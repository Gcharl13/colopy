# Scoring

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** **score scaling formula + difficulty multiplier + rank + accumulator `BYTE_VERIFIED`** (`func_03A9C0`); component weights `RECONSTRUCTED` (manual; behind paged thunk `0x191F:0x3AA`). **Canonical primary:** `func_03A9C0`; `docs/GAME_MANUAL.md` §"Colonization scoring"; `data_extracted/text/GAME_sections.json` `@SCORE`.

## 1. Purpose & behavior
At game end the player's empire is scored as a sum of component points, with a revolution bonus multiplier and a difficulty modifier. The score ranks the empire in the Hall of Fame and yields an "epitaph." **RECONSTRUCTED** (manual §"Colonization scoring"; function HIGH trust, but EXE bytes win for the exact numbers).

## 2. State & data
Inputs (all sourced from other systems): colonist counts by class (`@CLASS`/`UnitRecord +0x15`), founding fathers joined, treasury gold (`PowerRecord +0x2A`), rebel sentiment (`PowerRecord +0x02`), native settlements destroyed, difficulty (`DGROUP:0x53A6`).

Score accumulator global **`DGROUP:0x372`** — zeroed at the top of `func_03A9C0` and written during scoring. **BYTE_VERIFIED** (`@0x3A9E5`/`@0x3A9EC`).

## 3. Formulas & rules

### Score scaling — **BYTE_VERIFIED** (`func_03A9C0`, file `0x3A9C0`)
```
base   = func_03B36A(player)          # component sum (see schedule below)
diff   = [0x53A6]                      # 0..4
mult   = diff + 4 + (diff>=3) + (diff>=4)   # @0x3AA0A..0x3AA27
       = { Discoverer:4, Explorer:5, Conquistador:6, Governor:8, Viceroy:10 }
score  = (mult * base) / 100          # @0x3AA31..0x3AA3E (imul; idiv 100)
score  = score >> 1                   # @0x3AA6A (halved)
```
- The **difficulty multiplier `[4,5,6,8,10]`** is byte-verified — this is the
  manual's "difficulty factor". **B**
- `base` (the component points) is computed in the paged function
  **`0x191F:0x3AA` → file `0x39EE2`** (resolved via `tools/follow_thunk.py`). It
  seeds the accumulator with King-anger terms (`100·[0x53A7] + [0x53A8]`
  `@0x39EE6`) and adds **weighted components** (e.g. a `+5` weight at `@0x39F55`,
  consistent with the manual's "+5 per Founding Father"). Byte-visible per-line
  weights include **5, 16 (`0x10`), 24 (`0x18`), 97 (`0x61`)**; this function both
  computes the sum and renders the F10 breakdown lines (via text thunks
  `0x181F:0x16E/0x178/0x182`). Mapping each weight to its labelled component
  requires following each line's `@SCORE*` label — the count globals (`[0x830]`,
  `[0x831]`) have no xrefs to confirm them yet — so the **full per-component
  enumeration** is the remaining `RECONSTRUCTED`→`B` step (now reachable, not blocked).
- A Hall-of-Fame **rank 0..23** is derived from the score (largest `n` with
  `n²/3 < score`, capped at 23). **B** (`@0x3AA41..0x3AA79`).
- Score accumulator global `[0x372]` (zeroed at entry, written during scoring). **B**

### Component schedule — manual (RECONSTRUCTED; byte-verify each behind `0x191F:0x3AA`)
- **Population:** +1 per petty criminal / indentured servant; +2 per free colonist; +4 per skilled colonist.
- **Continental Congress:** +5 per Founding Father in Congress.
- **Treasury:** +1 per 1000 gold.
- **Rebel Sentiment:** +1 per point of rebel sentiment.
- **Indian Destruction Penalty:** −(difficulty + 1) per native settlement destroyed.
- **Revolution Bonus (multiplier):** ×2.0 if first to independence; ×1.5 if one other power declared first; ×1.25 if two did. **+1 per liberty bell produced after foreign intervention.** Pre-1780 declaration adds an extra bonus (sooner = larger).
- **Difficulty factor:** ~~derived from difficulty~~ — **byte-verified** as `[4,5,6,8,10]`/100, see §3 scaling.

> All of the above are **manual numbers (RECONSTRUCTED)**. Per the trust hierarchy, EXE bytes win — each weight must be byte-verified before it is promoted to `BYTE_VERIFIED`. Do not assert these as proven.

## 4. UI
F10 "Current Colonization Score" (manual menu map). End-game score sequence + Hall of Fame. Score plates: `SCORE*.SS`. Strings: `@SCORE`, `@SCORED` (GAME.TXT, **BYTE_VERIFIED present**). See `docs/SESSION_UI_CATALOG.md`, `docs/SCREEN_ASSET_REQUIREMENTS.md`.

## 5. Evidence
- `func_03A9C0` (file `0x3A9C0`) — score scaling: difficulty multiplier `[4,5,6,8,10]`, `score=(mult*base)/100>>1`, rank `n²/3<score` (≤23), accumulator `[0x372]`. **B**
- `func_03B36A` → `LJMP 0x191F:0x3AA` — the component-sum (`base`), paged overlay; weights TBD behind it.
- `docs/GAME_MANUAL.md` §"Colonization scoring" — component list + weights + revolution/difficulty modifiers. **R (function HIGH)**
- `data_extracted/text/GAME_sections.json` — `@SCORE`, `@SCORED` keys present. **B (present)**
- Cross-refs: `docs/DATA_MODEL.md` (`PowerRecord +0x2A` gold, `+0x02` rebel sentiment; `0x53A6` difficulty). **B**

## 6. Open questions (TBD)
1. ~~Locate the score-computation function + accumulator.~~ **Done 2026-06-19** — `func_03A9C0`, accumulator `[0x372]`; scaling/rank now **B**.
2. Byte-verify each component weight (1/2/4 population, +5 father, /1000 gold, +1 sentiment, −(diff+1) razed) — behind the paged thunk `0x191F:0x3AA` (`func_03B36A`).
3. Byte-verify the revolution multipliers (2.0/1.5/1.25) + post-intervention bell bonus (also in the paged component sum).
