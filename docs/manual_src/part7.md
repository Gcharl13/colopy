## 28. The map editor (MAPEDIT.EXE)

Colonization ships a stand-alone map editor, MAPEDIT.EXE (145,292 bytes), which
shares the MADS engine and the game's asset files (VICEROY.PAL, TERRAIN.SS,
PHYS0.SS, ICONS.SS, WOODTILE.SS, FONTINTR, FONTTINY, CURSOR.SS) with the main
executable. Uniquely among the shipped binaries it retains a CodeView NB02
debug block, so every function in this section is cited by its real,
compiler-emitted name together with its file offset. The editor reads and
writes the 3-layer `.MP` map format (6-byte header `width u16, height u16,
version u16 = 4`, then terrain / feature / continent layers of width×height
bytes each; AMER2.MP is 12,534 = 6 + 3·58·72 bytes).

### 28.1 The CodeView symbol trove

The debug block at file offset 0x1BE09 carries **1,071 public symbols**; a
symbol's file offset is `segment·16 + offset + 0x1600` (0x1600 = MZ header
size). The symbols partition the binary into named modules: the editor's own
code in `mapedit.obj` (138 symbols), `popup.obj` (84), `map.obj` (76, plus
`map_2/map_5/map_6/map_9/map_a`), `menu.obj` (38), `write.obj` (30),
`text.obj` (14), `me_mini.obj` (13), `tile.obj`, `stuff.obj`, `strings.obj`,
`env_1.obj`, `compass.obj`; and the MADS engine library (`mouse_1/mouse_2`,
`mem_*`, `pal_1`, `ems_1/ems_2`, `xms_1`, `himem_1`, `pack_5`, `pfabcomp`
(the FAB compressor), `loader_1`, `timer_1/timer_3`, `keys_4`, `sound_1/2`,
`font_1`, `cycle_1`, `mcga_7`, `sprite_e`, `matte_0`, `heap_1`, `error_1`,
`dos\crt0.asm`). These names anchor the whole section and — because the
engine modules are shared — resolve otherwise-anonymous code in VICEROY.EXE
(§28.8).

### 28.2 Startup and initialisation

`_main` @0x3ED8 scans the command line. Arguments beginning `-` or `/` go
through the per-character `_flag_parse` @0x3E72:

| flag | effect |
|------|--------|
| `-c` | `_create_me_now`=1 — force the create-new-map path |
| `-m:file` | `_map_name` ← file, `_map_selected`=1 |
| `?` (any arg starting `?`) | `_show_flags` @0x3DF6 — prints the usage text at DS:0x3AA..0x487 and exits |
| any other letter | ignored |

Otherwise control passes to `_viceroy_game` @0x3B16. On exit, a non-zero
`_exit_value` prints `"Exit value: %d\n"`. Initialisation is strictly ordered
and each failure sets a distinct exit code:

| step | asset / action | exit code on failure |
|------|----------------|----------------------|
| video mode 0x13 (MCGA 320×200) @0x3B2E | — | — |
| palette | VICEROY.PAL | 0x13 |
| two 320×200 work buffers `_scr_work` / `_scr_orig` | — | 0x14 |
| `_font_inter` | FONTINTR | 0x15 |
| `_menu_font` | FONTTINY | 0x16 |
| `_load_terrain_tiles` @0xB152 → `_terrain_1` | TERRAIN.SS as a flat 12-frame 16×16 array | 0x321 / 0x322 |
| cursor | CURSOR.SS | 0x17 |
| `_tiles` / `_tiles2` | PHYS0.SS | 0x18 |
| icons | ICONS.SS | 0x19 |
| `_scr_back` 32×24 tile | WOODTILE.SS | 0x1A / 0x1B |

then `_get_tile_colors` (mini-map colour table, §28.5), `_load_data` @0x3936
(NAMES.TXT), a **12,000-byte undo buffer** `_map_undo_memory`
(`_undo_available`=1) @0x3D6E, `_start_new_game` @0x3A7A, and the main loop
`_turn_control_loop` @0x38B0. The TERRAIN.SS-as-base-ground load order is one
of the independent proofs that TERRAIN.SS is the ground sheet composited
under the PHYS0.SS overlays.

### 28.3 Text-data loads

`_load_data` @0x3936 reads **NAMES.TXT**: `@UNFORESTED` fills terrain records
0..7, `@FORESTED` fills 8..15 and records 16..23 are `memcpy` aliases of
8..15 (@0x39B1–0x39CD), `@OTHER` fills 24..28
(Arctic/Ocean/Sea Lane/Mountains/Hills — the same authority order the game
uses: 25 = Ocean, 26 = Sea Lane), `@OTHER_NAMES` fills `_terrain_names`
("Forest / River / Major River / Minor River / Unexplored"), and `@COLORS`
fills nine palette-index globals (`_basic_color`, `_hilite_color`,
`_grey_color`, `_enhance_color`, `_shadow_color`, `_select_color`,
`_border0/1/2`, DS:0x92..0x9B), propagated to the popup engine by
`_popups_normal` @0x1618. Each terrain record is 16 bytes (appendix A). The
13th NAMES numeric column is never read.

**MAPMENU.TXT** feeds `_construct_mapedit_menu` @0x1796: sections `@GAME`
("Editor"), `@VIEW`, `@CUP` ("Map"), `@HELP`. Menu items receive hard-coded
event ids at the `_menu_add_item` call sites (0x13 Save As, 0x14 New, 0x1A
Save, 0x1B Load, 0x1F Exit, 0x24–0x2B zooms, 0x4A–0x4E map operations, 0x51+
help). Dialog wording comes from the 19 sections of MAPEDIT.TXT.

### 28.4 Session flow

`_start_new_game` @0x3A7A:

- With no `-m`/`-c`: the **file picker** `_file_menu("MAPEDIT", "MAPTOEDIT",
  "*.MP")` @0x3A8C ("Select Map File to Edit / (ESC to create new map)");
  ESC or cancel falls through to the create path.
- Map defaults `w=58, h=72` are set @0x3AB5; `@map_startup` allocates four
  0x2EE0-byte (= 58·72 = 4,176-tile, 12,000-byte-rounded) layer buffers:
  terrain, feature, continent, plus a memory-only `_site` layer.
- **Create**: `_create_me` @0x2BFC — a name-entry popup (sections
  "MAPEDIT"/"NEWNAME", default `UNTITLED.MP`, max 0x14 chars) →
  `_create_blank_map(58,72)`: size hard-coded, every tile filled with
  **Ocean (0x19)**, version = 4, then `_map_changes`=1. **There is no
  map-size picker and no procedural map generation anywhere in
  MAPEDIT.EXE** — arbitrary sizes can only enter via files.
- **Load**: `_load_map_file` @0xB700 (header/size validation), then
  **`_forest_fix` @0x16B6**, which normalises forest alias ids 16..23 down
  to 8..15 and strips the forest id from tiles carrying the mountain/hill
  overlay bit.
- Both paths centre the cursor and the view at (w/2, h/2).

`_file_menu` @0x1B6A runs DOS findfirst/findnext over the pattern into
13-byte name slots at DS:0x64F0, pages of 10, with "(More)" pager rows
(codes 0x61/0x62); the result goes to `_file_select`.

### 28.5 The main editor screen

```python
regions = [
    (0,   0, 320,   8, "Menu bar",       "panel", "WOODTILE fill; FONTTINY titles (_main_screen_refresh @0x2317)"),
    (0,   8, 240, 192, "Map viewport",   "hit",   "fixed 240x192 px (_map_pixel_size 0xF0/0xC0 @0xB633/@0xB639; hit test _mouse_area @0x31CA)"),
    (241, 8,  79,  41, "Mini-map panel", "panel", "frame rect (251,8)-(308,48) (_show_mini @0xCF14)"),
    (252, 9,  56,  39, "Mini-map",       "art",   "1 px per tile, max 56x39 (@0xCF8D)"),
    (241, 50, 79, 150, "Info window",    "text",  "border (240,49)-(320,200) (_info_window_clear @0x1DBD); click opens Tile Select"),
]  # 320x200 Mode 13h; drawn into two offscreen 320x200 buffers _scr_work/_scr_orig
```

**Zoom** (`@compute_view_parameters` @0xBA76): scale 0..3, visible tiles =
(15<<scale) × (12<<scale), tile pixels = 16>>scale. The four fixed levels:

| key | scale | visible tiles | px/tile | sprite scale |
|-----|-------|---------------|---------|--------------|
| F4  | 0 (startup default) | 15×12 | 16 | 100% |
| F3  | 1 | 30×24 | 8 | 50% |
| F2  | 2 | 60×48 | 4 | 25% |
| F1  | 3 | 120×96 | 2 | 12% |

