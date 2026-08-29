# Market & Prices

> **Layer 2 — Specification.** PRIMARY data only (`/METHODOLOGY.md`). Tiers:
> `BYTE_VERIFIED` / `ANCHOR_VERIFIED` / `RECONSTRUCTED`.

**Overall confidence:** commodity set + price-storage location + **per-turn drift
formula (`func_0305A8`: decay by `(base+Σtrade)/256`) `BYTE_VERIFIED`**; the
turn-loop *driver* + the `+0xFC` increment site **RESOLVED** (driver: **`func_036574`** — end-of-turn per-power drift loop calling `func_0305A8` via `@0x367FC`, invoked from `func_0755CC @0x0757B0`, §3 — *corrected 2026-06-28 from the mislabel `func_33C96`*; `+0xFC` increment: **BUY** `func_03234A @0x323BC` `add [bx+0xfc],ax` / **SELL** `func_0322D0 @0x32324` `sub [bx+0xfc],ax`, §3.1). **Last updated:** 2026-06-28.
**Primary evidence:** `data_extracted/text/NAMES_sections.json` (@CARGO),
`docs/DATA_MODEL.md` (price storage).

## 1. Purpose & behavior
The European market sets a buy/sell price per commodity. Selling pushes a price
down, demand pushes it up; prices drift over time. Boycotts (from Tea Parties)
block trading a good until lifted. Custom Houses allow trade after independence.

## 2. State & data layout

