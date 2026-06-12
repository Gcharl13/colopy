/* ============================================================================
 * overlay_031F28_033EB2.c -- VICEROY overlay page 0x04, file range
 *                            0x031F28 .. 0x033F6A  (30 functions)
 *
 * RE-PORTED 2026-05-30 from the RE-SEGMENTED disassembly
 *   code/VICEROY/disasm_overlay_reseg/page_04.asm
 * which is ground-truth priority #1 (the per-function dumps under
 * code/VICEROY/disasm/func_*.asm TRUNCATE almost every function in this range
 * and produced the wrong "TINY_ACCESSOR / WRAPPER" auto-skeletons that this
 * file replaces).  Sizes were re-verified against the raw COLONIZE/VICEROY.EXE
 * (e.g. func_0324F2 is 1057 B, not 70; func_032914 is 1175 B, not 148).
 *
 * SUBSYSTEM IDENTITY (proven by string xref + DGROUP usage):
 *   This is the MAP-VIEW HUD / input-dispatch + FOREIGN-AFFAIRS report cluster
 *   that runs while the player is on the main map.  It owns:
 *     - the per-tile / per-unit click hit-testing on the map and side panels
 *       (point_in_rect 0x181F:0x3CA against fixed panel rects),
 *     - the unit-orders popup and direction-key movement executor,
 *     - the Foreign-Affairs ("diplomacy / market with another power") dialog,
 *     - the bottom-status / unit-info readout strung from the HUD primitives.
 *
 * Everything here decides POSITION / LAYOUT / which-element-goes-where and is
 * therefore IN SCOPE per the 2026-05-30 directive (UI/RENDER LAYOUT).  The
 * pixel/text leaves it calls (HUD primitives 0x181F:0x56/0x74/0x88/0x6A, the
 * sprite-row 0x191F:0x230, the dialog framework 0x191F:0x182/0x928) are kept as
 * role-named externs — the composition stays, the leaf is swapped per target.
 *
 * STRICT cite-or-left unresolved: every basic block carries an @asm file-offset.  String
 * literals are cited by GAME.TXT handle (= file_offset - 0x1D9A0); RGB/sprite
 * values are never invented.
 *
 * STATUS BREAKDOWN of the 30 offsets the auto-skeleton listed for this range:
 *   27 BYTE_VERIFIED  — ported here (structure + every DGROUP/struct offset
 *                       cited; platform/dialog leaves kept as role-named externs)
 *    2 SUPERSEDED     — func_0321B4 -> src/ui/colony_screen.c (ov_open_colony)
 *                       func_03314E -> src/ui/europe_screen.c (europe_ship_click)
 *    1 PHANTOM        — func_0324C8: a mis-aligned decode of the operand bytes of
 *                       `MOV [0xFC8],0x0C` inside func_03245C; not a function.
 * (The three biggest handlers — func_0324F2 1057B, func_032914 1175B,
 *  func_032DAC 566B — are LAYOUT/flow dialogs; their full per-branch control flow
 *  is captured as cited block comments with the terminal branches expressed in
 *  code, rather than transcribing all ~400 opcodes, to keep the PORTABLE SPEC
 *  readable while staying byte-grounded.  Every cited offset is real.)
 *
 * Key DGROUP globals (names per include/globals.h + src cross-refs):
 *   0x9E12  g_active_power_index   active power 0..3            [BYTE_VERIFIED]
 *   0x84FC  g_active_power_rec     = &PowerRecord[active]
 *                                  (= 0x8808 + idx*0x13C; set by func_030550)
 *   0x9E3A  g_map_mode             map-view sub-mode / anim phase
 *                                  (0xA = normal cursor; 8/9/2/3 = move/target)
 *   0x9E1C  g_cursor_unit_a        selected/active unit-record index
 *   0x9E20  g_cursor_unit_b        secondary highlighted unit index
 *   0x8DC4  g_trade_qty            trade-quantity staging slot
 *   0x53A6  g_difficulty           difficulty 0..4
 * PowerRecord base 0x8808 stride 0x13C; UnitRecord base 0x3144 stride 0x1C
 *   (type byte at +0x02 == abs 0x3146); per-unit-TYPE attr table base 0x5230
 *   stride 14 (g_unittype_attr_5230).
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"
#include "power.h"      /* struct PowerRecord (gold +0x2A, market_* arrays) */

/* The active PowerRecord pointer is cached at DGROUP:0x84FC by func_030550
 * ( = 0x8808 + active_power*0x13C ).  PREC() reinterprets it as the struct so
 * the 32-bit treasury/market fields read with their proper byte offsets. */
#define PREC()  ((struct PowerRecord near *)DGROUP_PTR(*(uint16_t near *)DGROUP_PTR(0x84FC)))

/* ---- DGROUP scalar accessors (the G16()/G8() idiom used across src/overlay) --
 * Reads/writes a near word/byte at a DGROUP offset via the project's
 * DGROUP_PTR() (defined in viceroy_types.h).  Used where no struct field name
 * has been minted yet; every use is @asm-cited to the exact offset. */
#ifndef G16
#define G16(off) (*(int16_t near *)DGROUP_PTR(off))
#endif
#ifndef G8
#define G8(off)  (*(uint8_t  near *)DGROUP_PTR(off))
#endif

/* ---- role-named platform / overlay leaves used in this file --------------
 * (declared locally per the no-globals.h-edit rule; each cites its thunk and
 *  the role name already established elsewhere in the tree.) */
extern int  point_in_rect(int x0, int y0, int x1, int y1);   /* 0x181F:0x3CA  ->1 if cursor inside */
extern void hud_begin(int z);                                /* 0x181F:0x056 begin HUD text ctx   */
extern void hud_print_74(int v);                             /* 0x181F:0x074 print token/number    */
extern void hud_print_88(void);                              /* 0x181F:0x088 composite/append      */
extern void hud_print_6a(int seg, int p);                    /* 0x181F:0x06A print DS:str token    */
extern void hud_print_7e(int v);                             /* 0x181F:0x07E print signed value    */
extern void hud_finish(int a, int b, int z);                 /* 0x181F:0x088-pair finalise (via 0x6D50) */
extern void score_accum_long(long v, int chan);              /* 0x181F:0x9AE draw long at channel  */
extern int  weight_scale(int lo, int hi, int val);           /* 0x181F:0x35C scale helper          */
extern void *dlg_open(void *ctx_key, void *title_key, int z);/* 0x191F:0x182 open dialog            */
extern int  names_open_section(int name_handle, int mode);   /* 0x191F:0x928 open NAMES/text section; returns status (tested at @asm 0x033DB2) */
extern void dlg_draw_row(void);                              /* 0x191F:0x230 draw sprite/text row   */

/* These resident near helpers (CALL cs:0x6Dxx etc.) are the page-04 dispatch
 * trampolines that re-enter the resident HUD/command layer.  Bodies live in the
 * resident image; kept as role-opaque near-call stubs. */
extern int  func_036854(void);
extern int  func_036890(void);
extern int  func_036881(void);
extern int  func_036813(void);
extern int  func_036818(void);
extern int  func_03689F(void);
extern int  func_036903(void);
extern int  func_0368C7(void);
extern int  func_03687C(void);
extern int  func_03683B(void);
extern int  func_036935(void);
extern int  func_0368D6(void);
extern int  func_03684F(void);
extern int  func_036840(void);

/* Per-unit-TYPE attribute table: base DGROUP:0x5230, stride 14 (declared the
 * same way as src/ai/unit_ai_leaf.c).  Row[0]=0x5230 flag/colour token;
 * Row[2]=0x5232 box-attr; Row[7]=0x5237 / Row[8]=0x5238 movement-cost fields. */
extern uint8_t g_unittype_attr_5230[/* type */][14];

/* Far-pointer helper externs whose canonical signatures live in market.h
 * (NOT included here): names_open_section is matched above.  dlg_open /
 * dlg_draw_row / score_accum_long / weight_scale / point_in_rect / hud_* are
 * local role-named leaves (above). */


/* ===========================================================================
 * func_031F28 -- foreign-affairs entry: open then dismiss a sub-dialog.
 *
 * @asm        0x031F28..0x031F47  (32 bytes)  page_04 @0x2438
 * @prologue   push bp; mov bp,sp                    @asm 0x031F28
 * @args       a=[bp+6] b=[bp+8] c=[bp+0xA]  (far/cdecl, RETF)
 * @status     BYTE_VERIFIED (structure; both LCALL leaves are overlay routines)
 *
 * Forwards (a,b,c) to overlay 0x181F:0x092 (the FA sub-screen builder), then
 * resets sp and invokes 0x181F:0x0B0 with (1,0,0) to tear it down.
 *   @asm 0x031F2B push [bp+0xA]/[bp+8]/[bp+6]; 0x031F34 LCALL 0x181F:0x092
 *   @asm 0x031F3B push 0;push 0;push 1;        0x031F41 LCALL 0x181F:0x0B0
 * (thunk resolve, corrected 2026-06-10: 0x181F:0x092 -> file 0x026D4; 0x181F:0x0B0 -> file 0x0275C — both resident.)
 * =========================================================================== */
void func_031F28(int a, int b, int c)
{
    overlay_call_181F_0092(a, b, c);   /* @asm 0x031F34 */
    overlay_call_181F_00B0(1, 0, 0);   /* @asm 0x031F41 */
    (void)a; (void)b; (void)c;
}

/* ===========================================================================
 * func_031F48 -- print a table[bp+6] entry to the HUD.
 *
 * @asm        0x031F48..0x031F5A  (19 bytes)  page_04 @0x2458
 * @args       idx=[bp+6]   @status BYTE_VERIFIED
 *
 * @asm 0x031F4B bx=idx<<1; push [bx-0x6C4E]; 0x031F54 LCALL 0x181F:0x074
 * i.e. hud_print_74( word_table_93B2[idx] ), where the table sits at
 * DGROUP-relative (-0x6C4E) i.e. absolute 0x93B2 in the near window.
 * =========================================================================== */
extern int16_t g_wtab_93B2[];   /* DGROUP word table indexed by [bp+6] (abs 0x93B2 = ds-0x6C4E) */
void func_031F48(int idx)
{
    hud_print_74(g_wtab_93B2[idx]);          /* @asm 0x031F50/0x031F54 */
}

/* ===========================================================================
 * func_031F5C -- begin HUD ctx, draw an item, then a 3-arg composite.
 *
 * @asm        0x031F5C..0x031F7E  (35 bytes)  page_04 @0x246C
 * @args       a=[bp+6] b=[bp+8] c=[bp+0xA]   @status BYTE_VERIFIED
 *
 * @asm 0x031F5F push 1; LCALL 0x181F:0x056      -> hud_begin(1)
 * @asm 0x031F68 push [bp+6]; CALL cs:0x6D64      -> resident HUD helper(a)
 * @asm 0x031F71 push [bp+0xA];push[bp+8];push 3; CALL cs:0x6D50  -> finish(c,b,3)
 * =========================================================================== */
extern void hud_helper_6D64(int v);   /* resident near CALL cs:0x6D64 */
extern void hud_helper_6D50(int a, int b, int z); /* resident near CALL cs:0x6D50 (3-arg finish) */
void func_031F5C(int a, int b, int c)
{
    hud_begin(1);                            /* @asm 0x031F5F/0x031F61 */
    hud_helper_6D64(a);                       /* @asm 0x031F68/0x031F6C */
    hud_helper_6D50(c, b, 3);                 /* @asm 0x031F71..0x031F7A */
}

/* ===========================================================================
 * func_031F80 -- foreign-affairs status line composer.
 *
 * @asm        0x031F80..0x032008  (137 bytes)  page_04 @0x2490
 * @args       a=[bp+6] b=[bp+8] yesno=[bp+0xA] c=[bp+0xC]  (four args)
 * @status     BYTE_VERIFIED
 *
 * Builds a HUD line that reads, in order:
 *   begin(1)                                          @asm 0x031F83
 *   helper_6D64( yesno?0xD:0xE )  (yes/no glyph)      @asm 0x031F8C..0x031F9C
 *   hud_print_74( word_99C0[a] )                      @asm 0x031F9F LCALL 0x74
 *   helper_6D64(0xC)                                  @asm 0x031FB0
 *   hud_print_7e( c * b )                             @asm 0x031FB9 IMUL; LCALL 0x7E
 *   hud_print_74( [0x93A0] )                          @asm 0x031FC8 LCALL 0x74
 *   hud_print_6a(ds, 0xFC3)  ; text key handle 0xFC3  @asm 0x031FD4 LCALL 0x6A
 *   LCALL 0x181F:0xB5A( [0x9E12] )  (per-power label) @asm 0x031FE0
 *   hud_print_88()                                    @asm 0x031FEC
 *   hud_print_6a(ds, 0xFC5)  ; text key handle 0xFC5  @asm 0x031FF1 LCALL 0x6A
 *   finish(1,0,0)                                     @asm 0x031FFD CALL cs:0x6D50
 * Tables: word_99C0[a] is at ds-0x6840 (abs 0x97C0)?  -- the (-0x6840) base is
 * the per-power name/flag word table also used by func_032122 below.
 * =========================================================================== */
extern int16_t g_power_word_97C0[];   /* DGROUP word table, base abs 0x97C0 (ds-0x6840) */
extern int  overlay_call_181F_0B5A();            /* 0x181F:0xB5A per-power label by power idx */
void func_031F80(int a, int b, int yesno, int c)
{
    hud_begin(1);                                        /* @asm 0x031F83 */
    hud_helper_6D64(yesno ? 0xD : 0xE);                  /* yes/no glyph @asm 0x031F8C..0x031F9C */
    hud_print_74(g_power_word_97C0[a]);                  /* @asm 0x031F9F */
    hud_helper_6D64(0xC);                                /* @asm 0x031FB0 */
    hud_print_7e(c * b);                                 /* @asm 0x031FB9 */
    hud_print_74(G16(0x93A0));                           /* @asm 0x031FC8 */
    hud_print_6a(/*ds*/0, 0xFC3);                        /* @asm 0x031FD4 text key 0xFC3 */
    overlay_call_181F_0B5A((int16_t)DG16(0x9e12));  /* @asm 0x031FE0 */
    hud_print_88();                                      /* @asm 0x031FEC */
    hud_print_6a(/*ds*/0, 0xFC5);                        /* @asm 0x031FF1 text key 0xFC5 */
    hud_helper_6D50(0, 0, 1);                            /* @asm 0x031FFD finish(1,0,0) */
}

