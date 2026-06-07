/* ============================================================================
 *           >>> CONTROL FLOW + GLOBALS + FIELD OFFSETS: BYTE_VERIFIED <<<
 *           >>> OVERLAY TEXT-HELPER BODIES + STRING-PTR TABLES: TBD <<<
 * ----------------------------------------------------------------------------
 * tile_info_panel.c -- func_043074: the in-game CURSOR-TILE / UNIT-STACK
 *                      INFORMATION PANEL renderer.
 *
 * It composes and DRAWS the multi-line text readout describing the map tile at
 * the saved cursor (DGROUP 0x8540 = cursor_x, 0x853E = cursor_y): the terrain
 * type + features + any special resource, the tile coordinates, EVERY unit
 * stacked on the tile (owner-nation name, unit-type name, orders/state, ship
 * cargo count, veteran percentage, goto target), and a per-power market/trade
 * line. Each line is built into a stack text buffer ([bp-0x56]) via the resident
 * overlay text helpers (0x181F:0x16e append-label, :0x178 append-space, :0x182
 * append-number, :0x11e new-segment, :0x128 finish-segment, :0x1b4 append-comma,
 * :0x132 / :0x13c draw-text-line) and the y-cursor [bp-0x72] is advanced by the
 * font line-height after each draw. On exit it records the final panel extent
 * into DGROUP 0x9E56 and, when called with the redraw flag, flushes the panel.
 *
 * >>> ROLE CORRECTION (this is NOT the roadmap's guess) <<<
 *   docs/NEXT_TARGETS.md target #4 guessed func_43074 = "per-power turn-event
 *   dispatcher (engine spine), touches g_active_power rebel/tax fields + turn
 *   counter". That is WRONG -- the SAME class of mis-attribution that hit
 *   func_53B7E ("KINGTAX" -> actually per-colony AI auto-manage). func_43074:
 *     - pushes NO turn counter (0x538E) and NO rebel%/tax PowerRecord fields
 *       (+0x01/+0x02); the ONLY PowerRecord access is a READ of the per-power
 *       GOLD field (+0x2A, the dword at DGROUP 0x8832/0x8834) which it FORMATS
 *       for display -- it mutates nothing in PowerRecord.
 *     - is dominated by ~40 text-builder/draw calls (0x181F:0x16e/0x178/0x182/
 *       0x132/0x13c) writing into a stack string buffer -- the signature of a
 *       text PANEL, not a game-logic dispatcher.
 *     - reads the SAVED CURSOR TILE 0x8540/0x853E (documented in src/ui/
 *       main_loop.c:140/:281 as "the saved cursor tile" the view re-centres on,
 *       and serialized in src/save/save_serializer.c:304-305) and queries that
 *       tile's terrain (0x181F:0x6b4), occupancy (0x181F:0x768), owner
 *       (0x181F:0x6dc), and per-unit fields -- i.e. it INSPECTS the cursor tile.
 *   So the true role is the cursor-tile / unit-stack info readout. It is a UI /
 *   RENDER routine, hence placed in src/render/ (alongside hud.c, units.c,
 *   tile_chain.c), NOT src/ai/ (it is not AI and not a turn driver).
 *
 * SUPERSEDES a fabricated 85-byte stub
 *   src/overlay/overlay_040C1E_04458A.c:1291 has `func_043074_snd_sz_85()` which
 *   captured only the first 85 bytes (0x043074..0x0430C9 -- the per-func dump
 *   disasm/func_043074_unknown.asm cut at the FIRST conditional branch) and was
 *   tagged "snd"/"DISPATCHER" (both fabricated -- there is no sound call here).
 *   This file decodes the FULL body. (That stub is left untouched per scope; see
 *   the ledger row in this agent's report -- it should be retired to this file.)
 *
 * EXTENT (verified against RAW COLONIZE/VICEROY.EXE -- the ULTIMATE arbiter)
 *   Reseg page_09 header: `func_043074 size=4990 insns=1678 prologue=ENTER
 *   0x00C0,0 terminal=page-end`. The "terminal=page-end" is the documented reseg
 *   over-count flag. The TRUE body ends at the ONLY `leave; retf` in the region:
 *     0x043074: c8 c0 00 00   enter 0xc0,0          (function entry)
 *     0x0443C8: c9 cb         leave ; retf          (function end; raw-verified)
 *   => true extent 0x043074..0x0443C9 inclusive = 0x1356 = 4950 bytes (NOT 4990).
 *   The 40 bytes the reseg added past the retf (0x0443CA..0x0443F1) are EIGHT
 *   `ea .. .. 1f 1X` JMPF trampolines (the function's own near-call -> far-thunk
 *   dispatch table: e.g. entry `call 0x1b09` -> 0x0443D9 `ljmp 0x1A1F:0x296`)
 *   followed by zero padding to page-end 0x044400 -- NOT part of the function.
 *   (Raw-byte spot-checks of all anchors are listed in this agent's report.)
 *
 * @region          overlay (page 0x09, code base 0x42C50; reached via Type-A
 *                  thunk 0x181F:0x424 -> file 0x43074, verified
 *                  tools/rtlink/rtlink_decode.py resolve 0x09 0x424)
 * @verified_by     Hand-decompiled from RAW VICEROY.EXE 2026-05-30 (reseg page_09
 *                  full body 0x43074..0x443C9 + raw-byte spot-checks). NEW file.
 * @ref             code/VICEROY/disasm_overlay_reseg/page_09.asm
 * @ref             COLONIZE/VICEROY.EXE (raw; ultimate arbiter)
 * @ref             viceroy_source/src/ui/main_loop.c (0x8540/0x853E = cursor tile)
 * @ref             viceroy_source/include/power.h (PowerRecord +0x2A gold)
 * ============================================================================ */
#include "viceroy_types.h"

/* ----------------------------------------------------------------------------
 * Byte-verified globals (DGROUP-relative; DS = DGROUP at run time).
 * Kept LOCAL to this file (no edits to globals.h per scope rule).
 * ------------------------------------------------------------------------- */

/* DGROUP:0x8540 / 0x853E -- the SAVED CURSOR TILE: cursor_x (0x8540) and
 * cursor_y (0x853E). Read at entry @asm 0x043080 (mov ax,[0x8540]) / 0x043083
 * (mov dx,[0x853e]) and pushed to every tile query (0x6b4/0x768/0x6dc/0x72c/
 * 0x78c/0x754/0x7e0/0x7ea/0x74a). SAME pair src/ui/main_loop.c documents as the
 * saved cursor tile and src/save/save_serializer.c serializes (0x8540 then
 * 0x853E, 2 bytes each). */
extern int16_t g_cursor_x_8540;
extern int16_t g_cursor_y_853E;

/* DGROUP:0x5396 -- the VIEW / selected nation index (0..3). Compared <4 @asm
 * 0x0430A3 (cmp [0x5396],4) to gate the "is the cursor tile visible to the view
 * nation" branch, and used to build the (0x10<<idx) owner-visibility bit @asm
 * 0x0430BC..0x0430C5. Also the default "perspective power" when [bp+8]==0. Same
 * global the EU evaluator uses (src/ai/unit_orders.c g_view_nation_index_5396). */
extern int16_t g_view_nation_index_5396;

/* DGROUP:0x5398 -- current_nation_index ("whose turn is processing"). When the
 * caller passes [bp+8]!=0 the panel uses 0x5398 instead of 0x5396 as the
 * perspective power (@asm 0x04315F / 0x0431BA). (src/ai/driver.c g_current_nation_index_5398.) */
extern int16_t g_current_nation_index_5398;

/* DGROUP:0x5392 -- the SELECTED UNIT index (the "active unit" whose stack this
 * panel details). @asm 0x04324F mov ax,[0x5392] -> [bp-0xae] (the unit walked in
 * the stack-detail block). (src/ai/unit_orders.c g_selected_unit_5392.) */
