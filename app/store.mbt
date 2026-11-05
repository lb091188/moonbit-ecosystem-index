// 工作台的全部状态：场景定义、英文译文、包简介、注册表模块。
//
// 四份文件各自独立读写，互不覆盖：
//   data/scenarios.src.json  场景与规则（中文）
//   data/i18n.json           场景与分组的英文
//   data/blurbs.json         「完整方案」的中英文简介
//   data/raw/*.json          mooncakes 注册表快照

///|
pub struct Module {
  name : String
  mut version : String
  mut downloads : Double
  mut license : String
  mut repository : String
  mut keywords : Array[String]
  mut description : String
  mut created_at : String
  mut is_new : Bool
  mut yanked : Bool
}

///|
pub fn Module::make(name : String) -> Module {
  {
    name,
    version: "",
    downloads: 0.0,
    license: "",
    repository: "",
    keywords: [],
    description: "",
    created_at: "",
    is_new: false,
    yanked: false,
  }
}

///|
pub struct Studio {
  root : String
  cat : Catalog
  i18n_keys : Array[String]
  i18n_comment : String
  i18n_group_order : Array[String]
  i18n_groups : Map[String, String]
  i18n_order : Array[String]
  i18n_scen : Map[String, (String, String, String)]
  blurb_keys : Array[String]
  blurb_notes : Array[(String, String)]
  mut blurbs : Array[(String, Array[String])]
  mut modules : Map[String, Module]
  mut collected_at : String
  log : Array[String]
}

///|
pub fn Studio::find_module(self : Studio, name : String) -> Module? {
  self.modules.get(name)
}

///|
pub fn Studio::blurb(self : Studio, name : String) -> Array[String] {
  for (k, v) in self.blurbs {
    if k == name {
      return v
    }
  }
  []
}

///|
pub fn Studio::blurb_set(
  self : Studio,
  name : String,
  zh : String,
  en : String,
) -> Unit {
  let out : Array[(String, Array[String])] = []
  let mut done = false
  for (k, v) in self.blurbs {
    if k == name {
      out.push((k, [zh, en]))
      done = true
    } else {
      out.push((k, v))
    }
  }
  if !done {
    out.push((name, [zh, en]))
  }
  self.blurbs = out
}

///|
pub fn Studio::path(self : Studio, rel : String) -> String {
  join(self.root, rel)
}

///|
pub fn Studio::log_line(self : Studio, line : String) -> Unit {
  self.log.push(line)
}

// ---------------------------------------------------------------- 读取

///|
pub fn read_catalog(path : String) -> Catalog raise StudioError {
  let root = parse_json(read_text(path))
  let keys = obj_keys(root)
  let extra : Array[(String, Json)] = []
  for k in keys {
    if k != "groups" && k != "scenarios" {
      match obj_get(root, k) {
        Some(v) => extra.push((k, v))
        None => ()
      }
    }
  }
  let groups : Array[Group] = []
  for item in jarray(jget(root, "groups")) {
    groups.push(
      Group::make(jstr(jget(item, "id")), jstr(jget(item, "title")), ""),
    )
  }
  let scenarios : Array[Scenario] = []
  for item in jarray(jget(root, "scenarios")) {
    let s = Scenario::make()
    let skeys = obj_keys(item)
    for k in skeys {
      let v = jget(item, k)
      match k {
        "id" => s.id = jstr(v)
        "group" => s.group = jstr(v)
        "icon" => s.icon = jstr(v)
        "title" => s.title = jstr(v)
        "intro" => s.intro = jstr(v)
        "note" => s.note = jstr(v)
        "top" => s.top = jint(v)
        "curated" => s.curated = jbool(v)
        _ => ()
      }
      if !is_editable(k) {
        s.extra.push((k, v))
      }
    }
    s.keys = skeys
    scenarios.push(s)
  }
  { groups, scenarios, keys, extra }
}