| Field | Meaning | Tier | Evidence |
|-------|---------|------|----------|
| `@CARGO` (NAMES.TXT) | commodity list (16 goods + specials) with economic params | **BYTE_VERIFIED** | `data_extracted/text/NAMES_sections.json` |
| `DGROUP:0x53EA` word[16] | **per-good** European price base (indexed `good*2` in `func_0305A8`) | **BYTE_VERIFIED** | `func_0305A8` `@0x305B8`/`@0x30639` (prior "word[4] per-player" label superseded) |
| `PowerRecord +0x4C` u8[16] | **market sensitivity** (how fast a good's price drops when sold; low = price holds) | **RUNTIME-VERIFIED** | `colonization-memory-map (1).md` (write-verified; supersedes the old "+0x4C price array" label — RULINGS 2026-06-19) |
| `PowerRecord +0x5C` s16[16] | **market pool** (supply/demand imbalance; +surplus/−scarcity) | **RUNTIME-VERIFIED** | `colonization-memory-map (1).md` |
| `PowerRecord +0x7C` s32[16] | **traded volume** (cumulative units traded; long-term trend driver) | **RUNTIME-VERIFIED** | `colonization-memory-map (1).md` |
| `PowerRecord +0xBC` s32[16] | **European supply** per good | **RUNTIME-VERIFIED** | `colonization-memory-map (1).md` |
| `PowerRecord +0xFC` s32[16] (`@0x8904`) | per-good per-player accumulator **summed by the drift fn** (runtime labels it "base/initial values") | **BYTE_VERIFIED (op)** | `func_0305A8` `@0x305D8` reads/sums it; runtime layout per `colonization-memory-map (1).md` (RULINGS 2026-06-19) |

> **Goods order (runtime-verified, index 0..15):** Food, Sugar, Tobacco, Cotton,
> Furs, Lumber, Ore, Silver, Horses, Rum, Cigars, Cloth, Coats, Trade Goods, Tools,
> Muskets (`colonization-memory-map (1).md`).

## 3. Formulas & rules
**Per-turn price drift — `func_0305A8` (file `0x0305A8..0x03064C`). BYTE_VERIFIED**
(2026-06-19; reached via resident type-A thunk `@file 0x1C2AC`, page 4):
```
for good in 0..15:                                 # @0x305B3 (loop to 0x10)
    acc = price_base[good]                          # 16-word table DGROUP:0x53EA, good*2  @0x305B8 (sign-extended)
    for player in 0..3:                             # @0x305CE (loop to 4)
        v = trade_accum[player][good]               # dword table @0x8904 = PowerRecord+0xFC, stride 0x13C, good*4  @0x305D8
        if v < 0: v = 0                             # clamp >= 0  @0x305E0..0x305E8
        acc += v                                    # 32-bit add  @0x305F0/0x305F3
    if [bp+6]==0 and [0x9E12]==0:                   # gate (driver-mode / not-replay)  @0x305FF,0x30605
        price_base[good] -= acc >> 8                # decay: subtract (base + total_trade)/256  @0x30618..0x30639
```
- The drift is a **proportional decay**: each good's European price base relaxes by
  `(current_base + Σ_players clamped_trade_volume) / 256` per turn — i.e. heavy
  selling (large `+0xFC` accumulator) pushes the price down harder. **B.**
- **`DGROUP:0x53EA`** is indexed **per-good** here (`good*2`, 16 words) — a 16-entry
  per-good price-base array (`price_seed[16]`), *not* the "word[4] per-player" label.
  **It is RANDOM-SEEDED — BYTE_VERIFIED:** at new-game init `func_07561C` fills each
  `price_seed[good] = random_int(600, 1000)` (`@0x75645`: `push 0x3E8; push 0x258;
  lcall 0x181F:0x4D4; mov [good·2 + 0x53EA], ax`, loop ×16). So **there is no fixed
  price-base table** — the base is randomized in **[600,1000]** per good each game
  (the per-good **trade accumulator** is `PowerRecord +0xFC` dword[16], `@0x8904`).
- The old `0x181F:0x9A4` attribution was **wrong** — that thunk is a shared utility
  (92 callers), not the drift fn (see `tools/rtlink/THUNK_FOLLOWING.md`).
- **Buy/sell transaction — RESOLVED 2026-06-20 (was "blocked").** The earlier
  blocker note was wrong: the jump table at **`0x033F65`** is **not** the
  transaction — decoding it (`dec ax; cmp ax,0xb; ja default; shl; jmp word ptr
  cs:[bx+0x3a1a]`, 12 handlers `0x33dde..0x33f54`) yields the **button-enable
  predicates** ("which trade actions are available", testing `[bx+0x3146]`/
  `[bx+0x315b]` → boolean `[bp-0x66]`), not the executor. The real transaction is
  **page-13 resident** (`0x4C1F0..0x53540`) with shared helpers on page 4 — see the
  new §3.1. ⚠ `@0x352CA` (`sub [0x84FC]+0x2A`) is the **unit-purchase** gold debit
  (calls `place_unit 0x181F:0x95C` after) — *not* the commodity-sale debit.
- **Drift driver — RESOLVED 2026-06-20.** `func_0305A8` has exactly **4 call sites**,
  all in page 4, reached via the JMP-FAR trampoline at file `0x368bd`
  (`ljmp 0x191F:0x0CBC → resident stub 0x1C2AC → func_0305A8`):
  - **`func_036574 @0x367FC`** — the **per-turn drift driver** (*corrected 2026-06-28
    from the mislabel `func_33C96`*; body bounded `RETF @0x036573`/`@0x03680D`). It first
    zeroes the per-power 16-good accumulators (`mov [bx+0xfc],ax(=0)` loop `@0x03670E`,
    alongside `+0x5C/+0x7C/+0x7E/+0xBC/+0xBE/+0xFE`), then a **4-power loop** (`bp-6`=0..3)
    pushes `(-1, 1)` and calls `func_0305A8` via the trampoline `@0x0368BD`
    (`ljmp 0x191F:0x0CBC → thunk 0x1C2AC → func_0305A8`): the **all-16-goods price
    recompute**. **It is invoked from the end-of-turn processor `func_0755CC @0x0757B0`**
    (`lcall 0x191F:0x0B6C`; `func_0755CC` carries the `AMER2.MP` string + the `0x5380..0x53E0`
    per-power turn block).
  - **`func_0324F2 @0x32902`** and **`func_032914 @0x32D99`** — `drift(good, 0)`, the
    **single-commodity re-drift after a buy/sell** (the SELL/BUY handlers of §3.1).
  So European price movement is driven by **a per-turn phase** (`func_036574`, run from the
  end-of-turn processor `func_0755CC`) **plus** each individual transaction. *(This
  supersedes the prior "no separate headless turn phase / runs only in the trade screen"
  claim — RULING 2026-06-28; the per-turn driver is end-of-turn, byte-verified.)*
  > **Correction (supersedes the 2026-06-20 "page-4 dispatch table" note):** the
  > region `0x3680e..0x36976` is **not** a data table — it is a linker **thunk-island
  > of 72 five-byte `JMP FAR seg:off` trampolines** (RTLink near→far shim). The bytes
  > `0x191F:0x0CBC` at `0x368bd` are the *operand of a `JMP FAR` instruction*, which
  > `tools/find_callers.py` mis-reported as a far-pointer data ref. There is no
  > stride-`0xA` handler table. (Price-base `DGROUP:0x53EA` random-seeded
  > `[600,1000]` by `func_07561C @0x75645`, and the buy/sell accumulator site (§3.1)
  > remain **RESOLVED**.)

### 3.1 Commodity buy/sell transaction — **BYTE_VERIFIED (2026-06-20)**
The executor and its accumulator-updaters were byte-traced via the price helper
`func_030566`'s far-callers (a 7-call cluster in page 13).

**SELL — `func @0x32914`** (args: good `[bp+6]`, screen-idx `[bp+8]`, confirm `[bp+0xa]`):
1. `gross = price · qty` — price via `func @0x3245c` (`call 0x3691c→0x191f:0xdc6`),
   `qty=[0x8dc4]`, `gross` @`0x3249f`; it also calls the SELL accumulator-updater
   `0x3234a` @`0x324ae`. → `[bp-0x52]`.
2. **Tax split** @`0x32a4a..0x32a78`: `tax = gross · king_rate(PowerRecord +0x01) /
   100`; `net = gross − tax`.
3. **Gold credit** @`0x32a82`: `lcall 0x181f:0xaba → func @0x8806` adds `net` (s32)
   to gold and **clamps to `[0, 999999]` (`0xF423F`)**, writing `PowerRecord
   +0x2A/+0x2C` (DGROUP `0x8832`, `[player·0x13c − 0x77ce]`).
4. **King REF fund** `+0x22 += tax` @`0x32a92`; **sales tally** `+0x26 += net`
   @`0x32a9c` (matches `king.md`).

**BUY — six page-13 sites** (e.g. Muskets `0xF`/qty 0x32 @`0x526a2`, Horses `8`
@`0x52790`, Tools `0xE`/qty 0x64 @`0x52866`): compute `price·qty` (`imul ax,ax,0x32`
or `0x64`), affordability-check, then **inline gold debit** `sub [bx+0x2a],ax; sbb
[bx+0x2c],dx` (gross — **buys are untaxed**), then `push qty; push good; lcall
0x191f:0xc14 → func @0x322d0` (the BUY accumulator-updater).

**Accumulator updaters — byte-verified mirror pair** (args `good=[bp+6]`, `qty=[bp+8]`):

| field | BUY `func @0x322d0` | SELL `func @0x3234a` |
|-------|----------------------|----------------------|
| EU-supply `+0xBC` s32 | `−= qty` @`0x3231c` | `+= qty` @`0x323b4` |
| accumulator `+0xFC` s32 (`@0x8904`) | `−= qty` @`0x32324` | `+= qty` @`0x323bc` |
| traded-volume `+0x7C` s32 (good·4) | `−= price·qty` @`0x32340` | `+= price·qty·(100−tax%)/100` @`0x32402` |
| traffic pool `+0x5C` u16 (ALL FOUR powers) | `−= pressure` ×4 @`0x322ff` | `+= pressure` ×4 @`0x32383` (the **Dutch, power 3, ×`2/3`** @`0x32396`) |

where (re-read 2026-08-29, correcting the two errors below)

```
pressure = qty << cargo_shift                 (@CARGO row byte +8, @0x32360)
         + qty · k / 100,   k = (human ? difficulty − 2 : −2) · 16
                            (func_032294 — [0x53A6] is the DIFFICULTY,
                             not a market byte; AI sellers get −2)
```

and the volume `price` uses the **second** price accessor `func @0x30590` =
`PowerRecord [+0x4C + good] − 1`, clamped `≥0` (distinct from `func_030566`).

> **Correction 2026-08-29 (overturns the prior "spec correction"):** the
> "DGROUP pool array `[−0x779c]` stride `0x9e`" IS **`PowerRecord +0x5C`** —
> the index is `(p·0x9E + g)` in WORDS, and `0x9E·2 = 0x13C` is exactly the
> PowerRecord stride; with power-0's base at `−0x77F8` (gold `[−0x77CE]` =
> base + 0x2A), `−0x779C` = base + **0x5C**.  So the traffic accumulator IS
> transaction-moved, per-power, and SAV-persistent; every power's pool moves
> on every trade (the shared world market), with the Dutch accruing only 2/3
> of sell pressure and full buy pressure — their prices fall slower and
> recover faster.  Both engines now keep the accumulator in the record
> (signed 16-bit words) and seed it from the save.
> **Net direction:** a **buy** decreases all (goods leave Europe, gold
> `−gross`, untaxed); a **sell** increases supply/accumulator/pool, credits
> gold `+net`, REF `+tax`, tally `+net`.

