#!/usr/bin/env python3
"""audit_raw_functions.py -- identify the last "raw" (unclassified) functions in
code/VICEROY/functions.json and record the result.

Each entry below is an HONEST identification from the function's own bytes
(instructions, library/thunk calls, INT/port I/O, string xrefs, and the known
DGROUP anchors). Tiers:
  B    byte-evidence is diagnostic (INT 21h, VGA port I/O, string xref, anchor)
  R    role inferred from structure / callees (not a full byte-port)
  GLUE compiler / C-runtime / library helper (not gameplay)
  DATA NOT code -- a data/zero-fill block the auto-segmenter mis-split as a func

Writes: patches functions.json (name + status) and emits docs/RAW_FUNCTION_AUDIT.md.
status AUDITED = role identified (this pass); DATA = reclassified as not-code.
"""
from __future__ import annotations
import json, re, glob
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FJSON = ROOT / "code/VICEROY/functions.json"
DIS = ROOT / "code/VICEROY/disasm"
DOC = ROOT / "docs/RAW_FUNCTION_AUDIT.md"

# offset -> (name, status, tier, role/evidence)
AUDIT = {
 0x002400: ("rt_strtab_open",        "AUDITED","GLUE","C-runtime: opens the \"$STRING\" resource (lib 0x181F:0x48, ax=9); zeroes record counter [0x2D52]."),
 0x00242C: ("rt_strtab_append",      "AUDITED","GLUE","C-runtime: appends a record; bumps counter [0x2D52] (lib 0xD1D:0x113C/0x117E)."),
 0x002462: ("rt_far_strlen",         "AUDITED","GLUE","C-runtime: REPNE SCASB length scan over the far buffer at [0x2D42:0x2D44]."),
 0x002494: ("rt_code_select_2out",   "AUDITED","GLUE","C-runtime: maps an index arg to constant outputs (0x44/0x95/0xC + 0x22)."),
 0x002632: ("rt_emit_long",          "AUDITED","GLUE","C-runtime: converts via far 0:0x62, forwards to output sink CALL 0x260E."),
 0x002648: ("rt_fmt_emit_1arg",      "AUDITED","GLUE","C-runtime: formats 1 arg into a 20-byte stack buffer (0xD1D:0x8FA) then emits (0x260E)."),
 0x002668: ("rt_fmt_emit_2arg",      "AUDITED","GLUE","C-runtime: formats 2 args (0xD1D:0x916) then emits (0x260E)."),
 0x00268C: ("rt_fmt_emit_str",       "AUDITED","GLUE","C-runtime: formats a string (0x4B:0x1E8) then emits (0x260E)."),
 0x0028C0: ("rt_emit_repeat_n",      "AUDITED","GLUE","C-runtime: calls leaf 0x28B0 N=[bp+8] times (repeat/emit-n)."),
 0x0028E2: ("rt_libwrap_7a4_s52",    "AUDITED","GLUE","C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x52."),
 0x0028F2: ("rt_libwrap_7a4_s55",    "AUDITED","GLUE","C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x55."),
 0x002902: ("rt_libwrap_7a4_s58",    "AUDITED","GLUE","C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x58."),
 0x002912: ("rt_libwrap_7a4_s5c",    "AUDITED","GLUE","C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x5C."),
 0x002922: ("rt_libwrap_7a4_s5e",    "AUDITED","GLUE","C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x5E."),
 0x002932: ("rt_libwrap_7a4_s60",    "AUDITED","GLUE","C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x60."),
 0x002962: ("rt_libwrap_7a4_s66",    "AUDITED","GLUE","C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x66."),
 0x002972: ("rt_libwrap_7a4_s68",    "AUDITED","GLUE","C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x68."),
 0x002982: ("rt_libwrap_7a4_s6a",    "AUDITED","GLUE","C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x6A."),
 0x011D30: ("rt_dos_open",           "AUDITED","B",   "C-runtime: DOS file open/create -- INT 21h AH=3Dh (access in AL&3), AH=3Eh close path."),
 0x078548: ("vga_palette_dac_write", "AUDITED","B",   "VGA: writes the 256-colour palette to the DAC (OUT 0x3C7/0x3C9), vsync via IN 0x3DA; sets flag [0x808]."),
 0x078068: ("ui_input_cursor_helper","AUDITED","R",   "UI/input: reads cursor globals [0x184]/[0x89E]/[0x8A0], dispatches via thunks 0x181F:0x182/0x1F0/0x1FA."),
 0x078B3E: ("overlay_thunk_1a1f_e90","AUDITED","R",   "Thin wrapper forwarding to overlay thunk 0x1A1F:0xE90."),
 0x0092E0: ("colony_flag_bit_set",   "AUDITED","B",   "Colony: sets/tests a bit in the bit-array at ColonyRecord+0x84 (idx>>3 byte, idx&7 bit); base [0x8542]."),
 0x009318: ("colony_production_accumulate","AUDITED","R","Colony (782B): reads active colony [0x8542] + unit table [0x3159], accumulates into the stockpile array (+0x9A) and reads size (+0x1F). Role identified; full byte-port pending."),
 0x009626: ("colony_leaf_calls_90c8","AUDITED","R",   "Colony helper: active colony [0x8542]; calls leaf 0x90C8."),
 0x00965C: ("colony_leaf_calls_9102","AUDITED","R",   "Colony helper: active colony [0x8542]; calls leaf 0x9102."),
 0x009692: ("colony_leaf_90c8_9102", "AUDITED","R",   "Colony helper: active colony [0x8542]; calls leaves 0x90C8 and 0x9102."),
 0x0096DA: ("colony_leaf_activecol", "AUDITED","R",   "Colony helper: reads/writes via active colony [0x8542]."),
 0x00B150: ("colony_update_step",    "AUDITED","R",   "Colony: higher-level step -- active colony [0x8542]; calls 0x90C8, production 0x9318, 0xAB78."),
 0x00B368: ("colony_helper_b2a2",    "AUDITED","R",   "Colony helper cluster: calls 0xB2A2/0xB2F0/0xB304."),
 0x00B880: ("colony_helper_8dc4_a",  "AUDITED","R",   "Colony helper: active colony [0x8542] + global [0x8DC4]; calls 0xB368."),
 0x00B8D0: ("colony_helper_8dc4_b",  "AUDITED","R",   "Colony helper: active colony [0x8542] + global [0x8DC4]; calls 0xB42C."),
 0x054505: ("colony_helper_181f_c0e","AUDITED","R",   "Colony helper: active colony [0x8542]; thunks 0x181F:0xC0E/0xC36/0xC54."),
 0x05576B: ("colony_helper_181f_cd6","AUDITED","R",   "Colony helper: active colony [0x8542]; thunk 0x181F:0xCD6."),
 0x0572E6: ("native_convert_handler","AUDITED","B",   "Natives: mission/convert path -- string 'INDIANSCONVERT', active TribeData [0x8D4E]/[0x8D52], thunks 0x181F/0x191F."),
 0x05A20E: ("colony_scout_or_mayor_check","AUDITED","B","Colony: strings 'SCOUTCOLONY' / 'NOMAYORSDURINGREV'; reads game-phase [0x5382] (post-revolution gate)."),
 # --- NOT code: data/zero-fill mis-split as functions by the auto-segmenter ---
 0x055760: ("data_block_misseg_5576x","DATA","DATA","NOT a function: disassembly is data/zero-fill (ENTER 0xEFE then DB bytes) -- auto-segmenter boundary artifact."),
 0x05651C: ("data_block_misseg_5651C","DATA","DATA","NOT a function: body is 00-fill / data decoded as code (ADD [bx+si],al runs)."),
 0x056694: ("data_block_misseg_56694","DATA","DATA","NOT a function: 811B data block decoded as code (mostly 00 00 / junk opcodes)."),
 0x05AC34: ("data_block_misseg_5AC34","DATA","DATA","NOT a function: data/zero-fill decoded as code."),
 0x05AEA0: ("data_block_misseg_5AEA0","DATA","DATA","NOT a function: data/zero-fill decoded as code."),
 0x05AF2C: ("data_block_misseg_5AF2C","DATA","DATA","NOT a function: data/zero-fill (trailing 00-run) decoded as code."),
}

