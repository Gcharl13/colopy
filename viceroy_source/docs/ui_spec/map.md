# SCREEN 4 — Map / Main Game View  (flattened draw program)

- **Composer** `func_067644` (file 0x067644, ENTER 2; the in-game map frame
  redraw). Far-called with a 4-word view rect by-ref `[bp+6..+0xC]`
  (col,row,w,h). Calls the geometry setup, the tile walk, then 4 overlay passes
  in fixed order, then 2 gated passes. No PIK backdrop — the terrain VIEWPORT IS
  the background (x=0..239); the wood sidebar + top menubar are chrome on top.
- **Three regions**: (1) terrain VIEWPORT x=0..239 (15×12 tiles @16px, y=8..199);
  (2) TOP MENU BAR y≈0..8 (wood strip, green MENU.TXT labels); (3) RIGHT SIDEBAR
  x≥240 (wood: minimap panel → date/gold/tax → active-unit info panel).
- **Assets** `TERRAIN.SS` (terrain tiles, O514/O513 chain) · `PHYS0.SS`
  (feature/road overlays) · `ICONS.SS` (unit map glyphs, owner boxes) ·
  `WOODTILE.SS` (sidebar + menubar planks, sheet slot 5) · `FONTSMAL`/resident
  font `[0x89E]` (text). The sheet's palette is VICEROY.PAL (master).
- **Geometry globals** (all written by `render_frame_setup` func_06787C @0x6787C):
  zoom `[0x184]` · centre tile `[0x17C]`/`[0x17E]` · span_cols `[0x8544]`=0xF<<z ·
  span_rows `[0x8546]`=0xC<<z · tile_px `[0x8326]`=`[0x5AD4]`=0x10>>z · origin
  `[0x8328]`col/`[0x832E]`row (clamped [1..dim-span-1]) · pixbase `[0x832A]`/
  `[0x832C]` · max `[0x8804]`/`[0x8806]` · map dims `[0x853A]`w/`[0x853C]`h ·
  reveal-all `[0x53A2]` · fog layer `[0x5396]` (or 0xFFFF when revealed).
- **Per-tile pixel origin** (O514): `sx=([0x832A]+relcol)*[0x5AD4]+[0x5AD4]/2`,
  `sy=([0x832C]+relrow+1)*[0x8326]-1` (the +8 menu offset is applied in the unit
  pass, sy+8 @0x67433; tiles sit under the strip natively).
- **Sidebar/status data**: minimap origin world col/row `[0x9CCC]`/`[0x9CCA]` ·
  cursor tile `[0x8540]`x/`[0x853E]`y · season word table `[0x9800+[0x538C]*2]` ·
  year `[0x538A]` · PowerRecord base `0x8808` stride 0x13C (gold +0x2A dword, tax
  +0x01 byte) · view nation `[0x5396]` · cur nation `[0x5398]`.

## PRECONDITION — frame geometry build (`render_frame_setup` func_06787C, per-frame)

Runs first inside the tile walk (O514 calls it via thunk 0x191F:0x18E). From
centre `[0x17C]`/`[0x17E]` + zoom `[0x184]` it writes span/origin/tile_px/max and
the layer-window stride `[0x8548]`. At zoom 0: span=15×12, tile_px=16 → 240×192.
**STATUS: OK** (ported in `src/render/tile_chain.c` render_frame_setup).

## DRAW PROGRAM (composer `func_067644` order)

