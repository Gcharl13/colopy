# Menus — Boot/Setup Screens & In-Game Pulldown Menu Bar

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers:
> **B** (`BYTE_VERIFIED` — func@offset / GAME-NAMES-LABELS-MENU.TXT key / recorded ruling),
> **A** (`ANCHOR_VERIFIED` — overlay/pixel-measured geometry), **R** (`RECONSTRUCTED` —
> single-frame / low-trust approximate). Never invented (un-evidenced values are simply omitted).
>
> Substantive: boot-menu items + dispatch ladder, plaque/dialog framework geometry, the
> **in-game menu-bar build + dropdown engine + per-item dispatch**, the two new-game pickers
> (nation/difficulty grids + selection-box rects), Hall-of-Fame layout + record I/O, and
> screen→background names are now **B** (func@offset byte-cited). Residuals: save/load slot
> count (dynamic file-list — no fixed `MAX_SAVE`, closed B §15.6), the per-axis setup-widget /
> LEVN-thumbnail hit-rects (R, pixel-measured from committed PIK PNGs — §10), and the
> menu-bar **per-label x** (R — falls out of one centered string, not per-label immediates — §6.4).

**Overall confidence:** boot-menu items **B** (GAME.TXT `@BEGINMENU @options` → 1–4 `dec ax`
ladder @0x075C6D); menu-plaque/dialog framework geometry **B** (`panel_construct` 0x06C520 /
`panel_finalize_geometry` 0x06D316); **in-game menu bar B** (build `func_072090` @0x072090,
chrome `draw_map_view_chrome` `func_06083A` @0x06083A, dropdown run `func_06E3D0` @0x06E3D0);
the nation/difficulty pickers **B** (`func_07092E` / `func_070494` with byte-cited grid formulas
+ 1-px hollow selection boxes); Hall-of-Fame layout + record I/O **B**; screen→background
base-names **B** (literal EXE strings). · **Canonical primary:**
`viceroy_source/docs/drawlist/CHROME_AND_DISPATCH_INDEX.md` (chrome draw-lists §B1–B10,
dispatch index rows 1–43), `viceroy_source/docs/SCREEN_LAYOUTS.md` §1/§5/§6/§7,
`viceroy_source/docs/UI_PRIMITIVES.md` (the `0x181F:NNN` draw-verb Rosetta),
`raw/COLONIZE/{VICEROY.EXE,GAME.TXT}`, `data_extracted/text/{MENU,GAME,NAMES,LABELS}_sections.json`.
**Last updated:** 2026-06-23.

> **Corrections (2026-06-23):** (a) repointed all citations that previously referenced the
> deleted `docs/RENDERER_GEOMETRY.md` / `docs/RENDER_CHAIN.md` / `docs/UI_FONT_REFERENCE.md`
> to the surviving drawlist / SCREEN_LAYOUTS / UI_PRIMITIVES sources. (b) Added the **in-game
> menu-bar dispatch chain** (§6) as the backbone, byte-cited from `CHROME_AND_DISPATCH_INDEX.md`
> §B9/§B10. (c) Added the **byte-cited new-game picker grids** + selection-box rects (§7),
> superseding the old pixel-measured R hit-rects (now kept only as a fallback in §10).
> (d) Reconciled the menu-bar hit-rect note with `map_view.md` §6.4 (mechanism B, per-item x R).

---

## 1. Overview — two distinct menu families

There are **two** menu families in VICEROY, with **separate code** and **separate text
sources**; do not conflate them.

1. **Boot / setup plaque screens** (§2–§5, §8–§10). A sequence of full-screen mode-13h PIK
   backdrops, each with wood-framed plaques driven by the **title composer `func_0759E8`**
   @0x0759E8 (page 0x1A) before the map loads. Item text comes from **GAME.TXT** (`@BEGINMENU`)
   and **NAMES/LABELS.TXT** (difficulty/nation words). Backgrounds: `OPENING.PIK` (title),
   `OPENMENU.PIK` (main menu), `CUSTOMIZ.PIK`, `DIFFICUL.PIK`, `NATIONS.PIK`, `LEVN0001..0010.PIK`
   (scenarios). **B** (`CHROME_AND_DISPATCH_INDEX.md` §B1; `docs/SESSION_UI_CATALOG.md`).

2. **In-game pulldown menu bar** (§6). The map-screen top strip (GAME / VIEW / ORDERS / REPORTS /
   TRADE / CHEAT / COLONIZOPEDIA). Built by **`func_072090`** @0x072090 (page 0x1A) from the
   `game menu` data section, drawn by the HUD chrome **`func_06083A`** @0x06083A, and run/hit-tested
   by the shared menu engine **`func_06E3D0`** @0x06E3D0. Item text comes from
   **`MENU_sections.json`** (`@GAME @VIEW @ORDERS @REPORTS @TRADE @CUP @PEDIA @END`). **B.**

Both families **share** the centered-dialog geometry engine (`panel_construct` 0x06C520 /
`panel_finalize_geometry` 0x06D316, §11) and the resident `0x181F:NNN` draw-verb library
(`UI_PRIMITIVES.md`, §11).

---

## 2. Boot-menu framework — geometry & dispatch — **B** (`func_0759E8` @0x0759E8)

The title composer (`ENTER 0x3F4`, 640-byte frame, page 0x1A) composites the backdrop, draws
the OPENBORD decoration, runs `@BEGINMENU`, and dispatches the result.

### 2.1 Backdrop & decoration (draw order) — **B** (`CHROME_AND_DISPATCH_INDEX.md` §B1)

