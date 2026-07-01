#!/usr/bin/env python3
"""extract_cc_portraits.py -- crop the 25 Founding-Father portraits out of the CC-NN atlas sheets.

The committed docs/atlas/sprites/atlas_CC-NN.png files are debug contact-sheets: frame 0 (the
portrait, CC-00..CC-24 = @FATHERS order per spec/ui/continental_congress.md §3) sits at the top-left,
followed by a wide black legend strip with annotation text. This tool auto-detects the portrait
cell width (the first run of near-empty columns after the figure) and crops [0,0,width,H] into a
clean per-father PNG under data_extracted/sprites/fathers/CC-NN.png, plus a manifest with each
portrait's size. (The original .SS frames aren't in the repo, so these atlas crops are the source;
a small baked frame-index label may remain over the figure -- an artifact of the debug render.)

Run: python3 tools/extract_cc_portraits.py   (needs Pillow; the atlas sheets are committed)
"""
import json, os
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "docs", "atlas", "sprites")
OUT = os.path.join(ROOT, "data_extracted", "sprites", "fathers")


def portrait_width(im):
    """Width of the portrait cell = up to the atlas's cell-boundary line (an isolated full-height
    column drawn between the sprite and the yellow legend strip), with trailing empty columns
    trimmed. Falls back to the first run of >=4 near-empty columns. Mass is measured on RGB only
    (the sheet is opaque, so an alpha channel would read every pixel as content)."""
    rgb = im.convert("RGB")
    W, H = rgb.size
    px = rgb.load()
    m = [sum(1 for y in range(H) if sum(px[x, y]) > 40) for x in range(min(200, W))]
    boundary = None
    for x in range(26, len(m) - 1):                       # isolated tall line, empty on both sides
        if m[x] >= 40 and m[x - 1] <= 6 and m[x + 1] <= 6:
            boundary = x
            break
    if boundary is None:                                  # fallback: first 4-wide near-empty gap
        run = 0
        for x in range(26, len(m)):
            run = run + 1 if m[x] <= 2 else 0
            if run >= 4:
                boundary = x - 3
                break
    end = boundary if boundary else min(60, W)
    while end > 1 and m[end - 1] <= 2:                     # trim trailing empty columns
        end -= 1
    return end


def strip_title_text(crop):
    """The atlas draws a yellow per-sheet title ("CC-NN.SS (1 sprites) ...") across the top rows;
    where the portrait sits lower it bleeds into the crop. Blank the pure-yellow title glyphs in the
    top band to black. Only the top 12 rows and only strong yellow (portrait hair/hats aren't pure
    yellow up there), so gold uniform trim lower down is untouched."""
    px = crop.load()
    W, H = crop.size
    for y in range(min(18, H)):          # the "CC-NN.SS (1 sprites)" title band sits at y~9..17
        for x in range(W):
            r, g, b, a = px[x, y]
            if r > 165 and g > 150 and b < 95:
                px[x, y] = (0, 0, 0, 255)
    return crop


def main():
    os.makedirs(OUT, exist_ok=True)
    manifest = []
    for i in range(25):
        src = os.path.join(SRC, f"atlas_CC-{i:02d}.png")
        im = Image.open(src).convert("RGBA")
        w = portrait_width(im)
        crop = strip_title_text(im.crop((0, 0, w, im.height)))
        fn = f"CC-{i:02d}.png"
        crop.save(os.path.join(OUT, fn))
        manifest.append({"id": i, "file": f"data_extracted/sprites/fathers/{fn}",
                         "w": w, "h": im.height})
    json.dump({"_note": "founding-father portraits cropped from the CC-NN atlas sheets "
                        "(tools/extract_cc_portraits.py); index = @FATHERS order.",
               "count": len(manifest), "portraits": manifest},
              open(os.path.join(OUT, "manifest.json"), "w"), indent=1)
    print(f"cropped {len(manifest)} portraits -> {OUT}")
    print("widths:", ", ".join(f"{m['id']}:{m['w']}" for m in manifest))


if __name__ == "__main__":
    main()
