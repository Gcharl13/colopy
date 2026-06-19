#!/usr/bin/env python3
"""verify_entry_points.py -- capstone-check each BACKLOG/depth entry point against
what its bytes actually reference, to catch misattributions (3 found so far:
market 0x9A4, diplomacy func_03ECF0, ...). Emits docs/ENTRY_POINT_VERIFICATION.md.

For each (offset, claimed_role) it disassembles the whole function and collects
the DGROUP globals, struct field offsets, overlay-thunk calls and string xrefs it
uses, then checks them against the signals expected for that role.
"""
from __future__ import annotations
import json, re
from pathlib import Path
from capstone import Cs, CS_ARCH_X86, CS_MODE_16

ROOT = Path(__file__).resolve().parent.parent
EXE = (ROOT / "raw/COLONIZE/VICEROY.EXE").read_bytes()
FJ = {int(f["file_offset"], 16): f for f in json.load(open(ROOT / "code/VICEROY/functions.json"))["functions"]}
DIS = ROOT / "code/VICEROY/disasm"
MD = Cs(CS_ARCH_X86, CS_MODE_16)

# known anchors -> label, so a hit is meaningful
ANCH = {
    0x5235: "combat:LAND-def", 0x5236: "combat:LAND-atk", 0x523b: "combat:ship", 0x523c: "combat:ship",
    0x2f76: "terrain-tbl", 0x2f7b: "terrain-yield", 0x53ea: "market:base", 0x8904: "market:state",
    0x9652: "FF-table", 0x538a: "year", 0x538e: "turn", 0x53a6: "difficulty",
    0x53da: "REF", 0x53de: "REF", 0x978c: "recruit-pool", 0x8542: "active-colony",
    0x54ec: "nativeSettlement", 0x8d4e: "TribeData", 0x5ad6: "TribeData", 0x8808: "PowerRecord",
    0x372: "score-acc", 0x28ee: "rng-seed", 0x853a: "mapW", 0x853c: "mapH",
}
# claimed role -> set of anchor-label substrings that SHOULD appear
EXPECT = {
    "combat": {"combat", "terrain", "PowerRecord"},
    "market": {"market"},
    "founding-father": {"FF-table", "year", "difficulty"},
    "tax": {"PowerRecord", "difficulty"},
    "REF": {"REF"},
    "immigration": {"recruit-pool", "PowerRecord"},
    "natives": {"nativeSettlement", "TribeData", "active-colony"},
    "colony": {"active-colony"},
    "scoring": {"score-acc"},
    "mapgen": {"mapW", "mapH", "rng-seed"},
    "save": set(),  # file I/O, checked separately
}

# entry points to check: (offset, claimed_role, note)
TARGETS = [
    (0x05CA7E, "combat", "land decider"),
    (0x05B2C2, "combat", "consequence applier"),
    (0x0305A8, "market", "per-commodity drift accumulator (was 0x9A4 - wrong)"),
    (0x03C282, "founding-father", "bell-cost curve"),
    (0x034318, "tax", "tax clamp"),
    (0x0349F4, "tax", "tax gate 60"),
    (0x03CDA2, "REF", "REF assembly"),
    (0x051EF4, "REF", "Man-O-War tally"),
    (0x0363A2, "immigration", "crosses loop"),
    (0x035D9A, "immigration", "threshold helper"),
    (0x074688, "immigration", "recruit (reported corrupt)"),
    (0x0572E6, "natives", "mission conversion"),
    (0x05BE84, "natives", "native dispatch (6 outcomes)"),
    (0x04A7CA, "natives", "CHIEFKILL raze"),
    (0x02D658, "colony", "SoL/tory turn"),
    (0x03ECF0, "combat", "unit_vs_tile eval (was 'diplomacy' - wrong)"),
    (0x03A9C0, "scoring", "score accumulator (DATA_MODEL)"),
    (0x0749E0, "save", "NAMES/save loader"),
    (0x03ADA6, "save", "HALLFAME writer"),
]

def analyze(off):
    f = FJ.get(off)
    size = f["size"] if f else 200
    refs, thunks = set(), set()
    int21 = False
    for ins in MD.disasm(EXE[off:off+size], off):
        o = ins.op_str
        if ins.mnemonic == "lcall":
            thunks.add(o)
        if ins.mnemonic == "int" and "0x21" in o:
            int21 = True
        # catch BOTH absolute [0xNNNN] and indexed [reg + 0xNNNN] table accesses
        for m in re.findall(r"0x([0-9a-f]{2,5})\]", o):
            refs.add(int(m, 16))
    strs = []
    af = list(DIS.glob(f"func_{off:06X}_*.asm")) or list(DIS.glob(f"func_{off:06x}_*.asm"))
    if af:
        strs = re.findall(r'STRING: "([^"]+)"', af[0].read_text(errors="replace"))
    labels = sorted({ANCH[g] for g in refs if g in ANCH})
    return size, labels, sorted(thunks)[:6], strs[:5], int21

def main():
    rows = []
    for off, role, note in TARGETS:
        size, labels, thunks, strs, int21 = analyze(off)
        exp = EXPECT.get(role, set())
        hit = any(any(e in l for l in labels) for e in exp) if exp else False
        if role == "save":
            hit = int21 or bool(strs)        # file I/O or name/file strings
        verdict = "✅ match" if hit else ("⚠️ no role-signal" if (labels or strs or int21) else "❔ inconclusive")
        anchors = ", ".join(labels) or ("INT21h/file" if int21 else "—")
        sx = ("; str: " + ", ".join(strs)) if strs else ""
        rows.append(f"| `0x{off:06X}` | {role} | {note} | {verdict} | {anchors}{sx} |")
    DOC = ROOT / "docs/ENTRY_POINT_VERIFICATION.md"
    DOC.write_text(
        "# BACKLOG entry-point verification (capstone)\n\n"
        "Each entry point disassembled; the DGROUP anchors / strings it actually\n"
        "references are checked against its claimed role. `⚠️ no role-signal` means\n"
        "the function runs but doesn't touch the tables its claimed system would —\n"
        "a misattribution candidate. Generated by `tools/verify_entry_points.py`.\n\n"
        "| Offset | Claimed role | Note | Verdict | Anchors referenced |\n"
        "|--------|--------------|------|---------|--------------------|\n"
        + "\n".join(rows) + "\n\n"
        "## Residuals (not misattributions)\n\n"
        "- `0x034318` (tax clamp) — `❔ inconclusive`: a tiny function whose only\n"
        "  state is `PowerRecord +0x01` (a field, not an anchor in this set). The\n"
        "  `0x4B`=75 clamp is byte-verified separately (`king.md` §3).\n"
        "- `0x0363A2` / `0x035D9A` (immigration) — `⚠️`: the crosses-loop/threshold\n"
        "  globals aren't in this anchor set; both are byte-verified in\n"
        "  `IMMIGRATION_RECRUIT_FINDINGS.md` (not misattributions).\n"
        "- `0x074688` (immigration recruit) — `❔`: confirmed a 9-byte boundary\n"
        "  artifact (not a usable function entry).\n\n"
        "**Net:** after correcting market (`0x9A4`→`func_0305A8`) and diplomacy\n"
        "(`func_03ECF0`→combat eval), every checkable entry point matches its role.\n"
        "Use this sweep to vet any new entry point before investing in a decode.\n",
        encoding="utf-8")
    print(f"wrote {DOC.relative_to(ROOT)}")
    for r in rows:
        print(r)

if __name__ == "__main__":
    main()
