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
- **`tools/ssdec.py` frame index is OFF BY ONE vs the EXE: `ssdec_frame[K] = game_frame[K+1]`.**
  The disasm/spec cite **game** frame numbers (e.g. stockpile icon `add ax,0x17`; building `def_id+1`);
  the **renderer (ssdec) must subtract 1** (stockpile icon = `0x16+good`, Food=ssdec 22; building =
  `def_id`, def0→16; empty-plot terrain = `table[cat]−1`). **EMPIRICALLY MSE-0 verified** for all 16
  commodity icons + all colony buildings/terrain against the matched live capture (2026-06-27). This
  off-by-one was the root of the recurring "stockpile starts with Sugar not Food" / building-frame
  churn — the spec's game-frame cites were right; the ssdec mapping just needs −1. *(ruling 2026-06-27)*
- **VICEROY.PAL = 256 × stride-3 RGB** (first 768 bytes; 6-bit→8-bit via `(v<<2)|(v>>4)`), **NOT
  stride-4 RGBA** *(ruling 2026-06-27; proof: idx54 sky = stride-3 (105,138,195) ≈ real #6888c0 vs
  stride-4 yellow (186,186,64); fixed `tools/extract_pal.py`, regenerated `data_extracted/palette.json`)*.
- **Per-asset palette precedence:** a `.SS`/`.PIK` with an embedded palette section uses **its own**
  palette; only fall back to VICEROY.PAL when none is embedded. SS transparent index = **0xFD (253)**
  *(`tools/ssdec.py`)*. The `lab/assets/*.png` extracts are **mis-baked** (wrong palette + frame
  numbering) — decode raw `.SS`/`.PIK` via `tools/ssdec.py` instead *(ruling 2026-06-27)*.

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

## AI (Layer 4) — `spec/systems/ai.md` (decoded 2026-06-26/27)
- **Two engines:** strategic planner `func_04CC50` (per-**power**, `[bp+6]`=power 0..3) fills/reads
  the plan map and assigns missions; per-unit order processor `func_04E2D6` (per-**unit**) executes.
  Tactical heading evaluator `func_046FFA` scores 8 dirs+stay (base 200; +500 colony-site, ±4 heading
  continuity, +50 frontier, +40/20 colony, +16 yield, RNG jitter, clamp≥0, pick-max → `0x314F`).
- **Plan map** = `DS:0x98B0`, 4-byte records `((power<<6)+slot)<<2`, **POWER-indexed, 64 slots/power**
  (proven: all access in `func_04CC50`; BSS table `0x98B0..0x9CB0`, next global at `0x9CB0`). Fields:
  `+0` target X, `+1` target Y, `+2` goal_type (0xFF empty), `+3` priority. Setter `func_04C3A2`.
- **`0x314B` AI state alphabet** (~30 letters): planning `1/t/i/?` (`func_04CC50`); execution
  `@`,`V`,`L`,`=`,`C`,`U`,`R`,`9`,`G`,`B`,`e`,`F`,`0` + mission chars `2 3 4 5 8 D J N P W` via
  `func_04E2B6`. Missions = explore (`2/8/D`) / return-to-colony (`3/5/N/P/V/W`) / visit-natives (`4/J`).
- **`0x3149` = move-credits spent** (reset turn-start `@0x5872`; step −3; allowance = UnitTypeStats).
- **UnitTypeStats** = `DS:0x5234`, 14-byte record/type = loaded **`@UNIT` CSV** with **moves×3**;
  `+0` allowance, `+1` def, `+2` atk, `+3` work-cost, `+9` capability bits (= `@UNIT` binary column).
- **Scoring helpers** (resident, via `tools/follow_thunk.py`): `0x302`→`func_005BFA` in-bounds
  (⇒ map dims `[0x853a]`W/`[0x853c]`H), `0x37a`→`func_00493C` distance, `0x4d4`→`func_00C322` RNG,
  `0x90c`→`func_006CCA` allowance, `0x78c`→`func_00627A` terrain-id, `0x7be`→`func_008D26`
  colony-at-tile. They bottom out at the shared map-access seg `0x37f` + colony layer (`0x5d46`/`0xCA`).
