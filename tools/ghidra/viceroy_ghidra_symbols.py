# VICEROY.EXE symbol import for Ghidra  (GENERATED — do not hand-edit)
# Regenerate: python3 tools/ghidra/export_ghidra_symbols.py
#
# BUILD 7da1a1bbc0fc
# If a traceback from this file does not match the line numbers you expect,
# check that stamp against the one the repo prints — you are probably running
# an older copy that is still sitting in ghidra_scripts/.
#
# WHAT IT DOES
#   * names every one of the 1,250 known functions (89 carry their real 1994
#     CodeView names, recovered from MAPEDIT.EXE by instruction fingerprint)
#   * plate-comments each function with its module, overlay page, size and the
#     GAME.TXT message keys it emits
#   * creates a DGROUP memory block and labels ~150 named globals in it
#   * bookmarks the 31 RTLink overlay page boundaries
#
# HOW TO LOAD THE BINARY (important — see tools/ghidra/README.md)
#   Import VICEROY.EXE as **Raw Binary**, language x86:LE:16:Real Mode,
#   base address 0.  Then Ghidra address == file offset and all 31 overlay
#   pages are visible.  A normal MZ import maps only the load image (a
#   quarter of the code) — if you did that, set MZ_LOAD = True below.
#
# RUNTIME: works under BOTH Ghidra Python providers.
#   * PyGhidra (CPython 3, bundled and default since Ghidra 11.3)
#   * Jython 2.7 (the older provider, an installable extension)
# Only stdlib `json` plus the injected flat API are used, and the one Java
# type it needs is imported explicitly (a bare `ghidra.program...` reference
# resolves under neither provider).  No f-strings, no print_function needed.
#
# @category Colonization

MZ_LOAD = False          # True if imported as MS-DOS Executable rather than raw

# Synthetic home for the BSS half of DGROUP.  MUST be a valid address in the
# program's address space: x86 real mode tops out near 1 MB, so a "safely
# high" value like 0x200000 is NOT addressable and block creation fails.
# The file itself is ~495 KB (0x78D3E), so 0x80000 sits just past it and
# inside the 1 MB real-mode range.  Fallbacks are tried automatically.
DGROUP_BLOCK_ADDR = 0x80000
DGROUP_FALLBACKS = (0x80000, 0x90000, 0xF0000, 0x200000)

import json

try:
    from ghidra.program.model.symbol import SourceType
    SRC = SourceType.IMPORTED
except Exception as _e:      # pragma: no cover - provider without the class
    SRC = None
    print("WARNING: could not import SourceType (%s); renames will be skipped"
          % _e)

