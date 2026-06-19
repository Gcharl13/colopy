# Random Events / Lost City Rumors

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** event strings `BYTE_VERIFIED`; **Lost-City rumor: handler + index→`@LOSTCITY<n>` + reward `[bp-0x32]·100` + scout bonus `BYTE_VERIFIED`** (`func_061454`); per-index *meaning* `TBD`. (`func_05BE84` is the native **raid** handler — see `natives.md`.)
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

### Native **raid**-on-colony outcomes — `func_05BE84` (see `natives.md` §3)
> **Correction (2026-06-19):** `func_05BE84` is the **native-RAID** outcome
> dispatcher (message keys `RAIDWREAK/RAIDSTORES/RAIDBURN/RAIDSHIP/RAIDGOLD/
> RAIDNOTHING`), **not** the Lost-City rumor selector. The roll/dispatch mechanics
> are byte-verified — moved to **`spec/systems/natives.md` §3**.

### Lost-City rumor outcome selection — **BYTE_VERIFIED handler** (`func_061454`, file `0x61454`)
- Builds the outcome key as **`"LOSTCITY" + digit`** dynamically (bare `LOSTCITY`
  string `@0x618C2`), so `@LOSTCITY0..9` are selected by a computed index.
- **Scout bonus is byte-confirmed:** it tests the triggering unit's
  `unit_type == 5` (Scout, `@0x614A6`) and class byte `UnitRecord +0x15 == 0x16`
  (Seasoned Scout, `@0x614BB`) — the manual's "Seasoned Scout better at exploring
  rumors".
- **Outcome index → message (BYTE_VERIFIED):** the index `n = [bp-6]` is chosen by
  scout-boosted `random_int` (`0x181F:0x4D4`) rolls (`@0x614FA..0x6175A`), then the
  shown key is **`@LOSTCITY<n>`** directly — `sprintf("LOSTCITY", …)` `@0x618C9`
  then appends `n` `@0x618D1` (observed indices 1, 2, 4, 6). The message substitutes
  a **reward amount = `[bp-0x32]·100`** (gold ×100) and `[bp-0x10]` `@0x618A1..0x618BF`.
- **One-time special (`n=4`):** gated by a per-power flag `[0x543E]` bit `0x40`
  (`@0x6186B`: set on first occurrence, so outcome 4 fires once per power).
- Remaining **TBD:** which `@LOSTCITY0..9` body is treasure vs Fountain-of-Youth vs
  burial (needs the message bodies) and the per-index reward magnitudes.
- Fountain-of-Youth immigrant count: **TBD** (manual mentions immigration burst; no number in primary).
- **Treasure value & transport** — `func_05C878` (file `0x5C878`; strings `CASHTREASURE`/`KINGGALLEON`/`LOOTCASH`). **BYTE_VERIFIED:** treasure gold = **`100 × UnitRecord[+0x15]`** (a Treasure unit stores value/100 in its class byte) `@0x5C882`. **Post-independence** (`[0x5382]&1`) it is cashed directly (no cut) `@0x5C88B`; **pre-independence** the King offers to transport it for a **per-difficulty fee** read from the word table at `DGROUP:0x8394` (indexed by `difficulty×2`) `@0x5C8C2`, substituted into the `@KINGGALLEON` message. Fee *values* are in the data segment (TBD); the mechanism is byte-verified.
- Burial-ground → native alarm increase: **TBD**.

## 4. UI
Outcome surfaced via the dialog/text-template framework (`func_06EEEC` text
template parser, `func_06F0F4` dialog framework — `docs/ARCHITECTURE.md`,
BYTE_VERIFIED entry points). Concrete layout `TBD`.

## 5. Evidence
- `data_extracted/text/GAME_sections.json` — @LOSTCITY0..9, @BURIAL1..3, @VANISH, @CASHTREASURE. **B** (strings).
- `func_061454` (file `0x61454`) — Lost-City rumor handler: builds `LOSTCITY`+digit; checks unit_type 5 (Scout) + class 0x16 (Seasoned Scout). **B**
- `docs/GAME_MANUAL.md` — Rumors of Lost Cities; Corrupting Burial Grounds; Seasoned Scout. **R** (function).
- `docs/ARCHITECTURE.md` — `func_05A20E` scout interactions; `func_05C878` treasure transport. **B** (entry points).
- `func_05BE84` — native **raid** outcome dispatch (RAID* keys) — see `natives.md` §3. **B**

## 6. Open questions (TBD)
1. Trigger condition: which map feature flags a tile as a rumor square (see `spec/systems/map_system.md`).
2. Outcome dispatch table and per-outcome probabilities; bias by difficulty/scout type.
3. Numeric effects: which `@LOSTCITY0..9` index = treasure/Fountain-of-Youth/burial, and per-index reward magnitudes (reward = `[bp-0x32]·100`; mechanism B, the per-index amounts TBD).
4. ~~Entry function that consumes @LOSTCITY*/@BURIAL*.~~ **Found 2026-06-19** — `func_061454` (builds `LOSTCITY`+digit; Scout/Seasoned-Scout check **B**). Remaining: the index→`@LOSTCITYn` mapping + Fountain-of-Youth/burial numerics.
