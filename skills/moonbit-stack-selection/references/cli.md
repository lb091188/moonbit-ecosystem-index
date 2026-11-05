# CLI 参数解析（`cli`）

*CLI Argument Parsing*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/cli>

命令行工具的参数、子命令、帮助信息解析。

## 完整方案 · 可作骨架

1. **`Yoorkin/ArgParser`** v0.2.1
   轻量参数解析库，支持命令、选项与子命令定义，无额外依赖。
   <https://mooncakes.io/docs/Yoorkin/ArgParser>

2. **`mizchi/admiral`** v0.1.1
   声明式 CLI 构建器，提供类型化选项与子命令回调，生成 shell 补全与 --help 输出。
   <https://mooncakes.io/docs/mizchi/admiral>

3. **`TheWaWaR/clap`** v0.2.6
   命令行参数解析库，支持选项、位置参数与多层子命令，帮助输出沿用 clap-rs 风格。
   <https://mooncakes.io/docs/TheWaWaR/clap>

4. **`totto2727/admiral`** v0.6.5
   admiral 的异步优先分支，命令处理可直接返回异步结果。
   <https://mooncakes.io/docs/totto2727/admiral>

## 基础库 · 单点能力，自行组合

- **`DzmingLi/clap`** v0.2.8 — Command Line Argument Parser
- **`Milky2018/options`** v0.1.3 — Command line argument parser for MoonBit
- **`peter-jerry-ye/parse_args`** v0.1.2 — A arg parser inspired by minimalist
- **`cauchyQ/moonbit-argkit`** v0.1.0 — Small dependency-free command line argument parser for MoonBit.
- **`jqlssg/moondocopt`** v0.1.1 — Help-first command-line parsing with docopt semantics and bounded reusable compilation
- **`moonrockz/zig-cross`** v0.3.2 — Cross-compile MoonBit native binaries with zig
