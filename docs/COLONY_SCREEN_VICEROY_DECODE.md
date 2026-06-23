# COLONY SCREEN — VICEROY.EXE decode (code-anchored)

> Source of truth = **VICEROY.EXE disassembly** (`raw/COLONIZE/VICEROY.EXE`, capstone
> 16-bit). The recol-0.2.0 fork decode (`COLONY_RENDERER_DECODED.md`) is used as a
> cross-reference for *structure* only — every coordinate/table below is re-confirmed
> against VICEROY bytes. Built 2026-06-23 after three prior incomplete attempts; this
> file exists so the layout is **never re-derived from guesses again**.

## 0. Anchors

- **DGROUP file base = `0x1D9A0`.** Verified: the literal string `"COLORS"` is at
  `DS:0x22A7` (code pushes `0x22A7` @`0x7518C`) and sits at file `0x1FC47`
  → `0x1FC47 − 0x22A7 = 0x1D9A0`. (Read-back at `0x1FC47` = `"COLORS\0"`.)
- **BSS starts at `DS:0x2CC6`** (`MOV di,0x2cc6 ; start of BSS` @`0x0F7A3`). So any
  `DS:` offset **< 0x2CC6 is STATIC initialized data** readable directly from the file
  at `0x1D9A0 + off`; offsets **≥ 0x2CC6 are runtime/BSS** (zero in the file).
- Active colony record pointer = **`[0x8542]`** (near ptr; ColonyRecord stride `0xCA`).

## 1. Entry + call chain (VICEROY; recol func in parens)

```
colony_screen_main(colony)            (recol func_01D989)
  set active colony  [0x8542]
  precompute surrounding tiles
  set screen mode = colony
  paint_colony_background  → load COLONY.PIK         (recol func_017323 / load_asset)
  paint_colony_screen  = COMPOSER func_028592        (recol func_0199D8)
  event loop
```

## 2. Composer draw order — `func_028592 @0x028592` (byte-read, 12 calls)

Trampolines `CALL cs:0x2C9xx/0x2CAxx` → each `ljmp 0x191F:NNN` to the real sub-renderer.

| # | @site | trampoline | sub-renderer | role |
|---|-------|-----------|--------------|------|
| 1 | 0x028595 | `lcall 0x181F:0xC22` | — | scene/clear setup |
| 2 | 0x02859B | `call 0x2CA5A` | func_025C32 | colonist sort (stage A) |
| 3 | 0x02859F | `call 0x2CACD` | **func_026374** | **TERRAIN SCENE + scene units** |
| 4 | 0x0285AD | `call 0x2CAC3` (push 0xC8,0x140,0,0) | func_02633E | **full-screen region fill (x=0,y=0,w=320,h=200)** |
| 5 | 0x0285B5 | `call 0x2CAE6` | func_0268CE | **title text** |
| 6 | 0x0285BD | `call 0x2C9A1` | func_0264A8 | **field-production panel** |
| 7 | 0x0285C5 | `call 0x2C9DD` | func_0270D0 | **colonist plaza row** |
| 8 | 0x0285CD | `call 0x2CA19` | (trampoline) | sub-renderer (role TBD) |
| 9 | 0x0285D7 | `call 0x2C9E7` | func_02853C | **flag panel** |
| 10 | 0x0285DF | `call 0x2C9FB` | func_027DB2 | **surrounding-tile minimap** |
| 11 | 0x0285E7 | `call 0x2C983` | func_02814C | **SoL / cargo / msg panel** |
| 12 | 0x0285EF | `call 0x2C97E` | **func_02701C** | **buildings loop (15 slots)** |
| — | 0x028607 | `lcall 0x181F:0xE2` if `[bp+6]≠0` | — | screen-bottom rule |

> The stockpile bar is a separate per-page sub-renderer `func_0281D6` (not one of the
> 12 head calls); recol confirms it as `func_019622`.

## 3. Region map — "what is drawn where" (all byte-verified)

