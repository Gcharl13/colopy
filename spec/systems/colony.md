# Colony & Production

> **Layer 2 — Specification.** PRIMARY data only (`/METHODOLOGY.md`). Tiers:
> `BYTE_VERIFIED` / `ANCHOR_VERIFIED` / `RECONSTRUCTED` / `TBD`.

**Overall confidence:** record stride + fields + **per-tile production formula**
+ **Sons-of-Liberty %** `BYTE_VERIFIED`; per-turn hammers accumulation
`RECONSTRUCTED`; warehouse spoilage `TBD`. **Last updated:** 2026-06-18.
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
| `+0x9A` | `stockpile` u16[16] (NAMES `@CARGO` order) | **BYTE_VERIFIED** | `docs/DATA_MODEL.md` (runtime) |
| `+0xBA` | `hammers` (building-progress accumulator) u16 | **ANCHOR_VERIFIED** | `docs/DATA_MODEL.md` |
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

### Sons of Liberty % — **BYTE_VERIFIED** (`sol_membership_pct`, file `0x8524..0x85B1`)
```
sol_pct = (rebel_dividend[+0xC2] * 100) / rebel_divisor[+0xC6]     # @0x8557/0x855E (mul32/div32 helpers)
if FF_op(0x12) [Jan de Witt] and owner<4 and human:  sol_pct += 20  # @0x859C
sol_pct = min(sol_pct, 100)
```
The dividend/divisor pair is updated each turn in `sol_tory.c`
(`func_02D658`) from the bells produced; crossing thresholds fires the
`REBELMAJORITY`/`SONSUP`/`TORYMAJORITY` messages and feeds the per-nation
`PowerRecord +0x02 rebel_sentiment_pct`. The per-turn dividend/divisor smoothing
constants are **RECONSTRUCTED** (per `sol_tory.c`); the % computation above is
byte-verified.

### Still open
- **Hammers accumulation:** building progress is a slot in the **per-good colony
  production/stockpile array at `ColonyRecord +0x9A`** (stride 2) — *not* a
  standalone field. Cross-branch reconstructions (`colony/colonist_handler.c`,
  `market/pricing.c`) place the pseudo-commodity rows **`0xF`=Hammers, `0x10`=Crosses,
  `0x11`=Liberty Bells, `0x12`=Flags**, so Hammers ≈ `+0x9A + 0xF·2 = +0xB8` and the
  former "`+0xBA`" label is the adjacent (Crosses) slot. **RECONSTRUCTED** (lead from
  the other branch; the per-turn accumulation site in the big producer `func_00A3E1`
  is not yet re-verified against this branch's EXE — keep `R` until traced).
- **Warehouse capacity / spoilage:** base tied to `+0x1C` (=`0x40`); thresholds &
  wastage `TBD`.

## 4. UI layout
The **Colony screen** (`docs/COLONY_RENDER_CHAIN.md`) shows the building grid,
production grid, SoL bars, and the 16-commodity warehouse. Per-colony summary on
the **Colony Adviser (F6)** (`docs/ADVISOR_REPORTS_AUDIT.md`).

## 5. Evidence
- `viceroy_source/src/colony/turn_update.c` — `compute_terrain_yield` (file `0x9B9C..0x9FFB`) + `colony_turn_update` (`0xA222..0xA6A1`), full byte-traced bodies. **B**
- `viceroy_source/src/colony/production_support.c` — `sol_membership_pct` (`0x8524..0x85B1`): `(C2*100)/C6` + Jan-de-Witt +20, clamp 100. **B**
- `viceroy_source/src/colony/sol_tory.c` — per-turn `rebel_dividend`/`rebel_divisor` update (`func_02D658`). **B/R** (smoothing constants R)
- `docs/DATA_MODEL.md` — ColonyRecord stride `0xCA`; `+0x1A/+0x1B/+0x1C/+0x1F/+0x9A/+0xC2/+0xC6` (runtime-verified). **B/A**
- `data_extracted/text/NAMES_sections.json` — `@BUILDING/@JOB/@UNFORESTED/@FORESTED/@CARGO`. **B**
- `docs/COLONY_RENDER_CHAIN.md` — colony-screen composition. **B/R**

## 6. Confidence summary
- **B:** record stride; owner/status/size + stockpile + SoL dividend/divisor
  fields; the production-input data sets; the **per-tile production formula**
  (terrain lookup, expert ×2 / era +2, SoL/Tory penalty `10−diff` divisor,
  resource bonus, building gates); the **SoL %** computation.
- **R:** per-turn SoL dividend/divisor smoothing constants; per-turn hammers
  work-point accumulation (overlay-resident).
- **TBD:** warehouse capacity thresholds / spoilage; building prerequisite gating
  beyond the bit-6 manufacturing gate.

## 7. Open questions (TBD) → `spec/BACKLOG.md`
1. Byte-trace the per-turn **hammers** work-point accumulation (overlay-resident) toward `+0xBA` vs the `@BUILDING` cost.
2. **Warehouse** capacity thresholds + spoilage/wastage logic (base tied to `+0x1C`=`0x40`).
3. Confirm the per-turn SoL dividend/divisor smoothing constants in `sol_tory.c` against the read site.
