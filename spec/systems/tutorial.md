# In-Game Tutorial

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** key set + **trigger wiring + step-shown bitmask `[0x5386]/[0x5387]` + event-driven (non-sequential) model `BYTE_VERIFIED`** (2026-06-20). · **Canonical primary:** `data_extracted/text/GAME_sections.json` (`@TUTORIAL1..19`); `tools/rtlink/event_emitters.json`.

## 1. Purpose & behavior

A scripted, text-only help system that walks a new player through the opening
moves (land the first ship, load/unload cargo, send a ship to Europe, found a
colony). Each step surfaces a help dialog tied to a game event; the player reads
and dismisses it. No combat/economy mechanics of its own — it is a pure
**text + dialog** overlay on the normal game loop. **RECONSTRUCTED** (function
from the manual / observed strings; trigger wiring not byte-traced).

## 2. State & data

- Tutorial strings live in `GAME.TXT` as keys **`@TUTORIAL1` … `@TUTORIAL19`**
  (19 keys), all confirmed present in `data_extracted/text/GAME_sections.json`
  (lines 489–512). **B** (keys exist).
- Each `@TUTORIALn` key carries its **full prose value directly** in the extracted
  section (`data_extracted/text/GAME_sections.json` lines 464–482; all 19 keys
  TUTORIAL1..19 have non-empty values, e.g. line 475 `@TUTORIAL12` = the "ship has
  arrived … drag cargo" lesson). There are **no `@y=N` continuation entries** in the
  file (grep `"@y=` → 0 matches), so the key→prose binding is **direct/1:1** — the prior
  "empty value + `@y=N` continuation" note was a stale-extraction artifact, now
  superseded. **B** (prose binding resolved).
- Related help keys nearby: `@TUTNOLUMBER`, `@TUTNOSPACES`
  (`data_extracted/text/GAME_sections.json` lines 483–484) — conditional build-colony
  warnings, both emitted from the founding-colony validation routine **`func_022542`**
  (page 01, also home of NOPORT/NOCOLONIESEITHER). Both are gated by
  `cmp byte [0x53a6],2; jae skip` (`@0x22763`): warnings only fire when `[0x53a6] < 2`.
  **`@TUTNOSPACES`** (handle `0x9cd`, `@0x22772`) fires when `cmp word [bp-6],4; jge skip`
  (`@0x2276A`) is not taken — i.e. the adjacent productive-square count `[bp-6] < 4`.
  **`@TUTNOLUMBER`** (handle `0x9d9`, `@0x2278a`) fires when `cmp word [bp-0xe],0; jne skip`
  (`@0x22782`) is not taken — i.e. the forested-square count `[bp-0xe] == 0`. Each is a
  two-choice dialog (`lcall 0x181f,0x652`, arg `3`); the build proceeds only when the
  return `ax == 2` (`cmp ax,2; jne 0x2175` → otherwise abort), matching the
  "Cancel action. / Build colony anyway." prose. **B** (keys + trigger conditions).
- **Tutorial state = a 16-bit "step-shown" bitmask `[0x5386]` (low byte) / `[0x5387]`
  (high byte) — BYTE_VERIFIED 2026-06-20.** There is **no sequential step index**; each
  step owns one bit and is **idempotent**: its event site does
  `test [0x538x], <bit>; jne skip` → emit `@TUTORIALn` → `or [0x538x], <bit>` (mark
  shown), so each lesson fires **once** when its event first occurs. New-game init
  `mov word [0x5386], 0x0E` (`@0x755EB`) pre-marks three steps as already-shown.

## 3. Formulas & rules

- **Steps are event-driven & idempotent, NOT sequential — BYTE_VERIFIED 2026-06-20.**
  Each `@TUTORIALn` is emitted inline at the game function for its triggering event,
  guarded by its `[0x5386]/[0x5387]` bit (`tools/rtlink/event_emitters.json` handle map):

  | Step (handle) | Bit | Triggering function / event |
  |---|---|---|
  | TUTORIAL1 (`0x8B3`) | `[0x5386]&0x10` | `func_020F50` — unit move/land dispatcher (`@0x20FFB`) |
  | TUTORIAL5 (`0x1197`) | `[0x5387]&0x01` | `func_033F6A` — market/king phase (`@0x3651F`) |
  | TUTORIAL6 (`0xEC7`) | `[0x5387]&0x02` | `func_02D658` — colony processor / found colony (`@0x2EA4C`) |
  | TUTORIAL7 (`0xC99`) | `[0x5387]&0x04` | `func_02883E` — unit-movement event (`@0x28D41`) |
  | TUTORIAL4/12 (`0xD3D`/`0xD47`) | `[0x5386]&0x80` / `[0x5387]&0x80` | `func_02C5D4` — Europe/docks (`@0x2C74A`/`@0x2C7BC`) |
  | TUTORIAL3/8–11/13–15/19 | other `[0x5386]/[0x5387]` bits | `func_020F50` (`@0x21350`/`@0x213E9`/`@0x21481`/`@0x215CD`/…) |

- No numeric formulas.

## 4. UI

Standard help/message dialog (shared popup framework). Each step's emit site is
`push <arg2>; push <handle>; lcall 0x181f,0x652` (= `func_06F5F2`, page 23 — e.g.
TUTORIAL1 `push 0; push 0x8b3; lcall 0x181f,0x652` at `func_020F50 @0x20FF0`); the
wrapper stashes `[bp+8]` into `[0x1f5e]` and tail-calls the message-dialog renderer
`func_06F51A` via `func_06F7EF` (`ljmp 0x181f:0x998`). Body text is the matched
`@TUTORIALn` prose **directly** (no `@y=N` continuation exists — grep `@y=` → 0 in
GAME_sections.json, see §2) with `%STRINGn`/`%NUMBERn` substitutions — byte-real: the
prose literally carries `%STRING0..2`/`%NUMBER0..1` (GAME_sections.json 464–482) and
the substitution slots are registered immediately before the emit via `func_06C220`
(thunk `0x181f:0x416`) / `func_06C23C` (thunk `0x181f:0x438`). E.g. TUTORIAL12's colony
-name `%STRING0` is registered at `func_02C5D4 @0x2C7A7` (`push ds; push [0x8542]+2;
push 0; lcall 0x181f,0x416`) just before `push 5; push 0xd47; lcall 0x181f,0x652`
(`@0x2C7B1`). Dismissed with `{ESC}` (referenced in-prose, GAME_sections.json:475). **B**
(framework call chain + substitution wiring byte-cited). **Pixel geometry RESOLVED**
(2026-06-27): the tutorial dialog is rendered by the *shared* centered-dialog FRAME
engine, whose geometry is byte-cited in `spec/ui/popups.md` §2.3 and
`spec/ui/context_dialogs.md` §2 — `panel_finalize_geometry func_06D316 @0x06D316`:
`content_w = max(80, longest_line_px+10, @width)` (@0x06D392),
`box_w = content_w + border(3) + pad`, `box_h = line_count·2 + border(3) (+title/options)`
(@0x06D363/0x06D509/0x06D606), `X = (@x==-1)?(320-box_w)/2:@x` (@0x06D522),
`Y = (@y==-1)?(200-box_h)/2:@y` (@0x06D53B), clamp to (0x140,0xC8) (@0x06D563/0x06D571);
frame blit `lcall 0x181F:0x510` (WOODFRAM) @0x0263D6. The tutorial path provably reaches
this engine: `func_06F5F2` (the `0x181f:0x652` emit wrapper) tail-calls `func_06F7EF`
(= `LJMP 0x181F:0x998`, render-popup-body — `popups.md` §2.4, the `func_06F5B0..0x6F64C`
body-dispatch wrappers all funnel here). **No `@TUTORIALn` key carries an `@width`/`@x`/`@y`
directive** (verified — `GAME_sections.json` TUTORIAL1..19 are plain bodies), so each
tutorial popup uses the **default centered formula with the 80px content-width floor**;
box dimensions are a per-message function of the wrapped prose line count (live render
input, computed by `func_06C850`/`func_06D316`), not a static rectangle. **B**
(geometry engine + tutorial→engine routing byte-cited).

## 5. Evidence

- `data_extracted/text/GAME_sections.json` — `@TUTORIAL1..19` (464–482, prose
  bound directly to each key; no `@y=N` continuations — grep `@y=` → 0 matches),
  `@TUTNOLUMBER`/`@TUTNOSPACES` (483–484). (Prior "489–512 / `@y=5` (503) / 513–514"
  citations were a stale-extraction artifact, corrected to the verified offsets.) **B**
- `docs/GAME_MANUAL.md` — tutorial function (opening lessons). **R**

## 6. Open questions (TBD)

1. ~~Bind each `@TUTORIALn` to its triggering event.~~ **Done 2026-06-20** — each step
   is emitted inline at its event function, guarded by a `[0x5386]/[0x5387]` bit (§3
   table). The `@TUTORIALn`↔`@y=N` *prose* binding is a GAME.TXT extraction detail (the
   visible text is in the `@y=N` continuations). **B** (event wiring).
2. ~~Locate the tutorial-enabled flag and current-step index.~~ **Done 2026-06-20** —
   state is the **16-bit shown-bitmask `[0x5386]/[0x5387]`** (no sequential index);
   new-game init `[0x5386]=0x0E` `@0x755EB` (§2). **B.**
3. ~~Sequential or event-gated?~~ **Resolved 2026-06-20 — event-driven & idempotent**
   (fire once per event when the step's bit is clear), not a sequential script (§3). **B.**
