# Scoring

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** **score scaling formula + difficulty multiplier + rank + accumulator + population-component weights `BYTE_VERIFIED`** (`func_03A9C0`; population gates in paged `0x191F:0x3AA`→`0x39EE2`); **revolution bonus = additive `(1780−decl_year)×2`** `BYTE_VERIFIED` (2026-06-20, §6.3); remaining component weights (father/gold/sentiment/razed) `RECONSTRUCTED` (manual; reachable in the same paged function). **Canonical primary:** `func_03A9C0`; `docs/GAME_MANUAL.md` §"Colonization scoring"; `data_extracted/text/GAME_sections.json` `@SCORE`.

## 1. Purpose & behavior
At game end the player's empire is scored as a sum of component points, with a revolution bonus multiplier and a difficulty modifier. The score ranks the empire in the Hall of Fame and yields an "epitaph." **RECONSTRUCTED** (manual §"Colonization scoring"; function HIGH trust, but EXE bytes win for the exact numbers).

## 2. State & data
Inputs (all sourced from other systems): colonist counts by class (`@CLASS`/`UnitRecord +0x17`, abs `0x315B`), founding fathers joined, treasury gold (`PowerRecord +0x2A`), rebel sentiment (`PowerRecord +0x02`), native settlements destroyed, difficulty (`DGROUP:0x53A6`).

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
  manual's "difficulty factor". It is **computed, not a stored table**
  (`@0x3AA0F`: `mult = difficulty + 4`, `+1 if diff≥3`, `+1 if diff≥4`), yielding
  `{0→4, 1→5, 2→6, 3→8, 4→10}`. **B**
- `base` (the component points) is computed in the paged function
  **`0x191F:0x3AA` → file `0x39EE2`** (resolved via `tools/follow_thunk.py`). It
  seeds the accumulator with **year terms** (`100·[0x53A7] + [0x53A8]` = the
  reconstructed year per RULINGS 2026-05-30 — see §6.3; `[0x53A7]`=year/100,
  `[0x53A8]`=year mod 100; **not** king-anger, which is real but UNLOCATED/TBD)
  (`@0x39EE6`) and adds **weighted components**; this same function both computes
  the sum and renders the F10 breakdown lines (via text thunks
  `0x181F:0x16E/0x178/0x182`). Byte-visible per-line weights include **5, 16
  (`0x10`), 24 (`0x18`), 97 (`0x61`)**.

  **Population component — BYTE_VERIFIED (`@0x3A09A..0x3A117`).** A nested loop
  over each owned colony (count `[0x539E]`, `ColonyRecord` via `[0x8542]`, owner
  `+0x1A == player`, population size `+0x1F` `@0x3A0E1`) classifies every
  colonist by a profession byte (fetched via `0x181F:0xC54` → `0x181F:0x2C6`,
  stored `[bp-0x70]`; this is the `UnitRecord +0x17` profession (abs `0x315B`), range `0..0x1C`):
  - profession `∈ {0x19, 0x1A, 0x1B}` → **+1** (`@0x3A0BE..0x3A0D0`);
  - profession `== 0x1C` → **+2** (`@0x3A10D..0x3A113`);
  - any other profession → **+4** (`@0x3A0D6`).

  This **byte-confirms the manual's population tiers** (+1 petty criminal /
  indentured servant, +2 free colonist, +4 skilled colonist) with the exact
  profession-byte gates; the subtotal accrues in `[bp-0x6E]` and is rendered as
  the population score line `@0x3A261`. **B.** (The exact profession-name ↔ value
  binding for `0x19/0x1A/0x1B/0x1C` follows from `@CLASS`; the score gates are
  byte-exact regardless.)

  **The component enumeration is now BYTE_VERIFIED** at the grand-total
  summation `@0x3A896–@0x3A8AB`, which sums exactly seven subtotal locals into
  the returned `base` (stored `[bp-0x74]`):
  `[bp-0x64]` revolution bonus + `[bp-0x58]` founding fathers + `[bp-0x6c]`
  Indian-destruction penalty + `[bp-0x60]` (a flag-2-gated %-derived term) +
  `[bp-0x5a]` (`[0x53d0]`, capped 100) + `[bp-2]` treasury + `[bp-0x6e]`
  population. Per-line weights proven: **+5 per founding father** (loop
  `[bp-0x66]`=0..0x18 over 25 fathers, ownership test `lcall 0x181f,0x7b4`,
  `add [bp-0x58],5` `@0x3A2BE`); **gold/1000** (`[0x84fc]+0x2A/+0x2C` ÷ `0x3E8`
  via `lcall 0xd1d,0xec6` `@0x3A3F2–@0x3A402`, → `[bp-2]`); **razed × −(diff+1)**
  (`[0x84fc]+0x18` × `(0xFFFF − [0x53A6])` `@0x3A4B1–@0x3A4C5`, → `[bp-0x6c]`).
  The bytes `[0x830]`/`[0x831]` are NOT component counts — they are persisted
  savegame bytes (deserialized in sequence `@0x751A7`/`@0x751AF`) passed as a
  render-style argument to the per-line draw thunk `lcall 0x181f,0x13c`. **B.**
