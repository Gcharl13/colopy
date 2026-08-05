#!/usr/bin/env python3
"""Carry MAPEDIT.EXE's CodeView function names across to VICEROY.EXE.

MAPEDIT ships an NB02 CodeView publics table (1071 names, 203 modules --
`data_extracted/mapedit_symbols.json`); VICEROY ships none. The two programs
were built by the same team against the same in-house C library, so a large
number of MAPEDIT's named functions are the *same compiled C* sitting in
VICEROY under no name at all. That was established by hand for `menu.obj`
(RULINGS 2026-07-30) and `cycle_1.c` / `timer_1.c` / `timer_3.ASM`
(RULINGS 2026-08-05, both traced instruction for instruction). This does it
systematically.

## Method

The two builds differ in memory model and in every absolute address: DGROUP
offsets, segment values in far calls, and any address-valued immediate. What
does NOT differ, for the same source through the same compiler, is the
instruction sequence -- opcode, ModRM and SIB, in order. So an instruction is
fingerprinted as its encoding with the displacement and immediate fields
*deleted* (deleted, not zeroed, so a 2-byte and 4-byte form of the same operand
still compare equal).

Matching is two stages:

1. **Candidates** -- index both sides by the fingerprint of their first 16
   instructions. Cheap, and narrows 606 x 1250 to a handful per function.

2. **Verification by extension** -- for each candidate, disassemble both sides
   forward from their entry points, ignoring the recorded function boundaries
   entirely, and count how many leading instructions agree. This is the whole
   point: VICEROY's boundaries come from a scan and are often wrong, while a
   shared compiler prologue makes unrelated functions look alike for a dozen
   instructions. The agreed run length is a measurement, not an assumption.

A match is `exact` when the agreed run covers MAPEDIT's entire function -- i.e.
VICEROY contains that function's complete instruction stream, byte structure for
byte structure. Anything shorter is reported as `partial` with its run length
and is NOT a name assignment; those are leads, most of them shared prologues.
Both sides must also be unique: one MAPEDIT function and one VICEROY function
per fingerprint.

## Status of the output

Per CLAUDE.md this is EVIDENCE, not a ruling. An `exact` match says "these two
functions are the same code", which is a fact about bytes. It does not by itself
say the VICEROY copy is *called* the same way -- that still needs the call-site
trace, exactly as `cycle_colors` did (same code as MAPEDIT's, but reached
through a different thunk and installed by a different caller).
"""
import argparse
import json
from collections import defaultdict
from pathlib import Path
import re

import capstone

ROOT = Path(__file__).resolve().parents[1]
MAPEDIT = ROOT / "raw/COLONIZE/MAPEDIT.EXE"
VICEROY = ROOT / "raw/COLONIZE/VICEROY.EXE"
NAMED = ROOT / "code/MAPEDIT/disasm_named"
VFUNCS = ROOT / "code/VICEROY/functions.json"
OUT = ROOT / "data_extracted/viceroy_named_from_mapedit.json"

CAND_INSNS = 16          # stage-1 candidate window

# `; ---- _name  file 0xAAAAAA..0xBBBBBB  seg 0xS:0xO  (module) ----`
HDR = re.compile(
    r"^; ---- (\S+)\s+file 0x([0-9A-Fa-f]+)\.\.0x([0-9A-Fa-f]+)\s+"
    r"seg 0x([0-9A-Fa-f]+):0x([0-9A-Fa-f]+)\s+\((.+?)\)")

_md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)
_md.detail = True


def masked(insn):
    """Instruction encoding with displacement and immediate fields removed."""
    e = insn.encoding
    drop = set()
    if e.disp_size:
        drop.update(range(e.disp_offset, e.disp_offset + e.disp_size))
    if e.imm_size:
        drop.update(range(e.imm_offset, e.imm_offset + e.imm_size))
    return bytes(v for i, v in enumerate(insn.bytes) if i not in drop)


def stream(blob, start, limit_insns, limit_bytes=4096):
    """Masked instruction stream from `start`, stopping at a decode gap."""
    out, pos = [], 0
    code = blob[start:start + limit_bytes]
    for insn in _md.disasm(code, 0):
        if insn.address != pos:
            break
        out.append(masked(insn))
        pos += insn.size
        if len(out) >= limit_insns:
            break
    return out


def agreed_run(a, b):
    n = 0
    for x, y in zip(a, b):
        if x != y:
            break
        n += 1
    return n


