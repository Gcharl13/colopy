#!/usr/bin/env python3
"""
viceroy_exe.py — Foundational model of COLONIZE/VICEROY.EXE for byte-accurate
reverse engineering.

This is the ground-truth layer every higher tool builds on:
  - parse the DOS MZ header
  - map between (segment:offset) <-> raw file offset
  - read bytes / disassemble at any file offset (capstone 16-bit)
  - apply / inspect the relocation table

KEY MODEL (verified against the project's documented anchors):
    file_offset = LOAD_BASE + (seg << 4) + off
    LOAD_BASE   = e_cparhdr * 16   (= 0x2400 for this image)

The image is an RTLink/Plus v2 build: resident load image first, then the
overlay region appended in the same file (no .OVL). Overlay code is reached
through a thunk table whose three windows alias the same block at
file 0x1A5F0 (seg 0x181F / 0x191F / 0x1A1F).

Usage:
    from viceroy_exe import EXE
    exe = EXE()                       # loads re_work/VICEROY.EXE by default
    exe.read(0x103D4, 16)             # bytes at a file offset
    exe.foff(0x110D, 0x071D)          # seg:off -> file offset
    for ins in exe.disasm(0x103D4, 64): print(ins)
"""
import os
import struct
import sys

# Resolve the binary relative to repo root regardless of cwd.
_HERE = os.path.dirname(os.path.abspath(__file__))
_REPO = os.path.dirname(os.path.dirname(_HERE))          # .../colopy
DEFAULT_EXE = os.path.join(_REPO, "re_work", "VICEROY.EXE")

EXPECTED_SIZE = 494910
EXPECTED_SHA256 = "a17ed64c27671e5e95236e54a7ddc85803a96ba822fbed05e1dad34d3917e2e3"


class EXE:
    def __init__(self, path=DEFAULT_EXE):
        with open(path, "rb") as f:
            self.data = f.read()
        self.path = path
        self._parse_header()

    # ---- header ---------------------------------------------------------
    def _parse_header(self):
        d = self.data
        if d[:2] not in (b"MZ", b"ZM"):
            raise ValueError("not an MZ executable")
        (self.e_cblp, self.e_cp, self.e_crlc, self.e_cparhdr,
         self.e_minalloc, self.e_maxalloc, self.e_ss, self.e_sp,
         self.e_csum, self.e_ip, self.e_cs, self.e_lfarlc,
         self.e_ovno) = struct.unpack_from("<13H", d, 2)
        self.load_base = self.e_cparhdr * 16                 # 0x2400
        # image length declared by header (e_cp pages of 512, minus slack)
        self.image_len = self.e_cp * 512
        if self.e_cblp:
            self.image_len -= (512 - self.e_cblp)
        # relocation table
        self.relocs = []
        off = self.e_lfarlc
        for _ in range(self.e_crlc):
            r_off, r_seg = struct.unpack_from("<HH", d, off)
            self.relocs.append((r_seg, r_off))
            off += 4

    # ---- address translation -------------------------------------------
    def foff(self, seg, off):
        """seg:off (load-module-relative) -> raw file offset."""
        return self.load_base + (seg << 4) + off

    def linear(self, seg, off):
        """seg:off -> linear address within the load image (no file base)."""
        return (seg << 4) + off

    def seg_off_from_foff(self, foff, seg=None):
        """file offset -> (seg, off). If seg given, offset is relative to it."""
        lin = foff - self.load_base
        if seg is None:
            seg = (lin >> 4)
            return seg, lin - (seg << 4)
        return seg, lin - (seg << 4)

    # ---- byte access ----------------------------------------------------
    def read(self, foff, n):
        return self.data[foff:foff + n]

    def hex(self, foff, n, sep=" "):
        return sep.join(f"{b:02x}" for b in self.data[foff:foff + n])

    def u8(self, foff):
        return self.data[foff]

    def u16(self, foff):
        return struct.unpack_from("<H", self.data, foff)[0]

    def i16(self, foff):
        return struct.unpack_from("<h", self.data, foff)[0]

    def u32(self, foff):
        return struct.unpack_from("<I", self.data, foff)[0]

    def i32(self, foff):
        return struct.unpack_from("<i", self.data, foff)[0]

    # ---- disassembly ----------------------------------------------------
    _md = None

    @classmethod
    def _mdisasm(cls):
        if cls._md is None:
            import capstone
            md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)
            md.detail = True
            cls._md = md
        return cls._md

    def disasm(self, foff, n, base_addr=None):
        """Disassemble n bytes at file offset foff.
        base_addr: the address capstone reports (default = foff)."""
        md = self._mdisasm()
        if base_addr is None:
            base_addr = foff
        return list(md.disasm(self.data[foff:foff + n], base_addr))

    def disasm_str(self, foff, n, base_addr=None, with_bytes=True):
        out = []
        for ins in self.disasm(foff, n, base_addr):
            if with_bytes:
                bs = " ".join(f"{b:02x}" for b in ins.bytes)
                out.append(f"0x{ins.address:06x}  {bs:<24}  {ins.mnemonic} {ins.op_str}")
            else:
                out.append(f"0x{ins.address:06x}  {ins.mnemonic} {ins.op_str}")
        return "\n".join(out)

    # ---- string scan ----------------------------------------------------
    def ascii_at(self, foff, minlen=1, maxlen=256):
        """Return the NUL-terminated printable string at foff, or None."""
        d = self.data
        end = foff
        while end < len(d) and end - foff < maxlen and 0x20 <= d[end] < 0x7f:
            end += 1
        if end < len(d) and d[end] == 0 and end - foff >= minlen:
            return d[foff:end].decode("ascii")
        return None


def main(argv):
    exe = EXE()
    print(f"path        : {exe.path}")
    print(f"size        : {len(exe.data)} (expected {EXPECTED_SIZE})")
    print(f"e_cparhdr   : {exe.e_cparhdr}  -> load_base 0x{exe.load_base:x}")
    print(f"e_cp/e_cblp : {exe.e_cp} pages / {exe.e_cblp} last  -> image_len 0x{exe.image_len:x}")
    print(f"entry CS:IP : {exe.e_cs:04X}:{exe.e_ip:04X}  -> file 0x{exe.foff(exe.e_cs, exe.e_ip):06x}")
    print(f"init SS:SP  : {exe.e_ss:04X}:{exe.e_sp:04X}")
    print(f"relocations : {exe.e_crlc} (table @0x{exe.e_lfarlc:x})")
    print()
    # calibration checks against documented anchors
    checks = [
        ("entry stub @110D:071D (file 0x13BED)", exe.foff(0x110D, 0x071D), None),
        ("thunk[0] @181F:0 (file 0x1A5F0) == 9a ab 0d 0d 11", exe.foff(0x181F, 0), "9a ab 0d 0d 11"),
        ("rand() func_0103D4", 0x0103D4, None),
    ]
    for label, fo, expect in checks:
        got = exe.hex(fo, 5)
        ok = "" if expect is None else ("  OK" if got == expect else f"  MISMATCH (want {expect})")
        print(f"{label}\n    file 0x{fo:06x}: {got}{ok}")
    print()
    if len(argv) > 1:
        fo = int(argv[1], 0)
        n = int(argv[2], 0) if len(argv) > 2 else 64
        print(exe.disasm_str(fo, n))


if __name__ == "__main__":
    main(sys.argv)
