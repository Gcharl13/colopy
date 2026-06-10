/* ============================================================================
 *        >>> HEAD + ORDER-BYTE DISPATCH + EXIT TAIL (0x51C68) BYTE_VERIFIED;
 *            the per-candidate SCORING BODY (0x4E50C..0x51C68) is pending <<<
 * ----------------------------------------------------------------------------
 * unit/move.c -- the per-unit MOVE-STEP evaluator (func_04E2D6).
 *
 * This is the large (14975-byte) routine that, for one unit, decides and scores
 * its movement / action for the current step. The brief identifies it as the
 * move evaluator with an "order-byte dispatch 0/5/6/0xa" at its head -- that
 * dispatch is reproduced below byte-for-byte. The bulk of the function is a
 * per-candidate scoring loop whose weight tables are overlay/data-resident; the
 * HEAD (entry + order dispatch + validity gate + initial state-collection) and
 * the EXIT TAIL (file 0x51C68..0x51D55: auto-sentry / sentry wake-scan /
 * goto-arrival, the shared target of every `jmp 0x51c68` early-out) are ported;
 * the deep scoring body between them is the remaining gap.
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
 * [bx+0x314C],0; 0x4E353 mov [si+0x314B],0x40 -- all match).
 * CORRECTED 2026-06-10: the early-out jmps decode to file 0x51C68 (e.g.
 * 0x4E31A e9 4b 39 -> 0x4E31D+0x394B), not the stale "0x6218" cs-relative
 * reading; the tail there is now fully ported (move_eval_tail_51C68).
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
#include "dgroup.h"

/* ---- DGROUP globals (near) ------------------------------------------------- */
extern uint8_t  g_units_3144[];   /* DGROUP:0x3144 unit-table byte image */

/* DGROUP:0x8542 -- active record ptr (current unit/colony). Its .x=[bx+0],
 * .y=[bx+1] are read at @asm 0x04E3B4/0x04E3BA etc.  DGROUP:0x8D4A -- AI
 * per-power bookkeeping struct ptr (.x/.y at +0/+1; a word array at +0xA),
 * @asm 0x04E46B.  Both are 16-bit NEAR pointers (DGROUP offsets): the asm is
 * `mov bx,[0x8542] / mov al,[bx+1]`, so the modern read rebases the stored
 * word through g_dgroup (DG8(DG16(ptr)+k)) -- never a host pointer. */
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
#define U_DESTX  0x09   /* [bx+0x314D] goto destination x */
#define U_DESTY  0x0A   /* [bx+0x314E] goto destination y */

/* ---- cross-segment capability / query helpers (0x181F:*) -------------------
 * Arg/return shapes from the call sites only; the bitmask tests are byte-clear
 * (test/and 0xA, 0x40).  0x181F:0x302 RESOLVED 2026-06-10: it is
 * map_in_bounds(x,y) = (1 <= x < [0x853A]-1 && 1 <= y < [0x853C]-1),
 * resident func_005BFA, full body byte-verified (docs/RESIDENT_LIB.md). */
extern int func_005BFA_logic_sz_49(uint16_t x, uint16_t y);
                       /* @asm 0x04E347 lcall 0x181F:0x302 = map_in_bounds
                        * (resident func_005BFA, BYTE_VERIFIED port in
                        * src/load_image/load_image_004EE6_005DF0.c) */
extern int16_t ovly_query_181F_952(int16_t owner, int16_t y, int16_t x);/* @asm 0x04E387 */
extern int16_t ovly_query_181F_614(int16_t x, int16_t y, int16_t a, int16_t b);/* @asm 0x04E39E */
extern int16_t ovly_query_181F_722(int16_t x, int16_t y);            /* @asm 0x04E3BD */
extern int16_t ovly_query_181F_d84(int16_t x, int16_t y, int16_t a, int16_t b);/* @asm 0x04E419 */
extern int16_t ovly_market_181F_30C(int16_t owner, int16_t ctx);     /* @asm 0x04E44D */
extern int16_t ovly_market_181F_a60(int16_t v);                      /* @asm 0x04E456 */
extern int16_t ovly_query_181F_78C(int16_t x, int16_t y);            /* @asm 0x04E4B7 */
extern int16_t ovly_query_181F_72C(int16_t x, int16_t y);            /* @asm 0x04E4E4 */
extern int16_t ovly_query_181F_754(int16_t x, int16_t y);            /* @asm 0x04E4FB */

/* ---- the EXIT TAIL's three far calls, resolved through the thunk rule ------
 * (table file 0x1A5F0; all three are Type-B RESIDENT records, loader 0x0D91):
 *   0x181F:0x696 -> 037F:0358 = file 0x05F48  owner-at-tile probe
 *   0x181F:0xA38 -> 05B3:0004 = file 0x07F34  relations-byte reader
 *   0x181F:0x934 -> 0427:155E = file 0x07BCE  UnitRecord+0x05 refresh
 * All three bodies are already BYTE_VERIFIED ports: */
