#!/usr/bin/env python3
"""render_colony_compare.py — Phase-7 colony-screen oracle: the C colony
screen (smoke --rendercolony) vs the JS canvas (sim_trace rendercolony),
same fixture/colony/pinned seed, pixel-by-pixel over 320x200 with the
shared palette-model acceptance rule and its frozen ceiling (render_common).

Usage: python3 tools/render_colony_compare.py [save] [ci] [csel] [shipsel] [view] [numbers]
"""
import subprocess
import sys

from render_common import (ROOT, SCRATCH, c_frame, diff_frames, js_frame,
                           master_palette, verdict)


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
    js = js_frame(url)

    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    out = SCRATCH / f"col_{save}_{ci}.ppm"
    c_args = ["./smoke", "--rendercolony", save,
              str(ROOT / "cport/pak/COLOPY.PAK"), str(out), str(ci),
              str(csel), str(shipsel), str(view), str(numbers)]
    subprocess.run(c_args, cwd=ROOT / "cport/host", check=True,
                   capture_output=True)
    cim, idx = c_frame(out)

    structural, accepted, first = diff_frames(js, cim, idx, [master_palette()])
    print("colony %s #%d view %d: %d structural, %d palette-model accepted"
          % (save, ci, view, structural, accepted))
    if first:
        print("first structural diff at (%d,%d): JS %s C %s idx %d" % first)
        js.save(SCRATCH / f"col_{save}_{ci}_js.png")
        cim.crop((0, 0, 320, 200)).save(SCRATCH / f"col_{save}_{ci}_c.png")
    scene = "colony %s %d %d %d %d %d" % (save, ci, csel, shipsel, view,
                                          numbers)
    sys.exit(verdict(scene, structural, accepted))


if __name__ == "__main__":
    main()
