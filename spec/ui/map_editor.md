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

*(zooms 0x24–0x2B, tile-select 0x4B?, fill-mode 0x4C?, undo 0x4E?, help
0x51+ — pending the menus/dialogs decode.)*

## 4. Main editor screen — *(pending decode: viewport/info window/mini-map layout, zoom levels, paint interaction, key map)*

Known already (B): paint masks in `_parse_spot` — Ocean id 0x19 / Sea Lane
0x1A with and-mask 0x40 (preserves river bit); Mountains `or 0xA0/and 0x1F`;
Hills `or 0x20/and 0x5F`; Major River `or 0xC0/and 0x1F`; Minor River
`or 0x40/and 0x3F` @0x2730–0x2788. Right-click pickup @0x32B7–0x32E9. The
1-tile border ring is non-editable (`_change_map` bounds @0x31E9–0x320D).
Info window shows "Coast Protect: ON/OFF" (DS:0x1A8/0x1BA) and river/terrain
names keyed on the overlay bits (`_info_window_draw` @0x2029–0x2182).

## 5. Menus & dialog engine — *(pending decode)*

## 6. Open items
1. Retail MAPEDIT.TXT/MAPMENU.TXT files absent from `raw/COLONIZE/` —
   wording sourced from the extracted JSON; obtain originals to close.
2. Layer-2 bits 3/6 (`_is_hostile` tests 0x48) — game-side, needs VICEROY's
   reader.
3. `_map_error` 9999 display path (who shows it) — TBD.
4. `@env_open` path-resolution order (`_env_special_path`) — trace env_1.obj
   init if needed.
5. VICEROY's own .MP loader per-line annotation (format cross-check).
