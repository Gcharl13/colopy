#!/usr/bin/env python3
"""Tier-2 (clean): expand tools/viceroy_symbols.json with
  (1) correct + complete record field layouts from the reconstruction struct
      headers (fixes UnitRecord base 0x3146 -> 0x3144), and
  (2) scalar global names harvested from #defines, but ONLY for addresses that
      dgroup_map.json confirms the code actually references as DGROUP data
      (whitelist), and never libc/IO flags.

My hand-curated names win on conflict. Writes the merged symbols.json.
"""
import re, json, subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
B = "origin/claude/beautiful-maxwell-EUu9I"
def show(p): return subprocess.run(["git","show",f"{B}:{p}"],cwd=ROOT,capture_output=True,text=True).stdout

SYM = json.load(open(ROOT/"tools/viceroy_symbols.json"))

# (1) record windows + fields from headers ------------------------------------
SYM["record_windows"] = {
    "UnitRecord":       {"base":"0x3144","stride":"0x1C"},   # FIXED (was 0x3146)
    "AIPersonality":    {"base":"0x540E","stride":"0x34"},
    "NativeSettlement": {"base":"0x54EC","stride":"0x12"},
    "ColonyRecord":     {"base":"0x5D46","stride":"0xCA"},
    "PowerRecord":      {"base":"0x8808","stride":"0x13C"},
}
HDR = {"UnitRecord":"unit.h","AIPersonality":"ai_personality.h",
       "NativeSettlement":"native.h","ColonyRecord":"colony.h","PowerRecord":"power.h"}
# capture name, optional [count], type-width, offset
FIELD_LINE = re.compile(
    r"^\s*(?:const\s+)?(u?int(\d+)_t|char)\s+(\w+)(?:\[(\d+)\])?\s*;\s*/\*\s*\+0x([0-9a-fA-F]+)")
fields = {}        # rec -> {offhex: name}            (back-compat)
meta = {}          # rec -> {offhex: [name, elemsize, count]}  (span/array aware)
for rec, hdr in HDR.items():
    fl, ml = {}, {}
    for line in show(f"viceroy_source/include/{hdr}").splitlines():
        m = FIELD_LINE.match(line)
        if not m or m.group(3).startswith("pad"):
            continue
        bits = int(m.group(2)) if m.group(2) else 8
        elem = bits // 8
        count = int(m.group(4)) if m.group(4) else 1
        name, off = m.group(3), int(m.group(5), 16)
        key = f"0x{off:02X}"
        fl.setdefault(key, name)
        ml.setdefault(key, [name, elem, count])
    fields[rec], meta[rec] = fl, ml
# manual: ColonyRecord name string (the pad_02[0x18] block)
meta.setdefault("ColonyRecord", {}).setdefault("0x02", ["name", 1, 0x18])
fields.setdefault("ColonyRecord", {}).setdefault("0x02", "name")
for rec, fl in SYM.get("record_fields", {}).items():       # keep my hand fields too
    for k, v in fl.items():
        fields.setdefault(rec, {}).setdefault(k, v)
        meta.setdefault(rec, {}).setdefault(k, [v, 1, 1])
SYM["record_fields"] = fields
SYM["field_meta"] = meta

# (2) scalar globals: dgroup_map whitelist x #define names --------------------
dgm = json.loads(show("viceroy_source/docs/dgroup_map.json"))
WHITELIST = {a["addr"] for a in dgm.get("addresses", [])}   # ints
LIBC = re.compile(r"^(O_|SEEK_|_O_)|STRIDE$|_BYTES$|_SIZE$")
defines = {}
files = [f for f in subprocess.run(["git","ls-tree","-r","--name-only",B],cwd=ROOT,
         capture_output=True,text=True).stdout.split() if re.search(r"\.(c|h)$", f)]
DEFRE = re.compile(r"#define\s+([A-Za-z_]\w+)\s+0x([0-9a-fA-F]{3,4})\b")
for f in files:
    for m in DEFRE.finditer(show(f)):
        nm, v = m.group(1), int(m.group(2), 16)
        if v not in WHITELIST: continue            # must be a real DGROUP ref
        if LIBC.search(nm): continue               # never libc flags / strides
        prev = defines.get(v)
        sc = lambda s: (1 if re.search(r"_[0-9A-Fa-f]{3,4}$", s) else 0, len(s))
        if prev is None or sc(nm) < sc(prev):
            defines[v] = nm
G = SYM["globals"]
added = 0
for v, nm in defines.items():
    if f"0x{v:X}" not in G and f"0x{v:x}" not in G:        # my curated names win
        G[f"0x{v:X}"] = nm; added += 1

(ROOT/"tools/viceroy_symbols.json").write_text(json.dumps(SYM, indent=2)+"\n")
print(f"globals: {len(G)} (+{added} harvested) | fields: " +
      ", ".join(f"{r}={len(fl)}" for r, fl in fields.items()))
print(f"dgroup_map whitelist size: {len(WHITELIST)} addresses")
