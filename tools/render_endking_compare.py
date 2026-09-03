#!/usr/bin/env python3
"""render_endking_compare.py — Part E oracle: the King's audience at the
war's end (func_075352 @0x075352: KINGLSS<N>.PIK + the <NATION><N> banner
+ KINGLOSE.SS (victory) or KINGWIN.SS (defeat) at their sheet-baked
anchors, then @KINGLOSE / @KINGWIN in FONTKING laid out by the key's own
@width/@x/@y) drawn by the C (smoke --renderendking) and the JS
(sim_trace renderendking) over the same fixture, diffed pixel-by-pixel
over 320x200 under the shared palette-model rule.

Usage: python3 tools/render_endking_compare.py [save] [win]
  win 1 = victory (the default), 0 = defeat.
"""
import subprocess
import sys

from render_common import (ROOT, SCRATCH, c_frame, diff_frames, js_frame,
                           master_palette, pik_palette, sheet_palette,
                           verdict)


def main():
    save = sys.argv[1] if len(sys.argv) > 1 else "sav1653"
    win = int(sys.argv[2]) if len(sys.argv) > 2 else 1

    js_args = [sys.executable, ROOT / "tools/sim_trace.py", "renderendking",
               save, str(win)]
    url = subprocess.run(js_args, capture_output=True, text=True,
                         check=True).stdout.strip()
    js = js_frame(url)

    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    out = SCRATCH / f"endking_{save}_{win}.ppm"
    c_args = ["./smoke", "--renderendking", save,
              str(ROOT / "cport/pak/COLOPY.PAK"), str(out), str(win)]
    subprocess.run(c_args, cwd=ROOT / "cport/host", check=True,
                   capture_output=True)
    cim, idx = c_frame(out)

    accept = [master_palette()]
    for nm in ("KINGLSS1.PIK", "KINGLSS2.PIK"):
        p = pik_palette(nm)
        if p:
            accept.append(p)
    for nm in ("KINGLOSE.SS", "KINGWIN.SS", "ENGLND1.SS", "FRANCE1.SS",
               "SPAIN1.SS", "DUTCH1.SS", "ENGLND2.SS", "FRANCE2.SS",
               "SPAIN2.SS", "DUTCH2.SS"):
        p = sheet_palette(nm)
        if p:
            accept.append(p)

    structural, accepted, first = diff_frames(js, cim, idx, accept)
    print("endking %s %d: %d structural, %d palette-model accepted"
          % (save, win, structural, accepted))
    if first:
        print("first structural diff at (%d,%d): JS %s C %s idx %d" % first)
        js.save(SCRATCH / f"endking_{save}_{win}_js.png")
        cim.crop((0, 0, 320, 200)).save(SCRATCH / f"endking_{save}_{win}_c.png")
    sys.exit(verdict("endking %s %d" % (save, win), structural, accepted))


if __name__ == "__main__":
    main()
