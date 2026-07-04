"""bmp_io.py -- shared 24-bit BMP image I/O for the asset tools.

Every image asset in the project is a 24-bit BMP (BI_RGB); transparency is
the pure-magenta colorkey (255,0,255), which is not a VICEROY.PAL color and
is never used opaquely by any asset (verified repo-wide 2026-07-04). The
runtime (native_assets.cpp read_png_quantized) maps that key to the
transparent index; a .png with the same stem is accepted as a fallback so
older folders keep loading. Tools import this module to write assets and to
open either extension.
"""
import os

from PIL import Image

MAGENTA = (255, 0, 255)


def open_image(path):
    """Open `path`, or its .bmp/.png sibling when the extension moved."""
    stem, ext = os.path.splitext(path)
    for cand in ([path, stem + ".bmp"] if ext == ".png" else
                 [path, stem + ".png"] if ext == ".bmp" else [path]):
        if os.path.exists(cand):
            return Image.open(cand)
    return Image.open(path)  # raise the natural FileNotFoundError


def open_rgba(path):
    """Open as RGBA with the magenta colorkey decoded back to alpha 0."""
    img = open_image(path).convert("RGBA")
    img.putdata([(r, g, b, 0) if (r, g, b) == MAGENTA else (r, g, b, a)
                 for r, g, b, a in img.getdata()])
    return img


def save_bmp(img, path):
    """Save `img` as a 24-bit BMP; alpha < 128 becomes the magenta colorkey.

    A .png path is rewritten to .bmp. Returns the path actually written.
    """
    stem, ext = os.path.splitext(path)
    out = stem + ".bmp"
    if img.mode == "RGBA":
        rgb = Image.new("RGB", img.size)
        rgb.putdata([MAGENTA if a < 128 else (r, g, b)
                     for r, g, b, a in img.getdata()])
        img = rgb
    elif img.mode != "RGB":
        img = img.convert("RGB")
    img.save(out, "BMP")
    return out
