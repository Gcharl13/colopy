#!/usr/bin/env python3
"""Map GAME.TXT @event keys -> emitter function(s) in VICEROY.EXE.

For each @KEY in GAME.TXT:
  1. locate the null-terminated key string in the EXE DGROUP image
  2. DGROUP handle = file_offset - 0x1D9A0
  3. find `push <handle>` sites (68 lo hi) = message-emit call sites
  4. map each site to the enclosing reseg function (file-offset intervals)
  5. note whether that function is itself reachable via a thunk (xref) or
     dispatch-only (the func_03C638 "no direct caller" class)
"""
import json, re, os, glob, sys
HERE = os.path.dirname(__file__)
EXE = os.path.join(HERE, "..", "..", "raw", "COLONIZE", "VICEROY.EXE")
GAME = os.path.join(HERE, "..", "..", "raw", "COLONIZE", "GAME.TXT")
RESEG = os.path.join(HERE, "..", "..", "code", "VICEROY", "disasm_overlay_reseg")
DGROUP = 0x1D9A0

def keys():
    txt = open(GAME, encoding="utf-8", errors="replace").read()
    out = []
    for m in re.finditer(r"^@([A-Z][A-Z0-9_]+)\s*$", txt, re.M):
        k = m.group(1)
        if k in ("width", "height", "align"):
            continue
        out.append(k)
    return out

def func_intervals():
    """[(start_file, end_file, name, page)] from reseg headers."""
    ivals = []
    for p in sorted(glob.glob(os.path.join(RESEG, "page_*.asm"))):
        page = os.path.basename(p).replace("page_", "").replace(".asm", "")
        for m in re.finditer(r"; ---- (func_([0-9A-Fa-f]+))\s+size=(\d+)", open(p, encoding="utf-8", errors="replace").read()):
            start = int(m.group(2), 16); size = int(m.group(3))
            ivals.append((start, start + size, m.group(1), page))
    ivals.sort()
    return ivals

def enclosing(ivals, off):
    for s, e, name, page in ivals:
        if s <= off < e:
            return name, page
    return None, None

def main():
    b = open(EXE, "rb").read()
    ivals = func_intervals()
    xref = json.load(open(os.path.join(HERE, "thunk_xref.json")))
    thunk_targets = set(int(k, 16) for k in xref)
    out = {}
    for k in keys():
        needle = b"\x00" + k.encode("ascii") + b"\x00"
        i = b.find(needle)
        if i < 0:
            continue
        str_off = i + 1
        handle = str_off - DGROUP
        if handle < 0 or handle > 0xFFFF:
            continue
        sig = bytes([0x68, handle & 0xFF, (handle >> 8) & 0xFF])  # push imm16
        sites = [m.start() for m in re.finditer(re.escape(sig), b)]
        funcs = []
        for s in sites:
            name, page = enclosing(ivals, s)
            if name:
                fstart = int(name.split("_")[1], 16)
                funcs.append({"func": name, "page": page,
                              "site": hex(s),
                              "reachable": fstart in thunk_targets})
        if funcs:
            out[k] = {"handle": hex(handle), "emitters": funcs}
    json.dump(out, open(os.path.join(HERE, "event_emitters.json"), "w"), indent=1)
    # summary
    n_events = len(out)
    n_unreach = sum(1 for v in out.values()
                    for f in v["emitters"] if not f["reachable"])
    print(f"event keys with an in-overlay emitter = {n_events}")
    # list events whose emitter is NOT thunk-reachable (dispatch-only class)
    print("\n=== events whose emitter function is dispatch-only (no thunk caller) ===")
    seen = set()
    for k, v in sorted(out.items()):
        for f in v["emitters"]:
            if not f["reachable"] and f["func"] not in seen:
                seen.add(f["func"])
                print(f"  @{k:16} -> {f['func']} (page {f['page']})")

if __name__ == "__main__":
    main()
