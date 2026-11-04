#!/usr/bin/env python3
"""数据编辑器：在浏览器里改场景与包简介，保存后直接落盘。

    python3 pipeline/editor.py            # 打开 http://127.0.0.1:8770
    python3 pipeline/editor.py --port 9000

它读写四份文件，都在 data/ 下：

    scenarios.src.json   场景定义（分组、标题、简介、筛选规则）
    i18n.json            场景的英文标题 / 简介 / 补充说明
    blurbs.json          完整方案的一句话简介（中英）
    scenarios.json       构建产物，只读，用来取「某场景下有哪些包」

编辑不碰构建逻辑：保存只写文件，点「重建」才运行 analyze.py。所以改坏了
可以用备份还原（data/.backup/ 下按时间留了最近 20 份），不会连锁损坏。

为什么不做成线上编辑：站点是纯静态托管，没有后端可写；而选包清单的改动
应该留痕在 git 里，本地改完再提交比从浏览器直接推仓库更可控。
"""

import argparse
import json
import os
import shutil
import subprocess
import sys
import threading
import time
import webbrowser
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / "data"
SRC = DATA / "scenarios.src.json"
I18N = DATA / "i18n.json"
BLURBS = DATA / "blurbs.json"
SITE = DATA / "scenarios.json"          # 构建产物，只读
BACKUP = DATA / ".backup"
PAGE = Path(__file__).with_name("editor.html")

BUILD_TIMEOUT = 600
KEEP_BACKUPS = 20

_lock = threading.Lock()                # 保存与重建互斥，避免读到写了一半的文件


# ---------------------------------------------------------------- 读写

def read_json(path, default=None):
    if not path.exists():
        return default
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path, obj):
    """原子写：先落临时文件再替换，构建进程不会读到半截 JSON。"""
    tmp = path.with_suffix(path.suffix + ".tmp")
    tmp.write_text(json.dumps(obj, ensure_ascii=False, indent=2) + "\n",
                   encoding="utf-8")
    os.replace(tmp, path)


def backup():
    """保存前把三份可编辑文件复制一份，按时间戳分目录。"""
    stamp = time.strftime("%Y%m%d-%H%M%S")
    dest = BACKUP / stamp
    dest.mkdir(parents=True, exist_ok=True)
    for p in (SRC, I18N, BLURBS):
        if p.exists():
            shutil.copy2(p, dest / p.name)
    olds = sorted(d for d in BACKUP.iterdir() if d.is_dir())
    for d in olds[:-KEEP_BACKUPS]:
        shutil.rmtree(d, ignore_errors=True)
    return stamp


def load_all():
    """把编辑器需要的全部内容拼成一份响应。"""
    src = read_json(SRC, {}) or {}
    i18n = read_json(I18N, {}) or {}
    blurbs = read_json(BLURBS, {}) or {}
    site = read_json(SITE, {}) or {}

    scenarios = src.get("scenarios") or []
    groups = src.get("groups") or []
    gtitle_en = {k: v for k, v in (i18n.get("groups") or {}).items()
                 if not k.startswith("_")}
    scenes_en = {k: v for k, v in (i18n.get("scenarios") or {}).items()
                 if not k.startswith("_")}

    sols, libs = {}, {}
    mods = site.get("modules") or {}
    for sc in site.get("scenarios") or []:
        sols[sc["id"]] = sc.get("sol") or []
        libs[sc["id"]] = sc.get("lib") or []

    # 只带场景里出现过的包的描述，避免把 3500 条元数据全塞进页面
    need = {n for names in sols.values() for n in names}
    need |= {n for names in libs.values() for n in names}
    desc = {}
    for n in need:
        m = mods.get(n)
        if m:
            desc[n] = [m[1] if len(m) > 1 else "",            # 描述
                       m[0] if m else "",                     # 版本
                       bool(m[2]) if len(m) > 2 else False]   # yanked

    return {
        "groups": [{"id": g["id"], "title": g["title"],
                    "title_en": gtitle_en.get(g["id"], "")} for g in groups],
        "scenarios": scenarios,
        "i18n": {"scenarios": scenes_en, "groups": gtitle_en},
        "blurbs": {k: v for k, v in blurbs.items() if not k.startswith("_")},
        "notes": {k: v for k, v in blurbs.items() if k.startswith("_")},
        "sols": sols,
        "libs": libs,
        "desc": desc,
        "meta": site.get("meta") or {},
        "paths": {"src": str(SRC.relative_to(ROOT)),
                  "i18n": str(I18N.relative_to(ROOT)),
                  "blurbs": str(BLURBS.relative_to(ROOT))},
    }