extern int  func_005F48_logic_sz_58(uint16_t x, uint16_t y);
                       /* power index 0..3 of the unit at (x,y) when the
                        * layer-160 unit bit is set; else -1
                        * (src/load_image/load_image_005DF0_006939.c) */
extern int  func_007F34_logic_sz_27(uint16_t power, uint16_t off);
                       /* relations byte: PowerRecord+0x34[off] (power<4) or
                        * the 0x59D8 0x4E-stride table (power>=4); bit 0x40 =
                        * at-war (src/load_image/load_image_007610_00824E.c) */
extern void func_007BCE_logic_sz_25(uint16_t unit_index);
                       /* UnitRecord[unit]+0x05 := func_006CCA(unit)
                        * (src/load_image/load_image_007610_00824E.c) */

static int16_t move_eval_tail_51C68(int16_t unit_index, int16_t owner);

/* ============================================================================
 * unit_move_step -- func_04E2D6 (page 0x0D), file 0x04E2D6..0x51D55 (14975 b)
 * ----------------------------------------------------------------------------
 * Head + order-byte dispatch + validity gate + initial state collection, then
 * the (real) exit tail at 0x51C68.  The scoring body between them leans on
 * leaves that ARE decoded -- the func_05CA7E modifier ladder (ai/unit_ai_leaf.c)
 * and combat/combat_modifiers.c defend_strength -- but its own candidate loops
 * are still to be ported.
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
            return move_eval_tail_51C68(unit_index, owner); /* @asm 0x04E31A jmp 0x51c68 */
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
     * @asm 0x04E358 jmp 0x51c68 */
    if (func_005BFA_logic_sz_49((uint16_t)map_x, (uint16_t)map_y) == 0) {
        U_OFF(unit_index, U_PROF) = 0x40;        /* @asm 0x04E353 */
        return move_eval_tail_51C68(unit_index, owner); /* @asm 0x04E358 jmp 0x51c68 */
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
    /* active record (0x8542) origin probes: near ptr -> .x/.y bytes */
    (void)ovly_query_181F_722(DG8(DG16(0x8542) + 0),
                              DG8(DG16(0x8542) + 1));           /* @asm 0x04E3BD -> [bp-0x70] */
    (void)ovly_query_181F_614(map_x, map_y, -1, -1);           /* @asm 0x04E3D6 -> [bp-0x60] */
    (void)ovly_query_181F_d84(map_x, map_y, -1, -1);           /* @asm 0x04E419 -> [bp-0xAA] */
    /* AI bookkeeping (0x8D4A) origin probe: near ptr -> .x/.y bytes */
    (void)ovly_query_181F_722(DG8(DG16(0x8D4A) + 0),
                              DG8(DG16(0x8D4A) + 1));            /* @asm 0x04E439 -> [bp-0x9C] */
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

    /* ---- THE SCORING BODY (file 0x4E50C..0x51C68) -------------------------- *
     * Everything from here scores each of the (up to 8) move candidates using
     * overlay/data-resident weight tables and writes the chosen action back to
     * the UnitRecord (orders 0x0B/0x0C + dest, attack commits, etc.).  That
     * ~13.5KB body is the remaining unported gap of this function; until it
     * lands, AI units do not CHOOSE new moves here -- they fall through to the
     * (real) exit tail, which maintains standing orders byte-faithfully. */
    return move_eval_tail_51C68(unit_index, owner);            /* falls into 0x51c68 */
}

/* ============================================================================
 * move_eval_tail_51C68 -- the EXIT TAIL of func_04E2D6, file 0x51C68..0x51D55.
 * ----------------------------------------------------------------------------
 * The shared target of every early-out `jmp 0x51c68` in the function (the
 * order-byte dispatch @0x4E31A, the validity gate @0x4E358, and nine more
 * inside the scoring body) and the natural fall-through of the body itself.
 * Decoded byte-for-byte 2026-06-10 from re_work/disasm/func_04E2D6.asm:
 *
 *   (a) AUTO-SENTRY    @asm 0x51C68..0x51C88
 *       orders 0x0A or 0  ->  prof := 0x30 ('0'), orders := 5
 *   (b) SENTRY WAKE    @asm 0x51C88..0x51D03
 *       if orders==5: re-read x/y from the record (@0x51C93/0x51C9D -- the
 *       body may have moved the unit), then for dir 0..7 probe the neighbour
 *       tile (signed deltas dx@DGROUP:0x00B4[dir], dy@DGROUP:0x00BE[dir],
 *       CWDE at 0x51CCD/0x51CDA); owner_at = 0x181F:0x696(nx,ny); skip empty
 *       (<0, @0x51CEE jl) or own power (@0x51CF2); else if
 *       0x181F:0xA38(own, other) has bit 0x40 (at war, @0x51CB9 test al,0x40)
 *       -> orders := 0 (WAKE, @0x51CFE) and stop scanning (@0x51CBB jne).
 *       NOTE: 0x181F:0x696 returns power 0..3 only (>=4 -> -1), so the wake
 *       triggers on adjacent EUROPEAN at-war units, not native braves.
 *   (c) GOTO ARRIVAL   @asm 0x51D03..0x51D47
 *       if orders==0x0B and dest (+0x314D/+0x314E) equals the current x/y:
 *       ship band (type 0x0D..0x12, @0x51D22/0x51D29) with prof 0x31
 *       -> prof := 0x42 ('B', @0x51D37); then ALWAYS (the jb/ja/jne all land
 *       at 0x51D3C) call 0x181F:0x934(unit) -- the UnitRecord+0x05 refresh.
 *       Orders stay 0x0B here; the clear belongs to the order engine.
 *   (d) RESULT         @asm 0x51D47..0x51D54
 *       [bp-0xB6] := 0; AX = [bp-0xB6]; LEAVE; RETF  -> returns 0.
 *
 * `owner` is the caller's [bp-0xE4] (set @0x4E2F3 BEFORE the dispatch, so it
 * is live on every path into the tail).
 * ============================================================================ */
