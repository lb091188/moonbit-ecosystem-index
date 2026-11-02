# MoonBit 生态：场景化选包指南

> 覆盖 3520 个已发布模块；被 yanked 的包不计入推荐。

数据源：mooncakes.io 官方 API（模块元数据）。本索引仅做场景导航，不复制注册表能力：版本历史、完整 API 文档与依赖关系请到 mooncakes 包页查看，报告内包名均指向该页。

本报告不列下载量。清单顺序参考了注册表的下载量级，但该数字不作为事实对外呈现——它是累计计数，快照必然滞后，且容易被误读成「更适合」，而选型要看的是 API 形态与维护状态。

> **数据时效**　采集于 2026-11-02，早于本报告的生成时间。本报告为离线生成的静态快照，不随注册表更新，不含此后的新增、版本变更与 yanked 标记；选型判断请以 mooncakes.io 及仓库实际状态为准。

有完整方案的场景分两层：**完整方案**（能直接选型、定骨架的）与**基础库**（提供单点能力，由调用方组合）；尚无完整方案的场景不设分层，候选全部为基础库。框架、引擎、运行时、脚手架、ORM 均属「完整方案」的不同形态。「基础库」不等同于「依赖」：在 mooncakes 生态中，完整方案本身同样是依赖，分层的唯一标准是该包能否接管程序结构。

清单顺序在构建时确定，序号表示该场景内的推荐次序，不是下载量排行；同义词已做词干归一（如 async/asynchronous），并对易混淆场景做了排除（如 UI 场景排除 TUI）。

## 目录

