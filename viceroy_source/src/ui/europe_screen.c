/* ============================================================================
 * europe_screen.c -- European trade-port UI  (VICEROY.EXE, overlay page 0x04)
 * ----------------------------------------------------------------------------
 * STATUS: DRAW COMPOSER DECODED 2026-05-30.  The Europe-port paint function and
 * its five sub-renderers are byte-traced in overlay page 0x04
 * (code/VICEROY/disasm_overlay_reseg/page_04.asm).  Every coordinate below
 * cites the exact @asm PUSH that writes it.
 *
 * The composer was found by tracing the WOODPANL/EUROPE.PIK load_PIK pattern
 * and cross-checking the sibling COLONY screen, whose renderer is fully decoded
 * in docs/COLONY_RENDERER_DECODED.md (from the flat-linked recol/colonize.exe).
 * The VICEROY Europe paint function is the structural twin of colony's
 * paint_colony_screen (func_0199D8 there): a top-level orchestrator that fills
 * the backdrop then calls a fixed sequence of element sub-renderers.
 *
 * ----------------------------------------------------------------------------
 * KEY THUNK IDENTITIES (resolved; see citations inline)
 * ----------------------------------------------------------------------------
 *   0x191F:0x87A  load_PIK(0, x0,y0,x1,y1, key)        -> loads named .PIK by
 *                 GAME.TXT key into the rect, returns handle (0 = fail).
 *                 VERIFIED by the identical call pattern at TWO sibling stubs:
 *                   - func_030DBC pushes key 0x0FBA="EUROPE" (@asm 0x030DCE)
 *                   - page_02 @0x025ECB pushes key 0x0BA0="COLONY" (@asm 0x025EC8)
 *                 and at the report panel @asm 0x039E70 pushing 0x11C6="WOODPANL".
 *                 (RENDER_CHAIN.md line 183 also names 0x191F:0x87A = load_PIK.)
 *   0x181F:0x772  enter_screen_view(0,0,0,0, ax=0xFFAD, dx=2, bx=screen_id)
 *                 -- enters the full-screen interactive view after the backdrop
 *                 loads.  screen_id 0x2B = Europe (@asm 0x030DEB), 0x2C = Colony
 *                 (@asm 0x025EE5).  Only these two stubs use the 0xFFAD/2 pair.
 *   0x181F:0x254  blit_sprite(ax=sprite_idx, dx=screen_x, bx=&sheet_desc, [sp]=y)
 *                 -- the 4-arg sheet blit (per RENDER_CHAIN/COLONY decode).
 *   0x181F:0xCE / 0xBA  beveled box / panel-line draw (raised/pressed widget).
 *   0x181F:0xE2   box/frame primitive (border rect) -- task brief box thunk.
 *   0x181F:0x22 / 0x100  create off-screen drawing context / commit it (used to
 *                 build a text/panel layer; matches colony fill/blit helpers).
 *   0x181F:0x13C  draw_text_at_xy(color, y, x, ss, &buf)  [args pushed in that
 *                 order; x is 3rd push] -- used for stockpile qty + gold.
 *   0x181F:0x16E / 0x178 / 0x182 / 0x1B4 / 0x1BE  string-build helpers
 *                 (set message key / append / append-number / terminate).
 *   0xD1D:0x8FA / 0x916 / 0x7A4 / 0x7E4  C-runtime sprintf/strcat/strcpy.
 *   load_PIK backdrop key "EUROPE" = 0x0FBA; "WOODPANL" = 0x11C6;
 *   "COLONY" = 0x0BA0 (handle = file_offset - 0x1D9A0; CITED code/VICEROY/
 *   strings.json: EUROPE @file 0x1E95A, WOODPANL @file 0x1EB66).
 *
 * ----------------------------------------------------------------------------
 * fill_rect ARGUMENT ORDER (byte-verified via colony twin)
 * ----------------------------------------------------------------------------
 * The shared rect-fill helper (near CALL cs:0x6DDC in this page; = colony's
 * func_0177A5/"fill_rect") is invoked  PUSH h; PUSH w; PUSH y; PUSH x.
 * Proof: colony stockpile bar pushes (0x15, 320, 179, 0) and the verified
 * result is (x=0, y=179, w=320, h=21) -- docs/COLONY_RENDERER_DECODED.md §10
 * line "Stockpile bar | 0 | 179 | 320 | 21". So below, a PUSH tuple
 * (h, w, y, x) is annotated as the rect (x, y, w, h).
 *
 * NATIVE resolution 320x200, VGA mode 13h.  All coordinates are native px.
 * ============================================================================ */
#include "viceroy_types.h"
#include "iolib.h"
#include "power.h"

/* ----------------------------------------------------------------------------
 * Active power record (the player's nation).  BYTE_VERIFIED PowerRecord table
 * base DGROUP:0x8808 stride 0x13C; active via far ptr DGROUP:0x84FC.
 *   +0x01  u8   tax %               (read by the title banner, @asm 0x03103F)
 *   +0x20  u16  boycott_bitfield    (bit i = good i boycotted by the King)
 *   +0x2A  u32  gold (treasury)
 * (docs/DATA_MODEL.md / project memory PowerRecord layout.)
 * ---------------------------------------------------------------------------- */
extern struct PowerRecord *g_active_power;       /* via far ptr DGROUP:0x84FC */

