#!/usr/bin/env python3
"""Emit a self-contained Ghidra import script for VICEROY.EXE.

Everything this project knows about VICEROY's symbols — 1,250 function
boundaries, the 89 real 1994 CodeView names carried over from MAPEDIT, the
137-module map, the 31 overlay pages, ~150 named DGROUP globals and the five
record layouts — packaged so Ghidra stops showing FUN_0002d658 / DAT_00008542
and starts showing colony_turn_end_status / g_current_colony_ptr.

Outputs (both committed, regenerate any time):
  tools/ghidra/viceroy_ghidra_symbols.py   drop into ghidra_scripts, run it
  tools/ghidra/viceroy_types.h             File > Parse C Source

Address model (verified against the bytes, see tools/ghidra/README.md):
  MZ header      = 0x2400 (576 paragraphs)
  DGROUP in file = 0x1D9A0   (DS:0x2166 -> "AMER2.MP", 7/7 string probes hit)
  load image     = file 0x2400 .. 0x22A65
  overlay pages  = file 0x20EE0 .. 0x78D40  (31 RTLink pages)

Because the overlays live PAST the load image, a normal MZ load in Ghidra maps
only ~a quarter of the code.  The script therefore targets a RAW BINARY load
(16-bit x86, base 0), where Ghidra address == file offset and all 31 overlay
pages are present.  A delta constant covers the MZ-load case.
"""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUT_PY = ROOT / "tools/ghidra/viceroy_ghidra_symbols.py"
OUT_H = ROOT / "tools/ghidra/viceroy_types.h"

HEADER = 0x2400
DGROUP_FILE = 0x1D9A0
LOAD_IMAGE_END = 0x22A65


def sanitize(name):
    """Ghidra-safe identifier."""
    n = name.replace("@", "at_").replace("\\", "_").replace(".", "_")
    n = re.sub(r"[^A-Za-z0-9_]", "_", n)
    if n and n[0].isdigit():
        n = "f_" + n
    return n


def main():
    mods = json.loads((ROOT / "data_extracted/viceroy_modules.json").read_text())
    syms = json.loads((ROOT / "tools/viceroy_symbols.json").read_text())
    emitters = json.loads(
        (ROOT / "tools/rtlink/event_emitters.json").read_text())
    rtl = json.loads(
        (ROOT / "tools/rtlink/viceroy_rtlink_map.json").read_text())

    # --- GAME.TXT keys per emitting function ------------------------------
    keys_by_func = {}
    for key, rec in emitters.items():
        if not isinstance(rec, dict):
            continue
        for e in rec.get("emitters", []):
            keys_by_func.setdefault(e.get("func", ""), []).append(key)

    # --- functions --------------------------------------------------------
    page_label = {p: v["module"] for p, v in mods["page_labels"].items()}
    funcs = []
    for r in mods["functions"]:
        off = int(r["file_offset"], 16)
        real = r.get("real_name") or ""
        role = r.get("name") or ""
        module = r.get("module") or ""
        page = r.get("page") or ""
        # Only tier-B anchors are CONFIRMED CodeView names (the whole MAPEDIT
        # function matched instruction-for-instruction).  Tier-A `real_name`s
        # come from PARTIAL fingerprint matches, which the matcher itself
        # calls leads, not assignments — mostly shared compiler prologues.
        # Applying those as symbol names would launder a guess into a fact,
        # so they go in the comment as a candidate and the symbol keeps its
        # module-derived name.
        confirmed = real if r.get("tier") == "B" else ""
        lead = real if (real and r.get("tier") != "B") else ""

        if confirmed:
            nm = sanitize(confirmed)
            tier = "B"                       # real 1994 CodeView name
        elif role and role != "unknown" and not role.startswith("func_"):
            nm = sanitize(role)
            tier = "R"                       # role name from analysis
        else:
            base = sanitize(module).strip("_") or "unattributed"
            nm = "%s_%06X" % (base, off)
            tier = "M"                       # module-derived placeholder
        funcs.append({
            "a": off, "n": nm, "t": tier, "m": module, "p": page,
            "s": r.get("size") or 0, "lead": lead,
            "k": keys_by_func.get("func_%06X" % off, []),
        })

    # --- overlay page blocks ---------------------------------------------
    pages = [{"id": "%02X" % s["page_id"], "a": s["code_offset"],
              "z": s["code_size"]} for s in rtl["segments"]]

    # --- DGROUP globals ---------------------------------------------------
    globs = []
    for k, v in syms["globals"].items():
        ds = int(k, 16)
        globs.append({"ds": ds, "n": sanitize(v),
                      "f": DGROUP_FILE + ds,
                      "init": (DGROUP_FILE + ds) < LOAD_IMAGE_END})
    globs.sort(key=lambda g: g["ds"])

    # ---------------------------------------------------------------- emit
    data = {"funcs": funcs, "pages": pages, "globals": globs,
            "records": syms["record_windows"]}

    body = SCRIPT_TEMPLATE.replace("@@DATA@@", json.dumps(data, indent=0))
    OUT_PY.write_text(body)

    OUT_H.write_text(build_header(syms))

    b = sum(1 for f in funcs if f["t"] == "B")
    r = sum(1 for f in funcs if f["t"] == "R")
    leads = sum(1 for f in funcs if f.get("lead"))
    print("functions : %d  (%d CONFIRMED CodeView names, %d role names, "
          "%d module-derived)" % (len(funcs), b, r, len(funcs) - b - r))
    print("            %d unconfirmed candidates noted in comments only" % leads)
    print("globals   : %d  (%d initialised/in-file)"
          % (len(globs), sum(1 for g in globs if g["init"])))
    print("pages     : %d" % len(pages))
    print("->", OUT_PY)
    print("->", OUT_H)


