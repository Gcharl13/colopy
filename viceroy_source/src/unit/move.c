/* ============================================================================
 *        >>> HEAD + ORDER-BYTE DISPATCH BYTE_VERIFIED; deep per-candidate
 *            SCORING TAIL (file 0x6218+) is RUNTIME_ONLY (data-resident) <<<
 * ----------------------------------------------------------------------------
 * unit/move.c -- the per-unit MOVE-STEP evaluator (func_04E2D6).
 *
 * This is the large (14975-byte) routine that, for one unit, decides and scores
 * its movement / action for the current step. The brief identifies it as the
 * move evaluator with an "order-byte dispatch 0/5/6/0xa" at its head -- that
 * dispatch is reproduced below byte-for-byte. The bulk of the function is a
 * per-candidate scoring loop whose weight tables are overlay/data-resident; per
 * the brief, the HEAD (entry + order dispatch + validity gate + initial
 * state-collection) is ported and the scoring tail is RUNTIME_ONLY (not yet decoded).
 *
 * Entry: unit index in [bp+6] (the acting unit, *0x1C). ENTER 0xEE,0 -> 0x77
 * words of locals (a big scoring scratchpad). UnitRecord fields read at the
 * head (base DGROUP:0x3144, stride 0x1C):
 *   +0x03 owner (low nibble, [bx+0x3147]&0xF)   @asm 0x04E2F3
 *   +0x08 orders  ([bx+0x314C])                 @asm 0x04E2FE  <-- the dispatch
 *   +0x00 map_x   ([bx+0x3144])                 @asm 0x04E321
 *   +0x01 map_y   ([bx+0x3145])                 @asm 0x04E32B
 *   +0x02 type    ([bx+0x3146])                 @asm 0x04E33A / 0x04E494
 *   +0x07 profession ([bx+0x314B]) tested 0x74/0x69; set 0x40 on invalid
 *                                               @asm 0x04E360 / 0x04E353
 *
 * BYTE_VERIFIED 2026-05-30: the head offsets were checked against the raw
 * VICEROY.EXE (0x4E2D6 enter 0xEE; 0x4E2EF imul bx,[bp+6],0x1C; 0x4E2FE cmp
 * [bx+0x314C],0; 0x4E31A jmp 0x6218; 0x4E353 mov [si+0x314B],0x40 -- all match).
 *
 * @region          overlay (page 0x0D, code_base 0x04C1F0)
 * @verified_by     Hand-decompiled from VICEROY.EXE 2026-05-30 (page_0D.asm
 *                  full body head + raw-byte spot checks).
 * @ref             code/VICEROY/disasm_overlay_reseg/page_0D.asm  (func_04E2D6)
 * @ref             code/VICEROY/disasm/func_04E2D6_unknown.asm
 * @ref             include/unit.h
 * ============================================================================ */
#include "viceroy_types.h"
#include "unit.h"

/* ---- DGROUP globals (near) ------------------------------------------------- */
extern uint8_t  g_units_3144[];   /* DGROUP:0x3144 unit-table byte image */

/* DGROUP:0x8542 -- active record ptr (current unit/colony). Its .x=[bx+0],
 * .y=[bx+1] are read at @asm 0x04E3B4/0x04E3BA etc. */
extern uint8_t far *g_active_record_8542;
/* DGROUP:0x8D4A -- AI per-power bookkeeping struct ptr (.x/.y at +0/+1; a word
 * array at +0xA). @asm 0x04E2_29DC / 0x04E46B. */
extern uint8_t far *g_ai_bookkeep_8D4A;
/* DGROUP:0x8DB8 -- a scratch word re-read repeatedly into locals. @asm 0x04E3AA. */
extern uint16_t g_word_8DB8;
/* DGROUP:0x8D52 -- a market/commodity context word pushed to 0x181F:0x30C.
 * @asm 0x04E449. */
extern uint16_t g_word_8D52;

/* ---- UnitRecord byte accessors -------------------------------------------- */
#define U_OFF(idx, k)  g_units_3144[(idx) * UNIT_RECORD_STRIDE + (k)]
#define U_MAPX   0x00
#define U_MAPY   0x01
#define U_TYPE   0x02
#define U_OWNER  0x03
#define U_PROF   0x07
#define U_ORDERS 0x08

/* ---- cross-segment capability / query helpers (0x181F:*) -------------------
 * Arg/return shapes from the call sites only; the bitmask tests are byte-clear
 * (test/and 0xA, 0x40) but the precise ability semantics are not yet decoded. NONE invented. */