# ---------------------------------------------------------------- 保存

def validate(payload):
    """拦住会让构建直接失败的错误，逐条返回，前端一次列全。"""
    errs = []
    scenes = payload.get("scenarios") or []
    gids = [g["id"] for g in payload.get("groups") or []]
    seen = set()
    for sc in scenes:
        sid = (sc.get("id") or "").strip()
        if not sid:
            errs.append("有场景缺 id")
            continue
        if sid in seen:
            errs.append(f"场景 id 重复：{sid}")
        seen.add(sid)
        if not (sc.get("title") or "").strip():
            errs.append(f"{sid}：中文标题为空")
        if sc.get("group") not in gids:
            errs.append(f"{sid}：分组「{sc.get('group')}」不存在")
        en = (payload.get("i18n", {}).get("scenarios", {}) or {}).get(sid) or {}
        for k, label in (("title", "英文标题"), ("intro", "英文简介")):
            if not (en.get(k) or "").strip():
                errs.append(f"{sid}：{label}为空（构建会失败）")
        if (sc.get("note") or "").strip() and not (en.get("note") or "").strip():
            errs.append(f"{sid}：有中文补充说明但缺英文（构建会失败）")
    return errs


def save(payload):
    with _lock:
        errs = validate(payload)
        if errs:
            return {"ok": False, "error": "；".join(errs[:6]), "detail": errs}

        stamp = backup()

        # 场景源文件：保留文件头部的说明与字段注释
        src = read_json(SRC, {}) or {}
        src["groups"] = [{"id": g["id"], "title": g["title"]}
                         for g in payload.get("groups") or []]
        src["scenarios"] = payload.get("scenarios") or []
        write_json(SRC, src)

        # 英文：按场景 id 顺序重排，去掉已删场景的残留
        old_i18n = read_json(I18N, {}) or {}
        scenes_en = {}
        for sc in src["scenarios"]:
            en = (payload.get("i18n", {}).get("scenarios", {}) or {}).get(sc["id"]) or {}
            item = {"title": (en.get("title") or "").strip(),
                    "intro": (en.get("intro") or "").strip()}
            if (en.get("note") or "").strip():
                item["note"] = en["note"].strip()
            scenes_en[sc["id"]] = item
        new_i18n = {k: v for k, v in old_i18n.items() if k.startswith("_")}
        new_i18n["groups"] = {g["id"]: (g.get("title_en") or "").strip()
                              for g in src["groups"]}
        new_i18n["scenarios"] = scenes_en
        write_json(I18N, new_i18n)

        # 简介：保留原有的下划线注记；条目按原文件顺序回写，新包追加到末尾，
        # 这样编辑器的保存不会把整份文件的行序打乱、制造无意义 diff
        old_blurbs = read_json(BLURBS, {}) or {}
        new_blurbs = payload.get("blurbs") or {}
        out = {k: v for k, v in old_blurbs.items() if k.startswith("_")}
        for name, val in old_blurbs.items():
            if name.startswith("_"):
                continue
            val = new_blurbs.get(name, val)
            if isinstance(val, list) and len(val) == 2:
                zh, en = (val[0] or "").strip(), (val[1] or "").strip()
                if zh or en:
                    out[name] = [zh, en]
        for name, val in new_blurbs.items():
            if name in old_blurbs or name.startswith("_"):
                continue
            if isinstance(val, list) and len(val) == 2:
                zh, en = (val[0] or "").strip(), (val[1] or "").strip()
                if zh or en:
                    out[name] = [zh, en]
        write_json(BLURBS, out)

        return {"ok": True, "backup": stamp,
                "counts": {"scenarios": len(src["scenarios"]),
                           "blurbs": len([k for k in out if not k.startswith("_")])}}


