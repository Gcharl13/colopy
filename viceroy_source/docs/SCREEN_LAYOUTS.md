# SCREEN LAYOUTS — coded element placement, per screen

**What this is:** the single index answering *"exactly what is placed where"* for
every VICEROY.EXE screen, from the **code** (not from eyeballing DOS captures).
Each screen links to its `src/ui/` or `src/render/` file, names the composer
function + ordered sub-renderers, and gives the byte-cited coordinate/sprite
table. Built 2026-05-30 (coded-layout pass). Companion: `UI_VERIFICATION.md`
(how to TEST), `DATA_MODEL.md` (record layouts), `MAIN_LOOP.md` (dispatch).

**Confidence tags used below:**
- **[V]** = byte-verified against `raw/COLONIZE/VICEROY.EXE` (exact file offset cited in the source).
- **[recol-xref]** = coordinate confirmed in the recol-0.2.0 clone (`docs/COLONY_RENDERER_DECODED.md`), layout-faithful, VICEROY offset not yet pinned.
- **[layout]** = position is data-driven (a runner/table lays it out); no static literal to cite.

**Screen-entry rule (verified):** each full screen is entered by a stub that loads
its `*.PIK` backdrop then calls `enter_screen_view(id)` = `mov bx,<id>; lcall
0x181F:0x772`. The id→screen map (from the call sites):

| id | screen | entry file | PIK key | code page |
|----|--------|-----------|---------|-----------|
| 0x2B | **Europe / harbor** | 0x030DEB (func_030DBC) | EUROPE 0x0FBA | page_04.asm |
| 0x2C | **Colony** | 0x025EC8 | COLONY 0x0BA0 | page_02.asm (record-1) |
| 0x28 | (report/adviser cluster) | 0x450AE | — | page 0x07 |
| 0x29 | — | 0x6D5AA | — | — |
| 0x2A | — | 0x7661F | — | — |
| 0x2D | — | 0x05E63 | — | page 0x01 |

**E3 CLOSURE (Phase 3.4, 2026-06-12) — BYTE CORRECTION.** The `0x181F:0x772`
thunk resolves to `func_077D5E_fatal_error_report_xy` (file 0x77D5E, page 29
+0x3CE), **NOT** a screen-view dispatcher.  All six ids are DIAGNOSTIC ERROR
CODES embedded in call sites within already-ported functions; `0x2B`/`0x2C` are
the screen-entry functions (the PIK+blit+reporter sequence IS the "enter screen"
idiom for those two), while `0x28`/`0x29`/`0x2A`/`0x2D` are pure diagnostic
assertions in internal geometry/loading/tile code.  The strong no-op
`overlay_call_181F_0772` in `src/ui/screen_id_map.c` closes all four.

| id | actual enclosing function | role of the call | cite |
|----|--------------------------|-----------------|------|
| 0x28 | `func_044FA4_window_measure` (overlay_04458A) | off-screen geometry assert, error 0xFFB0 | [@0x450AE V] |
| 0x29 | `func_06D316_panel_finalize_geometry` (overlay_06C220) | panel origin < 0 assert, error 0xFFAF | [@0x6D5AA V] |
| 0x2A | `func_076594_terrain_layer_load3` (overlay_0745F0) | layer-count < 3 assert, error 0xFFAE | [@0x7661F V] |
| 0x2D | `func_005E18_op_sz_120` (load_image_005DF0) | tile-ownership-write status, error 0xFFAC | [@0x05E63 V] |

---

## 1. Map / gameplay HUD  →  `src/render/hud.c`  **[V]**

The in-game view: scrolling tile map on the left, minimap + status panel on the right.

**Viewport geometry** — `render_frame_setup` (func_06787C):
- `tile_px = 0x10 >> zoom` (16 px/tile at zoom 0). [V @0x06787C ENTER 4]
- visible span = `(0xF << zoom) × (0xC << zoom)` tiles → **15×12 tiles** at zoom 0. [V @0x067884]
- map viewport rect = **(0, 8, 240, 192)** (15·16 × 12·16), centered in 320×200. [V @0x06083A ENTER 0x60]

**HUD element table:**

| Element | x | y | w | h | source |
|---|---|---|---|---|---|
| Map viewport | 0 | 8 | 240 | 192 | [V] func_06787C |
| Minimap panel (frame) | 241 | 8 | 79 | 41 | [V @0x066DD7] |
| Minimap fill (tiles drawn) | — | — | 39 | 56 | [V @0x066B9E] |
| Date / turn readout | 125 / 208 | 25 | — | — | [V] |
| Status: year / gold / tax | 244 | 58..80 | — | — | [V] |
| Message box | (below minimap) | — | — | — | [V] |
| Unit/terrain markers | per-tile | — | — | — | [V] 067082 / 067182 |

