#!/usr/bin/env python3
"""
decode_sheet.py -- generate an ANNOTATED decode sheet for a disasm range.

This automates the per-body manual decode loop: for every line in the range
it resolves thunk calls to their ported names, names DGROUP globals and
unit-table fields, reconstructs push-sequence call arguments, labels jump
targets, and tallies [bp+/-X] local usage -- i.e. the sheet a porter
otherwise builds by hand before writing any C.

Output goes to re_work/sheets/ (gitignored: sheets quote original bytes).

Usage:
  python3 viceroy_source/tools/decode_sheet.py 0x50E20 0x50EC8
  python3 viceroy_source/tools/decode_sheet.py func_05CA7E          # whole fn
  python3 viceroy_source/tools/decode_sheet.py 0x4F883 0x50583 --locals tools/locals/func_04E2D6.json
"""
import json
import os
import re
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from portlib import (
    EXE_PATH,
    RE_WORK,
    PortIndex,
    Spans,
    dgroup_name,
    resolve_thunk,
)

LINE_RX = re.compile(r"^0x([0-9a-f]+)\s+((?:[0-9a-f]{2} )+)\s*(.+?)\s*$")
LCALL_RX = re.compile(r"lcall 0x([0-9a-f]+), 0x([0-9a-f]+)")
NEARCALL_RX = re.compile(r"\bcall 0x([0-9a-f]+)")
JUMP_RX = re.compile(r"\b(?:jmp|ja|jae|jb|jbe|jc|je|jg|jge|jl|jle|jne|jno|jnp|jns|jo|jp|js|jcxz|loop\w*) 0x([0-9a-f]+)")
ABSMEM_RX = re.compile(r"\[0x([0-9a-f]+)\]")
DISP_RX = re.compile(r"\[(?:bx|si|di|bp|bx \+ si|bx \+ di|bp \+ si|bp \+ di)\s*([+-])\s*0x([0-9a-f]+)\]")
BPLOCAL_RX = re.compile(r"\[bp ([+-]) (0x[0-9a-f]+|\d)\]")
PUSH_RX = re.compile(r"^push (.+)$")
ADDSP_RX = re.compile(r"^add sp, (0x[0-9a-f]+|\d+)$")

WRITE_OPS = {"mov", "add", "sub", "adc", "sbb", "inc", "dec", "and", "or",
             "xor", "shl", "shr", "sar", "rol", "ror", "neg", "not"}


def parse_lines(path):
    out = []
    for raw in open(path, errors="ignore"):
        m = LINE_RX.match(raw.rstrip())
        if m:
            out.append((int(m.group(1), 16), m.group(2).strip(), m.group(3)))
    return out


def annotate_mem(mn):
    """names for absolute and displacement memory operands in one mnemonic."""
    notes = []
    for m in ABSMEM_RX.finditer(mn):
        nm = dgroup_name(int(m.group(1), 16))
        if nm:
            notes.append(f"[0x{m.group(1)}]={nm}")
    for m in DISP_RX.finditer(mn):
        disp = int(m.group(2), 16)
        eff = disp if m.group(1) == "+" else (0x10000 - disp) & 0xFFFF
        nm = dgroup_name(eff)
        if nm:
            notes.append(f"{m.group(1)}0x{m.group(2)}->0x{eff:04X}={nm}")
    return notes


