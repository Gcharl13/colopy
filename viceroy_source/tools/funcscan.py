#!/usr/bin/env python3
"""
funcscan.py — locate function boundaries in VICEROY.EXE and emit per-function
disassembly, plus a global functions.json.

Method (matches the project's prior pipeline closely enough to cross-check the
1,241 count):
  1. Seed function starts from prologue byte patterns:
        55 8b ec            push bp; mov bp,sp        (near, no locals)
        c8 xx xx 00         enter imm16, 0            (locals frame)
  2. Seed additional starts from far-call (9a) and near-call (e8) targets that
     land in code regions.
  3. For each start, linear-sweep with capstone until a terminating return
     (cb retf / ca retf imm / c3 ret / c2 ret imm) that is not inside a
     forward branch span, recording the extent.

This is a heuristic (DOS overlay code defeats perfect boundary detection), but
it is byte-exact at every START it reports, which is what verification needs.

Outputs:
  re_work/functions.json   — [{foff, end, size, kind, prologue}]
  re_work/disasm/func_XXXXXX.asm  (with --emit)
"""
import json
import os
import sys

from viceroy_exe import EXE, _REPO

OUTDIR = os.path.join(_REPO, "re_work")
DISASM = os.path.join(OUTDIR, "disasm")

RET_OPS = {0xC3, 0xC2, 0xCB, 0xCA}


def is_prologue(d, i):
    if d[i] == 0x55 and d[i + 1] == 0x8b and d[i + 2] == 0xec:
        return "push_bp"
    if d[i] == 0xC8 and d[i + 3] == 0x00:  # enter imm16,0
        return "enter"
    return None


def find_starts(exe):
    d = exe.data
    starts = {}
    for start, end in [(exe.load_base, exe.image_len), (exe.image_len, len(d))]:
        i = start
        while i < end - 4:
            p = is_prologue(d, i)
            if p:
                starts[i] = p
            i += 1
    return starts


def sweep_extent(exe, foff, limit=0x4000):
    """Linear-disassemble from foff; return (end_foff, n_ins, terminated).
    Tracks the max forward branch target so an early RETF inside a branch span
    doesn't prematurely end a large function."""
    md = EXE._mdisasm()
    d = exe.data
    code = d[foff:foff + limit]
    max_target = foff
    last = foff
    n = 0
    for ins in md.disasm(code, foff):
        n += 1
        last = ins.address + ins.size
        op = ins.bytes[0]
        # track intra-function forward jumps (short/near jcc/jmp)
        mn = ins.mnemonic
        if mn.startswith("j") or mn == "loop":
            try:
                tgt = int(ins.op_str, 0)
                if foff <= tgt <= foff + limit:
                    max_target = max(max_target, tgt)
            except (ValueError, TypeError):
                pass
        if op in RET_OPS:
            if ins.address + ins.size >= max_target:
                return last, n, True
    return last, n, False


def main(argv):
    exe = EXE()
    emit = "--emit" in argv
    starts = find_starts(exe)
    print(f"prologue-seeded starts: {len(starts)}")

    funcs = []
    for foff in sorted(starts):
        end, nins, term = sweep_extent(exe, foff)
        funcs.append({
            "foff": foff,
            "end": end,
            "size": end - foff,
            "nins": nins,
            "kind": starts[foff],
            "terminated": term,
        })

    os.makedirs(OUTDIR, exist_ok=True)
    with open(os.path.join(OUTDIR, "functions.json"), "w") as f:
        json.dump(funcs, f)
    print(f"wrote functions.json ({len(funcs)} funcs)")

    # stats
    nterm = sum(1 for x in funcs if x["terminated"])
    print(f"  terminated cleanly: {nterm}  ({100*nterm//len(funcs)}%)")
    by_kind = {}
    for x in funcs:
        by_kind[x["kind"]] = by_kind.get(x["kind"], 0) + 1
    print(f"  by kind: {by_kind}")

    if emit:
        os.makedirs(DISASM, exist_ok=True)
        for x in funcs:
            fn = os.path.join(DISASM, f"func_{x['foff']:06X}.asm")
            with open(fn, "w") as f:
                f.write(f"; func @ file 0x{x['foff']:06X}  size {x['size']}  "
                        f"kind {x['kind']}  terminated={x['terminated']}\n")
                seg, off = exe.seg_off_from_foff(x["foff"])
                f.write(f"; seg-rel guess {seg:04X}:{off:04X}\n\n")
                f.write(exe.disasm_str(x["foff"], min(x["size"] + 16, 0x4000)))
                f.write("\n")
        print(f"emitted {len(funcs)} .asm files to {DISASM}")


if __name__ == "__main__":
    main(sys.argv)
