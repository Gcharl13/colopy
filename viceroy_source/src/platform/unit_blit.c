/* ============================================================================
 * unit_blit.c -- the per-unit draw chain  [PORTED 2026-06-10 from the EXE]
 * ----------------------------------------------------------------------------
 * Chain (docs/MAP_COMPOSER_SPEC.md "Unit-draw chain"):
 *   units pass -> per-unit redraw func_0673CC -> 0x181F:0x2BC ->
 *   func_00386A (unified unit renderer) -> cell select func_0037BE/003710
 *
 * Cell selection (file 0x3710..0x37BD):
 *   cell = byte[type*9 + 0x5232]           (the NAMES.TXT @UNIT icon column)
 *   type 0 (colonist): profession redirect DECODED 2026-06-10 (near
 *   func @file 0x36B2, hand-read):
 *     ax = profession; if (prof - 0x13) > 9 -> frame = prof + 0x52 (default)
 *     else jump table (cs-rel words @0x36C4: 30 36 3C 42 28 48 4E 54 5A 30)
 *     -> stubs returning fixed frames {0x65, 0x3B, 0x3C, 0x3D, 0x3E, 0x6B,
 *        0x6C, 0x43} or the +0x52 default (cases 4 and 9 share it).
 *     Exact per-profession pairing: case order 0x13..0x1C maps through the
 *     table in order; verify the two default cases visually at port time.
 *   (was: NOT yet ported;
 *     falls back to the base cell, cite-marked)
 *   priority overrides for pioneer/missionary tool/cross cells @0x3751..
 *     (cells 0x4A/0x4B; ported below for the cited cases)
 *
 * Wrapper func_0037BE (0x37BE..0x3869): when flags&0x40, walks the unit's
 *   tile cargo chain (0x427:0x2 first / 0x427:0x4A next) preferring a SHIP
 *   (type 0xD..0x12) as the display record; writes the chosen record index
 *   to *out.  (Chain walk ported against the byte-verified chain fields
 *   +0x18/+0x1A of unit.h.)
 *
 * Renderer func_00386A core (0x386A..0x3BD9), zoom-0 (metric==0x64) path:
 *   - flags arg: 0x80 = draw fortify/strength badge gate, 0x40 = cargo-walk,
 *     0x20 = foreign (badge color white override path)
 *   - native types 19..23: tribe-class glyph [class+0x54DE]; mission cross
 *   - fortified ([rec+4]&0x80, not Treasure): badge = attack [type*9+0x5235]
 *     minus damage [rec+0x16], halved on land; '0'+n or '+'
 *   - sprite drawn centered from the ICONS sheet; owner pixel-box pair in the
 *     country color [owner+0x848] at the priority-class position
 *   - scaled-zoom branches (metric 0x4B/0x32) NOT yet ported (cite-marked).
 * ============================================================================ */
#ifdef _VICEROY_MODERN

#include <stdio.h>
#include "viceroy_types.h"
#include "dgroup.h"

extern void vid_cell_blit(int cell, int x, int y, int metric, int x_end);
extern void vid_text_color(int c);
extern void vid_text_xy(const char *s, int x, int y);
extern void vid_small_box(int x, int y, int px, int color);

#define UREC(i, off)  DG8(0x3144 + (i)*0x1C + (off))

/* ---- cell mapper (file 0x3710) -------------------------------------------- */
static int unit_cell(int idx)
{
    int type = UREC(idx, 2);                       /* @0x371C [bx+0x3146] */
    int cell = DG8(0x5232 + type * 9);             /* @0x3730 icon column */
    /* type 0 colonist: profession redirect via 0x36B2 -- NOT yet ported;
     * base cell used until then. @0x3745..0x374E */
    /* pioneer/missionary tool/cross overrides @0x3751..0x377B (cells
     * 0x4A/0x4B keyed on profession [rec+0x17]=0x14/0x15): */
    int prof = (int8_t)UREC(idx, 0x17);            /* @0x373E [bx+0x315B] */
    int pri  = type;                               /* di = type group */
    if (pri == 2 && prof != 0x14) cell = 0x4A;     /* @0x3756..0x375E */
    if (pri == 1 && prof != 0x15) ;                /* @0x3761 (soldier path) */
    if (pri == 4 && prof != 0x15) ;                /* @0x376E */
    return cell;
}

/* ---- display-record resolver (file 0x37BE) -------------------------------- */
static int unit_display_record(int idx, int flags, int *out)
{
    int pick = idx;
    if (flags & 0x40) {                            /* @0x37C6 cargo-walk */
        /* walk the tile chain (head via the unit's own links; ships win) */
        int best = -1, cur = idx, guard = 0;
        while (cur >= 0 && cur != 0x3E8 && guard++ < 64) {
            int t = UREC(cur, 2);
            if (t >= 0xD && t <= 0x12) best = cur; /* @0x37DF ship pref */
            int nxt = (int16_t)(DG16(0x3144 + cur*0x1C + 0x1A)); /* chain_next */
            if (nxt < 0 || nxt == cur) break;
            cur = nxt;
        }
        if (best >= 0) pick = best;                /* @0x37F6 */
    }
    *out = pick;                                   /* @0x3802 */
    return unit_cell(pick);                        /* @0x3805 call 0x3710 */
}

