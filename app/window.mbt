// 工作台窗口：标题栏 + 四段导航 + 左侧场景树 + 右侧编辑区。
//
// 数据真身是 `Studio`（内存里的场景表、译文、简介、注册表快照）；界面只持有
// 一份引用。所有「改数据 → 重画」都走两条重建信号：
//   rev_tree  左侧树（选中态、标题、顺序、分组归属都变了才重建）
//   rev_pane  右侧编辑区（换页、换选中项、换包、保存后重算都要重建）
// 重建一律经 `post`（宿主下一拍任务）执行，避免在控件自己的点击回调里把
// 自己从树上摘掉。

///|
const PAGE_SCENE : String = "场景管理"

///|
const PAGE_PKG : String = "包数据"

///|
const PAGE_FETCH : String = "数据更新"

///|
const PAGE_BUILD : String = "数据生成"

///|
let page_names : Array[String] = [PAGE_SCENE, PAGE_PKG, PAGE_FETCH, PAGE_BUILD]

///|
/// 表单字段的寄存处：顶栏与主体分两次构建，保存按钮和输入框必须拿到同一份
/// `Store`，否则点保存写的是另一份没被编辑过的副本。作用域（页 / 选中项 /
/// 选中包）一变就整批丢弃，切走再回来等于重读文件。
struct FormCache {
  mut scope : String
  mut strs : Map[String, @base.Store[String]]
  mut flags : Map[String, @base.Store[Bool]]
}

///|
pub struct App {
  studio : Studio
  /// 顶部四段导航的当前页
  page : @base.Store[String]
  /// 左树选中项：场景 id，或 `g:<gid>` 表示选中分组
  sel : @base.Store[String]
  /// 包数据页里选中的包名
  pkg : @base.Store[String]
  /// 包数据页的搜索词。**不进 form 缓存**：切包、切场景都该留着，
  /// 它是「我在找什么」，不是某一屏的输入。
  pkg_q : @base.Store[String]
  /// 当前页是否「宽页」（数据更新 / 数据生成）：宽页不显示左侧场景树
  wide : @base.Store[Bool]
  /// 当前页表单的字段缓存
  form : FormCache
  /// 左树多选模式：开启后点行是勾选，不是切换右侧
  multi : @base.Store[Bool]
  /// 多选模式里勾中的场景 id
  picked : Array[String]
  /// 正在新建场景（右侧显示空白表单）
  mut drafting : Bool
  /// 包数据页里勾中的包名
  pkg_picked : Array[String]
  /// 删除场景已「上膛」：第一次点按钮只备好，再点一次才真删
  mut del_armed : Bool
  /// 底部状态行
  status : @base.Store[String]
  /// 数据更新页的日志行（每次采集重开一份）
  fetch_log : @base.Store[Array[String]]
  /// 数据更新页的状态行（阶段 + 计数 + 当前在等谁，按秒变）
  fetch_tick : @base.Store[String]
  /// 数据生成页的日志行。与采集**分开**：两件事互不覆盖，各自的日志各留各的
  build_log : @base.Store[Array[String]]
  rev_tree : @base.ListStore[String]
  rev_pane : @base.ListStore[String]
  tree_scroll : @ui.ScrollState
  pane_scroll : @ui.ScrollState
  mut tree_ver : Int
  mut pane_ver : Int
  /// 数据更新任务（协程里跑，没有任务时为 None）
  mut job : FetchJob?
  /// 正在生成（一次同步计算，用来把生成按钮锁成「生成中…」）
  mut building : Bool
  /// 权重（数据生成页可改，落 data/build.json）
  weights : Weights
  host : Ref[@widget.App?]
}

///|
fn bump(ls : @base.ListStore[String], key : String) -> Unit {
  let cur = ls.get()
  if cur.length() == 1 && cur[0] == key {
    return
  }
  ls.splice(0, cur.length(), [key])
}