| # | element | source / sprite | how (byte-cited) | @asm | tier |
|---|---------|-----------------|------------------|------|------|
| 0 | menu backdrop | str `[0x233C]`="OPENMENU" | build via `0x181F:0x44E`; composite to off-screen buf `0x0D1D:0xFB2` | @0x075AE4 / @0x075B1D | B |
| 0'| new-game backdrop | str `[0x2374]`="OPENMENU" | push @0x075DA3 | @0x075DA3 | B |
| 1 | OPENBORD pair (6,7) | OPENBORD sprites 6,7 | `push 7; push 6; lcall 0x1A1F:0xDF8`; x via `bx=0x140`, y=0xC8=200 | @0x075B8E | B |
| 2 | OPENBORD pair (8,9) | OPENBORD sprites 8,9 | `lcall 0x1A1F:0xDF8` | @0x075BB0 | B |
| 3 | OPENBORD pair (0xE,0xF) | OPENBORD sprites 14,15 | `lcall 0x1A1F:0xDF8` | @0x075BD2 | B |
| 4 | OPENBORD cursor decor | sprite-list `[0x2DA8..0x2DAE]` | `lcall 0x181F:0x444` (rect block-copy), y=0xC8 w=0x140 | @0x075C00 | B |
| 5 | full-screen cell blit | `0x181F:0xE2` = **clipped sprite blit** (sheet `[0x2DA8]`), not a fill | `bx=0; dx=0; push 0xC8(h); push 0x140(w); push 0(x); lcall 0x181F:0xE2` | @0x075C12 | B |
| 6 | restore composed buffer | off-screen → 0xA000 | `lcall 0x181F:0x3F4` | @0x075C1D | B |
| 7 | cursor/mode primer | id 0x33 | `push 0x33; lcall 0x181F:0x4DE` | @0x075C28 | B |

> **Primitive note (B, `UI_PRIMITIVES.md`):** `0x181F:0xE2`=`func_00DB3A` is a **clipped sprite
> blit** (sheet `[0x2DA8]`), NOT a horizontal rule; `0x181F:0x444`=`func_00DCF6` is a **rect
> block-fill/copy**; `0x181F:0x100`=`func_002BC8` is **center-text-in-box**; `0x181F:0x13C`=
> `func_002B38` is **draw-text-at-(x,y)**; `0x181F:0x22`=`func_002462` is a **string-scan helper**
> (no draw). The earlier "0x22=fill-rect / 0xE2=rule" vocabulary was wrong (RULING 2026-05-31).

### 2.2 Menu run + dispatch ladder — **B** (`CHROME_AND_DISPATCH_INDEX.md` §B1; `SCREEN_LAYOUTS.md` §5)

| step | action | @asm | tier |
|------|--------|------|------|
| run `@BEGINMENU` | `lea bx,[0x2345]("BEGINMENU"); lcall 0x181F:0x3FE` (runner → `func_06F594` @0x06F594, page 0x17) returns 1-based index in AX | **@0x075C60** | B |
| `dec ax` ladder | **1=exit** (`jmp 0x75F8D`); **2=load-game**; **3=setup/scenario-list**; **4=new-game** | **@0x075C6D** | B |
| opt 3 SETUP | `lea bx,[0x234f]("AMERICA"); lcall 0x181F:0x3FE` → `@AMERICA` scenario list; per-power init loop `[bx+0x543F]=1`, `imul 0x34` | @0x075CE5 / @0x075AB4 | B |
| opt 2 LOAD | re-run `@AMERICA` + MAPTOLOAD file dialog `call 0x763b6` (args "GAME","MAPTOLOAD","\*.MP"); WOODPANL backdrop `push 0x236B; lcall 0x191F:0x87A` | @0x075CE5 / @0x075D14 / @0x075E00 | B |
| default map | str `[0x2166]`="AMER2.MP" fallback `lcall 0x0D1D:0x816` | @0x075D22 | B |
| opt 4 NEW-GAME | `lcall 0x191F:0x320` = **`begin_game` @0x072578** (page 0x1A) | **@0x075E5F** | B |

- **Font:** boot menu/title text = **FONTINTR** (`[0x268A]`); build @0x075AE4, run @0x075C60.
  *(Note: GAME.TXT `@BEGINMENU @smallfont` sets `m->smallfont=1`, but **FONTSMAL.FF is never
  loaded** by VICEROY.EXE — RULING 2026-06-21 — so `@smallfont` selects no distinct font; the
  body renders in the active latch.)* **B** (font load) / **A** (exact `@smallfont` metric effect).
- Menu-row coordinates are **`[layout]`** (the `@BEGINMENU` runner lays them out via the dialog
  geometry engine §11 — no fabricated literal). The box is centered unless `@x/@y` are set
  (`@BEGINMENU @options @width=160 @y=91` pins y=91, centered x, width ≥160). **B (mechanism)**.
- **Spot-checks (PASS):** 0x075C60 `8d 1e 45 23 9a fe 03 1f 18` (BEGINMENU run);
  0x075E5F `9a 20 03 1f 19` (begin_game); 0x075C12 `9a e2 00 1f 18` (frame cell blit).

---

## 3. Menu-plaque colors & fonts — **B**

The four plaque colors are passed as **direct RGB** through `mr_color_for(r,g,b)` (export 48464),
which scans the live palette for the nearest entry — design-intent RGBs, not palette-index pushes:
outline **(20,12,6)**, selection bar **(56,32,16)**, text green **(82,138,49)**, selected gold
**(227,170,40)** (gold hits OPENMENU idx `0x54` exactly). **B.**
Wood panel fill = **WOODTILE.SS** tiled (plaques) / **WOODFRAM** whole-sprite frame (dialogs, §11).
Nav: ENTER 13 / ESC 27 / SPACE 32 / arrows / digit + first-letter hotkeys. **B.**

---

## 4. Main menu — **B**

- **Purpose:** entry choices after the title screen.
- **Background:** **OPENMENU** (literal EXE string `[0x233C]`@0x075AE4; composited over
  `OPENING.PIK`, decorative `OPENBORD` sprite pairs §2.1). **B** (`CHROME_AND_DISPATCH_INDEX.md`
  §B1; `docs/SESSION_UI_CATALOG.md`).