The view corner is clamped to [1, dim−view−1]; maps smaller than the view
are centred via `_map_tile_inset`.

**Info window** (FONTTINY, ink `_basic_color`, origin x=242 y=51, line pitch
fontH+1; content painters @0x1F4E–0x22D2), top to bottom:

1. `Size: (w, h)`
2. `Curs: (x, y)`
3. `Terrain at cursor:` + name — with `" Forest"` appended for ids 8..0x17
   and `(Major River)`/`(Minor River)` decoded from bits 0x40+0x80
4. `Selected:` + a 16×16 tool swatch (ground tile + PHYS0 forest overlay;
   or PHYS0 frames 4 / 0x14 / 0x24 / 0x34 for the river/river/mountain/hill
   tools)
5. shift-click help lines
6. `Fill radius: N`
7. `Coast Protect: ON|OFF`

**Mini-map**: 1 pixel per tile, window = clamp(centre −28, −19). Colour =
`_terrain_colors[id]`, where ids 0..23 sample **pixel (8,8) of the tile's
TERRAIN.SS frame** and Mountains/Hills sample PHYS0 frames 0x21/0x31
(`_get_tile_colors` @0xCBCC). A white (palette 0x0F) rectangle marks the
current view (@0xCFB4).

**Cursor**: ICONS.SS frame **0x13+scale** (a 16/8/4/2-pixel box matching the
tile size), blinking with a 20-tick (~1/3 s) period (@0x29C6/@0x372E).

### 28.6 The "Map Tile Select" screen

`_selection_screen` @0x2826 (menu id 0x4B, accelerator M, or a click on the
info window) is a custom full-screen picker on black. Items are 16×16 on a
**17-pixel pitch**:

