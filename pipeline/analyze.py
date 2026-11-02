#!/usr/bin/env python3
"""
构建 MoonBit 生态索引，并生成「不同场景下的包推荐」。

数据来源（全部为公开数据，已落盘到 data/raw/）：
  1. modules_api.json   mooncakes.io /api/v0/modules        全量模块元数据（3520）
  2. downloads.json      mooncakes.io /api/v0/search         每个模块的下载量（3518）
  3. metrics.tsv         gaato/mooncakes-graph 每日快照      每个模块的直接/传递反向依赖数
  4. versions.jsonl      gaato/mooncakes-graph              每个已发布版本的记录

输出：
  data/modules.json          合并后的模块表
  data/moonbit_index.db      SQLite 索引（modules / scenarios 两张表）
  scenarios.md               场景推荐报告（中文）
  index.html                 可浏览的场景推荐页
"""

import csv
import datetime
import html
import json
import math
import re
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / "data" / "raw"
OUT = ROOT / "data"
DIST = ROOT / "dist"          # 静态发布目录（Cloudflare Pages / 任意静态托管）
OUT.mkdir(parents=True, exist_ok=True)

TOKEN = re.compile(r"[a-z0-9]+")


def _fix_url(u):
    """注册表里有些仓库地址缺 scheme（github.com/x/y），补成 https:// 才能点。"""
    u = (u or "").strip()
    if u and not u.startswith(("http://", "https://")):
        return "https://" + u.lstrip("/")
    return u

# ---------------------------------------------------------------- 数据合并

def load_modules():
    api = json.loads((RAW / "modules_api.json").read_text())
    dl = json.loads((RAW / "downloads.json").read_text())
    metrics = {}
    with (RAW / "metrics.tsv").open() as f:
        for row in csv.DictReader(f, delimiter="\t"):
            name = (row.get("module") or row.get("\ufeffmodule") or "").strip()
            if not name:
                continue
            metrics[name] = (
                int(row.get("direct") or 0),
                int(row.get("transitive") or 0),
                int(row.get("owners") or 0),
            )

    mods = {}
    for m in api:
        name = m["name"]
        d = dl.get(name, {})
        direct, transitive, owners = metrics.get(name, (0, 0, 0))
        desc = (m.get("description") or d.get("description") or "").strip()
        keywords = [k.lower() for k in (m.get("keywords") or [])]
        mods[name] = {
            "name": name,
            "version": m.get("version") or d.get("version") or "",
            "downloads": int(d.get("downloads") or 0),
            "direct": direct,
            "transitive": transitive,
            "owners": owners,
            "license": m.get("license") or "",
            "repository": _fix_url(m.get("repository") or ""),
            "keywords": keywords,
            "description": desc,
            "created_at": (m.get("created_at") or d.get("created_at") or "")[:10],
            "is_new": bool(m.get("is_new")),
            "yanked": bool(m.get("yanked")),
        }
        mods[name]["_kw"] = set(keywords)
        mods[name]["_ntok"] = set(TOKEN.findall(name.lower().split("/")[-1]))
        mods[name]["_dtok"] = set(TOKEN.findall(desc.lower()))
        mods[name]["_desc_l"] = desc.lower()
    return mods


# ---------------------------------------------------------------- 场景定义
# kw   : 命中 keywords / 模块名的词（权重最高）
# desc : 需要出现在描述里的短语
# ex   : 命中即排除的词（用于压掉同名不同义的噪声）

