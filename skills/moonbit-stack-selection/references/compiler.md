# 编译器 / 代码生成（`compiler`）

*Compilers / Codegen*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/compiler>

编译器、字节码与虚拟机、代码生成、类型检查、LLVM 与原生后端。

## 完整方案 · 可作骨架

**无。** 该场景没有骨架级实现，只能用基础库组合。

## 基础库 · 单点能力，自行组合

- **`Kaida-Amethyst/MoonLLVM`** v0.1.18 — Moonbit version of LLVM, A Tiny, Friendly Companion to LLVM
- **`Milky2018/aarch64_target`** v0.18.0 — AArch64 direct MilkIR target pipeline to native code
- **`Milky2018/x64_target`** v0.18.0 — x64 direct MilkIR target pipeline to native code
- **`Milky2018/vcode`** v0.18.0 — Target-independent native lowering, VCode, and code-object infrastructure
- **`dowdiness/js_engine`** v0.9.0 — Pure MoonBit cross-target embedded JavaScript engine
- **`mizchi/jsonschema`** v0.8.1 — JSON Schema validator and code generator for MoonBit
- **`moonbitlang/protobuf`** v0.2.0 — The runtime library for protobuf
- **`moonbitstack/moonast`** v0.2.6 — Code generation for MoonBit from annotated declarations.
- **`mizchi/codegen`** v0.2.4 — Generic code generation library with abstract IR
- **`Milky2018/machv`** v0.12.6 — Target-neutral semantic machine IR
- **`Kaida-Amethyst/llvm`** v0.6.2 — llvm-c binding for Moonbit with friendly API, keeps the Cpp Style.
- **`Milky2018/milkir_machv`** v0.12.6 — MilkIR-to-MachV lowering
- **`mizchi/pkl`** v0.7.0 — Pure MoonBit parser, interpreter, and typechecker experiments for Apple's Pkl language.
- **`golemcloud/golem_sdk_tools`** v0.6.2 — Code generation tools for the Golem SDK for MoonBit
- **`marianoguerra/tailwindcss`** v0.5.0 — A MoonBit implementation of the Tailwind CSS v4 compiler
- **`Milky2018/milkir`** v0.18.0 — Reusable Cranelift-like SSA intermediate representation
- **`Milky2018/regalloc`** v0.18.0 — Target-independent register allocation algorithm
- **`Milky2018/wasm_milkir`** v0.18.0 — WebAssembly dialect adapter for MilkIR extension operations
- **`Milky2018/vcode_regalloc`** v0.18.0 — Target VCode adapter for the reusable register allocator
- **`Kaida-Amethyst/MoonMIR`** v0.1.2 — Machine IR, support compile llvm module (from MoonLLVM) to different architecture machine code.
- **`marianoguerra/pure-py`** v0.12.0 — PurePy (a pure functional subset of Python 3.12): tokenizer, parser, checker and interpreter
- **`moonbitstack/moonmodel`** v0.1.3 — One model description for MoonBit, projected to JSON Schema, OpenAPI, SQL and GraphQL.
- **`marianoguerra/wax`** v0.4.2 — The Wax language in MoonBit: parser, formatter, type checker, and wasm/wat emitters
- **`marianoguerra/error-report`** v0.1.1 — Source-annotated diagnostic reports: data first, renderers second. Inspired by miette, codespan-reporting and …
- **`Milky2018/isa_target`** v0.1.0 — ISA lowering from MilkIR to MachV
- **`bobzhang/cfront`** v0.4.0 — C syntax suite for meta-programming: parse C to an AST, build or transform it from MoonBit, and print it back …
- **`moonbitlang/protoc-gen-mbt`** v0.3.0 — The Protocol Buffers compiler plugin for MoonBit
- **`ubugeeei/vapor_moon`** v0.1.1 — Vapor Moon is a MoonBit-first Single File Component compiler and tooling layer built on top of luna.mbt.
- **`moonbit-community/proton_codegen`** v0.7.0 — WASM code generator for typed Proton command registrars.
- **`Milky2018/machv_regalloc`** v0.12.6 — Target VCode adapter for the reusable register allocator

*其余基础库见 [compiler-libs.md](compiler-libs.md) 全量分册。*
