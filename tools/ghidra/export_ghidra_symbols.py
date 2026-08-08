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
import hashlib
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


# Names Ghidra injects into a script's namespace at run time.  Anything the
# generated script reads that is not here, not a builtin, and not bound in the
# script itself is a generation bug.
GHIDRA_INJECTED = {
    "currentProgram", "currentAddress", "currentLocation", "currentSelection",
    "currentHighlight", "state", "monitor", "toAddr", "getBytes", "setBytes",
    "createLabel", "createFunction", "createBookmark", "setPlateComment",
    "getFunctionAt", "getFunctionContaining", "getInstructionAt", "getDataAt",
    "createData", "clearListing", "askYesNo", "popup", "println", "printerr",
    "getScriptArgs",
}


def check_free_names(body):
    """Refuse to write a script that reads a name nothing defines.

    SCRIPT_TEMPLATE is a *string*, so a constant living only in this
    generator's namespace is invisible to every local test and then dies as a
    NameError inside Ghidra — after the run has already half-applied itself.
    That is exactly how LOAD_IMAGE_END shipped broken on 2026-08-08.
    """
    import ast
    import builtins

    tree = ast.parse(body)
    bound = set(dir(builtins)) | GHIDRA_INJECTED
    for node in ast.walk(tree):
        if isinstance(node, (ast.FunctionDef, ast.ClassDef)):
            bound.add(node.name)
            args = getattr(node, "args", None)
            if args is not None:
                bound.update(a.arg for a in
                             args.posonlyargs + args.args + args.kwonlyargs)
                for extra in (args.vararg, args.kwarg):
                    if extra is not None:
                        bound.add(extra.arg)
        elif isinstance(node, ast.Name) and isinstance(node.ctx, ast.Store):
            bound.add(node.id)
        elif isinstance(node, (ast.Import, ast.ImportFrom)):
            bound.update((a.asname or a.name).split(".")[0] for a in node.names)
        elif isinstance(node, ast.ExceptHandler) and node.name:
            bound.add(node.name)
        elif isinstance(node, ast.comprehension):
            bound.update(n.id for n in ast.walk(node.target)
                         if isinstance(n, ast.Name))

    free = {}
    for node in ast.walk(tree):
        if isinstance(node, ast.Name) and isinstance(node.ctx, ast.Load):
            free.setdefault(node.id, node.lineno)

    missing = sorted((n, ln) for n, ln in free.items() if n not in bound)
    if missing:
        raise SystemExit(
            "REFUSING TO WRITE %s\n"
            "the generated script reads name(s) nothing defines:\n%s\n"
            "Define them inside SCRIPT_TEMPLATE, not just in this generator."
            % (OUT_PY, "\n".join("    %s   (line %d)" % m for m in missing)))


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
    tables = [{"name": n, "ds": base, "stride": stride,
               "count": ("g_colony_count" if n == "ColonyRecord" else
                         "g_unit_count" if n == "UnitRecord" else
                         "g_settlement_count" if n == "NativeSettlement" else
                         "fixed 4")}
              for n, base, stride, _s, _f in RECORDS]

    data = {"funcs": funcs, "pages": pages, "globals": globs,
            "records": syms["record_windows"], "tables": tables}

    body = SCRIPT_TEMPLATE.replace("@@DATA@@", json.dumps(data, indent=0))
    # Content-addressed build stamp, printed as the script's first line at run
    # time.  Sole purpose: make "am I running the file I just generated?"
    # answerable in one glance instead of by comparing tracebacks.
    stamp = hashlib.sha256(body.encode()).hexdigest()[:12]
    body = body.replace("@@STAMP@@", stamp)
    check_free_names(body)
    OUT_PY.write_text(body)

    print("record layouts:")
    verify_records()
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
    print("")
    print("BUILD %s" % stamp)
    print("The script prints this as its FIRST line in Ghidra's console.")
    print("If the two do not match, Ghidra is running an older copy that is")
    print("still sitting in ghidra_scripts/ - replace it and re-run.")