/* ============================================================================
 * ==                       EUROPE SCREEN PLACEMENT TABLE                    ==
 * ============================================================================
 * Every element of the Europe trade port, with its byte-traced placement.
 * STATIC elements give exact (x,y,w,h)/(x,y); DATA-DRIVEN elements give the
 * base coord + stride + count + per-slot data source.  Composer entry is the
 * top-level paint function at @file 0x031E4C (the SECOND entry inside the
 * disasm block the re-segmenter labelled func_031DC8; the first entry ending
 * at the RETF @0x031E4B is the recruit-pool sub-renderer).  This paint function
 * is the structural twin of colony paint_colony_screen.
 *
 * ----------------------------------------------------------------------------
 * | # | ELEMENT                  | x   | y   | w   | h  | sprite/string | @asm |
 * ----------------------------------------------------------------------------
 * COMPOSER  func @file 0x031E4C  (calls the sub-renderers in this fixed order)
 *  0  Play-area backdrop clear     0     8   320  192   (fill)   @asm 0x031E4C-56
 *       PUSH 0xC0,0x140,8,0 -> (x=0,y=8,w=320,h=192); then EUROPE.PIK already
 *       loaded by func_030DBC (key 0x0FBA) shows through.  CALL cs:0x6DB4 next.
 *  1  Commodity stockpile strip  (sub-renderer func_0310B4)        @asm 0x031E63
 *  2  Title / price banner       (sub-renderer func_030F76)        @asm 0x031E6B
 *  3  Dock + ships + in-port list(sub-renderer func_0314DC)        @asm 0x031E73
 *  4  Recruit / immigration pool (sub-renderer func_031DC8)        @asm 0x031E8D
 *  5  Outer screen frame           0   200   320   0    (0x181F:0xE2) @asm 0x031EA0
 *       PUSH 0,0x140,0xC8,0 ; ax=0,dx=0,bx=0 ; LCALL 0x181F:0xE2.
 *
 * ----------------------------------------------------------------------------
 * (1) STOCKPILE STRIP  func_0310B4 @file 0x0310B4  -- 16 commodity cells
 * ----------------------------------------------------------------------------
 *     bg fill              0   179   320   21   (fill)        @asm 0x0310B9-C4
 *        PUSH 0x15,0x140,0xB3,0 -> (x=0,y=179,w=320,h=21).  EXACT colony match.
 *     layout: base cell y = 0xB5 (181)  @asm 0x0310CF [bp-0x6a]=0xB5
 *             cell stride = 0x13 (19 px) @asm 0x03124C ADD [bp-0x68],0x13
 *             count       = 16           @asm 0x031253 CMP [bp-0x72],0x10
 *             icon sprite = ICONS.SS (good_idx + 0x17 = 23..38) @asm 0x0310F2 ADD ax,0x17
 *        per cell: blit_sprite(ICONS, idx, x, y) via 0x181F:0x254 @asm 0x03110F;
 *        qty text via 0xD1D:0x8FA(sprintf)+0x181F:0x13C @asm 0x0311AE
 *        (qty drawn at x = [bp-0x70]=0xC2(194)?+ cell, color/coords @asm 0x031174).
 *     boycott / saturation overlay  per cell  (box 0x181F:0xCE)    @asm 0x031247
 *        gated by [0x9E40] (boycott) / [0xFA7] (saturation), color 0xE
 *        @asm 0x031201 / 0x03121A MOV [bp-0x6c],0xE.
 *     gold readout         306   179   15    -    (text)        @asm 0x03125C-74
 *        PUSH 0xF,0xB3,0x132,[0x2f5e] ; 0x181F:0x22 then 0x181F:0x13C.
 *        x=0x132(306), y=0xB3(179).  EXACT colony "gold X=306,Y=179" match.
 *
 * ----------------------------------------------------------------------------
 * (2) TITLE / PRICE BANNER  func_030F76 @file 0x030F76  -- runtime text
 * ----------------------------------------------------------------------------
 *     "Selling <Good> at <N> Gold: (<gold>)" assembled then printed via
 *     0x181F:0xB0 at [bp+4]  @asm 0x0310AD.  Fields:
 *        selected good index [0x9E12]   @asm 0x030F7A  -> name strings via
 *           table -0x7C74 @asm 0x030F80 and -0x72BE @asm 0x030FAD
 *        year [0x538A]                  @asm 0x031007  -> sprintf 0xD1D:0x8FA
 *        tax%  = PowerRecord[+0x01] via [0x84FC]  @asm 0x03103F..0x031047
 *        price/gold strings [0x93B0] @asm 0x03102F, [0x93A0] @asm 0x031079.
 *     (Exact pixel x/y of the banner are set inside the 0x181F:0xB0 text
 *      engine from the current cursor; the banner occupies the y=0..45 strip
 *      per docs/RENDERER_GEOMETRY.md.  String IDs cited above; pixel origin
 *      not yet decoded -- lives in the resident text engine, not this page.)
 *
 * ----------------------------------------------------------------------------
 * (3) DOCK + SHIPS + IN-PORT LIST  func_0314DC @file 0x0314DC
 * ----------------------------------------------------------------------------
 *     dock scene fill      143   118   81    60   (fill)        @asm 0x0314E1-E7
 *        PUSH 0x3C,0x51,0x76,0x8F -> (x=0x8F=143, y=0x76=118, w=0x51=81, h=0x3C=60).
 *     in-port ship row layer  143    81   120   69   (0x181F:0x22/0x100) @asm 0x0314F8-150F
 *        PUSH 0x45,0x78,0x51,0x8F -> (x=143, y=81, w=120, h=69); committed via
 *        0x181F:0x100 @asm 0x03150F.
 *     ship sprites at dock  -- DATA-DRIVEN
 *        layout: count = 6 slots  @asm 0x031521 CMP [bp-0x5c],6
 *                sprite = 0x7B (123, ICONS.SS ship anchor base) @asm 0x03154F MOV ax,0x7B
 *                per-slot (x,y,w) computed by helper cs:0x6D55 @asm 0x03153E
 *                blit via 0x181F:0x254 @asm 0x031559 (and 2nd loop @asm 0x031731)
 *                ship records read through far ptr [0x83E] @asm 0x031544.
 *     in-port unit name+stat text  base x = 146 (0x92)          @asm 0x031631
 *        [bp-0x56]=0x92 ; rows from [0x9E1C]/[0x9E20] selected-ship state,
 *        unit type UnitRecord[+0x3146] @asm 0x03159E, stat table 0x5230
 *        @asm 0x0315B9 ; per-row draw via cs:0x6E3B @asm 0x0316B8.
 *        boycott highlight color 0xF gated by [0x9E40]/[0xF9A] @asm 0x031692/0x0316A1.
 *     EXPECTED / BOUND / LOADING sub-panels: drawn by cs:0x6E13 selector
 *        @asm 0x031560 (reads [0x9E1C]); their per-state text is in the
 *        cs:0x6Exx helper family (resident), pixel origin not yet decoded there.
 *
 * ----------------------------------------------------------------------------
 * (4) RECRUIT / IMMIGRATION POOL  func_031DC8 @file 0x031DC8  -- 3 slots
 * ----------------------------------------------------------------------------
 *     pool bg fill         281    89   37    32   (fill)        @asm 0x031DCC-D2
 *        PUSH 0x20,0x25,0x59,0x119 -> (x=0x119=281, y=0x59=89, w=0x25=37, h=0x20=32).
 *     layout: base (x,y) = (0x119=281, 0x59=89)  @asm 0x031DDC/0x031DE1
 *             count       = 3   @asm 0x031E2B CMP [bp-6],3
 *             y advance   = ret(helper)+2 per slot @asm 0x031E23 INC ax;INC ax;ADD [bp-4],ax
 *             per-slot key from table -0x6C28 @asm 0x031E19 (push word[bx-0x6C28])
 *             per-slot draw via button drawer cs:0x20F6 = func_031BE6 @asm 0x031E1D
 *     recruit BUTTON drawer func_031BE6 @file 0x031BE6 (raised/pressed bevel):
 *        bevel colors raised 0x30/0x39 vs pressed 0x39/0x30 @asm 0x031BFF/0x031C14
 *        & 0x031C1B/0x031C20 ; edges via 0x191F:0x8BC/0x8B2 @asm 0x031C8A/0x031CB8;
 *        label/key text via 0x181F:0x22 @asm 0x031D42.  args (x=[bp+6], y=[bp+8],
 *        flags=[bp+0xA], key=[bp+4]).
 *     button labels RECRUIT/PURCHASE/TRAIN = LABELS.TXT @EUROLABEL[0..2]
 *        (handle 0x22D4; CITED strings.json @file 0x1FC74).
 *
 * ----------------------------------------------------------------------------
 * BOYCOTT OVERLAY: red-X glyph is ICONS.SS slot 0x2B (43) per
 *   docs/SCREEN_ASSET_REQUIREMENTS.md "Europe trade port".  In this page the
 *   boycott condition is driven by DGROUP [0x9E40] and PowerRecord +0x20; the
 *   stockpile overlay box color is 0xE (@asm 0x031201) and the in-port row
 *   highlight is color 0xF (@asm 0x031692).  The literal sprite-index 0x2B blit
 *   for the cell X is performed inside the 0x181F:0xCE box helper variant; the
 *   exact ICONS-43 PUSH is in that resident helper (not this page) -> library-implementation-only.
 * EXIT "E" button: small red E from EXIT.SS at the bottom-right, drawn by the
 *   resident chrome layer (not in this page) -> library-implementation-only (geometry 303,~190,17,10
 *   per docs/RENDERER_GEOMETRY.md, FRAME-measured, not byte-traced here).
 * ============================================================================ */