extern int16_t ovly_unit_valid_here_181F_302(int16_t x, int16_t y);  /* @asm 0x04E347 */
extern int16_t ovly_query_181F_952(int16_t owner, int16_t y, int16_t x);/* @asm 0x04E387 */
extern int16_t ovly_query_181F_614(int16_t x, int16_t y, int16_t a, int16_t b);/* @asm 0x04E39E */
extern int16_t ovly_query_181F_722(int16_t x, int16_t y);            /* @asm 0x04E3BD */
extern int16_t ovly_query_181F_d84(int16_t x, int16_t y, int16_t a, int16_t b);/* @asm 0x04E419 */
extern int16_t ovly_market_181F_30C(int16_t owner, int16_t ctx);     /* @asm 0x04E44D */
extern int16_t ovly_market_181F_a60(int16_t v);                      /* @asm 0x04E456 */
extern int16_t ovly_query_181F_78C(int16_t x, int16_t y);            /* @asm 0x04E4B7 */
extern int16_t ovly_query_181F_72C(int16_t x, int16_t y);            /* @asm 0x04E4E4 */
extern int16_t ovly_query_181F_754(int16_t x, int16_t y);            /* @asm 0x04E4FB */

/* The deep scoring tail (file 0x6218+, ~0x6000 bytes of candidate loops over
 * overlay-resident weight tables). Modeled as an opaque continuation; its body
 * and the per-candidate weights are RUNTIME_ONLY (data-resident). */
extern int16_t ovly_move_score_tail_6218(int16_t unit_index);

/* ============================================================================
 * unit_move_step -- func_04E2D6 (page 0x0D), file 0x04E2D6..(RETF; 14975 bytes)
 * ----------------------------------------------------------------------------
 * Head + order-byte dispatch + validity gate + initial state collection. The
 * scoring tail is reached at file 0x6218 (the `jmp 0x6218` exit target shared
 * by the early-out branches) and is not yet decoded.
 * ============================================================================ */