def main():
    data = json.load(open(FJSON))
    fs = data["functions"]
    idx = {int(f["file_offset"], 16): f for f in fs}
    patched = 0
    for o, (name, status, tier, role) in AUDIT.items():
        f = idx.get(o)
        if not f:
            print(f"WARN 0x{o:06X} not in functions.json"); continue
        f["name"], f["status"] = name, status
        patched += 1
    json.dump(data, open(FJSON, "w"), indent=2)
    print(f"patched {patched} entries in {FJSON.relative_to(ROOT)}")

    # emit audit doc
    rows = []
    for o in sorted(AUDIT):
        name, status, tier, role = AUDIT[o]
        f = idx.get(o, {})
        rows.append(f"| `0x{o:06X}` | {f.get('size','?')} | `{name}` | {tier} | {role} |")
    DOC.write_text(
        "# Raw-function audit — clearing the last unclassified functions\n\n"
        "The coverage map (`tools/build_coverage_map.py`) had a residual set of\n"
        "functions that were disassembled but neither named nor reconstructed in C.\n"
        "This audit identifies every one of them from its own bytes. Tiers: **B** =\n"
        "diagnostic byte evidence (INT/port-I/O/string/anchor); **R** = role inferred\n"
        "from structure/callees (not a full port); **GLUE** = C-runtime/library helper;\n"
        "**DATA** = not code (a data block the auto-segmenter mis-split as a function).\n\n"
        "Key finding: 6 of these are **not code at all** — data/zero-fill regions that\n"
        "the boundary detector wrongly emitted as functions. They are reclassified\n"
        "`DATA`, not 'decoded'.\n\n"
        "| Offset | Size | Identification | Tier | Evidence (from the bytes) |\n"
        "|--------|-----:|----------------|------|---------------------------|\n"
        + "\n".join(rows) + "\n", encoding="utf-8")
    print(f"wrote {DOC.relative_to(ROOT)} ({len(AUDIT)} functions)")

if __name__ == "__main__":
    main()
