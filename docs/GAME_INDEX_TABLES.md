# Game index tables — master mapping reference

Cross-references between PEDIA.TXT indices, sprite assets,
NAMES.TXT data tables, and renderer-needed lookups.

Generated 2026-05-05 from PEDIA.TXT title extraction.

---

## 16 Cargo / Commodity types

PEDIA `@CARGO0..15` ↔ NAMES.TXT `@CARGO` ↔ PowerRecord market
arrays index ↔ ICONS sprite range.

NAMES.TXT @CARGO has 9 numeric parameters per cargo (per the
comment block at NAMES.TXT line 258):

```
Name, Start1, Start2, Low, High, Burden, Rise, Fall, Attrition, Volatility
```

- **Start1, Start2** = starting buy/sell price (low/high)
- **Low, High** = lowest/highest possible price drift bounds
- **Burden** = extra spread between ask and bid (0 = ask is 1 higher)
- **Rise** = traffic-volume threshold that triggers price rise
- **Fall** = traffic-volume threshold that triggers price fall
- **Attrition** = amount added to traffic volume each turn (recovery rate)
- **Volatility** = shift value for traffic volume

| Idx | Name | Start1 | Start2 | Low | High | Burden | Rise | Fall | Attrition | Volatility | Boycott bit | PowerRecord +0x4C+i |
|----:|------|-------:|-------:|----:|-----:|-------:|-----:|-----:|----------:|-----------:|------------:|---------------------|
| 0 | Food | 1 | 3 | 1 | 6 | 7 | 3 | 2 | -1 | 0 | 0x0001 | byte +0x4C |
| 1 | Sugar | 4 | 7 | 3 | 7 | 1 | 4 | 6 | -8 | 1 | 0x0002 | byte +0x4D |
| 2 | Tobacco | 3 | 5 | 2 | 5 | 1 | 4 | 8 | -10 | 1 | 0x0004 | byte +0x4E |
| 3 | Cotton | 2 | 5 | 2 | 5 | 1 | 4 | 6 | -11 | 1 | 0x0008 | byte +0x4F |
| 4 | Furs | 4 | 6 | 2 | 6 | 1 | 4 | 20 | -13 | 1 | 0x0010 | byte +0x50 |
| 5 | Lumber | 2 | 2 | 2 | 2 | 4 | 3 | 2 | 0 | 0 | 0x0020 | byte +0x51 |
| 6 | Ore | 3 | 6 | 2 | 6 | 2 | 2 | 4 | -7 | 0 | 0x0040 | byte +0x52 |
| 7 | Silver | 20 | 20 | 2 | 20 | 0 | 8 | 1 | -8 | 2 | 0x0080 | byte +0x53 |
| 8 | Horses | 2 | 3 | 2 | 11 | 0 | 3 | 2 | -3 | 0 | 0x0100 | byte +0x54 |
| 9 | Rum | 11 | 13 | 1 | 20 | 0 | 4 | 4 | -12 | 1 | 0x0200 | byte +0x55 |
| 10 | Cigars | 11 | 13 | 1 | 20 | 0 | 4 | 4 | -11 | 1 | 0x0400 | byte +0x56 |
| 11 | Cloth | 11 | 13 | 1 | 20 | 0 | 4 | 4 | -13 | 1 | 0x0800 | byte +0x57 |
| 12 | Coats | 11 | 13 | 1 | 20 | 0 | 4 | 4 | -11 | 1 | 0x1000 | byte +0x58 |
| 13 | Trade Goods | 2 | 3 | 2 | 12 | 0 | 2 | 3 | 4 | 0 | 0x2000 | byte +0x59 |
| 14 | Tools | 2 | 2 | 2 | 9 | 0 | 2 | 2 | 5 | 0 | 0x4000 | byte +0x5A |
| 15 | Muskets | 3 | 3 | 2 | 20 | 0 | 2 | 2 | 6 | 0 | 0x8000 | byte +0x5B |

