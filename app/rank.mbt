// 构建期的收录与排序：从注册表快照合并模块表，按场景规则打分、分层、排序。
//
// 打分只在构建期使用，分值不写进任何对外产物——站点只保留排好序的包名数组，
// 下载量同样不外发。

///|
pub struct Weights {
  mut rel_w : Double
  mut rel_cap : Double
  mut dl_w : Double
  mut pin_w : Double
  mut min_dl : Double
}

///|
pub fn Weights::default() -> Weights {
  { rel_w: 1.0, rel_cap: 6.0, dl_w: 1.35, pin_w: 1.2, min_dl: 20.0 }
}

///|
pub fn Weights::to_json(self : Weights) -> Json {
  json_obj([
    ("rel_w", json_num(self.rel_w)),
    ("rel_cap", json_num(self.rel_cap)),
    ("dl_w", json_num(self.dl_w)),
    ("pin_w", json_num(self.pin_w)),
    ("min_dl", json_num(self.min_dl)),
  ])
}

///|
pub fn Weights::field(self : Weights, key : String) -> Double {
  match key {
    "rel_w" => self.rel_w
    "rel_cap" => self.rel_cap
    "dl_w" => self.dl_w
    "pin_w" => self.pin_w
    "min_dl" => self.min_dl
    _ => 0.0
  }
}

///|
pub fn Weights::set_field(self : Weights, key : String, v : Double) -> Unit {
  match key {
    "rel_w" => self.rel_w = v
    "rel_cap" => self.rel_cap = v
    "dl_w" => self.dl_w = v
    "pin_w" => self.pin_w = v
    "min_dl" => self.min_dl = v
    _ => ()
  }
}

///|
pub fn Weights::from_json(j : Json) -> Weights {
  let w = Weights::default()
  for key in ["rel_w", "rel_cap", "dl_w", "pin_w", "min_dl"] {
    match obj_get(j, key) {
      Some(Json::Number(n, ..)) => w.set_field(key, n)
      _ => ()
    }
  }
  w
}

///|
pub fn load_weights(root : String) -> Weights {
  match @sys.sys_read_text_file(join(root, "data/build.json")) {
    Some(t) =>
      try {
        Weights::from_json(parse_json(t))
      } catch {
        _ => Weights::default()
      }
    None => Weights::default()
  }
}

///|
pub fn save_weights(root : String, w : Weights) -> Unit raise StudioError {
  write_json(join(root, "data/build.json"), w.to_json(), indent=2)
}

// 整族不进任何场景的包：cli/* 是 MoonX 的 coreutils 复刻，一条命令一个包；
// gmlewis/fonts-* 是按字母切分的字体数据分片，主包已代表该路线。
///|
let global_exclude_prefix : Array[String] = ["cli/", "gmlewis/fonts-"]

///|
let ambiguous_tokens : Array[String] = [
  "net", "map", "set", "ui", "io", "os", "fs", "log", "api", "app", "key", "job",
  "run", "src", "bin", "cmd", "dev", "sdk", "test", "tests", "demo", "example",
  "sample",
]