///|
fn App::refresh_tree(self : App) -> Unit {
  self.tree_ver = self.tree_ver + 1
  bump(
    self.rev_tree,
    "\{self.tree_ver}|\{self.sel.get()}|\{self.multi.get()}|\{self.picked.length()}|\{self.drafting}",
  )
}

///|
fn App::refresh_pane(self : App) -> Unit {
  self.pane_ver = self.pane_ver + 1
  bump(
    self.rev_pane,
    "\{self.pane_ver}|\{self.page.get()}|\{self.sel.get()}|\{self.pkg.get()}|\{self.pkg_q.get()}|\{self.picked.length()}|\{self.pkg_picked.length()}|\{self.drafting}",
  )
}

///|
/// 下一拍执行：回调里不做重活，卸载控件也不在派发中途发生。
fn App::post(self : App, work : () -> Unit) -> Unit {
  match self.host.val {
    Some(h) => h.task(work)
    None => ()
  }
}

///|
/// 换场景 / 换页时主区回到顶部。新内容不该继承上一屏的滚动位置；旧内容里的
/// 偏移还留在 `ScrollState` 上的话，新页面一挂载就停在中段，看着像丢了一截。
fn App::home(self : App) -> Unit {
  self.pane_scroll.set_offset(0.0)
}

///|
/// 字段寄存的作用域：换页、换场景、换包都算另起一份。
fn App::form_scope(self : App) -> String {
  "\{self.page.get()}|\{self.sel.get()}|\{self.pkg.get()}|\{self.drafting}"
}

///|
fn App::form_reset(self : App) -> Unit {
  let sc = self.form_scope()
  if self.form.scope != sc {
    self.form.scope = sc
    self.form.strs = Map([])
    self.form.flags = Map([])
  }
}

///|
/// 取（或建）一个字符串字段。顶栏与主体两次构建拿的是同一个 Store。
fn App::fstr(self : App, name : String, init : String) -> @base.Store[String] {
  self.form_reset()
  match self.form.strs.get(name) {
    Some(s) => s
    None => {
      let s = @base.Store::new(init)
      self.form.strs[name] = s
      s
    }
  }
}

///|
fn App::fflag(self : App, name : String, init : Bool) -> @base.Store[Bool] {
  self.form_reset()
  match self.form.flags.get(name) {
    Some(s) => s
    None => {
      let s = @base.Store::new(init)
      self.form.flags[name] = s
      s
    }
  }
}

///|
fn App::select(self : App, id : String) -> Unit {
  self.post(fn() {
    self.sel.set(id)
    self.pkg.set("")
    // 勾选是按场景列的，换场景必须丢掉，否则批量会把上一场景的包算进来
    self.pkg_picked.clear()
    self.home()
    self.refresh_tree()
    self.refresh_pane()
  })
}

///|
/// 进入单包编辑：包数据页从「列表」切到「详情」。详情单独一屏，不再挂在列表
/// 底下——列表动辄六十行，编辑框被推到最下面，改一个 boost 得滚半屏。
fn App::open_pkg(self : App, name : String) -> Unit {
  self.post(fn() {
    self.pkg.set(name)
    // 勾选是列表里的批量手段，进详情就不用带着了
    self.pkg_picked.clear()
    self.home()
    self.refresh_pane()
  })
}

///|
fn App::close_pkg(self : App) -> Unit {
  self.post(fn() {
    self.pkg.set("")
    self.home()
    self.refresh_pane()
  })
}

///|
/// 进出多选模式：切换时清掉已选，免得带着上一次的勾选去批量改。
fn App::toggle_multi(self : App) -> Unit {
  self.multi.set(!self.multi.get())
  self.picked.clear()
  self.drafting = false
  self.refresh_tree()
  self.refresh_pane()
}

///|
fn App::toggle_pick(self : App, id : String) -> Unit {
  let keep : Array[String] = []
  let mut had = false
  for x in self.picked {
    if x == id {
      had = true
    } else {
      keep.push(x)
    }
  }
  self.picked.clear()
  for x in keep {
    self.picked.push(x)
  }
  if !had {
    self.picked.push(id)
  }
  self.refresh_tree()
  self.refresh_pane()
}

