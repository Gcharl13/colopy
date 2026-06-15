# Map render chain — decode spec (terrain / coast / river / mountain)

This consolidates the **byte-verified** terrain renderer of VICEROY.EXE so both
this editor and the `viceroy_source` reimplementation draw the map the same way.
Sources: `viceroy_source/src/render/{tile_chain,terrain}.c` and
`viceroy_source/docs/{MAP_COMPOSER_SPEC,RENDER_GROUNDTRUTH}.md` on the
`beautiful-maxwell` branch (hand-decompiled from `page_15.asm`), cross-checked
here against the real PHYS0.SS/TERRAIN.SS frames (decoded by `src/ss.c`).

## Pipeline

```
func_O514  (0x685DC)  viewport walk: for each visible tile, set the per-tile
                      working pointers + screen origin, then call O513
  -> func_O513 (0x681A8)  per-tile emitter: classify, fog-test, emit the sprite
                          stack in z-order (below)
       -> func_O512 (0x67F50)  water-tile sub-cell coast composer
```

Three parallel byte layers (same as the `.MP` file): **terrain**, **feature**,
**resfog**. A tile's render reads its own 3 bytes plus its neighbours' bytes.

## Sprite sheets

- **TERRAIN.SS** — base textured ground, indexed by the *land_base* id.
  (`emit_ground_sprite`, sheet ptr `[0x16C]`.)
- **PHYS0.SS** — every overlay/edge sprite, indexed by the bases below.
  (`draw_tile_marker`/`emit_terrain_sprite`, sheet ptr `[0x174]`.)

PHYS0 frame index == decoded frame number (verified visually; `src/ss.c` frames):

| base        | role (confirmed)                              |
|-------------|-----------------------------------------------|
| `0x21+m`    | **mountains** body (m = `nmask4_feat_hi`)     |
| `0x31+m`    | **hills** body                                 |
| `0x41+m`    | **forest** canopy (m = `nmask4_forest`)        |
| `0x51`      | lone **river** source                          |
| `0x52+i`    | directional **river** (i = 8-dir bit)          |
| `0x5A+v`    | terrain **centre** variant (v = table below)   |
| `0x68`      | coast **surf** detail                          |
| `0x69+dir`  | water→land **coast transition** (O512, dir 0..3) |
| `0x6D+4·t+d`| **roads** (t = per-dir road-table, d = dir)    |
| `0x95`/`0x96`| active-tile / river-on-terrain markers        |
| `0x97+p`    | straight **coast** (p = clean-pattern 0..3)    |

## classify_terrain + centre variant

`classify_terrain(raw)` maps the raw terrain byte (low 5 bits, auto-forest at
0x6204) to a *visible id*. The centre sub-cell sprite is `0x5A + variant`:

```
TERRAIN_CENTER_VARIANT[29] (centre sprite = 0x5A + v; v=-1 => none):
  0 Ocean 6 | 1 SeaLane 1 | 2 Tundra 2 | 3 Desert 3 | 4 Plains 4 | 5 Prairie 5
  6 Grass 6 | 7 Savannah 6 | 8 Marsh 9 | 9 Swamp 1 | 10 Boreal 8 | 11 Scrub 9
  12 Mixed 10 | 13 Broadleaf 10 | 14 Conifer 6 | 15 Tropical 6 | 16 Wetland 9
  17 Rain 1 | 18..23 (ext) 8,9,10,10,6,6 | 24 Arctic -1 | 25 Ocean 7
  26 SeaLane -1 | 27 Hills 12 | 28 Mountains 13
```

## Neighbour masks (terrain.c, byte-verified)

Direction tables: DIR4 order **N,E,S,W**; DIR8 order **N,NE,E,SE,S,SW,W,NW**.

- `nmask4_terrain(mask)` — for the 4 cardinal terrain neighbours, OR in
  **N=8 S=4 W=2 E=1** when `(neighbour & mask)`.
- `nmask8_terrain(mask)` — 8 directions, bit *i* per DIR8 order.
- `nmask4_feature(mask)` — same as nmask4 but on the feature layer.
- `nmask4_feat_hi(self&0xA0)` — N=8/S=4/W=2/E=1 when `(neighbour&0xA0)==self_hi`
  (0xA0 = mountain 0x80 | rough 0x20: matches same-class hill/mountain runs).
- `nmask4_forest()` — 4-cardinal forest-base neighbour mask.
- `analyse_connections()` — fills the road/river connectivity bitmap `[0xA8A6]`
  and the per-dir road table `[0x2D24]`.

## O513 z-order (closest zoom)

For a visible tile, emit in this order (each `draw_*` is one PHYS0/TERRAIN blit):

1. **base ground** — water id (0x19/0x1A) or `land_base` (= `vis<0x18 ? vis&7 :
   vis`, with the Plains/Prairie group forced to `0x11`) via `emit_ground_sprite`.
2. **forest** (vis 0x08..0x17, land_base≠1): `0x41 + nmask4_forest()`.
3. **river-on-terrain** marker (terrain & 0x40): `0x96`.
4. **hills/mountains** (feature & 0x20, non-water): `0x21+m` (feature&0x80) else
   `0x31+m`, m = `nmask4_feat_hi(feature&0xA0)`.
5. **shore** (feature & 0x40, non-water): `(feature&0x80?1:0x11) +
   nmask4_feature(0x40)` (or `+0xF` when the mask is 0).
6. **centre + coast detail** (zoom 0): `0x5A + special_feature_at(...)`; then
   `0x68` when `river_detail_at(...)`.
7. **river network** (terrain & 0x0A, non-water): `0x51` if
   `nmask8_terrain(0x0A)==0`, else `0x52+i` for each set 8-dir bit.
8. **roads / straight coast** (non-water): if the connectivity bitmap matches a
   clean pattern — `(conn&0xDD)==0xC1→0`, `(conn&0x77)==0x07→1`,
   `(conn&0x77)==0x70→2`, `(conn&0xDD)==0x1C→3` — emit `0x97+pattern`; else emit
   the 4 directional road pieces `0x6D + 4·roadtable[dir] + dir`.

**Water tiles** (vis 0x19/0x1A) skip 2–8 and hand off to **O512**, which walks
the 4 cardinal neighbours and, for each non-water (land) neighbour, emits a
coast transition `0x69 + pass` then the neighbour's classified ground — this is
what paints the beach halo around every coastline.

## Interface (RENDER_GROUNDTRUTH.md)

Native frame is **320×200** (mode 13h). Map view = 15×12 tiles × 16px with the
chrome around it:

- **Top menu bar**: wood strip (WOODTILE.SS), green `#528A31` labels left
  (`GAME VIEW ORDERS REPORTS TRADE`) + gold/`COLONIZOPEDIA` right.
- **Right sidebar** (wood): minimap (orange border) → season/gold/tax line →
  active-unit panel → cargo rows.
- UI colours: green text `#528A31`, gold/highlight `#E3AA28`, selection bar
  `#382010`, panels = WOODTILE planks. Each PIK/SS carries its own palette;
  resolve UI colours to the nearest live-palette entry at draw time.

MAPEDIT's own chrome differs (its menus are `Editor/View/Map/Help` per
MAPMENU.TXT) but the **terrain rendering and 16px tile scale are shared** — that
is the part this spec pins for reuse.