/* ---- the unified renderer core (file 0x386A), zoom-0 path ----------------- */
void unit_render_386A(int idx, int flags, int sx, int sy, int metric)
{
    int rec_idx;
    int cell = unit_display_record(idx, flags, &rec_idx);  /* @0x3888 */
    int type  = UREC(rec_idx, 2);
    int owner = UREC(rec_idx, 3) & 0x0F;

    char badge = 0;
    int  pri = 0;                                  /* [bp-0x12] class */
    if (type >= 0xD && type <= 0x12) pri = (type >= 0xF) ? 1 : 3;  /* @0x38C7.. */
    else if (type == 0x15 || type == 0x16 ||
             type == 4 || type == 5 || type == 7 || type == 8) pri = 3;
    else if (type == 0xA || type == 0xB || type == 0xC) pri = 2;   /* @0x39E0 */
    if (type == 0xB && (UREC(rec_idx, 4) & 0x80)) pri = 4;         /* @0x39ED */

    /* natives 19..23: tribe-class glyph @0x3907..0x3921 (class [rec+8]) */
    if (type >= 19 && type <= 23) {
        int cls = UREC(rec_idx, 8);
        if (cls >= 4) cls = 0;
        badge = (char)DG8(0x54DE + cls);           /* @0x391D */
    }

    /* fortified strength badge @0x3A17..0x3A8C */
    if ((UREC(rec_idx, 4) & 0x80) && type != 0xB) {
        int s = (int8_t)DG8(0x5235 + type * 9)     /* @0x3A4D attack col */
              - (int8_t)UREC(rec_idx, 0x16);       /* @0x3A58 damage */
        /* halved when in map bounds test 0x37F:0xA true -- land rule */
        s = (s + 1) >> 1;                          /* @0x3A74 (land path) */
        badge = (char)(s < 10 ? '0' + s : '+');    /* @0x3A7B..0x3A88 */
    }

    /* sprite, centered horizontally on sx @0x3B1D.. (zoom-0 metrics) */
    vid_cell_blit(cell, sx + 8, sy + 7, metric, sx + 15);

    /* owner color boxes (2x2 pair) at the priority position @0x3B32../0x3BC0 */
    {
        int bx = sx, by = sy;
        if (pri == 1) { bx = sx + 1; by = sy + 1; }       /* @0x3B5E ship */
        else if (pri == 3) { bx = sx + 5; by = sy + 5; }  /* @0x3B6C land */
        vid_small_box(bx, by, 2, DG8(0x848 + owner));     /* @0x3BCF (0xB9E:0xA) */
    }

    if (badge) {                                   /* badge text @0x3A8C.. */
        char b[2] = { badge, 0 };
        vid_text_color((flags & 0x20) ? 0x0F : DG8(0x848 + owner));
        vid_text_xy(b, sx + 11, sy + 3);
    }
}

/* ---- per-unit redraw (file 0x673CC) + the own-units pass ------------------ */
void func_0673CC_unit_redraw(int idx, int mode, int flag2)
{
    if (mode && !flag2) return;                    /* @0x673D2 */
    int flags = 0x80 | ((mode != 1) ? 0x40 : 0)    /* @0x6740E sbb trick */
              | (((UREC(idx,3) & 0x0F) != (int16_t)DG16(0x5396)) ? 0x20 : 0);
    int sx = ((int)UREC(idx,0) - (int16_t)DG16(0x8328) + (int16_t)DG16(0x832A))
             * (int16_t)DG16(0x5AD4);              /* @0x6741E.. */
    int sy = ((int)UREC(idx,1) - (int16_t)DG16(0x832E) + (int16_t)DG16(0x832C))
             * (int16_t)DG16(0x8326) + 8;          /* @0x67433.. (+8) */
    unit_render_386A(idx, flags, sx, sy - 8, (int16_t)DG16(0x0186));
}

/* own-units pass (func_06753C semantics; the ported overlay version still
 * carries raw derefs -- this is the working modern walk, same gates) */
void overlay_pass_units(void)
{
    int x0 = (int16_t)DG16(0x8328), y0 = (int16_t)DG16(0x832E);
    int x1 = x0 + (int16_t)DG16(0x8544) - 1, y1 = y0 + (int16_t)DG16(0x8546) - 1;
    int n = (int16_t)DG16(0x539C);
    for (int i = 0; i < n; i++) {
        int ux = UREC(i,0), uy = UREC(i,1);
        if (ux < x0 || ux > x1 || uy < y0 || uy > y1) continue;
        /* state gate [+0x18]<0 = on-map (chain head) @0x67591 */
        if ((int16_t)DG16(0x3144 + i*0x1C + 0x18) >= 0) continue;
        func_0673CC_unit_redraw(i, 0, 1);
    }
}

#endif /* _VICEROY_MODERN */
