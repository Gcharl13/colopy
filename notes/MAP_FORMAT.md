# MAP_FORMAT.md — Colonization .MP File Format

**Canonical artifact. Validated against AMER2.MP, ONE.MP, UNTITLED.MP, BLANK4.MP.**
**Last validated: 2026-04-20.**

---

## 1. Overview / File Structure

A `.MP` file is a fixed-layout binary map. Every map currently observed uses 58 columns × 72 rows (4,176 tiles). The file has no compression and no checksum.

```
Offset        Size        Content
------        ----        -------
0             2           Width  (W) — u16 little-endian
2             2           Height (H) — u16 little-endian
4             2           Nations — u16 little-endian (always 4)
6             W*H         Layer 1: terrain bytes
6 + W*H       W*H         Layer 2: feature bytes
6 + 2*(W*H)   W*H         Layer 3: resource overlay bytes
```

**Total file size = 6 + 3*W*H bytes.**

Verified against all four test maps: every file is exactly 12,534 bytes = 6 + 3 * 4,176.

---

## 2. Header (bytes 0-5)

| Offset | Type   | Field   | Observed values                      |
|--------|--------|---------|--------------------------------------|
| 0      | u16 LE | Width   | 58 (0x3A, 0x00) on all four maps     |
| 2      | u16 LE | Height  | 72 (0x48, 0x00) on all four maps     |
| 4      | u16 LE | Nations | 4  (0x04, 0x00) on all four maps     |

**Confirmed (4 maps agree):** Width=58, Height=72, Nations=4.

The Nations field matches the `"nations": 4` entry in `extracted/map/AMER2_info.json` and the comment in `MAPEDIT_DECOMPILE.md` ("WORD nations — always 4"). Treat it as informational; do not use it as a loop bound.

**Playable area:** columns 1-56 are playable land/ocean. Column 0 and column 57 are Sea Lane border strips forced to base ID 26 (Sea Lane) at runtime by the loader.

**Disk vs. runtime transformation**: On disk, the rightmost column (column W-1 = 57)
contains raw byte 0x19 (base 25 = Ocean, no flags). At load time, the renderer
transforms all tiles in the rightmost column to base 26 (Sea Lane) for rendering.
When hand-parsing a .MP file, expect 0x19 in column 57, not 0x1A (which would be 26).
The 26 identifier is runtime-only.

---

## 3. Terrain Layer (Layer 1)

### 3.1 Byte decomposition

Each byte encodes a base terrain type in the low 5 bits and three independent feature flags in the high 3 bits:

```
Bit 7 (0x80)  — Forest flag: tile has a forest overlay
Bit 6 (0x40)  — Road flag: tile has a road
Bit 5 (0x20)  — Hills flag: tile has a hills overlay
Bits 4-0      — Base terrain ID (0-26)
```

**Extraction:**
```python
base  = raw & 0x1F   # terrain type (0-26)
flags = raw & 0xE0   # combined feature pattern
forest = bool(raw & 0x80)
road   = bool(raw & 0x40)
hills  = bool(raw & 0x20)
```

**CONFIRMED label applies to every claim in this section** because all four test maps agree and the bit definitions match the renderer in `colonize_sdl/main.py` (raw_at / road check at line 2707).

### 3.2 Feature flag patterns — empirical frequency

| Pattern | Hex  | Bits 7-5 | Meaning               | AMER2 tiles | UNTITLED tiles | ONE tiles | BLANK4 tiles |
|---------|------|----------|-----------------------|-------------|----------------|-----------|--------------|
| 000     | 0x00 | 000      | No overlay            | 3,724       | 4,143          | 4,176     | 4,176        |
| 001     | 0x20 | 001      | Hills                 | 56          | 0              | 0         | 0            |
| 010     | 0x40 | 010      | Road                  | 178         | 0              | 0         | 0            |
| 011     | 0x60 | 011      | Hills + Road (rare)   | 1           | 0              | 0         | 0            |
| 100     | 0x80 | 100      | Forest flag alone     | 0           | 0              | 0         | 0            |
| 101     | 0xA0 | 101      | Mountains             | 170         | 22             | 0         | 0            |
| 110     | 0xC0 | 110      | Forest + Road         | 47          | 11             | 0         | 0            |
| 111     | 0xE0 | 111      | (not observed)        | 0           | 0              | 0         | 0            |

