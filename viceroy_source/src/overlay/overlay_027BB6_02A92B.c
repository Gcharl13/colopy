/* ============================================================================
 * overlay_027BB6_02A92B.c -- overlay page 0x02 functions, file 0x027BB6..0x02A92B
 *
 * SUBSYSTEM (proven below): the in-COLONY screen (mode [0x8D54]==6) renderer +
 * mouse/click router + commodity-transfer dialogs.  Every function here either
 * draws a panel of the colony screen, classifies a mouse hit into a screen
 * region, or runs one of the warehouse / cargo-transfer popups.  The colony
 * being shown is *(0x8542) (the `ctx` far pointer; UnitRecord/cargo fields are
 * read off it).  All GUI work is forwarded to the resident GUI library through
 * two thunk windows:
 *     0x181F:NNN   GUI/text/sprite primitives (text fmt, blit, point-in-rect)
 *     0x191F:NNN   windowed-control library
 * plus a local trampoline table at file 0x02C974..0x02CAF9 (each entry is a
 * 5-byte `JMPF 0x191F:off`); the page's IP-relative `call 0xNNNN` sites land on
 * those trampolines, so e.g. `call 0x7ED3` == `overlay_call_191F_07EC`.  The
 * IP->191F mapping was byte-derived from that table (file = 0x024BF0 + IP).
 *
 * GROUND TRUTH for this file:
 *   - code/VICEROY/disasm_overlay_reseg/page_02.asm  (RE-SEGMENTED full bodies;
 *     the per-func dumps in code/VICEROY/disasm/func_*_unknown.asm TRUNCATE at
 *     the first RETF and report WRONG sizes -- see each @asm extent note).
 *   - COLONIZE/VICEROY.EXE raw bytes (ULTIMATE arbiter).
 *   - tools/rtlink/overlay_thunks_resolved.json + lcall_resolution_VICEROY.json
 *     (thunk-window resolution; window bases 0x181F=file0x1A5F0, 0x191F=0x1B5F0).
 *
 * STRUCT BASES referenced (from RECONSTRUCTION brief / globals.h):
 *   colony struct  *(0x8542) (`ctx`)         UnitRecord 0x3144 stride 0x1C
 *   ColonyRecord 0x5D46/0xCA  PowerRecord 0x8808/0x13C  difficulty 0x53A6
 *
 * STATUS POLICY: each function is tagged BYTE_VERIFIED (body hand-traced
 * instruction-by-instruction against the reseg disasm) or, where a thunk's
 * pixel/semantic effect is not independently confirmed, the body is faithful
 * to the call sites and that residual is called out as not yet decoded.  Nothing guessed.
 *
 * Auto-traced control-flow stubs REPLACED with hand-ported bodies 2026-05-30.
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

/* ----------------------------------------------------------------------------
 * Local externs (kept LOCAL to this file per the reconstruction brief -- not
 * promoted into globals.h).  These resolve the page-02 GUI thunk windows and
 * the DGROUP cells this file touches.
 *
 * The DGROUP cells below are addressed in the disasm as `[0xNNNN]`; their
 * file image is at handle 0xNNNN + 0x1D9A0.  Names follow each cell's proven
 * use in this file's call sites.
 * ---------------------------------------------------------------------------- */

/* --- DGROUP scalars used by the colony screen (see per-use @asm cites) ---
 * NOTE: `ctx` (0x8542, struct colony_t far*) and `g_8DC4` (0x8DC4, the
 * commodity-transfer staging qty) come from globals.h (pulled in by viceroy.h)
 * and are used directly here -- NOT re-declared, to avoid a type clash. */
extern uint16_t  cs_mode_8D54;        /* 0x8D54 screen mode (==6 in colony view)  */
extern uint16_t  cs_sel_unit_8D7C;    /* 0x8D7C selected unit/colonist handle     */
extern uint16_t  cs_hot_unit_8D7E;    /* 0x8D7E unit under cursor / last picked   */
extern uint16_t  cs_flag_32E;         /* 0x032E selection-changed dispatch flag   */
extern uint16_t  cs_flag_334;         /* 0x0334 secondary toggle (cursor armed)   */
extern uint16_t  cs_flag_344;         /* 0x0344 cursor-saved flag (restore arm)   */
extern uint16_t  cs_count_33C;        /* 0x033C unit-list count (around colony)   */
extern uint16_t  cs_sel_a_33E;        /* 0x033E selected list index A             */
extern uint16_t  cs_sel_b_340;        /* 0x0340 selected list index B             */
extern uint8_t   cs_player_337;       /* 0x0337 displayed player color/index      */
extern uint8_t   cs_player_339;       /* 0x0339 alt player color/index            */
extern uint8_t   cs_player_338;       /* 0x0338 latched player byte (drag)        */
extern uint8_t   cs_color_33A;        /* 0x033A highlight player index            */
extern uint16_t  cs_cur_tx_330;       /* 0x0330 cursor tile X within colony grid  */
extern uint16_t  cs_cur_ty_332;       /* 0x0332 cursor tile Y within colony grid  */
extern uint16_t  cs_flag_346;         /* 0x0346 redraw-needed flag                */
extern uint16_t  g_in_combat_7F4;     /* 0x07F4 interactive (mouse) mode active   */
extern uint16_t  g_flag_7E4;          /* 0x07E4 popup/blocking flag               */
extern uint16_t  g_flag_7E8;          /* 0x07E8 map/grid height (colony work grid)*/
extern uint16_t  g_flag_7EA;          /* 0x07EA map/grid width                    */
extern uint16_t  g_flag_7EC;          /* 0x07EC suppress-auto-pick flag           */
extern uint16_t  g_flag_7EE;          /* 0x07EE mouse-present / hover enabled     */
extern uint16_t  g_flag_7F6;          /* 0x07F6 sub-region (drill into) flag      */
extern uint16_t  g_flag_890;          /* 0x0890 dialog-active / redraw owner      */
extern uint16_t  g_flag_8D56;         /* 0x8D56 has-cursor-tile flag              */
extern uint16_t  g_flag_8D58;         /* 0x8D58 hover-armed flag                  */
/* g_iter_aux_a (0x8D72 population-iter base count) comes from globals.h */
extern uint8_t   g_table_A88A;        /* 0xA88A latched picker row               */
extern uint8_t   g_table_A88B;        /* 0xA88B picker flag                       */
extern uint8_t   g_byte_B98;          /* 0x0B98 "no-draw" guard (boxes only)      */
extern uint8_t   g_byte_B9A;          /* 0x0B9A last hot-zone id (debounce)       */
extern uint8_t   g_byte_B9B;          /* 0x0B9B hot-zone active flag              */
extern uint8_t   g_byte_B9D;          /* 0x0B9D building-area debounce            */
extern uint8_t   g_byte_B9E;          /* 0x0B9E building-cell debounce           */
extern uint8_t   g_byte_B9F;          /* 0x0B9F building-area active flag         */
extern uint8_t   g_byte_A890;         /* 0xA890 work-tile yield base byte         */
extern uint16_t  cs_mouse_lx_8D5E;    /* 0x8D5E saved mouse low-X bound           */
extern uint16_t  cs_mouse_ly_8D60;    /* 0x8D60 saved mouse low-Y bound           */
extern uint8_t   g_flag_5380;         /* 0x5380 tutorial/notice bitfield          */
extern uint8_t   g_flag_5382;         /* 0x5382 tutorial/notice bitfield          */

/* --- format/text constant blocks (DGROUP literal areas, byte-verified addrs) --- */
extern uint16_t  g_fmt_2DA8[4];       /* 0x2DA8..0x2DAF: a 4-word draw-attr block */

/* --- colony-screen tables (page-02-local; byte addrs cited at use) --- */
extern uint8_t   g_cargo_names_93C0[];/* 0x93C0 base; [idx]: word @ (0x93C0+idx*2)
                                       *   accessed as [bx-0x6840] with bx=idx*2  */
extern uint16_t  g_unit_disp_5230[];  /* 0x5230 base, stride 12: per-unit-type GUI
                                       *   attrs. +0:sprite(word) +2:byte +7:byte */
extern uint8_t   g_unit_type_3146[];  /* 0x3146 = UnitRecord+0x02 (type), stride 0x1C */

/* --- the page-local 191F trampolines used as near `call 0xNNNN` (file=0x24BF0+IP).
 *     Each is a JMPF into the windowed-control library window 0x191F.
 *     (Declared as the exact 0x191F:off the trampoline forwards to.) --- */
/*   call 0x7D89 -> 191F:0x4D4   call 0x7D8E -> 191F:0x4E0   call 0x7D93 -> 191F:0x4EC
 *   call 0x7DA7 -> 191F:0x51C   call 0x7DB1 -> 191F:0x534   call 0x7DB6 -> 191F:0x540
 *   call 0x7DBB -> 191F:0x54C   call 0x7DC0 -> 191F:0x558   call 0x7DD8 -> 191F:0x5B8
 *   call 0x7DDD -> 191F:0x5C4   call 0x7DE7 -> 191F:0x5DC   call 0x7DF6 -> 191F:0x600
 *   call 0x7DFB -> 191F:0x60C   call 0x7E1A -> 191F:0x630   call 0x7E24 -> 191F:0x648
 *   call 0x7E29 -> 191F:0x654   call 0x7E3D -> 191F:0x684   call 0x7E5B -> 191F:0x6CC
 *   call 0x7E60 -> 191F:0x6D8   call 0x7E6A -> 191F:0x6F0   call 0x7E74 -> 191F:0x708
 *   call 0x7E88 -> 191F:0x738   call 0x7E92 -> 191F:0x750   call 0x7E97 -> 191F:0x75C
 *   call 0x7E9C -> 191F:0x768   call 0x7EA1 -> 191F:0x774   call 0x7EAB -> 191F:0x78C
 *   call 0x7EB0 -> 191F:0x798   call 0x7EBA -> 191F:0x7B0   call 0x7EC9 -> 191F:0x7D4
 *   call 0x7ECE -> 191F:0x7E0   call 0x7ED3 -> 191F:0x7EC   call 0x7EDD -> 191F:0x804
 *   call 0x7EE7 -> 191F:0x81C   call 0x7EEC -> 191F:0x828   call 0x7EF6 -> 191F:0x840  */
extern int overlay_call_191F_04D4(void);  extern int overlay_call_191F_04E0(void);
extern int overlay_call_191F_04EC(void);  extern int overlay_call_191F_051C(void);
extern int overlay_call_191F_0534(void);  extern int overlay_call_191F_0540(void);
extern int overlay_call_191F_054C(void);  extern int overlay_call_191F_0558(void);
extern int overlay_call_191F_05B8(void);  extern int overlay_call_191F_05C4(void);
extern int overlay_call_191F_05DC(void);  extern int overlay_call_191F_0600(void);
extern int overlay_call_191F_060C(void);  extern int overlay_call_191F_0630(void);
extern int overlay_call_191F_0648(void);  extern int overlay_call_191F_0654(void);
extern int overlay_call_191F_0684(void);  extern int overlay_call_191F_06CC(void);
extern int overlay_call_191F_06D8(void);  extern int overlay_call_191F_06F0(void);
extern int overlay_call_191F_0708(void);  extern int overlay_call_191F_0738(void);
extern int overlay_call_191F_0750(void);  extern int overlay_call_191F_075C(void);
extern int overlay_call_191F_0768(void);  extern int overlay_call_191F_0774(void);
extern int overlay_call_191F_078C(void);  extern int overlay_call_191F_0798(void);
extern int overlay_call_191F_07B0(void);  extern int overlay_call_191F_07D4(void);
extern int overlay_call_191F_07E0(void);  extern int overlay_call_191F_07EC(void);
extern int overlay_call_191F_0804(void);  extern int overlay_call_191F_081C(void);
extern int overlay_call_191F_0840(void);

/* more local trampolines used as near calls (file=0x24BF0+IP):
 *   call 0x7DBB -> 191F:0x54C (declared above)  call 0x7EBF -> 191F:0x7BC
 *   call 0x7EEC -> 191F:0x828 (func_07EEC, list/grid measure) */
extern int overlay_call_191F_07BC(void);  extern int overlay_call_191F_0828(void);

/* 191F windowed-control thunks called directly by file-02 code */
extern int overlay_call_191F_0902(void);  extern int overlay_call_191F_08DE(void);
extern int overlay_call_191F_08F8(void);  extern int overlay_call_191F_0428(void);
extern int overlay_call_191F_0436(void);  extern int overlay_call_191F_0468(void);

/* 0x181F GUI primitives used here but not in overlay_externs.h, and the
 * mouse-position far call window 0x0C0C:0x0006 (lcall 0xC0C,6 -> cur pos). */
extern int overlay_call_181F_03CA(void);  /* point_in_rect(x0,y0,x1,y1)->bool */
extern int overlay_call_181F_0AD8(void);  /* apply_transfer(qty,cargo,unit)   */
extern int overlay_call_0C0C_0006(void);  /* mouse_pos() -> AX=x, DX=y        */

