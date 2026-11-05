// 数据更新：从 mooncakes 注册表抓模块元数据与下载量。
//
// 走 `moonbitlang/async` 的 HTTP（`@async/http`）：等待发生在 async 的事件循环里，
// 窗口照常响应；两条请求之间用 `@async.sleep` 留间隔，失败也用 sleep 退避。不再
// 起 curl 子进程，也不再有 pid / 临时文件那一套。
//
// **严格串行**：就是一个 `for` 循环，一条走完再走下一条。这是对 mooncakes 这种
// 免费公共服务的自觉——几百条并发压上去可能把人家拖垮，多等几小时不算事。
//
// 搜索接口单次上限 100 条且不支持 offset，所以下载量按「owner 前缀」批量取，
// 同一 owner 下的包通常不足 100 个；超过 100 个的 owner 再按包名逐个补齐。
//
// 搜索返回的包名做了小写归一，而 /modules 保留原始大小写，两边直接相等会漏
// （`xunyoyo/Permutation` 回来是 `xunyoyo/permutation`）。匹配一律走小写，
// 写回用 /modules 里的原名——见 `harvest`。
//
// 日志刻意写得密（每条请求两行：发出、收回），因为一次全量要跑几小时，界面
// 上必须看得见「它确实在动」。模块清单那一条还会流式读：正文 1 MB 上下、慢链路
// 上要一两分钟，所以每 2 秒报一次「已收多少、平均多快」，而不是干等一个总数。

///|
pub const API : String = "https://mooncakes.io/api/v0"

///|
pub const UA : String = "moonbit-ecosystem-index/1.0 (+https://github.com/lb091188/moonbit-ecosystem-index)"

///|
pub const FETCH_LIMIT : Int = 100

///|
/// 两条请求之间的间隔（毫秒）。串行已经不会并发，这一档是留给服务端喘气的。
const GAP_MS : Int = 800

///|
/// 单条请求最多试几次。
const RETRIES : Int = 3

///|
/// 失败退避基数：第 n 次失败等 `n × BACKOFF_MS`（1.6s / 3.2s / 4.8s）。
const BACKOFF_MS : Int = 1600

///|
/// 模块清单是一整份 1 MB 上下的快照，慢链路上要一分多钟。
const MODULES_TIMEOUT_MS : Int = 300_000

///|
/// 搜索响应只有几十 KB，给 90 秒已经很宽。
const SEARCH_TIMEOUT_MS : Int = 90_000

///|
/// 界面日志只留尾部这么多行：界面是虚拟列表，行数多不至于卡，但也没必要把
/// 几小时的全量都攒在内存里；完整日志最后落 `data/raw/fetch.log`。
const TAIL_LINES : Int = 2000

///|
/// 一次采集任务。协程里就地更新，界面每帧只读，不跨线程。
pub struct FetchJob {
  log : Array[String]
  mut phase : Int
  mut done : Bool
  mut failed : Bool
  mut cancelled : Bool
  mut owner_i : Int
  mut owner_n : Int
  mut name_i : Int
  mut name_n : Int
  mut covered : Int
  mut total : Int
  /// 当前正在等哪一条（界面显示「在等 owner xxx 已 3.2 秒」）
  mut current : String
  mut current_since : Int64
  /// 只采前 N 个 owner（0 = 不限）。冒烟测试用，别拿全量去试一条改动。
  mut owner_cap : Int
  t0 : Int64
  /// 小写名 -> /modules 里的原名（可能不止一个：注册表存了大小写不同的历史记录）
  mut want : Map[String, Array[String]]
  got : Map[String, Json]
  mut owner_names : Array[String]
  mut all_names : Array[String]
}

///|
pub fn FetchJob::make() -> FetchJob {
  let t = now_ms()
  {
    log: [],
    phase: 0,
    done: false,
    failed: false,
    cancelled: false,
    owner_i: 0,
    owner_n: 0,
    name_i: 0,
    name_n: 0,
    covered: 0,
    total: 0,
    current: "",
    current_since: t,
    owner_cap: 0,
    t0: t,
    want: Map([]),
    got: Map([]),
    owner_names: [],
    all_names: [],
  }
}

