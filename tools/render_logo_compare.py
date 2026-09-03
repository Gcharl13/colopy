#!/usr/bin/env python3
"""render_logo_compare.py — Part E oracle: the MicroProse boot logo
(OPENING.EXE _do_logo @0x1700: MPSLOGO frame (tick-1) mod 16 at (86,22)
over MPSNAME frame min(tick-92, 28) at its own anchor from tick 92) at a
pacer TICK, drawn by the C (smoke --renderlogo) and the JS (sim_trace
renderlogo), diffed pixel-by-pixel over 320x200 under the shared
palette-model rule.

Usage: python3 tools/render_logo_compare.py [tick]
"""
import subprocess
import sys

from render_common import (ROOT, SCRATCH, c_frame, diff_frames, js_frame,
                           master_palette, sheet_palette, verdict)


def main():
    tick = int(sys.argv[1]) if len(sys.argv) > 1 else 1

    js_args = [sys.executable, ROOT / "tools/sim_trace.py", "renderlogo",
               str(tick)]
    url = subprocess.run(js_args, capture_output=True, text=True,
                         check=True).stdout.strip()
    js = js_frame(url)

    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    out = SCRATCH / f"logo_{tick}.ppm"
    c_args = ["./smoke", "--renderlogo", str(ROOT / "cport/pak/COLOPY.PAK"),
              str(out), str(tick)]
    subprocess.run(c_args, cwd=ROOT / "cport/host", check=True,
                   capture_output=True)
    cim, idx = c_frame(out)

    accept = [master_palette()]
    for nm in ("MPSLOGO.SS", "MPSNAME.SS"):
        p = sheet_palette(nm)
        if p:
            accept.append(p)

    structural, accepted, first = diff_frames(js, cim, idx, accept)
    print("logo %d: %d structural, %d palette-model accepted"
          % (tick, structural, accepted))
    if first:
        print("first structural diff at (%d,%d): JS %s C %s idx %d" % first)
        js.save(SCRATCH / f"logo_{tick}_js.png")
        cim.crop((0, 0, 320, 200)).save(SCRATCH / f"logo_{tick}_c.png")
    sys.exit(verdict("logo %d" % tick, structural, accepted))


if __name__ == "__main__":
    main()
