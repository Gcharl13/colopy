# REF Growth (Royal Expeditionary Force)

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** REF count globals `USER-VERIFIED`; **the budget→force driver
`func_03E162` `BYTE_VERIFIED`** — accrual rate `(8·diff+10)·2^era`, **threshold 1800**,
composition ratios, and the `royal_money +0x22` spend; count writers
(`func_03CDA2`/`func_051EF4`, war-assembly path) `BYTE_VERIFIED`. · **Canonical
primary:** `func_03E162`; `docs/DATA_MODEL.md` (runtime-verified). Cross-ref `spec/systems/king.md`.

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
| `PowerRecord +0x32` | u16 | `ref_strength_rating` (aggregate REF power) | **RUNTIME-VERIFIED** | `docs/DATA_MODEL.md`; `colonization-memory-map (1).md` |
| `PowerRecord +0x44/+0x45/+0x46` | u8×3 | per-power bytes — **role unresolved** (one dump write-verified as REF, another found ≠ UI); **not** the authoritative count | **CONFLICT** | `colonization-memory-map (1).md` vs `docs/DATA_MODEL.md` (RULINGS 2026-06-19) |

`royal_money` is **player-only** (other nations = 0).

**REF-location — disasm-authoritative + a two-dump conflict (2026-06-19):** the static
disasm is decisive for game logic — the budget driver `func_03E162` (and
`func_03CDA2`/`func_051EF4`) read/write the **standalone globals `0x53DA..0x53E1`**
(regulars/cavalry/manowar/artillery), so **those are the authoritative counts** the
King grows and deploys. The two runtime dumps **disagree** on `PowerRecord
+0x44/+0x45/+0x46`: `colonization-memory-map (1).md` **write-verified** them as the
REF ("zeroing removes it"), while `docs/DATA_MODEL.md`'s session found them ≠ the UI
(with `0x53DA` matching). So `+0x44..46` is a per-power field of **unresolved** role —
do not treat it as the authoritative REF. (RULINGS 2026-06-19.)

## 3. Formulas & rules

- **Starting REF (new-game init) — BYTE_VERIFIED (2026-06-20):** at
  `new_game_state_init @0x7569B` the four counts are seeded from difficulty
  `diff=[0x53A6]`:
  - Regulars `[0x53DA] = 8·diff + 15` → {15,23,31,39,47}
  - Cavalry `[0x53DC] = 5·(diff+1)` → {5,10,15,20,25}
  - Artillery `[0x53E0] = 6·diff + 2` → {2,8,14,20,26}
  - Man-O-War `[0x53DE] = 3·diff + 2` → {2,5,8,11,14}

  **This corroborates the USER-VERIFIED in-game counts (23/10/5/8) exactly at
  `diff=1`** — the same difficulty the +18/turn `royal_money` accrual implies —
  closing the "Discoverer label off-by-one" question: the observed game was at
  `diff=1` (Explorer), not Discoverer. **B.** See `spec/systems/difficulty.md` §3.
- **Budget accrual:** `+0x22 += (8·difficulty + 10)·2^(era gates)` per turn —
  **BYTE_VERIFIED** (`func_03E162 @0x3E17C`; see below). The runtime **+18/turn**
  matches `diff=1` (`8·1+10`); era gates double it at 1600/1700/1750.
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
- **Budget accrual + reinforcement — `func_03E162` (file `0x3E162..0x3E2E8`).
  BYTE_VERIFIED (2026-06-19).** This is the per-turn REF driver and the
  `royal_money` **consumer**:
  - **Accrual rate** (`@0x3E17C..0x3E1AC`): `rate = (difficulty[0x53A6]·8 + 10)`,
    then **doubled once per era gate** passed on year `[0x538A]` ≥ `0x640`/`0x6A4`/
    `0x6D6` (**1600 / 1700 / 1750**). I.e. `rate = (8·diff + 10) · 2^(eras)`.
    Base per difficulty = `{Disc:10, +1:18, +2:26, +3:34, +4:42}` — the **+18/turn**
    runtime observation matches `diff=1` exactly (corroborates the formula; the
    runtime "Discoverer" label is off by one in indexing). Accrual runs only
    pre-independence (top gate `[0x5382]&1`, `@0x3E172`).
  - **Accrue:** `royal_money += rate` — 32-bit at current-player `PowerRecord
    +0x22/+0x24` via `[0x84FC]` (`@0x3E1B5`).
  - **Threshold:** a new REF unit is bought **iff `royal_money ≥ 1800` (`0x708`)**
    (`@0x3E1C6` `cmp +0x22, 0x708; jae`). This is why the runtime budget reached
    **1188 with no unit added** — it had not yet crossed 1800. **B.**
  - **Composition selection** (`@0x3E1D0..0x3E21D`) — picks the slot that keeps the
    force in ratio (`[bp-8]`, default **Regulars** slot 0):
    - **Cavalry** (slot 1) if `(regulars+2)/3 > cavalry[0x53DC]` (≈ 1 cav per 3 reg);
    - **Artillery** (slot 3) if `regulars/4 > artillery[0x53E0]` (≈ 1 art per 4 reg);
    - **Man-O-War** (slot 2) if `(regulars+cavalry+artillery+5)/10 > manowar[0x53DE]`
      (≈ 1 naval per 10 land).
  - **Apply:** `inc [0x53DA + slot·2]` (`@0x3E238`) adds the unit to the chosen
    count; pre-independence it then **deducts the cost `royal_money -= 1800`**
    (`@0x3E271` `sub +0x22, 0x708; sbb +0x24, 0`) and adds a per-type value to
    `PowerRecord +0xE` from table `DGROUP:0x9408` (`@0x3E283`). Post-independence
    the add is announced instead (`@0x3E28A`). **B.**

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
- `func_03E162` (file `0x3E162`) — REF budget driver: accrual `(8·diff+10)·2^era` (`@0x3E17C`), threshold **1800** (`@0x3E1C6`), composition ratios 3:1 reg:cav / 4:1 reg:art / 10:1 land:naval (`@0x3E1D0`), spend `+0x22 -= 1800` (`@0x3E271`). **B**
- `new_game_state_init` (file `@0x7569B`) — starting REF counts seeded from
  difficulty: `8·diff+15 / 5·(diff+1) / 6·diff+2 / 3·diff+2` (reg/cav/art/manowar);
  reproduces the 23/10/5/8 in-game counts at `diff=1`. **B**
- `docs/GAME_MANUAL.md` — REF grows over the game, deployed on independence. **R**

## 6. Open questions (TBD)

1. ~~Trace the writer of `0x53DA..0x53E0`.~~ **Done 2026-06-19** — `func_03CDA2`,
   `func_051EF4`, and the **driver `func_03E162`** (accrual + 1800-threshold spend +
   slot selection). **Royal-money consumer fully resolved.**
2. ~~**Difficulty scaling** of the accrual.~~ **Done** — `(8·diff+10)·2^(era gates)`
   (`func_03E162 @0x3E17C`).
3. ~~**Slot selection.**~~ **Done** — ratio rules 3:1 reg:cav, 4:1 reg:art, 10:1
   land:naval (`func_03E162 @0x3E1D0`).
4. The per-power gate byte `[0x53D2*0x13 − 0x6DA2]` and the per-unit thunk
   `0x181F:0x808` in the `func_051EF4`/`func_03CDA2` assembly path.
5. The `PowerRecord +0xE` per-type value added at purchase (table `DGROUP:0x9408`)
   and the aggregate `+0x32` strength rating's relation to the four counts.
