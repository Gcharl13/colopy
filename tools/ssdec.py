#!/usr/bin/env python3
"""ssdec.py -- MADSPACK 2.0 (.SS/.PIK) container + FAB decompressor.

Ported verbatim from the byte-verified `madspack_load` / `fab_decompress` in
`ghidra_export/VICEROY_decompiled.named.c` (the in-EXE library routines), so the
codec is primary-grounded, not guessed. The decisive correctness test is that
every compressed section expands to EXACTLY its directory `unpacked` size.

Container layout (BYTE_VERIFIED, see formats/SS.md):
  0x00  "MADSPACK 2.0\x1A\x00"   (header; loader checks first 8 bytes "MADSPACK")
  0x0E  u16  section count
  0x10  count * 10-byte directory entries: type(1) _(1) unpacked(u32) packed(u32)
  0xB0  section data (FIXED start = 16 + 0xA0 reserved block), concatenated by
        `packed` size. type!=0 -> FAB stream ("FAB"+shift+...); type==0 -> raw.
"""
from __future__ import annotations
import struct, sys
from pathlib import Path


def fab_decompress(src: bytes, dstsize: int) -> bytes:
    if len(src) < 6 or src[0:3] != b"FAB":
        raise ValueError("not a FAB stream")
    shift = src[3]
    if not (10 <= shift <= 13):
        raise ValueError(f"bad FAB shift {shift}")
    ofs_shift = 16 - shift
    ofs_mask = (0xFF << (shift - 8)) & 0xFF
    len_mask = (1 << ofs_shift) - 1

    p = 6
    bitbuf = src[4] | (src[5] << 8)
    bits = 16
    dst = bytearray(dstsize)
    out = 0

    def bit() -> int:
        nonlocal bits, bitbuf, p
        bits -= 1
        if bits == 0:
            if p + 2 > len(src):
                raise ValueError("FAB underrun")
            bitbuf = ((src[p] | (src[p + 1] << 8)) << 1) | (bitbuf & 1)
            p += 2
            bits = 16
        b = bitbuf & 1
        bitbuf >>= 1
        return b

    while True:
        if bit():                                   # literal
            dst[out] = src[p]; p += 1; out += 1
            continue
        if bit() == 0:                              # short back-ref
            b1 = bit(); b0 = bit()
            clen = ((b1 << 1) | b0) + 2
            cofs = src[p] - 256; p += 1
        else:                                       # long back-ref
            cofs = ((((src[p + 1] >> ofs_shift) | ofs_mask) << 8) | src[p]) - 0x10000
            clen = src[p + 1] & len_mask
            p += 2
            if clen == 0:
                clen = src[p]; p += 1
                if clen == 0:
                    break                           # end of stream
                if clen == 1:
                    continue                        # bitstream realign
                clen += 1
            else:
                clen += 2
        while clen > 0:
            dst[out] = dst[out + cofs]; out += 1; clen -= 1
    if out != dstsize:
        raise ValueError(f"FAB produced {out} bytes, expected {dstsize}")
    return bytes(dst)


def madspack_load(data: bytes) -> list[tuple[int, bytes]]:
    """Return [(type, decompressed_bytes), ...] for each section."""
    if len(data) < 16 + 0xA0 or data[:8] != b"MADSPACK":
        raise ValueError("not a MADSPACK container")
    count = struct.unpack_from("<H", data, 14)[0]
    off = 16 + 0xA0                                 # sections start after the 0xA0 reserve
    out = []
    for i in range(count):
        e = 16 + i * 10
        typ = data[e]
        size = struct.unpack_from("<I", data, e + 2)[0]
        csize = struct.unpack_from("<I", data, e + 6)[0]
        chunk = data[off:off + csize]
        if typ == 0:
            sec = chunk[:size].ljust(size, b"\0")
        else:
            sec = fab_decompress(chunk, size)
        out.append((typ, sec))
        off += csize
    return out


if __name__ == "__main__":
    for fn in sys.argv[1:]:
        secs = madspack_load(Path(fn).read_bytes())
        print(f"{fn}: {len(secs)} sections")
        for i, (typ, sec) in enumerate(secs):
            print(f"  sec{i}: type={typ} len={len(sec)}")


# ---- sprite-sheet frame parsing + RLE pixel decode (from ss_load/rle_decode) ----
SS_TRANSPARENT = 0xFD


def rle_decode(src: bytes, w: int, h: int) -> bytearray:
    out = bytearray([SS_TRANSPARENT]) * (w * h)
    i = 0; n = len(src); px = 0; line = 0
    while i < n:
        cmd = src[i]; i += 1
        if cmd == 0xFC:
            return out
        if cmd == 0xFF:
            line += 1; px = 0; continue
        if line >= h:
            return out
        base = line * w
        if cmd == 0xFD:
            while True:
                count = src[i]; i += 1
                if count == 0xFF: break
                pixel = src[i]; i += 1
                while count > 0 and px < w:
                    out[base + px] = SS_TRANSPARENT if pixel == 0xFD else pixel
                    px += 1; count -= 1
        else:
            # `cmd` is a literal-line marker (not a pixel); pixels follow it
            j = i
            while True:
                c = src[j]; j += 1
                if c == 0xFF: break
                if c == 0xFE:
                    count = src[j]; pixel = src[j + 1]; j += 2
                    while count > 0 and px < w:
                        out[base + px] = SS_TRANSPARENT if pixel == 0xFD else pixel
                        px += 1; count -= 1
                elif px < w:
                    out[base + px] = SS_TRANSPARENT if c == 0xFD else c
                    px += 1
            i = j
        line += 1; px = 0
    return out


def load_sheet(path):
    """Return dict(nframes, pal[256*3 8-bit], frames=[(x,y,w,h,pixels)])."""
    import struct
    secs = madspack_load(Path(path).read_bytes())
    hdr, desc, pal6, pix = [s for _, s in secs]
    nframes = struct.unpack_from("<H", hdr, 38)[0]
    pal = bytes(((pal6[i] << 2) | (pal6[i] >> 4)) for i in range(768))
    frames = []
    for k in range(nframes):
        e = desc[k * 16:k * 16 + 16]
        off, size = struct.unpack_from("<I", e, 0)[0], struct.unpack_from("<I", e, 4)[0]
        x, y, w, h = struct.unpack_from("<hhHH", e, 8)
        frames.append((x, y, w, h, rle_decode(pix[off:off + size], w, h)))
    return dict(nframes=nframes, pal=pal, frames=frames)