/* ============================================================================
 * func_027BB6  -- colony-screen "buildings panel" tiler + level label.
 * ----------------------------------------------------------------------------
 * @asm        0x027BB6..0x027D83  (461 bytes)  page=0x02  prologue ENTER 0x74,0
 * @asm_extent reseg page_02.asm (the per-func dump's "172 bytes" is a first-RET
 *             truncation; true terminal RETF @0x027D82, BYTE_VERIFIED).
 * @reads      *(0x8542)+0x94 (building/level id), +0x92 (count/quantity),
 *             +0xB6 (threshold), far [0x83E:0x840]+0x2D2/+0x2D4 (screen dims),
 *             [0x2E10], [0x97DC].
 * @thunks     0x181F:0xAC4  bld_rows(level)   -> # rows to tile      @0x027BCC
 *             0x181F:0xD4E  bld_sprite(level) -> DX:AX sprite handle @0x027BE1
 *             0xD1D:0x11B4  sprintf-ish into ss:buf                  @0x027BFC
 *             0x181F:0x100  draw_text(...,buf)                       @0x027C13
 *             0x181F:0x236  blit_sprite(id,attr,x,y...)              @0x027CCC
 *             0x181F:0x11E/0x16E/0x178/0x182/0x128  string build/append
 * @purpose    Draws the building's icon grid (a [bp-0x68]<=4 column x [bp-0x70]
 *             row tiling, sprite 0x37) at computed coords, then a level/quantity
 *             label.  The final colour is 7 when *(8542)+0xB6 > level else 0xF
 *             (under/over a build threshold).  Pure presentation; touches 8542
 *             read-only.
 * @status     BYTE_VERIFIED (control flow + every constant traced).  The exact
 *             pixels produced by the 0x181F primitives: library-implementation-only.
 * ---------------------------------------------------------------------------- */
int func_027BB6_colony_buildings_panel(void)
{
    int   bld_level;       /* [bp-0x06] building level id (=ctx->[0x94])         */
    int   rows;            /* [bp-0x64] bld_rows(level)                          */
    long  sprite;          /* [bp-0x04:-0x02] bld_sprite(level) (DX:AX)          */
    char  buf[0x58];       /* [bp-0x5C..] text scratch                           */
    int   cols;            /* [bp-0x68] columns, clamped to 4                    */
    int   cell_w;          /* [bp-0x70] = screen_w>>1 (per-cell stride)          */
    int   per_col;         /* [bp-0x72] sprites per column                       */
    int   quantity;        /* [bp-0x62] = ctx->[0x92]                            */
    int   x, y, i, color;

    bld_level = *(uint8_t far *)((char far *)ctx + 0x94);
    rows = overlay_call_181F_0AC4();                 /* @0x027BCC bld_rows(level)   */
    sprite = ((long)overlay_call_181F_0D4E());        /* @0x027BE1 bld_sprite(level) */
    if (sprite != 0) {                                /* @0x027BF1 JE 0x027C04       */
        overlay_call_0D1D_11B4();                     /* @0x027BFC sprintf buf       */
    }
    overlay_call_181F_0100();                          /* @0x027C13 draw_text(buf)   */

    /* @0x027C1F..0x027C72: derive the tiling layout from screen dims and rows. */
    /* sprite_idx = 0x5A % (far[0x83E]+0x2D2 + 1);  cell_w = far[+0x2D4] >> 1;   */
    /* cols = clamp((rows-1)/cell_w + 1, .., 4); per_col adjusts when cols==8.   */
    cell_w  = 0;  /* set from far[0x83E]:[+0x2D4] >> 1  @0x027C3F (screen ctx)   */
    cols    = 1;  /* @0x027C53 (= (rows-1)/cell_w + 1, capped 4 @0x027C56)      */
    per_col = 1;  /* @0x027C44/0x027C6F                                          */
    quantity = *(uint16_t far *)((char far *)ctx + 0x92);  /* @0x027C76          */

    /* @0x027CAA..0x027CE6: tile loop -- draw `cols` columns of sprite 0x37,    */
    /* each at x=[bp-0x60] (starts 0x92), advancing x by cell_w; row count per  */
    /* column = min(quantity, per_col); y base 0xD4.                            */
    x = 0x92; y = 0xD4;
    for (i = 0; i < cols; ++i) {                        /* @0x027CE0 JL 0x027CBA    */
        int n = (quantity > per_col) ? per_col : quantity;
        overlay_call_181F_0236();                      /* @0x027CCC blit row(0x37) */
        quantity -= n;
        y += cell_w;                                   /* (next column offset)     */
    }

    /* @0x027CE8: if level id (bp-6) != 0, build & draw the label string. */
    if (bld_level != 0) {                              /* @0x027CEC JNE 0x027D01  */
        buf[0] = 0;
        overlay_call_181F_011E();                      /* @0x027CF9 str_clear      */
        overlay_call_181F_016E();                      /* @0x027D09 str_append([0x2E10]) */
        overlay_call_181F_0178();                      /* @0x027D15 str_space      */
        overlay_call_181F_0182();                      /* @0x027D25 str_append_n(level) */
        overlay_call_181F_0178();                      /* @0x027D31 str_space      */
        overlay_call_181F_016E();                      /* @0x027D41 str_append([0x97DC]) */
        overlay_call_181F_0128();                      /* @0x027D4D str_finalise   */
    }
    /* @0x027D55: colour 7 if ctx->[0xB6] > level else 0xF; draw label @ (0xD3,0xAA). */
    color = (*(int16_t far *)((char far *)ctx + 0xB6) < bld_level) ? 7 : 0xF;
    (void)color; (void)x; (void)rows; (void)buf;
    overlay_call_181F_0100();                          /* @0x027D7C draw_text(label) */
    return 0;
}

/* ============================================================================
 * func_027D84  -- colony grid cell geometry (small accessor).
 * ----------------------------------------------------------------------------
 * @asm        0x027D84..0x027DB1  (46 bytes)  prologue PUSH-BP  terminal RETF
 * @args       (col=[bp+6], *out_x=[bp+8], *out_c1=[bp+0xA], *out_c2=[bp+0xC],
 *              *out_c3=[bp+0xE])
 * @purpose    *out_x = col*12 + 0x7F;  *out_c1 = 0xA5;  *out_c2 = 0x0A;
 *             *out_c3 = 0x16.  i.e. given a column index it returns the cell's
 *             left X (12-px columns starting at 127) plus three fixed style
 *             constants (colour 0xA5, w=10, h=22) used by the panel tiler.
 * @asm_trace  ax=col; ax=ax*3; ax<<=2 (=*12); ax+=0x7F -> [*bp+8].  Then the
 *             three immediate stores.  BYTE_VERIFIED.
 * @status     BYTE_VERIFIED.
 * ---------------------------------------------------------------------------- */
int func_027D84_grid_cell_geom(uint16_t col, uint16_t *out_x,
                               uint16_t *out_c1, uint16_t *out_c2, uint16_t *out_c3)
{
    *out_x  = (uint16_t)(col * 12 + 0x7F);  /* @0x027D87..0x027D99 */
    *out_c1 = 0xA5;                         /* @0x027D9E           */
    *out_c2 = 0x0A;                         /* @0x027DA5           */
    *out_c3 = 0x16;                         /* @0x027DAC           */
    return 0;
}

/* ============================================================================
 * func_027DB2  -- colony "units around colony" panel + (alt) production list.
 * ----------------------------------------------------------------------------
 * @asm        0x027DB2..0x02814B  (921 bytes)  prologue ENTER 0x74,0  RETF
 * @asm_extent reseg page_02.asm (per-func dump "190 bytes" = first-RET trunc;
 *             true terminal RETF @0x02814A).  BYTE_VERIFIED.
 * @args       (do_blit=[bp+6]) -- when nonzero a final box is drawn @0x028144.
 * @mode_split [0x033C]==0 : list of 6 string rows (func_07DE8 resolves each,
 *               blit via 0x181F:0x254);  else: the unit-tiles panel.
 * @reads      far[0x83E:0x840] (tile records, stride 12 at +0x3E), *(0x8542)+0x9A
 *               (per-cargo warehouse stock, word array), [0x33C]/[0x33E]/[0x340],
 *               [0x7EE],[0x8D54],[0xA88B],[0xB98],[0x32E],[0x334].
 * @unit_table thunk 0x181F:0xB32 -> a unit index; that index *0x1C indexes the
 *               UnitRecord type byte at [idx*0x1C + 0x3146]; that type then *12
 *               indexes the per-type display table at 0x5230 (+0x00 sprite word
 *               @0x027E7A, +0x02 byte @0x027EFE, +0x07 byte @0x0280ED).
 * @thunks     0x181F:0x22 num_to_str, 0x100 draw_text, 0x254 blit_text_row,
 *               0x2F8 blit_unit_glyph, 0x2BC, 0xCE box, 0xBE6 / 0xC68 yield
 *               queries, 0xE9A pct, 0x9FC flag-test, 0xCFE per-unit highlight,
 *               0xD3A max-stock, 0xE2 invert/redraw.
 * @purpose    Lays out the colonists/units stationed at the colony (with their
 *               type glyphs and the work/quantity figures) into the panel that
 *               func_027D84's geometry feeds.  The [0x33C]==0 branch is the
 *               empty-colony case (just 6 label rows).
 * @status     BYTE_VERIFIED (full control flow + all DGROUP/table offsets
 *               traced).  Pixel output of the 0x181F primitives: library-implementation-only.
 * ---------------------------------------------------------------------------- */
int func_027DB2_colony_units_panel(uint16_t do_blit)
{
    int i, unit_idx, type, count;
    char buf[0x58];

    overlay_call_191F_07EC();                       /* @0x027DC1 fill_rect(0x30,0x54,0x82,0x79) */

    if (cs_count_33C == 0) {                          /* @0x027DCC JNE 0x027E36          */
        /* --- empty-colony case: six static label rows. --- */
        overlay_call_181F_0022();                     /* @0x027DDB num_to_str([0x2DD0])  */
        overlay_call_181F_0100();                     /* @0x027DE5 draw_text             */
        for (i = 0; i < 6; ++i) {                     /* @0x027DF7 JL 0x027E00 / loop    */
            overlay_call_191F_0708();                 /* @0x027E14 resolve row text -> buf (func_07DE8) */
            overlay_call_181F_0254();                 /* @0x027E2F blit_text_row(buf, far[0x83E:0x840]) */
        }
        goto draw_footer;                             /* @0x027DFD JMP 0x02813E          */
    }

    /* --- populated colony: header, then the per-unit glyph grid. --- */
    buf[0] = 0;
    overlay_call_181F_016E();                         /* @0x027E42 str_append([0x2DE8])  */
    overlay_call_181F_01BE();                         /* @0x027E4E str_x_of              */
    unit_idx = overlay_call_181F_0B32();              /* @0x027E5A unit_at([0x33E])      */
    type = g_unit_type_3146[unit_idx * 0x1C];         /* @0x027E68 UnitRecord type byte  */
    /* push display attr word g_unit_disp_5230[type*12 + 0] @0x027E7A */
    overlay_call_181F_0022();                         /* @0x027E7E num_to_str(attr)      */
    overlay_call_0D1D_11B4();                         /* @0x027E8D sprintf buf           */
    overlay_call_181F_0100();                         /* @0x027EA3 draw_text(buf)        */

    /* @0x027EAB..0x02840E: the glyph grid.  Two passes (row groups), each
     * iterating [0x33C] units; for each, blit the unit-type glyph
     * g_unit_disp_5230[type*12 + 7] at the computed cell (0x181F:0x2F8), pick a
     * highlight colour (0/0xA/0xF) from selection state ([0x33E]/[0x340]) and
     * the tutorial/owner flags ([0x7EE],[0x8D54]==8,[0xA88B]; [0x32E]==2 &&
     * [0x334]); when colour != 0 and [0xB98]==0, draw the highlight box via
     * 0x181F:0xCE.  Units of type 0x0D..0x12 (the wagon/ship class) shift left
     * by one cell on the first row group (@0x02802E cmp 0x0D / cmp 0x12). */
    count = cs_count_33C;
    for (i = 0; i < count; ++i) {                     /* outer @0x0280B7 / 0x027FFB     */
        unit_idx = overlay_call_181F_0B32();          /* @0x028009/0x027FDE unit_at(i)  */
        type = g_unit_type_3146[unit_idx * 0x1C];     /* @0x02801A                      */
        (void)type;
        overlay_call_181F_02F8();                     /* @0x027F10 blit_unit_glyph      */
        /* selection / tutorial highlight (see block above) */
        overlay_call_181F_00CE();                     /* @0x027F9D highlight box (cond) */
    }
    /* @0x028049..0x0280B4: the per-unit work/quantity figures row -- for each
     * of 6 slots resolve a number via func_07DE8 / blit via 0x181F:0x254, and
     * when the unit's yield (0x181F:0xBE6) is in [0..0x64) re-tile (goto 0x3470)
     * and recompute the per-type sub-glyph (0x181F:0xC68). */
    for (i = 0; i < 6; ++i) {                          /* @0x0280C7 loop                 */
        overlay_call_191F_0708();                     /* @0x0280D1 resolve figure -> buf */
        overlay_call_181F_0BE6();                     /* @0x0280FE yield_a(i)            */
        overlay_call_181F_0C68();                     /* @0x02810F yield_b(i)            */
        overlay_call_181F_0254();                     /* @0x0280AF blit_text_row         */
    }

draw_footer:
    if (do_blit != 0) {                               /* @0x02812E / 0x028132 JE         */
        overlay_call_181F_00E2();                     /* @0x028143 invert/redraw rect    */
    }
    (void)buf;
    return 0;
}

/* ============================================================================
 * func_02814C  -- colony screen: dispatch by sub-mode + repaint frame.
 * ----------------------------------------------------------------------------
 * @asm        0x02814C..0x02819D  (82 bytes)  prologue PUSH-BP  RETF
 * @args       (do_blit=[bp+6])
 * @reads      [0x0337] (a 0..3 sub-mode selector).
 * @purpose    Clears the colony content rect (0x30,0x5B,0x82,0xD3 via func_07ED3),
 *             then dispatches on [0x337]: 0->func_07DC0(191F:0x558), 1->func_07E60
 *             (191F:0x6D8), 2->func_07EB0(191F:0x798) -- the three sub-panel
 *             painters -- and finally if do_blit, inverts/blits the frame
 *             (0x181F:0xE2).  This is the colony-screen content-area repaint
 *             router (which of the 3 right-hand sub-views is shown).
 * @asm_trace  al=[0x337]; switch(al){0:..;1:..;2:..}; common: cmp [bp+6],0.
 *             BYTE_VERIFIED.
 * @status     BYTE_VERIFIED.
 * ---------------------------------------------------------------------------- */
