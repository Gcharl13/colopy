# In-game map render — byte-verified trace (authoritative)

Source of truth = **VICEROY.EXE in-game renderer** (user ruling 2026-06-22). This
documents what the EXE *actually does*, traced from bytes. It supersedes any
mapedit-derived guess where they conflict. Items marked **[V]** are byte-verified;
**[I]** are inferences from context (flagged, not asserted as fact).

## 1. The three in-memory map planes  **[V]**
O513 reads three far pointers, one byte each at the current tile:
- `[0xA598]` = **terrain** byte → `[0xA8A1]`. High bits: `0x20` hills/mtn, `0x40`
  river, `0x80` mountain(vs hill). `classify_terrain([0xA598])` → `[0xA8A2]` = visible id.
- `[0xA594]` = **feature** byte → `[0xA89F]`. Tested `&0x40` (0x96 marker), `&0x0A`
  (river network 0x51/0x52). Empty on stock .MP, so these rarely fire.
- `[0xA59C]` = **fog** byte → `[0xA8A0]`. Tested against fog mask `[0xA89E]`.

## 2. O513 per-tile draw order + sprite bases  **[V]** (`func_0681A8`)
(Sprite indices are GAME indices. My decoded PHYS0 frames are GAME index − 1, a
consistent numbering offset — so my code's 0x40/0x6C/0x96 == game 0x41/0x6D/0x97.)
1. **base ground** `emit_ground_sprite(land_base)` — TERRAIN.SS via the blitter,
   which applies `terrain_cell_transform`. land_base: plain Desert(id1)→**1**→frame1
   (bare); Scrub/forested-desert→**0x11**→frame8 (cacti). *(confirms desert/scrub.)*
2. **O512** `func_067F50` — called for BOTH land and water tiles.
3. **centre variant** `0x5A + overlay_718()` (overlay returns variant or −1).
4. **forest** `0x41 + func_067C8E(land_base,3)` (only forested, base≠1).
5. **river marker** `0x96` if `feature & 0x40`.
6. **hills/mtn** `(0x21 if 0x80 else 0x31) + func_067BE4(terrain&0xA0,2)` if `terrain&0x20`.
7. **river band** `(0x01 if 0x80 else 0x11) + func_067B84(0x40,3)` if `terrain&0x40`
   (isolated→0xF). NOTE base **0x01/0x11**, not 0x00.
8. **surf** `0x68` if `overlay_75E()`.
9. **river network** `0x51` (lone) or `0x52+i` per 8-dir bit, if `feature & 0x0A`.
10. **coast** [water tiles only]: from `analyse_connections` (`func_067A24`) which
    fills the 8-neighbour bitmap `[0xA8A6]` + per-quadrant table `[0x2D24]`:
    - clean diagonal (`conn&0xDD==0xC1`→0, `&0x77==0x07`→1, `&0x77==0x70`→2,
      `&0xDD==0x1C`→3): `0x97 + pattern` (one 16×16).
    - else 4 quadrants: `0x6D + [0x2D24+q]*4 + q`, positioned by sub-cell offset
      `[0x1EA4]/[0x1EA5]` = (0,0)/(8,0)/(8,8)/(0,8) for q=0..3 (NW,NE,SE,SW).
    - then `emit_terrain_sprite(water_id)` (backfill, see §3).

## 3. The blit model — `0x839E` is the per-tile composite buffer  **[V]**
All three primitives write into the 16×16 tile buffer at near-ptr `0x839E`
(`[0x839E+2]` = stride). Sprite index → TERRAIN frame via `terrain_cell_transform`
(`func_03436`, called inside the blitters):
- **`emit_ground_sprite`** (blit `0x181F:0x25E` → file 0x3460): `rep movsb` —
  **UNCONDITIONAL** copy. Fills the whole tile with the base terrain.
- **`emit_terrain_sprite`** (blit `0x181F:0x268` → file 0x34C4): copies a source
  pixel **only where the destination buffer == 0** (`mov al,es:[di]; or al,al; jne
  skip; movsb`). A **backfill** of the still-empty (0) pixels.
- **`draw_subcell`** (blit `0x181F:0x254` → file 0xE76A): clipped/sub-cell sprite
  blit from PHYS0 (`[0x174]`) for index ≥ 0x64, else `0x2F8`. Overlay sprites.

### Consequence: O512's "terrain blend" is a HOLE-BACKFILL  **[V]/[I]**
O512 per cardinal neighbour: `draw_subcell(0x69+dir stencil)` then
`emit_terrain_sprite(neighbour_class)`. The base ground already filled the buffer;
the `0x69+dir` dither stencil punches a pattern of 0-holes; `emit_terrain` then
backfills exactly those holes with the neighbour's terrain → the neighbour biome
is **dithered into the tile edge**. (Backfill is **[V]**; that the stencil writes
the 0-holes is **[I]** pending draw_subcell's color-key, to verify next.)

### Consequence for the COAST index-0 key  **[V]/[I]**
For a water tile, base = ocean (emit_ground), coast sub-tiles drawn, then
`emit_terrain_sprite(water_id)` backfills remaining 0-holes **with the water id =
ocean** — NOT with the nearest land terrain. So the game's coast key is OCEAN.
My `nearest_terrain_px` invention contradicts the game.

## 4. What my current renderer gets wrong / invented (vs §2–3)
- **Invented, not in game** (remove): `shore_to_sand` (green→sand recolor),
  `nearest_terrain_px`, the 1-tile-lake branch, river-to-sea (`river_link` water),
  L3 ocean/lake sand selection. The game draws ocean ground + sub-tiles + water
  backfill; there is no sand recolor or lake special-case in O513.
- **River band**: should be base `0x00/0x10` (my numbering) by bit 0x80, mask
  `func_067B84(0x40)`; I use `0x00` only.
- **Blend**: my `blend_land_edges` mimics the dither but via "draw neighbour where
  stencil dot" rather than the buffer backfill; geometry of the E/S/W stencil
  remap is my guess, not the game's `0x69+dir` order.
- Not drawn: centre variants `0x5A+`, surf `0x68` (need overlay_718/75E).

## 5. Chrome: wood, minimap, menu
- **Wood background** [V via docs/UI_RENDER_MAP.md + WOODTILE.SS startup table
  0x1FD42]: the game **tiles WOODTILE.SS** (1102-byte wood-grain tile) across the
  **top menu bar** (full width, y≈0..9) and the **right sidebar** (x≈240..320).
  The map viewport (0,8,240,192) is terrain. **My code wrongly blits WOODPANL.PIK
  as a full-screen background** — that's the wrong wood.
- **Minimap** `func_066CD6` [V]: region (0xF1,8,0x4F,0x29)=(241,8,79,41). Blits a
  **pre-rendered bitmap** at far-ptr `[0x2DA8]` (`lcall 0x181F:0xBA`), then draws
  the viewport rectangle (`lcall 0x181F:0xCE`) from scroll `[0x9CCA]/[0x9CCC]` and
  map bounds `[0x8804]/[0x8806]`, colours 0xFB/0x0F. The per-tile minimap colours
  live in that bitmap, built elsewhere (TBD: find the builder; likely a terrain→
  palette-index table, not a live frame-centre sample like mine).
- **Menu bar** [V via spec]: WOODTILE strip bg + FONTTINY green titles
  `ui_color_for(0x52,0x8A,0x31)`; item x from title widths. (Exact draw fn TBD.)

## Open items to reach 100%
1. `draw_subcell` color-key (does the `0x69+dir` stencil write 0-holes?) — verify the 0xE76A copy loop.
2. overlay `0x718` (centre variant) + `0x75E` (surf) semantics.
3. minimap bitmap builder (terrain→colour table at `[0x2DA8]`).
4. menu-bar draw function + WOODTILE tiling fn.
