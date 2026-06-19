#!/usr/bin/env python3
"""Faithful merge of the 154 C reconstructions (beautiful-maxwell branch) into
ONE file, in file-offset order, with my current function names in the section
banners and a SECOND-PASS reconciliation checklist + auto-detected overlap
conflicts at the top. The C bodies are copied VERBATIM (faithful merge — no
edits); conflicts are only flagged, not resolved.

Output: ghidra_export/VICEROY_decompiled.c
Run:    python3 tools/build_merged_decompile.py
"""
import subprocess, re, json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BRANCH = "origin/claude/beautiful-maxwell-EUu9I"

def git(*a):
    return subprocess.run(["git", *a], cwd=ROOT, capture_output=True, text=True).stdout

# --- my current function names -------------------------------------------------
FUNCS = json.load(open(ROOT / "code/VICEROY/functions.json"))["functions"]
NAME = {int(f["file_offset"], 16): f["name"] for f in FUNCS
        if f.get("name") not in (None, "unknown")}

# --- collect the C reconstruction files ---------------------------------------
files = [f for f in git("ls-tree", "-r", "--name-only", BRANCH).split()
         if re.match(r"viceroy_source/src/.*\.c$", f)]

RANGE = re.compile(r"_([0-9A-Fa-f]{6})_([0-9A-Fa-f]{6})\.c$")
BODY = re.compile(r"\bfunc_0?([0-9A-Fa-f]{4,6})\w*\s*\([^;{]*\)\s*\{")

entries = []          # (start, end, path, text)
recon = {}            # offset -> set(files) that DEFINE a body for it
for cf in files:
    txt = git("show", f"{BRANCH}:{cf}")
    m = RANGE.search(cf)
    if m:
        start, end = int(m.group(1), 16), int(m.group(2), 16)
    else:
        mm = re.search(r"@asm[_a-z]*\s+(?:func_\w*?)?0x([0-9A-Fa-f]{4,6})", txt) \
             or re.search(r"func_0?([0-9A-Fa-f]{4,6})", txt)
        start = int(mm.group(1), 16) if mm else (1 << 30)
        end = None
    entries.append((start, end, cf, txt))
    for b in BODY.finditer(txt):
        recon.setdefault(int(b.group(1), 16), set()).add(cf)

entries.sort(key=lambda e: e[0])

# --- conflicts: same function body defined in 2+ files ------------------------
overlaps = {o: sorted(fs) for o, fs in recon.items() if len(fs) > 1}

# --- curated SECOND-PASS checklist: this session's findings (2026-06-19) that
#     postdate these reconstructions and should be re-checked against them. -----
SECOND_PASS = [
    "func_05C878 treasure: King-cut = tax_rate w/ Cortes else max(5*diff+50, 2*tax) cap 90% (events.md). Older C may say 'per-difficulty fee from 0x8394'.",
    "DGROUP:0x8394 is only a DISPLAYED number in @KINGGALLEON, NOT the cut. Some C calls it the galleon fee.",
    "PowerRecord +0x4C = market SENSITIVITY (u8[16]), not price. Price base 0x53EA = random_int(600,1000) seed (func_0755CC). Drift = func_0305A8.",
    "REF counts: 0x53DA[4] globals are disasm-authoritative; PowerRecord +0x44/45/46 is a two-dump CONFLICT (unresolved) -- see RULINGS 2026-06-19.",
    "Founding-father effects: 19/25 byte-verified (founding_fathers.md). Newly located continuous: Jefferson x2 bells @0x55818, Paine +tax% @0x290FB, Washington auto-promote @0x5C758, Revere musket-defense @0x5CCAA, Franklin peace @0x5834E, Sepulveda +4 conv @0x5E20B, de Soto LCR @0x614CC, de Witt @0x5A469.",
    "Boycott back-tax = commodity_price(good)*500 (func_03334E @0x333AF); +0x20 boycott mask test/set/lift/Fugger-clear byte-verified.",
    "King tax pretext: func_036138 severity = random(1,1000)+(2*sentiment-tax)*5+gold+turn/30; cadence turn>=30, interval 18->9 by era.",
    "Diplomacy: war matrix PowerRecord+0x34 (bit 0x02=war), treaty matrix +0x40 (0x02/0x20/0x40); handlers func_057F4E / func_057DC0.",
    "Map render: tile chain O514=0x685DC / O513=0x681A8 / O512=0x67F50; coast composed at render time, beach band 0x95-0x99; sprite bands per terrain.c (0x40 shore/0x51-0x5E river/0x6D roads/0x96-0x99 coast).",
    "$TERRAIN columns = Movement,Defensive,Improvement,Value + 9 yields; combat terrain-defense = Defensive col (forests 2/Hills 4/Mountains 6) via func_007D3E.",
    "REF growth driver func_03E162: accrual (8*diff+10)*2^era, buy threshold 1800, spend +0x22-=1800.",
]

def names_in(start, end):
    hi = end if end else start + 0x2000
    got = [(o, NAME[o]) for o in NAME if start <= o < hi]
    got.sort()
    return got

out = []
W = out.append
W("/* ============================================================================")
W(" * VICEROY.EXE — MERGED C DECOMPILATION  (faithful merge, ground truth = the EXE)")
W(" * ----------------------------------------------------------------------------")
W(f" * Assembled by tools/build_merged_decompile.py from {len(files)} byte-verified C")
W(f" * reconstructions on branch {BRANCH}, concatenated in FILE-OFFSET order.")
W(" * Bodies are copied VERBATIM. Section banners carry this branch's current")
W(" * function names; the disassembly (VICEROY_annotated.asm / VICEROY.EXE) remains")
W(" * the cited ground truth. Trust tier: C reconstruction (hand-decompiled).")
W(" * ----------------------------------------------------------------------------")
W(" * SECOND-PASS RECONCILIATION CHECKLIST (2026-06-19 findings that may supersede")
W(" * the older reconstructions — verify each against the merged bodies, do NOT")
W(" * assume the C below already reflects them):")
for i, s in enumerate(SECOND_PASS, 1):
    W(f" *   [{i:2d}] {s}")
W(" * ----------------------------------------------------------------------------")
W(f" * AUTO-DETECTED OVERLAP CONFLICTS — {len(overlaps)} function offsets are defined")
W(" *   in MORE THAN ONE source file (duplicate/divergent reconstructions). Resolve")
W(" *   in the second pass; listed here func_OFFSET -> files:")
for o in sorted(overlaps):
    nm = NAME.get(o, "")
    W(f" *   func_{o:06X} {('('+nm+')') if nm else '':30s} : " +
      ", ".join(Path(f).name for f in overlaps[o]))
W(" * ============================================================================ */")
W("")

for start, end, cf, txt in entries:
    rng = f"0x{start:06X}..0x{end:06X}" if end else f"0x{start:06X}.."
    nm = names_in(start, end)
    W("")
    W("/* ##################################################################### */")
    W(f"/* ## SOURCE: {cf}")
    W(f"/* ## range: {rng}")
    if nm:
        lbl = ", ".join(f"{n}@0x{o:06X}" for o, n in nm[:12])
        W(f"/* ## named here: {lbl}")
    W("/* ##################################################################### */")
    W(txt.rstrip())

outp = ROOT / "ghidra_export/VICEROY_decompiled.c"
outp.write_text("\n".join(out))
kb = outp.stat().st_size // 1024
print(f"wrote {outp.relative_to(ROOT)}  ({kb} KB, {len(entries)} source files, "
      f"{len(overlaps)} overlap conflicts flagged, {len(SECOND_PASS)} checklist items)")
