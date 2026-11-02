# MoonBit 生态：场景化选包指南

> 覆盖 3520 个已发布模块；仅为 **下载量 > 20** 的包做推荐，被 yanked 的包不计入推荐。

数据源：mooncakes.io 官方 API（模块元数据 + 下载量）。本索引仅做场景导航，不复制注册表能力：版本历史、完整 API 文档与依赖关系请到 mooncakes 包页查看，报告内包名均指向该页。

> **数据时效**　采集于 2026-11-02，早于本报告的生成时间。本报告为离线生成的静态快照，不随注册表更新，不含此后的新增、版本变更与 yanked 标记；选型判断请以 mooncakes.io 及仓库实际状态为准。

每个场景分两层：**完整方案**（能直接选型、定骨架的）与**基础库**（提供单点能力，由调用方组合）。框架、引擎、运行时、脚手架、ORM 均属「完整方案」的不同形态。「基础库」不等同于「依赖」：在 mooncakes 生态中，完整方案本身同样是依赖，分层的唯一标准是该包能否接管程序结构。

场景内排序 = 关键词匹配度 + 下载量；同义词已做词干归一（如 async/asynchronous），并对易混淆场景做了排除（如 UI 场景排除 TUI）。

## 目录

- [桌面](#gui) — 方案 6 / 基础库 29
- [移动端](#mobi) — 方案 7 / 基础库 8
- [Web UI / 前端框架](#ui) — 方案 6 / 基础库 50
- [终端 UI / TUI](#tui) — 方案 5 / 基础库 50
- [CLI 参数解析](#cli) — 方案 4 / 基础库 221
- [游戏引擎 / ECS](#game) — 方案 6 / 基础库 48
- [图形 / 渲染](#graphics) — 无方案 / 基础库 121
- [图像 / 媒体](#img) — 无方案 / 基础库 151
- [Web 后端 / HTTP 服务](#http) — 方案 13 / 基础库 126
- [数据库 / 存储](#db) — 方案 5 / 基础库 75
- [网络 / 协议](#net) — 无方案 / 基础库 118
- [异步 / 并发](#async) — 方案 4 / 基础库 41
- [JSON / 序列化格式](#json) — 方案 1 / 基础库 184
- [日志 / 追踪](#log) — 无方案 / 基础库 29
- [运维 / 系统管理](#ops) — 方案 4 / 基础库 8
- [LLM / Agent / MCP](#llm) — 方案 5 / 基础库 111
- [解析器 / 编译器 / 语法](#parser) — 方案 2 / 基础库 286
- [正则匹配](#regex) — 无方案 / 基础库 9
- [Unicode / 文本处理](#unicode) — 无方案 / 基础库 104
- [加密 / 哈希 / 编码](#crypto) — 无方案 / 基础库 117
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

### 完整方案（6）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbit-community/proton](https://mooncakes.io/docs/moonbit-community/proton) | 0.6.0 | 2.7万 | MoonBit bindings for the Proton native desktop runtime. |
| 2 | [wzzc-dev/moui](https://mooncakes.io/docs/wzzc-dev/moui) | 0.2.6 | 1.8k | MoUI is a multi-platform MoonBit GUI framework |
| 3 | [NoahLiu/native-gui](https://mooncakes.io/docs/NoahLiu/native-gui) | 0.3.1 | 99 | MoonBit 跨平台桌面 GUI 框架：一套代码直出 Windows / Linux / macOS 原生窗口，托盘/通知/快捷键/输入法/自启等系统能力开箱… |
| 4 | [vectie/lepusa](https://mooncakes.io/docs/vectie/lepusa) | 0.1.6 | 452 | MoonBit-native desktop application framework research and implementation. |
| 5 | [lepus-apps/webview](https://mooncakes.io/docs/lepus-apps/webview) | 0.1.15 | 282 | A modern desktop application framework based on web technologies. |
| 6 | [tonyfettes/giraffe](https://mooncakes.io/docs/tonyfettes/giraffe) | 0.2.0 | 74 | Elm-style declarative UI framework for MoonBit, built on GTK4 |

### 基础库（29）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [wzzc-dev/window](https://mooncakes.io/docs/wzzc-dev/window) | 0.5.4-0.2.4 | 1.1万 | The wzzc-dev fork of moonbit-community/window, tracking upstream 0.5.4 while add… |
| 2 | [Milky2018/window](https://mooncakes.io/docs/Milky2018/window) | 0.6.2 | 6.8k | A MoonBit port of winit with a native macOS event loop and windowing backend. |
| 3 | [Milky2018/windowing](https://mooncakes.io/docs/Milky2018/windowing) | 0.1.2 | 6.4k | Backend-neutral raw window and display handle contracts for MoonBit. |
| 4 | [Nanaloveyuki/moonview](https://mooncakes.io/docs/Nanaloveyuki/moonview) | 0.1.0-beta.12 | 572 | Direct native WebView embedding for MoonBit. |
| 5 | [Nanaloveyuki/orby](https://mooncakes.io/docs/Nanaloveyuki/orby) | 0.1.0-beta.7 | 403 | Native MoonBit application and window host. |
| 6 | [wzzc-dev/windowing](https://mooncakes.io/docs/wzzc-dev/windowing) | 0.1.2 | 368 | Backend-neutral raw window and display handle contracts for MoonBit. |
| 7 | [mizchi/glfw](https://mooncakes.io/docs/mizchi/glfw) | 0.2.3 | 2.8k | GLFW MoonBit bindings (native FFI + C stub) |
| 8 | [justjavac/webview](https://mooncakes.io/docs/justjavac/webview) | 0.1.10 | 285 | MoonBit bindings for webview, a tiny library for creating web-based desktop GUIs… |
| 9 | [tonyfettes/gtk](https://mooncakes.io/docs/tonyfettes/gtk) | 0.2.0 | 275 | MoonBit bindings for GTK4 widgets (Window, Button, Box, Label, etc.) |
| 10 | [justjavac/windows_subsystem](https://mooncakes.io/docs/justjavac/windows_subsystem) | 0.1.6 | 91 | Keep the Windows GUI subsystem linker stub alive for MoonBit native executables. |


## 移动端

Android、iOS、HarmonyOS 与微信小程序上的应用开发。生态中尚无统一的移动端关键词信号，候选清单为人工圈定，涵盖全平台 UI 框架、小程序运行时与组件库、原生桥接、小程序宿主。

> 本场景为**人工圈定**：候选包与其顺序由人工确定，因为该领域在生态里还没有形成可靠的关键词信号。

### 完整方案（7）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [XiLaiTL/moobile](https://mooncakes.io/docs/XiLaiTL/moobile) | 0.6.0 | 81 | MoonBit UI for mobile: Android, iOS and Web from one rabbita (TEA) app, rendered… |
| 2 | [wzzc-dev/moui](https://mooncakes.io/docs/wzzc-dev/moui) | 0.2.6 | 1.8k | MoUI is a multi-platform MoonBit GUI framework |
| 3 | [lampclaw/minimoon](https://mooncakes.io/docs/lampclaw/minimoon) | 0.3.2 | 196 | A MoonBit UI runtime for WeChat MiniApp Skyline with Elm-style state machines, V… |
| 4 | [Magic486/moon-miniprogram](https://mooncakes.io/docs/Magic486/moon-miniprogram) | 0.6.1 | 100 | MoonBit 微信小程序开发框架：类型安全运行时、状态自动 diff、跨页 store、声明式路由与无头测试基建 |
| 5 | [shop1111/moonohos](https://mooncakes.io/docs/shop1111/moonohos) | 0.6.0 | 62 | HarmonyOS Native module framework for MoonBit: async tasks, platform modules and… |
| 6 | [lampclaw/lampo](https://mooncakes.io/docs/lampclaw/lampo) | 0.1.0 | 48 | A MoonBit UI runtime for WeChat MiniApp Skyline with pure Elm-style authoring, c… |
| 7 | [vectie/bunnia](https://mooncakes.io/docs/vectie/bunnia) | 0.1.0 | 30 | MoonBit mini-app UI framework with Rabbita-style authoring and modular platform … |

### 基础库（8）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [wzzc-dev/window](https://mooncakes.io/docs/wzzc-dev/window) | 0.5.4-0.2.4 | 1.1万 | The wzzc-dev fork of moonbit-community/window, tracking upstream 0.5.4 while add… |
| 2 | [Nanaloveyuki/ajni](https://mooncakes.io/docs/Nanaloveyuki/ajni) | 0.3.4 | 636 | Checked bidirectional Java/MoonBit JNI runtime and Android host bridge. |
| 3 | [Nanaloveyuki/moonview](https://mooncakes.io/docs/Nanaloveyuki/moonview) | 0.1.0-beta.12 | 572 | Direct native WebView embedding for MoonBit. |
| 4 | [lampclaw/minimoon_ui](https://mooncakes.io/docs/lampclaw/minimoon_ui) | 0.2.0 | 88 | Native, touch-first Skyline components for Minimoon, adapted from RUI. |
| 5 | [shop1111/moonohos_ohos](https://mooncakes.io/docs/shop1111/moonohos_ohos) | 0.6.0 | 41 | HarmonyOS platform packages (HiLog, RawFile, task cancellation, device info, net… |
| 6 | [Nanaloveyuki/madk](https://mooncakes.io/docs/Nanaloveyuki/madk) | 0.1.0 | 66 | Transport-independent Android Open Accessory protocol support for MoonBit. |
| 7 | [Nanaloveyuki/wasee-moon](https://mooncakes.io/docs/Nanaloveyuki/wasee-moon) | 0.1.0 | 36 | Android WASI host integration for MoonBit guests. |
| 8 | [wzzc-dev/moui_cli](https://mooncakes.io/docs/wzzc-dev/moui_cli) | 0.2.6 | 250 | Standalone project generator and environment doctor for MoUI |


## Web UI / 前端框架

浏览器里的 UI 框架、响应式状态、组件、布局与 CSS。

### 完整方案（6）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbit-community/rabbita](https://mooncakes.io/docs/moonbit-community/rabbita) | 0.17.0 | 13.2万 | functional Web UI framework for MoonBit |
| 2 | [mizchi/luna](https://mooncakes.io/docs/mizchi/luna) | 0.25.2 | 2.1万 | Fine-grained reactive UI library for Moonbit/JS |
| 3 | [marianoguerra/tutuca](https://mooncakes.io/docs/marianoguerra/tutuca) | 0.57.1 | 767 | MoonBit port of the tutuca UI framework (value language, templates, vdom, compon… |
| 4 | [lampclaw/minimoon](https://mooncakes.io/docs/lampclaw/minimoon) | 0.3.2 | 196 | A MoonBit UI runtime for WeChat MiniApp Skyline with Elm-style state machines, V… |
| 5 | [Arcelyth/aitne](https://mooncakes.io/docs/Arcelyth/aitne) | 0.4.20 | 215 | A lightweight and high-performance reactive web framework. |
| 6 | [vectie/bunnia](https://mooncakes.io/docs/vectie/bunnia) | 0.1.0 | 30 | MoonBit mini-app UI framework with Rabbita-style authoring and modular platform … |

### 基础库（50）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [mizchi/signals](https://mooncakes.io/docs/mizchi/signals) | 0.6.6 | 9.0万 | Fine-grained reactive signals for MoonBit (alien-signals inspired) |
| 2 | [mizchi/wit](https://mooncakes.io/docs/mizchi/wit) | 0.3.3 | 6.5万 | WIT parser and resolver in MoonBit |
| 3 | [mizchi/crater](https://mooncakes.io/docs/mizchi/crater) | 0.19.0 | 6.1万 | CSS Layout Engine that implements Box/Flex/Grid |
| 4 | [mizchi/layout](https://mooncakes.io/docs/mizchi/layout) | 0.2.1 | 3.4万 | Pure layout computation kernel: alignment, justify, clamp, axis utilities |
| 5 | [dowdiness/incr](https://mooncakes.io/docs/dowdiness/incr) | 0.15.1 | 3.2万 | Salsa-inspired incremental recomputation library with automatic dependency track… |
| 6 | [mizchi/css](https://mooncakes.io/docs/mizchi/css) | 0.7.4 | 2.4万 | Standalone CSS parser, selector, cascade and computed-style engine for MoonBit |
| 7 | [Milky2018/moon_taffy](https://mooncakes.io/docs/Milky2018/moon_taffy) | 0.5.3 | 1.6万 | MoonBit port of the Rust crate taffy (v0.5.x) |
| 8 | [bobzhang/html_parser](https://mooncakes.io/docs/bobzhang/html_parser) | 0.2.2 | 1.3万 | MoonBit HTML parser and sanitizer ported from JustHTML. |


## 终端 UI / TUI

终端界面、字符画布、ANSI 控制、PTY。

### 完整方案（5）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [mizchi/tui](https://mooncakes.io/docs/mizchi/tui) | 0.10.2 | 7.1万 | Terminal UI library for MoonBit with reactive signals |
| 2 | [moonbit-community/rabbita_tui](https://mooncakes.io/docs/moonbit-community/rabbita_tui) | 0.1.3 | 401 | Native terminal UI toolkit built around The Elm Architecture |
| 3 | [Frank-III/onebit-tui](https://mooncakes.io/docs/Frank-III/onebit-tui) | 0.1.3 | 60 | Modern terminal UI library with Yoga flexbox layout and native performance |
| 4 | [moonbitstack/moonetui](https://mooncakes.io/docs/moonbitstack/moonetui) | 0.3.1 | 60 | A terminal UI toolkit for MoonBit: cell buffer, differential ANSI renderer, incr… |
| 5 | [brickfrog/pippa](https://mooncakes.io/docs/brickfrog/pippa) | 0.1.0 | 49 | A terminal UI framework for MoonBit, inspired by bubbletea (Go) and Elm architec… |

### 基础库（50）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbit-community/tty](https://mooncakes.io/docs/moonbit-community/tty) | 0.6.2 | 3.1万 | Low-level terminal primitives for MoonBit native and wasm targets: a sidecar-hel… |
| 2 | [moonbit-community/displaytext](https://mooncakes.io/docs/moonbit-community/displaytext) | 0.1.7 | 2.9万 | Grapheme-aware display-cell text boundaries for terminal UIs. |
| 3 | [moonbit-community/pty](https://mooncakes.io/docs/moonbit-community/pty) | 0.4.4 | 4.1万 | Cross-platform PTY (pseudo-terminal) spawning for MoonBit native targets, integr… |
| 4 | [mizchi/tui-terminal-buffer](https://mooncakes.io/docs/mizchi/tui-terminal-buffer) | 0.1.4 | 2.1万 | Terminal character buffer primitives for MoonBit TUI renderers |
| 5 | [mizchi/tui-terminal-protocol](https://mooncakes.io/docs/mizchi/tui-terminal-protocol) | 0.1.2 | 2.0万 | Terminal graphics protocol encoders for tui.mbt |
| 6 | [mizchi/crater-terminal-protocol](https://mooncakes.io/docs/mizchi/crater-terminal-protocol) | 0.19.0 | 7.4k | Terminal graphics protocol encoders for crater |
| 7 | [sennenki/pretty_prompt](https://mooncakes.io/docs/sennenki/pretty_prompt) | 0.1.2 | 629 | A pretty prompt library for Moonbit, providing an easy way to create interactive… |
| 8 | [cg-zhou/drawille](https://mooncakes.io/docs/cg-zhou/drawille) | 0.1.2 | 360 | MoonBit port of drawille for terminal graphics with Unicode Braille characters |


## CLI 参数解析

命令行工具的参数、子命令、帮助信息解析。

### 完整方案（4）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [Yoorkin/ArgParser](https://mooncakes.io/docs/Yoorkin/ArgParser) | 0.2.1 | 10.8万 | command line argument parser |
| 2 | [mizchi/admiral](https://mooncakes.io/docs/mizchi/admiral) | 0.1.1 | 1.8万 | Declarative CLI builder for MoonBit, inspired by gunshi |
| 3 | [TheWaWaR/clap](https://mooncakes.io/docs/TheWaWaR/clap) | 0.2.6 | 6.9k | Command Line Argument Parser |
| 4 | [totto2727/admiral](https://mooncakes.io/docs/totto2727/admiral) | 0.6.5 | 737 | Async-first declarative CLI builder for MoonBit, inspired by gunshi |

### 基础库（221）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [cli/core](https://mooncakes.io/docs/cli/core) | 0.9.1 | 443 | Shared runtime core for cli command modules. |
| 2 | [Milky2018/options](https://mooncakes.io/docs/Milky2018/options) | 0.1.3 | 93 | Command line argument parser for MoonBit |
| 3 | [moonbit-community/proton_cli](https://mooncakes.io/docs/moonbit-community/proton_cli) | 0.6.0 | 664 | Developer CLI for Proton desktop applications. |
| 4 | [colmugx/ai-passport](https://mooncakes.io/docs/colmugx/ai-passport) | 0.2.6 | 484 | MoonBit application SDK and host toolchain for supported embedded devices and th… |
| 5 | [moonrockz/smithy-cli](https://mooncakes.io/docs/moonrockz/smithy-cli) | 0.8.0 | 97 | Smithy command-line application |
| 6 | [totto2727/agent-core-sdk](https://mooncakes.io/docs/totto2727/agent-core-sdk) | 0.1.2 | 357 | Shared MoonBit process foundation for agent CLIs |
| 7 | [Xiao-li-He/MoonMarkMind](https://mooncakes.io/docs/Xiao-li-He/MoonMarkMind) | 0.1.0 | 338 | Markdown mind-map toolkit and browser application built with MoonBit |
| 8 | [cauchyQ/moonbit-argkit](https://mooncakes.io/docs/cauchyQ/moonbit-argkit) | 0.1.0 | 34 | Small dependency-free command line argument parser for MoonBit. |


## 游戏引擎 / ECS

游戏引擎、ECS 架构、程序化生成、游戏后端。

### 完整方案（6）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [Milky2018/selene](https://mooncakes.io/docs/Milky2018/selene) | 0.38.0 | 4.0k | ECS game engine in MoonBit |
| 2 | [mizchi/kagura](https://mooncakes.io/docs/mizchi/kagura) | 0.6.0 | 135 | 2D-first game engine for MoonBit inspired by Ebiten |
| 3 | [sennenki/reisen](https://mooncakes.io/docs/sennenki/reisen) | 0.3.2 | 90 | A visual novel engine in MoonBit |
| 4 | [sssssurf/abyssal_chord](https://mooncakes.io/docs/sssssurf/abyssal_chord) | 0.1.0 | 41 | 深渊协奏 (Abyssal Chord) - A MoonBit card battle game engine with CLI demo |
| 5 | [sacckey/moon8bit](https://mooncakes.io/docs/sacckey/moon8bit) | 0.1.0 | 32 | A minimal retro 2D game engine for MoonBit with text-first assets, deterministic… |
| 6 | [firefly/firefly](https://mooncakes.io/docs/firefly/firefly) | 0.10.0 | 81 | MoonBit SDK for making Firefly Zero games |

### 基础库（48）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [mizchi/terrain](https://mooncakes.io/docs/mizchi/terrain) | 0.1.1 | 3.0k | 117 procedural dungeon/terrain generation algorithms |
| 2 | [Milky2018/selene_webgpu](https://mooncakes.io/docs/Milky2018/selene_webgpu) | 0.38.0 | 1.0k | Default backend for Selene game engine. |
| 3 | [mizchi/differentiable_ecs](https://mooncakes.io/docs/mizchi/differentiable_ecs) | 0.2.1 | 653 | Game-agnostic parameter optimizer using CMA-ES for balance tuning (experimental) |
| 4 | [Milky2018/selene-canvas](https://mooncakes.io/docs/Milky2018/selene-canvas) | 0.20.1 | 219 | Default backend for Selene game engine. |
| 5 | [Milky2018/selene_raylib](https://mooncakes.io/docs/Milky2018/selene_raylib) | 0.38.0 | 1.8k | Native raylib backend for Selene. |
| 6 | [KKKIIO/selene](https://mooncakes.io/docs/KKKIIO/selene) | 0.37.5 | 113 | ECS game engine in MoonBit |
| 7 | [KKKIIO/selene_webgpu](https://mooncakes.io/docs/KKKIIO/selene_webgpu) | 0.37.5 | 81 | Default backend for Selene game engine. |
| 8 | [Milky2018/mecs](https://mooncakes.io/docs/Milky2018/mecs) | 0.2.1 | 62 | A performance-first ECS experiment for MoonBit. |


## 图形 / 渲染

矢量图形、SVG、场景图、绘图与布局。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 121 个，此处列出前 12 个。

### 基础库（121）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [mizchi/svg](https://mooncakes.io/docs/mizchi/svg) | 0.2.3 | 4.4万 | Standalone SVG scene graph and renderer |
| 2 | [dowdiness/svg-dsl](https://mooncakes.io/docs/dowdiness/svg-dsl) | 0.1.0 | 3.3万 | SVG DSL for programmatic SVG generation in MoonBit |
| 3 | [Milky2018/svg](https://mooncakes.io/docs/Milky2018/svg) | 0.6.0 | 4.4k | Standalone SVG scene graph and renderer |
| 4 | [dowdiness/graphviz](https://mooncakes.io/docs/dowdiness/graphviz) | 0.1.0 | 2.8万 | Parser, layout engine, and SVG renderer for Graphviz DOT graphs |
| 5 | [bobzhang/beautiful_mermaid](https://mooncakes.io/docs/bobzhang/beautiful_mermaid) | 0.2.0 | 2.7万 | MoonBit port of beautiful-mermaid: render Mermaid diagrams to SVG and ASCII/Unic… |
| 6 | [bobzhang/vg](https://mooncakes.io/docs/bobzhang/vg) | 0.4.1 | 2.8k | Declarative 2D vector graphics library for MoonBit |
| 7 | [gmlewis/fonts](https://mooncakes.io/docs/gmlewis/fonts) | 0.19.19 | 1.4万 | Experimental package to manipulate open source font data. |
| 8 | [moonbitlang/pagelayout](https://mooncakes.io/docs/moonbitlang/pagelayout) | 0.8.1 | 1.3万 | Paginated document layout engine: format-neutral page-model IR with SVG/PDF back… |
| 9 | [mizchi/moomaid](https://mooncakes.io/docs/mizchi/moomaid) | 0.4.0 | 1.0万 | Mermaid diagram renderer for MoonBit (ASCII and SVG output) |
| 10 | [moonbit-community/diago](https://mooncakes.io/docs/moonbit-community/diago) | 0.4.0 | 4.1k | A diagram toolkit for MoonBit with Dagre, ELK, and Railway layout engines, rende… |
| 11 | [justjavac/template](https://mooncakes.io/docs/justjavac/template) | 0.1.2 | 4.3k | A small and fast precompiled template engine for MoonBit. |
| 12 | [wzzc-dev/moui_skia](https://mooncakes.io/docs/wzzc-dev/moui_skia) | 0.2.6 | 1.9k | MoonBit bindings for the Skia Graphics Library |


## 图像 / 媒体

图像编解码（PNG/JPEG/GIF/BMP）、像素比较、音视频。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 151 个，此处列出前 12 个。

### 基础库（151）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [mizchi/image](https://mooncakes.io/docs/mizchi/image) | 0.4.3 | 2.6万 | Image codec primitives for MoonBit with PNG/BMP/JPEG decode+encode, GIF/WebP/ICO… |
| 2 | [mizchi/pixelmatch](https://mooncakes.io/docs/mizchi/pixelmatch) | 0.6.2 | 4.3万 | Fast pixel-level image comparison library for MoonBit/WASM |
| 3 | [mizchi/svg](https://mooncakes.io/docs/mizchi/svg) | 0.2.3 | 4.4万 | Standalone SVG scene graph and renderer |
| 4 | [mizchi/simd](https://mooncakes.io/docs/mizchi/simd) | 0.6.1 | 1.4万 | SIMD primitives for MoonBit across wasm / wasm-gc / native / js — @simdcore, @si… |
| 5 | [dowdiness/svg-dsl](https://mooncakes.io/docs/dowdiness/svg-dsl) | 0.1.0 | 3.3万 | SVG DSL for programmatic SVG generation in MoonBit |
| 6 | [dowdiness/graphviz](https://mooncakes.io/docs/dowdiness/graphviz) | 0.1.0 | 2.8万 | Parser, layout engine, and SVG renderer for Graphviz DOT graphs |
| 7 | [bobzhang/beautiful_mermaid](https://mooncakes.io/docs/bobzhang/beautiful_mermaid) | 0.2.0 | 2.7万 | MoonBit port of beautiful-mermaid: render Mermaid diagrams to SVG and ASCII/Unic… |
| 8 | [moonbit-community/proton_microphone](https://mooncakes.io/docs/moonbit-community/proton_microphone) | 0.6.0 | 2.4万 | Microphone capture device and session helpers. |
| 9 | [gmlewis/image](https://mooncakes.io/docs/gmlewis/image) | 0.17.18 | 9.1k | MoonBit image: simple image representation. |
| 10 | [gmlewis/fonts](https://mooncakes.io/docs/gmlewis/fonts) | 0.19.19 | 1.4万 | Experimental package to manipulate open source font data. |
| 11 | [moonbitlang/pagelayout](https://mooncakes.io/docs/moonbitlang/pagelayout) | 0.8.1 | 1.3万 | Paginated document layout engine: format-neutral page-model IR with SVG/PDF back… |
| 12 | [riantr/moonbit_image](https://mooncakes.io/docs/riantr/moonbit_image) | 0.3.9 | 1.4k | Pure-MoonBit image decoder/encoder covering BMP / QOI / TGA / PNG / GIF / JPEG /… |


## Web 后端 / HTTP 服务

HTTP 服务、路由、中间件与后端 API 开发。

### 完整方案（13）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbitlang/moonback](https://mooncakes.io/docs/moonbitlang/moonback) | 0.8.10 | 5.6万 | A web backend framework for MoonBit |
| 2 | [mizchi/mars](https://mooncakes.io/docs/mizchi/mars) | 0.3.13 | 6.9k | Hono-inspired MoonBit web framework with trie routing, middleware, SSE, and mizc… |
| 3 | [oboard/mocket](https://mooncakes.io/docs/oboard/mocket) | 0.10.2 | 3.1k | A web framework for MoonBit. |
| 4 | [bobzhang/crescent](https://mooncakes.io/docs/bobzhang/crescent) | 0.11.2 | 646 | Crescent: A web framework for MoonBit. |
| 5 | [moonbitstack/moonapi](https://mooncakes.io/docs/moonbitstack/moonapi) | 0.17.7 | 458 | A typed web framework for MoonBit. |
| 6 | [jaredzhou/pony](https://mooncakes.io/docs/jaredzhou/pony) | 0.5.0 | 126 | Lightweight HTTP web framework and router for MoonBit, inspired by Chi |
| 7 | [RabitLogic/mbit](https://mooncakes.io/docs/RabitLogic/mbit) | 0.3.0 | 68 | A Gin-inspired web framework for MoonBit — fast, lightweight, idiomatic. |
| 8 | [wflixu/Halo](https://mooncakes.io/docs/wflixu/Halo) | 0.6.0 | 55 | A modern middleware web framework for MoonBit with Koa-style onion model, struct… |

### 基础库（126）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [mizchi/github](https://mooncakes.io/docs/mizchi/github) | 0.1.5 | 1.2k | GitHub REST API client for MoonBit |
| 2 | [moonbitstack/moonasgi](https://mooncakes.io/docs/moonbitstack/moonasgi) | 0.10.4 | 1.0k | ASGI 3.0 for MoonBit: the interface between servers and frameworks. |
| 3 | [ShellWen/sw_router](https://mooncakes.io/docs/ShellWen/sw_router) | 0.2.0 | 2.5k | A fast and flexible URL router implementation for the MoonBit language. |
| 4 | [moonbitstack/moonnet](https://mooncakes.io/docs/moonbitstack/moonnet) | 0.1.8 | 624 | Networking for MoonBit: connections, listeners and dialers over TCP, TLS and QUI… |
| 5 | [moonbitstack/mooncat](https://mooncakes.io/docs/moonbitstack/mooncat) | 0.19.1 | 606 | A native ASGI server for MoonBit. |
| 6 | [mizchi/js_web](https://mooncakes.io/docs/mizchi/js_web) | 0.13.1 | 2.6k | web standard api bindings (fetch, Streams, Blob, URL, Crypto, ...) |
| 7 | [ryota0624/googleapis](https://mooncakes.io/docs/ryota0624/googleapis) | 0.4.1 | 535 | MoonBit client library for Google REST APIs |
| 8 | [gaato/http](https://mooncakes.io/docs/gaato/http) | 0.5.0 | 2.3k | Sans-IO HTTP vocabulary for MoonBit SDKs: request/response types, a Transport tr… |


## 数据库 / 存储

SQLite 绑定、ORM、KV 存储、迁移工具。

### 完整方案（5）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbitstack/moondb](https://mooncakes.io/docs/moonbitstack/moondb) | 0.2.4 | 1.7k | The standard database-access interface for MoonBit — the driver↔query-layer cont… |
| 2 | [oboard/morm](https://mooncakes.io/docs/oboard/morm) | 0.5.0 | 800 | A lightweight MoonBit ORM with typed queries, code generation, and multi-databas… |
| 3 | [moonbitstack/moonorm](https://mooncakes.io/docs/moonbitstack/moonorm) | 0.11.5 | 188 | An ORM and SQL toolkit for MoonBit. |
| 4 | [wflixu/Orion](https://mooncakes.io/docs/wflixu/Orion) | 0.2.0 | 45 | Derive + Codegen ORM for MoonBit. Schema DSL, type-safe CRUD, Query Builder. |
| 5 | [zen314/shadow](https://mooncakes.io/docs/zen314/shadow) | 0.1.0 | 32 | Simple ORM Framework |

### 基础库（75）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [mizchi/sqlite](https://mooncakes.io/docs/mizchi/sqlite) | 0.3.1 | 1.1万 | libsqlite3 bindings for MoonBit |
| 2 | [prowk/moonsqlitefile](https://mooncakes.io/docs/prowk/moonsqlitefile) | 0.8.1 | 1.7k | Pure MoonBit read-only SQLite file format parser and inspector |
| 3 | [f4ah6o/duckdb](https://mooncakes.io/docs/f4ah6o/duckdb) | 0.8.0 | 1.5k | MoonBit bindings for DuckDB on native and JavaScript targets (Node.js and browse… |
| 4 | [moonbitstack/moonsqlite](https://mooncakes.io/docs/moonbitstack/moonsqlite) | 0.3.3 | 360 | SQLite driver for moondb/moonorm — native FFI, amalgamation vendored here (isola… |
| 5 | [daqing/sqlite](https://mooncakes.io/docs/daqing/sqlite) | 0.4.0 | 2.6k | SQLite3 bindings for latest MoonBit toolchian |
| 6 | [mizchi/cloudflare](https://mooncakes.io/docs/mizchi/cloudflare) | 0.1.13 | 2.5k | MoonBit bindings for Cloudflare Workers APIs (KV, D1, R2, Durable Objects, etc.) |
| 7 | [jaredzhou/moonpg](https://mooncakes.io/docs/jaredzhou/moonpg) | 0.14.0 | 244 | A pure MoonBit PostgreSQL client, wire protocol from scratch. |
| 8 | [moonbitstack/moonpostgres](https://mooncakes.io/docs/moonbitstack/moonpostgres) | 0.6.7 | 238 | Pure-MoonBit PostgreSQL wire-protocol driver implementing @moondb.AsyncDriver — … |


## 网络 / 协议

TCP/UDP、WebSocket、MQTT、HTTP 协议栈、TLS。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 118 个，此处列出前 12 个。

### 基础库（118）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbitstack/moonhttp](https://mooncakes.io/docs/moonbitstack/moonhttp) | 0.15.4 | 1.7k | HTTP formats for MoonBit with no I/O: HTTP/1 to HTTP/3, WebSocket, SSE and multi… |
| 2 | [moonbitstack/moonnet](https://mooncakes.io/docs/moonbitstack/moonnet) | 0.1.8 | 624 | Networking for MoonBit: connections, listeners and dialers over TCP, TLS and QUI… |
| 3 | [ShellWen/sw_socket](https://mooncakes.io/docs/ShellWen/sw_socket) | 0.2.0 | 428 | A experimental *nix socket binding for MoonBit. |
| 4 | [fangyinc/socket](https://mooncakes.io/docs/fangyinc/socket) | 0.1.2-rc2 | 1.3k | A socket binding for MoonBit |
| 5 | [gaato/deflate](https://mooncakes.io/docs/gaato/deflate) | 0.1.0 | 2.4k | Streaming DEFLATE, zlib and gzip decoders and encoders (RFC 1951, 1950, 1952) fo… |
| 6 | [gaato/brotli](https://mooncakes.io/docs/gaato/brotli) | 0.4.1 | 2.3k | A streaming Brotli (RFC 7932) decoder and encoder in pure MoonBit: arbitrary inp… |
| 7 | [sujy123456/mooncoap](https://mooncakes.io/docs/sujy123456/mooncoap) | 0.1.1 | 168 | Bounded, deterministic unicast CoAP protocol core for MoonBit |
| 8 | [PaiGack/ftp](https://mooncakes.io/docs/PaiGack/ftp) | 0.2.5 | 141 | FTP/FTPS client library for MoonBit with passive EPSV/PASV data connections, MLS… |
| 9 | [ZSeanYves/MoonbitHTTP](https://mooncakes.io/docs/ZSeanYves/MoonbitHTTP) | 0.7.0 | 133 | Streaming HTTP protocol suite for MoonBit with HTTP/1.1, HTTP/2, HTTP/3, QUIC, T… |
| 10 | [moonbitstack/moontls](https://mooncakes.io/docs/moonbitstack/moontls) | 0.9.11 | 1.1k | TLS 1.3 and DTLS 1.3 for MoonBit. |
| 11 | [oboard/mio](https://mooncakes.io/docs/oboard/mio) | 0.5.4 | 949 | Best async http library for Moonbit |
| 12 | [gaato/zstd](https://mooncakes.io/docs/gaato/zstd) | 0.3.1 | 792 | A streaming Zstandard (RFC 8878) decoder in pure MoonBit: arbitrary input chunks… |


## 异步 / 并发

async 运行时、协程、并发原语、任务调度。

### 完整方案（4）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbitlang/async](https://mooncakes.io/docs/moonbitlang/async) | 0.22.7 | 74.4万 | Asynchronous programming library for MoonBit |
| 2 | [peter-jerry-ye/async](https://mooncakes.io/docs/peter-jerry-ye/async) | 0.2.1 | 219 | Async library: promise, event loop, i/o |
| 3 | [didiLjf/moonorbit](https://mooncakes.io/docs/didiLjf/moonorbit) | 0.2.1 | 57 | A lightweight, high-performance Actor concurrency framework for MoonBit |
| 4 | [kalculos/miao](https://mooncakes.io/docs/kalculos/miao) | 0.1.0-M2 | 41 | Another async I/O for moonbit, with libuv served as the default async runtime im… |

### 基础库（41）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [mizchi/x](https://mooncakes.io/docs/mizchi/x) | 0.6.1 | 20.5万 | Cross-platform MoonBit compatibility facades with native delegation and accelera… |
| 2 | [moonbitlang/moonback](https://mooncakes.io/docs/moonbitlang/moonback) | 0.8.10 | 5.6万 | A web backend framework for MoonBit |
| 3 | [colmugx/fuwaroid](https://mooncakes.io/docs/colmugx/fuwaroid) | 0.3.2 | 4.5k | Lightweight single-writer concurrency |
| 4 | [moonbit-community/pty](https://mooncakes.io/docs/moonbit-community/pty) | 0.4.4 | 4.1万 | Cross-platform PTY (pseudo-terminal) spawning for MoonBit native targets, integr… |
| 5 | [moonbit-community/tty](https://mooncakes.io/docs/moonbit-community/tty) | 0.6.2 | 3.1万 | Low-level terminal primitives for MoonBit native and wasm targets: a sidecar-hel… |
| 6 | [moonbitlang/jsonl](https://mooncakes.io/docs/moonbitlang/jsonl) | 0.2.1 | 2.7万 | Async reader for JSON Lines (newline-delimited JSON) streams. |
| 7 | [Nanaloveyuki/sync](https://mooncakes.io/docs/Nanaloveyuki/sync) | 0.7.3 | 391 | Minimal native concurrency primitives for MoonBit. |
| 8 | [mizchi/js_core](https://mooncakes.io/docs/mizchi/js_core) | 0.13.0 | 2.6k | js ffi foundation for MoonBit (Any, Promise, Nullable, target-specific interop) |


## JSON / 序列化格式

JSON、YAML、TOML、XML、CBOR 等格式的解析与生成。

### 完整方案（1）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [Yu-zh/data](https://mooncakes.io/docs/Yu-zh/data) | 0.2.1 | 126 | A serde-shaped serialization framework: one data model, many formats |

> 完整方案仅 1 个，说明该类需求目前在生态中主要依靠基础库组合实现，下方基础库清单的实用价值更高。

### 基础库（184）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbitlang/x](https://mooncakes.io/docs/moonbitlang/x) | 0.5.7 | 75.8万 | experimental packages for moonbitlang/core |
| 2 | [mizchi/cbor](https://mooncakes.io/docs/mizchi/cbor) | 0.1.1 | 5.8万 | CBOR (RFC 8949) implementation for MoonBit - Pure and FFI versions |
| 3 | [moonbit-community/yaml](https://mooncakes.io/docs/moonbit-community/yaml) | 0.0.8 | 11.2万 | A simple YAML parsing and stringifying library for MoonBit, support a simplified… |
| 4 | [moonrockz/ion](https://mooncakes.io/docs/moonrockz/ion) | 0.7.0 | 3.6万 | A MoonBit implementation of the Amazon Ion data format and Ion Schema. |
| 5 | [Milky2018/xml](https://mooncakes.io/docs/Milky2018/xml) | 0.6.1 | 7.9万 | A document-buffered pull XML parser for MoonBit |
| 6 | [moonbit-community/toml](https://mooncakes.io/docs/moonbit-community/toml) | 0.5.1 | 4.5万 | A TOML parser implementation in MoonBit |
| 7 | [moonbitlang/jsonl](https://mooncakes.io/docs/moonbitlang/jsonl) | 0.2.1 | 2.7万 | Async reader for JSON Lines (newline-delimited JSON) streams. |
| 8 | [moonbitstack/moonjson](https://mooncakes.io/docs/moonbitstack/moonjson) | 0.4.2 | 2.1k | JSON, its dialects and its binary encodings for MoonBit. |


## 日志 / 追踪

结构化日志、tracing、OpenTelemetry、指标。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 29 个，此处列出前 12 个。

### 基础库（29）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [tonyfettes/xlog](https://mooncakes.io/docs/tonyfettes/xlog) | 0.4.2 | 5.4万 | Native structured logging with levels and category-based filtering. |
| 2 | [moonbitstack/moonlog](https://mooncakes.io/docs/moonbitstack/moonlog) | 0.1.4 | 702 | Structured logging for MoonBit. |
| 3 | [moonrockz/moon-lander-logging](https://mooncakes.io/docs/moonrockz/moon-lander-logging) | 0.11.0 | 3.8k | Structured logging with a bring-your-own logger trait for the Moon-Lander framew… |
| 4 | [moonrockz/moon-lander-logging-hosting-async](https://mooncakes.io/docs/moonrockz/moon-lander-logging-hosting-async) | 0.11.0 | 3.8k | Console and rolling file delivery for Moon-Lander logging, with bounded async se… |
| 5 | [brickfrog/moontrace](https://mooncakes.io/docs/brickfrog/moontrace) | 0.14.0 | 242 | Structured tracing for MoonBit with spans, structured fields, pluggable subscrib… |
| 6 | [Milky2018/sysinfo](https://mooncakes.io/docs/Milky2018/sysinfo) | 0.1.6 | 799 | System metrics and process inspection library. |
| 7 | [mohongquan0630/moon-prometheus](https://mooncakes.io/docs/mohongquan0630/moon-prometheus) | 0.2.6 | 76 | — |
| 8 | [ryota0624/moonbit_otel](https://mooncakes.io/docs/ryota0624/moonbit_otel) | 0.1.0 | 75 | — |
| 9 | [CCllff-jpg/MoonLogTrace](https://mooncakes.io/docs/CCllff-jpg/MoonLogTrace) | 0.1.4 | 63 | Pure MoonBit structured logging and tracing library with safe formatters, replay… |
| 10 | [LilaLola67/moonmcap](https://mooncakes.io/docs/LilaLola67/moonmcap) | 0.17.4 | 240 | MoonBit-native MCAP message-log codec, indexed queries and file transformations |
| 11 | [Nanaloveyuki/BitLogger](https://mooncakes.io/docs/Nanaloveyuki/BitLogger) | 0.9.1 | 379 | A structured logger for MoonBit. |
| 12 | [chensuiyi/logfly](https://mooncakes.io/docs/chensuiyi/logfly) | 0.3.0 | 38 | Logging for MoonBit: plain text and JSONL appenders with timestamps, and size-tr… |


## 运维 / 系统管理

进程守护与进程检查、子进程与命令执行、伪终端控制、CI 任务运行。生态中尚无运维框架，但已有可直接部署的成品工具，与若干可组合的基础库。

> 本场景为**人工圈定**：候选包与其顺序由人工确定，因为该领域在生态里还没有形成可靠的关键词信号。

> 进程管理器与 CI 运行器本身就是可用成品，计入「完整方案」；其余为单点能力的基础库，需要自行组装。

### 完整方案（4）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [chensuiyi/bm2](https://mooncakes.io/docs/chensuiyi/bm2) | 0.8.0 | 127 | A lightweight Linux process manager for Bun and Node.js applications, written in… |
| 2 | [mizchi/actrun](https://mooncakes.io/docs/mizchi/actrun) | 0.32.0 | 785 | MVP GitHub Actions-compatible push CI runner with bitflow lowering, native execu… |
| 3 | [kupas/pm3](https://mooncakes.io/docs/kupas/pm3) | 0.1.8 | 64 | A language-agnostic process manager (PM2-like) with built-in log rotation |
| 4 | [tiye/redstart](https://mooncakes.io/docs/tiye/redstart) | 0.1.4 | 59 | Lightweight process manager for local development |

### 基础库（8）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbit-community/pty](https://mooncakes.io/docs/moonbit-community/pty) | 0.4.4 | 4.1万 | Cross-platform PTY (pseudo-terminal) spawning for MoonBit native targets, integr… |
| 2 | [moonbit-community/tty](https://mooncakes.io/docs/moonbit-community/tty) | 0.6.2 | 3.1万 | Low-level terminal primitives for MoonBit native and wasm targets: a sidecar-hel… |
| 3 | [Milky2018/sysinfo](https://mooncakes.io/docs/Milky2018/sysinfo) | 0.1.6 | 799 | System metrics and process inspection library. |
| 4 | [mizchi/process_pool](https://mooncakes.io/docs/mizchi/process_pool) | 0.1.4 | 6.5k | — |
| 5 | [moonbit-community/proton_process](https://mooncakes.io/docs/moonbit-community/proton_process) | 0.2.6 | 1.7k | Native child process spawning for MoonBit on Windows, Linux, and macOS. |
| 6 | [trkbt10/subprocess](https://mooncakes.io/docs/trkbt10/subprocess) | 0.2.0 | 404 | Node.js child_process-like subprocess management for MoonBit |
| 7 | [trkbt10/osenv](https://mooncakes.io/docs/trkbt10/osenv) | 0.1.0 | 626 | OS environment utilities: platform detection, safe path operations, and OS-stand… |
| 8 | [mizchi/tempfile](https://mooncakes.io/docs/mizchi/tempfile) | 0.1.3 | 15.5万 | Temporary file and directory management for MoonBit |


## LLM / Agent / MCP

大模型客户端、Agent 框架、MCP 服务端/客户端、提示词。

### 完整方案（5）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [colmugx/posoco](https://mooncakes.io/docs/colmugx/posoco) | 0.23.2 | 4.2k | LLM Agent framework with hexagonal (ports-and-adapters) architecture. Defines ex… |
| 2 | [colmugx/mcp](https://mooncakes.io/docs/colmugx/mcp) | 0.18.2 | 9.1k | Type-safe MCP SDK in MoonBit with server/client support and dual transport (STDI… |
| 3 | [golemcloud/golem_sdk](https://mooncakes.io/docs/golemcloud/golem_sdk) | 0.6.2 | 724 | Golem SDK for MoonBit — build durable, fault-tolerant agents on the Golem platfo… |
| 4 | [weopqrst/agent](https://mooncakes.io/docs/weopqrst/agent) | 0.5.1 | 84 | MoonBit version of LangChain core library — type-safe, composable, embeddable AI… |
| 5 | [soehi/moonlm](https://mooncakes.io/docs/soehi/moonlm) | 0.1.2 | 43 | Local LLM inference engine and strongly-typed agent runtime, in MoonBit |

### 基础库（111）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [mizchi/llm](https://mooncakes.io/docs/mizchi/llm) | 0.3.2 | 15.4万 | Pure MoonBit LLM client library |
| 2 | [colmugx/acp](https://mooncakes.io/docs/colmugx/acp) | 0.3.0 | 3.8k | Type-safe Agent Client Protocol (ACP) SDK for MoonBit. |
| 3 | [DC-Z-lab/moonllm](https://mooncakes.io/docs/DC-Z-lab/moonllm) | 0.1.0 | 500 | Type-safe, OpenAI-compatible LLM client for MoonBit: chat completions, streaming… |
| 4 | [marianoguerra/llm](https://mooncakes.io/docs/marianoguerra/llm) | 0.4.2 | 469 | A dialect-agnostic LLM IR, one wire mapping per provider protocol, a data-driven… |
| 5 | [colmugx/lody](https://mooncakes.io/docs/colmugx/lody) | 0.1.0 | 3.7k | 1:1 MoonBit mirror of the LodyAI acp-extension-core contract (tool vocabulary, _… |
| 6 | [totto2727/codex-sdk](https://mooncakes.io/docs/totto2727/codex-sdk) | 0.4.1 | 229 | MoonBit SDK for embedding the Codex agent in workflows and applications |
| 7 | [wzzc-dev/moui_agent_mcp](https://mooncakes.io/docs/wzzc-dev/moui_agent_mcp) | 0.2.6 | 309 | MCP JSON-RPC router and stdio transport exposing a MoUI AgentHost to external ag… |
| 8 | [gaato/openai](https://mooncakes.io/docs/gaato/openai) | 0.6.0 | 155 | Thin OpenAI API client for MoonBit built on gaato/http and gaato/sdk-runtime: mo… |


## 解析器 / 编译器 / 语法

词法、语法、parser combinator、AST、tree-sitter、parser generator。

### 完整方案（2）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbitlang/yacc](https://mooncakes.io/docs/moonbitlang/yacc) | 0.7.25 | 11.0万 | A LR(1) parser generator for MoonBit programming language. |
| 2 | [cogna-dev/parkit](https://mooncakes.io/docs/cogna-dev/parkit) | 0.1.1 | 184 | A nom-like parser combinator framework for MoonBit |

> 完整方案仅 2 个，说明该类需求目前在生态中主要依靠基础库组合实现，下方基础库清单的实用价值更高。

### 基础库（286）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbitlang/parser](https://mooncakes.io/docs/moonbitlang/parser) | 0.4.7 | 24.7万 | AST and parsers for the MoonBit programming language |
| 2 | [bobzhang/lexer](https://mooncakes.io/docs/bobzhang/lexer) | 0.3.1 | 17.4万 | A generic lexer library for handwritten lexers in MoonBit |
| 3 | [Yoorkin/ArgParser](https://mooncakes.io/docs/Yoorkin/ArgParser) | 0.2.1 | 10.8万 | command line argument parser |
| 4 | [mizchi/markdown](https://mooncakes.io/docs/mizchi/markdown) | 0.8.4 | 2.2万 | Incremental Markdown parser and compiler |
| 5 | [Milky2018/xml](https://mooncakes.io/docs/Milky2018/xml) | 0.6.1 | 7.9万 | A document-buffered pull XML parser for MoonBit |
| 6 | [moonrockz/krueger](https://mooncakes.io/docs/moonrockz/krueger) | 0.8.0 | 2.0万 | Parser and parsing utilities for Elm and Elm-like dialects (e.g. Morphir) in Moo… |
| 7 | [moonbitlang/lexer](https://mooncakes.io/docs/moonbitlang/lexer) | 0.4.4 | 13.3万 | Lexer for the MoonBit programming language |
| 8 | [moonbit-community/toml](https://mooncakes.io/docs/moonbit-community/toml) | 0.5.1 | 4.5万 | A TOML parser implementation in MoonBit |


## 正则匹配

正则表达式引擎与匹配。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 9 个，此处列出前 9 个。

### 基础库（9）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbitlang/regexp](https://mooncakes.io/docs/moonbitlang/regexp) | 0.3.7 | 6.4万 | A regular expression engine for MoonBit based on VM execution designed for predi… |
| 2 | [yj-qin/regexp](https://mooncakes.io/docs/yj-qin/regexp) | 0.3.6 | 126 | A regular expression library based on a backtracking engine. |
| 3 | [walkzzz/re-mbt](https://mooncakes.io/docs/walkzzz/re-mbt) | 0.1.0 | 116 | A port of ocaml-re — the pure OCaml regular expression library — to idiomatic Mo… |
| 4 | [moonbitstack/moonregex](https://mooncakes.io/docs/moonbitstack/moonregex) | 0.1.2 | 257 | Regular expressions for MoonBit. |
| 5 | [mizchi/js_regexp](https://mooncakes.io/docs/mizchi/js_regexp) | 0.0.4 | 59 | JS RegExp binding |
| 6 | [ZijianFeng33/regexp](https://mooncakes.io/docs/ZijianFeng33/regexp) | 0.1.0 | 35 | a simple regex matcher in moon |
| 7 | [Hjyyutr/moonyara](https://mooncakes.io/docs/Hjyyutr/moonyara) | 0.1.5 | 68 | A native MoonBit threat signature matching and malware scanning engine. |
| 8 | [YeeHh2004/mooninput](https://mooncakes.io/docs/YeeHh2004/mooninput) | 0.2.2 | 67 | Composable structured input editing: dynamic masks, bounded regex, validation, n… |
| 9 | [FidollarinLA/moonmask](https://mooncakes.io/docs/FidollarinLA/moonmask) | 0.1.0 | 30 | Constrained decoding for LLMs in MoonBit: compile JSON Schema and regex to byte-… |


## Unicode / 文本处理

Unicode 分类、字素簇、宽度计算、字符串工具。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 104 个，此处列出前 12 个。

### 基础库（104）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbit-community/charclass](https://mooncakes.io/docs/moonbit-community/charclass) | 0.1.4 | 7.9万 | Unicode character classification library providing functions to determine charac… |
| 2 | [moonbit-community/unicodewidth](https://mooncakes.io/docs/moonbit-community/unicodewidth) | 0.2.1 | 4.5万 | A simple library for measuring the width of unicode characters and strings. |
| 3 | [kawaz/grapheme](https://mooncakes.io/docs/kawaz/grapheme) | 0.10.4 | 3.1万 | Unicode grapheme cluster segmentation library for MoonBit (UAX #29) |
| 4 | [moonbit-community/displaytext](https://mooncakes.io/docs/moonbit-community/displaytext) | 0.1.7 | 2.9万 | Grapheme-aware display-cell text boundaries for terminal UIs. |
| 5 | [mizchi/x](https://mooncakes.io/docs/mizchi/x) | 0.6.1 | 20.5万 | Cross-platform MoonBit compatibility facades with native delegation and accelera… |
| 6 | [myfreess/charclass](https://mooncakes.io/docs/myfreess/charclass) | 0.1.3 | 2.0万 | Unicode character classification library providing functions to determine charac… |
| 7 | [moonbit-community/ucd](https://mooncakes.io/docs/moonbit-community/ucd) | 0.5.2 | 7.1万 | Unicode Character Database lookup and case mapping for MoonBit |
| 8 | [moonbit-community/prettyprinter](https://mooncakes.io/docs/moonbit-community/prettyprinter) | 0.4.11 | 14.3万 | pretty printer for moonbit |
| 9 | [Milky2018/moon_cosmic](https://mooncakes.io/docs/Milky2018/moon_cosmic) | 0.3.8 | 5.7万 | MoonBit port of cosmic-text (text shaping, layout, and editor primitives) built … |
| 10 | [moonbit-community/bidi](https://mooncakes.io/docs/moonbit-community/bidi) | 0.5.2 | 1.9万 | Unicode Bidirectional Algorithm for MoonBit |
| 11 | [moonbit-community/unicode](https://mooncakes.io/docs/moonbit-community/unicode) | 0.6.0 | 1.9万 | Unicode in MoonBit |
| 12 | [moonbit-community/fuzzy_match](https://mooncakes.io/docs/moonbit-community/fuzzy_match) | 0.2.6 | 4.3万 | A library for fuzzy string matching and fuzzy string searching |


## 加密 / 哈希 / 编码

哈希、对称加密、Base64/编码、安全相关。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 117 个，此处列出前 12 个。

### 基础库（117）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbitlang/x](https://mooncakes.io/docs/moonbitlang/x) | 0.5.7 | 75.8万 | experimental packages for moonbitlang/core |
| 2 | [illusory0x0/rijndael](https://mooncakes.io/docs/illusory0x0/rijndael) | 0.1.0 | 1.1万 | A MoonBit implementation of the Rijndael (AES) encryption algorithm |
| 3 | [cc06b/mooncry](https://mooncakes.io/docs/cc06b/mooncry) | 0.95.0 | 1.0万 | Pure-MoonBit crypto primitives: SHA-1/2 (incl. SHA-512/224/256), SHA-3, Keccak-2… |
| 4 | [gmlewis/base64](https://mooncakes.io/docs/gmlewis/base64) | 0.16.14 | 8.2万 | MoonBit base64: provide simple base64 operations. |
| 5 | [Tigls/mb-hash](https://mooncakes.io/docs/Tigls/mb-hash) | 0.1.0 | 7.6k | Secure hashing for MoonBit (SHA-256, SHA-512; native+WASM) |
| 6 | [gmlewis/hash](https://mooncakes.io/docs/gmlewis/hash) | 0.21.2 | 6.1万 | MoonBit hash: provide hash functions similar to Go. |
| 7 | [mizchi/cbor](https://mooncakes.io/docs/mizchi/cbor) | 0.1.1 | 5.8万 | CBOR (RFC 8949) implementation for MoonBit - Pure and FFI versions |
| 8 | [moonbitstack/mooncrypt](https://mooncakes.io/docs/moonbitstack/mooncrypt) | 0.4.7 | 4.0k | Cryptographic algorithms for MoonBit, one per package. |
| 9 | [gmlewis/sha256](https://mooncakes.io/docs/gmlewis/sha256) | 0.18.2 | 3.8k | MoonBit sha256: provide simple sha256 hash algorithm. |
| 10 | [mizchi/experimental_crypto](https://mooncakes.io/docs/mizchi/experimental_crypto) | 0.0.2 | 1.1万 | EXPERIMENTAL — pure-MoonBit cryptography / PKI / JOSE building blocks. Education… |
| 11 | [mizchi/bit_hash](https://mooncakes.io/docs/mizchi/bit_hash) | 0.48.1 | 2.3k | Git object hashing primitives (gix-hash equivalent) |
| 12 | [hustcer/ed25519](https://mooncakes.io/docs/hustcer/ed25519) | 0.6.1 | 1.9万 | A pure MoonBit Ed25519 signing and verification package. |


## 压缩 / 归档

DEFLATE / zlib / gzip / ZIP 的压缩与解压实现。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 55 个，此处列出前 12 个。

### 基础库（55）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [mizchi/zlib](https://mooncakes.io/docs/mizchi/zlib) | 0.4.10 | 20.5万 | Pure MoonBit zlib/deflate implementation. |
| 2 | [moonbit-community/flate](https://mooncakes.io/docs/moonbit-community/flate) | 0.10.0 | 5.3万 | Pure-MoonBit, runtime-agnostic DEFLATE (RFC 1951) engine with gzip/zlib/zip wrap… |
| 3 | [Milky2018/moon_yazi](https://mooncakes.io/docs/Milky2018/moon_yazi) | 0.1.4 | 7.2万 | A small zlib/DEFLATE implementation in MoonBit (ported from yazi). |
| 4 | [gmlewis/zlib](https://mooncakes.io/docs/gmlewis/zlib) | 0.21.17 | 6.1万 | MoonBit zlib: provide simplified zlib format compressed data. |
| 5 | [mizchi/brotli](https://mooncakes.io/docs/mizchi/brotli) | 0.2.2 | 3.6万 | Brotli compression and decompression library for MoonBit |
| 6 | [mizchi/x](https://mooncakes.io/docs/mizchi/x) | 0.6.1 | 20.5万 | Cross-platform MoonBit compatibility facades with native delegation and accelera… |
| 7 | [hustcer/fzip](https://mooncakes.io/docs/hustcer/fzip) | 0.8.8 | 2.0万 | High-performance compression library for MoonBit, ported from fflate. (DEFLATE/G… |
| 8 | [hustcer/fbr](https://mooncakes.io/docs/hustcer/fbr) | 0.8.2 | 1.5万 | Pure MoonBit Brotli (.br) encoder and decoder with split encode/decode packages |
| 9 | [gmlewis/flate](https://mooncakes.io/docs/gmlewis/flate) | 0.36.17 | 6.6万 | MoonBit flate: provide simplified flate (LZW) compression algorithm. |
| 10 | [moonbit-community/zipc](https://mooncakes.io/docs/moonbit-community/zipc) | 0.2.2 | 4.0k | Typed, in-memory ZIP archive library for MoonBit (deflate via moonbit-community/… |
| 11 | [Milky2018/zstd](https://mooncakes.io/docs/Milky2018/zstd) | 0.1.4 | 3.9k | — |
| 12 | [bikallem/compress](https://mooncakes.io/docs/bikallem/compress) | 0.3.4 | 2.7k | Compression library for MoonBit: flate, gzip, zlib, lzw, bzip2, snappy, lz4, zst… |


## 文件 / 路径 / IO

文件系统访问、路径与环境变量、临时文件、通用 IO 抽象与文件监听。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 122 个，此处列出前 12 个。

### 基础库（122）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [mizchi/tempfile](https://mooncakes.io/docs/mizchi/tempfile) | 0.1.3 | 15.5万 | Temporary file and directory management for MoonBit |
| 2 | [mizchi/x](https://mooncakes.io/docs/mizchi/x) | 0.6.1 | 20.5万 | Cross-platform MoonBit compatibility facades with native delegation and accelera… |
| 3 | [gmlewis/io](https://mooncakes.io/docs/gmlewis/io) | 0.23.20 | 6.8万 | MoonBit io: provide simplified I/O abstractions similar to Go. |
| 4 | [moonbitlang/jsonl](https://mooncakes.io/docs/moonbitlang/jsonl) | 0.2.1 | 2.7万 | Async reader for JSON Lines (newline-delimited JSON) streams. |
| 5 | [mizchi/fswatch](https://mooncakes.io/docs/mizchi/fswatch) | 0.2.1 | 1.3k | Cross-platform filesystem watcher for MoonBit: FSEvents on macOS, inotify on Lin… |
| 6 | [cc06b/mooncry](https://mooncakes.io/docs/cc06b/mooncry) | 0.95.0 | 1.0万 | Pure-MoonBit crypto primitives: SHA-1/2 (incl. SHA-512/224/256), SHA-3, Keccak-2… |
| 7 | [Kaida-Amethyst/path](https://mooncakes.io/docs/Kaida-Amethyst/path) | 0.1.1 | 1.6k | A cross-platform file path manipulation library for MoonBit, supporting both Uni… |
| 8 | [trkbt10/osenv](https://mooncakes.io/docs/trkbt10/osenv) | 0.1.0 | 626 | OS environment utilities: platform detection, safe path operations, and OS-stand… |
| 9 | [totto2727/target-file-discovery](https://mooncakes.io/docs/totto2727/target-file-discovery) | 0.2.1 | 324 | Reusable target file discovery for MoonBit |
| 10 | [ZSeanYves/bufferutils](https://mooncakes.io/docs/ZSeanYves/bufferutils) | 0.37.0 | 2.9k | Zero-copy shared byte buffers with high-performance synchronous, native, and asy… |
| 11 | [vicTop-cw/RX-MBT](https://mooncakes.io/docs/vicTop-cw/RX-MBT) | 0.4.0 | 2.8k | Rx-Rust 的 MoonBit 复刻：基于 Observer 模式的响应式编程库（Observable / Subject / Scheduler / 操作… |
| 12 | [mizchi/js_web](https://mooncakes.io/docs/mizchi/js_web) | 0.13.1 | 2.6k | web standard api bindings (fetch, Streams, Blob, URL, Crypto, ...) |


## 数学 / 数值计算

高精度数学、线性代数、矩阵、BLAS、统计。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 64 个，此处列出前 12 个。

### 基础库（64）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [Kaida-Amethyst/math](https://mooncakes.io/docs/Kaida-Amethyst/math) | 0.1.21 | 5.7k | High-precision Math library Implemented By Pure Moonbit |
| 2 | [Luna-Flow/luna-generic](https://mooncakes.io/docs/Luna-Flow/luna-generic) | 0.4.0 | 6.8k | Algebraic traits and default numeric instances that define the generic foundatio… |
| 3 | [Luna-Flow/linear-algebra](https://mooncakes.io/docs/Luna-Flow/linear-algebra) | 0.5.2 | 3.1k | Trait-oriented linear algebra foundations for MoonBit, with checked APIs, backen… |
| 4 | [mizchi/blas](https://mooncakes.io/docs/mizchi/blas) | 0.1.3 | 2.9k | BLAS bindings for MoonBit (Accelerate/OpenBLAS) |
| 5 | [mizchi/numbt](https://mooncakes.io/docs/mizchi/numbt) | 0.2.4 | 1.6k | NumPy-style numerical computing library for MoonBit |
| 6 | [Luna-Flow/luna-utils](https://mooncakes.io/docs/Luna-Flow/luna-utils) | 0.3.0 | 2.7k | Backend-independent numeric base with floating-point classification, canonical N… |
| 7 | [Luna-Flow/calculus-numerical](https://mooncakes.io/docs/Luna-Flow/calculus-numerical) | 0.3.1 | 1.3k | A numerical calculus library, a part of LunaFlow. |
| 8 | [Luna-Flow/arithmetic](https://mooncakes.io/docs/Luna-Flow/arithmetic) | 0.5.1 | 1.2k | Arithmetic capability traits and checked analytic operations for LunaFlow numeri… |
| 9 | [applejag/micromath](https://mooncakes.io/docs/applejag/micromath) | 0.3.0 | 1.4k | Embedded math arithmetic, optimized for small code size at the cost of precision |
| 10 | [CAIMEOX/moon_floating](https://mooncakes.io/docs/CAIMEOX/moon_floating) | 0.3.1 | 366 | Arbitrary-precision real, complex, interval, and numerical computing for MoonBit |
| 11 | [Luna-Flow/luna-poly](https://mooncakes.io/docs/Luna-Flow/luna-poly) | 0.4.0 | 185 | Immutable and mutable polynomial libraries for MoonBit with canonical dense, spa… |
| 12 | [bobzhang/loop_invariants_math](https://mooncakes.io/docs/bobzhang/loop_invariants_math) | 0.17.0 | 123 | Mathematical algorithms with loop-invariant explanations |


## 数据结构 / 算法

有序映射、B 树、堆、图算法、集合。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 95 个，此处列出前 12 个。

### 基础库（95）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [dowdiness/btree](https://mooncakes.io/docs/dowdiness/btree) | 0.2.0 | 3.4万 | Generic counted B-tree with O(log n) indexed access, insert, delete, and range o… |
| 2 | [dowdiness/order-tree](https://mooncakes.io/docs/dowdiness/order-tree) | 0.1.2 | 3.1万 | Order-statistic B-tree with O(log n) position-indexed operations |
| 3 | [dowdiness/alga](https://mooncakes.io/docs/dowdiness/alga) | 0.4.0 | 4.4万 | Algebraic graphs for MoonBit — directed graph trait and algorithm library inspir… |
| 4 | [dowdiness/rle](https://mooncakes.io/docs/dowdiness/rle) | 0.2.3 | 5.1万 | Generic run-length encoded sequence with O(log n) position lookup |
| 5 | [dowdiness/event-graph-walker](https://mooncakes.io/docs/dowdiness/event-graph-walker) | 0.8.0 | 2.2万 | Implementation of the eg-walker CRDT algorithm with FugueMax sequence CRDT |
| 6 | [moonbit-community/diago](https://mooncakes.io/docs/moonbit-community/diago) | 0.4.0 | 4.1k | A diagram toolkit for MoonBit with Dagre, ELK, and Railway layout engines, rende… |
| 7 | [wedarp/moongraph](https://mooncakes.io/docs/wedarp/moongraph) | 0.2.2 | 424 | Pure MoonBit generic graph data structures and algorithms |
| 8 | [wzzc-dev/moui_skia](https://mooncakes.io/docs/wzzc-dev/moui_skia) | 0.2.6 | 1.9k | MoonBit bindings for the Skia Graphics Library |
| 9 | [totto2727/any-collection](https://mooncakes.io/docs/totto2727/any-collection) | 0.2.2 | 180 | Typed references over mutable and immutable maps of dynamically typed values |
| 10 | [bobzhang/loop_invariants](https://mooncakes.io/docs/bobzhang/loop_invariants) | 0.9.0 | 128 | Comprehensive collection of algorithms and data structures with well-documented … |
| 11 | [wzzc-dev/moui_sun](https://mooncakes.io/docs/wzzc-dev/moui_sun) | 0.2.6 | 1.1k | Experimental MoonBit-native CPU raster stack for MoUI |
| 12 | [aurasuisui/indexmap](https://mooncakes.io/docs/aurasuisui/indexmap) | 0.4.0 | 62 | A hash map that preserves insertion order - MoonBit port of Rust's indexmap |


## 测试 / 断言 / 属性测试

单元测试、属性测试（quickcheck）、断言库、BDD、基准。

### 完整方案（4）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbitlang/quickcheck](https://mooncakes.io/docs/moonbitlang/quickcheck) | 0.15.1 | 19.7万 | Automatic testing of MoonBit programs |
| 2 | [moonrockz/moonspec](https://mooncakes.io/docs/moonrockz/moonspec) | 0.11.0 | 1.5万 | BDD test framework for MoonBit with Gherkin and Cucumber Expressions |
| 3 | [aspnmy/moonitest](https://mooncakes.io/docs/aspnmy/moonitest) | 0.2.1 | 57 | MoonBit integration test framework - real Docker/TCP/HTTP API via fangyinc/socke… |
| 4 | [Duckweed/moon-proof](https://mooncakes.io/docs/Duckweed/moon-proof) | 0.1.3 | 34 | MoonProof：MoonBit 文档与教程示例的持续验证框架——把文档里的代码块抽出来，隔离编译运行，回答“我们文档里的例子还都对吗” |

### 基础库（62）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonrockz/expect](https://mooncakes.io/docs/moonrockz/expect) | 0.6.1 | 3.9万 | A fluent assertion library for MoonBit |
| 2 | [moonrockz/cucumber-expressions](https://mooncakes.io/docs/moonrockz/cucumber-expressions) | 0.6.1 | 1.6万 | Cucumber Expressions parser and matcher for MoonBit |
| 3 | [moonrockz/gherkin](https://mooncakes.io/docs/moonrockz/gherkin) | 0.5.1 | 1.6万 | A Gherkin parser for MoonBit with DOM, visitor, fold, and SAX-style APIs |
| 4 | [moonrockz/cucumber-messages](https://mooncakes.io/docs/moonrockz/cucumber-messages) | 0.5.0 | 1.6万 | Cucumber Messages protocol types for MoonBit with JSON serialization and NDJSON … |
| 5 | [moonbit-community/fuzzy_match](https://mooncakes.io/docs/moonbit-community/fuzzy_match) | 0.2.6 | 4.3万 | A library for fuzzy string matching and fuzzy string searching |
| 6 | [CAIMEOX/qc_pyext](https://mooncakes.io/docs/CAIMEOX/qc_pyext) | 0.1.1 | 1.4k | QuickCheck and reference testing extension for Python programs |
| 7 | [f4ah6o/turtles](https://mooncakes.io/docs/f4ah6o/turtles) | 0.4.7 | 866 | Mutation testing for MoonBit projects |
| 8 | [zhangbowen2006/moonbit-target-parity](https://mooncakes.io/docs/zhangbowen2006/moonbit-target-parity) | 0.5.1 | 595 | Reusable cross-target behavior contract comparison for MoonBit programs. |


## 开发工具 / 代码质量

代码格式化、静态分析、lint、结构化搜索与重构、代码生成与脚手架。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 60 个，此处列出前 12 个。

### 基础库（60）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbitlang/formatter](https://mooncakes.io/docs/moonbitlang/formatter) | 0.1.6 | 5.1k | code prettifier for MoonBit |
| 2 | [riantr/moonbit_static_analysis](https://mooncakes.io/docs/riantr/moonbit_static_analysis) | 0.4.39 | 1.6k | Three-inspection (structural / type / behavior) static analysis for MoonBit prog… |
| 3 | [moonbitlang/protobuf](https://mooncakes.io/docs/moonbitlang/protobuf) | 0.2.0 | 4.3k | The runtime library for protobuf |
| 4 | [mizchi/codegen](https://mooncakes.io/docs/mizchi/codegen) | 0.2.4 | 1.4k | Generic code generation library with abstract IR |
| 5 | [moonbit-community/moongrep](https://mooncakes.io/docs/moonbit-community/moongrep) | 0.3.10 | 315 | Experimental MoonBit structural search and taint-analysis tool |
| 6 | [moonbitstack/moonast](https://mooncakes.io/docs/moonbitstack/moonast) | 0.2.4 | 689 | Code generation for MoonBit from annotated declarations. |
| 7 | [golemcloud/golem_sdk_tools](https://mooncakes.io/docs/golemcloud/golem_sdk_tools) | 0.6.2 | 634 | Code generation tools for the Golem SDK for MoonBit |
| 8 | [moonbitstack/moonctl](https://mooncakes.io/docs/moonbitstack/moonctl) | 0.12.5 | 135 | Project and code generator for MoonBit services. |
| 9 | [Milky2018/aarch64_target](https://mooncakes.io/docs/Milky2018/aarch64_target) | 0.18.0 | 649 | AArch64 direct MilkIR target pipeline to native code |
| 10 | [Milky2018/x64_target](https://mooncakes.io/docs/Milky2018/x64_target) | 0.18.0 | 628 | x64 direct MilkIR target pipeline to native code |
| 11 | [Milky2018/vcode](https://mooncakes.io/docs/Milky2018/vcode) | 0.18.0 | 510 | Target-independent native lowering, VCode, and code-object infrastructure |
| 12 | [marianoguerra/wax](https://mooncakes.io/docs/marianoguerra/wax) | 0.4.2 | 509 | The Wax language in MoonBit: parser, formatter, type checker, and wasm/wat emitt… |


## Markdown / 文档转换

Markdown 解析、HTML/PDF/DOCX 转换、文档排版。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 94 个，此处列出前 12 个。

### 基础库（94）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbitlang/pdflite](https://mooncakes.io/docs/moonbitlang/pdflite) | 0.4.1 | 2.0万 | Byte-oriented PDF reading, writing, and manipulation toolkit for MoonBit. |
| 2 | [bobzhang/html_parser](https://mooncakes.io/docs/bobzhang/html_parser) | 0.2.2 | 1.3万 | MoonBit HTML parser and sanitizer ported from JustHTML. |
| 3 | [hustcer/html2md](https://mooncakes.io/docs/hustcer/html2md) | 0.1.3 | 1.3万 | Convert HTML to Markdown (CommonMark), a MoonBit port of JohannesKaufmann/html-t… |
| 4 | [moonbitlang/pagelayout](https://mooncakes.io/docs/moonbitlang/pagelayout) | 0.8.1 | 1.3万 | Paginated document layout engine: format-neutral page-model IR with SVG/PDF back… |
| 5 | [moonbitlang/docx2html](https://mooncakes.io/docs/moonbitlang/docx2html) | 0.7.1 | 1.3万 | Native MoonBit DOCX to HTML/Markdown converter ported from Mammoth |
| 6 | [moonbit-community/cmark](https://mooncakes.io/docs/moonbit-community/cmark) | 0.4.13 | 9.8万 | A CommonMark toolkit for MoonBit |
| 7 | [mizchi/markdown](https://mooncakes.io/docs/mizchi/markdown) | 0.8.4 | 2.2万 | Incremental Markdown parser and compiler |
| 8 | [moonrockz/pretty](https://mooncakes.io/docs/moonrockz/pretty) | 0.3.0 | 2.1万 | Wadler-style pretty printer for MoonBit: documents, groups and layout that fits … |
| 9 | [Lampese/office-viewer](https://mooncakes.io/docs/Lampese/office-viewer) | 0.2.6 | 1.3万 | A read-only DOCX, XLSX, PPTX, and PDF viewer with structured selections. |
| 10 | [moonbit-community/html](https://mooncakes.io/docs/moonbit-community/html) | 0.2.3 | 4.5k | WHATWG HTML5 spec-compliant parser for MoonBit |
| 11 | [justjavac/template](https://mooncakes.io/docs/justjavac/template) | 0.1.2 | 4.3k | A small and fast precompiled template engine for MoonBit. |
| 12 | [Xiao-li-He/MoonMarkMind](https://mooncakes.io/docs/Xiao-li-He/MoonMarkMind) | 0.1.0 | 338 | Markdown mind-map toolkit and browser application built with MoonBit |


## 时间 / 日期

日期时间、时区、RFC3339、cron。

### 完整方案（0）

> 本场景**尚无完整方案**。这表明该需求在生态中尚未形成「一套骨架」，需要由开发者自行组合基础库。下方按用途列出可用的基础库，共 40 个，此处列出前 12 个。

### 基础库（40）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [moonbitlang/x](https://mooncakes.io/docs/moonbitlang/x) | 0.5.7 | 75.8万 | experimental packages for moonbitlang/core |
| 2 | [moonbitstack/moondate](https://mooncakes.io/docs/moonbitstack/moondate) | 0.1.2 | 4.5k | Dates, times, durations and cron expressions for MoonBit. |
| 3 | [brickfrog/tempo](https://mooncakes.io/docs/brickfrog/tempo) | 0.8.1 | 597 | UTC date/time library — RFC 3339 parsing, Unix timestamps, arithmetic |
| 4 | [mldong/moon-hutool](https://mooncakes.io/docs/mldong/moon-hutool) | 0.1.7 | 534 | Hutool-style utility library for MoonBit: all packages depend only on moonbitlan… |
| 5 | [kawaz/timespec](https://mooncakes.io/docs/kawaz/timespec) | 0.2.4 | 256 | CLI-oriented time specification parser for MoonBit |
| 6 | [mizchi/bit_date](https://mooncakes.io/docs/mizchi/bit_date) | 0.48.1 | 2.2k | Git date parsing primitives (gix-date equivalent) |
| 7 | [caijiewei295/tzif-engine](https://mooncakes.io/docs/caijiewei295/tzif-engine) | 0.1.0 | 205 | Pure MoonBit IANA TZif v2/v3 parser and timezone conversion engine. UTC ↔ local … |
| 8 | [001-Elsa/mooncron](https://mooncakes.io/docs/001-Elsa/mooncron) | 0.1.4 | 70 | A cron expression parser and schedule calculator written in MoonBit. |
| 9 | [iceBear67/time](https://mooncakes.io/docs/iceBear67/time) | 0.1.2 | 65 | A date-time library in MoonBit, including zone offsets and clocks that support J… |
| 10 | [marianoguerra/temporal](https://mooncakes.io/docs/marianoguerra/temporal) | 0.1.2 | 63 | An implementation of ECMAScript Temporal: calendar and time-zone aware dates, ti… |
| 11 | [mizchi/whenwords](https://mooncakes.io/docs/mizchi/whenwords) | 0.1.3 | 59 | A relative time formatting library for MoonBit, following the whenwords specific… |
| 12 | [suiyunonghen/datetime](https://mooncakes.io/docs/suiyunonghen/datetime) | 0.1.6 | 51 | datetime type of moonbit |


## WebAssembly / JS 互操作

Wasm 组件模型、WASI、FFI、JS 绑定。

### 完整方案（1）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [Milky2018/wasmoon](https://mooncakes.io/docs/Milky2018/wasmoon) | 0.18.0 | 691 | WebAssembly runtime with native JIT, interpreter, WASI and Component Model suppo… |

> 完整方案仅 1 个，说明该类需求目前在生态中主要依靠基础库组合实现，下方基础库清单的实用价值更高。

### 基础库（303）

| # | 包 | 版本 | 下载 | 说明 |
|---|---|---|---|---|
| 1 | [mizchi/mwac](https://mooncakes.io/docs/mizchi/mwac) | 0.2.2 | 6.6万 | WAC (WebAssembly Compositions) composer for the Component Model |
| 2 | [mizchi/wite](https://mooncakes.io/docs/mizchi/wite) | 0.11.3 | 6.5万 | Component-model-aware WebAssembly analyzer, optimizer, and profiler |
| 3 | [mizchi/oci_wasm](https://mooncakes.io/docs/mizchi/oci_wasm) | 0.5.1 | 6.6万 | WebAssembly package registry client |
| 4 | [mizchi/x](https://mooncakes.io/docs/mizchi/x) | 0.6.1 | 20.5万 | Cross-platform MoonBit compatibility facades with native delegation and accelera… |
| 5 | [mizchi/wit](https://mooncakes.io/docs/mizchi/wit) | 0.3.3 | 6.5万 | WIT parser and resolver in MoonBit |
| 6 | [mizchi/js](https://mooncakes.io/docs/mizchi/js) | 0.13.0 | 4.3万 | js bindings for MoonBit: re-exports mizchi/js_core + mizchi/js_builtin (web/node… |
| 7 | [moonbit-community/proton_ffi](https://mooncakes.io/docs/moonbit-community/proton_ffi) | 0.6.0 | 2.7万 | MoonBit Foreign Function Interface. |
| 8 | [justjavac/ffi](https://mooncakes.io/docs/justjavac/ffi) | 0.2.6 | 2.5万 | MoonBit Foreign Function Interface. |