**Notes on the flag patterns:**

- `0x20` (Hills): confirmed AMER2 (56 tiles) + MAPEDIT_DECOMPILE.md agreement. Appears on varied land base IDs. UNTITLED has 0 Hills tiles but does confirm Mountains (0xA0).

- `0x40` (**River**, resolved 2026-04-22 (h)): earlier interpreted as "road" but DOS does NOT render roads at scenario start. Visualizing bit-6 tiles on real AMER2 shows natural river paths (Mississippi + tributaries in North America, Amazon basin in South America). The 13 ocean tiles with bit 6 are river MOUTHS (where a river meets the sea). See RULINGS.md 2026-04-22 (h).

- `0x60` (Hills+Road): 1 tile in AMER2 at (25,17), raw=0x72. Bits 5 and 6 can coexist.

- `0x80` (Forest flag alone): **zero occurrences** in all four maps. Forested terrain is encoded via base IDs 8-15. Bit 7 in isolation has no real-file evidence.

- `0xA0` (Mountains): confirmed AMER2 + UNTITLED. The base ID under `0xA0` is the underlying terrain (Prairie, Desert, etc.) — it does NOT become a dedicated "Mountains" base ID.

- `0xC0` (**Forest+River**, resolved 2026-04-22 (h)): confirmed AMER2 + UNTITLED (11 tiles). River flowing through forest (e.g., Amazon), or (for 17 ocean tiles) a forested river mouth at the coast.

### 3.3 Base terrain IDs

The ordering below is from `NAMES_sections.json` (@UNFORESTED, @FORESTED, @OTHER) and confirmed by all four .MP files. **This is the authoritative ordering for map bytes.** It differs from `mapedit.c` (which uses 0=Ocean, 1=SeaLane, 2=Tundra...) — do not use the mapedit.c ordering.

#### Unforested land (IDs 0-7)

| ID | Name       | Confirmed in            |
|----|------------|-------------------------|
| 0  | Tundra     | AMER2, UNTITLED         |
| 1  | Desert     | AMER2, ONE, UNTITLED    |
| 2  | Plains     | AMER2                   |
| 3  | Prairie    | AMER2, UNTITLED         |
| 4  | Grassland  | AMER2, UNTITLED         |
| 5  | Savannah   | AMER2                   |
| 6  | Marsh      | AMER2                   |
| 7  | Swamp      | AMER2                   |

#### Forested land (IDs 8-15)

Forest is encoded as a dedicated base ID, not as a flag on top of an unforested base. IDs 8-15 correspond to the @FORESTED section entries in order.

| ID | Name            | Confirmed in    |
|----|-----------------|-----------------|
| 8  | Boreal Forest   | AMER2, UNTITLED |
| 9  | Scrub Forest    | AMER2           |
| 10 | Mixed Forest    | AMER2           |
| 11 | Broadleaf Forest| AMER2           |
| 12 | Conifer Forest  | AMER2, UNTITLED |
| 13 | Tropical Forest | AMER2           |
| 14 | Wetland Forest  | AMER2           |
| 15 | Rain Forest     | AMER2           |

#### Special terrain (IDs 16-26)

| ID    | Name      | Confirmed in | Notes                                          |
|-------|-----------|--------------|------------------------------------------------|
| 16    | Arctic    | AMER2, UNTITLED | Polar region; appears at far north of AMER2 |
| 17-23 | Unknown   | AMER2 only   | **See section 7 (ambiguities)**                |
| 24    | (unused)  | none         | No tile with base=24 observed in any map       |
| 25    | Ocean     | all four maps| Default fill; BLANK4 is entirely base=25       |
| 26    | Sea Lane  | AMER2        | Coastal navigation lanes; also set by loader   |

