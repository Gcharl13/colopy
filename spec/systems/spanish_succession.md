# War of the Spanish Succession (rival power withdrawal)

> **Layer 2 — Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.
> Re-grounded 2026-06-18 from the **real `@SUCCESSION` body** (the prior
> `heir_succession.md` invented a "king's heir" mechanic from an empty key).

**Overall confidence:** event text + **effect mechanics `BYTE_VERIFIED`** (`func_03C638`: unit + colony ownership transfer); **trigger LOCATED** (`@0x02393A` end-game dispatcher, gated `[0x53D0]`/`[0x53D2]`; `tools/find_callers.py`). · **Canonical primary:** `data_extracted/text/GAME_sections.json`
`@SUCCESSION`; `data_extracted/text/LABELS_sections.json` `@MISC`.

## 1. Purpose & behavior
A scripted historical event: the **War of the Spanish Succession** ends in Europe
(Treaty of Utrecht). A war-ravaged European rival **cedes its New-World
possessions to another power** — in game terms **one European rival is removed
from the game** and its colonies pass to the beneficiary power. The removed power
is thereafter shown as **"(Withdrawn from New World)"**.

## 2. State & data
| Item | Meaning | Tier | Evidence |
|------|---------|------|----------|
| `GAME @SUCCESSION` | event announcement (real body, below) | **BYTE_VERIFIED** | `GAME_sections.json` |
| `LABELS @MISC` → "(Withdrawn from New World)" | status label for the removed power | **BYTE_VERIFIED** | `LABELS_sections.json` |
| which power is removed / beneficiary | `%STRING0`/`%STRING3` (ceding) → `%STRING2` (receiving) | **TBD** | selection logic not traced |
| PowerRecord representation of a withdrawn power | how removal is flagged (active bit / colonies reassigned) | **TBD** | not traced |

Real `@SUCCESSION` body:
> War of the Spanish Succession ends in Europe!
> {%STRING0}, ravaged by war, agrees to cede %STRING1
> to the {%STRING2}.  Treaty of Utrecht specifies that all
> {%STRING3} possessions in the New World now fall under {%STRING2} rule.

## 3. Formulas & rules
**Handler `func_03C638` (file `0x3C638`, "SUCCESSION").** Announces via the
`@SUCCESSION` popup (`@0x3C76A`), then performs the **power absorption**:
- **Units transfer** — a loop reassigns each affected unit's owner nibble
  `MOV byte[UnitRecord +0x01], al` (`@0x3C81D`, `[bx+0x3147]`). **BYTE_VERIFIED.**
  (This is the `0x3C81D` write earlier mis-considered as combat "capture" — it is
  the succession ownership transfer, not combat.)
- **Colonies transfer** — `MOV byte[ColonyRecord +0x1A], al` (`@0x3C8A0`) sets each
  ceded colony's `owner_power_idx` to the beneficiary. **BYTE_VERIFIED.**
- Self/active-power global `[0x53D2]` is updated (`@0x3C922`).
- **Trigger — LOCATED 2026-06-20** (via `tools/find_callers.py`, the overlay
  call-graph resolver). `func_03C638`'s thunk is reached as **`lcall 0x191F:0x0364`**
  (not the `0x181F:0x1364` a naive file-offset guess gives), called from the
  **end-game/revolution dispatcher at `@0x02393A`**. The succession branch is gated by:
  `[0x53D0]` — a counter **clamped to 75 (`0x4B`)** (`@0x02391C`/`@0x02392A`) — and
  `[0x53D2]` (the seceding/tory power id) being `< 0` (`@0x023930`), with the
  `[0x5381]` bit-7 **once-flag** routing between the succession and the
  `[0x5382]`-gated revolution handlers. So it is part of the **revolution/end-game**
  state machine, **not** SoL-driven (confirming the §below ruling).
  - **`[0x53D0]` identified:** it is initialized at new-game (`func_0755CC @0x75620`)
    and bumped **`+= 20` (capped at 100)** when **Simón Bolívar (FF #18)** is acquired
    (`func_03BC42 @0x3BE64`, gated to a human European power) — i.e. it is Bolívar's
    accumulating SoL-boost meter. The dispatcher clamps it to 75 (`@0x02392A`) and
    routes on whether it has reached that threshold, so **the succession branch is
    taken in the low-`[0x53D0]` / `[0x53D2] < 0` (no seceding power) state** — the
    pre-revolution path — while the high state feeds the revolution handlers.
- **Not SoL-driven (2026-06-20):** the full handler body (`0x3C638..0x3C932`)
  contains **no read of rebel-sentiment `PowerRecord +0x02`, no `50` (`0x32`) compare,
  and no year check**. Victim selection ranks the 4 powers on the strength tables
  `0x9418`/`0x9298`/`0x9410` and eliminates the weakest eligible — a power-strength
  merge, gated only by `[0x5381]` bit 7 (enable/once flag). The 50%-SoL threshold is
  the unrelated `REBELMAJORITY` colony status (`func_02D658 @0x2DB29`), not this event.

## 4. UI
Announcement popup using `@SUCCESSION` (with `%STRING0..3` substitution) via the
shared popup framework (`spec/ui/popups.md`). The removed power renders as
"(Withdrawn from New World)" in the relevant reports.

## 5. Evidence
- `data_extracted/text/GAME_sections.json` — `@SUCCESSION` full body. **B**
- `data_extracted/text/LABELS_sections.json` — `@MISC` "(Withdrawn from New World)". **B**

## 6. Open questions (TBD)
1. ~~Trigger condition / timing.~~ **LOCATED 2026-06-20** — end-game dispatcher `@0x02393A`, gated on `[0x53D0]` (Bolívar SoL meter, init `func_0755CC`, +20/cap100 `@0x3BE64`) and `[0x53D2]<0`; not SoL/date. Residual: full dispatcher state-machine semantics.
2. Power-selection: which rival cedes, which receives.
3. Colony-transfer + power-removal mechanics in the data model.

> **Not** to be confused with the diplomatic `@WITHDRAW`/`@MAYBEWITHDRAW`/
> `@NOTWITHDRAW` cluster, which is about **withdrawing military forces** during
> peace negotiation — see `spec/systems/diplomacy.md`.
