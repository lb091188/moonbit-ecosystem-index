# MoonBit 已经有 3520 个包了，但没人告诉你该用哪个

MoonBit 这两年长得比很多人以为的快。

我上周拉了一次 mooncakes 的全量数据，已发布模块 3520 个。桌面、移动端、Web 框架、终端 UI、游戏引擎、HTTP 服务、数据库、LLM、微信小程序、鸿蒙……该有的基本都有了，有些方向还不止一个方案。

问题是：除了包作者自己，没多少人知道它们都在那儿。

## 一、包不少，但找不着

我想用 MoonBit 写个桌面小工具，打开 mooncakes 搜 `gui`。

出来一屏包。有底层窗口绑定，有 WebView 封装，有完整的应用框架，全混在一起排着。没有分类，没有层级，只有名字和一句话描述。

你得把每个 README 点开读一遍，才能判断「这个能不能当骨架用」。读了半个下午，我发现自己在做一件本来不该由使用者做的事。

这不是 mooncakes 的问题。注册表负责登记：有哪些包、什么版本、依赖谁。它不负责回答「我想做 X，该用哪几个」——那是选型，是另一件事。

而选型这件事，在包的数量过了三位数之后，就没人能靠翻 README 做完了。

## 二、我做的事

把 3520 个模块按**使用场景**重新排了一遍，37 个场景，覆盖从桌面到 WebAssembly 互操作。

每个场景里的包分两层：

- **完整方案**：能直接选型、定骨架的。框架、引擎、运行时、脚手架、ORM 都算。
- **基础库**：提供单点能力，由调用方自己组合。

37 个场景里 15 个有完整方案，一共 71 个包。剩下 22 个场景还没有框架级实现，那里的候选全部是基础库，就不硬分出「完整方案」这一栏。

**这 71 个完整方案，我每个写了一句人话简介。**

不是注册表里那句英文描述，而是回答三个问题：它是什么形态的方案、它替你做了哪些决定、什么情况下该选它。

下面就是全部内容。

## 三、界面与端

### 桌面（7）

- **moonbit-community/proton** — 类 Electron 的桌面运行时：界面交给内置浏览器承载，可直接复用现有前端生态，托盘、剪贴板、全局热键等系统模块配套齐全。
- **wzzc-dev/moui** — 自带渲染引擎的跨端 GUI 框架：不依赖系统 WebView，桌面与移动共用一套代码，能覆盖到没有浏览器内核的设备。
- **NoahLiu/native-gui** — 纯原生桌面方案：一套代码直出 Windows / Linux / macOS 原生窗口，托盘、通知、快捷键、输入法、开机自启等系统能力开箱即用。
- **vectie/lepusa** — MoonBit 原生桌面框架的研究性实现，更适合当参考读，而不是直接拿来做产品。
- **Nanaloveyuki/orbit** — 组合式桌面基座：原生窗口配系统 WebView，IPC 带策略授权，另附 orbit-cli 工具链，能力按需拼装而不是一次给全。
- **lepus-apps/webview** — 以 Web 技术构建桌面的应用框架：界面层完全交给 HTML / CSS，MoonBit 负责窗口、事件和系统调用。
- **tonyfettes/giraffe** — Elm 架构的声明式 UI 框架，底层绑定 GTK4，走原生控件路线，Linux 桌面上完成度最高。

### 移动端（7）

- **XiLaiTL/moobile** — 一套 Rabbita（TEA）代码同时出 Android / iOS / Web，渲染交给 React Native，前端团队迁移成本最低。
- **wzzc-dev/moui** — 自带渲染引擎的跨端 GUI 框架，桌面与移动共用一套代码。
- **lampclaw/minimoon** — 面向微信小程序 Skyline 渲染引擎的 UI 运行时：Elm 状态机驱动，局部状态更新是事务性的，宿主命令自动生成。
- **Magic486/moon-miniprogram** — 微信小程序开发框架：类型安全运行时、状态自动 diff、跨页 store、声明式路由，连无头测试基建都带了。
- **shop1111/moonohos** — HarmonyOS 原生模块框架：异步任务、平台模块调用、HAR 打包三件事一次解决。
- **lampclaw/lampo** — 小程序 Skyline 的另一条路线：纯 Elm 风格书写，状态按组件隔离，不共享全局 store。
- **vectie/bunnia** — 小程序 UI 框架，按 Rabbita 风格书写，靠可插拔的平台适配层支持多端。

### Web UI / 前端框架（6）