**Boycott bitfield** at PowerRecord +0x20 (u16): bit `i` set =
commodity `i` boycotted by King. Verified for Food in
session_1777952458 (bit 0 = 0x0001, all other bits clear).

**Saturation marker** at PowerRecord +0x4C+i = `0xC8` = market
saturated, UI displays price 0 (NOT a boycott — different state).

NAMES.TXT also lists 4 NON-tradeable virtual goods after Muskets:
`Hammers`, `Crosses`, `Liberty Bells`, `Flags` — these are produced
but never sold to Europe. Hammers is colony-internal building progress;
Crosses drives immigration; Liberty Bells drives Sons of Liberty
sentiment; Flags is the post-revolution citizen counter.

## 24 Unit types — full NAMES.TXT @UNIT table

PEDIA `@UNIT0..23` ↔ NAMES.TXT @UNIT (line-aligned) ↔ ICONS sprite
index (column 1) ↔ UnitRecord byte +0x00.

NAMES.TXT @UNIT columns (per file comment):
```
Name, Icon, Movement, Attack, Combat, Cargo, Size, Cost, Tools, Guns, Hull, Role(binary)
```

- **Icon** = ICONS.SS sprite index (DIRECT mapping for on-map render)
- **Cost / Tools / Guns / Hull** = build materials (ships only for last 3)
- **Role** = AI 8-bit role mask: Invade/Settle/Explore/Attack/Defend/Escort/Transport/Naval

Full table (verified 2026-05-05 from NAMES.TXT lines 300-323):

| Idx | Name | ICON# | Mvmt | Atk | Def | Cargo | Size | Cost | Tools | Guns | Hull | Role |
|----:|------|------:|-----:|----:|----:|------:|-----:|-----:|------:|-----:|-----:|------|
| 0 | Colonists | 101 | 1 | 0 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 01000000 |
| 1 | Soldiers | 103 | 1 | 2 | 2 | 0 | 1 | 2 | 0 | 0 | 0 | 00011100 |
| 2 | Pioneers | 102 | 1 | 0 | 1 | 0 | 1 | 2 | 0 | 0 | 0 | 01000000 |
| 3 | Missionaries | 106 | 2 | 0 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 00100000 |
| 4 | Dragoons | 105 | 4 | 3 | 3 | 0 | 1 | 3 | 0 | 0 | 0 | 00111100 |
| 5 | Scouts | 104 | 4 | 1 | 1 | 0 | 1 | 2 | 0 | 0 | 0 | 01100100 |
| 6 | Regulars | 126 | 1 | 5 | 5 | 0 | 1 | 3 | 0 | 0 | 0 | 00011100 |
| 7 | Cont. Cav. | 130 | 4 | 5 | 5 | 0 | 1 | 3 | 0 | 0 | 0 | 00011100 |
| 8 | Cavalry | 127 | 4 | 6 | 6 | 0 | 1 | 4 | 0 | 0 | 0 | 00011100 |
| 9 | Cont. Army | 129 | 1 | 4 | 4 | 0 | 1 | 3 | 0 | 0 | 0 | 00011100 |
| 10 | Treasure | 17 | 1 | 0 | 0 | 0 | 6 | 4 | 0 | 0 | 0 | 00000000 |
| 11 | Artillery | 10 | 1 | 7 | 5 | 0 | 1 | 6 | 4 | 0 | 0 | 00011000 |
| 12 | Wagon Train | 9 | 2 | 0 | 1 | 2 | 99 | 1 | 0 | 0 | 0 | 00000000 |
| 13 | Caravel | 6 | 4 | 0 | 2 | 2 | 99 | 4 | 4 | 0 | 4 | 10100010 |
| 14 | Merchantman | 7 | 5 | 0 | 6 | 4 | 99 | 6 | 8 | 1 | 8 | 10000010 |
| 15 | Galleon | 8 | 6 | 0 | 10 | 6 | 99 | 10 | 10 | 4 | 20 | 10000010 |
| 16 | Privateer | 15 | 8 | 8 | 8 | 2 | 99 | 8 | 12 | 4 | 12 | 00000001 |
| 17 | Frigate | 16 | 6 | 16 | 16 | 4 | 99 | 16 | 20 | 12 | 32 | 10000001 |
| 18 | Man-O-War | 128 | 5 | 24 | 24 | 6 | 99 | 32 | 90 | 32 | 64 | 10000001 |
| 19 | Braves | 110 | 1 | 1 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 00111000 |
| 20 | Armed Braves | 111 | 1 | 2 | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 00111000 |
| 21 | Mtd. Braves | 112 | 4 | 2 | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 00111000 |
| 22 | Mtd. Warriors | 113 | 4 | 3 | 3 | 0 | 0 | 3 | 0 | 0 | 0 | 00111000 |