///|
pub fn load_studio(root : String) -> Studio raise StudioError {
  let cat = read_catalog(join(root, "data/scenarios.src.json"))
  let i18n_raw = parse_json(read_text(join(root, "data/i18n.json")))
  let i18n_keys = obj_keys(i18n_raw)
  let i18n_comment = jstr(jget(i18n_raw, "_comment"))
  let gmap : Map[String, String] = Map([])
  let gorder : Array[String] = []
  let gnode = jget(i18n_raw, "groups")
  for k in obj_keys(gnode) {
    gorder.push(k)
    gmap[k] = jstr(jget(gnode, k))
  }
  let smap : Map[String, (String, String, String)] = Map([])
  let sorder : Array[String] = []
  let snode = jget(i18n_raw, "scenarios")
  for k in obj_keys(snode) {
    sorder.push(k)
    let item = jget(snode, k)
    smap[k] = (
      jstr(jget(item, "title")),
      jstr(jget(item, "intro")),
      jstr(jget(item, "note")),
    )
  }
  let blurbs_raw = parse_json(read_text(join(root, "data/blurbs.json")))
  let blurb_keys : Array[String] = []
  let blurb_notes : Array[(String, String)] = []
  let blurbs : Array[(String, Array[String])] = []
  for k in obj_keys(blurbs_raw) {
    if k.has_prefix("_") {
      blurb_keys.push(k)
      blurb_notes.push((k, jstr(jget(blurbs_raw, k))))
    } else {
      let xs = jarray(jget(blurbs_raw, k))
      let zh = if xs.length() > 0 { jstr(xs[0]) } else { "" }
      let en = if xs.length() > 1 { jstr(xs[1]) } else { "" }
      blurbs.push((k, [zh, en]))
    }
  }
  let studio : Studio = {
    root,
    cat,
    i18n_keys,
    i18n_comment,
    i18n_group_order: gorder,
    i18n_groups: gmap,
    i18n_order: sorder,
    i18n_scen: smap,
    blurb_keys,
    blurb_notes,
    blurbs,
    modules: Map([]),
    collected_at: "—",
    log: [],
  }
  for g in studio.cat.groups {
    match gmap.get(g.id) {
      Some(v) => g.title_en = v
      None => ()
    }
  }
  for s in studio.cat.scenarios {
    match smap.get(s.id) {
      Some(v) => {
        s.title_en = v.0
        s.intro_en = v.1
        s.note_en = v.2
      }
      None => ()
    }
  }
  studio
}

// ---------------------------------------------------------------- 写回

///|
/// 把场景 / 分组结构里带的 `*_en` 回灌到译文表，并补齐顺序表——界面改的是
/// 结构体字段，写文件读的是这三张表，保存前必须先对齐。
pub fn Studio::sync_i18n(self : Studio) -> Unit {
  for g in self.cat.groups {
    if !self.i18n_group_order.contains(g.id) {
      self.i18n_group_order.push(g.id)
    }
    self.i18n_groups[g.id] = g.title_en
  }
  for s in self.cat.scenarios {
    if !self.i18n_order.contains(s.id) {
      self.i18n_order.push(s.id)
    }
    self.i18n_scen[s.id] = (s.title_en, s.intro_en, s.note_en)
  }
}

///|
pub fn Studio::save_catalog(self : Studio) -> Unit raise StudioError {
  write_json(self.path("data/scenarios.src.json"), self.cat.to_json(), indent=2)
}

///|
pub fn Studio::save_i18n(self : Studio) -> Unit raise StudioError {
  let m : Map[String, Json] = Map([])
  for k in self.i18n_keys {
    if k == "groups" {
      let g : Map[String, Json] = Map([])
      for gid in self.i18n_group_order {
        match self.i18n_groups.get(gid) {
          Some(v) => g[gid] = json_str(v)
          None => ()
        }
      }
      m["groups"] = @json.to_json(g)
    } else if k == "scenarios" {
      let s : Map[String, Json] = Map([])
      for sid in self.i18n_order {
        match self.i18n_scen.get(sid) {
          Some(v) => {
            let item : Map[String, Json] = Map([])
            item["title"] = json_str(v.0)
            item["intro"] = json_str(v.1)
            if v.2 != "" {
              item["note"] = json_str(v.2)
            }
            s[sid] = @json.to_json(item)
          }
          None => ()
        }
      }
      m["scenarios"] = @json.to_json(s)
    } else {
      m[k] = json_str(self.i18n_comment)
    }
  }
  write_json(self.path("data/i18n.json"), @json.to_json(m), indent=2)
}

///|
pub fn Studio::save_blurbs(self : Studio) -> Unit raise StudioError {
  let m : Map[String, Json] = Map([])
  for (k, v) in self.blurb_notes {
    m[k] = json_str(v)
  }
  for (name, pair) in self.blurbs {
    let zh = if pair.length() > 0 { pair[0] } else { "" }
    let en = if pair.length() > 1 { pair[1] } else { "" }
    if zh != "" || en != "" {
      let a : Array[Json] = [json_str(zh), json_str(en)]
      m[name] = @json.to_json(a)
    }
  }
  let body = @json.to_json(m).stringify(indent=2)
  write_text(self.path("data/blurbs.json"), notes_gap(body) + "\n")
}

///|
pub fn Studio::save_all(self : Studio) -> Unit raise StudioError {
  self.save_catalog()
  self.save_i18n()
  self.save_blurbs()
}
