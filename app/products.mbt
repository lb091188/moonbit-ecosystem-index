// 产物生成：站点数据、Markdown 报告、静态站点文件、选型 skill 快照。

///|
pub fn collapse_ws(s : String) -> String {
  let out = StringBuilder()
  let mut pending = false
  let mut started = false
  for c in s {
    let sp = c == ' ' || c == '\t' || c == '\n' || c == '\r'
    if sp {
      if started {
        pending = true
      }
    } else {
      if pending {
        out.write_char(' ')
        pending = false
      }
      out.write_char(c)
      started = true
    }
  }
  out.to_string()
}

///|
pub fn murl(name : String) -> String {
  "https://mooncakes.io/docs/" + name
}

///|
pub fn now_stamp() -> String {
  match @sys.pr_run("date", ["+%Y-%m-%d %H:%M"], timeout_ms=3000) {
    Ok(o) => o.stdout.trim().to_owned()
    Err(_) => "—"
  }
}

///|
pub fn solution_names(ranked : Array[Ranked]) -> Array[String] {
  let out : Array[String] = []
  for r in ranked {
    for it in r.items {
      if it.tier == "solution" && !out.contains(it.name) {
        out.push(it.name)
      }
    }
  }
  out
}

// ---------------------------------------------------------------- 站点数据

///|
pub fn scenarios_payload(
  studio : Studio,
  ranked : Array[Ranked],
  built_at : String,
) -> Json {
  let sols = solution_names(ranked)
  let mut with_sol = 0
  for r in ranked {
    if !r.split("solution").is_empty() {
      with_sol = with_sol + 1
    }
  }
  let mut yanked = 0
  let modules : Map[String, Json] = Map([])
  for name in studio.modules.keys() {
    let m = studio.modules[name]
    if m.yanked {
      yanked = yanked + 1
    }
    let a : Array[Json] = [
      json_str(m.version),
      json_str(trunc(collapse_ws(m.description), 150)),
      json_int(if m.yanked { 1 } else { 0 }),
    ]
    modules[name] = @json.to_json(a)
  }
  let groups : Array[Json] = []
  for g in studio.cat.groups {
    let en = match studio.i18n_groups.get(g.id) {
      Some(v) => v
      None => ""
    }
    let pair : Array[Json] = [json_str(g.title), json_str(en)]
    let row : Array[Json] = [json_str(g.id), @json.to_json(pair)]
    groups.push(@json.to_json(row))
  }
  let scenes : Array[Json] = []
  for r in ranked {
    let en = match studio.i18n_scen.get(r.id) {
      Some(v) => v
      None => ("", "", "")
    }
    let sol : Array[Json] = []
    for it in r.items {
      if it.tier == "solution" {
        sol.push(json_str(it.name))
      }
    }
    let lib : Array[Json] = []
    for it in r.items {
      if it.tier == "lib" {
        lib.push(json_str(it.name))
      }
    }
    let title : Array[Json] = [json_str(r.title), json_str(en.0)]
    let intro : Array[Json] = [json_str(r.intro), json_str(en.1)]
    let note : Array[Json] = [json_str(r.note), json_str(en.2)]
    scenes.push(
      json_obj([
        ("id", json_str(r.id)),
        ("group", json_str(r.group)),
        ("title", @json.to_json(title)),
        ("icon", json_str(r.icon)),
        ("intro", @json.to_json(intro)),
        ("curated", json_bool(r.curated)),
        ("note", @json.to_json(note)),
        ("sol", @json.to_json(sol)),
        ("lib", @json.to_json(lib)),
      ]),
    )
  }
  let bl : Map[String, Json] = Map([])
  for (name, pair) in studio.blurbs {
    if sols.contains(name) {
      let a : Array[Json] = [
        json_str(if pair.length() > 0 { pair[0] } else { "" }),
        json_str(if pair.length() > 1 { pair[1] } else { "" }),
      ]
      bl[name] = @json.to_json(a)
    }
  }
  // 趋势：每次采集一个点，`[日期, 包数, 累计下载]`。只放全生态汇总，单包下载量
  // 依旧不进产物（见 docs/methodology.md「为什么站内不展示下载量」）。
  let hist : Array[Json] = []
  for p in read_history(studio.root) {
    hist.push(
      @json.to_json([json_str(p.date), json_int(p.packages), json_num(p.downloads)]),
    )
  }
  json_obj([
    ("schema_version", json_int(2)),
    (
      "meta",
      json_obj([
        ("collected_at", json_str(studio.collected_at)),
        ("built_at", json_str(built_at)),
        ("modules", json_int(studio.modules.length())),
        ("yanked", json_int(yanked)),
        ("scenarios", json_int(studio.cat.scenarios.length())),
        ("with_solutions", json_int(with_sol)),
        ("solution_packages", json_int(sols.length())),
      ]),
    ),
    ("history", @json.to_json(hist)),
    ("groups", @json.to_json(groups)),
    ("scenarios", @json.to_json(scenes)),
    ("modules", @json.to_json(modules)),
    ("blurbs", @json.to_json(bl)),
  ])
}

