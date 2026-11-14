# -*- coding: utf-8 -*-
"""VidHoist's mark kit: one source for every icon the two apps ship.

The mark: a strip of film folded into the letter V. The front arm carries
four perforations down its outer edge; the back arm is the second colour and
stops a hair short of the front one, so the fold reads as a clear gap. On
Windows it sits on an espresso tile; on Android the tile is the accent.
(Chosen by the owner on 2026-11-11 from the boards in
docs/design/mockups-2026-11-11-logo*; it replaced the window with the
download arrow.)

Writes:
  apps/vidhoist_mobile/assets/icons/icon.png, icon_foreground.png,
      icon_monochrome.png            then: dart run flutter_launcher_icons
  apps/vidhoist_desktop/windows/runner/resources/app_icon.ico
  apps/vidhoist_desktop/assets/tray/tray_light.ico, tray_dark.ico
  apps/vidhoist_desktop/windows/installer/wizard_large_*.bmp, wizard_small_*.png
  apps/vidhoist_desktop/brand/*.svg, vidhoist-symbol-1024.png

Rendering goes through a headless Chromium (Edge, which every Windows 11
carries) so the kit needs no SVG library: python tool/icons/vidhoist_kit.py
Run it from PowerShell: from Git Bash Edge returns success and writes nothing.
"""
import math
import os
import subprocess
import tempfile

from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
MOBILE = os.path.join(ROOT, "apps", "vidhoist_mobile")
DESKTOP = os.path.join(ROOT, "apps", "vidhoist_desktop")
BRAND = os.path.join(DESKTOP, "brand")

INK = "#2B211B"
CREAM = "#FBF6EE"
# The accent is repeated here from VhPalette (palette.dart), by day and by
# night, because the kit runs without Dart.
ACCENT = "#2457D6"        # superDay.accent: the Android tile, the back arm on light
ACCENT_NIGHT = "#7FA3FF"  # superNight.accent: the back arm on the espresso tile
ACCENT_SOFT = "#BCCDF5"   # the back arm on the accent tile: cream at about 55% over it
GRID = 256
SMALL_BELOW = 24

EDGE = next((p for p in [
    r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    r"C:\Program Files\Microsoft\Edge\Application\msedge.exe",
    r"C:\Program Files\Google\Chrome\Application\chrome.exe",
] if os.path.exists(p)), None)

# ---------------------------------------------------------------- geometry
# The ribbon on the 256 grid. HALF: half its width at the top; ARM: the
# width of one arm; TOP and TIP: where it starts and where the V ends;
# CORNER: the one radius every corner takes.
HALF, ARM, TOP, TIP, CORNER = 78, 50, 58, 202, 6
# The clear space between the two arms along the fold; wider in the small
# cut, where 7 units are less than half a pixel.
GAP, GAP_SMALL = 7, 10


def _rounded(pts, r):
    """A polygon with every corner rounded to radius r, as one sub-path."""
    n, segs = len(pts), []
    for i in range(n):
        p0, p1, p2 = pts[i - 1], pts[i], pts[(i + 1) % n]
        v1 = (p0[0] - p1[0], p0[1] - p1[1])
        v2 = (p2[0] - p1[0], p2[1] - p1[1])
        l1, l2 = math.hypot(*v1), math.hypot(*v2)
        u1, u2 = (v1[0] / l1, v1[1] / l1), (v2[0] / l2, v2[1] / l2)
        ang = math.acos(max(-1, min(1, u1[0] * u2[0] + u1[1] * u2[1])))
        d = r / math.tan(ang / 2)
        sweep = 1 if u1[0] * u2[1] - u1[1] * u2[0] < 0 else 0
        segs.append(((p1[0] + u1[0] * d, p1[1] + u1[1] * d), (p1[0] + u2[0] * d, p1[1] + u2[1] * d), sweep))
    out = f"M{segs[-1][1][0]:.2f} {segs[-1][1][1]:.2f}"
    for a, b, sweep in segs:
        out += f"L{a[0]:.2f} {a[1]:.2f}A{r} {r} 0 0 {sweep} {b[0]:.2f} {b[1]:.2f}"
    return out + "Z"


_SLOPE = HALF / (TIP - TOP)                     # how far an edge moves sideways per unit down
_INNER_Y = TOP + (HALF - ARM) / _SLOPE          # the inner vertex of the V
_FOLD = (128 + ARM / 2, TOP + (2 * HALF - ARM) / (2 * _SLOPE))   # where the arms' edges cross


def _perforation(y):
    """One perforation of the front arm at height y, leaning with the arm."""
    cx, hw, hh = 128 - HALF + _SLOPE * (y - TOP) + 15, 5.5, 7.5
    return _rounded([(cx - hw - _SLOPE * hh, y - hh), (cx + hw - _SLOPE * hh, y - hh),
                     (cx + hw + _SLOPE * hh, y + hh), (cx - hw + _SLOPE * hh, y + hh)], 2.5)