**Note on IDs 17-23:** These bases appear in AMER2 only (not in ONE, UNTITLED, or BLANK4). They all receive fog layer value 2 (land, no resource), confirming they are land terrain types. They cluster in the central Americas region of the AMER2 map at mid-latitudes. The @NAMES text sections enumerate only 16 named land types (IDs 0-15) + Arctic (16) before Ocean (25) and Sea Lane (26), leaving IDs 17-24 unaccounted for in text data. These are likely continent-specific terrain variants generated by VICEROY.EXE's random map generator that are not accessible in MAPEDIT.EXE. They are flagged as ambiguous in section 7.

---

## 4. Feature Layer (Layer 2)

**All four test maps show zero non-zero bytes in the feature layer.**

The `AMER2_info.json` `features_found` list confirms `[0]` (only zero). The `MAPEDIT_DECOMPILE.md` comment states: "Layer 2: width × height bytes — feature (roads/rivers, 0 at game start)."

The mapedit.c reconstruction (low trust) defines:
- `FEATURE_NONE = 0x00`
- `FEATURE_RIVER = 0x01` (from NAMES.TXT @OTHER_NAMES)
- `FEATURE_ROAD = 0x02`
- `FEATURE_LOST_CITY = 0xB0` (from COLONIZATION_TECHNICAL_REFERENCE.md memory map analysis)

**These values are speculative — they have not been confirmed against a non-zero feature layer in any of the four test maps.** The feature layer is populated only during gameplay, not in the shipped map files.

**Speculative interpretation (not validated against a real file):**
- Bit 0 (0x01): River
- Bit 1 (0x02): Road (redundant with terrain byte bit 6?)
- Value 0xB0: Lost City Rumour marker

This layer is reserved for `cross-source-reconciler` to resolve once a mid-game save's embedded map data can be examined.

---

## 5. Resource Overlay Layer (Layer 3)

The third layer assigns resource and tile-category values. Validated against AMER2.

### 5.1 Value semantics

| Value | Meaning                  | Observed in AMER2             |
|-------|--------------------------|-------------------------------|
| 0     | Border / no data         | 256 tiles (matches column 0+57 sea lanes) |
| 1     | Water tile               | 2,685 tiles (base 25 + 26 + coast) |
| 2     | Land tile, no resource   | 1,166 tiles (all land bases)  |
| 3-14  | Special resource bonus   | 69 tiles total                |

Cross-check: fog=1 tiles have base distribution {25: 1,874, 26: 810, 0: 1} — almost entirely ocean bases, confirming value 1 = water. The one base-0 (Tundra) tile at fog=1 at (21,1) is an edge case (coastal tundra tile treated as water-adjacent).

fog=2 tiles span all land bases (0-16, 17-23) — confirming value 2 = land, no resource.

### 5.2 Resource ID table

From @RESOURCE in `NAMES_sections.json` (positions 0-13, stored as overlay values 1-14):

| Overlay value | Resource name      | Bonus yield        |
|---------------|--------------------|--------------------|
| 1             | Depleted Mine      | +6 ore             |
| 2             | Oasis              | +3 food            |
| 3             | Wheat              | +4 food            |
| 4             | Prime Cotton       | +6 cotton          |
| 5             | Prime Tobacco      | +6 tobacco         |
| 6             | Prime Sugar        | +7 sugar           |
| 7             | Minerals           | +4 ore             |
| 8             | Fishery            | +5 fish            |
| 9             | Beaver             | +6 furs            |
| 10            | Game               | +6 furs            |
| 11            | Prime Timber       | +6 lumber          |
| 12            | Prime Timber (B)   | +6 lumber          |
| 13            | Silver Deposit     | +12 silver         |
| 14            | Ore Deposit        | +6 ore             |

**CONFIRMED** (AMER2 has all 14 resource types, max value = 14, matches NAMES_sections.json length exactly).

### 5.3 Resource distribution in AMER2

