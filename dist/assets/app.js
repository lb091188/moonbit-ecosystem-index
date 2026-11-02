'use strict';

const ROOT = 'data/scenarios.json';
const MK = n => 'https://mooncakes.io/docs/' + n;

const $ = s => document.querySelector(s);
const esc = s => String(s).replace(/[&<>"]/g,
  c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
// 数据里没有下载量：名次只是列表位置，右侧不再有第二个数字可供比对。

let D = null;          // 全部数据
const SC = {};         // 场景索引
const PREVIEW = 5;     // 首页每个场景固定展示的包数

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
  if (!list.length) return '<li class="empty">\u6682\u65e0\u5019\u9009</li>';
  return list.slice(0, n).map((x, i) => pkg(x, i + 1)).join('');
}

function card(sc) {
  const ns = sc.sol.length, nl = sc.lib.length;
  const def = ns > 0 ? 'sol' : 'lib';
  const tab = (k, n, label) =>
    `<button class="${def === k ? 'on' : ''}" data-t="${k}">${label} ${n}</button>`;
  const pane = (k, list) =>
    `<ul class="pkglist" data-tab="${k}"${def === k ? '' : ' hidden'}>${
      k === 'sol' && !ns
        ? '<li class="empty">\u672c\u573a\u666f\u5c1a\u65e0\u5b8c\u6574\u65b9\u6848\uff0c'
          + '\u9700\u7531\u57fa\u7840\u5e93\u7ec4\u5408\u5b9e\u73b0</li>'
        : rows(list, PREVIEW)}</ul>`;
  // 没有完整方案的场景：不设两组标签，候选全部只是基础库
  if (!ns) {
    return `<section class="card" data-id="${sc.id}">
      <div class="hd"><span class="ico">${sc.icon}</span><h2>${esc(sc.title)}</h2>
        <span class="tag">基础库 ${nl}</span></div>
      <p class="intro">${esc(sc.intro)}</p>
      <ul class="pkglist">${rows(sc.lib, PREVIEW)}</ul>
      <a class="more" href="#/s/${sc.id}">查看全部 ${nl} 个 →</a>
    </section>`;
  }
  return `<section class="card" data-id="${sc.id}">
    <div class="hd"><span class="ico">${sc.icon}</span><h2>${esc(sc.title)}</h2>
      <div class="tabs">${tab('sol', ns, '\u5b8c\u6574\u65b9\u6848')}${tab('lib', nl, '\u57fa\u7840\u5e93')}</div></div>
    <p class="intro">${esc(sc.intro)}</p>
    ${pane('sol', sc.sol)}
    ${pane('lib', sc.lib)}
    <a class="more" href="#/s/${sc.id}">\u67e5\u770b\u5168\u90e8 ${ns + nl} \u4e2a \u2192</a>
  </section>`;
}

/* ---------------------------------------------------------------- 页面 */

function viewHome() {
  const m = D.meta;
  return `<p class="lede">\u6309\u4f7f\u7528\u573a\u666f\u7ec4\u7ec7\u7684 MoonBit \u5305\u7d22\u5f15\uff0c\u5171 ${D.groups.length}
    \u7ec4 ${m.scenarios} \u4e2a\u573a\u666f\u3002有完整方案的场景分两层：<b>\u5b8c\u6574\u65b9\u6848</b>\uff08\u80fd\u76f4\u63a5\u9009\u578b\u3001\u5b9a\u9aa8\u67b6\uff09\u4e0e
    <b>\u57fa\u7840\u5e93</b>\uff08提供单点能力）；${m.scenarios - m.with_solutions} 个场景尚无完整方案，全部归为基础库。\u9996\u9875\u6bcf\u4e2a\u573a\u666f\u53ea\u5c55\u793a\u524d ${PREVIEW} \u4e2a\uff0c
    \u5b8c\u6574\u6e05\u5355\u5728\u573a\u666f\u8be6\u60c5\u9875\u3002</p>
    <div class="grid">${D.scenarios.map(card).join('')}</div>${footer()}`;
}

function sceneNote(sc) {
  const base = sc.curated
    ? '\u672c\u573a\u666f\u4e3a\u4eba\u5de5\u56f4\u5b9a\uff1a\u8be5\u9886\u57df\u5728\u751f\u6001\u4e2d\u5c1a\u672a\u5f62\u6210\u53ef\u9760\u7684\u5173\u952e\u8bcd\u4fe1\u53f7\uff0c\u5019\u9009\u5305\u4e0e\u5176\u987a\u5e8f\u7531\u4eba\u5de5\u786e\u5b9a\u3002'
    : '';
  const t = (base + ' ' + (sc.note || '')).trim();
  return t ? `<p class="note">${esc(t)}</p>` : '';
}

function viewScene(id) {
  const sc = SC[id];
  if (!sc) return `<p class="loading">\u672a\u77e5\u573a\u666f\uff1a${esc(id)}</p>`;
  const hasSol = sc.sol.length > 0;
  const sec = (k, list, title) => {
    if (!list.length && k === 'lib') return '';
    const body = `<ul class="pkglist all">${list.map((x, i) => pkg(x, i + 1)).join('')}</ul>`;
    return `<div class="sect"><h3>${title}<span class="k">${list.length} \u4e2a</span></h3>
      <div class="panel">${body}</div></div>`;
  };
  return `<p class="crumb"><a href="#/">\u9996\u9875</a> \u203a ${esc(sc.title)}</p>
    <div class="dhead"><h1>${sc.icon} ${esc(sc.title)}</h1>
      <p>${esc(sc.intro)}</p></div>
    ${sceneNote(sc)}
    ${hasSol ? sec('sol', sc.sol, '\u5b8c\u6574\u65b9\u6848') : ''}
    ${hasSol ? '' : `<p class="soless">本场景在生态中尚无完整方案（无框架或引擎级实现），下列均为基础库，需要按需组合。</p>`}
    ${sec('lib', sc.lib, '\u57fa\u7840\u5e93')}
    ${footer()}`;
}

function viewSearch(q) {
  return `<p class="crumb"><a href="#/">\u9996\u9875</a> \u203a \u68c0\u7d22</p>
    <input class="sbox" id="q" autocomplete="off" placeholder="\u68c0\u7d22\u5168\u90e8 ${D.meta.modules} \u4e2a\u5305\uff1a\u540d\u79f0\u6216\u63cf\u8ff0\uff0c\u4f8b\u5982 json\u3001http\u3001parser">
    <div id="sout"><p class="smeta">\u8f93\u5165\u5173\u952e\u8bcd\u5f00\u59cb\u68c0\u7d22\u3002\u6309\u5339\u914d\u7a0b\u5ea6\u6392\u5e8f\uff0c\u540c\u4e00\u7a0b\u5ea6\u6309\u540d\u79f0\u6392\u5217\u3002</p></div>`;
}

function doSearch(q) {
  const out = $('#sout');
  if (!out) return;
  const t = q.trim().toLowerCase();
  if (!t) {
    out.innerHTML = '<p class="smeta">\u8f93\u5165\u5173\u952e\u8bcd\u5f00\u59cb\u68c0\u7d22\u3002\u6309\u5339\u914d\u7a0b\u5ea6\u6392\u5e8f\uff0c\u540c\u4e00\u7a0b\u5ea6\u6309\u540d\u79f0\u6392\u5217\u3002</p>';
    return;
  }
  // 检索不再按下载量排序：命中程度优先（包名全等 > 包名开头 > 包名包含 > 描述包含），
  // 同程度按名称排列，顺序可复现，不需要读者相信任何隐藏权重。
  const score = n => {
    const full = n.toLowerCase(), seg = full.split('/').pop(), d = (D.modules[n][1] || '').toLowerCase();
    if (full === t || seg === t) return 4;
    if (seg.startsWith(t)) return 3;
    if (full.includes(t)) return 2;
    if (d.includes(t)) return 1;
    return 0;
  };
  const hit = [];
  for (const n of Object.keys(D.modules)) {
    const s = score(n);
    if (s) hit.push([s, n]);
  }
  hit.sort((a, b) => b[0] - a[0] || a[1].localeCompare(b[1]));
  const top = hit.slice(0, 200).map(x => x[1]);
  out.innerHTML = `<p class="smeta">\u300c${esc(q.trim())}\u300d\uff1a\u547d\u4e2d ${hit.length} \u4e2a${
    hit.length > top.length ? '\uff0c\u4ec5\u5217\u524d ' + top.length + ' \u4e2a' : ''}</p>
    <div class="panel"><ul class="pkglist all">${
      top.length ? top.map((n, i) => pkg(n, i + 1)).join('')
        : '<li class="empty">\u6ca1\u6709\u5339\u914d\u7684\u5305</li>'}</ul></div>`;
}

function footer() {
  const m = D.meta;
  return `<footer>
    <p><b>数据来源</b>　mooncakes.io 官方 API（模块元数据）。本索引仅做场景导航，不做注册表镜像：
      版本历史、完整 API 文档与依赖关系请到 mooncakes 包页查看，页面内每个包名均指向该页。</p>
    <p><b>数据时效</b>　采集于 ${m.collected_at}，构建于 ${m.built_at}。本站为离线快照，
      不随注册表实时更新，不含此后的新增、版本变更与 yanked 标记。</p>
    <p><b>分层标准</b>　完整方案指能接管程序结构、可直接选型的包（框架、引擎、运行时、
      脚手架、ORM）；基础库指提供单点能力、由调用方组合的包。「基础库」不等同于
      「依赖」：在 mooncakes 生态中完整方案本身亦为依赖，分层唯一标准是能否接管程序结构。
      ${m.scenarios - m.with_solutions} 个场景尚无完整方案。</p>
    <p><b>排序方法</b>　不设名次宣称。清单顺序在构建时确定：关键词相关度为主，注册表的下载量级
      参与排序但不对外呈现——它是累计计数，快照必然滞后，且一旦与名次并排显示，就会被
      读成「下载多的更适合」。选型要看 API 形态与维护状态，这两项请到包页自行核对。
      桌面、手机、运维等缺乏稳定关键词的场景为人工圈定的顺序。</p>
    <p><b>构建</b>　<code>python3 pipeline/analyze.py</code>　·　<b>查询</b>　<code>python3 pipeline/query.py json</code></p>
  </footer>`;
}

/* ---------------------------------------------------------------- 路由 */

function renderSide(active) {
  let h = `<a class="side-home${active === 'home' ? ' on' : ''}" href="#/">\u5168\u90e8\u573a\u666f</a>`;
  for (const [gid, gtitle] of D.groups) {
    const list = D.scenarios.filter(s => s.group === gid);
    if (!list.length) continue;
    h += `<div class="gt">${esc(gtitle)}</div><div class="snav">`;
    for (const s of list) {
      const n = s.sol.length ? s.sol.length : s.lib.length;
      h += `<a href="#/s/${s.id}" class="${active === s.id ? 'on' : ''}">${s.icon} ${esc(s.title)}<span class="n">${n}</span></a>`;
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
  const t = btn.dataset.t;
  cardEl.querySelectorAll('.tabs button').forEach(b => b.classList.toggle('on', b === btn));
  cardEl.querySelectorAll('.pkglist').forEach(u => { u.hidden = u.dataset.tab !== t; });
});

window.addEventListener('hashchange', route);

/* 抽屉开关：菜单按钮唤出，遮罩 / 关闭按钮 / Esc / 选中场景后收起 */
$('#menuBtn').addEventListener('click', () => setDrawer(!drawerOpen()));
$('#scrim').addEventListener('click', () => setDrawer(false));
$('#drwClose').addEventListener('click', () => setDrawer(false));
$('#snav').addEventListener('click', e => { if (e.target.closest('a')) setDrawer(false); });
document.addEventListener('keydown', e => { if (e.key === 'Escape') setDrawer(false); });
window.addEventListener('resize', () => { if (window.innerWidth > 880) setDrawer(false); });

(async function boot() {
  try {
    const r = await fetch(ROOT);
    if (!r.ok) throw new Error('HTTP ' + r.status);
    D = await r.json();
    D.scenarios.forEach(s => { SC[s.id] = s; });
    $('#ts').textContent =
      `\u91c7\u96c6\uff1a${D.meta.collected_at}\uff1b\u6784\u5efa\uff1a${D.meta.built_at}`;
    route();
  } catch (err) {
    $('#view').innerHTML = `<p class="loading">\u6570\u636e\u52a0\u8f7d\u5931\u8d25\uff1a${esc(err.message)}\u3002`
      + `\u8bf7\u901a\u8fc7 HTTP \u6253\u5f00\u9875\u9762\uff08\u5982 <code>python3 -m http.server</code>\uff09\uff0c`
      + `\u76f4\u63a5\u53cc\u51fb file:// \u65e0\u6cd5\u8bfb\u53d6\u6570\u636e\u3002</p>`;
  }
})();
