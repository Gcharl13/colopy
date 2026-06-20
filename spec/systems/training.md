# Colonist Training & Promotion

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** job/profession roster `BYTE_VERIFIED` (present); **expertise
field + `@JOB` columns + native-learn & school rulesets** `BYTE_VERIFIED`; the
per-turn school *teaching rate* still `TBD`. **Canonical primary:**
`data_extracted/text/NAMES_sections.json` `@JOB`/`@CLASS`;
`data_extracted/text/GAME_sections.json` `@LEARN*`/`@SCHOOL1`/`@NOTEACHER`;
`docs/GAME_MANUAL.md` (player-aid skill chart, p.3); `VICEROY.EXE` `func_05B2C2`
(expertise demotion).

## 1. Purpose & behavior
Colonists gain expertise three ways: **schools** (a skilled colonist teaches the unskilled), **native learning** (live in a village to learn a local skill such as tobacco planting or fur trapping), and **veterancy** (soldiers become Veteran Soldiers through combat). Education also advances class: petty criminals → indentured servants → free colonists → masters. **RECONSTRUCTED** (manual §"Education"/"Indian Lore").

## 2. State & data
A unit's **expertise / profession-class** is held in **`UnitRecord +0x17`**
(`0x315B`, values **`0x13..0x1C`** = the expert/veteran classes). **BYTE_VERIFIED**
— read/written by the combat demotion ladder `func_05B2C2` (`@0x05B570`
`cmp byte[bx+0x315B],0x15` → `@0x05B577` `mov …,0x1C`; `@0x05B60E` `cmp …,0x18`),
the combat promotion `@0x05C7DD`, the mercenary veteran stamp `@0x03D835`, and ~34
write sites image-wide. ⚠ **Correction:** the prior `+0x15` was the *value* `0x15`
(Veteran Soldier) mistaken for an offset — there is no expertise byte at `+0x15`;
`unit.h` (BYTE_VERIFIED 2026-05-28) maps `+0x17` here. (A separate `+0x07` byte,
init `0x2D`, is a different profession/assignment datum — not the expertise class.)

`@JOB` (NAMES, **BYTE_VERIFIED present**, 28 rows) — `base_name, expert_name, tier, number`:

| Job | Expert form | tier | num |
|-----|-------------|------|-----|
| Farmer | Expert Farmers | 1 | 1100 |
| Sugar/Tobacco/Cotton Planter | Master … Planters | 2 | -1 |
| Fur Trapper | Expert Fur Trappers | 1 | -1 |
| Lumberjack | Expert Lumberjacks | 1 | 700 |
| Ore/Silver Miner | Expert … Miners | 1 | 600/900 |
| Fisherman | Expert Fishermen | 1 | 1000 |
| Distiller/Tobacconist/Weaver/Fur Trader | Master … | 2 | 1100/1200/1300/950 |
| Carpenter/Blacksmith/Gunsmith | Master … | 1/2 | 1000/1050/850 |
| Preacher | Firebrand Preachers | 3 | 1500 |
| Statesman | Elder Statesmen | 3 | 1900 |
| Teacher | Expert Teachers | 4 | -1 |
| Colonist | Free Colonists | 4 | -1 |
| Pioneer | Hardy Pioneers | 1 | 1200 |
| Soldier | Veteran Soldiers | 2 | 2000 |
| Scout | Seasoned Scouts | … | … |

**`@JOB` columns decoded** (cross-checked against the manual player-aid skill chart,
`docs/GAME_MANUAL.md` p.3 line 5338):
- **Column 3 (tier 1/2/3/4) = the minimum school level required to teach the skill**:
  **1 = Schoolhouse (S)**, **2 = College (C)**, **3 = University (U)**, **4 = base /
  not school-taught** (Teacher, Free Colonist). Verified by the chart: Expert Farmer
  =1=S, Master Distiller/Weaver/Veteran Soldier=2=C, Elder Statesman/Firebrand
  Preacher/Jesuit Missionary=3=U. **B** (data + manual agree).
- **Column 4 (number)** = the expert's **gold value** (the Europe recruit/train cost
  basis for that specialist; e.g. Veteran Soldier 2000, Elder Statesman 1900,
  Master Weaver 1300). Same value scale as `@CLASS`. **R** (semantics manual-inferred).

`@CLASS` 8-tier ladder (Petty Criminals … Educated Elite) governs promotion-by-education. **BYTE_VERIFIED present.**

## 3. Formulas & rules

### Schoolhouse teaching — rules **B** (text), per-turn rate **TBD**
- **Only a colonist who has mastered a profession may teach** (`@NOTEACHER`:
  *"Only colonists who have mastered a profession may teach."*).
