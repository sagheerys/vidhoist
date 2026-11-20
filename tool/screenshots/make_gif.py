"""Makes the animation of a download for the READMEs and the project page.

The frames come from the phone's own widgets, drawn by
`apps/vidhoist_mobile/test/screenshots/download_gif_test.dart` into
`build/gif/<language>/` with how long each one shows. Here each goes into
the phone body of `frame.py`, on the app's ground, and the lot becomes a
looping GIF in `docs/screenshots/`:

    cd apps/vidhoist_mobile && VH_SHOTS=1 flutter test test/screenshots/download_gif_test.dart
    python tool/screenshots/make_gif.py
"""
import json
import os

from PIL import Image

from frame import GROUND, ROOT, SHOTS, phone_of, shadow_of

WIDTH = 440          # the animation's width in pixels, phone and margin
MARGIN = 60


def framed(path):
    piece = phone_of(Image.open(path))
    shade, pad = shadow_of(piece, 22, 60)
    canvas = Image.new('RGBA', (piece.width + MARGIN * 2,
                                piece.height + MARGIN * 2), GROUND + (255,))
    canvas.alpha_composite(shade, (MARGIN - pad, MARGIN - pad + 18))
    canvas.alpha_composite(piece, (MARGIN, MARGIN))
    scale = WIDTH / canvas.width
    return canvas.convert('RGB').resize(
        (WIDTH, round(canvas.height * scale)), Image.LANCZOS)


def make(lang):
    folder = os.path.join(ROOT, 'build', 'gif', lang)
    with open(os.path.join(folder, 'frames.json'), encoding='utf-8') as f:
        frames = json.load(f)
    images = [framed(os.path.join(folder, fr['file'])) for fr in frames]
    # One palette for every frame, taken from the first and the last: the
    # ground and the covers stay the same colour from frame to frame
    # instead of shimmering.
    sample = Image.new('RGB', (WIDTH * 2, images[0].height))
    sample.paste(images[0], (0, 0))
    sample.paste(images[-1], (WIDTH, 0))
    palette = sample.quantize(colors=255, method=Image.MEDIANCUT)
    quantized = [im.quantize(palette=palette, dither=Image.NONE)
                 for im in images]
    out = os.path.join(SHOTS, f'download-{lang}.gif')
    quantized[0].save(out, save_all=True, append_images=quantized[1:],
                      duration=[fr['ms'] for fr in frames], loop=0,
                      optimize=True)
    print(out, images[0].size, f'{os.path.getsize(out) // 1024} KB')


if __name__ == '__main__':
    for lang in ('en', 'ar'):
        make(lang)
