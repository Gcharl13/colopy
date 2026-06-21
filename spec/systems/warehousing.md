# Resource Management / Warehousing

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** cargo roster + **`@CARGO` column legend + warehouse capacity
formula `(level+1)·100` (`func_008D00`) + per-good overflow application** `BYTE_VERIFIED`
(2026-06-20); only the exact wastage-vs-sale ordering + Food-200 numbers `R`.
**Canonical primary:** `data_extracted/text/NAMES_sections.json` (@CARGO),
`docs/DATA_MODEL.md` (ColonyRecord `+0x1C`), `docs/GAME_MANUAL.md` (Warehouse view).

## 1. Purpose & behavior
Each colony stores commodities/goods in a warehouse; storage capacity grows by
building a Warehouse and Warehouse Expansions. End of turn, excess production is
stored; quantities above capacity are lost (`docs/GAME_MANUAL.md`).

## 2. State & data
**Storable goods — `@CARGO` (`NAMES_sections.json`, BYTE_VERIFIED data).** 16
tradeable commodities each with a **9-column CSV (column legend in NAMES.TXT itself,
lines 257–268)** — the per-good **market price-drift model**, *not* warehouse-volume
data: `Start1, Start2` (starting price low/high), `Low, High` (drift bounds), `Burden`
(extra ask−bid spread; 0 ⇒ ask = bid+1), `Rise`/`Fall` (traffic indicators where the
price rises/falls), `Attrition` (added to traffic volume each turn = price recovery),
`Volatility` (traffic-volume shift). **B** (legend is primary; cross-ref `market.md`).
Goods:
Food, Sugar, Tobacco, Cotton, Furs, Lumber, Ore, Silver, Horses, Rum, Cigars,
Cloth, Coats, Trade Goods, Tools, Muskets. Plus non-trade tallies listed after:
Hammers, Crosses, Liberty Bells, Flags (no CSV — accumulators, not warehouse stock). **B** (roster).

- **ColonyRecord `+0x1C`** — **per-colony status/warning FLAGS byte** (BYTE_VERIFIED
  2026-06-20): `func_02D658` tests/sets/clears bits `0x02`/`0x04`/`0x08`/`0x40`/`0x80`
  each turn (`@0x2DB34`/`@0x2DB67`/`@0x2DBAC`/`@0x2DD2E`/`@0x2E57A`/`@0x2EDF4`) — colony
  shortage/surplus/build-status warnings. The old "constant `0x40`" reading was just
  bit `0x40` being set; it is **not** a warehouse capacity base. (The 100-unit cap is
  `(+0x95+1)·100` via `func_008D00`, §3.)
- Per-commodity on-hand stock array in ColonyRecord (the 16-slot stockpile):
  offset **TBD** — confirm at read site (`spec/systems/colony.md`).
- Warehouse / Warehouse Expansion buildings exist in `@BUILDING` (`NAMES`): rows
  "Warehouse" and "Warehouse Expansion". **B** (building entries).

## 3. Formulas & rules
**Warehouse capacity — BYTE_VERIFIED 2026-06-20** (`func_008D00`, file `0x8D00`):
```
cap = ([ColonyRecord +0x95] == 0) ? 100 : ([ColonyRecord +0x95] + 1) · 100
```
i.e. **`(warehouse_level + 1) · 100`** per good, where `+0x95` is the warehouse
building level (`0` = none → **100**, `1` = Warehouse → **200**, `2` = Warehouse
Expansion → **300**). Confirms the manual's "base 100 / +100 per upgrade". **B.**
- **Applied per-good in the colony processor `func_02D658`** (cap fetched
  `@0x2D6AF`/`@0x2E6AF`, thunk `0x181F:0xD3A`) against the **16-slot stockpile array
  `ColonyRecord +0x9A`** (good `i` at `+0x9A + i·2`): stock above `cap` is the
  **overflow** (`stock − cap` computed `@0x2E6FB`) and is removed end-of-turn
  ("spoilage"). **B** (cap + per-good application); the exact wastage-vs-sale ordering
  inside the production loop is the narrow residual.
- **Food exception:** up to **199** food may be kept; at **200+ food a new colonist
  is created** and 200 food removed (`docs/GAME_MANUAL.md`). **R** (numbers).

## 4. UI
**Warehouse view** — horizontal strip along the bottom of the colony screen
showing each storable good and its on-hand count; `[Tab]` selects the strip
(manual keyboard ref). 16 commodity slots (`spec/systems/colony.md`). Layout details `TBD`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@CARGO` (16 goods + tallies); `@BUILDING` (Warehouse, Warehouse Expansion). **B**
- `docs/DATA_MODEL.md` — ColonyRecord `+0x1C` const 0x40. **A**
- `docs/GAME_MANUAL.md` — capacities (100/+100), food cap 199, 200-food colonist. **R**

## 6. Open questions (TBD)
1. ~~Confirm `+0x1C` (0x40) role.~~ **Done 2026-06-20** — `+0x1C` is a per-colony
   **status/warning flags byte** (bits `0x02/0x04/0x08/0x40/0x80`, `func_02D658`), not
   a capacity base; stockpile array is `+0x9A` (good `i` at `+0x9A+i·2`). **B.**
2. ~~Byte-confirm warehouse capacities and the +100-per-upgrade rule.~~ **Done
   2026-06-20** — `cap = (warehouse_level[+0x95]+1)·100` (`func_008D00`); §3. **B.**
3. ~~Decode the `@CARGO` CSV columns.~~ **Done 2026-06-20** — the 9 columns are the
   per-good **price-drift model** (Start1/2, Low, High, Burden, Rise, Fall, Attrition,
   Volatility), legend in NAMES.TXT lines 257–268; §2. (Not warehouse-volume.) **B.**
4. ~~Spoilage/overflow timing.~~ **Mostly done 2026-06-20** — per-good cap applied in
   `func_02D658` against stockpile `+0x9A`; overflow `stock−cap` removed end-of-turn
   (§3). Narrow residual: exact wastage-vs-sale ordering inside the production loop;
   only **Food** has special handling (200→colonist). **B** (mechanism).
