# UI Render Spec — flattened draw programs for every screen

**Purpose.** Stop re-tracing the assembly. Each VICEROY.EXE screen is a tree of
calls (`composer → sub-painters → thunks → leaves → string-leaves`). This folder
collapses each screen into ONE linear, readable **draw program**: an ordered
list of plain operations (`load PIK`, `fill box`, `draw sprite`, `draw text`)
with coordinates, asset ids, colors, the data each reads, and the originating
`@asm` offset for traceability. Implement the modern painters off THESE docs —
never off raw assembly, never function-hopping.

One file per screen. Each file is the single source of truth for that screen.

## The op vocabulary (the "modern readable" primitives)

Every assembly leaf maps to exactly one of these flat ops. Columns in a draw
program: `# | OP | rect/pos | asset/id | color | data source | @asm | leaf | status`.

| OP | meaning | maps from leaf(s) | modern primitive |
|----|---------|-------------------|------------------|
| `PIK_LOAD` | load a .PIK into the draw context / backdrop buffer | `0x191F:0x87A` load_PIK | `pik_load` |
| `SHEET_LOAD` | load a .SS sprite sheet | (asset_loader) | `ss_load` |
| `SCENE_FILL` | blit the saved backdrop into a rect (restore) | `0x181F:0x444` (func_02633E) | `fill_rect`→**cc_fill_444 (todo)** |
| `FILL` | solid/textured rectangle fill | `0x181F:0x4FC`,`0x181F:0x506` | `texture_fill_rect` |
| `BOX` | 1px rectangle outline | `0x181F:0xCE` hline | `draw_box` |
| `PANEL` | filled+bordered panel (id bg) | `0x181F:0x100` | `blit_box_id` |
| `SPRITE` | blit sprite `id` from sheet at (x,y) | `0x181F:0x254` | `blit_sprite`/`ss_blit_remap` |
| `SPRITE_SH` | shadowed sprite (worker pip) | `0x181F:0x24A` | `blit_sprite_shadowed` |
| `ICON_RUN` | a run of `n` stacked icons (amount meter) | `0x181F:0x236` | `draw_icon_run` |
| `FIGURE` | colonist/unit figure blit | `0x181F:0x2BC` | `unit_figure_blit_64` |
| `TEXT` | draw a finished string at (x,y) color | `0x181F:0x13C`,`0x181F:0xB0` | `vid_text_xy` |
| `STR` | assemble a string into a buffer (name/num/concat) | `0x16E/0x178/0x182/0x1A0/0x22` | (build in C) |
| `PRESENT` | re-blit a band / flip | `0x181F:0xE2` | `blit_band`/`vid_present` |
| `LOOP` | repeat a body N times with a stride | (asm loop) | `for` |
| `IF` | conditional draw (gate) | (asm cmp/jmp) | `if` |

`status` per op: **OK** (modern leaf real) · **TODO** (leaf stubbed/unported) ·
**DATA** (needs game state not yet populated).

## Shared draw context (read by the fill/sprite/text leaves)

- `0x2DA8..0x2DAE` — active sheet/draw descriptor (es:bx for the blit leaves)
- `0x839E..0x83A4` — clip rect (x0,y0,x1,y1)
- `0x83E/0x840` — active SS sheet header far-ptr (frame width/height reads)
- `0x835` — plot/texture fill color · `0x82E`/`0x82C` — fill pattern source
- `0x89E` — resident text context (font) · style indices 7/8 = the menu gray

## Screen catalog

| # | screen | entry | composer | screen-id | backdrop | spec file | state |
|---|--------|-------|----------|-----------|----------|-----------|-------|
| 1 | Title / main menu | func_0759E8 | menu_runner | — | OPENMENU.PIK | `title.md` | DONE (matches) |
| 2 | Nation picker | — | draw_nations | — | NATIONS.PIK | `nation.md` | verify |
| 3 | Difficulty picker | — | — | — | DIFFICUL.PIK | `difficulty.md` | verify |
| 4 | Map / main view | — | func_067644 | — | terrain+wood | `map.md` | chrome partial |
| 5 | **Colony interior** | func_025EB6 | func_028592 | 0x2C | COLONY.PIK (bar) | `colony.md` | buildings DONE; rest TODO |
| 6 | Europe / dock | func_030DEB | func_031E4C | 0x2B | EUROPE.PIK | `europe.md` | partial |
| 7 | Reports | func_072090… | — | — | REPORT7.PIK | `reports.md` | TODO |
| 8 | Colonizopedia | — | — | — | CCBKGD.PIK | `pedia.md` | TODO |

## How to use

1. Pick a screen file. Read its flattened draw program top to bottom.
2. Implement/verify the modern painter so it issues exactly those ops in order.
3. For any op marked **TODO**, the leaf it maps from needs porting first — the
   op row names the leaf and the modern primitive to wire.
4. Never reopen the assembly to "check the next call" — if a detail is missing
   from the draw program, ADD it to the draw program (with its `@asm` cite), then
   implement. The doc stays the working surface.
