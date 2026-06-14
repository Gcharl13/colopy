# SCREEN 7 — Reports (F1..F10 advisers)  (flattened draw program)

- **Entry** the in-game menu-bar "Reports" column (`build_menubar` func_072090, items
  selectors `0x40..0x49`). Firing an item enters the **SETREPORT** branch of the command
  dispatcher `func_0235D6` (page 0x01), a CMP/LCALL ladder on `[bp+6]` that calls one
  page-05 renderer per F-key (@asm 0x023843..0x0238CB, cited per sub-block).
- **Shared frame** every renderer first calls `report_open` (func_037340) indirectly via
  the page-05 trampoline `call 0x34C3` (`rpt_draw_frame(panel)`): copies the `"REPORT"`
  key, resolves the titled panel by selector, draws the panel frame into the content
  region `[0x2DA8..0x2DAE]`, blits at `(0x98,0x64)`. See SHARED FRAME block.
- **Assets** `REPORT7.PIK` (320×200 report backdrop; bodies blit a strip via `rpt_blit_bg`
  0x181F:0x22) · `ICONS.SS` / score-sheet `[0x83E]/[0x840]` (commodity + score icons) ·
  `CC-NN.SS` founding-father portrait plates (F3 hall) · `CCBKGD.PIK` (F3 hall backdrop) ·
  `FONTTINY.FF`. Per-report **title** + column **header** strings come from `LABELS.TXT
  @MISC` (NOT the EXE), staged into DGROUP `[0x2DEE..0x2F5A]` (`g_rpt_str[]`); literal text
  is `[RUNTIME_ONLY]`.
- **Active record** `select_report_player([bp+6])` (0x181F:0x582 → func_030550) stores
  player idx at `[0x9E12]` and sets `[0x84FC] = 0x8808 + player*0x13C` = `*PowerRecord`.
  **PowerRecord base 0x8808 stride 0x13C**; fields: `+0x0C/0x0E` bells · `+0x12` treasury ·
  `+0x2A` gold · `+0x2E` crosses-current · `+0x30` crosses-needed · `+0x4C` price-level base.
- **Other DGROUP data** colony table `*[0x8542]` (stride 0xCA; `+0x1A` owner, `+0x1F` pop,
  `+0/+1` x/y, `+1..` name) · FF name handles `word[0x9652+idx*6]` (stride 6) · FF plate
  order `byte[0x123A+i]` (25-byte perm) · colony count `[0x539E]` · tribe count `[0x539A]` ·
  unit count `[0x539C]` · independence/boycott `[0x5382]` · cheat `[0x5383]` (bit 0x20 =
  reveal/raw) · sales-tax `[0x53D0]` · congress series `word[0x53DA..0x53E8]` w/ colors `[0x52xx]`.
- **Selector → F# → renderer** (SETREPORT ladder): `0x40 F1` Terrain Info (MAP overlay
  func@0x069D8C page-0x16 — **out of scope**, see map.md) · `0x41 F2` func_037958 Religious ·
  `0x42 F3` func_037A10 Congress · `0x43 F4` func_038418 Labor · `0x44 F5` func_038A50
  Economic · `0x45 F6` func_039218 Colony · `0x46 F7` func_03954C Naval · `0x47 F8`
  func_039888 Foreign · `0x48 F9` func_03744A Indian · `0x49 F10` func_038778 Score.

## SHARED ANCHOR primitives (each maps to one OP; signatures byte-exact from call sites)

- `rpt_draw_frame(panel)` `call 0x34C3` → func_037340 report_open → **PANEL** (titled frame).
- `rpt_blit_bg(0,0x140,h,id,strslot)` 0x181F:0x22 + `rpt_commit(dx,ax)` 0x181F:0x100 → **FILL**
  of a backdrop strip from REPORT7.PIK at the panel id.
- `meter_draw(color,row,col,v0,v1,max)` 0x181F:0x236 → **ICON_RUN** (single progress meter).
- `bars_begin`/`bars_add(color,val)`/`bars_draw(n,row,col,w)` 0x181F:0x218/0x222/0x22C →
  **ICON_RUN** (stacked colored-segment bar).
