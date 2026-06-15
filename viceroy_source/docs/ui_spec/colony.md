# SCREEN 5 — Colony Interior  (flattened draw program)

- **Entry** `func_025EB6`: `PIK_LOAD COLONY.PIK (id 0x0BA0)` → `enter_screen_view(0x2C)`.
- **Composer** `func_028592` (screen-id 0x2C). Calls 11 sub-painters in fixed order.
- **Assets** `COLONY.PIK` (320×72 bottom-bar backdrop, master palette) · `BUILDING.SS`
  (48 frames) · `ICONS.SS` (commodity + UI icons) · `FONTTINY.FF`.
- **Active record** `ColonyRecord` at `*[0x8542]` (idx `[0x8DC6]`, stride 0xCA):
  `+0`/`+1` map x/y · `+0x1A` status (≥4 hides) · `+0x1B` owner/color · `+0x1F`
  population · `+0x70..` 20 tile-state (assigned colonist per tile) · `+0x84` 6-byte
  **building bit-array** · `+0x95/+0x96` food/horse stock · `+0x9A+i*2` 16 stockpile.
- **Screen state** `[0x336]` sel sub-idx · `[0x337]` right-panel mode (0 SoL/1 ship/2 msg)
  · `[0x339]` alt flag nation · `[0x33A]` hilite good · `[0x33C]` minimap gate ·
  `[0xB98]` minimized · `[0x2F5E]` gold · `[0x538A]` year · `[0x538C]` season ·
  `[0x835]` plot fill color.

## PRECONDITION — layout build (`func_025D34`, on colony enter, NOT per-frame)

Fills the per-slot tables the BUILDINGS painter reads. See
`docs/COLONY_BUILDING_MODEL.md`. Inputs: `+0x84` bits via `q9fc`, config
`0x8F87`(category)/`0x8F88`(column). Outputs: `0x8D62[slot]`=category,
`0x8E82[slot]`=building index (−1 empty), `0x8E92`=claim shuffle. **STATUS: DONE.**

## DRAW PROGRAM (composer order)

