# In-Game Tutorial

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** key set `BYTE_VERIFIED` (keys exist in primary data); trigger logic + step ordering `TBD`. · **Canonical primary:** `data_extracted/text/GAME_sections.json` (`@TUTORIAL1..19`).

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
- An on/off **tutorial-enabled flag** (set at new-game) and a **current-step**
  index are expected in game state but are **TBD** (no byte trace).

## 3. Formulas & rules

- Step advancement: which event fires which `@TUTORIALn` — `TBD`.
- Whether steps are gated/sequential or purely event-driven — `TBD`.
- No numeric formulas. **TBD**.

## 4. UI

Standard help/message dialog (shared popup framework). Body text from the
matched `@TUTORIALn`/`@y=N` string with `%STRINGn` substitutions (e.g. colony
name). Dismissed with `{ESC}`. Geometry per the shared dialog framework. **R**.

## 5. Evidence

- `data_extracted/text/GAME_sections.json` — `@TUTORIAL1..19` (489–512),
  `@y=5` sample prose (503), `@TUTNOLUMBER`/`@TUTNOSPACES` (513–514). **B**
- `docs/GAME_MANUAL.md` — tutorial function (opening lessons). **R**

## 6. Open questions (TBD)

1. Bind each `@TUTORIALn` key to its `@y=N` prose and to the triggering event.
2. Locate the tutorial-enabled flag and current-step index in game state.
3. Determine whether the 19 steps are sequential or event-gated.
