// 路径、文本读写与 JSON 取值的小工具。
//
// 工作台直接操作仓库根目录下的 data/ 与 dist/，因此先确定根目录：
// 环境变量 INDEX_ROOT 优先，否则从当前目录逐级向上找 data/scenarios.src.json。

///|
pub suberror StudioError {
  IoError(String)
  DataError(String)
}

///|
pub impl Show for StudioError with fn output(self, logger) {
  match self {
    IoError(m) => logger.write_string(m)
    DataError(m) => logger.write_string(m)
  }
}

///|
pub fn join(a : String, b : String) -> String {
  if a == "" {
    b
  } else if a.has_suffix("/") {
    a + b
  } else {
    a + "/" + b
  }
}

///|
pub fn dirname(p : String) -> String {
  match p.rev_find("/") {
    Some(i) if i > 0 => p[:i].to_owned()
    Some(_) => "/"
    None => "."
  }
}

///|
pub fn find_root() -> String {
  match @sys.sys_getenv("INDEX_ROOT") {
    Some(v) if v != "" => return v
    _ => ()
  }
  let mut dir = match @sys.sys_getenv("PWD") {
    Some(v) if v != "" => v
    _ => "."
  }
  for i = 0; i < 8; i = i + 1 {
    if @sys.sys_path_exists(join(dir, "data/scenarios.src.json")) {
      return dir
    }
    let up = dirname(dir)
    if up == dir {
      break
    }
    dir = up
  }
  "."
}

///|
pub fn read_text(path : String) -> String raise StudioError {
  match @sys.sys_read_text_file(path) {
    Some(t) => t
    None => raise IoError("读不到文件：\{path}")
  }
}

///|
pub fn write_text(path : String, text : String) -> Unit raise StudioError {
  let dir = dirname(path)
  if dir != "" && !@sys.sys_path_exists(dir) {
    let _ = @sys.sys_make_dirs(dir)
  }
  if !@sys.sys_write_text_file(path, text) {
    raise IoError("写不进文件：\{path}")
  }
}

///|
pub fn copy_file(src : String, dst : String) -> Unit raise StudioError {
  let dir = dirname(dst)
  if dir != "" && !@sys.sys_path_exists(dir) {
    let _ = @sys.sys_make_dirs(dir)
  }
  match @sys.pr_run("cp", ["-f", src, dst], timeout_ms=10000) {
    Ok(_) => ()
    Err(e) => raise IoError("复制失败：\{src} -> \{dst}（\{e}）")
  }
}

///|
pub fn parse_json(text : String) -> Json raise StudioError {
  try {
    @json.parse(text)
  } catch {
    _ => raise DataError("JSON 解析失败")
  }
}

///|
pub fn jstr(j : Json) -> String {
  match j {
    Json::String(s) => s
    _ => ""
  }
}

///|
pub fn jint(j : Json) -> Int {
  match j {
    Json::Number(n, ..) => n.to_int()
    _ => 0
  }
}

///|
pub fn jbool(j : Json) -> Bool {
  match j {
    Json::True => true
    _ => false
  }
}

///|
pub fn jarray(j : Json) -> Array[Json] {
  match j {
    Json::Array(a) => a
    _ => []
  }
}

///|
pub fn jstrings(j : Json) -> Array[String] {
  let out : Array[String] = []
  for x in jarray(j) {
    let s = jstr(x)
    if s != "" {
      out.push(s)
    }
  }
  out
}

///|
pub fn obj_get(j : Json, key : String) -> Json? {
  match j {
    Json::Object(m) => m.get(key)
    _ => None
  }
}

///|
pub fn jget(j : Json, key : String) -> Json {
  match obj_get(j, key) {
    Some(v) => v
    None => json_str("")
  }
}

///|
pub fn obj_keys(j : Json) -> Array[String] {
  match j {
    Json::Object(m) => m.keys().to_array()
    _ => []
  }
}

///|
pub fn json_str(s : String) -> Json {
  @json.to_json(s)
}

///|
pub fn json_int(n : Int) -> Json {
  @json.to_json(n)
}

///|
pub fn json_num(n : Double) -> Json {
  @json.to_json(n)
}

///|
pub fn json_bool(b : Bool) -> Json {
  @json.to_json(b)
}

///|
pub fn json_strs(xs : Array[String]) -> Json {
  let a : Array[Json] = []
  for x in xs {
    a.push(json_str(x))
  }
  @json.to_json(a)
}

///|
pub fn json_obj(pairs : Array[(String, Json)]) -> Json {
  let m : Map[String, Json] = Map([])
  for p in pairs {
    m[p.0] = p.1
  }
  @json.to_json(m)
}

///|
pub fn write_json(
  path : String,
  value : Json,
  indent? : Int32 = 2,
) -> Unit raise StudioError {
  let text = if indent > 0 {
    value.stringify(indent~) + "\n"
  } else {
    value.stringify()
  }
  write_text(path, text)
}

///|
pub fn today() -> String {
  match @sys.pr_run("date", ["+%F"], timeout_ms=2000) {
    Ok(o) => o.stdout.trim().to_owned()
    Err(_) => "—"
  }
}

///|
/// 表单里的数值解析：空串 / 解析失败都回落到 `fallback`（表单不因手滑锁死）。
pub fn num_of(text : String, fallback : Double) -> Double {
  let t = text.trim().to_owned()
  if t == "" {
    return fallback
  }
  try {
    @str.parse_double(t)
  } catch {
    _ => fallback
  }
}

///|
pub fn int_of(text : String, fallback : Int) -> Int {
  let t = text.trim().to_owned()
  if t == "" {
    return fallback
  }
  try {
    @str.parse_int(t)
  } catch {
    _ => fallback
  }
}

///|
/// 一位小数（分数只用于显示，精度到 0.1 够读）。
pub fn fmt1(v : Double) -> String {
  let scaled = (v * 10.0).round().to_int()
  if scaled < 0 {
    "\{scaled / 10 - 1}.\{10 + scaled % 10}"
  } else {
    "\{scaled / 10}.\{scaled % 10}"
  }
}

///|
/// blurbs.json 是手写文件，条目之间留空行；紧凑缩进会把空行吃掉，这里按原貌
/// 给每个顶层正文条目（`_` 开头的注释键除外）前补一个空行。
pub fn notes_gap(text : String) -> String {
  let out : Array[String] = []
  let mut prev_blank = false
  for line in text.split("\n") {
    let s = line.to_owned()
    let top = s.has_prefix("  \"") && !s.has_prefix("  \"_")
    if top && !prev_blank {
      out.push("")
    }
    out.push(s)
    prev_blank = s.trim() == ""
  }
  out.join("\n")
}

///|
/// 多行文本按行拆成词表：空行与首尾空白丢掉，其余原样保留（描述词里可能带空格，
/// 所以只在首尾 trim，不按空格再切）。
pub fn lines_of(text : String) -> Array[String] {
  let out : Array[String] = []
  for l in text.split("\n") {
    let t = l.trim().to_owned()
    if t != "" {
      out.push(t)
    }
  }
  out
}
