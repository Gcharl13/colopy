#!/usr/bin/env python3
"""disv.py FILE_OFFSET [N] [--exe PATH] — disassemble VICEROY.EXE at a file offset.

Load base 0x2400 (the DOS header size), matching the rest of the notes:
    file_offset = load_base + (seg*16 + off)
"""
import sys
import capstone

EXE = "/home/user/colopy/raw/COLONIZE/VICEROY.EXE"
LOAD_BASE = 0x2400

args = [a for a in sys.argv[1:] if not a.startswith("--")]
for i, a in enumerate(sys.argv):
    if a == "--exe":
        EXE = sys.argv[i + 1]
    if a == "--base":
        LOAD_BASE = int(sys.argv[i + 1], 0)

start = int(args[0], 0)
n = int(args[1], 0) if len(args) > 1 else 0x60

data = open(EXE, "rb").read()
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)
for insn in md.disasm(data[start:start + n], start - LOAD_BASE):
    fo = insn.address + LOAD_BASE
    raw = insn.bytes.hex()
    note = ""
    if insn.mnemonic[0] == "j" or insn.mnemonic in ("call", "loop"):
        try:
            tgt = int(insn.op_str, 16)
            note = f"   -> file 0x{tgt + LOAD_BASE:05X}"
        except ValueError:
            pass
    print(f"  {fo:06X}  {raw:<18} {insn.mnemonic} {insn.op_str}{note}")
