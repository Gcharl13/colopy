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
| `+0x1C` | constant `0x40` across colonies (likely warehouse base/config) | **ANCHOR_VERIFIED** | inspection |
| `+0x1F` | size / population factor (used in colony-burn loot) | **BYTE_VERIFIED** | trace @ file `0x05DE1E` |
| `+0x40..` | `colonist_job_skills[]` (1 byte/colonist; profession id) | **BYTE_VERIFIED** | read in `compute_terrain_yield` (profession-match) |
| `+0x8A` | `buildings_present[]` bit-array (1 bit per building id; the `building_bit(n)` source) | **BYTE_VERIFIED** | accessors `func_0085D6` (set/clear) / `func_0085B2` (test) compute `*(0x8542)+0x8A + n/8`, mask `1<<(n&7)` |
| `+0x95` | `warehouse_level` (0/1/2 = none / Warehouse / +Expansion) | **BYTE_VERIFIED** | read by `func_008D00` capacity = `(+0x95+1)·100` |
| `+0x9A` | per-good colony amount u16[**20**] (goods 0..0x13: 16 `@CARGO` tradables + Hammers/Crosses/Bells/Flags); array spans `+0x9A..+0xC0` | **BYTE_VERIFIED** | `docs/DATA_MODEL.md` (runtime); good order via `sol_tory` `colony_query(0x12)`=Bells |
| `+0xB8` | `muskets` (good `0xF` slot) | **BYTE_VERIFIED** | `auto_manage.c @0x548E9` arms defender: `col[+0xB8]≥200`, `−=50` |
| `+0xBA` | `hammers` / build progress (good `0x10` slot) u16 | **BYTE_VERIFIED** | array index `0x10` (`+0x9A+0x20`); supersedes the off-by-one `+0xB8` lead |
| `+0xC2` | `rebel_dividend` s32 (SoL fraction numerator) | **BYTE_VERIFIED** | read @ `0x8531` (`sol_membership_pct`) |
| `+0xC6` | `rebel_divisor` s32 (SoL fraction denominator) | **BYTE_VERIFIED** | read @ `0x8539` |

> `docs/DATA_MODEL.md` remains the canonical full field map; the offsets above are
> the ones confirmed at a cited read site this pass.

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
runs `+0x9A..+0xC0` and the SoL dividend `+0xC2` sits immediately after it.
Therefore **Hammers = `+0x9A + 0x10·2 = +0xBA`** (u16) — the original `+0xBA` label
is **correct**.

> **Conflict resolved 2026-06-20 (corrects the prior off-by-one lead):** the earlier
> note placed `0xF`=Hammers ⇒ `+0xB8`. That is wrong. `+0xB8` is good `0xF` =
> **Muskets** — `auto_manage.c @0x548E9` arms a defender when `col[+0xB8] ≥ 0xC8`
> (200), spending `0x32` (50) muskets. And `sol_tory.c` reads `colony_query(0x12)` =
> **Liberty Bells**, which fixes the order to Hammers `0x10` / Crosses `0x11` / Bells
> `0x12` / Flags `0x13`. Both independently land **Hammers at `+0xBA`**.

- **Accumulation:** Hammers are produced like any good (Carpenter `Lumber→Hammers`)
  and accrue into the `+0xBA` slot each turn via the same producer path as the
  raw→finished chains (`colony_turn_update`).
- **Completion (residual `TBD`):** the "hammers ≥ `@BUILDING` cost ⇒ add the building
  (set the constructed bit, carry surplus)" check is reached through the array base
  (`[colony + good·2 + 0x9A]`), not a literal `+0xBA` displacement — so it isn't
  found by a `+0xBA` operand scan. Entry points: the build-target field + the
  `@BUILDING` cost table (loaded by `func_0749E0`) and the constructed-buildings
  bitmask `ColonyRecord +0x60..0x65` (RUNTIME-VERIFIED, `docs/DATA_MODEL.md`).

### Warehouse / storage capacity — **BYTE_VERIFIED** (`func_008D00`)
Per-good storage cap = **`(ColonyRecord +0x95 + 1) · 100`**, default **100** when
`+0x95 == 0` (`@0x008D04` `bp-2=0x64`; `@0x008D14` `(+0x95)+1; ×0x64`). So
**100 / 200 / 300** for warehouse level **0 (none) / 1 (Warehouse) / 2 (+Expansion)**
— matching the game. `colony_turn_update` calls it (`@0x00A615`) and limits a good's
gain to `cap − current_amount` (`@0x00A61F` `cap − [colony+good·2]`, clamp ≥0), e.g.
capping **horse breeding** here. Goods cannot exceed the cap; surplus production is
dropped (spoilage). The exact end-of-turn spoilage of an *already-overfull* stock
(e.g. after a warehouse is lost) is the remaining detail (`TBD`).

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
- `data_extracted/text/NAMES_sections.json` — `@BUILDING/@JOB/@UNFORESTED/@FORESTED/@CARGO`. **B**
- `docs/COLONY_RENDER_CHAIN.md` — colony-screen composition. **B/R**

## 6. Confidence summary
- **B:** record stride; owner/status/size + stockpile + SoL dividend/divisor
  fields; the production-input data sets; the **per-tile production formula**
  (terrain lookup, expert ×2 / era +2, SoL/Tory penalty `10−diff` divisor,
  resource bonus, building gates); the **SoL %** computation.
- **B (added):** warehouse/storage capacity `(+0x95+1)·100` (`func_008D00`).
- **TBD:** building-**completion** check (hammers ≥ `@BUILDING` cost ⇒ set the
  `+0x60` constructed bit + carry surplus); end-of-turn spoilage of an overfull
  stock; building prerequisite gating beyond the bit-6 manufacturing gate.

## 7. Open questions (TBD) → `spec/BACKLOG.md`
1. ~~Byte-trace the per-turn hammers accumulation~~ **Field resolved 2026-06-20** —
   Hammers = `+0xBA` (good `0x10` in the `+0x9A` 20-good array); `+0xB8` = Muskets.
   Remaining: the build-**completion** check (hammers ≥ `@BUILDING` cost ⇒ set the
   `+0x60` constructed bit, carry surplus), reached via the array base.
2. ~~**Warehouse** capacity thresholds~~ **Done 2026-06-20** — `cap=(+0x95+1)·100`
   (100/200/300), `func_008D00`, applied in `colony_turn_update @0x00A615`. Remaining:
   end-of-turn spoilage of an already-overfull stock.
3. ~~Confirm the per-turn SoL dividend/divisor smoothing constants~~ **Done 2026-06-20**
   — both are 1/64-decay EMAs (`func_02D658 @0x2DA1C`); `B += 2·pop`, `A += new_bells`,
   `A` clamped to `[0,B]` ⇒ steady-state `sol% ≈ 50·bells/pop`. **B.** Remaining: the
   `new_bells` downward-pressure scratch operand `[bp-0x8C]` at `@0x2DA0E`.