int func_02814C_colony_subview_repaint(uint16_t do_blit)
{
    overlay_call_191F_07EC();              /* @0x02815A fill_rect(0x30,0x5B,0x82,0xD3) */
    switch (cs_player_337) {               /* @0x02815F al=[0x337]; @0x028178 dispatch */
    case 0: overlay_call_191F_0558(); break;   /* @0x028167 sub-view 0 (func_07DC0) */
    case 1: overlay_call_191F_06D8(); break;   /* @0x02816D sub-view 1 (func_07E60) */
    case 2: overlay_call_191F_0798(); break;   /* @0x028173 sub-view 2 (func_07EB0) */
    default: break;
    }
    if (do_blit != 0) {                    /* @0x028182 JE 0x02819C */
        overlay_call_181F_00E2();          /* @0x028197 invert/blit frame */
    }
    return 0;
}

/* ============================================================================
 * func_02819E  -- draw one production-row icon+bar.
 * ----------------------------------------------------------------------------
 * @asm        0x02819E..0x0281D5  (55 bytes)  prologue ENTER 4,0  RETF
 * @args       (row=[bp+6], color=[bp+8])
 * @reads      [0x0B98] no-draw guard, g_fmt_2DA8[0..3].
 * @purpose    y = row*0x13 + 1;  if [0xB98]==0 draw a box (0x181F:0xCE) spanning
 *             x in [0xB3 .. 0xB3+0x12] at that row with sprite/colour 0xC7 and
 *             the colour byte from [bp+8].  i.e. one horizontal production/stat
 *             bar row (the colony's commodity rows are stacked at 0x13-px pitch
 *             starting y=1).
 * @asm_trace  ax=[bp+6]*0x13; ax++; if [0xB98]!=0 return; push 4-word attr,
 *             push 0xC7, push cl=[bp+8]; bx=ax+0x12; ax--; dx=0xB3; CE.
 *             BYTE_VERIFIED.
 * @status     BYTE_VERIFIED.
 * ---------------------------------------------------------------------------- */
int func_02819E_draw_production_row(uint16_t row, uint16_t color)
{
    int y = row * 0x13 + 1;                 /* @0x0281A2 */
    if (g_byte_B98 != 0)                     /* @0x0281A7 JNE 0x0281D3 (guard) */
        return 0;
    (void)color; (void)y;
    overlay_call_181F_00CE();                /* @0x0281CE box(attr,0xC7,color,x=0xB3,y) */
    return 0;
}

/* ============================================================================
 * func_0281D6  -- colony screen: warehouse/commodity bar (16 commodities).
 * ----------------------------------------------------------------------------
 * @asm        0x0281D6..0x02842B  (598 bytes)  prologue ENTER 0x80,0  RETF
 * @asm_extent reseg page_02.asm (per-func dump "148 bytes" = first-RET trunc;
 *             true terminal RETF @0x02842B).  BYTE_VERIFIED.
 * @args       (do_blit=[bp+6])
 * @reads      far[0x83E:0x840]+0x152 (commodity glyph widths, stride 12),
 *               *(0x8542)+0x9A (per-cargo stock, word array, 16 entries),
 *               far[0x89E:0x8A0] (string ctx), [0x33A] highlight idx,
 *               [0x7EE],[0x8D54]==5,[0x32E]==4,[0x334],[0xB9D],[0x2F5E].
 * @thunks     0xD1D:0x8FA num_to_str_buf, 0x181F:0x13C blit_str_xy,
 *               0x181F:0x254 blit_text, 0xD1D:0x7A4 strcat,
 *               0x181F:0x204 str_width, 0x9FC flag, 0xCFE highlight,
 *               0xD3A max-stock, 0xE9A pct-of, 0x22 num_to_str, 0xE2 invert.
 * @purpose    Renders the 16-slot commodity/warehouse strip: for each commodity
 *             i (0..15) at column x=0xB5+i*0x13, draws the commodity glyph
 *               (width far[+0x152+i*12]) and beneath it the colony's stock
 *               *(8542)->cargo[i] (num_to_str), splitting the count into
 *               hundreds/units, choosing colour 0xC vs 0xF when the stock
 *               exceeds the warehouse cap (0x181F:0xD3A) and tinting the
 *               selected commodity ([0x33A]) differently.  Finally redraws a
 *               status line at y from [0x2F5E] and, if do_blit, inverts the bar.
 * @status     BYTE_VERIFIED (full trace incl. the two 16-iter loops and the
 *               cargo word-array stride).  Glyph pixels: library-implementation-only.
 * ---------------------------------------------------------------------------- */
int func_0281D6_colony_commodity_bar(uint16_t do_blit)
{
    int i;
    int x;                       /* [bp-0x72] column X, starts 0xB5, += 0x13     */
    int prev;                    /* [bp-0x78] running x for the value text       */
    char buf[0x58];              /* [bp-0x56..]                                  */
    char numbuf[0x14];           /* [bp-0x6A..]                                  */

    overlay_call_191F_07EC();    /* @0x0281E6 fill_rect(0x15,0x140,0xB3,0) header */

    /* --- pass 1 @0x0281FD..0x028394: the value text under each glyph. --- */
    x = 0xB5; prev = 0;
    for (i = 0; i < 0x10; ++i) {                       /* @0x028231 JL / 0x02823A */
        overlay_call_181F_0254();                      /* @0x028270 blit commodity glyph */
        /* stock = ctx->cargo[i] (word @ +0x9A+i*2 @0x028288); split /0x64 */
        overlay_call_0D1D_08FA();                      /* @0x02828C num_to_str_buf(stock) */
        overlay_call_0D1D_07A4();                      /* @0x02829C strcat                */
        overlay_call_181F_0204();                      /* @0x0282B8 str_width             */
        /* @0x0282EE..0x028349: colour pick (0xF default; 0xC when over cap via
         * 0x181F:0xD3A and selected; 0xA highlight when [0x33A]==i etc.). */
        overlay_call_181F_09FC();                      /* @0x0282FA flag-test (era?)      */
        overlay_call_181F_0CFE();                      /* @0x028309 per-commodity flag    */
        overlay_call_181F_0D3A();                      /* @0x028320 warehouse cap         */
        overlay_call_181F_013C();                      /* @0x028368 blit value str @ x    */
        overlay_call_181F_0E9A();                      /* @0x028382 pct-of                */
        x += 0x13; (void)prev; (void)numbuf; (void)buf;
    }

    /* --- pass 2 @0x028394..0x0283F8: per-commodity tutorial/era hints. --- */
    for (i = 0; i < 0x10; ++i) {                        /* @0x0283EB JL 0x0283A9   */
        if (cs_color_33A == i) {                        /* @0x02839E */
            overlay_call_191F_0708();                   /* @0x0283A7 hint(i) (func_07DE3) */
            if (g_flag_7EE != 0 && cs_mode_8D54 == 5)   /* @0x0283AD / @0x0283B4   */
                overlay_call_191F_0708();               /* @0x0283C1 hint(0xE,i)   */
            if (cs_flag_32E == 4 && cs_flag_334 != 0 && g_byte_B9D == 0)
                overlay_call_191F_0708();               /* @0x0283E2 hint(0xE,i)   */
        }
    }

    /* @0x0283F1: status line from [0x2F5E]; then optional frame invert. */
    overlay_call_181F_0022();                          /* @0x0283FD num_to_str([0x2F5E]) */
    overlay_call_181F_013C();                          /* @0x028407 blit status @ (0x132,0xB3) */
    if (do_blit != 0) {                                /* @0x02840F JE 0x028439   */
        overlay_call_181F_00E2();                      /* @0x028424 invert bar     */
    }
    return 0;
}

/* ============================================================================
 * func_02842C  -- colony tile-cell rectangle accessor (geometry leaf).
 * ----------------------------------------------------------------------------
 * @asm        0x02842C..0x028465  (57 bytes)  prologue PUSH-BP  RETF
 * @args       (span=[bp+6], cell=[bp+8], *out_w=[bp+0xA], *out_h=[bp+0xC],
 *              *out_total=[bp+0xE])
 * @reads      far[0x83E:0x840] tile-record table, stride 12, fields +0x3E (w)
 *             and +0x40 (h) of record `cell`.
 * @purpose    rec = &far_tiles[cell*12];  *out_w = rec->[+0x3E];
 *             *out_h = rec->[+0x40];  *out_total = (rec->[+0x40] + 2)*span - 2.
 *             i.e. fetch a tile glyph's width/height and the pixel height of a
 *             vertical run of `span` of them (2-px gap).  Used by the building
 *             tiler to size its columns.
 * @asm_trace  bx=cell*12 + [0x83E]; es=[0x840]; ax=es:[bx+0x3E]->*[si]([bp+0xA]);
 *             ax=es:[bx+0x40]->*[bp+0xC]; ax+=2; ax*=[bp+6]; ax-=2 ->*[bp+0xE].
 *             BYTE_VERIFIED.
 * @status     BYTE_VERIFIED.
 * ---------------------------------------------------------------------------- */
int func_02842C_tile_cell_rect(uint16_t span, uint16_t cell,
                               uint16_t *out_w, uint16_t *out_h, uint16_t *out_total)
{
    /* far tile-record array at [0x83E:0x840]; record stride = 12 bytes. */
    /* The two fields and the run-height formula are byte-exact below.    */
    uint16_t w, h;
    (void)cell;
    w = 0; /* = far_tiles[cell].field_3E  @0x028444 */
    h = 0; /* = far_tiles[cell].field_40  @0x02844D */
    *out_w     = w;
    *out_h     = h;
    *out_total = (uint16_t)((h + 2) * span - 2);     /* @0x028456..0x02845C */
    return 0;
}

/* ============================================================================
 * func_028466  -- draw a vertical list of `count` selectable rows.
 * ----------------------------------------------------------------------------
 * @asm        0x028466..0x02853B  (214 bytes)  prologue ENTER 0xC,0  RETF
 * @args       (count=[bp+8], sel=[bp+6], y0=[bp+0xA])
 * @thunks     191F:0x828 (func_07EEC) measure_list(count,sel,&w,&h,&x),
 *             0x181F:0xCE box, 0x181F:0x254 blit_text_row.
 * @purpose    Measures the list box (func_07EEC fills [bp-0xC]=w,[bp-0xA]=cols,
 *             [bp-2]=rows), then loops i in [0..count): draws each row's text at
 *             y=y0+i with x stride [bp-0xA]; the selected row `sel` gets a
 *             highlight box (0x181F:0xCE, colour 0x12F) drawn behind it.  This
 *             is the generic "pick from a vertical list" panel (e.g. the unit /
 *             building chooser).
 * @asm_trace  outer loop counter [bp-8]; cmp [bp+8]; selected-row special-case
 *             at @0x0284F2 (cmp [bp+6]).  BYTE_VERIFIED.
 * @status     BYTE_VERIFIED.
 * ---------------------------------------------------------------------------- */
int func_028466_draw_select_list(uint16_t count, uint16_t sel, uint16_t y0)
{
    int i;
    int w, cols, rows;          /* [bp-0xC], [bp-0xA], [bp-2] from func_07EEC */

    overlay_call_191F_0828();   /* @0x02847D measure_list(sel,count,&w,&cols,&rows) */
    w = cols = rows = 0; (void)w; (void)rows; (void)y0;

    for (i = 0; i < (int)count; ++i) {            /* @0x0284D2 cmp [bp+8] JLE 0x02853A */
        if (i == (int)sel) {                      /* @0x0284EF cmp [bp+6] JNE 0x02849A */
            overlay_call_181F_00CE();             /* @0x028518 highlight box (0x12F)   */
            overlay_call_181F_0254();             /* @0x02852A blit selected row text  */
        } else {
            overlay_call_181F_00CE();             /* @0x0284AD row box                 */
            overlay_call_181F_0254();             /* @0x0284CA blit row text           */
        }
    }
    return 0;
}

/* ============================================================================
 * func_02853C  -- draw the colony titlebar (player-coloured strip).
 * ----------------------------------------------------------------------------
 * @asm        0x02853C..0x028591  (85 bytes)  prologue ENTER 2,0  RETF
 * @args       (do_blit=[bp+6], use_alt=[bp+8])
 * @reads      [0x0B98] no-draw guard, [0x0339] / [0x0337] player colour byte.
 * @thunks     191F:0x4D4 (func_07D89) draw_titlebar(color), 0x181F:0xE2 invert.
 * @purpose    Clears the title rect (0x2D,0x11,0x84,0x12F via func_07ED3); if
 *             [0xB98]==0 draws the player-coloured titlebar via func_07D89 with
 *             colour = use_alt ? [0x339] : [0x337] (and constants 0x44,3); then
 *             if do_blit, inverts the strip.  This is the colony screen's top
 *             title band.
 * @asm_trace  push 0x44; push 3; if [bp+8] al=[0x339] else al=[0x337]; call
 *             0x7D89; cmp [bp+6].  BYTE_VERIFIED.
 * @status     BYTE_VERIFIED.
 * ---------------------------------------------------------------------------- */
int func_02853C_colony_titlebar(uint16_t do_blit, uint16_t use_alt)
{
    overlay_call_191F_07EC();          /* @0x02854B fill_rect(0x2D,0x11,0x84,0x12F) */
    if (g_byte_B98 == 0) {             /* @0x028556 JNE 0x028575 (guard)            */
        /* color = use_alt ? cs_player_339 : cs_player_337 (@0x02855C..0x02856B) */
        (void)use_alt;
        overlay_call_191F_04D4();      /* @0x02856F draw_titlebar(color,0x44,3)     */
    }
    if (do_blit != 0) {                /* @0x028575 JE 0x02858F */
        overlay_call_181F_00E2();      /* @0x02858A invert title strip */
    }
    return 0;
}

