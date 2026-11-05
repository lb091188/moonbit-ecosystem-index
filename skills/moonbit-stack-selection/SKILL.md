---
name: moonbit-stack-selection
description: Use this skill when choosing MoonBit packages or planning an application's stack — desktop app, mobile app, WeChat/HarmonyOS mini program, web backend, frontend UI, TUI, CLI, game engine, database/ORM, LLM agent, WebAssembly interop, or testing. It maps a product requirement onto a MoonBit scenario id, separates "full solutions" (frameworks that carry the skeleton) from "building blocks", and states each option's platform targets and boundaries. Trigger words: MoonBit 选型, 选包, 技术栈, 用哪个库, 做个桌面应用, mooncakes 选哪个, which MoonBit package, desktop framework, web framework.
---

# MoonBit 选型

给「要做成什么东西」找 MoonBit 的库，并且说清为什么是它、什么时候不该用它。

数据来自 mooncakes 注册表全量快照，场景与候选由人工划到「完整方案 / 基础库」两层。
本 skill 自带快照，不需要联网。

## 三步

**1. 先落场景，再谈选型。** 用户说的是产品形态（「做个桌面小工具」），不是包。
从需求里提取产物形态，映射到场景 id：

| 需求 | 场景 id |
|---|---|
| 桌面应用、窗口程序、托盘常驻 | `gui` |
| 手机 App、跨端、小程序、鸿蒙 | `mobi` |
| 浏览器里的界面、单页应用 | `ui` |
| 终端界面、全屏 TUI | `tui` |
| 命令行工具、参数解析 | `cli` |
| 游戏、ECS、渲染循环 | `game` |
| 服务端接口、REST、路由 | `http` |
| 调别人的 HTTP 接口 | `httpc` |
| 连数据库、ORM、迁移 | `db` |
| 并发、协程、Actor | `async` |
| 接大模型、Agent、MCP | `llm` |
| 解析 YAML/TOML/CSV/JSON | `datafmt` / `json`（后者无骨架） |
| 跑 wasm、和 JS 互操作 | `wasm` |
| 写测试 | `test` |

完整场景表见 `references/scenarios.md`（分组、场景、id、文件）。

**2. 查。** 不要凭记忆报包名。先在本 skill 目录下定位 id，再按需读文件：

| 文件 | 内容 | 什么时候读 |
|---|---|---|
| `references/scenarios.md` | 场景总表：分组、id、对应文件 | 不确定该落哪个 id 时 |
| `references/<id>.md` | 该场景的索引页：完整方案全量（简介 + 包页链接）+ 基础库按推荐次序列出 | 每次都要 |
| `references/<id>-libs.md` | 同一场景的基础库全量，只有基础库较多、索引页放不下时才存在 | 索引页里的候选都不合适，或被明确要求穷举时 |

例：需求是「做个桌面小工具」→ `gui` → 读 `references/gui.md`。索引页尾部若有一行
「其余基础库见 `<id>-libs.md` 全量分册」，那就是分册入口——**没被要求穷举就不要往下读**。
一次只处理一个场景，不要把整个 `references/` 都读进来。

**3. 给建议。** 每个场景给 1–3 个候选，每个都写清三件事：**形态**（谁负责画/谁负责调度）、**平台目标**（native / wasm / js / wasm-gc）、**代价**。最后单列一节「风险与未核实」。

## 硬规则

- **不按下载量推荐。** 索引里的序号是场景内推荐次序，不是热度。下载量衡量历史，不衡量合适度：`moonbit-community/yaml` 的下载量在同类里靠前，但 `keywords` 是空字段，在注册表里搜不到。
- **先问平台目标。** MoonBit 的包对 target 极敏感：`bobzhang/crescent` 只支持 native 与 wasm，不支持 js 与 wasm-gc；`oboard/mocket` 三种都支持。目标不匹配，选型直接作废。
- **「完整方案」≠ 生产可用。** `vectie/lepusa` 是研究性实现，只宜作架构参考；`Nanaloveyuki/orbit` 仍是 alpha。这类状态必须在建议里点明。
- **没骨架就说没骨架。** 有些场景还没有框架级实现（图形渲染、JSON、文件 IO、正则……），只能用基础库拼。不要为了凑一个「框架」而推荐不合适的包。
- **不编 API。** 快照只有形态与能力，没有函数签名。需要具体 API 时去 `https://mooncakes.io/docs/<name>` 或仓库 README 核对，别推测。
- 简介里出现「XX 风格」「参照 YY」时，那是设计取向，不是兼容性承诺。