Tile chain that fills the viewport: `render/tile_chain.c` (O514→O513→O512) →
`terrain.c` / `blit.c`. **Byte-verified, 0 skeletons** (the pixel core).

---

## 2. Europe / harbor  →  `src/ui/europe_screen.c`  **[V]**

Page 0x04, screen-id 0x2B. Entry `func_030DBC`: push EUROPE.PIK key 0x0FBA
[V @0x030DCE] → load_PIK → `mov bx,0x2B; lcall enter_screen_view`.

**Composer @file 0x031E4C** (no screen-id branch — paints Europe unconditionally).
Ordered calls:

| order | sub-renderer | draws | rect / key constants | source |
|---|---|---|---|---|
| 0 | (composer head) | play-area clear | (0, 8, 320, 192) | [V @0x031E4C] |
| 1 | func_0310B4 | **16-good market bar — the BUY/SELL interface** | bar (0,179,320,21); **16 cells, stride 19**; icons ICONS.SS 23..38; gold/total readout @ (306,179) | [V: sprite-base add 0x17 @0x0310F2 / pitch add 0x13 @0x03124C / count cmp 0x10 @0x031253 / gold push 0x132 @0x031261] |
| 2 | func_030F76 | **"Selling \<Good\> at \<N\> Gold" banner** | good=[0x9E12], year=[0x538A], tax=PowerRecord+0x01 | [V] |
| 3 | func_0314DC | **dock + 6 ships + in-port list** | dock fill (143,118,81,60); list (143,81,120,69); 6 slots, ship **sprite 0x7B**; list base x=146 | [V @0x0314E1 / sprite @0x03154F] |
| 4 | func_031DC8 | **3-immigrant recruit/immigration pool** | (281,89,37,32); **3 slots**; bevel func_031BE6; labels @EUROLABEL | [V @0x031DCC / 3-slots @0x031E2B] |
| 5 | (lcall 0x181F:0xE2) | outer frame | full 320×200 | [V @0x031EA0] |

**Honest not yet decoded (resident helpers, not page 04):** banner pixel origin;
EXPECTED/BOUND/LOADING sub-panel text; the ICONS-43 boycott-X blit; the EXIT "E"
button. Each flagged in-file with the function/handle to decode next.

> **The 16-commodity bottom bar is on BOTH screens** (not a colony-vs-europe
> discriminator). func_0310B4 is a *generic* 16-cell bar (icons ICONS.SS 23..38,
> pitch 19, y=179) whose per-cell number comes from a drawing-context, not a
> hardcoded source: **Europe feeds it market PRICES (the buy/sell interface — you
> trade through it); the Colony feeds it warehouse QUANTITIES** (see §3). Same
> layout, different data. What actually pins 0x031E4C as Europe is the
> 3-immigrant recruit pool (func_031DC8) + the "Selling \<Good\> at \<N\> Gold"
> banner (func_030F76) — both Europe-only. The colony's bottom bar is its own
> page-0x03 renderer (twin of this one); the re-trace confirms it.

---

## 3. Colony  →  `src/ui/colony_screen.c`  **[V]**

Overlay record-1 (`disasm_overlay_reseg/page_02.asm`; "page 0x03" in 1-based
PIK/record numbering), screen-id 0x2C. Entry @file 0x025EC8: push COLONY.PIK key
0x0BA0 → load_PIK (lcall 0x191F:0x087A) → `mov bx,0x2C; lcall 0x181F:0x772`
(enter_screen_view). **[V]**

> **CORRECTION resolved (2026-05-30):** the first pass mis-attributed the Europe
> composer (0x031E4C) to colony. Colony is a DISTINCT screen with its own
> composer **func_028592** (the VICEROY twin of recol `paint_colony_screen`
> func_0199D8). See `docs/RULINGS.md`. All coords below are now VICEROY-byte-verified.

**Composer func_028592** → 11 sub-renderers in fixed order, dispatched via
`push cs; call 0x7Dxx/0x7Exx` → `JMP 0x191F:NNN` (trailer page-id 0x02):

| order | sub-renderer | role |
|---|---|---|
| 1 | func_025C32 | scene setup A |
| 2 | func_026374 | scene / surrounding setup B |
| 3 | (fill) | full-screen fill (0,0,320,200) |
| 4 | func_0268CE | title text (status≥4 hide gate; owner/color [bx+0x1B]) |
| 5 | func_0264A8 | mid-band field-workers / production |
| 6 | func_0270D0 | colonist row (plaza) |
| 7 | func_0281D6 | **stockpile bar (16)** |
| 8 | func_02853C | flag panel |
| 9 | func_027DB2 | surrounding-tile minimap |
| 10 | func_02814C | SoL / cargo / msg panel |
| 11 | func_02701C | buildings loop (15) |

