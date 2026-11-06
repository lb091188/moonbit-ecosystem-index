# JSON 解析（`json`）

*JSON Parsing*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/json>

JSON、JSON Lines、JSON5 的解析、生成与 JSON Schema 校验。

## 完整方案 · 可作骨架

**无。** 该场景没有骨架级实现，只能用基础库组合。

## 基础库 · 单点能力，自行组合

- **`moonbitlang/x`** v0.5.7 — experimental packages for moonbitlang/core
- **`moonbitlang/jsonl`** v0.2.1 — Async reader for JSON Lines (newline-delimited JSON) streams.
- **`colmugx/json-schema`** v0.1.5 — Compile-once JSON Schema 2020-12 validator for MoonBit: exact decimal arithmetic, precise pattern semantics, n…
- **`moonbitstack/moonjson`** v0.4.3 — JSON, its dialects and its binary encodings for MoonBit.
- **`moonrockz/cucumber-messages`** v0.5.0 — Cucumber Messages protocol types for MoonBit with JSON serialization and NDJSON streaming
- **`moonbitstack/moonschema`** v0.2.4 — JSON Schema validation for MoonBit, draft-04 through v1: four output formats, nineteen format names, and vocab…
- **`mizchi/jsonschema`** v0.8.1 — JSON Schema validator and code generator for MoonBit
- **`mizchi/js_builtin`** v0.13.0 — javascript built-in object bindings (Object, Array, JSON, RegExp, Symbol, Proxy, ...)
- **`moonbitstack/moonmodel`** v0.1.3 — One model description for MoonBit, projected to JSON Schema, OpenAPI, SQL and GraphQL.
- **`moonbitstack/moonapi`** v0.17.9 — A typed web framework for MoonBit.
- **`gaato/sdk-runtime`** v0.7.0 — API-agnostic client runtime for MoonBit SDKs: error taxonomy, Retry-After and backoff, tri-state JSON fields, …
- **`colmugx/acp`** v0.3.0 — Type-safe Agent Client Protocol (ACP) SDK for MoonBit.
- **`colmugx/lody`** v0.1.0 — 1:1 MoonBit mirror of the LodyAI acp-extension-core contract (tool vocabulary, _meta.lody DTOs, _lody/ methods…
- **`totto2727/agent-core-sdk`** v0.1.2 — Shared MoonBit process foundation for agent CLIs
- **`mizchi/js_convert`** v0.13.0 — MoonBit <-> JavaScript value conversion (Map/Json/Option/Result <-> Any) and runtime type inspection
- **`mizchi/jq`** v0.2.2 — A jq clone implemented in MoonBit
- **`totto2727/lens`** v0.4.3 — Typed JSON lenses, builders, and aggregate validation for MoonBit
- **`bobzhang/moonjq`** v0.2.0 — A jq implementation in MoonBit
- **`moonrockz/smithy-jsonschema`** v0.8.0 — Convert assembled Smithy models to JSON Schema
- **`moonbitstack/moonlog`** v0.1.6 — Structured logging for MoonBit.
- **`moonbitstack/moonfetch`** v0.1.5 — An HTTP client for MoonBit, synchronous or asynchronous.
- **`totto2727/agent-cli-sdk`** v0.2.1 — Shared MoonBit process foundation for JSONL agent CLIs
- **`marianoguerra/mcp`** v0.10.1 — MCP 2026-07-28 protocol types, JSON-RPC codec and SEP-2243 header validation. No dependencies.
- **`bobzhang/typify`** v0.2.1 — Generate Rust and MoonBit types from JSON Schema (port of oxidecomputer/typify)
- **`tonyfettes/tree_sitter_json`** v0.1.26 — JSON grammar for tree-sitter
- **`tiye/json5`** v0.0.3 — JSON5 parser and stringifier for MoonBit
- **`123123213weqw/moon_scrub`** v0.5.2 — Offline sensitive-data detection, redaction, JSON and streaming pipelines for MoonBit applications.
- **`bobzhang/jqlog`** v0.2.0 — Run jq-compatible filters over JSON Lines input
- **`moonrockz/jmespath`** v0.8.0 — JMESPath expressions, parsing and JSON evaluation for MoonBit
- **`oboard/jsonx`** v0.1.0 — JSON Toolkit

*其余基础库见 [json-libs.md](json-libs.md) 全量分册。*
