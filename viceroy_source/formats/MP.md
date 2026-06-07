# MP Format — Map File

## File inventory
3 .MP files in COLONIZE/:
- `AMER2.MP` (12,534 bytes) — the Americas map (default scenario)
- `ONE.MP` — minimal test map
- `BLANK4.MP` — empty 4-tile-wide test map
- `UNTITLED.MP` — small custom map
(Player-saved maps go in saves/ rather than COLONIZE/.)

## Dimensions
- 58 columns × 72 rows in file (4,176 tiles)
- Playable area: columns 1-56, rows 0-71 (56×72 = 4,032)
- Columns 0 and 57 are sea-lane border (terrain type 26)

## Format

```
+---------------------------------------------------------------+
| Magic + header (TBD bytes — exact size pending verification)  |
+---------------------------------------------------------------+
| Layer 1: Terrain    (4,176 bytes = 58 × 72)                   |
|   Each byte = packed terrain attributes (see below)            |
+---------------------------------------------------------------+
| Layer 2: Features    (4,176 bytes)                             |
|   Roads, rivers, lost city rumors                               |
|   At game start: all zeros on AMER2.MP — features are added    |
|   during gameplay                                                |
+---------------------------------------------------------------+
| Layer 3: Resource overlay (4,176 bytes)                       |
|   0 = border/empty                                              |
|   1 = water tile (deep ocean / coast)                          |
|   2 = land tile, no special resource                            |
|   3-14 = resource id (matches NAMES.TXT @RESOURCE)             |
+---------------------------------------------------------------+
| Continent / region IDs (TBD; possibly per-tile or per-mass)   |
+---------------------------------------------------------------+
| Tribe village positions (read from layer or follow-up record) |
+---------------------------------------------------------------+
```

## Terrain byte encoding (Layer 1)

Each terrain byte packs multiple attributes:

```
Bit 7    Forested flag        (1 = has forest overlay)
Bit 6    Road/River flag      (1 = has road or river)
Bit 5    Prime resource flag  (1 = special resource square)
Bits 4-0 Base terrain type    (0-26)
```

## Terrain type table

| ID | Name        | Move | Def | Yields (Farm Sug Tob Cot Fur Lum Ore Sil Fish) |
|----|-------------|------|-----|-----|
| 0  | Ocean       |  1   |  0  | 0 0 0 0 0 0 0 0 3 |
| 1  | Sea Lane    |  1   |  0  | 0 0 0 0 0 0 0 0 3 |
| 2  | Tundra      |  1   |  0  | 2 0 0 0 0 0 2 0 0 |
| 3  | Desert      |  1   |  0  | 1 0 0 1 0 0 2 0 0 |
| 4  | Plains      |  1   |  0  | 4 0 0 2 0 0 1 0 0 |
| 5  | Prairie     |  1   |  0  | 2 0 0 3 0 0 0 0 0 |
| 6  | Grassland   |  1   |  0  | 2 0 3 0 0 0 0 0 0 |
| 7  | Savannah    |  1   |  0  | 3 3 0 0 0 0 0 0 0 |
| 8  | Marsh       |  2   |  1  | 2 0 2 0 0 0 2 0 0 |
| 9  | Swamp       |  2   |  1  | 2 2 0 0 0 0 2 0 0 |
| 10 | Boreal      |  2   |  2  | 1 0 0 0 3 2 1 0 0 |
| 11 | Scrub       |  1   |  2  | 1 0 0 1 2 1 1 0 0 |
| 12 | Mixed Forest|  2   |  2  | 2 0 0 1 3 3 0 0 0 |
| 13 | Broadleaf   |  2   |  2  | 1 0 0 1 2 2 0 0 0 |
| 14 | Conifer     |  2   |  2  | 1 0 1 0 2 3 0 0 0 |
| 15 | Tropical    |  2   |  2  | 2 1 0 0 2 2 0 0 0 |
| 16 | Wetland     |  3   |  2  | 1 0 1 0 2 2 1 0 0 |
| 17 | Rain Forest |  3   |  3  | 1 1 0 0 1 2 1 0 0 |
| 18 | Arctic      |  2   |  0  | 0 0 0 0 0 0 0 0 0 |
| 19 | Mountains   |  3   |  6  | 0 0 0 0 0 0 4 1 0 |
| 20 | Hills       |  2   |  4  | 1 0 0 0 0 0 4 0 0 |
| 21 | Tundra (var)|  -   |  -  | (decompiler artifact - see below) |
| ...                                                                 |

@rule   Use `extracted/text/NAMES_sections.json` for the AUTHORITATIVE
        terrain ordering. The C reconstruction in
        `_archive/mapedit_artifacts/mapedit.c` has been WRONG about
        terrain types; do not trust it (per docs/RULINGS.md).

@rule   **Auto-forest range 8-23** (incl. Arctic at 16) — byte-verified
        at VICEROY.EXE 0x6204 and 0x6831B (2026-04-25).

@rule   **Sea-lane** (right edge of map) is base terrain 26, NOT 25 or
        anything else.

## Resource overlay table (Layer 3)

| ID | Name           | Bonus       | Typical Terrain     |
|----|----------------|-------------|---------------------|
| 0  | None           | —           | —                   |
| 1  | Depleted Mine  | +6 ore      | Mountains/Hills     |
| 2  | Oasis          | +3 food     | Desert              |
| 3  | Wheat          | +4 food     | Plains/Prairie      |
| 4  | Prime Cotton   | +6 cotton   | Prairie/Plains      |
| 5  | Prime Tobacco  | +6 tobacco  | Grassland           |
| 6  | Prime Sugar    | +7 sugar    | Savannah            |
| 7  | Minerals       | +4 ore      | Various             |
| 8  | Fishery        | +5 fish     | Ocean adjacent coast |
| 9  | Beaver         | +6 furs     | Forested cold       |
| 10 | Game           | +6 furs     | Forested temperate  |
| 11 | Prime Timber   | +6 lumber   | Forested            |
| 12 | Prime Timber B | +6 lumber   | Forested            |
| 13 | Silver Deposit | +12 silver  | Mountains           |
| 14 | Ore Deposit    | +6 ore      | Mountains/Hills     |

## Loader

The DOS-side loader is in the overlay. Cross-references:
- `AMER2.MP` string at file 0x01FB06 in VICEROY.EXE
- Loader function: TBD (the cross-references at 0x011A62 / 0x01A0CC /
  0x034E93 from `code/VICEROY/asset_xrefs.md` were partially false
  positives; the real loader is constructed via `sprintf` of "AMER2.MP"
  in the overlay's asset-loader region)

The MAPEDIT.EXE map editor reads/writes the same format. The
`mapedit_source/src/load_image/` chunks contain the MAPEDIT-side .MP
parser/writer; cross-referencing them with VICEROY's overlay would
identify the exact byte layout.

## Verification

- @python  ../../../colonize_sdl/engine/asset_loader.py  (Python decoder)
- @python  ../../../tools/render_test.py  (renders MP files headless)
- @verified  Decode of AMER2.MP yields 56×72 playable area with the
  expected 21 base terrain types + 2 sea-lane columns + 69 resource tiles.

## Citations

- @asm_file  TBD (overlay-resident map loader)
- @ref       ../../../MAP_FORMAT.md   (full byte-level spec)
- @ref       ../../docs/RULINGS.md    (terrain-ordering rulings)
