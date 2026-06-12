/* ============================================================================
 * unit_blit.c -- the per-unit draw chain  [PORTED 2026-06-10 from the EXE]
 * ----------------------------------------------------------------------------
 * Chain (docs/MAP_COMPOSER_SPEC.md "Unit-draw chain"):
 *   units pass -> per-unit redraw func_0673CC -> 0x181F:0x2BC ->
 *   func_00386A (unified unit renderer) -> cell select func_0037BE/003710
 *
 * Cell selection (file 0x3710..0x37BD)  [BYTE-FAITHFUL 2026-06-12]:
 *   cell = byte[type*14 + 0x5232]          (the NAMES.TXT @UNIT icon column;
 *   the stat-table stride is *14 -- the shl/add chain @0x3726..0x372E -- the
 *   earlier *9 reading was wrong)
 *   type 0 (colonist): profession redirect (near func @file 0x36B2):
 *     ax = profession; if (prof - 0x13) > 9 -> frame = prof + 0x52 (default)
 *     else jump table (cs-rel words @0x36C4: 30 36 3C 42 28 48 4E 54 5A 30,
 *     table seg base = 0x36C4-0x14 = 0x36B0) -> fixed frames
 *     {0x65, 0x3B, 0x3C, 0x3D, default, 0x3E, 0x6B, 0x6C, 0x43, 0x65}
 *     for prof 0x13..0x1C in order (case 0x17 = ip 0x28 = the default body;
 *     case 0x1C = ip 0x30 shares 0x65 with case 0x13).
 *   role overrides @0x3751..0x37B4: non-expert role units swap to the generic
 *     role figure (type2/prof!=0x14 -> 0x4A, type1/prof!=0x15 -> 0x4B,
 *     type4/prof!=0x15 -> 0x4D, type5/prof!=0x16 -> 0x4C,
 *     type3/prof!=0x18 -> 0x4E); type 0xB with [rec+4]&0x80 -> 0x42.
 *
 * Wrapper func_0037BE (0x37BE..0x380B): when flags&0x40, walks the unit's
 *   tile chain from the resolved head (0x427:0x2 = unit_chain_resolve,
 *   0x427:0x4A = unit_chain_next) and picks the FIRST SHIP (type 0xD..0x12)
 *   as the display record; writes the chosen record index to *out and tail
 *   calls the cell mapper.
 *
 * Renderer func_00386A: NOT 880 bytes -- the auto span cut at 0x3BD9 falls
 *   mid-body; the true extent is 0x386A..0x3E3D (retf 6), just before
 *   func_003E40.  The [bp+6] stack word is the zoom METRIC: == 0x64 takes
 *   the figure+label-box path @0x3BDA.. (ported byte-faithfully below as
 *   unit_figure_blit_64, 2026-06-12); != 0x64 takes the scaled path
 *   @0x3B3A..0x3BB0 (sprite via 0xC56:4 + owner boxes; still approximated
 *   by unit_render_386A below).
 * ============================================================================ */
#ifdef _VICEROY_MODERN

#include <stdio.h>
#include "viceroy_types.h"
#include "dgroup.h"
#include "unit.h"                /* unit_chain_resolve / unit_chain_next */

extern void vid_cell_blit(int cell, int x, int y, int metric, int x_end);
extern void vid_text_color(int c);
extern void vid_text_xy(const char *s, int x, int y);
extern void vid_small_box(int x, int y, int px, int color);
extern void vid_box_fill(int x, int y, int w, int h, uint8_t color); /* 0xB9E:0xA */
extern int  vid_text_width(const char *s);          /* 0xC2A:6 measure (ax=0) */
extern int  vid_text_ctx_byte0(void);               /* [0x89E] ctx byte0 */
extern void blit_sprite(int desc, int id, int x, int y);          /* 0xC36:0xA */
extern void blit_sprite_shadowed(int flags, int id, int x, int y);/* func_00380C */
extern int  sheet_frame_w_icons(int id);            /* hdr [id*0xC+0x3E] */
extern int  sheet_frame_h_icons(int id);            /* hdr [id*0xC+0x40] */
extern int  func_005BFA_logic_sz_49(uint16_t x, uint16_t y); /* 0x37F:0xA in-bounds */

