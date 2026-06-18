# Unit System

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** UnitRecord base/stride + a few offsets `BYTE_VERIFIED`; @UNIT stat columns present but unmapped (R/TBD). **Canonical primary:** `docs/DATA_MODEL.md` UnitRecord; `data_extracted/text/NAMES_sections.json` `@UNIT`/`@CLASS`/`@ORDERS`.

## 1. Purpose & behavior
A unit is any mobile actor on the map — colonists, soldiers, pioneers, scouts, ships, wagon trains, treasure, artillery, and native braves. Each carries a type, a position, movement, combat values, and current orders. Land units may be carried by ships (sentry while aboard, per manual). **RECONSTRUCTED** (manual + @UNIT).

## 2. State & data
`UnitRecord` base `DGROUP:0x3146`, **stride 0x1C (28 bytes)**, up to ~300 records.

| Field | Type | Meaning | Tier | Evidence |
|-------|------|---------|------|----------|
| +0x00 | u8 | `unit_type` = `@UNIT` row index (0..23) | **BYTE_VERIFIED** (runtime) | `docs/DATA_MODEL.md`: type freq matches @UNIT idx (Colonists=190, Braves=37, Caravel=3) |
| +0x00 | u8 | most-accessed byte (652 refs); possibly also an is-alive/flags overlap | **ANCHOR_VERIFIED** | `docs/DATA_MODEL.md` |
| +0x07 | u8 | `map_x` | **BYTE_VERIFIED** (runtime) | `docs/DATA_MODEL.md`: Caravel (55,49) |
| +0x08 | u8 | `map_y` | **BYTE_VERIFIED** (runtime) | `docs/DATA_MODEL.md` |
| +0x15 | u8 | `unit_class` / profession (init 0..0x1C at creation; read by combat demotion table) | **ANCHOR_VERIFIED** | `docs/DATA_MODEL.md` |
| +0x01 | u8 | `power`/flags (per task hint) | **TBD — not yet traced** | — |
| other offsets | — | move/cargo/orders fields | **TBD — not yet traced** | — |

`@UNIT` rows (NAMES, **BYTE_VERIFIED present**): Colonists, Soldiers, Pioneers, Missionaries, Dragoons, Scouts, Regulars, Cont. Cav., Cavalry, Cont. Army, Treasure, Artillery, Wagon Train, Caravel, Merchantman, Galleon, Privateer, Frigate, Man-O-War, Braves, Armed Braves, … (24 rows). Each row carries `name, sprite_id, <8 numeric cols>, <8-bit flag string>`. **Column semantics: TBD** (sprite id is col 1; movement/attack/defense/cargo unmapped).

`@CLASS` (8 colonist classes w/ a number, BYTE_VERIFIED present): Petty Criminals 300, Indentured Servants 400, Peasant Farmers 600, Skilled Craftsmen 800, Hardy Pioneers 1450, Town Merchants 1500, Trained Mercenaries 1900, Educated Elite 2000.

## 3. Formulas & rules
- @UNIT numeric column meaning (movement, attack, defense, cargo capacity, sprite, hold size): **TBD** — byte-trace the @UNIT table reader.
- Carry/embark, ZoC, movement-point costs: **TBD**.

## 4. UI
Active-unit orders box and map cursor. See `docs/UI_RENDER_MAP.md`, `notes/SPRITE_CATALOG.md` (renderer sprite indices per CLAUDE.md hard rule 6).

## 5. Evidence
- `docs/DATA_MODEL.md` — UnitRecord base `0x3146`, stride 28; +0x00 type, +0x07/+0x08 pos, +0x15 class. **B/runtime**
- `data_extracted/text/NAMES_sections.json` — `@UNIT` (24 rows), `@CLASS` (8), `@ORDERS`. **B (keys/rows exist)**

## 6. Open questions (TBD)
1. Map every `@UNIT` numeric column (movement/attack/defense/cargo/hold) to a verified reader.
2. Trace +0x01 (`power`/flags) and the remaining 28-byte UnitRecord fields (orders, cargo, owner/nation, move-points-left).
3. Confirm unit→sprite mapping against `notes/SPRITE_CATALOG.md`.
