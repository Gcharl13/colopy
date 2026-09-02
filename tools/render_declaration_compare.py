#!/usr/bin/env python3
"""render_declaration_compare.py — Part E oracle: the Declaration signing
page (func_03DA2A @0x03DA2A: DECOIND.PIK + the DEC-UPP/LOW/SQIG stroke
frames of the leader's title-cased name from the pen seed (126,148),
wrapping into the squiggle at x >= 220) drawn by the C (smoke
--renderdeclaration) and the JS (sim_trace renderdeclaration) over the
same fixture with the NAME and the stroke STEP pinned, diffed pixel-by-
pixel over 320x200 under the shared palette-model rule.

Usage: python3 tools/render_declaration_compare.py [save] [name] [step]
  name defaults to "Willem van Oranje 3" (upper, lower, space, and the
  x >= 220 wrap on the 'O'); step 9999 = the finished signature, a small
  step shows the progressive strokes mid-glyph.
"""
import subprocess
import sys

from render_common import (ROOT, SCRATCH, c_frame, diff_frames, js_frame,
                           master_palette, pik_palette, sheet_palette,
                           verdict)


def main():
    save = sys.argv[1] if len(sys.argv) > 1 else "sav1653"
    name = sys.argv[2] if len(sys.argv) > 2 else "Willem van Oranje 3"
    step = int(sys.argv[3]) if len(sys.argv) > 3 else 9999

    js_args = [sys.executable, ROOT / "tools/sim_trace.py",
               "renderdeclaration", save, name, str(step)]
    url = subprocess.run(js_args, capture_output=True, text=True,
                         check=True).stdout.strip()
    js = js_frame(url)

    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    tag = "".join(ch if ch.isalnum() else "_" for ch in name)
    out = SCRATCH / f"dec_{save}_{tag}_{step}.ppm"
    c_args = ["./smoke", "--renderdeclaration", save,
              str(ROOT / "cport/pak/COLOPY.PAK"), str(out), name, str(step)]
    subprocess.run(c_args, cwd=ROOT / "cport/host", check=True,
                   capture_output=True)
    cim, idx = c_frame(out)

    accept = [master_palette()]
    p = pik_palette("DECOIND.PIK")
    if p:
        accept.append(p)
    for ch in set(name.upper()):
        if "A" <= ch <= "Z":
            for pre in ("DEC-UPP", "DEC-LOW"):
                p = sheet_palette(f"{pre}{ch}.SS")
                if p:
                    accept.append(p)
    p = sheet_palette("DEC-SQIG.SS")
    if p:
        accept.append(p)

    structural, accepted, first = diff_frames(js, cim, idx, accept)
    print("declaration %s %r %d: %d structural, %d palette-model accepted"
          % (save, name, step, structural, accepted))
    if first:
        print("first structural diff at (%d,%d): JS %s C %s idx %d" % first)
        js.save(SCRATCH / f"dec_{save}_{tag}_{step}_js.png")
        cim.crop((0, 0, 320, 200)).save(SCRATCH / f"dec_{save}_{tag}_{step}_c.png")
    sys.exit(verdict("declaration %s %s %d" % (save, name, step),
                     structural, accepted))


if __name__ == "__main__":
    main()