/* ----------------------------------------------------------------------------
 * Resident drawing primitives reached from page 0x04 (thunks + CS-relative).
 * Signatures from the byte trace + the colony twin (COLONY_RENDERER_DECODED.md).
 * fill_rect args are pushed (h, w, y, x); we declare them (x,y,w,h) for clarity.
 * ---------------------------------------------------------------------------- */
extern void fill_rect(int x, int y, int w, int h);          /* near CALL cs:0x6DDC */
extern void box_frame(int x, int y, int w, int h, int c);   /* 0x181F:0x00E2 */
extern void blit_sprite(int sprite_idx, int x, int y, void far *sheet); /* 0x181F:0x254 */
extern void draw_text_at_xy(int color, int y, int x, void *buf);        /* 0x181F:0x13C */
extern void gfx_ctx_begin(int a, int b, int c, int d);      /* 0x181F:0x22  (build layer) */
extern void gfx_ctx_commit(int lo, int hi);                 /* 0x181F:0x100 (commit layer) */

/* Sub-renderers (this page).  Each takes a "blit-now" flag in [bp+4]/[bp+6]. */
extern void europe_draw_stockpile(int blit);   /* func_0310B4 @file 0x0310B4 */
extern void europe_draw_title(int blit);       /* func_030F76 @file 0x030F76 */
extern void europe_draw_dock_ships(int blit);  /* func_0314DC @file 0x0314DC */
extern void europe_draw_recruit_pool(int blit);/* func_031DC8 @file 0x031DC8 */