- `graph_bar(w,a,b,val,row,col)` 0x181F:0x2BC → **ICON_RUN** (proportional bar).
- `icon_at(sheet,off,row,x,seg,y,n)` 0x181F:0x254 → **SPRITE** ; `hud_icon(2,seg,icon)`
  0x191F:0x8BC → **SPRITE** (header icon).
- `box_outline(a,row,col,b)` 0x191F:0x8B2 → **BOX** ; `text_draw(...)` 0x181F:0x13C → **TEXT** ;
  `str_*` 0x181F:0x10A..0x1BE / `str_cat_num` 0x181F:0x182 → **STR**.
- `unit_sprite(buf,type,x,y,n)` 0x191F:0xF82 → **FIGURE** ; `rpt_footer(-1,-2)` `call 0x34A0`
  → func_0373CA → **PANEL** (footer + key hint) ; present 0x181F:0xE2 → **PRESENT**.

---

## SHARED FRAME block — report_open (func_037340)  [every report via call 0x34C3]

```
#   OP          rect / pos             asset/id        color    data source                 @asm        leaf                 status
SF1 STR         [bp-0x50] titlebuf      key 0x11A2      -        strcpy "REPORT"             0x037344    strcpy_near(0xD1D:7E4) OK
SF2 (resolve)   -                       sel=[bp+6]      -        report-key by selector      0x03735B    ov_lookup(0x181F:0x182) OK
SF3 PANEL       [0x2DA8..0x2DAE]        titled frame    -        content region rect         0x03737F    ov_report_dispatch(0x181F:0x44E) TODO
SF4 IF ok!=0 → show: ov_report_show(region,0x22)                                             0x03739D    0x181F:0x484          TODO
SF5 ELSE → PRESENT  blit bigbuf @ (0x98,0x64); cursor latch [0x372] saved/0/restored          0x0373BC    ov_report_blit(0xC2E:0x22) OK
    NOTE: SF3 is the SHARED titled panel every sub-report draws first (rpt_draw_frame(panel)).
          panel index (1..8) selects the LABELS.TXT title; panel→LABELS idx [RUNTIME_ONLY].
```

## F2 — Religious Adviser  (sel 0x41 · func_037958 · panel 2)  [SETREPORT @0x023854]

Immigration progress meter: crosses current `[0x84FC]+0x2E` of needed `+0x30`.

```
#   OP          rect / pos             asset/id        color    data source                 @asm        leaf                 status
R1  (select)    -                       player=[bp+6]   -        set [0x84FC]=PowerRec        0x03795F    0x181F:0x582         OK
R2  PANEL       [0x2DA8..0x2DAE]        panel 2         -        titled frame (Religious)     0x03796A    call 0x34C3 (SF3)    TODO
R3  FILL        (0,?,0x140,h=5)         REPORT7 id 0x05 -        bg strip, slot [0x2DF6]      0x03797E    rpt_blit_bg 0x181F:0x22 TODO
R4  ICON_RUN    col 0xA,row 0x19,w 0x12C  meter         0x39     v0=[0x84FC+0x2E] v1=[+0x30]  0x0379B4    meter_draw 0x181F:0x236 DATA
R5  IF [0x5383]&0x20 (cheat): STR "(%d of %d)" raw crosses (0x11A9) → TEXT col 0xA,row 0x19   0x0379E4    text_draw 0x181F:0x13C DATA
R6  PANEL       footer                   key hint        -        rpt_footer(-1,-2)            0x0379F1    call 0x34A0          TODO
R7  PRESENT     (0,0x140,0xC8)           -               -        + wait-input 0x181F:0x3C0    0x037A04    0x181F:0xE2          OK
```

## F3 — Continental Congress  (sel 0x42 · func_037A10 · panel 3)  [SETREPORT @0x023865]

FF bells/liberty + economic stacked-bar breakdown, then the **Congress hall** (CCBKGD +
FF portrait plates). Reads flags `[0x5382]`, tax `[0x53D0]`, treasury `[0x84FC]+0x12`,
bells `+0xC`, FF name `word[0x9652+idx*6]`, paired (color `[0x52xx]`, value `[0x53DA..0x53E8]`).

