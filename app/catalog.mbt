// 场景定义的数据模型：data/scenarios.src.json 的读写。
//
// 文件里的键分两类：工作台能改的（标题、简介、分组、图标、top、curated），
// 以及保持原样的其余字段（kw / desc / sol / pick / boost / _why…）。保存时按原文件
// 的键序重新拼对象，未编辑的键原样写回，避免整份文件被重排。

///|
pub struct Group {
  id : String
  title : String
  mut title_en : String
}

///|
pub fn Group::renamed(self : Group, title : String, title_en : String) -> Group {
  { id: self.id, title, title_en }
}

///|
pub fn Group::make(id : String, title : String, title_en : String) -> Group {
  { id, title, title_en }
}

///|
pub fn Group::label(self : Group) -> String {
  if self.title == "" {
    self.id
  } else {
    self.title
  }
}

///|
pub struct Scenario {
  mut id : String
  mut group : String
  mut icon : String
  mut title : String
  mut intro : String
  mut note : String
  mut title_en : String
  mut intro_en : String
  mut note_en : String
  mut top : Int
  mut curated : Bool
  mut keys : Array[String]
  mut extra : Array[(String, Json)]
}

///|
let editable_fields : Array[String] = [
  "id", "group", "icon", "title", "intro", "note", "top", "curated",
]

///|
fn is_editable(k : String) -> Bool {
  editable_fields.contains(k)
}

///|
pub fn Scenario::make() -> Scenario {
  {
    id: "",
    group: "",
    icon: "",
    title: "",
    intro: "",
    note: "",
    title_en: "",
    intro_en: "",
    note_en: "",
    top: 8,
    curated: false,
    keys: [],
    extra: [],
  }
}

///|
pub fn Scenario::raw(self : Scenario, key : String) -> Json? {
  for (k, v) in self.extra {
    if k == key {
      return Some(v)
    }
  }
  None
}

///|
pub fn Scenario::raw_set(self : Scenario, key : String, value : Json) -> Unit {
  let out : Array[(String, Json)] = []
  let mut done = false
  for (k, v) in self.extra {
    if k == key {
      out.push((k, value))
      done = true
    } else {
      out.push((k, v))
    }
  }
  if !done {
    out.push((key, value))
    self.keys.push(key)
  }
  self.extra = out
}

///|
pub fn Scenario::raw_remove(self : Scenario, key : String) -> Unit {
  let out : Array[(String, Json)] = []
  for (k, v) in self.extra {
    if k != key {
      out.push((k, v))
    }
  }
  self.extra = out
  let ks : Array[String] = []
  for k in self.keys {
    if k != key {
      ks.push(k)
    }
  }
  self.keys = ks
}

///|
pub fn Scenario::str_list(self : Scenario, key : String) -> Array[String] {
  match self.raw(key) {
    Some(v) => jstrings(v)
    None => []
  }
}

///|
pub fn Scenario::set_str_list(
  self : Scenario,
  key : String,
  xs : Array[String],
) -> Unit {
  if xs.is_empty() {
    self.raw_remove(key)
  } else {
    self.raw_set(key, json_strs(xs))
  }
}

///|
pub fn Scenario::has_in(self : Scenario, key : String, name : String) -> Bool {
  self.str_list(key).contains(name)
}

///|
pub fn Scenario::toggle_in(self : Scenario, key : String, name : String) -> Bool {
  let xs = self.str_list(key)
  let out : Array[String] = []
  let mut now = false
  let mut removed = false
  for x in xs {
    if x == name && !removed {
      removed = true
    } else {
      out.push(x)
    }
  }
  if !removed {
    out.push(name)
    now = true
  }
  self.set_str_list(key, out)
  now
}

///|
pub fn Scenario::num_map(self : Scenario, key : String) -> Array[(String, Double)] {
  let out : Array[(String, Double)] = []
  match self.raw(key) {
    Some(Json::Object(m)) =>
      for k in m.keys() {
        match m.get(k) {
          Some(Json::Number(n, ..)) => out.push((k, n))
          Some(_) => out.push((k, 0.0))
          None => ()
        }
      }
    _ => ()
  }
  out
}

///|
pub fn Scenario::num_get(self : Scenario, key : String, name : String) -> Double {
  for (k, v) in self.num_map(key) {
    if k == name {
      return v
    }
  }
  0.0
}