| Element | x | y | w | h | sprite / count | source |
|---|---|---|---|---|---|---|
| Stockpile bar (warehouse qty) | 0 | 179 | 320 | 21 | ICONS 23..38, **pitch 19**, icon-Y 181, **16 cells** | [V: fill @0x0281DB / count cmp 0x10 @0x028231 / pitch add 0x13 @0x02822A / sprite add 0x17 @0x028253] |
| Stockpile gold readout | 306 | 179 | 15 | — | — | [V @0x0283F1] |
| Flag panel | 303 | 132 | 17 | 45 | flag **sprite 68 (0x44)** | [V: fill @0x02853C / sprite push 0x44 @0x028558] |
| Surrounding-tile minimap | 121 | 130 | 84 | 48 | inner box (121,132,84,57); outer loop 6 | [V @0x027DB7] |
| SoL / cargo / msg panel | 211 | 130 | 91 | 48 | mode-switch on [0x337] (3 cases) | [V @0x02814F] |
| Buildings loop | per slot | per slot | — | — | **15 slots**, BUILDING.SS | [V: count cmp 0xF @0x02707B] |

Per-slot building tables [V]: (x,y) pair @DGROUP+0x266/+0x268 stride 4; TYPE byte
@−0x729E; LEVEL byte @−0x717E (<0 = empty lot). The per-type/level **BUILDING.SS
sprite indices** (level switch 0x0F/0x11/0x13/0x14/0x30/0x2F-hex) are one leaf
deeper and remain **[recol-xref]** to `docs/COLONY_RENDERER_DECODED.md` §2.

**Note — shared bottom bar:** the colony stockpile bar (func_0281D6) is a per-page
**twin** of Europe's market bar (func_0310B4 §2): identical layout (16 cells,
pitch 19, sprite base 23, bar 0,179,320,21, gold @306,179) but distinct functions
(colony bp-0x7E/-0x6E vs europe bp-0x72/-0x68) — colony shows warehouse
quantities, Europe shows buy/sell prices.

---

## 4. Reports  →  `src/ui/report_screen.c`  **[V]**

Generic report-grid engine. Dispatcher **func_0235D6** routes the report command
(switch on `[bp+6]`, special-case 0x1A).

> **CORRECTION (2026-05-31, byte-trace):** this 12-cell grid (func_06FF94, page_19
> = record-24) is a SELECTABLE/reorderable grid screen, **NOT** the F-key advisor
> reports. The F2–F9 advisor reports dispatch via `lcall 0x191F:0x3xx` (e.g. F3
> @0x02386E) into the **blocked overlay 0x191F** — their BODIES are not
> byte-verifiable (PNG-measured only). Only the report FRAME below is byte-verified
> (frame draw primitives are resident/Type-B). See
> docs/FIDELITY_CONFORMANCE.md "Report screens — byte-trace result".

**Report frame** — `report_frame_grid` (func_06FF94):
- title bar: sprites 0xFD/0xFE, w=0x140, y=0. [V]
- header rule y=16; subtitle = str `[0x2EFC]` at (0, 190); footer rule y=183. [V @0x070003]
- body = **4-col × 3-row = 12-cell walk** (`call 0x110B` per cell).

**Cell origin formulas:**
- `report_cell_xy_4col` (func_06FDF0): **x = col·76 + 10**, **y = row·60 + 16** (−1 if row>1). [V @0x06FDF3 imul 0x4C]
- `report_cell_xy_3col` (func_0702C0): col=(n+1)%3, row=(n+1)/3, **x = col·105 + 23**, **y = row·96 + 7**. [V @0x0702DA imul 0x69]

---

## 5. Title / main menu  →  `src/ui/title_screen.c`  **[V]**

**Composer func_0759E8** (page 0x1A):
- backdrop: string handle **0x233C** (menu) / **0x2374** (new-game) → composited to 0xA000:0x300. [V @0x075AE4]
- OPENBORD decoration: sprite-pairs (6,7)(8,9)(0xE,0xF) at **x=200** (lcall 0x1A1F:0xDF8); menu-plate rule at y=0xC8, w=0x140. [V]
- menu: **@BEGINMENU key DS:0x2345** [V @0x075C60] → runner 0x181F:0x3FE → returns chosen index → dec-ax dispatch: **1=exit, 2=load, 3=setup-list, 4=new-game** (begin_game 0x191F:0x320).
- per-option rows are **[layout]** (runner lays them out — no fabricated coords).

---

## 6. Hall of Fame  →  `src/ui/hall_of_fame.c`  **[V]**

**Score reveal** — `func_03A9C0`:
- WOODPAN2 backdrop (str 0x11D7); leader title (color 0xFC, w=0x140, y=0).
- score list at **x=0xA0**, rows stacking up from **y=0xC3**; player name @ (0x8C, 0x8E); bottom rule y=0xC8.
- rating sprite **0x24 / 0x25 / 0x21** by rating (clamped 0..23, difficulty-scaled).

