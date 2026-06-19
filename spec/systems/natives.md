# Native Relations

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** NativeSettlement base/stride + a few offsets + **mission-conversion mechanism** `BYTE_VERIFIED`; attitude/trade/raid logic `RECONSTRUCTED`/`TBD`. **Canonical primary:** `docs/DATA_MODEL.md` NativeSettlement; `data_extracted/text/NAMES_sections.json` `@TRIBES`/`@ATTITUDE`/`@ATTITUDINAL`/`@LEVELS`/`@MISSION`; `data_extracted/text/GAME_sections.json` native keys.

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
- **Raze treasure (CHIEFKILL)** — `func_04A7CA`: treasure scales from `NativeSettlement[+0x04]` population; active record repointed at attack. **ANCHOR_VERIFIED** (`docs/DATA_MODEL.md` §CHIEFKILL); exact formula **TBD**.
- **Mission conversion** — `func_0572E6` (file `0x572E6`, "INDIANSCONVERT"). **BYTE_VERIFIED mechanism:**
  - success is gated by a roll: `threshold = TribeData[+2] + 2` (`[0x8D4E]` = active TribeData), **doubled** if a flag bit (`cl & 0x10`) is set; `random_int` via thunk `0x181F:0x4D4` @`0x5730E`; convert fails if `roll ≥ threshold`.
  - on success a **convert unit is created at the colony** — thunk `0x181F:0x95C` @`0x5735F` is passed `ColonyRecord +0x00`/`+0x01`/`+0x1A` (map_x / map_y / owner); its returned `UnitRecord` index then gets **`+0x15 (class) = 0x1B`** (`MOV byte[bx+0x315B],0x1B` @`0x57374`). That `0x1B` class is the same "convert/special" colonist the colony-production formula gives a +1 staple bonus (see `colony.md` §3 `is_special`).
  - the `@INDIANSCONVERT` popup (tribe name `[0x8D52]`) is shown only to a **human European** owner (`[bp+6] < 4` and `AIPersonality[+0x543F].controller == 0`), thunk `0x191F:0x19C` @`0x57344`.
  - Still **TBD:** the exact `random_int` bounds and the `cl & 0x10` flag's meaning.
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
2. Byte-trace the CHIEFKILL treasure formula and attitude escalation thresholds.
3. Trace native trade pricing and tribute/incite logic.
4. Mission conversion: the `random_int` bounds and the `cl & 0x10` flag in `func_0572E6` (mechanism is B; these two constants TBD).