///|
/// 点分组行：本组已全选就去掉整组，否则补齐全组。
fn App::toggle_group_pick(self : App, gid : String) -> Unit {
  let kids = self.studio.cat.scenarios_of(gid)
  let mut all = !kids.is_empty()
  for s in kids {
    if !self.picked.contains(s.id) {
      all = false
    }
  }
  for s in kids {
    if all {
      let keep : Array[String] = []
      for x in self.picked {
        if x != s.id {
          keep.push(x)
        }
      }
      self.picked.clear()
      for x in keep {
        self.picked.push(x)
      }
    } else if !self.picked.contains(s.id) {
      self.picked.push(s.id)
    }
  }
  self.refresh_tree()
  self.refresh_pane()
}

///|
fn App::clear_pick(self : App) -> Unit {
  self.picked.clear()
  self.refresh_tree()
  self.refresh_pane()
}

///|
fn App::toggle_pkg_pick(self : App, name : String) -> Unit {
  let keep : Array[String] = []
  let mut had = false
  for x in self.pkg_picked {
    if x == name {
      had = true
    } else {
      keep.push(x)
    }
  }
  self.pkg_picked.clear()
  for x in keep {
    self.pkg_picked.push(x)
  }
  if !had {
    self.pkg_picked.push(name)
  }
  self.refresh_pane()
}

///|
fn App::clear_pkg_pick(self : App) -> Unit {
  self.pkg_picked.clear()
  self.refresh_pane()
}

///|
fn App::start_draft(self : App) -> Unit {
  self.drafting = true
  self.multi.set(false)
  self.picked.clear()
  self.pkg_picked.clear()
  // 丢掉旧缓存，保证新建表单是空的而不是上一个场景的残留
  self.form.scope = ""
  self.home()
  self.refresh_tree()
  self.refresh_pane()
}

///|
fn App::cancel_draft(self : App) -> Unit {
  self.drafting = false
  self.form.scope = ""
  self.refresh_tree()
  self.refresh_pane()
}

///|
/// 删除场景：第一次点只上膛并说明，第二次点才落盘；3 秒不点自动复位，
/// 免得按钮一直处于「一碰就删」的状态。
fn App::drop_scenario(self : App, id : String, title : String) -> Unit {
  if !self.del_armed {
    self.del_armed = true
    self.say("再点一次「确认删除」才会删掉「\{title}」，3 秒后自动取消")
    match self.host.val {
      Some(h) => ignore(h.timer(3000, fn() {
        self.del_armed = false
        self.refresh_pane()
      }))
      None => ()
    }
    self.refresh_pane()
    return
  }
  self.del_armed = false
  self.studio.cat.remove_scenario(id)
  let first = if self.studio.cat.scenarios.length() > 0 {
    self.studio.cat.scenarios[0].id
  } else {
    ""
  }
  self.sel.set(first)
  self.pkg.set("")
  self.pkg_picked.clear()
  self.form.scope = ""
  ignore(self.commit())
  self.say("已删除场景「\{title}」")
}

///|
fn App::say(self : App, line : String) -> Unit {
  self.status.set(line)
}

///|
/// 把内存里的编辑写回磁盘（三份文件一起），随后重画左右两侧。
fn App::commit(self : App) -> Bool {
  self.studio.sync_i18n()
  let mut ok = true
  try {
    self.studio.save_all()
  } catch {
    e => {
      ok = false
      self.say("保存失败：\{e}")
    }
  }
  if ok {
    self.say("已保存 data/scenarios.src.json / data/i18n.json / data/blurbs.json")
  }
  self.post(fn() {
    self.refresh_tree()
    self.refresh_pane()
  })
  ok
}

///|
/// 采集协程挂在窗口主任务组上：窗口一关就随组收掉，不会跑野。
let studio_group : Ref[@async.TaskGroup[Unit]?] = Ref(None)

///|
pub fn current_studio_group() -> @async.TaskGroup[Unit]? {
  studio_group.val
}

