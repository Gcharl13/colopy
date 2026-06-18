# VICEROY.EXE Function Inventory

**Source binary**: COLONIZE/VICEROY.EXE -- 494,910 bytes, DOS real-mode, RTLink Plus overlays.

**Overlay disassembly**: extracted/disassembly/viceroy_overlay_full.asm -- 695 functions.
File offsets are cross-referenced to that .asm file.

This file is the canonical lookup for where in VICEROY.EXE does X happen?
Do not re-disassemble if the fact is here. Add new entries; do not rewrite
existing ones except to correct errors (note the correction with date).

**Last updated**: 2026-04-22. All byte evidence verified directly from VICEROY.EXE and MAPEDIT.EXE Ghidra dumps.

---

## X. Terrain-byte decoders (confirmed from Ghidra on 2026-04-22)

Two identical terrain-decoder functions exist — one in VICEROY.EXE, one in
MAPEDIT.EXE. Both take a raw terrain byte and return a terrain-type ID (0-28).

### VICEROY.EXE::FUN_13e4_000e — terrain-ID decoder

- **Ghidra address**: segment `13e4:000e`
- **Pseudo-code**:
  ```c
  uint16_t terrain_id(uint8_t raw) {
      if (raw & 0x20) {                   // hills bit set
          return (raw & 0x80) ? 0x1b : 0x1c;   // 0x1b=Mountain, 0x1c=Hills
      }
      return raw & 0x1f;                  // base terrain (0-23, 25, 26)
  }
  ```
- **Byte evidence** (first 18 bytes at `13e4:000e`):
  `55 8b ec 8b 5e 06 f6 c3 20 74 15 8a c3 25 80 00 3d 01`
  = push bp / mov bp,sp / mov bx,[bp+6] / test bl,0x20 / jz short +0x15 /
    mov al,bl / and ax,0x80 / cmp ax,1 ...
- **Callers**: FUN_13e4_003a (`get_terrain_type_at(x,y)`), FUN_15eb_18ec
  (colony yield lookup), and 12+ others.

### MAPEDIT.EXE::FUN_19b7_0006 — IDENTICAL terrain-ID decoder

Proves the map-editor and the game share the same bit-encoding convention.
Same bytes, same logic. Segment `19b7:0006`.

### Output → meaning (0-28 range)

| ID       | Meaning        | How raw byte encodes it                        |
|----------|----------------|-----------------------------------------------|
| 0-7      | Unforested biomes   | raw & 0x1f, 0-7                          |
| 8-15     | Forested biomes     | raw & 0x1f, 8-15                         |
| 16       | Arctic              | raw & 0x1f == 16                         |
| 17-23    | Extended bases      | raw & 0x1f, 17-23                        |
| 25       | Ocean               | raw & 0x1f == 25                         |
| 26       | Sea Lane            | raw & 0x1f == 26                         |
| **27 (0x1b)** | **Mountain**   | `raw & 0xA0 == 0xA0` (bits 5+7 set)      |
| **28 (0x1c)** | **Hills**      | `raw & 0x20 == 0x20` AND bit 7 clear     |

