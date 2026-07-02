# European Diplomacy

> **Layer 2 — Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R. Body fully populated: meeting/parley dispatcher (`func_057F4E`), SIGNTREATY handler (`func_057DC0`), both relation matrices (`+0x34` war / `+0x40` treaty), AI willingness thresholds, cooldown, and privateer attribution are all BYTE_VERIFIED; the numbered open questions in §6 are resolved.

**Overall confidence:** **meeting handler `func_057F4E` + SIGNTREATY handler `func_057DC0` + both relation matrices (`+0x34` war / `+0x40` treaty, bit meanings incl. `0x08`=grievance / `0x80`=privateer) + AI willingness thresholds (attitude table `DGROUP:0x940C`, no-action cutoff `(attitude>>2) > demand` `@0x58C24`) + cooldown `BYTE_VERIFIED`** (2026-06-20). **Canonical primary:** `func_057F4E`/`func_057DC0`; `data_extracted/text/GAME_sections.json` treaty/war keys; `docs/GAME_MANUAL.md`.

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
- **Grievance-score DRIVER — CLOSED 2026-07-02 (full xref of `[0x941C]`):** the
  per-power score (`bx = power*2; [bx-0x6BE4]` = DGROUP `0x941C`, a 4-word array)
  has exactly two writers: **reset to 0** `@0x42142` (the power-init scrub, which
  also zeroes the `0x7304/0x6D68/0x6BF8/0x6BF4` scratch bytes) and **accrual**
  `@0x42335` — when a power's unit is destroyed, `score += value(unit)` where
  `value` is the per-unit call `0x181F:0x9C8` (overlay-resident, undecoded —
  implementations may proxy the combat weight, **R**), alongside saturating
  byte-adds into the `0x9180`/`0x918C`/`0x9572` per-slot alarm tables via the
  clamp-to-0xFF helper `@0x42126`. The confrontation evaluator compares two
  powers' scores **relatively** (`@0x3F0C5`/`@0x3F0CE`) before raising the
  pending-grievance bit (`@0x3F0D7`). **B (sites), R (value fn internals).**
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
  - **AI willingness thresholds — BYTE_VERIFIED (re-verified vs EXE 2026-06-25).**
    Attitude is a per-power byte at `DGROUP:0x940C` (displacement `[bx-0x6BF4]`,
    indexed by the power arg). (a) **No-action gate** `func_057F4E @0x58C24`: the AI
    declines to act when `(attitude>>2) > demand_score` **and** (`demand_score <= 0xC`
    **OR** `random_int(0,4) != 0`) — i.e. it only proceeds past the gate when
    `(attitude>>2) <= demand_score`, or when `demand_score > 0xC` and the
    `random_int(0,4)` roll hits 0 (`shr al,2` `@0x58C2B`; `cmp [bp-6],0xC` `@0x58C35`;
    `lcall 0x181f,0x4d4 (random)` `@0x58C42`). (b) **Final accept/affordability gate**
    `@0x58E1F`: struct ptr `[0x84FC]`, demand value (`[bp-0x66]`, sign-extended via
    `cdq`) is compared against the 32-bit gold field at `+0x2A/+0x2C` (`cmp [bx+0x2C],dx`
    `@0x58E1F`, `cmp [bx+0x2A],ax` `@0x58E29`). (c) **Target eligibility** `@0x57B1A`:
    requires turn `>= 0x28` (`cmp [0x538E],0x28` `@0x57B10`) **and** at least one of the
    two powers' attitude `>= 8` (`cmp byte ptr [bx-0x6BF4],8` `@0x57B1A`/`@0x57B24`).
    Plus the difficulty-scaled demand terms above.
- **Privateer attribution** (BYTE_VERIFIED, see §2 / §6.3): in the war-declaration resolver `func_03ECF0`, a unit-type guard `cmp byte ptr [bx+0x3146],0x10` (`@0x3F092`, type `0x10` = Privateer) routes a privateer attack to `or byte ptr [bx+si-0x77C4],0x80` (`@0x3F0A1`, `-0x77C4 = 0x883C` war-matrix) — setting the **hidden-attribution bit `0x80`** *instead of* the war bit `0x02`, so the aggression is not openly imputed to the controlling power (cleared/revealed `@0x58BE1`). **Blockade:** no naval-blockade mechanic exists (0 `blockad*` strings in `data_extracted/text/`); the nearest analogue is land-adjacency **SIEGE**, which restricts a besieged colony's production to military units. **B.**

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

## 6. Open questions
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
