# 终端 / TUI（`tui`）

*Terminal / TUI*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/tui>

终端界面、字符画布、ANSI 控制、PTY。

## 完整方案 · 可作骨架

1. **`mizchi/tui`** v0.10.2
   基于信号驱动的终端 UI 库，状态变更自动重绘，适用于响应式编程风格的项目。
   <https://mooncakes.io/docs/mizchi/tui>

2. **`moonbit-community/rabbita_tui`** v0.1.3
   官方终端 UI 工具包，采用 Elm 架构，与 Rabbita 共享同一套组织方式。
   <https://mooncakes.io/docs/moonbit-community/rabbita_tui>

3. **`moonbitstack/moonetui`** v0.3.2
   功能完备的终端 UI 工具包，含单元格缓冲、差分 ANSI 渲染、增量按键解析、五十个组件与设计系统。
   <https://mooncakes.io/docs/moonbitstack/moonetui>

4. **`Frank-III/onebit-tui`** v0.1.3
   集成 Yoga flexbox 布局引擎的终端 UI 库，以 CSS 盒模型方式排版。
   <https://mooncakes.io/docs/Frank-III/onebit-tui>

5. **`brickfrog/pippa`** v0.1.0
   终端 UI 框架，采用 Bubble Tea 风格与 Model-Update-View 模式，消息类型化。
   <https://mooncakes.io/docs/brickfrog/pippa>

## 基础库 · 单点能力，自行组合

- **`moonbit-community/tty`** v0.6.2 — Low-level terminal primitives for MoonBit native and wasm targets: a sidecar-held controlling terminal with ra…
- **`moonbit-community/displaytext`** v0.1.7 — Grapheme-aware display-cell text boundaries for terminal UIs.
- **`moonbit-community/pty`** v0.4.4 — Cross-platform PTY (pseudo-terminal) spawning for MoonBit native targets, integrated with moonbitlang/async.
- **`mizchi/tui-terminal-buffer`** v0.1.4 — Terminal character buffer primitives for MoonBit TUI renderers
- **`mizchi/tui-terminal-protocol`** v0.1.2 — Terminal graphics protocol encoders for tui.mbt
- **`mizchi/crater-terminal-protocol`** v0.19.0 — Terminal graphics protocol encoders for crater
- **`sennenki/pretty_prompt`** v0.1.2 — A pretty prompt library for Moonbit, providing an easy way to create interactive command-line interfaces with …
- **`cg-zhou/drawille`** v0.1.2 — MoonBit port of drawille for terminal graphics with Unicode Braille characters
- **`hustcer/tabular`** v0.6.0 — A MoonBit library for pretty-printing tables in terminal. Ported from Rust tabled.
- **`FrozenLemonTee/LunarTUI`** v0.1.0 — A TUIs package written in MoonBit
- **`FrozenLemonTee/TerminalEvent`** v0.1.0 — C++ terminal event backend with a stable C FFI surface
- **`moonbitlang/openseek_tui`** v0.7.5 — OpenSeek interactive terminal UI: the openseek_tui binary
- **`FrozenLemonTee/LunarEvent`** v0.1.1 — MoonBit terminal event API backed by TerminalEvent C FFI
- **`xingwangzhe/style_print`** v0.1.7 — ANSI terminal styling: colors & text styles (truecolor).
- **`justjavac/terminal_size`** v0.1.7 — Cross-platform terminal size helpers for MoonBit.
- **`chensuiyi/clicolor`** v0.2.0 — Terminal color and hyperlink escape sequences for MoonBit
- **`wzzc-dev/moui_tui`** v0.3.0 — Terminal cell model: colors, attributes, rows and a damage-tracked screen buffer
- **`wzzc-dev/moui_tui_renderer`** v0.3.0 — Experimental terminal cell renderer: projects MoUI semantics frames into ANSI text
- **`FrozenLemonTee/TextEditor`** v0.1.1 — Demo app for LunarEvent and LunarTUI event loop integration
- **`wzzc-dev/moui_terminal_host`** v0.3.0 — Experimental terminal host: raw-mode TTY input channels for the MoUI TUI renderer
- **`zkazure/moonfocus`** v0.1.1 — A Pomodoro timer and habit tracker with a lightweight TUI rendering engine and web console, written in MoonBit…
- **`bobzhang/rich`** v0.1.2 — A port of Rich (rich text and beautiful formatting in the terminal) to MoonBit
- **`CGaaaaaa/MoonProgress`** v0.1.0 — A configurable command-line progress bar library for MoonBit
- **`Yu-zh/termbit`** v0.1.1 — A terminal manipulation library written in MoonBit
- **`xrr2016/tui-ansi`** v0.1.2
- **`sennenki/console`** v0.1.4 — Cross-platform console I/O library
- **`R00TK17/hex_editor`** v0.1.3 — Terminal hex editor & binary analysis toolkit: 20 format parsers, wildcard search, entropy analysis, steganogr…
- **`DWS-ai-nb/termproof`** v0.1.1 — Streaming ANSI/ECMA-48 terminal log sanitizer and security auditor for MoonBit
- **`grandEarshot/tui`** v0.1.0 — A terminal user interface library for MoonBit inspired by Bubble Tea.
- **`SongYZZZ/ansi-guard`** v0.1.0 — Audit and sanitize untrusted ANSI terminal output in pure MoonBit

*其余基础库见 [tui-libs.md](tui-libs.md) 全量分册。*
