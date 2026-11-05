// 右侧编辑区：按顶部导航分派到四个页面。
//
// 每页拆成 `pane_head`（顶栏：标题、条数、保存/执行按钮，固定在顶部）与
// `pane_body`（表单或日志，单独进滚动视口）。两边是两次独立构建，字段一律走
// `app.fstr` / `app.fflag` 取——同一作用域内拿到的是同一个 `Store`，保存按钮
// 读到的就是输入框里的值。
//
// 场景管理：场景表单（中英标题 / 简介 / 备注 / 分组 / 图标 / top / curated）
// 与分组表单（中英名）；包数据：场景内候选包列表 + 单包简介与关联度；
// 数据更新 / 数据生成：执行按钮 + 日志。

///|
fn pane_head(app : App) -> @widget.Node {
  let page = app.page.get()
  if page == PAGE_PKG {
    pkg_head(app)
  } else if page == PAGE_FETCH {
    fetch_head(app)
  } else if page == PAGE_BUILD {
    build_head(app)
  } else {
    scene_head(app)
  }
}

///|
fn pane_body(app : App) -> @widget.Node {
  let page = app.page.get()
  let node = if page == PAGE_PKG {
    pkg_body(app)
  } else if page == PAGE_FETCH {
    fetch_body(app)
  } else if page == PAGE_BUILD {
    build_body(app)
  } else {
    scene_body(app)
  }
  // 底部浮条是压着内容画的，留出与它等高的空档，最后几行才滚得出来
  if dock_showing(app) {
    @ui.col([node, @ui.view([], height=dock_height(app))], row_gap=0.0)
  } else {
    node
  }
}

///|
/// 顶栏统一高度 = 控件高度。顶栏里只要有一个按钮或选择器就占满这一档；标题行
/// 若按文字自然高度（14 号字一行约 20），列表屏与详情屏来回切时上沿会差十来个
/// 像素，滚动区跟着上下跳。所以所有顶栏一律钉成这个高度。
const HEAD_H : Double = 32.0

///|
fn head_row(children : Array[@widget.Node]) -> @widget.Node {
  @ui.row(
    children,
    column_gap=8.0,
    height=HEAD_H,
    align_items=@yoga.AlignItems::Center,
  )
}

///|
fn hint_head(text : String) -> @widget.Node {
  head_row([@ui.text(text, class=[@style.text_title], wrap=false)])
}

///|
fn hint_body(text : String) -> @widget.Node {
  @ui.card([@ui.empty(description=text)], padding=24.0)
}

///|
fn field(label : String, control : @widget.Node) -> @widget.Node {
  @ui.col([@ui.text(label, class=[@style.text_secondary]), control], row_gap=4.0)
}

///|
/// 让定宽控件（textarea 自己钉了 260）跟随列宽。
fn stretch(w : @widget.Widget) -> Unit {
  w.node.set_width(@yoga.percent(100.0))
  w.node.set_min_width(@yoga.fixed(0.0))
}

///|
fn section(children : Array[@widget.Node], title : String) -> @widget.Node {
  @ui.card(children, title=title, padding=12.0, row_gap=8.0)
}

// ---------------------------------------------------------------- 场景管理

///|
fn scene_head(app : App) -> @widget.Node {
  if app.drafting {
    return head_row([
      @ui.text("新建场景", class=[@style.text_title]),
      @ui.text("id 建好后不可改", class=[@style.text_secondary]),
      @ui.view([], grow=1.0),
      @ui.button("取消", on_click=fn() {
        app.cancel_draft()
      }, variant=@ui.Border),
      @ui.button("保存并加入", on_click=fn() {
        save_draft(app)
      }, variant=@ui.Solid),
    ])
  }
  // 多选的批量动作挂在底部浮条上（pane_dock.mbt），顶栏保持「这个场景」不变：
  // 顶栏一换内容，底下的表单就要跟着上下跳。
  let sel = app.sel.get()
  if sel.has_prefix("g:") {
    match app.studio.cat.group(sel[2:].to_owned()) {
      Some(g) =>
        head_row([
          @ui.text("分组", class=[@style.text_title]),
          @ui.text(g.id, class=[@style.text_secondary]),
          @ui.view([], grow=1.0),
          @ui.button("保存", on_click=fn() {
            save_group(app, g)
          }, variant=@ui.Solid),
        ])
      None => hint_head("分组不存在，左侧重新选一个")
    }
  } else {
    match app.studio.cat.find(sel) {
      Some(s) =>
        head_row([
          @ui.text("\{s.icon} \{s.title}", class=[@style.text_title]),
          @ui.text(s.id, class=[@style.text_secondary]),
          @ui.view([], grow=1.0),
          @ui.button("上移", on_click=fn() {
            app.studio.cat.move_scenario(s.id, -1)
            ignore(app.commit())
          }, variant=@ui.Border),
          @ui.button("下移", on_click=fn() {
            app.studio.cat.move_scenario(s.id, 1)
            ignore(app.commit())
          }, variant=@ui.Border),
          @ui.button(
            if app.del_armed { "确认删除" } else { "删除" },
            on_click=fn() {
              app.drop_scenario(s.id, s.title)
            },
            variant=@ui.Border,
          ),
          @ui.button("保存", on_click=fn() {
            save_scenario(app, s)
          }, variant=@ui.Solid),
        ])
      None => hint_head("左侧选一个场景或分组")
    }
  }
}

