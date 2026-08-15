#!/usr/bin/env python3
"""render_compare.py — Phase-7 render-core oracle.

Rebuilds the C `smoke --render` selftest scene DIRECTLY from the original
DOS assets (raw/COLONIZE via tools/ssdec.py — the byte-verified codec)
and diffs the C PPM pixel-exactly.  The two paths share no code past the
formats documents:

    raw .SS/.FF/.PAL -> gen_sd_pack -> COLOPY.PAK -> C blit  (the port)
    raw .SS/.FF/.PAL -> ssdec/this file -> reference        (the oracle)

so a zero diff certifies the pak pipeline AND the C blit/text/palette
primitives in one pass.  Exit 0 only on exact agreement.

Scene contract: keep in lockstep with cport/host/render_smoke.c.
"""
import struct
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
import ssdec  # noqa: E402

COLONIZE = ROOT / "raw" / "COLONIZE"
W, H, GAME_H = 320, 240, 200
TRANSPARENT = 0xFD


def ff_payload(name):
    secs = [d for _, d in ssdec.madspack_load((COLONIZE / name).read_bytes())]
    return max(secs, key=len)


def glyph_width(pl, ch):
    return pl[2 + ch - 1] if 1 <= ch <= 128 else 0


def draw_text(fb, pl, s, x, y, ink):
    """func_00E51C semantics — mirror of rd_text (colopy_render.c)."""
    cell_h = pl[0]
    sp = glyph_width(pl, 32) or 3
    for c in s:
        ch = ord(c)
        w = glyph_width(pl, ch)
        if not w:
            x += sp
            continue
        off = struct.unpack_from("<H", pl, 130 + 2 * (ch - 1))[0]
        stride = (w * 2 + 7) // 8
        for r in range(cell_h):
            dy = y + r
            if not (0 <= dy < H):
                continue
            row = pl[off + r * stride: off + (r + 1) * stride]
            for cx in range(w):
                dx = x + cx
                if not (0 <= dx < W):
                    continue
                lvl = (row[cx >> 2] >> (6 - 2 * (cx & 3))) & 3
                if ink[lvl] != 0xFF:
                    fb[dy * W + dx] = ink[lvl]
        x += w
    return x


def blit(fb, sheet, idx, x, y):
    fx, fy, w, h, pix = sheet["frames"][idx]
    for r in range(h):
        dy = y + r
        if not (0 <= dy < H):
            continue
        base = r * w
        for c in range(w):
            dx = x + c
            if not (0 <= dx < W):
                continue
            v = pix[base + c]
            if v != TRANSPARENT:
                fb[dy * W + dx] = v


def main():
    terrain = ssdec.load_sheet(COLONIZE / "TERRAIN.SS")
    phys0 = ssdec.load_sheet(COLONIZE / "PHYS0.SS")
    icons = ssdec.load_sheet(COLONIZE / "ICONS.SS")
    wood = ssdec.load_sheet(COLONIZE / "WOODTILE.SS")

    fb = bytearray(W * H)
    # the scene — lockstep with render_smoke.c
    wtw, wth = wood["frames"][0][2], wood["frames"][0][3]
    for y in range(0, GAME_H, wth):
        for x in range(0, W, wtw):
            blit(fb, wood, 0, x, y)
    for r in range(8, 8 + 192):
        fb[r * W: r * W + 240] = b"\0" * 240
    for k in range(terrain["nframes"]):
        blit(fb, terrain, k, 4 + k * 17, 12)
    for k in range(24):
        blit(fb, phys0, k, 4 + k * 13, 40)
    for k in range(16):
        blit(fb, icons, k, 244 + (k % 4) * 18, 12 + (k // 4) * 18)
    lut15 = (0xFF, 15, 14, 0)
    draw_text(fb, ff_payload("FONTTINY.FF"),
              "COLOPY RENDER SELFTEST 0123456789", 4, 100, lut15)
    draw_text(fb, ff_payload("FONTINTR.FF"),
              "Land Ho! What shall we call this new land?", 4, 110, lut15)
    draw_text(fb, ff_payload("FONTKING.FF"), "ABCXYZ abcxyz", 4, 130, lut15)

    # palette: master VICEROY.PAL overridden by WOODTILE.SS's own
    pal6 = (COLONIZE / "VICEROY.PAL").read_bytes()[:768]
    pal = bytearray(((v << 2) | (v >> 4)) & 0xFF for v in pal6)
    pal[:] = wood["pal"]        # usePalette('WOODTILE') — full 256 override
    ref = bytearray()
    for i in range(W * H):
        ref += pal[fb[i] * 3: fb[i] * 3 + 3]

    # the C side
    pak = ROOT / "cport" / "pak" / "COLOPY.PAK"
    if not pak.exists():
        subprocess.run([sys.executable, ROOT / "tools/gen_sd_pack.py"],
                       check=True)
    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host", check=True)
    out = ROOT / "cport" / "pak" / "selftest.ppm"
    subprocess.run(["./smoke", "--render", str(pak), str(out)],
                   cwd=ROOT / "cport/host", check=True,
                   capture_output=True)
    data = out.read_bytes()
    nl = 0
    for _ in range(3):                       # P6 header: three whitespace fields
        nl = data.index(b"\n", nl) + 1
    got = data[nl:]
    if len(got) != len(ref):
        print("render: size mismatch C %d ref %d" % (len(got), len(ref)))
        sys.exit(1)
    bad = sum(1 for a, b in zip(got, ref) if a != b)
    if bad:
        # find the first differing pixel for the report
        for i in range(0, len(ref), 3):
            if got[i:i + 3] != ref[i:i + 3]:
                p = i // 3
                print("first diff at (%d,%d): C %s ref %s"
                      % (p % W, p // W, list(got[i:i + 3]), list(ref[i:i + 3])))
                break
    print("render selftest: %d byte difference(s) over %dx%d" % (bad, W, H))
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
