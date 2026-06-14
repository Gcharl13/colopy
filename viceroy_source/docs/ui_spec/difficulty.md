# SCREEN 3 — Difficulty Picker  (flattened draw program)

- **Composer** `func_070494` (draw_difficulty_screen; file 0x070494, ENTER 0x62,0).
  Loads the backdrop, draws the heading, then loops `func_070302` for the five
  levels. **Modal** `func_070580` (difficulty_pick_dispatch, 0x070580..0x070781):
  single-column nav (mod 5; UP=(cur+4)%5, DOWN=(cur+1)%5), commits to `[0x53A6]`.
- **Port** `src/overlay/overlay_070302_074405.c` (`func_070494_draw_difficulty_screen`,
  `func_070302_draw_difficulty_row`, `func_070580_difficulty_pick_dispatch`) —
  control flow BYTE_VERIFIED. The modern shell shortcut `draw_difficulty()` in
  `src/main_modern.c` is a RECONSTRUCTION (only a centered prompt; see Notes).
- **Asset** `DIFFICUL.PIK` (320×200 backdrop: five figure portraits —
  Discoverer / Explorer / Conquistador / Governor / Viceroy; carries its own
  palette). The portraits ARE part of the .PIK backdrop — no separate portrait
  sprite blit; the painter draws only the per-cell restore, highlight box and
  label text on top.
- **Active state** `[0x53A6]` (uint8) = chosen difficulty 0..4 (`draw_difficulty_row`
  only fully paints the row where `idx==[0x53A6]`). `[0x268A]` cursor-sprite
  height → panel anchor `y = 0x14 - (h>>1)` (@asm 0x070498).
- **Grid** cells from `func_0702C0_report_cell_xy_3col(idx)` (the shared report
  grid-cell mapper, file in overlay_06D938_0702D5.c) via trampoline 0x070C46 →
  0x1A1F:0x0B90. Per-cell origin `[recon]` (mapper body not byte-cited here); the
  per-cell BOX/label geometry below IS byte-cited from func_070302.
- **Names** label table `[0x8394 + idx*2]` (@asm 0x0703CD `[bx-0x7C6C]`,
  0x10000-0x7C6C=0x8394): Discoverer / Explorer / Conquistador / Governor /
  Viceroy (GAME.TXT `@DIFFICULTY` @options, lines 172-176). Second field
  `[0x2F04 + idx*2]` (@asm 0x07043D). COLOUR per level (@asm 0x07035C..):
  idx 0→0x0A 1→0x09 2→0x0E 3→0x0D default(4)→0x0C (DOS 16-col: lt-green /
  lt-blue / yellow / lt-magenta / lt-red).
- **Box dims** per portrait cell: width 0x44(68), height 0x5A(90) (@asm 0x07033A).

## DRAW PROGRAM (composer order)

