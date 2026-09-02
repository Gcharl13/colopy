#!/usr/bin/env python3
"""render_map_compare.py — Phase-7 cluster-B oracle: the C map screen
(smoke --rendermap) vs the JS port's own canvas (sim_trace rendermap),
same fixture, same pinned view/seed, pixel-by-pixel over 320x200.

The JS resolves sprites through pre-baked per-sheet atlas palettes while
the C fb is single-palette (the DOS DAC model).  A mismatching pixel is
therefore ACCEPTED when the C index resolved through the MASTER palette
equals the JS pixel — the known palette-model deltas (greys 16/24/32/40,
206, 255).  Anything else is a STRUCTURAL diff and fails the run; and the
accepted count itself is bounded by render_common.PALETTE_CEILING, since
"same index, different RGB" is also what a wrong runtime palette produces.

Usage: python3 tools/render_map_compare.py [save] [vx vy] [sel] [menu] [msel]
"""
import subprocess
import sys

from render_common import (ROOT, SCRATCH, c_frame, diff_frames, diff_image,
                           js_frame, master_palette, verdict)


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
    js = js_frame(url)

    # C side
    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    out = SCRATCH / f"map_{save}.ppm"
    subprocess.run(["./smoke", "--rendermap", save,
                    str(ROOT / "cport/pak/COLOPY.PAK"), str(out),
                    str(vx), str(vy), str(sel), str(menu), str(msel)],
                   cwd=ROOT / "cport/host", check=True, capture_output=True)
    cim, idx = c_frame(out)

    accept = [master_palette()]
    structural, accepted, first = diff_frames(js, cim, idx, accept)
    print("map render %s view(%d,%d) menu %d: %d structural, %d "
          "palette-model accepted, %d px total"
          % (save, vx, vy, menu, structural, accepted, 320 * 200))
    if first:
        print("first structural diff at (%d,%d): JS %s C %s idx %d"
              % first)
        # save a visual diff for the debug loop
        diff_image(js, cim, idx, accept).save(SCRATCH / f"map_{save}_diff.png")
        js.save(SCRATCH / f"map_{save}_js.png")
        cim.crop((0, 0, 320, 200)).save(SCRATCH / f"map_{save}_c.png")
    scene = "map %s %d %d %d %d %d" % (save, vx, vy, sel, menu, msel)
    sys.exit(verdict(scene, structural, accepted))


if __name__ == "__main__":
    main()
