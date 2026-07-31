# Map Editor (MAPEDIT.EXE)

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.
> The editor is a **separate program** (MAPEDIT.EXE, 145,292 B) sharing the MADS
> engine + assets with VICEROY (viceroy.pal, TERRAIN.SS, PHYS0.SS, ICONS.SS,
> WOODTILE.SS, FONTINTR, FONTTINY, CURSOR.SS). It ships **CodeView NB02 debug
> info** — every function below is cited by its REAL name from
> `data_extracted/mapedit_symbols.json` (file_offset = seg·16 + off + 0x1600);
> listings in `code/MAPEDIT/disasm_named/<module>.asm`. File format:
> `formats/MP_FORMAT.md` (rewritten 2026-07-30 from this EXE's writer —
> see RULINGS.md). Sections marked *(pending)* are being decoded.

**Text data**: `data_extracted/text/MAPEDIT_sections.json` (19 dialog sections)
and `MAPMENU_sections.json` (4 pulldowns, 25 rows). ⚠ The retail MAPEDIT.TXT /
MAPMENU.TXT files are **not in `raw/COLONIZE/`** — the extracted JSON is the
wording source; the EXE cites sections by name only.

## 1. Startup & command line (B)

- `_main` @0x3ED8: args starting `-`/`/` → per-char `_flag_parse` @0x3E72
  (**`-c`** → `_create_me_now`=1 force-create; **`-m:file`** →
  `_map_name`←file, `_map_selected`=1; others ignored); an arg starting `?` →
  `_show_flags` @0x3DF6 (usage text at DS:0x3AA..0x487) and exit. Otherwise
  `_viceroy_game` @0x3B16. Exit prints `"Exit value: %d\n"` if
  `_exit_value`≠0.
- `_viceroy_game` init order (each failure sets a distinct `_exit_value`):
  video **mode 0x13** (MCGA 320×200) @0x3B2E; palette `viceroy.pal` (0x13);
  two 320×200 work buffers `_scr_work`/`_scr_orig` (0x14); `fontintr` →
  `_font_inter` (0x15); `fonttiny` → `_menu_font` (0x16);
  **`_load_terrain_tiles` @0xB152**: sheet `"terrain"` = TERRAIN.SS → 12-frame
  16×16 flat array `_terrain_1` (0x321/0x322) — *corroborates hard rule 5*;
  `cursor` (0x17); `"phys0"` → `_tiles`/`_tiles2` (0x18); `icons` (0x19);
  `woodtile` → 32×24 `_scr_back` used as popup/menu/main background tile
  (0x1A/0x1B); `_get_tile_colors`; `_load_data` @0x3936; 12,000-byte undo
  buffer `_map_undo_memory` (`_undo_available`=1) @0x3D6E; `_start_new_game`
  @0x3A7A; main loop `_turn_control_loop` @0x38B0.
- `_load_data` @0x3936 reads **NAMES.TXT**: `@UNFORESTED`→terrain records
  0..7, `@FORESTED`→8..15 (16..23 memcpy aliases @0x39B1–0x39CD), `@OTHER`→
  24..28 (Arctic/Ocean/Sea Lane/Mountains/Hills — *corroborates hard rules
  1/2*), `@OTHER_NAMES`→`_terrain_names` ("Forest/River/Major River/Minor
  River/Unexplored"), `@COLORS`→9 palette-index globals (`_basic_color`,
  `_hilite_color`, `_grey_color`, `_enhance_color`, `_shadow_color`,
  `_select_color`, `_border0/1/2` [0x92..0x9B]) propagated by
  `_popups_normal` @0x1618. Terrain record = 16 bytes: +0 name ptr, +2/3/4
  three numbers, +7..+15 nine numbers (13th NAMES column unread).
- **MAPMENU.TXT** → `_construct_mapedit_menu` @0x1796: sections `@GAME`
  (Editor), `@VIEW`, `@CUP` (Map), `@HELP`; items get hard-coded event ids at
  the `_menu_add_item` sites (0x13 SaveAs, 0x14 New, 0x1A Save, 0x1B Load,
  0x1F Exit, 0x24–0x2B zooms, 0x4A–0x4E map ops, 0x51+ help).

## 2. Session flow (B)

`_start_new_game` @0x3A7A:
- No `-m`/`-c` → **file picker** `_file_menu("MAPEDIT","MAPTOEDIT","*.MP")`
  @0x3A8C ("Select Map File to Edit / (ESC to create new map)"); ESC/cancel →
  create path.
