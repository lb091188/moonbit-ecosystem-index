// 数据生成：把当前数据编译成站点、报告与 skill 快照。
//
// 一次生成产出四类文件：
//   data/scenarios.json + data/modules.json   结构化中间产物
//   scenarios.md + dist/scenarios.md          人读报告
//   dist/index.html + dist/assets/* + dist/data/scenarios.json  静态站点
//   skills/moonbit-stack-selection/references/  一个场景一份 md + 总表 scenarios.md
//
// skill 写在**仓库内**，不再往 `~/.workbuddy/skills/` 里另存一份：它是这个索引的
// 一种交付形态，跟 dist/ 一样该跟数据同一次提交进 git，推到 GitHub 就是发布。
// SKILL.md 手写、不被覆盖；references/ 下的 md 每次生成重写。

///|
pub const REPO : String = "https://github.com/lb091188/moonbit-ecosystem-index"

///|
pub const SITE : String = "https://moonbit-ecosystem-index.pages.dev"

///|
pub struct BuildResult {
  payload : Json
  log : Array[String]
  modules : Int
  scenarios : Int
  solutions : Int
}

///|
/// skill 的落点：仓库内的 `skills/moonbit-stack-selection`。跟着仓库走，不往用户
/// 家目录里塞副本——本地那份一旦和仓库分叉，就成了两份都对不上的快照。
pub fn default_skill_dir(root : String) -> String {
  join(root, "skills/moonbit-stack-selection")
}

///|
fn slim_modules_json(studio : Studio) -> Json {
  let m : Map[String, Json] = Map([])
  for name in studio.modules.keys() {
    let x = studio.modules[name]
    m[name] = json_obj([
      ("name", json_str(x.name)),
      ("version", json_str(x.version)),
      ("downloads", json_num(x.downloads)),
      ("license", json_str(x.license)),
      ("repository", json_str(x.repository)),
      ("keywords", json_strs(x.keywords)),
      ("description", json_str(x.description)),
      ("created_at", json_str(x.created_at)),
      ("is_new", json_bool(x.is_new)),
      ("yanked", json_bool(x.yanked)),
    ])
  }
  @json.to_json(m)
}

///|
pub fn now_ms() -> Int64 {
  @env.now().reinterpret_as_int64()
}

///|
pub fn collected_at(root : String) -> String {
  match @sys.sys_read_text_file(join(root, "data/raw/meta.json")) {
    Some(t) =>
      try {
        let d = jstr(jget(parse_json(t), "collected_at"))
        if d == "" {
          today()
        } else {
          d
        }
      } catch {
        _ => today()
      }
    None => today()
  }
}

///|
pub fn build_all(
  root : String,
  skill_dir : String,
  weights : Weights,
  log : Array[String],
) -> BuildResult raise StudioError {
  let t0 = now_ms()
  let studio = load_studio(root)
  studio.modules = load_modules(root)
  studio.collected_at = collected_at(root)
  log.push("模块表 \{studio.modules.length()} 条（yanked 计入，不参与推荐）")
  log.push(
    "场景 \{studio.cat.scenarios.length()} 个，分组 \{studio.cat.groups.length()} 个",
  )
  let ranked = rank_all(studio.cat, studio.modules, weights)
  let built = now_stamp()
  let payload = scenarios_payload(studio, ranked, built)
  let compact = payload.stringify()
  write_text(join(root, "data/scenarios.json"), compact)
  write_json(join(root, "data/modules.json"), slim_modules_json(studio), indent=0)
  log.push("data/scenarios.json  \{compact.length() / 1024} KB")
  let md = report_md(studio, ranked)
  write_text(join(root, "scenarios.md"), md)
  write_text(join(root, "dist/scenarios.md"), md)
  log.push("scenarios.md  \{md.length() / 1024} KB")
  write_site(studio, ranked, REPO, SITE)
  write_text(join(root, "dist/data/scenarios.json"), compact)
  log.push("dist/index.html + dist/assets/app.js + dist/data/scenarios.json")
  write_skill(payload, skill_dir)
  log.push("skill → \{skill_dir}")
  let sols = solution_names(ranked)
  let mut have = 0
  let miss : Array[String] = []
  for name in sols {
    let b = studio.blurb(name)
    if b.length() > 0 && b[0] != "" {
      have = have + 1
    } else {
      miss.push(name)
    }
  }
  log.push("简介 \{have}/\{sols.length()} 个完整方案有中文简介")
  if !miss.is_empty() {
    log.push("  缺简介：" + miss.join(", "))
  }
  log.push("每个场景候选数（完整方案 / 基础库）：")
  for r in ranked {
    let sol = r.split("solution")
    let lib = r.split("lib")
    let head = if sol.is_empty() { "—" } else { sol[0].name }
    log.push("  \{r.id}  \{sol.length()} / \{lib.length()}   首位：\{head}")
  }
  log.push("用时 \{((now_ms() - t0) / 1000).to_int()} 秒")
  {
    payload,
    log,
    modules: studio.modules.length(),
    scenarios: studio.cat.scenarios.length(),
    solutions: sols.length(),
  }
}