///|
/// 常驻心跳：每 33ms 一个到期任务。`App::step` 里「等事件」的预算由壳层按到期
/// 任务算，没有任务时是 -1（无限等）——那样主线程会一直卡在窗口事件上，async
/// 的网络事件就轮不到。有一拍到期任务在，等待预算最长一帧，主循环必然回来。
fn heartbeat(w : @widget.App) -> Unit {
  ignore(w.timer(33, fn() {
    heartbeat(w)
  }))
}

///|
pub async fn open_studio(root : String) -> Unit {
  let mut loaded : Studio? = None
  try {
    loaded = Some(load_studio(root))
  } catch {
    e => println("读取失败：\{e}")
  }
  let studio = match loaded {
    Some(s) => s
    None => return
  }
  try {
    studio.modules = load_modules(root)
  } catch {
    e => println("模块表读取失败：\{e}")
  }
  studio.collected_at = collected_at(root)
  let first = if studio.cat.scenarios.length() > 0 {
    studio.cat.scenarios[0].id
  } else {
    ""
  }
  let app : App = {
    studio,
    page: @base.Store::new(PAGE_SCENE),
    sel: @base.Store::new(first),
    pkg: @base.Store::new(""),
    pkg_q: @base.Store::new(""),
    wide: @base.Store::new(false),
    form: { scope: "", strs: Map([]), flags: Map([]) },
    multi: @base.Store::new(false),
    picked: [],
    drafting: false,
    pkg_picked: [],
    del_armed: false,
    status: @base.Store::new(
      "数据根目录 \{root}｜场景 \{studio.cat.scenarios.length()} 个，模块表 \{studio.modules.length()} 条",
    ),
    fetch_log: @base.Store::new([]),
    fetch_tick: @base.Store::new("空闲（右上角「执行更新」开始）"),
    build_log: @base.Store::new([]),
    rev_tree: @base.ListStore::new(),
    rev_pane: @base.ListStore::new(),
    tree_scroll: @ui.ScrollState::new(),
    pane_scroll: @ui.ScrollState::new(),
    tree_ver: 0,
    pane_ver: 0,
    job: None,
    building: false,
    weights: load_weights(root),
    host: Ref(None),
  }
  app.refresh_tree()
  app.refresh_pane()
  // 输入框的 Ctrl+C/X/V 接系统剪贴板（只影响此后新建的输入框，故在建 UI 前开）
  @ui.use_system_clipboard(true)
  let mounted = @ui.mount_window(
    [shell(app)],
    title="MoonBit 生态索引 · 数据工作台",
    width=1320,
    height=880,
    handle=fn(h) {
      app.host.val = Some(h)
      ignore(h.follow_system_theme())
      app.page.subscribe(fn(p) {
        app.post(fn() {
          // 宽页收起左树；左树的滚动位置一并归零，来回切页不会停在半截
          app.wide.set(p == PAGE_FETCH || p == PAGE_BUILD)
          app.tree_scroll.set_offset(0.0)
          // 多选只属于场景管理：带着它去包数据页，左树的点击会被当成勾选，
          // 右侧场景根本换不过去
          if p != PAGE_SCENE && app.multi.get() {
            app.multi.set(false)
            app.picked.clear()
            app.refresh_tree()
          }
          app.home()
          app.refresh_pane()
        })
      })
    },
  )
  match mounted {
    Some(a) => {
      // 主循环交给 async：`GuiLoop::poll` 跑一帧窗口，IO/定时器就绪时 async 的
      // 等待线程调 `wm_wakeup` 把卡在 `@win.wait` 里的这一帧叫醒。采集协程挂在
      // 这个任务组上，窗口关掉就随组一起收掉。
      // 主循环放在 async 里：每帧先跑窗口（`step` 内部按到期任务决定等多久），
      // 帧末 `@async.pause()` 把控制权交回 async，网络事件才有机会被处理。
      // 常驻心跳保证 `step` 的等待预算永远不超过一帧，不会无限阻塞在窗口事件上。
      heartbeat(a)
      let mut alive = true
      @async.with_task_group(async fn(group) {
        studio_group.val = Some(group)
        while alive {
          alive = a.step()
          // 日志框跟随到底：放在 step 之后，这时本帧的内容高才是新的（见
          // pane_jobs.follow_log_tick）。不跟随时不做事；只推进当前页的那一份。
          follow_log_tick(app)
          if alive {
            @async.pause()
          }
        }
        studio_group.val = None
      })
      println("STUDIO-DONE")
    }
    None => println("STUDIO-SKIP: 本平台没有窗口后端或没有显示服务")
  }
}

