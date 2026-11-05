# 二进制编码（`binfmt`）

*Binary Encoding*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/binfmt>

CBOR、Protocol Buffers、MessagePack、ASN.1 等二进制序列化格式。

## 完整方案 · 可作骨架

**无。** 该场景没有骨架级实现，只能用基础库组合。

## 基础库 · 单点能力，自行组合

- **`mizchi/cbor`** v0.1.1 — CBOR (RFC 8949) implementation for MoonBit - Pure and FFI versions
- **`moonbitstack/moonjson`** v0.4.3 — JSON, its dialects and its binary encodings for MoonBit.
- **`moonbitstack/moonrpc`** v0.21.12 — gRPC for MoonBit.
- **`moonbitstack/mooncrypt`** v0.4.11 — Cryptographic algorithms for MoonBit, one per package.
- **`moonbitlang/protobuf`** v0.2.0 — The runtime library for protobuf
- **`moonbitstack/moonvar`** v0.2.1 — Fixed-width and variable-length integer encodings for MoonBit.
- **`moonbitstack/mooncred`** v0.6.9 — Credentials for MoonBit: JWT, JWK and X.509.
- **`oilleelssq-wq/MoonBit-PKI`** v0.2.0 — Pure-MoonBit ASN.1 DER codec and X.509 certificate toolkit.
- **`2515050242/cbor`** v0.1.2 — A high-performance, standard-compliant CBOR (RFC 8949) serialization library for MoonBit.
- **`yugonlian/moon-avro`** v0.3.0 — Pure MoonBit Apache Avro schema, datum codec, and Object Container File toolkit.
- **`moonbitstack/moonctl`** v0.12.7 — Project and code generator for MoonBit services.
- **`Xpeng/moonthrift`** v0.4.0 — Apache Thrift IDL tooling and binary protocol support for MoonBit
- **`hbYlj/moonldap`** v0.3.0 — RFC-driven LDAPv3 client library for MoonBit with a generic ASN.1 BER codec
- **`oilleelssq-wq/moonua`** v0.3.0 — Pure MoonBit OPC UA Binary Encoding primitives and data-model codecs.
- **`MuVirus/moonfig`** v0.1.8 — MoonBit 原生配置库：一处声明，多来源汇入。
- **`f4ah6o/direct_sdk`** v0.11.2 — MoonBit SDK for Direct4B WebSocket API with MessagePack RPC
- **`2515050243qyf/moon_bencode`** v0.2.0 — A fast and compliant Bencode encoder and decoder for MoonBit.
- **`Ljh684/MoonParse`** v0.1.4 — MoonBit 解析器组合子库 — 与生态中其他 combinator 不同：(1)内置完整 JSON 解析器（JsonValue 枚举+双向序列化）和 TOML 解析器，开箱即用；(2)支持二进制解析（u8-u64/L…
- **`Ridge-Lab/capnp`** v0.3.1 — Cap'n Proto serialization runtime and schema code generation for MoonBit.
- **`Duan-lang-dev/moonproto`** v0.2.0 — A pure-runtime Protocol Buffers wire format encoder/decoder and proto3 subset parser in MoonBit
- **`moonbitlang/protoc-gen-mbt`** v0.3.0 — The Protocol Buffers compiler plugin for MoonBit
- **`suiyunonghen/moonvalue`** v0.1.14 — moonbitlang实现的msgpack,bson库
- **`123123213weqw/moon_proto`** v0.1.1 — A MoonBit protobuf ecosystem lab for dynamic schema validation, compatibility testing, and AI code verificatio…
- **`lindividual/der`** v0.2.1 — ASN.1 DER parser for MoonBit. Supports PKCS#1 and PKCS#8 RSA private key parsing.
- **`hackwaly/msgpack`** v0.1.0
- **`zhaojun-coding/thrift`** v0.7.0 — 基于 Xpeng/moonthrift 的有界多请求 RPC 会话
