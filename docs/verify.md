# 验收清单

这份清单对应「MoonBit 数据工作台 + 选型 skill 拆分」这一批改动。机器能算的部分已由命令行核对过（标注**已核对**），余下需要人眼看的部分按节操作。

全部在仓库根目录 `/path/to/moonbit-eco-index` 下执行。

---

## 0. 前置

```bash
cd app && ~/.moon/bin/moon build     # 已核对：通过，零警告
```

启动工作台：

```bash
cd app && ~/.moon/bin/moon run .
```

不改代码、只想跑一遍生成：

```bash
cd app && ~/.moon/bin/moon run . -- --build   # 不开窗，跑完即退
```

**验收会写数据文件。** 先留一份退路：

```bash
cp data/scenarios.src.json /tmp/verify-scenarios.src.json
cp data/blurbs.json        /tmp/verify-blurbs.json
cp data/build.json         /tmp/verify-build.json
```

回滚：

```bash
cp /tmp/verify-scenarios.src.json data/scenarios.src.json
cp /tmp/verify-blurbs.json        data/blurbs.json
cp /tmp/verify-build.json         data/build.json
git checkout -- data dist           # 连生成产物一起还原
```

---

## 1. 五分钟快速线（最小必过集）

| # | 操作                              | 期望                                        |
| - | ------------------------------- | ----------------------------------------- |
| 1 | 切四个段：场景管理 → 包数据 → 数据更新 → 数据生成什么 | 每段右侧正常渲染；更新与生成两页左侧无场景树                    |
| 2 | 场景管理：点左树任一场景                    | 右侧出表单，顶栏标题、按钮一行整齐                         |
| 3 | 切到包数据，点列表任意一行                   | 进入详情屏，顶栏最左是「← 返回列表」                       |
| 4 | 点「← 返回列表」什么什么什么                 | 回到列表，滚动位置与进来前一致                           |
| 5 | 数据生成页，点「执行生成」                   | 日志出现「完成：模块 … / 场景 … / 方案包 …」与「skill 落在 …」 |

五条全过即可认为功能面无阻塞；下面按模块细查。

---

## 2. 产物（命令行，无需开窗）

```bash
cd skills/moonbit-stack-selection
find . -type f | wc -l              # SKILL.md + references 下的全部 md
ls references/*.md | wc -l
ls references/*-libs.md | wc -l     # 有分册的场景数，应与总表里「文件」列出现「全量」的行数相同
du -sh references
```

**已核对**：每个索引页尾部若写「其余基础库见 `<id>-libs.md`」，对应分册必定存在，反之亦然；
md 与总表里都不再有候选计数。

抽查四份：

```bash
sed -n 1,10p references/gui.md        # 头部：标题 / 英文副题 / 快照 + 在线版 / 简介
tail -3    references/wasm.md         # 指针：「*其余基础库见 [wasm-libs.md](wasm-libs.md) 全量分册。*」
head -6    references/wasm-libs.md    # 分册头：快照 + 返回索引页 + 在线版，无数量
sed -n 1,16p references/scenarios.md  # 总表：| 场景 | id | 文件 |，三列无计数
```

数量只应出现在数据里，文档与 skill 里不该复述：

```bash
grep -rn "个模块\|个场景\|共 [0-9]\+ 个\|前 [0-9]\+ 个" references/*.md | grep -v "每个场景"
```

期望无输出（命中「每个场景一份索引页」这类正常用词不算）。站点骨架同理：

```bash
grep -c "@@SCENARIOS@@\|@@MODULES@@" dist/index.html   # 0，占位符已移除
grep -c "[0-9]\+ 个" dist/index.html                   # 0，数量由前端读 scenarios.json 后填
```

幂等（连续两次生成，文件内容不变）：

```bash
cd skills/moonbit-stack-selection/references
find . -name '*.md' -exec md5sum {} + | sort | md5sum
cd ../../../app && ~/.moon/bin/moon run . -- --build >/dev/null
cd ../skills/moonbit-stack-selection/references
find . -name '*.md' -exec md5sum {} + | sort | md5sum   # 与上一次相同
```

> 唯一可能变的是采集日期行——它取自数据快照而非当前时间，正常两次应完全一致。

---

