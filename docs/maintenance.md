# 构建、部署与工作台

本文面向**维护者**：改数据、跑构建、发布站点。数据的来源与刷新流程见
[数据来源与更新](data.md)，分类与排序规则见[分类与排序规范](methodology.md)，逐项验收见
[验收清单](verify.md)。

> **工具链现状**：采集、构建、工作台与本地预览都在 `app/` 里用 MoonBit 完成，
> 日常操作只需要 `moon`。`pipeline/` 下的 Python 脚本是**旧版工具链，仅留档**，不参与
> 日常构建（唯一例外是 `make_assets.py`，只用来重画分享卡片与图标）。历史文档里出现的
> `python3 pipeline/analyze.py` 已不是本站的构建命令。

---

## 一、目录结构

```
.
├── app/                          MoonBit 工作台（当前工具链）
│   ├── *.mbt                      采集 fetch / 打分 rank / 构建 build / 预览 serve / 各页 pane_*
│   ├── assets/site/               站点源码：shell.html、app.js、style.css
│   ├── assets/static/             图标源文件（og.png、favicon.ico 等）
│   └── .mooncakes/                依赖（native-gui、async 等）
├── data/
│   ├── raw/                       原始快照，只增不改，用于复现
│   ├── scenarios.src.json         场景定义：分组、标题、简介、收录 / 排除规则
│   ├── i18n.json                  场景与分组的英文译文
│   ├── blurbs.json                「完整方案」的中英文简介
│   ├── build.json                 排序权重（在工作台保存权重后才生成）
│   ├── history.json              采集历史，长期累积，随仓库提交
│   ├── modules.json               合并去重后的模块表（生成产物）
│   ├── scenarios.json             站点数据源的中间形态（生成产物）
│   ├── moonbit_index.db           旧版 SQLite，当前工作台不再更新
│   └── .backup/<时间戳>/          保存前的人工源文件备份（已被 git 忽略）
├── dist/                         静态发布目录（产物入库，便于直接部署与差异追溯）
│   ├── index.html                 骨架，仅有样式与容器，不含数据
│   ├── assets/app.js              前端逻辑（路由、渲染、检索、趋势图）
│   ├── data/scenarios.json        前端唯一数据源
│   ├── scenarios.md               场景推荐报告
│   └── og.png / favicon.ico / apple-touch-icon.png
├── skills/moonbit-stack-selection/
│   ├── SKILL.md                   选型 skill 入口（手写，不被生成覆盖）
│   └── references/                生成，一场景 1–2 份 md
├── docs/                          本文所在：data / methodology / maintenance / verify
├── pipeline/                      旧版 Python 工具链，仅留档
├── promo/                         推广文稿
├── scenarios.md                   场景推荐报告（生成产物）
├── wrangler.toml                  Cloudflare Pages 直传配置
└── README.md                      使用者入口：网站与 skill 怎么用
```

`dist/`、`scenarios.md` 与 `skills/…/references/` 内文件均由构建生成，**不应手动修改**。
`data/history.json` 相反：它是长期累积的汇总，不是生成产物。

---

## 二、构建

```bash
cd app && moon run . -- --build     # 等价于工作台里点「执行生成」
```

一次生成产出四类文件：

| 类别 | 文件 |
| --- | --- |
| 结构化中间产物 | `data/modules.json`、`data/scenarios.json` |
| 人读报告 | `scenarios.md`、`dist/scenarios.md` |
| 静态站点 | `dist/index.html`、`dist/assets/*`、`dist/data/scenarios.json` |
| skill 快照 | `skills/moonbit-stack-selection/references/*.md` |

读取 `data/raw/` 与 `data/` 中的既有数据，重算榜单并输出全部产物。运行环境是 MoonBit 工具链，
产物写回仓库，**不依赖 Python**。`SKILL.md` 手写、不会被覆盖；`references/` 每次生成重写。

其它命令行档（都在 `app/` 目录下执行）：

```bash
moon run .                        # 打开工作台窗口
moon run . -- --build             # 只生成产物
moon run . -- --fetch             # 只采集注册表数据
moon run . -- --fetch --fetch-owners 3   # 冒烟档：只采前 3 个 owner，不落盘
moon run . -- --check             # 读一遍数据打印概况，不写文件
moon run . -- --save              # 读一遍原样写回，验证「不改字段不产生差异」
moon run . -- --probe [url]       # 网络自检：取一条 URL，打印耗时与正文大小
moon run . -- --serve [port]      # 本地预览 dist/（默认 8000，Ctrl+C 停止）
moon test                         # 单元测试（采集历史等）
```

`npm run build` 也指向同一条构建命令；`npm run preview` 起本地静态服务。

### 仓库地址与站点域名

`app/build.mbt` 顶部的 `REPO` 与 `SITE` 是**唯一来源**，构建时替换 `shell.html` 与 `app.js` 里的
`@@REPO@@` / `@@SITE@@`：

- `REPO` → 标题栏 GitHub 图标、页脚反馈链接、skill 的 raw 链接；
- `SITE` → `og:url` / `og:image` 绝对地址、在线版单场景页链接。

换域名时改这两行再生成一次即可，不要在产物里手改。`og:` 必须是绝对 URL，抓取方不解析相对
路径，改漏了分享出去的卡片就是空白。

---

## 三、工作台

```bash
cd app && moon run .
```