```
#   OP          rect / pos             asset/id        color    data source                 @asm        leaf                 status
C1  (select)    -                       player=[bp+6]   -        set [0x84FC]=PowerRec        0x037A18    0x181F:0x582         OK
C2  PANEL       [0x2DA8..0x2DAE]        panel 3         -        titled frame (Congress)      0x037A23    call 0x34C3 (SF3)    TODO
C3  FILL        (0,?,0x140,h=5)         REPORT7 id 0x05 -        bg strip, slot [0x2E04]      0x037A37    rpt_blit_bg 0x181F:0x22 TODO
C4  IF !([0x5382]&1): STR header [0x2E9A] + FF/king name when treasury [0x84FC+0x12]>=0      0x037A66    str_cat 0x16E/0x182 DATA
C5  ICON_RUN    col 0x19,row 4,w 0x12C  bar             0x3F     player bell tally (clamp)    0x037BF5    graph_bar 0x181F:0x236 DATA
C6  ICON_RUN    row 4,col 0x19,w 0x12C  stacked         [0x52xx] PASS1 income bars_add per (color,value[0x53DA+2k]) 0x037E1C bars_* 0x181F:0x218/0x222 DATA
C7  ICON_RUN    row 4,col 0x19,w 0x12C  stacked         [0x52xx] PASS2 bells x4 (value[0x53E2..0x53E8])           0x037EFE bars_* DATA
C8  PANEL       footer                   key hint        -        rpt_footer(-1,-2)            0x038040    call 0x39E30        TODO
C9  PRESENT     (0,0x140,0xC8)           -               -        + wait-input                 0x038049    0x181F:0xE2          OK
--- CONGRESS HALL TAIL (IF [0x346]==0 && [0x9E38]==0): congress_screen_render(player,-1) ---  0x038073    0x191F:0xF74 → func_03BB4A
C10 PIK_LOAD    (0,0,320,200)           CCBKGD.PIK      -        hall backdrop → clip rect    0x3BB6D     pik_load 0x181F:0x44E OK
C11 FILL        [0x2DA8..0x2DAE] 0x140x0xC8  -          -        compose backdrop over frame  0x3BBB5     0x181F:0x444        TODO cc_fill_444
C12 LOOP i=0..24: id=byte[0x123A+i]; IF ff_owned(power,id): load CC-<id>.SS;                  0x3BAB8     func_00BC10(0x181F:0x7B4) DATA
      FIGURE plate @ frames[0].x/y (embedded in CC-NN.SS)                                     0x3BB1E     ss_blit 0x181F:0x2F8 DATA
C13 PRESENT     (0,0x140,0xC8)           -               -        full-frame present           0x3BBE6     0x181F:0xE2         OK
    NOTE: F3 tail passes new_ff=-1 (plain hall). new_ff>=0 runs a reveal/fade (0x181F:0x3EA, unported).
```

## F4 — Labor Adviser  (sel 0x43 · func_038418 · panel 4)  [SETREPORT @0x023876]

Histogram of colonists by profession (29 bins): tally `colonist_profession()` (`+0x40`) over
owned colonies + field units (`+0x315B`); labeled bars + click drilldown.

```
#   OP          rect / pos             asset/id        color    data source                 @asm        leaf                 status
L1  (select)    -                       player=[bp+6]   -        set [0x84FC]=PowerRec        0x038421    0x181F:0x582         OK
L2  PANEL       [0x2DA8..0x2DAE]        panel 4         -        titled frame (Labor)         0x03842C    call 0x34C3 (SF3)    TODO
L3  FILL        (0,?,0x140,h=5)         REPORT7 id 0x05 -        bg strip, slot [0x2E1C]      0x038440    rpt_blit_bg 0x181F:0x22 TODO
L4  FILL        (0,?,0x140,h=[0x89E]+6) REPORT7 id 0x91 -        grid strip, slot [0x2E2A]    0x03846B    rpt_blit_bg 0x181F:0x22 TODO
L5  (tally A)   -                       29 bins         -        colonies [0x8542]: owner==player → bins[colonist_profession(c)]++ 0x0384C4 0x181F:0xC54 DATA
L6  (tally B)   -                       29 bins         -        units [0x539C]: owner==player & working → bins[+0x315B]++ 0x038524 0x181F:0xB28 DATA
L7  LOOP k=0..28: ICON_RUN labeled profession bar bins[k]; label [bx-0x715C]; geom 0x24A     0x038598    prof_bar 0x181F:0x24A DATA
L8  IF prof_hit_test([0x7E8],[0x7EA]) hits bar j → labor_drilldown(player,j,bins[j])          0x038706    call 0x34BE         DATA
L9  PANEL       footer                   key hint        -        rpt_footer                   -           call 0x34A0          TODO
```

