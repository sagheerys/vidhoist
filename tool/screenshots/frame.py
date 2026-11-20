"""Puts the screenshots in frames and lays them out for the READMEs.

The phone shots go into a phone body with its status bar and gesture bar,
the Windows shots into a window with rounded corners, each with a soft
shadow, on the app's own ground. Run after the screenshot tests:

    python tool/screenshots/frame.py
"""
import os

from PIL import Image, ImageDraw, ImageFilter, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
SHOTS = os.path.join(ROOT, 'docs', 'screenshots')
FONT = os.path.join(ROOT, 'packages', 'vh_ui', 'assets', 'fonts',
                    'NotoSans-Medium.ttf')

GROUND = (242, 241, 238)       # VhPalette.desktopDay.bg
BODY = (28, 24, 21)            # the phone's edge, near the ink
SHADOW = (43, 33, 27)

# A phone shot is 720 x 1600 pixels: 360 x 800 points at twice.
STATUS_H = 56                  # the shots leave this much for the bar
BEZEL = 14
SCREEN_RADIUS = 58


def shot(name):
    return Image.open(os.path.join(SHOTS, name + '.png')).convert('RGB')


def is_dark(img, box):
    region = img.crop(box).resize((1, 1))
    r, g, b = region.getpixel((0, 0))
    return (0.2126 * r + 0.7152 * g + 0.0722 * b) < 128


def rounded_mask(size, radius):
    mask = Image.new('L', size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, size[0] - 1, size[1] - 1),
                                           radius, fill=255)
    return mask


def status_bar(draw, width, ink, time='10:24'):
    font = ImageFont.truetype(FONT, 26)
    draw.text((44, 14), time, font=font, fill=ink)
    x = width - 44
    # Battery.
    draw.rounded_rectangle((x - 30, 20, x, 38), 4, outline=ink, width=3)
    draw.rectangle((x - 26, 24, x - 8, 34), fill=ink)
    draw.rectangle((x + 2, 25, x + 5, 33), fill=ink)
    # Signal.
    sx = x - 76
    for i in range(4):
        h = 6 + i * 5
        draw.rectangle((sx + i * 7, 38 - h, sx + i * 7 + 4, 38), fill=ink)
    # Wi-Fi: three arcs and a dot.
    wx, wy = x - 112, 40
    for r in (8, 15, 22):
        draw.arc((wx - r, wy - r, wx + r, wy + r), 225, 315, fill=ink, width=3)
    draw.ellipse((wx - 3, wy - 3, wx + 3, wy + 3), fill=ink)


def phone(name):
    """The shot in a phone body, transparent around it."""
    screen = shot(name).copy()
    w, h = screen.size
    draw = ImageDraw.Draw(screen)
    top_dark = is_dark(screen, (0, 0, w, STATUS_H))
    status_bar(draw, w, (245, 242, 238) if top_dark else (43, 33, 27))
    bottom_dark = is_dark(screen, (0, h - 36, w, h))
    pill = (235, 232, 228) if bottom_dark else (43, 33, 27)
    draw.rounded_rectangle((w // 2 - 70, h - 20, w // 2 + 70, h - 12), 4,
                           fill=pill)

    outer = (w + BEZEL * 2, h + BEZEL * 2)
    body = Image.new('RGBA', outer, (0, 0, 0, 0))
    edge = Image.new('RGBA', outer, BODY + (255,))
    body.paste(edge, (0, 0), rounded_mask(outer, SCREEN_RADIUS + BEZEL))
    body.paste(screen, (BEZEL, BEZEL), rounded_mask((w, h), SCREEN_RADIUS))
    return body


def window(name):
    """The shot in a window with rounded corners and a hairline."""
    img = shot(name)
    w, h = img.size
    radius = 14
    body = Image.new('RGBA', (w + 2, h + 2), (0, 0, 0, 0))
    edge = Image.new('RGBA', body.size, (60, 52, 46, 255))
    body.paste(edge, (0, 0), rounded_mask(body.size, radius + 1))
    body.paste(img, (1, 1), rounded_mask((w, h), radius))
    return body


def shadow_of(piece, blur, alpha):
    mask = piece.split()[-1].point(lambda v: alpha if v else 0)
    shade = Image.new('RGBA', piece.size, SHADOW + (0,))
    shade.putalpha(mask)
    pad = blur * 3
    canvas = Image.new('RGBA', (piece.width + pad * 2, piece.height + pad * 2),
                       (0, 0, 0, 0))
    canvas.paste(shade, (pad, pad), shade)
    return canvas.filter(ImageFilter.GaussianBlur(blur)), pad


def compose(pieces, gap, offsets, margin, out, width):
    """[pieces] side by side, each lowered by its offset, with shadows."""
    pw = sum(p.width for p in pieces) + gap * (len(pieces) - 1)
    ph = max(p.height + o for p, o in zip(pieces, offsets))
    canvas = Image.new('RGBA', (pw + margin * 2, ph + margin * 2),
                       GROUND + (255,))
    x = margin
    for piece, offset in zip(pieces, offsets):
        shade, pad = shadow_of(piece, 26, 70)
        canvas.alpha_composite(shade, (x - pad, margin + offset - pad + 22))
        canvas.alpha_composite(piece, (x, margin + offset))
        x += piece.width + gap
    scale = width / canvas.width
    final = canvas.convert('RGB').resize(
        (width, round(canvas.height * scale)), Image.LANCZOS)
    final.save(os.path.join(SHOTS, out), quality=88, optimize=True)
    print(out, final.size)


def phones(names, out):
    pieces = [phone(n) for n in names]
    compose(pieces, 90, [0, 80, 0, 80][:len(pieces)], 110, out, 2000)


def windows(names, out):
    pieces = [window(n) for n in names]
    compose(pieces, 80, [0] * len(pieces), 90, out, 2200)


if __name__ == '__main__':
    for lang in ('en', 'ar'):
        phones([f'phone-library-{lang}-day', f'phone-video-{lang}-day',
                f'phone-audio-{lang}-night', f'phone-channels-{lang}-day'],
               f'hero-{lang}.jpg')
        phones([f'phone-audio-{lang}-day', f'phone-video-{lang}-night',
                f'phone-library-{lang}-night', f'phone-languages-{lang}-day'],
               f'more-{lang}.jpg')
        windows([f'windows-clip-{lang}-day', f'windows-library-{lang}-day'],
                f'desktop-{lang}.jpg')
        windows([f'windows-clip-{lang}-night', f'windows-audio-{lang}-night'],
                f'desktop-night-{lang}.jpg')
