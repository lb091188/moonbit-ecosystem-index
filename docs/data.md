# 数据来源与更新

本文说明**索引的数据从哪来、落到哪些文件、怎么刷新**。分类与排序的规则见
[分类与排序规范](methodology.md)，构建与工作台操作见[构建、部署与工作台](maintenance.md)。

---

## 一、数据来源与时效

本索引是**离线快照，不随注册表实时更新**。唯一的数据来源是 mooncakes.io 的公开 API，
本项目只做聚合、分层与呈现，不修改原始数据，也不做注册表镜像。

| 数据项 | 来源 | 是否对外 |
| --- | --- | --- |
| 模块元数据（名称、版本、描述、关键词、许可、仓库、创建时间、yanked） | `GET /api/v0/modules` | 是 |
| 单包下载量 | `GET /api/v0/search?kw=…&limit=100` | **否**，仅参与构建期排序 |
| 生态汇总（包数、全生态累计下载量） | 每次全量采集记一笔，见 `data/history.json` | 是，仅首页趋势图 |
| 场景划分、层级、简介、译文、排序权重 | 人工维护，见 `data/` 下各源文件 | 是 |

站点顶部与页脚标注两个时间：**采集**（快照日期，来自 `data/raw/meta.json`）与**构建**
（页面生成时间，来自 `dist/data/scenarios.json` 的 `meta.built_at`）。所有数据都早于构建时间，
此后注册表的变动不在本站范围内：

- 快照之后发布的包不会出现在本站；
- 已发布新版本的包，版本号与描述可能滞后；
- yanked 状态以快照时为准，检索页标注 `yanked`，且不进入场景推荐。

对时效敏感的选型判断，应回到 mooncakes.io 与仓库实际状态核实。版本历史、完整 API 文档、
依赖关系本站一律不复制，页面内每个包名都直接指向 mooncakes 包页。

**数量不在文档里复述。** 包数、场景数、候选数这类会随采集变动的数字只存在于产物数据
（`data/scenarios.json`、`dist/data/scenarios.json`）；文档、报告与 skill 的 md 里都不写死，
避免文档一采完就过期。要数字就读 `dist/data/scenarios.json` 的 `meta`、`sol` / `lib` 字段。

---

## 二、采集链路

采集由 `app/fetch.mbt` 完成，按四步串行推进：

1. **拉模块清单**：`GET https://mooncakes.io/api/v0/modules` → `data/raw/modules_api.json`。
   响应是一整份 1 MB 上下的 JSON，无分页。用 `@http.get_stream` 分块读，每 2 秒往日志写一行
   「已收多少、平均多快」，状态行同步显示「接收中 N KB」，避免长时间无输出被误认为卡死。
2. **补下载量**：`GET https://mooncakes.io/api/v0/search?kw=<关键词>&limit=100` →
   `data/raw/downloads.json`。该接口单次上限 100 条且**不支持分页**，所以按 owner 前缀批量取
   （同一 owner 下的包通常不足 100 个），超过 100 个的 owner 再按包名逐个补，仍未覆盖的最后
   精确检索一次。匹配按小写包名归一，注册表里因改名留存的同名记录也能拿到下载量。
3. **记采集时间**：写 `data/raw/meta.json`，生成时带进站点与 skill 的快照行。
4. **记一笔历史**：往 `data/history.json` 追加 `[日期, 包数, 全生态累计下载量]`。数字取自
   **已落盘的模块表**（`load_modules()` 读两份 raw 快照并去重），不是采集过程中的计数——这样
   才与页面上「共 N 个包」同源。日志同时打印较上一次采集的增量。

### 请求策略：严格串行

这是人家白给的公共服务，几百条并发压上去一旦把注册表拖垮，比多等几小时糟得多。所以：

- 一条 `for` 循环，一条走完再歇 **0.8 秒**才发下一条；
- 失败按 **1.6 / 3.2 / 4.8 秒**退避重试，用尽才跳过该条；
- 请求走 `@async/http`，不起子进程、不用 curl；窗口模式把主循环也搬进 async，帧末
  `@async.pause()` 交还控制权，另有 33ms 常驻心跳保证窗口不僵；
- 全量采集耗时以小时计，中途可「停止采集」（协程在下一个检查点收手）。此时
  `downloads.json` / `meta.json` / `history.json` **都不会写半份**，但 phase 0 的
  `modules_api.json` **已经换成新快照**了。于是 `data/raw/` 会短暂停在「新模块清单 + 旧下载量」
  的混搭状态：**重新生成产物前先采完一次**，或把 `modules_api.json` 回退到上一版，否则榜单是
  新旧数据混算的；
- 冒烟档 `moon run . -- --fetch --fetch-owners 3` 只采前几个 owner、跳过按名补齐、不落盘，
  也不写历史点。

