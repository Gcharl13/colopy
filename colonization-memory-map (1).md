# Colonization (1994 DOS) — Memory Map Reference

## Overview

This document describes the live memory layout of Sid Meier's Colonization (1994) as observed in js-dos 6.22 (DOSBox compiled to WebAssembly). All game data lives within the WASM linear memory buffer, typically in a region starting around `0x1EE0000` (varies per session).

Base addresses shift between WASM sessions. The offsets within each structure are stable and consistent. The memlab.html tool auto-detects base addresses each session using fingerprint scanning.

All multi-byte values are little-endian (least significant byte first).

---

## Power Records

Each of the four European powers (English, French, Spanish, Dutch) has a 316-byte record. The four records are stored consecutively with exactly `0x13C` (316) bytes between each base address.

### How to find them

The auto-detection fingerprint uses the market sensitivity field at offset `+0x4C`: 16 consecutive bytes, each in range 1–20, with at least 4 distinct values. Combined with a tax byte at `+0x01` in range 1–20 and a gold value at `+0x2A` under 500,000, this uniquely identifies a power record. Scanning the last 3MB of WASM memory for this pattern, then checking for 4 records at `0x13C` spacing, reliably finds all four powers.

### Example addresses (one session)

| Nation | Base Address |
|--------|-------------|
| English | `0x1EEF1F0` |
| French | `0x1EEF32C` |
| Spanish | `0x1EEF468` |
| Dutch | `0x1EEF5A4` |

### Field layout

All offsets are relative to the power's base address.

#### Government and progress

| Offset | Size | Type | Field | Values |
|--------|------|------|-------|--------|
| +0x01 | 1 | u8 | Tax rate | 0–100 (percent) |
| +0x0C | 2 | u16 | Congress progress | Points toward next Founding Father. Rolls over when it hits the threshold. |
| +0x0E | 2 | u16 | Liberty bells | Per-turn bell production across all colonies |
| +0x10 | 2 | u16 | Crosses | Per-turn cross production across all colonies |
| +0x14 | 2 | u16 | Founding Fathers count | Number recruited so far |
| +0x2A | 4 | u32 | Gold | Current treasury. Verified by write-back: changing this value updates the in-game gold display immediately. |
| +0x30 | 2 | u16 | Recruit cost | Price to recruit next immigrant in Europe |
| +0x32 | 2 | u16 | REF strength | Aggregate Royal Expeditionary Force power rating |

#### Royal Expeditionary Force

| Offset | Size | Type | Field | Values |
|--------|------|------|-------|--------|
| +0x44 | 1 | u8 | REF dragoons | Number of mounted REF units |
| +0x45 | 1 | u8 | REF regulars | Number of infantry REF units |
| +0x46 | 1 | u8 | REF artillery | Number of REF artillery/man-o-war |

Setting all three to 0 eliminates the entire REF before declaring independence.

#### Market data

The market model tracks 16 trade goods. Each good occupies one slot in four parallel arrays within the power record. The goods order is fixed:

| Index | Good |
|-------|------|
| 0 | Food |
| 1 | Sugar |
| 2 | Tobacco |
| 3 | Cotton |
| 4 | Furs |
| 5 | Lumber |
| 6 | Ore |
| 7 | Silver |
| 8 | Horses |
| 9 | Rum |
| 10 | Cigars |
| 11 | Cloth |
| 12 | Coats |
| 13 | Trade Goods |
| 14 | Tools |
| 15 | Muskets |

**Market sensitivity** (+0x4C, 16 x u8)

Controls how rapidly prices drop when you sell a good. Lower values mean prices stay higher longer. Each power has independent sensitivity values.

| Offset | Good | Typical Dutch default |
|--------|------|-----------------------|
| +0x4C | Food | 1 |
| +0x4D | Sugar | 7 |
| +0x4E | Tobacco | 5 |
| +0x4F | Cotton | 5 |
| +0x50 | Furs | 6 |
| +0x51 | Lumber | 2 |
| +0x52 | Ore | 6 |
| +0x53 | Silver | 20 |
| +0x54 | Horses | 5 |
| +0x55 | Rum | 13 |
| +0x56 | Cigars | 11 |
| +0x57 | Cloth | 13 |
| +0x58 | Coats | 9 |
| +0x59 | Trade Goods | 2 |
| +0x5A | Tools | 2 |
| +0x5B | Muskets | 7 |

**Market pool** (+0x5C, 16 x s16)

Current supply/demand imbalance for each good. Positive values mean surplus (lower prices), negative values mean scarcity (higher prices). Each entry is a signed 16-bit integer (2 bytes, little-endian).