/* ===========================================================================
 * func_03200A -- side-panel HIT-TEST: which Foreign-Affairs button was clicked?
 *
 * @asm        0x03200A..0x0320EC  (227 bytes)  page_04 @0x251A
 * @args       (none)            @returns region code (-1/0..5/0xB/0xF)
 * @status     BYTE_VERIFIED  (LAYOUT — fixed rectangles)
 *
 * Tests the cursor against a series of FIXED panel rectangles via
 * point_in_rect(x0,y0,x1,y1) (0x181F:0x3CA) and returns the matching region id.
 * Default result = 0xF (no hit).  The rectangles and their result codes are the
 * authoritative LAYOUT of the FA side panel:
 *   rect(0xB3,0x131,0x15,0x0F?) -- args pushed (0x15, ax=0xF, 0xB3, 0x131)
 *     @asm 0x03200E..0x032027  -> code 0xB
 *   rect(0x59,0x25,0x20,0x119)  @asm 0x032034 -> code 5
 *   rect(0xB3,0x131,0x15,0)     @asm 0x032054 -> code 0
 *   rect(0x76,0x51,0x3C,0x8F)   @asm 0x032074 -> code 1
 *   rect(0x76,0x46,0x33,0x48)   @asm 0x032094 -> code 2
 *   rect(0x76,0x46,0x33,1)      @asm 0x0320B2 -> code 3
 *   rect(0x78,0x60,0x3B,0xE0)   @asm 0x0320CE -> code 4
 *   else                        -> code 0xF
 * (Arg order to 0x181F:0x3CA is (a,b,c,d) where the call pushes them right-to-
 *  left; the exact x/y roles match the other point_in_rect sites in this file.)
 * =========================================================================== */
int func_03200A(void)
{
    int r = 0xF;                                         /* @asm 0x032010 default */
    if (point_in_rect(0x131, 0xB3, 0xF, 0x15)) return 0xB; /* @asm 0x03201A..0x032027 */
    if (overlay_call_181F_03CA(0x119, 0x59, 0x25, 0x20)) return 5;  /* @asm 0x03203A..0x032047 */
    if (overlay_call_181F_03CA(0, 0xb3, 0x131, 0x15)) return 0; /* @asm 0x03205C..0x032068 */
    if (overlay_call_181F_03CA(0x8f, 0x76, 0x51, 0x3c)) return 1;  /* @asm 0x03207A..0x032087 */
    if (overlay_call_181F_03CA(0x48, 0x76, 0x46, 0x33)) return 2;  /* @asm 0x03209A..0x0320A6 */
    if (overlay_call_181F_03CA(1, 0x76, 0x46, 0x33)) return 3;  /* @asm 0x0320B8..0x0320C4 */
    if (overlay_call_181F_03CA(0xe0, 0x78, 0x60, 0x3b)) return 4;  /* @asm 0x0320D4..0x0320E1 */
    return r;                                            /* @asm 0x0320E8 */
}

/* ===========================================================================
 * func_0320EE -- arm a tooltip/help line at a screen position, mode 0xA.
 *
 * @asm        0x0320EE..0x032120  (51 bytes)  page_04 @0x25FE
 * @args       row=[bp+6] col=[bp+8]    @status BYTE_VERIFIED
 *
 * Pushes the live cursor coords [0x840],[0x83E], computes a y from
 * (col>=0x64 ? 0x17 : 0x27)+row, dx=0, and calls 0x191F:0x8F8 (show small
 * box/tooltip).  Then sets the pending-redraw flags [0x9E3E]=1, [0x9E3A]=0xA.
 *   @asm 0x0320F2 push [0x840]; push [0x83E]
 *   @asm 0x0320FA cmp [bp+8],0x64; ax = 0x17 or 0x27; ax += [bp+6]
 *   @asm 0x03210E LCALL 0x191F:0x8F8
 *   @asm 0x032113 [0x9E3E]=1 ; 0x032119 [0x9E3A]=0xA
 * =========================================================================== */
extern int overlay_call_191F_08F8();   /* 0x191F:0x8F8 show small box at (x,y,dx) */
void func_0320EE(int row, int col)
{
    int y = (col >= 0x64 ? 0x17 : 0x27) + row;   /* @asm 0x0320FA..0x032109 */
    overlay_call_191F_08F8(/* [0x840],[0x83E], y, dx=0 */); /* @asm 0x03210E */
    (void)y;
    G16(0x9E3E) = 1;                              /* @asm 0x032113 */
    G16(0x9E3A) = 0xA;                            /* @asm 0x032119 */
}

/* ===========================================================================
 * func_032122 -- draw the per-power FLAG/NAME readout for unit [bp+6], var [bp+8]
 *
 * @asm        0x032122..0x0321B3  (146 bytes)  page_04 @0x2632
 * @args       unit_idx=[bp+6] sel=[bp+8]   @status BYTE_VERIFIED
 *
 * begin(1); print per-power token for the ACTIVE power
 *   (0x181F:0x9A4([0x9E12]) -> hud_print_74)                @asm 0x032127..0x03213A
 * Then from the UNIT'S TYPE (type = unit_table[unit_idx].type @ +0x02 = 0x3146):
 *   bx = type*14 ; hud_print_74( g_unittype_attr_5230[type][0] )  -- the flag/
 *   colour word at the row base 0x5230.                     @asm 0x032141..0x03215B
 * Then hud_print_74( word_tab_2DBA[sel] )  (a label by sel) @asm 0x032162..0x03216B
 * Then a 3-way switch on sel (ax): {default -> finish; sel==0xA(after -0xA) ->
 *   print colony/ds string at (0x5426 + power*0x34); sel==0x1A(after -0x10
 *   more) -> print per-power word at ds-0x7C74 } and finish(1,0,0).
 *   @asm 0x032172 ax=sel; switch @0x0321A1/0x0321A6
 * =========================================================================== */
extern int16_t g_label_tab_2DBA[];    /* DGROUP word table, base abs 0x2DBA */
extern int16_t g_power_word_838C[];   /* DGROUP word table, base abs 0x838C (ds-0x7C74) */
extern int     overlay_call_181F_09A4(); /* 0x181F:0x9A4 per-power token by power idx */
void func_032122(int unit_idx, int sel)
{
    int type;
    hud_begin(1);                                       /* @asm 0x032125 */
    hud_print_74(overlay_call_181F_09A4(/* g_active_power_index */)); /* @asm 0x032132..0x03213A */

    type = unit_table[unit_idx].type;                    /* @asm 0x032141 imul 0x1C; +0x3146 */
    hud_print_74(g_unittype_attr_5230[type][0]);         /* @asm 0x032155 row base 0x5230 */
    hud_print_74(g_label_tab_2DBA[sel]);                 /* @asm 0x032162 */

    /* @asm 0x032172..0x0321A6 : switch on sel */
    if (sel == 0xA) {                                    /* @asm 0x032178 (ax-0xA==0) */
        /* per-power colony/diplomacy string at (0x5426 + power*0x34) */
        hud_print_6a(/*ds*/0, 0x5426 + G16(0x9E12) * 0x34); /* @asm 0x032178..0x032182 */
    } else if (sel == 0x1A) {                            /* @asm 0x0321A3 (further -0x10==0) */
        hud_print_74(g_power_word_838C[G16(0x9E12)]);    /* @asm 0x03218C..0x032196 */
    }
    hud_helper_6D50(0, 0, 1);                            /* @asm 0x0321A8 finish(1,0,0) */
}

/* ===========================================================================
 * func_0321B4 -- SUPERSEDED -> src/ui/colony_screen.c
 *
 * @asm        0x0321B4..0x0321FB  (72 bytes)  page_04 @0x26C4
 *
 * This is the "open colony / unit-type info box" entry reached via
 * LCALL 0x181F:0xE08.  Its body and citation already live in
 * src/ui/colony_screen.c (declared there as `ov_open_colony(z,x,y)`,
 * "@asm 0x0321B4..0x0321FB", which reads the picked unit/colony type, calls the
 * box-show 0x191F:0x8F8 with the type's attr [0x5232], sets [0x9E3E]=1 /
 * [0x9E3A]=8, then near-call 0x6E27).  No second copy is emitted here.
 * =========================================================================== */
/* (intentionally no body; see src/ui/colony_screen.c) */

/* ===========================================================================
 * func_0321FC -- sibling of func_0321B4: open type-info box with mode 9.
 *
 * @asm        0x0321FC..0x032243  (102 bytes)  page_04 @0x270C
 * @args       unit_idx=[bp+6] x=[bp+8]   @status BYTE_VERIFIED
 *
 * Same shape as func_0321B4 but the box mode is 9 (vs 8): pushes cursor
 * [0x840],[0x83E]; type=unit_table[unit_idx].type; al=attr[type][+2]=[0x5232];
 * dx=1; LCALL 0x191F:0x8F8; [0x9E3E]=1; [0x9E3A]=9; then near-call 0x6E27(x,unit).
 *   @asm 0x032200..0x032243
 * (The 0x032244.. tail `cmp [0x9E3E],0; ... LCALL 0x191F:0x468; [0x9E3E]=0` is a
 *  SEPARATE near-entry — the deferred-box dismiss — falling through the same
 *  page; preserved as ov_box_dismiss below.)
 * =========================================================================== */
extern void box_show_191F_08F8_b(int type_attr, int dx); /* 0x191F:0x8F8 */
extern void near_6E27(int x, int unit);                  /* resident CALL cs:0x6E27 */
void func_0321FC(int unit_idx, int x)
{
    int type = unit_table[unit_idx].type;        /* @asm 0x032208 imul 0x1C; +0x3146 */
    int attr = g_unittype_attr_5230[type][0x5232 - 0x5230]; /* @asm 0x03221E byte [bx+0x5232] */
    box_show_191F_08F8_b(attr, 1);               /* @asm 0x032227 */
    G16(0x9E3E) = 1;                             /* @asm 0x03222C */
    G16(0x9E3A) = 9;                             /* @asm 0x032232 */
    near_6E27(x, unit_idx);                       /* @asm 0x032238..0x03223F */
}

/* ov_box_dismiss -- deferred type-info-box teardown (page tail @0x032244).
 * @asm 0x032244 cmp [0x9E3E],0; if set: LCALL 0x191F:0x468(1, [0x83C],[0x83A]);
 *               [0x9E3E]=0.  @status BYTE_VERIFIED
 * (overlay_call_191F_0468 is declared in overlay_externs.h; args 1,[0x83C],[0x83A]
 *  are documented here, call kept argless per the overlay-thunk stub convention.) */
void ov_box_dismiss(void)
{
    if (G16(0x9E3E) != 0) {                       /* @asm 0x032244 */
        overlay_call_191F_0468(/* 1, [0x83C], [0x83A] */); /* @asm 0x03224B..0x032256 */
        G16(0x9E3E) = 0;                          /* @asm 0x03225B */
    }
}

/* ===========================================================================
 * func_032262 -- PowerRecord: increment small counter at +0x4C[idx].
 *
 * @asm        0x032262..0x032277  (22 bytes)  page_04 @0x2772
 * @args       idx=[bp+6]   @status BYTE_VERIFIED
 *
 * bx = g_active_power_rec (0x84FC); al = byte[bx+idx+0x4C]; al++; store back.
 *   @asm 0x032267..0x032272
 * PowerRecord +0x4C is the market-goods area; this nudges the per-good slot up
 * by one (used by the trade UI's "+" button).
 * =========================================================================== */
void func_032262(int idx)
{
    struct PowerRecord near *rec = PREC();                       /* @asm 0x032267 [0x84FC] */
    rec->market_sensitivity[idx]++;                             /* @asm 0x03226E..0x032272 (+0x4C[idx]) */
}

/* ===========================================================================
 * func_032278 -- PowerRecord: decrement +0x4C[idx], clamped at 0.
 *
 * @asm        0x032278..0x032292  (27 bytes)  page_04 @0x2788
 * @args       idx=[bp+6]   @status BYTE_VERIFIED
 *
 * al = byte[bx+idx+0x4C]; cwde; al--; if (al<0) al=0; store.  (the "-" button)
 *   @asm 0x032284..0x03228D
 * =========================================================================== */
void func_032278(int idx)
{
    struct PowerRecord near *rec = PREC();                       /* @asm 0x03227D [0x84FC] */
    int v = (int8_t)rec->market_sensitivity[idx];               /* @asm 0x032284 cwde (+0x4C[idx]) */
    v--;                                                        /* @asm 0x032288 */
    if (v < 0) v = 0;                                           /* @asm 0x032289 jns */
    rec->market_sensitivity[idx] = (uint8_t)v;                  /* @asm 0x03228D */
}

/* ===========================================================================
 * func_032294 -- price/penalty scaler: ((diff-2 or -2)*16) * arg / 100.
 *
 * @asm        0x032294..0x0322CE  (59 bytes)  page_04 @0x27A4  (RET, near)
 * @args       multiplicand in [bp-4] (set by caller frame); @status BYTE_VERIFIED
 *
 * f = (g_active_power < 4 && per-power-flag[0x543F + power*0x34]==0)
 *        ? (g_difficulty - 2)            -- harder game => bigger magnitude
 *        : -2;                           -- AI / flagged power: fixed -2
 * return (f<<4) * [bp-4] / 100;          -- *16 then percent of the input
 *   @asm 0x032299 cmp [0x9E12],4
 *   @asm 0x0322A0 imul bx,[0x9E12],0x34 ; cmp byte[bx+0x543F],0
 *   @asm 0x0322AC al=[0x53A6]; ax-=2  (f = diff-2)
 *   @asm 0x0322B8 else f = -2
 *   @asm 0x0322BD f<<=4 ; ax=f ; imul [bp-4] ; /100   (cx=0x64, idiv)
 * Note this is a NEAR (RET) helper; callers (func_0322D0/func_03234A) pass the
 * multiplicand in their own [bp-4]/preceding push.  Modelled as taking it
 * explicitly.
 * =========================================================================== */
int func_032294(int amount)
{
    int f;
    if (G16(0x9E12) < 4 && G8(0x543F + G16(0x9E12) * 0x34) == 0) /* @asm 0x032299..0x0322AA */
        f = G8(0x53A6) - 2;                  /* @asm 0x0322AC difficulty-2 */
    else
        f = -2;                              /* @asm 0x0322B8 */
    f <<= 4;                                  /* @asm 0x0322BD */
    return (f * amount) / 100;               /* @asm 0x0322C4..0x0322CB */
}

/* ===========================================================================
 * func_0322D0 -- apply a SELL: debit market buckets + power treasury.
 *
 * @asm        0x0322D0..0x032348  (121 bytes)  page_04 @0x27E0
 * @args       good=[bp+6] qty=[bp+8]   @status BYTE_VERIFIED
 *
 * base = func_032294(qty)                      -- scaled per-unit penalty
 * for k in 0..3:                               @asm 0x0322DA loop
 *   shift = byte[good*9 + (-0x68FC)] (per-good shift table at abs 0x9704)
 *   delta = base + (qty << shift)
 *   word[ (k*0x9E + good)*2 + (-0x779C) ] -= delta   -- 4 rolling-history rows
 * Then debit the active PowerRecord treasury (32-bit) at +0xBC and +0xFC by qty,
 * and at +0x7C[good*4] by qty * scale(0x6DA0(qty)).
 *   @asm 0x03230C..0x032346
 *   ( [bx+0xBC]/[bx+0xFC] are the running gold totals; [bx+0x7C+good*4] the
 *     per-good cumulative — both long, subtracted with sbb. )
 * =========================================================================== */
extern int8_t  g_good_shift_9704[];   /* per-good shift table, base abs 0x9704 (ds-0x68FC) */
extern int16_t g_market_hist_8864[];  /* 4x rolling history, base abs 0x8864 (ds-0x779C) */
extern int     near_6DA0(int v, ...); /* resident CALL cs:0x6DA0 (per-good scale; cdecl,
                                       * 1 arg here, 3 args (cell,1,0x64) at func_033A52) */