# Curated record layouts with REAL field widths.  Deriving these from
# viceroy_symbols.json's record_fields gives byte-correct strides but types
# every field `u8`, which is useless in the decompiler (`colony->gold` must
# read as a 32-bit value, `stock[]` as a u16 array).  Sources per record are
# cited below; unknown spans are emitted as padding, never invented.
#
# (offset, ctype, name, count)   count None = scalar
RECORDS = [
    ("ColonyRecord", 0x5D46, 0xCA,
     "spec/systems/save.md (SAV cross-decode, 2026-08-08) + DATA_MODEL.md", [
         (0x00, "u8", "map_x", None),
         (0x01, "u8", "map_y", None),
         (0x02, "char", "name", 24),
         (0x1A, "u8", "owner_power", None),
         (0x1C, "u8", "colony_flags", None),        # b1 SoL100 b2 SoL50 b7 blink
         (0x1F, "u8", "population", None),
         (0x20, "u8", "occupation", 32),            # per-colonist job
         (0x40, "u8", "profession", 32),            # per-colonist specialty
         (0x60, "u8", "work_duration", 16),         # 4-bit pairs
         (0x70, "s8", "tiles", 8),                  # N,E,S,W,NW,NE,SE,SW
         (0x84, "u8", "buildings", 6),              # 48-bit TIER-PACKED
         (0x8A, "u16", "custom_house_flags", None),
         (0x92, "u16", "hammers", None),
         (0x94, "u8", "building_in_production", None),
         (0x95, "u8", "warehouse_level", None),
         (0x97, "u8", "depletion_counter", None),
         (0x98, "u16", "hammers_purchased", None),
         (0x9A, "u16", "stock", 16),
         (0xBA, "u8", "population_on_map", 4),
         (0xBE, "u8", "fortification_on_map", 4),
         (0xC2, "s32", "rebel_dividend", None),
         (0xC6, "s32", "rebel_divisor", None),
     ]),
    ("UnitRecord", 0x3144, 0x1C,
     "docs/DATA_MODEL.md + tools/viceroy_symbols.json", [
         (0x00, "u8", "map_x", None),
         (0x01, "u8", "map_y", None),
         (0x02, "u8", "type", None),
         (0x03, "u8", "owner_flags", None),         # low nibble = nation
         (0x04, "u8", "flags", None),
         (0x06, "u8", "moves_remaining", None),
         (0x07, "u8", "profession", None),
         (0x08, "u8", "orders", None),
         (0x09, "u8", "goto_x", None),
         (0x0A, "u8", "goto_y", None),
         (0x0C, "u8", "cargo_slot_count", None),
         (0x0D, "u8", "cargo_kind_packed", 3),
         (0x10, "u8", "cargo_qty", 4),
         (0x15, "u8", "class_profession", None),
         (0x16, "u8", "turn_counter", None),
         (0x17, "u8", "vet_type", None),
         (0x18, "u16", "chain_prev", None),
         (0x1A, "u16", "chain_next", None),
     ]),
    ("PowerRecord", 0x8808, 0x13C,
     "docs/DATA_MODEL.md (byte-verified offsets) + the SAV decode", [
         (0x01, "u8", "tax_rate", None),
         (0x02, "u8", "dock_pool", 3),
         (0x07, "s32", "founding_fathers_bitmap", None),
         (0x0C, "u16", "liberty_bells", None),
         (0x0E, "u16", "bell_pool", None),
         (0x10, "u16", "crosses_per_turn", None),
         (0x12, "u16", "ff_pending_slot", None),
         (0x14, "u16", "founding_fathers_count", None),
         (0x1E, "u16", "artillery_bought_count", None),
         (0x20, "u16", "boycott_mask", None),
         (0x22, "s32", "royal_money", None),
         (0x2A, "s32", "gold", None),
         (0x2E, "u16", "crosses_accum", None),
         (0x30, "u16", "cross_threshold", None),
         (0x32, "u8", "home_x", None),
         (0x33, "u8", "home_y", None),
         (0x34, "u8", "war_matrix", 12),
         (0x40, "u8", "treaty_relation", 4),
         (0x44, "u8", "ref_dragoons", None),
         (0x45, "u8", "ref_regulars", None),
         (0x46, "u8", "ref_artillery", None),
         (0x4C, "u8", "market_price", 16),
         (0x5C, "u16", "market_pool", 16),
         (0x7C, "s32", "market_traded_value", 16),
         (0xBC, "s32", "market_traded_tons", 16),
         (0xFC, "s32", "market_base_value", 16),
     ]),
    ("NativeSettlement", 0x54EC, 0x12,
     "spec/systems/save.md + smcol cross-check", [
         (0x00, "u8", "map_x", None),
         (0x01, "u8", "map_y", None),
         (0x02, "u8", "tribe", None),               # importSav: tribe = this - 4
         (0x03, "u8", "flags", None),               # b2 capital, b3 chief_seen
         (0x04, "u8", "population", None),
         (0x05, "u8", "mission", None),             # 0xFF none
         (0x06, "u8", "growth_counter", None),
         (0x0A, "u16", "alarm_by_power", 4),
     ]),
    ("AIPersonality", 0x540E, 0x34,
     "tools/viceroy_symbols.json (mostly unmapped)", [
         (0x30, "u8", "field_30", None),
         (0x31, "u8", "controller_flag", None),     # 0 = human seat
         (0x32, "u8", "named_colony_count", None),
     ]),
]