ICONS sprite-index reverse lookup (for on-map rendering):

| ICONS.SS.# | Unit |
|-----------:|------|
| 6 | Caravel |
| 7 | Merchantman |
| 8 | Galleon |
| 9 | Wagon Train |
| 10 | Artillery |
| 15 | Privateer |
| 16 | Frigate |
| 17 | Treasure |
| 101 | Colonists |
| 102 | Pioneers |
| 103 | Soldiers |
| 104 | Scouts |
| 105 | Dragoons |
| 106 | Missionaries |
| 110 | Braves |
| 111 | Armed Braves |
| 112 | Mtd. Braves |
| 113 | Mtd. Warriors |
| 126 | Regulars |
| 127 | Cavalry |
| 128 | Man-O-War |
| 129 | Cont. Army |
| 130 | Cont. Cav. |

This is the **exact ICONS index → unit type mapping** for the
renderer. Resolves task SPRITE-A from PROJECT_BOARD.md.

UnitRecord byte +0x00 in session memory uses values 0x00..0x17
which match the @UNIT line indices 0..23 directly:
- 0x00 = idx 0 (Colonists)
- 0x02 = idx 2 (Pioneers)
- 0x04 = idx 4 (Dragoons)
- 0x0A = idx 10 (Treasure)
- 0x0B = idx 11 (Artillery)
- 0x0E = idx 14 (Merchantman)
- 0x12 = idx 18 (Man-O-War)
- 0x13 = idx 19 (Braves)
- 0x14 = idx 20 (Armed Braves)
- 0x17 = idx 23 (would be unused, last is 22 Mtd. Warriors)

So **UnitRecord byte +0x00 = NAMES.TXT @UNIT line index** directly.

## 42 Buildings (with upgrade chains)

PEDIA `@BUILDING0..41`. Upgrade chains marked with arrows:

### Defense
- 0 = STOCKADE → 1 = FORT → 2 = FORTRESS
- 3 = ARMORY → 4 = MAGAZINE → 5 = ARSENAL

### Naval
- 6 = DOCKS → 7 = DRYDOCKS → 8 = SHIPYARD

### Government
- 9 = TOWN HALL → 10 = TOWN HALL (variant) → 11 = COLONIAL ASSEMBLY
- 30 = CAPITOL → 31 = CAPITOL EXPANSION

### Education
- 12 = SCHOOLHOUSE → 13 = COLLEGE → 14 = UNIVERSITY

### Storage
- 15 = WAREHOUSE → 16 = WAREHOUSE EXPANSIONS

### Transport / Trade
- 17 = STABLES (single, no upgrade)
- 18 = CUSTOM HOUSE
- 19 = PRINTING PRESS → 20 = NEWSPAPER

### Manufacturing chains (raw → processed → factory)

