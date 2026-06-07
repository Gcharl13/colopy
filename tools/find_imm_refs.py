#!/usr/bin/env python3
"""
find_imm_refs.py — find every instruction in VICEROY.EXE that loads
a specified 16-bit immediate value.

Looks for patterns:
  B8 imm16        MOV AX, imm
  BB imm16        MOV BX, imm
  B9 imm16        MOV CX, imm
  BA imm16        MOV DX, imm
  BE imm16        MOV SI, imm
  BF imm16        MOV DI, imm
  68 imm16        PUSH imm16              (80186+; might be present)
  C7 06 dst imm16 MOV [dst], imm
  3D imm16        CMP AX, imm
  81 /7 imm16     CMP r/m, imm
  ...etc, but the MOV-reg pattern is the dominant one for string addresses

Reports each hit with file offset, segment:offset (per Ghidra's memory map),
and the surrounding bytes for context.

Usage:  python find_imm_refs.py 0x1be0
"""
from __future__ import annotations
import sys
from pathlib import Path

EXE = Path(__file__).resolve().parents[2] / "COLONIZE" / "VICEROY.EXE"

# (Segment paragraph in Ghidra, file offset, length) — extracted from
# the user's memory map output. We use this to convert file offsets back
# to Ghidra-style segment:offset addresses.
SEGMENT_MAP = [
    # (paragraph, file_start, length)
    (0x1000, 0x002400, 0x93),
    (0x1009, 0x002493, 0x42d),
    (0x104b, 0x0028c0, 0x4b3),
    (0x1097, 0x002d73, 0x6aa),
    (0x1101, 0x00341d, 0x294),
    (0x112b, 0x0036b1, 0x121b),
    (0x124c, 0x0048cc, 0x156),
    (0x1262, 0x004a22, 0x3d5),
    (0x129f, 0x004df7, 0x369),
    (0x12d6, 0x005160, 0x2d),
    (0x12d8, 0x00518d, 0x45),
    (0x12dd, 0x0051d2, 0xc3),
    (0x12e9, 0x005295, 0x148),
    (0x12fd, 0x0053dd, 0xfd),
    (0x130d, 0x0054da, 0x720),
    (0x137f, 0x005bfa, 0x654),
    (0x13e4, 0x00624e, 0xcb),
    (0x13f1, 0x006319, 0x359),
    (0x1427, 0x006672, 0x1575),
    (0x157e, 0x007be7, 0x34d),
    (0x15b3, 0x007f34, 0x28c),
    (0x15dc, 0x0081c0, 0xf2),
    (0x15eb, 0x0082b2, 0x396e),
    (0x1981, 0x00bc20, 0x2d),
    (0x1984, 0x00bc4d, 0x6aa),
    (0x19ef, 0x00c2f7, 0x6a),
    (0x19f6, 0x00c361, 0x142),
    (0x1a0a, 0x00c4a3, 0x1ed),
    (0x1a29, 0x00c690, 0x258),
    (0x1a4e, 0x00c8e8, 0xa5),
    (0x1a58, 0x00c98d, 0x728),
    (0x1acb, 0x00d0b5, 0x12f),
    (0x1ade, 0x00d1e4, 0x4c),
    (0x1ae3, 0x00d230, 0x4f),
    (0x1ae7, 0x00d27f, 0x2c),
    (0x1aea, 0x00d2ab, 0x112),
    (0x1afb, 0x00d3bd, 0x53),
    (0x1b01, 0x00d410, 0x210),
    (0x1b22, 0x00d620, 0xa3),
    (0x1b2c, 0x00d6c3, 0x6b),
    (0x1b32, 0x00d72e, 0xc2),
    (0x1b3f, 0x00d7f0, 0xf0),
    (0x1b4e, 0x00d8e0, 0x90),
    (0x1b57, 0x00d970, 0x70),
    (0x1b5e, 0x00d9e0, 0x120),
    (0x1b70, 0x00db00, 0x80),
    (0x1b78, 0x00db80, 0x130),
    (0x1b8b, 0x00dcb0, 0x24),
    (0x1b8d, 0x00dcd4, 0x1c),
    (0x1b8f, 0x00dcf0, 0xf0),
    (0x1b9e, 0x00dde0, 0xc0),
    (0x1baa, 0x00dea0, 0xf0),
    (0x1bb9, 0x00df90, 0x20),
    (0x1bbb, 0x00dfb0, 0x10),
    (0x1bbc, 0x00dfc0, 0x70),
    (0x1bc3, 0x00e030, 0x70),
    (0x1bca, 0x00e0a0, 0xa0),
    (0x1bd4, 0x00e140, 0x90),
    (0x1bdd, 0x00e1d0, 0x180),
    (0x1bf5, 0x00e350, 0x103),
    (0x1c05, 0x00e453, 0xd),
    (0x1c06, 0x00e460, 0x66),
    (0x1c0c, 0x00e4c6, 0x41),
    (0x1c10, 0x00e507, 0x15),
    (0x1c11, 0x00e51c, 0x164),
    (0x1c28, 0x00e680, 0x20),
    (0x1c2a, 0x00e6a0, 0x40),
    (0x1c2e, 0x00e6e0, 0x80),
    (0x1c36, 0x00e760, 0x200),
    (0x1c56, 0x00e960, 0x2d0),
    (0x1c83, 0x00ec30, 0x60),
    (0x1c89, 0x00ec90, 0x210),
    (0x1caa, 0x00eea0, 0x2e0),
    (0x1cd8, 0x00f180, 0x200),
    (0x1cf8, 0x00f380, 0xd0),
    (0x1d05, 0x00f450, 0xc0),
    (0x1d11, 0x00f510, 0xb0),
    (0x1d1c, 0x00f5c0, 0x12),
    (0x1d1d, 0x00f5d0, 0x329e),  # actual block start at 1d1d:0002 = file 0xf5d2
    (0x2047, 0x012870, 0x125),
    (0x2059, 0x012995, 0x5b),
    (0x205f, 0x0129f0, 0x76),
    (0x2066, 0x012a66, 0x6a),
    (0x206d, 0x012ad0, 0x70),
    (0x2074, 0x012b40, 0x80),
    (0x207c, 0x012bc0, 0x90),
    (0x2085, 0x012c50, 0x3c),
    (0x2088, 0x012c8c, 0xbe),
    (0x2094, 0x012d4a, 0x56),
    (0x209a, 0x012da0, 0x6d),
    (0x20a0, 0x012e0d, 0x48),
    (0x20a5, 0x012e55, 0x5ab),
    (0x2100, 0x013400, 0x3a),
    (0x2103, 0x01343a, 0x96),
    (0x210d, 0x0134d0, 0x5de0),
    (0x26eb, 0x0192b0, 0x420),
    (0x272d, 0x0196d0, 0x280),
    (0x2755, 0x019950, 0x80),
    (0x275d, 0x0199d0, 0xc20),
    (0x281f, 0x01a5f0, 0x2000),
    (0x2a1f, 0x01c5f0, 0x1000),
    (0x2b1f, 0x01d5f0, 0x10),
    (0x2b20, 0x01d600, 0x20),
    (0x2b22, 0x01d620, 0x380),
    (0x2b5a, 0x01d9a0, 0x2cc5),
]