## 3. 场景管理

| #  | 操作                    | 期望                                       |
| -- | --------------------- | ---------------------------------------- |
| S1 | 左树点一个分组（`g:` 开头）      | 顶栏「分组 + id」，右侧是分组名与排序表单                  |
| S2 | 左树点一个场景               | 顶栏「图标 场景名 + id」，右侧表单含名称、排序、所属分组、收录规则     |
| S3 | 改名称 → 保存              | 状态行提示已保存，左树该行文字同步变化                      |
| S4 | 顶栏「上移 / 下移」           | 该场景在同组内移动，左树立即反映                         |
| S5 | 「新建场景」→ 填 id → 保存并加入  | 新场景落在当前分组末尾并自动选中；id 与已有重复时应被拒            |
| S6 | 「多选」→ 勾两个以上场景         | 底部浮出条：`已选 N 个场景｜改到该分组 ▾｜清空选择`；**列表不上下跳** |
| S7 | 选一个目标分组 → 「改到该分组」     | 所选场景整体挪到该组末尾，状态行提示数量                     |
| S8 | 「删除」→ 同一按钮变「确认删除」→ 再点 | 二次确认后移除；只点一次不会删（3 秒后自动复位）                |
| S9 | 切到包数据再切回              | 「多选」按钮标签回到「多选」，勾选已清空                     |

S6 失败（页面抖动）看 `app/pane_dock.mbt`；S8 失败看 `app/window.mbt` 的 `drop_scenario`。

---

## 4. 包数据

### 4.1 左栏与对齐

| #  | 操作                   | 期望                                       |
| -- | -------------------- | ---------------------------------------- |
| P1 | 切到包数据                | 左栏顶部「新建场景 / 多选」两个按钮**消失**，场景树整体上移        |
| P2 | 同屏对比左右顶边             | 左树面板上边框与右侧顶栏上边缘在**同一条水平线**（差 0～1px 属抗锯齿） |
| P3 | 在场景管理 / 包数据之间来回切 3 次 | 左树不上下跳，位置稳定                              |

P2 是此前 8px 错位的复检点，失败看 `app/window.mbt` 的 `left_panel`（`row_gap=0` + 工具行 `margin_bottom=12`）。

### 4.2 列表屏

顶栏应为：`<图标> 场景名 · 包数据`、`候选 N 条｜点一行进入编辑`。

| #  | 操作           | 期望                                                                   |
| -- | ------------ | -------------------------------------------------------------------- |
| P4 | 勾选若干行        | 底部浮出：`已选 N 个包｜标为方案 / 置顶 / 强制收录 / 移出本场景 / 清空` + `加入场景 ▾ / 加入`；列表本身不位移 |
| P5 | 「标为方案」→ 清空选择 | 状态行提示数量；被标的包在列表中带上方案标记                                               |
| P6 | 展开「已移出」区     | 列出本场景显式移出的包，行内有「放回」                                                  |

### 4.3 详情屏

| #   | 操作                 | 期望                                                 |
| --- | ------------------ | -------------------------------------------------- |
| P7  | 点一行进入              | 顶栏：`← 返回列表`、包名、`场景名 · 下载 N`，右端 `选场景 ▾ + 加入场景 + 保存` |
| P8  | 进 / 出详情反复 3 次      | 顶栏高度不变、滚动区上沿不跳（列表顶栏与详情顶栏同高）                        |
| P9  | 改中文简介 → 保存         | 状态行「已保存 X（简介 / 关联度）」；返回列表再进来，内容仍在                  |
| P10 | 正文「所属场景」           | 列出显式收录它的场景；本场景标「（本场景）」；其他场景带「移出」                   |
| P11 | 顶栏选一个目标场景 → 加入场景   | 状态行「已把 X 加入「Y」；在「Z」里的位置不变」；下拉自动复位为「选场景」            |
| P12 | 左树切到 Y → 包数据 → 找该包 | 出现在 Y 的候选里；点进去「所属场景」同时列出 Z 与 Y                     |
| P13 | 在 Y 里点 Z 那行的「移出」   | 只影响 Z，Y 不变                                         |
| P14 | 找一个所属场景已覆盖全部场景的包   | 顶栏右侧显示「其他场景都已收录」，不出下拉                              |
| S1  | 包数据列表，输入框打一行字后按回车   | 候选只剩命中项，顶栏副标题变成「搜索「xxx」｜候选 N 条」，卡片底部显示命中数 / 显示前几条。回车前**打字不卡**（每次按键不重建整页） |
| S2  | 搜一个不在当前场景候选里的包（例如在某场景搜 `http`） | 下面出现「本地快照命中（N）」卡片，按下载量降序；点行进详情，「加入本场景」直接收进候选 |
| S3  | 点输入框的 ×（清空）        | 立刻回到全量候选，不用再按回车                                     |
| S4  | 搜一个必然没有的词           | 候选区显示「候选里没有匹配「xxx」的包」，不出空卡片                         |
| S5  | 搜索后切到另一个场景再回来       | 搜索词保留（它在 `pkg_q`，不在 form 缓存里），结果按新场景重新算                    |