The screen is two zones: a **scene zone (0,7,320,~128)** (colony view) on top and a
**bottom band (y≥130)** of panels, with the stockpile strip at the very bottom.

| Element | x | y | w | h | source |
|---------|---|---|---|---|--------|
| Full-screen fill | 0 | 0 | 320 | 200 | composer step 4 `func_02633E` (push 0xC8,0x140,0,0) |
| Title bar (text) | centered | ~0–7 | — | — | func_0268CE / recol 0x199E8 clear (0,0,320,7) |
| **Scene zone** (PIK ground + buildings + colonists) | 0 | 7 | 320 | 128 | recol mid-band wide blit (0,7,320,128) @0x17970 |
| Field-production panel | 224 | 32 | 72 | 72 | func_0264A8 @0x0264E9 |
| Colonist plaza row | 0 | 130 | 120 | 48 | func_0270D0 @0x0270D6 (recol clear 0,130,130,48) |
| Surrounding-tile minimap | 121 | 130 | 84 | 48 | func_027DB2 @0x027DB7 |
| SoL / cargo / msg panel | 211 | 130 | 91 | 48 | func_02814C @0x02814F |
| Flag panel | 303 | 132 | 17 | 45 | func_02853C @0x028540 |
| Stockpile bar | 0 | 179 | 320 | 21 | func_0281D6 @0x0281DB |
| Stockpile gold readout | 306 | 179 | 15 | — | @0x0283F1 |

## 4. BUILDINGS — positions, generation, frame selection (the part I kept getting wrong)

### 4a. Per-plot draw loop — `func_02701C @0x027067` (15 slots)
```
for slot = 0 .. 14 (cmp 0xF @0x02707B):
    bx = slot*4
    x  = word[DS:0x266 + bx]          ; @0x027087  -- PLOT X (static table)
    y  = word[DS:0x268 + bx] + 8      ; @0x02708B/8F-- PLOT Y + 8
    type  = byte[DS:0x8D62 + slot]    ; @0x027095  (BSS: per-colony)
    level = byte[DS:0x8E82 + slot]    ; @0x02709D  (BSS: per-colony; <0 ⇒ empty, skip)
    draw_building(level, x, y, type)  ; call 0x2CA23 → 0x191F:0x66C
```
**Buildings are placed by the `0x266` PLOT TABLE, not by a grid and NOT by the
BUILDING.SS frame descriptors.** (The recol equivalent `draw_one_building(level,
sprite,x,y)` blits at the passed `x,y`.)

### 4b. Plot position table — STATIC at `DS:0x266` (file `0x1DC06`), 15× (word x, word y)
Byte-verified (the y the renderer uses = table_y **+ 8**):

| slot | x | table y | **render y (+8)** |
|----|----|----|----|
| 0 | 56 | 5 | 13 |
| 1 | 145 | 7 | 15 |
| 2 | 173 | 10 | 18 |
| 3 | 8 | 33 | 41 |
| 4 | 37 | 37 | 45 |
| 5 | 67 | 46 | 54 |
| 6 | 96 | 45 | 53 |
| 7 | 6 | 6 | 14 |
| 8 | 128 | 45 | 53 |
| 9 | 10 | 68 | 76 |
| 10 | 15 | 94 | 102 |
| 11 | 87 | 3 | 11 |
| 12 | 66 | 79 | 87 |
| 13 | 123 | 98 | 106 |
| 14 | 123 | 47 | 55 |

