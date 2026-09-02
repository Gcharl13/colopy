#!/usr/bin/env python3
"""render_report_compare.py — Phase-7 report oracle: the C F2..F10
report (smoke --renderreport) vs the JS canvas (sim_trace renderreport),
same fixture/pinned state, pixel-by-pixel over 320x200 with the shared
palette-model acceptance rule and its frozen ceiling (render_common).

Usage: python3 tools/render_report_compare.py [save] [FK]
"""
import subprocess
import sys

from render_common import (ROOT, SCRATCH, c_frame, diff_frames, js_frame,
                           master_palette, verdict)


def main():
    save = sys.argv[1] if len(sys.argv) > 1 else "sav1653"
    fk = sys.argv[2] if len(sys.argv) > 2 else "F5"

    js_args = [sys.executable, ROOT / "tools/sim_trace.py", "renderreport",
               save, fk]
    url = subprocess.run(js_args, capture_output=True, text=True,
                         check=True).stdout.strip()
    js = js_frame(url)

    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    out = SCRATCH / f"rep_{save}_{fk}.ppm"
    c_args = ["./smoke", "--renderreport", save,
              str(ROOT / "cport/pak/COLOPY.PAK"), str(out), fk]
    subprocess.run(c_args, cwd=ROOT / "cport/host", check=True,
                   capture_output=True)
    cim, idx = c_frame(out)

    structural, accepted, first = diff_frames(js, cim, idx, [master_palette()])
    print("report %s %s: %d structural, %d palette-model accepted"
          % (save, fk, structural, accepted))
    if first:
        print("first structural diff at (%d,%d): JS %s C %s idx %d" % first)
        js.save(SCRATCH / f"rep_{save}_{fk}_js.png")
        cim.crop((0, 0, 320, 200)).save(SCRATCH / f"rep_{save}_{fk}_c.png")
    sys.exit(verdict("report %s %s" % (save, fk), structural, accepted))


if __name__ == "__main__":
    main()
