# Colony & Production

> **Layer 2 — Specification.** PRIMARY data only (`/METHODOLOGY.md`). Tiers:
> `BYTE_VERIFIED` / `ANCHOR_VERIFIED` / `RECONSTRUCTED`.

**Overall confidence:** record stride + fields + **per-tile production formula**
+ **Sons-of-Liberty %** + **hammers/build-progress field** `BYTE_VERIFIED`;
building-completion check **BYTE_VERIFIED** (`func_02D658`→`func_02D0E4`→`func_0092E0`, 2026-06-20);
warehouse "spoilage" **CORRECTED 2026-06-27** (no per-good spoilage clamp — over-cap tradeables are
auto-exported to Europe, §3). **Last updated:** 2026-06-27.
**Primary evidence:** `docs/DATA_MODEL.md` (ColonyRecord, runtime-verified),
`viceroy_source/src/colony/{turn_update,production_support,sol_tory}.c`
(full byte-traced bodies), `data_extracted/text/NAMES_sections.json`.

## 1. Purpose & behavior
A colony houses colonists working tiles or buildings to produce food and goods,
constructs buildings, and accumulates liberty bells (Sons of Liberty %). Output
is a function of the worked tile's terrain, the colonist's profession/expertise,
and the relevant building's bonus.

## 2. State & data layout

ColonyRecord **stride `0xCA` = 202 bytes** (BYTE_VERIFIED, `docs/DATA_MODEL.md`;
30+ `[reg+0xCA]` stride refs + direct memory inspection). `docs/DATA_MODEL.md` is
the canonical full field map; the offsets confirmed there include:

| Field | Meaning | Tier | Evidence |
|-------|---------|------|----------|
| `+0x1A` | `owner_power_idx` (0..3) | **BYTE_VERIFIED** | colony-burn trace |
| `+0x1B` | foreign-colony status (0 = player-owned) | **BYTE_VERIFIED** | cross-colony inspection |
| `+0x1C` | per-colony **status/warning flags** byte (bits `0x02`/`0x04`/`0x08`/`0x40`/`0x80` test/set/cleared each turn — shortage/surplus/build warnings) | **BYTE_VERIFIED** | `func_02D658` `@0x2DB34`/`@0x2DB67`/`@0x2E57A`/`@0x2EDF4` (the earlier "constant 0x40" was just bit `0x40` being set) |
| `+0xC8` | **high word of the 32-bit SoL `rebel_divisor`** (`+0xC6` lo / `+0xC8` hi) — **CORRECTED 2026-06-27**, this is NOT a food-growth accumulator (the food store is `+0xAA`, §3) | **BYTE_VERIFIED** | per-turn 32-bit EMA `func_02D658 @0x2DA1C..0x2DA6F` (`mov dx,[bx+0xc8]` … `sar dx;rcr ax` ×6 … `sub [bx+0xc6],ax; sbb [bx+0xc8],dx` … `add [bx+0xc6],ax; adc [bx+0xc8],dx`); birth `func_009318 @0x9453/@0x9458` (`add [bx+0xc6],0x64; adc [bx+0xc8],0`); death `func_008FB4 @0x9031/@0x9036` (`sub [bx+0xc6],0x64; sbb [bx+0xc8],0`). (The prior `@0x2E098 "+200"` was a misread — it adds `0xC8`=200 to the message-quantity local `[bp-0x60]`, not to `ColonyRecord+0xC8`.) |
| `+0x1F` | size / population factor (used in colony-burn loot) | **BYTE_VERIFIED** | trace @ file `0x05DE1E` |
| `+0x40..` | `colonist_job_skills[]` (1 byte/colonist; profession id) | **BYTE_VERIFIED** | read in `compute_terrain_yield` (profession-match) |
| `+0x84` | **persistent** `buildings_constructed[]` bit-array (48 bits; set on build-completion) | **BYTE_VERIFIED** | setter `func_0092E0` `*(0x8542)+0x84+n/8`, `or 1<<(n&7)` `@0x9308`; guard `func@0x860E` (`0x5D46+0x84`) |
| `+0x8A` | `buildings_present[]` bit-array — the **DISPLAY copy** of `+0x84` (colony-screen grid + founding) | **BYTE_VERIFIED** | accessors `func_0085D6` (set/clear) / `func_0085B2` (test) compute `*(0x8542)+0x8A + n/8`, mask `1<<(n&7)`; byte-for-byte twin of `func_0092E0` (`+0x8A` vs `+0x84`) |
| `+0x92` | per-turn `hammers` accumulator (`+= hammers_produced` each turn; feeds the early cost gate) u16 | **BYTE_VERIFIED** | `func_02D658 @0x2E50F`/`@0x2E53B` |
| `+0x94` | `build_target` (building id; `<0` = none) | **BYTE_VERIFIED** | `func_02D658 @0x2E529`/guard `@0x2E544` (supersedes the dump `+0x10` label) |
| `+0xB6` | **build-progress bank** (hammers toward the current building; shown to the player as "X of Y", cost-debited on completion with **surplus carried**) u16 | **BYTE_VERIFIED** | `func_02D658`: shortfall msg `@0x2E5DD`/`@0x2E648` (template `@0xEA1`), debit `@0x2E6A1`/`@0x2E6A7` |
| `+0x95` | `warehouse_level` (0/1/2 = none / Warehouse / +Expansion) | **BYTE_VERIFIED** | read by `func_008D00` capacity = `(+0x95+1)·100` |
| `+0x9A` | per-good colony amount u16[**20**] (goods 0..0x13: 16 `@CARGO` tradables + Hammers/Crosses/Bells/Flags); array spans `+0x9A..+0xC0` | **BYTE_VERIFIED** | `docs/DATA_MODEL.md` (runtime); good order via `sol_tory` `colony_query(0x12)`=Bells |
| `+0xB8` | `muskets` (good `0xF` slot) | **BYTE_VERIFIED** | `auto_manage.c @0x548E9` arms defender: `col[+0xB8]≥200`, `−=50` |
| `+0xBA` | ⚠ dump-labeled `hammers` (good `0x10` slot, `+0x9A+0x20`) — **but the build code uses `+0x92`/`+0xB6`, not `+0xBA`** | **CONFLICT** | the per-turn completion never reads `+0xBA` (RULINGS 2026-06-20); `+0xBA`'s real role pending re-examination |
| `+0xC2` | `rebel_dividend` s32 (SoL fraction numerator) | **BYTE_VERIFIED** | read @ `0x8531` (`sol_membership_pct`) |
| `+0xC6` | `rebel_divisor` s32 (SoL fraction denominator) | **BYTE_VERIFIED** | read @ `0x8539` |

> `docs/DATA_MODEL.md` remains the canonical full field map; the offsets above are
> the ones confirmed at a cited read site this pass.

### PowerRecord field tail (per-nation economy/diplomacy) — **BYTE_VERIFIED**

The per-nation **PowerRecord** is a **316-byte (`0x13C`) stride** array based at
`DGROUP:0x8808` (12 entries: 0..3 European powers, 4..11 native tribes). The
**active power** is reached via the near pointer `[DGROUP:0x84fc]`, which the
selector `func_030550` (`@0x30559`) sets to `0x8808 + power_idx·0x13C` (and writes
the index to `[0x9e12]`). Accesses are `bx = [0x84fc]; …[bx + 0xNN]`. Already-named
fields (`+0x01` tax, `+0x02` rebel%, `+0x07` FF mask, `+0x0C/0x0E` bells, `+0x14` FF
count, `+0x20` boycott, `+0x2A` gold u32, `+0x4C+i` price_level[16], `+0x5C+i·2`
vol_accum[16]) are documented in `docs/DATA_MODEL.md` §PowerRecord and
`national_powers.md`. The previously-unnamed tail offsets resolved this pass:

| Offset | Type | Field | Tier | Evidence |
|-------|------|-------|------|----------|
| `+0x20` | u16 | `boycott_bitfield` — bit `i` = good `i` boycotted by the King | **BYTE_VERIFIED** | test accessor `func_030B38 @0x30B47` (`ax = (1<<good) & [bx+0x20]`); cleared on lift `func_03334E @0x33423` (`[bx+0x20] &= ~(1<<good)`) |
| `+0x22` | s32 (`+0x22` lo / `+0x24` hi) | `royal_money` — King's REF-budget / tax-revenue accumulator; **grows** from the per-turn sales-tax skim and from boycott-lift tribute | **BYTE_VERIFIED** | per-turn `func_02D658 @0x2D785/@0x2D788` (`add [bx+0x22],ax; adc [bx+0x24],dx` — `ax`= net sale proceeds after the `[+0x01]` tax mul `@0x2D73B`); boycott-lift `func_03334E @0x33413` (`[+0x22] += cost`) |
| `+0x26` | s32 (`+0x26` lo / `+0x28` hi) | second per-turn sales accumulator (gross/pre-tax amount paired with `+0x22`) | **BYTE_VERIFIED** | `func_02D658 @0x2D78B/@0x2D78E` (`add [bx+0x26],si; adc [bx+0x28],di`, in the same per-power sales loop gated by `[idx·0x34+0x543f]`) |
| `+0x2A` | u32 (`+0x2A` lo / `+0x2C` hi) | `gold` (treasury) | **BYTE_VERIFIED** | debited on buy/boycott-lift `func_03334E @0x3340D` (`sub [bx+0x2a],ax; sbb [bx+0x2c],dx`), credited on treasure cash-in `func_04E2D6 @0x50954` (`+= 100·unit_value`); oracle = 1000 (`rep_economic.bin`/`rep_europe.bin`, active power 0) ↔ in-game "Gold 1000" |
| `+0x2E` / `+0x30` | u16 ×2 | **religious-immigration progress** pair: `+0x2E` = accumulated points so far (current), `+0x30` = next-immigrant cost/target; reaching `+0x2E ≥ +0x30` drops a new immigrant on the Europe dock and **resets `+0x2E` to 0**. Formatted as the `"(%d of %d)"` template (`[0x11a9]`); **NOT a treasury** (gold is `+0x2A`) | **BYTE_VERIFIED** | read `func_037958 @0x379AB` (`dx=[bx+0x30]; bx=[bx+0x2e]`), `@0x379C4` re-pushes both under `"(%d of %d)"` when `[0x5383]&0x20`; **writer `func_0363A2`** (`bx=[0x84fc]`): target `@0x363EF` (`mov [bx+0x30],ax`), inflow `@0x363F5` (`add [bx+0x2e],cx`, `cx=[bp-0xa]`), clamp ≥0 `@0x363FB`, reach-test `@0x36404` (`cmp [bx+0x2e],[bx+0x30]; jg`→arrival `call 0x368e5`), reset `@0x3645E` (`mov [bx+0x2e],0`); init `@0x365CA` (`mov [bx+0x2e],0`). oracle `+0x2e=0,+0x30=10` |
| `+0x32` / `+0x33` | byte ×2 | per-power **default unit destination tile** (`map_x` / `map_y`) — copied into a newly-created unit's goto-target | **BYTE_VERIFIED** | page_0D `@0x51E9B` (`al=[bx+0x32]` → `[si+0x314d]`) / `@0x51EA6` (`al=[bx+0x33]` → `[si+0x314e]`), where `0x314d/0x314e` = UnitRecord goto-target. **Supersedes** the `docs/DATA_MODEL.md` "ref_strength word `+0x32`" guess (the authoritative REF counts are the `DGROUP:0x53DA..0x53E1` globals, per RULINGS 2026-06-19) |
| `+0x49` | byte | per-power **free-immigrant queue count** — number of pre-earned (religious-unrest) recruits waiting on the Europe dock that can be hired for **0 cost**. **Incremented** when the crosses pool `+0x4A` fills (`func_051EF4 @0x529B1` `inc byte[bx+0x49]`, after `@0x529AE sub [bx+0x4a],cx`, gated `[0x538e]>0x50`); **decremented** when one is recruited free (`func_051EF4 @0x52688` `dec byte[bx+0x49]`, taken when `@0x52682 cmp byte[bx+0x49],0` is nonzero, which also zeroes the recruit cost `@0x52658/@0x5265E` and skips the `0x32`-cross payment `@0x5268E`) | **BYTE_VERIFIED** | `func_051EF4 @0x52658/@0x52682/@0x52688/@0x529B1`; init `@0x365D6` (`mov byte[bx+0x49],0`) |
| `+0x4A` | u16 | per-power **crosses/recruit point pool**, drained in fixed `0x32` (50) chunks | **BYTE_VERIFIED (site)** | `func_04E2D6 @0x5276F` (`cmp word[bx+0x4a],0x32`) / `@0x5279F` (`sub word[bx+0x4a],0x32` when ≥50); the `·0x32` immigrant-cost wiring sits beside it (`@0x52765 imul ax,0x32`) |
| `+0x4C+i` | u8[16] | `price_level[good]` — per-good current market price index (good order = `0=Food …15=Muskets`) | **BYTE_VERIFIED** | ask `func_030566 @0x30583` (`al=[bx+si+0x4c]`+base, clamp ≥0), bid `func_030590 @0x3059C` (`al=[bx+si+0x4c]−1`, clamp ≥0), recomputed `func_0305A8 @0x306F3` (`[bx+si+0x4c]=al`); oracle `[1,6,5,5,5,2,6,20,3,10,11,12,15,2,2,3]` (Silver=20 highest) |
| `+0x5C+i·2` | s16[16] | `vol_accum[good]` — per-good signed supply/demand volume accumulator feeding the price recompute | **BYTE_VERIFIED** | accumulated in `func_0305A8 @0x30707/@0x30806/@0x3094F` (`add [bx+si+0x5c],ax`) and drawn down `@0x30A3B/@0x30AB8` (`sub [bx+si+0x5c],ax`); oracle differs between the two snapshots (live accumulator) |

**Classification of the remaining tail.** The `+0x26/+0x28` and `+0x22/+0x24`
accumulators, `+0x2E/+0x30`, `+0x49`, and `+0x4A` are read by the **player-facing**
turn driver (`func_02D658`), the Europe/recruit overlay (`func_04E2D6`,
`func_037958`) and the market funcs — they are **not AI-overlay-only**. The bulk of
the record interior (`+0x33`-tail bytes through `+0x48`, and `+0x60..0x13B` outside
the byte-cited `vol_accum` window) is touched only by the js-dos-schema market arrays
in `docs/DATA_MODEL.md` (`market_pool`/`market_traded_volume`/`market_eu_supply`/
`market_base_values`, RECONSTRUCTED). **Mostly RESOLVED 2026-06-27 by base-register
provenance trace** — the bulk of the `+0x60..0x13B` interior is now byte-cited as **three
parallel per-good s32[16] European-market accumulator arrays** based on the *active-power*
pointer `bx=[0x84fc]`, indexed `bx += good·4`: **`+0x7c`** (`+0x7c..+0xBB`), **`+0xbc`**
(`+0xbc..+0xFB`), **`+0xfc`** (`+0xfc..+0x13B`, exactly filling to the `0x13C` stride end).
All three are **zeroed at game-init** in one 16-good loop (`func@0x366E7`: `bx=[0x84fc]; bx+=good·4;
mov [bx+0x7c]/[bx+0x7e]/[bx+0xbc]/[bx+0xbe]/[bx+0xfc]/[bx+0xfe],0`), **decremented on a BUY**
(`func_0322D0` via thunk `191F:0C14`: `bx=[0x84fc]+good·4; sub [bx+0xbc],ax; sbb [bx+0xbe],dx;
sub [bx+0xfc],ax; sbb [bx+0xfe],dx` `@0x32318..0x32328`, plus `sub [bx+si+0x7c],ax` `@0x32340`),
**incremented on a SELL** (`func_03234A` via thunk `191F:0A2E`: `add [bx+0xbc]/[bx+0xfc]…`
`@0x323B0..0x323C0` — called by the per-turn auto-export at `func_02D658 @0x2D774`), and
**read by the economic report** (`func_034318 @0x343C1`: `push [bx+di+0xbc]` over 16 goods,
`bx=[0x84fc]`, `di=good·4`). So the price-recompute `func_0305A8` (which touches only `+0x4c`
price_level and `+0x5c` vol_accum) is a *separate* path; the `+0x7c/+0xbc/+0xfc` trade-stat
arrays are written by the buy/sell handlers instead. **The only PowerRecord interior still
with no byte-cited site = `+0x33..+0x48`** (RECONSTRUCTED, js-dos schema); a live diff is still
the path for that narrow window.

Production inputs are primary game data:
- **`@BUILDING`** (buildings + production modifiers), **`@JOB`** (professions),
  **`@UNFORESTED`/`@FORESTED`** (terrain yields) — all in
  `data_extracted/text/NAMES_sections.json`. **BYTE_VERIFIED** (data exists).

## 3. Formulas & rules