| Raw | Tier 1 | Tier 2 | Tier 3 |
|-----|--------|--------|--------|
| Cotton → Cloth | 21 WEAVER'S HOUSE | 22 WEAVER'S SHOP | 23 TEXTILE MILL |
| Tobacco → Cigars | 24 TOBACCONIST'S HOUSE | 25 TOBACCONIST'S SHOP | 26 CIGAR FACTORY |
| Sugar → Rum | 27 RUM DISTILLER'S HOUSE | 28 RUM DISTILLERY | 29 RUM FACTORY |
| Furs → Coats | 32 FUR TRADER'S HOUSE | 33 FUR TRADER'S SHOP | 34 COAT FACTORY |
| Lumber → Hammers | 35 CARPENTER'S SHOP | 36 LUMBER MILL | (no factory) |
| Ore → Tools | 39 BLACKSMITH'S HOUSE | 40 BLACKSMITH'S SHOP | 41 IRON WORKS |

### Religion
- 37 = CHURCH → 38 = CATHEDRAL

### Build menu costs verified vs NAMES.TXT @BUILDING

NAMES.TXT @BUILDING table (lines 167-208) has 42 entries, each
with 5 numeric columns:

```
Name, Hammers, Tools/10, Category, MinPop, PreReqTier
```

**Tools column is in units of 10** (frame 1310206750 verified:
"20 Tools" shown in Build menu = NAMES.TXT col 2 value of 2).

The 15 first-tier options visible in Plymouth's Build menu match
@BUILDING indices exactly:

| Build menu | PEDIA / @BUILDING idx | Hammers | Tools | Verified? |
|-----------|----------------------:|--------:|------:|:--------:|
| Stockade | 0 | 64 | 0 | ✓ |
| Armory | 3 | 52 | 0 | ✓ |
| Docks | 6 | 52 | 0 | ✓ |
| Schoolhouse | 12 | 64 | 0 | ✓ |
| Warehouse | 15 | 80 | 0 | ✓ |
| Stable | 17 | 64 | 0 | ✓ |
| Printing Press | 19 | 52 | 20 | ✓ (file says 2, ×10) |
| Weaver's Shop | 22 | 64 | 20 | ✓ |
| Tobacconist's Shop | 25 | 64 | 20 | ✓ |
| Rum Distillery | 28 | 64 | 20 | ✓ |
| Fur Trading Post | 33 | 56 | 20 | ✓ |
| Lumber Mill | 36 | 52 | 0 | ✓ |
| Church | 37 | 64 | 0 | ✓ |
| Blacksmith's Shop | 40 | 64 | 20 | ✓ |
| Wagon Train | (UNIT, not building) | 40 | 0 | — |

**Wagon Train** is built like a building but produces a unit
instead of adding a structure. Cost = 40 hammers (no tools).
Likely defined in NAMES.TXT @UNIT or a separate unit-cost table.

### Full @BUILDING table (42 entries)

