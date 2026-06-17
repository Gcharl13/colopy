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
bit  6    : river               (0x40)   — O513 6d draws PHYS0 0x96
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

## Sprite rendering (from the real game art)

- **base ground**: TERRAIN.SS frame = `terrain_cell_transform(land_base)`
  (resident func_03436: `0x11/0x09→8`, `≥8→code-0xF`, else code).
- **forest** ids 8..23: PHYS0 `0x41 + forest-neighbour mask`.
- **hills/mtns** bit 0x20: PHYS0 `0x31` (hills) / `0x21` (mtn) `+ nmask4_feat_hi`.
- **river** bit 0x40: PHYS0 `0x96` (blue water + tan banks).
- **coast** (water tiles only, MAPEDIT `0xC665` + `0xBC1E`): from the 8 neighbours'
  land/water build a connectivity bitmap + per-quadrant config; a clean diagonal
  pattern draws the full-tile beach PHYS0 `0x97+pattern` (`0x97..0x99`; `0x9A` absent),
  else 4 quadrant 8×8 sub-cells PHYS0 `0x6D + config*4 + q` at NW/NE/SE/SW. The
  sub-cells encode "ocean shows here" as solid black (`0x6D..0x6F`), so pure-black
  source pixels are colour-keyed to the ocean base below — the same result the game
  gets by re-emitting the ocean sprite after the sub-cells.
- Each `.SS` uses its **own embedded palette** (VICEROY.PAL as a global DAC
  palette mis-colours the sprite indices → verified garbage).

## Open items (do not affect round-trip)

- The reserved 3rd header word's meaning (always 4 observed).
- Layer-2 (feature) runtime encoding (empty on a fresh map).
