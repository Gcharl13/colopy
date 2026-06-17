# `.MP` Map File Format — verified spec

This is the byte layout the modern reimplementation reads and writes. It is
derived **directly from the stock map `AMER2.MP`** (the file VICEROY loads for
the standard scenario, and the kind of file MAPEDIT creates/edits), and is
exercised by an automatic byte-exact round-trip test (`make test`).

## Layout

```
offset   size              field
-------  ----------------  --------------------------------------------------
0        u16  little-endian  width            (58 in AMER2)
2        u16  little-endian  height           (72 in AMER2)
4        u16  little-endian  reserved         (4 in AMER2; preserved verbatim)
6        W*H bytes           layer 1: terrain
6+N      W*H bytes           layer 2: feature  (empty on AMER2 — runtime layer)
6+2N     W*H bytes           layer 3: special  (land/water + resource)
```

with `N = width * height`.

For AMER2: `6 + 3 * (58*72) = 6 + 12528 = 12534` bytes — the exact file size,
no trailer.

### Why header = 6 (not 4) — pinned by ground truth

A 4-byte-header + 2-byte-trailer split gives the same total size, so it is
disambiguated by the **original program's own output**: MAPEDIT.EXE displays
tile (29,36) as "(Hills)". That tile decodes to Hills (id 21, +0x20, !0x80)
**only** under a 6-byte header. A 4-byte header shifts every tile by 2 and
mis-decodes it (id 23, +0x80 → wrongly a mountain). The 6-byte header also
yields a uniform ocean border on both edge columns. (An earlier 4-byte
hypothesis was wrong — it mistook the 2 header bytes for a trailer.)

## Three planar layers

The layers are separate arrays, not interleaved. Measured on AMER2:

| layer | role                | distinct values | notes                                   |
|-------|---------------------|-----------------|-----------------------------------------|
| 1     | terrain (packed)    | 87              | base id + overlay bits (below)          |
| 2     | feature             | 2               | almost all 0 (features added in-game)   |
| 3     | special/land-water  | 15              | 0=border, 1=water, 2=land, 3..14=resource |

The layer-3 land/water classifier was the key that pinned the water terrain
ids: every layer-1 id `0..23` appears only on `land`/`border` tiles, while ids
`25` and `26` appear only on `water` tiles.

## Terrain byte (layer 1) — verified against the render chain + ground truth

```
bits 0..4 : base terrain id (0..26; 8..23 = forest variants)
bit  5    : hills / mountains   (0x20)   — VICEROY O513 6e reads this
bit  6    : river               (0x40)   — draws PHYS0 river row 0x00 + mask
bit  7    : mountain (vs hills)  (0x80)   — with bit 0x20: set=mtn, clear=hills
```

Confirmed by tile (29,36) = `0x35` = id 21 + 0x20, !0x80 → "(Hills)", which is
exactly what the original MAPEDIT shows there. (The earlier labels
prime/road/forest were wrong; forest is encoded by *id*, not a bit.)

### Base terrain ids

| ids   | group        | source / confidence                                       |
|-------|--------------|-----------------------------------------------------------|
| 0..7  | UNFORESTED   | NAMES.TXT `@UNFORESTED` — Tundra…Swamp **(verified)**      |
| 8..23 | FORESTED     | forest variants; `classify_terrain` (func_006204) collapses 8..23 → 8..15 in map view (mode 2). Base ground = unforested(id&7); canopy = PHYS0 0x41+ **(verified)** |
| 24    | Arctic       | (absent from AMER2)                                        |
| 25    | Ocean        | pinned via layer-3 water correlation **(verified)**        |
| 26    | Sea Lane     | water + edge-column rule **(verified)**                    |

Hills/mountains are an overlay flag (bit 0x20) on any base, not a base id.

## Sprite rendering (PHYS0 indices are PIXEL-VERIFIED rows — see notes/SPRITE_CATALOG.md)

Each PHYS0 overlay occupies a 16-sprite **row**; a 4-cardinal neighbour mask
(0..15) indexes WITHIN the row, so the base MUST be the row start or a fully-
surrounded tile (mask 15) overflows into the next row. Pixel-verified rows:
`0x20` mtn · `0x30` hills · `0x40` forest · `0x50` **roads** (never drawn here) ·
`0x6C..0x6F` 8×8 **black null padding** · `0x70..0x7F` 8×8 coast sub-tiles ·
`0x90..0x99` coast / corner-beaches.

- **base ground**: TERRAIN.SS frame = `terrain_cell_transform(land_base)`
  (resident func_03436: `0x11/0x09→8`, `≥8→code-0xF`, else code).
- **forest** ids 8..23: PHYS0 `0x40 + forest-neighbour mask` (row 0x40).
- **hills/mtns** bit 0x20: PHYS0 `0x30` (hills) / `0x20` (mtn) `+ nmask4_feat_hi`.
  (The earlier `0x41/0x31/0x21` bases pushed mask-15 tiles into the ROAD row 0x50 —
  the "road sprites on terrain" bug.)
- **river** bit 0x40: PHYS0 river row `0x00 + continuity mask` (green/tan banks).
  (NOT `0x96`, which is pixel-verified as a *corner-beach* coast sprite.)
- **coast** (water tiles only): the corner-beach sprites `0x96..0x99` ("ocean with
  sand toward a corner/edge") oriented by mirroring toward the land-facing sides
  (cardinal land-neighbour mask). The exact mask→sprite+flip table lives inside
  MAPEDIT's `_buffer_tile` compositor and is verified visually. NEVER the black
  null-padding frames `0x6C..0x6F`.
- Minimap: a 56×39 tile **window** at 1px/tile (MAPEDIT `_generate_mini` /
  `_blast_mini`), scroll origin = clamp(view-centre − {28,19}, …) following the
  view in both axes; each pixel = sampled representative colour (`_get_tile_colors`).
- Menu chrome: flat bar, colours = palette indices from MAPEDIT.EXE's
  `_menu_bar_*` globals (text 0 / bar 7 / disabled 8 / hilite 15) on the standard
  VGA 16-colour ramp; small font (FONTTINY), not the ornate FONTINTR.
- Each `.SS` uses its **own embedded palette**; VICEROY.PAL supplies UI-chrome
  indices ≥16 only.

## Open items (do not affect round-trip)

- The reserved 3rd header word's meaning (always 4 observed).
- Layer-2 (feature) runtime encoding (empty on a fresh map).
