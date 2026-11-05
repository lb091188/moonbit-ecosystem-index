# 桌面（`gui`）

*Desktop*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/gui>

原生桌面应用开发：窗口创建、事件循环、控件布局与渲染后端接入。Proton 的托盘、剪贴板、全局热键等配套模块不计入本表。

## 完整方案 · 可作骨架

1. **`moonbit-community/proton`** v0.7.0
   以 Web 前端构建原生桌面的框架，经 CEF 内嵌 Chromium，系统能力经扩展按权限开放。
   <https://mooncakes.io/docs/moonbit-community/proton>

2. **`wzzc-dev/moui`** v0.3.0
   自带渲染引擎的跨端 GUI 框架，不依赖系统 WebView 与系统渲染，桌面与移动共用一套代码。
   <https://mooncakes.io/docs/wzzc-dev/moui>

3. **`NoahLiu/native-gui`** v0.3.1
   原生桌面 GUI 框架，界面由系统渲染引擎绘制，一套代码生成三平台窗口，托盘、通知、快捷键、输入法、自启内置。
   <https://mooncakes.io/docs/NoahLiu/native-gui>

4. **`Nanaloveyuki/orbit`** v0.2.0-alpha.2
   组合式桌面应用基座，原生窗口配系统 WebView，IPC 支持策略授权，附 orbit-cli 工具链。
   <https://mooncakes.io/docs/Nanaloveyuki/orbit>

5. **`vectie/lepusa`** v0.1.6
   MoonBit 原生桌面框架的研究性实现，可作为架构参考。
   <https://mooncakes.io/docs/vectie/lepusa>

6. **`lepus-apps/webview`** v0.1.15
   以 Web 技术构建桌面应用的框架，界面层由 HTML/CSS 实现，MoonBit 负责窗口与系统调用。
   <https://mooncakes.io/docs/lepus-apps/webview>

7. **`tonyfettes/giraffe`** v0.2.0
   基于 GTK4 的声明式 UI 框架，采用 Elm 架构，界面由 GTK 原生控件构成。
   <https://mooncakes.io/docs/tonyfettes/giraffe>

## 基础库 · 单点能力，自行组合

- **`wzzc-dev/window`** v0.5.4-0.2.5 — The wzzc-dev fork of moonbit-community/window, tracking upstream 0.5.4 while adding MoUI-oriented desktop, Web…
- **`Milky2018/window`** v0.6.2 — A MoonBit port of winit with a native macOS event loop and windowing backend.
- **`Milky2018/windowing`** v0.1.2 — Backend-neutral raw window and display handle contracts for MoonBit.
- **`wzzc-dev/windowing`** v0.1.2 — Backend-neutral raw window and display handle contracts for MoonBit.
- **`Nanaloveyuki/moonview`** v0.1.0-beta.13 — Direct native WebView embedding for MoonBit.
- **`Nanaloveyuki/orby`** v0.1.0-beta.8 — Native MoonBit application and window host.
- **`mizchi/glfw`** v0.2.3 — GLFW MoonBit bindings (native FFI + C stub)
- **`justjavac/webview`** v0.1.10 — MoonBit bindings for webview, a tiny library for creating web-based desktop GUIs.
- **`tonyfettes/gtk`** v0.2.0 — MoonBit bindings for GTK4 widgets (Window, Button, Box, Label, etc.)
- **`justjavac/windows_subsystem`** v0.1.6 — Keep the Windows GUI subsystem linker stub alive for MoonBit native executables.
- **`moonbitstack/moonegui`** v0.2.1 — Immediate-mode graphical interfaces for MoonBit.
- **`lepus-apps/lepus`** v0.2.5 — A modern desktop application framework based on web technologies.
- **`tonyfettes/gdk`** v0.2.0 — MoonBit bindings for GDK4 (Display, Clipboard, Cursor, etc.)
- **`KingBes/webui`** v0.0.4 — 🚀 moon 绑 定 webui 库。
- **`f4ah6o/gpui`** v0.10.6 — An independent MoonBit implementation of the GPUI programming model.
- **`wzzc-dev/moui_webview`** v0.3.0 — WebView platform view addon for MoUI: wraps platform-native WebView backends (WKWebView, WebKitGTK, WebView2) …
- **`shiguri-01/webview`** v0.1.1 — Low-level MoonBit bindings to webview/webview
- **`justjavac/dialog`** v0.1.4 — Native-only message dialogs for MoonBit on Windows, macOS, and Linux.
- **`tonyfettes/adw`** v0.2.0 — MoonBit bindings for libadwaita (Adw) widgets
- **`NoahLiu/yoga-mbt`** v0.1.1 — 纯 MoonBit 的 Flexbox 布局引擎：只对齐 Web Flexbox 标准（CSS Flexible Box Layout），为 native-gui 的 MoonBit 化提供布局层
- **`LING71671/moon-egui`** v0.6.0 — High-performance, pure MoonBit Immediate-Mode GUI library for WebAssembly, Canvas, and Games.
- **`tonyfettes/vte`** v0.2.0 — MoonBit bindings for VTE terminal emulator widget (GTK4)
- **`KeqingMoe/qt`** v0.5.2 — Qt MoonBit Binding
- **`illusory0x0/qpainter`** v0.3.1 — Moonbit FFI Bindings for Qt's QPainter
- **`wzzc-dev/imgui`** v0.1.0 — Moonbit binding for Dear ImGui library - A simple GUI example
- **`WilliamZ1008/qt-gui`** v0.1.1
- **`NoahLiu/gui-webview`** v0.2.0 — native-gui 的 WebView 扩展（独立模块，G9 Batch 1）：WebView2 + WebKitGTK 双后端，vendor 资产与链接参数由本模块 prebuild 自管，对主模块消费者保持「模块级…
- **`Mr-Houjie/mbt-diffview`** v0.1.0 — 文本 Diff 查看器：行级/词级差异、左右对照、统一补丁导出，附 CLI 与 Web GUI。
- **`Mr-Houjie/mbt-subtitle`** v0.1.0 — SRT / WebVTT 字幕工具：解析、序列化、整体平移与缩放、重叠检查，附 CLI 与 Web GUI。
- **`NoahLiu/gui-media`** v0.2.0 — native-gui 的媒体扩展（独立模块，媒体因此对主模块消费者保持「模块级可选」）：media/ 是新栈引擎（ffmpeg 解码 + miniaudio 设备直出），src/ 是旧链声明式播放器组件（待示例迁移完成后…
