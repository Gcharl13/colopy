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
| `PowerRecord +0x4C[16]` | per-good price-level array | **ANCHOR_VERIFIED** | `docs/DATA_MODEL.md` (price area; confirm read site) |
| `DGROUP:0x53EA` word[16] | **per-good** European price base (indexed `good*2` in `func_0305A8`) | **BYTE_VERIFIED** | `func_0305A8` `@0x305B8`/`@0x30639` (prior "word[4] per-player" label superseded) |
| `PowerRecord +0xFC` dword[16] (`@0x8904`) | per-good per-player trade-volume accumulator (drift input) | **BYTE_VERIFIED** | `func_0305A8` `@0x305D8` (stride `0x13C`) |

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
- **`DGROUP:0x53EA`** is indexed **per-good** here (`good*2`, 16 words) — *not* the
  "word[4] per-player" framing in §2/`DATA_MODEL.md`; that prior label needs
  reconciliation (the bytes show a 16-entry per-good price-base array). The
  per-good **trade accumulator** is `PowerRecord +0xFC` (dword[16], `@0x8904`).
- The old `0x181F:0x9A4` attribution was **wrong** — that thunk is a shared utility
  (92 callers), not the drift fn (see `tools/rtlink/THUNK_FOLLOWING.md`).
- **Remaining `TBD`:** the per-turn *driver* that invokes the `0x1C2AC` thunk
  (turn-loop call site), and where `+0xFC` is incremented on each buy/sell.

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
- `docs/DATA_MODEL.md` — `PowerRecord +0x4C` price area; `0x53EA` market base. **A**

## 6. Confidence summary
- **B:** commodity set; **per-turn drift formula** (`func_0305A8`); per-good price base `0x53EA[16]`; trade accumulator `+0xFC`.
- **A:** price-storage locations (`+0x4C[16]`).
- **TBD:** turn-loop driver call site; `+0xFC` increment site (buy/sell); buy/sell spread; boycott bookkeeping; spoilage.

## 7. Open questions (TBD) → `spec/BACKLOG.md`
1. ~~Byte-trace the **price-drift** formula.~~ **Done 2026-06-19** — `func_0305A8` (**B**); decay `(base+Σtrade)/256`. Remaining: the turn-loop driver + the `+0xFC` increment (buy/sell) site.
2. Confirm the read/write sites for `PowerRecord +0x4C[16]` and reconcile `0x53EA` (per-good[16], per `func_0305A8`) vs the old per-player[4] label.
3. ~~Locate the **boycott** bitmask field.~~ **Done 2026-06-19** — `PowerRecord +0x20` (test `func_030B38`, set `@0x34717`, lift `@0x33423`); see `spec/systems/boycotts.md` §3. Remaining: the Jakob-Fugger clear-all.