- **Items (B):** the five `@BEGINMENU @options` lines (`@width=160 @y=91`, read by
  `mr_load_section("BEGINMENU")`) — "Start a Game in NEW WORLD" / "Start a Game in AMERICA" /
  "CUSTOMIZE New World" / "LOAD Game" / "View Hall of Fame" (**GAME.TXT lines 31–42**, body in
  `GAME_sections.json @BEGINMENU`). Dispatched by the `dec ax` ladder §2.2 (1=exit/4=new-game etc;
  `menu==2` AMERICA opens the `@AMERICA` "Original Americas / Map Editor" sub-picker). **B.**
- **Tier:** background **B**; item set **B**; per-row coords `[layout]` **B (mechanism)**.

---

## 5. New-game wizard (world type / difficulty / nationality / name)

- **Purpose:** the ordered new-game setup, orchestrated by **`begin_game` @0x072578** (page 0x1A;
  reads `game menu` record ids 0x316/0x317/0x320…). **B** (`CHROME_AND_DISPATCH_INDEX.md` row 4,
  caveat 1).
- **Flow (A→B):** Customize world (§9) → Difficulty select (§7.1) → Nation select (§7.2) →
  leader-name entry. Land-naming / leader-name prompts: `GAME @LEADERNAME`, `GAME @LANDHO`
  ("Land Ho! What shall we call this new land…", `@default=America`), bodies present in
  `GAME_sections.json`. **B (keys)**.

---

## 6. In-game pulldown menu bar — **B** (the backbone)

The map-screen top strip. **This is the menu family `MENU_sections.json` describes.**

### 6.1 Build chain — `func_072090` @0x072090 (page 0x1A) — **B** (`CHROME_AND_DISPATCH_INDEX.md` §B10)

| step | action | source | @asm | tier |
|------|--------|--------|------|------|
| open font ctx | `lcall 0x1A1F:0x2D2` (FONTINTR handle 0xFA0) → `[0x896]/[0x898]` | — | @0x072099 | B |
| open section | `push "game"(0x2098); push "menu"(0x209D); lcall 0x191F:0x928` (section reader → `func_06F8FA` @0x06F8FA) | `game menu` | **@0x0720BE** | B |
| read record N | `lcall 0x191F:0x91C` (record reader → `func_06F9E6` @0x06F9E6) per command id | sequential ids | @0x0720D5 (loop) | B |
| register row | `lcall 0x1A1F:0x31A` / `0x1A1F:0x33E` (add command record → `func_044B7A` / `func_044D16`) | — | @0x0720E4 / @0x0720FD | B |
| RUN dropdown | menu engine `func_06E3D0` via `0x191F:0x16A` (run + hit-test); mode `[0x1F5C]` per command | — | (run §6.3) | B |

- The command ids read are **sequential `game menu` section indices** (e.g. 0x29,0x2A,0x2B… for
  the report-grid path @0x07239A; 0x316,0x317,0x320,0x321… for the begin_game path @0x072578) —
  these index the data section, **NOT** screen coordinates. **B.**
- **Spot-checks (PASS):** 0x0720BE `68 98 20 68 9d 20` (push "game"/"menu");
  0x0720C4 `9a 28 09 1f 19` (section reader 0x191F:0x928); 0x0720D5 `9a 1c 09 1f 19` (record reader).

### 6.2 Bar draw — `draw_map_view_chrome` `func_06083A` @0x06083A (page 0x06) — **B** (`CHROME_AND_DISPATCH_INDEX.md` §B9)

| element | x | y | w | h | how (byte-cited) | @asm | tier |
|---------|---|---|---|---|------------------|------|------|
| menu-bar label LINE | 0 | **5** | box-w **0x140 (320)** | — | `0x181F:0x182` builds the bar string into `[bp-0x50]`, then `lcall 0x181F:0x100` (= **center-text-in-box**) **color `0x0F`** | @0x060890 (build) / @0x060898 (args) / @0x0608A6 (call) | B |
| full-screen frame box | 0 | 0 | 0x140 | 0xC8 | `lcall 0x181F:0xE2` (clipped sprite/cell blit) | @0x060C1E | B |
| map viewport | 0 | **8** | 240 | 192 | `render_frame_setup` (`func_06787C`) | @0x06083A → @0x06787C | B |
| minimap panel frame | 241 | 8 | 79 | 41 | (HUD chain, page 0x15) — see `map_view.md` §6.1 | @0x066DD7 | B |

> **The menu bar is ONE centered label line**, not a colored strip-fill. The y=5 / w=0x140 /
> color-0x0F call at @0x0608A6 is `0x181F:0x100` = **center-text-in-box** over a string assembled
> by `0x181F:0x182` (the @-menu builder) immediately above. There is **no** wood-fill, black rule,
> or per-label color draw in `func_06083A`. Menu-bar height = **8 px** (text at y=5; viewport
> begins y=8). **B.** (CORRECTION 2026-05-31: a prior draw-list mislabeled `0x100` as a fill.)
> **Spot-check (PASS):** 0x060898 `6a 0f 6a 05 68 40 01 6a 00` (push 0x0F color; push 5 y;
> push 0x140 box-w; push 0 x) → `0x181F:0x100`.

### 6.3 Dropdown open / run / hit-test — `func_06E3D0` @0x06E3D0 (page 0x17) — **B**

When a bar title is clicked/hotkeyed, the **shared menu engine** `func_06E3D0` (run + hit-test,
reached via `0x191F:0x16A`; reads `[0x1F54]`/`[0x1F5C]` mode) opens the dropdown, sized by the
shared dialog geometry engine **`panel_finalize_geometry` `func_06D316`** / **`panel_construct`
`func_06C520`** (§11). Dropdown origin is anchored `@x`=label-x, `@y`=8 (opens **below** the bar);
centered only when `@x/@y` = -1 sentinel. The @-directive section is parsed by **`func_06F0F4`**
@0x06F0F4 (reached via `0x191F:0x182`). **Font = FONTINTR** (dialog ctx) for dropdown rows.
**Row highlight = `0x181F:0xCE` = a 1-px HOLLOW rectangle outline** (`func_00E0A2`-clamped, color
= the per-row palette byte), **not** a filled cell (RULING 2026-05-31). **B**
(`CHROME_AND_DISPATCH_INDEX.md` rows 22–27, §B10, P6).

