#!/usr/bin/env python3
"""render_congress_compare.py — Part E oracle: the Continental Congress
portrait page (func_03BB4A @0x03BB4A: CCBKGD.PIK + the owned CC-NN.SS
portraits at their sheet-baked anchors, func_03BAA6 @0x03BAA6) drawn by
the C (smoke --rendercongress) and the JS (sim_trace rendercongress) over
the same fixture with the owned set PINNED from a 25-bit mask, diffed
pixel-by-pixel over 320x200 under the shared palette-model rule.

Usage: python3 tools/render_congress_compare.py [save] [mask]
  mask defaults to 0x1FFFFFF = every portrait (the densest page).
"""
import subprocess
import sys

from render_common import (ROOT, SCRATCH, c_frame, diff_frames, js_frame,
                           master_palette, pik_palette, sheet_palette,
                           verdict)


def main():
    save = sys.argv[1] if len(sys.argv) > 1 else "sav1653"
    mask = int(sys.argv[2], 0) if len(sys.argv) > 2 else 0x1FFFFFF

    js_args = [sys.executable, ROOT / "tools/sim_trace.py", "rendercongress",
               save, str(mask)]
    url = subprocess.run(js_args, capture_output=True, text=True,
                         check=True).stdout.strip()
    js = js_frame(url)

    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    out = SCRATCH / f"cc_{save}_{mask}.ppm"
    c_args = ["./smoke", "--rendercongress", save,
              str(ROOT / "cport/pak/COLOPY.PAK"), str(out), str(mask)]
    subprocess.run(c_args, cwd=ROOT / "cport/host", check=True,
                   capture_output=True)
    cim, idx = c_frame(out)

    accept = [master_palette()]
    p = pik_palette("CCBKGD.PIK")
    if p:
        accept.append(p)
    for i in range(25):
        if (mask >> i) & 1:
            p = sheet_palette("CC-%02d.SS" % i)
            if p:
                accept.append(p)

    structural, accepted, first = diff_frames(js, cim, idx, accept)
    print("congress %s %d: %d structural, %d palette-model accepted"
          % (save, mask, structural, accepted))
    if first:
        print("first structural diff at (%d,%d): JS %s C %s idx %d" % first)
        js.save(SCRATCH / f"cc_{save}_{mask}_js.png")
        cim.crop((0, 0, 320, 200)).save(SCRATCH / f"cc_{save}_{mask}_c.png")
    sys.exit(verdict("congress %s %d" % (save, mask), structural, accepted))


if __name__ == "__main__":
    main()