///|
fn scene_body(app : App) -> @widget.Node {
  if app.drafting {
    return draft_form(app)
  }
  let sel = app.sel.get()
  if sel.has_prefix("g:") {
    match app.studio.cat.group(sel[2:].to_owned()) {
      Some(g) => group_form(app, g)
      None => hint_body("左侧选一个分组")
    }
  } else {
    match app.studio.cat.find(sel) {
      Some(s) => scenario_form(app, s)
      None => hint_body("左侧选一个场景或分组")
    }
  }
}

///|
/// 分组表单：只改中文名与英文名，id 是各场景 `group` 字段的引用键，不能改。
fn group_form(app : App, g : Group) -> @widget.Node {
  let zh = app.fstr("g_title", g.title)
  let en = app.fstr("g_title_en", g.title_en)
  @ui.col(
    [
      section(
        [field("中文名", @ui.input(zh)), field("英文名", @ui.input(en))],
        "分组名称",
      ),
    ],
    row_gap=12.0,
  )
}

///|
fn save_group(app : App, g : Group) -> Unit {
  let zh = app.fstr("g_title", g.title).get()
  let en = app.fstr("g_title_en", g.title_en).get()
  let gs = app.studio.cat.groups
  for i = 0; i < gs.length(); i = i + 1 {
    if gs[i].id == g.id {
      gs[i] = gs[i].renamed(zh, en)
    }
  }
  ignore(app.commit())
}

///|
fn scenario_form(app : App, s : Scenario) -> @widget.Node {
  let groups = app.studio.cat.groups
  let opts : Array[String] = []
  let mut cur = ""
  for g in groups {
    opts.push(g.label())
    if g.id == s.group {
      cur = g.label()
    }
  }
  @ui.col(
    [
      section(
        [
          field("图标", @ui.input(app.fstr("icon", s.icon), width=120.0)),
          field("中文标题", @ui.input(app.fstr("title", s.title))),
        ],
        "标识",
      ),
      section([field("英文标题", @ui.input(app.fstr("title_en", s.title_en)))], "译文标题"),
      section(
        [
          field(
            "简介（中文）",
            @ui.textarea(app.fstr("intro", s.intro), rows=3, handle=stretch),
          ),
          field(
            "简介（英文）",
            @ui.textarea(app.fstr("intro_en", s.intro_en), rows=4, handle=stretch),
          ),
        ],
        "简介",
      ),
      section(
        [
          field(
            "备注（中文，可空）",
            @ui.textarea(app.fstr("note", s.note), rows=2, handle=stretch),
          ),
          field(
            "备注（英文，可空）",
            @ui.textarea(app.fstr("note_en", s.note_en), rows=2, handle=stretch),
          ),
        ],
        "备注",
      ),
      section(
        [
          field(
            "所属分组",
            @ui.select(opts, app.fstr("group", cur), width=200.0),
          ),
          field(
            "榜单条数 top",
            @ui.input(app.fstr("top", s.top.to_string()), width=120.0),
          ),
          @ui.checkbox("人工圈定（curated）", app.fflag("curated", s.curated)),
        ],
        "位置与规则",
      ),
      rules_section(app, s),
    ],
    row_gap=12.0,
  )
}

///|
/// 收录规则：一行一个词。改这里等于改「哪些包会被收进来」，比逐个 pin 影响大，
/// 所以单独放一块并写清后果。
fn rules_section(app : App, s : Scenario) -> @widget.Node {
  section(
    [
      field(
        "关键词 kw（命中一个得 3 分；一行一个）",
        @ui.textarea(app.fstr("kw", s.str_list("kw").join("\n")), rows=5, handle=stretch),
      ),
      field(
        "描述词 desc（描述里出现即加分；短语可带空格）",
        @ui.textarea(app.fstr("desc", s.str_list("desc").join("\n")), rows=4, handle=stretch),
      ),
      field(
        "排除词 ex（包名或关键词命中即整个不收）",
        @ui.textarea(app.fstr("ex", s.str_list("ex").join("\n")), rows=3, handle=stretch),
      ),
      field(
        "必备词 core（至少命中一个才收；留空=不限）",
        @ui.textarea(app.fstr("core", s.str_list("core").join("\n")), rows=2, handle=stretch),
      ),
      field(
        "排除描述 ex_desc（描述命中即不收）",
        @ui.textarea(
          app.fstr("ex_desc", s.str_list("ex_desc").join("\n")),
          rows=2,
          placeholder="每行一个",
          handle=stretch,
        ),
      ),
      @ui.alert(
        "改完记得点保存，再到「包数据」看候选变化",
        description="规则是全场景生效的：kw 加宽会让榜单变长，ex 写宽会把本来该收的包挤掉。只想动个别包时，优先用包数据页的置顶 / 强制收录 / 移出。",
        t=@ui.Info,
      ),
    ],
    "收录规则（高级）",
  )
}