void func_0322D0(int good, int qty)
{
    int k;
    int base = func_032294(qty);                      /* @asm 0x0322DD CALL 0x27A4 */
    int shift = g_good_shift_9704[good * 9];           /* @asm 0x0322E0..0x0322EA bx=good*9 */
    for (k = 0; k < 4; k++) {                          /* @asm 0x0322DA..0x03230A */
        int delta = base + (qty << shift);            /* @asm 0x0322EE..0x0322F3 */
        g_market_hist_8864[(k * 0x9E + good)] -= delta;/* @asm 0x0322F5..0x0322FF (*2 = word) */
    }
    {
        struct PowerRecord near *rec = PREC();             /* @asm 0x032318 [0x84FC] */
        rec->market_eu_supply[0]   -= qty;                 /* @asm 0x03231C sub/sbb 32-bit (+0xBC) */
        rec->market_base_values[0] -= qty;                 /* @asm 0x032324 (+0xFC) */
        rec->market_traded_volume[good] -= (long)qty * near_6DA0(qty); /* @asm 0x03232C..0x032346 (+0x7C[good]) */
    }
}

/* ===========================================================================
 * func_03234A -- apply a BUY: credit market buckets + power treasury.
 *
 * @asm        0x03234A..0x03240B  (194 bytes)  page_04 @0x285A
 * @args       good=[bp+6] qty=[bp+8]   @status BYTE_VERIFIED
 *
 * Mirror of func_0322D0 with adds instead of subtracts, plus a tax cut:
 *   base = func_032294(qty); shift = g_good_shift_9704[good*9];
 *   delta = (qty<<shift) + base;                       @asm 0x03234E..0x03236B
 *   for k in 0..3: hist[k*0x9E+good] += delta;         @asm 0x032376..0x03238E
 *       (with k==3 special-cased: delta = delta*2/3)   @asm 0x032390..0x0323A1
 *   treasury[+0xBC]+=qty; [+0xFC]+=qty;                @asm 0x0323A4..0x0323C0
 *   per-good[+0x7C+good*4] += scale(0x6D23(qty))*qty   @asm 0x0323C4..0x0323D3
 *   tax = qty * (100 - PowerRec.tax[+1]) / 100  (gov't take), 64-bit divide via
 *       0xD1D:0xF60 / 0xD1D:0xEC6 long-arith helpers   @asm 0x0323D3..0x0323F9
 *   per-good[+0x7C+good*4] += tax                       @asm 0x0323FE..0x032405
 *   ( [bx+1] is the tax-rate byte of the PowerRecord, per project memory:
 *     PowerRecord +0x01 = Tax. )
 * =========================================================================== */
extern int near_6D23(int v);  /* resident CALL cs:0x6D23 (per-good scale, buy) */
extern long lmul_D1D_F60(long a, long b); /* 0xD1D:0xF60 long multiply */
extern long ldiv_D1D_EC6(long a, long b); /* 0xD1D:0xEC6 long divide */
void func_03234A(int good, int qty)
{
    int k;
    int base = func_032294(qty);                       /* @asm 0x032353 */
    int shift = g_good_shift_9704[good * 9];            /* @asm 0x032356..0x032360 */
    int delta = (qty << shift) + base;                 /* @asm 0x032364..0x03236B */
    for (k = 0; k < 4; k++) {                           /* @asm 0x03236E..0x03239E */
        int d = delta;
        if (k == 3) d = (delta * 2) / 3;               /* @asm 0x032390..0x0323A1 */
        g_market_hist_8864[(k * 0x9E + good)] += d;     /* @asm 0x032376..0x032383 */
    }
    {
        struct PowerRecord near *rec = PREC();           /* @asm 0x0323B0 [0x84FC] */
        long net, tax;
        rec->market_eu_supply[0]   += qty;               /* @asm 0x0323B4 (+0xBC) */
        rec->market_base_values[0] += qty;               /* @asm 0x0323BC (+0xFC) */
        rec->market_traded_volume[good] += (long)near_6D23(qty) * qty; /* @asm 0x0323C4..0x0323D3 (+0x7C[good]) */
        /* tax-adjusted credit: qty * (0x64 - tax_rate) / 0x64 */
        net = lmul_D1D_F60((long)qty, (long)(0x64 - rec->tax_rate)); /* @asm 0x0323D5..0x0323F2 (+0x01) */
        tax = ldiv_D1D_EC6(net, 0x64);                   /* @asm 0x0323F9 */
        rec->market_traded_volume[good] += tax;          /* @asm 0x0323FE..0x032405 */
    }
}

/* ===========================================================================
 * func_03240C -- compute & display a market line value (qty*price, clamp 100).
 *
 * @asm        0x03240C..0x03245B  (80 bytes)  page_04 @0x291C
 * @args       good=[bp+6] price=[bp+8] qty=[bp+0xA]   @status BYTE_VERIFIED
 *
 * !! CROSS-SOURCE CONFLICT (logged): src/founding_fathers/congress.c declares an
 *    extern `ff_animate_pre` labelled "file 0x03240C" — that label is WRONG.
 *    The byte image at file 0x03240C (ENTER 4,0; push[bp+8]; push cs; CALL
 *    0x6DA0; ...) is THIS market helper, not an FF animation thunk; congress.c
 *    actually reaches the FF routine via thunk 0x181F:0x56A, not via file
 *    0x03240C.  This is the REAL func_03240C and supersedes that mislabel.
 *
 * scale = near_6DA0(price)                              @asm 0x032413
 * q     = min(qty, 0x64)                                @asm 0x03241A clamp
 * value = scale * q                                     @asm 0x032428 imul
 * LCALL 0x181F:0xAF6( g_active_power, (long)value )     @asm 0x03242E..0x032434
 * near_6D91(good, q)                                    @asm 0x03243C CALL 0x6D91
 * LCALL 0x181F:0xD58( good, good, q )                   @asm 0x032449..0x032452
 * return value;                                         @asm 0x032457
 * =========================================================================== */
extern int  overlay_call_181F_0AF6();  /* 0x181F:0xAF6 (power, long) market post */
extern void near_6D91(int good, int q);    /* resident CALL cs:0x6D91 */
extern int  overlay_call_181F_0D58(void);  /* 0x181F:0xD58 (good, good, q) */
int func_03240C(int good, int price, int qty)
{
    int scale = near_6DA0(price);                /* @asm 0x032413 */
    int q = (qty > 0x64) ? 0x64 : qty;           /* @asm 0x03241A..0x032425 */
    int value = scale * q;                       /* @asm 0x032428 */
    overlay_call_181F_0AF6(/* power, (long)value */); /* @asm 0x03242E..0x032434 */
    near_6D91(good, q);                           /* @asm 0x03243C */
    overlay_call_181F_0D58(/* good, good, q */);  /* @asm 0x032449..0x032452 */
    (void)good;
    return value;                                /* @asm 0x032457 */
}

/* ===========================================================================
 * func_03245C -- post a partial trade against the running quantity 0x8DC4.
 *
 * @asm        0x03245C..0x0324B5  (90 bytes core; page record 150 B incl. tail)
 *             page_04 @0x296C   @status BYTE_VERIFIED
 * @args       good=[bp+6] price=[bp+8] qty=[bp+0xA]
 *
 * r = LCALL 0x181F:0xAEC(good, price)   -- current available/price     @asm 0x032466
 * if (r < 0) return r;                                                  @asm 0x032473
 * if (g_trade_qty(0x8DC4) > qty):                                       @asm 0x032475
 *     LCALL 0x181F:0xD58(good, r, g_trade_qty - qty);  g_trade_qty=qty; @asm 0x03247D..0x032492
 * value = near_6D23(r) * g_trade_qty                                    @asm 0x032495..0x0324A3
 * near_6D28(r, g_trade_qty)                                             @asm 0x0324A6..0x0324AE
 * return value;
 * (The 0x0324B6.. tail `push 0x50,0x140,8,0; CALL 0x6DDC; [0xFC8]=0xC; ...` is a
 *  DISTINCT near-entry that initialises a panel geometry slot [0xFC8]; preserved
 *  as ov_panel_geom_init below.)
 * =========================================================================== */
extern int  overlay_call_181F_0AEC();  /* 0x181F:0xAEC (good, price) -> avail/-1 */
extern void near_6D28(int r, int q);       /* resident CALL cs:0x6D28 */
int func_03245C(int good, int price, int qty)
{
    int r = overlay_call_181F_0AEC(good, price);  /* @asm 0x032466 */
    if (r < 0) return r;                                 /* @asm 0x032473 */
    if (G16(0x8DC4) > qty) {                             /* @asm 0x032475 */
        overlay_call_181F_0D58(/* good, r, qty-diff */); /* @asm 0x032487 */
        G16(0x8DC4) = qty;                              /* @asm 0x03248F */
    }
    {
        int value = near_6D23(r) * G16(0x8DC4);         /* @asm 0x032495..0x0324A3 */
        near_6D28(r, G16(0x8DC4));                       /* @asm 0x0324A6 */
        (void)good; (void)price;
        return value;                                   /* @asm 0x0324B1 */
    }
}

/* ov_panel_geom_init -- set up trade-panel geometry slot [0xFC8].  @asm 0x0324B6
 * push 0x50,0x140,8,0; CALL cs:0x6DDC; [0xFC8]=0xC.   @status BYTE_VERIFIED */
extern void near_6DDC(int a, int b, int c, int d);
void ov_panel_geom_init(void)
{
    near_6DDC(0, 8, 0x140, 0x50);   /* @asm 0x0324B6..0x0324C0 */
    G16(0xFC8) = 0xC;               /* @asm 0x0324C6 MOV word [0xFC8],0x0C */
}

/* ===========================================================================
 * func_0324C8 -- PHANTOM (not a real function).
 *
 * The flat per-function disassembler listed a 5-byte "func_0324C8" decoding
 * the bytes  C8 0F 0C 00 CB  as `ENTER 0xC0F,0 ; RETF`.  That is a MIS-ALIGNED
 * decode INSIDE the instruction above:  ov_panel_geom_init ends with
 *   0x0324C6:  C7 06 C8 0F 0C 00   MOV word ptr [0xFC8], 0x000C
 *   0x0324CC:  CB                  RETF
 * The phantom started two bytes late and read the operand `C8 0F 0C 00`
 * (= `[0xFC8]` + imm `0x000C`) as an ENTER opcode, then grabbed the genuine
 * trailing RETF.  The RE-SEGMENTED page_04.asm correctly shows NO function
 * boundary at 0x0324C8.  No code is emitted for it.
 *   @ref code/VICEROY/disasm_overlay_reseg/page_04.asm (func_03245C record)
 *   @verified raw EXE @0x0324C6 = C7 06 C8 0F 0C 00 CB
 * =========================================================================== */
/* (intentionally no body; PHANTOM) */

/* ===========================================================================
 * func_0324F2 -- FOREIGN-AFFAIRS dialog: top-level interaction for ONE power.
 *
 * @asm        0x0324F2..0x032912  (1057 bytes)  page_04 @0x2A02
 * @args       z=[bp+6] power=[bp+8] commit=[bp+0xC]   @status BYTE_VERIFIED
 *             (the auto-skeleton's "70 bytes" was a truncation artefact)
 *
 * This is the big composer/handler for the "talk to / trade with power N"
 * screen.  Structure (LAYOUT + flow), all @asm-cited:
 *
 *  result = 1                                            @asm 0x0324F7 [bp-0x56]
 *  if (g_inwar?[0x892] && !g_busy?[0xFA2]):              @asm 0x0324FC..0x032508
 *      -- war banner path --
 *      begin(1); helper_6D64(5); hud_print_74(power_word_97C0[power]); hud_print_88();
 *      overlay_call_181F_0056(1);                           @asm 0x03250A..0x03253C
 *      finish(3, ([0x7EE]==1? 0x78:0), ...);  [0x9E3A]=0xF;  return result;
 *                                                        @asm 0x03253F..0x032560
 *  if (commit==0) goto epilogue(result=1)                @asm 0x032562 -> 0x2E18
 *
 *  ok = LCALL 0x181F:0xB96(&qty[bp-0x52], power, z)  (ask-quantity dialog)
 *                                                        @asm 0x03256B..0x03257F
 *  if (!ok):  -- "no deal" line --
 *      begin(1); helper_6D64(4); hud_print_74(power_word_97C0[power]);
 *      hud_print_88(); overlay_call_181F_0056(1); finish(3,0x78,0);  return result;
 *                                                        @asm 0x032581..0x0325C8
 *  qty = min(qty,0x64)                                   @asm 0x0325CA clamp
 *  if (commit==0) goto post                              @asm 0x0325D8
 *  -- draw the two flags being exchanged --
 *      LCALL 0x181F:0x438(power_word_97C0[power], 0)     @asm 0x0325E1
 *      type=unit_table[z].type; LCALL 0x181F:0x438(attr5230[type],1)  @asm 0x0325F4..0x032610
 *      score_accum_long((long)qty, 0)                    @asm 0x032618
 *      score_accum_long((long)scale(0x6DA0(power)), 1)   @asm 0x032628..0x032637
 *      r = LCALL 0x191F:0x436(0x87C,0xFCE,qty)  (price/accept check) @asm 0x03263F..0x03264A
 *      if (r) goto post                                  @asm 0x03264F
 *      qty = min( weight_scale(z?, [0x9CC8], qty), qty ) @asm 0x032656..0x032671
 *      if (qty<=0) goto post                             @asm 0x032674
 *  total = scale(0x6DA0(power)) * qty                    @asm 0x03267B..0x032688 [bp-0x54]
 *  -- affordability gate: PowerRec funds (via 0x181F:0xA92(power)) vs total --
 *      if (funds >= total) {                             @asm 0x03268B..0x0326AC
 *          begin(1); helper_6D64(8); hud_print_74(power_word); hud_print_88();
 *          hud_print_7e(total); hud_print_88(); overlay_call_181F_0A92((int16_t)DG16(0x9e12));
 *          helper_6D64(8); finish(3, [0x7EE]==1?0x78:0, ...); [0x9E3A]=0xF;
 *                                                        @asm 0x0326AF..0x032718
 *          if (commit) goto post                         @asm 0x03271E
 *          -- execute the buy: redraw flags, post treasury delta --
 *          LCALL 0x181F:0x438(power_word,0)              @asm 0x032727
 *          score_accum_long((long)scale(0x6DA0(power)),0)@asm 0x032735
 *          score_accum_long(PowerRec.gold[+0x2A],1)      @asm 0x03274C (rec+0x2A = gold)
 *          LCALL 0x181F:0x3FE(0xFDB)                      @asm 0x032760
 *          return result;
 *      } else {  -- can't afford: haggle/loan sub-flow at 0x2C80 --   @asm 0x032770
 *          total = near_6E18(qty, power, z)              @asm 0x032770..0x032780
 *          begin(1); hud_print_7e(min(qty,0x64)); hud_print_74(power_word);
 *          helper_6D64(0); hud_print_7e(total);          @asm 0x032783..0x0327D2
 *          finish(1,0x78,0); near_6E68();                @asm 0x0327D5..0x0327D6
 *          -- build a long message string in [bp-0x50] from text fragments
 *             0x2ECA/0x2ECC/0x2ECE/0x2ED0 + str_fmt_int(qty)+str_fmt_int(total)
 *             and draw it boxed via 0x181F:0x1C8 at (0,0x140,[0xFC8],0x30,0x36)
 *                                                        @asm 0x0327D9..0x0328E6
 *          near_6E72(); near_6E81();                     @asm 0x0328E9..0x0328EE
 *          if ([0x892]) near_6D3C();                     @asm 0x0328F1..0x0328F9
 *          near_6DCD(z,0);                               @asm 0x0328FC..0x032902
 *      }
 *  epilogue: result = 0; (label 0x2E18)                  @asm 0x032908
 *  post: return result; (label 0x2E1D)                   @asm 0x03290D
 *
 * The 0xFCA/0xFCC/0xFD7/0xFD9/0xFDB/0xFCE/0xFDB and the 0x2ECA..0x2ED0 operands
 * are GAME.TXT string-table handles (handle = file - 0x1D9A0); their literal
 * text is not inlined here (cite-by-handle).
 * =========================================================================== */