**Key insight**: Mountain is NOT a dedicated base ID. It's encoded as
bits 5+7 set together on top of a regular base (usually Prairie for
AMER2's Andes). The decoder collapses this combination to the virtual
terrain-ID 27 for yield/movement lookups.

### is_water check: FUN_13e4_0074 (VICEROY)

```c
bool is_water(uint8_t raw) {
    uint8_t b = raw & 0x1f;
    return (b == 25) || (b == 26);   // Ocean or Sea Lane
}
```

Matches cc94's `looks_like_sea`.

### Mountain wxad-index loop: MAPEDIT::1a47:0379-03dc

Builds a 4-bit mask of cardinal neighbors that have the **mountain**
feat (0xA0):

```
AX = this_neighbor_byte & 0xA0;
if (AX == 0xA0) mask |= neighbor_bit;   // N=8, S=4, W=2, E=1
```

This is exactly cc94's `get_wxad_index(loc, PhysMountain)`. Confirms
the mountain-edge sprite selection follows the same 16-variant topology
algorithm as forest and river.

### River flag TEST: MAPEDIT::1a47:0cfd

```
TEST AL, 0x40       ; bit 6 = RIVER flag
JZ skip_river
CALL is_water(neighbor)
CMP AX, 0x19        ; Ocean?
JZ skip
CMP AX, 0x1A        ; Sea Lane?
JZ skip
CALL draw_river_line(...)
```

Confirms ruling 2026-04-22 (h): **bit 6 = river, not road**. The editor
only draws rivers on tiles that have bit 6 set AND are NOT water.

### Map dimensions: MAPEDIT::1000:24b5

Default new-map dimensions hard-coded into MAPEDIT:
```
[0x4b12] = 0x3a (58)   ; W
[0x4b14] = 0x48 (72)   ; H
```
These match the AMER2.MP file header exactly.

---

## Y. Data table: 3x3 transition confirmed in VICEROY

Found at Ghidra address `2b5a:1ee4`, immediately AFTER the `"TERRAIN"`
null-terminated string (at `2b5a:1edc`):

```
2b5a:1edc: "TERRAIN\0"
2b5a:1ee4: 05 07 06 0d 0f 0e 09 0b 0a      ← the 3x3 sub-cell table
2b5a:1eed: "JOB\0"                          ← next data structure
```

This is a DATA BLOCK nestled between sprite-sheet name strings. The
layout `<sheet_name> <parameters>` suggests it's part of an index into
the extracted .SS data — probably a "TERRAIN sprite-sheet parameters"
record. The 9 bytes are used by VICEROY's main tile renderer (func_O512)
to select which 16-variant sprite goes at each of the 9 sub-cell
positions of a 48×48 tile.

---

## A. Map Rendering Chain

### func_O514 -- Main map-draw loop

- **File offset**: 0x685DC
- **Size**: 696 bytes (ends ~0x68894)
- **Role** (observed): Outer viewport loop iterating tile rows and columns.
  Reads visible-tile extents from [0x8804] / [0x8806], advances three
  layer far-pointers ([0xA594] / [0xA598] / [0xA59C]) per column, and
  calls func_O513 for each tile. The imul word ptr [0x8548] at file
  0x6868E computes the flat tile index using MAP_STRIDE (Section B).
- **Call chain**: func_O514 -> func_O513 @ 0x681A8
- **Key globals read**:
  - [0x8804] / [0x8806] -- map visible extents
  - [0x8328] / [0x832E] -- viewport tile origin
  - [0x8548] -- MAP_STRIDE (value 56)
  - [0xA5A4] / [0xA5A6] -- pixel origin for current tile
  - [0x15C] / [0x15E] -- terrain layer far pointer
  - [0x160] / [0x162] -- features layer far pointer
  - [0x168] / [0x16A] -- resource/fog layer far pointer
- **Evidence** (first 16 bytes at 0x685DC):
  C8 28 00 00 53 52 50 56 C7 46 E2 00 00 83 7E 06
  = enter 0x28,0 / push bx / push dx / push ax / push si / mov word ptr [bp-0x1E],0 / cmp word ptr [bp+6],0

---

### func_O513 -- Per-tile dispatcher

- **File offset**: 0x681A8
- **Size**: 165 bytes (ends ~0x6824D)
- **Role** (observed): Reads the three raw map bytes for the current tile
  (terrain, features, fog/resource) via the three far-pointers in ES:BX from
  [0xA594] / [0xA598] / [0xA59C]. Calls lcall 0x181F:0x6AA (terrain
  classifier) at 0x681D5, storing the visible-terrain result at [0xA8A2].
  Applies fog-of-war test using [0xA89E] AND [0xA8A0]. Writes tile-cell
  globals [0xA89F] (sub-cell col), [0xA8A1] (sub-cell row), [0xA8A0]
  (fog mask). For water tiles calls func_O512 via
  push 0 / push [bp-0x22] / push 1 / call 0x67F50. Draws the active-cursor
  sprite PHYS0.SS index 0x95 (149) at 0x68212 via
  mov ax,0x95 / call 0x67DC8.
- **Call chain**: func_O513 -> func_O512 @ 0x67F50; func_O513 -> func_O508 @ 0x67DC8
- **Evidence** (first 16 bytes at 0x681A8):
  C8 24 00 00 50 56 C7 46 E4 00 00 C4 1E 94 A5 26
  = enter 0x24,0 / push ax / push si / mov word ptr [bp-0x1C],0 / les bx,[0xA594] / es:

---

### func_O512 -- Tile sprite-selection worker

- **File offset**: 0x67F50
- **Size**: 402 bytes (ends ~0x680E2)
- **Role** (observed): Core of terrain composition. Outer loop [bp-4] runs
  0..3 (four passes, one per sub-cell quadrant). Inner loops use the 4-dir and
  8-dir offset tables (Section B) to query neighbors via lcall 0x181F:0x302
  (on-screen check) and lcall 0x181F:0x6C8 (priority). Reads
  byte ptr [bx+0xAE] (dY) and byte ptr [bx+0xA8] (dX) for cardinal
  directions. Uses the 3x3 transition table (Section B) and per-terrain
  center-variant table (Section B) to derive the sprite index, then calls
  func_O508 @ 0x67DC8 to blit each sub-cell sprite.
- **Call chain**: func_O512 -> func_O506 @ 0x67CF4 (4-dir mask);
  func_O512 -> func_O507 @ 0x67D54 (8-dir mask);
  func_O512 -> func_O508 @ 0x67DC8 (blit)
- **Data tables used**: 3x3 transition at file 0x1F884; center-variant at
  file 0x1DB32
- **Evidence** (first 16 bytes at 0x67F50):
  C8 2C 00 00 56 A1 A8 A5 89 46 DA 2B C0 A3 A8 A5
  = enter 0x2C,0 / push si / mov ax,[0xA5A8] / mov [bp-0x26],ax / sub ax,ax / mov [0xA5A8],ax

---

### func_O508 (0x67DC8) -- compute_dialog_rect_from_cursor (the "blit wrapper" reading is WRONG)

> **CORRECTED 2026-05-28 (render)**: func_067DC8 is NOT a sprite-blit wrapper. It
> is `compute_dialog_rect_from_cursor` (byte-verified): it reads cursor_x/y from
> [0x174]/[0x176] (the `mov ax,0x95` at the O513 call site is DEAD), and sets a
> popup/dialog rect via 0x181F:0x254 -> file 0xE76A. [0x839E] = screen CLIP RECT,
> NOT the PHYS0.SS descriptor. The real terrain pixel-emit is resident draw code
> from func_O512's loop (format TBD). See src/render/tile_chain.c + docs/RULINGS.md
> 2026-05-28 (render). The text below is the SUPERSEDED (incorrect) reading.

- **File offset**: 0x67DC8
- **Size**: 65 bytes (ends 0x67E09)
- **Role** (observed): Receives sprite index in AX and tile-position from
  globals. Computes screen_Y in CX from [0x1EA5] + [0xA5A6] - 15,
  screen_X in DX from [0x1EA4] + [0xA5A4] - 8. Loads BX = 0x839E
  (DS offset of PHYS0.SS sprite-sheet descriptor), pushes screen_Y, then
  calls lcall 0x181F:0x254 at file 0x67E02.
  Guards with cmp word ptr [0x1EA6],0x64 / jl skip to clip off-screen tiles.
- **Calling convention for lcall 0x181F:0x254** (inferred from O508 + two other
  call sites at 0x265BF and 0x26492):
  - AX = sprite index
  - DX = screen X in pixels
  - BX = DS offset of sprite-sheet descriptor (0x839E = PHYS0.SS terrain sheet)
  - [SP+0] = screen Y in pixels (pushed immediately before the lcall)
- **Call chain**: func_O508 -> lcall 0x181F:0x0254
- **Evidence** (first 25 bytes at 0x67DC8):
  C8 04 00 00 8B 0E 74 01 8B 16 76 01 89 4E FC 89 56 FE 83 3E 86 01 64 7C 29
  = enter 0x4,0 / mov cx,[0x0174] / mov dx,[0x0176] / mov [bp-4],cx / mov [bp-2],dx / cmp word ptr [0x0186],0x64 / jl +0x29
- **Far-call bytes at 0x67E02**: 9A 54 02 1F 18
  = lcall 0x181F:0x0254

---

### func_O507 -- 8-direction neighbor-mask compute

- **File offset**: 0x67D54
- **Size**: 116 bytes (ends 0x67DC8)
- **Role** (observed): Iterates DS:0xB4 (8-dir dX) and DS:0xBE (8-dir dY)
  for all 8 neighbors. Shifts the result left by direction index to form an
  8-bit presence mask. Bit assignments (inferred from bit-shift order):
  bit 0=N, bit 1=NE, bit 2=E, bit 3=SE, bit 4=S, bit 5=SW, bit 6=W, bit 7=NW.
  Guard: cmp word ptr [0x0184],0 / jl skip rejects map-edge neighbors.
- **Evidence** (first 17 bytes at 0x67D54):
  C8 0A 00 00 50 56 C7 46 FC 00 00 3B 16 84 01 7C 5D
  = enter 0xA,0 / push ax / push si / mov word ptr [bp-4],0 / cmp dx,[0x0184] / jl +0x5D

---

### func_O506 -- 4-cardinal neighbor-mask compute

- **File offset**: 0x67CF4
- **Size**: 96 bytes (ends 0x67D54)
- **Role** (observed): Iterates DS:0xA8 (4-dir dX) and DS:0xAE (4-dir dY)
  for the 4 cardinal neighbors. For each neighbor whose raw terrain byte ANDed
  with the input test-mask is non-zero, sets the corresponding bit in the
  return value. Used by road continuity, coast detection, and 3x3 transition
  composition. Cardinal order (bits 3-2-1-0): N, S, W, E.
  Guard: cmp word ptr [0x0184],0 / jg continue (same edge guard as O507).
- **Evidence** (first 17 bytes at 0x67CF4):
  C8 02 00 00 50 56 C7 46 FE 00 00 39 16 84 01 7F 49
  = enter 0x2,0 / push ax / push si / mov word ptr [bp-2],0 / cmp [0x0184],dx / jg +0x49

---

### func_O530 -- Map-editor terrain-palette dialog (NOT the renderer)

- **File offset**: 0x69D8C
- **Size**: 1,934 bytes (ends ~0x6A55E)
- **Role** (observed): Opens the map editor terrain-palette popup dialog.
  Prologue calls lcall 0x181F:0x22 (create dialog) and lcall 0x181F:0x100
  (dialog event loop). Uses the same sprite row conventions as the in-game
  renderer (rows 0x01 / 0x11 / 0x21 / 0x31 / 0x41) because it paints
  terrain previews, but this function is NOT part of the game render chain.
- **WARNING**: Earlier sessions mistakenly treated O530 as the in-game
  renderer. The actual render chain is
  func_O514 -> func_O513 -> func_O512. Do not repeat this error.
- **Evidence** (first 12 bytes at 0x69D8C):
  C8 A8 00 00 57 56 0E E8 FC 18 A0 31
  = enter 0xA8,0 / push di / push si / push cs / call +0x18FC (= lcall 0x181F:0x22)

---

## B. Core Data Tables

### 3x3 transition table

- **DS offset**: 0x1EE4
- **File offset**: 0x1F884
- **Size**: 9 bytes
- **Verified bytes**: 05 07 06 0D 0F 0E 09 0B 0A
- **Layout**: table[row * 3 + col] gives the intra-row sprite offset for
  each sub-cell position:
  - row 0 (top):    NW=5,  N=7,  NE=6
  - row 1 (center): W=13,  C=15, E=14
  - row 2 (bottom): SW=9,  S=11, SE=10
- **Usage** (observed in func_O512): The sprite for a sub-cell is computed as
  base_row_sprite + table[sub_row * 3 + sub_col].

---

### 4-direction offset tables (cardinal)

- **dX** -- DS offset 0xA8, file offset 0x1DA48
  Verified bytes: 00 01 00 FF = offsets 0, +1, 0, -1 for N / E / S / W
- **dY** -- DS offset 0xAE, file offset 0x1DA4E
  Verified bytes: FF 00 01 00 = offsets -1, 0, +1, 0 for N / E / S / W

---

### 8-direction offset tables (all neighbors)

- **dX** -- DS offset 0xB4, file offset 0x1DA54
  Verified bytes: 00 01 01 01 00 FF FF FF
  = 0, +1, +1, +1, 0, -1, -1, -1 for N / NE / E / SE / S / SW / W / NW
- **dY** -- DS offset 0xBE, file offset 0x1DA5E
  Verified bytes: FF FF 00 01 01 01 00 FF
  = -1, -1, 0, +1, +1, +1, 0, -1 for N / NE / E / SE / S / SW / W / NW

---

### Per-terrain center-variant table

- **DS offset**: 0x192
- **File offset**: 0x1DB32
- **Size**: 29 x 16-bit signed words = 58 bytes
- **Verified bytes**:
  06 00 01 00 02 00 03 00 04 00 05 00 06 00 06 00
  09 00 01 00 08 00 09 00 0A 00 0A 00 06 00 06 00
  09 00 01 00 08 00 09 00 0A 00 0A 00 06 00 06 00
  FF FF 07 00 FF FF 0C 00 0D 00
- **Semantics**: Sprite drawn at the center sub-cell = 0x5A + value (= 90 + value).
  Value 0xFFFF (-1) means no center sprite drawn.
  Index 24 = Arctic (no center), index 26 = Sea Lane byte-level (no center).

| Index | Terrain            | Value | Center sprite |
|-------|--------------------|-------|---------------|
| 0     | Ocean              | 6     | 96            |
| 1     | Sea Lane           | 1     | 91            |
| 2     | Tundra             | 2     | 92            |
| 3     | Desert             | 3     | 93            |
| 4     | Plains             | 4     | 94            |
| 5     | Prairie            | 5     | 95            |
| 6     | Grassland          | 6     | 96            |
| 7     | Savannah           | 6     | 96            |
| 8     | Marsh              | 9     | 99            |
| 9     | Swamp              | 1     | 91            |
| 10    | Boreal Forest      | 8     | 98            |
| 11    | Scrub Forest       | 9     | 99            |
| 12    | Mixed Forest       | 10    | 100           |
| 13    | Broadleaf Forest   | 10    | 100           |
| 14    | Conifer Forest     | 6     | 96            |
| 15    | Tropical Forest    | 6     | 96            |
| 16    | Wetland Forest     | 9     | 99            |
| 17    | Rain Forest        | 1     | 91            |
| 18    | (unknown)          | 8     | 98            |
| 19    | (unknown)          | 9     | 99            |
| 20    | (unknown)          | 10    | 100           |
| 21    | (unknown)          | 10    | 100           |
| 22    | (unknown)          | 6     | 96            |
| 23    | (unknown)          | 6     | 96            |
| 24    | Arctic             | -1    | (none)        |
| 25    | Ocean (byte-level) | 7     | 97            |
| 26    | Sea Lane (b-level) | -1    | (none)        |
| 27    | Hills              | 12    | 102           |
| 28    | Mountains          | 13    | 103           |

---

### MAP_STRIDE

- **DS offset**: [0x8548]
- **Runtime value**: 56
- **Evidence** (observed): F7 2E 48 85 = imul word ptr [0x8548] at file
  offset 0x6868E inside func_O514. There are 11 total occurrences of
  mov ax,[0x8548] in the overlay disassembly.
- **Note** (inferred): The .MP file is 58 columns wide; columns 0 and 57 are
  sea-lane border columns skipped by the renderer, giving effective stride 56.

---

## C. Sprite Blit Primitive

### lcall 0x181F:0x0254 -- popup/dialog-rect setter (NOT pixel-blit)

> **CORRECTED 2026-05-28 (render)**: 0x181F:0x254 is a Type-B thunk -> file 0xE76A
> = the popup/dialog-rect setter, NOT a framebuffer pixel-blit. O513 uses it to
> draw the active-tile SELECTION rect. The real terrain pixel-emit leaf is TBD
> (resident, invoked from func_O512). The "pixel-blit" text below is SUPERSEDED.

- **Type**: Far call via the RTLink **thunk table** (NOT a separate engine
  segment). 0x181F:0x0254 is a Type-B thunk (file 0x1A844) → JMPF to resident
  **file 0xE76A** (0x0C36:0x000A). See code/VICEROY/thunks_resolved.json.
- **Location in caller**: bytes 9A 54 02 1F 18 at file 0x67E02
  (inside func_O508).
- **Calling convention** (inferred from func_O508 0x67DC8 + call sites at
  0x265BF and 0x26492):
  - AX = sprite index (into the loaded .SS sheet)
  - DX = destination X in pixels (screen coordinates)
  - BX = DS offset of sprite-sheet descriptor
    (0x839E for terrain PHYS0.SS; other sheets differ)
  - [SP+0] = destination Y in pixels, pushed immediately before lcall
- **Wrapped by**: func_O508 @ 0x67DC8
- **Note (corrected 2026-05-28)**: 0x181F is the RTLink thunk table at file
  0x1A5F0..0x1D5E6, not an engine segment. This blit thunk resolves to resident
  code at file 0xE76A. All 362 Type-B 0x181F thunks resolve to resident
  load-image targets (thunks_resolved.json); Type-A thunks target overlay pages
  (overlay_pages.json). See docs/RULINGS.md 2026-05-28.

### lcall 0x181F:0x06AA -- compute_visible_terrain

- **Type**: Far call to MADS engine.
- **Role** (inferred): Given a raw terrain byte, returns the visible-terrain
  classification. Called by func_O513 at 0x681D5; result stored at [0xA8A2].
  Used for fog-of-war and center-sprite selection.
- **Called by**: func_O513 at file 0x681D5.

### lcall 0x181F:0x0302 -- on-screen bounds check

- **Type**: Far call to MADS engine.
- **Role** (inferred): Tests whether a tile coordinate is within the visible
  viewport. Called by func_O512 to skip off-screen neighbor queries.
- **Called by**: func_O512 (multiple sites within 0x67F50..0x680E2).

### lcall 0x181F:0x06C8 -- sprite priority/layer decision

- **Type**: Far call to MADS engine.
- **Role** (inferred): Returns a priority or layer value used by func_O512 to
  determine draw order for overlapping terrain features.
- **Called by**: func_O512 (multiple sites within 0x67F50..0x680E2).

---

## D. Game Logic Functions

### func_O006 -- Spring turn processor

- **File offset**: 0x21A14
- **Size**: 602 bytes
- **Role** (inferred from asm): Processes all unit actions for the Spring
  season (season index 0). Reads unit index from [0x5392]. Checks
  cmp word ptr [0x5390],0 (season = Spring) at entry. Dispatches per-unit
  processing.
- **Evidence** (first 16 bytes at 0x21A14):
  C8 0C 00 00 A1 92 53 89 46 F4 83 3E 90 53 00 74
  = enter 0xC,0 / mov ax,[0x5392] / mov [bp-0xC],ax / cmp word ptr [0x5390],0 / jz ...

---

### func_O007 -- Autumn turn processor

- **File offset**: 0x21D32
- **Size**: 320 bytes
- **Role** (inferred from asm): Processes all unit actions for the Autumn
  season (season index 1). Checks cmp word ptr [0x5390],1. Calls
  lcall 0x181F:0xE08 at 0x22FB2 (inferred: founding-father notification
  or season-end event).
- **Evidence** (first 16 bytes at 0x21D32):
  C8 04 00 00 C7 46 FE 00 00 83 3E 90 53 01 1B C0
  = enter 0x4,0 / mov word ptr [bp-2],0 / cmp word ptr [0x5390],1 / sbb ax,ax

---

### func_O030 -- Game-tick coordinator

- **File offset**: 0x24342
- **Size**: 643 bytes (ends ~0x245C5)
- **Role** (inferred from asm): Top-level per-tick coordinator. Calls
  lcall 0x0C0C:0x0006 at 0x24357 (game timer; returns DX:AX tick count).
  Reads [0x5390] for current season. Dispatches to the main game overlay via
  far jump at 0x24BA5 = EA 6C 00 1F 19 = jmpf 0x191F:0x006C.
- **Key globals**:
  - [0x5390] -- season: 0=Spring, 1=Autumn
  - [0x9328] / [0x9340] -- game state flags checked at entry
  - [0x5392] -- current unit index for per-turn processing
- **Evidence** (first 32 bytes at 0x24342):
  C8 1E 00 00 C7 46 E6 00 00 A1 28 93 39 06 3E 93 74 03 E9 69 02 9A 06 00 0C 0C 89 46 FA 89 56 FC
  = enter 0x1E,0 / mov word ptr [bp-0x1A],0 / mov ax,[0x9328] / cmp [0x933E],ax / jz ... / lcall 0x0C0C:0x0006 / mov [bp-6],ax / mov [bp-4],dx
- **Dispatch evidence**: jmpf @ 0x24BA5: EA 6C 00 1F 19 = jmpf 0x191F:0x006C
  (observed -- far jump into overlay segment 0x191F, NOT in viceroy_overlay_full.asm;
  the main loop body lives there)

---

### func_O002 -- Unit-turn dispatcher (partially understood)

- **File offset**: 0x20F50
- **Size**: not yet measured
- **Role** (inferred from asm): Loads unit index from [0x5392], multiplies
  by 0x1C (UnitRecord stride = 28 bytes) to index into the unit table.
  Reads [0x5398] via and ax,0x0F comparison. See correction below.
  Calls lcall 0x181F:0xB78 (unknown MADS function).
- **CORRECTION (2026-04-20)**: DS:0x5398 is the current_nation_index at
  turn start, NOT an RNG seed. Evidence: A3 98 53 (= mov [0x5398],ax) at
  file 0x23D51 is surrounded by imul bx,[bp-2],0x34 (AI personality stride
  52 bytes) and by A3 94 53 A3 96 53 (copies same value to [0x5394] and
  [0x5396]). An RNG seed would not be written three times to three adjacent
  globals by an imul-of-personality-stride instruction.
- **Evidence** (first 16 bytes at 0x20F50):
  C8 2A 00 00 56 A1 92 53 89 46 DA 6B D8 1C 80 BF
  = enter 0x2A,0 / push si / mov ax,[0x5392] / mov [bp-0x26],ax / imul bx,ax,0x1C / ...

---

### DGROUP record counts -- colony_count @0x539E, unit_count @0x539C (BYTE_VERIFIED 2026-05-28)

- **`0x539E` = active COLONY count** (NOT num_powers). Used as a ColonyRecord
  index/base via `IMUL ax,[0x539E],0xCA` (×202 = ColonyRecord stride) at file
  0x735B3 (bytes `69 06 9E 53 CA 00`; sibling site 0x73D17). Bounded to 48 by
  `CMP word[0x539E],0x30` at 0x22584 / 0x2EB82 / 0x4C5D4 (bytes `83 3E 9E 53 30`).
  Used as the colony-index bound inside set_active_colony (`CMP ax,[0x539E]` at
  0x82EF). See docs/RULINGS.md 2026-05-28 (ai).
- **`0x539C` = active UNIT count.** Used as a UnitRecord index/base via
  `IMUL ax,[0x539C],0x1C` (×28 = UnitRecord stride, base 0x3144) at file 0x735D6
  (bytes `6B 06 9C 53 1C`; sibling sites 0x73D3C, 0x400D0). Count bounds
  `CMP word[0x539C],0x124` / `0x12C` at 0x6D3F / 0x6D4A. See docs/RULINGS.md
  2026-05-28 (ai).
- Both imuls live in the power/table-init function func_0734F8, alongside the
  `PUSH 0x540E` (@0x73580) that passes the AIPersonality table base (see "AI
  decision entry per nation" below).

---

### Main turn loop (top-level) -- DISPATCH RESOLVED (reframed 2026-05-28)

- **Status**: The per-season processors are in func_O006 / func_O007 / func_O030
  (above). The main loop dispatches via a 24-entry jump table at file 0x24B78
  (stride 0x0C) of `jmpf 0x191F:NNNN`. **0x191F is NOT an undisassembled overlay
  segment** — it is an address in the RTLink thunk table (file 0x1A5F0..0x1D5E6).
  Each entry is a Type-A thunk whose target is an overlay page; all 31 page bases
  are recovered in code/VICEROY/overlay_pages.json, and the
  overlay code is already flat-disassembled in
  extracted/disassembly/viceroy_overlay_full.asm.
- **Remaining**: re-segment the overlay disasm using the recovered page bases so
  each dispatched function decodes at its correct base; for 100%-certain Type-A
  placement, finish the RTLink VP-directory field decode (precise blocker in
  overlay_pages.json `_blocker`). See thunks_resolved.json / docs/RULINGS.md.

---

### Combat resolution -- NOT YET LOCATED

- **Suggested search**: Look for references to unit attack/defense fields
  (at offsets within the 0x1C-byte UnitRecord) combined with RNG calls and
  a conditional outcome branch. Expected in overlay 0x191F or nearby.

---

### RNG function -- LOCATED & BYTE_VERIFIED (2026-05-02; entry corrected 2026-05-28)

- **Status**: `rand()` is the Microsoft C 6.0 LCG at **file 0x103D4** (in the
  load image, NOT the overlay). Bytes `B8 FD 43 BA 03 00` = `MOV AX,0x43FD;
  MOV DX,3` → multiplier `0x000343FD` = 214013; `05 C3 9E` / `83 D2 26` →
  addend `0x00269EC3` = 2531011; `AND AH,0x7F` → result `(seed>>16) & 0x7FFF`.
  Seed at DGROUP:0x28EE/0x28F0; `srand` at 0x103C2. `random_int(lo,hi)` at
  **file 0xC322** (`((rand()*(hi-lo+1))>>15)+lo`), reached from the overlay via
  `LCALL 0x181F:0x04D4` and called from dozens of game-logic sites. See
  `viceroy_source/src/runtime/rng.c`.
- **Why the earlier "not located" was wrong**: the 2026-04-20 note scanned only
  the overlay; the RNG lives in the load image. `0x343FD` occurs exactly once in
  the whole binary — at 0x103D5, inside `rand()`. (The sub-note that DS:0x5398
  is the current_nation_index, not an RNG seed, was correct and still holds.)

---

### Colony production per-turn -- NOT YET LOCATED

- **Suggested search**: Functions iterating over ColonyRecord (stride 0xCA)
  dispatching on occupation field bytes. Expected in overlay 0x191F area.

---

### European market price update -- NOT YET LOCATED

- **Suggested search**: Look for a 16-entry price table (one word per trade
  good) near the colony and unit tables in the data segment. Price-modifying
  function expected near func_O007 (Autumn processor).

---

### Founding Father election -- NOT YET LOCATED

- **Suggested search**: lcall 0x181F:0xE08 (called from func_O007 at
  0x22FB2) may be the notification event; the election logic itself is
  probably in overlay 0x191F.

---

### AI decision entry per nation -- NOT YET LOCATED

- **Suggested search**: Function that reads the AIPersonality table (base
  **DGROUP:0x540E**, stride 52 = 0x34 bytes, 4 nations) and dispatches
  per-nation. The new-game controller init at 0x23D44 does `imul bx,idx,0x34`
  then `MOV byte[bx+0x543F],1` — that writes the CONTROLLER flag at field
  **+0x31** (effective 0x543F); it does NOT make 0x543F the table base. The
  base is 0x540E (LEADERNAME strcpy `ADD ax,0x540E` @0x74C22; `PUSH 0x540E`
  @0x73580). See docs/RULINGS.md 2026-05-29 (RESOLVED). Dispatcher probably
  in overlay 0x191F.

---

## E. I/O Functions

### .MP map file loader -- NOT YET LOCATED

- **String evidence**: File-path string AMER2.MP at file offset 0x1FB06
  (observed -- null-terminated string in data segment).
- **Suggested search**: Function that opens a file matching *.MP via DOS
  INT 21h AH=3Dh, then reads 58*72 bytes into the map buffer starting at
  the terrain far-pointer base. Expected near DS:0x15C (terrain far ptr init).

---

### .SAV / .COL save-game reader/writer -- NOT YET LOCATED

- **String evidence**: COLONY.SAV at file offset 0x1FA82 (observed).
- **Suggested search**: Functions referencing that string with DOS INT 21h
  3Dh (open) or 3Ch (create). Format partially documented in
  `docs/SAVE_FORMAT_CROSSREF.md`.

---

### MADSPACK decompressor -- NOT YET LOCATED in VICEROY.EXE

- **String evidence**: MADSPACK 2.0 at file offset 0x1FDAB (observed).
- **Note**: A standalone extracted version exists in extracted/ and the
  PNG sprites are already decompressed. Locating this in VICEROY.EXE is
  low priority.
- **Suggested search**: The decompressor entry point likely follows immediately
  after the MADSPACK 2.0 string; search for a near-call to the address just
  past 0x1FDB8.

---

## Coverage summary

| Section | Count located | Count not located | Total targeted |
|---------|--------------|-------------------|----------------|
| A -- Render chain functions   | 7 | 0 | 7  |
| B -- Core data tables         | 6 | 0 | 6  |
| C -- Blit primitive           | 1 | 0 | 1  |
| D -- Game logic functions     | 4 (partial) | 4 | 8 |
| E -- I/O functions            | 0 | 3 | 3  |
| **Total**                     | **18** | **7** | **25** |

---

## Ranked priorities for not-yet-located items

Attack in this order (highest project value first):

1. **RTLink VP-directory field decode** -- 0x181F/0x191F are the thunk table
   (resolved: thunks_resolved.json); all 31 overlay page bases recovered
   (overlay_pages.json, 16 high/6 med/9 low confidence). Remaining: decode the
   VP-directory header fields (trace the reloc walker below 0x164A2) for
   100%-certain Type-A placement, then re-segment the overlay disasm.
2. **RNG function** -- DONE: `rand()` @ file 0x103D4, `random_int` @ 0xC322
   (byte-verified 2026-05-02).
3. **Combat resolution** -- LOCATED & byte-verified 2026-05-28: `func_05B2C2`
   @ file 0x5B2C2 (2926 bytes). Roll = random_int(1, ATK+DEF), attacker wins iff
   roll<=ATK; stat table DGROUP:0x5230 stride 14 (+0x0C atk, +0x0B def, +0x06
   eligibility). NOTE: 0x4E2B6 is the AI move-eligibility evaluator, NOT combat.
4. **Colony production** -- Economy fidelity; same overlay as combat.
5. **European market price update** -- Economy balance; near func_O007.
6. **AI decision entry** -- Late-game fidelity; same overlay as combat.
7. **.MP map loader** -- Confirms map-format decisions (empirical analysis
   in map-format-decoder already covers most of this).
8. **MADSPACK decompressor in VICEROY.EXE** -- Low priority; PNGs extracted.

Each of these should be its own focused dos-disassembler invocation.

---

## P6 trace-anchor map (Godot game-logic re-derivation)

Source: `extracted/disassembly/function_index.json` (99 tagged functions)
+ `viceroy_overlay_full.asm` (1.87 MB). These are the cited entry points
each P6 subsystem MUST be traced from before any GDScript is written
(prime directive — no guessing). Dependency-ordered per the export plan.

| # | Godot module | VICEROY anchor (file_offset) | Tags / evidence |
|---|--------------|------------------------------|-----------------|
| 1 | `colony.gd` (production) | idx 14 `0x2EB1C`, idx 15 `0x2EB46` (ColonyRecord accessors); colony_turn_update VICEROY `0xA3E1` (memory: Sugar→Rum/Tobacco→Cigars/Ore→Tools) | `ColonyRecord (202B), colony_table` |
| 2 | `market.gd` | idx 44 `0x57DC0` (279 B, 99 instr) | `PowerRecord (316B), unk_threshold` — economy/price model |
| 3 | `combat.gd` | idx 39 `0x4E2B6` (1074 B, 327 instr) | `UnitRecord, current_year, unk_threshold, RANDOM` |
| 4 | `game_state.gd` end-turn | idx 39 `0x4E2B6`; idx 16 `0x30550` (PowerRecord) | end-turn op order + per-power accounting |
| 5 | `natives.gd` | NativeSettlement DGROUP:0x54EC; CHIEFKILL `func_04A7CA` (memory byte-verified) | raze gold + settlement table |
| 6 | `ai.gd` | idx 32 `0x40608`, idx 37 `0x45D92` | `AIPersonality (52B), ai_personality` |
| 7 | `revolution.gd` | REF array DGROUP:0x53DA..0x53E1 (memory byte-verified) | REF slot order Reg/Cav/MoW/Art |
| 8 | `diplomacy.gd`+`fathers.gd` | NAMES @FATHERS; king-anger DGROUP:0x53A7 (memory) | FF election + tax/Tea-Party |
| 9 | `save_system.gd` | `colowin/docs/engine/SAVE_FORMAT.md` (COL2 v3) | .COL r/w + parity |

RNG (idx 29 `0x3C322`) already done & engine-verified (plan P3).
Each row = one focused trace+implement+trace-verify increment. Verify
every subsystem via `tests/run_parity_godot.py` (deterministic trace).