def file_to_segoff(file_offset: int) -> str:
    """Convert file offset to Ghidra segment:offset string."""
    for paragraph, file_start, length in SEGMENT_MAP:
        if file_start <= file_offset < file_start + length:
            offset_in_seg = file_offset - file_start
            # Adjust for blocks that don't start at offset 0
            # (e.g., 1d1d:0002 starts the block, so file_start is 1d1d:0000 conceptually)
            return "%04x:%04x" % (paragraph, offset_in_seg)
    return "(unknown)"


# MOV reg, imm16 instruction patterns: opcode = 0xB8 + reg_index
MOV_REG_IMM = {
    0xB8: "MOV AX,",
    0xB9: "MOV CX,",
    0xBA: "MOV DX,",
    0xBB: "MOV BX,",
    0xBC: "MOV SP,",
    0xBD: "MOV BP,",
    0xBE: "MOV SI,",
    0xBF: "MOV DI,",
}

PUSH_IMM16 = 0x68   # PUSH imm16 (80186+)
CMP_AX_IMM = 0x3D   # CMP AX, imm16


def main(target: int) -> int:
    data = EXE.read_bytes()
    target_lo = target & 0xFF
    target_hi = (target >> 8) & 0xFF

    print(f"Searching for references to immediate 0x{target:04x} "
          f"({target_lo:02x} {target_hi:02x} little-endian)")
    print(f"in VICEROY.EXE ({len(data)} bytes)\n")

    # Scan every byte position; check if the byte+1,+2 pattern matches an
    # instruction that loads target as immediate operand.
    hits = []
    for i in range(len(data) - 2):
        # MOV reg, imm16  (3-byte instruction: opcode + 2-byte imm)
        if data[i] in MOV_REG_IMM:
            if data[i+1] == target_lo and data[i+2] == target_hi:
                hits.append((i, "MOV", MOV_REG_IMM[data[i]] + f" 0x{target:04x}"))
                continue
        # PUSH imm16 (80186+; 3 bytes)
        if data[i] == PUSH_IMM16:
            if data[i+1] == target_lo and data[i+2] == target_hi:
                hits.append((i, "PUSH", f"PUSH 0x{target:04x}"))
                continue
        # CMP AX, imm16 (3 bytes)
        if data[i] == CMP_AX_IMM:
            if data[i+1] == target_lo and data[i+2] == target_hi:
                hits.append((i, "CMP", f"CMP AX, 0x{target:04x}"))
                continue
        # MOV [mem16], imm16  (6 bytes: C7 06 mem_lo mem_hi imm_lo imm_hi)
        if data[i] == 0xC7 and i+5 < len(data) and data[i+1] == 0x06:
            if data[i+4] == target_lo and data[i+5] == target_hi:
                mem = data[i+2] | (data[i+3] << 8)
                hits.append((i, "MOV_MEM", f"MOV [0x{mem:04x}], 0x{target:04x}"))
                continue
        # CMP r/m16, imm16  (4-byte: 81 /7 imm)  — too noisy, skip
        # AND/OR/XOR with imm16 — skip (rarely used for addresses)

    print(f"Found {len(hits)} candidate references:\n")
    print(f"{'file_off':<10} {'seg:off':<14} {'kind':<10} instruction")
    print("-" * 70)
    for file_offset, kind, mnemonic in hits:
        seg_off = file_to_segoff(file_offset)
        print(f"0x{file_offset:06x}   {seg_off:<14} {kind:<10} {mnemonic}")

    return 0


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(__doc__)
        sys.exit(1)
    sys.exit(main(int(sys.argv[1], 0)))