### Finished-goods are price-coupled through a shared pool — **BYTE_VERIFIED**
The same drift fn (`func_0305A8`, phases after the supply build) does **not** price
the four manufactured luxuries independently. First it forms a **supply** per good
`supply[g] = price_seed[g] + Σ_players max(euro_holdings[+0xFC][g], 0)`
(`@0x0305AE`). Then:

- **Pool the four finished goods (`@0x030649`):**
  `S_pair = supply[9] + supply[10] + supply[11] + supply[12]` (Rum, Cigars, Cloth,
  Coats), 32-bit `add/adc`, clamped `≥ 1`. *(byte-confirmed: four `add/adc` of the
  good-9..12 frame slots → `[bp-0xa]`.)*
- **Relative-share target price (`@0x030745`):** for each finished good `i∈{9..12}`,
  ```
  target[i] = (S_pair * 3) / supply[i]        # shl/rcl ×2 + add = ×3, then ldiv32
  ```
  (`@0x03074F` `shl/rcl/add/adc` = ×3; `@0x030759` `lcall 0x0D1D:0x0EC6` = divide).
  So a good's target is **3 × (the combined Rum+Cigars+Cloth+Coats European supply)
  ÷ (that good's own supply)** — i.e. its price tracks its *inverse share* of the
  shared luxury basket. Dumping one luxury lowers its own price **and nudges the
  other three up** (it grows the shared numerator `S_pair` while only its own
  denominator rises).
- **Raw inputs are priced against the same pool (`@0x0307C9`):** the four raw
  materials `i∈{1..4}` (Sugar→Rum, Tobacco→Cigars, Cotton→Cloth, Furs→Coats) use the
  **same** `target = (S_pair*3)/v` (`v = supply[i]`, **Furs halved**; Furs also
  `+1` if year<1700 and `+1` if year<1600). So each raw good's price is tied to the
  size of the finished-luxury market.
- **Apply:** interactive recompute writes `price_level[+0x4C][i] = clamp(target,
  CARGO.low, CARGO.high)`; the silent per-turn path instead nudges the volume
  accumulator `+0x5C[i] += sgn(price_level − target) · ((rise+fall)/2) · 100`
  (finished) or `· 1` (raw), and **Phase 4** steps the published price ±1 toward it.

**`@CARGO` for the three (`data/commodity_prices.c`):** Rum/Cigars/Cloth share an
identical row — `start 11–13, band [1,20], spread 0, rise 4, fall 4, volatility 1`
— differing **only in `attrition`** (price-recovery rate): **Cloth −13** (recovers
fastest) **> Rum −12 > Cigars −11**. (Coats match Cigars at −11.)

**Buy/sell tax interaction:** the King's tax is taken from European sale proceeds
— **King tax = sale×tax%/100 → REF fund +0x22 (B)**, see [`king.md`](king.md).

**Boycotts:** a Tea Party boycotts one good; tested as a **per-power bitmask at
`PowerRecord +0x20` (word), bit index = good** — `func_030B38 @0x30B47` computes
`(1 << good) & [bx+0x20]` (`bx = [0x84fc]`). **B.** (set/lift sites + Jakob-Fugger
clear-all per `boycotts.md` §3; cross-ref `king.md` §7).

## 4. UI layout
Prices surface on the **Europe screen** (`docs/SESSION_UI_CATALOG.md`) and the
**Economic Adviser (F5)** (`docs/ADVISOR_REPORTS_AUDIT.md`). Commodity icons via
`docs/GAME_INDEX_TABLES.md`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@CARGO`. **B**
- `func_0305A8` (file `0x0305A8`) — per-turn drift: `price_base[good] -= (base + Σ_players clamped_trade)/256`; per-good base `DGROUP:0x53EA[16]`; trade accumulator `PowerRecord +0xFC` dword[16]. **B**
- `docs/DATA_MODEL.md` — `PowerRecord +0x4C` "price area" label **superseded** (it is market *sensitivity* u8[16]; RULINGS 2026-06-19); `0x53EA` per-good base. **A→corrected**

## 6. Confidence summary
- **B:** commodity set; **per-turn drift formula** (`func_0305A8`); per-good price base `0x53EA[16]`; trade accumulator `+0xFC`.
- **RUNTIME-VERIFIED:** the full per-power 16-good market array map (`+0x4C` sensitivity, `+0x5C` pool, `+0x7C` volume, `+0xBC` EU-supply, `+0xFC` base) + goods order (`colonization-memory-map (1).md`).
- **B (added 2026-06-20):** the **buy/sell transaction** (§3.1) — SELL `func@0x32914`
  (gross→tax→net→gold `+0x2A` via clamped helper `func@0x8806`, REF `+0x22`, tally
  `+0x26`), BUY page-13 sites (inline gold debit, untaxed), and the mirror
  accumulator-updaters `func@0x322d0`/`func@0x3234a` (`+0xBC`/`+0xFC`/`+0x7C` + DGROUP
  pool `[−0x779c]`). `+0x5C` is **drift-only** (not per-transaction).
- **B (added 2026-06-20):** the drift **driver** — `func_33C96 @0x367FC` (all-goods
  randomized recompute) + `func_0324F2`/`func_032914` (single-good post-transaction);
  reached via the JMP-FAR trampoline `0x368bd`. Price movement is trade-screen +
  transaction driven, not a headless turn phase.
- **Buy/sell display spread — RESOLVED 2026-06-27 (B).** The Europe price strip draws
  two numbers per good in a 16-good loop (`@0x38D40..0x38E3B`, `[bp-0x84]`=good, `cmp
  ...,0x10`): the **sell** price via `func_030590` (thunk `0x191F:0x09EA`, `@0x38D83`)
  and the **buy** price via `func_030566` (thunk `0x191F:0x0C3E`, `@0x38DE1`), each
  CWDE'd, int-formatted (`0x181F:0xD8`), and blitted (`0x181F:0x204`). From the reseg'd
  accessors: **buy** = `CARGO_row[good].field0 + sens[+0x4C+good]` (`@0x30575` `mov al,
  [bx-0x6900]` with `bx=good*9`; `@0x30587` `add ax,cx`; clamp ≥0) and **sell** =
  `sens[+0x4C+good] − 1` (`func_030590 @0x3059C..0x305A0`, clamp ≥0). So the on-screen
  **display spread = buy − sell = CARGO_row[good].field0 + 1** (per-good constant: field0
  = `@CARGO` col-1 `start_low` = Food 1, Sugar 4, Tobacco 3, Cotton 2, Furs 4, Lumber 2,
  Ore 3, Silver 20, Horses 2, Rum/Cigars/Cloth/Coats 11, Trade Goods/Tools 2, Muskets 3).
  (The `@CARGO` "spread" *column*, field 4 = `[bx-0x68fc]`, is a **different** thing — a
  per-good left-shift exponent on qty in the pool updaters `func@0x322d0 @0x322EA` /
  `func@0x3234a @0x32360`: `mov cl,[bx-0x68fc]; shl dx,cl` — not the display spread.) **B.**
- **Spoilage — out of scope here; owned by `warehousing.md` (B).** Spoilage is **colony
  warehouse-capacity overflow**, not a European-market mechanic: goods over the warehouse
  cap are auto-disposed (`func_02D658 @0x02D6F7`, over-100→50 export) and the player is
  warned via `@WAREHOUSEFULL` / `@SPOIL1..@SPOIL4` (GAME.TXT). See
  [`warehousing.md`](warehousing.md) §3/§6.4 and `spec/ui/popups.md`. No market-side
  spoilage exists.
- (Boycott bookkeeping **B** — `+0x20`, see `boycotts.md`.)

## 7. Open questions → `spec/BACKLOG.md`
1. ~~Byte-trace the **price-drift** formula.~~ **Done 2026-06-19** — `func_0305A8` (**B**); decay `(base+Σtrade)/256`. ~~the `+0xFC` increment (buy/sell) site.~~ **Done 2026-06-20** — buy/sell transaction §3.1. ~~the drift driver/call site.~~ **Done 2026-06-20** — `func_33C96 @0x367FC` (all-goods) + `func_0324F2`/`func_032914` (per-good); the `0x368bd` "table" was a JMP-FAR trampoline misread (§3).
2. ~~Confirm the read/write sites for `PowerRecord +0x4C[16]` and reconcile `0x53EA` (per-good[16], per `func_0305A8`) vs the old per-player[4] label.~~ **Done 2026-06-25 — B.** `+0x4C` is a **per-good byte array indexed by `good`** (base `[0x84fc]`, `byte ptr [bx + good + 0x4c]`), confirmed by four accessors that all index identically: **READ** `func_030566 @0x30583` (`price = CARGO_row[good][0] (stride-9 @[bx-0x6900]) + [+0x4C+good]`, clamp ≥0) and `func_030590 @0x3059c` (`[+0x4C+good] − 1`, clamp ≥0); **WRITE** `func_032262 @0x32272` (`[+0x4C+good] += 1` — price step up) and `func_032278 @0x3228d` (`[+0x4C+good] −= 1`, clamp ≥0 — price step down). The byte index is `good` (1-byte stride, 16 entries), so it is **per-good[16], not per-player[4]**. `0x53EA` is separately indexed `good*2` (16 words) at `func_0305A8 @0x305B8` — distinct array, reconciled.
3. ~~Locate the **boycott** bitmask field.~~ **Done 2026-06-19** — `PowerRecord +0x20` (test `func_030B38`, set `@0x34717`, lift `@0x33423`); see `spec/systems/boycotts.md` §3. Remaining: the Jakob-Fugger clear-all.