| idx | Name | Hammers | Tools×10 | Cat | MinPop | PreReq |
|----:|------|--------:|---------:|----:|------:|------:|
| 0 | Stockade | 64 | 0 | 3 | 3 | 0 |
| 1 | Fort | 120 | 10 | 3 | 3 | 10 |
| 2 | Fortress | 320 | 20 | 3 | 8 | 15 |
| 3 | Armory | 52 | 0 | 1 | 1 | 5 |
| 4 | Magazine | 120 | 5 | 1 | 8 | 10 |
| 5 | Arsenal | 240 | 10 | 1 | 8 | 15 |
| 6 | Docks | 52 | 0 | 4 | 1 | 5 |
| 7 | Drydock | 80 | 5 | 4 | 4 | 10 |
| 8 | Shipyard | 240 | 10 | 4 | 8 | 15 |
| 9 | Town Hall | 64 | 0 | 2 | 1 | 0 |
| 10 | Town Hall | 64 | 5 | 2 | 4 | 10 |
| 11 | Town Hall | 120 | 10 | 2 | 8 | 15 |
| 12 | Schoolhouse | 64 | 0 | 1 | 4 | 5 |
| 13 | College | 160 | 5 | 1 | 8 | 10 |
| 14 | University | 200 | 10 | 1 | 10 | 15 |
| 15 | Warehouse | 80 | 0 | 1 | 1 | 5 |
| 16 | Warehouse Expansion | 80 | 2 | 1 | 1 | 5 |
| 17 | Stable | 64 | 0 | 0 | 1 | 5 |
| 18 | Custom House | 160 | 5 | 0 | 1 | 15 |
| 19 | Printing Press | 52 | 2 | 0 | 1 | 5 |
| 20 | Newspaper | 120 | 5 | 0 | 4 | 10 |
| 21 | Weaver's House | 64 | 0 | 0 | 1 | 0 |
| 22 | Weaver's Shop | 64 | 2 | 0 | 1 | 5 |
| 23 | Textile Mill | 160 | 10 | 0 | 8 | 15 |
| 24 | Tobacconist's House | 64 | 0 | 0 | 1 | 0 |
| 25 | Tobacconist's Shop | 64 | 2 | 0 | 1 | 5 |
| 26 | Cigar Factory | 160 | 10 | 0 | 8 | 15 |
| 27 | Rum Distiller's House | 64 | 0 | 0 | 1 | 0 |
| 28 | Rum Distillery | 64 | 2 | 0 | 1 | 5 |
| 29 | Rum Factory | 160 | 10 | 0 | 8 | 15 |
| 30 | Capitol | 400 | 10 | 2 | 16 | 20 |
| 31 | Capitol Expansion | 400 | 10 | 2 | 16 | 10 |
| 32 | Fur Trader's House | 56 | 0 | 0 | 1 | 0 |
| 33 | Fur Trading Post | 56 | 2 | 0 | 1 | 5 |
| 34 | Fur Factory | 160 | 10 | 0 | 6 | 15 |
| 35 | Carpenter's Shop | 39 | 0 | 1 | 1 | 0 |
| 36 | Lumber Mill | 52 | 0 | 1 | 3 | 10 |
| 37 | Church | 64 | 0 | 2 | 3 | 5 |
| 38 | Cathedral | 176 | 10 | 2 | 8 | 15 |
| 39 | Blacksmith's House | 64 | 0 | 0 | 1 | 0 |
| 40 | Blacksmith's Shop | 64 | 2 | 0 | 1 | 5 |
| 41 | Iron Works | 240 | 10 | 0 | 8 | 15 |

**Category column (col 4)**:
- 0 = Manufacturing
- 1 = Storage / Education / Defense (mixed?)
- 2 = Government / Religion
- 3 = Defense (Stockade chain)
- 4 = Naval

**MinPop column (col 5)**: minimum colony population to construct
the building.

**PreReqTier column (col 6)**: tier-unlock requirement (0 = always
available, 5 = unlock at "Wave 1", 10 = "Wave 2", 15 = "Wave 3",
20 = "Wave 4" — likely tied to Founding Father acquisition?).

## 29 Terrain types — full NAMES.TXT terrain tables

NAMES.TXT splits terrain into 3 sections (`@UNFORESTED`, `@FORESTED`,
`@OTHER`) with 13 numeric columns per terrain (per file comment):

```
Name, Movement, Defensive, Improvement, Value,
       YieldFarmer, YieldSugarPlanter, YieldTobaccoPlanter,
       YieldCottonPlanter, YieldTrapper, YieldLumberjack,
       YieldOreMiner, YieldSilverMiner, YieldFisherman
```

### @UNFORESTED (8 terrains, indices 0..7)

