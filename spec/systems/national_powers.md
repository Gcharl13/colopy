# National Powers / Abilities

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** nation roster + leaders `BYTE_VERIFIED`; ability *function*
`RECONSTRUCTED` (manual); byte effects `TBD`.
**Canonical primary:** `data_extracted/text/NAMES_sections.json`
(@COUNTRY/@NATIONALITY/@NATIONABBREV/@HOMEPORT/@LEADERNAME/@COLONYNAME/@INDEPENDENT),
`docs/GAME_MANUAL.md` (Choose Your Nationality).

## 1. Purpose & behavior
Each of the four European powers has one special power that shapes strategy
(`docs/GAME_MANUAL.md`). RECONSTRUCTED ability functions (manual; numbers `TBD`):
- **English** — produce a greater number of immigrants than other nations.
- **French** — live among natives more peacefully (better native relations).
- **Spanish** — **+50% attack bonus** vs Indian villages/towns.
- **Dutch** — more stable Amsterdam prices (less price drift); **start with a
  trading vessel** (de Ruyter starts with a Caravel/merchantman per manual).

The "+50%" and "trading vessel" are manual numbers — EXE bytes win on conflict
(`/METHODOLOGY.md`); treat as `RECONSTRUCTED` until byte-traced.

## 2. State & data
All four-row tables below are **BYTE_VERIFIED** (data present in `NAMES_sections.json`),
indexed by power 0..3 = English/French/Spanish/Dutch:

| Idx | @NATIONALITY | @COUNTRY (+num) | @HOMEPORT | @COLONYNAME | @INDEPENDENT | @LEADERNAME (+3 nums) |
|-----|--------------|-----------------|-----------|-------------|--------------|------------------------|
| 0 | English | England, 12 | London | New England | United States of America | Walter Raleigh, 1, -1, 0 |
| 1 | French | France, 9 | La Rochelle | New France | Republic of Quebec | Jacques Cartier, 0, 1, 0 |
| 2 | Spanish | Spain, 14 | Seville | New Spain | Republic of Mexico | Christopher Columbus, 1, 0, -1 |
| 3 | Dutch | Netherlands, 13 | Amsterdam | New Netherlands | Republic of Surinam | Michiel De Ruyter, -1, 0, 1 |

- `@NATIONABBREV`: Eng. / Fr. / Span. / Dutch. **B**
- The `@COUNTRY` trailing number and the three `@LEADERNAME` numbers are **TBD**
  (likely AI-personality / starting-bias triplets — not decoded). Do not assume.
- Owning-power index stored in records as `owner_power_idx` (e.g. ColonyRecord
  `+0x1A`, BYTE_VERIFIED — `docs/DATA_MODEL.md`, `spec/systems/colony.md`).

## 3. Formulas & rules
Byte effects of each national power are **TBD**:
- English immigration multiplier: **TBD** (cross-ref immigration/crosses system).
- French native-attitude modifier: **TBD**.
- Spanish +50% vs native settlements: **R** (manual) — byte-confirm pending.
- Dutch price-drift damping + starting ship: **R** (manual) — byte-confirm pending.

## 4. UI
Chosen on the "Choose Your Nationality" setup screen with ability descriptions
(manual). Layout `TBD`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — @COUNTRY/@NATIONALITY/@NATIONABBREV/@HOMEPORT/@COLONYNAME/@INDEPENDENT/@LEADERNAME. **B**
- `docs/GAME_MANUAL.md` — four national-power descriptions. **R**
- `docs/DATA_MODEL.md` — `owner_power_idx` in records. **B**

## 6. Open questions (TBD)
1. Byte-trace each national-power effect (English immigration, French attitude, Spanish attack bonus, Dutch price stability + starting ship).
2. Decode the `@LEADERNAME` and `@COUNTRY` trailing numbers (AI bias?).
3. Confirm the power-index ordering is fixed at 0..3 across all record types.
