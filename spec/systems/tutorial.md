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
- Most `@TUTORIALn` slots carry an **empty value** in the extracted section; the
  visible tutorial prose is held in the adjacent `@y=N` continuation entries
  (e.g. `@y=5` at line 503 = the "ship has arrived … drag cargo" lesson). The
  key→prose binding is `TBD`.
- Related help keys nearby: `@TUTNOLUMBER`, `@TUTNOSPACES` (lines 513–514) —
  conditional warnings (no lumber / no build space). **B** (keys exist).
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

Standard help/message dialog (shared popup framework). Body text from the
matched `@TUTORIALn`/`@y=N` string with `%STRINGn` substitutions (e.g. colony
name). Dismissed with `{ESC}`. Geometry per the shared dialog framework. **R**.

## 5. Evidence

- `data_extracted/text/GAME_sections.json` — `@TUTORIAL1..19` (489–512),
  `@y=5` sample prose (503), `@TUTNOLUMBER`/`@TUTNOSPACES` (513–514). **B**
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
