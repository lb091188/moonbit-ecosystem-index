// 数据更新 / 数据生成两页：说明 + 表单 + 执行按钮 + 日志。
//
// 两件事的「慢」不是一种慢，界面上也分开对待：
//   · 采集是**等网络**，几小时起。它跑在协程里（`@async/http`），等待期间主线程
//     照常跑窗口循环，所以采集时切页、滚动、点按钮全都不受影响；顶栏按钮同时
//     变成「停止采集」。
//   · 生成是**纯本地计算**，一秒出头。它确实占着主线程，所以按下之后先把
//     「生成中…」写进日志、按钮置灰，隔 60ms 再动手：那一拍没有立即任务，
//     窗口能把字先画出来，用户看到的是「按下 → 生成中 → 出结果」，而不是按下
//     之后界面一声不响地顿一下。
// 执行按钮固定在顶栏；两页的日志各一份（`fetch_log` / `build_log`），互不覆盖。

// ---------------------------------------------------------------- 日志面板
//
// 日志是**追加型**的长文本，一屏只看得到十几行。原先用 `textarea` 装：每多一行
// 就要整段重新折行，几千行之后每帧都在白算，于是越跑越卡。这里换成虚拟列表
// （`virt_list`）——只挂可见的十几行，行数涨到几千也不影响帧率。
//
// 代价是行高必须等距：每行套一个钉死 `LOG_ROW_H` 的行槽，长行不折行（折了
// 行高就不一致，偏移与内容对不上），超出部分由控件自身裁剪。

///|
/// 单行高度。虚拟列表按等距窗口从偏移算下标，行槽必须与它严格一致。
const LOG_ROW_H : Double = 20.0

///|
/// 一份日志面板：视口句柄 + 「是否贴底」。
///
/// 贴底为什么不直接调 `ScrollState::scroll_to_bottom`：`virt_list` 与
/// `textarea` 一样把 `ScrollState` 建在组件内部、不交给调用方，`handle` 只给
/// 一个 `Widget`。能用的入口只有它自己的 `on_scroll` —— `dy` 给一个极大的
/// 负值（负 = 向下），内部越界夹取会一步走到底。库那边补上 `state` 参数后
/// 这段可以删掉（见 docs/verify.md）。
struct LogView {
  view : Ref[@widget.Widget?]
  /// 是否贴底：用户往上翻就停（那是要读旧行），往下翻或重开任务就恢复
  follow : Ref[Bool]
  /// 上次同步给界面的行数与末行——内容没变就别 set，省掉一次整窗重挂
  mut seen_n : Int
  mut seen_last : String
}

///|
fn LogView::make() -> LogView {
  { view: Ref(None), follow: Ref(true), seen_n: -1, seen_last: "" }
}

///|
fn LogView::bind(self : LogView, w : @widget.Widget) -> Unit {
  stretch(w)
  self.view.val = Some(w)
  self.follow.val = true
  let follow = self.follow
  // 滚轮：dy 正 = 往上翻 = 想看旧行，停跟随；dy 负 = 往下翻，恢复
  let orig_scroll = w.on_scroll
  w.on_scroll = Some(fn(ev : @widget.ScrollEvent) -> Bool {
    let handled = match orig_scroll {
      Some(f) => f(ev)
      None => false
    }
    // 真滚动了才改状态：已经在底还往下滚（返回 false）不该重置跟随
    if handled {
      follow.val = ev.dy <= 0.0
    }
    handled
  })
  // 拖动滚动条走它自己的 on_pointer，收不到滚轮那条，这里一并接住：
  // 按在条的底部 = 想回到底部（恢复跟随）；按在别处往上拖 = 暂停
  for kid in w.kids {
    let orig_press = kid.on_pointer
    kid.on_pointer = Some(fn(
      sw : @widget.Widget,
      ev : @widget.PointerEvent,
    ) -> Bool {
      let handled = match orig_press {
        Some(f) => f(sw, ev)
        None => false
      }
      match ev.kind {
        @widget.PointerKind::Down =>
          follow.val = ev.y > sw.rect.h - 24.0
        _ => ()
      }
      handled
    })
  }
}

