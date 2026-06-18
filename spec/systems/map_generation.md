# Map Generation

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** scenario presets present (`BYTE_VERIFIED` data); generation
algorithm not decoded (`TBD`).
**Canonical primary:** `data_extracted/text/NAMES_sections.json` (@SCENARIO),
`docs/GAME_MANUAL.md` (NEW WORLD / AMERICA / Customize New World).

## 1. Purpose & behavior
At new-game setup the player chooses how the world is built (`docs/GAME_MANUAL.md`):
- **Start in NEW WORLD** — randomly generated "undiscovered America."
- **Start in AMERICA** — fixed map matching real-world Americas geography (loads the
  canonical scenario; AMER2.MP is the standard-game world, `formats/MP_FORMAT.md`).
- **Customize New World** — adjustable parameters: average **land-mass size**,
  **moisture**, and **climate** (temperate / cold / tropical), "and so on."
  (RECONSTRUCTED — function from manual; parameter encodings `TBD`.)

## 2. State & data
`@SCENARIO` (`NAMES_sections.json`, **BYTE_VERIFIED** data present) lists named
scenarios with numeric parameter rows:
```
AMER2,     34, 20, 39, 10, 47, 61,  50, 33
AMERICA,   56, 27, 67, 12, 66, 42, 84,  65
```
The 8 numeric columns per scenario are **TBD** (likely starting positions /
dimensions / seed params — not yet decoded). Do not assume.

## 3. Formulas & rules
- Random-map generation algorithm: **TBD** (not located in disasm).
- Customize parameter ranges and their effect on land/moisture/climate: **TBD**.
- Polar-ice boundary: top/bottom edges bounded by impassable ice (manual). **R**
- Sea-lane on right edge: id 26 (see `spec/systems/map_system.md`, CLAUDE.md hard rule 2). **B**

## 4. UI
Setup-menu options surfaced in the opening/new-game flow. Strings likely in
`OPENING_sections.json` / `MENU_sections.json`; concrete catalog `TBD`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@SCENARIO` rows. **B** (data present).
- `docs/GAME_MANUAL.md` — NEW WORLD / AMERICA / Customize options. **R** (function).
- `formats/MP_FORMAT.md` — AMER2.MP is the standard-game world. **B**

## 6. Open questions (TBD)
1. Decode the 8 `@SCENARIO` columns.
2. Locate and trace the random-map generator (entry function unknown).
3. Customize parameter encodings (land size / moisture / climate scales).
4. Confirm which menu strings drive the three setup choices.