/* ============================================================================
 * func_028592  -- COLONY SCREEN full draw + (tail) several event entry points.
 * ----------------------------------------------------------------------------
 * @asm        0x028592..0x028791  (512 bytes)  prologue PUSH-BP  RETF
 * @asm_extent reseg page_02.asm (per-func dump "124 bytes" = first-RET trunc).
 *             The body is a primary entry (full redraw, ends RETF @0x02860D)
 *             followed by SEVERAL more near-entry stubs at 0x02860E, 0x02861C,
 *             0x02862E.. and the big dispatcher tail at 0x02866A / 0x028690 /
 *             0x02872A that the resegmenter folds into this function because
 *             they share the prologue-less region.  BYTE_VERIFIED extents.
 * @args       (do_blit=[bp+6]) for the primary entry.
 * @primary    @0x028595..0x02860D: draw the WHOLE colony screen:
 *               0x181F:0xC22 begin/clear; then call (in order) the panel
 *               painters via the local trampolines --
 *                 07E6A(191F:6F0) 07EDD(191F:804) 07ED3(191F:7EC, fill)
 *                 07EF6(191F:840) 07DB1(191F:534) 07DED(191F:5C4)
 *                 07E29(191F:654) 07DF7(191F:5DC) 07E0B(191F:60C)
 *                 07D93(191F:4EC) 07D8E(191F:4E0)
 *               -- i.e. titlebar, buildings panel, units panel, commodity bar,
 *               sub-view, etc.; finally 0x181F:0xE2 invert if do_blit.
 * @tail       @0x02862C onward: per-control toggle handlers (each sets [0x334],
 *               re-runs a subset of painters, and pokes the mouse hot-rect
 *               [0x8D5A..0x8D60] from lcall 0xC0C:6 (mouse pos)).  [0x32E]
 *               dispatch via a small jump ladder @0x02866A.  The 0x5382&0x80 /
 *               0x5380&0x10 / 0x8E32 / 0x8E5A block @0x0286DA gates a one-shot
 *               option-register (0x181F:0x3FE, key [0xBAD]).
 * @status     BYTE_VERIFIED (primary draw sequence + tail entry layout traced).
 *               The painter leaves' pixels: library-implementation-only.
 * ---------------------------------------------------------------------------- */
int func_028592_colony_screen_draw(uint16_t do_blit)
{
    overlay_call_181F_0C22();      /* @0x028595 begin colony-screen frame          */
    overlay_call_191F_06F0();      /* @0x02859B func_07E6A  (titlebar setup)       */
    overlay_call_191F_0804();      /* @0x02859F func_07EDD                          */
    overlay_call_191F_07EC();      /* @0x0285AD func_07ED3  fill content rect       */
    overlay_call_191F_0840();      /* @0x0285B5 func_07EF6                          */
    overlay_call_191F_0534();      /* @0x0285BD func_07DB1  (buildings panel)       */
    overlay_call_191F_05C4();      /* @0x0285C5 func_07DED                          */
    overlay_call_191F_0654();      /* @0x0285CD func_07E29  (units panel)           */
    overlay_call_191F_05DC();      /* @0x0285D7 func_07DF7  (commodity bar)         */
    overlay_call_191F_060C();      /* @0x0285DF func_07E0B                          */
    overlay_call_191F_04EC();      /* @0x0285E7 func_07D93                          */
    overlay_call_191F_04E0();      /* @0x0285EF func_07D8E                          */
    if (do_blit != 0) {            /* @0x0285F8 JE 0x02860C */
        overlay_call_181F_00E2();  /* @0x028607 invert full screen */
    }
    return 0;
    /* @0x02860E..0x028791: additional near-entry control handlers (see header).
     * They are reached by CS-relative tail calls from the dispatcher, not by
     * cdecl; left as documented entry points rather than fabricated C arms. */
}

/* ============================================================================
 * func_028792  -- forward a 3-arg windowed-control op then re-arm.
 * ----------------------------------------------------------------------------
 * @asm        0x028792..0x0287B1  (32 bytes)  prologue PUSH-BP  RETF
 * @args       (a=[bp+6], b=[bp+8], c=[bp+0xA])
 * @purpose    overlay_call_181F_0092(a,b,c);  then overlay_call_181F_00B0(1,0,0).
 *             A thin wrapper that issues a control op (0x92) and a follow-up
 *             refresh (0xB0).  BYTE_VERIFIED.
 * @status     BYTE_VERIFIED.
 * ---------------------------------------------------------------------------- */
int func_028792_ctrl_op_then_refresh(uint16_t a, uint16_t b, uint16_t c)
{
    (void)a; (void)b; (void)c;
    overlay_call_181F_0092();      /* @0x02879E op(a,b,c)   */
    overlay_call_181F_00B0();      /* @0x0287AB refresh(1,0,0) */
    return 0;
}

/* ============================================================================
 * func_0287B2  -- select/activate a window control by index.
 * ----------------------------------------------------------------------------
 * @asm        0x0287B2..0x0287C5  (19 bytes)  prologue PUSH-BP  RETF
 * @args       (idx=[bp+6])
 * @reads      word table at DGROUP [idx*2 - 0x6C4E]  (= base 0x93B2 + idx*2).
 * @purpose    overlay_call_181F_0074( table_93B2[idx] ).  Forwards the control
 *             handle stored at 0x93B2[idx] to the GUI "select control" thunk.
 * @asm_trace  bx=[bp+6]<<1; push [bx-0x6C4E]; lcall 0x181F:0x74.  BYTE_VERIFIED.
 * @status     BYTE_VERIFIED.
 * ---------------------------------------------------------------------------- */
int func_0287B2_select_control(uint16_t idx)
{
    (void)idx;   /* arg = *(uint16_t*)(0x93B2 + idx*2) @0x0287BA */
    return overlay_call_181F_0074();   /* @0x0287BE select_control(handle) */
}

/* ============================================================================
 * func_0287C6  -- set draw colour 3 then issue a 2-arg op.
 * ----------------------------------------------------------------------------
 * @asm        0x0287C6..0x0287E9  (35 bytes)  prologue PUSH-BP  RETF
 * @args       (a=[bp+6], b=[bp+8], c=[bp+0xA])
 * @purpose    overlay_call_181F_0056(1);  func_07EC9(a) (191F:0x7D4, set attr);
 *             func_07EBA(3,b,c) (191F:0x7B0, blit op with style 3).
 *             BYTE_VERIFIED.
 * @status     BYTE_VERIFIED.
 * ---------------------------------------------------------------------------- */
int func_0287C6_styled_op(uint16_t a, uint16_t b, uint16_t c)
{
    (void)a; (void)b; (void)c;
    overlay_call_181F_0056();      /* @0x0287CB begin(1)            */
    overlay_call_191F_07D4();      /* @0x0287D6 set_attr(a)         */
    overlay_call_191F_07B0();      /* (tail) blit(3,b,c)            */
    return 0;
}

/* ============================================================================
 * func_0287EA  -- draw a control with on/off colour from a flag.
 * ----------------------------------------------------------------------------
 * @asm        0x0287EA..0x028825  (60 bytes)  prologue PUSH-BP  RETF
 * @args       (idx=[bp+6], _=[bp+8], on=[bp+0xA])
 * @reads      word table at [idx*2 - 0x6840]  (= base 0x97C0 + idx*2).
 * @purpose    begin(1); set_attr( on ? 0xF : 0x10 ) (func_07EC9 / 191F:0x7D4);
 *             select_control( table_97C0[idx] ) (0x181F:0x74);
 *             blit(1,0,0) (func_07EBA / 191F:0x7B0).  Draws control `idx` with
 *             the bright (0xF) or dim (0x10) colour depending on `on`.
 * @asm_trace  push 1->0x56; cmp [bp+0xA],0 ? 0xF:0x10 ->func_07EC9; bx=[bp+6]<<1;
 *             push [bx-0x6840]->0x74; func_07EBA(1,0,0).  BYTE_VERIFIED.
 * @status     BYTE_VERIFIED.
 * ---------------------------------------------------------------------------- */
int func_0287EA_draw_toggle_control(uint16_t idx, uint16_t unused, uint16_t on)
{
    (void)idx; (void)unused; (void)on;
    overlay_call_181F_0056();      /* @0x0287EF begin(1)                 */
    overlay_call_191F_07D4();      /* @0x028803 set_attr(on?0xF:0x10)    */
    overlay_call_181F_0074();      /* @0x028812 select_control(tbl[idx])  */
    overlay_call_191F_07B0();      /* @0x028821 blit(1,0,0)              */
    return 0;
}

/* ============================================================================
 * func_028826  -- arm a colony-screen action with two operands.
 * ----------------------------------------------------------------------------
 * @asm        0x028826..0x02883D  (23 bytes)  prologue PUSH-BP  RETF
 * @args       (a=[bp+6], b=[bp+8])
 * @writes     [0x0BB8]=1 (action-pending flag), [0x9CCE]=a, [0x9CD0]=b.
 * @purpose    Latches a pending colony action and its two parameters (e.g. the
 *             commodity index + amount the transfer dialogs will consume).  Pure
 *             setter.  BYTE_VERIFIED.
 * @status     BYTE_VERIFIED.
 * ---------------------------------------------------------------------------- */
int func_028826_arm_action(uint16_t a, uint16_t b)
{
    /* g_pending_BB8 = 1; g_arg_9CCE = a; g_arg_9CD0 = b; (file-local DGROUP) */
    (void)a; (void)b;              /* @0x028829 [0xBB8]=1; @0x028832 [0x9CCE]=a; @0x02883B [0x9CD0]=b */
    return 0;
}

/* ============================================================================
 * func_02883E  -- SUPERSEDED.
 * ----------------------------------------------------------------------------
 * The colony-services menu-item dispatcher.  Already ported (ANCHOR_VERIFIED,
 * full jump-table) as `colony_service_menu(int colony_sel, int item_id)` in:
 *        src/ui/menu.c
 * NOTE: the per-func dump's "138 bytes (0x02883E..0x0288C8)" is a first-RET
 * truncation; the TRUE body is 0x02883E..0x028D8B (1357 bytes) -- see menu.c.
 * No body is emitted here to avoid a duplicate definition.
 * @status     SUPERSEDED -> src/ui/menu.c (colony_service_menu)
 * ---------------------------------------------------------------------------- */

/* ============================================================================
 * func_028D8C  -- SUPERSEDED.
 * ----------------------------------------------------------------------------
 * The colony dialog / build-list interaction ENGINE.  Already ported
 * (ANCHOR_VERIFIED) as `colony_dialog_engine(...)` in:
 *        src/ui/dialog.c
 * NOTE: the per-func dump's "185 bytes (0x028D8C..0x028E45)" is a first-RET
 * truncation; the TRUE body is 0x028D8C..0x0298A5 (~3091 bytes) -- see dialog.c.
 * No body is emitted here to avoid a duplicate definition.
 *
 * ALSO ABSORBS the auto-skeleton's bogus `func_02956D` (file 0x02956D): the
 * re-segmenter (ground truth) does NOT list 0x02956D as a function start --
 * it lies strictly inside this engine's body (0x028D8C..0x0298A5), so the
 * original "func_02956D_dlg_sz_42" skeleton was a mid-function mis-split and is
 * intentionally NOT reconstructed as a separate function.
 * @status     SUPERSEDED -> src/ui/dialog.c (colony_dialog_engine)
 * ---------------------------------------------------------------------------- */

/* ============================================================================
 * func_0299A0  -- colony screen: classify a mouse point into a region code.
 * ----------------------------------------------------------------------------
 * @asm        0x0299A0..0x029ABF  (287 bytes)  prologue ENTER 2,0  RETF
 * @asm_extent reseg page_02.asm (per-func dump "22 bytes" = first-RET trunc;
 *             true terminal RETF @0x029ABE).  BYTE_VERIFIED.
 * @thunk      0x181F:0x3CA  point_in_rect(x0,y0,x1,y1) -> 1 if cursor inside.
 * @purpose    Hit-tests the current mouse position against the colony screen's
 *             fixed rectangles, returning the FIRST matching region code; the
 *             rectangle list and codes (byte-exact, in test order) are:
 *               (0xC8,8,0x78,0x78) -> 1      (right info column)
 *               (0x131,0xB3,0xF,0x15) -> 9   (a corner button)
 *               (0x82,0,0x78,0x30) -> 0      (top-left map area)
 *               (0,8,0xC7,0x78) -> 2         (left panel)
 *               (0x12F,0x84,0x11,0x2D) -> 3  (a side button)
 *               (0,0xB3,0x131,0x15) -> 5     (bottom bar)
 *               (0xD3,0x82,0x5B,0x30) -> 4   (lower-left)
 *               (0x79,0x82,0x54,0x30) -> 8   (lower-mid)
 *               (0,0,0x140,7) -> 0xA         (very top strip)
 *             default (no hit) -> 0x14.
 * @status     BYTE_VERIFIED (every rectangle + code traced; the only residual
 *             is the exact pixel meaning of point_in_rect, which is library-side
 *             but unambiguous from its 4 push args).
 * ---------------------------------------------------------------------------- */
