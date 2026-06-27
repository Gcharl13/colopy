# Resource Management / Warehousing

> **Layer 2 — Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. No longer a breadth-pass stub: the storable-goods roster + ColonyRecord stockpile layout (§2), warehouse-capacity formula + over-100 surplus-disposal (§3/§6.4), and the warehouse-strip UI geometry (§4) are all BYTE_VERIFIED — capacity `func_008D00 @0x008D00`, stockpile bank/clamp `func_02D658 @0x02D96E`/`@0x02D972`, over-100→50 export `func_02D658 @0x02D6F7`/`@0x02D70B`, treasury credit `@0x02D785`, independence-waste gate `[0x5382]&1 @0x02D728`, food growth reserve `colony_turn_update @0x00A61F`, UI strip `func_0281D6 @0x0281DB`. The only remaining non-byte item is the **Food-200/199 + new-colonist numbers**, still `R` (manual; not located in any resident function — see §6).

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
  **offset `+0x9A`** (good `i` at `+0x9A + i·2`), BYTE_VERIFIED at the read/write
  sites in `func_02D658`: read `@0x2D6BB` (`MOV ax, [bx+0x9a]`); per-good indexed
  access `@0x2D6F1` (`si = i<<1`) → `@0x2D6F7` (`CMP [bx+si+0x9a], 0x64`) and the
  production bank `@0x2D96E` (`ADD [bx+si+0x9a], ax`), all inside the 16-good loop
  (`CMP [bp-0xb4], 0x10` `@0x2D8E8`). **B.**
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
- **The `(level+1)·100` cap is NOT a per-good goods clamp (CORRECTED 2026-06-27).** A full scan of
  the `+0x9A` write sites shows the stockpile is banked with **only a floor at 0, no ceiling**
  (`func_02D658 @0x2D96E` `add [bx+si+0x9a],ax`; clamp ≥0 `@0x2D972`). The over-100 disposal is the
  **auto-export-to-Europe** step (§6.4): the threshold is a **flat `0x64`=100 → reduce to `0x32`=50**
  (`cmp [+0x9a],0x64 @0x2D6F7`, `sub [+0x9a], stock−0x32 @0x2D70B`), **not** `(level+1)·100`; the
  `func_008D00` value bounds only the **food growth reserve** in `colony_turn_update` (`@0xA61F`).
  `0x181F:0xD3A` `@0x2D6AF` is the warehouse-level lookup feeding the export step. Goods over 100 are
  **sold** (treasury credit `PowerRecord+0x22`), or **wasted** if independence is declared
  (`[0x5382]&1`) — see §6.4. **B (corrected).**
- **Food exception:** up to **199** food may be kept; at **200+ food a new colonist
  is created** and 200 food removed (`docs/GAME_MANUAL.md`). **R** (numbers).

## 4. UI
**Warehouse view** — horizontal strip along the bottom of the colony screen
showing each storable good and its on-hand count; `[Tab]` selects the strip
(manual keyboard ref). 16 commodity slots (`spec/systems/colony.md`). **Layout BYTE_VERIFIED** in
`spec/ui/colony_screen.md` §3.9 via `func_0281D6 @0x0281DB`: backing rect
**(0,179,320,21)** (`PUSH 0x15`=21 h, `0x140`=320 w, `0xb3`=179 y, x=0 `@0x0281DB`),
**16 cells** (`CMP [bp-0x7e], 0x10` `@0x028231`) at **pitch 19** (`ADD [bp-0x6e], 0x13`
`@0x02822A`), icon Y **181** (`[bp-0x72]=0xb5` `@0x0281F1`), icon index = **good+0x17**
(`ADD ax, 0x17` `@0x028253`). **B.**

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@CARGO` (16 goods + tallies); `@BUILDING` (Warehouse, Warehouse Expansion). **B**
- `docs/DATA_MODEL.md` — ColonyRecord `+0x1C` const 0x40. **A**
- `docs/GAME_MANUAL.md` — capacities (100/+100), food cap 199, 200-food colonist. **R**

## 6. Resolved questions (items 1–4 closed; only the Food-200 manual number remains tier R — see §3)
1. ~~Confirm `+0x1C` (0x40) role.~~ **Done 2026-06-20** — `+0x1C` is a per-colony
   **status/warning flags byte** (bits `0x02/0x04/0x08/0x40/0x80`, `func_02D658`), not
   a capacity base; stockpile array is `+0x9A` (good `i` at `+0x9A+i·2`). **B.**
2. ~~Byte-confirm warehouse capacities and the +100-per-upgrade rule.~~ **Done
   2026-06-20** — `cap = (warehouse_level[+0x95]+1)·100` (`func_008D00`); §3. **B.**
3. ~~Decode the `@CARGO` CSV columns.~~ **Done 2026-06-20** — the 9 columns are the
   per-good **price-drift model** (Start1/2, Low, High, Burden, Rise, Fall, Attrition,
   Volatility), legend in NAMES.TXT lines 257–268; §2. (Not warehouse-volume.) **B.**
4. ~~Spoilage/overflow timing + wastage-vs-sale ordering.~~ **DONE 2026-06-21.** Per-good
   cap applied in `func_02D658` against stockpile `+0x9A`; the **end-of-turn order is fixed**
   in the per-colony finalize `colony_sol_tory_turn` (the per-turn loop over goods `i=0..0xF`):
   1. **Production is added first** — `stockpile[i] += term` where `term` is the net
      production (`g_global_amount[i] − band_base[i]`), clamped `≥ 0`;
   2. **then over-cap surplus is disposed** — when good `i` is over its warehouse cap and
      `stockpile[i] ≥ 100`, the colony keeps the lower band and the **excess is sold to
      Europe**: `net = excess − (excess·tax%)/100` credited to the treasury
      (`score_add_money`), **unless independence is declared** (`[0x5382]&1`) in which case
      `net = 0` — the excess is **wasted, not sold** (no Crown market in rebellion);
   3. **Food** is the special case: its surplus drives **colony growth** (`colony_growth_event`,
      the 200-food→new-colonist path) rather than a sale.
   So wastage and sale are the **same** end-of-turn surplus-disposal step (sell if trade is
   open, waste if at war for independence), strictly **after** production is banked. Source:
   `colony_sol_tory_turn` (byte-derived; `score_add_money`/tax gate `[0x5382]&1` cross-checked
   vs the EXE). **B.**