SCENARIOS = [
    dict(id="http", title="Web 后端 / HTTP 服务", icon="🌐",
         intro="HTTP 服务、路由、中间件与后端 API 开发。",
         kw=["http", "server", "web", "router", "api", "rest", "backend"],
         desc=["http server", "web framework", "router", "backend framework"],
         ex=["compatibility", "ui", "frontend", "tea", "desktop-app", "gui"],
         pin=["moonbitlang/moonback"]),
    dict(id="json", title="JSON / 序列化格式", icon="🧾",
         intro="JSON、YAML、TOML、XML、CBOR 等格式的解析与生成。",
         kw=["json", "serialization", "serde", "yaml", "toml", "csv", "xml", "cbor"],
         desc=["serializ", "data format"], ex=[]),
    dict(id="async", title="异步 / 并发", icon="⚡",
         intro="async 运行时、协程、并发原语、任务调度。",
         kw=["async", "concurrency", "coroutine", "future", "promise", "thread", "parallel"],
         desc=["asynchronous", "concurren"], ex=[]),
    dict(id="cli", title="CLI 参数解析", icon="⌨️",
         intro="命令行工具的参数、子命令、帮助信息解析。",
         kw=["cli", "argparse", "command-line", "args", "argument-parser", "docopt", "argv"],
         desc=["command line", "argument parser", "argument-parser"],
         ex=["tui", "terminal", "browser"]),
    dict(id="tui", title="终端 UI / TUI", icon="🖥️",
         intro="终端界面、字符画布、ANSI 控制、PTY。",
         kw=["tui", "terminal", "ansi", "console", "pty", "curses"],
         desc=["terminal ui", "terminal"], ex=[]),
    dict(id="test", title="测试 / 断言 / 属性测试", icon="🧪",
         intro="单元测试、属性测试（quickcheck）、断言库、BDD、基准。",
         kw=["testing", "test", "property", "benchmark", "quickcheck", "fuzz", "assert", "mock"],
         desc=["test framework", "property-based", "assertion"], ex=["image", "pixel"]),
    dict(id="regex", title="正则匹配", icon="🔍",
         intro="正则表达式引擎与匹配。",
         kw=["regex", "regexp", "regular-expression"],
         desc=["regular expression"], ex=[]),
    dict(id="unicode", title="Unicode / 文本处理", icon="🔤",
         intro="Unicode 分类、字素簇、宽度计算、字符串工具。",
         kw=["unicode", "grapheme", "string", "text", "width", "collation"],
         desc=["unicode", "grapheme"], ex=[]),
    dict(id="crypto", title="加密 / 哈希 / 编码", icon="🔐",
         intro="哈希、对称加密、Base64/编码、安全相关。",
         kw=["crypto", "hash", "sha256", "sha512", "aes", "encoding", "base64", "security", "bcrypt", "hmac"],
         desc=["cryptograph", "hashing"], ex=["simd"]),
    dict(id="db", title="数据库 / 存储", icon="🗄️",
         intro="SQLite 绑定、ORM、KV 存储、迁移工具。",
         kw=["database", "sqlite", "sql", "storage", "kv", "orm", "postgres", "migration"],
         desc=["database", "storage engine", "key-value"],
         pin=["mizchi/sqlite", "moonbitstack/moonsqlite"]),
    dict(id="wasm", title="WebAssembly / JS 互操作", icon="🧩",
         intro="Wasm 组件模型、WASI、FFI、JS 绑定。",
         kw=["wasm", "wasi", "ffi", "javascript", "webassembly", "component-model"],
         desc=["webassembly", "component model"], ex=[]),
    dict(id="parser", title="解析器 / 编译器 / 语法", icon="🌳",
         intro="词法、语法、parser combinator、AST、tree-sitter、parser generator。",
         kw=["parser", "lexer", "compiler", "grammar", "tree-sitter", "ast", "codegen"],
         desc=["parser", "compiler", "lexer", "interpreter"], ex=[]),
    dict(id="math", title="数学 / 数值计算", icon="📐",
         intro="高精度数学、线性代数、矩阵、BLAS、统计。",
         kw=["math", "numeric", "linear-algebra", "matrix", "statistics", "bigint", "blas", "arithmetic"],
         desc=["linear algebra", "numeric", "arbitrary precision"], ex=[]),
    dict(id="graphics", title="图形 / 渲染", icon="🎨",
         intro="矢量图形、SVG、场景图、绘图与布局。",
         kw=["graphics", "rendering", "svg", "canvas", "scene-graph", "vector", "drawing"],
         desc=["rendering", "vector graphics", "scene graph"], ex=[]),
    dict(id="game", title="游戏引擎 / ECS", icon="🎮",
         intro="游戏引擎、ECS 架构、程序化生成、游戏后端。",
         kw=["game", "engine", "ecs", "gamedev", "sprite"],
         desc=["game engine", "game"], ex=[]),
    dict(id="ui", title="Web UI / 前端框架", icon="🪟",
         intro="浏览器里的 UI 框架、响应式状态、组件、布局与 CSS。",
         kw=["ui", "component", "dom", "frontend", "css", "reactive", "signals"],
         desc=["user interface", "component", "frontend"],
         ex=["terminal", "tui", "component-model"],   # component-model 是 wasm 组件模型，不是 UI 组件
         pin=["moonbit-community/rabbita"]),
    # 桌面 GUI：生态里没有统一的 "desktop gui" 关键词，靠 core 门控——
    # 必须命中真正的窗口/渲染/控件绑定词，光有 desktop/native 的插件包不算。
    dict(id="gui", title="桌面 GUI / 跨平台窗口", icon="🪟",
         intro="原生桌面应用开发：窗口创建、事件循环、控件布局与渲染后端接入。"
               "Proton 的托盘、剪贴板、全局热键等配套模块不计入本表，检索 “proton” 可见全套。",
         kw=["gui", "windowing", "window", "renderer", "widget", "native-gui", "desktop", "tray"],
         desc=["desktop", "native window", "window system", "windowing", "gui framework",
               "cross-platform gui"],
         core=["gui", "windowing", "winit", "webview", "gtk", "qt", "sdl", "sdl3", "glfw",
               "skia", "immediate-mode", "imgui", "egui", "native-gui", "appkit", "webgpu",
               "wgpu", "wayland", "cocoa", "framebuffer"],
         ex=["graphql", "game engine"],
         ex_desc=["event-time", "watermark", "graphql", "audit", "cucumber"],
         pin=["wzzc-dev/moui", "moonbit-community/proton"],
         # 框架级包（一事全包：窗口+控件+系统能力）优先于单一绑定，
         # 否则新发布的框架会被 2 万下载的老绑定压在十几名开外。
         boost={"wzzc-dev/moui": 2.0, "NoahLiu/native-gui": 3.0}, top=10,
         ex_prefix=["wzzc-dev/moui_"]),
    # 注：Yoorkin/rabbit-tea（TEA 旧实现，4.7k 下载）已被 yanked，故不在候选内。
# 跨端 UI：关键词层面根本不存在（没人打 cross-end 标签），只能人工圈定。
    dict(id="xui", title="跨端 UI（一套代码多端）", icon="📱",
         intro="以同一套 UI 代码覆盖 Web、桌面、移动端与小程序。候选清单为人工圈定："
               "生态中尚无统一的跨端关键词，上述目标的实现需组合多个包方成立。",
         kw=["cross-platform", "mobile", "android", "ios", "webview", "tea", "vdom", "ui"],
         desc=["one codebase", "android", "ios", "multi-platform", "cross-platform", "desktop and web"],
         ex_desc=["cross-platform native clipboard", "cross-platform auto-launch",
                  "cross-platform native global hotkey", "cross-platform native tray",
                  "cross-platform path"],
         curated=True, top=12,
         pick=[
             "moonbit-community/rabbita",        # Web 端 UI 主体（TEA / vdom）
             "moonbit-community/proton",         # 桌面端宿主（webview + 原生外壳）
             "moonbit-community/proton_rabbita", # 把 rabbita 的 cmd/sub 接到原生契约
             "wzzc-dev/moui",                    # 自绘框架：桌面 / Web / 终端共用一套语义树
             "wzzc-dev/window",                  # 窗口层，桌面 / Web / 移动三后端
             "XiLaiTL/moobile",                  # 移动端：Android / iOS / Web 一套 rabbita
             "moonbit-community/rabbita_tui",    # 终端端：同一个 TEA 应用跑原生 TUI
             "lampclaw/minimoon",                # 微信小程序 Skyline 端
             "vectie/lepusa",                    # 桌面 webview 应用框架
             "helios-house/valence",             # dual-render 尝试
             "marianoguerra/tutuca",             # vdom + app runtime 的完整实现
         ]),
    dict(id="doc", title="Markdown / 文档转换", icon="📄",
         intro="Markdown 解析、HTML/PDF/DOCX 转换、文档排版。",
         kw=["markdown", "html", "pdf", "document", "epub", "asciidoc", "docx", "latex"],
         desc=["markdown", "pdf", "document"], ex=["font", "ui", "framework", "tea"]),
    dict(id="time", title="时间 / 日期", icon="🕒",
         intro="日期时间、时区、RFC3339、cron。",
         kw=["time", "date", "datetime", "timezone", "tzif", "cron", "duration"],
         desc=["timezone", "date and time"], ex=[]),
    dict(id="log", title="日志 / 追踪", icon="📝",
         intro="结构化日志、tracing、OpenTelemetry、指标。",
         kw=["logging", "tracing", "log", "telemetry", "otel", "metrics", "observability"],
         desc=["logging", "tracing", "observability"], ex=["font"]),
    dict(id="net", title="网络 / 协议", icon="🔌",
         intro="TCP/UDP、WebSocket、MQTT、HTTP 协议栈、TLS。",
         kw=["network", "tcp", "udp", "websocket", "protocol", "streaming", "mqtt", "amqp", "socket", "tls"],
         desc=["network protocol", "websocket", "socket"],
         ex=["compatibility", "git", "json", "jsonl", "cucumber", "codec"],
         pin=["moonbitstack/moonnet", "moonbitstack/moonhttp"]),
    dict(id="llm", title="LLM / Agent / MCP", icon="🤖",
         intro="大模型客户端、Agent 框架、MCP 服务端/客户端、提示词。",
         kw=["llm", "agent", "mcp", "openai", "embedding", "prompt"],
         desc=["language model", "llm", "agent"], ex=["wasi", "io"]),
    dict(id="img", title="图像 / 媒体", icon="🖼️",
         intro="图像编解码（PNG/JPEG/GIF/BMP）、像素比较、音视频。",
         kw=["image", "png", "jpeg", "gif", "bmp", "qoi", "audio", "video", "codec", "svg"],
         desc=["image", "codec", "audio", "video"], ex=[]),
    dict(id="ds", title="数据结构 / 算法", icon="🧱",
         intro="有序映射、B 树、堆、图算法、集合。",
         kw=["data-structure", "collection", "map", "set", "heap", "graph", "queue", "btree", "indexmap"],
         desc=["data structure", "algorithm"], ex=["syntax", "svg", "compatibility", "grapheme"]),
]

