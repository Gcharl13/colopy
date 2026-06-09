/* ============================================================================
 * globals.h — every confirmed DGROUP global with a citation
 * ----------------------------------------------------------------------------
 * @ref code/VICEROY/hot_globals.md  (per-function memory-displacement scan)
 * @ref code/VICEROY/per_func_globals.json
 * @ref decompiled.md "Known DGROUP globals"
 *
 * In real-mode 16-bit C, `extern` symbols here are linked against the
 * compiled tree's .DATA / .BSS segments.  The address comments document
 * the exact DGROUP offset that matches the original VICEROY.EXE.
 *
 * Globals are grouped by purpose.
 * ============================================================================ */
#ifndef VICEROY_GLOBALS_H
#define VICEROY_GLOBALS_H

#include "viceroy_types.h"
#include "dgroup.h"          /* DGS16 — for the DGROUP-resident count aliases below */
struct colony_t;
struct UnitRecord;

/* ----------------------------------------------------------------------------
 * Map dimensions
 * ---------------------------------------------------------------------------- */
extern uint16_t g_map_width;        /* DGROUP:0x853A; @ref is_xy_in_map_bounds @ 0x5BFA */
extern uint16_t g_map_height;       /* DGROUP:0x853C; @ref is_xy_in_map_bounds */

/* Far-pointers to map-data layers; each layer is map_width * map_height bytes */
extern void far *g_map_layer_15c;   /* DGROUP:0x015C..0x015F (far ptr); @ref map_tile_read_layer_15C @ 0x5CFE */
extern void far *g_map_layer_160;   /* DGROUP:0x0160..0x0163 (far ptr); @ref map_tile_read_layer_160 @ 0x5D32 */

/* ----------------------------------------------------------------------------
 * Unit table
 * ---------------------------------------------------------------------------- */
/* unit_table: canonical decl is in unit.h (pointer aliased to DG_UNIT_TABLE,
 * g_dgroup+0x3144). Was wrongly declared here as an array `unit_table[]` (a
 * conflicting decl); reconciled to the pointer form. */
extern struct UnitRecord far *unit_table;   /* DGROUP:0x3144 (stride 0x1C); see unit.h */
extern uint16_t           g_unit_chain;   /* DGROUP:0x315C (2 bytes ahead of table base) */

/* ----------------------------------------------------------------------------
 * Current colony pointer (most-touched global; 102 functions)
 * ---------------------------------------------------------------------------- */
extern struct colony_t far *ctx;          /* DGROUP:0x8542; far ptr to current colony */

/* ----------------------------------------------------------------------------
 * Per-commodity / Europe market state — three parallel WORD arrays
 *   (only indices 0..14 are commodity-relevant; 15..19 reserved)
 * ---------------------------------------------------------------------------- */
extern uint16_t g_global_amount[20];      /* DGROUP:0x8DC8; @ref dispatch_via_8e02_with_band @ 0x8E46 */
extern uint16_t g_band_base[20];          /* DGROUP:0x8E0A; @ref set_commodity_band_at_index @ 0x8E02 */
extern uint16_t g_over_low[20];           /* DGROUP:0x8E32; @ref same as above */
extern uint16_t g_over_high[20];          /* DGROUP:0x8E5A; @ref same as above */
#define g_over_high_ore  g_over_high[6]   /* the special-case Tools-vs-Ore adjustment word at 0x8E66 */

/* ----------------------------------------------------------------------------
 * Pair-table at DGROUP:0xC8 / 0xDE  (20 entries, used to map screen coords
 * into colony tile_state_70[] indices)
 * ---------------------------------------------------------------------------- */
extern uint8_t  g_pair_key1[20];          /* DGROUP:0xC8;  @ref find_pair_in_table_C8_DE @ 0x8892 */
extern uint8_t  g_pair_key2[20];          /* DGROUP:0xDE;  @ref same */

/* ----------------------------------------------------------------------------
 * Iterator-chain globals (unit-scan over colony's surrounding area)
 * ---------------------------------------------------------------------------- */
