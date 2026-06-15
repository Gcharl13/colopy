#!/usr/bin/env python3
"""
extract_phys0.py — decode PHYS0.SS (terrain sprite sheet) end to end:

  MADSPACK container -> FAB-decompress 4 sections -> parse MS_SPRITE frame
  table -> RLE-decode each 16x16 frame -> apply the embedded VGA palette.

Outputs:
  - mapedit_modern/data/phys0_contact.png : labelled contact sheet (for the
    one-time terrain-id -> frame-index identification)
  - mapedit_modern/data/phys0.atlas       : compact RGBA atlas the C GUI loads
"""
import struct
import zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SS = (ROOT / "raw/COLONIZE/PHYS0.SS").read_bytes()
OUT = ROOT / "mapedit_modern" / "data"
OUT.mkdir(parents=True, exist_ok=True)

TRANS = 0xFFFF   # sentinel for transparent pixels


# ---- FAB (verbatim port of ScummVM FabDecompressor) ----
def fab_decompress(src, destsize):
    assert src[:3] == b"FAB"
    shiftVal = src[3]
    copyOfsShift = 16 - shiftVal
    copyOfsMask = (0xFF << (shiftVal - 8)) & 0xFF
    copyLenMask = (1 << copyOfsShift) - 1
    p, bitsLeft, bitBuffer = 6, 16, src[4] | (src[5] << 8)
    dest = bytearray()

    def getbit():
        nonlocal bitsLeft, bitBuffer, p
        bitsLeft -= 1
        if bitsLeft == 0:
            word = src[p] | (src[p + 1] << 8)
            bitBuffer = ((word << 1) | (bitBuffer & 1)) & 0x1FFFF
            p += 2
            bitsLeft = 16
        b = bitBuffer & 1
        bitBuffer >>= 1
        return b

    while True:
        if getbit() == 0:
            if getbit() == 0:
                copyLen = ((getbit() << 1) | getbit()) + 2
                copyOfs = src[p] | 0xFFFFFF00; p += 1
            else:
                b0, b1 = src[p], src[p + 1]
                copyOfs = ((((b1 >> copyOfsShift) | copyOfsMask) << 8) | b0)
                copyLen = b1 & copyLenMask
                p += 2
                if copyLen == 0:
                    copyLen = src[p]; p += 1
                    if copyLen == 0:
                        break
                    elif copyLen == 1:
                        continue
                    else:
                        copyLen += 1
                else:
                    copyLen += 2
                copyOfs |= 0xFFFF0000
            off = copyOfs - 0x100000000 if (copyOfs & 0x80000000) else copyOfs
            for _ in range(copyLen):
                dest.append(dest[len(dest) + off])
        else:
            dest.append(src[p]); p += 1
    assert len(dest) == destsize, (len(dest), destsize)
    return bytes(dest)


# ---- MS_SPRITE RLE (verbatim port of ScummVM MSprite::loadSprite) ----
def decode_frame(data, off, size, w, h):
    px = [TRANS] * (w * h)
    src = data[off:off + size]
    i = 0
    x = 0
    y = 0

    def put(val):
        nonlocal x
        if y < h and x < w:
            px[y * w + x] = (TRANS if val == 0xFD else val)
        x += 1

    while i < len(src):
        cmd1 = src[i]; i += 1
        if cmd1 == 0xFC:
            break
        if cmd1 == 0xFF:
            y += 1; x = 0; continue
        if cmd1 == 0xFD:
            while i < len(src):
                count = src[i]; i += 1
                if count == 0xFF:
                    break
                pixel = src[i]; i += 1
                for _ in range(count):
                    put(pixel)
            y += 1; x = 0
        else:
            while i < len(src):
                cmd2 = src[i]; i += 1
                if cmd2 == 0xFF:
                    break
                elif cmd2 == 0xFE:
                    count = src[i]; i += 1
                    pixel = src[i]; i += 1
                    for _ in range(count):
                        put(pixel)
                else:
                    put(cmd2)
            y += 1; x = 0
    return px


def main():
    cnt = struct.unpack_from("<H", SS, 14)[0]
    dirs = []
    o = 16
    for _ in range(cnt):
        dirs.append((struct.unpack_from("<I", SS, o + 2)[0], struct.unpack_from("<I", SS, o + 6)[0]))
        o += 10
    start = SS.find(b"FAB", 56)
    secs, p = [], start
    for (usize, csize) in dirs:
        secs.append(fab_decompress(SS[p:p + csize + 32], usize)); p += csize

    header, frametab, palraw, pixels = secs
    # palette: 256 * RGB6 -> RGB8
    pal = []
    for k in range(256):
        r, g, b = palraw[k * 3], palraw[k * 3 + 1], palraw[k * 3 + 2]
        pal.append((r * 255 // 63, g * 255 // 63, b * 255 // 63))

    # frame table: 16-byte records {u32 dataOff, u32 dataSize, u16 a, u16 b, u16 w, u16 h}
    nframes = len(frametab) // 16
    frames = []
    for k in range(nframes):
        dOff, dSize, a, b, w, h = struct.unpack_from("<IIHHHH", frametab, k * 16)
        if w == 0 or h == 0 or w > 64 or h > 64:
            frames.append((w, h, []))
            continue
        frames.append((w, h, decode_frame(pixels, dOff, dSize, w, h)))
    print(f"frames: {nframes}  (palette {len(pal)})")

    # ---- contact sheet PNG ----
    cols = 16
    cell = 18
    rows = (nframes + cols - 1) // cols
    CW, CH = cols * cell, rows * cell
    img = [[(40, 40, 48)] * CW for _ in range(CH)]
    for idx, (w, h, px) in enumerate(frames):
        cx, cy = (idx % cols) * cell, (idx // cols) * cell
        for yy in range(min(h, cell)):
            for xx in range(min(w, cell)):
                if not px:
                    continue
                v = px[yy * w + xx]
                if v == TRANS:
                    continue
                img[cy + yy][cx + xx] = pal[v]
    write_png(OUT / "phys0_contact.png", img)
    print(f"wrote {OUT/'phys0_contact.png'} ({CW}x{CH})")

    # ---- binary atlas for the C loader ----
    # header: 'MPAT', u16 count; per frame: u16 w,h,u32 rgba_off; then RGBA blob
    blob = bytearray()
    meta = bytearray()
    for (w, h, px) in frames:
        meta += struct.pack("<HHI", w, h, len(blob))
        if not px:
            continue
        for v in px:
            if v == TRANS:
                blob += bytes((0, 0, 0, 0))
            else:
                r, g, b = pal[v]
                blob += bytes((r, g, b, 255))
    out = bytearray(b"MPAT")
    out += struct.pack("<H", nframes)
    out += meta
    out += blob
    (OUT / "phys0.atlas").write_bytes(out)
    print(f"wrote {OUT/'phys0.atlas'} ({len(out)} bytes, {nframes} frames)")


def write_png(path, rows):
    h = len(rows); w = len(rows[0])
    raw = bytearray()
    for r in rows:
        raw.append(0)
        for (rr, gg, bb) in r:
            raw += bytes((rr, gg, bb))
    comp = zlib.compress(bytes(raw), 9)

    def chunk(typ, data):
        c = struct.pack(">I", len(data)) + typ + data
        return c + struct.pack(">I", zlib.crc32(typ + data) & 0xFFFFFFFF)

    png = b"\x89PNG\r\n\x1a\n"
    png += chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 2, 0, 0, 0))
    png += chunk(b"IDAT", comp)
    png += chunk(b"IEND", b"")
    Path(path).write_bytes(png)


if __name__ == "__main__":
    main()
