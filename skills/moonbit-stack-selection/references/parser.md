# 解析器 / 语法（`parser`）

*Parsers / Grammars*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/parser>

词法、语法、parser combinator、AST、tree-sitter、parser generator。

## 完整方案 · 可作骨架

1. **`moonbitlang/yacc`** v0.7.26
   官方 LR(1) 语法分析器生成器，由文法生成解析器，适用于完整语言语法的实现。
   <https://mooncakes.io/docs/moonbitlang/yacc>

2. **`cogna-dev/parkit`** v0.1.1
   nom 风格的解析器组合子框架，以函数组合构建解析逻辑，适用于局部格式解析。
   <https://mooncakes.io/docs/cogna-dev/parkit>

## 基础库 · 单点能力，自行组合

- **`moonbitlang/parser`** v0.4.7 — AST and parsers for the MoonBit programming language
- **`bobzhang/lexer`** v0.3.1 — A generic lexer library for handwritten lexers in MoonBit
- **`moonbitlang/lexer`** v0.4.4 — Lexer for the MoonBit programming language
- **`Milky2018/xml`** v0.6.1 — A document-buffered pull XML parser for MoonBit
- **`moonrockz/krueger`** v0.8.0 — Parser and parsing utilities for Elm and Elm-like dialects (e.g. Morphir) in MoonBit
- **`moonbit-community/toml`** v0.5.1 — A TOML parser implementation in MoonBit
- **`dowdiness/graphviz`** v0.1.0 — Parser, layout engine, and SVG renderer for Graphviz DOT graphs
- **`mizchi/css`** v0.7.4 — Standalone CSS parser, selector, cascade and computed-style engine for MoonBit
- **`mizchi/cst`** v0.1.10 — Concrete Syntax Tree library with Red-Green Tree pattern
- **`mizchi/markdown`** v0.8.4 — Incremental Markdown parser and compiler
- **`moonrockz/gherkin`** v0.5.1 — A Gherkin parser for MoonBit with DOM, visitor, fold, and SAX-style APIs
- **`bobzhang/html_parser`** v0.2.3 — MoonBit HTML parser and sanitizer ported from JustHTML.
- **`moonbitlang/pdflite`** v0.4.1 — Byte-oriented PDF reading, writing, and manipulation toolkit for MoonBit.
- **`kokic/talcparsec`** v0.4.0 — A fast, trait-driven parser combinator library for MoonBit with explicit backtracking and structured diagnosti…
- **`tonyfettes/tree_sitter_language`** v0.1.3 — Tree-sitter language type for MoonBit grammar bindings
- **`TheWaWaR/clap`** v0.2.6 — Command Line Argument Parser
- **`moonbitstack/moonast`** v0.2.6 — Code generation for MoonBit from annotated declarations.
- **`Milky2018/css`** v0.6.1 — CSS parser, selector, cascade, and computed-style core maintained for Milky2018/svg
- **`moonbit-community/html`** v0.2.4 — WHATWG HTML5 spec-compliant parser for MoonBit
- **`AdUhTkJm/bitviewer`** v0.1.10 — A binary parser.
- **`tiye/cirru-parser`** v0.3.0 — parser for Cirru Syntax
- **`prowk/moonsqlitefile`** v0.8.1 — Pure MoonBit read-only SQLite file format parser and inspector
- **`moonbitlang/formatter`** v0.1.6 — code prettifier for MoonBit
- **`Nanaloveyuki/parsec`** v0.1.6 — Composable, token-generic parsers for MoonBit.
- **`moonbit-community/NyaCSV`** v0.3.4 — Purr-fectly parse your CSV files with delightful simplicity!
- **`bob/lexer`** v0.1.0 — A generic lexer library for handwritten lexers in MoonBit
- **`sennenki/sexp`** v0.1.1 — A simple S-expression parser and serializer for MoonBit.
- **`marianoguerra/uri`** v0.1.3 — A generic URI/IRI handling library compliant with RFC 3986/3987, ported from the Rust crate fluent-uri.
- **`maria/csv_parser`** v0.1.0 — A robust RFC 4180 compliant CSV parser with support for custom delimiters, quoted fields, and serialization
- **`moonbit-community/sqlparser`** v0.5.2 — Extensible SQL Lexer and Parser in MoonBit

*其余基础库见 [parser-libs.md](parser-libs.md) 全量分册。*
