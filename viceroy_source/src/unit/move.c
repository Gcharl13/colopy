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

/* ---- cross-segment leaves, ALL resolved through the thunk rule and bound to
 * their existing BYTE_VERIFIED ports (identities in docs/RESIDENT_LIB.md and
 * the per-file headers cited):
 *   0x181F:0x302 -> 0x05BFA map_in_bounds          0x181F:0x952 -> 0x0723E
 *   0x181F:0x614 -> 0x083F2 nearest-colony         0x181F:0x722 -> 0x05E90
 *   0x181F:0xD84 -> 0x46056 nearest-settlement     0x181F:0x30C -> 0x082A0
 *   0x181F:0xA60 -> 0x08262 tier classifier        0x181F:0x78C -> 0x0627A
 *   0x181F:0x72C -> 0x05CFE layer-15C read         0x181F:0x754 -> 0x05D32
 *   0x181F:0x718 -> 0x060A0 structure phase        0x181F:0x9E6 -> 0x082DC
 *   0x181F:0x37A -> 0x0493C octile distance        0x181F:0x984 -> 0x0704C
 *   0x181F:0x90C -> 0x06CCA display tile           0x181F:0x8BC -> 0x073A8
 *   0x181F:0x2EE -> 0x06672 chain head (AX-arg)    0x181F:0x2E4 -> 0x066BA next
 *   0x181F:0x98E -> 0x06696 chain tail (AX-arg; trivial walker, static below)
 * NOTE [0x8DB8]: the nearest-colony/settlement finders WRITE the winning
 * distance there (G_NEAREST_DIST) and SELECT the winner (0x8542/ctx); the
 * head snapshots it after each call -- that is the [bp-0x72]/[bp-0x2C]/
 * [bp-0x9E]/[bp-0x3A] pattern below. */
extern int func_005BFA_logic_sz_49(uint16_t x, uint16_t y);          /* in-bounds */
extern int func_00723E_op_sz_48(uint16_t x, uint16_t y, uint16_t owner);
extern int func_0083F2_op_sz_71(uint16_t x, uint16_t y, uint16_t owner_f,
                                uint16_t region_f);  /* -> colony idx; [0x8DB8]=dist */
extern int func_005E90_op_sz_64(uint16_t x, uint16_t y);   /* continent id / -1 */
extern int func_046056_nearest_settlement(uint16_t x, uint16_t y, int16_t dir);
extern int func_0082A0_logic_sz_18(uint16_t a, uint16_t b);
extern int func_008262_logic_sz_20(uint16_t v);            /* tier 0..3 (25/50/75) */
extern int func_00627A_op_sz_57(uint16_t x, uint16_t y);   /* terrain class */
extern int func_005CFE_map_tile_read_layer_15C(uint16_t x, uint16_t y);
extern int func_005D32_map_tile_read_layer_160(uint16_t x, uint16_t y);
extern int func_0060A0_logic_sz_128(uint16_t x, uint16_t y);
extern int func_0082DC_logic_sz_118(uint16_t colony);      /* select -> [0x8542]/ctx */
extern int func_00493C_logic_sz_14(uint16_t x, uint16_t y, uint16_t x2, uint16_t y2);
extern int func_00704C_op_sz_205(uint16_t x, uint16_t y, uint16_t owner);
extern int func_006CCA_logic_sz_13(uint16_t unit);
extern int func_0073A8_logic_sz_99(uint16_t unit, uint16_t category);
extern int unit_chain_resolve(int idx);                    /* func_006672 */
extern int unit_chain_next(int idx);                       /* func_0066BA */
/* page-0x0D AI helpers (already ported in overlay_04C306_053BC1.c) */
extern int func_04C7F0_ai_unit_task_total(uint16_t power, uint16_t unit);
extern int func_04C682_ai_power_strength_delta(uint16_t arg0, int16_t arg1);
extern int func_04CAF6_ai_find_nearest_target(uint16_t base_x, uint16_t base_y,
                                              uint16_t power, uint16_t mode);
extern int func_04C306_ai_queue_a_lookup_max(uint16_t power, uint16_t b0,
                                             uint16_t b1, uint16_t b2);
extern void func_04E2B6_unit_set_order_state(uint16_t unit_index, uint8_t prof,
                                             uint8_t dest_x, uint8_t dest_y);
                       /* prof/orders:=0x0B(goto)/dest stamper, file 0x4E2B6 */
extern int func_061E96_vector_to_dir(int dx, int dy);  /* 0x1A1F:0x59C sign-vector */
extern int func_008B96(uint16_t unit);                 /* 0x181F:0xB28 */
extern void overlay_grid16_cull_by_range(uint16_t row, uint16_t match_key,
                                         uint16_t ref_a, uint16_t ref_b,
                                         uint16_t max_metric);  /* func_04C20C */
extern int func_005EE8_logic_sz_28(uint16_t x, uint16_t y);   /* 0x181F:0x74A */
extern int func_008352_op_sz_92(uint16_t x, uint16_t y);
                       /* 0x181F:0xD12 cheapest passable neighbour ->
                        * [0x8DBA]/[0x8DBC] out-params, returns found */
extern int func_006018_logic_sz_33(uint16_t x, uint16_t y);   /* 0x181F:0x6D2 */
extern int func_005DBA_logic_sz_17(uint16_t x, uint16_t y);   /* 0x181F:0x6B4 */
extern int func_00BC10_ff_owned(uint16_t power, uint16_t ff); /* 0x181F:0x7B4 */
extern void func_0081F2_logic_sz_34(uint16_t settlement);     /* 0x181F:0xA4C select */
extern int unit_tile_head(int x, int y);               /* 0x181F:0x7E0 = 0x66CC */
extern int func_04C404_ai_queue_b_find_or_insert(uint16_t power, uint16_t b0,
                                                 uint16_t b1, uint16_t b2,
                                                 uint16_t b3);
/* AI6 helpers */
extern int  bld_pop_helper(void);             /* 0x181F:0xC7C -> res 0x8734 building/pop cap */
extern int  func_191F_9A4_colonist_enter(uint16_t unit_idx, uint16_t colony_idx);
                                              /* 0x191F:0x9A4 -- colonist joins colony,
                                               * called when unit is already on the colony tile;
                                               * returns non-zero on success; body in page07 */
/* AI7 helpers */
extern void rpt_select_player(int player);    /* 0x181F:0x582 -> func_030550 set player ctx */
extern int  overlay_call_181F_0AEC(void);     /* 0x181F:0xAEC do_transfer/cargo-discharge;
                                               * args pushed on stack by caller (unit, flag) */
/* AI8/AI10 helpers */
extern void overlay_191F_2EA_explore(uint16_t unit_index); /* 0x191F:0x2EA ship explore move;
                                               * called from AI10 schooner gate + AI8 mid-body;
                                               * body in page07 */
/* AI11/AI12 helpers -- all resolved through the thunk rule:
 *   0x181F:0x808 -> file 0x06E94  unit_destroy (BYTE_VERIFIED port)
 *   0x181F:0x8A8 -> file 0x07B64  nearest own unit excl. self (BYTE_VERIFIED)
 *   0x181F:0x9A4 -> file 0x08110  power-name word (existing extern convention)
 *   0x181F:0x438 / 0x9AE / 0x652  UI message-arg + dialog helpers (same extern
 *   names as ai/unit_orders.c and ai/unit_ai_leaf.c use for these thunks) */
extern int     func_006E94_logic_sz_198(uint16_t unit);    /* unit_destroy */
extern int     func_007B64_op_sz_105(uint16_t power, uint16_t excl_unit,
                                     uint16_t x, uint16_t y);
                       /* -> nearest unit owned by power (not excl); [0x8CF8]=dist */
extern int16_t ovly_name_word_9A4(int16_t power);
extern void    ovly_msg_arg_438(int16_t val, int16_t slot);
extern void    ovly_msg_arg_9AE(int16_t lo, int16_t hi, int16_t z);
extern int16_t ovly_dialog_652(int16_t flag, int16_t msg_id);

/* func_006696 (0x181F:0x98E): walk chain_next (+0x1A) to the TAIL of the tile
 * stack; AX-register arg/return, mirror of unit_chain_resolve (see the walk
 * description at load_image_00693A_00760F.c:135). */
static int unit_chain_tail_6696(int idx)
{
    int nxt;
    if (idx < 0) return idx;
    while ((nxt = unit_chain_next(idx)) >= 0)
        idx = nxt;
    return idx;
}

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
 * The European-AI per-unit decision ladder.  The original's own (release-dead)
 * trace logs name its sections "AI1".."AI19" (string table @DGROUP 0x1742+);
 * every section funnels into the COMMIT engine at 0x51A28..0x51C68 ("AI19"),
 * whose output is a direction choice [bp-0x74] (0..7, or 8 = stay) written to
 * UnitRecord+0x0B, an orders write (0x0C single-step move with dest, or 5/6
 * park), and a role profession byte ('9' idle, 'G' colony guard, 'B', 'e',
 * 'F', ...).  PORTED so far: HEAD (dispatch + state collection), the PRE
 * section (the reassignment flag ladder, 0x4E50C..0x4E877), AI1 (colony
 * garrison duty, 0x4E87F..0x4E96A), AI19 (the commit engine) and the EXIT
 * TAIL.  AI2..AI18 (target seeking / transport / pathing) are the remaining
 * gap: ai2_stub below falls to the tail = "considered, no decision", exactly
 * the pre-port behaviour for those paths.
 *
 * The 31 `lcall 0x181F:0x77E` trace calls are gated on local [bp-0xAC], which
 * is cleared at entry (0x4E2EB) and NEVER written again anywhere in the 14975
 * bytes -- release-dead code, omitted (the gate locations are kept as @asm
 * cites at each section boundary).
 * ============================================================================ */
