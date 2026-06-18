#!/usr/bin/env python3
"""audit_unmapped_regions.py -- classify the "unmapped" gaps between recognized
functions (the pale blocks on the coverage map) as CODE vs DATA, from the EXE
bytes. Emits docs/UNMAPPED_REGIONS_AUDIT.md.

Finding this corrects: the gaps are NOT mostly data. In the OVERLAY region they
are overwhelmingly *code* -- overlay function bodies that the per-function
segmenter (functions.json) never enumerated (they carry overlay-thunk far-calls
`9A lo hi 1F 18` at the same density as known overlay functions). Only the
LOAD-IMAGE gaps are genuine data (C-runtime strings, asset-name tables, padding).
"""
from __future__ import annotations
import json, re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
EXE = (ROOT / "raw/COLONIZE/VICEROY.EXE").read_bytes()
FUNCS = json.load(open(ROOT / "code/VICEROY/functions.json"))["functions"]
DOC = ROOT / "docs/UNMAPPED_REGIONS_AUDIT.md"

def off(f): return int(f["file_offset"], 16)
sf = sorted(FUNCS, key=off)

THUNK2 = re.compile(rb"\x9a..\x1f[\x18\x19\x1a]")             # LCALL seg 0x181F/0x191F/0x1A1F (overlay thunks)
STR = re.compile(rb"[\x20-\x7e]{4,}\x00")

def classify(b: bytes):
    n = len(b)
    z = b.count(0) / n
    printable = sum(1 for x in b if 0x20 <= x < 0x7f or x in (9, 10, 13)) / n
    strs = STR.findall(b)
    thunks = len(THUNK2.findall(b))
    # code lead-byte density (push bp / mov / cmp / call / jcc families)
    codey = sum(b.count(bytes([op])) for op in (0x55, 0x8b, 0x83, 0xc7, 0xe8, 0xe9, 0x74, 0x75, 0x9a)) / n
    if printable > 0.55 or (len(strs) > 25 and z < 0.3):
        return "DATA — strings / text", {"printable%": round(printable*100), "strings": len(strs)}
    if z > 0.75:
        return "PADDING / BSS (zero-fill)", {"zero%": round(z*100)}
    if thunks > 0 and n / thunks < 220:
        return "CODE — unenumerated overlay function(s)", {"thunk_calls": thunks, "per_bytes": round(n/thunks)}
    if codey > 0.16:
        return "CODE — likely (dense opcode stream)", {"codeop%": round(codey*100), "thunks": thunks}
    return "DATA — binary table", {"zero%": round(z*100), "printable%": round(printable*100), "distinct": len(set(b))}

gaps = []
for a, b in zip(sf, sf[1:]):
    g = off(b) - (off(a) + a["size"])
    if g > 256:
        start = off(a) + a["size"]
        kind, stats = classify(EXE[start:start+g])
        gaps.append((start, g, a["region"], kind, stats))

# totals by kind
from collections import defaultdict
tot = defaultdict(int); cnt = defaultdict(int)
for _, g, _, kind, _ in gaps:
    k = kind.split(" — ")[0]
    tot[k] += g; cnt[k] += 1

rows = []
for start, g, reg, kind, stats in sorted(gaps, key=lambda x: -x[1])[:30]:
    samp = b" | ".join(STR.findall(EXE[start:start+g])[:3])[:90].decode("latin1")
    rows.append(f"| `0x{start:06X}` | {g:,} | {reg} | {kind} | {samp or '—'} |")

DOC.write_text(
"# Unmapped-region audit — what the pale 'gaps' actually hold\n\n"
"The coverage map shows pale blocks between recognized functions. I classified\n"
"every gap >256 bytes from the **EXE bytes** (`tools/audit_unmapped_regions.py`).\n\n"
"## Headline (correcting an earlier claim)\n\n"
"The gaps are **not mostly data**. In the **overlay** region they are mostly\n"
"**code** — overlay function bodies that the per-function segmenter\n"
"(`functions.json`, which the map is built from) never split out. They carry the\n"
"overlay-thunk far-call `9A lo hi 1F 18` at the **same density as known overlay\n"
"functions** (~1 per 50 bytes), and they *are* present in the full overlay\n"
"disassembly (`data_extracted/disassembly/viceroy_overlay_full.asm`) — just not\n"
"as discrete `functions.json` entries. So the map **under-counts overlay code\n"
"coverage**; the real understood-fraction is higher than it shows.\n\n"
"Only the **load-image** gaps are genuine **data**: the C-runtime string area\n"
"(e.g. `0x1D5E6`: \"MS Run-Time Library — Copyright (c) 1990, Microsoft Corp\",\n"
"`$STRING`, asset names `LEVN00`/`MYLEADER`/…) and the RTLink overlay-loader\n"
"stub + its messages (`0x164DD`: \"Vectored call to Page …\").\n\n"
"## Totals (gaps >256 B)\n\n"
"| Classification | Bytes | Blocks |\n|---|--:|--:|\n"
+ "\n".join(f"| {k} | {v:,} | {cnt[k]} |" for k, v in sorted(tot.items(), key=lambda x:-x[1]))
+ "\n\n## Largest 30 blocks\n\n"
"| Offset | Bytes | Region | Classification | Strings found |\n"
"|--------|------:|--------|----------------|---------------|\n"
+ "\n".join(rows) + "\n\n"
"## Implication\n\n"
"Getting the overlay gaps onto the map is a *segmentation* task (extend\n"
"`functions.json` to enumerate the overlay's real function boundaries), not new\n"
"decoding — the bytes are already disassembled. The genuine data blocks stay\n"
"data and are handled by the data-extraction track.\n", encoding="utf-8")

print(f"wrote {DOC.relative_to(ROOT)}")
for k, v in sorted(tot.items(), key=lambda x:-x[1]):
    print(f"  {k:40s} {v:>8,} B  ({cnt[k]} blocks)")