| Idx | Name | Mvt | Def | Imp | Val | F | Sg | Tb | Ct | Tr | Lm | Or | Si | Fs |
|----:|------|----:|----:|----:|----:|--:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | Tundra | 1 | 0 | 4 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 |
| 1 | Desert | 1 | 0 | 3 | 2 | 1 | 0 | 0 | 1 | 0 | 0 | 2 | 0 | 0 |
| 2 | Plains | 1 | 0 | 3 | 4 | 4 | 0 | 0 | 2 | 0 | 0 | 1 | 0 | 0 |
| 3 | Prairie | 1 | 0 | 3 | 4 | 2 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 |
| 4 | Grassland | 1 | 0 | 3 | 4 | 2 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 |
| 5 | Savannah | 1 | 0 | 3 | 4 | 3 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 6 | Marsh | 2 | 1 | 5 | 2 | 2 | 0 | 2 | 0 | 0 | 0 | 2 | 0 | 0 |
| 7 | Swamp | 2 | 1 | 7 | 2 | 2 | 2 | 0 | 0 | 0 | 0 | 2 | 0 | 0 |

### @FORESTED (8 terrains, indices 8..15)

| Idx | Name | Mvt | Def | Imp | Val | F | Sg | Tb | Ct | Tr | Lm | Or | Si | Fs |
|----:|------|----:|----:|----:|----:|--:|---:|---:|---:|---:|---:|---:|---:|---:|
| 8 | Boreal | 2 | 2 | 4 | 3 | 1 | 0 | 0 | 0 | 3 | 2 | 1 | 0 | 0 |
| 9 | Scrub | 1 | 2 | 4 | 1 | 1 | 0 | 0 | 1 | 2 | 1 | 1 | 0 | 0 |
| 10 | Mixed | 2 | 2 | 4 | 3 | 2 | 0 | 0 | 1 | 3 | 3 | 0 | 0 | 0 |
| 11 | Broadleaf | 2 | 2 | 4 | 3 | 1 | 0 | 0 | 1 | 2 | 2 | 0 | 0 | 0 |
| 12 | Conifer | 2 | 2 | 4 | 3 | 1 | 0 | 1 | 0 | 2 | 3 | 0 | 0 | 0 |
| 13 | Tropical | 2 | 2 | 6 | 3 | 2 | 1 | 0 | 0 | 2 | 2 | 0 | 0 | 0 |
| 14 | Wetland | 3 | 2 | 6 | 1 | 1 | 0 | 1 | 0 | 2 | 2 | 1 | 0 | 0 |
| 15 | Rain | 3 | 3 | 7 | 1 | 1 | 1 | 0 | 0 | 1 | 2 | 1 | 0 | 0 |

### Indices 16..23

These are the SAME 8 forested types (Boreal/Scrub/Mixed/Broadleaf/
Conifer/Tropical/Wetland/Rain) but stored a SECOND time. Most
likely indicates "forested-with-road" or another state variant.

### @OTHER (5 terrains, indices 24..28)

| Idx | Name | Mvt | Def | Imp | Val | F | Sg | Tb | Ct | Tr | Lm | Or | Si | Fs |
|----:|------|----:|----:|----:|----:|--:|---:|---:|---:|---:|---:|---:|---:|---:|
| 24 | Arctic | 2 | 0 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 25 | Ocean | 1 | 0 | 2 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 |
| 26 | Sea Lane | 1 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 |
| 27 | Mountains | 3 | 6 | 7 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 1 | 0 |
| 28 | Hills | 2 | 4 | 4 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 |

Notes:
- **Movement cost** in points (1 = 1 move; mountains=3 most costly).
- **Defensive bonus** % added when defending in this terrain.
- **Improvement** = how many turns to plow/build road on this terrain.
- **Value** = base monetary value (used for trade calculations).
- **Yield columns** = each colonist's production per turn on this terrain
  (only specific (terrain, skill) pairs yield non-zero):
  - Plains → 4 food (best non-prairie food)
  - Mountains → 4 ore + 1 silver (mining)
  - Sea Lane / Ocean → 3 fish
  - Tropical → 1 sugar + 2 food + 2 trapper + 2 lumber

