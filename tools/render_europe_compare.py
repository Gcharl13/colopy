#!/usr/bin/env python3
"""render_europe_compare.py — Phase-7 Europe-screen oracle: the C Europe
screen (smoke --rendereurope) vs the JS canvas (sim_trace rendereurope),
same fixture/pinned state, pixel-by-pixel over 320x200 with the shared
palette-model acceptance rule and its frozen ceiling (render_common).

Usage: python3 tools/render_europe_compare.py [save] [ship] [docksel] [row] [marketsel]
"""
import subprocess
import sys

from render_common import (ROOT, SCRATCH, c_frame, diff_frames, js_frame,
                           master_palette, verdict)


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
    js = js_frame(url)

    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    out = SCRATCH / f"eur_{save}.ppm"
    c_args = ["./smoke", "--rendereurope", save,
              str(ROOT / "cport/pak/COLOPY.PAK"), str(out), str(ship),
              str(docksel), str(row), str(marketsel)]
    subprocess.run(c_args, cwd=ROOT / "cport/host", check=True,
                   capture_output=True)
    cim, idx = c_frame(out)

    structural, accepted, first = diff_frames(js, cim, idx, [master_palette()])
    print("europe %s ship %d: %d structural, %d palette-model accepted"
          % (save, ship, structural, accepted))
    if first:
        print("first structural diff at (%d,%d): JS %s C %s idx %d" % first)
        js.save(SCRATCH / f"eur_{save}_js.png")
        cim.crop((0, 0, 320, 200)).save(SCRATCH / f"eur_{save}_c.png")
    scene = "europe %s %d %d %d %d" % (save, ship, docksel, row, marketsel)
    sys.exit(verdict(scene, structural, accepted))


if __name__ == "__main__":
    main()