Offsets: +0x5C (Food), +0x5E (Sugar), +0x60 (Tobacco), +0x62 (Cotton), +0x64 (Furs), +0x66 (Lumber), +0x68 (Ore), +0x6A (Silver), +0x6C (Horses), +0x6E (Rum), +0x70 (Cigars), +0x72 (Cloth), +0x74 (Coats), +0x76 (Trade Goods), +0x78 (Tools), +0x7A (Muskets).

**Market traded volume** (+0x7C, 16 x s32)

Cumulative units traded per good. Each entry is a signed 32-bit integer (4 bytes). Drives long-term price trends.

Offsets: +0x7C (Food), +0x80 (Sugar), +0x84 (Tobacco), ... +0xB8 (Muskets). Spacing is 4 bytes per good.

**Market European supply** (+0xBC, 16 x s32)

European-side supply levels per good. 4 bytes each.

Offsets: +0xBC (Food), +0xC0 (Sugar), ... +0xF8 (Muskets).

**Market base values** (+0xFC, 16 x s32)

Initial market state at game start. Usually matches European supply at turn 1.

Offsets: +0xFC (Food), +0x100 (Sugar), ... +0x138 (Muskets).

---

## Map Data

The game map is 56 columns by 72 rows. Tiles are stored in row-major order: tile index = `y * 56 + x`. Total map layer size is 4,032 bytes.

### How to find map layers

The features layer is located by scanning for bytes with value `0xB0` (Lost City marker) in a 4,032-byte block. Typically found approximately `0xEAC4` bytes before the first power record base address.

### Known layers

| Layer | Typical offset from powers | Description |
|-------|---------------------------|-------------|
| Features/Rumors | powers[0] - 0xEAC4 | Tile special attributes |
| Visibility | features + 0x1B80 | Exploration fog per power |

### Features layer values

| Value | Hex | Meaning |
|-------|-----|---------|
| 0x00 | 0 | No special feature |
| 0xB0 | 176 | Lost City / Rumors of treasure |

When a unit steps on a `0xB0` tile, the game triggers a random event (gold, Fountain of Youth, Seven Cities of Cibola, burial grounds, or nothing) and clears the tile to `0x00`.

### Visibility layer values

| Value | Hex | Meaning |
|-------|-----|---------|
| 0x00 | 0 | Unexplored (fog) |
| 0x80 | 128 | Explored / visible |

### Address calculation

To read or write a specific tile:

```
tile_address = map_layer_base + (y * 56) + x
```

Example: tile at column 25, row 22 with features base at `0x1EE072C`:

```
0x1EE072C + (22 * 56) + 25 = 0x1EE072C + 1257 = 0x1EE0C15
```

---

## Colony Table

Colony records are stored in a contiguous array. Each record is 202 bytes (0xCA).

### How to find the colony table

Search the memory region between the map layers and the power records for known colony name strings (ASCII). Common names include Jamestown, New Amsterdam, Plymouth, Isabella, Quebec, Fort Orange, Fort Nassau, Santo Domingo, San Salvador. The first match is the start of the first colony record's name field.

### Record layout

| Field | Offset from name start | Size | Notes |
|-------|----------------------|------|-------|
| X coordinate | -2 | 1 | Column 0-55 |
| Y coordinate | -1 | 1 | Row 0-71 |
| Colony name | 0 | 24 | Null-terminated ASCII |

Colony records are spaced exactly 202 bytes apart. To find colony N (zero-indexed):

```
colony_address = colony_table_base + (N * 202)
```

---

## Unidentified But Located Regions

Session recording and diff analysis have identified several active memory regions whose exact purpose is not yet confirmed.

### Timer/frame counter

| Address (example) | Behavior |
|-------------------|----------|
| 0x1EEED20-0x1EEED21 | Changes approximately once per second, steadily incrementing. Likely a 16-bit frame counter or animation timer. Highest change frequency of any address in recorded sessions (208 changes in 210 seconds). |

### Unit table (probable)

| Region (example) | Evidence |
|-------------------|----------|
| 0x1EF5000-0x1EF52FF | During an Aztec combat event, 1,303 changes occurred in this 768-byte region. Dense change clustering suggests fixed-size unit records, likely 32 or 64 bytes each. Changes coincide with unit movement and combat resolution. |

### Cursor/selection state

| Region (example) | Evidence |
|-------------------|----------|
| 0x1EE6D00-0x1EE6FFF | Changes at high frequency (347+ per 6-minute session) regardless of game state. Likely tracks the current cursor position, selected unit, or active UI element. |

### Game state flags

| Address (example) | Behavior |
|-------------------|----------|
| 0x1EEFCD0 | Single byte changing 365 times in 6 minutes. Possibly a game phase indicator, animation state, or turn processing flag. |

---

## Common Edits (Quick Reference)

### Give Dutch 99,999 gold
```
Address: dutch_base + 0x2A
Write 4 bytes: 9F 86 01 00
```