/* Composer-local helpers (CS-relative inside page 0x04; roles per call site). */
extern void ov_prep_clip(void);                /* near CALL cs:0x6DB4 (clip setup) */
extern void ov_draw_extra_a(int z);            /* near CALL cs:0x6D73 */
extern void ov_draw_extra_b(int z);            /* near CALL cs:0x6E36 */

/* DGROUP scalars read by the composer / sub-renderers (BYTE_VERIFIED addrs). */
extern int16_t g_sel_good_9E12;   /* DGROUP:0x9E12 selected commodity for banner */
extern int16_t g_boycott_9E40;    /* DGROUP:0x9E40 boycott-active flag */
extern int16_t g_year_538A;       /* DGROUP:0x538A current year (banner) */

/* ----------------------------------------------------------------------------
 * europe_screen_render -- the Europe trade-port paint composer.
 *
 * @asm_function  (top-level paint) @file 0x031E4C  (second entry in the disasm
 *                block listed as func_031DC8; page_04.asm offset 0x235C).
 * @asm_disasm    code/VICEROY/disasm_overlay_reseg/page_04.asm
 *
 * Structural twin of colony paint_colony_screen (func_0199D8,
 * docs/COLONY_RENDERER_DECODED.md §1).  Fills the play area, then calls the
 * element sub-renderers in fixed order, then draws the outer frame.
 * The "blit" arg is 0 here (compose into the back buffer; the caller blits).
 * ---------------------------------------------------------------------------- */
void europe_screen_render(void)
{
    /* (0) clear the play area below the title strip; EUROPE.PIK (loaded by
     * europe_open via 0x191F:0x87A key 0x0FBA) shows through where not drawn.
     * @asm 0x031E4C-56  PUSH 0xC0,0x140,8,0 -> fill_rect(x=0,y=8,w=320,h=192). */
    fill_rect(0, 8, 320, 192);          /* @asm 0x031E4C..0x031E56 cs:0x6DDC */
    ov_prep_clip();                     /* @asm 0x031E5E near CALL cs:0x6DB4 */

    /* (1) 16-commodity stockpile strip at y=179, stride 19, ICONS+23. */
    europe_draw_stockpile(0);           /* @asm 0x031E63 CALL 0x15C4 (func_0310B4) */

    /* (2) "Selling <Good> at <N> Gold: (<gold>)" banner. */
    europe_draw_title(0);               /* @asm 0x031E6B CALL 0x1486 (func_030F76) */

    /* (3) dock scene + ships at anchor + in-port unit list. */
    europe_draw_dock_ships(0);          /* @asm 0x031E73 CALL 0x19EC (func_0314DC) */

    ov_draw_extra_a(0);                 /* @asm 0x031E7C near CALL cs:0x6D73 */
    ov_draw_extra_b(0);                 /* @asm 0x031E85 near CALL cs:0x6E36 */

    /* (4) recruit / immigration pool (3 candidate slots, right column). */
    europe_draw_recruit_pool(0);        /* @asm 0x031E8D CALL 0x22D8 (func_031DC8) */

    /* (5) outer screen frame.  @asm 0x031E95-A0 PUSH 0,0x140,0xC8,0 ; ax=dx=bx=0;
     * LCALL 0x181F:0xE2 -> box_frame(x=0,y=0,w=320,h=200,c=0). */
    box_frame(0, 0, 320, 200, 0);       /* @asm 0x031EA0 LCALL 0x181F:0x00E2 */
}

/* ============================================================================
 * europe_open -- VICEROY func_030DBC  (the "go to Europe" command entry)
 * ----------------------------------------------------------------------------
 * STATUS: BYTE_VERIFIED structure + corrected thunk identities (2026-05-30).
 *
 * @asm_function  func_030DBC   file 0x030DBC..0x030DF3
 * @asm_disasm    code/VICEROY/disasm_overlay_reseg/page_04.asm
 *
 * This is the Europe SCREEN-ENTRY stub (not the composer): it loads the
 * EUROPE.PIK backdrop, then enters the interactive Europe view (which paints
 * via europe_screen_render above and runs the input loop).  Its exact twin is
 * the COLONY entry stub at @asm 0x025EC8 (key 0x0BA0="COLONY", screen_id 0x2C).
 *
 * Purpose proven by STRING XREF:
 *   @asm 0x030DCE  PUSH 0x0FBA   -> GAME.TXT key "EUROPE"  (@file 0x1E95A)
 *
 * Behaviour, byte-faithful:
 *   load_PIK(0, rect[0x839E..0x83A4], 0x0FBA)             (@asm 0x030DD1 0x191F:0x87A)
 *   if (handle != 0)                                      (@asm 0x030DDB OR ax,ax / JE)
 *       enter_screen_view(0,0,0,0, ax=0xFFAD, dx=2, bx=0x2B)  (@asm 0x030DEE 0x181F:0x772)
 *
 * NOTE (correction): the prior revision labelled 0x191F:0x87A as
 * "menu_dispatch_region" -- that was wrong.  0x191F:0x87A is load_PIK
 * (load named .PIK by GAME.TXT key into the rect); verified by the identical
 * call pattern at the COLONY stub and the WOODPANL report panel (@asm
 * 0x039E70).  And 0x181F:0x772 is enter_screen_view (screen_id 0x2B = Europe),
 * not "ov_enter_view of unknown meaning": the 0xFFAD/2 sentinel pair appears at
 * exactly the two screen-entry stubs (Europe 0x2B, Colony 0x2C).
 * ============================================================================ */