FRONT = _rounded([(128 - HALF, TOP), (128 - HALF + ARM, TOP), _FOLD, (128, TIP)], CORNER)
PERFORATIONS = "".join(_perforation(TOP + step) for step in (22, 50, 78, 106))


def _back(gap):
    """The back arm, stopped [gap] short of the front arm across the fold."""
    n = math.hypot(_SLOPE, 1)
    ux, uy = -_SLOPE / n, 1 / n                 # down the back arm
    d = -gap / math.sin(2 * math.atan(_SLOPE))
    return _rounded([(128 + HALF - ARM, TOP), (128 + HALF, TOP),
                     (_FOLD[0] + d * ux, _FOLD[1] + d * uy), (128 + d * ux, _INNER_Y + d * uy)], CORNER)


def mark(front, back, small=False):
    """The folded ribbon: the front arm in [front], the back arm in [back].
    The small cut drops the perforations and widens the gap."""
    holes = "" if small else PERFORATIONS
    return (f'<path fill="{back}" d="{_back(GAP_SMALL if small else GAP)}"/>'
            f'<path fill="{front}" fill-rule="evenodd" d="{FRONT}{holes}"/>')


def svg(body, w=GRID, h=GRID, title="VidHoist"):
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" width="{w}" height="{h}">'
            f'<title>{title}</title>{body}</svg>')


EDGE_RIM = '<rect x="2" y="2" width="252" height="252" rx="56" fill="none" stroke="#FBF6EE" stroke-opacity="0.32" stroke-width="4"/>'


def _placed(art, scale, drop=0.0, about=128.0):
    """[art] grown by [scale] about the point (128, about) and lowered by
    [drop] grid units."""
    return f'<g transform="translate(128 {about + drop:.1f}) scale({scale}) translate(-128 -{about:.1f})">{art}</g>'


# **How large the ribbon sits** (owner's device round 2026-11-11: drawn at
# its bare grid size it looked "very small" on the phone). A V carries its
# weight in its top half, so it is also lowered a little: centred by its
# box it floats high and reads smaller still.
ON_TILE, ON_TILE_SMALL, TILE_DROP = 1.2, 1.28, 6
# With no tile around it (the tray) the ribbon nearly fills the square,
# grown about its own box's centre.
BLEED, BOX_CENTRE = 1.5, (TOP + TIP) / 2


def tile_art(edge=False, small=False):
    """Espresso tile, the front arm cream, the back arm the night accent."""
    rim = EDGE_RIM if edge else ""
    art = _placed(mark(CREAM, ACCENT_NIGHT, small), ON_TILE_SMALL if small else ON_TILE, TILE_DROP)
    return f'<rect width="256" height="256" rx="58" fill="{INK}"/>{rim}{art}'


def tile_svg(edge=False, small=False):
    return svg(tile_art(edge, small))


def mono_art(colour, small=False):
    """One colour: the mark without its tile, for tray icons and print."""
    return mark(colour, colour, small)


def tray_svg(colour, small=False):
    """The one-colour mark filling the square, as a tray icon needs it."""
    return svg(_placed(mono_art(colour, small), BLEED, about=BOX_CENTRE))


def mono_svg(colour, small=False):
    return svg(mono_art(colour, small))


def bare_svg(dark=False):
    """The mark alone in its two colours, for a light ground or a dark one."""
    return svg(mark(CREAM, ACCENT_NIGHT) if dark else mark(INK, ACCENT))


def mobile_svg():
    """The Android tile: the accent, the front arm cream, the back arm soft."""
    art = _placed(mark(CREAM, ACCENT_SOFT), ON_TILE, TILE_DROP)
    return svg(f'<rect width="256" height="256" rx="58" fill="{ACCENT}"/>{art}')


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
# The adaptive icon's layers are 108 dp square, of which the launcher shows
# a 72 dp mask and promises only a 66 dp circle (92% of the mask's radius).
# The 256 grid is drawn at this share of the file and the ribbon lowered by
# ADAPTIVE_DROP grid units: the V is then 64% of the icon's width, and its
# two top corners, the farthest points, sit at about 81% of the mask's
# radius, inside the promised circle under any launcher's mask.
#
# **This holds only with `adaptive_icon_foreground_inset: 0`** in the phone
# app's pubspec. flutter_launcher_icons wraps the layers in a 16% inset by
# default, which shrinks them to 68%: the first two cuts came out at 36%
# and 48% of the icon's width on the owner's phone, "very small".
ADAPTIVE_SHARE, ADAPTIVE_DROP = 0.70, 10