extern uint16_t g_iter_handle;            /* DGROUP:0x8D78; @ref init_and_scan_units_in_area @ 0x8C70 */
extern uint16_t g_iter_aux_a;             /* DGROUP:0x8D72  count clamped to 50 */
extern uint16_t g_iter_aux_b;             /* DGROUP:0x8D74  total iter count */
extern uint16_t g_iter_aux_c;             /* DGROUP:0x8D76  count whose unit-type has g_table_5237[type*14] != 0 */
extern uint16_t g_iter_aux_d;             /* DGROUP:0x8D7A  secondary counter (reset when c < d) */

/* ----------------------------------------------------------------------------
 * Render-time auxiliaries
 * ---------------------------------------------------------------------------- */
extern uint16_t g_render_aux_a;           /* DGROUP:0x8D4C; @ref update_and_render_tile_at @ 0x8982 */
extern void far *g_render_aux_b_ptr;      /* DGROUP:0x8D4E; pointer; deref +5 to inc byte */
extern uint16_t g_pop_or_year;            /* DGROUP:0x8DB8; mode/era flag (compared to 1, 2) */
extern uint8_t  g_render_flag_34D;        /* DGROUP:0x34D;  if !=0 skip render */
extern uint16_t g_field_917A;             /* DGROUP:0x917A; pushed to overlay 0x9EF:0x2C */
extern uint32_t g_long_8D80;              /* DGROUP:0x8D80..0x8D83 (LE 32-bit) */

/* ----------------------------------------------------------------------------
 * Game-progress / era globals (the "0x5380.." cluster — 20-37 references each)
 * ---------------------------------------------------------------------------- */
extern uint16_t g_progress_4_5394;        /* DGROUP:0x5394; @ref colony_turn_update — limit 4 */
extern uint8_t  g_difficulty_53A6;        /* DGROUP:0x53A6; difficulty 0..4 (default 2=Conquistador).
                                           * RESOLVED 2026-05-30: was g_progress_5_53A6 "era counter" —
                                           * a mislabel. It is the global DIFFICULTY, cross-confirmed by
                                           * raze/FF/king-tax/per-turn-gold traces (==0/1/3/4 compares,
                                           * default=2 @0x07433C). Active-power idx is the SEPARATE 0x9E12. */
extern uint16_t g_progress_5398;          /* DGROUP:0x5398 */
extern uint16_t g_progress_5392;          /* DGROUP:0x5392 */
extern uint16_t g_progress_5396;          /* DGROUP:0x5396 */
/* Live entity counts at DGROUP:0x539A/0x539C/0x539E. CONSOLIDATED 2026-06-09:
 * these were declared file-locally in ~12 files (as g_unit_count_539C etc., often
 * with int16/uint16 drift and *undefined* at link), AND separately as standalone
 * vars `g_progress_539C/E` in data/production.c — two different bytes in modern
 * mode, and neither matched the overlay/load_image code that reads the same count
 * via DGS16(0x539C). Unified here as DGROUP-resident aliases so the named form,
 * the DGS16() form, and DS:0x539C are one byte (byte-faithful in both modes). */
#define g_native_count_539A   DGS16(0x539A)  /* count at 0x539A. CONTESTED SEMANTIC:
                                              * overlay calls it native/other-settlement
                                              * count; native_unit_ai bounds a settlement
                                              * home_link by it (@asm 0x047128); report
                                              * code read it as "player colony count"
                                              * (@asm 0x037667). Same byte; meaning TBD by
                                              * RE. Name unified to the overlay/majority. */
#define g_unit_count_539C     DGS16(0x539C)  /* UNIT count (table stride 0x1C) */
#define g_colony_count_539E   DGS16(0x539E)  /* COLONY count (table stride 0xCA) */
extern uint16_t g_progress_5382;          /* DGROUP:0x5382 */

/* ----------------------------------------------------------------------------
 * Per-power 0x34-byte records (English / French / Spanish / Dutch + NPCs)
 * ---------------------------------------------------------------------------- */
extern uint8_t  g_power_records[4][0x34]; /* DGROUP:0x543F = the CONTROLLER-flag column
                                           * (field +0x31 of the AIPersonality record based at
                                           * 0x540E; RULINGS 2026-05-29). [type*0x34] reads
                                           * power `type`'s controller byte (correct address).
                                           * 4 powers (was wrongly "8"). Full record layout:
                                           * include/ai_personality.h (base 0x540E). */

