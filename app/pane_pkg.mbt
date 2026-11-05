// 包数据管理：当前场景的候选包列表，与单包编辑详情。
//
// 两个屏，不再挤在一列里：
//   列表  候选 N 条 + 已移出 N 条，点一行进详情；行首圆点是批量勾选
//   详情  注册表数据、简介、关联度、所属场景；顶栏一个「返回列表」+「保存」
// 列表动辄五六十行，详情挂在列表底下时改一个 boost 要先滚过半屏，拆开才顺手。
//
// 一个包可以**同时属于多个场景**（moui 既在桌面也在移动端），所以：
//   · 跨场景的动作是「加入」，只写目标场景，不动本场景
//   · 详情里有「所属场景」一栏，逐个列出显式收录它的场景，可就地移出
// 显式收录 = pick / pin / force / sol / boost 里点过名；纯靠关键词命中的场景
// 不列（那要跑全量打分，逐帧算不起，也不该由这里改）。

///|
fn set_member(sc : Scenario, key : String, name : String, want : Bool) -> Unit {
  let xs = sc.str_list(key)
  if xs.contains(name) == want {
    return
  }
  if want {
    xs.push(name)
    sc.set_str_list(key, xs)
  } else {
    let out : Array[String] = []
    for x in xs {
      if x != name {
        out.push(x)
      }
    }
    sc.set_str_list(key, out)
  }
}

///|
/// 显式收录判据：有人点过名才算。`drop` 一票否决——移出之后即使别处还留着
/// 旧标记，也不该再算进来。
fn in_scenario(sc : Scenario, name : String) -> Bool {
  if sc.str_list("drop").contains(name) {
    return false
  }
  if sc.str_list("pick").contains(name) ||
    sc.str_list("pin").contains(name) ||
    sc.str_list("force").contains(name) ||
    sc.str_list("sol").contains(name) {
    return true
  }
  for (k, _v) in sc.num_map("boost") {
    if k == name {
      return true
    }
  }
  false
}

///|
/// 把包「加入」一个场景。`pick` 非空表示这个场景是人工圈定模式，候选只认 pick，
/// 此时写 force 是无效的，必须落到 pick 末尾。
fn add_to_scenario(sc : Scenario, name : String) -> Unit {
  set_member(sc, "drop", name, false)
  if sc.str_list("pick").is_empty() {
    set_member(sc, "force", name, true)
  } else {
    set_member(sc, "pick", name, true)
  }
}

///|
/// 把包从某场景摘掉：四个名单一起清，boost 也抹掉，否则它会以另一种身份
/// 重新冒出来。`drop` 留一条，挡住纯靠关键词命中的路径。
fn remove_from_scenario(sc : Scenario, name : String) -> Unit {
  set_member(sc, "drop", name, true)
  set_member(sc, "pick", name, false)
  set_member(sc, "sol", name, false)
  set_member(sc, "pin", name, false)
  set_member(sc, "force", name, false)
  sc.num_remove("boost", name)
}

///|
/// 行首的勾选格：独立认领指针，点它不会顺带打开详情。
fn mark_cell(on : Bool, toggle : () -> Unit) -> @widget.Node {
  @ui.view(
    [@ui.text(if on { "●" } else { "○" }, class=[@style.text_secondary], wrap=false)],
    direction=@yoga.Row,
    padding=2.0,
    class=[@style.style(cursor=@widget.CURSOR_HAND)],
    handle=fn(w) {
      w.on_pointer = Some(fn(_s, ev) {
        match ev.kind {
          @widget.PointerKind::Down => true
          @widget.PointerKind::Up => {
            toggle()
            true
          }
          _ => false
        }
      })
    },
  )
}

// ---------------------------------------------------------------- 顶栏

///|
/// 「加入场景」的候选：本场景之外、还没显式收录它的场景。归属的增删都挂在
/// 详情屏顶栏，正文里只列现状——一屏一件事，找按钮不用往下滚。
fn add_targets(app : App, cur : Scenario, name : String) -> Array[String] {
  let opts : Array[String] = []
  for x in app.studio.cat.scenarios {
    if x.id != cur.id && !in_scenario(x, name) {
      opts.push("\{x.icon} \{x.title}")
    }
  }
  opts
}