## F5 — Economic Adviser  (sel 0x44 · func_038A50 · panel 5)  [SETREPORT @0x023887]

Per-cargo $ ledger `ledger[player*0x4F+cargo]` (64-bit at `[bx-0x777C]/[bx-0x777A]`),
formatted as dollars ("$" 0x11B4, /1000), one row per cargo (17) + name headers + gridlines.

```
#   OP          rect / pos             asset/id        color    data source                 @asm        leaf                 status
E1  (select)    -                       player=[bp+6]   -        set [0x84FC]=PowerRec        0x038A58    0x181F:0x582         OK
E2  PANEL       [0x2DA8..0x2DAE]        panel 5         -        titled frame (Economic)      0x038A63    call 0x34C3 (SF3)    TODO
E3  FILL        (0,?,0x140,h=5)         REPORT7 id 0x05 -        bg strip, slot [0x2E1E]      0x038A77    rpt_blit_bg 0x181F:0x22 TODO
E4  FILL        (0,?,0x140,h=[0x89E]+6) REPORT7 id 0x91 -        grid strip, slot [0x2F56]    0x038AA2    rpt_blit_bg 0x181F:0x22 TODO
E5  BOX         x 0x43,row 0x19,w 0xA1  header rule     0x77     -                            0x038ACF    box_outline 0x191F:0x8B2 OK
E6  LOOP cargo=0..16: SPRITE cargo-name header icon @ (0x21+cargo*8)  ICONS                   0x038BCD    hud_icon 0x191F:0x8BC OK
E7  LOOP cargo=0..16: STR "$%ld" ledger[player*0x4F+cargo] (abs, /1000) → TEXT at column      0x038D73    text_draw 0x181F:0x13C DATA
E8  (totals)    bottom row              -               -        cargo_total(cargo)           0x038D7F    0x191F:0x9EA        DATA
E9  PANEL       footer                   key hint        -        rpt_footer(-1,-2)            -           call 0x34A0          TODO
```

## F6 — Colony Adviser  (sel 0x45 · func_039218 · panel 6)  [SETREPORT @0x023898]

Per owned colony: name + map position + ships present (type 0x0D..0x12), 9/screen. Reads
colony table `*[0x8542]` (owner `+0x1A`, name `+1`, x/y `+0/+1`), count `[0x539E]`, marker `[0x8DC6]`.

```
#   OP          rect / pos             asset/id        color    data source                 @asm        leaf                 status
Y1  (select)    -                       player=[bp+6]   -        set [0x84FC]=PowerRec        0x03921F    0x181F:0x582         OK
Y2  PANEL       [0x2DA8..0x2DAE]        panel 6 (2-pane) -       header frame                 0x039232    call 0x34C8         TODO
Y3  LOOP i=0..[0x539E]-1: select_ctx(i) → ctx=[0x8542]; if owner[+0x1A]!=player continue      0x0392EE    0x181F:0x9E6        DATA
Y4    TEXT      col 2,row+0x17          colony name      -        [0x8542]+2 (16 bytes)        0x03934D    text_draw 0x181F:0x13C DATA
Y5    SPRITE    marker @ name x/y       [0x8DC6] icon    -        colony position marker       0x039330    0x181F:0x2A8        DATA
Y6    LOOP ships at colony: IF type[+0x3146] in 0x0D..0x12 → FIGURE ship + cargo bar          0x03928B    0x181F:0x2BC       DATA
Y7    row += 0x11; IF ++count==9: PANEL footer + new-page header                              0x039214    call 0x34A0/0x34C8 TODO
Y8  PANEL       final footer            key hint         -       colony_footer(player)         0x0393EE    call 0x34B4        TODO
```

## F7 — Naval Adviser  (sel 0x46 · func_03954C · panel 7)  [SETREPORT @0x0238A9]

Player ships (types 0x0D..0x12) with name, position, cargo manifest, sprite (damaged variant
distinct). Iterates all units `[0x539C]`. Player-select + panel-7 frame happen inside func_0393F4.

