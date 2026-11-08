# -*- coding: utf-8 -*-
"""VidHoist's mark kit: one source for every icon the two apps ship.

The mark: a window whose title bar carries the accent and whose glyph is a
download arrow landing in a tray, with film perforations down both sides.
On Windows it sits on an espresso tile; on Android the
tile is the accent and the plate is cream with the glyph cut out of it.

Writes:
  apps/vidhoist_mobile/assets/icons/icon.png, icon_foreground.png,
      icon_monochrome.png            then: dart run flutter_launcher_icons
  apps/vidhoist_desktop/windows/runner/resources/app_icon.ico
  apps/vidhoist_desktop/assets/tray/tray_light.ico, tray_dark.ico
  apps/vidhoist_desktop/windows/installer/wizard_large_*.bmp, wizard_small_*.png
  apps/vidhoist_desktop/brand/*.svg, vidhoist-symbol-1024.png

Rendering goes through a headless Chromium (Edge, which every Windows 11
carries) so the kit needs no SVG library: python tool/icons/vidhoist_kit.py
"""
import os
import shutil
import subprocess
import tempfile

import numpy as np
from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
MOBILE = os.path.join(ROOT, "apps", "vidhoist_mobile")
DESKTOP = os.path.join(ROOT, "apps", "vidhoist_desktop")
BRAND = os.path.join(DESKTOP, "brand")

INK = "#2B211B"
CREAM = "#FBF6EE"
ACCENT = "#2457D6"  # VhPalette.superDay.accent; the one place it is repeated
GRID = 256
SMALL_BELOW = 24

EDGE = next((p for p in [
    r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    r"C:\Program Files\Microsoft\Edge\Application\msedge.exe",
    r"C:\Program Files\Google\Chrome\Application\chrome.exe",
] if os.path.exists(p)), None)

# ---------------------------------------------------------------- geometry
PERF = ("M25.50 51.00H31.50A7.5 7.5 0 0 1 39.00 58.50V76.50A7.5 7.5 0 0 1 31.50 84.00H25.50A7.5 7.5 0 0 1 18.00 76.50V58.50A7.5 7.5 0 0 1 25.50 51.00Z"
        "M25.50 111.50H31.50A7.5 7.5 0 0 1 39.00 119.00V137.00A7.5 7.5 0 0 1 31.50 144.50H25.50A7.5 7.5 0 0 1 18.00 137.00V119.00A7.5 7.5 0 0 1 25.50 111.50Z"
        "M25.50 172.00H31.50A7.5 7.5 0 0 1 39.00 179.50V197.50A7.5 7.5 0 0 1 31.50 205.00H25.50A7.5 7.5 0 0 1 18.00 197.50V179.50A7.5 7.5 0 0 1 25.50 172.00Z"
        "M224.50 51.00H230.50A7.5 7.5 0 0 1 238.00 58.50V76.50A7.5 7.5 0 0 1 230.50 84.00H224.50A7.5 7.5 0 0 1 217.00 76.50V58.50A7.5 7.5 0 0 1 224.50 51.00Z"
        "M224.50 111.50H230.50A7.5 7.5 0 0 1 238.00 119.00V137.00A7.5 7.5 0 0 1 230.50 144.50H224.50A7.5 7.5 0 0 1 217.00 137.00V119.00A7.5 7.5 0 0 1 224.50 111.50Z"
        "M224.50 172.00H230.50A7.5 7.5 0 0 1 238.00 179.50V197.50A7.5 7.5 0 0 1 230.50 205.00H224.50A7.5 7.5 0 0 1 217.00 197.50V179.50A7.5 7.5 0 0 1 224.50 172.00Z")
WINDOW_BODY = "M52 82H204V189A23 23 0 0 1 181 212H75A23 23 0 0 1 52 189ZM75 96H181A9 9 0 0 1 190 105V189A9 9 0 0 1 181 198H75A9 9 0 0 1 66 189V105A9 9 0 0 1 75 96Z"
TITLE_BAR = "M52 74V67A23 23 0 0 1 75 44H181A23 23 0 0 1 204 67V74Z"
PLATE = "M75 44H181A23 23 0 0 1 204 67V189A23 23 0 0 1 181 212H75A23 23 0 0 1 52 189V67A23 23 0 0 1 75 44Z"
SMALL_T = 'transform="translate(128 128) scale(1.18) translate(-128 -128)"'


