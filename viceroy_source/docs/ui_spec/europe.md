# SCREEN 6 — Europe / Dock  (flattened draw program)

- **Entry** `func_030DBC` (`europe_open`): `PIK_LOAD EUROPE.PIK (key 0x0FBA)` into
  the dialog rect `[0x839E..0x83A4]` → if handle≠0 `enter_screen_view(0x2B)`.
  `@asm 0x030DD1` (load_PIK 0x191F:0x87A) · `@asm 0x030DEE` (enter 0x181F:0x772).
- **Composer** `func_031E4C` (screen-id 0x2B). Fills the play area, then calls a
  fixed sequence of 4 element sub-renderers, then draws the outer frame. The
  structural twin of colony `func_028592`. (This is the SECOND entry in the
  disasm block the re-segmenter labelled `func_031DC8`; the first entry — ending
  at `RETF @0x031E4B` — is the recruit-pool sub-renderer `func_031DC8`.)
- **Assets** `EUROPE.PIK` (320×200 full-screen backdrop, master palette, key
  0x0FBA / @file 0x1E95A) · `ICONS.SS` (commodity icons base +0x17; ship anchor
  sprite 0x7B; boycott red-X slot 0x2B) · `LABELS.TXT @EUROLABEL[0..2]`
  (RECRUIT/PURCHASE/TRAIN, handle 0x22D4) · `FONTTINY.FF`.
- **Active record** `PowerRecord` via far ptr `*[0x84FC]` = `0x8808 + power*0x13C`
  (power = `[0x9E12]`, stride **0x13C**): `+0x01` tax % · `+0x20` boycott
  bitfield (bit i = good i) · `+0x2A` (u32) **gold** treasury · `+0x4C+good`
  per-good **price level** (bid = level−1≥0, ask = level + cargo burden≥0).
- **Per-good tables** `[0x97C0 + good*2]` word[16] = **@CARGO** name string-handle
  (NAMES.TXT col0) · `CARGO_FIELD(good,4)` = `[0x96FC + good*9 + 4]` = cargo
  **burden** (signed) used in the ask price.
- **Screen state** `[0x9E12]` active power / selected-good index for banner ·
  `[0x9E1C]`/`[0x9E20]` selected & secondary in-port ship cursors · `[0x9E2C]`
  ship-cursor (recruit/cargo) · `[0x9E2E]` recruit-slot cursor · `[0x9E40]`
  boycott-active flag · `[0xFA7]` saturation one-shot · `[0xF9A]` report-panel id
  · `[0xFA2]` detail-unit (list vs detail) · `[0x07EE]` flash-enable · `[0x9E3A]`
  game-phase (flash gate) · `[0x2F5E]` gold readout · `[0x538A]` year ·
  `[0x83E]/[0x840]` ship-record far ptr · `[0x2DA8..0x2DAE]` blit/clip region.

## PRECONDITION — ship counts (`func_030D16` ship_cursor_recount; on Europe enter, NOT per-frame)

Recomputes `[0x9E2A]` (unit count of active power) and clamps the ship cursor
`[0x9E2C]` into range. Inputs: unit chain of `[0x9E12]-0x14`, type byte `+0x3146`
(ship range 0x0D..0x12). **STATUS: DONE** (`overlay_02F3A2_031E4C.c`).

## DRAW PROGRAM (composer order)