- **moonbit-community/rabbita** — 官方函数式 Web UI 框架，Elm 架构（Model-Update-View），生态配套最全，拿不准时选它。
- **mizchi/luna** — 细粒度响应式 UI 库：信号驱动、无虚拟 DOM diff，更新粒度和产物体积都更可控。
- **marianoguerra/tutuca** — 工具链最齐的一套：模板语言、虚拟 DOM、组件、运行时、lint、CLI 都在一个包里。
- **lampclaw/minimoon** — 小程序 Skyline 的 UI 运行时，Elm 状态机驱动。
- **Arcelyth/aitne** — 轻量响应式 Web 框架，主打运行时开销小，适合内容型页面而不是重交互应用。
- **vectie/bunnia** — 小程序 UI 框架，Rabbita 风格书写 + 模块化平台适配。

### 终端 UI（5）

- **mizchi/tui** — 信号驱动的 TUI 库，状态一变自动重绘，适合已经习惯响应式写法的项目。
- **moonbit-community/rabbita_tui** — 官方 Elm 架构终端工具包，和 Rabbita 共用一套心智模型，Web 与终端能沿用同一种组织方式。
- **Frank-III/onebit-tui** — 带 Yoga flexbox 布局引擎的 TUI 库，用 CSS 式的盒模型排版终端界面。
- **moonbitstack/moonetui** — 重工业 TUI 工具包：单元格缓冲加差分 ANSI 渲染、增量按键解析、五十个组件和一套类 CSS 设计系统。
- **brickfrog/pippa** — Bubble Tea 风格的 TUI 框架，Model-Update-View 加类型化消息，从 Go 生态迁过来最顺手。

### 游戏引擎 / ECS（6）

- **Milky2018/selene** — ECS 架构的游戏引擎，实体-组件-系统分层清晰，适合逻辑复杂、要长期加内容量的项目。
- **mizchi/kagura** — 2D 优先的游戏引擎（Ebiten 风格），简单循环加精灵绘制，做小游戏上手最快。
- **sssssurf/abyssal_chord** — 卡牌对战专用引擎，回合、牌库、结算流程都内置了，附带 CLI 演示。
- **sacckey/moon8bit** — 复古 2D 引擎：资源用文本描述、运行时确定性可复现，适合快速迭代和人机协作生成内容。
- **firefly/firefly** — Firefly Zero 掌机的游戏 SDK，目标平台是那台小设备，不是通用桌面。
- **sennenki/reisen** — 视觉小说引擎，按剧本、立绘、分支推进，不是通用游戏框架。

## 四、服务与数据

### Web 后端 / HTTP（13）

- **moonbitlang/moonback** — 官方 Web 后端框架，路由、中间件、请求响应抽象齐备，生态项目默认拿它当底座。
- **mizchi/mars** — Hono 风格的 Web 框架：trie 路由、中间件、SSE，HTTP 后端走 mizchi/x，原生和 Node.js 都能跑。
- **oboard/mocket** — 通用 Web 框架，路由与中间件齐备，接口风格接近 Express。
- **bobzhang/crescent** — Web 框架，出自 MoonBit 语言作者之手，实现偏探索性质，适合读代码而不是直接上生产。
- **jaredzhou/pony** — 轻量 HTTP 框架与路由器（Go 的 Chi 风格），只需要路由和中间件时用它。
- **RabitLogic/mbit** — Gin 风格的 Web 框架，API 设计和 Go 生态高度对应，从 Gin 迁过来几乎不用重新学。
- **moonbitstack/moonapi** — 类型化 Web 框架：路由、参数、响应都纳入类型检查，把错误挡在编译期。
- **daqing/moonway** — 全栈 Web 框架，前后端在同一个工程里组织，不用拆两套构建。
- **wflixu/Halo** — Koa 洋葱模型的中间件框架，支持结构化并发和流式响应，重中间件编排的服务适合它。
- **kupas/express** — Express 兼容的 Web 框架，底层走 uWebSockets，从 Node 迁过来改动最小。
- **KKKIIO/moondark** — Django 风格的后端框架，建在 moonback 之上，自带工程结构的约定。
- **moonbitstack/moonzero** — 服务框架，面向服务拆分而不是单机 HTTP 应用，边界比 Web 框架高一层。
- **anccnuer/onho** — Hono 风格的轻量 Web 框架，路由和中间件刚好够用。

### 数据库 / 存储（5）

- **moonbitstack/moondb** — 数据库访问的标准接口层：定义驱动与查询层的契约，本身不实现任何数据库。对应 Go 的 database/sql、Python 的 DB-API，想让上层代码不绑死某个数据库时用它。
- **oboard/morm** — 轻量 ORM：类型化查询加代码生成，支持多种数据库引擎，接口克制。
- **moonbitstack/moonorm** — ORM 与 SQL 工具包，模型映射和查询构建都在同一套里。
- **wflixu/Orion** — Derive 加代码生成的 ORM：用 Schema DSL 描述表，自动产出类型安全 CRUD 和查询构建器。
- **zen314/shadow** — 简单 ORM，接口直白，中小项目起步够用。