```
#   OP          rect / pos             asset/id        color    data            @asm        status
--- COMPOSER func_028592 -------------------------------------------------------------------------
C1  CTX_BEGIN   -                       -               -        grab draw ctx   0x028595    OK
C2  (setup A)   -                       -               -        colonist resort 0x02859B    OK (func_025C32)
C3  (setup B)   -                       -               -        see SCENE block 0x02859F    partial (func_026374)
C4  SCENE_FILL  (0,0,320,200)           backdrop        -        -               0x0285A2    TODO  cc_fill_444
C5  →TITLE      (block T)               -               -        -               0x0285B4
C6  →WORKGRID   (block W)               -               -        -               0x0285BC
C7  →COLROW     (block R)               -               -        -               0x0285C4
C8  →STOCKPILE  (block S)               -               -        -               0x0285CC
C9  →FLAG       (block F)               -               -        -               0x0285D6
C10 →MINIMAP    (block M)               -               -        -               0x0285DE
C11 →SOLPANEL   (block P)               -               -        -               0x0285E6
C12 →BUILDINGS  (block B)               -               -        -               0x0285EE
C13 PRESENT     (0,0,320,200)           -               -        if repaint      0x0285F4    OK

--- SCENE block (func_026374): surrounding-tile precompute + scene fill ---------------------------
S1  STORE       -                       -               -        [0x17C]=col.x [0x17E]=col.y  0x026379  OK
S2  FILL        (0,8,80,80)             -               -        scene block     0x0263A9    TODO (texture)
S3  LOOP n=[..0x329]  for each adjacent colony: SPRITE its tile marker @ derived (x,y)  0x0263F6  DATA

--- TITLE block (func_0268CE) → "<Name>, <Season> <Year>, Gold: <N>" ------------------------------
T0  IF status≥4 OR [0xB98]≠0 OR [0x828]≠0 → skip whole block                     0x0268D7    OK
T1  STR  start buffer with owner/color char [rec+0x1B]                           0x026915    TODO str-leaf
T2  STR  append colony NAME (rec+2, 16 bytes) + ", "                             0x026930+   TODO
T3  STR  append SEASON word [tbl 0x9800+[0x538C]*2] + " "                        0x026965    TODO
T4  STR  append YEAR number [0x538A]                                             0x026a44    TODO
T5  STR  append ", Gold: " + treasury [0x2F5E] (num_to_str 0x22)                 0x026a61    TODO
T6  TEXT  draw assembled string  (printer 0x181F:0xB0, param [bp+6])  green      0x026aa6    TODO  port func_0268CE
    └─ position: the printer centers in the top band (y≈1); color = UI green #528A31.

--- WORKGRID block (func_0264A8): 3×3 surrounding work tiles, upper-right ------------------------
W1  FILL   (200,8,120,120)              -               [0x835]  map backdrop    0x0264E1    OK texture_fill_rect
W2  FILL   (224,32,72,72)               -               -        grid band       0x0264E9    OK
W3  BOX    (199,7)-(320,128)            -               0        outer frame     0x026517    OK draw_box
W4  BOX    (223,31)-(296,104)           -               0        inner frame     0x026539    OK
W5  LOOP r=1..3, col=1..3  (inner 3×3; edge ring skipped):  cell_x=col*24+200, cell_y=r*24+8
      flags = [0x8DF0 + col*5 + r]
      IF flags&0x40: BOX cell (24×24) color 0xC                                  0x026584    OK
      IF flags==0 && [0x8D9E+col*5+r]≥0: SPRITE ICONS id 0x6D @ (cell_x+8,cell_y+4)  0x0265BF OK
      IF flags&0x80 (colonist): world=(col.x+col-2,col.y+r-2); FIGURE the working unit  0x026639 DATA
      IF flags&8 (resource): ICON_RUN bonus markers id 0x17 + [0xA891/3/4]       0x02665D    OK
      good = 0xCE0(col,r); amount = 0xB3C(col,r,&good_idx,1); good_spr=good_idx+0x17 (0x3A if 0xC0E==8)
      IF amount>0: ICON_RUN good_spr × amount @ cell                             0x026700    DATA draw_icon_run
      ELSE IF good_idx≥0: SPRITE good_spr centered + SPRITE id 0x41 @ cell       0x026758    DATA
      IF good_idx≥0: SPRITE_SH worker-pip func_0091CC(good) @ (cell_x+12,cell_y+6) 0x02677C  DATA
      IF not minimized: hilite selected good [0x8D7C] (BOX 0xA) + cursor cell    0x026810    OK
    FIXED 2026-06-14: 0xCE0 now called (col,r) / cursor ([0x330],[0x332]) — was the arg crash.
    FIXED 2026-06-15: 0xB3C unworked-case ported (colony_cell_production): good_idx defaults to
      −1 for cells whose 0x8DF0 flags lack the colonist bit, so the good_idx≥0 paths (goods
      icon + func_0091CC worker pip) correctly skip — that fault is gone.
    STILL BLOCKED (needs a real colony): the work-grid is NOT wired into the headless test frame
      because the SCENE PRECOMPUTE — func_025C32 (setup A) + func_026374 (setup B), which fill the
      surrounding-tile tables 0x8DF0 (per-cell flags) / 0x8D9E (per-cell tile id) and the data
      0xCE0 reads — is NOT YET PORTED. Without it 0xCE0(col,r) returns garbage, so cellgood is
      undefined and func_0090C8(cellgood) at @asm 0x0266C1 (called every cell, before the good_idx
      gate) reads out of range. Porting func_026374 (the 3×3 ring precompute) is the remaining
      unblock; the per-cell goods/amount still also need a real colony's colonist→tile data.

--- COLROW block (func_0270D0): colonist portrait row (mid-band) ----------------------------------
R1  FILL   (0,130,120,48)               -               -        band            0x0270D6    DATA
R2  LOOP i=0..pop-1: FIGURE colonist[i] portrait @ (i*step, y) + profession icon  -          DATA  needs colonists

--- STOCKPILE block (func_0281D6): 16-good bar across the bottom ----------------------------------
P1  FILL   (0,179,320,21)               -               -        bar bg          0x0281DB    OK (TODO texture)
P2  LOOP i=0..15: x=1+i*19, y=181
      SPRITE ICONS id (i+0x17) centered (half-w = ICONS.hdr[i].w>>1, +9)         0x028270    OK
      STR/TEXT quantity = rec[+0x9A+i*2]   (drawn under icon)                    0x028288    DATA
P3  LOOP i=0..15: IF i==[0x33A]: BOX highlight color 0x0E                        0x0283BB    OK
P4  TEXT   gold [0x2F5E] @ (306,179) w15                                         0x0283F9    OK num_to_str
P5  PRESENT (0,179,320,21) if repaint                                            0x028415    OK

--- FLAG block (func_02853C): nation flag panel, right edge --------------------------------------
F1  FILL   (303,132,17,45)              -               -        panel           0x02853C    OK
F2  IF not minimized: SPRITE flag id 0x44 (68), style 3, nation=[0x339]/[0x337]  0x02856F    OK
F3  PRESENT (303,132,17,45) if repaint                                           0x02857B    OK

--- MINIMAP block (func_027DB2): surrounding-tile minimap -----------------------------------------
M1  FILL   (121,130,84,48)              -               -        region          0x027DB7    OK
M2  IF [0x33C]==0: PANEL (121,132,84,57) bg=[0x2DD0]                             0x027DCE    OK blit_box_id
M3  LOOP tile=0..5: SPRITE terrain + worker overlay per direction                0x027DF7    DATA
--- SOLPANEL block (func_02814C): SoL% / ship / message, right of minimap ------------------------
P0  FILL   (211,130,91,48)              -               -        region          0x02814F    OK
P1  SWITCH [0x337]: 0→SoL% bars  1→ship-in-port  2→active message                0x02815F    DATA
P2  PRESENT (211,130,91,48) if repaint                                           0x028188    OK

--- BUILDINGS block (func_02701C): the 15-slot building plot --------------------------------------
B1  BOX    (0,7)-(199,?)                -               0xFFFF   top frame       0x02703F    OK draw_box
B2  FILL   (0,8,199,120)                -               7        plot backdrop   0x02705F    TODO 0x4FC framed
B3  LOOP slot=0..14:  x=[0x266+slot*4], y=[0x268+slot*4]+8
      type=[0x8D62+slot], level=[0x8E82+slot]
      IF level<0: (empty lot — draw nothing / lot marker via 0x7EF1)             0x027072    OK
      ELSE: SPRITE BUILDING.SS frame=level (1-based level+1 in DOS; 0-based=level)  0x026E4E  OK
            └─ wall special: level 0/0xF/0x11 → frames 0x11/0x2F/0x30 via q9fc gates
            └─ then SPRITE produced-good marker via per-type tables [0x24E/0x254/0x25A]
B4  PRESENT (0,8,199,?) if repaint                                               0x0270C8    OK
```