#define UREC(i, off)  DG8(0x3144 + (i)*0x1C + (off))

/* ---- colonist profession -> figure cell (near func, file 0x36B2) ----------
 * BYTE-DECODED 2026-06-12: `sub ax,0x13; cmp ax,9; ja default` @0x36B4..0x36BA,
 * `jmp cs:[bx+0x14]` @0x36BF over the word table @0x36C4
 * (30 36 3C 42 28 48 4E 54 5A 30; seg base 0x36B0). */
static int colonist_prof_cell(int prof)
{
    switch (prof) {
    case 0x13: return 0x65;            /* ip 0x30 -> @0x36E0 */
    case 0x14: return 0x3B;            /* ip 0x36 -> @0x36E6 */
    case 0x15: return 0x3C;            /* ip 0x3C -> @0x36EC */
    case 0x16: return 0x3D;            /* ip 0x42 -> @0x36F2 */
    case 0x18: return 0x3E;            /* ip 0x48 -> @0x36F8 */
    case 0x19: return 0x6B;            /* ip 0x4E -> @0x36FE */
    case 0x1A: return 0x6C;            /* ip 0x54 -> @0x3704 */
    case 0x1B: return 0x43;            /* ip 0x5A -> @0x370A */
    case 0x1C: return 0x65;            /* ip 0x30 -> @0x36E0 (shared) */
    default:   return prof + 0x52;     /* @0x36D8 (incl. case 0x17, ip 0x28) */
    }
}

/* ---- cell mapper (file 0x3710..0x37BD) -- BYTE-FAITHFUL 2026-06-12 -------- */
static int unit_cell(int idx)
{
    int rec  = idx * 0x1C;                          /* @0x3716 imul bx,ax,0x1C */
    int type = DG8(0x3146 + rec);                   /* @0x371C [bx+0x3146] */
    int cell = DG8(0x5232 + type * 14);             /* @0x3726..0x3730 (*14 chain) */
    int prof = (int8_t)DG8(0x315B + rec);           /* @0x373E [bx+0x315B]; cwde */
    if (type == 0)                                  /* @0x3745 or cx,cx / jne */
        cell = colonist_prof_cell(prof);            /* @0x374B call 0x36B2 */
    if (type == 2 && prof != 0x14) cell = 0x4A;     /* @0x3751..0x375E */
    if (type == 1 && prof != 0x15) cell = 0x4B;     /* @0x3761..0x376B */
    if (type == 4 && prof != 0x15) cell = 0x4D;     /* @0x376E..0x3778 */
    if (type == 5 && prof != 0x16) cell = 0x4C;     /* @0x377B..0x3785 */
    if (type == 3 && prof != 0x18) cell = 0x4E;     /* @0x378B..0x37A2 */
    if (type == 0xB && (DG8(0x3148 + rec) & 0x80))
        cell = 0x42;                                /* @0x37A5..0x37B4 */
    return cell;                                    /* @0x37B7 mov ax,si */
}

/* ---- display-record resolver (file 0x37BE..0x380B) -- BYTE-FAITHFUL ------- */
static int unit_display_record(int idx, int flags, int *out)
{
    int pick = idx;                                /* @0x37FA mov di,[bp-6] */
    if (flags & 0x40) {                            /* @0x37C6 or dx,dx */
        int ship = -1;                             /* @0x37CA mov di,0xFFFF */
        int cur  = unit_chain_resolve(idx);        /* @0x37CD lcall 0x427:2 */
        while (cur >= 0) {                         /* @0x37D4 or si,si / jl */
            int t = UREC(cur, 2);                  /* @0x37DB [bx+0x3146] */
            if (t >= 0xD && t <= 0x12) ship = cur; /* @0x37DF..0x37E7 */
            cur = unit_chain_next(cur);            /* @0x37EB lcall 0x427:0x4A */
            if (ship >= 0) break;                  /* @0x37F2 or di,di / jl loop */
        }
        if (ship >= 0) pick = ship;                /* @0x37F6..0x37F8 */
    }
    *out = pick;                                   /* @0x3802 mov [bx],ax */
    return unit_cell(pick);                        /* @0x3805 call 0x3710 */
}