// ---------------------------------------------------------------- Markdown 报告

///|
fn md_table(
  lines : Array[String],
  studio : Studio,
  rows : Array[RankItem],
  limit : Int,
) -> Unit {
  lines.push("| # | 包 | 版本 | 说明 |")
  lines.push("|---|---|---|---|")
  let n = if rows.length() < limit { rows.length() } else { limit }
  for i = 0; i < n; i = i + 1 {
    let it = rows[i]
    let m = match studio.modules.get(it.name) {
      Some(x) => x
      None => Module::make(it.name)
    }
    let pair = studio.blurb(it.name)
    let zh = if pair.length() > 0 { pair[0] } else { "" }
    let mut desc = if zh != "" { zh } else { collapse_ws(m.description) }
    let cut = if zh != "" { 110 } else { 80 }
    if desc.char_length() > cut {
      desc = trunc(desc, cut) + "…"
    }
    desc = desc.replace_all(old="|", new="\\|")
    if desc == "" {
      desc = "—"
    }
    lines.push("| \{i + 1} | [\{it.name}](\{murl(it.name)}) | \{m.version} | \{desc} |")
  }
  lines.push("")
}

///|
pub fn report_md(studio : Studio, ranked : Array[Ranked]) -> String {
  let lines : Array[String] = []
  lines.push("# MoonBit 生态：场景化选包指南\n")
  lines.push("> 覆盖 \{studio.modules.length()} 个已发布模块；被 yanked 的包不计入推荐。\n")
  lines.push(
    "数据源：mooncakes.io 官方 API（模块元数据）。本索引仅做场景导航，不复制注册表能力：版本历史、完整 API 文档与依赖关系请到 mooncakes 包页查看，报告内包名均指向该页。\n",
  )
  lines.push(
    "本报告不列下载量。清单顺序参考了注册表的下载量级，但该数字不作为事实对外呈现——它是累计计数，快照必然滞后，且容易被误读成「更适合」，而选型要看的是 API 形态与维护状态。\n",
  )
  lines.push(
    "> **数据时效**　采集于 \{studio.collected_at}，早于本报告的生成时间。本报告为离线生成的静态快照，不随注册表更新，不含此后的新增、版本变更与 yanked 标记；选型判断请以 mooncakes.io 及仓库实际状态为准。\n",
  )
  lines.push(
    "有完整方案的场景分两层：**完整方案**（能直接选型、定骨架的）与**基础库**（提供单点能力，由调用方组合）；尚无完整方案的场景不设分层，候选全部为基础库。框架、引擎、运行时、脚手架、ORM 均属「完整方案」的不同形态。「基础库」不等同于「依赖」：在 mooncakes 生态中，完整方案本身同样是依赖，分层的唯一标准是该包能否接管程序结构。\n",
  )
  lines.push(
    "清单顺序在构建时确定，序号表示该场景内的推荐次序，不是下载量排行；同义词已做词干归一（如 async/asynchronous），并对易混淆场景做了排除（如 UI 场景排除 TUI）。\n",
  )
  lines.push(
    "「完整方案」的说明为人工撰写（`data/blurbs.json`），回答的是「它替你做了哪些决定、什么情况下该选它」；基础库的说明取自注册表原描述。\n",
  )
  lines.push("## 目录\n")
  for r in ranked {
    let sol = r.split("solution")
    let lib = r.split("lib")
    let tag = if sol.is_empty() { "无方案" } else { "方案 \{sol.length()}" }
    lines.push("- [\{r.title}](#\{r.id}) — \{tag} / 基础库 \{lib.length()}")
  }
  lines.push("")
  for r in ranked {
    let sol = r.split("solution")
    let lib = r.split("lib")
    lines.push("\n## \{r.title}\n")
    lines.push("\{r.intro}\n")
    if r.curated {
      lines.push(
        "> 本场景为**人工圈定**：候选包与其顺序由人工确定，因为该领域在生态里还没有形成可靠的关键词信号。\n",
      )
    }
    if r.note != "" {
      lines.push("> \{r.note}\n")
    }
    let top = if r.top > 0 { r.top } else { 8 }
    if !sol.is_empty() {
      lines.push("### 完整方案（\{sol.length()}）\n")
      md_table(lines, studio, sol, top)
      if sol.length() <= 2 {
        lines.push(
          "> 完整方案仅 \{sol.length()} 个，说明该类需求目前在生态中主要依靠基础库组合实现，下方基础库清单的实用价值更高。\n",
        )
      }
    } else {
      lines.push(
        "> 本场景**尚无完整方案**：生态中还没有框架或引擎级的实现。下列 \{lib.length()} 个候选均为基础库，需按需组合。\n",
      )
    }
    if !lib.is_empty() {
      lines.push("### 基础库（\{lib.length()}）\n")
      let limit = if sol.is_empty() { 12 } else { top }
      md_table(lines, studio, lib, limit)
    }
    if r.items.length() < 3 {
      lines.push(
        "\n> 候选数量偏少，表明该领域在生态中仍处早期阶段，可考虑自行实现或复用 `moonbitlang/x` 中的通用能力。",
      )
    }
  }
  lines.join("\n")
}

