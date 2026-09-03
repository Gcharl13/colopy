#!/usr/bin/env python3
"""render_score_compare.py — Part E oracle: the end-game score plate
(func_03A9C0 @0x03A9C0: WOODPAN2.PIK through the SCORE<panel+1> palette,
the three @EXPLOITS lines, the @SCORE ladder rows 0..panel with the
achieved row highlighted, the joke caption with the signer's surname,
and the plate at its sheet-baked anchor) drawn by the C (smoke
--renderscore) and the JS (sim_trace renderscore) over the same fixture
with the BAND and the NAME pinned, diffed pixel-by-pixel over 320x200
under the shared palette-model rule.

Usage: python3 tools/render_score_compare.py [save] [panel] [name]
  panel 0 = SCORE01 (the one 140x97 plate), 23 = SCORE24 (all 24 rows).
"""
import subprocess
import sys

from render_common import (ROOT, SCRATCH, c_frame, diff_frames, js_frame,
                           master_palette, pik_palette, sheet_palette,
                           verdict)


def main():
    save = sys.argv[1] if len(sys.argv) > 1 else "sav1653"
    panel = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    name = sys.argv[3] if len(sys.argv) > 3 else "Willem van Oranje"

    js_args = [sys.executable, ROOT / "tools/sim_trace.py", "renderscore",
               save, str(panel), name]
    url = subprocess.run(js_args, capture_output=True, text=True,
                         check=True).stdout.strip()
    js = js_frame(url)

    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    out = SCRATCH / f"score_{save}_{panel}.ppm"
    c_args = ["./smoke", "--renderscore", save,
              str(ROOT / "cport/pak/COLOPY.PAK"), str(out), str(panel), name]
    subprocess.run(c_args, cwd=ROOT / "cport/host", check=True,
                   capture_output=True)
    cim, idx = c_frame(out)

    accept = [master_palette()]
    p = sheet_palette("SCORE%02d.SS" % (panel + 1))
    if p:
        accept.append(p)
    p = pik_palette("WOODPAN2.PIK")
    if p:
        accept.append(p)

    structural, accepted, first = diff_frames(js, cim, idx, accept)
    print("score %s %d %r: %d structural, %d palette-model accepted"
          % (save, panel, name, structural, accepted))
    if first:
        print("first structural diff at (%d,%d): JS %s C %s idx %d" % first)
        js.save(SCRATCH / f"score_{save}_{panel}_js.png")
        cim.crop((0, 0, 320, 200)).save(SCRATCH / f"score_{save}_{panel}_c.png")
    sys.exit(verdict("score %s %d %s" % (save, panel, name), structural,
                     accepted))


if __name__ == "__main__":
    main()