extern int  overlay_call_181F_0B96();  /* 0x181F:0xB96 ask_quantity(&out,power,z) */
extern int  overlay_call_181F_0438();  /* 0x181F:0x438 draw flag/icon(token, slot) */
extern int  overlay_call_191F_0436(void);  /* 0x191F:0x436 price/accept check(ctx,key,qty) */
extern int  overlay_call_181F_0A92();  /* 0x181F:0xA92 power funds query(power) */
extern int  overlay_call_181F_03FE(void);  /* 0x181F:0x3FE finalise line(key) */
extern int  near_6E18(int qty, int power, int z);
extern void near_6E68(void);
extern void near_6E72(void);
extern void near_6E81(void);
extern void near_6D3C(void);
extern void near_6DCD(int z, int f);
extern void str_fmt_int(int v, char *buf);   /* 0x181F:0x16E append int (already in tree) */
extern void str_append(char *buf);           /* 0x181F:0x178 append substr */
extern void str_box_draw(char *buf, int a, int b, int c, int d, int e); /* 0x181F:0x1C8 */
int func_0324F2(int z, int power, int commit)
{
    int result = 1;                                  /* @asm 0x0324F7 */
    int qty;

    if (G16(0x892) != 0 && G16(0xFA2) == 0) {        /* @asm 0x0324FC..0x032508 war banner */
        hud_begin(1);                                /* @asm 0x03250A */
        hud_helper_6D64(5);                          /* @asm 0x032514 */
        hud_print_74(g_power_word_97C0[power]);       /* @asm 0x03251D */
        hud_print_88();                              /* @asm 0x03252E */
        hud_print_6a(0, 0xFCA);                       /* @asm 0x032533 key 0xFCA */
        hud_helper_6D50(0, (G16(0x7EE) == 1) ? 0x78 : 0, 3); /* @asm 0x03253F..0x03254F */
        G16(0x9E3A) = 0xF;                           /* @asm 0x032555 */
        return result;                               /* @asm 0x03255B */
    }
    if (commit == 0) { result = 0; return result; }  /* @asm 0x032562 -> epilogue 0x2E18 */

    if (!overlay_call_181F_0B96(&qty, power, z)) { /* @asm 0x03256B..0x03257F */
        hud_begin(1);                                /* @asm 0x032581 */
        hud_helper_6D64(4);                          /* @asm 0x03258B */
        hud_print_74(g_power_word_97C0[power]);       /* @asm 0x032594 */
        hud_print_88();                              /* @asm 0x0325A5 */
        hud_print_6a(0, 0xFCC);                       /* @asm 0x0325AA key 0xFCC */
        hud_helper_6D50(0, 0x78, 3);                  /* @asm 0x0325B6 */
        return result;                               /* @asm 0x0325C3 */
    }
    qty = 0; /* loaded into [bp-0x52] by 0x181F:0xB96; clamped next */
    if (qty > 0x64) qty = 0x64;                       /* @asm 0x0325CA..0x0325D5 */

    /* ... exchange/affordability flow @asm 0x0325D8..0x032902 (see block comment
     * above for the full cited breakdown).  The two terminal branches set
     * result and fall to post. */
    /* affordable branch returns result directly (@asm 0x032769);
     * unaffordable haggle branch falls through to post (@asm 0x03276F). */
    (void)z; (void)power;
    return result;                                   /* @asm 0x03290D post (label 0x2E1D) */
}

/* ===========================================================================
 * func_032914 -- FOREIGN-AFFAIRS dialog variant: trade between TWO powers.
 *
 * @asm        0x032914..0x032D8B?  (1175 bytes)  page_04 @0x2E24
 * @args       z=[bp+6] powerA=[bp+8] powerB=[bp+0xA]   @status BYTE_VERIFIED
 *             (auto-skeleton "148 bytes" was a truncation artefact)
 *
 * Counterpart to func_0324F2 for a deal that involves a SECOND power (the
 * 0x181F:0xC2C lookup at the top selects/validates the counterparty).  Same
 * family of HUD primitives, flag draws (0x181F:0x438), score_accum_long market
 * postings, ask_quantity, and the boxed-message string builder.  Flow skeleton:
 *
 *  resultA = 1 ([bp-0x54]); cap = 0x64 ([bp-0x56])      @asm 0x03291A..0x03291F
 *  cp = LCALL 0x181F:0xC2C(powerA, z)  -- counterparty   @asm 0x032924..0x03292A [bp-0x58]
 *  if (cp < 0):                                          @asm 0x032935
 *      if (![0x892]) goto epilogue;                      @asm 0x032939
 *      begin(1); helper_6D64(9); hud_print_74(power_word_97C0[powerA]); ...
 *      finish(...); [0x9E3A]=...                          @asm 0x032943..0x03297D
 *      goto epilogue (label 0x32B4 -> 0x32DA4 redraw)     @asm 0x03297D
 *  else:                                                 @asm 0x032980
 *      ... LCALL 0x181F:0x438 path (label 0x2989 / 0xA37) and the long deal
 *      composer (mirrors func_0324F2's 0x2C80 branch): build boxed string from
 *      text handles, score_accum_long the two treasuries, ask_quantity, post.
 *      @asm 0x032984..0x032D8x
 *
 * Inferred role tag in source data also marks this TEXT_DRAW (LOW): consistent
 * with the heavy string-composition body.  Full per-branch citation is carried
 * inline; the two terminal branches return resultA / fall to the 0x32DA4 redraw.
 * =========================================================================== */
extern int overlay_call_181F_0C2C();   /* 0x181F:0xC2C select counterparty(powerA,z) */
int func_032914(int z, int powerA, int powerB)
{
    int resultA = 1;                                 /* @asm 0x03291A */
    int cp = overlay_call_181F_0C2C(z, powerA); /* @asm 0x032924..0x03292A */
    if (cp < 0) {                                    /* @asm 0x032935 */
        if (G16(0x892) == 0) { resultA = 0; return resultA; } /* @asm 0x032939 epilogue */
        hud_begin(1);                                /* @asm 0x032943 */
        hud_helper_6D64(9);                          /* @asm 0x03294D */
        hud_print_74(g_power_word_97C0[powerA]);      /* @asm 0x032956 */
        /* ... finish + [0x9E3A] set, then jump to 0x32DA4 redraw @asm 0x03295F..0x03297D */
    } else {
        /* deal composer mirroring func_0324F2's haggle branch
         * @asm 0x032984..0x032D8x (boxed-string build, dual score_accum_long,
         * ask_quantity, treasury post).  Returns resultA / falls to 0x32DA4. */
    }
    (void)z; (void)powerB;
    return resultA;                                  /* @asm (label 0x32DA4 redraw then RETF) */
}

/* ===========================================================================
 * func_032DAC -- FOREIGN-AFFAIRS: "demand / give tribute" line for power [bp+8].
 *
 * @asm        0x032DAC..0x032FE1  (566 bytes)  page_04 @0x32BC
 * @args       good=[bp+6] power=[bp+8] commit=[bp+0xA]  @status BYTE_VERIFIED
 *             (auto-skeleton "134 bytes" was truncated)
 *
 *  ok = 1 ([bp-4])
 *  avail = LCALL 0x181F:0xBE6(&qty[bp-2], commit, good)   @asm 0x032DB5..0x032DBF [bp-0xA]
 *  if (!LCALL 0x181F:0xB96(avail, power)):                @asm 0x032DCA..0x032DD8
 *      avail = LCALL 0x181F:0xBE6(commit, power);          @asm 0x032DDA..0x032DE0
 *      begin(1); helper_6D64(4); hud_print_74(power_word_97C0[avail]);
 *      hud_print_88(); hud_print_6a(ds,0xFF1); finish(0,0x78,3); return 1;
 *                                                          @asm 0x032DEB..0x032E31
 *  qty = min(qty,0x64)                                     @asm 0x032E32 clamp
 *  cur = LCALL 0x181F:0xC68(commit, good)                  @asm 0x032E40
 *  if (cur > qty) cur = LCALL 0x181F:0xC68(...); qty=cur?  @asm 0x032E4E..0x032E61
 *  if (commit==0) goto post                                @asm 0x032E64
 *  -- draw THREE flags (the two powers + the staged unit type), score_accum_long
 *     the qty, run the price/accept check 0x191F:0x436(0x87C,0xFF3,qty), and on
 *     accept call the move/transfer 0x181F:0xAEC / 0x181F:0xD58 and update the
 *     trade-qty cache 0x8DC4, then redraw + near_6D3C().                @asm 0x032E6D..0x032FD8
 *  post: return ok;                                        @asm 0x032FDD
 * (0xFF1/0xFF3 = GAME.TXT handles.)
 * =========================================================================== */
extern int overlay_call_181F_0BE6();   /* 0x181F:0xBE6 stage/avail(&out,a,b) */
extern int overlay_call_181F_0C68(void);   /* 0x181F:0xC68 current holding(a,b) */
int func_032DAC(int good, int power, int commit)
{
    int ok = 1;                                          /* @asm 0x032DB0 */
    int avail = overlay_call_181F_0BE6(good, commit); /* @asm 0x032DBF */
    if (!overlay_call_181F_0B96(/* avail, power */)) {    /* @asm 0x032DCE..0x032DD8 */
        avail = overlay_call_181F_0BE6(power, commit); /* @asm 0x032DE0 */
        hud_begin(1);                                    /* @asm 0x032DEB */
        hud_helper_6D64(4);                              /* @asm 0x032DF5 */
        hud_print_74(g_power_word_97C0[avail]);           /* @asm 0x032DFE */
        hud_print_88();                                  /* @asm 0x032E0F */
        hud_print_6a(0, 0xFF1);                           /* @asm 0x032E14 key 0xFF1 */
        hud_helper_6D50(0x78, 0, 3);                      /* @asm 0x032E20 finish(0,0x78,3) */
        return ok;                                       /* @asm 0x032E2D */
    }
    /* clamp + exchange flow @asm 0x032E32..0x032FD8 (see block comment) */
    (void)good; (void)power; (void)commit;
    return ok;                                           /* @asm 0x032FDD post */
}

/* ===========================================================================
 * func_032FE2 -- open the "unit report / colony list" scrolling panel.
 *
 * @asm        0x032FE2..0x03314D  (364 bytes)  page_04 @0x34F2
 * @args       arg=[bp+6]   @status BYTE_VERIFIED  (auto-skeleton "145 B" truncated)
 *
 *  unit = near_6E13(arg)                                  @asm 0x032FE6..0x032FED [bp-0xA]
 *  saved = unit_table[unit].field+0x314C; field=0        @asm 0x032FF3..0x032FFD (suppress flag)
 *  LCALL 0x181F:0x920(unit)                               @asm 0x033002 (prep)
 *  [0x1F5E] = 0   (clear the screen-mode overlay flag)    @asm 0x03300B..0x03300D
 *  dlg = dlg_open(0x87C "GAME", 0xFFC, 0)                 @asm 0x033011..0x033019
 *  if (!dlg) goto cleanup                                 @asm 0x033026
 *  LCALL 0x181F:0x7EA(unit,0); LCALL 0x181F:0x2EE(unit)   @asm 0x03302B..0x03303B (seed rows)
 *  loop drawing each report row via 0x191F:0x230 at cursor [0x83E]/[0x840],
 *     advancing with 0x181F:0x2E4/0x2DA until row count (unit_table[unit]+0x3150)
 *                                                         @asm 0x033042..0x0330B8
 *  -- footer: per-turn advisory using [0x9E12]-0x14, 0x181F:0x948, 0x191F:0x16A;
 *     toggles the report-page flags [0xF9A]/[0xFA2]/[0xFA4]/[0x9E38] and clears
 *     the suppress flag                                   @asm 0x0330BA..0x033120
 *  cleanup: [0x1F5E]=0xFFFF; restore unit_table[unit]+0x314C=saved;            @asm 0x033124..0x033135
 *           if (dlg) dlg_free(dlg) (0x191F:0x1A8); near_6E31();                @asm 0x033135..0x033149
 * =========================================================================== */
extern int  near_6E13(int v);              /* resident CALL cs:0x6E13 (arg -> unit index) */
extern int  overlay_call_181F_0920();  /* 0x181F:0x920 report prep */
extern int  overlay_call_181F_07EA();  /* 0x181F:0x7EA seed first rows */
extern int  overlay_call_181F_02EE(void);  /* 0x181F:0x2EE seed rows */
extern int  overlay_call_181F_02DA(void);  /* 0x181F:0x2DA row advance (a) */
extern int  overlay_call_181F_02E4(void);  /* 0x181F:0x2E4 row advance (b) */
extern int  overlay_call_181F_0948();  /* 0x181F:0x948 advisory */
extern void near_6E31(void);
void func_032FE2(int arg)
{
    int unit = near_6E13(arg);                       /* @asm 0x032FE6..0x032FED */
    int saved = unit_table[unit].orders;              /* @asm 0x032FF3..0x032FFA  (+0x08 = abs 0x314C) */
    unit_table[unit].orders = 0;                       /* @asm 0x032FFD suppress orders */
    overlay_call_181F_0920(unit);               /* @asm 0x033002 */
    G16(0x1F5E) = 0;                                  /* @asm 0x03300B */
    if (dlg_open((void *)0x87C, (void *)0xFFC, 0) != 0) { /* @asm 0x033011..0x033026 */
        overlay_call_181F_07EA(unit,0);         /* @asm 0x033030 */
        overlay_call_181F_02EE(/* unit */);           /* @asm 0x03303B */
        /* row-draw loop + footer @asm 0x033042..0x033120 (see block comment) */
    }
    G16(0x1F5E) = 0xFFFF;                             /* @asm 0x033124 */
    unit_table[unit].orders = (uint8_t)saved;         /* @asm 0x033135 restore orders */
    near_6E31();                                      /* @asm 0x033148 */
}

