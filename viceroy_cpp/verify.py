#!/usr/bin/env python3
"""verify.py -- oracle parity check for the P0 C++ map renderer.

Decodes PHYS0.SS + AMER2.MP via the byte-verified tools/ssdec.py (the same
decoder the C++ is ported from), composites the map with the identical naive
logic as tools/render_map.py / viceroy_cpp, writes a reference PPM, and
pixel-diffs it against the C++ output (map.ppm).

The hard part (FAB/MADSPACK/RLE decode) comes from ssdec.py here vs. the C++
port there -- so any decoder divergence is caught. Exit 0 iff identical.

Usage:
    python3 verify.py [--colonize raw/COLONIZE] [--cpp viceroy_cpp/build/map.ppm]
"""
from __future__ import annotations
import argparse, struct, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
import ssdec  # noqa: E402

TILE = 16
SKIP = {0, 16, 100}


def composite(colonize: Path):
    sheet = ssdec.load_sheet(str(colonize / "PHYS0.SS"))
    frames = sheet["frames"]          # list of (x, y, w, h, pixels)
    pal = sheet["pal"]                # 768 bytes, 8-bit RGB

    mp = (colonize / "AMER2.MP").read_bytes()
    w, h = struct.unpack_from("<HH", mp, 0)
    tiles = mp[4:4 + w * h]

    W, H = w * TILE, h * TILE
    rgb = bytearray(W * H * 3)        # black

    def blit(fr, dx, dy):
        fx, fy, fw, fh, px = fr
        if fw <= 0 or fh <= 0:
            return
        for ty in range(TILE):
            sy = ty if fh == TILE else (ty * fh) // TILE
            if sy >= fh:
                sy = fh - 1
            for tx in range(TILE):
                sx = tx if fw == TILE else (tx * fw) // TILE
                if sx >= fw:
                    sx = fw - 1
                idx = px[sy * fw + sx]
                if idx == ssdec.SS_TRANSPARENT:
                    continue
                X, Y = dx + tx, dy + ty
                if X < 0 or Y < 0 or X >= W or Y >= H:
                    continue
                o = (Y * W + X) * 3
                rgb[o] = pal[idx * 3]
                rgb[o + 1] = pal[idx * 3 + 1]
                rgb[o + 2] = pal[idx * 3 + 2]

    nf = len(frames)
    for y in range(h):
        for x in range(w):
            b = tiles[y * w + x]
            tid = b & 0x1F
            if tid in SKIP or tid >= nf:
                continue
            blit(frames[tid], x * TILE, y * TILE)
            if (b & 0x20) and nf > 1:          # river overlay = frame 1
                blit(frames[1], x * TILE, y * TILE)
    return W, H, bytes(rgb)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--colonize", type=Path, default=ROOT / "raw" / "COLONIZE")
    ap.add_argument("--cpp", type=Path, default=ROOT / "viceroy_cpp" / "build" / "map.ppm")
    ap.add_argument("--ref", type=Path, default=ROOT / "viceroy_cpp" / "build" / "ref.ppm")
    args = ap.parse_args()

    W, H, rgb = composite(args.colonize)
    args.ref.parent.mkdir(parents=True, exist_ok=True)
    with open(args.ref, "wb") as f:
        f.write(b"P6\n%d %d\n255\n" % (W, H))
        f.write(rgb)
    print(f"oracle render: {W}x{H}")

    if not args.cpp.exists():
        print(f"C++ output not found: {args.cpp}", file=sys.stderr)
        return 2
    data = args.cpp.read_bytes()
    # strip PPM header (3 whitespace-separated tokens after magic)
    if not data.startswith(b"P6"):
        print("C++ output is not P6 PPM", file=sys.stderr)
        return 2
    idx, tok = 2, 0
    while tok < 3:
        while idx < len(data) and data[idx] in b" \t\r\n":
            idx += 1
        while idx < len(data) and data[idx] not in b" \t\r\n":
            idx += 1
        tok += 1
    idx += 1  # single whitespace after maxval
    cpp_pixels = data[idx:]

    if cpp_pixels == rgb:
        print(f"PARITY OK: C++ output matches the ssdec oracle exactly "
              f"({len(rgb)} bytes).")
        return 0
    ndiff = sum(1 for a, b in zip(cpp_pixels, rgb) if a != b)
    print(f"MISMATCH: {ndiff} differing bytes / {len(rgb)} "
          f"(C++ {len(cpp_pixels)} vs oracle {len(rgb)}).", file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main())
