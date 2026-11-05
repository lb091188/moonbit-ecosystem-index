# LLM / Agent / MCP（`llm`）

*LLM / Agent / MCP*

> 快照 2026-11-05｜在线版 <https://moonbit-ecosystem-index.pages.dev/#/s/llm>

大模型客户端、Agent 框架、MCP 服务端/客户端、提示词。

## 完整方案 · 可作骨架

1. **`colmugx/posoco`** v0.24.1
   六边形架构（端口-适配器）Agent 框架，定义扩展端口与 Agent 循环，LLM 与工具可替换。
   <https://mooncakes.io/docs/colmugx/posoco>

2. **`colmugx/mcp`** v0.18.2
   类型安全的 MCP SDK，同时提供服务端与客户端，支持 STDIO 与 HTTP 两种传输。
   <https://mooncakes.io/docs/colmugx/mcp>

3. **`golemcloud/golem_sdk`** v0.6.2
   Golem 平台的 SDK，用于构建可持久化、可故障恢复的 agent，需绑定该托管平台。
   <https://mooncakes.io/docs/golemcloud/golem_sdk>

4. **`weopqrst/agent`** v0.5.1
   LangChain 核心库的 MoonBit 实现，类型安全、可组合，LLM 客户端基于 mizchi/llm。
   <https://mooncakes.io/docs/weopqrst/agent>

5. **`soehi/moonlm`** v0.1.3
   本地 LLM 推理引擎与强类型 agent 运行时，无需外部 API 即可运行模型。
   <https://mooncakes.io/docs/soehi/moonlm>

## 基础库 · 单点能力，自行组合

- **`mizchi/llm`** v0.3.2 — Pure MoonBit LLM client library
- **`colmugx/acp`** v0.3.0 — Type-safe Agent Client Protocol (ACP) SDK for MoonBit.
- **`DC-Z-lab/moonllm`** v0.1.0 — Type-safe, OpenAI-compatible LLM client for MoonBit: chat completions, streaming (SSE), tool calling, and mult…
- **`marianoguerra/llm`** v0.4.2 — A dialect-agnostic LLM IR, one wire mapping per provider protocol, a data-driven provider registry, and a tran…
- **`colmugx/lody`** v0.1.0 — 1:1 MoonBit mirror of the LodyAI acp-extension-core contract (tool vocabulary, _meta.lody DTOs, _lody/ methods…
- **`wzzc-dev/moui_agent_mcp`** v0.3.0 — MCP JSON-RPC router and stdio transport exposing a MoUI AgentHost to external agents
- **`totto2727/codex-sdk`** v0.4.1 — MoonBit SDK for embedding the Codex agent in workflows and applications
- **`gaato/openai`** v0.6.0 — Thin OpenAI API client for MoonBit built on gaato/http and gaato/sdk-runtime: models, embeddings, responses (b…
- **`shiguri-01/mcp`** v0.2.0 — A library for building Model Context Protocol servers and clients.
- **`moonbitstack/moonmcp`** v0.1.10 — Model Context Protocol servers and clients for MoonBit.
- **`totto2727/agent-core-sdk`** v0.1.2 — Shared MoonBit process foundation for agent CLIs
- **`wzzc-dev/moui_agent`** v0.3.0 — MoUI agent protocol layer: observable/controllable runtime surface for external agents
- **`mizchi/mnemo`** v0.2.2 — Hermes-compatible memory / skills / session / prompt layer for AI agents (MoonBit native + JS)
- **`trkbt10/llm_interop`** v0.3.0 — Unified LLM protocol abstraction for MoonBit — multi-provider support with streaming, tool calling, and protoc…
- **`hnlyxiaobing/MBOpenClacky`** v0.3.1 — AI Agent CLI tool rewritten in MoonBit
- **`howtomakeaname/tokenizers-moonbit`** v0.16.3 — A MoonBit port of HuggingFace tokenizers. Loads tokenizer.json and runs BPE / byte-level BPE / WordPiece / Uni…
- **`conglinyizhi/better-edit-tools-mcp`** v0.1.1 — MoonBit MCP file editing toolkit — atomic writes, function-scope detection, snapshot rollback, and fault-toler…
- **`golemcloud/golem_sdk_tools`** v0.6.2 — Code generation tools for the Golem SDK for MoonBit
- **`sennenki/pretty_prompt`** v0.1.2 — A pretty prompt library for Moonbit, providing an easy way to create interactive command-line interfaces with …
- **`moonbitstack/moonkoog`** v0.6.1 — moonkoog — a MoonBit port of JetBrains Koog (1.1.1): a type-safe agent-orchestration framework. The prompt/mes…
- **`kupas/mcpbox`** v0.1.6 — A self-contained MCP client CLI for discovering and calling Model Context Protocol servers
- **`eanzhao/pi-moonbit`** v0.1.5 — AI coding agent toolkit in MoonBit. Ships the `pimbt` CLI with 7 LLM providers (OpenAI / Anthropic / Gemini / …
- **`zhangbowen2006/moongate`** v0.7.1 — Dual-point policy enforcement and secret stand-ins for MCP tools, in one MoonBit core.
- **`Milky2018/svgdiff`** v0.10.6 — Deterministic visual-semantic SVG comparison with typed reports for programs and text-only agents.
- **`conglinyizhi/moonbit-llm-faceoff`** v0.2.0 — OpenAI-compatible LLM client, a harness that compares multiple models on the same case set, and a browser UI f…
- **`Across2005/harness-self-evolution`** v0.3.8 — 面向 DeepSeek Harness（DSH）的全盘自进化 stdio MCP 插件（MoonBit 原生）：16 个工具完成 扫描→监控→提案→审批→执行 闭环，含子 Agent 工厂与只读运行时快照；人工审批闸门；…
- **`123123213weqw/moonbit_mcp`** v0.1.0 — A MoonBit SDK for the Model Context Protocol (MCP). Build MCP servers and clients in MoonBit.
- **`totto2727/agent-sdk`** v0.2.1 — Provider-neutral MoonBit interfaces for agent CLI SDKs
- **`marianoguerra/mcp-server`** v0.10.1 — Define MCP 2026-07-28 servers: a side-effect-free routing core, tools/resources/prompts, and a transport trait…
- **`tuya-me/aegisrun`** v0.9.3 — AegisRun - AI Agent Secure Tool Runtime (MoonBit + Wasm)

*其余基础库见 [llm-libs.md](llm-libs.md) 全量分册。*