### 6.4 Per-item hit-rects — mechanism **B**, exact per-item x **R**

The bar's per-title hit-rects are built by the menu/bar widget from the **FONTTINY/FONTINTR
glyph-grid title widths** — they fall out of the single centered `0x181F:0x100` label string, not
from per-label draw-immediates. So the **mechanism is B** but the **explicit x-origins are R**
(GAME@11 … COLONIZOPEDIA@261 come from the low-trust `_VICEROY_MODERN` C reconstruction, absent
from the EXE). This is the **same reconciliation as `map_view.md` §6.4** — do not assert the x's
as byte-true. **B (mechanism) / R (per-item x)** (`CHROME_AND_DISPATCH_INDEX.md` §B9, P6, caveat 5).

### 6.5 Title → pulldown-item dispatch (per-pulldown contents) — **B** (`MENU_sections.json`)

All seven titles + `@END` confirmed present in `data_extracted/text/MENU_sections.json`
(`@GAME @VIEW @ORDERS @REPORTS @TRADE @CUP @PEDIA @END`; `@CUP`'s body header is `~CHEAT`).
Item lists transcribed verbatim from the JSON bodies (`~` = hotkey-underline marker; `#` = a
value-fill placeholder):

| pulldown | items (verbatim) | tier |
|----------|------------------|------|
| **`@GAME`** (`~GAME`) | Game Options · Colony Report Options · Sound Options · Pick Music · Save Game (§8) · Load Game (§8) · **DECLARE INDEPENDENCE** · Retire · Exit to DOS | B |
| **`@VIEW`** (`~VIEW`) | ~Move Pieces · ~View Pieces · ~European Status · Find Colony · Zoom In# ~Z · Zoom Out ~X · **Zoom Level 120 x 96 / #60 x 48 / #30 x 24 / #15 x 12** · Show ~Hidden Terrain · ~Center View | B |
| **`@ORDERS`** (`~ORDERS`) | ~Activate unit · ~Wait for next unit · ~Fortify · ~Sentry · ~Build Colony · Join Colony (~B) · Clear Forest (~P) · Plow Fields (~P) · Build ~Road · ~Load Cargo · ~Unload Cargo · ~Pillage · ~Go to Port · ~Go to Place · Begin ~Trade Route · ~Return to Europe · No Orders (~s~p~a~c~e~ bar) · Dump Cargo ~Overboard · Disband Unit (~s~h~i~f~t~-~D) | B |
| **`@REPORTS`** (`~REPORTS`) | ~F~1 Terrain Information · ~F~2 Religious Adviser · ~F~3 Continental Congress · ~F~4 Labor Adviser · ~F~5 Economic Adviser · ~F~6 Colony Adviser · ~F~7 Naval Adviser · ~F~8 Foreign Affairs Advisor · ~F~9 Indian Adviser · ~F~1~0 Colonization Score | B |
| **`@TRADE`** (`~TRADE`) | Edit Trade Route · Create Trade Route · Delete Trade Route | B |
| **`@CUP`** (`~CHEAT`) | ~F~0~1 Create Unit · ~F~0~2 Debug Info Flags · ~F~0~4 Reveal Map · ~F~0~5 Set Human Player · ~F~0~6 Kill Indians · ~F~0~7 Advance Revolution Status · Sound Test · Memory Check · ~F~0~8 Show Strategy · ~F~0~9 Show Colony Sites · ~F~0~1~0 Test Routine | B |
| **`@PEDIA`** (`~COLONIZOPEDIA`) | Cargo Types · Unit Types · Terrain Types · Colonist Skills · Colony Buildings · Founding Fathers · Miscellaneous · Complete | B |
| **`@END`** | (empty section terminator) | B |

- **REPORTS** items route F1–F10 through the advisor dispatch ladder — see `advisor_reports.md`
  §3 (key codes 0x41–0x49 for F1–F9; F10 via the score path). **B.**
- VIEW zoom levels map to viewport tile counts 120×96 / 60×48 / 30×24 / 15×12 — the four `[0x184]`
  zoom states (`map_view.md` §6.2; `render_frame_setup` @0x06787C). **B.**
- **Note (binding mechanism RESOLVED; per-row handler is runtime state):** `MENU_sections.json`
  gives the verified item **text + ordering**. The "command id" each row carries is the **sequential
  `game menu` section-record index** read by `func_072090`'s loop (`0x191F:0x928` open → `0x191F:0x91C`
  record-reader `func_06F9E6` @0x06F9E6, per id 0x29,0x2A,0x2B… — `CHROME_AND_DISPATCH_INDEX.md` §B10);
  it is **the row ordinal into the data section, not a hand-coded handler pointer**. At click, the menu
  engine `func_06E3D0` @0x06E3D0 returns the **1-based selected ordinal** (`0x191F:0x16A`), which the
  map-screen input loop switch-dispatches through the event router `func_0235D6` @0x0235D6 (router on
  `[bp+6]` event/screen id). So the binding is fully mechanistically B (ordinal → section index →
  engine result → screen switch); the concrete **ordinal→game-function map for the non-report rows is
  a runtime dispatch** scattered across the screen input switch, not a single static table — enumerating
  it requires a live trace of `func_06E3D0`'s result feeding the map-input switch per pulldown.
  **B (text/order + binding mechanism) / runtime-state (per-row ordinal→handler, needs live trace)**.

---

## 7. New-game pickers (nation / difficulty) — **B** (byte-cited grids)

