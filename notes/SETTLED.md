# SETTLED — closed facts, do not re-litigate

**Purpose.** This is the short digest a new session reads *instead of* re-deriving from 97
`RULINGS.md` entries and 50k lines of docs. Every line here is byte-verified and **closed**.
If you think one is wrong, you almost certainly haven't read the cite — go read it before
re-opening. A genuine change **edits the canonical `spec/` doc and updates the cite here**; it
does **not** spawn a new ruling or a parallel decode doc.

> Authority order if anything conflicts: running game > sprite pixels > VICEROY.EXE @offset >
> NAMES/GAME.TXT > recorded ruling > C reconstruction (low) > guess. Full table:
> `notes/TRUTH_HIERARCHY.md`. History (append-only): `notes/rulings/RULINGS.md`.

## Terrain & map
- Terrain id = `raw & 0x1F`; classify via `func_006204 @0x6204`.
- Terrain **ordering** authority = `NAMES.TXT $TERRAIN`, never `mapedit.c` *(hard rule 1)*.
- Base ids: **Arctic 24 (0x18), Ocean 25 (0x19), Sea Lane 26 (0x1A)** *(@OTHER order; ruling 2026-06-20)*.
- Sea-lane = the **right-edge column**, id 26 *(hard rule 2)*.
- Auto-forest band = ids **8..23** (forested variants); `func_006204 @0x6204` *(hard rule 3)*.
- Runtime-board feature bits: **0x20 = hills/mtn, 0x40 = river, 0x80 = mountain** (`mapview.cpp`).
  ⚠ This is the in-memory board; the **.MP file** packs differently (bit5=river, bit6=forest) — the
  two are different representations (the .MP→board remap is the only open piece here).
- Rivers = PHYS0 rows **0x01 / 0x11** (blue), NOT `0x51..0x5E` (roads), NOT coast; true coast =
  sprites **150–153** + water-tile beach halo *(hard rule 4; ruling 2026-06-22)*.
- Tile draw chain: `func_O514 → func_O513 → func_O512` *(hard rule 7)*.
- Active map-view palette = **PHYS0's embedded PLTE** (`main.cpp:225`; differs from VICEROY.PAL).

## Sprites
- **TERRAIN.SS = base-ground sheet** (loaded boot + map-enter), composited UNDER **PHYS0 overlays**
  *(hard rule 5, amended 2026-06-22)*.
- **BDARK.SS = orphan**, never load *(hard rule 5)*.
- PHYS0 placeholder frames **0 / 16 / 100** = 1×1 extraction artifacts → skip. This skip set is
  **PHYS0-scoped** *(ruling 2026-06-24)*. **ICONS is contiguous 0–130, no gaps.**
- ICONS renderer indices: ships **5–7 / 14–15 / 127**; foot units **100–105 + 109** *(hard rule 6)*;
  #109 = colony unit marker (`mov ax,0x6D @0x0265BF`); commodities **22–37**, cursors 0–7, boycott 43.

## Colony
- ColonyRecord stride **0xCA (202)**; current colony = `*(0x8542)` *(hard rule 8)*.
- Building plots: **DS:0x266** table, **15** plots, render **y = table_y + 8** (`func_02701C @0x02708F`).
  **Which building fills a plot is RNG-driven** (`func_025D34`) — position is fact, placement is not.
- Stockpile bar: **16 cells, x = 1 + i·19, icon y = 181**; icon = good + 0x16 ⇒ ICONS frame 22 (Food)…37
  (Muskets) (`colony_screen.cpp §6`).
- SoL% = `100·A/B` (`sol_membership_pct @0x8557`); per turn A,B are 1/64-decay EMAs, `B += 2·pop`,
  `A += bells` (`func_02D658 @0x2DA1C`); steady state ≈ **50·bells/pop**.
- Growth store = **200** (`@0x2E098`); max pop = **32** (`population<0x20 @0x009432`).
- Per-tile production (`compute_terrain_yield @0x9B9C`): terrain yield − `floor(toryCnt/(10−diff))`
  + expert (+2 Food/Horses, ×2 mfg) + manufacturing building gate (`@0x9F4F`) + factory ×2
  (`count_building_chain_present>2 @0x8EA9`).

## Market
- Price drift: `base -= (base + Σ_players max(trade_accum,0)) / 256` (`func_0305A8 @0x30618`);
  per-good price seed = `random(600,1000)` (`func_07561C @0x75645`).
- Luxury shared pool: `target[i] = (3 · Σsupply[Rum,Cigars,Cloth,Coats]) / supply[i]` (`@0x030745`).
- SELL (`func@0x32914`): gross = price·qty → King tax = gross·tax%/100 (→ REF `+0x22`) → net → gold
  `+= net`, clamp `[0, 999999]`. BUY (page-13): inline gold debit, **untaxed**.
- Boycott bitmask = `PowerRecord +0x20`; lift back-tax = price × 500 (`func_03334E @0x333AF`);
  Jakob Fugger clears all (`@0x3BD45`).
- Goods order (0..15): Food, Sugar, Tobacco, Cotton, Furs, Lumber, Ore, Silver, Horses, Rum,
  Cigars, Cloth, Coats, Trade Goods, Tools, Muskets.

## Map generator
- `func_064A10` passes P0–P6; random-map dims **58×72** (`@0x75702`); climate bands
  **{5,4,1,3,2,2} N / {2,3,3,4,6,7} S** (`@0x64CFC / @0x6504E`); landmass target `(p1+p2+1)·0x140`
  (`@0x64AAD`); borders: right two cols → Sea Lane 26, top/bottom → Arctic 24.
- Customize params = 5-word array `DGROUP:0x1E7E`, written mod-3 by `func_070060 @0x701AD`; menu
  strings `@CLAND` (LAND MASS) / `@CCONT` (LAND FORM) / `@CTEMP` (TEMPERATURE) / `@CCLIM` (CLIMATE).

## Known-open (the honest TBD frontier — not settled)
- **F2–F9 report field positions** render in overlay `0x191F` (raw asm in
  `code/VICEROY/disasm/orphans_overlay.asm`); decompile pending (`docs/GHIDRA_PHASE2_RUNBOOK.md`).
- Colony worked-tiles grid / panel text placement; raw→finished conversion ratios; starvation rule;
  WoI bells halving cadence; the `.MP`-file → runtime-board feature-bit remap.
