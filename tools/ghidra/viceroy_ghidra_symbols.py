# VICEROY.EXE symbol import for Ghidra  (GENERATED — do not hand-edit)
# Regenerate: python3 tools/ghidra/export_ghidra_symbols.py
#
# BUILD 4b45055cb93a
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
"k": [],
"na": 1,
"nas": 24
},
{
"a": 9742,
"n": "format_to_buffer_2D54",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 35,
"lead": "",
"k": [],
"na": 2,
"nas": 17
},
{
"a": 9778,
"n": "rt_emit_long",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 21,
"lead": "",
"k": [],
"na": 1,
"nas": 32
},
{
"a": 9800,
"n": "rt_fmt_emit_1arg",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 32,
"lead": "",
"k": [],
"na": 1,
"nas": 20
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
"k": [],
"na": 4,
"nas": 1
},
{
"a": 10076,
"n": "resident__unattributed_00275C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 39,
"lead": "",
"k": [],
"na": 3,
"nas": 1
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
"k": [],
"na": 3,
"nas": 1
},
{
"a": 10416,
"n": "call_overlay_with_80",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 16,
"lead": "",
"k": [],
"na": 1,
"nas": 143
},
{
"a": 10432,
"n": "_spacer",
"t": "B",
"m": "write.obj",
"p": "",
"s": 33,
"lead": "",
"k": [],
"na": 2,
"nas": 8
},
{
"a": 10466,
"n": "rt_libwrap_7a4_s52",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": [],
"na": 1,
"nas": 13
},
{
"a": 10482,
"n": "rt_libwrap_7a4_s55",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": [],
"na": 1,
"nas": 62
},
{
"a": 10498,
"n": "rt_libwrap_7a4_s58",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": [],
"na": 1,
"nas": 9
},
{
"a": 10514,
"n": "rt_libwrap_7a4_s5c",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": [],
"na": 1,
"nas": 26
},
{
"a": 10530,
"n": "rt_libwrap_7a4_s5e",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": [],
"na": 1,
"nas": 49
},
{
"a": 10546,
"n": "rt_libwrap_7a4_s60",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": [],
"na": 1,
"nas": 46
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
"k": [],
"na": 1,
"nas": 29
},
{
"a": 10610,
"n": "rt_libwrap_7a4_s68",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": [],
"na": 1,
"nas": 5
},
{
"a": 10626,
"n": "rt_libwrap_7a4_s6a",
"t": "R",
"m": "write.obj",
"p": "",
"s": 16,
"lead": "",
"k": [],
"na": 1,
"nas": 2
},
{
"a": 10642,
"n": "write_obj_002992",
"t": "M",
"m": "write.obj",
"p": "",
"s": 26,
"lead": "",
"k": [],
"na": 2,
"nas": 259
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
"k": [],
"na": 3,
"nas": 142
},
{
"a": 10758,
"n": "write_obj_002A06",
"t": "M",
"m": "write.obj",
"p": "",
"s": 104,
"lead": "",
"k": [],
"na": 3,
"nas": 2
},
{
"a": 10862,
"n": "write_obj_002A6E",
"t": "M",
"m": "write.obj",
"p": "",
"s": 42,
"lead": "",
"k": [],
"na": 4,
"nas": 2
},
{
"a": 10904,
"n": "write_obj_002A98",
"t": "M",
"m": "write.obj",
"p": "",
"s": 46,
"lead": "_say_bucks",
"k": [],
"na": 4,
"nas": 9
},
{
"a": 10950,
"n": "write_obj_002AC6",
"t": "M",
"m": "write.obj",
"p": "",
"s": 27,
"lead": "",
"k": [],
"na": 2,
"nas": 2
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
"k": [],
"na": 4,
"nas": 25
},
{
"a": 11064,
"n": "write_obj_002B38",
"t": "M",
"m": "write.obj",
"p": "",
"s": 58,
"lead": "",
"k": [],
"na": 5,
"nas": 129
},
{
"a": 11122,
"n": "write_obj_002B72",
"t": "M",
"m": "write.obj",
"p": "",
"s": 85,
"lead": "",
"k": [],
"na": 5,
"nas": 21
},
{
"a": 11208,
"n": "_write_centered",
"t": "B",
"m": "write.obj",
"p": "",
"s": 68,
"lead": "",
"k": [],
"na": 6,
"nas": 72
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
"k": [],
"na": 6,
"nas": 2
},
{
"a": 11394,
"n": "write_obj_002C82",
"t": "M",
"m": "write.obj",
"p": "",
"s": 94,
"lead": "",
"k": [],
"na": 6,
"nas": 6
},
{
"a": 11488,
"n": "_write_big_centered",
"t": "B",
"m": "write.obj",
"p": "",
"s": 71,
"lead": "",
"k": [],
"na": 7,
"nas": 10
},
{
"a": 11560,
"n": "_say_terrain",
"t": "B",
"m": "write.obj",
"p": "",
"s": 75,
"lead": "",
"k": [],
"na": 2,
"nas": 2
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
"k": [],
"na": 1,
"nas": 1
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
"k": [],
"na": 6,
"nas": 3
},
{
"a": 13508,
"n": "shared_game_band_0034C4",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 114,
"lead": "",
"k": [],
"na": 6,
"nas": 1
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
"k": [],
"na": 7,
"nas": 7
},
{
"a": 18636,
"n": "stuff_obj_0048CC",
"t": "M",
"m": "stuff.obj",
"p": "",
"s": 13,
"lead": "_minimax",
"k": [],
"na": 3,
"nas": 40
},
{
"a": 18666,
"n": "stuff_obj_0048EA",
"t": "M",
"m": "stuff.obj",
"p": "",
"s": 21,
"lead": "_swap",
"k": [],
"na": 2,
"nas": 1
},
{
"a": 18688,
"n": "_xy_dist",
"t": "B",
"m": "stuff.obj",
"p": "",
"s": 15,
"lead": "",
"k": [],
"na": 2,
"nas": 8
},
{
"a": 18748,
"n": "stuff_obj_00493C",
"t": "M",
"m": "stuff.obj",
"p": "",
"s": 14,
"lead": "",
"k": [],
"na": 4,
"nas": 18
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
"k": [],
"na": 2,
"nas": 1
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
"k": [],
"na": 4,
"nas": 31
},
{
"a": 19272,
"n": "shared_game_band_004B48",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 25,
"lead": "",
"k": [],
"na": 2,
"nas": 7
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
"k": [],
"na": 1,
"nas": 12
},
{
"a": 20720,
"n": "shared_game_band_0050F0",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 11,
"lead": "",
"k": [],
"na": 1,
"nas": 16
},
{
"a": 20732,
"n": "shared_game_band_0050FC",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 11,
"lead": "",
"k": [],
"na": 1,
"nas": 1
},
{
"a": 20744,
"n": "shared_game_band_005108",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 51,
"lead": "",
"k": [],
"na": 1,
"nas": 34
},
{
"a": 20796,
"n": "shared_game_band_00513C",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 26,
"lead": "",
"k": [],
"na": 1,
"nas": 6
},
{
"a": 20832,
"n": "shared_game_band_005160",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 45,
"lead": "",
"k": [],
"na": 1,
"nas": 9
},
{
"a": 20946,
"n": "shared_game_band_0051D2",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 62,
"lead": "",
"k": [],
"na": 9,
"nas": 1
},
{
"a": 21044,
"n": "shared_game_band_005234",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 62,
"lead": "",
"k": [],
"na": 9,
"nas": 1
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
"k": [],
"na": 14,
"nas": 1
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
"k": [],
"na": 1,
"nas": 1
},
{
"a": 21564,
"n": "shared_game_band_00543C",
"t": "M",
"m": "shared-game-band",
"p": "",
"s": 131,
"lead": "",
"k": [],
"na": 1,
"nas": 9
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
"k": [],
"na": 2,
"nas": 63
},
{
"a": 23596,
"n": "_on_colony_map",
"t": "B",
"m": "map.obj",
"p": "",
"s": 132,
"lead": "",
"k": [],
"na": 3,
"nas": 2
},
{
"a": 23728,
"n": "map_obj_005CB0",
"t": "M",
"m": "map.obj",
"p": "",
"s": 54,
"lead": "",
"k": [],
"na": 2,
"nas": 1
},
{
"a": 23782,
"n": "map_obj_005CE6",
"t": "M",
"m": "map.obj",
"p": "",
"s": 24,
"lead": "_map_loc",
"k": [],
"na": 2,
"nas": 6
},
{
"a": 23806,
"n": "map_tile_read_layer_15C",
"t": "R",
"m": "map.obj",
"p": "",
"s": 28,
"lead": "_map_get",
"k": [],
"na": 2,
"nas": 21
},
{
"a": 23834,
"n": "map_obj_005D1A",
"t": "M",
"m": "map.obj",
"p": "",
"s": 23,
"lead": "",
"k": [],
"na": 2,
"nas": 6
},
{
"a": 23858,
"n": "map_tile_read_layer_160",
"t": "R",
"m": "map.obj",
"p": "",
"s": 28,
"lead": "_feature_get",
"k": [],
"na": 2,
"nas": 42
},
{
"a": 23886,
"n": "_feature_set",
"t": "B",
"m": "map.obj",
"p": "",
"s": 40,
"lead": "",
"k": [],
"na": 4,
"nas": 10
},
{
"a": 23940,
"n": "map_obj_005D84",
"t": "M",
"m": "map.obj",
"p": "",
"s": 23,
"lead": "_continent_loc",
"k": [],
"na": 2,
"nas": 2
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
"k": [],
"na": 2,
"nas": 34
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
"k": [],
"na": 2,
"nas": 11
},
{
"a": 24088,
"n": "map_obj_005E18",
"t": "M",
"m": "map.obj",
"p": "",
"s": 120,
"lead": "",
"k": [],
"na": 3,
"nas": 6
},
{
"a": 24208,
"n": "map_obj_005E90",
"t": "M",
"m": "map.obj",
"p": "",
"s": 64,
"lead": "",
"k": [],
"na": 2,
"nas": 51
},
{
"a": 24272,
"n": "map_obj_005ED0",
"t": "M",
"m": "map.obj",
"p": "",
"s": 23,
"lead": "",
"k": [],
"na": 2,
"nas": 5
},
{
"a": 24296,
"n": "map_obj_005EE8",
"t": "M",
"m": "map.obj",
"p": "",
"s": 28,
"lead": "_site_get",
"k": [],
"na": 2,
"nas": 16
},
{
"a": 24324,
"n": "map_xy_bounds_or_neg1",
"t": "R",
"m": "map.obj",
"p": "",
"s": 31,
"lead": "",
"k": [],
"na": 2,
"nas": 14
},
{
"a": 24392,
"n": "map_obj_005F48",
"t": "M",
"m": "map.obj",
"p": "",
"s": 58,
"lead": "",
"k": [],
"na": 2,
"nas": 28
},
{
"a": 24450,
"n": "map_obj_005F82",
"t": "M",
"m": "map.obj",
"p": "",
"s": 31,
"lead": "",
"k": [],
"na": 2,
"nas": 5
},
{
"a": 24532,
"n": "map_xy_bounds_or_neg1_alt",
"t": "R",
"m": "map.obj",
"p": "",
"s": 31,
"lead": "",
"k": [],
"na": 2,
"nas": 23
},
{
"a": 24600,
"n": "map_obj_006018",
"t": "M",
"m": "map.obj",
"p": "",
"s": 33,
"lead": "_is_anything",
"k": [],
"na": 2,
"nas": 16
},
{
"a": 24634,
"n": "map_obj_00603A",
"t": "M",
"m": "map.obj",
"p": "",
"s": 33,
"lead": "",
"k": [],
"na": 3,
"nas": 3
},
{
"a": 24736,
"n": "tile_terrain_variant_hash",
"t": "R",
"m": "map.obj",
"p": "",
"s": 128,
"lead": "_resource_at",
"k": [],
"na": 2,
"nas": 15
},
{
"a": 24968,
"n": "map_obj_006188",
"t": "M",
"m": "map.obj",
"p": "",
"s": 91,
"lead": "",
"k": [],
"na": 2,
"nas": 6
},
{
"a": 25092,
"n": "_terrain_fix_2",
"t": "B",
"m": "map.obj",
"p": "",
"s": 46,
"lead": "",
"k": [],
"na": 1,
"nas": 7
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
"k": [],
"na": 2,
"nas": 52
},
{
"a": 25268,
"n": "is_tile_walkable_or_special",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 39,
"lead": "",
"k": [],
"na": 2,
"nas": 72
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
"k": [],
"na": 2,
"nas": 2
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
"k": [],
"na": 3,
"nas": 5
},
{
"a": 27118,
"n": "resident__unattributed_0069EE",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 33,
"lead": "",
"k": [],
"na": 1,
"nas": 5
},
{
"a": 27152,
"n": "resident__unattributed_006A10",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 108,
"lead": "",
"k": [],
"na": 1,
"nas": 5
},
{
"a": 27260,
"n": "resident__unattributed_006A7C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 50,
"lead": "",
"k": [],
"na": 3,
"nas": 16
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
"k": [],
"na": 2,
"nas": 4
},
{
"a": 27850,
"n": "unit_table_offset_calc",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 13,
"lead": "",
"k": [],
"na": 1,
"nas": 12
},
{
"a": 27940,
"n": "resident__unattributed_006D24",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 197,
"lead": "",
"k": [],
"na": 4,
"nas": 27
},
{
"a": 28308,
"n": "resident__unattributed_006E94",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 132,
"lead": "",
"k": [],
"na": 1,
"nas": 22
},
{
"a": 28506,
"n": "resident__unattributed_006F5A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 105,
"lead": "",
"k": [],
"na": 1,
"nas": 5
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
"k": [],
"na": 1,
"nas": 3
},
{
"a": 28674,
"n": "resident__unattributed_007002",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 26,
"lead": "",
"k": [],
"na": 2,
"nas": 5
},
{
"a": 28700,
"n": "resident__unattributed_00701C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 48,
"lead": "",
"k": [],
"na": 2,
"nas": 2
},
{
"a": 28748,
"n": "resident__unattributed_00704C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 205,
"lead": "",
"k": [],
"na": 3,
"nas": 4
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
"k": [],
"na": 3,
"nas": 3
},
{
"a": 29294,
"n": "resident__unattributed_00726E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 116,
"lead": "",
"k": [],
"na": 3,
"nas": 2
},
{
"a": 29410,
"n": "resident__unattributed_0072E2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 40,
"lead": "",
"k": [],
"na": 2,
"nas": 3
},
{
"a": 29450,
"n": "resident__unattributed_00730A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 75,
"lead": "",
"k": [],
"na": 3,
"nas": 2
},
{
"a": 29526,
"n": "resident__unattributed_007356",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 56,
"lead": "",
"k": [],
"na": 1,
"nas": 3
},
{
"a": 29582,
"n": "resident__unattributed_00738E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 26,
"lead": "",
"k": [],
"na": 2,
"nas": 1
},
{
"a": 29608,
"n": "resident__unattributed_0073A8",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 99,
"lead": "",
"k": [],
"na": 2,
"nas": 40
},
{
"a": 30078,
"n": "resident__unattributed_00757E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 33,
"lead": "",
"k": [],
"na": 1,
"nas": 2
},
{
"a": 30112,
"n": "resident__unattributed_0075A0",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 51,
"lead": "",
"k": [],
"na": 1,
"nas": 3
},
{
"a": 30164,
"n": "resident__unattributed_0075D4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 16,
"lead": "",
"k": [],
"na": 1,
"nas": 8
},
{
"a": 30180,
"n": "resident__unattributed_0075E4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 26,
"lead": "",
"k": [],
"na": 2,
"nas": 4
},
{
"a": 30206,
"n": "resident__unattributed_0075FE",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 17,
"lead": "",
"k": [],
"na": 1,
"nas": 3
},
{
"a": 30224,
"n": "resident__unattributed_007610",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 31,
"lead": "",
"k": [],
"na": 2,
"nas": 7
},
{
"a": 30256,
"n": "resident__unattributed_007630",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 37,
"lead": "",
"k": [],
"na": 1,
"nas": 2
},
{
"a": 30300,
"n": "resident__unattributed_00765C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 42,
"lead": "",
"k": [],
"na": 1,
"nas": 2
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
"k": [],
"na": 1,
"nas": 7
},
{
"a": 30964,
"n": "resident__unattributed_0078F4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 66,
"lead": "",
"k": [],
"na": 1,
"nas": 3
},
{
"a": 31030,
"n": "resident__unattributed_007936",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 48,
"lead": "",
"k": [],
"na": 2,
"nas": 1
},
{
"a": 31078,
"n": "resident__unattributed_007966",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 41,
"lead": "",
"k": [],
"na": 1,
"nas": 5
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
"k": [],
"na": 4,
"nas": 1
},
{
"a": 31694,
"n": "resident__unattributed_007BCE",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 25,
"lead": "",
"k": [],
"na": 1,
"nas": 29
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
"k": [],
"na": 2,
"nas": 8
},
{
"a": 32062,
"n": "combat_terrain_fort_bonus_fill",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 502,
"lead": "",
"k": [],
"na": 2,
"nas": 3
},
{
"a": 32564,
"n": "resident__unattributed_007F34",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 27,
"lead": "",
"k": [],
"na": 2,
"nas": 93
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
"k": [],
"na": 3,
"nas": 14
},
{
"a": 32768,
"n": "resident__unattributed_008000",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 115,
"lead": "",
"k": [],
"na": 3,
"nas": 15
},
{
"a": 32884,
"n": "resident__unattributed_008074",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 83,
"lead": "",
"k": [],
"na": 3,
"nas": 3
},
{
"a": 32968,
"n": "resident__unattributed_0080C8",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 14,
"lead": "",
"k": [],
"na": 1,
"nas": 43
},
{
"a": 33040,
"n": "resident__unattributed_008110",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 14,
"lead": "",
"k": [],
"na": 1,
"nas": 93
},
{
"a": 33112,
"n": "resident__unattributed_008158",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 14,
"lead": "",
"k": [],
"na": 1,
"nas": 1
},
{
"a": 33150,
"n": "resident__unattributed_00817E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 14,
"lead": "",
"k": [],
"na": 1,
"nas": 6
},
{
"a": 33188,
"n": "resident__unattributed_0081A4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 28,
"lead": "",
"k": [],
"na": 1,
"nas": 1
},
{
"a": 33222,
"n": "resident__unattributed_0081C6",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 44,
"lead": "",
"k": [],
"na": 1,
"nas": 20
},
{
"a": 33266,
"n": "resident__unattributed_0081F2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 34,
"lead": "",
"k": [],
"na": 1,
"nas": 31
},
{
"a": 33322,
"n": "resident__unattributed_00822A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 36,
"lead": "",
"k": [],
"na": 1,
"nas": 5
},
{
"a": 33378,
"n": "resident__unattributed_008262",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 20,
"lead": "",
"k": [],
"na": 1,
"nas": 22
},
{
"a": 33440,
"n": "resident__unattributed_0082A0",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 18,
"lead": "",
"k": [],
"na": 2,
"nas": 61
},
{
"a": 33458,
"n": "resident__unattributed_0082B2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 38,
"lead": "",
"k": [],
"na": 1,
"nas": 26
},
{
"a": 33500,
"n": "resident__unattributed_0082DC",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 44,
"lead": "",
"k": [],
"na": 1,
"nas": 80
},
{
"a": 33618,
"n": "resident__unattributed_008352",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 92,
"lead": "",
"k": [],
"na": 2,
"nas": 9
},
{
"a": 33778,
"n": "resident__unattributed_0083F2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 71,
"lead": "",
"k": [],
"na": 4,
"nas": 19
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
"k": [],
"na": 1,
"nas": 5
},
{
"a": 34034,
"n": "resident__unattributed_0084F2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 21,
"lead": "",
"k": [],
"na": 1,
"nas": 2
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
"k": [],
"na": 1,
"nas": 2
},
{
"a": 34262,
"n": "set_or_clear_bit_at_8a",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 56,
"lead": "",
"k": [],
"na": 2,
"nas": 11
},
{
"a": 34318,
"n": "resident__unattributed_00860E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 15,
"lead": "",
"k": [],
"na": 2,
"nas": 3
},
{
"a": 34366,
"n": "wrapper_with_global_8DC6",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 15,
"lead": "",
"k": [],
"na": 1,
"nas": 48
},
{
"a": 34382,
"n": "resident__unattributed_00864E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 31,
"lead": "",
"k": [],
"na": 1,
"nas": 8
},
{
"a": 34438,
"n": "resident__unattributed_008686",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 34,
"lead": "",
"k": [],
"na": 2,
"nas": 1
},
{
"a": 34496,
"n": "resident__unattributed_0086C0",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 19,
"lead": "",
"k": [],
"na": 1,
"nas": 1
},
{
"a": 34532,
"n": "resident__unattributed_0086E4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 34,
"lead": "",
"k": [],
"na": 1,
"nas": 1
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
"k": [],
"na": 1,
"nas": 7
},
{
"a": 34822,
"n": "resident__unattributed_008806",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 63,
"lead": "",
"k": [],
"na": 3,
"nas": 3
},
{
"a": 34886,
"n": "resident__unattributed_008846",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 27,
"lead": "",
"k": [],
"na": 3,
"nas": 6
},
{
"a": 34914,
"n": "resident__unattributed_008862",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 25,
"lead": "",
"k": [],
"na": 2,
"nas": 2
},
{
"a": 34940,
"n": "resident__unattributed_00887C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 21,
"lead": "",
"k": [],
"na": 1,
"nas": 1
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
"k": [],
"na": 3,
"nas": 1
},
{
"a": 35158,
"n": "lookup_byte_from_pair",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 44,
"lead": "",
"k": [],
"na": 2,
"nas": 10
},
{
"a": 35202,
"n": "resident__unattributed_008982",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 532,
"lead": "",
"k": [],
"na": 3,
"nas": 3
},
{
"a": 35734,
"n": "unit_field_test_at_3146",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 24,
"lead": "",
"k": [],
"na": 1,
"nas": 6
},
{
"a": 35762,
"n": "resident__unattributed_008BB2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 20,
"lead": "",
"k": [],
"na": 1,
"nas": 15
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
"k": [],
"na": 1,
"nas": 4
},
{
"a": 35870,
"n": "resident__unattributed_008C1E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 81,
"lead": "",
"k": [],
"na": 1,
"nas": 4
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
"k": [],
"na": 2,
"nas": 28
},
{
"a": 36252,
"n": "lookup_table_2F4_signed",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 31,
"lead": "",
"k": [],
"na": 1,
"nas": 1
},
{
"a": 36284,
"n": "resident__unattributed_008DBC",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 69,
"lead": "",
"k": [],
"na": 2,
"nas": 11
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
"k": [],
"na": 1,
"nas": 1
},
{
"a": 36650,
"n": "unpack_nibble_at_60",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 53,
"lead": "",
"k": [],
"na": 1,
"nas": 2
},
{
"a": 36716,
"n": "pack_nibble_at_60",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 72,
"lead": "",
"k": [],
"na": 2,
"nas": 3
},
{
"a": 36788,
"n": "resident__unattributed_008FB4",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 138,
"lead": "",
"k": [],
"na": 1,
"nas": 2
},
{
"a": 36926,
"n": "resident__unattributed_00903E",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 37,
"lead": "",
"k": [],
"na": 2,
"nas": 2
},
{
"a": 37064,
"n": "current_unit_field_at_20",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 29,
"lead": "",
"k": [],
"na": 1,
"nas": 25
},
{
"a": 37122,
"n": "current_unit_field_at_40",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 29,
"lead": "",
"k": [],
"na": 1,
"nas": 27
},
{
"a": 37180,
"n": "set_field_at_40_or_unit_byte",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 72,
"lead": "",
"k": [],
"na": 2,
"nas": 15
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
"k": [],
"na": 1,
"nas": 8
},
{
"a": 37530,
"n": "classify_pair_bounds",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 70,
"lead": "",
"k": [],
"na": 2,
"nas": 1
},
{
"a": 37600,
"n": "colony_flag_bit_set",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 44,
"lead": "",
"k": [],
"na": 2,
"nas": 18
},
{
"a": 37656,
"n": "colony_production_accumulate",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 782,
"lead": "",
"k": [],
"na": 2,
"nas": 20
},
{
"a": 38438,
"n": "colony_leaf_calls_90c8",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 53,
"lead": "",
"k": [],
"na": 1,
"nas": 5
},
{
"a": 38492,
"n": "colony_leaf_calls_9102",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 53,
"lead": "",
"k": [],
"na": 1,
"nas": 3
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
"k": [],
"na": 2,
"nas": 1
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
"k": [],
"na": 1,
"nas": 7
},
{
"a": 38790,
"n": "resident__unattributed_009786",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 12,
"lead": "",
"k": [],
"na": 1,
"nas": 5
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
"k": [],
"na": 1,
"nas": 5
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
"k": [],
"na": 2,
"nas": 1
},
{
"a": 39158,
"n": "resident__unattributed_0098F6",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 85,
"lead": "",
"k": [],
"na": 3,
"nas": 3
},
{
"a": 39244,
"n": "resident__unattributed_00994C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 40,
"lead": "",
"k": [],
"na": 1,
"nas": 5
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
"k": [],
"na": 2,
"nas": 1
},
{
"a": 39836,
"n": "resident__unattributed_009B9C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 1120,
"lead": "",
"k": [],
"na": 4,
"nas": 2
},
{
"a": 40956,
"n": "resident__unattributed_009FFC",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 550,
"lead": "",
"k": [],
"na": 2,
"nas": 2
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
"k": [],
"na": 2,
"nas": 10
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
"k": [],
"na": 1,
"nas": 16
},
{
"a": 45730,
"n": "resident__unattributed_00B2A2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 31,
"lead": "",
"k": [],
"na": 2,
"nas": 30
},
{
"a": 45808,
"n": "unit_table_3154_byte",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 20,
"lead": "",
"k": [],
"na": 2,
"nas": 23
},
{
"a": 45828,
"n": "resident__unattributed_00B304",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 21,
"lead": "",
"k": [],
"na": 3,
"nas": 1
},
{
"a": 45850,
"n": "resident__unattributed_00B31A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 77,
"lead": "",
"k": [],
"na": 3,
"nas": 1
},
{
"a": 45928,
"n": "colony_helper_b2a2",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 126,
"lead": "",
"k": [],
"na": 3,
"nas": 10
},
{
"a": 46124,
"n": "resident__unattributed_00B42C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 139,
"lead": "",
"k": [],
"na": 2,
"nas": 13
},
{
"a": 46264,
"n": "resident__unattributed_00B4B8",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 11,
"lead": "",
"k": [],
"na": 3,
"nas": 4
},
{
"a": 46416,
"n": "resident__unattributed_00B550",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 88,
"lead": "",
"k": [],
"na": 2,
"nas": 3
},
{
"a": 46504,
"n": "resident__unattributed_00B5A8",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 82,
"lead": "",
"k": [],
"na": 2,
"nas": 6
},
{
"a": 46586,
"n": "resident__unattributed_00B5FA",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 47,
"lead": "",
"k": [],
"na": 1,
"nas": 7
},
{
"a": 46682,
"n": "resident__unattributed_00B65A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 39,
"lead": "",
"k": [],
"na": 2,
"nas": 5
},
{
"a": 46852,
"n": "resident__unattributed_00B704",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 41,
"lead": "",
"k": [],
"na": 1,
"nas": 5
},
{
"a": 47232,
"n": "colony_helper_8dc4_a",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 80,
"lead": "",
"k": [],
"na": 3,
"nas": 1
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
"k": [],
"na": 1,
"nas": 1
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
"k": [],
"na": 1,
"nas": 1
},
{
"a": 48144,
"n": "is_arg2_negative",
"t": "R",
"m": "(resident, unattributed)",
"p": "",
"s": 16,
"lead": "",
"k": [],
"na": 2,
"nas": 44
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
"k": [],
"na": 2,
"nas": 6
},
{
"a": 48362,
"n": "resident__unattributed_00BCEA",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 61,
"lead": "",
"k": [],
"na": 1,
"nas": 3
},
{
"a": 48424,
"n": "resident__unattributed_00BD28",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 34,
"lead": "",
"k": [],
"na": 2,
"nas": 2
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
"k": [],
"na": 3,
"nas": 10
},
{
"a": 48956,
"n": "resident__unattributed_00BF3C",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 182,
"lead": "",
"k": [],
"na": 5,
"nas": 8
},
{
"a": 49138,
"n": "resident__unattributed_00BFF2",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 23,
"lead": "",
"k": [],
"na": 2,
"nas": 11
},
{
"a": 49162,
"n": "resident__unattributed_00C00A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 112,
"lead": "",
"k": [],
"na": 1,
"nas": 1
},
{
"a": 49274,
"n": "resident__unattributed_00C07A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 32,
"lead": "",
"k": [],
"na": 3,
"nas": 2
},
{
"a": 49306,
"n": "resident__unattributed_00C09A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 19,
"lead": "",
"k": [],
"na": 1,
"nas": 4
},
{
"a": 49326,
"n": "resident__unattributed_00C0AE",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 34,
"lead": "",
"k": [],
"na": 2,
"nas": 2
},
{
"a": 49360,
"n": "resident__unattributed_00C0D0",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 57,
"lead": "",
"k": [],
"na": 1,
"nas": 2
},
{
"a": 49530,
"n": "resident__unattributed_00C17A",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 20,
"lead": "",
"k": [],
"na": 1,
"nas": 3
},
{
"a": 49656,
"n": "resident__unattributed_00C1F8",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 20,
"lead": "",
"k": [],
"na": 1,
"nas": 1
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
"k": [],
"na": 2,
"nas": 1
},
{
"a": 49954,
"n": "resident__unattributed_00C322",
"t": "M",
"m": "(resident, unattributed)",
"p": "",
"s": 63,
"lead": "",
"k": [],
"na": 2,
"nas": 234
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
"k": [],
"na": 4,
"nas": 1
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
"k": [],
"na": 1,
"nas": 1
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
"k": [],
"na": 1,
"nas": 2
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
"k": [],
"na": 1,
"nas": 2
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
"k": [],
"na": 2,
"nas": 2
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
"k": [],
"na": 14,
"nas": 4
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
"k": [],
"na": 2,
"nas": 2
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
"k": [],
"na": 2,
"nas": 1
},
{
"a": 76072,
"n": "_SOUND_DRIVER_INIT",
"t": "B",
"m": "sound_1.ASM",
"p": "",
"s": 49,
"lead": "",
"k": [],
"na": 1,
"nas": 1
},
{
"a": 76121,
"n": "engine_band_012959",
"t": "M",
"m": "engine-band",
"p": "",
"s": 26,
"lead": "",
"k": [],
"na": 1,
"nas": 1
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
"k": [],
"na": 2,
"nas": 1
},
{
"a": 78972,
"n": "_xms_umb_free",
"t": "B",
"m": "XMS_3.C",
"p": "",
"s": 21,
"lead": "",
"k": [],
"na": 2,
"nas": 1
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
"k": [],
"na": 3,
"nas": 1
},
{
"a": 165810,
"n": "colony_ui_0287B2",
"t": "M",
"m": "colony_ui*",
"p": "02",
"s": 19,
"lead": "",
"k": [],
"na": 1,
"nas": 2
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
"k": [],
"na": 4,
"nas": 1
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
],
"na": 3,
"nas": 1
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
],
"na": 1,
"nas": 8
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
],
"na": 1,
"nas": 2
},
{
"a": 191164,
"n": "colony_econ_02EABC",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 46,
"lead": "",
"k": [],
"na": 2,
"nas": 1
},
{
"a": 191210,
"n": "colony_econ_02EAEA",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 49,
"lead": "",
"k": [],
"na": 2,
"nas": 1
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
"k": [],
"na": 2,
"nas": 2
},
{
"a": 191352,
"n": "colony_econ_02EB78",
"t": "M",
"m": "colony_econ*",
"p": "03",
"s": 182,
"lead": "",
"k": [],
"na": 4,
"nas": 1
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
"k": [],
"na": 1,
"nas": 4
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
"k": [],
"na": 1,
"nas": 24
},
{
"a": 197990,
"n": "commodity_current_price",
"t": "R",
"m": "europe_king*",
"p": "04",
"s": 42,
"lead": "",
"k": [],
"na": 1,
"nas": 8
},
{
"a": 198032,
"n": "europe_king_030590",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 24,
"lead": "",
"k": [],
"na": 1,
"nas": 3
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
"k": [],
"na": 1,
"nas": 2
},
{
"a": 199500,
"n": "europe_king_030B4C",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 105,
"lead": "",
"k": [],
"na": 1,
"nas": 1
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
"k": [],
"na": 1,
"nas": 2
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
"k": [],
"na": 1,
"nas": 2
},
{
"a": 200884,
"n": "europe_king_0310B4",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 483,
"lead": "",
"k": [],
"na": 1,
"nas": 4
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
"k": [],
"na": 1,
"nas": 2
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
"k": [],
"na": 4,
"nas": 1
},
{
"a": 203750,
"n": "europe_king_031BE6",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 481,
"lead": "",
"k": [],
"na": 4,
"nas": 1
},
{
"a": 204232,
"n": "europe_king_031DC8",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 351,
"lead": "",
"k": [],
"na": 1,
"nas": 1
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
"k": [],
"na": 2,
"nas": 6
},
{
"a": 205642,
"n": "europe_king_03234A",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 194,
"lead": "",
"k": [],
"na": 2,
"nas": 4
},
{
"a": 205836,
"n": "europe_king_03240C",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 80,
"lead": "",
"k": [],
"na": 3,
"nas": 1
},
{
"a": 205916,
"n": "europe_king_03245C",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 108,
"lead": "",
"k": [],
"na": 3,
"nas": 1
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
"k": [],
"na": 4,
"nas": 1
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
],
"na": 1,
"nas": 1
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
"k": [],
"na": 2,
"nas": 2
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
"k": [],
"na": 1,
"nas": 2
},
{
"a": 216532,
"n": "europe_king_034DD4",
"t": "M",
"m": "europe_king*",
"p": "04",
"s": 716,
"lead": "",
"k": [],
"na": 2,
"nas": 1
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
"k": [],
"na": 2,
"nas": 2
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
"k": [],
"na": 1,
"nas": 1
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
"k": [],
"na": 1,
"nas": 2
},
{
"a": 227672,
"n": "reports_037958",
"t": "M",
"m": "reports*",
"p": "05",
"s": 184,
"lead": "",
"k": [],
"na": 1,
"nas": 2
},
{
"a": 227856,
"n": "reports_037A10",
"t": "M",
"m": "reports*",
"p": "05",
"s": 1646,
"lead": "",
"k": [],
"na": 1,
"nas": 2
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
"k": [],
"na": 1,
"nas": 2
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
"k": [],
"na": 1,
"nas": 2
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
"k": [],
"na": 1,
"nas": 2
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
"k": [],
"na": 1,
"nas": 2
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
],
"na": 1,
"nas": 2
},
{
"a": 237208,
"n": "reports_039E98",
"t": "M",
"m": "reports*",
"p": "05",
"s": 73,
"lead": "",
"k": [],
"na": 1,
"nas": 2
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
"k": [],
"na": 2,
"nas": 1
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
"k": [],
"na": 1,
"nas": 1
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
],
"na": 2,
"nas": 1
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
],
"na": 3,
"nas": 1
},
{
"a": 260366,
"n": "naval_03F90E",
"t": "M",
"m": "naval*",
"p": "07",
"s": 56,
"lead": "",
"k": [],
"na": 2,
"nas": 2
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
],
"na": 1,
"nas": 1
},
{
"a": 264662,
"n": "pioneer_routes_0409D6",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 584,
"lead": "",
"k": [],
"na": 1,
"nas": 2
},
{
"a": 265246,
"n": "pioneer_routes_040C1E",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 515,
"lead": "",
"k": [],
"na": 1,
"nas": 1
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
],
"na": 2,
"nas": 1
},
{
"a": 267280,
"n": "pioneer_routes_041410",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 579,
"lead": "",
"k": [],
"na": 2,
"nas": 2
},
{
"a": 267860,
"n": "pioneer_routes_041654",
"t": "M",
"m": "pioneer_routes*",
"p": "08",
"s": 478,
"lead": "",
"k": [],
"na": 1,
"nas": 2
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
"k": [],
"na": 5,
"nas": 2
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
"k": [],
"na": 2,
"nas": 3
},
{
"a": 279872,
"n": "clamp_byte_at_far_ptr_to_5",
"t": "R",
"m": "menu_bar*",
"p": "0A",
"s": 21,
"lead": "",
"k": [],
"na": 2,
"nas": 10
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
"k": [],
"na": 3,
"nas": 1
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
"k": [],
"na": 4,
"nas": 3
},
{
"a": 281234,
"n": "menu_obj_044A92",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 47,
"lead": "",
"k": [],
"na": 4,
"nas": 13
},
{
"a": 281282,
"n": "menu_obj_044AC2",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 68,
"lead": "",
"k": [],
"na": 2,
"nas": 2
},
{
"a": 281350,
"n": "menu_obj_044B06",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 47,
"lead": "",
"k": [],
"na": 4,
"nas": 29
},
{
"a": 281398,
"n": "menu_obj_044B36",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 68,
"lead": "",
"k": [],
"na": 2,
"nas": 2
},
{
"a": 281466,
"n": "menu_obj_044B7A",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 411,
"lead": "_menu_add_bar_item",
"k": [],
"na": 6,
"nas": 7
},
{
"a": 281878,
"n": "menu_obj_044D16",
"t": "M",
"m": "menu.obj",
"p": "0A",
"s": 357,
"lead": "_menu_add_item",
"k": [],
"na": 6,
"nas": 91
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
],
"na": 2,
"nas": 1
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
"k": [],
"na": 4,
"nas": 31
},
{
"a": 286724,
"n": "native_raid_046004",
"t": "M",
"m": "native_raid*",
"p": "0B",
"s": 81,
"lead": "",
"k": [],
"na": 2,
"nas": 6
},
{
"a": 286806,
"n": "native_raid_046056",
"t": "M",
"m": "native_raid*",
"p": "0B",
"s": 162,
"lead": "",
"k": [],
"na": 4,
"nas": 14
},
{
"a": 286968,
"n": "native_raid_0460F8",
"t": "M",
"m": "native_raid*",
"p": "0B",
"s": 969,
"lead": "",
"k": [],
"na": 2,
"nas": 4
},
{
"a": 287938,
"n": "native_raid_0464C2",
"t": "M",
"m": "native_raid*",
"p": "0B",
"s": 305,
"lead": "",
"k": [],
"na": 4,
"nas": 4
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
"k": [],
"na": 3,
"nas": 3
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
],
"na": 1,
"nas": 3
},
{
"a": 290754,
"n": "village_trade_046FC2",
"t": "M",
"m": "village_trade*",
"p": "0C",
"s": 56,
"lead": "",
"k": [],
"na": 1,
"nas": 1
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
],
"na": 3,
"nas": 1
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
"k": [],
"na": 1,
"nas": 1
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
"k": [],
"na": 3,
"nas": 1
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
],
"na": 5,
"nas": 1
},
{
"a": 367422,
"n": "natives_059B3E",
"t": "M",
"m": "natives*",
"p": "0F",
"s": 81,
"lead": "",
"k": [],
"na": 1,
"nas": 2
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
],
"na": 3,
"nas": 2
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
"k": [],
"na": 2,
"nas": 1
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
],
"na": 2,
"nas": 1
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
],
"na": 5,
"nas": 3
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
"k": [],
"na": 13,
"nas": 1
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
"k": [],
"na": 1,
"nas": 3
},
{
"a": 392826,
"n": "trade_editor_05FE7A",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 38,
"lead": "",
"k": [],
"na": 1,
"nas": 2
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
"k": [],
"na": 4,
"nas": 1
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
"k": [],
"na": 1,
"nas": 3
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
"k": [],
"na": 1,
"nas": 3
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
"k": [],
"na": 1,
"nas": 1
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
"k": [],
"na": 3,
"nas": 1
},
{
"a": 395114,
"n": "trade_editor_06076A",
"t": "M",
"m": "trade_editor*",
"p": "12",
"s": 208,
"lead": "",
"k": [],
"na": 1,
"nas": 1
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
"k": [],
"na": 2,
"nas": 6
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
"k": [],
"na": 7,
"nas": 1
},
{
"a": 421078,
"n": "map_render_066CD6",
"t": "M",
"m": "map_render*",
"p": "15",
"s": 310,
"lead": "",
"k": [],
"na": 2,
"nas": 1
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
"k": [],
"na": 2,
"nas": 4
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
"k": [],
"na": 3,
"nas": 2
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
"k": [],
"na": 1,
"nas": 4
},
{
"a": 431814,
"n": "dialog_pedia_0696C6",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 1733,
"lead": "",
"k": [],
"na": 1,
"nas": 5
},
{
"a": 433548,
"n": "dialog_pedia_069D8C",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 2420,
"lead": "",
"k": [],
"na": 1,
"nas": 2
},
{
"a": 435968,
"n": "dialog_pedia_06A700",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 904,
"lead": "",
"k": [],
"na": 1,
"nas": 3
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
"k": [],
"na": 1,
"nas": 2
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
"k": [],
"na": 1,
"nas": 1
},
{
"a": 440046,
"n": "dialog_pedia_06B6EE",
"t": "M",
"m": "dialog_pedia*",
"p": "16",
"s": 52,
"lead": "",
"k": [],
"na": 2,
"nas": 2
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
"k": [],
"na": 3,
"nas": 91
},
{
"a": 442940,
"n": "popup_engine_06C23C",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 24,
"lead": "",
"k": [],
"na": 2,
"nas": 265
},
{
"a": 442964,
"n": "popup_engine_06C254",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 40,
"lead": "",
"k": [],
"na": 3,
"nas": 14
},
{
"a": 443004,
"n": "popup_obj_06C27C",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 25,
"lead": "_popup_num",
"k": [],
"na": 3,
"nas": 97
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
"k": [],
"na": 3,
"nas": 4
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
"k": [],
"na": 4,
"nas": 5
},
{
"a": 444282,
"n": "popup_engine_06C77A",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 47,
"lead": "",
"k": [],
"na": 4,
"nas": 5
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
"k": [],
"na": 3,
"nas": 9
},
{
"a": 444496,
"n": "popup_obj_06C850",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 488,
"lead": "_popup_add_item",
"k": [],
"na": 5,
"nas": 44
},
{
"a": 444984,
"n": "_popup_add_check",
"t": "B",
"m": "popup.obj",
"p": "17",
"s": 58,
"lead": "",
"k": [],
"na": 6,
"nas": 1
},
{
"a": 445042,
"n": "popup_obj_06CA72",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 15,
"lead": "_popup_set_width",
"k": [],
"na": 3,
"nas": 1
},
{
"a": 445058,
"n": "popup_obj_06CA82",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 274,
"lead": "_popup_add_string",
"k": [],
"na": 4,
"nas": 2
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
"k": [],
"na": 2,
"nas": 18
},
{
"a": 445836,
"n": "popup_obj_06CD8C",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 494,
"lead": "_popup_add_sprite",
"k": [],
"na": 8,
"nas": 7
},
{
"a": 446330,
"n": "popup_obj_06CF7A",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 65,
"lead": "",
"k": [],
"na": 5,
"nas": 1
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
"k": [],
"na": 6,
"nas": 1
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
"k": [],
"na": 3,
"nas": 4
},
{
"a": 454380,
"n": "popup_obj_06EEEC",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 520,
"lead": "",
"k": [],
"na": 2,
"nas": 5
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
"k": [],
"na": 2,
"nas": 37
},
{
"a": 456154,
"n": "popup_obj_06F5DA",
"t": "M",
"m": "popup.obj",
"p": "17",
"s": 24,
"lead": "_popk",
"k": [],
"na": 1,
"nas": 1
},
{
"a": 456178,
"n": "popup_engine_06F5F2",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 41,
"lead": "",
"k": [],
"na": 2,
"nas": 115
},
{
"a": 456220,
"n": "popup_engine_06F61C",
"t": "M",
"m": "popup_engine*",
"p": "17",
"s": 48,
"lead": "",
"k": [],
"na": 2,
"nas": 22
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
"k": [],
"na": 2,
"nas": 59
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
"k": [],
"na": 3,
"nas": 3
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
"count": "g_colony_count",
"n": 16,
"fields": [
{
"o": 0,
"t": "u8",
"nm": "map_x",
"c": null
},
{
"o": 1,
"t": "u8",
"nm": "map_y",
"c": null
},
{
"o": 2,
"t": "char",
"nm": "name",
"c": 24
},
{
"o": 26,
"t": "u8",
"nm": "owner_power",
"c": null
},
{
"o": 28,
"t": "u8",
"nm": "colony_flags",
"c": null
},
{
"o": 31,
"t": "u8",
"nm": "population",
"c": null
},
{
"o": 32,
"t": "u8",
"nm": "occupation",
"c": 32
},
{
"o": 64,
"t": "u8",
"nm": "profession",
"c": 32
},
{
"o": 96,
"t": "u8",
"nm": "work_duration",
"c": 16
},
{
"o": 112,
"t": "s8",
"nm": "tiles",
"c": 8
},
{
"o": 132,
"t": "u8",
"nm": "buildings",
"c": 6
},
{
"o": 138,
"t": "u16",
"nm": "custom_house_flags",
"c": null
},
{
"o": 146,
"t": "u16",
"nm": "hammers",
"c": null
},
{
"o": 148,
"t": "u8",
"nm": "building_in_production",
"c": null
},
{
"o": 149,
"t": "u8",
"nm": "warehouse_level",
"c": null
},
{
"o": 151,
"t": "u8",
"nm": "depletion_counter",
"c": null
},
{
"o": 152,
"t": "u16",
"nm": "hammers_purchased",
"c": null
},
{
"o": 154,
"t": "u16",
"nm": "stock",
"c": 16
},
{
"o": 186,
"t": "u8",
"nm": "population_on_map",
"c": 4
},
{
"o": 190,
"t": "u8",
"nm": "fortification_on_map",
"c": 4
},
{
"o": 194,
"t": "s32",
"nm": "rebel_dividend",
"c": null
},
{
"o": 198,
"t": "s32",
"nm": "rebel_divisor",
"c": null
}
]
},
{
"name": "UnitRecord",
"ds": 12612,
"stride": 28,
"count": "g_unit_count",
"n": 64,
"fields": [
{
"o": 0,
"t": "u8",
"nm": "map_x",
"c": null
},
{
"o": 1,
"t": "u8",
"nm": "map_y",
"c": null
},
{
"o": 2,
"t": "u8",
"nm": "type",
"c": null
},
{
"o": 3,
"t": "u8",
"nm": "owner_flags",
"c": null
},
{
"o": 4,
"t": "u8",
"nm": "flags",
"c": null
},
{
"o": 6,
"t": "u8",
"nm": "moves_remaining",
"c": null
},
{
"o": 7,
"t": "u8",
"nm": "profession",
"c": null
},
{
"o": 8,
"t": "u8",
"nm": "orders",
"c": null
},
{
"o": 9,
"t": "u8",
"nm": "goto_x",
"c": null
},
{
"o": 10,
"t": "u8",
"nm": "goto_y",
"c": null
},
{
"o": 12,
"t": "u8",
"nm": "cargo_slot_count",
"c": null
},
{
"o": 13,
"t": "u8",
"nm": "cargo_kind_packed",
"c": 3
},
{
"o": 16,
"t": "u8",
"nm": "cargo_qty",
"c": 4
},
{
"o": 21,
"t": "u8",
"nm": "class_profession",
"c": null
},
{
"o": 22,
"t": "u8",
"nm": "turn_counter",
"c": null
},
{
"o": 23,
"t": "u8",
"nm": "vet_type",
"c": null
},
{
"o": 24,
"t": "u16",
"nm": "chain_prev",
"c": null
},
{
"o": 26,
"t": "u16",
"nm": "chain_next",
"c": null
}
]
},
{
"name": "PowerRecord",
"ds": 34824,
"stride": 316,
"count": "fixed 4",
"n": 4,
"fields": [
{
"o": 1,
"t": "u8",
"nm": "tax_rate",
"c": null
},
{
"o": 2,
"t": "u8",
"nm": "dock_pool",
"c": 3
},
{
"o": 7,
"t": "s32",
"nm": "founding_fathers_bitmap",
"c": null
},
{
"o": 12,
"t": "u16",
"nm": "liberty_bells",
"c": null
},
{
"o": 14,
"t": "u16",
"nm": "bell_pool",
"c": null
},
{
"o": 16,
"t": "u16",
"nm": "crosses_per_turn",
"c": null
},
{
"o": 18,
"t": "u16",
"nm": "ff_pending_slot",
"c": null
},
{
"o": 20,
"t": "u16",
"nm": "founding_fathers_count",
"c": null
},
{
"o": 30,
"t": "u16",
"nm": "artillery_bought_count",
"c": null
},
{
"o": 32,
"t": "u16",
"nm": "boycott_mask",
"c": null
},
{
"o": 34,
"t": "s32",
"nm": "royal_money",
"c": null
},
{
"o": 42,
"t": "s32",
"nm": "gold",
"c": null
},
{
"o": 46,
"t": "u16",
"nm": "crosses_accum",
"c": null
},
{
"o": 48,
"t": "u16",
"nm": "cross_threshold",
"c": null
},
{
"o": 50,
"t": "u8",
"nm": "home_x",
"c": null
},
{
"o": 51,
"t": "u8",
"nm": "home_y",
"c": null
},
{
"o": 52,
"t": "u8",
"nm": "war_matrix",
"c": 12
},
{
"o": 64,
"t": "u8",
"nm": "treaty_relation",
"c": 4
},
{
"o": 68,
"t": "u8",
"nm": "ref_dragoons",
"c": null
},
{
"o": 69,
"t": "u8",
"nm": "ref_regulars",
"c": null
},
{
"o": 70,
"t": "u8",
"nm": "ref_artillery",
"c": null
},
{
"o": 76,
"t": "u8",
"nm": "market_price",
"c": 16
},
{
"o": 92,
"t": "u16",
"nm": "market_pool",
"c": 16
},
{
"o": 124,
"t": "s32",
"nm": "market_traded_value",
"c": 16
},
{
"o": 188,
"t": "s32",
"nm": "market_traded_tons",
"c": 16
},
{
"o": 252,
"t": "s32",
"nm": "market_base_value",
"c": 16
}
]
},
{
"name": "NativeSettlement",
"ds": 21740,
"stride": 18,
"count": "g_settlement_count",
"n": 32,
"fields": [
{
"o": 0,
"t": "u8",
"nm": "map_x",
"c": null
},
{
"o": 1,
"t": "u8",
"nm": "map_y",
"c": null
},
{
"o": 2,
"t": "u8",
"nm": "tribe",
"c": null
},
{
"o": 3,
"t": "u8",
"nm": "flags",
"c": null
},
{
"o": 4,
"t": "u8",
"nm": "population",
"c": null
},
{
"o": 5,
"t": "u8",
"nm": "mission",
"c": null
},
{
"o": 6,
"t": "u8",
"nm": "growth_counter",
"c": null
},
{
"o": 10,
"t": "u16",
"nm": "alarm_by_power",
"c": 4
}
]
},
{
"name": "AIPersonality",
"ds": 21518,
"stride": 52,
"count": "fixed 4",
"n": 4,
"fields": [
{
"o": 48,
"t": "u8",
"nm": "field_30",
"c": null
},
{
"o": 49,
"t": "u8",
"nm": "controller_flag",
"c": null
},
{
"o": 50,
"t": "u8",
"nm": "named_colony_count",
"c": null
}
]
}
],
"thunks": [
{
"a": 108102,
"t": 9540,
"n": "resident__unattributed_002544",
"h": "B"
},
{
"a": 108112,
"t": 10386,
"n": "resident__unattributed_002892",
"h": "B"
},
{
"a": 108122,
"t": 9742,
"n": "format_to_buffer_2D54",
"h": "B"
},
{
"a": 108132,
"t": 9778,
"n": "rt_emit_long",
"h": "B"
},
{
"a": 108142,
"t": 9800,
"n": "rt_fmt_emit_1arg",
"h": "B"
},
{
"a": 108162,
"t": 9940,
"n": "resident__unattributed_0026D4",
"h": "B"
},
{
"a": 108182,
"t": 10046,
"n": "resident__unattributed_00273E",
"h": "B"
},
{
"a": 108192,
"t": 10076,
"n": "resident__unattributed_00275C",
"h": "B"
},
{
"a": 108202,
"t": 56810,
"n": "engine_band_00DDEA",
"h": "B"
},
{
"a": 108212,
"t": 58192,
"n": "buffer_z_c_00E350",
"h": "B"
},
{
"a": 108222,
"t": 57506,
"n": "buffer_b_c_00E0A2",
"h": "B"
},
{
"a": 108232,
"t": 10904,
"n": "write_obj_002A98",
"h": "B"
},
{
"a": 108242,
"t": 56122,
"n": "engine_band_00DB3A",
"h": "B"
},
{
"a": 108252,
"t": 19194,
"n": "drain_keyboard_buffer",
"h": "B"
},
{
"a": 108262,
"t": 53874,
"n": "kbhit",
"h": "B"
},
{
"a": 108272,
"t": 11208,
"n": "_write_centered",
"h": "B"
},
{
"a": 108282,
"t": 10514,
"n": "rt_libwrap_7a4_s5c",
"h": "B"
},
{
"a": 108292,
"t": 10950,
"n": "write_obj_002AC6",
"h": "B"
},
{
"a": 108302,
"t": 10530,
"n": "rt_libwrap_7a4_s5e",
"h": "B"
},
{
"a": 108312,
"t": 10546,
"n": "rt_libwrap_7a4_s60",
"h": "B"
},
{
"a": 108322,
"t": 11006,
"n": "write_obj_002AFE",
"h": "B"
},
{
"a": 108332,
"t": 11064,
"n": "write_obj_002B38",
"h": "B"
},
{
"a": 108342,
"t": 10594,
"n": "rt_libwrap_7a4_s66",
"h": "B"
},
{
"a": 108352,
"t": 11122,
"n": "write_obj_002B72",
"h": "B"
},
{
"a": 108362,
"t": 10610,
"n": "rt_libwrap_7a4_s68",
"h": "B"
},
{
"a": 108372,
"t": 10626,
"n": "rt_libwrap_7a4_s6a",
"h": "B"
},
{
"a": 108382,
"t": 10642,
"n": "write_obj_002992",
"h": "B"
},
{
"a": 108392,
"t": 10416,
"n": "call_overlay_with_80",
"h": "B"
},
{
"a": 108402,
"t": 10718,
"n": "write_obj_0029DE",
"h": "B"
},
{
"a": 108412,
"t": 11338,
"n": "write_obj_002C4A",
"h": "B"
},
{
"a": 108422,
"t": 10432,
"n": "_spacer",
"h": "B"
},
{
"a": 108432,
"t": 10758,
"n": "write_obj_002A06",
"h": "B"
},
{
"a": 108442,
"t": 11394,
"n": "write_obj_002C82",
"h": "B"
},
{
"a": 108452,
"t": 10466,
"n": "rt_libwrap_7a4_s52",
"h": "B"
},
{
"a": 108462,
"t": 10482,
"n": "rt_libwrap_7a4_s55",
"h": "B"
},
{
"a": 108472,
"t": 11488,
"n": "_write_big_centered",
"h": "B"
},
{
"a": 108482,
"t": 10862,
"n": "write_obj_002A6E",
"h": "B"
},
{
"a": 108492,
"t": 10498,
"n": "rt_libwrap_7a4_s58",
"h": "B"
},
{
"a": 108502,
"t": 11560,
"n": "_say_terrain",
"h": "B"
},
{
"a": 108512,
"t": 59018,
"n": "set_global_269E_byte_pair",
"h": "B"
},
{
"a": 108522,
"t": 58652,
"n": "font_2_c_00E51C",
"h": "B"
},
{
"a": 108532,
"t": 59046,
"n": "font_4_c_00E6A6",
"h": "B"
},
{
"a": 108542,
"t": 12362,
"n": "shared_game_band_00304A",
"h": "B"
},
{
"a": 108562,
"t": 13298,
"n": "shared_game_band_0033F2",
"h": "B"
},
{
"a": 108572,
"t": 12548,
"n": "shared_game_band_003104",
"h": "B"
},
{
"a": 108582,
"t": 12004,
"n": "shared_game_band_002EE4",
"h": "B"
},
{
"a": 108592,
"t": 11636,
"n": "shared_game_band_002D74",
"h": "B"
},
{
"a": 108602,
"t": 14348,
"n": "shared_game_band_00380C",
"h": "B"
},
{
"a": 108612,
"t": 59242,
"n": "engine_band_00E76A",
"h": "B"
},
{
"a": 108622,
"t": 13408,
"n": "shared_game_band_003460",
"h": "B"
},
{
"a": 108632,
"t": 13508,
"n": "shared_game_band_0034C4",
"h": "B"
},
{
"a": 108642,
"t": 13622,
"n": "shared_game_band_003536",
"h": "B"
},
{
"a": 108652,
"t": 13342,
"n": "shared_game_band_00341E",
"h": "B"
},
{
"a": 108662,
"t": 13804,
"n": "shared_game_band_0035EC",
"h": "B"
},
{
"a": 108696,
"t": 17172,
"n": "shared_game_band_004314",
"h": "B"
},
{
"a": 108706,
"t": 15936,
"n": "shared_game_band_003E40",
"h": "B"
},
{
"a": 108716,
"t": 14442,
"n": "shared_game_band_00386A",
"h": "B"
},
{
"a": 108736,
"t": 17766,
"n": "shared_game_band_004566",
"h": "B"
},
{
"a": 108746,
"t": 14096,
"n": "shared_game_band_003710",
"h": "B"
},
{
"a": 108756,
"t": 26298,
"n": "unit_field_lookup_simple",
"h": "B"
},
{
"a": 108766,
"t": 26226,
"n": "unit_chain_resolve",
"h": "B"
},
{
"a": 108776,
"t": 59748,
"n": "engine_band_00E964",
"h": "B"
},
{
"a": 108786,
"t": 23546,
"n": "_on_map",
"h": "B"
},
{
"a": 108796,
"t": 33440,
"n": "resident__unattributed_0082A0",
"h": "B"
},
{
"a": 108806,
"t": 286968,
"n": "native_raid_0460F8",
"h": "A"
},
{
"a": 108818,
"t": 34318,
"n": "resident__unattributed_00860E",
"h": "B"
},
{
"a": 108842,
"t": 56998,
"n": "buffer_6_c_00DEA6",
"h": "B"
},
{
"a": 108866,
"t": 48956,
"n": "resident__unattributed_00BF3C",
"h": "B"
},
{
"a": 108876,
"t": 18636,
"n": "stuff_obj_0048CC",
"h": "B"
},
{
"a": 108886,
"t": 18666,
"n": "stuff_obj_0048EA",
"h": "B"
},
{
"a": 108896,
"t": 18688,
"n": "_xy_dist",
"h": "B"
},
{
"a": 108906,
"t": 18748,
"n": "stuff_obj_00493C",
"h": "B"
},
{
"a": 108916,
"t": 18940,
"n": "_bearing_adjacent",
"h": "B"
},
{
"a": 108926,
"t": 19272,
"n": "shared_game_band_004B48",
"h": "B"
},
{
"a": 108956,
"t": 19742,
"n": "shared_game_band_004D1E",
"h": "B"
},
{
"a": 108976,
"t": 19072,
"n": "shared_game_band_004A80",
"h": "B"
},
{
"a": 108986,
"t": 19222,
"n": "shared_game_band_004B16",
"h": "B"
},
{
"a": 108996,
"t": 490206,
"n": "engine_error_077ADE",
"h": "A"
},
{
"a": 109008,
"t": 53894,
"n": "getch",
"h": "B"
},
{
"a": 109018,
"t": 20832,
"n": "shared_game_band_005160",
"h": "B"
},
{
"a": 109028,
"t": 53732,
"n": "engine_band_00D1E4",
"h": "B"
},
{
"a": 109062,
"t": 442912,
"n": "popup_engine_06C220",
"h": "A"
},
{
"a": 109074,
"t": 457448,
"n": "_text_search",
"h": "A"
},
{
"a": 109086,
"t": 32884,
"n": "resident__unattributed_008074",
"h": "B"
},
{
"a": 109096,
"t": 442940,
"n": "popup_engine_06C23C",
"h": "A"
},
{
"a": 109108,
"t": 56566,
"n": "buffer_4_c_00DCF6",
"h": "B"
},
{
"a": 109132,
"t": 53706,
"n": "engine_band_00D1CA",
"h": "B"
},
{
"a": 109142,
"t": 53510,
"n": "engine_band_00D106",
"h": "B"
},
{
"a": 109152,
"t": 20198,
"n": "shared_game_band_004EE6",
"h": "B"
},
{
"a": 109172,
"t": 56532,
"n": "engine_band_00DCD4",
"h": "B"
},
{
"a": 109182,
"t": 20668,
"n": "shared_game_band_0050BC",
"h": "B"
},
{
"a": 109192,
"t": 20720,
"n": "shared_game_band_0050F0",
"h": "B"
},
{
"a": 109202,
"t": 20732,
"n": "shared_game_band_0050FC",
"h": "B"
},
{
"a": 109212,
"t": 20744,
"n": "shared_game_band_005108",
"h": "B"
},
{
"a": 109222,
"t": 20796,
"n": "shared_game_band_00513C",
"h": "B"
},
{
"a": 109252,
"t": 49954,
"n": "resident__unattributed_00C322",
"h": "B"
},
{
"a": 109292,
"t": 20946,
"n": "shared_game_band_0051D2",
"h": "B"
},
{
"a": 109302,
"t": 21044,
"n": "shared_game_band_005234",
"h": "B"
},
{
"a": 109312,
"t": 21276,
"n": "shared_game_band_00531C",
"h": "B"
},
{
"a": 109322,
"t": 21528,
"n": "shared_game_band_005418",
"h": "B"
},
{
"a": 109332,
"t": 21564,
"n": "shared_game_band_00543C",
"h": "B"
},
{
"a": 109366,
"t": 22368,
"n": "shared_game_band_005760",
"h": "B"
},
{
"a": 109376,
"t": 355080,
"n": "natives_056B08",
"h": "A"
},
{
"a": 109390,
"t": 274548,
"n": "map_input_2_043074",
"h": "A"
},
{
"a": 109426,
"t": 197968,
"n": "europe_king_030550",
"h": "A"
},
{
"a": 109440,
"t": 48362,
"n": "resident__unattributed_00BCEA",
"h": "B"
},
{
"a": 109464,
"t": 467088,
"n": "boot_save_072090",
"h": "A"
},
{
"a": 109492,
"t": 51724,
"n": "engine_band_00CA0C",
"h": "B"
},
{
"a": 109546,
"t": 219910,
"n": "europe_king_035B06",
"h": "A"
},
{
"a": 109560,
"t": 181716,
"n": "colony_ui_02C5D4",
"h": "A"
},
{
"a": 109572,
"t": 33778,
"n": "resident__unattributed_0083F2",
"h": "B"
},
{
"a": 109596,
"t": 150088,
"n": "map_input_024A48",
"h": "A"
},
{
"a": 109608,
"t": 339838,
"n": "foreign_loot_052F7E",
"h": "A"
},
{
"a": 109634,
"t": 456178,
"n": "popup_engine_06F5F2",
"h": "A"
},
{
"a": 109646,
"t": 33150,
"n": "resident__unattributed_00817E",
"h": "B"
},
{
"a": 109670,
"t": 297242,
"n": "village_trade_04891A",
"h": "A"
},
{
"a": 109682,
"t": 24324,
"n": "map_xy_bounds_or_neg1",
"h": "B"
},
{
"a": 109692,
"t": 23886,
"n": "_feature_set",
"h": "B"
},
{
"a": 109702,
"t": 24392,
"n": "map_obj_005F48",
"h": "B"
},
{
"a": 109712,
"t": 23940,
"n": "map_obj_005D84",
"h": "B"
},
{
"a": 109722,
"t": 25092,
"n": "_terrain_fix_2",
"h": "B"
},
{
"a": 109732,
"t": 23994,
"n": "map_obj_005DBA",
"h": "B"
},
{
"a": 109742,
"t": 24532,
"n": "map_xy_bounds_or_neg1_alt",
"h": "B"
},
{
"a": 109752,
"t": 23596,
"n": "_on_colony_map",
"h": "B"
},
{
"a": 109762,
"t": 24600,
"n": "map_obj_006018",
"h": "B"
},
{
"a": 109772,
"t": 24048,
"n": "map_obj_005DF0",
"h": "B"
},
{
"a": 109782,
"t": 24634,
"n": "map_obj_00603A",
"h": "B"
},
{
"a": 109792,
"t": 24450,
"n": "map_obj_005F82",
"h": "B"
},
{
"a": 109802,
"t": 23728,
"n": "map_obj_005CB0",
"h": "B"
},
{
"a": 109812,
"t": 24088,
"n": "map_obj_005E18",
"h": "B"
},
{
"a": 109822,
"t": 23782,
"n": "map_obj_005CE6",
"h": "B"
},
{
"a": 109832,
"t": 24736,
"n": "tile_terrain_variant_hash",
"h": "B"
},
{
"a": 109842,
"t": 24208,
"n": "map_obj_005E90",
"h": "B"
},
{
"a": 109852,
"t": 23806,
"n": "map_tile_read_layer_15C",
"h": "B"
},
{
"a": 109862,
"t": 24272,
"n": "map_obj_005ED0",
"h": "B"
},
{
"a": 109872,
"t": 23834,
"n": "map_obj_005D1A",
"h": "B"
},
{
"a": 109882,
"t": 24296,
"n": "map_obj_005EE8",
"h": "B"
},
{
"a": 109892,
"t": 23858,
"n": "map_tile_read_layer_160",
"h": "B"
},
{
"a": 109902,
"t": 24968,
"n": "map_obj_006188",
"h": "B"
},
{
"a": 109912,
"t": 25268,
"n": "is_tile_walkable_or_special",
"h": "B"
},
{
"a": 109922,
"t": 490846,
"n": "error_1_c_077D5E",
"h": "A"
},
{
"a": 109948,
"t": 25210,
"n": "resident__unattributed_00627A",
"h": "B"
},
{
"a": 109958,
"t": 26052,
"n": "resident__unattributed_0065C4",
"h": "B"
},
{
"a": 109968,
"t": 26120,
"n": "resident__unattributed_006608",
"h": "B"
},
{
"a": 109978,
"t": 25526,
"n": "resident__unattributed_0063B6",
"h": "B"
},
{
"a": 109988,
"t": 48144,
"n": "is_arg2_negative",
"h": "B"
},
{
"a": 109998,
"t": 36134,
"n": "resident__unattributed_008D26",
"h": "B"
},
{
"a": 110008,
"t": 191260,
"n": "colony_econ_02EB1C",
"h": "A"
},
{
"a": 110022,
"t": 28700,
"n": "resident__unattributed_00701C",
"h": "B"
},
{
"a": 110032,
"t": 26316,
"n": "resident__unattributed_0066CC",
"h": "B"
},
{
"a": 110042,
"t": 27462,
"n": "resident__unattributed_006B46",
"h": "B"
},
{
"a": 110052,
"t": 31360,
"n": "resident__unattributed_007A80",
"h": "B"
},
{
"a": 110062,
"t": 29410,
"n": "resident__unattributed_0072E2",
"h": "B"
},
{
"a": 110072,
"t": 28308,
"n": "resident__unattributed_006E94",
"h": "B"
},
{
"a": 110082,
"t": 26794,
"n": "resident__unattributed_0068AA",
"h": "B"
},
{
"a": 110092,
"t": 30078,
"n": "resident__unattributed_00757E",
"h": "B"
},
{
"a": 110102,
"t": 29450,
"n": "resident__unattributed_00730A",
"h": "B"
},
{
"a": 110112,
"t": 31504,
"n": "resident__unattributed_007B10",
"h": "B"
},
{
"a": 110122,
"t": 30112,
"n": "resident__unattributed_0075A0",
"h": "B"
},
{
"a": 110132,
"t": 26938,
"n": "resident__unattributed_00693A",
"h": "B"
},
{
"a": 110142,
"t": 29526,
"n": "resident__unattributed_007356",
"h": "B"
},
{
"a": 110152,
"t": 30164,
"n": "resident__unattributed_0075D4",
"h": "B"
},
{
"a": 110162,
"t": 30180,
"n": "resident__unattributed_0075E4",
"h": "B"
},
{
"a": 110172,
"t": 28506,
"n": "resident__unattributed_006F5A",
"h": "B"
},
{
"a": 110182,
"t": 30206,
"n": "resident__unattributed_0075FE",
"h": "B"
},
{
"a": 110192,
"t": 27090,
"n": "resident__unattributed_0069D2",
"h": "B"
},
{
"a": 110202,
"t": 30964,
"n": "resident__unattributed_0078F4",
"h": "B"
},
{
"a": 110212,
"t": 29582,
"n": "resident__unattributed_00738E",
"h": "B"
},
{
"a": 110222,
"t": 27118,
"n": "resident__unattributed_0069EE",
"h": "B"
},
{
"a": 110232,
"t": 31588,
"n": "resident__unattributed_007B64",
"h": "B"
},
{
"a": 110242,
"t": 30224,
"n": "resident__unattributed_007610",
"h": "B"
},
{
"a": 110252,
"t": 29608,
"n": "resident__unattributed_0073A8",
"h": "B"
},
{
"a": 110262,
"t": 27152,
"n": "resident__unattributed_006A10",
"h": "B"
},
{
"a": 110272,
"t": 30256,
"n": "resident__unattributed_007630",
"h": "B"
},
{
"a": 110282,
"t": 28632,
"n": "resident__unattributed_006FD8",
"h": "B"
},
{
"a": 110312,
"t": 31030,
"n": "resident__unattributed_007936",
"h": "B"
},
{
"a": 110322,
"t": 30300,
"n": "resident__unattributed_00765C",
"h": "B"
},
{
"a": 110332,
"t": 27850,
"n": "unit_table_offset_calc",
"h": "B"
},
{
"a": 110342,
"t": 31078,
"n": "resident__unattributed_007966",
"h": "B"
},
{
"a": 110352,
"t": 30510,
"n": "resident__unattributed_00772E",
"h": "B"
},
{
"a": 110362,
"t": 26608,
"n": "resident__unattributed_0067F0",
"h": "B"
},
{
"a": 110372,
"t": 31694,
"n": "resident__unattributed_007BCE",
"h": "B"
},
{
"a": 110382,
"t": 28674,
"n": "resident__unattributed_007002",
"h": "B"
},
{
"a": 110392,
"t": 27260,
"n": "resident__unattributed_006A7C",
"h": "B"
},
{
"a": 110402,
"t": 29246,
"n": "resident__unattributed_00723E",
"h": "B"
},
{
"a": 110412,
"t": 27940,
"n": "resident__unattributed_006D24",
"h": "B"
},
{
"a": 110422,
"t": 31136,
"n": "resident__unattributed_0079A0",
"h": "B"
},
{
"a": 110432,
"t": 29294,
"n": "resident__unattributed_00726E",
"h": "B"
},
{
"a": 110442,
"t": 31264,
"n": "resident__unattributed_007A20",
"h": "B"
},
{
"a": 110452,
"t": 28748,
"n": "resident__unattributed_00704C",
"h": "B"
},
{
"a": 110472,
"t": 455962,
"n": "popup_obj_06F51A",
"h": "A"
},
{
"a": 110484,
"t": 33040,
"n": "resident__unattributed_008110",
"h": "B"
},
{
"a": 110494,
"t": 443004,
"n": "popup_obj_06C27C",
"h": "A"
},
{
"a": 110520,
"t": 31786,
"n": "resident__unattributed_007C2A",
"h": "B"
},
{
"a": 110530,
"t": 31720,
"n": "resident__unattributed_007BE8",
"h": "B"
},
{
"a": 110540,
"t": 32062,
"n": "combat_terrain_fort_bonus_fill",
"h": "B"
},
{
"a": 110550,
"t": 33500,
"n": "resident__unattributed_0082DC",
"h": "B"
},
{
"a": 110560,
"t": 286724,
"n": "native_raid_046004",
"h": "A"
},
{
"a": 110572,
"t": 34366,
"n": "wrapper_with_global_8DC6",
"h": "B"
},
{
"a": 110582,
"t": 32662,
"n": "resident__unattributed_007F96",
"h": "B"
},
{
"a": 110592,
"t": 32768,
"n": "resident__unattributed_008000",
"h": "B"
},
{
"a": 110602,
"t": 32968,
"n": "resident__unattributed_0080C8",
"h": "B"
},
{
"a": 110612,
"t": 33112,
"n": "resident__unattributed_008158",
"h": "B"
},
{
"a": 110622,
"t": 33188,
"n": "resident__unattributed_0081A4",
"h": "B"
},
{
"a": 110632,
"t": 32564,
"n": "resident__unattributed_007F34",
"h": "B"
},
{
"a": 110642,
"t": 33222,
"n": "resident__unattributed_0081C6",
"h": "B"
},
{
"a": 110652,
"t": 33266,
"n": "resident__unattributed_0081F2",
"h": "B"
},
{
"a": 110662,
"t": 33322,
"n": "resident__unattributed_00822A",
"h": "B"
},
{
"a": 110672,
"t": 33378,
"n": "resident__unattributed_008262",
"h": "B"
},
{
"a": 110682,
"t": 39594,
"n": "resident__unattributed_009AAA",
"h": "B"
},
{
"a": 110692,
"t": 37324,
"n": "resident__unattributed_0091CC",
"h": "B"
},
{
"a": 110702,
"t": 36716,
"n": "pack_nibble_at_60",
"h": "B"
},
{
"a": 110712,
"t": 38746,
"n": "resident__unattributed_00975A",
"h": "B"
},
{
"a": 110722,
"t": 34804,
"n": "power_record_read_dword",
"h": "B"
},
{
"a": 110732,
"t": 36788,
"n": "resident__unattributed_008FB4",
"h": "B"
},
{
"a": 110742,
"t": 39244,
"n": "resident__unattributed_00994C",
"h": "B"
},
{
"a": 110752,
"t": 34382,
"n": "resident__unattributed_00864E",
"h": "B"
},
{
"a": 110762,
"t": 34822,
"n": "resident__unattributed_008806",
"h": "B"
},
{
"a": 110772,
"t": 46682,
"n": "resident__unattributed_00B65A",
"h": "B"
},
{
"a": 110782,
"t": 38790,
"n": "resident__unattributed_009786",
"h": "B"
},
{
"a": 110792,
"t": 47232,
"n": "colony_helper_8dc4_a",
"h": "B"
},
{
"a": 110802,
"t": 47978,
"n": "resident__unattributed_00BB6A",
"h": "B"
},
{
"a": 110812,
"t": 46124,
"n": "resident__unattributed_00B42C",
"h": "B"
},
{
"a": 110822,
"t": 34886,
"n": "resident__unattributed_008846",
"h": "B"
},
{
"a": 110832,
"t": 36252,
"n": "lookup_table_2F4_signed",
"h": "B"
},
{
"a": 110842,
"t": 37530,
"n": "classify_pair_bounds",
"h": "B"
},
{
"a": 110852,
"t": 34438,
"n": "resident__unattributed_008686",
"h": "B"
},
{
"a": 110862,
"t": 34914,
"n": "resident__unattributed_008862",
"h": "B"
},
{
"a": 110872,
"t": 35734,
"n": "unit_field_test_at_3146",
"h": "B"
},
{
"a": 110882,
"t": 45630,
"n": "resident__unattributed_00B23E",
"h": "B"
},
{
"a": 110892,
"t": 39836,
"n": "resident__unattributed_009B9C",
"h": "B"
},
{
"a": 110902,
"t": 36926,
"n": "resident__unattributed_00903E",
"h": "B"
},
{
"a": 110912,
"t": 36284,
"n": "resident__unattributed_008DBC",
"h": "B"
},
{
"a": 110922,
"t": 34940,
"n": "resident__unattributed_00887C",
"h": "B"
},
{
"a": 110932,
"t": 48024,
"n": "resident__unattributed_00BB98",
"h": "B"
},
{
"a": 110942,
"t": 43896,
"n": "resident__unattributed_00AB78",
"h": "B"
},
{
"a": 110952,
"t": 35762,
"n": "resident__unattributed_008BB2",
"h": "B"
},
{
"a": 110962,
"t": 38438,
"n": "colony_leaf_calls_90c8",
"h": "B"
},
{
"a": 110972,
"t": 47360,
"n": "resident__unattributed_00B900",
"h": "B"
},
{
"a": 110982,
"t": 46264,
"n": "resident__unattributed_00B4B8",
"h": "B"
},
{
"a": 110992,
"t": 34496,
"n": "resident__unattributed_0086C0",
"h": "B"
},
{
"a": 111002,
"t": 38936,
"n": "resident__unattributed_009818",
"h": "B"
},
{
"a": 111012,
"t": 46852,
"n": "resident__unattributed_00B704",
"h": "B"
},
{
"a": 111022,
"t": 37600,
"n": "colony_flag_bit_set",
"h": "B"
},
{
"a": 111032,
"t": 35796,
"n": "resident__unattributed_008BD4",
"h": "B"
},
{
"a": 111042,
"t": 43326,
"n": "resident__unattributed_00A93E",
"h": "B"
},
{
"a": 111052,
"t": 34532,
"n": "resident__unattributed_0086E4",
"h": "B"
},
{
"a": 111062,
"t": 45730,
"n": "resident__unattributed_00B2A2",
"h": "B"
},
{
"a": 111072,
"t": 38492,
"n": "colony_leaf_calls_9102",
"h": "B"
},
{
"a": 111092,
"t": 41506,
"n": "resident__unattributed_00A222",
"h": "B"
},
{
"a": 111102,
"t": 37064,
"n": "current_unit_field_at_20",
"h": "B"
},
{
"a": 111112,
"t": 34012,
"n": "resident__unattributed_0084DC",
"h": "B"
},
{
"a": 111132,
"t": 46416,
"n": "resident__unattributed_00B550",
"h": "B"
},
{
"a": 111142,
"t": 37656,
"n": "colony_production_accumulate",
"h": "B"
},
{
"a": 111152,
"t": 34034,
"n": "resident__unattributed_0084F2",
"h": "B"
},
{
"a": 111162,
"t": 35870,
"n": "resident__unattributed_008C1E",
"h": "B"
},
{
"a": 111172,
"t": 37122,
"n": "current_unit_field_at_40",
"h": "B"
},
{
"a": 111192,
"t": 45808,
"n": "unit_table_3154_byte",
"h": "B"
},
{
"a": 111202,
"t": 43412,
"n": "resident__unattributed_00A994",
"h": "B"
},
{
"a": 111212,
"t": 34612,
"n": "resident__unattributed_008734",
"h": "B"
},
{
"a": 111222,
"t": 34084,
"n": "resident__unattributed_008524",
"h": "B"
},
{
"a": 111232,
"t": 35096,
"n": "blit_at_origin_if_pair_visible",
"h": "B"
},
{
"a": 111242,
"t": 33458,
"n": "resident__unattributed_0082B2",
"h": "B"
},
{
"a": 111252,
"t": 45828,
"n": "resident__unattributed_00B304",
"h": "B"
},
{
"a": 111262,
"t": 37180,
"n": "set_field_at_40_or_unit_byte",
"h": "B"
},
{
"a": 111272,
"t": 39092,
"n": "resident__unattributed_0098B4",
"h": "B"
},
{
"a": 111282,
"t": 46504,
"n": "resident__unattributed_00B5A8",
"h": "B"
},
{
"a": 111292,
"t": 35952,
"n": "resident__unattributed_008C70",
"h": "B"
},
{
"a": 111302,
"t": 40956,
"n": "resident__unattributed_009FFC",
"h": "B"
},
{
"a": 111312,
"t": 35158,
"n": "lookup_byte_from_pair",
"h": "B"
},
{
"a": 111322,
"t": 45850,
"n": "resident__unattributed_00B31A",
"h": "B"
},
{
"a": 111332,
"t": 38618,
"n": "colony_leaf_activecol",
"h": "B"
},
{
"a": 111342,
"t": 34226,
"n": "test_bit_at_8a",
"h": "B"
},
{
"a": 111352,
"t": 36610,
"n": "check_total_exceeds_threshold",
"h": "B"
},
{
"a": 111362,
"t": 33618,
"n": "resident__unattributed_008352",
"h": "B"
},
{
"a": 111372,
"t": 36650,
"n": "unpack_nibble_at_60",
"h": "B"
},
{
"a": 111382,
"t": 34262,
"n": "set_or_clear_bit_at_8a",
"h": "B"
},
{
"a": 111392,
"t": 39158,
"n": "resident__unattributed_0098F6",
"h": "B"
},
{
"a": 111402,
"t": 36096,
"n": "step_100_or_level_scaled",
"h": "B"
},
{
"a": 111412,
"t": 35202,
"n": "resident__unattributed_008982",
"h": "B"
},
{
"a": 111422,
"t": 46586,
"n": "resident__unattributed_00B5FA",
"h": "B"
},
{
"a": 111432,
"t": 45928,
"n": "colony_helper_b2a2",
"h": "B"
},
{
"a": 111442,
"t": 38694,
"n": "resident__unattributed_009726",
"h": "B"
},
{
"a": 111452,
"t": 286194,
"n": "native_raid_045DF2",
"h": "A"
},
{
"a": 111464,
"t": 287938,
"n": "native_raid_0464C2",
"h": "A"
},
{
"a": 111476,
"t": 286806,
"n": "native_raid_046056",
"h": "A"
},
{
"a": 111488,
"t": 49930,
"n": "resident__unattributed_00C30A",
"h": "B"
},
{
"a": 111498,
"t": 49138,
"n": "resident__unattributed_00BFF2",
"h": "B"
},
{
"a": 111508,
"t": 49162,
"n": "resident__unattributed_00C00A",
"h": "B"
},
{
"a": 111518,
"t": 48298,
"n": "resident__unattributed_00BCAA",
"h": "B"
},
{
"a": 111528,
"t": 48424,
"n": "resident__unattributed_00BD28",
"h": "B"
},
{
"a": 111538,
"t": 49274,
"n": "resident__unattributed_00C07A",
"h": "B"
},
{
"a": 111548,
"t": 48458,
"n": "resident__unattributed_00BD4A",
"h": "B"
},
{
"a": 111558,
"t": 49306,
"n": "resident__unattributed_00C09A",
"h": "B"
},
{
"a": 111568,
"t": 49326,
"n": "resident__unattributed_00C0AE",
"h": "B"
},
{
"a": 111578,
"t": 49360,
"n": "resident__unattributed_00C0D0",
"h": "B"
},
{
"a": 111588,
"t": 49530,
"n": "resident__unattributed_00C17A",
"h": "B"
},
{
"a": 111598,
"t": 49656,
"n": "resident__unattributed_00C1F8",
"h": "B"
},
{
"a": 111608,
"t": 48862,
"n": "resident__unattributed_00BEDE",
"h": "B"
},
{
"a": 111618,
"t": 49782,
"n": "resident__unattributed_00C276",
"h": "B"
},
{
"a": 111656,
"t": 420784,
"n": "me_mini_obj_066BB0",
"h": "A"
},
{
"a": 111670,
"t": 273830,
"n": "map_input_2_042DA6",
"h": "A"
},
{
"a": 111682,
"t": 282236,
"n": "menu_obj_044E7C",
"h": "A"
},
{
"a": 111724,
"t": 50192,
"n": "env_1_obj_00C410",
"h": "B"
},
{
"a": 111734,
"t": 50266,
"n": "resident__unattributed_00C45A",
"h": "B"
},
{
"a": 111744,
"t": 50328,
"n": "resident__unattributed_00C498",
"h": "B"
},
{
"a": 111754,
"t": 50018,
"n": "env_1_obj_00C362",
"h": "B"
},
{
"a": 111764,
"t": 50758,
"n": "resident__unattributed_00C646",
"h": "B"
},
{
"a": 111774,
"t": 50340,
"n": "resident__unattributed_00C4A4",
"h": "B"
},
{
"a": 111794,
"t": 51353,
"n": "timer_3_ASM_00C899",
"h": "B"
},
{
"a": 111804,
"t": 51452,
"n": "at_buffer_conform",
"h": "B"
},
{
"a": 111814,
"t": 62736,
"n": "video_1_ASM_00F510",
"h": "B"
},
{
"a": 111844,
"t": 142662,
"n": "map_input_022D46",
"h": "A"
},
{
"a": 111868,
"t": 139250,
"n": "map_input_021FF2",
"h": "A"
},
{
"a": 111880,
"t": 144748,
"n": "map_input_02356C",
"h": "A"
},
{
"a": 111904,
"t": 147918,
"n": "map_input_0241CE",
"h": "A"
},
{
"a": 111916,
"t": 134880,
"n": "map_input_020EE0",
"h": "A"
},
{
"a": 111928,
"t": 136706,
"n": "map_input_021602",
"h": "A"
},
{
"a": 111940,
"t": 144196,
"n": "map_input_023344",
"h": "A"
},
{
"a": 111952,
"t": 142870,
"n": "map_input_022E16",
"h": "A"
},
{
"a": 111976,
"t": 144854,
"n": "map_input_0235D6",
"h": "A"
},
{
"a": 111988,
"t": 141288,
"n": "map_input_0227E8",
"h": "A"
},
{
"a": 112000,
"t": 141882,
"n": "map_input_022A3A",
"h": "A"
},
{
"a": 112012,
"t": 138546,
"n": "map_input_021D32",
"h": "A"
},
{
"a": 112024,
"t": 148004,
"n": "map_input_024224",
"h": "A"
},
{
"a": 112048,
"t": 136798,
"n": "map_input_02165E",
"h": "A"
},
{
"a": 112060,
"t": 148934,
"n": "map_input_0245C6",
"h": "A"
},
{
"a": 112084,
"t": 140610,
"n": "map_input_022542",
"h": "A"
},
{
"a": 112096,
"t": 147228,
"n": "map_input_023F1C",
"h": "A"
},
{
"a": 112112,
"t": 143112,
"n": "map_input_022F08",
"h": "A"
},
{
"a": 112124,
"t": 139550,
"n": "map_input_02211E",
"h": "A"
},
{
"a": 112160,
"t": 149042,
"n": "map_input_024632",
"h": "A"
},
{
"a": 112172,
"t": 141362,
"n": "map_input_022832",
"h": "A"
},
{
"a": 112184,
"t": 148142,
"n": "map_input_0242AE",
"h": "A"
},
{
"a": 112196,
"t": 138866,
"n": "map_input_021E72",
"h": "A"
},
{
"a": 112232,
"t": 149138,
"n": "map_input_024692",
"h": "A"
},
{
"a": 112244,
"t": 148258,
"n": "map_input_024322",
"h": "A"
},
{
"a": 112292,
"t": 138974,
"n": "map_input_021EDE",
"h": "A"
},
{
"a": 112304,
"t": 137704,
"n": "map_input_0219E8",
"h": "A"
},
{
"a": 112316,
"t": 148290,
"n": "map_input_024342",
"h": "A"
},
{
"a": 112328,
"t": 141438,
"n": "map_input_02287E",
"h": "A"
},
{
"a": 112340,
"t": 137748,
"n": "map_input_021A14",
"h": "A"
},
{
"a": 112352,
"t": 149218,
"n": "map_input_0246E2",
"h": "A"
},
{
"a": 112364,
"t": 142556,
"n": "map_input_022CDC",
"h": "A"
},
{
"a": 112388,
"t": 140084,
"n": "map_input_022334",
"h": "A"
},
{
"a": 112400,
"t": 456268,
"n": "popup_obj_06F64C",
"h": "A"
},
{
"a": 112426,
"t": 281350,
"n": "menu_obj_044B06",
"h": "A"
},
{
"a": 112438,
"t": 281234,
"n": "menu_obj_044A92",
"h": "A"
},
{
"a": 112450,
"t": 281398,
"n": "menu_obj_044B36",
"h": "A"
},
{
"a": 112462,
"t": 281282,
"n": "menu_obj_044AC2",
"h": "A"
},
{
"a": 112474,
"t": 451536,
"n": "popup_obj_06E3D0",
"h": "A"
},
{
"a": 112486,
"t": 444496,
"n": "popup_obj_06C850",
"h": "A"
},
{
"a": 112498,
"t": 454900,
"n": "popup_obj_06F0F4",
"h": "A"
},
{
"a": 112524,
"t": 456112,
"n": "popup_engine_06F5B0",
"h": "A"
},
{
"a": 112550,
"t": 444234,
"n": "popup_engine_06C74A",
"h": "A"
},
{
"a": 112562,
"t": 263766,
"n": "pioneer_routes_040656",
"h": "A"
},
{
"a": 112576,
"t": 267280,
"n": "pioneer_routes_041410",
"h": "A"
},
{
"a": 112590,
"t": 267860,
"n": "pioneer_routes_041654",
"h": "A"
},
{
"a": 112604,
"t": 191164,
"n": "colony_econ_02EABC",
"h": "A"
},
{
"a": 112618,
"t": 265246,
"n": "pioneer_routes_040C1E",
"h": "A"
},
{
"a": 112646,
"t": 264662,
"n": "pioneer_routes_0409D6",
"h": "A"
},
{
"a": 112660,
"t": 446330,
"n": "popup_obj_06CF7A",
"h": "A"
},
{
"a": 112672,
"t": 445836,
"n": "popup_obj_06CD8C",
"h": "A"
},
{
"a": 112684,
"t": 443680,
"n": "popup_engine_06C520",
"h": "A"
},
{
"a": 112696,
"t": 290496,
"n": "village_trade_046EC0",
"h": "A"
},
{
"a": 112708,
"t": 192052,
"n": "colony_econ_02EE34",
"h": "A"
},
{
"a": 112722,
"t": 456020,
"n": "at_pop_set",
"h": "A"
},
{
"a": 112802,
"t": 266368,
"n": "pioneer_routes_041080",
"h": "A"
},
{
"a": 112816,
"t": 395114,
"n": "trade_editor_06076A",
"h": "A"
},
{
"a": 112830,
"t": 392800,
"n": "trade_editor_05FE60",
"h": "A"
},
{
"a": 112844,
"t": 394742,
"n": "trade_editor_0605F6",
"h": "A"
},
{
"a": 112872,
"t": 393254,
"n": "trade_editor_060026",
"h": "A"
},
{
"a": 112886,
"t": 456062,
"n": "popup_obj_06F57E",
"h": "A"
},
{
"a": 112940,
"t": 444282,
"n": "popup_engine_06C77A",
"h": "A"
},
{
"a": 112994,
"t": 439192,
"n": "dialog_pedia_06B398",
"h": "A"
},
{
"a": 113008,
"t": 398054,
"n": "trade_editor_0612E6",
"h": "A"
},
{
"a": 113022,
"t": 397244,
"n": "trade_editor_060FBC",
"h": "A"
},
{
"a": 113036,
"t": 397488,
"n": "trade_editor_0610B0",
"h": "A"
},
{
"a": 113064,
"t": 235656,
"n": "reports_039888",
"h": "A"
},
{
"a": 113078,
"t": 234828,
"n": "reports_03954C",
"h": "A"
},
{
"a": 113092,
"t": 234008,
"n": "reports_039218",
"h": "A"
},
{
"a": 113106,
"t": 232016,
"n": "reports_038A50",
"h": "A"
},
{
"a": 113120,
"t": 230424,
"n": "reports_038418",
"h": "A"
},
{
"a": 113134,
"t": 227856,
"n": "reports_037A10",
"h": "A"
},
{
"a": 113148,
"t": 227672,
"n": "reports_037958",
"h": "A"
},
{
"a": 113162,
"t": 226378,
"n": "reports_03744A",
"h": "A"
},
{
"a": 113176,
"t": 433548,
"n": "dialog_pedia_069D8C",
"h": "A"
},
{
"a": 113190,
"t": 456344,
"n": "popup_engine_06F698",
"h": "A"
},
{
"a": 113202,
"t": 290754,
"n": "village_trade_046FC2",
"h": "A"
},
{
"a": 113228,
"t": 281178,
"n": "_menu_bar_hide",
"h": "A"
},
{
"a": 113240,
"t": 55776,
"n": "engine_band_00D9E0",
"h": "B"
},
{
"a": 113250,
"t": 283348,
"n": "menu_obj_0452D4",
"h": "A"
},
{
"a": 113262,
"t": 284908,
"n": "at_menu_bar_mouse_parse",
"h": "A"
},
{
"a": 113274,
"t": 285214,
"n": "at_menu_key_parse",
"h": "A"
},
{
"a": 113286,
"t": 285066,
"n": "menu_obj_04598A",
"h": "A"
},
{
"a": 113308,
"t": 266268,
"n": "pioneer_routes_04101C",
"h": "A"
},
{
"a": 113322,
"t": 265762,
"n": "pioneer_routes_040E22",
"h": "A"
},
{
"a": 113348,
"t": 164966,
"n": "colony_ui_028466",
"h": "A"
},
{
"a": 113360,
"t": 159772,
"n": "colony_ui_02701C",
"h": "A"
},
{
"a": 113372,
"t": 164172,
"n": "colony_ui_02814C",
"h": "A"
},
{
"a": 113396,
"t": 155682,
"n": "colony_ui_026022",
"h": "A"
},
{
"a": 113420,
"t": 165926,
"n": "colony_ui_028826",
"h": "A"
},
{
"a": 113432,
"t": 176800,
"n": "colony_ui_02B2A0",
"h": "A"
},
{
"a": 113444,
"t": 156840,
"n": "colony_ui_0264A8",
"h": "A"
},
{
"a": 113456,
"t": 170884,
"n": "colony_ui_029B84",
"h": "A"
},
{
"a": 113468,
"t": 165950,
"n": "colony_ui_02883E",
"h": "A"
},
{
"a": 113480,
"t": 161230,
"n": "colony_ui_0275CE",
"h": "A"
},
{
"a": 113492,
"t": 158386,
"n": "colony_ui_026AB2",
"h": "A"
},
{
"a": 113504,
"t": 178652,
"n": "colony_ui_02B9DC",
"h": "A"
},
{
"a": 113516,
"t": 162132,
"n": "colony_ui_027954",
"h": "A"
},
{
"a": 113528,
"t": 176078,
"n": "colony_ui_02AFCE",
"h": "A"
},
{
"a": 113540,
"t": 173734,
"n": "colony_ui_02A6A6",
"h": "A"
},
{
"a": 113552,
"t": 170942,
"n": "colony_ui_029BBE",
"h": "A"
},
{
"a": 113564,
"t": 164254,
"n": "colony_ui_02819E",
"h": "A"
},
{
"a": 113576,
"t": 163204,
"n": "colony_ui_027D84",
"h": "A"
},
{
"a": 113588,
"t": 159952,
"n": "colony_ui_0270D0",
"h": "A"
},
{
"a": 113600,
"t": 179314,
"n": "colony_ui_02BC72",
"h": "A"
},
{
"a": 113612,
"t": 165180,
"n": "colony_ui_02853C",
"h": "A"
},
{
"a": 113624,
"t": 154932,
"n": "colony_ui_025D34",
"h": "A"
},
{
"a": 113660,
"t": 163250,
"n": "colony_ui_027DB2",
"h": "A"
},
{
"a": 113672,
"t": 154142,
"n": "colony_ui_025A1E",
"h": "A"
},
{
"a": 113684,
"t": 172828,
"n": "colony_ui_02A31C",
"h": "A"
},
{
"a": 113696,
"t": 155970,
"n": "colony_ui_026142",
"h": "A"
},
{
"a": 113708,
"t": 171024,
"n": "colony_ui_029C10",
"h": "A"
},
{
"a": 113720,
"t": 165266,
"n": "colony_ui_028592",
"h": "A"
},
{
"a": 113732,
"t": 164310,
"n": "colony_ui_0281D6",
"h": "A"
},
{
"a": 113744,
"t": 162188,
"n": "colony_ui_02798C",
"h": "A"
},
{
"a": 113756,
"t": 159188,
"n": "colony_ui_026DD4",
"h": "A"
},
{
"a": 113768,
"t": 177988,
"n": "colony_ui_02B744",
"h": "A"
},
{
"a": 113792,
"t": 177000,
"n": "colony_ui_02B368",
"h": "A"
},
{
"a": 113828,
"t": 176198,
"n": "colony_ui_02B046",
"h": "A"
},
{
"a": 113840,
"t": 158914,
"n": "colony_ui_026CC2",
"h": "A"
},
{
"a": 113852,
"t": 170400,
"n": "colony_ui_0299A0",
"h": "A"
},
{
"a": 113864,
"t": 161606,
"n": "colony_ui_027746",
"h": "A"
},
{
"a": 113876,
"t": 158668,
"n": "colony_ui_026BCC",
"h": "A"
},
{
"a": 113888,
"t": 154674,
"n": "colony_ui_025C32",
"h": "A"
},
{
"a": 113912,
"t": 162522,
"n": "colony_ui_027ADA",
"h": "A"
},
{
"a": 113924,
"t": 175502,
"n": "colony_ui_02AD8E",
"h": "A"
},
{
"a": 113936,
"t": 174316,
"n": "colony_ui_02A8EC",
"h": "A"
},
{
"a": 113948,
"t": 177362,
"n": "colony_ui_02B4D2",
"h": "A"
},
{
"a": 113972,
"t": 179082,
"n": "colony_ui_02BB8A",
"h": "A"
},
{
"a": 113984,
"t": 167308,
"n": "colony_ui_028D8C",
"h": "A"
},
{
"a": 114008,
"t": 171300,
"n": "colony_ui_029D24",
"h": "A"
},
{
"a": 114032,
"t": 178374,
"n": "colony_ui_02B8C6",
"h": "A"
},
{
"a": 114056,
"t": 162742,
"n": "colony_ui_027BB6",
"h": "A"
},
{
"a": 114068,
"t": 172220,
"n": "colony_ui_02A0BC",
"h": "A"
},
{
"a": 114080,
"t": 165778,
"n": "colony_ui_028792",
"h": "A"
},
{
"a": 114092,
"t": 155374,
"n": "colony_ui_025EEE",
"h": "A"
},
{
"a": 114104,
"t": 174828,
"n": "colony_ui_02AAEC",
"h": "A"
},
{
"a": 114116,
"t": 165810,
"n": "colony_ui_0287B2",
"h": "A"
},
{
"a": 114128,
"t": 170688,
"n": "colony_ui_029AC0",
"h": "A"
},
{
"a": 114140,
"t": 156478,
"n": "colony_ui_02633E",
"h": "A"
},
{
"a": 114152,
"t": 173154,
"n": "colony_ui_02A462",
"h": "A"
},
{
"a": 114164,
"t": 156532,
"n": "colony_ui_026374",
"h": "A"
},
{
"a": 114176,
"t": 171476,
"n": "colony_ui_029DD4",
"h": "A"
},
{
"a": 114188,
"t": 165830,
"n": "colony_ui_0287C6",
"h": "A"
},
{
"a": 114200,
"t": 164908,
"n": "colony_ui_02842C",
"h": "A"
},
{
"a": 114212,
"t": 159730,
"n": "colony_ui_026FF2",
"h": "A"
},
{
"a": 114224,
"t": 157902,
"n": "colony_ui_0268CE",
"h": "A"
},
{
"a": 114236,
"t": 153856,
"n": "colony_ui_025900",
"h": "A"
},
{
"a": 114248,
"t": 175834,
"n": "colony_ui_02AEDA",
"h": "A"
},
{
"a": 114260,
"t": 165866,
"n": "colony_ui_0287EA",
"h": "A"
},
{
"a": 114272,
"t": 62544,
"n": "at_sort_insertion_8",
"h": "B"
},
{
"a": 114338,
"t": 57398,
"n": "at_buffer_vline",
"h": "B"
},
{
"a": 114348,
"t": 57292,
"n": "at_buffer_hline",
"h": "B"
},
{
"a": 114358,
"t": 445058,
"n": "popup_obj_06CA82",
"h": "A"
},
{
"a": 114370,
"t": 445042,
"n": "popup_obj_06CA72",
"h": "A"
},
{
"a": 114382,
"t": 435968,
"n": "dialog_pedia_06A700",
"h": "A"
},
{
"a": 114396,
"t": 444466,
"n": "popup_obj_06C832",
"h": "A"
},
{
"a": 114408,
"t": 56192,
"n": "engine_band_00DB80",
"h": "B"
},
{
"a": 114418,
"t": 436872,
"n": "dialog_pedia_06AA88",
"h": "A"
},
{
"a": 114432,
"t": 454380,
"n": "popup_obj_06EEEC",
"h": "A"
},
{
"a": 114456,
"t": 456954,
"n": "text_widget_06F8FA",
"h": "A"
},
{
"a": 114468,
"t": 431278,
"n": "dialog_pedia_0694AE",
"h": "A"
},
{
"a": 114482,
"t": 431814,
"n": "dialog_pedia_0696C6",
"h": "A"
},
{
"a": 114496,
"t": 185944,
"n": "colony_econ_02D658",
"h": "A"
},
{
"a": 114538,
"t": 184548,
"n": "colony_econ_02D0E4",
"h": "A"
},
{
"a": 114552,
"t": 185098,
"n": "colony_econ_02D30A",
"h": "A"
},
{
"a": 114566,
"t": 191302,
"n": "colony_econ_02EB46",
"h": "A"
},
{
"a": 114580,
"t": 191210,
"n": "colony_econ_02EAEA",
"h": "A"
},
{
"a": 114594,
"t": 191352,
"n": "colony_econ_02EB78",
"h": "A"
},
{
"a": 114608,
"t": 185862,
"n": "colony_econ_02D606",
"h": "A"
},
{
"a": 114622,
"t": 185286,
"n": "colony_econ_02D3C6",
"h": "A"
},
{
"a": 114636,
"t": 184272,
"n": "colony_econ_02CFD0",
"h": "A"
},
{
"a": 114650,
"t": 198032,
"n": "europe_king_030590",
"h": "A"
},
{
"a": 114664,
"t": 246562,
"n": "revolution_03C322",
"h": "A"
},
{
"a": 114692,
"t": 379518,
"n": "combat_aftermath_05CA7E",
"h": "A"
},
{
"a": 114718,
"t": 205642,
"n": "europe_king_03234A",
"h": "A"
},
{
"a": 114732,
"t": 394350,
"n": "trade_editor_06046E",
"h": "A"
},
{
"a": 114746,
"t": 392826,
"n": "trade_editor_05FE7A",
"h": "A"
},
{
"a": 114816,
"t": 222114,
"n": "europe_king_0363A2",
"h": "A"
},
{
"a": 114844,
"t": 484756,
"n": "engine_io_076594",
"h": "A"
},
{
"a": 114872,
"t": 442964,
"n": "popup_engine_06C254",
"h": "A"
},
{
"a": 114884,
"t": 456154,
"n": "popup_obj_06F5DA",
"h": "A"
},
{
"a": 114896,
"t": 213784,
"n": "europe_king_034318",
"h": "A"
},
{
"a": 114924,
"t": 216100,
"n": "europe_king_034C24",
"h": "A"
},
{
"a": 114966,
"t": 199784,
"n": "europe_king_030C68",
"h": "A"
},
{
"a": 114980,
"t": 220570,
"n": "immigration_threshold_and_cross_production",
"h": "A"
},
{
"a": 114994,
"t": 206066,
"n": "europe_king_0324F2",
"h": "A"
},
{
"a": 115008,
"t": 204584,
"n": "europe_king_031F28",
"h": "A"
},
{
"a": 115022,
"t": 201902,
"n": "europe_king_0314AE",
"h": "A"
},
{
"a": 115036,
"t": 222580,
"n": "europe_king_036574",
"h": "A"
},
{
"a": 115050,
"t": 221496,
"n": "king_tax_demand_and_pretext",
"h": "A"
},
{
"a": 115064,
"t": 208866,
"n": "europe_king_032FE2",
"h": "A"
},
{
"a": 115078,
"t": 204616,
"n": "europe_king_031F48",
"h": "A"
},
{
"a": 115092,
"t": 213462,
"n": "europe_king_0341D6",
"h": "A"
},
{
"a": 115106,
"t": 217248,
"n": "europe_king_0350A0",
"h": "A"
},
{
"a": 115120,
"t": 203174,
"n": "europe_king_0319A6",
"h": "A"
},
{
"a": 115134,
"t": 215540,
"n": "europe_king_0349F4",
"h": "A"
},
{
"a": 115148,
"t": 204636,
"n": "europe_king_031F5C",
"h": "A"
},
{
"a": 115162,
"t": 199958,
"n": "europe_king_030D16",
"h": "A"
},
{
"a": 115176,
"t": 210710,
"n": "europe_king_033716",
"h": "A"
},
{
"a": 115190,
"t": 209742,
"n": "boycott_lift_backtax",
"h": "A"
},
{
"a": 115204,
"t": 205520,
"n": "europe_king_0322D0",
"h": "A"
},
{
"a": 115218,
"t": 204672,
"n": "europe_king_031F80",
"h": "A"
},
{
"a": 115232,
"t": 203196,
"n": "europe_king_0319BC",
"h": "A"
},
{
"a": 115246,
"t": 197990,
"n": "commodity_current_price",
"h": "A"
},
{
"a": 115260,
"t": 211538,
"n": "europe_king_033A52",
"h": "A"
},
{
"a": 115274,
"t": 204810,
"n": "europe_king_03200A",
"h": "A"
},
{
"a": 115288,
"t": 201368,
"n": "europe_king_031298",
"h": "A"
},
{
"a": 115316,
"t": 220800,
"n": "europe_king_035E80",
"h": "A"
},
{
"a": 115330,
"t": 215776,
"n": "europe_king_034AE0",
"h": "A"
},
{
"a": 115344,
"t": 218302,
"n": "europe_king_0354BE",
"h": "A"
},
{
"a": 115358,
"t": 209964,
"n": "europe_king_03342C",
"h": "A"
},
{
"a": 115372,
"t": 198056,
"n": "market_price_drift",
"h": "A"
},
{
"a": 115386,
"t": 214814,
"n": "europe_king_03471E",
"h": "A"
},
{
"a": 115400,
"t": 199480,
"n": "boycott_is_good_boycotted",
"h": "A"
},
{
"a": 115414,
"t": 200070,
"n": "europe_king_030D86",
"h": "A"
},
{
"a": 115428,
"t": 210808,
"n": "europe_king_033778",
"h": "A"
},
{
"a": 115442,
"t": 207124,
"n": "europe_king_032914",
"h": "A"
},
{
"a": 115470,
"t": 209230,
"n": "europe_ship_arrival_trade_handler",
"h": "A"
},
{
"a": 115484,
"t": 216532,
"n": "europe_king_034DD4",
"h": "A"
},
{
"a": 115498,
"t": 200180,
"n": "europe_king_030DF4",
"h": "A"
},
{
"a": 115526,
"t": 203314,
"n": "europe_king_031A32",
"h": "A"
},
{
"a": 115554,
"t": 205038,
"n": "europe_king_0320EE",
"h": "A"
},
{
"a": 115568,
"t": 199606,
"n": "europe_king_030BB6",
"h": "A"
},
{
"a": 115582,
"t": 205836,
"n": "europe_king_03240C",
"h": "A"
},
{
"a": 115596,
"t": 202700,
"n": "europe_king_0317CC",
"h": "A"
},
{
"a": 115610,
"t": 211940,
"n": "europe_king_033BE4",
"h": "A"
},
{
"a": 115624,
"t": 205090,
"n": "europe_king_032122",
"h": "A"
},
{
"a": 115638,
"t": 205916,
"n": "europe_king_03245C",
"h": "A"
},
{
"a": 115666,
"t": 203514,
"n": "europe_king_031AFA",
"h": "A"
},
{
"a": 115680,
"t": 201574,
"n": "europe_king_031366",
"h": "A"
},
{
"a": 115708,
"t": 199700,
"n": "europe_king_030C14",
"h": "A"
},
{
"a": 115736,
"t": 212118,
"n": "europe_king_033C96",
"h": "A"
},
{
"a": 115750,
"t": 208300,
"n": "europe_king_032DAC",
"h": "A"
},
{
"a": 115778,
"t": 205236,
"n": "europe_king_0321B4",
"h": "A"
},
{
"a": 115792,
"t": 218078,
"n": "europe_king_0353DE",
"h": "A"
},
{
"a": 115820,
"t": 202962,
"n": "europe_king_0318D2",
"h": "A"
},
{
"a": 115848,
"t": 210426,
"n": "europe_king_0335FA",
"h": "A"
},
{
"a": 115862,
"t": 205308,
"n": "europe_king_0321FC",
"h": "A"
},
{
"a": 115904,
"t": 62346,
"n": "engine_band_00F38A",
"h": "B"
},
{
"a": 115928,
"t": 226250,
"n": "reports_0373CA",
"h": "A"
},
{
"a": 115942,
"t": 231288,
"n": "reports_038778",
"h": "A"
},
{
"a": 115956,
"t": 233172,
"n": "reports_038ED4",
"h": "A"
},
{
"a": 115970,
"t": 234484,
"n": "reports_0393F4",
"h": "A"
},
{
"a": 115984,
"t": 233260,
"n": "reports_038F2C",
"h": "A"
},
{
"a": 115998,
"t": 231568,
"n": "reports_038890",
"h": "A"
},
{
"a": 116012,
"t": 229502,
"n": "reports_03807E",
"h": "A"
},
{
"a": 116026,
"t": 226112,
"n": "reports_037340",
"h": "A"
},
{
"a": 116040,
"t": 233920,
"n": "reports_0391C0",
"h": "A"
},
{
"a": 116054,
"t": 246402,
"n": "revolution_03C282",
"h": "A"
},
{
"a": 116068,
"t": 244554,
"n": "revolution_03BB4A",
"h": "A"
},
{
"a": 116082,
"t": 274208,
"n": "map_input_2_042F20",
"h": "A"
},
{
"a": 116136,
"t": 456928,
"n": "text_widget_06F8E0",
"h": "A"
},
{
"a": 116160,
"t": 484644,
"n": "engine_io_076524",
"h": "A"
},
{
"a": 116174,
"t": 484560,
"n": "engine_io_0764D0",
"h": "A"
},
{
"a": 116188,
"t": 244802,
"n": "ff_acquire_dispatch",
"h": "A"
},
{
"a": 116208,
"t": 245714,
"n": "revolution_03BFD2",
"h": "A"
},
{
"a": 116222,
"t": 244262,
"n": "revolution_03BA26",
"h": "A"
},
{
"a": 116236,
"t": 244314,
"n": "revolution_03BA5A",
"h": "A"
},
{
"a": 116250,
"t": 244390,
"n": "revolution_03BAA6",
"h": "A"
},
{
"a": 116264,
"t": 243968,
"n": "revolution_03B900",
"h": "A"
},
{
"a": 116278,
"t": 244058,
"n": "revolution_03B95A",
"h": "A"
},
{
"a": 116292,
"t": 244096,
"n": "revolution_03B980",
"h": "A"
},
{
"a": 116306,
"t": 437768,
"n": "dialog_pedia_06AE08",
"h": "A"
},
{
"a": 116460,
"t": 246402,
"n": "revolution_03C282",
"h": "A"
},
{
"a": 116530,
"t": 257264,
"n": "unit_vs_tile_combat_terrain_eval",
"h": "A"
},
{
"a": 116544,
"t": 260366,
"n": "naval_03F90E",
"h": "A"
},
{
"a": 116572,
"t": 307976,
"n": "village_trade_04B308",
"h": "A"
},
{
"a": 116598,
"t": 379000,
"n": "treasure_value_and_king_transport",
"h": "A"
},
{
"a": 116610,
"t": 367504,
"n": "natives_059B90",
"h": "A"
},
{
"a": 116680,
"t": 263546,
"n": "pioneer_routes_04057A",
"h": "A"
},
{
"a": 116694,
"t": 263688,
"n": "pioneer_routes_040608",
"h": "A"
},
{
"a": 116708,
"t": 263344,
"n": "pioneer_routes_0404B0",
"h": "A"
},
{
"a": 116722,
"t": 266292,
"n": "pioneer_routes_041034",
"h": "A"
},
{
"a": 116736,
"t": 404868,
"n": "pathfind_062D84",
"h": "A"
},
{
"a": 116748,
"t": 394202,
"n": "trade_editor_0603DA",
"h": "A"
},
{
"a": 116762,
"t": 394114,
"n": "trade_editor_060382",
"h": "A"
},
{
"a": 116846,
"t": 403222,
"n": "pathfind_062716",
"h": "A"
},
{
"a": 116858,
"t": 273914,
"n": "map_input_2_042DFA",
"h": "A"
},
{
"a": 116870,
"t": 273488,
"n": "map_input_2_042C50",
"h": "A"
},
{
"a": 116882,
"t": 274390,
"n": "map_input_2_042FD6",
"h": "A"
},
{
"a": 116906,
"t": 273644,
"n": "map_input_2_042CEC",
"h": "A"
},
{
"a": 116918,
"t": 273734,
"n": "map_input_2_042D46",
"h": "A"
},
{
"a": 116930,
"t": 280630,
"n": "menu_bar_044836",
"h": "A"
},
{
"a": 116942,
"t": 279894,
"n": "menu_obj_044556",
"h": "A"
},
{
"a": 116954,
"t": 282532,
"n": "menu_obj_044FA4",
"h": "A"
},
{
"a": 116966,
"t": 280958,
"n": "_menu_bar_item",
"h": "A"
},
{
"a": 116978,
"t": 281028,
"n": "_menu_item",
"h": "A"
},
{
"a": 116990,
"t": 280046,
"n": "menu_bar_0445EE",
"h": "A"
},
{
"a": 117002,
"t": 281466,
"n": "menu_obj_044B7A",
"h": "A"
},
{
"a": 117014,
"t": 282810,
"n": "menu_obj_0450BA",
"h": "A"
},
{
"a": 117026,
"t": 280132,
"n": "menu_bar_044644",
"h": "A"
},
{
"a": 117038,
"t": 281878,
"n": "menu_obj_044D16",
"h": "A"
},
{
"a": 117050,
"t": 280446,
"n": "menu_bar_04477E",
"h": "A"
},
{
"a": 117076,
"t": 493120,
"n": "engine_overlay_078640",
"h": "A"
},
{
"a": 117104,
"t": 53932,
"n": "engine_band_00D2AC",
"h": "B"
},
{
"a": 117114,
"t": 493310,
"n": "engine_overlay_0786FE",
"h": "A"
},
{
"a": 117128,
"t": 285952,
"n": "native_raid_045D00",
"h": "A"
},
{
"a": 117140,
"t": 298148,
"n": "village_trade_048CA4",
"h": "A"
},
{
"a": 117152,
"t": 296438,
"n": "village_trade_0485F6",
"h": "A"
},
{
"a": 117164,
"t": 295646,
"n": "village_trade_0482DE",
"h": "A"
},
{
"a": 117176,
"t": 307038,
"n": "village_trade_04AF5E",
"h": "A"
},
{
"a": 117188,
"t": 290810,
"n": "village_trade_046FFA",
"h": "A"
},
{
"a": 117200,
"t": 295694,
"n": "village_trade_04830E",
"h": "A"
},
{
"a": 117212,
"t": 297530,
"n": "village_trade_048A3A",
"h": "A"
},
{
"a": 117224,
"t": 303996,
"n": "village_trade_04A37C",
"h": "A"
},
{
"a": 117236,
"t": 306176,
"n": "village_trade_04AC00",
"h": "A"
},
{
"a": 117248,
"t": 290272,
"n": "village_trade_046DE0",
"h": "A"
},
{
"a": 117260,
"t": 305098,
"n": "native_raze_treasure_chiefkill",
"h": "A"
},
{
"a": 117272,
"t": 304166,
"n": "village_trade_04A426",
"h": "A"
},
{
"a": 117284,
"t": 298804,
"n": "village_trade_048F34",
"h": "A"
},
{
"a": 117296,
"t": 290328,
"n": "village_trade_046E18",
"h": "A"
},
{
"a": 117308,
"t": 300544,
"n": "village_trade_049600",
"h": "A"
},
{
"a": 117320,
"t": 372592,
"n": "combat_aftermath_05AF70",
"h": "A"
},
{
"a": 117332,
"t": 313414,
"n": "foreign_loot_04C846",
"h": "A"
},
{
"a": 117344,
"t": 312154,
"n": "foreign_loot_04C35A",
"h": "A"
},
{
"a": 117356,
"t": 314102,
"n": "foreign_loot_04CAF6",
"h": "A"
},
{
"a": 117368,
"t": 335190,
"n": "foreign_loot_051D56",
"h": "A"
},
{
"a": 117380,
"t": 312768,
"n": "foreign_loot_04C5C0",
"h": "A"
},
{
"a": 117392,
"t": 311792,
"n": "foreign_loot_04C1F0",
"h": "A"
},
{
"a": 117404,
"t": 313502,
"n": "foreign_loot_04C89E",
"h": "A"
},
{
"a": 117416,
"t": 311820,
"n": "foreign_loot_04C20C",
"h": "A"
},
{
"a": 117428,
"t": 312324,
"n": "foreign_loot_04C404",
"h": "A"
},
{
"a": 117440,
"t": 312962,
"n": "foreign_loot_04C682",
"h": "A"
},
{
"a": 117464,
"t": 311906,
"n": "foreign_loot_04C262",
"h": "A"
},
{
"a": 117476,
"t": 320214,
"n": "foreign_loot_04E2D6",
"h": "A"
},
{
"a": 117488,
"t": 335404,
"n": "foreign_loot_051E2C",
"h": "A"
},
{
"a": 117500,
"t": 314448,
"n": "foreign_loot_04CC50",
"h": "A"
},
{
"a": 117512,
"t": 311960,
"n": "foreign_loot_04C298",
"h": "A"
},
{
"a": 117524,
"t": 312494,
"n": "foreign_loot_04C4AE",
"h": "A"
},
{
"a": 117536,
"t": 335590,
"n": "foreign_loot_051EE6",
"h": "A"
},
{
"a": 117548,
"t": 313116,
"n": "foreign_loot_04C71C",
"h": "A"
},
{
"a": 117560,
"t": 312014,
"n": "foreign_loot_04C2CE",
"h": "A"
},
{
"a": 117572,
"t": 335604,
"n": "foreign_loot_051EF4",
"h": "A"
},
{
"a": 117584,
"t": 312588,
"n": "foreign_loot_04C50C",
"h": "A"
},
{
"a": 117596,
"t": 313990,
"n": "foreign_loot_04CA86",
"h": "A"
},
{
"a": 117608,
"t": 312626,
"n": "foreign_loot_04C532",
"h": "A"
},
{
"a": 117620,
"t": 312070,
"n": "foreign_loot_04C306",
"h": "A"
},
{
"a": 117632,
"t": 313328,
"n": "foreign_loot_04C7F0",
"h": "A"
},
{
"a": 117644,
"t": 401046,
"n": "pathfind_061E96",
"h": "A"
},
{
"a": 117656,
"t": 342910,
"n": "colony_enter_053B7E",
"h": "A"
},
{
"a": 117668,
"t": 342580,
"n": "colony_enter_053A34",
"h": "A"
},
{
"a": 117680,
"t": 342688,
"n": "colony_enter_053AA0",
"h": "A"
},
{
"a": 117692,
"t": 342804,
"n": "colony_enter_053B14",
"h": "A"
},
{
"a": 117704,
"t": 342048,
"n": "colony_enter_053820",
"h": "A"
},
{
"a": 117716,
"t": 342822,
"n": "colony_enter_053B26",
"h": "A"
},
{
"a": 117728,
"t": 401154,
"n": "pathfind_061F02",
"h": "A"
},
{
"a": 117740,
"t": 360270,
"n": "diplomacy_meeting_dispatch",
"h": "A"
},
{
"a": 117754,
"t": 359648,
"n": "natives_057CE0",
"h": "A"
},
{
"a": 117768,
"t": 358970,
"n": "natives_057A3A",
"h": "A"
},
{
"a": 117782,
"t": 367422,
"n": "natives_059B3E",
"h": "A"
},
{
"a": 117796,
"t": 354832,
"n": "natives_056A10",
"h": "A"
},
{
"a": 117810,
"t": 359074,
"n": "natives_057AA2",
"h": "A"
},
{
"a": 117824,
"t": 355218,
"n": "natives_056B92",
"h": "A"
},
{
"a": 117838,
"t": 359872,
"n": "diplomacy_sign_treaty",
"h": "A"
},
{
"a": 117852,
"t": 355390,
"n": "natives_056C3E",
"h": "A"
},
{
"a": 117866,
"t": 359164,
"n": "natives_057AFC",
"h": "A"
},
{
"a": 117880,
"t": 456220,
"n": "popup_engine_06F61C",
"h": "A"
},
{
"a": 117920,
"t": 372956,
"n": "combat_aftermath_05B0DC",
"h": "A"
},
{
"a": 117932,
"t": 378458,
"n": "combat_aftermath_05C65A",
"h": "A"
},
{
"a": 117944,
"t": 376452,
"n": "native_raid_outcome_dispatch",
"h": "A"
},
{
"a": 117956,
"t": 378524,
"n": "combat_aftermath_05C69C",
"h": "A"
},
{
"a": 117968,
"t": 373442,
"n": "combat_aftermath_05B2C2",
"h": "A"
},
{
"a": 117992,
"t": 376368,
"n": "combat_aftermath_05BE30",
"h": "A"
},
{
"a": 118004,
"t": 387504,
"n": "combat_ui_05E9B0",
"h": "A"
},
{
"a": 118016,
"t": 450760,
"n": "popup_obj_06E0C8",
"h": "A"
},
{
"a": 118028,
"t": 396512,
"n": "trade_editor_060CE0",
"h": "A"
},
{
"a": 118042,
"t": 394250,
"n": "trade_editor_06040A",
"h": "A"
},
{
"a": 118056,
"t": 394316,
"n": "trade_editor_06044C",
"h": "A"
},
{
"a": 118070,
"t": 396684,
"n": "trade_editor_060D8C",
"h": "A"
},
{
"a": 118084,
"t": 392864,
"n": "trade_editor_05FEA0",
"h": "A"
},
{
"a": 118098,
"t": 392948,
"n": "trade_editor_05FEF4",
"h": "A"
},
{
"a": 118112,
"t": 395322,
"n": "trade_editor_06083A",
"h": "A"
},
{
"a": 118126,
"t": 396996,
"n": "trade_editor_060EC4",
"h": "A"
},
{
"a": 118140,
"t": 394064,
"n": "trade_editor_060350",
"h": "A"
},
{
"a": 118154,
"t": 397106,
"n": "trade_editor_060F32",
"h": "A"
},
{
"a": 118168,
"t": 396340,
"n": "trade_editor_060C34",
"h": "A"
},
{
"a": 118182,
"t": 394152,
"n": "trade_editor_0603A8",
"h": "A"
},
{
"a": 118196,
"t": 454356,
"n": "popup_obj_06EED4",
"h": "A"
},
{
"a": 118208,
"t": 403806,
"n": "pathfind_06295E",
"h": "A"
},
{
"a": 118220,
"t": 407680,
"n": "map_6_obj_063880",
"h": "A"
},
{
"a": 118360,
"t": 57270,
"n": "engine_band_00DFB6",
"h": "B"
},
{
"a": 118370,
"t": 57242,
"n": "engine_band_00DF9A",
"h": "B"
},
{
"a": 118406,
"t": 420200,
"n": "map_render_066968",
"h": "A"
},
{
"a": 118420,
"t": 421078,
"n": "map_render_066CD6",
"h": "A"
},
{
"a": 118434,
"t": 419920,
"n": "map_render_066850",
"h": "A"
},
{
"a": 118448,
"t": 419972,
"n": "map_render_066884",
"h": "A"
},
{
"a": 118462,
"t": 420758,
"n": "me_mini_obj_066B96",
"h": "A"
},
{
"a": 118644,
"t": 61092,
"n": "engine_band_00EEA4",
"h": "B"
},
{
"a": 118654,
"t": 60566,
"n": "engine_band_00EC96",
"h": "B"
},
{
"a": 118664,
"t": 430716,
"n": "dialog_pedia_06927C",
"h": "A"
},
{
"a": 118678,
"t": 429984,
"n": "dialog_pedia_068FA0",
"h": "A"
},
{
"a": 118692,
"t": 438044,
"n": "dialog_pedia_06AF1C",
"h": "A"
},
{
"a": 118706,
"t": 430748,
"n": "dialog_pedia_06929C",
"h": "A"
},
{
"a": 118734,
"t": 430168,
"n": "dialog_pedia_069058",
"h": "A"
},
{
"a": 118748,
"t": 438314,
"n": "dialog_pedia_06B02A",
"h": "A"
},
{
"a": 118762,
"t": 430956,
"n": "dialog_pedia_06936C",
"h": "A"
},
{
"a": 118776,
"t": 438786,
"n": "dialog_pedia_06B202",
"h": "A"
},
{
"a": 118790,
"t": 430422,
"n": "dialog_pedia_069156",
"h": "A"
},
{
"a": 118804,
"t": 430500,
"n": "dialog_pedia_0691A4",
"h": "A"
},
{
"a": 118818,
"t": 429792,
"n": "dialog_pedia_068EE0",
"h": "A"
},
{
"a": 118832,
"t": 429880,
"n": "dialog_pedia_068F38",
"h": "A"
},
{
"a": 118846,
"t": 430618,
"n": "dialog_pedia_06921A",
"h": "A"
},
{
"a": 118902,
"t": 484560,
"n": "engine_io_0764D0",
"h": "A"
},
{
"a": 118916,
"t": 55086,
"n": "engine_band_00D72E",
"h": "B"
},
{
"a": 118926,
"t": 444138,
"n": "popup_engine_06C6EA",
"h": "A"
},
{
"a": 118938,
"t": 451502,
"n": "popup_obj_06E3AE",
"h": "A"
},
{
"a": 118950,
"t": 448824,
"n": "popup_obj_06D938",
"h": "A"
},
{
"a": 118962,
"t": 444378,
"n": "_popup_read_check",
"h": "A"
},
{
"a": 118974,
"t": 445332,
"n": "popup_obj_06CB94",
"h": "A"
},
{
"a": 118986,
"t": 444426,
"n": "_popup_write_check",
"h": "A"
},
{
"a": 118998,
"t": 443030,
"n": "popup_obj_06C296",
"h": "A"
},
{
"a": 119010,
"t": 451294,
"n": "_popup_draw",
"h": "A"
},
{
"a": 119022,
"t": 444984,
"n": "_popup_add_check",
"h": "A"
},
{
"a": 119034,
"t": 448712,
"n": "popup_obj_06D8C8",
"h": "A"
},
{
"a": 119070,
"t": 457402,
"n": "_text_item_binary",
"h": "A"
},
{
"a": 119082,
"t": 58476,
"n": "engine_band_00E46C",
"h": "B"
},
{
"a": 119092,
"t": 55666,
"n": "engine_band_00D972",
"h": "B"
},
{
"a": 119102,
"t": 54206,
"n": "engine_band_00D3BE",
"h": "B"
},
{
"a": 119112,
"t": 461102,
"n": "multiplayer_07092E",
"h": "A"
},
{
"a": 119126,
"t": 460160,
"n": "multiplayer_070580",
"h": "A"
},
{
"a": 119140,
"t": 461338,
"n": "multiplayer_070A1A",
"h": "A"
},
{
"a": 119154,
"t": 458224,
"n": "multiplayer_06FDF0",
"h": "A"
},
{
"a": 119168,
"t": 459456,
"n": "multiplayer_0702C0",
"h": "A"
},
{
"a": 119182,
"t": 458268,
"n": "multiplayer_06FE1C",
"h": "A"
},
{
"a": 119196,
"t": 459522,
"n": "multiplayer_070302",
"h": "A"
},
{
"a": 119210,
"t": 458644,
"n": "multiplayer_06FF94",
"h": "A"
},
{
"a": 119224,
"t": 460674,
"n": "multiplayer_070782",
"h": "A"
},
{
"a": 119238,
"t": 460726,
"n": "multiplayer_0707B6",
"h": "A"
},
{
"a": 119252,
"t": 458848,
"n": "multiplayer_070060",
"h": "A"
},
{
"a": 119266,
"t": 459924,
"n": "multiplayer_070494",
"h": "A"
},
{
"a": 119360,
"t": 76284,
"n": "engine_band_0129FC",
"h": "B"
},
{
"a": 119370,
"t": 55390,
"n": "engine_band_00D85E",
"h": "B"
},
{
"a": 119450,
"t": 55164,
"n": "engine_band_00D77C",
"h": "B"
},
{
"a": 119460,
"t": 54302,
"n": "fileio_8_c_00D41E",
"h": "B"
},
{
"a": 119484,
"t": 469914,
"n": "boot_save_072B9A",
"h": "A"
},
{
"a": 119722,
"t": 467088,
"n": "boot_save_072090",
"h": "A"
},
{
"a": 119764,
"t": 55040,
"n": "engine_band_00D700",
"h": "B"
},
{
"a": 119774,
"t": 54980,
"n": "engine_band_00D6C4",
"h": "B"
},
{
"a": 119784,
"t": 57670,
"n": "engine_band_00E146",
"h": "B"
},
{
"a": 119808,
"t": 484594,
"n": "engine_io_0764F2",
"h": "A"
},
{
"a": 119856,
"t": 491322,
"n": "engine_video_077F3A",
"h": "A"
},
{
"a": 119912,
"t": 58452,
"n": "normalize_far_pointer",
"h": "B"
},
{
"a": 119922,
"t": 486992,
"n": "engine_loader_076E50",
"h": "A"
},
{
"a": 119950,
"t": 486992,
"n": "engine_loader_076E50",
"h": "A"
},
{
"a": 119964,
"t": 487532,
"n": "loader_1_c_07706C",
"h": "A"
},
{
"a": 120034,
"t": 76738,
"n": "PACK_4_C_012BC2",
"h": "B"
},
{
"a": 120044,
"t": 76506,
"n": "PACK_2_C_012ADA",
"h": "B"
},
{
"a": 120054,
"t": 76616,
"n": "PACK_3_C_012B48",
"h": "B"
},
{
"a": 120064,
"t": 76390,
"n": "PACK_1_C_012A66",
"h": "B"
},
{
"a": 120074,
"t": 490036,
"n": "engine_error_077A34",
"h": "A"
},
{
"a": 120086,
"t": 76940,
"n": "engine_band_012C8C",
"h": "B"
},
{
"a": 120096,
"t": 491216,
"n": "mcga_c_c_077ED0",
"h": "A"
},
{
"a": 120144,
"t": 76072,
"n": "_SOUND_DRIVER_INIT",
"h": "B"
},
{
"a": 120154,
"t": 75898,
"n": "_SOUND_DRIVER_LOAD",
"h": "B"
},
{
"a": 120164,
"t": 76121,
"n": "engine_band_012959",
"h": "B"
},
{
"a": 120188,
"t": 58032,
"n": "engine_band_00E2B0",
"h": "B"
},
{
"a": 120198,
"t": 57810,
"n": "buffer_r_c_00E1D2",
"h": "B"
},
{
"a": 120236,
"t": 78862,
"n": "_xms_umb_get_avail",
"h": "B"
},
{
"a": 120260,
"t": 78972,
"n": "_xms_umb_free",
"h": "B"
},
{
"a": 120270,
"t": 78906,
"n": "_xms_umb_get",
"h": "B"
}
]
}""")

HEADER = 0x2400
DGROUP_FILE = 0x1D9A0
LOAD_IMAGE_END = 0x22A65        # end of the MZ load image; DGROUP is BSS above
DELTA = -HEADER if MZ_LOAD else 0


def A(file_off):
    return toAddr(file_off + DELTA)


BUILD = "4b45055cb93a"

# Set False to stop the script defining/applying the record types (phase 4).
# Naming and DGROUP setup still run.
APPLY_TYPES = True

# Set False to skip the RTLink thunk pass (phase 5).  It walks every
# instruction in the program looking for far calls, which takes a moment on a
# 495 KB image.
ANNOTATE_THUNKS = True

# Set False to leave function signatures alone (phase 6).  Argument COUNTS are
# byte-verified; argument types are not, so every parameter is laid down as a
# plain 2-byte word.
APPLY_SIGNATURES = True

# Fixed-width Ghidra builtins.  Deliberately NOT IntegerDataType/LongDataType,
# whose sizes come from the language's data organisation — the whole point is
# that these widths are byte-verified and must not float.
_TYPES = {
    "u8":   ("ByteDataType", 1),
    "s8":   ("SignedByteDataType", 1),
    "char": ("CharDataType", 1),
    "u16":  ("WordDataType", 2),
    "s16":  ("SignedWordDataType", 2),
    "u32":  ("DWordDataType", 4),
    "s32":  ("SignedDWordDataType", 4),
}


def _dt(kind):
    """Instantiate a fixed-width builtin by name, plus its byte width."""
    import ghidra.program.model.data as D
    cls, width = _TYPES[kind]
    return getattr(D, cls)(), width


def apply_signatures():
    """Give each function the argument count its callers prove it takes.

    The count is byte evidence (cdecl `add sp, N` after the call, agreed by
    every observed site); the argument TYPES are not — each is laid down as a
    plain 2-byte word, which is what the stack slot actually is.  Naming them
    param_1..param_n rather than guessing meanings keeps the honest part and
    discards nothing: the decompiler stops inventing its own arity, which is
    the thing that made call sites unreadable.
    """
    from ghidra.program.model.data import WordDataType
    from ghidra.program.model.listing import ParameterImpl, Function
    from ghidra.program.model.symbol import SourceType as _S

    fm = currentProgram.getFunctionManager()
    applied = missing = 0
    for f in DATA["funcs"]:
        n = f.get("na")
        if not n:
            continue
        try:
            fn = fm.getFunctionAt(A(f["a"]))
            if fn is None:
                missing += 1
                continue
            params = [ParameterImpl("param_%d" % (i + 1), WordDataType(),
                                    currentProgram)
                      for i in range(n)]
            fn.replaceParameters(
                params, Function.FunctionUpdateType.DYNAMIC_STORAGE_FORMAL_PARAMS,
                True, _S.USER_DEFINED)
            applied += 1
        except Exception:
            missing += 1
    print("signatures applied   : %d  (arg counts from caller stack cleanup)"
          % applied)
    if missing:
        print("signatures skipped   : %d  (no function at that address)"
              % missing)


def annotate_thunk_calls():
    """Name the thunk stubs and label every call site with its real target.

    A cross-page call is `9A off16 seg16` (far CALL) into the thunk table.
    Ghidra resolves that seg:off with its own segment arithmetic, which is
    0x2400 out from the file offsets this database uses, so it lands nowhere
    useful and the callee shows as an anonymous FUN_.  Rather than fight the
    address model, decode the operand straight from the instruction bytes and
    state the answer in an EOL comment.

    Reading the bytes (not the operand objects) keeps this independent of how
    the loaded language chooses to render a far call.
    """
    by_stub = {}
    for e in DATA["thunks"]:
        by_stub[e["a"]] = e
    if not by_stub:
        return 0

    labelled = 0
    for e in DATA["thunks"]:
        try:
            createLabel(A(e["a"]), "thunk_" + e["n"], False)
            labelled += 1
        except Exception:
            pass

    sites = 0
    for ins in currentProgram.getListing().getInstructions(True):
        try:
            b = ins.getBytes()
            if len(b) < 5 or (b[0] & 0xFF) != 0x9A:
                continue
            off = (b[1] & 0xFF) | ((b[2] & 0xFF) << 8)
            seg = (b[3] & 0xFF) | ((b[4] & 0xFF) << 8)
        except Exception:
            continue
        e = by_stub.get(HEADER + seg * 16 + off)
        if e is None:
            continue
        try:
            setEOLComment(ins.getAddress(),
                          "-> %s   (file 0x%05X, via type-%s thunk)"
                          % (e["n"], e["t"], e["h"]))
            sites += 1
        except Exception:
            pass

    print("thunk stubs labelled : %d" % labelled)
    print("call sites annotated : %d  (EOL comment names the real callee)"
          % sites)
    return sites


def build_structs():
    """Define the five record layouts directly in the Data Type Manager.

    Replaces `File > Parse C Source` on viceroy_types.h.  Each struct is
    created at its byte-verified stride and fields are dropped in at their
    offsets, so unmapped spans stay `undefined1` — honest gaps, never
    invented names, and no alignment rule can shift anything.
    """
    from ghidra.program.model.data import (StructureDataType, ArrayDataType,
                                           CategoryPath)
    dtm = currentProgram.getDataTypeManager()
    path = CategoryPath("/viceroy")
    out = {}
    for t in DATA["tables"]:
        try:
            s = StructureDataType(path, t["name"], t["stride"])
            for f in t["fields"]:
                dt, w = _dt(f["t"])
                if f["c"]:
                    dt = ArrayDataType(dt, f["c"], w)
                s.replaceAtOffset(f["o"], dt, dt.getLength(), f["nm"], None)
            out[t["name"]] = dtm.addDataType(s, None)
        except Exception as e:
            print("!! could not define %s (%s)" % (t["name"], e))
    if out:
        print("record types defined: %s" % ", ".join(sorted(out)))
        print("   (Data Type Manager > <program> > viceroy - no C parse needed)")
    return out


def apply_tables(structs, dg):
    """Lay each record table down as an array at its DGROUP base."""
    from ghidra.program.model.data import ArrayDataType
    done = 0
    for t in DATA["tables"]:
        dt = structs.get(t["name"])
        if dt is None:
            continue
        try:
            addr = dg.add(t["ds"])
            span = t["n"] * t["stride"]
            clearListing(addr, addr.add(span - 1))
            createData(addr, ArrayDataType(dt, t["n"], dt.getLength()))
            print("   %-18s %s  [%d x 0x%X]"
                  % (t["name"] + "[]", addr, t["n"], t["stride"]))
            done += 1
        except Exception as e:
            print("!! could not apply %s at DS:0x%04X (%s)"
                  % (t["name"], t["ds"], e))
    print("record tables applied: %d/%d" % (done, len(DATA["tables"])))


def retype_pointers(structs, dg):
    """Type the current-record globals as 2-byte NEAR pointers.

    Size is forced to 2 rather than left to the language's default: these
    hold near offsets into DGROUP, and a 4-byte far pointer would swallow two
    bytes of whatever follows and mislabel it.
    """
    from ghidra.program.model.data import PointerDataType
    PTRS = [("g_current_colony_ptr", 0x8542, "ColonyRecord"),
            ("g_current_power_ptr", 0x84FC, "PowerRecord"),
            ("g_active_settlement_ptr", 0x8D4A, "NativeSettlement")]
    done = 0
    for nm, ds, tyname in PTRS:
        dt = structs.get(tyname)
        if dt is None:
            continue
        try:
            addr = dg.add(ds)
            clearListing(addr, addr.add(1))
            createData(addr, PointerDataType(dt, 2))
            print("   %-24s %s  as %s * (near, 2 bytes)" % (nm, addr, tyname))
            done += 1
        except Exception as e:
            print("!! could not retype %s at DS:0x%04X (%s)" % (nm, ds, e))
    print("record pointers typed: %d/%d" % (done, len(PTRS)))


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
        if f.get("na"):
            lines.append("args   : %d word(s), agreed by %d call site(s) "
                         "(cdecl caller cleanup)" % (f["na"], f["nas"]))
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

    # DGROUP MUST BE WRITABLE.  createInitializedBlock defaults to read-only,
    # and a read-only block is a promise to the decompiler that the bytes
    # never change - so it constant-folds every read.  BSS is zero-filled,
    # which means `if (g_some_flag)` folds to false and the ENTIRE guarded
    # body is deleted from the decompilation.  Symptom: a 274-byte function
    # decompiles to three lines plus "Read-only address is written" warnings.
    if dg is not None:
        try:
            blk = mem.getBlock(dg)
            blk.setRead(True)
            blk.setWrite(True)
            blk.setExecute(False)
            print("DGROUP permissions set to rw-")
        except Exception as e:
            print("!! could not make DGROUP writable (%s)" % e)
            print("!! the decompiler will constant-fold reads from it and")
            print("!! delete guarded code.  Fix by hand: Window > Memory Map,")
            print("!! tick the W column on the DGROUP row.")

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

    # ---- record types: define, apply, retype ------------------------------
    # Everything that used to be manual after the script ran:
    #   File > Parse C Source   -> build_structs()   (no C parser involved)
    #   G + T at each table base -> apply_tables()
    #   Ctrl-L on each pointer   -> retype_pointers()
    # Building the structs in code rather than parsing viceroy_types.h also
    # sidesteps the C parser's data organisation: widths are stated outright
    # instead of depending on what `long` means for the loaded language.
    structs = {}
    if APPLY_TYPES and dg is not None:
        structs = build_structs()
        if structs:
            apply_tables(structs, dg)
            retype_pointers(structs, dg)

    # ---- RTLink thunks ----------------------------------------------------
    if ANNOTATE_THUNKS:
        try:
            annotate_thunk_calls()
        except Exception as e:
            print("!! thunk annotation failed (%s) - everything else stands" % e)

    # ---- function signatures ----------------------------------------------
    if APPLY_SIGNATURES:
        try:
            apply_signatures()
        except Exception as e:
            print("!! signature pass failed (%s) - everything else stands" % e)

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
    # ---- where to look, in THIS program's own address format --------------
    # A 16-bit real-mode program shows segmented addresses (segment:offset),
    # so never compute these by hand — copy the right-hand column.
    print("")
    print("=" * 64)
    print("WHERE THINGS ARE")
    print("=" * 64)
    if dg is None:
        print("  DGROUP was not created - see the errors above")
    else:
        for t in DATA["tables"]:
            try:
                print("  %-18s DS:0x%04X  ->  %s     [%s, stride 0x%X]"
                      % (t["name"] + "[]", t["ds"], dg.add(t["ds"]),
                         t["count"], t["stride"]))
            except Exception as e:
                print("  %-18s DS:0x%04X  -> ERROR %s" % (t["name"], t["ds"], e))
        for nm, ds in (("g_current_colony_ptr", 0x8542),
                       ("g_current_power_ptr", 0x84FC),
                       ("g_active_settlement_ptr", 0x8D4A)):
            try:
                print("  %-24s DS:0x%04X  ->  %s" % (nm, ds, dg.add(ds)))
            except Exception:
                pass
    print("")
    if APPLY_TYPES:
        print("Nothing further to do by hand.  Check it took: G -> 53b14,")
        print("the decompiler should read g_current_colony_ptr->colony_flags.")
        print("(If the old text persists: right-click > Decompiler > Refresh.)")
    else:
        print("APPLY_TYPES is False - the record types were not defined or")
        print("applied.  Set it True at the top of this script, or do it by")
        print("hand per tools/ghidra/README.md section 3.2.")


main()