///|
fn pkg_head(app : App) -> @widget.Node {
  let sel = app.sel.get()
  if sel.has_prefix("g:") {
    return hint_head("包数据按场景列出，左侧选一个场景")
  }
  let s = match app.studio.cat.find(sel) {
    Some(s) => s
    None => return hint_head("左侧选一个场景")
  }
  let chosen = app.pkg.get()
  if chosen != "" {
    // 详情屏：返回 + 包名 + 加入场景 + 保存。保存放这里，编辑框滚多远都不用找按钮。
    let mod = app.studio.find_module(chosen)
    let stats = match mod {
      Some(m) => "\{s.title} · 下载 \{(m.downloads).to_int()}"
      None => "\{s.title} · 注册表快照里没有这个包"
    }
    let cells : Array[@widget.Node] = [
      @ui.button("← 返回列表", on_click=fn() {
        app.close_pkg()
      }, variant=@ui.Border),
      @ui.text(chosen, class=[@style.text_title], wrap=false),
      @ui.text(stats, class=[@style.text_secondary], wrap=false, ellipsis=true),
      @ui.view([], grow=1.0),
    ]
    let targets = add_targets(app, s, chosen)
    if targets.is_empty() {
      cells.push(@ui.text("其他场景都已收录", class=[@style.text_secondary], wrap=false))
    } else {
      cells.push(
        @ui.select(
          targets,
          app.fstr("pkg_add_to", targets[0]),
          width=150.0,
          placeholder="选场景",
        ),
      )
      cells.push(
        @ui.button("加入场景", on_click=fn() {
          add_elsewhere(app, s, chosen)
        }, variant=@ui.Border),
      )
    }
    cells.push(
      @ui.button("保存", on_click=fn() {
        save_pkg(app, s, chosen)
      }, variant=@ui.Solid),
    )
    return head_row(cells)
  }
  let ranked = rank_scenario(s, app.studio.modules, app.weights)
  let q = app.pkg_q.get().trim().to_owned()
  head_row([
    @ui.text("\{s.icon} \{s.title} · 包数据", class=[@style.text_title], wrap=false),
    @ui.text(
      if q == "" {
        "候选 \{ranked.items.length()} 条｜点一行进入编辑"
      } else {
        "搜索「\{q}」｜候选 \{ranked.items.length()} 条"
      },
      class=[@style.text_secondary],
      wrap=false,
    ),
    @ui.view([], grow=1.0),
  ])
}

// ---------------------------------------------------------------- 主体

///|
fn pkg_body(app : App) -> @widget.Node {
  let sel = app.sel.get()
  if sel.has_prefix("g:") {
    return hint_body("左侧选一个场景")
  }
  let s = match app.studio.cat.find(sel) {
    Some(s) => s
    None => return hint_body("左侧选一个场景")
  }
  let chosen = app.pkg.get()
  if chosen != "" {
    return pkg_detail(app, s, chosen)
  }
  pkg_list(app, s)
}

// ---------------------------------------------------------------- 本地搜索
//
// 「本地」= `data/raw/modules_api.json` 落下来的 `studio.modules`（几千个包），
// 不联网、不重新打分。它回答两类以前根本查不了的问题：
//   · 本场景候选里有没有 ×××（候选只显示前 60 条，后面的一直翻不到）
//   · 注册表里有没有 ×××，它属于哪个场景（命中但不在候选里的，单列一卡）
//
// 触发是「回车 / 点搜索 / 清空」，不是逐键过滤：每键都要重排一遍全库并重建
// 整页控件，打字会顿，光标也会被重建打断。清空例外——那一下必须立刻生效。

///|
/// 命中判定：包名、描述、关键词任一包含。全部转小写比，英文关键词与中文
/// 描述走同一套规则。
fn module_hit(m : Module, q : String) -> Bool {
  if m.name.to_lower().contains(q) {
    return true
  }
  if m.description.to_lower().contains(q) {
    return true
  }
  for k in m.keywords {
    if k.to_lower().contains(q) {
      return true
    }
  }
  false
}

///|
/// 按下载量降序插入（命中通常几十条，插入排序足够，不必为此引一个比较器）。
fn push_by_dl(xs : Array[(Double, String)], dl : Double, name : String) -> Unit {
  let mut i = xs.length()
  xs.push((dl, name))
  while i > 0 && xs[i - 1].0 < dl {
    xs[i] = xs[i - 1]
    i = i - 1
  }
  xs[i] = (dl, name)
}

