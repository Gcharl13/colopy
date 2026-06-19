# European Diplomacy

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** **meeting/parley handler `func_057F4E` LOCATED + war-matrix mutations + treaty cooldown `BYTE_VERIFIED`** (2026-06-19); AI willingness + exact bit layout `TBD`. **Canonical primary:** `func_057F4E`; `data_extracted/text/GAME_sections.json` treaty/war keys; `docs/GAME_MANUAL.md`.

## 1. Purpose & behavior
The player coexists with three rival European powers (English/French/Spanish/Dutch set). They can sign treaties, declare war, make peace, and conduct hostile actions (privateering, blockades). Relations are tracked as boolean war/peace state between power pairs, surfaced through diplomatic dialogs. **RECONSTRUCTED** (manual + GAME.TXT keys).

## 2. State & data
- **War bit-matrix** at `DGROUP:0x883C` — a per-power-pair byte matrix, accessed in
  code as **`[bx+si - 0x77C4]`** (`-0x77C4 = 0x883C`; that displacement encoding is
  why a literal-`0x883C` grep found "no xrefs"). **BYTE_VERIFIED** (read `@0x582DC`;
  writes in `func_057F4E`). Known bits: **`0x02` = at war** (set `@0x58A7B`/`0x59A61`),
  `0x08` (set `@0x59AE9`), `0x80` cleared on peace `@0x58BE1`. Full per-pair indexing
  (which `bx`/`si` = which power) and the `0x08`/`0x80` meanings: **TBD**.
- **Treaty cooldown** at `[power*2 + 0x53C8]` (word) — set to `turn + 0x10`
  (`@0x58075`/`0x5914C`); a 16-turn re-parley lockout. **BYTE_VERIFIED.**
- PowerRecord base `DGROUP:0x8808`, stride 316 (0x13C), 4 powers; per-pair war state
  lives in the `0x883C` matrix, not in PowerRecord.

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
- AI peace/war **willingness** thresholds + the exact gold/tribute amounts: **TBD**.
- Privateer attribution, blockade: **TBD**.

> Corroborated by `viceroy_source/src/diplomacy/{meeting,relations,treaty}.c`
> (other branch); the offsets above are re-verified against this branch's EXE.

## 4. UI
Diplomatic dialogs use GAME.TXT keys: `@SIGNTREATY @HAVETREATY @DECLAREWAR @CANCELPEACE @PEACEMANLY @PEACEMEEK @OLDPEACEMANLY @OLDPEACEMEEK @WARMANLY @WARMEEK @WARN1 @WARN2 @WARN3`. **All BYTE_VERIFIED present.** See `docs/SESSION_UI_CATALOG.md`, `docs/UI_DIALOGS.md`.

## 5. Evidence
- `func_057F4E` (file `0x057F4E`) — meeting/parley dispatcher: human gate `@0x57F8C`, war-matrix bit `0x02` set `@0x58A7B` / `0x80` clear `@0x58BE1`, treaty cooldown `[0x53C8+power*2]=turn+0x10` `@0x58075`. **B**
- `notes/rulings/RULINGS.md` — war bit-matrix at `DGROUP:0x883C`; `func_03ECF0` re-attribution (NOT diplomacy). **A (ruling)**
- `data_extracted/text/GAME_sections.json` — treaty/war/peace dialog keys present. **B**
- `docs/GAME_MANUAL.md` — diplomacy function (rivals, treaties, war). **R**

## 6. Open questions (TBD)
0. ~~The `0x883C` matrix "has no code xrefs".~~ **CORRECTED 2026-06-19** — it does: the
   accessor uses `[bx+si-0x77C4]` (displacement form of `0x883C`), in `func_057F4E`.
   The prior grep searched the literal and missed it.
1. ~~Find the diplomacy dispatcher.~~ **Done** — `func_057F4E` (meeting/parley),
   byte-verified vs EXE. Remaining: the per-pair **bit layout** (`bx`/`si` → which
   power pair; `0x08`/`0x80` bit meanings).
2. Byte-trace AI peace/war **willingness** thresholds and treaty-term gold/tribute amounts.
3. Privateer attribution / blockade mechanics.