These two modal pickers are twins on page 0x1A (same engine, different grid), entered from
`begin_game` via the thunk table; each runs its own input loop and returns the chosen index.
**Supersedes the old pixel-measured R hit-rects (now §10 fallback only).** Source:
`CHROME_AND_DISPATCH_INDEX.md` §B2/§B3 + the Selection-box summary.

### 7.1 Difficulty select — `func_070494` @0x070494, rows `func_070302`, cell-xy `func_0702C0` — **B**

- **Background:** `DIFFICUL.PIK` (5 conquistador figures, painted into the PIK; code only adds the
  badge cell + centered text + selection box — it does **not** redraw the portraits). **B.**
- **Levels (B, NAMES `@DIFFICULTY`, in id order):** Discoverer / Explorer / Conquistador /
  Governor / Viceroy. `LABELS @MISC` carries the prompt "Choose / Difficulty Level / Level" + rank
  words Easiest/Easy/Moderate/Tough/Toughest. Returns chosen index → `[0x53A6]`. **B.**
- **Grid (B):** `func_0702C0` — `m=n+1`, `col=m%3`, `grp=m/3`, **x=col·0x69+0x17 (105·col+23)**,
  **y=grp·0x60+7 (96·grp+7)** — a 3-wide grid with cell (0,0) skipped. Per-row cell (x,y):

  | row | level | cell (x,y) | **selection-box rect (x,y,w,h)** |
  |-----|-------|-----------|----------------------------------|
  | 0 | Discoverer | (128, 7) | **(128, 7, 67, 89)** |
  | 1 | Explorer | (233, 7) | **(233, 7, 67, 89)** |
  | 2 | Conquistador | (23, 103) | **(23, 103, 67, 89)** |
  | 3 | Governor | (128, 103) | **(128, 103, 67, 89)** |
  | 4 | Viceroy | (233, 103) | **(233, 103, 67, 89)** |

- **Selection box (B):** `0x181F:0xCE` = **1-px hollow rectangle outline**, w=0x43=67, h=0x59=89,
  drawn ONLY for `[0x53A6]==row`, color = the per-row palette byte `{0xA,9,0xE,0xD,0xC}` (NOT a
  fixed blue). **Font = FONTINTR**; NAME (str `[bx-0x7C6C]`+"+") and DESCRIPTION (str `[si+0x2F04]`)
  drawn centered in the cell (box-w 0x44) for the selected row only. **B.**
  Spot-checks (PASS): 0x0702DA `6b c2 69` (imul 0x69); 0x0703AB `9a ce 00 1f 18` (0xCE outline).

### 7.2 Nationality / leader select — `func_07092E` @0x07092E, rows `func_0707B6`, cell-xy `func_070782` — **B**

- **Background:** `NATIONS.PIK` (4 flag plaques, 2×2; painted into the PIK). Sets menu-mode
  `[0x1F5C]=4`; returns chosen index → `[0x5398]`. **B.**
- **Powers (B):** `NAMES @COUNTRY` = England / France / Spain / Netherlands; `@NATIONALITY`
  English/French/Spanish/Dutch; `@HOMEPORT` London/La Rochelle/Seville/Amsterdam; `@COLONYNAME`;
  default leaders `@LEADERNAME` = Walter Raleigh / Jacques Cartier / Christopher Columbus /
  Michiel De Ruyter. `LABELS @MISC` "Select / European Power / Power" + play-style words
  Immigration/Cooperation/Conquest/Trade. Picker keys `GAME @PICKNATION`, `@PICKACARGO` present;
  per-nation flavor `GAME @NATION0A/0B..3A/3B` (all 8 bodies present in JSON). **B.**
- **Grid (B):** `func_070782` — `col=n%2`, `row=n/2`, **x=col·0x63+0x70 (99·col+112)**,
  **y=row·0x5B+0x0D (91·row+13)** — a 2-column grid. Per-row cell (x,y):

  | row | nation | cell (x,y) | **selection-box rect (x,y,w,h)** |
  |-----|--------|-----------|----------------------------------|
  | 0 | England | (112, 13) | **(112, 13, 87, 81)** |
  | 1 | France | (211, 13) | **(211, 13, 87, 81)** |
  | 2 | Spain | (112, 104) | **(112, 104, 87, 81)** |
  | 3 | Netherlands | (211, 104) | **(211, 104, 87, 81)** |

- **Selection box (B):** `0x181F:0xCE` = **1-px hollow outline**, w=0x57=87, h=0x51=81, drawn ONLY
  for `[0x5398]==row`, color = the per-nation flag byte `[bx+0x848]` (NOT a fixed red). **Font =
  FONTINTR**; NAME (str `[bx-0x72BE]`+":") and DESCRIPTION (str `[si+0x2F14]`) centered in the cell
  (box-w 0x58), selected row only. **B.**
  Spot-checks (PASS): 0x07079C `6b … 63` (imul 0x63); 0x070846 `9a ce 00 1f 18` (0xCE outline);
  0x070813 `8a 87 48 08` (al=[bx+0x848] flag byte).

---

## 8. Save / Load dialogs

- **Save (B keys):** `GAME @SAVEGAME`, `@SAVEGOOD`, `@SAVEERROR` (bodies present in JSON).
  Save-name entry uses the resident file/name dialog `call 0x76375` (@0x075A75). The per-char
  text-entry cursor advances by the helper’s **per-glyph FONTTINY width** (proportional font advance,
  not a fixed pixel step) over the latched font — the standard text-entry advance, not a bespoke
  constant (`CHROME_AND_DISPATCH_INDEX.md` §B7). **B (keys + proportional-advance mechanism).**
- **Load (B keys):** `GAME @LOADGAME`, `@LOADGOOD`, `@LOADNOT`, `@LOADOLD`, `@LOADSIZE`,
  `@LOADERROR`; map-load `@MAPTOLOAD`. The picker is the MAPTOLOAD file dialog `call 0x763b6`
  (args "GAME","MAPTOLOAD","\*.MP", @0x075D14) over a **WOODPANL** backdrop
  (`push 0x236B; lcall 0x191F:0x87A`, @0x075E00). **B (keys + call site)**.