def _layer(art_body):
    """One adaptive layer: the 256 grid centred on a transparent 1024 file."""
    inner = round(1024 * ADAPTIVE_SHARE)
    art = render(svg(_placed(art_body, 1, ADAPTIVE_DROP)), inner)
    layer = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
    layer.paste(art, ((1024 - inner) // 2, (1024 - inner) // 2), art)
    return layer


def android_icons():
    out = os.path.join(MOBILE, "assets", "icons")
    os.makedirs(out, exist_ok=True)
    render(mobile_svg(), 1024).save(os.path.join(out, "icon.png"))
    # The perforations are holes, so the launcher's accent shows through them.
    _layer(mark(CREAM, ACCENT_SOFT)).save(os.path.join(out, "icon_foreground.png"))
    # Android 13+ themed icon: a white silhouette the system tints. The gap
    # along the fold keeps the two arms apart in one colour.
    _layer(mark("#FFFFFF", "#FFFFFF")).save(os.path.join(out, "icon_monochrome.png"))
    status_icon()


STATUS_ICON = os.path.join(MOBILE, "android", "app", "src", "main", "res", "drawable", "ic_stat_vidhoist.xml")


def status_icon():
    """The status bar's icon for every notification: a vector, so it is
    sharp at every density. Android draws it as a silhouette in the bar's
    own colour, white on a dark bar and dark on a light one, whatever
    colour the file holds; so both arms are white, kept apart by the gap.
    The small cut: 24 dp leaves a perforation under a pixel. It fills the
    square as the tray icon does, inside the 22 dp the bar keeps clear."""
    def path(d):
        return (f'        <path android:fillColor="#FFFFFFFF" android:fillType="evenOdd"\n'
                f'            android:pathData="{d}" />\n')
    xml = ('<?xml version="1.0" encoding="utf-8"?>\n'
           '<!-- Generated by tool/icons/vidhoist_kit.py (status_icon): the mark\n'
           '     in the status bar, white on clear as Android expects. -->\n'
           '<vector xmlns:android="http://schemas.android.com/apk/res/android"\n'
           '    android:width="24dp"\n'
           '    android:height="24dp"\n'
           f'    android:viewportWidth="{GRID}"\n'
           f'    android:viewportHeight="{GRID}">\n'
           f'    <group android:pivotX="128" android:pivotY="{BOX_CENTRE:g}"\n'
           f'        android:scaleX="{BLEED}" android:scaleY="{BLEED}">\n'
           + path(_back(GAP_SMALL)) + path(FRONT) +
           '    </group>\n'
           '</vector>\n')
    with open(STATUS_ICON, "w", encoding="utf-8", newline="\n") as f:
        f.write(xml)


ICON_SIZES = [16, 20, 24, 32, 40, 48, 64, 256]
TRAY_SIZES = [16, 20, 24, 32, 40, 48]


def windows_icons():
    big = render(tile_svg(edge=True), 1024)
    small = render(tile_svg(edge=True, small=True), 512)
    _ico([fit(small if s < SMALL_BELOW else big, s) for s in ICON_SIZES],
         os.path.join(DESKTOP, "windows", "runner", "resources", "app_icon.ico"))
    for theme, colour in [("light", INK), ("dark", CREAM)]:
        big = render(tray_svg(colour), 512)
        small = render(tray_svg(colour, small=True), 512)
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
    art = render(bare_svg(dark=True), 1024)
    for scale, (w, h) in {100: (164, 314), 125: (205, 393), 150: (246, 471), 200: (328, 628)}.items():
        img = Image.new("RGB", (w, h), INK)
        ms = int(w * 0.66)
        m = art.resize((ms, ms), Image.LANCZOS)
        img.paste(m, ((w - ms) // 2, int(h * 0.27)), m)
        d = ImageDraw.Draw(img)
        font = _font(int(w * 0.135))
        text = "VidHoist"
        tw = d.textlength(text, font=font)
        d.text(((w - tw) / 2, int(h * 0.27) + int(ms * 0.86) + int(h * 0.03)), text, font=font, fill=CREAM)
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
        "vidhoist-mark.svg": bare_svg(),
        "vidhoist-mark-dark.svg": bare_svg(dark=True),
        "vidhoist-mark-ink.svg": mono_svg(INK),
        "vidhoist-mark-cream.svg": mono_svg(CREAM),
    }
    for kind in ("horizontal", "stacked"):
        for suffix, dark in (("", False), ("-dark", True)):
            files[f"vidhoist-{kind}{suffix}.svg"] = _lockup(kind, dark)
    for name, text in files.items():
        open(os.path.join(BRAND, name), "w", encoding="utf-8").write(text)
    render(tile_svg(), 1024).save(os.path.join(BRAND, "vidhoist-symbol-1024.png"))
    open(os.path.join(BRAND, "guide.html"), "w", encoding="utf-8").write(_guide())


def _lockup(kind, dark):
    """The mark alone beside the name, or over it. The ribbon needs no tile."""
    font = "font-family=\"Manrope, 'Segoe UI', system-ui, sans-serif\" font-weight=\"800\""
    word = CREAM if dark else INK
    art = mark(CREAM, ACCENT_NIGHT) if dark else mark(INK, ACCENT)
    if kind == "horizontal":
        w, h = 836, 256
        # The ribbon spans 50..206 of its grid: pulled left so it starts near the edge.
        body = (f'<g transform="translate(-40 0)">{art}</g>'
                f'<text x="196" y="182" font-size="150" {font} fill="{word}">VidHoist</text>')
    else:
        w, h = 640, 400
        body = (f'<g transform="translate(192 -30)">{art}</g>'
                f'<text x="320" y="340" text-anchor="middle" font-size="120" {font} fill="{word}">VidHoist</text>')
    return svg(body, w, h)


def _guide():
    return f'''<!doctype html><html lang="en"><head><meta charset="utf-8"><title>VidHoist mark</title>
<style>body{{font:15px/1.6 system-ui,sans-serif;max-width:900px;margin:40px auto;padding:0 16px;color:{INK}}}
figure{{display:inline-block;margin:8px;padding:20px;border:1px solid #e6ddd0;border-radius:12px;text-align:center}}
figcaption{{font-size:12px;color:#8a7d73;margin-top:8px}}.dark{{background:{INK}}}.blue{{background:{ACCENT}}}</style></head><body>
<h1>VidHoist: the mark</h1>
<p>A strip of film folded into the letter V. The front arm carries four perforations down its outer edge; the back arm is the second colour and stops a hair short of the front one, so the fold reads as a clear gap. On a light ground the front arm is the ink <code>{INK}</code> and the back arm the accent <code>{ACCENT}</code>; on the espresso tile (Windows) they are cream <code>{CREAM}</code> and the night accent <code>{ACCENT_NIGHT}</code>; on the accent tile (Android) cream and a soft blue <code>{ACCENT_SOFT}</code>. Below 24 px the small cut drops the perforations and widens the gap.</p>
<p dir="rtl">شريط فيلم مطويّ على شكل حرف V. الذراع الأمامية تحمل أربعة ثقوب على حافتها، والخلفية باللون الثاني وتقف دون الأمامية بفجوة رفيعة عند الطيّ. على ويندوز بلاطة حبرية، وعلى أندرويد بلاطة زرقاء. تحت 24 بكسل تسقط الثقوب وتتّسع الفجوة.</p>
<figure><img src="vidhoist-mark.svg" width="128"><figcaption>vidhoist-mark.svg</figcaption></figure>
<figure class="dark"><img src="vidhoist-mark-dark.svg" width="128"><figcaption style="color:#aaa">vidhoist-mark-dark.svg</figcaption></figure>
<figure><img src="vidhoist-symbol.svg" width="128"><figcaption>vidhoist-symbol.svg</figcaption></figure>
<figure class="dark"><img src="vidhoist-symbol-dark.svg" width="128"><figcaption style="color:#aaa">vidhoist-symbol-dark.svg</figcaption></figure>
<figure><img src="vidhoist-symbol-small.svg" width="48"><figcaption>vidhoist-symbol-small.svg (below 24 px)</figcaption></figure>
<figure><img src="vidhoist-mark-ink.svg" width="128"><figcaption>vidhoist-mark-ink.svg</figcaption></figure>
<figure class="dark"><img src="vidhoist-mark-cream.svg" width="128"><figcaption style="color:#aaa">vidhoist-mark-cream.svg</figcaption></figure>
<figure><img src="vidhoist-horizontal.svg" height="64"><figcaption>vidhoist-horizontal.svg</figcaption></figure>
<figure class="dark"><img src="vidhoist-horizontal-dark.svg" height="64"><figcaption style="color:#aaa">vidhoist-horizontal-dark.svg</figcaption></figure>
<figure><img src="vidhoist-stacked.svg" height="120"><figcaption>vidhoist-stacked.svg</figcaption></figure>
<h2>Do not</h2><ul><li>recolour either arm outside the three pairings above, or let them follow the theme;</li><li>close the gap along the fold, or outline the arms;</li><li>put the espresso tile on a dark ground without its light edge;</li><li>keep the perforations below 24 px, or drop them above it;</li><li>stretch, rotate, mirror, or add shadows, gradients or glow;</li><li>set the name in another typeface.</li></ul>
<p>Everything here is generated by <code>tool/icons/vidhoist_kit.py</code>; edit the geometry there, not the files.</p>
</body></html>'''


if __name__ == "__main__":
    android_icons()
    windows_icons()
    installer_images()
    brand_files()
    print("VidHoist kit written.")