- [桌面](#gui) — 方案 7 / 基础库 31
- [移动端](#mobi) — 方案 7 / 基础库 8
- [Web UI / 前端框架](#ui) — 方案 6 / 基础库 50
- [终端 UI / TUI](#tui) — 方案 5 / 基础库 50
- [CLI 参数解析](#cli) — 方案 4 / 基础库 86
- [游戏引擎 / ECS](#game) — 方案 6 / 基础库 48
- [图形 / 图表 / 渲染](#graphics) — 无方案 / 基础库 123
- [图像编解码](#img) — 无方案 / 基础库 36
- [音频 / 视频](#media) — 无方案 / 基础库 36
- [Web 后端 / HTTP 服务](#http) — 方案 13 / 基础库 85
- [HTTP 客户端](#httpc) — 无方案 / 基础库 15
- [网络传输 / 套接字](#net) — 无方案 / 基础库 58
- [应用协议 / RPC](#proto) — 无方案 / 基础库 23
- [数据库 / 存储](#db) — 方案 5 / 基础库 75
- [异步 / 并发](#async) — 方案 4 / 基础库 41
- [JSON 解析](#json) — 无方案 / 基础库 115
- [配置 / 标记格式](#datafmt) — 方案 1 / 基础库 61
- [二进制编码](#binfmt) — 无方案 / 基础库 19
- [日志 / 追踪](#log) — 无方案 / 基础库 29
- [运维 / 系统管理](#ops) — 方案 4 / 基础库 8
- [LLM / Agent / MCP](#llm) — 方案 5 / 基础库 111
- [解析器 / 语法](#parser) — 方案 2 / 基础库 227
- [编译器 / 代码生成](#compiler) — 无方案 / 基础库 79
- [正则匹配](#regex) — 无方案 / 基础库 9
- [Unicode / 文本处理](#unicode) — 无方案 / 基础库 104
- [哈希 / 校验](#hash) — 无方案 / 基础库 44
- [加密 / 签名](#cipher) — 无方案 / 基础库 29
- [编码 / 转义](#encode) — 无方案 / 基础库 35
- [压缩 / 归档](#archive) — 无方案 / 基础库 55
- [文件 / 路径 / IO](#fs) — 无方案 / 基础库 122
- [数学 / 数值计算](#math) — 无方案 / 基础库 64
- [数据结构 / 算法](#ds) — 无方案 / 基础库 95
- [测试 / 断言 / 属性测试](#test) — 方案 4 / 基础库 62
- [开发工具 / 代码质量](#tool) — 无方案 / 基础库 60
- [Markdown / 文档转换](#doc) — 无方案 / 基础库 94
- [时间 / 日期](#time) — 无方案 / 基础库 40
- [WebAssembly / JS 互操作](#wasm) — 方案 1 / 基础库 303


## 桌面

原生桌面应用开发：窗口创建、事件循环、控件布局与渲染后端接入。Proton 的托盘、剪贴板、全局热键等配套模块不计入本表。

### 完整方案（7）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbit-community/proton](https://mooncakes.io/docs/moonbit-community/proton) | 0.6.0 | MoonBit bindings for the Proton native desktop runtime. |
| 2 | [wzzc-dev/moui](https://mooncakes.io/docs/wzzc-dev/moui) | 0.2.6 | MoUI is a multi-platform MoonBit GUI framework |
| 3 | [NoahLiu/native-gui](https://mooncakes.io/docs/NoahLiu/native-gui) | 0.3.1 | MoonBit 跨平台桌面 GUI 框架：一套代码直出 Windows / Linux / macOS 原生窗口，托盘/通知/快捷键/输入法/自启等系统能力开箱… |
| 4 | [vectie/lepusa](https://mooncakes.io/docs/vectie/lepusa) | 0.1.6 | MoonBit-native desktop application framework research and implementation. |
| 5 | [Nanaloveyuki/orbit](https://mooncakes.io/docs/Nanaloveyuki/orbit) | 0.2.0-alpha.1 | Composable desktop application foundations for MoonBit. |
| 6 | [lepus-apps/webview](https://mooncakes.io/docs/lepus-apps/webview) | 0.1.15 | A modern desktop application framework based on web technologies. |
| 7 | [tonyfettes/giraffe](https://mooncakes.io/docs/tonyfettes/giraffe) | 0.2.0 | Elm-style declarative UI framework for MoonBit, built on GTK4 |

### 基础库（31）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [wzzc-dev/window](https://mooncakes.io/docs/wzzc-dev/window) | 0.5.4-0.2.4 | The wzzc-dev fork of moonbit-community/window, tracking upstream 0.5.4 while add… |
| 2 | [Milky2018/window](https://mooncakes.io/docs/Milky2018/window) | 0.6.2 | A MoonBit port of winit with a native macOS event loop and windowing backend. |
| 3 | [Milky2018/windowing](https://mooncakes.io/docs/Milky2018/windowing) | 0.1.2 | Backend-neutral raw window and display handle contracts for MoonBit. |
| 4 | [Nanaloveyuki/moonview](https://mooncakes.io/docs/Nanaloveyuki/moonview) | 0.1.0-beta.12 | Direct native WebView embedding for MoonBit. |
| 5 | [Nanaloveyuki/orby](https://mooncakes.io/docs/Nanaloveyuki/orby) | 0.1.0-beta.7 | Native MoonBit application and window host. |
| 6 | [wzzc-dev/windowing](https://mooncakes.io/docs/wzzc-dev/windowing) | 0.1.2 | Backend-neutral raw window and display handle contracts for MoonBit. |
| 7 | [mizchi/glfw](https://mooncakes.io/docs/mizchi/glfw) | 0.2.3 | GLFW MoonBit bindings (native FFI + C stub) |
| 8 | [justjavac/webview](https://mooncakes.io/docs/justjavac/webview) | 0.1.10 | MoonBit bindings for webview, a tiny library for creating web-based desktop GUIs… |
| 9 | [tonyfettes/gtk](https://mooncakes.io/docs/tonyfettes/gtk) | 0.2.0 | MoonBit bindings for GTK4 widgets (Window, Button, Box, Label, etc.) |
| 10 | [justjavac/windows_subsystem](https://mooncakes.io/docs/justjavac/windows_subsystem) | 0.1.6 | Keep the Windows GUI subsystem linker stub alive for MoonBit native executables. |


## 移动端

Android、iOS、HarmonyOS 与微信小程序上的应用开发。生态中尚无统一的移动端关键词信号，候选清单为人工圈定，涵盖全平台 UI 框架、小程序运行时与组件库、原生桥接、小程序宿主。

> 本场景为**人工圈定**：候选包与其顺序由人工确定，因为该领域在生态里还没有形成可靠的关键词信号。

### 完整方案（7）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [XiLaiTL/moobile](https://mooncakes.io/docs/XiLaiTL/moobile) | 0.6.0 | MoonBit UI for mobile: Android, iOS and Web from one rabbita (TEA) app, rendered… |
| 2 | [wzzc-dev/moui](https://mooncakes.io/docs/wzzc-dev/moui) | 0.2.6 | MoUI is a multi-platform MoonBit GUI framework |
| 3 | [lampclaw/minimoon](https://mooncakes.io/docs/lampclaw/minimoon) | 0.3.2 | A MoonBit UI runtime for WeChat MiniApp Skyline with Elm-style state machines, V… |
| 4 | [Magic486/moon-miniprogram](https://mooncakes.io/docs/Magic486/moon-miniprogram) | 0.6.1 | MoonBit 微信小程序开发框架：类型安全运行时、状态自动 diff、跨页 store、声明式路由与无头测试基建 |
| 5 | [shop1111/moonohos](https://mooncakes.io/docs/shop1111/moonohos) | 0.6.0 | HarmonyOS Native module framework for MoonBit: async tasks, platform modules and… |
| 6 | [lampclaw/lampo](https://mooncakes.io/docs/lampclaw/lampo) | 0.1.0 | A MoonBit UI runtime for WeChat MiniApp Skyline with pure Elm-style authoring, c… |
| 7 | [vectie/bunnia](https://mooncakes.io/docs/vectie/bunnia) | 0.1.0 | MoonBit mini-app UI framework with Rabbita-style authoring and modular platform … |

### 基础库（8）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [wzzc-dev/window](https://mooncakes.io/docs/wzzc-dev/window) | 0.5.4-0.2.4 | The wzzc-dev fork of moonbit-community/window, tracking upstream 0.5.4 while add… |
| 2 | [Nanaloveyuki/ajni](https://mooncakes.io/docs/Nanaloveyuki/ajni) | 0.3.4 | Checked bidirectional Java/MoonBit JNI runtime and Android host bridge. |
| 3 | [Nanaloveyuki/moonview](https://mooncakes.io/docs/Nanaloveyuki/moonview) | 0.1.0-beta.12 | Direct native WebView embedding for MoonBit. |
| 4 | [lampclaw/minimoon_ui](https://mooncakes.io/docs/lampclaw/minimoon_ui) | 0.2.0 | Native, touch-first Skyline components for Minimoon, adapted from RUI. |
| 5 | [shop1111/moonohos_ohos](https://mooncakes.io/docs/shop1111/moonohos_ohos) | 0.6.0 | HarmonyOS platform packages (HiLog, RawFile, task cancellation, device info, net… |
| 6 | [Nanaloveyuki/madk](https://mooncakes.io/docs/Nanaloveyuki/madk) | 0.1.0 | Transport-independent Android Open Accessory protocol support for MoonBit. |
| 7 | [Nanaloveyuki/wasee-moon](https://mooncakes.io/docs/Nanaloveyuki/wasee-moon) | 0.1.0 | Android WASI host integration for MoonBit guests. |
| 8 | [wzzc-dev/moui_cli](https://mooncakes.io/docs/wzzc-dev/moui_cli) | 0.2.6 | Standalone project generator and environment doctor for MoUI |


## Web UI / 前端框架

浏览器里的 UI 框架、响应式状态、组件、布局与 CSS。

### 完整方案（6）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbit-community/rabbita](https://mooncakes.io/docs/moonbit-community/rabbita) | 0.17.0 | functional Web UI framework for MoonBit |
| 2 | [mizchi/luna](https://mooncakes.io/docs/mizchi/luna) | 0.25.2 | Fine-grained reactive UI library for Moonbit/JS |
| 3 | [marianoguerra/tutuca](https://mooncakes.io/docs/marianoguerra/tutuca) | 0.57.1 | MoonBit port of the tutuca UI framework (value language, templates, vdom, compon… |
| 4 | [lampclaw/minimoon](https://mooncakes.io/docs/lampclaw/minimoon) | 0.3.2 | A MoonBit UI runtime for WeChat MiniApp Skyline with Elm-style state machines, V… |
| 5 | [Arcelyth/aitne](https://mooncakes.io/docs/Arcelyth/aitne) | 0.4.20 | A lightweight and high-performance reactive web framework. |
| 6 | [vectie/bunnia](https://mooncakes.io/docs/vectie/bunnia) | 0.1.0 | MoonBit mini-app UI framework with Rabbita-style authoring and modular platform … |

### 基础库（50）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [mizchi/signals](https://mooncakes.io/docs/mizchi/signals) | 0.6.6 | Fine-grained reactive signals for MoonBit (alien-signals inspired) |
| 2 | [mizchi/wit](https://mooncakes.io/docs/mizchi/wit) | 0.3.3 | WIT parser and resolver in MoonBit |
| 3 | [mizchi/crater](https://mooncakes.io/docs/mizchi/crater) | 0.19.0 | CSS Layout Engine that implements Box/Flex/Grid |
| 4 | [mizchi/layout](https://mooncakes.io/docs/mizchi/layout) | 0.2.1 | Pure layout computation kernel: alignment, justify, clamp, axis utilities |
| 5 | [dowdiness/incr](https://mooncakes.io/docs/dowdiness/incr) | 0.15.1 | Salsa-inspired incremental recomputation library with automatic dependency track… |
| 6 | [mizchi/css](https://mooncakes.io/docs/mizchi/css) | 0.7.4 | Standalone CSS parser, selector, cascade and computed-style engine for MoonBit |
| 7 | [Milky2018/moon_taffy](https://mooncakes.io/docs/Milky2018/moon_taffy) | 0.5.3 | MoonBit port of the Rust crate taffy (v0.5.x) |
| 8 | [bobzhang/html_parser](https://mooncakes.io/docs/bobzhang/html_parser) | 0.2.2 | MoonBit HTML parser and sanitizer ported from JustHTML. |


## 终端 UI / TUI

终端界面、字符画布、ANSI 控制、PTY。

### 完整方案（5）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [mizchi/tui](https://mooncakes.io/docs/mizchi/tui) | 0.10.2 | Terminal UI library for MoonBit with reactive signals |
| 2 | [moonbit-community/rabbita_tui](https://mooncakes.io/docs/moonbit-community/rabbita_tui) | 0.1.3 | Native terminal UI toolkit built around The Elm Architecture |
| 3 | [Frank-III/onebit-tui](https://mooncakes.io/docs/Frank-III/onebit-tui) | 0.1.3 | Modern terminal UI library with Yoga flexbox layout and native performance |
| 4 | [moonbitstack/moonetui](https://mooncakes.io/docs/moonbitstack/moonetui) | 0.3.1 | A terminal UI toolkit for MoonBit: cell buffer, differential ANSI renderer, incr… |
| 5 | [brickfrog/pippa](https://mooncakes.io/docs/brickfrog/pippa) | 0.1.0 | A terminal UI framework for MoonBit, inspired by bubbletea (Go) and Elm architec… |

### 基础库（50）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbit-community/tty](https://mooncakes.io/docs/moonbit-community/tty) | 0.6.2 | Low-level terminal primitives for MoonBit native and wasm targets: a sidecar-hel… |
| 2 | [moonbit-community/displaytext](https://mooncakes.io/docs/moonbit-community/displaytext) | 0.1.7 | Grapheme-aware display-cell text boundaries for terminal UIs. |
| 3 | [moonbit-community/pty](https://mooncakes.io/docs/moonbit-community/pty) | 0.4.4 | Cross-platform PTY (pseudo-terminal) spawning for MoonBit native targets, integr… |
| 4 | [mizchi/tui-terminal-buffer](https://mooncakes.io/docs/mizchi/tui-terminal-buffer) | 0.1.4 | Terminal character buffer primitives for MoonBit TUI renderers |
| 5 | [mizchi/tui-terminal-protocol](https://mooncakes.io/docs/mizchi/tui-terminal-protocol) | 0.1.2 | Terminal graphics protocol encoders for tui.mbt |
| 6 | [mizchi/crater-terminal-protocol](https://mooncakes.io/docs/mizchi/crater-terminal-protocol) | 0.19.0 | Terminal graphics protocol encoders for crater |
| 7 | [sennenki/pretty_prompt](https://mooncakes.io/docs/sennenki/pretty_prompt) | 0.1.2 | A pretty prompt library for Moonbit, providing an easy way to create interactive… |
| 8 | [cg-zhou/drawille](https://mooncakes.io/docs/cg-zhou/drawille) | 0.1.2 | MoonBit port of drawille for terminal graphics with Unicode Braille characters |


## CLI 参数解析

命令行工具的参数、子命令、帮助信息解析。

### 完整方案（4）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [Yoorkin/ArgParser](https://mooncakes.io/docs/Yoorkin/ArgParser) | 0.2.1 | command line argument parser |
| 2 | [mizchi/admiral](https://mooncakes.io/docs/mizchi/admiral) | 0.1.1 | Declarative CLI builder for MoonBit, inspired by gunshi |
| 3 | [TheWaWaR/clap](https://mooncakes.io/docs/TheWaWaR/clap) | 0.2.6 | Command Line Argument Parser |
| 4 | [totto2727/admiral](https://mooncakes.io/docs/totto2727/admiral) | 0.6.5 | Async-first declarative CLI builder for MoonBit, inspired by gunshi |

### 基础库（86）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [DzmingLi/clap](https://mooncakes.io/docs/DzmingLi/clap) | 0.2.8 | Command Line Argument Parser |
| 2 | [cli/core](https://mooncakes.io/docs/cli/core) | 0.9.1 | Shared runtime core for cli command modules. |
| 3 | [moonrockz/smithy-cli](https://mooncakes.io/docs/moonrockz/smithy-cli) | 0.8.0 | Smithy command-line application |
| 4 | [jqlssg/moondocopt](https://mooncakes.io/docs/jqlssg/moondocopt) | 0.1.1 | Help-first command-line parsing with docopt semantics and bounded reusable compi… |
| 5 | [moonrockz/mission-control-cli](https://mooncakes.io/docs/moonrockz/mission-control-cli) | 0.1.0 | Mission Control command-line application |
| 6 | [cli/sh](https://mooncakes.io/docs/cli/sh) | 0.2.5 | sh command for MoonX. |
| 7 | [cli/wget](https://mooncakes.io/docs/cli/wget) | 0.2.5 | wget command for MoonX. |
| 8 | [cli/curl](https://mooncakes.io/docs/cli/curl) | 0.2.5 | curl command for MoonX. |


## 游戏引擎 / ECS

游戏引擎、ECS 架构、程序化生成、游戏后端。

### 完整方案（6）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [Milky2018/selene](https://mooncakes.io/docs/Milky2018/selene) | 0.38.0 | ECS game engine in MoonBit |
| 2 | [mizchi/kagura](https://mooncakes.io/docs/mizchi/kagura) | 0.6.0 | 2D-first game engine for MoonBit inspired by Ebiten |
| 3 | [sennenki/reisen](https://mooncakes.io/docs/sennenki/reisen) | 0.3.2 | A visual novel engine in MoonBit |
| 4 | [sssssurf/abyssal_chord](https://mooncakes.io/docs/sssssurf/abyssal_chord) | 0.1.0 | 深渊协奏 (Abyssal Chord) - A MoonBit card battle game engine with CLI demo |
| 5 | [sacckey/moon8bit](https://mooncakes.io/docs/sacckey/moon8bit) | 0.1.0 | A minimal retro 2D game engine for MoonBit with text-first assets, deterministic… |
| 6 | [firefly/firefly](https://mooncakes.io/docs/firefly/firefly) | 0.10.0 | MoonBit SDK for making Firefly Zero games |

### 基础库（48）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [mizchi/terrain](https://mooncakes.io/docs/mizchi/terrain) | 0.1.1 | 117 procedural dungeon/terrain generation algorithms |
| 2 | [Milky2018/selene_webgpu](https://mooncakes.io/docs/Milky2018/selene_webgpu) | 0.38.0 | Default backend for Selene game engine. |
| 3 | [mizchi/differentiable_ecs](https://mooncakes.io/docs/mizchi/differentiable_ecs) | 0.2.1 | Game-agnostic parameter optimizer using CMA-ES for balance tuning (experimental) |
| 4 | [Milky2018/selene-canvas](https://mooncakes.io/docs/Milky2018/selene-canvas) | 0.20.1 | Default backend for Selene game engine. |
| 5 | [Milky2018/selene_raylib](https://mooncakes.io/docs/Milky2018/selene_raylib) | 0.38.0 | Native raylib backend for Selene. |
| 6 | [KKKIIO/selene](https://mooncakes.io/docs/KKKIIO/selene) | 0.37.5 | ECS game engine in MoonBit |
| 7 | [KKKIIO/selene_webgpu](https://mooncakes.io/docs/KKKIIO/selene_webgpu) | 0.37.5 | Default backend for Selene game engine. |
| 8 | [Milky2018/mecs](https://mooncakes.io/docs/Milky2018/mecs) | 0.2.1 | A performance-first ECS experiment for MoonBit. |


## 图形 / 图表 / 渲染

矢量图形、SVG、场景图、图表与图形布局、绘图原语。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 123 个候选均为基础库，需按需组合。

### 基础库（123）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [mizchi/svg](https://mooncakes.io/docs/mizchi/svg) | 0.2.3 | Standalone SVG scene graph and renderer |
| 2 | [dowdiness/svg-dsl](https://mooncakes.io/docs/dowdiness/svg-dsl) | 0.1.0 | SVG DSL for programmatic SVG generation in MoonBit |
| 3 | [bobzhang/beautiful_mermaid](https://mooncakes.io/docs/bobzhang/beautiful_mermaid) | 0.2.0 | MoonBit port of beautiful-mermaid: render Mermaid diagrams to SVG and ASCII/Unic… |
| 4 | [mizchi/moomaid](https://mooncakes.io/docs/mizchi/moomaid) | 0.4.0 | Mermaid diagram renderer for MoonBit (ASCII and SVG output) |
| 5 | [Milky2018/svg](https://mooncakes.io/docs/Milky2018/svg) | 0.6.0 | Standalone SVG scene graph and renderer |
| 6 | [dowdiness/graphviz](https://mooncakes.io/docs/dowdiness/graphviz) | 0.1.0 | Parser, layout engine, and SVG renderer for Graphviz DOT graphs |
| 7 | [bobzhang/vg](https://mooncakes.io/docs/bobzhang/vg) | 0.4.1 | Declarative 2D vector graphics library for MoonBit |
| 8 | [moonbit-community/diago](https://mooncakes.io/docs/moonbit-community/diago) | 0.4.0 | A diagram toolkit for MoonBit with Dagre, ELK, and Railway layout engines, rende… |
| 9 | [gmlewis/fonts](https://mooncakes.io/docs/gmlewis/fonts) | 0.19.19 | Experimental package to manipulate open source font data. |
| 10 | [moonbitlang/pagelayout](https://mooncakes.io/docs/moonbitlang/pagelayout) | 0.8.1 | Paginated document layout engine: format-neutral page-model IR with SVG/PDF back… |
| 11 | [justjavac/template](https://mooncakes.io/docs/justjavac/template) | 0.1.2 | A small and fast precompiled template engine for MoonBit. |
| 12 | [Lampese/mathplotlib](https://mooncakes.io/docs/Lampese/mathplotlib) | 0.18.0 | A MoonBit plotting library with SVG output. |


## 图像编解码

图像格式的编解码与像素处理：PNG / JPEG / GIF / BMP / QOI / WebP。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 36 个候选均为基础库，需按需组合。

### 基础库（36）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [mizchi/pixelmatch](https://mooncakes.io/docs/mizchi/pixelmatch) | 0.6.2 | Fast pixel-level image comparison library for MoonBit/WASM |
| 2 | [mizchi/image](https://mooncakes.io/docs/mizchi/image) | 0.4.3 | Image codec primitives for MoonBit with PNG/BMP/JPEG decode+encode, GIF/WebP/ICO… |
| 3 | [gmlewis/image](https://mooncakes.io/docs/gmlewis/image) | 0.17.18 | MoonBit image: simple image representation. |
| 4 | [riantr/moonbit_image](https://mooncakes.io/docs/riantr/moonbit_image) | 0.3.9 | Pure-MoonBit image decoder/encoder covering BMP / QOI / TGA / PNG / GIF / JPEG /… |
| 5 | [riantr/snn_mbt](https://mooncakes.io/docs/riantr/snn_mbt) | 0.166.2 | Bit-exact MoonBit port of SpikingNeuralNetworks.jl, extended with modern trainin… |
| 6 | [Nanaloveyuki/image](https://mooncakes.io/docs/Nanaloveyuki/image) | 0.1.3 | Pure MoonBit image codecs and icon container encoders. |
| 7 | [walkzzz/image](https://mooncakes.io/docs/walkzzz/image) | 0.5.0 | MoonBit image library: pure MoonBit backend for native/wasm-gc/js/wasm multi-tar… |
| 8 | [trkbt10/jpeg2000](https://mooncakes.io/docs/trkbt10/jpeg2000) | 0.2.0 | T.800-2015 JPEG 2000 decoder for MoonBit |
| 9 | [0717lee/pixelforge](https://mooncakes.io/docs/0717lee/pixelforge) | 0.19.0 | Pure MoonBit image processing library with filters, morphology, color-space oper… |
| 10 | [shunge/image](https://mooncakes.io/docs/shunge/image) | 0.2.1 | 纯 MoonBit 图像解码库，支持 BMP/QOI/TGA/PNG/GIF/JPEG 六种格式、渐进式 JPEG、Adam7 PNG 和 GIF 动画，内置 … |
| 11 | [megemini/millow](https://mooncakes.io/docs/megemini/millow) | 0.3.1 | A zero-FFI, cross-platform image-processing library for MoonBit. |
| 12 | [Asterless/MoonQOI](https://mooncakes.io/docs/Asterless/MoonQOI) | 0.1.3 | QOI (Quite OK Image Format) encoder/decoder library for MoonBit |


## 音频 / 视频

音频采集与播放、音频编码、MIDI、麦克风与设备接口。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 36 个候选均为基础库，需按需组合。

### 基础库（36）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbit-community/proton_microphone](https://mooncakes.io/docs/moonbit-community/proton_microphone) | 0.6.0 | Microphone capture device and session helpers. |
| 2 | [Milky2018/moon_rodio](https://mooncakes.io/docs/Milky2018/moon_rodio) | 0.3.6 | Native-only MoonBit port of Rust rodio with playback pipeline, source effects, a… |
| 3 | [justjavac/microphone](https://mooncakes.io/docs/justjavac/microphone) | 0.1.3 | Microphone capture device and session helpers. |
| 4 | [mizchi/audio](https://mooncakes.io/docs/mizchi/audio) | 0.1.1 | audio encoder for wav/ogg |
| 5 | [moonbit-community/microphone](https://mooncakes.io/docs/moonbit-community/microphone) | 0.1.14 | Microphone capture device and session helpers. |
| 6 | [Milky2018/moon_cpal](https://mooncakes.io/docs/Milky2018/moon_cpal) | 0.11.8 | A MoonBit port (subset) of RustAudio/cpal. |
| 7 | [LL728/moonopus](https://mooncakes.io/docs/LL728/moonopus) | 0.2.2 | 纯 MoonBit 实现的 Ogg Opus 容器与 CELT 音频解码器，不依赖任何 C 库或系统编解码器 |
| 8 | [riantr/snn_mbt](https://mooncakes.io/docs/riantr/snn_mbt) | 0.166.2 | Bit-exact MoonBit port of SpikingNeuralNetworks.jl, extended with modern trainin… |
| 9 | [Ridge-Lab/moonwavkit](https://mooncakes.io/docs/Ridge-Lab/moonwavkit) | 0.1.3 | MoonBit-native WAV parser, PCM decoder, waveform analysis, validation, and audio… |
| 10 | [CAIMEOX/midi](https://mooncakes.io/docs/CAIMEOX/midi) | 0.1.0 | A MIDI file parser and writer in MoonBit |
| 11 | [Sakuraqwq1/moonflac-encoder](https://mooncakes.io/docs/Sakuraqwq1/moonflac-encoder) | 0.5.5 | Pure MoonBit FLAC encoder: turn interleaved PCM into a native .flac stream with … |
| 12 | [Xcsa-ee/moonflac](https://mooncakes.io/docs/Xcsa-ee/moonflac) | 0.3.4 | 纯 MoonBit 实现的 FLAC 无损音频解码器，不依赖任何 C 库或系统编解码器 |


## Web 后端 / HTTP 服务

HTTP 服务、路由、中间件与后端 API 开发。

### 完整方案（13）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbitlang/moonback](https://mooncakes.io/docs/moonbitlang/moonback) | 0.8.10 | A web backend framework for MoonBit |
| 2 | [mizchi/mars](https://mooncakes.io/docs/mizchi/mars) | 0.3.13 | Hono-inspired MoonBit web framework with trie routing, middleware, SSE, and mizc… |
| 3 | [oboard/mocket](https://mooncakes.io/docs/oboard/mocket) | 0.10.2 | A web framework for MoonBit. |
| 4 | [bobzhang/crescent](https://mooncakes.io/docs/bobzhang/crescent) | 0.11.2 | Crescent: A web framework for MoonBit. |
| 5 | [jaredzhou/pony](https://mooncakes.io/docs/jaredzhou/pony) | 0.5.0 | Lightweight HTTP web framework and router for MoonBit, inspired by Chi |
| 6 | [RabitLogic/mbit](https://mooncakes.io/docs/RabitLogic/mbit) | 0.3.0 | A Gin-inspired web framework for MoonBit — fast, lightweight, idiomatic. |
| 7 | [moonbitstack/moonapi](https://mooncakes.io/docs/moonbitstack/moonapi) | 0.17.7 | A typed web framework for MoonBit. |
| 8 | [daqing/moonway](https://mooncakes.io/docs/daqing/moonway) | 0.11.9 | A full-stack web framework for MoonBit |

### 基础库（85）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [ShellWen/sw_router](https://mooncakes.io/docs/ShellWen/sw_router) | 0.2.0 | A fast and flexible URL router implementation for the MoonBit language. |
| 2 | [gaato/http](https://mooncakes.io/docs/gaato/http) | 0.5.0 | Sans-IO HTTP vocabulary for MoonBit SDKs: request/response types, a Transport tr… |
| 3 | [mizchi/github](https://mooncakes.io/docs/mizchi/github) | 0.1.5 | GitHub REST API client for MoonBit |
| 4 | [gaato/http-async](https://mooncakes.io/docs/gaato/http-async) | 0.5.0 | gaato/http Transport over moonbitlang/async. Native, JS, and moonrun Wasm target… |
| 5 | [gaato/sdk-runtime](https://mooncakes.io/docs/gaato/sdk-runtime) | 0.7.0 | API-agnostic client runtime for MoonBit SDKs: error taxonomy, Retry-After and ba… |
| 6 | [moonbitstack/moonhttp](https://mooncakes.io/docs/moonbitstack/moonhttp) | 0.15.4 | HTTP formats for MoonBit with no I/O: HTTP/1 to HTTP/3, WebSocket, SSE and multi… |
| 7 | [mldong/moon-token-moonback](https://mooncakes.io/docs/mldong/moon-token-moonback) | 0.1.19 | moonback adapter for moon-token: per-route authentication middleware, request pr… |
| 8 | [ryota0624/googleapis](https://mooncakes.io/docs/ryota0624/googleapis) | 0.4.1 | MoonBit client library for Google REST APIs |


## HTTP 客户端

发起 HTTP 请求：请求构造、连接复用、重定向、SSE 流式读取。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 15 个候选均为基础库，需按需组合。

### 基础库（15）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [gaato/http](https://mooncakes.io/docs/gaato/http) | 0.5.0 | Sans-IO HTTP vocabulary for MoonBit SDKs: request/response types, a Transport tr… |
| 2 | [moonbitstack/moonfetch](https://mooncakes.io/docs/moonbitstack/moonfetch) | 0.1.2 | An HTTP client for MoonBit, synchronous or asynchronous. |
| 3 | [gaato/http-async](https://mooncakes.io/docs/gaato/http-async) | 0.5.0 | gaato/http Transport over moonbitlang/async. Native, JS, and moonrun Wasm target… |
| 4 | [q2316367743/moonhttp](https://mooncakes.io/docs/q2316367743/moonhttp) | 0.6.1 | axios 风格的 MoonBit HTTP 客户端：实例与配置合并、四种请求体形态、流式与 SSE、自动重定向 |
| 5 | [DC-Z-lab/moonllm](https://mooncakes.io/docs/DC-Z-lab/moonllm) | 0.1.0 | Type-safe, OpenAI-compatible LLM client for MoonBit: chat completions, streaming… |
| 6 | [gaato/requesto](https://mooncakes.io/docs/gaato/requesto) | 0.2.2 | A human-facing async HTTP client for MoonBit: verb functions, a client with defa… |
| 7 | [moonbitstack/moonnet](https://mooncakes.io/docs/moonbitstack/moonnet) | 0.1.8 | Networking for MoonBit: connections, listeners and dialers over TCP, TLS and QUI… |
| 8 | [SundayT1998/chroma-client](https://mooncakes.io/docs/SundayT1998/chroma-client) | 0.1.1 | A Chroma vector database HTTP client for MoonBit: collections, records, queries … |
| 9 | [marianoguerra/mcp-client](https://mooncakes.io/docs/marianoguerra/mcp-client) | 0.10.1 | MCP 2026-07-28 client: streamable-HTTP and stdio transports, MRTR, subscriptions… |
| 10 | [q2316367743/webdav](https://mooncakes.io/docs/q2316367743/webdav) | 0.1.0 | MoonBit WebDAV 客户端：文件上传/下载（流式+进度）、目录、移动/复制、PROPFIND/PROPPATCH。 |
| 11 | [marianoguerra/slack-http](https://mooncakes.io/docs/marianoguerra/slack-http) | 0.4.3 | Native HTTP transport for marianoguerra/slack, over moonbitlang/async. Implement… |
| 12 | [Atman-Angle/oas2moon_runtime](https://mooncakes.io/docs/Atman-Angle/oas2moon_runtime) | 0.1.0 | Runtime request, response, encoding, auth, and transport boundary for oas2moon c… |


## 网络传输 / 套接字

TCP / UDP、套接字、DNS、TLS 等传输层能力。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 58 个候选均为基础库，需按需组合。

### 基础库（58）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbitstack/moonnet](https://mooncakes.io/docs/moonbitstack/moonnet) | 0.1.8 | Networking for MoonBit: connections, listeners and dialers over TCP, TLS and QUI… |
| 2 | [mizchi/crater-network](https://mooncakes.io/docs/mizchi/crater-network) | 0.19.0 | WebDriver BiDi synthetic network state and byte/query encoding helpers for crate… |
| 3 | [ShellWen/sw_socket](https://mooncakes.io/docs/ShellWen/sw_socket) | 0.2.0 | A experimental *nix socket binding for MoonBit. |
| 4 | [fangyinc/socket](https://mooncakes.io/docs/fangyinc/socket) | 0.1.2-rc2 | A socket binding for MoonBit |
| 5 | [ZSeanYves/MoonbitHTTP](https://mooncakes.io/docs/ZSeanYves/MoonbitHTTP) | 0.7.0 | Streaming HTTP protocol suite for MoonBit with HTTP/1.1, HTTP/2, HTTP/3, QUIC, T… |
| 6 | [moonbitstack/moontls](https://mooncakes.io/docs/moonbitstack/moontls) | 0.9.11 | TLS 1.3 and DTLS 1.3 for MoonBit. |
| 7 | [oboard/mio](https://mooncakes.io/docs/oboard/mio) | 0.5.4 | Best async http library for Moonbit |
| 8 | [cghyyrrt/moonbit-pcap](https://mooncakes.io/docs/cghyyrrt/moonbit-pcap) | 0.1.2 | Pure MoonBit network packet capture (PCAP / PCAPNG) parser, stream reassembly, a… |
| 9 | [chensuiyi/packet](https://mooncakes.io/docs/chensuiyi/packet) | 0.1.1 | MoonBit 协议解析层：Ethernet/IPv4/IPv6/TCP/UDP 头解析 |
| 10 | [aspnmy/moodtcpcli](https://mooncakes.io/docs/aspnmy/moodtcpcli) | 0.1.0 | Zero-dependency TCP network primitives for MoonBit - ported from rstcpcli |
| 11 | [PaiGack/ftp](https://mooncakes.io/docs/PaiGack/ftp) | 0.2.5 | FTP/FTPS client library for MoonBit with passive EPSV/PASV data connections, MLS… |
| 12 | [jinshengmeng46/moon-dns-stub](https://mooncakes.io/docs/jinshengmeng46/moon-dns-stub) | 0.1.0 | Native DNS wire format codec and async stub resolver. Supports A/AAAA/MX/SRV/TXT… |


## 应用协议 / RPC

WebSocket、MQTT、gRPC、SSE 等应用层协议与 RPC 通信。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 23 个候选均为基础库，需按需组合。

### 基础库（23）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbitstack/moonhttp](https://mooncakes.io/docs/moonbitstack/moonhttp) | 0.15.4 | HTTP formats for MoonBit with no I/O: HTTP/1 to HTTP/3, WebSocket, SSE and multi… |
| 2 | [moonbitstack/moonrpc](https://mooncakes.io/docs/moonbitstack/moonrpc) | 0.21.7 | gRPC for MoonBit. |
| 3 | [mizchi/mars](https://mooncakes.io/docs/mizchi/mars) | 0.3.13 | Hono-inspired MoonBit web framework with trie routing, middleware, SSE, and mizc… |
| 4 | [gaato/http](https://mooncakes.io/docs/gaato/http) | 0.5.0 | Sans-IO HTTP vocabulary for MoonBit SDKs: request/response types, a Transport tr… |
| 5 | [f4ah6o/direct_sdk](https://mooncakes.io/docs/f4ah6o/direct_sdk) | 0.11.2 | MoonBit SDK for Direct4B WebSocket API with MessagePack RPC |
| 6 | [zbhzs1/moonbit-mqtt](https://mooncakes.io/docs/zbhzs1/moonbit-mqtt) | 0.1.0 | MQTT 3.1.1 packet codec helpers for MoonBit without transport or client runtime |
| 7 | [moonbitstack/mooncat](https://mooncakes.io/docs/moonbitstack/mooncat) | 0.19.1 | A native ASGI server for MoonBit. |
| 8 | [Duckweed/moon-mqtt](https://mooncakes.io/docs/Duckweed/moon-mqtt) | 0.3.3 | moon-mqtt：MoonBit 生态的 MQTT 3.1.1 客户端库——QoS0/1/2、持久会话恢复、core/ 纯计算状态机（四后端可测）、浏览器 W… |
| 9 | [q2316367743/moonhttp](https://mooncakes.io/docs/q2316367743/moonhttp) | 0.6.1 | axios 风格的 MoonBit HTTP 客户端：实例与配置合并、四种请求体形态、流式与 SSE、自动重定向 |
| 10 | [Xpeng/moonthrift](https://mooncakes.io/docs/Xpeng/moonthrift) | 0.4.0 | Apache Thrift IDL tooling and binary protocol support for MoonBit |
| 11 | [ZSeanYves/MoonbitHTTP](https://mooncakes.io/docs/ZSeanYves/MoonbitHTTP) | 0.7.0 | Streaming HTTP protocol suite for MoonBit with HTTP/1.1, HTTP/2, HTTP/3, QUIC, T… |
| 12 | [tonyfettes/soup](https://mooncakes.io/docs/tonyfettes/soup) | 0.2.0 | MoonBit bindings for libsoup 3.0 (HTTP client, WebSocket) |


## 数据库 / 存储

SQLite 绑定、ORM、KV 存储、迁移工具。

### 完整方案（5）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbitstack/moondb](https://mooncakes.io/docs/moonbitstack/moondb) | 0.2.4 | The standard database-access interface for MoonBit — the driver↔query-layer cont… |
| 2 | [oboard/morm](https://mooncakes.io/docs/oboard/morm) | 0.5.0 | A lightweight MoonBit ORM with typed queries, code generation, and multi-databas… |
| 3 | [moonbitstack/moonorm](https://mooncakes.io/docs/moonbitstack/moonorm) | 0.11.5 | An ORM and SQL toolkit for MoonBit. |
| 4 | [wflixu/Orion](https://mooncakes.io/docs/wflixu/Orion) | 0.2.0 | Derive + Codegen ORM for MoonBit. Schema DSL, type-safe CRUD, Query Builder. |
| 5 | [zen314/shadow](https://mooncakes.io/docs/zen314/shadow) | 0.1.0 | Simple ORM Framework |

### 基础库（75）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [mizchi/sqlite](https://mooncakes.io/docs/mizchi/sqlite) | 0.3.1 | libsqlite3 bindings for MoonBit |
| 2 | [prowk/moonsqlitefile](https://mooncakes.io/docs/prowk/moonsqlitefile) | 0.8.1 | Pure MoonBit read-only SQLite file format parser and inspector |
| 3 | [f4ah6o/duckdb](https://mooncakes.io/docs/f4ah6o/duckdb) | 0.8.0 | MoonBit bindings for DuckDB on native and JavaScript targets (Node.js and browse… |
| 4 | [moonbitstack/moonsqlite](https://mooncakes.io/docs/moonbitstack/moonsqlite) | 0.3.3 | SQLite driver for moondb/moonorm — native FFI, amalgamation vendored here (isola… |
| 5 | [daqing/sqlite](https://mooncakes.io/docs/daqing/sqlite) | 0.4.0 | SQLite3 bindings for latest MoonBit toolchian |
| 6 | [mizchi/cloudflare](https://mooncakes.io/docs/mizchi/cloudflare) | 0.1.13 | MoonBit bindings for Cloudflare Workers APIs (KV, D1, R2, Durable Objects, etc.) |
| 7 | [jaredzhou/moonpg](https://mooncakes.io/docs/jaredzhou/moonpg) | 0.14.0 | A pure MoonBit PostgreSQL client, wire protocol from scratch. |
| 8 | [moonbitstack/moonpostgres](https://mooncakes.io/docs/moonbitstack/moonpostgres) | 0.6.7 | Pure-MoonBit PostgreSQL wire-protocol driver implementing @moondb.AsyncDriver — … |


## 异步 / 并发

async 运行时、协程、并发原语、任务调度。

### 完整方案（4）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbitlang/async](https://mooncakes.io/docs/moonbitlang/async) | 0.22.7 | Asynchronous programming library for MoonBit |
| 2 | [peter-jerry-ye/async](https://mooncakes.io/docs/peter-jerry-ye/async) | 0.2.1 | Async library: promise, event loop, i/o |
| 3 | [didiLjf/moonorbit](https://mooncakes.io/docs/didiLjf/moonorbit) | 0.2.1 | A lightweight, high-performance Actor concurrency framework for MoonBit |
| 4 | [kalculos/miao](https://mooncakes.io/docs/kalculos/miao) | 0.1.0-M2 | Another async I/O for moonbit, with libuv served as the default async runtime im… |

### 基础库（41）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [mizchi/x](https://mooncakes.io/docs/mizchi/x) | 0.6.1 | Cross-platform MoonBit compatibility facades with native delegation and accelera… |
| 2 | [moonbitlang/moonback](https://mooncakes.io/docs/moonbitlang/moonback) | 0.8.10 | A web backend framework for MoonBit |
| 3 | [colmugx/fuwaroid](https://mooncakes.io/docs/colmugx/fuwaroid) | 0.3.2 | Lightweight single-writer concurrency |
| 4 | [moonbit-community/pty](https://mooncakes.io/docs/moonbit-community/pty) | 0.4.4 | Cross-platform PTY (pseudo-terminal) spawning for MoonBit native targets, integr… |
| 5 | [moonbit-community/tty](https://mooncakes.io/docs/moonbit-community/tty) | 0.6.2 | Low-level terminal primitives for MoonBit native and wasm targets: a sidecar-hel… |
| 6 | [moonbitlang/jsonl](https://mooncakes.io/docs/moonbitlang/jsonl) | 0.2.1 | Async reader for JSON Lines (newline-delimited JSON) streams. |
| 7 | [Nanaloveyuki/sync](https://mooncakes.io/docs/Nanaloveyuki/sync) | 0.7.3 | Minimal native concurrency primitives for MoonBit. |
| 8 | [mizchi/js_core](https://mooncakes.io/docs/mizchi/js_core) | 0.13.0 | js ffi foundation for MoonBit (Any, Promise, Nullable, target-specific interop) |


## JSON 解析

JSON、JSON Lines、JSON5 的解析、生成与 JSON Schema 校验。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 115 个候选均为基础库，需按需组合。

### 基础库（115）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbitlang/x](https://mooncakes.io/docs/moonbitlang/x) | 0.5.7 | experimental packages for moonbitlang/core |
| 2 | [moonbitlang/jsonl](https://mooncakes.io/docs/moonbitlang/jsonl) | 0.2.1 | Async reader for JSON Lines (newline-delimited JSON) streams. |
| 3 | [colmugx/json-schema](https://mooncakes.io/docs/colmugx/json-schema) | 0.1.5 | Compile-once JSON Schema 2020-12 validator for MoonBit: exact decimal arithmetic… |
| 4 | [moonrockz/cucumber-messages](https://mooncakes.io/docs/moonrockz/cucumber-messages) | 0.5.0 | Cucumber Messages protocol types for MoonBit with JSON serialization and NDJSON … |
| 5 | [mizchi/jsonschema](https://mooncakes.io/docs/mizchi/jsonschema) | 0.8.1 | JSON Schema validator and code generator for MoonBit |
| 6 | [moonbitstack/moonschema](https://mooncakes.io/docs/moonbitstack/moonschema) | 0.2.3 | JSON Schema validation for MoonBit, draft-04 through v1: four output formats, ni… |
| 7 | [mizchi/js_builtin](https://mooncakes.io/docs/mizchi/js_builtin) | 0.13.0 | javascript built-in object bindings (Object, Array, JSON, RegExp, Symbol, Proxy,… |
| 8 | [moonbitstack/moonjson](https://mooncakes.io/docs/moonbitstack/moonjson) | 0.4.2 | JSON, its dialects and its binary encodings for MoonBit. |
| 9 | [gaato/sdk-runtime](https://mooncakes.io/docs/gaato/sdk-runtime) | 0.7.0 | API-agnostic client runtime for MoonBit SDKs: error taxonomy, Retry-After and ba… |
| 10 | [colmugx/acp](https://mooncakes.io/docs/colmugx/acp) | 0.3.0 | Type-safe Agent Client Protocol (ACP) SDK for MoonBit. |
| 11 | [colmugx/lody](https://mooncakes.io/docs/colmugx/lody) | 0.1.0 | 1:1 MoonBit mirror of the LodyAI acp-extension-core contract (tool vocabulary, _… |
| 12 | [totto2727/agent-core-sdk](https://mooncakes.io/docs/totto2727/agent-core-sdk) | 0.1.2 | Shared MoonBit process foundation for agent CLIs |


## 配置 / 标记格式

YAML、TOML、XML、CSV、INI、Ion 等配置与标记语言的解析与生成。

### 完整方案（1）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [Yu-zh/data](https://mooncakes.io/docs/Yu-zh/data) | 0.2.1 | A serde-shaped serialization framework: one data model, many formats |

> 完整方案仅 1 个，说明该类需求目前在生态中主要依靠基础库组合实现，下方基础库清单的实用价值更高。

### 基础库（61）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonrockz/ion](https://mooncakes.io/docs/moonrockz/ion) | 0.7.0 | A MoonBit implementation of the Amazon Ion data format and Ion Schema. |
| 2 | [Milky2018/xml](https://mooncakes.io/docs/Milky2018/xml) | 0.6.1 | A document-buffered pull XML parser for MoonBit |
| 3 | [moonbit-community/toml](https://mooncakes.io/docs/moonbit-community/toml) | 0.5.1 | A TOML parser implementation in MoonBit |
| 4 | [moonbit-community/NyaCSV](https://mooncakes.io/docs/moonbit-community/NyaCSV) | 0.3.4 | Purr-fectly parse your CSV files with delightful simplicity! |
| 5 | [moonbitstack/moonyaml](https://mooncakes.io/docs/moonbitstack/moonyaml) | 0.1.3 | YAML 1.0, 1.1 and 1.2 for MoonBit. |
| 6 | [xunyoyo/NyaCSV](https://mooncakes.io/docs/xunyoyo/NyaCSV) | 0.3.3 | Purr-fectly parse your CSV files with delightful simplicity! |
| 7 | [maria/csv_parser](https://mooncakes.io/docs/maria/csv_parser) | 0.1.0 | A robust RFC 4180 compliant CSV parser with support for custom delimiters, quote… |
| 8 | [MuVirus/moonfig](https://mooncakes.io/docs/MuVirus/moonfig) | 0.1.8 | MoonBit 原生配置库：一处声明，多来源汇入。 |


## 二进制编码

CBOR、Protocol Buffers、MessagePack、ASN.1 等二进制序列化格式。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 19 个候选均为基础库，需按需组合。

### 基础库（19）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [mizchi/cbor](https://mooncakes.io/docs/mizchi/cbor) | 0.1.1 | CBOR (RFC 8949) implementation for MoonBit - Pure and FFI versions |
| 2 | [moonbitstack/moonjson](https://mooncakes.io/docs/moonbitstack/moonjson) | 0.4.2 | JSON, its dialects and its binary encodings for MoonBit. |
| 3 | [moonbitlang/protobuf](https://mooncakes.io/docs/moonbitlang/protobuf) | 0.2.0 | The runtime library for protobuf |
| 4 | [oilleelssq-wq/MoonBit-PKI](https://mooncakes.io/docs/oilleelssq-wq/MoonBit-PKI) | 0.2.0 | Pure-MoonBit ASN.1 DER codec and X.509 certificate toolkit. |
| 5 | [moonbitstack/moonrpc](https://mooncakes.io/docs/moonbitstack/moonrpc) | 0.21.7 | gRPC for MoonBit. |
| 6 | [2515050242/cbor](https://mooncakes.io/docs/2515050242/cbor) | 0.1.2 | A high-performance, standard-compliant CBOR (RFC 8949) serialization library for… |
| 7 | [yugonlian/moon-avro](https://mooncakes.io/docs/yugonlian/moon-avro) | 0.3.0 | Pure MoonBit Apache Avro schema, datum codec, and Object Container File toolkit. |
| 8 | [Xpeng/moonthrift](https://mooncakes.io/docs/Xpeng/moonthrift) | 0.4.0 | Apache Thrift IDL tooling and binary protocol support for MoonBit |
| 9 | [hbYlj/moonldap](https://mooncakes.io/docs/hbYlj/moonldap) | 0.3.0 | RFC-driven LDAPv3 client library for MoonBit with a generic ASN.1 BER codec |
| 10 | [MuVirus/moonfig](https://mooncakes.io/docs/MuVirus/moonfig) | 0.1.8 | MoonBit 原生配置库：一处声明，多来源汇入。 |
| 11 | [f4ah6o/direct_sdk](https://mooncakes.io/docs/f4ah6o/direct_sdk) | 0.11.2 | MoonBit SDK for Direct4B WebSocket API with MessagePack RPC |
| 12 | [2515050243qyf/moon_bencode](https://mooncakes.io/docs/2515050243qyf/moon_bencode) | 0.2.0 | A fast and compliant Bencode encoder and decoder for MoonBit. |


## 日志 / 追踪

结构化日志、tracing、OpenTelemetry、指标。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 29 个候选均为基础库，需按需组合。

### 基础库（29）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [tonyfettes/xlog](https://mooncakes.io/docs/tonyfettes/xlog) | 0.4.2 | Native structured logging with levels and category-based filtering. |
| 2 | [moonbitstack/moonlog](https://mooncakes.io/docs/moonbitstack/moonlog) | 0.1.4 | Structured logging for MoonBit. |
| 3 | [moonrockz/moon-lander-logging](https://mooncakes.io/docs/moonrockz/moon-lander-logging) | 0.11.0 | Structured logging with a bring-your-own logger trait for the Moon-Lander framew… |
| 4 | [moonrockz/moon-lander-logging-hosting-async](https://mooncakes.io/docs/moonrockz/moon-lander-logging-hosting-async) | 0.11.0 | Console and rolling file delivery for Moon-Lander logging, with bounded async se… |
| 5 | [brickfrog/moontrace](https://mooncakes.io/docs/brickfrog/moontrace) | 0.14.0 | Structured tracing for MoonBit with spans, structured fields, pluggable subscrib… |
| 6 | [Milky2018/sysinfo](https://mooncakes.io/docs/Milky2018/sysinfo) | 0.1.6 | System metrics and process inspection library. |
| 7 | [mohongquan0630/moon-prometheus](https://mooncakes.io/docs/mohongquan0630/moon-prometheus) | 0.2.6 | — |
| 8 | [ryota0624/moonbit_otel](https://mooncakes.io/docs/ryota0624/moonbit_otel) | 0.1.0 | — |
| 9 | [CCllff-jpg/MoonLogTrace](https://mooncakes.io/docs/CCllff-jpg/MoonLogTrace) | 0.1.4 | Pure MoonBit structured logging and tracing library with safe formatters, replay… |
| 10 | [LilaLola67/moonmcap](https://mooncakes.io/docs/LilaLola67/moonmcap) | 0.17.4 | MoonBit-native MCAP message-log codec, indexed queries and file transformations |
| 11 | [Nanaloveyuki/BitLogger](https://mooncakes.io/docs/Nanaloveyuki/BitLogger) | 0.9.1 | A structured logger for MoonBit. |
| 12 | [chensuiyi/logfly](https://mooncakes.io/docs/chensuiyi/logfly) | 0.3.0 | Logging for MoonBit: plain text and JSONL appenders with timestamps, and size-tr… |


## 运维 / 系统管理

进程守护与进程检查、子进程与命令执行、伪终端控制、CI 任务运行。生态中尚无运维框架，但已有可直接部署的成品工具，与若干可组合的基础库。

> 本场景为**人工圈定**：候选包与其顺序由人工确定，因为该领域在生态里还没有形成可靠的关键词信号。

> 进程管理器与 CI 运行器本身就是可用成品，计入「完整方案」；其余为单点能力的基础库，需要自行组装。

### 完整方案（4）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [chensuiyi/bm2](https://mooncakes.io/docs/chensuiyi/bm2) | 0.8.0 | A lightweight Linux process manager for Bun and Node.js applications, written in… |
| 2 | [mizchi/actrun](https://mooncakes.io/docs/mizchi/actrun) | 0.32.0 | MVP GitHub Actions-compatible push CI runner with bitflow lowering, native execu… |
| 3 | [kupas/pm3](https://mooncakes.io/docs/kupas/pm3) | 0.1.8 | A language-agnostic process manager (PM2-like) with built-in log rotation |
| 4 | [tiye/redstart](https://mooncakes.io/docs/tiye/redstart) | 0.1.4 | Lightweight process manager for local development |

### 基础库（8）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbit-community/pty](https://mooncakes.io/docs/moonbit-community/pty) | 0.4.4 | Cross-platform PTY (pseudo-terminal) spawning for MoonBit native targets, integr… |
| 2 | [moonbit-community/tty](https://mooncakes.io/docs/moonbit-community/tty) | 0.6.2 | Low-level terminal primitives for MoonBit native and wasm targets: a sidecar-hel… |
| 3 | [Milky2018/sysinfo](https://mooncakes.io/docs/Milky2018/sysinfo) | 0.1.6 | System metrics and process inspection library. |
| 4 | [mizchi/process_pool](https://mooncakes.io/docs/mizchi/process_pool) | 0.1.4 | — |
| 5 | [moonbit-community/proton_process](https://mooncakes.io/docs/moonbit-community/proton_process) | 0.2.6 | Native child process spawning for MoonBit on Windows, Linux, and macOS. |
| 6 | [trkbt10/subprocess](https://mooncakes.io/docs/trkbt10/subprocess) | 0.2.0 | Node.js child_process-like subprocess management for MoonBit |
| 7 | [trkbt10/osenv](https://mooncakes.io/docs/trkbt10/osenv) | 0.1.0 | OS environment utilities: platform detection, safe path operations, and OS-stand… |
| 8 | [mizchi/tempfile](https://mooncakes.io/docs/mizchi/tempfile) | 0.1.3 | Temporary file and directory management for MoonBit |


## LLM / Agent / MCP

大模型客户端、Agent 框架、MCP 服务端/客户端、提示词。

### 完整方案（5）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [colmugx/posoco](https://mooncakes.io/docs/colmugx/posoco) | 0.23.2 | LLM Agent framework with hexagonal (ports-and-adapters) architecture. Defines ex… |
| 2 | [colmugx/mcp](https://mooncakes.io/docs/colmugx/mcp) | 0.18.2 | Type-safe MCP SDK in MoonBit with server/client support and dual transport (STDI… |
| 3 | [golemcloud/golem_sdk](https://mooncakes.io/docs/golemcloud/golem_sdk) | 0.6.2 | Golem SDK for MoonBit — build durable, fault-tolerant agents on the Golem platfo… |
| 4 | [weopqrst/agent](https://mooncakes.io/docs/weopqrst/agent) | 0.5.1 | MoonBit version of LangChain core library — type-safe, composable, embeddable AI… |
| 5 | [soehi/moonlm](https://mooncakes.io/docs/soehi/moonlm) | 0.1.2 | Local LLM inference engine and strongly-typed agent runtime, in MoonBit |

### 基础库（111）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [mizchi/llm](https://mooncakes.io/docs/mizchi/llm) | 0.3.2 | Pure MoonBit LLM client library |
| 2 | [colmugx/acp](https://mooncakes.io/docs/colmugx/acp) | 0.3.0 | Type-safe Agent Client Protocol (ACP) SDK for MoonBit. |
| 3 | [DC-Z-lab/moonllm](https://mooncakes.io/docs/DC-Z-lab/moonllm) | 0.1.0 | Type-safe, OpenAI-compatible LLM client for MoonBit: chat completions, streaming… |
| 4 | [marianoguerra/llm](https://mooncakes.io/docs/marianoguerra/llm) | 0.4.2 | A dialect-agnostic LLM IR, one wire mapping per provider protocol, a data-driven… |
| 5 | [colmugx/lody](https://mooncakes.io/docs/colmugx/lody) | 0.1.0 | 1:1 MoonBit mirror of the LodyAI acp-extension-core contract (tool vocabulary, _… |
| 6 | [totto2727/codex-sdk](https://mooncakes.io/docs/totto2727/codex-sdk) | 0.4.1 | MoonBit SDK for embedding the Codex agent in workflows and applications |
| 7 | [wzzc-dev/moui_agent_mcp](https://mooncakes.io/docs/wzzc-dev/moui_agent_mcp) | 0.2.6 | MCP JSON-RPC router and stdio transport exposing a MoUI AgentHost to external ag… |
| 8 | [gaato/openai](https://mooncakes.io/docs/gaato/openai) | 0.6.0 | Thin OpenAI API client for MoonBit built on gaato/http and gaato/sdk-runtime: mo… |


## 解析器 / 语法

词法、语法、parser combinator、AST、tree-sitter、parser generator。

### 完整方案（2）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbitlang/yacc](https://mooncakes.io/docs/moonbitlang/yacc) | 0.7.25 | A LR(1) parser generator for MoonBit programming language. |
| 2 | [cogna-dev/parkit](https://mooncakes.io/docs/cogna-dev/parkit) | 0.1.1 | A nom-like parser combinator framework for MoonBit |

> 完整方案仅 2 个，说明该类需求目前在生态中主要依靠基础库组合实现，下方基础库清单的实用价值更高。

### 基础库（227）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbitlang/parser](https://mooncakes.io/docs/moonbitlang/parser) | 0.4.7 | AST and parsers for the MoonBit programming language |
| 2 | [bobzhang/lexer](https://mooncakes.io/docs/bobzhang/lexer) | 0.3.1 | A generic lexer library for handwritten lexers in MoonBit |
| 3 | [Milky2018/xml](https://mooncakes.io/docs/Milky2018/xml) | 0.6.1 | A document-buffered pull XML parser for MoonBit |
| 4 | [moonrockz/krueger](https://mooncakes.io/docs/moonrockz/krueger) | 0.8.0 | Parser and parsing utilities for Elm and Elm-like dialects (e.g. Morphir) in Moo… |
| 5 | [moonbitlang/lexer](https://mooncakes.io/docs/moonbitlang/lexer) | 0.4.4 | Lexer for the MoonBit programming language |
| 6 | [moonbit-community/toml](https://mooncakes.io/docs/moonbit-community/toml) | 0.5.1 | A TOML parser implementation in MoonBit |
| 7 | [dowdiness/graphviz](https://mooncakes.io/docs/dowdiness/graphviz) | 0.1.0 | Parser, layout engine, and SVG renderer for Graphviz DOT graphs |
| 8 | [mizchi/cst](https://mooncakes.io/docs/mizchi/cst) | 0.1.10 | Concrete Syntax Tree library with Red-Green Tree pattern |


## 编译器 / 代码生成

编译器、字节码与虚拟机、代码生成、类型检查、LLVM 与原生后端。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 79 个候选均为基础库，需按需组合。

### 基础库（79）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [Kaida-Amethyst/MoonLLVM](https://mooncakes.io/docs/Kaida-Amethyst/MoonLLVM) | 0.1.18 | Moonbit version of LLVM, A Tiny, Friendly Companion to LLVM |
| 2 | [Milky2018/aarch64_target](https://mooncakes.io/docs/Milky2018/aarch64_target) | 0.18.0 | AArch64 direct MilkIR target pipeline to native code |
| 3 | [dowdiness/js_engine](https://mooncakes.io/docs/dowdiness/js_engine) | 0.9.0 | Pure MoonBit cross-target embedded JavaScript engine |
| 4 | [Milky2018/x64_target](https://mooncakes.io/docs/Milky2018/x64_target) | 0.18.0 | x64 direct MilkIR target pipeline to native code |
| 5 | [mizchi/jsonschema](https://mooncakes.io/docs/mizchi/jsonschema) | 0.8.1 | JSON Schema validator and code generator for MoonBit |
| 6 | [Milky2018/vcode](https://mooncakes.io/docs/Milky2018/vcode) | 0.18.0 | Target-independent native lowering, VCode, and code-object infrastructure |
| 7 | [moonbitlang/protobuf](https://mooncakes.io/docs/moonbitlang/protobuf) | 0.2.0 | The runtime library for protobuf |
| 8 | [mizchi/codegen](https://mooncakes.io/docs/mizchi/codegen) | 0.2.4 | Generic code generation library with abstract IR |
| 9 | [Milky2018/machv](https://mooncakes.io/docs/Milky2018/machv) | 0.12.6 | Target-neutral semantic machine IR |
| 10 | [Kaida-Amethyst/llvm](https://mooncakes.io/docs/Kaida-Amethyst/llvm) | 0.6.2 | llvm-c binding for Moonbit with friendly API, keeps the Cpp Style. |
| 11 | [Milky2018/milkir_machv](https://mooncakes.io/docs/Milky2018/milkir_machv) | 0.12.6 | MilkIR-to-MachV lowering |
| 12 | [mizchi/pkl](https://mooncakes.io/docs/mizchi/pkl) | 0.7.0 | Pure MoonBit parser, interpreter, and typechecker experiments for Apple's Pkl la… |


## 正则匹配

正则表达式引擎与匹配。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 9 个候选均为基础库，需按需组合。

### 基础库（9）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbitlang/regexp](https://mooncakes.io/docs/moonbitlang/regexp) | 0.3.7 | A regular expression engine for MoonBit based on VM execution designed for predi… |
| 2 | [yj-qin/regexp](https://mooncakes.io/docs/yj-qin/regexp) | 0.3.6 | A regular expression library based on a backtracking engine. |
| 3 | [walkzzz/re-mbt](https://mooncakes.io/docs/walkzzz/re-mbt) | 0.1.0 | A port of ocaml-re — the pure OCaml regular expression library — to idiomatic Mo… |
| 4 | [moonbitstack/moonregex](https://mooncakes.io/docs/moonbitstack/moonregex) | 0.1.2 | Regular expressions for MoonBit. |
| 5 | [mizchi/js_regexp](https://mooncakes.io/docs/mizchi/js_regexp) | 0.0.4 | JS RegExp binding |
| 6 | [ZijianFeng33/regexp](https://mooncakes.io/docs/ZijianFeng33/regexp) | 0.1.0 | a simple regex matcher in moon |
| 7 | [Hjyyutr/moonyara](https://mooncakes.io/docs/Hjyyutr/moonyara) | 0.1.5 | A native MoonBit threat signature matching and malware scanning engine. |
| 8 | [YeeHh2004/mooninput](https://mooncakes.io/docs/YeeHh2004/mooninput) | 0.2.2 | Composable structured input editing: dynamic masks, bounded regex, validation, n… |
| 9 | [FidollarinLA/moonmask](https://mooncakes.io/docs/FidollarinLA/moonmask) | 0.1.0 | Constrained decoding for LLMs in MoonBit: compile JSON Schema and regex to byte-… |


## Unicode / 文本处理

Unicode 分类、字素簇、宽度计算、字符串工具。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 104 个候选均为基础库，需按需组合。

### 基础库（104）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbit-community/charclass](https://mooncakes.io/docs/moonbit-community/charclass) | 0.1.4 | Unicode character classification library providing functions to determine charac… |
| 2 | [moonbit-community/unicodewidth](https://mooncakes.io/docs/moonbit-community/unicodewidth) | 0.2.1 | A simple library for measuring the width of unicode characters and strings. |
| 3 | [kawaz/grapheme](https://mooncakes.io/docs/kawaz/grapheme) | 0.10.4 | Unicode grapheme cluster segmentation library for MoonBit (UAX #29) |
| 4 | [moonbit-community/displaytext](https://mooncakes.io/docs/moonbit-community/displaytext) | 0.1.7 | Grapheme-aware display-cell text boundaries for terminal UIs. |
| 5 | [mizchi/x](https://mooncakes.io/docs/mizchi/x) | 0.6.1 | Cross-platform MoonBit compatibility facades with native delegation and accelera… |
| 6 | [myfreess/charclass](https://mooncakes.io/docs/myfreess/charclass) | 0.1.3 | Unicode character classification library providing functions to determine charac… |
| 7 | [moonbit-community/ucd](https://mooncakes.io/docs/moonbit-community/ucd) | 0.5.2 | Unicode Character Database lookup and case mapping for MoonBit |
| 8 | [moonbit-community/prettyprinter](https://mooncakes.io/docs/moonbit-community/prettyprinter) | 0.4.11 | pretty printer for moonbit |
| 9 | [Milky2018/moon_cosmic](https://mooncakes.io/docs/Milky2018/moon_cosmic) | 0.3.8 | MoonBit port of cosmic-text (text shaping, layout, and editor primitives) built … |
| 10 | [moonbit-community/bidi](https://mooncakes.io/docs/moonbit-community/bidi) | 0.5.2 | Unicode Bidirectional Algorithm for MoonBit |
| 11 | [moonbit-community/unicode](https://mooncakes.io/docs/moonbit-community/unicode) | 0.6.0 | Unicode in MoonBit |
| 12 | [moonbit-community/fuzzy_match](https://mooncakes.io/docs/moonbit-community/fuzzy_match) | 0.2.6 | A library for fuzzy string matching and fuzzy string searching |


## 哈希 / 校验

哈希函数、消息摘要、HMAC 与校验和（CRC / FNV）。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 44 个候选均为基础库，需按需组合。

### 基础库（44）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [gmlewis/hash](https://mooncakes.io/docs/gmlewis/hash) | 0.21.2 | MoonBit hash: provide hash functions similar to Go. |
| 2 | [cc06b/mooncry](https://mooncakes.io/docs/cc06b/mooncry) | 0.95.0 | Pure-MoonBit crypto primitives: SHA-1/2 (incl. SHA-512/224/256), SHA-3, Keccak-2… |
| 3 | [Tigls/mb-hash](https://mooncakes.io/docs/Tigls/mb-hash) | 0.1.0 | Secure hashing for MoonBit (SHA-256, SHA-512; native+WASM) |
| 4 | [moonbitstack/mooncrypt](https://mooncakes.io/docs/moonbitstack/mooncrypt) | 0.4.7 | Cryptographic algorithms for MoonBit, one per package. |
| 5 | [gmlewis/sha256](https://mooncakes.io/docs/gmlewis/sha256) | 0.18.2 | MoonBit sha256: provide simple sha256 hash algorithm. |
| 6 | [gmlewis/md5](https://mooncakes.io/docs/gmlewis/md5) | 0.20.2 | MoonBit md5: provide simple md5 hash algorithm. |
| 7 | [mizchi/bit_hash](https://mooncakes.io/docs/mizchi/bit_hash) | 0.48.1 | Git object hashing primitives (gix-hash equivalent) |
| 8 | [gmlewis/crc32](https://mooncakes.io/docs/gmlewis/crc32) | 0.9.2 | MoonBit crc32: provide simple crc32 hash algorithm. |
| 9 | [gmlewis/sha1](https://mooncakes.io/docs/gmlewis/sha1) | 0.12.17 | MoonBit sha1: provide simple sha1 hash algorithm. |
| 10 | [shu-kitamura/sha256](https://mooncakes.io/docs/shu-kitamura/sha256) | 0.1.1 | A simple sha256 algorithm implemented in moonbit |
| 11 | [tonyfettes/xxh64](https://mooncakes.io/docs/tonyfettes/xxh64) | 0.1.0 | XXH64 — a fast, portable, high-quality non-cryptographic hash. Faithful MoonBit … |
| 12 | [Tigls/mb-hmac](https://mooncakes.io/docs/Tigls/mb-hmac) | 0.1.0 | HMAC message authentication for MoonBit (HMAC-SHA256, HMAC-SHA512; native+WASM) |


## 加密 / 签名

对称与非对称加密、数字签名、密钥交换、证书。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 29 个候选均为基础库，需按需组合。

### 基础库（29）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbit-community/proton_rsa](https://mooncakes.io/docs/moonbit-community/proton_rsa) | 0.6.0 | RSASSA-PKCS1-v1_5 signature verification over SHA-256. |
| 2 | [hustcer/ed25519](https://mooncakes.io/docs/hustcer/ed25519) | 0.6.1 | A pure MoonBit Ed25519 signing and verification package. |
| 3 | [illusory0x0/rijndael](https://mooncakes.io/docs/illusory0x0/rijndael) | 0.1.0 | A MoonBit implementation of the Rijndael (AES) encryption algorithm |
| 4 | [cc06b/mooncry](https://mooncakes.io/docs/cc06b/mooncry) | 0.95.0 | Pure-MoonBit crypto primitives: SHA-1/2 (incl. SHA-512/224/256), SHA-3, Keccak-2… |
| 5 | [moonbitstack/mooncrypt](https://mooncakes.io/docs/moonbitstack/mooncrypt) | 0.4.7 | Cryptographic algorithms for MoonBit, one per package. |
| 6 | [mizchi/experimental_crypto](https://mooncakes.io/docs/mizchi/experimental_crypto) | 0.0.2 | EXPERIMENTAL — pure-MoonBit cryptography / PKI / JOSE building blocks. Education… |
| 7 | [justinwongcn/moonpgp](https://mooncakes.io/docs/justinwongcn/moonpgp) | 0.4.0 | Pure-MoonBit OpenPGP implementation (RFC 4880/9580): email encryption, decryptio… |
| 8 | [moonbitstack/moonrand](https://mooncakes.io/docs/moonbitstack/moonrand) | 0.1.1 | Reproducible pseudo-random generators, unbiased sampling and the common distribu… |
| 9 | [RabitLogic/mjwt](https://mooncakes.io/docs/RabitLogic/mjwt) | 0.2.0 | A JWT (JSON Web Token) library for MoonBit with extensible trait-based signers |
| 10 | [ruifeng/moondsa](https://mooncakes.io/docs/ruifeng/moondsa) | 0.2.1 | moondsa is a MoonBit implementation of Dilithium, a post-quantum signature schem… |
| 11 | [lindividual/der](https://mooncakes.io/docs/lindividual/der) | 0.2.1 | ASN.1 DER parser for MoonBit. Supports PKCS#1 and PKCS#8 RSA private key parsing… |
| 12 | [mizchi/bitx_openpgp](https://mooncakes.io/docs/mizchi/bitx_openpgp) | 0.48.1 | Native OpenPGP signature verification (extension module for mizchi/bit) |


## 编码 / 转义

Base64 / Base32 / Hex 等编码、URL 百分号编码、转义与变长整数。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 35 个候选均为基础库，需按需组合。

### 基础库（35）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [cc06b/mooncry](https://mooncakes.io/docs/cc06b/mooncry) | 0.95.0 | Pure-MoonBit crypto primitives: SHA-1/2 (incl. SHA-512/224/256), SHA-3, Keccak-2… |
| 2 | [gmlewis/base64](https://mooncakes.io/docs/gmlewis/base64) | 0.16.14 | MoonBit base64: provide simple base64 operations. |
| 3 | [mizchi/cbor](https://mooncakes.io/docs/mizchi/cbor) | 0.1.1 | CBOR (RFC 8949) implementation for MoonBit - Pure and FFI versions |
| 4 | [moonbitstack/moonbase](https://mooncakes.io/docs/moonbitstack/moonbase) | 0.4.2 | Every base encoding, one shape: base2 through base85, bech32 and multibase for M… |
| 5 | [moonbitstack/moonurl](https://mooncakes.io/docs/moonbitstack/moonurl) | 0.2.3 | URLs for MoonBit: WHATWG and RFC 3986 parsing, IDNA, URI templates, percent codi… |
| 6 | [tonyfettes/encoding](https://mooncakes.io/docs/tonyfettes/encoding) | 0.3.9 | Encoding package extracted from moonbitlang/x |
| 7 | [LL728/moon_encoding](https://mooncakes.io/docs/LL728/moon_encoding) | 0.2.0 | WHATWG Encoding Standard 的 MoonBit 实现：label 解析、流式解码与一次性编码 API，覆盖规范定义的全部 40 种编码（含… |
| 8 | [superbigcup325/colenc](https://mooncakes.io/docs/superbigcup325/colenc) | 0.1.3 | Columnar encoding kernel for MoonBit: the Parquet page-level encoding family as … |
| 9 | [moonbitstack/moonvar](https://mooncakes.io/docs/moonbitstack/moonvar) | 0.2.0 | moonvar — how a number becomes bytes and back, for MoonBit: byte order for the f… |
| 10 | [f4ah6o/encoding_sjis](https://mooncakes.io/docs/f4ah6o/encoding_sjis) | 0.1.1 | encoding_rs-compliant Shift_JIS decoder for MoonBit |
| 11 | [horideicom/encoding_sjis](https://mooncakes.io/docs/horideicom/encoding_sjis) | 0.1.1 | encoding_rs-compliant Shift_JIS decoder for MoonBit |
| 12 | [2d5rrr333/toolsfx-moonbit](https://mooncakes.io/docs/2d5rrr333/toolsfx-moonbit) | 0.3.0 | Pure-MoonBit crypto & CTF toolbox (a port of ToolsFx): national crypto SM2/SM3/S… |


## 压缩 / 归档

DEFLATE / zlib / gzip / ZIP 的压缩与解压实现。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 55 个候选均为基础库，需按需组合。

### 基础库（55）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [mizchi/zlib](https://mooncakes.io/docs/mizchi/zlib) | 0.4.10 | Pure MoonBit zlib/deflate implementation. |
| 2 | [moonbit-community/flate](https://mooncakes.io/docs/moonbit-community/flate) | 0.10.0 | Pure-MoonBit, runtime-agnostic DEFLATE (RFC 1951) engine with gzip/zlib/zip wrap… |
| 3 | [Milky2018/moon_yazi](https://mooncakes.io/docs/Milky2018/moon_yazi) | 0.1.4 | A small zlib/DEFLATE implementation in MoonBit (ported from yazi). |
| 4 | [gmlewis/zlib](https://mooncakes.io/docs/gmlewis/zlib) | 0.21.17 | MoonBit zlib: provide simplified zlib format compressed data. |
| 5 | [mizchi/brotli](https://mooncakes.io/docs/mizchi/brotli) | 0.2.2 | Brotli compression and decompression library for MoonBit |
| 6 | [mizchi/x](https://mooncakes.io/docs/mizchi/x) | 0.6.1 | Cross-platform MoonBit compatibility facades with native delegation and accelera… |
| 7 | [hustcer/fzip](https://mooncakes.io/docs/hustcer/fzip) | 0.8.8 | High-performance compression library for MoonBit, ported from fflate. (DEFLATE/G… |
| 8 | [hustcer/fbr](https://mooncakes.io/docs/hustcer/fbr) | 0.8.2 | Pure MoonBit Brotli (.br) encoder and decoder with split encode/decode packages |
| 9 | [gmlewis/flate](https://mooncakes.io/docs/gmlewis/flate) | 0.36.17 | MoonBit flate: provide simplified flate (LZW) compression algorithm. |
| 10 | [moonbit-community/zipc](https://mooncakes.io/docs/moonbit-community/zipc) | 0.2.2 | Typed, in-memory ZIP archive library for MoonBit (deflate via moonbit-community/… |
| 11 | [Milky2018/zstd](https://mooncakes.io/docs/Milky2018/zstd) | 0.1.4 | — |
| 12 | [bikallem/compress](https://mooncakes.io/docs/bikallem/compress) | 0.3.4 | Compression library for MoonBit: flate, gzip, zlib, lzw, bzip2, snappy, lz4, zst… |


## 文件 / 路径 / IO

文件系统访问、路径与环境变量、临时文件、通用 IO 抽象与文件监听。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 122 个候选均为基础库，需按需组合。

### 基础库（122）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [mizchi/tempfile](https://mooncakes.io/docs/mizchi/tempfile) | 0.1.3 | Temporary file and directory management for MoonBit |
| 2 | [mizchi/x](https://mooncakes.io/docs/mizchi/x) | 0.6.1 | Cross-platform MoonBit compatibility facades with native delegation and accelera… |
| 3 | [gmlewis/io](https://mooncakes.io/docs/gmlewis/io) | 0.23.20 | MoonBit io: provide simplified I/O abstractions similar to Go. |
| 4 | [moonbitlang/jsonl](https://mooncakes.io/docs/moonbitlang/jsonl) | 0.2.1 | Async reader for JSON Lines (newline-delimited JSON) streams. |
| 5 | [mizchi/fswatch](https://mooncakes.io/docs/mizchi/fswatch) | 0.2.1 | Cross-platform filesystem watcher for MoonBit: FSEvents on macOS, inotify on Lin… |
| 6 | [cc06b/mooncry](https://mooncakes.io/docs/cc06b/mooncry) | 0.95.0 | Pure-MoonBit crypto primitives: SHA-1/2 (incl. SHA-512/224/256), SHA-3, Keccak-2… |
| 7 | [Kaida-Amethyst/path](https://mooncakes.io/docs/Kaida-Amethyst/path) | 0.1.1 | A cross-platform file path manipulation library for MoonBit, supporting both Uni… |
| 8 | [trkbt10/osenv](https://mooncakes.io/docs/trkbt10/osenv) | 0.1.0 | OS environment utilities: platform detection, safe path operations, and OS-stand… |
| 9 | [totto2727/target-file-discovery](https://mooncakes.io/docs/totto2727/target-file-discovery) | 0.2.1 | Reusable target file discovery for MoonBit |
| 10 | [ZSeanYves/bufferutils](https://mooncakes.io/docs/ZSeanYves/bufferutils) | 0.37.0 | Zero-copy shared byte buffers with high-performance synchronous, native, and asy… |
| 11 | [vicTop-cw/RX-MBT](https://mooncakes.io/docs/vicTop-cw/RX-MBT) | 0.4.0 | Rx-Rust 的 MoonBit 复刻：基于 Observer 模式的响应式编程库（Observable / Subject / Scheduler / 操作… |
| 12 | [mizchi/js_web](https://mooncakes.io/docs/mizchi/js_web) | 0.13.1 | web standard api bindings (fetch, Streams, Blob, URL, Crypto, ...) |


## 数学 / 数值计算

高精度数学、线性代数、矩阵、BLAS、统计。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 64 个候选均为基础库，需按需组合。

### 基础库（64）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [Kaida-Amethyst/math](https://mooncakes.io/docs/Kaida-Amethyst/math) | 0.1.21 | High-precision Math library Implemented By Pure Moonbit |
| 2 | [Luna-Flow/luna-generic](https://mooncakes.io/docs/Luna-Flow/luna-generic) | 0.4.0 | Algebraic traits and default numeric instances that define the generic foundatio… |
| 3 | [Luna-Flow/linear-algebra](https://mooncakes.io/docs/Luna-Flow/linear-algebra) | 0.5.2 | Trait-oriented linear algebra foundations for MoonBit, with checked APIs, backen… |
| 4 | [mizchi/blas](https://mooncakes.io/docs/mizchi/blas) | 0.1.3 | BLAS bindings for MoonBit (Accelerate/OpenBLAS) |
| 5 | [mizchi/numbt](https://mooncakes.io/docs/mizchi/numbt) | 0.2.4 | NumPy-style numerical computing library for MoonBit |
| 6 | [Luna-Flow/luna-utils](https://mooncakes.io/docs/Luna-Flow/luna-utils) | 0.3.0 | Backend-independent numeric base with floating-point classification, canonical N… |
| 7 | [Luna-Flow/calculus-numerical](https://mooncakes.io/docs/Luna-Flow/calculus-numerical) | 0.3.1 | A numerical calculus library, a part of LunaFlow. |
| 8 | [Luna-Flow/arithmetic](https://mooncakes.io/docs/Luna-Flow/arithmetic) | 0.5.1 | Arithmetic capability traits and checked analytic operations for LunaFlow numeri… |
| 9 | [applejag/micromath](https://mooncakes.io/docs/applejag/micromath) | 0.3.0 | Embedded math arithmetic, optimized for small code size at the cost of precision |
| 10 | [CAIMEOX/moon_floating](https://mooncakes.io/docs/CAIMEOX/moon_floating) | 0.3.1 | Arbitrary-precision real, complex, interval, and numerical computing for MoonBit |
| 11 | [Luna-Flow/luna-poly](https://mooncakes.io/docs/Luna-Flow/luna-poly) | 0.4.0 | Immutable and mutable polynomial libraries for MoonBit with canonical dense, spa… |
| 12 | [bobzhang/loop_invariants_math](https://mooncakes.io/docs/bobzhang/loop_invariants_math) | 0.17.0 | Mathematical algorithms with loop-invariant explanations |


## 数据结构 / 算法

有序映射、B 树、堆、图算法、集合。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 95 个候选均为基础库，需按需组合。

### 基础库（95）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [dowdiness/btree](https://mooncakes.io/docs/dowdiness/btree) | 0.2.0 | Generic counted B-tree with O(log n) indexed access, insert, delete, and range o… |
| 2 | [dowdiness/order-tree](https://mooncakes.io/docs/dowdiness/order-tree) | 0.1.2 | Order-statistic B-tree with O(log n) position-indexed operations |
| 3 | [dowdiness/alga](https://mooncakes.io/docs/dowdiness/alga) | 0.4.0 | Algebraic graphs for MoonBit — directed graph trait and algorithm library inspir… |
| 4 | [dowdiness/rle](https://mooncakes.io/docs/dowdiness/rle) | 0.2.3 | Generic run-length encoded sequence with O(log n) position lookup |
| 5 | [dowdiness/event-graph-walker](https://mooncakes.io/docs/dowdiness/event-graph-walker) | 0.8.0 | Implementation of the eg-walker CRDT algorithm with FugueMax sequence CRDT |
| 6 | [moonbit-community/diago](https://mooncakes.io/docs/moonbit-community/diago) | 0.4.0 | A diagram toolkit for MoonBit with Dagre, ELK, and Railway layout engines, rende… |
| 7 | [wedarp/moongraph](https://mooncakes.io/docs/wedarp/moongraph) | 0.2.2 | Pure MoonBit generic graph data structures and algorithms |
| 8 | [wzzc-dev/moui_skia](https://mooncakes.io/docs/wzzc-dev/moui_skia) | 0.2.6 | MoonBit bindings for the Skia Graphics Library |
| 9 | [totto2727/any-collection](https://mooncakes.io/docs/totto2727/any-collection) | 0.2.2 | Typed references over mutable and immutable maps of dynamically typed values |
| 10 | [bobzhang/loop_invariants](https://mooncakes.io/docs/bobzhang/loop_invariants) | 0.9.0 | Comprehensive collection of algorithms and data structures with well-documented … |
| 11 | [wzzc-dev/moui_sun](https://mooncakes.io/docs/wzzc-dev/moui_sun) | 0.2.6 | Experimental MoonBit-native CPU raster stack for MoUI |
| 12 | [aurasuisui/indexmap](https://mooncakes.io/docs/aurasuisui/indexmap) | 0.4.0 | A hash map that preserves insertion order - MoonBit port of Rust's indexmap |


## 测试 / 断言 / 属性测试

单元测试、属性测试（quickcheck）、断言库、BDD、基准。

### 完整方案（4）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbitlang/quickcheck](https://mooncakes.io/docs/moonbitlang/quickcheck) | 0.15.1 | Automatic testing of MoonBit programs |
| 2 | [moonrockz/moonspec](https://mooncakes.io/docs/moonrockz/moonspec) | 0.11.0 | BDD test framework for MoonBit with Gherkin and Cucumber Expressions |
| 3 | [aspnmy/moonitest](https://mooncakes.io/docs/aspnmy/moonitest) | 0.2.1 | MoonBit integration test framework - real Docker/TCP/HTTP API via fangyinc/socke… |
| 4 | [Duckweed/moon-proof](https://mooncakes.io/docs/Duckweed/moon-proof) | 0.1.3 | MoonProof：MoonBit 文档与教程示例的持续验证框架——把文档里的代码块抽出来，隔离编译运行，回答“我们文档里的例子还都对吗” |

### 基础库（62）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonrockz/expect](https://mooncakes.io/docs/moonrockz/expect) | 0.6.1 | A fluent assertion library for MoonBit |
| 2 | [moonrockz/cucumber-expressions](https://mooncakes.io/docs/moonrockz/cucumber-expressions) | 0.6.1 | Cucumber Expressions parser and matcher for MoonBit |
| 3 | [moonrockz/gherkin](https://mooncakes.io/docs/moonrockz/gherkin) | 0.5.1 | A Gherkin parser for MoonBit with DOM, visitor, fold, and SAX-style APIs |
| 4 | [moonrockz/cucumber-messages](https://mooncakes.io/docs/moonrockz/cucumber-messages) | 0.5.0 | Cucumber Messages protocol types for MoonBit with JSON serialization and NDJSON … |
| 5 | [moonbit-community/fuzzy_match](https://mooncakes.io/docs/moonbit-community/fuzzy_match) | 0.2.6 | A library for fuzzy string matching and fuzzy string searching |
| 6 | [CAIMEOX/qc_pyext](https://mooncakes.io/docs/CAIMEOX/qc_pyext) | 0.1.1 | QuickCheck and reference testing extension for Python programs |
| 7 | [f4ah6o/turtles](https://mooncakes.io/docs/f4ah6o/turtles) | 0.4.7 | Mutation testing for MoonBit projects |
| 8 | [zhangbowen2006/moonbit-target-parity](https://mooncakes.io/docs/zhangbowen2006/moonbit-target-parity) | 0.5.1 | Reusable cross-target behavior contract comparison for MoonBit programs. |


## 开发工具 / 代码质量

代码格式化、静态分析、lint、结构化搜索与重构、代码生成与脚手架。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 60 个候选均为基础库，需按需组合。

### 基础库（60）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbitlang/formatter](https://mooncakes.io/docs/moonbitlang/formatter) | 0.1.6 | code prettifier for MoonBit |
| 2 | [riantr/moonbit_static_analysis](https://mooncakes.io/docs/riantr/moonbit_static_analysis) | 0.4.39 | Three-inspection (structural / type / behavior) static analysis for MoonBit prog… |
| 3 | [moonbitlang/protobuf](https://mooncakes.io/docs/moonbitlang/protobuf) | 0.2.0 | The runtime library for protobuf |
| 4 | [mizchi/codegen](https://mooncakes.io/docs/mizchi/codegen) | 0.2.4 | Generic code generation library with abstract IR |
| 5 | [moonbit-community/moongrep](https://mooncakes.io/docs/moonbit-community/moongrep) | 0.3.10 | Experimental MoonBit structural search and taint-analysis tool |
| 6 | [moonbitstack/moonast](https://mooncakes.io/docs/moonbitstack/moonast) | 0.2.4 | Code generation for MoonBit from annotated declarations. |
| 7 | [golemcloud/golem_sdk_tools](https://mooncakes.io/docs/golemcloud/golem_sdk_tools) | 0.6.2 | Code generation tools for the Golem SDK for MoonBit |
| 8 | [moonbitstack/moonctl](https://mooncakes.io/docs/moonbitstack/moonctl) | 0.12.5 | Project and code generator for MoonBit services. |
| 9 | [Milky2018/aarch64_target](https://mooncakes.io/docs/Milky2018/aarch64_target) | 0.18.0 | AArch64 direct MilkIR target pipeline to native code |
| 10 | [Milky2018/x64_target](https://mooncakes.io/docs/Milky2018/x64_target) | 0.18.0 | x64 direct MilkIR target pipeline to native code |
| 11 | [Milky2018/vcode](https://mooncakes.io/docs/Milky2018/vcode) | 0.18.0 | Target-independent native lowering, VCode, and code-object infrastructure |
| 12 | [marianoguerra/wax](https://mooncakes.io/docs/marianoguerra/wax) | 0.4.2 | The Wax language in MoonBit: parser, formatter, type checker, and wasm/wat emitt… |


## Markdown / 文档转换

Markdown 解析、HTML/PDF/DOCX 转换、文档排版。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 94 个候选均为基础库，需按需组合。

### 基础库（94）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbitlang/pdflite](https://mooncakes.io/docs/moonbitlang/pdflite) | 0.4.1 | Byte-oriented PDF reading, writing, and manipulation toolkit for MoonBit. |
| 2 | [bobzhang/html_parser](https://mooncakes.io/docs/bobzhang/html_parser) | 0.2.2 | MoonBit HTML parser and sanitizer ported from JustHTML. |
| 3 | [hustcer/html2md](https://mooncakes.io/docs/hustcer/html2md) | 0.1.3 | Convert HTML to Markdown (CommonMark), a MoonBit port of JohannesKaufmann/html-t… |
| 4 | [moonbitlang/pagelayout](https://mooncakes.io/docs/moonbitlang/pagelayout) | 0.8.1 | Paginated document layout engine: format-neutral page-model IR with SVG/PDF back… |
| 5 | [moonbitlang/docx2html](https://mooncakes.io/docs/moonbitlang/docx2html) | 0.7.1 | Native MoonBit DOCX to HTML/Markdown converter ported from Mammoth |
| 6 | [moonbit-community/cmark](https://mooncakes.io/docs/moonbit-community/cmark) | 0.4.13 | A CommonMark toolkit for MoonBit |
| 7 | [mizchi/markdown](https://mooncakes.io/docs/mizchi/markdown) | 0.8.4 | Incremental Markdown parser and compiler |
| 8 | [moonrockz/pretty](https://mooncakes.io/docs/moonrockz/pretty) | 0.3.0 | Wadler-style pretty printer for MoonBit: documents, groups and layout that fits … |
| 9 | [Lampese/office-viewer](https://mooncakes.io/docs/Lampese/office-viewer) | 0.2.6 | A read-only DOCX, XLSX, PPTX, and PDF viewer with structured selections. |
| 10 | [moonbit-community/html](https://mooncakes.io/docs/moonbit-community/html) | 0.2.3 | WHATWG HTML5 spec-compliant parser for MoonBit |
| 11 | [justjavac/template](https://mooncakes.io/docs/justjavac/template) | 0.1.2 | A small and fast precompiled template engine for MoonBit. |
| 12 | [Xiao-li-He/MoonMarkMind](https://mooncakes.io/docs/Xiao-li-He/MoonMarkMind) | 0.1.0 | Markdown mind-map toolkit and browser application built with MoonBit |


## 时间 / 日期

日期时间、时区、RFC3339、cron。

> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 40 个候选均为基础库，需按需组合。

### 基础库（40）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [moonbitlang/x](https://mooncakes.io/docs/moonbitlang/x) | 0.5.7 | experimental packages for moonbitlang/core |
| 2 | [moonbitstack/moondate](https://mooncakes.io/docs/moonbitstack/moondate) | 0.1.2 | Dates, times, durations and cron expressions for MoonBit. |
| 3 | [brickfrog/tempo](https://mooncakes.io/docs/brickfrog/tempo) | 0.8.1 | UTC date/time library — RFC 3339 parsing, Unix timestamps, arithmetic |
| 4 | [mldong/moon-hutool](https://mooncakes.io/docs/mldong/moon-hutool) | 0.1.7 | Hutool-style utility library for MoonBit: all packages depend only on moonbitlan… |
| 5 | [kawaz/timespec](https://mooncakes.io/docs/kawaz/timespec) | 0.2.4 | CLI-oriented time specification parser for MoonBit |
| 6 | [mizchi/bit_date](https://mooncakes.io/docs/mizchi/bit_date) | 0.48.1 | Git date parsing primitives (gix-date equivalent) |
| 7 | [caijiewei295/tzif-engine](https://mooncakes.io/docs/caijiewei295/tzif-engine) | 0.1.0 | Pure MoonBit IANA TZif v2/v3 parser and timezone conversion engine. UTC ↔ local … |
| 8 | [001-Elsa/mooncron](https://mooncakes.io/docs/001-Elsa/mooncron) | 0.1.4 | A cron expression parser and schedule calculator written in MoonBit. |
| 9 | [iceBear67/time](https://mooncakes.io/docs/iceBear67/time) | 0.1.2 | A date-time library in MoonBit, including zone offsets and clocks that support J… |
| 10 | [marianoguerra/temporal](https://mooncakes.io/docs/marianoguerra/temporal) | 0.1.2 | An implementation of ECMAScript Temporal: calendar and time-zone aware dates, ti… |
| 11 | [mizchi/whenwords](https://mooncakes.io/docs/mizchi/whenwords) | 0.1.3 | A relative time formatting library for MoonBit, following the whenwords specific… |
| 12 | [suiyunonghen/datetime](https://mooncakes.io/docs/suiyunonghen/datetime) | 0.1.6 | datetime type of moonbit |


## WebAssembly / JS 互操作

Wasm 组件模型、WASI、FFI、JS 绑定。

### 完整方案（1）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [Milky2018/wasmoon](https://mooncakes.io/docs/Milky2018/wasmoon) | 0.18.0 | WebAssembly runtime with native JIT, interpreter, WASI and Component Model suppo… |

> 完整方案仅 1 个，说明该类需求目前在生态中主要依靠基础库组合实现，下方基础库清单的实用价值更高。

### 基础库（303）

| # | 包 | 版本 | 说明 |
|---|---|---|---|
| 1 | [mizchi/mwac](https://mooncakes.io/docs/mizchi/mwac) | 0.2.2 | WAC (WebAssembly Compositions) composer for the Component Model |
| 2 | [mizchi/wite](https://mooncakes.io/docs/mizchi/wite) | 0.11.3 | Component-model-aware WebAssembly analyzer, optimizer, and profiler |
| 3 | [mizchi/oci_wasm](https://mooncakes.io/docs/mizchi/oci_wasm) | 0.5.1 | WebAssembly package registry client |
| 4 | [mizchi/x](https://mooncakes.io/docs/mizchi/x) | 0.6.1 | Cross-platform MoonBit compatibility facades with native delegation and accelera… |
| 5 | [mizchi/wit](https://mooncakes.io/docs/mizchi/wit) | 0.3.3 | WIT parser and resolver in MoonBit |
| 6 | [mizchi/js](https://mooncakes.io/docs/mizchi/js) | 0.13.0 | js bindings for MoonBit: re-exports mizchi/js_core + mizchi/js_builtin (web/node… |
| 7 | [moonbit-community/proton_ffi](https://mooncakes.io/docs/moonbit-community/proton_ffi) | 0.6.0 | MoonBit Foreign Function Interface. |
| 8 | [justjavac/ffi](https://mooncakes.io/docs/justjavac/ffi) | 0.2.6 | MoonBit Foreign Function Interface. |
