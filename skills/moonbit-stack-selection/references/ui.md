# Web 前端框架（`ui`）

*Web Frontend*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/ui>

浏览器里的 UI 框架、响应式状态、组件、布局与 CSS。

## 完整方案 · 可作骨架

1. **`moonbit-community/rabbita`** v0.17.0
   官方函数式 Web UI 框架，采用 Elm 架构（Model-Update-View），生态配套最完整。
   <https://mooncakes.io/docs/moonbit-community/rabbita>

2. **`mizchi/luna`** v0.25.2
   细粒度响应式 UI 库，基于信号驱动，不使用虚拟 DOM diff，更新粒度与产物体积可控。
   <https://mooncakes.io/docs/mizchi/luna>

3. **`marianoguerra/tutuca`** v0.57.1
   完整 UI 框架，集成模板语言、虚拟 DOM、组件、运行时、lint 与 CLI。
   <https://mooncakes.io/docs/marianoguerra/tutuca>

4. **`lampclaw/minimoon`** v0.3.2
   面向微信小程序 Skyline 渲染引擎的 UI 运行时，采用 Elm 状态机，局部状态更新具备事务性。
   <https://mooncakes.io/docs/lampclaw/minimoon>

5. **`Arcelyth/aitne`** v0.4.20
   响应式前端框架，采用细粒度更新与 JSX 风格组件语法，参照 Leptos 与 SolidJS 设计。
   <https://mooncakes.io/docs/Arcelyth/aitne>

6. **`vectie/bunnia`** v0.1.0
   小程序 UI 框架，采用 Rabbita 风格，通过可插拔的平台适配层支持多端。
   <https://mooncakes.io/docs/vectie/bunnia>

## 基础库 · 单点能力，自行组合

- **`mizchi/signals`** v0.6.6 — Fine-grained reactive signals for MoonBit (alien-signals inspired)
- **`mizchi/crater`** v0.19.0 — CSS Layout Engine that implements Box/Flex/Grid
- **`mizchi/layout`** v0.2.1 — Pure layout computation kernel: alignment, justify, clamp, axis utilities
- **`dowdiness/incr`** v0.15.1 — Salsa-inspired incremental recomputation library with automatic dependency tracking, backdating, and durabilit…
- **`mizchi/css`** v0.7.4 — Standalone CSS parser, selector, cascade and computed-style engine for MoonBit
- **`Milky2018/moon_taffy`** v0.5.3 — MoonBit port of the Rust crate taffy (v0.5.x)
- **`bobzhang/html_parser`** v0.2.3 — MoonBit HTML parser and sanitizer ported from JustHTML.
- **`mizchi/crater-dom`** v0.19.0 — DOM, HTML, AOM, and scheduling packages for crater
- **`moonbit-community/rui`** v0.5.0 — Self-contained Nova-style UI components for Rabbita
- **`mizchi/js_browser`** v0.13.0 — browser-specific js bindings (DOM, canvas, indexeddb, ...)
- **`tiye/dom-ffi`** v0.5.1 — Typed MoonBit bindings for browser DOM APIs
- **`Milky2018/css`** v0.6.1 — CSS parser, selector, cascade, and computed-style core maintained for Milky2018/svg
- **`tiye/respo_css`** v0.1.7 — Type-safe CSS styling library for Respo framework with comprehensive property definitions, enumeration values,…
- **`vicTop-cw/RX-MBT`** v0.4.0 — Rx-Rust 的 MoonBit 复刻：基于 Observer 模式的响应式编程库（Observable / Subject / Scheduler / 操作符），零外部依赖。
- **`mizchi/js_web`** v0.13.1 — web standard api bindings (fetch, Streams, Blob, URL, Crypto, ...)
- **`mizchi/luna_components`** v0.23.4 — Headless + styled UI components (WAI-ARIA APG patterns) for Luna UI
- **`Frank-III/onebit-yoga`** v0.2.6 — MoonBit bindings for Yoga Layout Engine
- **`Milky2018/chicle`** v0.6.3 — A UI layout engine for MoonBit
- **`Yoorkin/duplix`** v0.2.9 — An RC-friendly reactive graph with lazy computation and bounded retention.
- **`lampclaw/minimoon_ui`** v0.2.0 — Native, touch-first Skyline components for Minimoon, adapted from RUI.
- **`helios-house/valence`** v0.3.1 — MoonBit UI where every component is readable by humans and AI equally
- **`marianoguerra/tailwindcss`** v0.5.0 — A MoonBit implementation of the Tailwind CSS v4 compiler
- **`bikallem/webapi`** v0.5.0 — Moonbit browser WebApi - dom, fetch, html, xhr, url, svg, uievents and more
- **`chen333w/moon-element`** v0.2.0 — Web Components runtime for MoonBit, with an offscreen layout engine: the same view tree renders to custom elem…
- **`howtomakeaname/sumi`** v0.3.0 — A UI component library for MoonBit web apps — dark & light themes, overlay motion, zero config
- **`lampclaw/lampo`** v0.1.0 — A MoonBit UI runtime for WeChat MiniApp Skyline with pure Elm-style authoring, component-scoped state, and gen…
- **`conglinyizhi/precss`** v0.1.4 — A pluggable CSS preprocessor compile facade: a single function turns SCSS / LESS / CSS source (or file) into C…
- **`marianoguerra/css`** v0.1.2 — A semantic CSS syntax tree for MoonBit: a tolerant parser, a printer with pretty, compact and minified modes, …
- **`2d5rrr333/moonbridge`** v0.1.0 — The 'wasm owns state, JS is a thin shell' architecture as a reusable kit: a generic Session with an init/dispa…
- **`marianoguerra/shrubbery-css`** v0.2.1 — CSS in shrubbery notation: lower shrubbery to a CSS tree, and print a CSS tree back as shrubbery

*其余基础库见 [ui-libs.md](ui-libs.md) 全量分册。*
