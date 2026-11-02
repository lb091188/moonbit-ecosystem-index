#!/usr/bin/env python3
"""
MoonBit 生态索引 · 场景化推荐查询

用法：
  python3 recommend.py --list                列出所有场景
  python3 recommend.py db                    按场景 id 查推荐
  python3 recommend.py "数据库"               按场景标题模糊匹配
  python3 recommend.py --search json         全量搜索模块（名字/描述/关键词）
  python3 recommend.py --search http --top 15
  python3 recommend.py --sql "select name,downloads from modules order by downloads desc limit 5"
"""

import argparse
import sqlite3
import sys
from pathlib import Path

DB = Path(__file__).resolve().parent.parent / "data" / "moonbit_index.db"


def fmt(n):
    n = int(n or 0)
    if n >= 10000:
        return f"{n / 10000:.1f}万"
    if n >= 1000:
        return f"{n / 1000:.1f}k"
    return str(n)


def conn():
    if not DB.exists():
        sys.exit(f"索引不存在：{DB}\n先运行：python3 build.py")
    return sqlite3.connect(DB)


def cmd_list(con):
    rows = con.execute("""
        SELECT s.scenario, s.title,
               SUM(CASE WHEN s.tier='framework' THEN 1 ELSE 0 END) AS fw,
               SUM(CASE WHEN s.tier='dep' THEN 1 ELSE 0 END) AS dep
        FROM scenarios s GROUP BY s.scenario, s.title
        ORDER BY MIN(s.rowid)
    """).fetchall()
    print(f"{'场景 id':<12}{'标题':<28}{'框架':>5}{'依赖':>6}")
    print("-" * 54)
    for sc, title, fw, dep in rows:
        flag = "" if fw else "  ← 本场景无框架"
        print(f"{sc:<12}{title:<28}{fw:>5}{dep:>6}{flag}")
    print("\n用 `python3 recommend.py <场景 id>` 查看框架；加 `--deps` 一并看依赖。")


def _print_rows(con, scenario, tier, top, header, indent=""):
    rows = con.execute("""
        SELECT s.rank, s.module, m.version, m.downloads, m.transitive,
               m.description, m.repository, ROUND(s.score, 2)
        FROM scenarios s JOIN modules m ON m.name = s.module
        WHERE s.scenario = ? AND s.tier = ? ORDER BY s.rank LIMIT ?
    """, (scenario, tier, top)).fetchall()
    total = con.execute("SELECT COUNT(*) FROM scenarios WHERE scenario=? AND tier=?",
                        (scenario, tier)).fetchone()[0]
    print(f"{indent}{header}（{total}）\n")
    if not rows:
        print(f"{indent}  —\n")
        return
    for rank, name, ver, dl, tr, desc, repo, score in rows:
        print(f"{indent}{rank:>2}. {name}  v{ver}")
        print(f"{indent}    下载 {fmt(dl)} · {tr} 反向依赖 · 匹配分 {score}"
              + (f" · {repo}" if repo else ""))
        if desc:
            print(f"{indent}    {desc[:150]}")
        print()
    if total > len(rows):
        print(f"{indent}  … 另有 {total - len(rows)} 个，用 --top {total} 看全\n")


def show_scenario(con, scenario, top, deps=False):
    row = con.execute("SELECT DISTINCT title FROM scenarios WHERE scenario=?", (scenario,)).fetchone()
    if not row:
        return False
    print(f"\n{row[0]}  ({scenario})")
    n_fw = con.execute("SELECT COUNT(*) FROM scenarios WHERE scenario=? AND tier='framework'",
                       (scenario,)).fetchone()[0]
    if n_fw:
        _print_rows(con, scenario, "framework", top, "【框架】定义程序结构，可直接选型")
    else:
        print("【框架】无 —— 这个场景没有框架级方案，只能拿零件自己组装\n")
    if deps:
        _print_rows(con, scenario, "dep", top, "【依赖 / 零件】配合框架使用")
    else:
        n_dep = con.execute("SELECT COUNT(*) FROM scenarios WHERE scenario=? AND tier='dep'",
                            (scenario,)).fetchone()[0]
        print(f"【依赖 / 零件】共 {n_dep} 个，加 --deps 查看\n")
    return True


def search_scenarios(con, text):
    rows = con.execute("""
        SELECT DISTINCT scenario, title FROM scenarios
        WHERE title LIKE ? OR scenario LIKE ?
    """, (f"%{text}%", f"%{text}%")).fetchall()
    return rows


def cmd_search(con, text, top):
    like = f"%{text}%"
    rows = con.execute("""
        SELECT name, version, downloads, transitive, description, repository
        FROM modules
        WHERE name LIKE ? OR description LIKE ? OR keywords LIKE ?
        ORDER BY downloads DESC LIMIT ?
    """, (like, like, like, top)).fetchall()
    print(f"\n搜索「{text}」：{len(rows)} 条（按下载量排序）\n")
    for name, ver, dl, tr, desc, repo in rows:
        print(f"  {name}  v{ver}  下载 {fmt(dl)} · {tr} 反向依赖")
        if desc:
            print(f"    {desc[:130]}")
    if not rows:
        print("  没有匹配结果，试试更宽的关键词。")


def main():
    ap = argparse.ArgumentParser(add_help=True, description="MoonBit 生态场景化推荐")
    ap.add_argument("query", nargs="?", help="场景 id / 标题关键词 / 搜索词")
    ap.add_argument("--list", action="store_true", help="列出所有场景")
    ap.add_argument("--search", metavar="TEXT", help="全量搜索模块")
    ap.add_argument("--deps", action="store_true", help="同时显示依赖 / 零件层")
    ap.add_argument("--top", type=int, default=8, help="每层返回条数（默认 8）")
    ap.add_argument("--sql", help="直接执行 SQL（只读）")
    args = ap.parse_args()

    con = conn()

    if args.list:
        cmd_list(con)
        return

    if args.sql:
        try:
            cur = con.execute(args.sql)
            cols = [d[0] for d in cur.description]
            print(" | ".join(cols))
            print("-" * 60)
            for r in cur.fetchall():
                print(" | ".join("" if v is None else str(v) for v in r))
        except sqlite3.Error as e:
            sys.exit(f"SQL 错误：{e}")
        return

    if args.search:
        cmd_search(con, args.search, args.top)
        return

    if not args.query:
        ap.print_help()
        return

    q = args.query.strip()
    if show_scenario(con, q, args.top, args.deps):
        return

    hits = search_scenarios(con, q)
    if len(hits) == 1:
        show_scenario(con, hits[0][0], args.top, args.deps)
        return
    if len(hits) > 1:
        print(f"「{q}」匹配到多个场景：")
        for sc, title in hits:
            print(f"  {sc:<12}{title}")
        print("\n请用场景 id 精确查询。")
        return

    # 不是场景名 → 退化为模块搜索
    cmd_search(con, q, args.top)


if __name__ == "__main__":
    main()
