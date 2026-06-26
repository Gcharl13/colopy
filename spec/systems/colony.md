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
(Warehouse) / 2 (+Expansion)**. `colony_turn_update` calls it (`@0x00A615`) and limits
a good's gain to `cap − current_amount` (`@0x00A61F`, clamp ≥0). Goods cannot exceed
the cap; surplus production is dropped (spoilage).

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
Likewise the end-of-turn spoilage of an *already-overfull* regular stock is `TBD`.

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
