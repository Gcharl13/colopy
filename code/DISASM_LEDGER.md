# Disassembly Ledger

Per-line identification status of every disassembled DOS executable. **Generated** by `tools/ledger_update.py` from the `.asm` files in `code/<EXE>/disasm/`. Do not hand-edit; rerun the tool after editing any `.asm` file.

_Last updated: 2026-05-05 01:48 UTC_

## Status legend

- **RAW** — every code line is `; UNKNOWN`. Capstone output, no annotation.
- **IN-PROGRESS** — some lines have semantic comments, some still `; UNKNOWN`.
- **DONE** — every code line has a semantic comment. No `; UNKNOWN`s remain.

## Top-level summary

| Executable    |   Funcs |    Total lines | Identified |   % | RAW | IN-PROG | DONE |
|---------------|--------:|---------------:|-----------:|----:|----:|--------:|-----:|
| VICEROY       |    1241 |        212,834 |    211,479 | 99.4 |   0 |      29 | 1212 |
| MAPEDIT       |     210 |         83,318 |     83,242 | 99.9 |   0 |       1 |  209 |
| OPENING       |     145 |         56,428 |     56,281 | 99.7 |   0 |       1 |  144 |
| CLOSING       |     136 |         54,037 |     53,963 | 99.9 |   0 |       1 |  135 |

## `VICEROY.EXE`

- Functions: **1241** (DONE: 1212, IN-PROGRESS: 29, RAW: 0)
- Function code lines: 59,489 (identified: 58,814)
- Orphan code lines: 153,345 (identified: 152,665)
- Grand total: **212,834** lines, **99.36%** identified.

