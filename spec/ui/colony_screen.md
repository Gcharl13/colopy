# Colony Screen

> **Layer 2 — UI Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** outer band geometry **A** (luma-edge measured); per-element draw code **TBD** (renderer lives in un-extracted overlay 0x191F). · **Canonical primary:** `docs/COLONY_RENDER_CHAIN.md`, `docs/RENDERER_GEOMETRY.md` "Colony screen (VERIFIED v3)", `docs/SESSION_UI_CATALOG.md` §2.

## 1. Purpose
The colony management screen (33 session snaps; Plymouth). Shows the colony scene (buildings/colonists/trees) with surrounding worked tiles, a middle band of stats panels (Sons-of-Liberty %, colonist list, loading ship, cargo/build progress), and a bottom 16-commodity warehouse strip. Entered by clicking an own colony on the map. **A** (`SESSION_UI_CATALOG.md` §2).

## 2. Layout — "what is drawn where"
Native 320×200. Bands frame-verified via luma-edge analysis (`RENDERER_GEOMETRY.md` "VERIFIED v3", tier **A**).

| Region | Pixel rect | Tier | Notes |
|--------|-----------|------|-------|
| Title bar | (0, 0, 320, 8) | A | "Plymouth.  Spring, 1543.  Gold: NNNN" FONTSMAL green over WOODTILE |
| Colony scene | (0, 8, 199, 120) | A | beige bg; buildings/colonists/trees as unified layered scene |
| Wood frame separator | (199, 8, 25, 120) | A | dark vertical strip |
| Surrounding-tiles minimap | (224, 8, 72, 120) | A | 3-wide tile grid (24 px each) of neighbor tiles + worker yields |
| Wood frame right border | (296, 8, 24, 120) | A | trim |
| Middle band | (0, 128, 320, 50) | A | 4 sub-panels (below) |
| Stockpile strip | (8, 178, 304, 22) | A | 16 cells × 19 px stride, left margin 8 |

Middle-band sub-panels (all y=128..178):

| Sub-panel | Pixel rect | Tier | Notes |
|-----------|-----------|------|-------|
| Left (SoL + colonists) | (0, 128, 120, 50) | A | flag + "%loyal (count)" SoL bars + idle colonist sprites |
| Center (ships) | (120, 128, 86, 50) | A | "Loading: \<ship\>" + ship sprite |
| Right (cargo + build) | (206, 128, 97, 50) | A | cargo barrels + in-progress build sprite |
| Exit button | (303, 128, 17, 50) | A | red "Exit" stacked |

**Caveat:** the per-element draw code (building sprite indices, fixed (x,y) per building, production-row bell/cross/hammer indices, colonist placement) is **NOT in the extracted disassembly — it lives in overlay segment 0x191F** (`COLONY_RENDER_CHAIN.md` §6). All such specifics are **TBD**; do not invent indices.

## 3. Assets & text
- **Background:** COLONY.PIK (320×72 strip drawn y=128..200, EUROPE.PIK palette). Scene composed from BUILDING.SS sprites + colonist ICONS.SS. Exit: EXIT.SS. **A/B**
- **16-commodity order** (NAMES `@CARGO`, verified present; first entries Food/Sugar/Tobacco/Cotton/Furs… confirmed in JSON): Food, Sugar, Tobacco, Cotton, Furs, Lumber, Ore, Silver, Horses, Rum, Cigars, Cloth, Coats, Trade, Tools, Muskets. **B**
- **Text keys** (verified in `LABELS_sections.json`): `@CTITLE` ("Pop:", "Gold:", "BUY", "CHANGE", "Select An Item To Build", "(No Production)", "Tax:"); `@MISC` ("Loading", "(Outside Colony)"). Building names NAMES `@BUILDING` (verified). **B**

## 4. Interactions
- Exit button → back to map. **A**
- "CHANGE"/BUY (`@CTITLE`) → Build menu overlay (frame 1310206750): lists buildable items + hammer/tool costs, "(F1 for Help)". Costs (Stockade 64H, Warehouse 80H, Printing Press 52H+20T, …) observed in session but **need byte-verification vs `func_02D658`** — tier **R**. (`SESSION_UI_CATALOG.md` §2, `RENDERER_GEOMETRY.md` "Build menu overlay".)
- Click colonist / work tile → reassign profession (mechanism TBD).

## 5. Evidence
- `docs/RENDERER_GEOMETRY.md` "Colony screen (VERIFIED v3)" — luma-measured bands. **A**
- `docs/COLONY_RENDER_CHAIN.md` §1 (globals: `[0x8542]` active ColonyRecord ptr, base 0x5D46 stride 0xCA), §2 (entry chain), §5/§6 (renderer in overlay 0x191F, KNOWN UNKNOWNS). **B / TBD**
- `docs/SESSION_UI_CATALOG.md` §2 — Plymouth frame, 16-good order, build menu. **A**
- `data_extracted/text/{NAMES,LABELS}_sections.json` — `@CARGO`, `@CTITLE`, `@BUILDING`, `@MISC` (verified). **B**

## 6. Open questions (TBD)
1. Building bitmask → BUILDING.SS index → fixed (x,y) placement table — in overlay 0x191F (`COLONY_RENDER_CHAIN.md` §6g).
2. Production-row sprite indices (bell/cross/anvil) — overlay 0x191F (§6d).
3. Colonist mid-band & work-tile sprite indices/positions — overlay 0x191F (§6e).
4. Stockpile cell qty draw color thresholds — overlay 0x191F (§6f).
5. Surround loop count (3×3 vs other) — unconfirmed; visible-surround code in overlay (§6c).
6. Build-cost table byte-verification vs `func_02D658`.
