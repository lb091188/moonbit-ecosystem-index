# 网络传输 / 套接字（`net`）

*Networking / Sockets*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/net>

TCP / UDP、套接字、DNS、TLS 等传输层能力。

## 完整方案 · 可作骨架

**无。** 该场景没有骨架级实现，只能用基础库组合。

## 基础库 · 单点能力，自行组合

- **`moonbitstack/moonnet`** v0.1.10 — Networking for MoonBit: connections, listeners and dialers over TCP, TLS and QUIC.
- **`mizchi/crater-network`** v0.19.0 — WebDriver BiDi synthetic network state and byte/query encoding helpers for crater adapters
- **`ShellWen/sw_socket`** v0.2.0 — A experimental *nix socket binding for MoonBit.
- **`fangyinc/socket`** v0.1.2-rc2 — A socket binding for MoonBit
- **`moonbitstack/moontls`** v0.9.14 — TLS 1.3 and DTLS 1.3 for MoonBit.
- **`ZSeanYves/MoonbitHTTP`** v0.7.0 — Streaming HTTP protocol suite for MoonBit with HTTP/1.1, HTTP/2, HTTP/3, QUIC, TLS integration, and policy-dri…
- **`oboard/mio`** v0.5.4 — Best async http library for Moonbit
- **`moonbitstack/moonquic`** v0.3.11 — QUIC transport for MoonBit.
- **`moonbitstack/moonrpc`** v0.21.12 — gRPC for MoonBit.
- **`moonbitstack/mooncat`** v0.19.5 — A native ASGI server for MoonBit.
- **`moonbitstack/moonfetch`** v0.1.5 — An HTTP client for MoonBit, synchronous or asynchronous.
- **`cghyyrrt/moonbit-pcap`** v0.1.2 — Pure MoonBit network packet capture (PCAP / PCAPNG) parser, stream reassembly, and multi-protocol analyzer lib…
- **`moonbitstack/moonmysql`** v0.7.9 — Pure-MoonBit MySQL wire-protocol driver implementing @moondb.Driver — no C, like PyMySQL.
- **`chensuiyi/packet`** v0.1.1 — MoonBit 协议解析层：Ethernet/IPv4/IPv6/TCP/UDP 头解析
- **`PaiGack/ftp`** v0.2.5 — FTP/FTPS client library for MoonBit with passive EPSV/PASV data connections, MLSD/LIST parsing, resume, direct…
- **`jinshengmeng46/moon-dns-stub`** v0.1.0 — Native DNS wire format codec and async stub resolver. Supports A/AAAA/MX/SRV/TXT/CNAME/NS/PTR/SOA with name co…
- **`aspnmy/moodtcpcli`** v0.1.0 — Zero-dependency TCP network primitives for MoonBit - ported from rstcpcli
- **`Ljh684/moonnet-lab`** v0.1.0 — Deterministic packet-level network simulator and TCP congestion-control lab for MoonBit
- **`usagi-star/mooncap`** v0.1.0 — Pure MoonBit offline PCAP/PCAPNG parsing and protocol decoding
- **`chgttyyr/moon_dns`** v0.1.0 — Pure MoonBit authoritative DNS server (RFC 1035/6891) with robust pointer compression security
- **`moonbitstack/moonpostgres`** v0.6.9 — Pure-MoonBit PostgreSQL wire-protocol driver implementing @moondb.AsyncDriver — no C, like asyncpg.
- **`wcj12314/moon-flow-guard`** v0.1.0 — MoonFlowGuard: a MoonBit traffic-flow security audit and policy gate with PASS/REVIEW/FAIL verdicts, risk scor…
- **`q2316367743/moonhttp`** v0.6.1 — axios 风格的 MoonBit HTTP 客户端：实例与配置合并、四种请求体形态、流式与 SSE、自动重定向
- **`sujy123456/mooncoap`** v0.1.1 — Bounded, deterministic unicast CoAP protocol core for MoonBit
- **`aspnmy/moonitest`** v0.2.1 — MoonBit integration test framework - real Docker/TCP/HTTP API via fangyinc/socket + C FFI
- **`BeiLaDuo/cidr-audit`** v0.1.2 — Audit IPv4 CIDR allow/deny rules for overlap, shadowing, and risky network ranges in pure MoonBit
- **`fangyinc/net`** v0.1.1-rc1 — Cross-target network abstractions (TcpStream, TcpListener, UdpSocket) unifying WASM, JS, and native targets fo…
- **`bobzhang/loop_invariants_graph`** v0.18.0 — Graph and tree algorithms with loop-invariant explanations
- **`chensuiyi/dcipc`** v0.3.0 — Local daemon control channel for MoonBit: length-prefixed frames, token auth over loopback TCP, contact files …
- **`qyt1234567/moonbit-modbus`** v0.2.2 — A portable Modbus RTU, ASCII, and TCP protocol stack with device simulation and gateway primitives for MoonBit…

*其余基础库见 [net-libs.md](net-libs.md) 全量分册。*