```
#   OP          rect / pos             asset/id        color    data source                 @asm        leaf                 status
N1  PANEL       [0x2DA8..0x2DAE]        panel 7          -       header+select via func_0393F4 0x039555   call 0x34AF          TODO
N2  LOOP u=0..[0x539C]-1: owner[+0x3147]&0xF==player; t=type[+0x3146]; SHIPS ONLY 0x0D..0x12  0x0397E3    -                  DATA
N3    TEXT      row                     ship name [bx-0x7C74] -   ship name                    0x03954C    text_draw 0x181F:0x13C DATA
N4    ICON_RUN  cargo bar               manifest         -        graph_bar cargo              0x0396A2    0x181F:0x2BC       DATA
N5    FIGURE    ship sprite (damaged if player-y in {0xC,0x10})                                0x03975A    unit_sprite 0x191F:0xF82 DATA
N6    row += 0x14; 7 ships/screen → footer + repaginate                                       0x039796    call 0x34AF        TODO
```

## F8 — Foreign Affairs  (sel 0x47 · func_039888 · panel 8)  [SETREPORT @0x0238BA]

4-column comparative diplomacy. When independence declared `[0x5382]&1` shows "FOREIGNNOTAVAIL"
(0x11B6) and bails. Per-power stats: colonies `[0x9298]`, wealth `[0x944E]`, pop `[0x9410]`,
finance `[0x941C]`.

```
#   OP          rect / pos             asset/id        color    data source                 @asm        leaf                 status
G0  IF [0x5382]&1: show "FOREIGNNOTAVAIL" (0x11B6); RETURN                                    0x039899    0x181F:0x652        DATA
G1  (select)    -                       player=[bp+6]   -        set [0x84FC]=PowerRec        0x0398A7    0x181F:0x582         OK
G2  PANEL       [0x2DA8..0x2DAE]        panel 8         -        titled frame (Foreign)       0x0398B2    call 0x34C3 (SF3)    TODO
G3  FILL        (0,?,0x140,h=2)         REPORT7 id 0x90 -        bg strip, slot [0x2E74]      0x0398C6    rpt_blit_bg 0x181F:0x22 TODO
G4  LOOP j=0..3: BOX 4-power column headers @ row j*0x2D                                      0x0398E2    box_outline 0x191F:0x8B2 OK
G5  LOOP slot=0..3: IF recognized(4,player)==0 && [0x53A2]==0 → skip                          0x039922    0x181F:0x7B4       DATA
G6    TEXT      column                  power name [0x9298] -    + wealth [0x944E], pop [0x9410], finance [0x941C]>>3 0x0399.. str_cat/0x13C DATA
G7  PANEL       footer (implied)        key hint         -       rpt_footer                    -           call 0x34A0          TODO
```

## F9 — Indian Adviser  (sel 0x48 · func_03744A · panel 1)  [SETREPORT @0x023843]

Per-tribe strength: native types 0x14 (Braves) + 0x16 (Mounted), `strength=count*0x32`. Reads
tribe rec `[0x8D4E]` (color `+2`, treaty `+3`&0x80, level `+7`, tension `+8`), settlements
`[0x54EE]` stride 0x12, tribe count `[0x539A]`. 8 tribes, paged. No select; opens to panel 1.

```
#   OP          rect / pos             asset/id        color    data source                 @asm        leaf                 status
I1  PANEL       [0x2DA8..0x2DAE]        panel 1         -        titled frame (Indian)        0x037453    call 0x34C3 (SF3)    TODO
I2  FILL        (0,?,0x140,h=5)         REPORT7 id 0x05 -        bg strip, slot [0x2DF4]      0x037467    rpt_blit_bg 0x181F:0x22 TODO
I3  LOOP t=0..7: rec=[0x8D50]; IF !(tribe_flags&0x20) && !([0x8D4E][+3]&0x80) → skip          0x03784C    0x181F:0xA42       DATA
I4    (count)   -                       -               -        settlements [0x54EE] owner==t + units type 0x14|0x16; strength*=0x32 0x03767F IMUL 0x32 DATA
I5    TEXT      col 0x19,row 0xA        tribe block      -       name/color [0x8D4E]+2, level +7, tension +8, count, strength 0x0376B4 str_cat_num 0x181F:0x182 DATA
I6    row += 0x15                                                                              0x037827    -                  OK
I7  IF mouse hits a tribe row → per-tribe drill-down (0x181F:0x30C/0x35C)                      0x037837    -                  DATA
I8  PANEL       footer                   key hint        -        rpt_footer(-1,-2)            0x037937    call 0x34A0          TODO
```