DATA = json.loads(r"""{
"funcs": [
{
"a": 9216,
"n": "rt_strtab_open",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 33,
"lead": "",
"k": []
},
{
"a": 9260,
"n": "rt_strtab_append",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 53,
"lead": "",
"k": []
},
{
"a": 9314,
"n": "rt_far_strlen",
"t": "R",
"m": "strings.obj",
"p": "",
"s": 45,
"lead": "_strings",
"k": []
},
{
"a": 9364,
"n": "rt_code_select_2out",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 50,
"lead": "",
"k": []
},
{
"a": 9414,
"n": "resident__unattributed_0024C6",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 126,
"lead": "",
"k": []
},
{
"a": 9540,
"n": "resident__unattributed_002544",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 60,
"lead": "",
"k": []
},
{
"a": 9742,
"n": "format_to_buffer_2D54",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 35,
"lead": "",
"k": []
},
{
"a": 9778,
"n": "rt_emit_long",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 21,
"lead": "",
"k": []
},
{
"a": 9800,
"n": "rt_fmt_emit_1arg",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 32,
"lead": "",
"k": []
},
{
"a": 9832,
"n": "rt_fmt_emit_2arg",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 35,
"lead": "",
"k": []
},
{
"a": 9868,
"n": "rt_fmt_emit_str",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 38,
"lead": "",
"k": []
},
{
"a": 9940,
"n": "resident__unattributed_0026D4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 44,
"lead": "",
"k": []
},
{
"a": 10046,
"n": "resident__unattributed_00273E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 10,
"lead": "",
"k": []
},
{
"a": 10076,
"n": "resident__unattributed_00275C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 39,
"lead": "",
"k": []
},
{
"a": 10115,
"n": "resident__unattributed_002783",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 13,
"lead": "",
"k": []
},
{
"a": 10386,
"n": "resident__unattributed_002892",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 30,
"lead": "",
"k": []
},
{
"a": 10416,
"n": "call_overlay_with_80",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 16,
"lead": "",
"k": []
},
{
"a": 10432,
"n": "_spacer",
"t": "B",
"m": "write.obj",
"p": "",
"s": 33,
"lead": "",
"k": []
},
{
"a": 10466,
"n": "rt_libwrap_7a4_s52",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": []
},
{
"a": 10482,
"n": "rt_libwrap_7a4_s55",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": []
},
{
"a": 10498,
"n": "rt_libwrap_7a4_s58",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": []
},
{
"a": 10514,
"n": "rt_libwrap_7a4_s5c",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": []
},
{
"a": 10530,
"n": "rt_libwrap_7a4_s5e",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": []
},
{
"a": 10546,
"n": "rt_libwrap_7a4_s60",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": []
},
{
"a": 10562,
"n": "write_obj_002942",
"t": "M",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": []
},
{
"a": 10578,
"n": "write_obj_002952",
"t": "M",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": []
},
{
"a": 10594,
"n": "rt_libwrap_7a4_s66",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": []
},
{
"a": 10610,
"n": "rt_libwrap_7a4_s68",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": []
},
{
"a": 10626,
"n": "rt_libwrap_7a4_s6a",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": []
},
{
"a": 10642,
"n": "write_obj_002992",
"t": "M",
"m": "write.obj",
"p": "",
"s": 26,
"lead": "",
"k": []
},
{
"a": 10668,
"n": "write_obj_0029AC",
"t": "M",
"m": "write.obj",
"p": "",
"s": 49,
"lead": "",
"k": []
},
{
"a": 10718,
"n": "write_obj_0029DE",
"t": "M",
"m": "write.obj",
"p": "",
"s": 39,
"lead": "",
"k": []
},
{
"a": 10758,
"n": "write_obj_002A06",
"t": "M",
"m": "write.obj",
"p": "",
"s": 104,
"lead": "",
"k": []
},
{
"a": 10862,
"n": "write_obj_002A6E",
"t": "M",
"m": "write.obj",
"p": "",
"s": 42,
"lead": "",
"k": []
},
{
"a": 10904,
"n": "write_obj_002A98",
"t": "M",
"m": "write.obj",
"p": "",
"s": 46,
"lead": "_say_bucks",
"k": []
},
{
"a": 10950,
"n": "write_obj_002AC6",
"t": "M",
"m": "write.obj",
"p": "",
"s": 27,
"lead": "",
"k": []
},
{
"a": 10978,
"n": "write_obj_002AE2",
"t": "M",
"m": "write.obj",
"p": "",
"s": 27,
"lead": "",
"k": []
},
{
"a": 11006,
"n": "write_obj_002AFE",
"t": "M",
"m": "write.obj",
"p": "",
"s": 58,
"lead": "",
"k": []
},
{
"a": 11064,
"n": "write_obj_002B38",
"t": "M",
"m": "write.obj",
"p": "",
"s": 58,
"lead": "",
"k": []
},
{
"a": 11122,
"n": "write_obj_002B72",
"t": "M",
"m": "write.obj",
"p": "",
"s": 85,
"lead": "",
"k": []
},
{
"a": 11208,
"n": "_write_centered",
"t": "B",
"m": "write.obj",
"p": "",
"s": 68,
"lead": "",
"k": []
},
{
"a": 11276,
"n": "write_obj_002C0C",
"t": "M",
"m": "write.obj",
"p": "",
"s": 62,
"lead": "",
"k": []
},
{
"a": 11338,
"n": "write_obj_002C4A",
"t": "M",
"m": "write.obj",
"p": "",
"s": 56,
"lead": "",
"k": []
},
{
"a": 11394,
"n": "write_obj_002C82",
"t": "M",
"m": "write.obj",
"p": "",
"s": 94,
"lead": "",
"k": []
},
{
"a": 11488,
"n": "_write_big_centered",
"t": "B",
"m": "write.obj",
"p": "",
"s": 71,
"lead": "",
"k": []
},
{
"a": 11560,
"n": "_say_terrain",
"t": "B",
"m": "write.obj",
"p": "",
"s": 75,
"lead": "",
"k": []
},
{
"a": 11636,
"n": "shared_game_band_002D74",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 218,
"lead": "",
"k": []
},
{
"a": 11854,
"n": "shared_game_band_002E4E",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 149,
"lead": "",
"k": []
},
{
"a": 12004,
"n": "shared_game_band_002EE4",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 358,
"lead": "",
"k": []
},
{
"a": 12362,
"n": "shared_game_band_00304A",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 142,
"lead": "",
"k": []
},
{
"a": 12548,
"n": "shared_game_band_003104",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 143,
"lead": "",
"k": []
},
{
"a": 12691,
"n": "shared_game_band_003193",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 598,
"lead": "",
"k": []
},
{
"a": 13298,
"n": "shared_game_band_0033F2",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 43,
"lead": "",
"k": []
},
{
"a": 13342,
"n": "shared_game_band_00341E",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 23,
"lead": "",
"k": []
},
{
"a": 13366,
"n": "_tile_id",
"t": "B",
"m": "tile.obj",
"p": "",
"s": 25,
"lead": "",
"k": []
},
{
"a": 13408,
"n": "shared_game_band_003460",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 99,
"lead": "",
"k": []
},
{
"a": 13508,
"n": "shared_game_band_0034C4",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 114,
"lead": "",
"k": []
},
{
"a": 13622,
"n": "shared_game_band_003536",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 53,
"lead": "",
"k": []
},
{
"a": 13804,
"n": "shared_game_band_0035EC",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 53,
"lead": "",
"k": []
},
{
"a": 14096,
"n": "shared_game_band_003710",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 20,
"lead": "",
"k": []
},
{
"a": 14270,
"n": "shared_game_band_0037BE",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 78,
"lead": "",
"k": []
},
{
"a": 14348,
"n": "shared_game_band_00380C",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 93,
"lead": "",
"k": []
},
{
"a": 14442,
"n": "shared_game_band_00386A",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 100,
"lead": "",
"k": []
},
{
"a": 15936,
"n": "shared_game_band_003E40",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 174,
"lead": "",
"k": []
},
{
"a": 17172,
"n": "shared_game_band_004314",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 14,
"lead": "",
"k": []
},
{
"a": 17329,
"n": "shared_game_band_0043B1",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 40,
"lead": "",
"k": []
},
{
"a": 17766,
"n": "shared_game_band_004566",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 326,
"lead": "",
"k": []
},
{
"a": 18636,
"n": "stuff_obj_0048CC",
"t": "M",
"m": "stuff.obj",
"p": "",
"s": 13,
"lead": "_minimax",
"k": []
},
{
"a": 18666,
"n": "stuff_obj_0048EA",
"t": "M",
"m": "stuff.obj",
"p": "",
"s": 21,
"lead": "_swap",
"k": []
},
{
"a": 18688,
"n": "_xy_dist",
"t": "B",
"m": "stuff.obj",
"p": "",
"s": 15,
"lead": "",
"k": []
},
{
"a": 18748,
"n": "stuff_obj_00493C",
"t": "M",
"m": "stuff.obj",
"p": "",
"s": 14,
"lead": "",
"k": []
},
{
"a": 18820,
"n": "_xy_dist_2",
"t": "B",
"m": "stuff.obj",
"p": "",
"s": 12,
"lead": "",
"k": []
},
{
"a": 18868,
"n": "stuff_obj_0049B4",
"t": "M",
"m": "stuff.obj",
"p": "",
"s": 14,
"lead": "",
"k": []
},
{
"a": 18940,
"n": "_bearing_adjacent",
"t": "B",
"m": "stuff.obj",
"p": "",
"s": 20,
"lead": "",
"k": []
},
{
"a": 19036,
"n": "wait_for_keypress",
"t": "R",
"m": "shared-game-band",
"p": "",
"s": 36,
"lead": "",
"k": []
},
{
"a": 19072,
"n": "shared_game_band_004A80",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 26,
"lead": "",
"k": []
},
{
"a": 19194,
"n": "drain_keyboard_buffer",
"t": "R",
"m": "shared-game-band",
"p": "",
"s": 28,
"lead": "",
"k": []
},
{
"a": 19222,
"n": "shared_game_band_004B16",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 46,
"lead": "",
"k": []
},
{
"a": 19272,
"n": "shared_game_band_004B48",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 25,
"lead": "",
"k": []
},
{
"a": 19314,
"n": "shared_game_band_004B72",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 427,
"lead": "",
"k": []
},
{
"a": 19742,
"n": "shared_game_band_004D1E",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 217,
"lead": "",
"k": []
},
{
"a": 19960,
"n": "shared_game_band_004DF8",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 126,
"lead": "",
"k": []
},
{
"a": 20198,
"n": "shared_game_band_004EE6",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 297,
"lead": "",
"k": []
},
{
"a": 20668,
"n": "shared_game_band_0050BC",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 51,
"lead": "",
"k": []
},
{
"a": 20720,
"n": "shared_game_band_0050F0",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 11,
"lead": "",
"k": []
},
{
"a": 20732,
"n": "shared_game_band_0050FC",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 11,
"lead": "",
"k": []
},
{
"a": 20744,
"n": "shared_game_band_005108",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 51,
"lead": "",
"k": []
},
{
"a": 20796,
"n": "shared_game_band_00513C",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 26,
"lead": "",
"k": []
},
{
"a": 20832,
"n": "shared_game_band_005160",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 45,
"lead": "",
"k": []
},
{
"a": 20946,
"n": "shared_game_band_0051D2",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 62,
"lead": "",
"k": []
},
{
"a": 21044,
"n": "shared_game_band_005234",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 62,
"lead": "",
"k": []
},
{
"a": 21142,
"n": "shared_game_band_005296",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 22,
"lead": "",
"k": []
},
{
"a": 21276,
"n": "shared_game_band_00531C",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 89,
"lead": "",
"k": []
},
{
"a": 21470,
"n": "shared_game_band_0053DE",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 44,
"lead": "",
"k": []
},
{
"a": 21528,
"n": "shared_game_band_005418",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 30,
"lead": "",
"k": []
},
{
"a": 21564,
"n": "shared_game_band_00543C",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 131,
"lead": "",
"k": []
},
{
"a": 21722,
"n": "shared_game_band_0054DA",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 42,
"lead": "",
"k": []
},
{
"a": 22126,
"n": "shared_game_band_00566E",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 132,
"lead": "",
"k": []
},
{
"a": 22258,
"n": "shared_game_band_0056F2",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 109,
"lead": "",
"k": []
},
{
"a": 22368,
"n": "shared_game_band_005760",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 127,
"lead": "",
"k": []
},
{
"a": 23546,
"n": "_on_map",
"t": "B",
"m": "map.obj",
"p": "",
"s": 49,
"lead": "",
"k": []
},
{
"a": 23596,
"n": "_on_colony_map",
"t": "B",
"m": "map.obj",
"p": "",
"s": 132,
"lead": "",
"k": []
},
{
"a": 23728,
"n": "map_obj_005CB0",
"t": "M",
"m": "map.obj",
"p": "",
"s": 54,
"lead": "",
"k": []
},
{
"a": 23782,
"n": "map_obj_005CE6",
"t": "M",
"m": "map.obj",
"p": "",
"s": 24,
"lead": "_map_loc",
"k": []
},
{
"a": 23806,
"n": "map_tile_read_layer_15C",
"t": "R",
"m": "map.obj",
"p": "",
"s": 28,
"lead": "_map_get",
"k": []
},
{
"a": 23834,
"n": "map_obj_005D1A",
"t": "M",
"m": "map.obj",
"p": "",
"s": 23,
"lead": "",
"k": []
},
{
"a": 23858,
"n": "map_tile_read_layer_160",
"t": "R",
"m": "map.obj",
"p": "",
"s": 28,
"lead": "_feature_get",
"k": []
},
{
"a": 23886,
"n": "_feature_set",
"t": "B",
"m": "map.obj",
"p": "",
"s": 40,
"lead": "",
"k": []
},
{
"a": 23940,
"n": "map_obj_005D84",
"t": "M",
"m": "map.obj",
"p": "",
"s": 23,
"lead": "_continent_loc",
"k": []
},
{
"a": 23964,
"n": "map_obj_005D9C",
"t": "M",
"m": "map.obj",
"p": "",
"s": 29,
"lead": "_continent_get",
"k": []
},
{
"a": 23994,
"n": "map_obj_005DBA",
"t": "M",
"m": "map.obj",
"p": "",
"s": 17,
"lead": "_continent_at",
"k": []
},
{
"a": 24012,
"n": "map_obj_005DCC",
"t": "M",
"m": "map.obj",
"p": "",
"s": 36,
"lead": "_continent_set",
"k": []
},
{
"a": 24048,
"n": "map_obj_005DF0",
"t": "M",
"m": "map.obj",
"p": "",
"s": 40,
"lead": "_owner_of",
"k": []
},
{
"a": 24088,
"n": "map_obj_005E18",
"t": "M",
"m": "map.obj",
"p": "",
"s": 120,
"lead": "",
"k": []
},
{
"a": 24208,
"n": "map_obj_005E90",
"t": "M",
"m": "map.obj",
"p": "",
"s": 64,
"lead": "",
"k": []
},
{
"a": 24272,
"n": "map_obj_005ED0",
"t": "M",
"m": "map.obj",
"p": "",
"s": 23,
"lead": "",
"k": []
},
{
"a": 24296,
"n": "map_obj_005EE8",
"t": "M",
"m": "map.obj",
"p": "",
"s": 28,
"lead": "_site_get",
"k": []
},
{
"a": 24324,
"n": "map_xy_bounds_or_neg1",
"t": "R",
"m": "map.obj",
"p": "",
"s": 31,
"lead": "",
"k": []
},
{
"a": 24392,
"n": "map_obj_005F48",
"t": "M",
"m": "map.obj",
"p": "",
"s": 58,
"lead": "",
"k": []
},
{
"a": 24450,
"n": "map_obj_005F82",
"t": "M",
"m": "map.obj",
"p": "",
"s": 31,
"lead": "",
"k": []
},
{
"a": 24532,
"n": "map_xy_bounds_or_neg1_alt",
"t": "R",
"m": "map.obj",
"p": "",
"s": 31,
"lead": "",
"k": []
},
{
"a": 24600,
"n": "map_obj_006018",
"t": "M",
"m": "map.obj",
"p": "",
"s": 33,
"lead": "_is_anything",
"k": []
},
{
"a": 24634,
"n": "map_obj_00603A",
"t": "M",
"m": "map.obj",
"p": "",
"s": 33,
"lead": "",
"k": []
},
{
"a": 24736,
"n": "tile_terrain_variant_hash",
"t": "R",
"m": "map.obj",
"p": "",
"s": 128,
"lead": "_resource_at",
"k": []
},
{
"a": 24968,
"n": "map_obj_006188",
"t": "M",
"m": "map.obj",
"p": "",
"s": 91,
"lead": "",
"k": []
},
{
"a": 25092,
"n": "_terrain_fix_2",
"t": "B",
"m": "map.obj",
"p": "",
"s": 46,
"lead": "",
"k": []
},
{
"a": 25166,
"n": "_terrain_type",
"t": "B",
"m": "terrain.obj",
"p": "",
"s": 8,
"lead": "",
"k": []
},
{
"a": 25210,
"n": "resident__unattributed_00627A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 57,
"lead": "",
"k": []
},
{
"a": 25268,
"n": "is_tile_walkable_or_special",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 39,
"lead": "",
"k": []
},
{
"a": 25314,
"n": "resident__unattributed_0062E2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 50,
"lead": "",
"k": []
},
{
"a": 25370,
"n": "resident__unattributed_00631A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 25,
"lead": "",
"k": []
},
{
"a": 25526,
"n": "resident__unattributed_0063B6",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 14,
"lead": "",
"k": []
},
{
"a": 25557,
"n": "resident__unattributed_0063D5",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 69,
"lead": "",
"k": []
},
{
"a": 25704,
"n": "resident__unattributed_006468",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 79,
"lead": "",
"k": []
},
{
"a": 26052,
"n": "resident__unattributed_0065C4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 67,
"lead": "",
"k": []
},
{
"a": 26120,
"n": "resident__unattributed_006608",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 106,
"lead": "",
"k": []
},
{
"a": 26226,
"n": "unit_chain_resolve",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 35,
"lead": "",
"k": []
},
{
"a": 26298,
"n": "unit_field_lookup_simple",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 18,
"lead": "",
"k": []
},
{
"a": 26316,
"n": "resident__unattributed_0066CC",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 57,
"lead": "",
"k": []
},
{
"a": 26526,
"n": "resident__unattributed_00679E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 16,
"lead": "",
"k": []
},
{
"a": 26608,
"n": "resident__unattributed_0067F0",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 44,
"lead": "",
"k": []
},
{
"a": 26700,
"n": "resident__unattributed_00684C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 39,
"lead": "",
"k": []
},
{
"a": 26740,
"n": "resident__unattributed_006874",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 53,
"lead": "",
"k": []
},
{
"a": 26794,
"n": "resident__unattributed_0068AA",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 143,
"lead": "",
"k": []
},
{
"a": 26938,
"n": "resident__unattributed_00693A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 14,
"lead": "",
"k": []
},
{
"a": 27090,
"n": "resident__unattributed_0069D2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 12,
"lead": "",
"k": []
},
{
"a": 27118,
"n": "resident__unattributed_0069EE",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 33,
"lead": "",
"k": []
},
{
"a": 27152,
"n": "resident__unattributed_006A10",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 108,
"lead": "",
"k": []
},
{
"a": 27260,
"n": "resident__unattributed_006A7C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 50,
"lead": "",
"k": []
},
{
"a": 27310,
"n": "resident__unattributed_006AAE",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 103,
"lead": "",
"k": []
},
{
"a": 27462,
"n": "resident__unattributed_006B46",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 71,
"lead": "",
"k": []
},
{
"a": 27850,
"n": "unit_table_offset_calc",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 13,
"lead": "",
"k": []
},
{
"a": 27940,
"n": "resident__unattributed_006D24",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 197,
"lead": "",
"k": []
},
{
"a": 28308,
"n": "resident__unattributed_006E94",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 132,
"lead": "",
"k": []
},
{
"a": 28506,
"n": "resident__unattributed_006F5A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 105,
"lead": "",
"k": []
},
{
"a": 28612,
"n": "resident__unattributed_006FC4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 20,
"lead": "",
"k": []
},
{
"a": 28632,
"n": "resident__unattributed_006FD8",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 42,
"lead": "",
"k": []
},
{
"a": 28674,
"n": "resident__unattributed_007002",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 26,
"lead": "",
"k": []
},
{
"a": 28700,
"n": "resident__unattributed_00701C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 48,
"lead": "",
"k": []
},
{
"a": 28748,
"n": "resident__unattributed_00704C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 205,
"lead": "",
"k": []
},
{
"a": 28960,
"n": "resident__unattributed_007120",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 69,
"lead": "",
"k": []
},
{
"a": 29048,
"n": "resident__unattributed_007178",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 192,
"lead": "",
"k": []
},
{
"a": 29246,
"n": "resident__unattributed_00723E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 48,
"lead": "",
"k": []
},
{
"a": 29294,
"n": "resident__unattributed_00726E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 116,
"lead": "",
"k": []
},
{
"a": 29410,
"n": "resident__unattributed_0072E2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 40,
"lead": "",
"k": []
},
{
"a": 29450,
"n": "resident__unattributed_00730A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 75,
"lead": "",
"k": []
},
{
"a": 29526,
"n": "resident__unattributed_007356",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 56,
"lead": "",
"k": []
},
{
"a": 29582,
"n": "resident__unattributed_00738E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 26,
"lead": "",
"k": []
},
{
"a": 29608,
"n": "resident__unattributed_0073A8",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 99,
"lead": "",
"k": []
},
{
"a": 30078,
"n": "resident__unattributed_00757E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 33,
"lead": "",
"k": []
},
{
"a": 30112,
"n": "resident__unattributed_0075A0",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 51,
"lead": "",
"k": []
},
{
"a": 30164,
"n": "resident__unattributed_0075D4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 16,
"lead": "",
"k": []
},
{
"a": 30180,
"n": "resident__unattributed_0075E4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 26,
"lead": "",
"k": []
},
{
"a": 30206,
"n": "resident__unattributed_0075FE",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 17,
"lead": "",
"k": []
},
{
"a": 30224,
"n": "resident__unattributed_007610",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 31,
"lead": "",
"k": []
},
{
"a": 30256,
"n": "resident__unattributed_007630",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 37,
"lead": "",
"k": []
},
{
"a": 30300,
"n": "resident__unattributed_00765C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 42,
"lead": "",
"k": []
},
{
"a": 30348,
"n": "resident__unattributed_00768C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 161,
"lead": "",
"k": []
},
{
"a": 30510,
"n": "resident__unattributed_00772E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 149,
"lead": "",
"k": []
},
{
"a": 30964,
"n": "resident__unattributed_0078F4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 66,
"lead": "",
"k": []
},
{
"a": 31030,
"n": "resident__unattributed_007936",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 48,
"lead": "",
"k": []
},
{
"a": 31078,
"n": "resident__unattributed_007966",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 41,
"lead": "",
"k": []
},
{
"a": 31136,
"n": "resident__unattributed_0079A0",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 119,
"lead": "",
"k": []
},
{
"a": 31264,
"n": "resident__unattributed_007A20",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 83,
"lead": "",
"k": []
},
{
"a": 31360,
"n": "resident__unattributed_007A80",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 143,
"lead": "",
"k": []
},
{
"a": 31504,
"n": "resident__unattributed_007B10",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 76,
"lead": "",
"k": []
},
{
"a": 31588,
"n": "resident__unattributed_007B64",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 105,
"lead": "",
"k": []
},
{
"a": 31694,
"n": "resident__unattributed_007BCE",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 25,
"lead": "",
"k": []
},
{
"a": 31720,
"n": "resident__unattributed_007BE8",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 66,
"lead": "",
"k": []
},
{
"a": 31786,
"n": "resident__unattributed_007C2A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 46,
"lead": "",
"k": []
},
{
"a": 32062,
"n": "combat_terrain_fort_bonus_fill",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 502,
"lead": "",
"k": []
},
{
"a": 32564,
"n": "resident__unattributed_007F34",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 27,
"lead": "",
"k": []
},
{
"a": 32610,
"n": "resident__unattributed_007F62",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 30,
"lead": "",
"k": []
},
{
"a": 32662,
"n": "resident__unattributed_007F96",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 105,
"lead": "",
"k": []
},
{
"a": 32768,
"n": "resident__unattributed_008000",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 115,
"lead": "",
"k": []
},
{
"a": 32884,
"n": "resident__unattributed_008074",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 83,
"lead": "",
"k": []
},
{
"a": 32968,
"n": "resident__unattributed_0080C8",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 14,
"lead": "",
"k": []
},
{
"a": 33040,
"n": "resident__unattributed_008110",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 14,
"lead": "",
"k": []
},
{
"a": 33112,
"n": "resident__unattributed_008158",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 14,
"lead": "",
"k": []
},
{
"a": 33150,
"n": "resident__unattributed_00817E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 14,
"lead": "",
"k": []
},
{
"a": 33188,
"n": "resident__unattributed_0081A4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 28,
"lead": "",
"k": []
},
{
"a": 33222,
"n": "resident__unattributed_0081C6",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 44,
"lead": "",
"k": []
},
{
"a": 33266,
"n": "resident__unattributed_0081F2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 34,
"lead": "",
"k": []
},
{
"a": 33322,
"n": "resident__unattributed_00822A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 36,
"lead": "",
"k": []
},
{
"a": 33378,
"n": "resident__unattributed_008262",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 20,
"lead": "",
"k": []
},
{
"a": 33440,
"n": "resident__unattributed_0082A0",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 18,
"lead": "",
"k": []
},
{
"a": 33458,
"n": "resident__unattributed_0082B2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 38,
"lead": "",
"k": []
},
{
"a": 33500,
"n": "resident__unattributed_0082DC",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 44,
"lead": "",
"k": []
},
{
"a": 33618,
"n": "resident__unattributed_008352",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 92,
"lead": "",
"k": []
},
{
"a": 33778,
"n": "resident__unattributed_0083F2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 71,
"lead": "",
"k": []
},
{
"a": 33992,
"n": "resident__unattributed_0084C8",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 19,
"lead": "",
"k": []
},
{
"a": 34012,
"n": "resident__unattributed_0084DC",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 21,
"lead": "",
"k": []
},
{
"a": 34034,
"n": "resident__unattributed_0084F2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 21,
"lead": "",
"k": []
},
{
"a": 34056,
"n": "resident__unattributed_008508",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 9,
"lead": "",
"k": []
},
{
"a": 34084,
"n": "resident__unattributed_008524",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 18,
"lead": "",
"k": []
},
{
"a": 34226,
"n": "test_bit_at_8a",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 34,
"lead": "",
"k": []
},
{
"a": 34262,
"n": "set_or_clear_bit_at_8a",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 56,
"lead": "",
"k": []
},
{
"a": 34318,
"n": "resident__unattributed_00860E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 15,
"lead": "",
"k": []
},
{
"a": 34366,
"n": "wrapper_with_global_8DC6",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 15,
"lead": "",
"k": []
},
{
"a": 34382,
"n": "resident__unattributed_00864E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 31,
"lead": "",
"k": []
},
{
"a": 34438,
"n": "resident__unattributed_008686",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 34,
"lead": "",
"k": []
},
{
"a": 34496,
"n": "resident__unattributed_0086C0",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 19,
"lead": "",
"k": []
},
{
"a": 34532,
"n": "resident__unattributed_0086E4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 34,
"lead": "",
"k": []
},
{
"a": 34612,
"n": "resident__unattributed_008734",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 30,
"lead": "",
"k": []
},
{
"a": 34672,
"n": "resident__unattributed_008770",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 132,
"lead": "",
"k": []
},
{
"a": 34804,
"n": "power_record_read_dword",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 18,
"lead": "",
"k": []
},
{
"a": 34822,
"n": "resident__unattributed_008806",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 63,
"lead": "",
"k": []
},
{
"a": 34886,
"n": "resident__unattributed_008846",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 27,
"lead": "",
"k": []
},
{
"a": 34914,
"n": "resident__unattributed_008862",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 25,
"lead": "",
"k": []
},
{
"a": 34940,
"n": "resident__unattributed_00887C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 21,
"lead": "",
"k": []
},
{
"a": 34962,
"n": "find_pair_in_table_C8_DE",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 62,
"lead": "",
"k": []
},
{
"a": 35024,
"n": "resident__unattributed_0088D0",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 71,
"lead": "",
"k": []
},
{
"a": 35096,
"n": "blit_at_origin_if_pair_visible",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 62,
"lead": "",
"k": []
},
{
"a": 35158,
"n": "lookup_byte_from_pair",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 44,
"lead": "",
"k": []
},
{
"a": 35202,
"n": "resident__unattributed_008982",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 532,
"lead": "",
"k": []
},
{
"a": 35734,
"n": "unit_field_test_at_3146",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 24,
"lead": "",
"k": []
},
{
"a": 35762,
"n": "resident__unattributed_008BB2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 20,
"lead": "",
"k": []
},
{
"a": 35782,
"n": "resident__unattributed_008BC6",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 13,
"lead": "",
"k": []
},
{
"a": 35796,
"n": "resident__unattributed_008BD4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 73,
"lead": "",
"k": []
},
{
"a": 35870,
"n": "resident__unattributed_008C1E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 81,
"lead": "",
"k": []
},
{
"a": 35952,
"n": "resident__unattributed_008C70",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 66,
"lead": "",
"k": []
},
{
"a": 36096,
"n": "step_100_or_level_scaled",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 38,
"lead": "",
"k": []
},
{
"a": 36134,
"n": "resident__unattributed_008D26",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 69,
"lead": "",
"k": []
},
{
"a": 36252,
"n": "lookup_table_2F4_signed",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 31,
"lead": "",
"k": []
},
{
"a": 36284,
"n": "resident__unattributed_008DBC",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 69,
"lead": "",
"k": []
},
{
"a": 36354,
"n": "set_commodity_band_at_index",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 68,
"lead": "",
"k": []
},
{
"a": 36422,
"n": "dispatch_via_8e02_with_band",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 61,
"lead": "",
"k": []
},
{
"a": 36484,
"n": "resident__unattributed_008E84",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 120,
"lead": "",
"k": []
},
{
"a": 36610,
"n": "check_total_exceeds_threshold",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 33,
"lead": "",
"k": []
},
{
"a": 36650,
"n": "unpack_nibble_at_60",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 53,
"lead": "",
"k": []
},
{
"a": 36716,
"n": "pack_nibble_at_60",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 72,
"lead": "",
"k": []
},
{
"a": 36788,
"n": "resident__unattributed_008FB4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 138,
"lead": "",
"k": []
},
{
"a": 36926,
"n": "resident__unattributed_00903E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 37,
"lead": "",
"k": []
},
{
"a": 37064,
"n": "current_unit_field_at_20",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 29,
"lead": "",
"k": []
},
{
"a": 37122,
"n": "current_unit_field_at_40",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 29,
"lead": "",
"k": []
},
{
"a": 37180,
"n": "set_field_at_40_or_unit_byte",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 72,
"lead": "",
"k": []
},
{
"a": 37252,
"n": "nibble_to_4_tier_quantity",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 72,
"lead": "",
"k": []
},
{
"a": 37324,
"n": "resident__unattributed_0091CC",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 181,
"lead": "",
"k": []
},
{
"a": 37530,
"n": "classify_pair_bounds",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 70,
"lead": "",
"k": []
},
{
"a": 37600,
"n": "colony_flag_bit_set",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 44,
"lead": "",
"k": []
},
{
"a": 37656,
"n": "colony_production_accumulate",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 782,
"lead": "",
"k": []
},
{
"a": 38438,
"n": "colony_leaf_calls_90c8",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 53,
"lead": "",
"k": []
},
{
"a": 38492,
"n": "colony_leaf_calls_9102",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 53,
"lead": "",
"k": []
},
{
"a": 38546,
"n": "colony_leaf_90c8_9102",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 67,
"lead": "",
"k": []
},
{
"a": 38618,
"n": "colony_leaf_activecol",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 75,
"lead": "",
"k": []
},
{
"a": 38694,
"n": "resident__unattributed_009726",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 52,
"lead": "",
"k": []
},
{
"a": 38746,
"n": "resident__unattributed_00975A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 25,
"lead": "",
"k": []
},
{
"a": 38790,
"n": "resident__unattributed_009786",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 12,
"lead": "",
"k": []
},
{
"a": 38804,
"n": "resident__unattributed_009794",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 39,
"lead": "",
"k": []
},
{
"a": 38870,
"n": "resident__unattributed_0097D6",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 28,
"lead": "",
"k": []
},
{
"a": 38936,
"n": "resident__unattributed_009818",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 66,
"lead": "",
"k": []
},
{
"a": 39030,
"n": "resident__unattributed_009876",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 62,
"lead": "",
"k": []
},
{
"a": 39092,
"n": "resident__unattributed_0098B4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 65,
"lead": "",
"k": []
},
{
"a": 39158,
"n": "resident__unattributed_0098F6",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 85,
"lead": "",
"k": []
},
{
"a": 39244,
"n": "resident__unattributed_00994C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 40,
"lead": "",
"k": []
},
{
"a": 39284,
"n": "resident__unattributed_009974",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 18,
"lead": "",
"k": []
},
{
"a": 39342,
"n": "resident__unattributed_0099AE",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 63,
"lead": "",
"k": []
},
{
"a": 39406,
"n": "resident__unattributed_0099EE",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 67,
"lead": "",
"k": []
},
{
"a": 39474,
"n": "resident__unattributed_009A32",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 56,
"lead": "",
"k": []
},
{
"a": 39530,
"n": "resident__unattributed_009A6A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 63,
"lead": "",
"k": []
},
{
"a": 39594,
"n": "resident__unattributed_009AAA",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 241,
"lead": "",
"k": []
},
{
"a": 39836,
"n": "resident__unattributed_009B9C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 1120,
"lead": "",
"k": []
},
{
"a": 40956,
"n": "resident__unattributed_009FFC",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 550,
"lead": "",
"k": []
},
{
"a": 41506,
"n": "resident__unattributed_00A222",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 447,
"lead": "",
"k": []
},
{
"a": 41953,
"n": "resident__unattributed_00A3E1",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 705,
"lead": "",
"k": []
},
{
"a": 42658,
"n": "resident__unattributed_00A6A2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 130,
"lead": "",
"k": []
},
{
"a": 43326,
"n": "resident__unattributed_00A93E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 86,
"lead": "",
"k": []
},
{
"a": 43412,
"n": "resident__unattributed_00A994",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 293,
"lead": "",
"k": []
},
{
"a": 43822,
"n": "resident__unattributed_00AB2E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 73,
"lead": "",
"k": []
},
{
"a": 43896,
"n": "resident__unattributed_00AB78",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 29,
"lead": "",
"k": []
},
{
"a": 43925,
"n": "resident__unattributed_00AB95",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 78,
"lead": "",
"k": []
},
{
"a": 45392,
"n": "colony_update_step",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 155,
"lead": "",
"k": []
},
{
"a": 45548,
"n": "resident__unattributed_00B1EC",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 42,
"lead": "",
"k": []
},
{
"a": 45630,
"n": "resident__unattributed_00B23E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 46,
"lead": "",
"k": []
},
{
"a": 45730,
"n": "resident__unattributed_00B2A2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 31,
"lead": "",
"k": []
},
{
"a": 45808,
"n": "unit_table_3154_byte",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 20,
"lead": "",
"k": []
},
{
"a": 45828,
"n": "resident__unattributed_00B304",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 21,
"lead": "",
"k": []
},
{
"a": 45850,
"n": "resident__unattributed_00B31A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 77,
"lead": "",
"k": []
},
{
"a": 45928,
"n": "colony_helper_b2a2",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 126,
"lead": "",
"k": []
},
{
"a": 46124,
"n": "resident__unattributed_00B42C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 139,
"lead": "",
"k": []
},
{
"a": 46264,
"n": "resident__unattributed_00B4B8",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 11,
"lead": "",
"k": []
},
{
"a": 46416,
"n": "resident__unattributed_00B550",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 88,
"lead": "",
"k": []
},
{
"a": 46504,
"n": "resident__unattributed_00B5A8",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 82,
"lead": "",
"k": []
},
{
"a": 46586,
"n": "resident__unattributed_00B5FA",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 47,
"lead": "",
"k": []
},
{
"a": 46682,
"n": "resident__unattributed_00B65A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 39,
"lead": "",
"k": []
},
{
"a": 46852,
"n": "resident__unattributed_00B704",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 41,
"lead": "",
"k": []
},
{
"a": 47232,
"n": "colony_helper_8dc4_a",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 80,
"lead": "",
"k": []
},
{
"a": 47312,
"n": "colony_helper_8dc4_b",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 47,
"lead": "",
"k": []
},
{
"a": 47360,
"n": "resident__unattributed_00B900",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 57,
"lead": "",
"k": []
},
{
"a": 47978,
"n": "resident__unattributed_00BB6A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 45,
"lead": "",
"k": []
},
{
"a": 48024,
"n": "resident__unattributed_00BB98",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 71,
"lead": "",
"k": []
},
{
"a": 48144,
"n": "is_arg2_negative",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 16,
"lead": "",
"k": []
},
{
"a": 48206,
"n": "resident__unattributed_00BC4E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 50,
"lead": "",
"k": []
},
{
"a": 48256,
"n": "resident__unattributed_00BC80",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 41,
"lead": "",
"k": []
},
{
"a": 48298,
"n": "resident__unattributed_00BCAA",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 64,
"lead": "",
"k": []
},
{
"a": 48362,
"n": "resident__unattributed_00BCEA",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 61,
"lead": "",
"k": []
},
{
"a": 48424,
"n": "resident__unattributed_00BD28",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 34,
"lead": "",
"k": []
},
{
"a": 48458,
"n": "resident__unattributed_00BD4A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 221,
"lead": "",
"k": []
},
{
"a": 48862,
"n": "resident__unattributed_00BEDE",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 93,
"lead": "",
"k": []
},
{
"a": 48956,
"n": "resident__unattributed_00BF3C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 182,
"lead": "",
"k": []
},
{
"a": 49138,
"n": "resident__unattributed_00BFF2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 23,
"lead": "",
"k": []
},
{
"a": 49162,
"n": "resident__unattributed_00C00A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 112,
"lead": "",
"k": []
},
{
"a": 49274,
"n": "resident__unattributed_00C07A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 32,
"lead": "",
"k": []
},
{
"a": 49306,
"n": "resident__unattributed_00C09A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 19,
"lead": "",
"k": []
},
{
"a": 49326,
"n": "resident__unattributed_00C0AE",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 34,
"lead": "",
"k": []
},
{
"a": 49360,
"n": "resident__unattributed_00C0D0",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 57,
"lead": "",
"k": []
},
{
"a": 49530,
"n": "resident__unattributed_00C17A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 20,
"lead": "",
"k": []
},
{
"a": 49656,
"n": "resident__unattributed_00C1F8",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 20,
"lead": "",
"k": []
},
{
"a": 49782,
"n": "resident__unattributed_00C276",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 20,
"lead": "",
"k": []
},
{
"a": 49930,
"n": "resident__unattributed_00C30A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 17,
"lead": "",
"k": []
},
{
"a": 49954,
"n": "resident__unattributed_00C322",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 63,
"lead": "",
"k": []
},
{
"a": 50018,
"n": "env_1_obj_00C362",
"t": "M",
"m": "env_1.obj",
"p": "",
"s": 173,
"lead": "@env_catint",
"k": []
},
{
"a": 50192,
"n": "env_1_obj_00C410",
"t": "M",
"m": "env_1.obj",
"p": "",
"s": 73,
"lead": "_env_get_path",
"k": []
},
{
"a": 50266,
"n": "resident__unattributed_00C45A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 44,
"lead": "",
"k": []
},
{
"a": 50328,
"n": "resident__unattributed_00C498",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 11,
"lead": "",
"k": []
},
{
"a": 50340,
"n": "resident__unattributed_00C4A4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 55,
"lead": "",
"k": []
},
{
"a": 50458,
"n": "resident__unattributed_00C51A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 205,
"lead": "",
"k": []
},
{
"a": 50758,
"n": "resident__unattributed_00C646",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 74,
"lead": "",
"k": []
},
{
"a": 51167,
"n": "timer_3_ASM_00C7DF",
"t": "M",
"m": "timer_3.ASM",
"p": "",
"s": 12,
"lead": "_TIMER_SET_COPY_PROTECT",
"k": []
},
{
"a": 51353,
"n": "timer_3_ASM_00C899",
"t": "M",
"m": "timer_3.ASM",
"p": "",
"s": 18,
"lead": "_TIMER_SET_SOUND_FLAG",
"k": []
},
{
"a": 51371,
"n": "_TIMER_ACTIVATE_LOW_PRIORITY",
"t": "B",
"m": "timer_3.ASM",
"p": "",
"s": 48,
"lead": "",
"k": []
},
{
"a": 51452,
"n": "at_buffer_conform",
"t": "B",
"m": "buffer_i.c",
"p": "",
"s": 88,
"lead": "",
"k": []
},
{
"a": 51724,
"n": "engine_band_00CA0C",
"t": "M",
"m": "engine-band",
"p": "",
"s": 74,
"lead": "",
"k": []
},
{
"a": 52057,
"n": "mouse_1_ASM_00CB59",
"t": "M",
"m": "mouse_1.ASM",
"p": "",
"s": 25,
"lead": "_MOUSE_SET_HOTSPOT",
"k": []
},
{
"a": 52367,
"n": "engine_band_00CC8F",
"t": "M",
"m": "engine-band",
"p": "",
"s": 92,
"lead": "",
"k": []
},
{
"a": 52491,
"n": "_mouse_get_status",
"t": "B",
"m": "mouse_1.ASM",
"p": "",
"s": 67,
"lead": "",
"k": []
},
{
"a": 52943,
"n": "mouse_1_ASM_00CECF",
"t": "M",
"m": "mouse_1.ASM",
"p": "",
"s": 25,
"lead": "_mouse_set_work_buffer",
"k": []
},
{
"a": 52968,
"n": "engine_band_00CEE8",
"t": "M",
"m": "engine-band",
"p": "",
"s": 42,
"lead": "",
"k": []
},
{
"a": 53017,
"n": "mouse_1_ASM_00CF19",
"t": "M",
"m": "mouse_1.ASM",
"p": "",
"s": 25,
"lead": "_mouse_set_view_port",
"k": []
},
{
"a": 53054,
"n": "mouse_1_ASM_00CF3E",
"t": "M",
"m": "mouse_1.ASM",
"p": "",
"s": 134,
"lead": "_mouse_refresh_view_port",
"k": []
},
{
"a": 53430,
"n": "at_mouse_in_box",
"t": "B",
"m": "mouse_2.c",
"p": "",
"s": 35,
"lead": "",
"k": []
},
{
"a": 53510,
"n": "engine_band_00D106",
"t": "M",
"m": "engine-band",
"p": "",
"s": 158,
"lead": "",
"k": []
},
{
"a": 53706,
"n": "engine_band_00D1CA",
"t": "M",
"m": "engine-band",
"p": "",
"s": 26,
"lead": "",
"k": []
},
{
"a": 53732,
"n": "engine_band_00D1E4",
"t": "M",
"m": "engine-band",
"p": "",
"s": 52,
"lead": "",
"k": []
},
{
"a": 53874,
"n": "kbhit",
"t": "R",
"m": "KEYS_1.C",
"p": "",
"s": 13,
"lead": "@keys_any",
"k": []
},
{
"a": 53894,
"n": "getch",
"t": "R",
"m": "KEYS_1.C",
"p": "",
"s": 15,
"lead": "@keys_get",
"k": []
},
{
"a": 53932,
"n": "engine_band_00D2AC",
"t": "M",
"m": "engine-band",
"p": "",
"s": 57,
"lead": "",
"k": []
},
{
"a": 54206,
"n": "engine_band_00D3BE",
"t": "M",
"m": "engine-band",
"p": "",
"s": 45,
"lead": "",
"k": []
},
{
"a": 54252,
"n": "engine_band_00D3EC",
"t": "M",
"m": "engine-band",
"p": "",
"s": 49,
"lead": "",
"k": []
},
{
"a": 54302,
"n": "fileio_8_c_00D41E",
"t": "M",
"m": "fileio_8.c",
"p": "",
"s": 29,
"lead": "@fileio_fread_f",
"k": []
},
{
"a": 54850,
"n": "fileio_c_ASM_00D642",
"t": "M",
"m": "fileio_c.ASM",
"p": "",
"s": 129,
"lead": "_fileio_exist",
"k": []
},
{
"a": 54980,
"n": "engine_band_00D6C4",
"t": "M",
"m": "engine-band",
"p": "",
"s": 59,
"lead": "",
"k": []
},
{
"a": 55040,
"n": "engine_band_00D700",
"t": "M",
"m": "engine-band",
"p": "",
"s": 46,
"lead": "",
"k": []
},
{
"a": 55086,
"n": "engine_band_00D72E",
"t": "M",
"m": "engine-band",
"p": "",
"s": 77,
"lead": "",
"k": []
},
{
"a": 55164,
"n": "engine_band_00D77C",
"t": "M",
"m": "engine-band",
"p": "",
"s": 26,
"lead": "",
"k": []
},
{
"a": 55284,
"n": "engine_band_00D7F4",
"t": "M",
"m": "engine-band",
"p": "",
"s": 105,
"lead": "",
"k": []
},
{
"a": 55390,
"n": "engine_band_00D85E",
"t": "M",
"m": "engine-band",
"p": "",
"s": 134,
"lead": "",
"k": []
},
{
"a": 55524,
"n": "engine_band_00D8E4",
"t": "M",
"m": "engine-band",
"p": "",
"s": 141,
"lead": "",
"k": []
},
{
"a": 55666,
"n": "engine_band_00D972",
"t": "M",
"m": "engine-band",
"p": "",
"s": 23,
"lead": "",
"k": []
},
{
"a": 55776,
"n": "engine_band_00D9E0",
"t": "M",
"m": "engine-band",
"p": "",
"s": 111,
"lead": "",
"k": []
},
{
"a": 56122,
"n": "engine_band_00DB3A",
"t": "M",
"m": "engine-band",
"p": "",
"s": 69,
"lead": "",
"k": []
},
{
"a": 56192,
"n": "engine_band_00DB80",
"t": "M",
"m": "engine-band",
"p": "",
"s": 226,
"lead": "",
"k": []
},
{
"a": 56532,
"n": "engine_band_00DCD4",
"t": "M",
"m": "engine-band",
"p": "",
"s": 34,
"lead": "",
"k": []
},
{
"a": 56566,
"n": "buffer_4_c_00DCF6",
"t": "M",
"m": "buffer_4.c",
"p": "",
"s": 11,
"lead": "@buffer_rect_copy",
"k": []
},
{
"a": 56810,
"n": "engine_band_00DDEA",
"t": "M",
"m": "engine-band",
"p": "",
"s": 132,
"lead": "",
"k": []
},
{
"a": 56998,
"n": "buffer_6_c_00DEA6",
"t": "M",
"m": "buffer_6.c",
"p": "",
"s": 152,
"lead": "@buffer_rect_copy_2",
"k": []
},
{
"a": 57242,
"n": "engine_band_00DF9A",
"t": "M",
"m": "engine-band",
"p": "",
"s": 18,
"lead": "",
"k": []
},
{
"a": 57270,
"n": "engine_band_00DFB6",
"t": "M",
"m": "engine-band",
"p": "",
"s": 15,
"lead": "",
"k": []
},
{
"a": 57292,
"n": "at_buffer_hline",
"t": "B",
"m": "buffer_9.c",
"p": "",
"s": 39,
"lead": "",
"k": []
},
{
"a": 57398,
"n": "at_buffer_vline",
"t": "B",
"m": "buffer_a.c",
"p": "",
"s": 24,
"lead": "",
"k": []
},
{
"a": 57506,
"n": "buffer_b_c_00E0A2",
"t": "M",
"m": "buffer_b.c",
"p": "",
"s": 14,
"lead": "@buffer_draw_box",
"k": []
},
{
"a": 57670,
"n": "engine_band_00E146",
"t": "M",
"m": "engine-band",
"p": "",
"s": 97,
"lead": "",
"k": []
},
{
"a": 57810,
"n": "buffer_r_c_00E1D2",
"t": "M",
"m": "buffer_r.c",
"p": "",
"s": 221,
"lead": "@buffer_to_disk",
"k": []
},
{
"a": 58032,
"n": "engine_band_00E2B0",
"t": "M",
"m": "engine-band",
"p": "",
"s": 159,
"lead": "",
"k": []
},
{
"a": 58192,
"n": "buffer_z_c_00E350",
"t": "M",
"m": "buffer_z.c",
"p": "",
"s": 43,
"lead": "_buffer_tile",
"k": []
},
{
"a": 58452,
"n": "normalize_far_pointer",
"t": "R",
"m": "engine-band",
"p": "",
"s": 23,
"lead": "",
"k": []
},
{
"a": 58476,
"n": "engine_band_00E46C",
"t": "M",
"m": "engine-band",
"p": "",
"s": 48,
"lead": "",
"k": []
},
{
"a": 58566,
"n": "read_far_dword_via_267A",
"t": "R",
"m": "TIMER_1.C",
"p": "",
"s": 12,
"lead": "@timer_read",
"k": []
},
{
"a": 58632,
"n": "engine_band_00E508",
"t": "M",
"m": "engine-band",
"p": "",
"s": 20,
"lead": "",
"k": []
},
{
"a": 58652,
"n": "font_2_c_00E51C",
"t": "M",
"m": "font_2.c",
"p": "",
"s": 24,
"lead": "@font_write",
"k": []
},
{
"a": 59018,
"n": "set_global_269E_byte_pair",
"t": "R",
"m": "FONT_3.C",
"p": "",
"s": 15,
"lead": "@font_set_colors",
"k": []
},
{
"a": 59046,
"n": "font_4_c_00E6A6",
"t": "M",
"m": "font_4.c",
"p": "",
"s": 72,
"lead": "@font_string_width",
"k": []
},
{
"a": 59118,
"n": "mcga_b_c_00E6EE",
"t": "M",
"m": "mcga_b.c",
"p": "",
"s": 20,
"lead": "@mcga_retrace",
"k": []
},
{
"a": 59138,
"n": "at_mcga_setpal_range",
"t": "B",
"m": "mcga_b.c",
"p": "",
"s": 21,
"lead": "",
"k": []
},
{
"a": 59242,
"n": "engine_band_00E76A",
"t": "M",
"m": "engine-band",
"p": "",
"s": 49,
"lead": "",
"k": []
},
{
"a": 59495,
"n": "engine_band_00E867",
"t": "M",
"m": "engine-band",
"p": "",
"s": 15,
"lead": "",
"k": []
},
{
"a": 59748,
"n": "engine_band_00E964",
"t": "M",
"m": "engine-band",
"p": "",
"s": 54,
"lead": "",
"k": []
},
{
"a": 60126,
"n": "engine_band_00EADE",
"t": "M",
"m": "engine-band",
"p": "",
"s": 15,
"lead": "",
"k": []
},
{
"a": 60466,
"n": "engine_band_00EC32",
"t": "M",
"m": "engine-band",
"p": "",
"s": 100,
"lead": "",
"k": []
},
{
"a": 60566,
"n": "engine_band_00EC96",
"t": "M",
"m": "engine-band",
"p": "",
"s": 49,
"lead": "",
"k": []
},
{
"a": 60819,
"n": "engine_band_00ED93",
"t": "M",
"m": "engine-band",
"p": "",
"s": 15,
"lead": "",
"k": []
},
{
"a": 61092,
"n": "engine_band_00EEA4",
"t": "M",
"m": "engine-band",
"p": "",
"s": 54,
"lead": "",
"k": []
},
{
"a": 61470,
"n": "engine_band_00F01E",
"t": "M",
"m": "engine-band",
"p": "",
"s": 15,
"lead": "",
"k": []
},
{
"a": 61828,
"n": "engine_band_00F184",
"t": "M",
"m": "engine-band",
"p": "",
"s": 49,
"lead": "",
"k": []
},
{
"a": 62081,
"n": "engine_band_00F281",
"t": "M",
"m": "engine-band",
"p": "",
"s": 15,
"lead": "",
"k": []
},
{
"a": 62346,
"n": "engine_band_00F38A",
"t": "M",
"m": "engine-band",
"p": "",
"s": 46,
"lead": "",
"k": []
},
{
"a": 62544,
"n": "at_sort_insertion_8",
"t": "B",
"m": "sort_3.c",
"p": "",
"s": 44,
"lead": "",
"k": []
},
{
"a": 62736,
"n": "video_1_ASM_00F510",
"t": "M",
"m": "video_1.ASM",
"p": "",
"s": 28,
"lead": "_video_init",
"k": []
},
{
"a": 62764,
"n": "video_1_ASM_00F52C",
"t": "M",
"m": "video_1.ASM",
"p": "",
"s": 35,
"lead": "_video_update",
"k": []
},
{
"a": 62950,
"n": "resident__unattributed_00F5E6",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 68,
"lead": "",
"k": []
},
{
"a": 63234,
"n": "resident__unattributed_00F702",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 29,
"lead": "",
"k": []
},
{
"a": 63264,
"n": "dos_version_check_stub",
"t": "R",
"m": "dos\\crt0.asm",
"p": "",
"s": 13,
"lead": "__astart",
"k": []
},
{
"a": 63277,
"n": "cstart",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 182,
"lead": "",
"k": []
},
{
"a": 63709,
"n": "exit",
"t": "R",
"m": "125.obj",
"p": "",
"s": 7,
"lead": "_exit",
"k": []
},
{
"a": 63716,
"n": "exit_abort",
"t": "R",
"m": "125.obj",
"p": "",
"s": 8,
"lead": "__exit",
"k": []
},
{
"a": 63724,
"n": "f_125_obj_00F8EC",
"t": "M",
"m": "125.obj",
"p": "",
"s": 10,
"lead": "__cexit",
"k": []
},
{
"a": 63734,
"n": "f_125_obj_00F8F6",
"t": "M",
"m": "125.obj",
"p": "",
"s": 106,
"lead": "__c_exit",
"k": []
},
{
"a": 63940,
"n": "fclose_or_remove",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 186,
"lead": "",
"k": []
},
{
"a": 64126,
"n": "resident__unattributed_00FA7E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 43,
"lead": "",
"k": []
},
{
"a": 64170,
"n": "printf_to_str",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 21,
"lead": "",
"k": []
},
{
"a": 64192,
"n": "resident__unattributed_00FAC0",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 56,
"lead": "",
"k": []
},
{
"a": 64248,
"n": "resident__unattributed_00FAF8",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 135,
"lead": "",
"k": []
},
{
"a": 64476,
"n": "resident__unattributed_00FBDC",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 163,
"lead": "",
"k": []
},
{
"a": 64738,
"n": "resident__unattributed_00FCE2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 14,
"lead": "",
"k": []
},
{
"a": 64800,
"n": "putchar",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 8,
"lead": "",
"k": []
},
{
"a": 64808,
"n": "resident__unattributed_00FD28",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 37,
"lead": "",
"k": []
},
{
"a": 64846,
"n": "getchar",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 8,
"lead": "",
"k": []
},
{
"a": 64854,
"n": "resident__unattributed_00FD56",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 30,
"lead": "",
"k": []
},
{
"a": 64884,
"n": "_strcat",
"t": "B",
"m": "strcat.asm",
"p": "",
"s": 63,
"lead": "",
"k": []
},
{
"a": 64948,
"n": "_strcpy",
"t": "B",
"m": "strcpy.asm",
"p": "",
"s": 50,
"lead": "",
"k": []
},
{
"a": 64998,
"n": "_strcmp",
"t": "B",
"m": "strcmp.asm",
"p": "",
"s": 43,
"lead": "",
"k": []
},
{
"a": 65042,
"n": "strlen_near",
"t": "R",
"m": "strlen.asm",
"p": "",
"s": 27,
"lead": "_strlen",
"k": []
},
{
"a": 65070,
"n": "_strncat",
"t": "B",
"m": "strncat.asm",
"p": "",
"s": 51,
"lead": "",
"k": []
},
{
"a": 65124,
"n": "_strncpy",
"t": "B",
"m": "strncpy.asm",
"p": "",
"s": 34,
"lead": "",
"k": []
},
{
"a": 65164,
"n": "_strncmp",
"t": "B",
"m": "strncmp.asm",
"p": "",
"s": 27,
"lead": "",
"k": []
},
{
"a": 65226,
"n": "itoa_radix_dispatch",
"t": "R",
"m": "itoa.asm",
"p": "",
"s": 28,
"lead": "_itoa",
"k": []
},
{
"a": 65254,
"n": "ltoa_dispatch",
"t": "R",
"m": "runtime-band",
"p": "",
"s": 10,
"lead": "",
"k": []
},
{
"a": 65264,
"n": "runtime_band_00FEF0",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 11,
"lead": "",
"k": []
},
{
"a": 65276,
"n": "runtime_band_00FEFC",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 20,
"lead": "",
"k": []
},
{
"a": 65298,
"n": "runtime_band_00FF12",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 87,
"lead": "",
"k": []
},
{
"a": 65394,
"n": "runtime_band_00FF72",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 39,
"lead": "",
"k": []
},
{
"a": 65434,
"n": "_fgets",
"t": "B",
"m": "fgets.asm",
"p": "",
"s": 34,
"lead": "",
"k": []
},
{
"a": 65550,
"n": "fseek_c_01000E",
"t": "M",
"m": "fseek.c",
"p": "",
"s": 127,
"lead": "_fseek",
"k": []
},
{
"a": 65678,
"n": "runtime_band_01008E",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 26,
"lead": "",
"k": []
},
{
"a": 65704,
"n": "runtime_band_0100A8",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 33,
"lead": "",
"k": []
},
{
"a": 65772,
"n": "setbuf_c_0100EC",
"t": "M",
"m": "setbuf.c",
"p": "",
"s": 44,
"lead": "_setbuf",
"k": []
},
{
"a": 65816,
"n": "sprintf_c_010118",
"t": "M",
"m": "sprintf.c",
"p": "",
"s": 90,
"lead": "_sprintf",
"k": []
},
{
"a": 65906,
"n": "flength_c_010172",
"t": "M",
"m": "flength.c",
"p": "",
"s": 134,
"lead": "_filelength",
"k": []
},
{
"a": 66086,
"n": "_strchr",
"t": "B",
"m": "strchr.asm",
"p": "",
"s": 42,
"lead": "",
"k": []
},
{
"a": 66128,
"n": "runtime_band_010250",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 66,
"lead": "",
"k": []
},
{
"a": 66194,
"n": "_strnicmp",
"t": "B",
"m": "strnicmp.asm",
"p": "",
"s": 54,
"lead": "",
"k": []
},
{
"a": 66282,
"n": "runtime_band_0102EA",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 43,
"lead": "",
"k": []
},
{
"a": 66326,
"n": "runtime_band_010316",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 30,
"lead": "",
"k": []
},
{
"a": 66356,
"n": "runtime_band_010334",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 30,
"lead": "",
"k": []
},
{
"a": 66386,
"n": "_memcpy",
"t": "B",
"m": "memcpy.asm",
"p": "",
"s": 44,
"lead": "",
"k": []
},
{
"a": 66430,
"n": "memset_near",
"t": "R",
"m": "runtime-band",
"p": "",
"s": 45,
"lead": "",
"k": []
},
{
"a": 66476,
"n": "runtime_band_0103AC",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 22,
"lead": "",
"k": []
},
{
"a": 66498,
"n": "runtime_band_0103C2",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 17,
"lead": "",
"k": []
},
{
"a": 66556,
"n": "runtime_band_0103FC",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 29,
"lead": "",
"k": []
},
{
"a": 66586,
"n": "unlink",
"t": "R",
"m": "dos\\unlink.asm",
"p": "",
"s": 14,
"lead": "_unlink",
"k": []
},
{
"a": 66600,
"n": "dos_d_find_asm_010428",
"t": "M",
"m": "dos\\d_find.asm",
"p": "",
"s": 11,
"lead": "__dos_findnext",
"k": []
},
{
"a": 66611,
"n": "__dos_findfirst",
"t": "B",
"m": "dos\\d_find.asm",
"p": "",
"s": 79,
"lead": "",
"k": []
},
{
"a": 66662,
"n": "_read",
"t": "R",
"m": "dos\\d_rdwr.asm",
"p": "",
"s": 7,
"lead": "__dos_read",
"k": []
},
{
"a": 66669,
"n": "__dos_write",
"t": "B",
"m": "dos\\d_rdwr.asm",
"p": "",
"s": 5,
"lead": "",
"k": []
},
{
"a": 66710,
"n": "__aFldiv",
"t": "B",
"m": "ldiv.asm",
"p": "",
"s": 154,
"lead": "",
"k": []
},
{
"a": 66864,
"n": "__aFulmul",
"t": "B",
"m": "lmul.asm",
"p": "",
"s": 25,
"lead": "",
"k": []
},
{
"a": 66914,
"n": "runtime_band_010562",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 32,
"lead": "",
"k": []
},
{
"a": 66946,
"n": "__fmemcpy",
"t": "B",
"m": "hmemcpy.asm",
"p": "",
"s": 28,
"lead": "",
"k": []
},
{
"a": 67040,
"n": "__fstrchr",
"t": "B",
"m": "strchr.asm",
"p": "",
"s": 42,
"lead": "",
"k": []
},
{
"a": 67086,
"n": "__fstricmp",
"t": "B",
"m": "stricmp.asm",
"p": "",
"s": 69,
"lead": "",
"k": []
},
{
"a": 67156,
"n": "__fstrncmp",
"t": "B",
"m": "strncmp.asm",
"p": "",
"s": 26,
"lead": "",
"k": []
},
{
"a": 67216,
"n": "__fstrncpy",
"t": "B",
"m": "strncpy.asm",
"p": "",
"s": 33,
"lead": "",
"k": []
},
{
"a": 67258,
"n": "__fstrrchr",
"t": "B",
"m": "strrchr.asm",
"p": "",
"s": 42,
"lead": "",
"k": []
},
{
"a": 67304,
"n": "__fstrupr",
"t": "B",
"m": "strupr.asm",
"p": "",
"s": 36,
"lead": "",
"k": []
},
{
"a": 67340,
"n": "strlen_far",
"t": "R",
"m": "strlen.asm",
"p": "",
"s": 23,
"lead": "__fstrlen",
"k": []
},
{
"a": 67364,
"n": "runtime_band_010724",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 41,
"lead": "",
"k": []
},
{
"a": 67406,
"n": "__fstrcpy",
"t": "B",
"m": "strcpy.asm",
"p": "",
"s": 54,
"lead": "",
"k": []
},
{
"a": 67460,
"n": "__fstrcat",
"t": "B",
"m": "strcat.asm",
"p": "",
"s": 70,
"lead": "",
"k": []
},
{
"a": 67530,
"n": "__fmemset",
"t": "B",
"m": "hmemset.asm",
"p": "",
"s": 49,
"lead": "",
"k": []
},
{
"a": 67602,
"n": "__FF_MSGBANNER",
"t": "B",
"m": "dos\\crt0msg.asm",
"p": "",
"s": 34,
"lead": "",
"k": []
},
{
"a": 68080,
"n": "__setenvp",
"t": "B",
"m": "dos\\stdenvp.asm",
"p": "",
"s": 15,
"lead": "",
"k": []
},
{
"a": 68206,
"n": "__NMSG_TEXT",
"t": "B",
"m": "dos\\nmsghdr.asm",
"p": "",
"s": 18,
"lead": "",
"k": []
},
{
"a": 68249,
"n": "__NMSG_WRITE",
"t": "B",
"m": "dos\\nmsghdr.asm",
"p": "",
"s": 12,
"lead": "",
"k": []
},
{
"a": 68390,
"n": "__filbuf",
"t": "B",
"m": "_filbuf.asm",
"p": "",
"s": 149,
"lead": "",
"k": []
},
{
"a": 68540,
"n": "__flsbuf",
"t": "B",
"m": "_flsbuf.asm",
"p": "",
"s": 151,
"lead": "",
"k": []
},
{
"a": 68768,
"n": "runtime_band_010CA0",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 44,
"lead": "",
"k": []
},
{
"a": 68812,
"n": "open_c_010CCC",
"t": "M",
"m": "_open.c",
"p": "",
"s": 180,
"lead": "__openfile",
"k": []
},
{
"a": 69044,
"n": "sftbuf_asm_010DB4",
"t": "M",
"m": "_sftbuf.asm",
"p": "",
"s": 115,
"lead": "__stbuf",
"k": []
},
{
"a": 69159,
"n": "__ftbuf",
"t": "B",
"m": "_sftbuf.asm",
"p": "",
"s": 63,
"lead": "",
"k": []
},
{
"a": 69222,
"n": "fflush_c_010E66",
"t": "M",
"m": "fflush.c",
"p": "",
"s": 116,
"lead": "_fflush",
"k": []
},
{
"a": 69346,
"n": "runtime_band_010EE2",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 75,
"lead": "",
"k": []
},
{
"a": 69438,
"n": "__output",
"t": "B",
"m": "output.asm",
"p": "",
"s": 448,
"lead": "",
"k": []
},
{
"a": 70730,
"n": "_close",
"t": "R",
"m": "dos\\close.asm",
"p": "",
"s": 32,
"lead": "_close",
"k": []
},
{
"a": 70762,
"n": "_lseek",
"t": "B",
"m": "dos\\lseek.asm",
"p": "",
"s": 122,
"lead": "",
"k": []
},
{
"a": 70884,
"n": "_read",
"t": "B",
"m": "dos\\read.asm",
"p": "",
"s": 125,
"lead": "",
"k": []
},
{
"a": 71118,
"n": "write_asm_0115CE",
"t": "M",
"m": "write.asm",
"p": "",
"s": 185,
"lead": "_write",
"k": []
},
{
"a": 71692,
"n": "__catox",
"t": "B",
"m": "atox.asm",
"p": "",
"s": 46,
"lead": "",
"k": []
},
{
"a": 71776,
"n": "ftell_c_011860",
"t": "M",
"m": "ftell.c",
"p": "",
"s": 172,
"lead": "_ftell",
"k": []
},
{
"a": 72150,
"n": "setvbuf_c_0119D6",
"t": "M",
"m": "setvbuf.c",
"p": "",
"s": 157,
"lead": "_setvbuf",
"k": []
},
{
"a": 72534,
"n": "runtime_band_011B56",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 341,
"lead": "",
"k": []
},
{
"a": 72914,
"n": "runtime_band_011CD2",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 25,
"lead": "",
"k": []
},
{
"a": 72982,
"n": "dos_open_asm_011D16",
"t": "M",
"m": "dos\\open.asm",
"p": "",
"s": 26,
"lead": "_sopen",
"k": []
},
{
"a": 73008,
"n": "_open",
"t": "B",
"m": "dos\\open.asm",
"p": "",
"s": 105,
"lead": "",
"k": []
},
{
"a": 73582,
"n": "load_game_state",
"t": "R",
"m": "runtime-band",
"p": "",
"s": 403,
"lead": "",
"k": []
},
{
"a": 73986,
"n": "runtime_band_012102",
"t": "M",
"m": "runtime-band",
"p": "",
"s": 273,
"lead": "",
"k": []
},
{
"a": 74260,
"n": "__nfree",
"t": "B",
"m": "nmalloc.asm",
"p": "",
"s": 33,
"lead": "",
"k": []
},
{
"a": 74293,
"n": "__nmalloc",
"t": "B",
"m": "nmalloc.asm",
"p": "",
"s": 40,
"lead": "",
"k": []
},
{
"a": 74334,
"n": "resident__unattributed_01225E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 360,
"lead": "",
"k": []
},
{
"a": 74966,
"n": "coreleft_total",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 90,
"lead": "",
"k": []
},
{
"a": 75866,
"n": "resident__unattributed_01285A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 32,
"lead": "",
"k": []
},
{
"a": 75898,
"n": "_SOUND_DRIVER_LOAD",
"t": "B",
"m": "sound_1.ASM",
"p": "",
"s": 136,
"lead": "",
"k": []
},
{
"a": 76072,
"n": "_SOUND_DRIVER_INIT",
"t": "B",
"m": "sound_1.ASM",
"p": "",
"s": 49,
"lead": "",
"k": []
},
{
"a": 76121,
"n": "engine_band_012959",
"t": "M",
"m": "engine-band",
"p": "",
"s": 26,
"lead": "",
"k": []
},
{
"a": 76209,
"n": "engine_band_0129B1",
"t": "M",
"m": "engine-band",
"p": "",
"s": 16,
"lead": "",
"k": []
},
{
"a": 76284,
"n": "engine_band_0129FC",
"t": "M",
"m": "engine-band",
"p": "",
"s": 57,
"lead": "",
"k": []
},
{
"a": 76342,
"n": "engine_band_012A36",
"t": "M",
"m": "engine-band",
"p": "",
"s": 14,
"lead": "",
"k": []
},
{
"a": 76390,
"n": "PACK_1_C_012A66",
"t": "M",
"m": "PACK_1.C",
"p": "",
"s": 29,
"lead": "PACK_READ_MEMORY",
"k": []
},
{
"a": 76506,
"n": "PACK_2_C_012ADA",
"t": "M",
"m": "PACK_2.C",
"p": "",
"s": 28,
"lead": "PACK_WRITE_MEMORY",
"k": []
},
{
"a": 76616,
"n": "PACK_3_C_012B48",
"t": "M",
"m": "PACK_3.C",
"p": "",
"s": 121,
"lead": "PACK_READ_FILE",
"k": []
},
{
"a": 76738,
"n": "PACK_4_C_012BC2",
"t": "M",
"m": "PACK_4.C",
"p": "",
"s": 145,
"lead": "PACK_WRITE_FILE",
"k": []
},
{
"a": 76940,
"n": "engine_band_012C8C",
"t": "M",
"m": "engine-band",
"p": "",
"s": 60,
"lead": "",
"k": []
},
{
"a": 77000,
"n": "xms_1_c_012CC8",
"t": "M",
"m": "xms_1.c",
"p": "",
"s": 130,
"lead": "@xms_detect",
"k": []
},
{
"a": 77130,
"n": "engine_band_012D4A",
"t": "M",
"m": "engine-band",
"p": "",
"s": 95,
"lead": "",
"k": []
},
{
"a": 77226,
"n": "at_xtoi",
"t": "B",
"m": "btype_3.c",
"p": "",
"s": 99,
"lead": "",
"k": []
},
{
"a": 77398,
"n": "engine_band_012E56",
"t": "M",
"m": "engine-band",
"p": "",
"s": 20,
"lead": "",
"k": []
},
{
"a": 77536,
"n": "engine_band_012EE0",
"t": "M",
"m": "engine-band",
"p": "",
"s": 63,
"lead": "",
"k": []
},
{
"a": 77988,
"n": "engine_band_0130A4",
"t": "M",
"m": "engine-band",
"p": "",
"s": 20,
"lead": "",
"k": []
},
{
"a": 78107,
"n": "engine_band_01311B",
"t": "M",
"m": "engine-band",
"p": "",
"s": 63,
"lead": "",
"k": []
},
{
"a": 78512,
"n": "PFABEXP2",
"t": "B",
"m": "pfabexp2.ASM",
"p": "",
"s": 26,
"lead": "",
"k": []
},
{
"a": 78862,
"n": "_xms_umb_get_avail",
"t": "B",
"m": "XMS_2.C",
"p": "",
"s": 32,
"lead": "",
"k": []
},
{
"a": 78906,
"n": "_xms_umb_get",
"t": "B",
"m": "XMS_3.C",
"p": "",
"s": 65,
"lead": "",
"k": []
},
{
"a": 78972,
"n": "_xms_umb_free",
"t": "B",
"m": "XMS_3.C",
"p": "",
"s": 21,
"lead": "",
"k": []
},
{
"a": 80718,
"n": "resident__unattributed_013B4E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 17,
"lead": "",
"k": []
},
{
"a": 80799,
"n": "resident__unattributed_013B9F",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 22,
"lead": "",
"k": []
},
{
"a": 80877,
"n": "entry_point",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 10,
"lead": "",
"k": []
},
{
"a": 80887,
"n": "system_init",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 1368,
"lead": "",
"k": []
},
{
"a": 82529,
"n": "rtlink_loader_B",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 26,
"lead": "",
"k": []
},
{
"a": 82555,
"n": "rtlink_loader_A",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 24,
"lead": "",
"k": []
},
{
"a": 82579,
"n": "rtlink_loader_shared",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 1018,
"lead": "",
"k": []
},
{
"a": 86164,
"n": "resident__unattributed_015094",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 69,
"lead": "",
"k": []
},
{
"a": 86321,
"n": "resident__unattributed_015131",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 20,
"lead": "",
"k": []
},
{
"a": 86341,
"n": "resident__unattributed_015145",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 19,
"lead": "",
"k": []
},
{
"a": 86374,
"n": "resident__unattributed_015166",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 75,
"lead": "",
"k": []
},
{
"a": 86449,
"n": "resident__unattributed_0151B1",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 65,
"lead": "",
"k": []
},
{
"a": 90227,
"n": "resident__unattributed_016073",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 19,
"lead": "",
"k": []
},
{
"a": 91298,
"n": "rtlink_segment_lookup",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 59,
"lead": "",
"k": []
},
{
"a": 106084,
"n": "resident__unattributed_019E64",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 11,
"lead": "",
"k": []
},
{
"a": 107139,
"n": "resident__unattributed_01A283",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 86,
"lead": "",
"k": []
},
{
"a": 107557,
"n": "dos_version_far",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 23,
"lead": "",
"k": []
},
{
"a": 108016,
"n": "rtlink_overlay_thunk_table",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 12278,
"lead": "",
"k": []
},
{
"a": 133180,
"n": "overlay_metadata_02083C",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 220,
"lead": "",
"k": []
},
{
"a": 133400,
"n": "overlay_metadata_020918",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 5,
"lead": "",
"k": []
},
{
"a": 134880,
"n": "map_input_020EE0",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 111,
"lead": "",
"k": [
"TUTORIAL2"
]
},
{
"a": 134992,
"n": "map_input_020F50",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 1714,
"lead": "",
"k": [
"TUTORIAL1",
"TUTORIAL3",
"TUTORIAL8",
"TUTORIAL9",
"TUTORIAL10",
"TUTORIAL11",
"TUTORIAL13",
"TUTORIAL14",
"TUTORIAL15",
"TUTORIAL19"
]
},
{
"a": 136706,
"n": "map_input_021602",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 92,
"lead": "",
"k": []
},
{
"a": 136798,
"n": "map_input_02165E",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 906,
"lead": "",
"k": []
},
{
"a": 137704,
"n": "map_input_0219E8",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 44,
"lead": "",
"k": []
},
{
"a": 137748,
"n": "map_input_021A14",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 797,
"lead": "",
"k": []
},
{
"a": 138546,
"n": "map_input_021D32",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 320,
"lead": "",
"k": []
},
{
"a": 138866,
"n": "map_input_021E72",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 107,
"lead": "",
"k": []
},
{
"a": 138974,
"n": "map_input_021EDE",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 275,
"lead": "",
"k": []
},
{
"a": 139250,
"n": "map_input_021FF2",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 299,
"lead": "",
"k": [
"HAVETREATY"
]
},
{
"a": 139550,
"n": "map_input_02211E",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 533,
"lead": "",
"k": [
"INDIANBRIBE",
"NOPLOW"
]
},
{
"a": 140084,
"n": "map_input_022334",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 526,
"lead": "",
"k": [
"NOROAD"
]
},
{
"a": 140610,
"n": "map_input_022542",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 678,
"lead": "",
"k": [
"SEACOLONY",
"NOPORT",
"TOONEAR",
"TOONEARBUILD",
"TOOMOUNTAIN",
"NOCOLONIESEITHER",
"TUTNOLUMBER",
"TUTNOSPACES"
]
},
{
"a": 141288,
"n": "map_input_0227E8",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 73,
"lead": "",
"k": []
},
{
"a": 141362,
"n": "map_input_022832",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 75,
"lead": "",
"k": []
},
{
"a": 141438,
"n": "map_input_02287E",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 444,
"lead": "",
"k": [
"DISBANDSHIP"
]
},
{
"a": 141882,
"n": "map_input_022A3A",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 673,
"lead": "",
"k": []
},
{
"a": 142556,
"n": "map_input_022CDC",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 106,
"lead": "",
"k": []
},
{
"a": 142662,
"n": "map_input_022D46",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 208,
"lead": "",
"k": [
"TRADENONE",
"TRADESELECT"
]
},
{
"a": 142870,
"n": "map_input_022E16",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 242,
"lead": "",
"k": []
},
{
"a": 143112,
"n": "map_input_022F08",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 1084,
"lead": "",
"k": []
},
{
"a": 144196,
"n": "map_input_023344",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 551,
"lead": "",
"k": []
},
{
"a": 144748,
"n": "map_input_02356C",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 105,
"lead": "",
"k": []
},
{
"a": 144854,
"n": "map_input_0235D6",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 2374,
"lead": "",
"k": []
},
{
"a": 147228,
"n": "map_input_023F1C",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 689,
"lead": "",
"k": []
},
{
"a": 147918,
"n": "map_input_0241CE",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 86,
"lead": "",
"k": []
},
{
"a": 148004,
"n": "map_input_024224",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 138,
"lead": "",
"k": []
},
{
"a": 148142,
"n": "map_input_0242AE",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 116,
"lead": "",
"k": []
},
{
"a": 148258,
"n": "map_input_024322",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 32,
"lead": "",
"k": []
},
{
"a": 148290,
"n": "map_input_024342",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 643,
"lead": "",
"k": []
},
{
"a": 148934,
"n": "map_input_0245C6",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 107,
"lead": "",
"k": []
},
{
"a": 149042,
"n": "map_input_024632",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 96,
"lead": "",
"k": []
},
{
"a": 149138,
"n": "map_input_024692",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 80,
"lead": "",
"k": []
},
{
"a": 149218,
"n": "map_input_0246E2",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 870,
"lead": "",
"k": []
},
{
"a": 150088,
"n": "map_input_024A48",
"t": "M",
"m": "map_input*",
"p": "01",
"s": 424,
"lead": "",
"k": []
},
{
"a": 152768,
"n": "overlay_metadata_0254C0",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 229,
"lead": "",
"k": []
},
{
"a": 153856,
"n": "colony_ui_025900",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 285,
"lead": "",
"k": []
},
{
"a": 154142,
"n": "colony_ui_025A1E",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 531,
"lead": "",
"k": []
},
{
"a": 154674,
"n": "colony_ui_025C32",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 258,
"lead": "",
"k": []
},
{
"a": 154932,
"n": "colony_ui_025D34",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 442,
"lead": "",
"k": [
"COLONY"
]
},
{
"a": 155374,
"n": "colony_ui_025EEE",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 308,
"lead": "",
"k": []
},
{
"a": 155682,
"n": "colony_ui_026022",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 288,
"lead": "",
"k": []
},
{
"a": 155970,
"n": "colony_ui_026142",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 507,
"lead": "",
"k": []
},
{
"a": 156478,
"n": "colony_ui_02633E",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 54,
"lead": "",
"k": []
},
{
"a": 156532,
"n": "colony_ui_026374",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 308,
"lead": "",
"k": []
},
{
"a": 156840,
"n": "colony_ui_0264A8",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 1062,
"lead": "",
"k": []
},
{
"a": 157902,
"n": "colony_ui_0268CE",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 483,
"lead": "",
"k": []
},
{
"a": 158386,
"n": "colony_ui_026AB2",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 282,
"lead": "",
"k": []
},
{
"a": 158668,
"n": "colony_ui_026BCC",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 246,
"lead": "",
"k": []
},
{
"a": 158914,
"n": "colony_ui_026CC2",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 273,
"lead": "",
"k": []
},
{
"a": 159188,
"n": "colony_ui_026DD4",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 541,
"lead": "",
"k": []
},
{
"a": 159730,
"n": "colony_ui_026FF2",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 41,
"lead": "",
"k": []
},
{
"a": 159772,
"n": "colony_ui_02701C",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 180,
"lead": "",
"k": []
},
{
"a": 159952,
"n": "colony_ui_0270D0",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 1278,
"lead": "",
"k": []
},
{
"a": 161230,
"n": "colony_ui_0275CE",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 376,
"lead": "",
"k": []
},
{
"a": 161606,
"n": "colony_ui_027746",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 526,
"lead": "",
"k": []
},
{
"a": 162132,
"n": "colony_ui_027954",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 56,
"lead": "",
"k": []
},
{
"a": 162188,
"n": "colony_ui_02798C",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 334,
"lead": "",
"k": []
},
{
"a": 162522,
"n": "colony_ui_027ADA",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 220,
"lead": "",
"k": []
},
{
"a": 162742,
"n": "colony_ui_027BB6",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 461,
"lead": "",
"k": []
},
{
"a": 163204,
"n": "colony_ui_027D84",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 46,
"lead": "",
"k": []
},
{
"a": 163250,
"n": "colony_ui_027DB2",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 921,
"lead": "",
"k": []
},
{
"a": 164172,
"n": "colony_ui_02814C",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 82,
"lead": "",
"k": []
},
{
"a": 164254,
"n": "colony_ui_02819E",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 55,
"lead": "",
"k": []
},
{
"a": 164310,
"n": "colony_ui_0281D6",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 598,
"lead": "",
"k": []
},
{
"a": 164908,
"n": "colony_ui_02842C",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 57,
"lead": "",
"k": []
},
{
"a": 164966,
"n": "colony_ui_028466",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 214,
"lead": "",
"k": []
},
{
"a": 165180,
"n": "colony_ui_02853C",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 85,
"lead": "",
"k": []
},
{
"a": 165266,
"n": "colony_ui_028592",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 512,
"lead": "",
"k": []
},
{
"a": 165778,
"n": "colony_ui_028792",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 32,
"lead": "",
"k": []
},
{
"a": 165810,
"n": "colony_ui_0287B2",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 19,
"lead": "",
"k": []
},
{
"a": 165830,
"n": "colony_ui_0287C6",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 35,
"lead": "",
"k": []
},
{
"a": 165866,
"n": "colony_ui_0287EA",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 60,
"lead": "",
"k": []
},
{
"a": 165926,
"n": "colony_ui_028826",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 23,
"lead": "",
"k": []
},
{
"a": 165950,
"n": "colony_ui_02883E",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 1357,
"lead": "",
"k": [
"FULL",
"NOTEACHER",
"NEEDCOLLEGE",
"NEEDUNIVERSITY",
"SIEGE",
"ABANDON",
"SCHOOL1",
"COLLEGE2",
"UNIV3",
"NODOCKS",
"KEEPSTOCKADE",
"MORETHANTHREE",
"TUTORIAL7"
]
},
{
"a": 167308,
"n": "colony_ui_028D8C",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 2017,
"lead": "",
"k": [
"LOBOTOMIZE"
]
},
{
"a": 169325,
"n": "colony_ui_02956D",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 1075,
"lead": "",
"k": []
},
{
"a": 170400,
"n": "colony_ui_0299A0",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 287,
"lead": "",
"k": []
},
{
"a": 170688,
"n": "colony_ui_029AC0",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 196,
"lead": "",
"k": []
},
{
"a": 170884,
"n": "colony_ui_029B84",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 57,
"lead": "",
"k": []
},
{
"a": 170942,
"n": "colony_ui_029BBE",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 82,
"lead": "",
"k": []
},
{
"a": 171024,
"n": "colony_ui_029C10",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 275,
"lead": "",
"k": []
},
{
"a": 171300,
"n": "colony_ui_029D24",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 176,
"lead": "",
"k": []
},
{
"a": 171476,
"n": "colony_ui_029DD4",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 744,
"lead": "",
"k": []
},
{
"a": 172220,
"n": "colony_ui_02A0BC",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 607,
"lead": "",
"k": []
},
{
"a": 172828,
"n": "colony_ui_02A31C",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 325,
"lead": "",
"k": []
},
{
"a": 173154,
"n": "colony_ui_02A462",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 579,
"lead": "",
"k": []
},
{
"a": 173734,
"n": "colony_ui_02A6A6",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 582,
"lead": "",
"k": [
"WAREHOUSEFULL"
]
},
{
"a": 174316,
"n": "colony_ui_02A8EC",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 512,
"lead": "",
"k": []
},
{
"a": 174828,
"n": "colony_ui_02AAEC",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 674,
"lead": "",
"k": [
"SHIPOPTIONS"
]
},
{
"a": 175502,
"n": "colony_ui_02AD8E",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 331,
"lead": "",
"k": []
},
{
"a": 175834,
"n": "colony_ui_02AEDA",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 243,
"lead": "",
"k": []
},
{
"a": 176078,
"n": "colony_ui_02AFCE",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 119,
"lead": "",
"k": []
},
{
"a": 176198,
"n": "colony_ui_02B046",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 602,
"lead": "",
"k": [
"UNITOPTIONS"
]
},
{
"a": 176800,
"n": "colony_ui_02B2A0",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 199,
"lead": "",
"k": []
},
{
"a": 177000,
"n": "colony_ui_02B368",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 361,
"lead": "",
"k": []
},
{
"a": 177362,
"n": "colony_ui_02B4D2",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 625,
"lead": "",
"k": []
},
{
"a": 177988,
"n": "colony_ui_02B744",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 386,
"lead": "",
"k": [
"BUYME0",
"BUYME1"
]
},
{
"a": 178374,
"n": "colony_ui_02B8C6",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 277,
"lead": "",
"k": []
},
{
"a": 178652,
"n": "colony_ui_02B9DC",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 429,
"lead": "",
"k": []
},
{
"a": 179082,
"n": "colony_ui_02BB8A",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 232,
"lead": "",
"k": []
},
{
"a": 179314,
"n": "colony_ui_02BC72",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 2259,
"lead": "",
"k": []
},
{
"a": 181574,
"n": "colony_ui_02C546",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 141,
"lead": "",
"k": []
},
{
"a": 181716,
"n": "colony_ui_02C5D4",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 1318,
"lead": "",
"k": [
"TUTORIAL4",
"TUTORIAL12"
]
},
{
"a": 184272,
"n": "colony_econ_02CFD0",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 274,
"lead": "",
"k": []
},
{
"a": 184548,
"n": "colony_econ_02D0E4",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 549,
"lead": "",
"k": [
"BUILT",
"NOMOREWAREHOUSE",
"NOMOREWAGONS"
]
},
{
"a": 185098,
"n": "colony_econ_02D30A",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 188,
"lead": "",
"k": [
"DEPLETION"
]
},
{
"a": 185286,
"n": "colony_econ_02D3C6",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 575,
"lead": "",
"k": [
"FORTFIRE"
]
},
{
"a": 185862,
"n": "colony_econ_02D606",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 81,
"lead": "",
"k": []
},
{
"a": 185944,
"n": "colony_econ_02D658",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 5220,
"lead": "",
"k": [
"TRAINFAIL",
"TRAINCRIMINAL",
"TRAININDENTURED",
"TRAINPROFESSION",
"CARGOREADY0",
"LUMBER",
"COTTON",
"TOBACCO",
"CANESUGAR",
"FURS",
"ORE",
"TOOLS",
"FOOD1",
"FOOD2",
"VANISH",
"STARVE1",
"STARVE2",
"FOODLOW",
"SPOIL1",
"SPOIL2",
"NEEDTOOLS",
"ALREADYHAVE",
"REBELMAJORITY",
"REBELUNANIMOUS",
"TORYMINORITY",
"TORYMAJORITY",
"SONSUP",
"SONSDOWN",
"NEWCOLONIST",
"INEFFICIENT",
"EFFICIENT",
"TUTORIAL6"
]
},
{
"a": 191164,
"n": "colony_econ_02EABC",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 46,
"lead": "",
"k": []
},
{
"a": 191210,
"n": "colony_econ_02EAEA",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 49,
"lead": "",
"k": []
},
{
"a": 191260,
"n": "colony_econ_02EB1C",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 42,
"lead": "",
"k": []
},
{
"a": 191302,
"n": "colony_econ_02EB46",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 49,
"lead": "",
"k": []
},
{
"a": 191352,
"n": "colony_econ_02EB78",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 182,
"lead": "",
"k": []
},
{
"a": 191534,
"n": "colony_econ_02EC2E",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 518,
"lead": "",
"k": []
},
{
"a": 192052,
"n": "colony_econ_02EE34",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 304,
"lead": "",
"k": []
},
{
"a": 192356,
"n": "colony_econ_02EF64",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 236,
"lead": "",
"k": [
"DEADCONVERTS"
]
},
{
"a": 192594,
"n": "colony_econ_02F052",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 847,
"lead": "",
"k": [
"KINGTAX",
"REFIT"
]
},
{
"a": 193442,
"n": "colony_econ_02F3A2",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 1869,
"lead": "",
"k": [
"OTHERMIGHT",
"OTHERLESS",
"LOSENOCOLONIES",
"KINGLOSE",
"KINGWIN"
]
},
{
"a": 196364,
"n": "overlay_metadata_02FF0C",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 111,
"lead": "",
"k": []
},
{
"a": 197452,
"n": "overlay_metadata_03034C",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 473,
"lead": "",
"k": []
},
{
"a": 197968,
"n": "europe_king_030550",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 21,
"lead": "",
"k": []
},
{
"a": 197990,
"n": "commodity_current_price",
"t": "R",
"m": "europe_king*",
"p": "04",
"s": 42,
"lead": "",
"k": []
},
{
"a": 198032,
"n": "europe_king_030590",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 24,
"lead": "",
"k": []
},
{
"a": 198056,
"n": "market_price_drift",
"t": "R",
"m": "europe_king*",
"p": "04",
"s": 1424,
"lead": "",
"k": [
"PRICEUP",
"PRICEDOWN"
]
},
{
"a": 199480,
"n": "boycott_is_good_boycotted",
"t": "R",
"m": "europe_king*",
"p": "04",
"s": 20,
"lead": "",
"k": []
},
{
"a": 199500,
"n": "europe_king_030B4C",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 105,
"lead": "",
"k": []
},
{
"a": 199606,
"n": "europe_king_030BB6",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 94,
"lead": "",
"k": []
},
{
"a": 199700,
"n": "europe_king_030C14",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 83,
"lead": "",
"k": []
},
{
"a": 199784,
"n": "europe_king_030C68",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 174,
"lead": "",
"k": []
},
{
"a": 199958,
"n": "europe_king_030D16",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 111,
"lead": "",
"k": []
},
{
"a": 200070,
"n": "europe_king_030D86",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 110,
"lead": "",
"k": []
},
{
"a": 200180,
"n": "europe_king_030DF4",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 385,
"lead": "",
"k": []
},
{
"a": 200566,
"n": "europe_king_030F76",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 318,
"lead": "",
"k": []
},
{
"a": 200884,
"n": "europe_king_0310B4",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 483,
"lead": "",
"k": []
},
{
"a": 201368,
"n": "europe_king_031298",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 206,
"lead": "",
"k": []
},
{
"a": 201574,
"n": "europe_king_031366",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 327,
"lead": "",
"k": []
},
{
"a": 201902,
"n": "europe_king_0314AE",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 46,
"lead": "",
"k": []
},
{
"a": 201948,
"n": "europe_king_0314DC",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 752,
"lead": "",
"k": []
},
{
"a": 202700,
"n": "europe_king_0317CC",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 261,
"lead": "",
"k": []
},
{
"a": 202962,
"n": "europe_king_0318D2",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 211,
"lead": "",
"k": []
},
{
"a": 203174,
"n": "europe_king_0319A6",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 21,
"lead": "",
"k": []
},
{
"a": 203196,
"n": "europe_king_0319BC",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 117,
"lead": "",
"k": []
},
{
"a": 203314,
"n": "europe_king_031A32",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 199,
"lead": "",
"k": []
},
{
"a": 203514,
"n": "europe_king_031AFA",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 182,
"lead": "",
"k": []
},
{
"a": 203696,
"n": "europe_king_031BB0",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 54,
"lead": "",
"k": []
},
{
"a": 203750,
"n": "europe_king_031BE6",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 481,
"lead": "",
"k": []
},
{
"a": 204232,
"n": "europe_king_031DC8",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 351,
"lead": "",
"k": []
},
{
"a": 204584,
"n": "europe_king_031F28",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 32,
"lead": "",
"k": []
},
{
"a": 204616,
"n": "europe_king_031F48",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 19,
"lead": "",
"k": []
},
{
"a": 204636,
"n": "europe_king_031F5C",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 35,
"lead": "",
"k": []
},
{
"a": 204672,
"n": "europe_king_031F80",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 137,
"lead": "",
"k": []
},
{
"a": 204810,
"n": "europe_king_03200A",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 227,
"lead": "",
"k": []
},
{
"a": 205038,
"n": "europe_king_0320EE",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 51,
"lead": "",
"k": []
},
{
"a": 205090,
"n": "europe_king_032122",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 146,
"lead": "",
"k": []
},
{
"a": 205236,
"n": "europe_king_0321B4",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 72,
"lead": "",
"k": []
},
{
"a": 205308,
"n": "europe_king_0321FC",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 102,
"lead": "",
"k": []
},
{
"a": 205410,
"n": "europe_king_032262",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 22,
"lead": "",
"k": []
},
{
"a": 205432,
"n": "europe_king_032278",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 27,
"lead": "",
"k": []
},
{
"a": 205460,
"n": "europe_king_032294",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 59,
"lead": "",
"k": []
},
{
"a": 205520,
"n": "europe_king_0322D0",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 121,
"lead": "",
"k": []
},
{
"a": 205642,
"n": "europe_king_03234A",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 194,
"lead": "",
"k": []
},
{
"a": 205836,
"n": "europe_king_03240C",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 80,
"lead": "",
"k": []
},
{
"a": 205916,
"n": "europe_king_03245C",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 108,
"lead": "",
"k": []
},
{
"a": 206024,
"n": "europe_king_0324C8",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 42,
"lead": "",
"k": []
},
{
"a": 206066,
"n": "europe_king_0324F2",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 1057,
"lead": "",
"k": []
},
{
"a": 207124,
"n": "europe_king_032914",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 1175,
"lead": "",
"k": []
},
{
"a": 208300,
"n": "europe_king_032DAC",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 566,
"lead": "",
"k": []
},
{
"a": 208866,
"n": "europe_king_032FE2",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 364,
"lead": "",
"k": []
},
{
"a": 209230,
"n": "europe_ship_arrival_trade_handler",
"t": "R",
"m": "europe_king*",
"p": "04",
"s": 511,
"lead": "",
"k": [
"EUROPESHIPOPTIONS",
"SOMEBOYCOTT"
]
},
{
"a": 209742,
"n": "boycott_lift_backtax",
"t": "R",
"m": "europe_king*",
"p": "04",
"s": 221,
"lead": "",
"k": [
"KISSUP",
"KISSSORRY"
]
},
{
"a": 209964,
"n": "europe_king_03342C",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 462,
"lead": "",
"k": []
},
{
"a": 210426,
"n": "europe_king_0335FA",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 283,
"lead": "",
"k": []
},
{
"a": 210710,
"n": "europe_king_033716",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 97,
"lead": "",
"k": []
},
{
"a": 210808,
"n": "europe_king_033778",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 730,
"lead": "",
"k": []
},
{
"a": 211538,
"n": "europe_king_033A52",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 402,
"lead": "",
"k": []
},
{
"a": 211940,
"n": "europe_king_033BE4",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 178,
"lead": "",
"k": []
},
{
"a": 212118,
"n": "europe_king_033C96",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 724,
"lead": "",
"k": [
"ARMOPTIONS"
]
},
{
"a": 212842,
"n": "europe_king_033F6A",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 620,
"lead": "",
"k": [
"UNREST",
"KINGLOWER",
"KINGRAISE",
"TAXOPTIONS",
"TEAPARTY",
"KINGNEWWAR",
"KINGVICTORY",
"KINGWIFE",
"KINGWAR",
"KINGNAVACT",
"KINGSTAMPACT",
"COUNTRIES",
"ORDINAL",
"REALLYBUY",
"TUTORIAL5"
]
},
{
"a": 213462,
"n": "europe_king_0341D6",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 322,
"lead": "",
"k": []
},
{
"a": 213784,
"n": "europe_king_034318",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 1030,
"lead": "",
"k": []
},
{
"a": 214814,
"n": "europe_king_03471E",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 726,
"lead": "",
"k": []
},
{
"a": 215540,
"n": "europe_king_0349F4",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 236,
"lead": "",
"k": []
},
{
"a": 215776,
"n": "europe_king_034AE0",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 324,
"lead": "",
"k": []
},
{
"a": 216100,
"n": "europe_king_034C24",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 432,
"lead": "",
"k": []
},
{
"a": 216532,
"n": "europe_king_034DD4",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 716,
"lead": "",
"k": []
},
{
"a": 217248,
"n": "europe_king_0350A0",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 830,
"lead": "",
"k": []
},
{
"a": 218078,
"n": "europe_king_0353DE",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 224,
"lead": "",
"k": []
},
{
"a": 218302,
"n": "europe_king_0354BE",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 1554,
"lead": "",
"k": []
},
{
"a": 219856,
"n": "europe_king_035AD0",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 54,
"lead": "",
"k": []
},
{
"a": 219910,
"n": "europe_king_035B06",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 660,
"lead": "",
"k": []
},
{
"a": 220570,
"n": "immigration_threshold_and_cross_production",
"t": "R",
"m": "europe_king*",
"p": "04",
"s": 230,
"lead": "",
"k": []
},
{
"a": 220800,
"n": "europe_king_035E80",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 440,
"lead": "",
"k": []
},
{
"a": 221240,
"n": "europe_king_036038",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 256,
"lead": "",
"k": []
},
{
"a": 221496,
"n": "king_tax_demand_and_pretext",
"t": "R",
"m": "europe_king*",
"p": "04",
"s": 618,
"lead": "",
"k": []
},
{
"a": 222114,
"n": "europe_king_0363A2",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 466,
"lead": "",
"k": []
},
{
"a": 222580,
"n": "europe_king_036574",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 1026,
"lead": "",
"k": []
},
{
"a": 223606,
"n": "europe_king_036976",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 26,
"lead": "",
"k": []
},
{
"a": 224052,
"n": "overlay_metadata_036B34",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 12,
"lead": "",
"k": []
},
{
"a": 224064,
"n": "overlay_metadata_036B40",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 225,
"lead": "",
"k": []
},
{
"a": 226112,
"n": "reports_037340",
"t": "M",
"m": "reports*",
"p": "05",
"s": 137,
"lead": "",
"k": []
},
{
"a": 226250,
"n": "reports_0373CA",
"t": "M",
"m": "reports*",
"p": "05",
"s": 128,
"lead": "",
"k": []
},
{
"a": 226378,
"n": "reports_03744A",
"t": "M",
"m": "reports*",
"p": "05",
"s": 1294,
"lead": "",
"k": []
},
{
"a": 227672,
"n": "reports_037958",
"t": "M",
"m": "reports*",
"p": "05",
"s": 184,
"lead": "",
"k": []
},
{
"a": 227856,
"n": "reports_037A10",
"t": "M",
"m": "reports*",
"p": "05",
"s": 1646,
"lead": "",
"k": []
},
{
"a": 229502,
"n": "reports_03807E",
"t": "M",
"m": "reports*",
"p": "05",
"s": 921,
"lead": "",
"k": []
},
{
"a": 230424,
"n": "reports_038418",
"t": "M",
"m": "reports*",
"p": "05",
"s": 864,
"lead": "",
"k": []
},
{
"a": 231288,
"n": "reports_038778",
"t": "M",
"m": "reports*",
"p": "05",
"s": 280,
"lead": "",
"k": []
},
{
"a": 231568,
"n": "reports_038890",
"t": "M",
"m": "reports*",
"p": "05",
"s": 447,
"lead": "",
"k": []
},
{
"a": 232016,
"n": "reports_038A50",
"t": "M",
"m": "reports*",
"p": "05",
"s": 1155,
"lead": "",
"k": []
},
{
"a": 233172,
"n": "reports_038ED4",
"t": "M",
"m": "reports*",
"p": "05",
"s": 87,
"lead": "",
"k": []
},
{
"a": 233260,
"n": "reports_038F2C",
"t": "M",
"m": "reports*",
"p": "05",
"s": 659,
"lead": "",
"k": []
},
{
"a": 233920,
"n": "reports_0391C0",
"t": "M",
"m": "reports*",
"p": "05",
"s": 87,
"lead": "",
"k": []
},
{
"a": 234008,
"n": "reports_039218",
"t": "M",
"m": "reports*",
"p": "05",
"s": 475,
"lead": "",
"k": []
},
{
"a": 234484,
"n": "reports_0393F4",
"t": "M",
"m": "reports*",
"p": "05",
"s": 344,
"lead": "",
"k": []
},
{
"a": 234828,
"n": "reports_03954C",
"t": "M",
"m": "reports*",
"p": "05",
"s": 827,
"lead": "",
"k": []
},
{
"a": 235656,
"n": "reports_039888",
"t": "M",
"m": "reports*",
"p": "05",
"s": 1551,
"lead": "",
"k": [
"FOREIGNNOTAVAIL"
]
},
{
"a": 237208,
"n": "reports_039E98",
"t": "M",
"m": "reports*",
"p": "05",
"s": 73,
"lead": "",
"k": []
},
{
"a": 237282,
"n": "score_component_sum_and_report",
"t": "R",
"m": "reports*",
"p": "05",
"s": 2781,
"lead": "",
"k": []
},
{
"a": 240064,
"n": "score_scale_and_rank",
"t": "R",
"m": "reports*",
"p": "05",
"s": 998,
"lead": "",
"k": [
"EXPLOITS",
"SCORE"
]
},
{
"a": 241062,
"n": "hallfame_dat_write",
"t": "R",
"m": "reports*",
"p": "05",
"s": 1362,
"lead": "",
"k": []
},
{
"a": 242424,
"n": "reports_03B2F8",
"t": "M",
"m": "reports*",
"p": "05",
"s": 134,
"lead": "",
"k": []
},
{
"a": 242616,
"n": "overlay_metadata_03B3B8",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 959,
"lead": "",
"k": []
},
{
"a": 243968,
"n": "revolution_03B900",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 59,
"lead": "",
"k": []
},
{
"a": 244028,
"n": "revolution_03B93C",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 29,
"lead": "",
"k": []
},
{
"a": 244058,
"n": "revolution_03B95A",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 38,
"lead": "",
"k": []
},
{
"a": 244096,
"n": "revolution_03B980",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 96,
"lead": "",
"k": []
},
{
"a": 244192,
"n": "revolution_03B9E0",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 69,
"lead": "",
"k": []
},
{
"a": 244262,
"n": "revolution_03BA26",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 52,
"lead": "",
"k": []
},
{
"a": 244314,
"n": "revolution_03BA5A",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 76,
"lead": "",
"k": []
},
{
"a": 244390,
"n": "revolution_03BAA6",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 163,
"lead": "",
"k": []
},
{
"a": 244554,
"n": "revolution_03BB4A",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 247,
"lead": "",
"k": []
},
{
"a": 244802,
"n": "ff_acquire_dispatch",
"t": "R",
"m": "revolution*",
"p": "06",
"s": 911,
"lead": "",
"k": []
},
{
"a": 245714,
"n": "revolution_03BFD2",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 688,
"lead": "",
"k": []
},
{
"a": 246402,
"n": "revolution_03C282",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 160,
"lead": "",
"k": []
},
{
"a": 246562,
"n": "revolution_03C322",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 258,
"lead": "",
"k": [
"AMBUSHHINT",
"CONSIDER"
]
},
{
"a": 246820,
"n": "revolution_03C424",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 126,
"lead": "",
"k": []
},
{
"a": 246946,
"n": "revolution_03C4A2",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 134,
"lead": "",
"k": []
},
{
"a": 247080,
"n": "revolution_03C528",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 128,
"lead": "",
"k": []
},
{
"a": 247208,
"n": "revolution_03C5A8",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 143,
"lead": "",
"k": [
"SEIZURE"
]
},
{
"a": 247352,
"n": "spanish_succession_absorb_power",
"t": "R",
"m": "revolution*",
"p": "06",
"s": 762,
"lead": "",
"k": [
"SUCCESSION"
]
},
{
"a": 248114,
"n": "revolution_03C932",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 247,
"lead": "",
"k": [
"SEIZURESEA",
"SEIZURELAND"
]
},
{
"a": 248362,
"n": "revolution_03CA2A",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 155,
"lead": "",
"k": []
},
{
"a": 248518,
"n": "revolution_03CAC6",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 732,
"lead": "",
"k": [
"TORYUPRISING"
]
},
{
"a": 249250,
"n": "revolution_03CDA2",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 1902,
"lead": "",
"k": [
"INVASION"
]
},
{
"a": 251152,
"n": "revolution_03D510",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 1080,
"lead": "",
"k": [
"INTERVENE",
"MERCS"
]
},
{
"a": 252232,
"n": "revolution_03D948",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 225,
"lead": "",
"k": [
"INTERVENTION",
"FRIEND"
]
},
{
"a": 252458,
"n": "revolution_03DA2A",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 1051,
"lead": "",
"k": []
},
{
"a": 253510,
"n": "revolution_03DE46",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 795,
"lead": "",
"k": [
"INDEPENDENCE"
]
},
{
"a": 254306,
"n": "ref_budget_accrue_and_reinforce",
"t": "R",
"m": "revolution*",
"p": "06",
"s": 391,
"lead": "",
"k": [
"KINGBUY",
"KINGMOBILIZE"
]
},
{
"a": 254698,
"n": "revolution_03E2EA",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 343,
"lead": "",
"k": [
"MOBILIZE",
"MOBILIZE2"
]
},
{
"a": 255042,
"n": "revolution_03E442",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 546,
"lead": "",
"k": [
"MERCENARIES"
]
},
{
"a": 255588,
"n": "revolution_03E664",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 479,
"lead": "",
"k": []
},
{
"a": 256068,
"n": "revolution_03E844",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 319,
"lead": "",
"k": [
"REBELUP",
"REBELUP50",
"REBELDOWN"
]
},
{
"a": 256388,
"n": "revolution_03E984",
"t": "M",
"m": "revolution*",
"p": "06",
"s": 210,
"lead": "",
"k": [
"MULTIREV",
"TOOTORY",
"DECLARE",
"ALREADYREVOLUTION"
]
},
{
"a": 257264,
"n": "unit_vs_tile_combat_terrain_eval",
"t": "R",
"m": "naval*",
"p": "07",
"s": 3101,
"lead": "",
"k": [
"CANCELPEACE",
"DECLAREWAR",
"WHACKINDIANS"
]
},
{
"a": 260366,
"n": "naval_03F90E",
"t": "M",
"m": "naval*",
"p": "07",
"s": 56,
"lead": "",
"k": []
},
{
"a": 260422,
"n": "naval_03F946",
"t": "M",
"m": "naval*",
"p": "07",
"s": 342,
"lead": "",
"k": []
},
{
"a": 260764,
"n": "naval_03FA9C",
"t": "M",
"m": "naval*",
"p": "07",
"s": 834,
"lead": "",
"k": []
},
{
"a": 261598,
"n": "naval_03FDDE",
"t": "M",
"m": "naval*",
"p": "07",
"s": 366,
"lead": "",
"k": [
"LANDFALL",
"LANDFALL2",
"SHIPCOMBAT",
"SHIPLAKE",
"LANDFIRST",
"SAILHOME"
]
},
{
"a": 261964,
"n": "naval_03FF4C",
"t": "M",
"m": "naval*",
"p": "07",
"s": 182,
"lead": "",
"k": []
},
{
"a": 262146,
"n": "naval_040002",
"t": "M",
"m": "naval*",
"p": "07",
"s": 42,
"lead": "",
"k": []
},
{
"a": 262188,
"n": "naval_04002C",
"t": "M",
"m": "naval*",
"p": "07",
"s": 82,
"lead": "",
"k": []
},
{
"a": 262270,
"n": "naval_04007E",
"t": "M",
"m": "naval*",
"p": "07",
"s": 114,
"lead": "",
"k": []
},
{
"a": 262512,
"n": "overlay_metadata_040170",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 369,
"lead": "",
"k": []
},
{
"a": 263344,
"n": "pioneer_routes_0404B0",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 201,
"lead": "",
"k": []
},
{
"a": 263546,
"n": "pioneer_routes_04057A",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 141,
"lead": "",
"k": []
},
{
"a": 263688,
"n": "pioneer_routes_040608",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 78,
"lead": "",
"k": [
"USEDUPTOOLS"
]
},
{
"a": 263766,
"n": "pioneer_routes_040656",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 896,
"lead": "",
"k": [
"CLEARCUT"
]
},
{
"a": 264662,
"n": "pioneer_routes_0409D6",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 584,
"lead": "",
"k": []
},
{
"a": 265246,
"n": "pioneer_routes_040C1E",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 515,
"lead": "",
"k": []
},
{
"a": 265762,
"n": "pioneer_routes_040E22",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 436,
"lead": "",
"k": []
},
{
"a": 266198,
"n": "pioneer_routes_040FD6",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 70,
"lead": "",
"k": []
},
{
"a": 266268,
"n": "pioneer_routes_04101C",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 23,
"lead": "",
"k": []
},
{
"a": 266292,
"n": "pioneer_routes_041034",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 76,
"lead": "",
"k": []
},
{
"a": 266368,
"n": "pioneer_routes_041080",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 912,
"lead": "",
"k": [
"ROUTELOOP"
]
},
{
"a": 267280,
"n": "pioneer_routes_041410",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 579,
"lead": "",
"k": []
},
{
"a": 267860,
"n": "pioneer_routes_041654",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 478,
"lead": "",
"k": []
},
{
"a": 268338,
"n": "pioneer_routes_041832",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 120,
"lead": "",
"k": []
},
{
"a": 268458,
"n": "pioneer_routes_0418AA",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 227,
"lead": "",
"k": []
},
{
"a": 268686,
"n": "pioneer_routes_04198E",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 487,
"lead": "",
"k": []
},
{
"a": 269174,
"n": "pioneer_routes_041B76",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 137,
"lead": "",
"k": []
},
{
"a": 269312,
"n": "pioneer_routes_041C00",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 100,
"lead": "",
"k": []
},
{
"a": 269412,
"n": "pioneer_routes_041C64",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 89,
"lead": "",
"k": []
},
{
"a": 269502,
"n": "pioneer_routes_041CBE",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 448,
"lead": "",
"k": []
},
{
"a": 269950,
"n": "pioneer_routes_041E7E",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 108,
"lead": "",
"k": []
},
{
"a": 270058,
"n": "pioneer_routes_041EEA",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 589,
"lead": "",
"k": [
"LOOTCASH"
]
},
{
"a": 270648,
"n": "pioneer_routes_042138",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 1518,
"lead": "",
"k": []
},
{
"a": 272166,
"n": "pioneer_routes_042726",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 176,
"lead": "",
"k": []
},
{
"a": 272342,
"n": "pioneer_routes_0427D6",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 239,
"lead": "",
"k": []
},
{
"a": 273168,
"n": "overlay_metadata_042B10",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 223,
"lead": "",
"k": []
},
{
"a": 273488,
"n": "map_input_2_042C50",
"t": "M",
"m": "map_input_2*",
"p": "09",
"s": 155,
"lead": "",
"k": []
},
{
"a": 273644,
"n": "map_input_2_042CEC",
"t": "M",
"m": "map_input_2*",
"p": "09",
"s": 89,
"lead": "",
"k": []
},
{
"a": 273734,
"n": "map_input_2_042D46",
"t": "M",
"m": "map_input_2*",
"p": "09",
"s": 95,
"lead": "",
"k": []
},
{
"a": 273830,
"n": "map_input_2_042DA6",
"t": "M",
"m": "map_input_2*",
"p": "09",
"s": 83,
"lead": "",
"k": []
},
{
"a": 273914,
"n": "map_input_2_042DFA",
"t": "M",
"m": "map_input_2*",
"p": "09",
"s": 293,
"lead": "",
"k": []
},
{
"a": 274208,
"n": "map_input_2_042F20",
"t": "M",
"m": "map_input_2*",
"p": "09",
"s": 182,
"lead": "",
"k": []
},
{
"a": 274390,
"n": "map_input_2_042FD6",
"t": "M",
"m": "map_input_2*",
"p": "09",
"s": 157,
"lead": "",
"k": []
},
{
"a": 274548,
"n": "map_input_2_043074",
"t": "M",
"m": "map_input_2*",
"p": "09",
"s": 4990,
"lead": "",
"k": []
},
{
"a": 279872,
"n": "clamp_byte_at_far_ptr_to_5",
"t": "R",
"m": "menu_bar*",
"p": "0A",
"s": 21,
"lead": "",
"k": []
},
{
"a": 279894,
"n": "menu_obj_044556",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 52,
"lead": "_menu_set_font",
"k": []
},
{
"a": 279946,
"n": "menu_bar_04458A",
"t": "M",
"m": "menu_bar*",
"p": "0A",
"s": 99,
"lead": "",
"k": []
},
{
"a": 280046,
"n": "menu_bar_0445EE",
"t": "M",
"m": "menu_bar*",
"p": "0A",
"s": 86,
"lead": "",
"k": []
},
{
"a": 280132,
"n": "menu_bar_044644",
"t": "M",
"m": "menu_bar*",
"p": "0A",
"s": 313,
"lead": "",
"k": []
},
{
"a": 280446,
"n": "menu_bar_04477E",
"t": "M",
"m": "menu_bar*",
"p": "0A",
"s": 183,
"lead": "",
"k": []
},
{
"a": 280630,
"n": "menu_bar_044836",
"t": "M",
"m": "menu_bar*",
"p": "0A",
"s": 328,
"lead": "",
"k": []
},
{
"a": 280958,
"n": "_menu_bar_item",
"t": "B",
"m": "menu.obj",
"p": "0A",
"s": 69,
"lead": "",
"k": []
},
{
"a": 281028,
"n": "_menu_item",
"t": "B",
"m": "menu.obj",
"p": "0A",
"s": 149,
"lead": "",
"k": []
},
{
"a": 281178,
"n": "_menu_bar_hide",
"t": "B",
"m": "menu.obj",
"p": "0A",
"s": 56,
"lead": "",
"k": []
},
{
"a": 281234,
"n": "menu_obj_044A92",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 47,
"lead": "",
"k": []
},
{
"a": 281282,
"n": "menu_obj_044AC2",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 68,
"lead": "",
"k": []
},
{
"a": 281350,
"n": "menu_obj_044B06",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 47,
"lead": "",
"k": []
},
{
"a": 281398,
"n": "menu_obj_044B36",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 68,
"lead": "",
"k": []
},
{
"a": 281466,
"n": "menu_obj_044B7A",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 411,
"lead": "_menu_add_bar_item",
"k": []
},
{
"a": 281878,
"n": "menu_obj_044D16",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 357,
"lead": "_menu_add_item",
"k": []
},
{
"a": 282236,
"n": "menu_obj_044E7C",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 296,
"lead": "_menu_draw_bar",
"k": []
},
{
"a": 282532,
"n": "menu_obj_044FA4",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 278,
"lead": "_menu_compute_size",
"k": []
},
{
"a": 282810,
"n": "menu_obj_0450BA",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 537,
"lead": "_menu_draw_menu",
"k": []
},
{
"a": 283348,
"n": "menu_obj_0452D4",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 1559,
"lead": "@menu_bar_run",
"k": []
},
{
"a": 284908,
"n": "at_menu_bar_mouse_parse",
"t": "B",
"m": "menu.obj",
"p": "0A",
"s": 158,
"lead": "",
"k": []
},
{
"a": 285066,
"n": "menu_obj_04598A",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 147,
"lead": "",
"k": []
},
{
"a": 285214,
"n": "at_menu_key_parse",
"t": "B",
"m": "menu.obj",
"p": "0A",
"s": 198,
"lead": "",
"k": []
},
{
"a": 285412,
"n": "menu_bar_045AE4",
"t": "M",
"m": "menu_bar*",
"p": "0A",
"s": 310,
"lead": "",
"k": []
},
{
"a": 285952,
"n": "native_raid_045D00",
"t": "M",
"m": "native_raid*",
"p": "0B",
"s": 145,
"lead": "",
"k": [
"INDIANBURN"
]
},
{
"a": 286098,
"n": "native_raid_045D92",
"t": "M",
"m": "native_raid*",
"p": "0B",
"s": 95,
"lead": "",
"k": []
},
{
"a": 286194,
"n": "native_raid_045DF2",
"t": "M",
"m": "native_raid*",
"p": "0B",
"s": 529,
"lead": "",
"k": []
},
{
"a": 286724,
"n": "native_raid_046004",
"t": "M",
"m": "native_raid*",
"p": "0B",
"s": 81,
"lead": "",
"k": []
},
{
"a": 286806,
"n": "native_raid_046056",
"t": "M",
"m": "native_raid*",
"p": "0B",
"s": 162,
"lead": "",
"k": []
},
{
"a": 286968,
"n": "native_raid_0460F8",
"t": "M",
"m": "native_raid*",
"p": "0B",
"s": 969,
"lead": "",
"k": []
},
{
"a": 287938,
"n": "native_raid_0464C2",
"t": "M",
"m": "native_raid*",
"p": "0B",
"s": 305,
"lead": "",
"k": []
},
{
"a": 288760,
"n": "overlay_metadata_0467F8",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 339,
"lead": "",
"k": []
},
{
"a": 290160,
"n": "overlay_metadata_046D70",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 112,
"lead": "",
"k": []
},
{
"a": 290272,
"n": "village_trade_046DE0",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 56,
"lead": "",
"k": []
},
{
"a": 290328,
"n": "village_trade_046E18",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 167,
"lead": "",
"k": []
},
{
"a": 290496,
"n": "village_trade_046EC0",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 258,
"lead": "",
"k": [
"EXTINCT"
]
},
{
"a": 290754,
"n": "village_trade_046FC2",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 56,
"lead": "",
"k": []
},
{
"a": 290810,
"n": "village_trade_046FFA",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 4835,
"lead": "",
"k": [
"INDIANSURPRISE"
]
},
{
"a": 295646,
"n": "village_trade_0482DE",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 48,
"lead": "",
"k": []
},
{
"a": 295694,
"n": "village_trade_04830E",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 743,
"lead": "",
"k": []
},
{
"a": 296438,
"n": "village_trade_0485F6",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 804,
"lead": "",
"k": []
},
{
"a": 297242,
"n": "village_trade_04891A",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 287,
"lead": "",
"k": []
},
{
"a": 297530,
"n": "village_trade_048A3A",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 617,
"lead": "",
"k": [
"MISSION0"
]
},
{
"a": 298148,
"n": "village_trade_048CA4",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 84,
"lead": "",
"k": [
"HERESY0",
"HERESY1"
]
},
{
"a": 298232,
"n": "village_trade_048CF8",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 572,
"lead": "",
"k": []
},
{
"a": 298804,
"n": "village_trade_048F34",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 1740,
"lead": "",
"k": []
},
{
"a": 300544,
"n": "village_trade_049600",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 3451,
"lead": "",
"k": [
"TRADE0",
"BADCARGO",
"BADHAGGLE0",
"BADHAGGLE1",
"BADHAGGLE2",
"BADHAGGLE3",
"BRING",
"DEFICIT",
"BUYWHICH",
"BUY0",
"NOTENOUGH"
]
},
{
"a": 303996,
"n": "village_trade_04A37C",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 170,
"lead": "",
"k": [
"MADATWAGONS",
"GRUDGEWAGONS",
"KILLWAGONS"
]
},
{
"a": 304166,
"n": "village_trade_04A426",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 931,
"lead": "",
"k": [
"LEARNSTAY"
]
},
{
"a": 305098,
"n": "native_raze_treasure_chiefkill",
"t": "R",
"m": "village_trade*",
"p": "0C",
"s": 1077,
"lead": "",
"k": [
"CHIEFHOWDY",
"CHIEFGUIDES",
"CHIEFAREA",
"CHIEFGIFT",
"CHIEFBORED",
"CHIEFKILL",
"WELLSEASONED"
]
},
{
"a": 306176,
"n": "village_trade_04AC00",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 861,
"lead": "",
"k": [
"EXTORTSTUFF",
"EXTORTPOOR",
"EXTORTLAUGH",
"EXTORTNO"
]
},
{
"a": 307038,
"n": "village_trade_04AF5E",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 216,
"lead": "",
"k": [
"NOCONTACT",
"ALREADYSMITE",
"UNFORTUNATE",
"INDIANWARPATH2",
"INDIANWARFARE"
]
},
{
"a": 307254,
"n": "village_trade_04B036",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 722,
"lead": "",
"k": []
},
{
"a": 307976,
"n": "village_trade_04B308",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 1861,
"lead": "",
"k": [
"MADATSHIPS"
]
},
{
"a": 310692,
"n": "overlay_metadata_04BDA4",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 175,
"lead": "",
"k": []
},
{
"a": 311392,
"n": "overlay_metadata_04C060",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 144,
"lead": "",
"k": []
},
{
"a": 311536,
"n": "overlay_metadata_04C0F0",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 5,
"lead": "",
"k": []
},
{
"a": 311792,
"n": "foreign_loot_04C1F0",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 27,
"lead": "",
"k": []
},
{
"a": 311820,
"n": "foreign_loot_04C20C",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 86,
"lead": "",
"k": []
},
{
"a": 311906,
"n": "foreign_loot_04C262",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 53,
"lead": "",
"k": []
},
{
"a": 311960,
"n": "foreign_loot_04C298",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 53,
"lead": "",
"k": []
},
{
"a": 312014,
"n": "foreign_loot_04C2CE",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 55,
"lead": "",
"k": []
},
{
"a": 312070,
"n": "foreign_loot_04C306",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 84,
"lead": "",
"k": []
},
{
"a": 312154,
"n": "foreign_loot_04C35A",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 169,
"lead": "",
"k": []
},
{
"a": 312324,
"n": "foreign_loot_04C404",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 169,
"lead": "",
"k": []
},
{
"a": 312494,
"n": "foreign_loot_04C4AE",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 94,
"lead": "",
"k": []
},
{
"a": 312588,
"n": "foreign_loot_04C50C",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 37,
"lead": "",
"k": []
},
{
"a": 312626,
"n": "foreign_loot_04C532",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 100,
"lead": "",
"k": []
},
{
"a": 312726,
"n": "foreign_loot_04C596",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 42,
"lead": "",
"k": []
},
{
"a": 312768,
"n": "foreign_loot_04C5C0",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 194,
"lead": "",
"k": []
},
{
"a": 312962,
"n": "foreign_loot_04C682",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 153,
"lead": "",
"k": []
},
{
"a": 313116,
"n": "foreign_loot_04C71C",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 211,
"lead": "",
"k": []
},
{
"a": 313328,
"n": "foreign_loot_04C7F0",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 86,
"lead": "",
"k": []
},
{
"a": 313414,
"n": "foreign_loot_04C846",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 87,
"lead": "",
"k": []
},
{
"a": 313502,
"n": "foreign_loot_04C89E",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 488,
"lead": "",
"k": []
},
{
"a": 313990,
"n": "foreign_loot_04CA86",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 111,
"lead": "",
"k": []
},
{
"a": 314102,
"n": "foreign_loot_04CAF6",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 345,
"lead": "",
"k": []
},
{
"a": 314448,
"n": "foreign_loot_04CC50",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 5733,
"lead": "",
"k": []
},
{
"a": 320182,
"n": "foreign_loot_04E2B6",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 32,
"lead": "",
"k": []
},
{
"a": 320214,
"n": "foreign_loot_04E2D6",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 14975,
"lead": "",
"k": [
"LOOTFOREIGN"
]
},
{
"a": 335190,
"n": "foreign_loot_051D56",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 214,
"lead": "",
"k": []
},
{
"a": 335404,
"n": "foreign_loot_051E2C",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 186,
"lead": "",
"k": []
},
{
"a": 335590,
"n": "foreign_loot_051EE6",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 13,
"lead": "",
"k": []
},
{
"a": 335604,
"n": "foreign_loot_051EF4",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 4233,
"lead": "",
"k": []
},
{
"a": 339838,
"n": "foreign_loot_052F7E",
"t": "M",
"m": "foreign_loot*",
"p": "0D",
"s": 1472,
"lead": "",
"k": []
},
{
"a": 341588,
"n": "overlay_metadata_053654",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 15,
"lead": "",
"k": []
},
{
"a": 342048,
"n": "colony_enter_053820",
"t": "M",
"m": "colony_enter*",
"p": "0E",
"s": 531,
"lead": "",
"k": []
},
{
"a": 342580,
"n": "colony_enter_053A34",
"t": "M",
"m": "colony_enter*",
"p": "0E",
"s": 107,
"lead": "",
"k": []
},
{
"a": 342688,
"n": "colony_enter_053AA0",
"t": "M",
"m": "colony_enter*",
"p": "0E",
"s": 115,
"lead": "",
"k": []
},
{
"a": 342804,
"n": "colony_enter_053B14",
"t": "M",
"m": "colony_enter*",
"p": "0E",
"s": 18,
"lead": "",
"k": []
},
{
"a": 342822,
"n": "colony_enter_053B26",
"t": "M",
"m": "colony_enter*",
"p": "0E",
"s": 87,
"lead": "",
"k": []
},
{
"a": 342910,
"n": "colony_enter_053B7E",
"t": "M",
"m": "colony_enter*",
"p": "0E",
"s": 2439,
"lead": "",
"k": []
},
{
"a": 345349,
"n": "colony_helper_181f_c0e",
"t": "R",
"m": "colony_enter*",
"p": "0E",
"s": 4699,
"lead": "",
"k": []
},
{
"a": 350048,
"n": "data_block_misseg_5576x",
"t": "R",
"m": "colony_enter*",
"p": "0E",
"s": 11,
"lead": "",
"k": []
},
{
"a": 350059,
"n": "colony_helper_181f_cd6",
"t": "R",
"m": "colony_enter*",
"p": "0E",
"s": 2885,
"lead": "",
"k": []
},
{
"a": 353564,
"n": "data_block_misseg_5651C",
"t": "R",
"m": "(overlay-metadata)",
"p": "",
"s": 45,
"lead": "",
"k": []
},
{
"a": 353940,
"n": "data_block_misseg_56694",
"t": "R",
"m": "(overlay-metadata)",
"p": "",
"s": 811,
"lead": "",
"k": []
},
{
"a": 354832,
"n": "natives_056A10",
"t": "M",
"m": "natives*",
"p": "0F",
"s": 247,
"lead": "",
"k": []
},
{
"a": 355080,
"n": "natives_056B08",
"t": "M",
"m": "natives*",
"p": "0F",
"s": 138,
"lead": "",
"k": []
},
{
"a": 355218,
"n": "natives_056B92",
"t": "M",
"m": "natives*",
"p": "0F",
"s": 171,
"lead": "",
"k": [
"INDIANPEACE",
"INDIANCOME"
]
},
{
"a": 355390,
"n": "natives_056C3E",
"t": "M",
"m": "natives*",
"p": "0F",
"s": 1704,
"lead": "",
"k": [
"INDIANWELCOME",
"INDIANSHUN",
"INDIANWAGONS",
"INDIANCITY",
"INDIANSCONVERT",
"INDIANGIVEFOOD",
"INDIANGIVESTUFF",
"INDIANCOMMENT",
"INDIANBEGFOOD"
]
},
{
"a": 357094,
"n": "native_convert_handler",
"t": "R",
"m": "natives*",
"p": "0F",
"s": 1876,
"lead": "",
"k": []
},
{
"a": 358970,
"n": "natives_057A3A",
"t": "M",
"m": "natives*",
"p": "0F",
"s": 103,
"lead": "",
"k": []
},
{
"a": 359074,
"n": "natives_057AA2",
"t": "M",
"m": "natives*",
"p": "0F",
"s": 89,
"lead": "",
"k": [
"MEEKNESS"
]
},
{
"a": 359164,
"n": "natives_057AFC",
"t": "M",
"m": "natives*",
"p": "0F",
"s": 484,
"lead": "",
"k": []
},
{
"a": 359648,
"n": "natives_057CE0",
"t": "M",
"m": "natives*",
"p": "0F",
"s": 224,
"lead": "",
"k": []
},
{
"a": 359872,
"n": "diplomacy_sign_treaty",
"t": "R",
"m": "natives*",
"p": "0F",
"s": 397,
"lead": "",
"k": [
"SIGNTREATY"
]
},
{
"a": 360270,
"n": "diplomacy_meeting_dispatch",
"t": "R",
"m": "natives*",
"p": "0F",
"s": 7151,
"lead": "",
"k": [
"HELLOUSA",
"PIRACY",
"SIEGES",
"HEATHEN",
"APOSTATES",
"TRIBUTE",
"WANTSTUFF",
"RID",
"WORTHY",
"GIVECASH",
"PEACEUSA",
"NOTWITHDRAW",
"WITHDRAW",
"NOTHINGWITHDRAW",
"MAYBEWITHDRAW",
"PROVOKE",
"WARMANLY",
"THREATS",
"GIFTS",
"SMITEINDIANS",
"SMITEEUROPE",
"MERCENARY"
]
},
{
"a": 367422,
"n": "natives_059B3E",
"t": "M",
"m": "natives*",
"p": "0F",
"s": 81,
"lead": "",
"k": []
},
{
"a": 367504,
"n": "natives_059B90",
"t": "M",
"m": "natives*",
"p": "0F",
"s": 1662,
"lead": "",
"k": [
"SHIPSLOW",
"SHIPRUN",
"SCOUTCOLONY",
"LOSTOURSCOUTS",
"LOSTTHEIRSCOUTS",
"NOMAYORSDURINGREV"
]
},
{
"a": 369166,
"n": "colony_scout_or_mayor_check",
"t": "R",
"m": "natives*",
"p": "0F",
"s": 512,
"lead": "",
"k": []
},
{
"a": 369678,
"n": "natives_05A40E",
"t": "M",
"m": "natives*",
"p": "0F",
"s": 1107,
"lead": "",
"k": [
"TRADEMERCANTILISM",
"TRADENOCARGO",
"TRADENOWANT",
"TRADEWITH"
]
},
{
"a": 370786,
"n": "natives_05A862",
"t": "M",
"m": "natives*",
"p": "0F",
"s": 224,
"lead": "",
"k": []
},
{
"a": 371764,
"n": "data_block_misseg_5AC34",
"t": "R",
"m": "(overlay-metadata)",
"p": "",
"s": 89,
"lead": "",
"k": []
},
{
"a": 372384,
"n": "data_block_misseg_5AEA0",
"t": "R",
"m": "(overlay-metadata)",
"p": "",
"s": 140,
"lead": "",
"k": []
},
{
"a": 372524,
"n": "data_block_misseg_5AF2C",
"t": "R",
"m": "(overlay-metadata)",
"p": "",
"s": 68,
"lead": "",
"k": []
},
{
"a": 372592,
"n": "combat_aftermath_05AF70",
"t": "M",
"m": "combat_aftermath*",
"p": "10",
"s": 364,
"lead": "",
"k": []
},
{
"a": 372956,
"n": "combat_aftermath_05B0DC",
"t": "M",
"m": "combat_aftermath*",
"p": "10",
"s": 486,
"lead": "",
"k": []
},
{
"a": 373442,
"n": "combat_aftermath_05B2C2",
"t": "M",
"m": "combat_aftermath*",
"p": "10",
"s": 2925,
"lead": "",
"k": [
"LOOTCAPTURE",
"WAGONCAPTURE",
"COLONISTCAPTURE",
"COLONISTCAPTURE2",
"CARGOCAPTURE",
"DEMOTE",
"SHIPDAMAGE",
"SHIPSUNK",
"ARTILLERY",
"ARTILLERY2"
]
},
{
"a": 376368,
"n": "combat_aftermath_05BE30",
"t": "M",
"m": "combat_aftermath*",
"p": "10",
"s": 83,
"lead": "",
"k": []
},
{
"a": 376452,
"n": "native_raid_outcome_dispatch",
"t": "R",
"m": "combat_aftermath*",
"p": "10",
"s": 2006,
"lead": "",
"k": [
"RAIDNOTHING",
"RAIDWREAK",
"RAIDSTORES",
"RAIDBURN",
"RAIDSHIP",
"RAIDGOLD"
]
},
{
"a": 378458,
"n": "combat_aftermath_05C65A",
"t": "M",
"m": "combat_aftermath*",
"p": "10",
"s": 65,
"lead": "",
"k": []
},
{
"a": 378524,
"n": "combat_aftermath_05C69C",
"t": "M",
"m": "combat_aftermath*",
"p": "10",
"s": 475,
"lead": "",
"k": [
"CONTINENTAL",
"VETERAN",
"VALOR"
]
},
{
"a": 379000,
"n": "treasure_value_and_king_transport",
"t": "R",
"m": "combat_aftermath*",
"p": "10",
"s": 518,
"lead": "",
"k": [
"CASHTREASURE"
]
},
{
"a": 379518,
"n": "combat_aftermath_05CA7E",
"t": "M",
"m": "combat_aftermath*",
"p": "10",
"s": 7348,
"lead": "",
"k": [
"INDIANBOW",
"INDIANSLAVES",
"HALF",
"LOOT",
"LOOT2",
"INDIANWIN0",
"INDIANLOSE",
"INDIANWINCOLONY",
"INDIANWINCOLONY2",
"INDIANBURNCOLONY",
"INDIANBURNCOLONY2",
"CAPTURED",
"CAPTURED2",
"CAPTURED3",
"BURNED",
"BURNED2",
"BURNED3",
"EUROPEWIN",
"EUROPELOSE",
"EVASIVE",
"HOWTOWIN"
]
},
{
"a": 387040,
"n": "overlay_metadata_05E7E0",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 167,
"lead": "",
"k": []
},
{
"a": 387504,
"n": "combat_ui_05E9B0",
"t": "M",
"m": "combat_ui*",
"p": "11",
"s": 136,
"lead": "",
"k": []
},
{
"a": 387640,
"n": "combat_ui_05EA38",
"t": "M",
"m": "combat_ui*",
"p": "11",
"s": 4248,
"lead": "",
"k": []
},
{
"a": 392240,
"n": "overlay_metadata_05FC30",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 19,
"lead": "",
"k": []
},
{
"a": 392800,
"n": "trade_editor_05FE60",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 26,
"lead": "",
"k": []
},
{
"a": 392826,
"n": "trade_editor_05FE7A",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 38,
"lead": "",
"k": []
},
{
"a": 392864,
"n": "trade_editor_05FEA0",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 83,
"lead": "",
"k": []
},
{
"a": 392948,
"n": "trade_editor_05FEF4",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 306,
"lead": "",
"k": []
},
{
"a": 393254,
"n": "trade_editor_060026",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 810,
"lead": "",
"k": []
},
{
"a": 394064,
"n": "trade_editor_060350",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 50,
"lead": "",
"k": []
},
{
"a": 394114,
"n": "trade_editor_060382",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 37,
"lead": "",
"k": []
},
{
"a": 394152,
"n": "trade_editor_0603A8",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 50,
"lead": "",
"k": []
},
{
"a": 394202,
"n": "trade_editor_0603DA",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 47,
"lead": "",
"k": []
},
{
"a": 394250,
"n": "trade_editor_06040A",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 66,
"lead": "",
"k": []
},
{
"a": 394316,
"n": "trade_editor_06044C",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 33,
"lead": "",
"k": []
},
{
"a": 394350,
"n": "trade_editor_06046E",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 180,
"lead": "",
"k": []
},
{
"a": 394530,
"n": "trade_editor_060522",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 211,
"lead": "",
"k": []
},
{
"a": 394742,
"n": "trade_editor_0605F6",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 371,
"lead": "",
"k": []
},
{
"a": 395114,
"n": "trade_editor_06076A",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 208,
"lead": "",
"k": []
},
{
"a": 395322,
"n": "trade_editor_06083A",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 1017,
"lead": "",
"k": []
},
{
"a": 396340,
"n": "trade_editor_060C34",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 171,
"lead": "",
"k": []
},
{
"a": 396512,
"n": "trade_editor_060CE0",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 171,
"lead": "",
"k": []
},
{
"a": 396684,
"n": "trade_editor_060D8C",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 312,
"lead": "",
"k": [
"CARGOLOAD",
"CARGOUNLOAD"
]
},
{
"a": 396996,
"n": "trade_editor_060EC4",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 110,
"lead": "",
"k": []
},
{
"a": 397106,
"n": "trade_editor_060F32",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 137,
"lead": "",
"k": []
},
{
"a": 397244,
"n": "trade_editor_060FBC",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 243,
"lead": "",
"k": []
},
{
"a": 397488,
"n": "trade_editor_0610B0",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 566,
"lead": "",
"k": [
"TRADENAMES"
]
},
{
"a": 398054,
"n": "trade_editor_0612E6",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 366,
"lead": "",
"k": [
"TRADEDELETE"
]
},
{
"a": 398420,
"n": "lost_city_rumor_outcome",
"t": "R",
"m": "trade_editor*",
"p": "12",
"s": 2121,
"lead": "",
"k": [
"SCREWED"
]
},
{
"a": 400912,
"n": "pathfind_061E10",
"t": "M",
"m": "pathfind*",
"p": "13",
"s": 133,
"lead": "",
"k": []
},
{
"a": 401046,
"n": "pathfind_061E96",
"t": "M",
"m": "pathfind*",
"p": "13",
"s": 107,
"lead": "",
"k": []
},
{
"a": 401154,
"n": "pathfind_061F02",
"t": "M",
"m": "pathfind*",
"p": "13",
"s": 2067,
"lead": "",
"k": []
},
{
"a": 403222,
"n": "pathfind_062716",
"t": "M",
"m": "pathfind*",
"p": "13",
"s": 168,
"lead": "",
"k": []
},
{
"a": 403390,
"n": "pathfind_0627BE",
"t": "M",
"m": "pathfind*",
"p": "13",
"s": 415,
"lead": "",
"k": []
},
{
"a": 403806,
"n": "pathfind_06295E",
"t": "M",
"m": "pathfind*",
"p": "13",
"s": 1061,
"lead": "",
"k": []
},
{
"a": 404868,
"n": "pathfind_062D84",
"t": "M",
"m": "pathfind*",
"p": "13",
"s": 1618,
"lead": "",
"k": []
},
{
"a": 407680,
"n": "map_6_obj_063880",
"t": "M",
"m": "map_6.obj",
"p": "14",
"s": 855,
"lead": "_map_find_continents",
"k": []
},
{
"a": 408536,
"n": "mapgen_063BD8",
"t": "M",
"m": "mapgen*",
"p": "14",
"s": 127,
"lead": "",
"k": []
},
{
"a": 408664,
"n": "mapgen_063C58",
"t": "M",
"m": "mapgen*",
"p": "14",
"s": 740,
"lead": "",
"k": []
},
{
"a": 409404,
"n": "mapgen_063F3C",
"t": "M",
"m": "mapgen*",
"p": "14",
"s": 535,
"lead": "",
"k": []
},
{
"a": 409940,
"n": "mapgen_064154",
"t": "M",
"m": "mapgen*",
"p": "14",
"s": 151,
"lead": "",
"k": []
},
{
"a": 410092,
"n": "mapgen_0641EC",
"t": "M",
"m": "mapgen*",
"p": "14",
"s": 122,
"lead": "",
"k": []
},
{
"a": 410214,
"n": "mapgen_064266",
"t": "M",
"m": "mapgen*",
"p": "14",
"s": 261,
"lead": "",
"k": []
},
{
"a": 410476,
"n": "mapgen_06436C",
"t": "M",
"m": "mapgen*",
"p": "14",
"s": 140,
"lead": "",
"k": []
},
{
"a": 410616,
"n": "mapgen_0643F8",
"t": "M",
"m": "mapgen*",
"p": "14",
"s": 315,
"lead": "",
"k": []
},
{
"a": 410932,
"n": "mapgen_064534",
"t": "M",
"m": "mapgen*",
"p": "14",
"s": 194,
"lead": "",
"k": []
},
{
"a": 411126,
"n": "mapgen_0645F6",
"t": "M",
"m": "mapgen*",
"p": "14",
"s": 1050,
"lead": "",
"k": []
},
{
"a": 412176,
"n": "map_generate_new_world",
"t": "R",
"m": "mapgen*",
"p": "14",
"s": 4886,
"lead": "",
"k": []
},
{
"a": 417062,
"n": "mapgen_065D26",
"t": "M",
"m": "mapgen*",
"p": "14",
"s": 2387,
"lead": "",
"k": []
},
{
"a": 419920,
"n": "map_render_066850",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 51,
"lead": "",
"k": []
},
{
"a": 419972,
"n": "map_render_066884",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 228,
"lead": "",
"k": []
},
{
"a": 420200,
"n": "map_render_066968",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 558,
"lead": "",
"k": []
},
{
"a": 420758,
"n": "me_mini_obj_066B96",
"t": "M",
"m": "me_mini.obj",
"p": "15",
"s": 26,
"lead": "_blast_mini",
"k": []
},
{
"a": 420784,
"n": "me_mini_obj_066BB0",
"t": "M",
"m": "me_mini.obj",
"p": "15",
"s": 293,
"lead": "_show_mini_region",
"k": []
},
{
"a": 421078,
"n": "map_render_066CD6",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 310,
"lead": "",
"k": []
},
{
"a": 421388,
"n": "_conform_to_view",
"t": "B",
"m": "map_2.obj",
"p": "15",
"s": 70,
"lead": "",
"k": []
},
{
"a": 421458,
"n": "_conform_to_view_size",
"t": "B",
"m": "map_2.obj",
"p": "15",
"s": 118,
"lead": "",
"k": []
},
{
"a": 421576,
"n": "map_2_obj_066EC8",
"t": "M",
"m": "map_2.obj",
"p": "15",
"s": 159,
"lead": "_update_terrain_region",
"k": []
},
{
"a": 421736,
"n": "map_2_obj_066F68",
"t": "M",
"m": "map_2.obj",
"p": "15",
"s": 211,
"lead": "_show_map_gradually",
"k": []
},
{
"a": 421948,
"n": "map_2_obj_06703C",
"t": "M",
"m": "map_2.obj",
"p": "15",
"s": 69,
"lead": "_show_map_region",
"k": []
},
{
"a": 422018,
"n": "map_render_067082",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 256,
"lead": "",
"k": []
},
{
"a": 422274,
"n": "map_render_067182",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 350,
"lead": "",
"k": []
},
{
"a": 422624,
"n": "map_render_0672E0",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 236,
"lead": "",
"k": []
},
{
"a": 422860,
"n": "map_render_0673CC",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 169,
"lead": "",
"k": []
},
{
"a": 423030,
"n": "map_render_067476",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 50,
"lead": "",
"k": []
},
{
"a": 423080,
"n": "map_render_0674A8",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 147,
"lead": "",
"k": []
},
{
"a": 423228,
"n": "map_render_06753C",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 264,
"lead": "",
"k": []
},
{
"a": 423492,
"n": "map_render_067644",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 188,
"lead": "",
"k": []
},
{
"a": 423680,
"n": "map_render_067700",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 202,
"lead": "",
"k": []
},
{
"a": 423882,
"n": "map_render_0677CA",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 178,
"lead": "",
"k": []
},
{
"a": 424060,
"n": "map_a_obj_06787C",
"t": "M",
"m": "map_a.obj",
"p": "15",
"s": 423,
"lead": "@compute_view_parameters",
"k": []
},
{
"a": 424484,
"n": "analyse_connections_road_river",
"t": "R",
"m": "map_render*",
"p": "15",
"s": 352,
"lead": "",
"k": []
},
{
"a": 424836,
"n": "nmask4_feature",
"t": "R",
"m": "map_render*",
"p": "15",
"s": 96,
"lead": "",
"k": []
},
{
"a": 424932,
"n": "map_render_067BE4",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 111,
"lead": "",
"k": []
},
{
"a": 425044,
"n": "map_render_067C54",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 57,
"lead": "",
"k": []
},
{
"a": 425102,
"n": "nmask4_forest",
"t": "R",
"m": "map_render*",
"p": "15",
"s": 102,
"lead": "",
"k": []
},
{
"a": 425204,
"n": "map_render_067CF4",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 96,
"lead": "",
"k": []
},
{
"a": 425300,
"n": "nmask8_terrain",
"t": "R",
"m": "map_render*",
"p": "15",
"s": 116,
"lead": "",
"k": []
},
{
"a": 425416,
"n": "render_subcell_place",
"t": "R",
"m": "map_render*",
"p": "15",
"s": 95,
"lead": "",
"k": []
},
{
"a": 425512,
"n": "emit_ground_sprite",
"t": "R",
"m": "map_render*",
"p": "15",
"s": 99,
"lead": "",
"k": []
},
{
"a": 425612,
"n": "map_render_067E8C",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 95,
"lead": "",
"k": []
},
{
"a": 425708,
"n": "emit_terrain_sprite",
"t": "R",
"m": "map_render*",
"p": "15",
"s": 99,
"lead": "",
"k": []
},
{
"a": 425808,
"n": "tile_compose_subcells_O512",
"t": "R",
"m": "map_render*",
"p": "15",
"s": 599,
"lead": "",
"k": []
},
{
"a": 426408,
"n": "tile_dispatch_O513",
"t": "R",
"m": "map_render*",
"p": "15",
"s": 1076,
"lead": "",
"k": []
},
{
"a": 427484,
"n": "map_view_render_O514",
"t": "R",
"m": "map_a.obj",
"p": "15",
"s": 699,
"lead": "@generate_terrain_map_region",
"k": []
},
{
"a": 428184,
"n": "map_a_obj_068898",
"t": "M",
"m": "map_a.obj",
"p": "15",
"s": 149,
"lead": "@generate_terrain_map",
"k": []
},
{
"a": 428334,
"n": "map_render_06892E",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 75,
"lead": "",
"k": []
},
{
"a": 428564,
"n": "overlay_metadata_068A14",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 15,
"lead": "",
"k": []
},
{
"a": 429792,
"n": "dialog_pedia_068EE0",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 87,
"lead": "",
"k": []
},
{
"a": 429880,
"n": "dialog_pedia_068F38",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 104,
"lead": "",
"k": []
},
{
"a": 429984,
"n": "dialog_pedia_068FA0",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 59,
"lead": "",
"k": []
},
{
"a": 430044,
"n": "dialog_pedia_068FDC",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 124,
"lead": "",
"k": []
},
{
"a": 430168,
"n": "dialog_pedia_069058",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 253,
"lead": "",
"k": []
},
{
"a": 430422,
"n": "dialog_pedia_069156",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 78,
"lead": "",
"k": []
},
{
"a": 430500,
"n": "dialog_pedia_0691A4",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 117,
"lead": "",
"k": []
},
{
"a": 430618,
"n": "dialog_pedia_06921A",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 97,
"lead": "",
"k": []
},
{
"a": 430716,
"n": "dialog_pedia_06927C",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 32,
"lead": "",
"k": []
},
{
"a": 430748,
"n": "dialog_pedia_06929C",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 207,
"lead": "",
"k": []
},
{
"a": 430956,
"n": "dialog_pedia_06936C",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 322,
"lead": "",
"k": []
},
{
"a": 431278,
"n": "dialog_pedia_0694AE",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 535,
"lead": "",
"k": []
},
{
"a": 431814,
"n": "dialog_pedia_0696C6",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 1733,
"lead": "",
"k": []
},
{
"a": 433548,
"n": "dialog_pedia_069D8C",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 2420,
"lead": "",
"k": []
},
{
"a": 435968,
"n": "dialog_pedia_06A700",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 904,
"lead": "",
"k": []
},
{
"a": 436872,
"n": "dialog_pedia_06AA88",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 895,
"lead": "",
"k": []
},
{
"a": 437768,
"n": "dialog_pedia_06AE08",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 276,
"lead": "",
"k": []
},
{
"a": 438044,
"n": "dialog_pedia_06AF1C",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 270,
"lead": "",
"k": []
},
{
"a": 438314,
"n": "dialog_pedia_06B02A",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 472,
"lead": "",
"k": []
},
{
"a": 438786,
"n": "dialog_pedia_06B202",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 406,
"lead": "",
"k": []
},
{
"a": 439192,
"n": "dialog_pedia_06B398",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 854,
"lead": "",
"k": []
},
{
"a": 440046,
"n": "dialog_pedia_06B6EE",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 52,
"lead": "",
"k": []
},
{
"a": 440098,
"n": "dialog_pedia_06B722",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 975,
"lead": "",
"k": []
},
{
"a": 441620,
"n": "overlay_metadata_06BD14",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 85,
"lead": "",
"k": []
},
{
"a": 441936,
"n": "popup_engine_06BE50",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 65,
"lead": "",
"k": []
},
{
"a": 442002,
"n": "popup_engine_06BE92",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 127,
"lead": "",
"k": []
},
{
"a": 442130,
"n": "popup_engine_06BF12",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 41,
"lead": "",
"k": []
},
{
"a": 442172,
"n": "popup_engine_06BF3C",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 41,
"lead": "",
"k": []
},
{
"a": 442214,
"n": "popup_engine_06BF66",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 550,
"lead": "",
"k": []
},
{
"a": 442764,
"n": "popup_engine_06C18C",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 147,
"lead": "",
"k": []
},
{
"a": 442912,
"n": "popup_engine_06C220",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 27,
"lead": "",
"k": []
},
{
"a": 442940,
"n": "popup_engine_06C23C",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 24,
"lead": "",
"k": []
},
{
"a": 442964,
"n": "popup_engine_06C254",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 40,
"lead": "",
"k": []
},
{
"a": 443004,
"n": "popup_obj_06C27C",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 25,
"lead": "_popup_num",
"k": []
},
{
"a": 443030,
"n": "popup_obj_06C296",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 63,
"lead": "_popup_set_font",
"k": []
},
{
"a": 443094,
"n": "popup_engine_06C2D6",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 112,
"lead": "",
"k": []
},
{
"a": 443206,
"n": "popup_engine_06C346",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 65,
"lead": "",
"k": []
},
{
"a": 443272,
"n": "popup_engine_06C388",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 265,
"lead": "",
"k": []
},
{
"a": 443538,
"n": "popup_engine_06C492",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 141,
"lead": "",
"k": []
},
{
"a": 443680,
"n": "popup_engine_06C520",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 458,
"lead": "",
"k": []
},
{
"a": 444138,
"n": "popup_engine_06C6EA",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 96,
"lead": "",
"k": []
},
{
"a": 444234,
"n": "popup_engine_06C74A",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 47,
"lead": "",
"k": []
},
{
"a": 444282,
"n": "popup_engine_06C77A",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 47,
"lead": "",
"k": []
},
{
"a": 444330,
"n": "_popup_release_all_grey",
"t": "B",
"m": "popup.obj",
"p": "17",
"s": 48,
"lead": "",
"k": []
},
{
"a": 444378,
"n": "_popup_read_check",
"t": "B",
"m": "popup.obj",
"p": "17",
"s": 47,
"lead": "",
"k": []
},
{
"a": 444426,
"n": "_popup_write_check",
"t": "B",
"m": "popup.obj",
"p": "17",
"s": 39,
"lead": "",
"k": []
},
{
"a": 444466,
"n": "popup_obj_06C832",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 29,
"lead": "_popup_set_active_item",
"k": []
},
{
"a": 444496,
"n": "popup_obj_06C850",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 488,
"lead": "_popup_add_item",
"k": []
},
{
"a": 444984,
"n": "_popup_add_check",
"t": "B",
"m": "popup.obj",
"p": "17",
"s": 58,
"lead": "",
"k": []
},
{
"a": 445042,
"n": "popup_obj_06CA72",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 15,
"lead": "_popup_set_width",
"k": []
},
{
"a": 445058,
"n": "popup_obj_06CA82",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 274,
"lead": "_popup_add_string",
"k": []
},
{
"a": 445332,
"n": "popup_obj_06CB94",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 465,
"lead": "_popup_add_entry",
"k": []
},
{
"a": 445798,
"n": "popup_obj_06CD66",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 37,
"lead": "",
"k": []
},
{
"a": 445836,
"n": "popup_obj_06CD8C",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 494,
"lead": "_popup_add_sprite",
"k": []
},
{
"a": 446330,
"n": "popup_obj_06CF7A",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 65,
"lead": "",
"k": []
},
{
"a": 446396,
"n": "popup_obj_06CFBC",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 43,
"lead": "",
"k": []
},
{
"a": 446440,
"n": "popup_obj_06CFE8",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 814,
"lead": "",
"k": []
},
{
"a": 447254,
"n": "popup_obj_06D316",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 1398,
"lead": "",
"k": []
},
{
"a": 448652,
"n": "popup_obj_06D88C",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 59,
"lead": "",
"k": []
},
{
"a": 448712,
"n": "popup_obj_06D8C8",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 112,
"lead": "_popup_help_draw",
"k": []
},
{
"a": 448824,
"n": "popup_obj_06D938",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 148,
"lead": "_popup_big_sprite",
"k": []
},
{
"a": 448972,
"n": "popup_obj_06D9CC",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 664,
"lead": "",
"k": []
},
{
"a": 449636,
"n": "popup_obj_06DC64",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 522,
"lead": "",
"k": []
},
{
"a": 450158,
"n": "popup_obj_06DE6E",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 601,
"lead": "",
"k": []
},
{
"a": 450760,
"n": "popup_obj_06E0C8",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 534,
"lead": "_popup_box_draw",
"k": []
},
{
"a": 451294,
"n": "_popup_draw",
"t": "B",
"m": "popup.obj",
"p": "17",
"s": 207,
"lead": "",
"k": []
},
{
"a": 451502,
"n": "popup_obj_06E3AE",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 34,
"lead": "_popup_set_active_sprite",
"k": []
},
{
"a": 451536,
"n": "popup_obj_06E3D0",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 2820,
"lead": "@popup_exec",
"k": []
},
{
"a": 454356,
"n": "popup_obj_06EED4",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 24,
"lead": "",
"k": []
},
{
"a": 454380,
"n": "popup_obj_06EEEC",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 520,
"lead": "",
"k": []
},
{
"a": 454900,
"n": "popup_obj_06F0F4",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 1061,
"lead": "@popup_start_box",
"k": []
},
{
"a": 455962,
"n": "popup_obj_06F51A",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 57,
"lead": "",
"k": []
},
{
"a": 456020,
"n": "at_pop_set",
"t": "B",
"m": "popup.obj",
"p": "17",
"s": 42,
"lead": "",
"k": []
},
{
"a": 456062,
"n": "popup_obj_06F57E",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 49,
"lead": "@pop_get",
"k": []
},
{
"a": 456112,
"n": "popup_engine_06F5B0",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 41,
"lead": "",
"k": []
},
{
"a": 456154,
"n": "popup_obj_06F5DA",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 24,
"lead": "_popk",
"k": []
},
{
"a": 456178,
"n": "popup_engine_06F5F2",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 41,
"lead": "",
"k": []
},
{
"a": 456220,
"n": "popup_engine_06F61C",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 48,
"lead": "",
"k": []
},
{
"a": 456268,
"n": "popup_obj_06F64C",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 75,
"lead": "@popup_ask",
"k": []
},
{
"a": 456344,
"n": "popup_engine_06F698",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 65,
"lead": "",
"k": []
},
{
"a": 456410,
"n": "popup_engine_06F6DA",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 372,
"lead": "",
"k": []
},
{
"a": 456928,
"n": "text_widget_06F8E0",
"t": "M",
"m": "text_widget*",
"p": "18",
"s": 26,
"lead": "",
"k": []
},
{
"a": 456954,
"n": "text_widget_06F8FA",
"t": "M",
"m": "text_widget*",
"p": "18",
"s": 447,
"lead": "",
"k": []
},
{
"a": 457402,
"n": "_text_item_binary",
"t": "B",
"m": "text.obj",
"p": "18",
"s": 46,
"lead": "",
"k": []
},
{
"a": 457448,
"n": "_text_search",
"t": "B",
"m": "text.obj",
"p": "18",
"s": 74,
"lead": "",
"k": []
},
{
"a": 457892,
"n": "overlay_metadata_06FCA4",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 195,
"lead": "",
"k": []
},
{
"a": 458224,
"n": "multiplayer_06FDF0",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 44,
"lead": "",
"k": []
},
{
"a": 458268,
"n": "multiplayer_06FE1C",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 376,
"lead": "",
"k": []
},
{
"a": 458644,
"n": "multiplayer_06FF94",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 204,
"lead": "",
"k": []
},
{
"a": 458848,
"n": "multiplayer_070060",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 607,
"lead": "",
"k": []
},
{
"a": 459456,
"n": "multiplayer_0702C0",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 66,
"lead": "",
"k": []
},
{
"a": 459522,
"n": "multiplayer_070302",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 402,
"lead": "",
"k": []
},
{
"a": 459924,
"n": "multiplayer_070494",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 236,
"lead": "",
"k": []
},
{
"a": 460160,
"n": "multiplayer_070580",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 514,
"lead": "",
"k": []
},
{
"a": 460674,
"n": "multiplayer_070782",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 51,
"lead": "",
"k": []
},
{
"a": 460726,
"n": "multiplayer_0707B6",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 376,
"lead": "",
"k": []
},
{
"a": 461102,
"n": "multiplayer_07092E",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 236,
"lead": "",
"k": []
},
{
"a": 461338,
"n": "multiplayer_070A1A",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 594,
"lead": "",
"k": []
},
{
"a": 461932,
"n": "multiplayer_070C6C",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 72,
"lead": "",
"k": []
},
{
"a": 462004,
"n": "multiplayer_070CB4",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 308,
"lead": "",
"k": []
},
{
"a": 462312,
"n": "multiplayer_070DE8",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 209,
"lead": "",
"k": []
},
{
"a": 462522,
"n": "multiplayer_070EBA",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 317,
"lead": "",
"k": [
"MULTI"
]
},
{
"a": 462840,
"n": "map_9_obj_070FF8",
"t": "M",
"m": "map_9.obj",
"p": "19",
"s": 202,
"lead": "@allocate_map_memory",
"k": []
},
{
"a": 463042,
"n": "at_map_check",
"t": "B",
"m": "map_9.obj",
"p": "19",
"s": 68,
"lead": "",
"k": []
},
{
"a": 463110,
"n": "multiplayer_071106",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 320,
"lead": "",
"k": []
},
{
"a": 463430,
"n": "multiplayer_071246",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 266,
"lead": "",
"k": []
},
{
"a": 463696,
"n": "map_9_obj_071350",
"t": "M",
"m": "map_9.obj",
"p": "19",
"s": 131,
"lead": "_create_blank_map",
"k": []
},
{
"a": 463828,
"n": "multiplayer_0713D4",
"t": "M",
"m": "multiplayer*",
"p": "19",
"s": 178,
"lead": "",
"k": []
},
{
"a": 464360,
"n": "overlay_metadata_0715E8",
"t": "M",
"m": "(overlay-metadata)",
"p": "",
"s": 59,
"lead": "",
"k": []
},
{
"a": 467088,
"n": "boot_save_072090",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 2826,
"lead": "",
"k": []
},
{
"a": 469914,
"n": "boot_save_072B9A",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 222,
"lead": "",
"k": []
},
{
"a": 470136,
"n": "boot_save_072C78",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 44,
"lead": "",
"k": []
},
{
"a": 470180,
"n": "boot_save_072CA4",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 29,
"lead": "",
"k": []
},
{
"a": 470210,
"n": "boot_save_072CC2",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 696,
"lead": "",
"k": []
},
{
"a": 470906,
"n": "save_orchestrator",
"t": "R",
"m": "boot_save*",
"p": "1A",
"s": 478,
"lead": "",
"k": [
"SAVEGAME"
]
},
{
"a": 471384,
"n": "boot_save_073158",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 280,
"lead": "",
"k": [
"LOADGAME"
]
},
{
"a": 471664,
"n": "boot_save_073270",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 648,
"lead": "",
"k": []
},
{
"a": 472312,
"n": "save_serializer",
"t": "R",
"m": "boot_save*",
"p": "1A",
"s": 1464,
"lead": "",
"k": []
},
{
"a": 473776,
"n": "boot_save_073AB0",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 256,
"lead": "",
"k": []
},
{
"a": 474032,
"n": "load_deserializer",
"t": "R",
"m": "boot_save*",
"p": "1A",
"s": 1901,
"lead": "",
"k": []
},
{
"a": 475934,
"n": "boot_save_07431E",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 722,
"lead": "",
"k": [
"NATION0A"
]
},
{
"a": 476656,
"n": "boot_save_0745F0",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 91,
"lead": "",
"k": []
},
{
"a": 476748,
"n": "boot_save_07464C",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 60,
"lead": "",
"k": []
},
{
"a": 476808,
"n": "boot_save_074688",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 856,
"lead": "",
"k": []
},
{
"a": 477664,
"n": "boot_save_0749E0",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 2417,
"lead": "",
"k": []
},
{
"a": 480082,
"n": "boot_save_075352",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 578,
"lead": "",
"k": []
},
{
"a": 480660,
"n": "boot_save_075594",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 55,
"lead": "",
"k": [
"VICEROY"
]
},
{
"a": 480716,
"n": "new_game_state_init",
"t": "R",
"m": "boot_save*",
"p": "1A",
"s": 1052,
"lead": "",
"k": []
},
{
"a": 481768,
"n": "boot_save_0759E8",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 1455,
"lead": "",
"k": [
"MAPTOLOAD"
]
},
{
"a": 483224,
"n": "boot_save_075F98",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 30,
"lead": "",
"k": []
},
{
"a": 483254,
"n": "boot_save_075FB6",
"t": "M",
"m": "boot_save*",
"p": "1A",
"s": 1039,
"lead": "",
"k": []
},
{
"a": 484560,
"n": "engine_io_0764D0",
"t": "M",
"m": "engine_io*",
"p": "1B",
"s": 33,
"lead": "",
"k": []
},
{
"a": 484594,
"n": "engine_io_0764F2",
"t": "M",
"m": "engine_io*",
"p": "1B",
"s": 49,
"lead": "",
"k": []
},
{
"a": 484644,
"n": "engine_io_076524",
"t": "M",
"m": "engine_io*",
"p": "1B",
"s": 111,
"lead": "",
"k": []
},
{
"a": 484756,
"n": "engine_io_076594",
"t": "M",
"m": "engine_io*",
"p": "1B",
"s": 174,
"lead": "",
"k": []
},
{
"a": 484930,
"n": "engine_io_076642",
"t": "M",
"m": "engine_io*",
"p": "1B",
"s": 1194,
"lead": "",
"k": []
},
{
"a": 486124,
"n": "engine_io_076AEC",
"t": "M",
"m": "engine_io*",
"p": "1B",
"s": 178,
"lead": "",
"k": []
},
{
"a": 486302,
"n": "engine_io_076B9E",
"t": "M",
"m": "engine_io*",
"p": "1B",
"s": 210,
"lead": "",
"k": []
},
{
"a": 486512,
"n": "engine_io_076C70",
"t": "M",
"m": "engine_io*",
"p": "1B",
"s": 254,
"lead": "",
"k": []
},
{
"a": 486992,
"n": "engine_loader_076E50",
"t": "M",
"m": "engine_loader*",
"p": "1C",
"s": 521,
"lead": "",
"k": []
},
{
"a": 487514,
"n": "loader_1_c_07705A",
"t": "M",
"m": "loader_1.c",
"p": "1C",
"s": 18,
"lead": "@loader_set_priority",
"k": []
},
{
"a": 487532,
"n": "loader_1_c_07706C",
"t": "M",
"m": "loader_1.c",
"p": "1C",
"s": 148,
"lead": "@loader_close",
"k": []
},
{
"a": 487680,
"n": "engine_loader_077100",
"t": "M",
"m": "engine_loader*",
"p": "1C",
"s": 441,
"lead": "",
"k": []
},
{
"a": 488122,
"n": "_far_to_near",
"t": "B",
"m": "pack_6.c",
"p": "1C",
"s": 10,
"lead": "",
"k": []
},
{
"a": 488132,
"n": "engine_loader_0772C4",
"t": "M",
"m": "engine_loader*",
"p": "1C",
"s": 21,
"lead": "",
"k": []
},
{
"a": 488154,
"n": "pack_6_c_0772DA",
"t": "M",
"m": "pack_6.c",
"p": "1C",
"s": 31,
"lead": "_pack_set_special_buffer",
"k": []
},
{
"a": 488186,
"n": "pack_6_c_0772FA",
"t": "M",
"m": "pack_6.c",
"p": "1C",
"s": 754,
"lead": "@pack_data",
"k": []
},
{
"a": 488940,
"n": "fileio_9_c_0775EC",
"t": "M",
"m": "fileio_9.c",
"p": "1C",
"s": 263,
"lead": "@fileio_fwrite_f",
"k": []
},
{
"a": 489204,
"n": "at_pack_raw_copy",
"t": "B",
"m": "pack_5.c",
"p": "1C",
"s": 125,
"lead": "",
"k": []
},
{
"a": 489330,
"n": "at_pack_a_packet",
"t": "B",
"m": "pack_5.c",
"p": "1C",
"s": 255,
"lead": "",
"k": []
},
{
"a": 489872,
"n": "engine_error_077990",
"t": "M",
"m": "engine_error*",
"p": "1D",
"s": 164,
"lead": "",
"k": []
},
{
"a": 490036,
"n": "engine_error_077A34",
"t": "M",
"m": "engine_error*",
"p": "1D",
"s": 169,
"lead": "",
"k": []
},
{
"a": 490206,
"n": "engine_error_077ADE",
"t": "M",
"m": "engine_error*",
"p": "1D",
"s": 49,
"lead": "",
"k": []
},
{
"a": 490256,
"n": "engine_error_077B10",
"t": "M",
"m": "engine_error*",
"p": "1D",
"s": 590,
"lead": "",
"k": []
},
{
"a": 490846,
"n": "error_1_c_077D5E",
"t": "M",
"m": "error_1.c",
"p": "1D",
"s": 162,
"lead": "@error_report",
"k": []
},
{
"a": 491216,
"n": "mcga_c_c_077ED0",
"t": "M",
"m": "mcga_c.c",
"p": "1E",
"s": 106,
"lead": "@mcga_time_palette_swap",
"k": []
},
{
"a": 491322,
"n": "engine_video_077F3A",
"t": "M",
"m": "engine_video*",
"p": "1E",
"s": 302,
"lead": "",
"k": []
},
{
"a": 491624,
"n": "ui_input_cursor_helper",
"t": "R",
"m": "engine_video*",
"p": "1E",
"s": 218,
"lead": "",
"k": []
},
{
"a": 491842,
"n": "engine_video_078142",
"t": "M",
"m": "engine_video*",
"p": "1E",
"s": 66,
"lead": "",
"k": []
},
{
"a": 491908,
"n": "engine_video_078184",
"t": "M",
"m": "engine_video*",
"p": "1E",
"s": 90,
"lead": "",
"k": []
},
{
"a": 491998,
"n": "engine_video_0781DE",
"t": "M",
"m": "engine_video*",
"p": "1E",
"s": 100,
"lead": "",
"k": []
},
{
"a": 492098,
"n": "engine_video_078242",
"t": "M",
"m": "engine_video*",
"p": "1E",
"s": 39,
"lead": "",
"k": []
},
{
"a": 492138,
"n": "engine_video_07826A",
"t": "M",
"m": "engine_video*",
"p": "1E",
"s": 176,
"lead": "",
"k": []
},
{
"a": 492314,
"n": "engine_video_07831A",
"t": "M",
"m": "engine_video*",
"p": "1E",
"s": 202,
"lead": "",
"k": []
},
{
"a": 492516,
"n": "engine_video_0783E4",
"t": "M",
"m": "engine_video*",
"p": "1E",
"s": 118,
"lead": "",
"k": []
},
{
"a": 492634,
"n": "engine_video_07845A",
"t": "M",
"m": "engine_video*",
"p": "1E",
"s": 238,
"lead": "",
"k": []
},
{
"a": 492872,
"n": "at_mcga_getpal",
"t": "B",
"m": "mcga_8.c",
"p": "1E",
"s": 77,
"lead": "",
"k": []
},
{
"a": 492949,
"n": "engine_video_078595",
"t": "M",
"m": "engine_video*",
"p": "1E",
"s": 2,
"lead": "",
"k": []
},
{
"a": 493120,
"n": "engine_overlay_078640",
"t": "M",
"m": "engine_overlay*",
"p": "1F",
"s": 189,
"lead": "",
"k": []
},
{
"a": 493310,
"n": "engine_overlay_0786FE",
"t": "M",
"m": "engine_overlay*",
"p": "1F",
"s": 163,
"lead": "",
"k": []
},
{
"a": 493474,
"n": "engine_overlay_0787A2",
"t": "M",
"m": "engine_overlay*",
"p": "1F",
"s": 58,
"lead": "",
"k": []
},
{
"a": 493532,
"n": "engine_overlay_0787DC",
"t": "M",
"m": "engine_overlay*",
"p": "1F",
"s": 66,
"lead": "",
"k": []
},
{
"a": 493598,
"n": "engine_overlay_07881E",
"t": "M",
"m": "engine_overlay*",
"p": "1F",
"s": 55,
"lead": "",
"k": []
},
{
"a": 493654,
"n": "engine_overlay_078856",
"t": "M",
"m": "engine_overlay*",
"p": "1F",
"s": 28,
"lead": "",
"k": []
},
{
"a": 493682,
"n": "engine_overlay_078872",
"t": "M",
"m": "engine_overlay*",
"p": "1F",
"s": 391,
"lead": "",
"k": []
},
{
"a": 494074,
"n": "engine_overlay_0789FA",
"t": "M",
"m": "engine_overlay*",
"p": "1F",
"s": 80,
"lead": "",
"k": []
},
{
"a": 494154,
"n": "at_mem_adjust",
"t": "B",
"m": "mem_2.c",
"p": "1F",
"s": 168,
"lead": "",
"k": []
},
{
"a": 494322,
"n": "coreleft_max",
"t": "R",
"m": "engine_overlay*",
"p": "1F",
"s": 28,
"lead": "",
"k": []
},
{
"a": 494350,
"n": "engine_overlay_078B0E",
"t": "M",
"m": "engine_overlay*",
"p": "1F",
"s": 48,
"lead": "",
"k": []
},
{
"a": 494398,
"n": "overlay_thunk_1a1f_e90",
"t": "R",
"m": "engine_overlay*",
"p": "1F",
"s": 144,
"lead": "",
"k": []
},
{
"a": 494542,
"n": "at_heap_declare",
"t": "B",
"m": "heap_1.c",
"p": "1F",
"s": 62,
"lead": "",
"k": []
},
{
"a": 494604,
"n": "heap_1_c_078C0C",
"t": "M",
"m": "heap_1.c",
"p": "1F",
"s": 59,
"lead": "",
"k": []
},
{
"a": 494664,
"n": "heap_1_c_078C48",
"t": "M",
"m": "heap_1.c",
"p": "1F",
"s": 105,
"lead": "@heap_get",
"k": []
},
{
"a": 494770,
"n": "at_heap_shrink",
"t": "B",
"m": "heap_1.c",
"p": "1F",
"s": 137,
"lead": "",
"k": []
},
{
"a": 494907,
"n": "engine_overlay_078D3B",
"t": "M",
"m": "engine_overlay*",
"p": "1F",
"s": 2,
"lead": "",
"k": []
}
],
"pages": [
{
"id": "01",
"a": 134880,
"z": 15632
},
{
"id": "02",
"a": 153856,
"z": 29184
},
{
"id": "03",
"a": 184272,
"z": 11040
},
{
"id": "04",
"a": 197968,
"z": 25664
},
{
"id": "05",
"a": 226112,
"z": 16448
},
{
"id": "06",
"a": 243968,
"z": 12640
},
{
"id": "07",
"a": 257264,
"z": 5120
},
{
"id": "08",
"a": 263344,
"z": 9248
},
{
"id": "09",
"a": 273488,
"z": 6064
},
{
"id": "0A",
"a": 279872,
"z": 5856
},
{
"id": "0B",
"a": 285952,
"z": 2304
},
{
"id": "0C",
"a": 290272,
"z": 19568
},
{
"id": "0D",
"a": 311792,
"z": 29520
},
{
"id": "0E",
"a": 342048,
"z": 10896
},
{
"id": "0F",
"a": 354832,
"z": 16192
},
{
"id": "10",
"a": 372592,
"z": 14288
},
{
"id": "11",
"a": 387504,
"z": 4384
},
{
"id": "12",
"a": 392800,
"z": 7744
},
{
"id": "13",
"a": 400912,
"z": 5584
},
{
"id": "14",
"a": 407680,
"z": 11776
},
{
"id": "15",
"a": 419920,
"z": 8496
},
{
"id": "16",
"a": 429792,
"z": 11296
},
{
"id": "17",
"a": 441936,
"z": 14848
},
{
"id": "18",
"a": 456928,
"z": 608
},
{
"id": "19",
"a": 458224,
"z": 5792
},
{
"id": "1A",
"a": 467088,
"z": 17216
},
{
"id": "1B",
"a": 484560,
"z": 2208
},
{
"id": "1C",
"a": 486992,
"z": 2608
},
{
"id": "1D",
"a": 489872,
"z": 1136
},
{
"id": "1E",
"a": 491216,
"z": 1744
},
{
"id": "1F",
"a": 493120,
"z": 1792
}
],
"globals": [
{
"ds": 256,
"n": "S_IREAD",
"f": 121504,
"init": true
},
{
"ds": 346,
"n": "G_LAYERS_RESIDENT",
"f": 121594,
"init": true
},
{
"ds": 348,
"n": "g_layer_terrain_ptr",
"f": 121596,
"init": true
},
{
"ds": 352,
"n": "g_layer_elev_ptr",
"f": 121600,
"init": true
},
{
"ds": 356,
"n": "g_layer_resource_ptr",
"f": 121604,
"init": true
},
{
"ds": 360,
"n": "g_layer_fog_ptr",
"f": 121608,
"init": true
},
{
"ds": 364,
"n": "G_SHEET_PTR_B",
"f": 121612,
"init": true
},
{
"ds": 372,
"n": "G_SHEET_PHYS",
"f": 121620,
"init": true
},
{
"ds": 380,
"n": "G_CENTRE_X",
"f": 121628,
"init": true
},
{
"ds": 382,
"n": "G_CENTRE_Y",
"f": 121630,
"init": true
},
{
"ds": 388,
"n": "G_ZOOM",
"f": 121636,
"init": true
},
{
"ds": 390,
"n": "G_SHEET_METRIC",
"f": 121638,
"init": true
},
{
"ds": 392,
"n": "G_METRIC_188",
"f": 121640,
"init": true
},
{
"ds": 394,
"n": "G_STRAT_VIEW",
"f": 121642,
"init": true
},
{
"ds": 398,
"n": "G_STRAT_VIEW2",
"f": 121646,
"init": true
},
{
"ds": 400,
"n": "g_rng_seed",
"f": 121648,
"init": true
},
{
"ds": 402,
"n": "g_rng_seed_hi",
"f": 121650,
"init": true
},
{
"ds": 674,
"n": "BYTE_2A2",
"f": 121922,
"init": true
},
{
"ds": 846,
"n": "CD_RESULT_034E",
"f": 122094,
"init": true
},
{
"ds": 860,
"n": "CD_LISTACTIVE",
"f": 122108,
"init": true
},
{
"ds": 882,
"n": "g_score_accum",
"f": 122130,
"init": true
},
{
"ds": 2110,
"n": "G_SHEET_ICONS",
"f": 123358,
"init": true
},
{
"ds": 2172,
"n": "KEY_GAME",
"f": 123420,
"init": true
},
{
"ds": 3029,
"n": "K_ONE_ENTER",
"f": 124277,
"init": true
},
{
"ds": 3039,
"n": "K_ONE_LEAVE",
"f": 124287,
"init": true
},
{
"ds": 3829,
"n": "MSG_WINNING_KEY",
"f": 125077,
"init": true
},
{
"ds": 3864,
"n": "MSG_WINNING",
"f": 125112,
"init": true
},
{
"ds": 3921,
"n": "MSG_OTHERGRANTED",
"f": 125169,
"init": true
},
{
"ds": 3968,
"n": "MSG_RETIRING",
"f": 125216,
"init": true
},
{
"ds": 3977,
"n": "MSG_RETIRING2",
"f": 125225,
"init": true
},
{
"ds": 3987,
"n": "MSG_SCORED",
"f": 125235,
"init": true
},
{
"ds": 4101,
"n": "KEY_EUROPESHIPCLICK",
"f": 125349,
"init": true
},
{
"ds": 7844,
"n": "G_NUDGE_DX",
"f": 129092,
"init": true
},
{
"ds": 7845,
"n": "G_NUDGE_DY",
"f": 129093,
"init": true
},
{
"ds": 8020,
"n": "OPT_FLAGS_1F54",
"f": 129268,
"init": true
},
{
"ds": 8028,
"n": "OPT_FIELD_1F5C",
"f": 129276,
"init": true
},
{
"ds": 8030,
"n": "OPT_MODE_1F5E",
"f": 129278,
"init": true
},
{
"ds": 8032,
"n": "OPT_FIELD_1F60",
"f": 129280,
"init": true
},
{
"ds": 8100,
"n": "MACRO_KEYTAB_1FA4",
"f": 129348,
"init": true
},
{
"ds": 8107,
"n": "MACRO_KEYTAB_1FAB",
"f": 129355,
"init": true
},
{
"ds": 8114,
"n": "MACRO_KEYTAB_1FB2",
"f": 129362,
"init": true
},
{
"ds": 8118,
"n": "MACRO_PAD_1FB6",
"f": 129366,
"init": true
},
{
"ds": 8120,
"n": "MACRO_KEYTAB_1FB8",
"f": 129368,
"init": true
},
{
"ds": 8128,
"n": "MACRO_KEYTAB_1FC0",
"f": 129376,
"init": true
},
{
"ds": 8133,
"n": "MACRO_PCT_1FC5",
"f": 129381,
"init": true
},
{
"ds": 8226,
"n": "TMPL_FMT_2022",
"f": 129474,
"init": true
},
{
"ds": 9003,
"n": "KEY_FONTKING",
"f": 130251,
"init": true
},
{
"ds": 9029,
"n": "MENU_BEGIN_KEY",
"f": 130277,
"init": true
},
{
"ds": 11556,
"n": "G_ROAD_DIR_TABLE",
"f": 132804,
"init": true
},
{
"ds": 11688,
"n": "DLG_FMT_2DA8",
"f": 132936,
"init": true
},
{
"ds": 12155,
"n": "g_terrain_yield_table",
"f": 133403,
"init": true
},
{
"ds": 12612,
"n": "g_unit_table",
"f": 133860,
"init": true
},
{
"ds": 12613,
"n": "UNIT_Y",
"f": 133861,
"init": true
},
{
"ds": 12614,
"n": "UNIT_TYPE",
"f": 133862,
"init": true
},
{
"ds": 12615,
"n": "UNIT_OWNER",
"f": 133863,
"init": true
},
{
"ds": 12616,
"n": "U_FLAGS_3148",
"f": 133864,
"init": true
},
{
"ds": 12618,
"n": "U_FIELD_314A",
"f": 133866,
"init": true
},
{
"ds": 12620,
"n": "U_ORDERS_314C",
"f": 133868,
"init": true
},
{
"ds": 12621,
"n": "U_GOTOX_314D",
"f": 133869,
"init": true
},
{
"ds": 12622,
"n": "U_GOTOY_314E",
"f": 133870,
"init": true
},
{
"ds": 12624,
"n": "UNIT_CARGO_3150",
"f": 133872,
"init": true
},
{
"ds": 12634,
"n": "U_TURN_315A",
"f": 133882,
"init": true
},
{
"ds": 12636,
"n": "UNIT_CHAIN_PREV_OFF",
"f": 133884,
"init": true
},
{
"ds": 12638,
"n": "UNIT_CHAIN_NEXT_OFF",
"f": 133886,
"init": true
},
{
"ds": 21040,
"n": "UNIT_TYPE_WORD_5230",
"f": 142288,
"init": false
},
{
"ds": 21045,
"n": "UNIT_REFIT_TABLE_5235",
"f": 142293,
"init": false
},
{
"ds": 21378,
"n": "g_game_phase_flags",
"f": 142626,
"init": false
},
{
"ds": 21386,
"n": "g_year",
"f": 142634,
"init": false
},
{
"ds": 21388,
"n": "g_year_misc",
"f": 142636,
"init": false
},
{
"ds": 21390,
"n": "g_turn",
"f": 142638,
"init": false
},
{
"ds": 21396,
"n": "g_current_nation",
"f": 142644,
"init": false
},
{
"ds": 21398,
"n": "g_active_human_player",
"f": 142646,
"init": false
},
{
"ds": 21400,
"n": "g_current_player",
"f": 142648,
"init": false
},
{
"ds": 21402,
"n": "g_settlement_count",
"f": 142650,
"init": false
},
{
"ds": 21404,
"n": "g_unit_count",
"f": 142652,
"init": false
},
{
"ds": 21406,
"n": "g_colony_count",
"f": 142654,
"init": false
},
{
"ds": 21414,
"n": "g_difficulty",
"f": 142662,
"init": false
},
{
"ds": 21415,
"n": "g_year_centuries",
"f": 142663,
"init": false
},
{
"ds": 21416,
"n": "g_year_mod100",
"f": 142664,
"init": false
},
{
"ds": 21448,
"n": "TREATY_TIMER_BASE",
"f": 142696,
"init": false
},
{
"ds": 21456,
"n": "g_rebel_sentiment_meter",
"f": 142704,
"init": false
},
{
"ds": 21458,
"n": "g_self_power_idx",
"f": 142706,
"init": false
},
{
"ds": 21466,
"n": "g_ref_regulars",
"f": 142714,
"init": false
},
{
"ds": 21468,
"n": "g_ref_cavalry",
"f": 142716,
"init": false
},
{
"ds": 21470,
"n": "g_ref_manowar",
"f": 142718,
"init": false
},
{
"ds": 21472,
"n": "g_ref_artillery",
"f": 142720,
"init": false
},
{
"ds": 21482,
"n": "g_price_seed_16_",
"f": 142730,
"init": false
},
{
"ds": 21567,
"n": "AI_CTRL_543F",
"f": 142815,
"init": false
},
{
"ds": 23252,
"n": "G_TILE_PX",
"f": 144500,
"init": false
},
{
"ds": 23904,
"n": "COL_OWNER_5D60",
"f": 145152,
"init": false
},
{
"ds": 23906,
"n": "COL_FLAG_TABLE_5D62",
"f": 145154,
"init": false
},
{
"ds": 24032,
"n": "MARKET_PRICE_5DE0",
"f": 145280,
"init": false
},
{
"ds": 33574,
"n": "G_TILE_PX2",
"f": 154822,
"init": false
},
{
"ds": 33576,
"n": "g_viewport_origin_x",
"f": 154824,
"init": false
},
{
"ds": 33578,
"n": "G_PIXBASE_COL",
"f": 154826,
"init": false
},
{
"ds": 33580,
"n": "G_PIXBASE_ROW",
"f": 154828,
"init": false
},
{
"ds": 33582,
"n": "g_viewport_origin_y",
"f": 154830,
"init": false
},
{
"ds": 33684,
"n": "g_king_galleon_displaynum_diff_",
"f": 154932,
"init": false
},
{
"ds": 33694,
"n": "G_CLIP_RECT",
"f": 154942,
"init": false
},
{
"ds": 34044,
"n": "g_current_power_ptr",
"f": 155292,
"init": false
},
{
"ds": 34106,
"n": "g_map_width",
"f": 155354,
"init": false
},
{
"ds": 34108,
"n": "g_map_height",
"f": 155356,
"init": false
},
{
"ds": 34114,
"n": "g_current_colony_ptr",
"f": 155362,
"init": false
},
{
"ds": 34116,
"n": "G_SPAN_W",
"f": 155364,
"init": false
},
{
"ds": 34118,
"n": "G_SPAN_H",
"f": 155366,
"init": false
},
{
"ds": 34120,
"n": "g_map_stride",
"f": 155368,
"init": false
},
{
"ds": 34122,
"n": "G_WIN_ROWS",
"f": 155370,
"init": false
},
{
"ds": 34124,
"n": "G_WIN_BASE_COL",
"f": 155372,
"init": false
},
{
"ds": 34126,
"n": "G_WIN_BASE_ROW",
"f": 155374,
"init": false
},
{
"ds": 34820,
"n": "G_MAX_COL",
"f": 156068,
"init": false
},
{
"ds": 34822,
"n": "G_MAX_ROW",
"f": 156070,
"init": false
},
{
"ds": 34876,
"n": "g_war_matrix_base",
"f": 156124,
"init": false
},
{
"ds": 34888,
"n": "g_treaty_matrix_base",
"f": 156136,
"init": false
},
{
"ds": 36100,
"n": "g_combat_terrain_bonus",
"f": 157348,
"init": false
},
{
"ds": 36170,
"n": "g_active_settlement_ptr",
"f": 157418,
"init": false
},
{
"ds": 36174,
"n": "g_active_tribe_data_ptr",
"f": 157422,
"init": false
},
{
"ds": 36220,
"n": "CD_LIST_CURSOR",
"f": 157468,
"init": false
},
{
"ds": 37528,
"n": "TBL_9298_NCOL",
"f": 158776,
"init": false
},
{
"ds": 37904,
"n": "TBL_9410_ARMTYPE",
"f": 159152,
"init": false
},
{
"ds": 38482,
"n": "g_founding_father_table",
"f": 159730,
"init": false
},
{
"ds": 40112,
"n": "MACRO_VAL_9CB0",
"f": 161360,
"init": false
},
{
"ds": 40138,
"n": "G_MINIMAP_ROW0",
"f": 161386,
"init": false
},
{
"ds": 40140,
"n": "G_MINIMAP_COL0",
"f": 161388,
"init": false
},
{
"ds": 40146,
"n": "MACRO_VAL_9CD2",
"f": 161394,
"init": false
},
{
"ds": 40468,
"n": "G_MAPROW_TILE",
"f": 161716,
"init": false
},
{
"ds": 42388,
"n": "G_WP_TERRAIN",
"f": 163636,
"init": false
},
{
"ds": 42392,
"n": "G_WP_FEATURE",
"f": 163640,
"init": false
},
{
"ds": 42396,
"n": "G_WP_RESFOG",
"f": 163644,
"init": false
},
{
"ds": 42400,
"n": "G_SUBCELL_BX",
"f": 163648,
"init": false
},
{
"ds": 42402,
"n": "G_SUBCELL_BY",
"f": 163650,
"init": false
},
{
"ds": 42404,
"n": "G_TILE_SX",
"f": 163652,
"init": false
},
{
"ds": 42406,
"n": "G_TILE_SY",
"f": 163654,
"init": false
},
{
"ds": 42408,
"n": "G_COL_PARITY",
"f": 163656,
"init": false
},
{
"ds": 43166,
"n": "g_render_fog_mask",
"f": 164414,
"init": false
},
{
"ds": 43167,
"n": "G_RAW_TERRAIN",
"f": 164415,
"init": false
},
{
"ds": 43168,
"n": "G_RAW_RESFOG",
"f": 164416,
"init": false
},
{
"ds": 43169,
"n": "G_RAW_FEATURE",
"f": 164417,
"init": false
},
{
"ds": 43170,
"n": "G_VIS_TERRAIN",
"f": 164418,
"init": false
},
{
"ds": 43171,
"n": "G_CONN_COUNT",
"f": 164419,
"init": false
},
{
"ds": 43174,
"n": "G_CONN_BITMAP",
"f": 164422,
"init": false
}
],
"records": {
"UnitRecord": {
"base": "0x3144",
"stride": "0x1C"
},
"AIPersonality": {
"base": "0x540E",
"stride": "0x34"
},
"NativeSettlement": {
"base": "0x54EC",
"stride": "0x12"
},
"ColonyRecord": {
"base": "0x5D46",
"stride": "0xCA"
},
"PowerRecord": {
"base": "0x8808",
"stride": "0x13C"
}
},
"tables": [
{
"name": "ColonyRecord",
"ds": 23878,
"stride": 202,
"count": "g_colony_count"
},
{
"name": "UnitRecord",
"ds": 12612,
"stride": 28,
"count": "g_unit_count"
},
{
"name": "PowerRecord",
"ds": 34824,
"stride": 316,
"count": "fixed 4"
},
{
"name": "NativeSettlement",
"ds": 21740,
"stride": 18,
"count": "g_settlement_count"
},
{
"name": "AIPersonality",
"ds": 21518,
"stride": 52,
"count": "fixed 4"
}
]
}""")