- row 0, y=1: the 8 unforested base tiles;
- row 1, y=18: the forested variants (base tile + PHYS0 frame 0x41 overlay;
  Desert's forest uses the dedicated Scrub ground tile via id 0x11);
- bottom row, y=48: Arctic / Ocean / Sea Lane tiles, then PHYS0 sprite items
  frame 4 = Major River, 0x14 = Minor River, 0x24 = Mountains, 0x34 = Hills.

A white selection box is drawn at (x−1,y−1)–(x+16,y+16); the selected tool's
name is labelled at (160,10). Arrow keys move ±1/±8 across the 24 slots;
any other key or a click-release exits. The startup default tool is Ocean.
Each tool compiles to a (sel, and, or, rmc) mask set (`_parse_spot` @0x26CC)
applied to the terrain byte:

| tool | sel | and | or | rmc |
|------|-----|-----|----|-----|
| terrain id t (rows 0/1, Arctic) | t | 0xFF | 0 | 0 |
| Ocean / Sea Lane | 0x19 / 0x1A | 0x40 | 0 | 0 |
| Major / Minor River | 0 | 0x1F / 0x3F | 0xC0 / 0x40 | 1 |
| Mountains / Hills | 0 | 0x1F / 0x5F | 0xA0 / 0x20 | 1 |

### 28.7 Paint interaction

- Screen→tile mapping: `tx = mx/tsz − inset_x + corner_x`,
  `ty = (my−8)/tsz − inset_y + corner_y` (@0x35C4–0x35F1).
- **Plain click** recentres the view (`_set_center`). **Shift+left** paints
  (`_fill_map`): a square brush of side 2r+1 where r = `_fill_radius` 0..2,
  i.e. **1×1 / 3×3 / 5×5** (menu "Fill Mode Change", id 0x4C, cycles
  r=(r+1)%3 @0x3104); painting is continuous while dragging, with one undo
  snapshot taken at stroke start. **Shift+right** is context-sensitive:
  with a terrain tool it is an **eyedropper** (picks up the tile under the
  cursor as the current tool); with a feature tool it removes the feature
  (applies the and-mask only). Keyboard: Enter/Space = paint at cursor,
  Backspace = pick-up/remove.
- `_change_map` @0x31E0 enforces three guards: the **1-tile border ring is
  immutable**; while **Coastline Protect** is ON (`_coastline_protect`
  [DS:0x4E], toggled by menu id 0x4D) painting terrain onto Ocean/Sea-Lane
  tiles is skipped (@0x3265–0x327D); and the mountain/hill or-bit is
  **always** refused on water (@0x328B). Any accepted write sets
  `_map_changes`.
- **Undo** is a single slot covering the terrain layer only: a 12,000-byte
  copy taken at stroke start; `_perform_undo` @0x1D7E restores it (menu id
  0x4E / key U, gated by `_undo_available`/`_undo_active`). The mini-map is
  rebuilt on every draw (`_small_map_needs_update` exists but is never
  referenced).
- Cursor movement: numpad 1–9 and Home/Up/PgUp/Left/Right/End/Down/PgDn give
  8-way movement (jump table at file 0x346E), clamped to [1, dim−2], with
  auto-scroll when within 2 tiles of the view edge (`_possibly_center`
  @0x2A5E).

### 28.8 Menus and dialogs

**Engine identity.** MAPEDIT's `menu.obj` is **the same pulldown module as
VICEROY's in-game menu bar, built from the same source**: the dropdown
screen clamps @0x008E97/@0x008EA6 (`cmp [bp-8],0x13e` / `cmp [bp-2],0xc6` —
right edge ≤ 317, bottom ≤ 199) are instruction-identical, with the same
locals and constants, to VICEROY `func_044FA4` @0x04505F/@0x04506E, and the
node shapes match (bar's menu list at +0x38, a menu's item list at +0x1E,
`~`-hotkey extraction, pending-command word at struct offset +0).

**Menu bar** (`_construct_mapedit_menu` @0x1796): `_menu_create(0x800,
FONTTINY)` @0x17AA → `_menu_bar` at DS:0x78. Constants (@0x86C3–0x86E6):
bar y=1, bar gap 12, drop-row pad 3, bar text pad 1, drop text pad 4. Bar
and dropdown backgrounds use fill colour 7,7, the sentinel that selects the
**WOODTILE fill** — the pre-rendered 32×24 `_scr_back` tile (menu helper
@0x83C2, popup helper @0x4D1A). Bar items read positionally from
MAPMENU.TXT (`_text_get`, one line per call, `_` → space): "Editor", View,
"Map", Help (Help right-justified at x = 0x140−width−12 @0x8B0B). First bar
item x=12, then prev.x+prev.w+12; hotkey characters (after `~`) draw in the
hilite colour @0x84FF–0x8567. Dropdowns: x = bar-item x, y = barFontH+4,
width = maxItemW+2 (min 0xA), height = (fontH+3)·visible+5, 1-px border in
`_menu_border_color`, wood interior, empty rows drawn as centred 1-px
separator rules, save-under id 0xFFF8.

**Command dispatch** (`_execute_menu_event` @0x2DE0, jump table at file
0x2DFC):

| id | item | action |
|----|------|--------|
| 0x1A | Save | confirm popup `@SAVE` → `_write_map_file`; failure → `@ERROR`; success clears `_map_changes` @0x2F8E |
| 0x13 | Save As | strip path, string popup `@SAVEAS` (14 chars), force extension "MP", write @0x2EAC |
| 0x1B | Load | if dirty confirm `@LOAD`; `_file_menu(@MAPTOLOAD,"*.MP")`; load; `_forest_fix`; recentre @0x2FD4 |
| 0x14 | Create | if dirty confirm `@CREATENOW`; `_create_me`; recentre + `_new_mini` @0x2F24 |
| 0x1F | Exit | if dirty, 3-way `@EXIT` (exit unsaved / save+exit / cancel) @0x305E |
| 0x24/0x25 | Zoom In ~Z / Out ~X | `_set_zoom_level(_map_scale ∓ 1)` @0x30C2/@0x30D2 |
| 0x26–0x29 | F1..F4 zoom rows | `_set_zoom_level(0x29−id)`, clamp 0..3 @0x30D8/@0x2B8B |
| 0x2B | ~Center View | `_set_center(cursor, 1)` @0x30E0 |
| 0x4A | Find Continents | `_continent_check` @0x2C70: `_map_find_continents` @0xB242 — two flood passes labelling continents 1..15 into the layer-3 low nibbles; >15 land regions → `@CONTINENTS1` popup, >15 water → `@CONTINENTS2`; then a full-screen continent-id view (Ocean/Sea-Lane blanked), any key restores |
| 0x4B | ~Map Tile Select | `_selection_screen` @0x2826 |
| 0x4C | ~Fill Mode Change | `_fill_radius` = (r+1)%3 @0x3104 |
| 0x4D | Coastline Protect | toggle `_coastline_protect` |
| 0x4E | ~Undo Last Change | `_perform_undo` @0x3128 |
| 0x51–0x54 | Help rows 1–4 | `@popup_box("HELP1".."HELP4")` @0x3140–@0x3164 |
| 0x5F | "How To Use Maps" row | `@popup_box("ABOUT")` @0x3170 — shipped off-by-one, §28.9 |
| 0x21, 0x6A | *(no menu row)* | `_set_view_mode` / `_memory_check` @0x30BA/@0x317C — dead, nothing emits these ids |

**Popup/dialog engine** (`popup.obj`, segment 0x33D). `_popup_create`
@0x50AE: frame inset 3; bevel borders from the `@COLORS` border0/1/2
palette indices (outer ring + inset−1 rect in border0, top/left in the
border-down colour, bottom/right in border-up, @0x6CB3–0x6DA1); wood
(WOODTILE) interior; FONTINTR text, switched to FONTTINY by a `@SMALLFONT`
directive. Minimum width 0x50; auto-centre x=160−w/2, y=100−h/2, clamped to
320×200; item rows fontH+3, entry rows fontH+8. The section parser
`@popup_start_box` @0x7C82 is a small state machine: a blank line separates
the text block from the option block; `^^` = centred line, `^` = raw line,
plain lines word-wrap; `{…}` = hilite span, `|` truncates; option items get
ids 1..n in read order; directives `@OPTIONS/@PROMPT/@TEXT/@SMALLFONT/@X=/
@Y=/@WIDTH/@LENGTH/@CHECKBOX/@DEFAULT` are parsed (none is used by the 19
MAPEDIT.TXT sections). Substitutions: `%STRINGn` (DS:0x634E+64n, set by
`_popup_say_string`), `%NUMBERn`, `%HEXn`, `%%`. The event loop
`@popup_exec` @0x6F5E: Up/Down move (skip greyed, wrap), Enter/Space select
→ popup word 0 = item id, **ESC → 0xFFFF**, hotkey match, mouse rows with
release-select; entry mode appends printable chars to maxlen, accepts on
Enter into `_popup_text_buffer` DS:0x4B64. `@popup_ask_number` has zero
callers (dead), as do `_menu_read_colors` ("MENUCOLR.SS") and
`_popup_read_colors` ("TEXTCOLR"). HELP1–4/ABOUT are plain text popups (no
buttons, no scrolling; a popup taller than 200 px aborts with error 0xFFAF).

**Keyboard accelerators** (`_human_interface_loop` @0x3724; keys upcased,
tried in order): (1) bar hotkeys E/V/M/H open the dropdowns
(`@menu_bar_key_parse` @0x97C2); (2) global item accelerators
(`@menu_key_parse` @0x9856, firing without opening a menu): S=Save,
A=Save As, L=Load, Z/X=zoom in/out, F1–F4=zoom levels, C=Center,
M=Tile Select, F=Fill Mode, P=Coastline Protect, O=Find Continents, U=Undo;
(3) `_parse_main_keys` @0x33B6: ESC/Ctrl-Q/Ctrl-X/Alt-Q/Alt-X → exit flow,
Space/Enter paint, Backspace pick-up, numpad/arrows move. `_shift_key`
(BIOS 0x417 & 3) gates paint-vs-move on mouse strokes.

### 28.9 The five shipped bugs

All five are byte-verified in the shipped binary:

1. **"Memor~y check" never appears.** The `@CUP` (Map) menu section has 6
   item rows but the construction code issues only 5 `_text_get` reads —
   the last row is never read, and its handler id 0x6A is dead. (The
   handler itself, `_memory_check` @0x2BCC, would show a popup from the
   file "DEBUG", section `@MEMORY`.)
2. **Help off-by-one.** `@HELP` has 6 rows but 5 reads, assigned ids 0x51,
   0x52, 0x53, 0x54, 0x5F. The row labelled **"How To Use Maps" therefore
   fires id 0x5F, which opens the `@ABOUT` popup**; the "About Map Editor"
   row is never read and the `@HELP5` section is unreachable.
3. **Dead `@XS`/`@YS`.** No referencing string for either section exists
   anywhere in the EXE — the map size is hard-coded 58×72; the size-entry
   dialogs the text file provides for were never wired up.
4. **Dead command ids 0x21 and 0x6A.** Both have live handlers in the
   dispatch jump table (`_set_view_mode`, `_memory_check`) but no menu row
   or key ever emits them.
5. **Load→save is not byte-preserving.** `_forest_fix` runs on every load,
   folding forest alias ids 16..23 to 8..15 and stripping forest under
   mountain/hill overlays — so round-tripping a file that contains ids
   16..23 (AMER2.MP does) rewrites those bytes. (The main game performs the
   same fold in its own loader, so the meaning is unchanged.)

### 28.10 Renderer frame map and engine parity

The editor's tile renderer (helper @0xC3A2) is the same compositor scheme
as the game's: ground from the 12-tile TERRAIN.SS array, PHYS0.SS overlays
on top, BDARK.SS never referenced. Ground selection (`_tile_id` @0x46CE):
ids 0..7 → frames 0..7; ids 9 and 0x11 → frame 8 (Scrub); 0x18/0x19/0x1A →
frames 9/10/11 (Arctic/Ocean/Sea Lane). Frame constants below are **engine
frame numbers, 1-based over the disk descriptors** (disk sprite = engine
frame − 1):

| overlay | engine frames | rule |
|---------|---------------|------|
| forest | 0x41+mask | mask = N8\|S4\|W2\|E1 over neighbouring forests |
| mountains | 0x21+mask | neighbours connect only when `byte&0xA0` is equal |
| hills | 0x31+mask | same adjacency rule |
| major river | 0x01..0x10 | 4-neighbour mask; isolated → mask 0xF |
| minor river | 0x11..0x20 | same |
| river mouths | 0x8D+dir / 0x91+dir | on water tiles adjoining a land river |
| unexplored | 0x95 | |
| straight coasts | 0x97..0x9A (disk 150–153) | by edge class |
| beach-halo quadrants | 0x6D+quad+4·code | 8×8 sub-tiles at 8×8 sub-offsets |
| scale-0 extras | 0x5A+idx resources, 0x68 lost city, 0x51/0x52+dir roads | inert on fresh maps (feature layer empty) |

Engine frame 0x96 (disk 149), the feature-bit wave/hatch overlay, is
present but dormant in the editor (@0xC550). The identity of these
constants with VICEROY's in-game map renderer — same coast adder at
VICEROY file 0x06850D, same halo adder at 0x0684E8 — plus the
instruction-identical menu clamps of §28.8, make MAPEDIT a second,
independently shipped witness to the game's rendering rules.

## 29. Verification

Everything in this manual was established by three mutually checking
methods against the shipped 1994 binaries and data files: static
disassembly with byte-level citation, live memory reads of the running game
under emulation, and pixel-level render-and-diff in which whole screens
were rebuilt purely from the documented facts and compared against
captures of the real game. This section records what each method
contributed and — just as importantly — what remains unproven.

### 29.1 Static disassembly

The primary evidence layer is the disassembly of VICEROY.EXE (an RTLink
overlaid MZ executable: resident segments plus 31 overlay pages reached
through thunk tables), MAPEDIT.EXE (with its CodeView symbols, §28.1), and
the OPENING/CLOSING cinematic executables. Every load-bearing number in
this manual is cited to a file offset in one of these binaries, to a field
of the NAMES.TXT/GAME.TXT-family data files, or to a recorded ruling; where
a value is computed at runtime it is marked as such rather than guessed.
Cross-checks internal to this layer repeatedly caught errors: for example,
the sprite-frame numbering convention (engine frame = disk descriptor + 1)
was proven from descriptor counts — TERRAIN.SS holds exactly 12 disk
descriptors while the engine loads "frames 1..12", and PHYS0.SS holds 154
(disk 0..153) while engine code references frame 154 — with no subtraction
anywhere in the draw verb (the offset lives in the in-memory record layout,
appendix A).

### 29.2 Live-RAM reads under emulation

The running game (DOSBox 0.74-3) is the top of the evidence order. Memory
snapshots were taken at known moments and the game's data segment located
by **DGROUP anchoring**: scanning the dump for known DGROUP string
constants (e.g. "WOODPANL" at DS:0x2189) pins the physical base (0x1CFD0
in the verification sessions), after which every documented DGROUP offset
can be read directly. This validated record layouts end-to-end (the active
colony pointer `[0x8542]` → bytes `33 1D "Jamestown"` = (51,29) exactly as
the ColonyRecord head specifies), exposed state the disassembly could not
decide (the debug bitfield `[0x894]` defaults to 8, not 0; the boot text
ink latch `[0x1F4E]` reads 0xFC at the boot menu and 0x95 in-game), and
killed a systematically wrong oracle: the word `[0x2F5E]` = 537 had been
dereferenced as a string pointer yielding "Sons of Liberty"; the live table
walk showed it is an integer **string id** (slot 210 of a 221-entry id
table, resolving to "Exit") — consistent with the pixel evidence in both
screens where the wrong reading had propagated.

### 29.3 Render-and-diff

Twelve-plus screens were rebuilt from scratch using only the documented
facts (geometry, fonts, palette indices, sprite frames, formulas) and
diffed pixel-by-pixel against captures of the running game (pixel-verified
against the running game, 1994 binary under DOSBox):

| screen | rebuilt-vs-live result |
|--------|------------------------|
| difficulty select | 99.96% identical |
| nation select | 99.86% identical |
| boot (main) menu | 98.7% identical; four documented claims falsified and corrected in the process |
| leader-name entry | pixel-identical (residual: the mouse cursor) |
| King audience | pixel-identical (residual: the mouse cursor) |
| Europe screen, idle state | **100.00%** outside declared dynamic-sprite masks |
| Europe screen, ship-arriving state | **100.00%** |
| colony screen | structurally exact: every element matched or produced a recorded correction; **all 15 building plots pixel-exact from an exact replay of the placement RNG chain** (16-bit seed → LCG → 15-group category shuffle → frame select) |
| map view (ocean window) | **100.0000%** — 45,056/45,056 non-overlay pixels |
| land window (Jamestown region) | **100.0000%** of 41,540 non-overlay pixels |
| crafted-test-map windows (5 viewports over a purpose-built 58×72 map exercising hills, mountains, rivers, mouths, lakes, forest aliases) | **100.0000%** non-overlay in all five (raw including live-object overlays: 95.15–98.00%) |

The method is deliberately adversarial: a mismatch is treated as a
falsifier of the documentation, not of the capture. It refuted, among
others, a claimed sprite-blit chain on the boot menu (actually a
palette-index find-and-replace, a no-op on that background), transposed
width/height argument labels on the frontend cell grids, a wrong market-bar
y, and the "Sons of Liberty" string described above; and it discovered
mechanisms no static read had found — the beach-halo **ground
substitution** (a coastal water tile is grounded with its last cardinal
land neighbour's terrain, coast frames drawn over it, and water backfilled
through the frames' zero-holes) and the colony scene panel's deterministic
×1.5 dithered upscale of the shared 16-px map compositor.

Non-overlay means: engine object sprites (units, villages, the view
cursor, a ≤2-px sprite overhang) are masked from the diff, since they are
game objects, not tile-compositor output; every masked region is declared.

### 29.4 Capture pipeline

Comparisons must model the capture chain or they fail for the wrong
reasons. Three facts matter: (1) the captures are **2× frames** — each
native pixel is a 2×2 block, recovered by sampling every second row and
column; (2) the emulator framebuffer is **RGB565**: the 6-bit VGA palette
entry is expanded `(v<<2)|(v>>4)` and then floored to 5/6/5 bits, and the
renderer must apply the same quantisation before diffing; (3) **palette
cycling**: the sea-lane sparkle is a VGA palette rotation over indices
120–127, so each capture's cycle phase (0..7) is fitted before the diff,
and the Europe harbour water indices 54–60 are likewise pure palette
animation with zero pixel-index changes. None of these steps touches the
documented render rules; they model only the measurement instrument.

### 29.5 What remains unexercised or unmapped

Stated honestly, in the open:

- **Shore-hatch 0x96, roads, and the feature-resource bit have byte-cited
  draw gates but no pixel test.** The game's `.MP` loader discards layer 2
  (features) entirely and rebuilds the plane at runtime, so no crafted map
  can exercise them; the draw sites (land/water shore gates at VICEROY file
  0x6834F/0x68354, the road walker with its per-direction frames 0x52+d)
  are decoded from the disassembly only. Exercising them needs an organic
  in-game state with pioneer-built roads. (Hills, rivers, river mouths,
  lake coasts, forest aliases, fog blends — all previously on this list —
  are now live-confirmed by the crafted-map and land-window tests.)
- **AIPersonality tail bytes** +0x30/+0x32/+0x33 are unlabelled.
- **ColonyRecord** retains unmapped runs; two locations (+0x24, +0x99)
  have provably **no static accessor** in the entire EXE and read zero in
  live dumps.
- The boot-time writer of **`[0x8D80]`** (a session-constant term mixed
  into the colony building-placement seed; live values 0x2C55, 0x5B7C in
  two sessions) is unlocated.
- **`func_003E40`** — the map unit-marker sprite mapping drawn into the
  colony scene panel — is undecoded.
- The live value of **`[0x890]`** on the colony screen (it gates the
  marker name/population text inside the scene panel) has not been read.

## A. Appendix — data structures

This appendix collects every record layout established for the shipped
binaries, as C structs with byte offsets. Only fields actually mapped are
named; gaps are declared. Unless noted, addresses are DGROUP-relative in
VICEROY.EXE; per-field citations are the decisive read/write sites.
"(runtime-verified)" marks fields whose meaning rests on live-memory
observation of the running game rather than a static code citation.

### A.1 UnitRecord — 0x1C bytes, base DGROUP:0x3144, 300 slots

```c
typedef struct {                 // base 0x3144, stride 0x1C
    uint8_t  map_x;              // +0x00 drawn position (renderer @0x03A63, placer @0x06958)
    uint8_t  map_y;              // +0x01
    uint8_t  unit_type;          // +0x02 NAMES @UNIT row 0..23 (dispatcher @0x51D6B; 694 refs)
    uint8_t  owner_flags;        // +0x03 low nibble = power 0..11, high nibble = state (setter @0x738E)
    uint8_t  scratch_bits;       // +0x04 per-pass flag register: 0x08 tile-dirty (@0x0481B0), 0x80 draw/AI marker (@0x069923), 0x20 Merchantman tag (@0x04CE44), 0x10 path>=8 hops (@0x05106E), 0x02 was-fortifying (@0x04CEC9), 0x04 ship-cargo class (@0x04CDDC)
    uint8_t  moves_spent;        // +0x05 AI move-credits spent this turn (reset @0x005872; +3/step @0x05CAE2; gate @0x03EE95)
    uint8_t  countdown;          // +0x06 timer, init 0xFF, dec (@0x2EF17)
    uint8_t  ai_state;           // +0x07 persistent AI state letter ('X','0','1','G','E','R','V',...; init @0x06D84)
    uint8_t  order;              // +0x08 order code 0..0x0C = NAMES @ORDERS row (dispatch @0x249CB)
    uint8_t  goto_x;             // +0x09 goto / trade-route next-stop target (writer @0x22D38)
    uint8_t  goto_y;             // +0x0A
    uint8_t  heading;            // +0x0B facing 0..7, 8 = none (xor-4 reverse @0x047AA8; bound @0x0516F0)
    uint8_t  cargo_count;        // +0x0C goods in hold (@0x0B2AB)
    uint8_t  cargo_ids[3];       // +0x0D nibble-packed good ids, up to 6 (@0x0B2CB)
    uint8_t  cargo_qty[2];       // +0x10 per-slot quantities (@0x0B2FB)
    uint16_t timer;              // +0x12 overloaded: AI/native = snapshot of [0x538E] (@0x06DB3); player = byte 0xFF then rand 0..0x13 (@0x06DA3/@0x50C75)
    uint8_t  moved_flag;         // +0x14 per-turn land-unit boolean; read only for Wagon Trains (@0x04968D/@0x04F730/@0x0507E1; exact label runtime-open)
    uint8_t  tools;              // +0x15 pioneer tools 0..100, -20/action (@0x4060F)
    uint8_t  work_counter;       // +0x16 turns in clear/road/fortify activity (@0x04071D)
    uint8_t  class_prof;         // +0x17 colonist profession 0x13..0x1C; on route units: low nibble = route id, high = stop idx (@0x5B60E / @0x0075D4)
    uint16_t occ_back;           // +0x18 per-tile occupancy list back link (@0x06976)
    uint16_t occ_next;           // +0x1A next link (@0x06968)
} UnitRecord;                    // fully mapped
```

### A.2 ColonyRecord — 0xCA bytes, array head DGROUP:0x5D46, ~50 slots

Reached via the active-colony far pointer `[0x8542]` (0 at boot, real after
founding; slot free when the name at +0x02 is empty; slots are recycled).

```c
typedef struct {                 // stride 0xCA; serialized to save-games
    uint8_t  map_x;              // +0x00
    uint8_t  map_y;              // +0x01
    char     name[24];           // +0x02 NUL-terminated
    uint8_t  owner_power;        // +0x1A 0..3 (colony-burn trace)
    uint8_t  foreign_status;     // +0x1B (runtime-verified; semantics open)
    uint8_t  status_flags;       // +0x1C per-colony status byte
    uint8_t  flags_1d;           // +0x1D bit 0x80 only (test @0x551D8, set @0x55C20, clear @0x55A2F)
    uint8_t  countdown_1e;       // +0x1E gated by +0x8E (@0x4D9C7, 14 sites)
    uint8_t  population;         // +0x1F size (burn-loot formula @0x05DE1E)
    uint16_t flags_20;           // +0x20 (runtime-verified; foreign-marker byte at low half)
    uint16_t state_22;           // +0x22 packed state (runtime-verified)
    uint16_t unused_24;          // +0x24 NO static accessor exists; 0 in live dumps
    // +0x26..+0x3F unmapped (26 bytes)
    uint8_t  job_skills[32];     // +0x40 1 byte per colonist, live length = population (runtime-verified); declared span to +0x5F
    uint8_t  bldg_mask_60[6];    // +0x60 buildings-constructed bitmask (runtime-verified observation)
    // +0x66..+0x6F unmapped (10 bytes)
    uint8_t  tile_workers[8];    // +0x70 colonist idx per surrounding tile, NW..SE, 0xFF empty (runtime-verified)
    // +0x78..+0x83 unmapped (12 bytes)
    uint8_t  constructed_mask;   // +0x84 building mask (static accessor cite)
    // +0x85..+0x8D unmapped (9 bytes)
    uint8_t  gate_8e;            // +0x8E gates the +0x1E countdown
    // +0x8F..+0x91 unmapped (3 bytes)
    uint8_t  hammers;            // +0x92 build progress (paired with +0xB6)
    // +0x93..+0x94 unmapped (2 bytes)
    uint8_t  warehouse_level;    // +0x95
    uint8_t  counter_96;         // +0x96 inc/dec counter (@0x2C244/@0x5C474)
    // +0x97..+0x98 unmapped (2 bytes)
    uint8_t  unused_99;          // +0x99 NO static accessor; 0 in live dumps
    uint16_t stockpile[16];      // +0x9A per-good cargo, NAMES @CARGO order (runtime-verified against the in-game bar)
    uint16_t hammers_b6;         // +0xB6 build-progress pair of +0x92
    // +0xB8..+0xB9 unmapped (2 bytes)
    uint8_t  power_flag[4];      // +0xBA per-power byte flags, init 1 in the colony-reset loop (@0x2ED7A)
    uint8_t  power_flag2[4];     // +0xBE paired array, init 0 (@0x2ED7F)
    int32_t  rebel_dividend;     // +0xC2 Sons-of-Liberty numerator (runtime-verified)
    int32_t  rebel_divisor;      // +0xC6 denominator; SoL% = dividend/divisor
} ColonyRecord;
```

### A.3 RouteRecord (0x4A) and StopRecord (0x0A) — trade routes

Routes live in their own segment 0x1B22, base offset 0, max 12
(`select_route` = `func_05FE60`; count `[0x53A0]`, cap @0x610B5; delete
shifts 0x4A bytes @0x605DB).

```c
typedef struct {
    uint16_t destination;        // +0x00 colony id (record = id*0xCA + 0x5D46), 0x3E7 = Europe, 0x3E8 = none (@0x05FEE1)
    uint8_t  counts;             // +0x02 low nibble = UNLOAD count (lanes +0x06..), high = LOAD count (lanes +0x03..) (@0x060382)
    uint8_t  goods[7];           // +0x03 nibble-packed good ids, 2 per byte: +0x03..+0x05 load lanes, +0x06..+0x08 unload lanes (@0x603DA)
} StopRecord;                    // 0x0A bytes

typedef struct {
    char       name[32];         // +0x00 route name (memcpy @0x61273; uniqueness strcmp @0x611FF)
    uint8_t    type;             // +0x20 0 = sea, 1 = land (@0x61282)
    uint8_t    cursor;           // +0x21 current-stop cursor (init 2 @0x61286; inc @0x60C7A)
    StopRecord stops[4];         // +0x22 up to 4 stops (set_stop_ptr @0x05FE7A)
} RouteRecord;                   // 0x4A bytes; unit binding = UnitRecord +0x17 nibbles
```

### A.4 PowerRecord — 0x13C bytes, base DGROUP:0x8808, 12 entries

Entries 0..3 are the European powers, 4..11 the native tribes. (Earlier
field cites off a base of 0x8809 are the same bytes: that table's +0x21
gold / +0x25 loot / +0x29 treasury are +0x22/+0x26/+0x2A here.)

```c
typedef struct {                 // stride 0x13C
    uint8_t  treasure_pool;      // +0x00 (SMITE multiplier trace)
    uint8_t  tax_pct;            // +0x01 0..100 (@0x034AE0 chain)
    uint8_t  rebel_sentiment;    // +0x02 0..100 (runtime-verified vs display)
    // +0x03..+0x06 unmapped (4 bytes; +0x06 = attribute-bitfield start)
    uint32_t ff_bitmask;         // +0x07 acquired Founding Fathers, bit = FF idx (reader func_00BC10 @0x00BC10)
    // +0x0B unmapped (1 byte)
    uint16_t bells_next_ff;      // +0x0C bells toward next FF, resets on acquisition (runtime-verified)
    uint16_t bells_per_turn;     // +0x0E
    uint16_t crosses_per_turn;   // +0x10
    // +0x12..+0x13 unmapped (2 bytes)
    uint16_t ff_count;           // +0x14
    // +0x16..+0x1D unmapped (8 bytes)
    uint16_t artillery_bought;   // +0x1E Europe artillery escalation counter (read x100 @0x035124; inc @0x035282; zeroed @0x03662F)
    uint16_t boycott_bits;       // +0x20 bit i = good i boycotted (runtime-verified)
    int32_t  royal_money;        // +0x22 King's REF budget (runtime-verified: +18/turn at Discoverer)
    int32_t  unknown_26;         // +0x26
    uint32_t gold;               // +0x2A treasury (write-back updates UI)
    // +0x2E..+0x31 unmapped (4 bytes)
    uint8_t  home_x;             // +0x32 spawn/relocation x (REF growth chain)
    uint8_t  home_y;             // +0x33
    uint8_t  relations[4];       // +0x34 4x4 relation matrix row (DG 0x883C, row stride 0x13C; get func_007F34, symmetric set func_007F96):
                                 //       bits: 0x02 war, 0x08 grievance-pending, 0x10 parley cooldown, 0x20 met, 0x40 peace treaty, 0x80 privateer-hidden
    // +0x38..+0x3F unmapped (8 bytes)
    uint8_t  treaty_respect;     // +0x40 counter, seed 2*(6-difficulty), halved w/ Franklin (@0x059B00; AI attack-abort @0x03F163; decrement site unlocated)
    // +0x41..+0x43 unmapped (3 bytes)
    uint8_t  ref_bytes[3];       // +0x44 disputed: one runtime dump write-verified as REF dragoons/regulars/artillery, another found it stale; the King's code reads the globals 0x53DA..0x53E1 instead
    // +0x47..+0x4B unmapped (5 bytes)
    uint8_t  mkt_sensitivity[16];// +0x4C per good (measured; not byte-cited)
    int16_t  mkt_pool[16];       // +0x5C (measured; not byte-cited)
    int32_t  mkt_traded[16];     // +0x7C (measured; not byte-cited)
    int32_t  mkt_eu_supply[16];  // +0xBC (measured; not byte-cited)
    int32_t  mkt_base[16];       // +0xFC (measured; not byte-cited)
} PowerRecord;                   // ends exactly at +0x13C
```

### A.5 AIPersonality — 0x34 bytes, base DGROUP:0x540E, 4 entries

European powers only (tribes use TribeData instead). Leader/region name
pointers used by the diplomacy text filler are `0x540E + p·0x34` and
`0x5426 + p·0x34`.

```c
typedef struct {                 // stride 0x34
    char    leader_name[24];     // +0x00 e.g. "Walter Raleigh" (runtime-verified; NAMES @LEADERNAME)
    char    country_name[24];    // +0x18 e.g. "New England"
    uint8_t unknown_30;          // +0x30 (English = 0xC0; unlabelled)
    uint8_t is_active;           // +0x31
    uint8_t unknown_32;          // +0x32
    uint8_t unknown_33;          // +0x33
} AIPersonality;
```

### A.6 TribeData — 0x4E bytes, base DGROUP:0x5AD6, 8 entries

Selected by `set_active_tribe` (`func_0081C6`): `[0x8D4E] = 0x5AD6 +
tribe_idx·0x4E`.

```c
typedef struct {                 // stride 0x4E
    // +0x00..+0x01 unmapped (2 bytes)
    uint8_t settlement_size_factor; // +0x02 raze-formula multiplier (@0x04AB24 trace)
    // +0x03..+0x4D unmapped (75 bytes)
} TribeData;
```

### A.7 NativeSettlement — 0x12 bytes, base DGROUP:0x54EC, ≥60 slots

The table is compacted on raze; walk from index 0 until an (0,0) coordinate
pair.

```c
typedef struct {                 // stride 0x12
    uint8_t map_x;               // +0x00
    uint8_t map_y;               // +0x01
    uint8_t owner_power;         // +0x02 4..11
    uint8_t flags;               // +0x03 0x02 taught, 0x04 mission/capital, 0x08 visited, 0x40 event
    uint8_t population;          // +0x04 CHIEFKILL size byte (user-verified raze payout)
    uint8_t mission;             // +0x05 0xFF none, else 0x10 | power 0..3 (user-verified)
    int8_t  growth_counter;      // +0x06 +population per turn; spawns/grows at 20
    uint8_t sentinel;            // +0x07 always 0xFF
    uint8_t last_bought;         // +0x08 cargo idx of last good bought here
    uint8_t last_sold;           // +0x09
    struct { uint8_t friction, attacks; } alarm[4]; // +0x0A per European power
} NativeSettlement;              // fully mapped
```

### A.8 VICEROY dialog struct (the @-directive dialog framework)

Allocated per dialog; accessed as a far pointer (`les bx,[bp+4]` in the
finalizer `func_06D316`). Field cites are the construct/pump sites.

```c
typedef struct {
    uint16_t opt_count;          // +0x02 option-row count (appender func_06C850 @0x06CA2B)
    uint16_t text_count;         // +0x04 text-line count (appender func_06CA82 @0x06CB87)
    uint16_t third_count;        // +0x08 third item-class count (@0x06CD57)
    uint16_t flags;              // +0x0A 0x10 borderless, 0x40 off-screen, 0x20 sibling-attach; checkbox sets |=5
    int16_t  req_x, req_y;       // +0x0C/+0x0E from @x/@y; -1 = centre sentinel (@0x06F2A6/@0x06F25E)
    int16_t  x, y;               // +0x10/+0x12 final on-screen origin
    uint16_t w, h;               // +0x14/+0x16 box size
    uint16_t rect[4];            // +0x18 final absolute rect (@0x06D5B9)
    uint16_t longest_line_px;    // +0x20 (clamp @0x06D392)
    uint16_t pad;                // +0x22 = 4, option-row x-indent component (@0x06C5AC)
    uint16_t content_x;          // +0x24 (flags&0x10)?0:3; option rows at box_x+9 (@0x06D9D6)
    uint16_t row_y_seed;         // +0x26 = inset'(3)+border(3), bumped past the text block (@0x06D440)
    uint16_t width_floor;        // +0x28 init 0x50, @WIDTH override (@0x06CA7B)
    uint16_t text_x, text_y;     // +0x2A/+0x2C text-line origin seeds (lines at box_x+5)
    // +0x2E..+0x3B partially mapped (+0x32 = 4; +0x34 width term)
    uint16_t fill_color[2];      // +0x3C from [0x1F3C]/[0x1F3E] (= TEXTCOLR.SS sprite 1/2 pixel); value 7 = wood-tile fill sentinel
    uint16_t sel_color[2];       // +0x40 selection band from [0x1F40]/[0x1F42] (boot value 0x37)
    uint16_t ring2_color;        // +0x44 from [0x1F44]
    uint16_t border;             // +0x46 (flags&0x10)?0:3
    uint16_t inset;              // +0x48 (flags&0x10)?0:2
    uint16_t content_h_cursor;   // +0x4A summed as items append; H = 2*this + border
    // +0x4C..+0x53 unmapped (8 bytes)
    void far *opt_head;          // +0x54 option-row list (painter func_06D9CC)
    void far *text_head;         // +0x58 text-line list (painter func_06CFE8)
    void far *widget_head;       // +0x5C child/widget list (pump loop B @0x06E699)
    void far *prompt_head;       // +0x60 prompt/third-class list (painter func_06DC64)
    // +0x64..+0x67 unmapped (4 bytes)
    void far *submenu;           // +0x68 attached submenu; on widget nodes: the sprite far-ptr blitted (@0x06D952)
    // +0x6C..+0x73 unmapped (8 bytes)
    uint16_t ink_record[8];      // +0x74 built by func_06C296: +2 normal<-[0x1F4A], +4 disabled<-[0x1F4C], +6 hilite<-[0x1F4E], +8/+A aux, +C/+E font ptr
    // ({ and } in any string toggle the hilite latch [0x1F62])
    void far *font_key;          // +0x80 identity/font latch (@SMALLFONT stores the FONTTINY latch here @0x06F211)
} Dialog;                        // ~0x84+ bytes; trailing size unmapped

typedef struct {                 // one option row (appender @0x044DCE region)
    uint16_t flags;              // +0x00 bit 0 = text empty -> pump skips
    uint16_t scalar;             // +0x02 accelerator column or pixel width (callee untraced)
    uint16_t command_id;         // +0x04 id the row fires
    char far *text;              // +0x06
    // +0x0A..+0x0D reserved, never written (4 bytes)
    void far *next;              // +0x0E
} DialogRowNode;
```

### A.9 Menu-bar structs (VICEROY page-0x0A module = MAPEDIT menu.obj)

The in-game menu bar object lives at `[0x896]` (built by `func_072090`
@0x0720AC from MENU.TXT); MAPEDIT builds its bar from MAPMENU.TXT with the
same module (`_menu_bar` DS:0x78). All offsets byte-cited in the VICEROY
copy; the MAPEDIT node shapes match (result word +0, first menu +0x38,
first item +0x1E).

```c
typedef struct {                 // menubar (creator func_044836)
    uint16_t result_id;          // +0x00 selected command id (write @0x045895; 0 = none)
    uint16_t bar_y;              // +0x04 = 1
    uint16_t title_gap;          // +0x06 = 0x0C
    uint16_t item_leading;       // +0x08 = 3
    uint16_t title_x_pad;        // +0x0A = 1
    uint16_t bar_colors[2];      // +0x0E from [0x149C]/[0x149E]
    uint16_t hilite_colors[2];   // +0x1A from [0x14A8]/[0x14AA]
    uint8_t  title_font[12];     // +0x20 font descriptor (far string ptr at +0x28)
    uint8_t  item_font[12];      // +0x2C (far string ptr at +0x34)
    void far *first_menu;        // +0x38
} MenuBar;

typedef struct {                 // menu node, 0x22 bytes (alloc @0x044BD9)
    uint16_t x;                  // +0x02 = prev.x + prev.width + gap (first title x = 0x0C)
    uint16_t title_w;            // +0x04
    uint16_t panel_inner_w;      // +0x06 init 0x0A
    uint16_t hotkey;             // +0x08 title hotkey char
    uint16_t flags;              // +0x0C bit 0 = disabled
    char far *title;             // +0x0E
    void far *owner;             // +0x12 owning menubar
    void far *next;              // +0x16
    void far *prev;              // +0x1A
    void far *first_item;        // +0x1E
} MenuNode;

typedef struct {                 // item node
    uint16_t flags;              // +0x00 bit 0 disabled, bit 1 hidden
    uint16_t shortcut;           // +0x02
    uint16_t command_id;         // +0x04 (returned into menubar +0)
    char far *label;             // +0x06 empty first byte = separator
    void far *next;              // +0x0E
    void far *prev;              // +0x12
} MenuItemNode;
```

Dropdown layout (`func_044FA4`): panel x = menu.x; y = bar_y +
title-height + 3; w = panel_inner_w + 2; h = visible·(item_font_h +
leading) + leading + 2; clamps right ≤ 0x13D, bottom ≤ 0xC7 —
instruction-identical in both programs (§28.8).

### A.10 MAPEDIT terrain record and popup result

```c
typedef struct {                 // MAPEDIT _load_data terrain table, 29 records
    char   *name;                // +0x00 near ptr into the NAMES text pool
    uint8_t num_a, num_b, num_c; // +0x02..+0x04 NAMES numeric columns 1-3
    // +0x05..+0x06 unmapped (2 bytes)
    uint8_t nums[9];             // +0x07..+0x0F NAMES numeric columns 4-12 (column 13 never read)
} MapeditTerrainRec;             // 16 bytes

typedef struct {                 // MAPEDIT popup object (popup.obj)
    uint16_t result;             // +0x00 selected item id 1..n; 0xFFFF = ESC (@popup_exec @0x6F5E)
    // remainder unmapped (geometry/config words; constants in section 28.8)
} MapeditPopup;
```

### A.11 Sprite sheet in memory (.SS handle)

A loaded sheet handle carries a header, then **12-byte frame records at
+0x36**, indexed by the 1-based engine frame number: record =
`handle + 0x36 + 12·(frame−1)` (VICEROY draw verb `func_00E76A`; the
OPENING blit routine at its file 0x4520 uses the same layout).

```c
typedef struct {                 // per-frame record, stride 12
    // +0x00..+0x03 unmapped (4 bytes; pixel-data reference)
    int16_t  anchor_x;           // +0x04 = frame CENTRE x  (screen x = anchor_x - w/2)
    int16_t  anchor_y;           // +0x06 = frame BOTTOM y  (screen y = anchor_y - h + 1)
    uint16_t width;              // +0x08
    uint16_t height;             // +0x0A (y-extent)
} SSFrameRec;                    // sheet dims at handle +0x4A/+0x4C
```

The (centre-x, bottom-y) anchor semantics were proven twice independently
by pixel diff (the King-audience figure and throne-canopy banner land
exactly where `ax−⌊w/2⌋, ay−h+1` predicts). Pixel value 0xFD in a decoded
frame is transparent.

## B. Appendix — sprite sheets and palette

All numbers in this appendix were decoded directly from the shipped
MADSPACK 2.0 containers (header `"MADSPACK 2.0"`, section directory,
FAB-compressed sections; frames stored RLE with transparent index 0xFD) —
nothing is transcribed from secondary notes. The disc set contains **206
`.SS` sheets**. Frame numbering: **disk index = 0-based descriptor order;
engine frame = disk + 1** (the convention proven in §29.1). Roles are
stated only where the project established them; everything else is counted
but left unlabelled.

### B.1 TERRAIN.SS — 12 frames, all 16×16 (the base-ground sheet)

Loaded at boot and on map-enter; composited UNDER the PHYS0.SS overlays.
Frame = ground id per the loaders in both programs (VICEROY fold at file
0x6204; MAPEDIT `_tile_id` @0x46CE). MAPEDIT's mini-map colours sample
pixel (8,8) of each frame.

| disk | engine | size | ground |
|------|--------|------|--------|
| 0 | 1 | 16×16 | Tundra |
| 1 | 2 | 16×16 | Desert |
| 2 | 3 | 16×16 | Plains |
| 3 | 4 | 16×16 | Prairie |
| 4 | 5 | 16×16 | Grassland |
| 5 | 6 | 16×16 | Savannah |
| 6 | 7 | 16×16 | Marsh |
| 7 | 8 | 16×16 | Swamp |
| 8 | 9 | 16×16 | Scrub floor (ground for ids 9 and 0x11 — forested Desert) |
| 9 | 10 | 16×16 | Arctic |
| 10 | 11 | 16×16 | Ocean |
| 11 | 12 | 16×16 | Sea Lane |

### B.2 PHYS0.SS — 154 frames (terrain overlay sheet)

All frames 16×16 except the three 1×1 placeholders (disk 0, 16, 100 —
never drawn: river mask 0 is remapped to the isolated form 0xF) and the
8×8 beach-halo band (disk 108–139).

| disk band | engine | size | role |
|-----------|--------|------|------|
| 0 | 0x01 | 1×1 | placeholder (major-river mask 0, unreachable) |
| 1–15 | 0x02..0x10 | 16×16 | major rivers, 4-neighbour mask N8/S4/W2/E1; isolated = mask 0xF |
| 16 | 0x11 | 1×1 | placeholder (minor-river mask 0) |
| 17–31 | 0x12..0x20 | 16×16 | minor rivers (same masks; majors/minors interconnect via terrain bit 0x40) |
| 32–47 | 0x21..0x30 | 16×16 | mountains, mask over neighbours with equal `byte&0xA0` |
| 48–63 | 0x31..0x40 | 16×16 | hills (same adjacency; hills never connect to mountains) |
| 64–79 | 0x41..0x50 | 16×16 | forest, mask over neighbouring forests; desert scrub (id&7==1) never connects |
| 80–88 | 0x51..0x59 | 16×16 | roads: isolated = engine 0x51; else ONE frame per set 8-dir bit, engine 0x52+d |
| 89–99, 101–102 | 0x5A..0x67 | 16×16 | terrain-detail / prime-resource band (position hash + DTAB class; mountains draw ore/gold engine 0x66, hills rock engine 0x67) |
| 100 | 0x65 | 1×1 | placeholder inside the detail band |
| 103 | 0x68 | 16×16 | surf / lost-city-rumor circle (suppressed when the continent-plane owner nibble ≠ 0xF) |
| 104–107 | 0x69..0x6C | 16×16 | dither-blend stencils N,E,S,W (class-boundary and fog-edge blends) |
| 108–139 | 0x6D..0x8C | 8×8 | beach-halo quadrant sub-tiles, engine 0x6D+quad+4·code (code-0 frames disk 108–111 are all-zero punch-throughs) |
| 140–147 | 0x8D..0x94 | 16×16 | river mouths on water: base engine 0x8D (major) / 0x91 (minor) + cardinal direction |
| 148 | 0x95 | 16×16 | unexplored/fog tile |
| 149 | 0x96 | 16×16 | wave/hatch shore overlay (feature-layer bit 0x40; dormant in the standard game) |
| 150–153 | 0x97..0x9A | 16×16 | the four straight-coast shorelines, by edge class |

### B.3 ICONS.SS — 131 frames (HUD, goods, units, markers)

Mixed sizes; established bands (disk numbering, engine gloss):

| disk | engine | size | role |
|------|--------|------|------|
| 0–3 | 1..4 | 21×16 | colony map markers (drawn with the pennant on the map and colony scene) |
| 4 | 5 | 1×1 | placeholder |
| 5–7, 14–15, 127 | 6..8, 15..16, 0x80 | 13–14×16 | ship unit icons (@UNIT icon column; e.g. Privateer eng 15, Frigate eng 16, Man-O-War eng 128 = disk 127) |
| 18–21 | 0x13..0x16 | 16/8/4/2 px | map cursor set, engine 0x13+zoom (MAPEDIT blink cursor) |
| 22–37 | 0x17..0x26 | 6–13×12 | the 16 goods icons, @CARGO order (Europe market bar and colony stockpile bar, icon y=181) |
| 67–69 | 0x44..0x46 | 14×13 | button/flag plaques (colony flag panel = engine 0x44, frame = nation) |
| 81–108 | 0x52..0x6D | 6–14×16 | unit figure band; foot-unit icons disk 100–105 + 109 (Colonist eng 101 = disk 100, Soldier eng 103 = disk 102) |
| 118–121 | 0x77..0x7A | 6×5 | nation pennants, engine 0x77+power (colony markers) |
| 122 | 0x7B | 10×12 | cargo crate (Europe dock slots at (147+12·slot,165); colony dock boxes) |
| 124 | 0x7D | 13×11 | crown (colony Sons-of-Liberty/Tory band) |
| remainder | — | various | not yet role-assigned (incl. disk 38–66 second 12-px band, 70–80, 110–117, 123, 125–126, 128–130) |

### B.4 BUILDING.SS — 48 frames (colony buildings)

Drawn frame = **def + 1** in engine numbering, i.e. **disk frame = def
id**, named from NAMES.TXT `@BUILDING` (42 defs). Special cases at the
colony composer: def 0 with build-query 0 → engine 0x11 (disk 16); defs
0x0F/0x11 with garrison → engine 0x2F/0x30 (disk 46/47); empty plots draw
a per-category frame from the DS:0x260 table minus one. 1×1/2×2 entries
are placeholder descriptors.

| disk (=def) | size | building |
|------|------|----------|
| 0 | 73×18 | Stockade |
| 1 | 73×18 | Fort |
| 2 | 73×18 | Fortress |
| 3 | 44×22 | Armory |
| 4 | 44×22 | Magazine |
| 5 | 44×22 | Arsenal |
| 6 | 75×48 | Docks |
| 7 | 75×48 | Drydock |
| 8 | 75×48 | Shipyard |
| 9 | 53×37 | Town Hall |
| 10 | 1×1 | Town Hall (level 2 — placeholder art) |
| 11 | 1×1 | Town Hall (level 3 — placeholder art) |
| 12 | 44×22 | Schoolhouse |
| 13 | 44×22 | College |
| 14 | 44×22 | University |
| 15 | 44×22 | Warehouse |
| 16 | 73×18 | Warehouse Expansion (also the def-0 forced-stockade frame, engine 0x11) |
| 17 | 1×1 | Stable (placeholder art) |
| 18 | 23×27 | Custom House |
| 19 | 23×27 | Printing Press |
| 20 | 23×27 | Newspaper |
| 21 | 23×27 | Weaver's House |
| 22 | 23×27 | Weaver's Shop |

| disk (=def) | size | building |
|------|------|----------|
| 23 | 23×27 | Textile Mill |
| 24 | 23×27 | Tobacconist's House |
| 25 | 23×27 | Tobacconist's Shop |
| 26 | 23×27 | Cigar Factory |
| 27 | 23×27 | Rum Distiller's House |
| 28 | 23×27 | Rum Distillery |
| 29 | 23×27 | Rum Factory |
| 30 | 1×1 | Capitol (placeholder art) |
| 31 | 2×2 | Capitol Expansion (placeholder art) |
| 32 | 23×27 | Fur Trader's House |
| 33 | 23×27 | Fur Trading Post |
| 34 | 23×27 | Fur Factory |
| 35 | 44×22 | Carpenter's Shop |
| 36 | 44×22 | Lumber Mill |
| 37 | 53×37 | Church |
| 38 | 53×37 | Cathedral |
| 39 | 23×27 | Blacksmith's House |
| 40 | 23×27 | Blacksmith's Shop |
| 41 | 23×27 | Iron Works |
| 42 | 53×37 | (extra frame; empty-plot/category art) |
| 43 | 44×22 | (extra frame) |
| 44 | 23×27 | (extra frame) |
| 45 | 75×48 | (extra frame) |
| 46 | 44×22 | garrison variant (engine 0x2F) |
| 47 | 44×22 | garrison variant (engine 0x30) |

### B.5 Small chrome sheets

| sheet | frames | sizes | role |
|-------|--------|-------|------|
| WOODTILE.SS | 1 | 32×24 | the wood background tile — menu bars, dropdowns, popup interiors, colony composer fill (fill-colour-7 sentinel selects it) |
| WOODFRAM.SS | 1 | 274×170 | woodcut-screen frame, centred from its sheet header |
| NAMEPLAT.SS | 3 | 18×14, 16×14, 18×14 | woodcut caption strip at y=162: left cap + repeated mid tile + right cap, centred on x=160 |
| CURSOR.SS | 2 | 17×17 both | mouse pointer (2 frames) |
| OPENTILE.SS | 1 | 32×24 | boot-menu plaque fill tile (tiled, phase-anchored at the box origin) |
| PARCH.SS | 1 | 32×24 | parchment fill tile |

### B.6 Inventory of the remaining sheets (counts from decode)

| sheet(s) | frames each | frame sizes | role where established |
|----------|-------------|-------------|------------------------|
| BDARK.SS | 46 | 2×2 – 75×48 | **orphan — no load path in either EXE; never loaded** |
| CC-00 .. CC-24 (25 sheets) | 1 | 31×86 – 115×114 | the 25 Founding Father portraits (Continental Congress / FF pick) |
| CLOS-BEL / -FWK / -HAT / -LDY / -MAN / -MIL / -ROC | 21 / 66 / 22 / 21 / 14 / 20 / 22 | up to 204 px wide / 89 tall (CLOS-FWK) | closing-cinematic elements (CLOSING.EXE) |
| DEC-LOWA .. DEC-LOWZ (26) | 8 | 5–11 × 22 | Declaration of Independence lettering, lower case |
| DEC-UPPA .. DEC-UPPZ (26) | 11 | 8–19 × 22 | upper case |
| DEC-SQIG | 11 | 28×22 | lettering flourish |
| DUTCH1 / ENGLND1 / FRANCE1 / SPAIN1 | 1 | 172–178 × 120–122 | King-audience nation banner, variant 1 (ENGLND1 = throne-canopy banner drawn at (32,0)) |
| DUTCH2 / ENGLND2 / FRANCE2 / SPAIN2 | 1 | 170–176 × 128–133 | nation banner, variant 2 |
| IND0A0 .. IND7A3 (32 sheets) | 1 (IND2A0: 2) | 50×141 – 153×182 | native chief speaker portraits (tribe, pose; loader name-patches "IND0A0") |
| KING.SS | 1 | 79×161 | King speaker portrait |
| KING1.SS | 1 | 189×187 | King-audience foreground figure (king + dog), drawn at (0,12) over KINGLSS1.PIK |
| KING2.SS | 8 | 79×161 | King speaker frames |
| KINGLOSE.SS | 1 | 149×179 | king crying — player wins the war |
| KINGWIN.SS | 1 | 214×198 | king triumphant — player loses |
| MPSLOGO.SS / MPSNAME.SS | 16 / 29 | 155×119 / up to 302×26 | MicroProse logo + name (opening) |
| MSS0 .. MSS5 (6) | 1 | 60×68 – 149×95 | advisor portraits (speaker channel `[0x1F5E]` 0..5) |
| MYR0 .. MYR3 (4) | 1 | 67×68 – 96×93 | European rival leader portraits (conversation channel 3) |
| OPENLOGO | 1 | 276×50 | opening title logo |
| OPENBONK / OPENCRD1-3 / OPENFISH / OPENGUY / OPENMON1-3 / OPENSHIP / OPENSUN / OPENWND1-2 | 18 / 7,7,5 / 13 / 54 / 15,32,21 / 8 / 7 / 10,11 | various | opening-cinematic elements (OPENING.EXE anim table) |
| SCORE01 .. SCORE24 (24) | 1 | 140–142 × 97–99 | score-screen panels ("SCORE"+NN filename build) |
| WDCUT01 .. WDCUT13 (13) | 1 | 192 × 113/115 | woodcut event plates (no 00/14–16 files; captions 0/14–16 unshowable) |
| WIN.SS / WIN-FWRK.SS | 1 / 46 | 320×200 / up to 200×91 | victory backdrop + fireworks |

### B.7 VICEROY.PAL — the master palette

The file is 1,024 bytes: 768 bytes of 6-bit VGA RGB (256 × 3) plus 256
trailing unused bytes. Values below are 8-bit `RRGGBB` after the standard
expansion `(v<<2)|(v>>4)`. Screens whose `.PIK` backgrounds carry an
embedded palette (the frontend/cinematic plates) replace this palette
while shown; COLONY.PIK, for example, has none and renders on VICEROY.PAL.

| base | +0 .. +15 |
|------|-----------|
| 0 | 000000 0000AA 00AA00 00AAAA AA0000 AA4900 AA5500 AAAAAA 555555 5555FF 55FF55 55FFFF FF0000 FF7100 FFFF55 FFFFFF |
| 16 | FBFBFB F3F3F3 EBEBEB E3E3E3 DBDBDB D3D3D3 CBCBCB C3C3C3 BEBEBE B6B6B6 AEAEAE A6A6A6 9E9E9E 969696 8E8E8E 868686 |
| 32 | 828282 797979 717171 696969 616161 595959 515151 494949 454545 3C3C3C 343434 2C2C2C 242424 1C1C1C 141414 0C0C0C |
| 48 | DBEFFF C3DBF3 B2CBEB 9EBADF 8EAAD7 799ACF 698AC3 5D79BA 4D65AE 4159A6 34499E 283892 202C8A 181C7D 101075 08086D |
| 64 | D7E3AA B6CF86 96BA69 75A64D 559634 348220 1C6D10 045D04 BABA41 A6AA41 9A9E41 8A8E3C 79823C 697138 5D6534 515930 |
| 80 | CF9634 BE8630 B2792C A26928 965D20 86511C 79451C 6D3C18 CFB28E BAA27D AA926D 9A825D 867151 756145 655134 55452C |
| 96 | FFFFDB F7F3C7 F3E7B6 EBDBA2 E7CB92 DFB682 DBA675 D79265 FFFBEB F3EFDB EBE3CB E3DBBA DBCFAE D3C39E CBB692 C3AE86 |
| 112 | F30000 E30000 D30000 C30000 B20000 A20000 920000 860000 4D65AE 5169B2 4961A6 4159A2 384D9E 30459A 2C3C96 283892 |
| 128 | 794934 75492C 694530 713C1C 613C28 65381C 593424 5D3018 512C20 49281C 3C2018 FF55FF FF55FF FF55FF FF55FF FF55FF |
| 144 | FFFFBE FFFF8E FFF35D FFE32C E3C328 C7A220 A67D1C 8A5D14 000000 000000 000000 000000 000000 000000 000000 000000 |
| 160 | 000000 ×16 |
| 176 | 000000 ×16 |
| 192 | 000000 ×14, 0C0C0C (206), 000000 |
| 208 | 000000 ×16 |
| 224 | 000000 ×16 |
| 240 | 000000 ×12, FF55FF FF55FF FF55FF (252–254), CFCFCF (255) |

**Cycling bands** (VGA palette rotation; pixel indices never change):

- **54–60** — the harbour-water shimmer band inside the 48–63 blue ramp
  (pixel-verified pure palette animation on the Europe screen);
- **120–127** — the sea-lane sparkle band (rotated with an 8-step phase;
  fitted per capture in every map diff).

Index 0xFD (253) doubles as the RLE transparent sentinel inside `.SS`
frames; the tribe map-marker colours cited by the raze popup data are
palette entries here (Aztec 149 = C7A220, Inca 97 = F7F3C7).