#define KEY_EUROPE     0x0FBA   /* "EUROPE"   @asm 0x030DCE / @file 0x1E95A */
#define SCREEN_ID_EUR   0x2B     /* Europe view id @asm 0x030DEB (0x2C = Colony) */
#define SCREEN_EUROPE   SCREEN_ID_EUR

extern int16_t g_dialog_rect[4];   /* DGROUP:0x839E (x), 0x83A0 (y), 0x83A2, 0x83A4 */
extern int  load_PIK(int z0, int x0, int y0, int x1, int y1,
                     int key);                  /* 0x191F:0x87A */
extern void enter_screen_view(int z0, int z1, int z2, int z3,
                              int ax, int dx, int bx);   /* 0x181F:0x772 */

void europe_open(void)
{
    int handle = load_PIK(0,
                          g_dialog_rect[0], g_dialog_rect[1],
                          g_dialog_rect[2], g_dialog_rect[3],
                          KEY_EUROPE);            /* @asm 0x030DD1 0x191F:0x87A */
    if (handle != 0) {                            /* @asm 0x030DDB OR ax,ax / JE 0x1303 */
        /* enter the Europe view; the paint pass is europe_screen_render().
         * @asm 0x030DE5..0x030DEE  ax=0xFFAD, dx=2, bx=0x2B (Europe screen id). */
        enter_screen_view(0, 0, 0, 0, 0xFFAD, 2, SCREEN_ID_EUR); /* @asm 0x030DEE 0x181F:0x772 */
    }
    /* @asm 0x030DF3 RETF */
}

/* ----------------------------------------------------------------------------
 * europe_clip_blit -- VICEROY func_030D86 (the FIRST entry of the page-04 pair)
 *
 * STATUS: BYTE_VERIFIED (structure); the blit leaf (0x181F:0x444) is
 * ANCHOR-resolved but not re-decoded.
 *
 * @asm_function  func_030D86  file 0x030D86..0x030DBB  (110 B, push bp/mov bp,sp)
 *
 * A generic "blit within two clip regions" helper used by the Europe/report
 * full-screen paths. Pushes BOTH the dialog rect (DGROUP:0x839E..0x83A4) and a
 * second persistent 4-word region (DGROUP:0x2DA8..0x2DAE -- the same region the
 * report entry func_037340 uses, AND the same &sheet_desc the Europe blits pass
 * to 0x181F:0x254), then the caller's (bp+0xC) arg, and calls 0x181F:0x444 with
 * ax=[bp+6], dx=[bp+8], bx=[bp+0xA].  @asm 0x030D89..0x030DB5.
 *
 * args:  a=[bp+6] b=[bp+8] c=[bp+0xA] d=[bp+0xC]
 * ---------------------------------------------------------------------------- */
extern int16_t g_region_2DA8[4];   /* DGROUP:0x2DA8..0x2DAE second clip region */
extern void ov_clip_blit(int d, int r0,int r1,int r2,int r3,
                         int q0,int q1,int q2,int q3,
                         int ax,int dx,int bx);            /* 0x181F:0x444 */

void europe_clip_blit(int a, int b, int c, int d)
{
    /* @asm 0x030D89..0x030DB5 : push rect[0x839E..0x83A4], push region
     * [0x2DA8..0x2DAE], push d, then LCALL 0x181F:0x444 with ax=a,dx=b,bx=c. */
    ov_clip_blit(d,
                 g_dialog_rect[0], g_dialog_rect[1], g_dialog_rect[2], g_dialog_rect[3],
                 g_region_2DA8[0], g_region_2DA8[1], g_region_2DA8[2], g_region_2DA8[3],
                 a, b, c);
}

/* ----------------------------------------------------------------------------
 * europe_screen_update -- input handling.
 *
 * The Europe-screen *input dispatch* IS decoded: the ship-click handler is
 * func_03314E (see europe_ship_click below). The per-frame loop is the resident
 * main loop; the Europe-mode selector is DGROUP:[0x1F5E]=4 (set by the
 * SETEUROPE command branch of func_0235D6 -- @asm 0x0236D3 MOV [0x1F5E],4).
 * The buy/sell quantity dialog still routes through the menu/dialog framework
 * func_028D8C (see dialog.c); the ship-options menu path is decoded below.
 * ---------------------------------------------------------------------------- */
int europe_screen_update(void)
{
    /* The per-frame Europe input dispatch routes a ship click to
     * europe_ship_click() (func_03314E).  @asm 0x0236D3 MOV [0x1F5E],4. */
    return SCREEN_EUROPE;
}

