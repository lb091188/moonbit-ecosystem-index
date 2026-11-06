# 测试 / 断言 / 属性测试（`test`）

*Testing / Assertions / Property Testing*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/test>

单元测试、属性测试（quickcheck）、断言库、BDD、基准。

## 完整方案 · 可作骨架

1. **`moonbitlang/quickcheck`** v0.15.1
   官方 QuickCheck 实现，以属性描述行为并自动生成输入查找反例。
   <https://mooncakes.io/docs/moonbitlang/quickcheck>

2. **`moonrockz/moonspec`** v0.11.0
   BDD 测试框架，支持 Gherkin 语法与 Cucumber 表达式，可按需求描述编写可执行测试。
   <https://mooncakes.io/docs/moonrockz/moonspec>

3. **`aspnmy/moonitest`** v0.2.1
   集成测试框架，通过真实 Docker、TCP 与 HTTP 调用后端接口，作为单元测试的补充。
   <https://mooncakes.io/docs/aspnmy/moonitest>

4. **`Duckweed/moon-proof`** v0.1.3
   文档示例的持续验证框架，抽取文档中的代码块并隔离编译运行，用于确认示例是否仍然有效。
   <https://mooncakes.io/docs/Duckweed/moon-proof>

## 基础库 · 单点能力，自行组合

- **`moonrockz/expect`** v0.6.1 — A fluent assertion library for MoonBit
- **`moonrockz/cucumber-expressions`** v0.6.1 — Cucumber Expressions parser and matcher for MoonBit
- **`moonrockz/gherkin`** v0.5.1 — A Gherkin parser for MoonBit with DOM, visitor, fold, and SAX-style APIs
- **`moonrockz/cucumber-messages`** v0.5.0 — Cucumber Messages protocol types for MoonBit with JSON serialization and NDJSON streaming
- **`moonbit-community/fuzzy_match`** v0.2.6 — A library for fuzzy string matching and fuzzy string searching
- **`moonbitstack/moonasgi`** v0.10.6 — ASGI 3.0 for MoonBit: the interface between servers and frameworks.
- **`CAIMEOX/qc_pyext`** v0.1.1 — QuickCheck and reference testing extension for Python programs
- **`f4ah6o/turtles`** v0.4.7 — Mutation testing for MoonBit projects
- **`zhangbowen2006/moonbit-target-parity`** v0.5.1 — Reusable cross-target behavior contract comparison for MoonBit programs.
- **`CaptainK-65/moon-statelens`** v0.5.0 — Active black-box Mealy model learning and replay-confirmed behavioral compatibility checks.
- **`Han-Wentao/mooncontract`** v0.1.1 — MoonBit-native OpenAPI contract validation and deterministic mock toolkit
- **`xziheng/testcontainers`** v0.1.0 — Throwaway Docker containers for MoonBit integration tests
- **`moonbit-community/quickcheck_statemachine`** v0.0.1
- **`CAIMEOX/quickcheck`** v0.6.9 — Automatic testing of MoonBit programs
- **`weopqrst/mooncassette`** v0.10.0 — Deterministic record-and-replay (cassette) for LLM interactions: write offline, reproducible, drift-detecting …
- **`Magic486/moon_mutest`** v0.1.7 — Mutation testing toolkit for MoonBit projects
- **`erzhuzi259/moongrammata`** v0.1.1 — Structure-aware feedback-guided fuzzing toolkit for MoonBit
- **`CCllff-jpg/cldr-conformance`** v0.1.3 — CLDR conformance benchmark and differential tester for MoonBit i18n implementations
- **`2515050242/moonagentcheck`** v0.3.0
- **`chenqi-arch/moonbit-project`** v0.3.2 — MoonBit HTTP recording, replay, response contract validation, and offline testing library
- **`LL728/moonseal`** v0.1.6 — MoonBit test adequacy and release quality gate toolkit.
- **`Luna-Flow/mare_mark`** v0.4.1 — Reproducible benchmarking, statistical comparison, tuning, and self-contained reports for MoonBit payloads.
- **`zxch3n/expect`** v0.6.2 — `expect` is used to create various assertions easily
- **`ryota0624/moonbit_test_containers`** v0.0.5 — Test containers implementation for MoonBit
- **`123123213weqw/moon_historycheck`** v0.7.0 — Bounded concurrent-history checking with verified witnesses and counterexample reduction
- **`illusory0x0/inspect`** v0.1.1 — A powerful quotation meta programming library that hacks MoonBit's snapshot test system, allowing you to custo…
- **`liu666789987/moonbtkit`** v0.1.6 — Serializable behavior-tree assets, deterministic execution, and regression analysis for MoonBit.
- **`tonyfettes/assert`** v0.1.0
- **`2d5rrr333/moonwebtest`** v0.1.0 — Test toolkit for MoonBit wasm-gc web apps: a Node harness that drives your wasm exports over the JSON bridge, …
- **`Ag108/MoonReduce`** v0.2.0 — Deterministic failure-preserving testcase reduction for MoonBit projects

*其余基础库见 [test-libs.md](test-libs.md) 全量分册。*
