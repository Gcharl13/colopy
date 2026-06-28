#!/usr/bin/env python3
"""deoverlay.py — build the flat, RTLink-resolved navigation substrate (INTERNAL, regenerable).

VICEROY.EXE is RTLink/Plus-overlaid: most code lives in 31 overlay pages paged in at runtime via
`lcall SEG:OFF` thunks. This tool flattens the program for *analysis* (not a runnable binary):
it indexes every function (resident load-image + the 31 reseg overlay pages) and resolves every
`lcall` thunk to its named target in one hop, using the already-computed thunk map
(data_extracted/thunk_targets.json, from tools/follow_thunk.py).

Output (code/VICEROY/flat/, regenerable / git-ignored — NOT a spec deliverable):
  func_index.json   {hexFileOffset: func_name}            — every function start
  functions.jsonl   one line/function: {name,file_off,page,region,calls[],globals[],strings[]}
  thunk_resolve.json{"SEG:OFF": {target,target_name,type,page}} — common-segment lcall resolutions

Resolution model (mirrors follow_thunk.py): an `lcall SEG:OFF` references a thunk stub whose file
offset = 0x2400 + SEG*16 + OFF; thunk_targets maps that stub -> target file offset; func_index maps
the target file offset -> the enclosing function name.
"""
import json, re, glob, bisect
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DIS = ROOT / "code/VICEROY/disasm"
RESEG = ROOT / "code/VICEROY/disasm_overlay_reseg"
OUT = ROOT / "code/VICEROY/flat"
THUNKS = json.load(open(ROOT / "data_extracted/thunk_targets.json"))["thunks"]

# ---- 1. function-start index (file_offset -> name) -------------------------------------------
func_index = {}          # int file_off -> name
func_page = {}           # name -> page_id (None = resident load-image)
RESIDENT_RE = re.compile(r"^func_([0-9A-Fa-f]{6})_(.+)\.asm$")
for p in sorted(DIS.glob("func_*.asm")):
    m = RESIDENT_RE.match(p.name)
    if not m:
        continue
    fo = int(m.group(1), 16)
    name = f"func_{m.group(1).upper()}"
    func_index[fo] = name
    func_page[name] = None

HDR_RE = re.compile(r"^; ---- (func_[0-9A-Fa-f]+)\s+size=")
for p in sorted(RESEG.glob("page_*.asm")):
    page_id = int(p.stem.split("_")[1], 16)
    for line in p.read_text(errors="replace").splitlines():
        m = HDR_RE.match(line)
        if m:
            name = m.group(1)
            fo = int(name[5:], 16)
            name = f"func_{name[5:].upper()}"
            func_index[fo] = name
            func_page[name] = page_id

starts = sorted(func_index)            # sorted file offsets for nearest-<= lookup

def enclosing(fo: int):
    """name of the function containing file offset fo (nearest start <= fo)."""
    i = bisect.bisect_right(starts, fo) - 1
    return func_index[starts[i]] if i >= 0 else None

def resolve_lcall(seg: int, off: int):
    stub_fo = 0x2400 + seg * 16 + off
    t = THUNKS.get(f"{stub_fo:06X}")
    if not t:
        return None
    tgt = int(t["target_file_offset"], 16)
    return {"seg": f"{seg:04X}", "off": f"{off:04X}",
            "target": f"0x{tgt:06X}", "target_name": enclosing(tgt),
            "type": t["type"], "page": t.get("page_id"),
            "exact": t.get("known_function_start", False)}

# ---- 2. walk every function, collect resolved calls / globals / strings ----------------------
LCALL_RE = re.compile(r"\blcall\s+0x([0-9a-fA-F]+),\s*0x([0-9a-fA-F]+)", re.I)
GLOBAL_RE = re.compile(r"(?:word|byte|dword) ptr \[0x([0-9a-fA-F]+)\]")
STRING_RE = re.compile(r'STRING:\s*"([^"]*)"')
# file offset at start of a disasm line (both formats begin with optional ws + 6 hex)
LINEFO_RE = re.compile(r"^\s*([0-9A-Fa-f]{6})\b")

def iter_func_bodies():
    """yield (name, page, region, [lines]) for every function in both disasm trees."""
    # resident: one file per function
    for p in sorted(DIS.glob("func_*.asm")):
        m = RESIDENT_RE.match(p.name)
        if not m:
            continue
        name = f"func_{m.group(1).upper()}"
        yield name, None, "load_image", p.read_text(errors="replace").splitlines()
    # overlay: split each page on the func headers
    for p in sorted(RESEG.glob("page_*.asm")):
        page_id = int(p.stem.split("_")[1], 16)
        cur, lines = None, []
        for line in p.read_text(errors="replace").splitlines():
            h = HDR_RE.match(line)
            if h:
                if cur:
                    yield cur, page_id, "overlay", lines
                nm = h.group(1)
                cur = f"func_{nm[5:].upper()}"
                lines = []
            elif cur:
                lines.append(line)
        if cur:
            yield cur, page_id, "overlay", lines

OUT.mkdir(parents=True, exist_ok=True)
seg_resolve = {}
nfunc = ncall = 0
with open(OUT / "functions.jsonl", "w") as fout:
    for name, page, region, lines in iter_func_bodies():
        fo = int(name[5:], 16)
        calls, globals_, strings = [], set(), []
        for line in lines:
            for seg, off in LCALL_RE.findall(line):
                r = resolve_lcall(int(seg, 16), int(off, 16))
                if r:
                    calls.append({"at": (LINEFO_RE.match(line) or [None, None])[1],
                                  "seg": r["seg"], "off": r["off"],
                                  "target_name": r["target_name"], "target": r["target"]})
                    seg_resolve[f"{seg.upper()}:{off.upper().zfill(4)}"] = {
                        "target": r["target"], "target_name": r["target_name"],
                        "type": r["type"], "page": r["page"]}
                    ncall += 1
            for g in GLOBAL_RE.findall(line):
                globals_.add(f"0x{int(g,16):X}")
            for s in STRING_RE.findall(line):
                strings.append(s)
        rec = {"name": name, "file_off": f"0x{fo:06X}", "page": page, "region": region,
               "calls": calls, "globals": sorted(globals_, key=lambda x: int(x, 16)),
               "strings": strings[:12]}
        fout.write(json.dumps(rec) + "\n")
        nfunc += 1

json.dump({f"0x{k:06X}": v for k, v in func_index.items()},
          open(OUT / "func_index.json", "w"))
json.dump(seg_resolve, open(OUT / "thunk_resolve.json", "w"), indent=0)
print(f"deoverlay: {nfunc} functions, {ncall} resolved lcall sites, "
      f"{len(func_index)} starts, {len(seg_resolve)} distinct thunk seg:off")
print(f"  -> {OUT}/functions.jsonl  func_index.json  thunk_resolve.json")
