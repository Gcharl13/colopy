# REF Growth (Royal Expeditionary Force)

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** REF count globals + budget rate `USER-VERIFIED`; count **writers located** (`func_03CDA2`/`func_051EF4`, the war-assembly path) `BYTE_VERIFIED`; the `royal_money`→force spend rule `TBD`. · **Canonical primary:** `docs/DATA_MODEL.md` (runtime-verified). Cross-ref `spec/systems/king.md`.

## 1. Purpose & behavior

Over the game the Crown accumulates a hidden **expansion budget** and uses it to
grow the **Royal Expeditionary Force** — the army deployed against the player on
a declaration of independence. The budget ticks up every turn; at some
(undecoded) threshold a new REF unit is added to one of four count slots. The
REF is **exactly four unit types**: Regulars, Cavalry, Man-O-War, Artillery
(per `king.md` and `docs/DATA_MODEL.md`). **RECONSTRUCTED** for the
budget→unit causal link; the counts and the per-turn rate are runtime-verified.

## 2. State & data

| Address / field | Type | Meaning | Tier | Evidence |
|---|---|---|---|---|
| `DGROUP:0x53DA` | u16 | REF **Regulars** count | **USER-VERIFIED** | `docs/DATA_MODEL.md` (23 in-game) |
| `DGROUP:0x53DC` | u16 | REF **Cavalry** count | **USER-VERIFIED** | `docs/DATA_MODEL.md` (10 in-game) |
| `DGROUP:0x53DE` | u16 | REF **Man-O-War** count | **USER-VERIFIED** | `docs/DATA_MODEL.md` (5 in-game) |
| `DGROUP:0x53E0` | u16 | REF **Artillery** count (slot 3) | **USER-VERIFIED** | `docs/DATA_MODEL.md` (8 in-game) |
| `PowerRecord +0x22` | s32 | `royal_money` — King's REF budget | **RUNTIME-VERIFIED** (field+rate); meaning **RECONSTRUCTED** | `docs/DATA_MODEL.md`: English 936→1062 over 7 turns = **+18/turn** (Discoverer); still +18 at turn 65 (1188) |
| `PowerRecord +0x32` | u16 | `ref_strength_rating` (aggregate REF power) | **RUNTIME-VERIFIED** | `docs/DATA_MODEL.md`: Eng=12599, Du=15153, Sp=4899, Fr=5154 |

`royal_money` is **player-only** (other nations = 0). The four count globals are
a standalone array `0x53DA..0x53E1`, authoritative over any PowerRecord
`+0x44/+0x45/+0x46` candidate (see `docs/DATA_MODEL.md` "Conflict — REF location").

## 3. Formulas & rules

- **Budget accrual:** `+0x22 += 18` per turn at Discoverer difficulty.
  **RUNTIME-VERIFIED.** Whether the +18 scales with difficulty is `TBD` (rate
  observed unchanged even as king_anger rose 3→5).
- **Count writers — LOCATED (2026-06-19), and they are REF *assembly*, not a
  per-turn budget spend:**
  - `func_03CDA2` (file `0x3CDA2`) sums the four counts as the REF total
    (`[0x53DA]+[0x53DC]+[0x53E0]+[0x53DE]` @`0x3CDB3..0x3CDBE`) and **guarantees
    ≥1 Man-O-War**: if `[0x53DE]==0` (and a per-power gate byte
    `[0x53D2*0x13 − 0x6DA2]==0`) it does `INC [0x53DE]` @`0x3CDF7`. **B**
  - `func_051EF4` (file `0x51EF4`) walks the unit table for units owned by the
    power (`UnitRecord +0x01 & 0x0F`) of **type `0x12` (Man-O-War)** and, per such
    unit (after a per-unit thunk `0x181F:0x808`), does `INC [0x53DE]` @`0x52013` —
    i.e. the player's Man-O-Wars are tallied into the REF. **B**
  - **Neither writer reads `royal_money` (`+0x22`).** So the +18/turn budget is
    **not** consumed by a direct per-turn `INC` of these counts — the budget→force
    link is indirect (counts appear assembled at/around the independence
    declaration, consistent with "no REF added up to budget 1188").
- **Spend / royal-money consumer:** still `TBD` — the function that reads `+0x22`
  to size the force is not these two; trace it next.
- **Which of the 4 slots** a new unit goes to (mix/weighting): `TBD`.

## 4. UI

REF composition is shown in the King / independence-readiness reports (the four
counts surface in-game — that is how they were USER-VERIFIED). Exact screen and
labels `TBD`. **R**.

## 5. Evidence

- `docs/DATA_MODEL.md` — REF globals `0x53DA/0x53DC/0x53DE/0x53E0`
  (USER-VERIFIED), `+0x22` royal_money (+18/turn), `+0x32` strength rating,
  REF-location conflict ruling. **B / runtime**
- `spec/systems/king.md` — REF = exactly 4 unit types; budget meaning. **B**
- `func_03CDA2` (file `0x3CDA2`) — REF total = sum of the 4 counts; ≥1 Man-O-War guarantee (`INC [0x53DE]` @`0x3CDF7`). **B**
- `func_051EF4` (file `0x51EF4`) — tallies the power's `unit_type 0x12` (Man-O-War) units into `[0x53DE]` (`INC` @`0x52013`). **B**
- `docs/GAME_MANUAL.md` — REF grows over the game, deployed on independence. **R**

## 6. Open questions (TBD)

1. ~~Trace the writer of `0x53DA..0x53E0`.~~ **Done 2026-06-19** — `func_03CDA2`
   (REF assembly; ≥1 Man-O-War guarantee) and `func_051EF4` (tallies the power's
   Man-O-War units into `[0x53DE]`). Remaining: the **`royal_money +0x22`
   consumer** that sizes the force (not in either writer; threshold > 1188).
2. **Difficulty scaling** of the +18/turn accrual.
3. The per-power gate byte `[0x53D2*0x13 − 0x6DA2]` and the per-unit thunk
   `0x181F:0x808` in the assembly path.
3. **Slot selection** — how a new unit's type is chosen among the four.
4. Relationship between the four counts and the aggregate `+0x32` rating.