S1/S2 失败先看 `app/pane_pkg.mbt` 的 `module_hit`（包名 / 描述 / 关键词，全小写比）与 `pkg_q` 是否被加进了 `refresh_pane` 的 key；只在回车 / 点搜索 / 清空时刷新是**故意**的（逐键刷新会每键重排全库，打字必顿）。

P8 失败看 `app/pane_scene.mbt` 的 `HEAD_H`；P11/P13 失败看 `app/pane_pkg.mbt` 的 `add_to_scenario` / `remove_elsewhere`。

### 4.4 滚动

| #   | 操作           | 期望                |
| --- | ------------ | ----------------- |
| P15 | 详情页滚到底，再返回列表 | 列表回到进入时的位置，不是停在页首 |
| P16 | 切换场景 / 切换段   | 滚动位置归零            |

---

## 5. 数据更新 / 数据生成

| #  | 操作                      | 期望                                                                               |
| -- | ----------------------- | -------------------------------------------------------------------------------- |
| J1 | 两页检查左栏                  | 无场景树，内容区占满宽度                                                                     |
| J2 | 两页顶栏                    | 标题与按钮同高，与包数据页顶栏一致                                                                |
| J3 | 生成页改一个权重 → 「保存权重」       | 状态行「排序权重已写入 data/build.json」；`git diff data/build.json` 只应有那一处                   |
| J4 | 「执行生成」                  | 日志：完成行 + 「skill 落在 skills/moonbit-stack-selection｜提交并推送后即同步到 GitHub」；状态行显示仓库相对路径 |
| J5 | 生成后查 Git                | `git status` 中 `skills/` 下 `references/*.md` 为新增或修改；手写的 `SKILL.md` 不被覆盖          |
| J6 | 更新页「执行更新」（可选，需联网，**全量耗时以小时计**，串行不并发） | 日志逐条推进、进度行约 30 秒一条；结束后模块表条数变化；中途失败应有「采集失败，见日志」而非静默。只想看流程是否通，跑一分钟就按「停止采集」即可           |
| J6a | 采集进行中，去切别的页、滚动、点按钮 | **窗口正常响应**：段切换即刻生效、日志继续推进。这是这次改动的核心——旧版在这里会整窗僵住 |
| J6b | 采集进行中，按顶栏「停止采集」 | 按钮回到「执行更新」，日志末行提示下载量 / 采集日期 / 历史点未写入、模块清单已刷新；`data/raw/downloads.json`、`meta.json`、`data/history.json` 无改动（`modules_api.json` 在 phase 0 已落盘，属预期） |
| J6c | 采集进行中，最小化再还原 / 拖窗口 | 窗口不白屏、不假死；采集仍在推进（日志有时间戳的进展行） |
| J6d | 采集进行中盯日志列表            | 每来一行新日志，列表**自动滚到最底**，末尾那行始终可见；往上滚动滚轮后停住（可读旧行），再往下滚一下恢复跟随 |
| J6e | 采集跑过几百行后继续盯           | 帧率不变、滚轮跟手（日志是虚拟列表，只挂可见的十几行）。旧版用 textarea 装整段文本，行数一多每帧都在重排，会肉眼可见地变卡 |
| J6f | 采集进行中切到「数据生成」页再点「执行生成」 | 生成页只显示生成自己的日志（完成行 / skill 落点），**采集日志不被覆盖**；切回更新页，采集日志仍在、仍在推进 |
| J6g | 生成完成后切回更新页并继续采集 | 两边日志各自独立：更新页是采集行 + 状态行，生成页是生成行，互不串联 |
| J7 | 采集完成后核对覆盖                  | `downloads.json` 的键数等于 `modules_api.json` 的条目数（大小写重复的记录各算一条，缺 0）                       |
| J8 | 生成后核对模块表条数                 | 日志「模块表 N 条」比采集条目略少，差额正是大小写重复的历史记录被去重掉的那几条                                 |
| J9 | 一次全量采集完成后查 `data/history.json` | `points` 多一条（**同日重跑仍只有当天那一条**，不新增）；日志有「⑤ 历史：N 个包 / 累计 … 次下载」与「较 YYYY-MM-DD：包 +N，下载 +M」。冒烟档与中途「停止采集」都不写这一点 |
| J10 | 「执行生成」后核对产物                 | `dist/data/scenarios.json` 有 `history` 数组，条数与 `data/history.json` 一致，每点形如 `[日期, 包数, 累计下载]`；`data/modules.json` 的单包下载量仍不出现在产物里 |
| J11 | 用 `moon run . -- --serve` 打开站点首页 | 导语下方有「生态增长」卡片：蓝线包数量、绿线累计下载，左右各一根纵轴，图例给最新值及较上次的增量；悬停任一点出该次完整数值。只有 1 条记录时改为一句说明、不画折线；删掉 `history` 则整块卡片不出现，其余页面正常 |
| J12 | 窗口收窄到 620px 以下                 | 图表换紧凑版：左右纵轴刻度都留在卡片内、没有横向滚动条，刻度与日期标签不重叠；再拉宽能自动换回来，首页滚动位置不跳 |

