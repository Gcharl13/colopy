#!/usr/bin/env python3
"""render_boot_compare.py — Phase-7 boot-screen oracle: the C screen
(smoke --renderboot) vs the JS canvas (sim_trace renderboot),
same fixture/pinned state, pixel-by-pixel over 320x200 with the shared
palette-model acceptance rule and its frozen ceiling (render_common).

Usage: python3 tools/render_boot_compare.py [kind] [arg]
"""
import subprocess
import sys

from render_common import (ROOT, SCRATCH, c_frame, diff_frames, js_frame,
                           master_palette, pik_palette, sheet_palette,
                           verdict)

# every boot screen the oracle covers, with its argument space -- the
# default run walks all of them (each is one C/JS frame pair)
KINDS = {"title": [0], "difficulty": [0], "nation": [0], "name": [1],
         "king": [0, 3], "cards": [0, 1, 3, 6]}
NATION_STEM = ["ENGLND1", "FRANCE1", "SPAIN1", "DUTCH1"]


def compare(save, fk):

    js_args = [sys.executable, ROOT / "tools/sim_trace.py", "renderboot",
               save, fk]
    url = subprocess.run(js_args, capture_output=True, text=True,
                         check=True).stdout.strip()
    js = js_frame(url)

    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    out = SCRATCH / f"bt_{save}_{fk}.ppm"
    c_args = ["./smoke", "--renderboot", save,
              str(ROOT / "cport/pak/COLOPY.PAK"), str(out), fk]
    subprocess.run(c_args, cwd=ROOT / "cport/host", check=True,
                   capture_output=True)
    cim, idx = c_frame(out)

    # the atlas-vs-DAC model: the JS bakes each sheet's art in its OWN
    # palette; the single-DAC C resolves everything through WOODFRAM's.
    # A pixel is accepted when the C index resolves to the JS RGB through
    # ANY palette a sheet on this screen authored (structure stays bound
    # to the index plane) -- here the master plus OPENTILE's own.
    accept = [master_palette()]
    # the King's audience is KINGLSS1.PIK's palette (DAC upload @0x0754AD)
    # with the KING1 / nation banner sheets composed over it; a card is
    # its own LEVN000n.PIK palette (@0x004CFE, card 1 latches it)
    sheets = ["OPENTILE.SS"]
    piks = []
    if save == "king":
        piks = ["KINGLSS1.PIK"]
        sheets = ["KING1.SS", NATION_STEM[int(fk) & 3] + ".SS"]
    elif save == "cards":
        piks = ["LEVN%04d.PIK" % (int(fk) % 10 + 1)]
        sheets = []
    for nm in sheets:
        p = sheet_palette(nm)
        if p:
            accept.append(p)
    for nm in piks:
        p = pik_palette(nm)
        if p:
            accept.append(p)

    structural, accepted, first = diff_frames(js, cim, idx, accept)
    print("boot %s %s: %d structural, %d palette-model accepted"
          % (save, fk, structural, accepted))
    if first:
        print("first structural diff at (%d,%d): JS %s C %s idx %d" % first)
        js.save(SCRATCH / f"bt_{save}_{fk}_js.png")
        cim.crop((0, 0, 320, 200)).save(SCRATCH / f"bt_{save}_{fk}_c.png")
    return verdict("boot %s %s" % (save, fk), structural, accepted)


def main():
    if len(sys.argv) > 1:
        sys.exit(compare(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else "0"))
    worst = 0
    for kind, args in KINDS.items():
        for a in args:
            worst = max(worst, compare(kind, str(a)))
    sys.exit(worst)


if __name__ == "__main__":
    main()
