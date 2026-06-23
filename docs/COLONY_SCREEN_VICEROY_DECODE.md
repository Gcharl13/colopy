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
| 8 | 0x0285CD | `call 0x2CA19` → `0x191F:0x654` | **func_0281D6** | **STOCKPILE bar** (resolved 2026-06-23) |
| 9 | 0x0285D7 | `call 0x2C9E7` | func_02853C | **flag panel** |
| 10 | 0x0285DF | `call 0x2C9FB` | func_027DB2 | **surrounding-tile minimap** |
| 11 | 0x0285E7 | `call 0x2C983` | func_02814C | **SoL / cargo / msg panel** |
| 12 | 0x0285EF | `call 0x2C97E` | **func_02701C** | **buildings loop (15 slots)** |
| — | 0x028607 | `lcall 0x181F:0xE2` if `[bp+6]≠0` | — | screen-bottom rule |

> **Correction (2026-06-23):** the stockpile bar `func_0281D6` IS composer step 8
> (`call 0x2CA19` → `ljmp 0x191F:0x654` → file `0x0281D6`, verified with
> `tools/follow_thunk.py 0x191f 0x654`; its body fills `(0,179,320,21)` then loops
> 16 cells at pitch 0x13). The earlier "separate per-page sub-renderer, not one of
> the 12 head calls" note was wrong — every one of the 12 head calls is now
> resolved to a named sub-renderer (no remaining TBD). recol equivalent
> `func_019622`.

**All 12 composer steps resolved** (`tools/follow_thunk.py 0x191f <off>`):
`0x6F0→025C32, 0x804→026374, 0x7EC→02633E, 0x840→0268CE, 0x534→0264A8,
0x5C4→0270D0, 0x654→0281D6, 0x5DC→02853C, 0x60C→027DB2, 0x4EC→02814C,
0x4E0→02701C`. There is **no** thirteenth/menu sub-renderer in the composer
(see §9).

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
- **over-capacity warning:** per cell, `0x181F:0xD3A` returns the warehouse cap; if
  `stockpile[i] > cap` the quantity is drawn **red `0x0C`** (else white `0x0F`) — the
  classic "goods will spoil" colour.