///|
fn pkg_search(app : App, hint : String) -> @widget.Node {
  @ui.row(
    [
      @ui.input(
        app.pkg_q,
        placeholder="搜包名 / 描述 / 关键词（本地快照）",
        width=380.0,
        clearable=true,
        // 固定焦点号：重建后焦点还在框里，回车搜完能接着改词
        focus_id=9001,
        on_enter=fn() {
          app.post(fn() {
            app.refresh_pane()
          })
        },
        on_change=fn(t : String) {
          // 打字不重建（理由见上）；清空要立刻生效
          if t.trim() == "" {
            app.post(fn() {
              app.refresh_pane()
            })
          }
        },
      ),
      @ui.button("搜索", on_click=fn() {
        app.post(fn() {
          app.refresh_pane()
        })
      }, variant=@ui.Border),
      @ui.text(hint, class=[@style.text_secondary], wrap=false, ellipsis=true),
    ],
    column_gap=8.0,
    align_items=@yoga.AlignItems::Center,
  )
}

///|
fn pkg_list(app : App, s : Scenario) -> @widget.Node {
  let ranked = rank_scenario(s, app.studio.modules, app.weights)
  let items = ranked.items
  // 原文留着给人看（「搜 Web」不该被回显成「搜 web」），小写的一份用来比
  let q_raw = app.pkg_q.get().trim().to_owned()
  let q = q_raw.to_lower()
  let searching = q_raw != ""
  // 候选按命中过滤；上限只在非搜索时生效——要找的就是那几条，被「前 60」
  // 截掉等于搜不到。搜索时放宽到 80：再多人眼也看不过来，而这里是每次
  // 重建都实打实挂控件（不是虚拟列表），挂太多反而卡。
  let shown : Array[RankItem] = []
  for it in items {
    if searching {
      match app.studio.modules.get(it.name) {
        Some(m) =>
          if module_hit(m, q) {
            shown.push(it)
          }
        None => ()
      }
    } else {
      shown.push(it)
    }
  }
  let cap = (if searching { 80 } else { 60 }).min(shown.length())
  let rows : Array[@widget.Node] = []
  for i = 0; i < cap; i = i + 1 {
    let it = shown[i]
    let picked = app.pkg_picked.contains(it.name)
    rows.push(
      click_row(
        [
          mark_cell(picked, fn() {
            app.post(fn() {
              app.toggle_pkg_pick(it.name)
            })
          }),
          @ui.text("\{i + 1}", class=[@style.text_secondary], wrap=false),
          @ui.text(it.name, wrap=false, ellipsis=true),
          @ui.view([], grow=1.0),
          @ui.text(
            if it.tier == "solution" { "方案" } else { "库" },
            class=[@style.text_secondary],
            wrap=false,
          ),
          @ui.text(fmt1(it.score), class=[@style.text_secondary], wrap=false),
          @ui.text("›", class=[@style.text_secondary], wrap=false),
        ],
        false,
        fn() {
          app.open_pkg(it.name)
        },
      ),
    )
  }
  // 已移出：搜索时也过一遍，免得搜出来的卡片里混着无关行
  let all_drops = s.str_list("drop")
  let drops : Array[String] = []
  for name in all_drops {
    if !searching || name.to_lower().contains(q) {
      drops.push(name)
    }
  }
  let drop_rows : Array[@widget.Node] = []
  for name in drops {
    drop_rows.push(
      click_row(
        [
          @ui.text("+", class=[@style.text_secondary], wrap=false),
          @ui.text(name, wrap=false, ellipsis=true),
          @ui.view([], grow=1.0),
          @ui.text("放回", class=[@style.text_secondary]),
        ],
        false,
        fn() {
          set_member(s, "drop", name, false)
          ignore(app.commit())
          app.say("已把 \{name} 放回「\{s.title}」")
        },
      ),
    )
  }
  // 本地快照里命中、但没进本场景候选的包——这才是「本地搜索」多出来的能力：
  // 以前只能看前 60 条候选，注册表里有但场景规则没命中的包无从查起。
  let snapshot : Array[(Double, String)] = []
  if searching {
    let in_cand : Map[String, Bool] = Map([])
    for it in items {
      in_cand[it.name] = true
    }
    let dropped : Map[String, Bool] = Map([])
    for name in all_drops {
      dropped[name] = true
    }
    for name in app.studio.modules.keys() {
      if in_cand.contains(name) || dropped.contains(name) {
        continue
      }
      let m = app.studio.modules[name]
      if !m.yanked && module_hit(m, q) {
        push_by_dl(snapshot, m.downloads, name)
      }
    }
  }
  let local_cap = snapshot.length().min(60)
  let local_rows : Array[@widget.Node] = []
  for i = 0; i < local_cap; i = i + 1 {
    let (dl, name) = snapshot[i]
    local_rows.push(
      click_row(
        [
          @ui.text(name, wrap=false, ellipsis=true),
          @ui.view([], grow=1.0),
          @ui.text("下载 \{(dl).to_int()}", class=[@style.text_secondary], wrap=false),
          @ui.button("加入本场景", on_click=fn() {
            add_local(app, s, name)
          }, variant=@ui.Border),
        ],
        false,
        fn() {
          app.open_pkg(name)
        },
      ),
    )
  }
  let foot = if searching {
    "「\{q_raw}」：候选命中 \{shown.length()} 条（显示前 \{cap}）｜本地快照另有 \{snapshot.length()} 条不在候选里（显示前 \{local_cap}）"
  } else {
    "候选 \{items.length()} 条，显示前 \{cap}｜相关度权重 \{(app.weights).rel_w} · 下载权重 \{(app.weights).dl_w}｜点行首圆点可多选"
  }
  let cards : Array[@widget.Node] = [
    @ui.card(
      [
        pkg_search(
          app,
          "在 \{app.studio.modules.length()} 个本地包里搜（回车或点搜索）",
        ),
        if rows.is_empty() {
          @ui.text(
            if searching {
              "候选里没有匹配「\{q_raw}」的包——换个词，或看下面「本地快照命中」"
            } else {
              "这个场景还没有候选包"
            },
            class=[@style.text_secondary],
          )
        } else {
          @ui.col(rows, row_gap=2.0)
        },
        @ui.text(foot, class=[@style.text_secondary]),
      ],
      title="候选包（按当前权重）",
      padding=12.0,
      row_gap=8.0,
    ),
  ]
  if !local_rows.is_empty() {
    cards.push(
      @ui.card(
        [
          @ui.text(
            "这些包在本地快照里命中「\{q_raw}」，但没进本场景的候选（按关键词收录的规则没命中，或曾被移出）。点行看详情，或直接加入。",
            class=[@style.text_secondary],
          ),
          @ui.col(local_rows, row_gap=2.0),
        ],
        title="本地快照命中（\{snapshot.length()}）",
        padding=12.0,
        row_gap=8.0,
      ),
    )
  }
  if !drop_rows.is_empty() {
    cards.push(
      @ui.card(
        [
          @ui.col(drop_rows, row_gap=2.0),
          @ui.text("点一行即放回本场景；这些包不会出现在榜单里", class=[
            @style.text_secondary,
          ]),
        ],
        title="已移出（\{drops.length()}）",
        padding=12.0,
        row_gap=8.0,
      ),
    )
  }
  @ui.col(cards, row_gap=12.0)
}

