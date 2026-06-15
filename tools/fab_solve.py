#!/usr/bin/env python3
"""fab_solve.py — faithful MADS FAB decompressor (port of ScummVM
FabDecompressor::decompress), applied to PHYS0.SS. Validates all four sections
against their exact uncompressed sizes and dumps them to raw/COLONIZE/."""
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SS = (ROOT / "raw/COLONIZE/PHYS0.SS").read_bytes()
PAL = (ROOT / "raw/COLONIZE/VICEROY.PAL").read_bytes()


def fab_decompress(src, destsize):
    assert src[:3] == b"FAB", "bad FAB header"
    shiftVal = src[3]
    copyOfsShift = 16 - shiftVal
    copyOfsMask = (0xFF << (shiftVal - 8)) & 0xFF
    copyLenMask = (1 << copyOfsShift) - 1
    p = 6
    bitsLeft = 16
    bitBuffer = src[4] | (src[5] << 8)
    dest = bytearray()

    def getbit():
        nonlocal bitsLeft, bitBuffer, p
        bitsLeft -= 1
        if bitsLeft == 0:
            word = src[p] | (src[p + 1] << 8)
            bitBuffer = ((word << 1) | (bitBuffer & 1)) & 0x1FFFF
            p += 2
            bitsLeft = 16
        bit = bitBuffer & 1
        bitBuffer >>= 1
        return bit

    while True:
        if getbit() == 0:
            if getbit() == 0:
                copyLen = ((getbit() << 1) | getbit()) + 2
                copyOfs = (src[p] | 0xFFFFFF00); p += 1
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
            off = copyOfs & 0xFFFFFFFF
            if off & 0x80000000:
                off -= 0x100000000          # signed
            while copyLen > 0:
                dest.append(dest[len(dest) + off])
                copyLen -= 1
        else:
            dest.append(src[p]); p += 1
    if len(dest) != destsize:
        raise ValueError(f"size mismatch: got {len(dest)} want {destsize}")
    return bytes(dest)


# parse directory + locate FAB sections
cnt = struct.unpack_from("<H", SS, 14)[0]
dirs = []
o = 16
for _ in range(cnt):
    dirs.append((struct.unpack_from("<I", SS, o + 2)[0], struct.unpack_from("<I", SS, o + 6)[0]))
    o += 10
start = SS.find(b"FAB", 56)
sections, p = [], start
for (usize, csize) in dirs:
    sections.append((p, csize, usize)); p += csize

outs = []
for i, (off, csize, usize) in enumerate(sections):
    out = fab_decompress(SS[off:off + csize + 32], usize)
    outs.append(out)
    print(f"section {i}: comp={csize} -> {len(out)} bytes  OK")
    (ROOT / f"raw/COLONIZE/_phys0_sec{i}.bin").write_bytes(out)

print("\npalette section (768=256*3) [0:24]:", outs[2][:24].hex(' '))
print("VICEROY.PAL                  [0:32]:", PAL[:32].hex(' '))