MIN_DOWNLOADS = 20   # 只推荐下载量 > 20 的包

# 数据快照时间。本索引为离线快照，不随时间自动更新，务必与构建时间一并披露。
META_SNAPSHOT = "2026-11-02"   # 模块元数据与下载量（mooncakes.io 官方 API）
GRAPH_SNAPSHOT = "2026-11-01"  # 反向依赖数（gaato/mooncakes-graph 每日快照）


# ---------------------------------------------------------------- 层级：完整方案 / 基础库
# 判定原则（不是按下载量、也不是按"厉不厉害"）：
#   完整方案 = 能直接选型的东西：它**定义你的程序结构**，你往里填空（路由表、组件树、
#              事件循环、ECS、数据访问层、命令行树、语法 DSL、测试用例容器…）。
#              "框架""引擎""运行时""脚手架""ORM"都是它的不同形态，本质都是同一件事：
#              一套完整的、能直接开箱搭项目的方案。
#   基础库   = 它**提供一个单点能力**，你调用它（解析、编码、哈希、绑定、数据结构、
#              某个协议/格式的实现）
# 术语注意：「基础库」不等于「依赖」。在 mooncakes 里所有包都是依赖（moon.mod.json
# 的 deps 里装的是全部，框架同样是依赖），所以拿 deps 当"方案"的反义词在定义上就是错的。
# 分层看的只有一件事：它能不能接管程序结构，不是它装不装进 deps。
# 因此 binding（gtk / glfw / sqlite）都是基础库：它们不接管你的程序结构，
# 完整方案是长在它们上面的那层（giraffe 之于 gtk、proton 之于 webview）。
SOLUTIONS = {
    "http": ["moonbitlang/moonback", "mizchi/mars", "oboard/mocket", "bobzhang/crescent",
             "moonbitstack/moonapi", "jaredzhou/pony", "RabitLogic/mbit", "KKKIIO/moondark",
             "moonbitstack/moonzero", "daqing/moonway", "wflixu/Halo", "kupas/express",
             "anccnuer/onho"],
    "json": ["Yu-zh/data"],          # 生态里唯一的序列化框架（serde 式：定义一次数据模型，多格式）
    "async": ["moonbitlang/async", "peter-jerry-ye/async", "didiLjf/moonorbit", "kalculos/miao"],
    "cli": ["Yoorkin/ArgParser", "mizchi/admiral", "totto2727/admiral", "TheWaWaR/clap"],
    "tui": ["mizchi/tui", "moonbit-community/rabbita_tui", "moonbitstack/moonetui",
            "brickfrog/pippa", "Frank-III/onebit-tui"],
    "test": ["moonbitlang/quickcheck", "moonrockz/moonspec", "aspnmy/moonitest",
             "Duckweed/moon-proof"],
    "db": ["moonbitstack/moondb", "moonbitstack/moonorm", "oboard/morm", "wflixu/Orion",
           "zen314/shadow"],
    "wasm": ["Milky2018/wasmoon"],
    "parser": ["moonbitlang/yacc", "cogna-dev/parkit"],
    "game": ["Milky2018/selene", "mizchi/kagura", "sennenki/reisen", "sacckey/moon8bit",
             "sssssurf/abyssal_chord", "firefly/firefly"],
    "ui": ["moonbit-community/rabbita", "mizchi/luna", "marianoguerra/tutuca",
           "Arcelyth/aitne", "lampclaw/minimoon", "vectie/bunnia"],
    "gui": ["moonbit-community/proton", "wzzc-dev/moui", "NoahLiu/native-gui",
            "vectie/lepusa", "lepus-apps/webview", "tonyfettes/giraffe"],
    "xui": ["moonbit-community/rabbita", "wzzc-dev/moui", "moonbit-community/proton",
            "lampclaw/minimoon"],
    "llm": ["colmugx/posoco", "colmugx/mcp", "golemcloud/golem_sdk", "soehi/moonlm",
            "weopqrst/agent"],
    # 这些场景在生态里**没有任何完整方案**，全是基础库：按需要挑，别指望有个骨架
    # json 之外：regex / unicode / crypto / math / graphics / doc / time / img / ds / net / log
}

# 名字里带 "framework" 但实际只是基础库或接口规范的，禁止被兜底规则抬成方案
SOL_DENY = {
    "moonbitstack/moonasgi",          # 描述是 "interface between servers and frameworks"
    "moonrockz/moon-lander-logging",  # 是 Moon-Lander 框架的日志组件
    "mizchi/crater",                  # CSS 布局引擎，不是 UI 框架
}

SOL_WORDS = ("framework", "full-stack", "all-in-one")
LIB_WORDS = ("binding", "bindings", "wrapper", "port of", "client for", "client library",
             "implementation of", "primitives", "codec", "encoder", "decoder", "sub-module")


def tier_of(mod, sc):
    """返回 'solution' 或 'lib'。

    只认白名单：方案槽是高精度区，宁可漏也不能把基础库混进来当"推荐"。新发布的
    方案在 build 时会被打印成「待确认」，人工看一眼加进 SOLUTIONS 即可。
    """
    if mod["name"] in SOLUTIONS.get(sc["id"], ()):
        return "solution"
    return "lib"


# ---------------------------------------------------------------- 打分