- A **Schoolhouse holds one teacher** at a time (`@SCHOOL1`: *"…faculty of only one
  teacher at a time"*; manual: build at population 4). Schoolhouse → College →
  University upgrades raise the **tier cap**: a building of level *L* can teach only
  professions whose `@JOB` column-3 tier `≤ L` (S/C/U = 1/2/3, §2). Teaching copies
  the teacher's expertise (`+0x17`) onto a student colonist.
- **Building ids — BYTE_VERIFIED:** Schoolhouse `0x0C`, College `0x0D`, University
  `0x0E` (bits 12/13/14 in `ColonyRecord +0x84`/`+0x8A` building bitmaps).
- **AI-side school promotion — BYTE_VERIFIED (2026-06-20):** in the AI economic turn
  `func_051EF4`, a school gate `@0x052959` (counts schoolhouse id `0x0C` via thunk
  `0x181F:0x8BC`, gated on the AI phase flag `[0x5382]&1`; **no school ⇒ skip** the
  block `@0x05296D jmp 0x52D3D`), then promotes a pooled colonist by copying a class
  byte into `UnitRecord +0x315B` (`@0x052710`, target class `0x1C`) — **probabilistic
  per turn** (`random_int` rolls `@0x05260E/@0x05262B`) with a gold cost debited from
  `PowerRecord +0x2A`. So the AI path is a per-turn *chance*, not a fixed counter.
- The **human-side deterministic per-turn teaching rate / turns-to-graduate** byte
  mechanic remains **TBD** — no distinct human teaching function survives in the
  annotated disasm (likely folded into a UI-driven teacher-assignment flow whose
  message-key call sites didn't survive the xref artifacts; closest anchors
  `func_0317CC`/`func_0318D2` colony-screen profession code).

### Native learning ("live among the Indians") — ruleset **B**, grant site **TBD**
From the `@LEARN*` bodies + the player-aid chart (skills marked `*` are
Indian-learnable):
- **Learnable skills are the outdoorsman/gathering experts only** — Expert
  Farmer / Fisherman / Fur Trapper / Silver Miner, Master Sugar / Cotton / Tobacco
  Planter, Seasoned Scout (the `*` rows). Manufacturing (craftsmen) skills are
  **not** Indian-learnable.
- **Petty Criminals cannot learn** (`@LEARNCRIMINAL`); the unskilled learn slowly
  (`@LEARNSLOW`/`@LEARNSTAY`). A colonist who is **already a master is refused**
  (`@LEARNMASTER` *"we can only teach new skills to colonists who…"*); **Indian
  converts** already know native ways (`@TEACHCONVERT`).
- **Each village teaches only once** (`@LEARNALREADY`).
- On success (`@LEARNDONE` *"become a master {%STRING1}"*) the colonist's expertise
  `+0x17` is set to the village's skill. **Grant site BYTE_VERIFIED (2026-06-20):**
  `@0x04A782` writes the learned profession into `UnitRecord +0x315B`, then
  `@0x04A78A or [bx+3],2` stamps the **"already taught" flag = NativeSettlement +0x03
  bit `0x02`** (`[0x8D4A]` = active settlement) — the byte mechanism behind
  `@LEARNALREADY` (each village teaches once). **B.**
- **Slow-learner success roll — BYTE_VERIFIED (2026-06-20):** for an unskilled
  colonist (Free Colonist `0x1C` / Indentured `0x19`; Criminal `0x1A` refused), the
  learn succeeds iff `random_int(1,1000) ≥ 200·difficulty + 100` (`@0x4A72C`:
  `random_int(1,1000)` then `al=0xC8; mul [0x53a6]; add 0x64`). So **P(success) ≈
  (900 − 200·diff)/1000** = **90 / 70 / 50 / 30 / 10 %** for Discoverer…Viceroy; on
  failure `@LEARNSLOW` is shown and the colonist stays. **B.**

### Veteran promotion / demotion on combat — **B** (demotion ladder)
The combat consequence applier `func_05B2C2` adjusts the expertise `+0x17`:
a **Veteran Soldier (`0x15`) is demoted to `0x1C`** on a loss
(`@0x05B570→0x05B577`), with a parallel `0x18` branch (`@0x05B60E`); the unit
*type* `+0x02` is demoted in lockstep (Dragoons→Soldiers etc., `@0x05B5B3`). Soldiers
gain Veteran status by winning (manual); the win-promotion write is at `@0x05C7DD`.
**BYTE_VERIFIED** (ladder); exact win-promotion probability **TBD**.

## 4. UI
Surfaces in the colony screen (assign job) and education building tooltips. See `spec/systems/colony.md`, `docs/SESSION_UI_CATALOG.md`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@JOB` (28 rows), `@CLASS` (8). **B (present)**
- `data_extracted/text/GAME_sections.json` — `@NOTEACHER`, `@SCHOOL1`, `@LEARNCRIMINAL`/
  `@LEARNMASTER`/`@LEARNALREADY`/`@LEARNSLOW`/`@LEARNSTAY`/`@LEARNDONE`/`@TEACHCONVERT`. **B**
- `VICEROY.EXE` `func_05B2C2` (`@0x05B570`/`@0x05B577`/`@0x05B60E`) — expertise `+0x17`
  demotion ladder; `@0x05C7DD` promotion write; `@0x03D835` veteran stamp. **B**
- `viceroy_source/include/unit.h` — `UnitRecord +0x17` (`0x315B`) vet/profession type
  `0x13..0x1C` (supersedes the old `+0x15`). **B**
- `docs/GAME_MANUAL.md` — player-aid skill chart (col-3 school tiers S/C/U, `*` =
  Indian-learnable), §"Education", "Indian Lore". **B/R**

## 6. Open questions (TBD)
1. Byte-trace the **per-turn school teaching rate** (turns-to-graduate; who-teaches-
   whom selection) — entry: the colony-turn update that writes `UnitRecord +0x17`
   from a teacher; gate on the building-tier bitmap (`ColonyRecord +0x8A`, see `colony.md`).
2. Byte-trace the **native-learning grant** site (`@LEARNDONE` path) and its
   per-class success roll (`@LEARNSLOW` semantics).
3. Confirm the **veteran win-promotion probability** at `func` near `@0x05C7DD`.
4. Confirm `@JOB` column-4 = Europe recruit/train gold cost (vs a pure score value).
