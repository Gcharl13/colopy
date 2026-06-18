# Resource Management / Warehousing

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** cargo roster `BYTE_VERIFIED`; capacity values
`RECONSTRUCTED` (manual); spoilage/overflow rules `TBD`.
**Canonical primary:** `data_extracted/text/NAMES_sections.json` (@CARGO),
`docs/DATA_MODEL.md` (ColonyRecord `+0x1C`), `docs/GAME_MANUAL.md` (Warehouse view).

## 1. Purpose & behavior
Each colony stores commodities/goods in a warehouse; storage capacity grows by
building a Warehouse and Warehouse Expansions. End of turn, excess production is
stored; quantities above capacity are lost (`docs/GAME_MANUAL.md`).

## 2. State & data
**Storable goods — `@CARGO` (`NAMES_sections.json`, BYTE_VERIFIED data).** 16
tradeable commodities each with a CSV of numeric columns (column semantics `TBD`):
Food, Sugar, Tobacco, Cotton, Furs, Lumber, Ore, Silver, Horses, Rum, Cigars,
Cloth, Coats, Trade Goods, Tools, Muskets. Plus non-trade tallies listed after:
Hammers, Crosses, Liberty Bells, Flags (no CSV — accumulators, not warehouse stock). **B** (roster).

- **ColonyRecord `+0x1C`** — constant `0x40` (64) across colonies, "likely
  warehouse base/config" (`docs/DATA_MODEL.md`, **ANCHOR_VERIFIED**). Its exact
  role (capacity base?) is unconfirmed — do not treat as the 100-unit cap.
- Per-commodity on-hand stock array in ColonyRecord (the 16-slot stockpile):
  offset **TBD** — confirm at read site (`spec/systems/colony.md`).
- Warehouse / Warehouse Expansion buildings exist in `@BUILDING` (`NAMES`): rows
  "Warehouse" and "Warehouse Expansion". **B** (building entries).

## 3. Formulas & rules
Capacities from the manual (**RECONSTRUCTED** — EXE bytes win on conflict):
- No warehouse: **100** of each commodity.
- Each Warehouse / Warehouse Expansion upgrade: **+100** capacity for all goods.
  (Manual: base 100 → Warehouse 200 → Expansion 300.)
- **Food exception:** up to **199** food may be kept; at **200+ food a new colonist
  is created** and 200 food is removed (`docs/GAME_MANUAL.md`). **R** (numbers).
- **Overflow/spoilage:** quantities above capacity are lost at end of turn
  (manual mentions "spoilage"); exact wastage rule and whether it applies before
  or after sale: **TBD**.

## 4. UI
**Warehouse view** — horizontal strip along the bottom of the colony screen
showing each storable good and its on-hand count; `[Tab]` selects the strip
(manual keyboard ref). 16 commodity slots (`spec/systems/colony.md`). Layout details `TBD`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@CARGO` (16 goods + tallies); `@BUILDING` (Warehouse, Warehouse Expansion). **B**
- `docs/DATA_MODEL.md` — ColonyRecord `+0x1C` const 0x40. **A**
- `docs/GAME_MANUAL.md` — capacities (100/+100), food cap 199, 200-food colonist. **R**

## 6. Open questions (TBD)
1. Confirm `+0x1C` (0x40) role and locate the actual per-commodity stockpile array offset.
2. Byte-confirm warehouse capacities and the +100-per-upgrade rule.
3. Decode the `@CARGO` CSV columns (price/volume/related-good indices).
4. Spoilage/overflow timing and whether any good besides food has special handling.
