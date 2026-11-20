"""Draws the sample covers the project's screenshots show.

Made here, from shapes and gradients, so the screenshots carry nobody
else's pictures. Run once; the PNGs are kept beside this file:

    python tool/screenshots/make_covers.py
"""
import math
import os
import random

from PIL import Image, ImageDraw, ImageFilter

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, 'covers')
W, H = 640, 360


def gradient(top, bottom, size=(W, H)):
    img = Image.new('RGB', size)
    draw = ImageDraw.Draw(img)
    for y in range(size[1]):
        t = y / (size[1] - 1)
        draw.line([(0, y), (size[0], y)],
                  fill=tuple(round(a + (b - a) * t) for a, b in zip(top, bottom)))
    return img


def ridge(draw, base, amp, color, seed, step=8):
    rnd = random.Random(seed)
    points = [(0, H)]
    y = base
    for x in range(0, W + step, step):
        y += rnd.uniform(-amp, amp)
        y = min(max(y, base - amp * 6), base + amp * 3)
        points.append((x, y))
    points.append((W, H))
    draw.polygon(points, fill=color)


def mountains():
    img = gradient((255, 196, 140), (120, 150, 210))
    draw = ImageDraw.Draw(img)
    draw.ellipse((420, 70, 500, 150), fill=(255, 236, 200))
    ridge(draw, 190, 9, (96, 112, 160), 1)
    ridge(draw, 240, 8, (62, 74, 120), 2)
    ridge(draw, 290, 6, (34, 42, 78), 3)
    return img


def sea():
    img = gradient((140, 200, 235), (20, 90, 150))
    draw = ImageDraw.Draw(img)
    draw.rectangle((0, 200, W, H), fill=(18, 82, 140))
    for i in range(14):
        y = 210 + i * 11
        for x in range(-40, W, 70):
            off = (i * 23) % 70
            draw.arc((x + off, y, x + off + 50, y + 10), 200, 340,
                     fill=(170, 215, 240), width=2)
    draw.polygon([(250, 205), (300, 120), (300, 205)], fill=(250, 250, 245))
    draw.polygon([(305, 205), (305, 135), (345, 205)], fill=(235, 235, 228))
    draw.rectangle((255, 205, 350, 218), fill=(120, 70, 40))
    return img


def city():
    img = gradient((12, 16, 40), (60, 40, 90))
    draw = ImageDraw.Draw(img)
    rnd = random.Random(7)
    for _ in range(60):
        x, y = rnd.randrange(W), rnd.randrange(150)
        draw.point((x, y), fill=(230, 230, 255))
    x = 0
    while x < W:
        w = rnd.randrange(34, 70)
        h = rnd.randrange(90, 230)
        draw.rectangle((x, H - h, x + w - 4, H), fill=(22, 24, 44))
        for wy in range(H - h + 10, H - 6, 14):
            for wx in range(x + 6, x + w - 10, 10):
                if rnd.random() < 0.45:
                    draw.rectangle((wx, wy, wx + 4, wy + 6), fill=(255, 210, 120))
        x += w
    return img


def desert():
    img = gradient((250, 170, 110), (250, 220, 170))
    draw = ImageDraw.Draw(img)
    draw.ellipse((90, 60, 170, 140), fill=(255, 245, 210))
    for i, (base, color) in enumerate([(230, (226, 160, 96)),
                                       (270, (206, 136, 74)),
                                       (310, (180, 112, 58))]):
        pts = [(0, H)]
        for x in range(0, W + 10, 10):
            pts.append((x, base + 22 * math.sin(x / (90 + i * 30) + i)))
        pts.append((W, H))
        draw.polygon(pts, fill=color)
    return img


def forest():
    img = gradient((200, 230, 210), (90, 150, 110))
    draw = ImageDraw.Draw(img)
    rnd = random.Random(11)
    for row, (y, shade) in enumerate([(200, (60, 120, 80)), (250, (40, 96, 62)),
                                      (300, (24, 70, 44))]):
        for x in range(-20, W + 20, 34 - row * 4):
            h = rnd.randrange(60, 110)
            draw.polygon([(x, y + 40), (x + 18, y + 40 - h), (x + 36, y + 40)],
                         fill=shade)
        draw.rectangle((0, y + 38, W, H), fill=shade)
    return img


def abstract(seed, colors):
    img = gradient(colors[0], colors[1])
    layer = Image.new('RGBA', (W, H))
    draw = ImageDraw.Draw(layer)
    rnd = random.Random(seed)
    for _ in range(7):
        r = rnd.randrange(60, 170)
        x, y = rnd.randrange(W), rnd.randrange(H)
        c = colors[rnd.randrange(2, len(colors))]
        draw.ellipse((x - r, y - r, x + r, y + r), fill=c + (150,))
    layer = layer.filter(ImageFilter.GaussianBlur(28))
    img.paste(layer, (0, 0), layer)
    return img


def kitchen():
    img = gradient((250, 236, 214), (236, 206, 170))
    draw = ImageDraw.Draw(img)
    draw.ellipse((200, 90, 440, 330), fill=(245, 245, 240), outline=(210, 200, 190), width=6)
    draw.ellipse((240, 130, 400, 290), fill=(222, 110, 60))
    for (x, y, c) in [(290, 170, (90, 160, 70)), (340, 200, (250, 210, 80)),
                      (300, 230, (90, 160, 70)), (350, 160, (200, 60, 50))]:
        draw.ellipse((x - 16, y - 16, x + 16, y + 16), fill=c)
    draw.rectangle((470, 120, 482, 320), fill=(160, 160, 165))
    draw.ellipse((458, 90, 494, 150), fill=(160, 160, 165))
    return img


def music_square(side=1080):
    """Square and large: the players show it big, where a small one's thin
    rings turned to steps."""
    img = gradient((40, 30, 90), (220, 90, 120), size=(side, side))
    layer = Image.new('RGBA', (side, side))
    draw = ImageDraw.Draw(layer)
    rnd = random.Random(5)
    for _ in range(7):
        r = rnd.randrange(side // 5, side // 2)
        x, y = rnd.randrange(side), rnd.randrange(side)
        c = [(255, 180, 80), (90, 200, 220), (220, 90, 120)][rnd.randrange(3)]
        draw.ellipse((x - r, y - r, x + r, y + r), fill=c + (150,))
    layer = layer.filter(ImageFilter.GaussianBlur(side // 12))
    img.paste(layer, (0, 0), layer)
    draw = ImageDraw.Draw(img)
    c = side // 2
    for r in range(side // 3, side // 16, -side // 30):
        draw.ellipse((c - r, c - r, c + r, c + r), outline=(255, 255, 255),
                     width=max(2, side // 360))
    dot = side // 20
    draw.ellipse((c - dot, c - dot, c + dot, c + dot), fill=(255, 255, 255))
    return img


COVERS = {
    'mountains': mountains,
    'sea': sea,
    'city': city,
    'desert': desert,
    'forest': forest,
    'kitchen': kitchen,
    'aurora': lambda: abstract(3, [(10, 30, 50), (20, 90, 90), (80, 220, 160), (120, 120, 255)]),
    'sunset': lambda: abstract(9, [(255, 120, 90), (110, 40, 120), (255, 200, 120), (255, 90, 160)]),
    'music': music_square,
}

if __name__ == '__main__':
    os.makedirs(OUT, exist_ok=True)
    for name, make in COVERS.items():
        make().convert('RGB').save(os.path.join(OUT, f'{name}.jpg'), quality=86)
    print('covers:', ', '.join(COVERS))