// ---------------------------------------------------------------- 静态站点

///|
fn read_asset(root : String, rel : String) -> String raise StudioError {
  read_text(join(join(root, "app/assets"), rel))
}

///|
pub fn write_site(
  studio : Studio,
  ranked : Array[Ranked],
  repo : String,
  site : String,
) -> Unit raise StudioError {
  let root = studio.root
  let dist = join(root, "dist")
  let shell = read_asset(root, "site/shell.html")
  let css = read_asset(root, "site/style.css")
  let app_js = read_asset(root, "site/app.js").replace_all(old="@@REPO@@", new=repo)
  // 骨架里不写包数、场景数：数量由前端读 data/scenarios.json 的 meta 得到，
  // 采集后数字变了也不用重新生成 HTML。
  let doc = shell
    .replace_all(old="@@CSS@@", new=css)
    .replace_all(old="@@SITE@@", new=site)
    .replace_all(old="@@REPO@@", new=repo)
  write_text(join(dist, "index.html"), doc)
  write_text(join(dist, "assets/app.js"), app_js)
  for name in ["og.png", "favicon.ico", "apple-touch-icon.png"] {
    copy_file(join(join(root, "app/assets/static"), name), join(dist, name))
  }
  copy_file(
    join(root, "app/assets/static/assets/favicon.svg"),
    join(dist, "assets/favicon.svg"),
  )
  write_text(join(dist, "scenarios.md"), report_md(studio, ranked))
}

// ---------------------------------------------------------------- skill 快照

///|
fn pair_of(j : Json) -> (String, String) {
  match j {
    Json::Array(a) if a.length() >= 2 => (jstr(a[0]), jstr(a[1]))
    _ => ("", "")
  }
}

///|
fn end_period(s : String) -> String {
  if s == "" || s.has_suffix("。") || s.has_suffix(".") {
    s
  } else {
    s + "。"
  }
}

///|
fn ver_of(v : String) -> String {
  if v == "" {
    ""
  } else {
    " v" + v
  }
}

