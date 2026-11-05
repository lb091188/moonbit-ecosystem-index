// 采集历史：每次全量采集记一笔「包数量 + 累计下载量」，首页据此画趋势线。
//
// 与 `data/raw/` 的原始快照不同，`data/history.json` 是长期累积的汇总：不随单次
// 采集重写，只往后加一条，所以要单独成文件、跟仓库一起走。
//
// **同一天重跑只覆盖当天那一条**。趋势按天看，一天出现两个点会把横轴挤成锯齿；
// 而且重跑本来就是「把今天这份重采一遍」，不是新的一天。
//
// 这里只放**全生态汇总**，不落任何单包下载量：站点的排序口径是「下载量只在构建期
// 参与打分、不出现在页面上」（见 docs/methodology.md「为什么站内不展示下载量」）。一个总数没法
// 逐行比对，也就不会把「下载多的更适合」这个误读带回页面。

///|
/// 一个采集时刻的横截面。`downloads` 是全部已取到下载量的包的累计值之和，
/// `with_dl` 是其中拿到数字的包数——缺口大时曲线会突然「掉」，有这个数才看得出
/// 那是采集没覆盖全，而不是生态萎缩了。
pub struct HistPoint {
  date : String
  at : String
  packages : Int
  downloads : Double
  with_dl : Int
}

///|
pub const HISTORY_PATH : String = "data/history.json"

///|
/// 最多留多少个点。按天算，一千个点够看三年；文件本身很小（每点一行）。
const MAX_POINTS : Int = 1000

// ---------------------------------------------------------------------------
// 数字格式化（日志与站点各自有一份，这里只管日志与 JSON）
// ---------------------------------------------------------------------------

///|
/// 千分位。日志里 `10796732` 和 `10,796,732` 读起来是两回事。
fn group3(n : Int) -> String {
  if n == 0 {
    return "0"
  }
  let chars : Array[Char] = []
  for c in n.to_string() {
    chars.push(c)
  }
  let len = chars.length()
  let out = StringBuilder()
  for i = 0; i < len; i = i + 1 {
    if i > 0 && (len - i) % 3 == 0 {
      out.write_char(',')
    }
    out.write_char(chars[i])
  }
  out.to_string()
}

///|
pub fn fmt_int(n : Int) -> String {
  if n < 0 {
    "-" + group3(-n)
  } else {
    group3(n)
  }
}

///|
pub fn fmt_num(v : Double) -> String {
  fmt_int(v.round().to_int())
}

///|
/// 带符号的增量：`+1,234` / `-3` / `±0`。采集日志里「较上次」用这一种写法，
/// 正负都能一眼看出来。
pub fn fmt_signed(n : Int) -> String {
  if n > 0 {
    "+" + group3(n)
  } else if n < 0 {
    "-" + group3(-n)
  } else {
    "±0"
  }
}

///|
pub fn fmt_signed_num(v : Double) -> String {
  fmt_signed(v.round().to_int())
}

// ---------------------------------------------------------------------------
// 读写
// ---------------------------------------------------------------------------

///|
fn point_of(j : Json) -> HistPoint? {
  let date = jstr(jget(j, "date"))
  if date == "" {
    return None
  }
  let at = match jstr(jget(j, "at")) {
    "" => date
    v => v
  }
  let downloads = match jget(j, "downloads") {
    Json::Number(n, ..) => n
    _ => 0.0
  }
  Some({
    date,
    at,
    packages: jint(jget(j, "packages")),
    downloads,
    with_dl: jint(jget(j, "with_dl")),
  })
}

///|
/// 读历史。文件不存在、解析失败、条目坏掉都当作「没有这一点」——趋势图是附加信息，
/// 不该因为它让整次构建失败。返回顺序即文件顺序（写入时已按日期升序）。
pub fn read_history(root : String) -> Array[HistPoint] {
  let text = match @sys.sys_read_text_file(join(root, HISTORY_PATH)) {
    Some(t) => t
    None => return []
  }
  let root_json = try {
    @json.parse(text)
  } catch {
    _ => return []
  }
  let out : Array[HistPoint] = []
  for item in jarray(jget(root_json, "points")) {
    match point_of(item) {
      Some(p) => out.push(p)
      None => ()
    }
  }
  out
}

///|
pub fn write_history(root : String, pts : Array[HistPoint]) -> Unit raise StudioError {
  let arr : Array[Json] = []
  for p in pts {
    arr.push(
      json_obj([
        ("date", json_str(p.date)),
        ("at", json_str(p.at)),
        ("packages", json_int(p.packages)),
        ("downloads", json_num(p.downloads)),
        ("with_dl", json_int(p.with_dl)),
      ]),
    )
  }
  let doc = json_obj([
    ("schema_version", json_int(1)),
    (
      "note",
      json_str(
        "每次全量采集追加一条，同一天重跑覆盖当日那条。packages 为去重后的包数，downloads 为全生态累计下载量之和（仅汇总，不含单包数字）。",
      ),
    ),
    ("points", @json.to_json(arr)),
  ])
  write_json(join(root, HISTORY_PATH), doc, indent=2)
}

///|
/// 记一笔，返回 `(上一次的点, 这一次的点)`。上一次是**另一个日期**的点：同日重跑
/// 时拿当天旧值做对比没有意义（那是同一份快照的两次读数），要和上一次采集比。
pub fn record_history(
  root : String,
  at : String,
  packages : Int,
  downloads : Double,
  with_dl : Int,
) -> (HistPoint?, HistPoint) raise StudioError {
  let pts = read_history(root)
  let date = if at.length() >= 10 { at[:10].to_owned() } else { at }
  let now : HistPoint = { date, at, packages, downloads, with_dl }
  let kept : Array[HistPoint] = []
  let mut replaced = false
  for p in pts {
    if p.date == date {
      // 只保留一条：同一份快照重采，旧的读数没必要留
      if !replaced {
        kept.push(now)
        replaced = true
      }
    } else {
      kept.push(p)
    }
  }
  if !replaced {
    kept.push(now)
  }
  kept.sort_by(fn(a : HistPoint, b : HistPoint) -> Int32 {
    if a.date < b.date {
      -1
    } else if a.date > b.date {
      1
    } else {
      0
    }
  })
  let trimmed = if kept.length() > MAX_POINTS {
    let s : Array[HistPoint] = []
    for i = kept.length() - MAX_POINTS; i < kept.length(); i = i + 1 {
      s.push(kept[i])
    }
    s
  } else {
    kept
  }
  let mut prev : HistPoint? = None
  for i = 1; i < trimmed.length(); i = i + 1 {
    if trimmed[i].date == date {
      prev = Some(trimmed[i - 1])
    }
  }
  write_history(root, trimmed)
  (prev, now)
}
