# Map View (main gameplay screen)

> **Layer 2 — UI Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** outer band geometry **A** (overlay-verified, not byte-cited); tile chain & sidebar fields **B/R**. · **Canonical primary:** `docs/RENDERER_GEOMETRY.md` "Map view", `docs/SESSION_UI_CATALOG.md` §1, `docs/COLONY_RENDER_CHAIN.md` (tile chain).

## 1. Purpose
The default in-game screen (155/396 session snaps — the majority of play). Left ~3/4 is the tile-rendered world viewport; the right ~80px is a woodgrain sidebar showing season/gold/tax plus a context panel for the selected unit or hovered (foreign) colony. A top menu strip drives all pulldowns. **A** (`SESSION_UI_CATALOG.md` §1).

## 2. Layout — "what is drawn where"
Native 320×200 (mode 13h). Coordinates from `RENDERER_GEOMETRY.md` (overlay-verified v2/v3, tier **A** — pixel-measured, not byte-cited).

| Region | Pixel rect | Tier | Notes |
|--------|-----------|------|-------|
| Top menu strip | (0, 0, 320, 8) | A | glyph-grid; v3 corrected from 14→8 px |
| Map viewport | (0, 8, 240, 192) | A | 15×12 tiles × 16×16 px at closest zoom (240×192) |
| Sidebar A — minimap | (240, 14, 80, 58) | A | ~58×72 world squashed; white viewport rect, colony/unit dots |
| Sidebar B — season/gold/tax | (240, 72, 80, 64) | A | "Spring NNNN / Gold: NNNN / Tax: NN%" |
| Sidebar C — selected-unit panel | (240, 136, 80, 64) | A | sprite + Moves/Locat + type/skill/orders/(terrain) |

Sidebar variants: foreign-colony hover replaces panel C with name/nation/treasury + With:/Ask: trade lists (`SESSION_UI_CATALOG.md` §8). **A**

**Tile drawing chain (per CLAUDE.md hard rule #7):** each tile drawn by `func_O514 → func_O513 → func_O512`. `func_O512`'s 4-loop iterates the 4 cardinal neighbors (dX `00 01 00 FF`, dY `FF 00 01 00`) for terrain-transition composition; terrain id decoded via `get_terrain_id_from_raw` (file `0x6204`, mask `& 0x1F` + auto-forest). **B** (`COLONY_RENDER_CHAIN.md` §4, §3).

## 3. Assets & text
- **Tiles:** PHYS0.SS (+ auto-forest variants); **never** TERRAIN.SS/BDARK.SS (orphans, CLAUDE.md #5). Map units/colonies: ICONS.SS. Sidebar bg: WOODPANL.PIK. Cursor: CURSOR.SS. **A/B**
- **Menu text** (verified present in `data_extracted/text/MENU_sections.json`): keys `@GAME`, `@VIEW`, `@ORDERS`, `@REPORTS`, `@TRADE`, `@CUP` (CHEAT), `@PEDIA` (COLONIZOPEDIA). **B**
- **Sidebar labels** (verified in `LABELS_sections.json`): `@INFO` ("Moves:\nLocat:"), `@MISC` ("Gold", "Road", order statuses). Season from NAMES `@SEASONS`; terrain from NAMES `@FORESTED`/`@UNFORESTED`; unit type NAMES `@UNIT`, skill NAMES `@JOB`. All keys verified present. **B**

## 4. Interactions
- Top menu pulldowns (GAME/VIEW/ORDERS/REPORTS/TRADE/CHEAT/COLONIZOPEDIA) — items enumerated in MENU keys above. **B**
- REPORTS F2–F10 → advisor screens (see `advisor_reports.md`). **B**
- Click own colony tile → colony screen (`COLONY_RENDER_CHAIN.md` §2 entry chain: `func_L187 → set_active_colony (file 0x82DC) → lcall 0x191f:0x1de`). **B**
- Click foreign colony → sidebar trade view. **A**
- VIEW menu zoom levels (120×96 / 60×48 / 30×24 / 15×12) per `@VIEW`. **B**

## 5. Evidence
- `docs/RENDERER_GEOMETRY.md` — "Map view (VERIFIED v2)" + "REVISED v3" (band y=8), "Default map view sidebar". **A**
- `docs/SESSION_UI_CATALOG.md` §1, §8 — layout, sidebar variants. **A**
- `docs/COLONY_RENDER_CHAIN.md` §3/§4 — tile chain, `0x6204` decoder, entry chain. **B**
- `data_extracted/text/MENU_sections.json`, `LABELS_sections.json`, `NAMES_sections.json` — menu/sidebar keys (all verified). **B**

## 6. Open questions (TBD)
1. Sidebar B/C exact intra-panel text (x,y) per line — only band rects measured.
2. Minimap dot color → owner mapping (orange=own, grey/red=foreign/native) is observation, not byte-cited.
3. Per-zoom-level viewport tile counts beyond closest zoom (15×12) not measured.
4. Top-menu item hit-rects (x ranges) only roughly placed in v1 geometry.