This is the **base yield matrix**. Modifiers like Resource bonuses
(Wheat, Prime Cotton, Beaver, etc.) and building bonuses
(Lumber Mill, Tobacconist's Shop) multiply on top.

### Resource overlays (NAMES.TXT @RESOURCE)

| Idx | Resource | Bonus value |
|----:|----------|------------:|
| 0 | Depleted Mine | 6 |
| 1 | Oasis | 3 |
| 2 | Wheat | 4 |
| 3 | Prime Cotton | 6 |
| 4 | Prime Tobacco | 6 |
| 5 | Prime Sugar | 7 |
| 6 | Minerals | 4 |
| 7 | Fishery | 5 |
| 8 | Beaver | 6 |
| 9 | Game | 6 |
| 10 | Prime Timber | 6 |
| 11 | Prime Timber (alt) | 6 |
| 12 | Silver Deposit | 12 |
| 13 | Ore Deposit | 6 |

**Forest indices 8-23 with auto-forest range 8-23** is the
auto-forest BYTE_VERIFIED rule from CLAUDE.md (file 0x6204 +
0x6831B). Confirmed: forests live at indices 8..23 in this
ordering.

## 28 Colonist Jobs (skills) — full NAMES.TXT @JOB table

NAMES.TXT @JOB (28 entries, indices 0..27) maps directly to the
PEDIA @JOB description and to ColonyRecord +0x40 colonist job-skill
bytes.

NAMES.TXT @JOB columns:
```
BaseName, MasterName, Tier, EuropeCost
```

- **Tier 1** = common laborers (1-skill)
- **Tier 2** = processed-good specialists (2-skill)
- **Tier 3** = advanced specialists
- **Tier 4** = lowest tier (criminals/converts/teachers)

| Idx | Base name | Master name | Tier | Europe cost |
|----:|-----------|-------------|-----:|------------:|
| 0 | Farmer | Expert Farmers | 1 | 1100 |
| 1 | Sugar Planter | Master Sugar Planters | 2 | -1 (not for sale) |
| 2 | Tobacco Planter | Master Tobacco Planters | 2 | -1 |
| 3 | Cotton Planter | Master Cotton Planters | 2 | -1 |
| 4 | Fur Trapper | Expert Fur Trappers | 1 | -1 |
| 5 | Lumberjack | Expert Lumberjacks | 1 | 700 |
| 6 | Ore Miner | Expert Ore Miners | 1 | 600 |
| 7 | Silver Miner | Expert Silver Miners | 1 | 900 |
| 8 | Fisherman | Expert Fishermen | 1 | 1000 |
| 9 | Distiller | Master Distiller | 2 | 1100 |
| 10 | Tobacconist | Master Tobacconists | 2 | 1200 |
| 11 | Weaver | Master Weavers | 2 | 1300 |
| 12 | Fur Trader | Master Fur Traders | 2 | 950 |
| 13 | Carpenter | Master Carpenters | 1 | 1000 |
| 14 | Blacksmith | Master Blacksmiths | 2 | 1050 |
| 15 | Gunsmith | Master Gunsmiths | 2 | 850 |
| 16 | Preacher | Firebrand Preachers | 3 | 1500 |
| 17 | Statesman | Elder Statesmen | 3 | 1900 |
| 18 | Teacher | Expert Teachers | 4 | -1 |
| 19 | Colonist | Free Colonists | 4 | -1 |
| 20 | Pioneer | Hardy Pioneers | 1 | 1200 |
| 21 | Soldier | Veteran Soldiers | 2 | 2000 |
| 22 | Scout | Seasoned Scouts | 1 | -1 |
| 23 | Dragoon | Veteran Dragoons | 2 | -1 |
| 24 | Missionary | Jesuit Missionaries | 3 | 1400 |
| 25 | Ind. Servant | Indentured Servants | 4 | -1 |
| 26 | Criminal | Petty Criminals | 4 | -1 |
| 27 | Convert | Indian Converts | 4 | -1 |

`EuropeCost = -1` = not purchasable from King (e.g., specialists
must be EARNED in-game by training colonists at native settlements
or by completing Schoolhouse education).

### Verified Plymouth worker assignment (frame 1310196718)

ColonyRecord +0x40..+0x45 (Plymouth, size=6):

| Worker idx | Byte | NAMES.TXT @JOB | Working tile (+0x70 lookup) |
|----------:|-----:|----------------|------------------------------|
| 0 | 0x16 = 22 | Scout / Seasoned Scouts | SE tile |
| 1 | 0x00 = 0  | Farmer / Expert Farmers | W tile |
| 2 | 0x01 = 1  | Sugar Planter / Master Sugar Planters | E tile |
| 3 | 0x1C = 28 | OUT OF RANGE — sentinel? In building? | — (not on tile) |
| 4 | 0x05 = 5  | Lumberjack / Expert Lumberjacks | — (in Carpenter's Shop?) |
| 5 | 0x0D = 13 | Carpenter / Master Carpenters | — (in Carpenter's Shop) |

Frame sidebar showed "Carpenter 88 Sentry" — matches Worker 5
(Carpenter, on Sentry).

### Old documented mapping (now superseded)

| Idx | Skill | Base resource |
|----:|-------|---------------|
| 0 | EXPERT FARMERS | Food |
| 1 | MASTER SUGAR PLANTERS | Sugar |
| 2 | MASTER TOBACCO PLANTERS | Tobacco |
| 3 | MASTER COTTON PLANTERS | Cotton |
| 4 | MASTER FUR TRAPPERS | Furs |
| 5 | EXPERT LUMBERJACKS | Lumber |
| 6 | EXPERT ORE MINERS | Ore |
| 7 | EXPERT SILVER MINERS | Silver |
| 8 | EXPERT FISHERMEN | Food (water) |
| 9 | EXPERT DISTILLERS | Rum (from Sugar) |
| 10 | MASTER TOBACCONISTS | Cigars (from Tobacco) |
| 11 | MASTER WEAVERS | Cloth (from Cotton) |
| 12 | MASTER FUR TRADERS | Coats (from Furs) |
| 13 | EXPERT CARPENTERS | Hammers (from Lumber) |
| 14 | EXPERT BLACKSMITHS | Tools (from Ore) |
| 15 | MASTER GUNSMITHS | Muskets (from Tools) |
| 16 | FIREBRAND PREACHERS | Liberty Bells |
| 17 | ELDER STATESMEN | Liberty Bells (better) |
| 18 | Student | (in school) |
| 19 | FREE COLONISTS | Generic worker |
| 20 | HARDY PIONEERS | Pioneer (specialty) |
| 21 | VETERAN SOLDIERS | Combat |
| 22 | SEASONED SCOUTS | Exploration |
| 23 | VETERAN DRAGOONS | Combat (mounted) |
| 24 | INDENTURED SERVANTS | Half-rate worker |
| 26 | PETTY CRIMINALS | Quarter-rate worker |
| 27 | INDIAN CONVERTS | Half-rate worker |

(Index 25 missing — probably reserved.)

## 25 Founding Fathers

PEDIA `@FATHER0..24` ↔ CC-NN sprite ↔ NAMES.TXT @FATHERS row N.

(Already documented in `SESSION_UI_CATALOG.md` — same indices.)

---

## Renderer wiring guide

When a renderer needs to display a commodity, unit, building, or
FF, it should:

1. Use the **index** from this table to look up the name (PEDIA).
2. Use the **index** to compute the sprite offset:
   - Cargo: `ICONS.SS.<12+i>` (estimated)
   - Unit: `ICONS.SS.<unit-row + offset>` (varies by type)
   - Building: `BUILDING.SS.<index>` (likely 1:1 with PEDIA index
     for tier-1 sprites; tier-2/3 may share sprites)
   - Founding Father: `CC-<NN>.SS.000` where NN matches PEDIA index
3. Use NAMES.TXT @TRIBES / @CARGO / @UNIT for player-facing names
   (these tables can be modded; PEDIA descriptions match).
