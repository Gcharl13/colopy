# Colony Screen

> **Layer 2 — UI Specification.** Per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.

**Overall confidence:** composition + every panel-paint routine **decompiled** (tier **B**);
the building-placement tables, work-grid flag table, and active-colony pointer are
**raw-EXE-verified** (**B**); a handful of overlay-`0x181F` helpers (SoL% math, per-cell good
resolution, terrain classify, building frame-selection) remain **TBD**. · **Canonical
primary:** `ghidra_export/VICEROY_decompiled.named.c` (`colony_screen_render` line 16974 +
helpers), `raw/COLONIZE/VICEROY.EXE`, `docs/COLONY_RENDER_CHAIN.md`, `docs/RENDERER_GEOMETRY.md`.

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
- **SoL text color**: `thresh = clamp(-(difficulty-0xA), …, 0x32)`; color `0xF→4` if
  `thresh ≤ tory_count`, `→0xC` if `thresh·2 ≤ tory_count`. **B** (export 16478–86)
- **Stockpile qty** is plain **white** (`0xFF,0xFF,0xFF`), no color threshold. **B** (16794)
- **Build-cost table**: not referenced by any render routine; routed through `func_02D658`
  (warehousing). **R** (not re-verified here).

## 4. UI layout — "what is drawn where"
Native 320×200. Composition `colony_screen_render` (line 16974) draw order: clear → title →
work-grid → colonist row → stockpile → flag → minimap → SoL panel → buildings.

| Element | Rect / (x,y) | Sprite/sheet or text | Fn (line) | Tier |
|---------|--------------|----------------------|-----------|------|
| Title | centered, y=1, green RGB(0x52,0x8A,0x31) | name@rec+2, season, "…, Gold: N" | `colony_paint_title` 16935 | B |
| Buildings panel | box(0,7,199,128)+parch(0,8,199,120); slots at `0x266+i*4` | `BUILDING.SS` frame, `ss_blit_remap` | `colony_paint_buildings` 16841 | B |
| Work-grid (3×3) | cell `(col·0x18+0xC8, r·0x18+8)` | terrain scaled; good icon `good+0x17`; prof `0x52+prof`; unit figure | `colony_draw_workgrid` 15986 / `_terrain` 18730 | B |
| Colonist row | fill(0,0x82,0x78,0x30); baseline y=0x8E, adaptive spacing | colonist sprites; SoL faces 0x7C/0x7D | `colony_paint_colonist_row` 16361 | B |
| Production/warehouse bars | row at (2,0xA3,0x76,4) | `bar_queue_push`/`bar_row_flush` | 16440–71 | B |
| SoL panel | fill(0xD3,0x82,0x5B,0x30); "Sons of Liberty" y=0x86 / "No Ships In Port" y=0x8C, cream | text | `colony_paint_sol_panel` 16904 | B |
| Nation flag | fill(0x12F,0x84,0x11,0x2D) | flag sprite (blit elided in export) | `colony_paint_flag` 16874 | B (partial) |
| Surround minimap | fill(0x79,0x82,0x54,0x30); 28×19 tiles @3px, origin (121,132) | per-tile color from layers | `colony_paint_minimap` 16891 / `_contents` 18327 | B |
| Stockpile strip | fill(0,0xB3,0x140,0x15); 16 cells stride 0x13, icon y=0xB5, qty y=0xC1 | ICONS `good+0x16`; qty white | `colony_paint_stockpile` 16769 | B |

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

## 6. Open questions (TBD)
All remaining unknowns are **overlay-`0x181F`-resident helpers** — their call sites and
arguments are known; only their internals are TBD:
1. `overlay 0x181F:0x0C86` — SoL% computation.
2. `overlay 0x181F:0x0CE0(col,r)` — per-cell good/profession resolution (the exact bell/
   cross/anvil good-index values).
3. `overlay 0x181F:0x02E4` — colony unit-chain iterator.
4. `overlay 0x181F:0x3ca` — building bitmask→`BUILDING.SS` frame selection (placement table
   itself is byte-verified; only the frame index is TBD).
5. Build-cost table byte-verification vs `func_02D658` (warehousing).
6. Bell/SoL face exact ICONS.SS indices (0x7C/0x7D export-attested, not raw-confirmed).