SIZEOF = {"u8": 1, "s8": 1, "char": 1, "u16": 2, "s16": 2, "s32": 4}


def verify_records():
    """Arithmetic self-check: fields must not overlap and must fit the stride.

    NOT done with a host C compiler: `s32` is `signed long`, which is 4 bytes
    under Ghidra's 16-bit x86 compiler spec (and in the 1994 build) but 8 on
    an LP64 host, so a gcc sizeof() check reports false failures.  The layout
    is checked here in the units that actually matter — byte offsets.
    """
    for name, base, stride, _src, fields in RECORDS:
        pos = 0
        for off, ctype, fname, count in sorted(fields):
            if off < pos:
                raise SystemExit("%s.%s at 0x%X overlaps previous field end 0x%X"
                                 % (name, fname, off, pos))
            pos = off + SIZEOF[ctype] * (count or 1)
        if pos > stride:
            raise SystemExit("%s overruns its stride: 0x%X > 0x%X"
                             % (name, pos, stride))
        mapped = sum(SIZEOF[c] * (n or 1) for _, c, _, n in fields)
        print("  %-18s stride 0x%-4X mapped %3d/%3d bytes (%d%%)"
              % (name, stride, mapped, stride, 100 * mapped // stride))


def build_header(syms):
    """C header for Ghidra's File > Parse C Source.

    Byte-granular by construction: every gap becomes an explicit u8 pad array
    and each struct is asserted to total its true stride, so Ghidra's
    alignment rules cannot shift a field.
    """
    out = [
        "/* VICEROY.EXE record layouts — generated by",
        " * tools/ghidra/export_ghidra_symbols.py.  DO NOT hand-edit.",
        " *",
        " * Ghidra:  File > Parse C Source  (see tools/ghidra/README.md).",
        " * Every struct is padded to its byte-verified stride and contains",
        " * only byte-granular members, so no alignment rule can move a",
        " * field.  Unmapped spans are `_pad`, never invented names.",
        " *",
        " * IMPORTANT — parse this against the 16-BIT PROGRAM, not a 64-bit",
        " * architecture: `s32` is `signed long`, which is 4 bytes under",
        " * Ghidra's 16-bit x86 compiler spec (as in the 1994 build) but 8",
        " * under an LP64 spec, which would silently shift every field after",
        " * the first s32 and corrupt the layout.",
        " */",
        "",
        "typedef unsigned char  u8;",
        "typedef signed char    s8;",
        "typedef unsigned short u16;",
        "typedef signed short   s16;",
        "typedef signed long    s32;",
        "",
    ]
    for name, base, stride, source, fields in RECORDS:
        out.append("/* %s — DGROUP base 0x%04X, stride 0x%X (%d bytes)" %
                   (name, base, stride, stride))
        out.append(" * source: %s */" % source)
        out.append("typedef struct %s {" % name)
        pos = 0
        pad = 0
        for off, ctype, fname, count in sorted(fields):
            if off < pos:
                raise SystemExit("%s: field %s at 0x%X overlaps 0x%X"
                                 % (name, fname, off, pos))
            if off > pos:
                out.append("    u8   _pad_%02X[0x%X];" % (pos, off - pos))
                pad += 1
                pos = off
            width = SIZEOF[ctype] * (count or 1)
            decl = ("%s[%d]" % (fname, count)) if count else fname
            out.append("    %-4s %-26s /* +0x%02X */" %
                       (ctype, decl + ";", off))
            pos += width
        if pos > stride:
            raise SystemExit("%s: fields overrun stride (0x%X > 0x%X)"
                             % (name, pos, stride))
        if pos < stride:
            out.append("    u8   _pad_%02X[0x%X];" % (pos, stride - pos))
        out.append("} %s;" % name)
        out.append("")
    return "\n".join(out)


SCRIPT_TEMPLATE = r'''# VICEROY.EXE symbol import for Ghidra  (GENERATED — do not hand-edit)
# Regenerate: python3 tools/ghidra/export_ghidra_symbols.py
#
# BUILD @@STAMP@@
# If a traceback from this file does not match the line numbers you expect,
# check that stamp against the one the repo prints — you are probably running
# an older copy that is still sitting in ghidra_scripts/.
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
# RUNTIME: works under BOTH Ghidra Python providers.
#   * PyGhidra (CPython 3, bundled and default since Ghidra 11.3)
#   * Jython 2.7 (the older provider, an installable extension)
# Only stdlib `json` plus the injected flat API are used, and the one Java
# type it needs is imported explicitly (a bare `ghidra.program...` reference
# resolves under neither provider).  No f-strings, no print_function needed.
#
# @category Colonization

MZ_LOAD = False          # True if imported as MS-DOS Executable rather than raw

# Synthetic home for the BSS half of DGROUP.  MUST be a valid address in the
# program's address space: x86 real mode tops out near 1 MB, so a "safely
# high" value like 0x200000 is NOT addressable and block creation fails.
# The file itself is ~495 KB (0x78D3E), so 0x80000 sits just past it and
# inside the 1 MB real-mode range.  Fallbacks are tried automatically.
DGROUP_BLOCK_ADDR = 0x80000
DGROUP_FALLBACKS = (0x80000, 0x90000, 0xF0000, 0x200000)

import json

try:
    from ghidra.program.model.symbol import SourceType
    SRC = SourceType.IMPORTED
except Exception as _e:      # pragma: no cover - provider without the class
    SRC = None
    print("WARNING: could not import SourceType (%s); renames will be skipped"
          % _e)

DATA = json.loads(r"""@@DATA@@""")

HEADER = 0x2400
DGROUP_FILE = 0x1D9A0
LOAD_IMAGE_END = 0x22A65        # end of the MZ load image; DGROUP is BSS above
DELTA = -HEADER if MZ_LOAD else 0


def A(file_off):
    return toAddr(file_off + DELTA)


BUILD = "@@STAMP@@"


def main():
    # First line out, before anything can fail: which copy of this file is
    # actually running.  Ghidra runs whatever is in ghidra_scripts/, which is
    # not necessarily the file you just regenerated.
    print("=" * 64)
    print("viceroy_ghidra_symbols  BUILD %s" % BUILD)
    print("=" * 64)

    fm = currentProgram.getFunctionManager()
    st = currentProgram.getSymbolTable()
    mem = currentProgram.getMemory()

    named = renamed = commented = failed = skipped = 0
    for f in DATA["funcs"]:
        try:
            addr = A(f["a"])
        except Exception:
            skipped += 1
            continue
        if mem.getBlock(addr) is None:
            skipped += 1                  # not mapped (MZ load, overlay page)
            continue

        fn = fm.getFunctionAt(addr)
        if fn is None:
            fn = createFunction(addr, f["n"])
            if fn is not None:
                named += 1
        if fn is not None and SRC is not None:
            try:
                fn.setName(f["n"], SRC)
                renamed += 1
            except Exception as e:
                failed += 1
                if failed <= 5:           # report a few, don't spam
                    print("  rename failed at 0x%06X (%s): %s"
                          % (f["a"], f["n"], e))

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
    # ONE contiguous 64 KB window, not two halves.  DGROUP's initialised part
    # lives in the file at 0x1D9A0 and runs to the end of the load image
    # (0x22A65 = DS:0x50C5); everything above that is BSS, past the end of the
    # file.  In a raw-binary import the bytes immediately after 0x22A65 are
    # already occupied by overlay data, so BSS cannot simply be appended -
    # hence a synthetic block, with the initialised bytes COPIED into it so
    # that one DS value covers the whole segment.
    #
    # Why this matters: real mode writes `mov bx,[0x8542]`, meaning DS:0x8542.
    # Unless Ghidra knows DS, that displacement stays a bare constant and every
    # global in the program decompiles as a naked number.  Labelling the two
    # halves at two different addresses (the previous behaviour) could never
    # fix that, because no single DS value reached both.
    dg = None
    existing = mem.getBlock("DGROUP")
    if existing is not None:
        dg = existing.getStart()
        print("DGROUP block already present at %s" % dg)
        if not existing.isInitialized():
            print("!! ...but it is UNINITIALISED - left over from an older run")
            print("!! of this script.  Delete it and re-run, or the initialised")
            print("!! half of DGROUP will read as zeros:")
            print("!!   Window > Memory Map, select DGROUP, click the red X.")
    else:
        errs = []
        for cand in DGROUP_FALLBACKS:
            try:
                base = toAddr(cand)
                if base is None:
                    errs.append("0x%X: toAddr returned None" % cand)
                    continue
                mem.createInitializedBlock("DGROUP", base, 0x10000,
                                           0, monitor, False)
                dg = base
                print("DGROUP block created at %s (0x%X), 64 KB" % (dg, cand))
                break
            except Exception as e:
                errs.append("0x%X: %s" % (cand, e))
        if dg is None:
            print("!! COULD NOT CREATE THE DGROUP BLOCK - the record tables")
            print("!! will have no addresses.  Attempts:")
            for e in errs:
                print("     %s" % e)

    # DGROUP MUST BE WRITABLE.  createInitializedBlock defaults to read-only,
    # and a read-only block is a promise to the decompiler that the bytes
    # never change - so it constant-folds every read.  BSS is zero-filled,
    # which means `if (g_some_flag)` folds to false and the ENTIRE guarded
    # body is deleted from the decompilation.  Symptom: a 274-byte function
    # decompiles to three lines plus "Read-only address is written" warnings.
    if dg is not None:
        try:
            blk = mem.getBlock(dg)
            blk.setRead(True)
            blk.setWrite(True)
            blk.setExecute(False)
            print("DGROUP permissions set to rw-")
        except Exception as e:
            print("!! could not make DGROUP writable (%s)" % e)
            print("!! the decompiler will constant-fold reads from it and")
            print("!! delete guarded code.  Fix by hand: Window > Memory Map,")
            print("!! tick the W column on the DGROUP row.")

    # Copy the initialised half in, so DS:0x0000..0x50C4 reads real data.
    init_len = LOAD_IMAGE_END - DGROUP_FILE
    if dg is not None:
        try:
            src = getBytes(A(DGROUP_FILE), init_len)
            mem.setBytes(dg, src)
            print("DGROUP initialised half copied: %d bytes from file 0x%X"
                  % (init_len, DGROUP_FILE))
        except Exception as e:
            print("!! could not copy the initialised half (%s) - DS:0x0000..0x%X"
                  % (e, init_len - 1))
            print("!! will read as zeros.  BSS globals are unaffected.")

    # Every global goes in the one window, initialised or not.
    gi = gb = 0
    if dg is not None:
        for g in DATA["globals"]:
            try:
                createLabel(dg.add(g["ds"]), g["n"], True)
                if g["init"]:
                    gi += 1
                else:
                    gb += 1
            except Exception:
                pass

    # ---- teach Ghidra what DS holds --------------------------------------
    # With the block at a paragraph-aligned address, DS = block>>4 makes every
    # `[0xNNNN]` displacement in the program resolve to DGROUP:0xNNNN - which
    # is where the labels now are.  Without this the decompiler shows
    # `*(int *)0x8542` instead of `g_current_colony_ptr`.
    if dg is not None:
        try:
            from java.math import BigInteger
            ds_reg = currentProgram.getRegister("DS")
            if ds_reg is None:
                print("!! no DS register in this language - is the program"
                      " really x86:LE:16:Real Mode?")
            else:
                ds_val = BigInteger.valueOf(dg.getOffset() >> 4)
                ctx = currentProgram.getProgramContext()
                spans = 0
                for blk in mem.getBlocks():
                    if blk.getName() == "DGROUP":
                        continue
                    try:
                        ctx.setValue(ds_reg, blk.getStart(), blk.getEnd(),
                                     ds_val)
                        spans += 1
                    except Exception:
                        pass
                print("DS set to 0x%04X over %d block(s) - globals should now"
                      " decompile by name" % (dg.getOffset() >> 4, spans))
                print("   (if they do not, re-run Analysis > Auto Analyze, or"
                      " right-click a function > Decompiler > Refresh)")
        except Exception as e:
            print("!! could not set DS (%s); set it by hand: select all in the"
                  " Listing," % e)
            print("!! right-click > Registers > Set Register Values, DS = 0x%04X"
                  % (dg.getOffset() >> 4))

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
    if failed:
        print("renames FAILED     : %d  (see messages above)" % failed)
    if skipped:
        print("skipped (unmapped) : %d  <- set MZ_LOAD/re-import if unexpected"
              % skipped)
    print("plate comments     : %d" % commented)
    print("globals in-file    : %d" % gi)
    print("globals in DGROUP  : %d" % gb)
    print("overlay bookmarks  : %d" % pages)
    # ---- the addresses you actually need, in THIS program's own format ----
    # Do not compute these by hand: a 16-bit real-mode program uses segmented
    # addresses (segment:offset), so a flat hex number will not resolve in
    # Go To.  Copy the right-hand column verbatim.
    print("")
    print("=" * 64)
    print("APPLY RECORD ARRAYS HERE  (Listing: G to go, then T to set type)")
    print("=" * 64)
    if dg is None:
        print("  unavailable - the DGROUP block was not created (see above)")
    else:
        for t in DATA["tables"]:
            try:
                a = dg.add(t["ds"])
            except Exception as e:
                print("  %-18s DS:0x%04X  -> ERROR %s" % (t["name"], t["ds"], e))
                continue
            print("  %-18s DS:0x%04X  ->  %s     [%s, stride 0x%X]"
                  % (t["name"] + "[]", t["ds"], a, t["count"], t["stride"]))
        print("")
        print("RECORD POINTERS to retype:")
        for nm, ds, ty in (("g_current_colony_ptr", 0x8542, "ColonyRecord *"),
                           ("g_current_power_ptr", 0x84FC, "PowerRecord *"),
                           ("g_active_settlement_ptr", 0x8D4A,
                            "NativeSettlement *")):
            try:
                print("  %-24s DS:0x%04X  ->  %s   as %s"
                      % (nm, ds, dg.add(ds), ty))
            except Exception:
                pass
    print("")
    print("Next: File > Parse C Source > tools/ghidra/viceroy_types.h")
    print("(clean profile: our header only, empty options, 16-bit program)")


main()
'''

if __name__ == "__main__":
    main()
