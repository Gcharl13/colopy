# Index Tables — Sprite & Text Cross-Reference

> **Layer 2 — Data Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.

**Canonical primary:** `docs/GAME_INDEX_TABLES.md` (master mapping reference — CANONICAL). This stub summarizes the mappings it holds and points to it; it does **not** copy the index tables.

## 1. Summary

`docs/GAME_INDEX_TABLES.md` is the single canonical cross-reference linking the game's data taxonomies (NAMES.TXT `@`-sections), the encyclopedia (PEDIA.TXT `@KEY` indices), the runtime records (PowerRecord market arrays etc.), and the renderer's sprite-frame lookups. It exists so that a given entity (cargo type, unit, building, terrain) can be traced from its data-table row to its sprite frame and its string offset.

## 2. Contents

| Mapping | What it indexes | Source / target | Tier |
|---------|-----------------|-----------------|------|
| 16 Cargo / Commodity | NAMES `@CARGO` row ↔ PEDIA `@CARGO0..15` ↔ PowerRecord market byte `+0x4C+i` ↔ ICONS sprite range; 9 price params per cargo + boycott bit (`+0x20` u16) | `docs/GAME_INDEX_TABLES.md` | **B** |
| Units | NAMES `@UNIT` row index (0..23) → UnitRecord `+0x00` unit_type → renderer sprite frame (foot units 100–105+109; ships 5–7/14–15/127 per CLAUDE.md) | `docs/GAME_INDEX_TABLES.md` | **B/A** |
| Buildings | NAMES `@BUILDING` row → colony-screen sprite frame | `docs/GAME_INDEX_TABLES.md` | **B/A** |
| Terrain | raw map byte (`& 0x1F`, auto-forest 8..23 per CLAUDE.md hard rule 3) → terrain id → PHYS0.SS frame | `docs/GAME_INDEX_TABLES.md`, `formats/MP_FORMAT.md` | **B/A** |
| Text / Colonizopedia | PEDIA `@KEY` (`@FATHERN`, `@CARGON`, …) → string offset / encyclopedia entry | `docs/GAME_INDEX_TABLES.md`, `docs/PEDIA_TXT_CATALOG.md` | **B** |

Index counts and the exact per-cargo parameter table (Name, Start1/2, Low, High, Burden, Rise, Fall, Attrition, Volatility, boycott bit) live in `docs/GAME_INDEX_TABLES.md` — read them there.

## 3. Evidence

- `docs/GAME_INDEX_TABLES.md` — generated 2026-05-05 from PEDIA.TXT title extraction; cargo params byte-verified, boycott bitfield verified for Food. **B**
- `data_extracted/text/NAMES_sections.json` — the `@`-section data tables being indexed. **B**
- `data_extracted/text/PEDIA_sections.json` — `@KEY` entries. **B**
- CLAUDE.md hard rules 3/6 — terrain id & renderer sprite-index anchors. **B**

## 4. Resolved questions (all closed)

1. **Sprite-frame indices — RESOLVED 2026-06-20** (per `notes/SPRITE_CATALOG.md`, the
   authoritative catalog): a **global ICONS.SS off-by-one** holds — `port_png_index =
   VICEROY_sprite_index − 1` for all roles (e.g. `@UNIT` icon Caravel 6→png5,
   Man-O-War 128→png127; the CLAUDE.md anchors ships 5-7/14-15/127 & foot 100-105+109
   are already PORT indices). `@UNIT` col-1 sprite ids verified (Colonists 101,
   Soldiers 103, Pioneers 102, Scouts 104, Braves 110). **B.** ⚠ **Correction:**
   CC-00..CC-24 are **Founding Father portraits** (`@FATHERS`, per `PROJECT_BOARD.md`
   SPRITE-A), **not** a "unit-sheet→type" table — unit sprites are in **ICONS.SS** (above).
   **`.SS` decoder — DONE 2026-06-20:** the codec is standard **FAB** (LZ77 bitstream),
   recovered statically from the in-EXE `fab_decompress`/`madspack_load` and ported to
   [`tools/ssdec.py`](../../tools/ssdec.py); it decodes all 28 `.SS` sheets to their exact
   directory `unpacked` sizes and renders correct sprites (the old "FAB codec undocumented /
   `mpskit` absent / decoder-blocked" note is superseded — see `formats/SS.md`). CC-NN
   render as the 25 portraits; BUILDING.SS as 48 building frames. **BUILDING.SS catalogued
   (2026-06-21):** all 48 frames rendered + identified, render mechanism byte-verified via
   `colony_paint_buildings` (slot tables `0x8D62`/`0x8E82`/`0x0266`); the 48-vs-42 gap is
   5 placeholder dummies + ~4 empty-lot/waterfront backgrounds + production art **shared by
   goods** (runtime ICONS.SS overlay) — so no clean 1:1 list exists for the craftsman chains;
   the unambiguous frames (walls 0–2, docks 6–8, civic 9, church/cathedral 37/38, education
   13/14, warehouse 15, stable 35, blacksmith 39–41) are bound. See `notes/SPRITE_CATALOG.md`
   §CC-00..CC-24 / §BUILDING.SS. **B** (pixels HIGH + mechanism byte-verified).
2. ~~PEDIA `@KEY` ↔ NAMES 1:1.~~ **Done 2026-06-20** — 1:1 by count+order for FATHERS
   (25), BUILDING (42), JOB (28), UNIT (24), CARGO (16 tradeables); TERRAIN PEDIA (29)
   spans `@UNFORESTED`+`@FORESTED`. (`docs/PEDIA_TXT_CATALOG.md` @JOB count 27 is an
   off-by-one; real = 28.) See `text_resources.md` §4. **B.**