/* ============================================================================
 * europe_ship_click -- VICEROY func_03314E  (Europe-port ship interaction)
 * ----------------------------------------------------------------------------
 * STATUS: BYTE_VERIFIED (structure + all DGROUP offsets + string keys);
 * the GUI-framework leaf calls (0x191F:NNN / 0x181F:NNN into func_028D8C /
 * func_02883E) are ANCHOR_VERIFIED by lcall resolution but their internal
 * behaviour is summarised, not re-decoded here.
 *
 * @asm_function  func_03314E   file 0x03314E..0x03334D  (511 bytes, ENTER 0x60,0)
 * @asm_disasm    code/VICEROY/disasm_overlay_reseg/page_04.asm (func_03314E)
 *
 * Purpose proven by STRING XREF (the decisive evidence):
 *   @asm 0x03318D  LEA ax,[0x1005]   -> GAME.TXT key "EUROPESHIPCLICK"
 *   @asm 0x0331AD  PUSH 0x1015       -> GAME.TXT key "EUROPESHIPOPTIONS"
 *   @asm 0x03331A  PUSH 0x1027       -> GAME.TXT key "SOMEBOYCOTT"
 *   (string handle = file_offset - 0x1D9A0; EUROPESHIPCLICK @file 0x1E9A5,
 *    EUROPESHIPOPTIONS @file 0x1E9B5, SOMEBOYCOTT @file 0x1E9C7.)
 *
 * Args (cdecl; lowest stack slot = first declared param):
 *   ship_idx = [bp+6]   UnitRecord index of the clicked ship
 *   flag     = [bp+8]   secondary mode flag (0 in the common path)
 *
 * UnitRecord access is BYTE_VERIFIED: base DGROUP:0x3144, stride 0x1C; the type
 * byte is at +0x02 (0x3146).  Per project memory ("VICEROY UnitRecord table
 * base is DGROUP:0x3144 (type at +0x02)").
 *   @asm 0x033152  IMUL bx,[bp+6],0x1C
 *   @asm 0x033156  MOV bl,[bx+0x3146]            ; unit type
 *
 * The per-type stat row is the stride-14 table at DGROUP:0x5230 (the SAME table
 * the combat resolver and the turn loop use -- see src/combat / main_loop.c):
 *   @asm 0x03315E..0x033166  bx = type*14   (shl1;add;shl1;add;shl1 == *14)
 *   @asm 0x033168  PUSH [bx+0x5230]             ; stat field of that row
 *   @asm 0x03316E  LCALL 0x181F:0x438           ; (stat-formatting helper)
 *
 * Local scratch buffer [bp-0x50] is zeroed (@asm 0x033176) and used as the
 * string/format target for LCALL 0x181F:0x416 (@asm 0x033181) before the menu
 * is built.
 * ============================================================================ */

/* GAME.TXT message keys (handles into DGROUP data; file = handle + 0x1D9A0).
 * CITED: code/VICEROY/strings.json. */
#define KEY_GAME              0x087C   /* "GAME"   (table selector) @file 0x1E21C */
#define KEY_EUROPESHIPCLICK   0x1005   /* @asm 0x03318D / @file 0x1E9A5 */
#define KEY_EUROPESHIPOPTIONS 0x1015   /* @asm 0x0331AD / @file 0x1E9B5 */
#define KEY_SOMEBOYCOTT       0x1027   /* @asm 0x03331A / @file 0x1E9C7 */

/* UnitRecord table (BYTE_VERIFIED base/stride/type-offset). */
extern uint8_t g_unit_records[];        /* DGROUP:0x3144, stride 0x1C */
#define EUR_U_X(i)     g_unit_records[(i)*0x1C + 0x00]   /* 0x3144 */
#define EUR_U_Y(i)     g_unit_records[(i)*0x1C + 0x01]   /* 0x3145 */
#define EUR_U_TYPE(i)  g_unit_records[(i)*0x1C + 0x02]   /* 0x3146 */
#define EUR_U_F148(i)  g_unit_records[(i)*0x1C + 0x04]   /* 0x3148 flags (bit7=0x80) */
#define EUR_U_CARGO(i) g_unit_records[(i)*0x1C + 0x0C]   /* 0x3150 cargo-slot count */

/* DGROUP scalars touched by this handler (BYTE_VERIFIED addresses). */
extern int16_t g_word_840;   /* DGROUP:0x0840  (cursor/anchor word, pushed @asm 0x0331C8) */
extern int16_t g_word_83E;   /* DGROUP:0x083E  (cursor/anchor word, pushed @asm 0x0331CC) */
extern int16_t g_word_9E20;  /* DGROUP:0x9E20  cleared on menu-action 1 @asm 0x0332A9 */
extern int16_t g_word_9E1C;  /* DGROUP:0x9E1C  cleared/used on action 1/2 @asm 0x0332AC/0x0332B2 */

/* Stat-table (stride 14 @ DGROUP:0x5230) -- same table as combat/turn loop. */
extern int16_t g_unit_stat_5230[];      /* DGROUP:0x5230, stride 14 (7 words) */

/* ---- GUI / menu framework (ANCHOR_VERIFIED via lcall_resolution) ----------
 * These are entry points into the menu/dialog engine func_028D8C (page 0x02)
 * and the menu-item engine func_02883E (page 0x02).  Their CALL SITES + args
 * are byte-exact; their internals are not re-decoded here (cross-subsystem). */
