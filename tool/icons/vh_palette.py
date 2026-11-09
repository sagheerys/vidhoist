"""The VidHoist palette, read from the Dart source so that a mockup can never
drift from the app: `packages/vh_ui/lib/src/tokens/palette.dart` is parsed at
import and each `Color(0xAARRGGBB)` becomes a CSS colour.

    import vh_palette as p
    p.DAY["accent"]      -> "#2457D6"
    p.NIGHT["ink2"]      -> "rgba(240,235,228,0.66)"
    p.css_vars(p.DAY)    -> "--bg:#F2F1EE;--card:#FFFFFF;..."

Usage: python -I vh_palette.py   (prints both palettes, as a check)
"""
import os
import re

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
PALETTE_DART = os.path.join(ROOT, "packages", "vh_ui", "lib", "src", "tokens", "palette.dart")

_BLOCK = re.compile(r"static const VhPalette (\w+) = VhPalette\((.*?)\n  \);", re.S)
_FIELD = re.compile(r"(\w+): Color\(0x([0-9A-Fa-f]{8})\)")


def _css(argb):
    a, r, g, b = (int(argb[i:i + 2], 16) for i in (0, 2, 4, 6))
    if a == 255:
        return f"#{argb[2:].upper()}"
    return f"rgba({r},{g},{b},{a / 255:.2f})"


def load(path=PALETTE_DART):
    """Every named palette in the Dart file: {name: {field: css colour}}."""
    src = open(path, encoding="utf-8").read()
    out = {}
    for name, body in _BLOCK.findall(src):
        out[name] = {field: _css(argb) for field, argb in _FIELD.findall(body)}
    if "desktopDay" not in out or "desktopNight" not in out:
        raise SystemExit(f"palette.dart changed shape: found {sorted(out)}")
    return out


PALETTES = load()
DAY = PALETTES["desktopDay"]
NIGHT = PALETTES["desktopNight"]


def css_vars(palette):
    """The palette as CSS custom properties, one per field, named as in Dart."""
    return ";".join(f"--{k}:{v}" for k, v in palette.items())


if __name__ == "__main__":
    for name in ("desktopDay", "desktopNight"):
        print(name)
        for k, v in PALETTES[name].items():
            print(f"  {k:14} {v}")
