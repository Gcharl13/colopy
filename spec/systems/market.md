# Market & Prices

> **Layer 2 — Specification.** PRIMARY data only (`/METHODOLOGY.md`). Tiers:
> `BYTE_VERIFIED` / `ANCHOR_VERIFIED` / `RECONSTRUCTED` / `TBD`.

**Overall confidence:** commodity set + price-storage location + **per-turn drift
formula (`func_0305A8`: decay by `(base+Σtrade)/256`) `BYTE_VERIFIED`**; the
turn-loop *driver* + the `+0xFC` increment site remain `TBD`. **Last updated:** 2026-06-19.
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
- **Remaining `TBD` (blocked, not just unfound):** the per-turn *driver* that
  invokes the `0x1C2AC` thunk (turn-loop call site), and the commodity buy/sell
  transaction that moves `+0xFC`/`+0x5C`/`+0x7C` and computes the bid/ask coin value.
  The latter is **trade-dialog-resident**, in the page-04 region behind the jump
  table at **`0x033F65`** that does **not** linearly disassemble (per
  `viceroy_source/src/market/pricing.c`), so it needs a jump-table-aware decode, not
  an operand scan. ⚠ Note `@0x352CA` (`sub [0x84FC]+0x2A`) is the **unit-purchase**
  gold debit (it calls `place_unit` `0x181F:0x95C` immediately after) — *not* the
  commodity-sale debit; do not cite it for `market_sell`. (The per-good price-base at
  `DGROUP:0x53EA` is **RESOLVED** — random-seeded `[600,1000]` at init by
  `func_07561C @0x75645`.)

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
— see [`king.md`](king.md) §3 (revenue loop currently `TBD`).

**Boycotts:** a Tea Party boycotts one good; field/bitmask `TBD` (cross-ref
`king.md` §7).

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
- **TBD:** turn-loop driver call site; `+0xFC`/`+0x7C` increment site (buy/sell); buy/sell spread; spoilage. (Boycott bookkeeping now **B** — `+0x20`, see `boycotts.md`.)

## 7. Open questions (TBD) → `spec/BACKLOG.md`
1. ~~Byte-trace the **price-drift** formula.~~ **Done 2026-06-19** — `func_0305A8` (**B**); decay `(base+Σtrade)/256`. Remaining: the turn-loop driver + the `+0xFC` increment (buy/sell) site.
2. Confirm the read/write sites for `PowerRecord +0x4C[16]` and reconcile `0x53EA` (per-good[16], per `func_0305A8`) vs the old per-player[4] label.
3. ~~Locate the **boycott** bitmask field.~~ **Done 2026-06-19** — `PowerRecord +0x20` (test `func_030B38`, set `@0x34717`, lift `@0x33423`); see `spec/systems/boycotts.md` §3. Remaining: the Jakob-Fugger clear-all.
