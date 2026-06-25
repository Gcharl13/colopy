# Map View (main gameplay screen)

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.
> Substantive: outer geometry + minimap + tile chain + menu/label keys are A/B-grounded;
> the residual soft spots (sidebar per-line text x,y; menu per-item hit-rects) are honestly
> **R** — single-frame/low-trust, called out in §6.3/§6.4 with the exact source.

**Overall confidence:** outer band geometry **B** (byte-verified `[V]` in `SCREEN_LAYOUTS.md` §1; formerly overlay-only **A**); tile chain & sidebar fields **B/R**. · **Canonical primary:** `viceroy_source/docs/SCREEN_LAYOUTS.md` §1 (map HUD geometry, byte-cited), `docs/SESSION_UI_CATALOG.md` §1, `docs/COLONY_RENDER_CHAIN.md` (tile chain), `docs/INGAME_MAP_RENDER_TRACE.md` (tile draw chain).

## 1. Purpose
The default in-game screen (155/396 session snaps — the majority of play). Left ~3/4 is the tile-rendered world viewport; the right ~80px is a woodgrain sidebar showing season/gold/tax plus a context panel for the selected unit or hovered (foreign) colony. A top menu strip drives all pulldowns. **A** (`SESSION_UI_CATALOG.md` §1).

## 2. Layout — "what is drawn where"
Native 320×200 (mode 13h). Coordinates from `viceroy_source/docs/SCREEN_LAYOUTS.md` §1 (byte-verified
`[V]`, tier **B** — e.g. map viewport `(0,8,240,192)` @`func_06787C`, minimap panel `(241,8,79,41)`
`[V @0x066DD7]`). This supersedes the older overlay-measured `RENDERER_GEOMETRY.md` pass (tier A),
which was removed in the 2026-06-22 cleanup (it also carried a wrong "minimap = whole map squashed"
claim; the byte-verified minimap is a 1px/tile 56×39 scrolling window — see `INGAME_MAP_RENDER_TRACE.md`).

| Region | Pixel rect | Font | Color | Notes |
|--------|-----------|------|-------|-------|
| Top menu strip | (0, 0, 320, 9) | FONTTINY | green `ui_color_for(0x52,0x8A,0x31)`→(82,138,49) | glyph-grid; `ui_wood_fill(0,0,320,9)` bg. Item x-ranges from title widths (mechanism B; exact coords R) |
| Map viewport | (0, 8, 240, 192) | — (tiles) | per-tile palette | 15×12@16px (zoom 0); see §6.2 |
| Sidebar A — minimap | (241, 8, 79, 41) | — | viewport rect `0x0F`→white; dots from DG8(0x830..0x833) | `func_066CD6` (§6.1) |
| Sidebar B — season/gold/tax | (240, 72, 80, 64) | FONTTINY | white `0x0F`→(255,255,255) | per-line x,y overlay-resident (§6.3) |
| Sidebar C — selected-unit panel | (240, 136, 80, 64) | FONTTINY | white `0x0F` | sprite + `@INFO` labels; layout overlay-resident |

Sidebar variants: foreign-colony hover replaces panel C with name/nation/treasury + With:/Ask: trade lists (`SESSION_UI_CATALOG.md` §8). **A**