- **right-end readout at `(306,179)` — NOT gold (corrected 2026-06-23, user/DOS).**
  End of `func_0281D6` `@0x0283F1`: `push 0x0F` (white), `push 0xB3` (y=179),
  `push 0x132` (x=306), `push [0x2F5E]`, `lcall 0x181F:0x22` (`func_002462` = **fetch
  string #N** from the loaded text heap `[0x2D42:0x2D44]`), `lcall 0x181F:0x13C` (draw).
  So this draws **heap string #`[0x2F5E]`** — a label/caption, **semantic TBD**. The
  earlier "`$%d` gold mirror" reading was an over-read: `0x2F5E` is a string *index*,
  never written as a treasury value anywhere in code (`grep` finds only the two read
  sites, colony + Europe `@0x03125C`; no `mov [0x2F5E]`). **The player gold is NOT shown
  on the warehouse bar** — see §10.

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

## 5c. COLONY.PIK — load + placement (BOTTOM of screen)

**It is at the BOTTOM**, the background of the bottom band (320×72 → y = 200−72 = **128**;
the info panels + stockpile are drawn over it).

Load path (verified):
- Colony-enter stub `@0x25EB6`: `load_PIK("COLONY"=DS:0xBA0, [0x839E], [0x83A0],
  [0x83A2], [0x83A4], flag=1)` → `load_PIK` = `0x191F:0x87A` = file **`0x76AEC`**.
- `load_PIK` opens the file (`0xD1D:0x7E4`), reads the 8-byte header + the FAB pixel
  section (`0x1A1F:0xA94/0xE9E/0xE82`) **directly into the dest far-ptr `[0x83A2]:[0x83A4]`**,
  scanline by scanline, with `[0x839E]` as the x/stride offset (`@0x76C0E` `dx=[bp+8]−
  [bp-0xc]`, `0x181F:0x290`). So the **screen Y is encoded in the dest offset
  `[0x83A2]:[0x83A4]`** (the bottom-band surface), which is set up by the graphics-context
  pipeline *before* the enter stub — the same `[0x839E..0x83A4]` 4-word surface descriptor
  the map renderer fills via `0x181F:0x25E/0x272` (`@0x67E5D/0x67F21`).
- **Not yet pinned to a literal instruction:** the exact set of `[0x83A2]:[0x83A4]` to the
  y=128 screen offset for the colony screen (it's the persistent surface context, not set
  inside the colony enter). The y=128 value follows from the 320×72 size + bottom placement;
  confirming the literal needs either the surface-context setup site or a runtime trace.

### 4d. Frame selection — building type → BUILDING.SS frame (RESOLVED)
`func_026CC2` (the type→frame/dims mapper) resolves the sprite frame:
- type `0x13`/`0x14` → frame `[0xA892]`, dims `0x3F`; type `0x11` → frame `[0x8DD8]`,
  dims `0x1F` (then `−[0xA892]`).
- else: `base = 0x181F:0xACE(type)` = **`byte[type + 0x2ca]`** — a STATIC per-type
  base-frame table at `DS:0x2ca` (file `0x1DC6A`, 42 entries). A jump table
  `cs:[bx+0x1472]` (file `0x26D72`, 9 cases for base 9..0x11) remaps a few:
  base 13→frame 16, base 16→17, base 17→18; all others use `frame=base, dims=base+0x17`.
- LEVEL = `0x181F:0xBAA(type)` walks the upgrade chain (`@BUILDING` predecessor at
  `DS:0x8F88`, stride 12) and counts how many the colony owns → offsets/refines the frame.

**`DS:0x2ca` base-frame table (42 types, grouped in 3 = the 3 upgrade levels/category;
`0xFF` = no BUILDING.SS sprite):**
```
type 0-2 :21   3-5 :15   6-8 :FF   9-11:17  12-14:18  15-20:FF
type 21-23:11  24-26:10  27-29:09  30-31:17 32-34:12  35-36:13  37-38:16  39-41:14
```
The `0xFF` groups (6-8, 15-20) are wall/non-sprite categories. The dummy frames
10/11/17 appearing as bases are the `≤2×2` markers the level walk-back steps past.

## 8. Status — verified vs remaining
- **VERIFIED (byte/static):** DGROUP base; **all 12 composer steps resolved to named
  sub-renderers** (§2, incl. step 8 = stockpile bar and the §9 top-bar/title); the 15
  plot positions (`0x266`); all panel rects; stockpile geometry+centering; building
  loop tables (`0x266`/`0x8D62`/`0x8E82`) and the frame-mapper `func_026CC2`; the scene
  zone `(0,7,320,128)`; palette grouping. The colony screen **has a top menu bar** (§10,
  command table @0x2BDEA) above the composer's title/date strip (§9); **gold renders in
  that menu header** (treasury `PowerRecord+0x2A`), **not** on the warehouse bar.
- **NEEDS A FINAL TRACE (do before pixel-perfect):** (a) the per-colony writer that
  fills `0x8D62`/`0x8E82` from the ColonyRecord; (b) the exact COLONY.PIK blit Y inside
  `func_026374` (the scene-sheet `lcall 0x181F:0x510` args); (c) the `func_026CC2`
  jump-table targets `cs:[bx+0x1472]` (per-type frame indices 9..0x11); (d) the
  surrounding-minimap 6-direction tile geometry.

## 9. Top bar — title / status strip (composer step 5)

> **Correction (2026-06-23).** An earlier revision claimed the colony screen has
> "no menu bar." **That was wrong** — the colony screen DOES have a top **menu bar**
> with dropdown commands (see §10). What follows is the composer's centred title
> line, which is a *separate* element from the menu bar.

The composer's top text is the **title / status line**, composer **step 5**
`func_0268CE @0x0268CE` (trampoline `0x2CAE6` → `0x191F:0x840` → file `0x0268CE`).
It is one centred text line across the full 320-px width near `y≈5`. Byte-confirmed
fields: it ends with the **season** (`word[word[0x538C]*2-0x6800]`, `[0x538C]` = season
counter) + **year** (`[0x538A]`, the game-year global) — i.e. the colony name + date
banner. (`[0x538A]`/`[0x538C]` verified in `spec/systems/turn_dispatch.md`.)

### 9a. Gating (when the strip is drawn)
`func_0268CE` paints only when all three hold (else it jumps to the alt branch at
`0x269F8`):
- controller check `0x268D7`: `[colony+0x1a] < 4`, **or** the AI-personality slot
  `byte[ [colony+0x1a]*0x34 + 0x543F ] == 0`;
- `word[0xB98] == 0` (`0x268EE`);
- `byte[0x828] == 0` (`0x268F8`).
The alt branch (`0x269F8`) builds a shorter string from `colony+2` via
`lcall 0xD1D:0x7E4` (the `sprintf`-family) — the spectator/AI-owned variant.

### 9b. String assembly (into stack buffer `[bp-0x50]`)
Built left→right with the C string library (call counts confirm these are the
shared string primitives, not colony-specific):

**Helper semantics (decoded bodies, so the table is read correctly):**
`0x181F:0x182` (`func_0029DE`) = **append a decimal number** (`itoa` via `0xD1D:0x8FA`
then `strcat`); `0x181F:0x16E` (`func_002992`) = **append a string fetched from a table**
(`lcall 0:0x62`(index) → far ptr, then `%s`); `0x181F:0x1A0` (`func_002A06`) =
zero-padded number; `0x181F:0x178` (`func_0028B0`) = strlen/util (not a paint).

| order | site | call | source | meaning |
|------|------|------|--------|---------|
| 1 | 0x26915 | `0x181F:0x1A0` (zero-pad num) | `byte[colony+0x1b]` | numeric status/prefix, padded to width 8 |
| 2 | 0x26942 (×4) | `0x181F:0x182` (append **number**) | `byte[colony+0x8c .. +0x8f]` | four numeric fields (per-colony bytes — **field identity R**, NOT verified as ASCII name) |
| 2′ | 0x2697A | `0x181F:0x16E` (append **table string**) | `word[ byte[colony+0x8d]*2 - 0x6840 ]` | a string from a per-colony word table, inserted after field 1 |
| 3 | 0x2698C | `0x181F:0x16E` (append table string) | `word[0x2E38]` | appended string by id |
| 4 | 0x269AD | `0x181F:0x722` → `func_005E90(map_x=byte[colony], map_y=byte[colony+1])` | returns a tile attribute byte (−1 if not owned/visible), appended as a **number** | descriptor derived from the colony's map position |
| 5 | 0x269E1 | `0x181F:0x182` (append number) | `byte[ (byte[colony+0x1a]<<4) + si - 0x6790 ]` | nation×index byte |
| 6 | 0x26A28 | `0x181F:0x16E` (append table string) | `word[ word[0x538C]*2 - 0x6800 ]` | appended string by id |
| 7 | 0x26A44 | `0x181F:0x182` | `word[0x538A]` | appended value |
| 8 | 0x26A61 | `0x181F:0x22` → `func_002462([0x93A0])` (fetch table string #N) → `0xD1D:0x11B4` | far ptr | appended string |

### 9c. Final transform + paint
- `0x26A96` `lcall 0x181F:0xB1E` → `func_008862(buf, nation=byte[colony+0x1a])`:
  looks up the nation descriptor (`0x87F4(nation)` → far ptr) and merges it into the
  buffer (`lcall 0x4B:0x1E8`) — the per-nation prefix/colour.
- `0x26AA6` `lcall 0x181F:0xB0` → **`func_00275C(buf, mode=[bp+6])`**, the general
  rich-text painter. The composer passes `mode = 0` (`push 0` at `0x0285B2` before
  `call 0x2CAE6`). `func_00275C` draws inside the text-box globals
  `[0x2CC6]/[0x2CC8]/[0x2CCA]/[0x2CCC]` (the per-screen cursor/clip rect), centred —
  the exact top-band origin is **runtime state** (set by the composer's
  `0x181F:0xC22` context init), not a static literal, so the `y≈5` here is **R**
  (geometry/recol), the string sources above are **B**.

**Net:** the composer's top line = a centred banner — colony name + **season + year**
(byte-confirmed) — assembled by `func_0268CE`. This is the *title*, distinct from the
menu bar (§10).

**Honest limit on the literal words.** The *mechanism* and *which fields feed it* are
byte-traced (**B**), but the **literal rendered sentence is not statically reproducible**:
the `0x16E`/`0x22` appends pull from the runtime-loaded string heap (`[0x2D42:0x2D44]`,
`[0x93A0]`, the `-0x6840`/`-0x6800` per-colony word tables) and several inputs are live
colony fields. So the rendered string is **TBD/R** until a string-section dump + a live
field snapshot (or a runtime trace at `0x026AA6`) is taken. Do **not** invent the wording.

## 10. Top MENU BAR + gold (corrected 2026-06-23)

The colony screen **has a top menu bar** with dropdown commands — byte-confirmed in the
colony page handler:
- **command dispatch** `@0x02BDEA+`: `cmp [bp+6], 0x13C … 0x142`, each firing a handler
  `lcall 0x191F:0x40C / 0x3FE / 0x3F0 / 0x3E2 / 0x3D4 / 0x3C6 …` (menu-item commands).
- **menu registration** `@0x02BE00+`: a run of `lcall 0x191F:0x3xx` (the same `0x3FE`
  BEGINMENU-runner family the map menu uses, `spec/ui/menus.md`).

**Gold is shown in this top header — NOT on the warehouse bar** (user/DOS,
authoritative per `TRUTH_HIERARCHY`). The player treasury is **`PowerRecord+0x2A`** via
`[0x84FC]` (`g_current_power_ptr`) — **BYTE_VERIFIED** in `docs/DATA_MODEL.md` (write-back
updates the UI immediately; matched the user's on-screen 3552/4032). A displayed mirror
lives at **DGROUP `+0x9CB0`** (u32), recomputed in the colony page `@0x02B80E`
(`mov [0x9CB0],ax` / `[0x9CB2],dx`).

**Header label source — `Gold:` from `@CTITLE` (LABELS, byte-verified).** `@CTITLE` is
the colony-screen label *pool* (`"Pop:\nGold:\nBUY\nCHANGE\n…\nTax:"`); **only `Gold:`
(idx 1) belongs to the top header.** `Pop:` (idx 0) and `Tax:` (idx 9) are drawn **elsewhere**
on the colony screen (NOT in the top menu — user/DOS, 2026-06-23) — do not place them in the
header. Gold value = treasury `PowerRecord+0x2A`. The other header element is the
composer-step-5 banner (§9): colony **name + season** (`@SEASONS = Spring\nAutumn`,
`[0x538C]`) **+ year** (`[0x538A]`).

**Example top line** (gold + date **B**; exact order/spacing **R** — no Pop/Tax here):
> `Jamestown   Spring 1612        Gold: 1240`

**Still TBD:** the exact x/y/font of the header gold blit (the menu chrome reads `[0x9CD2]`
at runtime; the literal draw site in the menu renderer is the next trace target). The
`(306,179)` `[0x2F5E]` readout on the warehouse bar is a heap caption, **not** gold (§6).
