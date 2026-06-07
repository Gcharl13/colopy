# CHROME & DISPATCH INDEX — VICEROY.EXE UI paint code

**What this is:** the master index of *which function paints which UI surface*,
with each painter resolved to a **raw VICEROY.EXE file offset** and its **overlay
page** (or "resident"), plus a full byte-cited draw-list for every "chrome"
screen not owned by the two sibling decode agents (reports F-key bodies →
sibling A; Europe/Colony bodies → sibling B).

Built 2026-05-31. Companions: `SCREEN_LAYOUTS.md` (per-screen geometry tables),
`UI_FIDELITY.md` (fonts/sprites/dialog-sizing primitives), `docs/RULINGS.md`
commit 199, `EVENT_DISPATCH.md` (GAME.TXT event flow).

## How offsets were resolved (the authoritative method)

Every `lcall 0x181F:NNN` / `0x191F:NNN` / `0x1A1F:NNN` is an RTLink/Plus V2
**thunk dispatch**. The far address `seg:off` is only a *window* into the thunk
table (file 0x1A5F0..0x1D610). The thunk record's own page-id trailer — NOT the
window seg — names the real overlay page. Resolved with
`tools/rtlink/rtlink_decode.py` (validate: ALL PASS):

```
target_file_offset = segments[page_id-1].code_offset + offset_in_segment
page_id            = thunk trailer word (= segmentNum - 1)
```

**CRITICAL — corrects a naïve trap:** `rtlink_decode.py resolve <page> <off>`
takes a page *you* supply. To resolve a real call site you must read the thunk
record's **own** page-id (via `info --json`), because a single window offset
(e.g. `0x191F:0x320`) carries a trailer that points at page 0x1A, not page 0x01.
The per-page code bases used below (all from `rtlink_decode info`, byte-identical
to `code/VICEROY/overlay_pages.json`):

| page | code base | page | code base | page | code base |
|----|----|----|----|----|----|
| 0x01 | 0x020EE0 | 0x0B | 0x045D00 | 0x15 | 0x066850 |
| 0x02 | 0x025900 | 0x0C | 0x046DE0 | 0x16 | 0x068EE0 |
| 0x03 | 0x02CFD0 | 0x0D | 0x04C1F0 | 0x17 | 0x06BE50 |
| 0x04 | 0x030550 | 0x0E | 0x053820 | 0x18 | 0x06F8E0 |
| 0x05 | 0x037340 | 0x0F | 0x056A10 | 0x19 | 0x06FDF0 |
| 0x06 | 0x03B900 | 0x10 | 0x05AF70 | 0x1A | 0x072090 |
| 0x07 | 0x03ECF0 | 0x11 | 0x05E9B0 | 0x1B | 0x0764D0 |
| 0x08 | 0x0404B0 | 0x12 | 0x05FE60 | 0x1C | 0x076E50 |
| 0x09 | 0x042C50 | 0x13 | 0x061E10 | 0x1D | 0x077990 |
| 0x0A | 0x044540 | 0x14 | 0x063880 | 0x1E | 0x077ED0 |
|      |          |      |          | 0x1F | 0x078640 |

(All bases from `rtlink_decode info`, byte-identical to
`code/VICEROY/overlay_pages.json`. Page 0x17 = segmentNum 24 base 0x06BE50;
page 0x18 = segmentNum 25 base 0x06F8E0.)

Resident code (load image, no paging) lives below the overlay image start
0x020670; resident functions are cited by their flat file offset directly.

## Draw-primitive thunk semantics — CORRECTED & byte-verified (2026-05-31)

The earlier brief's primitive vocabulary ("0x22=FILL RECT, 0xE2=HORIZONTAL
RULE, 0x100=TEXT-CENTERED, 0x1C8=title-bar sprite tiler") was **partly wrong**.
Each `0x181F:NNN` draw thunk is a **type-B** record (`9a 91 0d 0d 11` =
`LCALL 0x110D:0x0D91`, then `ea off seg` = `JMPF seg:off`). The JMPF segment is
relative to the resident load-image base (file 0x2400), so the true target file
offset = `0x2400 + (seg<<4) + off`. Disassembled the targets directly from the
EXE (capstone, CS_MODE_16). The disassembler's inline `overlay @file 0x0259xx`
comments on these thunks are GARBAGE (wrong-page assumption) — ignore them.

| thunk | thunk rec @file | JMPF target | resident func | **what it ACTUALLY does** (byte-verified) |
|---|---|---|---|---|
| `0x181F:0x22` | 0x1A612 | 0x0000:0x0062 | **func_002462** @0x2462 | **get_string_by_index** — `repne scasb` over the strtab at far ptr `[0x2d42:0x2d44]`, skips `[bp+6]` NUL-terminated strings, returns ptr in DX:AX. **NOT a fill-rect.** (45 B, ENTER 4, RETF.) |
| `0x181F:0x114` | 0x1A704 | 0x004B:0x0216 | func_002AC6 @0x2AC6 | **measure_text_width** (returns px width in AX). |
| `0x181F:0x13C` | 0x1A72C | 0x004B:0x0288 | func_002B38 @0x2B38 | **draw_text_at(x,y,color)** — explicit position, no centering. |
| `0x181F:0x100` | 0x1A6F0 | 0x004B:0x0318 | **func_002BC8** @0x2BC8 | **draw_text_CENTERED_in_box** — measures (0x2AC6), `x = boxX + (boxW−textW)/2` (clamp ≥0), draws via 0x2B38. **Matches brief.** |
| `0x181F:0x1C8` | 0x1A7B8 | 0x004B:0x0430 | func_002CE0 @0x2CE0 | **draw_title_text_centered** — same centre math as 0x100, used for the picker title bar. **NOT a sprite tiler.** (The `0xFD/0xFE` args are color/flag words, not sprite indices.) |
| `0x181F:0xCE` | 0x1A6BE | 0x0BCA:0x0002 | **func_00E0A2** @0xE0A2 | **draw_rect_OUTLINE (hollow 1-px box)** — sorts (bx,ax)→x0,x1 and (dx,[bp+8])→y0,y1, then 2× h-span (`0xBBC:0xC`) + 2× v-span (`0xBC3:6`). color=`[bp+6]`. **This is the picker SELECTION HIGHLIGHT.** RETF 0xC (6 stack words + ax/bx/dx regs). |
| `0x181F:0xE2` | 0x1A6D2 | 0x0B70:0x003A | **func_00DB3A** @0xDB3A | **indexed-sprite/cell blit with clip-ctx [0x2da8]** — resolves sheet ptr (`0xA58:0x2CE`/`0x5BE`), pushes 3 caller args + ptr + `ds:0x2da8`, calls blitter `0xD11:0x1C`. RETF 6. **NOT a horizontal rule.** (Used for the always-drawn row flag cell.) |
| `0x181F:0x444` | 0x1AA34 | 0x0B8F:0x0006 | func_00DCF6 @0xDCF6 | **sprite/bitmap blit with per-row stride** (`rep movsw`/`movsb`, `add si,bx` stride). Used for the row badge/portrait base. |
| `0x181F:0x254` | 0x1A844 | 0x0C36:0x000A | func_00E76A @0xE76A | indexed sprite blit (AX=idx, DX=x, BX=&ctx) — matches UI_FIDELITY. |
| helpers | — | — | `0xBBC:0xC` @0xDFCC | **h-span fill** (one scanline run into FB segment). |
| helpers | — | — | `0xBC3:6` @0xE036 | **v-span fill** (one column run). |

**Upshot for the pickers:** the SELECTION box is `0x181F:0xCE` = a **1-px hollow
rectangle outline**, color taken from the per-row palette byte. There is no
filled-rect selection. The brief's "selection = 0x22 FILL RECT" is incorrect.

---

# (A) MASTER UI PAINTER DISPATCH INDEX

Legend: **R** = resident (load image). **[V]** = byte-verified this pass or in
SCREEN_LAYOUTS/UI_FIDELITY against the resolver. **[sib-A]** = report F-key body,
owned by sibling agent A. **[sib-B]** = Europe/Colony body, owned by sibling B.

