#!/usr/bin/env python3
"""extract_cc_portraits.py -- crop the 25 Founding-Father portraits out of the CC-NN atlas sheets.

The committed docs/atlas/sprites/atlas_CC-NN.bmp files are debug contact-sheets: frame 0 (the
portrait, CC-00..CC-24 = @FATHERS order per spec/ui/continental_congress.md §3) sits at the top-left,
followed by a wide black legend strip with annotation text. This tool auto-detects the portrait
cell width (the first run of near-empty columns after the figure) and crops [0,0,width,H] into a
clean per-father 24-bit BMP under data_extracted/sprites/fathers/CC-NN.bmp, plus a manifest with each
portrait's size. (The original .SS frames aren't in the repo, so these atlas crops are the source;
a small baked frame-index label may remain over the figure -- an artifact of the debug render.)

Run: python3 tools/extract_cc_portraits.py   (needs Pillow; the atlas sheets are committed)
"""
import json, os
from PIL import Image
from bmp_io import open_image, open_rgba, save_bmp

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
            if a and r > 165 and g > 150 and b < 95:
                px[x, y] = (0, 0, 0, 0)   # transparent (the black bg is already keyed out)
    return crop


def key_out_background(crop):
    """The atlas draws each figure on a solid black cell. Flood-fill the near-black region reachable
    from the border and make it transparent, so the figures can overlap as a crowd. Interior black
    (coats, hats) is enclosed by the figure, so it is never reached from the border and stays opaque."""
    from collections import deque
    px = crop.load()
    W, H = crop.size
    seen = [[False] * W for _ in range(H)]
    dq = deque()
    def blackish(x, y):
        r, g, b, a = px[x, y]
        return a != 0 and (r + g + b) <= 42
    for x in range(W):
        for y in (0, H - 1):
            if not seen[y][x] and blackish(x, y): seen[y][x] = True; dq.append((x, y))
    for y in range(H):
        for x in (0, W - 1):
            if not seen[y][x] and blackish(x, y): seen[y][x] = True; dq.append((x, y))
    while dq:
        x, y = dq.popleft()
        px[x, y] = (0, 0, 0, 0)
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < W and 0 <= ny < H and not seen[ny][nx] and blackish(nx, ny):
                seen[ny][nx] = True; dq.append((nx, ny))
    return crop


def drop_small_islands(crop, min_area=34):
    """After the background is keyed out, the atlas's title glyphs ("CC-NN.SS (1 sprites)") float above
    the figure as tiny opaque islands. Remove every opaque component smaller than min_area, keeping the
    figure and any real prop (staff/book/dog, which are larger). Connected-components over the alpha."""
    from collections import deque
    px = crop.load()
    W, H = crop.size
    seen = [[False] * W for _ in range(H)]
    for sy in range(H):
        for sx in range(W):
            if seen[sy][sx] or px[sx, sy][3] == 0:
                continue
            comp = []
            dq = deque([(sx, sy)]); seen[sy][sx] = True
            while dq:
                x, y = dq.popleft(); comp.append((x, y))
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < W and 0 <= ny < H and not seen[ny][nx] and px[nx, ny][3] != 0:
                        seen[ny][nx] = True; dq.append((nx, ny))
            if len(comp) < min_area:
                for (x, y) in comp:
                    px[x, y] = (0, 0, 0, 0)
    return crop


def inpaint_index_label(crop):
    """The atlas also stamps a small "N/0xNN" frame-index label (light grey/blue) over the figure's
    lower-left torso. Paint those light label pixels over with clothing sampled a little below, so the
    watermark disappears without leaving a transparent hole. Confined to the label zone."""
    px = crop.load()
    W, H = crop.size
    def label_px(r, g, b, a):
        if a == 0: return False
        grayish = min(r, g, b) > 150 and max(r, g, b) - min(r, g, b) < 40
        bluish  = b > 150 and b - r > 26 and g > 118
        return grayish or bluish
    targ = [(x, y) for y in range(26, 54) for x in range(0, min(48, W)) if label_px(*px[x, y])]
    for (x, y) in targ:
        for dy in (20, 22, 24, 18, 26, -18, -20):
            ny = y + dy
            if 0 <= ny < H:
                r, g, b, a = px[x, ny]
                if a != 0 and not label_px(r, g, b, a):
                    px[x, y] = (r, g, b, a); break
    return crop


def main():
    os.makedirs(OUT, exist_ok=True)
    manifest = []
    for i in range(25):
        src = os.path.join(SRC, f"atlas_CC-{i:02d}.bmp")
        im = open_rgba(src)
        w = portrait_width(im)
        crop = im.crop((0, 0, w, im.height))
        strip_title_text(crop)          # strong-yellow title band -> transparent
        key_out_background(crop)         # black cell background -> transparent (flood fill)
        drop_small_islands(crop)         # floating title-glyph remnants -> gone
        inpaint_index_label(crop)        # the "N/0xNN" watermark -> painted over
        fn = f"CC-{i:02d}.bmp"
        save_bmp(crop, os.path.join(OUT, fn))
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
