#!/usr/bin/env python3
"""
MoonBit 生态索引 · 场景化查询

用法：
  python3 pipeline/query.py --list                 列出全部场景
  python3 pipeline/query.py mobi                   按场景 id 查完整方案
  python3 pipeline/query.py "移动端"               按场景标题模糊匹配
  python3 pipeline/query.py gui --libs             连基础库一起看
  python3 pipeline/query.py --search json          全量检索模块（名称/描述/关键词）
  python3 pipeline/query.py --sql "select name,downloads from modules order by downloads desc limit 5"

本工具只读索引库，不做任何写操作。包的版本历史、API 文档与依赖关系请到
mooncakes 包页查看，输出里每个包都带有该页地址。
"""
import argparse
import sqlite3
import sys
from pathlib import Path

DB = Path(__file__).resolve().parent.parent / "data" / "moonbit_index.db"
MK = "https://mooncakes.io/docs/"


def fmt(n):
    n = int(n or 0)
    if n >= 10000:
        return f"{n / 10000:.1f}万"
    if n >= 1000:
        return f"{n / 1000:.1f}k"
    return str(n)


def conn():
    if not DB.exists():
        sys.exit(f"索引不存在：{DB}\n先运行：python3 pipeline/analyze.py")
    return sqlite3.connect(DB)


def cmd_list(con):
    rows = con.execute("""
        SELECT s.scenario, s.title,
               SUM(CASE WHEN s.tier='solution' THEN 1 ELSE 0 END) AS sol,
               SUM(CASE WHEN s.tier='lib' THEN 1 ELSE 0 END) AS lib
        FROM scenarios s GROUP BY s.scenario, s.title
        ORDER BY MIN(s.rowid)
    """).fetchall()
    print(f"{'场景 id':<12}{'标题':<30}{'完整方案':>9}{'基础库':>8}")
    print("-" * 59)
    for sc, title, sol, lib in rows:
        flag = "" if sol else "  ← 尚无完整方案"
        print(f"{sc:<12}{title:<30}{sol:>9}{lib:>8}{flag}")
    print(f"\n共 {len(rows)} 个场景。"
          f"用 `python3 pipeline/query.py <场景 id>` 查看；加 `--libs` 一并看基础库。")


def _print_rows(con, scenario, tier, top, header):
    rows = con.execute("""
        SELECT s.rank, s.module, m.version, m.downloads, m.description, ROUND(s.score, 2)
        FROM scenarios s JOIN modules m ON m.name = s.module
        WHERE s.scenario = ? AND s.tier = ? ORDER BY s.rank LIMIT ?
    """, (scenario, tier, top)).fetchall()
    total = con.execute("SELECT COUNT(*) FROM scenarios WHERE scenario=? AND tier=?",
                        (scenario, tier)).fetchone()[0]
    print(f"{header}（{total}）\n")
    if not rows:
        print("  —\n")
        return
    for rank, name, ver, dl, desc, score in rows:
        print(f"  {rank:>2}. {name}  v{ver}   下载 {fmt(dl)}   匹配分 {score}")
        print(f"      {MK}{name}")
        if desc:
            print(f"      {desc[:150]}")
        print()
    if total > len(rows):
        print(f"  … 另有 {total - len(rows)} 个，用 --top {total} 看全\n")


def show_scenario(con, scenario, top, libs=False):
    row = con.execute("SELECT DISTINCT title FROM scenarios WHERE scenario=?",
                      (scenario,)).fetchone()
    if not row:
        return False
    print(f"\n【{row[0]}】  ({scenario})")
    n_sol = con.execute("SELECT COUNT(*) FROM scenarios WHERE scenario=? AND tier='solution'",
                        (scenario,)).fetchone()[0]
    if n_sol:
        _print_rows(con, scenario, "solution", top, "完整方案 · 可直接选型、承担程序骨架")
    else:
        print("完整方案 · 无 —— 该场景尚无骨架，只能由基础库组合实现\n")
    if libs:
        _print_rows(con, scenario, "lib", top, "基础库 · 提供单点能力，由调用方组合")
    else:
        n_lib = con.execute("SELECT COUNT(*) FROM scenarios WHERE scenario=? AND tier='lib'",
                            (scenario,)).fetchone()[0]
        print(f"基础库 · 共 {n_lib} 个，加 --libs 查看\n")
    return True


def search_scenarios(con, text):
    return con.execute("""
        SELECT DISTINCT scenario, title FROM scenarios
        WHERE title LIKE ? OR scenario LIKE ?
    """, (f"%{text}%", f"%{text}%")).fetchall()


def cmd_search(con, text, top):
    like = f"%{text}%"
    rows = con.execute("""
        SELECT name, version, downloads, description, yanked
        FROM modules
        WHERE name LIKE ? OR description LIKE ? OR keywords LIKE ?
        ORDER BY downloads DESC LIMIT ?
    """, (like, like, like, top)).fetchall()
    print(f"\n检索「{text}」：共 {len(rows)} 条（按下载量降序）\n")
    for name, ver, dl, desc, yanked in rows:
        mark = "  [yanked]" if yanked else ""
        print(f"  {name}  v{ver}   下载 {fmt(dl)}{mark}")
        print(f"      {MK}{name}")
        if desc:
            print(f"      {desc[:130]}")
    if not rows:
        print("  没有匹配结果，试试更宽的关键词。")


def main():
    ap = argparse.ArgumentParser(description="MoonBit 生态场景化索引查询")
    ap.add_argument("query", nargs="?", help="场景 id / 标题关键词 / 检索词")
    ap.add_argument("--list", action="store_true", help="列出全部场景")
    ap.add_argument("--search", metavar="TEXT", help="全量检索模块")
    ap.add_argument("--libs", action="store_true", help="同时显示基础库层")
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
    if show_scenario(con, q, args.top, args.libs):
        return

    hits = search_scenarios(con, q)
    if len(hits) == 1:
        show_scenario(con, hits[0][0], args.top, args.libs)
        return
    if len(hits) > 1:
        print(f"「{q}」匹配到多个场景：")
        for sc, title in hits:
            print(f"  {sc:<12}{title}")
        print("\n请用场景 id 精确查询。")
        return

    cmd_search(con, q, args.top)


if __name__ == "__main__":
    main()
