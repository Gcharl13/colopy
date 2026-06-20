# National Powers / Abilities

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** nation roster + leaders `BYTE_VERIFIED`; **all four ability
effects fully `BYTE_VERIFIED`** (English immigration ×2/3 crosses, French
native-tension ×½, Spanish +50% vs natives, Dutch price-pool ×2/3 **+** starting
Merchantman — all traced in `VICEROY.EXE`).
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
- **French (1)** — live among natives more peacefully. **BYTE_VERIFIED**: in the
  native tension-raise applier `func_045DF2`, when the power index `== 1` (French)
  and the tension delta is positive, the delta is **halved** (`@0x45E21`:
  `cmp [bp+8],1; jne; cmp [bp+0xa],0; jle; sar [bp+0xa],1`) — so the French raise
  native tension at **half rate**. (Pocahontas FF 16 applies a second, independent
  halving at `@0x45E30`.)
- **Spanish (2)** — **+50% attack vs natives**. **BYTE_VERIFIED**: in the land
  decider, attacker owner `== 2` **and** defender owner `>= 4` (a native) →
  attack strength `+= strength/2` (×1.5) (`func_05CA7E @0x05CF2F..0x05CF4D`:
  `cmp [bp-0x86],2 / cmp [bp-0x76],4 / mov ax,[bp-0x90]; sar ax,1; add [bp-0x90],ax`,
  then sets report-flag `[0x8D01] |= 0x10`).
- **Dutch (3)** — more stable Amsterdam prices. **BYTE_VERIFIED**: in the SELL
  market-accumulator updater `func_03234A`, the per-player market-pool delta is
  applied at full value for players 0–2 but **`×2/3` for player 3 (Dutch)**
  (`@0x32390`: `cmp [bp-8],3; jne; ax = (delta·2)/3`) — so Dutch trades move the
  market pool less ⇒ stabler prices. **And the starting ship is upgraded
  Caravel→Merchantman** for power 3 (`@0x075875`, see §3). Both halves **B**.

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
- **French (1) native attitude** — **BYTE_VERIFIED 2026-06-20.** The increment site
  is `func_045DF2` (the **native tension-raise applier** for the `DGROUP:0x5B1C`
  per-`(settlement·39 + power)` tension array, range `[0,100]`): it adds the delta
  `[bp+0xa]` to `tension[row·39+power]` and clamps to `[0,100]` (`@0x45E4A..0x45E6C`,
  clamp helper `func@0x48CC`). The **`power==1` (French) test halves the positive
  delta** (`@0x45E21`). (This is distinct from the older `DGROUP:0x54F6` alarm array
  with raid threshold `0x80`; the `0x5B1C` tension has thresholds **75** = hostile
  and **100** = war, both checked in the raid scan `func_047320`.)
- **Dutch (3) price stability** — **BYTE_VERIFIED 2026-06-20.** The damping is in
  the **per-sale market-accumulator** path, not the global drift: `func_03234A`
  (SELL updater) loops the per-player market-pool array `DGROUP:0x8864`
  (`[player·0x9e + good]`) and applies the trade delta in full to players 0–2 but
  **`(delta·2)/3` to player 3 (Dutch)** (`@0x32390..0x323A1`: `cmp [bp-8],3; jne;
  shl ax,1; mov cx,3; idiv cx`). So the Dutch pool absorbs ⅔ of each trade's impact
  ⇒ less price movement. (The BUY updater twin `func_0322D0` uses a per-player
  sensitivity shift instead; the explicit ⅔ is on the sell path.)
- **Dutch (3) starting trading vessel** — **BYTE_VERIFIED 2026-06-20.** In the
  new-game starting-unit setup, every power is placed a **Caravel** (type `0x0D`,
  `@0x07584B push 0xd → place_unit`); immediately after, **`if power==3 (Dutch):
  UnitRecord +0x3146 := 0x0E` (Merchantman)** (`@0x075875 cmp [bp-6],3; jne; mov
  byte[bx+0x3146],0xe`). So the Dutch start with a **Merchantman (trading vessel,
  more cargo)** instead of the Caravel the other three powers receive. (Aside: the
  second starting unit gets class `0x14` for power 1/French at `@0x0758B5`.)

## 4. UI
Chosen on the "Choose Your Nationality" setup screen with ability descriptions
(manual). Layout `TBD`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — @COUNTRY/@NATIONALITY/@NATIONABBREV/@HOMEPORT/@COLONYNAME/@INDEPENDENT/@LEADERNAME. **B**
- `VICEROY.EXE` `func_035D9A` (`0x035D9A`, crosses threshold) — English power-0 gate
  `@0x035E6E` (`cmp [0x9E12],0`; `×2/3`). **B**
- `VICEROY.EXE` `func_05CA7E` (`0x05CA7E`, land decider) — Spanish power-2 vs-native
  `+50%` `@0x05CF2F..0x05CF4D`. **B**
- `VICEROY.EXE` `func_045DF2` (`0x045DF2`, native tension-raise applier) — French
  power-1 halves the tension delta `@0x45E21` (array `DGROUP:0x5B1C`, `[0,100]`). **B**
- `VICEROY.EXE` `func_03234A` (`0x03234A`, SELL market-accumulator updater) — Dutch
  power-3 market-pool delta `×2/3` `@0x32390` (array `DGROUP:0x8864`). **B**
- `VICEROY.EXE` new-game unit setup (`@0x07584B`/`@0x075875`) — Dutch power-3
  starting ship upgraded Caravel `0x0D` → Merchantman `0x0E` (`UnitRecord +0x3146`). **B**
- `docs/GAME_MANUAL.md` — four national-power descriptions (English immigration,
  French native peace, Spanish +50% vs natives, Dutch stable prices + start ship). **R**
- `docs/DATA_MODEL.md` — `owner_power_idx` in records; native alarm array `0x54F6`. **B**

## 6. Open questions (TBD)
1. ~~**French (1):** native-alarm increment site scaling by `power==1`.~~ **Done
   2026-06-20** — `func_045DF2 @0x45E21` halves the native tension-raise delta for
   power 1 (tension array `DGROUP:0x5B1C`, range `[0,100]`). **B.**
2. ~~**Dutch (3):** price-drop damping + starting ship.~~ **Done 2026-06-20** —
   `func_03234A @0x32390` applies `×2/3` to the player-3 market-pool delta (array
   `DGROUP:0x8864`); **and the starting ship is upgraded Caravel→Merchantman for
   power 3** (`@0x075875`). Both **B**. (All four national powers now fully resolved.)
3. ~~Decode the `@LEADERNAME` and `@COUNTRY` trailing numbers (AI bias?).~~
   **Done 2026-06-20** — `@LEADERNAME` triplet → `DGROUP:0x9566` stride 3
   (`@0x547A1`), loaded as AI-personality bias axes; `@COUNTRY` number →
   `DGROUP:0x848` byte/nation (`@0x70813`), nation index for setup. Both **B**
   for location; the numbers are **not** gameplay multipliers.
4. Confirm the power-index ordering is fixed at 0..3 across all record types.
