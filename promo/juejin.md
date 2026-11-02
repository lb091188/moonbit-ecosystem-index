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

- **moonbit-community/proton** — 基于内置浏览器渲染的桌面运行时，兼容现有前端技术栈，并提供托盘、剪贴板、全局热键等系统模块。
- **wzzc-dev/moui** — 自带渲染引擎的跨端 GUI 框架，不依赖系统 WebView，桌面与移动共用一套代码。
- **NoahLiu/native-gui** — 原生桌面 GUI 框架，一套代码生成 Windows、Linux、macOS 窗口，内置托盘、通知与快捷键。
- **vectie/lepusa** — MoonBit 原生桌面框架的研究性实现，适合作为架构参考，尚不适用于生产环境。
- **Nanaloveyuki/orbit** — 组合式桌面应用基座，原生窗口配系统 WebView，IPC 支持策略授权，附 orbit-cli 工具链。
- **lepus-apps/webview** — 以 Web 技术构建桌面应用的框架，界面层由 HTML/CSS 实现，MoonBit 负责窗口与系统调用。
- **tonyfettes/giraffe** — 基于 GTK4 的声明式 UI 框架，采用 Elm 架构与原生控件，Linux 桌面支持最完整。

### 移动端（7）

- **XiLaiTL/moobile** — Rabbita（TEA）移动端方案，一套代码输出 Android、iOS 与 Web，React Native 渲染。
- **wzzc-dev/moui** — 自带渲染引擎的跨端 GUI 框架，不依赖系统 WebView，桌面与移动共用一套代码。
- **lampclaw/minimoon** — 面向微信小程序 Skyline 渲染引擎的 UI 运行时，采用 Elm 状态机，局部状态更新具备事务性。
- **Magic486/moon-miniprogram** — 微信小程序开发框架，提供类型安全运行时、状态自动 diff、跨页 store 与声明式路由。
- **shop1111/moonohos** — HarmonyOS 原生模块框架，支持异步任务、平台模块调用与 HAR 打包。
- **lampclaw/lampo** — 面向小程序 Skyline 的 UI 框架，采用纯 Elm 风格，状态按组件隔离，不使用全局 store。
- **vectie/bunnia** — 小程序 UI 框架，采用 Rabbita 风格，通过可插拔的平台适配层支持多端。

### Web UI / 前端框架（6）

- **moonbit-community/rabbita** — 官方函数式 Web UI 框架，采用 Elm 架构（Model-Update-View），生态配套最完整。
- **mizchi/luna** — 细粒度响应式 UI 库，基于信号驱动，不使用虚拟 DOM diff，更新粒度与产物体积可控。
- **marianoguerra/tutuca** — 完整 UI 框架，集成模板语言、虚拟 DOM、组件、运行时、lint 与 CLI。
- **lampclaw/minimoon** — 面向微信小程序 Skyline 渲染引擎的 UI 运行时，采用 Elm 状态机，局部状态更新具备事务性。
- **Arcelyth/aitne** — 轻量响应式 Web 框架，运行时开销低，适用于内容型页面。
- **vectie/bunnia** — 小程序 UI 框架，采用 Rabbita 风格，通过可插拔的平台适配层支持多端。

### 终端 UI（5）

- **mizchi/tui** — 基于信号驱动的终端 UI 库，状态变更自动重绘，适用于响应式编程风格的项目。
- **moonbit-community/rabbita_tui** — 官方终端 UI 工具包，采用 Elm 架构，与 Rabbita 共享同一套组织方式。
- **Frank-III/onebit-tui** — 集成 Yoga flexbox 布局引擎的终端 UI 库，以 CSS 盒模型方式排版。
- **moonbitstack/moonetui** — 功能完备的终端 UI 工具包，含单元格缓冲、差分 ANSI 渲染、增量按键解析、五十个组件与设计系统。
- **brickfrog/pippa** — 终端 UI 框架，采用 Bubble Tea 风格与 Model-Update-View 模式，消息类型化。

### 游戏引擎 / ECS（6）

- **Milky2018/selene** — 基于 ECS 架构的游戏引擎，实体、组件与系统分层明确，适用于逻辑复杂且持续扩展的项目。
- **mizchi/kagura** — 2D 游戏引擎，参照 Ebiten 设计，提供游戏循环与精灵绘制，适用于中小规模项目。
- **sssssurf/abyssal_chord** — 卡牌对战专用引擎，内置回合、牌库与结算流程，附带命令行示例。
- **sacckey/moon8bit** — 复古风格 2D 引擎，资源以文本描述，运行时具备确定性，适用于快速迭代与自动化生成。
- **firefly/firefly** — Firefly Zero 掌机的游戏 SDK，仅面向该硬件平台，不适用于通用桌面环境。
- **sennenki/reisen** — 视觉小说引擎，以剧本、立绘与分支组织内容，不适用于通用游戏开发。

## 四、服务与数据

### Web 后端 / HTTP（13）

