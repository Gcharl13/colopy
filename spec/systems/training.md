# Colonist Training & Promotion

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** job/profession roster `BYTE_VERIFIED` (present); **expertise
field + `@JOB` columns + native-learn (grant+roll) + school rulesets + combat
veteran promotion (Washington-auto / `random_int(1,S)≤winner_str`)** `BYTE_VERIFIED`;
the human-side per-turn school *teaching rate* is now `BYTE_VERIFIED` too
(`func_02D658`; 4/6/8 turns by skill class — §3). **Canonical primary:**
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

### Schoolhouse teaching — **B** (located in `func_02D658`, the per-colony turn processor)
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
- **Human-side per-turn teaching — BYTE_VERIFIED 2026-06-21 (correcting the earlier
  "UI-driven / not statically located" claim).** It is **not** a separate UI routine: it
  runs inside **`func_02D658`** — the per-colony turn processor that executes for *every*
  colony regardless of owner — in the block `@0x02DDB4..0x02E012`, which emits
  **`@TRAINPROFESSION`** (handle `0xE0F`, `@0x02DFA8`) on graduation and **`@TRAINFAIL`**
  (`0xDE7`, `@0x02E008`) when a teacher has no eligible student. The mechanic:
  - **Faculty cap = 3** teachers per colony (`cmp [bp-0x6C], 3` `@0x02DE5B`) — i.e.
    Schoolhouse 1 / College 2 / University 3 (matches `@SCHOOL1`/`@COLLEGE2`/`@UNIV3`).
  - **Eligible students** = unit types `0x13`/`0x19`/`0x1A`/`0x1C` (`@0x02DE2B..0x02DE3D`)
    (free colonist + servant/criminal/petty tiers); **teacher** = job code `0x12`
    (`cmp [bp-0xC0], 0x12` `@0x02DE51`).
  - **Turns-to-graduate = 4 / 6 / 8**, selected by the profession's **skill class**
    read from the unit-type attribute table at **DGROUP `0x8EA6`** (`mov ax,[bx-0x715A]`,
    `bx = type·8`, `@0x02DE75`): class `1 → 4`, class `2 → 6`, class `3 → 8` turns
    (`mov [bp-0xB2], 4/6/8` `@0x02DDB4`/`@0x02DE98`/`@0x02DE8E`); class `≥ 4` ⇒ the
    profession is **not teachable** (`@0x02DE7D cmp ax,4; jl`).
  - A **per-student teach counter** is read each turn (`0x181F:0xD1C` `@0x02DDFE`),
    **incremented** (`@0x02DE19`), written back (`0x181F:0xA7E` `@0x02DDDD`), and **reset
    to 0 on graduation** (`@0x02DDD1`); graduation fires when the counter reaches the
    4/6/8 threshold (`cmp [bp-0x7E], [bp-0xB2]; jl skip` `@0x02DDBA`).
  - On graduation a **student below expert is promoted one tier** (criminal `0x1A`→servant,
    servant `0x19`→colonist `0x1C`, `@0x02DF00`/`@0x02DF35`); a **free colonist learns the
    teacher's profession** outright (`0x181F:0xCAE` set-type `@0x02DF70`). Teacher→student
    pairing picks a **random student** (`random_int`, `0x181F:0x4D4` `@0x02DEC5`).

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
*type* `+0x02` is demoted in lockstep (Dragoons→Soldiers etc., `@0x05B5B3`).

**Win-promotion — BYTE_VERIFIED (2026-06-20).** On a win the promotion of the
victor (`bp+6`) gates two ways:
- **With George Washington (Founding Father #11)** — `func 0x181F:0x7B4(0xB, owner)`
  (`@0x5C758`) returns nonzero → the roll is **skipped and promotion is automatic**.
- **Otherwise** — `random_int(1, S) ≤ winner_strength` (`@0x5C764`: `random_int(1,
  [bp-4])` then `cmp ax,[bp+0xA]; jle` proceed, else no promotion). So
  **P(promote) = winner_strength / S** (`S` = the combat strength sum from
  `func_05CA7E`, `combat.md`).
On promotion the class ladder `func_05E714` maps the current `+0x315B` to its next
rank and writes it back (`@0x5C7DD`); at the soldier ceiling the **unit *type*
`+0x3146`** advances instead (Soldier `1` → **Continental Army `9`**, else `→ 7`,
`@0x5C7C3`/`@0x5C7CE`), and only for an active European owner (`owner<4`,
controller `+0x543F==0`). **B.**

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
1. ~~Byte-trace the **human-side per-turn school teaching rate** (turns-to-graduate;
   who-teaches-whom selection).~~ **DONE 2026-06-21 — it WAS statically located** (the
   earlier "UI-driven / not in the disasm" conclusion was wrong; I had searched the
   colony-*screen* code `0x31000..0x33000`, but teaching runs in the colony *turn*
   processor). It is in **`func_02D658` `@0x02DDB4..0x02E012`**: faculty cap 3, students
   types `0x13/0x19/0x1A/0x1C`, teacher job `0x12`, **turns-to-graduate 4/6/8 by skill
   class** (unit-type table DGROUP `0x8EA6`), per-student counter via `0x181F:0xD1C`/`0xA7E`,
   promote-one-tier or learn-profession on graduation, emits `@TRAINPROFESSION`/`@TRAINFAIL`
   (§3). Tier → **B**. Found via the `@TRAINPROFESSION` emitter (`tools/rtlink/event_emitters.json`).
2. ~~Byte-trace the **native-learning grant** site (`@LEARNDONE` path) and its
   per-class success roll (`@LEARNSLOW` semantics).~~ **Done 2026-06-20** — grant
   `@0x04A782`, "taught" flag `NativeSettlement +0x03` bit `0x02`, slow-learner roll
   `random_int(1,1000) ≥ 200·diff+100` (§3). **B.**
3. ~~Confirm the **veteran win-promotion probability** at `func` near `@0x05C7DD`.~~
   **Done 2026-06-20** — `random_int(1,S) ≤ winner_strength` (`@0x5C764`), or
   **automatic with Washington FF#11** (`@0x5C758`); ladder `func_05E714`, type
   bump Soldier→Continental (§3). **B.**
4. ~~Confirm `@JOB` column-4 = Europe recruit/train gold cost.~~ **Done 2026-06-20** —
   the **NAMES.TXT legend itself** (above `@JOB`) names the columns
   *"name, expert-name, student level (4 = unlearnable), **cost in europe**"*; col-4 =
   the Europe recruit/purchase gold cost (`-1` = not recruitable). **B** (primary legend).