### 异步 / 并发（4）

- **moonbitlang/async** — 官方异步库，协程调度加 IO 抽象，生态里的默认底座，其他库大多兼容它。
- **peter-jerry-ye/async** — Promise、事件循环、IO 三件套的异步库，接口偏 JS 习惯。
- **didiLjf/moonorbit** — Actor 并发框架，用消息传递代替共享状态，适合状态多、并发写冲突多的服务。
- **kalculos/miao** — 以 libuv 为默认运行时的异步 IO 库，行为和 Node 生态最接近。

### 配置 / 标记格式（1）

- **Yu-zh/data** — serde 形态的序列化框架：一套数据模型，多种格式共用同一套序列化逻辑，换格式不用重写。

### LLM / Agent / MCP（5）

- **colmugx/posoco** — 六边形架构（端口-适配器）的 Agent 框架：定义扩展端口和 Agent 循环，LLM 供应商与工具都可替换。
- **colmugx/mcp** — 类型安全的 MCP SDK，服务端客户端都有，STDIO 和 HTTP 两种传输都支持。
- **golemcloud/golem_sdk** — Golem 平台的 SDK，用来构建可持久化、故障自恢复的 agent，代价是绑定到这个托管平台。
- **weopqrst/agent** — LangChain 核心库的 MoonBit 版：类型安全、可组合、可嵌入，LLM 客户端走 mizchi/llm。
- **soehi/moonlm** — 本地 LLM 推理引擎加强类型 agent 运行时，不依赖外部 API 也能跑模型。

## 五、工具与底层

### CLI 参数解析（4）

- **Yoorkin/ArgParser** — 最轻的一个：定义命令、选项、子命令就够用，不引入额外依赖。
- **mizchi/admiral** — 声明式 CLI 构建器（gunshi 风格），把命令结构写成数据，帮助文本和补全自动生成。
- **TheWaWaR/clap** — Rust clap 的移植，用法基本对应，写过 clap 的话迁移成本接近零。
- **totto2727/admiral** — admiral 的异步优先分支，命令处理可以直接返回异步结果。

### 运维 / 系统管理（4）

- **chensuiyi/bm2** — 给 Bun / Node.js 应用用的 Linux 进程管理器，本身用 MoonBit 写。
- **mizchi/actrun** — 兼容 GitHub Actions 的本地 CI runner，workflow 能在自己机器上跑，不必等远端。
- **kupas/pm3** — PM2 式的语言无关进程管理器，内置日志轮转，跑什么语言的进程都行。
- **tiye/redstart** — 面向本地开发的轻量进程管理器，一次起停一组服务。

### 解析器 / 语法（2）

- **moonbitlang/yacc** — 官方 LR(1) 语法分析器生成器，写文法出解析器，适合整门语言的完整语法。
- **cogna-dev/parkit** — nom 风格的解析器组合子框架，用函数组合拼解析逻辑，适合局部格式而不是整门语言。

### 测试 / 断言（4）

- **moonbitlang/quickcheck** — 官方 QuickCheck 实现：用属性描述行为，自动生成输入去找反例。
- **moonrockz/moonspec** — BDD 测试框架，支持 Gherkin 语法和 Cucumber 表达式，需求文档可以直接变成测试。
- **aspnmy/moonitest** — 集成测试框架，通过真实 Docker / TCP / HTTP 打后端接口，是单元测试的补充而不是替代。
- **Duckweed/moon-proof** — 文档示例的持续验证框架：把文档里的代码块抽出来隔离编译运行，回答「文档里的例子还都对吗」。

### WebAssembly / JS 互操作（1）

- **Milky2018/wasmoon** — WebAssembly 运行时：自带 JIT 和解释器，支持 WASI 与 Component Model，可以在 MoonBit 里加载并执行 wasm 模块。

---

以上是全部 15 个场景的完整方案，共 71 个包。其中 moui、minimoon、bunnia 三个跨场景通用，所以会在两处出现，正文条目数比包数多几条。

剩下 22 个场景没有完整方案，那里列的是按用途分好的基础库，需要的时候去站点上查就行。

## 六、最后还是公开了

这东西一开始只是给自己做的一张表。做完发现，卡在「不知道有什么」这一步的人应该不止我一个。

所以放了上来。站点是纯静态的，两边都能切语言：

**https://moonbit-ecosystem-index.pages.dev**

数据是 2026-11-02 的快照，不随注册表实时更新，之后新发布的包不在里面。分类也一定有错，尤其是我按规则砍掉的那些包，保不齐误伤。

觉得某个包该在某个场景里、或者某个包不该出现，欢迎到 GitHub 提：

**https://github.com/lb091188/moonbit-ecosystem-index**

如果你也在写 MoonBit，希望这张表能省下你翻 README 的那个下午。