extern void far *menu_lookup_by_key(int key_lo, int key_hi, int table); /* 0x191F:0x182 */
extern int       menu_run_options(int key, int table);                  /* 0x191F:0x928 */
extern void      menu_do_action(void far *menu, int a, int x83e, int x840,
                                int ship, int z1, int z2, int z3);        /* 0x191F:0x230 */
extern int       menu_item_get(void far *menu, int idx, void *buf, int n);/* 0x191F:0x176 */
extern int       menu_item_count(void *buf);                            /* 0x191F:0x91C */
extern void      menu_item_step(int handle);                            /* 0x191F:0x910 */
extern int       menu_selected_index(void far *menu);                   /* 0x191F:0x16A */
extern void      menu_free(void far *menu);                             /* 0x191F:0x1A8 */
extern void      menu_close(void);                                      /* near CALL 0x6D3C (CS-rel) */
extern void      ov_unit_stat_format(int stat, int zero);               /* 0x181F:0x438 */
extern void      ov_strbuf_init(int n, void *buf, int one);             /* 0x181F:0x416 */
extern void      ov_show_message(int n, int key);                       /* 0x181F:0x652 (SOMEBOYCOTT) */
extern int       ov_unit_cargo_query(int slot, int ship);               /* 0x181F:0xBE6 */
extern void      ov_unit_select(int ship);                              /* 0x181F:0x89E */

/* The three near-CALL (push cs;call) action handlers reached by the menu
 * selection -- CS-relative targets inside this overlay page (file offsets in
 * page_04's display IP space). Identities are local helpers; inferred from call context beyond role. */
extern int  eship_action_a(int x9e1c);                /* near CALL 0x6D5F @asm 0x0332B7 */
extern int  eship_action_b(int z);                    /* near CALL 0x6DD7 @asm 0x0332F6 */
extern int  eship_action_c(int z, int slot, int ship);/* near CALL 0x6DE6 @asm 0x033308 */

