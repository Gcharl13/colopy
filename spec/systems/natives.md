# Native Relations

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** NativeSettlement base/stride + a few offsets + **mission-conversion mechanism (incl. RNG bound 0..15) + CHIEFKILL treasure roll + native-raid dispatch** `BYTE_VERIFIED`; attitude/trade logic + the roll→gold conversion `RECONSTRUCTED`/`TBD`. **Canonical primary:** `docs/DATA_MODEL.md` NativeSettlement; `data_extracted/text/NAMES_sections.json` `@TRIBES`/`@ATTITUDE`/`@ATTITUDINAL`/`@LEVELS`/`@MISSION`; `data_extracted/text/GAME_sections.json` native keys.

## 1. Purpose & behavior
Native tribes occupy settlements the player can trade with, send missionaries to, learn skills from, demand tribute from, or attack. Tribe attitude escalates Content → Uneasy → Restless → Angry → War as the colonial presence grows, unless soothed by trade and tribute. Razing a settlement (CHIEFKILL) can yield treasure scaled by its population. **RECONSTRUCTED** (manual §"Indian Lore" + byte-cited CHIEFKILL).

## 2. State & data
`NativeSettlement` base `DGROUP:0x54EC`, **stride 18 (0x12)**.

| Field | Type | Meaning | Tier | Evidence |
|-------|------|---------|------|----------|
| +0x00 | u8 | `map_x` | **BYTE_VERIFIED** (runtime) | `docs/DATA_MODEL.md`: matches dispersal templates |
| +0x01 | u8 | `map_y` | **BYTE_VERIFIED** (runtime) | `docs/DATA_MODEL.md` |
| +0x02 | u8 | tribe / owner (per task hint) | **TBD — not yet traced** | task hint; not confirmed in DATA_MODEL excerpt |
| +0x03 | u8 | flags (per task hint) | **TBD — not yet traced** | task hint |
| +0x04 | u8 | `population` (size byte, feeds CHIEFKILL) | **BYTE_VERIFIED** | `docs/DATA_MODEL.md` §CHIEFKILL: size_byte from `NativeSettlement[+0x04]` |
| +0x08 | u8 | per-nation `last_bought` | **ANCHOR_VERIFIED** | `docs/DATA_MODEL.md` |

`@TRIBES` (NAMES, **BYTE_VERIFIED present**): the 8 active tribes carry `name, adj, gift-good, level, sprite#`: Incas(Jewelled Relics,3,97), Aztecs(Gold Bars,2,149), Arawaks(1,54), Iroquois(1,87), Cherokee(1,67), Apache(0,111), Sioux(0,118), Tupi(0,71); plus name-only reserve tribes.

`@ATTITUDE` (5): Content, Uneasy, Restless, Angry, War. `@ATTITUDINAL` (5): Extremely, Very, Rather, Somewhat, Slightly. `@LEVELS` (5): Semi-Nomadic/Camp, Agrarian/Village, Advanced/City, Civilized/City, `<Any>`/Capital. `@MISSION` (4): mission-name prefixes. **All BYTE_VERIFIED present.**

## 3. Formulas & rules
- **Raze treasure (CHIEFKILL)** — `func_04A7CA` (file `0x4A7CA`). **Roll mechanism
  BYTE_VERIFIED** (2026-06-19): the attacker's class byte `UnitRecord +0x15 == 0x16`
  (**Seasoned Scout**) sets a bonus flag `scout∈{0,1}` (`@0x4A7D9`); the settlement
  **size** `sz` is fetched via thunk `0x181F:0x30C` (`@0x4A7F2`, `[bp-0x22]`). Then:
  - **normal path** (`sz < 0x4B = 75`): treasure roll = `random_int(0, 40·scout + 100)`
    (`@0x4A81A`: `bp-2 = scout·0x28 + 0x64`, `@0x4A827` roll); for `sz ≥ 0x19 = 25`,
    the roll is **rejected and re-rolled while `sz/4 ≥ roll`** (`@0x4A832..0x4A841`) —
    so larger settlements bias toward larger treasure;
  - **tribe == 2** special: bound `= (8 − difficulty[0x53A6]) << scout` (`@0x4A84A`);
  - `sz ≥ 75`: a distinct big-treasure branch (`@0x4A802 → 0x4AB72`).

  So the magnitude is a **Seasoned-Scout-boosted, size-biased random** roll. **B
  (roll mechanism).** The downstream conversion of the roll to gold / treasure-unit
  creation (likely `×100` per the treasure-unit convention, `events.md` §3) is **TBD**.