def _hit(term, tokens):
    if len(term) >= 4 and any(t.startswith(term) for t in tokens):
        return True
    return term in tokens


def _kw_hit(term, mod):
    """关键词命中：支持 "desktop" 命中 "desktop-app" 这类前缀变形。"""
    if term in mod["_kw"]:
        return True
    if len(term) >= 4 and any(k.startswith(term) for k in mod["_kw"]):
        return True
    return False


def relevance(mod, sc):
    if mod["yanked"]:
        return None
    # core 门控：必须命中真正的领域词，避免只带 "desktop"/"native" 的外围包混进来
    core = sc.get("core")
    if core and not any(_kw_hit(t, mod) or _hit(t, mod["_ntok"]) or _hit(t, mod["_dtok"])
                        for t in core):
        return None
    if any(x in mod["_desc_l"] for x in sc.get("ex_desc", ())):
        return None
    # 排除某框架的内部子包（主包已代表该路线，子渲染器/adapter 只会占位）
    if any(mod["name"].startswith(pfx) for pfx in sc.get("ex_prefix", ())):
        return None
    rel = 0.0
    for t in sc["kw"]:
        if _kw_hit(t, mod):
            rel += 3
        elif _hit(t, mod["_ntok"]):
            rel += 2
        elif _hit(t, mod["_dtok"]):
            rel += 1
    for t in sc["desc"]:
        if " " in t:
            if t in mod["_desc_l"]:
                rel += 1.5
        elif _hit(t, mod["_dtok"]):
            rel += 1.2
    for t in sc.get("ex", []):
        if t in mod["_kw"] or _hit(t, mod["_ntok"]):
            return None
    if rel < 3 or mod["downloads"] < MIN_DOWNLOADS:
        return None
    return rel


def score(mod, sc):
    rel = relevance(mod, sc)
    if rel is None:
        return None
    s = (min(rel, 6) * 1.0
         + math.log1p(mod["downloads"]) * 1.05
         + math.log1p(mod["transitive"]) * 0.55)
    if mod["name"] in sc.get("pin", ()):
        s += 1.2          # 少量人工置顶：算法排名不理想时兜底
    s += sc.get("boost", {}).get(mod["name"], 0.0)
    return s


def rank_all(mods, top_n=10):
    out = []
    for sc in SCENARIOS:
        pick = sc.get("pick")
        if pick:
            # 人工圈定：候选与顺序都由 pick 决定（关键词在这类场景里不可靠）
            rows = []
            for i, name in enumerate(pick):
                mod = mods.get(name)
                if not mod or mod["yanked"] or mod["downloads"] < MIN_DOWNLOADS:
                    continue
                rows.append((200.0 - 10.0 * i, mod, tier_of(mod, sc)))   # 优先级序号，非算法分
        else:
            rows = []
            for mod in mods.values():
                s = score(mod, sc)
                if s is not None:
                    rows.append((s, mod, tier_of(mod, sc)))
            rows.sort(key=lambda x: -x[0])
        out.append((sc, rows))
    return out


def split_tiers(rows):
    sol = [(s, m) for s, m, t in rows if t == "solution"]
    lib = [(s, m) for s, m, t in rows if t == "lib"]
    return sol, lib


def fmt_dl(n):
    if n >= 10000:
        return f"{n / 10000:.1f}万"
    if n >= 1000:
        return f"{n / 1000:.1f}k"
    return str(n)


def reason(mod):
    parts = [f"下载 {fmt_dl(mod['downloads'])}"]
    if mod["direct"]:
        parts.append(f"{mod['direct']} 个包直接依赖")
    elif mod["transitive"]:
        parts.append(f"传递依赖 {mod['transitive']}")
    if mod["description"]:
        d = re.sub(r"\s+", " ", mod["description"]).strip()
        parts.append(d[:90] + ("…" if len(d) > 90 else ""))
    return " · ".join(parts)


# ---------------------------------------------------------------- 输出：SQLite

def write_db(mods, ranked, table_top=None):
    db = OUT / "moonbit_index.db"
    if db.exists():
        db.unlink()
    con = sqlite3.connect(db)
    con.execute("""
        CREATE TABLE modules(
            name TEXT PRIMARY KEY, version TEXT, downloads INTEGER,
            direct INTEGER, transitive INTEGER, owners INTEGER,
            license TEXT, repository TEXT, keywords TEXT, description TEXT,
            created_at TEXT, is_new INTEGER, yanked INTEGER)
    """)
    con.execute("""
        CREATE TABLE scenarios(
            scenario TEXT, title TEXT, tier TEXT, rank INTEGER, module TEXT,
            score REAL, PRIMARY KEY(scenario, module))
    """)
    con.executemany(
        "INSERT INTO modules VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",
        [(m["name"], m["version"], m["downloads"], m["direct"], m["transitive"],
          m["owners"], m["license"], m["repository"], ",".join(m["keywords"]),
          m["description"], m["created_at"], int(m["is_new"]), int(m["yanked"]))
         for m in mods.values()],
    )
    for sc, rows in ranked:
        sol, lib = split_tiers(rows)
        for tier, sub in (("solution", sol), ("lib", lib)):
            con.executemany(
                "INSERT OR REPLACE INTO scenarios VALUES (?,?,?,?,?,?)",
                [(sc["id"], sc["title"], tier, i, m["name"], round(s, 3))
                 for i, (s, m) in enumerate(sub if table_top is None else sub[:table_top], 1)],
            )
    con.execute("CREATE INDEX idx_dl ON modules(downloads DESC)")
    con.commit()
    con.close()
    return db


# ---------------------------------------------------------------- 输出：Markdown

def _md_table(lines, rows, limit):
    lines.append("| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |")
    lines.append("|---|---|---|---|---|---|")
    for i, (s, m) in enumerate(rows[:limit], 1):
        repo = f"[{m['name']}]({m['repository']})" if m["repository"] else m["name"]
        desc = re.sub(r"\s+", " ", m["description"]).strip()
        if len(desc) > 80:
            desc = desc[:80] + "…"
        desc = desc.replace("|", "\\|") or "—"
        lines.append(f"| {i} | {repo} | {m['version']} | {fmt_dl(m['downloads'])} "
                     f"| {m['transitive']} | {desc} |")
    lines.append("")


