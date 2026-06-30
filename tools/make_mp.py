#!/usr/bin/env python3
"""Rebuild a binary .MP map from an extracted *_tiles.json.

The repo ships the original maps as decoded JSON (data_extracted/map/*_tiles.json),
not as the binary .MP the Forge map editor loads. This regenerates a loadable .MP
from that JSON: a 4-byte header (width u16le, height u16le) followed by the raw
row-major tile bytes (terrain id in bits 0-4, river bit 5, forest bit 6 -- preserved
verbatim). The original per-tile trailer (colony/unit/native records) is NOT carried
in the JSON, so the result is terrain-only -- exactly what the map editor needs to
view and paint. See formats/MP_FORMAT.md.

Usage: tools/make_mp.py data_extracted/map/AMER2_tiles.json data_extracted/map/AMER2.MP
"""
import json
import struct
import sys


def main(argv):
    if len(argv) != 3:
        sys.exit(f"usage: {argv[0]} IN_tiles.json OUT.mp")
    src, dst = argv[1], argv[2]
    with open(src) as f:
        d = json.load(f)
    w, h = int(d["width"]), int(d["height"])
    tiles = d["tiles"]
    if len(tiles) != w * h:
        sys.exit(f"{src}: tile count {len(tiles)} != {w}*{h}={w*h}")
    out = bytearray()
    out += struct.pack("<HH", w, h)          # header: width, height (little-endian words)
    out += bytes(int(t) & 0xFF for t in tiles)  # raw tile bytes, row-major
    with open(dst, "wb") as f:
        f.write(out)
    print(f"wrote {dst}: {w}x{h} = {w*h} tiles, {len(out)} bytes")


if __name__ == "__main__":
    main(sys.argv)