- **moonbitlang/moonback** — 官方 Web 后端框架，提供路由、中间件与请求响应抽象，是生态项目的常用基础。
- **mizchi/mars** — Hono 风格 Web 框架，提供 trie 路由、中间件与 SSE，可运行于原生与 Node.js。
- **oboard/mocket** — 通用 Web 框架，提供路由与中间件，接口风格接近 Express。
- **bobzhang/crescent** — Web 框架，由 MoonBit 语言作者实现，具有探索性质，宜作参考而非直接用于生产。
- **jaredzhou/pony** — 轻量 HTTP 框架与路由器，采用 Go 的 Chi 风格，适用于仅需路由与中间件的服务。
- **RabitLogic/mbit** — Gin 风格 Web 框架，API 设计与 Go 生态一致，迁移成本低。
- **moonbitstack/moonapi** — 类型化 Web 框架，路由、参数与响应均纳入类型检查，错误在编译期暴露。
- **daqing/moonway** — 全栈 Web 框架，前后端在同一工程内组织，无需拆分构建流程。
- **wflixu/Halo** — 基于 Koa 洋葱模型的中间件框架，支持结构化并发与流式响应，适用于中间件层次较多的服务。
- **kupas/express** — Express 兼容的 Web 框架，底层采用 uWebSockets，便于从 Node.js 迁移。
- **KKKIIO/moondark** — Django 风格的后端框架，基于 moonback，对工程结构有明确约定。
- **moonbitstack/moonzero** — 服务框架，面向多服务拆分而非单机 HTTP 应用，抽象层次高于 Web 框架。
- **anccnuer/onho** — Hono 风格轻量 Web 框架，提供基础的路由与中间件。

### 数据库 / 存储（5）

- **moonbitstack/moondb** — 数据库访问的标准接口层，定义驱动与查询层之间的契约，本身不实现具体数据库。用于避免上层代码绑定特定数据库。
- **oboard/morm** — 轻量 ORM，提供类型化查询与代码生成，支持多种数据库引擎。
- **moonbitstack/moonorm** — ORM 与 SQL 工具包，模型映射与查询构建由同一套接口提供。
- **wflixu/Orion** — Derive 与代码生成 ORM，以 Schema DSL 描述表结构，生成类型安全 CRUD 与查询构建器。
- **zen314/shadow** — 轻量 ORM，接口简单，适用于中小规模项目。

### 异步 / 并发（4）

- **moonbitlang/async** — 官方异步库，提供协程调度与 IO 抽象，是生态中的基础依赖。
- **peter-jerry-ye/async** — 异步库，提供 Promise、事件循环与 IO，接口风格接近 JavaScript。
- **didiLjf/moonorbit** — Actor 并发框架，以消息传递代替共享状态，适用于并发写入冲突较多的服务。
- **kalculos/miao** — 异步 IO 库，默认运行时为 libuv，行为与 Node.js 生态接近。

### 配置 / 标记格式（1）

- **Yu-zh/data** — serde 形态的序列化框架，以单一数据模型支持多种格式，切换格式无需重写序列化逻辑。

### LLM / Agent / MCP（5）

- **colmugx/posoco** — 六边形架构（端口-适配器）Agent 框架，定义扩展端口与 Agent 循环，LLM 与工具可替换。
- **colmugx/mcp** — 类型安全的 MCP SDK，同时提供服务端与客户端，支持 STDIO 与 HTTP 两种传输。
- **golemcloud/golem_sdk** — Golem 平台的 SDK，用于构建可持久化、可故障恢复的 agent，需绑定该托管平台。
- **weopqrst/agent** — LangChain 核心库的 MoonBit 实现，类型安全、可组合，LLM 客户端基于 mizchi/llm。
- **soehi/moonlm** — 本地 LLM 推理引擎与强类型 agent 运行时，无需外部 API 即可运行模型。

## 五、工具与底层

### CLI 参数解析（4）

- **Yoorkin/ArgParser** — 轻量参数解析库，支持命令、选项与子命令定义，无额外依赖。
- **mizchi/admiral** — 声明式 CLI 构建器，采用 gunshi 风格，以数据描述命令结构，自动生成帮助文本与补全。
- **TheWaWaR/clap** — Rust clap 的移植版本，接口与用法基本一致，迁移成本低。
- **totto2727/admiral** — admiral 的异步优先分支，命令处理可直接返回异步结果。

### 运维 / 系统管理（4）

- **chensuiyi/bm2** — 面向 Bun 与 Node.js 应用的 Linux 进程管理器，以 MoonBit 实现。
- **mizchi/actrun** — 兼容 GitHub Actions 的本地 CI 运行器，工作流可在本机执行，不依赖远端。
- **kupas/pm3** — 语言无关的进程管理器，参照 PM2 设计，内置日志轮转。
- **tiye/redstart** — 面向本地开发的轻量进程管理器，支持一组服务的批量启动与停止。

### 解析器 / 语法（2）

- **moonbitlang/yacc** — 官方 LR(1) 语法分析器生成器，由文法生成解析器，适用于完整语言语法的实现。
- **cogna-dev/parkit** — nom 风格的解析器组合子框架，以函数组合构建解析逻辑，适用于局部格式解析。

### 测试 / 断言（4）

- **moonbitlang/quickcheck** — 官方 QuickCheck 实现，以属性描述行为并自动生成输入查找反例。
- **moonrockz/moonspec** — BDD 测试框架，支持 Gherkin 语法与 Cucumber 表达式，可按需求描述编写可执行测试。
- **aspnmy/moonitest** — 集成测试框架，通过真实 Docker、TCP 与 HTTP 调用后端接口，作为单元测试的补充。
- **Duckweed/moon-proof** — 文档示例的持续验证框架，抽取文档中的代码块并隔离编译运行，用于确认示例是否仍然有效。

### WebAssembly / JS 互操作（1）

- **Milky2018/wasmoon** — WebAssembly 运行时，内置 JIT 与解释器，支持 WASI 与组件模型。

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