def mapedit_functions():
    """(name, module, file_start, file_end) for every named MAPEDIT function."""
    funcs = []
    for asm in sorted(NAMED.glob("*.asm")):
        for line in asm.read_text(errors="replace").splitlines():
            m = HDR.match(line)
            if m:
                name, a, b, seg, off, mod = m.groups()
                funcs.append((name, mod, int(a, 16), int(b, 16)))
    return funcs


def viceroy_functions():
    d = json.load(open(VFUNCS))["functions"]
    return [(f.get("name") or "", int(f["file_offset"], 16), f["size"],
             f.get("region", "")) for f in d if f.get("size")]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--min-insns", type=int, default=CAND_INSNS,
                    help=f"skip functions shorter than this (default {CAND_INSNS})")
    ap.add_argument("--write", action="store_true", help="write the JSON output")
    args = ap.parse_args()

    mb, vb = MAPEDIT.read_bytes(), VICEROY.read_bytes()
    mfun, vfun = mapedit_functions(), viceroy_functions()
    print(f"MAPEDIT named functions : {len(mfun)}")
    print(f"VICEROY functions       : {len(vfun)}")

    # ---- stage 1: candidates by shared 16-instruction prologue fingerprint
    def head_index(entries, blob, start_of):
        idx = defaultdict(list)
        for e in entries:
            s = stream(blob, start_of(e), CAND_INSNS)
            if len(s) < args.min_insns:
                continue
            idx[b"".join(s)].append(e)
        return idx

    mi = head_index(mfun, mb, lambda e: e[2])
    vi = head_index(vfun, vb, lambda e: e[1])
    cand = [(k, mi[k], vi[k]) for k in mi if k in vi]
    print(f"candidate fingerprints  : {len(cand)}")

    # ---- stage 2: verify by extension, ignoring the recorded boundaries
    exact, partial, ambiguous = [], [], []
    for _, mlist, vlist in cand:
        if len(mlist) != 1 or len(vlist) != 1:
            ambiguous.append((mlist, vlist))
            continue
        (mname, mmod, ms, me), = mlist
        (vname, vs, vsize, vregion), = vlist
        want = stream(mb, ms, 1 << 20, me - ms)
        got = stream(vb, vs, len(want) + 4)
        run = agreed_run(want, got)
        rec = {
            "mapedit": {"name": mname, "module": mmod,
                        "file_offset": f"0x{ms:06X}", "size": me - ms,
                        "instructions": len(want)},
            "viceroy": {"name": vname, "file_offset": f"0x{vs:06X}",
                        "size": vsize, "region": vregion},
            "agreed_instructions": run,
        }
        if run == len(want) and run >= args.min_insns:
            rec["kind"] = "exact"
            exact.append(rec)
        else:
            rec["kind"] = "partial"
            partial.append(rec)

    exact.sort(key=lambda r: -r["agreed_instructions"])
    partial.sort(key=lambda r: -r["agreed_instructions"])
    print(f"EXACT (whole function)  : {len(exact)}")
    print(f"partial (prologue only) : {len(partial)}")
    print(f"ambiguous (n:m)         : {len(ambiguous)}")

    agree = [r for r in exact if r["viceroy"]["name"] not in ("", "unknown")]
    print(f"\nexact matches where VICEROY already carried a name: {len(agree)}")
    for r in agree:
        print(f"  {r['agreed_instructions']:4d}i  {r['mapedit']['name']:<26}"
              f"{r['mapedit']['module']:<18} | {r['viceroy']['file_offset']} "
              f"{r['viceroy']['name']}")

    bymod = defaultdict(int)
    for r in exact:
        bymod[r["mapedit"]["module"]] += 1
    print("\nexact matches by MAPEDIT module:")
    for mod, n in sorted(bymod.items(), key=lambda kv: (-kv[1], kv[0]))[:20]:
        print(f"  {n:4d}  {mod}")

    print("\nlargest exact matches:")
    for r in exact[:30]:
        print(f"  {r['agreed_instructions']:4d}i  {r['mapedit']['name']:<30}"
              f"{r['mapedit']['module']:<18} -> {r['viceroy']['file_offset']} "
              f"{r['viceroy']['name'] or '(unnamed)'}")

    if args.write:
        OUT.write_text(json.dumps({
            "_doc": __doc__.strip(),
            "generated_by": "tools/xmatch_mapedit_viceroy.py",
            "candidate_window_instructions": CAND_INSNS,
            "counts": {"mapedit_named": len(mfun), "viceroy_functions": len(vfun),
                       "exact": len(exact), "partial": len(partial),
                       "ambiguous": len(ambiguous)},
            "exact": exact,
            "partial": partial,
        }, indent=1))
        print(f"\nwrote {OUT}")


if __name__ == "__main__":
    main()