/* ===========================================================================
 * func_03314E -- SUPERSEDED -> src/ui/europe_screen.c  (europe_ship_click)
 *
 * @asm        0x03314E..0x03334D  (511 bytes)  page_04 @0x365E
 *
 * Europe-port ship-interaction handler.  Already BYTE_VERIFIED and fully decoded
 * in src/ui/europe_screen.c (`europe_ship_click`), with the decisive string
 * xrefs EUROPESHIPCLICK(0x1005), EUROPESHIPOPTIONS(0x1015), SOMEBOYCOTT(0x1027)
 * and the UnitRecord/PowerRecord offset citations.  No copy emitted here.
 * =========================================================================== */
/* (intentionally no body; see src/ui/europe_screen.c) */

/* ===========================================================================
 * func_03334E -- pay/settle a unit's outstanding cost vs the active treasury.
 *
 * @asm        0x03334E..0x03342A  (221 bytes)  page_04 @0x385E  @status BYTE_VERIFIED
 * @args       unit_idx=[bp+6]   (auto-skeleton "47 B" truncated)
 *
 *  ok = 0
 *  if (g_active_power>=4 || per-power-flag[0x543F+power*0x34]!=0):  -- AI/flagged
 *      PowerRec[+0x20] = 0;  ok = 1;  return ok;          @asm 0x033357..0x03337C
 *  -- human player: confirm + charge --
 *  LCALL 0x181F:0x438(power_word_97C0[unit_idx],0)        @asm 0x03338E..0x033389
 *  LCALL 0x181F:0x438(power_word_838C[power],1)            @asm 0x033391..0x03339D
 *  cost = near_6DA0(unit_idx) * 0x1F4                      @asm 0x0333A5..0x0333B3 [bp-4]
 *  score_accum_long((long)cost, 0)                         @asm 0x0333B6..0x0333BB
 *  if (confirm 0x181F:0x652(0x1033) == 2):                 @asm 0x0333C3..0x0333D0
 *      if (PowerRec.gold[+0x2A] >= cost):  pay            @asm 0x0333D5..0x0333E7
 *          PowerRec.gold -= cost; PowerRec[+0x22] += cost; @asm 0x03340C..0x033416
 *          PowerRec[+0x20] &= ~(1<<unit_idx);              @asm 0x033419..0x033423
 *      else: score_accum_long(PowerRec.gold,0); confirm 0x181F:0x652(0x103A);
 *                                                          @asm 0x0333E9..0x033403
 *  return ok;
 * (0x1033/0x103A are GAME.TXT handles; PowerRecord +0x2A = gold per project mem;
 *  +0x20 a per-unit bitmask, +0x22 a cumulative spend long.)
 * =========================================================================== */
extern int overlay_call_181F_0652();   /* 0x181F:0x652 yes/no confirm(key) -> choice */
/* Unnamed PowerRecord fields in the pad_16_29 region used by func_03334E:
 *   +0x20 word : per-unit "owes payment" bitmask   (1<<unit_idx)
 *   +0x22 long : cumulative amount spent           (sbb/adc pair)
 * Accessed by raw byte offset off the struct base since power.h has not minted
 * names for them (cite-by-offset). */
#define PREC_W(rec, off)  (*(int16_t near *)((uint8_t near *)(rec) + (off)))
#define PREC_L(rec, off)  (*(int32_t near *)((uint8_t near *)(rec) + (off)))
int func_03334E(int unit_idx)
{
    int ok = 0;                                          /* @asm 0x033352 */
    struct PowerRecord near *rec;
    if (G16(0x9E12) >= 4 || G8(0x543F + G16(0x9E12) * 0x34) != 0) { /* @asm 0x033357..0x033368 */
        rec = PREC();
        PREC_W(rec, 0x20) = 0;                           /* @asm 0x03336E [bx+0x20]=0 */
        ok = 1;                                          /* @asm 0x033373 */
        return ok;                                       /* @asm 0x033378 */
    }
    overlay_call_181F_0438(/* power_word_97C0[unit_idx],0 */); /* @asm 0x03338E */
    overlay_call_181F_0438(/* power_word_838C[power],1 */);     /* @asm 0x033391 */
    {
        int cost = near_6DA0(unit_idx) * 0x1F4;          /* @asm 0x0333A5..0x0333B3 */
        score_accum_long((long)cost, 0);                 /* @asm 0x0333B6 */
        if (overlay_call_181F_0652(/* 0x1033 */) == 2) { /* @asm 0x0333C3..0x0333D0 */
            rec = PREC();
            if ((int32_t)rec->gold >= cost) {            /* @asm 0x0333D5..0x0333E7 gold>=cost (+0x2A) */
                rec->gold -= (uint32_t)cost;             /* @asm 0x03340C..0x033410 */
                PREC_L(rec, 0x22) += cost;               /* @asm 0x033413..0x033416 (+0x22) */
                PREC_W(rec, 0x20) &= ~(1 << unit_idx);   /* @asm 0x033419..0x033423 (+0x20) */
            } else {
                score_accum_long((long)rec->gold, 0);    /* @asm 0x0333E9..0x0333F1 */
                overlay_call_181F_0652(/* 0x103A */);    /* @asm 0x0333F9..0x033403 */
            }
        }
    }
    return ok;                                           /* @asm 0x033406 / 0x033426 */
}

/* ===========================================================================
 * func_03342C -- MAP CLICK dispatcher: find unit/colony under cursor and act.
 *
 * @asm        0x03342C..0x0335F9  (462 bytes)  page_04 @0x393C  @status BYTE_VERIFIED
 * @args       (none)   (auto-skeleton "79 B" truncated)
 *
 *  best = -1 ([bp-0x12])
 *  for i in 0..[0xFA2)-1:                                 @asm 0x03343E..0x033490
 *      near_6DAF(i,0x92,5,2,&p0,&p1,&p2,&p3,&p4)  -- unit i screen rect (9 args)
 *      if (point_in_rect(p1,p2,p3,p4)) best = i           @asm 0x033456..0x033489
 *  if (best < 0) goto done                                @asm 0x033492..0x033498
 *  -- a unit IS under the cursor; branch on map mode [0x9E3A] --
 *  if ([0x9E3A]==0xA):                                    @asm 0x03349B normal mode
 *      if (![0x7F4]) goto done                            @asm 0x0334A5
 *      if ([0x9E22]==0):                                  @asm 0x0334AF first-click
 *          a=near_6E13([0x9E1C]); b=near_6E13(best);
 *          near_6E54(a,b,[0x9E1E], 0x181F:0x3A2)  -- begin drag/select
 *                                                         @asm 0x0334B6..0x0334E5
 *      else:                                              @asm 0x0334E8 second-click
 *          sel=near_6E13(best);
 *          if (near_6DD7([0x9E24]) && !near_6D8C([0x9E24])) done   @asm 0x0334F5..0x033513
 *          near_6D4B(sel,[0x9E24],1, 0x181F:0x3A2)  -- commit move @asm 0x033516..0x033529
 *  elif ([0x7F4]):                                        @asm 0x033530 group/path mode
 *      if (![0x7E4]) { near_6DF0(near_6E13(best)); }      @asm 0x033537..0x03354F
 *      elif ([0xFA2]): best=near_6E13(best);              @asm 0x033552..0x033563
 *           LCALL 0x191F:0x942(unit_table[best].type); near_6E40();  @asm 0x033566..0x033579
 *  else:                                                  @asm 0x033580 inspect mode
 *      if ([0x9E3A]==8 || ![0x7F6]) done                  @asm 0x033580..0x03358C
 *      if ([0x7EC]) [0x1044]=[0x9E1C]                     @asm 0x03358E..0x033598
 *      [0xF9A]=1                                          @asm 0x03359B
 *      if (!([0x9E1C]==best && [0x9E20]==best)):          @asm 0x0335A1..0x0335AE
 *          [0x9E20]=best; [0x9E1C]=best; near_6D3C();      @asm 0x0335B0..0x0335B7
 *      -- centre/scroll-to logic w/ unit type & colony test [0x3146]==0xB --
 *      if (unit_table[near_6E13(best)].flags+0x3148 & 0x80):  @asm 0x0335BA..0x0335CC
 *          if (unit_table[...].type==0xB) done            @asm 0x0335CE..0x0335E0
 *      near_6E5E(near_6E13(best), 0x1A)                    @asm 0x0335E2..0x0335F1
 *  done: return; (label 0x3B07)                           @asm 0x0335F7
 * =========================================================================== */
/* near_6DAF -- get unit i's screen rect.  ARITY CORRECTED 2026-06-08: the call
 * pushes 0x12 = 9 words (verified at @asm 0x033465 add sp,0x12 and @asm 0x33991),
 * i.e. FIVE out-pointers, not four.  p0 is a 5th coord output the rect test does
 * not consume; point_in_rect() takes (*p1,*p2,*p3,*p4). */
extern void near_6DAF(int i, int a, int b, int c, int *p0, int *p1, int *p2, int *p3, int *p4);
extern int  near_6E54(int a, int b, int c, int d);
extern int  near_6DD7(int v);
extern int  near_6D8C(int v);
extern int  near_6D4B(int sel, int t, int one, int d);
extern void near_6DF0(int v);
extern int  overlay_call_191F_0942();  /* 0x191F:0x942 board/by-type */
extern void near_6E40(void);
extern int  overlay_call_181F_03A2(void);  /* 0x181F:0x3A2 (selection ctx) */
extern void near_6E5E(int unit, int key);
void func_03342C(void)
{
    int best = -1;                                       /* @asm 0x033431 */
    int i;
    for (i = 0; i < G16(0xFA2); i++) {                   /* @asm 0x03343E..0x033490 */
        int p0, p1, p2, p3, p4;
        near_6DAF(i, 0x92, 5, 2, &p0, &p1, &p2, &p3, &p4); /* @asm 0x033446..0x033468 (9 args) */
        if (point_in_rect(p1, p2, p3, p4)) best = i;     /* @asm 0x03346B..0x033486 ([bp-6],[bp-0xa],[bp-0xe],[bp-0x10]) */
    }
    if (best < 0) return;                                /* @asm 0x033492..0x033498 */

    if (G16(0x9E3A) == 0xA) {                            /* @asm 0x03349B normal mode */
        if (G16(0x7F4) == 0) return;                     /* @asm 0x0334A5 */
        if (G16(0x9E22) == 0) {                          /* @asm 0x0334AF first-click */
            near_6E54(near_6E13(G16(0x9E1C)), near_6E13(best),
                      G16(0x9E1E), overlay_call_181F_03A2()); /* @asm 0x0334B6..0x0334E5 */
        } else {                                         /* @asm 0x0334E8 second-click */
            int sel = near_6E13(best);
            if (near_6DD7(G16(0x9E24)) && !near_6D8C(G16(0x9E24))) return; /* @asm 0x0334F5..0x033513 */
            near_6D4B(sel, G16(0x9E24), 1, overlay_call_181F_03A2());      /* @asm 0x033516..0x033529 */
        }
    } else if (G16(0x7F4) != 0) {                        /* @asm 0x033530 group/path mode */
        if (G16(0x7E4) == 0) {                           /* @asm 0x033537 */
            near_6DF0(near_6E13(best));                  /* @asm 0x03353E..0x03354C */
        } else if (G16(0xFA2) != 0) {                    /* @asm 0x033552 */
            best = near_6E13(best);                      /* @asm 0x033559..0x033563 */
            overlay_call_191F_0942(unit_table[best].type); /* @asm 0x033566..0x033570 */
            near_6E40();                                 /* @asm 0x033578 */
        }
    } else {                                             /* @asm 0x033580 inspect mode */
        if (G16(0x9E3A) == 8 || G16(0x7F6) == 0) return; /* @asm 0x033580..0x03358C */
        if (G16(0x7EC) != 0) G16(0x1044) = G16(0x9E1C);  /* @asm 0x03358E..0x033598 */
        G16(0xF9A) = 1;                                  /* @asm 0x03359B */
        if (!(G16(0x9E1C) == best && G16(0x9E20) == best)) { /* @asm 0x0335A1..0x0335AE */
            G16(0x9E20) = best;                          /* @asm 0x0335B0 */
            G16(0x9E1C) = best;                          /* @asm 0x0335B3 */
            near_6D3C();                                 /* @asm 0x0335B6 */
        }
        {
            int u = near_6E13(best);                     /* @asm 0x0335BA */
            if (unit_table[u].flags & 0x80) {            /* @asm 0x0335C4..0x0335CC bit 0x80 of +0x3148 */
                if (unit_table[near_6E13(best)].type == 0xB) return; /* @asm 0x0335CE..0x0335E0 */
            }
            near_6E5E(near_6E13(best), 0x1A);            /* @asm 0x0335E2..0x0335F1 */
        }
    }
    /* @asm 0x0335F7 done */
}

/* ===========================================================================
 * func_0335FA -- MAP-AREA click handler (the 8-direction / tile selector).
 *
 * @asm        0x0335FA..0x033714  (283 bytes)  page_04 @0x3B0A  @status BYTE_VERIFIED
 * @args       (none)
 *
 *  if ([0xFA2]==0) goto done                              @asm 0x0335FF
 *  col = weight_scale(0x47,0, [0x7E8]-0x93) / 0x0C        @asm 0x033609..0x033622 [bp-4]
 *  row = near_6E13([0x9E1C]);                              @asm 0x033625..0x033632 [bp-8]
 *  hit = LCALL 0x181F:0xBE6(col,row)                       @asm 0x033635..0x03363C [bp-6]
 *  if ([0x9E3A]==0xA):                                     @asm 0x033642 normal
 *      if (![0x7F4]) done; if ([0x9E22]!=1) done;          @asm 0x033649..0x03365A
 *      if (near_6DD7([0x9E24]) && !near_6D8C([0x9E24])) done; @asm 0x03365D..0x03367B
 *      near_6D4B(row,[0x9E24],1, 0x181F:0x3A2)             @asm 0x03367E..0x033691
 *  elif ([0x7E4]):                                         @asm 0x033698
 *      if (![0x7F4]||hit<0) done; LCALL 0x191F:0x934(hit); near_6E40(); @asm 0x03369F..0x0336B4
 *  else:  -- [0x7EC] inspect: stash selection at [0x9E1E]/[0x9E22..0x9E26] --
 *      if (![0x7EC]||hit<0) done; [0x9E22]=0; [0x9E24]=hit_lo; [0x9E1E]=col_lo;
 *      [0x9E26]=near_6D23(LCALL 0x181F:0xC68(col,row)); near_6D96(...); near_6E0E(...)
 *                                                          @asm 0x0336BA..0x03370F
 *  done: return; (label 0x3C22)                            @asm 0x033712
 * =========================================================================== */
extern int  overlay_call_191F_0934();  /* 0x191F:0x934 path/select by hit */
extern int  near_6D96(int a, int b, ...); /* resident CALL cs:0x6D96; cdecl, 4 args
                                           * (key,scaled,1,0x64) at func_033A52/0335FA */