///|
fn is_alnum(c : Char) -> Bool {
  (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')
}

///|
pub fn tokens(s : String) -> Array[String] {
  let out : Array[String] = []
  let mut buf : Array[Char] = []
  for c in s.to_lower() {
    if is_alnum(c) {
      buf.push(c)
    } else if !buf.is_empty() {
      out.push(String::from_array(buf))
      buf = []
    }
  }
  if !buf.is_empty() {
    out.push(String::from_array(buf))
  }
  out
}

///|
fn has_prefix_any(s : String, xs : Array[String]) -> Bool {
  for x in xs {
    if s.has_prefix(x) {
      return true
    }
  }
  false
}

///|
pub fn last_segment(name : String) -> String {
  match name.rev_find("/") {
    Some(i) => name[i + 1:].to_owned()
    None => name
  }
}

///|
pub fn trunc(s : String, n : Int) -> String {
  if s.char_length() <= n {
    return s
  }
  let mut out = ""
  let mut i = 0
  for c in s {
    if i >= n {
      break
    }
    out = out + c.to_string()
    i = i + 1
  }
  out
}

///|
pub fn fix_url(u : String) -> String {
  let t = u.trim().to_owned()
  if t == "" {
    return ""
  }
  if t.has_prefix("http://") || t.has_prefix("https://") {
    t
  } else {
    "https://" + t.trim_start(chars="/").to_owned()
  }
}

///|
pub fn load_modules(root : String) -> Map[String, Module] raise StudioError {
  let api_path = join(root, "data/raw/modules_api.json")
  let dl_path = join(root, "data/raw/downloads.json")
  let api = parse_json(read_text(api_path))
  let dl = if @sys.sys_path_exists(dl_path) {
    parse_json(read_text(dl_path))
  } else {
    json_obj([])
  }
  let out : Map[String, Module] = Map([])
  for item in jarray(api) {
    let name = jstr(jget(item, "name"))
    if name == "" {
      continue
    }
    let m = Module::make(name)
    let extra = jget(dl, name)
    let ver = jstr(jget(item, "version"))
    m.version = if ver != "" { ver } else { jstr(jget(extra, "version")) }
    m.downloads = match obj_get(extra, "downloads") {
      Some(Json::Number(n, ..)) => n
      _ => 0.0
    }
    m.license = jstr(jget(item, "license"))
    m.repository = fix_url(jstr(jget(item, "repository")))
    let kws : Array[String] = []
    for k in jstrings(jget(item, "keywords")) {
      kws.push(k.to_lower())
    }
    m.keywords = kws
    let desc = jstr(jget(item, "description"))
    m.description = if desc != "" { desc } else { jstr(jget(extra, "description")) }
    let created = jstr(jget(item, "created_at"))
    m.created_at = if created != "" {
      trunc(created, 10)
    } else {
      trunc(jstr(jget(extra, "created_at")), 10)
    }
    m.is_new = jbool(jget(item, "is_new"))
    m.yanked = jbool(jget(item, "yanked"))
    out[name] = m
  }
  dedupe(out)
}

///|
/// 版本号比较：按 `.` 拆段逐段比数字，`-` 之后的预发布后缀忽略。
/// 逐段比而不是比字符串，否则 `0.1.10` 会被判成小于 `0.1.9`。
fn ver_cmp(a : String, b : String) -> Int {
  let strip = fn(s : String) -> String {
    match s.find("-") {
      Some(i) => s[:i].to_owned()
      None => s
    }
  }
  let pa : Array[String] = []
  for seg in strip(a).split(".") {
    pa.push(seg.to_owned())
  }
  let pb : Array[String] = []
  for seg in strip(b).split(".") {
    pb.push(seg.to_owned())
  }
  let n = if pa.length() > pb.length() { pa.length() } else { pb.length() }
  for i = 0; i < n; i = i + 1 {
    let x = if i < pa.length() { ver_num(pa[i]) } else { 0 }
    let y = if i < pb.length() { ver_num(pb[i]) } else { 0 }
    if x > y {
      return 1
    }
    if x < y {
      return -1
    }
  }
  0
}

///|
fn ver_num(s : String) -> Int {
  let mut v = 0
  for c in s {
    let d = c.to_int() - 48
    if d < 0 || d > 9 {
      break
    }
    v = v * 10 + d
  }
  v
}

///|
/// 注册表里同一个包可能存着大小写不同的多条记录——重发一次就多一条：
/// `youyong5/MoonTetris` 与 `youyong5/moontetris` 指向同一个仓库，
/// `xunyoyo/Permutation` 是 `xunyoyo/permutation` 的旧版（0.1.1 对 0.1.3）。
///
/// 按小写名归并，保留版本高的一条；版本相同取发布更晚的；再相同取全小写那个
/// （平台规范形式）。归并后模块总数会少掉重复的条数，其余包名与键不受影响。
fn dedupe(by_name : Map[String, Module]) -> Map[String, Module] {
  let pick : Map[String, String] = Map([])
  for name in by_name.keys() {
    let key = name.to_lower()
    match pick.get(key) {
      None => pick[key] = name
      Some(best) => {
        let a = by_name[name]
        let b = by_name[best]
        let c = ver_cmp(a.version, b.version)
        let win = if c != 0 {
          c > 0
        } else if a.created_at != b.created_at {
          a.created_at > b.created_at
        } else {
          a.name == key
        }
        if win {
          pick[key] = name
        }
      }
    }
  }
  let out : Map[String, Module] = Map([])
  for key in pick.keys() {
    let name = pick[key]
    out[name] = by_name[name]
  }
  out
}

// ---------------------------------------------------------------- 打分

///|
fn hit(term : String, toks : Array[String]) -> Bool {
  if term.length() >= 4 {
    for t in toks {
      if t.has_prefix(term) {
        return true
      }
    }
  }
  toks.contains(term)
}

///|
fn kw_hit(term : String, kws : Array[String]) -> Bool {
  if kws.contains(term) {
    return true
  }
  if term.length() >= 4 {
    for k in kws {
      if k.has_prefix(term) {
        return true
      }
    }
  }
  false
}

///|
pub fn relevance(mod : Module, sc : Scenario, w : Weights) -> Double? {
  if mod.yanked {
    return None
  }
  // drop：工作台里手工移出本场景的包，即使命中关键词也不再收
  if sc.str_list("drop").contains(mod.name) {
    return None
  }
  if has_prefix_any(mod.name, global_exclude_prefix) {
    return None
  }
  let ntok = tokens(last_segment(mod.name))
  let dtok = tokens(mod.description)
  let desc_l = mod.description.to_lower()
  let core = sc.str_list("core")
  if !core.is_empty() {
    let mut ok = false
    for t in core {
      if kw_hit(t, mod.keywords) || hit(t, ntok) || hit(t, dtok) {
        ok = true
      }
    }
    if !ok {
      return None
    }
  }
  for t in sc.str_list("ex_desc") {
    if desc_l.contains(t.to_lower()) {
      return None
    }
  }
  for pfx in sc.str_list("ex_prefix") {
    if mod.name.has_prefix(pfx) {
      return None
    }
  }
  let mut rel = 0.0
  for t in sc.str_list("kw") {
    if kw_hit(t, mod.keywords) {
      rel = rel + 3.0
    } else if hit(t, ntok) {
      // 包名里出现与场景词完全相同的词是强信号（yaml 的关键词是空的，名字才是唯一线索），
      // 但 net / ui 这类过短的词仍按弱信号处理
      if t.length() >= 3 && ntok.contains(t) && !ambiguous_tokens.contains(t) {
        rel = rel + 3.0
      } else {
        rel = rel + 2.0
      }
    } else if hit(t, dtok) {
      rel = rel + 1.0
    }
  }
  for t in sc.str_list("desc") {
    if t.contains(" ") {
      if desc_l.contains(t.to_lower()) {
        rel = rel + 1.5
      }
    } else if hit(t, dtok) {
      rel = rel + 1.2
    }
  }
  for t in sc.str_list("ex") {
    if mod.keywords.contains(t) || hit(t, ntok) {
      return None
    }
  }
  if rel < 3.0 || mod.downloads < w.min_dl {
    return None
  }
  Some(rel)
}

///|
pub fn score(mod : Module, sc : Scenario, w : Weights) -> Double? {
  match relevance(mod, sc, w) {
    None => None
    Some(rel) => {
      let mut s = rel.min(w.rel_cap) * w.rel_w + @math.ln_1p(mod.downloads) * w.dl_w
      if sc.str_list("pin").contains(mod.name) {
        s = s + w.pin_w
      }
      s = s + sc.num_get("boost", mod.name)
      Some(s)
    }
  }
}

// ---------------------------------------------------------------- 排序

///|
pub struct RankItem {
  score : Double
  name : String
  tier : String
}

///|
pub struct Ranked {
  id : String
  title : String
  icon : String
  intro : String
  note : String
  group : String
  curated : Bool
  top : Int
  items : Array[RankItem]
}

///|
pub fn Ranked::split(self : Ranked, tier : String) -> Array[RankItem] {
  let out : Array[RankItem] = []
  for it in self.items {
    if it.tier == tier {
      out.push(it)
    }
  }
  out
}

///|
pub fn tier_of(sc : Scenario, name : String) -> String {
  if sc.str_list("sol").contains(name) {
    "solution"
  } else {
    "lib"
  }
}

///|
fn stable_sort_items(items : Array[RankItem]) -> Unit {
  for i = 1; i < items.length(); i = i + 1 {
    let cur = items[i]
    let mut j = i - 1
    while j >= 0 && items[j].score < cur.score {
      items[j + 1] = items[j]
      j = j - 1
    }
    items[j + 1] = cur
  }
}

///|
pub fn rank_scenario(
  sc : Scenario,
  mods : Map[String, Module],
  w : Weights,
) -> Ranked {
  let items : Array[RankItem] = []
  let pick = sc.str_list("pick")
  if !pick.is_empty() {
    // 人工圈定：候选与顺序都由 pick 决定
    let drop = sc.str_list("drop")
    for i = 0; i < pick.length(); i = i + 1 {
      let name = pick[i]
      match mods.get(name) {
        Some(m) =>
          if !m.yanked && m.downloads >= w.min_dl && !drop.contains(name) {
            items.push({
              score: 200.0 - 10.0 * i.to_double(),
              name,
              tier: tier_of(sc, name),
            })
          }
        None => ()
      }
    }
  } else {
    let seen : Map[String, Bool] = Map([])
    for name in mods.keys() {
      let m = mods[name]
      match score(m, sc, w) {
        Some(s) => {
          items.push({ score: s, name, tier: tier_of(sc, name) })
          seen[name] = true
        }
        None => ()
      }
    }
    // force：元数据太泛、关键词命不中，但确实属于本场景的包。按本层级的中位分安置，
    // 既不因手工收录占据前列，也不因描述缺失被压到末尾。
    for name in sc.str_list("force") {
      match mods.get(name) {
        Some(m) =>
          if !seen.contains(name) &&
            !m.yanked &&
            m.downloads >= w.min_dl &&
            !sc.str_list("drop").contains(name) {
            let tier = tier_of(sc, name)
            let same : Array[Double] = []
            for it in items {
              if it.tier == tier {
                same.push(it.score)
              }
            }
            let mid = if same.is_empty() {
              3.0
            } else {
              same.sort()
              same[same.length() / 2]
            }
            items.push({ score: mid, name, tier })
          }
        None => ()
      }
    }
    // 稳定排序：同分保持模块表原有顺序（插入排序，严格小于才后移）
    stable_sort_items(items)
  }
  {
    id: sc.id,
    title: sc.title,
    icon: sc.icon,
    intro: sc.intro,
    note: sc.note,
    group: sc.group,
    curated: sc.curated,
    top: sc.top,
    items,
  }
}

///|
pub fn rank_all(
  cat : Catalog,
  mods : Map[String, Module],
  w : Weights,
) -> Array[Ranked] {
  let out : Array[Ranked] = []
  for sc in cat.scenarios {
    out.push(rank_scenario(sc, mods, w))
  }
  out
}