def write_md(mods, ranked, top_n=8):
    lines = []
    lines.append("# MoonBit 生态：场景化选包指南\n")
    lines.append(f"> 覆盖 {len(mods)} 个已发布模块；仅为 **下载量 > {MIN_DOWNLOADS}** 的包做推荐，"
                 f"被 yanked 的包不计入推荐。\n")
    lines.append("数据源：mooncakes.io 官方 API（模块元数据 + 下载量）、"
                 "gaato/mooncakes-graph 每日依赖快照（反向依赖数）。\n")
    lines.append(f"> **数据时效**　模块元数据与下载量采集于 {META_SNAPSHOT}，反向依赖数取自 "
                 f"{GRAPH_SNAPSHOT} 的依赖图快照，两者相隔约半日，且均早于本报告的生成时间。"
                 f"本报告为离线生成的静态快照，不随注册表更新，不含此后的新增、版本变更与 "
                 f"yanked 标记；选型判断请以 mooncakes.io 及仓库实际状态为准。\n")
    lines.append("每个场景分两层：**完整方案**（能直接选型、定骨架的）与"
                 "**基础库**（提供单点能力，由调用方组合）。框架、引擎、运行时、"
                 "脚手架、ORM 均属「完整方案」的不同形态。「基础库」不等同于「依赖」："
                 "在 mooncakes 生态中，完整方案本身同样是依赖，分层的唯一标准是"
                 "该包能否接管程序结构。\n")
    lines.append("打分 = 关键词匹配度 + 下载量 + 被依赖数；"
                 "同义词已做词干归一（如 async/asynchronous），"
                 "并对易混淆场景做了排除（如 UI 场景排除 TUI）。\n")
    lines.append("## 目录\n")
    for sc, rows in ranked:
        sol, lib = split_tiers(rows)
        n = f"方案 {len(sol)}" if sol else "无方案"
        lines.append(f"- [{sc['title']}](#{sc['id']}) — {n} / 基础库 {len(lib)}")
    lines.append("")
    for sc, rows in ranked:
        sol, lib = split_tiers(rows)
        lines.append(f"\n## {sc['title']}\n")
        lines.append(f"{sc['intro']}\n")
        if sc.get("curated"):
            lines.append("> 本场景为**人工圈定**：候选包与其顺序由人工确定，"
                         "因为「跨端」在生态里还没有形成可靠的关键词信号。\n")
        if sol:
            lines.append(f"### 完整方案（{len(sol)}）\n")
            _md_table(lines, sol, sc.get("top", top_n))
            if len(sol) <= 2:
                lines.append(f"> 完整方案仅 {len(sol)} 个，说明该类需求目前在生态中"
                             f"主要依靠基础库组合实现，下方基础库清单的实用价值更高。\n")
        else:
            lines.append("### 完整方案（0）\n")
            lines.append(f"> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成"
                         f"「一套骨架」，需要由开发者自行组合基础库。下方按用途列出"
                         f"可用的基础库，共 {len(lib)} 个，此处列出前 {min(len(lib), 12)} 个。\n")
        if lib:
            lines.append(f"### 基础库（{len(lib)}）\n")
            _md_table(lines, lib, 12 if not sol else sc.get("top", top_n))
        if len(rows) < 3:
            lines.append("\n> 候选数量偏少，表明该领域在生态中仍处早期阶段，可考虑自行实现"
                         "或复用 `moonbitlang/x` 中的通用能力。")
    (ROOT / "scenarios.md").write_text("\n".join(lines))
    return "\n".join(lines)


# ---------------------------------------------------------------- 输出：静态站点
# 站点为纯静态产物：dist/ 目录可直接交由 Cloudflare Pages、GitHub Pages 或任意
# 静态托管服务发布。构建完全在本地完成，云端不需要 Python 运行时。

HTML_CSS = """
  :root {
    --bg:#f6f7f9; --panel:#fff; --ink:#171a1f; --muted:#666e7a;
    --line:#e3e6ea; --accent:#2f5fe0; --accent-soft:#eef2fd; --warm:#a15a08;
    --warn-bg:#fffaeb; --warn-line:#f2dfae; --warn-ink:#7a4b06;
  }
  * { box-sizing:border-box; }
  body { margin:0; background:var(--bg); color:var(--ink);
    font:15px/1.65 -apple-system,BlinkMacSystemFont,"Segoe UI","PingFang SC",
    "Hiragino Sans GB","Microsoft YaHei",sans-serif;
    -webkit-font-smoothing:antialiased; }
  .wrap { max-width:1140px; margin:0 auto; padding:44px 24px 72px; }
  .masthead { border-bottom:1px solid var(--line); padding-bottom:20px; margin-bottom:24px; }
  h1 { font-size:30px; margin:0 0 10px; letter-spacing:-.4px; font-weight:650; }
  .sub { color:var(--muted); margin:0; max-width:74ch; }
  .notice { background:var(--warn-bg); border:1px solid var(--warn-line);
    border-left:3px solid #d99a2b; border-radius:8px; padding:16px 20px;
    margin:0 0 26px; color:var(--warn-ink); }
  .notice h2 { font-size:13px; margin:0 0 8px; letter-spacing:.04em;
    text-transform:uppercase; font-weight:650; }
  .notice ul { margin:0 0 8px; padding-left:20px; font-size:13px; }
  .notice li { margin:2px 0; }
  .notice p { margin:8px 0 0; font-size:13px; line-height:1.7; }
  .notice a { color:var(--warn-ink); }
  .stats { display:flex; gap:10px; flex-wrap:wrap; margin-bottom:26px; }
  .stat { background:var(--panel); border:1px solid var(--line); border-radius:9px;
    padding:10px 16px; font-size:12.5px; color:var(--muted); }
  .stat b { color:var(--ink); font-size:19px; display:block; line-height:1.35;
    font-weight:650; }
  .search { width:100%; padding:13px 16px; font-size:15px; border:1px solid var(--line);
    border-radius:9px; background:var(--panel); margin-bottom:16px; outline:none;
    font-family:inherit; }
  .search:focus { border-color:var(--accent); box-shadow:0 0 0 3px var(--accent-soft); }
  nav { display:flex; flex-wrap:wrap; gap:7px; margin-bottom:28px; }
  nav a { font-size:12.5px; text-decoration:none; color:var(--muted); background:var(--panel);
    border:1px solid var(--line); border-radius:999px; padding:4px 11px; }
  nav a:hover { color:var(--accent); border-color:var(--accent); }
  .grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(490px,1fr)); gap:18px; }
  .card { background:var(--panel); border:1px solid var(--line); border-radius:12px;
    padding:20px 22px; }
  .card header { display:flex; gap:12px; align-items:flex-start; margin-bottom:4px; }
  .ico { font-size:21px; line-height:1.25; }
  .card h2 { font-size:16.5px; margin:0 0 3px; font-weight:650; }
  .card header p { margin:0; color:var(--muted); font-size:12.5px; }
  .cnt { margin-left:8px; color:var(--accent); white-space:nowrap; }
  .tag { display:inline-block; margin-left:6px; font-size:10.5px; color:#5b46a8;
    background:#efeafd; border-radius:4px; padding:1px 5px; vertical-align:1px; }
  ol { list-style:none; margin:12px 0 0; padding:0; }
  li { display:flex; gap:12px; padding:10px 0; border-top:1px solid var(--line); }
  li:first-child { border-top:none; }
  .rk { flex:0 0 22px; height:22px; border-radius:6px; background:var(--accent-soft);
    color:var(--accent); font-size:12px; font-weight:600; display:flex;
    align-items:center; justify-content:center; margin-top:1px; }
  .rk.dim { background:#f2f3f5; color:var(--muted); font-weight:500; }
  .note { margin:12px 0 0; padding:10px 13px; background:var(--warn-bg);
    border:1px solid var(--warn-line); border-radius:7px; font-size:12.5px;
    color:var(--warn-ink); line-height:1.7; }
  details.more-libs { margin-top:12px; border-top:1px dashed var(--line); padding-top:9px; }
  details.more-libs summary { cursor:pointer; font-size:12.5px; color:var(--accent);
    list-style:none; user-select:none; }
  details.more-libs summary::-webkit-details-marker { display:none; }
  details.more-libs summary::before { content:"\\25B8\\00a0"; }
  details.more-libs[open] summary::before { content:"\\25BE\\00a0"; }
  details.more-libs summary:hover { text-decoration:underline; }
  details.more-libs ol { margin-top:4px; }
  .more { margin:7px 0 0; font-size:12px; color:var(--muted); }
  .soltag { font-size:10.5px; color:#0b6046; background:#d9f5e9; border-radius:4px;
    padding:1px 5px; margin-left:6px; vertical-align:1px; font-weight:500; }
  .body { min-width:0; }
  .nm { font-weight:600; font-size:14px; word-break:break-all; }
  .nm a { color:var(--ink); text-decoration:none; border-bottom:1px solid transparent; }
  .nm a:hover { color:var(--accent); border-bottom-color:var(--accent); }
  .ver { font-weight:400; color:var(--muted); font-size:12px; margin-left:6px; }
  .yank { font-size:10.5px; color:#8f3c16; background:#fdeede;
    border-radius:4px; padding:1px 5px; margin-left:6px; vertical-align:1px; }
  .meta { font-size:12px; color:var(--muted); }
  .meta b { color:var(--warm); }
  .dot { margin:0 4px; }
  .desc { font-size:12.5px; color:var(--muted); margin-top:2px; }
  #results { display:none; }
  #results ol { display:grid; grid-template-columns:1fr 1fr; column-gap:34px; margin:0; }
  footer { margin-top:52px; color:var(--muted); font-size:12.5px; line-height:1.85;
    border-top:1px solid var(--line); padding-top:20px; }
  footer p { margin:0 0 9px; max-width:96ch; }
  footer b { color:var(--ink); font-weight:600; }
  code { background:#eef0f3; padding:1px 5px; border-radius:4px; font-size:12px; }
  @media (max-width:560px) {
    #results ol { grid-template-columns:1fr; }
    .grid { grid-template-columns:1fr; }
  }
"""