- **Per-turn flow:** `func_005760` main loop → per-power 0..3, controller gate `[idx·0x34+0x543f]`
  (0 = run; skips human) → orders `func_024A48` → `func_04CC50` plan → `func_051D56` → `func_04E2D6`.

## Colony economy (L3, `spec/systems/colony.md` / `warehousing.md`, 2026-06-27)
- **Manufacturing = 1:1** (`func_008E84`): 1 finished per 1 raw, **×2/3 throttle** when the finished
  good's building-chain count > 2 (`func_00864E > 2`); Tools(14) −`[0x8E66]` (horses offset).
  Chains: Ore→Tools, Tobacco→Cigars, Cotton→Cloth, Furs→Coats, Sugar→Rum.
- **Food/growth:** consumption = 2·pop; surplus = max(0, producedFood−2·pop); half (`ceil/2`) accrues
  to colony `+0xAA`; born at threshold 25 (50 on difficulty) via `func_009318` (`INC +0x1F`); starve
  via `func_008FB4` (`DEC +0x1F`). The deficit→remove trigger + per-turn `+0xAA` write are TBD.
- **No warehouse spoilage clamp:** `+0x9A` stockpile banks with a floor at 0, **no ceiling**. Over-100
  tradeable goods are **auto-exported to Europe** (`func_02D658`: flat 100→50, excess sold → treasury
  `PowerRecord+0x22`; **wasted** if independence declared `[0x5382]&1`). `(level+1)·100`
  (`func_008D00`) bounds **only the food growth reserve**, not goods. *(Corrected the prior
  "goods dropped at (level+1)·100 cap" reading.)*

## Endgame / combat (L3, 2026-06-27)
- **REF** (`ref_growth.md`): init `func_0755CC` difficulty-scaled (Regulars `8d+15`, Cavalry `5d+5`,
  Man-O-War `3d+2`, Artillery `6d+2`; 4-type array `DGROUP:0x53DA` stride 2). Growth `func_03E162`:
  `royal_money(PowerRecord+0x22) += (8d+10)·2^era` (eras at 1600/1700/1750); buy 1 unit at `≥1800`.
- **Naval combat** (`combat.md`): `func_05B2C2` roll = `random_int(1, A+D)`, A/D = UnitTypeStats
  `+0x0B/+0x0C` (`0x523B/0x523C`); attacker wins when `roll ≤ D`; loser → capture/cargo/sink.
  `func_05CA7E` = pre-combat UI setup, not the roll. Land roll = `random_int(3,6)+terrain`.
- **Tory uprising** (`tory_uprising.md`): `func_03CAC6` — **no SoL threshold**; per-call gate
  `random_int(0,diff+1)`; targets the rebel colony with max `tory_strength = pop·(100−SoL)·2/100 +
  diff + 1`; spawns Tory-Militia (count = strength countdown). SoL enters only via magnitude.

## Known-open (the honest TBD frontier — not settled)
- **AI runtime/leaf items:** the compass dx/dy delta tables (`[bx+0xb4/0xbe]`, BSS), the full
  `goal_type` code enumeration (1/4/7 known), the order-7..12 secondary jump table
  (`func_051D56 @0x51E15`, CS-relative), and the exact weighting inside `func_0083F2` (reachability).
- **L3 inherent/runtime residuals** (not undecoded mechanics — the honest frontier): colony
  food-deficit starvation *trigger* site + `+0xAA`/`+0xC8` growth-accumulator reconcile; immigration
  `+0x1F` per-colony-cross-vs-population reconcile; WoI bells halving cadence; Tory caller cadence +
  militia type id `[0x53D2]`; naval damage-vs-sink threshold + bombardment roll; mercenary
  intervention exact effect (`func_03E2EA`); boycott goods glyph colour (no palette arg — UI-inherent);
  the `.MP`-file → runtime-board feature-bit remap.