| # | UI surface | painter / composer | FILE offset | page | dispatch site (how reached) | status |
|---|---|---|---|---|---|---|
| 1 | **Title / opening menu** | `func_0759E8` (composer) | **0x0759E8** | 0x1A | called at game boot / return-to-menu; runs @BEGINMENU then dec-ax ladder | **[V]** decoded §B1 |
| 2 | — title menu RUN (@BEGINMENU) | `opt_register`→`menu_lookup_run`→`func_06E3D0` | runner `0x06F594` | 0x17 | `lea bx,[0x2345]; lcall 0x181F:0x3FE` @0x075C64 | **[V]** |
| 3 | **Main-menu list rows** | (data-driven via menu engine) | — | 0x17 | @BEGINMENU section rows; `[layout]` | **[V]** §B1 |
| 4 | **New-game orchestrator** (begin_game) | `begin_game` (page-0x1A) | **0x072578** | 0x1A | `lcall 0x191F:0x320` @0x075E5F (title "new game") AND @0x023626 path | **[V]** §B1 |
| 5 | **Nation-select screen** | `func_07092E` (composer) | **0x07092E** | 0x1A | modal entry from begin_game; reads @PICKNATION; returns index→[0x5398] | **[V]** decoded §B3 |
| 6 | — nation row painter | `func_0707B6` | **0x0707B6** | 0x1A | composer loop body via near `0x70C5F`→thunk 0x1A1F:0xBD6→`func_0707B6` (per nation 0..3) | **[V]** §B3 |
| 7 | — nation cell-xy | `func_070782` | **0x070782** | 0x1A | reached from row painter via near `0x70C5A`→0x1A1F:0xBC8. **2-col grid:** `x=(n%2)·0x63+0x70` (99·col+112), `y=(n/2)·0x5B+0x0D` (91·row+13) | **[V]** §B3 |
| 8 | **Difficulty-select screen** | `func_070494` (composer) | **0x070494** | 0x1A | modal entry from begin_game; reads @DIFFICULTY; returns→[0x53A6] | **[V]** decoded §B2 |
| 9 | — difficulty row painter | `func_070302` | **0x070302** | 0x1A | composer loop body via near `0x70C50`→thunk 0x1A1F:0xBAC→`func_070302` (per level 0..4) | **[V]** §B2 |
| 10 | — difficulty cell-xy | `func_0702C0` (**NOT** shared 070782) | **0x0702C0** | 0x1A | reached from row painter via near `0x70C46`→0x1A1F:0xB90. **3-col grid w/ (n+1) offset:** `col=(n+1)%3`, `grp=(n+1)/3`, `x=col·0x69+0x17` (105·col+23), `y=grp·0x60+7` (96·grp+7). **CORRECTION:** difficulty does NOT share the nation 2-col grid. | **[V]** §B2 |
| 11 | **Setup / scenario-list ("AMERICA")** | menu engine (@AMERICA list) | runner `0x06F594` | 0x17 | `lea bx,[0x234f]; lcall 0x181F:0x3FE` @0x075CE5 (title "setup-list") | **[V]** §B1 |
| 12 | **Load-game / saved-game pick** | `func_0759E8` load branch | **0x075D05+** | 0x1A | title menu opt 2 → MAPTOLOAD file dialog `call 0x763b6` @0x075D14 | **[V]** §B7 |
| 13 | — load-game backdrop | WOODPANL via load_PIK | `0x0764DC` | 0x1B | `push 0x236B(WOODPANL); lcall 0x191F:0x87A` @0x075E03 | **[V]** §B7 |
| 14 | **Enter-name / text-entry** | file/name input dialog | `0x076375`/`0x763b6` (R near) | R/0x1A | `call 0x76375` @0x075A75 (open-menu name) / `call 0x763b6` (MAPTOLOAD) | **[V]** §B7 |
| 15 | **King-audience / endgame screen** | `func_075352` (FONTKING ctx renderer) | **0x075352** | 0x1A | sets FONTKING `lcall 0x1A1F:0xA86` @0x0754F6 → runs @-menu `lcall 0x181F:0x3FE` @0x075540; tagged KINGLSS/ENGLND/FRANCE | **[V]** §B6 |
| 16 | — King/native popup sprite name | `func_06BE92` | **0x06BE92** | 0x17 | builds "KING"/"IND0A0" sheet name from channel `[0x1F5C]` | **[V]** §B6 |
| 17 | **Hall-of-Fame score reveal** | `func_03A9C0` | **0x03A9C0** | 0x06 | end-of-game scoring; WOODPAN2 backdrop, rating sprite 0x24/0x25/0x21 | **[V]** SCREEN_LAYOUTS §6 |
| 18 | — Hall-of-Fame table I/O + draw | `func_03ADA6` + `hallfame_write` | **0x03ADA6** | 0x06 | HALLFAME.DAT rb/wb; WOODPANL; 5 rows from y=0x10 | **[V]** SCREEN_LAYOUTS §6 |
| 19 | **Map / gameplay HUD** | `render_frame_setup` chain | **0x06787C** | 0x17 | main loop per frame; viewport (0,8,240,192) | **[V]** SCREEN_LAYOUTS §1 |
| 20 | — HUD chrome (menu-bar strip + frame) | `draw_map_view_chrome` `func_06083A` | **0x06083A** | 0x06 | per frame; strip fill (0,5,320) `lcall 0x181F:0x100`; frame `lcall 0x181F:0xE2` | **[V]** §B9 |
| 21 | — minimap panel | (within HUD chain) | `0x066DD7`/`0x066B9E` | 0x15 | frame (241,8,79,41); fill 39×56 | **[V]** SCREEN_LAYOUTS §1 |
| 22 | **In-game menu-BAR build** | `func_072090` | **0x072090** | 0x1A | reads `game menu` section (0x191F:0x928/0x91C); builds dropdown records | **[V]** §B10 |
| 23 | — menu-bar / dropdown RUN | `func_06E3D0` (picker) | **0x06E3D0** | 0x17 | `0x191F:0x16A` (run+hit-test); reads [0x1F54]/[0x1F5C] | **[V]** UI_FIDELITY Menus |
| 24 | — menu/dialog BUILD (@-parser) | `func_06F0F4` | **0x06F0F4** | 0x17 | `0x191F:0x182`; parses @-directive sections | **[V]** UI_FIDELITY Menus |
| 25 | **Shared popup/dialog FRAME engine** | `panel_construct` `func_06C520` | **0x06C520** | 0x17 | allocates panel; border=3 +0x46, inset=2 +0x48, minW=80 +0x28 | **[V]** §B8 / UI_FIDELITY |
| 26 | — dialog geometry finalize | `panel_finalize_geometry` `func_06D316` | **0x06D316** | 0x17 | centers (160,100); W=max(80,line+10,@width)+border | **[V]** §B8 |
| 27 | — dialog text-line builder | `func_06C850` + `func_06CCxx` | **0x06C850** | 0x17 | per-body-line width grow; +0x0A margin | **[V]** §B8 |
| 28 | — dialog frame blit (WOODFRAM) | frame painter `lcall 0x181F:0x510` | site `0x0263D6` | 0x17 | `9a 10 05 1f 18` consts (0x50,0x50,8,0xC8,0,0) rect [0x839E] | **[V]** §B8 |
| 29 | **GAME.TXT event templates (~30)** | (all share #25–#28 engine) | engine = `0x06C520`/`0x06D316` | 0x17 | event handlers push @KEY then run the shared centered-dialog | **[V]** §B8 |
| 30 | — event/report DISPATCHER | `func_0235D6` | **0x0235D6** | 0x02(R-ovl) | 27-case switch on [bp+6]=event/screen id 0..0x1A | **[V]** |
| 31 | **Reports F-key selector** | `func_0235D6` (same dispatcher) | **0x0235D6** | 0x02 | F-keys map to ids; special-case 0x1A → grid; F2-F9 bodies via 0x191F:0x3xx | **[V]** |
| 32 | — report 12-cell grid frame | `report_frame_grid` `func_06FF94` | **0x06FF94** | 0x19 | title 0xFD/0xFE; 4col×3row; cell-xy `func_06FDF0` | **[V]** SCREEN_LAYOUTS §4 |
| 33 | — F-key advisor report BODIES | (pages 05/06/12 …) | e.g. `0x0373D2`,`0x03CE28`,`0x0610B0` | 05/06/12 | `lcall 0x191F:0x3AA/0x348/0x39C` | **[sib-A]** record only |
| 34 | **Europe / harbor** | `func_031E4C` (composer) | **0x031E4C** | 0x04 | entry `func_030DBC` → load EUROPE.PIK → `mov bx,0x2B; lcall 0x181F:0x772` | **[sib-B]** record only |
| 35 | — Europe entry stub | `func_030DBC` | **0x030DBC** | 0x04 | push EUROPE.PIK key 0x0FBA @0x030DCE | **[sib-B]** |
| 36 | **Colony** | `func_028592` (composer) | **0x028592** | 0x02 | entry @0x025EC8 → load COLONY.PIK key 0x0BA0 → `mov bx,0x2C; lcall 0x181F:0x772` | **[sib-B]** record only |
| 37 | — Colony entry stub | (entry) | **0x025EC8** | 0x02 | `lcall 0x191F:0x087A` load_PIK | **[sib-B]** |
| 38 | **`enter_screen_view(id)`** (shared) | screen-state setter | **0x07004A** | 0x19 | `mov bx,<id>; lcall 0x181F:0x772`; id map below | **[V]** |
| 39 | **load_PIK** (shared backdrop loader) | PIK decompress+blit | **0x0764DC** | 0x1B | `lcall 0x191F:0x87A` (used by every full screen) | **[V]** |
| 40 | **Indexed sprite blit** (shared) | sprite engine | overlay `0x0C36:0x000A` | (B-thunk) | `lcall 0x181F:0x254`; AX=idx DX=x BX=&ctx | **[V]** UI_FIDELITY |
| 41 | **Text/number print** (shared) | generic text printer | `func_002BC8`/`func_002B38` | R | `lcall 0x181F:0x100` (centered) / `0x181F:0x13C` (clipped) | **[V]** |
| 42 | **Rect/box fill** (shared) | fill primitive | overlay `0x0B70:0x003A` | (B-thunk) | `lcall 0x181F:0xE2` | **[V]** |
| 43 | **OPENBORD decoration blit** | sprite-pair blitter | overlay `0x0BD4:0x0006` | (B-thunk) | `lcall 0x1A1F:0xDF8` | **[V]** §B1 |

**`enter_screen_view(id)` id→screen map** (from SCREEN_LAYOUTS, verified): id
0x2B=Europe, 0x2C=Colony, 0x28=report/adviser cluster, 0x2D=opening/setup.

## Index coverage summary

- **43 dispatch rows** covering every requested surface.
- **Resolved & byte-verified this pass or cross-checked against the resolver:
  41 rows.** The 2 sibling-owned bodies (rows 33, 34/36) are recorded with their
  composer offset + dispatch site per the brief, not re-decoded.
- **CORRECTIONS this pass (2026-05-31), all re-disassembled from the EXE with
  capstone CS_MODE_16:**
  - Draw-primitive semantics fixed (see the "Draw-primitive thunk semantics"
    table): `0x22`=get_string_by_index (not fill-rect), `0xCE`=1-px hollow rect
    OUTLINE (the picker selection box), `0xE2`=indexed cell blit (not h-rule),
    `0x1C8`=centered title text (not sprite tiler), `0x100`=centered text
    (confirmed). The earlier brief vocabulary was wrong on 0x22/0xE2/0x1C8.
  - **Difficulty cell-xy is `func_0702C0` (3-col, n+1 offset), NOT the shared
    nation `func_070782` (2-col).** Prior index row 10 was wrong.
  - **Picker selection boxes are 1-px hollow `0xCE` outlines** with exact rects
    (nation 87×81, difficulty 67×89) — tabulated in B2/B3 and the PORT FIXES
    selection-box summary.
  - B9 menu-bar "strip fill" was `0x100` = centered TEXT, not a color fill.
- **NEEDS VERIFICATION (0 hard-blocked surfaces).** Soft TBDs carried forward
  from the source docs (not introduced here): exact per-label x of the menu-bar
  line (falls out of the single centered string, not per-label draw-immediates);
  the OK/Cancel button SS sprite index; FONTTINY numeric line-pitch (font FF
  byte0); the exact y-pitch of the picker NAME/DESCRIPTION lines within the cell
  (the `[0x89E]` font byte0 sets it — formula cited, byte0 value is the TBD).

---

# (B) CHROME-SCREEN DRAW-LISTS (full, byte-cited)

All file offsets are into `raw/COLONIZE/VICEROY.EXE`. Sprite sheet for index
blits is named by the handle pushed before the `lcall 0x181F:0x254`/`0x22`/`0x1c8`
draw (PHYS0=[0x174], ICONS=[0x83E], BUILDING=[0x842]). DGROUP string handles
dereference at file 0x1D9A0 + handle.

> **Section numbering** matches the index rows. **B4 (Hall-of-Fame, index rows
> 17–18)** and **B5 (HUD viewport + report-grid, index rows 19/21/32)** are
> already fully byte-decoded in `SCREEN_LAYOUTS.md` §6 / §1 / §4 respectively —
> not duplicated here; the index rows carry their painter offsets + dispatch.
> The sections below decode the chrome screens that had *no* prior dedicated
> draw-list (B1 title, B2 difficulty, B3 nation, B6 king, B7 load/name/scenario,
> B8 dialog engine, B9 HUD chrome strip, B10 menu-bar).

## B1. Title / Opening-menu screen — `func_0759E8` @0x0759E8 (page 0x1A)

Composer for the title menu AND the new-game/load entry ladder. Frame is
640-byte stack frame (`ENTER 0x3F4`). Backdrop is composited to 0xA000:0x300.

### Backdrop & decoration
| order | element | source / sprite | x | y | w | h | font/color | @asm |
|---|---|---|---|---|---|---|---|---|
| 0 | menu backdrop (menu mode) | str `[0x233C]`="OPENMENU" | — | — | — | — | — | push @0x075AE4 → build `0x181F:0x44E`; off-screen buffer composite `lcall 0x0D1D:0xFB2` @0x075B1D |
| 0' | backdrop (new-game mode) | str `[0x2374]`="OPENMENU" | — | — | — | — | — | push @0x075DA3 |
| 1 | OPENBORD pair (6,7) | OPENBORD sprites 6,7 | x via `bx=0x140` | y=0xC8 | — | — | — | `push 7; push 6; lcall 0x1A1F:0xDF8` @0x075B8E |
| 2 | OPENBORD pair (8,9) | OPENBORD sprites 8,9 | " | 0xC8 | — | — | — | @0x075BB0 |
| 3 | OPENBORD pair (0xE,0xF) | OPENBORD sprites 14,15 | " | 0xC8 | — | — | — | @0x075BD2 |
| 4 | OPENBORD cursor decor | sprite-list [0x2DA8..0x2DAE] | — | 0xC8 | 0x140 | — | — | `lcall 0x181F:0x444` @0x075C00 |
| 5 | full-screen cell/sprite blit (NOT a rect-fill engine) | `0x181F:0xE2` = indexed cell blit (see primitive table) | 0 | 0 | 0x140 | 0xC8 | — | `bx=0; dx=0; push 0xC8(h); push 0x140(w); push 0(x); lcall 0x181F:0xE2` @0x075C12 |
| 6 | restore composed buffer | off-screen → 0xA000 | — | — | — | — | — | `lcall 0x181F:0x3F4` @0x075C1D |
| 7 | cursor/mode primer | id 0x33 | — | — | — | — | — | `push 0x33; lcall 0x181F:0x4DE` @0x075C28 |

### Menu run + dispatch ladder
| step | action | @asm |
|---|---|---|
| run @BEGINMENU | `lea bx,[0x2345]("BEGINMENU"); lcall 0x181F:0x3FE` (runner→`func_06F594`) returns 1-based index in AX | **0x075C60** |
| `dec ax` ladder | 1=exit (`jmp 0x75F8D`); 2=load-game; 3=setup-list; 4=new-game | **0x075C6D** |
| **opt 3 SETUP** | `lea bx,[0x234f]("AMERICA"); lcall 0x181F:0x3FE` → scenario list; then per-power init loop `[bx+0x543F]=1`, `imul 0x34`, cmp 4 | 0x075CE5 / 0x075AB4 |
| **opt 2 LOAD** | `lea bx,[0x234f]("AMERICA")` re-run + MAPTOLOAD file dialog `call 0x763b6` (args "GAME","MAPTOLOAD","*.MP") | 0x075CE5 / 0x075D14 |
| default map | str `[0x2166]`="AMER2.MP" fallback `lcall 0x0D1D:0x816` | 0x075D22 |
| **opt 4 NEW-GAME** | `lcall 0x191F:0x320` = **begin_game @0x072578** | **0x075E5F** |
| **opt 2b LOAD overlay** | WOODPANL backdrop `push 0x236B; lcall 0x191F:0x87A` (load_PIK) → frame → begin_game | 0x075E00..0x075E5F |

- **Font:** FONTINTR ([0x268A]) — title/menu text (UI_FIDELITY Fonts; build
  0x075AE4 + run 0x075C60). **[V]**
- Menu-row coords are **[layout]** (the @BEGINMENU runner lays them out — no
  fabricated literal). Sizing = the shared dialog engine (§B8).

**Spot-checks (PASS):** 0x075AE4 `68 3C 23` (push "OPENMENU"); 0x075B8E
`9a f8 0d 1f 1a` (OPENBORD blit); 0x075C12 `9a e2 00 1f 18` (frame box);
0x075C60 `8d 1e 45 23 9a fe 03 1f 18` (BEGINMENU run); 0x075E5F
`9a 20 03 1f 19` (begin_game).

## B2. Difficulty-select screen — `func_070494` @0x070494 (page 0x1A)

Modal screen: paints the title bar + 5 difficulty rows, runs its own
input loop, returns the chosen index into `[0x53A6]`. Backdrop key "DIFFICUL".
**Fully re-disassembled (continuous, across reseg split) 2026-05-31.**

### Composer draw order (`func_070494` @0x070494..0x07057F)
| order | element | source | x | y | how (byte-verified) | @asm |
|---|---|---|---|---|---|---|
| 1 | row-metric setup | FONTINTR height `[0x268A]` byte0 = `h` | — | `y0 = -(h/2 - 0x14)` (≈ small + h band) | `les bx,[0x268A]; al=es:[bx]; shr al,1; sub ax,0x14; neg ax` → `[bp-0x5A]=y0` | 0x070498..0x0704BE |
| 2 | title string fetch | str index `[0x2EFE]` | — | — | `get_string_by_index` → DX:AX | `push 0xFD;push 0xFE;push dx(y0);push 0x44;push 0x17;push [0x2EFE]; lcall 0x181F:0x22` @0x0704DE |
| 3 | title text (centered) L | (string from step 2) | centered | y0 | `push dx,ax; lcall 0x181F:0x1C8` (= draw_title_text_centered) | 0x0704E8 |
| 4 | title text (centered) R | str `[0x2F00]` | centered | `[bp-0x5E]` | second fetch+`0x1C8` | 0x0704F0..0x070510 |
| 5 | title string draw | str `[0x2EFC]` (section title) | box base x | y0 | `0x181F:0x16E`(strcat build) → `lcall 0x181F:0x100` **centered** base (0xFE,0x51) box-w 0x44 | 0x070523 / 0x07054D |
| 6 | sub-line text | str `[0x80]` | x=0x67 | — | `push 0;push 0x80(boxw);push 0x67(x);…; lcall 0x181F:0xE2` (sprite/cell blit, NOT a rule) | 0x070561 |
| 7 | **5 difficulty rows** | `func_070302` per row | grid | grid | loop `cmp [bp-0x54],5` @0x070578; body near `call 0x70c50` → thunk → **func_070302** | 0x07056B |

### Cell-coordinate formula `func_0702C0` @0x0702C0 (difficulty-ONLY; NOT func_070782)
```
n   = [bp+6]            (row index 0..4)
m   = n + 1                                      ; @0x0702C8 inc ax
col = m mod 3                                    ; idiv 3, remainder
grp = m / 3                                      ; idiv 3, quotient
x   = col·0x69 + 0x17   (105·col + 23)           ; @0x0702DA imul 0x69 / @0x0702DD add 0x17  -> *[bp+8]
y   = grp·0x60 + 7      (96·grp + 7)             ; @0x0702F2 imul 0x60 / @0x0702F7 add 7      -> *[bp+0xa]
                          (+ a -1 nudge only if grp>1, which never occurs for m≤5)
```
A **3-wide grid with cell (0,0) skipped** (because of the `n+1` offset). Per-row
base (x,y) — and the byte-verified SELECTION-BOX rect (see below):

| row | label (id order) | m | col | grp | **cell x** | **cell y** |
|---|---|---|---|---|---|---|
| 0 | Discoverer | 1 | 1 | 0 | **128** | **7** |
| 1 | Explorer | 2 | 2 | 0 | **233** | **7** |
| 2 | Conquistador | 3 | 0 | 1 | **23** | **103** |
| 3 | Governor | 4 | 1 | 1 | **128** | **103** |
| 4 | Viceroy | 5 | 2 | 1 | **233** | **103** |

### Per-row painter `func_070302` @0x070302..0x070493 (continuous)
`[bp-0x54] = cell x`, `[bp-0x56] = cell y` (written by the cell-xy helper).

| order | element | always / selected | how (byte-verified) | @asm |
|---|---|---|---|---|
| 1 | call cell-xy | always | near `call 0x70c46` → thunk 0x1A1F:0xB90 → **func_0702C0** | 0x070314 |
| 2 | **row badge/portrait base** | always | `0x181F:0x444` blit: clip `[0x839E..0x83A4]`+`[0x2DA8..0x2DAE]`, width `0x5A`, `ax=x dx=y bx=0x44`(sprite 0x44 = player-flag/portrait) | 0x07033A..0x070345 |
| 3 | per-row palette color | always | switch `n`→ `[bp-0x58]` = {0:0xA, 1:9, 2:0xE, 3:0xD, 4:0xC} (VICEROY.PAL idx) | 0x07034A..0x070378 |
| 4 | **SELECTION GATE** | — | `al=[0x53A6]; cmp ax,n; jne →skip-to-tail (0x7047C)` | 0x070378..0x070382 |
| 5 | **SELECTION BOX (hollow outline)** | **selected only** | `0x181F:0xCE` (rect outline). Regs `ax=x`, `bx=x+0x43`, `dx=y`; stack `[bp+6]=color=[bp-0x58]`, `[bp+8]=y+0x59`, clip `[0x2DA8..]`. ⇒ **rect (x, y, w=0x43=67, h=0x59=89)**, 1-px, color=per-row byte | **0x0703A0..0x0703AB** |
| 6 | difficulty NAME (centered) | selected only | str `[bx-0x7C6C]` + "+"(`0x202B`) appended; drawn TWICE (shadow at color, fg at `[bp-0x58]`) via `0x181F:0x100` box-w 0x44 at x=`[bp-0x54]+1`, y≈`0x2C - (h - y)` | 0x0703CD..0x070428 |
| 7 | difficulty DESCRIPTION (centered) | selected only | str `[si+0x2F04]`; drawn TWICE via `0x181F:0x100` box-w 0x44 at x=`[bp-0x54]+1`, y=`[bp-0x56]+0x2E` | 0x07043D..0x070474 |
| 8 | **row flag cell** | always (tail) | `0x181F:0xE2` blit: `push [bp-0x56](y); push 0x44(sheet); push 0x5A(idx); ax=x dx=y bx=x` | **0x07047C..0x07048B** |

> **Selection-box rects (difficulty), exact:** w=67 h=89 at each cell (x,y):
> Discoverer **(128, 7, 67, 89)** · Explorer **(233, 7, 67, 89)** ·
> Conquistador **(23, 103, 67, 89)** · Governor **(128, 103, 67, 89)** ·
> Viceroy **(233, 103, 67, 89)**. Color = the per-row palette byte
> {0xA,9,0xE,0xD,0xC}, NOT a fixed blue. Drawn ONLY for `[0x53A6]==row`.

### Input/run loop
- Reads `[0x53A6]` (current sel); backdrop "DIFFICUL" via `lcall 0x181F:0x44E`;
  menu descriptor `@DIFFICULTY` (str [0x2036]) staged through
  `lcall 0x181F:0x998` → result−1 → `[0x53A6]`. Wrap `(sel+4) mod 5` up /
  `sel+1` down (`idiv 5` @0x0706A1). **[V]**
- **Font:** FONTINTR (UI_FIDELITY: 0x070494 `les [0x268A]`). Names/descriptions
  use `0x181F:0x100` = **centered text**. **[V]**
- **PIK provides** the 5 painted portraits + wood backdrop ("DIFFICUL"). The code
  only adds the badge cell (0x444/0xE2), the centered title/name/descr text, and
  the hollow selection box. It does **not** redraw portraits.

**Spot-checks (PASS):** 0x070498 `c4 1e 8a 26` (les [0x268A] FONTINTR);
0x0704DE `9a 22 00 1f 18` (get_string 0x22); 0x0702DA `6b c2 69` (imul 0x69);
0x0702F2 `6b cb 60` (imul 0x60); 0x0703A5 `83 c3 43` (bx=x+0x43 box right);
0x070398 `05 59 00` (y+0x59 box bottom); 0x0703AB `9a ce 00 1f 18` (0xCE outline);
0x07048B `9a e2 00 1f 18` (0xE2 flag cell); 0x070578 `83 7e ac 05` (cmp 5 rows).

## B3. Nation-select screen — `func_07092E` @0x07092E (page 0x1A)

Twin of difficulty (same page, same engine) but a DIFFERENT grid. Paints title
bar + 4 nation rows, returns chosen index into `[0x5398]`, sets menu-mode
`[0x1F5C]=4`. Backdrop "NATIONS". **Fully re-disassembled (continuous) 2026-05-31.**

### Composer draw order (`func_07092E` @0x07092E..0x070A19)
| order | element | source | x | y | how (byte-verified) | @asm |
|---|---|---|---|---|---|---|
| 1 | row-metric setup | FONTINTR height `h` | — | `y0 = -(h/2 - 0x28)` (wider band than difficulty's 0x14) | `les bx,[0x268A]; shr al,1; sub ax,0x28; neg ax` → `[bp-0x5A]=y0` | 0x070932..0x070958 |
| 2 | title string fetch | str index `[0x2F0E]` | — | — | `get_string_by_index` → DX:AX | `push 0xFD;push 0xFE;push dx(y0);push 0x70;push 0;push [0x2F0E]; lcall 0x181F:0x22` @0x07095F→0x070977 |
| 3 | title text (centered) | (string from step 2) | centered | y0 | `push dx,ax; lcall 0x181F:0x1C8` (draw_title_text_centered) | 0x070981 |
| 4 | title text R | str `[0x2F10]` | centered | `[bp-0x5E]` | second fetch + `0x1C8` | 0x070989..0x0709A9 |
| 5 | section title string | str `[0x2EFC]` | box base x | 0xB6/y0 | `0x16E`(strcat) → `lcall 0x181F:0x100` **centered** base (0xFE,0xB6) box-w 0x70 | 0x0709C4..0x0709E7 |
| 6 | base cell blit | sheet 0x70 | 0 | y0 | `push 0;push 0x70;push 0xC8;…; lcall 0x181F:0xE2` (cell/sprite blit, NOT a fill) | 0x0709FB |
| 7 | **4 nation rows** | `func_0707B6` per row | grid | grid | loop `cmp [bp-0x54],4` @0x070A12; body near `call 0x70c5f` → thunk → **func_0707B6** | 0x070A05 |

### Cell-coordinate formula `func_070782` @0x070782 (nation-ONLY 2-col grid)
```
n   = [bp+6]                          (row index 0..3)
col = n mod 2                         ; idiv 2 remainder
row = n / 2                           ; quotient
x   = col·0x63 + 0x70   (99·col + 112)   ; @0x07079C imul 0x63 / @0x07079F add 0x70  -> *[bp+8]
y   = row·0x5B + 0x0D   (91·row + 13)    ; @0x0707A7 imul 0x5B / @0x0707AA add 0x0D  -> *[bp+0xa]
```
A **2-column grid**, 4 nations (rows 0..1). Per-row base (x,y):

| row | nation (id order) | col | row | **cell x** | **cell y** |
|---|---|---|---|---|---|
| 0 | England | 0 | 0 | **112** | **13** |
| 1 | France | 1 | 0 | **211** | **13** |
| 2 | Spain | 0 | 1 | **112** | **104** |
| 3 | Netherlands | 1 | 1 | **211** | **104** |

### Per-row painter `func_0707B6` @0x0707B6..0x07092D (continuous)
`[bp-0x54] = cell x`, `[bp-0x56] = cell y`. Guard `0 ≤ n ≤ 3` (else skip).

| order | element | always / selected | how (byte-verified) | @asm |
|---|---|---|---|---|
| 1 | call cell-xy | always | near `call 0x70c5a` → thunk 0x1A1F:0xBC8 → **func_070782** | 0x0707DA |
| 2 | **row portrait/flag base** | always | `0x181F:0x444` blit: clip `[0x839E..0x83A4]`+`[0x2DA8..0x2DAE]`, width `0x52`, `ax=x dx=y bx=0x58`(sheet 0x58) | 0x070800..0x07080B |
| 3 | read flag byte | always | `al = [bx+0x848]` (per-nation flag idx) → `[bp-0x58]` | 0x070810..0x070817 |
| 4 | **SELECTION GATE** | — | `cmp [0x5398], bx; jne →skip-to-tail (0x70916)` | 0x07081A..0x070820 |
| 5 | **SELECTION BOX (hollow outline)** | **selected only** | `0x181F:0xCE` (rect outline). Regs `ax=x`, `bx=x+0x57`, `dx=y`; stack `[bp+6]=color=al`(flag byte), `[bp+8]=y+0x51`, clip `[0x2DA8..]`. ⇒ **rect (x, y, w=0x57=87, h=0x51=81)**, 1-px, color=flag byte | **0x07083B..0x070846** |
| 6 | nation NAME (centered) | selected only | str `[bx-0x72BE]`, ":"(`0x2041`) appended; drawn TWICE (shadow+fg) via `0x181F:0x100` box-w 0x58 at x=`[bp-0x54]+1`, y=`[bp-0x52]=y+2` | 0x07085C..0x0708BC |
| 7 | nation DESCRIPTION (centered) | selected only | str `[si+0x2F14]`; drawn TWICE via `0x181F:0x100` box-w 0x58 at x=`[bp-0x54]+1`, y=`0x50 - (h - y)` | 0x0708D7..0x070913 |
| 8 | **row flag cell** | always (tail) | `0x181F:0xE2` blit: `push [bp-0x56](y); push 0x58(sheet); push 0x52(idx); ax=x dx=y bx=x` | **0x070916..0x070925** |

> **Selection-box rects (nation), exact:** w=87 h=81 at each cell (x,y):
> England **(112, 13, 87, 81)** · France **(211, 13, 87, 81)** ·
> Spain **(112, 104, 87, 81)** · Netherlands **(211, 104, 87, 81)**.
> Color = the per-nation flag byte `[bx+0x848]`, NOT a fixed red. Drawn ONLY for
> `[0x5398]==row`.

### Run loop
- Backdrop "NATIONS" `lcall 0x181F:0x44E` @0x070A42; `[0x1F5C]=4` (menu mode)
  @0x070A4E; menu descriptor `@PICKNATION` (str [0x204B]) via
  `lcall 0x181F:0x998` @0x070A5E → result−1 → `[0x5398]`.
- **Font:** FONTINTR (dialog ctx [0x268A]); name + description both via
  `0x181F:0x100` = **centered text**. **[V]**
- **PIK provides** the 4 painted flags + wood backdrop ("NATIONS"). The code only
  adds the portrait/flag cell (0x444/0xE2), the centered name/description text
  (selected row), and the hollow selection box. It does **not** redraw flags.

**Spot-checks (PASS):** 0x070A3F `68 43 20` (push "NATIONS"); 0x070A4E
`c7 06 5c 1f 04 00` (`[0x1F5C]=4`); 0x070A12 `83 7e ac 04` (cmp 4 rows);
0x070813 `8a 87 48 08` (`al=[bx+0x848]` flag byte); 0x070840 `83 c3 57`
(bx=x+0x57 box right); 0x070836 `83 c1 51` (y+0x51 box bottom);
0x070846 `9a ce 00 1f 18` (0xCE outline); 0x070925 `9a e2 00 1f 18` (0xE2 cell).

## B6. King-Audience / endgame screen — `func_075352` @0x075352 (page 0x1A)

The royal-audience dialog renderer (578 B, `ENTER 0x320`; byte-verified
2026-05-04, auto-tagged KINGLSS/ENGLND/FRANCE — it also serves the endgame
king-loss screen, str `[0x22F2]`="KINGLSS" @0x07536E). It switches the *dialog
text context* to FONTKING, overrides the dialog metric globals, runs the @-menu
(the king's choices), then restores. The body text/portrait is drawn by the
shared dialog engine using the KING.SS sheet (name built by `func_06BE92`).

### Font-context setup (the King-specific part)
| step | action | value | @asm |
|---|---|---|---|
| load FONTKING | `lea bx,[0x232B]("FONTKING"); lcall 0x1A1F:0xA86` → far ptr DX:AX | handle 0x232B | **0x0754F2** |
| set dialog font | `[0x1F9E]=ax; [0x1FA0]=dx` (dialog text ctx) | FONTKING | 0x075511 |
| save old metrics | save `[0x1F4A]/[0x1F50]/[0x1F52]` to locals | — | 0x075518 |
| **override metric X** | `[0x1F4A]=0xF2` (242) | 0xF2 | **0x075526** |
| **override metric Y** | `[0x1F50]=0x2F` (47) | 0x2F | **0x07552C** |
| override metric Z | `[0x1F52]=0` | 0 | 0x075532 |
| set flag | `[0x1F56] |= 0x18` | bit 0x18 | 0x075538 |
| run @-menu | `lcall 0x181F:0x3FE` (the king's option list) | — | **0x075540** |
| restore metrics | `[0x1F4A]=si; [0x1F50]=di; [0x1F52]=saved` | — | 0x075545 |
| restore buffer | `push 0xA000; push 0xFC00; lcall 0x181F:0x3F4` | — | 0x075558 |

### Sprite-sheet name builder `func_06BE92` @0x06BE92 (page 0x17)
- If `[0x1F5C] > 7` (king channel): `push 0x1F72("KING"); lcall 0x0D1D:0x7E4`
  builds sheet name "KING" → KING.SS; sets `[0x1F6E]=1`, `[0xA5AE]=1`,
  `[0xA5B0/0xA5B2] = lcall 0x0C0C:6 result + 0xF0`. @0x06BE9D..0x06BEC3
- Else (native advisor): `push 0x1F77("IND0A0"); lcall 0x0D1D:0x7E4` →
  IND0A0.SS, name suffixed by channel byte `[0x1F5C]` (@0x06BEF5 `add
  [bp-0x11],al`) and a tribe index (@0x06BEFB). @0x06BECA..0x06BEFE
- Tail: `call 0x6BE50` (the actual name→sheet load) @0x06BF0A.

- **Font:** FONTKING (UI_FIDELITY Fonts: load 0x0754F2 → `[0x1F9E]` 0x075511,
  metric overrides 0x075526). **[V]**
- **Sprite:** KING.SS / IND0A0.SS **by NAME** (not an index) — UI_FIDELITY
  Sprites row "King-audience". **[V]**
- **Frame/sizing:** shared dialog engine §B8 (centered, WOODFRAM frame). The
  king's choice rows are the @-menu list rows (data-driven). **[V]**

**Spot-checks (PASS):** 0x0754F2 `8d 1e 2b 23` (lea "FONTKING"); 0x0754F6
`9a 86 0a 1f 1a` (FONTKING loader); 0x075526 `c7 06 4a 1f f2 00`
(`[0x1F4A]=0xF2`); 0x06BE9D `68 72 1f` (push "KING"); 0x06BEE6 `68 77 1f`
(push "IND0A0").

## B7. Load-game / Enter-name / Scenario-list — `func_0759E8` branches

These three share the title composer's stack frame and the file/name dialogs.

### Load-game (title menu opt 2)
| step | element | source | @asm |
|---|---|---|---|
| 1 | WOODPANL backdrop | str `[0x236B]`="WOODPANL"; `lcall 0x191F:0x87A` (load_PIK → 0x0764DC) | 0x075E00 |
| 2 | outer frame | OPENBORD/decor + `lcall 0x181F:0xE2` | 0x075E1A..0x075E5A |
| 3 | begin_game | `lcall 0x191F:0x320` (→0x072578) loads the saved game | 0x075E5F |
| 4 | post-load init | `[0x829]=1`; tutorial gate `test [0x5382],1` → score path `0x181F:0x4AC`/`0x4A2` | 0x075E6C..0x075E8E |

### Enter-name / file-name dialog (used for save name + map name)
| path | dialog | strings | @asm |
|---|---|---|---|
| open-menu name | `call 0x76375` (3-arg: dest, &local, 0) | — | 0x075A75 |
| MAPTOLOAD pick | `call 0x763b6` (4-arg: "GAME", "MAPTOLOAD", "*.MP", dest) | [0x2366]/[0x235C]/[0x2357] | 0x075D14 |
| default map | str [0x2166]="AMER2.MP" copy `lcall 0x0D1D:0x7E4` | [0x2166] | 0x075D44 |

The name/file dialogs are file-selector widgets (resident near-funcs 0x76375 /
0x763b6 / 0x763c0) — they present a directory list + text-entry, sized by the
shared dialog engine. **The text-entry cursor/field draw is inside these
resident helpers; the exact per-char x-step is TBD** (not a literal in page
0x1A). The *strings* and *call sites* are byte-verified above.

### Scenario-list ("AMERICA") (title menu opt 3 = setup)
- `lea bx,[0x234f]("AMERICA"); lcall 0x181F:0x3FE` @0x075CE5 → the @AMERICA
  scenario picker (menu engine §B8/UI_FIDELITY); chosen index drives per-power
  setup loop `imul 0x34` / `[bx+0x543F]=1` @0x075AB4. **[V]**

**Spot-checks (PASS):** 0x075E03 `9a 7a 08 1f 19` (load_PIK WOODPANL); 0x075CE5
`8d 1e 4f 23` (lea "AMERICA"); 0x075D0D `68 5c 23` (push "MAPTOLOAD"); 0x075D22
`68 66 21` (push "AMER2.MP").

## B8. Shared popup / dialog FRAME engine + GAME.TXT event templates

The single centered-dialog engine used by every popup, the ~30 GAME.TXT event
templates, the King audience body, and (via the same `func_06D316`) the menu
sizing. **Fully byte-cited in `UI_FIDELITY.md` "Popups / Dialogs"** — reproduced
here as the load-bearing constants with their offsets:

### Construction — `panel_construct` func_06C520 @0x06C520 (page 0x17)
| field | role | value | @asm |
|---|---|---|---|
| `+0x46` | border thickness | `(flags&0x10)?0:3` = **3** | 0x06C5E9 |
| `+0x48` | inner inset | `(flags&0x10)?0:2` = **2** | 0x06C5F5 |
| `+0x28` | default/min content width | **0x50 (80)** | 0x06C5A6 |
| `+0x4A` | body line count | (per line) | 0x06C68D |
| alloc | panel struct 0x29 paras | `lcall 0x1A1F:0x356` | 0x06C56E |

### Line builder — func_06C850 + func_06CCxx (page 0x17)
- per body line: `line_w = text_px + sub_w + 0x0A(10)`; `[bx+0x34]=max(...)`.
  @0x06CCE3 (`add ax,0x0A`). Body margin = **10 px**. **[V]**
- text width measured via font engine `lcall 0x181F:0x204`.

### Geometry finalize — `panel_finalize_geometry` func_06D316 @0x06D316 (page 0x17)
```
content_w = max(80, longest_line_px + 10, @width)        ; @0x06D392 (max of +0x28,+0x20,+0x34)
box_w     = content_w + border(3) + per-branch pad(3..6) ; @0x06D4BA / 0x06D606 / 0x06D61D
box_h     = line_count·2 + border(3)                     ; @0x06D363 (shl 1; add [bx+0x46])
            + (title ? title_rows·metric + (match?6:3))   ; @0x06D509 (+6) / 0x06D513 (+3)
            + (options ? Σ(option_rows + 3) + 3 : 0)      ; @0x06D606 / 0x06D61D
X = (@x==-1) ? (320 - box_w)/2 : @x                       ; @0x06D522 (sar 1; sub 0xA0; neg)
Y = (@y==-1) ? (200 - box_h)/2 : @y                       ; @0x06D53B (sar 1; sub 0x64; neg)
clamp: if X+box_w>0x140 shift left; if Y+box_h>0xC8 shift up  ; @0x06D563 / 0x06D571
```
`@width` keyword string "WIDTH\0" @file **0x1F989** (a *floor*, not a clamp).

### Frame blit (WOODFRAM)
- `lcall 0x181F:0x510` (frame painter) @ site **0x0263D6** (`9a 10 05 1f 18`),
  consts (0x50,0x50,8,0xC8,0,0) + rect `[0x839E]`×2. WOODFRAM is a whole-sprite
  frame (NOT an indexed corner set). **[V]**
- **Body font: FONTTINY** ([0x89E] engine default) — UI_FIDELITY Fonts row
  "generic dialog/popup body". **[V]**
- **OK/Cancel buttons = FONTTINY TEXT** rows (the @OPTIONS list), NOT sprites.
  The button SS art index is **TBD** (UI_FIDELITY Open items). Button-row Y is
  height-reserved `rows+3` and sub-centered.

### GAME.TXT event templates (~30) — same engine
Per `EVENT_DISPATCH.md`: each European-event/native handler (e.g. @SUCCESSION
func_03C638, @SEIZURE func_03C5A8, @INVASION func_03CDA2, @TORYUPRISING
func_03CAC6, @INTERVENE func_03D510, @KINGTAX, @MULTIREV, @TOOTORY, @WAR,
@PEACE, …) **pushes its @KEY string and runs the SAME centered-dialog engine
above** — there is no per-event painter. The dispatcher `func_0235D6` (resident,
@0x0235D6) routes them; bodies that change game state live in pages 05/06
(sibling-A territory for the F-key advisor reports; the event popups themselves
are thin wrappers over §B8). The number of @-templates is data-driven from
GAME.TXT, not a code constant; `event_catalog.json` enumerates 499 message
records, of which the popup-bearing European-event set is ~30.

**Sizing constant spot-checks (all PASS, from UI_FIDELITY master table):**
0x06D522 `26 8b 47 14 d1 f8 2d a0 00 f7 d8` (X-center); 0x06D53B
`26 8b 47 16 d1 f8 2d 64 00 f7 d8` (Y-center); 0x06C5E9 border-3 idiom; 0x06C5F5
inset-2; 0x06C5A6 `26 c7 47 28 50 00` (minW 80); 0x06CCE3 `05 0a 00` (+10
margin); 0x06D363 `d1 e0 26 03 47 46` (rows·2 + border); 0x1F989
`57 49 44 54 48 00` ("WIDTH").

## B9. Map / HUD chrome — `draw_map_view_chrome` func_06083A @0x06083A (page 0x06)

The fixed-coordinate chrome around the scrolling map (the menu-bar strip + the
full-screen frame). The tile viewport itself is `render_frame_setup`
(SCREEN_LAYOUTS §1).

| element | x | y | w | h | how | @asm |
|---|---|---|---|---|---|---|
| menu-bar label LINE (centered text, **NOT a fill**) | 0 | **5** | box-w **0x140 (320)** | — | `0x181F:0x182` builds the bar string into `[bp-0x50]`, then `lcall 0x181F:0x100` (=draw_text_CENTERED_in_box) color **0x0F** | 0x060890 (build) / 0x060898 (args) / 0x0608A6 (call) |
| full-screen frame box | 0 | 0 | 0x140 | 0xC8 | `lcall 0x181F:0xE2` (cell/sprite blit) | 0x060C1E |
| map viewport | 0 | **8** | 240 | 192 | `render_frame_setup` (func_06787C) | 0x06083A → 0x06787C |
| minimap panel frame | 241 | 8 | 79 | 41 | (HUD chain, page 0x15) | 0x066DD7 |
| minimap fill | — | — | 39 | 56 | (HUD chain) | 0x066B9E |

- **CORRECTION:** the y=5 / w=0x140 / color-0x0F call at 0x0608A6 is
  `0x181F:0x100` = **draw_text_CENTERED_in_box**, not a solid strip fill. The
  string in `[bp-0x50]` is assembled by `0x181F:0x182` (the @-menu builder)
  immediately above — i.e. the menu bar is **one centered label line** (color
  palette idx 0x0F) drawn across the full 320-px width at y=5, NOT a colored
  rectangle. (The prior draw-list mislabeled `0x100` as a fill.)
- **Menu-bar height = 8 px** (text anchored y=5, viewport begins y=8). **[V]**
- **Per-label x positions** (GAME/VIEW/ORDERS/REPORTS/TRADE/CHEAT(+PEDIA)) fall
  out of the centered single-string layout — they are **frame-verified, NOT
  byte-pinned** to per-label draw-immediates. Carried forward.
- **Font:** the bar line uses the active text ctx (FONTINTR for dropdowns);
  in-game status flows through generic [0x89E]=FONTTINY default. **[V]**

**Spot-check (PASS):** 0x060898 `6a 0f 6a 05 68 40 01 6a 00`
(push 0x0F color; push 5 y; push 0x140 box-w; push 0 x) → `0x181F:0x100`
centered-text, NOT a fill.

## B10. In-game menu-BAR build + dropdown engine — func_072090 @0x072090 (page 0x1A)

Builds the dropdown command records for the top menu-bar from the `game menu`
data section, then the dropdowns RUN through the shared menu engine
(`func_06E3D0` run + `func_06D316` sizing — UI_FIDELITY Menus).

| step | action | source | @asm |
|---|---|---|---|
| open font ctx | `lcall 0x1A1F:0x2D2` (FONTINTR [0x89E]/[0x8A0] handle 0xFA0) → `[0x896]/[0x898]` | — | 0x072099..0x0720AC |
| open section | `push "game"(0x2098); push "menu"(0x209D); lcall 0x191F:0x928` (section reader → 0x06F8FA) | "game menu" | **0x0720BE** |
| read record N | `lcall 0x191F:0x91C` (record reader → 0x06F9E6) per command id | — | 0x0720D5, …loop |
| register row | `lcall 0x1A1F:0x31A` / `0x1A1F:0x33E` (add command record → 0x044B7A / 0x044D16) | — | 0x0720E4 / 0x0720FD |
| RUN dropdown | menu engine `func_06E3D0` via `0x191F:0x16A`; mode `[0x1F5C]` per command | — | (UI_FIDELITY) |

- The command ids read are sequential (0x29, 0x2A, 0x2B, … for report-grid
  path at 0x07239A; 0x316, 0x317, 0x320, 0x321, … for begin_game path at
  0x072578) — these index the `game menu` section, NOT screen coordinates.
- **Sizing = the shared dialog engine §B8** (UI_FIDELITY: same
  `func_06D316`/`func_06C520`). Dropdown origin is anchored `@x`=label-x,
  `@y`=8 (opens below the bar); centered only when `@x/@y` = -1 sentinel.
- **Font:** FONTINTR (dialog ctx) for dropdown rows. **[V]**

**Spot-checks (PASS):** 0x0720BE `68 98 20 68 9d 20` (push "game"/"menu");
0x0720C4 `9a 28 09 1f 19` (section reader 0x191F:0x928); 0x0720D5
`9a 1c 09 1f 19` (record reader 0x191F:0x91C).

---

# PORT FIXES (code-transcribed)

Audit of `colonize_sdl/render/screens.py` + `hud.py` against the byte-verified
draw-lists above. **READ-ONLY here — these are the strip-list for whoever edits
the port.** Each item is FABRICATION (invent/guess to remove) or MISMATCH
(present but wrong vs the EXE). PIK art is the backdrop in every case; the code
adds only the cell blits + centered text + the 1-px hollow selection box.

## P1. Nation-select — `_render_nation_select` (screens.py ~471–560)

The whole geometry is invented. Strip and replace with the byte-verified grid.

- **FABRICATED click/flag grid.** `quad_centers = [(175,50),(270,50),(175,130),
  (270,130)]` and `flag_w,flag_h = 90,70` are guessed. The real layout is the
  **2-col grid `func_070782`**: cell (x,y) = England (112,13), France (211,13),
  Spain (112,104), Netherlands (211,104). (`# source: needs-trace VICEROY.EXE
  NATIONS.PIK rect coordinates` on line ~521 is the admission it was guessed.)
- **FABRICATED selection outline.** `pygame.draw.rect(surf, red, rect, 2)` —
  wrong color (fixed red), wrong width (2 px), wrong rect. Correct =
  **`rect(cell_x, cell_y, 87, 81)`, 1-px hollow outline**, color = the per-nation
  palette byte `[bx+0x848]` (NOT a literal red). Drawn ONLY for the selected row.
- **FABRICATED title placement.** `f.render(surf,'Select',8,60,green)` /
  `'European Power',8,70` is LEFT-aligned at a guessed (8,60). The EXE draws the
  section title (str `[0x2EFC]`) **CENTERED** (via `0x181F:0x1C8`) on the title
  bar at the top, plus a centered `0x100` title — there is no left-aligned label.
- **FABRICATED footer.** `'(Click Here When Finished)' @ (8, H-14)` is invented;
  no such string is drawn by `func_07092E`.
- **MISMATCH name/bonus text.** Name label uses `render_centered(... opt.upper()
  + ':', cx, rect.top-9)` and a `bonuses=['Immigration',...]` list. The EXE draws
  the nation NAME (str `[bx-0x72BE]` + ":") and the nation DESCRIPTION (str
  `[si+0x2F14]`), both **centered inside the cell** (box-w 0x58) and **only for
  the selected row** — not a hand-authored bonus list. (Bonuses string is from
  the DESCRIPTION table, not a port constant.)
- **FABRICATED scaled flags.** The port scales `nation_flags` to 90×70. The EXE
  draws the flag cell via `0x444`/`0xE2` at sheet 0x58, idx/width 0x52 — but in
  practice the **flags come from NATIONS.PIK**; the code only overlays the
  selection box + selected-row text. Do not synthesize/scale flags.

## P2. Difficulty-select — `_render_difficulty` (screens.py ~562–636)

- **FABRICATED card grid.** `card_rects` with `card_w,card_h=50,80`, `top_y=30`,
  `bot_y=115`, x's {140,220,100,170,240} are guessed (`# source: needs-trace
  VICEROY.EXE - DIFFICUL.PIK card click rects`, line ~610). Correct = the
  **3-col `(n+1)`-offset grid `func_0702C0`**: Discoverer (128,7), Explorer
  (233,7), Conquistador (23,103), Governor (128,103), Viceroy (233,103).
- **FABRICATED selection outline.** `pygame.draw.rect(surf, blue, r, 2)` — wrong
  color (fixed blue), width (2 px), rect. Correct =
  **`rect(cell_x, cell_y, 67, 89)`, 1-px hollow outline**, color = the per-row
  palette byte {0xA, 9, 0xE, 0xD, 0xC} (NOT a literal blue). Selected row only.
- **FABRICATED title placement + hint.** `'Choose'@(8,28)`, `'Difficulty Level'
  @(8,38)`, `'(Click Here'@(8,80)`, `'When Finished)'@(8,90)` are LEFT-aligned at
  guessed coords. The EXE draws the section title CENTERED on the top title bar
  (`0x1C8`/`0x100`); there is no left-aligned title block or "(Click Here)" hint.
- **MISMATCH name/descriptor text.** Port uses `descriptors=['Easiest',...]` and
  `render_centered(f'{dname.upper()}:', r.centerx, r.centery-5)`. The EXE draws
  NAME (str `[bx-0x7C6C]` + "+") and DESCRIPTION (str `[si+0x2F04]`) **centered in
  the cell** (box-w 0x44), selected row only. The descriptor list is fabricated;
  it's the @DIFFICULTY description string.
- **MISSING always-drawn flag cell.** Every row draws sprite 0x44 (player flag)
  via `0x444`+`0xE2` regardless of selection. Port draws nothing for unselected
  rows (relies entirely on the PIK). This is acceptable IF the PIK already shows
  all five portraits, but the selection box/ text geometry must still match.

## P3. Main menu — `_render_main_menu` (screens.py ~371–446)

- **FABRICATED red border.** `pygame.draw.rect(surf,(168,0,0),...,1)` "red
  border" around the menu box — there is no red-border draw in the title
  composer `func_0759E8`; the box frame is the **WOODFRAM** sprite + the dialog
  engine's 3-px border (§B8), not a red rectangle. (`# cited: docs/RULINGS.md
  "dark-wood box with red border"` — that RULING is itself unverified vs the
  composer; the composer draws no `0xCE`/`0xE2` red box here.)
- **FABRICATED selected-row fill.** `pygame.draw.rect(surf,(60,35,18),(inner_x-1,
  row_y-1,content_w,row_h))` — a filled wood-brown bar. The menu engine's
  selected-row highlight is `0x181F:0xCE` = a **1-px hollow outline**, not a
  filled cell. (UI_FIDELITY's "highlight cell" wording misled this.) If a fill is
  truly wanted it must be cited to a `0xbbc`/`0xbc3` span loop, which the menu
  path does not use for the bar.
- **MISMATCH box-Y anchor.** `LOGO_BOTTOM_Y = 84` is a guessed anchor
  (`# cited: TITLE_screen ref logo letters end y~82`). The composer positions the
  menu via the dialog geometry engine (centered unless `@x/@y`), data-driven from
  @BEGINMENU — `[layout]`, not a literal 84. Acceptable as `[layout]` but should
  be flagged, not asserted as byte-true.
- OK as-is: FONTINTR font, centered/left text per the @-list, version row.

## P4. King-audience — `_render_king_audience` (screens.py ~694–767)

- **FABRICATED parchment geometry + verbatim speech.** `sx=250` scroll center,
  per-line y's (30,40,56,66,86+9·i), and the 9-line hard-coded speech
  (`'"For the greater'...`) are all invented (`# source: needs-trace`, "Verbatim
  from DOSBox screenshot"). The EXE renders the body via the **shared dialog
  engine** (§B8, centered WOODFRAM box) with FONTKING and metric overrides
  `[0x1F4A]=0xF2, [0x1F50]=0x2F` (§B6) — the text is the GAME.TXT/@-menu king
  message, NOT a port-authored paragraph, and it's laid out by the dialog
  centering, not a fixed x=250 column.
- **FABRICATED sepia ink colors.** `sepia=(60,30,10)`, `sepia_head=(40,20,5)` are
  guessed (`# source: needs-trace ... SetTextColor`). FONTKING text color is the
  dialog text ctx, not these literals.
- The PIK (KINGLSS*/KING.SS portrait) provides the throne art — that part is OK.

## P5. Hall-of-Fame — `_render_hall_of_fame` (screens.py ~839–921)

- **MISMATCH title bar fill + text.** Port fills a black bar `(0,0,320,14)` and
  centers "Hall of Fame". The byte-verified `func_03ADA6` uses the **leader-title
  bar at y=0 w=0x140 with text palette idx 0xFC** (the constants `HOF_TITLE_*`
  are already cited) — the 14-px black fill is a port addition (the title bar is a
  sprite/strip in DOS). The `_pal_rgb` path for row colors ([0x830]/[0x831]) is
  good; keep it. Title text height/positioning is `[layout]`-ish; acceptable but
  the explicit black `(0,0,0)` fill is not cited to a fill primitive.
- **MISMATCH row column x's.** `30/70/200/250` for rank/name/year/score are
  guessed; §6 only pins row0 y=0x10 and the 5-row count. Flag as `[layout]`.
- Mostly conformant; lowest-priority fixes.

## P6. Map/HUD chrome + menu-bar — `hud.py`

- **MISMATCH menu-bar background.** `_render_menu_bar` paints a **wood fill +
  black bottom rule** and per-label gold text. The EXE draws the bar as **one
  centered label line** via `0x181F:0x100` (color palette 0x0F) over a string
  built by `0x181F:0x182` (§B9) — there is no wood-fill / black-rule / per-label
  positioning in `func_06083A`. The port's note already concedes the 0x0F grey
  "is intentionally NOT drawn" because it contradicts the capture; that is a
  pixel-vs-byte conflict to resolve, but the per-label gold x-table
  (`_MENU_LABEL_X`) is explicitly **frame-verified, not byte-pinned** (correctly
  flagged). Keep the flag; do not assert the x's as byte-true.
- **FABRICATED dropdown chrome.** `_render_dropdown` draws a shadow `(10,8,5)`,
  bg `(40,30,20)`, border `(120,90,50)`, and hover fill `(70,50,30)` — all
  `# tracked: task #74` (i.e. acknowledged guesses). The EXE sizes dropdowns via
  the shared dialog engine (§B8/§B10) and highlights the hovered row with
  `0x181F:0xCE` = **1-px hollow outline**, not a filled cell. Strip the invented
  shadow/bg/border tints or cite them; replace the hover fill with the outline.
- **FABRICATED right-panel rules.** `_render_right_panel` draws a wood-shadow
  rule `(60,40,28)` above the cursor readout (`# source: palette idx 99` but no
  draw-call citation). Not in the HUD chain decode; flag as guess.
- OK: the minimap viewport white outline (1-px) and the selection-tile ring
  (PHYS0 95) are cited; leave them.

## Selection-box summary (the priority deliverable)

| screen | painter | grid helper | per-row rect (x, y, **w, h**) | outline | color source |
|---|---|---|---|---|---|
| **Nation** | func_0707B6 | func_070782 (2-col) | England (112,13,**87,81**) · France (211,13,**87,81**) · Spain (112,104,**87,81**) · Neth. (211,104,**87,81**) | `0x181F:0xCE` 1-px hollow | flag byte `[bx+0x848]` |
| **Difficulty** | func_070302 | func_0702C0 (3-col, n+1) | Discoverer (128,7,**67,89**) · Explorer (233,7,**67,89**) · Conquist. (23,103,**67,89**) · Governor (128,103,**67,89**) · Viceroy (233,103,**67,89**) | `0x181F:0xCE` 1-px hollow | per-row palette {0xA,9,0xE,0xD,0xC} |

Both: rect drawn ONLY when `[0x5398]`/`[0x53A6]` == row; width = `x + Δ`
(`Δ`=0x57 nation / 0x43 difficulty) and height = `y + Δ` (`Δ`=0x51 / 0x59);
i.e. (x, y) top-left, (w, h) as tabulated.

---

## Cross-reference notes & caveats

1. **begin_game lives at 0x072578 (page 0x1A), NOT 0x213C8.** An earlier naïve
   `resolve 0x01 0x04E8` mis-paged it. The thunk record at file 0x1B910
   (window 0x191F:0x320) carries page-id trailer 0x1A; resolving with that page
   gives 0x072090+0x04E8 = **0x072578**. Verified: the body at 0x072578 reads
   the `game` data section (record ids 0x316/0x317/0x320…) — the new-game
   initializer, in the SAME overlay page as the title composer, menu-bar
   builder, and nation/difficulty pickers. This is why all of "chrome" clusters
   in page 0x1A.

2. **Report-grid (0x191F:0x32e) = 0x07239A (page 0x1A)** is likewise a
   *descriptor-table loader* (reads `game menu` ids 0x29..), not the grid
   painter. The grid PAINTER is `func_06FF94` @0x06FF94 (page 0x19,
   SCREEN_LAYOUTS §4). The F2–F9 advisor report BODIES dispatch via
   `lcall 0x191F:0x3xx` into pages 05/06/12 (e.g. 0x0373D2, 0x03CE28, 0x0610B0)
   — **sibling-A territory**, recorded in row 33, not re-decoded here.

3. **The pickers are self-contained modal screens.** `func_070494` (difficulty)
   and `func_07092E` (nation) have no near-call caller in page 0x1A — they are
   entered via the thunk table from begin_game and run their own input loop,
   returning the chosen index in `[0x53A6]` / `[0x5398]`. They share the
   cell-coord helper `func_070782` and the FONTINTR metric setup.

4. **Sibling-owned surfaces (recorded, not re-decoded):** Europe composer
   `func_031E4C` @0x031E4C (page 0x04), entry `func_030DBC` @0x030DBC; Colony
   composer `func_028592` @0x028592 (page 0x02), entry @0x025EC8; the 9 F-key
   report bodies (pages 05/06/12). See SCREEN_LAYOUTS §2/§3 + the sibling
   agents' output.

5. **Carried-forward TBDs (from UI_FIDELITY, not new):** menu-bar per-label x
   draw-call; OK/Cancel button SS sprite index; FONTTINY numeric line-pitch
   (font FF byte0); the file/name-entry per-char cursor step. None block any
   surface in the index; all are soft "absence/leaf-not-isolated" items.

## Verification provenance

- RTLink resolver self-validation: **ALL PASS** (16 byte-checks incl. thunk
  0x1CCD0 → func_05B2C2). Tool: `tools/rtlink/rtlink_decode.py`.
- **2026-05-31 re-decode method:** every picker function and every draw-primitive
  target was re-disassembled CONTINUOUSLY (across the reseg splits that truncate
  the per-func `.asm` stubs) directly from `raw/COLONIZE/VICEROY.EXE` with
  `capstone` (CS_ARCH_X86 / CS_MODE_16). The draw-primitive thunk records were
  read raw (`9a 91 0d 0d 11 ea <off> <seg>` = type-B `JMPF seg:off`), and the
  target flat offset computed as `0x2400 + (seg<<4) + off` (resident load-image
  base), then disassembled to confirm each primitive's behavior. The near-call
  table at file 0x70C46 (`ljmp 0x1A1F:NNN`) was resolved via the thunk JSON to
  map `0x70C46→func_0702C0`, `0x70C50→func_070302`, `0x70C5A→func_070782`,
  `0x70C5F→func_0707B6` — confirming difficulty's distinct cell-xy.
- Every offset above was either (a) read from the parsed thunk table's own
  page-id trailer, or (b) confirmed against `code/VICEROY/overlay_pages.json`
  (byte-decoded segment descriptors), or (c) spot-checked against raw EXE bytes
  (the `Spot-checks (PASS)` lines).
- Existing SCREEN_LAYOUTS.md / UI_FIDELITY.md offsets were re-derived against the
  resolver and **agree** (Europe 0x031E4C, Colony 0x028592, report grid
  0x06FF94, title 0x0759E8, dialog engine 0x06C520/0x06D316, menu engine
  0x06F0F4/0x06E3D0, opt_register 0x06F594).