// ---------------------------------------------------------------------------
// 日志与进度
// ---------------------------------------------------------------------------

///|
fn pad2(v : Int64) -> String {
  if v < 10L {
    "0\{v}"
  } else {
    "\{v}"
  }
}

///|
/// 相对开工时刻的 `+HH:MM:SS`。用相对时间而不是墙钟：一次跑几小时，看「跑了
/// 多久」比看「现在几点」有用。
fn FetchJob::stamp(self : FetchJob) -> String {
  let s = (now_ms() - self.t0) / 1000L
  "+" + pad2(s / 3600L) + ":" + pad2((s % 3600L) / 60L) + ":" + pad2(s % 60L)
}

///|
fn FetchJob::say(self : FetchJob, line : String) -> Unit {
  let s = "[" + self.stamp() + "] " + line
  self.log.push(s)
  // 命令行档就地看得见进度；窗口档从桌面启动时 stdout 没有去处，无害
  println(s)
}

///|
/// 界面用的日志行：尾部若干行，**按行给出**而不是拼成一整段字符串。
/// 界面是虚拟列表，按行取用才谈得上只挂可见的十几行；拼接本身在大日志下
/// 也是一趟白烧（每 300 毫秒拼两千行）。
pub fn FetchJob::lines(self : FetchJob) -> Array[String] {
  let n = self.log.length()
  let start = if n > TAIL_LINES { n - TAIL_LINES } else { 0 }
  let out : Array[String] = []
  for i = start; i < n; i = i + 1 {
    out.push(self.log[i])
  }
  out
}

///|
/// 一行状态：阶段 + 计数 + 当前在等什么、等了多久。
pub fn FetchJob::progress(self : FetchJob) -> String {
  if self.done {
    if self.cancelled {
      "已停止（下载量与历史未写入）"
    } else if self.failed {
      "失败，见日志"
    } else {
      "完成"
    }
  } else if self.cancelled {
    "正在停止…"
  } else {
    let head = match self.phase {
      0 => "① 拉模块清单"
      1 => "② owner \{self.owner_i}/\{self.owner_n}"
      2 => "③ 按名补齐 \{self.name_i}/\{self.name_n}"
      _ => "收尾"
    }
    let cover = "· 已覆盖 \{self.covered}/\{self.total}"
    if self.current == "" {
      "\{head} \{cover}"
    } else {
      // 一位小数就够：整串文本每 300ms 会重设一次，带一串浮点尾巴既难看又白重排
      let ds = (now_ms() - self.current_since) / 100L
      "\{head} \{cover} · 在等 \{self.current} 已 \{ds / 10L}.\{ds % 10L} 秒"
    }
  }
}

///|
/// 用户按「停止采集」：协程在每个检查点看这个标记，看到就收手。此时 phase 0
/// 的 `modules_api.json` **已经落盘**（新快照），但 `downloads.json` / `meta.json` /
/// `history.json` 都只在全部采完时写一次，不会留下半份下载量。重新生成前要么采完
/// 一次，要么先回退 `modules_api.json`，否则新旧快照会混算。
pub fn FetchJob::cancel(self : FetchJob) -> Unit {
  self.cancelled = true
}

// ---------------------------------------------------------------------------
// 请求
// ---------------------------------------------------------------------------

///|
fn hex_char(v : Int) -> Char {
  if v < 10 {
    (v + 48).unsafe_to_char()
  } else {
    (v - 10 + 97).unsafe_to_char()
  }
}

///|
/// RFC 3986 的最小转义：只留 unreserved 字符。包名里有 `@` `/` 之类，直接拼进
/// query 会截断。
pub fn urlencode(s : String) -> String {
  let out = StringBuilder()
  for b in @utf8.encode(s) {
    let v = b.to_int()
    let safe = (v >= 97 && v <= 122) ||
      (v >= 65 && v <= 90) ||
      (v >= 48 && v <= 57) ||
      v == 45 ||
      v == 95 ||
      v == 46 ||
      v == 126
    if safe {
      out.write_char(v.unsafe_to_char())
    } else {
      out.write_char('%')
      out.write_char(hex_char((v >> 4) & 15))
      out.write_char(hex_char(v & 15))
    }
  }
  out.to_string()
}

