# 移动端（`mobi`）

*Mobile*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/mobi>

Android、iOS、HarmonyOS 与微信小程序上的应用开发。生态中尚无统一的移动端关键词信号，候选清单为人工圈定，涵盖全平台 UI 框架、小程序运行时与组件库、原生桥接、小程序宿主。

## 完整方案 · 可作骨架

1. **`XiLaiTL/moobile`** v0.6.0
   Rabbita（TEA）移动端方案，一套代码输出 Android、iOS 与 Web，React Native 渲染。
   <https://mooncakes.io/docs/XiLaiTL/moobile>

2. **`wzzc-dev/moui`** v0.3.0
   自带渲染引擎的跨端 GUI 框架，不依赖系统 WebView 与系统渲染，桌面与移动共用一套代码。
   <https://mooncakes.io/docs/wzzc-dev/moui>

3. **`lampclaw/minimoon`** v0.3.2
   面向微信小程序 Skyline 渲染引擎的 UI 运行时，采用 Elm 状态机，局部状态更新具备事务性。
   <https://mooncakes.io/docs/lampclaw/minimoon>

4. **`Magic486/moon-miniprogram`** v0.6.1
   微信小程序开发框架，提供类型安全运行时、状态自动 diff、跨页 store 与声明式路由。
   <https://mooncakes.io/docs/Magic486/moon-miniprogram>

5. **`shop1111/moonohos`** v0.6.0
   HarmonyOS 原生模块框架，支持异步任务、平台模块调用与 HAR 打包。
   <https://mooncakes.io/docs/shop1111/moonohos>

6. **`lampclaw/lampo`** v0.1.0
   面向小程序 Skyline 的 UI 框架，采用纯 Elm 风格，状态按组件隔离，不使用全局 store。
   <https://mooncakes.io/docs/lampclaw/lampo>

7. **`vectie/bunnia`** v0.1.0
   小程序 UI 框架，采用 Rabbita 风格，通过可插拔的平台适配层支持多端。
   <https://mooncakes.io/docs/vectie/bunnia>

## 基础库 · 单点能力，自行组合

- **`wzzc-dev/window`** v0.5.4-0.2.5 — The wzzc-dev fork of moonbit-community/window, tracking upstream 0.5.4 while adding MoUI-oriented desktop, Web…
- **`Nanaloveyuki/ajni`** v0.3.6 — Checked bidirectional Java/MoonBit JNI runtime and Android host bridge.
- **`Nanaloveyuki/moonview`** v0.1.0-beta.13 — Direct native WebView embedding for MoonBit.
- **`lampclaw/minimoon_ui`** v0.2.0 — Native, touch-first Skyline components for Minimoon, adapted from RUI.
- **`shop1111/moonohos_ohos`** v0.6.0 — HarmonyOS platform packages (HiLog, RawFile, task cancellation, device info, network state, vibrator) for Moon…
- **`Nanaloveyuki/madk`** v0.1.0 — Transport-independent Android Open Accessory protocol support for MoonBit.
- **`Nanaloveyuki/wasee-moon`** v0.1.0 — Android WASI host integration for MoonBit guests.
- **`wzzc-dev/moui_cli`** v0.3.1 — Standalone project generator and environment doctor for MoUI
