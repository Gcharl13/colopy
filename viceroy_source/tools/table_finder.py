#!/usr/bin/env python3
"""
table_finder.py — data-driven census of array accesses into the *initialized*
DGROUP window, so embedded data tables are found by their ACCESSORS (the right
way) rather than guessed offsets (the prior sessions' mistake).

For every instruction across the code + overlay regions:
  - record memory operands `[base + disp16]` / `[base + index + disp16]` whose
    disp16 lands in the initialized DGROUP window DS[0x80 .. 0x2CC5);
  - record `imul reg, r/m, imm` strides;
  - attribute the nearest preceding imul-stride to each indexed read.

Output: the hot table bases (disp values with many access sites), each with the
stride(s) seen, access count, and a byte/word preview of the data — i.e. the
embedded tables and their element sizes.
"""
import sys
from collections import defaultdict

import capstone
from viceroy_exe import EXE

DG_BASE = 0x1D9A0
DG_INIT_LO = 0x0080      # skip very-low scalars/format-context
DG_INIT_HI = 0x2CC5      # end of initialized image (overlay start)
INDEX_REGS = {"bx", "si", "di", "bp"}


def main(argv):
    exe = EXE()
    md = EXE._mdisasm()
    d = exe.data

    accesses = defaultdict(list)     # disp -> [foff,...]
    disp_strides = defaultdict(lambda: defaultdict(int))  # disp -> {stride:count}

    for start, end in [(exe.load_base, exe.image_len), (exe.image_len, len(d))]:
        recent_imul = None           # (stride, addr)
        for ins in md.disasm(d[start:end], start):
            # track recent imul stride
            if ins.mnemonic == "imul":
                ops = ins.operands
                if ops and ops[-1].type == capstone.x86.X86_OP_IMM:
                    recent_imul = (ops[-1].imm, ins.address)
            # examine memory operands
            for op in ins.operands:
                if op.type == capstone.x86.X86_OP_MEM:
                    m = op.mem
                    disp = m.disp & 0xFFFF
                    base = ins.reg_name(m.base) if m.base else None
                    index = ins.reg_name(m.index) if m.index else None
                    if (base in INDEX_REGS or index in INDEX_REGS) and \
                       DG_INIT_LO <= disp < DG_INIT_HI:
                        accesses[disp].append(ins.address)
                        if recent_imul and (ins.address - recent_imul[1]) <= 40:
                            disp_strides[disp][recent_imul[0]] += 1

    # rank by number of access sites
    hot = sorted(accesses.items(), key=lambda kv: -len(kv[1]))
    print(f"hot DGROUP table bases (init window), top {min(40,len(hot))}:\n")
    print(f"{'DS_off':>7} {'file':>8} {'#acc':>5}  strides            preview(words)")
    for disp, sites in hot[:40]:
        foff = DG_BASE + disp
        strides = disp_strides.get(disp, {})
        sstr = ",".join(f"{s}x{c}" for s, c in sorted(strides.items(), key=lambda x:-x[1])[:4]) or "-"
        words = " ".join(f"{exe.u16(foff+2*k):04x}" for k in range(8))
        print(f" 0x{disp:04x} 0x{foff:06x} {len(sites):5d}  {sstr:18} {words}")

    if len(argv) > 1:
        disp = int(argv[1], 0)
        foff = DG_BASE + disp
        print(f"\n--- access sites for DS 0x{disp:04x} (file 0x{foff:06x}) ---")
        for a in accesses[disp][:40]:
            print(f"  @0x{a:06x}: {exe.disasm_str(a, 8).splitlines()[0]}")


if __name__ == "__main__":
    main(sys.argv)