///|
fn pkg_detail(app : App, s : Scenario, name : String) -> @widget.Node {
  let mod = app.studio.find_module(name)
  let desc = match mod {
    Some(m) => m.description
    None => ""
  }
  let stats = match mod {
    Some(m) =>
      "下载 \{(m.downloads).to_int()}｜版本 \{(m.version)}｜许可 \{(m.license)}｜\{m.name}"
    None => "注册表快照里没有这个包（可能已被下架，或快照过期，去「数据更新」重采一次）"
  }
  let b = app.studio.blurb(name)
  let zh0 = if b.length() > 0 { b[0] } else { "" }
  let en0 = if b.length() > 1 { b[1] } else { "" }
  let mut bv0 = ""
  for (k, v) in s.num_map("boost") {
    if k == name {
      bv0 = fmt1(v)
    }
  }
  let dropped = s.str_list("drop").contains(name)
  let cards : Array[@widget.Node] = []
  if dropped {
    cards.push(
      @ui.alert(
        "这个包已从「\{s.title}」移出",
        description="它不会出现在本场景的榜单与候选里。点下面「放回」恢复；若只是不想要它，直接返回列表即可。",
        t=@ui.Warning,
      ),
    )
  }
  cards.push(
    @ui.card(
      [
        @ui.text(name, class=[@style.text_title]),
        @ui.text(stats, class=[@style.text_secondary]),
        @ui.text(if desc == "" { "（注册表无描述）" } else { desc }, class=[
          @style.text_secondary,
        ]),
      ],
      title="注册表数据",
      padding=12.0,
      row_gap=6.0,
    ),
  )
  cards.push(
    section(
      [
        field(
          "简介（中文）——留空则站点回落到注册表描述",
          @ui.textarea(
            app.fstr("b_zh", zh0),
            rows=3,
            placeholder=desc,
            handle=stretch,
          ),
        ),
        field(
          "简介（英文）",
          @ui.textarea(
            app.fstr("b_en", en0),
            rows=3,
            placeholder=desc,
            handle=stretch,
          ),
        ),
      ],
      "简介",
    ),
  )
  cards.push(
    section(
      [
        field(
          "boost（加在相关度之外的固定分，空=不加）",
          @ui.input(app.fstr("boost", bv0), width=120.0, placeholder="例如 2.5"),
        ),
        @ui.row(
          [
            @ui.checkbox("pin（置顶）", app.fflag("pin", s.has_in("pin", name))),
            @ui.checkbox("force（强制收录）", app.fflag("force", s.has_in("force", name))),
            @ui.checkbox("完整方案（sol）", app.fflag("sol", s.has_in("sol", name))),
          ],
          column_gap=16.0,
        ),
        @ui.row(
          [
            @ui.text(
              "移出后不再出现在本场景的榜单与候选里，可随时在下面所属场景里放回",
              class=[@style.text_secondary],
            ),
            @ui.view([], grow=1.0),
            @ui.button("移出「\{s.title}」", on_click=fn() {
              sort_out(app, s, name)
            }, variant=@ui.Border),
          ],
          column_gap=8.0,
        ),
      ],
      "与「\{s.title}」的关联度",
    ),
  )
  cards.push(membership_section(app, s, name))
  if dropped {
    cards.push(
      @ui.row(
        [
          @ui.view([], grow=1.0),
          @ui.button("放回「\{s.title}」", on_click=fn() {
            set_member(s, "drop", name, false)
            ignore(app.commit())
            app.say("已把 \{name} 放回「\{s.title}」")
          }, variant=@ui.Solid),
        ],
      ),
    )
  }
  @ui.col(cards, row_gap=12.0)
}

