# 开发工具 / 代码质量（`tool`）

*Dev Tooling / Code Quality*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/tool>

代码格式化、静态分析、lint、结构化搜索与重构、代码生成与脚手架。

## 完整方案 · 可作骨架

**无。** 该场景没有骨架级实现，只能用基础库组合。

## 基础库 · 单点能力，自行组合

- **`moonbitlang/formatter`** v0.1.6 — code prettifier for MoonBit
- **`riantr/moonbit_static_analysis`** v0.4.41 — Three-inspection (structural / type / behavior) static analysis for MoonBit programs, every toolchain file kin…
- **`moonbitstack/moonast`** v0.2.6 — Code generation for MoonBit from annotated declarations.
- **`moonbitlang/protobuf`** v0.2.0 — The runtime library for protobuf
- **`mizchi/codegen`** v0.2.4 — Generic code generation library with abstract IR
- **`moonbit-community/moongrep`** v0.3.10 — Experimental MoonBit structural search and taint-analysis tool
- **`golemcloud/golem_sdk_tools`** v0.6.2 — Code generation tools for the Golem SDK for MoonBit
- **`moonbitstack/moonctl`** v0.12.7 — Project and code generator for MoonBit services.
- **`Milky2018/aarch64_target`** v0.18.0 — AArch64 direct MilkIR target pipeline to native code
- **`Milky2018/x64_target`** v0.18.0 — x64 direct MilkIR target pipeline to native code
- **`Milky2018/vcode`** v0.18.0 — Target-independent native lowering, VCode, and code-object infrastructure
- **`marianoguerra/wax`** v0.4.2 — The Wax language in MoonBit: parser, formatter, type checker, and wasm/wat emitters
- **`yzfyzf12345678/moonbit-rtl`** v0.1.5 — A practical Verilog RTL parser and rule checker written in MoonBit.
- **`668xin/modbus_lint`** v0.1.2 — General-purpose Modbus point-table linter: catches duplicate register names, out-of-range and overlapping addr…
- **`moonbit-community/bashcheck`** v0.0.2 — MoonBit reimplementation of ShellCheck
- **`Milky2018/machv`** v0.12.6 — Target-neutral semantic machine IR
- **`Milky2018/milkir_machv`** v0.12.6 — MilkIR-to-MachV lowering
- **`moonbit-community/proton_codegen`** v0.7.0 — WASM code generator for typed Proton command registrars.
- **`Mr-Houjie/mbt-typeset`** v0.1.0 — 中文排版校对工具：检查并自动修复中英文间距、全角标点、术语统一等问题，提供命令行工具与可复用库。
- **`moonrockz/smithy-codegen`** v0.8.0 — Language-neutral Smithy code generation core
- **`Ridge-Lab/capnp`** v0.3.1 — Cap'n Proto serialization runtime and schema code generation for MoonBit.
- **`spectacleCase/moonhadolint`** v0.1.3 — Dockerfile parser and hadolint-style linter for MoonBit
- **`mizchi/starlint`** v0.10.1 — Opinionated moonbit linter
- **`minie135/moon-audit`** v0.5.0-dev — Static security scanner for MoonBit projects
- **`marianoguerra/wax-cli`** v0.4.2 — The wax-mb command-line tool: convert, format and check Wax source
- **`justjavac/template_codegen`** v0.1.5 — Code generator for precompiled MoonBit templates.
- **`Mairzzcllo/moonbit_sqlc_plugin`** v0.1.9 — sqlc WASM plugin ? generate type-safe MoonBit database layer from SQL queries
- **`Zhouz-z/moon_l10n`** v0.2.0 — A cross-target ICU MessageFormat subset runtime and catalog linter for MoonBit.
- **`bobzhang/typify`** v0.2.1 — Generate Rust and MoonBit types from JSON Schema (port of oxidecomputer/typify)
- **`bobzhang/cfront`** v0.4.0 — C syntax suite for meta-programming: parse C to an AST, build or transform it from MoonBit, and print it back …

*其余基础库见 [tool-libs.md](tool-libs.md) 全量分册。*