// ---------------------------------------------------------------- 骨架

///|
fn shell(app : App) -> @widget.Node {
  @ui.col(
    [
      header(app),
      @ui.row(
        [
          // 宽页的左树收成 0 宽占位（`set_visible` 走 display:none，不占位也不吃
          // 栏间距），右侧自然铺满整行
          @ui.when_else_store_bool(
            app.wide,
            @ui.view([], width=0.0),
            left_panel(app),
          ),
          right_panel(app),
        ],
        grow=1.0,
        column_gap=12.0,
        align_items=@yoga.AlignItems::Stretch,
      ),
      @ui.text_dyn(
        app.status.signal(),
        class=[@style.text_secondary],
        wrap=false,
        ellipsis=true,
      ),
    ],
    grow=1.0,
    row_gap=12.0,
    padding=12.0,
    background_color="bg_page",
  )
}

///|
fn header(app : App) -> @widget.Node {
  @ui.col(
    [
      @ui.segmented(page_names, app.page),
    ],
    row_gap=8.0,
  )
}

///|
/// 左栏：工具行固定（新建 / 多选），树单独滚动——新建按钮不该被树滚走。
///
/// 工具行只属于场景管理：包数据页借这棵树选场景，不该顺手「新建场景」或进多选
/// （多选里的点行是勾选，不换右侧内容）。显隐走 `when_store`。
///
/// 列间距刻意给 0、工具行自带 `margin_bottom=12`（与右栏「顶栏→主体」的 12 一致）：
/// `when_store` 隐掉内容后，外面那层宿主仍是个 flex 子项，`row_gap` 会照算一份，
/// 包数据页的左树就比右侧顶栏低 8px。间距改挂在工具行自己身上，隐藏时连同
/// margin 一起消失，左侧顶边才和右侧顶栏齐平。
fn left_panel(app : App) -> @widget.Node {
  @ui.col(
    [
      @ui.when_store(app.page, scene_tools(app), pred=fn(p : String) -> Bool {
        p == PAGE_SCENE
      }),
      @ui.scroll_view(
        [
          @ui.for_list(
            app.rev_tree,
            fn(_k, _i) {
              tree_body(app)
            },
            key=fn(k : String) {
              k
            },
          ),
        ],
        app.tree_scroll,
        class=[@style.style(flex=1.0)],
      ),
    ],
    width=272.0,
    grow=1.0,
    row_gap=0.0,
  )
}

///|
fn scene_tools(app : App) -> @widget.Node {
  @ui.row(
    [
      @ui.button("新建场景", on_click=fn() {
        app.start_draft()
      }, variant=@ui.Border),
      // 字数随多选态变的按钮：左栏只建一次，标签得靠两支常驻切显隐来换
      @ui.when_else_store_bool(
        app.multi,
        @ui.button("退出多选", on_click=fn() {
          app.toggle_multi()
        }, variant=@ui.Border),
        @ui.button("多选", on_click=fn() {
          app.toggle_multi()
        }, variant=@ui.Border),
      ),
    ],
    column_gap=6.0,
    class=[@style.style(margin_bottom=12.0)],
  )
}

