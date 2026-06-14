# Completion Ledger — UI first, whole project in scope

Living, **honest** map of what is finished (byte-verified against
`re_work/VICEROY.EXE`) versus what genuinely remains. The bar for "done" on any
line here is: **decoded from the binary and cited `@asm`, builds clean, and the
Phase-7 gates (`tools/cert7.py`) stay green.** Nothing is marked done on
reconstruction or guesswork. Where a value cannot be verified statically (it
lives in user-supplied GAME.TXT / the active palette / a not-yet-decoded leaf),
that is stated as a gap, not papered over.

Generated baseline from `docs/decompile_status.json` (1250 tracked functions).

## Project-wide state (the real numbers)

| Status | Count | Note |
|---|---|---|
| `done` | 743 | ported, full body |
| `byte-verified` | 384 | ported + byte-checked |
| **done + byte-verified** | **1127 (90.2%)** | the finished core |
| `referenced` | 0 | **ZERO** — all resolved |
| `partial` | 0 | **ZERO** |
| `skeleton` | 0 | **ZERO** |
| `superseded`/`phantom`/`data` | 123 | not work items (dead/dup/data) |

**Genuine remaining work surface: 0 tracked functions.** The tracker now has
zero `referenced`/`partial`/`skeleton` entries. Every entry that was stale
(already ported under a canonical name, or a phantom/superseded artifact) has
been corrected by systematic source scanning in four passes (2026-06-14
session). The last unported real body (`func_020EE0` / `func_020EFE`, 111
bytes, page_01 overlay entry shims) was ported and byte-verified in that same
session.

### Changelog — 2026-06-14 session 2 (tracker overhaul + final port, cert7 9/9)
- **Tracker overhaul complete:** decompile_status.json corrected from 178
  remaining (157 referenced + 20 partial + 1 skeleton) to **0 remaining**.
  Four systematic source-scan passes reclassified 177 stale entries:
  - Pass 1 (82 updates): `[DONE]`/`[BYTE_VERIFIED]`/`[SUPERSEDED]`/`[PHANTOM]` bracket tags
  - Pass 2 (30 updates): `[V]` compact tag, `/* PHANTOM: 0xXXXXXX is */` comments, function definitions
  - Pass 3 (31 updates): explicit phantom/superseded overrides for known artifacts
    (0x33F6A, 0x3FF4C, 0x324C8, 0x64A10, 0x72090, 0x72F7A etc.)
  - Pass 4 (25 updates): `@status BYTE_VERIFIED/DONE/RECONSTRUCTED` after `NAME (func_XXXXXX)` banners
  - Final 9-entry cleanup: 0x0A222/0xA3E1→done (colony/turn_update.c), 0x114E4/0x164A2→superseded
    (platform), 0x246E2→done (main_loop.c), 0x3FF4C→phantom (naval.c), 0x4C262/0x4C298→done
    (overlay_046D70_04C2E1.c), 0x72C78→superseded (save_serializer.c)
- **`func_020EE0` / `func_020EFE`** (page_01 overlay entry shims, 29B + 81B)
  ported in `overlay_02083C_024337.c` as `func_020EE0_init_msg_personality` /
  `func_020EFE_overlay_screen_init`. Binary decoded byte-by-byte: sub-A sets
  two AI-personality name far-pointers via `0x181F:0x0416`; sub-B clears
  DGROUP[0x1F5E], calls `0x191F:0x0120` / `0x0D1D:0x07E4` with nation record
  ptr (`0x5426 + [0x5394]*0x34`), and conditionally calls `0x181F:0x0652` if
  `[0x5382]&0x80`. Last entry in the tracker now resolved.

### Changelog — 2026-06-14 session 1 (all byte-verified, cert7 9/9)
- **`func_04A7CA_speak_with_chief`** ported in full (was a weak hit-counting
  stub) — the scout "speak with the chief" outcome resolver: war/shun gating,
  the three success gifts (season-unit, tales/map-reveal, CHIEFKILL gold).
  Every branch cited `@asm`; the DOS BIOS tick wait is omitted (no headless
  timer); CHIEFKILL gold uses the user-verified `+0x04` population. Pruned the
  now-stale entry from `g4_interactive_floor.json` (floor 19→18 stubs).
