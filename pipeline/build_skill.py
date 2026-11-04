#!/usr/bin/env python3
"""
从站点产物生成选型 skill 的数据快照。

输入 dist/data/scenarios.json（analyze.py 的产物），输出：
  <skill>/data/index.json        机器可读快照，供 scripts/query.py 查询
  <skill>/references/scenarios.md 人读的场景速查表

用法：
  python3 pipeline/build_skill.py                       # 写到默认 skill 目录
  python3 pipeline/build_skill.py --out /path/to/skill  # 指定目录
"""
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "dist" / "data" / "scenarios.json"
DEFAULT_OUT = Path.home() / ".workbuddy" / "skills" / "moonbit-stack-selection"
LIB_PREVIEW = 8          # 每个场景速查表里列出的基础库条数


def load():
    if not SRC.exists():
        raise SystemExit(f"缺少 {SRC}，先运行 python3 pipeline/analyze.py")
    return json.loads(SRC.read_text(encoding="utf-8"))


def build_index(d):
    mods = d["modules"]
    blurbs = d["blurbs"]
    out = []
    for sc in d["scenarios"]:
        sols = []
        for name in sc["sol"]:
            m = mods.get(name, ["", "", 0])
            zb, eb = blurbs.get(name, ["", ""])
            sols.append({
                "name": name,
                "version": m[0],
                "blurb": zb or m[1],
                "blurb_en": eb or m[1],
                "registry": m[1],
            })
        libs = []
        for name in sc["lib"][:LIB_PREVIEW]:
            m = mods.get(name, ["", "", 0])
            libs.append({"name": name, "version": m[0], "description": m[1]})
        out.append({
            "id": sc["id"],
            "group": sc["group"],
            "title": sc["title"],
            "intro": sc["intro"],
            "note": sc["note"],
            "solutions": sols,
            "libs": libs,
            "lib_count": len(sc["lib"]),
        })
    return {
        "meta": dict(d["meta"], source="https://moonbit-ecosystem-index.pages.dev",
                     generated_by="pipeline/build_skill.py"),
        "groups": d["groups"],
        "scenarios": out,
    }


def build_md(idx):
    L = ["# MoonBit 场景速查", ""]
    m = idx["meta"]
    L += [f"数据快照 {m['collected_at']} · {m['modules']} 个模块 · "
          f"{m['scenarios']} 个场景 · {m['with_solutions']} 个场景有完整方案 · "
          f"{m['solution_packages']} 个方案包", ""]
    L += ["「完整方案」= 能当骨架、替你做决定的库；「基础库」= 只提供单点能力。",
          "序号是场景内的推荐次序，不是下载量排行。", ""]

    titles = {g[0]: g[1][0] for g in idx["groups"]}
    for gid in [g[0] for g in idx["groups"]]:
        scenes = [s for s in idx["scenarios"] if s["group"] == gid]
        if not scenes:
            continue
        L += [f"## {titles.get(gid, gid)}", ""]
        for s in scenes:
            L += [f"### {s['title'][0]} `{s['id']}`", ""]
            if s["intro"][0]:
                L += [s["intro"][0] + "。" if not s["intro"][0].endswith("。") else s["intro"][0], ""]
            if s["solutions"]:
                L += ["完整方案：", ""]
                for x in s["solutions"]:
                    v = f" v{x['version']}" if x["version"] else ""
                    L += [f"- **`{x['name']}`**{v} — {x['blurb']}"]
            else:
                L += ["完整方案：**无**。该场景尚无骨架级实现，只能用基础库组合。"]
            L += [""]
            if s["lib_count"]:
                L += [f"基础库 {s['lib_count']} 个，前 {len(s['libs'])} 个：", ""]
                for x in s["libs"]:
                    L += [f"- `{x['name']}` — {(x['description'] or '—')[:90]}"]
                L += [""]
    return "\n".join(L)


def main():
    ap = argparse.ArgumentParser(description="生成选型 skill 的数据快照")
    ap.add_argument("--out", default=str(DEFAULT_OUT), help="skill 目录")
    args = ap.parse_args()

    out = Path(args.out).expanduser()
    (out / "data").mkdir(parents=True, exist_ok=True)
    (out / "references").mkdir(parents=True, exist_ok=True)

    idx = build_index(load())
    (out / "data" / "index.json").write_text(
        json.dumps(idx, ensure_ascii=False, indent=1), encoding="utf-8")
    md = build_md(idx)
    (out / "references" / "scenarios.md").write_text(md, encoding="utf-8")

    n_sol = sum(len(s["solutions"]) for s in idx["scenarios"])
    print(f"场景 {len(idx['scenarios'])} | 方案 {n_sol} | "
          f"index.json {(out/'data'/'index.json').stat().st_size // 1024} KB | "
          f"scenarios.md {len(md.splitlines())} 行")
    print(f"-> {out}")


if __name__ == "__main__":
    main()
