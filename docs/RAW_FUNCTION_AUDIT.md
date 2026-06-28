# Raw-function audit — clearing the last unclassified functions

The coverage map (`tools/build_coverage_map.py`) had a residual set of
functions that were disassembled but neither named nor reconstructed in C.
This audit identifies every one of them from its own bytes. Tiers: **B** =
diagnostic byte evidence (INT/port-I/O/string/anchor); **R** = role inferred
from structure/callees (not a full port); **GLUE** = C-runtime/library helper;
**DATA** = not code (a data block the auto-segmenter mis-split as a function).

Key finding: 6 of these are **not code at all** — data/zero-fill regions that
the boundary detector wrongly emitted as functions. They are reclassified
`DATA`, not 'decoded'.

| Offset | Size | Identification | Tier | Evidence (from the bytes) |
|--------|-----:|----------------|------|---------------------------|
| `0x002400` | 33 | `rt_strtab_open` | GLUE | C-runtime: opens the "$STRING" resource (lib 0x181F:0x48, ax=9); zeroes record counter [0x2D52]. |
| `0x00242C` | 53 | `rt_strtab_append` | GLUE | C-runtime: appends a record; bumps counter [0x2D52] (lib 0xD1D:0x113C/0x117E). |
| `0x002462` | 45 | `rt_far_strlen` | GLUE | C-runtime: REPNE SCASB length scan over the far buffer at [0x2D42:0x2D44]. |
| `0x002494` | 50 | `rt_code_select_2out` | GLUE | C-runtime: maps an index arg to constant outputs (0x44/0x95/0xC + 0x22). |
| `0x002632` | 21 | `rt_emit_long` | GLUE | C-runtime: converts via far 0:0x62, forwards to output sink CALL 0x260E. |
| `0x002648` | 32 | `rt_fmt_emit_1arg` | GLUE | C-runtime: formats 1 arg into a 20-byte stack buffer (0xD1D:0x8FA) then emits (0x260E). |
| `0x002668` | 35 | `rt_fmt_emit_2arg` | GLUE | C-runtime: formats 2 args (0xD1D:0x916) then emits (0x260E). |
| `0x00268C` | 38 | `rt_fmt_emit_str` | GLUE | C-runtime: formats a string (0x4B:0x1E8) then emits (0x260E). |
| `0x0028C0` | 33 | `rt_emit_repeat_n` | GLUE | C-runtime: calls leaf 0x28B0 N=[bp+8] times (repeat/emit-n). |
| `0x0028E2` | 16 | `rt_libwrap_7a4_s52` | GLUE | C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x52. |
| `0x0028F2` | 16 | `rt_libwrap_7a4_s55` | GLUE | C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x55. |
| `0x002902` | 16 | `rt_libwrap_7a4_s58` | GLUE | C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x58. |
| `0x002912` | 16 | `rt_libwrap_7a4_s5c` | GLUE | C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x5C. |
| `0x002922` | 16 | `rt_libwrap_7a4_s5e` | GLUE | C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x5E. |
| `0x002932` | 16 | `rt_libwrap_7a4_s60` | GLUE | C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x60. |
| `0x002962` | 16 | `rt_libwrap_7a4_s66` | GLUE | C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x66. |
| `0x002972` | 16 | `rt_libwrap_7a4_s68` | GLUE | C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x68. |
| `0x002982` | 16 | `rt_libwrap_7a4_s6a` | GLUE | C-runtime: thin wrapper -> lib 0xD1D:0x7A4 with selector 0x6A. |
| `0x0092E0` | 44 | `colony_flag_bit_set` | B | Colony: sets/tests a bit in the bit-array at ColonyRecord+0x84 (idx>>3 byte, idx&7 bit); base [0x8542]. |
| `0x009318` | 782 | `colony_production_accumulate` | R | Colony (782B): reads active colony [0x8542] + unit table [0x3159], accumulates into the stockpile array (+0x9A) and reads size (+0x1F). Role identified; full byte-port pending. |
| `0x009626` | 53 | `colony_leaf_calls_90c8` | R | Colony helper: active colony [0x8542]; calls leaf 0x90C8. |
| `0x00965C` | 53 | `colony_leaf_calls_9102` | R | Colony helper: active colony [0x8542]; calls leaf 0x9102. |
| `0x009692` | 67 | `colony_leaf_90c8_9102` | R | Colony helper: active colony [0x8542]; calls leaves 0x90C8 and 0x9102. |
| `0x0096DA` | 75 | `colony_leaf_activecol` | R | Colony helper: reads/writes via active colony [0x8542]. |
| `0x00B150` | 155 | `colony_update_step` | R | Colony: higher-level step -- active colony [0x8542]; calls 0x90C8, production 0x9318, 0xAB78. |
| `0x00B368` | 126 | `colony_helper_b2a2` | R | Colony helper cluster: calls 0xB2A2/0xB2F0/0xB304. |
| `0x00B880` | 80 | `colony_helper_8dc4_a` | R | Colony helper: active colony [0x8542] + global [0x8DC4]; calls 0xB368. |
| `0x00B8D0` | 47 | `colony_helper_8dc4_b` | R | Colony helper: active colony [0x8542] + global [0x8DC4]; calls 0xB42C. |
| `0x011D30` | 105 | `rt_dos_open` | B | C-runtime: DOS file open/create -- INT 21h AH=3Dh (access in AL&3), AH=3Eh close path. |
| `0x054505` | 177 | `colony_helper_181f_c0e` | R | Colony helper: active colony [0x8542]; thunks 0x181F:0xC0E/0xC36/0xC54. |
| `0x055760` | 11 | `data_block_misseg_5576x` | DATA | NOT a function: disassembly is data/zero-fill (ENTER 0xEFE then DB bytes) -- auto-segmenter boundary artifact. |
| `0x05576B` | 87 | `colony_helper_181f_cd6` | R | Colony helper: active colony [0x8542]; thunk 0x181F:0xCD6. |
| `0x05651C` | 45 | `data_block_misseg_5651C` | DATA | NOT a function: body is 00-fill / data decoded as code (ADD [bx+si],al runs). |
| `0x056694` | 811 | `data_block_misseg_56694` | DATA | NOT a function: 811B data block decoded as code (mostly 00 00 / junk opcodes). |
| `0x0572E6` | 164 | `native_convert_handler` | B | Natives: mission/convert path -- string 'INDIANSCONVERT', active TribeData [0x8D4E]/[0x8D52], thunks 0x181F/0x191F. |
| `0x05A20E` | 141 | `colony_scout_or_mayor_check` | B | Colony: strings 'SCOUTCOLONY' / 'NOMAYORSDURINGREV'; reads game-phase [0x5382] (post-revolution gate). |
| `0x05AC34` | 89 | `data_block_misseg_5AC34` | DATA | NOT a function: data/zero-fill decoded as code. |
| `0x05AEA0` | 140 | `data_block_misseg_5AEA0` | DATA | NOT a function: data/zero-fill decoded as code. |
| `0x05AF2C` | 68 | `data_block_misseg_5AF2C` | DATA | NOT a function: data/zero-fill (trailing 00-run) decoded as code. |
| `0x078068` | 217 | `ui_input_cursor_helper` | R | UI/input: reads cursor globals [0x184]/[0x89E]/[0x8A0], dispatches via thunks 0x181F:0x182/0x1F0/0x1FA. |
| `0x078548` | 49 | `vga_palette_dac_write` | B | VGA: writes the 256-colour palette to the DAC (OUT 0x3C7/0x3C9), vsync via IN 0x3DA; sets flag [0x808]. |
| `0x078B3E` | 52 | `overlay_thunk_1a1f_e90` | R | Thin wrapper forwarding to overlay thunk 0x1A1F:0xE90. |