- *(The F2–F9 report painters + OPENING/CLOSING cinematics are now decoded — see
  `docs/ADVISOR_REPORTS_AUDIT.md` and `spec/ui/cinematics.md`; no longer open.)*

- **Colony-site VALUE ("Show Colony Sites" cheat F9) — CLOSED B 2026-06-28.** F09 (cmd id `0x6C`,
  dispatch jump-table `0x023DE8` → `func_021602`) displays the **low nibble of map-layer #4**
  (`[0x168]/[0x16a]`, read via `func_005EE8`/`181F:0x74a`, masked `& 0x0F` ⇒ range **0–15**, not 0–24).
  The nibble is filled at map-gen by **`func_063F3C`** (body `0x063F3C`, store `mov es:[bx],al`
  `@0x064130`, addr via `func_005ED0`/`181F:0x736`): per land tile, sum over the ~21-tile catchment
  (deltas `[bx+0xc8]`/`[bx+0xde]`, ring-weighted ×5→2) of {special-resource bonus `[id-0x684e]` |
  ocean coastal-adjacency `(2+2·land)>>2` | base terrain **Improvement** stat `[terrain·16+0x2F79]`}
  +1 feature-bit; near-colony halves; Mountains→0, Hills→½; then **`clamp(score/10, 0, 15)`**
  (`func_0048CC`/`181F:0x35c`). Water/oob ⇒ 0. Was the last open spec formula. (Corrects the
  2026-06-27 "draw-time, no cached array, not statically locatable" finding — it IS a cached nibble.)

- **Static-residual closeout — 2026-06-28 (decode→adversarial-verify, 10 closed B / 1 runtime-terminal / 1 rejected).**
  - **market** drift driver = `func_036574` (end-of-turn via `func_0755CC @0x0757B0`); `+0xFC` BUY `func_03234A @0x323BC` / SELL `func_0322D0 @0x32324` (corrects `func_33C96` mislabel + RULING).
  - **ai** `func_0083F2` = nearest-colony scan; weighting = octile distance `max(|dx|,|dy|)+(min>>1)` in `func_004900`.
  - **colony** SoL new_bells pressure = `new_bells/(−20)` (`@0x2DA12`); `+0xAA` food accumulator has **no static per-turn write** (write-census: only `+100`@0x05A3CA / `=2`@0x05627D) → runtime-terminal **A**.
  - **combat** `+0x17==0x18` demotion = type-0 + profession `[unit+0x315B]==0x18` → unit type 3 (offset is record-rel **+0x15**, not +0x17).
  - **scoring** all 7 component weights B (`func_039EE2`): pop +1/+2/+4, FF +5, sentiment ×1, razed ×−(1+diff), gold min(/100,100), bells /1000, revolution (1780−turn)·2; × ((8>>n)+8)/8 diff mult.
  - **founding_fathers** Smith(0)/Stuyvesant(3)/Drake(13)/Penn(21) gated by `func_00BC10` via direct `lcall 0x981:0` (not thunk 0x181F:0x7B4) → all 25 fathers **B**.
  - **map_generation** landmass = iterative random blob-stamping (`func_064A10`/`func_0643F8`) to target `(p1+p2+1)·0x140`.
  - **immigration** per-slot type = 3-tier difficulty-weighted RNG ladder `func_034C24` (Brewster→Elite 0x1C).
  - **events** burial `@BURIAL3` treasure `2·(1d8+2·(scout+5))` ×100.
  - **difficulty** Indian-destruction penalty = `razed_count × −(1+difficulty)` (`@0x3A4C3`); native `+0x46` = per-power alarm seed (resolved, not a difficulty field).
  - **REJECTED**: a re-derivation of `func_05B2C2`'s naval win-condition (inverted compare) — the 2026-06-27 resolved naval/bombardment version stands.
