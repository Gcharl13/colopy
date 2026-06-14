# SCREEN 2 — Nation Picker  (flattened draw program)

- **Composer** `func_07092E` (draw_nation_screen; file 0x07092E, ENTER 0x62,0).
  Loads the backdrop, draws the heading, then loops `func_0707B6` for the four
  nations. **Modal** `func_070A1A` (nation_pick_dispatch, 0x070A1A..0x070C3B):
  2×2 grid nav (mod 4; DOWN=+2 row, RIGHT=+1 col), commits to `[0x5398]`.
- **Port** `src/overlay/overlay_070302_074405.c` (`func_07092E_draw_nation_screen`,
  `func_0707B6_draw_nation_row`, `func_070A1A_nation_pick_dispatch`) — control
  flow BYTE_VERIFIED. The modern shell shortcut `draw_nations()` in
  `src/main_modern.c` is a RECONSTRUCTION (overlays NAMES.TXT names on the PIK at
  reconstructed y's; see Notes) — the byte-true layout is the overlay port below.
- **Asset** `NATIONS.PIK` (320×200 backdrop: four wood-framed flag plaques,
  England/France/Spain/Netherlands; carries its own palette). The flags ARE part
  of the .PIK backdrop — there is no separate flag sprite blit; the painter
  draws only the per-plaque restore, highlight box and label text on top.
- **Active state** `[0x5398]` = current/chosen power index 0..3 (`draw_nation_row`
  only fully paints the row where `idx==[0x5398]`). `[0x268A]` cursor-sprite
  height → panel anchor `y = 0x28 - (h>>1)` (@asm 0x070932).
- **Grid** `func_070782_grid_cell_xy(idx)` — 2-column (@asm 0x07079A..0x0707B0,
  fully byte-verified): `cell_x = (idx%2)*0x63 + 0x70`, `cell_y = (idx/2)*0x5B + 0x0D`.
  → 0:(0x70,0x0D) 1:(0xD3,0x0D) 2:(0x70,0x68) 3:(0xD3,0x68).
- **Names** COUNTRY word-ptr table `[0x8D42 + idx*2]` (@asm 0x07085C `[bx-0x72BE]`,
  0x10000-0x72BE=0x8D42; data_load.c loads it from NAMES.TXT `@COUNTRY`):
  England / France / Spain / Netherlands. Second field `[0x2F14 + idx*2]`
  (@asm 0x0708DF). Banner COLOUR per nation `[0x848 + idx]` = {0x0C,0x09,0x0E,0x0D}
  (the @COUNTRY attr bytes: England 12, France 9, Spain 14, Netherlands 13).
- **Box dims** per plaque: width 0x58(88), height 0x52(82) (@asm 0x070800).

## DRAW PROGRAM (composer order)

```
#   OP          rect / pos             asset/id        color    data            @asm        leaf            status
--- COMPOSER func_07092E (draw_nation_screen) ----------------------------------------------------------------------
N1  PIK_LOAD    (0,0,320,200)          NATIONS.PIK     -        backdrop strip 0  [0x2F0E]   0x181F:0x22    OK   pik_load(NATIONS.PIK) / load_bg
N2  SCENE_FILL  full                    backdrop        -        composite 0      0x070981    0x181F:0x1C8   OK   draw_bg
N3  PIK_LOAD    (0,0,320,200)          NATIONS.PIK     -        backdrop strip 1  [0x2F10]   0x181F:0x22    OK   (2nd strip)
N4  SCENE_FILL  full                    backdrop        -        composite 1      0x0709A4    0x181F:0x1C8   OK
N5  STR/TEXT    heading @ (0x38-w/2, 0xB6)  font[0x89E]  0xFE   MISC[161]=[0x2EFC] "Select a European Power"  0x0709E7  0x181F:0x100  DATA  needs [0x2EFC] handle
N6  PRESENT     band (x=0x70, w=0xC8)   -               -        flush            0x0709FB    0x181F:0xE2    OK
N7  LOOP nation i=0..3 → N8 block (func_0707B6 draw_nation_row)                    0x070A09    call 0x070C5F   OK

--- per-nation block (func_0707B6 draw_nation_row, idx 0..3) --------------------------------------------------------
B0  (range gate 0<=idx<=3 else skip)                                              0x0707BC    -               OK
B1  (cell xy = grid_cell_xy(idx): cx=(idx%2)*0x63+0x70, cy=(idx/2)*0x5B+0x0D)     0x0707CE    0x070782        OK   func_070782_grid_cell_xy
B2  SCENE_FILL  (cx, cy, 0x58, 0x52)    NATIONS.PIK     -        restore plaque cell (id 0x52)  0x07080B  0x181F:0x444  OK  overlay_call_181F_0444
B3  (color = [0x848+idx] = {0xC,9,0xE,0xD})                                       0x070813    -               OK
B4  IF [0x5398]==idx (selected nation) → B5..B12, else skip to B13                0x07081A    -               OK
B5  BOX         (cx+0x57, cy)-(.. , cy+0x51)  -          color    highlight box around plaque  0x070846  0x181F:0xCE   OK   draw_box (hline family)
B6  STR  name = COUNTRY[0x8D42+idx*2], strtoupper, strcat ":"  (DG8(0x2041)=":")  0x07085C    0x181F:0x16E   DATA needs [0x8D42] / NAMES.TXT
      └─ name1 = {ENGLAND:, FRANCE:, SPAIN:, NETHERLANDS:}
B7  TEXT   name shadow @ (cx+0x2C-w/2 +1, cy+2)   font[0x89E]  0       label shadow  0x07089A  0x181F:0x100  DATA
B8  TEXT   name main   @ (cx+0x2C-w/2,    cy+2)   font[0x89E]  color   label         0x0708B7  0x181F:0x100  DATA
B9  STR  name2 = MISC[173+idx] = [0x2F14+idx*2]                                    0x0708DF    0x181F:0x16E   DATA needs [0x2F14]
B10 TEXT   name2 shadow @ (cx+0x2C-w2/2 +1, cy-ctx[0]+0x50)  font  0    2nd-field shadow  0x0708F8  0x181F:0x100  DATA
B11 TEXT   name2 main   @ (cx+0x2C-w2/2,    cy-ctx[0]+0x50)  font  color 2nd field   0x07090E  0x181F:0x100  DATA
B12 (fall through)
B13 PRESENT  band (cx, cy, 0x58, 0x52)  -               -        flush            0x070925    0x181F:0xE2    OK
```

## Implementation status (what renders today)

- **Backdrop + names** render. The 4 flag plaques come straight from
  `NATIONS.PIK` (N1..N4). `draw_nations()` (main_modern.c) overlays the COUNTRY
  names; the byte-true painter highlights only the selected plaque (B4 gate) and
  draws an upper-case `NAME:` label + a second field in the nation's banner
  colour.
- **DATA gaps**: the heading handle `[0x2EFC]` (N5), the COUNTRY name table
  `[0x8D42]` (B6) and the second-field table `[0x2F14]` (B9) must be populated by
  `data_load.c` (`@COUNTRY` → 0x8D42, `@MISC` → 0x2DBA family) and the screen
  must run with `[0x5398]` set for the highlight/labels to appear. Colour bytes
  `[0x848]` are the `@COUNTRY` attrs and load with the names.
- **Highlight box (B5)** maps to the `0x181F:0xCE` hline/box leaf — OK to wire.

## Notes / cites

- The modern shortcut `draw_nations()` (main_modern.c lines 138-155) is a
  RECONSTRUCTION: it draws `"%d  %s"` rows at x=18, y=24+i*44 in a palette-picked
  "light" colour plus a centered `"Select a European Power (1-4)"` at y=184.
  Those x/y are NOT byte-verified — the authoritative geometry is the 2×2 grid
  above (`cell_x=(idx%2)*0x63+0x70`, `cell_y=(idx/2)*0x5B+0x0D`), and the heading
  is the `[0x2EFC]` handle at (centered, y=0xB6).
- `@COUNTRY` (NAMES.TXT): England,12 / France,9 / Spain,14 / Netherlands,13 —
  the name strings AND the banner-colour attr bytes (→ DS:0x848).
- This screen does NOT go through `menu_runner.c`. (A SEPARATE GAME.TXT text menu
  "Select a European Power" with England/France/Spain/Netherlands `@options`
  exists for the keyboard/text path, but the graphical picker is `NATIONS.PIK` +
  func_07092E as flattened here.)
```