**Tile drawing chain (per CLAUDE.md hard rule #7) — re-verified 2026-06-21:** each tile drawn
by `func_O514 → func_O513 → func_O512`. `func_O512`'s 4-loop (`@file 0x68026`, `cmp [bp-4],4`)
iterates the 4 cardinal neighbors via dY table `[bx+0xae]` / dX table `[bx+0xa8]`, world coords
from `[0xa5a0]/[0xa5a2]`, on-screen test `lcall 0x181f:0x302`; `func_O513` (`@0x681D5`) decodes
terrain via `lcall 0x181f:0x6aa` → `[0xa8a2]`. `get_terrain_id_from_raw` (`@file 0x6204`)
confirms hard rule #3 byte-for-byte: `and al,0x1f` (`@0x620A`) then auto-forest for ids 8..23
(`and ax,7; or al,8` `@0x6225`). **B**.

## 3. Assets & text
- **Tiles:** **TERRAIN.SS = base ground**, composited under **PHYS0.SS overlays** (forest/river/mountain/hill/resource + the **water-tile coast composition**: shore `0x96` + 16×16 edges `0x97..0x99` or the 8×8 quadrant sub-tiles `0x6D..0x8B`); BDARK.SS is the only orphan (CLAUDE.md #5, amended 2026-06-22). **No road overlay** — the `0x6D` band once labelled "roads" is the coast sub-tile set (`map_system.md` §3, corrected 2026-06-22). Map units/colonies: ICONS.SS. Sidebar bg: WOODPANL.PIK. Cursor: CURSOR.SS. **A/B**
- **Menu text** (verified present in `data_extracted/text/MENU_sections.json`): keys `@GAME`, `@VIEW`, `@ORDERS`, `@REPORTS`, `@TRADE`, `@CUP` (CHEAT), `@PEDIA` (COLONIZOPEDIA). **B**
- **Sidebar labels** (verified in `LABELS_sections.json`): `@INFO` ("Moves:\nLocat:"), `@MISC` ("Gold", "Road", order statuses). Season from NAMES `@SEASONS`; terrain from NAMES `@FORESTED`/`@UNFORESTED`; unit type NAMES `@UNIT`, skill NAMES `@JOB`. All keys verified present. **B**
  - **RUNTIME-CONFIRMED 2026-06-25** (`docs/screens/06_ingame_map.png`): the live sidebar renders exactly this layout — `Spring 1498` (season/year), `Gold: 1000e Tax: 0%`, and the active-unit panel `Moves: 4 / Locat: (50, 42) / Eng. Caravel / No Orders / (Sea Lane)` with cargo `Veteran` + `100 Tools`. Visually validates the §6.3 positions and the `(Sea Lane)` base-terrain label (CLAUDE.md hard rule 2).

## 4. Interactions
- Top menu pulldowns (GAME/VIEW/ORDERS/REPORTS/TRADE/CHEAT/COLONIZOPEDIA) — items enumerated in MENU keys above. **B**
- REPORTS F2–F10 → advisor screens (see `advisor_reports.md`). **B**
- Click own colony tile → colony screen (`COLONY_RENDER_CHAIN.md` §2 entry chain: `func_L187 → set_active_colony (file 0x82DC) → lcall 0x191f:0x1de`). **B**
- Click foreign colony → sidebar trade view. **A**
- VIEW menu zoom levels (120×96 / 60×48 / 30×24 / 15×12) per `@VIEW`. **B**

## 5. Evidence
- `viceroy_source/docs/SCREEN_LAYOUTS.md` §1 — map HUD element table, byte-cited `[V]` (viewport, minimap panel/fill, status lines). **B** *(supersedes the removed overlay-only `RENDERER_GEOMETRY.md` "Map view v2/v3"; the sidebar R-table it held is preserved inline in §6.3 below)*.
- `docs/SESSION_UI_CATALOG.md` §1, §8 — layout, sidebar variants. **A**
- `docs/COLONY_RENDER_CHAIN.md` §3/§4 — tile chain, `0x6204` decoder, entry chain. **B**
- `data_extracted/text/MENU_sections.json`, `LABELS_sections.json`, `NAMES_sections.json` — menu/sidebar keys (all verified). **B**

## 6. Open questions — mostly CLOSED 2026-06-21 (none are truly runtime)
1. ✅ **World-minimap render function — LOCATED (B).** `func_066CD6_minimap_panel` (`@0x66CD6`;
   panel box `(0xF1,8,0x4F,0x29)`=(241,8,79,41) byte-verified `@0x66CF4`) → `minimap_draw_contents`
   (the sibling of the colony surround minimap). Owner→dot-color is the table at **DG8(`0x830..0x833`)**
   (`0x830` ocean/coast, `0x831` land, `0x832` fog `&0x80`, `0x833` owned `&0x20`); the white
   viewport rect uses idx `0x0F`. **Structure B**; the color *index values* `0x830..0x839` —
   **RESOLVED 2026-06-21 (B):** filled at init @0x751A2–0x751E7 by a byte-stream reader
   (`lcall 0x1A1F:0x88A` `@0x751A7`, store `mov [0x830],al` @0x751A7) after opening the section
   keyed **`COLORS`** (`push 0x22A7`="COLORS"@0x7518C). The source is **`NAMES.TXT @COLORS`**
   (line 471): the 9 bytes `68,149,8,128,47,138,134,128,138` =
   `basic,hilite,grey,enhance,shadow,select,border0,border1,border2`, written to
   `0x830,0x831,0x832,0x833,0x834,0x835,0x837,0x838,0x839` (`0x836` skipped). These are **palette
   indices into VICEROY.PAL** (6-bit) → e.g. `basic 68`→#559634 green, `hilite 149`→#C7A220 gold,
   `grey 8`→#555555; the low four (`0x830..0x833`) feed the minimap owner-dots. The same loader
   sequentially reads `@FOUNDING`, `@FATHERS`, `@COLORS`, `@INFO` from NAMES.TXT. (These are the
   UI text-color slots — **9** color bytes, not "10 owner/terrain" bytes.) Data-driven, **B**.
2. ✅ **Per-zoom viewport tile counts — CLOSED (B, computed).** Viewport setup `@0x6787C`:
   `SPAN_W[0x8544]=0xF<<zoom`, `SPAN_H[0x8546]=0xC<<zoom`, `TILE_PX[0x5AD4]=0x10>>zoom` (zoom =
   `[0x184]`, re-verified). zoom 0..3 = **15×12@16px / 30×24@8px / 60×48@4px / 120×96@2px** —
   exactly the four `@VIEW` "Zoom Level" entries; the overview mode (`[0x18A]≠0`) forces 5×5.
3. **Sidebar B/C per-line text (x,y)** — painted by overlay HUD thunks (`hud_print_6a/74/7e`,
   seg `191F/1A1F`) whose layout constants are **overlay-resident, not statically resolvable**
   (confirmed 2026-06-21: the `191F/1A1F:0x6a/0x74/0x88` thunk records do not parse cleanly from
   the rtlink trailer table — only `1A1F:0x7e`→file 0x3E162 resolves, and that is a treasury/tax
   turn routine, **not** a sidebar painter). So **no byte-verified (B) source exists** for these
   per-line constants; font is FONTTINY **B** and the displayed text is live UnitRecord/PowerRecord
   data, but the positions stay **TBD at B**.

   **Implementation layout (R — approximate, single-frame).** For a Layer-3 render that must only
   *look like* the original (not be byte-exact), the one available source is the pixel-measured
   sidebar table **preserved inline below** (originally from the removed `RENDERER_GEOMETRY.md`
   "Default map view sidebar", **frame 1310262984**, Scout selected). Use it as the **approximate**
   sidebar layout, explicitly **R** — it is a single
   eyeballed frame and is internally imperfect (its menu row even places CHEAT@244 right of
   COLONIZOPEDIA@234, and its minimap rect (244,8,72,44) is *superseded* by the byte-verified
   (241,8,79,41) of §6.1). Relative to the sidebar origin x≈240:

   | Line | x | y | Source string |
   |------|---|---|---------------|
   | Season/year | 244 | 58 | `Spring %YEAR` (NAMES `@SEASONS`) |
   | Gold | 244 | 66 | `Gold: %d%%` (LABELS `@MISC`) |
   | Tax | 290 | 66 | `Tax: %d%%` |
   | Unit sprite | 244 | 80 | ICONS.SS[unit_type] |
   | Moves: N | 270 | 82 | LABELS `@INFO`[0] |
   | Locat: (x,y) | 270 | 92 | LABELS `@INFO`[1] |
   | Unit type | 244 | 104 | NAMES `@UNIT`[type] |
   | Unit skill | 244 | 112 | NAMES `@JOB`[skill] |
   | Orders | 244 | 120 | LABELS `@MISC` (No Orders/Sentry/…) |
   | (Terrain) | 244 | 128 | NAMES `@UNFORESTED`/`@FORESTED` |

   These are the **only** non-invented coordinates available; an implementer must render *from this
   table* (citing it as R), never fabricate positions. Tightening to B requires either disassembling
   the `191F/1A1F` HUD thunks or pixel-measuring several frames to average out the single-frame error.
4. **Top-menu item hit-rects** — built by the `menubar` widget from **FONTTINY title widths**
   (glyph-grid), not a fixed table. The explicit x-origins (GAME@11 … COLONIZOPEDIA@261) come
   from the low-trust `_VICEROY_MODERN` C reconstruction (absent from the EXE) → those exact coords
   are **R**, the glyph-grid mechanism is **B**.