/* ----------------------------------------------------------------------------
 * Colony center pre-pass results (computed by compute_colony_center_yields)
 * ---------------------------------------------------------------------------- */
extern uint8_t  g_table_A891;             /* food yield class 0..6+ */
extern uint8_t  g_table_A892;             /* misc adjustment byte */
extern int8_t   g_table_A893;             /* best non-food commodity index (0xFF = none) */
extern uint8_t  g_table_A894;             /* best non-food yield amount */
extern uint8_t  g_table_A895;             /* specialist tally accumulator */
extern uint8_t  g_table_A896;             /* second tally accumulator */

/* Other colony-turn auxiliaries */
extern uint16_t g_8DC4;                   /* commodity-transfer staging quantity */
extern uint16_t g_8D4A;                   /* render structure ptr */
extern uint16_t g_8DD8;                   /* work points cumulative */
extern uint16_t g_8DE6;                   /* dispatch for slot 14 (Tools final) */
extern uint16_t g_8DE8;                   /* dispatch for slot 5 (Lumber) */
extern uint16_t g_8DEA;                   /* counter — bonus from test_bit_via_863E */
extern uint16_t g_8DEC;                   /* counter — modified by founding-fathers */
extern uint16_t g_8E6A;                   /* rebellion-quota * 2 result */

/* ----------------------------------------------------------------------------
 * Tutorial / first-time flags
 * ---------------------------------------------------------------------------- */
extern uint16_t g_tutorial_flag_35C;      /* DGROUP:0x35C; if non-zero, suppress tutorial trigger */
extern uint16_t g_tutorial_flag_348;      /* DGROUP:0x348; set to 1 when colony abandoned */

/* ----------------------------------------------------------------------------
 * Far-pointer to a major game-state record (read by 0xE4C6)
 * ---------------------------------------------------------------------------- */
extern void far *g_state_record_267A;     /* DGROUP:0x267A; @ref read_far_dword_via_267A @ 0xE4C6 */

/* ----------------------------------------------------------------------------
 * 12-byte-stride table (chain walk)
 * ---------------------------------------------------------------------------- */
extern uint8_t  g_table_8F86_stride12[];  /* DGROUP:0x8F86; @ref decompiled.md "func_0086C0" */

/* ----------------------------------------------------------------------------
 * Per-unit-type flag tables at DGROUP:0x5236/0x5237, and the PowerRecord byte
 * view at 0x8808. CONSOLIDATED 2026-06-09: these were file-local externs (each
 * undefined at link) in overlay code. Now g_dgroup-resident aliases so the
 * named byte-array form indexes the same bytes as DG_POWER_TABLE / the static
 * window (byte-faithful, no separate storage). Code indexes them as g_X[expr].
 * (The old unused `extern uint8_t g_table_5237_stride14[]` is folded in here —
 * same 0x5237 base; callers index with their own stride, 6 in the overlay.) */
#define g_table_5237_stride14    ((uint8_t near *)(DG_BASE + (uint16_t)0x5237))
#define g_unit_type_flags_5236   ((uint8_t near *)(DG_BASE + (uint16_t)0x5236))
#define g_unit_type_flags_5237   ((uint8_t near *)(DG_BASE + (uint16_t)0x5237))
#define g_power_table_8808       ((uint8_t near *)(DG_BASE + (uint16_t)0x8808))
#define native_class_weight_5AD8 ((uint8_t near *)(DG_BASE + (uint16_t)0x5AD8))  /* per-class weight table */

/* ----------------------------------------------------------------------------
 * 5-stride sub-table (used by update_and_render_tile_at)
 * ---------------------------------------------------------------------------- */
extern uint8_t  g_table_8D9E[];           /* DGROUP:0x8D9E; @ref update_and_render_tile_at @ 0x8982 */

/* ----------------------------------------------------------------------------
 * Terrain-yield table (16 bytes per terrain id, ~64 terrain ids)
 * ---------------------------------------------------------------------------- */
extern uint8_t  g_terrain_yield_table[0x400];   /* DGROUP:0x2F7B; @ref compute_terrain_yield @ 0x9B9C */