J9 / J10 的核对命令（不开窗）：

```bash
node -e '
const fs = require("fs");
const r = p => JSON.parse(fs.readFileSync(p, "utf8"));
const h = r("data/history.json").points;
const d = r("dist/data/scenarios.json");
const m = r("data/modules.json");
console.log("历史点", h.length, "产物点", (d.history || []).length);
console.log("末点", h.at(-1));
console.log("与模块表一致:", h.at(-1).packages === Object.keys(m).length);
const dates = h.map(p => p.date);
console.log("日期升序且同日唯一:", dates.every((x, i) => i === 0 || x > dates[i - 1]));
console.log("产物形状:", d.history[0]);
'
```

期望：两个点数相等；末点 `packages` 等于模块表条数；日期升序且无重复；产物里每点是
三项数组 `[日期, 包数, 累计下载]`。

J6 会覆盖 `data/raw/` 与 `data/modules.json`，不想动数据就跳过。

采集是**严格串行**的（一条 for 循环、每条收工后再歇 0.8 秒、失败退避重试），全量一次
以小时计属正常，不是卡住。想确认它没在偷偷并发，看日志：任意时刻只该有一条「→」后面
还没跟「←」。日志里每条都带地址、耗时、大小与覆盖增量。

模块清单那条会在正文到达途中每 2 秒刷一行 `↓ 已收 128 KB（22.8s，约 5 KB/s）`，
状态行显示 `① 拉模块清单 · 已覆盖 0/… · 在等 模块清单（接收中 128 KB）`。看到这两处
在走，就说明不是卡死。

不动仓库数据就能验证链路（只采前几个 owner、跳过按名补齐、不落盘）：

```
cd app && moon run . -- --fetch --fetch-owners 3
```

不想开窗口就想确认「网络这条路通、非阻塞档可用」，可以跑一次自检（只发一条请求，不写任何数据）：

```bash
cd app && moon run . -- --probe                     # 默认取一次搜索接口
cd app && moon run . -- --probe https://mooncakes.io/api/v0/modules
```

期望：`已发起 pid=…` → `poll N 次后结束（档位 1），耗时 … ms，正文 … 字节`。
「档位 1」= 正常退出；同一个进程在请求期间没有停等，这就是窗口不卡的原因。

J7 的核对命令：

