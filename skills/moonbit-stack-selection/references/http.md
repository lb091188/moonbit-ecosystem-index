# Web 后端 / HTTP 服务（`http`）

*Web Backends / HTTP Servers*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/http>

HTTP 服务、路由、中间件与后端 API 开发。

## 完整方案 · 可作骨架

1. **`moonbitlang/moonback`** v0.8.10
   官方 Web 后端框架，提供路由、中间件与请求响应抽象，是生态项目的常用基础。
   <https://mooncakes.io/docs/moonbitlang/moonback>

2. **`mizchi/mars`** v0.3.13
   Hono 风格 Web 框架，提供 trie 路由、中间件与 SSE，可运行于原生与 Node.js。
   <https://mooncakes.io/docs/mizchi/mars>

3. **`oboard/mocket`** v0.10.2
   Web 框架，提供路由与应用入口，可运行于 js、wasm 与 native 三种后端。
   <https://mooncakes.io/docs/oboard/mocket>

4. **`moonbitstack/moonapi`** v0.17.9
   类型化 Web 框架，由类型化路由构建服务端并生成 OpenAPI 文档，可编译为原生或 wasm。
   <https://mooncakes.io/docs/moonbitstack/moonapi>

5. **`bobzhang/crescent`** v0.11.2
   mocket 的硬分叉，类型安全实现，目标 native 与 wasm，不支持 JS 与 wasm-gc。
   <https://mooncakes.io/docs/bobzhang/crescent>

6. **`moonbitstack/moonzero`** v0.14.6
   服务框架，面向服务化场景，与 Web 框架定位不同。
   <https://mooncakes.io/docs/moonbitstack/moonzero>

7. **`daqing/moonway`** v0.11.9
   全栈 Web 框架，前后端在同一工程内组织，无需拆分构建流程。
   <https://mooncakes.io/docs/daqing/moonway>

8. **`jaredzhou/pony`** v0.5.0
   轻量 HTTP 框架与路由器，采用 Go 的 Chi 风格，适用于仅需路由与中间件的服务。
   <https://mooncakes.io/docs/jaredzhou/pony>

9. **`KKKIIO/moondark`** v0.1.1
   Django 风格的后端框架，基于 moonback，对工程结构有明确约定。
   <https://mooncakes.io/docs/KKKIIO/moondark>

10. **`RabitLogic/mbit`** v0.3.0
   Gin 风格 Web 框架，API 设计与 Go 生态一致，迁移成本低。
   <https://mooncakes.io/docs/RabitLogic/mbit>

11. **`kupas/express`** v0.4.0
   Express 兼容的 Web 框架，底层采用 uWebSockets，便于从 Node.js 迁移。
   <https://mooncakes.io/docs/kupas/express>

12. **`wflixu/Halo`** v0.6.0
   基于 Koa 洋葱模型的中间件框架，支持结构化并发与流式响应，适用于中间件层次较多的服务。
   <https://mooncakes.io/docs/wflixu/Halo>

13. **`anccnuer/onho`** v0.3.0
   Hono 风格轻量 Web 框架，提供基础的路由与中间件。
   <https://mooncakes.io/docs/anccnuer/onho>

## 基础库 · 单点能力，自行组合

- **`moonbitstack/moonasgi`** v0.10.6 — ASGI 3.0 for MoonBit: the interface between servers and frameworks.
- **`ShellWen/sw_router`** v0.2.0 — A fast and flexible URL router implementation for the MoonBit language.
- **`mizchi/crater-browser-http`** v0.19.0 — HTTP, cache, cookie, and request sandbox helpers for crater browser
- **`moonbitstack/moonhttp`** v0.15.8 — HTTP formats for MoonBit with no I/O: HTTP/1 to HTTP/3, WebSocket, SSE and multipart.
- **`moonbitstack/moontls`** v0.9.14 — TLS 1.3 and DTLS 1.3 for MoonBit.
- **`mldong/moon-token-moonback`** v0.1.20 — moonback adapter for moon-token: per-route authentication middleware, request principal in context, route perm…
- **`gaato/sdk-runtime`** v0.7.0 — API-agnostic client runtime for MoonBit SDKs: error taxonomy, Retry-After and backoff, tri-state JSON fields, …
- **`moonbitstack/moonrpc`** v0.21.12 — gRPC for MoonBit.
- **`hnlyxiaobing/crescent`** v0.10.7 — Crescent: A web framework for MoonBit. Fork of hnlyxiaobing/crescent with Debug trait fix for wbtest.
- **`oboard/mio`** v0.5.4 — Best async http library for Moonbit
- **`moonbitstack/mooncat`** v0.19.5 — A native ASGI server for MoonBit.
- **`mizchi/astra`** v0.23.4 — Mountable Mars middleware for static site generation
- **`mldong/moon-hutool`** v0.1.8 — Hutool-style utility library for MoonBit: all packages depend only on moonbitlang/core (no FFI, fully synchron…
- **`vicoproplus/moon_ua_parser_middleware_core`** v0.1.0 — Shared pure helper for framework middleware adapters of vicoproplus/moon_ua_parser: UaInfo assembly, degradati…
- **`paveg/httprouter`** v0.2.0 — A high-performance HTTP router for MoonBit, inspired by julienschmidt/httprouter
- **`naokikawamoto16/turn`** v0.1.0 — A simple HTTP router for MoonBit
- **`vicoproplus/moon_ua_parser_mars`** v0.1.0 — mars framework middleware adapter for vicoproplus/moon_ua_parser: mounts parsed UA families on the typed reque…
- **`xiewenchen/moonbit-platform`** v0.1.0 — 纯 MoonBit 实现的后端开发平台：Redis / PostgreSQL 协议驱动 + HTTP 1.1 服务端 + 应用框架层与工具链
- **`vicoproplus/moon_ua_parser_crescent`** v0.1.0 — Crescent framework middleware adapter for vicoproplus/moon_ua_parser: mounts parsed UaInfo on the request/resp…
- **`cpypypypy/har-toolkit`** v0.1.0 — Validated HAR 1.2 parser and performance analysis toolkit for MoonBit
- **`mldong/moon-token-store-file`** v0.1.20 — File-backed TokenStore for moon-token: in-memory authority with write-through to a directory, so a restart kee…
- **`zhuguiyuan/eda-router`** v0.1.3 — An simple congestion-aware EDA router implemented in MoonBit
- **`ZSeanYves/MoonbitHTTP`** v0.7.0 — Streaming HTTP protocol suite for MoonBit with HTTP/1.1, HTTP/2, HTTP/3, QUIC, TLS integration, and policy-dri…
- **`kaashyapan/uri`** v0.1.5 — URI parser and builder for Moonbit
- **`mizchi/crater-browser-http-sqlite`** v0.17.1 — Optional SQLite-backed cache backend for crater-browser-http
- **`marianoguerra/atproto-http`** v0.1.3 — Native HTTP transport for marianoguerra/atproto, over moonbitlang/async. Implements @xrpc.Transport; native ta…
- **`1726914517-spec/moonproxy`** v0.2.1 — A native L7 reverse proxy / load balancer runtime: host/path routing, five balancing policies, forwarding head…
- **`unmbt/http-server-mbt`** v0.5.0
- **`posoco/ext-llm`** v0.2.0 — Posoco LLM Extension - host-injected model slot router
- **`BigOrangeQWQ/uri`** v0.1.0 — URI parser for Moonbit

*其余基础库见 [http-libs.md](http-libs.md) 全量分册。*
