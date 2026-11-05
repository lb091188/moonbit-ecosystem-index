#!/usr/bin/env python3
"""
【旧版工具链，仅留档】当前采集由 app/fetch.mbt 完成，见 docs/data.md。

MoonBit 生态索引 · 数据采集

两步，对应 docs/data.md「采集链路」：

  1. GET /api/v0/modules                    全量模块元数据 -> data/raw/modules_api.json
  2. GET /api/v0/search?kw=&limit=100       下载量           -> data/raw/downloads.json

搜索接口单次上限 100 条且不支持 offset，所以第 2 步按「owner 前缀」批量取：
同一个 owner 下的包通常不足 100 个，一次请求即可全拿；超过 100 个的 owner
（mizchi、moonbit-community 等）再按包名逐个补齐。仍未被覆盖的包名最后逐个精确检索。

用法：
  python3 pipeline/fetch.py                 # 全量采集
  python3 pipeline/fetch.py --skip-modules  # 只补下载量（复用已有 modules_api.json）
  python3 pipeline/fetch.py --workers 6     # 并发数，默认 8
"""
import argparse
import json
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

RAW = Path(__file__).resolve().parent.parent / "data" / "raw"
BASE = "https://mooncakes.io/api/v0"
UA = {"User-Agent": "moonbit-ecosystem-index/1.0 (+https://github.com/lb091188/moonbit-ecosystem-index)"}
LIMIT = 100          # 搜索接口单次上限
RETRY = 3


def get_json(url, timeout=180):
    last = None
    for i in range(RETRY):
        try:
            req = urllib.request.Request(url, headers=UA)
            with urllib.request.urlopen(req, timeout=timeout) as r:
                return json.loads(r.read().decode("utf-8"))
        except (urllib.error.URLError, TimeoutError, json.JSONDecodeError) as e:
            last = e
            time.sleep(1.5 * (i + 1))
    raise RuntimeError(f"{url} 失败：{last}")


def fetch_modules():
    print("① 拉取模块元数据 …", flush=True)
    data = get_json(f"{BASE}/modules", timeout=300)
    if not isinstance(data, list) or len(data) < 1000:
        sys.exit(f"模块接口返回异常：{type(data)} {len(data) if hasattr(data, '__len__') else ''}")
    RAW.mkdir(parents=True, exist_ok=True)
    (RAW / "modules_api.json").write_text(json.dumps(data, ensure_ascii=False), encoding="utf-8")
    print(f"   {len(data)} 个模块 -> data/raw/modules_api.json", flush=True)
    return data


def search(kw):
    q = urllib.parse.quote(kw, safe="")
    try:
        return get_json(f"{BASE}/search?kw={q}&limit={LIMIT}", timeout=60) or []
    except RuntimeError as e:
        print(f"   ! 跳过 {kw}：{e}", flush=True)
        return []


def harvest(rows, want, got):
    n = 0
    for r in rows:
        name = r.get("name")
        if name in want and name not in got:
            got[name] = {k: r.get(k) for k in
                         ("downloads", "created_at", "version", "is_new", "description")}
            n += 1
    return n


def fetch_downloads(modules, workers):
    want = {m["name"] for m in modules}
    owners = sorted({n.split("/")[0] for n in want})
    got = {}

    print(f"② 按 owner 批量取下载量（{len(owners)} 个 owner，并发 {workers}）…", flush=True)
    with ThreadPoolExecutor(max_workers=workers) as ex:
        for i, rows in enumerate(ex.map(search, owners), 1):
            harvest(rows, want, got)
            if i % 100 == 0:
                print(f"   {i}/{len(owners)} owner，已覆盖 {len(got)}/{len(want)}", flush=True)

    # 超过 100 个包的 owner，批量结果里必然有遗漏，按包名逐个补
    missing = sorted(want - set(got))
    print(f"③ 按包名补齐 {len(missing)} 个 …", flush=True)
    with ThreadPoolExecutor(max_workers=workers) as ex:
        for i, rows in enumerate(ex.map(search, missing), 1):
            harvest(rows, want, got)
            if i % 200 == 0:
                print(f"   {i}/{len(missing)}，已覆盖 {len(got)}/{len(want)}", flush=True)

    lost = sorted(want - set(got))
    RAW.mkdir(parents=True, exist_ok=True)
    (RAW / "downloads.json").write_text(json.dumps(got, ensure_ascii=False), encoding="utf-8")
    print(f"   写入 {len(got)}/{len(want)} -> data/raw/downloads.json", flush=True)
    if lost:
        print(f"   未取到下载量（{len(lost)}）：{', '.join(lost[:10])}"
              f"{' …' if len(lost) > 10 else ''}", flush=True)
    return got


def main():
    ap = argparse.ArgumentParser(description="采集 mooncakes 注册表数据")
    ap.add_argument("--skip-modules", action="store_true", help="复用已有 modules_api.json")
    ap.add_argument("--workers", type=int, default=8, help="并发数（默认 8）")
    args = ap.parse_args()

    if args.skip_modules:
        p = RAW / "modules_api.json"
        if not p.exists():
            sys.exit("没有 data/raw/modules_api.json，先跑一次完整采集")
        modules = json.loads(p.read_text())
        print(f"① 复用已有模块元数据（{len(modules)}）", flush=True)
    else:
        modules = fetch_modules()

    fetch_downloads(modules, max(1, args.workers))
    print("完成。接着把 pipeline/analyze.py 的 COLLECTED_AT 改成今天，再运行 analyze.py。")


if __name__ == "__main__":
    main()