HEADER = 0x2400
DGROUP_FILE = 0x1D9A0
LOAD_IMAGE_END = 0x22A65        # end of the MZ load image; DGROUP is BSS above
DELTA = -HEADER if MZ_LOAD else 0


def A(file_off):
    return toAddr(file_off + DELTA)


BUILD = "7da1a1bbc0fc"


def main():
    # First line out, before anything can fail: which copy of this file is
    # actually running.  Ghidra runs whatever is in ghidra_scripts/, which is
    # not necessarily the file you just regenerated.
    print("=" * 64)
    print("viceroy_ghidra_symbols  BUILD %s" % BUILD)
    print("=" * 64)

    fm = currentProgram.getFunctionManager()
    st = currentProgram.getSymbolTable()
    mem = currentProgram.getMemory()

    named = renamed = commented = failed = skipped = 0
    for f in DATA["funcs"]:
        try:
            addr = A(f["a"])
        except Exception:
            skipped += 1
            continue
        if mem.getBlock(addr) is None:
            skipped += 1                  # not mapped (MZ load, overlay page)
            continue

        fn = fm.getFunctionAt(addr)
        if fn is None:
            fn = createFunction(addr, f["n"])
            if fn is not None:
                named += 1
        if fn is not None and SRC is not None:
            try:
                fn.setName(f["n"], SRC)
                renamed += 1
            except Exception as e:
                failed += 1
                if failed <= 5:           # report a few, don't spam
                    print("  rename failed at 0x%06X (%s): %s"
                          % (f["a"], f["n"], e))

        tier = {"B": "REAL NAME (MAPEDIT CodeView match)",
                "R": "role name (analysis)",
                "M": "module-derived placeholder"}[f["t"]]
        lines = ["%s   [%s]" % (f["n"], tier),
                 "module : %s" % (f["m"] or "?"),
                 "page   : %s" % (f["p"] or "resident"),
                 "size   : %d bytes   file 0x%06X" % (f["s"], f["a"])]
        if f.get("lead"):
            lines.append("CANDIDATE (unconfirmed, partial fingerprint match "
                         "- verify before adopting): %s" % f["lead"])
        if f["k"]:
            lines.append("emits  : %s" % ", ".join(sorted(f["k"])))
        setPlateComment(addr, "\n".join(lines))
        commented += 1

    # ---- DGROUP -----------------------------------------------------------
    # ONE contiguous 64 KB window, not two halves.  DGROUP's initialised part
    # lives in the file at 0x1D9A0 and runs to the end of the load image
    # (0x22A65 = DS:0x50C5); everything above that is BSS, past the end of the
    # file.  In a raw-binary import the bytes immediately after 0x22A65 are
    # already occupied by overlay data, so BSS cannot simply be appended -
    # hence a synthetic block, with the initialised bytes COPIED into it so
    # that one DS value covers the whole segment.
    #
    # Why this matters: real mode writes `mov bx,[0x8542]`, meaning DS:0x8542.
    # Unless Ghidra knows DS, that displacement stays a bare constant and every
    # global in the program decompiles as a naked number.  Labelling the two
    # halves at two different addresses (the previous behaviour) could never
    # fix that, because no single DS value reached both.
    dg = None
    existing = mem.getBlock("DGROUP")
    if existing is not None:
        dg = existing.getStart()
        print("DGROUP block already present at %s" % dg)
        if not existing.isInitialized():
            print("!! ...but it is UNINITIALISED - left over from an older run")
            print("!! of this script.  Delete it and re-run, or the initialised")
            print("!! half of DGROUP will read as zeros:")
            print("!!   Window > Memory Map, select DGROUP, click the red X.")
    else:
        errs = []
        for cand in DGROUP_FALLBACKS:
            try:
                base = toAddr(cand)
                if base is None:
                    errs.append("0x%X: toAddr returned None" % cand)
                    continue
                mem.createInitializedBlock("DGROUP", base, 0x10000,
                                           0, monitor, False)
                dg = base
                print("DGROUP block created at %s (0x%X), 64 KB" % (dg, cand))
                break
            except Exception as e:
                errs.append("0x%X: %s" % (cand, e))
        if dg is None:
            print("!! COULD NOT CREATE THE DGROUP BLOCK - the record tables")
            print("!! will have no addresses.  Attempts:")
            for e in errs:
                print("     %s" % e)

    # Copy the initialised half in, so DS:0x0000..0x50C4 reads real data.
    init_len = LOAD_IMAGE_END - DGROUP_FILE
    if dg is not None:
        try:
            src = getBytes(A(DGROUP_FILE), init_len)
            mem.setBytes(dg, src)
            print("DGROUP initialised half copied: %d bytes from file 0x%X"
                  % (init_len, DGROUP_FILE))
        except Exception as e:
            print("!! could not copy the initialised half (%s) - DS:0x0000..0x%X"
                  % (e, init_len - 1))
            print("!! will read as zeros.  BSS globals are unaffected.")

    # Every global goes in the one window, initialised or not.
    gi = gb = 0
    if dg is not None:
        for g in DATA["globals"]:
            try:
                createLabel(dg.add(g["ds"]), g["n"], True)
                if g["init"]:
                    gi += 1
                else:
                    gb += 1
            except Exception:
                pass

    # ---- teach Ghidra what DS holds --------------------------------------
    # With the block at a paragraph-aligned address, DS = block>>4 makes every
    # `[0xNNNN]` displacement in the program resolve to DGROUP:0xNNNN - which
    # is where the labels now are.  Without this the decompiler shows
    # `*(int *)0x8542` instead of `g_current_colony_ptr`.
    if dg is not None:
        try:
            from java.math import BigInteger
            ds_reg = currentProgram.getRegister("DS")
            if ds_reg is None:
                print("!! no DS register in this language - is the program"
                      " really x86:LE:16:Real Mode?")
            else:
                ds_val = BigInteger.valueOf(dg.getOffset() >> 4)
                ctx = currentProgram.getProgramContext()
                spans = 0
                for blk in mem.getBlocks():
                    if blk.getName() == "DGROUP":
                        continue
                    try:
                        ctx.setValue(ds_reg, blk.getStart(), blk.getEnd(),
                                     ds_val)
                        spans += 1
                    except Exception:
                        pass
                print("DS set to 0x%04X over %d block(s) - globals should now"
                      " decompile by name" % (dg.getOffset() >> 4, spans))
                print("   (if they do not, re-run Analysis > Auto Analyze, or"
                      " right-click a function > Decompiler > Refresh)")
        except Exception as e:
            print("!! could not set DS (%s); set it by hand: select all in the"
                  " Listing," % e)
            print("!! right-click > Registers > Set Register Values, DS = 0x%04X"
                  % (dg.getOffset() >> 4))

    # ---- overlay page bookmarks ------------------------------------------
    pages = 0
    for p in DATA["pages"]:
        try:
            addr = A(p["a"])
            if mem.getBlock(addr) is not None:
                createBookmark(addr, "RTLink",
                               "overlay page 0x%s  (%d bytes)" % (p["id"], p["z"]))
                pages += 1
        except Exception:
            pass

    print("functions created  : %d" % named)
    print("functions named    : %d" % renamed)
    if failed:
        print("renames FAILED     : %d  (see messages above)" % failed)
    if skipped:
        print("skipped (unmapped) : %d  <- set MZ_LOAD/re-import if unexpected"
              % skipped)
    print("plate comments     : %d" % commented)
    print("globals in-file    : %d" % gi)
    print("globals in DGROUP  : %d" % gb)
    print("overlay bookmarks  : %d" % pages)
    # ---- the addresses you actually need, in THIS program's own format ----
    # Do not compute these by hand: a 16-bit real-mode program uses segmented
    # addresses (segment:offset), so a flat hex number will not resolve in
    # Go To.  Copy the right-hand column verbatim.
    print("")
    print("=" * 64)
    print("APPLY RECORD ARRAYS HERE  (Listing: G to go, then T to set type)")
    print("=" * 64)
    if dg is None:
        print("  unavailable - the DGROUP block was not created (see above)")
    else:
        for t in DATA["tables"]:
            try:
                a = dg.add(t["ds"])
            except Exception as e:
                print("  %-18s DS:0x%04X  -> ERROR %s" % (t["name"], t["ds"], e))
                continue
            print("  %-18s DS:0x%04X  ->  %s     [%s, stride 0x%X]"
                  % (t["name"] + "[]", t["ds"], a, t["count"], t["stride"]))
        print("")
        print("RECORD POINTERS to retype:")
        for nm, ds, ty in (("g_current_colony_ptr", 0x8542, "ColonyRecord *"),
                           ("g_current_power_ptr", 0x84FC, "PowerRecord *"),
                           ("g_active_settlement_ptr", 0x8D4A,
                            "NativeSettlement *")):
            try:
                print("  %-24s DS:0x%04X  ->  %s   as %s"
                      % (nm, ds, dg.add(ds), ty))
            except Exception:
                pass
    print("")
    print("Next: File > Parse C Source > tools/ghidra/viceroy_types.h")
    print("(clean profile: our header only, empty options, 16-bit program)")


main()
