#!/usr/bin/env python3
"""
arity_truth.py -- derive ground-truth call arity for every thunk from its
actual call sites in the disassembly.

For each `lcall 0xSEG, 0xOFF` site across re_work/disasm/*.asm, read the
`add sp, N` that follows (caller cleanup => N/2 stack args) and record the
push operands immediately preceding.  Aggregates a per-thunk arity histogram.
This is the arbiter for Phase 4.3's ~429 "arity mismatch" rows: the stub or
the target prototype is wrong; the call sites cannot be.

Outputs:
  re_work/arity_truth.json   full per-site detail (gitignored)
  docs/ARITY_TRUTH.md        per-thunk summary table (addresses+counts only)

Notes:
  - sites with no `add sp` within 2 instructions are REGISTER/VOID-arg
    conventions (e.g. AX-arg chain walkers): recorded as arity "reg".
  - a thunk with MULTIPLE observed arities is flagged MIXED (usually a
    tail-merged call site or a variadic-style helper) -- human review row.

Usage:  python3 viceroy_source/tools/arity_truth.py [--md-out docs/ARITY_TRUTH.md]
"""
import glob
import json
import os
import re
import sys
from collections import Counter, defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from portlib import REPO, RE_WORK, EXE_PATH, PortIndex, Spans, resolve_thunk

DISASM = os.path.join(RE_WORK, "disasm")
LINE_RX = re.compile(r"^0x([0-9a-f]+)\s+(?:[0-9a-f]{2} )+\s*(.+?)\s*$")
LCALL_RX = re.compile(r"^lcall 0x([0-9a-f]+), 0x([0-9a-f]+)$")
ADDSP_RX = re.compile(r"^add sp, (0x[0-9a-f]+|\d+)$")
PUSH_RX = re.compile(r"^push ")

SEG_WINDOWS = {0x181F, 0x191F, 0x1A1F, 0x0D1D}


def main(argv):
    md_out = os.path.join(REPO, "viceroy_source", "docs", "ARITY_TRUTH.md")
    if "--md-out" in argv:
        md_out = argv[argv.index("--md-out") + 1]

    sites = defaultdict(list)  # (seg,off) -> [{file, addr, arity, pushes}]
    for path in sorted(glob.glob(os.path.join(DISASM, "*.asm"))):
        lines = []
        for raw in open(path, errors="ignore"):
            m = LINE_RX.match(raw.rstrip())
            if m:
                lines.append((int(m.group(1), 16), m.group(2)))
        for i, (addr, mn) in enumerate(lines):
            m = LCALL_RX.match(mn)
            if not m:
                continue
            seg, off = int(m.group(1), 16), int(m.group(2), 16)
            if seg not in SEG_WINDOWS:
                continue
            # cleanup: add sp within the next 2 instructions
            arity = "reg"
            for j in (1, 2):
                if i + j < len(lines):
                    am = ADDSP_RX.match(lines[i + j][1])
                    if am:
                        arity = int(am.group(1), 0) // 2
                        break
            # preceding contiguous pushes
            pushes = 0
            k = i - 1
            while k >= 0 and PUSH_RX.match(lines[k][1]):
                pushes += 1
                k -= 1
            sites[(seg, off)].append(
                {"file": os.path.basename(path), "addr": addr,
                 "arity": arity, "pushes": pushes}
            )

    spans = Spans()
    ports = PortIndex()
    exe = open(EXE_PATH, "rb").read() if os.path.exists(EXE_PATH) else None

    rows = []
    for (seg, off), ss in sorted(sites.items()):
        hist = Counter(s["arity"] for s in ss)
        if len(hist) > 1:
            dom, domn = hist.most_common(1)[0]
            # tail-call sites defer cleanup to the epilogue and show as 'reg';
            # call out the dominant arity so most MIXED rows resolve at a glance
            verdict = f"MIXED(dom={dom}:{domn}/{len(ss)})"
        else:
            verdict = str(next(iter(hist)))
        target = name = status = "?"
        if exe is not None:
            kind, tfoff, detail = resolve_thunk(seg, off, exe)
            if tfoff is not None:
                target = f"0x{tfoff:05X}"
                sp = spans.at(tfoff)
                if sp:
                    rec = ports.lookup(sp[0])
                    if rec["definitions"]:
                        name, status = rec["definitions"][0]["name"], "PORTED"
                    elif rec["externs"]:
                        name, status = rec["externs"][0]["name"], "EXTERN"
                    else:
                        name, status = spans.name(sp[0]), "UNPORTED"
            else:
                target = f"unres({detail})"
        rows.append(
            {"thunk": f"0x{seg:04X}:0x{off:04X}", "sites": len(ss),
             "arity": verdict,
             "hist": {str(k): v for k, v in sorted(hist.items(), key=str)},
             "target": target, "name": name, "status": status}
        )

    os.makedirs(RE_WORK, exist_ok=True)
    json.dump(
        {"rows": rows,
         "sites": {f"0x{s:04X}:0x{o:04X}": v for (s, o), v in sites.items()}},
        open(os.path.join(RE_WORK, "arity_truth.json"), "w"), indent=1)

    mixed = [r for r in rows if r["arity"].startswith("MIXED")]
    with open(md_out, "w") as f:
        f.write("# ARITY_TRUTH -- ground-truth thunk arity from call sites\n\n")
        f.write("Auto-generated by `tools/arity_truth.py` from the disasm "
                "call sites (`add sp, N` caller cleanup = N/2 args). "
                "This table is the arbiter for every Phase-4.3 arity "
                "reconciliation; addresses and counts only.\n\n")
        f.write(f"- thunks observed called: **{len(rows)}**\n")
        f.write(f"- single consistent arity: **{len(rows) - len(mixed)}**\n")
        f.write(f"- MIXED (human review): **{len(mixed)}**\n\n")
        f.write("| thunk | sites | arity | target | name | status |\n")
        f.write("|---|--:|---|---|---|---|\n")
        for r in rows:
            f.write(f"| `{r['thunk']}` | {r['sites']} | {r['arity']} "
                    f"| {r['target']} | `{r['name']}` | {r['status']} |\n")
        if mixed:
            f.write("\n## MIXED rows (arity histogram)\n\n")
            for r in mixed:
                f.write(f"- `{r['thunk']}` -> {r['hist']}  ({r['name']})\n")
    print(f"thunks: {len(rows)}  mixed: {len(mixed)}")
    print(f"wrote re_work/arity_truth.json and {os.path.relpath(md_out, REPO)}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