///|
/// 站点走 hash 路由（`#/s/<id>`）：不带 id 的链接落回首页，人和 AI 拿到的都是空壳。
fn scene_url(id : String) -> String {
  SITE + "/#/s/" + id
}

///|
/// 站点是前端渲染的，直接抓页面拿不到数据；md 在 GitHub 上是纯文本，没装 skill 的
/// 一方（或没有浏览器的环境）可以直接取。
fn raw_base() -> String {
  REPO.replace_all(
    old="https://github.com/",
    new="https://raw.githubusercontent.com/",
  ) + "/main/skills/moonbit-stack-selection/references"
}

///|
fn raw_of(name : String) -> String {
  raw_base() + "/\{name}.md"
}

///|
/// 索引页收几个基础库。再多就另开 `<id>-libs.md`——wasm 247 个、parser 232 个，
/// 全塞进索引页会把它撑到两万字，按需读也读不动。
const LIB_CAP : Int = 30

///|
/// 一行一个基础库：名字、版本、注册表描述（截断）。
fn lib_line(name : String, mods : Json) -> String {
  let m = pair_of(jget(mods, name))
  // 注册表里没写描述的包不少，别留个「— —」的空壳。
  let d = if m.1 == "" {
    ""
  } else if m.1.char_length() > 110 {
    " — " + trunc(m.1, 110) + "…"
  } else {
    " — " + m.1
  }
  "- **`\{name}`**\{ver_of(m.0)}\{d}"
}

///|
/// 一个场景的索引页：`references/<id>.md`。
///
/// 只放「完整方案」全量与前 30 个基础库——基础库动辄 100+，全塞进来单文件就到两万字，
/// 按需读也读不动。超出的部分另出一份 `<id>-libs.md`，本页留一行指针。
fn scene_md(sc : Json, mods : Json, bls : Json, collected : String) -> String {
  let id = jstr(jget(sc, "id"))
  let title = pair_of(jget(sc, "title"))
  let intro = pair_of(jget(sc, "intro"))
  let note = jstr(jget(sc, "note"))
  let sols = jstrings(jget(sc, "sol"))
  let libs = jstrings(jget(sc, "lib"))
  let head = if title.0 != "" { title.0 } else { id }
  let lines : Array[String] = []
  lines.push("# \{head}（`\{id}`）")
  lines.push("")
  if title.1 != "" {
    lines.push("*\{title.1}*")
    lines.push("")
  }
  lines.push("> 快照 \{collected}｜在线版 <\{scene_url(id)}>")
  lines.push("")
  if intro.0 != "" {
    lines.push(end_period(intro.0))
    lines.push("")
  }
  if note != "" {
    lines.push("> \{note}")
    lines.push("")
  }
  lines.push("## 完整方案 · 可作骨架")
  lines.push("")
  if sols.is_empty() {
    lines.push("**无。** 该场景没有骨架级实现，只能用基础库组合。")
    lines.push("")
  } else {
    for i = 0; i < sols.length(); i = i + 1 {
      let name = sols[i]
      let m = pair_of(jget(mods, name))
      let b = pair_of(jget(bls, name))
      let blurb = if b.0 != "" { b.0 } else { m.1 }
      lines.push("\{i + 1}. **`\{name}`**\{ver_of(m.0)}")
      if blurb != "" {
        lines.push("   \{blurb}")
      }
      lines.push("   <https://mooncakes.io/docs/\{name}>")
      lines.push("")
    }
  }
  lines.push("## 基础库 · 单点能力，自行组合")
  lines.push("")
  if libs.is_empty() {
    lines.push("无。")
  } else {
    let n = if libs.length() < LIB_CAP { libs.length() } else { LIB_CAP }
    for i = 0; i < n; i = i + 1 {
      lines.push(lib_line(libs[i], mods))
    }
    if libs.length() > n {
      lines.push("")
      lines.push(
        "*其余基础库见 [\{id}-libs.md](\{id}-libs.md) 全量分册。*",
      )
    }
  }
  lines.push("")
  lines.join("\n")
}