- Defaults `_map_file` w=58, h=72 @0x3AB5; `@map_startup` allocates four
  0x2EE0-byte layer buffers (terrain/feature/continent + memory-only
  `_site`).
- Create: `_create_me` @0x2BFC — **name-entry popup** ("MAPEDIT"/"NEWNAME",
  default `UNTITLED.MP`, max 0x14 chars) → `_create_blank_map(58,72)`
  (hard-coded size; all-Ocean fill 0x19, version=4) → `_map_changes`=1.
  **There is NO map-size picker and NO procedural generation in MAPEDIT.**
- Load: `_load_map_file` @0xB700 (validation + error codes in
  `formats/MP_FORMAT.md`) → **`_forest_fix` @0x16B6** (normalizes ids
  16..23→8..15, strips forest under mtn/hill overlay).
- Both: cursor + view centered at (w/2, h/2).

`_file_menu` @0x1B6A: DOS findfirst/findnext on the pattern; pages of 10
(13-byte name slots at DS:0x64F0); "(More)" pager rows (codes 0x61/0x62);
result → `_file_select`.

## 3. File-menu commands (`_execute_menu_event` @0x2DE0, jump table file 0x2DFC) (B)

| id | item | flow |
|---|---|---|
| 0x1A | Save | confirm popup `@SAVE` (proceed on answer 1) → `_write_map_file` → fail: `@ERROR` popup; ok: `_map_changes`=0 @0x2F8E |
| 0x13 | Save As | strip path, string popup `@SAVEAS` (14 chars), force ext "MP", write @0x2EAC |
| 0x1B | Load | if `_map_changes` → confirm `@LOAD`; `_file_menu(@MAPTOLOAD,"*.MP")`; load; `_forest_fix`; recenter @0x2FD4 |
| 0x14 | Create | if `_map_changes` → confirm `@CREATENOW`; `_create_me`; recenter + `_new_mini` @0x2F24 |
| 0x1F | Exit | if `_map_changes` → 3-way `@EXIT` (exit unsaved / save+exit / cancel) @0x305E |
| 0x4A | Find Continents | `_continent_check` @0x2C70: `_map_find_continents` @0xB242 (two flood passes; labels 1..15 into layer-3 low nibbles; >15 land → `@CONTINENTS1` popup, >15 water → `@CONTINENTS2`), then full-screen continent-id view (Ocean/Sea-Lane blanked), any key restores |
| 0x4D | Coastline Protect | toggles `_coastline_protect` [0x4E] — edit-time guard: painting terrain onto Ocean/Sea-Lane tiles is skipped while ON (`_change_map` @0x3265–0x327D); mtn/hill or-bit always blocked on water @0x328B |
| — | Memory check | `_memory_check` @0x2BCC — popup from file "DEBUG" section `@MEMORY` |

| 0x24/0x25 | Zoom In ~Z / Out ~X | `_set_zoom_level(_map_scale ∓ 1)` @0x30C2/@0x30D2 |
| 0x26–0x29 | F1..F4 zoom rows | `_set_zoom_level(0x29−id)` → F1=3 (120×96) … F4=0 (15×12), clamp 0..3 @0x30D8/@0x2B8B |
| 0x2B | ~Center View | `_set_center(cursor, 1)` @0x30E0 |
| 0x4B | ~Map Tile Select | `_selection_screen` @0x2826 (custom full-screen picker — §4) |
| 0x4C | ~Fill Mode Change | `_fill_radius` = (r+1)%3 @0x3104 |
| 0x4E | ~Undo Last Change | `_perform_undo` @0x1D7E (gated `_undo_available`/`_undo_active`) @0x3128 |
| 0x51–0x54 | Help rows 1–4 | `@popup_box("HELP1".."HELP4")` @0x3140–@0x3164 |
| 0x5F | row labeled "How To Use Maps" | `@popup_box("ABOUT")` @0x3170 — **shipped off-by-one, see §5** |
| 0x21, 0x6A | *(no menu row)* | `_set_view_mode` / `_memory_check` @0x30BA/@0x317C — **dead: nothing emits these ids** |

## 4. Main editor screen — B
Decoded 2026-07-30; screen rects, zoom math, selection grid, and renderer
frame constants re-verified against the listings.