def build_header(syms):
    """C header for Ghidra's File > Parse C Source."""
    out = ["/* VICEROY.EXE record layouts — generated by",
           " * tools/ghidra/export_ghidra_symbols.py.",
           " * Strides are byte-verified (spec/systems/save.md); field names",
           " * come from tools/viceroy_symbols.json + the SAV cross-decode.",
           " * Gaps are padded so each struct totals its true stride. */",
           "", "typedef unsigned char  u8;", "typedef unsigned short u16;",
           "typedef signed short   s16;", "typedef signed long    s32;", ""]
    windows = syms["record_windows"]
    fields = syms["record_fields"]
    for rec, win in windows.items():
        stride = int(win["stride"], 16)
        fl = fields.get(rec, {})
        items = sorted(((int(k, 16), v) for k, v in fl.items()))
        out.append("/* %s — base %s, stride 0x%X */" % (rec, win["base"], stride))
        out.append("typedef struct %s {" % rec)
        pos = 0
        pad = 0
        for off, name in items:
            if off < pos:
                continue                       # overlapping alias, skip
            if off > pos:
                out.append("    u8  _pad%d[0x%X];" % (pad, off - pos))
                pad += 1
                pos = off
            out.append("    u8  %s;" % sanitize(name))
            pos += 1
        if pos < stride:
            out.append("    u8  _pad%d[0x%X];" % (pad, stride - pos))
        out.append("} %s;   /* 0x%X */" % (rec, stride))
        out.append("")
    return "\n".join(out)


