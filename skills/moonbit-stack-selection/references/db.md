# 数据库 / 存储（`db`）

*Databases / Storage*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/db>

SQLite 绑定、ORM、KV 存储、迁移工具。

## 完整方案 · 可作骨架

1. **`moonbitstack/moondb`** v0.2.6
   数据库驱动与查询层之间的接口层，定义驱动需实现的契约，本身无依赖，不绑定具体数据库。
   <https://mooncakes.io/docs/moonbitstack/moondb>

2. **`oboard/morm`** v0.5.0
   轻量 ORM，提供类型化查询与代码生成，支持多种数据库引擎。
   <https://mooncakes.io/docs/oboard/morm>

3. **`moonbitstack/moonorm`** v0.11.7
   ORM 与 SQL 工具包，模型映射与查询构建由同一套接口提供。
   <https://mooncakes.io/docs/moonbitstack/moonorm>

4. **`wflixu/Orion`** v0.2.0
   Derive 与代码生成 ORM，以 Schema DSL 描述表结构，生成类型安全 CRUD 与查询构建器。
   <https://mooncakes.io/docs/wflixu/Orion>

5. **`zen314/shadow`** v0.1.0
   轻量 ORM，接口简单，适用于中小规模项目。
   <https://mooncakes.io/docs/zen314/shadow>

## 基础库 · 单点能力，自行组合

- **`moonbit-community/sqlite3`** v0.2.4 — A lightweight, low-level SQLite3 binding for MoonBit, providing a thin interface over the SQLite3 C API.
- **`mizchi/sqlite`** v0.3.1 — libsqlite3 bindings for MoonBit
- **`moonbit-community/proton_safe_storage`** v0.7.0 — Native OS-backed safe storage helpers for MoonBit.
- **`prowk/moonsqlitefile`** v0.8.1 — Pure MoonBit read-only SQLite file format parser and inspector
- **`f4ah6o/duckdb`** v0.8.0 — MoonBit bindings for DuckDB on native and JavaScript targets (Node.js and browser WASM backends)
- **`moonbitstack/moonsqlite`** v0.3.5 — SQLite driver for moondb/moonorm — native FFI, amalgamation vendored here (isolated).
- **`myfreess/sqlite3`** v0.1.1
- **`daqing/sqlite`** v0.4.0 — SQLite3 bindings for latest MoonBit toolchian
- **`moonbitstack/moonmysql`** v0.7.9 — Pure-MoonBit MySQL wire-protocol driver implementing @moondb.Driver — no C, like PyMySQL.
- **`moonbitstack/moonvar`** v0.2.1 — Fixed-width and variable-length integer encodings for MoonBit.
- **`moonbitstack/moonpostgres`** v0.6.9 — Pure-MoonBit PostgreSQL wire-protocol driver implementing @moondb.AsyncDriver — no C, like asyncpg.
- **`jaredzhou/moonpg`** v0.14.0 — A pure MoonBit PostgreSQL client, wire protocol from scratch.
- **`mizchi/cloudflare`** v0.1.13 — MoonBit bindings for Cloudflare Workers APIs (KV, D1, R2, Durable Objects, etc.)
- **`moonbit-community/postgres`** v0.1.3 — A secure, easy-to-use PostgreSQL client library for MoonBit with an included connection pool.
- **`mattn/postgres`** v0.10.7 — A PostgreSQL client library for MoonBit using libpq.
- **`moonbitstack/moonctl`** v0.12.7 — Project and code generator for MoonBit services.
- **`mizchi/bit_objstore`** v0.49.1 — Object storage abstraction with compare-and-swap writes (S3/R2/GCS)
- **`moonbit-community/migrate`** v0.1.5 — Database migrations for MoonBit with SQLite and PostgreSQL support.
- **`kath61105/moon_schema_plan`** v0.4.0 — Deterministic schema diff, migration planning, and destructive-change gates for MoonBit
- **`ash1day/sql`** v0.2.1 — PostgreSQL query builder for MoonBit: SQL AST and bound parameters
- **`riantr/tesseract`** v0.1.15 — Tiny multi-key JSON value database over a 4D sudoku lattice (1..215 cells per axis, 81 by default), with a SQL…
- **`jaredzhou/foxql`** v0.1.4 — Compile-time type-safe PostgreSQL SQL builder with fluent API
- **`KKKIIO/moondark_postgresql`** v0.1.0 — PostgreSQL backends for the moondark framework
- **`QYF795/regolith`** v0.5.1 — 月壤：纯 MoonBit LSM-tree 嵌入式 KV 存储（WAL + 跳表 MemTable + SSTable + 合并压缩）。
- **`mizchi/sqlc_gen_moonbit`** v0.4.0 — sqlc plugin for MoonBit
- **`PingGuoMiaoMiao/moonlsm`** v0.3.2 — Embedded LSM-tree storage engine for MoonBit
- **`kaashyapan/postgresx`** v0.2.0 — Extends moonbitlang/x types for use with moonbit-community/postgres
- **`moonbitstack/moonmodel`** v0.1.3 — One model description for MoonBit, projected to JSON Schema, OpenAPI, SQL and GraphQL.
- **`wallll-wal6/moonkv`** v0.1.3 — An append-only key-value storage engine in MoonBit based on Bitcask architecture.
- **`liuhuo23/clickhouse-driver`** v0.4.0 — 一个ClickHouse的驱动库

*其余基础库见 [db-libs.md](db-libs.md) 全量分册。*
