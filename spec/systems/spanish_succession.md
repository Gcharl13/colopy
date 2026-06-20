# War of the Spanish Succession (rival power withdrawal)

> **Layer 2 — Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.
> Re-grounded 2026-06-18 from the **real `@SUCCESSION` body** (the prior
> `heir_succession.md` invented a "king's heir" mechanic from an empty key).

**Overall confidence:** event text + **effect mechanics `BYTE_VERIFIED`** (`func_03C638`: power selection + map-tile/unit/colony ownership transfer + power-elimination); **trigger LOCATED** (`@0x02393A` end-game dispatcher, gated `[0x53D0]`/`[0x53D2]`; `tools/find_callers.py`); only the **firing-probability/schedule** that enqueues the event is `TBD`. · **Canonical primary:** `data_extracted/text/GAME_sections.json`
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
| which power is removed / beneficiary | **ceding = weakest eligible AI; receiving = strongest** — ranked by `score = 3·[0x9418+p] + 2·[0x9298+p] + 1·[0x9410+p]` over powers 0..3 (`@0x3C655/0x3C661/0x3C66B`), sorted `@0x3C68E`. `0x9298` = per-power **colony count**; `0x9418`/`0x9410` = strength components. | **BYTE_VERIFIED** | `func_03C638` selection loops `@0x3C64C..0x3C70E` |
| PowerRecord representation of a withdrawn power | the removed power's **AIPersonality controller byte `+0x543F := 2`** ("eliminated") `@0x3C91A`; its id stored to `[0x53D2]` `@0x3C922` | **BYTE_VERIFIED** | `func_03C638` aftermath |
| single-player gate | succession runs **only in single-player** — `test [0x5381],0x80; je …` skips to exit when the multiplayer bit is set `@0x3C63D` | **BYTE_VERIFIED** | `func_03C638` entry |

Real `@SUCCESSION` body:
> War of the Spanish Succession ends in Europe!
> {%STRING0}, ravaged by war, agrees to cede %STRING1
> to the {%STRING2}.  Treaty of Utrecht specifies that all
> {%STRING3} possessions in the New World now fall under {%STRING2} rule.

## 3. Formulas & rules
**Handler `func_03C638` (file `0x3C638`, `enter 0x24`, "SUCCESSION").** Single-player
only (entry gate `@0x3C63D`, above). It (1) ranks the 4 powers by strength and picks
the **weakest eligible AI** as the ceding power `[bp-0xa]` (`@0x3C6A4`) and the
**strongest** as the beneficiary `[bp-8]` (`@0x3C6DA`); (2) emits the `@SUCCESSION`
popup (`@0x3C76A`, handle `0x128C`), pre-binding `%STRING2`=beneficiary /
`%STRING3`=ceding power names (`lcall 0x181F:0xA1A`→`0x438` `@0x3C73C`/`@0x3C752`,
nation-name copy `@0x3C729`); then performs the **full asset transfer** (loser→winner):
- **Map-tile ownership** — nested loop over `[0x853C]`(height)×`[0x853A]`(width)
  rewriting each tile's owner nibble: `shr al,4; cmp ax,[bp-0xa]` then
  `and es:[bx],0xF; or es:[bx], (new<<4)` (`@0x3C7AF..0x3C80C`). **BYTE_VERIFIED.**
- **Units transfer** — loop over `[0x539C]` units: where `[UnitRecord+0x03]&0xF ==`
  ceding power, rewrite owner nibble `MOV byte[bx+0x3147], al` (`@0x3C81D`, stride
  `0x1C`, base `0x3144`) then refresh `lcall 0x181F:0x704`. **BYTE_VERIFIED.**
  (This is the `0x3C81D` write earlier mis-considered as combat "capture" — it is
  the succession ownership transfer, not combat.)
- **Colonies transfer** — loop over `[0x539E]` colonies (selected via `lcall
  0x181F:0x9E6`, current at `[0x8542]`, stride `0xCA`): where `[ColonyRecord+0x1A] ==`
  ceding power, `MOV byte[bx+0x1A], al` sets `owner_power_idx` to the beneficiary
  (`@0x3C8A0`) and zeroes `+0xC2`/`+0xC4` (`@0x3C8A5`). **BYTE_VERIFIED.**
- **Third nibble fixup** — loop over `[0x539A]` records via `[0x8D4A]`, owner nibble
  `[bx+5]` rewritten loser→winner (`@0x3C8CA..0x3C8FE`). **BYTE_VERIFIED.**
- **Aftermath** — ceding power's controller `[+0x543F] := 2` ("eliminated", `@0x3C91A`);
  `[0x53D2] := ceding-power id` (`@0x3C922`); state refresh `lcall 0x181F:0xE1C`.
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
1. ~~Trigger condition / timing.~~ **LOCATED 2026-06-20** — end-game dispatcher `@0x02393A`, gated on `[0x53D0]` (Bolívar SoL meter, init `func_0755CC`, +20/cap100 `@0x3BE64`) and `[0x53D2]<0`; not SoL/date. **Residual:** the firing-probability/schedule that *enqueues* this event id (the page-0x06 segment is mis-segmented; odds/RNG gate not isolated).
2. ~~Power-selection: which rival cedes, which receives.~~ **Resolved 2026-06-20** — weakest eligible AI cedes / strongest receives, ranked `3·[0x9418]+2·[0x9298]+[0x9410]` (sorted `@0x3C68E`); see §2/§3. **B.**
3. ~~Colony-transfer + power-removal mechanics in the data model.~~ **Resolved 2026-06-20** — map-tile/unit (`+0x3147`)/colony (`+0x1A`) owner-nibble rewrites + controller `+0x543F:=2`; see §3. **B.**

> **Not** to be confused with the diplomatic `@WITHDRAW`/`@MAYBEWITHDRAW`/
> `@NOTWITHDRAW` cluster, which is about **withdrawing military forces** during
> peace negotiation — see `spec/systems/diplomacy.md`.
