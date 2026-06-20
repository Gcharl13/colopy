# European Diplomacy

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** **meeting handler `func_057F4E` + SIGNTREATY handler `func_057DC0` + both relation matrices (`+0x34` war / `+0x40` treaty, with bit meanings) + cooldown `BYTE_VERIFIED`** (2026-06-19); AI willingness thresholds + the `0x08`/`0x80` war-bits `TBD`. **Canonical primary:** `func_057F4E`/`func_057DC0`; `data_extracted/text/GAME_sections.json` treaty/war keys; `docs/GAME_MANUAL.md`.

## 1. Purpose & behavior
The player coexists with three rival European powers (English/French/Spanish/Dutch set). They can sign treaties, declare war, make peace, and conduct hostile actions (privateering, blockades). Relations are tracked as boolean war/peace state between power pairs, surfaced through diplomatic dialogs. **RECONSTRUCTED** (manual + GAME.TXT keys).

## 2. State & data
- **War bit-matrix** at `DGROUP:0x883C` = a **4×4 per-pair byte matrix embedded as
  `PowerRecord +0x34`** (base `0x8808+0x34`, row-stride `0x13C`). **BYTE_VERIFIED
  layout** (`@0x58A72`): the cell is `PowerRecord[subject] + 0x34 + target` — i.e.
  `imul si, subject, 0x13C; bx = target; [bx+si-0x77C4]` (`-0x77C4 = 0x883C`; that
  displacement form is why a literal-`0x883C` grep found "no xrefs"). **Bit catalogue
  — BYTE_VERIFIED (2026-06-20):** `0x01` = resolved/normalized relationship (set
  `@0x5318F`), **`0x02` = at war** (set `@0x58A7B`/`0x59A61`/`@0x3F0E8`, cleared
  `@0x5DE98`), **`0x08` = pending grievance** (set `@0x3F0D7`/`@0x59AE9` when the
  grievance-score `[bx−0x6BE4]` crosses a threshold; per-turn it transitions to bit
  `0x01` when its timer `+0x40` expires and `random_int(0,3)==0`, `@0x53165`),
  **`0x20` = peace-pending** (gate in SIGNTREATY `@0x57DF0`), **`0x40` = met/contacted**,
  **`0x80` = Privateer hidden-attribution** (set only under attacker-type `==0x10`
  guard `@0x3F0A1`, *instead of* the war bit; cleared/revealed `@0x58BE1`).
- **Treaty/relation-state matrix** — a **second** 4×4 byte matrix at
  `PowerRecord +0x40` (`DGROUP:0x8848`, same `0x13C` row-stride). **BYTE_VERIFIED bit
  meanings** (`func_057DC0`, the SIGNTREATY/treaty-state handler, verified vs EXE):
  bit **`0x02` = at war / hostile** (`test al,2 @0x57E05`), **`0x20` = peace/
  treaty-pending** (`@0x57DF0`), **`0x40` = existing treaty/alliance** (`@0x57E7D`).
  `func_057DC0` writes the matrix **symmetrically** (`matrix[A][B] = matrix[B][A]`,
  `@0x57EC5`/`@0x57ED0`): state `1` = treaty established, `0` = cleared/war; it emits
  `@SIGNTREATY` (`0x188D`) / `@CANCELTREATY` (`0x1898`) / `@DECLAREWAR` (`0x18A5`).
- **Treaty cooldown** at `[power*2 + 0x53C8]` (word) — set to `turn + 0x10`
  (`@0x58075`/`0x5914C`); a 16-turn re-parley lockout. **BYTE_VERIFIED.**
- PowerRecord base `DGROUP:0x8808`, stride 316 (0x13C), 4 powers.

> `func_03ECF0` was previously mislabeled "diplomatic_action_init" — per `RULINGS.md`
> it is the **per-unit confrontation/command AI evaluator**, **not** diplomacy.

## 3. Formulas & rules
**Meeting / parley dispatcher — `func_057F4E` (file `0x057F4E..0x059B3C`, page 0x0F,
ENTER 0xD6). BYTE_VERIFIED (located + key mutations, 2026-06-19; verified vs EXE).**
Runs when two powers meet and exchange treaty / peace / tribute / war. Structure:
- **human-only gate** `@0x57F8C` (`cmp [bp+6],4; imul bx,*0x34; cmp [bx+0x543F],0`).
- **dialog** via `0x1A1F:0x688 → func_06F61C`; option tree via `func_057A3A`; topic
  keys (all byte-verified pushes) include `PIRACY/SIEGES/TRIBUTE/WANTSTUFF/PROVOKE/
  WARMANLY/WORTHY/PEACE/OLDPEACE/PEACEUSA/GIVECASH/GIFTS/THREATS/WITHDRAW`.
- **declare war:** set war-matrix bit `0x02` (`@0x58A7B`); **make peace:** clear bit
  `0x80` (`@0x58BE1`) + treaty-bit clear (`rel_clear_event 0x40`); **sign treaty:**
  treaty-bit set (`rel_apply_event 0x40`, `0x181F:0xA06`), **gold transfer** on a paid
  treaty (subtract from power-b gold), per-unit ownership transfer (UnitRecord stride
  `0x1C`), and the cooldown write above.
