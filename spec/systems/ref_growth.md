# REF Growth (Royal Expeditionary Force)

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** REF count globals + budget rate `USER-VERIFIED`; budget→unit spend rule `TBD`. · **Canonical primary:** `docs/DATA_MODEL.md` (runtime-verified). Cross-ref `spec/systems/king.md`.

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
- **Spend / add-unit threshold:** `TBD`. Observed: **no** REF unit added across
  budget values up to **1188** → threshold > 1188 (or gated by another
  condition). The writer of `0x53DA..0x53E0` is not yet traced.
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
- `docs/GAME_MANUAL.md` — REF grows over the game, deployed on independence. **R**

## 6. Open questions (TBD)

1. **Spend threshold:** trace the writer of `0x53DA..0x53E0`; find what consumes
   `+0x22` to add a unit (threshold > 1188 observed).
2. **Difficulty scaling** of the +18/turn accrual.
3. **Slot selection** — how a new unit's type is chosen among the four.
4. Relationship between the four counts and the aggregate `+0x32` rating.