static int16_t move_eval_tail_51C68(int16_t unit_index, int16_t owner)
{
    /* (a) auto-sentry */
    {
        uint8_t orders = U_OFF(unit_index, U_ORDERS);  /* @asm 0x51C68 imul */
        if (orders == 0x0A || orders == 0) {           /* @asm 0x51C6C/0x51C73 */
            U_OFF(unit_index, U_PROF)   = 0x30;        /* @asm 0x51C7E */
            U_OFF(unit_index, U_ORDERS) = 5;           /* @asm 0x51C83 */
        }
    }

    /* (b) sentry wake-scan over the 8 neighbours */
    if (U_OFF(unit_index, U_ORDERS) == 5) {            /* @asm 0x51C8C */
        int16_t x = U_OFF(unit_index, U_MAPX);         /* @asm 0x51C93 re-read */
        int16_t y = U_OFF(unit_index, U_MAPY);         /* @asm 0x51C9D */
        for (int16_t dir = 0; dir < 8; dir++) {        /* @asm 0x51CA5/0x51CC0 */
            int16_t ny = (int16_t)((int8_t)DG8(0x00BE + dir) + y); /* @asm 0x51CC9 cwde */
            int16_t nx = (int16_t)((int8_t)DG8(0x00B4 + dir) + x); /* @asm 0x51CD6 cwde */
            int16_t other = (int16_t)func_005F48_logic_sz_58(
                                (uint16_t)nx, (uint16_t)ny);       /* @asm 0x51CE3 */
            if (other < 0)      continue;              /* @asm 0x51CEE jl  */
            if (other == owner) continue;              /* @asm 0x51CF2 cmp [bp-0xE4] */
            if (func_007F34_logic_sz_27((uint16_t)owner,
                                        (uint16_t)other) & 0x40) { /* @asm 0x51CB1/0x51CB9 */
                U_OFF(unit_index, U_ORDERS) = 0;       /* @asm 0x51CFE wake */
                break;                                 /* @asm 0x51CBB jne 0x51cfa */
            }
        }
    }

    /* (c) goto arrival */
    if (U_OFF(unit_index, U_ORDERS) == 0x0B            /* @asm 0x51D07 */
        && U_OFF(unit_index, U_DESTX) == U_OFF(unit_index, U_MAPX)   /* @asm 0x51D12 */
        && U_OFF(unit_index, U_DESTY) == U_OFF(unit_index, U_MAPY)) {/* @asm 0x51D1C */
        uint8_t type = U_OFF(unit_index, U_TYPE);
        if (type >= 0x0D && type <= 0x12               /* @asm 0x51D22/0x51D29 */
            && U_OFF(unit_index, U_PROF) == 0x31)      /* @asm 0x51D30 */
            U_OFF(unit_index, U_PROF) = 0x42;          /* @asm 0x51D37 */
        func_007BCE_logic_sz_25((uint16_t)unit_index); /* @asm 0x51D3F 0x181F:0x934 */
    }

    return 0;                                          /* @asm 0x51D47..0x51D54 */
}

/* ============================================================================
 * NOTES / TODO_VERIFY
 * ----------------------------------------------------------------------------
 *  - Order-byte dispatch (0/5/6/>=0xA proceed; 1-4,7-9 skip), the validity
 *    gate (0x181F:0x302 -> profession:=0x40 on fail), and the EXIT TAIL
 *    (0x51C68..0x51D55: auto-sentry / wake-scan / goto-arrival) are
 *    BYTE_VERIFIED.
 *  - The 0x181F:* probe helpers in the head have bodies in thunk pages; their
 *    arg/return shapes are taken from the call sites only -- nothing invented.
 *    The `(void)` casts mark results that feed the (not yet ported) scoring
 *    scratchpad.
 *  - The per-candidate SCORING BODY (file 0x4E50C..0x51C68, ~13.5KB) and its
 *    weight tables remain to be ported; the head currently falls through to
 *    the tail, so AI units maintain standing orders but do not choose new
 *    moves from this function yet.
 *  - [bp-0x74]=8 (candidate budget) and the +0x314B "special profession"
 *    branch are reproduced; their downstream use sits in the scoring body.
 * ============================================================================ */