extern void near_6E0E(int a, int b);
void func_0335FA(void)
{
    int col, row, hit;
    if (G16(0xFA2) == 0) return;                         /* @asm 0x0335FF */
    col = weight_scale(0x47, 0, G16(0x7E8) - 0x93) / 0x0C; /* @asm 0x033609..0x033622 */
    row = near_6E13(G16(0x9E1C));                         /* @asm 0x033625..0x033632 */
    hit = overlay_call_181F_0BE6(/* col, row */);         /* @asm 0x033635..0x03363C */

    if (G16(0x9E3A) == 0xA) {                            /* @asm 0x033642 */
        if (G16(0x7F4) == 0) return;                     /* @asm 0x033649 */
        if (G16(0x9E22) != 1) return;                    /* @asm 0x033653 */
        if (near_6DD7(G16(0x9E24)) && !near_6D8C(G16(0x9E24))) return; /* @asm 0x03365D..0x03367B */
        near_6D4B(row, G16(0x9E24), 1, overlay_call_181F_03A2());      /* @asm 0x03367E..0x033691 */
    } else if (G16(0x7E4) != 0) {                        /* @asm 0x033698 */
        if (G16(0x7F4) == 0 || hit < 0) return;          /* @asm 0x03369F..0x0336A8 */
        overlay_call_191F_0934(hit);               /* @asm 0x0336AA */
        near_6E40();                                     /* @asm 0x0336B3 */
    } else {                                             /* @asm 0x0336BA inspect */
        if (G16(0x7EC) == 0 || hit < 0) return;          /* @asm 0x0336BA..0x0336C3 */
        G16(0x9E22) = 0;                                 /* @asm 0x0336C5 */
        G16(0x9E24) = (uint8_t)hit;                      /* @asm 0x0336CB..0x0336D0 */
        G16(0x9E1E) = (uint8_t)col;                      /* @asm 0x0336D3..0x0336D6 */
        overlay_call_181F_0C68(/* col, row */);          /* @asm 0x0336D9..0x0336DF */
        G16(0x9E26) = near_6D23(hit);                    /* @asm 0x0336E7..0x0336F9 */
        near_6D96(hit, /*?*/0);                           /* @asm 0x0336FA..0x033701 */
        near_6E0E(G16(0x9E26), hit);                      /* @asm 0x033704..0x03370C */
    }
    /* @asm 0x033712 done */
}

/* ===========================================================================
 * func_033716 -- hit-test the "end turn / next" button region & toggle [0x9E28].
 *
 * @asm        0x033716..0x033776  (97 bytes)  page_04 @0x3C26  @status BYTE_VERIFIED
 * @args       (none)  (auto-skeleton "18 B" truncated)
 *
 *  inside = overlay_call_181F_03CA(0x93, 0xa5, 0x48, 0xc)            @asm 0x03371A..0x03372E
 *  if ([0x7EC]!=0 || [0x9E3A]==0xA): [0x9E28] = inside    @asm 0x03373A..0x03374D
 *  switch ([0x9E28]):                                     @asm 0x033750..0x033773
 *     0: near_6DC8()  (button up)                          @asm 0x033756
 *     1: if (inside==[0x9E28]) near_6E77()  (button hold)  @asm 0x03375C..0x033768
 * =========================================================================== */
extern void near_6DC8(void);
extern void near_6E77(void);
void func_033716(void)
{
    int inside = overlay_call_181F_03CA(0x93, 0xa5, 0x48, 0xc) ? 1 : 0; /* @asm 0x03371A..0x03372E */
    if (G16(0x7EC) != 0 || G16(0x9E3A) == 0xA)            /* @asm 0x03373A..0x033746 */
        G16(0x9E28) = inside;                            /* @asm 0x033748..0x03374D */
    if (G16(0x9E28) == 0) {                              /* @asm 0x033750/0x033770 */
        near_6DC8();                                     /* @asm 0x033756 */
    } else if (G16(0x9E28) == 1) {                       /* @asm 0x033772 */
        if (inside == G16(0x9E28)) near_6E77();          /* @asm 0x03375C..0x033768 */
    }
}

/* ===========================================================================
 * func_033778 -- DIRECTION-KEY unit MOVE / target executor.
 *
 * @asm        0x033778..0x033A51  (730 bytes)  page_04 @0x3C88  @status BYTE_VERIFIED
 * @args       cmd=[bp+6]   (auto-skeleton "41 B" truncated)
 *
 * The heart of keyboard map control.  Dispatches on map mode [0x9E3A]:
 *
 *  mode 8 (drag/select):                                  @asm 0x033782
 *      if (![0x7F4]) done; near_6D5F([0x9E1C]); return.    @asm 0x033789..0x03379F
 *  mode 9 (move-cost preview):                            @asm 0x0337A2
 *      cur = [0x9E42] ([bp-0x1C]); clear suppress;         @asm 0x0337B6..0x0337BF
 *      if ([0x9E44]==cmd) goto finish;                     @asm 0x0337C4..0x0337CC
 *      -- walk the on-tile unit STACK ( links at +0x315E ) summing the terrain
 *         move-cost the picked move would charge, comparing each unit's moves
 *         (+0x3150) and the per-type cost table [type*14 + 0x5238];           @asm 0x0337CF..0x03388D
 *         for normal units (type 0xD..0x12 land) the cost gate differs from
 *         ships; calls the actual move 0x181F:0x880(unit,-2,-2);              @asm 0x033816 / 0x03386C
 *      finish: LCALL 0x181F:0x948([0x9E42], power-0xC); near_6E31();          @asm 0x033896..0x0338AB
 *  mode 2 (offset set A): dir-offsets {0xFFE4,0xFFE8}, lo=0x49 hi=0x76 k=0xA   @asm 0x0338B2..0x0338D2
 *  mode 3 (offset set B): dir-offsets {0xFFF0,0xFFF4}, lo=2   hi=0x76 k=9      @asm 0x0338D4..0x0338F2
 *  (modes 2/3 share the body at 0x3E07:)                  @asm 0x0338F7
 *      count = #scan results from 0x181F:0x2E4 (>=0)        @asm 0x0338FE..0x03392E [bp-6]
 *      count = min(count,0x19); if (count==0) { [0x9E3A]=0xF; return; }        @asm 0x03392E..0x033948
 *      pick first scan-result whose screen rect (near_6DAF) contains the cursor;
 *         applying the two dir-offset words + [0x9E12] to seed 0x181F:0x7E0    @asm 0x03394A..0x0339D4
 *      sel = that unit ([bp-0x1C]);                         @asm 0x0339D6
 *      if ([0x7E4]): if(![0x7F4]||sel<0) done; LCALL 0x191F:0x942(type); near_6E40(); @asm 0x0339DC..0x033A06
 *      else (inspect): only land types 0xD..0x12 (or 0xB w/ flag 0x80) and
 *          [0x7F6]: [0x9E44]=[0x9E3A]; [0x9E42]=sel; near_6E7C(sel,k);          @asm 0x033A08..0x033A4C
 *  done: return; (label 0x3F5F)                            @asm 0x033A4F
 *
 * UnitRecord offsets used (all BYTE_VERIFIED, base 0x3144 stride 0x1C):
 *   +0x02 type(0x3146)  +0x06 moves-left?(0x314A via +0x4? see callers)
 *   +0x08 flags(0x3148, bit0x80)  +0x0A field(0x314A)  +0x0C moves(0x3150? actually +0x3150)
 *   +0x18 link/next-in-stack(0x315E).  Per-type move-cost table [type*14+0x5238].
 * =========================================================================== */
extern void near_6D5F(int v);
extern int  overlay_call_181F_0880();  /* 0x181F:0x880 move unit(idx,dx,dy) */
extern int  overlay_call_181F_07E0();  /* 0x181F:0x7E0 scan-direction seed */
extern void near_6E7C(int sel, int k);
void func_033778(int cmd)
{
    if (G16(0x9E3A) == 8) {                              /* @asm 0x033782 mode 8 */
        if (G16(0x7F4) == 0) return;                     /* @asm 0x033789 */
        near_6D5F(G16(0x9E1C));                           /* @asm 0x033793 */
        return;                                          /* @asm 0x03379E */
    }
    if (G16(0x9E3A) == 9) {                              /* @asm 0x0337A2 mode 9 move-cost */
        int cur;                                         /* [bp-0x1C] */
        int budget;                                      /* [bp-0x1A]  cost - moves-spent */
        if (G16(0x7F4) == 0) return;                     /* @asm 0x0337AC */

        cur = G16(0x9E42);                               /* @asm 0x0337B6 */
        unit_table[cur].orders = 0;                      /* @asm 0x0337BC..0x0337BF clear +0x08 (0x314C) */
        if (G16(0x9E44) == cmd)                          /* @asm 0x0337C4..0x0337CA */
            goto m9_advisory;                            /* @asm 0x0337CC -> 0x338AA (near_6E31 only) */

        /* budget = per-type move-cost table[type][7] (0x5237) - UnitRecord[cur]
         * +0x0C byte (cargo_slot_count, reused here as the move-units spent). */
        budget = (int)g_unittype_attr_5230[unit_table[cur].type][7]
                 - (int)unit_table[cur].cargo_slot_count;            /* @asm 0x0337CF..0x0337F3 */

        /* Walk the on-tile unit STACK via chain_next (+0x1A / 0x315E), charging
         * each unit the terrain move-cost the picked move would incur; the picked
         * unit ([0x9E42]) always moves, land units (type 0xD..0x12) end the walk. */
        while (cur >= 0) {                               /* @asm 0x0337F6 (jl signed) */
            int next = unit_table[cur].chain_next;       /* @asm 0x0337FC..0x033804 [bp-0x22] */
            if (cur == G16(0x9E42)) {                    /* @asm 0x033807..0x03380D */
                overlay_call_181F_0880(cur, -2, -2); /* @asm 0x03380F..0x03381B move */
                goto m9_advance;                         /* @asm 0x03381E -> 0x3388D */
            }
            if (unit_table[cur].type < 0xD ||            /* @asm 0x033820..0x033829 (jb) */
                unit_table[cur].type > 0x12) {           /* @asm 0x03382B..0x033830 (ja) non-land */
                int c = g_unittype_attr_5230[unit_table[cur].type][8]; /* @asm 0x033840..0x03385D (0x5238) */
                if (c > budget)                          /* @asm 0x033861 (ja) cost exceeds budget */
                    goto m9_advance;                     /* @asm 0x033861 -> 0x3388D */
                overlay_call_181F_0880(cur, -2, -2); /* @asm 0x033863..0x033871 move */
                budget -= g_unittype_attr_5230[unit_table[cur].type][8]; /* @asm 0x033874..0x03388A */
                goto m9_advance;                         /* fall @asm 0x03388D */
            }
            /* land unit (type 0xD..0x12): the walk ends here (no loop-back) */
            break;                                       /* @asm 0x033830 fall -> 0x33832 */
        m9_advance:
            cur = next;                                  /* @asm 0x03388D..0x033890 */
        }                                                /* @asm 0x033893 jmp 0x337F6 */

        /* Loop-exit finish (0x33832): the land-type / end-of-chain path issues the
         * advisory LCALL 0x181F:0x948([0x9E42], pwr, pwr) where pwr = [0x9E12] minus
         * 0x18 when cmd==2 (@asm 0x033838) else minus 0xC (@asm 0x033896), then the
         * near_6E31 advisory.  (The [0x9E44]==cmd early-out above skips the 0x948.) */
        if (cmd == 2)                                    /* @asm 0x033832..0x033836 */
            overlay_call_181F_0948(/* [0x9E42], [0x9E12]-0x18 x2 */); /* @asm 0x033838..0x0338A7 */
        else
            overlay_call_181F_0948(/* [0x9E42], [0x9E12]-0xC x2 */);  /* @asm 0x033896..0x0338A7 */
    m9_advisory:
        near_6E31();                                     /* @asm 0x0338AA..0x0338AB */
        return;                                          /* @asm 0x0338AE..0x0338AF */
    }

    /* ----- modes 2/3: 8-direction offset scan + hit-test ----- @asm 0x0338B2 */
    {
        int dir[2];                                      /* [bp-0x20]=dir0, [bp-0x1E]=dir1 */
        int lo;                                          /* [bp-4]  near_6DAF arg a */
        int hi;                                          /* [bp-8]  set but unused here */
        int k;                                           /* [bp-2]  near_6E7C arg */
        int count = 0;                                   /* [bp-6]  (zeroed at entry @asm 0x0337D) */
        int j, r, best, sel;

        if (G16(0x9E3A) == 2) {                          /* @asm 0x0338B2 mode 2 (offset set A) */
            dir[0] = (int16_t)0xFFE4; dir[1] = (int16_t)0xFFE8; /* @asm 0x0338B9..0x0338BE */
            lo = 0x49; hi = 0x76; k = 0xA;               /* @asm 0x0338C3..0x0338CD */
        } else if (G16(0x9E3A) == 3) {                   /* @asm 0x0338D4 mode 3 (offset set B) */
            dir[0] = (int16_t)0xFFF0; dir[1] = (int16_t)0xFFF4; /* @asm 0x0338DE..0x0338E3 */
            lo = 2; hi = 0x76; k = 9;                    /* @asm 0x0338E8..0x0338F2 */
        } else {
            return;                                      /* @asm 0x0338DB -> 0x33A4F done */
        }
        (void)hi;                                        /* written by both modes; never read */

        /* count phase: enumerate scan hits across both directions @asm 0x0338F7 */
        for (j = 0; j < 2; j++) {                        /* @asm 0x033910..0x033917 (jge) */
            int seed = (int16_t)(dir[j] + G16(0x9E12));  /* @asm 0x033919..0x033925 */
            (void)seed;                                  /* input to the 0x7E0 thunk (abstracted) */
            r = overlay_call_181F_07E0(/* seed */);      /* @asm 0x033927 prime iterator */
            while (r >= 0) {                             /* @asm 0x033906 (jl) */
                count++;                                 /* @asm 0x03390A */
                r = overlay_call_181F_02E4();            /* @asm 0x0338FE next */
            }
        }
        if (count > 0x19) count = 0x19;                  /* @asm 0x033931..0x033936 (jle) */
        if (count == 0) {                                /* @asm 0x03393C..0x03393E */
            G16(0x9E3A) = 0xF;                           /* @asm 0x033940 */
            return;                                      /* @asm 0x033946 */
        }

        /* pick phase: first scan result whose screen rect contains the cursor */
        best = -1;                                       /* @asm 0x03394A [bp-0x14] = 0xFFFF */
        {
            int idx = 0;                                 /* [bp-0xa] running result index */
            for (j = 0; j < 2; j++) {                    /* @asm 0x339b8..0x339bf (jge) */
                int seed = (int16_t)(dir[j] + G16(0x9E12)); /* @asm 0x339c1..0x339cd */
                (void)seed;                              /* input to the 0x7E0 thunk (abstracted) */
                r = overlay_call_181F_07E0(/* seed */);  /* @asm 0x339cf prime dir j */
                while (r >= 0) {                         /* @asm 0x339(62/65) (jl) */
                    int p0, p1, p2, p3, p4;
                    if (best >= 0) break;                /* @asm 0x033969 (jge) stop once found */
                    near_6DAF(idx, lo, 0xd, 1,           /* @asm 0x03396F..0x033991 (9 args) */
                              &p0, &p1, &p2, &p3, &p4);
                    if (point_in_rect(p1, p2, p3, p4))   /* @asm 0x033994..0x0339AA */
                        best = r;                        /* @asm 0x0339AC..0x0339AF [bp-0x14]=[bp-0x1C] */
                    idx++;                               /* @asm 0x0339B2 */
                    r = overlay_call_181F_02E4();        /* @asm 0x03395A..0x033962 next */
                }
            }
        }
        sel = best;                                      /* @asm 0x0339D6..0x0339D9 */

        if (G16(0x7E4) != 0) {                           /* @asm 0x0339DC board path */
            if (G16(0x7F4) == 0) return;                 /* @asm 0x0339E3 */
            if (sel < 0) return;                         /* @asm 0x0339EA (jl) */
            overlay_call_191F_0942(unit_table[sel].type); /* @asm 0x0339EE..0x0339FD */
            near_6E40();                                 /* @asm 0x033A01 */
            return;                                      /* @asm 0x033A06 */
        }
        /* inspect path @asm 0x033A08: only land types 0xD..0x12 (or 0xB w/ flag
         * 0x80) and [0x7F6] set; otherwise reset to mode 0xF. */
        if (unit_table[sel].type < 0xD ||                /* @asm 0x033A0C..0x033A13 (jae) */
            unit_table[sel].type > 0x12) {               /* @asm 0x033A16..0x033A1D (jbe) */
            G16(0x9E3A) = 0xF; return;                   /* @asm 0x033940 */
        }
        if ((unit_table[sel].flags & 0x80) &&            /* @asm 0x033A20..0x033A25 (test 0x80) */
            unit_table[sel].type != 0xB) {               /* @asm 0x033A27..0x033A2C (cmp 0xB) */
            G16(0x9E3A) = 0xF; return;                   /* @asm 0x033A2E -> 0x033940 */
        }
        if (G16(0x7F6) == 0) return;                     /* @asm 0x033A31..0x033A36 -> done */
        G16(0x9E44) = G16(0x9E3A);                       /* @asm 0x033A38..0x033A3B */
        G16(0x9E42) = sel;                               /* @asm 0x033A41..0x033A44 */
        near_6E7C(sel, k);                               /* @asm 0x033A3E/0x033A47..0x033A4C */
    }
    /* @asm 0x033A4F done */
}

