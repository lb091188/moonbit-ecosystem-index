# MoonBit 生态索引

按使用场景组织的 MoonBit 包选型参考。本项目采集 mooncakes.io 注册表的公开数据，将包归入
25 个常见技术场景，并把每个场景的候选划分为**完整方案**与**基础库**两个层级，生成一份
可在浏览器中检索的静态站点。

站点为纯静态产物，构建在本地完成，可直接托管于 Cloudflare Pages、GitHub Pages 或任意
静态文件服务。

---

## 一、数据时效

本索引是**离线快照，不随注册表实时更新**。各项数据的时间边界如下：

| 数据项 | 来源 | 快照时间 |
| --- | --- | --- |
| 模块元数据、下载量 | mooncakes.io 官方 API | 2026-11-02 |
| 反向依赖数（直接 / 传递） | gaato/mooncakes-graph 每日快照 | 2026-11-01 |

两批数据相隔约半日，且均早于站点构建时间。mooncakes 注册表每日均有新增、版本更新与
yanked 标记，本索引**不包含**快照之后的任何变动，具体影响为：

- 快照之后发布的包不会出现在本站；
- 已发布新版本的包，其版本号与描述可能滞后；
- yanked 状态以快照时为准（当前 96 个），已在站内标注，并从推荐中排除。

对时效敏感的选型判断，应回到 mooncakes.io 与仓库实际状态核实。如需刷新，依照
「五、数据更新」重新抓取并构建。

---

## 二、分层口径

同一场景内混列「可承担项目骨架的包」与「提供单点能力的包」，会使选型失去意义，因此
本索引将候选分为两层。

| 层级 | 判定标准 | 示例 |
| --- | --- | --- |
| **完整方案** | 定义程序结构，由调用方填空：路由表、组件树、事件循环、ECS、数据访问层、命令行树、语法 DSL、测试容器 | `moonback`、`rabbita`、`proton`、`selene`、`moondb`、`ArgParser` |
| **基础库** | 提供单点能力，由调用方组合：格式解析、哈希、C 库绑定、数据结构 | `yaml`、`sha256`、`btree`、`sqlite`、`gtk`、`glfw` |

框架、引擎、运行时、脚手架、ORM 均属「完整方案」的不同形态。

需特别说明：**「基础库」不等同于「依赖」**。在 mooncakes 生态中，完整方案本身同样是依赖
（`moon.mod.json` 的 deps 收录全部包），因此以 deps 作为「方案」的反义词在定义上不成立。
分层的唯一标准是该包能否接管程序结构。由此可推出：所有 binding 均归入基础库，完整方案
位于其上层（`giraffe` 之于 GTK，`proton` 之于 WebView）。

完整方案的判定**采用人工白名单**（`pipeline/analyze.py` 中的 `SOLUTIONS`，当前 62 个包），
不使用启发式推断。方案层是高精度区，宁可遗漏，也不将基础库纳入推荐位。构建脚本每次运行
会输出「待确认的方案候选」，即自我描述含 `framework` 等字样、尚未收录白名单的包，供人工
复核后补入。

25 个场景中，14 个存在完整方案；其余 11 个（regex、unicode、crypto、math、graphics、doc、
time、log、net、img、ds）在生态中尚无骨架级实现，站内已明确注明，并列出可用基础库。
这属于生态现状，而非数据缺失。

---

## 三、目录结构

```
.
├── pipeline/
│   ├── analyze.py            数据合并、场景打分、排序与产物生成
│   └── query.py              命令行查询（场景 / 全量检索 / SQL）
├── data/
│   ├── raw/                  原始快照，只增不改，用于复现
│   ├── modules.json          合并后的模块表（3520 条）
│   ├── scenarios.json        场景与分层结果，站点的数据源
│   └── moonbit_index.db      SQLite 索引（modules / scenarios 两表）
├── dist/                     静态发布目录（产物入库，便于直接部署与差异追溯）
│   ├── index.html
│   ├── scenarios.md
│   └── data/
├── scenarios.md              场景推荐报告（Markdown，便于引用于文档）
└── README.md
```

`dist/` 内文件均由 `pipeline/analyze.py` 生成，不应手动修改。

---

## 四、构建与部署

### 构建

```bash
python3 pipeline/analyze.py
```

脚本读取 `data/raw/` 与 `data/` 中的既有数据，输出四类产物：SQLite 索引、Markdown 报告、
结构化 JSON，以及 `dist/` 站点。运行环境仅需 Python 3.9 及以上，无第三方依赖。

### 部署至 Cloudflare Pages