///|
pub fn Scenario::num_set(
  self : Scenario,
  key : String,
  name : String,
  value : Double,
) -> Unit {
  let pairs = self.num_map(key)
  let out : Array[(String, Double)] = []
  let mut done = false
  for (k, v) in pairs {
    if k == name {
      out.push((k, value))
      done = true
    } else {
      out.push((k, v))
    }
  }
  if !done {
    out.push((name, value))
  }
  let m : Map[String, Json] = Map([])
  for (k, v) in out {
    m[k] = json_num(v)
  }
  self.raw_set(key, @json.to_json(m))
}

///|
pub fn Scenario::num_remove(self : Scenario, key : String, name : String) -> Unit {
  let pairs = self.num_map(key)
  let m : Map[String, Json] = Map([])
  let mut n = 0
  for (k, v) in pairs {
    if k != name {
      m[k] = json_num(v)
      n = n + 1
    }
  }
  if n == 0 {
    self.raw_remove(key)
  } else {
    self.raw_set(key, @json.to_json(m))
  }
}

///|
pub fn Scenario::to_json(self : Scenario) -> Json {
  let m : Map[String, Json] = Map([])
  let mut note_written = false
  for k in self.keys {
    if is_editable(k) {
      match k {
        "id" => m["id"] = json_str(self.id)
        "group" => m["group"] = json_str(self.group)
        "icon" => m["icon"] = json_str(self.icon)
        "title" => m["title"] = json_str(self.title)
        "intro" => m["intro"] = json_str(self.intro)
        "note" =>
          if self.note != "" {
            m["note"] = json_str(self.note)
            note_written = true
          }
        "top" => m["top"] = json_int(self.top)
        "curated" => m["curated"] = json_bool(self.curated)
        _ => ()
      }
    } else {
      match self.raw(k) {
        Some(v) => m[k] = v
        None => ()
      }
    }
  }
  let _ = note_written
  if !self.keys.contains("id") {
    m["id"] = json_str(self.id)
  }
  if !self.keys.contains("group") {
    m["group"] = json_str(self.group)
  }
  if !self.keys.contains("title") {
    m["title"] = json_str(self.title)
  }
  if !self.keys.contains("intro") {
    m["intro"] = json_str(self.intro)
  }
  if !self.keys.contains("note") && self.note != "" {
    m["note"] = json_str(self.note)
  }
  @json.to_json(m)
}

///|
pub struct Catalog {
  groups : Array[Group]
  scenarios : Array[Scenario]
  keys : Array[String]
  extra : Array[(String, Json)]
}

///|
pub fn Catalog::find(self : Catalog, id : String) -> Scenario? {
  for s in self.scenarios {
    if s.id == id {
      return Some(s)
    }
  }
  None
}

///|
pub fn Catalog::group(self : Catalog, id : String) -> Group? {
  for g in self.groups {
    if g.id == id {
      return Some(g)
    }
  }
  None
}

///|
pub fn Catalog::scenarios_of(self : Catalog, gid : String) -> Array[Scenario] {
  let out : Array[Scenario] = []
  for s in self.scenarios {
    if s.group == gid {
      out.push(s)
    }
  }
  out
}

///|
pub fn Catalog::index_of(self : Catalog, id : String) -> Int {
  for i = 0; i < self.scenarios.length(); i = i + 1 {
    if self.scenarios[i].id == id {
      return i
    }
  }
  -1
}

///|
pub fn Catalog::move_scenario(self : Catalog, id : String, delta : Int) -> Unit {
  let i = self.index_of(id)
  if i < 0 {
    return
  }
  let j = i + delta
  if j < 0 || j >= self.scenarios.length() {
    return
  }
  // 只在同组内换位：跨组用改分组的方式
  if self.scenarios[i].group != self.scenarios[j].group {
    return
  }
  let a = self.scenarios[i]
  self.scenarios[i] = self.scenarios[j]
  self.scenarios[j] = a
}

///|
fn groups_json(groups : Array[Group]) -> Json {
  let gs : Array[Json] = []
  for g in groups {
    gs.push(json_obj([("id", json_str(g.id)), ("title", json_str(g.title))]))
  }
  @json.to_json(gs)
}