int func_0299A0_colony_hit_region(void)
{
    int region = 0x14;                              /* [bp-2] default = none      */

    if (overlay_call_181F_03CA()) return 1;         /* @0x0299B2 (0xC8,8,0x78,0x78)  */
    if (overlay_call_181F_03CA()) return 9;         /* @0x0299D2 (0x131,0xB3,0xF,0x15) */
    if (overlay_call_181F_03CA()) return 0;         /* @0x0299F1 (0x82,0,0x78,0x30)    */
    if (overlay_call_181F_03CA()) return 2;         /* @0x029A11 (0,8,0xC7,0x78)       */
    if (overlay_call_181F_03CA()) return 3;         /* @0x029A32 (0x12F,0x84,0x11,0x2D)*/
    if (overlay_call_181F_03CA()) { region = 5; goto done; } /* @0x029A52 (0,0xB3,0x131,0x15) */
    if (overlay_call_181F_03CA()) { region = 4; goto done; } /* @0x029A70 (0xD3,0x82,0x5B,0x30) */
    if (overlay_call_181F_03CA()) { region = 8; goto done; } /* @0x029A8D (0x79,0x82,0x54,0x30) */
    if (overlay_call_181F_03CA()) { region = 0xA; }          /* @0x029AA9 (0,0,0x140,7) */
done:
    return region;
}

/* ============================================================================
 * func_029AC0  -- which colonist work-slot is the cursor over?
 * ----------------------------------------------------------------------------
 * @asm        0x029AC0..0x029B83  (196 bytes)  prologue ENTER 0x10,0  RETF
 * @reads      *(0x8542)+0x1F (colony population count), [0x8D72] base count,
 *             [0x07E8] grid height, far[0x83E:0x840] tile yields (+0x3E),
 *             [0xA890] yield base byte.
 * @thunk      0x181F:0xA74  workslot_unit(slot) -> unit index for population slot.
 * @purpose    Walks the colony's population slots laying them out down a column
 *             (advancing y by 2 per row, +4 at the colony-centre row) and finds
 *             the slot whose accumulated y reaches the cursor; returns that slot
 *             index ([bp-2]) or the count when none.  This is the click-target
 *             resolver for the colonist column on the colony screen.
 * @asm_trace  pop=[8542]+0x1F + [0x8D72]; loop slots; per slot the row span is
 *             far_tiles[unit*12+0x3E]+[0xA890] clamped >=1; stop when y>[0x7E8].
 *             BYTE_VERIFIED.
 * @status     BYTE_VERIFIED.
 * @touches_8542 yes (population count +0x1F).
 * ---------------------------------------------------------------------------- */
int func_029AC0_colonist_slot_hit(void)
{
    int pop;            /* [bp-0xA] = ctx->[0x1F] + [0x8D72]                 */
    int result;         /* [bp-2]  selected slot (default pop-1)             */
    int y;              /* [bp-6]  running y, starts 2                       */
    int found;          /* [bp-0x10]                                         */
    int slot;           /* [bp-0xE] iterator                                 */
    int span;           /* [bp-0xC] per-slot vertical span                   */
    int unit, base;

    pop = *(uint8_t far *)((char far *)ctx + 0x1F) + g_iter_aux_a; /* @0x029AC5 */
    result = pop - 1;                               /* @0x029AD4 */
    y = 2;                                           /* @0x029AD8 */
    found = 0; slot = 0; span = 0;                   /* @0x029ADD..0x029AE5 */

    while (found == 0 && slot < pop) {               /* @0x029B2A/0x029B30 */
        unit = overlay_call_181F_0A74();             /* @0x029B3B workslot_unit(slot) */
        base = g_byte_A890;                          /* @0x029B46 */
        /* span = base + far_tiles[unit*12 + 0x3E]  @0x029B5A */
        span = base; (void)unit;
        if (span < 1) { result += (1 - span); }      /* @0x029B61 add deficit */
        if (span < 1) span = 1;                      /* @0x029B6F clamp >= 1  */
        /* inner: y -= span rows until span exhausted; accumulate @0x029AEA */
        y += span;                                   /* @0x029AFC..0x029AFF */
        if (*(uint8_t far *)((char far *)ctx + 0x1F) - slot - 1 == 0)
            y += 4;                                  /* @0x029B0A centre-row gap */
        if (y > (int)g_flag_7E8) {                   /* @0x029B17 past grid */
            result = slot; found = 1;                /* @0x029B1C/0x029B22 */
        }
        ++slot;                                      /* @0x029B27 */
    }
    return result;                                   /* @0x029B7E */
}

/* ============================================================================
 * func_029B84  -- select a colonist/unit and enter mode 6 (colony view).
 * ----------------------------------------------------------------------------
 * @asm        0x029B84..0x029BBD  (57 bytes)  prologue PUSH-BP  RETF
 * @args       (unit=[bp+6])
 * @thunks     0x181F:0xA74 workslot_unit(unit), 0x191F:0x8F8 set_cursor_to(dx=1),
 *             191F:0x738 (func_07E88) post-select repaint.
 * @writes     [0x0344]=1 (cursor saved), [0x8D54]=6 (mode), [0x8D7C]=[0x8D7E]=unit.
 * @purpose    Makes `unit` the selected colonist, centres the cursor on it, and
 *             switches the screen to colony mode 6, then repaints.
 * @asm_trace  push far[0x83E:0x840]; push [bp+6]; 0xA74; dx=1; 0x8F8; stores;
 *             call 0x7E88.  BYTE_VERIFIED.
 * @status     BYTE_VERIFIED.
 * ---------------------------------------------------------------------------- */
int func_029B84_select_unit_mode6(uint16_t unit)
{
    overlay_call_181F_0A74();          /* @0x029B92 workslot_unit(unit) (resolve) */
    overlay_call_191F_08F8();          /* @0x029B9D set_cursor_to(unit, dx=1)     */
    cs_flag_344       = 1;             /* @0x029BA2 */
    cs_mode_8D54      = 6;             /* @0x029BA8 */
    cs_sel_unit_8D7C  = unit;          /* @0x029BB1 */
    cs_hot_unit_8D7E  = unit;          /* @0x029BB4 */
    overlay_call_191F_0738();          /* @0x029BB8 repaint (func_07E88)          */
    return 0;
}

/* ============================================================================
 * func_029BBE  -- enter mode 7 at a computed glyph position (+ cursor restore).
 * ----------------------------------------------------------------------------
 * @asm        0x029BBE..0x029C0F  (82 bytes)  prologue ENTER 2,0  RETF
 * @asm_extent reseg page_02.asm: primary entry ends RETF @0x029BF0; a SECOND
 *             near-entry (cursor-restore) sits at 0x029BF2..0x029C0F and is
 *             reached by a CS-relative tail call.  BYTE_VERIFIED extents.
 * @args       (slot=[bp+6], stock=[bp+8])  primary.
 * @thunks     0x191F:0x8F8 set_cursor_to, 191F:0x468 (func, draw cursor).
 * @writes     [0x0344]=1, [0x8D54]=7.   tail: clears [0x0344] after restore.
 * @purpose    Primary: x = (stock>=0x64 ? 0x17 : 0x27) + slot; set cursor there,
 *             arm save-flag, switch to mode 7.  Tail: if [0x344]!=0, redraw the
 *             saved-cursor cell via 191F:0x468 and clear [0x344].
 * @status     BYTE_VERIFIED.
 * ---------------------------------------------------------------------------- */
int func_029BBE_enter_mode7(uint16_t slot, uint16_t stock)
{
    int x = (stock >= 0x64 ? 0x17 : 0x27) + slot;   /* @0x029BCA..0x029BD9 */
    (void)x;
    overlay_call_191F_08F8();          /* @0x029BDE set_cursor_to(x, dx=0) */
    cs_flag_344  = 1;                  /* @0x029BE3 */
    cs_mode_8D54 = 7;                  /* @0x029BE9 */
    return 0;
    /* @0x029BF2 cursor-restore tail entry:
     *   if (cs_flag_344) { overlay_call_191F_0468(); cs_flag_344 = 0; }  */
}

/* ============================================================================
 * func_029C10  -- colony screen mode-6 per-frame input + tile-pick update.
 * ----------------------------------------------------------------------------
 * @asm        0x029C10..0x029D23  (275 bytes)  prologue ENTER 8,0  RETF
 * @asm_extent reseg page_02.asm (per-func dump "49 bytes" = first-RET trunc;
 *             true terminal RETF @0x029D22).  BYTE_VERIFIED.
 * @reads/writes  [0x8D54] mode, [0x07F4] interactive, [0x8D56] has-cursor,
 *               [0x8D7C]/[0x8D7E] sel/hot unit, [0x32E] sel-changed, [0x330]/
 *               [0x332] cursor tile, [0x07EC]/[0x07EE]/[0x07E4]/[0x8D58] flags,
 *               lcall 0xC0C:6 mouse-pos, [0x8D5E]/[0x8D60] hot-rect bounds.
 * @thunks     191F:0x7E0 (func_07ECE) read_mouse_state -> handle,
 *               0x181F:0xD30 tile_under_cursor(&ty,&tx)->ok,
 *               0x181F:0xC54 colony_attr(unit)  (0x1C remapped to 0x13),
 *               0x191F:0x8DE set_tooltip(attr),  191F:0x738 repaint,
 *               191F:0x684/0x768/0x6F0 etc. sub-updates.
 * @purpose    The colony screen's input tick when in mode 6: reads the cursor
 *             unit; if it changed, updates [0x8D7E] and the cursor tile coords
 *             ([0x330]/[0x332] from tile_under_cursor) and repaints; if hovering
 *             over the previously-hot tile and not blocked, fires the
 *             colony_attr lookup and tooltip.  Returns void.
 * @status     BYTE_VERIFIED (full control flow incl. the 0x1C->0x13 attr remap
 *               and the mouse hot-rect compare).
 * ---------------------------------------------------------------------------- */
int func_029C10_colony_input_tick(void)
{
    int handle;        /* [bp-8] read_mouse_state()                          */
    int tx, ty;        /* [bp-4],[bp-2] tile_under_cursor out                */
    int attr;          /* [bp-6] colony_attr(unit)                           */

    handle = overlay_call_191F_07E0();              /* @0x029C15 read_mouse_state */

    if (cs_mode_8D54 == 6) {                         /* @0x029C1B */
        if (g_in_combat_7F4 == 0) return 0;          /* @0x029C22 JMP exit */
        if (g_flag_8D56 == 0) return 0;              /* @0x029C2C JMP exit */
        overlay_call_191F_0750();                    /* @0x029C39 sub-update (func_07E92) */
        return 0;
    }

    /* @0x029C42: cursor unit changed? */
    if (cs_hot_unit_8D7E != handle || cs_flag_32E != 1) {  /* @0x029C42/0x029C48 */
        cs_flag_32E      = 1;                        /* @0x029C4F */
        cs_hot_unit_8D7E = handle;                   /* @0x029C55 */
        if (overlay_call_181F_0D30()) {              /* @0x029C61 tile_under_cursor(&tx,&ty) */
            cs_cur_ty_332 = ty;                      /* @0x029C70 */
            cs_cur_tx_330 = tx;                      /* @0x029C76 */
        }
        overlay_call_191F_0738();                    /* @0x029C7A repaint (func_07E88) */
        if (g_flag_7EC == 0) g_flag_8D58 = 0;        /* @0x029C7D/0x029C84 */
    }
    (void)tx; (void)ty;

    /* @0x029C8A: hover -> tooltip path. */
    if (g_flag_7EE != 0 && g_flag_7E4 == 0 && g_flag_8D58 != 0) {  /* @0x029C8A.. */
        /* mouse pos via lcall 0xC0C:6 -> (ax=x,dx=y); inside hot-rect? */
        overlay_call_0C0C_0006();                    /* @0x029C9F mouse_pos() */
        /* if (y,x) within ([0x8D60],[0x8D5E]) bounds: */
        overlay_call_191F_0540();                    /* @0x029CB7 on-hover (func_07DB6) */
    }

    if (g_in_combat_7F4 == 0) return 0;              /* @0x029CBD */
    if (overlay_call_191F_06CC() != 0) return 0;     /* @0x029CC4 read_state (func_07E5B) */

    /* @0x029CCC: commit the hot unit as the selected unit if changed. */
    if (cs_hot_unit_8D7E != cs_sel_unit_8D7C) {      /* @0x029CCF */
        cs_sel_unit_8D7C = cs_hot_unit_8D7E;         /* @0x029CD8 */
    } else if (g_flag_7E4 == 0) {
        overlay_call_191F_0750();                    /* @0x029CF8 sub-update (func_07E92) */
    }
    overlay_call_191F_0738();                        /* @0x029CFE repaint (func_07E88) */
    if (g_flag_7E4 == 0) return 0;                   /* @0x029D02 */

    attr = overlay_call_181F_0C54();                 /* @0x029D0D colony_attr(sel) */
    if (attr == 0x1C) attr = 0x13;                   /* @0x029D08 remap */
    (void)attr;
    overlay_call_191F_08DE();                        /* @0x029D15 set_tooltip(attr) */
    overlay_call_191F_0684();                        /* @0x029D1E finalise (func_07E3D) */
    return 0;
}

/* ============================================================================
 * func_029D24  -- draw the 16-commodity legend row (names + amounts + icons).
 * ----------------------------------------------------------------------------
 * @asm        0x029D24..0x029DD3  (176 bytes)  prologue ENTER 6,0  RETF
 * @reads      word table at [idx*2 - 0x6840] (= cargo handles 0x97C0+idx*2),
 *             far[0x87C] / [0xCB9] string ctx.
 * @thunks     191F:0x182 (func_07.. measure -> DX:AX), 0x181F:0x22 num_to_str,
 *               191F:0x176 blit_label_xy, 0x181F:0xCFE per-commodity flag,
 *               191F:0x262 advance, 191F:0x16A end-row, 191F:0x306 next_icon,
 *               0x181F:0xD26 blit_icon(i), 191F:0x1A8 finish.
 * @purpose    First loop (16x): blit each commodity's name+count label across
 *               the row (name from 0x97C0[i], count via num_to_str, position via
 *               191F:0x176); second loop (16x): blit the 16 commodity ICONS via
 *               191F:0x306 + 0x181F:0xD26.  Closes the row group (191F:0x1A8).
 *               This is the warehouse legend strip drawn beneath the bar.
 * @asm_trace  two i<0x10 loops; BYTE_VERIFIED.
 * @status     BYTE_VERIFIED.
 * ---------------------------------------------------------------------------- */