///|
/// 所属场景：一个包同时出现在多个场景里是常态，这里把「显式收录」它的场景
/// 全列出来，可就地移出。往别的场景「加入」的动作在顶栏，不在这里——加是
/// 屏幕级的操作，改的是另一份场景数据，跟本屏的保存不是一回事。
fn membership_section(app : App, cur : Scenario, name : String) -> @widget.Node {
  let rows : Array[@widget.Node] = []
  let mut hits = 0
  for sc in app.studio.cat.scenarios {
    if in_scenario(sc, name) {
      hits = hits + 1
      let here = sc.id == cur.id
      rows.push(
        @ui.row(
          [
            @ui.text("\{sc.icon} \{sc.title}", wrap=false),
            @ui.text(if here { "（本场景）" } else { "" }, class=[
              @style.text_secondary,
            ]),
            @ui.view([], grow=1.0),
            if here {
              @ui.text("", wrap=false)
            } else {
              @ui.button("移出", on_click=fn() {
                remove_elsewhere(app, sc, name)
              }, variant=@ui.Border)
            },
          ],
          column_gap=8.0,
        ),
      )
    }
  }
  let body : Array[@widget.Node] = []
  if rows.is_empty() {
    body.push(
      @ui.text(
        "没有显式收录它的场景。按关键词命中的场景不在这里列——那种归属由收录规则决定。",
        class=[@style.text_secondary],
      ),
    )
  } else {
    body.push(@ui.text("显式收录 \{hits} 个场景：", class=[@style.text_secondary]))
    for r in rows {
      body.push(r)
    }
  }
  body.push(
    @ui.text("要加进别的场景，用顶栏的「加入场景」——只写目标场景，本场景不动。", class=[
      @style.text_secondary,
    ]),
  )
  section(body, "所属场景")
}

// ---------------------------------------------------------------- 动作

///|
/// 本地搜索结果里直接收进本场景。走与详情页同一个 `add_to_scenario`：
/// pick 非空的场景落 pick，否则落 force——不能自己另写一套名单语义。
fn add_local(app : App, s : Scenario, name : String) -> Unit {
  add_to_scenario(s, name)
  ignore(app.commit())
  app.say("已把 \{name} 加入「\{s.title}」")
  app.post(fn() {
    app.refresh_pane()
  })
}