**Hall-of-Fame table I/O** — `func_03ADA6` + `hallfame_write`:
- **HALLFAME.DAT** (str 0x11F2 "rb" / 0x1227 "wb").
- **DOS record layout [V]: stride 0x2A (42 bytes), max 6 entries, 5 shown**, score key at +0x26, insertion `rep movsw cx=0x15`. [V @0x03AE0B imul 0x2A / @0x03B0F8 cmp 5]
- WOODPANL backdrop (0x11FF); 5 ranked rows from **y=0x10**; "--- "/" ---" separators (0x121A/0x121F); highlighted entry palette [0x831] vs [0x830].

---

## 7. Continental Congress / Founding Fathers  →  `src/ui/congress_screen.c`  **[V]**

Not behind an `enter_screen_view` id — raised by the FF chain (full map in the
`src/founding_fathers/congress.c` banner). Two entries into the composer
**func_03BB4A `cc_screen_background(power, slot)`** (0x191F:0xF74):
- acquisition: `ff_acquire_dispatch` @0x3BD1D `call cs:0x1077` (slot = new FF id);
- F3 Congress report tail @0x38073 (slot = −1, plain hall view; gates
  `[0x346]==0 && [0x9E38]==0` [V @0x38060/0x38067]).

| order | element | source / position | cite |
|---|---|---|---|
| 1 | "CCBKGD" backdrop (dg 0x1253; loader appends ".PIK" dg 0x2402) into the dialog/clip rect [0x839E..0x83A4] | full-frame (present is 0,0x140,0xC8) | [V @0x3BB6A push 0x1253 / @0x3BB6D 0x181F:0x44E] |
| 2 | content fill, rect [0x2DA8..0x2DAE] h=0xC8 w=0x140 | runtime rect | [V @0x3BBB5 0x181F:0x444] |
| 3 | portrait plates: for plate i=0..24, id = byte[0x123A+i] (**plate-order table**, a permutation of 0..24, dg 0x123A); if `ff_owned(power,id)`: load "CC-" ["0"] itoa(id) (dg 0x1234/0x1238; default ext ".SS" dg 0x23E6 in func_076642) and draw at the **coords embedded in the .SS** (es:[ent+0x46]=x / +0x48=y) | data-driven — no static x/y in code | [V @0x3BAB8 / @0x3BAD1 / @0x3BAE6 / @0x3BB36 0x181F:0x2F8; ext @0x76698] |
| 4 | new-father reveal (slot>=0): owned-bit CLEAR → draw → present → bit SET → draw → palette step 8 | two-pass | [V @0x3BBC0..0x3BC0C; bit = func_03B900] |

The **selection dialog** ("WHICHFREEDOM", func_03BFD2) and the acquire popup
("FREEDOM" via 0x181F:0x998) ride the 3.1 menu engine — rows are **[layout]**
(template @section + appended candidate rows, value = category+1 [V @0x3C1E9]).

---

## 8. Supporting layout/geometry primitives (shared)  **[V]**

These are not screens but the byte-verified geometry the screens build on:

| Function | role | key constants |
|---|---|---|
| `render_frame_setup` (06787C) | map viewport span/origin/stride/zoom | tile=0x10>>zoom; span 0xF×0xC; centered 320×200 |
| `panel_finalize_geometry` (06D316) | dialog/pop-up x/y/w/h + row stepping | 320×200-centered |
| `panel_construct` (06C520) | dialog frame build | — |
| difficulty picker (070302) | new-game difficulty rows | row stepping |
| nation picker (0707B6) | new-game nation rows | per-nation coords |

---

## Status summary

| Screen | file | composer | status |
|---|---|---|---|
| Map / HUD | render/hud.c | render_frame_setup chain | **[V] done** |
| Europe | ui/europe_screen.c | 0x031E4C (page 0x04, id 0x2B) | **[V] done** |
| Colony | ui/colony_screen.c | func_028592 (overlay record-1, id 0x2C) | **[V] done** |
| Reports | ui/report_screen.c | func_06FF94 + dispatcher 0x0235D6 | **[V] done** |
| Title / menu | ui/title_screen.c | func_0759E8 | **[V] done** |
| Hall of Fame | ui/hall_of_fame.c | func_03A9C0 / func_03ADA6 | **[V] done** |
| Continental Congress / FF | ui/congress_screen.c | func_03BB4A (+ portraits func_03BAA6; dlg func_03BFD2) | **[V] done** (2026-06-12, §7) |
| Naval adviser | (not yet decoded) | — | not yet coded |
| Opening cutscene | — | — | OUT-OF-SCOPE (separate OPENING.EXE media player) |