### Per-tile production — **BYTE_VERIFIED end to end** (`compute_terrain_yield`, file `0x9B9C..0x9FFB`; re-read 2026-08-28)
The 2026-08-28 read replaced several earlier glosses (marked ✝ below) and is
cross-checked against every per-tile badge in the COLONY_SHIP census baseline
(Vlissingen: farmers 6/5, lumberjacks 4/4, miners 4/4, fisherman 4). The
COLUMN is the worker's `@JOB` row 0..8 (`func_009974`: occupation byte), and
the terrain row comes from the classifier `func_00624E` (0x3E4:0xE): **bit5
set → Hills (0x1C), bit5+bit7 → Mountains (0x1B)** — a mountain ore miner
reads the `@OTHER` Mountains row (ore 4), never the base-terrain row.
```
yield = terrain_yield_table[classify(v)*16 + col]     # DGROUP:0x2F7B, @0x9C1E (from NAMES)
if yield != 0:
    # ✝ the "adjacency nudge" was the FISHERMAN ladder (col >= 8): n = 8-neighbour
    # count of ocean/sea-lane (func_0099EE with lo/hi 0x19/0x1A):
    #   n>=8: −2   n in 6..7: −1   n<6: +1                          @0x9C33..@0x9C87
    # furs (col 4): +1 road (imp&0x0A), +1 river (v&0x40), +1 more major (v&0x80)
yield = max(yield, 0)                                               @0x9CB4
pen = tory penalty:                                                 @0x9D13..@0x9D98
    tories  = (pop*(100−sol)+50)/100
    divisor = human colony ? 10−difficulty : (tories forced 0)      @0x9D43/@0x9D73
    pen     = −(tories/divisor) + 1 per RECORD flag +0x1C bit2/bit1 (NOT runtime sol)
if yield != 0 and pen > 0: yield += pen        # positive pen EARLY @0x9D9B
expert = (profession byte == col)              # plain byte equality @0x9CDC — prof 0 IS Expert Farmers
if expert and yield != 0:
    if col in {0, 8}: yield += 2 (+pen again if pen>0)              @0x9DB9..@0x9DC9
    else:             yield <<= 1                                   @0x9DD2
bonus = func_009AAA[detail_id][col]            # detail hash = prime resource; res 7 with
if bonus < 0: yield <<= 1                      # yield<=0 → 0; negative DOUBLES,
else: yield += expert ? 2*bonus : bonus        # expert doubles the bonus  @0x9DD5..@0x9E10
# silver (col 7) with no detail and no mine bit (imp&4): 1 if road/expert else 0,
# and the improvement block below is skipped                        @0x9E41..@0x9EA6
if col == 5: yield <<= 1                       # the LUMBER column DOUBLES @0x9EAB
if yield > 0:                                  # improvements @0x9EBD..@0x9F4C
    b = ((expert and col not in {0,8}) or col == 5) ? 2 : 1
    if col == 0:               yield += b      # the farmer's inherent +b
    if (imp & 0x0A) and col>3: yield += b      # road
    if (imp & 0x40) and col<=3: yield += b     # plow
    if v & 0x40: yield += b; and another +b for a MAJOR river only when the
                 river was the sole bonus collected                 @0x9F3B..@0x9F46
if col >= 8 and not colony_has(row 6 = DOCKS): yield = 0            @0x9F4F  (✝ not "manufacturing building")
if col == 4 and father 8 (Henry Hudson) owned: yield <<= 1          @0x9F65
if profession == 27 (Indian Convert) and yield > 0 and col in {0..4, 8+}: yield += 1  @0x9F86
yield = max(yield, 0); if yield != 0 and pen < 0: yield = max(0, yield + pen)  # negative pen LAST @0x9FD8
```
✝ The port's old capture-fitted easy-difficulty +2/+1 field bonus is **not in
the bytes** and is gone (difficulty enters field yields only through the tory
divisor). Side effects while computing: `[0xA896]` accrues depletion pressure
(+1 detail-6 ore, +2 detail-6 silver, +1 detail-12 silver, `@0x9E13..@0x9E41`)
and the producer sums fisher yields into `[0xA895]`.

### Indoor production — **BYTE_VERIFIED** (`func_009FFC`, file `0x9FFC..0xA221`)
expert = profession byte == occupation byte (`@0xA01A`). Class rate from the
PROFESSION (`@0xA0D7..@0xA0FD`): Indentured Servant (25) → 2, Petty Criminal
(26) / Indian Convert (27) → 1, else 3. Tory pen identical to the field's.
Per job (jump table `@0xA1F4`, cs base 0x82B0):
- **Carpenter 13** `@0xA100`: `(expert?6:class)+pen`, **×2 with the Lumber
  Mill** (row 0x24).
- **Preacher 16** `@0xA132`: `(expert?6:class)+pen`, ×2 with the Cathedral
  (row 0x26), +50% with William Penn (father 21).
- **Statesman 17** `@0xA1C8`: `class+pen`, ×2 if expert. (The Printing
  Press/Newspaper act on the bell TOTAL, not here.)
- **Teacher 18** (default `@0xA0AF`): `expert?3:1`.
- **Converters 9-12, 14, 15** `@0xA188`: `class+pen`, **+class** with the 2nd
  link, **+50%** with the 3rd (factory), ×2 if expert. (Isabella's census rum
  row 4 = criminal 1 + free 3.)

### Field learn-by-doing — **BYTE_VERIFIED** (`@0x2E01C..@0x2E107`, 2026-08-28)
Inside the per-colony turn processor, after the school pass: each colonist
whose profession is an unskilled tier (`func_0082B2` returns 0 for none 28 /
Free Colonists 19 / Indentured Servants 25 / Petty Criminals 26; Indian
Converts are skipped outright `@0x2E05E`) and whose OCCUPATION is a
planter/trapper job 1..4 (`@0x2E070`) may learn that job's specialty — but
only while the power owns **zero** of it: the gate reads `[job-0x6BD0]`, the
per-power profession census `func_042726` rebuilds from every owned
UnitRecord's `+0x17` byte plus every colonist's `+0x40` byte.  The roll is
`random_int(0, N) == 0` with N = 99 (199 for a Servant, 99+200 for a
Criminal, `@0x2E080..@0x2E098`); success sets `profession := job id`
(`0x181F:0xCAE` — the byte-equality expert rule makes him the job's expert;
the setter also remaps Veteran Dragoons→Veteran Soldiers `@0x9141`) and
emits `@TRAINPROFESSION` (string 0xE1F) with the specialty name, registering
the new expert in the census (`@0x2E0B4`).  The 0xE1F id is now
**byte-verified**, not flagged: the key-name table holds `TRAINPROFESSION`
**twice** (`@0x1E7AF` and `@0x1E7BF` in the EXE string block), and the
name-table delta from `TRAINFAIL` (`@0x1E787` = id 0xDE7) lands 0xE1F exactly
on the second copy.

### Mine depletion — **BYTE_VERIFIED** (accrual `@0x9E13`, consumer `@0x2EA62..@0x2EA9D`, action `func_02D30A`)
Field yields accrue `[0xA896]` (ore on Minerals +1, silver on Minerals +2,
silver on a Depleted Mine +1; zeroed per produce `@0xA22C`).  Per point the
turn rolls `random_int(0, difficulty+1)`; a NONZERO roll bumps
`ColonyRecord+0x97`; at 50 it wraps and `func_02D30A` marks every worked
ore/silver cell whose detail id is 6 or 12 with improve bit **0x04**
(`@0x2D383`) — killing the resource bonus and switching the sprite to the
Depleted Mine through `map_detail_id`'s `imp&4` gate — and emits
`@DEPLETION` (string 0xD75) once per turn.

### Growth, starvation & the food warning — **BYTE_VERIFIED** (`func_02D658 @0x2E10A..@0x2E36C`, read 2026-08-28)
The message ids pin by name-table delta from `@TRAINFAIL` (`@0x1E787` = id
0xDE7): `@NEWCOLONIST` 0xE2F, `@FOOD1` 0xE3B, `@FOOD2` 0xE41, `@VANISH`
0xE47, `@STARVE1` 0xE4E, `@STARVE2` 0xE56, `@FOODLOW` 0xE5E — and the same
walk proves the table holds `TRAINPROFESSION` **twice** (`@0x1E7AF`,
`@0x1E7BF`), closing the old 0xE1F flag.  The engine's order is growth →
starvation → warning, and every seasonal variant is picked by the season
word `[0x538C]` (0 = spring → the `1` variant, `@0x2E19A`).

1. **Growth** `@0x2E10A`: threshold = thunk `0x181F:0xCB8` → `func_0098B4`
   called with two null out-args; the function **returns the constant
   0xC8 = 200** (`@0x98BD`; its out-args, when non-null, expose the
   20-food-per-unit rate and a `min((cap+1)·20−1, 118)` figure for other
   callers).  `stock[FOOD] >= 200` → deduct 200 (`@0x2E123`) and spawn a
   **type-0 (Colonists) unit on the colony square** via `0x181F:0x95C` →
   `func_006D24 (0, owner, x, y)` (`@0x2E136`) — the child waits at the
   fence, he is *not* a colony member — then `@NEWCOLONIST` (`@0x2E156`).
