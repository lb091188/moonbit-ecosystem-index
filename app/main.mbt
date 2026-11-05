// 入口：默认打开工作台窗口；带参数时直接跑命令行动作。
//
//   moon run app               打开窗口
//   moon run app -- --build    只生成产物（站点 / 报告 / skill）
//   moon run app -- --fetch    只抓取注册表数据（命令行档：自带最小事件循环）
//   moon run app -- --fetch --fetch-owners 5
//                              只采前 5 个 owner，用来冒烟（不写 downloads.json）
//   moon run app -- --check    读一遍数据并打印概况，不写文件
//   moon run app -- --probe [url]   网络自检：取一条 URL，打印耗时与 poll 次数
//   moon run app -- --serve [port]  本地预览 dist/（默认 8000，Ctrl+C 停止）

///|
/// 入口是 async 的：采集走 `@async/http`。窗口模式把 `App::step`（跑一帧）放进
/// 协程里，帧末 `@async.pause()` 把控制权交回 async；命令行模式直接 await。
///|
async fn main {
  let args = @env.args()
  let root = find_root()
  // async 会接管信号处理，默认不响应 SIGINT/SIGTERM——不注册的话命令行里
  // Ctrl+C 和 timeout 的 TERM 都杀不掉进程（只能 -9）。注册成「取消所有协程」，
  // 采集会正常收手、stdout 也会刷出来。
  @signal.set_global_cancellation_signals([
    @signal.Signal::SIGINT,
    @signal.Signal::SIGTERM,
  ])
  if args.contains("--probe") {
    let mut url = API + "/search?kw=moonbitlang&limit=10"
    let mut i = 0
    while i < args.length() {
      if args[i] == "--probe" && i + 1 < args.length() {
        url = args[i + 1]
      }
      i = i + 1
    }
    run_probe(url)
    return
  }
  if args.contains("--serve") {
    // 本地预览。端口可选，非法值一律回落到 8000。
    let mut port = 8000
    let mut i = 0
    while i < args.length() {
      if args[i] == "--serve" && i + 1 < args.length() {
        let p = int_of(args[i + 1], 8000)
        if p > 0 && p < 65536 {
          port = p
        }
      }
      i = i + 1
    }
    serve_dist(root, port)
    return
  }
  if args.contains("--build") {
    let log : Array[String] = []
    try {
      let r = build_all(root, default_skill_dir(root), load_weights(root), log)
      println("完成：模块 \{r.modules} / 场景 \{r.scenarios} / 方案包 \{r.solutions}")
    } catch {
      e => println("构建失败：\{e}")
    }
    return
  }
  if args.contains("--check") {
    try {
      let s = load_studio(root)
      s.modules = load_modules(root)
      println("根目录 \{root}")
      println(
        "分组 \{s.cat.groups.length()} / 场景 \{s.cat.scenarios.length()} / 模块 \{s.modules.length()}",
      )
      println("简介 \{s.blurbs.length()} 条 / 英文场景 \{s.i18n_order.length()} 条")
      for g in s.cat.groups {
        println("  [\{g.id}] \{g.title} — \{g.title_en}")
      }
    } catch {
      e => println("读取失败：\{e}")
    }
    return
  }
  if args.contains("--save") {
    // 读一遍再原样写回：用来验证「不改字段时保存不产生差异」
    try {
      let s = load_studio(root)
      s.sync_i18n()
      s.save_all()
      println("已保存（未改动任何字段）")
    } catch {
      e => println("保存失败：\{e}")
    }
    return
  }
  if args.contains("--fetch") {
    let job = FetchJob::make()
    // `--fetch-owners N`：冒烟档，只采前 N 个 owner。全量一次以小时计，改一行
    // 代码就跑一遍全量不现实。
    let mut i = 0
    while i + 1 < args.length() {
      if args[i] == "--fetch-owners" {
        job.owner_cap = int_of(args[i + 1], 0)
      }
      i = i + 1
    }
    job.run(root)
    if job.failed {
      println("采集失败")
    }
    return
  }
  open_studio(root)
}
