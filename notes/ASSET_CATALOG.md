# Sid Meier's Colonization (1994) — Complete Asset Catalog

## Extraction Results

| Category | Count | Format | Tool |
|---|---|---|---|
| **Sprites** | 1,723 PNGs from 206 .SS files | MADSPACK 2.0 + FAB + linemode | mpskit |
| **Backgrounds** | 34 PNGs from 35 .PIK files | MADSPACK 2.0 + FAB + indexed | mpskit |
| **Fonts** | 340 glyph PNGs from 5 .FF files | MADSPACK 2.0 + 2-bit packed | mpskit |
| **Text Sections** | 843 sections from 13 .TXT files | ASCII with @SECTION markers | extract_all.py |
| **Map** | 58×72 terrain/resource/feature layers | Binary 3-layer + 6-byte header | extract_all.py |
| **Palette** | 256 colors (VGA 6-bit) | 1024 bytes (4 bytes/color RGBX) | extract_all.py |
| **Binary Data** | 6 analyzed files | Various | extract_all.py |

---

## File Format Reference

### MADSPACK 2.0 Container
```
Offset  Size  Field
0       12    Magic: "MADSPACK 2.0"
12      2     Terminator: 0x1A 0x00
14      2     uint16 LE: number of parts (max 16)
16      160   Part headers (10 bytes × 16 slots)
176+    ...   Compressed data for each part
```

Part header (10 bytes):
```
0  uint16 LE  flags — bit 0: 0=raw, 1=FAB compressed
2  uint32 LE  decompressed size
6  uint32 LE  compressed size
```

### FAB Compression
LZ77/LZSS variant by MicroProse. Each compressed section starts with `"FAB" + shift_val` (1 byte, range 10-13). Uses 16-bit LE bitstream, LSB-first.

Commands:
- `1`: literal byte from source
- `00 b1 b2 A`: short copy, length=(b1<<1|b2)+2, offset=A-256
- `01 A B`: long copy, offset from upper bits of B + A, length from lower bits of B
- `01 A B 0x00`: HALT (end of stream)

### .SS Sprite Sheet Format
MADSPACK with 4 parts:
- **Part 0** (0x98 bytes): SS header — mode, sprite count, data size
- **Part 1**: Sprite headers — 16 bytes each (offset, length, padded_w/h, w, h)
- **Part 2**: Palette — 256 × 3 bytes (VGA 6-bit R,G,B)
- **Part 3**: Pixel data — linemode encoded

Linemode encoding:
- `0xFF`: fill to end of line with background (0xFD), advance to next line
- `0xFE`: pixel mode — read single pixels or `0xFE len col` for runs
- `0xFD`: multipixel mode — read `len col` pairs
- `0xFC`: end of image

Transparency index: **0xFD**

SS header mode field: 0=linemode only, 1=FAB+linemode (per-sprite FAB)

### .PIK Background Image Format
MADSPACK with 3 parts:
- **Part 0**: Header — height(2), width(2), unk1(2), unk2(2)
- **Part 1**: Pixel data — width×height bytes, indexed color
- **Part 2**: Palette — 256 × 3 bytes (VGA 6-bit)

### .FF Font Format
MADSPACK with 1 part:
```
0    uint8   max_height
1    uint8   max_width
2    128×1   glyph widths (chars 1-127, padded to 128)
130  128×2   glyph offsets (uint16 LE, relative to section start)
386+ ...     glyph pixel data (2 bits per pixel, 4 colors)
```

Font colors: index 0=background, 1=primary, 2=shadow, 3=outline

### .MP Map Format
```
0    uint16 LE  width (58 for Americas)
2    uint16 LE  height (72)
4    uint16 LE  nations (4)
6    w×h bytes   terrain layer
6+wh w×h bytes   feature layer
6+2wh w×h bytes  resource overlay
```

Terrain byte encoding:
- Bits [4:0] = terrain type (0-26)
- Bit 5 = prime resource flag
- Bit 6 = road/river
- Bit 7 = forested

### VICEROY.PAL (VGA Palette)
1024 bytes: 256 entries × 4 bytes (R, G, B, padding). VGA 6-bit values (0-63), multiply by 4 for 8-bit.

### CYCLE.DAT (Palette Cycling)
34 bytes: palette cycling range definitions for water animation.