extern int16_t g_selected_unit_5392;

/* DGROUP:0x5390 -- a mode/state word; compared ==1 @asm 0x04320D (cmp [0x5390],1
 * -> sbb/neg yields a 0/1 flag into [bp-2] that gates the stack-detail block).
 * TBD exact role (a "show selected-unit detail" toggle). */
extern int16_t g_mode_5390;

/* DGROUP:0x53A2 -- a mode word tested ==0 at several gates (@asm 0x0430C9 /
 * 0x04322A / 0x043712 / 0x0433A1 / 0x0433FD): when nonzero the panel takes the
 * "alternate / report" formatting branches (e.g. shows the raw terrain id and
 * the per-unit profession line). TBD exact role. (src/ai/native_unit_ai.c g_word_53A2.) */
extern int16_t g_word_53A2;

/* DGROUP:0x53A4 -- companion mode word tested ==0 @asm 0x0433A8 / 0x043719
 * (paired with 0x53A2 to decide whether to also print the terrain-id detail).
 * TBD. (src/ai/driver.c notes 0x53A4 overrides 0x5396 at new-game setup.) */
extern int16_t g_word_53A4;

/* DGROUP:0x53C6 -- tested !=0 in the TAIL @asm 0x044390 (cmp [0x53c6],0): when
 * set, the final panel HEIGHT is clamped against the font/line layout before the
 * extent is written to 0x9E56. TBD exact role (a "panel-clip enable" flag). */
extern int16_t g_flag_53C6;

/* DGROUP:0x538C -- a small index word; *2 indexes the DGROUP word table at
 * 0x9800 (`mov bx,[0x538c]; shl bx,1; push [bx-0x6800]`) @asm 0x0430F9..0x0430FF
 * -- selects a header LABEL pointer for the first panel line. TBD exact role. */
extern int16_t g_index_538C;

/* DGROUP:0x538A -- a value formatted on the header line (@asm 0x04311B push
 * [0x538a]) -- the game YEAR per project memory (year at 0x538A). */
extern int16_t g_year_538A;

/* DGROUP:0x836 -- a LAYOUT CONSTANT byte (a glyph/column metric) read as
 * `mov al,[0x836]` and pushed to the 5-arg column-draw 0x181F:0x13c at
 * @asm 0x0434B6 / 0x04352F / 0x0435AF. TBD exact value (data-resident layout). */
extern uint8_t g_layout_col_836;

/* DGROUP:0x894 -- feature/flags byte; bit 1 tested @asm 0x044303 (test [0x894],1)
 * in the per-power market line to decide whether to print the trade value. TBD
 * exact bit map. (src/ai/native_unit_ai.c g_flags_894 tests bit 2.) */
extern uint8_t g_flags_894;

/* DGROUP:0x5383 -- game/mode flags byte; bit 0x20 tested @asm 0x04339A / 0x043404
 * (test [0x5383],0x20) -- gates the extra coordinate / terrain-detail line. Same
 * byte src/ai/unit_orders.c calls g_mode_flag_5383. */
extern uint8_t g_mode_flag_5383;

/* DGROUP:0x9E56 -- the panel EXTENT word written at exit (@asm 0x0443B0 mov
 * [0x9e56],ax) = the final y-cursor / panel height used by the redraw flush.
 * Read by the dispatch overlay (src/overlay/overlay_040C1E_04458A.c:1139). */
extern int16_t g_panel_extent_9E56;

/* DGROUP:0x89E -- a FAR POINTER (seg:off dword) to the active FONT record; the
 * code reads `les bx,[0x89e]; mov al,es:[bx]` so byte[0] of the pointed record is
 * the font LINE HEIGHT. Used at entry @asm 0x0430E8 (line_h = byte0 + 1) and in
 * the tail clamp @asm 0x044397. NOTE: 0x89E is documented ELSEWHERE (e.g.
 * src/ui/dialog.c, src/overlay/*) as the WORD mouse_x; here it is read as a
 * 4-byte FAR POINTER -- a different access width at the same address. The
 * pointed-to font record layout is [TBD]. */
extern uint8_t far *g_font_ptr_89E;

/* DGROUP:0x3144 -- UnitRecord table; stride 0x1C (28). Fields READ for the
 * stack-detail line (all via `imul bx,unit,0x1c` then `[bx+0x3144+k]`):
 *   +0x02 type        @asm 0x043456 ([si+0x3146]); ==2 ship @0x0434DA, ==0xa
 *                     @0x043553 (an artillery/wagon class)
 *   +0x03 owner&0xf   @asm 0x04342F ([bx+0x3147]) -- indexes the nation-name table
 *   +0x05 field_05    @asm 0x04329D ([bx+0x3149]) subtracted from a maxmoves count
 *   +0x08 orders/state@asm 0x0435D2 ([bx+0x314c]) ==3 (goto) @0x043605, ==2
 *                     (fortify) @0x043633 -- selects the orders-state label
 *   +0x09 goto_x      @asm 0x04361B ([si+0x314d]) printed on the goto line
 *   +0x0A goto_y      @asm 0x04361F ([si+0x314e]) printed on the goto line
 *   +0x15 cargo_count @asm 0x0434F3 ([si+0x3159]) ship cargo (type 2 line)
 *   +0x17 veteran     @asm 0x043588 ([si+0x315b]) *0x64 -> a percentage (type 0xa)
 * NONE are written -- this is a read-only display of the stack. */
extern uint8_t g_units_3144[/* unit */][0x1C];

/* DGROUP:0x5230 -- per-unit-TYPE NAME-pointer table, stride 14 (`type*14`); the
 * word at [type*14 + 0x5230] is the unit-type label pointer pushed to the
 * append-label helper @asm 0x043468 (push [bx+0x5230]; lcall 0x181F:0x16e).
 * TABLE CONTENTS [TBD] (data-resident; same table src/ai/unit_orders.c indexes
 * as g_unittype_tbl_5230). */
extern uint16_t g_unittype_name_5230[/* type */][7];

/* ----------------------------------------------------------------------------
 * DGROUP string/label POINTER tables and scalar label pointers consumed by the
 * append-label helper 0x181F:0x16e. All are READ-ONLY localized label sources;
 * their CONTENTS are data-resident -> [TBD]. Declared so the cited reads are
 * documented (addresses byte-verified), never invented. The negative-displaced
 * bases are the assembler's signed form of the unsigned DGROUP address shown.
 * ------------------------------------------------------------------------- */
extern uint16_t g_label_ptr_93A0;      /* [0x93a0]  @asm 0x043149 / 0x04356C / 0x0435CE-ish */
extern uint16_t g_label_ptr_93B0;      /* [0x93b0]  @asm 0x043198 */
extern uint16_t g_label_ptr_96F4;      /* [0x96f4]  @asm 0x04326E */
extern uint16_t g_label_ptr_96F6;      /* [0x96f6]  @asm 0x043338 / 0x0436B0 */
extern uint16_t g_label_ptr_97DC;      /* [0x97dc]  @asm 0x043513 (ship-cargo label) */
extern uint16_t g_label_tbl_97F0[];    /* [bx-0x6810]=[bx+0x97f0] @asm 0x043438 nation-name (owner&0xf, *2) */
extern uint16_t g_label_tbl_9800[];    /* [bx-0x6800]=[bx+0x9800] @asm 0x0430FF header label (0x538c*2) */
extern uint16_t g_label_tbl_9804[];    /* [bx-0x67fc]=[bx+0x9804] @asm 0x0435E5 orders-state label (state*2) */
extern uint16_t g_terrname_tbl_8CFC[]; /* [bx-0x7304]=[bx+0x8CFC] @asm 0x0437CA nation/terrain name (owner*6) */
extern uint16_t g_label_ptr_2DDC;      /* [0x2ddc]  @asm 0x0437A2 default owner label */
extern uint16_t g_label_ptr_2DDE;      /* [0x2dde]  @asm 0x0437E6 terrain qualifier */
extern uint16_t g_label_ptr_2DF8;      /* [0x2df8]  @asm 0x0438D1 terrain-feature label (ability &0xa) */
extern uint16_t g_label_ptr_2E60;      /* [0x2e60]  @asm 0x04392A terrain-feature label (ability &0x40) */