2. **Starvation** `@0x2E164`: trigger is the food **outage plane
   `[0x8E5A]`** (`max(0, eaten − start-stock − produced)`, `func_008E02`),
   not the banked stock.  AI powers (power ≥ 4, or an `AIPersonality`
   controller `@0x2E170`) are forgiven an outage below 3 (`@0x2E177`).
   deaths = 1 **only when the colony entered the turn with zero food**
   (`[bp-0x6a]` captured `@0x2D6BF`, tested `@0x2E1AD`); on difficulty ≤ 1
   a death is waived before 1520 (`@0x2E1C0`) and afterwards survives only
   `random_int(0, 2−diff) == 0` (`@0x2E1D4`).  deaths = 0 →
   `@FOOD1`/`@FOOD2`; deaths = size → `@VANISH` (`@0x2E265`); else
   `@STARVE1`/`@STARVE2`.  Each death removes a **random** colonist
   `random_int(0, size−1)` via `func_008FB4` (`@0x2E2C6`) — the engine's
   removal primitive: shift the +0x20/+0x40 arrays and +0x60 nibbles, clear
   field claims equal to the index and decrement those above it, size−−,
   SoL divisor −100 (`@0x902E/@0x9031`).  Size 0 destroys the colony
   (`@0x2E2F8`).
3. **`@FOODLOW`** `@0x2E30A` (only when the outage is zero): fires — no
   latch — while the **overdraw plane `[0x8E32]`** (`max(0, eaten −
   produced)`) is nonzero and `stock < 4·overdraw`
   (`@0x2E314/@0x2E31B`), with the stock as `%NUMBER` (`@0x2E33D`); gated
   by colony-report option "Report food shortages" (`[0x5384]` bit 0x40,
   set = suppress, `@0x2E321`).

Both engines carry this model verbatim (`cport/core/colopy_turn.c`
`colony_turn`, `port/src/game.js` `colonyTurn`); the port's old
latch-based warning/depletion states (`foodWarned`/`foodDepleted`) are
gone.  The cheat handler's own size++ site is `@0x2C12B` (debug key), and
colony creation zeroes size `@0x2EC17` — neither is the growth site.

### The centre tile — **BYTE_VERIFIED** (`func_00A222 @0xA222..@0xA3D1`)
FOOD band by classifier id — arctic 0; desert family {1, 9, 0x11} 1; forested
8..23 and Hills/Mountains 2; other land 3 (`@0xA247..@0xA290`; **no
auto-clear fold** — a rain-forest centre is band 2); +2/+1 at difficulty 0/1;
+2 when the centre's prime resource is 1, 2 or 9 (`@0xA314`); +1 per record
flag +0x1C bit2/bit1. **SECONDARY** (`@0xA343..@0xA3D1`): best of columns 1..7
skipping 5 on the same classified row, resource bonus per column (negative
doubles), strict `>` so the FIRST max wins; the winner gets +1 at difficulty
0, the river bonus (minor 1 / major 2), +1 per flag bit — and the amount is
**added to production** (`@0xA3F7..@0xA409`). Vlissingen: rain-forest ore 1 +
Minerals 3 = 4 wins, +1 → 5 (runtime-confirmed by the sidebar's "(Minerals)"
line, which also independently validates the detail hash and map seed 1657).

### Per-turn driver sequence — `colony_turn_update @0xA222` (traced 2026-06-26)
The ordered per-turn colony pipeline (call sites byte-read):
1. Setup `lcall 0x3E4:0x3A @0xA23C`, then three `lcall 0x37F:{0x142,0x4B0,0x10E}`
   (`@0xA2B9/0xA2D6/0xA2F3`) — accumulator/context init.
2. **Tile production**: loop over the 3×3 ring / goods (bounds `cmp [bp-0x1c],0x14`=20
   `@0xA3E8`), `call 0x9AAA` (feature bonus) + **`call 0x9B9C` = `compute_terrain_yield`**
   `@0xA42A`, accumulating per-good into the produced table `[good·2 + 0x8DC8]`.
3. **Raw→finished chains — RE-READ 2026-08-28 (the outage model).** The indoor
   wants accumulate **uncapped** (`@0xA480..@0xA4A0`); the resolution runs at
   the tail: `call 0x8E46(5, hammers)` then **`call 0x8E84` ×5**
   (`@0xA64E..0xA68C`, args `(raw, finished)`: Ore6→Tools14, Tobacco2→Cigars10,
   Cotton3→Cloth11, Furs4→Coats12, Sugar1→Rum9), then `0x8E46(14, muskets)`.
   `func_008E84` records the finished good's raw COST (×2/3 with the factory
   tier: `func_00864E(finished) > 2`, `@0x8EA9/@0x8EB1`) and `func_008E02`
   fills three per-good planes: consumed `[0x8E0A]`, the warehouse OVERDRAW
   `[0x8E32]` = max(0, consumed − produced), and the **OUTAGE** `[0x8E5A]` =
   max(0, consumed − stock − produced) — which `func_008E84`'s tail converts
   to product units for a factory (everything when nothing was affordable,
   else ×3/2, `@0x8EC9..@0x8EFC`). The product is short by the outage.
   ✝ **Tools' `[0x8E66]` subtract (`@0x8E5A..@0x8E61`) is not a
   "tools-from-horses offset"** — `0x8E66 = 0x8E5A + 2·6` is the ORE outage:
   the gunsmith sees the toolsmith's post-outage output. **HORSES**
   (`@0xA5B0..@0xA63B`): want = 2·ceil(herd/(Stable?25:50)), fed by
   ceil(surplus/2), stored bounded by warehouse room; `goods[8] += want` and
   `[0x8E6A]` (the outage slot) = want − stored, the crossed foals. **B.**
4. **Food consumption — BYTE_VERIFIED: `eaten = 2·pop`** (`@0xA5F2` `mov al,[bx+0x1F]; shl
   ax,1`); `net_food = max(food_produced[0x8DC8] − 2·pop, 0)` (`@0xA5F7 sub/neg`, clamp
   `@0xA5FD`). Net food feeds the **`+0xAA` food-growth store** (read `@0xA5D6`/`@0xA61F`;
   half-of-surplus toward growth, §3) — **not** `+0xC8` (`+0xC8` is the SoL `rebel_divisor`
   high word, written only by the EMA `func_02D658 @0x2DA1C`, §2). **CORRECTED 2026-06-27:**
   the earlier "`+0xC8` accumulator / `+200` threshold @`0x2E098`" gloss was a misread — a
   reseg of `0x2E088..0x2E0A1` shows `@0x2E098 add [bp-0x60],0xc8` writes the **message-quantity
   local `[bp-0x60]`** (pushed into the `lcall 0x181f:0x4d4` notification at `@0x2E0A1`), never
   `ColonyRecord+0xC8`.
5. **Warehouse capacity — BYTE_VERIFIED: `cap = (warehouse_level[+0x95] + 1)·100`**
   (`func_008D00`: base `0x64`=100 `@0x8D04`, `(+0x95+1)·0x64` `@0x8D1A` when `+0x95≠0`).
6. **Display-delta bookkeeping** `func_008E02` (via `func_008E46 @0xA648/0xA655/0xA699`):
   per good, computes produced/room/overflow into the colony-screen summary tables at
   DGROUP `0x8E0A`/`0x8E32`/`0x8E5A` (indexed `good·2`); Tools(0xE) gets a special subtract
   of `[0x8E66]` `@0x8E61`.

**Warehouse "spoilage" — CORRECTED 2026-06-27 (there is no per-good spoilage clamp).** A full
scan of every `+0x9A` write site shows the stockpile is **banked with only a floor at 0, no
ceiling** (`func_02D658 @0x2D96E` `add [bx+si+0x9a],ax` then `@0x2D972` `or/jge/sub` clamp ≥0).
The over-capacity disposal is **not spoilage** — it is the **auto-export-to-Europe** path
(`func_02D658 @0x2D6F7`): for each tradeable good (filter `func_02EF55 @0x2D6DD`) with
`stock ≥ 100` (`cmp [+0x9a],0x64`), the stock is reduced to **50** (`sub [+0x9a], stock−0x32`
`@0x2D70B`) and the **excess is sold** — `net = excess·price − tax` credited to the treasury
`PowerRecord+0x22` (`@0x2D785`, the `[0x84fc]` player record) — **unless independence is declared**
(`[0x5382]&1` `@0x2D728`), in which case the excess is **wasted, not sold**. So `func_02D658`'s
100→50 is the Custom-House/auto-export step (canonical: `warehousing.md §6.4`), **not** a
`(level+1)·100` cap. The `func_008D00` `(level+1)·100` value is fetched once `@0xA615` and used
**only** to bound the **food growth reserve** (`cap − [+0xAA]` `@0xA61F`), not per-good goods.
**B (corrected).** *(Open: whether a true over-warehouse-cap spoilage exists for non-tradeable
goods — none was found; `0x181F:0xD3A` cap query `@0x2D6AF` is the warehouse-level lookup feeding
the export step.)*