```
#   OP          rect / pos             asset/id        color    data source           @asm        leaf            status
--- COMPOSER func_067644 (view rect [bp+6..+0xC] = col,row,w,h) ------------------------------------------------------
C1  (geom)      -                       -               -        setup rect by-ref     0x06765C    1A1F:0x914      OK   render_frame_setup
C2  →VIEWPORT   (0,8,240,192)           TERRAIN.SS/PHYS0 -       tile walk (block V)   0x067681    1A1F:0x968      OK   map_view_render(O514)
C3  →SETTLE     (block N: settlements)  ICONS.SS        -        native settlements    0x067686    191F:0x888      DATA overlay_pass_settlements
C4  →COLONY     (block C: colonies)     ICONS.SS        -        colony markers        0x06768B    191F:0x896      DATA overlay_pass_colonies
C5  →UNITPASS1  (view rect)             -               -        pre-unit sweep        0x06769C    181F:0x32C      DATA (func over rect)
C6  →UNITS      (block U: own units)    ICONS.SS        -        unit sprites          0x0676B0    181F:0x344      DATA overlay_pass_units
C7  →OVL_E38    (view rect + si,reveal) -               -        extra overlay (si)    0x0676DB    181F:0xE38      TODO (7-arg pass; unported)
C8  IF si≠0 →   (view rect)             -               -        gated post-pass       0x0676F5    1A1F:0x8F8      TODO (gated on [bp-2]=si)
    └─ NOTE: si=[bp+0xE]; reveal token = (([0x53A2]≠0)?0xFFFF:[0x5396]) pushed @C2/C8.
    └─ NOTE: composer draws NO menubar/minimap/status — those are SEPARATE entries
       (the in-game dispatch calls func_066CD6 + tile_info_panel + the menubar
       finalize after this composer; flattened as blocks M / I / B below).

--- VIEWPORT block V (map_view_render func_O514 @0x685DC -> O513 @0x681A8) ------------------------------------------
V0  (fog)       -                       -               -        [0xA89E]=1<<(L+4)|0   0x685E9     -              OK   fog mask set
V1  (setup)     -                       -               -        render_frame_setup    0x68603     191F:0x18E     OK   (see PRECONDITION)
V2  IF origin>max → skip (empty window) -               -        [0x8804]/[0x8806]     0x6860A     -              OK
V3  LOOP row=origin_row..max_row, col=origin_col..max_col:                            0x68758     -              OK
      sy=([0x832C]+relrow+1)*[0x8326]-1                                               0x68720     -              OK   [0xA5A6]
      sx=([0x832A]+relcol)*[0x5AD4]+[0x5AD4]/2                                        0x6875F     -              OK   [0xA5A4]
      commit 3 layer ptrs [0xA594/8/C] (relrow+1)*[0x8548]+relcol+1                   0x68852     -              OK   wp_commit
      active_cell = subcell_priority (cursor hilite gate)                             0x687BC     181F:0x6C8     OK
      → O513 per-tile emitter:                                                        0x687D1     (near O513)    OK   tile_dispatch
        SPRITE terrain base frame @ (sx,sy)        TERRAIN.SS   -   layer-A cell      0x67E28     181F:0x254     OK   emit_sprite_layerA (clipped RLE blit)
        SPRITE feature/road overlays @ (sx,sy)     PHYS0.SS     -   layer-B cell      0x67EEC     181F:0x254     OK   emit_sprite_layerB
        SPRITE alt/sub-cell composer (O512)        TERRAIN.SS   -   sub-cell          0x67E8C     1A1F:(alt)     OK   emit_sprite_alt
        IF cursor cell: draw_tile_marker (hilite)  -            -   active_cell       0x67DC8     (marker)       OK   func_067DC8
    NOTE: pixel format = direct mode-13h palette index (no remap); control bytes
          0xFF end-row / 0xFE run / 0xFD transparent. Sprite selection byte-verified.

--- SETTLE block N (overlay_pass_settlements = 191F:0x888; func_067082) -------------------------------------------
N1  LOOP i over settlement list, gate world (x,y) in [origin..origin+span-1]          0x670EE     -              DATA
      IF tile not visible && [0x53A2]==0: skip                                        0x6710A     -              DATA
      sx=(x-[0x8328]+[0x832A])*[0x5AD4]; sy=(y-[0x832E]+[0x832C])*[0x8326]            0x6712A     -              DATA
      SPRITE settlement glyph @ (sx,sy)            ICONS.SS     owner  logic 0x2B2    0x67151     003E40:0x2B2   DATA needs native settlements

--- COLONY block C (overlay_pass_colonies = 191F:0x896; func_067182) ----------------------------------------------
C1c LOOP i over colony records, same view-rect gate + visibility gate                 0x67182     -              DATA
      sx/sy as N1; SPRITE colony marker @ (sx,sy)  ICONS.SS     owner  colony pass    0x67182     191F:0x896     DATA needs colony records

--- UNITS block U (overlay_pass_units = 181F:0x344; func_06753C / func_0673CC) ------------------------------------
U1  LOOP i=0..[0x539C]-1: gate world (ux,uy) in view rect                             0x67560     -              DATA
      IF unit state [0x3144+i*0x1C+0x18] >= 0 (not on-map head): skip                 0x67591     -              DATA
      flags = 0x80 | (mode≠1?0x40:0) | (owner≠[0x5396]?0x20:0)                        0x6740E     -              DATA
      sx=(UREC.x-[0x8328]+[0x832A])*[0x5AD4]; sy=(UREC.y-[0x832E]+[0x832C])*[0x8326]+8 0x6741E     -              DATA  (+8 menu offset)
      FIGURE unit map sprite centered @ (sx+8,sy+7) metric [0x186]                    0x67433     (vid_cell_blit) DATA unit_render_386A
      SPRITE owner color box 2×2 @ pri pos (ship +1,+1 / land +5,+5) col [0x848+owner] 0x3BCF     0xB9E:0xA      DATA
      IF fortified/native: TEXT strength/tribe badge @ (sx+11,sy+3)                   0x3A8C     vid_text_xy    DATA needs live units

--- TOP MENU BAR block B (data: build_menubar func_072090; render: page-02 finalize) -----------------------------
B0  FILL    (0,0,320,8)                  WOODTILE.SS     -        wood strip bg         [recon]     ui_wood_fill   OK   (modern; native fills via menubar bg)
    --- menu DATA built by func_072090 (labels = MENU.TXT @-section keys) ---
B1  (create) menubar container                          -        cap 0xFA0,[0x89E/A0]  0x0720A4    1A1F:0x2D2     DATA menubar_create
B2  STR/TITLE col0 "GAME"   key 0x2098 (~GAME) + sub 0x209D (~menu)                    0x0720C4    191F:0x928     DATA menu_add
B3  STR/TITLE col1 "VIEW"   key 0x20A6 (~VIEW)                                         0x072236    191F:0x928     DATA
B4  STR/TITLE col2 "ORDERS" key 0x20AF (~ORDERS)                                       0x072408    191F:0x928     DATA
B5  STR/TITLE col3 "REPORTS" key 0x20BA (~REPORTS)                                     0x0726C8    191F:0x928     DATA
B6  STR/TITLE col4 "TRADE"  key 0x20C5 (~TRADE)                                        0x07284C    191F:0x928     DATA
B7  STR/TITLE col5 "CHEAT"  key 0x20CB (~CHEAT) — gated test byte[0x5383]&0x20         0x0728CB    191F:0x45C     DATA (cheat-only)
B8  STR/TITLE col6 "COLONIZOPEDIA" key 0x20D3 (~PEDIA)                                 0x072AA5    191F:0x928     DATA
B9  (rows)  each column: TITLE via menu_set_title 1A1F:0x31A; rows via 1A1F:0x33E      0x07286D    1A1F:0x31A/33E DATA  (per-item labels from MENU.TXT)
B10 PRESENT menubar (finalize/render the built bar)     WOODTILE.SS  green  green text 0x072B8F    191F:0xFB8     TODO page-02 menubar render unported
    └─ TEXT labels green #528A31 on WOODTILE; native finalize positions them.
    └─ [recon] modern shortcut (main_modern.c draw_map): ui_wood_fill(0,0,320,9)
       + vid_text_xy green at x: GAME 11, VIEW 48, ORDERS 80, REPORTS 120, TRADE 158,
       COLONIZOPEDIA 256, y=1. GROUNDTRUTH measured x: GAME 11, VIEW 45, ORDERS 77,
       REPORTS 109, TRADE 146, COLONIZOPEDIA 261 (use these for pixel-match).

--- SIDEBAR background (x>=240) ------------------------------------------------------------------------------------
SB0 FILL    (240,0,80,200)               WOODTILE.SS     -        wood backdrop         [recon]     ui_wood_fill   OK   (modern draw_map; native left it black before)

--- MINIMAP block M (func_066CD6_minimap_panel @0x066CD6; called after composer) ----------------------------------
M0  (prep)  latch palette                                -       near 0x772            0x066CDA    181F:0x59A     OK   func_066BB0_prep
M1  IF [0x82C]==0: BOX panel frame (241,8,79,41)         -        0/0x29 (push)        0x066CF4    181F:0xBA      OK   vid_box_fill(0xF1,8,0x4F,0x29)
M1b ELSE: textured panel frame (241,8,79,41) via overlay rec [0x82C]+0..6             0x066D34    181F:0xC4      OK   (alt path)
M2  BOX     inner strip (251,8,48,6)     -               0x0F     bevel                0x066D4B    181F:0xCE      OK   vid_box_outline(0xFB,8,0x30,6)
M3  (content) minimap pixel block, anchor px (252,9) = world - [0x9CCC]/[0x9CCA]+(0xFC,9) 0x066D61  1A1F:0x8CE    DATA minimap_draw_contents
      clip window [row0..row0+0x26]×[col0..col0+0x37]; bg fill 0x27×0x38 @ origin      0x066B9E    1A1F:0x896     DATA func_066B96_minimap_fill
M4  BOX     "you are here" viewport rect @ (vx,vy) w=[0x8544] h=[0x8546]               0x066DC9    181F:0xCE      OK   vx=[0x8328]-col0+0xFC, vy=[0x832E]-row0+9
      └─ horizontal/vertical lines clamped to [0x8804]/[0x8806] then [0x8328]/[0x832E]
M5  IF highlight≠0 ([bp+6]): BOX highlight (241,8,41,79) 0x0F                          0x066DE5    181F:0xE2      OK   vid_box_outline(0xF1,8,0x29,0x4F)

--- INFO/STATUS block I (tile_info_panel func_043074 @0x043074; redraw=1 use_cur=1) -------------------------------
I0  (setup) cursor tile = ([0x8540],[0x853E]); x_col=0xF2(242); y_cur=0x33(51)         0x0430DE    -              OK   line_h=*[0x89E]+1
I0b (vis)   vis_flag from tile owner-bits ([0x10<<view] of 0x74A) or [0x53A2]          0x0430A3    181F:0x74A     OK
I1  STR     header buf = season label [0x9800+[0x538C]*2] + " " + YEAR [0x538A]         0x0430F5    181F:0x16E/178/182 DATA assemble (str-leaf)
I2  TEXT    draw header line @ (242,51)                  -        green    name/year    0x043137    181F:0x132     DATA  "Spring YYYY"  (drawcol)
I3  STR     name/gold/tax = label[0x93A0] + GOLD dword PR[0x2A] + label[0x93B0] + TAX byte PR[0x01] 0x043145 181F:0x16E/0D8/182 DATA
I4  TEXT    draw gold/tax line @ (242, 51+line_h)        -        green    PowerRecord  0x0431F1    181F:0x132     DATA  "Gold: N  Tax: N%"
I5  IF use_cur: jump to per-power market block (skip unit detail)                      0x0431FF    -              OK
I6  ELSE self_det = ([0x5390]==1 && selected-unit owner matches view): unit stack block 0x04320D    -              DATA
      y_cur += line_h/2; then SELECTED-UNIT DETAIL lines (sprite + Moves/Locat/name/orders/terrain):
I7  SPRITE  selected-unit icon @ (244,80)               ICONS.SS  -        unit[0x5392] [recon]     181F:0x254     DATA (frame-verified pos)
I8  TEXT    "Moves: N"     @ (270,82)   LABELS @INFO[0]  -        maxmoves-field/3      [recon]     181F:0x132     DATA
I9  TEXT    "Locat: (x,y)" @ (270,92)   LABELS @INFO[1]  -        unit (x,y)            [recon]     181F:0x132     DATA
I10 TEXT    unit type      @ (244,104)  NAMES @UNIT[t]   -        UREC type             [recon]     181F:0x132     DATA
I11 TEXT    unit skill     @ (244,112)  NAMES @JOB[s]    -        UREC skill            [recon]     181F:0x132     DATA
I12 TEXT    orders         @ (244,120)  LABELS @MISC     -        UREC orders           [recon]     181F:0x132     DATA
I13 TEXT    "(Terrain)"    @ (244,128)  NAMES @UN/FORESTED -      cursor terrain        [recon]     181F:0x132     DATA
I14 (carried) LOOP carried-unit rows below the panel (cargo on selected ship/wagon)    0x04(stack) 181F:0x132     DATA
I15 IF redraw≠0 ([bp+6]): PRESENT/flush composed panel                                 0x0443BC    -              OK   tail flush
    └─ I7..I13 native positions resolve from LABELS.TXT/NAMES.TXT inside the panel
       layout (y_cur advances by line_h); the (244,..) coords are frame-verified.
```

