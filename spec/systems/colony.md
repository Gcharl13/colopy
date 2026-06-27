# Colony & Production

> **Layer 2 — Specification.** PRIMARY data only (`/METHODOLOGY.md`). Tiers:
> `BYTE_VERIFIED` / `ANCHOR_VERIFIED` / `RECONSTRUCTED` / `TBD`.

**Overall confidence:** record stride + fields + **per-tile production formula**
+ **Sons-of-Liberty %** + **hammers/build-progress field** `BYTE_VERIFIED`;
building-completion check + warehouse spoilage `TBD`. **Last updated:** 2026-06-20.
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
| `+0xC8` | food-growth accumulator (read/written in the per-turn food accounting; the `200` growth constant is added at `@0x2E098`) | **ANCHOR_VERIFIED** | `func_02D658` `@0x2DA20..0x2DACC`, `+200` `@0x2E098` |
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
| `+0x2E` / `+0x30` | u16 ×2 | Europe-screen progress pair, formatted as the `"(%d of %d)"` template (`[0x11a9]`); **NOT a treasury** (gold is `+0x2A`) | **BYTE_VERIFIED (read site)** | `func_037958 @0x379AB` (`dx=[bx+0x30]; bx=[bx+0x2e]`) then `@0x379C4` re-pushes both under `"(%d of %d)"` when `[0x5383]&0x20`; oracle `+0x2e=0,+0x30=10`. Writer/exact semantics (current/target of an immigration or recruit pool) **TBD** |
| `+0x32` / `+0x33` | byte ×2 | per-power **default unit destination tile** (`map_x` / `map_y`) — copied into a newly-created unit's goto-target | **BYTE_VERIFIED** | page_0D `@0x51E9B` (`al=[bx+0x32]` → `[si+0x314d]`) / `@0x51EA6` (`al=[bx+0x33]` → `[si+0x314e]`), where `0x314d/0x314e` = UnitRecord goto-target. **Supersedes** the `docs/DATA_MODEL.md` "ref_strength word `+0x32`" guess (the authoritative REF counts are the `DGROUP:0x53DA..0x53E1` globals, per RULINGS 2026-06-19) |
| `+0x49` | byte | per-power pending-action countdown (decremented to 0) | **BYTE_VERIFIED (site)** | recruit/immigration overlay `func_04E2D6 @0x52658` (`cmp byte[bx+0x49],0`) / `@0x52688` (`dec byte[bx+0x49]`); exact trigger **TBD** |
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
`market_base_values`, RECONSTRUCTED, not byte-cited here) and is left **TBD** rather
than asserted — no read/write site was traced this pass.

Production inputs are primary game data:
- **`@BUILDING`** (buildings + production modifiers), **`@JOB`** (professions),
  **`@UNFORESTED`/`@FORESTED`** (terrain yields) — all in
  `data_extracted/text/NAMES_sections.json`. **BYTE_VERIFIED** (data exists).

## 3. Formulas & rules

### Per-tile production — **BYTE_VERIFIED** (`compute_terrain_yield`, file `0x9B9C..0x9FFB`)
Full body byte-traced in `viceroy_source/src/colony/turn_update.c`. For a worker
on a tile producing good *g*:
```
yield = terrain_yield_table[terrain_id*16 + g]   # DGROUP:0x2F7B, @0x9C1E (loaded from NAMES @terrain)
if yield > 0:
    # adjacency nudge (manufactured/secondary goods g>=8): +1, or −1/−2 if 6/8 like-neighbours  @0x9C3E
    # special feature bumps (furs+feature, river bits)                                            @0x9C87
    # --- Sons-of-Liberty / Tory production penalty (@0x9D14..0x9D98) ---
    tory_cnt = round(population * (100 - sol_pct) / 100)
    divisor  = (owner < 4 and active) ? (10 - difficulty) : 10     # @0x9D49 (= 10−diff)
    yield   += -(tory_cnt / divisor)            # plus +1 each for rebel-majority / rebel-unanimous latches
    # --- profession (expert) match (@0x9DAD..0x9DD2) ---
    if colonist_skill(tile) == g:
        if g in {Food(0), Horses(8)}:  yield += 2          # "era" goods: flat +2
        else:                          yield *= 2          # @0x9DD2 SHL — expert DOUBLES manufactured goods
    yield += feature_yield_bonus(resource, g)   # @0x9AAA: penalty-resource ×2; else +bonus (×2 if expert)
    # --- building gates (@0x9F4F..0x9F83) ---
    if g >= 8 and not building_bit(6):  yield = 0          # needs the manufacturing building
    if g == Furs(4) and FF_op(8):       yield *= 2
yield = max(yield, 0)
```
The lookup table value is **data-driven** (NAMES, not hardcoded); the arithmetic,
multipliers, the `10−difficulty` divisor, and the gates are byte-verified from the
operand bytes. The per-turn driver `colony_turn_update` (file `0xA222..0xA6A1`)
zeroes the 20-good accumulator, runs the 3×3 ring through `compute_terrain_yield`,
then applies the 5 raw→finished chains (Ore→Tools, etc.).

