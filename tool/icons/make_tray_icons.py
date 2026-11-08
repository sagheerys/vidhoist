"""Draws Vidhoist's small Windows icons, one colour each: ink for a light
taskbar and cream for a dark one.

- the taskbar preview's buttons, from the icons the app draws
  (packages/vh_ui/lib/src/icons/vh_icons.dart), so they match the player;
- the count badge on the taskbar button, Vidhoist's blue with a white
  figure (the day accent: one badge serves both taskbars).

At the sizes Windows asks for: 16 at 100 percent scaling, 24 at 150, 32 at
200.

The tray icon itself comes with the mark's kit (tool/icons/vidhoist_kit.py).

Run from the repository root: python tool/icons/make_tray_icons.py
The badges need Pillow alone: --badges draws only them, for a machine
without PyMuPDF.
"""

import io
import re
import sys

from PIL import Image, ImageDraw, ImageFont

INK, CREAM = "#2B211B", "#FBF6EE"
THEMES = [("light", INK), ("dark", CREAM)]
SIZES = [(16, 16), (24, 24), (32, 32), (48, 48)]
OUT = "apps/vidhoist_desktop/assets/tray/"
ICONS = "packages/vh_ui/lib/src/icons/vh_icons.dart"


def svg_image(svg, scale):
    import fitz  # PyMuPDF renders the SVG; Pillow writes the .ico

    page = fitz.open(stream=svg.encode(), filetype="svg")[0]
    pixmap = page.get_pixmap(matrix=fitz.Matrix(scale, scale), alpha=True)
    return Image.open(io.BytesIO(pixmap.tobytes("png"))).convert("RGBA")


def icon_svg(key):
    """One icon's SVG from the app's own set, slots unfilled."""
    source = open(ICONS, encoding="utf-8").read()
    quotes = "'" * 3
    pattern = r"VhIconData\(\s*'" + key + r"',\s*r" + quotes + "(.*?)" + quotes
    return re.search(pattern, source, re.S).group(1)


def preview_buttons():
    for key in ["prev", "play_fill", "pause", "next"]:
        for theme, colour in THEMES:
            svg = icon_svg(key).replace("{ink}", colour).replace("{ember}", colour)
            image = svg_image(svg, 256 / 24).resize((256, 256), Image.LANCZOS)
            image.save(f"{OUT}{key}_{theme}.ico", sizes=SIZES[:3])


def badges():
    """The count on the taskbar button: 1 to 9, then 9+."""
    # The palette's day accent (packages/vh_ui/lib/src/tokens/palette.dart).
    blue = (0x24, 0x57, 0xD6, 255)
    white = (255, 255, 255, 255)
    font_file = "C:/Windows/Fonts/segoeuib.ttf"
    for count in [str(n) for n in range(1, 10)] + ["9+"]:
        image = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
        draw = ImageDraw.Draw(image)
        draw.ellipse((8, 8, 248, 248), fill=blue)
        font = ImageFont.truetype(font_file, 150 if len(count) == 1 else 110)
        draw.text((128, 132), count, font=font, fill=white, anchor="mm")
        image.save(f"{OUT}badge_{count.replace('+', 'plus')}.ico", sizes=SIZES[:3])


if "--badges" not in sys.argv:
    preview_buttons()
badges()
print("wrote", OUT)
