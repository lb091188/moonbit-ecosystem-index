# HTTP 客户端（`httpc`）

*HTTP Clients*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/httpc>

发起 HTTP 请求：请求构造、连接复用、重定向、SSE 流式读取。

## 完整方案 · 可作骨架

**无。** 该场景没有骨架级实现，只能用基础库组合。

## 基础库 · 单点能力，自行组合

- **`moonbitstack/moonfetch`** v0.1.5 — An HTTP client for MoonBit, synchronous or asynchronous.
- **`gaato/http`** v0.5.0 — Sans-IO HTTP vocabulary for MoonBit SDKs: request/response types, a Transport trait, Retry-After and Link pars…
- **`gaato/http-async`** v0.5.0 — gaato/http Transport over moonbitlang/async. Native, JS, and moonrun Wasm targets.
- **`q2316367743/moonhttp`** v0.6.1 — axios 风格的 MoonBit HTTP 客户端：实例与配置合并、四种请求体形态、流式与 SSE、自动重定向
- **`moonbitstack/moonnet`** v0.1.10 — Networking for MoonBit: connections, listeners and dialers over TCP, TLS and QUIC.
- **`DC-Z-lab/moonllm`** v0.1.0 — Type-safe, OpenAI-compatible LLM client for MoonBit: chat completions, streaming (SSE), tool calling, and mult…
- **`moonbitstack/moonquic`** v0.3.11 — QUIC transport for MoonBit.
- **`gaato/requesto`** v0.2.2 — A human-facing async HTTP client for MoonBit: verb functions, a client with defaults, body encoders, responses…
- **`SundayT1998/chroma-client`** v0.1.1 — A Chroma vector database HTTP client for MoonBit: collections, records, queries and embeddings.
- **`marianoguerra/mcp-client`** v0.10.1 — MCP 2026-07-28 client: streamable-HTTP and stdio transports, MRTR, subscriptions and the tasks extension.
- **`q2316367743/webdav`** v0.1.0 — MoonBit WebDAV 客户端：文件上传/下载（流式+进度）、目录、移动/复制、PROPFIND/PROPPATCH。
- **`marianoguerra/slack-http`** v0.4.3 — Native HTTP transport for marianoguerra/slack, over moonbitlang/async. Implements @api.Transport; native targe…
- **`Atman-Angle/oas2moon_runtime`** v0.1.0 — Runtime request, response, encoding, auth, and transport boundary for oas2moon clients.
- **`marianoguerra/exa`** v0.1.4 — MoonBit client for the Exa search API
- **`q2316367743/open-list`** v0.1.0 — OpenList API 的 MoonBit 客户端：认证、用户、管理、文件系统、公开接口与分享六个子模块
- **`Rz-coder8848/moon-neo4j`** v0.1.0 — A pure-MoonBit Neo4j client: Bolt protocol, PackStream codec, HTTP transactional endpoint, and a typed Cypher …