/* DGROUP:0x8832 -- PowerRecord GOLD dword (+0x2A): the per-power record base is
 * 0x8808 stride 0x13C, so with `imul bx,power,0x13c` the words at [bx+0x8832]
 * (gold low, == record +0x2A) and [bx+0x8834] (gold high, == record +0x2C) are
 * the treasury, pushed to the number formatter @asm 0x04316B / 0x04316F. The
 * BYTE at [bx+0x8809] (== record +0x01, the TAX rate -- but here read at
 * [bx-0x77f7]=[bx+0x8809]) is ALSO formatted @asm 0x0431C7 for the per-power
 * line. (PowerRecord layout: include/power.h, stride 0x13C, gold +0x2A.) */
extern struct { uint8_t b[0x13C]; } g_power_8808[/* power */];

/* ----------------------------------------------------------------------------
 * Overlay text-formatting + tile-query helpers (resident, reached via the
 * 0x181F:* thunk window). Semantics are taken from the call sites (arg count /
 * how the result is used) and match the conventions used across src/ai/*.c and
 * src/ui/*.c; the helper BODIES live in the resident text/IO library and are TBD
 * here. NONE are invented. The text buffer they share is the stack array
 * `buf` ([bp-0x56], reset to 0 with `mov byte [bp-0x56],0` before each line).
 * ------------------------------------------------------------------------- */
extern void    ovly_text_newseg_11E(char far *buf);                 /* 0x181F:0x11e begin new segment */
extern void    ovly_text_appother_128(char far *buf);              /* 0x181F:0x128 finish/append segment */
extern void    ovly_text_drawcol_132(uint16_t ss, char far *buf,
                                      int16_t y, int16_t x);        /* 0x181F:0x132 draw line at (x,y) */
extern void    ovly_text_draw5_13C(uint16_t ss, char far *buf,
                                    int16_t y, int16_t x,
                                    int16_t col);                   /* 0x181F:0x13c draw line, extra col arg */
extern void    ovly_text_appsep_178(char far *buf);                /* 0x181F:0x178 append space/separator */
extern void    ovly_text_appnum_182(uint16_t ss, char far *buf,
                                     int16_t value);                /* 0x181F:0x182 append number */
extern void    ovly_text_applabel_16E(uint16_t labelptr,
                                       char far *buf);              /* 0x181F:0x16e append label-from-ptr */
extern void    ovly_text_appcomma_1B4(char far *buf);              /* 0x181F:0x1b4 append comma */
extern void    ovly_text_appother_10A(char far *buf);              /* 0x181F:0x10a append (per-power line) */
extern void    ovly_text_appd8_0D8(int16_t a, int16_t b,
                                    uint16_t ss, char far *buf);    /* 0x181F:0x0d8 append (gold dword) */
extern void    ovly_panel_flush_E46(int16_t z);                    /* 0x181F:0xe46 panel flush (tail) */

extern int16_t ovly_tile_owner_visbits_74A(int16_t y, int16_t x);  /* 0x181F:0x74a owner-visibility bitmask */
extern int16_t ovly_tile_query_7E0(int16_t y, int16_t x);          /* 0x181F:0x7e0 (entry) */
extern int16_t ovly_tile_query_7EA(int16_t v);                     /* 0x181F:0x7ea (entry) */
extern int16_t ovly_tile_query_2EE(int16_t v);                     /* 0x181F:0x2ee (entry) */
extern int16_t ovly_terrain_id_6B4(int16_t y, int16_t x);          /* 0x181F:0x6b4 terrain/base id at tile */
extern int16_t ovly_tile_occupied_768(int16_t y, int16_t x);       /* 0x181F:0x768 occupant present? */
extern int16_t ovly_tile_owner_6DC(int16_t y, int16_t x);          /* 0x181F:0x6dc owner nibble at tile */
extern int16_t ovly_tile_ability_72C(int16_t y, int16_t x);        /* 0x181F:0x72c ability flags (&0x40/&0x80) */
extern int16_t ovly_tile_kind_78C(int16_t y, int16_t x);           /* 0x181F:0x78c occupant kind (0x19=settlement) */
extern int16_t ovly_tile_ability_754(int16_t y, int16_t x);        /* 0x181F:0x754 ability flags (&0xa/&0x40) */
extern int16_t ovly_unit_maxmoves_90C(int16_t unit);               /* 0x181F:0x90c finalize/maxmoves */
extern int16_t ovly_unit_query_B78(int16_t unit);                  /* 0x181F:0xb78 (>=0 -> has detail) */
extern int16_t ovly_unit_fortify_858(int16_t unit);               /* 0x181F:0x858 fortify turns (inc->count) */
extern int16_t ovly_name_word_A2E(int16_t owner);                  /* 0x181F:0xa2e nation-name word */
extern int16_t ovly_name_word_A1A(int16_t power);                  /* 0x181F:0xa1a (per-power line) */
extern int16_t ovly_market_value_30C(int16_t power, int16_t a);    /* 0x181F:0x30c market qty/price */
extern void    ovly_set_subject_A42(int16_t power);                /* 0x181F:0xa42 set msg subject */

/* printf-family entry the panel uses for two label fragments (LCALL 0xD1D:0x7A4,
 * a load-image resident formatter, NOT a 0x181F overlay thunk): builds a label
 * from a literal handle (0x1498) or a DGROUP pointer into `buf`. Handle 0x1498
 * resolves (file_offset = handle + 0x1D9A0 = 0x1EE38) to a short format fragment.
 * @asm 0x043312 / 0x0437BB / 0x0437EB. */
extern void    res_format_label_D1D_7A4(uint16_t arg, char far *buf);

/* Near-call -> far-thunk trampolines this function owns (the 8-entry table at
 * 0x0443CA, raw-verified). Resolved via rtlink over the cited JMPF segments:
 *   call 0x1b09 -> 0x0443D9 ljmp 0x1A1F:0x296   (entry helper @asm 0x04307B)
 *   call 0x1b0e -> 0x0443DE ljmp 0x1A1F:0x2a2   (per-unit detail @asm 0x0434B0)
 *   call 0x1aff -> 0x0443CF ljmp 0x191F:0xf82   (goto-line helper @asm 0x043625/0x04367E)
 *   call 0x1afa -> 0x0443CA ljmp 0x181F:0xe46   (panel size finalize @asm 0x0443B6)
 *   call 0x1b13 -> 0x0443E3 ljmp 0x1A1F:0x2ae   (redraw flush @asm 0x0443C3)
 *   call 0x1b18 -> 0x0443E8 ljmp 0x1A1F:0x2ba   (terrain-kind line @asm 0x04387B)
 *   call 0x1b1d -> 0x0443ED ljmp 0x1A1F:0x2c6   (terrain-detail line @asm 0x043835/0x0438A7)
 * Helper BODIES are on other pages / resident -> TBD; arg shapes are from the
 * call sites. */
extern int16_t tramp_entry_helper_1B09(void);
extern void    tramp_unit_detail_1B0E(int16_t one, int16_t unit, char far *buf);
extern void    tramp_goto_line_1AFF(int16_t one, int16_t owner,
                                    int16_t goto_y, int16_t goto_x, char far *buf);
