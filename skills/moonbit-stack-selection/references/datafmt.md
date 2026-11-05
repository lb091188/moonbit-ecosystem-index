# 配置 / 标记格式（`datafmt`）

*Config / Markup Formats*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/datafmt>

YAML、TOML、XML、CSV、INI、Ion 等配置与标记语言的解析与生成。

## 完整方案 · 可作骨架

1. **`Yu-zh/data`** v0.2.1
   serde 形态的序列化框架，以单一数据模型支持多种格式，切换格式无需重写序列化逻辑。
   <https://mooncakes.io/docs/Yu-zh/data>

## 基础库 · 单点能力，自行组合

- **`moonbit-community/yaml`** v0.0.8 — A simple YAML parsing and stringifying library for MoonBit, support a simplified YAML subset which can be conv…
- **`moonrockz/ion`** v0.7.0 — A MoonBit implementation of the Amazon Ion data format and Ion Schema.
- **`Milky2018/xml`** v0.6.1 — A document-buffered pull XML parser for MoonBit
- **`moonbit-community/toml`** v0.5.1 — A TOML parser implementation in MoonBit
- **`moonbit-community/NyaCSV`** v0.3.4 — Purr-fectly parse your CSV files with delightful simplicity!
- **`moonbitstack/moonyaml`** v0.1.4 — YAML 1.0, 1.1 and 1.2 for MoonBit.
- **`xunyoyo/NyaCSV`** v0.3.3 — Purr-fectly parse your CSV files with delightful simplicity!
- **`maria/csv_parser`** v0.1.0 — A robust RFC 4180 compliant CSV parser with support for custom delimiters, quoted fields, and serialization
- **`MuVirus/moonfig`** v0.1.8 — MoonBit 原生配置库：一处声明，多来源汇入。
- **`Ljh684/MoonParse`** v0.1.4 — MoonBit 解析器组合子库 — 与生态中其他 combinator 不同：(1)内置完整 JSON 解析器（JsonValue 枚举+双向序列化）和 TOML 解析器，开箱即用；(2)支持二进制解析（u8-u64/L…
- **`moonbitstack/moontoml`** v0.1.1 — TOML for MoonBit, 1.0.0 and earlier.
- **`ZSeanYves/doc_parser`** v0.1.1 — MoonBit-native document structure foundation for source-native parsing, inspect, validation, and custom toolin…
- **`ppyj663/moonbit-robot-vision-formats`** v0.3.1 — Offline robotics vision format bridge for image timestamps, camera calibration, trajectories, depth metadata a…
- **`R00TK17/moonreader`** v0.1.3 — MoonReader — 纯 MoonBit 实现的文件内容读取库（TXT / CSV / JSON / JSONL / XML / Markdown / ZIP / TAR / DOCX / XLSX / PPTX /…
- **`bob/toml`** v0.1.6 — A TOML parser implementation in MoonBit
- **`moonbitstack/moonconf`** v0.1.3 — Configuration files, their expansion, their layering and their binding to a typed model.
- **`tonyfettes/tree_sitter_yaml`** v0.1.26 — YAML grammar for tree-sitter
- **`crh12354/moonconfigkit`** v0.1.1 — MoonConfigKit is a MoonBit-native INI/properties configuration merge, validation, diagnostics, and reporting t…
- **`hnlyxiaobing/toml`** v0.4.9 — A TOML parser implementation in MoonBit (fork of bobzhang/toml with array-of-tables fix)
- **`moonbit-community/XMLParser`** v0.2.7 — An XML parsing library written in MoonBit that converts XML strings into structured data, supporting elements,…
- **`Milky2018/pptz`** v0.7.1 — PowerPoint Zero: a portable MoonBit PPTX generator driven by YAML deck and page sources.
- **`conglinyizhi/toml`** v0.1.0 — Nightly-compatible TOML parser for MoonBit, maintained from moonbit-community/toml-parser
- **`ihb2032/MoonFrame`** v0.8.1 — A lightweight DataFrame and tabular-data library for MoonBit
- **`superbigcup325/moonlake`** v0.6.4 — Embeddable analytical query engine for MoonBit: run SQL over CSV/Parquet files, native and WebAssembly from on…
- **`moonrockz/partiql-value`** v0.3.0 — The PartiQL data model for MoonBit, with PartiQL-encoded Ion, JSON and YAML input codecs.
- **`ingydotnet/yamlscript`** v0.3.7 — YAMLScript loader binding for MoonBit
- **`sundaysebasidian-byte/moonods`** v0.5.0 — Typed OpenDocument spreadsheet (.ods) reader and writer with bounded, deterministic packages
- **`ruifeng/XMLParser`** v0.2.6 — An XML parsing library written in MoonBit that converts XML strings into structured data, supporting elements,…
- **`ingydotnet/yamlstar`** v0.1.28 — YAMLStar loader binding for MoonBit
- **`moonbit-community/ini`** v0.2.3 — High-performance INI parser for MoonBit with nested section support.

*其余基础库见 [datafmt-libs.md](datafmt-libs.md) 全量分册。*