///|
fn save_pkg(app : App, s : Scenario, name : String) -> Unit {
  let zh = app.fstr("b_zh", "").get()
  let en = app.fstr("b_en", "").get()
  app.studio.blurb_set(name, zh, en)
  let raw = app.fstr("boost", "").get()
  if raw.trim() == "" {
    s.num_remove("boost", name)
  } else {
    s.num_set("boost", name, num_of(raw, 1.0))
  }
  let pinned = app.fflag("pin", false).get()
  set_member(s, "pin", name, pinned)
  set_member(s, "force", name, app.fflag("force", false).get())
  set_member(s, "sol", name, app.fflag("sol", false).get())
  // 勾了置顶/强制/方案就等于要它，顺手把移出记录撤掉，免得两边打架
  if pinned || s.has_in("force", name) || s.has_in("sol", name) {
    set_member(s, "drop", name, false)
  }
  ignore(app.commit())
  app.say("已保存 \{name}（简介 / 关联度）")
}

///|
fn sort_out(app : App, s : Scenario, name : String) -> Unit {
  remove_from_scenario(s, name)
  ignore(app.commit())
  app.say("已把 \{name} 移出「\{s.title}」")
}

///|
/// 从别的场景移出（不出本屏，改完仍在详情里）。
fn remove_elsewhere(app : App, sc : Scenario, name : String) -> Unit {
  remove_from_scenario(sc, name)
  ignore(app.commit())
  app.say("已把 \{name} 从「\{sc.title}」移出")
}

///|
fn add_elsewhere(app : App, cur : Scenario, name : String) -> Unit {
  let label = app.fstr("pkg_add_to", "").get()
  let mut dst : Scenario? = None
  for x in app.studio.cat.scenarios {
    if "\{x.icon} \{x.title}" == label {
      dst = Some(x)
    }
  }
  match dst {
    Some(d) => {
      add_to_scenario(d, name)
      // 加完之后该场景就不再是候选，选择框退回「选场景」，免得留一个已失效的标签
      app.fstr("pkg_add_to", "").set("")
      ignore(app.commit())
      app.say("已把 \{name} 加入「\{d.title}」；在「\{cur.title}」里的位置不变")
    }
    None => app.say("先在顶栏选一个目标场景")
  }
}

///|
/// 列表里的批量动作。sol / pin / force 只加不减；drop 是「移出本场景」，
/// 走与单包相同的一套清理。
fn batch_pkg(app : App, s : Scenario, action : String) -> Unit {
  let n = app.pkg_picked.length()
  for name in app.pkg_picked {
    if action == "drop" {
      remove_from_scenario(s, name)
    } else if action == "sol" {
      set_member(s, "sol", name, true)
      set_member(s, "drop", name, false)
    } else if action == "pin" {
      set_member(s, "pin", name, true)
      set_member(s, "drop", name, false)
    } else if action == "force" {
      set_member(s, "force", name, true)
      set_member(s, "drop", name, false)
    }
  }
  app.clear_pkg_pick()
  ignore(app.commit())
  let verb = if action == "drop" {
    "移出"
  } else if action == "sol" {
    "标为方案"
  } else if action == "pin" {
    "置顶"
  } else {
    "强制收录"
  }
  app.say("已对 \{n} 个包执行「\{verb}」")
}

///|
/// 批量加入别的场景：只写目标，不动本场景——一个包同时属于多个场景是正常状态，
/// 以前那版把源场景的 pin/boost 一并清掉，等于强行「搬家」。
fn batch_join(app : App, from : Scenario) -> Unit {
  let label = app.fstr("join_to", "").get()
  let mut dst : Scenario? = None
  for x in app.studio.cat.scenarios {
    if x.id != from.id && "\{x.icon} \{x.title}" == label {
      dst = Some(x)
    }
  }
  match dst {
    Some(d) => {
      let n = app.pkg_picked.length()
      for name in app.pkg_picked {
        add_to_scenario(d, name)
      }
      app.clear_pkg_pick()
      ignore(app.commit())
      app.say("已把 \{n} 个包也加入「\{d.title}」；「\{from.title}」里保持不变")
    }
    None => app.say("先选目标场景")
  }
}