- A Hall-of-Fame **rank 0..23** is derived from the score (largest `n` with
  `n²/3 < score`, capped at 23). **B** (`@0x3AA41..0x3AA79`).
- Score accumulator global `[0x372]` (zeroed at entry, written during scoring). **B**

### Component schedule — manual (RECONSTRUCTED; byte-verify each behind `0x191F:0x3AA`)
- **Population:** +1 per petty criminal / indentured servant; +2 per free colonist; +4 per skilled colonist. **— now BYTE_VERIFIED** (profession-byte gates `{0x19,0x1A,0x1B}→+1`, `0x1C→+2`, else `+4`; see §3 population component).
- **Continental Congress:** +5 per Founding Father in Congress. **— BYTE_VERIFIED** (`func_039EE2`: loop index `[bp-0x66]` over 0..0x18 = 25 fathers, ownership via `lcall 0x181f,0x7b4(idx,player)`, `add [bp-0x58],5` `@0x3A2BE`; subtotal `[bp-0x58]` enters the grand total `@0x3A899`).
- **Treasury:** +1 per 1000 gold. **— BYTE_VERIFIED** (`func_039EE2 @0x3A3F2–@0x3A402`: 32-bit treasury `[0x84fc]+0x2A` (low) / `+0x2C` (high) divided by `0x3E8`=1000 via `lcall 0xd1d,0xec6`, result → `[bp-2]`, which enters the grand total `@0x3A8A5`).
- **Rebel Sentiment:** +1 per point of rebel sentiment.
- **Indian Destruction Penalty:** −(difficulty + 1) per native settlement destroyed. **— BYTE_VERIFIED** (`func_039EE2 @0x3A4B1–@0x3A4C5`: razed count `[0x84fc]+0x18` (`al`) × `cx = 0xFFFF − [0x53A6]` = −(difficulty+1), `imul cx` → `[bp-0x6c]`, which enters the grand total `@0x3A89C`).
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
2. ~~Byte-verify the population weights (1/2/4).~~ **Done 2026-06-19** — profession-byte gates `{0x19,0x1A,0x1B}→+1`, `0x1C→+2`, else `+4` at `@0x3A09A..0x3A117` (**B**). **+5 father, /1000 gold, −(diff+1) razed now also BYTE_VERIFIED** in `func_039EE2` (father loop `@0x3A2BE`; gold÷1000 `@0x3A3F2–@0x3A402`; razed×−(diff+1) `@0x3A4B1–@0x3A4C5`); the 7-term grand-total summation is `@0x3A896–@0x3A8AB`. **Still TBD:** the `+1 sentiment` weight — the corresponding subtotal `[bp-0x5a]` is read ×1 from global `[0x53d0]` (incremented by 0x14 and capped at 100 `@0x3BE64`), but `[0x53d0]` is not yet byte-bound to "rebel sentiment" (spec §2 cites `PowerRecord +0x02`, a different source), and the flag-2-gated `[bp-0x60]` term (`[0x84fc]+0xC ÷ 100`, capped 100, `@0x3A70F`) is unlabeled.
3. ~~Byte-verify the revolution multipliers (2.0/1.5/1.25).~~ **RESOLVED 2026-06-20 — the
   bonus is ADDITIVE, not a multiplier** (the manual's "1×/0.5×/0.25×" framing is wrong;
   EXE wins). In `func_039EE2` (reached from the accumulator `func_03A9C0` `@0x3B340`),
   gated on **independence won** (`test [0x5382],8` `@0x3A5F5`) **and** declaration year
   `< 1780` (`cmp [bp-0x6A],0x6F4` `@0x3A5FF`), the score gains
   **`(1780 − declaration_year) × 2` points** (`@0x3A609`: `mov ax,0x6F4; sub
   ax,decl_year; shl ax,1`). The **declaration year** is recorded by the WoI handler
   `func_03DE46` into `[0x53A7]` (year÷100) / `[0x53A8]` (year mod 100) (`@0x3DE65`/
   `@0x3DE6F`) and reconstructed `@0x39EE6`. So *earlier* declaration → *larger* additive
   bonus (e.g. 1700 → +160, 1776 → +8); `≥1780` → none. **B.** *(The earlier "(8>>n+8)/8"
   scaling in the same function is an unrelated per-power-count display value, not this.)*