///|
/// 基础库全量分册：`references/<id>-libs.md`，只在该场景基础库超过索引页容量时生成。
fn libs_md(sc : Json, mods : Json, collected : String) -> String {
  let id = jstr(jget(sc, "id"))
  let title = pair_of(jget(sc, "title"))
  let libs = jstrings(jget(sc, "lib"))
  let head = if title.0 != "" { title.0 } else { id }
  let lines : Array[String] = []
  lines.push("# \{head}（`\{id}`）· 基础库全量")
  lines.push("")
  lines.push(
    "> 快照 \{collected}｜按推荐次序列出｜返回 [\{id}.md](\{id}.md)｜在线版 <\{scene_url(id)}>",
  )
  lines.push("")
  lines.push(
    "单点能力，需自行组合；没有骨架级实现，不要当成框架推荐。",
  )
  lines.push("")
  for name in libs {
    lines.push(lib_line(name, mods))
  }
  lines.push("")
  lines.join("\n")
}

///|
/// 总表：只放定位信息（分组、场景、id、文件名），正文全在各自文件里。
/// 不写候选数、模块数这类会随采集变动的数字——要数量请读 `data/scenarios.json`。
fn scenarios_md(payload : Json) -> String {
  let meta = jget(payload, "meta")
  let scenes = jarray(jget(payload, "scenarios"))
  let groups = jarray(jget(payload, "groups"))
  let lines : Array[String] = []
  lines.push("# MoonBit 场景总表")
  lines.push("")
  lines.push("快照 \{jstr(jget(meta, "collected_at"))}｜场景按分组排列。")
  lines.push("")
  lines.push(
    "每个场景一份索引页 `references/<id>.md`：完整方案全量 + 基础库按推荐次序列出；基础库较多的场景另有 `<id>-libs.md` 全量分册。本表只用来定位 id。",
  )
  lines.push("")
  lines.push(
    "在线版单场景页：`https://moonbit-ecosystem-index.pages.dev/#/s/<id>`（如 `#/s/gui`）。站点是前端渲染的，直接抓页面拿不到数据；纯文本可直接取 \{raw_of("<id>")}。",
  )
  lines.push("")
  lines.push(
    "「完整方案」= 能当骨架、替你作决定的库；「基础库」= 只提供单点能力。场景内序号是推荐次序，不是下载量。",
  )
  lines.push("")
  for g in groups {
    let row = jarray(g)
    if row.length() < 2 {
      continue
    }
    let gid = jstr(row[0])
    let gp = jarray(row[1])
    let gtitle = if gp.length() > 0 { jstr(gp[0]) } else { gid }
    let mut any = false
    for s in scenes {
      if jstr(jget(s, "group")) == gid {
        any = true
      }
    }
    if !any {
      continue
    }
    lines.push("## \{gtitle}")
    lines.push("")
    lines.push("| 场景 | id | 文件 |")
    lines.push("|---|---|---|")
    for s in scenes {
      if jstr(jget(s, "group")) != gid {
        continue
      }
      let title = pair_of(jget(s, "title"))
      let id = jstr(jget(s, "id"))
      let more = if jstrings(jget(s, "lib")).length() > LIB_CAP {
        " · [全量](\{id}-libs.md)"
      } else {
        ""
      }
      lines.push("| \{title.0} | `\{id}` | [索引](\{id}.md)\{more} |")
    }
    lines.push("")
  }
  lines.join("\n")
}

///|
pub fn write_skill(payload : Json, out_dir : String) -> Unit raise StudioError {
  let scenes = jarray(jget(payload, "scenarios"))
  let mods = jget(payload, "modules")
  let bls = jget(payload, "blurbs")
  let collected = jstr(jget(jget(payload, "meta"), "collected_at"))
  let refs = join(out_dir, "references")
  for sc in scenes {
    let id = jstr(jget(sc, "id"))
    write_text(join(refs, id + ".md"), scene_md(sc, mods, bls, collected))
    if jstrings(jget(sc, "lib")).length() > LIB_CAP {
      write_text(join(refs, id + "-libs.md"), libs_md(sc, mods, collected))
    }
  }
  write_text(join(refs, "scenarios.md"), scenarios_md(payload))
}