完整日志（含每条请求的地址、耗时、大小、覆盖进度）落 `data/raw/fetch.log`；界面上只显示
尾部若干行，且采集日志与生成日志各用一份虚拟列表，互不覆盖。

### 下载量的口径

`downloads.json` **只用于构建期排序，不复制进 `dist/`，也不写入站点数据**。若跳过补下载量，
构建会退化为仅按关键词排序，清单质量明显下降。这样设计的原因与完整论证见
[分类与排序规范 · 为什么站内不展示下载量](methodology.md#为什么站内不展示下载量)。

唯一的例外是首页「生态增长」里的**全生态累计下载总量**：它不与任何一行绑定、不参与排序，
无法拿来逐包比对。单包数字依旧不进 `dist/`。

---

## 三、文件契约

| 文件 | 性质 | 内容 |
| --- | --- | --- |
| `data/raw/modules_api.json` | 采集产物 | 注册表模块清单原始响应 |
| `data/raw/downloads.json` | 采集产物 | 单包下载量，键为小写包名 |
| `data/raw/meta.json` | 采集产物 | `collected_at` 快照日期 |
| `data/raw/fetch.log` | 采集产物 | 全量采集日志 |
| `data/history.json` | **长期累积，随仓库提交** | 每次全量采集一个点：`date` / `at` / `packages` / `downloads` / `with_dl` |
| `data/scenarios.src.json` | 人工源 | 场景定义：分组、标题、简介、收录与排除规则 |
| `data/i18n.json` | 人工源 | 场景与分组的英文译文，构建时校验完整性 |
| `data/blurbs.json` | 人工源 | 「完整方案」的中英文一句话简介 |
| `data/build.json` | 人工源（保存权重时才生成） | 排序权重 |
| `data/.backup/<时间戳>/` | 工作台自动备份 | 保存前的人工源文件副本 |
| `data/modules.json` | 生成产物 | 合并、去重后的模块表 |
| `data/scenarios.json` | 生成产物 | 站点数据源的中间形态 |
| `data/moonbit_index.db` | **旧版** SQLite | 由 `pipeline/analyze.py` 写入，当前工作台不再更新，见 [维护文档](maintenance.md#命令行查询) |
| `dist/data/scenarios.json` | 生成产物 | 前端唯一数据源：`meta` / `history` / `groups` / `scenarios` / `modules` / `blurbs` |
| `dist/index.html` + `dist/assets/*` | 生成产物 | 站点骨架与前端逻辑，**不含任何数量或数据** |
| `skills/…/references/*.md` | 生成产物 | skill 的离线快照，一场景 1–2 份 |

`data/raw/` 只增不改，用于复现。`data/history.json` 是长期累积的汇总，**不是生成产物**，
不要当成可重建的文件忽略或清理：漏提交等于把首页趋势图的历史清空。

页面与数据彻底分离：`index.html` 只含 CSS 与挂载点，数据全部由前端 `fetch` 加载
`dist/data/scenarios.json` 后填进页面。采集后数字变了不必重新生成 HTML，改样式也不必重新
生成数据。

### 双语数据的取法

- 场景的 `title` / `intro` / `note`、方案简介在产物里是 `[中文, 英文]` 二元数组，前端按语言
  取下标；中文原文写在 `data/scenarios.src.json`，英文译文集中在 `data/i18n.json`。
- 少一条译文，或留下一个 `scenarios.src.json` 里不存在的 id，构建会失败，不会带着漏译上线。
- 界面文案在 `dist/assets/app.js` 的 `T` 表；包描述来自注册表原文（多数为英文），**不翻译**——
  它是元数据，不是本站的表述。

---

## 四、刷新数据

更新分两步，先采集原始快照，再生成产物；两步在工作台里是两个独立按钮，这不是故障。

```bash
cd app && moon run .                     # 工作台：数据更新 → 执行更新；数据生成 → 执行生成
cd app && moon run . -- --fetch          # 或不开窗口，只跑采集
cd app && moon run . -- --build          # 或不开窗口，只跑生成
```

- **采集完成后必须再点一次「执行生成」**，否则榜单、站点与 skill 里的顺序仍是旧的。
- 同一天重跑采集，`data/history.json` **覆盖当天那一条**、不新增点，横轴不会被挤成锯齿。
- 写入历史失败只记日志、不影响本次采集成果。
- 图形化编辑（改场景、简介、收录规则）只写文件、不跑构建，要看到新排名得再生成一次；
  改坏了用 `git checkout -- data/` 取回上版。

验收步骤与核对命令见 [验收清单](verify.md)；构建与部署细节见
[构建、部署与工作台](maintenance.md)。