/* ============================================================================
 * unit_figure_blit_64 -- func_00386A, the metric==0x64 path (file 0x386A..
 * 0x3E3D).  BYTE-DECODED 2026-06-12 from the raw EXE (capstone over
 * re_work/VICEROY.EXE; the per-func disasm dump ends at 0x3BD9 mid-body).
 *
 * DOS calling convention: regs AX=unit DX=flags BX=x; stack words pushed in
 * order (y, box_w, metric) -> [bp+0xA]=y, [bp+8]=box_w, [bp+6]=metric;
 * retf 6.  Both colony-screen call sites pass metric=0x64 (this path).
 *
 * Draws one unit as the classic figure-with-label: the figure sprite
 * (silhouette + sprite via func_00380C = blit_sprite_shadowed), a label box
 * (outer black + inner owner-colour fill) holding the orders letter
 * [orders+0x54DE] / foreign-ship cargo digit / fortified strength digit,
 * doubled at (-2,-2)/(+2,+2) when more units share the tile, and the 0x38
 * cross overlay on fortified figures.  flags: 0x80 = stacked probe,
 * 0x40 = prefer-ship display record, 0x20 = CLEARED at entry @0x387A
 * (every later flags&0x20 test is dead).
 * ============================================================================ */
void unit_figure_blit_64(int unit, int flags, int x, int box_w, int y)
{
    char buf[2];                          /* [bp-0x32] {char,0} */
    int rec_idx, rec, type, owner, orders, cls;
    int rebel_x = 0;                      /* [bp-0x1E] @0x3875 */
    int stacked = 0;                      /* [bp-0x1C] */
    int cell, ch, boxcol, digit;
    int label_w, label_h, fig_w, fig_h, total_w;
    int dx, fig_x, label_x, label_y, box_x, box_y;

    flags &= ~0x20;                       /* @0x387A and byte[bp-0x4A],0xDF */
    cell = unit_display_record(unit, flags & 0x40, &rec_idx);
                                          /* [bp-0xC] @0x3884..0x388B (dx=flags&0x40) */
    if (flags & 0x80)                     /* @0x388E test byte[bp-0x4A],0x80 */
        stacked = (unit_chain_next(unit_chain_resolve(unit)) >= 0);
                                          /* @0x3894..0x38A4 (0x427:2 + 0x427:0x4A) */

    rec  = rec_idx * 0x1C;                /* [bp-0x40] @0x38B6 */
    type = DG8(0x3146 + rec);             /* @0x38BD */

    /* label-class ladder @0x38C7..0x39FC ([bp-0x12]) */
    cls = 0;                              /* @0x38B1 */
    if (type >= 0xD && type <= 0x12)      /* @0x38C7/0x38CF */
        cls = (type >= 0xF) ? 1 : 3;      /* @0x38D6..0x38F3 -> 0x3996 / 0x38F6 */
    else if (type == 0x15 || type == 0x16 || type == 5 ||
             type == 4 || type == 7 || type == 8)
        cls = 3;                          /* @0x399E..0x39CB -> 0x38F6 */
    else if (type == 0xC || type == 0xA || type == 0xB) {
        cls = 2;                          /* @0x39CE..0x39DB -> 0x39E0 */
        if (type == 0xB && (DG8(0x3148 + rec) & 0x80))
            cls = 4;                      /* @0x39E5..0x39F7 */
    }

    owner  = DG8(0x3147 + rec) & 0xF;     /* di @0x38FE..0x3905 */
    orders = DG8(0x314C + rec);           /* [bp-0xA] @0x3907..0x390D */
    if (owner >= 4) orders = 0;           /* @0x3910..0x3915 */
    ch = DG8(0x54DE + orders);            /* [bp-1] @0x391A..0x3921 */

    /* foreign ship: cargo digit / privateer 'X'  @0x3924..0x3955 */
    if (type >= 0xD && type <= 0x12 &&    /* @0x3927/0x392E */
        (int16_t)DG16(0x5396) != owner) { /* @0x3935 */
        ch = '0' + DG8(0x3150 + rec);     /* @0x393B..0x3941 ([rec+0xC]) */
        if (type == 0x10 && DG16(0x53A2) == 0) {  /* @0x3944/0x3949 */
            rebel_x = 1;                  /* @0x3950 */
            ch = 'X';                     /* @0x3955 (0x58) */
        }
    }
    /* active-European contact letter @0x3959..0x3986 */
    if (owner < 4 &&                      /* @0x3959 cmp di,4 / jge skip */
        DG8(0x543F + owner * 0x34) != 0 &&/* @0x3960..0x3968 */
        (DG8(0x5383) & 0x20) &&           /* @0x396A */
        (DG8(0x0894) & 8)) {              /* @0x3971 */
        ch = DG8(0x314B + rec);           /* @0x3978..0x397F ([rec+7]) */
        if (ch >= 0x80) ch = 'E';         /* @0x3982/0x3986 (0x45) */
    }

    boxcol = DG8(0x848 + owner);          /* [bp-0x1F] @0x398F/@0x3A00 */
    {
        int txtcol = boxcol;              /* [bp-0xF] @0x3A0A */
        if (rebel_x) txtcol = 0;          /* @0x3A0D..0x3A13 */

        /* fortified strength digit @0x3A17..0x3A88 */
        digit = ((DG8(0x3148 + rec) & 0x80) && type != 0xB); /* [bp-0x18] @0x3A1A/0x3A21 */
        if (digit) {
            int s = DG8(0x5235 + type * 14)   /* @0x3A3B..0x3A4D (*14 chain) */
                  - DG8(0x315A + rec);        /* @0x3A55..0x3A5C ([rec+0x16]) */
            if (func_005BFA_logic_sz_49(DG8(0x3144 + rec), DG8(0x3145 + rec)))
                s = (s + 1) >> 1;             /* @0x3A5E..0x3A79 (0x37F:0xA) */
            ch = (s < 10) ? '0' + s : '+';    /* @0x3A7B..0x3A88 */
        }

        buf[0] = (char)ch; buf[1] = 0;        /* @0x3A8F..0x3A95 */
        label_w = vid_text_width(buf) + 3;    /* [bp-0x22] @0x3A99..0x3AB0 (0xC2A:6, ax=0) */
        label_h = vid_text_ctx_byte0() + 3;   /* [bp-0x24] @0x3AB3..0x3ABF */
        fig_w   = sheet_frame_w_icons(cell);  /* [bp-0x26] @0x3AC2..0x3AE0 */
        fig_h   = sheet_frame_h_icons(cell);  /* [bp-0x1A] @0x3AF1 (0x64 mode) */
        total_w = label_w + fig_w;            /* [bp-8] @0x3AE8..0x3AEE */

        dx = x;                               /* @0x3B1D mov dx,[bp-0x48] */
        if (box_w > total_w)
            dx += (box_w - total_w) >> 1;     /* @0x3B23..0x3B30 centre in box_w */
        /* -- metric==0x64 tail @0x3B32 je -> 0x3BDA -- */
        fig_x = dx;                           /* [bp-0xE]/[bp-4] @0x3BDA/@0x3BF2 */
        dx += fig_w;                          /* @0x3BEF/0x3BF5 label right of figure */
        if (total_w > 0x10)
            dx -= total_w - 0x10;             /* @0x3BF7..0x3C07 squeeze into 16px */

        switch (cls) {                        /* dec-ladder @0x3C09..0x3C16 */
        default:                              /* class 0 @0x3C18 */
            box_x   = dx - 2;                 /* [bp-0x14] @0x3C18..0x3C1C */
            label_y = y - label_h + fig_h;    /* [bp-6] @0x3C1F..0x3C28 */
            box_y   = label_y - 2;            /* [bp-0x16] @0x3C2B..0x3C2D */
            label_x = dx;                     /* [bp-2] @0x3C35 */
            cls = 0;                          /* @0x3C30 */
            break;
        case 1:                               /* big ships @0x3C3A */
            box_x   = dx - 2;                 /* @0x3C3A..0x3C3E */
            label_y = y;                      /* @0x3C41..0x3C44 */
            box_y   = y + 2;                  /* @0x3C47..0x3C49 -> 0x3C2D */
            label_x = dx;                     /* @0x3C35 */
            cls = 0;                          /* @0x3C30 */
            break;
        case 2: case 4:                       /* wagons / treasure @0x3C4C */
            label_x = fig_x - (label_w >> 1) + 9;  /* @0x3C4C..0x3C56 */
            label_y = y + ((cls == 4) ? 2 : 0);    /* @0x3C59..0x3C63 */
            box_x   = label_x - 2;            /* @0x3C64..0x3C68 */
            box_y   = label_y + 2;            /* @0x3C6B..0x3C6E */
            cls = 1;                          /* @0x3C71 (silhouette-first) */
            break;
        case 3:                               /* galleons/artillery @0x3C7C */
            label_x = fig_x;                  /* @0x3C7C..0x3C7F */
            label_y = y;                      /* @0x3C82..0x3C85 */
            box_x   = fig_x + 2;              /* @0x3C88..0x3C8C */
            box_y   = y + 2;                  /* @0x3C8F..0x3C91 */
            cls = 1;                          /* @0x3C94 */
            fig_x  += label_w;                /* @0x3C99..0x3C9C figure right of label */
            if (total_w + 2 > 0x10)
                fig_x -= total_w - 0xE;       /* @0x3C9F..0x3CAF */
            break;
        }

        if (cls != 0)                                     /* @0x3CB2 */
            blit_sprite_shadowed(1, cell, fig_x, y);      /* @0x3CB8..0x3CC4 (0x380C, push 1) */
        if (stacked) {                                    /* @0x3CC7 */
            vid_box_fill(box_x, box_y, label_w, label_h, 0);       /* @0x3CCD..0x3CEB */
            vid_box_fill(box_x + 1, box_y + 1, label_w - 2, label_h - 2,
                         (uint8_t)txtcol);                /* @0x3CF0..0x3D17 */
        }
        vid_box_fill(label_x, label_y, label_w, label_h, 0);       /* @0x3D1C..0x3D3A */
        vid_box_fill(label_x + 1, label_y + 1, label_w - 2, label_h - 2,
                     (uint8_t)txtcol);                    /* @0x3D3F..0x3D66 */
        if (cls == 0)                                     /* @0x3D6B */
            blit_sprite_shadowed(1, cell, fig_x, y);      /* @0x3D71..0x3D7D */
        blit_sprite_shadowed(2, cell, fig_x, y);          /* @0x3D80..0x3D8C (sprite at x+2) */
    }

    /* orders / strength character (the flags&0x20 gate @0x3D8F is dead:
     * the bit was cleared at entry) @0x3D8F..0x3E08 */
    {
        int chcol;                                        /* refines [bp-0x1F] */
        if (orders == 1 || orders == 6)                   /* @0x3D96..0x3DA0 */
            chcol = (owner < 4) ? boxcol - 8 : 8;         /* @0x3DAA..0x3DB6 */
        else
            chcol = 0;                                    /* @0x3DA2 */
        if (rebel_x) chcol = 0xF;                         /* @0x3DBA..0x3DC0 */
        if (digit)   chcol = (owner == 2) ? 0xC : 0xF;    /* @0x3DC4..0x3DD6 */
        vid_text_color(chcol);                            /* @0x3DD9..0x3DE6 (0xC28:0xA) */
        vid_text_xy(buf, label_x + 2, label_y + 2);       /* @0x3DEB..0x3E08 (0xC11:0xC) */
    }
    if (digit)                                            /* @0x3E0D (and [bp+6]==0x64 @0x3E13) */
        blit_sprite(0, 0x38, fig_x + 4, y + 4);           /* @0x3E19..0x3E35 (0xC36:0xA) */
}

/* ---- the unified renderer core (file 0x386A) -- APPROXIMATION -------------
 * Kept for the map-view redraw chain (func_0673CC below).  The byte-faithful
 * metric==0x64 path now lives in unit_figure_blit_64 above; this body still
 * approximates the scaled path (its layout constants are inferred, not
 * byte-cited).  2026-06-12: the stat read is corrected to stride *14
 * (shl/add chain @0x3A41..0x3A4B), was *9. */
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
        int s = (int8_t)DG8(0x5235 + type * 14)    /* @0x3A4D attack col (*14) */
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