### Layout (320×200 MCGA; two offscreen 320×200 buffers `_scr_work`/`_scr_orig`)
| element | rect | cite |
|---|---|---|
| Menu bar | y 0..7, full width | `_main_screen_refresh` @0x2317 |
| **Map viewport** | (0,8)–(240,200); fixed **240×192** px (`_map_pixel_size` = 0xF0/0xC0 @0xB633/@0xB639) | hit-test `_mouse_area` @0x31CA |
| **Mini-map** | panel (241,8) 79×41; frame (251,8)–(308,48); pixels from (252,9), max 56×39 | `_show_mini` @0xCF14/@0xCF8D |
| **Info window** | (241,50) 79×150; border (240,49)–(320,200) | `_info_window_clear` @0x1DBD |

**Zoom** (`@compute_view_parameters` @0xBA76): scale 0..3; visible tiles =
**(15<<scale) × (12<<scale)**; tile px = **16>>scale** — F1=120×96@2px,
F2=60×48@4px, F3=30×24@8px, F4=15×12@16px (startup default scale 0). Corner
clamped to [1, dim−view−1]; small maps centered via `_map_tile_inset`;
sprite scale = 100>>scale percent.

**Info window** (FONTTINY, `_basic_color`, x=242 y=51, line pitch fontH+1):
"Size: (w, h)" / "Curs: (x, y)" / "Terrain at cursor:" + name (with
" Forest" for ids 8..0x17, "(Major|Minor River)" from bit 0x40+0x80) /
"Selected:" + 16×16 tool swatch (tile + PHYS0 forest overlay, or PHYS0
frames 4/0x14/0x24/0x34 for river/mtn/hill tools) / shift-click help lines /
"Fill radius: N" / "Coast Protect: ON|OFF" @0x1F4E–0x22D2.

**Mini-map**: 1 px/tile, window = clamp(center−28/−19); color =
`_terrain_colors[id]` where ids 0..23 sample **pixel (8,8) of the TERRAIN.SS
tile** and Mountains/Hills sample PHYS0 frames 0x21/0x31 (`_get_tile_colors`
@0xCBCC); white (0xF) view rectangle @0xCFB4. **Cursor**: ICONS.SS frame
**0x13+scale**, blink 20 ticks (~1/3s) @0x29C6/@0x372E.

### "Map Tile Select" screen (`_selection_screen` @0x2826)
Full-screen black; 16×16 items on **17px pitch**: row 0 y=1 = 8 UNFORESTED
base tiles; row 1 y=18 = forested (base + PHYS0 frame 0x41 overlay; Desert →
dedicated Scrub tile 0x11); bottom row y=48 = Arctic/Ocean/Sea Lane tiles +
PHYS0 sprite items frame 4=Major River, 0x14=Minor River, 0x24=Mountains,
0x34=Hills. White selection box (x−1,y−1)–(x+16,y+16); selected name label
at (160,10). Arrow keys move ±1/±8 over 24 slots; any other key or
click-release exits. Tool table (`_parse_spot` @0x26CC):

| tool | sel | and | or | rmc |
|---|---|---|---|---|
| terrain id t (rows 0/1, Arctic) | t | 0xFF | 0 | 0 |
| Ocean / Sea Lane | 0x19/0x1A | 0x40 | 0 | 0 |
| Major / Minor River | 0 | 0x1F/0x3F | 0xC0/0x40 | 1 |
| Mountains / Hills | 0 | 0x1F/0x5F | 0xA0/0x20 | 1 |

Startup default = Ocean tool. Also entered by clicking the info window.

### Paint interaction
- Screen→tile: `tx = mx/tsz − inset_x + corner_x`, `ty = (my−8)/tsz −
  inset_y + corner_y` @0x35C4–0x35F1.
- **No shift**: click recenters (`_set_center`). **Shift+left**: paint
  (`_fill_map`, square brush side 2r+1, r = `_fill_radius` 0..2 → 1×1/3×3/
  5×5, continuous while dragging, undo snapshot at stroke start).
  **Shift+right**: terrain tool → eyedropper pick-up; feature tool → remove
  (and-mask only). Keyboard: Enter/Space paint, Backspace pick-up/remove.
- `_change_map` @0x31E0: border ring immutable; coastline-protect skips
  painting terrain onto water; hills/mtn never apply to water; write sets
  `_map_changes`.
- **Undo**: single-slot, terrain layer only (12,000-byte copy at stroke
  start; `_perform_undo` restores). `_small_map_needs_update` is never
  referenced (mini-map rebuilt on every draw).