int europe_ship_click(int ship_idx, int flag)
{
    void far *menu;            /* [bp-0x58]:[bp-0x56] far ptr to the menu object */
    int  sel;                  /* [bp-0x54] selected menu index (1..3) */
    int  i;                    /* [bp-0x5E] loop var over 4 menu slots */
    char namebuf[0x50];        /* [bp-0x50] format/scratch buffer */

    /* --- format the ship's stat into the scratch buffer ---
     * @asm 0x033152..0x033195 : type=EUR_U_TYPE(ship); push stat row[type] +
     * 0, LCALL 0x181F:0x438; zero namebuf; LCALL 0x181F:0x416(1,&namebuf,1). */
    int type = EUR_U_TYPE(ship_idx);
    ov_unit_stat_format(g_unit_stat_5230[type * 7 /*stride 14 bytes*/], 0);
    namebuf[0] = 0;                                       /* @asm 0x033176 */
    ov_strbuf_init(1, namebuf, 1);                        /* @asm 0x033181 LCALL 0x181F:0x416 */

    /* --- build the ship-click menu from key EUROPESHIPCLICK ---
     * @asm 0x033189..0x0331A0 : menu = lookup_by_key(0x1005, GAME, 0); if NULL
     * -> goto cleanup. */
    menu = menu_lookup_by_key(KEY_EUROPESHIPCLICK, KEY_GAME, 0); /* 0x191F:0x182 */
    if (menu == 0)                                       /* @asm 0x0331A0 OR dx,ax / JNE */
        goto cleanup;                                    /* @asm 0x0331A2 JMP 0x3844 */

    /* set bits 0+1 in the menu record's flag byte at +0x0A.
     * @asm 0x0331A5 LES bx,[bp-0x58] ; 0x0331A8 OR es:[bx+0x0A],3 */
    *((uint8_t far *)menu + 0x0A) |= 3;

    /* --- present the EUROPESHIPOPTIONS option list ---
     * @asm 0x0331AD..0x0331BD : if menu_run_options(0x1015, GAME)==0 ->
     * cleanup. (A zero return means "no options available".) */
    if (menu_run_options(KEY_EUROPESHIPOPTIONS, KEY_GAME) == 0) /* 0x191F:0x928 */
        goto cleanup;                                    /* @asm 0x0331BF JMP 0x3844 */

    /* dispatch the chosen action: menu_do_action(menu, sel,sel,sel, ship,
     * [0x840],[0x83E], menu.off, menu.seg).  @asm 0x0331C2..0x0331DB
     * (8 PUSHes, add sp,0x10). i = 1.  @asm 0x0331DE MOV [bp-0x5E],1 */
    menu_do_action(menu, 0/*ax dup*/, g_word_83E, g_word_840,
                   ship_idx, 0, 0, 0);                   /* 0x191F:0x230 */
    i = 1;

    /* --- iterate the four menu slots, refreshing each item state ---
     * @asm 0x0331E3 JMP 0x372B (loop test) .. body @asm 0x0331E6..0x033260.
     * The per-slot body keys off (i): the slots map to (1) cargo-present,
     * (2) flag-148-bit7 clear, (3) cargo-slot byte at +0x0C nonzero, (4) same
     * as (1). For an "active" slot it calls menu_item_get(...) @asm 0x033210
     * (LCALL 0x191F:0x176). */
    while (i <= 4) {                                     /* @asm 0x03321B CMP [bp-0x5E],4 / JG */
        int active;                                      /* [bp-0x5C] */
        switch (i) {                                     /* @asm 0x033236 dispatch on i */
        case 1:                                          /* @asm 0x03323A i==1 -> 0x3707 */
        case 4:                                          /* @asm 0x033242 i==4 -> 0x3707 */
            /* slot 1 and 4 are unconditionally active.  @asm 0x033707 */
            active = 1;
            break;
        case 2:                                          /* @asm 0x03323C i==2 -> 0x36F6 */
            /* active unless flag!=0, or the unit's +0x04 byte has bit7 set.
             * @asm 0x0331E6..0x0331F5 (CMP [bp+8],0/JNE; TEST [bx+0x3148],0x80/JNE) */
            active = !(flag != 0 || (EUR_U_F148(ship_idx) & 0x80));
            break;
        case 3:                                          /* @asm 0x03323F i==3 -> 0x3758 */
            /* active iff cargo-slot byte (+0x0C) nonzero AND flag==0.
             * @asm 0x033248..0x033257 (CMP [bx+0x3150],0/JE; CMP [bp+8],0; JNE) */
            active = (EUR_U_CARGO(ship_idx) != 0) && (flag == 0);
            break;
        default:
            active = 0;
            break;
        }
        if (active) {                                    /* @asm 0x0331FC CMP [bp-0x5C],0 / JE */
            /* menu_item_get(menu, &namebuf, i)  @asm 0x033202..0x033215 */
            menu_item_get(menu, i, namebuf, 0);          /* 0x191F:0x176 */
        }
        i++;                                             /* @asm 0x033218 INC [bp-0x5E] */
        /* per-slot menu bookkeeping: menu_item_count(&namebuf) then
         * menu_item_step(that)  @asm 0x033221..0x033236 (LCALL 0x191F:0x91C,
         * then PUSH ax / LCALL 0x191F:0x910). */
        menu_item_step(menu_item_count(namebuf));
    }

    /* --- read the selected index and validate range 1..3 ---
     * @asm 0x033262..0x03327D : sel = menu_selected_index(menu) (0x191F:0x16A);
     * menu cleanup pass 0x191F:0x1A8; zero the far ptr; if sel<1 or sel>=4 ->
     * cleanup. */
    sel = menu_selected_index(menu);                     /* 0x191F:0x16A */
    menu_free(menu);                                     /* @asm 0x033276 LCALL 0x191F:0x1A8 */
    menu = 0;                                            /* @asm 0x03327B..0x033280 */
    if (sel < 1 || sel >= 4)                             /* @asm 0x033283/0x03328C */
        goto cleanup;

    /* dispatch on sel: 1,2,3 (jump table @asm 0x033838).  @asm 0x033295 sel-1 */
    switch (sel) {
    case 1:                                              /* @asm 0x03332B sel==1 -> 0x37AC */
        /* "disembark / unselect": ov_unit_select(ship); clear [0x9E20],[0x9E1C]
         * @asm 0x03329C..0x0332AF */
        ov_unit_select(ship_idx);                        /* 0x181F:0x89E */
        g_word_9E20 = 0;
        g_word_9E1C = 0;
        break;
    case 2:                                              /* @asm 0x03332F sel==2 -> 0x37C2 */
        /* action_a on [0x9E1C]  @asm 0x0332B2..0x0332BD (near CALL 0x6D5F) */
        eship_action_a(g_word_9E1C);
        break;
    case 3:                                              /* @asm 0x033332 sel==3 -> 0x37D0 */
        /* iterate the ship's cargo slots downward (count-1 .. 0):
         * @asm 0x0332C0..0x033320 : n = EUR_U_CARGO(ship)-1; for(;n>=0;n--){
         *   q = ov_unit_cargo_query(n, ship)  (0x181F:0xBE6);
         *   if (eship_action_b(q)) continue/break;
         *   if (eship_action_c(0,q,ship)) ... }
         * If any slot triggered the boycott condition ([bp-0x60]!=0), show the
         * SOMEBOYCOTT message: ov_show_message(2, 0x1027).  @asm 0x033318. */
        {
            int n = (int)EUR_U_CARGO(ship_idx) - 1;      /* @asm 0x0332CA DEC ax */
            int boycotted = 0;                           /* [bp-0x60] */
            for (; n >= 0; n--) {                        /* @asm 0x0332D8 CMP [bp-0x5E],0 / JL */
                int q = ov_unit_cargo_query(n, ship_idx);/* 0x181F:0xBE6 */
                if (eship_action_b(q))                   /* near CALL 0x6DD7 -> nonzero: skip */
                    continue;
                if (eship_action_c(0, q, ship_idx))      /* near CALL 0x6DE6 */
                    boycotted = 1;                       /* (sets [bp-0x60]=1 path) */
            }
            if (boycotted)                               /* @asm 0x033312 CMP [bp-0x60],0 / JE */
                ov_show_message(2, KEY_SOMEBOYCOTT);     /* @asm 0x03331D 0x181F:0x652 */
        }
        break;
    }

cleanup:
    /* @asm 0x033334 push cs / CALL 0x6D3C  (menu_close / restore) */
    menu_close();
    /* if a menu ptr is still live, free it.  @asm 0x033338..0x033356 */
    if (menu != 0)                                       /* OR of the two ptr words */
        menu_free(menu);                                 /* 0x191F:0x1A8 */
    return 0;                                            /* @asm 0x03334B LEAVE/RETF */
}
