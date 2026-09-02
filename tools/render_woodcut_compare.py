#!/usr/bin/env python3
"""render_woodcut_compare.py — Phase-7 woodcut oracle: the C plate
(smoke --renderwoodcut) vs the JS canvas (sim_trace renderwoodcut),
same fixture/pinned state, pixel-by-pixel over 320x200 with the shared
palette-model acceptance rule and its frozen ceiling (render_common).

Usage: python3 tools/render_woodcut_compare.py [save] [N]
"""
import subprocess
import sys

from render_common import (ROOT, SCRATCH, c_frame, diff_frames, js_frame,
                           master_palette, sheet_palette, verdict)


def main():
    save = sys.argv[1] if len(sys.argv) > 1 else "sav1653"
    fk = sys.argv[2] if len(sys.argv) > 2 else "1"

    js_args = [sys.executable, ROOT / "tools/sim_trace.py", "renderwoodcut",
               save, fk]
    url = subprocess.run(js_args, capture_output=True, text=True,
                         check=True).stdout.strip()
    js = js_frame(url)

    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    out = SCRATCH / f"wc_{save}_{fk}.ppm"
    c_args = ["./smoke", "--renderwoodcut", save,
              str(ROOT / "cport/pak/COLOPY.PAK"), str(out), fk]
    subprocess.run(c_args, cwd=ROOT / "cport/host", check=True,
                   capture_output=True)
    cim, idx = c_frame(out)

    # the atlas-vs-DAC model: the JS bakes each sheet's art in its OWN
    # palette; the single-DAC C resolves everything through WOODFRAM's.
    # A pixel is accepted when the C index resolves to the JS RGB through
    # ANY palette a sheet on this screen authored (structure stays bound
    # to the index plane).  The plate is the largest acceptance of all
    # seven oracles -- which is exactly why its ceiling is frozen.
    accept = [master_palette()]
    for nm in ("WOODFRAM.SS", "WDCUT%02d.SS" % int(fk), "NAMEPLAT.SS"):
        p = sheet_palette(nm)
        if p:
            accept.append(p)

    structural, accepted, first = diff_frames(js, cim, idx, accept)
    print("woodcut %s %s: %d structural, %d palette-model accepted"
          % (save, fk, structural, accepted))
    if first:
        print("first structural diff at (%d,%d): JS %s C %s idx %d" % first)
        js.save(SCRATCH / f"wc_{save}_{fk}_js.png")
        cim.crop((0, 0, 320, 200)).save(SCRATCH / f"wc_{save}_{fk}_c.png")
    sys.exit(verdict("woodcut %s %s" % (save, fk), structural, accepted))


if __name__ == "__main__":
    main()