///|
/// 右栏：顶栏（标题 + 保存/执行按钮）固定，只有主体进滚动视口。视口自带一圈
/// 描边，这里按 class 覆盖掉，让表单直接落在页面底色上。
///
/// 两块各占一个 `for_list` 槽位：槽位宿主是自动生成的容器，宽度靠外层 `col` 的
/// stretch 撑满，高度由内容决定；滚动视口本身带 `flex=1`，才吃得到剩余高度。
///
/// 主体外面再套一层 `view(grow=1)`，是为了给悬浮操作条一个「够大的父盒」：
/// 控件绘制时会把子件裁到自己的矩形里，浮层若直接挂在零高度的槽位上会被裁没。
fn right_panel(app : App) -> @widget.Node {
  @ui.col(
    [
      @ui.for_list(
        app.rev_pane,
        fn(_k, _i) {
          pane_head(app)
        },
        key=fn(k : String) {
          k
        },
      ),
      @ui.view(
        [
          @ui.scroll_view(
            [
              @ui.for_list(
                app.rev_pane,
                fn(_k, _i) {
                  pane_body(app)
                },
                key=fn(k : String) {
                  k
                },
              ),
            ],
            app.pane_scroll,
            class=[@style.style(flex=1.0, border_width=0.0)],
          ),
          dock(app),
        ],
        grow=1.0,
      ),
    ],
    grow=1.0,
    row_gap=12.0,
  )
}

// ---------------------------------------------------------------- 左树

///|
/// 可点的一行：选中态给底色，悬停给 hover 桶。
fn click_row(
  children : Array[@widget.Node],
  selected : Bool,
  on_click : () -> Unit,
) -> @widget.Node {
  @ui.view(
    children,
    direction=@yoga.Row,
    padding=6.0,
    column_gap=6.0,
    background_color=if selected {
      "primary_light"
    } else {
      ""
    },
    class=[
      @style.style(
        cursor=@widget.CURSOR_HAND,
        hover=@style.style(background_color="fill_hover"),
      ),
    ],
    handle=fn(w) {
      w.on_pointer = Some(fn(_s, ev) {
        match ev.kind {
          // 按下要认领，否则宿主不会把抬起派回本行
          @widget.PointerKind::Down => true
          @widget.PointerKind::Up => {
            on_click()
            true
          }
          _ => false
        }
      })
    },
  )
}

///|
fn tree_body(app : App) -> @widget.Node {
  let cat = app.studio.cat
  let sel = app.sel.get()
  let multi = app.multi.get()
  let blocks : Array[@widget.Node] = []
  for g in cat.groups {
    let gid = "g:" + g.id
    let kids = cat.scenarios_of(g.id)
    let mut all_picked = !kids.is_empty()
    for s in kids {
      if !app.picked.contains(s.id) {
        all_picked = false
      }
    }
    blocks.push(
      click_row(
        [
          @ui.text(g.label(), class=[@style.text_secondary], wrap=false),
          @ui.view([], grow=1.0),
          @ui.text(
            if multi && all_picked { "● \{kids.length()}" } else { "\{kids.length()}" },
            class=[@style.text_secondary],
          ),
        ],
        !multi && gid == sel,
        fn() {
          if multi {
            app.toggle_group_pick(g.id)
          } else {
            app.select(gid)
          }
        },
      ),
    )
    for s in kids {
      let on = s.id == sel
      let picked = app.picked.contains(s.id)
      let cells : Array[@widget.Node] = []
      if multi {
        cells.push(
          @ui.text(
            if picked { "●" } else { "○" },
            class=[@style.text_secondary],
            wrap=false,
          ),
        )
      }
      cells.push(@ui.text(s.icon, wrap=false))
      cells.push(
        @ui.text(
          s.title,
          wrap=false,
          ellipsis=true,
          color=if multi && picked {
            "primary"
          } else if !multi && on {
            "primary"
          } else {
            "text_regular"
          },
        ),
      )
      blocks.push(
        click_row(
          cells,
          if multi { picked } else { on },
          fn() {
            if multi {
              app.toggle_pick(s.id)
            } else {
              app.select(s.id)
            }
          },
        ),
      )
    }
  }
  @ui.col(blocks, row_gap=2.0, padding=8.0)
}
