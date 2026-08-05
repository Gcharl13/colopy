#!/usr/bin/env python3
"""Does the live map capture sit at a non-zero colour-cycle phase?

CYCLE.DAT band 0 = {len 8, start 120, delay 35}. cycle_colors rotates the band
toward HIGHER indices, wrapping the last colour into the first, so after p steps
palette index (120+k) holds the colour authored at (120 + (k-p mod 8)).

Render TERRAIN frame 11 (Sea Lane) under every phase and diff it against the two
clean sea-lane tiles in docs/screens/06_ingame_map.png.
"""
import sys, zipfile, tempfile, os
sys.path.insert(0, "/home/user/colopy/tools")
import ssdec
from PIL import Image

ROOT = "/home/user/colopy"
z = zipfile.ZipFile(f"{ROOT}/col.zip")
pick = lambda name: [n for n in z.namelist()
                     if n.endswith(name) and not n.startswith("__")][0]

master = z.read(pick("VICEROY.PAL"))
PAL = [((v << 2) | (v >> 4)) & 0xFF for v in master[:768]]

with tempfile.NamedTemporaryFile(suffix=".SS", delete=False) as f:
    f.write(z.read(pick("TERRAIN.SS")))
    p = f.name
sheet = ssdec.load_sheet(p)
os.unlink(p)

BAND_START, BAND_LEN, DELAY = 120, 8, 35


def phased(pal, ph):
    """Palette after `ph` rotation steps (colour at j moves to index j+ph)."""
    out = list(pal)
    for k in range(BAND_LEN):
        src = BAND_START + ((k - ph) % BAND_LEN)
        dst = BAND_START + k
        out[dst * 3:dst * 3 + 3] = pal[src * 3:src * 3 + 3]
    return out


# The capture is a clean 2x of the 320x200 logical screen, letterboxed inside a
# 1024x768 frame at (192,184) (measured: the non-black bbox is exactly 640x400).
# The map viewport is (0,8,240,192) at 16px/tile, so tile (tx,ty) starts at
# (OX + 32*tx, OY + 16 + 32*ty).
OX, OY = 192, 184
cap = Image.open(f"{ROOT}/docs/screens/06_ingame_map.png").convert("RGB")
print("capture", cap.size)


def live_tile(tx, ty):
    px = cap.load()
    return [px[OX + 32 * tx + 2 * i, OY + 16 + 32 * ty + 2 * j]
            for j in range(16) for i in range(16)]


hx, hy, w, h, pixels = sheet["frames"][11]
assert (w, h) == (16, 16), (w, h)


def q565(c):
    """DOSBox presents the 320x200 surface as RGB565; the capture is truncated."""
    return (c[0] & 0xF8, c[1] & 0xFC, c[2] & 0xF8)


for tx, ty in ((8, 6), (8, 8)):
    want = [q565(c) for c in live_tile(tx, ty)]
    print(f"\n--- live tile ({tx},{ty}) ---")
    best = []
    for ph in range(BAND_LEN):
        pal = phased(PAL, ph)
        bad = []
        for n, v in enumerate(pixels):
            got = q565((pal[v * 3], pal[v * 3 + 1], pal[v * 3 + 2]))
            if got != want[n]:
                bad.append((n % 16, n // 16, v, got, want[n]))
        best.append((len(bad), ph, bad))
        print(f"  phase {ph}: {len(bad):3d}/256 wrong")
    n, ph, bad = min(best)
    print(f"  BEST phase {ph} -> {n}/256")
    for x, y, v, got, exp in bad:
        print(f"     ({x:2d},{y:2d}) idx {v}: rendered {got} live {exp}")
