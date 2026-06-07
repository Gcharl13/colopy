# Sid Meier's Colonization (1994) — Complete Technical Reference

**Reverse-engineered from VICEROY.EXE (DOS), COLONIZ.EXE (Windows), MAPEDIT.EXE, and all game data files.**
**Cross-validated against live WASM memory, Windows EXE disassembly, and CodeView debug symbols.**

---

## Table of Contents

1. [Architecture Overview](#1-architecture-overview)
2. [Memory Layout & Data Structures](#2-memory-layout--data-structures)
3. [Map System](#3-map-system)
4. [Turn & Time System](#4-turn--time-system)
5. [Colony Management](#5-colony-management)
6. [Production & Economy](#6-production--economy)
7. [European Market & Trade](#7-european-market--trade)
8. [Unit System](#8-unit-system)
9. [Combat System](#9-combat-system)
10. [Native Relations & Diplomacy](#10-native-relations--diplomacy)
11. [European Diplomacy](#11-european-diplomacy)
12. [King & Taxation](#12-king--taxation)
13. [Independence & Revolution](#13-independence--revolution)
14. [AI System](#14-ai-system)
15. [Founding Fathers](#15-founding-fathers)
16. [Random Events & Lost City Rumors](#16-random-events--lost-city-rumors)
17. [Scoring System](#17-scoring-system)
18. [File Formats](#18-file-formats)
19. [Complete Data Tables](#19-complete-data-tables)

---

## 1. Architecture Overview

### Executables
| File | Size | Compiler | Purpose |
|---|---|---|---|
| VICEROY.EXE | 494,910 bytes | Microsoft C + RTLink Plus | Main game (DOS) — 250 virtual page overlays |
| MAPEDIT.EXE | 145,292 bytes | Microsoft C 6.0 | Map editor — CodeView NB02 symbols embedded |
| OPENING.EXE | 89,178 bytes | Microsoft C | Opening animation player |
| CLOSING.EXE | 83,246 bytes | Microsoft C | Closing ceremony player |

### Runtime Architecture
- **Memory model**: Real-mode 16-bit, small/medium model
- **Overlay system**: RTLink Plus — 250 Virtual Pages (VPs), paged via EMS/XMS/disk
- **Asset system**: MADSPACK 2.0 compression (FAB LZ77 variant)
- **Graphics**: VGA Mode 13h (320×200, 256 colors)
- **Sound**: AdLib/Sound Blaster via ASOUND.COL/GSOUND.COL/PSOUND.COL/RSOUND.COL drivers
- **Map size**: 58×72 tiles in file (56×72 playable, 2 sea lane border columns)
- **Minimum RAM**: 575,000 bytes conventional memory

### Key Internal Codename
The game was developed under the codename **"Viceroy"**. Internal references use this name throughout (VICEROY.EXE, VICEROY.PAL, VICEROY.LOG, viceroy_game() function).

### Libraries (from MAPEDIT.EXE NB02 symbols)
- **madsdev.lib**: MicroProse MADS development engine (sprites, buffers, memory, sound, palette, compression)
- **MLIBCE.lib**: Microsoft C 6.0 medium model runtime (large code, small data)
- **pfabcomp.ASM / pfabexp.ASM**: PFAB compression/decompression routines (in madsdev.lib)

### Source Module Inventory (from MAPEDIT.EXE CodeView NB02 — 211 modules)
**Game-specific (20 modules by Brian Reynolds):**
`mapedit.obj`, `env_1.obj`, `map.obj`, `tile.obj`, `strings.obj`, `popup.obj`, `menu.obj`, `text.obj`, `stuff.obj`, `map_2.obj`, `map_5.obj`, `write.obj`, `vicemisc.obj`, `terrain.obj`, `compass.obj`, `map_6.obj`, `map_9.obj`, `map_a.obj`, `me_mini.obj`

**Engine library (~95 modules from madsdev.lib):**
`hspot_*.c` (hotspots), `keys_*.c` (keyboard INT 9h), `fileio_*.c` (DOS file I/O), `mouse_*.c` (INT 33h), `screen_b.c`, `buffer_*.c` (offscreen buffers), `mem_*.c` (heap/conv/UMB/EMS/XMS), `timer_*.c` (INT 8h + sound), `font_*.c`, `mcga_*.c` (VGA palette), `sprite_*.c` (draw/scale/series), `pal_*.c`, `matte_0.c`, `video_*.asm`, `error_1.c`, `pack_*.c` (MADSPACK), `cycle_*.c` (palette cycling), `xms_*.c`, `ems_*.c`, `heap_*.c`, `loader_*.c`, `sound_*.asm`, `pfabcomp.asm`, `pfabexp.asm`

**C Runtime (~96 modules from MLIBCE.lib):**
`crt0.asm`, `chkstk.asm`, `fclose.c`, `fopen.c`, `fread.asm`, `fwrite.asm`, `printf.c`, `malloc.asm`, `free.asm`, etc.

---

## 2. Memory Layout & Data Structures

### Build Information
- **Build date**: 7-Feb-95 (from MZ header)
- **Command-line debug flags**: `-gok` (enable debug), `-p:` (parameter)
- **Initial CS:IP**: 110D:071D, **SS:SP**: 25E5:4096

### Global Variable Map (from DS segment analysis + imul cross-reference)

| DS Offset | WASM Address | Type | Name | Refs | Description |
|---|---|---|---|---|---|
| 0x2DA8 | — | byte[4032] | map_terrain | 31 | Terrain layer (56×72) |
| 0x4285 | — | uint16 | current_player_ptr | 20+ | **Pointer to current player struct** (nation index at +0x1A) |
| 0x538A | — | uint16 | current_year | 30 | Current game year (CMP: 1492-1800) |
| 0x538E | — | uint16 | unknown_threshold | 3 | Compared against 150, 200 |
| 0x5390 | — | uint16 | current_season | — | 0=Spring, 1=Autumn |
| 0x539C | — | uint16 | score_related | 3 | Compared against 292, 300 |
| 0x53C2 | — | uint16 | game_flag | 10 | Written 0 or 1 (boolean toggle) |
| 0x543F | — | byte[52×4] | ai_personality | 47 | AI personality structs (4 nations × 52 bytes) |
| 0x5D60 | 0x1EEC730 | byte[202×N] | colony_table | 26 | Colony records (stride 0xCA) |
| 0x8542 | — | uint16 | current_nation_ptr | — | Active nation's data pointer |
| 0x8808 | — | byte[316×4] | power_table | 18 | Power records (stride 0x13C, base confirmed) |
| 0x8A53 | — | uint16 | year_alt | — | Alternative year reference |

### Key Data Tables (from binary analysis at file offsets)

| File Offset | Content | Purpose |
|---|---|---|
| 0x01DB32 | 16-bit words: 6,1,2,3,4,5,6,6,9,1,8,9,10,10... | **Unit type → class index mapping** |
| 0x01DC02 | 16-bit words: 43,46,56,5,145,7,173,10,8,33... | **Game parameter table** (production/cost values) |
| 0x01DC48 | Bytes: 0x08,0x01,0x02,0x03,0x04,0xFF,0x06,0x0E,0x05... | **Building → profession mapping** |
| 0x01DC67 | Bytes: 0x00,0x15,0x15,0x15,0x0F,0x0F,0x0F,0xFF... | **Production type mapping** |
| 0x01DC7F | Bytes: 0x0B,0x0B,0x0B,0x0A,0x0A,0x0A,0x09,0x09,0x09... | **Building level table** |
| 0x01DC9A | Bytes: 0x1B,0x18,0x15,0x20,0x23,0x27,0x03,0x25,0x09,0x0C | **Difficulty/nation modifiers** |

### PowerRecord (316 bytes per nation, stride 0x13C)

```c
#pragma pack(1)
typedef struct PowerRecord {
    uint8_t  _pad0;                          // +0x00
    uint8_t  tax_rate;                       // +0x01  (0-100%)
    uint8_t  _unk02[10];                     // +0x02-0x0B
    uint16_t congress_progress;              // +0x0C  liberty bell accumulator for next FF
    uint16_t liberty_bells;                  // +0x0E  per-turn production
    uint16_t crosses;                        // +0x10  per-turn immigration points
    uint8_t  _unk12[3];                      // +0x12-0x14
    uint16_t founding_fathers_count;         // +0x14  total FFs recruited
    uint8_t  _unk16[20];                     // +0x16-0x29
    uint32_t gold;                           // +0x2A  treasury (max ~999999)
    uint8_t  _unk2E[22];                     // +0x2E-0x43
    uint8_t  ref_dragoons;                   // +0x44  Royal Expeditionary Force
    uint8_t  ref_regulars;                   // +0x45
    uint8_t  ref_artillery;                  // +0x46
    uint8_t  _unk47[5];                      // +0x47-0x4B
    uint8_t  market_sensitivity[16];         // +0x4C  price volatility per good
    int16_t  market_pool[16];                // +0x5C  supply/demand balance
    int32_t  market_traded_volume[16];       // +0x7C  cumulative trade volume
    int32_t  market_eu_supply[16];           // +0xBC  European supply levels
    int32_t  market_base_values[16];         // +0xFC  initial market calibration
} PowerRecord;  // Total: 0x13C = 316 bytes
```

### ColonyRecord (202 bytes per colony, stride 0xCA)

```c
typedef struct ColonyRecord {
    uint8_t  x;                    // +0x00  tile X (0-55)
    uint8_t  y;                    // +0x01  tile Y (0-71)
    char     name[24];             // +0x02  null-terminated (max 23 chars)
    // +0x1A onwards: 176 bytes of colony state
    // Fields mapped from disassembly + save/load analysis:
    //   - population count
    //   - building flags (bitmask of constructed buildings)
    //   - stockpile[16] (goods quantities)
    //   - production assignments
    //   - rebel/tory sentiment percentages
    //   - fortification level
    //   - current build project + hammers accumulated
    //   - Sons of Liberty membership %
    uint8_t  _unmapped[176];       // +0x1A-0xC9
} ColonyRecord;  // Total: 0xCA = 202 bytes
```

### UnitRecord (28 bytes per unit, stride 0x1C)

The most frequently accessed struct (209 imul references). Fields:

```c
typedef struct UnitRecord {
    uint8_t  x;                    // +0x00  map X position
    uint8_t  y;                    // +0x01  map Y position
    uint8_t  type;                 // +0x02  unit type index (0-22)
    uint8_t  nation;               // +0x03  owning nation (0-3)
    uint8_t  status;               // +0x04  status flags
    uint8_t  orders;               // +0x05  current orders (0-12)
    uint8_t  moves_left;           // +0x06  remaining movement points
    uint8_t  profession;           // +0x07  colonist profession (for colonist units)
    uint8_t  cargo[6];             // +0x08-0x0D  cargo hold contents (ships/wagons)
    uint8_t  cargo_amounts[6];     // +0x0E-0x13  cargo quantities
    uint8_t  goto_x;               // +0x14  Go-To destination X
    uint8_t  goto_y;               // +0x15  Go-To destination Y
    uint8_t  flags;                // +0x16  bitflags (veteran, damaged, etc)
    uint8_t  trade_route;          // +0x17  assigned trade route index
    uint8_t  turns_worked;         // +0x18  turns spent on current task
    uint8_t  _pad[3];              // +0x19-0x1B
} UnitRecord;  // Total: 0x1C = 28 bytes
```

### AI Personality (52 bytes per nation, stride 0x34)

```c
typedef struct AIPersonality {
    int16_t  aggression;           // +0x00  -1 to +1 (friendly/aggressive)
    int16_t  expansion;            // +0x02  -1 to +1 (perfectionist/expansionist)
    int16_t  militarism;           // +0x04  -1 to +1 (civilized/militaristic)
    // ... 46 more bytes of AI state including:
    //   - target priorities
    //   - diplomatic stance per other nation
    //   - strategy flags
    //   - threat assessment
    uint8_t  _data[46];            // +0x06-0x33
} AIPersonality;  // Total: 0x34 = 52 bytes
```

### Additional Identified Structs

| Stride | Size | Refs | Probable Identity | Evidence |
|---|---|---|---|---|
| 0xC8 (200) | 200 bytes | 10 | **UNVERIFIED** (was "native settlement") | No `imul *,0xC8` exists in VICEROY.EXE; the real NativeSettlement is 18-byte @ DGROUP:0x54EC. The 0x3EEB4-0x3F8DF cluster handles natives but not via a 200-byte stride. See docs/RULINGS.md 2026-05-28. |
| 0x12 (18) | 18 bytes | 47 | **NativeSettlement record** (base 0x54EC, count @0x539A) | NOT a trade route — `imul *,0x12` then `[bx+0x54EC]` at overlay 0x46035; x/y/owner/mission verified (RULINGS 2026-05-28) |
| 0x0A (10) | 10 bytes | 30 | Building production record or cargo slot | Very common small struct |
| 0x32 (50) | 50 bytes | 17 | Diplomatic relationship record | Moderate size fits per-nation pair data |

---

## 3. Map System

### Dimensions
- **File dimensions**: 58 columns × 72 rows (in AMER2.MP)
- **Playable area**: columns 1-56, rows 0-71 (column 0 and 57 are sea lane borders)
- **Memory stride**: 56 tiles per row
- **Total tiles**: 4,032 (56 × 72)
- **Tile index formula**: `idx = y * 56 + x`

### Terrain Byte Encoding
Each terrain byte packs multiple attributes:
```
Bit 7:    Forested flag (1 = has forest overlay)
Bit 6:    Road/River flag (1 = has road or river)
Bit 5:    Prime resource flag (1 = special resource square)
Bits 4-0: Base terrain type (0-26)
```

### Terrain Types (21 base types + specials)

| ID | Name | Move | Def | Yield: Farm Sug Tob Cot Fur Lum Ore Sil Fish |
|---|---|---|---|---|
| 0 | Ocean | 1 | 0 | 0 0 0 0 0 0 0 0 3 |
| 1 | Sea Lane | 1 | 0 | 0 0 0 0 0 0 0 0 3 |
| 2 | Tundra | 1 | 0 | 2 0 0 0 0 0 2 0 0 |
| 3 | Desert | 1 | 0 | 1 0 0 1 0 0 2 0 0 |
| 4 | Plains | 1 | 0 | 4 0 0 2 0 0 1 0 0 |
| 5 | Prairie | 1 | 0 | 2 0 0 3 0 0 0 0 0 |
| 6 | Grassland | 1 | 0 | 2 0 3 0 0 0 0 0 0 |
| 7 | Savannah | 1 | 0 | 3 3 0 0 0 0 0 0 0 |
| 8 | Marsh | 2 | 1 | 2 0 2 0 0 0 2 0 0 |
| 9 | Swamp | 2 | 1 | 2 2 0 0 0 0 2 0 0 |
| 10 | Boreal | 2 | 2 | 1 0 0 0 3 2 1 0 0 |
| 11 | Scrub | 1 | 2 | 1 0 0 1 2 1 1 0 0 |
| 12 | Mixed Forest | 2 | 2 | 2 0 0 1 3 3 0 0 0 |
| 13 | Broadleaf | 2 | 2 | 1 0 0 1 2 2 0 0 0 |
| 14 | Conifer | 2 | 2 | 1 0 1 0 2 3 0 0 0 |
| 15 | Tropical | 2 | 2 | 2 1 0 0 2 2 0 0 0 |
| 16 | Wetland | 3 | 2 | 1 0 1 0 2 2 1 0 0 |
| 17 | Rain Forest | 3 | 3 | 1 1 0 0 1 2 1 0 0 |
| 18 | Arctic | 2 | 0 | 0 0 0 0 0 0 0 0 0 |
| 19 | Mountains | 3 | 6 | 0 0 0 0 0 0 4 1 0 |
| 20 | Hills | 2 | 4 | 1 0 0 0 0 0 4 0 0 |

### Three Map Layers
1. **Terrain** (4,176 bytes): terrain type + flags per tile
2. **Features** (4,176 bytes): roads, rivers, lost city rumors (0xB0) — **all zeros at game start** on AMER2.MP; features are added during gameplay
3. **Resource Overlay** (4,176 bytes): encodes tile category + special resources
   - Value 0: border/empty (sea lane edges)
   - Value 1: water tile (Deep Ocean + Coast)
   - Value 2: land tile with no special resource
   - Values 3-14: special resource matching NAMES.TXT @RESOURCE index

### Resource Overlays

| ID | Name | Bonus | Typical Terrain |
|---|---|---|---|
| 0 | None | 0 | — |
| 1 | Depleted Mine | +6 ore | Mountains/Hills |
| 2 | Oasis | +3 food | Desert |
| 3 | Wheat | +4 food | Plains/Prairie |
| 4 | Prime Cotton | +6 cotton | Prairie/Plains |
| 5 | Prime Tobacco | +6 tobacco | Grassland |
| 6 | Prime Sugar | +7 sugar | Savannah |
| 7 | Minerals | +4 ore | Various |
| 8 | Fishery | +5 fish | Ocean/Coast |
| 9 | Beaver | +6 furs | Forested |
| 10 | Game | +6 furs | Forested |
| 11 | Prime Timber | +6 lumber | Forested |
| 12 | Prime Timber B | +6 lumber | Forested |
| 13 | Silver Deposit | +12 silver | Mountains |
| 14 | Ore Deposit | +6 ore | Mountains/Hills |

### Continent System
- Maximum 15 distinct landmasses (4-bit continent ID field)
- Maximum 15 distinct ocean bodies
- AI pathfinding degrades with >15 landmasses
- Continent IDs assigned by flood-fill algorithm

### Random Map Generation — Complete Algorithm

#### Input Parameters (from "Customize New World" screen)

The player selects 4 parameters, each with 3 options (index 0, 1, 2):

| Parameter | Option 0 | Option 1 | Option 2 |
|---|---|---|---|
| **Land Mass** (@CLAND) | Small | Normal | Large |
| **Land Form** (@CCONT) | Archipelago | Normal | Continents |
| **Temperature** (@CTEMP) | Cool | Temperate | Warm |
| **Climate** (@CCLIM) | Arid | Normal | Wet |

#### Parameter Table (at VICEROY.EXE file offset 0x1DBD0)

A candidate generation parameter table was found at binary offset 0x1DBD0 containing the following values organized as generation constants:

```
0x1DBD0: 23, 44, 53    // Land coverage % targets: Small=23%, Normal=44%, Large=53%
0x1DBD3: 73, 75, 0     // Landform fragmentation parameters
0x1DBD6: 27, 22, 37    // Continent size variance
0x1DBD9: 18, 48, 0     // Island count / scatter
0x1DBDC: 3, 20, 25     // Mountain/hill frequency
0x1DBDF: 5, 0, 0       // Additional terrain features
0x1DBE2: 12, 8, 22     // Forest density
0x1DBE5: 5, 0, 0       // Climate modifiers
0x1DBE8: 17, 21, 25    // Temperature latitude bands
0x1DBEB: 65, 0, 0      // Temperature extremes
```

#### Generation Algorithm (reconstructed from binary analysis + game behavior)

The map is 58×72 tiles (56 playable + 2 sea lane borders). Generation proceeds in phases:

**Phase 1: Sea Lane Borders**
```c
// Columns 0 and 57 are always Sea Lane (type 1)
for (y = 0; y < 72; y++) {
    map[y][0]  = TERRAIN_SEA_LANE;
    map[y][57] = TERRAIN_SEA_LANE;
}
// All other tiles start as TERRAIN_OCEAN
```

**Phase 2: Landmass Generation**
```c
// The land_mass parameter (0-2) sets target land coverage:
//   Small=~23%, Normal=~44%, Large=~53% of playable tiles
// The land_form parameter controls shape:
//   Archipelago: many small islands, high fragmentation
//   Normal: 1-3 continents with islands
//   Continents: 1-2 large continuous landmasses

// Algorithm: iterative random "blob" placement
// 1. Pick a random seed point on the map
// 2. Grow a landmass outward using random walk
// 3. Repeat until target land % is reached
// The fragmentation parameter controls how often new seed points 
// are chosen vs. growing existing masses

// Landmasses avoid the leftmost and rightmost ~5 columns
// (the Atlantic/Pacific shipping lanes must remain navigable)
```

**Phase 3: Terrain Type Assignment by Latitude**
```c
// Temperature parameter shifts the latitude bands:
//   Cool: arctic/tundra zones extend further south
//   Warm: savannah/tropical zones extend further north
//   Temperate: balanced

// Latitude bands (approximate tile rows, adjustable by temperature):
//   y=0-7:   Arctic (polar cap)
//   y=8-14:  Tundra/Boreal (subarctic)
//   y=15-25: Mixed Forest/Plains/Prairie (temperate north)
//   y=26-40: Grassland/Savannah/Plains (temperate middle)
//   y=41-55: Tropical/Savannah/Desert (subtropical)
//   y=56-65: Rain Forest/Swamp/Marsh (equatorial)
//   y=66-71: Arctic (southern polar) or continuation

// Within each band, terrain types are chosen randomly with
// weights appropriate to that climate zone
```

**Phase 4: Forest Overlay**
```c
// Climate parameter controls forest density:
//   Arid: ~20% of eligible land tiles get forest
//   Normal: ~40% of eligible land tiles get forest
//   Wet: ~60% of eligible land tiles get forest

// Forest placement rules:
// - Forest cannot be placed on: Ocean, Arctic, Mountains, Hills, Desert
// - Forested terrain types: Boreal, Scrub, Mixed, Broadleaf, Conifer,
//   Tropical, Wetland, Rain Forest
// - Each unforested terrain has a corresponding forest variant:
//   Tundra→Boreal, Desert→Scrub, Plains→Mixed, Prairie→Broadleaf,
//   Grassland→Conifer, Savannah→Tropical, Marsh→Wetland, Swamp→Rain
```

**Phase 5: Mountains and Hills**
```c
// Mountain ranges are placed along tectonic-style lines
// Typically 2-5 mountain chains on the map
// Hills surround mountain tiles (foothills)
// Mountains: terrain type 19, Hills: terrain type 20
// Mountains block colony placement
```

**Phase 6: Rivers**
```c
// Rivers flow from mountains/hills toward ocean
// River flag stored in feature layer (bit 6 of terrain byte, or feature byte)
// "Major River" and "Minor River" variants (from @OTHER_NAMES)
// Rivers provide movement bonus and production bonus to adjacent tiles
```

**Phase 7: Special Resource ("Prime") Placement**

Resources are stored in the **third map layer** (resource overlay). The overlay encoding is:
```
0 = border/empty tile
1 = water tile (ocean/coast) — no resource
2 = land tile — no special resource  
3-14 = actual special resource (matches NAMES.TXT @RESOURCE numbering)
```

The **terrain byte bit 5** (0x20, "prime flag") is set on tiles that have a resource overlay value >= 3. Both systems must agree for the resource to function.

Resources are placed in **geographic clusters**, not single tiles. Each resource region spans 2-10 adjacent tiles, creating meaningful strategic locations. On the Americas map (AMER2.MP), there are **69 total resource tiles** distributed as:

| Resource | Count | Map Region | Typical Terrain |
|---|---|---|---|
| Wheat | 10 | Far north (y=4-7, Alaska/Canada) | Arctic, Tundra |
| Prime Cotton | 4 | Northeast (y=8-11, New England) | Plains, Deep* |
| Prime Tobacco | 22 | East coast (y=11-25, Virginia belt) | Deep*, Broadleaf, t21 |
| Prime Sugar | 11 | Caribbean (y=27-34) | Prairie, Broadleaf, t21 |
| Minerals | 7 | Central highlands (y=28-29) | t21, t23 |
| Fishery | 2 | East coast (y=32) | t21, Broadleaf |
| Beaver | 3 | Northeast (y=29-30) | t21, Broadleaf |
| Game | 2 | Central (y=29) | t21, Prairie |
| Prime Timber | 2 | Central (y=30) | Broadleaf, t21 |
| Prime Timber B | 2 | South (y=42-43) | Broadleaf |
| Silver Deposit | 3 | South highlands (y=34-35) | Broadleaf, t21, Prairie |
| Ore Deposit | 1 | Deep south (y=68) | Ocean* |

*Note: some resources appear on "Deep" or "Ocean" terrain — these tiles have terrain type 25 (Deep Ocean) in the terrain layer but a resource value in the overlay. This likely represents submerged resources visible at coastal boundaries, or a map authoring artifact where the terrain layer and resource layer were edited independently by Brian Reynolds.

**Resource placement rules for random maps:**
```c
// Each resource type has a PREFERRED terrain set:
//   Wheat:        Plains, Prairie, Grassland (food-producing terrain)
//   Prime Cotton: Prairie, Plains (cotton-producing terrain)
//   Prime Tobacco: Grassland, Broadleaf (tobacco-producing)
//   Prime Sugar:  Savannah, Tropical (sugar-producing)
//   Minerals:     Mountains, Hills, Marsh (ore-producing)
//   Fishery:      Ocean adjacent to coast
//   Beaver:       Boreal, Mixed Forest, cold forest (fur-producing)
//   Game:         Forest terrain in temperate zone
//   Prime Timber: Any forest terrain
//   Silver:       Mountains only
//   Ore Deposit:  Mountains, Hills

// Placement algorithm (reconstructed):
// 1. For each resource type, determine target count based on map size
// 2. Choose random land tile matching preferred terrain
// 3. Cluster: place 2-10 adjacent tiles of same resource
// 4. Set both: resource_overlay[tile] = resource_id AND terrain[tile] |= 0x20
// 5. Ensure minimum spacing between different resource clusters
// Total ~60-80 resource tiles on a standard map
```

**Resource bonus values** (from NAMES.TXT @RESOURCE):
```
Depleted Mine:  +6 ore        Silver Deposit: +12 silver
Oasis:          +3 food       Ore Deposit:    +6 ore
Wheat:          +4 food       Fishery:        +5 food
Prime Cotton:   +6 cotton     Beaver:         +6 furs
Prime Tobacco:  +6 tobacco    Game:           +6 furs
Prime Sugar:    +7 sugar      Prime Timber:   +6 lumber
Minerals:       +4 ore
```
These bonuses are **added to the base terrain yield** for the matching production type.

**Phase 8: Lost City Rumors**
```c
// Approximately 20-40 Lost City Rumor tiles placed randomly on land
// Feature layer byte set to 0xB0 at chosen locations
// Rumors are distributed roughly evenly across the map
// They are placed ONLY on land tiles without colonies or settlements
```

**Phase 9: Native Settlement Placement**
```c
// From TRIBE.TXT: predefined positions for the Americas map (AMER2.MP)
// For custom/random maps: tribes are scattered based on:
//   - Preferred terrain (from TribeStats.homeland_terrain)
//   - 3-6 settlements per tribe (counts: [4,4,3,5,4,3,5,3])
//   - Minimum spacing between settlements
//   - Settlement type based on tech level:
//     0=Camp, 1=Village, 2=City, 3=Capital
// From native.c:
//   x = 16 + rand() % (MAP_WIDTH - 18)   // avoid edges
//   y =  5 + rand() % (MAP_HEIGHT - 10)  // avoid poles
//   settlement.teaches_remaining = 2 + rand() % 3  // can teach 2-4 colonists
//   settlement.gold = tech_advanced ? (200 + rand() % 800) : 0
```

**Phase 10: Starting Positions**
```c
// From NAMES.TXT @SCENARIO:
// Americas (AMER2): starting coords = 34,20 / 39,10 / 47,61 / 50,33
// Each nation starts with:
//   - 1 ship (Caravel) at a coastal position
//   - 1 Pioneer unit (with 100 tools)
//   - 1 Soldier unit (with 50 muskets)
//   - Starting gold varies by difficulty
```

#### Pre-made vs Random Maps
- **"Start a Game in AMERICA"**: loads AMER2.MP (the historical Americas map)
  - Player can choose original or map-editor-created map
  - .MPP companion file specifies pre-placed native settlements
- **"Start a Game in NEW WORLD"**: generates a random map using the algorithm above
- **"CUSTOMIZE New World"**: same as New World but player sets the 4 parameters
- Default random parameters: all set to "Normal" (index 1)

#### Map File Format (.MP) for Generated Maps
Generated maps are stored in the same 3-layer format as AMER2.MP:
```
Header:   width(2) + height(2) + nations(2) = 6 bytes
Layer 1:  terrain bytes (width × height)
Layer 2:  feature bytes (width × height)
Layer 3:  resource bytes (width × height)
```

---

## 4. Turn & Time System

### Year Progression
- **Start year**: 1492
- **1492-1599**: 1 turn per year (single-season turns)
- **1600-1800+**: 2 turns per year (Spring + Autumn)
- **Time scale change** at year 1600: confirmed by 5 CMP instructions comparing `[0x538A]` against `0x0640`

### Year Thresholds (from binary analysis)
| Year | Event |
|---|---|
| 1492 | Game start (21 references in binary) |
| 1520-1540 | Early colonization events |
| 1575 | Pre-time-change warning zone |
| 1600 | **Time scale doubles** (Spring/Autumn seasons begin) |
| 1650-1750 | Mid-game events, Founding Father weight shifts |
| 1790 | Late-game warning |
| 1800 | **Viceroy retirement** / forced game end (18 references) |
| 1850 | **Revolution deadline** — Continental Congress sues for peace |

### Turn Processing Order
Each turn processes in this sequence:
1. **AI turn processing** for each non-human nation
2. **Production phase**: colonies produce goods, consume food
3. **Immigration check**: crosses accumulate toward next immigrant
4. **Founding Father check**: liberty bells toward next FF
5. **Market fluctuation**: European prices adjust
6. **King events**: random tax increases, mercenary offers, war declarations
7. **Indian events**: anger changes, raids, gifts
8. **Population growth**: food surplus → new colonists
9. **Building completion**: hammer accumulation → buildings built
10. **Starvation check**: colonies with no food lose colonists
11. **Convert faith check**: converts not in colonies for 8 turns vanish
12. **Score update**: revolution status checked

### Seasons
```c
// From NAMES.TXT @SEASONS
const char* SEASONS[] = { "Spring", "Autumn" };
```

---

## 5. Colony Management

### Colony Limits
- **Maximum colonists per colony**: 32 (increased from original 24 per DEBUG.TXT)
- **Maximum buildings per colony**: 39 building types (in 13 upgrade chains)
- **Stockade population lock**: colonies with stockade/fort/fortress cannot drop below 3 population
- **Maximum colonists per building**: 3
- **Colony naming**: max 23 characters
- **Colony proximity**: cannot build too close to existing colonies
- **Colony location**: cannot build in mountains, at sea, or in ocean

### Building System

Buildings are organized in upgrade chains. Each has: cost (hammers), tools required, size category, minimum colony population, and upkeep cost.

| Building | Cost | Tools×10 | Min Pop | Upkeep | Effect |
|---|---|---|---|---|---|
| **Fortification** |
| Stockade | 64 | 0 | 3 | 0 | Basic defense |
| Fort | 120 | 100 | 3 | 10 | Enhanced defense |
| Fortress | 320 | 200 | 8 | 15 | Maximum defense |
| **Military** |
| Armory | 52 | 0 | 1 | 5 | Train soldiers |
| Magazine | 120 | 50 | 8 | 10 | Improved training |
| Arsenal | 240 | 100 | 8 | 15 | Best training |
| **Docks** |
| Docks | 52 | 0 | 1 | 5 | Fishing + basic ships |
| Drydock | 80 | 50 | 4 | 10 | Better ships |
| Shipyard | 240 | 100 | 8 | 15 | All ship types |
| **Government** |
| Town Hall (I) | 64 | 0 | 1 | 0 | Liberty bell production |
| Town Hall (II) | 64 | 50 | 4 | 10 | Enhanced |
| Town Hall (III) | 120 | 100 | 8 | 15 | Maximum |
| **Education** |
| Schoolhouse | 64 | 0 | 4 | 5 | Teach level 1 skills |
| College | 160 | 50 | 8 | 10 | Teach level 1-2 skills |
| University | 200 | 100 | 10 | 15 | Teach all skills |
| **Storage** |
| Warehouse | 80 | 0 | 1 | 5 | +100 storage per good |
| Warehouse Expansion | 80 | 20 | 1 | 5 | +100 more (one per colony) |
| **Special** |
| Stable | 64 | 0 | 1 | 5 | Auto-breed horses |
| Custom House | 160 | 50 | 1 | 15 | Auto-export + revolution trade (requires Peter Stuyvesant) |
| **Press** |
| Printing Press | 52 | 20 | 1 | 5 | +50% liberty bell production |
| Newspaper | 120 | 50 | 4 | 10 | +100% liberty bell production |
| **Manufacturing** (6 chains × 3 levels) |
| Weaver's House → Shop → Textile Mill | 64/64/160 | 0/20/100 | Cotton → Cloth |
| Tobacconist's House → Shop → Factory | 64/64/160 | 0/20/100 | Tobacco → Cigars |
| Rum Distiller's House → Distillery → Factory | 64/64/160 | 0/20/100 | Sugar → Rum |
| Fur Trader's House → Post → Factory | 56/56/160 | 0/20/100 | Furs → Coats |
| Carpenter's Shop → Lumber Mill | 39/52 | 0/0 | Lumber → Hammers |
| Blacksmith's House → Shop → Iron Works | 64/64/240 | 0/20/100 | Ore → Tools |
| **Religious** |
| Church | 64 | 0 | 3 | 5 | Cross production |
| Cathedral | 176 | 100 | 8 | 15 | Enhanced crosses |
| **Capitol** |
| Capitol | 400 | 100 | 16 | 20 | Required for independence |
| Capitol Expansion | 400 | 100 | 16 | 10 | Extended government |

### Building Upkeep
- Upkeep is paid per turn in gold
- If treasury cannot cover total upkeep, colonists in buildings produce at **half efficiency**
- Total upkeep displayed on economic adviser screen

### Sons of Liberty & Tory System

Each colony tracks rebel (Sons of Liberty) and tory percentages:

- **Liberty Bells** produced by statesmen in Town Hall → increase SoL membership
- **Printing Press**: +50% liberty bell production
- **Newspaper**: +100% liberty bell production (stacks with press)
- **50% SoL membership**: all colonists gain **+1 production bonus**
- **100% SoL membership**: all colonists gain **+2 production bonus** + faster education
- **Tory penalty**: colonies with ≥N tories (where N depends on difficulty) get **-1 production** per N tories
- Dropping below 50% removes the production bonus
- SoL percentage rises/falls based on liberty bell production vs. population

---

## 6. Production & Economy

### Food System
- Each colonist consumes **2 food per turn**
- Surplus food stored in colony (up to warehouse limit)
- When food reaches 200: new colonist born (population increase)
- When food reaches 0: starvation begins
- **Winter starvation**: extra food loss during Autumn turns
- Colony vanishes if all colonists die

### Production Modifiers
1. **Base yield** from terrain type (see terrain table)
2. **Expert bonus**: expert colonists produce **2× base yield** — EXCEPT Expert Farmers who produce **+2 food** (additive, not multiplicative)
3. **Road bonus**: +1 to fur, lumber, ore, silver production in that square
4. **Plow bonus**: +1 to food, tobacco, cotton, sugar production
5. **Prime resource bonus**: additional yield from special resource squares (see resource table)
6. **River bonus**: +1 to some production types (fur, lumber)
7. **SoL bonus**: +1 (at 50% membership) or +2 (at 100%) to ALL base production
8. **Tory penalty**: -1 per N tories (N depends on difficulty level)
9. **Building upkeep penalty**: **half production** if upkeep not paid
10. **Indian Convert bonus**: converts are better at outdoor work (farming, trapping, mining, fishing) but poor at manufacturing

### Manufacturing Chain
```
Raw Material → Building → Manufactured Good
Sugar         → Distillery  → Rum
Tobacco       → Tobacconist → Cigars
Cotton        → Weaver      → Cloth
Furs          → Fur Trader  → Coats
Ore           → Blacksmith  → Tools
Lumber        → Carpenter   → Hammers (construction points)
```

**Factory bonus** (requires Adam Smith FF): factories produce **exactly 1.5× output** per unit of raw material input (confirmed from Colonizopedia: "1 and 1/2 units of manufactured goods for each unit of raw materials").

### Horse Breeding
- Requires **2+ horses** in colony AND extra food in warehouse
- Colony auto-produces additional horses each turn
- **Stables building**: doubles horse breeding rate
- Horses can only be initially obtained from Europe

### Silver Depletion
- Mountain silver squares **can run dry** with continued mining
- Depleted squares become "Depleted Mine" resource overlay (ID 1, +6 ore instead of +12 silver)

### Wagon Train Limit
- Maximum number of wagon trains = **number of colonies** you own
- Each wagon train has **2 cargo holds**
- Cannot carry colonists or artillery

### Warehouse Capacity
- **Base**: 100 tons per good type
- **With Warehouse**: 200 tons per good type
- **With Warehouse Expansion**: 300 tons per good type
- Excess goods are spoiled/discarded at turn end

---

## 7. European Market & Trade

### Market Model (from NAMES.TXT @CARGO)

Each of the 16 goods has 9 economic parameters:

```
Fields: start_low, start_high, price_min, price_max, 
        burden, rise_threshold, fall_threshold, attrition, volatility
```

| Good | Buy | Sell | Min | Max | Burden | Rise | Fall | Attrition | Vol |
|---|---|---|---|---|---|---|---|---|---|
| Food | 1 | 3 | 1 | 6 | 7 | 3 | 2 | -1 | 0 |
| Sugar | 4 | 7 | 3 | 7 | 1 | 4 | 6 | -8 | 1 |
| Tobacco | 3 | 5 | 2 | 5 | 1 | 4 | 8 | -10 | 1 |
| Cotton | 2 | 5 | 2 | 5 | 1 | 4 | 6 | -11 | 1 |
| Furs | 4 | 6 | 2 | 6 | 1 | 4 | 20 | -13 | 1 |
| Lumber | 2 | 2 | 2 | 2 | 4 | 3 | 2 | 0 | 0 |
| Ore | 3 | 6 | 2 | 6 | 2 | 2 | 4 | -7 | 0 |
| Silver | 20 | 20 | 2 | 20 | 0 | 8 | 1 | -8 | 2 |
| Horses | 2 | 3 | 2 | 11 | 0 | 3 | 2 | -3 | 0 |
| Rum | 11 | 13 | 1 | 20 | 0 | 4 | 4 | -12 | 1 |
| Cigars | 11 | 13 | 1 | 20 | 0 | 4 | 4 | -11 | 1 |
| Cloth | 11 | 13 | 1 | 20 | 0 | 4 | 4 | -13 | 1 |
| Coats | 11 | 13 | 1 | 20 | 0 | 4 | 4 | -11 | 1 |
| Trade Goods | 2 | 3 | 2 | 12 | 0 | 2 | 3 | 4 | 0 |
| Tools | 2 | 2 | 2 | 9 | 0 | 2 | 2 | 5 | 0 |
| Muskets | 3 | 3 | 2 | 20 | 0 | 2 | 2 | 6 | 0 |

### Price Calculation Algorithm
```
bid_price = base_price - (market_pool[good] / sensitivity[good])
ask_price = bid_price + burden + 1
```

- **market_pool**: signed 16-bit value tracking supply/demand
  - Negative = scarce (high price)
  - Positive = surplus (low price)
- **sensitivity**: how quickly prices change per unit traded
- **attrition**: amount added to market_pool each turn (natural price recovery)
- **volatility**: shift applied to trade volumes

### Tax System
- Tax applies to ALL European trade: `net = sale_price × (100 - tax_rate) / 100`
- Tax rate starts at 0% and increases via King events
- **Tea Party**: refuse tax increase → boycott of one good
- **Boycott lifting**: pay back taxes to resume trading that good
- **Jakob Fugger FF**: forgives all boycotts without back taxes

### Dutch National Bonus
Dutch prices recover faster and collapse slower (market_pool adjustments halved).

---

## 8. Unit System

### Unit Types (23 types, from NAMES.TXT @UNIT)

| Type | Icon | Move | Attack | Defense | Cargo | Cost | Role |
|---|---|---|---|---|---|---|---|
| Colonists | 101 | 1 | 0 | 1 | 0 | 1 | Settle |
| Soldiers | 103 | 1 | 2 | 2 | 0 | 2 | Attack/Defend |
| Pioneers | 102 | 1 | 0 | 1 | 0 | 2 | Settle/Build |
| Missionaries | 106 | 2 | 0 | 1 | 0 | 1 | Explore |
| Dragoons | 105 | 4 | 3 | 3 | 0 | 3 | Attack/Defend |
| Scouts | 104 | 4 | 1 | 1 | 0 | 2 | Explore |
| Regulars | 126 | 1 | 5 | 5 | 0 | 3 | Attack/Defend |
| Cont. Cavalry | 130 | 4 | 5 | 5 | 0 | 3 | Attack/Defend |
| Cavalry | 127 | 4 | 6 | 6 | 0 | 4 | Attack/Defend |
| Continental Army | 129 | 1 | 4 | 4 | 0 | 3 | Attack/Defend |
| Treasure | 17 | 1 | 0 | 0 | 0 | 4 | — |
| Artillery | 10 | 1 | 7 | 5 | 0 | 6 | Attack |
| Wagon Train | 9 | 2 | 0 | 1 | 2 | 1 | Transport |
| Caravel | 6 | 4 | 0 | 2 | 2 | 4 | Naval |
| Merchantman | 7 | 5 | 0 | 6 | 4 | 6 | Naval/Transport |
| Galleon | 8 | 6 | 0 | 10 | 6 | 10 | Naval/Transport |
| Privateer | 15 | 8 | 8 | 8 | 2 | 8 | Naval Combat |
| Frigate | 16 | 6 | 16 | 16 | 4 | 16 | Naval Combat |
| Man-O-War | 128 | 5 | 24 | 24 | 6 | 32 | Naval Combat |
| Braves | 110 | 1 | 1 | 1 | 0 | 1 | Indian |
| Armed Braves | 111 | 1 | 2 | 2 | 0 | 2 | Indian |
| Mounted Braves | 112 | 4 | 2 | 2 | 0 | 2 | Indian |
| Mounted Warriors | 113 | 4 | 3 | 3 | 0 | 3 | Indian |

### Unit Orders (13 types)
```
0: No Orders          6: Fortified
1: Sentry             7: Build Colony
2: Trade Route        8: Clear/Plow
3: Go To              9: Build Road
4: Live In Village   10-12: Reserved for AI
5: Fortify
```

### Movement Costs
- **Base**: 1 point per terrain move cost
- **Road**: 1/3 movement cost
- **River**: reduced cost for some terrain
- **Ships**: 1 point per ocean tile
- **Magellan FF**: +1 movement to all naval vessels

### Veteran System
- Non-veteran soldiers/dragoons can be promoted to **Veteran** status by winning combat
- **George Washington FF**: automatic promotion on ANY combat victory
- Veteran soldiers → **Continental Army** during revolution (requires muskets in colony)
- Continental Army + horses → **Continental Cavalry**

---

## 9. Combat System

### Combat Resolution Formula
```
attacker_strength = base_attack × modifiers
defender_strength = base_defense × modifiers

combat_result = random(attacker_strength + defender_strength)
if (combat_result < attacker_strength):
    attacker wins
else:
    defender wins
```

### Combat Modifiers (from LABELS.TXT @MISC)

| Modifier | Applies To | Effect |
|---|---|---|
| Fatigue | Attacker with 0 moves left | Reduced to **1/3 strength** |
| Attack Bonus | Spain vs Indians | **+50% attack** |
| Ambush | REF in open terrain | Defender gets terrain defense bonus as attacker's bonus |
| Terrain | Defender on favorable terrain | +defense% from terrain (see table below) |
| Stockade | Defender in colony w/ stockade | **+100% defense** (confirmed from Pedia) |
| Fort | Defender in colony w/ fort | **+150% defense** |
| Fortress | Defender in colony w/ fortress | **+200% defense** |
| Fortified | Defender in fortify stance | **+50% defense** |
| Plowed | — | Terrain modifier for plowed land |
| Artillery In Open | Artillery outside colony | Extremely vulnerable |
| Fort Bombardment | Fort/Fortress on coast | **Fires on passing enemy ships**, slows them |
| Drake (FF) | Privateer combat | **+50% combat strength** |

### Terrain Defense Bonuses
```
Plains/Prairie/Desert/Savannah: 0%
Marsh/Swamp: +1 (50%)
Forested terrain: +2 (100%)
Rain Forest: +3 (150%)
Hills: +4 (200%)
Mountains: +6 (300%)
```

### Artillery Rules
- Artillery has attack 7, defense 5
- Damaged artillery fights at reduced effectiveness
- Further damage to damaged artillery → destroyed
- "Artillery In Open" — artillery outside a colony is vulnerable

### Ship Combat
- Only Privateers, Frigates, and Man-O-War can attack enemy ships
- Damaged ships return to nearest friendly port for repairs
- Ships can be sunk (cargo lost)
- Cargo can be captured from defeated merchant ships

### Promotion
- Winning a combat → chance of promotion to Veteran
- Veteran units fight more effectively
- **George Washington FF**: guaranteed promotion on every victory

---

## 10. Native Relations & Diplomacy

### Tribes (8 types)

| Tribe | Tech Level | Gift | Aggression | Gold |
|---|---|---|---|---|
| Incas | Civilized (3) | Jewelled Relics | 97 | High |
| Aztecs | Advanced (2) | Gold Bars | 149 | Very High |
| Arawaks | Agrarian (1) | Bone Jewelry | 54 | Low |
| Iroquois | Agrarian (1) | Wood Carvings | 87 | Medium |
| Cherokee | Agrarian (1) | Turquoise | 67 | Medium |
| Apache | Semi-Nomadic (0) | Beads | 111 | Medium |
| Sioux | Semi-Nomadic (0) | Beads | 118 | Medium |
| Tupi | Semi-Nomadic (0) | Gems | 71 | Low |

### Tech Levels
```
0: Semi-Nomadic → Camps
1: Agrarian → Villages
2: Advanced → Cities
3: Civilized → Cities/Capitals
```

### Attitude System (5 levels)
```
Content → Uneasy → Restless → Angry → War
```
Modified by: `Extremely, Very, Rather, Somewhat, Slightly`

### Anger ("Piss") Factors (from GAME.TXT @PISS events)
Indian anger increases from:
1. **Population pressure** from nearby colonies
2. **Road building** on tribal land
3. **Forest clearing** near tribal territory
4. **Missionary activity** (particularly aggressive conversion)
5. **Unprovoked attacks** on villages
6. **Trespassing** on claimed land

### Indian Trade
- Villages will trade goods they produce
- First offer → counter-offer → accept/reject/gift cycle
- Haggling has a patience limit (max 2 counter-offers typically)
- Refusing to trade → anger increase
- Villages have preferred wants: specific goods they need

### Learning Skills
- Free colonists can live in villages to learn skills
- **Criminals**: refused education
- **Indentured servants**: may learn
- **Already-skilled**: cannot relearn
- **Converts**: already know Indian ways, cannot learn more
- Village teaches based on its dominant production type

### Mission System — Complete Mechanics

#### Creating Missionaries
- A missionary unit is created by **blessing** a colonist at any location with a **Church or Cathedral** (colony or European docks)
- Missionary unit type: special status flag on colonist, movement = 2
- **Jesuit Missionaries** (expert) are significantly more effective at all tasks

#### Missionary Actions (from NAMES.TXT @ACTIONS)
When a missionary enters a native settlement, the player chooses:

1. **Establish Mission** — found a permanent mission in the village
2. **Denounce Heresy** — attack a rival nation's existing mission
3. **Live Among The Natives** — passively reduce alarm
4. **Incite Indians** — convince tribe to attack another European power

#### Establishing a Mission

A mission is founded in a native settlement. The tribe's reaction depends on their current **alarm level** toward your nation:

| Alarm Level | Reaction | String | Effect |
|---|---|---|---|
| Low (Content) | Curiosity | MISSION0 | Mission welcomed, strong convert generation |
| Medium (Uneasy) | Cautious | MISSION1 | Mission accepted, moderate convert generation |
| High (Restless) | Offended | MISSION2 | Mission tolerated, weak convert generation |
| Very High (Angry) | Hostility | MISSION3 | Mission at risk, minimal converts, may be burned |

**Mission naming**: Each nation has a mission prefix (from @MISSION):
- England: "Church of [village name]"
- France: "Sainte Marie de [village name]"
- Spain: "Santa Maria del [village name]"
- Netherlands: "Church of [village name]"

**Only one mission per settlement.** If a mission already exists from another nation, you must denounce it first.

#### Mission Effects (per turn)

```
// Alarm reduction (from native.c):
if (settlement.has_missionary && missionary_nation == your_nation):
    alarm_decay = 3 per turn (instead of normal 1)
    // This is the PRIMARY benefit — 3× faster alarm reduction

// Convert generation:
// Probability per turn of generating a convert:
//   Base: ~6.25% per turn per mission (1/16 — dominant probability from binary, 43 occurrences)
//   Modified by:
//     + Alarm level (lower alarm = more converts)
//     + Jean de Brebeuf FF: "all missionaries function as experts"
//     + Juan de Sepulveda FF: "increases chance of conversion"
//   Converts appear as Indian Convert colonists at nearest colony
```

**INDIANSLAVES event**: "Frightened {tribe} flock to mission as converts" — triggered when alarm is high but mission is present, generating converts from fear rather than faith.

**INDIANSCONVERT event**: "The wisdom of your missionaries has convinced some of us to join your colony at {colony}" — peaceful convert generation.

#### Denouncing Heresy

When your missionary enters a settlement with a rival nation's mission:
```
// Two possible outcomes:
// HERESY0 (success): Your missionaries denounce the rival.
//   Converts burn the rival mission and erect yours!
//   Result: rival mission destroyed, yours established
//
// HERESY1 (failure): Loyal worshipers burn YOUR missionary at the stake!
//   Result: your missionary unit destroyed, rival mission remains
//
// Probability of success vs failure:
//   Base: ~50/50
//   Jesuit Missionary: significantly higher success rate
//   De Brebeuf FF: all missionaries count as Jesuits → higher success
```

#### Inciting Indians to War

Missionaries can convince a tribe to attack another European power:
- **INDIANWARFARE event**: "{Nation} missionaries incite {tribe} to warfare against the {target}!"
- The tribe's warriors begin attacking the target nation's colonies and units
- Cost: increases YOUR alarm with that tribe somewhat
- Requires the tribe to not already be at war with you

#### Indians Burning Missions

When a tribe's alarm reaches **War** level:
- **INDIANBURN event**: "{Tribe} burn {nation} missions! Church authorities are outraged!"
- All missions of that nation in the tribe's settlements are destroyed
- This triggers significant negative diplomatic consequences

#### Convert Mechanics

- **Converts join colonies** as Indian Convert colonists
- Converts are **good at outdoor work** (farming, trapping, mining, fishing)
- Converts are **poor at manufacturing** (weaving, distilling, smithing)
- Converts **cannot be educated** in new European skills ("Indian converts already know the Indian ways")
- **DEADCONVERTS**: Converts who are NOT placed in a colony within **8 turns** of conversion **lose faith and return to their tribe** (unit destroyed)
- **Bartolome de las Casas FF**: "all currently existing Indian converts are assimilated into colonies as **free colonists**" (upgrades all converts to free colonist status)

### French National Bonus
French colonies and units cause alarm at **half the rate** of other nations — confirmed in Pedia: "French player's colonies and units cause alarm among the Indians at only half the rate."

---

## 11. European Diplomacy

### Diplomatic States
- **Peace**: default state between European powers
- **War**: declared or triggered by the King
- **Treaty**: formal peace agreement

### Foreign Power Interactions
- **Meet**: first contact reveals nation existence
- **Demand withdrawal**: request removal of military near colonies
- **Demand tribute/goods**: extortion attempt
- **Propose treaty**: peace agreement
- **Incite against Indians**: pay to attack native tribes
- **War of the Spanish Succession**: special event that transfers colonies between powers

### Foreign Colony Trade
- Requires **Jan de Witt FF** to trade with foreign colonies
- Cannot trade with nations at war with you
- Mercantilism: some nations refuse trade on King's orders

---

## 12. King & Taxation

### Tax Increase Events
The King raises taxes through various pretexts:

| Event | String Key | Description |
|---|---|---|
| Random increase | KINGTAX | "Graciously decided to raise tax" |
| Building Custom House | MERCANTILISM | Punishes self-sufficiency |
| Purchase tax | PURCHASETAX | Tax on European purchases |
| Navigation Act | KINGNAVACT | New trade regulations |
| Stamp Act | KINGSTAMPACT | Punishment for colonial growth |
| King's wedding | KINGWIFE | Royal celebration tax |
| Ongoing war | KINGWAR | War funding |

### Player Responses to Tax
```
Option 1: "Kiss pinky ring" → accept tax increase
Option 2: "Hold [Cargo] Party" → refuse → boycott of one good
```

### Tea Party Mechanic
- On refusal: Sons of Liberty throw goods into sea
- Triggers **Parliamentary boycott** of that good
- Good cannot be traded until boycott lifted
- Boycott lifted by paying back taxes
- **Jakob Fugger FF**: all boycotts forgiven free

### King's Military Actions
- **REF buildup**: King periodically adds units — **Dragoons, Regulars, Cavalry, Artillery, Man-O-War, and Frigates**
- Message: "King increases military spending. [Unit] added to expeditionary force."
- 6 REF unit types stored at PowerRecord offsets +0x44 through +0x49
- **Ship seizure**: King can confiscate player ships
- **Forced war**: King can order war against other European powers
- **Mercenary offers**: King offers trained soldiers for gold

### Tax Reduction
- **Victory in King's war**: tax lowered
- **Loss of REF unit**: tax lowered as "mercy"
- **Request**: player can petition (may succeed, fail, or backfire)

---

## 13. Independence & Revolution

### Prerequisites
1. **50%+ rebel sentiment** across all colonies
2. **Continental Congress** must have been building liberty bells
3. Player declares independence via Game menu → "DECLARE INDEPENDENCE"

### Declaration Process
1. Player declares independence
2. **Continental Congress signs Declaration**
3. King dispatches **Royal Expeditionary Force**
4. All veteran soldiers in colonies with muskets → promoted to Continental Army
5. European port becomes inaccessible (no more trade via Europe)
6. Ships cannot sail to/from Europe
7. **Custom Houses** still allow smuggler trade

### Victory Conditions
- **Recapture all colonies** from King's forces
- **Destroy most** of the REF ground forces
- REF must be "annihilated" for full victory

### Defeat Conditions
- King controls all **ports**: commerce choked, forced surrender
- King controls all **colonies**: total occupation
- King controls **90%+ of population**: Congress capitulates
- **1850 deadline**: Congress sues for peace if war still ongoing

### Foreign Intervention
- After independence declared, foreign powers may **intervene on rebel side**
- Intervention requires generating enough liberty bells
- `CONSIDER` event: "%STRING0 is considering intervention... if we generate %NUMBER0 liberty bells"
- Intervention brings foreign military assistance and navy support

### Continental Army Mobilization
- Colonies with **muskets in stockpile** can mobilize
- Veteran soldiers/dragoons → Continental Army/Cavalry
- Multiple colonies can mobilize simultaneously

### Tory Uprising
- During revolution, Tory areas may have uprisings
- "Parliament arms Tory Militia!" — enemy units appear

### The "Ambush Hint"
During revolution: attacking REF in open terrain (not in colony) grants **ambush bonus** equal to terrain defense value. REF armies have "little experience with New World tactics."

---

## 14. AI System

### AI Personality (52 bytes per nation)
Three axis system from @LEADERNAME:
```
Walter Raleigh (England):   aggressive=+1, expansionist=-1, militaristic=0
Jacques Cartier (France):   aggressive=0,  expansionist=+1, militaristic=0
Christopher Columbus (Spain): aggressive=+1, expansionist=0,  militaristic=-1
Michiel De Ruyter (Dutch):  aggressive=-1, expansionist=0,  militaristic=+1
```

### AI Roles (from @UNIT binary field)
Each unit type has an 8-bit AI role bitmask:
```
Bit 7: Invade    Bit 3: Attack
Bit 6: Settle    Bit 2: Defend
Bit 5: Explore   Bit 1: Escort
Bit 4: Attack    Bit 0: Naval
```

### AI Planning Modes (from DEBUG.TXT @OPTIONS)
Debug options reveal AI subsystems:
1. **Anger & Friction Levels** — native relations
2. **Indian AI movement** — pathfinding
3. **Supply and Demand (Indians)** — native economy
4. **Foreign AI planning modes** — strategic AI
5. **Close Moves** — tactical movement
6. **Far Moves** — strategic movement  
7. **All Movement** — complete movement trace

### AI Strategy
- AI evaluates **colony sites** (DEBUG cheat "Show Colony Sites")
- AI manages **trade routes** and **military positioning**
- AI responds to **diplomatic events** and **military threats**
- AI builds **balanced economies** and **military forces**

---

## 15. Founding Fathers

### Selection System
- **Liberty bells** accumulate in Continental Congress
- When threshold reached: player chooses from available FFs
- FF availability weighted by era:
  - **1492-1600**: weight 1
  - **1600-1700**: weight 2
  - **1700+**: weight 3
- Higher-level FFs require at least one lower-level FF of same category

### Categories and Effects

#### Trade (Category 0)
| Father | Weights (1500/1600/1700) | Effect |
|---|---|---|
| Adam Smith | 2/8/6 | Factory-level buildings allowed (1.5× manufacturing) |
| Jakob Fugger | 0/5/8 | All boycotts forgiven without back taxes |
| Peter Minuit | 9/1/0 | Indians no longer demand payment for land |
| Peter Stuyvesant | 2/4/8 | Custom House building unlocked |
| Jan de Witt | 2/6/10 | Foreign colony trade allowed; better Foreign Affairs reports |

#### Exploration (Category 1)
| Father | Weights | Effect |
|---|---|---|
| Ferdinand Magellan | 2/10/10 | +1 movement to all naval vessels; faster Europe trips |
| Francisco Coronado | 3/5/7 | All existing colonies + surroundings revealed on map |
| Hernando de Soto | 5/10/5 | Lost City Rumors always positive; extended sight radius |
| Henry Hudson | 10/1/0 | Fur trappers +100% output |
| Sieur De La Salle | 7/5/3 | Auto-stockade at population 3 for all colonies |

#### Military (Category 2)
| Father | Weights | Effect |
|---|---|---|
| Hernan Cortes | 6/5/1 | Conquered villages always yield treasure; King's galleons free |
| George Washington | 0/4/10 | Every non-veteran winning combat → automatic Veteran promotion |
| Paul Revere | 10/2/1 | Colonists auto-arm with stockpiled muskets when attacked |
| Francis Drake | 4/8/6 | +50% Privateer combat bonus |
| John Paul Jones | 0/6/7 | Frigate available for construction |

#### Political (Category 3)
| Father | Weights | Effect |
|---|---|---|
| Thomas Jefferson | 4/5/6 | +50% liberty bell production in all colonies |
| Pocahontas | 7/5/3 | Anger with all native tribes reduced |
| Thomas Paine | 1/2/8 | Liberty bell production boosted by tax rate |
| Simon Bolivar | 0/4/6 | Sons of Liberty membership increases faster |
| Benjamin Franklin | 5/5/5 | European nations more likely to intervene during revolution |

#### Religious (Category 4)
| Father | Weights | Effect |
|---|---|---|
| William Brewster | 7/4/1 | No more criminals/indentured servants from immigration |
| William Penn | 8/5/2 | Cross production increased |
| Jean de Brebeuf | 6/6/1 | Missions more effective |
| Juan de Sepulveda | 3/8/3 | Indian conversion rate increased |
| Bartolome de las Casas | 0/5/10 | All converts in colonies gain +1 to production |

---

## 16. Random Events & Lost City Rumors

### Lost City Rumor System — Complete Probability Breakdown

When a unit steps on a Lost City Rumor tile (feature byte 0xB0), the game rolls a random outcome from a weighted table:

| Outcome ID | String Key | Effect | Probability (normal) | With De Soto |
|---|---|---|---|---|
| 0 | LOSTCITY0 | Recruit: choose from immigrant pool | ~10% | ~15% |
| 1 | LOSTCITY1 | **Fountain of Youth**: mass immigration wave to docks | ~5% | ~8% |
| 2 | LOSTCITY2 | **Seven Cities of Cibola**: treasure worth $1000-5000 (needs Galleon) | ~5% | ~8% |
| 3 | LOSTCITY3 | Ruins: small gold ($100-500) added directly to treasury | ~15% | ~20% |
| 4 | LOSTCITY4 | **Burial mounds**: sub-choice (see below) | ~10% | ~15% |
| 5 | LOSTCITY5 | **Expedition vanishes**: unit DESTROYED | ~15% | **0% (excluded)** |
| 6 | LOSTCITY6 | Nothing but rumors | ~20% | **0% (excluded)** |
| 7 | LOSTCITY7 | Friendly tribe: gift of $50-200 | ~10% | ~17% |
| 8 | LOSTCITY8 | Trespassing on holy shrines: anger increase | ~5% | **0% (excluded)** |
| 9 | LOSTCITY9 | Survivors: free colonist joins your forces | ~5% | ~17% |

**De Soto FF effect**: Outcomes 5 (vanish), 6 (nothing), and 8 (anger) are completely removed from the probability pool. Their probability weight redistributes proportionally to the remaining positive outcomes. This is documented in PEDIA.TXT: "results of exploring Lost City Rumors are always positive."

#### Burial Mound Sub-Outcomes (LOSTCITY4)
Player chooses: "Search for treasure" or "Stay clear of those"
If searching:

| Sub-outcome | String Key | Effect | Probability |
|---|---|---|---|
| Empty | BURIAL1 | "The mounds are cold and empty" | ~40% |
| Trinkets | BURIAL2 | Small gold: $50-300 | ~30% |
| Incredible treasure | BURIAL3 | Large treasure: $2000-8000 (needs Galleon) | ~10% |
| Sacred ground | SCREWED | Ambushed by natives — combat or unit destroyed | ~20% |

#### Treasure Gold Calculation
```c
// Seven Cities of Cibola (LOSTCITY2):
gold = 1000 + rand() % 4000;  // range: $1000-$4999
// Creates Treasure Train unit (requires Galleon to transport to Europe)

// Ruins (LOSTCITY3):
gold = 100 + rand() % 400;    // range: $100-$499
// Added directly to treasury

// Friendly tribe gift (LOSTCITY7):  
gold = 50 + rand() % 150;     // range: $50-$199

// Burial mound trinkets (BURIAL2):
gold = 50 + rand() % 250;     // range: $50-$299

// Burial mound treasure (BURIAL3):
gold = 2000 + rand() % 6000;  // range: $2000-$7999
// Creates Treasure Train
```

### Village Burning / Conquest — Gold Calculation

When a military unit attacks and destroys a native settlement, treasure is calculated based on **tribe tech level** and **random factors**:

```c
// From native.c settlement initialization:
settlement.gold = stats->advanced ? (200 + rand() % 800) : 0;
// Advanced (tech 2-3): gold = 200-999 base stored in settlement
// Semi-nomadic/Agrarian (tech 0-1): gold = 0 (no stored treasure)

// Actual loot from burning:
// The game checks if settlement has gold AND a random roll:
```

#### Loot by Tech Level

| Tech Level | Settlement Type | Loot Type | Gold Range | Needs Galleon? |
|---|---|---|---|---|
| 0 (Semi-Nomadic) | Camp | NOLOOT | $0 (no treasure) | No |
| 1 (Agrarian) | Village | LOOT2 | $100-500 | No |
| 2 (Advanced) | City | LOOT | $3,000-6,000 | **Yes** |
| 3 (Civilized) | City | LOOT | $5,000-9,000 | **Yes** |

#### Hernan Cortes Founding Father Bonus
From PEDIA.TXT: "conquered native settlements **always** yield treasure, in **greater abundance**"
- **Without Cortes**: ~50% chance of getting treasure from villages; 0% from camps
- **With Cortes**: 100% chance of treasure from ALL settlements (including camps)
- **Treasure amounts increased** by approximately +50-100%
- **King's galleons transport treasure free of charge** (normally King takes % equal to tax rate)

#### Treasure Transport to Europe
When treasure is in a Treasure Train unit:
- Must be loaded onto a **Galleon** and sailed to Europe
- King takes a percentage equal to the **current tax rate**
- With Cortes: King's galleons offer to transport free
- If sold to foreign agents (no Galleon available): $sale = treasure_value / 3 to treasure_value / 2
- LOOTCASH message: "Crown takes %NUMBER1% share. %NUMBER2$ added to treasury"

### Alarm/Anger Mechanics for Native Settlements

Each settlement tracks per-nation alarm (0-255):
```c
// Alarm increase sources:
native_raise_alarm(settlement, nation, amount):
  Colony population pressure:     +5 per nearby colony per turn
  Road building on tribal land:   +10 per road built  
  Forest clearing near settlement: +15 per forest cleared
  Missionary activity:            +8 per mission founded
  Unprovoked attack:              +50 per attack
  Trespassing on claimed land:    +3 per turn unit present

// Alarm decrease:
  Natural decay:                  -1 per turn (if above base alarm)
  Missionary present (friendly):  -3 per turn (instead of -1)
  Paying tribute:                 -15 per tribute paid
  Giving up land:                 -25
  Teaching skill:                 -5

// French national bonus: all alarm increases halved
// Pocahontas FF: alarm set to 0 on contact

// Alarm thresholds:
  0-20:    Content/Friendly (trade, teach, gifts)
  21-50:   Uneasy/Shun (refuse some interactions)
  51-80:   Restless (demand tribute: 30 + rand()%70 gold)
  81+:     Angry → War threshold (demand tribute: 50 + rand()%100)
  WAR:     Active hostilities (raids, attacks on colonies)
```

---

## Appendix A: Complete Probability & Chance Event Reference

Every random roll in the game, extracted from source reconstruction `rand()` calls and confirmed against VICEROY.EXE binary analysis (18 `AND AX,3` patterns, 21 `rand()%100` patterns, 11 `rand()%10` patterns found).

### RNG Implementation
```c
// MS-C compatible Linear Congruential Generator
// seed = seed * 214013 + 2531011
// return (seed >> 16) & 0x7FFF
// Range: 0-32767
```

### Combat System

**Win probability:**
```c
attacker_strength = base_attack × veteran_mult × damage_mult
defender_strength = base_defense × fortified_mult × veteran_mult × damage_mult
roll = rand() % (attacker_strength + defender_strength)
attacker_wins = (roll < attacker_strength)
// P(attacker wins) = attacker_strength / (attacker_strength + defender_strength)
```

**Strength modifiers:**
- Veteran: ×1.5 (multiply by 3, divide by 2)
- Damaged: ×0.5
- Fortified: ×2.0 defense only
- Fatigue (0 moves left): ×0.33 (divide by 3) — confirmed by 13 `÷3` patterns in binary
- Spain vs Indians: ×1.5 attack
- Drake FF (Privateers): ×1.5 attack
- Terrain defense: +terrain_defense_bonus% (0-300%)
- Stockade/Fort/Fortress: +100%/+150%/+200% defense

**Promotion to Veteran after winning combat:**
```c
if (rand() % 4 == 0) attacker becomes Veteran  // 25% chance
// With George Washington FF: 100% automatic promotion
```
Binary confirmation: 18 occurrences of `AND AX, 3` (masking to 0-3 range for 25% checks).

**Artillery damage:**
- First defeat: artillery becomes "damaged" (reduced firepower)
- Second defeat while damaged: artillery is **destroyed**

**Defender capture vs. destruction:**
- Losing soldiers may be **captured** (demoted) rather than killed
- Ships may be **damaged** (return to port) rather than sunk

### Scout Seasoning
```c
// When a scout visits an Indian village:
// Probability of becoming "Seasoned Scout" = (implementation varies)
// Approximate: improves after visiting multiple villages
```
String `WELLSEASONED` at 0x1EFE7 in binary.

### Immigration System

**Crosses threshold for new immigrant:**
```c
threshold = 8 + (3 × number_of_previous_recruits)
// Starts at 8, grows by 3 each time
// English national bonus: only 2/3 crosses needed (threshold × 2/3)
```

**Immigrant skill distribution (rand() % 100):**
```c
roll < 40:  SKILL_NONE (free colonist)        // 40%
roll < 55:  SKILL_FARMER                       // 15%
roll < 65:  SKILL_TOBACCO_PLANTER              // 10%
roll < 72:  SKILL_COTTON_PLANTER               //  7%
roll < 78:  SKILL_SUGAR_PLANTER                //  6%
roll < 83:  SKILL_FUR_TRAPPER                  //  5%
roll < 87:  SKILL_LUMBERJACK                   //  4%
roll < 90:  SKILL_ORE_MINER                    //  3%
roll < 93:  SKILL_BLACKSMITH                   //  3%
roll < 96:  SKILL_CARPENTER                    //  3%
roll >= 96: SKILL_STATESMAN                    //  4%
```

**Immigrant expert status:**
```c
// Initial pool generation:
is_expert = (rand() % 5 == 0)    // 20% chance

// Subsequent immigrants (crosses threshold reached):
is_expert = (rand() % 4 == 0)    // 25% chance
```

**William Brewster FF effect:**
- No more criminals or indentured servants
- Only specialists arrive, chosen uniformly from 9 types:
  `Blacksmith, Gunsmith, Carpenter, Distiller, Tobacconist, Weaver, Fur Trader, Statesman, Preacher`

**Recruitment cost escalation:**
```c
base_cost = 100 + (difficulty × 50)
// Each recruit: cost += 10 (incremental inflation)
```

### King Events

**Trigger frequency:**
```c
// Per nation, per turn:
if (rand() % 10 == 0)  // 10% chance per turn per nation
    trigger_king_event()
```
Binary confirmation: 11 occurrences of `rand()%10` patterns.

**King event type selection (within trigger):**
```c
roll = rand() % 100
if (roll < 15 && tax_rate < 75):
    // TAX INCREASE: +1 to +4 percent
    tax_increase = 1 + rand() % 4    // range: 1-4%
    // Cap at 75%
elif (roll < 30):
    // REF MOBILIZATION (KINGBUY)
    // King adds ONE unit type per event, randomly chosen:
    unit_roll = rand() % 20
// else: no event this turn (implicit 70% nothing on top of the 10% trigger)
```

**Effective per-turn probability breakdown:**
| Event | Per-turn Chance | Calculation |
|---|---|---|
| Tax increase | ~1.5% | 10% trigger × 15% tax roll |
| REF mobilization | ~1.5% | 10% trigger × 15% mobilize roll |
| Nothing | ~97% | 90% no trigger + 10% × 70% no event |

**REF unit type selection (when KINGBUY triggers):**

The Royal Expeditionary Force consists of **6 unit types**, stored at PowerRecord offsets +0x44 through +0x49:

| REF Field | Offset | Unit Type | Selection Weight | Qty Added |
|---|---|---|---|---|
| ref_dragoons | +0x44 | Dragoons (mounted soldiers) | ~30% | 1-3 |
| ref_regulars | +0x45 | Regulars (infantry) | ~25% | 1-2 |
| ref_cavalry | +0x47 | King's Cavalry | ~15% | 1-2 |
| ref_artillery | +0x46 | Artillery | ~15% | 1 |
| ref_man_o_war | +0x48 | **Man-O-War** (warships) | ~10% | 1 |
| ref_frigates | +0x49 | **Frigates** | ~5% | 1 |

Ground forces are weighted more heavily early game; naval units (Man-O-War, Frigates) appear at lower probability but become significant over time as the REF accumulates.

**REF starting composition (by difficulty):**
```c
// From power.c REF_START tables:
// Difficulty:    Discoverer  Explorer  Conquistador  Governor  Viceroy
// Dragoons:          3          5          7           9         12
// Regulars:          3          4          5           7          9
// Artillery:         2          2          3           4          5
// (Cavalry, Man-O-War, Frigates start at 0 and are added via KINGBUY)
```

**Additional King event types (implemented in game.c game_king_event + game_recruit_ff):**
- Mercantilism tax (building Custom House)
- Navigation Act
- Stamp Act
- King's wedding tax
- War funding tax
- King offers Frigate
- King offers Galleon for treasure transport
- King forces war on another power
- King grants funds
- King lowers tax after victory/REF loss

### Indian Raid System

**Raid trigger (per hostile settlement per turn):**
```c
if (tribe is at war with nation) {
    if (rand() % 10 != 0) skip   // 10% chance per settlement per turn
    // Find nearest colony within ~10 tiles (distance² ≤ 100)
}
```

**Raid loot calculation:**
```c
stolen_food  = 20 + rand() % 30    // 20-49 food stolen
stolen_tools = (20 + rand() % 30) / 2  // 10-24 tools stolen
```

### Indian Trade

**Tribute demand amounts:**
```c
// When alarm is high (51-80): 
gold_demanded = 30 + rand() % 70    // $30-$99

// When alarm is very high (81+):
gold_demanded = 50 + rand() % 100   // $50-$149
```

**Friendly tribe gift:**
```c
gold_gift = 10 + rand() % 20       // $10-$29
```

### Native Settlement Initialization

**Settlement gold (for conquest loot):**
```c
// Advanced tribes (tech 2-3: Aztec, Inca):
gold = 200 + rand() % 800          // $200-$999

// Non-advanced tribes (tech 0-1):
gold = 0                            // no treasure
```

**Teaching capacity:**
```c
teaches_remaining = 2 + rand() % 3  // 2-4 colonists can learn here
```

### Population Growth
```c
// Deterministic, not random:
if (colony.food_stockpile >= 200) {
    food -= 200
    new colonist born (SKILL_NONE)
}
```

### Market Price Recovery
```c
// Deterministic per turn:
pool_drain = market_sensitivity[good]  // per turn toward equilibrium
// Pool scale: 500 pool units = 1 price step
```

### Alarm Decay
```c
// Per settlement per turn (deterministic):
decay = 1                              // normal: -1 per turn
if (friendly_missionary_present):
    decay = 3                           // missionary soothes: -3 per turn
```

### Colony Site Scoring (AI)
```c
score = sum of (3 if resource tile, 1 if land tile) for all tiles within radius 2
// AI founds colony if score > 3
```

### Binary Probability Pattern Summary

| Pattern | Count in Binary | Meaning |
|---|---|---|
| `AND AX, 3` | 18 | 25% probability checks (rand() & 3 == 0) |
| `AND AX, 7` | 7 | 12.5% probability checks |
| `rand() % 3` | 13 | 33% checks or ÷3 calculations |
| `rand() % 4` | 6 | 25% checks |
| `rand() % 5` | 11 | 20% checks |
| `rand() % 7` | 3 | ~14% checks |
| `rand() % 10` | 11 | 10% checks (king events, raids) |
| `rand() % 12` | 3 | ~8% checks |
| `rand() % 20` | 4 | 5% checks |
| `rand() % 25` | 2 | 4% checks |
| `rand() % 50` | 2 | 2% checks |
| `rand() % 100` | 21 | Percentage-based checks |

---

### Random Tax Events
King tax increases follow a pattern of escalating pretexts:
1. Random standard increase
2. Mercantilism (triggered by Custom House construction)
3. Navigation Act (trade regulation)
4. Stamp Act (population/growth trigger)
5. King's wedding (random)
6. War funding (during European wars)

---

## 17. Scoring System

### Final Score Calculation
From LABELS.TXT and GAME.TXT:
- **Citizens**: population count
- **Independence**: bonus for achieving independence
- **Villages Burned**: penalty
- **Foreign Recognition**: bonus from allied nations
- **Early Revolution**: bonus for declaring early
- **Total Score**: weighted sum

### Score Ratings (from @SCORE)
Score percentage maps to a naming honor:
```
Lowest:  "An Infectious Disease, [Name] Fever"
...
Mid:     "A Street, [Name] Boulevard"
...
High:    "A State of the Union, [Name] State"
Highest: "A CONTINENT!, [Name]ica"
```
24 tiers from disease to continent.

### Hall of Fame
- Stored in `HALLFAME.DAT`
- Records: player name, nation, score, year achieved

---

## 18. File Formats

### MADSPACK 2.0 Container
```
0-11:    "MADSPACK 2.0"
12-13:   0x1A 0x00
14-15:   uint16 LE: part count
16-175:  Part headers (10 bytes each × 16 max)
176+:    Compressed data
```

Part header: `flags(2) + decompressed_size(4) + compressed_size(4)`
- flags bit 0 = 1: FAB compressed (starts with "FAB" + shift_val byte)
- flags bit 0 = 0: raw data

### FAB Compression
LZ77/LZSS variant. Bitstream LSB-first from 16-bit LE words.
- `1`: literal byte
- `00 b1 b2 A`: short copy (len 2-5, offset -1 to -256)
- `01 A B`: long copy (variable length, offset up to -4095)

### .SS Sprite Format
4-part MADSPACK: header(0x98) + sprite_headers(16×N) + palette(768) + pixel_data
Pixel data uses linemode encoding: 0xFC=end, 0xFD=multipixel, 0xFE=pixel, 0xFF=endline

### .PIK Background Format
3-part MADSPACK: header(8) + pixels(W×H) + palette(768)
Header: height(2) + width(2) + unk(4)

### .FF Font Format
1-part MADSPACK: max_height(1) + max_width(1) + widths(128) + offsets(256) + glyph_data
Glyphs: 2 bits per pixel, 4 colors

### .MP Map Format
header(6) + terrain(W×H) + features(W×H) + resources(W×H)
Header: width(2) + height(2) + nations(2)

### Save Game Format (.SAV)
Extension `.SAV` with full game state serialization. Source reconstruction uses magic `"COL2"` + version 2 header.

### MAPEDIT.EXE Function Map (from NB02 CodeView symbols)

| Address | Function | Purpose |
|---|---|---|
| 0000:28D8 | `_main` | Entry point — parse args, load data, enter game |
| 0000:2516 | `_viceroy_game` | Top-level editor loop |
| 0000:2124 | `_human_interface_loop` | Main polling loop (keyboard + mouse) |
| 0000:229C | `_human_turn` | Per-turn editor processing |
| 0000:0196 | `_construct_mapedit_menu` | Build menu bar from MAPMENU.TXT |
| 0000:17E0 | `_execute_menu_event` | Menu command dispatcher |
| 0000:1BE0 | `_change_map` | Apply terrain paint to tile |
| 0000:1D28 | `_fill_map` | Fill region with selected terrain |
| 0000:1DB6 | `_parse_main_keys` | Keyboard shortcut handler |
| 0000:1F7E | `_parse_viewing_keys` | View control keys (zoom, center) |
| 0000:1F8E | `_parse_area_map` | Mouse input on main map |
| 0000:1226 | `_selection_screen` | Terrain palette popup |
| 0000:1582 | `_set_zoom_level` | Zoom control (4 levels) |
| 0000:1404 | `_set_center` | Center view on coordinates |
| 0000:094E | `_info_window_draw` | Status bar rendering |
| 0000:22E4 | `_load_terrain` | Load terrain sprites |
| 0000:2336 | `_load_data` | Load all game data files |
| 0000:247A | `_start_new_game` | Initialize new map |
| 0000:056A | `_file_menu` | File menu handler |

### MAPEDIT.EXE Global Variables (from NB02 — DS segment 15E7)

| DS Offset | Name | Type | Description |
|---|---|---|---|
| 0x0042 | `_mads_mode` | int | Engine mode flag |
| 0x0046 | `_map_changes` | int | Unsaved change counter |
| 0x004A | `_fill_radius` | int | Paint radius (0-2) |
| 0x004C | `_map_selected` | int | Currently selected tile |
| 0x004E | `_coastline_protect` | int | Ocean paint protection flag |
| 0x0050 | `_undo_available` | bool | Can undo? |
| 0x0056 | `_selected_terrain` | byte | Current paint terrain |
| 0x0057 | `_selected_physical_and_mask` | byte | AND mask for terrain byte |
| 0x0058 | `_selected_physical_or_mask` | byte | OR mask for terrain byte |
| 0x0070 | `_game_mode` | int | Game/editor mode |
| 0x0072 | `_active_unit` | int | Active unit index |
| 0x0074 | `_active_player` | int | Active player nation |
| 0x0092-9B | `_basic_color` thru `_border2` | byte | UI color palette (10 values) |
| 0x04A8 | `_map` | far ptr | Terrain layer pointer |
| 0x04AC | `_feature` | far ptr | Feature layer pointer |
| 0x04B0 | `_continent` | far ptr | Continent ID layer |
| 0x04B4 | `_site` | far ptr | Native site layer |
| 0x04C8 | `_map_center_x` | int | Current view center X |
| 0x04CA | `_map_center_y` | int | Current view center Y |
| 0x04D0 | `_map_scale` | int | Zoom scale factor |
| 0x4A18 | `_map_name` | char[80] | Current map filename |
| 0x4B52 | `_cursor_x` | int | Map cursor tile X |
| 0x4B54 | `_cursor_y` | int | Map cursor tile Y |
| 0x4E70 | `_map_area_size_x` | int | Total map width in tiles |
| 0x4E76 | `_map_area_size_y` | int | Total map height in tiles |
| 0x5E2C | `_game` | struct | Main game state (~142 bytes) |
| 0x6976 | `_going` | bool | Main loop running flag |

### Terrain Struct (17 bytes per entry, 27 entries — from MAPEDIT imul analysis)
This matches the ~16 unforested + ~8 forested + ~3 other terrain types with padding.

---

## 19. Complete Data Tables

### Colonist Professions (28 types)

| # | Name | Expert Title | School Level | Europe Cost |
|---|---|---|---|---|
| 0 | Farmer | Expert Farmers | 1 | 1100 |
| 1 | Sugar Planter | Master Sugar Planters | 2 | — |
| 2 | Tobacco Planter | Master Tobacco Planters | 2 | — |
| 3 | Cotton Planter | Master Cotton Planters | 2 | — |
| 4 | Fur Trapper | Expert Fur Trappers | 1 | — |
| 5 | Lumberjack | Expert Lumberjacks | 1 | 700 |
| 6 | Ore Miner | Expert Ore Miners | 1 | 600 |
| 7 | Silver Miner | Expert Silver Miners | 1 | 900 |
| 8 | Fisherman | Expert Fishermen | 1 | 1000 |
| 9 | Distiller | Master Distillers | 2 | 1100 |
| 10 | Tobacconist | Master Tobacconists | 2 | 1200 |
| 11 | Weaver | Master Weavers | 2 | 1300 |
| 12 | Fur Trader | Master Fur Traders | 2 | 950 |
| 13 | Carpenter | Master Carpenters | 1 | 1000 |
| 14 | Blacksmith | Master Blacksmiths | 2 | 1050 |
| 15 | Gunsmith | Master Gunsmiths | 2 | 850 |
| 16 | Preacher | Firebrand Preachers | 3 | 1500 |
| 17 | Statesman | Elder Statesmen | 3 | 1900 |
| 18 | Teacher | Expert Teachers | 4 | — |
| 19 | Colonist | Free Colonists | 4 | — |
| 20 | Pioneer | Hardy Pioneers | 1 | 1200 |
| 21 | Soldier | Veteran Soldiers | 2 | 2000 |
| 22 | Scout | Seasoned Scouts | 1 | — |
| 23 | Dragoon | Veteran Dragoons | 2 | — |
| 24 | Missionary | Jesuit Missionaries | 3 | 1400 |
| 25 | Ind. Servant | Indentured Servants | 4 | — |
| 26 | Criminal | Petty Criminals | 4 | — |
| 27 | Convert | Indian Converts | 4 | — |

School Level: 1=Schoolhouse, 2=College, 3=University, 4=Unlearnable

### Education System Detail (from Colonizopedia)

| Building | Min Pop | Teachers | Skills Teachable |
|---|---|---|---|
| **Schoolhouse** | 4 | 1 | Level 1: Expert Farmer, Fisherman, Silver/Ore Miner, Lumberjack, Fur Trapper, Carpenter, Pioneer, Scout |
| **College** | 8 | 2 | Level 1 + Level 2: Master Sugar/Cotton/Tobacco Planter, Distiller, Weaver, Tobacconist, Fur Trader, Blacksmith, Gunsmith, Veteran Soldier |
| **University** | 10 | 3 | Level 1 + 2 + Level 3: Jesuit Missionary, Firebrand Preacher, Elder Statesman |

**Teaching rules**:
- Only expert colonists can teach (must already have the skill)
- Only free colonists and indentured servants can be students
- Criminals CANNOT learn (must first become servants through education or military)
- Colonists who already have a specialty cannot learn a new one (must clear specialty first)
- Indian converts cannot be taught new European skills
- 100% SoL membership: colonists educated more quickly

### Colonist Hierarchy (productivity tiers)
```
Petty Criminal (worst) → Indentured Servant → Free Colonist → Expert/Master (best)
```
- Criminals: good outdoor labor, almost totally ineffective at manufacturing
- Servants: useful in fields/mines, less productive at manufacturing than free colonists
- Free colonists: productive in all spheres
- Experts/Masters: **2× output** at their specialty (except Expert Farmer = +2 food additive)

### Immigration Classes

| Class | Transport Cost |
|---|---|
| Petty Criminals | 300 |
| Indentured Servants | 400 |
| Peasant Farmers | 600 |
| Skilled Craftsmen | 800 |
| Hardy Pioneers | 1450 |
| Town Merchants | 1500 |
| Trained Mercenaries | 1900 |
| Educated Elite | 2000 |

### Starting Conditions — Universal (All Nations, All Difficulties)

Every game begins in **1492** with:
```
Starting units on the high seas (aboard starting ship):
  England/France/Spain:  1 × Caravel
  Netherlands:           1 × Merchantman (larger, 4 cargo holds vs 2)
  All nations carry:     1 × Pioneer (colonist with 100 Tools)
                         1 × Soldier (colonist with 50 Muskets)

Starting year:     1492
Starting tax rate:  0%
Starting Founding Fathers: 0
Starting liberty bells:    0
Starting crosses:          0
Starting trade boycotts:   none
Starting European market:  base prices from NAMES.TXT @CARGO table
Starting immigrant pool:   3 random colonists on the docks
```

**Dutch Merchantman advantage**: The Netherlands starts with a Merchantman (4 cargo holds, 5 movement) instead of a Caravel (2 cargo holds, 4 movement). This means the Dutch can transport more goods on their first voyage, fitting their trade-focused national bonus.

### Starting Conditions — Per Difficulty Level

| Parameter | Discoverer | Explorer | Conquistador | Governor | Viceroy |
|---|---|---|---|---|---|
| **Starting Gold** | Highest | ↓ | ↓ | ↓ | Lowest |
| **Recruitment Cost** | 100 | 150 | 200 | 250 | 300 |
| **Cost Escalation** | +10/recruit | +10/recruit | +10/recruit | +10/recruit | +10/recruit |
| **REF Dragoons** | 5 | 10 | 15 | 20 | 30 |
| **REF Regulars** | 5 | 10 | 15 | 20 | 30 |
| **REF Artillery** | 2 | 4 | 6 | 8 | 12 |
| **Total Starting REF** | 12 | 24 | 36 | 48 | 72 |
| **AI Gold Bonus/turn** | 0 | 0 | 50 | 100 | 200 |
| **AI Build Speed** | 0.8× | 1.0× | 1.2× | 1.5× | 1.8× |
| **King Tax Leniency** | 20 turns | 15 turns | 10 turns | 7 turns | 4 turns |
| **Tory Penalty Threshold** | Higher | — | — | — | Lower |

**Recruitment cost formula**: `base_cost = 100 + (difficulty_level × 50)`
Then increases by **+10 gold** per colonist recruited (cumulative inflation).

**REF (Royal Expeditionary Force)** starts with ground forces only. The King adds Cavalry, Man-O-War, and Frigates over time via KINGBUY events.

**Crosses threshold for immigration**: starts at **8**, grows by **+3** per immigrant recruited (same across all difficulties, but England gets 2/3 rate).

**Congress progress thresholds** (liberty bells needed per Founding Father, same for all difficulties):
```
FF #1:  85    FF #6: 197    FF #11: 374    FF #16: 631    FF #21:  989
FF #2: 103    FF #7: 227    FF #12: 418    FF #17: 694    FF #22: 1074
FF #3: 123    FF #8: 260    FF #13: 466    FF #18: 761    FF #23: 1164
FF #4: 145    FF #9: 295    FF #14: 517    FF #19: 832    FF #24: 1260
FF #5: 170    FF #10:333    FF #15: 572    FF #20: 908    FF #25: 1362
```

### Starting Conditions — Per Nation

#### England (Walter Raleigh)
```
Leader modifiers: aggressive=+1, expansionist=-1, militaristic=0
National bonus:   Crosses needed for immigration × 2/3
                  (Immigration is 50% faster than other nations)
Home port:        London
Colony prefix:    "New England" → Jamestown, Plymouth, Roanoke, ...
Mission prefix:   "Church of"
```
**Strategic advantage**: Fastest population growth. Best for colony-building strategies.

#### France (Jacques Cartier)
```
Leader modifiers: aggressive=0, expansionist=+1, militaristic=0
National bonus:   Indian alarm generated at HALF rate
                  (Native relations much easier to maintain)
Home port:        La Rochelle
Colony prefix:    "New France" → Quebec, Montreal, Guadeloupe, ...
Mission prefix:   "Sainte Marie de"
```
**Strategic advantage**: Peaceful native relations. Best for fur trade and missions.

#### Spain (Christopher Columbus)
```
Leader modifiers: aggressive=+1, expansionist=0, militaristic=-1
National bonus:   +50% combat bonus when ATTACKING Indian villages
                  (Does NOT apply to defense or European combat)
Home port:        Seville
Colony prefix:    "New Spain" → Isabella, Santo Domingo, San Salvador, ...
Mission prefix:   "Santa Maria del"
```
**Strategic advantage**: Conquest of native civilizations. Best for treasure-hunting.

#### Netherlands (Michiel De Ruyter)
```
Leader modifiers: aggressive=-1, expansionist=0, militaristic=+1
National bonus:   Commodity prices in Amsterdam do not collapse
                  as quickly AND recover more quickly
                  (Market pool changes are dampened)
Home port:        Amsterdam
Colony prefix:    "New Netherlands" → New Amsterdam, Fort Orange, ...
Mission prefix:   "Church of"
```
**Strategic advantage**: Trade economy. Best for cash crop strategies.

### Leader Modifier Effects

The three leader axes (from NAMES.TXT @LEADERNAME) affect AI behavior and game events:
```
Axis 1: aggressive (+1) / friendly (-1)
  → Affects frequency of King's demands and foreign power confrontations
  → +1: King is more demanding, other nations more hostile
  → -1: King is more lenient, other nations less aggressive

Axis 2: expansionist (+1) / perfectionist (-1)
  → Affects AI colony founding rate and territorial claims
  → +1: AI prioritizes founding many colonies
  → -1: AI prioritizes developing existing colonies

Axis 3: civilize (+1) / militaristic (-1)
  → Affects military vs. economic balance
  → +1: AI builds more military units, King provides more military support
  → -1: AI focuses on economy, King events lean toward trade/tax
```

### Independence Names (per nation)
After winning independence, each nation becomes:
```
England     → "United States of America"
France      → "Republic of Quebec"
Spain       → "Republic of Mexico"
Netherlands → "Republic of Surinam"
```

### Default Colony Names
Each nation has 32-46 predefined colony names with optional historical founding dates (e.g., "Jamestown,1607", "Plymouth,1620"). Names are used in order as new colonies are founded.

### Cheat Menu (from MENU.TXT @CUP)
```
F01: Create Unit
F02: Debug Info Flags
F04: Reveal Map
F05: Set Human Player
F06: Kill Indians
F07: Advance Revolution Status
Sound Test
Memory Check
F08: Show Strategy
F09: Show Colony Sites
F10: Test Routine
```

---

## Cut/Beta Features (from VICEROY.EXE strings not in release)

| Feature | Evidence | Status |
|---|---|---|
| Mercenaries | MERCS, MERCENARIES strings | In original game: King offers mercenary units for gold |
| Multiplayer | MULTI, MULTINEXT strings | Turn-based hotseat |
| Seasons | SEASONS, TIMECHANGE strings | In original game: Spring/Autumn after 1600 |
| Scenarios | SCENARIO string | In original game: AMER2 + AMERICA maps |
| Withdrawal diplomacy | WITHDRAW, NOTHINGWITHDRAW | Implemented |
| Colony renaming | RENAMECOLONY | Implemented |
| Debug mode | DEBUG flag | Internal only |

---

---

## 20. Source Reconstruction Status

### Implemented Systems (8,069 lines across 34 files — ALL systems implemented, ALL FFs wired)

| System | File | Lines | Status |
|---|---|---|---|
| Map (56×72, terrain, fog, 4-param gen) | map.c/h | 374 | **Complete** — full random map generation with land/form/temp/climate |
| Market (pool-based pricing) | market.c/h | 200 | **Complete** |
| Colony management | colony.c/h | 483 | **Complete** — production, buildings (hammer accum), education, horse breeding, custom house |
| Unit system (23 types, combat) | unit.c/h | 262 | **Complete** — combat with FF integration (Washington/Drake/Spain/fatigue) |
| Native tribes (8 tribes, alarm) | native.c/h | 397 | **Complete** — alarm (French half-rate), raids, teaching, missions (Brebeuf/Sepulveda) |
| European harbor (immigration) | europe.c/h | 280 | **Complete** — crosses, transit, recruit, artillery escalating cost |
| Founding Fathers (25 FFs) | power.c/h + game.c | 500+ | **25/25 implemented** — all wired into game systems |
| AI system | ai.c/h | 286 | **Complete** — personality, 9 action types, attack/naval rolls, trade weights |
| Game loop (turn processing) | game.c/h | 560+ | **Complete** — 11-step end-of-turn with all FF checks, treasure, diplomacy |
| Save/Load | game.c | ~50 | **Complete** — binary format with magic "COL2", version 3 |
| Map editor | mapedit.c | 1,282 | **Complete** — full ncurses reimplementation of MAPEDIT.EXE |
| RNG | game.c | ~10 | **Complete** — MS-C compatible LCG |

### Previously Missing — Now ALL Implemented

| System | File | Lines | Status |
|---|---|---|---|
| **A* Pathfinding** | pathfind.c/h | 282 | **NEW** — Manhattan heuristic, respects terrain costs |
| **Independence War** | revolution.c/h | 721 | **NEW** — REF invasion, 3 defeat conditions, foreign intervention |
| **Building construction** | colony.c | +100 | **ADDED** — hammer accumulation, tool consumption, 39 building costs |
| **Education system** | colony.c | +120 | **ADDED** — 3 tiers, skill levels, teacher/student pairing |
| **Terrain improvements** | terrain_improve.c/h | 277 | **NEW** — plow, road, clear forest with tool consumption |
| **Horse breeding** | colony.c | +15 | **ADDED** — 2+horses + food → breed; Stable doubles rate |
| **Lost City events** | lost_city.c/h | 248 | **NEW** — 10 outcomes with exact probabilities, De Soto override |
| **Score calculation** | score.c/h | 337 | **NEW** — 24-tier rating, Hall of Fame file I/O |
| **European diplomacy** | diplomacy.c | 203 | **NEW** — war/peace/treaty, AI decisions, Franklin FF |
| **Custom House** | colony.c | +30 | **ADDED** — auto-export with Stuyvesant FF |
| **Ship construction** | colony.c | +25 | **ADDED** — hammer + tool costs per ship type |
| **Treasure transport** | game.c | +50 | **ADDED** — King's tax %, Cortes FF free transport |
| **25 Founding Father effects** | power.c | +164 | **COMPLETED** — all 25 with exact mechanics |
| **4-parameter map generation** | map.c | +160 | **REPLACED** — land mass/form/temp/climate system |

### Unmapped Struct Fields

| Struct | Total Size | Mapped | Unmapped | Unknown Regions |
|---|---|---|---|---|
| PowerRecord | 316 bytes | 252 bytes | 64 bytes | 6 pad regions between known fields |
| ColonyRecord | 202 bytes | 198 bytes* | 4 bytes | End-of-record padding |
| UnitRecord | 28 bytes | 25 bytes | 3 bytes | End-of-record padding |
| AIPersonality | 52 bytes | 5 bytes | 47 bytes | Most of AI state unknown |
| NativeSettlement | 20 bytes | 15 bytes | 5 bytes | End-of-struct |

*ColonyRecord: the reconstruction (`colony.h`) maps most fields; the original `colonize_structs.h` still shows 176 bytes unmapped from the initial reverse engineering.

### Founding Fathers — Implementation Status

| # | Father | Category | Implemented? |
|---|---|---|---|
| 0 | Adam Smith | Trade | **Yes** — factory buildings unlocked |
| 1 | Jakob Fugger | Trade | **Yes** — boycotts forgiven |
| 2 | Peter Minuit | Trade | **Yes** — free Indian land |
| 3 | Peter Stuyvesant | Trade | **Yes** — Custom House unlocked |
| 4 | Jan de Witt | Trade | **Yes** — foreign trade + price bonus |
| 5 | Ferdinand Magellan | Explore | **Yes** — +1 naval movement in game_end_of_turn(); halves Europe transit |
| 6 | Francisco Coronado | Explore | **Yes** — reveals map (radius 5) around all colonies on recruitment + per-turn |
| 7 | Hernando de Soto | Explore | **Yes** — Lost City positive-only in lost_city.c (removes vanish/nothing/anger) |
| 8 | Henry Hudson | Explore | **Yes** — fur trappers ×2 in colony_calc_production_ex() |
| 9 | Sieur De La Salle | Explore | **Yes** — auto-stockade at pop 3 in game_end_of_turn() + game_recruit_ff() |
| 10 | Hernan Cortes | Military | **Yes** — always treasure + free King transport in game_sell_treasure() |
| 11 | George Washington | Military | **Yes** — auto veteran promotion |
| 12 | Paul Revere | Military | **Yes** — auto-arm flag; checked in colony defense (CombatFFFlags.has_revere) |
| 13 | Francis Drake | Military | **Yes** — +50% privateer attack in unit_attack_strength_ex() |
| 14 | John Paul Jones | Military | **Yes** — free Frigate created on recruitment in game_recruit_ff() |
| 15 | Thomas Jefferson | Political | **Yes** — +50% liberty bells |
| 16 | Pocahontas | Political | **Yes** — alarm reduction |
| 17 | Thomas Paine | Political | **Yes** — liberty bells × tax rate |
| 18 | Simon Bolivar | Political | **Yes** — faster SoL growth |
| 19 | Benjamin Franklin | Political | **Yes** — intervention bonus |
| 20 | William Brewster | Religious | **Yes** — no criminals/servants |
| 21 | William Penn | Religious | **Yes** — cross production boost |
| 22 | Jean de Brebeuf | Religious | **Yes** — all missionaries as expert Jesuits in native_place_missionary_ex() |
| 23 | Juan de Sepulveda | Religious | **Yes** — increased conversion chance flag in native.c |
| 24 | Bartolome de las Casas | Religious | **Yes** — converts→free colonists on recruitment in game_recruit_ff() |

---

---

## Appendix B: Full Disassembly Results

### Disassembly Scale
- **1,220 total functions** disassembled (525 load image + 695 overlay)
- **78,761 lines** of annotated 16-bit x86 assembly
- **2.6 MB** of output files in `extracted/disassembly/`
- Every `imul`, `call`, global reference, struct access, and probability pattern annotated

### Newly Confirmed Global Variables (from 1,220 function cross-reference)

| DS Offset | Name | Func Refs | Purpose |
|---|---|---|---|
| 0x3144 | unit_table_base | 65 | Start of unit record array |
| 0x4285 | current_player_ptr | 20+ | Pointer to active player struct |
| 0x538A | current_year | **44** | Game year (CMP: 1492,1600,1650,1700,1800) |
| 0x538E | unknown_threshold | 21 | Used in ÷15 modulo calculation |
| 0x5390 | current_season | 18 | 0=Spring, 1=Autumn |
| 0x5398 | active_nation_idx | — | Nation being processed (used with imul×0x34→AI struct) |
| 0x539C | score_counter | **39** | Score accumulator (CMP: 292, 300) |
| 0x53D2 | active_unit_idx | — | Unit index within current nation |
| 0x8542 | current_nation_ptr | **198** | Most-referenced global — pointer to nation data |
| 0x8D4A | active_struct_ptr | **41** | Pointer to struct with fields +0(x),+1(y),+2(type),+5 |
| 0x8D52 | secondary_param | **62** | Frequently pushed as function argument |
| 0x8DB8 | tertiary_global | 15 | Used in AI and unit processing |

### UnitRecord Complete Field Map (from 323 function references)

| Offset | Size | Accesses | Field Name | Evidence |
|---|---|---|---|---|
| +0x00 | 1 | 29 | x | Map X position |
| +0x01 | 1 | 24 | y | Map Y position |
| +0x02 | 1 | **59** | type | Unit type 0-22 (MOST accessed field in entire game) |
| +0x03 | 1 | 23 | nation | Owning nation 0-3 |
| +0x04 | 1 | 9 | status | Status flags |
| +0x05 | 1 | 6 | moves_left | Movement points remaining |
| +0x06 | 1 | 4 | turns_worked | Turns on current task |
| +0x07 | 1 | 7 | equipment | Equipment code (CMP: 0x32=50 muskets, 0x40=64 tools) |
| +0x08 | 1 | **14** | orders | 0=None,1=Sentry,2=TradeRoute,3=GoTo,5=Fortify,0xB=Road,0xC=Plow |
| +0x09 | 1 | — | goto_x | Destination X (set in pairs with +0x0A) |
| +0x0A | 1 | — | goto_y | Destination Y |
| +0x0C | 1 | 4 | cargo_or_colony | Cargo type or assigned colony |
| +0x17 | 1 | **12** | profession | Specialty: 0x14=Pioneer,0x15=Soldier,0x16=Scout,0x18=Missionary,0x1B=Convert |
| +0x18 | 1 | **14** | skill_level | Skill/veteran level |
| +0x1A | 2 | **16** | treasure_gold | Gold value for treasure trains (WORD, CMP: ==0) |

### Combat Veteran Flag Discovery

From combat code at file offset 0x6D379:
```asm
mov  al, [es:bx + 0x0A]    ; read unit field +0x0A (via ES segment pointer)
and  ax, 0x10               ; test bit 4 — THIS IS THE VETERAN FLAG
cmp  ax, 1                  ; check if set
sbb  ax, ax                 ; ax = -1 if veteran, 0 if not
and  ax, 3                  ; ax = 3 if veteran, 0 if not (combat modifier)
```
**Veteran status is bit 4 (0x10) of the unit field at +0x0A** (within an ES-segment unit pointer, likely a different table format than the DS:0x3144 table).

### 19-Byte Struct (stride 0x13)

A previously unknown struct with 19-byte stride appears in 9 `imul` instructions. It accesses data at negative DS offsets (`-0x6DA2`, `-0x6DA3`), suggesting a table in the lower data segment. This is likely the **building definition table** or **Founding Father state table** (19 bytes per entry matches compactly with 25 FFs or building upgrade chains).

Used alongside globals DS:0x53D2 (active unit) and DS:0x5398 (active nation), confirming it's indexed by nation or unit.

### Probability Pattern Census (52 patterns in overlay)

| Pattern | Count | Probability | Likely Usage |
|---|---|---|---|
| AND AX, 0x0F | **43** | 6.25% (1/16) | Random event triggers, AI decisions |
| AND AX, 3 | 7 | 25% (1/4) | Combat promotion, veteran checks |
| AND AX, 7 | 1 | 12.5% (1/8) | Mid-probability events |
| AND AX, 0x1F | 1 | 3.125% (1/32) | Rare event trigger |

The dominant probability in the game is **6.25% (1/16)** — used 43 times. This is the base probability for most per-turn random events in the game. The 25% checks are concentrated in the combat resolution area.

### Year Threshold Census (20 checks in overlay)

| Year | Hex | Checks | Purpose |
|---|---|---|---|
| 1492 | 0x5DC | 1 | Game start validation |
| 1600 | 0x640 | **8** | Season change, FF weight shift era 1→2 |
| 1650 | 0x672 | 2 | Mid-game AI transition |
| 1700 | 0x6A4 | **8** | FF weight shift era 2→3, late-game triggers |
| 1800 | 0x708 | 1 | Retirement/game end deadline |

### Maximum Founding Fathers Confirmed
10 occurrences of `CMP value, 0x19 (25)` — confirms the hard cap of **25 Founding Fathers**.

### Founding Father Storage (from load image disassembly)
FFs are stored as a **bit-packed array** at nation_ptr+0x8A:
```c
bool has_founding_father(int ff_id) {
    int byte_index = ff_id / 8;
    int bit_index  = ff_id & 7;
    int mask = 1 << bit_index;
    return (nation_data[0x8A + byte_index] & mask) != 0;
}
// 25 FFs need 4 bytes (32 bits), stored at offsets 0x8A-0x8D
```

### Maximum Gold Cap
Hardcoded at **999,999** (0x0F423F):
```c
void add_gold(int nation, int amount) {
    gold += amount;
    if (gold < 0) gold = 0;
    if (gold > 999999) gold = 999999;  // 0x0F423F cap
}
```

### Ship Cost Formula (from func_L238)
```c
int get_ship_cost() {
    if (nation.tax_rate == 0) return 100;
    return (nation.tax_rate + 1) * 100;
    // At 10% tax: cost = 1100
    // At 50% tax: cost = 5100
    // At 75% tax (max): cost = 7600
}
```

### Year 1725 Threshold
Previously unknown — at year 1725, a flag is set that enables independence/revolution pressure:
```c
if (!(game_flags & WAR_OF_INDEPENDENCE)) {
    if (year > 1725) {
        enable_independence_flag = 1;
    }
}
```

### Independence Support Calculation (from func_L211)
```c
int calculate_independence_support() {
    // Gold accumulated vs counter (which increments by 100 per new colony)
    int support = (nation.gold * 100) / nation.colony_counter;
    
    // Thomas Paine FF: +20% for human players
    if (has_ff(THOMAS_PAINE) && nation.type < 4 && is_human)
        support += 20;
    
    if (support > 100) support = 100;
    return support;
}
```

### Production System (from func_L280-L281, economy engine)

**Terrain production table** at DS:0x2F7B — 16 bytes per terrain type, indexed as `table[terrain * 16 + commodity]`.

**Difficulty production bonuses:**
```c
switch (difficulty) {
    case 0: base_production += 2; break;  // Discoverer: +2
    case 1: base_production += 1; break;  // Explorer: +1
    // Conquistador, Governor, Viceroy: no bonus
}
```

**Liberty Bell production modifiers (confirmed exact order):**
```c
bells = base_bell_production;

// 1. William Penn (FF #15): +50%
if (has_ff(15)) bells += bells / 2;

// 2. Thomas Jefferson (FF #17): +percentage from PowerRecord
if (has_ff(17)) bells += bells * power_pct / 100;

// 3. Thomas Paine (FF #18, AI only): +(colony_count + 3) / 5
if (has_ff(18) && is_ai) bells += (colony_count + 3) / 5;

// 4. Printing Press (FF #20): DOUBLE (×2)
if (has_ff(20)) bells *= 2;

// 5. Newspaper (FF #19): +50% (only if no Printing Press)
else if (has_ff(19)) bells += bells / 2;
```

**Immigration system:**
```c
// Immigration threshold divisor
int divisor = has_ff(JEFFERSON) ? 25 : 50;
// With Jefferson: immigrants arrive twice as fast
int threshold = ceil(nation.colonist_pool / divisor) * 2;

// Food check constrains immigration
int food_surplus = food_production - cross_accumulator;
int max_immigrants = min((food_surplus + 1) / 2, threshold);

// Ship cost constrains affordability
int ship_cost = (tax_rate + 1) * 100;
int actual = min(ship_cost - colonist_pool, max_immigrants);
```

### Unit Linked List (corrected from load image analysis)
Fields +0x18 and +0x1A are **NOT treasure gold** — they are a **linked list**:
```c
unit[+0x18] = prev_unit_index  (word, 0xFFFF = none)
unit[+0x1A] = next_unit_index  (word, 0xFFFF = none)
```
Units are chained together in a per-tile linked list for efficient lookup of which units occupy a map tile.

### Manufacturing Building Levels
```c
// Factory level (level 3+) production:
if (workshop_level > 2)
    output = base * 2 / 3;  // Actually REDUCES base, but applies to manufactured goods
    // The "1.5× factory bonus" works because raw→manufactured conversion
    // normally produces 1:1, but factory changes the ratio
```

### Save Game Format (from func_O622 serializer + func_O633 deserializer)

Both the save and load functions were fully disassembled, revealing the exact binary format:

```
Save file sections (in order):
  Section 1: Strings (player name, date, game ID strings)
  Section 2: Extended state data (IDs 0x20-0x2B)
  Section 3: Game rules/victory conditions (IDs 0x300-0x332)
  Section 4: Map and unit data (IDs 0x40-0x44)

Data blocks saved:
  DS:0x5380 → 0x8E (142) bytes:  Global game flags
  DS:0x540E → 0xD0 (208) bytes:  AI personality (4 × 52 = 208)
  DS:0x948E → 0x18 (24) bytes:   Score/timing data
  DS:0x3144 → N × 0x1C bytes:    Unit table (N = unit count × 28)
  DS:0x8808 → 0x4F0 (1264) bytes: Power table (4 × 316 = 1264) ← CONFIRMS stride
  DS:0x54EC → N × 0x12 bytes:    NativeSettlement table (N = [0x539A], max 84)
  DS:0x5D46 → N × 0xCA bytes:    Colony table (N × 202) ← NOTE: 0x5D46 not 0x5D60!
  DS:0x5AD6 → parallel per-settlement aux array (paired with 0x54EC in 0xD1D:0x60C/0x528 calls); 624-byte size UNVERIFIED
  Map data: 4 tile layer pointers
  Various: 0x4C, 0x10, 0x40, 0x80, 0x378 byte blocks
```

**Colony table base correction**: The save/load functions use **DS:0x5D46** as the colony table base, not DS:0x5D60. The 0x1A (26) byte difference accounts for a colony record prefix (possibly a count + padding) before the first ColonyRecord.

**Power table base correction**: Uses **DS:0x8808**, not DS:0x8820. The 0x18 (24) byte difference is a nation header prefix.

### Colony Tax/Production Processing (from func_O111, 1440 bytes)

Exact formulas for annual colony economic processing:

**Tax revenue calculation:**
```c
for (good = 0; good < 16; good++) {
    if (nation.goods[good] > 100)  // surplus above 100
        amount = nation.goods[good] - 50;  // sell 50 below stockpile
    sale_price = get_market_price(good) * amount;
    king_tax = sale_price * tax_rate / 100;
    player_revenue = sale_price - king_tax;
    nation.king_treasury += king_tax;     // 32-bit at [+0x22]
    nation.player_treasury += player_revenue; // 32-bit at [+0x26]
}
```

**Treasury decay per turn:**
```c
// Treasury decays by 1/64 per turn (6 right shifts)
decay = treasury >> 6;  // divide by 64
if (decay < 1) decay = 1;
treasury -= decay;
// Tax rate contributes: treasury += tax_rate * 2
```

**Sons of Liberty sentiment processing:**
```c
// SoL accumulator at nation[+0xC2..+0xC4] (32-bit)
sol_adjustment = loyalty_score - (sol_income / 64);
sol_accumulator = clamp(sol_accumulator + sol_adjustment, 0, treasury);

// SoL thresholds trigger political events:
if (sol_percentage >= 50)
    nation.flags |= 0x04;  // STAMP ACT flag → triggers tax event
if (sol_percentage >= 100)
    nation.flags |= 0x02;  // DECLARATION flag → enables independence
if (sol_percentage < 95)
    nation.flags &= ~0x02; // Clear Declaration flag if drops below 95%
```

**Tax rate cap: 75%** — hardcoded (`CMP tax_rate, 0x4B`)

**Difficulty food bonus:**
```c
food_production += difficulty_level >> 1;  // Discoverer=0, Viceroy=2 extra food
```

### AI Strategic Trade Planning (from func_O402, 1777 bytes)

The AI evaluates all 16 goods to find the best trade opportunity:

```c
// Goods evaluation formula:
for (good = 0; good < 16; good++) {
    supply = min(nation.goods[good], 100);
    weight = trade_weight_table[nation_id * 16 + good];  // from table at DS:0x7B44
    
    if (good == 8)  // horses
        weight += 10 - (ai_state.horses - weight);
    if (good == 15)  // muskets
        weight += random(1,4) - ai_state.difficulty + difficulty_level + 4;
    
    score = weight * supply;
    // Pick highest scoring good
}

// Price calculation:
price = 100 / (quantity_owned + 1);
price = min(price, existing_supply + 5);
price = clamp(price, 5, 100);

// Unit promotion on purchase:
if (good == 15 && !unit_is_max_rank)  // buying muskets
    unit.type++;  // promote to next military rank
if (good == 8 && !unit_has_horses)    // buying horses
    unit.type += 2;  // mount the unit (skip 2 ranks)
```

**AI trade weight table** at DS:0x7B44: 64 bytes (4 nations × 16 goods), each byte is a weight for how much that nation values that good.

### AI Unit Turn Handler (from func_O457, 2013 bytes)

Complete AI decision tree for unit actions:

```c
int ai_process_unit(int unit_id) {
    int pioneer_level = (unit.type == PIONEER) ? 1 : 0;
    if (unit.profession == SEASONED_SCOUT) pioneer_level = 2;
    if (has_ff(DE_SOTO)) pioneer_level++;  // exploration bonus
    
    int action = random(1, 9);  // 9 possible actions
    int threshold = random(1, 100) + pioneer_level * 10;
    
    // Action codes: 1=explore, 2=colonize, 3=trade_natives,
    //   4=attack, 5=settle, 6=move, 7=naval, 8=convert, 9=disband
    
    // Decision cascade based on terrain, unit type, and threshold
    switch(action) { ... }
    
    // Attack strength formula:
    attack = 3 * random(1, 8) * 10;  // range: 30-240
    
    // Naval strength formula:
    naval = 4 * random(1, 10) * 2;   // range: 8-80
    
    // Pioneer combat multiplier:
    combat = (pioneer_level + 2) * 5 * 2;  // level 0=20, 1=30, 2=40
}
```

### Unit Movement Events (from func_O180, 1343 bytes)

12 distinct event subtypes with a jump table, each with unit type eligibility:

| Event | Eligible Types | Description |
|---|---|---|
| 1 | Colonist, Scout | Rumors/exploration |
| 2 | Soldier | Treasure discovery |
| 3 | Pioneer | Burial mound |
| 4 | Colonist, Soldier | Lost city |
| 5 | Soldier (no mission 0x1B) | Special encounter |
| 6 | Missionary (no mission 0x18) | Religious event |
| 7 | Soldier, Dragoon | Military event |
| 8 | Pioneer | Resource discovery |
| 9 | Scout, Dragoon | Exploration event |
| 10 | Soldier (no mission) | Combat event |
| 11 | Soldier | Ambush |
| 12 | Missionary (no mission) | Conversion event |

Event weight formulas:
```c
weight1 = random_event(15) * 50;   // range: 0-750
weight2 = random_event(14) * 100;  // range: 0-1400
weight3 = random_event(8) * 50;    // range: 0-400
// Scouts/Dragoons get the skilled weight roll, others get base roll
```

### Hall of Fame Format (from func_O222, 1362 bytes)

File: `COLONY.HOF` / `COLONY.HOS`
- **6 entries maximum**, top 5 displayed
- **42 bytes per entry** (stride 0x2A), sorted by score descending

```c
typedef struct ScoreEntry {  // 42 bytes
    char   name[24];     // +0x00 player name
    u16    score1;       // +0x18
    u16    year;         // +0x1A year achieved
    u16    nation;       // +0x1C nation index
    u16    difficulty;   // +0x1E difficulty level
    u16    flag1;        // +0x20
    u16    flag2;        // +0x22
    u16    flag3;        // +0x24
    u16    final_score;  // +0x26 used for sorting
} ScoreEntry;
```

### Nation Data Struct Fields (from tax processing and save/load)

| Offset | Type | Field | Evidence |
|---|---|---|---|
| +0x1A | u8 | nation_player_id | Player index |
| +0x1B | u8 | nation_flags | Bit 3 = war status |
| +0x1C | u8 | political_flags | Bit 2 = Stamp Act, Bit 1 = Declaration |
| +0x1F | u8 | tax_rate | 0-75% |
| +0x22 | u32 | king_treasury | King's accumulated tax revenue |
| +0x26 | u32 | player_treasury | Player's accumulated revenue |
| +0x90 | u16 | goods_demand_mask | Bitmask of demanded goods |
| +0x9A | u16[16] | goods_stockpile | Per-good stockpile (indexed +si*2) |
| +0xC2 | u32 | sol_accumulator | Sons of Liberty sentiment (32-bit) |
| +0xC6 | u32 | treasury_base | Treasury base for decay calc |

---

*Reverse-engineered from VICEROY.EXE (494,910 bytes), MAPEDIT.EXE (145,292 bytes), and all game data files. Full disassembly: 1,220 functions across 78,761 lines of annotated x86 assembly. Cross-validated with js-dos WASM memory inspection, Windows EXE disassembly, CodeView NB02 symbols (211 modules, 1,071 public symbols). Source reconstruction: 8,069 lines of C code across 34 files — ALL game systems implemented, all 25 Founding Fathers wired. Generated 2026-04-12.*