def glyph(color, cx=128, cy=150, s=1.0):
    """The arrow landing in its tray, drawn in [color]."""
    return (
        f'<path d="M{cx} {cy - 44 * s:.1f}V{cy - 2 * s:.1f}" stroke="{color}" stroke-width="{15 * s:.1f}" stroke-linecap="round" fill="none"/>'
        f'<path d="M{cx - 26 * s:.1f} {cy - 8 * s:.1f}H{cx + 26 * s:.1f}L{cx} {cy + 20 * s:.1f}Z" fill="{color}" stroke="{color}" stroke-width="{9 * s:.1f}" stroke-linejoin="round"/>'
        f'<path d="M{cx - 40 * s:.1f} {cy + 24 * s:.1f}V{cy + 30 * s:.1f}A{10 * s:.1f} {10 * s:.1f} 0 0 0 {cx - 30 * s:.1f} {cy + 40 * s:.1f}H{cx + 30 * s:.1f}A{10 * s:.1f} {10 * s:.1f} 0 0 0 {cx + 40 * s:.1f} {cy + 30 * s:.1f}V{cy + 24 * s:.1f}" fill="none" stroke="{color}" stroke-width="{11 * s:.1f}" stroke-linecap="round"/>'
    )


def svg(body, w=GRID, h=GRID, title="VidHoist"):
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" width="{w}" height="{h}">'
            f'<title>{title}</title>{body}</svg>')


EDGE_RIM = '<rect x="2" y="2" width="252" height="252" rx="56" fill="none" stroke="#FBF6EE" stroke-opacity="0.32" stroke-width="4"/>'


def tile_art(edge=False, small=False):
    """Espresso tile, cream window, accent title bar, cream glyph in the hole."""
    rim = EDGE_RIM if edge else ""
    if small:
        return (f'<rect width="256" height="256" rx="58" fill="{INK}"/>{rim}<g {SMALL_T}>'
                f'<path fill="{CREAM}" fill-rule="evenodd" d="{WINDOW_BODY}"/><path fill="{ACCENT}" d="{TITLE_BAR}"/>{glyph(CREAM)}</g>')
    return (f'<rect width="256" height="256" rx="58" fill="{INK}"/>{rim}'
            f'<path fill="{CREAM}" fill-rule="evenodd" d="{PERF}{WINDOW_BODY}"/><path fill="{ACCENT}" d="{TITLE_BAR}"/>{glyph(CREAM)}')


def tile_svg(edge=False, small=False):
    return svg(tile_art(edge, small))


def mono_art(colour, small=False):
    """One colour: the mark without its tile, for tray icons and print."""
    if small:
        return f'<g {SMALL_T}><path fill="{colour}" fill-rule="evenodd" d="{WINDOW_BODY}{TITLE_BAR}"/>{glyph(colour)}</g>'
    return f'<path fill="{colour}" fill-rule="evenodd" d="{PERF}{WINDOW_BODY}{TITLE_BAR}"/>{glyph(colour)}'


def mono_svg(colour, small=False):
    return svg(mono_art(colour, small))


def plate_art(plate=CREAM, hole=None):
    """The Android plate: perforations and a solid plate; [hole] draws the
    glyph in a colour (the tile shows through it in the launcher icon)."""
    g = glyph(hole, cy=136, s=1.12) if hole else ""
    return f'<path fill="{plate}" fill-rule="evenodd" d="{PERF}{PLATE}"/>{g}'


def mobile_svg():
    return svg(f'<rect width="256" height="256" rx="58" fill="{ACCENT}"/>{plate_art(hole=ACCENT)}')


# ---------------------------------------------------------------- rendering
def render(svg_text, size, bg="00000000"):
    """[svg_text] as an RGBA image [size] pixels square, through headless Chromium."""
    if EDGE is None:
        raise SystemExit("No Edge or Chrome found to render SVG.")
    with tempfile.TemporaryDirectory() as tmp:
        page = os.path.join(tmp, "a.html")
        out = os.path.join(tmp, "a.png")
        html = (f'<!doctype html><html><head><meta charset="utf-8"><style>html,body{{margin:0;padding:0;background:transparent;overflow:hidden}}'
                f'svg{{display:block;width:{size}px;height:{size}px}}</style></head><body>{svg_text}</body></html>')
        open(page, "w", encoding="utf-8").write(html)
        subprocess.run([EDGE, "--headless=new", "--disable-gpu", "--hide-scrollbars", "--force-device-scale-factor=1",
                        f"--default-background-color={bg}", f"--window-size={size},{size}",
                        f"--screenshot={out}", "file:///" + page.replace("\\", "/")],
                       check=True, capture_output=True, timeout=120)
        return Image.open(out).convert("RGBA").copy()