///|
fn save_scenario(app : App, s : Scenario) -> Unit {
  s.title = app.fstr("title", s.title).get()
  s.title_en = app.fstr("title_en", s.title_en).get()
  s.intro = app.fstr("intro", s.intro).get()
  s.intro_en = app.fstr("intro_en", s.intro_en).get()
  s.note = app.fstr("note", s.note).get()
  s.note_en = app.fstr("note_en", s.note_en).get()
  s.icon = app.fstr("icon", s.icon).get()
  s.top = int_of(app.fstr("top", s.top.to_string()).get(), s.top)
  s.curated = app.fflag("curated", s.curated).get()
  let gl = app.fstr("group", "").get()
  for g in app.studio.cat.groups {
    if g.label() == gl {
      s.group = g.id
    }
  }
  for key in ["kw", "desc", "ex", "core", "ex_desc"] {
    let xs = lines_of(app.fstr(key, "").get())
    if !xs.is_empty() || !s.str_list(key).is_empty() {
      s.set_str_list(key, xs)
    }
  }
  ignore(app.commit())
}

// ---------------------------------------------------------------- 新建与批量

///|
fn draft_form(app : App) -> @widget.Node {
  let opts : Array[String] = []
  let mut first = ""
  for g in app.studio.cat.groups {
    opts.push(g.label())
    if first == "" {
      first = g.label()
    }
  }
  @ui.col(
    [
      section(
        [
          field(
            "id（小写字母、数字、连字符；建好后不可改）",
            @ui.input(app.fstr("n_id", ""), width=220.0),
          ),
          field("所属分组", @ui.select(opts, app.fstr("n_group", first), width=200.0)),
          field("图标", @ui.input(app.fstr("n_icon", "🧩"), width=120.0)),
          field("中文标题", @ui.input(app.fstr("n_title", ""))),
          field("榜单条数 top", @ui.input(app.fstr("n_top", "8"), width=120.0)),
        ],
        "标识与位置",
      ),
      section(
        [
          field("英文标题", @ui.input(app.fstr("n_title_en", ""))),
          field(
            "简介（中文）",
            @ui.textarea(app.fstr("n_intro", ""), rows=3, handle=stretch),
          ),
          field(
            "简介（英文）",
            @ui.textarea(app.fstr("n_intro_en", ""), rows=3, handle=stretch),
          ),
        ],
        "文案",
      ),
      @ui.alert(
        "新建只写场景表与译文，不碰候选包",
        description="保存后到「包数据」页给它勾选收录的包（或改关键词 kw / desc）。没有包的场景在站点上是空榜。",
        t=@ui.Info,
      ),
    ],
    row_gap=12.0,
  )
}

///|
fn save_draft(app : App) -> Unit {
  let id = app.fstr("n_id", "").get().trim().to_owned()
  let err = app.studio.cat.valid_new_id(id)
  if err != "" {
    app.say(err)
    return
  }
  let label = app.fstr("n_group", "").get()
  let mut gid = ""
  for g in app.studio.cat.groups {
    if g.label() == label {
      gid = g.id
    }
  }
  if gid == "" {
    app.say("先选一个分组")
    return
  }
  let s = Scenario::blank(id, gid)
  s.icon = app.fstr("n_icon", "🧩").get()
  s.title = app.fstr("n_title", "").get()
  s.title_en = app.fstr("n_title_en", "").get()
  s.intro = app.fstr("n_intro", "").get()
  s.intro_en = app.fstr("n_intro_en", "").get()
  s.top = int_of(app.fstr("n_top", "8").get(), 8)
  if s.title == "" {
    s.title = id
  }
  // 英文栏留空就先顶中文：i18n.json 里出现空串，英文页会是一片空白
  if s.title_en == "" {
    s.title_en = s.title
  }
  if s.intro_en == "" {
    s.intro_en = s.intro
  }
  app.studio.cat.add_scenario(s)
  app.drafting = false
  app.form.scope = ""
  app.sel.set(id)
  app.home()
  ignore(app.commit())
  app.say("已新建场景 \{id}")
}

///|
fn apply_batch_group(app : App) -> Unit {
  let label = app.fstr("batch_group", "").get()
  let mut gid = ""
  for g in app.studio.cat.groups {
    if g.label() == label {
      gid = g.id
    }
  }
  if gid == "" {
    app.say("先选目标分组")
    return
  }
  let n = app.picked.length()
  app.studio.cat.reassign(app.picked, gid)
  app.clear_pick()
  ignore(app.commit())
  app.say("已把 \{n} 个场景移到「\{label}」")
}