### PATH.DAT (Sea Lane Path)
Text file: 701 coordinate pairs defining the shipping route between New World and Europe.

### CONFIG.COL (Sound Configuration)  
20 bytes: sound card type, port, IRQ, DMA settings.

### COLDIG.BIN (Digital Sound Bank)
993,755 bytes: unsigned 8-bit PCM audio samples at 11025 Hz.

---

## Sprite File Inventory

### Map/Terrain
| File | Sprites | Description |
|---|---|---|
| PHYS0.SS | 155 | Terrain tiles (all zoom levels) |
| TERRAIN.SS | 13 | Terrain type indicators |
| BDARK.SS | 47 | Dark terrain variants |

### Units & Characters
| File | Sprites | Description |
|---|---|---|
| CC-00 to CC-24.SS | 2 each | Founding Father portraits (25 fathers) |
| ENGLND1/2.SS | 2 each | English leader portraits |
| FRANCE1/2.SS | 2 each | French leader portraits |
| SPAIN1/2.SS | 2 each | Spanish leader portraits |
| DUTCH1/2.SS | 2 each | Dutch leader portraits |
| KING.SS, KING1/2.SS | 2-9 | King character sprites |
| KINGWIN.SS | 2 | King victory scene |
| KINGLOSE.SS | 2 | King defeat scene |
| IND0A0-IND7A3.SS | 2-3 each | Native tribe sprites (8 tribes × 4 animations) |
| MSS0-MSS5.SS | 2 each | Mission sprites |
| MYR0-MYR3.SS | 2 each | Mystery/event sprites |

### UI Elements
| File | Sprites | Description |
|---|---|---|
| ICONS.SS | 132 | Game UI icons (goods, units, buildings) |
| CURSOR.SS | 3 | Mouse cursors |
| BUILDING.SS | 49 | Colony building sprites |
| NAMEPLAT.SS | 4 | Name plate UI elements |
| PARCH.SS | 2 | Parchment background |
| WOODTILE.SS | 2 | Wood panel tile |
| WOODFRAM.SS | 2 | Wood frame border |
| WIN-FWRK.SS | 47 | Window framework elements |
| WIN.SS | 2 | Window background |

### Opening/Closing Animations  
| File | Sprites | Description |
|---|---|---|
| OPENGUY.SS | 55 | Opening scene character animation |
| OPENMON1-3.SS | 16-33 | Sea monster animations |
| OPENSHIP.SS | 9 | Ship animation |
| OPENSUN.SS | 8 | Sun animation |
| OPENFISH.SS | 14 | Fish animation |
| OPENWND1/2.SS | 11-12 | Wind animation |
| OPENBONK.SS | 19 | Ship hitting land |
| OPENCRD1-3.SS | 6-8 | Credits text sprites |
| OPENLOGO.SS | 2 | Opening logo |
| OPENTILE.SS | 2 | Opening tile |
| MPSLOGO.SS | 17 | MicroProse logo animation |
| MPSNAME.SS | 30 | MicroProse name animation |
| CLOS-*.SS | 15-67 | Closing ceremony animations |

### Decorative Letters
| File | Sprites | Description |
|---|---|---|
| DEC-UPPA-Z.SS | 12 each | Decorative capital letters A-Z |
| DEC-LOWA-Z.SS | 9 each | Decorative lowercase letters a-z |
| DEC-SQIG.SS | 12 | Decorative squiggle/ornament |

### Score/Victory Screens
| File | Sprites | Description |
|---|---|---|
| SCORE01-24.SS | 2 each | Score screen elements (24 frames) |
| WDCUT01-13.SS | 2 each | Historical woodcut illustrations |

---

## Background Image Inventory

| File | Description |
|---|---|
| OPENING.PIK | Title screen (320×396) |
| OPENMENU.PIK | Main menu background |
| OPENBORD.PIK | Opening border frame |
| NATIONS.PIK | Nation selection screen |
| DIFFICUL.PIK | Difficulty selection |
| CUSTOMIZ.PIK | New World customization |
| CLOS-BKG.PIK | Closing ceremony background |
| DECLARAT.PIK | Declaration of Independence |
| DECOIND.PIK | Independence decoration |
| CCBKGD.PIK | Continental Congress background |
| COLONY.PIK | Colony screen background |
| EUROPE.PIK | European port screen |
| REPORT1-9.PIK | Adviser report backgrounds |
| KINGLSS1/2.PIK | King's audience backgrounds |
| LEVN0001-10.PIK | Leader portrait backgrounds |
| WOODPANL.PIK | Wood panel UI background |
| WOODPAN2.PIK | Wood panel variant |

