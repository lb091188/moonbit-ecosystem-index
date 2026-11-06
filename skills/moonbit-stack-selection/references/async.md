# 异步 / 并发（`async`）

*Async / Concurrency*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/async>

async 运行时、协程、并发原语、任务调度。

## 完整方案 · 可作骨架

1. **`moonbitlang/async`** v0.22.7
   官方异步库，提供协程调度与 IO 抽象，是生态中的基础依赖。
   <https://mooncakes.io/docs/moonbitlang/async>

2. **`peter-jerry-ye/async`** v0.2.1
   异步库，提供 Promise、事件循环与 IO，接口风格接近 JavaScript。
   <https://mooncakes.io/docs/peter-jerry-ye/async>

3. **`didiLjf/moonorbit`** v0.2.1
   Actor 并发框架，以消息传递代替共享状态，适用于并发写入冲突较多的服务。
   <https://mooncakes.io/docs/didiLjf/moonorbit>

4. **`kalculos/miao`** v0.1.0-M2
   异步 IO 库，默认运行时为 libuv，行为与 Node.js 生态接近。
   <https://mooncakes.io/docs/kalculos/miao>

## 基础库 · 单点能力，自行组合

- **`mizchi/x`** v0.6.1 — Cross-platform MoonBit compatibility facades with native delegation and accelerated JS implementations for asy…
- **`moonbitlang/moonback`** v0.8.10 — A web backend framework for MoonBit
- **`colmugx/fuwaroid`** v0.4.0 — Lightweight single-writer concurrency
- **`moonbit-community/pty`** v0.4.4 — Cross-platform PTY (pseudo-terminal) spawning for MoonBit native targets, integrated with moonbitlang/async.
- **`moonbit-community/tty`** v0.6.2 — Low-level terminal primitives for MoonBit native and wasm targets: a sidecar-held controlling terminal with ra…
- **`moonbitlang/jsonl`** v0.2.1 — Async reader for JSON Lines (newline-delimited JSON) streams.
- **`moonrockz/moon-lander-logging-hosting-async`** v0.11.0 — Console and rolling file delivery for Moon-Lander logging, with bounded async sessions
- **`Nanaloveyuki/sync`** v0.7.4 — Minimal native concurrency primitives for MoonBit.
- **`mizchi/js_core`** v0.13.0 — js ffi foundation for MoonBit (Any, Promise, Nullable, target-specific interop)
- **`moonbitstack/moondb`** v0.2.6 — The standard database-access interface for MoonBit — the driver↔query-layer contract, transliterated from Go's…
- **`moonbitstack/moonfetch`** v0.1.5 — An HTTP client for MoonBit, synchronous or asynchronous.
- **`gaato/http-async`** v0.5.0 — gaato/http Transport over moonbitlang/async. Native, JS, and moonrun Wasm targets.
- **`moonbitstack/moonnet`** v0.1.10 — Networking for MoonBit: connections, listeners and dialers over TCP, TLS and QUIC.
- **`moonbitstack/moonasgi`** v0.10.6 — ASGI 3.0 for MoonBit: the interface between servers and frameworks.
- **`oboard/mio`** v0.5.4 — Best async http library for Moonbit
- **`bobzhang/crescent`** v0.11.2 — Crescent: A web framework for MoonBit.
- **`moonbitstack/moonapi`** v0.17.9 — A typed web framework for MoonBit.
- **`moonbitstack/moonmysql`** v0.7.9 — Pure-MoonBit MySQL wire-protocol driver implementing @moondb.Driver — no C, like PyMySQL.
- **`azhzx/transaction`** v0.3.0 — Software Transactional Memory for MoonBit: TVars, atomic and composable transactions, retry/or_else blocking, …
- **`moonbitstack/moonpostgres`** v0.6.9 — Pure-MoonBit PostgreSQL wire-protocol driver implementing @moondb.AsyncDriver — no C, like asyncpg.
- **`mldong/moon-token-store`** v0.1.20 — Token state storage contract for moon-token: async storage port, account-to-token reverse index, shared value …
- **`hnlyxiaobing/crescent`** v0.10.7 — Crescent: A web framework for MoonBit. Fork of hnlyxiaobing/crescent with Debug trait fix for wbtest.
- **`nuskey8/oneshot`** v0.1.0 — Async oneshot channel for MoonBit
- **`q2316367743/moonhttp`** v0.6.1 — axios 风格的 MoonBit HTTP 客户端：实例与配置合并、四种请求体形态、流式与 SSE、自动重定向
- **`marianoguerra/mcp-client`** v0.10.1 — MCP 2026-07-28 client: streamable-HTTP and stdio transports, MRTR, subscriptions and the tasks extension.
- **`marianoguerra/mcp-server-native`** v0.10.1 — Native transports for MCP 2026-07-28 servers: stdio and streamable HTTP with SSE.
- **`PaiGack/ftp`** v0.2.5 — FTP/FTPS client library for MoonBit with passive EPSV/PASV data connections, MLSD/LIST parsing, resume, direct…
- **`123123213weqw/moon_historycheck`** v0.7.0 — Bounded concurrent-history checking with verified witnesses and counterexample reduction
- **`thy1016/moonkcp`** v0.2.0 — MoonKCP — KCP 协议 MoonBit 纯实现（零 IO 零时钟纯状态机 ARQ 核心 + 会话壳 + async UDP adapter + 多会话服务端;C 参照差分对拍逐字节等价）
- **`Strangelight-Merser/async-tls`** v0.1.1 — Native TLS client with PEM mTLS identity support, derived from moonbitlang/async 0.21.3

*其余基础库见 [async-libs.md](async-libs.md) 全量分册。*