///|
fn kb_bytes(n : Int) -> String {
  if n < 1024 {
    "\{n} B"
  } else if n < 1024 * 1024 {
    "\{n / 1024} KB"
  } else {
    "\{n / (1024 * 1024)}.\{(n % (1024 * 1024)) * 10 / (1024 * 1024)} MB"
  }
}

///|
fn kb(text : String) -> String {
  kb_bytes(text.length())
}

///|
fn dur(ms : Int64) -> String {
  let w = ms / 1000L
  let frac = (ms % 1000L) / 100L
  "\{w}.\{frac}s"
}

///|
fn ua_headers() -> Map[@http.CaseInsensitiveString, String] {
  let h : Map[@http.CaseInsensitiveString, String] = Map([])
  h[@http.CaseInsensitiveString("User-Agent")] = UA
  h
}

///|
/// 真发一次请求：成功回 `(状态码, 正文)`，任何异常都折成一段说明文字。
/// 单独抽出来是因为 `try/catch` 卡在循环体里时，编译器会把循环当成要产值的
/// 表达式，报「while loop is expected to yield」。
async fn http_once(url : String, timeout_ms : Int) -> Result[(Int, String), String] {
  try {
    let pair = @async.with_timeout(timeout_ms, async fn() {
      @http.get(url, headers=ua_headers())
    })
    let (resp, body) = pair
    Ok((resp.code, body.text()))
  } catch {
    e => Err(e.to_string())
  }
}

///|
/// 流式收一条响应：边收边把进度写进日志。
///
/// 模块清单是 1 MB 上下的整份快照，慢链路上要一分多钟。一次性读的话这段时间
/// 界面上只有「在等 模块清单 已 73.4 秒」，分不清是慢还是死了。`@http.get_stream`
/// 返回的 client 支持按块读（gzip 由解析层内部解开，这里拿到的就是正文），
/// 于是每 2 秒报一次「已收多少、平均多快」，状态行也一起走。
///
/// 搜索响应只有几十 KB，不值得多这一层，仍旧走 `http_once`。
async fn FetchJob::fetch_stream(
  self : FetchJob,
  url : String,
  label : String,
  timeout_ms : Int,
) -> Result[(Int, String), String] {
  let t0 = now_ms()
  let last = Ref(t0)
  let report = fn(n : Int) {
    let now = now_ms()
    if now - last.val >= 2000L {
      last.val = now
      let ms = now - t0
      // 速率按整段平均算，不做滑动窗口：这里只为了让人看出「在动、大概多快」
      let speed = (n.to_int64() * 1000L / (if ms > 0L { ms } else { 1L })) / 1024L
      self.say("   ↓ 已收 \{kb_bytes(n)}（\{dur(ms)}，约 \{speed} KB/s）")
      self.current = label + "（接收中 " + kb_bytes(n) + "）"
    }
  }
  try {
    let out = @async.with_timeout(timeout_ms, async fn() {
      let (resp, client) = @http.get_stream(url, headers=ua_headers())
      self.say(
        "   响应头到了：HTTP \{resp.code}（首字节 \{dur(now_ms() - t0)}），开始接正文",
      )
      let buf = @buffer.Buffer()
      let mut eof = false
      while !eof {
        match client.read_some(max_len=16384) {
          Some(chunk) => {
            buf.write_bytes(chunk[:])
            report(buf.length())
          }
          None => eof = true
        }
      }
      client.close()
      // `Buffer::to_string` 走的是 Show（带转义的展示形式），不是「按字节解成
      // 字符串」。正文必须显式按 UTF-8 解码，否则交给 JSON 解析必然失败。
      let raw = buf.to_bytes()
      let text = try {
        @utf8.decode(raw[:])
      } catch {
        _ => @utf8.decode_lossy(raw[:])
      }
      self.say("   正文收完：\{kb(text)}（\{dur(now_ms() - t0)}）")
      (resp.code, text)
    })
    Ok(out)
  } catch {
    e => Err(e.to_string())
  }
}