def fit(image, size):
    return image.resize((size, size), Image.LANCZOS) if image.width != size else image


def _ico(images, path):
    largest, *rest = sorted(images, key=lambda i: -i.width)
    largest.save(path, format="ICO", sizes=[(i.width, i.height) for i in images], append_images=rest)


# ---------------------------------------------------------------- outputs
def android_icons():
    out = os.path.join(MOBILE, "assets", "icons")
    os.makedirs(out, exist_ok=True)
    render(mobile_svg(), 1024).save(os.path.join(out, "icon.png"))
    # The adaptive foreground: the whole 256 grid at 92.7% of the file, so the
    # plate sits inside the launcher's safe zone after the system mask.
    inner = 950
    plate = render(svg(plate_art()), inner)
    hole = render(svg(f'<g>{glyph("#FFFFFF", cy=136, s=1.12)}</g>'), inner)
    a = np.array(plate).astype(np.float32)
    a[..., 3] *= 1 - np.array(hole)[..., 3].astype(np.float32) / 255
    plate = Image.fromarray(a.astype(np.uint8))
    fg = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
    fg.paste(plate, ((1024 - inner) // 2, (1024 - inner) // 2), plate)
    fg.save(os.path.join(out, "icon_foreground.png"))
    # Android 13+ themed icon: a white silhouette the system tints.
    mono = np.array(fg)
    mono[..., :3] = 255
    Image.fromarray(mono).save(os.path.join(out, "icon_monochrome.png"))


ICON_SIZES = [16, 20, 24, 32, 40, 48, 64, 256]
TRAY_SIZES = [16, 20, 24, 32, 40, 48]


def windows_icons():
    big = render(tile_svg(edge=True), 1024)
    small = render(tile_svg(edge=True, small=True), 512)
    _ico([fit(small if s < SMALL_BELOW else big, s) for s in ICON_SIZES],
         os.path.join(DESKTOP, "windows", "runner", "resources", "app_icon.ico"))
    for theme, colour in [("light", INK), ("dark", CREAM)]:
        big = render(mono_svg(colour), 512)
        small = render(mono_svg(colour, small=True), 512)
        _ico([fit(small if s < SMALL_BELOW else big, s) for s in TRAY_SIZES],
             os.path.join(DESKTOP, "assets", "tray", f"tray_{theme}.ico"))


def _font(size):
    for f in [os.path.join(ROOT, "packages", "vh_ui", "assets", "fonts", "Tajawal-Bold.ttf"),
              r"C:\Windows\Fonts\segoeuib.ttf"]:
        if os.path.exists(f):
            return ImageFont.truetype(f, size)
    return ImageFont.load_default()


def installer_images():
    inst = os.path.join(DESKTOP, "windows", "installer")
    # The tall wizard image: the mark without its tile on espresso, the name under it.
    for scale, (w, h) in {100: (164, 314), 125: (205, 393), 150: (246, 471), 200: (328, 628)}.items():
        img = Image.new("RGB", (w, h), INK)
        mark = render(svg(f'<path fill="{CREAM}" fill-rule="evenodd" d="{PERF}{WINDOW_BODY}"/><path fill="{ACCENT}" d="{TITLE_BAR}"/>{glyph(CREAM)}'), 1024)
        ms = int(w * 0.56)
        mark = mark.resize((ms, ms), Image.LANCZOS)
        img.paste(mark, ((w - ms) // 2, int(h * 0.30)), mark)
        d = ImageDraw.Draw(img)
        font = _font(int(w * 0.135))
        text = "VidHoist"
        tw = d.textlength(text, font=font)
        d.text(((w - tw) / 2, int(h * 0.30) + ms + int(h * 0.03)), text, font=font, fill=CREAM)
        img.save(os.path.join(inst, f"wizard_large_{scale}.bmp"))
    big = render(tile_svg(edge=True), 1024)
    for s in [58, 77, 97, 124]:
        fit(big, s).save(os.path.join(inst, f"wizard_small_{s}.png"))


def brand_files():
    os.makedirs(BRAND, exist_ok=True)
    for old in os.listdir(BRAND):
        # Brand files from before the rename are swept away.
        if old.startswith("ember-"):
            os.remove(os.path.join(BRAND, old))
    files = {
        "vidhoist-symbol.svg": tile_svg(),
        "vidhoist-symbol-dark.svg": tile_svg(edge=True),
        "vidhoist-symbol-small.svg": tile_svg(edge=True, small=True),
        "vidhoist-mark-ink.svg": mono_svg(INK),
        "vidhoist-mark-cream.svg": mono_svg(CREAM),
    }
    for kind in ("horizontal", "stacked"):
        for suffix, edge, word in (("", False, INK), ("-dark", True, CREAM)):
            files[f"vidhoist-{kind}{suffix}.svg"] = _lockup(kind, edge, word)
    for name, text in files.items():
        open(os.path.join(BRAND, name), "w", encoding="utf-8").write(text)
    render(tile_svg(), 1024).save(os.path.join(BRAND, "vidhoist-symbol-1024.png"))
    open(os.path.join(BRAND, "guide.html"), "w", encoding="utf-8").write(_guide())


def _lockup(kind, edge, word_colour):
    font = "font-family=\"Manrope, 'Segoe UI', system-ui, sans-serif\" font-weight=\"800\""
    if kind == "horizontal":
        w, h = 256 + 64 + 640, 256
        text = f'<text x="320" y="172" font-size="150" {font} fill="{word_colour}">VidHoist</text>'
        body = f'<g>{tile_art(edge)}</g>{text}'
    else:
        w, h = 640, 256 + 52 + 130
        text = f'<text x="320" y="{256 + 52 + 110}" text-anchor="middle" font-size="120" {font} fill="{word_colour}">VidHoist</text>'
        body = f'<g transform="translate(192 0)">{tile_art(edge)}</g>{text}'
    return svg(body, w, h)


def _guide():
    return f'''<!doctype html><html lang="en"><head><meta charset="utf-8"><title>VidHoist mark</title>
<style>body{{font:15px/1.6 system-ui,sans-serif;max-width:900px;margin:40px auto;padding:0 16px;color:{INK}}}
figure{{display:inline-block;margin:8px;padding:20px;border:1px solid #e6ddd0;border-radius:12px;text-align:center}}
figcaption{{font-size:12px;color:#8a7d73;margin-top:8px}}.dark{{background:#000}}</style></head><body>
<h1>VidHoist: the mark</h1>
<p>A window whose title bar carries the accent blue <code>{ACCENT}</code>; inside it a download arrow lands in a tray. Film perforations run down both sides. On Windows the window sits on an espresso tile <code>{INK}</code> with a cream plate <code>{CREAM}</code>; on Android the tile is the accent and the plate is cream with the glyph cut out of it. Below 24 px the small cut drops the perforations.</p>
<p dir="rtl">نافذة شريطها العلوي أزرق، وفي داخلها سهم تنزيل يستقر في صينية، وثقوب الفيلم على الجانبين. على ويندوز بلاطة حبرية، وعلى أندرويد بلاطة زرقاء ولوحة كريمية.</p>
<figure><img src="vidhoist-symbol.svg" width="128"><figcaption>vidhoist-symbol.svg</figcaption></figure>
<figure class="dark"><img src="vidhoist-symbol-dark.svg" width="128"><figcaption style="color:#aaa">vidhoist-symbol-dark.svg</figcaption></figure>
<figure><img src="vidhoist-symbol-small.svg" width="48"><figcaption>vidhoist-symbol-small.svg (below 24 px)</figcaption></figure>
<figure><img src="vidhoist-mark-ink.svg" width="128"><figcaption>vidhoist-mark-ink.svg</figcaption></figure>
<figure class="dark"><img src="vidhoist-mark-cream.svg" width="128"><figcaption style="color:#aaa">vidhoist-mark-cream.svg</figcaption></figure>
<figure><img src="vidhoist-horizontal.svg" height="64"><figcaption>vidhoist-horizontal.svg</figcaption></figure>
<figure class="dark"><img src="vidhoist-horizontal-dark.svg" height="64"><figcaption style="color:#aaa">vidhoist-horizontal-dark.svg</figcaption></figure>
<figure><img src="vidhoist-stacked.svg" height="120"><figcaption>vidhoist-stacked.svg</figcaption></figure>
<h2>Do not</h2><ul><li>recolour the title bar, or let it follow the theme;</li><li>put the tile on a dark ground without its light edge;</li><li>drop the perforations above 24 px, or keep them below it;</li><li>stretch, rotate, outline, or add shadows, gradients or glow;</li><li>set the name in another typeface.</li></ul>
<p>Everything here is generated by <code>tool/icons/vidhoist_kit.py</code>; edit the geometry there, not the files.</p>
</body></html>'''


if __name__ == "__main__":
    android_icons()
    windows_icons()
    installer_images()
    brand_files()
    print("VidHoist kit written.")