///|
fn LogView::scroll_bottom(self : LogView) -> Unit {
  let ev : @widget.ScrollEvent = {
    x: 0.0,
    y: 0.0,
    dx: 0.0,
    dy: -1.0e9,
    mods: 0,
  }
  match self.view.val {
    Some(w) =>
      match w.on_scroll {
        // 返回 true = 偏移真动了。`virt_list` 内部已按新窗口重挂并自带重绘，
        // 这里再 invalidate 一次是幂等的。
        Some(f) => if f(ev) {
          @widget.invalidate()
        }
        None => ()
      }
    None => ()
  }
}

///|
/// 每帧一次：跟随时把偏移贴到底。必须放在 `step()` **之后**——内容高是那一帧
/// 绘制时才算出来的，在写数据的同一拍里滚，夹取用的是上一帧的旧高度。
fn LogView::tick(self : LogView) -> Unit {
  if self.follow.val {
    self.scroll_bottom()
  }
}

///|
/// 把新日志行推给界面。日志只追加，所以「行数 + 末行」就足以判断有没有变化。
fn LogView::show(
  self : LogView,
  store : @base.Store[Array[String]],
  lines : Array[String],
) -> Unit {
  let n = lines.length()
  let last = if n == 0 { "" } else { lines[n - 1] }
  if n != self.seen_n || last != self.seen_last {
    self.seen_n = n
    self.seen_last = last
    store.set(lines)
  }
}

///|
/// 重开一份日志：清空并恢复贴底。
fn LogView::reset(self : LogView, store : @base.Store[Array[String]]) -> Unit {
  self.seen_n = 0
  self.seen_last = ""
  self.follow.val = true
  store.set([])
}

///|
let fetch_view : LogView = LogView::make()

///|
let build_view : LogView = LogView::make()

///|
fn log_panel(
  store : @base.Store[Array[String]],
  view : LogView,
  height : Double,
) -> @widget.Node {
  @ui.virt_list(
    store,
    height,
    LOG_ROW_H,
    fn(_i : Int, line : String) -> @widget.Node {
      @ui.view(
        [
          @ui.text(
            line,
            font_size=12.0,
            wrap=false,
            ellipsis=true,
            class=[@style.text_secondary],
          ),
        ],
        height=LOG_ROW_H,
        justify_content=@yoga.JustifyContent::Center,
      )
    },
    overscan=4,
    handle=fn(w) {
      view.bind(w)
    },
  )
}

///|
/// 每帧调一次（主循环 `step()` 之后）：只推进**当前页**那一份。切到别的页时
/// 视图已不在树上，继续推只会白重挂、白请求重绘。
pub fn follow_log_tick(app : App) -> Unit {
  let p = app.page.get()
  if p == PAGE_FETCH {
    fetch_view.tick()
  } else if p == PAGE_BUILD {
    build_view.tick()
  }
}

// ---------------------------------------------------------------- 数据更新

///|
fn fetch_running(app : App) -> Bool {
  match app.job {
    Some(j) => !j.done
    None => false
  }
}

///|
fn fetch_head(app : App) -> @widget.Node {
  let running = fetch_running(app)
  head_row([
    @ui.text("数据更新", class=[@style.text_title]),
    @ui.view([], grow=1.0),
    @ui.button(
      if running { "停止采集" } else { "执行更新" },
      on_click=fn() {
        if running {
          stop_fetch(app)
        } else {
          start_fetch(app)
        }
      },
      variant=if running { @ui.Border } else { @ui.Solid },
    ),
  ])
}

///|
fn fetch_body(app : App) -> @widget.Node {
  @ui.col(
    [
      @ui.alert(
        "从 mooncakes 注册表重采下载量与版本",
        description="一次全量模块列表 + 按 owner 批量补下载量。请求走 async、严格串行、每条之间留 0.8 秒，失败按 1.6/3.2/4.8 秒退避重试——全量以小时计，慢是正常的。日志逐条记录每次请求的地址、耗时、大小与覆盖进度，并自动跟随到底（往上翻可以停住看旧行，再往下翻恢复）。完整一份结束时落在 data/raw/fetch.log。写入 data/raw/modules_api.json、downloads.json、meta.json，不改场景表。期间可以继续看别的页、改场景；要收手按顶栏的「停止采集」。",
        t=@ui.Info,
      ),
      @ui.card(
        [
          // 状态行单独一条：它每秒都在变（「在等 owner xxx 已 3.2 秒」），
          // 混进日志列表会让整窗每 300 毫秒重挂一遍
          @ui.text_dyn(
            app.fetch_tick.signal(),
            font_size=12.0,
            class=[@style.text_secondary],
          ),
          log_panel(app.fetch_log, fetch_view, 396.0),
        ],
        title="采集日志",
        padding=12.0,
        row_gap=8.0,
      ),
    ],
    row_gap=12.0,
  )
}