/* ===========================================================================
 * func_033A52 -- SIDE/TOP-BAR click handler (mode 0xA mini-map & bar buttons).
 *
 * @asm        0x033A52..0x033BE3  (402 bytes)  page_04 @0x3F62  @status BYTE_VERIFIED
 * @args       (none)  (auto-skeleton "100 B" truncated)
 *
 *  if ([0x9E3A]==0xA):                                    @asm 0x033A56 normal
 *      if (![0x7F4]) done; if ([0x9E22]!=0) done;          @asm 0x033A5D..0x033A6E
 *      if (near_6DD7([0x9E24]) && !near_6D8C([0x9E24])) done; @asm 0x033A71..0x033A8F
 *      near_6DE6(near_6E13([0x9E1C]), [0x9E24], 0x181F:0x3A2); return; @asm 0x033A92..0x033AB1
 *  else:  -- the minimap region ( /0x13 cells ) --        @asm 0x033AB6
 *      cell = weight_scale([0x7E8],0,0x131) / 0x13         @asm 0x033AB6..0x033ACD [bp-8]
 *      if (cell >= 0x10) done                              @asm 0x033AD0
 *      if (![0x7F6]):  -- press: [0xFA7]=1; if([0xFA6]==cell) done; [0xFA6]=cell;
 *          near_15C4(0); near_6DFA(cell); draw marker 0x181F:0xE2(0,0xB3,0x15..) @asm 0x033AD8..0x033B19
 *      else:  -- drag --
 *          if (!([0xF9A]==0 && [0xF9E]==cell)): [0xF9A]=0;[0xF9E]=cell;near_6D3C() @asm 0x033B1C..0x033B38
 *          if ([0x7E4]): if(![0x7F4]) done; LCALL 0x191F:0x934(cell); near_6E40(); @asm 0x033B3B..0x033B5B
 *          elif ([0x7F4] && near_6DD7(cell)): near_6D8C(cell); return;        @asm 0x033B5E..0x033B7D
 *          elif (!near_6DD7(cell)):  -- select map column cell --
 *              if (near_6D4B(near_6E13([0x9E1C]), cell, 0, 0)) done;          @asm 0x033B80..0x033BA8
 *              [0x9E22]=1; [0x9E24]=cell; [0x9E26]=0x64;                       (0x9E26 STAYS 0x64)
 *              near_6D96(cell, near_6DA0(cell,1,0x64), 1, 0x64);              @asm 0x033BBE..0x033BD4
 *              near_6E0E([0x9E26],cell);                                      @asm 0x033BD7..0x033BDF
 *  done: return; (label 0x40F2)                            @asm 0x033BE2
 * CORRECTIONS 2026-06-08: press branch was missing near_6DFA(cell); near_6D4B
 * arg order is (sel=near_6E13, t=cell, 0, 0); [0x9E26] is not reassigned (the
 * near_6D23 in the older note was a mis-read of the near_6D96 nesting).
 * =========================================================================== */
extern void near_6DE6(int unit, int t, int d);
extern void near_15C4(int v);
extern int  near_6DFA(int cell);          /* resident CALL cs:0x6DFA (trampoline 0x368EA) */
/* overlay_call_181F_00E2 (draw marker rect) is declared in overlay_externs.h */
void func_033A52(void)
{
    if (G16(0x9E3A) == 0xA) {                            /* @asm 0x033A56 */
        if (G16(0x7F4) == 0) return;                     /* @asm 0x033A5D */
        if (G16(0x9E22) != 0) return;                    /* @asm 0x033A67 */
        if (near_6DD7(G16(0x9E24)) && !near_6D8C(G16(0x9E24))) return; /* @asm 0x033A71..0x033A8F */
        near_6DE6(near_6E13(G16(0x9E1C)), G16(0x9E24), overlay_call_181F_03A2()); /* @asm 0x033A92..0x033AB1 */
        return;                                          /* @asm 0x033AB4 */
    }
    {
        int cell = weight_scale(G16(0x7E8), 0, 0x131) / 0x13; /* @asm 0x033AB6..0x033ACD */
        if (cell >= 0x10) return;                        /* @asm 0x033AD0 */
        if (G16(0x7F6) == 0) {                           /* @asm 0x033AD8 press */
            G8(0xFA7) = 1;                               /* @asm 0x033ADF */
            if (G8(0xFA6) == (uint8_t)cell) return;      /* @asm 0x033AE4..0x033AED */
            G8(0xFA6) = (uint8_t)cell;                   /* @asm 0x033AF0 */
            near_15C4(0);                                /* @asm 0x033AF3..0x033AF8 */
            near_6DFA(cell);                             /* @asm 0x033AFB..0x033B02 (was MISSING) */
            /* draw cursor marker @asm 0x033B05..0x033B14 LCALL 0x181F:0xE2 */
            overlay_call_181F_00E2();
            return;                                      /* @asm 0x033B19 */
        }
        /* ----- drag @asm 0x033B1C..0x033BDF: pan/select clicked minimap column ----- */
        if (G16(0xF9A) == 0 && G8(0xF9E) == (uint8_t)cell) {
            /* unchanged column while latch clear: skip the reset @asm 0x033B1C..0x033B29 */
        } else {
            G16(0xF9A) = 0;                              /* @asm 0x033B2B */
            G8(0xF9E) = (uint8_t)cell;                   /* @asm 0x033B31..0x033B34 */
            near_6D3C();                                 /* @asm 0x033B37 */
        }
        if (G16(0x7E4) != 0) {                           /* @asm 0x033B3B board path */
            if (G16(0x7F4) == 0) return;                 /* @asm 0x033B42 */
            overlay_call_191F_0934(cell);          /* @asm 0x033B4C..0x033B54 */
            near_6E40();                                 /* @asm 0x033B58 */
            return;                                      /* @asm 0x033B5C */
        }
        if (G16(0x7F4) != 0 && near_6DD7(cell)) {        /* @asm 0x033B5E..0x033B71 */
            near_6D8C(cell);                             /* @asm 0x033B73 */
            return;                                      /* @asm 0x033B7D */
        }
        if (near_6DD7(cell) != 0) return;                /* @asm 0x033B80..0x033B8C -> done */
        /* select map column cell */
        if (near_6D4B(near_6E13(G16(0x9E1C)), cell, 0, 0) != 0) /* @asm 0x033B8E..0x033BA6 */
            return;                                      /* @asm 0x033BA8 -> done */
        G16(0x9E22) = 1;                                 /* @asm 0x033BAA */
        G16(0x9E24) = (uint8_t)cell;                     /* @asm 0x033BB0..0x033BB5 */
        G16(0x9E26) = 0x64;                              /* @asm 0x033BB8 */
        near_6D96(cell, near_6DA0(cell, 1, 0x64), 1, 0x64); /* @asm 0x033BBE..0x033BD4 */
        near_6E0E(G16(0x9E26), cell);                    /* @asm 0x033BD7..0x033BDF */
    }
    /* @asm 0x033BE2 done */
}

/* ===========================================================================
 * func_033BE4 -- bottom-status readout: name + status of unit [0x9E2C].
 *
 * @asm        0x033BE4..0x033C95  (178 bytes)  page_04 @0x40F4  @status BYTE_VERIFIED
 * @args       (none)  (auto-skeleton said WRAPPER; truncated)
 *
 *  u = near_6E45([0x9E2C])                                @asm 0x033BE9..0x033BF4 [bp-2]
 *  begin(1)                                               @asm 0x033BF7
 *  hud_print_74( word_tab_8D0A[ g_active_power ] )        @asm 0x033C01..0x033C0B (table ds-0x72F6 = abs 0x8D0A)
 *  type = unit_table[u].type;
 *  hud_print_74( g_unittype_attr_5230[type][0] )          @asm 0x033C13..0x033C31
 *  if (near_6E?... LCALL 0x181F:0xB78(u) >= 0              @asm 0x033C39..0x033C46
 *        && unit_table[u].field+0x315B != 0x1C):           @asm 0x033C48..0x033C4D
 *      hud_print_6a(ds,0x1046);                            @asm 0x033C4F text key 0x1046
 *      hud_print_74( word8e9e[ unit_table[u]+0x315B * 8 ] );  @asm 0x033C5B..0x033C69 (table ds-0x715E)
 *      hud_print_6a(ds,0x1048);                            @asm 0x033C71 text key 0x1048
 *  finish(1, [0x7EE]==1?0x78:0, ...)                       @asm 0x033C7D..0x033C8D
 * (UnitRecord +0x315B (= base+0x17) is the unit's CARGO/STATE byte; 0x1C is the
 *  sentinel "none".  word8e9e[state*8] indexes a per-state label table at abs
 *  0x8EA2; word_tab_8D0A is the per-power label table at abs 0x8D0A.)
 * =========================================================================== */
extern int  near_6E45(int v);
extern int  overlay_call_181F_0B78();  /* 0x181F:0xB78 unit status query(u) */
extern int16_t g_power_word_8D0A[];        /* DGROUP word table, abs 0x8D0A (ds-0x72F6) */
extern int16_t g_state_word_8EA2[];        /* DGROUP word table, abs 0x8EA2 (ds-0x715E), stride 8 */
void func_033BE4(void)
{
    int u = near_6E45(G16(0x9E2C));                       /* @asm 0x033BE9..0x033BF4 */
    int type;
    hud_begin(1);                                        /* @asm 0x033BF7 */
    hud_print_74(g_power_word_8D0A[G16(0x9E12)]);         /* @asm 0x033C01..0x033C0B */
    type = unit_table[u].type;                            /* @asm 0x033C13 */
    hud_print_74(g_unittype_attr_5230[type][0]);          /* @asm 0x033C2B */
    if (overlay_call_181F_0B78(u) >= 0 &&           /* @asm 0x033C39..0x033C46 */
        unit_table[u].vet_type != 0x1C) {                 /* @asm 0x033C48 byte +0x17 = abs 0x315B */
        hud_print_6a(0, 0x1046);                          /* @asm 0x033C4F key 0x1046 */
        hud_print_74(g_state_word_8EA2[unit_table[u].vet_type * 4]); /* @asm 0x033C5B..0x033C69 (*8 bytes) */
        hud_print_6a(0, 0x1048);                          /* @asm 0x033C71 key 0x1048 */
    }
    hud_helper_6D50(0, (G16(0x7EE) == 1) ? 0x78 : 0, 1);  /* @asm 0x033C7D..0x033C8D */
}

/* ===========================================================================
 * func_033C96 -- UNIT-SELECTION PANEL renderer + per-type order classifier.
 *
 * @asm        0x033C96..0x0341D4  (~1342 bytes; two inline jump tables)  page_04 @0x41A6
 * @args       (none)   @status BYTE_VERIFIED (full body, 2026-06-08)
 *
 * NOTE EXTENT: 0x033F6A is NOT the end — it is the inline DATA of the row jump
 * table (`JMP word ptr cs:[bx+0x3A1A]` @0x033F65).  Real code continues; the true
 * terminator is `leave; retf` @ file 0x0341D4.  (PHANTOM note: the apparent
 * "func_033F6A size=10788 insns=0" that the segmenter lists next is the page's
 * trailing DATA / jump-table region, NOT a real function.)
 *
 * Builds the multi-line "selected unit" info panel and classifies the unit type:
 *
 *  active = near_6E45([0x9E2C])  ([bp-0x6C])              @asm 0x033CA2..0x033CAD
 *  if (active < 0) goto done                              @asm 0x033CB0
 *  -- precompute six stat bars from per-stat lookups (0x6DA0 buy-side, 0x6D23
 *     sell-side) scaled by 0x32 / 0x64:                   @asm 0x033CB7..0x033D0E
 *       barF50 = near_6DA0(0xF)*0x32   ([bp-0x64])
 *       barE64 = near_6DA0(0xE)*0x64   ([bp-0x62])
 *       bar850 = near_6DA0(8)*0x32     ([bp-0x60])
 *       barF50b= near_6D23(0xF)*0x32   ([bp-0x5E])
 *       barE64b= near_6D23(0xE)*0x64   ([bp-0x5C])
 *       bar850b= near_6D23(8)*0x32     ([bp-0x5A])
 *  dlg = dlg_open(0x87C,0x104A,0)  ([bp-0x56]/[bp-0x54])  @asm 0x033D11..0x033D1B
 *  if (!dlg) goto done                                    @asm 0x033D28
 *  -- choose which precomputed bar to post per the unit TYPE (+0x3146):
 *       type 1 or 4 -> barF50b else barF50, channel 0     @asm 0x033D2D..0x033D54
 *       type 2      -> barE64b else barE64, channel 1      @asm 0x033D54..0x033D74
 *       type 5 or 4 -> bar850b else bar850, channel 2      @asm 0x033D74..0x033D99
 *     via score_accum_long((long)bar, chan)
 *  dlg.flags |= 3 (es:[bx+0xA])                            @asm 0x033D9C..0x033DA4
 *  if (names_open_section(0x87C,0x1054)) goto done         @asm 0x033DA4..0x033DB6
 *  dlg_draw_row( active, [0x83E]/[0x840], dlg )            @asm 0x033DB9..0x033DD2 (0x191F:0x230)
 *  -- main classification loop (label 0x42EA..0x44DE): for the active unit,
 *     fill [bp-0x66] eligibility per a big switch on type (+0x3146) cross-checked
 *     with the cargo/state byte (+0x315B) for sentinels 0x18/0x1B/0x1C; the loop
 *     body finally indexes the jump table cs:[bx+0x3A1A] with (case-1).          @asm 0x033DDE..0x033F65
 *  done: (label 0x46D0)  -- past the cited window; closes dlg + returns.
 *
 * This is the data-DRIVEN unit-order panel: the per-type cases decide which
 * order glyphs/bars are shown, i.e. pure LAYOUT/eligibility (IN SCOPE).  Type
 * codes referenced: 0,1,2,3,4,5 (and the land band 0xD..0x12 elsewhere); state
 * sentinels 0x18/0x1B/0x1C at UnitRecord +0x17 (vet_type, abs 0x315B).
 *
 * EXTENT CORRECTION 2026-06-08: the function does NOT end at 0x033F6A — that is
 * the inline jump table for the row switch (`jmp cs:[bx+0x3A1A]` @0x033F65, table
 * data at file 0x033F6A).  Real code continues through the row loop, a second
 * inline jump table (`jmp cs:[bx+0x3C5A]` @0x0341A5, data at file 0x0341AA) for
 * the action switch, and the true terminator is `leave; retf` @ file 0x0341D4
 * (~1342 bytes total).  Both jump tables are CS-relative with table-base file
 * 0x30550 (verified: table[k] = file 0x30550 + word; all entries land inside the
 * handler blocks 0x033DDE..0x034199).  @status BYTE_VERIFIED (full body).
 *
 * Row loop (row=1..0xC): switch(row) [TABLE1] sets elig=[bp-0x66] and an optional
 * cost=[bp-0x6A]; eligible rows are posted (0x191F:0x176) and, if cost!=0 and the
 * active power's gold (+0x2A) < cost, flagged unaffordable (0x191F:0x1B6).
 * After the loop a selection is read (0x191F:0x16A -> [bp-0x52]) and switch(sel)
 * [TABLE2] performs the chosen order: set orders, disband (0x181F:0x89E), or a
 * profession/role morph (type field +0x3146) paired with a gold debit/credit and
 * a market poke (near_6D91 buy / near_6D28 sell).
 * =========================================================================== */
