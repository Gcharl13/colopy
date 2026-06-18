# Random Events / Lost City Rumors

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** event message strings `BYTE_VERIFIED` (data present); triggers/outcomes/probabilities `TBD`.
**Canonical primary:** `data_extracted/text/GAME_sections.json` (@LOSTCITY0..9, @BURIAL1..3, @VANISH, @CASHTREASURE), `docs/GAME_MANUAL.md` (Rumors of Lost Cities, Corrupting Burial Grounds).

## 1. Purpose & behavior
A unit entering a "Lost City Rumor" map square triggers a random exploration
event. The manual states the outcome is a gamble: "there may be something of
value... or there may be nothing; it may be very dangerous... or benign; there
may be a Fountain of Youth, or an abandoned burial ground" (`docs/GAME_MANUAL.md`).
RECONSTRUCTED outcome set (manual, function only): treasure, Fountain of Youth
(burst of immigrants), nothing, danger, burial-ground desecration (native anger).

## 2. State & data
Message-template keys present in `GAME_sections.json` (each `BYTE_VERIFIED` as a
string asset; mapping key→outcome is `TBD`):
- `@LOSTCITY0` .. `@LOSTCITY9` — 10 rumor-outcome message templates.
- `@BURIAL1`, `@BURIAL2`, `@BURIAL3` — burial-ground desecration messages.
- `@VANISH` — unit/feature disappearance message.
- `@CASHTREASURE` — treasure-found message (also referenced by treasure transport).
- Related: `@FINDCITY`, `@NOCITY`, `@LOSTOURSCOUTS`, `@LOSTTHEIRSCOUTS`.

The mapping of each key to a concrete game effect, and the dispatch table that
selects among them, is not yet traced. → `spec/BACKLOG.md`.

## 3. Formulas & rules
- Outcome-selection probabilities: **TBD**.
- Fountain-of-Youth immigrant count: **TBD** (manual mentions immigration burst; no number in primary).
- Treasure value range: **TBD** (treasure transport entry `func_05C878`, `docs/ARCHITECTURE.md`, BYTE_VERIFIED entry point).
- Scout/Seasoned Scout modifier to outcomes: **TBD** (manual: "Seasoned Scout Better at exploring rumors").
- Burial-ground → native alarm increase: **TBD**.

## 4. UI
Outcome surfaced via the dialog/text-template framework (`func_06EEEC` text
template parser, `func_06F0F4` dialog framework — `docs/ARCHITECTURE.md`,
BYTE_VERIFIED entry points). Concrete layout `TBD`.

## 5. Evidence
- `data_extracted/text/GAME_sections.json` — @LOSTCITY0..9, @BURIAL1..3, @VANISH, @CASHTREASURE. **B** (strings).
- `docs/GAME_MANUAL.md` — Rumors of Lost Cities; Corrupting Burial Grounds; Seasoned Scout. **R** (function).
- `docs/ARCHITECTURE.md` — `func_05A20E` scout interactions; `func_05C878` treasure transport. **B** (entry points).

## 6. Open questions (TBD)
1. Trigger condition: which map feature flags a tile as a rumor square (see `spec/systems/map_system.md`).
2. Outcome dispatch table and per-outcome probabilities; bias by difficulty/scout type.
3. Numeric effects: treasure value, Fountain-of-Youth immigrant count, burial-ground alarm delta.
4. Entry function that consumes @LOSTCITY*/@BURIAL* — likely near scout-interaction `func_05A20E`.