```bash
npx wrangler pages deploy dist --project-name moonbit-ecosystem-index
```

也可在 Cloudflare 控制台创建 Pages 项目，将**输出目录设为 `dist`**，构建命令留空。
由于产物已入库，云端无需执行任何构建步骤。

本项目未采用「在 Cloudflare 上运行构建脚本」的方式：Pages 的构建镜像以 Node.js 为主，
Python 可用性不作保证；而站点产物为纯静态文件，本地构建后上传即可满足需求，无须为此
引入额外的 Node 构建链。

### 本地预览

```bash
python3 -m http.server 8000 --directory dist
```

访问 `http://localhost:8000`。页面运行时不发起任何网络请求，全部数据在构建阶段内联，
因此直接以 `file://` 打开 `dist/index.html` 亦可正常工作。

---

## 五、数据更新

1. 抓取 `https://mooncakes.io/api/v0/modules`，写入 `data/raw/modules_api.json`；
2. 通过 `https://mooncakes.io/api/v0/search?kw=<关键词>&limit=100` 补齐下载量，写入
   `data/raw/downloads.json`。该接口单次上限 100 条且不支持分页，需以「关键词并集」加
   「包名精确检索」两步合并，方可覆盖全量；
3. 从 gaato/mooncakes-graph 取 `metrics.tsv` 与 `versions.jsonl`，存入 `data/raw/`；
4. 修改 `pipeline/analyze.py` 顶部的 `META_SNAPSHOT` 与 `GRAPH_SNAPSHOT`；
5. 运行 `python3 pipeline/analyze.py`。

---

## 六、命令行查询

```bash
python3 pipeline/query.py --list                    # 场景清单与两层计数
python3 pipeline/query.py http                      # 指定场景的完整方案
python3 pipeline/query.py "数据库"                   # 支持中文场景名
python3 pipeline/query.py http --libs --top 20      # 连同基础库一并展开
python3 pipeline/query.py --search websocket        # 全量检索模块
python3 pipeline/query.py --sql "select name,downloads from modules order by downloads desc limit 10"
```

---

## 七、排序方法

```
score = min(关键词匹配度, 6) × 1.0
      + log(1 + 下载量) × 1.05
      + log(1 + 反向依赖数) × 0.55
```

关键词匹配依据 `keywords`、包名词元与描述词元，并做词干前缀归一（使 `async` 命中
"Asynchronous"、`argparse` 命中 `ArgParser`）。易混场景设有排除规则，例如 UI 场景排除
TUI、文档场景排除 UI 框架。db、ui、net、gui 四个场景另有少量人工置顶，用于纠正「接口库
排在使用库之前」的偏差。

仅纳入下载量大于 20 的模块（3520 个中的 3341 个），yanked 包不进入推荐。

---

## 八、已知局限

1. **下载量为累计值**，不反映近期热度，发布较早的包天然占优。
2. **约 386 个包无描述、680 个无关键词**，仅能依据包名匹配，存在遗漏可能。
3. **场景划分为人为定义**，并非生态固有分类；同一包可能适用于多个场景。
4. **完整方案判定为主观白名单**，边界情形（如 `mizchi/tui` 计入方案而 `tonyfettes/xml`
   不计入）存在判断空间。代价是新发布的方案需人工补入方可出现在方案层。
5. **基础库层未再细分**，目前未区分完整工具（如 `cmark`）与底层原语（如 `sha256`）。
6. **`moonbit-community/window` 在注册表中已不可用**，现行为 fork 版 `wzzc-dev/window`；
   `Milky2018/window` 为另一条独立实现。
7. **`Yoorkin/rabbit-tea` 已被 yanked**，TEA 路线的现行实现为 `moonbit-community/rabbita`。
8. **新包在公式中系统性偏弱**：`log(下载量)` 权重最高，而下载量为累计值，刚发布的包难以
   与老包比较。`created_at` 系注册表收录时间而非项目起始时间，无法据以计算增长速度，
   因此只能对部分框架级包（`proton`、`moui`、`native-gui`）人工加权。
9. **跨端 UI 场景为人工圈定**，其 `score` 字段为优先级序号而非算法得分。
10. **Proton 系列配套模块下载量偏高**：`proton_clipboard`、`proton_tray`、
    `proton_global_hotkey` 等集中在 2.4 万上下且反向依赖仅 1~2，疑为随脚手架整包拉取，
    不宜视作独立采用度。

---

## 九、许可与致谢

数据来源为 mooncakes.io 公开 API 与 gaato/mooncakes-graph 的公开快照，版权归各原始项目所有。
本项目仅做聚合、分层与呈现，不修改原始数据。
