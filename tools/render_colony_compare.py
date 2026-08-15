#!/usr/bin/env python3
"""render_colony_compare.py — Phase-7 colony-screen oracle: the C colony
screen (smoke --rendercolony) vs the JS canvas (sim_trace rendercolony),
same fixture/colony/pinned seed, pixel-by-pixel over 320x200 with
the same master-palette acceptance rule as the map compare.

Usage: python3 tools/render_colony_compare.py [save] [ci] [csel] [shipsel] [view] [numbers]
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
    ci = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    csel = int(sys.argv[3]) if len(sys.argv) > 3 else -1
    shipsel = int(sys.argv[4]) if len(sys.argv) > 4 else 0
    view = int(sys.argv[5]) if len(sys.argv) > 5 else 0
    numbers = int(sys.argv[6]) if len(sys.argv) > 6 else 1

    js_args = [sys.executable, ROOT / "tools/sim_trace.py", "rendercolony",
               save, str(ci), str(csel), str(shipsel), str(view),
               str(numbers)]
    url = subprocess.run(js_args, capture_output=True, text=True,
                         check=True).stdout.strip()
    js = Image.open(io.BytesIO(base64.b64decode(url.split(",", 1)[1])))
    js = js.convert("RGB")

    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    out = SCRATCH / f"col_{save}_{ci}.ppm"
    c_args = ["./smoke", "--rendercolony", save,
              str(ROOT / "cport/pak/COLOPY.PAK"), str(out), str(ci),
              str(csel), str(shipsel), str(view), str(numbers)]
    subprocess.run(c_args, cwd=ROOT / "cport/host", check=True,
                   capture_output=True)
    cim = Image.open(out).convert("RGB")
    raw = (SCRATCH / f"col_{save}_{ci}.ppm.idx").read_bytes()
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
    print("colony %s #%d view %d: %d structural, %d palette-model accepted"
          % (save, ci, view, structural, accepted))
    if first:
        print("first structural diff at (%d,%d): JS %s C %s idx %d" % first)
        js.save(SCRATCH / f"col_{save}_{ci}_js.png")
        cim.crop((0, 0, W, H)).save(SCRATCH / f"col_{save}_{ci}_c.png")
    sys.exit(1 if structural else 0)


if __name__ == "__main__":
    main()
