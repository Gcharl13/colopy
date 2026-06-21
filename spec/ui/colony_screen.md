# Colony Screen

> **Layer 2 — UI Specification.** Per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.

**Overall confidence:** composition + every panel-paint routine **decompiled** (tier **B**);
placement tables, work-grid flag table, active-colony pointer **raw-EXE-verified** (**B**); and
the overlay-`0x181F` helpers (SoL% math, per-cell good→sprite, unit iterator, build frame-select)
are now **all traced (B)** — see §6. · **Canonical primary:**
`ghidra_export/VICEROY_decompiled.named.c` (`colony_screen_render` line 16974 + helpers),
`raw/COLONIZE/VICEROY.EXE`, `docs/COLONY_RENDER_CHAIN.md`, `docs/RENDERER_GEOMETRY.md`.

> **Corrections (2026-06-21):** (a) the per-element draw code is **NOT** in an
> "un-extracted overlay 0x191F → TBD" — the composition `colony_screen_render` and all paint
> routines are fully decompiled, and the building/work-grid/minimap offsets are
> byte-verified. (b) The overlay segment is **`0x181F`**, not `0x191F`. (c) The surrounding
> minimap is **28×19 tiles**, not a "3×3 surround"; the 3×3 is the *work grid*.

## 1. Purpose
The colony management screen (Plymouth in the session snaps): the colony scene with placed
buildings, a 3×3 work grid of surrounding worked tiles, a colonist row, a Sons-of-Liberty
panel, a 28×19 surround minimap, and a bottom 16-commodity warehouse strip. Entered by
clicking an own colony. Active colony = the far pointer at `[0x8542]` (`+0`=cx, `+1`=cy),
byte-verified (`mov bx,[0x8542]` @0x26176). **B**

## 2. State & data layout
| Field | Meaning | Tier | Evidence |
|-------|---------|------|----------|
| `[0x8542]` | active ColonyRecord far ptr; `+0`=cx, `+1`=cy | B | EXE @0x26176 / @0x27081 |
| `0x0266` (word, stride 4, ×15) | building screen-pos: x@`+0`, y@`+2` (+8) | B | EXE @0x27087/0x2708b |
| `0x8D62` (byte ×15) | building-type per slot | B | EXE @0x27095 (`[bx-0x729e]`) |
| `0x8E82` (byte ×15) | building-level per slot; `<0` ⇒ slot empty | B | EXE @0x2709d (`[bx-0x717e]`, `cwde; jl skip`) |
| `0x8DF0` (stride 5) | work-cell flag table, bits 0x40/0x80/0x08 | B | EXE @0x2616c (`[bx+si-0x7210]`) |
| `0x8D9E` (stride 5, signed) | work-cell secondary table | B | export 16022 |
| `ctx->stockpile_9a[16]` | warehouse qty per good | B | export 16780 |
| `g_panel_mode_337` | SoL-panel mode (0=SoL,1=No Ships,2=blank) + flag nation | B | export 16880/16912 |
| `c->population` + `0x8D72` | colonist-row count | B | export 16373 |

## 3. Formulas & rules
- **Building slot loop** (byte-verified @0x27067): `for i in 0..14:
  x=DGS16(0x0266+i*4); y=DGS16(0x0268+i*4)+8; type=DGS8(0x8D62+i); lvl=DGS8(0x8E82+i);
  if lvl<0 skip; else blit at (x,y)`. **B**
- **Building frame selection**: the EXE building loop (a second site @0x29ec4) delegates the
  bitmask→`BUILDING.SS` frame choice to **overlay `0x181F:0x3ca`** with type sub-tables; the
  decompiled C uses `frame=level` + a **≤2×2 placeholder walk-back** (`while frame & ≤2×2:
  frame--`). Placement = **B**; exact frame index = **R/TBD** (overlay helper).
- **Work-grid cell geometry**: `cell_x = col·0x18 + 0xC8`, `cell_y = r·0x18 + 8`; 3×3 inner
  of a 5×5 (border cols/rows 0 and 4 skipped). **B** (origin/stride byte-adjacent @0x2617f).
- **Surround minimap**: 28×19 tiles at 3 px each, origin (121,132), center pixel color 0x0F,
  per-tile color from map layers (`colony_render_minimap_contents`, export 18327). **B**
