'use strict';

const ROOT = 'data/scenarios.json';
const MK = n => 'https://mooncakes.io/docs/' + n;
// https://github.com/lb091188/moonbit-ecosystem-index 在构建时被替换成 analyze.py 顶部的 REPO，地址只有一处来源。
const REPO = 'https://github.com/lb091188/moonbit-ecosystem-index';
const ISSUE = REPO + '/issues/new';

const $ = s => document.querySelector(s);
const esc = s => String(s).replace(/[&<>"]/g,
  c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
// 数据里没有下载量：名次只是列表位置，右侧不再有第二个数字可供比对。

let D = null;          // 全部数据
const SC = {};         // 场景索引
const PREVIEW = 5;     // 首页每个场景固定展示的包数

/* ---------------------------------------------------------------- 双语
   语言优先级：URL 的 ?lang= > 上次手动选择（localStorage）> 浏览器首选语言。
   浏览器首选语言以 zh 开头即中文，其余一律英文。
   数据里的标题 / 简介 / 说明是 [中文, 英文] 两元数组，用 L() 取值；
   界面文案在下面的 T 表里，中英各一份，不存在第三种来源。 */

const LS_KEY = 'moonbit-index-lang';

let LANG = (() => {
  const p = new URLSearchParams(location.search).get('lang');
  if (p === 'zh' || p === 'en') return p;
  let saved = '';
  try { saved = localStorage.getItem(LS_KEY) || ''; } catch (e) { /* 隐私模式下不可用 */ }
  if (saved === 'zh' || saved === 'en') return saved;
  const list = navigator.languages && navigator.languages.length
    ? navigator.languages : [navigator.language || ''];
  for (const l of list) if (l) return l.toLowerCase().indexOf('zh') === 0 ? 'zh' : 'en';
  return 'en';
})();
let ZH = LANG === 'zh';
const L = x => Array.isArray(x) ? (x[ZH ? 0 : 1] || x[0]) : x;

function fill(s, o) {
  let r = s;
  for (const k in o) r = r.split('{' + k + '}').join(o[k]);
  return r;
}

const T = {
  zh: {
    docTitle: 'MoonBit 生态索引 · 场景化选型参考',
    docDesc: '按使用场景组织的 MoonBit 包索引：{n} 个场景，区分完整方案与基础库。',
    brand: 'MoonBit 生态索引',
    search: '检索',
    langBtn: 'EN',
    langAria: '切换到英文',
    navGroups: '场景分类',
    navClose: '关闭场景导航',
    navOpen: '打开场景导航',
    loading: '正在加载数据…',
    allScenes: '全部场景',
    ts: '采集：{c}；构建：{b}',
    sol: '完整方案',
    lib: '基础库',
    libOnly: '基础库 {n}',
    empty: '暂无候选',
    solNone: '本场景尚无完整方案，需由基础库组合实现',
    more: '查看全部 {n} 个 →',
    count: '{n} 个',
    home: '首页',
    unknown: '未知场景：{id}',
    noSol: '本场景在生态中尚无完整方案（无框架或引擎级实现），下列均为基础库，需要按需组合。',
    curated: '本场景为人工圈定：该领域在生态中尚未形成可靠的关键词信号，候选包与其顺序由人工确定。',
    ph: '检索全部 {n} 个包：名称或描述，例如 json、http、parser',
    sHint: '输入关键词开始检索。按匹配程度排序，同一程度按名称排列。',
    sHit: '「{q}」：命中 {n} 个',
    sMore: '，仅列前 {k} 个',
    sEmpty: '没有匹配的包',
    errTitle: '数据加载失败：{e}。',
    errHint: '请通过 HTTP 打开页面（如 <code>python3 -m http.server</code>），直接双击 file:// 无法读取数据。',
    lede: '按使用场景组织的 MoonBit 包索引，共 {g} 组 {s} 个场景。有完整方案的场景分两层：'
      + '<b>完整方案</b>（能直接选型、定骨架）与 <b>基础库</b>（提供单点能力）；'
      + '{x} 个场景尚无完整方案，全部归为基础库。首页每个场景只展示前 {p} 个，完整清单在场景详情页。',
    foot: [
      { h: '数据来源',
        p: 'mooncakes.io 官方 API（模块元数据）。本索引仅做场景导航，不做注册表镜像：'
          + '版本历史、完整 API 文档与依赖关系请到 mooncakes 包页查看，页面内每个包名均指向该页。' },
      { h: '数据时效',
        p: '采集于 {c}，构建于 {b}。本站为离线快照，不随注册表实时更新，'
          + '不含此后的新增、版本变更与 yanked 标记。' },
      { h: '分层标准',
        p: '完整方案指能接管程序结构、可直接选型的包（框架、引擎、运行时、脚手架、ORM）；'
          + '基础库指提供单点能力、由调用方组合的包。「基础库」不等同于「依赖」：'
          + '在 mooncakes 生态中完整方案本身亦为依赖，分层唯一标准是能否接管程序结构。'
          + '{x} 个场景尚无完整方案。' },
      { h: '排序方法',
        p: '不设名次宣称。清单顺序在构建时确定：关键词相关度为主，注册表的下载量级参与排序但不对外呈现'
          + '——它是累计计数，快照必然滞后，且一旦与名次并排显示，就会被读成「下载多的更适合」。'
          + '选型要看 API 形态与维护状态，这两项请到包页自行核对。'
          + '桌面、手机、运维等缺乏稳定关键词的场景为人工圈定的顺序。' },
    ],
    ghAria: '在 GitHub 上查看源码或反馈问题',
    issueLink: 'issue',
    foot2: { h: '反馈与勘误',
      p: '数据、分类或排序若有错漏，欢迎到 {repo} 提 {issue}；指出一个包名就能定位，'
        + '场景的判定词、显式收录（force）与排除清单都集中在 pipeline/analyze.py 一处，'
        + '站点由它从 data/raw/ 的快照重建。' },
    buildLabel: '构建',
    queryLabel: '查询',
  },
  en: {
    docTitle: 'MoonBit Ecosystem Index · Choosing packages by use case',
    docDesc: 'A MoonBit package index organized by use case: {n} scenarios, split into complete solutions and libraries.',
    brand: 'MoonBit Ecosystem Index',
    search: 'Search',
    langBtn: '中文',
    langAria: 'Switch to Chinese',
    navGroups: 'Scenario groups',
    navClose: 'Close scenario navigation',
    navOpen: 'Open scenario navigation',
    loading: 'Loading data…',
    allScenes: 'All scenarios',
    ts: 'collected {c} · built {b}',
    sol: 'Solutions',
    lib: 'Libraries',
    libOnly: 'Libraries {n}',
    empty: 'No candidates yet',
    solNone: 'No complete solution yet; assemble one from these libraries',
    more: 'View all {n} →',
    count: '{n} packages',
    home: 'Home',
    unknown: 'Unknown scenario: {id}',
    noSol: 'This scenario has no complete solution in the ecosystem (no framework or engine-level '
      + 'implementation). Everything below is a library, to be composed as needed.',
    curated: 'This list is hand-curated: the domain has no reliable keyword signal yet, so the '
      + 'candidates and their order were chosen by hand.',
    ph: 'Search all {n} packages by name or description, e.g. json, http, parser',
    sHint: 'Type a keyword to search. Results are ordered by match strength, then by name.',
    sHit: '“{q}”: {n} matches',
    sMore: ', showing the first {k}',
    sEmpty: 'No matching packages',
    errTitle: 'Failed to load data: {e}.',
    errHint: 'Serve the page over HTTP (e.g. <code>python3 -m http.server</code>); '
      + 'opening file:// directly cannot read the data.',
    lede: 'A MoonBit package index organized by use case: {s} scenarios in {g} groups. '
      + 'Scenarios that have complete solutions are split in two layers: <b>complete solutions</b> '
      + '(pick one and the project skeleton is set) and <b>libraries</b> (single capabilities). '
      + '{x} scenarios have no complete solution yet and list libraries only. '
      + 'Each card shows the first {p} packages; the full list is on the scenario page.',
    foot: [
      { h: 'Data source',
        p: 'The official mooncakes.io API (module metadata). This index only navigates by use case; '
          + 'it is not a registry mirror. Version history, full API docs, and dependency information '
          + 'live on the mooncakes package page — every package name here links to it.' },
      { h: 'Data freshness',
        p: 'Collected {c}, built {b}. This is an offline snapshot: it does not follow the registry '
          + 'in real time and does not include later additions, version changes, or yanked flags.' },
      { h: 'Layering',
        p: 'A complete solution is a package that takes over the structure of your program and can be '
          + 'chosen outright (framework, engine, runtime, scaffolding tool, ORM). A library provides a '
          + 'single capability that the caller composes. "Library" is not a synonym for "dependency": '
          + 'complete solutions are dependencies too, so the only criterion is whether a package takes '
          + 'over program structure. {x} scenarios still have no complete solution.' },
      { h: 'Ordering',
        p: 'No ranking is claimed. Order is fixed at build time: keyword relevance dominates, and the '
          + 'registry download magnitude participates in sorting but is never shown — it is a cumulative '
          + 'count that a snapshot necessarily lags behind, and shown next to a position it would be read '
          + 'as "most downloaded fits best". Judge by API shape and maintenance status, both checkable on '
          + 'the package page. Desktop, mobile, and ops lack a stable keyword signal, so their order is '
          + 'hand-set.' },
    ],
    ghAria: 'View the source or report a problem on GitHub',
    issueLink: 'an issue',
    foot2: { h: 'Feedback',
      p: 'If a package is missing, misfiled, or the order looks wrong, open {issue} on {repo}. '
        + 'A package name is enough to locate the rule: the scenario keyword lists, the '
        + 'force-included packages and the exclusion lists all live in one file, '
        + 'pipeline/analyze.py, which rebuilds the site from the snapshot in data/raw/.' },
    buildLabel: 'build',
    queryLabel: 'query',
  },
};

let t = T[LANG];

/* 静态骨架里的文案（品牌名、按钮、aria-label）按 data-i18n 键填充；
   放在 fetch 之前执行，避免中文闪一下再变英文。 */
function applyStatic() {
  const el = document.documentElement;
  el.lang = ZH ? 'zh-CN' : 'en';
  document.title = t.docTitle;
  const desc = document.querySelector('meta[name="description"]');
  if (desc) desc.setAttribute('content', fill(t.docDesc, { n: D ? D.meta.scenarios : '' }));
  document.querySelectorAll('[data-i18n]').forEach(n => {
    const v = t[n.dataset.i18n];
    if (typeof v === 'string') n.textContent = v;
  });
  document.querySelectorAll('[data-i18n-aria]').forEach(n => {
    const v = t[n.dataset.i18nAria];
    if (typeof v === 'string') { n.setAttribute('aria-label', v); n.title = v; }
  });
  const ts = document.getElementById('ts');
  if (ts && D) ts.textContent = fill(t.ts, { c: D.meta.collected_at, b: D.meta.built_at });
}

/* 手动切换：写进 URL（可分享、刷新不丢）并记住选择；下次从无参数链接进来时沿用。
   切换后不重载页面，只重建文案与当前视图。 */
function setLang(next) {
  LANG = next === 'zh' ? 'zh' : 'en';
  ZH = LANG === 'zh';
  t = T[LANG];
  try { localStorage.setItem(LS_KEY, LANG); } catch (e) { /* 隐私模式下忽略 */ }
  const u = new URL(location.href);
  u.searchParams.set('lang', LANG);
  history.replaceState(null, '', u);
  applyStatic();
  if (!D) return;
  const keep = ($('#q') || {}).value || '';   // 检索页：切语言不丢当前查询
  route();
  if (keep) { const b = $('#q'); if (b) { b.value = keep; doSearch(keep); } }
}

/* ---------------------------------------------------------------- 渲染片段 */

function pkg(name, i) {
  const m = D.modules[name] || ['', '', 0];   // [版本, 描述, yanked]
  const ver = m[0] ? `<span class="v">v${esc(m[0])}</span>` : '';
  const yk = m[2] ? '<span class="yk">yanked</span>' : '';
  return `<li><span class="rk${i > 5 ? ' dim' : ''}">${i}</span>
    <div class="b">
      <div class="n"><a href="${MK(name)}" target="_blank" rel="noopener">${esc(name)}</a>${ver}${yk}</div>
      <div class="d">${esc(m[1] || '\u2014')}</div>
    </div></li>`;
}

function rows(list, n) {
  if (!list.length) return `<li class="empty">${t.empty}</li>`;
  return list.slice(0, n).map((x, i) => pkg(x, i + 1)).join('');
}

function card(sc) {
  const ns = sc.sol.length, nl = sc.lib.length;
  const def = ns > 0 ? 'sol' : 'lib';
  const title = L(sc.title), intro = L(sc.intro);
  const tab = (k, n, label) =>
    `<button class="${def === k ? 'on' : ''}" data-t="${k}">${label} ${n}</button>`;
  const pane = (k, list) =>
    `<ul class="pkglist" data-tab="${k}"${def === k ? '' : ' hidden'}>${
      k === 'sol' && !ns
        ? `<li class="empty">${t.solNone}</li>`
        : rows(list, PREVIEW)}</ul>`;
  // 没有完整方案的场景：不设两组标签，候选全部只是基础库
  if (!ns) {
    return `<section class="card" data-id="${sc.id}">
      <div class="hd"><span class="ico">${sc.icon}</span><h2>${esc(title)}</h2>
        <span class="tag">${fill(t.libOnly, { n: nl })}</span></div>
      <p class="intro">${esc(intro)}</p>
      <ul class="pkglist">${rows(sc.lib, PREVIEW)}</ul>
      <a class="more" href="#/s/${sc.id}">${fill(t.more, { n: nl })}</a>
    </section>`;
  }
  return `<section class="card" data-id="${sc.id}">
    <div class="hd"><span class="ico">${sc.icon}</span><h2>${esc(title)}</h2>
      <div class="tabs">${tab('sol', ns, t.sol)}${tab('lib', nl, t.lib)}</div></div>
    <p class="intro">${esc(intro)}</p>
    ${pane('sol', sc.sol)}
    ${pane('lib', sc.lib)}
    <a class="more" href="#/s/${sc.id}">${fill(t.more, { n: ns + nl })}</a>
  </section>`;
}

/* ---------------------------------------------------------------- 页面 */

function viewHome() {
  const m = D.meta;
  return `<p class="lede">${fill(t.lede, {
    g: D.groups.length, s: m.scenarios, x: m.scenarios - m.with_solutions, p: PREVIEW })}
    </p>
    <div class="grid">${D.scenarios.map(card).join('')}</div>${footer()}`;
}

function sceneNote(sc) {
  const base = sc.curated ? t.curated : '';
  const extra = L(sc.note) || '';
  const txt = (base + ' ' + extra).trim();
  return txt ? `<p class="note">${esc(txt)}</p>` : '';
}

function viewScene(id) {
  const sc = SC[id];
  if (!sc) return `<p class="loading">${esc(fill(t.unknown, { id }))}</p>`;
  const hasSol = sc.sol.length > 0;
  const title = L(sc.title), intro = L(sc.intro);
  const sec = (k, list, head) => {
    if (!list.length && k === 'lib') return '';
    const body = `<ul class="pkglist all">${list.map((x, i) => pkg(x, i + 1)).join('')}</ul>`;
    return `<div class="sect"><h3>${head}<span class="k">${
      fill(t.count, { n: list.length })}</span></h3>
      <div class="panel">${body}</div></div>`;
  };
  return `<p class="crumb"><a href="#/">${t.home}</a> › ${esc(title)}</p>
    <div class="dhead"><h1>${sc.icon} ${esc(title)}</h1>
      <p>${esc(intro)}</p></div>
    ${sceneNote(sc)}
    ${hasSol ? sec('sol', sc.sol, t.sol) : ''}
    ${hasSol ? '' : `<p class="soless">${esc(t.noSol)}</p>`}
    ${sec('lib', sc.lib, t.lib)}
    ${footer()}`;
}

function viewSearch(q) {
  return `<p class="crumb"><a href="#/">${t.home}</a> › ${t.search}</p>
    <input class="sbox" id="q" autocomplete="off"
      placeholder="${esc(fill(t.ph, { n: D.meta.modules }))}">
    <div id="sout"><p class="smeta">${t.sHint}</p></div>${footer()}`;
}

function doSearch(q) {
  const out = $('#sout');
  if (!out) return;
  const t0 = q.trim().toLowerCase();
  if (!t0) {
    out.innerHTML = `<p class="smeta">${t.sHint}</p>`;
    return;
  }
  // 检索不再按下载量排序：命中程度优先（包名全等 > 包名开头 > 包名包含 > 描述包含），
  // 同程度按名称排列，顺序可复现，不需要读者相信任何隐藏权重。
  const score = n => {
    const full = n.toLowerCase(), seg = full.split('/').pop(), d = (D.modules[n][1] || '').toLowerCase();
    if (full === t0 || seg === t0) return 4;
    if (seg.startsWith(t0)) return 3;
    if (full.includes(t0)) return 2;
    if (d.includes(t0)) return 1;
    return 0;
  };
  const hit = [];
  for (const n of Object.keys(D.modules)) {
    const s = score(n);
    if (s) hit.push([s, n]);
  }
  hit.sort((a, b) => b[0] - a[0] || a[1].localeCompare(b[1]));
  const top = hit.slice(0, 200).map(x => x[1]);
  const head = fill(t.sHit, { q: q.trim(), n: hit.length })
    + (hit.length > top.length ? fill(t.sMore, { k: top.length }) : '');
  out.innerHTML = `<p class="smeta">${esc(head)}</p>
    <div class="panel"><ul class="pkglist all">${
      top.length ? top.map((n, i) => pkg(n, i + 1)).join('')
        : `<li class="empty">${t.sEmpty}</li>`}</ul></div>`;
}

function footer() {
  const m = D.meta;
  const sep = ZH ? '　' : ': ';
  // 站点自己生成的链接：外部打开，文字直接显示地址，读者不用悬停才知道去哪
  const link = (href, text) =>
    `<a href="${href}" target="_blank" rel="noopener noreferrer">${esc(text)}</a>`;
  const vars = {
    c: m.collected_at, b: m.built_at, x: m.scenarios - m.with_solutions,
    repo: link(REPO, REPO.replace(/^https:\/\//, '')),
    issue: link(ISSUE, t.issueLink),
  };
  const ps = t.foot.map(f => `<p><b>${f.h}</b>${sep}${fill(f.p, vars)}</p>`).join('');
  const fb = `<p><b>${t.foot2.h}</b>${sep}${fill(t.foot2.p, vars)}</p>`;
  return `<footer>${ps}${fb}
    <p><b>${t.buildLabel}</b>${sep}<code>python3 pipeline/analyze.py</code> · <b>${t.queryLabel}</b>${sep}<code>python3 pipeline/query.py json</code></p>
  </footer>`;
}

/* ---------------------------------------------------------------- 路由 */

function renderSide(active) {
  let h = `<a class="side-home${active === 'home' ? ' on' : ''}" href="#/">${t.allScenes}</a>`;
  for (const [gid, gname] of D.groups) {
    const list = D.scenarios.filter(s => s.group === gid);
    if (!list.length) continue;
    h += `<div class="gt">${esc(L(gname))}</div><div class="snav">`;
    for (const s of list) {
      const n = s.sol.length ? s.sol.length : s.lib.length;
      h += `<a href="#/s/${s.id}" class="${active === s.id ? 'on' : ''}">${s.icon} ${esc(L(s.title))}<span class="n">${n}</span></a>`;
    }
    h += '</div>';
  }
  $('#snav').innerHTML = h;
}

/* ---------------------------------------------------------------- 抽屉（窄屏导航） */

function setDrawer(on) {
  document.body.classList.toggle('drawer-open', on);
  const b = $('#menuBtn');
  if (b) b.setAttribute('aria-expanded', on ? 'true' : 'false');
}

const drawerOpen = () => document.body.classList.contains('drawer-open');

function route() {
  setDrawer(false);          // 切页即收起抽屉，避免遮挡新页面
  const h = location.hash || '#/';
  const view = $('#view');
  if (h.startsWith('#/s/')) {
    const id = h.slice(4);
    renderSide(id);
    view.innerHTML = viewScene(id);
    window.scrollTo(0, 0);
    document.querySelector('.main').scrollTop = 0;
  } else if (h.startsWith('#/search')) {
    renderSide('search');
    view.innerHTML = viewSearch();
    const q = decodeURIComponent((h.split('?q=')[1] || ''));
    const box = $('#q');
    box.value = q;
    if (q) doSearch(q);
    box.addEventListener('input', () => doSearch(box.value));
    box.focus();
  } else {
    renderSide('home');
    view.innerHTML = viewHome();
    document.querySelector('.main').scrollTop = 0;
  }
}

/* tab 切换：完整方案 / 基础库 */
document.addEventListener('click', e => {
  const btn = e.target.closest('.tabs button');
  if (!btn) return;
  const cardEl = btn.closest('.card');
  const tabKey = btn.dataset.t;
  cardEl.querySelectorAll('.tabs button').forEach(b => b.classList.toggle('on', b === btn));
  cardEl.querySelectorAll('.pkglist').forEach(u => { u.hidden = u.dataset.tab !== tabKey; });
});

window.addEventListener('hashchange', route);

/* 语言切换：按钮上写的是「点它会切到的语言」 */
$('#langBtn').addEventListener('click', () => setLang(ZH ? 'en' : 'zh'));

/* 抽屉开关：菜单按钮唤出，遮罩 / 关闭按钮 / Esc / 选中场景后收起 */
$('#menuBtn').addEventListener('click', () => setDrawer(!drawerOpen()));
$('#scrim').addEventListener('click', () => setDrawer(false));
$('#drwClose').addEventListener('click', () => setDrawer(false));
$('#snav').addEventListener('click', e => { if (e.target.closest('a')) setDrawer(false); });
document.addEventListener('keydown', e => { if (e.key === 'Escape') setDrawer(false); });
window.addEventListener('resize', () => { if (window.innerWidth > 880) setDrawer(false); });

(async function boot() {
  applyStatic();                      // 骨架文案先切到目标语言，避免中文闪一下
  try {
    const r = await fetch(ROOT);
    if (!r.ok) throw new Error('HTTP ' + r.status);
    D = await r.json();
    D.scenarios.forEach(s => { SC[s.id] = s; });
    applyStatic();                    // 文案与时间已就绪，补一次 meta description
    route();
  } catch (err) {
    $('#view').innerHTML = `<p class="loading">${
      esc(fill(t.errTitle, { e: err.message }))} ${t.errHint}</p>`;
  }
})();
