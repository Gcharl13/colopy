# load_image decompilation — status & remaining work

The always-resident load image (file `0x0..0x1A43C`) was auto-segmented into
~475 skeleton functions, then hand-decompiled in waves. This is the honest
accounting of what is done, what remains, and why.

## Progress

| Wave | Method | Result |
|---|---|---|
| Tiny (≤60 B) | 4 parallel agents + template | 115 byte-verified |
| Medium (61–250 B) | 4 parallel agents | +59 byte-verified |
| **Total ported** | | **174 functions `BYTE_VERIFIED`** |

Every port is decompiled from the capstone `.asm` (authoritative extent — the
skeleton `@asm` spans are unreliable; the auto-segmenter cut many functions at a
false `retf`/`jl` boundary), carries per-block `@asm` citations, and uses the
named DGROUP fields from `DGROUP_MEMORY_MAP.md`. Spot-checks and the agents' own
`gcc -fsyntax-only` runs confirmed byte-fidelity.

## Remaining, categorized honestly

The raw "SKELETON" count overstated the work. Re-tagging (see
`tools/reclassify_status.py`) splits the remainder into what it actually is:

| Status | Count | What it is | Action |
|---|---|---|---|
| `SKELETON` overlay-dependent | ~174 | real game/engine logic that **lcalls overlay thunks** | needs overlay thunk resolution; ports are approximate until then |
| `SKELETON` self-contained leaf | ~32 | the *hard* leaves (register-ABI, far-pointer conventions) | decompilable with care |
| `SKELETON` load_image near-call | ~21 | call other load_image functions | decompilable |
| `SKELETON` no_asm | ~8 | missing disasm dump | needs the dump |
| `SHADOWED` | 55 | **not real functions** — auto-segmentation artifacts sitting *inside* a larger function's true extent | fold/ignore (re-tagged) |
| `PLATFORM_LAYER` | 19 | DOS `int 21h` / BIOS / hardware I/O / RTLink overlay-loader | **replaced** in the modern port, not decompiled (re-tagged) |

So the true remaining **decompilation** target is ~235 (174 overlay-dependent +
~61 leaf/near-call/no_asm), not 303. The 74 SHADOWED+PLATFORM entries are
accounted for and need no byte-faithful port.

## Strategic read

1. **The tractable load_image leaf work is essentially done.** What remains is
   dominated by overlay-dependent functions whose real behavior lives in the
   overlay pages, plus host-layer code the port replaces.

2. **The next decompilation leverage is overlay thunk resolution.** 174
   load_image functions call `lcall SEG:OFF` overlay thunks. Today those are
   modeled as void `overlay_call_SEG_OFF()` externs, so ports capture control
   flow but not faithful data flow. Giving the resolved thunks real signatures
   (from the already-decompiled `src/overlay/*.c`) would upgrade all 174 from
   approximate to faithful — higher leverage than grinding more leaves.

3. **Milestone-3 swap-points are now identified.** Porting surfaced the layers a
   modern Windows build replaces with native code, already located by file
   offset:
   - **C runtime** (MSC 6.0): `strcpy@0xFDB4`, `memcpy@0x10352`, `strlen`,
     `fread`, `stricmp`, `__aFldiv`, `_filbuf`/`_flsbuf` → native libc
   - **Graphics**: VGA DAC palette upload, sprite blit to `0xA000`, clipped
     run-fills, glyph rendering → SDL/modern renderer
   - **Platform**: DOS `int 21h` file/mem, BIOS video/keyboard, PIT/CGA timing,
     mouse `int 33h`, the RTLink overlay loader → native OS / a flat binary

## Recommended next step

**The overlay-thunk foundation is now built** (`tools/harvest_thunk_signatures.py`
→ `docs/thunk_signatures.json`): 924 distinct thunks consolidated, **361 with
real named signatures** (the most-called ones — `txt_lookup`, `market_price`,
`draw_text_clip`, `menu_add_item`, `select_player_ctx`, `num_to_str` — are
named), joined to their overlay file offsets via `lcall_resolution_VICEROY.json`.

With that reference in hand, the 174 overlay-dependent load_image functions can
be ported **faithfully** — calling the real identified function (and its real
signature) instead of a void `overlay_call_*` stub — closing the load_image ↔
overlay call graph. Remaining identification work: 168 placeholder-only + 395
undeclared thunks (mostly low call-frequency), plus reconciling a few naming
conflicts (e.g. `0x181F:0x0438` is named both `power_set_flag` and
`ov_unit_stat_format` in different files).

Grinding the remaining ~32 hard self-contained leaves is lower leverage than
either (a) the faithful overlay-dependent port above, or (b) deepening the
overlay game-logic files directly (where the real mechanics live).

---

*Counts regenerate via `tools/segmentation_audit.py` (mis-segmented/shadowed) and
the categorizer in this session. Re-run after each porting wave.*