///|
/// 起一个采集协程。协程挂在窗口主任务组上：窗口一关就随组收掉，不会跑野。
fn start_fetch(app : App) -> Unit {
  if fetch_running(app) {
    return
  }
  let job = FetchJob::make()
  app.job = Some(job)
  fetch_view.reset(app.fetch_log)
  app.fetch_tick.set("准备中…")
  app.say("开始采集（协程后台跑，窗口照常响应）")
  match current_studio_group() {
    Some(group) => {
      let root = app.studio.root
      group.spawn_bg(async fn() {
        job.run(root)
      })
    }
    None => {
      // 窗口主循环没就绪（理论上到不了这里）：不留一个永远不动的任务
      job.cancel()
      app.say("采集只能在窗口主循环里启动")
    }
  }
  app.post(fn() {
    app.refresh_pane()
  })
  app.post(fn() {
    pump_fetch(app)
  })
}

///|
/// 停止：只置标记，协程在下一个检查点收手。`downloads.json` / `meta.json` /
/// `history.json` 不会落半份，但 phase 0 的 `modules_api.json` 已经刷新；重新生成
/// 产物前要先把这次采集跑完，避免新旧快照混算。
fn stop_fetch(app : App) -> Unit {
  match app.job {
    Some(j) => if !j.done { j.cancel() }
    None => ()
  }
}

///|
/// 把协程写下的日志搬到界面上，并盯着它跑完。
fn pump_fetch(app : App) -> Unit {
  match app.job {
    None => ()
    Some(j) => {
      // 日志按行推给虚拟列表，状态行单独一条（只重绘那一行）
      fetch_view.show(app.fetch_log, j.lines())
      app.fetch_tick.set(j.progress())
      if j.done {
        app.job = None
        if j.failed {
          app.say("采集失败，见日志")
        } else if j.cancelled {
          app.say("已停止采集（下载量与历史未写入，模块清单已更新）")
        } else {
          // 采集完顺手重载模块表，包数据页才用得上新数字
          try {
            app.studio.modules = load_modules(app.studio.root)
            app.studio.collected_at = collected_at(app.studio.root)
          } catch {
            e => println("重载模块表失败：\{e}")
          }
          app.say("采集完成，模块表 \{app.studio.modules.length()} 条")
        }
        // 无论成没成都要重画顶栏：按钮得从「停止采集」回到「执行更新」
        app.post(fn() {
          app.refresh_pane()
        })
        return
      }
      // 300ms 一拍：日志是给人看的，比这更密只是白重挂窗口
      match app.host.val {
        Some(h) => ignore(h.timer(300, fn() {
          pump_fetch(app)
        }))
        None => ()
      }
    }
  }
}

// ---------------------------------------------------------------- 数据生成

///|
fn build_head(app : App) -> @widget.Node {
  let busy = app.building
  head_row([
    @ui.text("数据生成", class=[@style.text_title]),
    @ui.view([], grow=1.0),
    @ui.button(
      if busy { "生成中…" } else { "执行生成" },
      on_click=fn() {
        start_build(app)
      },
      variant=@ui.Solid,
      disabled=busy,
    ),
  ])
}

