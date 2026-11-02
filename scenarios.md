# MoonBit 生态：场景化选包指南

> 覆盖 3520 个已发布模块；仅为 **下载量 > 20** 的包做推荐，被 yanked 的包不计入推荐。

数据源：mooncakes.io 官方 API（模块元数据 + 下载量）、gaato/mooncakes-graph 每日依赖快照（反向依赖数）。

每个场景分两层：**完整方案**（能直接选型、定骨架的）与**基础库**（提供单点能力，由调用方组合）。框架、引擎、运行时、脚手架、ORM 均属「完整方案」的不同形态。「基础库」不等同于「依赖」：在 mooncakes 生态中，完整方案本身同样是依赖，分层的唯一标准是该包能否接管程序结构。

打分 = 关键词匹配度 + 下载量 + 被依赖数；同义词已做词干归一（如 async/asynchronous），并对易混淆场景做了排除（如 UI 场景排除 TUI）。

## 目录

- [Web 后端 / HTTP 服务](#http) — 方案 13 / 基础库 126
- [JSON / 序列化格式](#json) — 方案 1 / 基础库 184
- [异步 / 并发](#async) — 方案 4 / 基础库 41
- [CLI 参数解析](#cli) — 方案 4 / 基础库 221
- [终端 UI / TUI](#tui) — 方案 5 / 基础库 50
- [测试 / 断言 / 属性测试](#test) — 方案 4 / 基础库 62
- [正则匹配](#regex) — 无方案 / 基础库 9
- [Unicode / 文本处理](#unicode) — 无方案 / 基础库 104
- [加密 / 哈希 / 编码](#crypto) — 无方案 / 基础库 117
- [数据库 / 存储](#db) — 方案 5 / 基础库 75
- [WebAssembly / JS 互操作](#wasm) — 方案 1 / 基础库 303
- [解析器 / 编译器 / 语法](#parser) — 方案 2 / 基础库 286
- [数学 / 数值计算](#math) — 无方案 / 基础库 64
- [图形 / 渲染](#graphics) — 无方案 / 基础库 121
- [游戏引擎 / ECS](#game) — 方案 6 / 基础库 48
- [Web UI / 前端框架](#ui) — 方案 6 / 基础库 50
- [桌面 GUI / 跨平台窗口](#gui) — 方案 6 / 基础库 29
- [跨端 UI（一套代码多端）](#xui) — 方案 4 / 基础库 7
- [Markdown / 文档转换](#doc) — 无方案 / 基础库 94
- [时间 / 日期](#time) — 无方案 / 基础库 40
- [日志 / 追踪](#log) — 无方案 / 基础库 29
- [网络 / 协议](#net) — 无方案 / 基础库 118
- [LLM / Agent / MCP](#llm) — 方案 5 / 基础库 111
- [图像 / 媒体](#img) — 无方案 / 基础库 151
- [数据结构 / 算法](#ds) — 无方案 / 基础库 95


## Web 后端 / HTTP 服务

HTTP 服务、路由、中间件与后端 API 开发。

### 完整方案（13）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbitlang/moonback](https://github.com/moonbitlang/moonback) | 0.8.10 | 5.6万 | 62 | A web backend framework for MoonBit |
| 2 | [mizchi/mars](https://github.com/mizchi/mars.mbt) | 0.3.13 | 6.9k | 5 | Hono-inspired MoonBit web framework with trie routing, middleware, SSE, and mizc… |
| 3 | [oboard/mocket](https://github.com/oboard/mocket) | 0.10.2 | 3.1k | 11 | A web framework for MoonBit. |
| 4 | [bobzhang/crescent](https://github.com/moonbit-community/crescent) | 0.11.2 | 646 | 5 | Crescent: A web framework for MoonBit. |
| 5 | [moonbitstack/moonapi](https://github.com/moonbitstack/moonapi) | 0.17.7 | 458 | 1 | A typed web framework for MoonBit. |
| 6 | [jaredzhou/pony](https://github.com/jaredzhou/pony) | 0.5.0 | 126 | 0 | Lightweight HTTP web framework and router for MoonBit, inspired by Chi |
| 7 | [KKKIIO/moondark](https://github.com/kkkiio/moondark) | 0.1.1 | 40 | 2 | A Django-inspired backend framework for MoonBit, built on moonback |
| 8 | [RabitLogic/mbit](https://github.com/RabitLogic/mbit) | 0.3.0 | 68 | 0 | A Gin-inspired web framework for MoonBit — fast, lightweight, idiomatic. |

### 基础库（126）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbitstack/moonasgi](https://github.com/moonbitstack/moonasgi) | 0.10.4 | 1.0k | 5 | ASGI 3.0 for MoonBit: the interface between servers and frameworks. |
| 2 | [mizchi/js_web](https://github.com/mizchi/js.mbt) | 0.13.1 | 2.6k | 20 | web standard api bindings (fetch, Streams, Blob, URL, Crypto, ...) |
| 3 | [moonbitstack/moonnet](https://github.com/moonbitstack/moonnet) | 0.1.8 | 624 | 7 | Networking for MoonBit: connections, listeners and dialers over TCP, TLS and QUI… |
| 4 | [mizchi/github](https://github.com/mizchi/github) | 0.1.5 | 1.2k | 1 | GitHub REST API client for MoonBit |
| 5 | [gaato/http](https://github.com/gaato/mbt-sdk) | 0.5.0 | 2.3k | 11 | Sans-IO HTTP vocabulary for MoonBit SDKs: request/response types, a Transport tr… |
| 6 | [moonbitstack/mooncat](https://github.com/moonbitstack/mooncat) | 0.19.1 | 606 | 3 | A native ASGI server for MoonBit. |
| 7 | [gaato/sdk-runtime](https://github.com/gaato/mbt-sdk) | 0.7.0 | 1.9k | 7 | API-agnostic client runtime for MoonBit SDKs: error taxonomy, Retry-After and ba… |
| 8 | [ryota0624/googleapis](https://github.com/ryota0624/moonbit_googleapis) | 0.4.1 | 535 | 0 | MoonBit client library for Google REST APIs |


## JSON / 序列化格式

JSON、YAML、TOML、XML、CBOR 等格式的解析与生成。

### 完整方案（1）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [Yu-zh/data](https://github.com/Yu-zh/data) | 0.2.1 | 126 | 0 | A serde-shaped serialization framework: one data model, many formats |

> 完整方案仅 1 个，说明该类需求目前在生态中主要依靠基础库组合实现，下方基础库清单的实用价值更高。

### 基础库（184）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbitlang/x](https://github.com/moonbitlang/x) | 0.5.7 | 75.8万 | 1097 | experimental packages for moonbitlang/core |
| 2 | [mizchi/cbor](https://github.com/mizchi/cbor.mbt) | 0.1.1 | 5.8万 | 0 | CBOR (RFC 8949) implementation for MoonBit - Pure and FFI versions |
| 3 | [moonbit-community/yaml](https://github.com/moonbit-community/yaml.mbt) | 0.0.8 | 11.2万 | 64 | A simple YAML parsing and stringifying library for MoonBit, support a simplified… |
| 4 | [Milky2018/xml](https://github.com/moonbit-community/xml-mbt.git) | 0.6.1 | 7.9万 | 79 | A document-buffered pull XML parser for MoonBit |
| 5 | [moonrockz/ion](https://github.com/moonrockz/ion) | 0.7.0 | 3.6万 | 11 | A MoonBit implementation of the Amazon Ion data format and Ion Schema. |
| 6 | [moonbit-community/toml](https://github.com/moonbit-community/toml-parser) | 0.5.1 | 4.5万 | 28 | A TOML parser implementation in MoonBit |
| 7 | [moonbitstack/moonjson](https://github.com/moonbitstack/moonjson) | 0.4.2 | 2.1k | 17 | JSON, its dialects and its binary encodings for MoonBit. |
| 8 | [moonbitlang/jsonl](https://github.com/moonbitlang/jsonl) | 0.2.1 | 2.7万 | 5 | Async reader for JSON Lines (newline-delimited JSON) streams. |


## 异步 / 并发

async 运行时、协程、并发原语、任务调度。

### 完整方案（4）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbitlang/async](https://github.com/moonbitlang/async) | 0.22.7 | 74.4万 | 1103 | Asynchronous programming library for MoonBit |
| 2 | [peter-jerry-ye/async](https://github.com/peter-jerry-ye/async.mbt) | 0.2.1 | 219 | 2 | Async library: promise, event loop, i/o |
| 3 | [didiLjf/moonorbit](https://github.com/didiLjf/moonorbit) | 0.2.1 | 57 | 0 | A lightweight, high-performance Actor concurrency framework for MoonBit |
| 4 | [kalculos/miao](https://github.com/kalculos/miao) | 0.1.0-M2 | 41 | 0 | Another async I/O for moonbit, with libuv served as the default async runtime im… |

### 基础库（41）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [mizchi/x](https://github.com/mizchi/x) | 0.6.1 | 20.5万 | 53 | Cross-platform MoonBit compatibility facades with native delegation and accelera… |
| 2 | [moonbitlang/moonback](https://github.com/moonbitlang/moonback) | 0.8.10 | 5.6万 | 62 | A web backend framework for MoonBit |
| 3 | [colmugx/fuwaroid](https://github.com/colmugx/fuwaroid) | 0.3.2 | 4.5k | 5 | Lightweight single-writer concurrency |
| 4 | [moonbit-community/pty](https://github.com/moonbit-community/pty) | 0.4.4 | 4.1万 | 4 | Cross-platform PTY (pseudo-terminal) spawning for MoonBit native targets, integr… |
| 5 | [moonbit-community/tty](https://github.com/moonbit-community/tonyfettes-tty) | 0.6.2 | 3.1万 | 7 | Low-level terminal primitives for MoonBit native and wasm targets: a sidecar-hel… |
| 6 | [moonbitlang/jsonl](https://github.com/moonbitlang/jsonl) | 0.2.1 | 2.7万 | 5 | Async reader for JSON Lines (newline-delimited JSON) streams. |
| 7 | [mizchi/js_core](https://github.com/mizchi/js.mbt) | 0.13.0 | 2.6k | 39 | js ffi foundation for MoonBit (Any, Promise, Nullable, target-specific interop) |
| 8 | [Nanaloveyuki/sync](https://github.com/Nanaloveyuki/sync) | 0.7.3 | 391 | 1 | Minimal native concurrency primitives for MoonBit. |


## CLI 参数解析

命令行工具的参数、子命令、帮助信息解析。

### 完整方案（4）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [Yoorkin/ArgParser](https://github.com/Yoorkin/ArgParser) | 0.2.1 | 10.8万 | 8 | command line argument parser |
| 2 | [mizchi/admiral](https://github.com/mizchi/admiral) | 0.1.1 | 1.8万 | 0 | Declarative CLI builder for MoonBit, inspired by gunshi |
| 3 | [totto2727/admiral](https://github.com/totto2727-org/admiral) | 0.6.5 | 737 | 4 | Async-first declarative CLI builder for MoonBit, inspired by gunshi |
| 4 | [TheWaWaR/clap](https://github.com/TheWaWaR/clap.mbt) | 0.2.6 | 6.9k | 7 | Command Line Argument Parser |

### 基础库（221）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [cli/core](https://github.com/moonbit-community/cmd) | 0.9.1 | 443 | 76 | Shared runtime core for cli command modules. |
| 2 | [Milky2018/options](https://github.com/Milky2018/options.git) | 0.1.3 | 93 | 1 | Command line argument parser for MoonBit |
| 3 | [totto2727/agent-core-sdk](https://github.com/totto2727-org/agent-core-sdk) | 0.1.2 | 357 | 8 | Shared MoonBit process foundation for agent CLIs |
| 4 | [totto2727/opencode-sdk](https://github.com/totto2727-org/opencode-sdk) | 0.4.1 | 270 | 6 | MoonBit SDKs for OpenCode CLI execution and managed Server lifecycle |
| 5 | [moonbit-community/proton_cli](https://github.com/moonbit-community/proton/tree/main/cli) | 0.6.0 | 664 | 0 | Developer CLI for Proton desktop applications. |
| 6 | [moonrockz/smithy-cli](https://github.com/moonrockz/smithy) | 0.8.0 | 97 | 0 | Smithy command-line application |
| 7 | [cauchyQ/moonbit-argkit](https://github.com/cauchyQ/moonbit-argkit) | 0.1.0 | 34 | 0 | Small dependency-free command line argument parser for MoonBit. |
| 8 | [jqlssg/moondocopt](https://github.com/jqlssg/moondocopt) | 0.1.1 | 31 | 0 | Help-first command-line parsing with docopt semantics and bounded reusable compi… |


## 终端 UI / TUI

终端界面、字符画布、ANSI 控制、PTY。

### 完整方案（5）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [mizchi/tui](https://github.com/mizchi/tui.mbt) | 0.10.2 | 7.1万 | 27 | Terminal UI library for MoonBit with reactive signals |
| 2 | [moonbit-community/rabbita_tui](https://github.com/moonbit-community/rabbita_tui) | 0.1.3 | 401 | 1 | Native terminal UI toolkit built around The Elm Architecture |
| 3 | [Frank-III/onebit-tui](https://github.com/Frank-III/opentui) | 0.1.3 | 60 | 0 | Modern terminal UI library with Yoga flexbox layout and native performance |
| 4 | [moonbitstack/moonetui](https://github.com/moonbitstack/moonetui) | 0.3.1 | 60 | 0 | A terminal UI toolkit for MoonBit: cell buffer, differential ANSI renderer, incr… |
| 5 | [brickfrog/pippa](https://github.com/brickfrog/pippa) | 0.1.0 | 49 | 0 | A terminal UI framework for MoonBit, inspired by bubbletea (Go) and Elm architec… |

### 基础库（50）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbit-community/tty](https://github.com/moonbit-community/tonyfettes-tty) | 0.6.2 | 3.1万 | 7 | Low-level terminal primitives for MoonBit native and wasm targets: a sidecar-hel… |
| 2 | [mizchi/tui-terminal-buffer](https://github.com/mizchi/tui.mbt) | 0.1.4 | 2.1万 | 30 | Terminal character buffer primitives for MoonBit TUI renderers |
| 3 | [moonbit-community/displaytext](https://github.com/moonbit-community/displaytext) | 0.1.7 | 2.9万 | 2 | Grapheme-aware display-cell text boundaries for terminal UIs. |
| 4 | [moonbit-community/pty](https://github.com/moonbit-community/pty) | 0.4.4 | 4.1万 | 4 | Cross-platform PTY (pseudo-terminal) spawning for MoonBit native targets, integr… |
| 5 | [mizchi/tui-terminal-protocol](https://github.com/mizchi/tui.mbt) | 0.1.2 | 2.0万 | 10 | Terminal graphics protocol encoders for tui.mbt |
| 6 | [mizchi/crater-terminal-protocol](https://github.com/mizchi/crater) | 0.19.0 | 7.4k | 9 | Terminal graphics protocol encoders for crater |
| 7 | [sennenki/pretty_prompt](https://github.com/zvmsbackend/pretty_prompt) | 0.1.2 | 629 | 3 | A pretty prompt library for Moonbit, providing an easy way to create interactive… |
| 8 | [hustcer/tabular](https://github.com/hustcer/tabular) | 0.6.0 | 329 | 2 | A MoonBit library for pretty-printing tables in terminal. Ported from Rust table… |


## 测试 / 断言 / 属性测试

单元测试、属性测试（quickcheck）、断言库、BDD、基准。

### 完整方案（4）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbitlang/quickcheck](https://github.com/moonbitlang/quickcheck) | 0.15.1 | 19.7万 | 47 | Automatic testing of MoonBit programs |
| 2 | [moonrockz/moonspec](https://github.com/moonrockz/moonspec) | 0.11.0 | 1.5万 | 0 | BDD test framework for MoonBit with Gherkin and Cucumber Expressions |
| 3 | [aspnmy/moonitest](https://github.com/aspnmy/moonitest) | 0.2.1 | 57 | 0 | MoonBit integration test framework - real Docker/TCP/HTTP API via fangyinc/socke… |
| 4 | [Duckweed/moon-proof](https://github.com/Duckweed-yhb/MoonProof) | 0.1.3 | 34 | 0 | MoonProof：MoonBit 文档与教程示例的持续验证框架——把文档里的代码块抽出来，隔离编译运行，回答“我们文档里的例子还都对吗” |

### 基础库（62）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonrockz/expect](https://github.com/moonrockz/expect) | 0.6.1 | 3.9万 | 33 | A fluent assertion library for MoonBit |
| 2 | [moonrockz/cucumber-expressions](https://github.com/moonrockz/cucumber-expressions) | 0.6.1 | 1.6万 | 1 | Cucumber Expressions parser and matcher for MoonBit |
| 3 | [moonrockz/gherkin](https://github.com/moonrockz/gherkin) | 0.5.1 | 1.6万 | 1 | A Gherkin parser for MoonBit with DOM, visitor, fold, and SAX-style APIs |
| 4 | [moonrockz/cucumber-messages](https://github.com/moonrockz/cucumber-messages) | 0.5.0 | 1.6万 | 1 | Cucumber Messages protocol types for MoonBit with JSON serialization and NDJSON … |
| 5 | [moonbit-community/fuzzy_match](https://github.com/moonbit-community/fuzzy_match) | 0.2.6 | 4.3万 | 1 | A library for fuzzy string matching and fuzzy string searching |
| 6 | CAIMEOX/qc_pyext | 0.1.1 | 1.4k | 1 | QuickCheck and reference testing extension for Python programs |
| 7 | [f4ah6o/turtles](https://github.com/gpui-mbt/turtles.mbt) | 0.4.7 | 866 | 0 | Mutation testing for MoonBit projects |
| 8 | [zhangbowen2006/moonbit-target-parity](https://github.com/zhangbowen2006/MoonBitTargetParity.git) | 0.5.1 | 595 | 0 | Reusable cross-target behavior contract comparison for MoonBit programs. |


## 正则匹配

正则表达式引擎与匹配。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 9 个，此处列出前 9 个。

### 基础库（9）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbitlang/regexp](https://github.com/moonbitlang/regexp.mbt) | 0.3.7 | 6.4万 | 114 | A regular expression engine for MoonBit based on VM execution designed for predi… |
| 2 | [moonbitstack/moonregex](https://github.com/moonbitstack/moonregex) | 0.1.2 | 257 | 8 | Regular expressions for MoonBit. |
| 3 | [walkzzz/re-mbt](https://github.com/walkzzz/re-mbt) | 0.1.0 | 116 | 1 | A port of ocaml-re — the pure OCaml regular expression library — to idiomatic Mo… |
| 4 | [yj-qin/regexp](https://github.com/yj-qin/regexp) | 0.3.6 | 126 | 0 | A regular expression library based on a backtracking engine. |
| 5 | [mizchi/js_regexp](https://github.com/mizchi/moonbit-libs/tree/main/moonbit_js_regexp) | 0.0.4 | 59 | 0 | JS RegExp binding |
| 6 | ZijianFeng33/regexp | 0.1.0 | 35 | 0 | a simple regex matcher in moon |
| 7 | [Hjyyutr/moonyara](https://github.com/Hjyyutr/MoonYara) | 0.1.5 | 68 | 0 | A native MoonBit threat signature matching and malware scanning engine. |
| 8 | [YeeHh2004/mooninput](https://github.com/YeeHh2004/mooninput) | 0.2.2 | 67 | 0 | Composable structured input editing: dynamic masks, bounded regex, validation, n… |
| 9 | [FidollarinLA/moonmask](https://github.com/FidollarinLA/moonmask) | 0.1.0 | 30 | 0 | Constrained decoding for LLMs in MoonBit: compile JSON Schema and regex to byte-… |


## Unicode / 文本处理

Unicode 分类、字素簇、宽度计算、字符串工具。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 104 个，此处列出前 12 个。

### 基础库（104）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbit-community/charclass](https://github.com/moonbit-community/charclass) | 0.1.4 | 7.9万 | 29 | Unicode character classification library providing functions to determine charac… |
| 2 | [moonbit-community/unicodewidth](https://github.com/moonbit-community/unicodewidth.mbt) | 0.2.1 | 4.5万 | 7 | A simple library for measuring the width of unicode characters and strings. |
| 3 | [kawaz/grapheme](https://github.com/kawaz/grapheme.mbt) | 0.10.4 | 3.1万 | 10 | Unicode grapheme cluster segmentation library for MoonBit (UAX #29) |
| 4 | [mizchi/x](https://github.com/mizchi/x) | 0.6.1 | 20.5万 | 53 | Cross-platform MoonBit compatibility facades with native delegation and accelera… |
| 5 | [moonbit-community/prettyprinter](https://github.com/moonbit-community/prettyprinter) | 0.4.11 | 14.3万 | 96 | pretty printer for moonbit |
| 6 | [moonbit-community/ucd](https://github.com/moonbit-community/tonyfettes-unicode) | 0.5.2 | 7.1万 | 39 | Unicode Character Database lookup and case mapping for MoonBit |
| 7 | [moonbit-community/displaytext](https://github.com/moonbit-community/displaytext) | 0.1.7 | 2.9万 | 2 | Grapheme-aware display-cell text boundaries for terminal UIs. |
| 8 | [myfreess/charclass](https://github.com/moonbit-community/charclass) | 0.1.3 | 2.0万 | 1 | Unicode character classification library providing functions to determine charac… |
| 9 | [moonbit-community/unicode](https://github.com/moonbit-community/tonyfettes-unicode) | 0.6.0 | 1.9万 | 18 | Unicode in MoonBit |
| 10 | [moonbit-community/unicode-data](https://github.com/moonbit-community/tonyfettes-unicode) | 0.6.0 | 1.4万 | 31 | Unicode Character Database lookup and case mapping for MoonBit |
| 11 | [Milky2018/moon_cosmic](https://github.com/moonbit-community/moon_cosmic) | 0.3.8 | 5.7万 | 11 | MoonBit port of cosmic-text (text shaping, layout, and editor primitives) built … |
| 12 | [moonbit-community/normalization](https://github.com/moonbit-community/tonyfettes-unicode) | 0.5.2 | 1.5万 | 8 | Unicode normalization forms for MoonBit |


## 加密 / 哈希 / 编码

哈希、对称加密、Base64/编码、安全相关。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 117 个，此处列出前 12 个。

### 基础库（117）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbitlang/x](https://github.com/moonbitlang/x) | 0.5.7 | 75.8万 | 1097 | experimental packages for moonbitlang/core |
| 2 | [cc06b/mooncry](https://github.com/cc06b/mooncry) | 0.95.0 | 1.0万 | 94 | Pure-MoonBit crypto primitives: SHA-1/2 (incl. SHA-512/224/256), SHA-3, Keccak-2… |
| 3 | [gmlewis/base64](https://github.com/gmlewis/moonbit-base64) | 0.16.14 | 8.2万 | 64 | MoonBit base64: provide simple base64 operations. |
| 4 | [moonbitstack/mooncrypt](https://github.com/moonbitstack/mooncrypt) | 0.4.7 | 4.0k | 33 | Cryptographic algorithms for MoonBit, one per package. |
| 5 | [Tigls/mb-hash](https://github.com/moonbit-crypto/mb-crypto) | 0.1.0 | 7.6k | 4 | Secure hashing for MoonBit (SHA-256, SHA-512; native+WASM) |
| 6 | [gmlewis/sha256](https://github.com/gmlewis/moonbit-sha256) | 0.18.2 | 3.8k | 16 | MoonBit sha256: provide simple sha256 hash algorithm. |
| 7 | [gmlewis/hash](https://github.com/gmlewis/moonbit-hash) | 0.21.2 | 6.1万 | 17 | MoonBit hash: provide hash functions similar to Go. |
| 8 | [mizchi/bit_hash](https://github.com/mizchi/bit-vcs) | 0.48.1 | 2.3k | 33 | Git object hashing primitives (gix-hash equivalent) |
| 9 | [illusory0x0/rijndael](https://github.com/moonbit-community/rijndael.mbt) | 0.1.0 | 1.1万 | 0 | A MoonBit implementation of the Rijndael (AES) encryption algorithm |
| 10 | [moonbitstack/moonbase](https://github.com/moonbitstack/moonbase) | 0.4.2 | 4.4k | 40 | Every base encoding, one shape: base2 through base85, bech32 and multibase for M… |
| 11 | [mizchi/experimental_crypto](https://github.com/mizchi/experimental_crypto) | 0.0.2 | 1.1万 | 3 | EXPERIMENTAL — pure-MoonBit cryptography / PKI / JOSE building blocks. Education… |
| 12 | [mizchi/cbor](https://github.com/mizchi/cbor.mbt) | 0.1.1 | 5.8万 | 0 | CBOR (RFC 8949) implementation for MoonBit - Pure and FFI versions |


## 数据库 / 存储

SQLite 绑定、ORM、KV 存储、迁移工具。

### 完整方案（5）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbitstack/moondb](https://github.com/moonbitstack/moondb) | 0.2.4 | 1.7k | 7 | The standard database-access interface for MoonBit — the driver↔query-layer cont… |
| 2 | [oboard/morm](https://github.com/oboard/morm) | 0.5.0 | 800 | 1 | A lightweight MoonBit ORM with typed queries, code generation, and multi-databas… |
| 3 | [moonbitstack/moonorm](https://github.com/moonbitstack/moonorm) | 0.11.5 | 188 | 0 | An ORM and SQL toolkit for MoonBit. |
| 4 | [wflixu/Orion](https://github.com/wflixu/Orion) | 0.2.0 | 45 | 0 | Derive + Codegen ORM for MoonBit. Schema DSL, type-safe CRUD, Query Builder. |
| 5 | zen314/shadow | 0.1.0 | 32 | 0 | Simple ORM Framework |

### 基础库（75）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [mizchi/sqlite](https://github.com/mizchi/sqlite.mbt) | 0.3.1 | 1.1万 | 5 | libsqlite3 bindings for MoonBit |
| 2 | [prowk/moonsqlitefile](https://github.com/prowk/MoonSQLiteFile) | 0.8.1 | 1.7k | 6 | Pure MoonBit read-only SQLite file format parser and inspector |
| 3 | [f4ah6o/duckdb](https://github.com/f4ah6o/duckdb.mbt) | 0.8.0 | 1.5k | 1 | MoonBit bindings for DuckDB on native and JavaScript targets (Node.js and browse… |
| 4 | [moonbitstack/moonsqlite](https://github.com/moonbitstack/moondb) | 0.3.3 | 360 | 1 | SQLite driver for moondb/moonorm — native FFI, amalgamation vendored here (isola… |
| 5 | [jaredzhou/moonpg](https://github.com/jaredzhou/moonpg) | 0.14.0 | 244 | 3 | A pure MoonBit PostgreSQL client, wire protocol from scratch. |
| 6 | [mizchi/bit_objstore](https://github.com/mizchi/bit-vcs) | 0.48.1 | 1.4k | 20 | Object storage abstraction with compare-and-swap writes (S3/R2/GCS) |
| 7 | [moonbitstack/moonpostgres](https://github.com/moonbitstack/moondb) | 0.6.7 | 238 | 1 | Pure-MoonBit PostgreSQL wire-protocol driver implementing @moondb.AsyncDriver — … |
| 8 | [daqing/sqlite](https://github.com/daqing/sqlite.mbt) | 0.4.0 | 2.6k | 2 | SQLite3 bindings for latest MoonBit toolchian |


## WebAssembly / JS 互操作

Wasm 组件模型、WASI、FFI、JS 绑定。

### 完整方案（1）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [Milky2018/wasmoon](https://github.com/Milky2018/wasmoon.git) | 0.18.0 | 691 | 1 | WebAssembly runtime with native JIT, interpreter, WASI and Component Model suppo… |

> 完整方案仅 1 个，说明该类需求目前在生态中主要依靠基础库组合实现，下方基础库清单的实用价值更高。

### 基础库（303）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [mizchi/mwac](https://github.com/mizchi/mwac) | 0.2.2 | 6.6万 | 6 | WAC (WebAssembly Compositions) composer for the Component Model |
| 2 | [mizchi/wite](https://github.com/mizchi/wite) | 0.11.3 | 6.5万 | 4 | Component-model-aware WebAssembly analyzer, optimizer, and profiler |
| 3 | [mizchi/x](https://github.com/mizchi/x) | 0.6.1 | 20.5万 | 53 | Cross-platform MoonBit compatibility facades with native delegation and accelera… |
| 4 | [mizchi/oci_wasm](https://github.com/mizchi/oci_wasm) | 0.5.1 | 6.6万 | 5 | WebAssembly package registry client |
| 5 | [mizchi/js](https://github.com/mizchi/js.mbt) | 0.13.0 | 4.3万 | 27 | js bindings for MoonBit: re-exports mizchi/js_core + mizchi/js_builtin (web/node… |
| 6 | [mizchi/wit](https://github.com/mizchi/wit.mbt) | 0.3.3 | 6.5万 | 7 | WIT parser and resolver in MoonBit |
| 7 | [Milky2018/wasm_core](https://github.com/Milky2018/wasmoon.git) | 0.18.0 | 2.4k | 12 | Reusable WebAssembly specification model for parsers, validators, and frontends |
| 8 | [moonbit-community/proton_ffi](https://github.com/moonbit-community/proton) | 0.6.0 | 2.7万 | 13 | MoonBit Foreign Function Interface. |


## 解析器 / 编译器 / 语法

词法、语法、parser combinator、AST、tree-sitter、parser generator。

### 完整方案（2）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbitlang/yacc](https://github.com/moonbitlang/moonyacc) | 0.7.25 | 11.0万 | 6 | A LR(1) parser generator for MoonBit programming language. |
| 2 | [cogna-dev/parkit](https://github.com/cogna-dev/parkit) | 0.1.1 | 184 | 2 | A nom-like parser combinator framework for MoonBit |

> 完整方案仅 2 个，说明该类需求目前在生态中主要依靠基础库组合实现，下方基础库清单的实用价值更高。

### 基础库（286）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbitlang/parser](https://github.com/moonbitlang/parser) | 0.4.7 | 24.7万 | 92 | AST and parsers for the MoonBit programming language |
| 2 | [bobzhang/lexer](https://github.com/moonbit-community/toml-parser) | 0.3.1 | 17.4万 | 55 | A generic lexer library for handwritten lexers in MoonBit |
| 3 | [Milky2018/xml](https://github.com/moonbit-community/xml-mbt.git) | 0.6.1 | 7.9万 | 79 | A document-buffered pull XML parser for MoonBit |
| 4 | [moonbitlang/lexer](https://github.com/moonbitlang/parser) | 0.4.4 | 13.3万 | 110 | Lexer for the MoonBit programming language |
| 5 | [mizchi/markdown](https://github.com/mizchi/markdown.mbt) | 0.8.4 | 2.2万 | 16 | Incremental Markdown parser and compiler |
| 6 | [Yoorkin/ArgParser](https://github.com/Yoorkin/ArgParser) | 0.2.1 | 10.8万 | 8 | command line argument parser |
| 7 | [moonbit-community/toml](https://github.com/moonbit-community/toml-parser) | 0.5.1 | 4.5万 | 28 | A TOML parser implementation in MoonBit |
| 8 | [mizchi/css](https://github.com/mizchi/css) | 0.7.4 | 2.4万 | 46 | Standalone CSS parser, selector, cascade and computed-style engine for MoonBit |


## 数学 / 数值计算

高精度数学、线性代数、矩阵、BLAS、统计。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 64 个，此处列出前 12 个。

### 基础库（64）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [Kaida-Amethyst/math](https://github.com/Kaida-Amethyst/math.mbt) | 0.1.21 | 5.7k | 14 | High-precision Math library Implemented By Pure Moonbit |
| 2 | [Luna-Flow/luna-generic](https://github.com/Luna-Flow/luna-generic) | 0.4.0 | 6.8k | 13 | Algebraic traits and default numeric instances that define the generic foundatio… |
| 3 | [Luna-Flow/linear-algebra](https://github.com/Luna-Flow/linear-algebra) | 0.5.2 | 3.1k | 6 | Trait-oriented linear algebra foundations for MoonBit, with checked APIs, backen… |
| 4 | [mizchi/blas](https://github.com/mizchi/blas) | 0.1.3 | 2.9k | 3 | BLAS bindings for MoonBit (Accelerate/OpenBLAS) |
| 5 | [Luna-Flow/arithmetic](https://github.com/Luna-Flow/arithmetic) | 0.5.1 | 1.2k | 10 | Arithmetic capability traits and checked analytic operations for LunaFlow numeri… |
| 6 | [mizchi/numbt](https://github.com/mizchi/numbt) | 0.2.4 | 1.6k | 2 | NumPy-style numerical computing library for MoonBit |
| 7 | [Luna-Flow/luna-utils](https://github.com/Luna-Flow/luna-utils) | 0.3.0 | 2.7k | 3 | Backend-independent numeric base with floating-point classification, canonical N… |
| 8 | [Luna-Flow/calculus-numerical](https://github.com/Luna-Flow/calculus-numerical) | 0.3.1 | 1.3k | 1 | A numerical calculus library, a part of LunaFlow. |
| 9 | [applejag/micromath](https://github.com/applejag/micromath.mbt) | 0.3.0 | 1.4k | 1 | Embedded math arithmetic, optimized for small code size at the cost of precision |
| 10 | [Luna-Flow/luna-poly](https://github.com/Luna-Flow/luna-poly) | 0.4.0 | 185 | 1 | Immutable and mutable polynomial libraries for MoonBit with canonical dense, spa… |
| 11 | [CAIMEOX/moon_floating](https://github.com/CAIMEOX/mbmath.git) | 0.3.1 | 366 | 1 | Arbitrary-precision real, complex, interval, and numerical computing for MoonBit |
| 12 | [bobzhang/loop_invariants_math](https://github.com/moonbit-community/loop_invariants) | 0.17.0 | 123 | 0 | Mathematical algorithms with loop-invariant explanations |


## 图形 / 渲染

矢量图形、SVG、场景图、绘图与布局。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 121 个，此处列出前 12 个。

### 基础库（121）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [mizchi/svg](https://github.com/mizchi/svg) | 0.2.3 | 4.4万 | 38 | Standalone SVG scene graph and renderer |
| 2 | [dowdiness/svg-dsl](https://github.com/dowdiness/svg-dsl) | 0.1.0 | 3.3万 | 1 | SVG DSL for programmatic SVG generation in MoonBit |
| 3 | [Milky2018/svg](https://github.com/Milky2018/svg) | 0.6.0 | 4.4k | 24 | Standalone SVG scene graph and renderer |
| 4 | [gmlewis/fonts](https://github.com/gmlewis/moonbit-fonts) | 0.19.19 | 1.4万 | 27 | Experimental package to manipulate open source font data. |
| 5 | [bobzhang/vg](https://github.com/moonbit-community/vg) | 0.4.1 | 2.8k | 0 | Declarative 2D vector graphics library for MoonBit |
| 6 | [mizchi/moomaid](https://github.com/mizchi/moomaid) | 0.4.0 | 1.0万 | 17 | Mermaid diagram renderer for MoonBit (ASCII and SVG output) |
| 7 | [moonbitlang/pagelayout](https://github.com/moonbitlang/office.mbt) | 0.8.1 | 1.3万 | 8 | Paginated document layout engine: format-neutral page-model IR with SVG/PDF back… |
| 8 | [dowdiness/graphviz](https://github.com/dowdiness/graphviz) | 0.1.0 | 2.8万 | 0 | Parser, layout engine, and SVG renderer for Graphviz DOT graphs |
| 9 | [bobzhang/beautiful_mermaid](https://github.com/bobzhang/mermaid) | 0.2.0 | 2.7万 | 0 | MoonBit port of beautiful-mermaid: render Mermaid diagrams to SVG and ASCII/Unic… |
| 10 | [justjavac/template](https://github.com/justjavac/moonbit-template) | 0.1.2 | 4.3k | 2 | A small and fast precompiled template engine for MoonBit. |
| 11 | [moonbit-community/diago](https://github.com/moonbit-community/diago) | 0.4.0 | 4.1k | 0 | A diagram toolkit for MoonBit with Dagre, ELK, and Railway layout engines, rende… |
| 12 | [wzzc-dev/moui_skia](https://github.com/wzzc-dev/moui_skia) | 0.2.6 | 1.9k | 3 | MoonBit bindings for the Skia Graphics Library |


## 游戏引擎 / ECS

游戏引擎、ECS 架构、程序化生成、游戏后端。

### 完整方案（6）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [Milky2018/selene](https://github.com/moonbit-community/selene.git) | 0.38.0 | 4.0k | 9 | ECS game engine in MoonBit |
| 2 | [mizchi/kagura](https://github.com/mizchi/kagura) | 0.6.0 | 135 | 0 | 2D-first game engine for MoonBit inspired by Ebiten |
| 3 | [sennenki/reisen](https://github.com/zvmsbackend/reisen.git) | 0.3.2 | 90 | 0 | A visual novel engine in MoonBit |
| 4 | [sssssurf/abyssal_chord](https://github.com/sssssurf/abyssal-chord) | 0.1.0 | 41 | 0 | 深渊协奏 (Abyssal Chord) - A MoonBit card battle game engine with CLI demo |
| 5 | [sacckey/moon8bit](https://github.com/sacckey/moon8bit) | 0.1.0 | 32 | 0 | A minimal retro 2D game engine for MoonBit with text-first assets, deterministic… |
| 6 | [firefly/firefly](https://github.com/firefly-zero/firefly-moon) | 0.10.0 | 81 | 0 | MoonBit SDK for making Firefly Zero games |

### 基础库（48）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [mizchi/terrain](https://github.com/mizchi/terrain) | 0.1.1 | 3.0k | 15 | 117 procedural dungeon/terrain generation algorithms |
| 2 | [Milky2018/selene_webgpu](https://github.com/moonbit-community/selene.git) | 0.38.0 | 1.0k | 2 | Default backend for Selene game engine. |
| 3 | [mizchi/differentiable_ecs](https://github.com/mizchi/differentiable_ecs) | 0.2.1 | 653 | 0 | Game-agnostic parameter optimizer using CMA-ES for balance tuning (experimental) |
| 4 | [Milky2018/selene-canvas](https://github.com/moonbit-community/selene.git) | 0.20.1 | 219 | 0 | Default backend for Selene game engine. |
| 5 | [KKKIIO/selene](https://github.com/kkkiio/selene.git) | 0.37.5 | 113 | 2 | ECS game engine in MoonBit |
| 6 | [Milky2018/selene_raylib](https://github.com/moonbit-community/selene.git) | 0.38.0 | 1.8k | 2 | Native raylib backend for Selene. |
| 7 | [KKKIIO/selene_webgpu](https://github.com/kkkiio/selene.git) | 0.37.5 | 81 | 0 | Default backend for Selene game engine. |
| 8 | [Milky2018/mecs](https://github.com/Milky2018/mecs.git) | 0.2.1 | 62 | 0 | A performance-first ECS experiment for MoonBit. |


## Web UI / 前端框架

浏览器里的 UI 框架、响应式状态、组件、布局与 CSS。

### 完整方案（6）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbit-community/rabbita](https://github.com/moonbit-community/rabbita) | 0.17.0 | 13.2万 | 56 | functional Web UI framework for MoonBit |
| 2 | [mizchi/luna](https://github.com/mizchi/luna.mbt) | 0.25.2 | 2.1万 | 9 | Fine-grained reactive UI library for Moonbit/JS |
| 3 | [marianoguerra/tutuca](https://github.com/marianoguerra/tutuca-moonbit) | 0.57.1 | 767 | 0 | MoonBit port of the tutuca UI framework (value language, templates, vdom, compon… |
| 4 | [lampclaw/minimoon](https://github.com/lucavance/minimoon) | 0.3.2 | 196 | 1 | A MoonBit UI runtime for WeChat MiniApp Skyline with Elm-style state machines, V… |
| 5 | [Arcelyth/aitne](https://github.com/Arcelyth/aitne) | 0.4.20 | 215 | 0 | A lightweight and high-performance reactive web framework. |
| 6 | [vectie/bunnia](https://git@github.com:vectie/bunnia.git) | 0.1.0 | 30 | 0 | MoonBit mini-app UI framework with Rabbita-style authoring and modular platform … |

### 基础库（50）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [mizchi/signals](https://github.com/mizchi/signals) | 0.6.6 | 9.0万 | 41 | Fine-grained reactive signals for MoonBit (alien-signals inspired) |
| 2 | [mizchi/layout](https://github.com/mizchi/layout) | 0.2.1 | 3.4万 | 42 | Pure layout computation kernel: alignment, justify, clamp, axis utilities |
| 3 | [mizchi/wit](https://github.com/mizchi/wit.mbt) | 0.3.3 | 6.5万 | 7 | WIT parser and resolver in MoonBit |
| 4 | [mizchi/css](https://github.com/mizchi/css) | 0.7.4 | 2.4万 | 46 | Standalone CSS parser, selector, cascade and computed-style engine for MoonBit |
| 5 | [mizchi/crater](https://github.com/mizchi/crater) | 0.19.0 | 6.1万 | 0 | CSS Layout Engine that implements Box/Flex/Grid |
| 6 | [dowdiness/incr](https://github.com/dowdiness/incr) | 0.15.1 | 3.2万 | 2 | Salsa-inspired incremental recomputation library with automatic dependency track… |
| 7 | [bobzhang/html_parser](https://github.com/bobzhang/html_parser) | 0.2.2 | 1.3万 | 7 | MoonBit HTML parser and sanitizer ported from JustHTML. |
| 8 | [Milky2018/css](https://github.com/Milky2018/svg) | 0.6.0 | 4.3k | 25 | CSS parser, selector, cascade, and computed-style core maintained for Milky2018/… |


## 桌面 GUI / 跨平台窗口

原生桌面应用开发：窗口创建、事件循环、控件布局与渲染后端接入。Proton 的托盘、剪贴板、全局热键等配套模块不计入本表，检索 “proton” 可见全套。

### 完整方案（6）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbit-community/proton](https://github.com/moonbit-community/proton) | 0.6.0 | 2.7万 | 3 | MoonBit bindings for the Proton native desktop runtime. |
| 2 | [wzzc-dev/moui](https://github.com/wzzc-dev/MoUI.git) | 0.2.6 | 1.8k | 21 | MoUI is a multi-platform MoonBit GUI framework |
| 3 | [NoahLiu/native-gui](https://github.com/lb091188/moonbit-native-gui) | 0.3.1 | 99 | 2 | MoonBit 跨平台桌面 GUI 框架：一套代码直出 Windows / Linux / macOS 原生窗口，托盘/通知/快捷键/输入法/自启等系统能力开箱… |
| 4 | [vectie/lepusa](https://github.com/vectie/lepusa) | 0.1.6 | 452 | 5 | MoonBit-native desktop application framework research and implementation. |
| 5 | [lepus-apps/webview](https://github.com/lepus-apps/lepus_webview) | 0.1.15 | 282 | 0 | A modern desktop application framework based on web technologies. |
| 6 | [tonyfettes/giraffe](https://github.com/moonbit-community/tonyfettes-g) | 0.2.0 | 74 | 1 | Elm-style declarative UI framework for MoonBit, built on GTK4 |

### 基础库（29）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [wzzc-dev/window](https://github.com/wzzc-dev/window.git) | 0.5.4-0.2.4 | 1.1万 | 25 | The wzzc-dev fork of moonbit-community/window, tracking upstream 0.5.4 while add… |
| 2 | [Milky2018/windowing](https://github.com/moonbit-community/window.git) | 0.1.2 | 6.4k | 8 | Backend-neutral raw window and display handle contracts for MoonBit. |
| 3 | [Milky2018/window](https://github.com/moonbit-community/window.git) | 0.6.2 | 6.8k | 1 | A MoonBit port of winit with a native macOS event loop and windowing backend. |
| 4 | [wzzc-dev/windowing](https://github.com/moonbit-community/window.git) | 0.1.2 | 368 | 26 | Backend-neutral raw window and display handle contracts for MoonBit. |
| 5 | [Nanaloveyuki/moonview](https://github.com/Nanaloveyuki/moonview) | 0.1.0-beta.12 | 572 | 2 | Direct native WebView embedding for MoonBit. |
| 6 | [tonyfettes/gtk](https://github.com/moonbit-community/tonyfettes-g) | 0.2.0 | 275 | 4 | MoonBit bindings for GTK4 widgets (Window, Button, Box, Label, etc.) |
| 7 | [Nanaloveyuki/orby](https://github.com/Nanaloveyuki/orby) | 0.1.0-beta.7 | 403 | 1 | Native MoonBit application and window host. |
| 8 | [mizchi/glfw](https://github.com/mizchi/glfw-mbt) | 0.2.3 | 2.8k | 3 | GLFW MoonBit bindings (native FFI + C stub) |
| 9 | [justjavac/webview](https://github.com/justjavac/moonbit-webview) | 0.1.10 | 285 | 0 | MoonBit bindings for webview, a tiny library for creating web-based desktop GUIs… |
| 10 | [justjavac/windows_subsystem](https://github.com/justjavac/moonbit-windows-subsystem) | 0.1.6 | 91 | 0 | Keep the Windows GUI subsystem linker stub alive for MoonBit native executables. |


## 跨端 UI（一套代码多端）

以同一套 UI 代码覆盖 Web、桌面、移动端与小程序。候选清单为人工圈定：生态中尚无统一的跨端关键词，上述目标的实现需组合多个包方成立。

> 本场景为**人工圈定**：候选包与其顺序由人工确定，因为「跨端」在生态里还没有形成可靠的关键词信号。

### 完整方案（4）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbit-community/rabbita](https://github.com/moonbit-community/rabbita) | 0.17.0 | 13.2万 | 56 | functional Web UI framework for MoonBit |
| 2 | [moonbit-community/proton](https://github.com/moonbit-community/proton) | 0.6.0 | 2.7万 | 3 | MoonBit bindings for the Proton native desktop runtime. |
| 3 | [wzzc-dev/moui](https://github.com/wzzc-dev/MoUI.git) | 0.2.6 | 1.8k | 21 | MoUI is a multi-platform MoonBit GUI framework |
| 4 | [lampclaw/minimoon](https://github.com/lucavance/minimoon) | 0.3.2 | 196 | 1 | A MoonBit UI runtime for WeChat MiniApp Skyline with Elm-style state machines, V… |

### 基础库（7）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbit-community/proton_rabbita](https://github.com/moonbit-community/proton) | 0.6.0 | 337 | 0 | Rabbita commands and subscriptions for typed Proton contracts. |
| 2 | [wzzc-dev/window](https://github.com/wzzc-dev/window.git) | 0.5.4-0.2.4 | 1.1万 | 25 | The wzzc-dev fork of moonbit-community/window, tracking upstream 0.5.4 while add… |
| 3 | [XiLaiTL/moobile](https://github.com/XiLaiTL/moobile.git) | 0.6.0 | 81 | 1 | MoonBit UI for mobile: Android, iOS and Web from one rabbita (TEA) app, rendered… |
| 4 | [moonbit-community/rabbita_tui](https://github.com/moonbit-community/rabbita_tui) | 0.1.3 | 401 | 1 | Native terminal UI toolkit built around The Elm Architecture |
| 5 | [vectie/lepusa](https://github.com/vectie/lepusa) | 0.1.6 | 452 | 5 | MoonBit-native desktop application framework research and implementation. |
| 6 | [helios-house/valence](https://github.com/helios-house/valence) | 0.3.1 | 87 | 0 | MoonBit UI where every component is readable by humans and AI equally |
| 7 | [marianoguerra/tutuca](https://github.com/marianoguerra/tutuca-moonbit) | 0.57.1 | 767 | 0 | MoonBit port of the tutuca UI framework (value language, templates, vdom, compon… |


## Markdown / 文档转换

Markdown 解析、HTML/PDF/DOCX 转换、文档排版。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 94 个，此处列出前 12 个。

### 基础库（94）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbitlang/pdflite](https://github.com/moonbitlang/pdflite) | 0.4.1 | 2.0万 | 12 | Byte-oriented PDF reading, writing, and manipulation toolkit for MoonBit. |
| 2 | [moonbitlang/docx2html](https://github.com/moonbitlang/docx2html) | 0.7.1 | 1.3万 | 10 | Native MoonBit DOCX to HTML/Markdown converter ported from Mammoth |
| 3 | [moonbitlang/pagelayout](https://github.com/moonbitlang/office.mbt) | 0.8.1 | 1.3万 | 8 | Paginated document layout engine: format-neutral page-model IR with SVG/PDF back… |
| 4 | [bobzhang/html_parser](https://github.com/bobzhang/html_parser) | 0.2.2 | 1.3万 | 7 | MoonBit HTML parser and sanitizer ported from JustHTML. |
| 5 | [moonbit-community/cmark](https://github.com/moonbit-community/cmark.mbt) | 0.4.13 | 9.8万 | 27 | A CommonMark toolkit for MoonBit |
| 6 | [mizchi/markdown](https://github.com/mizchi/markdown.mbt) | 0.8.4 | 2.2万 | 16 | Incremental Markdown parser and compiler |
| 7 | [hustcer/html2md](https://github.com/hustcer/html2md) | 0.1.3 | 1.3万 | 0 | Convert HTML to Markdown (CommonMark), a MoonBit port of JohannesKaufmann/html-t… |
| 8 | [moonrockz/pretty](https://github.com/moonrockz/pretty) | 0.3.0 | 2.1万 | 6 | Wadler-style pretty printer for MoonBit: documents, groups and layout that fits … |
| 9 | [Lampese/office-viewer](https://github.com/moonbit-community/office-viewer) | 0.2.6 | 1.3万 | 3 | A read-only DOCX, XLSX, PPTX, and PDF viewer with structured selections. |
| 10 | [moonbit-community/html](https://github.com/moonbit-community/html5-mbt.git) | 0.2.3 | 4.5k | 3 | WHATWG HTML5 spec-compliant parser for MoonBit |
| 11 | [justjavac/template](https://github.com/justjavac/moonbit-template) | 0.1.2 | 4.3k | 2 | A small and fast precompiled template engine for MoonBit. |
| 12 | [wzzc-dev/moui_markdown](https://github.com/wzzc-dev/MoUI.git) | 0.2.6 | 297 | 1 | Reusable Markdown editing chrome components for MoUI (outline, find/replace, for… |


## 时间 / 日期

日期时间、时区、RFC3339、cron。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 40 个，此处列出前 12 个。

### 基础库（40）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbitlang/x](https://github.com/moonbitlang/x) | 0.5.7 | 75.8万 | 1097 | experimental packages for moonbitlang/core |
| 2 | [moonbitstack/moondate](https://github.com/moonbitstack/moondate) | 0.1.2 | 4.5k | 47 | Dates, times, durations and cron expressions for MoonBit. |
| 3 | [mldong/moon-hutool](https://github.com/mldong/moon-hutool) | 0.1.7 | 534 | 15 | Hutool-style utility library for MoonBit: all packages depend only on moonbitlan… |
| 4 | [brickfrog/tempo](https://github.com/brickfrog/tempo) | 0.8.1 | 597 | 0 | UTC date/time library — RFC 3339 parsing, Unix timestamps, arithmetic |
| 5 | [mizchi/bit_date](https://github.com/mizchi/bit-vcs) | 0.48.1 | 2.2k | 18 | Git date parsing primitives (gix-date equivalent) |
| 6 | caijiewei295/tzif-engine | 0.1.0 | 205 | 1 | Pure MoonBit IANA TZif v2/v3 parser and timezone conversion engine. UTC ↔ local … |
| 7 | [kawaz/timespec](https://github.com/kawaz/timespec.mbt) | 0.2.4 | 256 | 0 | CLI-oriented time specification parser for MoonBit |
| 8 | [iceBear67/time](https://github.com/iceBear67/mbt-time) | 0.1.2 | 65 | 1 | A date-time library in MoonBit, including zone offsets and clocks that support J… |
| 9 | [chensuiyi/dateku](https://github.com/chenbimo/moonbit) | 0.3.0 | 46 | 2 | MoonBit date-time formatting: epoch-milliseconds to ISO 8601 and RFC 5322 timest… |
| 10 | [suiyunonghen/datetime](https://github.com/suiyunonghen/datetime) | 0.1.6 | 51 | 1 | datetime type of moonbit |
| 11 | [001-Elsa/mooncron](https://github.com/001-Elsa/mooncron) | 0.1.4 | 70 | 0 | A cron expression parser and schedule calculator written in MoonBit. |
| 12 | [marianoguerra/temporal](https://github.com/marianoguerra/temporal-mb) | 0.1.2 | 63 | 0 | An implementation of ECMAScript Temporal: calendar and time-zone aware dates, ti… |


## 日志 / 追踪

结构化日志、tracing、OpenTelemetry、指标。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 29 个，此处列出前 12 个。

### 基础库（29）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [tonyfettes/xlog](https://github.com/moonbit-community/tonyfettes-log) | 0.4.2 | 5.4万 | 7 | Native structured logging with levels and category-based filtering. |
| 2 | [moonbitstack/moonlog](https://github.com/moonbitstack/moonlog) | 0.1.4 | 702 | 4 | Structured logging for MoonBit. |
| 3 | [moonrockz/moon-lander-logging](https://github.com/moonrockz/moon-lander) | 0.11.0 | 3.8k | 3 | Structured logging with a bring-your-own logger trait for the Moon-Lander framew… |
| 4 | [moonrockz/moon-lander-logging-hosting-async](https://github.com/moonrockz/moon-lander) | 0.11.0 | 3.8k | 2 | Console and rolling file delivery for Moon-Lander logging, with bounded async se… |
| 5 | [brickfrog/moontrace](https://github.com/brickfrog/moontrace) | 0.14.0 | 242 | 1 | Structured tracing for MoonBit with spans, structured fields, pluggable subscrib… |
| 6 | [mohongquan0630/moon-prometheus](https://gitlink.org.cn/mohongquan0630/moon-prometheus) | 0.2.6 | 76 | 0 | — |
| 7 | [ryota0624/moonbit_otel](https://github.com/ryota0624/moonbit_otel) | 0.1.0 | 75 | 0 | — |
| 8 | [Milky2018/sysinfo](https://github.com/moonbit-community/sysinfo.git) | 0.1.6 | 799 | 1 | System metrics and process inspection library. |
| 9 | [CCllff-jpg/MoonLogTrace](https://github.com/CCllff-jpg/MoonLogTrace) | 0.1.4 | 63 | 0 | Pure MoonBit structured logging and tracing library with safe formatters, replay… |
| 10 | [chensuiyi/logfly](https://github.com/chenbimo/moonbit) | 0.3.0 | 38 | 0 | Logging for MoonBit: plain text and JSONL appenders with timestamps, and size-tr… |
| 11 | [JYPeng487/moonopenmetrics](https://github.com/JYPeng487/moonopenmetrics) | 0.1.1 | 35 | 0 | OpenMetrics 1.0 text parser, canonical encoder, semantic validator, and document… |
| 12 | [LilaLola67/moonmcap](https://github.com/LilaLola67/moonmcap) | 0.17.4 | 240 | 0 | MoonBit-native MCAP message-log codec, indexed queries and file transformations |


## 网络 / 协议

TCP/UDP、WebSocket、MQTT、HTTP 协议栈、TLS。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 118 个，此处列出前 12 个。

### 基础库（118）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [moonbitstack/moonhttp](https://github.com/moonbitstack/moonhttp) | 0.15.4 | 1.7k | 10 | HTTP formats for MoonBit with no I/O: HTTP/1 to HTTP/3, WebSocket, SSE and multi… |
| 2 | [moonbitstack/moonnet](https://github.com/moonbitstack/moonnet) | 0.1.8 | 624 | 7 | Networking for MoonBit: connections, listeners and dialers over TCP, TLS and QUI… |
| 3 | [ShellWen/sw_socket](https://github.com/moonbit-community/sw-socket.git) | 0.2.0 | 428 | 0 | A experimental *nix socket binding for MoonBit. |
| 4 | [gaato/deflate](https://github.com/gaato/codecs.mbt) | 0.1.0 | 2.4k | 8 | Streaming DEFLATE, zlib and gzip decoders and encoders (RFC 1951, 1950, 1952) fo… |
| 5 | [fangyinc/socket](https://github.com/fangyinc/socket.mbt) | 0.1.2-rc2 | 1.3k | 2 | A socket binding for MoonBit |
| 6 | [gaato/brotli](https://github.com/gaato/codecs.mbt) | 0.4.1 | 2.3k | 7 | A streaming Brotli (RFC 7932) decoder and encoder in pure MoonBit: arbitrary inp… |
| 7 | [PaiGack/ftp](https://github.com/PaiGack/moonbit_ftp) | 0.2.5 | 141 | 2 | FTP/FTPS client library for MoonBit with passive EPSV/PASV data connections, MLS… |
| 8 | [moonbitstack/moontls](https://github.com/moonbitstack/moontls) | 0.9.11 | 1.1k | 9 | TLS 1.3 and DTLS 1.3 for MoonBit. |
| 9 | [sujy123456/mooncoap](https://github.com/sujy123456/MoonCoAP) | 0.1.1 | 168 | 0 | Bounded, deterministic unicast CoAP protocol core for MoonBit |
| 10 | [oboard/mio](https://github.com/oboard/mio) | 0.5.4 | 949 | 7 | Best async http library for Moonbit |
| 11 | [gaato/zstd](https://github.com/gaato/codecs.mbt) | 0.3.1 | 792 | 8 | A streaming Zstandard (RFC 8878) decoder in pure MoonBit: arbitrary input chunks… |
| 12 | [ZSeanYves/MoonbitHTTP](https://github.com/ZSeanYves/MoonbitHTTP) | 0.7.0 | 133 | 0 | Streaming HTTP protocol suite for MoonBit with HTTP/1.1, HTTP/2, HTTP/3, QUIC, T… |


## LLM / Agent / MCP

大模型客户端、Agent 框架、MCP 服务端/客户端、提示词。

### 完整方案（5）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [colmugx/posoco](https://github.com/colmugx/posoco) | 0.23.2 | 4.2k | 4 | LLM Agent framework with hexagonal (ports-and-adapters) architecture. Defines ex… |
| 2 | [colmugx/mcp](https://github.com/colmugx/mcp.mbt) | 0.18.2 | 9.1k | 2 | Type-safe MCP SDK in MoonBit with server/client support and dual transport (STDI… |
| 3 | [golemcloud/golem_sdk](https://github.com/golemcloud/moonbit-sdk) | 0.6.2 | 724 | 0 | Golem SDK for MoonBit — build durable, fault-tolerant agents on the Golem platfo… |
| 4 | [weopqrst/agent](https://github.com/mihujiang/MoonBit) | 0.5.1 | 84 | 0 | MoonBit version of LangChain core library — type-safe, composable, embeddable AI… |
| 5 | [soehi/moonlm](https://github.com/soehi/moonlm) | 0.1.2 | 43 | 1 | Local LLM inference engine and strongly-typed agent runtime, in MoonBit |

### 基础库（111）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [mizchi/llm](https://github.com/mizchi/llm) | 0.3.2 | 15.4万 | 10 | Pure MoonBit LLM client library |
| 2 | [DC-Z-lab/moonllm](https://github.com/DC-Z-lab/moonllm) | 0.1.0 | 500 | 4 | Type-safe, OpenAI-compatible LLM client for MoonBit: chat completions, streaming… |
| 3 | [colmugx/acp](https://github.com/colmugx/acp.mbt) | 0.3.0 | 3.8k | 0 | Type-safe Agent Client Protocol (ACP) SDK for MoonBit. |
| 4 | [marianoguerra/llm](https://github.com/marianoguerra/llm-mb) | 0.4.2 | 469 | 1 | A dialect-agnostic LLM IR, one wire mapping per provider protocol, a data-driven… |
| 5 | [totto2727/codex-sdk](https://github.com/totto2727-org/codex-sdk) | 0.4.1 | 229 | 6 | MoonBit SDK for embedding the Codex agent in workflows and applications |
| 6 | colmugx/lody | 0.1.0 | 3.7k | 0 | 1:1 MoonBit mirror of the LodyAI acp-extension-core contract (tool vocabulary, _… |
| 7 | wzzc-dev/moui_agent_mcp | 0.2.6 | 309 | 1 | MCP JSON-RPC router and stdio transport exposing a MoUI AgentHost to external ag… |
| 8 | [totto2727/agent-core-sdk](https://github.com/totto2727-org/agent-core-sdk) | 0.1.2 | 357 | 8 | Shared MoonBit process foundation for agent CLIs |


## 图像 / 媒体

图像编解码（PNG/JPEG/GIF/BMP）、像素比较、音视频。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 151 个，此处列出前 12 个。

### 基础库（151）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [mizchi/image](https://github.com/mizchi/image-mbt) | 0.4.3 | 2.6万 | 47 | Image codec primitives for MoonBit with PNG/BMP/JPEG decode+encode, GIF/WebP/ICO… |
| 2 | [mizchi/pixelmatch](https://github.com/mizchi/pixelmatch) | 0.6.2 | 4.3万 | 37 | Fast pixel-level image comparison library for MoonBit/WASM |
| 3 | [mizchi/simd](https://github.com/mizchi/simd) | 0.6.1 | 1.4万 | 34 | SIMD primitives for MoonBit across wasm / wasm-gc / native / js — @simdcore, @si… |
| 4 | [mizchi/svg](https://github.com/mizchi/svg) | 0.2.3 | 4.4万 | 38 | Standalone SVG scene graph and renderer |
| 5 | [gmlewis/fonts](https://github.com/gmlewis/moonbit-fonts) | 0.19.19 | 1.4万 | 27 | Experimental package to manipulate open source font data. |
| 6 | [gmlewis/image](https://github.com/gmlewis/moonbit-image) | 0.17.18 | 9.1k | 4 | MoonBit image: simple image representation. |
| 7 | [riantr/moonbit_image](https://github.com/riantr/moonbit_image) | 0.3.9 | 1.4k | 5 | Pure-MoonBit image decoder/encoder covering BMP / QOI / TGA / PNG / GIF / JPEG /… |
| 8 | [riantr/snn_mbt](https://gitee.com/ren-yongxiang/moonbit-snn) | 0.166.2 | 1.3k | 3 | Bit-exact MoonBit port of SpikingNeuralNetworks.jl, extended with modern trainin… |
| 9 | [mizchi/moomaid](https://github.com/mizchi/moomaid) | 0.4.0 | 1.0万 | 17 | Mermaid diagram renderer for MoonBit (ASCII and SVG output) |
| 10 | [dowdiness/svg-dsl](https://github.com/dowdiness/svg-dsl) | 0.1.0 | 3.3万 | 1 | SVG DSL for programmatic SVG generation in MoonBit |
| 11 | [moonbitlang/pagelayout](https://github.com/moonbitlang/office.mbt) | 0.8.1 | 1.3万 | 8 | Paginated document layout engine: format-neutral page-model IR with SVG/PDF back… |
| 12 | [moonbit-community/proton_microphone](https://github.com/moonbit-community/proton/tree/main/sys/microphone) | 0.6.0 | 2.4万 | 1 | Microphone capture device and session helpers. |


## 数据结构 / 算法

有序映射、B 树、堆、图算法、集合。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 95 个，此处列出前 12 个。

### 基础库（95）

| # | 包 | 版本 | 下载 | 反向依赖 | 说明 |
|---|---|---|---|---|---|
| 1 | [dowdiness/btree](https://github.com/dowdiness/canopy) | 0.2.0 | 3.4万 | 2 | Generic counted B-tree with O(log n) indexed access, insert, delete, and range o… |
| 2 | [dowdiness/order-tree](https://github.com/dowdiness/order-tree) | 0.1.2 | 3.1万 | 1 | Order-statistic B-tree with O(log n) position-indexed operations |
| 3 | [dowdiness/alga](https://github.com/dowdiness/alga) | 0.4.0 | 4.4万 | 2 | Algebraic graphs for MoonBit — directed graph trait and algorithm library inspir… |
| 4 | [dowdiness/rle](https://github.com/dowdiness/rle) | 0.2.3 | 5.1万 | 3 | Generic run-length encoded sequence with O(log n) position lookup |
| 5 | [dowdiness/event-graph-walker](https://github.com/dowdiness/event-graph-walker) | 0.8.0 | 2.2万 | 0 | Implementation of the eg-walker CRDT algorithm with FugueMax sequence CRDT |
| 6 | [totto2727/any-collection](https://github.com/totto2727-org/any-collection) | 0.2.2 | 180 | 7 | Typed references over mutable and immutable maps of dynamically typed values |
| 7 | [wedarp/moongraph](https://github.com/wedarp/MoonGraph) | 0.2.2 | 424 | 0 | Pure MoonBit generic graph data structures and algorithms |
| 8 | [moonbit-community/diago](https://github.com/moonbit-community/diago) | 0.4.0 | 4.1k | 0 | A diagram toolkit for MoonBit with Dagre, ELK, and Railway layout engines, rende… |
| 9 | [wzzc-dev/moui_skia](https://github.com/wzzc-dev/moui_skia) | 0.2.6 | 1.9k | 3 | MoonBit bindings for the Skia Graphics Library |
| 10 | [bobzhang/loop_invariants](https://github.com/moonbit-community/loop_invariants) | 0.9.0 | 128 | 0 | Comprehensive collection of algorithms and data structures with well-documented … |
| 11 | [wzzc-dev/moui_sun](https://github.com/wzzc-dev/MoUI.git) | 0.2.6 | 1.1k | 1 | Experimental MoonBit-native CPU raster stack for MoUI |
| 12 | [aurasuisui/indexmap](https://github.com/aurasuisui/moonbit-indexmap) | 0.4.0 | 62 | 0 | A hash map that preserves insertion order - MoonBit port of Rust's indexmap |