## Region geometry summary (320×200 native)

| region            | rect                | source                                   |
|-------------------|---------------------|------------------------------------------|
| map viewport      | (0,8,240,192)       | func_06787C zoom0 15×12@16px  @0x06787C  |
| top menu bar      | (0,0,320,8)         | TOPMENU_H=8 (hud.c v3)                    |
| right sidebar     | (240,0,80,200)      | x ≥ VIEW_TX*16 = 240                      |
| minimap panel     | (241,8,79,41)       | func_066CD6  @0x066CF4                    |
| minimap inner     | (251,8,48,6)        | func_066CD6  @0x066D4B                    |
| minimap content   | anchor (252,9)      | func_066CD6  @0x0669CF (px = +0xFC,+9)    |
| status year       | (242,51)→(244,58)   | tile_info_panel y_cur=0x33 / framever     |
| status gold/tax   | (242,~59)→(244,66)  | tile_info_panel I4 / framever (290,66 tax) |
| unit panel sprite | (244,80)            | frame-verified                            |

## Implementation status (what renders today, per main_modern.c draw_map)

- **VIEWPORT (block V)** — OK: real TERRAIN.SS/PHYS0 sprites via O514/O513
  (`map_view_render`). The terrain itself is pixel-correct.
- **MINIMAP (block M)** — OK frame + viewport box (`func_066CD6_minimap_panel`);
  content fill (M3) is DATA (needs the minimap compositor `1A1F:0x8CE` driven).
