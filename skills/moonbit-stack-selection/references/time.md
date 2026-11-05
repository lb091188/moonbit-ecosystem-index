# 时间 / 日期（`time`）

*Time / Dates*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/time>

日期时间、时区、RFC3339、cron。

## 完整方案 · 可作骨架

**无。** 该场景没有骨架级实现，只能用基础库组合。

## 基础库 · 单点能力，自行组合

- **`moonbitlang/x`** v0.5.7 — experimental packages for moonbitlang/core
- **`moonbitstack/moondate`** v0.1.4 — Dates, times, durations and cron expressions for MoonBit.
- **`mldong/moon-hutool`** v0.1.8 — Hutool-style utility library for MoonBit: all packages depend only on moonbitlang/core (no FFI, fully synchron…
- **`brickfrog/tempo`** v0.8.1 — UTC date/time library — RFC 3339 parsing, Unix timestamps, arithmetic
- **`kawaz/timespec`** v0.2.4 — CLI-oriented time specification parser for MoonBit
- **`mizchi/bit_date`** v0.49.1 — Git date parsing primitives (gix-date equivalent)
- **`caijiewei295/tzif-engine`** v0.1.0 — Pure MoonBit IANA TZif v2/v3 parser and timezone conversion engine. UTC ↔ local time with full DST handling, P…
- **`moonbitstack/moonward`** v0.2.1 — Resilience for MoonBit without I/O: circuit breaking, load shedding, rate limits and deadlines.
- **`001-Elsa/mooncron`** v0.1.4 — A cron expression parser and schedule calculator written in MoonBit.
- **`marianoguerra/temporal`** v0.1.2 — An implementation of ECMAScript Temporal: calendar and time-zone aware dates, times, instants and durations. P…
- **`iceBear67/time`** v0.1.2 — A date-time library in MoonBit, including zone offsets and clocks that support JS and Native backend.
- **`mizchi/whenwords`** v0.1.3 — A relative time formatting library for MoonBit, following the whenwords specification
- **`chensuiyi/dateku`** v0.3.0 — MoonBit date-time formatting: epoch-milliseconds to ISO 8601 and RFC 5322 timestamps, UTC only
- **`suiyunonghen/datetime`** v0.1.6 — datetime type of moonbit
- **`connect0459/almanac`** v0.3.0 — A date and time library for MoonBit
- **`Asterless/MoonPtime`** v0.1.2 — A POSIX time library for MoonBit with picosecond precision, inspired by OCaml's ptime library. Provides immuta…
- **`MINGtoMING/datetime`** v0.1.0 — Parsing and stringifying datetime values in TOML format
- **`yyqdbngt/moon_edtf`** v0.2.0 — Conservative pure-MoonBit EDTF subset parser that preserves uncertainty and rejects guesswork.
- **`bobzhang/dateutil`** v0.1.0 — A port of python-dateutil to MoonBit: relativedelta, rrule, parser, tz, easter.
- **`lxz123411/moonrrule`** v0.1.0 — A timezone-safe recurrence and scheduling engine for MoonBit
- **`p1nbored/moon_cron`** v0.1.0 — A dependency-free cron expression parser and schedule matcher for MoonBit.
- **`justjavac/ttl`** v0.1.3 — A small in-memory TTL cache for MoonBit
- **`MaoDingA/moonpost`** v0.2.1 — Pure MoonBit toolkit for subtitles, timecode, creator cleanup, delivery checks, and post-production QC.
- **`cxh04/cron_mbt`** v0.2.4 — A cron expression parser, matcher, scheduler, and CLI for MoonBit.
- **`bobzhang/sleep`** v0.1.2 — Pause for a number of seconds, like sleep, runnable via moonx
- **`white-bear233/moontimeline`** v0.2.0 — MoonBit OTIO schemas, timeline semantics, algorithms, bundles and plugins
- **`Zy789kl/moon-change-point`** v0.3.1 — Production-oriented MoonBit change-point detection, streaming windows, multivariate monitoring, replay, SLO an…
- **`CAIMEOX/Motiva`** v0.3.0 — A MoonBit animation engine inspired by Manim.
- **`cn-wn/moonsignalkit`** v0.3.0 — Streaming telemetry statistics and change detection for MoonBit.
- **`Santa968/moonpromql`** v0.1.0 — A pure-MoonBit PromQL parser and query engine for in-memory time-series data

*其余基础库见 [time-libs.md](time-libs.md) 全量分册。*
