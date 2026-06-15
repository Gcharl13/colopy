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
4        W*H bytes           layer 1: terrain
4+N      W*H bytes           layer 2: feature
4+2N     W*H bytes           layer 3: special  (land/water + resource)
4+3N     rest               trailer           (2 bytes = 0x0000 in AMER2)
```

with `N = width * height`.

For AMER2: `4 + 3 * (58*72) + 2 = 4 + 12528 + 2 = 12534` bytes — the exact file
size.

### Why header = 4 (not 6)

The alternative split (6-byte header, no trailer) gives the same total size,
so it is disambiguated by the **sea-lane border rule**: the left and right edge
columns must decode to terrain id 26 (Sea Lane). Measured on AMER2:

| split                | left column id 26 | result            |
|----------------------|-------------------|-------------------|
| **header 4 + tail 2**| 70 / 72 rows      | ✅ borders line up |
| header 6 + no tail   | 0 / 72 rows (all 25) | ❌ off by 2 tiles |

So the 4-byte header is correct and the 2 extra bytes are a trailer. The
reimplementation preserves the trailer verbatim (so unknown trailer content
never corrupts a round-trip) and writes a 2-byte zero trailer for new maps.

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

## Terrain byte (layer 1)

```
bits 0..4 : base terrain id (0..26)
bit  5    : prime-resource flag    (0x20)
bit  6    : road / river flag      (0x40)
bit  7    : forest sprite overlay  (0x80)
```

### Base terrain ids

| ids   | group        | source / confidence                                       |
|-------|--------------|-----------------------------------------------------------|
| 0..7  | UNFORESTED   | NAMES.TXT `@UNFORESTED` — Tundra,Desert,Plains,Prairie,Grassland,Savannah,Marsh,Swamp **(verified)** |
| 8..15 | FORESTED     | NAMES.TXT `@FORESTED`, paired with 0..7 — Boreal,Scrub,Mixed,Broadleaf,Conifer,Tropical,Wetland,Rain **(verified)** |
| 16..23| other land   | Arctic / Hills / Mountains + stock-map variants — **name↔id not yet byte-verified (TODO_VERIFY)** |
| 24    | (unused)     | absent from AMER2                                          |
| 25    | Ocean        | pinned via layer-3 water correlation **(verified)**        |
| 26    | Sea Lane     | water + edge-column rule **(verified)**                    |

The editor palette (what you can paint) is the 21 entries NAMES.TXT lists as
`@UNFORESTED` (8) + `@FORESTED` (8) + `@OTHER` (Arctic, Ocean, Sea Lane,
Mountains, Hills).

## Open items (do not affect round-trip)

- Exact names/ordering of land ids `16..23`.
- Exact trailer semantics (always 2 bytes? a record count?). Only `0x0000`
  observed; preserved verbatim either way.
- Layer-2 feature encoding beyond "mostly zero on a fresh map".

These can be pinned by decompiling MAPEDIT's overlay write path (`write.obj`)
or by diffing saves produced by the original under DOSBox.