/* ----------------------------------------------------------------------------
 * C runtime globals
 * ---------------------------------------------------------------------------- */
extern uint16_t g_NFILE_QQ;               /* DGROUP:0x27B9; max open files (used by _close, _read) */
extern uint8_t  g_file_flags[];           /* DGROUP:0x27BB; per-fd flag byte */
extern uint16_t g_argc;                   /* DGROUP:0x27CF (cstart) */
extern uint16_t g_argv;                   /* DGROUP:0x27D1 (cstart) */
extern uint16_t g_envp;                   /* DGROUP:0x27D3 (cstart) */
extern uint16_t g_program_ds;             /* DGROUP:0x27B2 (saved by cstart) */
extern uint16_t g_default_text_mode_2B01; /* DGROUP:0x2B01 (used by _open) */
extern uint16_t g_iob_dispatch_2B16;      /* DGROUP:0x2B16 (function-ptr table sentinel) */
extern void   (*g_iob_dispatch_2B18)(void); /* DGROUP:0x2B18 */
extern uint16_t g_errno_27AC;             /* DGROUP:0x27AC; generic C-runtime errno
                                           * (set by func_011F6E, the RTLink/overlay-EXE
                                           * record reader — NOT savegame; RULINGS 2026-05-30) */

/* Output stream globals (printf-family pipeline) */
extern uint8_t  g_output_stream_2D40[18]; /* DGROUP:0x2D40 (stream descriptor) */
extern uint16_t g_output_count_2D52;      /* DGROUP:0x2D52 (byte counter) */
extern void far *g_buf_ptr_2D42_2D44;     /* DGROUP:0x2D42 (far ptr buffer) */
extern void far *g_stdout_FILE;           /* DGROUP:0x2916 (stdout FILE struct) */
extern void far *g_stdin_FILE;            /* DGROUP:0x290E (stdin FILE struct) */

/* DOS exec helper globals */
extern uint8_t  g_exec_param_26AB[8];     /* DGROUP:0x26AB; copied to overlay's segment+8 */
extern uint16_t g_saved_ss_26A3;          /* DGROUP:0x26A3 (saved SS during exec) */
extern uint16_t g_saved_sp_26A5;          /* DGROUP:0x26A5 */
extern uint16_t g_load_seg_26A7;          /* DGROUP:0x26A7 */

/* ----------------------------------------------------------------------------
 * RTLink overlay globals (set by system_init / overlay loader)
 * ----------------------------------------------------------------------------
 * NOTE (CORRECTED 2026-06-08): 0x3995 is **CS-RELATIVE** (code segment), NOT a
 * DGROUP global. Every access uses the 0x2E CS override (e.g. @0x013BD5
 * `mov byte cs:[0x39E3],0xFF`; `test cs:[0x39DE],8`; `add cs:[0x39B7],ax`). It is
 * self-modified overlay-dispatch state living in the code image, and it does NOT
 * occupy DGROUP (where 0x3144..0x5214 is the 300-record UnitRecord table). This
 * `extern` is retained for callers but is NOT a true DS datum; do not place it in
 * the DGROUP struct map. @ref docs/DGROUP_MEMORY_MAP.md §5.6 */
extern uint16_t g_overlay_layout_CS[0xAA];   /* CS:0x3995.. (NOT DGROUP); RTLink overlay dispatch state */

/* ----------------------------------------------------------------------------
 * Screen-ID constants (enter_screen_view bx arg; DGROUP:0x???)
 * SCREEN_EUROPE = 0x2B: byte-verified at 0x025EE5/Europe entry
 * SCREEN_COLONY = 0x2C: byte-verified at 0x025EE5/colony entry (mov bx,0x2C)
 * SCREEN_TITLE  = 0x01: title screen (conventional ID; not yet byte-verified)
 * ---------------------------------------------------------------------------- */
#define SCREEN_TITLE        0x01
#define SCREEN_EUROPE       0x2B
#define SCREEN_COLONY       0x2C
#define SCREEN_HALL_OF_FAME 0x2D  /* not yet byte-verified; conventional ID */

#endif /* VICEROY_GLOBALS_H */
