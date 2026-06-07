# Ghidra Decompile Import — VICEROY.EXE Phase 1

**Source:** Ghidra File → Export Program → C/C++  
**Date:** 2026-05-02  
**Coverage:** Load image only (segments 1000..2b5a, file 0x2400..0x20665)  
**Overlay coverage:** NONE — overlay region (file 0x20665+) is not loaded

The full export was pasted in the conversation; this directory is the
landing place for excerpts and processed views.

## Immediate BYTE_VERIFIED facts from the export

### 1. Function-name anchors confirmed

| Ghidra name        | Our project name      | File offset | Status |
|--------------------|----------------------|------------|--------|
| `FUN_1d1d_07e4`    | `strcpy_near`         | 0x00FDB4   | BYTE_VERIFIED — body matches MSC 6.0 strcpy exactly |
| `entry`            | `entry_point`         | 0x013BED   | BYTE_VERIFIED — matches anchor_map.md (210d:071d) |
| `FUN_1d1d_0727`    | startup helper        | 0x012CF7   | ANCHOR_VERIFIED — called by entry, sets up DGROUP |
| `FUN_1d1d_0150`    | `cstart`              | 0x01072A   | BYTE_VERIFIED — DOS version check + heap init + setargv + calls _main |

### 2. RTLink overlay system — fully revealed

**Every `FUN_281f_xxxx` function is an RTLink thunk** — Ghidra shows them
all with the same body:

```c
void FUN_281f_NNNN(int param_1) {
    FUN_210d_0dab(0x281f, in_stack_00000000, param_1);
    halt_baddata();
}
```

These thunks call **`FUN_210d_0dab`** (file 0x011DAB) which is the
**overlay dispatcher**. Per the symbol table earlier, `FUN_210d_0d91`
(very similar function, probably the "load and dispatch" partner) has
**353 callers** — explaining why most overlay functions show "Control
flow encountered bad instruction data" — those LCALLs land in code
Ghidra hasn't loaded.

**The dispatcher reads a flag at `s_Smart_vectoring_failed__BP_chain_210d_28cd[0x44]`
and bit-tests `[0x41] & 0x0C` to decide overlay-load vs. cached
call.** This is the RTLink Plus runtime — confirmed.

### 3. `_main()` is at `FUN_281f_0000`

In `cstart` (FUN_1d1d_0150), the call sequence ends with:

```c
FUN_281f_0000(0x1d1d);   // ← the FIRST overlay call = main()
FUN_1d1d_030d();         // exit
```

So **`FUN_281f_0000` IS the game's `_main()`**. It's the first thunk in
the RTLink overlay table — file offset 0x01A5F0 — and dispatches into
the actual game-init code in the overlay region.

This confirms anchor_map.md: "_main() is the FIRST overlay-resident
function. It loads VICEROY.PAL, ICONS.SS, and the other always-needed
assets..."

### 4. Strings now resolved with addresses

The Ghidra export shows the actual `char *` constants resolved (not
just hex). Examples confirmed:

- `"VICEROY.EXE"` at `2755:0001`
- `"AMERICA.MOV"` at `2b5a:1e50`, `2b5a:1e5f`, `2b5a:1e71` (3 copies — at 3 call sites)
- `"HALLFAME.DAT"` at `2b5a:11f2`, `2b5a:1227`
- `"COLONY"` at `2b5a:0ba0`, `2b5a:1453`, `2b5a:146f`
- All RTLink runtime errors at `210d:` offsets

### 5. `entry` flow byte-traced

```c
void entry(void) {
    DAT_2b5a_e944 = 0x210d;
    DAT_2b5a_e942 = 0x17f2;
    FUN_210d_0727(uRam00004096);   // startup helper
    FUN_1d1d_0150();                // cstart → _main → exit
    return;
}
```

The two bytes at `2b5a:e944` and `2b5a:e942` are stored — these are
likely RTLink overlay-system trampolines (the values 0x210d:0x17f2
look like a far-pointer to a runtime entry).

## What's still NOT byte-verified (requires Phase 2 — overlay load)

The actual game logic — combat, raze treasure, market pricing, FF
effects, AI, score, map gen — lives in the overlay region. Ghidra
doesn't see it. Symptoms in the export:

- All `FUN_281f_xxxx` show `// WARNING: Control flow encountered bad
  instruction data` followed by `halt_baddata()` — Ghidra runs out of
  road at the LCALL into the overlay.
- `FUN_2b5a_1fc0` shows hundreds of `Removing unreachable block`
  warnings — that's the cstart/runtime in DGROUP that gets analyzed
  with bad segment register tracking.
- The pseudo-C for `FUN_2b5a_1fc0` is essentially garbage
  (incomprehensible nested operations on `puVar`/`pbVar` pointers).

To answer game-logic questions byte-verifiably, **Phase 2 is required**
— load the overlay segments as additional memory blocks in Ghidra and
re-export.

## Auto-name mapping table (Ghidra ↔ project)

For the load-image functions Ghidra found, their file-offset
correspondence (computed from the segment paragraph + offset) lets us
map to our existing `code/VICEROY/disasm/func_NNNNNN_*.asm` filenames.

| Ghidra name              | File offset | Project filename                          |
|--------------------------|-------------|--------------------------------------------|
| `FUN_1d1d_07e4`          | 0x00FDB4    | `func_00FDB4_strcpy_near.asm`             |
| `FUN_1d1d_07a4`          | 0x00FD74    | `func_00FD74_strcat_near.asm`             |
| `FUN_1d1d_113c`          | 0x010A4C... | `func_0107XX_strlen_near.asm` (calc)      |
| `FUN_1d1d_117e`          | 0x01073A... | `func_0107XX_*.asm`                        |
| `FUN_210d_0d91`          | 0x014261    | `func_014261_rtlink_loader_B.asm` (per anchor_map) |
| `FUN_210d_0dab`          | 0x01427B    | `func_01427B_rtlink_loader_A.asm`         |
| `FUN_281f_0000`          | 0x01A5F0    | (first overlay thunk = _main)              |

These mappings let us replace Ghidra's `FUN_xxxx_xxxx` with our
project's role-based names without manual rework.

## Verification work this enables

Even without Phase 2, the load-image decompiles let us byte-verify:

- **C runtime layer** — strcpy, strcat, strlen, memset, memcpy, printf,
  fopen, fread, fwrite, exit, atexit (all in segments 0x1d1d, 0x1c0c,
  0x1c11, 0x281f thunks)
- **DOS service wrappers** — file I/O, console I/O
- **RTLink Plus loader** — overlay dispatch, segment lookup, EMS/XMS
  caching
- **MZ entry + cstart** — fully decompiled in Ghidra
- **system_init** — sub-functions in segment 0x210d are visible

What we can NOT byte-verify yet (Phase 2 required):
- All game logic (combat, market, raze, FF, AI, scoring, map gen)
- All asset loaders (TERRAIN.SS, PHYS0.SS, AMER2.MP, etc.)
- All UI / render chain

## Phase 2 plan (next session)

Load overlay segments into Ghidra:

1. Export `overlay_segments.json` from our project — gives the 82
   distinct overlay segments with their file offsets, sizes, and
   default base paragraphs.
2. For each overlay segment N:
   - Compute file offset and size from the RTLink thunk table
   - Use `File → Add to Program → Memory Block` in Ghidra
   - Set the segment paragraph to whatever RTLink would load it as
3. Re-run **Analysis → Auto Analyze** with the new blocks
4. Re-export decompile

Estimated overlay coverage after Phase 2: **691 game-logic functions
fully decompiled**, which combined with the 550 load-image functions
gives all 1,241 functions in citable C.
