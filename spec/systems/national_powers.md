# National Powers / Abilities

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** nation roster + leaders `BYTE_VERIFIED`; **English & Spanish
ability effects `BYTE_VERIFIED`** (traced in `VICEROY.EXE`); French & Dutch effects
`R` (manual) with the byte-site narrowed.
**Canonical primary:** `data_extracted/text/NAMES_sections.json`
(@COUNTRY/@NATIONALITY/@NATIONABBREV/@HOMEPORT/@LEADERNAME/@COLONYNAME/@INDEPENDENT),
`docs/GAME_MANUAL.md` (Choose Your Nationality); `VICEROY.EXE` `func_035D9A`
(English crosses), `func_05CA7E` (Spanish combat).

## 1. Purpose & behavior
Each of the four European powers has one special power that shapes strategy
(`docs/GAME_MANUAL.md`). The four power **slots are fixed to nationalities**
(index `0..3` = English/French/Spanish/Dutch), so every effect is gated by a
literal `power_index == N` test:
- **English (0)** — produce a greater number of immigrants. **BYTE_VERIFIED**:
  the crosses-needed **threshold is multiplied by `2/3`** (`func_035D9A @0x035E6E`:
  `cmp [0x9E12],0 / jne / shl ax,1 / idiv 3`), so English need only ⅔ the crosses
  → immigrants arrive ~50% faster.
- **French (1)** — live among natives more peacefully (lower native alarm growth).
  **R** (manual); gate not yet pinned — see §3.
- **Spanish (2)** — **+50% attack vs natives**. **BYTE_VERIFIED**: in the land
  decider, attacker owner `== 2` **and** defender owner `>= 4` (a native) →
  attack strength `+= strength/2` (×1.5) (`func_05CA7E @0x05CF2F..0x05CF4D`:
  `cmp [bp-0x86],2 / cmp [bp-0x76],4 / mov ax,[bp-0x90]; sar ax,1; add [bp-0x90],ax`,
  then sets report-flag `[0x8D01] |= 0x10`).
- **Dutch (3)** — more stable Amsterdam prices (less price drift) **and start with
  a trading vessel**. **R** (manual); byte-site narrowed — see §3.

## 2. State & data
All four-row tables below are **BYTE_VERIFIED** (data present in `NAMES_sections.json`),
indexed by power 0..3 = English/French/Spanish/Dutch. **This index is the
nationality** — every national-power effect is a literal `power_index == N` test
(confirmed for English `==0` and Spanish `==2`):

| Idx | @NATIONALITY | @COUNTRY (+num) | @HOMEPORT | @COLONYNAME | @INDEPENDENT | @LEADERNAME (+3 nums) |
|-----|--------------|-----------------|-----------|-------------|--------------|------------------------|
| 0 | English | England, 12 | London | New England | United States of America | Walter Raleigh, 1, -1, 0 |
| 1 | French | France, 9 | La Rochelle | New France | Republic of Quebec | Jacques Cartier, 0, 1, 0 |
| 2 | Spanish | Spain, 14 | Seville | New Spain | Republic of Mexico | Christopher Columbus, 1, 0, -1 |
| 3 | Dutch | Netherlands, 13 | Amsterdam | New Netherlands | Republic of Surinam | Michiel De Ruyter, -1, 0, 1 |

- `@NATIONABBREV`: Eng. / Fr. / Span. / Dutch. **B**
- **`@LEADERNAME` trailing triplet — BYTE_VERIFIED (location/use):** the three
  numbers per leader are stored as a per-power byte triplet at **`DGROUP:0x9566`,
  stride 3** (`power*3`), read at **`@0x547A1`** (`bx=[bp-0x1ae]; bx*3;
  al=byte[bx-0x6a9a]` where `-0x6a9a ≡ 0x9566`) — they are loaded as
  **AI-personality bias values** at AI setup. The triplets are
  `(1,-1,0)/(0,1,0)/(1,0,-1)/(-1,0,1)` for English/French/Spanish/Dutch — a
  signed per-axis personality lean (zero-sum across the four), not gameplay
  multipliers. The **`AIPersonality` record (`0x540E`) `+0x00` holds the
  leader-name STRING and `+0x18` the colony-name STRING** — these are text, not
  the numeric triplet.