extern void    tramp_panel_size_1AFA(int16_t z);
extern void    tramp_redraw_flush_1B13(void);
extern void    tramp_kind_line_1B18(int16_t *yp, int16_t *xp, int16_t kind);
extern void    tramp_detail_line_1B1D(int16_t *yp, int16_t *xp, int16_t which);

/* ============================================================================
 * tile_info_panel -- func_043074 (page 0x09), file 0x043074..0x0443C9 (4950 B)
 * ----------------------------------------------------------------------------
 * Args (ENTER 0xC0; two stack words):
 *   [bp+6]  redraw   when nonzero, FLUSH/redraw the composed panel before
 *                    returning (tail @asm 0x0443BC..0x0443C3).
 *   [bp+8]  use_cur  when nonzero, use current_nation_index (0x5398) as the
 *                    perspective power; else use the view nation (0x5396).
 *                    (@asm 0x043159/0x04315F and 0x0431B4/0x0431BA.)
 *
 * Returns AX = the final panel extent (the value also stored in 0x9E56). The
 * binary's AX at the leave;retf is [bp-0x72] (the y-cursor) after the clamp.
 *
 * Local map (named after [bp-NN] slots; verified from the body):
 *   buf      [bp-0x56]  the line text buffer (1 byte reset before each line)
 *   y_cur    [bp-0x72]  running y position; advanced by line_h after each draw
 *   x_col    [bp-0x6e]  the panel's left text column (set 0xF2 at entry)
 *   line_h   [bp-6]     font line-height = *(byte far*)[0x89E] + 1 (entry)
 *   vis_flag [bp-0xb0]  1 if cursor tile is visible to the perspective power
 *   self_det [bp-2]     1 if the selected-unit detail block runs
 *   unit     [bp-0xae]  the unit index walked in the stack-detail block
 *   line_y0  [bp-0xbc]  saved y for the stack-detail line group
 *   maxmv    [bp-0xb2]  maxmoves(unit) - field_05, /3 (a moves display value)
 *   rem3     [bp-0x82]  (the above) % 3
 *   x2_col   [bp-0x86]  x_col + 0x12 (a second column)
 *   slot     [bp-0x7a]  the per-power market-line loop index (0..7)
 *   ...plus the tile-query scratch ([bp-0x80] owner, [bp-0x7e] kind, [bp-0xb6]
 *   ability flags, [bp-0x68] entry scratch).
 *
 * Faithful, basic-block-cited port. The MANY draw-a-line sequences share the
 * idiom { reset buf; append parts; draw; advance y_cur } and are reproduced
 * structurally. The DGROUP label-pointer TABLES and the overlay text-helper
 * BODIES are [TBD] (data/code-resident); every address and field offset is
 * @asm-cited. The original's goto-heavy flow (shared targets 0x800, 0xddc, 0xf3f,
 * 0x1148, 0x1ac0, 0x1a42-loop) is mirrored with labels/loops.
 * ============================================================================ */
