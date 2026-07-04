#!/usr/bin/env python3
"""png_to_bmp.py -- convert the project's image assets to 24-bit BMP.

The asset trees (data_extracted/**, docs/atlas/**) carry every sprite,
sheet and background as a plain 24-bit BMP (BI_RGB). Transparency, which
BMP24 cannot store, is encoded as the pure-magenta colorkey (255,0,255):
that RGB is not a VICEROY.PAL entry and no asset uses it opaquely
(verified repo-wide 2026-07-04), so the runtime maps it to the
transparent index unambiguously (native_assets.cpp read_png_quantized).

Converting is index-exact: the runtime quantizes RGB against
VICEROY.PAL at load either way, and this tool verifies per file that the
BMP decodes to the same index map the PNG did before deleting the PNG.

Usage: python3 tools/png_to_bmp.py [--keep-png] [ROOT...]
       (default roots: data_extracted docs/atlas)
"""
import json
import os
import sys

from PIL import Image

MAGENTA = (255, 0, 255)


def load_palette(repo):
    cols = json.load(open(os.path.join(repo, "data_extracted/palette.json")))
    pal = [(c["r"], c["g"], c["b"]) for c in sorted(cols, key=lambda c: c["index"])]
    # exact-match LUT, first palette occurrence wins (native_assets.cpp)
    lut = {}
    for i in range(255, -1, -1):
        lut[pal[i]] = i
    return pal, lut


def quantize(im, pal, lut):
    """Replicate read_png_quantized: index map with -1 = transparent."""
    px = list(im.convert("RGBA").getdata())
    out = []
    for r, g, b, a in px:
        if a < 128 or (r, g, b) == MAGENTA:
            out.append(-1)
            continue
        hit = lut.get((r, g, b))
        if hit is None:  # stray -> nearest entry
            hit = min(range(256), key=lambda i: (r - pal[i][0]) ** 2 +
                      (g - pal[i][1]) ** 2 + (b - pal[i][2]) ** 2)
        out.append(hit)
    return out


def convert(path, pal, lut, keep_png):
    im = Image.open(path).convert("RGBA")
    want = quantize(im, pal, lut)
    rgb = Image.new("RGB", im.size)
    rgb.putdata([MAGENTA if a < 128 else (r, g, b)
                 for r, g, b, a in im.getdata()])
    out = path[:-4] + ".bmp"
    rgb.save(out, "BMP")
    got = quantize(Image.open(out), pal, lut)
    if got != want:
        os.remove(out)
        raise SystemExit(f"{path}: BMP does not quantize to the same indices")
    if not keep_png:
        os.remove(path)
    return out


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    keep_png = "--keep-png" in sys.argv
    repo = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    roots = args or [os.path.join(repo, "data_extracted"),
                     os.path.join(repo, "docs/atlas")]
    pal, lut = load_palette(repo)
    n = 0
    for root in roots:
        for dp, _, fns in os.walk(root):
            for fn in sorted(fns):
                if fn.endswith(".png"):
                    convert(os.path.join(dp, fn), pal, lut, keep_png)
                    n += 1
    print(f"png_to_bmp: converted + verified {n} files")


if __name__ == "__main__":
    main()