### Renderer (terrain byte → sprites; helper @0xC3A2)
> **Frame-numbering convention (RULING 2026-07-31):** the `0xNN` constants below are
> **engine frame numbers, 1-based over disk descriptors** (`disk sprite = engine
> frame − 1`); e.g. straight coasts engine 0x97..0x9A = **disk sprites 150–153**
> (hard rule 4's numbers), and engine 0x96 = disk 149 (the feature-bit wave overlay).
> Evidence: `docs/screens/phys0_coast_frames.png` + descriptor counts.
Ground from the 12-tile TERRAIN.SS array (`_tile_id` @0x46CE: 0..7→0..7;
ids 9 and 0x11→8 Scrub; 0x18/0x19/0x1A→9/10/11), PHYS0 overlays on top —
**agrees with hard rules 3/5**; BDARK.SS never referenced. PHYS0 frames:
forest **0x41+mask** (N8|S4|W2|E1 neighbor forests); mountains **0x21+mask**
/ hills **0x31+mask** (neighbors with equal byte&0xA0); rivers major
**0x01..0x10** / minor **0x11..0x20** (4-neighbor mask, isolated→0xF —
**agrees with hard rule 4** rows 0x01/0x11 = rivers); river mouths on water
**0x8D+dir / 0x91+dir**; unexplored 0x95; straight coasts **0x97..0x9A
(151..154)** by edge class, otherwise per-quadrant beach-halo **0x6D+quad+
4·code (109..140)** at 8×8 sub-offsets. ~~Hard-rule-4 numbering flag~~ **RESOLVED (RULING
2026-07-31)**: engine frames are 1-based over disk sprites, so the engine's
151–154 ARE hard rule 4's disk sprites 150–153 — no conflict; engine 0x96
(= disk 149, feature-byte bit 0x40, dormant in the editor @0xC550) is a
wave/hatch overlay, not a coast.
Scale-0-only extras (inert on fresh maps): resources 0x5A+idx, lost city
0x68, roads 0x51/0x52+dir.

### Cursor movement
Numpad 1–9 and Home/Up/PgUp/Left/Right/End/Down/PgDn = 8-way move
(jump table file 0x346E), clamp [1, dim−2], auto-scroll when within 2 tiles
of the view edge (`_possibly_center` @0x2A5E).

## 5. Menus & dialog engine — B
Decoded 2026-07-30; dialog-section strings, menu-id pushes, dead-data claims
(no "XS"/"YS"/"HELP5" C-strings anywhere in the EXE), and the engine-identity
clamps re-verified against raw bytes.

### Engine identity
menu.obj **is VICEROY's page-0x0A pulldown module from the same source**:
the dropdown screen clamps @0x008E97/@0x008EA6 (`cmp [bp-8],0x13e` /
`cmp [bp-2],0xc6`) are instruction-identical (same locals, same constants)
to VICEROY `func_044FA4` @0x04505F/@0x04506E, and the node shapes match
(bar list at +0x38, items at +0x1E, `~`-hotkey extraction, pending-command
word at +0).

### Menu bar (`_construct_mapedit_menu` @0x1796, engine seg 0x6D7)
- `_menu_create(0x800, _menu_font=FONTTINY)` @0x17AA → `_menu_bar` DS:0x78.
  Constants: barY=1, bar gap 12, dropRowPad=3, barTextPad=1, dropTextPad=4
  @0x86C3–0x86E6. Bar/dropdown backgrounds = color 7,7 → **WOODTILE fill**
  (32×24 pre-rendered `_scr_back` tiled whenever bg color==7; menu helper
  @0x83C2, popup helper @0x4D1A). Select/grey/hilite colors from NAMES.TXT
  `@COLORS` via `_viceroy_game` @0x3D43–0x3D66.
- Bar items read positionally from MAPMENU.TXT (`_text_get` = one line per
  call; `_` → space): `@GAME`→"Editor" (id row set §3), `@VIEW`, `@CUP`→"Map",
  `@HELP` (right-justified, x = 0x140−width−12 @0x8B0B). Bar item x: first
  = 12, then prev.x+prev.w+12; width = text−`~`s + 2. Bar strip height =
  fontH+2; `~X` hotkey char drawn in hilite color @0x84FF–0x8567.
- **Dropdown geometry**: x = bar-item x; y = barFontH+4; width = maxItemW+2
  (min 0xA); height = (fontH+3)·visible + 5; clamps right ≤0x13D, bottom
  ≤0xC7; 1px border in `_menu_border_color`, wood interior, separators
  (empty rows, flag bit0) drawn as 1px centered rules; save-under id 0xFFF8.
- **Two shipped construction bugs (byte-verified by `_text_get` call
  counts)**: `@CUP` has 6 item rows but only 5 reads — **"Memor~y check"
  never appears in the menu** (and its id 0x6A handler is dead); `@HELP` has
  6 rows but 5 reads with ids 0x51,0x52,0x53,0x54,0x5F — **the row labeled
  "How To Use Maps" gets id 0x5F which opens the @ABOUT popup; "About Map
  Editor" is never read and @HELP5 is unreachable**.

### Popup/dialog engine (popup.obj seg 0x33D)
- `_popup_create` @0x50AE: frame inset 3, bevel borders (`@COLORS`
  border0/1/2: outer + inset-1 rect in border0, top/left in border-down,
  bottom/right in border-up @0x6CB3–0x6DA1), wood interior, FONTINTR text
  (`@SMALLFONT` directive switches to FONTTINY). Min width 0x50;
  auto-center x=160−w/2, y=100−h/2, clamp 0x140/0xC8; item rows fontH+3,
  entry rows fontH+8.
- **Section parser** `@popup_start_box` @0x7C82: state machine — blank line
  separates text block from option block; `^^`=centered line, `^`=raw line,
  plain lines word-wrap; `{…}`=hilite span, `|` truncates (char-draw
  @0x4F16); items get ids 1..n in read order; directives `@OPTIONS/@PROMPT/
  @TEXT/@SMALLFONT/@X=/@Y=/@WIDTH/@LENGTH/@CHECKBOX/@DEFAULT` (none used by
  the 19 MAPEDIT.TXT sections). Substitutions: `%STRINGn` (DS:0x634E+64n,
  set by `_popup_say_string`), `%NUMBERn`, `%HEXn`, `%%`.
- **Event loop** `@popup_exec` @0x6F5E: Up/Down move (skip greyed, wrap),
  Enter/Space select → popup[0]=item id; **ESC → 0xFFFF**; hotkey match;
  mouse rows + release-select; entry mode: printable append to maxlen, BS,
  Enter accepts → text strcpy'd to `_popup_text_buffer` DS:0x4B64.
  Wrappers: `@popup_box` (ax=section, bx=file, dx=initial),
  `@popup_ask` (entry dialog), `@popup_ask_number` (**zero callers — dead**).
- **Dead code**: `_menu_read_colors` ("MENUCOLR.SS") and
  `_popup_read_colors` ("TEXTCOLR") have no callers; `@XS`/`@YS` sections
  have no referencing strings in the binary (map size is hard-coded 58×72).
- HELP1–4/ABOUT = plain text popups (auto-centered, no buttons, no
  scrolling; >200px height would abort with error 0xFFAF).

### Keyboard accelerators (full wiring, `_human_interface_loop` @0x3724)
Key → uppercase → tried in order: (1) bar hotkeys E/V/M/H open dropdowns
(`@menu_bar_key_parse` @0x97C2); (2) **global item accelerators**
(`@menu_key_parse` @0x9856, fires without opening the menu): S=Save,
A=Save As, L=Load, Z/X=zoom in/out, F1–F4=zoom levels, C=Center, M=Tile
Select, F=Fill Mode, P=Coastline Protect, O=Find Continents, U=Undo;
(3) `_parse_main_keys` @0x33B6: ESC/Ctrl-Q/Ctrl-X/Alt-Q/Alt-X → exit flow,
Space/Enter → paint at cursor, Backspace → pick-up/remove, numpad 1–9 +
arrows/Home/End/PgUp/PgDn → 8-way cursor move (jump table file 0x346E).
`_shift_key` (BIOS 0x417&3) gates paint-vs-move on mouse strokes.

## 6. Open items
1. Retail MAPEDIT.TXT/MAPMENU.TXT files absent from `raw/COLONIZE/` —
   wording sourced from the extracted JSON; obtain originals to close.
2. Layer-2 bits 3/6 (`_is_hostile` tests 0x48) — game-side, needs VICEROY's
   reader.
3. `_map_error` 9999 display path (who shows it) — TBD.
4. `@env_open` path-resolution order (`_env_special_path`) — trace env_1.obj
   init if needed.
5. VICEROY's own .MP loader per-line annotation (format cross-check).
