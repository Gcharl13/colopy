# SCREEN 1 — Title / Main Menu  (flattened draw program)

- **Composer** `func_0759E8` (page 0x1A, file 0x0759E8..0x075F97, ENTER 0x3F4,0).
  Draws the OPENING backdrop + OPENBORD frame + menu plate, then runs the
  `@BEGINMENU` panel through the data-driven menu engine `0x181F:0x3FE`
  (`lea bx,[0x2345]; lcall 0x181F:0x3FE` @asm 0x075C60/0x075C64) and dispatches
  the 1-based result with `dec ax; jge` (@asm 0x075C6D — `<1` aborts).
- **Port** `src/ui/menu_runner.c` — **authoritative, marked DONE** (ROUTE_B_PLAN
  3.1). The whole `0x181F:0x3FE` chain (template engine func_06F0F4 → modal
  func_06E3D0) is byte-verified there; this screen rides it. `src/ui/title_screen.c`
  ports the func_0759E8 plate/border composition (the static geometry).
- **Assets** `OPENMENU.PIK` (320×200 backdrop, handle 0x233C "OPENMENU"; its own
  palette — UI green idx≈254, gold idx≈84) · `OPENBORD` decoration sprites
  (pairs 6/7, 8/9, 0xE/0xF) · `WOODTILE.SS` (32×24 plank, panel fill) ·
  `FONTSMAL.FF`/`[0x89E]` resident text ctx (`@SMALLFONT`).
- **Menu data** GAME.TXT `@BEGINMENU` section (key DS:0x2345): `@width=160`,
  `@y=91`, `@smallfont`, prompt `{COLONIZATION} Version %STRING0 -- %STRING1`,
  then 5 `@options` rows. `%STRING0`=`"3.0"`, `%STRING1`=`"7-Feb-95"` (both
  byte-cited from VICEROY.EXE; menu_runner.c `mr_subst`).
- **Style words** panel[+0x3C..+0x44] init `{7,7,8,8,0}` (@asm 0x06C5B7, DGROUP
  image 07 00 07 00 08 00 08 00 @file 0x1F8DC): normal text = idx 7, HIGHLIGHT =
  idx 8. The braces `{}` toggle norm↔hi per glyph (func_06C388 @asm 0x6C3C4/
  0x6C3D2; `|` ends a line @asm 0x6C48A). RGB targets resolved to the live
  OPENMENU palette at draw time (`mr_color_for`): option green `#528A31`, title
  gold `#E3AA28`, selection bar `#382010`, panel edge `#140C06`.
- **Geometry** centered (`@x`=-1 → `x=(320-w)/2`; `@y=91` is set so the box is
  ANCHORED at y=91): `content_w = max(80, longest+10, @width=160)`,
  `w = content_w + 6`; `pitch = font.maxh + 3`; rows + 3-gap option block
  (@asm 0x06D392/0x06D513/0x06DC13). `text_x = x + border(3) + inset(2) - 1`.

## DRAW PROGRAM (composer order)

