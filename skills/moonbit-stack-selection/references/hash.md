# 哈希 / 校验（`hash`）

*Hashing / Checksums*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/hash>

哈希函数、消息摘要、HMAC 与校验和（CRC / FNV）。

## 完整方案 · 可作骨架

**无。** 该场景没有骨架级实现，只能用基础库组合。

## 基础库 · 单点能力，自行组合

- **`gmlewis/hash`** v0.21.2 — MoonBit hash: provide hash functions similar to Go.
- **`cc06b/mooncry`** v0.95.0 — Pure-MoonBit crypto primitives: SHA-1/2 (incl. SHA-512/224/256), SHA-3, Keccak-256, SHAKE/cSHAKE, BLAKE2b/BLAK…
- **`Tigls/mb-hash`** v0.1.0 — Secure hashing for MoonBit (SHA-256, SHA-512; native+WASM)
- **`moonbitstack/mooncrypt`** v0.4.11 — Cryptographic algorithms for MoonBit, one per package.
- **`gmlewis/sha256`** v0.18.2 — MoonBit sha256: provide simple sha256 hash algorithm.
- **`gmlewis/md5`** v0.20.2 — MoonBit md5: provide simple md5 hash algorithm.
- **`mizchi/bit_hash`** v0.49.1 — Git object hashing primitives (gix-hash equivalent)
- **`gmlewis/crc32`** v0.9.2 — MoonBit crc32: provide simple crc32 hash algorithm.
- **`gmlewis/sha1`** v0.12.17 — MoonBit sha1: provide simple sha1 hash algorithm.
- **`shu-kitamura/sha256`** v0.1.1 — A simple sha256 algorithm implemented in moonbit
- **`tonyfettes/xxh64`** v0.1.0 — XXH64 — a fast, portable, high-quality non-cryptographic hash. Faithful MoonBit port of the reference xxHash.
- **`moonbitstack/moonasgi`** v0.10.6 — ASGI 3.0 for MoonBit: the interface between servers and frameworks.
- **`Tigls/mb-hmac`** v0.1.0 — HMAC message authentication for MoonBit (HMAC-SHA256, HMAC-SHA512; native+WASM)
- **`AXiX-official/xxhash`** v0.1.0 — xxHash implementation in MoonBit.
- **`mldong/moon-hutool`** v0.1.8 — Hutool-style utility library for MoonBit: all packages depend only on moonbitlang/core (no FFI, fully synchron…
- **`kujirahand/crc32`** v0.1.1 — CRC32 checksum implementation
- **`wbgxiaosu/smcrypto`** v0.4.0 — 基于 2d5rrr333/toolsfx-moonbit 的国密工程化扩展：RFC 8998 符合的 SM4-GCM 认证加密、SM4 CTR、HMAC-SM3（RFC 2104）、PBKDF2-HMAC-SM3（RFC…
- **`123123213weqw/moonbit_jwt`** v0.1.0 — A MoonBit library for JSON Web Token (JWT) creation and verification. Pure MoonBit SHA256 + HMAC implementatio…
- **`Q30399/moonvault`** v0.1.0 — MoonVault -- Pure MoonBit password hashing and cryptographic library
- **`chenzehaoo/moon_guard`** v0.1.11 — MoonGuard is a pure-MoonBit supply chain security toolchain providing Ed25519 package signing and verification…
- **`Milky2018/slotmap`** v0.1.5 — Stable-key map containers for MoonBit with slot reuse and self-invalidating secondary maps.
- **`JJ-ai-nb/moonbit-shard-note`** v0.2.1 — Printable short-message shard cards with checksum validation, multi-parity recovery, diagnostics, and conforma…
- **`DzmingLi/rapidhash`** v0.1.4 — rapidhash V3 — a very fast, high-quality, non-cryptographic hash. Faithful MoonBit port of the reference C.
- **`kupas/hashwheel`** v0.1.2 — Consistent hashing hash ring, a MoonBit port of hashwheel
- **`bzhangui/hooklab`** v0.3.0-rc.5 — Self-hosted webhook security and reliable event-delivery platform in MoonBit.
- **`LuoYunze06/mooniban`** v0.1.1 — ISO 13616 IBAN normalization, checksum validation, and BBAN structure checks for MoonBit
- **`oboard/mooncrypto`** v0.1.8 — MoonBit Crypto Library
- **`aurasuisui/indexmap`** v0.4.0 — A hash map that preserves insertion order - MoonBit port of Rust's indexmap
- **`PingGuoMiaoMiao/LunarKeccak256`** v0.1.3 — 一个使用 MoonBit 语言实现的 Keccak256 哈希算法库。Keccak256 是 SHA-3 标准的一部分，广泛应用于区块链和密码学领域。
- **`RabitLogic/mjwt`** v0.2.0 — A JWT (JSON Web Token) library for MoonBit with extensible trait-based signers

*其余基础库见 [hash-libs.md](hash-libs.md) 全量分册。*