- **Difficulty-scaled demand terms — BYTE_VERIFIED (2026-06-20)** (within
  `func_057F4E`, `diff=[0x53A6]`):
  - **AI war/refusal grace period** = `10·(10 − diff)` turns vs `[0x538E]`
    (100/90/80/70/60 — lower difficulty = longer peace) (`@0x58374`).
  - **Tribute/demand value** scaled `value · 10·(diff+8) / 100` (×0.8…×1.2)
    (`@0x583A0`); a flat **demand surcharge `+= 500·(diff+1)`** (`@0x5842B`); a
    `(diff+1)·value >> 3` term feeds a 0..400 roll (`@0x58409`); an
    attitude/demand component `+= (diff−2)·meeting_val` (`@0x58580`).
  - **AI action probability** gate `random_int(1000) < 200·diff + 100` (10%…90%)
    (`@0x58315`). See `spec/systems/difficulty.md` §3.
  The remaining **non-difficulty** AI willingness thresholds (attitude/relationship
  cutoffs that decide *whether* to offer peace vs war) are still **TBD**.
- Privateer attribution, blockade: **TBD**.

> Corroborated by `viceroy_source/src/diplomacy/{meeting,relations,treaty}.c`
> (other branch); the offsets above are re-verified against this branch's EXE.

## 4. UI
Diplomatic dialogs use GAME.TXT keys: `@SIGNTREATY @HAVETREATY @DECLAREWAR @CANCELPEACE @PEACEMANLY @PEACEMEEK @OLDPEACEMANLY @OLDPEACEMEEK @WARMANLY @WARMEEK @WARN1 @WARN2 @WARN3`. **All BYTE_VERIFIED present.** See `docs/SESSION_UI_CATALOG.md`, `docs/UI_DIALOGS.md`.

## 5. Evidence
- `func_057F4E` (file `0x057F4E`) — meeting/parley dispatcher: human gate `@0x57F8C`, war-matrix bit `0x02` set `@0x58A7B` / `0x80` clear `@0x58BE1`, treaty cooldown `[0x53C8+power*2]=turn+0x10` `@0x58075`; difficulty-scaled demand terms `@0x58374`/`@0x583A0`/`@0x5842B`/`@0x58315`. **B**
- `func_057DC0` (file `0x057DC0`) — SIGNTREATY/treaty-state handler: symmetric `+0x40` matrix write `@0x57EC5`/`@0x57ED0`; bits `0x02`/`0x20`/`0x40` tested `@0x57E05`/`@0x57DF0`/`@0x57E7D`; keys `@SIGNTREATY`/`@CANCELTREATY`/`@DECLAREWAR`. **B**
- `notes/rulings/RULINGS.md` — war bit-matrix at `DGROUP:0x883C`; `func_03ECF0` re-attribution (NOT diplomacy). **A (ruling)**
- `data_extracted/text/GAME_sections.json` — treaty/war/peace dialog keys present. **B**
- `docs/GAME_MANUAL.md` — diplomacy function (rivals, treaties, war). **R**

## 6. Open questions (TBD)
0. ~~The `0x883C` matrix "has no code xrefs".~~ **CORRECTED 2026-06-19** — it does: the
   accessor uses `[bx+si-0x77C4]` (displacement form of `0x883C`), in `func_057F4E`.
   The prior grep searched the literal and missed it.
1. ~~Find the diplomacy dispatcher + per-pair bit layout.~~ **Done** — `func_057F4E`
   (meeting) + `func_057DC0` (SIGNTREATY); war matrix `+0x34` (bit `0x02`=war), treaty
   matrix `+0x40` (`0x02`=war/`0x20`=peace-pending/`0x40`=treaty), all byte-verified.
   **War-matrix `0x08`/`0x80` bits now resolved** (§2: `0x08`=grievance, `0x80`=privateer).
2. ~~Byte-trace AI peace/war **willingness** thresholds.~~ **Done 2026-06-20** — the
   per-power **attitude table is `DGROUP:0x940C`** (byte/power, adjusted on
   unit-ownership transfer by `UnitRecord +0x1F` `@0x5DC76`/`@0x5DC87`). Cutoffs:
   `func_057F4E @0x58C24` — the AI takes no action when `(attitude>>2) > demand_score`
   **and** `demand_score > 12 (0xC)` **and** `random_int(0,4)!=0`; the final accept
   gate is an affordability check `demand vs PowerRecord +0x2C gold` (`@0x58E1F`).
   Target-selection requires **attitude ≥ 8** (`@0x57B1A`). Plus the difficulty-scaled
   demand terms (§3). **B.**
3. ~~Privateer attribution / blockade.~~ **Done 2026-06-20** — **Privateer** (unit
   type `0x10`) hidden attribution is in the war-declaration resolver `func_03ECF0`:
   `@0x3F092 cmp [bx+0x3146],0x10; jne` → `@0x3F0A1 or war_matrix,0x80` (sets the
   hidden bit instead of declaring war). **No naval blockade mechanic exists** (0
   "blockad*" strings; the closest is land-adjacency **SIEGE**, which restricts a
   besieged colony's production to military units). **B.**