```
#   OP          rect / pos             asset/id        color    data            @asm        leaf            status
--- COMPOSER func_0759E8 (plate + border, src/ui/title_screen.c) ---------------------------------------------------
A1  CTX_RESET   (0,0,320,200)→A000      -               -        region init     0x0759FE    0x181F:0x53C    OK   ttl_region_reset
A2  IF [0x104]≠0: boot-intro (sel 3) gate — skipped on resident replay          0x075A1B    0x181F:0x498    OK   (gated)
A3  IF [0x828]==0 (first run): PIK_LOAD backdrop  handle 0x233C "OPENMENU"        0x075AE4    0x181F:0x44E    OK   pik_load(OPENMENU.PIK)
A4    └─ on ok: compose A000:0x300 (memcpy backdrop→video)                        0x075B1D    0xD1D:0xFB2     OK   draw_bg
A5    └─ else:  present saved region (no backdrop)                                0x075B05    0x181F:0x484    OK
A6  SPRITE      x=0xC8(200)             OPENBORD 6,7    -        border piece A   0x075B8E    0x1A1F:0xDF8    TODO ttl_blit_border (art not decoded)
A7  SPRITE      x=0xC8(200)             OPENBORD 8,9    -        border piece B   0x075BB0    0x1A1F:0xDF8    TODO ttl_blit_border
A8  SPRITE      x=0xC8(200)             OPENBORD 0xE,0xF -       border piece C   0x075BD2    0x1A1F:0xDF8    TODO ttl_blit_border
A9  SCENE_FILL  x=0xC8(200)             menu-plate      -        region→video     0x075C00    0x181F:0x444    OK   ttl_screen_to_video
A10 BOX         (0,0xC8)  w=0x140       -               0        menu-plate rule  0x075C12    0x181F:0x00E2   OK   ttl_box_rule
A11 (cursor reset, sel 0x33)            -               -        -               0x075C28    0x181F:0x4DE    OK
A12 →MENU RUN   key DS:0x2345 "BEGINMENU"  → returns 1-based option [bp-0xE0]     0x075C64    0x181F:0x3FE    OK   menu_run_key  (block M)
A13 sel ladder  dec-ax: 1→NEW WORLD 2→AMERICA 3→CUSTOMIZE 4→LOAD 5→Hall          0x075C6D..   (dispatch)      OK
    └─ NOTE: modern shell maps r-1 (0-based) in menu_select(); -1/ESC quits.

--- MENU RUN block (0x181F:0x3FE → menu_runner.c, the @BEGINMENU panel) --------------------------------------------
M0  (load @BEGINMENU from GAME.TXT: prompt + 5 options + @width/@y/@smallfont)    0x06F0F4    mr_load_section OK
M1  STR  prompt: substitute %STRING0="3.0" %STRING1="7-Feb-95" into prompt buf    -           mr_subst        OK
M2  (finalize geometry: w=max(80,longest+10,160)+6; anchored x centered, y=91)    0x06D316    mr_finalize     OK
M3  (save backdrop band behind the panel for teardown restore)                   0x06E53F    0x1A1F:0x364    OK   mr_save_bg
M4  FILL    panel (x,91,w,h)            WOODTILE.SS     planks   wood-plank fill  -           ss_blit_remap   OK   mr_wood_fill
M5  BOX     panel (x,91,w,h)            -               edge#140C06  panel border 0x0263D6    0x181F:0x510*   OK   vid_box_outline  (*WOODFRAM art reconstructed: 1px edge)
M6  TEXT    prompt row @ (text_x, 91+inset)  font[0x89E]  green#528A31 / gold#E3AA28  GAME.TXT @BEGINMENU prompt   0x06D9CC  0x181F:0x100  OK  mr_draw_styled
    └─ `{COLONIZATION}` word → gold (idx 8/highlight); `Version 3.0 -- 7-Feb-95` → green (idx 7/normal).
M7  (gap +3 before option block)        -               -        -               0x06D513    -               OK
M8  LOOP opt i=0..4: y=base+i*pitch
      IF i+1==sel: FILL selection bar (x+3, y-1, w-6, pitch)  bar#382010         0x06DA85    0x181F:0x100*   OK   vid_box_fill  (*style switch in DOS; modern = dark bar)
      TEXT  option text @ (text_x, y)   font[0x89E]  green#528A31  GAME.TXT @options[i]  0x06D9CC  0x181F:0x100  OK  mr_draw_styled
    └─ options (GAME.TXT order, value = 1-based @asm 0x06F4D9):
       1 "Start a Game in NEW WORLD"  2 "Start a Game in AMERICA"  3 "CUSTOMIZE New World"
       4 "LOAD Game"  5 "View Hall of Fame"
M9  PRESENT panel band / flip                                                      0x06DC..    0x181F:0xE2    OK   vid_present
M10 (modal loop: Up/Down wrap, Enter/Space commit -> panel[+0]=value, ESC=-1)     0x06E3D0    0x181F:0x16A   OK   menu_run_key loop
M11 (teardown: restore backdrop band; latches [0x1F5C/5E/60]=0xFFFF)              0x06EEC4    0x1A1F:0x1A8   OK   mr_restore_bg / mr_teardown
```

## Implementation status (what renders today)

- **DONE / matches ground truth** (`refs/ref_title.png`): the whole panel —
  wood-plank fill, `{COLONIZATION}` gold, green options + version/date, dark
  selection bar, the Up/Down/Enter/ESC modal, the 1-based / -1 return contract.
  Every structural step (M0..M11) is byte-cited in `menu_runner.c`.
- **OPENBORD decoration (A6..A8)** — TODO: the `0x1A1F:0xDF8` border-sprite blits
  are not ported as art; the modern title shows the OPENMENU.PIK backdrop + the
  wood panel without the carved OPENBORD frame pieces. Backdrop itself (A3/A4)
  renders from the real PIK.
- **Style-word → palette mapping** is a documented RECONSTRUCTION: the init
  bytes 7/7/8/8 are byte-cited; the RGB targets (`#528A31`/`#E3AA28`/…) are
  sampled from the live game and resolved through `mr_color_for` so the menu
  looks identical regardless of which PIK palette is live.

## Notes / cites

- `%STRING0`/`%STRING1` default to `"3.0"`/`"7-Feb-95"` only for the BEGINMENU
  key (menu_runner.c `mr_load_section` lines 254-257); both literals are
  byte-cited from VICEROY.EXE. The version field otherwise lives in GAME.TXT.
- The OPENMENU palette differs from the in-game master in ~31 entries (exactly
  the UI-colour slots) — see `docs/RENDER_GROUNDTRUTH.md` "Palette fact".
- Backdrop handle 0x233C and new-game backdrop 0x2374 are byte-cited (@asm
  0x075AE4 / 0x075DA3); the ".PIK" extension is appended inside the loader
  (file 0x764DE) — there is NO "TITLE.PIK".
```