## 常见组合

| 目标 | 骨架 | 补齐 |
|---|---|---|
| 桌面，界面用 Web 技术 | `proton`（CEF 内嵌 Chromium，随应用分发）／`orbit`（系统 WebView + 策略授权 IPC）／`lepus-apps/webview`（HTML/CSS 交给前端，MoonBit 管窗口） | 前端层用现成前端框架；系统能力（托盘、剪贴板）走各方案自带模块 |
| 桌面，不要浏览器 | `native-gui`（系统渲染引擎，托盘/通知/快捷键/输入法/自启内置）／`moui`（自带渲染引擎，桌面与移动同一套代码）／`giraffe`（GTK4 原生控件，Linux 最顺） | `wzzc-dev/window` 等窗口层；注意 moui 与 native-gui 的差别只在渲染归属 |
| Web 后端 | `moonbitlang/moonback`（官方基础）／`moonapi`（类型化路由 + 自动 OpenAPI）／`kupas/express`（Express 兼容，uWebSockets） | 数据层 `moondb` 接口 + `morm`/`Orion`/`moonorm`；异步 `moonbitlang/async` |
| 命令行工具 | `Yoorkin/ArgParser`（轻）／`mizchi/admiral`（类型化选项 + shell 补全）／`TheWaWaR/clap`（clap-rs 风格帮助） | `cli/*` 是被剔除的 MoonX coreutils 一族，不要当第三方库推荐 |
| 终端界面 | `moonetui`（控件最全）／`pippa`（Bubble Tea 风格）／`mizchi/tui`（信号驱动） | `onebit-tui`（Yoga flexbox 布局） |
| 小程序 / 移动 | `moon-miniprogram`（完整框架）／`minimoon`、`lampo`（Skyline 运行时，状态管理不同）／`bunnia`（可插拔平台适配）／`moonohos`（鸿蒙）／`moobile`（React Native 渲染） | UI 层 `rabbita`；跨端也可用 `moui` |
| LLM / Agent | `posoco`（六边形架构 Agent）／`weopqrst/agent`（LangChain 核心）／`mcp`（MCP SDK）／`moonlm`（本地推理）／`golem_sdk`（Golem 托管平台） | 注意 `golem_sdk` 绑定该平台，不可自托管 |

## 输出格式

先一句结论（选哪个、为什么），再一张表：

| 候选 | 形态 | 平台 | 代价 / 风险 |
|---|---|---|---|

最后写「未核实」：哪些结论只来自注册表描述、哪些来自 README、哪些是推断。用户是在做长期依赖决定，这一节比推荐本身重要。

## 数据

- 快照在 `references/`：一场景一个索引页 `<id>.md`，基础库较多时另有 `<id>-libs.md`
  全量分册，`scenarios.md` 是总表（表头写着采集日期）。正文即数据，不需要跑脚本、
  不需要解析 JSON；需要数量（包数、场景数）时读仓库的 `data/scenarios.json`。
- 本 skill 就在数据源仓库里（`moonbit-eco-index/skills/moonbit-stack-selection/`）。过期时
  在仓库里打开工作台「数据生成」点一次，重算后提交即可，不需要另外导出。
- 在线版（随时最新，中英双语）：单场景页 `https://moonbit-ecosystem-index.pages.dev/#/s/<id>`，
  例如 `#/s/gui`。站点是前端渲染的，直接抓页面只有空壳；没有本地文件时改取 raw
  `https://raw.githubusercontent.com/lb091188/moonbit-ecosystem-index/main/skills/moonbit-stack-selection/references/<id>.md`。
- 反馈与勘误：https://github.com/lb091188/moonbit-ecosystem-index
