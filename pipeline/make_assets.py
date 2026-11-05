#!/usr/bin/env python3
"""
生成分享卡片与站点图标。**不参与日常构建**（当前构建在 app/ 里，不依赖它）：
产物已提交进仓库，只有改了配色、文案或域名时才需要重跑。

    python3 pipeline/make_assets.py

产出：
    dist/og.png                 1200×630 分享卡片（og:image / twitter:image）
    dist/assets/favicon.svg     站点图标（矢量，现代浏览器优先用这个）
    dist/favicon.ico            16/32/48 的 ico（旧客户端与「/favicon.ico」硬请求）
    dist/apple-touch-icon.png   180×180（iOS 添加到主屏）

依赖：Pillow（画图标）+ 本机 Chrome（渲染 op.html 卡片）。缺 Chrome 时只更新图标，
卡片保持原样并给出提示，不会留下半张图。
"""

import shutil
import subprocess
import sys
import sys
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
DIST = ROOT / "dist"
ACCENT = "#2f5fe0"
WHITE = "#ffffff"

# 与 dist/assets/favicon.svg 同一套几何：32 的画布上，四块 7.5 的圆角方块，
# 留 7 的边距。含义是「按格子组织的索引」，也算首页卡片的缩略。
SVG = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" role="img" aria-label="MoonBit 生态索引">
  <rect width="32" height="32" rx="7" fill="{a}"/>
  <rect x="7" y="7" width="7.5" height="7.5" rx="1.8" fill="#fff"/>
  <rect x="17.5" y="7" width="7.5" height="7.5" rx="1.8" fill="#fff"/>
  <rect x="7" y="17.5" width="7.5" height="7.5" rx="1.8" fill="#fff"/>
  <rect x="17.5" y="17.5" width="7.5" height="7.5" rx="1.8" fill="#fff"/>
</svg>
"""


def icon(size: int) -> Image.Image:
    """按 4 倍超采样画，再缩小，边缘才不会有锯齿。"""
    s = size * 4
    k = s / 32
    im = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    d.rounded_rectangle([0, 0, s - 1, s - 1], radius=7 * k, fill=ACCENT)
    for x, y in ((7, 7), (17.5, 7), (7, 17.5), (17.5, 17.5)):
        d.rounded_rectangle([x * k, y * k, (x + 7.5) * k, (y + 7.5) * k],
                            radius=1.8 * k, fill=WHITE)
    return im.resize((size, size), Image.LANCZOS)


def write_icons():
    (DIST / "assets").mkdir(parents=True, exist_ok=True)
    (DIST / "assets" / "favicon.svg").write_text(SVG.format(a=ACCENT), encoding="utf-8")
    icon(180).save(DIST / "apple-touch-icon.png")
    big = icon(256)
    big.save(DIST / "favicon.ico", sizes=[(16, 16), (32, 32), (48, 48)])
    print("icons  ok  favicon.svg / favicon.ico / apple-touch-icon.png")


def write_card():
    chrome = next((c for c in ("google-chrome", "chromium", "chromium-browser")
                   if shutil.which(c)), None)
    if not chrome:
        print("card   skip  未找到 Chrome，dist/og.png 保持原样")
        return False
    out = DIST / "og.png"
    tmp = out.with_suffix(".tmp.png")
    cmd = [chrome, "--headless=new", "--disable-gpu", "--hide-scrollbars",
           "--force-device-scale-factor=1", "--window-size=1200,630",
           "--virtual-time-budget=3000", f"--screenshot={tmp}",
           (ROOT / "pipeline" / "og.html").as_uri()]
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0 or not tmp.exists():
        print("card   FAIL", r.stderr.strip()[:200])
        return False
    with Image.open(tmp) as im:
        if im.size != (1200, 630):
            print(f"card   FAIL  尺寸 {im.size}，应为 (1200, 630)")
            tmp.unlink()
            return False
        im.convert("RGB").save(out, optimize=True)
    tmp.unlink()
    print(f"card   ok   dist/og.png  {out.stat().st_size // 1024} KB")
    return True


if __name__ == "__main__":
    write_icons()
    write_card()      # 缺 Chrome 不算失败：图标已更新，卡片沿用旧的