HTML_JS = """
const q = document.getElementById('q');
const cards = document.getElementById('cards');
const results = document.getElementById('results');
const rlist = document.getElementById('rlist');
const esc = s => String(s).replace(/[&<>"]/g,
  c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));
const human = n => n >= 10000 ? (n / 10000).toFixed(1) + '\\u4e07'
  : n >= 1000 ? (n / 1000).toFixed(1) + 'k' : String(n);

q.addEventListener('input', () => {
  const t = q.value.trim().toLowerCase();
  if (!t) { results.style.display = 'none'; cards.style.display = ''; return; }
  cards.style.display = 'none'; results.style.display = 'block';
  const hits = DATA.filter(r => r[0].toLowerCase().includes(t) ||
      (r[4] || '').toLowerCase().includes(t))
    .sort((a, b) => b[1] - a[1]).slice(0, 60);
  document.getElementById('rtitle').textContent =
    '\\u641c\\u7d22\\u7ed3\\u679c\\u00b7\\u300c' + q.value.trim() + '\\u300d\\u00b7' +
    hits.length + ' \\u4e2a\\uff08\\u6309\\u4e0b\\u8f7d\\u91cf\\u964d\\u5e8f\\uff09';
  rlist.innerHTML = hits.length ? hits.map(r => `
    <li><div class="body">
      <div class="nm">${r[5] ? `<a href="${esc(r[5])}" target="_blank" rel="noopener">${esc(r[0])}</a>` : esc(r[0])}
        <span class="ver">v${esc(r[3])}</span>${r[6] ? '<span class="yank">yanked</span>' : ''}${r[7] ? `<span class="soltag">${r[7]} \\u4e2a\\u573a\\u666f\\u7684\\u5b8c\\u6574\\u65b9\\u6848</span>` : ''}</div>
      <div class="meta"><b>${human(r[1])}</b> \\u4e0b\\u8f7d
        <span class="dot">\\u00b7</span> ${r[2]} \\u53cd\\u5411\\u4f9d\\u8d56</div>
      <div class="desc">${esc((r[4] || '').slice(0, 120))}</div>
    </div></li>`).join('')
    : '<li><div class="body">\\u6ca1\\u6709\\u5339\\u914d\\u7684\\u5305</div></li>';
});
"""