### Building presence & factory tier — **BYTE_VERIFIED** (`ColonyRecord +0x8A` bitmap)
Each colony tracks which buildings it has in the per-colony bit-array at
`ColonyRecord +0x8A` (one bit per building id; `building_bit(n)` above is a read of
this array). Accessors:
- `func_0085B2` `test_bit_at_8a(n)` — getter (used by the production gates).
- `func_0085D6` `set_or_clear_bit_at_8a(n, op)` — `op!=0` sets, `op==0` clears;
  both compute `*(0x8542) + 0x8A + n/8` and mask `1 << (n&7)`.

A building **chain** (e.g. Weaver's House → Weaver's Shop → Textile Mill) is walked
by `count_building_chain_present` (`@0x864E`): from a start link it follows the
signed-byte next-link table `byte[idx*12 + 0x8F86]` (negative = end), tallying each
link whose colony bit is set via `func_00863E → func_00860E` (the `[0x8DC6]`-scoped
test). The caller treats **`count > 2`** as the *factory present* condition
(`@0x8EA9 CMP ax,2 / JLE`) — i.e. the 3rd link present ⇒ factory-tier yield
(Henry-Hudson-style ×2 manufacturing). This per-colony bitmap (not the
`PowerRecord +0x07` FF bitmask) is the subsystem the build-menu consults for
Adam-Smith/Stuyvesant constructability gating; see `founding_fathers.md` §3 note.

### Sons of Liberty % — **BYTE_VERIFIED** (`sol_membership_pct`, file `0x8524..0x85B1`)
```
sol_pct = (rebel_dividend[+0xC2] * 100) / rebel_divisor[+0xC6]     # @0x8557/0x855E (mul32/div32 helpers)
if FF_op(0x12) [Jan de Witt] and owner<4 and human:  sol_pct += 20  # @0x859C
sol_pct = min(sol_pct, 100)
```
**Per-turn accumulator update — BYTE_VERIFIED** (`func_02D658 @0x2DA1C..0x2DAD8`).
Both `+0xC2` (dividend `A`) and `+0xC6` (divisor `B`) are **32-bit exponential
moving averages** with a fixed decay of **1/64** per turn (six `sar/rcr` pairs):

> **RUNTIME-CONFIRMED founding-init values 2026-06-26** (`colony_jamestown.bin`, a
> just-founded pop-1 colony with all per-turn accumulators still 0): `B(+0xC6) = 200`,
> `A(+0xC2) = 0` → `sol_pct = 0%` (matches the live Score screen "Continental Congress +0").
> Other freshly-initialized fields: `build_target(+0x94) = 6`, `food-accum(+0xC8) = 0`,
> `hammers(+0x92) = 0`, `build-progress(+0xB6) = 0`, `warehouse_level(+0x95) = 0`,
> stockpile `Muskets(+0xB8) = 50`. So a rewrite seeds a new colony with **rebel_divisor B = 200,
> dividend A = 0**; the EMA then decays B toward its `128·pop` steady state from there.
```
new_bells = bells produced this turn (after the modifiers below)
pop       = colony size (ColonyRecord +0x1F)

# divisor B (capacity)  @0x2DA1C
B -= B >> 6                 # decay 1/64   (@0x2DA24 ×6 sar/rcr)
B  = max(B, 1)              # clamp ≥1     (@0x2DA44)
B += 2 * pop                # inflow       (@0x2DA64 pop<<1; add)

# dividend A (rebel bells)  @0x2DA73
A += new_bells - (A >> 6)   # decay 1/64 then add new bells (@0x2DA78/@0x2DA98)
A  = max(A, 0)              # clamp ≥0     (@0x2DAA4)
A  = min(A, B)              # A never exceeds B (@0x2DABE) → sol_pct ≤ 100
```
**`new_bells` modifiers (`@0x2D9DF..0x2DA1C`):** during the War of Independence
(`[0x5382]&1`) a colony owned by the tory-leader power (`[0x53D2]`) has its bells
**halved and negated** (`new_bells = −(new_bells/2)`, `@0x2D9F2`); otherwise, if
`pop > new_bells`, a small downward pressure `new_bells += scratch/(−20)` is applied
(`@0x2DA0E`, divisor `0xFFEC`).

Because both terms are 1/64-decay EMAs, the **steady state** is `B → 128·pop` and
`A → min(64·new_bells, B)`, so `sol_pct → min(100, 50·new_bells/pop)` — i.e. **SoL%
≈ 50 × (bells/turn) ÷ population**, reaching 100% when bell output ≥ `2·pop`.
(Derived consequence of the byte-verified EMA, not a stored constant.)

Crossing thresholds fires the `REBELMAJORITY` (≥50%, `@0x2DB29`) / `REBELUNANIMOUS`
(≥100%, `@0x2DB6E`) / `TORYMINORITY` (<95%) / `TORYMAJORITY` (<50%) / `SONSUP`/
`SONSDOWN` messages and feeds the per-nation `PowerRecord +0x02 rebel_sentiment_pct`.

### Hammers / build progress — field **BYTE_VERIFIED**, completion site **BYTE_VERIFIED** (`func_02D658`→`func_02D0E4`→`func_0092E0`, RESOLVED 2026-06-20; see "Completion" below)
Building progress is a slot in the **per-good colony amount array at `ColonyRecord
+0x9A`** (u16, stride 2) — *not* a standalone field. The array holds **20 goods
(0..0x13)**: the 16 `@CARGO` tradables (0..0xF) followed by the 4 internal goods
**`0x10`=Hammers, `0x11`=Crosses, `0x12`=Liberty Bells, `0x13`=Flags**, so the array
would run `+0x9A..+0xC0` and put **Hammers at `+0x9A + 0x10·2 = +0xBA`** (u16).
⚠ **DISPUTED, and the 16-wide reading keeps winning** — the build code reads
`+0x92`/`+0xB6`, **never `+0xBA`** (RULINGS 2026-06-20), and `docs/DATA_MODEL.md`
maps the per-good array as **16×u16** (`+0x9A..+0xB9`), making `+0xBA` a separate
field.  2026-08-28 adds two more direct readers consistent only with 16-wide:
the growth/starvation block reads **`+0x9A` as `stock[FOOD]`** (`@0x2E11D`,
`@0x2D6BF`) and the tools gate reads **`+0xB6` as `stock[TOOLS]`** (good 14,
`@0x2E5DD/@0x2E6A7`), while the internal goods live in the DGROUP planes
(`[0x8DE8]` hammers / `[0x8DEA]` crosses / `[0x8DEC]` bells) and the record's own
`+0x92` bank.  No reader of a 20-wide array has ever been found; the conflict row
stays only until someone shows one.

> **Conflict resolved 2026-06-20 (corrects the prior off-by-one lead):** the earlier
> note placed `0xF`=Hammers ⇒ `+0xB8`. That is wrong. `+0xB8` is good `0xF` =
> **Muskets** — `auto_manage.c @0x548E9` arms a defender when `col[+0xB8] ≥ 0xC8`
> (200), spending `0x32` (50) muskets. And `sol_tory.c` reads `colony_query(0x12)` =
> **Liberty Bells**, which fixes the order to Hammers `0x10` / Crosses `0x11` / Bells
> `0x12` / Flags `0x13`. Both independently land **Hammers at `+0xBA`**.

- **Accumulation:** Hammers are produced like any good (Carpenter `Lumber→Hammers`)
  and accrue into the `+0xBA` slot each turn via the same producer path as the
  raw→finished chains (`colony_turn_update`).