(These are the 15 building-category plots in the colony view. They are FIXED; the
colony's actual buildings just occupy the plots whose `level ≥ 0`.)

### 4c. Generation — which building/level per plot
- `type[slot]` = `byte[0x8D62+slot]`, `level[slot]` = `byte[0x8E82+slot]` — both BSS,
  filled per-colony from the ColonyRecord building data at colony-screen entry
  (writer not yet pinned — runtime fill; `level<0` marks an unbuilt plot).

### 4d. Frame selection — building type→frame mapper `func_026CC2 @0x026CC2`
Returns (frame_base `[bp-6]`, dims `[bp-4]`, …) for a building type `[bp+6]`:
- type `0x13`/`0x14` → `[bp-6]` from `[0xA892]`, dims `0x3F`
- type `0x11` → `[bp-6]` from `[0x8DD8]`, dims `0x1F` (then `−[0xA892]`)
- else: `lcall 0x181F:0xACE` (type→base), `lcall 0x181F:0xBAA` (level gate);
  base `frame = value + 0x17`; a jump table `jmp cs:[bx+0x1472]` for type−9 in `0..8`
  picks per-type frame/dim pairs (e.g. `[bp-6]=0x10,dims 0x37`; `0x11/0x39`; `0x12/0x3F`).
- **Placeholder walk-back** (per `SPRITE_CATALOG.md`, pixel-corroborated): the
  `≤2×2` dummy frames **10, 11, 17, 30, 31** are level-fallback markers — when the
  chosen frame is a dummy the renderer decrements to the lower tier's art, then blits.
- National variant: the sprite is modified by the player nation byte (`[0x336]`/`[0x903]`).

## 5. SCENE ZONE — COLONY.PIK + terrain + colonists  (`func_026374 @0x026374`)
- Reads colony `map_x = [bx]` → `[0x17C]`, `map_y = [bx+1]` → `[0x17E]` (`bx=[0x8542]`).
- Scene composite blit `lcall 0x181F:0x510` with the scene-sheet far-ptr `[0x839E..0x83A4]`.
- **COLONY.PIK = a 320×72 ground strip** (grass / building-door slots / water) loaded by
  paint_colony_background; it is the *ground* of the scene zone (NOT a full-screen bg).
- Scene units (worked-tile colonists): sheet `[0x839E]`; per spec §3.8 placed by the
  surrounding-tile geometry.
- **Palette:** the scene runs on the **gameplay palette** (PHYS0/WOODTILE/ICONS/**BUILDING**
  all share it — build-verified: BUILDING.SS is NOISY under VICEROY.PAL, correct under the
  gameplay palette). COLONY.PIK carries its own ≈VICEROY.PAL palette and is composited onto
  the gameplay palette at runtime.

## 6. STOCKPILE bar — `func_0281D6` (recol `func_019622`, byte-detailed)
- bg fill `(0,179,320,21)`; **16 cells**, **pitch 19 (0x13)**, **icon-Y 181 (0xB5)**.
- icon sprite = `good + 0x17` ⇒ **ICONS 23..38** (Food=23 … Muskets=38, NAMES @CARGO order).
- **cell x:** start `x=1`, `x += 19` each cell; **icon centered**: `icon_x = x − (icon_w/2) + 9`
  where `icon_w = ICONS_header[0x152 + i*12]` (recol). number printed = **quantity + 1**.
- selected-good highlight (push 0xE box) + boycott red-X second loop (`[0x907]`/boycott id).
- **gold** readout at `(306,179)` (right-aligned).

## 7. Bottom-band panels
- **Colonist plaza** `func_0270D0`: clear `(0,130,120,48)`; row x-origin **143**, walks
  **left** wrapping at width `0x60=96`; per-colonist sprite from ICONS via skill byte.
- **Surrounding minimap** `func_027DB2`: `(121,130,84,48)`; **6-slot** loop, per-tile
  sprite **ICONS 0x7B=123**, sheet `[0x2DA8]` (NOT a world-map render — surrounding tiles).
- **SoL/cargo/msg** `func_02814C`: `(211,130,91,48)`; mode switch on `[0x337]`/`[0x904]`
  → 3 sub-renderers (Sons-of-Liberty %% bar / ship-in-port / active message).
- **Flag** `func_02853C`: `(303,132,17,45)`; sprite **ICONS 0x44=68** at panel+3,
  frame = nation byte `[0x337]`/`[0x339]`.

## 7b. RTLink `0x191F` thunk resolution (was the blocker — now cracked)

`load_PIK`/`draw_building` go through the **`0x191F`** resident thunk window, which the
project data did NOT resolve (only `0x181F`'s 1023 entries). Resolution:
- `0x191F:X` aliases `0x181F:(X+0x1000)` (segment +0x100 para = +0x1000 bytes).
- For a type-A thunk, `target_file = pages[page_id] + (ljmp_seg<<4) + page_relative_off`,
  where the trailer = `(page_id u16, ljmp_seg u16)` and `pages[]` is the flat-map page table.
- **Verified** on succession: `0x191F:0x364` → page 6 (`0x3B900`) + `0xB2<<4` + `0x218`
  = `0x3C638` = `func_03C638` ✓.

Resolved:
- **`load_PIK` = `0x191F:0x87A` → file `0x76AEC`** — the asset *file* loader (open/read/
  FAB-decompress into a buffer); it does NOT place pixels on screen.
- **`draw_building` = `0x191F:0x66C` → file `0x26DD4`** (page 2 `0x25900` + `0x14D4`).
  It blits the building sprite via `lcall 0x181F:0x254` at **`x=[bp+8]`, `y=[bp+0xa]`
  passed straight through** (= the `0x266` plot `x`, `y+8`) against sheet `[0x2DA8]`,
  with per-building sub-sprite offsets `[type+0x24e/0x254/0x25a]`. The info-mapper is
  the sibling `func_026CC2` (type→frame/dims, `frame=val+0x17`, jump table `cs:[bx+0x1472]`).

**Open tension (the thing to finish):** `draw_building` uses the plot `(x, y+8)` as
ABSOLUTE screen coords, and the `0x266` table y's are 5..98 → screen y 13..106 (upper
area). But COLONY.PIK is at the **bottom** (per ground-truth). So either (a) there is a
colony-view viewport/origin offset applied by the `0x181F:0x254` blit or set globally
that I have not yet pinned, or (b) the colony layout is buildings-upper + a separate
COLONY.PIK strip lower. The COLONY.PIK screen blit itself goes through the offscreen
`[0x839e..0x83a4]` buffer + the resident compositor (`0x181F:0x510` = file `0x531C`, a
two-surface masked copy) — its exact dst-Y is the next thing to pin.

## 4b. BUILDING LIFECYCLE — generation, state, render fill (byte-verified)

The colony view buildings are **upper-left** (plot table `0x266`, x 6..173, y 13..106).
Three pieces feed it:

**(A) Built-state storage — `ColonyRecord +0x84` bitmask (42 bits).**
- `has_building(colony_idx, type)` = **`func_0860E`**: `byte = ColonyRecord[idx*0xCA] +
  0x84 + (type>>3)`, bit `= type&7`; returns that bit. (`0x5DCA = base 0x5D46 + 0x84`.)
- **construction setter** = **`func_092E0(type, flag)`**: `flag≠0` → `[+0x84+(type>>3)]
  |= 1<<(type&7)` (build, the `@0x9308` `or [bx],al`); `flag=0` → clears the bit
  (demolish/capture). So "what happens when a building is built" = this one bit flips on.
- `[0x8DC6]` = the current colony index (set `@0x082E8`), the arg `has_building` passes.

**(B) Building catalogue (42 types) + the 15 on-screen slots.**
- The colony screen shows **15 plots in 5 categories**, counts `DS:0x224 = [7,4,2,1,1]`
  (=15), category type-bases `DS:0x22a = [0,7,11,13,14]` (static data).
- The full **`@BUILDING` def table** is `DS:0x8F86`, stride **12**, 42 entries (loaded from
  NAMES.TXT `@BUILDING`); it carries the **upgrade-chain predecessor** field used to count
  a building's LEVEL (e.g. Stockade→Fort→Fortress).

**(C) Render-table fill — `func_025D34` (every colony-screen paint):**
1. init all 15 slots: LEVEL `0x8E82[slot] = -1` (empty), `0x8E92[slot] = -1`.
2. TYPE table `0x8D62[slot]`: filled from the 5 categories (`0x224`/`0x22a`).
3. LEVEL table `0x8E82[slot]`: for each of the 42 types, if `has_building` (B), walk the
   upgrade chain and store the slot's level. (`func_025C32`, the sibling, separately sorts
   the **colonists** for the plaza row — not buildings.)

**(D) Draw — `func_02701C` loop → `draw_building` (`func_026DD4`):**
for slot 0..14: `x=0x266[slot].x`, `y=0x266[slot].y + 8`, `type=0x8D62[slot]`,
`level=0x8E82[slot]` (skip if `<0`); frame from `(type,level)` via mapper `func_026CC2`;
blit at the absolute `(x,y)` (sheet `[0x2DA8]`). **Upper-left, no extra origin offset.**

**What a colony STARTS with** = the bits set in `+0x84` at founding (the colony-creation
code, separate from the render — the one remaining thing to pin; see §8).

## 5b. UPPER-RIGHT "outside colony" view (surrounding land + workers)

Two sub-renderers compose the upper-right surrounding-land view (the worked tiles):

**Surrounding-tile LAYOUT** — static tables `DS:0xC8` (col offsets) / `DS:0xDE` (row
offsets), 20 entries (signed), the fat-cross around the colony centre:
`(0,-1)N (1,0)E (0,1)S (-1,0)W (-1,-1)NW (1,-1)NE (1,1)SE (-1,1)SW` then the
outer ring (±2). The grid is **centred at screen (252,60)** with **24px** cells:
`screen_x = 252 + 24*col`, `screen_y = 60 + 24*row` (so the 3×3 core spans x 228..300,
y 36..108 — upper-right; centre tile (252,60) = the colony itself).

**(A) Terrain — `func_026374` (composer step 3):** for each surrounding tile it reads
the world tile id (`lcall 0x181F:0x718` at colony_xy + offset), on-map-tests it
(`0x181F:0x302`), and blits the **terrain sprite `frame = id + 0x5a`** at `(252+24*col,
60+24*row)` from sheet `[0x839E]`, clipped by `[0x174]/[0x176]`.

**(B) Workers + production — `func_0264A8` (composer step 6):**
1. composites the surrounding-land strip (`0x181F:0x506`, sheet `[0x2DA8]`), fills the
   panel `(224,32,72,72)`, and draws two divider rules (`0x181F:0xCE`) at **y=104**
   (x 223..) and **y=128** (x 0..320).
2. loops a **per-tile work table `DS:0x8DF0` (stride 5)** indexed `[outer]*5+[inner]`,
   and per worked tile draws: the **worker colonist** (flag bit `0x80` — found by walking
   the units at that map tile, `UnitRecord 0x3146`, stat `0x5236`; blit `0x181F:0x2BC`,
   x+4,y+4); the **commodity icon** produced (`good + 0x17` ⇒ ICONS 23.., flag bit `0x40`);
   an empty/road marker (sprite `0x6D`, sheet `[0x2DA8]`, when unworked); and the
   **production quantity** number (`0x181F:0xB3C`). Centre/expert markers use `[0xA891]/
   [0xA893]/[0xA894]` (`good+0x17`).

So the upper-right = the colony's worked land (terrain under `func_026374`, the
worker+goods overlay under `func_0264A8`), a 3×3(+) grid of 24px tiles centred at (252,60).

## 8. Status — verified vs remaining
- **VERIFIED (byte/static):** DGROUP base; the 15 plot positions (`0x266`); all panel
  rects; stockpile geometry+centering; building loop tables (`0x266`/`0x8D62`/`0x8E82`)
  and the frame-mapper `func_026CC2`; the scene zone `(0,7,320,128)`; palette grouping.
- **NEEDS A FINAL TRACE (do before pixel-perfect):** (a) the per-colony writer that
  fills `0x8D62`/`0x8E82` from the ColonyRecord; (b) the exact COLONY.PIK blit Y inside
  `func_026374` (the scene-sheet `lcall 0x181F:0x510` args); (c) the `func_026CC2`
  jump-table targets `cs:[bx+0x1472]` (per-type frame indices 9..0x11); (d) the
  surrounding-minimap 6-direction tile geometry.