```bash
node -e '
const fs = require("fs");
const r = p => JSON.parse(fs.readFileSync(p, "utf8"));
const a = r("data/raw/modules_api.json");
const d = r("data/raw/downloads.json");
const names = a.filter(m => m.name).map(m => m.name);
const miss = names.filter(n => !(n in d));
console.log("模块", names.length, "下载量键", Object.keys(d).length, "缺", miss.length, miss.slice(0, 5));
'
```

期望「缺 0」。若有少量缺失，先看日志里有没有「! 跳过 owner」，那说明是网络问题而非匹配问题；重跑一次即可补上。

J8 说明：采集阶段不去重，`/modules` 里同一个包可能存着大小写不同的多条记录（重发或改名留下的）。生成阶段 `load_modules()` 按小写名归并，保留版本高的一条，因此模块表条数会少于采集条目数。当前快照里是 2 组 4 条：

```
xunyoyo/permutation  0.1.3  ← 保留
xunyoyo/Permutation  0.1.1
youyong5/moontetris  0.1.0 16:47 ← 保留
youyong5/MoonTetris  0.1.0 16:29
```

---

## 6. 数据安全（往返零变更）

| #  | 操作                     | 期望                                                              |
| -- | ---------------------- | --------------------------------------------------------------- |
| D1 | 启动工作台后，**不做任何编辑**，直接退出 | `git status` 中 `data/scenarios.src.json`、`data/blurbs.json` 无改动 |
| D2 | 打开某场景，点一次「保存」          | `git diff data/scenarios.src.json` 语义无变化（可能仅有格式差）               |
| D3 | 打开某包，点一次「保存」           | `git diff data/blurbs.json` 无变化，条目间空行不被压掉                       |
| D4 | 重复 D2/D3 各两次           | 无累积差异（幂等）                                                       |

D2/D3 失败看 `app/store.mbt` 的保存链路与 `app/util.mbt` 的 `notes_gap`。

---

## 7. 已知问题（不作为验收项）

| 现象                | 说明                                                     |
| ----------------- | ------------------------------------------------------ |
| emoji 显示为方块       | native-gui 无字体回退，属库缺陷；场景图标改用文字可规避                      |
| Windows 上写二进制产物失败 | `@sys` 无 `write_bytes`，图标靠 `cp` 复制，Windows 需另作处理       |
| 站点抓不到内容           | 站点为前端渲染，`pages.dev` 直取只有空壳；机器可读请取 `references/<id>.md` |
| raw 链接 404        | `skills/` 尚未推送；`git push` 后生效                          |

---

## 8. 提交

验收通过后按功能拆成三次提交：

```bash
cd /path/to/moonbit-eco-index

git add app/ && git commit -m "feat(app): MoonBit 原生数据工作台（场景 / 包 / 更新 / 生成）"

git add skills/ && git commit -m "feat(skill): 一场景一索引页 + 基础库分册，随仓库分发"

git add README.md docs/ data/ dist/ pipeline/ \
  && git commit -m "docs/data: 同步生成产物、目录结构与验收清单；删除已被取代的 build_skill.py"

git push
```

`data/history.json` 是长期累积文件（跟着 `data/` 一起 add），别当成生成产物忽略掉：
漏提交等于把站点趋势图的历史清空，后续采集只会从第一个点重新开始。

推送后复验一处：raw 链接应能取到内容。

```bash
curl -sI https://raw.githubusercontent.com/lb091188/moonbit-ecosystem-index/main/skills/moonbit-stack-selection/references/gui.md | head -1
# 期望 HTTP/2 200
```

---

## 9. 收尾（待定）

本机 `~/.workbuddy/skills/moonbit-stack-selection/` 仍是旧布局（含已废弃的 `data/index.json` 与 `query.py`），WorkBuddy 会话里加载的是它。两种处理：

```bash
# 软链：一处真身，git pull 即刷新
rm -rf ~/.workbuddy/skills/moonbit-stack-selection
ln -s "$(pwd)/skills/moonbit-stack-selection" ~/.workbuddy/skills/moonbit-stack-selection

# 或复制：需要手动重新拷贝
rm -rf ~/.workbuddy/skills/moonbit-stack-selection
cp -r skills/moonbit-stack-selection ~/.workbuddy/skills/
```

这一步动家目录，确认后再执行。
