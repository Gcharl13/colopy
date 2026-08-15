#!/usr/bin/env python3
"""render_europe_compare.py — Phase-7 Europe-screen oracle: the C Europe
screen (smoke --rendereurope) vs the JS canvas (sim_trace rendereurope),
same fixture/pinned state, pixel-by-pixel over 320x200 with the same
master-palette acceptance rule as the map compare.

Usage: python3 tools/render_europe_compare.py [save] [ship] [docksel] [row] [marketsel]
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
    ship = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    docksel = int(sys.argv[3]) if len(sys.argv) > 3 else 0
    row = int(sys.argv[4]) if len(sys.argv) > 4 else 0
    marketsel = int(sys.argv[5]) if len(sys.argv) > 5 else -1

    js_args = [sys.executable, ROOT / "tools/sim_trace.py", "rendereurope",
               save, str(ship), str(docksel), str(row), str(marketsel)]
    url = subprocess.run(js_args, capture_output=True, text=True,
                         check=True).stdout.strip()
    js = Image.open(io.BytesIO(base64.b64decode(url.split(",", 1)[1])))
    js = js.convert("RGB")

    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    out = SCRATCH / f"eur_{save}.ppm"
    c_args = ["./smoke", "--rendereurope", save,
              str(ROOT / "cport/pak/COLOPY.PAK"), str(out), str(ship),
              str(docksel), str(row), str(marketsel)]
    subprocess.run(c_args, cwd=ROOT / "cport/host", check=True,
                   capture_output=True)
    cim = Image.open(out).convert("RGB")
    raw = (SCRATCH / f"eur_{save}.ppm.idx").read_bytes()
    idx = raw[:320 * 240]

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
            if jp[x, y] == tuple(master[i * 3:i * 3 + 3]):
                accepted += 1
                continue
            structural += 1
            if first is None:
                first = (x, y, jp[x, y], cp[x, y], i)
    print("europe %s ship %d: %d structural, %d palette-model accepted"
          % (save, ship, structural, accepted))
    if first:
        print("first structural diff at (%d,%d): JS %s C %s idx %d" % first)
        js.save(SCRATCH / f"eur_{save}_js.png")
        cim.crop((0, 0, W, H)).save(SCRATCH / f"eur_{save}_c.png")
    sys.exit(1 if structural else 0)


if __name__ == "__main__":
    main()