- **Mission conversion** — `func_0572E6` (file `0x572E6`, "INDIANSCONVERT"). **BYTE_VERIFIED mechanism:**
  - success is gated by a roll: `threshold = TribeData[+2] + 2` (`[0x8D4E]` = active TribeData), **doubled** if a flag bit (`cl & 0x10`) is set; the roll is **`random_int(0, 15)`** (bound `0x0F` `@0x5730A`, thunk `0x181F:0x4D4` `@0x5730E`); convert **fails if `roll ≥ threshold`** (`@0x57316`). So **P(convert) = (TribeData[+2]+2)/15**, doubled to `2·(…)/15` when `cl & 0x10`. **BYTE_VERIFIED bound.**
  - on success a **convert unit is created at the colony** — thunk `0x181F:0x95C` @`0x5735F` is passed `ColonyRecord +0x00`/`+0x01`/`+0x1A` (map_x / map_y / owner); its returned `UnitRecord` index then gets **`+0x15 (class) = 0x1B`** (`MOV byte[bx+0x315B],0x1B` @`0x57374`). That `0x1B` class is the same "convert/special" colonist the colony-production formula gives a +1 staple bonus (see `colony.md` §3 `is_special`).
  - the `@INDIANSCONVERT` popup (tribe name `[0x8D52]`) is shown only to a **human European** owner (`[bp+6] < 4` and `AIPersonality[+0x543F].controller == 0`), thunk `0x191F:0x19C` @`0x57344`.
  - Still **TBD:** the `cl & 0x10` flag's *meaning* (it doubles the success chance — likely a mission-level or relevant-father bonus; the bound `0..15` is now B).
- **Native raid on colony** — `func_05BE84` (file `0x5BE84`). **BYTE_VERIFIED:** the
  6 raid outcomes are the message keys `RAIDWREAK` (`@0x5C1DE`), `RAIDSTORES`
  (`@0x5C3CC`), `RAIDBURN` (`@0x5C50B`), `RAIDSHIP` (`@0x5C57B`), `RAIDGOLD`
  (`@0x5C5F7`), `RAIDNOTHING` (`@0x5C637`) — i.e. raze havoc / steal stores / burn a
  building / sink a docked ship / steal gold / no effect. Selection: a **gate roll**
  `random_int(1,12)−1` `@0x5BEFD` (biased `+(difficulty−2)` for a human-European
  owner `@0x5BF1A`) vs threshold `3·K+1` `@0x5BEE5`; a **base outcome**
  `random_int(1,4)` `@0x5BF35` adjusted by turn/difficulty (`turn < 40·(2−diff)`
  downgrades `@0x5BF44`) and per-outcome availability gates (thunk `0x181F:0x9FC`);
  a 5-way dispatch `@0x5C023` → handlers `0x5C1AF/03E/0CA/252/29A`. Exact
  outcome→handler→key wiring is partly **TBD** (handlers have sub-branches).
- Attitude escalation/decay, trade pricing, tribute amounts: **TBD** (`func_03ECF0` adjacency is the per-unit confrontation AI per RULINGS — not the price math; do not assert).

## 4. UI
Native dialogs use `@CHIEF*` / `@VILLAGE*` / `@INDIAN*` / `@MISSION*` GAME keys (e.g. `@CHIEFHOWDY @CHIEFGIFT @CHIEFKILL @VILLAGEHAPPY @INDIANTREATY`). Action menu from `@ACTIONS`. See `docs/SESSION_UI_CATALOG.md`.

## 5. Evidence
- `docs/DATA_MODEL.md` — NativeSettlement base `0x54EC` stride 18; +0x00/+0x01 pos, +0x04 population (CHIEFKILL), +0x08 last_bought; raze `func_04A7CA`. **B/A**
- `data_extracted/text/NAMES_sections.json` — `@TRIBES @ATTITUDE @ATTITUDINAL @LEVELS @MISSION`. **B (present)**
- `data_extracted/text/GAME_sections.json` — native dialog keys present. **B**
- `func_0572E6` (file `0x572E6`) — mission conversion: roll-gated success, convert-unit creation at the colony, `UnitRecord +0x15 = 0x1B`, `@INDIANSCONVERT` popup. **B**

## 6. Open questions (TBD)
1. Byte-confirm `+0x02` (tribe/owner) and `+0x03` (flags); fill the rest of the 18-byte record (attitude value, mission flag, alarm/tension counter).
2. ~~CHIEFKILL treasure roll~~ **Done 2026-06-19** — `random_int(0, 40·scout+100)`, Seasoned-Scout (class 0x16) boost, size/4 re-roll bias, tribe-2 `(8−diff)<<scout` (`func_04A7CA`, **B**); the roll→gold conversion + attitude escalation thresholds remain TBD.
3. Trace native trade pricing and tribute/incite logic.
4. Mission conversion: ~~the `random_int` bounds~~ **Done** — `random_int(0,15)`, `P=(TribeData[+2]+2)/15` (**B**). Remaining: the `cl & 0x10` flag's *meaning* (doubles the chance).
