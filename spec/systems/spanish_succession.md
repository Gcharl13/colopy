# War of the Spanish Succession (rival power withdrawal)

> **Layer 2 — Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.
> Re-grounded 2026-06-18 from the **real `@SUCCESSION` body** (the prior
> `heir_succession.md` invented a "king's heir" mechanic from an empty key).

**Overall confidence:** event text + status label `BYTE_VERIFIED`; trigger &
effect mechanics `TBD`. · **Canonical primary:** `data_extracted/text/GAME_sections.json`
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
- **Trigger:** `TBD` — date/condition not byte-traced (historically the Treaty of
  Utrecht is 1713; whether the game gates on a year or a random event is unknown).
- **Effect:** the ceding power's colonies transfer to the beneficiary; the ceding
  power is removed. Byte mechanics `TBD`.

## 4. UI
Announcement popup using `@SUCCESSION` (with `%STRING0..3` substitution) via the
shared popup framework (`spec/ui/popups.md`). The removed power renders as
"(Withdrawn from New World)" in the relevant reports.

## 5. Evidence
- `data_extracted/text/GAME_sections.json` — `@SUCCESSION` full body. **B**
- `data_extracted/text/LABELS_sections.json` — `@MISC` "(Withdrawn from New World)". **B**

## 6. Open questions (TBD)
1. Trigger condition / timing of the event (date gate vs random).
2. Power-selection: which rival cedes, which receives.
3. Colony-transfer + power-removal mechanics in the data model.

> **Not** to be confused with the diplomatic `@WITHDRAW`/`@MAYBEWITHDRAW`/
> `@NOTWITHDRAW` cluster, which is about **withdrawing military forces** during
> peace negotiation — see `spec/systems/diplomacy.md`.
