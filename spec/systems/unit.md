# Unit System

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** **UnitRecord base `0x3144` + near-complete field map +
`@UNIT` stat-column→runtime mapping `BYTE_VERIFIED`** (2026-06-20). **Canonical
primary:** the placer/renderer/loader byte-traces (§2/§3); `data_extracted/text/NAMES_sections.json`
`@UNIT`/`@CLASS`/`@ORDERS`. (Prior `docs/DATA_MODEL.md` base `0x3146` + map_x=+0x07
labels superseded — RULINGS 2026-06-20.)

## 1. Purpose & behavior
A unit is any mobile actor on the map — colonists, soldiers, pioneers, scouts, ships, wagon trains, treasure, artillery, and native braves. Each carries a type, a position, movement, combat values, and current orders. Land units may be carried by ships (sentry while aboard, per manual). **RECONSTRUCTED** (manual + @UNIT).

## 2. State & data
`UnitRecord` base **`DGROUP:0x3144`**, **stride 0x1C (28 bytes)** (corrected from the
prior `0x3146` base — RULINGS 2026-06-20). Fields by **absolute** address (the base
convention is ambiguous, so offsets are given absolute):

| abs | Type | Meaning | Tier | Evidence |
|-----|------|---------|------|----------|
| `0x3144` | u8 | **map_x** (drawn position) | **BYTE_VERIFIED** | renderer `@0x03A63`, placer `@0x06958` |
| `0x3145` | u8 | **map_y** | **BYTE_VERIFIED** | renderer `@0x03A5E`, placer `@0x0695E` |
| `0x3146` | u8 | **unit_type** (`@UNIT` row 0..23; ×stat-table index) | **BYTE_VERIFIED** | dispatcher `@0x51D6B`; 694 refs |
| `0x3147` | u8 | **owner/power nibble** (`&0xF` = power 0..11) + state hi-nibble | **BYTE_VERIFIED** | `set_unit_owner @0x738E`; `@0x51D88` |
| `0x3148` | u8 | flag byte (bit `0x80` = land/ship or moved) | **A** | `test [..],0x80` `@0x037AD`/`@0x079EF` |
| `0x3149` | u8 | active / AI-enable flag | **A** | dispatcher gate `@0x51D5D` |
| `0x314A` | u8 | countdown timer (init `0xFF`, `dec`) | **A** | `@0x2EF17`, init `@0x06DBA` |
| `0x314B` | u8 | state/mode char (ASCII `'X'`/`'-'`/`'E'`/`'A'`/`'G'`) | **A** | `@0x06D84`, `@0x51DAB` |
| `0x314C` | u8 | **order code** (0..0x0C) | **BYTE_VERIFIED** | dispatchers `@0x249CB`/`@0x51DCE` |
| `0x314D`/`0x314E` | u8×2 | **goto-target x/y** (also trade-route next-stop) | **BYTE_VERIFIED** | GoTo writer `@0x22D38` |
| `0x314F` | u8 | europe/recruit state (cmp ==8) | **TBD** | `@0x47A6F`/`@0x516E9` |
| `0x3150` | u8 | **cargo count** (# goods in hold) | **BYTE_VERIFIED** | `get_nth_cargo @0x0B2AB`, init `@0x06D93` |
| `0x3151..0x3153` | nib | **cargo good-ids** (nibble-packed, 2/byte, ≤6) | **BYTE_VERIFIED** | `@0x0B2CB` |
| `0x3154..0x3155` | u8×2 | **cargo quantities** (per slot) | **A** | `@0x0B2FB` |
| `0x3156` | u16 | accumulated value (cost/sale-price/treasure) | **TBD** | `@0x4769C`, init `0xFFFF @0x06DB3` |
| `0x3159` | u8 | **tools** (0..100; −20/pioneer-action, revert to Colonist if <20) | **BYTE_VERIFIED** | `@0x4060F`, init `@0x06E3F` |
| `0x315A` | u8 | **work/turns-in-activity counter** (clear/road/fortify) | **BYTE_VERIFIED** | `@0x04071D`/`@0x2EFD6` |
| `0x315B` | u8 | **class/profession** (0x13..0x1C); route units: lo nib=route, hi=stop | **BYTE_VERIFIED** | combat `@0x5B60E`, write `@0x09548` |
| `0x315C`/`0x315E` | u16×2 | per-tile occupancy back/next links (unit idx) | **BYTE_VERIFIED** | placer `@0x06976`/`@0x06968` |

(`0x3158`, and the exact bit meanings of `0x3148`/`0x314B`, remain TBD.)

`@UNIT` rows (NAMES, **BYTE_VERIFIED present**): Colonists, Soldiers, Pioneers, Missionaries, Dragoons, Scouts, Regulars, Cont. Cav., Cavalry, Cont. Army, Treasure, Artillery, Wagon Train, Caravel, Merchantman, Galleon, Privateer, Frigate, Man-O-War, Braves, Armed Braves, … (24 rows). Each row carries `name, sprite_id, <8 numeric cols>, <8-bit flag string>`. **Column semantics: TBD** (sprite id is col 1; movement/attack/defense/cargo unmapped).

`@CLASS` (8 colonist classes w/ a number, BYTE_VERIFIED present): Petty Criminals 300, Indentured Servants 400, Peasant Farmers 600, Skilled Craftsmen 800, Hardy Pioneers 1450, Town Merchants 1500, Trained Mercenaries 1900, Educated Elite 2000.

## 3. Formulas & rules
**@UNIT column → runtime stat table — BYTE_VERIFIED (2026-06-20).** The `@UNIT`
loader (`@0x074EC3`/`@0x074EEE`) parses 23 rows into a per-type table at base
**`DGROUP:0x5230`, stride 14 (0x0E)**, indexed `type·14`:
| @UNIT col | runtime | field |
|-----------|---------|-------|
| name | `0x5230` (word) | name-string pointer |
| sprite | `0x5232` | sprite_id |
| 1 | `0x5234` (stored ×3) | **movement** (thirds; road = 1/3) |
| 2 | `0x5236` | **attack** |
| 3 | `0x5235` | **defense** |
| 4 | `0x5237` | **cargo-hold capacity** (Caravel 2 / Galleon 6) |
| 5 | `0x5238` | **movement class** (99 = naval/free) |
| 6 | `0x5239` | **hull / base strength** |
| 7 | `0x523A` | **size / transport-cost** |
| 8 | `0x523B` | **guns** |
| 9 | `0x523C` | **AI value / build weight** |
| flags | `0x523D` | 8-bit role/flag string (bit-tested `@0x51D7D` etc.) |
("tools" is not an @UNIT column — it is the runtime UnitRecord field `0x3159`.)
- Carry/embark, ZoC, movement-point costs: movement is stored ×3 (`0x5234`),
  road = 1/3 cost; full move-cost table **TBD**.

## 4. UI
Active-unit orders box and map cursor. See `docs/UI_RENDER_MAP.md`, `notes/SPRITE_CATALOG.md` (renderer sprite indices per CLAUDE.md hard rule 6).

## 5. Evidence
- placer `@0x06958` / renderer `@0x03A63` / GoTo writer `@0x22D38` — position `0x3144/0x3145`, goto-target `0x314D/0x314E` (base `0x3144`). **B**
- `@UNIT` loader `@0x074EC3`/`@0x074EEE` — stat table `0x5230` stride 14 (§3). **B**
- cargo-hold `get_nth_cargo @0x0B2AB` (count `0x3150`, ids `0x3151..`, qty `0x3154..`); tools `@0x4060F` (`0x3159`); class `@0x5B60E` (`0x315B`). **B**
- `docs/DATA_MODEL.md` — UnitRecord (base `0x3146`/+0x07 pos labels **superseded**, RULINGS 2026-06-20). **A→corrected**
- `data_extracted/text/NAMES_sections.json` — `@UNIT` (24 rows), `@CLASS` (8), `@ORDERS`. **B**

## 6. Open questions (TBD)
1. ~~Map every `@UNIT` numeric column.~~ **Done 2026-06-20** — table `0x5230` stride 14
   (§3): movement `0x5234`(×3) / attack `0x5236` / defense `0x5235` / cargo `0x5237` /
   move-class `0x5238` / hull `0x5239` / size `0x523A` / guns `0x523B` / ai-value
   `0x523C` / flags `0x523D`. **B.**
2. ~~Trace the 28-byte UnitRecord fields.~~ **Mostly done 2026-06-20** — base `0x3144`,
   full field map in §2 (position/type/owner/order/goto/cargo/tools/work/class/links).
   Residual: `0x3158`, `0x314F` europe state, and exact bits of `0x3148`/`0x314B`.
3. Confirm unit→sprite mapping against `notes/SPRITE_CATALOG.md`.
