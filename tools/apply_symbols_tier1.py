#!/usr/bin/env python3
"""Tier-1 symbolization of the no-comments merged decompile (mechanical, no new RE):
  (a) rename func_<offset> -> my functions.json name (the 90 I have names for);
  (b) replace bare hex address constants (>= 0x1000) with their global / record
      field name from viceroy_symbols.json.
Small ambiguous values (< 0x1000) are intentionally NOT touched to avoid false
positives on plain numbers (0x190 etc. double as loop bounds / divisors).

In:  ghidra_export/VICEROY_decompiled.nocomments.c
Out: ghidra_export/VICEROY_decompiled.named.c   (+ prints a change report)
"""
import re, json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SYM = json.load(open(ROOT / "tools/viceroy_symbols.json"))
FUNCS = json.load(open(ROOT / "code/VICEROY/functions.json"))["functions"]

NAME = {int(f["file_offset"], 16): f["name"] for f in FUNCS
        if f.get("name") not in (None, "unknown")}
GLOBALS = {int(k, 16): v for k, v in SYM["globals"].items()}
WIN = {n: (int(d["base"], 16), int(d["stride"], 16)) for n, d in SYM["record_windows"].items()}
FIELDS = {r: {int(k, 16): v for k, v in fl.items()} for r, fl in SYM["record_fields"].items()}
# span/array-aware field layout: rec -> sorted [(off, name, elemsize, count)]
META = {r: sorted((int(k, 16), v[0], v[1], v[2]) for k, v in fm.items())
        for r, fm in SYM.get("field_meta", {}).items()}
TABLE = {"UnitRecord": "g_unit_table", "AIPersonality": "g_ai_table",
         "NativeSettlement": "g_settle_table", "PowerRecord": "g_power_table",
         "ColonyRecord": "g_colony_table"}

def addr_name(v):
    if v < 0x1000:
        return None                      # skip small ambiguous constants
    if v in GLOBALS:
        return GLOBALS[v]
    for rec, (base, stride) in WIN.items():
        if v == base:
            return TABLE[rec]
        if base < v < base + stride:
            off = v - base
            # span/array-aware: find the field whose [foff, foff+elem*count) covers off
            for foff, name, elem, count in META.get(rec, []):
                if foff <= off < foff + elem * count:
                    if count > 1:
                        return f"{TABLE[rec]}__{name}[{(off - foff) // elem}]"
                    return f"{TABLE[rec]}__{name}"          # scalar (absorbs u16/u32 inner bytes)
            fl = FIELDS.get(rec, {})
            below = [o for o in fl if o < off]
            if below:
                o = max(below); return f"{TABLE[rec]}__{fl[o]}_p{off-o:x}"
    return None

txt = (ROOT / "ghidra_export/VICEROY_decompiled.nocomments.c").read_text()

# (a) function names ----------------------------------------------------------
fn_hits = {}
def sub_func(m):
    off = int(m.group(1), 16)
    if off in NAME:
        fn_hits[NAME[off]] = fn_hits.get(NAME[off], 0) + 1
        return NAME[off]
    return m.group(0)
txt = re.sub(r"\bfunc_0?([0-9A-Fa-f]{4,6})(?:_\w+)?\b", sub_func, txt)

# (b) hex address constants ---------------------------------------------------
hx_hits = {}
def sub_hex(m):
    v = int(m.group(1), 16)
    nm = addr_name(v)
    if nm:
        hx_hits[nm] = hx_hits.get(nm, 0) + 1
        return nm
    return m.group(0)
txt = re.sub(r"\b0x([0-9A-Fa-f]+)\b", sub_hex, txt)

outp = ROOT / "ghidra_export/VICEROY_decompiled.named.c"
outp.write_text(txt)

fn_total = sum(fn_hits.values()); hx_total = sum(hx_hits.values())
print(f"wrote {outp.relative_to(ROOT)}  ({outp.stat().st_size//1024} KB)")
print(f"\nfunction-name substitutions: {len(fn_hits)} distinct, {fn_total} occurrences")
for n, c in sorted(fn_hits.items(), key=lambda x: -x[1]):
    print(f"   {c:4d}  {n}")
print(f"\naddress-constant substitutions: {len(hx_hits)} distinct, {hx_total} occurrences")
for n, c in sorted(hx_hits.items(), key=lambda x: -x[1]):
    print(f"   {c:4d}  {n}")