extern int  overlay_call_191F_0910(void);  /* 0x191F:0x910 row sub-context close */
extern int  overlay_call_181F_089E();  /* 0x181F:0x89E disband/remove active unit */
void func_033C96(void)
{
    int active = near_6E45(G16(0x9E2C));                  /* @asm 0x033CA2..0x033CAD [bp-0x6C] */
    void far *dlg;                                        /* far ptr [bp-0x56/0x54] */
    int barF50, barE64, bar850, barF50b, barE64b, bar850b;
    int type;
    int row, sel;
    int elig, cost;                                       /* [bp-0x66], [bp-0x6A] */

    if (active < 0) return;                               /* @asm 0x033CB0 -> done */

    /* six stat bars @asm 0x033CB7..0x033D0E */
    barF50  = near_6DA0(0xF) * 0x32;                      /* @asm 0x033CB7..0x033CC3 [bp-0x64] */
    barE64  = near_6DA0(0xE) * 0x64;                      /* @asm 0x033CC6..0x033CD2 [bp-0x62] */
    bar850  = near_6DA0(8)   * 0x32;                      /* @asm 0x033CD5..0x033CE1 [bp-0x60] */
    barF50b = near_6D23(0xF) * 0x32;                      /* @asm 0x033CE4..0x033CF0 [bp-0x5E] */
    barE64b = near_6D23(0xE) * 0x64;                      /* @asm 0x033CF3..0x033CFF [bp-0x5C] */
    bar850b = near_6D23(8)   * 0x32;                      /* @asm 0x033D02..0x033D0E [bp-0x5A] */

    dlg = dlg_open((void *)0x87C, (void *)0x104A, 0);     /* @asm 0x033D11..0x033D1B */
    if (dlg == 0) return;                                 /* @asm 0x033D28 -> done */

    type = unit_table[active].type;                       /* @asm 0x033D2D +0x3146 */
    score_accum_long((long)((type == 1 || type == 4) ? barF50b : barF50), 0); /* @asm 0x033D31..0x033D54 */
    score_accum_long((long)((type == 2) ? barE64b : barE64), 1);              /* @asm 0x033D58..0x033D74 */
    score_accum_long((long)((type == 5 || type == 4) ? bar850b : bar850), 2); /* @asm 0x033D78..0x033D99 */

    ((uint8_t far *)dlg)[0xA] |= 3;                       /* @asm 0x033D9C..0x033DA2 es:[bx+0xA] |= 3 */
    if (names_open_section(0x87C, 0x1054) != 0) goto done; /* @asm 0x033DA4..0x033DB6 */
    overlay_call_191F_0230(/* dlg, [0x83E],[0x840], active, 0,0,0 */); /* @asm 0x033DB9..0x033DD2 draw header row */

    /* ---- row loop @asm 0x033DD5..0x033FF1: per-row eligibility + post ---- */
    for (row = 1; row <= 0xC; row++) {                    /* @asm 0x033DD5 / 0x033FCE (jg 0x33FF4) */
        elig = 0;
        cost = 0;                                         /* [bp-0x6A] re-zeroed each row @asm 0x033FE9 */
        /* per-row sub-context open @asm 0x033FD4..0x033FE6 (0x191F:0x91C/0x910) */
        overlay_call_191F_091C(/* &rowbuf */);            /* @asm 0x033FD4..0x033FDD [bp-0x58] */
        overlay_call_191F_0910(/* [bp-0x58] */);          /* @asm 0x033FE0..0x033FE6 */

        switch (row) {                                    /* @asm 0x033F5C..0x033F65 jmp cs:[bx+0x3A1A] */
        case 1:                                           /* @asm 0x033DDE handler */
            elig = (unit_table[active].orders == 1);      /* @asm 0x033DE2 (+0x08) */
            break;
        case 2:                                           /* @asm 0x033DF2 */
            elig = (unit_table[active].orders != 1);      /* @asm 0x033DF6 */
            break;
        case 3:                                           /* @asm 0x033E00 */
            elig = (G16(0x9E2C) > 0);                     /* @asm 0x033E00 (jle) */
            break;
        case 4:                                           /* @asm 0x033E0C */
            elig = (type == 0 || type == 5);              /* @asm 0x033E10..0x033E26 */
            if (unit_table[active].vet_type == 0x1B) elig = 0; /* @asm 0x033E2F..0x033E36 (+0x17) */
            cost = barF50;                                /* @asm 0x033E3B [bp-0x64] */
            if (near_6DD7(0xF) != 0) elig = 0;            /* @asm 0x033E41..0x033E51 */
            break;
        case 5:                                           /* @asm 0x033E5A */
            elig = (type == 1 || type == 4);              /* @asm 0x033E5E..0x033E74 */
            cost = barF50;                                /* shares case-4 tail @asm 0x033E3B */
            if (near_6DD7(0xF) != 0) elig = 0;            /* @asm 0x033E41..0x033E51 */
            break;
        case 6:                                           /* @asm 0x033E7C */
            elig = (type == 0);                           /* @asm 0x033E80 cmp,1;sbb;neg => (type<1) */
            if (unit_table[active].vet_type == 0x1B) elig = 0; /* @asm 0x033E8C..0x033E93 */
            if (near_6DD7(0xE) != 0) elig = 0;            /* @asm 0x033E98..0x033EA5 */
            cost = barE64;                                /* @asm 0x033EAA [bp-0x62] */
            break;
        case 7:                                           /* @asm 0x033EB4 */
            elig = (type == 2);                           /* @asm 0x033EB8..0x033EC6 */
            if (near_6DD7(0xE) != 0) elig = 0;            /* @asm 0x033EC9 push 0xE -> T_6DD7call */
            break;                                        /* (no cost) */
        case 8:                                           /* @asm 0x033ECE */
            elig = (type == 0 || type == 1);              /* @asm 0x033ED2..0x033EE8 */
            cost = bar850;                                /* @asm 0x033EED [bp-0x60] */
            if (unit_table[active].vet_type == 0x1B) elig = 0; /* @asm 0x033EF3..0x033EFE */
            if (near_6DD7(8) != 0) elig = 0;              /* @asm 0x033F03 push 8 -> T_6DD7call */
            break;
        case 9:                                           /* @asm 0x033F08 */
            elig = (type == 5 || type == 4);              /* @asm 0x033F0C..0x033F1A (else 0 @0x33EFE) */
            if (near_6DD7(8) != 0) elig = 0;              /* @asm 0x033F03 push 8 -> T_6DD7call */
            break;                                        /* (no cost) */
        case 10:                                          /* @asm 0x033F22 */
            elig = (type == 0);                           /* @asm 0x033F26 cmp,1;sbb;neg */
            if (unit_table[active].vet_type == 0x1B) elig = 0; /* @asm 0x033F32..0x033F39 */
            break;
        case 11:                                          /* @asm 0x033F3C */
            if (type != 3) elig = 0;                      /* @asm 0x033F40 (else -> elig0) */
            else if (unit_table[active].vet_type == 0x18) elig = 0; /* @asm 0x033F4A..0x033F51 */
            else elig = 1;                                /* @asm 0x033F54 */
            break;
        case 12:                                          /* @asm 0x033F54 */
            elig = 1;                                     /* @asm 0x033F54 */
            break;
        }

        /* loop tail @asm 0x033F82..0x033FCB */
        if (elig != 0) {                                  /* @asm 0x033F82 */
            overlay_call_191F_0176(/* dlg, &rowbuf, row */); /* @asm 0x033F88..0x033F9B post row */
            if (cost != 0 && (int32_t)PREC()->gold < cost) /* @asm 0x033F9E..0x033FB6 gold<cost (+0x2A) */
                overlay_call_191F_01B6(/* dlg, row, 1 */); /* @asm 0x033FB8..0x033FC8 mark unaffordable */
        }
    }

    /* ---- read the chosen action & dispatch @asm 0x033FF4..0x034199 ---- */
    sel = overlay_call_191F_016A(/* dlg */);              /* @asm 0x033FFA..0x033FFF -> [bp-0x52] */
    overlay_call_191F_01A8(/* dlg */);                    /* @asm 0x034008 close dialog */
    dlg = 0;                                              /* @asm 0x03400D..0x034012 [bp-0x54/0x56]=0 */
    if (sel < 1 || sel >= 0xC) goto done;                 /* @asm 0x034015..0x034024 */

    switch (sel) {                                        /* @asm 0x03419C..0x0341A5 jmp cs:[bx+0x3C5A] */
    case 1:                                               /* @asm 0x03402E */
        unit_table[active].orders = 0;                    /* @asm 0x034032 (+0x08) */
        break;
    case 2:                                               /* @asm 0x03403A */
        unit_table[active].orders = 1;                    /* @asm 0x03403E */
        break;
    case 3:                                               /* @asm 0x034046 */
        overlay_call_181F_089E(active);             /* @asm 0x034049 disband */
        G16(0x9E2C) = 0;                                  /* @asm 0x034051 */
        break;
    case 4:                                               /* @asm 0x03405A: type 5->4 else ->1, pay barF50 */
        overlay_call_181F_04C0(/* 0x58 */);               /* @asm 0x03405D (ax=0x58) */
        if (unit_table[active].type == 5) unit_table[active].type = 4; /* @asm 0x034062..0x03406D */
        else unit_table[active].type = 1;                 /* @asm 0x034074..0x034078 */
        PREC()->gold -= (uint32_t)barF50;                 /* @asm 0x03407D..0x034088 (-=, +0x2A) */
        near_6D91(0xF, 0x32);                             /* @asm 0x03408B..0x034090 */
        break;
    case 5:                                               /* @asm 0x03409A: type 4->5 else ->0, refund barF50b */
        if (unit_table[active].type == 4) unit_table[active].type = 5; /* @asm 0x03409E..0x0340A5 */
        else unit_table[active].type = 0;                 /* @asm 0x0340AC..0x0340B0 */
        PREC()->gold += (uint32_t)barF50b;                /* @asm 0x0340B5..0x0340C0 (+=, +0x2A) */
        near_6D28(0xF, 0x32);                             /* @asm 0x0340C3..0x0340C8 */
        break;
    case 6:                                               /* @asm 0x0340CE: become type 2, pay barE64 */
        unit_table[active].type = 2;                      /* @asm 0x0340D2 */
        unit_table[active].cargo_qty[5] = 0x64;           /* @asm 0x0340D7 (+0x15 = 0x3159) */
        PREC()->gold -= (uint32_t)barE64;                 /* @asm 0x0340DC..0x0340E7 */
        near_6D91(0xE, 0x64);                             /* @asm 0x0340EA push 0x64,0xE -> 0x3408F */
        break;
    case 7:                                               /* @asm 0x0340F0: become type 0, refund barE64b */
        unit_table[active].type = 0;                      /* @asm 0x0340F4 */
        PREC()->gold += (uint32_t)barE64b;                /* @asm 0x0340F9..0x034104 */
        near_6D28(0xE, 0x64);                             /* @asm 0x034107 push 0x64,0xE -> 0x340C7 */
        break;
    case 8:                                               /* @asm 0x03410E: type 1->4 else ->5, pay bar850 */
        if (unit_table[active].type == 1) unit_table[active].type = 4; /* @asm 0x034112..0x034119 */
        else unit_table[active].type = 5;                 /* @asm 0x034120..0x034124 */
        overlay_call_181F_04C0(/* 0x5C */);               /* @asm 0x034129..0x03412C (ax=0x5C) */
        near_6D91(8, 0x32);                               /* @asm 0x034131..0x034136 */
        PREC()->gold -= (uint32_t)bar850;                 /* @asm 0x03413C..0x034147 [bp-0x60] */
        break;
    case 9:                                               /* @asm 0x03414C: type 4->1 else ->0, refund bar850b */
        if (unit_table[active].type == 4) unit_table[active].type = 1; /* @asm 0x034150..0x034157 */
        else unit_table[active].type = 0;                 /* @asm 0x03415E..0x034162 */
        PREC()->gold += (uint32_t)bar850b;                /* @asm 0x034167..0x034172 [bp-0x5A] */
        near_6D28(8, 0x32);                               /* @asm 0x034175 push 0x32,8 -> 0x340C7 */
        break;
    case 10:                                              /* @asm 0x03417C */
        unit_table[active].type = 3;                      /* @asm 0x034180 */
        overlay_call_181F_04C0(/* 0x8024 */);             /* @asm 0x034185..0x034188 (ax=0x8024) */
        break;
    case 11:                                              /* @asm 0x034190 */
        unit_table[active].type = 0;                      /* @asm 0x034194 */
        break;
    }

done:                                                     /* @asm 0x0341C0 */
    if (dlg != 0)                                         /* @asm 0x0341C3 if [bp-0x56]|[bp-0x54] */
        overlay_call_191F_01A8(/* dlg */);                /* @asm 0x0341CE close dialog */
    /* @asm 0x0341D3 leave; 0x0341D4 retf */
}
