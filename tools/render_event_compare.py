#!/usr/bin/env python3
"""render_event_compare.py — Phase-7 dialog-framework oracle: the C event
popup / ask dialog (smoke --renderevent) vs the JS canvas (sim_trace
renderevent), same fixture/key/subs, pixel-by-pixel over 320x200 with the
shared palette-model acceptance rule and its frozen ceiling (render_common).

Usage: python3 tools/render_event_compare.py KEY [mode] [sel] [speaker] [save]
"""
import subprocess
import sys

from render_common import (ROOT, SCRATCH, c_frame, diff_frames, js_frame,
                           master_palette, verdict)


def main():
    # Default = a REAL @-key.  It was "FOUNTAIN" until 2026-08-17, which
    # is a WOODCUT caption ("THE FOUNTAIN OF YOUTH"), not an event key --
    # so the bare invocation always exited 2 with "unknown event key"
    # and this oracle silently never ran unless given an argument.
    key = sys.argv[1] if len(sys.argv) > 1 else "RAIDSTORES"
    mode = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    sel = int(sys.argv[3]) if len(sys.argv) > 3 else 0
    speaker = sys.argv[4] if len(sys.argv) > 4 else ""
    save = sys.argv[5] if len(sys.argv) > 5 else "sav1653"

    js_args = [sys.executable, ROOT / "tools/sim_trace.py", "renderevent",
               save, key, str(mode), str(sel)]
    if speaker:
        js_args.append(speaker)
    url = subprocess.run(js_args, capture_output=True, text=True,
                         check=True).stdout.strip()
    if url == "NOKEY":
        print("unknown event key:", key)
        sys.exit(2)
    js = js_frame(url)

    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    out = SCRATCH / f"ev_{key}.ppm"
    c_args = ["./smoke", "--renderevent", save,
              str(ROOT / "cport/pak/COLOPY.PAK"), str(out), key,
              str(mode), str(sel)]
    if speaker:
        c_args.append(speaker)
    subprocess.run(c_args, cwd=ROOT / "cport/host", check=True,
                   capture_output=True)
    cim, idx = c_frame(out)

    structural, accepted, first = diff_frames(js, cim, idx, [master_palette()])
    print("event %s mode %d: %d structural, %d palette-model accepted"
          % (key, mode, structural, accepted))
    if first:
        print("first structural diff at (%d,%d): JS %s C %s idx %d" % first)
        js.save(SCRATCH / f"ev_{key}_js.png")
        cim.crop((0, 0, 320, 200)).save(SCRATCH / f"ev_{key}_c.png")
    scene = "event %s %d %d %s %s" % (key, mode, sel, speaker or "-", save)
    sys.exit(verdict(scene, structural, accepted))


if __name__ == "__main__":
    main()