///|
/// 取一条 JSON。带重试与退避，每一趟都在日志里留「发出 / 收回」两行。
///
/// 5xx、超时、正文坏掉都值得重试；4xx 是请求本身有问题，重试没意义，直接跳过。
/// `progress=true` 的那条（模块清单）走流式读，中途会不断报「已收多少」。
async fn FetchJob::get(
  self : FetchJob,
  url : String,
  label : String,
  timeout_ms : Int,
  progress? : Bool,
) -> Json? raise {
  let streaming = progress.unwrap_or(false)
  let mut attempt = 1
  while attempt <= RETRIES {
    if self.cancelled {
      return None
    }
    self.current = label
    self.current_since = now_ms()
    self.say("→ \{label}  \{url}")
    let t0 = now_ms()
    let outcome = if streaming {
      self.fetch_stream(url, label, timeout_ms)
    } else {
      http_once(url, timeout_ms)
    }
    let took = now_ms() - t0
    self.current = ""
    let mut retryable = true
    match outcome {
      Err(msg) => self.say("← 失败：\{msg}（\{dur(took)}）")
      Ok((code, text)) =>
        if code != 200 {
          // 4xx 多半是关键词本身取不出东西，重试也是一样
          retryable = code >= 500
          self.say("← HTTP \{code}  \{kb(text)}  \{dur(took)}")
        } else {
          let parsed = try {
            Some(@json.parse(text))
          } catch {
            _ => None
          }
          match parsed {
            Some(j) => {
              self.say("← 200  \{kb(text)}  \{dur(took)}")
              return Some(j)
            }
            None => self.say("← 200 但正文不是 JSON（\{kb(text)}）")
          }
        }
    }
    if !retryable || attempt >= RETRIES {
      if retryable {
        self.say("   \{RETRIES} 次都失败，跳过这条")
      }
      return None
    }
    let wait = BACKOFF_MS * attempt
    self.say("   \{wait}ms 后重试（第 \{attempt + 1}/\{RETRIES} 次）")
    @async.sleep(wait)
    attempt = attempt + 1
  }
  return None
}

// ---------------------------------------------------------------------------
// 采集主流程
// ---------------------------------------------------------------------------

///|
/// 搜索接口返回的包名做了小写归一（`xunyoyo/Permutation` 回来是
/// `xunyoyo/permutation`），按原名精确匹配会把这类包判成「不在清单里」而丢掉。
/// 所以匹配用下划线小写名，写回用 /modules 里的原名。
///
/// 同一小写名在 /modules 里可能对应多条记录（注册表存了大小写不同的历史版本），
/// 命中时全部写入——它们本来就是同一个包，下载量相同，不该有一条落成 0。
fn harvest(rows : Json, want : Map[String, Array[String]], got : Map[String, Json]) -> Unit {
  for r in jarray(rows) {
    let name = jstr(jget(r, "name"))
    if name == "" {
      continue
    }
    match want.get(name.to_lower()) {
      Some(origins) =>
        for orig in origins {
          got[orig] = json_obj([
            ("downloads", obj_get(r, "downloads").unwrap_or(json_int(0))),
            ("created_at", json_str(jstr(jget(r, "created_at")))),
            ("version", json_str(jstr(jget(r, "version")))),
            ("is_new", json_bool(jbool(jget(r, "is_new")))),
            ("description", json_str(jstr(jget(r, "description")))),
          ])
        }
      None => ()
    }
  }
}

///|
/// 收模块清单：建「小写名 → 原名」与 owner 清单。
fn FetchJob::take_modules(self : FetchJob, data : Json) -> Unit raise StudioError {
  let rows = jarray(data)
  if rows.length() < 1000 {
    raise StudioError::DataError("模块接口返回异常，只有 \{rows.length()} 条")
  }
  let want : Map[String, Array[String]] = Map([])
  let names : Array[String] = []
  let ownerset : Map[String, Bool] = Map([])
  let owners : Array[String] = []
  for r in rows {
    let name = jstr(jget(r, "name"))
    if name == "" {
      continue
    }
    let key = name.to_lower()
    match want.get(key) {
      Some(list) => list.push(name)
      None => want[key] = [name]
    }
    names.push(name)
    let owner = match name.find("/") {
      Some(i) => name[:i].to_owned()
      None => name
    }
    if !ownerset.contains(owner) {
      ownerset[owner] = true
      owners.push(owner)
    }
  }
  self.want = want
  self.total = names.length()
  self.owner_n = owners.length()
  self.owner_i = 0
  self.owner_names = owners
  self.all_names = names
  self.say(
    "   \{rows.length()} 个模块 / \{owners.length()} 个 owner / 去重后 \{names.length()} 个包",
  )
}

