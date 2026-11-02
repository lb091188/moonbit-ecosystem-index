#!/usr/bin/env python3
"""
构建 MoonBit 生态索引，并生成「不同场景下的包推荐」。

数据来源（全部为公开数据，已落盘到 data/raw/）：
  1. modules_api.json   mooncakes.io /api/v0/modules        全量模块元数据（3520）
  2. downloads.json     mooncakes.io /api/v0/search         每个模块的下载量（3518）

本索引只做场景导航，不复制注册表的能力：不引入依赖图、不计算反向依赖数、
不展示版本历史。包的完整信息请到 mooncakes 包页查看（页面上每个包都链过去）。

输出：
  data/modules.json          合并后的模块表
  data/scenarios.json        站点数据（前端 fetch 加载，与 HTML 分离）
  data/moonbit_index.db      SQLite 索引（modules / scenarios 两张表）
  scenarios.md               场景推荐报告（中文）
  dist/index.html            站点骨架（不含数据，数据在 dist/data/）
"""

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


def murl(name):
    """包在 mooncakes 上的文档页。

    本索引只做导航：版本历史、完整 API 文档、依赖关系一律回注册表查看，
    页面与报告里的包名全部指向这里，不复制注册表的能力。
    """
    return "https://mooncakes.io/docs/" + name

# ---------------------------------------------------------------- 数据合并