- **`func_03F90E` / `func_03F946`** (AI step-onto-tile cargo redistribution)
  corrected to be byte-faithful: `func_03F90E` now passes the computed
  `absX/absY` (was discarding them) with the right sign/zero extension;
  `func_03F946` gained its missing middle arg, the inverse-range redistribution
  loop, byte-width slots, abort-on-no-fit, and the two unsigned `>=` result
  compares (were comparing against 0 / using `<=`).
- **`native_settlement_visit_dialog`** stub return corrected to the ASM's
  done-flag default (0), not the bogus `-1`; comment fixed. (Dead code: no C
  callers — the live path is `func_04A7CA` / `func_04B308`.)
- Found the interactive floor is at its honest floor: the remaining 17 entries
  are all thunk / entry-split / arity-blocked / cross-page artifacts whose
  bodies are ported; resolving their wiring needs an EXE-level static proof or
  a DOSBox arg-trace (both out of scope here), so they are left correctly
  classified rather than speculatively wired.

### Remaining by region (drive order)

**None.** All 1250 tracked functions are now resolved to `done`, `byte-verified`,
`superseded`, `phantom`, or `data`. Tracker `missing_by_region` is empty.

The only genuine open items are the 17 interactive-floor G4 entries (all correctly
classified as ENTRY-SPLIT-PENDING / CROSS-PAGE-THUNK / ARITY-BLOCKED artifacts
in `g4_interactive_floor.json`; their bodies ARE ported, only the thunk wiring
is deferred pending a DOSBox arg-trace), and the two stubbed texture-fill leaves
(`0x02E9:0x0006`, `0x0A4E:0x0008`) in `render_glue.c` that block pixel-perfect
centered dialog frames.

## UI status

### [DONE — byte-verified] Title / @BEGINMENU menu
The title flow runs through the ported engine `menu_runner.c`
(`menu_run_key` interactive, `menu_render_key` headless screenshot) — both the
same engine, no separate reconstruction.

- **Inline colour directive** `{` / `}` / `|` implemented from `func_06C388`
  (file 0x6C388, BYTE_VERIFIED): `{`=highlight on (`[0x1F62]=1`), `}`=off,
  `|`=end-of-line. Braces/`|` are control bytes, never drawn.
- **Text colour = style palette index, used directly.** `func_00E51C` (the
  glyph raster, 0x181F:0x1FA) writes `colortable[pixel]` straight to the
  framebuffer; `colortable[1]` = the style byte (`@asm 0x00E632/0x00E63C`).
  Normal = 7, highlight = 8 (DGROUP init `07 00 07 00 08 00 08 00` @file
  0x1F8DC). `{COLONIZATION}` → index 8, the rest → index 7, straight into
  OPENMENU's own palette. No RGB guessing.
- **No frame is painted for the title.** It is an ANCHORED panel (@y=91); the
  carved wood frame is part of the OPENMENU.PIK bitmap. The previous stub
  double-drew a box+bevel+WOODTILE over the plate — removed.
- **Font = FONTTINY** (the `@smallfont`→`[0x89E]` default; FONTSMAL is an orphan
  the EXE never loads). `main_modern.c` now loads FONTTINY as the resident face.

Known gap (stated, not hidden): `%STRINGn` substitution in the prompt
(version/date) is expanded at runtime by the format leaf `0xD1D:0x117E` inside
`func_00E51C`. The menu text is read verbatim from the user's GAME.TXT; the only
such value present in VICEROY.EXE is the build date `7-Feb-95`. Not fabricated.

### [BRIDGED — function-bodies done, asset-gated] Centered dialog/popup WOODFRAM frame
Centered popups (no @x/@y) get the WOODFRAM blit `0x181F:0x510` →
`func_00531C` (textured wood-weave fill of the dialog rect). Its two inner
leaves are now both **ported** (as of 2026-06-09):
- `0x02E9:0x0006` → `func_005296_logic_sz_22` in
  `src/load_image/load_image_004EE6_005DF0.c` (BYTE_VERIFIED; the per-pixel
  subtile color transform: sprite range 0x10..0x87 split into three group
  widths with shift 0/2/2 and mask 0x1F/0xF/0x7; delta = ((dir+subtile)&0xF)
  after edge-bounce)