///|
/// 粗估剩余时间：一条请求按 6 秒算，加上间隔。
fn estimate(n : Int) -> String {
  let sec = n * (6000 + GAP_MS) / 1000
  if sec < 60 {
    "\{sec} 秒"
  } else if sec < 3600 {
    "\{sec / 60} 分钟"
  } else {
    "\{sec / 3600} 小时 \{sec % 3600 / 60} 分"
  }
}

///|
/// 主流程。任何一步抛错都算整次失败（单条请求失败只是跳过，不抛）。
async fn FetchJob::collect(self : FetchJob, root : String) -> Unit raise {
  // ---- phase 0：模块清单
  self.phase = 0
  self.say("① 拉模块清单（整份快照，慢链路上要一分多钟）")
  let data = match self.get(
    API + "/modules",
    "模块清单",
    MODULES_TIMEOUT_MS,
    progress=true,
  ) {
    Some(d) => d
    None => raise StudioError::DataError("模块清单取不到")
  }
  if self.cancelled {
    raise StudioError::DataError("已停止")
  }
  self.take_modules(data)
  write_text(join(root, "data/raw/modules_api.json"), data.stringify())
  self.say("   已写入 data/raw/modules_api.json")

  // ---- phase 1：按 owner 批量补下载量
  self.phase = 1
  self.say(
    "② 按 owner 补下载量：\{self.owner_n} 个，严格串行、每条间隔 \{GAP_MS}ms（粗估 \{estimate(self.owner_n)}）",
  )
  for o in self.owner_names {
    if self.cancelled {
      raise StudioError::DataError("已停止")
    }
    self.owner_i = self.owner_i + 1
    let url = API + "/search?kw=" + urlencode(o) + "&limit=\{FETCH_LIMIT}"
    let before = self.got.length()
    match self.get(url, "owner \{o}（\{self.owner_i}/\{self.owner_n}）", SEARCH_TIMEOUT_MS) {
      Some(d) => harvest(d, self.want, self.got)
      None => ()
    }
    self.covered = self.got.length()
    self.say(
      "   owner \{o} 增量 +\{self.got.length() - before}，累计覆盖 \{self.covered}/\{self.total}",
    )
    if self.cancelled {
      raise StudioError::DataError("已停止")
    }
    if self.owner_cap > 0 && self.owner_i >= self.owner_cap {
      self.say("   已达到 owner 上限 \{self.owner_cap}（冒烟测试档），提前结束 phase 1")
      break
    }
    @async.sleep(GAP_MS)
  }

  // ---- phase 2：按包名补齐前面没覆盖到的
  if self.owner_cap > 0 {
    self.phase = 2
    self.say("③ 冒烟档跳过按名补齐（全量运行才会走这一步）")
  } else {
    let missing : Array[String] = []
    for n in self.all_names {
      if !self.got.contains(n) {
        missing.push(n)
      }
    }
    missing.sort()
    self.phase = 2
    self.name_n = missing.length()
    self.name_i = 0
    if missing.is_empty() {
      self.say("③ 没有缺口，跳过按名补齐")
    } else {
      self.say("③ 按名补齐：\{missing.length()} 个包（粗估 \{estimate(missing.length())}）")
    }
    for n in missing {
      if self.cancelled {
        raise StudioError::DataError("已停止")
      }
      self.name_i = self.name_i + 1
      let url = API + "/search?kw=" + urlencode(n) + "&limit=\{FETCH_LIMIT}"
      match self.get(url, "包 \{n}（\{self.name_i}/\{self.name_n}）", SEARCH_TIMEOUT_MS) {
        Some(d) => harvest(d, self.want, self.got)
        None => ()
      }
      self.covered = self.got.length()
      if self.cancelled {
        raise StudioError::DataError("已停止")
      }
      @async.sleep(GAP_MS)
    }
  }

  // ---- 收尾：落盘。冒烟档不写，免得把半份下载量留在仓库里
  if self.owner_cap > 0 {
    self.say("冒烟档结束：未写入 downloads.json / meta.json")
    return
  }
  let stamp = today()
  let m : Map[String, Json] = Map([])
  for k in self.got.keys() {
    m[k] = self.got[k]
  }
  write_text(join(root, "data/raw/downloads.json"), @json.to_json(m).stringify())
  write_json(
    join(root, "data/raw/meta.json"),
    json_obj([("collected_at", json_str(stamp))]),
    indent=2,
  )
  let gap = self.total - self.got.length()
  self.say("④ 完成（\{stamp}）：\{self.got.length()}/\{self.total} 个包拿到下载量")
  if gap > 0 {
    self.say("   \{gap} 个查不到（多半是关键词搜不出来的老包）")
  }
  self.say("   已写入 data/raw/downloads.json 与 data/raw/meta.json")

  // ---- phase 5：记一笔历史，首页趋势图读它
  try {
    self.record_point(root)
  } catch {
    e => self.say("   写历史失败：\{e}（不影响本次采集，趋势图少一个点）")
  }
}