def load_modules():
    """合并两份官方快照：模块元数据 + 下载量。

    本索引只做「场景导航」，不替代 mooncakes：所有字段均来自注册表本身，
    不引入依赖图、反向依赖数等派生指标。包的详细信息（文档、版本历史、
    依赖关系）请直接到 mooncakes 包页查看，页面上每个包都链到那里。
    """
    api = json.loads((RAW / "modules_api.json").read_text())
    dl = json.loads((RAW / "downloads.json").read_text())

    mods = {}
    for m in api:
        name = m["name"]
        d = dl.get(name, {})
        desc = (m.get("description") or d.get("description") or "").strip()
        keywords = [k.lower() for k in (m.get("keywords") or [])]
        mods[name] = {
            "name": name,
            "version": m.get("version") or d.get("version") or "",
            "downloads": int(d.get("downloads") or 0),
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

# 场景分组：左侧导航按组渲染，组内按下列顺序
GROUPS = [
    ("app", "界面与应用"),
    ("svc", "服务与数据"),
    ("lang", "语言与工具"),
]

# kw   : 命中 keywords / 模块名的词（权重最高）
# desc : 需要出现在描述里的短语
# ex   : 命中即排除的词（用于压掉同名不同义的噪声）
# pick : 人工圈定的候选清单（生态里没有可靠关键词信号时使用）
# audit: 人工场景的复核词。build 时扫描全量模块，命中这些词却不在 pick 里的包会被打印
#        出来，防止「覆盖了某个场景却没出现在该场景」的漏收悄悄发生
# skip : audit 命中但确认不收的包及其理由（写清楚才能长期维护）
# note : 场景详情页的补充说明（用于解释分层口径等）
SCENARIOS = [
    # ---------------------------------------------------------------- 界面与应用
    # 桌面：生态里没有统一的 "desktop gui" 关键词，靠 core 门控——
    # 必须命中真正的窗口/渲染/控件绑定词，光有 desktop/native 的插件包不算。
    dict(id="gui", group="app", title="桌面", icon="🖥️",
         intro="原生桌面应用开发：窗口创建、事件循环、控件布局与渲染后端接入。"
               "Proton 的托盘、剪贴板、全局热键等配套模块不计入本表。",
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
    # 移动端：关键词层面不可靠（"mobile" 会命中 window 的三端后端，"ios" 会命中
    # "scenarios" 这类词），候选以人工圈定为主。
    # 收录原则：**覆盖即出现**。一个包只要支持移动端，就必须在这里列出，哪怕它主要
    # 归类在别的场景（如 MoUI 的桌面主线）。清单是封闭集合，靠人维护，因此 build 时
    # 会用 audit 词扫描一遍全量模块，把「有覆盖迹象却没进清单」的包打印出来复核。
    dict(id="mobi", group="app", title="移动端", icon="📱",
         intro="Android、iOS、HarmonyOS 与微信小程序上的应用开发。生态中尚无统一的"
               "移动端关键词信号，候选清单为人工圈定，涵盖全平台 UI 框架、小程序运行时与"
               "组件库、原生桥接、小程序宿主。",
         curated=True, top=10,
         pick=[
             "XiLaiTL/moobile",           # Android / iOS / Web 一套 rabbita，React Native 渲染
             "wzzc-dev/moui",             # 全平台 GUI：HarmonyOS 已承诺，Android / iOS 实验性
             "lampclaw/minimoon",         # 微信小程序 Skyline UI 运行时
             "Magic486/moon-miniprogram", # 微信小程序框架：类型安全运行时 + 声明式路由
             "shop1111/moonohos",         # HarmonyOS 原生模块框架（async / 平台模块 / HAR）
             "lampclaw/lampo",            # 小程序 Skyline，纯 Elm 风格编写
             "vectie/bunnia",             # 小程序 UI 框架：微信 / 支付宝 / 抖音适配层
             "wzzc-dev/window",           # 窗口层，含 desktop / Web / mobile 三后端
             "Nanaloveyuki/ajni",         # Android JNI 双向桥
             "Nanaloveyuki/moonview",     # 原生 WebView 嵌入
             "lampclaw/minimoon_ui",      # 小程序 Skyline 组件库
             "shop1111/moonohos_ohos",    # HarmonyOS 平台包（HiLog / RawFile / deviceinfo）
             "Nanaloveyuki/madk",         # Android Open Accessory 协议
             "Nanaloveyuki/wasee-moon",   # Android 上的 WASI host
             "wzzc-dev/moui_cli",         # MoUI 的工程生成器与环境检查，含 --platform 移动端
         ],
         audit=["miniapp", "miniprogram", "skyline", "android", "ios", "harmonyos",
                "mobile", "wechat"],
         skip={"daqing/moon-pay-sdk": "微信支付 SDK，服务端为主，不属移动端 UI 或运行时",
               "kupas/imrelay": "消息网关，与移动端开发无关",
               "tonyfettes/create-moonbit-raylib-android-app":
                   "模板仓库，注册表无描述与关键词，无法判断可用性"}),
    dict(id="ui", group="app", title="Web UI / 前端框架", icon="🌐",
         intro="浏览器里的 UI 框架、响应式状态、组件、布局与 CSS。",
         kw=["ui", "component", "dom", "frontend", "css", "reactive", "signals"],
         desc=["user interface", "component", "frontend"],
         ex=["terminal", "tui", "component-model"],   # component-model 是 wasm 组件模型，不是 UI 组件
         pin=["moonbit-community/rabbita"]),
    dict(id="tui", group="app", title="终端 UI / TUI", icon="⌨️",
         intro="终端界面、字符画布、ANSI 控制、PTY。",
         kw=["tui", "terminal", "ansi", "console", "pty", "curses"],
         desc=["terminal ui", "terminal"], ex=[]),
    # CLI：关键词 "cli" 本身极宽（任何命令行程序都带），故加 core 门控，
    # 必须命中参数解析器本身的词，把「带 CLI 的应用」挡在外面。
    dict(id="cli", group="app", title="CLI 参数解析", icon="🧰",
         intro="命令行工具的参数、子命令、帮助信息解析。",
         kw=["cli", "argparse", "command-line", "args", "argument-parser", "docopt", "argv",
             "clap", "subcommand"],
         desc=["command line", "argument parser", "argument-parser"],
         core=["argparse", "argv", "command-line", "subcommand", "argument-parser", "docopt",
               "clap"],
         ex=["tui", "terminal", "browser"]),
    dict(id="game", group="app", title="游戏引擎 / ECS", icon="🎮",
         intro="游戏引擎、ECS 架构、程序化生成、游戏后端。",
         kw=["game", "engine", "ecs", "gamedev", "sprite"],
         desc=["game engine", "game"], ex=[]),
    dict(id="graphics", group="app", title="图形 / 图表 / 渲染", icon="🎨",
         intro="矢量图形、SVG、场景图、图表与图形布局、绘图原语。",
         kw=["graphics", "rendering", "svg", "canvas", "scene-graph", "vector", "drawing",
             "diagram", "chart"],
         desc=["rendering", "vector graphics", "scene graph", "diagram"],
         ex=["vector database", "ann"], ex_prefix=["wzzc-dev/moui_"]),
    dict(id="img", group="app", title="图像编解码", icon="🖼️",
         intro="图像格式的编解码与像素处理：PNG / JPEG / GIF / BMP / QOI / WebP。",
         kw=["image", "png", "jpeg", "jpg", "gif", "bmp", "webp", "qoi", "ico", "tiff",
             "pixel", "pixmap"],
         desc=["image", "pixel"]),
    dict(id="media", group="app", title="音频 / 视频", icon="🔊",
         intro="音频采集与播放、音频编码、MIDI、麦克风与设备接口。",
         kw=["audio", "video", "wav", "mp3", "midi", "opus", "ffmpeg", "mp4", "flac",
             "playback", "microphone", "speech"],
         desc=["audio", "video", "media"]),

    # ---------------------------------------------------------------- 服务与数据
    # HTTP 服务端：只收服务端框架与路由/中间件，客户端另立 httpc
    dict(id="http", group="svc", title="Web 后端 / HTTP 服务", icon="🚀",
         intro="HTTP 服务、路由、中间件与后端 API 开发。",
         kw=["http", "router", "rest", "middleware", "backend", "web-framework", "endpoint"],
         desc=["http server", "web framework", "router", "rest api"],
         ex=["compatibility", "ui", "frontend", "tea", "desktop-app", "gui"],
         pin=["moonbitlang/moonback"],
         core=["http", "router", "rest", "middleware", "backend"],
         # 注册表元数据只有 web + framework 两个泛词，命不中本场景关键词，单独补入
         force=["moonbitstack/moonapi", "daqing/moonway"]),
    dict(id="httpc", group="svc", title="HTTP 客户端", icon="📡",
         intro="发起 HTTP 请求：请求构造、连接复用、重定向、SSE 流式读取。",
         kw=["http-client", "httpc", "fetch", "axios", "client", "request"],
         desc=["http client"], core=["http"]),
    dict(id="net", group="svc", title="网络传输 / 套接字", icon="🔌",
         intro="TCP / UDP、套接字、DNS、TLS 等传输层能力。",
         kw=["network", "tcp", "udp", "socket", "dns", "tls", "ip-address", "net"],
         desc=["network", "socket", "tcp"],
         ex=["compatibility", "git"],
         pin=["moonbitstack/moonnet"]),
    dict(id="proto", group="svc", title="应用协议 / RPC", icon="🛰️",
         intro="WebSocket、MQTT、gRPC、SSE 等应用层协议与 RPC 通信。",
         kw=["websocket", "mqtt", "sse", "grpc", "amqp", "http2", "rpc", "socket.io"],
         desc=["websocket", "rpc", "messaging protocol"],
         ex=["compatibility", "git"]),
    dict(id="db", group="svc", title="数据库 / 存储", icon="🗄️",
         intro="SQLite 绑定、ORM、KV 存储、迁移工具。",
         kw=["database", "sqlite", "sql", "storage", "kv", "orm", "postgres", "migration"],
         desc=["database", "storage engine", "key-value"],
         pin=["mizchi/sqlite", "moonbitstack/moonsqlite"]),
    dict(id="async", group="svc", title="异步 / 并发", icon="⚡",
         intro="async 运行时、协程、并发原语、任务调度。",
         kw=["async", "concurrency", "coroutine", "future", "promise", "thread", "parallel"],
         desc=["asynchronous", "concurren"], ex=[]),
    # 序列化按「文本格式 / 配置格式 / 二进制格式」三分，原先一个场景混装 184 个包
    dict(id="json", group="svc", title="JSON 解析", icon="🧾",
         intro="JSON、JSON Lines、JSON5 的解析、生成与 JSON Schema 校验。",
         kw=["json", "jsonl", "ndjson", "json5", "json-schema"],
         desc=["json"], ex=["jsonrpc"]),
    dict(id="datafmt", group="svc", title="配置 / 标记格式", icon="📋",
         intro="YAML、TOML、XML、CSV、INI、Ion 等配置与标记语言的解析与生成。",
         kw=["yaml", "toml", "xml", "csv", "ini", "hcl", "ion", "properties"],
         desc=["data format", "configuration file"], ex=["toml-config-ui"],
         # 只带 serialization / serde 关键词，命不中具体格式名，按「多格式框架」补入
         force=["Yu-zh/data"]),
    dict(id="binfmt", group="svc", title="二进制编码", icon="🔢",
         intro="CBOR、Protocol Buffers、MessagePack、ASN.1 等二进制序列化格式。",
         kw=["cbor", "protobuf", "msgpack", "bencode", "asn1", "avro", "thrift", "capnp",
             "binary format"],
         desc=["binary format", "binary encoding"]),
    dict(id="log", group="svc", title="日志 / 追踪", icon="📝",
         intro="结构化日志、tracing、OpenTelemetry、指标。",
         kw=["logging", "tracing", "log", "telemetry", "otel", "metrics", "observability"],
         desc=["logging", "tracing", "observability"], ex=["font"]),
    # 运维：生态里没有运维框架，但有可整件部署的成品工具（进程管理器、CI 运行器），
    # 这些按「完整方案」计；其余是可组合的基础库。
    # process 类关键词会被 "processing" 命中，因此整段人工圈定，同样用 audit 词复核缺口。
    dict(id="ops", group="svc", title="运维 / 系统管理", icon="🛠️",
         intro="进程守护与进程检查、子进程与命令执行、伪终端控制、CI 任务运行。"
               "生态中尚无运维框架，但已有可直接部署的成品工具，与若干可组合的基础库。",
         note="进程管理器与 CI 运行器本身就是可用成品，计入「完整方案」；"
              "其余为单点能力的基础库，需要自行组装。",
         curated=True, top=10,
         pick=[
             "chensuiyi/bm2",                    # 进程管理器：守护 Bun / Node 应用（类 PM2）
             "mizchi/actrun",                    # GitHub Actions 兼容的 CI 运行器
             "kupas/pm3",                        # 语言无关的进程管理器，自带日志轮转
             "tiye/redstart",                    # 轻量进程管理器，面向本地开发
             "moonbit-community/pty",            # 跨平台伪终端，接 async
             "moonbit-community/tty",            # 底层终端原语：raw 模式、尺寸与 resize 事件
             "Milky2018/sysinfo",                # 系统指标与进程检查
             "mizchi/process_pool",              # 进程池
             "moonbit-community/proton_process", # 原生子进程（Win/Linux/macOS）
             "trkbt10/subprocess",               # Node child_process 风格子进程管理
             "trkbt10/osenv",                    # 环境变量、XDG 目录、平台路径
             "mizchi/tempfile",                  # 临时文件与目录
         ],
         audit=["process manager", "process-manager", "supervisor", "daemon",
                "systemd", "sysinfo", "subprocess", "pty"],
         skip={"moonbit-community/proton_cefsetup": "Proton 的 CEF 运行时装包器，不是运维工具",
               "Milky2018/selene_editor_service": "编辑器配套的本地服务，非通用运维",
               "mst-mkt/clipboard": "剪贴板绑定，只是实现里用了子进程",
               "chensuiyi/dcipc": "守护进程的控制通道库，粒度低于本场景定位",
               "tonyfettes/pty": "与 moonbit-community/pty 同一实现，只保留下载量高的那个"}),
    dict(id="llm", group="svc", title="LLM / Agent / MCP", icon="🤖",
         intro="大模型客户端、Agent 框架、MCP 服务端/客户端、提示词。",
         kw=["llm", "agent", "mcp", "openai", "embedding", "prompt"],
         desc=["language model", "llm", "agent"], ex=["wasi", "io"]),

    # ---------------------------------------------------------------- 语言与工具
    # 解析器与编译器分开：前者是「把文本读成结构」，后者是「把结构变成可执行物」
    dict(id="parser", group="lang", title="解析器 / 语法", icon="🌳",
         intro="词法、语法、parser combinator、AST、tree-sitter、parser generator。",
         kw=["parser", "lexer", "grammar", "ast", "tree-sitter", "parser-combinator",
             "tokenizer"],
         desc=["parser", "lexer"],
         ex=["argparse", "cli", "command-line", "docopt"]),
    dict(id="compiler", group="lang", title="编译器 / 代码生成", icon="⚙️",
         intro="编译器、字节码与虚拟机、代码生成、类型检查、LLVM 与原生后端。",
         kw=["compiler", "codegen", "interpreter", "type-checker", "bytecode", "llvm",
             "virtual-machine"],
         desc=["compiler", "code generation", "interpreter"]),
    dict(id="regex", group="lang", title="正则匹配", icon="🔍",
         intro="正则表达式引擎与匹配。",
         kw=["regex", "regexp", "regular-expression"],
         desc=["regular expression"], ex=[]),
    dict(id="unicode", group="lang", title="Unicode / 文本处理", icon="🔤",
         intro="Unicode 分类、字素簇、宽度计算、字符串工具。",
         kw=["unicode", "grapheme", "string", "text", "width", "collation"],
         desc=["unicode", "grapheme"], ex=[]),
    # 密码学按能力三分：哈希只管校验、cipher 管机密性与身份、encode 管字节到文本
    dict(id="hash", group="lang", title="哈希 / 校验", icon="#️⃣",
         intro="哈希函数、消息摘要、HMAC 与校验和（CRC / FNV）。",
         kw=["hash", "sha256", "sha512", "sha1", "md5", "blake2", "blake3", "crc",
             "checksum", "digest", "hmac", "xxhash", "fnv"],
         desc=["hashing", "hash function", "checksum"], ex=["simd"]),
    dict(id="cipher", group="lang", title="加密 / 签名", icon="🔐",
         intro="对称与非对称加密、数字签名、密钥交换、证书。",
         kw=["aes", "rsa", "ed25519", "x25519", "chacha", "cipher", "encrypt", "cryptography",
             "signature", "ecdsa", "pkcs", "curve25519"],
         desc=["encryption", "cryptography", "signing"], ex=["simd"]),
    dict(id="encode", group="lang", title="编码 / 转义", icon="🔡",
         intro="Base64 / Base32 / Hex 等编码、URL 百分号编码、转义与变长整数。",
         kw=["base64", "base32", "base58", "hex", "percent-encoding", "encoding", "escape",
             "urlencode", "varint"],
         desc=["encoding", "escape"]),
    dict(id="archive", group="lang", title="压缩 / 归档", icon="🗜️",
         intro="DEFLATE / zlib / gzip / ZIP 的压缩与解压实现。",
         kw=["zip", "gzip", "zlib", "deflate", "compression", "compress", "archive", "tar",
             "brotli", "inflate", "lz4"],
         desc=["compression", "deflate", "gzip", "zip archive"],
         pin=["mizchi/zlib", "moonbit-community/flate"]),
    dict(id="fs", group="lang", title="文件 / 路径 / IO", icon="📁",
         intro="文件系统访问、路径与环境变量、临时文件、通用 IO 抽象与文件监听。",
         kw=["filesystem", "file", "path", "directory", "tempfile", "io", "stream",
             "watch", "fswatch"],
         desc=["file system", "filesystem", "temporary file", "path", "io abstraction"],
         ex=["git", "svg"],
         ex_prefix=["moonbit-community/proton_"],   # 桌面框架的内部扩展包，不单列
         pin=["mizchi/tempfile", "gmlewis/io"]),
    dict(id="math", group="lang", title="数学 / 数值计算", icon="📐",
         intro="高精度数学、线性代数、矩阵、BLAS、统计。",
         kw=["math", "numeric", "linear-algebra", "matrix", "statistics", "bigint", "blas", "arithmetic"],
         desc=["linear algebra", "numeric", "arbitrary precision"], ex=[]),
    dict(id="ds", group="lang", title="数据结构 / 算法", icon="🧱",
         intro="有序映射、B 树、堆、图算法、集合。",
         kw=["data-structure", "collection", "map", "set", "heap", "graph", "queue", "btree", "indexmap"],
         desc=["data structure", "algorithm"], ex=["syntax", "svg", "compatibility", "grapheme"]),
    dict(id="test", group="lang", title="测试 / 断言 / 属性测试", icon="🧪",
         intro="单元测试、属性测试（quickcheck）、断言库、BDD、基准。",
         kw=["testing", "test", "property", "benchmark", "quickcheck", "fuzz", "assert", "mock"],
         desc=["test framework", "property-based", "assertion"], ex=["image", "pixel"]),
    dict(id="tool", group="lang", title="开发工具 / 代码质量", icon="🧭",
         intro="代码格式化、静态分析、lint、结构化搜索与重构、代码生成与脚手架。",
         kw=["formatter", "linter", "lint", "static-analysis", "prettifier", "refactor",
             "codegen", "scaffold"],
         desc=["static analysis", "code formatter", "linter", "code generation"],
         ex=["toml", "hcl", "json"],   # 数据格式的格式化 CLI 属于对应格式领域
         pin=["moonbitlang/formatter", "riantr/moonbit_static_analysis"]),
    dict(id="doc", group="lang", title="Markdown / 文档转换", icon="📄",
         intro="Markdown 解析、HTML/PDF/DOCX 转换、文档排版。",
         kw=["markdown", "html", "pdf", "document", "epub", "asciidoc", "docx", "latex"],
         desc=["markdown", "pdf", "document"], ex=["font", "ui", "framework", "tea"]),
    dict(id="time", group="lang", title="时间 / 日期", icon="🕒",
         intro="日期时间、时区、RFC3339、cron。",
         kw=["time", "date", "datetime", "timezone", "tzif", "cron", "duration"],
         desc=["timezone", "date and time"], ex=[]),
    dict(id="wasm", group="lang", title="WebAssembly / JS 互操作", icon="🧩",
         intro="Wasm 组件模型、WASI、FFI、JS 绑定。",
         kw=["wasm", "wasi", "ffi", "javascript", "webassembly", "component-model"],
         desc=["webassembly", "component model"], ex=[]),
]

MIN_DOWNLOADS = 20   # 只推荐下载量 > 20 的包

# 数据快照时间。本索引为离线快照，不随时间自动更新，务必与构建时间一并披露。
COLLECTED_AT = "2026-11-02"   # 模块元数据与下载量的采集日期（mooncakes.io 官方 API）


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
    "json": [],          # JSON 场景只收格式实现，序列化框架（serde 式）归 datafmt
    "datafmt": ["Yu-zh/data"],   # 生态里唯一的序列化框架：定义一次数据模型，多格式
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
    # 移动端：小程序 / HarmonyOS / React Native 三条路线各有自己的运行时，
    # 全平台 GUI 框架（moui）同样覆盖移动端，一并计入
    "mobi": ["XiLaiTL/moobile", "wzzc-dev/moui", "lampclaw/minimoon",
             "Magic486/moon-miniprogram", "shop1111/moonohos",
             "lampclaw/lampo", "vectie/bunnia"],
    # 运维：无框架，但进程管理器与 CI 运行器是可整件部署的成品
    "ops": ["chensuiyi/bm2", "mizchi/actrun", "kupas/pm3", "tiye/redstart"],
    "llm": ["colmugx/posoco", "colmugx/mcp", "golemcloud/golem_sdk", "soehi/moonlm",
            "weopqrst/agent"],
    # 这些场景在生态里**没有任何完整方案**，全是基础库：按需要挑，别指望有个骨架
    # regex / unicode / crypto / math / graphics / doc / time / img / ds / net / log
    # fs / archive / tool
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
    """场景内排序分。

    只用两项信号：与场景的关键词相关度、注册表里的下载量。不引入反向依赖数、
    传递依赖数等派生指标——本索引只做导航，不替代 mooncakes 的选型判断，
    派生指标既增加数据滞后面，也把「被依赖多」误当成「适合这个场景」。
    """
    rel = relevance(mod, sc)
    if rel is None:
        return None
    s = (min(rel, 6) * 1.0
         + math.log1p(mod["downloads"]) * 1.35)
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
            seen = set()
            for mod in mods.values():
                s = score(mod, sc)
                if s is not None:
                    rows.append((s, mod, tier_of(mod, sc)))
                    seen.add(mod["name"])
            # force：元数据描述不足、但确实属于本场景的包（注册表关键词太泛时兜底）
            for name in sc.get("force", ()):
                mod = mods.get(name)
                if (mod and mod["name"] not in seen and not mod["yanked"]
                        and mod["downloads"] >= MIN_DOWNLOADS):
                    rows.append((6.0 + math.log1p(mod["downloads"]) * 1.35, mod,
                                 tier_of(mod, sc)))
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
            license TEXT, repository TEXT, keywords TEXT, description TEXT,
            created_at TEXT, is_new INTEGER, yanked INTEGER)
    """)
    con.execute("""
        CREATE TABLE scenarios(
            scenario TEXT, title TEXT, tier TEXT, rank INTEGER, module TEXT,
            score REAL, PRIMARY KEY(scenario, module))
    """)
    con.executemany(
        "INSERT INTO modules VALUES (?,?,?,?,?,?,?,?,?,?)",
        [(m["name"], m["version"], m["downloads"], m["license"], m["repository"],
          ",".join(m["keywords"]), m["description"], m["created_at"],
          int(m["is_new"]), int(m["yanked"]))
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
    lines.append("| # | 包 | 版本 | 下载 | 说明 |")
    lines.append("|---|---|---|---|---|")
    for i, (s, m) in enumerate(rows[:limit], 1):
        desc = re.sub(r"\s+", " ", m["description"]).strip()
        if len(desc) > 80:
            desc = desc[:80] + "…"
        desc = desc.replace("|", "\\|") or "—"
        lines.append(f"| {i} | [{m['name']}]({murl(m['name'])}) | {m['version']} "
                     f"| {fmt_dl(m['downloads'])} | {desc} |")
    lines.append("")


def write_md(mods, ranked, top_n=8):
    lines = []
    lines.append("# MoonBit 生态：场景化选包指南\n")
    lines.append(f"> 覆盖 {len(mods)} 个已发布模块；仅为 **下载量 > {MIN_DOWNLOADS}** 的包做推荐，"
                 f"被 yanked 的包不计入推荐。\n")
    lines.append("数据源：mooncakes.io 官方 API（模块元数据 + 下载量）。"
                 "本索引仅做场景导航，不复制注册表能力：版本历史、完整 API 文档与"
                 "依赖关系请到 mooncakes 包页查看，报告内包名均指向该页。\n")
    lines.append(f"> **数据时效**　采集于 {COLLECTED_AT}，早于本报告的生成时间。"
                 f"本报告为离线生成的静态快照，不随注册表更新，不含此后的新增、版本变更与 "
                 f"yanked 标记；选型判断请以 mooncakes.io 及仓库实际状态为准。\n")
    lines.append("有完整方案的场景分两层：**完整方案**（能直接选型、定骨架的）与"
                 "**基础库**（提供单点能力，由调用方组合）；尚无完整方案的场景不设分层，"
                 "候选全部为基础库。框架、引擎、运行时、"
                 "脚手架、ORM 均属「完整方案」的不同形态。「基础库」不等同于「依赖」："
                 "在 mooncakes 生态中，完整方案本身同样是依赖，分层的唯一标准是"
                 "该包能否接管程序结构。\n")
    lines.append("场景内排序 = 关键词匹配度 + 下载量；"
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
                         "因为该领域在生态里还没有形成可靠的关键词信号。\n")
        if sc.get("note"):
            lines.append(f"> {sc['note']}\n")
        if sol:
            lines.append(f"### 完整方案（{len(sol)}）\n")
            _md_table(lines, sol, sc.get("top", top_n))
            if len(sol) <= 2:
                lines.append(f"> 完整方案仅 {len(sol)} 个，说明该类需求目前在生态中"
                             f"主要依靠基础库组合实现，下方基础库清单的实用价值更高。\n")
        else:
            # 没有完整方案的场景不做两层划分，全部候选都只是基础库
            lines.append(f"> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。"
                         f"下列 {len(lib)} 个候选均为基础库，需按需组合。\n")
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
#
# 产物三层分离：
#   dist/index.html          骨架（CSS 内联，不含任何数据）
#   dist/assets/app.js       前端逻辑（路由、渲染、检索）
#   dist/data/scenarios.json 全部数据（由 write_scenarios_json 生成）
# 因此改样式不必碰数据，数据更新不必重写页面。

HTML_CSS = """
  :root {
    --bg:#f6f7f9; --panel:#fff; --ink:#171a1f; --muted:#6b7280;
    --line:#e4e7ec; --line-soft:#eef0f3; --accent:#2f5fe0; --accent-soft:#eef2fd;
    --warm:#a15a08; --green:#0b6046; --green-soft:#d9f5e9;
    --side-w:238px; --row-h:56px; --rows:5;
  }
  * { box-sizing:border-box; }
  html, body { height:100%; }
  body { margin:0; background:var(--bg); color:var(--ink);
    font:14.5px/1.6 -apple-system,BlinkMacSystemFont,"Segoe UI","PingFang SC",
    "Hiragino Sans GB","Microsoft YaHei",sans-serif;
    -webkit-font-smoothing:antialiased; }
  a { color:inherit; }
  .app { display:flex; height:100vh; }

  /* ---------- 左侧分类：独立滚动 ---------- */
  .side { width:var(--side-w); flex:0 0 var(--side-w); background:var(--panel);
    border-right:1px solid var(--line); overflow-y:auto; overscroll-behavior:contain;
    padding:18px 10px 32px; }
  .side::-webkit-scrollbar { width:8px; }
  .side::-webkit-scrollbar-thumb { background:#d8dce3; border-radius:4px; }
  .side-home { display:block; margin:0 8px 14px; padding:9px 12px; border-radius:8px;
    font-size:13.5px; font-weight:600; text-decoration:none; color:var(--ink); }
  .side-home:hover { background:var(--accent-soft); color:var(--accent); }
  .side-home.on { background:var(--accent-soft); color:var(--accent); }
  .gt { margin:16px 12px 6px; font-size:11px; letter-spacing:.08em; text-transform:uppercase;
    color:#9aa2ae; font-weight:600; }
  .snav a { display:flex; align-items:center; gap:8px; padding:6px 12px; margin:1px 0;
    border-radius:7px; font-size:13.5px; text-decoration:none; color:#3d444e; }
  .snav a:hover { background:#f2f4f7; color:var(--ink); }
  .snav a.on { background:var(--accent-soft); color:var(--accent); font-weight:600; }
  .snav a .n { margin-left:auto; font-size:11px; color:#9aa2ae; font-variant-numeric:tabular-nums; }
  .snav a.on .n { color:var(--accent); }

  /* 抽屉组件在宽屏不出现：侧栏本身常驻，无需菜单入口与遮罩 */
  .menu-btn, .drw-head, .scrim { display:none; }
  .menu-btn i { display:block; width:15px; height:1.7px; background:#3d444e; border-radius:1px; }
  .drw-head button { margin-left:auto; width:27px; height:27px; padding:0; border:0;
    border-radius:7px; background:#f2f4f7; color:var(--muted); font-size:13px; line-height:1;
    cursor:pointer; }
  .drw-head button:hover { background:var(--line); color:var(--ink); }

  /* ---------- 主区：独立滚动 ---------- */
  .main { flex:1; overflow-y:auto; overscroll-behavior:contain; padding:0 26px 64px; }
  .top { position:sticky; top:0; z-index:10; display:flex; align-items:center; gap:14px;
    padding:14px 0 12px; margin-bottom:18px; background:rgba(246,247,249,.93);
    backdrop-filter:saturate(160%) blur(8px); border-bottom:1px solid var(--line); }
  .brand { font-size:15px; font-weight:650; letter-spacing:-.2px; text-decoration:none;
    white-space:nowrap; }
  .ts { font-size:11.5px; color:#8b939f; font-variant-numeric:tabular-nums; }
  .sbtn { margin-left:auto; font-size:12.5px; text-decoration:none; color:var(--muted);
    border:1px solid var(--line); border-radius:7px; padding:5px 12px; background:var(--panel);
    white-space:nowrap; }
  .sbtn:hover { color:var(--accent); border-color:var(--accent); }

  /* ---------- 首页卡片 ---------- */
  .lede { color:var(--muted); font-size:13px; margin:0 0 18px; max-width:88ch; }
  .grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(min(420px,100%),1fr));
    gap:16px; }
  .card { background:var(--panel); border:1px solid var(--line); border-radius:11px;
    padding:15px 17px 13px; display:flex; flex-direction:column; min-width:0; }
  .hd { display:flex; align-items:center; gap:9px; flex-wrap:wrap; margin-bottom:3px; }
  .ico { font-size:16px; line-height:1; }
  .hd h2 { font-size:14.5px; margin:0; font-weight:650; white-space:nowrap; }
  .tabs { display:flex; gap:2px; background:var(--line-soft); border-radius:7px; padding:2px; }
  .tabs button { border:0; background:none; font:inherit; font-size:11.5px; color:var(--muted);
    padding:2px 9px; border-radius:5px; cursor:pointer; font-variant-numeric:tabular-nums; }
  .tabs button:hover { color:var(--ink); }
  .tabs button.on { background:var(--panel); color:var(--accent); font-weight:600;
    box-shadow:0 1px 2px rgba(16,24,40,.08); }
  .intro { margin:0 0 9px; color:var(--muted); font-size:12px; line-height:1.55;
    display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden;
    min-height:37px; }

  /* 固定 5 行高度：超出部分裁掉，完整清单去详情页 */
  .pkglist { list-style:none; margin:0; padding:0; height:calc(var(--row-h) * var(--rows));
    overflow:hidden; }
  .pkglist.all { height:auto; overflow:visible; }
  .pkglist li { height:var(--row-h); display:flex; gap:9px; align-items:center;
    border-top:1px solid var(--line-soft); }
  .pkglist li:first-child { border-top:0; }
  .pkglist li.empty { color:var(--muted); font-size:12.5px; height:auto; padding:14px 0;
    border-top:0; }
  .rk { flex:0 0 19px; height:19px; border-radius:5px; background:var(--accent-soft);
    color:var(--accent); font-size:11px; font-weight:600; display:flex; align-items:center;
    justify-content:center; font-variant-numeric:tabular-nums; }
  .rk.dim { background:#f3f4f6; color:#9aa2ae; font-weight:500; }
  .b { min-width:0; flex:1; }
  .n { font-size:13px; font-weight:600; white-space:nowrap; overflow:hidden;
    text-overflow:ellipsis; }
  .n a { text-decoration:none; }
  .n a:hover { color:var(--accent); text-decoration:underline; text-underline-offset:2px; }
  .v { font-weight:400; color:#9aa2ae; font-size:11px; margin-left:5px; }
  .yk { font-size:10px; color:#8f3c16; background:#fdeede; border-radius:4px;
    padding:0 4px; margin-left:5px; vertical-align:1px; }
  .d { font-size:11.5px; color:var(--muted); white-space:nowrap; overflow:hidden;
    text-overflow:ellipsis; line-height:1.4; }
  .dl { flex:0 0 auto; font-size:11.5px; color:var(--warm); font-variant-numeric:tabular-nums;
    font-weight:600; }
  .more { margin-top:9px; padding-top:9px; border-top:1px dashed var(--line);
    font-size:12px; color:var(--accent); text-decoration:none; }
  .more:hover { text-decoration:underline; }

  /* ---------- 场景详情页 ---------- */
  .crumb { font-size:12.5px; color:var(--muted); margin:0 0 10px; }
  .crumb a { text-decoration:none; color:var(--accent); }
  .dhead h1 { font-size:22px; margin:0 0 6px; letter-spacing:-.3px; font-weight:650; }
  .dhead p { margin:0 0 14px; color:var(--muted); font-size:13px; max-width:78ch; }
  .sect { margin:22px 0 0; }
  .sect h3 { font-size:13px; margin:0 0 8px; font-weight:650; display:flex;
    align-items:center; gap:8px; }
  .sect h3 .k { font-size:11px; font-weight:500; color:var(--muted); }
  .panel { background:var(--panel); border:1px solid var(--line); border-radius:11px;
    padding:4px 16px; }
  .badge { font-size:10.5px; color:var(--green); background:var(--green-soft);
    border-radius:4px; padding:1px 6px; font-weight:500; }
  .note { margin:10px 0 0; padding:9px 13px; background:#fffaf0; border:1px solid #f2e3bd;
    border-radius:7px; font-size:12.5px; color:var(--warm); }
  .tag { margin-left:auto; font-size:11px; color:var(--muted); background:var(--line-soft);
    border-radius:5px; padding:2px 8px; font-variant-numeric:tabular-nums; }
  .soless { margin:16px 0 0; font-size:12.5px; color:var(--muted); }

  /* ---------- 检索页 ---------- */
  .sbox { width:100%; padding:12px 15px; font:inherit; font-size:14px; border:1px solid var(--line);
    border-radius:9px; background:var(--panel); outline:none; }
  .sbox:focus { border-color:var(--accent); box-shadow:0 0 0 3px var(--accent-soft); }
  .smeta { font-size:12px; color:var(--muted); margin:11px 0; }
  .loading { color:var(--muted); font-size:13px; }

  footer { margin-top:44px; padding-top:18px; border-top:1px solid var(--line);
    color:var(--muted); font-size:12px; line-height:1.85; }
  footer p { margin:0 0 7px; max-width:100ch; }
  footer b { color:var(--ink); font-weight:600; }
  code { background:var(--line-soft); padding:1px 5px; border-radius:4px; font-size:11.5px; }

  @media (max-width:880px) {
    body { overflow-x:hidden; }
    .app { display:block; height:auto; }

    /* 标题栏：菜单入口 + 标题 + 检索，滚动时吸顶 */
    .main { overflow:visible; height:auto; padding:0 14px 44px; }
    .top { position:sticky; top:0; z-index:14; flex-wrap:wrap; gap:4px 10px;
      padding:10px 0 9px; margin-bottom:14px; }
    .menu-btn { display:inline-flex; flex:0 0 34px; flex-direction:column; align-items:center;
      justify-content:center; gap:4px; width:34px; height:34px; padding:0; cursor:pointer;
      border:1px solid var(--line); border-radius:8px; background:var(--panel); }
    .menu-btn:active { background:var(--line-soft); }
    .brand { font-size:14.5px; }
    .ts { flex:1 1 100%; order:3; font-size:11px; }

    /* 窄屏：侧栏改为左侧抽屉，默认移出视口，由标题栏菜单唤出 */
    .drw-head { display:flex; align-items:center; gap:8px; position:sticky; top:0;
      z-index:1; margin:0 -10px 6px; padding:12px 10px 10px 18px; background:var(--panel);
      border-bottom:1px solid var(--line-soft); font-size:12.5px; font-weight:600;
      color:var(--muted); }
    .side { position:fixed; top:0; bottom:0; left:0; width:288px; max-width:86vw;
      height:auto; max-height:none; flex:none; z-index:40; padding:0 10px 30px;
      background:var(--panel); border-right:1px solid var(--line); border-bottom:0;
      overflow-x:hidden; overflow-y:auto; white-space:normal;
      transform:translateX(-100%); transition:transform .26s cubic-bezier(.4,0,.2,1); }
    body.drawer-open .side { transform:translateX(0); box-shadow:0 0 60px rgba(16,24,40,.22); }
    .side-home { margin-bottom:12px; }
    .snav a { padding:9px 12px; }

    .scrim { display:block; position:fixed; inset:0; z-index:36;
      background:rgba(16,24,40,.36); opacity:0; pointer-events:none;
      transition:opacity .26s ease; }
    body.drawer-open .scrim { opacity:1; pointer-events:auto; }
    body.drawer-open { overflow:hidden; }

    .grid { grid-template-columns:minmax(0,1fr); }
  }
"""

HTML_JS = """
'use strict';

const ROOT = 'data/scenarios.json';
const MK = n => 'https://mooncakes.io/docs/' + n;

const $ = s => document.querySelector(s);
const esc = s => String(s).replace(/[&<>"]/g,
  c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
const human = n => n >= 10000 ? (n / 10000).toFixed(1) + '\\u4e07'
  : n >= 1000 ? (n / 1000).toFixed(1) + 'k' : String(n);

let D = null;          // 全部数据
const SC = {};         // 场景索引
const PREVIEW = 5;     // 首页每个场景固定展示的包数

/* ---------------------------------------------------------------- 渲染片段 */

function pkg(name, i) {
  const m = D.modules[name] || [0, '', '', 0];
  const ver = m[1] ? `<span class="v">v${esc(m[1])}</span>` : '';
  const yk = m[3] ? '<span class="yk">yanked</span>' : '';
  return `<li><span class="rk${i > 5 ? ' dim' : ''}">${i}</span>
    <div class="b">
      <div class="n"><a href="${MK(name)}" target="_blank" rel="noopener">${esc(name)}</a>${ver}${yk}</div>
      <div class="d">${esc(m[2] || '\\u2014')}</div>
    </div>
    <span class="dl">${human(m[0])}</span></li>`;
}

function rows(list, n) {
  if (!list.length) return '<li class="empty">\\u6682\\u65e0\\u5019\\u9009</li>';
  return list.slice(0, n).map((x, i) => pkg(x, i + 1)).join('');
}

function card(sc) {
  const ns = sc.sol.length, nl = sc.lib.length;
  const def = ns > 0 ? 'sol' : 'lib';
  const tab = (k, n, label) =>
    `<button class="${def === k ? 'on' : ''}" data-t="${k}">${label} ${n}</button>`;
  const pane = (k, list) =>
    `<ul class="pkglist" data-tab="${k}"${def === k ? '' : ' hidden'}>${
      k === 'sol' && !ns
        ? '<li class="empty">\\u672c\\u573a\\u666f\\u5c1a\\u65e0\\u5b8c\\u6574\\u65b9\\u6848\\uff0c'
          + '\\u9700\\u7531\\u57fa\\u7840\\u5e93\\u7ec4\\u5408\\u5b9e\\u73b0</li>'
        : rows(list, PREVIEW)}</ul>`;
  // 没有完整方案的场景：不设两组标签，候选全部只是基础库
  if (!ns) {
    return `<section class="card" data-id="${sc.id}">
      <div class="hd"><span class="ico">${sc.icon}</span><h2>${esc(sc.title)}</h2>
        <span class="tag">\u57fa\u7840\u5e93 ${nl}</span></div>
      <p class="intro">${esc(sc.intro)}</p>
      <ul class="pkglist">${rows(sc.lib, PREVIEW)}</ul>
      <a class="more" href="#/s/${sc.id}">\u67e5\u770b\u5168\u90e8 ${nl} \u4e2a \u2192</a>
    </section>`;
  }
  return `<section class="card" data-id="${sc.id}">
    <div class="hd"><span class="ico">${sc.icon}</span><h2>${esc(sc.title)}</h2>
      <div class="tabs">${tab('sol', ns, '\\u5b8c\\u6574\\u65b9\\u6848')}${tab('lib', nl, '\\u57fa\\u7840\\u5e93')}</div></div>
    <p class="intro">${esc(sc.intro)}</p>
    ${pane('sol', sc.sol)}
    ${pane('lib', sc.lib)}
    <a class="more" href="#/s/${sc.id}">\\u67e5\\u770b\\u5168\\u90e8 ${ns + nl} \\u4e2a \\u2192</a>
  </section>`;
}

/* ---------------------------------------------------------------- 页面 */

function viewHome() {
  const m = D.meta;
  return `<p class="lede">\\u6309\\u4f7f\\u7528\\u573a\\u666f\\u7ec4\\u7ec7\\u7684 MoonBit \\u5305\\u7d22\\u5f15\\uff0c\\u5171 ${D.groups.length}
    \\u7ec4 ${m.scenarios} \\u4e2a\\u573a\\u666f\\u3002\u6709\u5b8c\u6574\u65b9\u6848\u7684\u573a\u666f\u5206\u4e24\u5c42\uff1a<b>\\u5b8c\\u6574\\u65b9\\u6848</b>\\uff08\\u80fd\\u76f4\\u63a5\\u9009\\u578b\\u3001\\u5b9a\\u9aa8\\u67b6\\uff09\\u4e0e
    <b>\\u57fa\\u7840\\u5e93</b>\\uff08\u63d0\u4f9b\u5355\u70b9\u80fd\u529b\uff09\uff1b${m.scenarios - m.with_solutions} \u4e2a\u573a\u666f\u5c1a\u65e0\u5b8c\u6574\u65b9\u6848\uff0c\u5168\u90e8\u5f52\u4e3a\u57fa\u7840\u5e93\u3002\\u9996\\u9875\\u6bcf\\u4e2a\\u573a\\u666f\\u53ea\\u5c55\\u793a\\u524d ${PREVIEW} \\u4e2a\\uff0c
    \\u5b8c\\u6574\\u6e05\\u5355\\u5728\\u573a\\u666f\\u8be6\\u60c5\\u9875\\u3002</p>
    <div class="grid">${D.scenarios.map(card).join('')}</div>${footer()}`;
}

function sceneNote(sc) {
  const base = sc.curated
    ? '\\u672c\\u573a\\u666f\\u4e3a\\u4eba\\u5de5\\u56f4\\u5b9a\\uff1a\\u8be5\\u9886\\u57df\\u5728\\u751f\\u6001\\u4e2d\\u5c1a\\u672a\\u5f62\\u6210\\u53ef\\u9760\\u7684\\u5173\\u952e\\u8bcd\\u4fe1\\u53f7\\uff0c\\u5019\\u9009\\u5305\\u4e0e\\u5176\\u987a\\u5e8f\\u7531\\u4eba\\u5de5\\u786e\\u5b9a\\u3002'
    : '';
  const t = (base + ' ' + (sc.note || '')).trim();
  return t ? `<p class="note">${esc(t)}</p>` : '';
}

function viewScene(id) {
  const sc = SC[id];
  if (!sc) return `<p class="loading">\\u672a\\u77e5\\u573a\\u666f\\uff1a${esc(id)}</p>`;
  const hasSol = sc.sol.length > 0;
  const sec = (k, list, title) => {
    if (!list.length && k === 'lib') return '';
    const body = `<ul class="pkglist all">${list.map((x, i) => pkg(x, i + 1)).join('')}</ul>`;
    return `<div class="sect"><h3>${title}<span class="k">${list.length} \\u4e2a</span></h3>
      <div class="panel">${body}</div></div>`;
  };
  return `<p class="crumb"><a href="#/">\\u9996\\u9875</a> \\u203a ${esc(sc.title)}</p>
    <div class="dhead"><h1>${sc.icon} ${esc(sc.title)}</h1>
      <p>${esc(sc.intro)}</p></div>
    ${sceneNote(sc)}
    ${hasSol ? sec('sol', sc.sol, '\\u5b8c\\u6574\\u65b9\\u6848') : ''}
    ${hasSol ? '' : `<p class="soless">\u672c\u573a\u666f\u5728\u751f\u6001\u4e2d\u5c1a\u65e0\u5b8c\u6574\u65b9\u6848\uff08\u65e0\u6846\u67b6\u6216\u5f15\u64ce\u7ea7\u5b9e\u73b0\uff09\uff0c\u4e0b\u5217\u5747\u4e3a\u57fa\u7840\u5e93\uff0c\u9700\u8981\u6309\u9700\u7ec4\u5408\u3002</p>`}
    ${sec('lib', sc.lib, '\\u57fa\\u7840\\u5e93')}
    ${footer()}`;
}

function viewSearch(q) {
  return `<p class="crumb"><a href="#/">\\u9996\\u9875</a> \\u203a \\u68c0\\u7d22</p>
    <input class="sbox" id="q" autocomplete="off" placeholder="\\u68c0\\u7d22\\u5168\\u90e8 ${D.meta.modules} \\u4e2a\\u5305\\uff1a\\u540d\\u79f0\\u6216\\u63cf\\u8ff0\\uff0c\\u4f8b\\u5982 json\\u3001http\\u3001parser">
    <div id="sout"><p class="smeta">\\u8f93\\u5165\\u5173\\u952e\\u8bcd\\u5f00\\u59cb\\u68c0\\u7d22\\u3002\\u6309\\u4e0b\\u8f7d\\u91cf\\u964d\\u5e8f\\u3002</p></div>`;
}

function doSearch(q) {
  const out = $('#sout');
  if (!out) return;
  const t = q.trim().toLowerCase();
  if (!t) {
    out.innerHTML = '<p class="smeta">\\u8f93\\u5165\\u5173\\u952e\\u8bcd\\u5f00\\u59cb\\u68c0\\u7d22\\u3002\\u6309\\u4e0b\\u8f7d\\u91cf\\u964d\\u5e8f\\u3002</p>';
    return;
  }
  const hit = [];
  for (const [n, m] of Object.entries(D.modules)) {
    if (n.toLowerCase().includes(t) || (m[2] || '').toLowerCase().includes(t)) hit.push(n);
  }
  hit.sort((a, b) => D.modules[b][0] - D.modules[a][0]);
  const top = hit.slice(0, 200);
  out.innerHTML = `<p class="smeta">\\u300c${esc(q.trim())}\\u300d\\uff1a\\u547d\\u4e2d ${hit.length} \\u4e2a${
    hit.length > top.length ? '\\uff0c\\u4ec5\\u5217\\u524d ' + top.length + ' \\u4e2a' : ''}</p>
    <div class="panel"><ul class="pkglist all">${
      top.length ? top.map((n, i) => pkg(n, i + 1)).join('')
        : '<li class="empty">\\u6ca1\\u6709\\u5339\\u914d\\u7684\\u5305</li>'}</ul></div>`;
}

function footer() {
  const m = D.meta;
  return `<footer>
    <p><b>\\u6570\\u636e\\u6765\\u6e90</b>\\u3000mooncakes.io \\u5b98\\u65b9 API\\uff08\\u6a21\\u5757\\u5143\\u6570\\u636e\\u4e0e\\u4e0b\\u8f7d\\u91cf\\uff09\\u3002\\u672c\\u7ad9\\u4ec5\\u505a\\u573a\\u666f\\u5bfc\\u822a\\uff0c
      \\u4e0d\\u590d\\u5236\\u6ce8\\u518c\\u8868\\u80fd\\u529b\\uff1a\\u7248\\u672c\\u5386\\u53f2\\u3001\\u5b8c\\u6574 API \\u6587\\u6863\\u4e0e\\u4f9d\\u8d56\\u5173\\u7cfb\\u8bf7\\u5230 mooncakes \\u5305\\u9875\\u67e5\\u770b\\uff0c
      \\u9875\\u9762\\u5185\\u6bcf\\u4e2a\\u5305\\u540d\\u5747\\u6307\\u5411\\u8be5\\u9875\\u3002</p>
    <p><b>\\u6570\\u636e\\u65f6\\u6548</b>\\u3000\\u91c7\\u96c6\\u4e8e ${m.collected_at}\\uff0c\\u6784\\u5efa\\u4e8e ${m.built_at}\\u3002\\u672c\\u7ad9\\u4e3a\\u79bb\\u7ebf\\u5feb\\u7167\\uff0c
      \\u4e0d\\u968f\\u6ce8\\u518c\\u8868\\u5b9e\\u65f6\\u66f4\\u65b0\\uff0c\\u4e0d\\u542b\\u6b64\\u540e\\u7684\\u65b0\\u589e\\u3001\\u7248\\u672c\\u53d8\\u66f4\\u4e0e yanked \\u6807\\u8bb0\\u3002</p>
    <p><b>\\u5206\\u5c42\\u6807\\u51c6</b>\\u3000\\u5b8c\\u6574\\u65b9\\u6848\\u6307\\u80fd\\u63a5\\u7ba1\\u7a0b\\u5e8f\\u7ed3\\u6784\\u3001\\u53ef\\u76f4\\u63a5\\u9009\\u578b\\u7684\\u5305\\uff08\\u6846\\u67b6\\u3001\\u5f15\\u64ce\\u3001\\u8fd0\\u884c\\u65f6\\u3001
      \\u811a\\u624b\\u67b6\\u3001ORM\\uff09\\uff1b\\u57fa\\u7840\\u5e93\\u6307\\u63d0\\u4f9b\\u5355\\u70b9\\u80fd\\u529b\\u3001\\u7531\\u8c03\\u7528\\u65b9\\u7ec4\\u5408\\u7684\\u5305\\u3002\\u300c\\u57fa\\u7840\\u5e93\\u300d\\u4e0d\\u7b49\\u540c\\u4e8e
      \\u300c\\u4f9d\\u8d56\\u300d\\uff1a\\u5728 mooncakes \\u751f\\u6001\\u4e2d\\u5b8c\\u6574\\u65b9\\u6848\\u672c\\u8eab\\u4ea6\\u4e3a\\u4f9d\\u8d56\\uff0c\\u5206\\u5c42\\u552f\\u4e00\\u6807\\u51c6\\u662f\\u80fd\\u5426\\u63a5\\u7ba1\\u7a0b\\u5e8f\\u7ed3\\u6784\\u3002
      ${m.scenarios - m.with_solutions} \\u4e2a\\u573a\\u666f\\u5c1a\\u65e0\\u5b8c\\u6574\\u65b9\\u6848\\u3002</p>
    <p><b>\\u6392\\u5e8f\\u65b9\\u6cd5</b>\\u3000\\u573a\\u666f\\u5185\\u6392\\u5e8f = \\u5173\\u952e\\u8bcd\\u5339\\u914d\\u5ea6 + \\u4e0b\\u8f7d\\u91cf\\uff1b\\u4e0d\\u5f15\\u5165\\u53cd\\u5411\\u4f9d\\u8d56\\u6570\\u7b49\\u6d3e\\u751f\\u6307\\u6807\\u3002
      \\u684c\\u9762\\u4e0e\\u624b\\u673a\\u7b49\\u73af\\u5883\\u7531\\u4e8e\\u7f3a\\u4e4f\\u7a33\\u5b9a\\u5173\\u952e\\u8bcd\\uff0c\\u6539\\u4e3a\\u4eba\\u5de5\\u56f4\\u5b9a\\u3002</p>
    <p><b>\\u6784\\u5efa</b>\\u3000<code>python3 pipeline/analyze.py</code>\\u3000\\u00b7\\u3000<b>\\u67e5\\u8be2</b>\\u3000<code>python3 pipeline/query.py json</code></p>
  </footer>`;
}

/* ---------------------------------------------------------------- 路由 */

function renderSide(active) {
  let h = `<a class="side-home${active === 'home' ? ' on' : ''}" href="#/">\\u5168\\u90e8\\u573a\\u666f</a>`;
  for (const [gid, gtitle] of D.groups) {
    const list = D.scenarios.filter(s => s.group === gid);
    if (!list.length) continue;
    h += `<div class="gt">${esc(gtitle)}</div><div class="snav">`;
    for (const s of list) {
      const n = s.sol.length ? s.sol.length : s.lib.length;
      h += `<a href="#/s/${s.id}" class="${active === s.id ? 'on' : ''}">${s.icon} ${esc(s.title)}<span class="n">${n}</span></a>`;
    }
    h += '</div>';
  }
  $('#snav').innerHTML = h;
}

/* ---------------------------------------------------------------- 抽屉（窄屏导航） */

function setDrawer(on) {
  document.body.classList.toggle('drawer-open', on);
  const b = $('#menuBtn');
  if (b) b.setAttribute('aria-expanded', on ? 'true' : 'false');
}

const drawerOpen = () => document.body.classList.contains('drawer-open');

function route() {
  setDrawer(false);          // 切页即收起抽屉，避免遮挡新页面
  const h = location.hash || '#/';
  const view = $('#view');
  if (h.startsWith('#/s/')) {
    const id = h.slice(4);
    renderSide(id);
    view.innerHTML = viewScene(id);
    window.scrollTo(0, 0);
    document.querySelector('.main').scrollTop = 0;
  } else if (h.startsWith('#/search')) {
    renderSide('search');
    view.innerHTML = viewSearch();
    const q = decodeURIComponent((h.split('?q=')[1] || ''));
    const box = $('#q');
    box.value = q;
    if (q) doSearch(q);
    box.addEventListener('input', () => doSearch(box.value));
    box.focus();
  } else {
    renderSide('home');
    view.innerHTML = viewHome();
    document.querySelector('.main').scrollTop = 0;
  }
}

/* tab 切换：完整方案 / 基础库 */
document.addEventListener('click', e => {
  const btn = e.target.closest('.tabs button');
  if (!btn) return;
  const cardEl = btn.closest('.card');
  const t = btn.dataset.t;
  cardEl.querySelectorAll('.tabs button').forEach(b => b.classList.toggle('on', b === btn));
  cardEl.querySelectorAll('.pkglist').forEach(u => { u.hidden = u.dataset.tab !== t; });
});

window.addEventListener('hashchange', route);

/* 抽屉开关：菜单按钮唤出，遮罩 / 关闭按钮 / Esc / 选中场景后收起 */
$('#menuBtn').addEventListener('click', () => setDrawer(!drawerOpen()));
$('#scrim').addEventListener('click', () => setDrawer(false));
$('#drwClose').addEventListener('click', () => setDrawer(false));
$('#snav').addEventListener('click', e => { if (e.target.closest('a')) setDrawer(false); });
document.addEventListener('keydown', e => { if (e.key === 'Escape') setDrawer(false); });
window.addEventListener('resize', () => { if (window.innerWidth > 880) setDrawer(false); });

(async function boot() {
  try {
    const r = await fetch(ROOT);
    if (!r.ok) throw new Error('HTTP ' + r.status);
    D = await r.json();
    D.scenarios.forEach(s => { SC[s.id] = s; });
    $('#ts').textContent =
      `\\u91c7\\u96c6\\uff1a${D.meta.collected_at}\\uff1b\\u6784\\u5efa\\uff1a${D.meta.built_at}`;
    route();
  } catch (err) {
    $('#view').innerHTML = `<p class="loading">\\u6570\\u636e\\u52a0\\u8f7d\\u5931\\u8d25\\uff1a${esc(err.message)}\\u3002`
      + `\\u8bf7\\u901a\\u8fc7 HTTP \\u6253\\u5f00\\u9875\\u9762\\uff08\\u5982 <code>python3 -m http.server</code>\\uff09\\uff0c`
      + `\\u76f4\\u63a5\\u53cc\\u51fb file:// \\u65e0\\u6cd5\\u8bfb\\u53d6\\u6570\\u636e\\u3002</p>`;
  }
})();
"""


def write_html(mods, ranked):
    """写出 dist/index.html —— 只有骨架，不含任何数据。"""
    doc = f"""<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>MoonBit 生态索引 · 场景化选型参考</title>
<meta name="description" content="按使用场景组织的 MoonBit 包索引：{len(SCENARIOS)} 个场景，区分完整方案与基础库。">
<style>{HTML_CSS}</style>
</head>
<body>
<div class="app">
  <aside class="side" id="side">
    <div class="drw-head"><span>场景分类</span>
      <button type="button" id="drwClose" aria-label="关闭场景导航">&#10005;</button></div>
    <div id="snav"></div>
  </aside>
  <div class="scrim" id="scrim"></div>
  <main class="main">
    <header class="top">
      <button type="button" class="menu-btn" id="menuBtn"
              aria-label="打开场景导航" aria-controls="side" aria-expanded="false">
        <i></i><i></i><i></i></button>
      <a class="brand" href="#/">MoonBit 生态索引</a>
      <span class="ts" id="ts"></span>
      <a class="sbtn" href="#/search">检索</a>
    </header>
    <div id="view"><p class="loading">正在加载数据…</p></div>
  </main>
</div>
<script src="assets/app.js"></script>
</body>
</html>
"""
    (DIST / "assets").mkdir(parents=True, exist_ok=True)
    (DIST / "index.html").write_text(doc, encoding="utf-8")
    (DIST / "assets" / "app.js").write_text(HTML_JS.lstrip(), encoding="utf-8")
    return DIST / "index.html"


def publish_site():
    """把分析产物同步到 dist/，该目录即静态托管发布目录。"""
    import shutil
    (DIST / "data").mkdir(parents=True, exist_ok=True)
    (DIST / "assets").mkdir(parents=True, exist_ok=True)
    # scenarios.json 内已含精简模块表，不再单独复制 modules.json，避免同一份数据两遍
    shutil.copyfile(OUT / "scenarios.json", DIST / "data" / "scenarios.json")
    shutil.copyfile(ROOT / "scenarios.md", DIST / "scenarios.md")
    return DIST


# ---------------------------------------------------------------- 输出：结构化 JSON
# 站点数据。与 index.html 完全分离：页面只是骨架，数据由前端 fetch 本文件后渲染。
# 体积靠模块表共享控制——场景里只存包名，包的详情（下载量、版本、描述）统一
# 在 modules 字典里查一次，因此场景内可以完整列出全部候选而不重复存储。

def write_scenarios_json(mods, ranked):
    n_sol_scene = sum(1 for _sc, rows in ranked if split_tiers(rows)[0])
    n_sol_pkg = len({m["name"] for _sc, rows in ranked
                     for _s, m, t in rows if t == "solution"})
    built = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")

    modules = {}
    for name, m in mods.items():
        desc = re.sub(r"\s+", " ", m["description"]).strip()
        modules[name] = [m["downloads"], m["version"], desc[:150], int(m["yanked"])]

    payload = {
        "schema_version": 2,
        "meta": {
            "collected_at": COLLECTED_AT,
            "built_at": built,
            "modules": len(mods),
            "above_threshold":
                sum(1 for m in mods.values() if m["downloads"] > MIN_DOWNLOADS),
            "yanked": sum(1 for m in mods.values() if m["yanked"]),
            "scenarios": len(SCENARIOS),
            "with_solutions": n_sol_scene,
            "solution_packages": n_sol_pkg,
            "min_downloads": MIN_DOWNLOADS,
        },
        "groups": [[gid, gtitle] for gid, gtitle in GROUPS],
        "scenarios": [],
        "modules": modules,
    }
    for sc, rows in ranked:
        sol, lib = split_tiers(rows)
        payload["scenarios"].append({
            "id": sc["id"],
            "group": sc.get("group", "lang"),
            "title": sc["title"],
            "icon": sc["icon"],
            "intro": sc["intro"],
            "curated": bool(sc.get("curated")),
            "note": sc.get("note", ""),
            "sol": [m["name"] for _s, m in sol],
            "lib": [m["name"] for _s, m in lib],
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

    # 人工圈定场景的覆盖缺口：命中 audit 词却没进清单，说明「覆盖了却没出现」。
    # 人工清单是封闭集合，靠人维护；这里把缺口暴露在构建日志里，避免长期漏收。
    gaps = []
    for sc in SCENARIOS:
        if not sc.get("curated"):
            continue
        chosen = set(sc.get("pick", ()))
        skip = sc.get("skip", {})
        for name, m in mods.items():
            if name in chosen or name in skip or m["yanked"]:
                continue
            if m["downloads"] < MIN_DOWNLOADS:
                continue
            hit = next((t for t in sc.get("audit", ())
                        if (t in m["_desc_l"] if " " in t
                            else (_kw_hit(t, m) or _hit(t, m["_ntok"])
                                  or _hit(t, m["_dtok"])))), None)
            if hit:
                gaps.append((sc["title"], name, hit, m["downloads"]))
    if gaps:
        gaps.sort(key=lambda x: -x[3])
        print(f"\n人工场景的覆盖缺口（{len(gaps)}，确认后加进 pick，或记进 skip 说明为何不收）：")
        for title, name, hit, dl in gaps[:14]:
            print(f"  {title}  {name:<34} 命中 {hit}  下载 {dl}")
        if len(gaps) > 14:
            print(f"  … 另有 {len(gaps) - 14} 个")


if __name__ == "__main__":
    main()