---

## Text File Inventory

| File | Sections | Description |
|---|---|---|
| NAMES.TXT | 31 | Master game data: terrain, goods, units, tribes, buildings, Founding Fathers |
| GAME.TXT | 536 | All in-game dialog/event messages |
| PEDIA.TXT | 204 | Colonizopedia encyclopedia entries |
| LABELS.TXT | 7 | UI labels and short strings |
| COLONY.TXT | 5 | Default colony names by nation |
| MENU.TXT | 8 | Menu structure (Game, View, Orders, Reports, Trade, Cheat, Pedia) |
| DEBUG.TXT | 26 | Debug/cheat dialog messages |
| OPENING.TXT | 3 | Opening animation credits/script |
| CLOSING.TXT | 2 | Closing animation script |
| WOODCUT.TXT | 1 | Woodcut illustration titles |
| MAPEDIT.TXT | 26 | Map editor dialogs and help text |
| MAPMENU.TXT | 5 | Map editor menu structure |
| README.TXT | 0 | Player documentation |

---

## Key Data Tables Extracted from NAMES.TXT

### Terrain (21 types + water variants)
Tundra, Desert, Plains, Prairie, Grassland, Savannah, Marsh, Swamp (unforested)
Boreal, Scrub, Mixed, Broadleaf, Conifer, Tropical, Wetland, Rain (forested)
Arctic, Ocean, Sea Lane, Mountains, Hills (other)

### Goods (16 + 4 abstract)
Food, Sugar, Tobacco, Cotton, Furs, Lumber, Ore, Silver, Horses, Rum, Cigars, Cloth, Coats, Trade Goods, Tools, Muskets (+Hammers, Crosses, Liberty Bells, Flags)

### Units (23 types)
Colonists, Soldiers, Pioneers, Missionaries, Dragoons, Scouts, Regulars, Continental Cavalry, Cavalry, Continental Army, Treasure, Artillery, Wagon Train, Caravel, Merchantman, Galleon, Privateer, Frigate, Man-O-War, Braves, Armed Braves, Mounted Braves, Mounted Warriors

### Buildings (39 types in 13 categories)
Fortification (3), Military (3), Docks (3), Town Hall (3), Education (3), Warehouse (2), Stable, Custom House, Press (2), Weaving (3), Tobacco (3), Rum (3), Capitol (2), Fur (3), Lumber (2), Church (2), Blacksmith (3)

### Founding Fathers (25, in 5 categories)
Trade: Adam Smith, Jakob Fugger, Peter Minuit, Peter Stuyvesant, Jan de Witt
Exploration: Ferdinand Magellan, Francisco Coronado, Hernando de Soto, Henry Hudson, Sieur De La Salle
Military: Hernan Cortes, George Washington, Paul Revere, Francis Drake, John Paul Jones
Political: Thomas Jefferson, Pocahontas, Thomas Paine, Simon Bolivar, Benjamin Franklin
Religious: William Brewster, William Penn, Jean de Brebeuf, Juan de Sepulveda, Bartolome de las Casas

### Native Tribes (8 + 18 extra names)
Incas (Civilized), Aztecs (Advanced), Arawaks (Agrarian), Iroquois (Agrarian), Cherokee (Agrarian), Apache (Semi-Nomadic), Sioux (Semi-Nomadic), Tupi (Semi-Nomadic)

---

## Tools

- `tools/mpskit/` — Full MADSPACK decompressor/recompressor (GPL, from github.com/institution/mpskit)
- `tools/extract_all.py` — Custom extractor for text, map, palette, and binary data files
- `tools/batch_extract.sh` — Batch extraction script using mpskit

## Reconstruction Source Code

- `colonize_src_v3.zip` — C source reconstruction with 11 modules
- `colonize_structs.h` — Reverse-engineered memory layout structures
- `game_data.h` — Authoritative game constants from data files
- `mapedit.c` — C reimplementation of the map editor

---

*Generated 2026-04-12 by automated extraction pipeline.*
