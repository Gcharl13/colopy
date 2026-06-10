/* ============================================================================
 * turn_step.c -- func_021D32 unit_turn_advance  [PORTED 2026-06-10]
 * ----------------------------------------------------------------------------
 * The per-unit ADVANCE step of the main loop (file 0x021D32..0x021E71, 320 B,
 * full transcription against re_work/disasm/func_021D32.asm).  Runs when the
 * active unit's orders are settled: deselect fx, order-state ladder, season
 * latch back to Spring, reveal + cursor box, then the season processors and
 * the tutorial-hint hook (func_020F50, ported).
 *
 * RESOLVED 2026-06-10 (the "pickers"): the near calls @0x21E39/@0x21E45
 * target the page-tail trampolines @0x24BD7/@0x24BA5 = JMP FAR 0x191F:0xE4 /
 * 0x191F:0x6C; their records at file 0x1B5F0+NNN decode to page 1 offsets
 * 0xB34 / 0x902 = file 0x021A14 / 0x0217E2:
 *   @0x21E39 -> func_021A14 = spring_turn_process (PORTED, main_loop.c):
 *               Spring refresh+draw of the active unit.
 *   @0x21E45 -> 0x0217E2 = the begin-Autumn trigger ([0x5390]=1; the
 *               main_loop.c season ladder's documented setter).  Ported here
 *               as the one-line season store, cite-marked PARTIAL (the
 *               surrounding 0x217E2 body is not yet transcribed).
 * Unit ROTATION (advancing [0x5392]) belongs to the resident dispatcher tail
 * of func_0246E2 -- substituted by the SHELL (main_modern.c) until ported.
 *
 * Leaves (all resident, ported):
 *   0x7A0 deselect-notify  func_006608   0x7F4 needs-orders  func_007A80
 *   0x830 order-msg-id     func_007B10   0x86C order-msg     func_006F5A
 *   0x302 in-bounds        func_005BFA   0xDB8 reveal        func_00BD28
 *   0x352 cursor-box       func_00BF3C   0x9BA deselect fx (overlay; stub)
 * ============================================================================ */
#ifdef _VICEROY_MODERN

#include "viceroy_types.h"
#include "dgroup.h"

#define UB(i, off)  DG8(0x3144 + (i)*0x1C + (off))

extern int  func_006608_logic_sz_106(uint16_t u);            /* 0x7A0 */
extern int  func_007A80_op_sz_143(uint16_t u);               /* 0x7F4 */
extern int  func_007B10_logic_sz_83(uint16_t u);             /* 0x830 */
extern int  func_006F5A_op_sz_105(uint16_t id);              /* 0x86C */
extern int  func_005BFA_logic_sz_49(uint16_t x, uint16_t y); /* 0x302 */
extern int  func_00BD28_op_sz_34(uint16_t x, uint16_t y);    /* 0xDB8 */
extern int  func_00BF3C_logic_sz_182(uint16_t a, uint16_t b, uint16_t c,
                                     uint16_t d, uint16_t e);/* 0x352 */
extern int  func_020F50_tutorial_hints(void);
extern int  func_021A14_sec_sz_602(void);      /* near 0x24BD7 -> func_021A14
                                                * spring_turn_process; spec in
                                                * main_loop.c, body pending --
                                                * the TU stub stands in */
extern void ovl_deselect_fx(int x, int y);     /* 0x181F:0x9BA (overlay) */

int unit_turn_advance(int notify)
{
    int done = 0;                                  /* [bp-2] @0x21D36 */
    int was_autumn = ((int16_t)DG16(0x5390) == 1); /* [bp-4] @0x21D3B sbb/inc */
    int u = (int16_t)DG16(0x5392);

    if (u >= 0) {                                  /* @0x21D46 */
        DG16(0x1EA2) = 0;                          /* @0x21D4D */
        func_006608_logic_sz_106((uint16_t)u);     /* @0x21D56 deselect notify */
        ovl_deselect_fx(UB(u,0), UB(u,1));         /* @0x21D72 0x9BA(1,1,1,y,x) */
        DG16(0x1EA2) = 1;                          /* @0x21D7A */
    }

    /* @0x21D80 needs-orders gate: when the unit no longer needs orders, or
     * the caller didn't ask for notification, run the order message + ladder */
    if (func_007A80_op_sz_143((uint16_t)u) == 0 || notify == 0) {  /* @0x21D88/0x21D8C */
        int id = func_007B10_logic_sz_83((uint16_t)u);  /* @0x21D95 */
        func_006F5A_op_sz_105((uint16_t)id);            /* @0x21D9B */
        /* order ladder @0x21DA8..0x21DC9: orders 5,6,8,9 -> done=1 (and the
         * autumn flag clears); everything else -> keep the autumn flag */
        {
            int o = UB(u, 8);
            if (o == 5 || o == 6 || o == 8 || o == 9) {
                was_autumn = 0;                    /* @0x21DC4 [bp-4]=0 */
                done = 1;                          /* @0x21DC9 [bp-2]=1 */
            } else {
                was_autumn = 1;                    /* @0x21DBD [bp-4]=1 */
            }
        }
    }

    if (u >= 0) {                                  /* @0x21DCE */
        DG16(0x5390) = 0;                          /* @0x21DD7 season -> Spring */
        DG16(0x53C6) = 0;                          /* @0x21DDA */
        if (done == 0) {                           /* @0x21DDD */
            if (func_005BFA_logic_sz_49(UB(u,0), UB(u,1))) {     /* @0x21DF3 */
                func_00BD28_op_sz_34(UB(u,0), UB(u,1));          /* @0x21E10 reveal */
                if (was_autumn)                                  /* @0x21E18 */
                    func_00BF3C_logic_sz_182(DG16(0x8540), DG16(0x853E),
                                             DG16(0x8540), DG16(0x853E), 0);
                                                                 /* @0x21E30 cursor box */
            }
        }
        func_021A14_sec_sz_602();                  /* @0x21E39 near 0x24BD7 ->
                                                    * func_021A14 (Spring refresh;
                                                    * = spring_turn_process) */
    } else {
        DG16(0x53C6) = 1;                          /* @0x21E3E */
        DG16(0x5390) = 1;                          /* @0x21E45 near 0x24BA5 ->
                                                    * 0x0217E2 begin-Autumn trigger
                                                    * ([0x5390]=1); PARTIAL -- the
                                                    * full 0x217E2 body pending */
        if (DG16(0x97B0) != 0 && (DG8(0x5383) & 8) == 0)         /* @0x21E48 */
            DG16(0x53C4) = 0;                      /* @0x21E56 */
    }

    if (u >= 0 && (DG8(0x5382) & 0x80))            /* @0x21E5C/0x21E63 */
        func_020F50_tutorial_hints();              /* @0x21E6A call 0x20F50 */
    return done;                                   /* @0x21E6D */
}

#endif /* _VICEROY_MODERN */