- **SoL%** (per-colony Sons-of-Liberty, `0x181F:0x0C86 → @file 0x8524`, re-verified):
  `sol = (colony[+0xC2]·100) / colony[+0xC6]` (32-bit, mul `0xD1D:0xF60` / div `0xD1D:0xEC6`),
  then **+20** if the colony's power is human-controlled (`[+0x1A]<4` and
  `byte[power·0x34 + 0x543F]==0`), clamped to 100. **B** (matches `systems/colony.md`
  `sol_membership_pct`; feeds the national meter `[0x53D0]`). SoL *text* color: `0xF→4` if
  `thresh ≤ tory_count`, `→0xC` if `thresh·2 ≤ tory_count` (export 16478–86). **B**
- **Stockpile qty** is plain **white** (`0xFF,0xFF,0xFF`), no color threshold. **B** (16794)
- **Building frame select** (`0x191F:0x66C → @file 0x26DD4`): **`frame = building_type + 1`**
  (type from `0x8D62`), with composite frames `0x2F`/`0x30` for the Stockade/wall pair; level
  overlay via `0x2CA46`/`0x181F:0x236`. (Correction: `0x181F:0x3CA → 0x4B16` is a **rectangle
  bounds hit-test** `(x,y,w,h)` vs clip `[0x7E8]/[0x7EA]`, **not** frame-select — re-verified.)
  **B** (offset/bounds) / **R** (the type+1 frame map; the EXE keys on *type*, not the
  decompiler's `frame=level` stub).
- **Build-cost** is **data, not code**: per-building hammer/tool costs live in NAMES.TXT
  `@BUILDING` (legend `name, hammers, tools×10, size, min_colony, upkeep`; DGROUP table
  `0x8F8C`). `func_02D658` *reads* `@BUILDING[+0x94]` and gates the two hammer banks
  (`+0x92`/`+0xB6`) — it does not hold a cost table. Stockade **64H**, Warehouse **80H**,
  Printing Press **52H+20T** all byte-confirmed. **B**

## 4. UI layout — "what is drawn where"
Native 320×200. Composition `colony_screen_render` (line 16974) draw order: clear → title →
work-grid → colonist row → stockpile → flag → minimap → SoL panel → buildings.

Colors are EUROPE.PIK palette indices → RGB (B); fonts are screen-latched (A, see
`fonts_and_colors.md`).

| Element | Rect / (x,y) | Sprite/text | Font | Color → RGB | Fn (line) |
|---------|--------------|-------------|------|-------------|-----------|
| Title | centered, y=1 | name/season/"…, Gold: N" | **FONTTINY** (`push [0x89E]` @0x25F62 — *not* FONTKING; RULING 2026-06-21) | `ui_color_for(0x52,0x8A,0x31)`→(82,138,49) green¹ | `colony_paint_title` 16935 |
| Buildings panel | box(0,7,199,128)+parch | `BUILDING.SS` frame, `ss_blit_remap` | — | — | `colony_paint_buildings` 16841 |
| Work-grid (3×3) | cell `(col·0x18+0xC8, r·0x18+8)` | terrain; good icon `good_idx+0x17`; prof `0x52+prof`; yield "N" | FONTTINY (yields) | yield `0x0F`→white | `colony_draw_workgrid` 15986 / `_terrain` 18730 |
| Colonist row | fill(0,0x82,0x78,0x30); baseline y=0x8E | colonist sprites; sel box | — | sel box `0x0F`/`0x0A`→white/(85,255,85) | `colony_paint_colonist_row` 16361 |
| SoL% text | rebel x=face+2 / tory x=face−tw, y=0x85 | "N%% (R)" / "N%% (T)" | **FONTTINY** (colony render latch — *not* FONTKING) | **`0x0F`→white**, →**`0x04`(170,0,0)** if tories≥thresh, →**`0x0C`(255,85,85)** if ≥2·thresh | 16478–16512 |
| Rebel/Tory faces | 0x7C@(2,0x84) / 0x7D@(face_x,0x84) | ICONS.SS sprites **0x7C/0x7D** (frame ids, not colors) | — | — | 16492/16514 |
| SoL panel label | fill(0xD3,0x82,0x5B,0x30); "Sons of Liberty" y=0x86 / "No Ships" y=0x8C | text | **FONTTINY** (colony render latch — *not* FONTKING) | `ui_color_for(0xF0,0xE0,0xB0)`→(240,224,176) cream | `colony_paint_sol_panel` 16904 |
| Nation flag | fill(0x12F,0x84,0x11,0x2D)=(303,132,17,45) | **ICONS sprite `0x44`** (`push 0x44 @0x28558`), frame = nation byte `[0x337]`/`[0x339]` | — | — | `colony_paint_flag` 16874 (`@file 0x2853C`) |
| Surround minimap | fill(0x79,0x82,0x54,0x30); 28×19 @3px, origin (121,132) | per-tile color from layers | — | per-tile (map layers) | `colony_paint_minimap` 16891 / `_contents` 18327 |
| Stockpile strip | fill(0,0xB3,0x140,0x15); 16 cells stride 0x13, icon y=0xB5, qty y=0xC1 | ICONS `good+0x16`; qty | FONTTINY | qty `0x0F`→white | `colony_paint_stockpile` 16769 |

¹ EXE/C emits green `RGB(0x52,0x8A,0x31)`; the pixel capture in `docs/UI_FONT_REFERENCE.md`
reads the title as **yellow (218,178,0)**. EXE bytes win per CLAUDE.md, but the per-draw font/
color handle is screen-latched (not per-blit), so title-as-rendered is **A** — a noted discrepancy.

## 5. Evidence
- `ghidra_export/VICEROY_decompiled.named.c`: composition 16974; buildings 16841/16573;
  workgrid 15986/18730; colonist-row 16361; stockpile 16769; flag 16874; minimap 16891/18327;
  SoL 16904; title 16935. **B**
- `raw/COLONIZE/VICEROY.EXE` (capstone 16-bit): building loop @0x27067–0x270b1 (tables
  0x266/0x268/0x8D62/0x8E82, count 15, signed-skip — re-confirmed this pass); second loop
  @0x29ec4 delegating frame-select to overlay `0x181F:0x3ca`; work-grid loop @0x2616c (flag
  table 0x8DF0, `[0x8542]` cx/cy). **B**
- `docs/COLONY_RENDER_CHAIN.md`, `docs/RENDERER_GEOMETRY.md` "Colony screen (VERIFIED v3)". **B/A**
- `data_extracted/text/{NAMES,LABELS}_sections.json` — `@CARGO`, `@CTITLE`, `@BUILDING`, `@MISC`. **B**

## 6. Open questions — RESOLVED 2026-06-21
The overlay-`0x181F` helpers were all traced statically (no dump needed; thunks resolved via
`tools/follow_thunk.py` to clean function bodies):
1. ✅ **SoL%** `0x181F:0x0C86 → @0x8524` — `(colony[+0xC2]·100)/colony[+0xC6]` +20 human latch,
   clamp 100 (§3). **B.**
2. ✅ **Per-cell good** `0x181F:0x0CE0 → @0x8956` — returns `colony[slot+0x70]` (good-index);
   **production sprite = `good_idx + 0x17`**. Production-good indices (after the 16 `@CARGO`
   goods 0..15): **Hammers = 16 → sprite 0x27**, **Crosses = 17 → 0x28**, **Liberty Bells = 18
   → 0x29**, Food = 0 → 0x17; alt-bells icon forced to **0x3A** when the cell good == 8.
   (Stockpile strip uses `good+0x16`, one less than the production base.) **B.**
3. ✅ **Unit iterator** `0x181F:0x02E4 → @0x66BA` — unit-record accessor, stride `0x1C`, base
   DGROUP `0x315E`. **B.**
4. ✅ **Building frame select** — `frame = type+1` (`0x191F:0x66C → @0x26DD4`); `0x3CA` was a
   bounds hit-test, not the selector (corrected, §3). **B/R.**
5. ✅ **Build-cost** — data in NAMES.TXT `@BUILDING` (DGROUP `0x8F8C`); Stockade 64H / Warehouse
   80H / Printing Press 52H+20T confirmed (§3). **B.**

*SoL-face / nation-flag ICONS.SS indices — CLOSED 2026-06-21 (B):* SoL faces `0x7C`/`0x7D`
(byte-cited §2, `@0x28492`/`@0x28514`) and the **nation flag = ICONS sprite `0x44`** (`push 0x44
@0x28558` in `colony_paint_flag` `@0x2853C`, fill rect (303,132,17,45), frame = nation byte
`[0x337]`/`[0x339]`). No soft residual remains for this screen.