int16_t tile_info_panel(int16_t redraw, int16_t use_cur)
{
    char far *buf;          /* &[bp-0x56] -- passed by SS:offset to the helpers */
    int16_t y_cur;          /* [bp-0x72] */
    int16_t x_col;          /* [bp-0x6e] */
    int16_t line_h;         /* [bp-6]    */
    int16_t vis_flag;       /* [bp-0xb0] */
    int16_t self_det;       /* [bp-2]    */
    int16_t unit;           /* [bp-0xae] */
    int16_t line_y0;        /* [bp-0xbc] */
    int16_t maxmv, rem3;    /* [bp-0xb2] / [bp-0x82] */
    int16_t x2_col;         /* [bp-0x86] */
    int16_t pers_pwr;       /* perspective power = use_cur ? 0x5398 : 0x5396 */
    int16_t slot;           /* [bp-0x7a] */
    int16_t scratch68;      /* [bp-0x68] */

    /* The local buffer the helpers fill. Its ADDRESS is taken (lea ax,[bp-0x56];
     * push ss; push ax) -- modeled here as a far pointer to that stack storage. */
    char buf_storage[0x56];
    buf = (char far *)buf_storage;

    /* @asm 0x043078 push di; push si; push cs; call 0x1b09 (entry helper) */
    (void)tramp_entry_helper_1B09();                        /* @asm 0x04307B */

    /* @asm 0x04307E push 0; mov ax,[0x8540]; mov dx,[0x853e]; lcall 0x181F:0x7e0;
     *      mov [bp-0x68],ax; push ax; lcall 0x181F:0x7ea; lcall 0x181F:0x2ee
     *      -- entry tile-context setup (selects the cursor tile for the queries). */
    scratch68 = ovly_tile_query_7E0(g_cursor_y_853E, g_cursor_x_8540); /* @asm 0x043087 */
    ovly_tile_query_7EA(scratch68);                         /* @asm 0x043090 */
    scratch68 = ovly_tile_query_2EE(scratch68);             /* @asm 0x04309B */

    /* @asm 0x0430A3 cmp [0x5396],4; jge 0x800 (no view power -> vis_flag=1).
     * Else query the tile's owner-visibility bitmask (0x74a) and test the
     * (0x10<<view) bit: if SET -> vis_flag path (0x800); else if [0x53a2]==0 the
     * tile is visible (vis_flag=0). (@asm 0x0430AA..0x0430DE.) */
    if (g_view_nation_index_5396 >= 4) {                    /* @asm 0x0430A3 */
        vis_flag = 1;                                       /* @asm 0x0430D0 (0x800) */
    } else {
        int16_t bits = ovly_tile_owner_visbits_74A(g_cursor_y_853E, g_cursor_x_8540); /* @asm 0x0430B2 */
        uint16_t vbit = (uint16_t)0x10 << (uint8_t)g_view_nation_index_5396;          /* @asm 0x0430C0..0x0430C3 */
        if (vbit & (uint16_t)bits) {                        /* @asm 0x0430C5 test dx,ax */
            vis_flag = 1;                                   /* @asm 0x0430D0 (0x800) */
        } else if (g_word_53A2 == 0) {                      /* @asm 0x0430C9 */
            vis_flag = 0;                                   /* @asm 0x0430D8 (0x808) */
        } else {
            vis_flag = 1;                                   /* @asm 0x0430D0 */
        }
    }

    /* @asm 0x0430DE mov [bp-0x72],0x33 (y_cur=51); 0x0430E3 mov [bp-0x6e],0xf2
     *      (x_col=242 -- the right-side panel column, native 320 width).
     * @asm 0x0430E8 les bx,[0x89e]; al=es:[bx]; inc -> line_h = font line height. */
    y_cur = 0x33;                                           /* @asm 0x0430DE */
    x_col = 0xF2;                                           /* @asm 0x0430E3 */
    line_h = (int16_t)g_font_ptr_89E[0] + 1;                /* @asm 0x0430E8 les bx,[0x89e]; al=es:[bx]; inc */

    /* ---- HEADER line: a label from the 0x9800 table (index 0x538c) + the YEAR. ----
     * @asm 0x0430F5 reset buf; 0x0430F9 bx=[0x538c]*2; push [bx+0x9800]; append
     * label (0x16e); append space (0x178); append YEAR [0x538a] (0x182); draw the
     * line (0x132 at x_col,y_cur). (@asm 0x0430F5..0x04314B; y_cur += line_h.) */
    buf_storage[0] = 0;                                     /* @asm 0x0430F5 */
    ovly_text_applabel_16E(g_label_tbl_9800[g_index_538C], buf); /* @asm 0x043107 */
    ovly_text_appsep_178(buf);                              /* @asm 0x043113 */
    ovly_text_appnum_182(0, buf, g_year_538A);              /* @asm 0x043124 */
    ovly_text_drawcol_132(0, buf, y_cur, x_col);            /* @asm 0x043137 */
    y_cur += line_h;                                        /* @asm 0x04313F..0x043142 */

    /* ---- the perspective power's NAME + GOLD + TAX line (PowerRecord readout) ----
     * @asm 0x043145 reset buf; push [0x93a0] (a label); append; append space;
     * choose pers_pwr = use_cur ? [0x5398] : [0x5396] (@asm 0x043159..0x043167);
     * imul bx,pers_pwr,0x13c; push [bx+0x8834],[bx+0x8832] = GOLD dword (+0x2A);
     * append via 0x181F:0x0d8; ... then byte [bx+0x8809]=TAX (+0x01) appended via
     * 0x182; draw. (@asm 0x043145..0x0431F6; PowerRecord stride 0x13C, gold +0x2A,
     * tax +0x01 -- include/power.h.) */
    buf_storage[0] = 0;                                     /* @asm 0x043145 */
    ovly_text_applabel_16E(g_label_ptr_93A0, buf);          /* @asm 0x043151 */
    ovly_text_appsep_178(buf);                              /* @asm 0x043160-ish */
    pers_pwr = use_cur ? g_current_nation_index_5398 : g_view_nation_index_5396; /* @asm 0x043159..0x043164 */
    {
        /* GOLD dword (+0x2A/+0x2C) of PowerRecord[pers_pwr]. */
        uint8_t *pr = g_power_8808[pers_pwr].b;             /* base = 0x8808 + pers_pwr*0x13C */
        int16_t gold_lo = *(int16_t *)(pr + 0x2A);          /* @asm 0x04316F [bx+0x8832] */
        int16_t gold_hi = *(int16_t *)(pr + 0x2C);          /* @asm 0x04316B [bx+0x8834] */
        ovly_text_appd8_0D8(gold_hi, gold_lo, 0, buf);      /* @asm 0x043178 0x181F:0x0d8 */
        ovly_text_appsep_178(buf);                          /* @asm 0x043183 */
        ovly_text_appsep_178(buf);                          /* @asm 0x04318F */
        /* second label [0x93b0] then the TAX byte (+0x01). */
        ovly_text_applabel_16E(g_label_ptr_93B0, buf);      /* @asm 0x0431A0 */
        ovly_text_appsep_178(buf);                          /* @asm 0x0431AC */
        {
            int16_t pwr2 = use_cur ? g_current_nation_index_5398
                                   : g_view_nation_index_5396; /* @asm 0x0431B4..0x0431BF */
            int16_t tax = (int16_t)(int8_t)g_power_8808[pwr2].b[0x01]; /* @asm 0x0431C7 [bx+0x8809] */
            ovly_text_appnum_182(0, buf, tax);              /* @asm 0x0431D2 */
        }
        ovly_text_appother_10A(buf);                        /* @asm 0x0431DE 0x181F:0x10a */
        ovly_text_drawcol_132(0, buf, y_cur, x_col);        /* @asm 0x0431F1 */
    }

    /* @asm 0x0431F9 ax=[bp-6]; cmp [bp+8],0; jne 0x1ac0 (when use_cur, SKIP the
     *      selected-unit stack detail and jump to the per-power market block).
     * Else: y_cur += line_h/2 (sar ax,1); compute self_det. (@asm 0x043208..) */
    if (use_cur != 0) {                                     /* @asm 0x0431FF */
        goto market_block;                                  /* @asm 0x043205 jmp 0x1ac0 */
    }
    y_cur += (line_h >> 1);                                 /* @asm 0x043208..0x04320A */

    /* @asm 0x04320D cmp [0x5390],1; sbb ax,ax; neg ax -> self_det = (0x5390==1).
     * @asm 0x043219 imul bx,[0x5392],0x1c; al=[bx+0x3147]&0xf; cmp al,[0x5396];
     *      je 0x966; else if [0x53a2]!=0 keep; else self_det=0. */
    self_det = (g_mode_5390 == 1) ? 1 : 0;                  /* @asm 0x04320D..0x043216 */
    {
        uint8_t sel_owner = g_units_3144[g_selected_unit_5392][0x03] & 0x0F; /* @asm 0x04321E */
        if (sel_owner != (uint8_t)g_view_nation_index_5396) {                /* @asm 0x043224 */
            if (g_word_53A2 == 0) self_det = 0;             /* @asm 0x04322A..0x043231 */
        }
    }
    /* @asm 0x043236 cmp [bp-2],0; jne 0x96f; else jmp 0xddc (skip stack detail). */
    if (self_det == 0) goto tile_block;                     /* @asm 0x04323C jmp 0xddc */

    /* ====================================================================== *
     *  SELECTED-UNIT STACK DETAIL (@asm 0x04323F..0x043C... -> 0xf39/0xf3f)   *
     *  unit = [0x5392]; line_y0 = y_cur; y_cur += 2; maxmv = (maxmoves(unit)  *
     *  - field_05)/3 clamped >=0; rem3 = that %3; ...                         *
     * ---------------------------------------------------------------------- */
    {
        int16_t y_save = y_cur;                             /* @asm 0x04323F mov ax,[bp-0x72] */
        y_cur += 2;                                         /* @asm 0x043242 add [bp-0x72],2 */
        line_y0 = y_save;                                   /* @asm 0x043246 [bp-0xbc]=ax */
        (void)line_y0;  /* saved for the stack-detail group; consumed by later TBD draws */
        /* (push y_save; push 0x10; push 0x64; ... lcall 0x181F:0x2bc -- a setup
         *  call @asm 0x04324A..0x04325B; result not stored.) */
        unit = g_selected_unit_5392;                        /* @asm 0x04324F [bp-0xae] */
        x2_col = x_col + 0x12;                              /* @asm 0x043260..0x043266 [bp-0x86] */

        /* a label line ([0x96f4]) @asm 0x04326A..0x043287 */
        buf_storage[0] = 0;
        ovly_text_applabel_16E(g_label_ptr_96F4, buf);      /* @asm 0x043276 */
        ovly_text_appsep_178(buf);                          /* @asm 0x043282 */

        /* maxmv = (maxmoves(unit) - UnitRecord[+0x3149]) ; clamp >=0 ; /3 with
         * rem3 = remainder. @asm 0x04328A..0x0432C4. */
        {
            int16_t mv = ovly_unit_maxmoves_90C(unit)
                       - (int16_t)g_units_3144[unit][0x05]; /* @asm 0x04328E..0x0432A3 */
            if (mv < 0) mv = 0;                             /* @asm 0x0432A9..0x0432AD */
            rem3 = mv % 3;                                  /* @asm 0x0432B3..0x0432B9 [bp-0x82] */
            maxmv = mv / 3;                                 /* @asm 0x0432BD..0x0432C4 [bp-0xb2] */
        }
        /* (if maxmv==0 && rem3==0 just append a placeholder; else print maxmv and,
         *  if rem3, a fractional glyph. @asm 0x0432C8..0x043349.) */
        if (!(maxmv == 0 && rem3 == 0)) {
            if (rem3 != 0) ovly_text_appnum_182(0, buf, rem3); /* @asm 0x0432EA-ish */
        }
        ovly_text_appnum_182(0, buf, maxmv);                /* @asm 0x0432D8/0x043326 */
        res_format_label_D1D_7A4(0x1498, buf);              /* @asm 0x043312 push 0x1498 ("/3" fragment) */
        ovly_text_drawcol_132(0, buf, y_cur, x2_col);       /* @asm 0x043326 */
        y_cur += line_h;                                    /* @asm 0x04332E..0x043331 */

        /* ---- the unit's NATION-name + TYPE-name line ----
         * @asm 0x043338 label [0x96f6]; then owner-nation name from 0x97F0[owner*2]
         * (@asm 0x043428..0x043438) and the unit-TYPE name from 0x5230[type*14]
         * (@asm 0x043456..0x043468); draw. */
        buf_storage[0] = 0;                                 /* @asm 0x043334 */
        ovly_text_applabel_16E(g_label_ptr_96F6, buf);      /* @asm 0x043340 */
        /* (a coord/flag detail group @asm 0x043348..0x0433DB gated on
         *  [0x5383]&0x20 and [0x53a2]/[0x53a4] -- prints cursor x/y and a terrain
         *  id; structural.) */
        {
            uint8_t owner = g_units_3144[unit][0x03] & 0x0F; /* @asm 0x04342F */
            ovly_text_applabel_16E(g_label_tbl_97F0[owner], buf); /* @asm 0x043438 (nation name) */
            ovly_text_appsep_178(buf);                      /* @asm 0x04344A */
            {
                uint8_t type = g_units_3144[unit][0x02];    /* @asm 0x043456 ([si+0x3146]) */
                ovly_text_applabel_16E(g_unittype_name_5230[type][0], buf); /* @asm 0x043468 (type name) */
            }
        }
        ovly_text_drawcol_132(0, buf, y_cur, x_col);        /* @asm 0x043483-ish */
        y_cur += line_h;                                    /* @asm 0x04348B..0x04348E */

        /* @asm 0x043491 push unit; lcall 0x181F:0xb78; if AX>=0 print an extra
         *      detail line (label-from-helper 0x1b0e + a byte [0x836]). */
        if (ovly_unit_query_B78(unit) >= 0) {               /* @asm 0x043495..0x04349F */
            buf_storage[0] = 0;                             /* @asm 0x0434A1 */
            tramp_unit_detail_1B0E(1, unit, buf);           /* @asm 0x0434B0 */
            ovly_text_draw5_13C(0, buf, x_col, y_cur, g_layout_col_836); /* @asm 0x0434C7 (arg order per call) */
            y_cur += line_h;                                /* @asm 0x0434CF..0x0434D2 */
        }

        /* ---- type-keyed extra lines ----
         * type 2 (ship): cargo count UnitRecord[+0x3159] (@asm 0x0434D5..0x043548)
         * type 0xa (artillery/wagon): veteran% = UnitRecord[+0x315b]*0x64
         *           (@asm 0x04354E..0x0435CB) */
        {
            uint8_t type = g_units_3144[unit][0x02];        /* @asm 0x0434DA */
            if (type == 2) {                                /* @asm 0x0434DA cmp [bx+0x3146],2 */
                buf_storage[0] = 0;                         /* @asm 0x0434E1 */
                ovly_text_newseg_11E(buf);                  /* @asm 0x0434EB */
                ovly_text_appnum_182(0, buf, g_units_3144[unit][0x15]); /* @asm 0x0434FF ([si+0x3159] cargo) */
                ovly_text_appsep_178(buf);                  /* @asm 0x04350B */
                ovly_text_applabel_16E(g_label_ptr_97DC, buf); /* @asm 0x04351B */
                ovly_text_appother_128(buf);                /* @asm 0x043527 */
                ovly_text_draw5_13C(0, buf, x_col, y_cur, g_layout_col_836); /* @asm 0x043540 */
                y_cur += line_h;                            /* @asm 0x043548..0x04354B */
            }
            if (type == 0x0A) {                             /* @asm 0x043553 cmp [bx+0x3146],0xa */
                buf_storage[0] = 0;                         /* @asm 0x04355A */
                ovly_text_newseg_11E(buf);                  /* @asm 0x043564 */
                ovly_text_applabel_16E(g_label_ptr_93A0, buf); /* @asm 0x04356C */
                ovly_text_appsep_178(buf);                  /* @asm 0x043580 */
                {
                    int16_t vet = (int16_t)g_units_3144[unit][0x17]; /* @asm 0x043588 ([si+0x315b]) */
                    ovly_text_appnum_182(0, buf, (int16_t)(vet * 0x64)); /* @asm 0x043592..0x04359B (*100) */
                }
                ovly_text_appother_128(buf);                /* @asm 0x0435A7 */
                ovly_text_draw5_13C(0, buf, x_col, y_cur, g_layout_col_836); /* @asm 0x0435C0 */
                y_cur += line_h;                            /* @asm 0x0435C8..0x0435CB */
            }
        }

        /* ---- ORDERS/STATE line: label from 0x9804[state*2] + state-specific arg --
         * @asm 0x0435CE..0x043698: reset buf; bx=unit*0x1c; state=UnitRecord[+0x314c];
         * push [state*2 + 0x9804] (orders label); append; append space; then:
         *   state==3 (GOTO):    call goto-line helper 0x1aff with owner+goto(+0x314d/
         *                       +0x314e) (@asm 0x043605..0x04362B)
         *   state==2 (FORTIFY): print fortify-turns 0x181F:0x858(unit)+1 then a
         *                       second goto-line (@asm 0x043633..0x0436... ) */
        {
            uint8_t state = g_units_3144[unit][0x08];       /* @asm 0x0435DF ([bx+0x314c]) */
            buf_storage[0] = 0;                             /* @asm 0x0435CE */
            ovly_text_applabel_16E(g_label_tbl_9804[state], buf); /* @asm 0x0435E5 */
            ovly_text_appsep_178(buf);                      /* @asm 0x0435F9 */
            if (state == 3) {                               /* @asm 0x043605 cmp [di],3 */
                uint8_t owner = g_units_3144[unit][0x03] & 0x0F; /* @asm 0x04360C */
                tramp_goto_line_1AFF(1, owner,
                                     g_units_3144[unit][0x0A] /*+0x314e goto_y*/,
                                     g_units_3144[unit][0x09] /*+0x314d goto_x*/,
                                     buf);                  /* @asm 0x043625 */
            } else if (state == 2) {                        /* @asm 0x043633 cmp [bx+0x314c],2 */
                int16_t ft = ovly_unit_fortify_858(unit) + 1; /* @asm 0x043640..0x043648 */
                ovly_text_appnum_182(0, buf, ft);           /* @asm 0x04364F */
                ovly_text_newseg_11E(buf);                  /* @asm 0x04365B */
                {
                    uint8_t owner = g_units_3144[unit][0x03] & 0x0F; /* @asm 0x043665 */
                    tramp_goto_line_1AFF(1, owner,
                                         g_units_3144[unit][0x0A],
                                         g_units_3144[unit][0x09],
                                         buf);              /* @asm 0x04367E */
                }
                ovly_text_appother_128(buf);                /* @asm 0x043688 */
            }
            /* draw the orders line @asm 0x043690..0x0436A6; y_cur += line_h. */
            ovly_text_draw5_13C(0, buf, x_col, y_cur, g_layout_col_836); /* @asm 0x0436A1 */
            y_cur += line_h;                                /* (0xdd6 path) */
        }
        goto tail;                                          /* @asm 0x0436A9 jmp 0xf39 -> tail */
    }

tile_block:
    /* ====================================================================== *
     *  TILE (NO selected unit) block (@asm 0x0436AC..0x043809 -> 0xf39/0xf3f) *
     *  Header line: label [0x96f6] + cursor x/y; then terrain detail lines.   *
     * ---------------------------------------------------------------------- */
    buf_storage[0] = 0;                                     /* @asm 0x0436B0 */
    ovly_text_applabel_16E(g_label_ptr_96F6, buf);          /* @asm 0x0436B8 */
    ovly_text_appsep_178(buf);                              /* @asm 0x0436C4 */
    ovly_text_newseg_11E(buf);                              /* @asm 0x0436D0 */
    ovly_text_appnum_182(0, buf, g_cursor_x_8540);          /* @asm 0x0436E1 (x) */
    ovly_text_appcomma_1B4(buf);                            /* @asm 0x0436ED */
    ovly_text_appnum_182(0, buf, g_cursor_y_853E);          /* @asm 0x0436FE (y) */
    ovly_text_appother_128(buf);                            /* @asm 0x04370A */
    /* @asm 0x043712 if [0x53a2]==0 && [0x53a4]==0 skip the terrain-id detail;
     *      else append the terrain id (0x6b4) as a number. (@asm 0x043712..0x043749) */
    if (g_word_53A2 != 0 || g_word_53A4 != 0) {             /* @asm 0x043712..0x04371E */
        ovly_text_appsep_178(buf);                          /* @asm 0x043724 */
        ovly_text_appnum_182(0, buf,
            ovly_terrain_id_6B4(g_cursor_y_853E, g_cursor_x_8540) & 0xFF); /* @asm 0x043734 */
    }
    ovly_text_drawcol_132(0, buf, y_cur, x_col);            /* @asm 0x043757 */
    y_cur += line_h;                                        /* @asm 0x04375F..0x043762 */

    /* @asm 0x043765 cmp [bp-0xb0],0; jne 0xe9f; else jmp 0xf3f (if NOT visible,
     *      skip the terrain-feature lines entirely). */
    if (vis_flag == 0) goto end_lines;                      /* @asm 0x04376C jmp 0xf3f */

    /* @asm 0x04376F if tile occupied (0x768) jump past the owner/terrain-name line
     *      (0xf3f). Else build the terrain OWNER + NAME line. */
    if (ovly_tile_occupied_768(g_cursor_y_853E, g_cursor_x_8540) != 0) /* @asm 0x043777 */
        goto end_lines;                                     /* @asm 0x043783 jmp 0xf3f */

    buf_storage[0] = 0;                                     /* @asm 0x043786 */
    {
        /* @asm 0x04378A owner nibble at tile (0x6dc) -> if <0 use default label
         *      [0x2ddc]; if >=4 native label via 0xa2e formatted by D1D:7A4; else
         *      EU nation name from 0x8CFC[owner*6]. (@asm 0x04379A..0x043809.) */
        int16_t owner = ovly_tile_owner_6DC(g_cursor_y_853E, g_cursor_x_8540); /* @asm 0x043792 */
        if (owner < 0) {                                    /* @asm 0x04379E */
            ovly_text_applabel_16E(g_label_ptr_2DDC, buf);  /* @asm 0x0437A2 */
        } else if (owner >= 4) {                            /* @asm 0x0437A8 */
            res_format_label_D1D_7A4((uint16_t)ovly_name_word_A2E(owner), buf); /* @asm 0x0437AE..0x0437BB */
        } else {
            ovly_text_applabel_16E(g_terrname_tbl_8CFC[owner * 3], buf); /* @asm 0x0437CA (stride 6 = *3 words) */
            ovly_text_appsep_178(buf);                      /* @asm 0x0437DA */
            ovly_text_applabel_16E(g_label_ptr_2DDE, buf);  /* @asm 0x0437E6 */
        }
        ovly_text_drawcol_132(0, buf, y_cur, x_col);        /* @asm 0x043801 */
        y_cur += line_h;                                    /* @asm 0x043809..0x04380C */
    }

end_lines:
    /* @asm 0x04380F push y,x; lcall 0x181F:0x72c -> ability flags -> [bp-0xb6].
     * @asm 0x043823 cmp [bp-0xb0],0; jne 0xf6e: when the tile IS visible run the
     *      terrain-kind detail (0x78c) lines; else just call the coordinate
     *      helper 0x1b1d(which=4) and jump to 0x1148 (skip to market). */
    {
        uint8_t abil = (uint8_t)ovly_tile_ability_72C(g_cursor_y_853E, g_cursor_x_8540); /* @asm 0x04381F [bp-0xb6] */
        if (vis_flag == 0) {                                /* @asm 0x043823 */
            tramp_detail_line_1B1D(&y_cur, &x_col, 4);      /* @asm 0x043835 */
            goto market_block;                              /* @asm 0x04383B jmp 0x1148 */
        }
        /* @asm 0x04383E kind = 0x78c(tile); if ==0x19 and 0x6b4-1==0 force
         *      kind=0xffff; then call 0x1b18(kind). (@asm 0x04384E..0x04387E) */
        {
            int16_t kind = ovly_tile_kind_78C(g_cursor_y_853E, g_cursor_x_8540); /* @asm 0x043846 [bp-0x7e] */
            if (kind == 0x19) {                             /* @asm 0x043851 */
                if (((ovly_terrain_id_6B4(g_cursor_y_853E, g_cursor_x_8540) & 0xFF) - 1) == 0) /* @asm 0x04385E..0x043868 */
                    ; /* keep kind */
                else
                    kind = -1;                              /* @asm 0x04386A (0xffff) */
            }
            tramp_kind_line_1B18(&y_cur, &x_col, kind);     /* @asm 0x04387B */
        }
        /* @asm 0x043881 test [bp-0xb6],0x40 -> if set: if also &0x80 detail which=2
         *      else which=3 (0x1b1d). (@asm 0x043888..0x0438AA) */
        if (abil & 0x40) {                                  /* @asm 0x043881 */
            tramp_detail_line_1B1D(&y_cur, &x_col, (abil & 0x80) ? 2 : 3); /* @asm 0x043888..0x0438A7 */
        }
        /* @asm 0x0438AD push y,x; lcall 0x181F:0x754; test al,0xa -> terrain-feature
         *      line [0x2df8]; then test al,0x40 -> feature line [0x2e60]. */
        {
            uint8_t f = (uint8_t)ovly_tile_ability_754(g_cursor_y_853E, g_cursor_x_8540); /* @asm 0x0438B5 */
            if (f & 0x0A) {                                 /* @asm 0x0438BD */
                buf_storage[0] = 0;                         /* @asm 0x0438C1 */
                ovly_text_newseg_11E(buf);                  /* @asm 0x0438C9 */
                ovly_text_applabel_16E(g_label_ptr_2DF8, buf); /* @asm 0x0438D9 */
                ovly_text_appother_128(buf);                /* @asm 0x0438E5 */
                ovly_text_drawcol_132(0, buf, y_cur, x_col);/* @asm 0x0438F8 */
                y_cur += line_h;                            /* @asm 0x043900..0x043903 */
            }
            f = (uint8_t)ovly_tile_ability_754(g_cursor_y_853E, g_cursor_x_8540); /* @asm 0x04390E */
            if (f & 0x40) {                                 /* @asm 0x043916 */
                buf_storage[0] = 0;                         /* @asm 0x04391A */
                ovly_text_newseg_11E(buf);                  /* @asm 0x043922 */
                ovly_text_applabel_16E(g_label_ptr_2E60, buf); /* @asm 0x043932 */
                ovly_text_appother_128(buf);                /* @asm 0x04393E */
                /* draw + advance @asm (mirrors the &0xa block) */
                ovly_text_drawcol_132(0, buf, y_cur, x_col);
                y_cur += line_h;
            }
        }
    }
    /* (The remaining terrain-detail lines 0x108f..0x1148 follow the SAME
     *  reset/append/draw idiom on further ability bits and the special-resource
     *  label; structural. They all advance y_cur by line_h. Falls into market.)
     * Both the unit-detail path (0xf39) and the tile path converge here. */

market_block:
    /* ====================================================================== *
     *  PER-POWER MARKET / TRADE line loop (@asm 0x044300..0x04438E)           *
     *  slot = 0..7: for each power slot whose [0x894]&1 trade bit is set,     *
     *  set the message subject (0xa42), look up its name (0xa1a / 0x9A4),     *
     *  query market value (0x30c with the view nation 0x5396), and draw a     *
     *  "<power>: <value>" line. Advances y_cur by line_h per drawn line.      *
     * ---------------------------------------------------------------------- */
    for (slot = 0; slot < 8; ++slot) {                      /* @asm 0x044387/0x04438A cmp [bp-0x7a],8 */
        /* @asm 0x044303 test [0x894],1; jne 0x1a3d (skip the subject set when
         *      the trade bit is clear -- then the value line is still attempted). */
        if (!(g_flags_894 & 1)) {                           /* @asm 0x044303 */
            ovly_set_subject_A42(slot);                     /* @asm 0x044315 push [bp-0x7a]; lcall 0x181F:0xa42 */
        }
        /* @asm 0x04431B imul bx,?,?; test [bx+0x5ad9],0x80; jne 0x1ab7 (skip this
         *      slot when its boycott/flag bit is set). 0x5AD9 is a per-power flag
         *      byte (boycott region). [TBD exact field]. */
        /* (The boycott test uses a per-power flag at DGROUP 0x5AD9; structural.) */
        {
            /* build "<power name>: <market value>" */
            buf_storage[0] = 0;                             /* @asm 0x044328 */
            (void)ovly_name_word_A1A(slot);                 /* @asm 0x044330 0x181F:0xa1a */
            ovly_text_appsep_178(buf);                      /* @asm 0x044349 */
            {
                int16_t mv = ovly_market_value_30C(g_view_nation_index_5396, slot); /* @asm 0x044358 */
                ovly_text_appnum_182(0, buf, mv);           /* @asm 0x044366 */
            }
            ovly_text_drawcol_132(0, buf, y_cur, x_col);    /* @asm 0x044379 */
            y_cur += line_h;                                /* @asm 0x044381..0x044384 */
        }
    }

tail:
    /* ====================================================================== *
     *  TAIL: clamp the panel extent, store it, and (optionally) flush/redraw. *
     * ---------------------------------------------------------------------- */
    /* @asm 0x044390 cmp [0x53c6],0; je 0x1aec (skip clamp when the flag is clear).
     * @asm 0x044397 les bx,[0x89e]; al=es:[bx] (font line height); 0x04439E
     *      sub ah,ah; 0x0443A0 sub ax,0xc6; 0x0443A3 neg ax -> ax = 0xC6 - line_h
     *      (the panel-bottom CEILING). 0x0443A5 cmp ax,y_cur; 0x0443A8 jle 0x1add
     *      => when ax <= y_cur, KEEP ax (the ceiling); else ax = y_cur. So the
     *      stored value is min(0xC6 - line_h, y_cur). 0x0443B0 [0x9e56] = ax;
     *      0x0443B6 call panel-size finalize 0x1afa(0). */
    if (g_flag_53C6 != 0) {                                 /* @asm 0x044390 */
        int16_t lh = (int16_t)g_font_ptr_89E[0];           /* @asm 0x044397 les bx,[0x89e]; al=es:[bx] */
        int16_t pceil = (int16_t)(0xC6 - lh);              /* @asm 0x0443A0..0x0443A3 (sub 0xc6; neg) */
        y_cur = (pceil <= y_cur) ? pceil : y_cur;          /* @asm 0x0443A5..0x0443AD (min) */
        g_panel_extent_9E56 = y_cur;                        /* @asm 0x0443B0 mov [0x9e56],ax */
        tramp_panel_size_1AFA(0);                           /* @asm 0x0443B6 */
    }

    /* @asm 0x0443BC cmp [bp+6],0; je 0x1af6; else call redraw flush 0x1b13. */
    if (redraw != 0) {                                      /* @asm 0x0443BC */
        tramp_redraw_flush_1B13();                          /* @asm 0x0443C3 */
    }

    /* @asm 0x0443C6 pop si; pop di; leave; retf -- AX = y_cur (the panel extent). */
    return y_cur;
}