def write_html(mods, ranked):
    """渲染 dist/index.html。纯静态，运行时不需要任何后端。"""
    sol_count = {}
    for _sc, rows in ranked:
        for _s, m, t in rows:
            if t == "solution":
                sol_count[m["name"]] = sol_count.get(m["name"], 0) + 1

    payload = json.dumps(
        [[m["name"], m["downloads"], m["transitive"], m["version"],
          m["description"][:160], m["repository"], int(m["yanked"]),
          sol_count.get(m["name"], 0)] for m in mods.values()],
        ensure_ascii=False, separators=(",", ":")).replace("</", "<\\/")

    def item(i, m, dim=False):
        name = html.escape(m["name"])
        link = (f'<a href="{html.escape(m["repository"])}" target="_blank" rel="noopener">'
                f'{name}</a>') if m["repository"] else name
        desc = html.escape(re.sub(r"\s+", " ", m["description"])).strip()
        if len(desc) > 108:
            desc = desc[:108] + "…"
        rk = f'<span class="rk{" dim" if dim else ""}">{i}</span>'
        return (f'\n        <li>{rk}<div class="body">'
                f'<div class="nm">{link}<span class="ver">v{html.escape(m["version"])}</span></div>'
                f'<div class="meta"><b>{fmt_dl(m["downloads"])}</b> 下载'
                f'<span class="dot">·</span>{m["transitive"]} 反向依赖</div>'
                f'<div class="desc">{desc}</div></div></li>')

    cards = []
    for sc, rows in ranked:
        sol, lib = split_tiers(rows)
        cap = sc.get("top", 8)
        parts = []
        if sol:
            parts.append('<ol>' + "".join(item(i, m) for i, (_s, m) in enumerate(sol[:cap], 1))
                         + '</ol>')
            if len(sol) > cap:
                rest = "、".join(m["name"] for _s, m in sol[cap:])
                parts.append(f'<p class="more">另有 {len(sol) - cap} 个完整方案：'
                             f'{html.escape(rest)}</p>')
            if len(sol) <= 2:
                parts.append(f'<p class="note">本场景完整方案仅 {len(sol)} 个，'
                             f'该类需求目前主要依靠基础库组合实现，展开下方基础库更具参考价值。</p>')
        else:
            parts.append('<p class="note">本场景<b>尚无完整方案</b>。该需求在生态中'
                         '尚未形成可复用的骨架，需由开发者自行组合基础库；'
                         '下方按用途列出可用基础库。</p>')
            parts.append('<ol>' + "".join(item(i, m, dim=True)
                                          for i, (_s, m) in enumerate(lib[:12], 1)) + '</ol>')
        if lib and sol:
            parts.append(
                f'<details class="more-libs"><summary>展开 {len(lib)} 个基础库'
                f'（配合上方完整方案使用）</summary><ol>'
                + "".join(item(i, m, dim=True) for i, (_s, m) in enumerate(lib[:14], 1))
                + '</ol>'
                + (f'<p class="more">共 {len(lib)} 个，可用 '
                   f'<code>python3 pipeline/query.py {sc["id"]} --libs --top 40</code>'
                   f' 查看全部</p>' if len(lib) > 14 else '')
                + '</details>')
        elif lib and not sol:
            if len(lib) > 12:
                parts.append(
                    f'<details class="more-libs"><summary>另外 {len(lib) - 12} 个基础库'
                    f'（共 {len(lib)}）</summary><ol>'
                    + "".join(item(i + 12, m, dim=True)
                              for i, (_s, m) in enumerate(lib[12:26], 1))
                    + '</ol></details>')
        tag = '<span class="tag">人工圈定</span>' if sc.get("curated") else ''
        cards.append(f"""
    <section class="card" id="{sc['id']}">
      <header><span class="ico">{sc['icon']}</span>
        <div><h2>{html.escape(sc['title'])}{tag}</h2>
        <p>{html.escape(sc['intro'])}
          <span class="cnt">方案 {len(sol)} · 基础库 {len(lib)}</span></p></div>
      </header>{''.join(parts)}
    </section>""")

    nav = "".join(f'<a href="#{sc["id"]}">{sc["icon"]} {html.escape(sc["title"])}</a>'
                  for sc, _ in ranked)
    n_sol_scene = sum(1 for _sc, rows in ranked if split_tiers(rows)[0])
    n_sol_pkg = len({m["name"] for _sc, rows in ranked for _s, m, t in rows
                     if t == "solution"})
    n_active = sum(1 for m in mods.values() if m["downloads"] > MIN_DOWNLOADS)
    n_yanked = sum(1 for m in mods.values() if m["yanked"])
    built = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")

    body = f"""
<div class="wrap">
  <header class="masthead">
    <h1>MoonBit 生态索引</h1>
    <p class="sub">按使用场景组织的 MoonBit 包选型参考。每个场景先列<b>完整方案</b>
      （可直接选型、承担程序骨架），<b>基础库</b>折叠于下方，按需展开。
      仅纳入下载量大于 {MIN_DOWNLOADS} 的模块。</p>
  </header>

  <aside class="notice">
    <h2>数据时效说明</h2>
    <ul>
      <li>模块元数据与下载量：采集于 <b>{META_SNAPSHOT}</b>（mooncakes.io 官方 API）</li>
      <li>反向依赖数：<b>{GRAPH_SNAPSHOT}</b> 的依赖图快照（gaato/mooncakes-graph）</li>
      <li>本页构建时间：<b>{built}</b></li>
    </ul>
    <p>本页为构建时生成的静态快照，不随 mooncakes 注册表实时更新。上述两批数据相隔约半日，
      且均早于本页构建时间；此后新增、更新或被标记为 yanked 的包不会反映在本页。
      选型前请以 <a href="https://mooncakes.io" target="_blank" rel="noopener">mooncakes.io</a>
      及仓库实际状态为准。</p>
  </aside>

  <div class="stats">
    <div class="stat"><b>{len(mods)}</b>已发布模块</div>
    <div class="stat"><b>{n_active}</b>下载量 &gt; {MIN_DOWNLOADS}</div>
    <div class="stat"><b>{len(SCENARIOS)}</b>使用场景</div>
    <div class="stat"><b>{n_sol_pkg}</b>完整方案（覆盖 {n_sol_scene} 个场景）</div>
    <div class="stat"><b>{n_yanked}</b>已标记 yanked</div>
  </div>

  <input class="search" id="q" autocomplete="off"
    placeholder="检索全部 {len(mods)} 个模块：名称、描述或关键词，例如 json、http、parser">

  <nav>{nav}</nav>

  <section id="results"><h2 style="font-size:15px" id="rtitle">检索结果</h2>
    <ol id="rlist"></ol></section>
  <div class="grid" id="cards">{''.join(cards)}</div>

  <footer>
    <p><b>数据来源</b>　mooncakes.io 官方 API（模块元数据、下载量）；gaato/mooncakes-graph
      依赖图快照（反向依赖数）。</p>
    <p><b>数据滞后</b>　元数据与下载量为 {META_SNAPSHOT} 的抓取结果，依赖图为 {GRAPH_SNAPSHOT}
      的快照，本页构建于 {built}，三者在时间上均非实时。mooncakes 注册表每日均有新增与更新，
      本页不含此后的变动；对时效敏感的选型判断，请回到注册表与仓库核实。</p>
    <p><b>分层标准</b>　完整方案指可直接选型、承担程序骨架的包，框架、引擎、运行时、脚手架、
      ORM 均属此类；基础库指提供单点能力、由调用方组合的包。「基础库」不等同于「依赖」：
      在 mooncakes 生态中完整方案本身亦为依赖，分层的唯一标准是该包能否接管程序结构。
      因此 gtk、glfw、sqlite 等绑定归入基础库，完整方案位于其上层（giraffe 之于 GTK，
      proton 之于 WebView）。共 {len(SCENARIOS) - n_sol_scene} 个场景尚无完整方案，卡片内已注明。</p>
    <p><b>排序方法</b>　关键词匹配度 ×1.0（上限 6）+ log(下载量) ×1.05 + log(反向依赖数) ×0.55。
      同义词已做词干归一，易混场景设有排除规则；db、ui、net、gui 含少量人工置顶。</p>
    <p><b>特殊场景</b>　桌面 GUI 采用核心词门控，仅含 desktop 标签的外围插件不参与排名；
      跨端 UI 因生态中尚无可靠关键词信号，为人工圈定的路线清单。</p>
    <p><b>构建</b>　<code>python3 pipeline/analyze.py</code> ·
      <b>查询</b>　<code>python3 pipeline/query.py "json"</code></p>
  </footer>
</div>"""

    doc = ('<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="utf-8">\n'
           '<meta name="viewport" content="width=device-width, initial-scale=1">\n'
           '<title>MoonBit 生态索引 · 场景化选型参考</title>\n'
           '<meta name="description" content="按使用场景组织的 MoonBit 包选型参考，'
           '区分完整方案与基础库，含下载量与反向依赖数据。">\n'
           f'<style>{HTML_CSS}</style>\n</head>\n<body>{body}\n'
           f'<script>\nconst DATA = {payload};\n{HTML_JS}</script>\n</body>\n</html>\n')

    DIST.mkdir(parents=True, exist_ok=True)
    (DIST / "index.html").write_text(doc, encoding="utf-8")
    return DIST / "index.html"