- **SIDEBAR / MENUBAR backgrounds (SB0/B0)** — OK in the modern shell
  (`ui_wood_fill` on WOODTILE); native menubar bg comes from the bar finalize.
- **MENU BAR labels (B10)** — TODO: native page-02 menubar render (`191F:0xFB8`)
  is unported; the modern shell hard-draws the 6 green labels via `vid_text_xy`.
  For pixel-match use the GROUNDTRUTH x: GAME 11 / VIEW 45 / ORDERS 77 /
  REPORTS 109 / TRADE 146 / COLONIZOPEDIA 261 (current code uses 48/80/120/158/256).
- **INFO/STATUS (block I)** — header/gold/tax structurally ported in
  `tile_info_panel` (DATA: needs a live PowerRecord + cursor tile populated);
  the I1/I3 string assembly uses the overlay str-leaves (0x16E/0x178/0x182/0x0D8).
- **SETTLE / COLONY / UNITS (blocks N/C/U)** — DATA: need live settlement/colony
  records and on-map units (`[0x539C]` count, `0x3144` unit table). The walks +
  pixel math are ported; only state is missing.
- **C7/C8 (OVL_E38 / 1A1F:0x8F8)** — TODO: the 7-arg extra overlay pass and the
  si-gated final pass are not yet ported in the modern composer.

## Required fixes (from the program, not from re-tracing asm)

1. Align the modern menubar label x-positions to GROUNDTRUTH (B10): GAME 11 /
   VIEW 45 / ORDERS 77 / REPORTS 109 / TRADE 146 / COLONIZOPEDIA 261.
2. Drive the minimap content compositor (M3, `1A1F:0x8CE`) so the squashed
   world renders inside the (252,9) anchor — currently only the frame draws.
3. Port the page-02 menubar finalize (B10, `191F:0xFB8`) to replace the
   hard-coded label shortcut with the real MENU.TXT-driven bar.
4. Populate a live PowerRecord (gold +0x2A / tax +0x01) + cursor tile so the
   status line (I2/I4) and the unit panel (I7..I13) show real values.
5. Port the composer's C7 (`181F:0xE38`) + C8 (`1A1F:0x8F8`) overlay passes.
```