int16_t unit_move_step(int16_t unit_index)
{
    int16_t owner;        /* [bp-0xE4] */
    int16_t map_x;        /* [bp-0x86] */
    int16_t map_y;        /* [bp-0x92] */
    int16_t type;         /* [bp-0x62] */
    int16_t occ;          /* [bp-0xA8] / scratch */

    /* @asm 0x04E2DC mov [bp-0xB6],1   -- a default "result/continue" flag = 1
     * @asm 0x04E2E2 sub ax,ax; clear [bp-0x8C], [bp-0x10], [bp-0xAC]  -- accums */

    /* @asm 0x04E2EF imul bx,[bp+6],0x1C
     * @asm 0x04E2F3 mov al,[bx+0x3147]; and ax,0xF; mov [bp-0xE4],ax */
    owner = U_OFF(unit_index, U_OWNER) & 0x0F;

    /* ---- ORDER-BYTE DISPATCH (the brief's "0/5/6/0xa") ---------------------
     * @asm 0x04E2FE cmp [bx+0x314C],0;   je  0x28CD   (proceed)
     * @asm 0x04E305 cmp [bx+0x314C],5;   je  0x28CD   (proceed)
     * @asm 0x04E30C cmp [bx+0x314C],6;   je  0x28CD   (proceed)
     * @asm 0x04E313 cmp [bx+0x314C],0xA; jae 0x28CD   (proceed)
     * @asm 0x04E31A jmp 0x6218                         (skip to scoring tail)
     *
     * So orders 0 (none), 5, 6, or >= 0xA take the active move-evaluation path;
     * orders in {1,2,3,4,7,8,9} (the busy multi-turn states: fortify / sentry /
     * build-road / plow / goto etc.) skip straight to the tail. The compare is
     * unsigned (jae), so 0xA..0xFF all proceed. */
    {
        uint8_t orders = U_OFF(unit_index, U_ORDERS);
        int proceed = (orders == 0) || (orders == 5) || (orders == 6)
                      || (orders >= 0x0A);
        if (!proceed)
            return ovly_move_score_tail_6218(unit_index); /* @asm 0x04E31A jmp 0x6218 */
    }

    /* ---- 0x28CD: collect the unit's tile + type --------------------------- */
    /* @asm 0x04E321 map_x = [bx+0x3144]; @asm 0x04E32B map_y = [bx+0x3145] */
    map_x = U_OFF(unit_index, U_MAPX);
    map_y = U_OFF(unit_index, U_MAPY);
    /* @asm 0x04E335 [bp-0x74] = 8  (direction count / candidate budget) */
    /* @asm 0x04E33A type = [bx+0x3146] */
    type = U_OFF(unit_index, U_TYPE);

    /* ---- validity gate: can the unit legally be at (x,y)? ------------------
     * @asm 0x04E347 lcall 0x181F:0x302(x,y); if 0 -> mark invalid + bail.
     * @asm 0x04E353 mov [si+0x314B],0x40   (profession byte := 0x40 == "stuck")
     * @asm 0x04E358 jmp 0x6218 */
    if (ovly_unit_valid_here_181F_302(map_x, map_y) == 0) {
        U_OFF(unit_index, U_PROF) = 0x40;        /* @asm 0x04E353 */
        return ovly_move_score_tail_6218(unit_index); /* @asm 0x04E358 jmp 0x6218 */
    }

    /* ---- special profession flag: 0x74 or 0x69 -> a "special" unit kind ----
     * @asm 0x04E360 cmp [bx+0x314B],0x74; je set1
     * @asm 0x04E367 cmp [bx+0x314B],0x69; jne set0
     *      [bp-4] = (prof==0x74 || prof==0x69) ? 1 : 0 */
    {
        uint8_t prof = U_OFF(unit_index, U_PROF);
        int special = (prof == 0x74 || prof == 0x69) ? 1 : 0;  /* @asm 0x04E36E/0x04E376 */
        (void)special; /* feeds the scoring tail */
    }

    /* ---- initial state collection: a battery of map/capability probes that
     * seed the scoring scratchpad. These are byte-clear call edges with bodies
     * in thunk pages; reproduced for fidelity of side effects. -------------- */
    (void)ovly_query_181F_952(owner, map_y, map_x);            /* @asm 0x04E387 -> [bp-0x18] */
    (void)ovly_query_181F_614(map_x, map_y, -1, -1);           /* @asm 0x04E39E -> [bp-0xE2] */
    /* active record (0x8542) origin probes */
    (void)ovly_query_181F_722(g_active_record_8542[0],
                              g_active_record_8542[1]);         /* @asm 0x04E3BD -> [bp-0x70] */
    (void)ovly_query_181F_614(map_x, map_y, -1, -1);           /* @asm 0x04E3D6 -> [bp-0x60] */
    (void)ovly_query_181F_d84(map_x, map_y, -1, -1);           /* @asm 0x04E419 -> [bp-0xAA] */
    /* AI bookkeeping (0x8D4A) origin probe */
    (void)ovly_query_181F_722(g_ai_bookkeep_8D4A[0],
                              g_ai_bookkeep_8D4A[1]);            /* @asm 0x04E439 -> [bp-0x9C] */
    /* market context */
    {
        int16_t mv = ovly_market_181F_30C(owner, (int16_t)g_word_8D52); /* @asm 0x04E44D */
        (void)ovly_market_181F_a60(mv);                         /* @asm 0x04E456 -> [bp-0x52] */
    }

    /* ---- occupant kind at this tile (0x19/0x1A flags) --------------------- */
    /* @asm 0x04E4B7 occ = 0x181F:0x78C(x,y); [bp-0x8E] = (occ==0x19||occ==0x1A) */
    occ = ovly_query_181F_78C(map_x, map_y);
    {
        int colony_like = (occ == 0x19 || occ == 0x1A) ? 1 : 0; /* @asm 0x04E4CD/0x04E4D6 */
        (void)colony_like;
    }
    /* @asm 0x04E494 type band 0x0D..0x12 -> [bp-0x32] (native/scout band flag) */
    {
        int band = (type >= 0x0D && type <= 0x12) ? 1 : 0;     /* @asm 0x04E494..0x04E4A2 */
        (void)band;
    }
    /* @asm 0x04E4E4 ability 0x72C & 0x40 -> [bp-0x82]; 0x04E4FB ability 0x754 & 0xA */
    (void)(ovly_query_181F_72C(map_x, map_y) & 0x40);          /* @asm 0x04E4EC */
    (void)(ovly_query_181F_754(map_x, map_y) & 0x0A);          /* @asm 0x04E503 */

    /* ---- THE SCORING TAIL (file 0x6218 and the candidate loops) ----------- *
     * Everything from here scores each of the (up to 8) move candidates using
     * overlay/data-resident weight tables and finally writes the chosen action
     * back to the UnitRecord. That logic is NOT in this code segment and its
     * weights are data-resident -- RUNTIME_ONLY (not yet decoded) per the brief. The
     * function ultimately returns AX (the chosen-move / result word). */
    return ovly_move_score_tail_6218(unit_index);              /* @asm reaches 0x6218 */
}

/* ============================================================================
 * NOTES / TODO_VERIFY
 * ----------------------------------------------------------------------------
 *  - Order-byte dispatch (0/5/6/>=0xA proceed; 1-4,7-9 skip) and the validity
 *    gate (0x181F:0x302 -> profession:=0x40 on fail) are BYTE_VERIFIED.
 *  - The 0x181F:* probe helpers have bodies in thunk pages; their arg/return
 *    shapes are taken from the call sites only -- nothing invented. The `(void)`
 *    casts mark results that feed the (not yet decoded) scoring scratchpad.
 *  - The per-candidate SCORING (file 0x6218 onward, ~0x6000 bytes) and its
 *    weight tables are RUNTIME_ONLY (data-resident), as directed.
 *  - [bp-0x74]=8 (candidate budget) and the +0x314B "special profession"
 *    branch are reproduced; their downstream use is not yet decoded.
 * ============================================================================ */