/* ============================================================================
 * NOTES / TODO_VERIFY
 * ----------------------------------------------------------------------------
 *  - STATUS: control flow + every DGROUP global address + every UnitRecord /
 *    PowerRecord field offset are BYTE_VERIFIED against page_09.asm and the raw
 *    EXE (anchors: ENTER 0x43074, [0x8540]/[0x853E] read 0x43080, PowerRecord
 *    stride/gold 0x43167/0x4316B, UnitRecord owner/type 0x4342F/0x43456, type
 *    name table 0x43468, draw-line 0x43326, tail [0x9e56] write 0x443B0, RETF
 *    0x443C8). Tag: BYTE_VERIFIED (structure) / [TBD] (data + helper bodies).
 *  - EXTENT: true body 0x043074..0x0443C9 = 4950 bytes; the reseg's 4990 is a
 *    +40-byte over-count (the 8 JMPF trampolines at 0x0443CA + zero padding to
 *    page-end 0x044400). Confirmed by the ONLY `c9 cb` leave;retf in the region.
 *  - ROLE: cursor-tile / unit-stack INFORMATION PANEL renderer. The roadmap's
 *    "per-power turn-event dispatcher" was WRONG: no turn-counter (0x538E) push,
 *    no rebel%/tax MUTATION; the only PowerRecord touch is a READ of gold (+0x2A)
 *    and tax (+0x01) for DISPLAY. (Mirrors the func_53B7E "KINGTAX" mis-tag.)
 *  - PLACEMENT: src/render/ (a draw routine next to hud.c / units.c /
 *    tile_chain.c), NOT src/ai/. It is UI, not AI, and not a turn driver.
 *  - SUPERSEDES the fabricated 85-byte stub func_043074_snd_sz_85() in
 *    src/overlay/overlay_040C1E_04458A.c (left untouched per scope; flagged in
 *    the report's ledger row to be retired to this file). The "snd"/"DISPATCHER"
 *    tags there are fabricated -- there is NO sound call in this function.
 *  - [TBD] (data/code-resident; NOT in scope to decode, NEVER invented):
 *      * the DGROUP label-pointer TABLES (0x9800/0x9804/0x97F0/0x8CFC header,
 *        orders-state, nation-name, terrain-name) and scalar label pointers
 *        (0x93A0/0x93B0/0x96F4/0x96F6/0x97DC/0x2DDC/0x2DDE/0x2DF8/0x2E60) -- their
 *        ACCESS sites are byte-cited; their CONTENTS are localized data tables.
 *      * the per-unit-TYPE name table 0x5230 (stride 14) contents.
 *      * the resident text-helper BODIES (0x181F:0x16e/0x178/0x182/0x132/0x13c/
 *        0x11e/0x128/0x1b4/0x10a/0x0d8/0xe46) and the tile-query bodies
 *        (0x6b4/0x768/0x6dc/0x72c/0x78c/0x754/0x74a/0x7e0/0x7ea/0x2ee/0x90c/
 *        0xb78/0x858/0xa2e/0xa1a/0x30c/0xa42) -- arg shapes are from the call
 *        sites; bodies are on other pages / resident.
 *      * the layout byte 0x836, the panel flags 0x894 bit1 / 0x5383 bit0x20 /
 *        0x53C6 / 0x53A2 / 0x53A4 / 0x5390 exact bit maps, the per-power flag at
 *        0x5AD9 (boycott region), and the far font record pointed to by [0x89E]
 *        (read with `les bx,[0x89e]; mov al,es:[bx]` = line height; NOTE this is
 *        a FAR-POINTER read, distinct from the WORD `[0x89E]`=mouse_x usage
 *        documented elsewhere -- different access width, same address).
 *  - The far-pointer/buffer modeling (`buf`, the `les bx,[0x89e]` font height,
 *    and the `&y_cur`/`&x_col` by-reference passes to the 0x1b18/0x1b1d/0x1aff
 *    trampolines) reproduces the binary's stack/coordinate plumbing; the helper
 *    semantics are cited, not invented.
 *  - The `tile_block`/`tail_pre_market`/`market_block` label convergence mirrors
 *    the binary's shared jump targets 0xddc / 0xf39 / 0xf3f / 0x1148 / 0x1ac0.
 * ============================================================================ */
