#!/usr/bin/env python3
"""render_map_compare.py — Phase-7 cluster-B oracle: the C map screen
(smoke --rendermap) vs the JS port's own canvas (sim_trace rendermap),
same fixture, same pinned view/seed, pixel-by-pixel over 320x200.

The JS resolves sprites through pre-baked per-sheet atlas palettes while
the C fb is single-palette (the DOS DAC model).  A mismatching pixel is
therefore ACCEPTED when the C index resolved through the MASTER palette
(or the sheet-side greys' own values) equals the JS pixel — the known
palette-model deltas (greys 16/24/32/40, 206, 255).  Anything else is a
STRUCTURAL diff and fails the run.

Usage: python3 tools/render_map_compare.py [save] [vx vy] [sel]
"""
import base64
import io
import subprocess
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SCRATCH = ROOT / "cport" / "pak"


def main():
    save = sys.argv[1] if len(sys.argv) > 1 else "sav1653"
    vx = int(sys.argv[2]) if len(sys.argv) > 2 else 20
    vy = int(sys.argv[3]) if len(sys.argv) > 3 else 30
    sel = int(sys.argv[4]) if len(sys.argv) > 4 else 0
    menu = int(sys.argv[5]) if len(sys.argv) > 5 else -1
    msel = int(sys.argv[6]) if len(sys.argv) > 6 else 0

    # JS side
    url = subprocess.run(
        [sys.executable, ROOT / "tools/sim_trace.py", "rendermap", save,
         str(vx), str(vy), str(sel), str(menu), str(msel)],
        capture_output=True, text=True, check=True).stdout.strip()
    js = Image.open(io.BytesIO(base64.b64decode(url.split(",", 1)[1])))
    js = js.convert("RGB")

    # C side
    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    out = SCRATCH / f"map_{save}.ppm"
    subprocess.run(["./smoke", "--rendermap", save,
                    str(ROOT / "cport/pak/COLOPY.PAK"), str(out),
                    str(vx), str(vy), str(sel), str(menu), str(msel)],
                   cwd=ROOT / "cport/host", check=True, capture_output=True)
    cim = Image.open(out).convert("RGB")
    raw = (SCRATCH / f"map_{save}.ppm.idx").read_bytes()
    idx, cpal = raw[:320 * 240], raw[320 * 240:]

    # the master palette, for the sprite-side acceptance
    pal6 = (ROOT / "raw/COLONIZE/VICEROY.PAL").read_bytes()[:768]
    master = bytes(((v << 2) | (v >> 4)) & 0xFF for v in pal6)

    W, H = 320, 200
    jp, cp = js.load(), cim.load()
    structural = accepted = 0
    first = None
    for y in range(H):
        for x in range(W):
            if jp[x, y] == cp[x, y]:
                continue
            i = idx[y * 320 + x]
            m = tuple(master[i * 3:i * 3 + 3])
            if jp[x, y] == m:
                accepted += 1        # atlas resolved via master palette
                continue
            structural += 1
            if first is None:
                first = (x, y, jp[x, y], cp[x, y], i)
    print("map render %s view(%d,%d) menu %d: %d structural, %d "
          "palette-model accepted, %d px total"
          % (save, vx, vy, menu, structural, accepted, W * H))
    if first:
        print("first structural diff at (%d,%d): JS %s C %s idx %d"
              % first)
        # save a visual diff for the debug loop
        d = Image.new("RGB", (W, H))
        dp = d.load()
        for y in range(H):
            for x in range(W):
                dp[x, y] = (255, 0, 255) if (jp[x, y] != cp[x, y] and
                                             jp[x, y] != tuple(
                    master[idx[y * 320 + x] * 3: idx[y * 320 + x] * 3 + 3]))\
                    else cp[x, y]
        d.save(SCRATCH / f"map_{save}_diff.png")
        js.save(SCRATCH / f"map_{save}_js.png")
        cim.crop((0, 0, W, H)).save(SCRATCH / f"map_{save}_c.png")
    sys.exit(1 if structural else 0)


if __name__ == "__main__":
    main()
