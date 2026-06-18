# Scoring

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** component list + weights `RECONSTRUCTED` (manual, HIGH for function); exact byte weights + difficulty factor `TBD`. **Canonical primary:** `docs/GAME_MANUAL.md` §"Colonization scoring"; `data_extracted/text/GAME_sections.json` `@SCORE`.

## 1. Purpose & behavior
At game end the player's empire is scored as a sum of component points, with a revolution bonus multiplier and a difficulty modifier. The score ranks the empire in the Hall of Fame and yields an "epitaph." **RECONSTRUCTED** (manual §"Colonization scoring"; function HIGH trust, but EXE bytes win for the exact numbers).

## 2. State & data
Inputs (all sourced from other systems): colonist counts by class (`@CLASS`/`UnitRecord +0x15`), founding fathers joined, treasury gold (`PowerRecord +0x2A`), rebel sentiment (`PowerRecord +0x02`), native settlements destroyed, difficulty (`DGROUP:0x53A6`).

No dedicated score-accumulator global identified yet: **TBD — not yet traced.**

## 3. Formulas & rules — manual schedule (RECONSTRUCTED; byte-verify each)
- **Population:** +1 per petty criminal / indentured servant; +2 per free colonist; +4 per skilled colonist.
- **Continental Congress:** +5 per Founding Father in Congress.
- **Treasury:** +1 per 1000 gold.
- **Rebel Sentiment:** +1 per point of rebel sentiment.
- **Indian Destruction Penalty:** −(difficulty + 1) per native settlement destroyed.
- **Revolution Bonus (multiplier):** ×2.0 if first to independence; ×1.5 if one other power declared first; ×1.25 if two did. **+1 per liberty bell produced after foreign intervention.** Pre-1780 declaration adds an extra bonus (sooner = larger).
- **Difficulty factor:** final score modified by a factor derived from the chosen difficulty level.

> All of the above are **manual numbers (RECONSTRUCTED)**. Per the trust hierarchy, EXE bytes win — each weight must be byte-verified before it is promoted to `BYTE_VERIFIED`. Do not assert these as proven.

## 4. UI
F10 "Current Colonization Score" (manual menu map). End-game score sequence + Hall of Fame. Score plates: `SCORE*.SS`. Strings: `@SCORE`, `@SCORED` (GAME.TXT, **BYTE_VERIFIED present**). See `docs/SESSION_UI_CATALOG.md`, `docs/SCREEN_ASSET_REQUIREMENTS.md`.

## 5. Evidence
- `docs/GAME_MANUAL.md` §"Colonization scoring" — component list + weights + revolution/difficulty modifiers. **R (function HIGH)**
- `data_extracted/text/GAME_sections.json` — `@SCORE`, `@SCORED` keys present. **B (present)**
- Cross-refs: `docs/DATA_MODEL.md` (`PowerRecord +0x2A` gold, `+0x02` rebel sentiment; `0x53A6` difficulty). **B**

## 6. Open questions (TBD)
1. Byte-verify each component weight (1/2/4 population, +5 father, /1000 gold, +1 sentiment, −(diff+1) razed).
2. Locate the score-computation function (F10 reader + end-game) and any score accumulator global.
3. Byte-verify the revolution multipliers (2.0/1.5/1.25), the post-intervention bell bonus, and the difficulty factor.
