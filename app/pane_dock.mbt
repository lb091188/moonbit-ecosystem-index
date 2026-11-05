// 悬浮操作条：勾选之后长出来的那一排按钮，贴在右栏底部，绝对定位。
//
// 之前这些按钮长在顶栏里：一勾选，顶栏就从「标题 + 保存」换成「已选 N 个」，
// 高度和内容都变，底下的表单被推下去再弹回来，滚到一半的位置也跟着跳。改成
// 浮层后勾选只影响这一条自己，滚动位置、表单位置都不动。
//
// 定位壳带 left/right/bottom、高度随内容，不参与排版；没勾选时内容是一个零高
// `view`，浮层既不可见也命中不到（零高矩形 contains 恒假），不会挡住下层点击。

///|
fn App::cur_scene(self : App) -> Scenario? {
  let sel = self.sel.get()
  if sel.has_prefix("g:") {
    return None
  }
  self.studio.cat.find(sel)
}

///|
fn dock(app : App) -> @widget.Node {
  @ui.view(
    [
      @ui.for_list(
        app.rev_pane,
        fn(_k, _i) {
          dock_content(app)
        },
        key=fn(k : String) {
          k
        },
      ),
    ],
    // 走 class 而不是 handle：样式槽是唯一定位来源，换主题重放样式时不会被抹掉
    class=[
      @style.style(
        position=@yoga.Absolute,
        left=0.0,
        // 右侧让出滚动条的宽度，别把滑块盖住
        right=16.0,
        bottom=0.0,
      ),
    ],
  )
}

///|
/// 底部浮条此刻是否在显示。主体用它决定要不要留尾部空档——浮条压在内容上，
/// 不留空档的话列表最后三四行永远被盖住。
fn dock_showing(app : App) -> Bool {
  let page = app.page.get()
  if page == PAGE_SCENE {
    return !app.picked.is_empty()
  }
  if page == PAGE_PKG {
    return !app.pkg_picked.is_empty() && app.pkg.get() == ""
  }
  false
}

///|
fn dock_height(app : App) -> Double {
  if !dock_showing(app) {
    return 0.0
  }
  // 场景条一行，包条两行（批量动作 + 加入场景）
  if app.page.get() == PAGE_PKG {
    104.0
  } else {
    60.0
  }
}

///|
fn dock_content(app : App) -> @widget.Node {
  let page = app.page.get()
  if page == PAGE_SCENE {
    return scene_dock(app)
  }
  if page == PAGE_PKG {
    return pkg_dock(app)
  }
  @ui.view([])
}

///|
fn scene_dock(app : App) -> @widget.Node {
  if app.picked.is_empty() {
    return @ui.view([])
  }
  let opts : Array[String] = []
  let mut cur = ""
  for g in app.studio.cat.groups {
    opts.push(g.label())
    if cur == "" {
      cur = g.label()
    }
  }
  // 默认落在第一个选中场景所在的分组：批量操作多是「挪到别处」
  match app.studio.cat.find(app.picked[0]) {
    Some(s0) =>
      for g in app.studio.cat.groups {
        if g.id == s0.group {
          cur = g.label()
        }
      }
    None => ()
  }
  @ui.card(
    [
      @ui.row(
        [
          @ui.text("已选 \{app.picked.length()} 个场景", class=[@style.text_title], wrap=false),
          @ui.text(
            "改分组会整段挪到目标组末尾，组内顺序不变",
            class=[@style.text_secondary],
            wrap=false,
          ),
          @ui.view([], grow=1.0),
          @ui.select(opts, app.fstr("batch_group", cur), width=180.0),
          @ui.button("改到该分组", on_click=fn() {
            apply_batch_group(app)
          }, variant=@ui.Solid),
          @ui.button("清空选择", on_click=fn() {
            app.clear_pick()
          }, variant=@ui.Border),
        ],
        column_gap=8.0,
      ),
    ],
    padding=10.0,
  )
}

///|
fn pkg_dock(app : App) -> @widget.Node {
  // 详情屏不挂批量条：那屏一次只编辑一个包
  if app.pkg_picked.is_empty() || app.pkg.get() != "" {
    return @ui.view([])
  }
  let s = match app.cur_scene() {
    Some(s) => s
    None => return @ui.view([])
  }
  let opts : Array[String] = []
  let mut first = ""
  for x in app.studio.cat.scenarios {
    if x.id != s.id {
      let label = "\{x.icon} \{x.title}"
      opts.push(label)
      if first == "" {
        first = label
      }
    }
  }
  let join_row : Array[@widget.Node] = [
    @ui.text("加入场景", class=[@style.text_secondary], wrap=false),
  ]
  if opts.is_empty() {
    join_row.push(@ui.text("只有一个场景", class=[@style.text_secondary]))
  } else {
    join_row.push(@ui.select(opts, app.fstr("join_to", first), width=200.0))
    join_row.push(
      @ui.button("加入", on_click=fn() {
        batch_join(app, s)
      }, variant=@ui.Solid),
    )
  }
  join_row.push(
    @ui.text(
      "同一个包可以同时属于多个场景：加入只写目标，本场景不动",
      class=[@style.text_secondary],
      wrap=false,
    ),
  )
  @ui.card(
    [
      @ui.row(
        [
          @ui.text("已选 \{app.pkg_picked.length()} 个包", class=[@style.text_title], wrap=false),
          @ui.view([], grow=1.0),
          @ui.button("标为方案", on_click=fn() {
            batch_pkg(app, s, "sol")
          }, variant=@ui.Border),
          @ui.button("置顶", on_click=fn() {
            batch_pkg(app, s, "pin")
          }, variant=@ui.Border),
          @ui.button("强制收录", on_click=fn() {
            batch_pkg(app, s, "force")
          }, variant=@ui.Border),
          @ui.button("移出本场景", on_click=fn() {
            batch_pkg(app, s, "drop")
          }, variant=@ui.Border),
          @ui.button("清空", on_click=fn() {
            app.clear_pkg_pick()
          }, variant=@ui.Border),
        ],
        column_gap=8.0,
      ),
      @ui.row(join_row, column_gap=8.0),
    ],
    padding=10.0,
    row_gap=8.0,
  )
}