## F10 — Colonization Score  (sel 0x49 · func_038778 · panel 5)  [SETREPORT @0x0238CB]

Score grid: titled frame + header box, then 16-row × 18-col grid of score icons from sheet
`[0x83E]/[0x840]`. SETREPORT fires F10 only when `[0x5383]&0x20`; thunk 0x181F:0x574 re-enters +0x70.

```
#   OP          rect / pos             asset/id        color    data source                 @asm        leaf                 status
S1  (select)    -                       player=[bp+6]   -        set [0x84FC]=PowerRec        0x03877F    0x181F:0x582         OK
S2  PANEL       [0x2DA8..0x2DAE]        panel 5         -        titled frame (Score)         0x03878A    call 0x34C3 (SF3)    TODO
S3  FILL        (0,?,0x140,h=5)         REPORT7 id 0x05 -        bg strip, slot [0x2E1E]      0x03879E    rpt_blit_bg 0x181F:0x22 TODO
S4  FILL        (0,?,0x140,h=[0x89E]+6) REPORT7 id 0x91 -        grid strip, slot [0x2F58]    0x0387C9    rpt_blit_bg 0x181F:0x22 TODO
S5  SPRITE      x 0x17,y 0x5A,row 0x30  score sheet [0x83E]/[0x840] n=4  first score-icon row 0x038825 icon_at 0x181F:0x254 DATA
S6  LOOP i=0..15: BOX row outline @ (col 0xB2,row 0x19,w 0x77); y+=0xE                        0x03884C    box_outline 0x191F:0x8B2 OK
S7  LOOP i=0..17: SPRITE header icon @ (0x2A+i*8), seg 0x137                                  0x038880    hud_icon 0x191F:0x8BC OK
    NOTE: ANOMALY — F10 thunk 0x181F:0x574 lands +0x70 into func_038778; exact entry [RUNTIME_ONLY].
```

## F1 — Terrain Information  (sel 0x40)  — OUT OF SCOPE

`0x40 F1` resolves to `0x191F:0x428` = func@0x069D8C (page 0x16): a **MAP overlay**, not a
page-05 report renderer. No `report_open` frame; documented with the map screen (`map.md`).

## Implementation status (what renders today)

- **Shared-frame select/present + header box/icon rules** (`0x181F:0x582`, `0x181F:0xE2`,
  `0x191F:0x8B2`/`0x8BC` in E5/E6, S6/S7, G4) — OK leaves, call them.
- **PANEL frames** (SF3 + every `call 0x34C3/0x34AF/0x34C8/0x34B4`) — TODO: the
  `ov_report_dispatch`/`ov_report_show` titled-frame path is unported.
- **Backdrop strips** (`rpt_blit_bg`+`rpt_commit`) — TODO: REPORT7.PIK strip blit; F3 hall
  fill C11 shares the `cc_fill_444` TODO with colony/map/europe.
- **All report BODIES** (meters, stacked bars, histogram, $ ledger, per-colony/ship/tribe
  rows, FF plates, score grid) — **DATA**: need populated game state.

## Required fixes (from the program, not from re-tracing asm)

1. Port the shared **PANEL frame** path (`ov_report_dispatch` 0x181F:0x44E + `ov_report_show`
   0x181F:0x484 + the `call 0x34C3` → report_open trampoline) → lights up the titled frame +
   footer for all 9 reports at once.
2. Wire `rpt_blit_bg`(0x181F:0x22)+`rpt_commit`(0x181F:0x100) to blit REPORT7.PIK body strips
   at panel ids (0x05 main / 0x90 / 0x91 grid); shares `cc_fill_444` for C11 hall fill.
3. Resolve per-report **panel→LABELS.TXT** title/header indices (`g_rpt_str[]` slots
   `[0x2DEE..0x2F5A]`) so titles + column headers are real text.
4. Drive bodies from real game state: PowerRecord (F2/F3/F5), colony table (F4/F6), unit list
   (F4/F6/F7/F9), AI-census `0x92xx/0x94xx` (F8), score sheet (F10), FF owned-set + CC-NN.SS (F3).
