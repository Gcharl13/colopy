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
| `done` | 629 | ported, full body |
| `byte-verified` | 361 | ported + byte-checked |
| **done + byte-verified** | **990 (79.2%)** | the finished core |
| `referenced` | 157 | called but body not yet ported |
| `partial` | 20 | partially ported |
| `skeleton` | 1 | stub only |
| `superseded`/`phantom`/`data` | 82 | not work items (dead/dup/data) |

**Genuine remaining work surface: 178 functions** (`referenced` + `partial` +
`skeleton`). This is the spine of "finish the entire project."

### Remaining by region (drive order)

| Region | Remaining | What lives here |
|---|---:|---|
| resident | 39 | shared library leaves (text/blit/format primitives) |
| overlay 0x04 | 25 | **Europe / harbor screen** |
| overlay 0x02 | 24 | **Colony screen + build engine** |
| overlay 0x12 | 21 | (mixed) |
| overlay 0x15 | 12 | |
| overlay 0x13 | 9 | |
| overlay 0x23 | 8 | |
| overlay 0x26 | 8 | |
| overlay 0x01 | 7 | |
| 0x16/0x06/0x17/0x19/0x20/0x25 | 2 each | |
| 0x03/0x07/0x08/0x18/0x21/0x22/0x24/0x27/0x28/0x30/0x31 | 1 each | |

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

### [RECONSTRUCTED — remaining] Centered dialog/popup WOODFRAM frame
Centered popups (no @x/@y) get the WOODFRAM blit `0x181F:0x510` →
`func_00531C` (textured wood-weave fill of the dialog rect). Its inner
pixel-transform leaves `0x02E9:0x0006` and `0x0A4E:0x0008` are **stubbed
no-ops** in `render_glue.c`, so the modern fill is a placeholder
(`vid_box_fill 0` + `outline 15`). Decoding those two leaves is the next UI item;
they also feed `texture_fill_rect` (colony work-grid backdrop, `func_005234`).

### [BLOCKED — the real UI completion gap] Nations / Difficulty / Europe composers
The whole-screen composers ARE ported and control-flow byte-verified:
`func_07092E_draw_nation_screen`, `func_070494_draw_difficulty_screen`,
`func_0707B6_draw_nation_row`, `func_070302_draw_difficulty_row` (+ the modal
dispatchers `func_070A1A` / `func_070580`) in `overlay_070302_074405.c`.

They do NOT draw in the modern build because their text leaves are no-op stubs:
`overlay_call_181F_0100` (= `func_002BC8` text-field draw) returns 0 in
`platform/headless_io_stubs.c`. The chain
`func_002BC8 -> func_002B38/func_002AFE -> 0x0C11:0xC blit / 0x0C28:0xA style /
0x0C2A:6 measure` is ported but its leaves pass args via REGISTERS + DGROUP
([0x89E] font ctx, [0x2DA8] screen desc, string-handle on the stack, x=ax,
y=dx), which the C port left argless -> stubbed.

**Root cause (one fix unblocks several screens):** bridge the 6 resident
text-field functions to the platform text primitives using their own C args,
exactly as `render_glue.c` already does for the colony/map path
(`vid_text_xy`/`vid_text_color`/`vid_text_width`). The functions:
`func_002AFE`, `func_002B38`, `func_002B72`, `func_002BC8`, `func_002C0C`,
`func_002C4A` (file 0x2AFE..0x2C82). Their leaf calls (`0x0C11:0xC`,
`0x0C28:0xA`, `0x0C2A:6`) map 1:1 onto `vid_text_xy` / `vid_text_color` /
`vid_text_width` (string handle resolved via `viceroy_str`, colour from the
DGROUP [0x830]/[0x833] bytes or the explicit arg4). Then wire
`overlay_call_181F_0100 -> func_002BC8` and route the shell's
`draw_nations`/`draw_difficulty` through the real composers. NOT done yet --
it needs the user's NAMES/LABELS text + palette to pixel-verify, so it lands as
a verified-by-byte increment, not an asset-checked one.

### [coded, not yet asset-verified] Colony / Reports / Hall-of-Fame
Per `UI_VERIFICATION.md` + `SCREEN_LAYOUTS.md`: geometry byte-verified, full
composition assembled in primitives. No game-data assets are present in this
environment, so pixel parity can't be run here; correctness is driven by
byte-citation against the disasm.

## How completion is being driven
1. UI first (title done above), then the two stubbed text/blit leaves that block
   every framed dialog (`0x02E9:0x0006`, `0x0A4E:0x0008`).
2. Then the remaining 178 by region, highest-leverage first (resident leaves →
   Europe 0x04 → Colony 0x02), each decoded from `re_work/disasm/func_*.asm`,
   cited `@asm`, kept green under `cert7.py`.
3. Every increment committed to `claude/beautiful-maxwell-EUu9I` with the byte
   cites in the message. No line is called done that isn't verified against the
   binary.