```
#   OP          rect / pos             asset/id        color    data source                         @asm        leaf            status
--- COMPOSER func_031E4C ----------------------------------------------------------------------------------------------------------------
C0  PIK_LOAD    rect [0x839E..0x83A4]   EUROPE.PIK 0x0FBA -      backdrop (loaded by europe_open)    0x030DD1    0x191F:0x87A    OK
C1  SCENE_FILL  (0,8,320,192)           backdrop        -        clear play area; PIK shows through  0x031E4C..56 cs:0x6DDC fill OK (TODO texture/cc_fill_444)
C2  (clip prep) -                       -               -        clip/region setup                   0x031E5E    cs:0x6DB4      OK [recon]
C3  →STOCKPILE  (block S)               -               -        -                                   0x031E63    func_0310B4
C4  →BANNER     (block T)               -               -        -                                   0x031E6B    func_030F76
C5  →DOCK       (block D)               -               -        -                                   0x031E73    func_0314DC
C6  (extra A)   -                       -               -        aux paint (in-port selector)        0x031E7C    cs:0x6D73      OK [recon]
C7  (extra B)   -                       -               -        aux paint                           0x031E85    cs:0x6E36      OK [recon]
C8  →RECRUIT    (block R)               -               -        -                                   0x031E8D    func_031DC8
C9  BOX         (0,0,320,200)           -               0        outer screen frame                  0x031EA0    0x181F:0x0E2   OK draw_box
C10 EXIT-BTN    (303,190,17,10)         EXIT.SS  red E  -        resident chrome (not this page)     —           (resident)     DATA [recon, FRAME-measured]

--- STOCKPILE block (func_0310B4): 16-good MARKET PRICE bar across the bottom ----------------------------
S1  FILL        (0,179,320,21)          -               -        bar bg (PUSH 0x15,0x140,0xB3,0)     0x0310B9..C4 cs:0x6DDC fill OK (TODO texture)
S2  LOOP good=0..15: base cell y=0xB5(181), stride 0x13(19) → cell_x advances per good
      SPRITE  (cell_x, 181)             ICONS id good+0x17 -     icon sprite (good_idx+23 = 23..38)  0x0310F2/0x03110F 0x181F:0x254 OK blit_sprite
      STR/TEXT (cell_x area, ~194)      -               -        bid/ask qty text per good           0x031174/0x0311AE 0xD1D:0x8FA+0x181F:0x13C DATA
        └─ bid = market_buy_price(good) = price_level[+0x4C+good] − 1, clamp≥0  (func_030590 @asm 0x03059C/0x0305A0)
        └─ ask = market_sell_price(good) = price_level[+0x4C+good] + CARGO_FIELD(good,4) burden, clamp≥0 (func_030566 @asm 0x030583/0x030587)
      IF [0x9E40] (boycott) OR [0xFA7] (saturation): BOX cell highlight color 0xE  0x031201/0x03121A/0x031247 0x181F:0x0CE OK draw_box (X = ICONS 0x2B inside leaf)
S3  TEXT        (306,179) w15           -               -        gold = [0x2F5E]                     0x03125C..74 0x181F:0x22+0x13C OK num_to_str
      └─ PUSH 0xF,0xB3,0x132,[0x2F5E]; x=0x132(306), y=0xB3(179). EXACT colony match.

--- BANNER block (func_030F76): "Selling <Good> at <N> Gold" title / price line, top strip y≈0..45 ------
T1  STR  nation name  = g_str[power*2 − 0x7C74]  (power-name table, power=[0x9E12])  0x030F7A/0x030F80   0x181F:0x22    TODO str-leaf
T2  STR  nation adjective = g_str[power*2 − 0x72BE]; strfmt                          0x030FAD/0x030FC0   0x0D1D:0x11B4  TODO
T3  STR  era word = g_str[era_index([0x538C])*2 − 0x6800]; strfmt                    0x030FDA/0x030FED   0x0D1D:0x11B4  TODO
T4  STR  year value = [0x538A]  (sprintf)                                            0x031007/0x03100B   0x0D1D:0x08FA  TODO
T5  STR  label [0x93B0] + tax % = PowerRecord[+0x01] via [0x84FC] (append num)       0x03102F/0x03103F   0x181F:0x182   TODO  (tax = m[1])
T6  STR  label [0x93A0] appended + finalize                                          0x031079/0x031081   0x181F:0x16E   TODO
T7  TEXT  draw assembled banner (printer 0x181F:0xB1E power, then 0x181F:0xB0 @ [bp+4]) 0x03109D/0x0310AD 0x181F:0xB0   TODO  port func_030F76
      └─ pixel origin set inside the resident text engine (func_00E51C/00DDEA); occupies the y=0..45 strip.

--- DOCK block (func_0314DC): dock scene + 6 ship slots + in-port unit list, mid screen ------------------
D1  FILL        (143,118,81,60)         -               -        dock scene fill (PUSH 0x3C,0x51,0x76,0x8F) 0x0314E1..E7 cs:0x6DDC fill OK (TODO texture)
D2  PANEL       (143,81,120,69)         -               -        in-port ship row layer (build+commit) 0x0314F8..150F 0x181F:0x22/0x100 OK blit_box_id
D3  IF [0xFA2]==0 (LIST mode): LOOP slot=0..5  (6 ship slots @asm 0x031521 CMP 6)
      per-slot (x,y,w) via helper cs:0x6D55; ship records read via far ptr [0x83E]   0x03153E/0x031544  cs:0x6D55      DATA
      SPRITE  (slot rect)              ICONS id 0x7B    -        ship anchor sprite (base 123)       0x03154F/0x031559 0x181F:0x254 DATA blit_sprite
      (2nd cargo-icon pass)            ICONS            -        per-slot cargo icons                0x031731          0x181F:0x254 DATA
D4  ELSE [0xFA2]≠0 (DETAIL mode): unit = list_unit_at([0x9E1C]); type = UNIT[+0x3146]
      STR/TEXT title = g_unit_name_tbl[type*7 + 0x5230] (special if type==0x0E)      0x03157A/0x0315B9  0x181F:0x100   DATA
      LOOP slot=0..[0xFA2]-1: highlight color 0xA (==[0x9E1C]); 0xF on flash gate
        ([0x07EE]&&[0x9E3A]==1&&[0x9E28]==0) OR ([0xF9A]==1&&[0x9E40]&&slot==[0x9E20]) 0x031657..0x0316A1 cs:0x6E3B draw_table_row DATA
      in-port unit name+stat text base x = 0x92(146)                                 0x031631          0x181F:0x100   DATA
D5  (EXPECTED/BOUND/LOADING sub-panels) selector cs:0x6E13 reads [0x9E1C]; per-state text in cs:0x6Exx 0x031560 cs:0x6E13 DATA [recon]

--- RECRUIT block (func_031DC8): immigration / recruit pool, 3 candidate slots, right column ------------
R1  FILL        (281,89,37,32)          -               -        pool bg (PUSH 0x20,0x25,0x59,0x119) 0x031DCC..D2 cs:0x6DDC fill OK (TODO texture)
R2  LOOP slot=0..2  (count=3 @asm 0x031E2B CMP 3): base (x,y)=(0x119=281, 0x59=89); y advance = drawer-ret+2
      highlight = (slot==[0x9E2E] && [0x07EE]!=0 && [0x9E3A]==5)                      0x031DF0..0x031E07 -            DATA
      per-slot key from table [0x93D8 + slot*2] = {0x1430,0x143E,0x1430}              0x031E19          [bx-0x6C28]   OK
      PANEL/BUTTON  draw via func_031BE6 (beveled num cell) args(key,x,y,mode)        0x031E1D          func_031BE6   OK [recon]
        └─ raised colors fg0/edge0x30/text0x39/light7 vs sunken fg0xF/edge0x39/text0x30/light0xE 0x031BEC..0x031C24 - OK
        └─ bevel edges 0x191F:0x8BC (light top/left) + 0x191F:0x8B2 (shadow bottom/right) 0x031C8A/0x031CB8 - OK edge_light/edge_shadow
        └─ box_bevel highlight if light≥0  (0x181F:0x0BA)                              0x031D3A          0x181F:0x0BA   OK box_bevel
        └─ label/key text (shadow+face) via num_to_str + draw_text_clip x2            0x031D42/0x031DA2/0x031DB4 0x181F:0x13C TODO (button labels EUROLABEL[0..2] handle 0x22D4)
```