- **Slot count:** the save/load picker is a **file-list dialog** (glob `*.MP`), overlay-resident;
  there is **no `MAX_SAVE`/10 array constant** in any decompiled body. The manual's "10" may be a
  save-name char limit, not a slot array. There is **no fixed slot count by design** — the picker is a dynamic file-list dialog that lists whatever `COLONY*.SAV`/`*.MP` files exist. **B (closed: dynamic file-list, not a `MAX_SAVE` array).**

---

## 9. Customize world (land / moisture / climate)

- **Purpose:** tune the generated map before play. **Background:** `CUSTOMIZ.PIK`. **A.**
- **Labels (B, `LABELS @MISC`):** "CUSTOMIZE NEW WORLD", "Click Here When Finished"; axes
  "Land Mass", "Land Form", "Temperature", "Climate"; values Land Mass Small/Moderate/Large;
  Land Form Archipelago/Continents (label "Normal/Continents"); Temperature Cool/Temperate/Warm;
  Climate Arid/Normal/Wet. In-popup help keys `GAME @CLAND @CCONT @CTEMP @CCLIM` (bodies present —
  e.g. `@CLAND` = "LAND MASS / Small / Normal / Large"). **B.**
- **Control geometry:** the click hit-rects are computed inside the overlay-resident Customize input
  loop, not in any exported page-0x1A body → not byte-derivable. (Correction: `0x191F:0x87A` is **NOT**
  the Customize hit-rect handler — it resolves to `func_076AEC` @0x076AEC = **`load_PIK(0,x0,y0,x1,y1,
  key)`**, the named-PIK backdrop loader, confirmed in `thunk_resolve.json` and three overlay sources;
  it only paints the CUSTOMIZ.PIK background.) The per-axis widget rects therefore stay **R** — see §10
  for the pixel-measured CUSTOMIZ.PIK fallback. **R (per-axis rects) / B (`0x191F:0x87A` = load_PIK, not
  the rect handler)**.

---

## 10. Pixel-measured fallback hit-rects (R) — Customize / scenario thumbnails only

> For Customize (§9) and scenario thumbnails (§10.1), no byte-cited grid exists (the handlers are
> overlay-resident). These are the **best-available R** rects, pixel-measured 2026-06-21 from the
> committed `docs/atlas/pik/*.png` backgrounds (native 320×200, widget art baked into each PIK,
> ±2px). For **difficulty and nation**, use the **byte-cited grids §7 (B)** instead — the old
> pixel-measured difficulty/nation rects are retired.

- **CUSTOMIZ.PIK** — 4-axis × 3-value grid of map thumbnails, **~62×42** each: columns
  `x≈{15, 91, 167, 244}` (Land Mass / Land Form / Temperature / Climate), rows `y≈{20, 79, 138}`.
  Tier **R**.

### 10.1 Scenario select (LEVN*.PIK) — A (assets); no thumbnail grid

- **Assets (A):** `LEVN0001..LEVN0010.PIK` are **full-screen 320×200 previews**, not pre-tiled
  thumbnails. Scenario data `NAMES @SCENARIO` (AMER2 / AMERICA, **B**). Reached via the title
  `dec ax` opt-3 `@AMERICA` scenario list (§2.2). **A / B.**
- **No thumbnail grid (closed, B/A):** the `LEVN*.PIK` are **full-screen 320×200 previews** shown
  one at a time, selected from the `@AMERICA`/`@SCENARIO` text list (§2.2) — there is no tiled grid
  to lay out, so the earlier "grid geometry" question is moot.

---

## 11. Shared dialog / plaque geometry engine — **B** (used by both families)

Every boot plaque, every dropdown, every GAME.TXT event popup, and the King-audience body share
this centered-dialog engine (`CHROME_AND_DISPATCH_INDEX.md` §B8; `SCREEN_LAYOUTS.md` §7).

- **Construction — `panel_construct` `func_06C520` @0x06C520:** border `+0x46`=**3** (@0x06C5E9),
  inset `+0x48`=**2** (@0x06C5F5), default/min content width `+0x28`=**0x50 (80)** (@0x06C5A6),
  alloc `lcall 0x1A1F:0x356`. **B.**
- **Line builder — `func_06C850`:** per body line `line_w = text_px + sub_w + 0x0A (10)` (margin
  10px @0x06CCE3); text width via `0x181F:0x204`. **B.**
- **Geometry finalize — `panel_finalize_geometry` `func_06D316` @0x06D316:**
  `content_w = max(80, longest_line_px+10, @width)` (@0x06D392);
  `box_h = line_count·2 + 3 (+ title rows + Σ option rows)` (@0x06D363);
  `X = (@x==-1)?(320-box_w)/2:@x` (@0x06D522); `Y = (@y==-1)?(200-box_h)/2:@y` (@0x06D53B);
  clamp shifts if `X+box_w>0x140` / `Y+box_h>0xC8`. `@width` keyword string "WIDTH\0" @file
  0x1F989 is a **floor**, not a clamp. **B.**
- **Frame blit:** `lcall 0x181F:0x510` (WOODFRAM whole-sprite frame) @site 0x0263D6, consts
  (0x50,0x50,8,0xC8,0,0). **Body font = FONTTINY** (`[0x89E]` engine default) for generic popups;
  **FONTINTR** for the boot menu/pickers/dropdowns (dialog ctx `[0x268A]`). **B.**