def publish_site():
    """把分析产物同步到 dist/，该目录即静态托管发布目录。"""
    import shutil
    (DIST / "data").mkdir(parents=True, exist_ok=True)
    for name in ("modules.json", "scenarios.json"):
        shutil.copyfile(OUT / name, DIST / "data" / name)
    shutil.copyfile(ROOT / "scenarios.md", DIST / "scenarios.md")
    return DIST


# ---------------------------------------------------------------- 输出：结构化 JSON
# 供前端构建脚本（Node.js）消费。分析与渲染在此解耦，使静态站点的构建
# 不依赖 Python 运行时。

def _row(m, s):
    return {
        "name": m["name"],
        "version": m["version"],
        "downloads": m["downloads"],
        "direct": m["direct"],
        "transitive": m["transitive"],
        "description": re.sub(r"\s+", " ", m["description"]).strip(),
        "repository": m["repository"],
        "score": round(s, 3),
    }


def write_scenarios_json(mods, ranked, lib_limit=40):
    n_sol_scene = sum(1 for sc, rows in ranked if split_tiers(rows)[0])
    n_sol_pkg = len({m["name"] for sc, rows in ranked for _, m, t in rows if t == "solution"})
    payload = {
        "schema_version": 1,
        "generated_at": datetime.datetime.now().astimezone().isoformat(timespec="seconds"),
        "snapshots": {"metadata_and_downloads": META_SNAPSHOT,
                      "dependency_graph": GRAPH_SNAPSHOT},
        "min_downloads": MIN_DOWNLOADS,
        "totals": {
            "modules": len(mods),
            "above_download_threshold":
                sum(1 for m in mods.values() if m["downloads"] > MIN_DOWNLOADS),
            "yanked": sum(1 for m in mods.values() if m["yanked"]),
            "scenarios": len(SCENARIOS),
            "scenarios_with_solutions": n_sol_scene,
            "solution_packages": n_sol_pkg,
        },
        "tiers": {
            "solution": "可直接选型、承担程序骨架的包（框架、引擎、运行时、脚手架、ORM 等）",
            "lib": "提供单点能力、由调用方组合的包（解析、编码、哈希、绑定、数据结构等）",
        },
        "scenarios": [],
    }
    for sc, rows in ranked:
        sol, lib = split_tiers(rows)
        payload["scenarios"].append({
            "id": sc["id"],
            "title": sc["title"],
            "icon": sc["icon"],
            "intro": sc["intro"],
            "curated": bool(sc.get("curated")),
            "counts": {"solutions": len(sol), "libs": len(lib)},
            "solutions": [_row(m, s) for s, m in sol],
            "libs": [_row(m, s) for s, m in lib[:lib_limit]],
        })
    path = OUT / "scenarios.json"
    path.write_text(json.dumps(payload, ensure_ascii=False, separators=(",", ":")),
                    encoding="utf-8")
    return path


# ---------------------------------------------------------------- main

def main():
    mods = load_modules()
    ranked = rank_all(mods)

    slim = {k: {kk: vv for kk, vv in v.items() if not kk.startswith("_")}
            for k, v in mods.items()}
    (OUT / "modules.json").write_text(
        json.dumps(slim, ensure_ascii=False, indent=None, separators=(",", ":")))

    db = write_db(mods, ranked)
    md = write_md(mods, ranked)
    sj = write_scenarios_json(mods, ranked)
    page = write_html(mods, ranked)
    publish_site()

    active = [m for m in mods.values() if m["downloads"] > MIN_DOWNLOADS]
    print(f"modules={len(mods)}  dl>{MIN_DOWNLOADS}={len(active)}  "
          f"scenarios={len(SCENARIOS)}")
    print(f"db   -> {db}")
    print(f"md   -> {ROOT/'scenarios.md'}  ({len(md)} chars)")
    print(f"json -> {sj}")
    print(f"site -> {page}  ({page.stat().st_size/1024:.0f} KB)")
    print(f"dist -> {DIST}")
    print("\n每个场景候选数（完整方案 / 基础库）：")
    for sc, rows in ranked:
        sol, lib = split_tiers(rows)
        print(f"  {sc['id']:9} {len(sol):3} / {len(lib):4}   方案: " +
              (", ".join(m["name"] for _, m in sol[:3]) or "—（本场景暂无完整方案）"))

    # 自我描述像框架、但还没进白名单的候选：列出来，避免新方案被永久埋掉
    known = {n for v in SOLUTIONS.values() for n in v}
    pending = []
    for sc, rows in ranked:
        for _, m, _t in rows:
            d = m["_desc_l"]
            if (m["name"] not in known and m["name"] not in SOL_DENY
                    and any(w in d for w in SOL_WORDS)
                    and not any(w in d for w in LIB_WORDS)):
                pending.append(f"{sc['id']}/{m['name']}")
    if pending:
        print(f"\n待确认的方案候选（{len(pending)}，确认后加进 build.py 的 SOLUTIONS）：")
        for p in pending[:14]:
            print("  " + p)
        if len(pending) > 14:
            print(f"  … 另有 {len(pending) - 14} 个")


if __name__ == "__main__":
    main()