## Implementation status (what renders today)

- **BOTTOM-BAR backdrop** — DONE: the real `COLONY.PIK` (320×72) asset blitted at
  its documented position (bottom-aligned, y=128); the stockpile/minimap/SoL panels
  draw on top of it.
- **BUILDINGS (block B, slots)** — DONE: real `0x8E82` levels → `ss_blit_remap`.
- **STOCKPILE icons, FLAG, MINIMAP frame, SoL/ workgrid frames** — OK leaves, call them.
- **SCENE_FILL (C4), plot backdrop (B2), workgrid backdrop (W1)** — DONE 2026-06-15:
  the `0x93F0` texture block the fill leaves (`0x444`/`0x4FC`/`0x506`) tile is the
  **PARCH.SS** (sandy plot, master indices 98..110) / **WOODTILE.SS** (woodgrain
  frame, indices 130..140) 32×24 weave — both ship as standalone assets, so no DOS
  far-memory decode is needed.  `tile_texture()` (render_glue.c) tiles them with the
  phase anchored at screen (0,0), exactly the DOS strip copier.  C4=WOODTILE full
  screen, B2=PARCH `(0,8,199,120)`, W1=WOODTILE via `texture_fill_rect`.  Verified
  pixel-for-pixel against `refs/ref_colony_interior.png` (header band, sandy plot,
  work-grid frame).
- **TITLE (block T)** — needs `func_0268CE` ported (the STR leaves + printer 0xB0).
- **WORKGRID per-cell, COLROW, SoL contents, MINIMAP tiles** — **DATA**: need a real
  colony's colonist→tile assignments (`+0x70`, `0x8DF0`); fix the `0xCE0(col,r)` arg bug.

## Required fixes (from the program, not from re-tracing asm)

1. ~~Wire `fill_rect`→`cc_fill_444` + plot fill `0x4FC` so C4/B2/W1 backdrops are
   real.~~ — DONE 2026-06-15.  The `0x93F0` weave == PARCH.SS / WOODTILE.SS; tiled
   via `tile_texture()`.  Plot/frame/header now render sandy+woodgrain.
2. Port `func_0268CE` (block T) — assemble name/season/year/gold via the STR leaves.
3. ~~Pass `(col,r)` to `0x181F:0xCE0` in WORKGRID (W5)~~ — DONE 2026-06-14. The
   work-grid still faults: next port `0x181F:0xB3C` to return `good_idx=−1` for
   unworked tiles (the stub returns 0, tripping the `good_idx≥0` gate).
4. Drive from a real colony (colonists + tile assignments) for blocks W/R/M/P contents.