///|
fn build_body(app : App) -> @widget.Node {
  let w = app.weights
  @ui.col(
    [
      @ui.alert(
        "读当前场景表与注册表快照，重算榜单并产出全部交付物",
        description="data/scenarios.json、data/modules.json、scenarios.md、dist/index.html + dist/assets/app.js + dist/data/scenarios.json，以及选型 skill 的 references/（一个场景一份 md + 总表 scenarios.md）。skill 直接写在仓库的 skills/moonbit-stack-selection/ 里，不往家目录另存副本；改完提交、推送即同步到 GitHub。",
        t=@ui.Info,
      ),
      section(
        [
          @ui.row(
            [
              field("相关度权重 rel_w", @ui.input(app.fstr("rel_w", "\{w.rel_w}"), width=110.0)),
              field("相关度上限 rel_cap", @ui.input(app.fstr("rel_cap", "\{w.rel_cap}"), width=110.0)),
              field("下载量权重 dl_w", @ui.input(app.fstr("dl_w", "\{w.dl_w}"), width=110.0)),
              field("pin 权重 pin_w", @ui.input(app.fstr("pin_w", "\{w.pin_w}"), width=110.0)),
              field("下载量下限 min_dl", @ui.input(app.fstr("min_dl", "\{w.min_dl}"), width=110.0)),
            ],
            column_gap=12.0,
            align_items=@yoga.AlignItems::FlexEnd,
          ),
          field(
            "skill 输出目录（默认在仓库内，随 git 同步到 GitHub）",
            @ui.input(app.fstr("skill", default_skill_dir(app.studio.root))),
          ),
          @ui.row(
            [
              @ui.view([], grow=1.0),
              @ui.button("保存权重", on_click=fn() {
                save_weight(app)
              }, variant=@ui.Border),
            ],
            column_gap=8.0,
          ),
        ],
        "排序权重",
      ),
      @ui.card(
        [log_panel(app.build_log, build_view, 240.0)],
        title="生成日志",
        padding=12.0,
        row_gap=8.0,
      ),
    ],
    row_gap=12.0,
  )
}

///|
fn save_weight(app : App) -> Unit {
  let w = app.weights
  w.rel_w = num_of(app.fstr("rel_w", "\{w.rel_w}").get(), w.rel_w)
  w.rel_cap = num_of(app.fstr("rel_cap", "\{w.rel_cap}").get(), w.rel_cap)
  w.dl_w = num_of(app.fstr("dl_w", "\{w.dl_w}").get(), w.dl_w)
  w.pin_w = num_of(app.fstr("pin_w", "\{w.pin_w}").get(), w.pin_w)
  w.min_dl = num_of(app.fstr("min_dl", "\{w.min_dl}").get(), w.min_dl)
  let mut ok = true
  try {
    save_weights(app.studio.root, w)
  } catch {
    e => {
      ok = false
      app.say("权重保存失败：\{e}")
    }
  }
  if ok {
    app.say("排序权重已写入 data/build.json")
  }
  app.post(fn() {
    app.refresh_pane()
  })
}

///|
/// 生成入口：先落一句「生成中…」并把按钮置灰，隔一拍再真跑。
/// 为什么不当场跑——在点击回调里直接做，这一帧要等活干完才画得出来，用户
/// 看到的就是「按下去，界面僵一秒多」。`timer(60)` 那一拍没有立即任务，
/// 窗口能先把状态画上屏。
fn start_build(app : App) -> Unit {
  if app.building {
    return
  }
  app.building = true
  build_view.reset(app.build_log)
  build_view.show(
    app.build_log,
    ["生成中…（读数据、算榜、写站点与 skill，约 1–2 秒，这期间窗口会顿一下）"],
  )
  // 顶栏按钮先切成「生成中…」
  app.post(fn() {
    app.refresh_pane()
  })
  match app.host.val {
    Some(h) =>
      ignore(h.timer(60, fn() {
        finish_build(app)
      }))
    None => finish_build(app)
  }
}

///|
fn finish_build(app : App) -> Unit {
  let log : Array[String] = []
  let root = app.studio.root
  let skill = app.fstr("skill", default_skill_dir(root)).get()
  // 日志里报仓库相对路径，读起来比一长串绝对路径清楚
  let shown = if skill.has_prefix(root + "/") {
    skill[root.length() + 1:].to_owned()
  } else {
    skill
  }
  try {
    let r = build_all(root, skill, app.weights, log)
    log.push("完成：模块 \{r.modules} / 场景 \{r.scenarios} / 方案包 \{r.solutions}")
    log.push("skill 落在 \{shown}｜提交并推送后即同步到 GitHub")
    app.say("生成完成：dist/ 站点、scenarios.md、skill → \{shown}")
  } catch {
    e => {
      log.push("生成失败：\{e}")
      app.say("生成失败，见日志")
    }
  }
  app.building = false
  build_view.show(app.build_log, log)
  // 生成会改场景表的派生数据（榜单、报告、skill），右侧重画一遍才对得上
  app.post(fn() {
    app.refresh_pane()
  })
}
