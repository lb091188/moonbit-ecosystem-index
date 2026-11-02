'use strict';

const ROOT = 'data/scenarios.json';
const MK = n => 'https://mooncakes.io/docs/' + n;

const $ = s => document.querySelector(s);
const esc = s => String(s).replace(/[&<>"]/g,
  c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
const human = n => n >= 10000 ? (n / 10000).toFixed(1) + '\u4e07'
  : n >= 1000 ? (n / 1000).toFixed(1) + 'k' : String(n);

let D = null;          // 全部数据
const SC = {};         // 场景索引
const PREVIEW = 5;     // 首页每个场景固定展示的包数

/* ---------------------------------------------------------------- 渲染片段 */

function pkg(name, i) {
  const m = D.modules[name] || [0, '', '', 0];
  const ver = m[1] ? `<span class="v">v${esc(m[1])}</span>` : '';
  const yk = m[3] ? '<span class="yk">yanked</span>' : '';
  return `<li><span class="rk${i > 5 ? ' dim' : ''}">${i}</span>
    <div class="b">
      <div class="n"><a href="${MK(name)}" target="_blank" rel="noopener">${esc(name)}</a>${ver}${yk}</div>
      <div class="d">${esc(m[2] || '\u2014')}</div>
    </div>
    <span class="dl">${human(m[0])}</span></li>`;
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
    \u7ec4 ${m.scenarios} \u4e2a\u573a\u666f\u3002\u6bcf\u4e2a\u573a\u666f\u5206\u4e24\u5c42\uff1a<b>\u5b8c\u6574\u65b9\u6848</b>\uff08\u80fd\u76f4\u63a5\u9009\u578b\u3001\u5b9a\u9aa8\u67b6\uff09\u4e0e
    <b>\u57fa\u7840\u5e93</b>\uff08\u63d0\u4f9b\u5355\u70b9\u80fd\u529b\uff09\u3002\u9996\u9875\u6bcf\u4e2a\u573a\u666f\u53ea\u5c55\u793a\u524d ${PREVIEW} \u4e2a\uff0c
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
  const sec = (k, list, title) => {
    if (!list.length && k === 'lib') return '';
    const body = list.length
      ? `<ul class="pkglist all">${list.map((x, i) => pkg(x, i + 1)).join('')}</ul>`
      : `<ul class="pkglist all"><li class="empty">\u5c1a\u65e0\u5b8c\u6574\u65b9\u6848\uff0c\u8be5\u9700\u6c42\u76ee\u524d\u9700\u7531\u57fa\u7840\u5e93\u7ec4\u5408\u5b9e\u73b0</li></ul>`;
    return `<div class="sect"><h3>${title}<span class="k">${list.length} \u4e2a</span></h3>
      <div class="panel">${body}</div></div>`;
  };
  return `<p class="crumb"><a href="#/">\u9996\u9875</a> \u203a ${esc(sc.title)}</p>
    <div class="dhead"><h1>${sc.icon} ${esc(sc.title)}</h1>
      <p>${esc(sc.intro)}</p></div>
    ${sceneNote(sc)}
    ${sec('sol', sc.sol, '\u5b8c\u6574\u65b9\u6848')}
    ${sec('lib', sc.lib, '\u57fa\u7840\u5e93')}
    ${footer()}`;
}

function viewSearch(q) {
  return `<p class="crumb"><a href="#/">\u9996\u9875</a> \u203a \u68c0\u7d22</p>
    <input class="sbox" id="q" autocomplete="off" placeholder="\u68c0\u7d22\u5168\u90e8 ${D.meta.modules} \u4e2a\u5305\uff1a\u540d\u79f0\u6216\u63cf\u8ff0\uff0c\u4f8b\u5982 json\u3001http\u3001parser">
    <div id="sout"><p class="smeta">\u8f93\u5165\u5173\u952e\u8bcd\u5f00\u59cb\u68c0\u7d22\u3002\u6309\u4e0b\u8f7d\u91cf\u964d\u5e8f\u3002</p></div>`;
}

function doSearch(q) {
  const out = $('#sout');
  if (!out) return;
  const t = q.trim().toLowerCase();
  if (!t) {
    out.innerHTML = '<p class="smeta">\u8f93\u5165\u5173\u952e\u8bcd\u5f00\u59cb\u68c0\u7d22\u3002\u6309\u4e0b\u8f7d\u91cf\u964d\u5e8f\u3002</p>';
    return;
  }
  const hit = [];
  for (const [n, m] of Object.entries(D.modules)) {
    if (n.toLowerCase().includes(t) || (m[2] || '').toLowerCase().includes(t)) hit.push(n);
  }
  hit.sort((a, b) => D.modules[b][0] - D.modules[a][0]);
  const top = hit.slice(0, 200);
  out.innerHTML = `<p class="smeta">\u300c${esc(q.trim())}\u300d\uff1a\u547d\u4e2d ${hit.length} \u4e2a${
    hit.length > top.length ? '\uff0c\u4ec5\u5217\u524d ' + top.length + ' \u4e2a' : ''}</p>
    <div class="panel"><ul class="pkglist all">${
      top.length ? top.map((n, i) => pkg(n, i + 1)).join('')
        : '<li class="empty">\u6ca1\u6709\u5339\u914d\u7684\u5305</li>'}</ul></div>`;
}

function footer() {
  const m = D.meta;
  return `<footer>
    <p><b>\u6570\u636e\u6765\u6e90</b>\u3000mooncakes.io \u5b98\u65b9 API\uff08\u6a21\u5757\u5143\u6570\u636e\u4e0e\u4e0b\u8f7d\u91cf\uff09\u3002\u672c\u7ad9\u4ec5\u505a\u573a\u666f\u5bfc\u822a\uff0c
      \u4e0d\u590d\u5236\u6ce8\u518c\u8868\u80fd\u529b\uff1a\u7248\u672c\u5386\u53f2\u3001\u5b8c\u6574 API \u6587\u6863\u4e0e\u4f9d\u8d56\u5173\u7cfb\u8bf7\u5230 mooncakes \u5305\u9875\u67e5\u770b\uff0c
      \u9875\u9762\u5185\u6bcf\u4e2a\u5305\u540d\u5747\u6307\u5411\u8be5\u9875\u3002</p>
    <p><b>\u6570\u636e\u65f6\u6548</b>\u3000\u91c7\u96c6\u4e8e ${m.collected_at}\uff0c\u6784\u5efa\u4e8e ${m.built_at}\u3002\u672c\u7ad9\u4e3a\u79bb\u7ebf\u5feb\u7167\uff0c
      \u4e0d\u968f\u6ce8\u518c\u8868\u5b9e\u65f6\u66f4\u65b0\uff0c\u4e0d\u542b\u6b64\u540e\u7684\u65b0\u589e\u3001\u7248\u672c\u53d8\u66f4\u4e0e yanked \u6807\u8bb0\u3002</p>
    <p><b>\u5206\u5c42\u6807\u51c6</b>\u3000\u5b8c\u6574\u65b9\u6848\u6307\u80fd\u63a5\u7ba1\u7a0b\u5e8f\u7ed3\u6784\u3001\u53ef\u76f4\u63a5\u9009\u578b\u7684\u5305\uff08\u6846\u67b6\u3001\u5f15\u64ce\u3001\u8fd0\u884c\u65f6\u3001
      \u811a\u624b\u67b6\u3001ORM\uff09\uff1b\u57fa\u7840\u5e93\u6307\u63d0\u4f9b\u5355\u70b9\u80fd\u529b\u3001\u7531\u8c03\u7528\u65b9\u7ec4\u5408\u7684\u5305\u3002\u300c\u57fa\u7840\u5e93\u300d\u4e0d\u7b49\u540c\u4e8e
      \u300c\u4f9d\u8d56\u300d\uff1a\u5728 mooncakes \u751f\u6001\u4e2d\u5b8c\u6574\u65b9\u6848\u672c\u8eab\u4ea6\u4e3a\u4f9d\u8d56\uff0c\u5206\u5c42\u552f\u4e00\u6807\u51c6\u662f\u80fd\u5426\u63a5\u7ba1\u7a0b\u5e8f\u7ed3\u6784\u3002
      ${m.scenarios - m.with_solutions} \u4e2a\u573a\u666f\u5c1a\u65e0\u5b8c\u6574\u65b9\u6848\u3002</p>
    <p><b>\u6392\u5e8f\u65b9\u6cd5</b>\u3000\u573a\u666f\u5185\u6392\u5e8f = \u5173\u952e\u8bcd\u5339\u914d\u5ea6 + \u4e0b\u8f7d\u91cf\uff1b\u4e0d\u5f15\u5165\u53cd\u5411\u4f9d\u8d56\u6570\u7b49\u6d3e\u751f\u6307\u6807\u3002
      \u684c\u9762\u4e0e\u624b\u673a\u7b49\u73af\u5883\u7531\u4e8e\u7f3a\u4e4f\u7a33\u5b9a\u5173\u952e\u8bcd\uff0c\u6539\u4e3a\u4eba\u5de5\u56f4\u5b9a\u3002</p>
    <p><b>\u6784\u5efa</b>\u3000<code>python3 pipeline/analyze.py</code>\u3000\u00b7\u3000<b>\u67e5\u8be2</b>\u3000<code>python3 pipeline/query.py json</code></p>
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