## Implementation status (what renders today)

- **STOCKPILE icons (S2 sprite), gold (S3), bar bg (S1)** — OK leaves; the modern
  shell `draw_europe()` (`src/main_modern.c`) already draws the 16-good strip with
  LIVE numbers: `market_bid_price`/`market_ask_price` per good, name from
  `[0x97C0+good*2]` (@CARGO), gold/tax from PowerRecord `0x8808+power*0x13C` (+0x2A
  gold, +0x01 tax). Icon sprites/exact cell geometry still SHELL-reconstructed.
- **RECRUIT pool (block R)** — OK leaves: `func_031DC8`/`func_031BE6` fully ported
  in `overlay_02F3A2_031E4C.c` (beveled_cell_grid / beveled_num_cell). Button
  labels (EUROLABEL) and slot occupancy are **DATA**.
- **DOCK ships + in-port list (block D)** — DATA: needs real ship UnitRecords of
  the active power (chain `[0x9E12]-0x14`, ship types 0x0D..0x12) and cursor state
  `[0x9E1C]/[0x9E20]`. Sub-renderer `func_0314DC` (unit_stack_panel) is ported as
  LAYOUT; per-row leaves (cs:0x6D55/0x6E3B/0x6E13) are resident.
- **BANNER (block T)** — needs `func_030F76` (report_header_row) ported: the STR
  leaves (name/adjective/era/year/tax) + printer 0x181F:0xB0. Currently the shell
  draws a plain `EUROPE - Gold N Tax N%` header instead of the assembled
  "Selling <Good> at <N> Gold" line.
- **SCENE_FILL (C1), bar/dock/pool bg fills** — need the real texture-fill leaf
  (`cc_fill_444` / `0x4FC`) wired, OR run from a populated draw context; today
  EUROPE.PIK shows through.
- **EXIT "E" button (C10), boycott red-X (ICONS 0x2B)** — drawn inside resident
  chrome / box-helper leaves (not in page 0x04); geometry FRAME-measured only.

## Required fixes (from the program, not from re-tracing asm)

1. Wire `fill_rect`→texture (`cc_fill_444` / `0x4FC`) so C1/S1/D1/R1 backdrops are
   real instead of relying on the PIK showing through.
2. Port `func_030F76` (block T) — assemble nation/adjective/era/year + tax via the
   STR leaves and emit the real "Selling <Good> at <N> Gold" banner.
3. Drive block D from real ship UnitRecords (active power, types 0x0D..0x12) so the
   6 dock slots + in-port detail panel render; wire `func_0314DC` per-row leaves.
4. Supply recruit-pool slot data (EUROLABEL labels + candidate immigrants) so the 3
   beveled buttons show RECRUIT/PURCHASE/TRAIN with live state.