int16_t unit_move_step(int16_t unit_index)
{
    int16_t owner;        /* [bp-0xE4] */
    int16_t map_x;        /* [bp-0x86] */
    int16_t map_y;        /* [bp-0x92] */
    int16_t type;         /* [bp-0x62] */
    int16_t occ;          /* [bp-0xA8] */
    int16_t dir_choice = 8;   /* [bp-0x74] @asm 0x04E335 (8 = stay) */
    int16_t escort_8C = 0;    /* [bp-0x8C] cleared @asm 0x04E2E4 */
    int16_t l_10 = 0;         /* [bp-0x10] cleared @asm 0x04E2E8 (deep sections) */
    int16_t special;          /* [bp-4]   prof 0x74/0x69 flag */
    int16_t probe_18;         /* [bp-0x18] */
    int16_t col_any, col_any_dist;     /* [bp-0xE2], [bp-0x72] */
    int16_t reg_active;       /* [bp-0x70] */
    int16_t col_own, col_own_dist;     /* [bp-0x60], [bp-0x2C] */
    int16_t reg_own_col;      /* [bp-0x2A] */
    int16_t settle_idx, settle_dist;   /* [bp-0xAA], [bp-0x9E] */
    int16_t reg_origin;       /* [bp-0x9C] */
    int16_t tier_52;          /* [bp-0x52] */
    int16_t ai_word_3C;       /* [bp-0x3C] */
    int16_t col_reg, col_reg_dist;     /* [bp-0x50], [bp-0x3A] */
    int16_t ship_band;        /* [bp-0x32] */
    int16_t colony_like;      /* [bp-0x8E] */
    int16_t abil_82, abil_58; /* [bp-0x82], [bp-0x58] */
    int16_t region;           /* [bp-0x36] */
    int16_t mission_28;       /* [bp-0x28] */
    int16_t struct_84;        /* [bp-0x84] */
    int16_t task_total_12;    /* [bp-0x12] */
    int16_t reassign;         /* [bp-0x68] */
    int16_t transport_CA;     /* [bp-0xCA] */
    int16_t transport_DA;     /* [bp-0xDA] */
    int16_t deficit_B4;       /* [bp-0xB4] */
    int16_t stack_n_56;       /* [bp-0x56] */
    int16_t l_40 = 0;         /* [bp-0x40] queue-A snapshot (@asm 0x4EB17) */
    int16_t fortify_CC = 0;   /* [bp-0xCC] set only @asm 0x51A11 (AI18, unported:
                               * defensive 0 keeps AI19's CC-branch cold) */
    int16_t guard_adj_E8 = 0; /* [bp-0xE8] set only @asm 0x514C0 (AI18, unported) */
    int16_t ai8_best42  = -1; /* [bp-0x42] best cargo slot type found in AI8 scan;
                               * -1 = none; tested in AI10 gate (jge 0x507BB) */
    int16_t ai8_deliv_A6 = 0; /* [bp-0xA6] = func_0073A8(unit,2)-1 from AI8;
                               * 0 default (no pending delivery); tested AI9/AI10 */

    /* @asm 0x04E2DC mov [bp-0xB6],1   -- result word (the tail returns 0)
     * @asm 0x04E2E2 sub ax,ax; clear [bp-0x8C], [bp-0x10], [bp-0xAC] */

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

    /* ---- special profession flag: 0x74 't' or 0x69 'i' ---------------------
     * @asm 0x04E360/0x04E367/0x04E36E/0x04E376 */
    {
        uint8_t prof = U_OFF(unit_index, U_PROF);
        special = (prof == 0x74 || prof == 0x69) ? 1 : 0;
        (void)special;            /* read by the unported deep sections */
    }

    /* ---- initial state collection (all leaves are BYTE_VERIFIED ports) ---- */
    probe_18 = (int16_t)func_00723E_op_sz_48((uint16_t)map_x, (uint16_t)map_y,
                                             (uint16_t)owner);  /* @asm 0x04E387 */
    (void)probe_18;
    col_any = (int16_t)func_0083F2_op_sz_71((uint16_t)map_x, (uint16_t)map_y,
                                            (uint16_t)-1, (uint16_t)-1); /* @asm 0x04E39E */
    col_any_dist = (int16_t)DG16(0x8DB8);                       /* @asm 0x04E3AA */
    /* the finder SELECTED the winner -> [0x8542] points at it */
    reg_active = (int16_t)func_005E90_op_sz_64(DG8(DG16(0x8542) + 0),
                                               DG8(DG16(0x8542) + 1)); /* @asm 0x04E3BD */
    (void)reg_active;
    col_own = (int16_t)func_0083F2_op_sz_71((uint16_t)map_x, (uint16_t)map_y,
                                            (uint16_t)owner, (uint16_t)-1); /* @asm 0x04E3D6 */
    col_own_dist = (int16_t)DG16(0x8DB8);                       /* @asm 0x04E3E1 */
    if (col_own >= 0)                                           /* @asm 0x04E3E7 */
        reg_own_col = (int16_t)func_005E90_op_sz_64(DG8(DG16(0x8542) + 0),
                                                    DG8(DG16(0x8542) + 1)); /* @asm 0x04E3FA */
    else
        reg_own_col = -2;                                       /* @asm 0x04E408 */
    settle_idx = (int16_t)func_046056_nearest_settlement((uint16_t)map_x,
                                                         (uint16_t)map_y, -1);
                                  /* @asm 0x04E419 (4th pushed word unused) */
    settle_dist = (int16_t)DG16(0x8DB8);                        /* @asm 0x04E425 */
    (void)settle_idx; (void)settle_dist;
    reg_origin = (int16_t)func_005E90_op_sz_64(DG8(DG16(0x8D4A) + 0),
                                               DG8(DG16(0x8D4A) + 1)); /* @asm 0x04E439 */
    (void)reg_origin;
    tier_52 = (int16_t)func_008262_logic_sz_20(
        (uint16_t)func_0082A0_logic_sz_18(DG16(0x8D52), (uint16_t)owner));
                                  /* @asm 0x04E44D/0x04E456 */
    (void)tier_52;
    ai_word_3C = (int16_t)(DG16(DG16(0x8D4A) + 0x0A + owner*2)); /* @asm 0x04E46B */
    (void)ai_word_3C;
    col_reg = (int16_t)func_0083F2_op_sz_71((uint16_t)map_x, (uint16_t)map_y,
                                            (uint16_t)owner, (uint16_t)-2); /* @asm 0x04E47F */
    col_reg_dist = (int16_t)DG16(0x8DB8);                       /* @asm 0x04E48A */
    (void)col_reg; (void)col_reg_dist;

    /* @asm 0x04E494 ship band 0x0D..0x12 -> [bp-0x32] */
    ship_band = (type >= 0x0D && type <= 0x12) ? 1 : 0;
    occ = (int16_t)func_00627A_op_sz_57((uint16_t)map_x, (uint16_t)map_y); /* @asm 0x04E4B7 */
    colony_like = (occ == 0x19 || occ == 0x1A) ? 1 : 0;         /* @asm 0x04E4CD/0x04E4D6 */
    (void)colony_like;
    abil_82 = (int16_t)(func_005CFE_map_tile_read_layer_15C((uint16_t)map_x,
                                          (uint16_t)map_y) & 0x40); /* @asm 0x04E4EC */
    (void)abil_82;
    abil_58 = (int16_t)(func_005D32_map_tile_read_layer_160((uint16_t)map_x,
                                          (uint16_t)map_y) & 0x0A); /* @asm 0x04E503 */
    (void)abil_58;

    /* ======================= PRE: the REASSIGNMENT ladder ===================
     * (0x4E50C..0x4E877) computes [bp-0x68]: "this unit should pick new work".
     * ======================================================================== */
    region = (int16_t)func_005E90_op_sz_64((uint16_t)map_x, (uint16_t)map_y);
                                                                /* @asm 0x04E511 */
    if (region >= 0)                                            /* @asm 0x04E51E */
        mission_28 = DG8(0x9870 + owner*16 + region);           /* @asm 0x04E529
                                  * [bx+si-0x6790]: per-power-per-region byte */
    else
        mission_28 = 5;                                         /* @asm 0x04E534 */
    struct_84 = (int16_t)func_0060A0_logic_sz_128((uint16_t)map_x,
                                                  (uint16_t)map_y); /* @asm 0x04E541 */
    (void)struct_84;
    task_total_12 = (int16_t)func_04C7F0_ai_unit_task_total((uint16_t)owner,
                                                            (uint16_t)unit_index);
                                  /* @asm 0x04E555 push cs; call 0x53539 stub
                                   * -> 0x1A1F:0x590 -> 0x4C7F0 */

    /* @asm 0x04E562..0x04E578: types 2 and 0 default to reassignable */
    reassign = (type == 2 || type == 0) ? 1 : 0;
    if (U_OFF(unit_index, 0x17) == 0x1B)                        /* @asm 0x04E581 [bx+0x315B] */
        reassign = 0;

    if (type == 1 || type == 4) {                               /* @asm 0x04E591/0x04E598 */
        if (U_OFF(unit_index, U_ORDERS) == 0)                   /* @asm 0x04E5A6 */
            reassign = 1;
        if (U_OFF(unit_index, U_ORDERS) == 0x0B) {              /* @asm 0x04E5B6 */
            int d = func_00493C_logic_sz_14((uint16_t)map_x, (uint16_t)map_y,
                        U_OFF(unit_index, U_DESTX),
                        U_OFF(unit_index, U_DESTY));            /* @asm 0x04E5D1 octile */
            if (d > 0x0C)                                       /* @asm 0x04E5D9 */
                reassign = 1;
        }
        if (func_04C682_ai_power_strength_delta((uint16_t)owner, region) > 2)
            reassign = 1;        /* @asm 0x04E5EB push cs; call 0x534E9 -> 0x4C682;
                                  * args (owner, region); cmp ax,2; jle */
        if ((int16_t)func_04CAF6_ai_find_nearest_target((uint16_t)map_x,
                       (uint16_t)map_y, (uint16_t)owner, 0) >= 0) /* @asm 0x04E60A */
            reassign = 0;                                       /* @asm 0x04E614 */
        if (U_OFF(unit_index, 0x17) == 0x15)                    /* @asm 0x04E61D */
            reassign = 0;
        /* @asm 0x04E629..0x04E641: per-power-per-region tables
         * [bx-0x6B1A]=0x94E6 (flag) and [bx-0x6A8E]=0x9572 (count), bx=owner*16+region */
        if (DG8(0x94E6 + owner*16 + region) == 0 &&
            DG8(0x9572 + owner*16 + region) < 8)
            reassign = 1;
        if (type == 4 && (DG8(0x95F2 + region) & 4))            /* @asm 0x04E64A/0x04E654 */
            reassign = 0;
    }

    if (type == 5) {                                            /* @asm 0x04E664 */
        if (U_OFF(unit_index, U_PROF) == 0x32)                  /* @asm 0x04E66B '2' */
            reassign = 1;
        if (mission_28 == 0)                                    /* @asm 0x04E677 */
            reassign = 0;
        if (DG8(0x94E6 + owner*16 + region) == 0 &&             /* @asm 0x04E68C */
            (int16_t)DG16(0x538E) % 15 == 0)                    /* @asm 0x04E693 turn%15 */
            reassign = 1;
        if (col_own_dist > 0x0C && col_any_dist > 2)            /* @asm 0x04E6A5/0x04E6AB */
            reassign = 1;
        /* @asm 0x04E6C5 push cs; call 0x534C6 -> 0x4CAF6 (x,y,owner,0) */
        if ((int16_t)func_04CAF6_ai_find_nearest_target((uint16_t)map_x,
                       (uint16_t)map_y, (uint16_t)owner, 0) >= 0 ||
            (int16_t)DG16(0x538A) > 0x672)                      /* @asm 0x04E6CF year>1650 */
            reassign = 0;                                       /* @asm 0x04E6D7 */
    }

    /* ---- home-colony auto-assignment (fast land units) ---------------------
     * @asm 0x04E6DC..0x04E71B: @UNIT row stride 14 base 0x5234; +2 = movement */
    if (ship_band == 0 &&
        DG8(0x5236 + type*14) > 1 &&                            /* @asm 0x04E6FA */
        (int8_t)U_OFF(unit_index, 0x06) < 0 &&                  /* @asm 0x04E703 [bx+0x314A] */
        col_own_dist <= 8 &&                                    /* @asm 0x04E70A */
        reg_own_col == region)                                  /* @asm 0x04E713 */
        U_OFF(unit_index, 0x06) = (uint8_t)col_own;             /* @asm 0x04E71B */

    /* @asm 0x04E71F..0x04E739: reassign &&= (task_total != 0) */
    reassign = (reassign != 0 && task_total_12 != 0) ? 1 : 0;

    if (type == 0 && col_own_dist == 0) {                       /* @asm 0x04E73D/0x04E744 */
        func_0082DC_logic_sz_118((uint16_t)col_own);            /* @asm 0x04E74D select */
        if (DG8(DG16(0x8542) + 0x1B) & 0x10)                    /* @asm 0x04E759 */
            reassign = 0;
    }

    if (reassign != 0 && region >= 0) {                         /* @asm 0x04E764/0x04E76A */
        /* @asm 0x04E774 cmp type,1; sbb ax,ax; add ax,3 -> cap = type==0 ? 2 : 3 */
        int cap = (type == 0) ? 2 : 3;
        uint8_t cnt;
        DG8(0xA13C + region) += 1;                              /* @asm 0x04E781 [bx-0x5EC4] */
        cnt = DG8(0xA13C + region);                             /* @asm 0x04E785 */
        if (cap < (int)cnt)                                     /* @asm 0x04E78B jge keeps */
            reassign = 0;
    }
    if (DG8(0x5382) & 1)                                        /* @asm 0x04E794 revolution */
        reassign = 0;
    (void)reassign;     /* consumed by AI2.. (the unported sections) */

    /* ---- transport availability flags (feed AI9..AI12) -------------------- */
    transport_CA = 1;                                           /* @asm 0x04E7A0 */
    if (type == 0x12)                                           /* @asm 0x04E7AA */
        transport_CA = 0;
    if (type == 0x11) {                                         /* @asm 0x04E7BB */
        /* @asm 0x04E7C6..0x04E7EB: [si-0x6BEC]=0x9414+owner;
         * [bx+di-0x6DB4]=0x924C+owner*0x13+type; [bx-0x6DA4]=0x925C+owner*0x13 */
        deficit_B4 = (int16_t)((int)DG8(0x9414 + owner)
                     - 3*(int)DG8(0x924C + owner*0x13 + type)
                     - (int)DG8(0x925C + owner*0x13));
        if (deficit_B4 >= 4)                                    /* @asm 0x04E7EF */
            transport_CA = 0;
        if (func_00704C_op_sz_205((uint16_t)map_x, (uint16_t)map_y,
                                  (uint16_t)owner) != 0)        /* @asm 0x04E803 */
            transport_CA = 0;
    }
    if (type == 0x10)                                           /* @asm 0x04E819 */
        transport_CA = (DG8(0xA89B) > 1 || (int16_t)DG16(0x9E52) > 6) ? 1 : 0;
                                                                /* @asm 0x04E820/0x04E827 */
    transport_DA = transport_CA;                                /* @asm 0x04E83C */
    if (type == 0x12 &&                                         /* @asm 0x04E848 */
        ((unit_index & 1) ||                                    /* @asm 0x04E84F test [bp+6],1 */
         DG8(0x925E + owner*0x13) == 1))                        /* @asm 0x04E85A [bx-0x6DA2] */
        transport_DA = 1;
    (void)transport_DA; (void)deficit_B4;
    /* @asm 0x04E867 trace gate [bp-0xAC]: dead (never set) -- log "AI1" omitted */

    /* ======================= AI1: COLONY GARRISON DUTY ======================
     * (0x4E87F..0x4E96A)  Fast land combat units standing in their own colony
     * while it still needs guards ([colony+0x8E] > 0, or prof 'A'): count the
     * qualifying stack; one stays as guard ('G', need--), extras get escort
     * duty (escort_8C=1 -> the AI17 pathing entry @0x50F1E).
     * ======================================================================== */
    if (ship_band != 0) goto ai2;                               /* @asm 0x04E883 */
    if (DG8(0x5236 + type*14) <= 1) goto ai2;                   /* @asm 0x04E8A2 movement */
    if (type == 4) goto ai2;                                    /* @asm 0x04E8AC */
    if (type == 8) goto ai2;                                    /* @asm 0x04E8B4 */
    if (col_own_dist != 0) goto ai2;                            /* @asm 0x04E8BC */
    func_0082DC_logic_sz_118((uint16_t)col_own);                /* @asm 0x04E8CA select */
    if ((int8_t)DG8(DG16(0x8542) + 0x8E) <= 0 &&                /* @asm 0x04E8D6 guard need */
        U_OFF(unit_index, U_PROF) != 0x41)                      /* @asm 0x04E8DD 'A' */
        goto ai2;
    stack_n_56 = 0;                                             /* @asm 0x04E8E7 */
    {   /* @asm 0x04E8EC..0x04E948: the cursor reuses [bp+6]; restored after */
        int cur = unit_chain_resolve(unit_index);               /* @asm 0x04E8F3 0x2EE */
        for (; cur >= 0; cur = unit_chain_next(cur)) {          /* @asm 0x04E93D/0x04E938 */
            uint8_t t2 = U_OFF(cur, U_TYPE);                    /* @asm 0x04E8FD */
            if (DG8(0x5236 + t2*14) <= 1) continue;             /* @asm 0x04E911 */
            if (t2 >= 0x0D && t2 <= 0x12) continue;             /* @asm 0x04E918/0x04E91C */
            if (U_OFF(cur, U_TYPE) == 4) continue;              /* @asm 0x04E924 (cursor) */
            if (U_OFF(cur, U_TYPE) == 8) continue;              /* @asm 0x04E92B */
            stack_n_56++;                                       /* @asm 0x04E932 */
        }
    }
    if (U_OFF(unit_index, U_PROF) == 0x41)                      /* @asm 0x04E94E 'A' */
        goto ai19_park;                                         /* @asm 0x04E955 -> 0x51A89 */
    if (stack_n_56 <= 1)                                        /* @asm 0x04E958 */
        goto ai19_guard_commit;                                 /* @asm 0x04E95E -> 0x51A78 */
    escort_8C = 1;                                              /* @asm 0x04E961 */
    goto ai17_entry;                                            /* @asm 0x04E967 -> 0x50F1E */

    /* ======================= AI2: IDLE REGION -> HEAD HOME ==================
     * (0x4E96A..0x4E9F8)  No mission in this region: combat-capable land
     * units march back to (or park in) the nearest own colony as 'V'. */
ai2:                                                            /* 0x4E96A */
    if (mission_28 == 0 &&                                      /* @asm 0x4E982 */
        special == 0 &&                                         /* @asm 0x4E988 */
        ship_band == 0 &&                                       /* @asm 0x4E98E */
        (type == 2 ||                                           /* @asm 0x4E998 */
         DG8(0x5236 + type*14) > 1) &&                          /* @asm 0x4E9B1 */
        reg_own_col == region) {                                /* @asm 0x4E9BB */
        if (col_own_dist != 0) {                                /* @asm 0x4E9C0 */
            func_0082DC_logic_sz_118((uint16_t)col_own);        /* @asm 0x4E9C9 */
            func_04E2B6_unit_set_order_state((uint16_t)unit_index, 0x56,
                DG8(DG16(0x8542) + 0), DG8(DG16(0x8542) + 1));
                          /* @asm 0x4E9E5 call 0x4E2B6: 'V', goto colony x/y */
            return move_eval_tail_51C68(unit_index, owner);     /* @asm 0x4E9E8 */
        }
        U_OFF(unit_index, U_PROF) = 0x56;                       /* @asm 0x4E9F0 'V' */
        goto ai19_park;                                         /* @asm 0x4E9F5 */
    }

    /* ======================= AI3: WAGON -> HAUL TO AI ORIGIN ================
     * (0x4E9F8..0x4EA5C)  A wagon adjacent to a native settlement, low trade
     * tier, no pending AI cargo word: step toward the per-power AI origin. */
    if (type == 5 &&                                            /* @asm 0x4EA14 */
        settle_dist == 1 &&                                     /* @asm 0x4EA1B */
        !(DG8(DG16(0x8D4A) + 3) & 8) &&                         /* @asm 0x4EA26 */
        tier_52 < 0x19 &&                                       /* @asm 0x4EA2C */
        ai_word_3C == 0) {                                      /* @asm 0x4EA32 */
        int dx = (int)DG8(DG16(0x8D4A) + 0) - map_x;            /* @asm 0x4EA38 */
        int dy = (int)DG8(DG16(0x8D4A) + 1) - map_y;            /* @asm 0x4EA40 */
        dir_choice = (int16_t)func_061E96_vector_to_dir(dx, dy);/* @asm 0x4EA4B */
        U_OFF(unit_index, U_PROF) = 0x4C;                       /* @asm 0x4EA53 'L' */
        goto ai19_have_dir;                                     /* @asm 0x4EA58 */
    }

    /* ======================= AI4: SLOW HAULER -> AI ORIGIN ==================
     * (0x4EA5C..0x4EB02)  Slow non-wagon carrying state (func_008B96) with
     * subtype 0x1C/0x19, adjacent to a settlement: same origin step as AI3. */
    if (func_008B96((uint16_t)unit_index) != 0 &&               /* @asm 0x4EA77 */
        DG8(0x5236 + type*14) <= 1 &&                           /* @asm 0x4EA9D */
        type != 5 &&                                            /* @asm 0x4EAA4 */
        type != 3 &&                                            /* @asm 0x4EAA9 */
        (U_OFF(unit_index, 0x17) == 0x1C ||                     /* @asm 0x4EAB0 */
         U_OFF(unit_index, 0x17) == 0x19) &&                    /* @asm 0x4EAB7 */
        settle_dist == 1 &&                                     /* @asm 0x4EABE */
        !(DG8(DG16(0x8D4A) + 3) & 2) &&                         /* @asm 0x4EAC9 */
        tier_52 < 0x19 &&                                       /* @asm 0x4EACF */
        ai_word_3C < 0x40) {                                    /* @asm 0x4EAD5 */
        int dx = (int)DG8(DG16(0x8D4A) + 0) - map_x;            /* @asm 0x4EADB */
        int dy = (int)DG8(DG16(0x8D4A) + 1) - map_y;            /* @asm 0x4EAE3 */
        dir_choice = (int16_t)func_061E96_vector_to_dir(dx, dy);/* @asm 0x4EAEC */
        U_OFF(unit_index, U_PROF) = 0x4C;                       /* @asm 0x4EAF8 'L' */
        goto ai19_have_dir;                                     /* @asm 0x4EAFD */
    }

    /* @asm 0x4EB02..0x4EB34: queue-A snapshot (key 6) + cull when reassigning */
    l_40 = (int16_t)func_04C306_ai_queue_a_lookup_max((uint16_t)owner,
               (uint16_t)map_x, (uint16_t)map_y, 6);            /* @asm 0x4EB11 */
    if (reassign != 0)                                          /* @asm 0x4EB1A */
        overlay_grid16_cull_by_range((uint16_t)owner, 6,
            (uint16_t)map_x, (uint16_t)map_y, 0);               /* @asm 0x4EB31 */

    /* ======================= AI5: SETTLE-SITE SCAN ==========================
     * (0x4EB4F..0x4F060)  Reassignable units scan a (2R+1)^2 window (R=3/2/1
     * by the patience score) for the best colony site: per-cell terrain class
     * x4, colony repulsion (-(cap-dist)^2, cap 9 own / 7|5 foreign), a
     * settling-conflict check (another unit with orders 7 nearby kills the
     * cell), native-settlement penalty ladder (x2/x4/x8 by distance, halved
     * by power/FF modifiers), virgin-region and colonist bonuses.  Best cell:
     * stand on it -> orders 7 (BUILD COLONY); else goto-site as prof '2'.
     * Non-reassignable: enqueue the (stale-dir) neighbour into queue B. */
ai5_retry:                                                      /* 0x4EB37 (trace gate dead -> 0x4EB4F) */
    if (reassign != 0) {                                        /* @asm 0x4EB4F */
        if (U_OFF(unit_index, 0x11) != 0) {                     /* @asm 0x4EB59 cooldown */
            U_OFF(unit_index, 0x11) -= 1;                       /* @asm 0x4EB60 */
            goto ai5_end;                                       /* @asm 0x4EB64 */
        }
        U_OFF(unit_index, 0x12) = 0xFF;                         /* @asm 0x4EB6C */
        if (task_total_12 != 0 &&                               /* @asm 0x4EB71 */
            U_OFF(unit_index, 0x10) < 0x7F)                     /* @asm 0x4EB77 */
            U_OFF(unit_index, 0x10) += 1;                       /* @asm 0x4EB7E patience */
        l_10 = (int16_t)(DG8(0x9E98 + region) * 8               /* @asm 0x4EB85 */
                         + U_OFF(unit_index, 0x10));            /* @asm 0x4EB92 */
    }
    if (reassign == 0)                                          /* @asm 0x4EB9D */
        goto ai5_end;
    {
        int16_t best_E0   = -999;                               /* @asm 0x4EBAB 0xFC19 */
        int16_t bestcls_A = 0;                                  /* @asm 0x4EBB1 */
        int16_t shift_DC  = 3;                                  /* @asm 0x4EBB6 */
        int16_t radius_C8 = 3;                                  /* @asm 0x4EBF6 */
        int16_t sx_16, sy_1A;
        int16_t cls_4A = 0, score_26 = 0, best_x_4C = 0, best_y_5C = 0;
        int16_t w0 = (int16_t)DG16(0x945E + region*2);          /* @asm 0x4EBC1 [bx-0x6BA2] */
        if (w0 <= 8)        shift_DC = 0;                       /* @asm 0x4EBC1 */
        else if (w0 <= 0x18) shift_DC = 1;                      /* @asm 0x4EBD5 */
        else if (w0 <= 0x30) shift_DC = 2;                      /* @asm 0x4EBE9 */
        if (l_10 >= 0x20) radius_C8 = 2;                        /* @asm 0x4EBFC */
        if (l_10 >= 0x40) radius_C8 = 1;                        /* @asm 0x4EC08 */

        for (sy_1A = map_y - radius_C8; map_y + radius_C8 >= sy_1A; sy_1A++) {
                                                                /* @asm 0x4EC14/0x4EFE5 */
            for (sx_16 = map_x - radius_C8; map_x + radius_C8 >= sx_16; sx_16++) {
                                                                /* @asm 0x4EFF2/0x4EC4C */
                /* ---- cheap filters @asm 0x4EC5C..0x4ED0C ---- */
                if (func_005BFA_logic_sz_49((uint16_t)sx_16, (uint16_t)sy_1A) == 0)
                    continue;                                   /* @asm 0x4EC62 */
                {
                    int16_t o = (int16_t)func_006018_logic_sz_33((uint16_t)sx_16,
                                                                 (uint16_t)sy_1A);
                    if (o >= 0 && o != owner) continue;         /* @asm 0x4EC7F/0x4EC83 */
                }
                if ((int16_t)func_005E90_op_sz_64((uint16_t)sx_16,
                        (uint16_t)sy_1A) != region) continue;   /* @asm 0x4EC97 */
                cls_4A = (int16_t)(func_005EE8_logic_sz_28((uint16_t)sx_16,
                                       (uint16_t)sy_1A) & 0x0F);/* @asm 0x4ECAA */
                score_26 = (int16_t)(cls_4A << 2);              /* @asm 0x4ECB0 */
                if (sx_16 == 0 && sy_1A == 0)                   /* @asm 0x4ECB6 (sic:
                                       * literal origin check in the original) */
                    score_26 += 0x10;                           /* @asm 0x4ECC2 */
                if (func_00627A_op_sz_57((uint16_t)sx_16,
                        (uint16_t)sy_1A) == 0x1B) continue;     /* @asm 0x4ECD6 */
                {   /* settle qualifier: cheapest passable neighbour + its
                     * layer-164 byte must be 1 (@asm 0x4ECE4..0x4ED12) */
                    int16_t q = (int16_t)func_008352_op_sz_92((uint16_t)sx_16,
                                                              (uint16_t)sy_1A);
                    if (q != 0 &&
                        (uint8_t)(func_005DBA_logic_sz_17(DG16(0x8DBA),
                                      DG16(0x8DBC)) - 1) != 0)  /* @asm 0x4ED03 dec al */
                        q = 0;                                  /* @asm 0x4ED07 */
                    if (q == 0)                                 /* @asm 0x4ED0C je */
                        continue;       /* (dead stores @0x4ED15..0x4ED28 incl. an
                                         * UNINITIALIZED [bp-0x4E]==8 test -- both
                                         * arms fall to next-x; nothing to port) */
                }

                /* ---- full scoring @asm 0x4EC22.. (entered only for
                 * qualifying cells via the jmp at 0x4ED12) ---- */
                func_0083F2_op_sz_71((uint16_t)sx_16, (uint16_t)sy_1A,
                                     (uint16_t)-1, (uint16_t)region); /* @asm 0x4EC2D */
                if ((int16_t)DG16(0x8DC6) >= 0) {               /* @asm 0x4EC35 */
                    int16_t cdist = (int16_t)DG16(0x8DB8);
                    if (cdist <= 1)                             /* @asm 0x4EC3F */
                        continue;       /* adjacent to a colony: reject cell */
                    if (DG8(DG16(0x8542) + 0x1A) == (uint8_t)owner) { /* @asm 0x4ED34 */
                        if (cdist == 2) continue;               /* @asm 0x4ED7A/0x4ED7F */
                        if (cdist < 9)                          /* @asm 0x4ED90 */
                            score_26 += (int16_t)((9 - cdist) * (cdist - 9));
                                                                /* @asm 0x4ED95..0x4EDA1 */
                    } else {
                        int16_t cap_A0 = 7;                     /* @asm 0x4ED44 */
                        if (cdist == 2) score_26 -= 0x14;       /* @asm 0x4ED39/0x4ED40 */
                        if (DG8(0x94E6 + owner*16 + region) < 1)/* @asm 0x4ED54 */
                            cap_A0 = 5;                         /* @asm 0x4ED5B */
                        if (cdist < cap_A0)                     /* @asm 0x4ED67 */
                            score_26 += (int16_t)((cap_A0 - cdist) * (cdist - cap_A0));
                                                                /* @asm 0x4ED6D..0x4EDA1 */
                    }
                }
                func_0082DC_logic_sz_118((uint16_t)col_any);    /* @asm 0x4EDA8 restore */

                /* settling-conflict: any OTHER unit with orders 7 on the cell
                 * or its 8 neighbours kills the cell (@asm 0x4EDB0..0x4EE23) */
                {
                    int16_t ok_8 = 1, k;
                    for (k = 0; ok_8 != 0 && k < 9; k++) {      /* @asm 0x4EDC7/0x4EDCD */
                        int16_t cy = (int16_t)((int8_t)DG8(0x00BE + k) + sy_1A);
                        int16_t cx = (int16_t)((int8_t)DG8(0x00B4 + k) + sx_16);
                        int cur = unit_tile_head(cx, cy);       /* @asm 0x4EDEE 0x7E0 */
                        for (; cur >= 0; cur = unit_chain_next(cur)) { /* @asm 0x4EE0F */
                            if (U_OFF(cur, U_ORDERS) == 7 &&    /* @asm 0x4EDFD */
                                cur != unit_index)              /* @asm 0x4EE04 */
                                ok_8 = 0;                       /* @asm 0x4EE0A */
                        }
                    }
                    if (ok_8 == 0) continue;                    /* @asm 0x4EE1D */
                }

                /* native-settlement penalty (@asm 0x4EE26..0x4EF61) */
                func_046056_nearest_settlement((uint16_t)sx_16, (uint16_t)sy_1A, -1);
                                                                /* @asm 0x4EE30 */
                if ((int16_t)DG16(0x8D4C) >= 0) {               /* @asm 0x4EE38 */
                    int16_t reg2_5E = (int16_t)func_005E90_op_sz_64(
                        DG8(DG16(0x8D4A) + 0), DG8(DG16(0x8D4A) + 1)); /* @asm 0x4EE4F */
                    int16_t ndist = (int16_t)DG16(0x8DB8);      /* @asm 0x4EE5A */
                    if (DG8(0x94E6 + owner*16 + reg2_5E) == 0)  /* @asm 0x4EE6A */
                        ndist += 1;                             /* @asm 0x4EE71 */
                    if (ndist < 6) {                            /* @asm 0x4EE75 */
                        int16_t tier2 = (int16_t)func_008262_logic_sz_20(
                            (uint16_t)func_0082A0_logic_sz_18(DG16(0x8D52),
                                                              (uint16_t)owner));
                                                                /* @asm 0x4EE86/0x4EE8F */
                        int16_t base_6A = (int16_t)((DG8(DG16(0x8D4E) + 2)
                                          + tier2 + 3) << 1);   /* @asm 0x4EE9B..0x4EEA7 */
                        int16_t pen_D2;
                        if (reg2_5E != region)                  /* @asm 0x4EEAD */
                            base_6A >>= 1;                      /* @asm 0x4EEB2 sar */
                        pen_D2 = (int16_t)(base_6A >> 1);       /* @asm 0x4EEB8 */
                        if (ndist <= 4) pen_D2 += base_6A;      /* @asm 0x4EEBE */
                        if (ndist <= 3) pen_D2 += (int16_t)(base_6A << 1); /* @asm 0x4EECB */
                        if (ndist <= 2) pen_D2 += (int16_t)(base_6A << 2); /* @asm 0x4EEDA */
                        if (ndist <= 1) pen_D2 += (int16_t)(base_6A << 3); /* @asm 0x4EEEA */
                        if (DG8(DG16(0x8D4A) + 3) & 4)          /* @asm 0x4EEFE */
                            pen_D2 <<= 1;                       /* @asm 0x4EF04 */
                        if (owner == 1) pen_D2 >>= 1;           /* @asm 0x4EF08 sar */
                        if (func_00BC10_ff_owned((uint16_t)owner, 0x10) != 0)
                            pen_D2 >>= 1;                       /* @asm 0x4EF19/0x4EF25 */
                        if (owner == 2) pen_D2 >>= 2;           /* @asm 0x4EF29 sar 2 */
                        if (l_10 > 0x28) pen_D2 >>= 1;          /* @asm 0x4EF35 */
                        pen_D2 -= (int16_t)DG8(0x9572 + owner*16 + reg2_5E);
                                                                /* @asm 0x4EF49 */
                        if (pen_D2 < 0) pen_D2 = 0;             /* @asm 0x4EF57 clamp */
                        score_26 -= pen_D2;                     /* @asm 0x4EF61 */
                    }
                }
                func_0081F2_logic_sz_34((uint16_t)settle_idx);  /* @asm 0x4EF68 restore */

                /* bonuses + best tracking (@asm 0x4EF70..0x4EFDE) */
                if (reassign != 0 && cls_4A >= 4) {             /* @asm 0x4EF70/0x4EF76 */
                    if (DG8(0x94E6 + owner*16 + region) == 0)   /* @asm 0x4EF86 */
                        score_26 += (int16_t)(score_26 >> 1);   /* @asm 0x4EF8D x1.5 */
                    if (type == 0)                              /* @asm 0x4EF99 */
                        score_26 <<= 1;                         /* @asm 0x4EFA0 */
                    score_26 += (int16_t)(l_10 >> shift_DC);    /* @asm 0x4EFA3 sar cl */
                    if (l_40 != 0)                              /* @asm 0x4EFAF */
                        score_26 += 0x10;                       /* @asm 0x4EFB5 */
                }
                if (score_26 >= best_E0) {                      /* @asm 0x4EFBD jge */
                    best_E0   = score_26;                       /* @asm 0x4EFC5 */
                    bestcls_A = cls_4A;                         /* @asm 0x4EFCC */
                    best_x_4C = sx_16;                          /* @asm 0x4EFD2 */
                    best_y_5C = sy_1A;                          /* @asm 0x4EFD8 */
                }
            }
        }

        if (bestcls_A > 0) {                                    /* @asm 0x4F000 */
            if (reassign != 0) {                                /* @asm 0x4F006 */
                if (best_x_4C == map_x && best_y_5C == map_y) { /* @asm 0x4F010/0x4F019 */
                    U_OFF(unit_index, U_ORDERS) = 7;            /* @asm 0x4F022 BUILD */
                    return move_eval_tail_51C68(unit_index, owner); /* @asm 0x4F027 */
                }
                func_04E2B6_unit_set_order_state((uint16_t)unit_index, 0x32,
                    (uint8_t)best_x_4C, (uint8_t)best_y_5C);
                          /* @asm 0x4F02A..0x4F036 jmp into the 0x4E9E5 call:
                           * '2', goto best site */
                return move_eval_tail_51C68(unit_index, owner);
            }
            /* !reassign: enqueue neighbour-of-(stale)-dir into queue B
             * (@asm 0x4F03A; dir_choice is 8 here -- the index reads the
             * DGROUP bytes after the dx table, faithfully reproduced) */
            func_04C404_ai_queue_b_find_or_insert((uint16_t)owner,
                (uint16_t)((int8_t)DG8(0x00B4 + dir_choice) + map_x),
                (uint16_t)((int8_t)DG8(0x00BE + dir_choice) + map_y),
                6, 2);                                          /* @asm 0x4F05A */
        }
    }
ai5_end:                                                        /* 0x4F060 */
    /* ======================= AI6: COLONIST DEPLOY ============================
     * (0x4F078..0x4F23C)  Type-0 (pioneer/colonist) units that are NOT being
     * reassigned (reassign==0) scan own colonies in this region for the most
     * under-staffed one and navigate to it (or enter it if already there).
     * Score = min(bld_pop_helper,16) - col.workers × (octile_dist/2); ties
     * broken by the index order; smaller score = more urgent × nearer.
     * If no colony found: if at an own colony transform to type 2 (farmer) and
     * exit; otherwise set reassign=1 and retry AI5 (settle-site scan). */
    /* @asm 0x4F078 type==0 gate; @asm 0x4F086 reassign==0 gate */
    if (type != 0)      goto ai7_check;                         /* @asm 0x4F07C */
    if (reassign != 0)  goto ai7_check;                         /* @asm 0x4F086 */
    {
        int16_t best_col_22  = -1;                              /* @asm 0x4F08F */
        int16_t best_E0_score = 0x270F;                         /* @asm 0x4F094 9999 */
        int16_t col_i;
        for (col_i = 0; col_i < (int16_t)DG16(0x539E); col_i++) {
            int16_t cap_A2, half_dist, surplus, enroute;
            func_0082DC_logic_sz_118((uint16_t)col_i);          /* @asm 0x4F0A8 select */
            if (DG8(DG16(0x8542) + 0x1A) != (uint8_t)owner)    /* @asm 0x4F0BB owner */
                continue;
            if ((int16_t)func_005E90_op_sz_64(DG8(DG16(0x8542) + 0),
                                              DG8(DG16(0x8542) + 1)) != region)
                continue;                                       /* @asm 0x4F0C4 region */
            {   /* warehouse-flag OR unit-subtype gate @asm 0x4F0DD */
                int ok = (DG8(DG16(0x8542) + 0x1B) & 0x10) != 0;
                if (!ok)
                    ok = (U_OFF(unit_index, 0x17) == 0x1B);     /* @asm 0x4F0E7 */
                if (!ok) continue;
            }
            cap_A2 = (int16_t)bld_pop_helper();                 /* @asm 0x4F0F1 */
            if (cap_A2 > 0x10) cap_A2 = 0x10;                  /* @asm 0x4F0FA clamp 16 */
            half_dist = (int16_t)func_00493C_logic_sz_14(       /* @asm 0x4F11B */
                (uint16_t)map_x, (uint16_t)map_y,
                DG8(DG16(0x8542) + 0), DG8(DG16(0x8542) + 1)) >> 1;
            surplus = cap_A2 - (int16_t)(int8_t)DG8(DG16(0x8542)+0x1F); /* @asm 0x4F130 */
            if (surplus > 0)                                    /* @asm 0x4F139 */
                half_dist = (int16_t)(surplus * half_dist);     /* @asm 0x4F13D */
            if ((int16_t)(int8_t)DG8(DG16(0x8542)+0x1F) >= cap_A2)     /* @asm 0x4F147 */
                half_dist <<= 1;                                /* @asm 0x4F14C double if full */
            {   /* count colonists already enroute to this colony @asm 0x4F14F */
                int tile_u = unit_tile_head(DG8(DG16(0x8542) + 0),
                                            DG8(DG16(0x8542) + 1)); /* @asm 0x4F15A */
                enroute = (int16_t)func_0073A8_logic_sz_99((uint16_t)tile_u, 2); /* @asm 0x4F160 */
            }
            enroute += (int16_t)(int8_t)DG8(DG16(0x8542) + 0x1F); /* @asm 0x4F172 */
            if (enroute >= cap_A2 + 2) continue;                /* @asm 0x4F17C */
            if (half_dist < best_E0_score) {                    /* @asm 0x4F185 jl */
                best_E0_score = half_dist;
                best_col_22   = col_i;                          /* @asm 0x4F18E */
            }
        }
        if (best_col_22 < 0) goto ai6_no_colony;               /* @asm 0x4F1A9 jl */
        func_0082DC_logic_sz_118((uint16_t)best_col_22);        /* @asm 0x4F1AB */
        if (U_OFF(unit_index, U_MAPX) == DG8(DG16(0x8542) + 0) && /* @asm 0x4F1C0 */
            U_OFF(unit_index, U_MAPY) == DG8(DG16(0x8542) + 1)) { /* @asm 0x4F1C9 */
            /* already on the colony tile: assign colonist, return 1 */
            func_007BCE_logic_sz_25((uint16_t)unit_index);      /* @asm 0x4F1D2 */
            func_191F_9A4_colonist_enter((uint16_t)unit_index,
                                         (uint16_t)best_col_22);/* @asm 0x4F1E0 */
            return 1;                                           /* @asm 0x4F1E8 */
        }
        /* not yet there: set goto-colony as prof '3' */
        func_04E2B6_unit_set_order_state((uint16_t)unit_index, 0x33,
            DG8(DG16(0x8542) + 0), DG8(DG16(0x8542) + 1));     /* @asm 0x4F1F5 */
        return move_eval_tail_51C68(unit_index, owner);         /* @asm 0x4F200 */
ai6_no_colony:                                                  /* 0x4F204 */
        if (col_own_dist != 0) {                                /* @asm 0x4F204 cmp [bp-0x2C] */
            if (!(DG8(0x5382) & 1)) {                           /* @asm 0x4F22C revolution */
                reassign = 1;                                   /* @asm 0x4F233 */
                goto ai5_retry;                                 /* @asm 0x4F238 jmp 0x4EB37 */
            }
        } else {
            /* at own colony with no deploy target: transform to type-2 farmer */
            U_OFF(unit_index, U_PROF)  = 0x3D;                  /* @asm 0x4F20E '=' */
            U_OFF(unit_index, U_TYPE)  = 2;                     /* @asm 0x4F213 */
            U_OFF(unit_index, 0x15)    = 0x14;                  /* @asm 0x4F218 qty[5]:=20 */
            func_007BCE_logic_sz_25((uint16_t)unit_index);      /* @asm 0x4F220 */
            return move_eval_tail_51C68(unit_index, owner);     /* @asm 0x4F228 jmp 0x51c68 */
        }
    }
ai7_check:                                                      /* 0x4F23C */
    /* ======================= AI7: SHIP CARGO DELIVERY =======================
     * (0x4F254..0x4F748)  Units that can carry cargo AND are at their own
     * colony: discharge any loaded cargo into the colony's budget tracking
     * array, then (if still has slots + transport_DA set) evaluate best
     * delivery destination.
     *
     * BYTE_VERIFIED 2026-06-10: gates (0x4F254..0x4F297), chain-fortify-clear
     * (0x4F297..0x4F2CB), colony context + cargo discharge
     * (0x4F2CB..0x4F30F), capacity / schooner clamp / guard-colony check
     * (0x4F30F..0x4F3BF).  Deep delivery-scoring body (0x4F3C0..0x4F748)
     * stubbed -- uses RUNTIME_ONLY colony-budget tables. */
    {
        /* Gate 1: unit type has cargo capacity (type*14 table at 0x5237) */
        uint8_t  ai7_type = U_OFF(unit_index, U_TYPE);
        uint16_t ai7_t14  = (uint16_t)((uint16_t)ai7_type * 14u);
        if (DG8(0x5237 + ai7_t14) == 0) goto ai8;              /* @asm 0x4F26C no cargo */
        /* Gate 2: at own colony (col_own_dist == 0) */
        if (col_own_dist != 0) goto ai8;                        /* @asm 0x4F276 */
        /* Gate 3: ship band OR unit's home colony matches col_own */
        if (!((uint8_t)ai7_type >= 0x0D && (uint8_t)ai7_type <= 0x12)) { /* @asm 0x4F27F */
            if (U_OFF(unit_index, 0x06) != (uint8_t)col_own) goto ai8; /* @asm 0x4F28E */
        }
        /* Chain walk: clear fortify (orders==1) on every unit in the tile
         * stack.  [bp+6] is used as the cursor; restore from [bp-0xA4]. */
        {
            int ai7_save = unit_index;
            int ai7_cur  = unit_chain_resolve(unit_index);      /* @asm 0x4F29E */
            for (;;) {                                          /* @asm 0x4F2BD loop */
                if (ai7_cur < 0) break;
                if (U_OFF(ai7_cur, U_ORDERS) == 1)             /* @asm 0x4F2A9 */
                    U_OFF(ai7_cur, U_ORDERS) = 0;              /* @asm 0x4F2B0 */
                ai7_cur = unit_chain_next(ai7_save);           /* @asm 0x4F2B8 */
            }
        }
        /* Colony context: select col_own, bind player */
        func_0082DC_logic_sz_118((uint16_t)col_own);            /* @asm 0x4F2CE */
        rpt_select_player(owner);                               /* @asm 0x4F2DA */
        /* Cargo discharge: for each loaded slot, credit colony budget array
         * colony+0x9A[good*2] += [0x8DC4]; @asm 0x4F2E4: push 0; push unit;
         * lcall 0x181F:0xAEC -> good-index.  overlay_call_181F_0AEC() is
         * declared void-arg (DOS stack convention): args must already be on
         * the stack.  In the modern build this whole section runs only when
         * cargo_count > 0 (real game data), so the stub returns 0 safely. */
        {
            int ai7_iters = 0;                                  /* @asm 0x4F306 loop */
            while (U_OFF(unit_index, 0x0C) != 0 && ai7_iters < 6) {
                int16_t cmdty = (int16_t)overlay_call_181F_0AEC(); /* @asm 0x4F2E9 */
                uint16_t price = DG16(0x8DC4);                 /* @asm 0x4F2F5 */
                uint16_t si    = (uint16_t)((uint16_t)cmdty * 2u);
                *(uint16_t near *)(DG_BASE + DG16(0x8542) + 0x9Au + si) += price; /* @asm 0x4F302 */
                ai7_iters++;
            }
        }
        /* Capacity: slots_left = max_slots(type) - loaded */
        {
            int16_t maxslots = (int16_t)DG8(0x5237 + ai7_t14); /* @asm 0x4F351 */
            int16_t slots_D0 = maxslots - (int16_t)U_OFF(unit_index, 0x0C); /* @asm 0x4F357 */
            if ((uint8_t)ai7_type == 0x0C && slots_D0 > 1) slots_D0 = 1;  /* @asm 0x4F35D schooner */
            if (ship_band)                                      /* @asm 0x4F311 */
                U_OFF(unit_index, 0x06) = 0xFF;                 /* @asm 0x4F31B home:=0xFF */
            if (ship_band)                                      /* @asm 0x4F320 */
                DG8(DG16(0x8542) + 0x8F) = 0;                  /* @asm 0x4F32A guard_need:=0 */
            /* Guard-colony check: ship_band, colony has bit-2 flag, type < 0xF */
            if (ship_band &&                                    /* @asm 0x4F374 */
                (DG8(DG16(0x8542) + 0x1B) & 2) &&              /* @asm 0x4F378 */
                (uint8_t)ai7_type < 0x0F) {                    /* @asm 0x4F382 */
                int16_t cnt_thresh;
                U_OFF(unit_index, 0x16)++;                     /* @asm 0x4F389 inc counter */
                cnt_thresh = (int16_t)(10 - maxslots);         /* @asm 0x4F3AD 10-max */
                /* neg dx: becomes maxslots-10 < current_count → guard */
                if ((int16_t)(maxslots - 10) < (int16_t)U_OFF(unit_index, 0x16)) { /* @asm 0x4F3B4 */
                    U_OFF(unit_index, U_PROF) = 0x43;           /* @asm 0x4F3B8 'C' */
                    goto ai19_park;                             /* @asm 0x4F3BD jmp 0x51A89 */
                }
                (void)cnt_thresh;
            }
            /* Scoring gates for delivery evaluation */
            if (!ship_band)          goto ai7_end;              /* @asm 0x4F3C0 */
            if (!transport_DA)       goto ai7_end;              /* @asm 0x4F3C9 */
            if (U_OFF(unit_index, 0x04) & 0x20) goto ai7_end;  /* @asm 0x4F3D7 */
            /* Deep delivery scoring (0x4F3E1..0x4F4F8 + 0x4F4FC..0x4F73D):
             * chain walk + per-colony delivery budget loops; uses
             * RUNTIME_ONLY colony +0x9A budget tables and 0x8DC4 price word.
             * Structural stub: no decision → fall to tail. */
            (void)slots_D0;
ai7_end:;
        }
    }
ai8:                                                            /* 0x4F748 */
    /* ======================= AI8: SHIP DELIVERY SCORING =====================
     * (0x4F760..0x50583)  Ship-band units evaluate cargo delivery runs.
     * Gate: ship_band required; non-ship falls straight to AI9.
     *
     * Body (0x4F769..0x50583):
     *   cargo-slot type loop -> best slot type in [bp-0x42] / ai8_best42
     *   func_181F_8BC(2,unit) - 1 -> [bp-0xA6] / ai8_deliv_A6
     *   5x func_181F_8BC colony budget queries -> [bp-0xB4,0xB8,0xBA,0xBC,0xEC]
     *   func_181F_948, func_534c6 neighbour probes -> flag word [bp-0x9A]
     *   colony scoring loop (0x4F998..0x4FCC4) + jmp-0x4E9E5(dx='4')
     *   ship explore path: 0x50196 push unit; lcall 0x191F:0x2EA; jmp 0x4F225
     * All scoring uses RUNTIME_ONLY overlay-resident tables.
     * BYTE_VERIFIED: gate at 0x4F760, ai8_best42/ai8_deliv_A6 init, explore
     * path at 0x50196. Body RUNTIME_ONLY stub. */
    if (!ship_band) goto ai9;                                   /* @asm 0x4F760 jmp 0x50583 */
    {
        /* cargo count from unit record - set ai8_best42 / ai8_deliv_A6 */
        /* (stub: body RUNTIME_ONLY; defaults -1/0 are safe for AI9/AI10 gates) */
        (void)ai8_best42; (void)ai8_deliv_A6;
    }
ai9:                                                            /* 0x50583 */
    /* ======================= AI9: SHIP CARRIER SCORING ======================
     * (0x50583..0x5076E)  Ship picks best colony destination to carry colonists.
     *
     * Gates (all BYTE_VERIFIED):
     *   1. ship band (type 0x0D..0x12)
     *   2. transport_CA || transport_DA must be set
     *   3. ai8_deliv_A6 == 0 (no pending delivery cargo)
     *   4. special == 0
     * Scoring loop (0x505D7..0x5076E): iterates 16 destination slots using
     * overlay-resident carrier tables; commits via jmp-0x4E9E5(dx='5').
     * RUNTIME_ONLY stub. */
    if (!(type >= 0x0D && type <= 0x12)) goto ai10;             /* @asm 0x050599 */
    if (!transport_CA && !transport_DA)   goto ai10;             /* @asm 0x0505B3 */
    if (ai8_deliv_A6 != 0)               goto ai10;             /* @asm 0x050589 [bp-0xA6] */
    if (special != 0)                     goto ai10;             /* @asm 0x0505CE */
    /* scoring loop (RUNTIME_ONLY stub) */
ai10:                                                           /* 0x5076E */
    /* ======================= AI10: SCHOONER EXPLORE TRIGGER =================
     * (0x5076E..0x507D3)  Modulo-32 turn ship exploration dispatch.
     * BYTE_VERIFIED: special gate (0x5076E), ship/cargo/transport gates
     * (0x50777..0x5079D), flags-0x20 or modulo-32 → 0x50196. */
    {
        /* Special units (prof 't'/'i') always exit to tail -- no AI11+ */
        if (special != 0)                                       /* @asm 0x5076E */
            return move_eval_tail_51C68(unit_index, owner);     /* @asm 0x50774 jmp 0x51C68 */

        /* Schooner explore: ship band + no best cargo + transport_DA active */
        if (ship_band != 0 &&                                   /* @asm 0x50777 */
            ai8_deliv_A6 == 0 &&                                /* @asm 0x50789 */
            ai8_best42 < 0 &&                                   /* @asm 0x50790 */
            transport_DA != 0) {                                 /* @asm 0x50796 */

            /* unit.flags bit 0x20: "always explore" override */
            if (U_OFF(unit_index, 0x04) & 0x20)                 /* @asm 0x507A3 */
                goto ai8_explore_50196;                          /* @asm 0x507AA jmp 0x50196 */
            /* modulo-32 turn slot: (unit_index + turn) & 0x1F == 0 */
            if (!(((uint8_t)unit_index + DG8(0x538E)) & 0x1Fu)) /* @asm 0x507AD */
                goto ai8_explore_50196;                          /* @asm 0x507B8 jmp 0x50196 */
        }
    }
    goto ai11;

ai8_explore_50196:                                              /* 0x50196 */
    /* shared explore exit: push unit; call 0x191F:0x2EA; reuse add sp,2 at
     * 0x4F225 then jmp 0x51C68 */
    overlay_191F_2EA_explore((uint16_t)unit_index);             /* @asm 0x050199 */
    return move_eval_tail_51C68(unit_index, owner);             /* @asm 0x4F228 jmp 0x51C68 */

ai11:                                                           /* 0x507D3 */
    /* ======================= AI11: TYPE-0xC TRADER ROUTE ====================
     * (0x507D3..0x50918)  Type 0x0C (the colony-supply hauler: AI7's load
     * path sets its +0x14 "loaded" byte @asm 0x4F730).
     * LOADED: pick the nearest native settlement in this region (the
     * settlement's +3 bit-4 "visited" flag halves its distance, min 1) and
     * goto it as prof '4' (sell trip).  No candidate -> the unit is DESTROYED
     * (jmp 0x509A9).
     * EMPTY:  park at the home colony as 'U' when standing in it; else goto
     * the home colony as '5'; no home -> adopt col_own when it is in this
     * region, otherwise DESTROYED.
     * All control flow BYTE_VERIFIED @asm 0x507D7..0x50918. */
    if (type != 0x0C) goto ai12;                                /* @asm 0x507D7 */
    if (U_OFF(unit_index, 0x14) != 0) {                         /* @asm 0x507E1 loaded */
        int16_t best_22 = -1;                                   /* @asm 0x507EB [bp-0x22] */
        int16_t best_E0 = 0x270F;                               /* @asm 0x507F0 [bp-0xE0] */
        int16_t si_4E;                                          /* [bp-0x4E] */
        for (si_4E = 0; si_4E < (int16_t)DG16(0x539A); si_4E++) {
                                                                /* @asm 0x507F6/0x5087B */
            int16_t d;
            func_0081F2_logic_sz_34((uint16_t)si_4E);           /* @asm 0x50801 select */
            if ((int16_t)func_005E90_op_sz_64(DG8(DG16(0x8D4A) + 0),
                    DG8(DG16(0x8D4A) + 1)) != region)           /* @asm 0x50816/0x5081E */
                continue;
            d = (int16_t)func_00493C_logic_sz_14((uint16_t)map_x, (uint16_t)map_y,
                    DG8(DG16(0x8D4A) + 0), DG8(DG16(0x8D4A) + 1)); /* @asm 0x50838 */
            if (DG8(DG16(0x8D4A) + 3) & 4) {                    /* @asm 0x50847 visited */
                d = (int16_t)(d >> 1);                          /* @asm 0x50858 sar */
                if (d < 1) d = 1;                               /* @asm 0x5085A/0x5085F */
            }
            if (best_E0 > d) {                                  /* @asm 0x50868 jle skips */
                best_22 = si_4E;                                /* @asm 0x5086E */
                best_E0 = d;                                    /* @asm 0x50874 */
            }
        }
        if (best_22 < 0)                                        /* @asm 0x50886 */
            goto ai12_remove_509A9;                             /* @asm 0x5088C */
        func_0081F2_logic_sz_34((uint16_t)best_22);             /* @asm 0x50892 select */
        func_04E2B6_unit_set_order_state((uint16_t)unit_index, 0x34,
            DG8(DG16(0x8D4A) + 0), DG8(DG16(0x8D4A) + 1));
                          /* @asm 0x5089A..0x508AE: dx='4', jmp 0x4E9E5 */
        return move_eval_tail_51C68(unit_index, owner);
    }
    /* empty hauler (@asm 0x508B2) */
    if (col_own_dist == 0) {                                    /* @asm 0x508B2 */
        if ((int8_t)U_OFF(unit_index, 0x06) < 0)                /* @asm 0x508BC */
            U_OFF(unit_index, 0x06) = (uint8_t)col_own;         /* @asm 0x508C6 */
        if (U_OFF(unit_index, 0x06) == (uint8_t)col_own) {      /* @asm 0x508D1 */
            U_OFF(unit_index, U_PROF) = 0x55;                   /* @asm 0x508D7 'U' */
            goto ai19_park;                                     /* @asm 0x508DC -> 0x51A89 */
        }
    }
    if ((int8_t)U_OFF(unit_index, 0x06) >= 0) {                 /* @asm 0x508E4 */
        func_0082DC_logic_sz_118(
            (uint16_t)(int8_t)U_OFF(unit_index, 0x06));         /* @asm 0x508F1 select */
        goto ai11_goto_colony_35;                               /* @asm 0x508F9 -> 0x50757 */
    }
    if (reg_own_col != region)                                  /* @asm 0x508FF */
        goto ai12_remove_509A9;                                 /* @asm 0x50904 */
ai11_sethome_50912:                                             /* 0x50907 */
    U_OFF(unit_index, 0x06) = (uint8_t)col_own;                 /* @asm 0x5090E */
    func_0082DC_logic_sz_118((uint16_t)col_own);                /* @asm 0x50912 (push)
                                                                 * -> 0x508F1 select */
ai11_goto_colony_35:                                            /* 0x50757 */
    func_04E2B6_unit_set_order_state((uint16_t)unit_index, 0x35,
        DG8(DG16(0x8542) + 0), DG8(DG16(0x8542) + 1));
                          /* @asm 0x50757..0x5076B: dx='5', jmp 0x4E9E5 */
    return move_eval_tail_51C68(unit_index, owner);

ai12:                                                           /* 0x50918 */
    /* ======================= AI12: TREASURE-TRAIN DELIVERY ==================
     * (0x50918..0x50A4D)  Type 0x0A (treasure train).
     * AT OWN COLONY: value = 100 x U_OFF(+0x17); credit the power treasury
     * dword ([0x84FC]+0x2A/+0x2C); unless in revolution ([0x5382]&1) raise the
     * "treasure delivered" dialog (power name + homeport name + value, template
     * DGROUP:0x1786); then DESTROY the train and return 1 (jmp 0x51D4D skips
     * the tail's result-zeroing, so the entry value [bp-0xB6]=1 is returned).
     * ELSEWHERE: same region as an own colony -> adopt it as home and goto as
     * '5' (shared AI11 path); else walk toward the nearest own unit (a carrier
     * candidate, func_007B64) in this region as '!'; if the nearest-target
     * probe equals current_nation_index ([0x5398]) the train is DESTROYED.
     * All control flow BYTE_VERIFIED @asm 0x050934..0x050A4D. */
    if (type != 0x0A) goto ai13;                                /* @asm 0x050934 */
    if (col_own_dist == 0) {                                    /* @asm 0x05093E */
        uint16_t value = (uint16_t)(0x64u *
                             (uint16_t)U_OFF(unit_index, 0x17)); /* @asm 0x050944 mul */
        uint32_t t = (uint32_t)DG16(DG16(0x84FC) + 0x2A)
                   | ((uint32_t)DG16(DG16(0x84FC) + 0x2C) << 16);
        t += value;                                             /* @asm 0x050954 add/adc */
        DG16(DG16(0x84FC) + 0x2A) = (uint16_t)t;
        DG16(DG16(0x84FC) + 0x2C) = (uint16_t)(t >> 16);
        if (!(DG8(0x5382) & 1)) {                               /* @asm 0x05095A revolution */
            ovly_msg_arg_438(ovly_name_word_9A4((int16_t)owner), 0);
                                                                /* @asm 0x050965/0x050970 */
            ovly_msg_arg_438((int16_t)DG16(0x838C + owner*2), 1);
                                                                /* @asm 0x05097E/0x050984
                                                                 * HOMEPORT name word */
            ovly_msg_arg_9AE((int16_t)value, 0, 0);             /* @asm 0x050994 */
            ovly_dialog_652(2, 0x1786);                         /* @asm 0x0509A1 */
        }
        goto ai12_remove_509A9;
    }
    if (reg_own_col == region)                                  /* @asm 0x0509BB */
        goto ai11_sethome_50912;                                /* @asm 0x0509C0 -> 0x50912 */
    {
        int16_t carrier = (int16_t)func_007B64_op_sz_105((uint16_t)owner,
                              (uint16_t)unit_index, (uint16_t)map_x,
                              (uint16_t)map_y);                 /* @asm 0x0509D7 */
        if (carrier >= 0) {                                     /* @asm 0x0509E4 */
            uint8_t hx = U_OFF(carrier, U_MAPX);                /* @asm 0x0509F0 */
            uint8_t hy = U_OFF(carrier, U_MAPY);                /* @asm 0x0509E9 */
            if ((int16_t)func_005E90_op_sz_64(hx, hy) == region) {
                                                                /* @asm 0x0509F7/0x0509FF */
                func_04E2B6_unit_set_order_state((uint16_t)unit_index, 0x21,
                                                 hx, hy);
                          /* @asm 0x050A1B..0x050A24: dx='!', jmp 0x4E9E5 */
                return move_eval_tail_51C68(unit_index, owner);
            }
        }
        if ((int16_t)func_04CAF6_ai_find_nearest_target((uint16_t)map_x,
                (uint16_t)map_y, (uint16_t)owner, 0)
                == (int16_t)DG16(0x5398))                       /* @asm 0x050A3E/0x050A44 */
            goto ai12_remove_509A9;                             /* @asm 0x050A4A */
    }
    goto ai13;                                                  /* @asm 0x050A48 fall */

ai12_remove_509A9:                                              /* 0x509A9 */
    func_006E94_logic_sz_198((uint16_t)unit_index);             /* @asm 0x0509AC destroy */
    return 1;                  /* @asm 0x0509B4 jmp 0x51D4D: returns [bp-0xB6]=1 */

ai13:                                                           /* 0x50A4D */
    /* ======================= AI13: TYPE-3 MISSIONARY PATH ===================
     * (0x50A4D..0x50BE7)  Type 3 (missionary): scores settlements to visit
     * using market-budget comparison and octile distance.
     * Gate: type == 3 (BYTE_VERIFIED @asm 0x050A65).  RUNTIME_ONLY stub. */
    if (type != 3) goto ai14;                                   /* @asm 0x050A65 */
    /* (RUNTIME_ONLY stub) */
ai14:                                                           /* 0x50BE7 */
    /* ======================= AI14: SOLDIER/SETTLER DISPATCH =================
     * (0x50BE7..0x50C42)  Type 5 (soldier) or type 2 (farmer/settler) with no
     * active mission: dispatches with prof 0x4A/'J' or 0x4E/'N'.
     * Gates (BYTE_VERIFIED @asm 0x050BFF/0x050C0F/0x050C11):
     *   (type == 5 || type == 2)  &&  mission_28 == 0
     * RUNTIME_ONLY stub. */
    if (type != 5 && type != 2) goto ai15;                      /* @asm 0x050C03/0x050C0F */
    if (mission_28 != 0)        goto ai15;                      /* @asm 0x050C11 */
    /* (RUNTIME_ONLY stub) */
ai15:                                                           /* 0x50C42 */
    /* ======================= AI15: REASSIGN ACTIVE PATH =====================
     * (0x50C42..0x50E20)  reassign != 0: handles in-flight goto orders (0x0B),
     * computes pathing target, prof 0x57/'W'.
     * Gate: reassign != 0 (BYTE_VERIFIED @asm 0x050C5A).  RUNTIME_ONLY stub. */
    if (reassign == 0) goto ai16;                               /* @asm 0x050C5A */
    /* (RUNTIME_ONLY stub) */
ai16:                                                           /* 0x50E20 */
    /* ======================= AI16: TYPE-2 COLONY NAVIGATION =================
     * (0x50E20..0x50F1E)  Type 2 land unit with reassign==0: evaluates
     * nearby settlement + pathing toward own colony.
     * Gate: type == 2 && reassign == 0 (BYTE_VERIFIED @asm 0x050E38/0x050E46).
     * RUNTIME_ONLY stub. */
    if (type != 2 || reassign != 0) goto ai16_exit;             /* @asm 0x050E3C/0x050E46 */
    /* RUNTIME_ONLY stub body (0x50E46..0x50EC8) */

ai16_exit:                                                      /* 0x50EC8 */
    /* ======================= AI16→AI17 ORDERS FILTER ========================
     * (0x50EC8..0x50F1E)  Entered from both paths of AI16 and AI11..AI15 falls.
     * Only units with free orders ({0,0xA,5,6}) or a just-arrived goto-0x0B
     * (dest == current tile) enter the pathing engine; units already holding
     * an active order call func_00704C and enter only if it returns non-zero;
     * otherwise exit to tail ("considered, no decision").
     * BYTE_VERIFIED @asm 0x050ECC..0x050F1B. */
    {
        uint8_t ords = U_OFF(unit_index, U_ORDERS);
        if (ords == 0 || ords == 0x0A ||
            ords == 5 || ords == 6)                    goto ai17_entry; /* @asm 0x50ED1 */
        if (ords == 0x0B                            &&                  /* @asm 0x50EE8 */
            U_OFF(unit_index, U_DESTX) == U_OFF(unit_index, U_MAPX) && /* @asm 0x50EEF */
            U_OFF(unit_index, U_DESTY) == U_OFF(unit_index, U_MAPY))   /* @asm 0x50EF9 */
            goto ai17_entry;                                            /* @asm 0x50F01 */
        if (func_00704C_op_sz_205((uint16_t)map_x, (uint16_t)map_y,
                                  (uint16_t)owner) != 0)   goto ai17_entry; /* @asm 0x50F19 */
        return move_eval_tail_51C68(unit_index, owner);   /* @asm 0x50F1B jmp 0x51C68 */
    }

ai17_entry:                                                     /* 0x50F1E */
    /* ======================= AI17-AI18: ESCORT / PATHING ENGINE =============
     * (0x50F1E..0x51A28)  Reached from AI1 (escort_8C=1) and from AI16.
     * Walks toward col_own's surroundings using func_00704C_op_sz_205, then
     * selects a direction and falls into AI19 (sets dir_choice / fortify_CC /
     * guard_adj_E8).  Until AI17-AI18 are ported, the escort candidate stands
     * down (tail), preserving the pre-port "considered, no decision" behaviour.
     * RUNTIME_ONLY stub. */
    (void)escort_8C;
    return move_eval_tail_51C68(unit_index, owner);

    /* ======================= AI19: the COMMIT engine ========================
     * (0x51A28..0x51C68)  Role checks, then the direction commit.
     * ======================================================================== */
#if 0   /* ai19 proper (0x51A28..0x51A66 + role ladder): becomes reachable when
         * AI2..AI18 land.  fortify_CC / guard_adj_E8 are its inputs. */
ai19:
    if (fortify_CC != 0) {                                      /* @asm 0x51A30 */
        if ((int)(uint8_t)func_006CCA_logic_sz_13((uint16_t)unit_index)
            - (int)U_OFF(unit_index, 0x05) < 3)                 /* @asm 0x51A3A/0x51A48 */
            dir_choice = 8;                                     /* @asm 0x51A55 */
        U_OFF(unit_index, U_PROF) = 0x39;                       /* @asm 0x51A5E '9' */
        goto ai19_have_dir;                                     /* @asm 0x51A63 */
    }
    if (escort_8C != 0) {                                       /* @asm 0x51A66 */
        func_0082DC_logic_sz_118((uint16_t)col_own);            /* @asm 0x51A70 */
        goto ai19_guard_commit;
    }
    /* role checks 0x51ACC..0x51C23 (queue A lookups, lone-unit adjacency) */
    if ((DG8(0x523D + type*14) & 1) && col_own_dist != 0) {     /* @asm 0x51AE4/0x51AEB */
        int q = func_04C306_ai_queue_a_lookup_max((uint16_t)owner, (uint16_t)map_x,
                                                  (uint16_t)map_y, 0); /* @asm 0x51B02 */
        if (q != 0 && q <= 4) {                                 /* @asm 0x51B0B/0x51B0F */
            if (func_0073A8_logic_sz_99((uint16_t)unit_index, 2) < 2) { /* @asm 0x51B19 */
                U_OFF(unit_index, U_PROF) = 0x42;               /* @asm 0x51B26 'B' */
                goto ai19_park;                                 /* @asm 0x51B2B */
            }
        }
    }
    if (DG8(0x523D + type*14) & 4) {                            /* @asm 0x51B46 */
        if (func_04C306_ai_queue_a_lookup_max((uint16_t)owner, (uint16_t)map_x,
                                              (uint16_t)map_y, 2) != 0) { /* @asm 0x51B5E */
            if (func_0073A8_logic_sz_99((uint16_t)unit_index, 2) < 2) {   /* @asm 0x51B6D */
                U_OFF(unit_index, U_PROF) = 0x65;               /* @asm 0x51B7A 'e' */
                goto ai19_park;                                 /* @asm 0x51B7F */
            }
        }
    }
    /* lone fast unit with hostile neighbour -> 'F' (@asm 0x51B82..0x51C21) */
    if (DG8(0x5236 + type*14) > 1 &&                            /* @asm 0x51B9A */
        !(type >= 0x0D && type <= 0x12) &&                      /* @asm 0x51BA4/0x51BA8 */
        guard_adj_E8 != 0) {                                    /* @asm 0x51BAF */
        if (unit_chain_tail_6696(unit_index) ==                 /* @asm 0x51BBC 0x98E */
            unit_chain_resolve(unit_index)) {                   /* @asm 0x51BC6 0x2EE */
            int16_t d2;
            for (d2 = 0; d2 < 8; d2++) {                        /* @asm 0x51BD2/0x51BDD */
                int16_t ny2 = (int16_t)((int8_t)DG8(0x00BE + d2) + map_y);
                int16_t nx2 = (int16_t)((int8_t)DG8(0x00B4 + d2) + map_x);
                int16_t oth = (int16_t)func_005F48_logic_sz_58((uint16_t)nx2,
                                                               (uint16_t)ny2);
                if (oth < 0) continue;                          /* @asm 0x51C10 */
                if (oth == owner) continue;                     /* @asm 0x51C12 */
                U_OFF(unit_index, U_PROF) = 0x46;               /* @asm 0x51C1C 'F' */
                goto ai19_park;                                 /* @asm 0x51C21 */
            }
        }
    }
    U_OFF(unit_index, U_PROF) = 0x39;                           /* @asm 0x51A5A '9' */
    goto ai19_have_dir;
#endif

ai19_guard_commit:                                              /* 0x51A78 */
    DG8(DG16(0x8542) + 0x8E) -= 1;                              /* @asm 0x51A7C need-- */
    U_OFF(unit_index, U_PROF) = 0x47;                           /* @asm 0x51A84 'G' */
ai19_park:                                                      /* 0x51A89 */
    dir_choice = 8;
ai19_have_dir:                                                  /* 0x51A8E */
    U_OFF(unit_index, 0x0B) = (uint8_t)dir_choice;              /* @asm 0x51A95 [bx+0x314F] */
    if (dir_choice != 8)                                        /* @asm 0x51A99 */
        goto ai19_apply;
    /* stay: park as sentry (or fortify if record flag +0x04 bit2) */
    if (U_OFF(unit_index, U_ORDERS) != 5 &&                     /* @asm 0x51AA2 */
        U_OFF(unit_index, U_ORDERS) != 6)                       /* @asm 0x51AA9 */
        U_OFF(unit_index, U_ORDERS) = 5;                        /* @asm 0x51AB0 */
    if (U_OFF(unit_index, 0x04) & 2)                            /* @asm 0x51AB9 [bx+0x3148] */
        U_OFF(unit_index, U_ORDERS) = 6;                        /* @asm 0x51AC3 */
    return move_eval_tail_51C68(unit_index, owner);             /* @asm 0x51AC0/0x51AC8 */

ai19_apply:                                                     /* 0x51C24 */
    map_y += (int8_t)DG8(0x00BE + dir_choice);                  /* @asm 0x51C27 cwde */
    map_x += (int8_t)DG8(0x00B4 + dir_choice);                  /* @asm 0x51C35 cwde */
    if (func_005BFA_logic_sz_49((uint16_t)map_x, (uint16_t)map_y) == 0)
        return move_eval_tail_51C68(unit_index, owner);         /* @asm 0x51C4D */
    U_OFF(unit_index, U_ORDERS) = 0x0C;                         /* @asm 0x51C53 step order */
    U_OFF(unit_index, U_DESTX)  = (uint8_t)map_x;               /* @asm 0x51C5C */
    U_OFF(unit_index, U_DESTY)  = (uint8_t)map_y;               /* @asm 0x51C64 */
    return move_eval_tail_51C68(unit_index, owner);             /* falls into 0x51C68 */
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
 * NOTES / STATUS
 * ----------------------------------------------------------------------------
 *  HEAD (order dispatch + validity gate + state collection): BYTE_VERIFIED
 *  EXIT TAIL (auto-sentry + wake-scan + goto-arrival): BYTE_VERIFIED
 *
 *  PRE section (0x4E509..0x4E887): BYTE_VERIFIED
 *  AI1 garrison (0x4E888..0x4E968): BYTE_VERIFIED (gate + chain walk + exit)
 *  AI2 idle-region return (0x4E96A..0x4E9F8): BYTE_VERIFIED
 *  AI3 wagon→origin haul (0x4E9F8..0x4EA5C): BYTE_VERIFIED
 *  AI4 slow-hauler→origin (0x4EA5C..0x4EB02): BYTE_VERIFIED
 *  AI5 settle-site scan (0x4EB4F..0x4F060): BYTE_VERIFIED (full scan+scoring)
 *  AI6 colonist deploy (0x4F078..0x4F23C): BYTE_VERIFIED 2026-06-10
 *    func_191F_9A4_colonist_enter: external body unresolved (0x191F:0x9A4)
 *    bld_pop_helper: external body in production_support.c (0x181F:0xC7C)
 *  AI7..AI18 (0x4F254..0x51A28): NOT YET DECODED (structural stubs).
 *  AI19 commit engine (0x51A28..0x51C68): BYTE_VERIFIED (guarded by #if 0
 *    until AI7..AI18 land and set fortify_CC / guard_adj_E8 / escort_8C).
 *
 *  The SCORING WEIGHTS (per-candidate delta tables, colony budget tables,
 *  relation matrices) are loaded from NAMES.TXT / game data at runtime --
 *  RUNTIME_ONLY, never fabricated here.
 * ============================================================================ */