| 页 | 能改什么 / 做什么 | 落在哪个文件 |
| --- | --- | --- |
| 场景管理 | 场景标题、简介、补充说明（中英）、图标、分组、顺序；收录规则（`kw` / `core` / `pin` / `force` / `ex` / `top` 等）；新增与删除场景 | `data/scenarios.src.json` + `data/i18n.json` |
| 场景管理 | 每个「完整方案」的中英文简介 | `data/blurbs.json` |
| 包数据 | 单个包的简介、收录与移出、所属场景 | `data/blurbs.json` + `data/scenarios.src.json` |
| 数据更新 | 抓注册表快照、补下载量、记历史点 | `data/raw/*` + `data/history.json` |
| 数据生成 | 重算榜单、输出站点与 skill；可改排序权重 | `dist/`、`scenarios.md`、`skills/…/references/`、`data/build.json` |

保存只写文件、不跑构建；要看到新排名得回「数据生成」点一次。工作台保存前会把人工源文件备份到
`data/.backup/<时间戳>/`，改坏了也可用 `git checkout -- data/` 取回上版。

**包数据页的本地搜索**：范围是本地快照的全部包（`data/raw/modules_api.json` 落下来的几千条），
按包名 / 描述 / 关键词任一命中，不联网。它解决两件以前做不到的事——候选只显示前 60 条，排在
后面的翻不到；注册表里有、但场景关键词规则没命中的包，也没处查。命中但不在当前候选里的单列
一卡，点行看详情或直接「加入本场景」。刷新由回车 / 点搜索 / 清空触发，不是逐键：逐键要每敲
一个字就重排一遍全库并重建整页，打字会顿。

**为什么不做成线上编辑**：站点是纯静态托管，没有可写的后端；而选包清单的每次改动都应该留在
git 里，本地改完再提交，比从浏览器直接推仓库更可控。

---

## 四、部署至 Cloudflare Pages

产物是纯静态文件且已随仓库提交，因此有两种方式，选一种即可。

**方式一：Git 集成（推荐，push 即发布）**

1. Cloudflare 控制台 → Workers & Pages → 创建 → Pages → 连接到 Git，授权并选中本仓库；
2. 分支选 `main`，框架预设选 `None`；
3. **构建命令留空**，**构建输出目录填 `dist`**；
4. 保存并部署，站点落在 `moonbit-ecosystem-index.pages.dev`。

之后每次 `git push` 都会自动发布一次新产物，云端不执行任何构建。

**方式二：本地直传**

```bash
npx wrangler pages deploy dist --project-name moonbit-ecosystem-index
```

首次运行会打开浏览器完成 Cloudflare 授权，并自动创建同名项目；`wrangler.toml` 里的
`pages_build_output_dir` 已指向 `dist`。

本项目未采用「在 Cloudflare 上运行构建」的方式：Pages 的构建镜像以 Node.js 为主，MoonBit
工具链可用性不作保证；而站点产物为纯静态文件，本地构建后上传即可满足需求。若确实需要云端
重建（例如以后加定时抓取），把构建命令改为 `cd app && moon run . -- --build` 即可——
`data/raw/` 已在仓库内。

### 分享卡片与站点图标

链接被分享到微信、Discord、Slack、X 时显示成什么样，由 `<head>` 里的 `og:` 一组标签决定。
抓取方不执行 JavaScript，所以这组标签是**静态中文默认值**，站内的语言切换不会改动它们。

```bash
python3 pipeline/make_assets.py     # 仅在改配色、改文案或换域名后需要重跑
```

| 产物 | 用途 |
| --- | --- |
| `dist/og.png` | 1200×630 分享卡片，`og:image` 与 `twitter:image` |
| `dist/assets/favicon.svg` | 矢量图标，现代浏览器优先使用 |
| `dist/favicon.ico` | 16/32/48 三档，兜住旧客户端与对 `/favicon.ico` 的硬请求 |
| `dist/apple-touch-icon.png` | 180×180，iOS 添加到主屏 |

`make_assets.py` 不参与日常构建：这些产物已入库，只有内容变了才需要重跑。它依赖 Pillow
（画图标）与本机 Chrome（把 `pipeline/og.html` 截成卡片）；缺 Chrome 时只更新图标、卡片保持
原样，不会留下半张图。卡片本身是 `pipeline/og.html`，改文案直接改这个文件。

### 本地预览

```bash
cd app && moon run . -- --serve        # 默认 8000；换端口用 --serve 8080
```

访问 `http://127.0.0.1:8000`。服务由 `app/serve.mbt` 实现，基于 `@async/http` 的
`Server`，只把 `dist/` 下的文件递出去（挡目录穿越，按扩展名给 MIME，`Cache-Control:
no-cache`）。**必须通过 HTTP 打开**：数据由前端 `fetch` 加载，直接双击以 `file://`
打开会被浏览器同源策略拦截，页面会提示加载失败并给出上述命令。`Ctrl+C` 停止。

---

## 命令行查询

```bash
moon run . -- --check             # 分组 / 场景 / 模块 / 简介条数，并列出全部分组
```

要看某个包的详情，或按名字、描述、关键词搜包，用工作台「包数据」页的本地搜索（不联网，
覆盖本地快照的全部包）。要看生成后的完整数据，直接读 `data/scenarios.json` /
`dist/data/scenarios.json`。

旧版的 `pipeline/query.py` 读本地 SQLite，其中保留了下载量原始值，曾用于比对排序是否合理、
排查场景归属。`data/moonbit_index.db` 由旧 `pipeline/analyze.py` 写入，工作台的「数据生成」
**不再更新它**，数据会停在最后一次跑旧脚本的时间，不能当作当前数据使用；该脚本仅留档，
不建议再跑。

---

## 提交

`docs/verify.md` 第 8 节给出按功能拆分的提交顺序。要点：`data/history.json` 跟着 `data/`
一起提交（漏提交等于清空趋势图历史）；`dist/` 与 `skills/…/references/` 是产物，但本项目
**有意入库**，便于直接部署与差异追溯。
