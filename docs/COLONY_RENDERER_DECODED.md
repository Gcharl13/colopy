# COLONY SCREEN RENDERER — Decoded from recol-0.2.0/colonize.exe

**Status**: PRIMARY RENDERER IDENTIFIED. Building loop, stockpile loop, minimap,
title-text, flag, and background loader all located with byte citations.

**Source binary**: `build/recol_extracted/recol-0.2.0/colonize.exe`
(455,137 bytes, MS-C 6.0 large-model, flat-linked — VICEROY's
"overlay 0x191F" is in the main code segment here.)

**Disassembly**: `reverse_engineered/code/COLONIZE/disasm/` (1244 funcs)

**DGROUP base** (recol): `paragraph 0x62F7` → file `0x68F70`. Verified by
matching string `"COLONY"` to file `0x6E879` (DGROUP+0x2909).

**Asset handle globals** (recol DGROUP):
- `PHYS0.SS` → `[0x0B24]` offset / `[0x0B26]` segment (far ptr)
- `ICONS.SS` → `[0x0970]` offset / `[0x0972]` segment
- `BUILDING.SS` → `[0x0974]` offset / `[0x0976]` segment
- Active colony record pointer → **`[0x7338]`** (NEAR, DS-relative; recol
  equivalent of VICEROY's `[0x8542]`). Written once at file `0x2D651`:
  `ADD bx, 0x40B8; MOV [0x7338], bx`.

---

## 1. The full call chain (verified)

```
┌──── func_01D989 = colony_screen_main(colony_ptr)  ─ file 0x1D989, 694 bytes
│     • PUSH [bp+6]; LCALL 0x245F:0x32       ; set active colony
│     • MOV [0x7344], 0                      ; clear some flag
│     • LCALL 0x245F:0x268F → func_02FC7F    ; precompute surrounding tiles
│     • MOV [0x9A4], 1                       ; set screen mode = colony
│     • CALL 0x1731E (thunk → 0x16BFE)       ; some setup
│     • CALL 0x17319 (paint_colony_background → loads "COLONY.PIK")
│     • CALL 0x199D8(1)                      ; paint colony screen
│     • ... event loop entry at 0x1DC8A → CALL 0x1D051
│
├──── paint_colony_background  ─ file 0x1731E (no separate func entry in
│     functions.json; appears right after a 5-byte thunk at 0x17319)
│         PUSH 1, [0xCE90], [0xCE8E], [0xCE8C], [0xCE8A], DGROUP+0x15C4
│         LCALL 0x1A5E:0x08 → func_0235E8 (= load_asset)
│         DGROUP+0x15C4 → file 0x6D534 → string "COLONY" ◄ definitive
│         load_asset internally appends "PIK" (DGROUP+0x18B0 = "PIK")
│         Called from func_01D989:0x1D9CB and func_019A54 redraw wrapper.
│
├──── func_0199D8 = paint_colony_screen(blit_flag)  ─ file 0x199D8 (the
│     PRIMARY PAINT FUNCTION). 8 sub-renderers in fixed order:
│      1. CALL func_01709C  = sort_colonists_for_display
│      2. CALL func_0177DB  = ??? (308 bytes — blit/clip setup)
│      3. CALL func_0177A5(C8, 140, 0, 0) ; full-screen 320×200 fill/setup
│      4. CALL func_017D31(0) = draw_title_text                       (§3)
│      5. CALL func_01790F(0) = draw_mid_band_field_workers           (§4)
│      6. CALL func_018528(0) = draw_colonist_row                     (§5)
│      7. CALL func_019622(0) = draw_stockpile_bar (16 commodities)   (§6)
│      8. CALL func_019984(0,0) = draw_flag_panel                     (§7)
│      9. CALL func_019202(0) = draw_surrounding_tile_minimap (3×3?)  (§8)
│     10. CALL func_019599(0) = draw_sons_of_liberty_panel            (§9)
│     11. CALL func_018475(0) = draw_buildings_loop (15 slots)        (§2)
│     12. if blit_flag != 0: LCALL 0x5CB4:0x3B (full 320×200 blit)
│
├──── func_019A54 = redraw_colony_screen — wrapper that calls
│         CALL 0x1731D + CALL 0x199D8(1)   ; used by event handlers
│
└──── func_01D051 = colony_screen_event_loop  ─ file 0x1D051
          dispatches keystroke/click events, calls func_019A54 to redraw
```

---

## 2. Buildings loop — `func_018475`  (file 0x18475, 179 bytes)

**Loop count = 15** (the 15 building slots on the colony screen).

```c
// pseudo-C
void draw_buildings(int unused_arg) {
    // First fill backdrop area before iterating
    fill_rect_from_colony(199, 0, 0xFFFF, 7, [0xCE82..]);   // top-right
    blit_panel(7, 120, 199, 8, 0, [0xCE82..]);              // some panel

    for (int i = 0; i < 15; i++) {                          // 15 slots
        int x = (&table_8BF)[i*4 + 0];                       // x coord table
        int y = (&table_8C1)[i*4 + 0] + 8;                   // y coord table
        int b_type = ((u8*)0x32D4)[i];                       // building type byte
        int b_lvl  = ((i8*)0x7441)[i];                       // upgrade level (-1=empty)
        int sprite = x;                                      // (alias; see asm)

        if (b_lvl < 0)   draw_empty_lot(b_type, x, y);       // func_01844C
        else             draw_one_building(b_lvl, sprite, x, y); // func_018230
    }
    if (arg6 != 0) /* blit entire screen */;
}
```

**Per-slot tables (DGROUP):**
- `0x08BF` — building (x, y) pair, 4 bytes/slot, 15 entries
- `0x32D4` — building TYPE byte per slot (15 entries)
- `0x7441` — building LEVEL byte per slot (-1 = not built)

**`func_018230 = draw_one_building(level, sprite, x, y)`** at file 0x18230
(192 bytes):
- Reads `[0x903]` (current player nation) → modifies sprite (national variant)
- Switches on `level == 0x0F` (Stockade), `0x11` (Custom House),
  `0x13` (Schoolhouse), `0x14` (College?), `0x30` (special), `0x2F` (Cathedral?)
- PUSHes `[0x976][0x974]` = BUILDING.SS far ptr
- LCALL `0x5D15:0x0E` (blit sprite from sheet)

---

## 3. Title text — `func_017D31`  (file 0x17D31, 482 bytes)

```c
// pseudo-C
void draw_title_text(int unused) {
    bx = [0x7338];                       // active colony struct
    if (bx->byte_1A >= 4) return;        // status check
    if (bx->byte_1A * 0x34[-0x3F49] != 0) return;
    if ([0x910] != 0) return;            // not minimized
    if ([0x9A0] != 0) return;            // not blocked

    char buf[80];
    sprintf(buf, fmt, bx->byte_1B);      // owner / color
    // Build 4-char name fragment (loop CMP [bp-0x54], 4):
    for (int i = 0; i < 4; i++) {
        sprintf(buf + strlen, "%c", bx->name[i]);  // [bx+0x8C+i]
    }
    // Then concatenates colony-info strings:
    //   colony.bx[0x8D] → name char index → string table
    //   colony.bx+1 (year/round?) sprintf
    //   colony.bx[0x1A] → status text
    //   etc. — total of ~7 sprintf invocations to 0x2413:0x138 ("%c")
    //   and 0x2413:0xC (strcat) and 0x2413:0x4D, 0x2413:0xED, 0x2413:0x29F
    // Finally:
    LCALL(0x3E2B, 0x2D0, buf, [bp+6]);   // = func_047580 = print_string
}
```

`func_047580` (file 0x47580) is the **generic text printer** — reads the
active font handle from `[0xC5E2..0xC5E8]`, draws each character via
LCALL `0x5A84:0`. The font (FONTTINY) is selected by some preceding
`set_font(FONTTINY)` call — `fonttiny` string lives at DGROUP+0x1CC1.

---

## 4. Field-worker band — `func_01790F`  (file 0x1790F, 1058 bytes)

The middle band area where workers stand on their tiles (around the
surrounding 8 tiles). Several rect-clears + nested loops over a
24-byte stride per-tile worker table at `0x73B0`.

**Constants found:**
- Rect-clear `(8, 200, 120, 120)` → most of left mid-band
- Rect-clear `(224, 32, 72, 72)` → upper-right mid-band
- Rect `(0, 7, 320, 128)` via LCALL 0x5A84:0 — entire band area
- Rect `(31, 0, 296, ?)` → secondary clear
- ADD ax, `0x17` (=23) — commodity icon sprite base in ICONS.SS
  (matches stockpile)
- TEST al, 0x40 — flag bit for "expert" worker marker

---

## 5. Colonist row — `func_018528`  (file 0x18528, 1276 bytes)

```c
// pseudo-C
void draw_colonist_row(int unused) {
    fill_rect(0, 130, 130, 48);          // clear left mid-band
    bx = [0x7338];
    int n = bx[0x1F];                    // num_colonists
    n += [0x733A];                       // + n_outside?
    int x = 143;                         // initial x
    int max_x = 143;
    while (--n >= 0 && x < 0x60) {       // CMP 0x60? actually different
        u8 type = colonists[i].byte_5;   // skill/type
        int sprite_idx = LCALL(0x245F, 0xDF7, type);  // get colonist sprite
        int width      = LCALL(0x245F, 0xEF5, type);  // get sprite width
        if (special_flag) draw_sprite_with_overlay(...);
        else              draw_sprite(...);                 // LCALL 0x5A84:0
        x += pitch;
    }
}
```

The constants `0x8F` (=143) and `0x60` (=96), pitch math, and the
read of `[bx+0x1F]` confirms this is the "colonists standing in plaza"
loop.

---

## 6. Stockpile bar — `func_019622`  (file 0x19622, 596 bytes) ◄ CRITICAL

**Loop count = 16 commodities** — `CMP word ptr [bp-0x7E], 0x10` at
file 0x1967C. **Pitch = 19 pixels** — `ADD word ptr [bp-0x6E], 0x13`
at file 0x19675. **Sprite base = 23 (ICONS.SS+23)** — `ADD ax, 0x17`
at file 0x1969E. **Y-position = 179** (`0xB3`) for bg fill,
**181** (`0xB5`) for icon base.

```c
// pseudo-C
void draw_stockpile(int unused) {
    // Clear the stockpile bar background:
    fill_rect_from_colony(0x15, 320, 179, 0, [colony_struct]);  // (0,179,320,21)

    int x = 1;                           // starting X for first cell
    int y_icon = 181;                    // icon Y base
    for (int i = 0; i < 16; i++) {       // 16 commodities
        int qty = colony[+0x?? + i*?];   // (read from colony struct)
        sprintf(qtybuf, "%d", qty+1);    // LCALL 0x5F65:0x88A
        draw_text(qtybuf, [colony], i+1, [bp-0x7C], qtybuf, ...);
                                         // LCALL 0x2413:0x28F
        x += 19;
        // ===== draw the icon (centered on x) =====
        int sprite_idx = i + 23;         // ICONS.SS index 23..38
        // Centering: read ICONS header[+0x152+i*12] for width, /2
        cx = read_word(ICONS, 0x152 + i*12); cx >>= 1;
        draw_sprite(ICONS, sprite_idx, x - cx + 9, y_icon, [colony]);
    }
    // Highlight selected commodity (if any) — second loop CMP 0x10:
    for (int i = 0; i < 16; i++) {
        if (i == [0x907])   draw_highlight_box(i);   // PUSH 0xE
        if (i == boycott)   draw_red_X(i);           // ditto
    }
    // Right edge: Gold display at x=0x132 (=306), y=179, w=0xF, [0x349E]
    sprintf gold; draw_text(gold, ..., 306, 179);    // LCALL 0x14C0:0x65F
    if (arg != 0) LCALL 0x5CB4:0x3B;     // blit stockpile band
}
```

**Sprite indices (ICONS.SS) for stockpile commodities** — derived from
`ADD ax, 0x17`:
- Food=23, Sugar=24, Tobacco=25, Cotton=26, Furs=27, Lumber=28, Ore=29,
  Silver=30, Horses=31, Rum=32, Cigars=33, Cloth=34, Coats=35, Trade
  Goods=36, Tools=37, Muskets=38 (per VICEROY ordering).

---

## 7. Flag panel — `func_019984`  (file 0x19984, 84 bytes)

```c
void draw_flag_panel(int arg_w, int arg_b) {
    fill_rect(45, 17, 132, 303);          // (x=303, y=132, w=17, h=45)
    if ([0x910] == 0) {                    // not minimized
        int idx = (arg_b ? [0x906] : [0x904]);
        draw_sprite_thing(0x44, 3, idx);   // SPRITE INDEX 0x44 = 68 (FLAG)
    }
    if (arg_w != 0) blit_rect(0x12F,0x84,0x2D,0x11);  // (303,132,45,17) wait,
                                                       // arg order swapped
}
```

**Player nation flag sprite index = 68 (0x44)** in some sheet
(probably ICONS.SS where flag sprites live). Param "3" looks like
font/style. Read `[0x904]` for normal flag, `[0x906]` for "shield" or
alternate state.

---

## 8. Surrounding-tile minimap — `func_019202`  (file 0x19202, 919 bytes)

```c
void draw_surrounding(int unused) {
    fill_rect(48, 84, 130, 121);           // (x=121, y=130, w=84, h=48)
    if ([0xADB] != 0) {                    // flag-active mode
        draw_complex_overlay(0x39, 0x84, 0x54, 0x79, [0x3310]);
    }
    // ===== 3x3 (or 5x5?) tile grid =====
    // Outer loop: CMP [bp-0x9E], 6
    for (int row = 0; row < 6; row++) {
        // Inner loop limit varies — CMP [bp-..] 4 / 1
        for (int col = 0; col < 4 || col < 1; col++) {
            // Each cell: per-tile pitch IMUL bx, [bp-0x70], 0x1C (=28 per tile)
            // sprite tables at 0x8882, 0x8884, 0x8886, 0x888B, 0x368B (per
            // tile orientation)
            // Final call: LCALL 0x5A84:0 (=blit sprite to clipped region)
        }
    }
    // Per-tile worker overlay loop reads at [bx+0x1C*i+0x82] (worker_type),
    // [bx+0x1C*i+0x80] (job), etc., and conditionally draws
    // commodity icon over the tile.
    // Constants: 0x10 (=16), 0x19 (=25 per-tile pitch?), 0x84 (=132),
    // 0x39 (=57)
    if (arg != 0) blit_rect(48, 84, 121, 130);
}
```

Outer loop 6 + inner loops 4/1 do NOT match a clean 3×3. Could be a
**3-wide × 2-tall pattern iterated with rotations**, or a per-direction
walk (N, NE, E, SE, S, SW = 6 directions; W is skipped because of map
boundary handling). Worth a deeper trace.

---

## 9. Sons of Liberty panel — `func_019599`  (file 0x19599, 82 bytes)

```c
void draw_sol_or_cargo_or_msg(int arg) {
    fill_rect(48, 91, 130, 211);          // (x=211, y=130, w=91, h=48)
    int mode = [0x904];                    // 0/1/2
    switch (mode) {
        case 0: CALL func_018A24(); break;  // Sons of Liberty %
        case 1: CALL func_018B9C(); break;  // ship in port
        case 2: CALL func_019009(); break;  // active message
    }
    if (arg != 0) blit_rect(48, 91, 211, 130);
}
```

The right-of-minimap panel changes based on game state.

---

## 10. Coordinate constants summary (all verified by byte)

| Element | x | y | w | h | Source |
|---------|---|---|---|---|--------|
| Whole screen | 0 | 0 | 320 | 200 | many |
| Top status bar (clear height 7) | 0 | 0 | 320 | 7 | 0x199E8 |
| Mid-band field workers fill | 8 | 200⁂ | 120 | 120 | 0x1792B-3C |
| Mid-band upper-right fill | 224 | 32 | 72 | 72 | 0x17950 |
| Mid-band wide blit | 0 | 7 | 320 | 128 | 0x17970-7E |
| Colonist row clear | 0 | 130 | 130 | 48 | 0x1852C |
| Stockpile bar | 0 | 179 | 320 | 21 | 0x19627-32 |
| Stockpile pitch | – | – | **19** | – | 0x19675 ADD,0x13 |
| Stockpile icon Y | – | 181 | – | – | 0x1963D |
| Stockpile gold X | 306 | 179 | 15 | – | 0x1983D |
| Flag panel | 303 | 132 | 17 | 45 | 0x19988 |
| Surrounding minimap | 121 | 130 | 84 | 48 | 0x19206 |
| Right-of-minimap panel | 211 | 130 | 91 | 48 | 0x1959C |

(⁂ y=200 in fill_rect call is suspicious — likely the arg order is
(h, y, w, x) not (w, h, x, y). Needs verification by examining the
fill_rect callee's prolog.)

---

## 11. Sprite indices used by name

| Sprite kind | Sheet | Index | Source |
|-------------|-------|-------|--------|
| Stockpile commodities | ICONS.SS | 23..38 | `ADD ax, 0x17` @ 0x1969E + 16-loop |
| Mid-band worker icons | ICONS.SS | base 23 + offset | `ADD ax, 0x17` @ 0x179DA |
| Building sprites | BUILDING.SS | per slot/level table | `[0x974][0x976]` handle |
| Player flag | (ICONS?) | 68 (0x44) | `PUSH 0x44` @ 0x199A0 |
| Bell / Cross / Anvil | TBD | TBD | not yet located |
| US flag | TBD | TBD | only generic player flag (0x44) found |
| Crown | TBD | TBD | not yet located |

**The bell/cross/anvil/US-flag/crown sprite indices were NOT
definitively located** in this pass. They live in the sub-renderers
called by `func_019599` (`func_018A24/B9C/9009` — the SoL panel
variants) and the FoundingFather/score area. Tracing those is the
next step.

---

## 12. "Definitely identified" vs "best guess"

### Definitely identified
- **`func_01D989`** = colony_screen_main entry (FAR-callable, 9 callers)
- **`func_0199D8`** = paint_colony_screen primary repaint (5 callers)
- **`func_019A54`** = colony screen redraw wrapper
- **`func_01D051`** = colony screen input/event loop
- **`func_018475`** = building loop (CMP 0xF, calls draw_one_building)
- **`func_018230`** = draw_one_building (uses BUILDING.SS @ [0x974])
- **`func_01844C`** = draw_empty_lot
- **`func_019622`** = stockpile bar loop (16 commodities, pitch 19, Y=179)
- **`func_019202`** = surrounding-tile minimap (region 121,130,84,48)
- **`func_019599`** = SoL/cargo/msg panel (region 211,130,91,48)
- **`func_019984`** = flag panel (region 303,132,17,45, sprite 68)
- **`func_017D31`** = title text builder
- **`func_018528`** = colonist row in plaza
- **`func_01790F`** = mid-band field workers (1058 bytes — biggest)
- **`func_01709C`** = sort_colonists_for_display (called first)
- **`func_023585E8`** = load_asset(name) — appends ".PIK", opens, reads
- **`paint_colony_background` at file 0x17323** calls load_asset("COLONY")
- **`[0x7338]`** = active colony struct pointer (DGROUP near pointer)
- **DGROUP base = 0x62F7 paragraph**
- **Stockpile loop count = 16, pitch = 19, sprite base = 23**
- **Buildings loop count = 15**

### Best guess (needs verification)
- `func_0177DB`, `func_0177A5` = generic fill/blit helpers (called many
  times; arg signatures inferred but not byte-verified)
- `func_018A24`, `func_018B9C`, `func_019009` = SoL panel modes
- Field-worker minimap iterates "6 directions × 4 substeps" rather
  than 3×3 grid — needs trace
- The "0xCE82..0xCE88" 8-byte arg passed everywhere appears to be a
  **clip rectangle** (x, y, w, h) or **drawing context struct**, not
  the colony pointer
- FONTTINY is the title font — assumed by convention; need to find
  the explicit `set_font(FONTTINY)` call before title draw
- The `[0x732D]` colonist data sort key function `0x245F:0xC60` is
  probably `colonist_skill_for_sort`

### Could NOT locate
- **Bell sprite** (Liberty Bell icon) — not in the renderers traced
- **Cross sprite** (church/cross icon) — not located
- **Anvil sprite** — not located (only "expert" markers via TEST al,0x40)
- **US flag** specifically (vs generic player flag 0x44) — not found
- **Crown** sprite — not found
- These are likely in the SoL panel sub-renderers `func_018A24/B9C/9009`
  which were not decoded in detail

### Next step to fully decode
Disassemble and pseudo-C the 3 SoL panel sub-renderers:
- `func_018A24` (file 0x18A24)
- `func_018B9C` (file 0x18B9C)
- `func_019009` (file 0x19009)

These should contain the bell/cross/anvil sprite indices since the SoL
panel shows the Liberty Bell + rebel/tory %% icons.