- **Completion — RESOLVED & BYTE_VERIFIED 2026-06-20** (the "hammers ≥ `@BUILDING`
  cost ⇒ add the building" check). It is **inline in the per-turn colony update
  `func_02D658`**, committing via `func_02D0E4 → func_0092E0`. Full chain (all sites
  byte-verified; see `notes/rulings/RULINGS.md` 2026-06-20):
  - **Hammer accrual bank = `ColonyRecord +0x92`** (u16): each turn `+0x92 +=
    hammers_produced` (good-0x10 query `lcall 0x181f:0xb50 → func@0x8DBC`, which reads
    a **global** per-good table `DGROUP:0x8E5A`, not a colony field), clamped ≥0
    (`@0x2E50F`/`@0x2E517`).
  - **Build target id = `ColonyRecord +0x94`** (`@0x2E529 mov al,[bx+0x94]`; `<0` =
    no target, guard `@0x2E544`). **Cost function = `func_00B65A`** (thunk
    `0x181F:0xAC4`, re-read 2026-08-28): classifier `func_00B5A8` maps the id —
    0..0x29 → **building** (cost = `@BUILDING[idx]` word from **`DGROUP:0x8F8C`**
    stride 12, tools = the row's byte × 10 `@0x0B694`; table written by parser
    `func_074D18 @0x74D1D`), 0x2A..0x30 → **unit `@UNIT` rows 11..17** (Artillery,
    Wagon Train, Caravel, Merchantman, Galleon, Privateer, Frigate; hammer cost =
    the stride-14 unit record's byte `[0x5239+14i]` **× 32** `@0x0B6B7 shl ax,5`,
    clamp ladder `<40 → 40`, `40..51 → 52` `@0x0B6BD..@0x0B6CF` — only the 40 floor
    is reachable for ×32 inputs, and it is what prices the Wagon Train's 32 at
    "(40 Hammers)"; tools = byte `[0x523A+14i]` × 10 `@0x0B6E3`).  The function
    returns the hammer cost and writes the **tools cost** through its out-arg.
    Gate `cost ≤ +0x92` (`@0x2E53B`).
  - **`+0xB6` is `stock[TOOLS]`** (good 14 of the 16-wide `+0x9A` array — the
    prior "second hammer bank" reading is **overturned 2026-08-28**): the gate
    `tools_cost ≤ +0xB6` (`@0x2E5DD`, against `func_00B65A`'s out-arg); a shortfall
    posts **`@NEEDTOOLS`** (key 0xEA1, NUMBER0 = needed, NUMBER1 = on hand
    `@0x2E62B/@0x2E640`) — and when the stock is zero the engine literally
    **strcats the string "0" (0xEAB) onto the key** to form `@NEEDTOOLS0`
    (`@0x2E64F strcpy` / `@0x2E669 strcat`), gated by colony-report option bit
    0x10 ("Report tools needed", `@0x2E5FF`).  **AI colonies simply get
    `stock[TOOLS] = cost`** (`@0x2E696`).  Payment: `+0xB6 −= tools_cost`
    (`@0x2E6A7`) → `func_02D0E4`.
  - **Commit:** `func_0092E0` sets the **persistent constructed-mask bit** in
    **`ColonyRecord +0x84..0x89`** (`cx = *(0x8542) + (id>>3) + 0x84; or [bx],
    1<<(id&7)`, `@0x9308`). **The `+0x8A` bitmap is the DISPLAY copy** — its setter
    `func_0085D6` is a byte-for-byte twin differing only in the `+0x8A`/`+0x84`
    constant. The pre-completion "already-built?" guard tests `+0x84`
    (`func@0x860E` reads `[colony_idx·0xCA + 0x5DCA]`, `0x5DCA = 0x5D46 + 0x84`).
  - **Build target `+0x94` is NOT auto-reset** to 0xFF on completion (no writer in
    either function); re-completion is blocked by the `+0x84` guard + `@ALREADYHAVE`.
    Target re-selection is a colony-UI action.
  - **One hammer bank, zeroed on completion (corrects the 2026-06-20 "two
    hammer fields" reading, 2026-08-28):** `+0x92` is the only hammer field —
    the per-turn accumulator (`+= hammers_produced`, clamp ≥ 0
    `@0x2E50F..@0x2E521`) and the completion gate (`cost ≤ +0x92` `@0x2E53B`).
    The completion tail **sets `+0x92 = 0`** (`@0x2D26C`) — **surplus hammers
    are NOT carried**.  The "X of Y" message keyed 0xEA1 is `@NEEDTOOLS`
    (tools, not hammers — see the `+0xB6` bullet), and the only debit on the
    way in is the tools payment `@0x2E6A7`.  Both engines carry this model
    (previously they subtracted the cost and carried the surplus).
  - ⚠ **Conflict with prior dump labels (RULINGS 2026-06-20):** the older
    "RUNTIME-VERIFIED" labels build-target `+0x10` / constructed-mask `+0x60..0x65`
    / hammers `+0xBA` are **not referenced** by the completion code, which uses
    `+0x94` / `+0x84` / `+0x92`+`+0xB6`. The byte-traced offsets are authoritative
    for the build mechanism; the dump labels are flagged for re-examination.

### Warehouse / storage capacity — **BYTE_VERIFIED** (`func_008D00`)
Per-good storage cap for the **regular (tradable) goods** = **`(ColonyRecord +0x95 +
1) · 100`**, default **100** when `+0x95 == 0` (`@0x008D04` `bp-2=0x64`; `@0x008D14`
`(+0x95)+1; ×0x64`). So **100 / 200 / 300** for warehouse level **0 (none) / 1
(Warehouse) / 2 (+Expansion)**. **CORRECTED 2026-06-27:** `colony_turn_update`'s single
`func_008D00` call (`@0x00A615`) bounds **only the food growth reserve** (`cap − [+0xAA]`
`@0x00A61F`), **not** per-good goods. Goods are **not** clamped/spoiled at this cap — over-100
tradeable goods are **auto-exported to Europe** (→50, sold; wasted if independence declared) in
`func_02D658`; see the "Warehouse spoilage — CORRECTED" note above and `warehousing.md §6.4`. The
prior "surplus production is dropped (spoilage)" wording was wrong.

**Food is the exception — base capacity 200** (user-confirmed; manual). Food is not a
warehouse-limited trade good but the **population-growth store**: it accumulates to
its cap and then a colonist is born. The growth path is byte-traced —
the grow branch lives in `func_009318` (file `0x009318..0x009626`) — reached when the
`func_00929A` bound-classifier (called `@0x009412`, dispatched on its 0..3 return
`@0x00941B..0x009429`) takes the case-3 path to `@0x00942E`; the grow branch
(`@0x009432`) fires only while `population (+0x1F) < 0x20` (32, the max colony size),
then `population++` (`@0x009464`), bumps the SoL divisor `+0xC6 += 100` (`@0x009453`),
and posts `@NEWCOLONIST`. **CORRECTED 2026-06-27:** there is **no "200" food threshold** here —
`func_009318` is the **generic add-colonist routine** (it `INC`s pop `+0x1F` and bumps the SoL
divisor `+0xC6/+0xC8 += 100` whenever population grows, regardless of cause), and `func_00929A` is a
**job-assignment bound classifier** (it compares the job-slot index `[bp+6]` against the colony's
population count `+0x1F` and the secondary index `[bp+8]` against `0x13`=19 — confirmed
`func_00929A @0x929A..0x92DF`), **not** a food evaluator. The real food-growth gate is the **`+0xAA`
accumulator vs the 25/50 threshold** in `func_00A3E1` (next paragraph); the 200 figure was a
mis-attribution.

> **SUPERSEDED IN PART, 2026-08-17 (see `notes/rulings/RULINGS.md`).** Everything
> below that treats **`ColonyRecord +0xAA` as a food-growth store**, and that reads
> `func_00A3E1 @0x0A5B4..@0x0A63F` (the "25 with a Stable / 50 without" threshold) as
> the food-growth gate, is a **misattribution**. `+0xAA` is the **Horses** stock and
> that block is **horse breeding**. The colony stock array is at `+0x9A`, u16 per
> good, indexed by good id — proved by `push word ptr [bx+si+0x9a]` **@0x08E6E**
> with `si = good*2` — so `+0x9A + 2*8 = +0xAA` is cargo row 8, Horses; buildings row
> `0x11` (queried @0x0A5C0) is the Stable. Read as horses the block is coherent: gate
> `herd >= 2` @0x0A5B4, per-turn cap `2*ceil(herd/T)` @0x0A5D6..@0x0A5E2, feed
> `ceil(max(0, produced_food - 2*pop)/2)` @0x0A5F7..@0x0A606, warehouse clamp
> @0x0A614..@0x0A627 (`func_008D00 @0x08D00`: 100 at level 0, else `(level+1)*100`),
> and the foals' feed added to the colony's food consumption @0x0A63F. It also
> explains the write census below: no per-turn `+0xAA` write exists because a **stock**
> field is written by the generic indexed goods loop, not by a named displacement.
>
> What survives unchanged: the starvation-WARNING emitter and the removal site in
> `func_02D658`, the `eaten = 2*pop` base @0xA5F2, the pop cap 32 and the
> `+0xC6 += 100` birth write in `func_009318`, and the `+0xC8` correction. What is now
> **open**: the real per-turn food-growth store for `@NEWCOLONIST` is unlocated — the
> census that went looking for it was searching the wrong field — and the 200-food
> threshold stays tier **R** (manual), flagged in both engines.

**Growth & starvation mechanism — refined 2026-06-27 (B mechanism + B warning-trigger + B
starvation-removal site `func_02D658 @0x2E2DE`; the per-turn `+0xAA` write was found NOT to exist — write-census closed **B**, see foot of section).** Per turn the
food **surplus = max(0, producedFood[`0x8DC8`] − 2·pop)** (`@0xA5F7`); **half of it**
(`ceil(surplus/2)` = `inc;sar ax,1` `@0xA606`, capped) accrues toward growth, accumulated against
the colony food-growth field **`+0xAA`** (read `@0xA5D6`/`@0xA61F`; growth fires once `+0xAA` ≥ the
threshold, which is **25 with a Stable (building `0x11`) / 50 without** — `func_00A3E1 @0xA5BB`
seeds `[bp-0x1e]=0x19`(25), `@0xA5C0` queries Stable via `push 0x11; call 0x863e`, and `@0xA5C9
or ax,ax; jne` keeps 25 when the Stable is present, else `@0xA5CD mov [bp-0x1e],0x32`(50); the
`cmp [+0xAA],2` skip-gate is `@0xA5B4`). The earlier "25 normally / 50 on the difficulty flag"
wording was wrong — the toggle is the **Stable building**, not a difficulty flag. The
**born-colonist** write is `func_009318` (`INC [+0x1F]`, above); the **starvation** write is
`func_008FB4 @0x902E` (`DEC [+0x1F]`, shifting the colonist job arrays `+0x20/+0x21/+0x40/+0x41` and
the 0x14-entry work-tile table `+0x70` down to fill the vacated slot). **Starvation-WARNING emitter
byte-verified 2026-06-27** (reseg `func_02D658 @0x2E1A7..0x2E2BA`): the resident turn driver only
*posts the messages* — `[bp-0x12c]` is a **food-OK boolean** (`mov [bp-0x12c],1` `@0x2E1A7`, cleared
`@0x2E1B3`/`@0x2E1E0` from the `lcall 0x181f:0x4ca`/`0x4d4` overlay food-state queries), and the
`cmp [+0x1f],[bp-0x12c]` test `@0x2E242` (pop vs the flag) selects which template fires: `0xe3b`/`0xe41`
(=@FOOD1/@FOOD2 "food stores depleted"), `0xe47` (=@VANISH "colony vanished… starved"), `0xe4e`/`0xe56`
(=@STARVE1/@STARVE2 / @FOODLOW) — all via `call 0x2ef5f` `@0x2E2B4` (templates in
`GAME_sections.json`). **Starvation-removal call site PINNED 2026-06-27 (overlay_deep, reseg page_03):**
the `func_008FB4` DEC-pop *is* reachable statically — it is **`func_02D658 @0x2E2DE`** (`push [bp-0x76];
lcall 0x181f,0xa9c` → thunk `181F:0A9C`=`func_008FB4`), inside the food-depletion block that fires the
@FOOD/@VANISH/@STARVE templates. It runs in a loop `@0x2E2C6..0x2E2F2` bounded by the colonist-index
counter `[bp-0xb4]` vs the food-state word `[bp-0x12c]` (`@0x2E2EE cmp [bp-0x12c],ax; jg 0x2c6`), each
iteration pushing the colonist slot `[bp-0x76]` (loaded from the `lcall 0x181f,0x4d4` food-state query
`@0x2E2D2`) and calling `func_008FB4` to remove that colonist; the whole-colony case (`@0x2E242 cmp
[+0x1f],[bp-0x12c]`) instead pushes the @VANISH template `0xe47` `@0x2E265`. So the per-turn starvation
removal is **B (byte-pinned, reseg `func_02D658 @0x2E2DE`)**, not runtime. (The resident-image view of
`func_02D658` truncates before this block — the body lives in reseg page_03 `@0x2E1A7..0x2E2F4`, the
overlay copy.) **The per-turn `+0xAA` increment remains the only unresolved site:** an exhaustive write
scan of the resident image **and all 31 resegmented overlay pages** finds only **two** writers of
`ColonyRecord+0xAA` — `mov [bx+0xaa],2` (floor, page_0E `@0x5627D`, gold-buyout path) and
`add [bx+0xaa],0x64` (scout-colony +100, page_0F `@0x5A3CA`) — **no per-turn additive `+= surplus/2`**.
(The `lcall 0x181f:0x4ca`/`0x4d4` calls in this block resolve to the resident notification helpers
`func_00C30A`/`func_00C322` — leaf message formatters with no globals/calls, not the mutator.) The
per-turn `+0xAA` accumulation is thus the lone write with **no statically-resolvable site** in
`func_02D658`'s resident body or the 31 reseg pages; pinning it requires a two-turn live
`ColonyRecord+0xAA`/`+0x1F` — now **CLOSED by the write-census (B)**: no per-turn `+0xAA` write exists (see foot of section). *(Field reconciliation RESOLVED 2026-06-27 by oracle RAM read: in both founding snapshots
`colony_jamestown.bin` and `colony_live_1505.bin` (pop 1, `[0x8542]`→colptr `0x606e`),
`ColonyRecord+0xAA = 0` AND `+0xC8 = 0`. An image-wide write scan settles the roles: `+0xC8`
is written **only** by the SoL 32-bit EMA (`func_02D658 @0x2DA1C`, `sub/add [bx+0xc6]/[bx+0xc8]`,
§2) — it is the `rebel_divisor` high word, NOT a food store; `+0xAA` is the food-growth store
(the §3 forecast reads it at `@0xA5D6`/`@0xA61F`). The "+0xC8 growth accumulator" gloss in driver
step 4 was stale and is now corrected there. **A (oracle) / B (write-scan).**)* **B (funcs +
surplus rule + field reconciliation + starvation-removal site `func_02D658 @0x2E2DE`, reseg page_03) /
CLOSED — write-census (B, 2026-06-28): an exhaustive image-wide scan (resident + all 31 reseg pages,
including ES-prefixed and register-indexed forms) finds **no** per-turn `+= surplus/2` write to `+0xAA`
at all. The *only* two writers image-wide are init `=2` (`page_0E @0x5627D`, after a −10 treasury debit)
and event `+=0x64` (`page_0F @0x5A3CA`). The per-turn food surplus is accumulated in the **DGROUP
globals** `[0x8dc8]/[0x8dd8]/[0x8e6a]` (`func_00A3E1 @0x00A5F7`/`@0x00A635`), **not** in `+0xAA`; the
growth forecast only *reads* `+0xAA` `@0x00A5D6`. So the earlier "`+0xAA += surplus/2` per turn" model
was a misattribution — corrected. **B.**)**

## 4. UI layout
The **Colony screen** (`docs/COLONY_RENDER_CHAIN.md`) shows the building grid,
production grid, SoL bars, and the 16-commodity warehouse. Per-colony summary on
the **Colony Adviser (F6)** (`docs/ADVISOR_REPORTS_AUDIT.md`).

## 5. Evidence
- `viceroy_source/src/colony/turn_update.c` — `compute_terrain_yield` (file `0x9B9C..0x9FFB`) + `colony_turn_update` (`0xA222..0xA6A1`), full byte-traced bodies. **B**
- `viceroy_source/src/colony/production_support.c` — `sol_membership_pct` (`0x8524..0x85B1`): `(C2*100)/C6` + Jan-de-Witt +20, clamp 100. **B**
- `viceroy_source/src/colony/sol_tory.c` + `func_02D658 @0x2DA1C..0x2DAD8` — per-turn
  `rebel_dividend`(+0xC2)/`rebel_divisor`(+0xC6) update: both 32-bit EMAs, decay 1/64,
  inflow `new_bells` / `2·pop`, clamp `A∈[0,B]`. **B** (smoothing constants now byte-verified). 
- `docs/DATA_MODEL.md` — ColonyRecord stride `0xCA`; `+0x1A/+0x1B/+0x1C/+0x1F/+0x9A/+0xC2/+0xC6` (runtime-verified). **B/A**
- `func_02D658` (file `0x2D658`) — per-turn build completion: hammer accrual `+0x92` `@0x2E50F`, target `+0x94` `@0x2E529`, cost gate `@0x2E53B`, surplus `+0xB6 −= cost` `@0x2E6A7`; commit `func_02D0E4`→`func_0092E0` sets `+0x84` bit `@0x9308`; `@BUILDING` cost table `DGROUP:0x8F8C` (parser `func_074D18 @0x74D1D`, reader `func_00B65A @0xB688`). **B** (RULINGS 2026-06-20)
- `data_extracted/text/NAMES_sections.json` — `@BUILDING/@JOB/@UNFORESTED/@FORESTED/@CARGO`. **B**
- `docs/COLONY_RENDER_CHAIN.md` — colony-screen composition. **B/R**

## 6. Confidence summary
- **B:** record stride; owner/status/size + stockpile + SoL dividend/divisor
  fields; the production-input data sets; the **per-tile production formula**
  (terrain lookup, expert ×2 / era +2, SoL/Tory penalty `10−diff` divisor,
  resource bonus, building gates); the **SoL %** computation.
- **B (added):** warehouse/storage capacity `(+0x95+1)·100` (`func_008D00`).
- **B (added 2026-06-20):** building-**completion** — `func_02D658`→`func_02D0E4`→
  `func_0092E0`: hammers `+0x92`/`+0xB6` vs `@BUILDING[+0x94].cost` (table
  `DGROUP:0x8F8C`, stride 12) ⇒ set persistent bit `+0x84` (display copy `+0x8A`),
  surplus carried in `+0xB6`, target `+0x94` not auto-reset.
- **A (static inference, 2026-06-20):** `+0x92` and `+0xB6` track the **same hammer
  total** — both are gated against the *identical* cost `[bp-0xc]` (single `@BUILDING`
  lookup `@0x2E52F`; `+0x92` gate `@0x2E53B`, `+0xB6` gate `@0x2E5DD`/`@0x2E6A1`), and
  no path advances one without the other; `+0x92` is the raw accumulator, `+0xB6` the
  displayed/debited copy ("X of Y", surplus carried). (`+0xB6` is **not** a tools bank
  — there is no separate tool-cost lookup.) Full lockstep would need a runtime dump to
  100%-confirm, hence **A** not B.
- **RESOLVED 2026-06-27:** end-of-turn "spoilage" of an overfull stock — there is **no per-good
  spoilage clamp**; over-100 tradeables are **auto-exported to Europe** (→50, sold; wasted if
  independence declared) in `func_02D658 @0x2D6F7..0x2D785` (see §3 "Warehouse spoilage — CORRECTED").
- **Building prerequisite gating — BYTE_VERIFIED 2026-06-27 (substrate + build-menu consumer both pinned).**
  The predecessor structure, its walkers, AND the build-menu consumer that calls them are now byte-traced —
  the consumer is the colony-screen handler **`func_053B7E`** (page_0E): walker call `func_0086C0`
  `@0x055ED1` (`lcall 0x181f,0xba0`) + bit-test `func_00863E` `@0x055DE9`/`@0x055EF7` (`lcall 0x181f,0x9fc`),
  detailed at the end of this entry. **Chain "next-link" table =
  `DGROUP:0x8F86`**, stride **12 (0xC)**, signed byte per record (negative = end of chain) — accessed as
  `byte[idx·12 + 0x8F86]` (resident funcs encode it `[bx-0x707a]`, bx=idx·12; `0x10000−0x707a=0x8F86`).
  **Four chain-walk helpers** (reseg `0x864E..0x871F`): `func_00864E` = count links whose colony bit is
  set (bit test `call 0x863e`), `func_008686` = same scoped to a colony (`call 0x860e`), `func_0086C0` =
  walk chain to its end, `func_0086E4` = return the **first** present link (else `0xFFFF`). The
  **`@BUILDING` parser** `func_074D18` lays the 42-record table at base **`DGROUP:0x8F82`** stride 12
  (loop `@0x74D01..0x74D4C`, `bx=idx·3<<2`): `+0x00` word cost (`@0x74D12`), then five `lcall 0x1a1f:0x88a`
  byte/word reads → `+0x0A` word (`[si-0x7074]`), `+0x07` (`[si-0x7077]`), `+0x05` (`[si-0x7079]`),
  `+0x08` (`[si-0x7076]`), `+0x09` (`[si-0x7075]`); the chain-link byte `+0x04` (`0x8F86`) is populated
  separately.   **Production consumers of the walk:** `func_008E84` (`@0x8EA3`, the ×2/3 factory throttle) and
  `func_009FFC` (`@0xA19B`, the factory-tier yield ×1.5/×2).
  **Build-menu / construction consumer — PINNED 2026-06-27 (overlay/UI).** The walkers are reached from
  the colony-screen UI via **far thunks** (the prior pass only checked *near* callers, hence the false
  "no caller"). The thunk map: `func_0086C0`=`181F:0BA0`, `func_008686`=`181F:0B14`, `func_00863E`
  (bit-test)=`181F:09FC` (`thunk_resolve.json`). The **build-menu constructability gate** is inside the
  monolithic colony-screen handler **`func_053B7E`** (page_0E, 10025 bytes) — it walks a 6-entry
  build-category list (`al=byte[bx+0x864]`, bx=slot·4, slots 5..0) and for each calls the predecessor
  walker **`func_0086C0` `@0x055ED1`** (`lcall 0x181f,0xba0`) plus the building-bit test **`func_00863E`
  `@0x055DE9`/`@0x055EF7`** (`lcall 0x181f,0x9fc`, e.g. `push 8`), gating on `@BUILDING` requirement
  fields (`[bx-0x6bf0]`/`[bx-0x6d68]`/`[bx-0x6bec]`/`[bx-0x6da3]`/`[bx-0x6bdc]`) and the colony pop
  `[0x8542]+0x1f` — emitting the "can't build" reason codes (`push 0x0f/0x10/0x11/0x08/0x0b` →
  `jmp 0x269e`) and on success writing the build target `[0x8542]+0x94` (`@0x055F62`). The **colony-scoped**
  count walker `func_008686` is also reached far, via `func_02EB1C @0x2EB37` (`lcall 0x181f,0xb14`,
  page_03), which precomputes a per-colony chain-count into `[idx·0xCA+0x5e04]`. So the build-menu
  predecessor check **is** byte-pinned (`func_053B7E @0x055ED1`); the "untraced colony-UI overlay" is
  page_0E.

## 7. Open questions → `spec/BACKLOG.md`
1. ~~Byte-trace the per-turn hammers accumulation + build completion.~~ **DONE
   2026-06-20** — completion is `func_02D658`→`func_02D0E4`→`func_0092E0` (**B**):
   hammer banks `+0x92`/`+0xB6`, target `+0x94`, cost table `DGROUP:0x8F8C`,
   persistent mask `+0x84` (display copy `+0x8A`), surplus carried, target not reset
   (§3). **Correction:** the build code uses `+0x92`/`+0xB6` (not the dump-labeled
   `+0xBA`) and `+0x84`/`+0x94` (not `+0x60`/`+0x10`) — RULINGS 2026-06-20. **RESOLVED:** `+0x92` = hammer **accrual** bank (`@0x2E50F`); `+0xB6` = build-cost **debit**, surplus carried (`@0x2E6A7`) (`BACKLOG.md` #4b); `+0xBA` = element 0 of the 4-entry per-power flag array `+0xBA..+0xBD` (`records.md` §4), not a hammers field. **B.**
2. ~~**Warehouse** capacity thresholds~~ **Done** — regular goods `cap=(+0x95+1)·100`
   (100/200/300), `func_008D00`, applied `@0x00A615` (2026-06-20). **Spoilage RESOLVED
   2026-06-27:** no per-good spoilage clamp; over-cap tradeables auto-export to Europe
   (`func_02D658`, §3). **Food growth-store CORRECTED 2026-06-27:** the food accumulator is
   `ColonyRecord +0xAA` (not a "base-200" constant, and **not** in `func_00929A` — that func is the
   job-slot bound classifier); the per-turn growth-conversion **threshold is 25 (Stable present, bldg
   `0x11`) / 50 (no Stable)** per `func_00A3E1 @0xA5BB/@0xA5C0/@0xA5CD`. **RESOLVED 2026-06-28 (write-census, B):**
   an exhaustive image-wide scan for every WRITE-encoding to `[bx+0xAA]` (all opcode/modrm forms, resident
   `disasm/` + all 31 overlay pages + `orphans_overlay.asm`) finds **exactly two** writes, both constants:
   `add [bx+0xaa],0x64` (rush-grant `@page_0F 0x05A3CA`) and `mov [bx+0xaa],2` (gold-buyout floor
   `@page_0E 0x05627D`) — **no per-turn `+0xAA += surplus` instruction exists in the binary**. The food
   chain computes net food into globals `[0x8dec]`/`[0x8dc8]`/`[0x8dd8]`/`[0x8e6a]` and only *reads* `+0xAA`
   (`@0xA5D6`/`@0xA61F`); the surplus→accumulator transfer + birth/starve decrement are applied at
   **runtime** with no static write site. The call targets ARE resident (`lcall 0x981,0`→func_009818,
   `func_008D00`, `func_008E46`) but none writes `+0xAA`. Terminal: **A (oracle: `+0xAA`=0 in both
   founding snapshots; structurally the only writes are the two constants above)** — there is no further EXE
   byte to decode.
3. ~~Confirm the per-turn SoL dividend/divisor smoothing constants~~ **Done 2026-06-20**
   — both are 1/64-decay EMAs (`func_02D658 @0x2DA1C`); `B += 2·pop`, `A += new_bells`,
   `A` clamped to `[0,B]` ⇒ steady-state `sol% ≈ 50·bells/pop`. **B.** **RESOLVED 2026-06-28 (B):** the
   `[bp-0x8C]` scratch IS `new_bells` verbatim (stored from the overlay bell-production query
   `0x181F:0xC86`→`@0x027264` at `@0x2D9DB`); the downward-pressure term added to `A` is
   `new_bells / (−20)` (`mov cx,0xFFEC; cwd; idiv cx; add [bp-0xB8],ax` `@0x2DA12..0x2DA18`), applied only
   when `A > byte[colony+0x1F]` (floor gate `@0x2DA08`). The divisor −20 is a byte-verified constant; only
   `new_bells`'s value is the runtime query return.
