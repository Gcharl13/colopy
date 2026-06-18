# European Diplomacy

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** war state location `ANCHOR_VERIFIED` (ruling); treaty/war logic `TBD`. **Canonical primary:** `notes/rulings/RULINGS.md` (war bit-matrix ruling); `data_extracted/text/GAME_sections.json` treaty/war keys; `docs/GAME_MANUAL.md`.

## 1. Purpose & behavior
The player coexists with three rival European powers (English/French/Spanish/Dutch set). They can sign treaties, declare war, make peace, and conduct hostile actions (privateering, blockades). Relations are tracked as boolean war/peace state between power pairs, surfaced through diplomatic dialogs. **RECONSTRUCTED** (manual + GAME.TXT keys).

## 2. State & data
- **War bit-matrix** at `DGROUP:0x883C` — the real diplomatic state is a boolean war matrix between powers, NOT a per-PowerRecord field. **ANCHOR_VERIFIED** via `notes/rulings/RULINGS.md` (a byte finding recorded as a ruling: "war bit set at 0x883C"). Exact matrix dimensions/bit layout: **TBD**.
- PowerRecord base `DGROUP:0x8808`, stride 316 (0x13C), 4 powers (per `spec/systems/king.md`) — but per-pair war state lives in the `0x883C` matrix, not in PowerRecord.

> `func_03ECF0` was previously mislabeled "diplomatic_action_init" — per `RULINGS.md` it is actually the **per-unit confrontation/command AI evaluator** (`0x03ECF0..0x03F90C`). **Do NOT cite `func_03ECF0` as the diplomacy handler.**

## 3. Formulas & rules
- War declaration / peace acceptance / treaty terms / AI willingness: **TBD** (no verified handler; the `0x883C` writer is the place to trace).
- Privateer attribution, blockade, gold/gift demands: **TBD**.

## 4. UI
Diplomatic dialogs use GAME.TXT keys: `@SIGNTREATY @HAVETREATY @DECLAREWAR @CANCELPEACE @PEACEMANLY @PEACEMEEK @OLDPEACEMANLY @OLDPEACEMEEK @WARMANLY @WARMEEK @WARN1 @WARN2 @WARN3`. **All BYTE_VERIFIED present.** See `docs/SESSION_UI_CATALOG.md`, `docs/UI_DIALOGS.md`.

## 5. Evidence
- `notes/rulings/RULINGS.md` — war bit-matrix at `DGROUP:0x883C`; `func_03ECF0` re-attribution (NOT diplomacy). **A (ruling)**
- `data_extracted/text/GAME_sections.json` — treaty/war/peace dialog keys present. **B**
- `docs/GAME_MANUAL.md` — diplomacy function (rivals, treaties, war). **R**

## 6. Open questions (TBD)
1. Decode the `0x883C` war matrix layout (dimensions, which bit = which power pair, self-vs-king vs power-vs-power).
2. Find the real diplomacy dispatcher (declare-war / sign-treaty handlers) feeding the `@WAR*`/`@TREATY` strings.
3. Byte-trace AI peace/war willingness and any treaty-term state.
