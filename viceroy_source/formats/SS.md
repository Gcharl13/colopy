# SS Format — Sprite Sheet (MS_SPRITE)

## File inventory
- 206 .SS files in COLONIZE/, e.g. PHYS0.SS, ICONS.SS, BUILDING.SS,
  TERRAIN.SS, BDARK.SS, COLONY1.SS, CITY.SS, WOODFRAM.SS, WOODTILE.SS,
  CC-00.SS through CC-24.SS (Founding Father portraits)

## Format

Each .SS file is a sprite-sheet container. Multi-sprite layout (MS_SPRITE).

```
+---------------------------------------------------------------+
| 8-byte zero magic         00 00 00 00 00 00 00 00              |
+---------------------------------------------------------------+
| LE16 width                                                     |
| LE16 height                                                    |
+---------------------------------------------------------------+
| 13 metadata bytes         (purpose TBD; varies per file)       |
+---------------------------------------------------------------+
| 25-byte header total                                           |
+---------------------------------------------------------------+
| Per-sprite stream: each sprite is RLE-encoded as a list of     |
| rows. Each row is:                                             |
|   LE16 skip       transparent pixels at the start              |
|   LE16 run_count  number of opaque pixels                       |
|   byte[run_count] palette indices (0 = transparent placeholder) |
+---------------------------------------------------------------+
```

The 8-byte zero magic identifies this as the "MS_SPRITE" format used
by the MicroProse MADS engine. The 25-byte header is consistent with
what the Win16 build's coldata0/3/5/6/8 DLLs use; coldata4 has a
different `c0fe...` prefix (a separate codec, not yet covered).

## Sprite count

The sprite count is NOT in the header. The decoder walks the byte
stream until EOF, counting sprites. Specific files have known counts:

| File         | Sprites | Notes                                       |
|--------------|---------|---------------------------------------------|
| ICONS.SS     | 131     | All units, ships, buildings, cargo icons    |
| PHYS0.SS     | 154+    | Terrain edges, roads, rivers, beach halos  |
| BUILDING.SS  | not yet decoded     | Colony-screen building sprites              |
| TERRAIN.SS   | 12+     | Per-terrain texture tiles                   |
| WOODFRAM.SS  | not yet decoded     | Wood frame UI border                         |
| WOODTILE.SS  | not yet decoded     | Wood tile UI background                      |
| BDARK.SS     | not yet decoded     | Suspected orphan, NEVER LOADED at runtime   |
| CC-NN.SS     | varies  | Founding Father portraits (NN = age slot)   |

## Loader

The decoded loader is in the Python port at
`colonize_sdl/sprites.py` (the `load_ss()` function). The DOS-side
loader is in the overlay; specific function offset not yet decoded pending overlay
cross-reference.

## Verification

The format has been verified byte-perfect against the original:
- `tools/extract_ss.py` decodes a .SS file to a directory of PNG sprites
- `tools/encode_ss.py` repacks them; SHA256 of result matches original
- 206/206 .SS files round-trip cleanly except for `BDARK.SS` (suspected
  orphan that never loads in the running game)

## Citations

- @python    ../../../colonize_sdl/sprites.py
- @python    ../../../tools/extract_all.py  (the SS decoder section)
- @verified  Round-trip byte-equal for 205/206 files
- @ref       ../../../SPRITE_CATALOG.md  -- per-sprite role mapping
- @rule      Per CLAUDE.md hard rules: NEVER LOAD `BDARK.SS` (suspected orphan)
- @rule      `func_O530` is the map-editor dialog, NOT the in-game tile
             renderer. The real chain is `func_O514 → O513 → O512`.

## Special notes (from past pain points, see docs/RULINGS.md)

- **PHYS0 sprite indices 0, 16, 100** are 1×1 placeholders. They do
  NOT contain real sprites. Their absence in atlases is expected.
- **PHYS0 rows 0x01 and 0x11** are RIVER sprites (blue with green banks),
  NOT coast edges. True coasts are sprites 150-153.
- **PHYS0 row 0x21** = mountains (snow peaks). Row 0x31 = hills (brown).
- **TERRAIN.SS** IS used by the renderer (re-extracted 2026-04-25).
- **CC-NN.SS** are Founding Father portraits, NOT unit map sprites.
  Unit map sprites come from ICONS.SS at indices 100-105 + 109 (foot
  units) and 5-7 / 14-15 / 127 (ships).