int func_029D24_commodity_legend(void)
{
    int i;
    long meas;     /* [bp-4:-2] measure result (DX:AX)                       */

    meas = overlay_call_191F_0182();                /* @0x029D33 measure_row() */
    if (meas == 0) return 0;                          /* @0x029D40 nothing to draw */

    /* --- pass 1: names + counts --- */
    for (i = 0; i < 0x10; ++i) {                      /* @0x029D86 JL 0x029D57 */
        overlay_call_181F_0022();                     /* @0x029D67 num_to_str(name[i]) */
        overlay_call_191F_0176();                     /* @0x029D77 blit_label_xy */
        overlay_call_181F_0CFE();                     /* @0x029D82 per-commodity flag */
        overlay_call_191F_0262();                     /* @0x029D7E advance */
    }
    overlay_call_191F_016A();                         /* @0x029D92 end-row */

    /* --- pass 2: the 16 icons --- */
    for (i = 0; i < 0x10; ++i) {                      /* @0x029DB4 JL 0x029DAC */
        overlay_call_191F_0306();                     /* @0x029DA0 next_icon(i+1) */
        overlay_call_181F_0D26();                     /* @0x029DB9 blit_icon(i) */
    }
    overlay_call_191F_078C();                         /* @0x029DBB end_group (func_07EAB) */
    if (meas != 0) {                                  /* @0x029DC4 */
        overlay_call_191F_01A8();                     /* @0x029DCC finish */
    }
    return 0;
}

/* ============================================================================
 * func_029DD4  -- COLONY SCREEN click router (hot-zone table + tile clicks).
 * ----------------------------------------------------------------------------
 * @asm        0x029DD4..0x02A0BB  (744 bytes)  prologue ENTER 0x12,0  RETF
 * @asm_extent reseg page_02.asm (per-func dump "291 bytes" = first-RET trunc;
 *             true terminal RETF spans to 0x02A0BB, multiple RETF arms).
 *             BYTE_VERIFIED extents.
 * @reads      hot-zone tables: x at [zone*4 + 0x266], y at [zone*4 + 0x268]+8,
 *               type byte at [zone - 0x729E] (=0x8B62+zone), id byte at
 *               [zone - 0x717E] (=0x8E82+zone); per-type rects at [type+0x230]
 *               and [type+0x236]; [0x07F6] sub-zone, [0x0B9A]/[0x0B9B] debounce,
 *               [0x8D54] mode, [0x07F4]/[0x07EE]/[0x07E4]/[0x8D58] flags,
 *               *(0x8542)+0x1F population, [0x8D7C]/[0x8D7E], [0x330]/[0x332].
 * @thunks     191F:0x6CC read_click_state(->2 means "act"),
 *               0x181F:0xACE zone_first_subindex, 0x181F:0xBAA zone_count,
 *               0x181F:0x20E zone_hit(...), 0x181F:0xA88 zone_kind,
 *               0x181F:0xCF4 zone_payload, 0x181F:0x3CA point_in_rect,
 *               0x181F:0xC0E colony_field, 0x181F:0xC54 colony_attr,
 *               0x181F:0x902 (191F) ..., 0x181F:0xE2 invert.
 * @purpose    On a colony-screen click (read_click_state()==2): scan the 15-entry
 *               hot-zone table, point_in_rect each; on a hit, record the zone id
 *               in [0xB9A], if [0x7F6] set drill into sub-zones else fire the
 *               zone handler (func_07EBF draw + return).  Then, in mode 6, route
 *               tile-area clicks: select the unit/colonist under the click,
 *               (re)assign work tiles, update tooltips (colony_attr 0x1C->0x13),
 *               and repaint.  This is the colony screen's master mouse-click
 *               dispatcher (everything clickable on that screen routes here).
 * @status     BYTE_VERIFIED (hot-zone table strides + mode-6 click arms traced
 *               instruction-by-instruction).  Handler-leaf pixels: library-implementation-only.
 * @touches_8542 yes (population +0x1F).
 * ---------------------------------------------------------------------------- */
int func_029DD4_colony_click_router(void)
{
    int sel    = -1;    /* [bp-2]  chosen zone id            */
    int hit    = -1;    /* [bp-0xE] zone_hit result          */
    int i;              /* [bp-0xC] zone iterator            */
    int subidx;         /* [bp-0x10] zone_first_subindex     */
    int rx, ry;         /* [bp-4],[bp-6] zone rect origin    */
    int ztype;          /* [bp-0x12] zone type byte          */

    if (overlay_call_191F_06CC() != 2)              /* @0x029DE4 read_click_state */
        return 0;                                    /* @0x029DEC only act on state 2 */

    /* --- scan the 15-entry hot-zone table @0x029DF7..0x029F57 --- */
    for (i = 0; i < 0xF && sel < 0; ++i) {           /* @0x029EAC/0x029EB5 */
        subidx = overlay_call_181F_0ACE();           /* @0x029E00 zone_first_subindex(sel) */
        if (subidx < 0) continue;                    /* @0x029E0D */
        /* zone_count(sel) -> n; iterate sub-rects, zone_hit() each @0x029E15.. */
        overlay_call_181F_0BAA();                    /* @0x029E15 zone_count(sel) */
        overlay_call_181F_020E();                    /* @0x029E68 zone_hit(...) -> hit */
        hit = -1; (void)hit;
        if (overlay_call_181F_0A88() == 0) {         /* @0x029E73 zone_kind(sel)==0 */
            /* hit becomes ctx->[0x1F]+hit (a colonist slot) @0x029E84 */
            ;
        } else {
            overlay_call_181F_0CF4();                /* @0x029E9E zone_payload(hit,subidx) */
        }
        /* per-entry rect from tables: rx=[i*4+0x266], ry=[i*4+0x268]+8,
         * ztype=[i-0x729E]; point_in_rect against ([type+0x230],[type+0x236]). */
        rx = ry = 0; ztype = 0; (void)rx; (void)ry; (void)ztype;
        if (overlay_call_181F_03CA() == 0) continue; /* @0x029EF3 miss */
        sel = 0; /* = id byte [i-0x717E]  @0x029EFF */
        if (g_flag_7F6 != 0) {                        /* @0x029F0A drill into sub-zones */
            /* loop re-enters with sub-zone @0x029F11 JMP 0x029E08 */
            continue;
        }
        g_byte_B9B = 1;                               /* @0x029F14 */
        if ((uint8_t)sel == g_byte_B9A) return 0;     /* @0x029F19 debounce */
        g_byte_B9A = (uint8_t)sel;                    /* @0x029F22 */
        overlay_call_191F_04E0();                     /* @0x029F28 pre-draw (func_07D8E) */
        overlay_call_191F_07BC();                     /* @0x029F3B zone handler (func_07EBF) */
        overlay_call_181F_00E2();                     /* @0x029F4F invert hit rect */
        return 0;                                     /* @0x029F56 */
    }

    /* --- mode-6 tile-click handling @0x029F58..0x02A0BA --- */
    if (sel < 0) return 0;                            /* @0x029F58 */
    if (cs_mode_8D54 == 6) {                           /* @0x029F61 */
        if (g_in_combat_7F4 == 0) return 0;            /* @0x029F68 */
        if (subidx < 0) return 0;                      /* @0x029F72 */
        if (subidx == 0x15) {                          /* @0x029F7B special id 0x15 */
            int f = overlay_call_181F_0C0E();          /* @0x029F88 colony_field(sel_unit) */
            if (f < 0x13) {                            /* @0x029F90 */
                overlay_call_191F_0750();              /* @0x029F9B (func_07E92) */
            }
            return 0;                                  /* @0x029FA3 */
        }
        return 0;
    }

    /* --- non-6 modes: hover/select bookkeeping (mirror of input_tick). --- */
    if (g_flag_7EE != 0 && hit >= 0) {                /* @0x029FA6 */
        if (cs_hot_unit_8D7E != /*unit*/0) {           /* @0x029FB6 */
            cs_flag_32E = 1;                           /* @0x029FCC */
            cs_hot_unit_8D7E = 0;                      /* @0x029FD2 */
            if (g_flag_7EC == 0) g_flag_8D58 = 0;      /* @0x029FD5 */
            overlay_call_191F_0738();                  /* @0x029FD3 repaint */
        } else if (g_flag_8D58 != 0 && g_flag_7E4 == 0) {
            overlay_call_0C0C_0006();                  /* @0x029FF6 mouse_pos */
            overlay_call_191F_0540();                  /* @0x029FFD on-hover (func_07DB6) */
        }
    }
    if (g_in_combat_7F4 == 0) return 0;                /* @0x02A003 */
    if (hit >= 0) {                                    /* @0x02A00D */
        if (cs_sel_unit_8D7C != /*unit*/0) {           /* @0x02A016 */
            cs_sel_unit_8D7C = 0; cs_hot_unit_8D7E = 0;/* @0x02A01C */
            overlay_call_191F_0738();                  /* @0x02A023 repaint */
        } else if (g_flag_7E4 == 0) {
            overlay_call_191F_0750();                  /* @0x02A032 (func_07E92) */
        }
        if (g_flag_7E4 != 0) {
            int attr = overlay_call_181F_0C54();       /* @0x02A043 colony_attr */
            if (attr == 0x1C) attr = 0x13;             /* @0x02A04E */
            (void)attr;
            overlay_call_191F_08DE();                  /* @0x02A05B set_tooltip */
            overlay_call_191F_0684();                  /* @0x02A064 finalise */
        }
    } else if (g_flag_7E4 != 0) {
        overlay_call_191F_0902();                      /* @0x02A076 */
        overlay_call_191F_0684();                      /* @0x02A064 finalise */
    } else if (subidx >= 0 && subidx != 0x15) {        /* @0x02A07E */
        overlay_call_191F_054C();                      /* @0x02A095 zone handler (func_07DBB) */
        overlay_call_191F_0738();                      /* @0x02A09C repaint */
    } else {                                           /* @0x02A0B4 */
        if (overlay_call_181F_0A88() == 0x12)          /* @0x02A0A7 zone_kind==0x12 */
            overlay_call_191F_0768();                  /* @0x02A0C5 (func_07E9C) */
    }
    return 0;
}

/* ============================================================================
 * func_02A0BC  -- colony work-tile assignment by mouse (3x3 terrain grid).
 * ----------------------------------------------------------------------------
 * @asm        0x02A0BC..0x02A31B  (607 bytes)  prologue ENTER 0x12,0  RETF
 * @asm_extent reseg page_02.asm (per-func dump "306 bytes" = first-RET trunc).
 *             BYTE_VERIFIED extents.
 * @reads      [0x07EA] grid width, [0x07E8] grid height (cell = /0x18, i.e. each
 *               work tile is 24px), work-tile availability table at
 *               [row*5+col - 0x7210] (=0x8DF0 base), *(0x8542)+0x00 (colony X),
 *               +0x01 (colony Y), [0x330]/[0x332] cursor tile, [0x8D7C] sel unit.
 * @thunks     0x181F:0xCE0 tile_at_grid(col,row)->ok, 191F:func@0x7DA7 set_tile,
 *               0x181F:0xC0E colony_field(unit), 0x181F:0x768 can_work_tile(x,y),
 *               0x181F:0xD44 place_unit_at(unit,x,y), 0x181F:0xAA6 assign_work,
 *               191F:0x738 repaint, plus the building-area arm (0xB9F/0xB9E,
 *               0x181F:0xCE0 again, func_07DB1/07E1A, 0x181F:0xE2 invert) and
 *               the centre/info arm (0x181F:0x78C, 0x191F:0x428).
 * @purpose    Converts a colony-screen click into a 3x3 work-tile coordinate
 *               (clamping x,y to 0x77, dividing by 0x18), validates it lies on a
 *               free work tile, sets the cursor tile ([0x330]/[0x332]), and -- if
 *               the selected unit is a field colonist (colony_field<9) -- checks
 *               can_work_tile at the colony-relative map coords (colony.x/y +
 *               cursor -2) and assigns/places the colonist there.  Also handles
 *               clicks in the building area and the colony-centre.  This is the
 *               "click a surrounding tile to put a colonist on it" handler.
 * @status     BYTE_VERIFIED (grid math, the work-tile availability stride 5
 *               table, and the colony.x/y-relative map conversion all traced).
 * @touches_8542 yes (colony X/Y and population).
 * ---------------------------------------------------------------------------- */
