# X 推文

单调英文即可。X 自带翻译（Translate post），双语会把 280 字挤掉一半，钩子反而变弱。

数字写「3,000+」，不写具体值：快照会过期，读者去站点核对容易发现对不上。

## 主推（191 字符）

```
3,000+ MoonBit packages on mooncakes, and no one tells you which to pick.

Indexed by 37 dev scenarios — full solutions vs building blocks, no download-count ranking:

https://moonbit-ecosystem-index.pages.dev
```

加在末尾：`@Moonbitlang`（共 204 字符）。

## 备选（263 字符，语气更具体，接近 280 上限）

```
mooncakes has 3,000+ MoonBit packages. Nothing tells you which ones to actually use for a desktop app.

So I indexed them by 37 dev scenarios, each split into "full solution" and "building blocks" — deliberately no download-count ranking.

https://moonbit-ecosystem-index.pages.dev
```

## 自回复（发布后接着回，用来放解释，不占正文）

第一条，讲为什么不做下载量排序（`orbit` 有 160 下载量，按下载量排序会落到桌面场景第 11 位、一堆底层绑定之后）：

```
Why no download ranking: sorted by downloads, the desktop category puts a working Tauri-style framework at #11, below a dozen low-level bindings. Downloads measure history, not fit.
```

第二条，讲元数据不可靠（`moonbit-community/yaml` 有 111,945 下载量，但 `keywords` 是空的，靠关键词根本搜不到）：

```
A 111k-download format package was missing from the index entirely — its keywords field is empty, so keyword matching never saw it.
```

带标签一起发：`#MoonBit #WebAssembly #OpenSource`

## 发布要点

- 配图用 `dist/og.png`（1200×630），链接卡片会自动展开。
- 标签：`#MoonBit #WebAssembly #OpenSource`，标签放在自回复里更省正文。
- 时间：北京时间工作日上午，欧美前一晚刚过完。
- 不要写成「I built a website」，正文里唯一的动词是 indexed。