///|
/// 把这一次的横截面追加到 `data/history.json`。
///
/// 数字取**已落盘的模块表**（`load_modules`）而不是采集过程中的计数：那边按小写名
/// 去过重，条数与站点上显示的「共 N 个包」一致；用采集计数的话，曲线会和页面上的
/// 数字差几条，看着像丢数据。
fn FetchJob::record_point(self : FetchJob, root : String) -> Unit raise StudioError {
  let mods = load_modules(root)
  let mut total = 0.0
  let mut with_dl = 0
  for name in mods.keys() {
    let d = mods[name].downloads
    total = total + d
    if d > 0.0 {
      with_dl = with_dl + 1
    }
  }
  let at = now_stamp()
  let (prev, _) = record_history(root, at, mods.length(), total, with_dl)
  self.say(
    "⑤ 历史：\{mods.length()} 个包 / 累计 \{fmt_num(total)} 次下载（\{with_dl} 个包有下载量）",
  )
  match prev {
    Some(p) => {
      let dp = mods.length() - p.packages
      let dd = total - p.downloads
      self.say("   较 \{p.date}：包 \{fmt_signed(dp)}，下载 \{fmt_signed_num(dd)}")
    }
    None => self.say("   这是第一条记录，下次采集起首页就能看到趋势")
  }
}

///|
/// 跑一次采集。正常结束、失败、被取消都只设 `done`，不抛给调用方——界面靠
/// `done` / `failed` / `cancelled` 三个标记决定提示什么。
pub async fn FetchJob::run(self : FetchJob, root : String) -> Unit {
  try {
    self.collect(root)
  } catch {
    e => {
      let msg = e.to_string()
      if self.cancelled || msg.contains("已停止") {
        self.say(
          "已停止采集（downloads.json / meta.json / history.json 未写入；modules_api.json 已是新快照，重新生成前请先采完一次或回退它）",
        )
      } else {
        self.failed = true
        self.say("采集失败：\{msg}")
      }
    }
  }
  self.done = true
  // 完整日志落一份到 data/raw/，界面只看尾部
  let b = StringBuilder()
  let mut i = 0
  while i < self.log.length() {
    b.write_string(self.log[i])
    b.write_char('\n')
    i = i + 1
  }
  try {
    write_text(join(root, "data/raw/fetch.log"), b.to_string())
  } catch {
    _ => ()
  }
}

///|
/// 网络自检：发一条请求，打印状态码、字节数、耗时。用来确认这台机器上 async
/// 的 TLS 与注册表都通（不写任何数据）。
pub async fn run_probe(url : String) -> Unit {
  println("→ " + url)
  let t0 = now_ms()
  match http_once(url, 120_000) {
    Ok((code, text)) => {
      println("← HTTP \{code}  \{kb(text)}  \{dur(now_ms() - t0)}")
      if text.length() > 0 {
        println("开头：\{(if text.length() > 120 { text[:120].to_owned() } else { text })}")
      }
    }
    Err(msg) => println("失败：\{msg}（\{dur(now_ms() - t0)}）")
  }
}