- **OK/Cancel buttons** = FONTTINY text rows (the `@OPTIONS` list), NOT sprites; the modal
  "wait for OK / keypress" loop is `0x181F:0x3C0` (`func_004A80`) which **draws nothing** (the box
  + label are painted by the builder first). **There is NO OK/Cancel button SS sprite:** the modal
  wait `func_004A80` @0x004A80 (`0x181F:0x3C0`) was disassembled in full (0x004A80..0x004AF8, RETF)
  and contains **only** input-poll lcalls — `0xC0C:6` (mouse), `0x29F:0xF6` (kbhit), `0xACB:0x30/0x56/
  0x11A` + `0xAE7:2/0x16` (event/key) — and **no blit verb** (`0x181F:0xE2/0x254/0x444`) and no text
  verb. The OK/Cancel affordance is the `@OPTIONS` FONTTINY text rows painted by the panel builder
  beforehand; a button SS art index does not exist. **B (no-sprite, byte-proven `func_004A80`)**.

### 11.1 Resident draw-verb library (`0x181F:NNN`) cited above — **B** (`UI_PRIMITIVES.md`)

| `0x181F:` | func @file | role |
|-----------|-----------|------|
| 0x022 | `func_002462` @0x2462 | string-scan helper (memchr/strlen) — **no draw** |
| 0x0CE | `func_00E0A2` @0xE0A2 | min/order-2 clamp (used for the `0xCE`-path selection-box bounds) |
| 0x0E2 | `func_00DB3A` @0xDB3A | **clipped sprite blit** (sheet `[0x2DA8]`) |
| 0x100 | `func_002BC8` @0x2BC8 | **center-text-in-box** (the menu-bar line; FONTTINY) |
| 0x114 | `func_002AC6` @0x2AC6 | measure string width |
| 0x13C | `func_002B38` @0x2B38 | draw text at explicit (x,y), left-aligned |
| 0x16E | `func_002992` @0x2992 | strcat into shared buffer |
| 0x182 | `func_0029DE` @0x29DE | append number (builds the bar string) |
| 0x1C8 | `func_002CE0` @0x2CE0 | center-text-in-box (styled variant; picker titles) |
| 0x254 | `func_00E76A` @0xE76A | blit one sprite (index bit15 = H-mirror) |
| 0x444 | `func_00DCF6` @0xDCF6 | rect block-fill / copy (2-D) |
| 0x484 | `func_00DCD4` @0xDCD4 | horizontal solid-color span fill (closest to a "rule") |
| 0x3C0 | `func_004A80` @0x4A80 | modal wait-for-OK/keypress loop — **draws nothing** |

> The selection-box outline `0x181F:0xCE` cited in §6.3/§7 resolves (in `CHROME_AND_DISPATCH_INDEX.md`
> §"Draw-primitive thunk semantics") to **`func_00E0A2`-clamped → a 1-px hollow rectangle outline**
> drawn via the h-span/v-span helpers `0xBBC:0xC` (h-span) + `0xBC3:6` (v-span); color = the per-row
> palette byte. **B.**

---

## 12. Hall of Fame — **B**

- **Purpose:** high-score / retired-leader roster.
- **Title/columns (B):** `LABELS @MISC` "COLONIZATION HALL OF FAME"; columns "President",
  "General, Continental Army", "Leader", "Score", "Colonization_Rating", "A.D.". Retirement keys
  `GAME @RETIRE @RETIRING @RETIRING2 @SOONRETIRING0/1` (bodies present in JSON). **B.**
- **Background/geometry (B):** there is **no HoF PIK** — `func_03A9C0` @0x03A9C0 (`@file 0x3AC..`,
  `SCREEN_LAYOUTS.md` §6) draws the score-reveal on the procedural **WOODPAN2** (str `0x11D7`) and
  the table on **WOODPANL** (str `0x11FF`). Font = **FONTINTR** (`[0x268A]`; not FONTKING — RULING
  2026-06-21). Title color `0xFC`→gold (`[0x831]` hilite); score/rating bars x=0xA0, rows stack up
  from y=0xC3; player name @ (0x8C,0x8E); bottom rule y=0xC8. Trophy sprite **0x24** (rating≥0x17) /
  **0x21** (≤6) / **0x25** (else), difficulty-scaled, clamped 0..23. Table rows (`func_03ADA6`):
  start y=0x10, 5 ranked rows, "--- "/" ---" separators (str 0x121A/0x121F); highlighted entry
  palette `[0x831]` vs `[0x830]`. **B.**
- **Record I/O — B (`func_03ADA6` @0x03ADA6):** `HALLFAME.DAT` (str 0x11F2 "rb" / 0x1227 "wb"),
  record stride **0x2A (42)** (@0x03AE0B `imul 0x2A`), **max 6 entries, 5 shown** (@0x03B0F8
  `cmp 5`); **score = int16 @ record +0x26**, descending insertion-sort (`rep movsw cx=0x15`).
  (Cross-ref `spec/systems/save.md` §6.5.) **B.**

---

## 13. Interactions

- **Boot menu:** ENTER/ESC/SPACE/arrows + digit + first-letter hotkeys (§3). The `@BEGINMENU`
  runner returns a 1-based index → `dec ax` ladder §2.2. **B.**
- **In-game bar:** click a title (or hotkey) → dropdown opens below the bar via `func_06E3D0`
  (§6.3); hovered row highlighted by the `0x181F:0xCE` 1-px outline; selecting a row routes through
  the dispatcher `func_0235D6` / the `game menu` command-id table (§6.1). `func_0235D6` @0x0235D6 is
  byte-confirmed a **screen/event router** keyed on `[bp+6]` (screen-id ladder: cmp 0x1a, dec-ax
  cases @0x0235EF→0x235FE/3606/360E/3616, default jmp 0x23dc8) — it routes the engine's selected
  ordinal to a per-screen sub-handler, so the binding is fully mechanistically B and the concrete
  ordinal→handler map is **runtime-state scattered across the per-screen input switches** (no single
  static table). **B (mechanism, byte-cited `func_0235D6`) / runtime-state (per-row ordinal→handler)**.
- **Pickers:** difficulty/nation pickers are self-contained modal loops (own input loop, return
  index in `[0x53A6]` / `[0x5398]`); arrows wrap `(sel±1) mod count`. **B.**