```
#   OP          rect / pos             asset/id        color    data            @asm        leaf            status
--- COMPOSER func_070494 (draw_difficulty_screen) ------------------------------------------------------------------
D1  PIK_LOAD    (0,0,320,200)          DIFFICUL.PIK    -        backdrop strip 0  [0x2EFE]   0x181F:0x22    OK   pik_load(DIFFICUL.PIK) / load_bg
D2  SCENE_FILL  full                    backdrop        -        composite 0      0x0704E8    0x181F:0x1C8   OK   draw_bg
D3  PIK_LOAD    (0,0,320,200)          DIFFICUL.PIK    -        backdrop strip 1  [0x2F00]   0x181F:0x22    OK   (2nd strip)
D4  SCENE_FILL  full                    backdrop        -        composite 1      0x07050B    0x181F:0x1C8   OK
D5  STR/TEXT    heading @ (0x22-w/2+0x17, 0x51)  font[0x89E]  0xFE  MISC[161]=[0x2EFC] "Select a Difficulty Level"  0x07054D  0x181F:0x100  DATA  needs [0x2EFC] handle
D6  PRESENT     band (x=0x80, w=0x67)   -               -        flush            0x070561    0x181F:0xE2    OK
D7  LOOP level i=0..4 → D8 block (func_070302 draw_difficulty_row)                 0x07056F    call 0x070C50   OK

--- per-level block (func_070302 draw_difficulty_row, idx 0..4) -----------------------------------------------------
C0  (cell xy via report 3-col mapper → [bp-0x56]/[bp-0x54])  [recon origin]       0x070314    0x070C46→0B90   OK   func_0702C0_report_cell_xy_3col
C1  SCENE_FILL  (cx, cy, 0x44, 0x5A)    DIFFICUL.PIK    -        restore portrait cell (id 0x5A)  0x070345  0x181F:0x444  OK  overlay_call_181F_0444
C2  (color = switch idx: 0xA/9/0xE/0xD/0xC)                                        0x07034F    -               OK
C3  IF [0x53A6]==idx (selected level) → C4..C11, else skip to C12                 0x070378    -               OK
C4  BOX         (cx+0x43, cy)-(.., cy+0x59)  -          color    highlight box around portrait  0x0703AB  0x181F:0xCE   OK   draw_box (hline family)
C5  STR  name = DIFFICULTY[0x8394+idx*2], strtoupper, strcat ":" (DG8(0x202B)=":") 0x0703CD   0x181F:0x16E   DATA needs [0x8394] / GAME.TXT @DIFFICULTY
      └─ name1 = {DISCOVERER:, EXPLORER:, CONQUISTADOR:, GOVERNOR:, VICEROY:}
C6  TEXT   name shadow @ (cx+0x22-w/2 +1, cy-ctx[0]+0x2C)  font[0x89E]  0    label shadow  0x07040B  0x181F:0x100  DATA
C7  TEXT   name main   @ (cx+0x22-w/2,    cy-ctx[0]+0x2C)  font[0x89E]  color label         0x070428  0x181F:0x100  DATA
C8  STR  name2 = MISC[165+idx] = [0x2F04+idx*2]                                    0x07043D    0x181F:0x16E   DATA needs [0x2F04]
C9  TEXT   name2 shadow @ (cx+0x22-w2/2 +1, cy+0x2E)  font  0     2nd-field shadow  0x07045E  0x181F:0x100  DATA
C10 TEXT   name2 main   @ (cx+0x22-w2/2,    cy+0x2E)  font  color  2nd field        0x070474  0x181F:0x100  DATA
C11 (fall through)
C12 PRESENT  band (cx, cy, 0x44, 0x5A)  -               -        flush            0x07048B    0x181F:0xE2    OK
```

## Implementation status (what renders today)

- **Backdrop** renders. The 5 figure portraits come straight from `DIFFICUL.PIK`
  (D1..D4). The byte-true painter highlights only the selected portrait (C3 gate)
  with a coloured box and draws an upper-case `NAME:` label + a second field in
  that level's DOS palette colour.
- **DATA gaps**: the heading handle `[0x2EFC]` (D5), the difficulty-name table
  `[0x8394]` (C5) and the second-field table `[0x2F04]` (C8) must be populated and
  the screen must run with `[0x53A6]` set for the highlight/labels to appear.
  The 5 names are GAME.TXT `@DIFFICULTY` @options (Discoverer..Viceroy); note
  `data_load.c` currently fills `[0x8394]` from NAMES.TXT `@LEVELS` (tribe levels)
  — that table must instead carry the @DIFFICULTY rows for this screen. (DATA)
- **Highlight box (C4)** maps to the `0x181F:0xCE` hline/box leaf — OK to wire.
- **Per-cell origin (C0)** is `[recon]`: the `func_0702C0` 3-col mapper body lives
  in `overlay_06D938_0702D5.c` and is not byte-cited here; the cell width/height
  (0x44×0x5A) and the box/label offsets ARE byte-cited from func_070302.

## Notes / cites

- The modern shortcut `draw_difficulty()` (main_modern.c lines 157-166) is a thin
  RECONSTRUCTION: it draws ONLY a centered `"Choose Difficulty Level (1-5)"` at
  y=184 over the PIK — no portrait highlight, no per-level label. The
  authoritative layout is the 5 portrait cells + heading `[0x2EFC]` at
  (centered, y=0x51) above.
- GAME.TXT `@DIFFICULTY`: `@width=190`, prompt "Select a Difficulty Level", then
  @options Discoverer / Explorer / Conquistador / Governor / Viceroy (these feed
  the name table the picker reads at `[0x8394]`).
- This screen does NOT go through `menu_runner.c`. (The GAME.TXT `@DIFFICULTY`
  text-menu path exists for the keyboard/text route; the graphical picker is
  `DIFFICUL.PIK` + func_070494 as flattened here.) Selection lands in `[0x53A6]`.
```
