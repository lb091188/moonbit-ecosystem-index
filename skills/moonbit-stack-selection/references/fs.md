# 文件 / 路径 / IO（`fs`）

*Files / Paths / IO*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/fs>

文件系统访问、路径与环境变量、临时文件、通用 IO 抽象与文件监听。

## 完整方案 · 可作骨架

**无。** 该场景没有骨架级实现，只能用基础库组合。

## 基础库 · 单点能力，自行组合

- **`mizchi/tempfile`** v0.1.3 — Temporary file and directory management for MoonBit
- **`mizchi/x`** v0.6.1 — Cross-platform MoonBit compatibility facades with native delegation and accelerated JS implementations for asy…
- **`gmlewis/io`** v0.23.20 — MoonBit io: provide simplified I/O abstractions similar to Go.
- **`mizchi/fswatch`** v0.2.1 — Cross-platform filesystem watcher for MoonBit: FSEvents on macOS, inotify on Linux, polling fallback elsewhere…
- **`Kaida-Amethyst/path`** v0.1.1 — A cross-platform file path manipulation library for MoonBit, supporting both Unix and Windows platforms.
- **`BigOrangeQWQ/wasi-filesystem`** v0.2.6
- **`trkbt10/osenv`** v0.1.0 — OS environment utilities: platform detection, safe path operations, and OS-standard directory resolution (XDG/…
- **`totto2727/target-file-discovery`** v0.2.1 — Reusable target file discovery for MoonBit
- **`ZSeanYves/bufferutils`** v0.37.0 — Zero-copy shared byte buffers with high-performance synchronous, native, and async I/O for MoonBit.
- **`justjavac/glob`** v0.2.0 — A glob library for MoonBit, supporting wildcard pattern matching on file paths.
- **`riantr/moonbit_static_analysis`** v0.4.41 — Three-inspection (structural / type / behavior) static analysis for MoonBit programs, every toolchain file kin…
- **`justjavac/walkdir`** v0.1.9 — A deterministic walkdir library for MoonBit.
- **`moonbitstack/moonlog`** v0.1.6 — Structured logging for MoonBit.
- **`moonbitstack/moonquic`** v0.3.11 — QUIC transport for MoonBit.
- **`Lxxbv/glob`** v0.2.6 — 面向 MoonBit 的可复用通配符路径匹配与文件检索库，支持 Wasm、JS 与 Native 目标。
- **`mizchi/vfs`** v0.2.3 — Cross-platform virtual filesystem with pluggable backends
- **`mldong/moon-file-storage-local`** v0.1.6 — Local filesystem platform for moon-file-storage
- **`illusory0x0/path`** v0.2.0 — A cross-platform path manipulation library for MoonBit that provides robust handling of both Unix and Windows …
- **`tonyfettes/gio`** v0.2.0 — MoonBit bindings for GIO (Application, File, D-Bus, streams, sockets, etc.)
- **`marianoguerra/sos`** v0.2.1 — Simple Object Storage
- **`totto2727/x`** v0.7.0 — Focused utility collections, traits, and value types for MoonBit
- **`xingwangzhe/files_tree`** v0.1.3 — recursively builds and displays directory structures in ASCII tree format.
- **`moonrockz/directories`** v0.1.2 — Platform-specific config, cache, and data directory paths for MoonBit (XDG on Linux, conventions on macOS/Wind…
- **`i5ting/glob-watcher`** v0.1.0 — Glob-pattern file watcher for MoonBit native — debounced, queue-aware, chokidar-backed.
- **`mldong/moon-token-store-file`** v0.1.20 — File-backed TokenStore for moon-token: in-memory authority with write-through to a directory, so a restart kee…
- **`chenliyi-cly/moonfat`** v0.1.2 — FAT12/16/32 on-disk volume codec for MoonBit
- **`Ag108/moon-wasi`** v0.1.0 — Capability-aware WASI Preview 1 utilities for MoonBit
- **`peter-jerry-ye/async`** v0.2.1 — Async library: promise, event loop, i/o
- **`mldong/moon-file-storage`** v0.1.8 — File storage models, the platform and recorder ports, and the service facade
- **`kokic/uniform-path`** v0.1.6 — Cross-platform paths with consistent / separators.

*其余基础库见 [fs-libs.md](fs-libs.md) 全量分册。*
