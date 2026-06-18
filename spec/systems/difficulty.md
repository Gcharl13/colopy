# Difficulty Levels

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** 5 level names + global byte `BYTE_VERIFIED`; per-level
modifiers `TBD`.
**Canonical primary:** `data_extracted/text/NAMES_sections.json` (@DIFFICULTY),
`docs/DATA_MODEL.md` (DGROUP `0x53A6`).

## 1. Purpose & behavior
A difficulty level chosen at setup adjusts many factors to make the game easier
or harder (`docs/GAME_MANUAL.md`). Five levels, ascending:

| Idx | Name | Manual gist |
|-----|------|-------------|
| 0 | Discoverer | easiest; novice players |
| 1 | Explorer | opponents stronger/smarter, natives less friendly |
| 2 | Conquistador | enemies substantially more aggressive |
| 3 | Governor | opponents evenly matched with player |
| 4 | Viceroy | hardest; winnable but not consistently |

Names `BYTE_VERIFIED` from `@DIFFICULTY`; ordering matches manual.

## 2. State & data
- `@DIFFICULTY` (`NAMES_sections.json`): 5 level strings (above). **BYTE_VERIFIED**.
- **DGROUP `0x53A6`** — byte holding "difficulty / current player (0..4)"
  (`docs/DATA_MODEL.md:280`, BYTE_VERIFIED via king-tax + SMITE byte-traces;
  also listed `docs/ARCHITECTURE.md:108`). **BYTE_VERIFIED**.
  > Note: this single byte is documented as serving both "current player" and
  > "difficulty" roles; disambiguate at the read site before relying on it.

## 3. Formulas & rules
Per-level numeric modifiers are **TBD** — none are byte-verified in primary yet.
Known *touch points* where difficulty feeds a formula (entry points only):
- Score difficulty factor (`docs/GAME_MANUAL.md`: "modified by a difficulty
  factor"; score formula `func_03A9C0`, `docs/ARCHITECTURE.md`). Magnitude **TBD**.
- Indian Destruction Penalty = `-(difficulty + 1)` per native settlement destroyed
  (`docs/GAME_MANUAL.md`). **R** (manual formula; byte-confirm pending).
- A manual reference notes a per-level count "10 at Discoverer ... 6 at Viceroy"
  for some mechanic (`docs/GAME_MANUAL.md:3528`) — context **TBD**.
- King tax / native attitude / AI aggression scaling: **TBD**.

## 4. UI
Selected on the difficulty-selection setup screen (manual). Strings in the
opening/menu catalogs; layout `TBD`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@DIFFICULTY` (5 names). **B**
- `docs/DATA_MODEL.md:280` / `docs/ARCHITECTURE.md:108` — DGROUP `0x53A6`. **B**
- `docs/GAME_MANUAL.md` — level descriptions; difficulty score factor; Indian penalty. **R**

## 6. Open questions (TBD)
1. Byte-trace per-level modifier table (AI aggression, native friendliness, economy).
2. Resolve the `0x53A6` dual role (difficulty vs current player) at read sites.
3. Confirm the score difficulty factor and Indian-destruction penalty in bytes.