- **`@COUNTRY` trailing number — BYTE_VERIFIED (location):** one byte per nation
  at **`DGROUP:0x848`**, read at **`@0x70813`** (`al=byte[bx+0x848]`). It is the
  nation's index/id used by the country-selection setup path (12/9/14/13 in the
  table below); not a gameplay modifier. Its full downstream use is **TBD**.
- Owning-power index stored in records as `owner_power_idx` (e.g. ColonyRecord
  `+0x1A`, BYTE_VERIFIED — `docs/DATA_MODEL.md`, `spec/systems/colony.md`).

## 3. Formulas & rules
Byte status of each national-power effect:
- **English (0) immigration** — crosses **threshold × 2/3**. **BYTE_VERIFIED**
  (`func_035D9A @0x035E6E`; the threshold base is `(8−difficulty)·Σcolony_crosses/8`,
  then ×2/3 for power 0). Lower threshold = faster immigrant arrival.
- **Spanish (2) +50% vs natives** — attacker land strength **×3/2** when
  `attacker_power==2 && defender_power>=4`. **BYTE_VERIFIED** (`func_05CA7E
  @0x05CF43`). (Distinct from the unconditional native-defender `÷4` at `@0x05CEE2`
  and the war-of-independence ×3/2 at `@0x05CF82`, which are not nationality-gated.)
- **French (1) native attitude** — **R** (manual). Narrowed: the per-(settlement·9
  + power) **alarm/tension array is `DGROUP:0x54F6`** (word, raid threshold `0x80`;
  `spec` native AI). A French discount would scale the alarm **increment**; the
  located `0x54F6` sites are caps/resets (`@0x045FC1` clamp, `@0x05DF7D` reset) —
  the additive-increment site with a `power==1` test is **TBD**.
- **Dutch (3) price stability + starting ship** — **R** (manual). Narrowed: the
  per-turn drift `func_0305A8` is per-good global (`0x53EA`), not per-power, so the
  Dutch damping is in the **per-sale price-drop** path (market sensitivity
  `PowerRecord +0x4C`) — a `power==3` test there is **TBD**. The **starting trading
  vessel** is set in the **new-game unit-setup overlay** (not in `@SCENARIO`, which
  carries only x,y), also **TBD**.

## 4. UI
Chosen on the "Choose Your Nationality" setup screen with ability descriptions
(manual). Layout `TBD`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — @COUNTRY/@NATIONALITY/@NATIONABBREV/@HOMEPORT/@COLONYNAME/@INDEPENDENT/@LEADERNAME. **B**
- `VICEROY.EXE` `func_035D9A` (`0x035D9A`, crosses threshold) — English power-0 gate
  `@0x035E6E` (`cmp [0x9E12],0`; `×2/3`). **B**
- `VICEROY.EXE` `func_05CA7E` (`0x05CA7E`, land decider) — Spanish power-2 vs-native
  `+50%` `@0x05CF2F..0x05CF4D`. **B**
- `docs/GAME_MANUAL.md` — four national-power descriptions (English immigration,
  French native peace, Spanish +50% vs natives, Dutch stable prices + start ship). **R**
- `docs/DATA_MODEL.md` — `owner_power_idx` in records; native alarm array `0x54F6`. **B**

## 6. Open questions (TBD)
1. **French (1):** find the native-alarm **increment** site that scales by
   `power==1` (alarm array `DGROUP:0x54F6`, threshold `0x80`).
2. **Dutch (3):** find the per-sale **price-drop** `power==3` damping (sensitivity
   `PowerRecord +0x4C`) and the **starting-ship** grant in the new-game setup overlay.
3. ~~Decode the `@LEADERNAME` and `@COUNTRY` trailing numbers (AI bias?).~~
   **Done 2026-06-20** — `@LEADERNAME` triplet → `DGROUP:0x9566` stride 3
   (`@0x547A1`), loaded as AI-personality bias axes; `@COUNTRY` number →
   `DGROUP:0x848` byte/nation (`@0x70813`), nation index for setup. Both **B**
   for location; the numbers are **not** gameplay multipliers.
4. Confirm the power-index ordering is fixed at 0..3 across all record types.