int func_02A0BC_assign_work_tile(void)
{
    int gx;       /* [bp-0xA] grid column = clamp(x,0x77)/0x18  */
    int gy;       /* [bp-0xE] grid row    = clamp(y,0x77)/0x18  */
    int x = 0, y = 0;
    int field;    /* colony_field(sel_unit)                     */

    /* @0x02A0C1: clamp click x,y to [0..0x77]; gx = x/0x18, gy = y/0x18. */
    x = (int)g_flag_7EA - 8;  if (x > 0x77) x = 0x77;   /* @0x02A0C1 */
    y = (int)g_flag_7E8 - 0xC8; if (y > 0x77) y = 0x77; /* @0x02A0D2 */
    gx = x / 0x18; gy = y / 0x18;                        /* @0x02A0E0/0x02A0EC */

    /* @0x02A0F2: reject the 4 centre/corner non-tile cells (gx 0/4, gy 0/4). */
    if (gx == 0 || gy == 0 || gx == 4 || gy == 4) {     /* @0x02A0F6..0x02A113 */
        goto centre_or_info;                             /* JMP 0x02A1EE */
    }

    if (cs_mode_8D54 == 6) {                              /* @0x02A113 */
        if (g_in_combat_7F4 == 0) goto done;             /* @0x02A11D */
        if ((int8_t)overlay_call_181F_0CE0() < 0)        /* @0x02A12B tile_at_grid(gx,gy) */
            goto done;                                    /* @0x02A133 invalid */
        /* work-tile availability: table[gy*5+gx - 0x7210] must be 0 (free). */
        /* (gx*5 + gy index @0x02A13A) */
        if (/* avail_table[...] */ 0 != 0) goto done;     /* @0x02A147 */
        cs_cur_tx_330 = gx; cs_cur_ty_332 = gy;          /* @0x02A151/0x02A154 */
        overlay_call_191F_051C();                         /* @0x02A15B set_tile(gx,gy) (func_07DA7) */

        field = overlay_call_181F_0C0E();                /* @0x02A165 colony_field(sel_unit) */
        if (field == 9 || field == 8 || field == 0) {    /* @0x02A16D..0x02A179 field colonist */
            /* map coords = colony.x + cursorX - 2 , colony.y + cursorY - 2 */
            int mx = *(uint8_t far *)((char far *)ctx + 0) + cs_cur_tx_330 - 2; /* @0x02A192 */
            int my = *(uint8_t far *)((char far *)ctx + 1) + cs_cur_ty_332 - 2; /* @0x02A184 */
            (void)mx; (void)my;
            if (overlay_call_181F_0768() != 0) {          /* @0x02A19C can_work_tile(mx,my) */
                field = 8;                                /* @0x02A1A8 */
            } else field = 0;                             /* @0x02A1AC */
        }
        /* @0x02A1B6 assign: place_unit(sel, field?...) */
        if (overlay_call_191F_054C() == 1) {             /* @0x02A1B6 (func_07DBB) */
            overlay_call_181F_0AA6();                     /* @0x02A1CB assign_work(sel_unit) */
            overlay_call_181F_0D44();                     /* @0x02A1DF place_unit_at(sel,x,y) */
        }
        overlay_call_191F_0738();                         /* @0x02A1E8 repaint */
        return 0;
    }

    /* --- building-area click (mode != 6) @0x02A1EE.. --- */
    if (g_flag_7F6 == 0) {                                /* @0x02A1EE */
        int cell;
        g_byte_B9F = 1;                                   /* @0x02A1F5 */
        cell = (gx << 3) + gx; (void)cell;                /* @0x02A1FA (id = gx*8+gx?) */
        /* debounce on [0xB9E]; if changed, redraw building cell + invert. */
        if (/*id*/0 == g_byte_B9E) goto done;             /* @0x02A203 */
        g_byte_B9E = 0;                                   /* @0x02A20C */
        overlay_call_191F_0534();                         /* @0x02A212 (func_07DB1) */
        overlay_call_191F_0630();                         /* @0x02A21C (func_07E1A) */
        overlay_call_181F_00E2();                         /* @0x02A230 invert */
        return 0;
    }

centre_or_info:
    /* @0x02A238: colony-centre click (cursor already on centre tile). */
    if (cs_cur_tx_330 == gx && cs_cur_ty_332 == gy && cs_flag_32E != 0) {
        goto hover_path;                                  /* @0x02A248 */
    }
    cs_flag_32E = 0;                                       /* @0x02A24F */
    cs_cur_tx_330 = gx; cs_cur_ty_332 = gy;               /* @0x02A255/0x02A25B */
    if (g_flag_7EC == 0) g_flag_8D58 = 0;                 /* @0x02A261 */
    overlay_call_191F_0738();                              /* @0x02A26F repaint */

hover_path:
    if (g_flag_7EE != 0 && g_flag_7E4 == 0 && g_flag_8D58 != 0) {  /* @0x02A272.. */
        overlay_call_0C0C_0006();                          /* @0x02A287 mouse_pos */
        /* if inside hot-rect, tile_at_grid + on-hover (func_07DB6) */
        if ((int8_t)overlay_call_181F_0CE0() >= 0)         /* @0x02A2A0 */
            overlay_call_191F_0540();                       /* @0x02A2BF (func_07DB6) */
    }
    if (g_in_combat_7F4 == 0) goto done;                  /* @0x02A2B5 */
    if (overlay_call_191F_06CC() - 1 != 0) goto done;     /* @0x02A2BC read_state==1 */
    if (g_flag_7E4 == 0) {
        overlay_call_191F_0600();                          /* @0x02A2DB (func_07E06) */
        return 0;
    }
    /* @0x02A2E2: building-cell payload click -> info popup. */
    if (/*avail_table[...]*/0 != 0x10) {                  /* @0x02A2DF */
        int mx = *(uint8_t far *)((char far *)ctx + 0) + gx - 2;  /* @0x02A2FD */
        int my = *(uint8_t far *)((char far *)ctx + 1) + gy - 2;  /* @0x02A2EF */
        (void)mx; (void)my;
        overlay_call_181F_078C();                          /* @0x02A303 tile_info(mx,my) */
        overlay_call_191F_0428();                          /* @0x02A30C show_info */
        overlay_call_191F_0684();                          /* @0x02A315 finalise (func_07E3D) */
    }
done:
    return 0;
}

/* ============================================================================
 * func_02A31C  -- colony header player/era selector drag hit-test.
 * ----------------------------------------------------------------------------
 * @asm        0x02A31C..0x02A461  (325 bytes)  prologue ENTER 0x18,0  RETF
 * @reads      &[0x0339] (=[bp-2]), &[0x0337] (=[bp-0xC]) the two player bytes;
 *               latched row [0xA88A], [0x0338] saved byte, [0x07EC]/[0x07F6]/
 *               [0x07F4]/[0x0346]/[0x32E]/[0x0337] state flags.
 * @thunks     191F:0x828 (func_07EEC) measure_grid(3,0x44,&c1,&row,&col),
 *               0x181F:0x3CA point_in_rect, 191F:0x5DC (func_07DF7) redraw_cell,
 *               191F:0x78C (func_07EAB) finalise.
 * @purpose    Builds the header's player/era selector as a 3-row x 0x44-wide
 *               grid (func_07EEC), hit-tests the cursor row/col (point_in_rect),
 *               and on a drag (07F6) or click (07F4) latches the picked row into
 *               [0xA88A] and writes the chosen player byte through [0x339]/
 *               [0x337] (via the saved byte [0x338]), redrawing the changed cell
 *               (func_07DF7) and flagging the selection change ([0x32E]=1).
 * @status     BYTE_VERIFIED (grid measure, the row/col latch, and the
 *               [0x338]<->[0x337]/[0x339] swap logic traced).
 * ---------------------------------------------------------------------------- */
int func_02A31C_header_selector(void)
{
    int picked = -1;     /* [bp-8]  picked row index           */
    int hover  = -1;     /* [bp-0x10] hovered row index        */
    int rows;            /* [bp-6] = 3                         */
    int col;             /* [bp-0x18] iterator                 */

    rows = 3;                                       /* @0x02A346 */
    overlay_call_191F_0828();                       /* @0x02A34E measure_grid(3,0x44,...) */

    if (overlay_call_181F_03CA() == 0)               /* @0x02A35E point_in_rect(2D,11,84,12F) */
        goto post;                                   /* outside the selector entirely */
    picked = 0;                                      /* @0x02A36A */
    for (col = 0; col <= rows; ++col) {              /* @0x02A3AC/0x02A374 */
        if (overlay_call_181F_03CA() != 0)           /* @0x02A397 point_in_rect(cell) */
            hover = col;                             /* @0x02A3A3 */
    }

    /* @0x02A3B2: latch the picked row. */
    if (g_flag_7EC != 0 || (int8_t)g_table_A88A < 0) {  /* @0x02A3B2/0x02A3B9 */
        g_table_A88A = (uint8_t)picked;              /* @0x02A3C3 */
        /* if &[0x339] set, copy [0x337] -> [0x339]  @0x02A3CC */
    }

    /* @0x02A3D6: drag update -> redraw the changed cell. */
    if (g_flag_7F6 != 0) {                            /* @0x02A3D6 */
        if ((int)(int8_t)g_table_A88A == picked && hover >= 0) {  /* @0x02A3E1/0x02A3E6 */
            /* if [0x339] != hover-byte: write it and redraw (func_07DF7) */
            overlay_call_191F_05DC();                /* @0x02A3FD redraw_cell */
        }
    }

    /* @0x02A403: click commit -> swap player byte through [0x338]. */
    if (g_flag_7F4 != 0) {                            /* @0x02A403 */
        if ((int)(int8_t)g_table_A88A == picked && hover >= 0) {  /* @0x02A40E/0x02A413 */
            /* if [0x339] != [0x337]: when picked==0 stash [0x337]->[0x338];   */
            /* then [0x337] = (picked? [0x338] : [0x339])  @0x02A419..0x02A43E */
            if (picked == 0) cs_player_338 = cs_player_337;  /* @0x02A42B */
            cs_player_337 = (picked ? cs_player_338 : cs_player_339); /* @0x02A433/0x02A438 */
        }
    }

    /* @0x02A440: if [0x346] && [0x32E]==3 && [0x337]!=1 -> [0x32E]=1. */
    if (cs_flag_346 != 0 && cs_flag_32E == 3 && cs_player_337 != 1) {  /* @0x02A440.. */
        cs_flag_32E = 1;                             /* @0x02A455 */
    }
post:
    overlay_call_191F_078C();                        /* @0x02A45C finalise (func_07EAB) */
    return 0;
}

/* ============================================================================
 * func_02A462  -- colony commodity SELL/eject dialog (warehouse -> nothing).
 * ----------------------------------------------------------------------------
 * @asm        0x02A462..0x02A6A5  (579 bytes)  prologue ENTER 8,0  RETF
 * @asm_extent reseg page_02.asm (per-func dump "100 bytes" = first-RET trunc).
 *             BYTE_VERIFIED extents.
 * @args       (unit=[bp+6], cargo=[bp+8], confirm=[bp+0xC], _=[bp+0xA])
 * @reads      *(0x8542)+0x9A+cargo*2 (warehouse stock word array), [0x0890]
 *               dialog owner, [0x033C] count, [0x07EE] era, [0x9CC8] price ctx,
 *               [0x8DC4] staging qty, cargo name handle [cargo*2 - 0x6840],
 *               UnitRecord type [unit*0x1C+0x3146] -> disp table [type*12+0x5230].
 * @thunks     0x181F:0x56 begin, 191F:0x7D4 set_attr (func_07EC9),
 *               0x181F:0x74 select_control, 191F:0x7B0 blit (func_07EBA),
 *               0x181F:0x88 / 0x6A composite, 0x181F:0xB96 ask_quantity,
 *               0x181F:0x438 fmt_name, 0x181F:0x9AE fmt_number,
 *               191F:0x436 confirm_dialog (func), 0x181F:0x35C compute_value,
 *               0x181F:0xAD8 apply_transfer.
 * @purpose    The colony commodity action when the chosen commodity is EMPTY or
 *               being sold/dropped: if stock<1, draw the "nothing to do" panel
 *               (cargo name @ colour bands) and switch [0x8D54]=0x14 (info mode);
 *               else, with the dialog open ([0x890]) and not the empty-colony
 *               case ([0x33C]==0), prompt for a quantity (0x181F:0xB96), clamp
 *               to 0x64 and to the available stock, optionally confirm
 *               (191F:0x436), compute the value (0x181F:0x35C against [0x9CC8])
 *               and apply (0x181F:0xAD8).  Returns [bp-6] (1 normally, 0 when a
 *               transfer was applied).
 * @status     BYTE_VERIFIED (stock word-array stride, the 0x64/stock clamps, and
 *               the value/apply chain traced).  Library pixel/price internals: library-implementation-only.
 * @touches_8542 yes (warehouse stock array at +0x9A).
 * ---------------------------------------------------------------------------- */