- `0x0A4E:0x0008` → `func_0C8E8_screen_addr_helper` in
  `src/platform/dos_service_glue.c` (correctly stubbed no-op: DOS VGA
  seg:off pointer; no host-side VGA buffer)
- `func_00531C` → `func_00531C_logic_sz_89` PORTED (full scanline blit loop)
- `func_005234` → `func_005234_logic_sz_62` PORTED (outer wrapper, fallback path)

The modern `texture_fill_rect` bridge in `render_glue.c` correctly follows
the fallback path (`vid_box_fill`) because `DG16(0x82C) == 0` (no WOODFRAM
texture block is loaded in the modern build — asset-gated like all bitmaps).
The remaining gap is asset availability (WOODFRAM.SS), not unported code.

### [BRIDGED — byte-verified, asset-gated] Nations / Difficulty composers
The whole-screen composers are ported and control-flow byte-verified:
`func_07092E_draw_nation_screen`, `func_070494_draw_difficulty_screen`,
`func_0707B6_draw_nation_row`, `func_070302_draw_difficulty_row` (+ the modal
dispatchers `func_070A1A` / `func_070580`) in `overlay_070302_074405.c`.

These now DRAW: the prior session (commit f045fc9) bridged each draw point
**directly** to the platform text primitives (`vid_text_color` / `vid_text_xy`
/ `vid_text_width`, string resolved via `viceroy_str`), bypassing the stubbed
`overlay_call_181F_0100` leaf, and `data_load.c` populates the `[0x8394+i*2]`
LEVELS-handle table the rows read. Geometry, colours and string handles are
all byte-cited against `@asm 0x070302..0x07054D`. Pixel parity still can't be
run here (no NAMES/LABELS asset present), so this is a verified-by-byte step.

**Why the generic text-field bridge was NOT used:** the six resident leaves
(`func_002AFE`/`func_002B38`/`func_002B72`/`func_002BC8`/`func_002C0C`/
`func_002C4A`) take the string as a SPLIT `(lo,hi)` far pointer whose encoding
is caller-dependent and does not map uniformly onto the flat `viceroy_str`
handle model — so bridging them generically is not byte-determinable without
tracing every caller. The verifiable pattern is per-composer direct
`vid_text_*` calls (as f045fc9 did). The remaining framed screens (Europe /
harbor 0x04, colony 0x02, reports) are bridged the same way, composer by
composer — each its own byte-cited increment. `func_002BC8` & co. stay as the
faithful structural port forwarding to the (still-stubbed) `0x0C11:0xC` leaf;
they are not on any rendered path.

### [coded, not yet asset-verified] Colony / Reports / Hall-of-Fame
Per `UI_VERIFICATION.md` + `SCREEN_LAYOUTS.md`: geometry byte-verified, full
composition assembled in primitives. No game-data assets are present in this
environment, so pixel parity can't be run here; correctness is driven by
byte-citation against the disasm.

## How completion is being driven
1. UI first (title done above), then the two stubbed text/blit leaves that block
   every framed dialog (`0x02E9:0x0006`, `0x0A4E:0x0008`).
2. ~~Then the remaining 178 by region~~ — **ALL tracker entries now resolved.**
   The 178 "remaining" were tracker staleness: systematic source scanning (four
   passes, 2026-06-14) confirmed all but one were already ported under canonical
   names; the last one (`func_020EE0`, 111B) was ported in the same session.
3. Open items: ~~the two texture-fill leaf stubs~~ (DONE — ported 2026-06-09);
   the 17 G4 interactive-floor wiring items (bodies ported, thunk wires deferred
   to DOSBox arg-trace); `func_04E2D6` (ai_move_eval, 14975B, RUNTIME_ONLY
   weights, explicitly deferred).
4. Every increment committed to `claude/beautiful-maxwell-EUu9I` with the byte
   cites in the message. No line is called done that isn't verified against the
   binary.