### Per-turn driver sequence — `colony_turn_update @0xA222` (traced 2026-06-26)
The ordered per-turn colony pipeline (call sites byte-read):
1. Setup `lcall 0x3E4:0x3A @0xA23C`, then three `lcall 0x37F:{0x142,0x4B0,0x10E}`
   (`@0xA2B9/0xA2D6/0xA2F3`) — accumulator/context init.
2. **Tile production**: loop over the 3×3 ring / goods (bounds `cmp [bp-0x1c],0x14`=20
   `@0xA3E8`), `call 0x9AAA` (feature bonus) + **`call 0x9B9C` = `compute_terrain_yield`**
   `@0xA42A`, accumulating per-good into the produced table `[good·2 + 0x8DC8]`.
3. **Raw→finished chains**: **`call 0x8E84` ×5** (`@0xA660..0xA68C`, args `(finished, raw)`):
   Ore6→Tools14, Tobacco2→Cigars10, Cotton3→Cloth11, Furs4→Coats12, Sugar1→Rum9.
   **Conversion ratio = 1:1 (BYTE_VERIFIED 2026-06-27)** — `func_008E84` takes the raw the tile
   loop gathered (`produced[finished]`) and converts it unchanged, **except a ×2/3 throttle** when
   the finished good's **building-chain count > 2**: `if func_00864E(finished) > 2: amount =
   amount·2/3` (`shl;mov cx,3;idiv` `@0x8EB1`). The gate counts how many buildings in the finished
   good's requirement chain (chain table `DS:0x8F86`; link ids `byte[good+0x2F4]`) the colony owns,
   via the building bitfield `ColonyRecord+0x84` (`func_00860E`: `imul si,colony,0xCA;
   al=[si+(b>>3)+0x5DCA]; bit b&7`). **Tools (14)** additionally subtract the per-turn
   tools-from-horses offset `[0x8E66]` (`@0x8E61`). Commit `func_008E46`→`func_008E02`. **B.**
4. **Food consumption — BYTE_VERIFIED: `eaten = 2·pop`** (`@0xA5F2` `mov al,[bx+0x1F]; shl
   ax,1`); `net_food = max(food_produced[0x8DC8] − 2·pop, 0)` (`@0xA5F7 sub/neg`, clamp
   `@0xA5FD`). Net feeds the `+0xC8` growth accumulator (the `+200` growth threshold is
   added at `@0x2E098`, §2).
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

### Hammers / build progress — field **BYTE_VERIFIED**, completion site **TBD**
Building progress is a slot in the **per-good colony amount array at `ColonyRecord
+0x9A`** (u16, stride 2) — *not* a standalone field. The array holds **20 goods
(0..0x13)**: the 16 `@CARGO` tradables (0..0xF) followed by the 4 internal goods
**`0x10`=Hammers, `0x11`=Crosses, `0x12`=Liberty Bells, `0x13`=Flags**, so the array
would run `+0x9A..+0xC0` and put **Hammers at `+0x9A + 0x10·2 = +0xBA`** (u16).
⚠ **DISPUTED, not settled** — the build code reads `+0x92`/`+0xB6`, **never `+0xBA`**
(RULINGS 2026-06-20), and `docs/DATA_MODEL.md` maps the per-good array as **16×u16**
(`+0x9A..+0xB9`), making `+0xBA` a separate field. See the `+0xBA` **CONFLICT** row in
the §state table and the §6 residual; the 16-vs-20 array width is unresolved.

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
    no target, guard `@0x2E544`). Cost = `@BUILDING[idx].cost` from table
    **`DGROUP:0x8F8C`** (stride **12 (0xC)**, **42** entries; written by parser
    `func_074D18 @0x74D1D`, read by `func_00B65A @0xB688`). Gate `cost ≤ +0x92`
    (`@0x2E53B`).
  - **Second hammer bank `+0xB6`** (cost-debited): `cost ≤ +0xB6` (`@0x2E6A1`) then
    **`+0xB6 −= cost`** — **surplus hammers are carried** (remainder kept, not
    zeroed) (`@0x2E6A7`) → `func_02D0E4`.
  - **Commit:** `func_0092E0` sets the **persistent constructed-mask bit** in
    **`ColonyRecord +0x84..0x89`** (`cx = *(0x8542) + (id>>3) + 0x84; or [bx],
    1<<(id&7)`, `@0x9308`). **The `+0x8A` bitmap is the DISPLAY copy** — its setter
    `func_0085D6` is a byte-for-byte twin differing only in the `+0x8A`/`+0x84`
    constant. The pre-completion "already-built?" guard tests `+0x84`
    (`func@0x860E` reads `[colony_idx·0xCA + 0x5DCA]`, `0x5DCA = 0x5D46 + 0x84`).
  - **Build target `+0x94` is NOT auto-reset** to 0xFF on completion (no writer in
    either function); re-completion is blocked by the `+0x84` guard + `@ALREADYHAVE`.
    Target re-selection is a colony-UI action.
  - **Two hammer fields (clarified 2026-06-20):** `+0x92` is the **per-turn
    accumulator** (`+= hammers_produced`, feeds the early `cost ≤ +0x92` gate
    `@0x2E53B`); `+0xB6` is the **build-progress bank** that is **shown to the
    player** when the building isn't done yet — at `@0x2E5DD` a `+0xB6 < cost`
    branch formats *cost* and *+0xB6* into a "X of Y hammers" message (template
    `@0xEA1`, `@0xEAB` when `+0xB6 == 0`) — and is the field **debited** on
    completion (`+0xB6 −= cost`, surplus carried). So `+0xB6` is the UI/consumed
    build bank; `+0x92` gates. (Whether the two are kept in lockstep or hold
    distinct totals still warrants a runtime spot-check.)
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
and posts `@NEWCOLONIST`. The exact **200** food threshold constant is **TBD** (the
evaluator compares population against a food-derived argument rather than a literal).

**Growth & starvation mechanism — refined 2026-06-27 (B mechanism; trigger TBD).** Per turn the
food **surplus = max(0, producedFood[`0x8DC8`] − 2·pop)** (`@0xA5F7`); **half of it**
(`ceil(surplus/2)` = `inc;sar ax,1` `@0xA606`, capped) accrues toward growth, accumulated against
the colony food-growth field **`+0xAA`** (read `@0xA5D6`/`@0xA61F`; growth fires once `+0xAA` ≥ the
threshold **25 normally / 50** on the difficulty flag, `cmp [+0xAA],2` gate `@0xA5B4`). The
**born-colonist** write is `func_009318` (`INC [+0x1F]`, above); the **starvation** write is
`func_008FB4 @0x902E` (`DEC [+0x1F]`, shifting the colonist job arrays `+0x20/+0x21/+0x40/+0x41` and
the 0x14-entry work-tile table `+0x70` down to fill the vacated slot). The exact **deficit→remove**
*trigger* (where `2·pop > producedFood` with empty stored food calls `func_008FB4`) and the per-turn
`+0xAA` increment site are still **TBD** — the `0xA5D0..0xA640` block is the colony-screen
**forecast/display**, not the mutation; the mutation funcs are byte-confirmed but their call gate is
not yet pinned. *(NB: the older "+0xC8 growth accumulator" gloss (§ driver step 4) and this `+0xAA`
need a runtime cross-check to confirm which is the live store.)* **B (funcs + surplus rule) / TBD
(trigger + accumulator-field reconciliation).**

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
- **TBD:** end-of-turn spoilage of an overfull stock; building prerequisite gating
  beyond the bit-6 manufacturing gate.

## 7. Open questions (TBD) → `spec/BACKLOG.md`
1. ~~Byte-trace the per-turn hammers accumulation + build completion.~~ **DONE
   2026-06-20** — completion is `func_02D658`→`func_02D0E4`→`func_0092E0` (**B**):
   hammer banks `+0x92`/`+0xB6`, target `+0x94`, cost table `DGROUP:0x8F8C`,
   persistent mask `+0x84` (display copy `+0x8A`), surplus carried, target not reset
   (§3). **Correction:** the build code uses `+0x92`/`+0xB6` (not the dump-labeled
   `+0xBA`) and `+0x84`/`+0x94` (not `+0x60`/`+0x10`) — RULINGS 2026-06-20. Residual:
   `+0x92` vs `+0xB6` bank roles; `+0xBA`'s real meaning.
2. ~~**Warehouse** capacity thresholds~~ **Mostly done 2026-06-20** — regular goods
   `cap=(+0x95+1)·100` (100/200/300), `func_008D00`, applied `@0x00A615`. Remaining:
   the **food** base-200 growth-store threshold constant (`func_00929A`; user-confirmed
   value, byte-site TBD) and end-of-turn spoilage of an already-overfull stock.
3. ~~Confirm the per-turn SoL dividend/divisor smoothing constants~~ **Done 2026-06-20**
   — both are 1/64-decay EMAs (`func_02D658 @0x2DA1C`); `B += 2·pop`, `A += new_bells`,
   `A` clamped to `[0,B]` ⇒ steady-state `sol% ≈ 50·bells/pop`. **B.** Remaining: the
   `new_bells` downward-pressure scratch operand `[bp-0x8C]` at `@0x2DA0E`.