### Set Dutch tax to 0%
```
Address: dutch_base + 0x01
Write 1 byte: 00
```

### Eliminate Dutch REF
```
dutch_base + 0x44: 00 (dragoons)
dutch_base + 0x45: 00 (regulars)
dutch_base + 0x46: 00 (artillery)
```

### Max congress progress
```
Address: dutch_base + 0x0C
Write 2 bytes: E7 03 (= 999)
```

### Set all Dutch market sensitivity to 1
```
Addresses: dutch_base + 0x4C through dutch_base + 0x5B
Write 1 to each of the 16 bytes
```

### Plant Lost City at tile (x, y)
```
Address: features_base + (y * 56) + x
Write 1 byte: B0
```

### Remove Lost City at tile (x, y)
```
Address: features_base + (y * 56) + x
Write 1 byte: 00
```

---

## Address Calculation Formulas

**Power field:**
```
address = power_base + field_offset
```

**Map tile:**
```
address = map_layer_base + (y * 56) + x
```

**Colony record:**
```
address = colony_table_base + (colony_index * 202)
```

**Market good in any array:**
```
sensitivity: power_base + 0x4C + good_index
pool:        power_base + 0x5C + (good_index * 2)
traded:      power_base + 0x7C + (good_index * 4)
eu_supply:   power_base + 0xBC + (good_index * 4)
base_vals:   power_base + 0xFC + (good_index * 4)
```

---

## Data Types

| Type | Size | Range | Example |
|------|------|-------|---------|
| u8 | 1 byte | 0 to 255 | Tax rate, sensitivity |
| u16 | 2 bytes | 0 to 65,535 | Bells, crosses, congress |
| u32 | 4 bytes | 0 to 4,294,967,295 | Gold |
| s16 | 2 bytes | -32,768 to 32,767 | Market pool |
| s32 | 4 bytes | -2,147,483,648 to 2,147,483,647 | Traded volume, EU supply |

Signed negative encoding (two's complement):
- s16 value -500 = 65536 - 500 = 65036 = bytes `0C FE`
- s16 value -1 = bytes `FF FF`

---

## Game Message System

GAME.TXT contains 1,045 message templates. Variable slots used in templates:

| Variable | Type | Example |
|----------|------|---------|
| %STRING0 through %STRING4 | Text | Nation names, colony names, unit types |
| %NUMBER0 through %NUMBER3 | Numeric | Gold amounts, percentages, quantities |
| %YEAR | Numeric | Current game year |
| %COUNTRY | Text | Current player's nation name |

The memory address of the variable buffer that fills these slots has not yet been identified. It is a target for future discovery through OCR-based cross-referencing.

---

## Tools

| Tool | Purpose |
|------|---------|
| memlab.html | Browser game runner with live dashboard, scanner, hex editor, session recorder with screenshots |
| col_fontmatch.py | Bitmap font OCR using extracted game font glyphs (no Tesseract dependency) |
| col_analyze.py | Session log analyzer with Tesseract OCR and GAME.TXT template matching |
| mpskit | MADSPACK 2.0 decoder for extracting font and sprite files from game assets |

### Extracted font files

| Font file | Glyphs | Height | Typical use |
|-----------|--------|--------|-------------|
| FONTINTR.FF | 88 | 9px | Main dialog/popup text |
| FONTKING.FF | 78 | 7px | King and advisor dialog text |
| FONTSMAL.FF | 65 | 6px | Small UI labels and status text |
| FONTTINY.FF | 82 | 6px | HUD elements and tiny labels |
| FONT-NP.FF | 27 | 8px | Newspaper headlines (uppercase only) |

All glyphs are variable-width, palette-indexed PNGs. Pixel index 0 = background, index >= 1 = foreground.

---

## Verification Status

| Structure | Located | Read verified | Write verified |
|-----------|---------|---------------|----------------|
| Power records (all 4) | Yes | Yes | Yes (gold, tax) |
| Market sensitivity | Yes | Yes | Yes (price changes observed) |
| Market pool | Yes | Yes | Not tested |
| Market traded/supply | Yes | Yes | Not tested |
| REF forces | Yes | Yes | Yes (zeroed, reflected in report) |
| Map features layer | Yes | Yes | Yes (planted/removed Lost Cities) |
| Map visibility layer | Yes | Yes | Not tested |
| Colony table | Yes | Yes (names, coordinates) | Not tested |
| Colony goods storage | Estimated (+0x9A) | Not verified | Not tested |
| Unit table | Probable (0x1EF5000) | Partial (combat diffs) | Not tested |
| Game year | Not found | - | - |
| Turn counter | Not found | - | - |
| Native settlements | Not found | - | - |
| Message variable buffer | Not found | - | - |
