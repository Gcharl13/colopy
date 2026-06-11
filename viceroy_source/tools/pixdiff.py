#!/usr/bin/env python3
"""
pixdiff.py -- compare two screen captures byte-for-byte (Phase 0.3 gate).

Reads PPM (P6, the modern build's F12 dump) and PNG (DOSBox screenshots;
8-bit palette or 24-bit truecolor, non-interlaced -- decoded with stdlib
zlib only).  Frames must match pixel-exactly after decoding to RGB; exit 0
on identical.

On divergence: reports count, bounding box, first divergent pixel, and
writes a visual diff (divergent pixels in white on black) next to file A
as <A>.diff.ppm.

Usage:  python3 tools/pixdiff.py modern.ppm dosbox.png
"""
import os
import struct
import sys
import zlib


def read_ppm(path):
    data = open(path, "rb").read()
    if not data.startswith(b"P6"):
        raise ValueError("not P6 PPM")
    # header: P6 <w> <h> <maxval> with comments allowed
    toks, i = [], 2
    while len(toks) < 3:
        while i < len(data) and data[i] in b" \t\r\n":
            i += 1
        if data[i : i + 1] == b"#":
            while data[i] not in b"\r\n":
                i += 1
            continue
        j = i
        while data[j] not in b" \t\r\n":
            j += 1
        toks.append(int(data[i:j]))
        i = j
    i += 1  # single whitespace after maxval
    w, h, _ = toks
    return w, h, data[i : i + w * h * 3]


def read_png(path):
    data = open(path, "rb").read()
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        raise ValueError("not PNG")
    pos, idat, plte = 8, b"", None
    w = h = depth = ctype = None
    while pos < len(data):
        ln, typ = struct.unpack(">I4s", data[pos : pos + 8])
        body = data[pos + 8 : pos + 8 + ln]
        pos += 12 + ln
        if typ == b"IHDR":
            w, h, depth, ctype, _, _, ilace = struct.unpack(">IIBBBBB", body)
            if ilace:
                raise ValueError("interlaced PNG unsupported")
        elif typ == b"PLTE":
            plte = body
        elif typ == b"IDAT":
            idat += body
        elif typ == b"IEND":
            break
    raw = zlib.decompress(idat)
    if ctype == 3:  # palette
        if depth != 8:
            raise ValueError(f"palette depth {depth} unsupported")
        stride, px = w, 1
    elif ctype == 2:  # truecolor
        stride, px = w * 3, 3
    elif ctype == 6:  # truecolor+alpha
        stride, px = w * 4, 4
    else:
        raise ValueError(f"PNG color type {ctype} unsupported")

    # un-filter
    out = bytearray()
    prev = bytearray(stride)
    p = 0
    for _ in range(h):
        f = raw[p]
        p += 1
        line = bytearray(raw[p : p + stride])
        p += stride
        if f == 1:  # sub
            for i in range(px, stride):
                line[i] = (line[i] + line[i - px]) & 0xFF
        elif f == 2:  # up
            for i in range(stride):
                line[i] = (line[i] + prev[i]) & 0xFF
        elif f == 3:  # average
            for i in range(stride):
                a = line[i - px] if i >= px else 0
                line[i] = (line[i] + ((a + prev[i]) >> 1)) & 0xFF
        elif f == 4:  # paeth
            for i in range(stride):
                a = line[i - px] if i >= px else 0
                b = prev[i]
                c = prev[i - px] if i >= px else 0
                pa, pb, pc = abs(b - c), abs(a - c), abs(a + b - 2 * c)
                pr = a if pa <= pb and pa <= pc else (b if pb <= pc else c)
                line[i] = (line[i] + pr) & 0xFF
        out += line
        prev = line

    rgb = bytearray(w * h * 3)
    if ctype == 3:
        for i in range(w * h):
            pi = out[i] * 3
            rgb[i * 3 : i * 3 + 3] = plte[pi : pi + 3]
    elif ctype == 2:
        rgb = out
    else:  # drop alpha
        for i in range(w * h):
            rgb[i * 3 : i * 3 + 3] = out[i * 4 : i * 4 + 3]
    return w, h, bytes(rgb)


def read_any(path):
    return read_png(path) if path.lower().endswith(".png") else read_ppm(path)


def main(argv):
    if len(argv) != 2:
        print(__doc__)
        return 2
    wa, ha, a = read_any(argv[0])
    wb, hb, b = read_any(argv[1])
    if (wa, ha) != (wb, hb):
        print(f"GEOMETRY DIFF: {wa}x{ha} vs {wb}x{hb}")
        return 1
    if a == b:
        print(f"IDENTICAL {wa}x{ha}")
        return 0
    n = 0
    first = None
    x0, y0, x1, y1 = wa, ha, -1, -1
    diff = bytearray(wa * ha * 3)
    for i in range(wa * ha):
        if a[i * 3 : i * 3 + 3] != b[i * 3 : i * 3 + 3]:
            n += 1
            x, y = i % wa, i // wa
            if first is None:
                first = (x, y)
            x0, y0 = min(x0, x), min(y0, y)
            x1, y1 = max(x1, x), max(y1, y)
            diff[i * 3 : i * 3 + 3] = b"\xff\xff\xff"
    out = argv[0] + ".diff.ppm"
    with open(out, "wb") as f:
        f.write(b"P6\n%d %d\n255\n" % (wa, ha))
        f.write(diff)
    print(f"DIVERGENT: {n} px ({100.0 * n / (wa * ha):.2f}%)  "
          f"first=({first[0]},{first[1]})  bbox=({x0},{y0})..({x1},{y1})")
    print(f"visual diff -> {out}")
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