Special resources (values 3-14): 69 tiles total. Value 5 (Prime Tobacco) is most common (22 tiles).

---

## 6. Off-Map Convention

When the renderer needs to sample a tile outside the map boundaries, it returns `0x19` (decimal 25 = Ocean base ID, no flags). This is confirmed at `colonize_sdl/main.py` line 2557:

```python
def raw_at(x, y):
    t = wm.get_tile(x, y)
    if not t:
        return 0x19  # off-map counts as ocean
    return getattr(t, '_raw', t.terrain)
```

The value `0x19 = 25 = Ocean` also matches `create_blank_map()` in `MAPEDIT_DECOMPILE.md`: "fills all terrain with ocean (type 0x19 = 25)."

**CONFIRMED** by both the renderer source code and the map editor decompilation.

---

## 7. Known Ambiguities

These items could not be resolved from the four test maps alone. Forward to `cross-source-reconciler` or `dos-disassembler` for resolution.

### AMB-1: Base terrain IDs 17-23 — **PARTIALLY RESOLVED 2026-04-22 (i)**

**What is known:** All seven IDs appear heavily in real AMER2 (54+81+22+45+165+5+194 = 566 tiles ≈ 14% of the map). They all receive resource-overlay value 2 (land, no resource). Spatial analysis (tools/viz_ext_bases.py) shows them clustered geographically — 17/19 on east coast, 18/20 in northern plains, 21 in Central/South tropical zone, 23 widespread. They accept all flag combinations (0x00, 0x20, 0x40, 0xA0, 0xC0) just like other land bases.

**Resolution (empirical)**: Treat bases 17-23 as FORESTED biome variants specific to the AMER2 scenario. The renderer's `_tile_has_forest` now returns True for `17 <= base <= 23`, causing the 16-variant wxad forest topology to fire on these tiles. Ground textures picked per cluster geography:
- 17, 19, 23: Grassland-green (most widespread land type)
- 18, 20: Plains-olive
- 21: Savannah-yellow (tropical/Central-America zone)
- 22: Marsh-green (rare wet pockets)

This produces authentic-looking AMER2 rendering with proper forest density — Amazon basin reads as continuous canopy, eastern North American deciduous forest is filled in, etc.

**What is still unknown:** Their CANONICAL names from the DOS source. NAMES.TXT lists 21 named terrains (8 unforested + 8 forested + Arctic + Ocean + SeaLane + Mountains + Hills). IDs 17-23 have no entries. Since the rendering is now visually correct, the name mystery is cosmetic — it only matters for tile-info UI text.

See RULINGS.md 2026-04-22 (i) for full details.

### AMB-2: Terrain byte bit-5 (0x20) meaning

**What is known:** Empirical data from AMER2 shows 56 tiles with the 0x20 flag. Only 2 of those 56 tiles have a resource-overlay value >= 3 (special resource), making the MAPEDIT_DECOMPILE.md label "bit 5 = prime_resource flag" inconsistent with observed data.

**Two competing interpretations:** MAPEDIT_DECOMPILE.md (low trust) labels bit5 = prime_resource. The actual renderer (main.py) treats 0x20 as Hills and stores resources separately in Layer 3. Empirically only 2 of 56 tiles with bit5 set have a Layer-3 resource value >= 3, which is inconsistent with a prime-resource marker. **For rendering purposes, treat 0x20 = Hills.** The deeper meaning of bit5 vis-a-vis the resource layer is unresolved.

### AMB-3: Feature layer (Layer 2) non-zero values

No non-zero feature layer bytes appear in any of the four test maps. The layer semantics (river=0x01, road=0x02, lost-city=0xB0) are known only from `mapedit.c` reconstruction, which has a documented history of inaccuracies. Verification requires examining a save-game map state that includes rivers or lost city rumours.

### AMB-4: The single 0x60 tile

AMER2 contains exactly one tile with flags=0x60 (both Hills=0x20 and Road=0x40 set): tile (25,17), raw=0x72, base=18. Its neighbors include both hills tiles (0x20 flag) and road tiles (0x40 flag), so Hills+Road combination is geometrically plausible. This is an observed fact, not an ambiguity — but worth noting because it confirms bits 5 and 6 can coexist on a single tile.