///|
pub fn Catalog::to_json(self : Catalog) -> Json {
  let m : Map[String, Json] = Map([])
  let scen_json = {
    let ss : Array[Json] = []
    for s in self.scenarios {
      ss.push(s.to_json())
    }
    @json.to_json(ss)
  }
  for k in self.keys {
    if k == "groups" {
      m["groups"] = groups_json(self.groups)
    } else if k == "scenarios" {
      m["scenarios"] = scen_json
    } else {
      for (ek, ev) in self.extra {
        if ek == k {
          m[k] = ev
        }
      }
    }
  }
  if !self.keys.contains("groups") {
    m["groups"] = groups_json(self.groups)
  }
  if !self.keys.contains("scenarios") {
    m["scenarios"] = scen_json
  }
  @json.to_json(m)
}

// ---------------------------------------------------------------- 增删与批量

///|
/// 用 `src` 的内容原地替换 `dst`：`Catalog.scenarios` 是定长引用，只能改内容。
fn take_over(dst : Array[Scenario], src : Array[Scenario]) -> Unit {
  dst.clear()
  for s in src {
    dst.push(s)
  }
}

///|
/// 新场景的初值：键序照文件里既有条目来，便于人工比对；未填的字段留空。
pub fn Scenario::blank(id : String, group : String) -> Scenario {
  {
    id,
    group,
    icon: "🧩",
    title: "",
    intro: "",
    note: "",
    title_en: "",
    intro_en: "",
    note_en: "",
    top: 8,
    curated: false,
    keys: ["id", "group", "icon", "title", "intro", "top", "curated"],
    extra: [],
  }
}

///|
pub fn Catalog::last_of_group(self : Catalog, gid : String) -> Int {
  let mut at = -1
  for i = 0; i < self.scenarios.length(); i = i + 1 {
    if self.scenarios[i].group == gid {
      at = i
    }
  }
  at
}

///|
/// 新场景插到目标分组最后一条之后，保持文件里「同组聚拢」的观感；
/// 组还不存在（或整个文件为空）就追加到末尾。
pub fn Catalog::add_scenario(self : Catalog, sc : Scenario) -> Unit {
  let at = self.last_of_group(sc.group)
  if at < 0 {
    self.scenarios.push(sc)
  } else {
    let out : Array[Scenario] = []
    for i = 0; i < self.scenarios.length(); i = i + 1 {
      out.push(self.scenarios[i])
      if i == at {
        out.push(sc)
      }
    }
    take_over(self.scenarios, out)
  }
}

///|
/// 批量改分组：先把选中项的分组字段改掉，再整段挪到目标组末尾（组内保持原相对
/// 顺序），这样文件和左树的顺序都不至于散乱。
pub fn Catalog::reassign(self : Catalog, ids : Array[String], gid : String) -> Unit {
  let moved : Array[Scenario] = []
  let rest : Array[Scenario] = []
  for s in self.scenarios {
    if ids.contains(s.id) {
      s.group = gid
      moved.push(s)
    } else {
      rest.push(s)
    }
  }
  if moved.is_empty() {
    return
  }
  let mut at = -1
  for i = 0; i < rest.length(); i = i + 1 {
    if rest[i].group == gid {
      at = i
    }
  }
  let out : Array[Scenario] = []
  if at < 0 {
    for s in rest {
      out.push(s)
    }
    for s in moved {
      out.push(s)
    }
  } else {
    for i = 0; i <= at; i = i + 1 {
      out.push(rest[i])
    }
    for s in moved {
      out.push(s)
    }
    for i = at + 1; i < rest.length(); i = i + 1 {
      out.push(rest[i])
    }
  }
  take_over(self.scenarios, out)
}

///|
/// 新建场景前的 id 校验：非空、只用小写字母数字与连字符、不与既有 id 撞。
pub fn Catalog::valid_new_id(self : Catalog, id : String) -> String {
  if id == "" {
    return "id 不能为空"
  }
  for c in id {
    let ok = if c >= 'a' && c <= 'z' {
      true
    } else if c >= '0' && c <= '9' {
      true
    } else {
      c == '-' || c == '_'
    }
    if !ok {
      return "id 只能用小写字母、数字、连字符"
    }
  }
  match self.find(id) {
    Some(_) => "id 已存在"
    None => ""
  }
}

///|
/// 从场景表里摘掉一条。译文表里的残留不致命（构建只按场景表取），
/// 下次保存 i18n 时也不会主动补回来。
pub fn Catalog::remove_scenario(self : Catalog, id : String) -> Unit {
  let out : Array[Scenario] = []
  for s in self.scenarios {
    if s.id != id {
      out.push(s)
    }
  }
  take_over(self.scenarios, out)
}