| Offset | Name | Lines | Ident | % | Status | Purpose |
|--------|------|------:|------:|--:|--------|---------|
| 0x002400 | `open_output_stream` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x00242C | `format_int_to_stream` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x002462 | `find_char_in_buffer` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x002494 | `map_int_to_screen_code` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x0024C6 | `unknown` | 44 | 44 | 100 | DONE | UNKNOWN |
| 0x002544 | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x00260E | `format_to_buffer_2D54` | 15 | 15 | 100 | DONE | Twice calls the format engine at 0x0D1D:0x11B4 with the buffer at DGROUP:0x2D54: first to format the caller's two arguments ([bp+6], [bp+8]) into the buffer, then again with constant 0x4D (77) — likely terminator append or finalisation pass. |
| 0x002632 | `write_int_via_format` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x002648 | `format_long_via_8FA` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x002668 | `format_long_via_916` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x00268C | `format_via_lib_4B_1E8` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x0026D4 | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x00273E | `unknown` | 5 | 5 | 100 | DONE | UNKNOWN |
| 0x00275C | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x002783 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x002892 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x0028B0 | `call_overlay_with_80` | 7 | 7 | 100 | DONE | Pushes 0x50 (80) and the caller's argument [bp+6], then far-calls 0x0D1D:0x07A4 (overlay-resident helper). The 0x50 likely identifies a fixed target-id (screen/menu/buffer-id 80 per a runtime lookup table), so this is a 'call-helper-X-with-context-Y' wrapper. |
| 0x0028C0 | `repeat_dispatch_op_50` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x0028E2 | `dispatch_overlay_op_52` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x0028F2 | `dispatch_overlay_op_55` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x002902 | `dispatch_overlay_op_58` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x002912 | `dispatch_overlay_op_5C` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x002922 | `dispatch_overlay_op_5E` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x002932 | `dispatch_overlay_op_60` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x002942 | `dispatch_overlay_op_62` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x002952 | `dispatch_overlay_op_64` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x002962 | `dispatch_overlay_op_66` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x002972 | `dispatch_overlay_op_68` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x002982 | `dispatch_overlay_op_6A` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x002992 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x0029AC | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x0029DE | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x002A06 | `unknown` | 42 | 42 | 100 | DONE | UNKNOWN |
| 0x002A6E | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x002A98 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x002AC6 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x002AE2 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x002AFE | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x002B38 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x002B72 | `unknown` | 33 | 33 | 100 | DONE | UNKNOWN |
| 0x002BC8 | `unknown` | 36 | 36 | 100 | DONE | UNKNOWN |
| 0x002C0C | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x002C4A | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x002C82 | `unknown` | 35 | 35 | 100 | DONE | UNKNOWN |
| 0x002CE0 | `unknown` | 37 | 37 | 100 | DONE | UNKNOWN |
| 0x002D28 | `unknown` | 35 | 35 | 100 | DONE | UNKNOWN |
| 0x002D74 | `unknown` | 87 | 87 | 100 | DONE | UNKNOWN |
| 0x002E4E | `unknown` | 53 | 53 | 100 | DONE | UNKNOWN |
| 0x002EE4 | `unknown` | 134 | 134 | 100 | DONE | UNKNOWN |
| 0x00304A | `unknown` | 58 | 58 | 100 | DONE | UNKNOWN |
| 0x003104 | `unknown` | 55 | 55 | 100 | DONE | UNKNOWN |
| 0x003193 | `unknown` | 213 | 213 | 100 | DONE | UNKNOWN |
| 0x0033F2 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x00341E | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x003436 | `terrain_id_normalize_to_8` | 10 | 10 | 100 | DONE | Maps terrain id 17 (0x11) or 9 to 8; passes other values through. Likely converts "forested" variants to a base terrain id, or normalises a special-case terrain value used by the renderer. Returns AX = normalised id. |
| 0x003460 | `unknown` | 40 | 40 | 100 | DONE | UNKNOWN |
| 0x0034C4 | `unknown` | 49 | 49 | 100 | DONE | UNKNOWN |
| 0x003536 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x0035EC | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x003710 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x0037BE | `unknown` | 36 | 36 | 100 | DONE | UNKNOWN |
| 0x00380C | `unknown` | 38 | 38 | 100 | DONE | UNKNOWN |
| 0x00386A | `unknown` | 37 | 37 | 100 | DONE | UNKNOWN |
| 0x003E40 | `unknown` | 64 | 64 | 100 | DONE | UNKNOWN |
| 0x004314 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x0043B1 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x004566 | `unknown` | 111 | 111 | 100 | DONE | UNKNOWN |
| 0x0048CC | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x0048EA | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x004900 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x00493C | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x004984 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x0049B4 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x0049FC | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x004A5C | `wait_for_keypress` | 16 | 16 | 100 | DONE | Block until the user presses a key, calling a periodic-refresh helper between polls. The loop body is: (1) call helper at 0x029F:0x00F6 (cursor blink / status-bar refresh / screensaver-defeat — to be confirmed when that function is annotated); (2) call kbhit (file 0xD272) — if no key pending, loop back; (3) call getch (file 0xD286) to consume the key; (4) return AX = the key value. Used wherever the game wants 'press any key to continue' input — title screen, end-of-turn prompt, message-box dismiss. |
| 0x004A80 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x004AFA | `drain_keyboard_buffer` | 11 | 11 | 100 | DONE | Discard every pending keystroke. Loops: kbhit; if AX=0, exit; else getch to consume it, then kbhit again. Used at points where the game wants to ignore keystrokes that arrived during a long-running operation (animation, file load) — common in DOS games to prevent 'stuck' input from advancing dialogs unintentionally. |
| 0x004B16 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x004B48 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x004B72 | `unknown` | 141 | 141 | 100 | DONE | UNKNOWN |
| 0x004D1E | `unknown` | 69 | 69 | 100 | DONE | UNKNOWN |
| 0x004DF8 | `unknown` | 36 | 36 | 100 | DONE | UNKNOWN |
| 0x004EE6 | `unknown` | 89 | 89 | 100 | DONE | UNKNOWN |
| 0x0050BC | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x0050F0 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x0050FC | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x005108 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x00513C | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x005160 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x0051D2 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x005234 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x005296 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x00531C | `unknown` | 32 | 32 | 100 | DONE | UNKNOWN |
| 0x0053DE | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x005418 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x00543C | `unknown` | 52 | 52 | 100 | DONE | UNKNOWN |
| 0x0054DA | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x00566E | `unknown` | 43 | 43 | 100 | DONE | UNKNOWN |
| 0x0056F2 | `unknown` | 36 | 36 | 100 | DONE | UNKNOWN |
| 0x005760 | `unknown` | 42 | 42 | 100 | DONE | UNKNOWN |
| 0x005BFA | `is_xy_in_map_bounds` | 18 | 18 | 100 | DONE | Returns 1 if a 2D map coordinate (x,y) is strictly inside the playable map area (1 <= x < map_width-1 AND 1 <= y < map_height-1), 0 otherwise. The map dimensions are read from DGROUP:0x853A (width) and DGROUP:0x853C (height). Used by movement-validation, sight-radius, and rendering code to test whether to read a tile. |
| 0x005C2C | `unknown` | 49 | 49 | 100 | DONE | UNKNOWN |
| 0x005CB0 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x005CE6 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x005CFE | `map_tile_read_layer_15C` | 10 | 10 | 100 | DONE | Reads a byte from one of the game's map tile-data layers. Computes byte offset = y * map_width + x, then loads ES = [DGROUP:0x15E] and uses BX = (offset + [DGROUP:0x15C]) to read the tile byte at ES:BX. The far pointer at DGROUP:[0x15C..0x15F] is the base of one of the map's parallel layers (probably the terrain-id layer based on its high call frequency). |
| 0x005D1A | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x005D32 | `map_tile_read_layer_160` | 10 | 10 | 100 | DONE | Sister function of map_tile_read_layer_15C — reads from a DIFFERENT map layer. Same indexing scheme (y*map_width + x) but the far pointer base is at DGROUP:[0x160..0x163]. The two layers together form the parallel-array tile-data structure (probably terrain id + terrain features, OR base terrain + overlays). |
| 0x005D4E | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x005D84 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x005D9C | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x005DBA | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x005DCC | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x005DF0 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x005E18 | `unknown` | 46 | 46 | 100 | DONE | UNKNOWN |
| 0x005E90 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x005ED0 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x005EE8 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x005F04 | `map_xy_bounds_or_neg1` | 12 | 12 | 100 | DONE | Wrapper around `is_xy_in_map_bounds`: returns 0xFFFF (= -1 sentinel) if (x,y) is out of bounds, otherwise returns 0. Used for early-exit branch protection in map-iteration code. |
| 0x005F48 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x005F82 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x005FD4 | `map_xy_bounds_or_neg1_alt` | 12 | 12 | 100 | DONE | Sister of map_xy_bounds_or_neg1 (file 0x5F04). Same logic — wraps is_xy_in_map_bounds, returns -1 on out-of-bounds, 0 otherwise. Probably a parallel entry from a different overlay segment. |
| 0x006018 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x00603A | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x0060A0 | `unknown` | 45 | 45 | 100 | DONE | UNKNOWN |
| 0x006188 | `unknown` | 33 | 33 | 100 | DONE | UNKNOWN |
| 0x006204 | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x00624E | `unknown` | 5 | 5 | 100 | DONE | UNKNOWN |
| 0x00627A | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x0062B4 | `is_tile_walkable_or_special` | 18 | 18 | 100 | DONE | Calls overlay helper at 0x037F:0x10E with (x, y), masks the result's low 5 bits (terrain-id mask), and returns 0 if the result is 0x19 (= 25) or 0x1A (= 26). For other values, falls through to the same return path with AX=0. Looks like 'is this tile NOT a special-passable type'. |
| 0x0062E2 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x00631A | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x0063B6 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x0063D5 | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x006468 | `unknown` | 33 | 33 | 100 | DONE | UNKNOWN |
| 0x0065C4 | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x006608 | `unknown` | 40 | 40 | 100 | DONE | UNKNOWN |
| 0x006672 | `unit_chain_resolve` | 16 | 16 | 100 | DONE | Chain-follow utility for the unit table at DGROUP:0x3144 (stride 0x1C = UnitRecord). Walks tile-chain link words at +0x18/+0x1A within each entry (DGROUP:0x315C prev / 0x315E next): starting from index AX, repeatedly follows the field while the value is non-negative; stops on the first negative value and returns the LAST POSITIVE index. Implements the equivalent of 'find the leader of this unit's chain' — used when units are linked in some equivalence class (probably the cargo / passenger / stack chain). 15 callers. |
| 0x0066BA | `unit_field_lookup_simple` | 9 | 9 | 100 | DONE | Reads a 16-bit field from the unit table. Stride is 0x1C (28 bytes — the well-known UnitRecord size from FUNCTIONS_INVENTORY.md). Index AX (signed 16-bit); on negative input returns AX unchanged (caller convention for 'no unit'). On nonnegative input returns the word at DGROUP:[0x315E + AX*0x1C] = field +0x1A (next-link) of UnitRecord[AX] (base 0x3144). Called 18 times — the most-called custom utility function in the load image. |
| 0x0066CC | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x00679E | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x0067F0 | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x00684C | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x006874 | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x0068AA | `unknown` | 52 | 52 | 100 | DONE | UNKNOWN |
| 0x00693A | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x0069D2 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x0069EE | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x006A10 | `unknown` | 42 | 42 | 100 | DONE | UNKNOWN |
| 0x006A7C | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x006AAE | `unknown` | 38 | 38 | 100 | DONE | UNKNOWN |
| 0x006B46 | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x006CCA | `unit_table_offset_calc` | 5 | 5 | 100 | DONE | Computes unit-table byte offset for index AX: returns BX = AX * 0x1C (28 = sizeof UnitRecord). Used as a shared helper by other unit-accessor functions that handle the array-base addition themselves. |
| 0x006D24 | `unknown` | 60 | 60 | 100 | DONE | UNKNOWN |
| 0x006E94 | `unknown` | 51 | 51 | 100 | DONE | UNKNOWN |
| 0x006F5A | `unknown` | 45 | 45 | 100 | DONE | UNKNOWN |
| 0x006FC4 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x006FD8 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x007002 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x00701C | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x00704C | `unknown` | 80 | 80 | 100 | DONE | UNKNOWN |
| 0x007120 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x007178 | `unknown` | 71 | 71 | 100 | DONE | UNKNOWN |
| 0x00723E | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x00726E | `unknown` | 49 | 49 | 100 | DONE | UNKNOWN |
| 0x0072E2 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x00730A | `unknown` | 35 | 35 | 100 | DONE | UNKNOWN |
| 0x007356 | `unknown` | 30 | 30 | 100 | DONE | UNKNOWN |
| 0x00738E | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x0073A8 | `unknown` | 47 | 47 | 100 | DONE | UNKNOWN |
| 0x00757E | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x0075A0 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x0075D4 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x0075E4 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x0075FE | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x007610 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x007630 | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x00765C | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x00768C | `unknown` | 67 | 67 | 100 | DONE | UNKNOWN |
| 0x00772E | `unknown` | 57 | 57 | 100 | DONE | UNKNOWN |
| 0x0078F4 | `unknown` | 32 | 32 | 100 | DONE | UNKNOWN |
| 0x007936 | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x007966 | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x0079A0 | `unknown` | 46 | 46 | 100 | DONE | UNKNOWN |
| 0x007A20 | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x007A80 | `unknown` | 54 | 54 | 100 | DONE | UNKNOWN |
| 0x007B10 | `unknown` | 35 | 35 | 100 | DONE | UNKNOWN |
| 0x007B64 | `unknown` | 42 | 42 | 100 | DONE | UNKNOWN |
| 0x007BCE | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x007BE8 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x007C2A | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x007D3E | `unknown` | 157 | 157 | 100 | DONE | UNKNOWN |
| 0x007F34 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x007F62 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x007F96 | `unknown` | 40 | 40 | 100 | DONE | UNKNOWN |
| 0x008000 | `unknown` | 46 | 46 | 100 | DONE | UNKNOWN |
| 0x008074 | `unknown` | 30 | 30 | 100 | DONE | UNKNOWN |
| 0x0080C8 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x008110 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x008158 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x00817E | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x0081A4 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x0081C6 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x0081F2 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x00822A | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x008262 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x0082A0 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x0082B2 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x0082DC | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x008352 | `unknown` | 35 | 35 | 100 | DONE | UNKNOWN |
| 0x0083F2 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x0084C8 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x0084DC | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x0084F2 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x008508 | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x008524 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x0085B2 | `test_bit_at_8a` | 15 | 15 | 100 | DONE | Tests a bit in the bit-array at *(0x8542)+0x8A. Returns AX != 0 |
| 0x0085D6 | `set_or_clear_bit_at_8a` | 23 | 23 | 100 | DONE | Sets or clears a bit in the bit-array at *(0x8542)+0x8A. The |
| 0x00860E | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00863E | `wrapper_with_global_8DC6` | 7 | 7 | 100 | DONE | Small near-call wrapper that pushes [bp+6] (the caller's argument) and the 16-bit global at DGROUP:0x8DC6 (likely a global state index — current player? current colony?), then near-calls 0x860E. Effectively a 'forward this call together with the current-context global' helper. |
| 0x00864E | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x008686 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x0086C0 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x0086E4 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x008734 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x008770 | `unknown` | 46 | 46 | 100 | DONE | UNKNOWN |
| 0x0087F4 | `power_record_read_dword` | 7 | 7 | 100 | DONE | Reads a 32-bit DWORD from a player/power record. Index is multiplied by 0x13C (316 bytes = sizeof PowerRecord, confirmed in FUNCTIONS_INVENTORY.md), then offsets -0x77CE and -0x77CC (which together form the table base) are added to get the field address. Returns DX:AX = the DWORD. |
| 0x008806 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x008846 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x008862 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x00887C | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x008892 | `find_pair_in_table_C8_DE` | 20 | 20 | 100 | DONE | Searches two parallel 20-byte tables at DGROUP:0xC8 and DGROUP:0xDE for an entry matching ([bp+6]-2, [bp+8]-2). Iterates 0..0x13 (20 entries), checking byte at [bx+0xC8] == [bp+6]-2 AND byte at [bx+0xDE] == [bp+8]-2. Returns the matching index (signed), or -1 if no match. The -2 offsets suggest the input is in 1-based screen-coordinate space and the tables are in 0-based internal space (or the tables index a smaller region than the screen). |
| 0x0088D0 | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x008918 | `blit_at_origin_if_pair_visible` | 26 | 26 | 100 | DONE | Conditional blit: looks up (key1, key2) in the 20-entry C8/DE pair table via `find_pair_in_table_C8_DE` (0x8892). If the pair is registered, translates (key1, key2) by the current-context origin (struct.byte[+0] - 2, struct.byte[+1] - 2) and dispatches to the far drawing routine at 0x37F:0x15E with (adj_key1, adj_key2, 0x10, arg3). The find_pair return value is used purely as a "is this pair visible?" predicate — the match index itself is discarded. |
| 0x008956 | `lookup_byte_from_pair` | 18 | 18 | 100 | DONE | Given (key1, key2), looks up the matching entry via `find_pair_in_table_C8_DE` (0x8892). On a successful match, indexes the 'current-context' struct *(0x8542) at offset +0x70 + match_index to retrieve a byte value. Returns the byte, or -1 if no match was found. |
| 0x008982 | `update_and_render_tile_at` | 199 | 199 | 100 | DONE | UNKNOWN |
| 0x008B96 | `unit_field_test_at_3146` | 10 | 10 | 100 | DONE | Tests a per-unit byte field. Computes BX = (unit_index * 0x1C) + 0x3146 = the TYPE field (+0x02) of UnitRecord (base 0x3144), reads the byte there, then compares against the byte at DGROUP:0x30E. Returns 1 if (unit_table_3146[idx] >= byte_at_30E), else falls through (caller-provided default). |
| 0x008BB2 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x008BC6 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x008BD4 | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x008C1E | `find_indexed_match` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x008C70 | `init_and_scan_units_in_area` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x008D00 | `step_100_or_level_scaled` | 13 | 13 | 100 | DONE | Returns 100 by default, or `(struct.byte[+0x95] + 1) * 100` if that byte is non-zero. The struct is *(0x8542) (current-context struct). Pattern is a "step / increment value" scaled by a level/stage counter at +0x95: stage 0 → 100, stage 1 → 200, stage 2 → 300, etc. Likely used as a per-turn step delta in some accumulating calculation (score, treasury, attribute drift). |
| 0x008D26 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x008D9C | `lookup_table_2F4_signed` | 11 | 11 | 100 | DONE | Bounded array lookup: returns -1 if index >= 0x13 (19), else returns sign-extended byte at DGROUP:0x2F4 + index. The fixed limit 0x13 + sign-extension suggests a small ranged lookup table (perhaps terrain-attribute or unit-class table). |
| 0x008DBC | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x008E02 | `set_commodity_band_at_index` | 25 | 25 | 100 | DONE | Updates three parallel WORD arrays in DGROUP for a given index. |
| 0x008E46 | `dispatch_via_8e02_with_band` | 23 | 23 | 100 | DONE | Dispatcher that wraps `set_commodity_band_at_index` (0x8E02). For an index `i` in the 0..14 range, reads the global per-index WORD at DGROUP:0x8DC8[i] (call it 'global_amount'), applies a special-case adjustment for index 14 (subtracts the word at DGROUP:0x8E66 — apparently the "Ore overflow" used to dampen Tools demand), then calls set_commodity_band_at_index with (idx, midpoint=[bp+8], primary=adjusted_global, delta=struct[+0x9A + idx*2]). |
| 0x008E84 | `unknown` | 47 | 47 | 100 | DONE | UNKNOWN |
| 0x008F02 | `check_total_exceeds_threshold` | 14 | 14 | 100 | DONE | Tests whether the per-index running total (struct.word[+0x9A + idx*2] in *(0x8542)  PLUS the global_amount at DGROUP:0x8DC8[idx*2]) exceeds the band-base value at DGROUP:0x8E0A[idx*2]. If exceeded, returns AX=1; otherwise falls through past the LEAVE/RETF into the next function (0x8F2A) — a fast-path predicate before the slower main case (just like func_00BC10_is_arg2_negative). |
| 0x008F2A | `unpack_nibble_at_60` | 21 | 21 | 100 | DONE | Reads a packed-nibble entry from the byte-array at *(0x8542)+0x60. The array stores 2 nibbles per byte: even-index `i` lives in the low nibble of byte[i/2], odd-index `i` lives in the high nibble. Bound-checked against struct.byte[+0x1F] (the count). On out-of-bounds the function does NOT set AX and falls through past its RETF into the next function — same fast-path / fall-through pattern as is_arg2_negative. |
| 0x008F6C | `pack_nibble_at_60` | 26 | 26 | 100 | DONE | Setter companion to `unpack_nibble_at_60` (0x8F2A). Writes a 4-bit value into the packed-nibble array at *(0x8542)+0x60. Even-index `i` is stored in the low nibble of byte[i/2]; odd-index in the high nibble. The value is clamped to 0..15 first. Bound-checked against struct.byte[+0x1F] — out-of-bounds is a silent no-op. |
| 0x008FB4 | `unknown` | 53 | 53 | 100 | DONE | UNKNOWN |
| 0x00903E | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x0090C8 | `current_unit_field_at_20` | 13 | 13 | 100 | DONE | Reads byte field at offset +0x20 within the current-unit-or-context struct pointed to by [DGROUP:0x8542]. The byte at +0x1F is the bound-check count: if [bp+6] < count, returns the byte at *(0x8542) + 0x20 + index; else returns the count. (Indexed access into a per-unit subarray.) |
| 0x009102 | `current_unit_field_at_40` | 13 | 13 | 100 | DONE | Sister of current_unit_field_at_20 — reads from offset +0x40 instead of +0x20 within the same struct at *(0x8542). Same bound-check (count at +0x1F). |
| 0x00913C | `set_field_at_40_or_unit_byte` | 31 | 31 | 100 | DONE | Dual-mode setter for the +0x40 byte-array. If `index < struct.count`, |
| 0x009184 | `nibble_to_4_tier_quantity` | 30 | 30 | 100 | DONE | Reads a packed-nibble entry via `unpack_nibble_at_60` (0x8F2A) at |
| 0x0091CC | `unknown` | 63 | 63 | 100 | DONE | UNKNOWN |
| 0x00929A | `classify_pair_bounds` | 27 | 27 | 100 | DONE | Classifies a (primary_index, secondary_index) pair against two |
| 0x0092E0 | `set_or_clear_bit_at_84` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x009318 | `colony_assign_or_change_colonist_job` | 292 | 292 | 100 | DONE | UNKNOWN |
| 0x009626 | `count_field_at_20_matching` | 21 | 21 | 100 | DONE | Counts entries in the *(0x8542)+0x20 byte-array that equal the |
| 0x00965C | `count_field_at_40_matching` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x009692 | `count_field_40_matches_field_20` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x0096DA | `find_nth_match_in_field_at_20` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x009726 | `register_origin_to_overlay_9EF` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x00975A | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x009786 | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x009794 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x0097D6 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x009818 | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x009876 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x0098B4 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x0098F6 | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x00994C | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x009974 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x0099AE | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x0099EE | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x009A32 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x009A6A | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x009AAA | `unknown` | 75 | 75 | 100 | DONE | UNKNOWN |
| 0x009B9C | `compute_terrain_yield` | 400 | 400 | 100 | DONE | UNKNOWN |
| 0x009FFC | `unknown` | 206 | 203 | 99 | IN-PROGRESS | UNKNOWN |
| 0x00A222 | `compute_colony_center_yields` | 153 | 153 | 100 | DONE | UNKNOWN |
| 0x00A3E1 | `colony_turn_update` | 266 | 266 | 100 | DONE | UNKNOWN |
| 0x00A6A2 | `unknown` | 58 | 58 | 100 | DONE | UNKNOWN |
| 0x00A93E | `unknown` | 32 | 32 | 100 | DONE | UNKNOWN |
| 0x00A994 | `unknown` | 103 | 103 | 100 | DONE | UNKNOWN |
| 0x00AB2E | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x00AB78 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x00AB95 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x00B150 | `auto_assign_unassigned_colonists` | 61 | 61 | 100 | DONE | UNKNOWN |
| 0x00B1EC | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x00B23E | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x00B2A2 | `unit_cargo_slot_kind_or_neg1` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x00B2F0 | `unit_table_3154_byte` | 10 | 10 | 100 | DONE | Reads a byte from a per-unit table at DGROUP:0x3154 + (index * 0x1C). The caller supplies a far-pointer base in [bp+8] (probably a player or context override). Returns AX = byte value (zero-extended). |
| 0x00B304 | `unit_cargo_slot_set_quantity` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x00B31A | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x00B368 | `unit_load_commodity_into_slots` | 46 | 46 | 100 | DONE | UNKNOWN |
| 0x00B42C | `unknown` | 58 | 58 | 100 | DONE | UNKNOWN |
| 0x00B4B8 | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x00B550 | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x00B5A8 | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x00B5FA | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x00B65A | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x00B704 | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x00B880 | `colony_transfer_commodity_to_unit` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x00B8D0 | `colony_receive_commodity_from_unit` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x00B900 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x00BB6A | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x00BB98 | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x00BC10 | `is_arg2_negative` | 29 | 29 | 100 | DONE | Read bit `arg2` from the per-power attribute bitfield in |
| 0x00BC4E | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x00BC80 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x00BCAA | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x00BCEA | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x00BD28 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x00BD4A | `unknown` | 73 | 73 | 100 | DONE | UNKNOWN |
| 0x00BEDE | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x00BF3C | `unknown` | 69 | 69 | 100 | DONE | UNKNOWN |
| 0x00BFF2 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x00C00A | `unknown` | 42 | 42 | 100 | DONE | UNKNOWN |
| 0x00C07A | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x00C09A | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x00C0AE | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x00C0D0 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x00C17A | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x00C1F8 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x00C276 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x00C30A | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x00C322 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x00C362 | `unknown` | 69 | 69 | 100 | DONE | UNKNOWN |
| 0x00C410 | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x00C45A | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x00C498 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x00C4A4 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x00C51A | `unknown` | 75 | 75 | 100 | DONE | UNKNOWN |
| 0x00C646 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x00C7DF | `unknown` | 5 | 5 | 100 | DONE | UNKNOWN |
| 0x00C899 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x00C8AB | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x00C8FC | `unknown` | 40 | 40 | 100 | DONE | UNKNOWN |
| 0x00CA0C | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x00CB59 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00CC8F | `unknown` | 38 | 38 | 100 | DONE | UNKNOWN |
| 0x00CD0B | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x00CECF | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x00CEE8 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x00CF19 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x00CF3E | `unknown` | 50 | 50 | 100 | DONE | UNKNOWN |
| 0x00D0B6 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x00D106 | `unknown` | 51 | 51 | 100 | DONE | UNKNOWN |
| 0x00D1CA | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x00D1E4 | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x00D272 | `kbhit` | 8 | 8 | 100 | DONE | C `kbhit()`: BIOS keyboard 'is a key pending?'. Issues INT 16h, AH=1 (Check Key). If the zero flag is clear (a key is buffered) returns AX=key (scan-code in AH, ASCII in AL). If no key is pending returns AX=0. Standard MS C runtime kbhit(). |
| 0x00D286 | `getch` | 9 | 9 | 100 | DONE | C `getch()` / `_getch()`: BIOS keyboard blocking read. Issues INT 16h, AH=0 (Get Key). The BIOS waits for a key, returns scan-code in AH and ASCII in AL. If AL is 0 it's an extended key (function key, arrow, etc.) — the runtime convention here returns the full AX (preserves AH); if AL!=0 it returns AL with AH zeroed (return just the ASCII character). |
| 0x00D2AC | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x00D3BE | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x00D3EC | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x00D41E | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x00D642 | `unknown` | 56 | 56 | 100 | DONE | UNKNOWN |
| 0x00D6C4 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x00D700 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x00D72E | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x00D77C | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x00D7F4 | `unknown` | 40 | 40 | 100 | DONE | UNKNOWN |
| 0x00D85E | `unknown` | 49 | 49 | 100 | DONE | UNKNOWN |
| 0x00D8E4 | `unknown` | 50 | 50 | 100 | DONE | UNKNOWN |
| 0x00D972 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00D9E0 | `unknown` | 41 | 41 | 100 | DONE | UNKNOWN |
| 0x00DB3A | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x00DB80 | `unknown` | 82 | 82 | 100 | DONE | UNKNOWN |
| 0x00DCD4 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x00DCF6 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x00DDEA | `unknown` | 54 | 54 | 100 | DONE | UNKNOWN |
| 0x00DEA6 | `unknown` | 57 | 57 | 100 | DONE | UNKNOWN |
| 0x00DF9A | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x00DFB6 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x00DFCC | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x00E036 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x00E0A2 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00E146 | `unknown` | 40 | 40 | 100 | DONE | UNKNOWN |
| 0x00E1D2 | `unknown` | 90 | 90 | 100 | DONE | UNKNOWN |
| 0x00E2B0 | `unknown` | 64 | 64 | 100 | DONE | UNKNOWN |
| 0x00E350 | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x00E454 | `normalize_far_pointer` | 10 | 10 | 100 | DONE | Normalises a far pointer (segment, offset) so the offset is in 0..15 (i.e. shifts the high nibble of offset into the segment). Equivalent to MS C `_makeptr` / `_pmakefp` normalisation. Returns DX:AX where DX = segment + (offset >> 4) and AX = offset & 0xF. |
| 0x00E46C | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x00E4C6 | `read_far_dword_via_267A` | 4 | 4 | 100 | DONE | Reads the first 4 bytes (DWORD) at the far pointer stored in DGROUP:[0x267A]. The far pointer itself is set up at runtime to point at a major game-state structure. Called 17 times — a hot accessor for whatever lives at *(0x267A). 4 instructions. |
| 0x00E508 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x00E51C | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x00E68A | `set_global_269E_byte_pair` | 6 | 6 | 100 | DONE | Stores AL into DGROUP:0x269E and DL into DGROUP:0x269F (a 2-byte coordinate pair), then returns AX = BX. Looks like `set_cursor(x, y)` or `set_target(x, y)` — sets a 2-byte (x,y) state global from CX/DX, returns BX as a token. |
| 0x00E6A6 | `unknown` | 32 | 32 | 100 | DONE | UNKNOWN |
| 0x00E6EE | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x00E702 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x00E76A | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x00E867 | `unknown` | 4 | 3 | 75 | IN-PROGRESS | UNKNOWN |
| 0x00E964 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x00EADE | `unknown` | 4 | 3 | 75 | IN-PROGRESS | UNKNOWN |
| 0x00EC32 | `unknown` | 43 | 43 | 100 | DONE | UNKNOWN |
| 0x00EC96 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x00ED93 | `unknown` | 4 | 3 | 75 | IN-PROGRESS | UNKNOWN |
| 0x00EEA4 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x00F01E | `unknown` | 4 | 3 | 75 | IN-PROGRESS | UNKNOWN |
| 0x00F184 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x00F281 | `unknown` | 4 | 3 | 75 | IN-PROGRESS | UNKNOWN |
| 0x00F38A | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x00F450 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x00F510 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x00F52C | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x00F5E6 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x00F702 | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x00F720 | `dos_version_check_stub` | 8 | 8 | 100 | DONE | Tiny pre-stack-relocation stub. Calls DOS Get-Version (INT 21h, AH=30h); if the major version is below 2 it falls through to a 'PUSH ES; PUSH AX; RETF' that returns to PSP:0 (DOS terminates the program). On DOS 2.0+ it jumps to 0xF72D (cstart) to set up the C runtime. Reached as the LJMP-target of the entry-point stub at 0x13BED, after system_init returns. |
| 0x00F72D | `cstart` | 73 | 73 | 100 | DONE | C-runtime startup. Relocates the program stack to its dedicated SS segment, on failure prints 'stack overflow' and exits. Then zeroes the BSS, calls the precompiled-init chain (lcall 0xD1D:0x1420 / 0x128E / 0x248 — atexit init, FPU init, _setargv equivalents). Pushes argc/argv/envp from globals at [0x27CF],[0x27D1],[0x27D3] and far-calls _main via the overlay thunk at 0x181F:0 (file 0x1A5F0). On return passes _main's exit code to the exit chain at 0xF8DD. |
| 0x00F8DD | `exit` | 4 | 4 | 100 | DONE | C `exit(status)` entry point. The runtime convention here is two cooperating thunks that share an implementation at 0xF8FE: this one zeroes CX (CL flag = 'normal exit, run atexit handlers') and tail-jumps to 0xF8FE. Called by cstart immediately after _main returns (with the exit code already pushed as [bp+6]). |
| 0x00F8E4 | `exit_abort` | 4 | 4 | 100 | DONE | C `_exit(status)` / `abort()`-style entry. Sets CX=1 (the merged implementation at 0xF8FE skips the atexit chain and stdio flush when CX is non-zero, going straight to INT 21h AH=4Ch with the supplied exit code). |
| 0x00F8EC | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x00F8F6 | `unknown` | 44 | 44 | 100 | DONE | UNKNOWN |
| 0x00F9C4 | `fclose_or_remove` | 72 | 72 | 100 | DONE | C runtime fclose() variant. Validates the FILE struct's flag byte at offset +6 (must have bit 0x83 set, must NOT have bit 0x40 set). Calls a library helper (LCALL 0xD1D:0x1896) and the buffer flush (CALL 0x10CA0), then translates the FILE* to its parallel-table entry at DGROUP:0x29B2[fd], reads a stored handle from there and calls the close-handle library (LCALL 0xD1D:0x1E7A). For temp files (entry 0x27E8 sentinel), calls an additional path that includes the unlink helper. Branches into the unlink wrapper at 0x01041A for the temp-file removal case. |
| 0x00FA7E | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x00FAAA | `printf_to_str` | 10 | 10 | 100 | DONE | C `printf` / `vsprintf`-style entry: pushes 0 (NULL fill arg), the format string ([bp+8]), and a destination buffer pointer ([bp+6]), then far-calls 0x0D1D:0x04AE — the overlay-resident format-string engine. Returns whatever the engine returns. |
| 0x00FAC0 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x00FAF8 | `unknown` | 63 | 63 | 100 | DONE | UNKNOWN |
| 0x00FBDC | `unknown` | 78 | 78 | 100 | DONE | UNKNOWN |
| 0x00FCE2 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00FD20 | `putchar` | 4 | 4 | 100 | DONE | C `putchar(int c)`. Loads BX with the address of the stdout FILE struct (DGROUP:0x2916) and tail-jumps to the shared putc fast path at 0xFD2E. |
| 0x00FD28 | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x00FD4E | `getchar` | 4 | 4 | 100 | DONE | C `getchar(void)`. Loads BX with the address of the stdin FILE struct (DGROUP:0x290E) and tail-jumps to the shared getc fast path at 0xFD5C. |
| 0x00FD56 | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x00FD74 | `strcat_near` | 30 | 30 | 100 | DONE | C `strcat(dest, src)` — both arguments are near (DGROUP-relative) pointers. Locates the end of dest with REPNE SCASB (scan-byte-while-not-zero), locates the source length similarly, then REP MOVSW + MOVSB-tail to append source onto dest. Returns AX = original dest pointer. |
| 0x00FDB4 | `strcpy_near` | 26 | 26 | 100 | DONE | C `strcpy(dest, src)` — both arguments are near (DGROUP-relative) pointers. Locates the source length with REPNE SCASB, then REP MOVSW + MOVSB-tail to copy. Returns AX = original dest pointer. |
| 0x00FDE6 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x00FE12 | `strlen_near` | 15 | 15 | 100 | DONE | C `strlen(s)` — single near-pointer argument. Locates the NUL terminator with REPNE SCASB, returns the byte count not including the terminator. AX = length. |
| 0x00FE2E | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x00FE64 | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x00FE8C | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x00FECA | `itoa_radix_dispatch` | 14 | 14 | 100 | DONE | Front-half of `itoa(value, buf, radix)` / `ltoa`-equivalent. Loads the radix from [bp+0xA], the value's low word from [bp+6], computes DX = high word (via CDQ if radix is 10, else 0 for unsigned), loads buffer pointer DI = [bp+8], then jumps to the shared body at 0x11B02 which performs the digit conversion. Sets BL = 1 to flag 'this is the radix-10 / signed path'. |
| 0x00FEE6 | `ltoa_dispatch` | 6 | 6 | 100 | DONE | Sister of `itoa_radix_dispatch` (0xFECA): sets BL=1 to flag 'long-decimal path' to the shared digit-emit body at 0x11AF6 (a different shared body than itoa's 0x11B02). Used for `ltoa(value, buf)` (long-int to string). |
| 0x00FEF0 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x00FEFC | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x00FF12 | `unknown` | 38 | 38 | 100 | DONE | UNKNOWN |
| 0x00FF72 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x00FF9A | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x01000E | `unknown` | 47 | 47 | 100 | DONE | UNKNOWN |
| 0x01008E | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x0100A8 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x0100EC | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x010118 | `unknown` | 37 | 37 | 100 | DONE | UNKNOWN |
| 0x010172 | `unknown` | 57 | 57 | 100 | DONE | UNKNOWN |
| 0x010226 | `strchr_near` | 24 | 24 | 100 | DONE | C `strchr(s, c)` — finds the FIRST occurrence of byte c in string s. First REPNE SCASB finds the string length (so we know the bound for the second scan); the second REPNE SCASB scans forward looking for c. After the find, DEC DI to point at the match, then CMP to distinguish 'found' from 'CX-exhausted'. Returns DI = pointer to first match, or 0 if no match. |
| 0x010250 | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x010292 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x0102EA | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x010316 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x010334 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x010352 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x01037E | `memset_near` | 23 | 23 | 100 | DONE | C `memset(dest, c, n)` — fills n bytes at near-pointer dest with byte c. Uses REP STOSW with the fill byte broadcast to AH:AL, plus byte-pre/post handling for odd alignment and odd length. |
| 0x0103AC | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x0103C2 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x0103FC | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x01041A | `unlink` | 7 | 7 | 100 | DONE | C `unlink(path)` / `remove(path)`. Loads DX with the path pointer from [bp+6] and issues DOS Delete File (INT 21h, AH=41h). On success CF=0, AX=0; on failure CF=1, AX=DOS error code. Tail-jumps to the shared C-runtime errno-translation epilogue at 0x10AD0 which converts the DOS error to a C errno value and returns AX accordingly. |
| 0x010428 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x010433 | `find_file` | 41 | 41 | 100 | DONE | C `_dos_findfirst(path, attr, &finfo)` / `_dos_findnext(&finfo)`. Sets up the disk-transfer-area (DTA) by saving the caller's DTA via INT 21h AH=2Fh (Get DTA), then INT 21h AH=1Ah (Set DTA) to install the caller-supplied buffer. The user's actual call (Find First, AH=0x4E, or Find Next, AH=0x4F — chosen by AH supplied in the call frame) follows. Restores the original DTA before returning. The 0x4E/0x4F selection is encoded by the AL=0x4E literal at 0x10437 — this branch is the Find First entry; the Find Next companion shares the implementation but takes a different entry point in the same module. |
| 0x010466 | `_read` | 4 | 4 | 100 | DONE | C `read(fd, buf, count)` low-level read. Loads AH=3Fh (DOS Read From File Handle) and tail-jumps to the shared read/write trampoline at 0x10472 which loads BX (handle), CX (count), and DS:DX (buffer) from the call frame, issues INT 21h, and stores the bytes-read result. |
| 0x01046D | `_write` | 3 | 3 | 100 | DONE | C `write(fd, buf, count)` low-level write. Sister to `_read` at 0x010466: same call-frame conventions, but loads AH=40h (DOS Write to File Handle) instead. Note this stub does NOT end in a JMP — it falls through into the shared read/write trampoline at 0x010472, which is the very next instruction after MOV AH,0x40. |
| 0x010496 | `unknown` | 73 | 73 | 100 | DONE | 32-bit signed long division — Microsoft C 6.0 runtime helper |
| 0x010530 | `unknown` | 23 | 23 | 100 | DONE | 32-bit signed/unsigned long multiplication — Microsoft C 6.0 |
| 0x010562 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x010582 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x0105E0 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x01060E | `unknown` | 36 | 36 | 100 | DONE | UNKNOWN |
| 0x010654 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x010690 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x0106BA | `strrchr_far` | 23 | 23 | 100 | DONE | C `strrchr(s, c)` for far-pointer s — finds the LAST occurrence of byte c in string s. After finding string length with REPNE SCASB, sets STD (direction-decrement), DEC DI, scans BACKWARDS with REPNE SCASB to find the last match, then CLD restores forward-direction. Returns DX:AX = far-pointer to last match, or 0:0 if not found. |
| 0x0106E8 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x01070C | `strlen_far` | 13 | 13 | 100 | DONE | C `strlen(s)` for far-pointer s. Loads ES:DI from [bp+6..9], REPNE SCASB to NUL, returns AX = length. Far-pointer variant of strlen_near at 0xFE12. |
| 0x010724 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x01074E | `strcpy_far` | 29 | 29 | 100 | DONE | Far-pointer variant of strcpy: dest is a far pointer at [bp+6..9] (LES DI), src is a far pointer at [bp+0xA..0xD] (LDS SI). Otherwise identical to strcpy_near (REPNE SCASB to find src length, then REP MOVSW + MOVSB-tail to copy). Returns DX:AX = original dest far-pointer. |
| 0x010784 | `strcat_far` | 34 | 34 | 100 | DONE | Far-pointer variant of strcat: dest is a far pointer at [bp+6..9] (LES DI), additional segment at [bp+8] (?), src is a far pointer at [bp+0xA..0xD]. Implements `_fstrcat`. Two REPNE SCASB phases (dest length, src length) followed by REP MOVSW + MOVSB-tail. |
| 0x0107CA | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x010812 | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x0109F0 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x010A6E | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x010A99 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x010B26 | `unknown` | 65 | 65 | 100 | DONE | UNKNOWN |
| 0x010BBC | `unknown` | 65 | 65 | 100 | DONE | UNKNOWN |
| 0x010CA0 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x010CCC | `unknown` | 72 | 72 | 100 | DONE | UNKNOWN |
| 0x010DB4 | `unknown` | 47 | 47 | 100 | DONE | UNKNOWN |
| 0x010E27 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x010E66 | `unknown` | 50 | 50 | 100 | DONE | UNKNOWN |
| 0x010EE2 | `unknown` | 33 | 33 | 100 | DONE | UNKNOWN |
| 0x010F3E | `unknown` | 186 | 184 | 99 | IN-PROGRESS | UNKNOWN |
| 0x01144A | `_close` | 13 | 13 | 100 | DONE | C `close(fd)` for the low-level file-descriptor table. Validates the fd against the open-files limit at DGROUP:0x27B9 (returns errno EBADF=9 if out of range); otherwise issues INT 21h AH=3Eh (Close Handle) and clears the corresponding entry in the file-descriptor flag table at DGROUP:0x27BB+fd. Tail-jumps to the shared errno-translation epilogue at 0x10AD0. |
| 0x01146A | `unknown` | 46 | 46 | 100 | DONE | UNKNOWN |
| 0x0114E4 | `read` | 52 | 52 | 100 | DONE | UNKNOWN |
| 0x0115CE | `unknown` | 82 | 82 | 100 | DONE | UNKNOWN |
| 0x01180C | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x011860 | `unknown` | 71 | 71 | 100 | DONE | UNKNOWN |
| 0x0119D6 | `unknown` | 55 | 55 | 100 | DONE | UNKNOWN |
| 0x011B56 | `unknown` | 127 | 127 | 100 | DONE | UNKNOWN |
| 0x011CD2 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x011D16 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x011D30 | `open` | 42 | 42 | 100 | DONE | UNKNOWN |
| 0x011F6E | `load_game_state` | 151 | 151 | 100 | DONE | Large savegame / state-loader function. Allocates a 0xAE-byte working buffer (LCALL 0xD1D:0x3D0), reads a path/handle from [bp+6], iterates over a list, calls a parser at 0xD1D:0x2C8E (~14 bytes of args) to fetch records, calls coreleft_total at 0x124D6 to verify free memory, and calls _close at 0x1144A on completion. The 0xAE-byte buffer suggests a single-record stride matching the 174-byte ColonyRecord or a similar major struct. Sets DGROUP:0x27AC = 8 on out-of-memory failure (errno-like signal). |
| 0x012102 | `unknown` | 106 | 106 | 100 | DONE | UNKNOWN |
| 0x012214 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x012235 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x01225E | `unknown` | 133 | 133 | 100 | DONE | UNKNOWN |
| 0x0124D6 | `coreleft_total` | 43 | 43 | 100 | DONE | C `coreleft()` (total free memory). Issues INT 21h AH=48h (Allocate Memory) with BX=0xFFFF to deliberately fail and learn the largest available block, then walks the DOS Memory Control Block (MCB) chain starting from the segment in DGROUP:0x27B2 (saved program-DS from cstart) to sum the total free memory across ALL MCBs (not just the largest single block). Returns the total in AX:DX (32-bit, AX=high, DX=low) suitable for `long coreleft(void)`. |
| 0x01285A | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x01287A | `dos_exec_load_overlay_4B3` | 59 | 59 | 100 | DONE | UNKNOWN |
| 0x012928 | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x012959 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x0129B1 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x0129FC | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x012A36 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x012A66 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x012ADA | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x012B48 | `unknown` | 45 | 45 | 100 | DONE | UNKNOWN |
| 0x012BC2 | `unknown` | 53 | 53 | 100 | DONE | UNKNOWN |
| 0x012C8C | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x012CC8 | `unknown` | 41 | 41 | 100 | DONE | UNKNOWN |
| 0x012D4A | `unknown` | 37 | 37 | 100 | DONE | UNKNOWN |
| 0x012DAA | `unknown` | 43 | 43 | 100 | DONE | UNKNOWN |
| 0x012E56 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x012EE0 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x0130A4 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x01311B | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x0132B0 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x01340E | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x01343A | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x01347C | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x013B4E | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x013B9F | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x013BED | `entry_point` | 2 | 2 | 100 | DONE | MZ entry-point stub. The very first code DOS executes after loading VICEROY.EXE. Its only job is to (a) far-call system_init at 0x13BF7 to set up DOS/EMS/XMS/heap state and (b) tail-far-jump to dos_version_check_stub at 0xF720 which then falls into the C-runtime cstart. Two instructions, 10 bytes total. The MZ header points here via cs:ip = 110D:071D (segment-relative; file offset = header(0x2400) + 0x110D*16 + 0x071D = 0x13BED). |
| 0x013BF7 | `system_init` | 437 | 437 | 100 | DONE | Boot-time DOS/EMS/XMS/heap initialization. Saves the initial DS/ES/SS, runs DOS Get-Version (INT 21h, AH=30h), probes for an EMS driver (INT 67h, AH=42h) and allocates a 1-page handle if present, probes for XMS (call 0x18153) and allocates an XMS block if present, queries the conventional-memory ceiling from the PSP, computes the runtime memory layout (program break, near-heap, far-heap, EMS window, XMS handle), shrinks the program memory block to the computed size via INT 21h AH=4Ah, allocates the near-heap base via INT 21h AH=48h, hooks INT 21h handlers for environment-variable lookup (function 35h/25h sub-21h), and stores all of this into globals at DS:[0x3995..0x39FF] for later use by file I/O, the asset loader and the renderer. Returns far via PUSH ES; PUSH DS; ... ; POP DS; POP ES; RETF. |
| 0x014261 | `rtlink_loader_B` | 8 | 8 | 100 | DONE | Type-B entry point for the RTLink Plus overlay runtime. Called from the second instruction of every type-B thunk in the overlay-thunk table at 0x1A5F0. Sets cs:[0x39F1] = 0x52 to mark this call as 'no relocation patch needed' (the runtime will load the overlay segment but the LJMP's segment word does not need rewriting), then jumps to the shared loader body at 0x14293. Called approximately 109 times per game session (most-called load-image function after the type-A entry). |
| 0x01427B | `rtlink_loader_A` | 7 | 7 | 100 | DONE | Type-A entry point for the RTLink Plus overlay runtime. Called from the second instruction of every type-A thunk in the overlay-thunk table at 0x1A5F0. Sets cs:[0x39F1] = 0 (the runtime DOES need to patch the LJMP's segment word with the actual runtime address of the loaded overlay segment), then falls through to the shared loader body at 0x14293. Called approximately 127 times per game session — the single most-called load-image function. |
| 0x014293 | `rtlink_loader_shared` | 307 | 307 | 100 | DONE | Shared body of the RTLink overlay loader, reached from rtlink_loader_A (fall-through) and rtlink_loader_B (JMP). Implements the demand-paging mechanism for overlay segments: (1) sets the 'loader busy' flag at cs:[0x39E1] = 0xFF to prevent re-entry, (2) extracts the LCALL's saved CS:IP from the stack and saves it to globals cs:[0x397D]/cs:[0x397F], (3) saves SP, (4) re-pushes saved CS:IP for the eventual far-return, (5) saves all general-purpose registers (AX, BX, DX, SI, DS, ES, CX, DI, BP), (6) calls the segment-lookup helper at 0x164A2, (7) on success, branches between three patch paths: 'no patch needed', 'patch reloc' (rewrites the LJMP's segment word at [si-4]), or 'fault load from disk'. The function ends with IRET-like restoration of state and a final far-return that lands inside the overlay segment. |
| 0x015094 | `unknown` | 28 | 27 | 96 | IN-PROGRESS | UNKNOWN |
| 0x015131 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x015145 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x015166 | `unknown` | 27 | 26 | 96 | IN-PROGRESS | UNKNOWN |
| 0x0151B1 | `unknown` | 39 | 39 | 100 | DONE | UNKNOWN |
| 0x016073 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x0164A2 | `rtlink_segment_lookup` | 24 | 24 | 100 | DONE | Dispatcher that, given the saved CS:IP of the LCALL site, walks 6 storage-class helpers to determine where the requested overlay segment lives (in memory, EMS, XMS, or on disk) and patches the LJMP's segment word accordingly. Reads the saved IP from cs:[0x397D], subtracts 5 to back up to the LCALL's address (where the immediately-following LJMP's seg:off operand lives at IP+1..IP+4 of the LJMP), saves at cs:[0x3981]. Loads ES:DI from caller-supplied [bp+0x18]; if ES is already 0x110D the lookup is a self-call to the runtime and returns immediately. Otherwise calls the chain of 6 storage-class helpers (0x164FE, 0x164E8, 0x16564, 0x16516, 0x16837, 0x167F2). Each helper returns CF=1 on a positive match (segment found in that storage class) and CF=0 on miss; the dispatcher returns the first match's status flags up the chain. |
| 0x019E64 | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x01A283 | `unknown` | 45 | 45 | 100 | DONE | UNKNOWN |
| 0x01A425 | `dos_version_far` | 16 | 16 | 100 | DONE | Far-callable DOS Get-Version stub. Issues INT 21h, AX=3000h. If the major version (AL) is below 3 the stub sets the carry flag and unwinds an unusually large set of pushed registers (BP, ES, DI, DX, CX, BX, AX) before far-returning — it is being called from a context that pushed a 7-register save frame and wants the carry flag to signal an old-DOS error. |
| 0x01A5F0 | `rtlink_overlay_thunk_table` | 6005 | 5378 | 90 | IN-PROGRESS | RTLink Plus overlay-thunk table — 1,020 thunks bridging load-image code to overlay-resident functions. Each thunk is either a variable-size (10/12/14/16 bytes) `LCALL 110D:0DAB ; LJMP <ovl_seg>:<ovl_off> ; <2/4/6-byte trailer>` (type-A, 658 instances) or a fixed 10-byte `LCALL 110D:0D91 ; LJMP <ovl_seg>:<ovl_off>` (type-B, 362 instances). When the load image far-calls a thunk, the LCALL invokes the RTLink runtime at file 0x14261/0x1427B which loads the requested overlay segment and patches the trailing LJMP's segment word to the runtime address. Catalogued in `code/VICEROY/overlay_thunks.md`. Distinct overlay segments referenced: 82. Top segments by entry count: 0x0000 (661 thunks — main code), 0x05EB (82), 0x0427 (47), 0x004B (25), 0x037F (24). The first thunk (offset 0x01A5F0, type-A, target 0x0000:0x025A) is the entry to _main, called from cstart at 0xF7D8. |
| 0x02083C | `unknown` | 127 | 125 | 98 | IN-PROGRESS | UNKNOWN |
| 0x020918 | `unknown` | 2 | 2 | 100 | DONE | UNKNOWN |
| 0x020F50 | `unknown` | 45 | 45 | 100 | DONE | Tutorial dispatcher  (M1W2 hand-annotated) |
| 0x021602 | `unknown` | 32 | 32 | 100 | DONE | UNKNOWN |
| 0x02165E | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x0219E8 | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x021A14 | `unknown` | 186 | 186 | 100 | DONE | UNKNOWN |
| 0x021D32 | `unknown` | 103 | 103 | 100 | DONE | UNKNOWN |
| 0x021E72 | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x021EDE | `unknown` | 88 | 88 | 100 | DONE | UNKNOWN |
| 0x021FF2 | `unknown` | 100 | 100 | 100 | DONE | Treaty-status check / break  (auto-inferred from string xref) |
| 0x02211E | `unknown` | 35 | 35 | 100 | DONE | UNKNOWN |
| 0x022334 | `unknown` | 30 | 30 | 100 | DONE | UNKNOWN |
| 0x022542 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x0227E8 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x022832 | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x02287E | `unknown` | 50 | 50 | 100 | DONE | UNKNOWN |
| 0x022A3A | `unknown` | 62 | 62 | 100 | DONE | UNKNOWN |
| 0x022CDC | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x022D46 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x022E16 | `unknown` | 48 | 48 | 100 | DONE | UNKNOWN |
| 0x022F08 | `unknown` | 43 | 43 | 100 | DONE | UNKNOWN |
| 0x023344 | `unknown` | 189 | 188 | 99 | IN-PROGRESS | UNKNOWN |
| 0x02356C | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x0235D6 | `unknown` | 50 | 50 | 100 | DONE | UNKNOWN |
| 0x023F1C | `unknown` | 76 | 76 | 100 | DONE | UNKNOWN |
| 0x0241CE | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x024224 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x0242AE | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x024322 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x024342 | `unknown` | 179 | 179 | 100 | DONE | UNKNOWN |
| 0x0245C6 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x024632 | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x024692 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x0246E2 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x024A48 | `unknown` | 61 | 61 | 100 | DONE | UNKNOWN |
| 0x0254C0 | `unknown` | 116 | 113 | 97 | IN-PROGRESS | UNKNOWN |
| 0x025900 | `unknown` | 106 | 106 | 100 | DONE | init_with_owner_nation (entry to colony state init)  (M1W2 hand-annotated) |
| 0x025A1E | `unknown` | 35 | 35 | 100 | DONE | UNKNOWN |
| 0x025C32 | `unknown` | 74 | 74 | 100 | DONE | UNKNOWN |
| 0x025D34 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x025EEE | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x026022 | `unknown` | 99 | 99 | 100 | DONE | UNKNOWN |
| 0x026142 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x02633E | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x026374 | `unknown` | 49 | 49 | 100 | DONE | UNKNOWN |
| 0x0264A8 | `unknown` | 74 | 74 | 100 | DONE | UNKNOWN |
| 0x0268CE | `unknown` | 52 | 52 | 100 | DONE | UNKNOWN |
| 0x026AB2 | `unknown` | 39 | 39 | 100 | DONE | UNKNOWN |
| 0x026BCC | `unknown` | 37 | 37 | 100 | DONE | UNKNOWN |
| 0x026CC2 | `unknown` | 94 | 94 | 100 | DONE | UNKNOWN |
| 0x026DD4 | `unknown` | 193 | 193 | 100 | DONE | UNKNOWN |
| 0x026FF2 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x02701C | `unknown` | 68 | 68 | 100 | DONE | UNKNOWN |
| 0x0270D0 | `unknown` | 81 | 81 | 100 | DONE | UNKNOWN |
| 0x0275CE | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x027746 | `unknown` | 154 | 154 | 100 | DONE | UNKNOWN |
| 0x027954 | `unknown` | 21 | 21 | 100 | DONE | popup_finalizer (overlay 0x0B70:0x0002)  (M1W2 hand-annotated) |
| 0x02798C | `unknown` | 121 | 121 | 100 | DONE | UNKNOWN |
| 0x027ADA | `unknown` | 50 | 50 | 100 | DONE | UNKNOWN |
| 0x027BB6 | `unknown` | 64 | 64 | 100 | DONE | UNKNOWN |
| 0x027D84 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x027DB2 | `unknown` | 66 | 66 | 100 | DONE | random_int (overlay 0x09EF:0x0032 — BYTE_VERIFIED helper)  (M1W2 hand-annotated) |
| 0x02814C | `unknown` | 38 | 38 | 100 | DONE | UNKNOWN |
| 0x02819E | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x0281D6 | `unknown` | 53 | 53 | 100 | DONE | UNKNOWN |
| 0x02842C | `unknown` | 5 | 5 | 100 | DONE | UNKNOWN |
| 0x028466 | `unknown` | 62 | 62 | 100 | DONE | UNKNOWN |
| 0x02853C | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x028592 | `unknown` | 58 | 58 | 100 | DONE | UNKNOWN |
| 0x028792 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x0287B2 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x0287C6 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x0287EA | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x028826 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x02883E | `unknown` | 49 | 49 | 100 | DONE | Town hall / colony-services menu  (M1W2 hand-annotated) |
| 0x028D8C | `unknown` | 58 | 58 | 100 | DONE | UNKNOWN |
| 0x02956D | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x0299A0 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x029AC0 | `unknown` | 72 | 72 | 100 | DONE | UNKNOWN |
| 0x029B84 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x029BBE | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x029C10 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x029D24 | `unknown` | 60 | 60 | 100 | DONE | UNKNOWN |
| 0x029DD4 | `unknown` | 111 | 111 | 100 | DONE | UNKNOWN |
| 0x02A0BC | `unknown` | 117 | 117 | 100 | DONE | UNKNOWN |
| 0x02A31C | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x02A462 | `unknown` | 37 | 37 | 100 | DONE | UNKNOWN |
| 0x02A6A6 | `unknown` | 40 | 40 | 100 | DONE | UNKNOWN |
| 0x02A8EC | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x02AAEC | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x02AD8E | `unknown` | 45 | 45 | 100 | DONE | UNKNOWN |
| 0x02AEDA | `unknown` | 47 | 47 | 100 | DONE | UNKNOWN |
| 0x02AFCE | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x02B046 | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x02B2A0 | `unknown` | 72 | 72 | 100 | DONE | UNKNOWN |
| 0x02B368 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x02B4D2 | `unknown` | 176 | 176 | 100 | DONE | UNKNOWN |
| 0x02B744 | `unknown` | 13 | 13 | 100 | DONE | Buy commodity (BUYME0)  (M1W2 hand-annotated) |
| 0x02B8C6 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x02B9DC | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x02BB8A | `unknown` | 39 | 39 | 100 | DONE | UNKNOWN |
| 0x02BC72 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x02C546 | `unknown` | 48 | 48 | 100 | DONE | UNKNOWN |
| 0x02C5D4 | `unknown` | 188 | 188 | 100 | DONE | UNKNOWN |
| 0x02CFD0 | `unknown` | 91 | 91 | 100 | DONE | UNKNOWN |
| 0x02D0E4 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x02D30A | `unknown` | 71 | 71 | 100 | DONE | UNKNOWN |
| 0x02D3C6 | `unknown` | 105 | 105 | 100 | DONE | UNKNOWN |
| 0x02D606 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x02D658 | `unknown` | 330 | 330 | 100 | DONE |  |
| 0x02EABC | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x02EAEA | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x02EB1C | `unknown` | 5 | 5 | 100 | DONE | UNKNOWN |
| 0x02EB46 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x02EB78 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x02EC2E | `unknown` | 5 | 5 | 100 | DONE | UNKNOWN |
| 0x02EE34 | `unknown` | 5 | 5 | 100 | DONE | UNKNOWN |
| 0x02EF64 | `unknown` | 77 | 77 | 100 | DONE | UNKNOWN |
| 0x02F052 | `unknown` | 41 | 41 | 100 | DONE | UNKNOWN |
| 0x02F3A2 | `unknown` | 18 | 18 | 100 | DONE | Win/lose check (KINGLOSE/KINGWIN/YOULOSE/YOUWIN)  (M1W2 hand-annotated) |
| 0x02FF0C | `unknown` | 47 | 47 | 100 | DONE | UNKNOWN |
| 0x03034C | `unknown` | 446 | 444 | 100 | IN-PROGRESS | UNKNOWN |
| 0x030550 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x030566 | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x030590 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x0305A8 | `unknown` | 30 | 30 | 100 | DONE |  |
| 0x030B38 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x030B4C | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x030BB6 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x030C14 | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x030C68 | `unknown` | 54 | 54 | 100 | DONE | UNKNOWN |
| 0x030D16 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x030D86 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x030DF4 | `unknown` | 136 | 136 | 100 | DONE | UNKNOWN |
| 0x030F76 | `unknown` | 112 | 112 | 100 | DONE | UNKNOWN |
| 0x0310B4 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x031298 | `unknown` | 57 | 57 | 100 | DONE | UNKNOWN |
| 0x031366 | `unknown` | 83 | 83 | 100 | DONE | UNKNOWN |
| 0x0314AE | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x0314DC | `unknown` | 74 | 74 | 100 | DONE | UNKNOWN |
| 0x0317CC | `unknown` | 98 | 98 | 100 | DONE | UNKNOWN |
| 0x0318D2 | `unknown` | 81 | 81 | 100 | DONE | UNKNOWN |
| 0x0319A6 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x0319BC | `unknown` | 37 | 37 | 100 | DONE | UNKNOWN |
| 0x031A32 | `unknown` | 70 | 70 | 100 | DONE | UNKNOWN |
| 0x031AFA | `unknown` | 60 | 60 | 100 | DONE | UNKNOWN |
| 0x031BB0 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x031BE6 | `unknown` | 164 | 164 | 100 | DONE | UNKNOWN |
| 0x031DC8 | `unknown` | 45 | 45 | 100 | DONE | UNKNOWN |
| 0x031F28 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x031F48 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x031F5C | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x031F80 | `unknown` | 33 | 33 | 100 | DONE | UNKNOWN |
| 0x03200A | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x0320EE | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x032122 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x0321B4 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x0321FC | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x032262 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x032278 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x032294 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x0322D0 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x03234A | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x03240C | `unknown` | 30 | 30 | 100 | DONE | UNKNOWN |
| 0x03245C | `unknown` | 32 | 32 | 100 | DONE | UNKNOWN |
| 0x0324C8 | `unknown` | 2 | 2 | 100 | DONE | UNKNOWN |
| 0x0324F2 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x032914 | `unknown` | 51 | 51 | 100 | DONE | UNKNOWN |
| 0x032DAC | `unknown` | 46 | 46 | 100 | DONE | UNKNOWN |
| 0x032FE2 | `unknown` | 46 | 46 | 100 | DONE | UNKNOWN |
| 0x03314E | `unknown` | 5 | 5 | 100 | DONE | UNKNOWN |
| 0x03334E | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x03342C | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x0335FA | `unknown` | 59 | 59 | 100 | DONE | UNKNOWN |
| 0x033716 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x033778 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x033A52 | `unknown` | 36 | 36 | 100 | DONE | UNKNOWN |
| 0x033BE4 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x033C96 | `unknown` | 191 | 191 | 100 | DONE | UNKNOWN |
| 0x0341D6 | `unknown` | 38 | 38 | 100 | DONE | UNKNOWN |
| 0x034318 | `unknown` | 93 | 93 | 100 | DONE | UNKNOWN |
| 0x03471E | `unknown` | 245 | 245 | 100 | DONE | UNKNOWN |
| 0x0349F4 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x034AE0 | `unknown` | 39 | 39 | 100 | DONE | UNKNOWN |
| 0x034C24 | `unknown` | 40 | 40 | 100 | DONE | UNKNOWN |
| 0x034DD4 | `unknown` | 80 | 80 | 100 | DONE | UNKNOWN |
| 0x0350A0 | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x0353DE | `unknown` | 43 | 43 | 100 | DONE | UNKNOWN |
| 0x0354BE | `unknown` | 92 | 92 | 100 | DONE | UNKNOWN |
| 0x035AD0 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x035B06 | `unknown` | 37 | 37 | 100 | DONE | UNKNOWN |
| 0x035D9A | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x035E80 | `unknown` | 100 | 100 | 100 | DONE | UNKNOWN |
| 0x036038 | `unknown` | 94 | 94 | 100 | DONE | UNKNOWN |
| 0x036138 | `unknown` | 40 | 40 | 100 | DONE | UNKNOWN |
| 0x0363A2 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x036574 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x036976 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x036B34 | `unknown` | 5 | 5 | 100 | DONE | UNKNOWN |
| 0x036B40 | `unknown` | 107 | 106 | 99 | IN-PROGRESS | UNKNOWN |
| 0x037340 | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x0373CA | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x03744A | `unknown` | 126 | 126 | 100 | DONE | UNKNOWN |
| 0x037958 | `unknown` | 67 | 67 | 100 | DONE | UNKNOWN |
| 0x037A10 | `unknown` | 45 | 45 | 100 | DONE | UNKNOWN |
| 0x03807E | `unknown` | 37 | 37 | 100 | DONE | UNKNOWN |
| 0x038418 | `unknown` | 218 | 218 | 100 | DONE | UNKNOWN |
| 0x038778 | `unknown` | 81 | 81 | 100 | DONE | UNKNOWN |
| 0x038890 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x038A50 | `unknown` | 128 | 128 | 100 | DONE | UNKNOWN |
| 0x038ED4 | `unknown` | 32 | 32 | 100 | DONE | UNKNOWN |
| 0x038F2C | `unknown` | 228 | 228 | 100 | DONE | UNKNOWN |
| 0x0391C0 | `unknown` | 32 | 32 | 100 | DONE | UNKNOWN |
| 0x039218 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x0393F4 | `unknown` | 116 | 116 | 100 | DONE | UNKNOWN |
| 0x03954C | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x039888 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x039E98 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x039EE2 | `unknown` | 261 | 261 | 100 | DONE | UNKNOWN |
| 0x03A9C0 | `unknown` | 23 | 23 | 100 | DONE | Score formula (964-byte stack frame!)  (M1W2 hand-annotated) |
| 0x03ADA6 | `unknown` | 424 | 424 | 100 | DONE | Hall-of-Fame writer (HALLFAME.DAT)  (M1W2 hand-annotated) |
| 0x03B2F8 | `unknown` | 43 | 43 | 100 | DONE | UNKNOWN |
| 0x03B3B8 | `unknown` | 701 | 700 | 100 | IN-PROGRESS | UNKNOWN |
| 0x03B900 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x03B93C | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x03B95A | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x03B980 | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x03B9E0 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x03BA26 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x03BA5A | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x03BAA6 | `unknown` | 56 | 56 | 100 | DONE | UNKNOWN |
| 0x03BB4A | `unknown` | 83 | 83 | 100 | DONE | UNKNOWN |
| 0x03BC42 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x03BFD2 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x03C282 | `unknown` | 56 | 56 | 100 | DONE | UNKNOWN |
| 0x03C322 | `unknown` | 73 | 73 | 100 | DONE | UNKNOWN |
| 0x03C424 | `unknown` | 51 | 51 | 100 | DONE | UNKNOWN |
| 0x03C4A2 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x03C528 | `unknown` | 41 | 41 | 100 | DONE | UNKNOWN |
| 0x03C5A8 | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x03C638 | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x03C932 | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x03CA2A | `unknown` | 57 | 57 | 100 | DONE | UNKNOWN |
| 0x03CAC6 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x03CDA2 | `unknown` | 92 | 92 | 100 | DONE | UNKNOWN |
| 0x03D510 | `unknown` | 374 | 374 | 100 | DONE | UNKNOWN |
| 0x03D948 | `unknown` | 16 | 16 | 100 | DONE | French intervention force (revolution aid)  (M1W2 hand-annotated) |
| 0x03DA2A | `unknown` | 70 | 70 | 100 | DONE | UNKNOWN |
| 0x03DE46 | `unknown` | 51 | 51 | 100 | DONE | Independence event handler  (M1W2 hand-annotated) |
| 0x03E162 | `unknown` | 49 | 49 | 100 | DONE | UNKNOWN |
| 0x03E2EA | `unknown` | 39 | 39 | 100 | DONE | UNKNOWN |
| 0x03E442 | `unknown` | 57 | 57 | 100 | DONE | UNKNOWN |
| 0x03E664 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x03E844 | `unknown` | 21 | 21 | 100 | DONE |  |
| 0x03E984 | `unknown` | 9 | 9 | 100 | DONE |  |
| 0x03ECF0 | `unknown` | 31 | 31 | 100 | DONE |  |
| 0x03F90E | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x03F946 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x03FA9C | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x03FDDE | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x040002 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x04002C | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x04007E | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x040170 | `unknown` | 162 | 159 | 98 | IN-PROGRESS | UNKNOWN |
| 0x0404B0 | `unknown` | 74 | 74 | 100 | DONE | Colony naming prompt  (auto-inferred from string xref) |
| 0x04057A | `unknown` | 53 | 53 | 100 | DONE | UNKNOWN |
| 0x040608 | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x040656 | `unknown` | 56 | 56 | 100 | DONE | UNKNOWN |
| 0x0409D6 | `unknown` | 191 | 191 | 100 | DONE | UNKNOWN |
| 0x040C1E | `unknown` | 163 | 163 | 100 | DONE | UNKNOWN |
| 0x040E22 | `unknown` | 140 | 140 | 100 | DONE | UNKNOWN |
| 0x040FD6 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x04101C | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x041034 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x041080 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x041410 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x041654 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x041832 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x0418AA | `unknown` | 70 | 70 | 100 | DONE | UNKNOWN |
| 0x04198E | `unknown` | 136 | 136 | 100 | DONE | UNKNOWN |
| 0x041B76 | `unknown` | 45 | 45 | 100 | DONE | UNKNOWN |
| 0x041C00 | `unknown` | 32 | 32 | 100 | DONE | UNKNOWN |
| 0x041C64 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x041CBE | `unknown` | 158 | 158 | 100 | DONE | UNKNOWN |
| 0x041E7E | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x041EEA | `unknown` | 187 | 187 | 100 | DONE | UNKNOWN |
| 0x042138 | `unknown` | 60 | 60 | 100 | DONE | UNKNOWN |
| 0x042726 | `unknown` | 60 | 60 | 100 | DONE | UNKNOWN |
| 0x0427D6 | `unknown` | 63 | 63 | 100 | DONE | UNKNOWN |
| 0x042B10 | `unknown` | 102 | 98 | 96 | IN-PROGRESS | UNKNOWN |
| 0x042CEC | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x042D46 | `unknown` | 36 | 36 | 100 | DONE | UNKNOWN |
| 0x042DA6 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x042DFA | `unknown` | 102 | 102 | 100 | DONE | UNKNOWN |
| 0x042F20 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x042FD6 | `unknown` | 39 | 39 | 100 | DONE | UNKNOWN |
| 0x043074 | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x044540 | `clamp_byte_at_far_ptr_to_5` | 9 | 9 | 100 | DONE | Reads a byte at the far pointer in [bp+4..7]. If the byte equals 6, decrements it to 5; otherwise returns it unchanged. AX = clamped byte (zero-extended). |
| 0x044556 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x04458A | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x0445EE | `unknown` | 35 | 35 | 100 | DONE | UNKNOWN |
| 0x044644 | `unknown` | 106 | 106 | 100 | DONE | UNKNOWN |
| 0x04477E | `unknown` | 44 | 44 | 100 | DONE | UNKNOWN |
| 0x044836 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x04497E | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x0449C4 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x044A5A | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x044A92 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x044AC2 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x044B06 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x044B36 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x044B7A | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x044D16 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x044E7C | `unknown` | 80 | 80 | 100 | DONE | UNKNOWN |
| 0x044FA4 | `unknown` | 38 | 38 | 100 | DONE | UNKNOWN |
| 0x0450BA | `unknown` | 96 | 96 | 100 | DONE | UNKNOWN |
| 0x0452D4 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x0458EC | `unknown` | 33 | 33 | 100 | DONE | UNKNOWN |
| 0x04598A | `unknown` | 57 | 57 | 100 | DONE | UNKNOWN |
| 0x045A1E | `unknown` | 71 | 71 | 100 | DONE | UNKNOWN |
| 0x045AE4 | `unknown` | 103 | 103 | 100 | DONE | UNKNOWN |
| 0x045D00 | `unknown` | 48 | 48 | 100 | DONE | UNKNOWN |
| 0x045D92 | `unknown` | 35 | 35 | 100 | DONE | UNKNOWN |
| 0x045DF2 | `unknown` | 104 | 104 | 100 | DONE | UNKNOWN |
| 0x046004 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x046056 | `unknown` | 55 | 55 | 100 | DONE | UNKNOWN |
| 0x0460F8 | `unknown` | 42 | 42 | 100 | DONE | UNKNOWN |
| 0x0464C2 | `unknown` | 103 | 103 | 100 | DONE | UNKNOWN |
| 0x0467F8 | `unknown` | 168 | 165 | 98 | IN-PROGRESS | UNKNOWN |
| 0x046D70 | `unknown` | 50 | 49 | 98 | IN-PROGRESS | UNKNOWN |
| 0x046DE0 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x046E18 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x046EC0 | `unknown` | 36 | 36 | 100 | DONE | UNKNOWN |
| 0x046FC2 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x046FFA | `unknown` | 40 | 40 | 100 | DONE | UNKNOWN |
| 0x0482DE | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x04830E | `unknown` | 259 | 259 | 100 | DONE | UNKNOWN |
| 0x0485F6 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x04891A | `unknown` | 49 | 49 | 100 | DONE | UNKNOWN |
| 0x048A3A | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x048CA4 | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x048CF8 | `unknown` | 192 | 192 | 100 | DONE | UNKNOWN |
| 0x048F34 | `unknown` | 327 | 327 | 100 | DONE | UNKNOWN |
| 0x049600 | `unknown` | 56 | 56 | 100 | DONE | UNKNOWN |
| 0x04A37C | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x04A426 | `unknown` | 39 | 39 | 100 | DONE | UNKNOWN |
| 0x04A7CA | `unknown` | 175 | 175 | 100 | DONE | Chief greeting  (auto-inferred from string xref) |
| 0x04AC00 | `unknown` | 133 | 133 | 100 | DONE | UNKNOWN |
| 0x04AF5E | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x04B036 | `unknown` | 117 | 117 | 100 | DONE | UNKNOWN |
| 0x04B308 | `unknown` | 204 | 204 | 100 | DONE | UNKNOWN |
| 0x04BDA4 | `unknown` | 83 | 79 | 95 | IN-PROGRESS | UNKNOWN |
| 0x04C060 | `unknown` | 69 | 68 | 99 | IN-PROGRESS | UNKNOWN |
| 0x04C0F0 | `unknown` | 2 | 2 | 100 | DONE | UNKNOWN |
| 0x04C1F0 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x04C20C | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x04C262 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x04C298 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x04C2CE | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x04C306 | `unknown` | 30 | 30 | 100 | DONE | UNKNOWN |
| 0x04C35A | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x04C404 | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x04C4AE | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x04C50C | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x04C532 | `unknown` | 38 | 38 | 100 | DONE | UNKNOWN |
| 0x04C596 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x04C5C0 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x04C682 | `unknown` | 55 | 55 | 100 | DONE | UNKNOWN |
| 0x04C71C | `unknown` | 70 | 70 | 100 | DONE | UNKNOWN |
| 0x04C7F0 | `unknown` | 37 | 37 | 100 | DONE | UNKNOWN |
| 0x04C846 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x04C89E | `unknown` | 170 | 170 | 100 | DONE | UNKNOWN |
| 0x04CA86 | `unknown` | 36 | 36 | 100 | DONE | UNKNOWN |
| 0x04CAF6 | `unknown` | 38 | 38 | 100 | DONE | UNKNOWN |
| 0x04CC50 | `unknown` | 71 | 71 | 100 | DONE | UNKNOWN |
| 0x04E2B6 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x04E2D6 | `unknown` | 178 | 178 | 100 | DONE | AI action dispatcher (11 sub-actions AI10..AI20)  (M1W2 hand-annotated) |
| 0x051D56 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x051E2C | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x051EE6 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x051EF4 | `unknown` | 370 | 370 | 100 | DONE | UNKNOWN |
| 0x052F7E | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x053654 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x053820 | `unknown` | 57 | 57 | 100 | DONE | UNKNOWN |
| 0x053A34 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x053AA0 | `unknown` | 36 | 36 | 100 | DONE | UNKNOWN |
| 0x053B14 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x053B26 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x053B7E | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x054505 | `unknown` | 55 | 55 | 100 | DONE | UNKNOWN |
| 0x055760 | `unknown` | 5 | 5 | 100 | DONE | UNKNOWN |
| 0x05576B | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x05651C | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x056694 | `unknown` | 666 | 663 | 100 | IN-PROGRESS | UNKNOWN |
| 0x056A10 | `unknown` | 90 | 90 | 100 | DONE | UNKNOWN |
| 0x056B08 | `unknown` | 48 | 48 | 100 | DONE | UNKNOWN |
| 0x056B92 | `unknown` | 58 | 58 | 100 | DONE | Indian peace overture  (auto-inferred from string xref) |
| 0x056C3E | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x0572E6 | `unknown` | 60 | 60 | 100 | DONE | Native conversion  (auto-inferred from string xref) |
| 0x057A3A | `unknown` | 36 | 36 | 100 | DONE | UNKNOWN |
| 0x057AA2 | `unknown` | 30 | 30 | 100 | DONE | UNKNOWN |
| 0x057AFC | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x057CE0 | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x057DC0 | `unknown` | 99 | 99 | 100 | DONE | UNKNOWN |
| 0x057F4E | `unknown` | 115 | 115 | 100 | DONE | UNKNOWN |
| 0x059B3E | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x059B90 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x05A20E | `unknown` | 48 | 48 | 100 | DONE | UNKNOWN |
| 0x05A40E | `unknown` | 30 | 30 | 100 | DONE | UNKNOWN |
| 0x05A862 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x05AC34 | `unknown` | 40 | 39 | 98 | IN-PROGRESS | UNKNOWN |
| 0x05AEA0 | `unknown` | 60 | 58 | 97 | IN-PROGRESS | UNKNOWN |
| 0x05AF2C | `unknown` | 32 | 32 | 100 | DONE | UNKNOWN |
| 0x05AF70 | `unknown` | 55 | 55 | 100 | DONE | UNKNOWN |
| 0x05B0DC | `unknown` | 167 | 167 | 100 | DONE | UNKNOWN |
| 0x05B2C2 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x05BE30 | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x05BE84 | `unknown` | 43 | 43 | 100 | DONE | UNKNOWN |
| 0x05C65A | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x05C69C | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x05C878 | `unknown` | 183 | 183 | 100 | DONE | Treasure cashed in  (auto-inferred from string xref) |
| 0x05CA7E | `unknown` | 133 | 133 | 100 | DONE | UNKNOWN |
| 0x05E7E0 | `unknown` | 76 | 75 | 99 | IN-PROGRESS | UNKNOWN |
| 0x05E9B0 | `unknown` | 51 | 51 | 100 | DONE | UNKNOWN |
| 0x05EA38 | `unknown` | 63 | 63 | 100 | DONE | UNKNOWN |
| 0x05FC30 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x05FE60 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x05FE7A | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x05FEA0 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x05FEF4 | `unknown` | 82 | 82 | 100 | DONE | UNKNOWN |
| 0x060026 | `unknown` | 59 | 59 | 100 | DONE | UNKNOWN |
| 0x060350 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x060382 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x0603A8 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x0603DA | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x06040A | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x06044C | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x06046E | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x060522 | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x0605F6 | `unknown` | 129 | 129 | 100 | DONE | UNKNOWN |
| 0x06076A | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x06083A | `unknown` | 101 | 101 | 100 | DONE | UNKNOWN |
| 0x060C34 | `unknown` | 66 | 66 | 100 | DONE | UNKNOWN |
| 0x060CE0 | `unknown` | 54 | 54 | 100 | DONE | UNKNOWN |
| 0x060D8C | `unknown` | 125 | 125 | 100 | DONE | UNKNOWN |
| 0x060EC4 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x060F32 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x060FBC | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x0610B0 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
_… and 241 more — see `code/VICEROY/ledger.json` for the full list._

## `MAPEDIT.EXE`

- Functions: **210** (DONE: 209, IN-PROGRESS: 1, RAW: 0)
- Function code lines: 4,711 (identified: 4,709)
- Orphan code lines: 78,607 (identified: 78,533)
- Grand total: **83,318** lines, **99.91%** identified.

| Offset | Name | Lines | Ident | % | Status | Purpose |
|--------|------|------:|------:|--:|--------|---------|
| 0x00232A | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x00239E | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x002A04 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x002B82 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x002DE0 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x003724 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x0038E4 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x00402A | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x0040B2 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x00427E | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00466C | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x0046CE | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x00494A | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x004976 | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x0049DE | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x004D1A | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x004DAE | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x004DCA | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x004E0A | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x004E24 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x004ED4 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x0053C0 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x005600 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x005B08 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x00641A | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x006F3C | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x007A62 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x0080E2 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x00810C | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x00813E | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x008168 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x008180 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x0081AA | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x008378 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00838E | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x0083C2 | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x009C5E | `unknown` | 6 | 6 | 100 | DONE |  |
| 0x009C7C | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x009C92 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x009D16 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x009D8E | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x009DB4 | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x00A02A | `unknown` | 35 | 35 | 100 | DONE | UNKNOWN |
| 0x00A0D0 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x00A102 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x00A112 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x00A122 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x00A132 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x00A142 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x00A152 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x00A162 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x00A172 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x00A182 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x00A192 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x00A1A2 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x00A1B2 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x00A1CC | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x00A2B8 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x00A2E6 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x00A302 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x00A31E | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x00A358 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x00A392 | `unknown` | 33 | 33 | 100 | DONE | UNKNOWN |
| 0x00A3E8 | `unknown` | 36 | 36 | 100 | DONE | UNKNOWN |
| 0x00A42C | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x00A46A | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x00A500 | `unknown` | 37 | 37 | 100 | DONE | UNKNOWN |
| 0x00A548 | `unknown` | 35 | 35 | 100 | DONE | UNKNOWN |
| 0x00B176 | `unknown` | 5 | 5 | 100 | DONE | UNKNOWN |
| 0x00B1A2 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x00B1DC | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x00B20A | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x00CA92 | `unknown` | 44 | 44 | 100 | DONE | UNKNOWN |
| 0x00CDD4 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x00CF14 | `unknown` | 54 | 54 | 100 | DONE | UNKNOWN |
| 0x00D030 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x00D0A2 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00D0F4 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x00D108 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00D12E | `unknown` | 44 | 44 | 100 | DONE | UNKNOWN |
| 0x00D64E | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x00D810 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x00D852 | `unknown` | 55 | 55 | 100 | DONE | UNKNOWN |
| 0x00D920 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00D984 | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x00D9EA | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00DA24 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x00DA9E | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x00DD64 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x00DD80 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x00DE6C | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00E0BC | `unknown` | 44 | 44 | 100 | DONE | UNKNOWN |
| 0x00E380 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x00E39C | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x00E57C | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x00E68E | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x00E6E8 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x00ECA6 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x00ED0A | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x010AE0 | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x010B1E | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x011AF2 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x011BB6 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x011BCA | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x011C1A | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x011D4E | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x011D6C | `unknown` | 74 | 74 | 100 | DONE | UNKNOWN |
| 0x011FC8 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x0120D2 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x01288B | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x0128D6 | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x01298A | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x0129A4 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x012A86 | `unknown` | 38 | 38 | 100 | DONE | UNKNOWN |
| 0x012AF0 | `unknown` | 42 | 42 | 100 | DONE | UNKNOWN |
| 0x013ADC | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x013AEE | `unknown` | 44 | 44 | 100 | DONE | UNKNOWN |
| 0x013DEC | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x013E18 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x013E5A | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x013E90 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x013EB4 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x013EF0 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x0140DC | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x01469A | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x0146A4 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x0146BA | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x0149EA | `unknown` | 35 | 35 | 100 | DONE | UNKNOWN |
| 0x014A34 | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x014B7E | `unknown` | 5 | 5 | 100 | DONE | UNKNOWN |
| 0x014C0A | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x014C78 | `unknown` | 30 | 30 | 100 | DONE | UNKNOWN |
| 0x01505B | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x015062 | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x01506A | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x015074 | `unknown` | 44 | 44 | 100 | DONE | UNKNOWN |
| 0x015142 | `unknown` | 72 | 72 | 100 | DONE | UNKNOWN |
| 0x0151FC | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x015228 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x01523E | `unknown` | 63 | 63 | 100 | DONE | UNKNOWN |
| 0x015322 | `unknown` | 78 | 78 | 100 | DONE | UNKNOWN |
| 0x015428 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x015466 | `unknown` | 30 | 30 | 100 | DONE |  |
| 0x0154A6 | `unknown` | 26 | 26 | 100 | DONE |  |
| 0x0154D8 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x015504 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x015520 | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x015556 | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x01557E | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x0155BC | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x0155D8 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x0155E2 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x01560A | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x01567E | `unknown` | 47 | 47 | 100 | DONE | UNKNOWN |
| 0x0156FE | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x015718 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x01575C | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x015788 | `unknown` | 37 | 37 | 100 | DONE | UNKNOWN |
| 0x0157E2 | `unknown` | 57 | 57 | 100 | DONE | UNKNOWN |
| 0x015868 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x015892 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x0158EA | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x015908 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x015926 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x015934 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x01593F | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x015972 | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x015979 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x0159A2 | `unknown` | 73 | 73 | 100 | DONE |  |
| 0x015A3C | `unknown` | 11 | 11 | 100 | DONE |  |
| 0x015A6E | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x015ACA | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x015B28 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x015B56 | `unknown` | 36 | 36 | 100 | DONE | UNKNOWN |
| 0x015B9C | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x015BD8 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x015C02 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x015C30 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x015C54 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x015C6C | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x015CA2 | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x015CE8 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x015D30 | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x015DFA | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x015FD8 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x016056 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x016081 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x01610E | `unknown` | 65 | 65 | 100 | DONE | UNKNOWN |
| 0x0161A4 | `unknown` | 65 | 65 | 100 | DONE | UNKNOWN |
| 0x016288 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x0162B4 | `unknown` | 93 | 93 | 100 | DONE | UNKNOWN |
| 0x01639C | `unknown` | 47 | 47 | 100 | DONE | UNKNOWN |
| 0x01640F | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x01644E | `unknown` | 50 | 50 | 100 | DONE | UNKNOWN |
| 0x0164CA | `unknown` | 33 | 33 | 100 | DONE | UNKNOWN |
| 0x016526 | `unknown` | 186 | 184 | 99 | IN-PROGRESS | UNKNOWN |
| 0x016A32 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x016A52 | `unknown` | 46 | 46 | 100 | DONE | UNKNOWN |
| 0x016ACC | `unknown` | 52 | 52 | 100 | DONE | UNKNOWN |
| 0x016BB6 | `unknown` | 82 | 82 | 100 | DONE | UNKNOWN |
| 0x016CF6 | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x016D4A | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x016D76 | `unknown` | 71 | 71 | 100 | DONE | UNKNOWN |
| 0x016EEC | `unknown` | 68 | 68 | 100 | DONE | UNKNOWN |
| 0x016FAC | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x01705E | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x0170A2 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x0170BC | `unknown` | 42 | 42 | 100 | DONE | UNKNOWN |
| 0x01727E | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x01729F | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |

## `OPENING.EXE`

- Functions: **145** (DONE: 144, IN-PROGRESS: 1, RAW: 0)
- Function code lines: 3,885 (identified: 3,883)
- Orphan code lines: 52,543 (identified: 52,398)
- Grand total: **56,428** lines, **99.74%** identified.

| Offset | Name | Lines | Ident | % | Status | Purpose |
|--------|------|------:|------:|--:|--------|---------|
| 0x000C00 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x000C2E | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x0016AC | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x00198C | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x002594 | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x00261C | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x002A38 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x002A64 | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x002ACC | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x002AFC | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x002DD2 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x0030F2 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x003106 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00322A | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x003514 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00357A | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x0035B4 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x0035F6 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x003982 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x00399E | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x003B7E | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x003C90 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x003CEA | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x003D2E | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x0042D6 | `unknown` | 5 | 5 | 100 | DONE | UNKNOWN |
| 0x00433A | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x005142 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x00525E | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x005439 | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x005440 | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x005448 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x005452 | `unknown` | 44 | 44 | 100 | DONE | UNKNOWN |
| 0x005520 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x005546 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x005563 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x005576 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x005588 | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x005642 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x00566E | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x005684 | `unknown` | 63 | 63 | 100 | DONE | UNKNOWN |
| 0x005768 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x0057A6 | `unknown` | 30 | 30 | 100 | DONE |  |
| 0x0057E6 | `unknown` | 26 | 26 | 100 | DONE |  |
| 0x005818 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x005844 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x005860 | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x005896 | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x0058BE | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x0058FC | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x005918 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x005922 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x00594A | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x0059BE | `unknown` | 47 | 47 | 100 | DONE | UNKNOWN |
| 0x005A3E | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x005A58 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x005A9C | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x005AC8 | `unknown` | 57 | 57 | 100 | DONE | UNKNOWN |
| 0x005B4E | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x005B78 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x005B96 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x005BB4 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x005BE2 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x005C00 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x005C0E | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x005C15 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x005C3E | `unknown` | 73 | 73 | 100 | DONE |  |
| 0x005CD8 | `unknown` | 11 | 11 | 100 | DONE |  |
| 0x005D0A | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x005D66 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x005DC4 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x005DF2 | `unknown` | 36 | 36 | 100 | DONE | UNKNOWN |
| 0x005E38 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x005E74 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x005E9E | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x005ECC | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x005EF0 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x005F08 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x005F3E | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x005F84 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x005FCC | `unknown` | 39 | 39 | 100 | DONE | UNKNOWN |
| 0x006096 | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x006274 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x0062F2 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x00631D | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x0063AA | `unknown` | 65 | 65 | 100 | DONE | UNKNOWN |
| 0x006440 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x00646C | `unknown` | 93 | 93 | 100 | DONE | UNKNOWN |
| 0x006554 | `unknown` | 47 | 47 | 100 | DONE | UNKNOWN |
| 0x0065C7 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x006606 | `unknown` | 50 | 50 | 100 | DONE | UNKNOWN |
| 0x006682 | `unknown` | 33 | 33 | 100 | DONE | UNKNOWN |
| 0x0066DE | `unknown` | 186 | 184 | 99 | IN-PROGRESS | UNKNOWN |
| 0x006BEA | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x006C0A | `unknown` | 46 | 46 | 100 | DONE | UNKNOWN |
| 0x006C84 | `unknown` | 52 | 52 | 100 | DONE | UNKNOWN |
| 0x006D6E | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x006DC2 | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x006DEE | `unknown` | 71 | 71 | 100 | DONE | UNKNOWN |
| 0x006F64 | `unknown` | 68 | 68 | 100 | DONE | UNKNOWN |
| 0x007024 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x0070B0 | `unknown` | 127 | 127 | 100 | DONE | UNKNOWN |
| 0x00722C | `unknown` | 65 | 65 | 100 | DONE | UNKNOWN |
| 0x007310 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x007354 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x00736E | `unknown` | 42 | 42 | 100 | DONE | UNKNOWN |
| 0x007510 | `unknown` | 82 | 82 | 100 | DONE | UNKNOWN |
| 0x00765C | `unknown` | 38 | 38 | 100 | DONE | UNKNOWN |
| 0x0076BC | `unknown` | 67 | 67 | 100 | DONE | UNKNOWN |
| 0x007850 | `unknown` | 106 | 106 | 100 | DONE | UNKNOWN |
| 0x007976 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x007997 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x007ABE | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x007B00 | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x007B2C | `unknown` | 133 | 133 | 100 | DONE | UNKNOWN |
| 0x007DA4 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x008128 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x0082FB | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x008380 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00877E | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x008790 | `unknown` | 56 | 56 | 100 | DONE | UNKNOWN |
| 0x008BA0 | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x008BDE | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x009A58 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x009B1C | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x009B30 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x009C38 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x009C56 | `unknown` | 74 | 74 | 100 | DONE | UNKNOWN |
| 0x009EB2 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x009FBC | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x00AE5C | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x00AE66 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x00AE7C | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x00B1AC | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x00B1D8 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x00B21A | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00B250 | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x00B39A | `unknown` | 5 | 5 | 100 | DONE | UNKNOWN |
| 0x00B77A | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x00B82E | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x00B848 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x00B92A | `unknown` | 38 | 38 | 100 | DONE | UNKNOWN |
| 0x00B994 | `unknown` | 42 | 42 | 100 | DONE | UNKNOWN |
| 0x00BB9E | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x00BC0C | `unknown` | 45 | 45 | 100 | DONE | UNKNOWN |
| 0x00BE22 | `unknown` | 35 | 35 | 100 | DONE | UNKNOWN |

## `CLOSING.EXE`

- Functions: **136** (DONE: 135, IN-PROGRESS: 1, RAW: 0)
- Function code lines: 3,911 (identified: 3,909)
- Orphan code lines: 50,126 (identified: 50,054)
- Grand total: **54,037** lines, **99.86%** identified.

| Offset | Name | Lines | Ident | % | Status | Purpose |
|--------|------|------:|------:|--:|--------|---------|
| 0x000E4C | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x00176A | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x0017F2 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x001C0E | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x001C3A | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x001CA2 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x001CD2 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x001FA8 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x0022C8 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x0022DC | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x002400 | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x0026EA | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x002750 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00278A | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x0027CC | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x002A9C | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x002AB8 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x002C98 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x002DAA | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x002E04 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x0033C2 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x0033DE | `unknown` | 25 | 25 | 100 | DONE | UNKNOWN |
| 0x0041E6 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x004302 | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x0044DD | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x0044E4 | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x0044EC | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x0044F6 | `unknown` | 44 | 44 | 100 | DONE | UNKNOWN |
| 0x0045C4 | `unknown` | 72 | 72 | 100 | DONE | UNKNOWN |
| 0x00467E | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x0046AA | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x0046C0 | `unknown` | 63 | 63 | 100 | DONE | UNKNOWN |
| 0x0047A4 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x0047E2 | `unknown` | 30 | 30 | 100 | DONE |  |
| 0x004822 | `unknown` | 26 | 26 | 100 | DONE |  |
| 0x004854 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x004880 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x00489C | `unknown` | 28 | 28 | 100 | DONE | UNKNOWN |
| 0x0048D2 | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x0048FA | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x004938 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x004954 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x00495E | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x004986 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x0049FA | `unknown` | 47 | 47 | 100 | DONE | UNKNOWN |
| 0x004A7A | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x004A94 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x004AD8 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x004B04 | `unknown` | 57 | 57 | 100 | DONE | UNKNOWN |
| 0x004B8A | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x004BB4 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x004BD2 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x004BF0 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x004C0E | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x004C15 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x004C3E | `unknown` | 73 | 73 | 100 | DONE |  |
| 0x004CD8 | `unknown` | 11 | 11 | 100 | DONE |  |
| 0x004D0A | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x004D66 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x004DC4 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x004DF2 | `unknown` | 36 | 36 | 100 | DONE | UNKNOWN |
| 0x004E38 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x004E74 | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x004E9E | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x004ECC | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x004EF0 | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x004F08 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x004F3E | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x004F84 | `unknown` | 24 | 24 | 100 | DONE | UNKNOWN |
| 0x004FCC | `unknown` | 39 | 39 | 100 | DONE | UNKNOWN |
| 0x005096 | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x005274 | `unknown` | 6 | 6 | 100 | DONE | UNKNOWN |
| 0x0052F2 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x00531D | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x0053AA | `unknown` | 65 | 65 | 100 | DONE | UNKNOWN |
| 0x005440 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x00546C | `unknown` | 93 | 93 | 100 | DONE | UNKNOWN |
| 0x005554 | `unknown` | 47 | 47 | 100 | DONE | UNKNOWN |
| 0x0055C7 | `unknown` | 29 | 29 | 100 | DONE | UNKNOWN |
| 0x005606 | `unknown` | 50 | 50 | 100 | DONE | UNKNOWN |
| 0x005682 | `unknown` | 33 | 33 | 100 | DONE | UNKNOWN |
| 0x0056DE | `unknown` | 186 | 184 | 99 | IN-PROGRESS | UNKNOWN |
| 0x005BEA | `unknown` | 13 | 13 | 100 | DONE | UNKNOWN |
| 0x005C0A | `unknown` | 46 | 46 | 100 | DONE | UNKNOWN |
| 0x005C84 | `unknown` | 52 | 52 | 100 | DONE | UNKNOWN |
| 0x005D6E | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x005DC2 | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x005DEE | `unknown` | 71 | 71 | 100 | DONE | UNKNOWN |
| 0x005F64 | `unknown` | 68 | 68 | 100 | DONE | UNKNOWN |
| 0x006024 | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x0060B0 | `unknown` | 127 | 127 | 100 | DONE | UNKNOWN |
| 0x006206 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x00623A | `unknown` | 65 | 65 | 100 | DONE | UNKNOWN |
| 0x00631E | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x006362 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x00637C | `unknown` | 42 | 42 | 100 | DONE | UNKNOWN |
| 0x00651E | `unknown` | 82 | 82 | 100 | DONE | UNKNOWN |
| 0x00666A | `unknown` | 38 | 38 | 100 | DONE | UNKNOWN |
| 0x0066CA | `unknown` | 151 | 151 | 100 | DONE | UNKNOWN |
| 0x00685E | `unknown` | 106 | 106 | 100 | DONE | UNKNOWN |
| 0x006984 | `unknown` | 17 | 17 | 100 | DONE | UNKNOWN |
| 0x0069A5 | `unknown` | 21 | 21 | 100 | DONE | UNKNOWN |
| 0x006ACC | `unknown` | 34 | 34 | 100 | DONE | UNKNOWN |
| 0x006B0E | `unknown` | 26 | 26 | 100 | DONE | UNKNOWN |
| 0x006B3A | `unknown` | 133 | 133 | 100 | DONE | UNKNOWN |
| 0x006DB2 | `unknown` | 20 | 20 | 100 | DONE | UNKNOWN |
| 0x007136 | `unknown` | 22 | 22 | 100 | DONE | UNKNOWN |
| 0x007309 | `unknown` | 7 | 7 | 100 | DONE | UNKNOWN |
| 0x00738E | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00778C | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00779E | `unknown` | 56 | 56 | 100 | DONE | UNKNOWN |
| 0x007BAE | `unknown` | 19 | 19 | 100 | DONE | UNKNOWN |
| 0x007BEC | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x008B22 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x008BE6 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x008BFA | `unknown` | 23 | 23 | 100 | DONE | UNKNOWN |
| 0x008D02 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x008D20 | `unknown` | 74 | 74 | 100 | DONE | UNKNOWN |
| 0x008F7C | `unknown` | 18 | 18 | 100 | DONE | UNKNOWN |
| 0x009086 | `unknown` | 8 | 8 | 100 | DONE | UNKNOWN |
| 0x009F26 | `unknown` | 4 | 4 | 100 | DONE | UNKNOWN |
| 0x009F30 | `unknown` | 11 | 11 | 100 | DONE | UNKNOWN |
| 0x009F46 | `unknown` | 12 | 12 | 100 | DONE | UNKNOWN |
| 0x00A276 | `unknown` | 15 | 15 | 100 | DONE | UNKNOWN |
| 0x00A2A2 | `unknown` | 27 | 27 | 100 | DONE | UNKNOWN |
| 0x00A2E4 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00A31A | `unknown` | 16 | 16 | 100 | DONE | UNKNOWN |
| 0x00A464 | `unknown` | 5 | 5 | 100 | DONE | UNKNOWN |
| 0x00A844 | `unknown` | 31 | 31 | 100 | DONE | UNKNOWN |
| 0x00A8F8 | `unknown` | 10 | 10 | 100 | DONE | UNKNOWN |
| 0x00A912 | `unknown` | 9 | 9 | 100 | DONE | UNKNOWN |
| 0x00A9F4 | `unknown` | 38 | 38 | 100 | DONE | UNKNOWN |
| 0x00AA5E | `unknown` | 42 | 42 | 100 | DONE | UNKNOWN |
| 0x00AC68 | `unknown` | 14 | 14 | 100 | DONE | UNKNOWN |
| 0x00ACD6 | `unknown` | 45 | 45 | 100 | DONE | UNKNOWN |
| 0x00AEEC | `unknown` | 35 | 35 | 100 | DONE | UNKNOWN |