- **REPORTS pulldown / F1–F10** → advisor screens (`advisor_reports.md`). **B.**

---

## 14. Evidence

- `viceroy_source/docs/drawlist/CHROME_AND_DISPATCH_INDEX.md` — **primary**. Master dispatch index
  (rows 1–43), §B1 title/boot menu, §B2 difficulty, §B3 nation, §B7 load/name/scenario, §B8 dialog
  engine, §B9 HUD chrome + menu-bar line, §B10 in-game menu-bar build + dropdown engine; the
  Draw-primitive thunk-semantics table; Selection-box summary. **B.**
- `viceroy_source/docs/SCREEN_LAYOUTS.md` — §5 title/main menu, §6 Hall of Fame, §7 supporting
  geometry primitives, §1 map HUD strip. **B.**
- `viceroy_source/docs/UI_PRIMITIVES.md` — the resident `0x181F:NNN` draw-verb Rosetta (font latch
  `[0x89E]` FONTTINY; the centered-text / blit / fill / wait verbs). **B.**
- `data_extracted/text/MENU_sections.json` — in-game bar `@GAME @VIEW @ORDERS @REPORTS @TRADE @CUP
  @PEDIA @END` (full per-pulldown item text, §6.5 — grep-verified present). **B.**
- `data_extracted/text/GAME_sections.json` — `@BEGINMENU @SAVEGAME @LOADGAME @PICKNATION
  @DIFFICULTY @LEADERNAME @RETIRE @LANDHO @CLAND @CCONT @CTEMP @CCLIM @NATION0A..3B` (bodies
  present). **B.**
- `data_extracted/text/NAMES_sections.json` — `@DIFFICULTY @COUNTRY @NATIONALITY @HOMEPORT
  @LEADERNAME @SCENARIO`. **B.**
- `data_extracted/text/LABELS_sections.json` `@MISC` — "CUSTOMIZE NEW WORLD", difficulty/
  temperature/climate/land-form value words, "Select European Power", "COLONIZATION HALL OF FAME"
  + columns. **B.**
- `docs/SESSION_UI_CATALOG.md` — `OPENING/OPENMENU/CUSTOMIZ/DIFFICUL/NATIONS/LEVN*` PIK visual
  identification. **A.**
- *(NOT cited — deleted in the 2026-06-22 cleanup: `docs/RENDERER_GEOMETRY.md`,
  `docs/RENDER_CHAIN.md`, `docs/UI_FONT_REFERENCE.md`. Any geometry they once carried is now
  byte-cited from the drawlist / SCREEN_LAYOUTS / UI_PRIMITIVES sources above.)*

---

## 15. Open questions (resolved-with-citation)

1. ✅ **In-game menu-bar build + dropdown dispatch — RESOLVED (B).** Build `func_072090`
   @0x072090, draw `func_06083A` @0x06083A (one centered `0x181F:0x100` label line, color 0x0F,
   y=5), run/hit-test `func_06E3D0` @0x06E3D0, parse `func_06F0F4` @0x06F0F4, size via
   `func_06D316`/`func_06C520` (§6, §11). Item text = `MENU_sections.json` (§6.5). **B.**
2. ✅ **New-game picker grids + selection boxes — RESOLVED (B).** Difficulty `func_0702C0`
   (3-col, n+1 offset), nation `func_070782` (2-col); 1-px hollow `0x181F:0xCE` selection-box rects
   tabulated (§7), color = per-row palette/flag byte. Supersedes the old pixel-measured R rects.
3. ✅ **Hall-of-Fame background+geometry+record I/O — RESOLVED (B).** Procedural WOODPAN2/WOODPANL,
   `func_03A9C0`/`func_03ADA6`, HALLFAME.DAT 5×0x2A=210 (§12).
4. **Menu-bar per-item x-origins** — built from glyph-grid title widths (mechanism **B**), but the
   explicit per-label x's are **R** (C-recon, absent from EXE). Reconciled with `map_view.md` §6.4.
   Tightening to B requires disassembling the bar widget's per-label layout (it currently falls out
   of one centered string). **B (mechanism) / R (per-item x)**.
5. **Per-row command-id binding for the non-report pulldown items** — the item **text + order** are
   B (`MENU_sections.json`); the exact `game menu` command-id each row dispatches (and its handler)
   is data-driven and resolved-as-state: each row carries its **sequential `game menu` section-record
   index** (read by `func_072090`'s `0x191F:0x91C` loop, `func_06F9E6` @0x06F9E6); at click the engine
   `func_06E3D0` @0x06E3D0 returns the 1-based ordinal, which the screen router `func_0235D6` @0x0235D6
   switch-dispatches per screen-id — so the ordinal→handler mapping is **runtime dispatch in the
   per-screen input switches, with no single static per-row table** (only the F1–F10 report ladder is
   statically pinned). **B (mechanism) / runtime-state (per-row ordinal→handler)**.
6. **Save/load slot count — CLOSED (B).** It is a **dynamic file-list** dialog (glob `*.MP`/`COLONY*.SAV`):
   it enumerates the save files that exist, so there is no fixed `MAX_SAVE` array — by design. The
   manual’s "10" is the save-**name** char limit, not a slot count.
7. **Customize widget rects (R, §10, pixel-measured); cursor step + OK/Cancel button — CLOSED (B).**
   The text-entry cursor step is the **FONTTINY proportional glyph advance** (§8, not a fixed constant);
   the OK/Cancel buttons have **no SS sprite** — they are FONTTINY text rows (`func_004A80` modal-wait
   draws nothing, shared with `context_dialogs.md` §7).
8. **Scenario-select (LEVN*.PIK) — no grid (CLOSED, §10.1).** The `LEVN*.PIK` are full-screen 320×200
   previews shown one at a time (no tiled thumbnail grid), selected from the `@AMERICA`/`@SCENARIO`
   text list. There is no grid geometry to measure. **A (assets) / B (no-grid, closed).**
</content>
</invoke>