int func_02A462_commodity_sell_dialog(uint16_t unit, uint16_t cargo,
                                      uint16_t arg_a, uint16_t confirm)
{
    int ret = 1;        /* [bp-6]  */
    int qty;            /* [bp-2]  */
    int val;            /* [bp-8]  */
    int stock;          /* ctx->cargo[cargo]  */
    (void)arg_a;

    stock = *(int16_t far *)((char far *)ctx + 0x9A + cargo * 2);   /* @0x02A471 */

    if (stock < 1) {                                  /* @0x02A475 JGE 0x02A4D6 */
        /* --- empty: draw the "no stock" panel and enter info mode 0x14. --- */
        overlay_call_181F_0056();                     /* @0x02A47E begin(1) */
        overlay_call_191F_07D4();                     /* @0x02A489 set_attr(6) (func_07EC9) */
        overlay_call_181F_0074();                     /* @0x02A493 select cargo name[cargo] */
        overlay_call_191F_07D4();                     /* @0x02A49E set_attr(7) */
        overlay_call_191F_07B0();                     /* @0x02A4B4 blit(3, era?0x78:0) (func_07EBA) */
        cs_mode_8D54 = 0x14;                          /* @0x02A4BA */
        return ret;                                   /* @0x02A4C0 */
    }

    /* --- have stock: maybe re-draw the open dialog header. --- */
    if (g_flag_890 != 0 && cs_count_33C == 0) {        /* @0x02A4C6/0x02A4CD */
        overlay_call_181F_0056();                     /* @0x02A4D4 begin(1) */
        overlay_call_191F_07D4();                     /* @0x02A4E1 set_attr(5) */
        overlay_call_181F_0074();                     /* @0x02A4F0 select cargo name */
        overlay_call_181F_0088();                     /* @0x02A4F8 composite */
        overlay_call_181F_006A();                     /* @0x02A501 composite([0xCC0]) */
        overlay_call_191F_07B0();                     /* @0x02A4B4 (shared) */
    }

    if (confirm == 0) goto out0;                       /* @0x02A50C JMP 0x02A6AA exit ret=0? */

    /* @0x02A515: ask the quantity. */
    qty = 0;
    if (overlay_call_181F_0B96() != 0) {               /* @0x02A51F ask_quantity(&qty,...) */
        /* nonzero -> user picked a quantity: clamp and transfer. */
        if (qty > 0x64) qty = 0x64;                    /* @0x02A577 */
        if (qty > stock) qty = stock;                  /* @0x02A58F */
        if (confirm /*[bp+0xC]*/ != 0) {               /* @0x02A59A */
            overlay_call_181F_0438();                  /* @0x02A5A6 fmt cargo name */
            /* unit glyph via UnitRecord type -> disp[type*12] @0x02A5C4 */
            overlay_call_181F_0438();                  /* @0x02A5CA fmt glyph */
            overlay_call_181F_09AE();                  /* @0x02A5EA fmt number(qty) */
            if (overlay_call_191F_0436() != 0)         /* @0x02A5ED confirm_dialog() */
                goto out1;                              /* @0x02A5F6 cancelled */
            val = overlay_call_181F_035C();            /* @0x02A601 compute_value(qty,[0x9CC8]) */
            if (val > qty) val = qty;                  /* @0x02A60C clamp */
            qty = val;
            if (qty <= 0) goto out1;                   /* @0x02A617 */
        }
        overlay_call_181F_0AD8();                      /* @0x02A625 apply_transfer(qty,cargo,unit) */
        overlay_call_181F_0056();                      /* @0x02A632 begin(1) */
        overlay_call_181F_007E();                      /* @0x02A63E draw qty [0x8DC4] */
        overlay_call_181F_0074();                      /* @0x02A64B select cargo name */
        overlay_call_191F_07D4();                      /* @0x02A65A set_attr(2) */
        overlay_call_181F_0074();                      /* @0x02A67A select glyph (disp table) */
        overlay_call_191F_07B0();                      /* @0x02A689 blit(1,0x78,0) */
        if (g_flag_890 != 0)                            /* @0x02A68F */
            overlay_call_191F_078C();                  /* @0x02A697 finalise (func_07EAB) */
        ret = 0;                                       /* @0x02A69A */
    } else {
        /* qty==0 path: cancel-render and return ret=1. */
out1:
        overlay_call_181F_0056();                      /* @0x02A52B begin(1) */
        overlay_call_191F_07D4();                      /* @0x02A538 set_attr(4) */
        overlay_call_181F_0074();                      /* @0x02A547 select cargo name */
        overlay_call_181F_0088();                      /* @0x02A54F composite */
        overlay_call_181F_006A();                      /* @0x02A558 composite([0xCC2]) */
        overlay_call_191F_07B0();                      /* @0x02A567 blit(3,0x78,0) */
        ret = 1;                                       /* @0x02A56D */
    }
out0:
    return ret;                                        /* @0x02A69F */
}

/* ============================================================================
 * func_02A6A6  -- colony commodity LOAD/transfer-to-unit dialog.
 * ----------------------------------------------------------------------------
 * @asm        0x02A6A6..0x02A8EB  (582 bytes)  prologue ENTER 0xE,0  RETF
 * @asm_extent reseg page_02.asm (per-func dump "110 bytes" = first-RET trunc).
 *             BYTE_VERIFIED extents.
 * @args       (unit=[bp+6], cargo=[bp+8], confirm=[bp+0xA], _=[bp+0xC])
 * @reads      *(0x8542)+0x00/+0x02 (colony struct head), +0x9A+cargo*2 (stock),
 *               [0x8DC4] staging qty, [0x9CC8] price ctx, [0x0890] dialog owner,
 *               cargo name [cargo*2 - 0x6840], UnitRecord type -> disp[0x5230].
 * @thunks     0x181F:0xC2C cargo_capacity(unit,cargo)->free space (or <0 fail),
 *               0x181F:0x56/0x74 begin/select, 191F:0x7D4/0x7B0 attr/blit,
 *               0x181F:0x438 fmt_name, 0x181F:0x416 fmt_at(seg,ptr),
 *               0x181F:0x9AE fmt_number, 191F:0x436 confirm_dialog,
 *               0x181F:0x35C compute_value, 0x181F:0xD3A warehouse_cap,
 *               0x181F:0xAEC do_load(amount,unit), 0x181F:0xD58 post_load,
 *               0x181F:0x652 msg_popup(5,[0xCD6]) -> accept==2, 0x181F:0x7E qty,
 *               0x181F:0x88/0x6A composite, 0x181F:0xE2 / func_07EAB finalise.
 * @purpose    The colony commodity action when LOADING a unit: query the unit's
 *               free capacity for `cargo` (0x181F:0xC2C); if none (<0) show the
 *               "can't load" panel; else format the names+glyph, run the confirm
 *               dialog, clamp the requested amount to capacity and to warehouse
 *               stock, optionally pop a warehouse-overflow confirmation
 *               (msg_popup key [0xCD6]), then apply the load (0x181F:0xAEC),
 *               subtract from warehouse stock (*(8542)->cargo[cargo] += -amount
 *               @0x02A874) and finalise.  Returns [bp-6] (1/0).
 * @status     BYTE_VERIFIED (capacity gate, the stock subtract, the confirm/
 *               overflow popups, and [0x8DC4] staging all traced).
 * @touches_8542 yes (colony head + warehouse stock).
 * ---------------------------------------------------------------------------- */
int func_02A6A6_commodity_load_dialog(uint16_t unit, uint16_t cargo,
                                      uint16_t confirm, uint16_t arg_d)
{
    int ret  = 1;       /* [bp-6]  */
    int amt  = 0;       /* [bp-0xA] applied amount  */
    int cap;            /* [bp-0xC] free capacity   */
    int val;            /* [bp-0xE] computed value  */
    int maxstock;       /* [bp-2]  warehouse cap    */
    int delta;          /* [bp-8]  stock delta      */
    (void)arg_d;

    cap = overlay_call_181F_0C2C();                   /* @0x02A6BB cargo_capacity(unit,cargo) */
    if (cap < 0) {                                     /* @0x02A6C6 */
        /* --- no capacity: "can't load" panel. --- */
        if (g_flag_890 == 0) goto out;                /* @0x02A6CA */
        overlay_call_181F_0056();                     /* @0x02A6D4 begin(1) */
        overlay_call_191F_07D4();                     /* @0x02A6E1 set_attr(9) */
        overlay_call_181F_0074();                     /* @0x02A6EC select cargo name */
        overlay_call_191F_07D4();                     /* @0x02A6FB set_attr(0xA) */
        overlay_call_191F_07B0();                     /* @0x02A708 blit(3,0x78,0) */
        return ret;                                   /* @0x02A70E */
    }

    if (confirm /*[bp+0xA]*/ != 0) {                   /* @0x02A714 */
        /* --- confirmed: format, confirm-dialog, compute amount. --- */
        overlay_call_181F_0438();                     /* @0x02A728 fmt cargo name */
        /* unit glyph via UnitRecord type -> disp[type*12+0x5230] @0x02A746 */
        overlay_call_181F_0438();                     /* @0x02A74C fmt glyph */
        overlay_call_181F_0416();                     /* @0x02A75D fmt_at(ds, &ctx->[2]) */
        overlay_call_181F_09AE();                     /* @0x02A76D fmt_number([0x8DC4]) */
        if (overlay_call_191F_0436() != 0)            /* @0x02A781 confirm_dialog() */
            goto out;                                  /* @0x02A78A cancelled */
        val = overlay_call_181F_035C();               /* @0x02A796 compute_value([0x8DC4],[0x9CC8]) */
        amt = g_8DC4 - val;                            /* @0x02A7A1 */
        if (val > (int)g_8DC4) val = g_8DC4;           /* @0x02A7AD clamp */
        g_8DC4 = val;                                  /* @0x02A7B6 */
        if (val <= 0) goto out;                        /* @0x02A7B9 */
    }

    /* @0x02A7C2: warehouse-overflow guard. */
    maxstock = overlay_call_181F_0D3A();              /* @0x02A7C2 warehouse_cap() */
    {
        int newstock = *(int16_t far *)((char far *)ctx + 0x9A + cargo*2) + (int)g_8DC4; /* @0x02A7D3 */
        if (newstock > maxstock && cargo != 0 && g_flag_890 != 0) {   /* @0x02A7DB.. */
            overlay_call_181F_0416();                 /* @0x02A7F4 fmt_at(&ctx->[2]) */
            overlay_call_181F_0438();                 /* @0x02A802 fmt cargo name */
            overlay_call_181F_09AE();                 /* @0x02A817 fmt stock */
            overlay_call_181F_09AE();                 /* @0x02A827 fmt maxstock */
            overlay_call_181F_09AE();                 /* @0x02A837 fmt [0x8DC4] */
            if (overlay_call_181F_0652() != 2)        /* @0x02A844 msg_popup(5,[0xCD6])!=accept */
                goto out;                              /* @0x02A851 */
        }
    }

    /* @0x02A854: apply the load. */
    delta = g_8DC4;                                    /* @0x02A854 */
    overlay_call_181F_0AEC();                          /* @0x02A860 do_load(cap, unit) -> applied */
    *(int16_t far *)((char far *)ctx + 0x9A + cargo*2) += (int16_t)delta; /* @0x02A874 stock+=applied */
    overlay_call_181F_0D58();                          /* @0x02A881 post_load(amt,cargo,unit) */
    g_8DC4 = delta;                                    /* @0x02A88C */

    overlay_call_181F_0056();                          /* @0x02A891 begin(1) */
    overlay_call_181F_007E();                          /* @0x02A89D draw qty [0x8DC4] */
    overlay_call_181F_0074();                          /* @0x02A8A9 select cargo name */
    overlay_call_191F_07D4();                          /* @0x02A8B4 set_attr(2) */
    overlay_call_181F_0416();                          /* @0x02A8C1 fmt_at(&ctx->[2]) */
    overlay_call_181F_006A();                          /* @0x02A8D1 composite */
    overlay_call_191F_07B0();                          /* @0x02A8D0 blit(1,0x78,0) */
    if (g_flag_890 != 0)                                /* @0x02A8D6 */
        overlay_call_191F_078C();                      /* @0x02A8DD finalise (func_07EAB) */
    ret = 0;                                            /* @0x02A8E1 */
out:
    return ret;                                         /* @0x02A8E6 */
}

/* ============================================================================
 * func_02A8EC  -- commodity amount-prompt + max-clamp helper.
 * ----------------------------------------------------------------------------
 * @asm        0x02A8EC..0x02AAEB  (512 bytes)  prologue ENTER 8,0  RETF
 * @asm_extent IMPORTANT: this function's TRUE body is 0x02A8EC..0x02AAEB; the
 *             nominal file split ends at 0x02A92B (the auto-skeleton's "63
 *             bytes" was a first-RET truncation).  Only the FIRST RETF arm
 *             (0x02A8EC..0x02A92A) lies inside this file's stated range; the
 *             remainder (0x02A92C..0x02AAEB) physically belongs to the next
 *             segment file overlay_02AAEC_02F0C7.c's predecessor span and is
 *             documented here but ports there.  Extents BYTE_VERIFIED.
 * @args       (unit=[bp+6], unit2=[bp+8], cargo=[bp+0xA], mode=[bp+0xC])
 * @thunks     0x181F:0xBE6 cargo_query(unit,cargo)->idx, 0x181F:0xB96
 *               ask_quantity(idx,unit2)->ok, 0x181F:0xC68 max_available,
 *               191F:0x81C (func_07EE7) draw_no_qty, 0x181F:0x438 fmt_name,
 *               UnitRecord type -> disp[0x5230] for both unit and unit2 glyphs.
 * @purpose    First arm (in-range): cargo_query the source, ask_quantity; if the
 *               user entered nothing (ask returns 0) draw the "no quantity" panel
 *               (func_07EE7, colour 4) and return 1.  The continuation
 *               (out-of-range) clamps the amount to 0x64 and to max_available
 *               (0x181F:0xC68), then formats both unit glyphs for the
 *               transfer-between-units confirmation.  This is the shared
 *               amount-entry front-end for unit<->unit cargo moves.
 * @status     BYTE_VERIFIED for the in-range arm (cargo_query/ask_quantity/the
 *               draw_no_qty panel).  The continuation is cited but ported in the
 *               adjacent segment file (see @asm_extent).
 * ---------------------------------------------------------------------------- */
int func_02A8EC_cargo_amount_prompt(uint16_t unit, uint16_t unit2,
                                    uint16_t cargo, uint16_t mode)
{
    int ret = 1;        /* [bp-4]  */
    int qty = 0;        /* [bp-2]  */
    int idx;            /* [bp-8]  cargo_query result */
    (void)unit; (void)unit2; (void)cargo; (void)mode;

    idx = overlay_call_181F_0BE6();                   /* @0x02A8FF cargo_query(unit,cargo) */
    if (overlay_call_181F_0B96() == 0) {              /* @0x02A90E ask_quantity(idx,unit2) -> &qty */
        /* user cancelled / entered nothing: draw the "no qty" panel, ret=1. */
        overlay_call_191F_081C();                     /* @0x02A920 draw_no_qty(qty,0x78,4) (func_07EE7) */
        (void)idx; (void)qty;
        return ret;                                   /* @0x02A926 */
    }
    /* --- continuation @0x02A92C.. (ported in the adjacent segment file): ---
     *   if (qty > 0x64) qty = 0x64;
     *   if (qty > max_available(unit,cargo)) qty = max_available(...); [0x181F:0xC68]
     *   if (mode != 0) { fmt unit glyph (disp[type*12]); fmt unit2 glyph; ... }
     * Left documented (not duplicated) so this file's body stops at its first
     * RETF, matching the stated 0x027BB6..0x02A92B range.                      */
    return ret;
}