SCRIPT_TEMPLATE = r'''# VICEROY.EXE symbol import for Ghidra  (GENERATED — do not hand-edit)
# Regenerate: python3 tools/ghidra/export_ghidra_symbols.py
#
# WHAT IT DOES
#   * names every one of the 1,250 known functions (89 carry their real 1994
#     CodeView names, recovered from MAPEDIT.EXE by instruction fingerprint)
#   * plate-comments each function with its module, overlay page, size and the
#     GAME.TXT message keys it emits
#   * creates a DGROUP memory block and labels ~150 named globals in it
#   * bookmarks the 31 RTLink overlay page boundaries
#
# HOW TO LOAD THE BINARY (important — see tools/ghidra/README.md)
#   Import VICEROY.EXE as **Raw Binary**, language x86:LE:16:Real Mode,
#   base address 0.  Then Ghidra address == file offset and all 31 overlay
#   pages are visible.  A normal MZ import maps only the load image (a
#   quarter of the code) — if you did that, set MZ_LOAD = True below.
#
# @category Colonization

MZ_LOAD = False          # True if imported as MS-DOS Executable rather than raw
DGROUP_BLOCK_ADDR = 0x200000   # synthetic home for the BSS half of DGROUP

import json

DATA = json.loads(r"""@@DATA@@""")

HEADER = 0x2400
DGROUP_FILE = 0x1D9A0
DELTA = -HEADER if MZ_LOAD else 0


def A(file_off):
    return toAddr(file_off + DELTA)


def main():
    fm = currentProgram.getFunctionManager()
    st = currentProgram.getSymbolTable()
    mem = currentProgram.getMemory()

    named = renamed = commented = 0
    for f in DATA["funcs"]:
        try:
            addr = A(f["a"])
        except Exception:
            continue
        if mem.getBlock(addr) is None:
            continue                      # not mapped (MZ load, overlay page)

        fn = fm.getFunctionAt(addr)
        if fn is None:
            fn = createFunction(addr, f["n"])
            if fn is not None:
                named += 1
        if fn is not None:
            try:
                fn.setName(f["n"], ghidra.program.model.symbol.SourceType.IMPORTED)
                renamed += 1
            except Exception:
                pass

        tier = {"B": "REAL NAME (MAPEDIT CodeView match)",
                "R": "role name (analysis)",
                "M": "module-derived placeholder"}[f["t"]]
        lines = ["%s   [%s]" % (f["n"], tier),
                 "module : %s" % (f["m"] or "?"),
                 "page   : %s" % (f["p"] or "resident"),
                 "size   : %d bytes   file 0x%06X" % (f["s"], f["a"])]
        if f.get("lead"):
            lines.append("CANDIDATE (unconfirmed, partial fingerprint match "
                         "- verify before adopting): %s" % f["lead"])
        if f["k"]:
            lines.append("emits  : %s" % ", ".join(sorted(f["k"])))
        setPlateComment(addr, "\n".join(lines))
        commented += 1

    # ---- DGROUP -----------------------------------------------------------
    gi = gb = 0
    for g in DATA["globals"]:
        if g["init"]:
            try:
                addr = A(g["f"])
                if mem.getBlock(addr) is not None:
                    createLabel(addr, g["n"], True)
                    gi += 1
                    continue
            except Exception:
                pass
        gb += 1

    # BSS half: give it a block of its own so the names exist somewhere
    try:
        base = toAddr(DGROUP_BLOCK_ADDR)
        if mem.getBlock(base) is None:
            mem.createUninitializedBlock("DGROUP", base, 0x10000, False)
        for g in DATA["globals"]:
            if not g["init"]:
                createLabel(toAddr(DGROUP_BLOCK_ADDR + g["ds"]), g["n"], True)
    except Exception as e:
        print("DGROUP block skipped: %s" % e)

    # ---- overlay page bookmarks ------------------------------------------
    pages = 0
    for p in DATA["pages"]:
        try:
            addr = A(p["a"])
            if mem.getBlock(addr) is not None:
                createBookmark(addr, "RTLink",
                               "overlay page 0x%s  (%d bytes)" % (p["id"], p["z"]))
                pages += 1
        except Exception:
            pass

    print("functions created  : %d" % named)
    print("functions named    : %d" % renamed)
    print("plate comments     : %d" % commented)
    print("globals in-file    : %d" % gi)
    print("globals in DGROUP  : %d" % gb)
    print("overlay bookmarks  : %d" % pages)
    print("")
    print("Next: File > Parse C Source > tools/ghidra/viceroy_types.h")
    print("then retype the record pointers (g_current_colony_ptr -> ColonyRecord*).")


main()
'''

if __name__ == "__main__":
    main()
