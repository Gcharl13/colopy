#!/usr/bin/env python3
"""
extract_dgroup_map.py -- evidence-based DGROUP address map for VICEROY.

Scans the reconstructed C tree for every reference to a DGROUP (data-segment)
address and classifies it against the known record tables. The output is the
raw material for docs/DGROUP_MEMORY_MAP.md and for the eventual memory-model
refactor (absolute-address poke -> named struct field).

It does NOT guess: each table's *actual* extent is reported as the highest
record index and field offset the code is observed to touch, so boundary
overlaps surface instead of being papered over.

Access kinds detected:
  poke   *(uintN_t near*)0xXXXX        -- real code (the refactor targets these)
  abs    [0xXXXX]                      -- @asm citation, absolute scalar
  idx    [reg+0xXXXX] / [reg+reg+0xXXXX] -- @asm citation, table field offset

Usage:  python3 tools/extract_dgroup_map.py [--json docs/dgroup_map.json]
"""
import glob, re, json, sys, collections

# Known record tables: (name, base, stride, count_global)
# A field is reached via `imul reg,idx,stride; [reg+DISP]` where DISP is the
# table base + field offset (the RECORD index lives in `reg`, not the
# displacement). So a displacement classifies to a table iff it falls in the
# RECORD-0 window [base, base+stride); field = DISP-base. (An earlier wide
# window mis-read 0x543F as UnitRecord[319] instead of AIPersonality+0x31.)
# The physical record COUNT is NOT derivable from displacements; it is tracked
# by the cited count global and must be read from init/alloc code separately.
TABLES = [
    ("UnitRecord",       0x3144, 0x1C, "g_unit_count @0x539C"),
    ("AIPersonality",    0x540E, 0x34, "4 EU powers (init @0x744FE)"),
    ("NativeSettlement", 0x54EC, 0x12, "g_settle_count @0x539A (max 84)"),
    ("ColonyRecord",     0x5D46, 0xCA, "g_colony_count @0x539E"),
    ("PowerRecord",      0x8808, 0x13C, "4 EU (+native slots 4..11)"),
]

POKE = re.compile(r'\*\(\s*(?:const\s+)?u?int(?:8|16|32)_t\s*(?:near|far)?\s*\*\)\s*(0x[0-9A-Fa-f]+)')
ABS  = re.compile(r'\[\s*(0x[0-9A-Fa-f]{3,5})\s*\]')
IDX  = re.compile(r'\[\s*[a-z]{2}(?:\+[a-z]{2})?\+(0x[0-9A-Fa-f]{3,5})\s*\]')

def scan():
    refs = collections.defaultdict(lambda: {"poke":0,"abs":0,"idx":0,"files":set()})
    for pat in ("src/**/*.c", "include/*.h"):
        for f in glob.glob(pat, recursive=True):
            short = f.replace("src/","").replace("include/","inc:")
            for ln in open(f, errors='ignore'):
                for kind, rx in (("poke",POKE),("abs",ABS),("idx",IDX)):
                    for m in rx.finditer(ln):
                        a = int(m.group(1),16)
                        refs[a][kind]+=1; refs[a]["files"].add(short)
    return refs

def classify(addr):
    # record-0 window only: displacement == base + field, field < stride
    for name,base,stride,_ in TABLES:
        if base <= addr < base + stride:
            return name, 0, addr-base
    return None, None, None

def main():
    refs = scan()
    # Per-table observed field set (the displacement is the record-0 field addr)
    table_extent = {n:{"fields":set(),"refs":0} for n,_,_,_ in TABLES}
    scalars = []
    rows = []
    for addr,d in refs.items():
        total = d["poke"]+d["abs"]+d["idx"]
        name,rec,off = classify(addr)
        rows.append((addr,name,rec,off,d["poke"],d["abs"],d["idx"],total,sorted(d["files"])))
        if name:
            te = table_extent[name]
            te["fields"].add(off); te["refs"]+=total
        else:
            scalars.append((addr,total,d["poke"],sorted(d["files"])))
    rows.sort(key=lambda r:r[0])

    print("=== TABLE FIELD WINDOWS (record-0 displacement evidence) ===")
    for name,base,stride,cnt in TABLES:
        te=table_extent[name]
        fields=sorted(te["fields"])
        rng = f"+0x{fields[0]:X}..+0x{fields[-1]:X}" if fields else "(none)"
        print(f"{name:16s} base 0x{base:05X} stride 0x{stride:03X}  window 0x{base:05X}..0x{base+stride:05X}  "
              f"fields {len(fields)} ({rng})  {te['refs']} refs  count={cnt}")
    print("\nField windows are disjoint (no overlaps) -> displacement classification is unambiguous.")
    print("Physical table END = base + stride*COUNT; COUNT lives in the cited global, not in displacements.")

    print(f"\n=== SCALAR GLOBALS: {len(scalars)} distinct (top 30 by refs) ===")
    for addr,total,poke,files in sorted(scalars,key=lambda s:-s[1])[:30]:
        pk = f" POKE x{poke}" if poke else ""
        print(f"  0x{addr:05X}  x{total:<4}{pk}")

    if "--json" in sys.argv:
        out = sys.argv[sys.argv.index("--json")+1]
        payload = {
            "tables":[{"name":n,"base":b,"stride":s,"count":c,
                       "fields_touched":sorted(table_extent[n]["fields"]),
                       "refs":table_extent[n]["refs"]} for n,b,s,c in TABLES],
            "addresses":[{"addr":a,"table":nm,"record":rc,"offset":of,
                          "poke":pk,"abs":ab,"idx":ix,"refs":tot,"files":fl}
                         for a,nm,rc,of,pk,ab,ix,tot,fl in rows],
        }
        json.dump(payload, open(out,"w"), indent=1)
        print(f"\nWrote {out}  ({len(rows)} addresses)")

if __name__=="__main__":
    main()
