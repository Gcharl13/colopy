#!/usr/bin/env python3
"""render_woodcut_compare.py — Phase-7 woodcut oracle: the C plate
(smoke --renderwoodcut) vs the JS canvas (sim_trace renderwoodcut),
same fixture/pinned state, pixel-by-pixel over 320x200 with the same
master-palette acceptance rule as the map compare.

Usage: python3 tools/render_woodcut_compare.py [save] [N]
"""
import base64
import io
import subprocess
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SCRATCH = ROOT / "cport" / "pak"


def main():
    save = sys.argv[1] if len(sys.argv) > 1 else "sav1653"
    fk = sys.argv[2] if len(sys.argv) > 2 else "1"

    js_args = [sys.executable, ROOT / "tools/sim_trace.py", "renderwoodcut",
               save, fk]
    url = subprocess.run(js_args, capture_output=True, text=True,
                         check=True).stdout.strip()
    js = Image.open(io.BytesIO(base64.b64decode(url.split(",", 1)[1])))
    js = js.convert("RGB")

    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    out = SCRATCH / f"wc_{save}_{fk}.ppm"
    c_args = ["./smoke", "--renderwoodcut", save,
              str(ROOT / "cport/pak/COLOPY.PAK"), str(out), fk]
    subprocess.run(c_args, cwd=ROOT / "cport/host", check=True,
                   capture_output=True)
    cim = Image.open(out).convert("RGB")
    raw = (SCRATCH / f"wc_{save}_{fk}.ppm.idx").read_bytes()
    idx = raw[:320 * 240]

    pal6 = (ROOT / "raw/COLONIZE/VICEROY.PAL").read_bytes()[:768]
    master = bytes(((v << 2) | (v >> 4)) & 0xFF for v in pal6)
    # the atlas-vs-DAC model: the JS bakes each sheet's art in its OWN
    # palette; the single-DAC C resolves everything through WOODFRAM's.
    # A pixel is accepted when the C index resolves to the JS RGB through
    # ANY palette a sheet on this screen authored (structure stays bound
    # to the index plane).
    sys.path.insert(0, str(ROOT / "port" / "tools"))
    import ssdec
    accept = [master]
    for nm in ("WOODFRAM.SS", "WDCUT%02d.SS" % int(fk), "NAMEPLAT.SS"):
        f = ROOT / "raw/COLONIZE" / nm
        if f.exists():
            accept.append(bytes(ssdec.load_sheet(str(f))["pal"]))

    W, H = 320, 200
    jp, cp = js.load(), cim.load()
    structural = accepted = 0
    first = None
    for y in range(H):
        for x in range(W):
            if jp[x, y] == cp[x, y]:
                continue
            i = idx[y * 320 + x]
            if any(jp[x, y] == tuple(p8[i * 3:i * 3 + 3]) for p8 in accept):
                accepted += 1
                continue
            structural += 1
            if first is None:
                first = (x, y, jp[x, y], cp[x, y], i)
    print("woodcut %s %s: %d structural, %d palette-model accepted"
          % (save, fk, structural, accepted))
    if first:
        print("first structural diff at (%d,%d): JS %s C %s idx %d" % first)
        js.save(SCRATCH / f"wc_{save}_{fk}_js.png")
        cim.crop((0, 0, W, H)).save(SCRATCH / f"wc_{save}_{fk}_c.png")
    sys.exit(1 if structural else 0)


if __name__ == "__main__":
    main()