def build():
    """跑一次构建，返回日志尾部。构建失败不抛异常，交给前端显示。"""
    with _lock:
        t0 = time.time()
        try:
            p = subprocess.run([sys.executable, str(ROOT / "pipeline" / "analyze.py")],
                               cwd=str(ROOT), capture_output=True, text=True,
                               timeout=BUILD_TIMEOUT)
            log = (p.stdout or "") + (p.stderr or "")
            ok = p.returncode == 0
        except subprocess.TimeoutExpired:
            return {"ok": False, "log": f"构建超过 {BUILD_TIMEOUT} 秒，已放弃", "secs": 0}
        lines = [ln for ln in log.strip().splitlines() if ln.strip()]
        return {"ok": ok, "secs": round(time.time() - t0, 1),
                "log": "\n".join(lines[-40:]),
                "meta": (read_json(SITE, {}) or {}).get("meta") or {}}


# ---------------------------------------------------------------- HTTP

class Handler(BaseHTTPRequestHandler):
    server_version = "MoonBitIndexEditor"

    def log_message(self, fmt, *args):
        if self.path.startswith("/api/"):
            sys.stderr.write("  %s %s\n" % (self.command, self.path))

    def _send(self, code, body, ctype="application/json; charset=utf-8"):
        data = body if isinstance(body, bytes) else body.encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(data)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        if self.path in ("/", "/index.html"):
            self._send(200, PAGE.read_bytes(), "text/html; charset=utf-8")
        elif self.path.startswith("/api/data"):
            try:
                self._send(200, json.dumps(load_all(), ensure_ascii=False))
            except Exception as e:            # 数据文件写坏时不要让页面白屏
                self._send(500, json.dumps({"error": str(e)}, ensure_ascii=False))
        else:
            self._send(404, json.dumps({"error": "not found"}))

    def do_POST(self):
        n = int(self.headers.get("Content-Length") or 0)
        try:
            payload = json.loads(self.rfile.read(n) or b"{}")
        except json.JSONDecodeError as e:
            return self._send(400, json.dumps({"ok": False, "error": f"请求不是合法 JSON：{e}"}))

        if self.path.startswith("/api/save"):
            try:
                res = save(payload)
            except Exception as e:
                res = {"ok": False, "error": f"{type(e).__name__}: {e}"}
            self._send(200 if res.get("ok") else 400, json.dumps(res, ensure_ascii=False))
        elif self.path.startswith("/api/build"):
            self._send(200, json.dumps(build(), ensure_ascii=False))
        else:
            self._send(404, json.dumps({"error": "not found"}))


def main():
    ap = argparse.ArgumentParser(description="在浏览器里编辑场景与包简介")
    ap.add_argument("--port", type=int, default=8770)
    ap.add_argument("--host", default="127.0.0.1")
    ap.add_argument("--no-open", action="store_true", help="不自动打开浏览器")
    args = ap.parse_args()

    if not PAGE.exists():
        raise SystemExit(f"缺少 {PAGE}")
    if not SRC.exists():
        raise SystemExit(f"缺少 {SRC}，先运行一次 pipeline/analyze.py")

    url = f"http://{args.host}:{args.port}/"
    srv = ThreadingHTTPServer((args.host, args.port), Handler)
    print(f"编辑器已启动：{url}")
    print(f"数据文件：{SRC.relative_to(ROOT)} / {I18N.relative_to(ROOT)} / {BLURBS.relative_to(ROOT)}")
    print("保存后点「重建」生成站点，或 Ctrl+C 退出")
    if not args.no_open:
        threading.Timer(0.6, lambda: webbrowser.open(url)).start()
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        print("\n已退出")
    finally:
        srv.server_close()


if __name__ == "__main__":
    main()
