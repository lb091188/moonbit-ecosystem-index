# WebAssembly / JS 互操作（`wasm`）

*WebAssembly / JS Interop*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/wasm>

Wasm 组件模型、WASI、FFI、JS 绑定。

## 完整方案 · 可作骨架

1. **`Milky2018/wasmoon`** v0.18.0
   WebAssembly 运行时，内置 JIT 与解释器，支持 WASI 与组件模型。
   <https://mooncakes.io/docs/Milky2018/wasmoon>

## 基础库 · 单点能力，自行组合

- **`mizchi/mwac`** v0.2.2 — WAC (WebAssembly Compositions) composer for the Component Model
- **`mizchi/wite`** v0.11.3 — Component-model-aware WebAssembly analyzer, optimizer, and profiler
- **`mizchi/oci_wasm`** v0.5.1 — WebAssembly package registry client
- **`mizchi/x`** v0.6.1 — Cross-platform MoonBit compatibility facades with native delegation and accelerated JS implementations for asy…
- **`mizchi/wit`** v0.3.3 — WIT parser and resolver in MoonBit
- **`mizchi/js`** v0.13.0 — js bindings for MoonBit: re-exports mizchi/js_core + mizchi/js_builtin (web/node/browser/deno/bun split into m…
- **`moonbit-community/proton_ffi`** v0.7.0 — MoonBit Foreign Function Interface.
- **`justjavac/ffi`** v0.2.6 — MoonBit Foreign Function Interface.
- **`Milky2018/wasm_core`** v0.18.0 — Reusable WebAssembly specification model for parsers, validators, and frontends
- **`mizchi/npm_typed`** v0.1.18 — Typed npm library bindings(40+) for js backend
- **`Milky2018/wasm_component`** v0.18.0 — Portable WebAssembly Component Model syntax and validation
- **`moonrockz/extism`** v0.1.1 — An Extism host for MoonBit: a WASM engine layer, the Extism kernel and a plugin API
- **`mizchi/libgit2`** v0.1.0 — MoonBit bindings for libgit2 - Git operations from MoonBit
- **`mizchi/ts`** v0.6.0 — TypeScript <-> MoonBit bridge generator
- **`mizchi/v8`** v0.3.0 — MoonBit bindings for V8 aimed at prototyping MoonBit-first runtimes in the style of Node or Deno.
- **`mizchi/simd`** v0.6.1 — SIMD primitives for MoonBit across wasm / wasm-gc / native / js — @simdcore, @simd_buffer, codecs, hashes, ima…
- **`f4ah6o/duckdb`** v0.8.0 — MoonBit bindings for DuckDB on native and JavaScript targets (Node.js and browser WASM backends)
- **`mizchi/wasmx`** v0.1.1 — Experimental fork of moonbitlang/wasm5. WebAssembly VM built with pure MoonBit.
- **`Milky2018/wasm_milkir`** v0.18.0 — WebAssembly dialect adapter for MilkIR extension operations
- **`golemcloud/golem_sdk`** v0.6.2 — Golem SDK for MoonBit — build durable, fault-tolerant agents on the Golem platform
- **`golemcloud/golem_sdk_tools`** v0.6.2 — Code generation tools for the Golem SDK for MoonBit
- **`dowdiness/js_engine`** v0.9.0 — Pure MoonBit cross-target embedded JavaScript engine
- **`Nanaloveyuki/dynlib`** v0.2.3 — Checked dynamic library loading for MoonBit native targets.
- **`marianoguerra/wax`** v0.4.2 — The Wax language in MoonBit: parser, formatter, type checker, and wasm/wat emitters
- **`tiye/dom-ffi`** v0.5.1 — Typed MoonBit bindings for browser DOM APIs
- **`rami3l/js-ffi`** v0.4.0
- **`daqing/sqlite`** v0.4.0 — SQLite3 bindings for latest MoonBit toolchian
- **`mizchi/glfw`** v0.2.3 — GLFW MoonBit bindings (native FFI + C stub)
- **`mizchi/js_core`** v0.13.0 — js ffi foundation for MoonBit (Any, Promise, Nullable, target-specific interop)
- **`moonbit-community/evol-minifier`** v0.3.1 — A slightly faster JavaScript mangler/compressor for MoonBit.

*其余基础库见 [wasm-libs.md](wasm-libs.md) 全量分册。*
