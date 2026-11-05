# 压缩 / 归档（`archive`）

*Compression / Archives*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/archive>

DEFLATE / zlib / gzip / ZIP 的压缩与解压实现。

## 完整方案 · 可作骨架

**无。** 该场景没有骨架级实现，只能用基础库组合。

## 基础库 · 单点能力，自行组合

- **`mizchi/zlib`** v0.4.10 — Pure MoonBit zlib/deflate implementation.
- **`moonbit-community/flate`** v0.10.0 — Pure-MoonBit, runtime-agnostic DEFLATE (RFC 1951) engine with gzip/zlib/zip wrappers — suspendable and io-free…
- **`Milky2018/moon_yazi`** v0.1.4 — A small zlib/DEFLATE implementation in MoonBit (ported from yazi).
- **`gmlewis/zlib`** v0.21.17 — MoonBit zlib: provide simplified zlib format compressed data.
- **`mizchi/brotli`** v0.2.2 — Brotli compression and decompression library for MoonBit
- **`hustcer/fzip`** v0.8.8 — High-performance compression library for MoonBit, ported from fflate. (DEFLATE/GZIP/Zlib/ZIP) 🚀
- **`mizchi/x`** v0.6.1 — Cross-platform MoonBit compatibility facades with native delegation and accelerated JS implementations for asy…
- **`hustcer/fbr`** v0.8.2 — Pure MoonBit Brotli (.br) encoder and decoder with split encode/decode packages
- **`gmlewis/flate`** v0.36.17 — MoonBit flate: provide simplified flate (LZW) compression algorithm.
- **`moonbit-community/zipc`** v0.2.2 — Typed, in-memory ZIP archive library for MoonBit (deflate via moonbit-community/flate)
- **`Milky2018/zstd`** v0.1.4
- **`bikallem/compress`** v0.3.4 — Compression library for MoonBit: flate, gzip, zlib, lzw, bzip2, snappy, lz4, zstd, brotli
- **`moonbitstack/moonzip`** v0.3.6 — Compression and archives for MoonBit, one format per package.
- **`gaato/codec`** v0.1.0 — Error kinds and limits shared by the streaming codecs of gaato/codecs.mbt.
- **`gaato/codec_bytes`** v0.1.1 — The streaming contract of byte-stream codecs: step through input chunks into bounded output slices, with bound…
- **`gaato/deflate`** v0.1.0 — Streaming DEFLATE, zlib and gzip decoders and encoders (RFC 1951, 1950, 1952) for MoonBit: arbitrary input chu…
- **`gaato/brotli`** v0.4.1 — A streaming Brotli (RFC 7932) decoder and encoder in pure MoonBit: arbitrary input chunks, bounded output slic…
- **`gmlewis/gzip`** v0.34.17 — MoonBit gzip: provide simple gzip and gunzip algorithms.
- **`superbigcup325/colenc`** v0.1.3 — Columnar encoding kernel for MoonBit: the Parquet page-level encoding family as a reusable, verifiable, plugga…
- **`moonbitstack/moonrpc`** v0.21.12 — gRPC for MoonBit.
- **`gaato/zstd`** v0.3.1 — A streaming Zstandard (RFC 8878) decoder in pure MoonBit: arbitrary input chunks, bounded output slices, memor…
- **`moonbitstack/moonfetch`** v0.1.5 — An HTTP client for MoonBit, synchronous or asynchronous.
- **`aurora0x27/lzma-mbt`** v0.1.0 — Independent MoonBit implementation of liblzma core functionality
- **`mizchi/bit_archive`** v0.49.1 — Tar archive writing (gix-archive equivalent)
- **`lin2077-zeming/moonxz`** v0.4.6 — Pure MoonBit XZ/LZMA/LZMA2 compression and decompression toolkit
- **`moonbit-community/evol-minifier`** v0.3.1 — A slightly faster JavaScript mangler/compressor for MoonBit.
- **`bobzhang/tar`** v0.1.3 — Pure MoonBit library to read and write tar files with streaming support
- **`ivgtr/moonzip`** v0.2.4 — A MoonBit compression library compatible with fflate
- **`Asterless/MoonQOI`** v0.1.3 — QOI (Quite OK Image Format) encoder/decoder library for MoonBit
- **`moonbitstack/moonapi`** v0.17.9 — A typed web framework for MoonBit.

*其余基础库见 [archive-libs.md](archive-libs.md) 全量分册。*