def main(argv):
    args = [a for a in argv if not a.startswith("--")]
    locals_map = {}
    if "--locals" in argv:
        locals_map = {
            k.lower(): v
            for k, v in json.load(open(argv[argv.index("--locals") + 1])).items()
        }

    spans = Spans()
    ports = PortIndex()
    exe = open(EXE_PATH, "rb").read()

    if len(args) == 1 and args[0].startswith("func_"):
        start = int(args[0][5:11], 16)
        lo, hi = spans.at(start)
    else:
        lo, hi = int(args[0], 16), int(args[1], 16)

    # spans nest (false starts inside large bodies): use the containing span
    # whose disasm file actually has an instruction at `lo`
    fstart = fend = None
    lines = []
    for s, e in spans.all_at(lo):
        path = spans.disasm_path(s)
        if not os.path.exists(path):
            continue
        cand = [l for l in parse_lines(path) if lo <= l[0] < hi]
        if cand and cand[0][0] == lo:
            fstart, fend, lines = s, e, cand
            break
        if cand and not lines:
            fstart, fend, lines = s, e, cand
    if not lines:
        print(f"no disasm lines for 0x{lo:05X}..0x{hi:05X} in any containing span")
        return 1
    stem = spans.name(fstart)

    # pass 1: jump targets, locals tally
    jtargets = defaultdict(list)
    locals_seen = defaultdict(lambda: {"r": 0, "w": 0, "first": None})
    for addr, _, mn in lines:
        for m in JUMP_RX.finditer(mn):
            jtargets[int(m.group(1), 16)].append(addr)
        op = mn.split()[0]
        for m in BPLOCAL_RX.finditer(mn):
            key = f"bp{m.group(1)}{m.group(2)}"
            ent = locals_seen[key.lower()]
            # write when the [bp..] operand is the destination (before comma)
            dest = mn.split(",")[0]
            if op in WRITE_OPS and m.group(0) in dest:
                ent["w"] += 1
                if ent["first"] is None:
                    ent["first"] = addr
            else:
                ent["r"] += 1

    # pass 2: emit
    os.makedirs(os.path.join(RE_WORK, "sheets"), exist_ok=True)
    out_path = os.path.join(RE_WORK, "sheets", f"{stem}_0x{lo:05X}_0x{hi:05X}.txt")
    out = open(out_path, "w")
    W = out.write
    W(f"DECODE SHEET {stem}  range 0x{lo:05X}..0x{hi:05X}"
      f"  (function span 0x{fstart:05X}..0x{fend:05X})\n")
    W("=" * 78 + "\n\n")

    pushes = []
    for addr, byts, mn in lines:
        # label line if it is a branch target (from inside or outside range)
        if addr in jtargets:
            srcs = ",".join(f"0x{s:05X}" for s in jtargets[addr][:6])
            W(f"\nL_{addr:05X}:                          ; <- from {srcs}\n")
        notes = annotate_mem(mn)

        m = LCALL_RX.search(mn)
        if m:
            seg, off = int(m.group(1), 16), int(m.group(2), 16)
            kind, target, detail = resolve_thunk(seg, off, exe)
            if target is not None:
                tspan = spans.at(target)
                if tspan:
                    rec = ports.lookup(tspan[0])
                    nm = (rec["definitions"] or rec["externs"] or
                          [{"name": spans.name(tspan[0])}])[0]["name"]
                    status = "PORTED" if rec["definitions"] else (
                        "EXTERN" if rec["externs"] else "UNPORTED")
                    notes.append(f"=> {nm} [{status}] file 0x{target:05X}")
                else:
                    notes.append(f"=> file 0x{target:05X} (no fn span)")
            else:
                notes.append(f"=> unresolved [{kind}] {detail}")
            nargs = None
            # peek ahead for add sp, N on the next line
            notes.append("args<=(" + ", ".join(p for p in reversed(pushes)) + ")"
                         if pushes else "args<=()")

        m = NEARCALL_RX.search(mn)
        if m and "lcall" not in mn:
            t = int(m.group(1), 16)
            tspan = spans.at(t)
            if tspan and tspan[0] != fstart:
                notes.append(f"=> near {spans.name(tspan[0])}")

        # local-name substitutions note
        for lm in BPLOCAL_RX.finditer(mn):
            key = f"bp{lm.group(1)}{lm.group(2)}".lower()
            if key in locals_map:
                notes.append(f"{lm.group(0)}={locals_map[key]}")

        jt = JUMP_RX.search(mn)
        if jt:
            t = int(jt.group(1), 16)
            if not (lo <= t < hi):
                tspan = spans.at(t)
                where = spans.name(tspan[0]) if tspan else "?"
                rel = f"+0x{t - tspan[0]:X}" if tspan else ""
                notes.append(f"target OUTSIDE range ({where}{rel})")

        note_s = ("  ; " + " | ".join(notes)) if notes else ""
        W(f"0x{addr:05x}  {mn}{note_s}\n")

        # push tracking (reset at flow changes)
        pm = PUSH_RX.match(mn)
        am = ADDSP_RX.match(mn)
        if pm:
            pushes.append(pm.group(1))
        elif am or mn.startswith(("ret", "leave")):
            pushes = []
        elif LCALL_RX.search(mn) or NEARCALL_RX.search(mn):
            pushes = []
        elif JUMP_RX.search(mn) or addr in jtargets:
            pushes = []

    W("\n" + "=" * 78 + "\nLOCALS ([bp+/-X] usage in range)\n")
    W(f"{'slot':<10}{'reads':>6}{'writes':>7}  {'first-write':<12}known-name\n")
    for key in sorted(locals_seen, key=lambda k: (k[2], k)):
        e = locals_seen[key]
        fw = f"0x{e['first']:05X}" if e["first"] else "-"
        W(f"{key:<10}{e['r']:>6}{e['w']:>7}  {fw:<12}{locals_map.get(key, '')}\n")
    out.close()
    print(f"wrote {out_path}  ({len(lines)} instructions)")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
