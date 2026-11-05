# 运维 / 系统管理（`ops`）

*Ops / System Administration*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/ops>

进程守护与进程检查、子进程与命令执行、伪终端控制、CI 任务运行。生态中尚无运维框架，但已有可直接部署的成品工具，与若干可组合的基础库。

## 完整方案 · 可作骨架

1. **`chensuiyi/bm2`** v0.8.0
   面向 Bun 与 Node.js 应用的 Linux 进程管理器，以 MoonBit 实现。
   <https://mooncakes.io/docs/chensuiyi/bm2>

2. **`mizchi/actrun`** v0.32.0
   兼容 GitHub Actions 的本地 CI 运行器，工作流可在本机执行，不依赖远端。
   <https://mooncakes.io/docs/mizchi/actrun>

3. **`kupas/pm3`** v0.1.8
   语言无关的进程管理器，参照 PM2 设计，内置日志轮转。
   <https://mooncakes.io/docs/kupas/pm3>

4. **`tiye/redstart`** v0.1.4
   面向本地开发的轻量进程管理器。
   <https://mooncakes.io/docs/tiye/redstart>

## 基础库 · 单点能力，自行组合

- **`moonbit-community/pty`** v0.4.4 — Cross-platform PTY (pseudo-terminal) spawning for MoonBit native targets, integrated with moonbitlang/async.
- **`moonbit-community/tty`** v0.6.2 — Low-level terminal primitives for MoonBit native and wasm targets: a sidecar-held controlling terminal with ra…
- **`Milky2018/sysinfo`** v0.1.7 — System metrics and process inspection library.
- **`mizchi/process_pool`** v0.1.4
- **`moonbit-community/proton_process`** v0.2.6 — Native child process spawning for MoonBit on Windows, Linux, and macOS.
- **`trkbt10/subprocess`** v0.2.0 — Node.js child_process-like subprocess management for MoonBit
- **`trkbt10/osenv`** v0.1.0 — OS environment utilities: platform detection, safe path operations, and OS-standard directory resolution (XDG/…
- **`mizchi/tempfile`** v0.1.3 — Temporary file and directory management for MoonBit