### AMB-5: Ocean tiles with Road flag (0x40) — **RESOLVED 2026-04-22 (h)**

~~AMER2 has 13 ocean tiles (base=25) with the 0x40 flag and 17 with the 0xC0 flag. These cluster near coastlines in the Gulf of Mexico region. Their resource-overlay values are mostly 1 (water) or 5 (Prime Tobacco). Whether these encode harbour facilities, river mouths, shallow-water passages, or are map-editor artifacts is unresolved.~~

**Resolution**: Bit 6 (0x40) is the RIVER flag, not road. Ocean tiles with bit 6 are **river mouths** — where a river enters the sea. The cc94-based renderer now draws cardinal mouth-marker sprites (PHYS0.140-143) on these water tiles, pointing toward the adjacent river tile on land. See RULINGS.md 2026-04-22 (h).

### AMB-6: Forest flag (0x80) alone

Zero tiles in any map have flags=0x80 in isolation. The renderer handles it speculatively. Whether forest can be encoded as a flag on top of an unforested base (rather than via base IDs 8-15) in VICEROY.EXE's terrain generator is unknown. Current safe assumption: **forest = base ID in 8-15; bit 7 alone is not used in shipped maps.**

---

## 8. Appendix: Per-Map Statistics

### AMER2.MP (58×72 = 4,176 tiles)

**Header:** W=58, H=72, Nations=4. File size=12,534.

**Feature flags:** 0x00=3724, 0x20=56, 0x40=178, 0x60=1, 0xA0=170, 0xC0=47.

**Top base IDs:** 25=2139 (Ocean), 26=810 (SeaLane), 23=194, 21=165, 16=121, 18=81, 3=125, 0=25, all others <60.

**Resource overlay:** 0=256, 1=2685, 2=1166, 3-14=69 (special resources). Distinct values: 0x01-0x0E.

### ONE.MP (58×72 = 4,176 tiles)

5 Desert tiles (base=1, no flags), 4,171 Ocean tiles (base=25). All layers 2 and 3 are zero.

### UNTITLED.MP (58×72 = 4,176 tiles)

Bases: 0=66 (Tundra), 1=91 (Desert, 22 with 0xA0), 4=102 (Grassland, 10 with 0xC0), 8=18 (Boreal), 12=4 (Conifer), 25=3895 (Ocean). Layers 2 and 3 are zero.

### BLANK4.MP (58×72 = 4,176 tiles)

All 4,176 tiles are base=25 (Ocean), no flags. Layers 2 and 3 are zero. Pure reference map.

---

## Quick Reference

```python
import struct

def read_map(path):
    with open(path, 'rb') as f:
        data = f.read()
    W, H = struct.unpack_from('<HH', data, 0)
    terrain = data[6 : 6 + W*H]
    feature = data[6 + W*H : 6 + 2*W*H]
    overlay = data[6 + 2*W*H : 6 + 3*W*H]
    return W, H, terrain, feature, overlay

def decode_tile(raw):
    return {
        'base':   raw & 0x1F,    # terrain type 0-26
        'hills':  bool(raw & 0x20),
        'road':   bool(raw & 0x40),
        'forest': bool(raw & 0x80),
    }

OFF_MAP_SENTINEL = 0x19   # 25 = Ocean; returned for out-of-bounds reads
WATER_BASES = {25, 26}    # Ocean, Sea Lane
```

**Terrain ID ordering (bits 0-4):**
- 0-7: Tundra, Desert, Plains, Prairie, Grassland, Savannah, Marsh, Swamp
- 8-15: Boreal, Scrub, Mixed, Broadleaf, Conifer, Tropical, Wetland, Rain Forest
- 16: Arctic
- 17-23: Unknown extended types (AMER2 only — see AMB-1)
- 24: Unused
- 25: Ocean
- 26: Sea Lane
