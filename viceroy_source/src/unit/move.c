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
#include <string.h>

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
extern int  func_02EAEA_op_sz_49(uint16_t colony, uint16_t unit);
                                              /* 0x191F:0x9A4 -> page03+0x1B1A = file
                                               * 0x2EAEA (colonist joins colony; existing
                                               * port -- ROUTE_B 1.5b).  cdecl order from
                                               * the call site: (colony, unit). */
/* AI7 helpers */
extern void rpt_select_player(int player);    /* 0x181F:0x582 -> func_030550 set player ctx */
extern int  overlay_call_181F_0AEC(void);     /* 0x181F:0xAEC do_transfer/cargo-discharge;
                                               * args pushed on stack by caller (unit, flag) */
/* AI8/AI10 helpers */
extern void overlay_191F_2EA_explore(uint16_t unit_index);
                       /* 0x191F:0x2EA ship explore move: RTLink SUB-SEGMENT
                        * record (trailer 0x138) -- target pending the
                        * sub-segment directory decode (ROUTE_B 1.5a) */
extern int16_t func_00B2A2_cargo_slot_good(int16_t unit, int16_t slot);
                       /* 0x181F:0xBE6 -> 0x0B2A2 cargo kind at slot (unit/cargo.c) */
extern int16_t func_00B2F0_cargo_slot_amount(int16_t unit, int16_t slot);
                       /* 0x181F:0xC68 -> 0x0B2F0 cargo qty byte at slot (unit/cargo.c) */
extern int16_t func_00B368_cargo_load(int16_t unit, int16_t good, int16_t qty);
                       /* 0x181F:0xD58 -> 0x0B368 load qty into slots (unit/cargo.c) */
extern int16_t func_008D00_colony_stock_cap(void);
                       /* 0x181F:0xD3A -> 0x08D00 colony stock cap (unit/cargo.c) */
/* AI8 body leaves -- all thunk/trampoline-resolved to existing ports:
 *   tramp 0x534BC -> 0x4C846   tramp 0x53516 -> 0x4C71C
 *   tramp 0x534D0 -> 0x4C5C0   tramp 0x534DA -> 0x4C89E
 *   0x1A1F:0x150  -> 0x3F90E (board/step executor)
 *   0x181F:0x948  -> 0x06A7C   0x181F:0xAEC -> 0x0B42C (slot discharge)
 *   0x191F:0xA2E  -> 0x3234A (market credit)
 *   (0x191F:0x2EA explore is a SUB-SEGMENT record -- unresolved, see above) */
extern int func_04C846_ai_find_unit_of_type(int16_t start_unit);
extern int func_04C71C_ai_unit_task_priority(uint16_t power, uint16_t unit,
                                             uint16_t dest);
extern int func_04C5C0_ai_power_budget(uint16_t power);
extern int func_04C89E_ai_best_adjacent_move(uint16_t power, uint16_t base_x,
                                             uint16_t base_y, uint16_t flag,
                                             uint16_t match_type);
extern int func_03F90E_logic_sz_50(uint16_t unit, uint16_t dir);
extern int func_006A7C_logic_sz_50(uint16_t unit, uint16_t x, uint16_t y);
extern int func_00B42C_logic_sz_139(uint16_t unit, uint16_t mode);
extern void func_03234A(int good, int qty);
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
/* AI13 helper: 0x181F:0x316 -> page 0x0B + 0x3F8 = file 0x460F8 (Type-A overlay
 * thunk, loader 0x0DAB).  The original passes an optional out-param ([bp+8])
 * that AI13 feeds into a dead store only -- the 1-arg port form is exact. */
extern int func_0460F8_muster_braves(uint16_t idx);
/* AI15 helper */
extern int16_t random_int_4D4(int16_t lo, int16_t hi);     /* 0x181F:0x4D4 */
/* AI16 helper: 0x181F:0xA56 -> file 0x0822A tribe claim-tier {1,2,3} */
extern int func_00822A_logic_sz_36(uint16_t tribe);
/* AI17/AI18 helpers -- all thunk-resolved to existing BYTE_VERIFIED ports:
 *   0x181F:0x6DC -> 0x05DF0  layer-164 high nibble (territory power, 0xF=-1)
 *   0x181F:0x682 -> 0x05F04  power index at tile / -1 (naval_classify extern)
 *   0x181F:0x768 -> 0x062B4  water-region probe
 *   0x181F:0x6F0 -> 0x05F82  layer-164 power (layer-160 bit1 gated) / -1
 *   0x181F:0x7BE -> 0x08D26  colony index at tile / -1
 *   0x181F:0x322 -> 0x0860E  ColonyRecord+0x84 bitmap bit test
 *   0x191F:0xA14 -> page 10 + 0x1B0E = file 0x5CA7E (7348-byte combat
 *                   evaluator, ENTER 0xDE; called here as a pure evaluator
 *                   with (unit, x, y, 0, 0) -- body unported) */
extern int func_005DF0_logic_sz_40(uint16_t x, uint16_t y);
extern int func_005F04_map_xy_bounds_or_neg1(uint16_t x, uint16_t y);
extern int func_0062B4_op_sz_39(uint16_t x, uint16_t y);
extern int func_005F82_logic_sz_31(uint16_t x, uint16_t y);
extern int func_008D26_op_sz_69(uint16_t x, uint16_t y);
extern int func_00860E_logic_sz_15(uint16_t colony, uint16_t bit);
extern int16_t func_05CA7E_attack_value(uint16_t unit, uint16_t x, uint16_t y,
                                        uint16_t f1, uint16_t f2);

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
    int16_t ai8_qty3_48 = 0;  /* [bp-0x48] = func_0073A8(unit,3); read by AI17 gate */
    int16_t ai8_qty4_46 = 0;  /* [bp-0x46] = func_0073A8(unit,4); read by AI17 gate */
    int16_t ai8_flags_9A = 0; /* [bp-0x9A] AI8 delivery-pending flag word.  The
                               * original leaves it UNINITIALIZED on the deliv==0
                               * path (0x4F959 jmp 0x50140 skips the 0x4F95C
                               * clear); deterministic 0 here. */
    int16_t hunt_EA = 0;      /* [bp-0xEA] AI17 hunt flag */

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
                continue;                                       /* @asm 0x4F0D1 region */
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
            func_02EAEA_op_sz_49((uint16_t)best_col_22,
                                 (uint16_t)unit_index);        /* @asm 0x4F1E0
                                               * 0x191F:0x9A4 -> func_02EAEA */
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
            /* ---- AI7a: BOARDING SCAN (0x4F3C0..0x4F4F8) --------------------
             * Ships with transport duty mark land units in the colony stack
             * to wait for pickup (orders := 1), consuming hold capacity by
             * the unit's @UNIT space byte (0x5238).  Gates: ship band +
             * transport_DA + flags bit 0x20 clear; each gate falls to the
             * PICKUP loop at 0x4F73E (NOT to AI8).
             * BYTE_VERIFIED from the decode sheet 0x4F3C0..0x4F4F8. */
            if (ship_band != 0 &&                               /* @asm 0x4F3C0 */
                transport_DA != 0 &&                            /* @asm 0x4F3C9 */
                !(U_OFF(unit_index, 0x04) & 0x20)) {            /* @asm 0x4F3D7 */
                int cur = unit_chain_resolve(unit_index);       /* @asm 0x4F3E8 0x2EE */
                for (; cur >= 0; cur = unit_chain_next(cur)) {  /* @asm 0x4F4D6/0x4F4DE */
                    int16_t pickup_DE;
                    uint8_t ct;
                    if ((int16_t)DG16(0x1734 + owner * 2) >= 0x19)
                        break;                                  /* @asm 0x4F3F6 budget cap */
                    ct = U_OFF(cur, U_TYPE);
                    if (ct >= 0x0D && ct <= 0x12)               /* @asm 0x4F403/0x4F40A */
                        continue;                               /* ships don't board */
                    if (DG8(0x5238 + (uint16_t)ct * 14) > (uint8_t)slots_D0)
                        continue;                               /* @asm 0x4F42E space */
                    pickup_DE = 0;                              /* @asm 0x4F437 */
                    if (DG8(0x5236 + (uint16_t)ct * 14) > 1 &&  /* @asm 0x4F467 fast */
                        U_OFF(cur, U_PROF) != 0x47 &&           /* @asm 0x4F470 'G' */
                        U_OFF(cur, U_PROF) != 0x41 &&           /* @asm 0x4F477 'A' */
                        mission_28 == 0)                        /* @asm 0x4F47E */
                        pickup_DE = 1;                          /* @asm 0x4F484 */
                    if (ct == 2) {                              /* @asm 0x4F48E settler */
                        if (task_total_12 == 0 && mission_28 != 0)
                            continue;                           /* @asm 0x4F499/0x4F49F */
                        pickup_DE = 1;                          /* @asm 0x4F4A1 */
                    }
                    if (pickup_DE != 0) {                       /* @asm 0x4F4A7 */
                        U_OFF(cur, U_ORDERS) = 1;               /* @asm 0x4F4B2 hold */
                        slots_D0 -= (int16_t)DG8(0x5238 + (uint16_t)ct * 14);
                                                                /* @asm 0x4F4C9/0x4F4CF */
                    }
                }
                DG16(0x1734 + owner * 2) = 0;                   /* @asm 0x4F4F2 clear */
            }

            /* ---- AI7b: GOODS PICKUP LOOP (0x4F73E gate; body 0x4F4FC..0x4F73D)
             * While hold slots remain (and transport_CA): score the colony's
             * 16 stock words (+0x9A): amount below the stock cap counts as-is
             * (good 8 adds 0x19-cap then max(amt-2,0)); above-cap doubles
             * (except good 0); good 5 skipped; goods 0x0E/0x0F need ship +
             * colony flag word +0x90 bit set, then -100; ships skip 0x0D and
             * 0; zero amounts skip.  Ship score = weight(0x84BC[owner*16+g])
             * x amt; land score = weight decayed by random(0,3) rolls, then
             * amt x (cap[8|4] - score) + 5x(1-score), rejected when >= cap or
             * amt < 50.  Winner: take min(stock, 100) (the original computes
             * good-0/8/0xE adjustments first, then UNCONDITIONALLY re-clamps
             * -- dead stores, omitted), deduct stock, cargo_load(unit, good,
             * qty), slot--, ship home := col_own, land loaded flag +0x14 := 1.
             * BYTE_VERIFIED from the decode sheet 0x4F4FC..0x4F748. */
            while (slots_D0 != 0) {                             /* @asm 0x4F73E/0x4F745 */
                int16_t best_22 = -1, best_E0 = -1;             /* @asm 0x4F506 */
                int16_t cap_A2, i_B4, amt_34, score_26;
                if (transport_CA == 0)                          /* @asm 0x4F4FC */
                    break;                                      /* @asm 0x4F503 -> ai8 */
                cap_A2 = func_008D00_colony_stock_cap();        /* @asm 0x4F510 0xD3A */
                for (i_B4 = 0; i_B4 < 0x10; i_B4++) {           /* @asm 0x4F519/0x4F54A */
                    amt_34 = (int16_t)DG16(DG16(0x8542) + 0x9A + i_B4 * 2);
                                                                /* @asm 0x4F55E */
                    if (amt_34 < cap_A2 || i_B4 == 0) {         /* @asm 0x4F565/0x4F56B */
                        if (i_B4 == 8) {                        /* @asm 0x4F522 horses */
                            amt_34 = (int16_t)(amt_34 + 0x19 - cap_A2 - 2);
                                                                /* @asm 0x4F529/0x4F536 */
                            if (amt_34 < 0) amt_34 = 0;         /* @asm 0x4F538 */
                        }
                    } else {
                        amt_34 = (int16_t)(amt_34 << 1);        /* @asm 0x4F572 over-cap x2 */
                    }
                    if (i_B4 == 5)                              /* @asm 0x4F53F skip good 5 */
                        continue;
                    if (i_B4 == 0x0E || i_B4 == 0x0F) {         /* @asm 0x4F576/0x4F57D */
                        if (ship_band == 0)                     /* @asm 0x4F584 */
                            continue;
                        if (!(DG16(DG16(0x8542) + 0x90) &
                              (uint16_t)(1u << i_B4)))          /* @asm 0x4F58A/0x4F593 */
                            continue;
                        amt_34 -= 0x64;                         /* @asm 0x4F599 */
                    }
                    if (ship_band != 0 && i_B4 == 0x0D)         /* @asm 0x4F59D/0x4F5A3 */
                        continue;
                    if (ship_band != 0 && i_B4 == 0)            /* @asm 0x4F5AA/0x4F5B0 */
                        continue;
                    if (amt_34 == 0)                            /* @asm 0x4F5B7 */
                        continue;
                    if (ship_band != 0) {                       /* @asm 0x4F5BD */
                        score_26 = (int16_t)((int16_t)DG8(0x84BC + owner * 16 + i_B4)
                                             * amt_34);         /* @asm 0x4F5C3/0x4F5D4 */
                    } else {
                        int16_t cap2;
                        score_26 = (int16_t)DG8(0x84BC + owner * 16 + i_B4);
                                                                /* @asm 0x4F5DC */
                        while (score_26 >= 2) {                 /* @asm 0x4F605 */
                            if (random_int_4D4(0, 3) != 0)      /* @asm 0x4F5F6/0x4F5FE */
                                break;
                            score_26--;                         /* @asm 0x4F602 */
                        }
                        cap2 = (i_B4 == 0x0D) ? 8 : 4;          /* @asm 0x4F60B..0x4F618 */
                        if (cap2 > score_26) {                  /* @asm 0x4F61F jle reject */
                            int16_t old = score_26;             /* @asm 0x4F624 */
                            score_26 = (int16_t)(amt_34 * (cap2 - score_26));
                                                                /* @asm 0x4F62A/0x4F632 */
                            score_26 = (int16_t)(score_26 + 5 * (1 - old));
                                                                /* @asm 0x4F638..0x4F644 */
                        } else {
                            score_26 = -1;                      /* @asm 0x4F64A */
                        }
                        if (amt_34 < 0x32)                      /* @asm 0x4F64F */
                            score_26 = -1;                      /* @asm 0x4F655 amt < 50 */
                    }
                    if (score_26 > best_E0) {                   /* @asm 0x4F65E jg */
                        best_E0 = score_26;                     /* @asm 0x4F669 */
                        best_22 = i_B4;                         /* @asm 0x4F66D */
                    }
                }
                if (best_22 < 0) {                              /* @asm 0x4F678 */
                    slots_D0 = 0;                               /* @asm 0x4F738 */
                    break;                                      /* -> 0x4F73E -> ai8 */
                }
                /* @asm 0x4F69B/0x4F6B1/0x4F6C5: good-0 keep-10 / good-8
                 * stable-fill / good-0xE,F surplus computations -- DEAD
                 * STORES, unconditionally overwritten by the re-clamp at
                 * 0x4F6E8; omitted (original quirk preserved by omission). */
                amt_34 = (int16_t)DG16(DG16(0x8542) + 0x9A + best_22 * 2);
                                                                /* @asm 0x4F6E8 */
                if (amt_34 > 0x64) amt_34 = 0x64;               /* @asm 0x4F6F1/0x4F6F6 */
                *(uint16_t near *)(DG_BASE + DG16(0x8542) + 0x9Au
                                   + (uint16_t)best_22 * 2u) -= (uint16_t)amt_34;
                                                                /* @asm 0x4F6FC deduct */
                func_00B368_cargo_load((int16_t)unit_index, best_22, amt_34);
                                                                /* @asm 0x4F709 0xD58 */
                slots_D0--;                                     /* @asm 0x4F711 */
                if (ship_band != 0)                             /* @asm 0x4F715 */
                    U_OFF(unit_index, 0x06) = (uint8_t)col_own; /* @asm 0x4F722 home */
                if (ship_band == 0)                             /* @asm 0x4F726 */
                    U_OFF(unit_index, 0x14) = 1;                /* @asm 0x4F730 loaded
                                                                 * (AI11 trader gate) */
            }
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
        /* ---- setup (BYTE_VERIFIED @asm 0x4F769..0x4F880) ---- */
        int16_t ai8_cargo_B4 = (int16_t)U_OFF(unit_index, 0x0C); /* @asm 0x4F76D */
        uint8_t qty_tally_C6[16];                               /* [bp-0xC6] */
        int16_t qty6_44, qty5_14;
        int16_t i;
        memset(qty_tally_C6, 0, 16);             /* @asm 0x4F780 0xD1D:0xDAE memset */
        for (i = 0; i < ai8_cargo_B4; i++) {                    /* @asm 0x4F78D/0x4F7D7 */
            int16_t ctype = func_00B2A2_cargo_slot_good(unit_index, i);
                                                                /* @asm 0x4F79A 0xBE6 */
            if (ctype >= 0x0D || ctype == 8) {                  /* @asm 0x4F7A5/0x4F7AA */
                if (ctype > ai8_best42)
                    ai8_best42 = ctype;                         /* @asm 0x4F7B5 */
                qty_tally_C6[ctype & 0x0F] = (uint8_t)(qty_tally_C6[ctype & 0x0F]
                    + func_00B2F0_cargo_slot_amount(unit_index, i));
                                                                /* @asm 0x4F7C4..0x4F7CF
                                                                 * (index = slot good;
                                                                 * goods 0..15) */
            }
        }
        /* @asm 0x4F7FC 0x181F:0x920(unit): result discarded; pure -- skipped */
        ai8_deliv_A6 = (int16_t)(func_0073A8_logic_sz_99(
                           (uint16_t)unit_index, 2) - 1);       /* @asm 0x4F809/0x4F811 */
        ai8_qty3_48 = (int16_t)func_0073A8_logic_sz_99(
                          (uint16_t)unit_index, 3);             /* @asm 0x4F81B */
        ai8_qty4_46 = (int16_t)func_0073A8_logic_sz_99(
                          (uint16_t)unit_index, 4);             /* @asm 0x4F82B */
        qty6_44 = (int16_t)func_0073A8_logic_sz_99(
                          (uint16_t)unit_index, 6);             /* @asm 0x4F83B [bp-0x44] */
        qty5_14 = (int16_t)func_0073A8_logic_sz_99(
                          (uint16_t)unit_index, 5);             /* @asm 0x4F84B [bp-0x14] */
        if (DG8(0x5382) & 1)                                    /* @asm 0x4F86C revolution */
            ai8_qty4_46 = (int16_t)(ai8_qty4_46 +
                func_0073A8_logic_sz_99((uint16_t)unit_index, 0x0C)); /* @asm 0x4F878 */

        /* ======== AI8 BODY: the ship ENROUTE-DECISION ENGINE ================
         * (0x4F883..0x50583)  Ported from the decode sheet + AI8_DECODE_NOTES.
         * Phases: prologue probes -> per-direction flag-word build -> boarding
         * executor -> sail-destination scoring ('4' commit) -> deliv==0
         * continuation (privateer/idle explore, harbor unload scoring with
         * 'P' commit, at-sea emergency unload, capacity explore).
         * BYTE_VERIFIED control flow + constants throughout. */
        {
            int16_t ai8_80    = (int16_t)(ai8_deliv_A6 - qty5_14
                                          - ai8_qty4_46 - ai8_qty3_48);
                                                                /* @asm 0x4F856..0x4F862 */
            int16_t ai8_B2    = ai8_qty3_48;                    /* @asm 0x4F868 snapshot */
            int16_t ai8_7E    = 0;
            int16_t target_64, hunt2_EA, find_66;

            func_006A7C_logic_sz_50((uint16_t)unit_index, (uint16_t)map_x,
                                    (uint16_t)map_y);           /* @asm 0x4F88E 0x948 */
            target_64 = (int16_t)func_04C306_ai_queue_a_lookup_max(
                (uint16_t)owner, (uint16_t)map_x, (uint16_t)map_y, 7);
                                                                /* @asm 0x4F8BD */
            hunt2_EA = (int16_t)func_04C306_ai_queue_a_lookup_max(
                (uint16_t)owner, (uint16_t)map_x, (uint16_t)map_y, 1);
                                                                /* @asm 0x4F8D5 ([bp-0xEA]
                                                                 * reused; AI17 rewrites
                                                                 * hunt_EA before reading) */
            find_66 = (int16_t)func_04C846_ai_find_unit_of_type(
                                    (int16_t)unit_index);       /* @asm 0x4F8E3 */
            if (find_66 >= 0) {                                 /* @asm 0x4F8EE */
                int16_t pr = (int16_t)(func_04C71C_ai_unit_task_priority(
                                  (uint16_t)owner, (uint16_t)find_66, (uint16_t)-1)
                              + func_04C5C0_ai_power_budget((uint16_t)owner));
                                                                /* @asm 0x4F8F8/0x4F905 */
                if (pr > 0) {                                   /* @asm 0x4F912 */
                    ai8_7E = ai8_80;                            /* @asm 0x4F917 */
                    ai8_qty3_48 = (int16_t)(ai8_qty3_48 + ai8_80); /* @asm 0x4F91A */
                    ai8_80 = 0;                                 /* @asm 0x4F91D */
                } else if (hunt2_EA == 0) {                     /* @asm 0x4F924 */
                    ai8_80 = (int16_t)(ai8_80 + ai8_qty3_48);   /* @asm 0x4F92E */
                    ai8_qty3_48 = 0;                            /* @asm 0x4F931 */
                }
            }

            if (ai8_deliv_A6 != 0) {                            /* @asm 0x4F952 deliv!=0 */
                int16_t d8;
                ai8_flags_9A = 0;                               /* @asm 0x4F95C */
                if (ai8_qty3_48 != 0 || ai8_qty4_46 != 0 || qty5_14 != 0) {
                                                                /* @asm 0x4F962..0x4F972 */
                    /* ---- direction loop: flag-word build (0x4F98F..0x4FCC4).
                     * Each QUALIFYING neighbour resets and rebuilds flags_9A
                     * (the last qualifying direction wins) ---- */
                    for (d8 = 0; d8 < 8; d8++) {                /* @asm 0x4F98F/0x4FC20 */
                        int16_t tx = (int16_t)((int8_t)DG8(0x00B4 + d8) + map_x);
                        int16_t ty = (int16_t)((int8_t)DG8(0x00BE + d8) + map_y);
                                                                /* @asm 0x4FC2C..0x4FC45 */
                        int16_t oth, r;
                        if (func_005BFA_logic_sz_49((uint16_t)tx,
                                                    (uint16_t)ty) == 0)
                            continue;                           /* @asm 0x4FC46/0x4FC50 */
                        if (func_0062B4_op_sz_39((uint16_t)tx,
                                                 (uint16_t)ty) != 0)
                            continue;                           /* @asm 0x4FC58/0x4FC62 */
                        oth = (int16_t)func_006018_logic_sz_33((uint16_t)tx,
                                                               (uint16_t)ty);
                        if (oth >= 0 && oth != owner)           /* @asm 0x4FC75/0x4FC79 */
                            continue;
                        ai8_flags_9A = 0;                       /* @asm 0x4FC7F reset */
                        r = (int16_t)func_005E90_op_sz_64((uint16_t)tx,
                                                          (uint16_t)ty);
                                                                /* @asm 0x4FC8B */
                        if (DG8(0x9870 + owner*16 + r) == 0)    /* @asm 0x4FC9F mission */
                            continue;                           /* @asm 0x4FCA6 */
                        if (ty < 2 ||                           /* @asm 0x4FCA9 */
                            (int16_t)(DG16(0x853C) - 3) < ty)   /* @asm 0x4FCB2 */
                            continue;
                        /* ---- FLAG BUILD for region r (L_4F998) ---- */
                        if (U_OFF(unit_index, U_ORDERS) == 0x0B &&
                            (int16_t)func_005E90_op_sz_64(
                                U_OFF(unit_index, U_DESTX),
                                U_OFF(unit_index, U_DESTY)) == r)
                            ai8_flags_9A = (int16_t)0xFFFF;     /* @asm 0x4F99C..0x4F9BC */
                        if (qty5_14 != 0 &&                     /* @asm 0x4F9C2 */
                            DG8(0x9870 + owner*16 + r) != 0) {  /* @asm 0x4F9D2 */
                            if (DG8(0x94E6 + owner*16 + r) < 1) { /* @asm 0x4F9D9 */
                                if ((int16_t)DG16(0x85C8 + r*2) > 0x0A)
                                    ai8_flags_9A |= 0x20;       /* @asm 0x4F9E5/0x4FA09 */
                            } else if ((int16_t)DG8(0x94A6 + owner*16 + r) <
                                       (int16_t)((int16_t)DG16(0x85C8 + r*2) >> 3))
                                ai8_flags_9A |= 0x20;           /* @asm 0x4F9F6..0x4FA09 */
                        }
                        if (ai8_qty3_48 != 0) {                 /* @asm 0x4FA0E */
                            int16_t keep_96 = 1;                /* @asm 0x4FA44 */
                            if (func_04C682_ai_power_strength_delta(
                                    (uint16_t)owner, r) > 0)    /* @asm 0x4FA1F/0x4FA25 */
                                ai8_flags_9A |= 0x40;           /* @asm 0x4FA29 */
                            if (DG8(0x94A6 + owner*16 + r) == 0) /* @asm 0x4FA38 */
                                ai8_flags_9A |= 0x40;           /* @asm 0x4FA3F */
                            if (col_own >= 0 && reg_own_col == r) { /* @asm 0x4FA4A/0x4FA52 */
                                if ((int16_t)(8 - (int16_t)DG8(0x94E6 + owner*16 + r))
                                        > col_own_dist)         /* @asm 0x4FA5E..0x4FA69 */
                                    ai8_flags_9A &= ~0x40;      /* @asm 0x4FA6E */
                                if (col_own_dist >= 0x0C)       /* @asm 0x4FA73 */
                                    keep_96 = 0;                /* @asm 0x4FA79 */
                            }
                            if (keep_96 != 0) {                 /* @asm 0x4FA7F */
                                int16_t t = (int16_t)(DGS16(0x538E) >> 4);
                                                                /* @asm 0x4FA86 */
                                if (DG16(0x9650) != 0 &&        /* @asm 0x4FA8F */
                                    (int16_t)((int16_t)DG8(0x94E6 + owner*16 + r) * 4
                                        + (int16_t)DG8(0x94A6 + owner*16 + r)) > t &&
                                                                /* @asm 0x4FAA0..0x4FAB1 */
                                    (int16_t)DG16(0x1734 + owner*2) < 0x14)
                                                                /* @asm 0x4FABB */
                                    ai8_flags_9A &= ~0x40;      /* @asm 0x4FAC2 */
                            }
                            if (ai8_7E != 0 &&                  /* @asm 0x4FAC7 */
                                DG8(0xA13C + r) > 1)            /* @asm 0x4FAD0 */
                                ai8_flags_9A &= ~0x40;          /* @asm 0x4FAD7 */
                            if (target_64 != 0)                 /* @asm 0x4FADC */
                                ai8_flags_9A |= 0x40;           /* @asm 0x4FAE2 */
                            if (hunt2_EA != 0)                  /* @asm 0x4FAE7 */
                                ai8_flags_9A |= 0x40;           /* @asm 0x4FAEE */
                            if (DG16(0x173E) & (uint16_t)(1u << r))
                                ai8_flags_9A |= 0x40;           /* @asm 0x4FAF3/0x4FB01 */
                        }
                        if (ai8_qty4_46 != 0 && (DG8(0x5382) & 1)) { /* @asm 0x4FB06/0x4FB0C */
                            if (DG8(0x94E6 + (int16_t)DG16(0x5398)*16 + r) != 0)
                                ai8_flags_9A |= 0x10;           /* @asm 0x4FB1D/0x4FB24 */
                        }
                        if (ai8_qty4_46 != 0 && !(DG8(0x5382) & 1)) {
                                                                /* @asm 0x4FB29/0x4FB32 */
                            if (DG8(0x9870 + owner*16 + r) == 4) /* @asm 0x4FB46 */
                                ai8_flags_9A |= 0x10;           /* @asm 0x4FB4D */
                            if (qty6_44 == 0) {                 /* @asm 0x4FB52 */
                                int16_t t = (int16_t)(DGS16(0x538E) >> 4);
                                                                /* @asm 0x4FB58 */
                                if (DG16(0x9650) != 0 &&        /* @asm 0x4FB61 */
                                    (int16_t)((int16_t)DG8(0x94E6 + owner*16 + r) * 4
                                        + (int16_t)DG8(0x94A6 + owner*16 + r)) > t &&
                                                                /* @asm 0x4FB72..0x4FB83 */
                                    (int16_t)DG16(0x1734 + owner*2) < 0x14)
                                                                /* @asm 0x4FB8D */
                                    ai8_flags_9A &= ~0x10;      /* @asm 0x4FB94 */
                            }
                            if (DG8(0x94E6 + owner*16 + r) == 0 && /* @asm 0x4FBA3 */
                                (DG8(0x95F2 + r) & 4) &&        /* @asm 0x4FBAA */
                                col_any_dist < 7)               /* @asm 0x4FBB1 */
                                ai8_flags_9A |= 0x10;           /* @asm 0x4FBB7 */
                            if (DG8(0x95F2 + r) & 8)            /* @asm 0x4FBBC */
                                ai8_flags_9A |= 0x10;           /* @asm 0x4FBC3 */
                        }
                        if (ai8_qty4_46 != 0) {                 /* @asm 0x4FBC8 */
                            if (func_04C306_ai_queue_a_lookup_max((uint16_t)owner,
                                    (uint16_t)map_x, (uint16_t)map_y, 7) != 0)
                                ai8_flags_9A |= 0x10;           /* @asm 0x4FBDD/0x4FBE7 */
                            if (func_04C306_ai_queue_a_lookup_max((uint16_t)owner,
                                    (uint16_t)map_x, (uint16_t)map_y, 1) != 0)
                                ai8_flags_9A |= 0x10;           /* @asm 0x4FBFB/0x4FC05 */
                            if (DG16(0x173C) & (uint16_t)(1u << r))
                                ai8_flags_9A |= 0x10;           /* @asm 0x4FC0A/0x4FC18 */
                        }
                    }
                }
                if (DG16(0x1740) != 0)                          /* @asm 0x4FCE0 override */
                    ai8_flags_9A = 0;                           /* @asm 0x4FCE7 */
                if (ai8_flags_9A != 0) {                        /* @asm 0x4FCED */
                    /* ---- BOARDING EXECUTOR (0x4FCF7..0x4FE37) ---- */
                    int16_t progress_76 = 0, repeat_24, dirc;
                    if (hunt2_EA != 0 || target_64 != 0)        /* @asm 0x4FCF7/0x4FCFE */
                        special = 0;                            /* @asm 0x4FD04 [bp-4] */
                    do {                                        /* L_4FD15 */
                        int cur;
                        repeat_24 = 0;                          /* @asm 0x4FD2D */
                        dirc = -1;                              /* @asm 0x4FD32 */
                        cur = unit_chain_resolve(unit_index);   /* @asm 0x4FD3B */
                        for (; cur >= 0 && dirc != 8 && repeat_24 == 0;
                             cur = unit_chain_next(cur)) {      /* @asm 0x4FDD5..0x4FDE6 */
                            uint8_t ct = U_OFF(cur, U_TYPE);
                            if (ct >= 0x0D && ct <= 0x12)       /* @asm 0x4FDEB/0x4FDF2 */
                                continue;
                            dirc = (int16_t)func_04C89E_ai_best_adjacent_move(
                                (uint16_t)owner, (uint16_t)map_x, (uint16_t)map_y,
                                (uint16_t)(ai8_flags_9A & 0x40),
                                (uint16_t)(ct == 0x0B ? 1 : 0)); /* @asm 0x4FD46..0x4FD62 */
                            if ((DG8(0x523D + (uint16_t)ct * 14) & (uint8_t)ai8_flags_9A)
                                && dirc != 8) {                 /* @asm 0x4FD7D/0x4FD83 */
                                progress_76 = 1;                /* @asm 0x4FD89 */
                                U_OFF(cur, 0x05) = 0;           /* @asm 0x4FD92 moves */
                                func_03F90E_logic_sz_50((uint16_t)cur,
                                                        (uint16_t)dirc);
                                                                /* @asm 0x4FD9D board */
                                func_007BCE_logic_sz_25((uint16_t)cur);
                                                                /* @asm 0x4FDA8 */
                                if (U_OFF(cur, U_MAPX) != (uint8_t)map_x ||
                                    U_OFF(cur, U_MAPY) != (uint8_t)map_y)
                                    repeat_24 = 1;              /* @asm 0x4FDB8..0x4FDC8 */
                            }
                        }
                    } while (repeat_24 != 0);                   /* @asm 0x4FE18/0x4FE1E */
                    if (progress_76 != 0)                       /* @asm 0x4FE28 */
                        func_007BCE_logic_sz_25((uint16_t)unit_index);
                                                                /* @asm 0x4FE2F */
                }
                /* ---- SAIL-DESTINATION DECISION (0x4FE4F..0x50140) ---- */
                if (special == 0) {                             /* @asm 0x4FE4F */
                    int run_scoring = 0;
                    if (ai8_80 != 0) {                          /* @asm 0x4FE58 */
                        run_scoring = 1;
                    } else if (!(ai8_qty3_48 == ai8_deliv_A6 && /* @asm 0x4FE62 */
                                 (int16_t)DG16(0x1734 + owner*2) < 0x19)
                                                                /* @asm 0x4FE6D */
                               && ai8_flags_9A == 0) {          /* @asm 0x4FE77 */
                        run_scoring = 1;
                    }
                    if (run_scoring) {
                        /* destination scoring over all colonies (0x4FE81..0x50124) */
                        int16_t bx_4C = (int16_t)U_OFF(unit_index, U_MAPX);
                        int16_t by_5C = (int16_t)U_OFF(unit_index, U_MAPY);
                                                                /* @asm 0x4FE85..0x4FE92 */
                        int16_t bestv = (int16_t)0xD8F1;        /* @asm 0x4FE95 -9999 */
                        int16_t ci, score_26;
                        for (ci = 0; ci < (int16_t)DG16(0x539E); ci++) {
                                                                /* @asm 0x4FE9B/0x50013 */
                            int16_t r, cap2, mult_B0 = 1;       /* @asm 0x5008C */
                            int16_t tx, ty, d;
                            func_0082DC_logic_sz_118((uint16_t)ci); /* @asm 0x50023 */
                            if (DG8(DG16(0x8542) + 0x1A) != (uint8_t)owner)
                                continue;                       /* @asm 0x50033 */
                            if (DG8(DG16(0x8542) + 0) == U_OFF(unit_index, U_MAPX) &&
                                DG8(DG16(0x8542) + 1) == U_OFF(unit_index, U_MAPY))
                                continue;                       /* @asm 0x5003E..0x5004B */
                            r = (int16_t)func_005E90_op_sz_64(
                                DG8(DG16(0x8542) + 0), DG8(DG16(0x8542) + 1));
                                                                /* @asm 0x50056 */
                            if (ai8_B2 != 0 &&                  /* @asm 0x50061 */
                                DG8(0x9870 + owner*16 + r) == 0)
                                continue;                       /* @asm 0x50071 */
                            cap2 = (int16_t)func_008734_logic_sz_30(); /* @asm 0x50078 */
                            if (cap2 > 0x0C) cap2 = 0x10;       /* @asm 0x50081/0x50086 */
                            if (ai8_qty4_46 == 0) {             /* @asm 0x50092 */
                                /* colonist-delivery scoring (L_4FED6) */
                                int16_t pop = (int16_t)DG8(DG16(0x8542) + 0x1F);
                                if (pop > 0x10) pop = 0x10;     /* @asm 0x4FEEB/0x4FEEF */
                                score_26 = (int16_t)(random_int_4D4(0, 8)
                                    + (((0x11 - pop) * (0x11 - pop) + 2) << 2));
                                                                /* @asm 0x4FED8..0x4FF02 */
                                score_26 = (int16_t)(score_26 +
                                    ((cap2 - (int16_t)DG8(DG16(0x8542) + 0x1F)) << 1));
                                                                /* @asm 0x4FF09..0x4FF15 */
                                if (DG8(0x94E6 + (int16_t)DG16(0x5398)*16 + r) != 0)
                                    score_26 += 0x14;           /* @asm 0x4FF22/0x4FF29 */
                                score_26 = (int16_t)(score_26 +
                                    ((DG8(DG16(0x8542) + 0x1B) & 0x10) ? 0x19 : -0x19));
                                                                /* @asm 0x4FF31..0x4FF3F
                                                                 * sbb/and trick: +-25 */
                            } else {                            /* military (L_5009B) */
                                score_26 = 0;                   /* @asm 0x5009B */
                                if (DG8(0x9870 + owner*16 + r) == 0)
                                    continue;                   /* @asm 0x500AA/0x500B1 */
                                {
                                    int16_t r2 = (int16_t)func_005E90_op_sz_64(
                                        DG8(DG16(0x8542) + 0), DG8(DG16(0x8542) + 1));
                                                                /* @asm 0x500C1 */
                                    score_26 = (int16_t)(score_26 +
                                        (((int16_t)(DG8(0x95F2 + r2) & 7)) << 3));
                                                                /* @asm 0x500CB..0x500DC */
                                }
                                if (DG8(0xA89C) != 0 && ai8_qty4_46 > 1)
                                                                /* @asm 0x500DF/0x500E6 */
                                    score_26 = (int16_t)(score_26 -
                                        (((int16_t)DG8(0xA89C) * ai8_qty4_46) << 3));
                                                                /* @asm 0x500EC..0x500F7 */
                                if (DG8(0x94E6 + (int16_t)DG16(0x5398)*16 + r) != 0)
                                    score_26 += 0x32;           /* @asm 0x50104/0x5010B */
                                if (DG8(DG16(0x8542) + 0x1B) & 0x40) {
                                    score_26 += 0x3C;           /* @asm 0x50113/0x5011C */
                                } else if (DG16(0x9650) > 1 &&  /* @asm 0x4FEA4 */
                                           (int16_t)DG16(0x1734 + owner*2) < 0x14) {
                                                                /* @asm 0x4FEB1 */
                                    score_26 -= 0x2D;           /* @asm 0x4FEB8 */
                                } else if (DG8(DG16(0x8542) + 0x1B) & 8) {
                                    score_26 += 0x2D;           /* @asm 0x4FEC4/0x4FECA */
                                } else {
                                    score_26 -= 0x0F;           /* @asm 0x4FED0 */
                                }
                            }
                            /* common tail (L_4FF42) */
                            score_26 = (int16_t)(score_26 +
                                (int16_t)(int8_t)DG8(DG16(0x8542) + 0x8F));
                                                                /* @asm 0x4FF46/0x4FF4B */
                            if (DG8(DG16(0x8542) + 0x1B) & 2) { /* @asm 0x4FF4E danger */
                                if (U_OFF(unit_index, U_TYPE) != 0x11)
                                    score_26 -= 0x32;           /* @asm 0x4FF58/0x4FF5F */
                            } else if (DG8(DG16(0x8542) + 0x1B) & 1) {
                                                                /* @asm 0x4FF66 */
                                if (U_OFF(unit_index, U_TYPE) < 0x11)
                                    score_26 = (int16_t)(score_26 +
                                        (((int16_t)DG8(0x5235 + (uint16_t)type * 14)
                                          - 0x0A) << 1));       /* @asm 0x4FF70..0x4FF94 */
                            }
                            if (!(DG8(0x5D62 + (uint16_t)DG16(0x8DC6) * 0xCA) & 0x40))
                                                                /* @asm 0x4FF97/0x4FF9D */
                                func_0083F2_op_sz_71(DG8(DG16(0x8542) + 0),
                                    DG8(DG16(0x8542) + 1), (uint16_t)owner,
                                    (uint16_t)-2);              /* @asm 0x4FFB7 re-find */
                            if ((int16_t)DG16(0x8DC6) < 0)      /* @asm 0x4FFBF */
                                continue;
                            ty = (int16_t)DG8(DG16(0x8542) + 1); /* @asm 0x4FFCA */
                            tx = (int16_t)DG8(DG16(0x8542) + 0); /* @asm 0x4FFD3 */
                            d = (int16_t)func_00493C_logic_sz_14((uint16_t)map_x,
                                    (uint16_t)map_y, (uint16_t)tx, (uint16_t)ty);
                                                                /* @asm 0x4FFE1 */
                            score_26 = (int16_t)(score_26 -
                                (((d * mult_B0) >> 1) + 1));    /* @asm 0x4FFE9..0x4FFF0 */
                            if (score_26 >= bestv) {            /* @asm 0x4FFF7 jl skips */
                                bestv = score_26;               /* @asm 0x4FFFF */
                                bx_4C = tx;                     /* @asm 0x50006 */
                                by_5C = ty;                     /* @asm 0x5000C */
                            }
                        }
                        /* threshold: qty4 present -> any score; else > -999 */
                        if ((int16_t)(ai8_qty4_46 >= 1 ? 0 : (int16_t)0xFC19) < bestv) {
                                                                /* @asm 0x50124..0x50131 */
                            func_04E2B6_unit_set_order_state((uint16_t)unit_index,
                                0x34, (uint8_t)bx_4C, (uint8_t)by_5C);
                                                                /* @asm 0x50133..0x5013C
                                                                 * dx='4' via 0x4F033 */
                            return move_eval_tail_51C68(unit_index, owner);
                        }
                    }
                }
            }

            /* ---- deliv==0 CONTINUATION (L_50140..0x50583) ---- */
            /* privateer auto-explore (0x50158..0x50194) */
            if ((DG8(0x5382) & 1) &&                            /* @asm 0x50158 */
                U_OFF(unit_index, U_TYPE) == 0x12 &&            /* @asm 0x50163 */
                special == 0 &&                                 /* @asm 0x5016A */
                ai8_deliv_A6 == 0 &&                            /* @asm 0x50170 */
                DG16(0x53DE) == 0 &&                            /* @asm 0x50177 */
                DG8(0x9456 + owner) == 0 &&                     /* @asm 0x50182 */
                (int16_t)(DG16(0x53DA) + DG16(0x53DC) + DG16(0x53E0)) != 0)
                                                                /* @asm 0x50189..0x50194 */
                goto ai8_explore_50196;
            /* idle-explore gate (0x501BA..0x501E0) */
            if (ai8_deliv_A6 == 0 &&                            /* @asm 0x501BA */
                ai8_best42 < 0 &&                               /* @asm 0x501C1 */
                transport_DA != 0 &&                            /* @asm 0x501C7 */
                special == 0 &&                                 /* @asm 0x501CE */
                DG8(0x945A + owner) > DG8(0x9456 + owner))      /* @asm 0x501D4..0x501E0 */
                goto ai8_explore_50196;
            /* unload evaluation (0x501FA..0x50538) */
            if (ai8_cargo_B4 != 0 && special == 0) {            /* @asm 0x501FA/0x50204 */
                if (ai8_best42 >= 0) {                          /* @asm 0x5020D */
                    int16_t best_22 = -1, bestv = -1;           /* @asm 0x50216 */
                    int16_t ci;
                    for (ci = 0; ci < (int16_t)DG16(0x539E); ci++) {
                                                                /* @asm 0x50220/0x50414 */
                        int16_t r, cap_20, ok_8, score_26, g, d;
                        func_0082DC_logic_sz_118((uint16_t)ci); /* @asm 0x50422 */
                        if (DG8(DG16(0x8542) + 0x1A) != (uint8_t)owner)
                            continue;                           /* @asm 0x50432 */
                        if (ci == col_own && col_own_dist == 0) /* @asm 0x5043A/0x5043F */
                            continue;
                        if (!(DG8(0x5D62 + (uint16_t)ci * 0xCA) & 0x40))
                            continue;                           /* @asm 0x50445/0x5044F
                                                                 * harbor flag */
                        if ((int16_t)(int8_t)U_OFF(unit_index, 0x06) == ci)
                            continue;                           /* @asm 0x50455/0x5045D */
                        if (ai8_best42 == 8) {                  /* @asm 0x5045F horses */
                            int16_t c2 = func_008D00_colony_stock_cap();
                                                                /* @asm 0x50465 */
                            if ((int16_t)((int16_t)qty_tally_C6[8] +
                                    (int16_t)DG16(DG16(0x8542) + 0xAA)) > c2)
                                continue;                       /* @asm 0x5046C..0x5047B */
                        }
                        r = (int16_t)func_005E90_op_sz_64(
                            DG8(DG16(0x8542) + 0), DG8(DG16(0x8542) + 1));
                                                                /* @asm 0x5048A */
                        cap_20 = func_008D00_colony_stock_cap(); /* @asm 0x50495 */
                        ok_8 = 1;                               /* @asm 0x5049D */
                        score_26 = 0;                           /* @asm 0x504A4 */
                        for (g = 0; g < 0x10; g++) {            /* @asm 0x504A7/0x50291 */
                            int16_t a, stock;
                            if (qty_tally_C6[g] == 0)           /* @asm 0x5029C */
                                continue;
                            stock = (int16_t)DG16(DG16(0x8542) + 0x9A + g*2);
                            if (DG16(DG16(0x8542) + 0x90) & (uint16_t)(1u << g)) {
                                                                /* @asm 0x502B0 boycott */
                                if (stock >= 0x64) {            /* @asm 0x502BB */
                                    ok_8 = 0;                   /* @asm 0x502C5 */
                                    continue;                   /* (loop exits via cond) */
                                }
                            }
                            /* score block A (L_50228) */
                            a = (int16_t)qty_tally_C6[g];       /* @asm 0x5022C */
                            if ((int16_t)(a + stock) >= cap_20) /* @asm 0x50235/0x50239 */
                                score_26 = (int16_t)(score_26 +
                                    (((cap_20 - stock - a) *
                                      (int16_t)DG8(0x84BC + owner*16 + g)) << 2));
                                                                /* @asm 0x5023E..0x5025D */
                            if (DG8(DG16(0x8542) + 0x8D) == (uint8_t)g)
                                                                /* @asm 0x50268 wanted */
                                score_26 = (int16_t)(score_26 +
                                    (((int16_t)(int8_t)DG8(DG16(0x8542) + 0x8F) + 8)
                                     << 2));                    /* @asm 0x5026E..0x50279 */
                            score_26 = (int16_t)(score_26 +
                                (cap_20 - stock - 1));          /* @asm 0x5027C..0x5028A */
                        }
                        if (ok_8 == 0)                          /* @asm 0x502CA */
                            continue;                           /* @asm 0x502D0 */
                        if (ai8_best42 == 0x0F) {               /* @asm 0x502D3 muskets */
                            int16_t k;
                            if (DG8(0x94E6 + (int16_t)DG16(0x5398)*16 + r) != 0)
                                score_26 += 0x10;               /* @asm 0x502E6/0x502ED */
                            for (k = 0; k < 0x14; k++) {        /* @asm 0x502F1/0x50301 */
                                int16_t cy = (int16_t)((int8_t)DG8(0x00DE + k)
                                    + DG8(DG16(0x8542) + 1));   /* @asm 0x5030A..0x5031A */
                                int16_t cx = (int16_t)((int8_t)DG8(0x00C8 + k)
                                    + DG8(DG16(0x8542) + 0));   /* @asm 0x5031E..0x50327 */
                                int16_t oth;
                                if (func_005BFA_logic_sz_49((uint16_t)cx,
                                        (uint16_t)cy) == 0)     /* @asm 0x5032B/0x50333 */
                                    continue;
                                oth = (int16_t)func_006018_logic_sz_33(
                                    (uint16_t)cx, (uint16_t)cy); /* @asm 0x5033D */
                                if (oth < 4) {                  /* @asm 0x50348 */
                                    score_26 += 0x18;           /* @asm 0x502FA */
                                } else {
                                    score_26 = (int16_t)(score_26 +
                                        ((int16_t)func_008262_logic_sz_20(
                                            (uint16_t)func_0082A0_logic_sz_18(
                                                (uint16_t)(oth - 4),
                                                (uint16_t)owner)) << 4));
                                                                /* @asm 0x50351..0x50369 */
                                }
                            }
                        }
                        if (DG8(DG16(0x8542) + 0x1B) & 2) {     /* @asm 0x50372 danger */
                            if (U_OFF(unit_index, U_TYPE) < 0x10)
                                score_26 = (int16_t)(score_26 +
                                    (((int16_t)DG8(0x5235 + (uint16_t)type * 14)
                                      - 0x0A) << 3));           /* @asm 0x5037C..0x503A1 */
                        } else if (DG8(DG16(0x8542) + 0x1B) & 1) {
                                                                /* @asm 0x503A4 */
                            if (U_OFF(unit_index, U_TYPE) < 0x10)
                                score_26 = (int16_t)(score_26 +
                                    (((int16_t)DG8(0x5235 + (uint16_t)type * 14)
                                      - 0x0A) << 1));           /* @asm 0x503AE..0x503D0 */
                        }
                        d = (int16_t)func_00493C_logic_sz_14((uint16_t)map_x,
                                (uint16_t)map_y, DG8(DG16(0x8542) + 0),
                                DG8(DG16(0x8542) + 1));         /* @asm 0x503EA */
                        score_26 = (int16_t)(score_26 / ((d >> 2) + 1));
                                                                /* @asm 0x503F2..0x503FC */
                        if (score_26 >= bestv) {                /* @asm 0x50401 jl skips */
                            bestv = score_26;                   /* @asm 0x50407 */
                            best_22 = ci;                       /* @asm 0x5040E */
                        }
                    }
                    if (best_22 >= 0) {                         /* @asm 0x504B0 */
                        func_0082DC_logic_sz_118((uint16_t)best_22); /* @asm 0x504B9 */
                        func_04E2B6_unit_set_order_state((uint16_t)unit_index, 0x50,
                            DG8(DG16(0x8542) + 0), DG8(DG16(0x8542) + 1));
                                                                /* @asm 0x504C1..0x504D5
                                                                 * dx='P', jmp 0x4E9E5 */
                        return move_eval_tail_51C68(unit_index, owner);
                    }
                    /* no harbor found: AT-SEA EMERGENCY UNLOAD (L_5052D) */
                    while (U_OFF(unit_index, 0x0C) != 0) {      /* @asm 0x50531 */
                        int16_t good = (int16_t)func_00B42C_logic_sz_139(
                            (uint16_t)unit_index, 0);           /* @asm 0x504DD discharge */
                        uint16_t price = DG16(0x8DC4);          /* @asm 0x504E9 */
                        int32_t v;
                        func_03234A(good, (int)price);          /* @asm 0x504EE market */
                        v = (int32_t)(int16_t)DG8(0x84BC + owner*16 + good)
                            * (int32_t)(int16_t)price;          /* @asm 0x50501/0x50507 */
                        DGS32(DG16(0x84FC) + 0x2A) += v;        /* @asm 0x50510 gold */
                        DGS32(DG16(0x84FC) + 0x7C + good*4) += v; /* @asm 0x5051B */
                        DGS32(DG16(0x84FC) + 0xBC + good*4) +=
                            (int32_t)(int16_t)price;            /* @asm 0x50521..0x50529 */
                    }
                    U_OFF(unit_index, 0x0C) = 0;                /* @asm 0x5053C */
                } else {
                    /* best42 < 0: capacity explore check (L_50541) */
                    uint8_t cc = U_OFF(unit_index, 0x0C);       /* @asm 0x50545 */
                    if (DG8(0x5237 + (uint16_t)type * 14) == cc) /* @asm 0x5055B full */
                        goto ai8_explore_50196;                 /* @asm 0x50561 */
                    if (cc > 1)                                 /* @asm 0x50564 */
                        goto ai8_explore_50196;                 /* @asm 0x50568 */
                }
            }
        }
    }
ai9:                                                            /* 0x50583 */
    /* ======================= AI9: TRANSPORT-REQUEST PICKUP ==================
     * (0x50583..0x5076E)  Ship answers the per-power TRANSPORT-REQUEST QUEUE
     * (16 stride-6 entries at DGROUP:0xA0DC, built by the AI census pass:
     * +0 colony idx word / +2 demand word / +4 count byte / +5 priority
     * flag byte).  Score = demand / (octile/4 + 1); the unit's home colony
     * is excluded; colonies with the danger flag (+0x1B bit 1) only accept
     * type >= 0x10; when transport_CA == 0 only flagged (+5) entries can
     * win.  Winner: the entry is consumed pro-rata (remaining = count -
     * free_slots, demand scaled by remaining/count, slot freed at zero)
     * and the ship gotoes the colony as '5' (the shared 0x50757 commit).
     * Gates + loop BYTE_VERIFIED @asm 0x05059F..0x05076B (decode sheet). */
    if (!(type >= 0x0D && type <= 0x12)) goto ai10;             /* @asm 0x05059F/0x0505A9 */
    if (!transport_CA && !transport_DA)   goto ai10;             /* @asm 0x0505B3/0x0505BA */
    if (ai8_deliv_A6 != 0)               goto ai10;             /* @asm 0x0505C4 [bp-0xA6] */
    if (special != 0)                     goto ai10;             /* @asm 0x0505CE */
    {
        int16_t best_22 = -1, best_E0 = -1;                     /* @asm 0x0505D7 */
        int16_t d_4E, score_26;
        for (d_4E = 0; d_4E < 0x10; d_4E++) {                   /* @asm 0x0505E1/0x0506AF */
            int16_t dist;
            if ((int16_t)DG16(0xA0DC + d_4E * 6) < 0)           /* @asm 0x0505F1 empty */
                continue;
            if ((int8_t)DG8(0xA0E0 + d_4E * 6) <= 0)            /* @asm 0x050603 count */
                continue;
            func_0082DC_logic_sz_118(DG16(0xA0DC + d_4E * 6));  /* @asm 0x05061B select */
            score_26 = (int16_t)DG16(0xA0DE + d_4E * 6);        /* @asm 0x050623 demand */
            if ((int16_t)(int8_t)U_OFF(unit_index, 0x06) ==
                (int16_t)DG16(0x8DC6))                          /* @asm 0x050633 home */
                continue;                                       /* @asm 0x050637 */
            if ((DG8(DG16(0x8542) + 0x1B) & 2) &&               /* @asm 0x05063D danger */
                U_OFF(unit_index, U_TYPE) < 0x10)               /* @asm 0x050647 */
                continue;                                       /* @asm 0x05064C */
            dist = (int16_t)func_00493C_logic_sz_14(
                U_OFF(unit_index, U_MAPX), U_OFF(unit_index, U_MAPY),
                DG8(DG16(0x8542) + 0), DG8(DG16(0x8542) + 1));  /* @asm 0x050669 */
            score_26 = (int16_t)(score_26 / ((dist >> 2) + 1)); /* @asm 0x050673/0x05067B */
            if (score_26 < best_E0)                             /* @asm 0x050680 jl */
                continue;
            if (transport_CA == 0 &&                            /* @asm 0x050686 */
                DG8(0xA0E1 + d_4E * 6) == 0)                    /* @asm 0x050698 flag */
                continue;                                       /* @asm 0x05069D */
            best_E0 = score_26;                                 /* @asm 0x0506A2 */
            best_22 = d_4E;                                     /* @asm 0x0506A9 */
        }
        if (best_22 < 0)                                        /* @asm 0x0506B8 */
            goto ai10;                                          /* @asm 0x0506BE */
        {   /* consume the winning entry pro-rata (0x0506C1..0x050735) */
            int16_t cnt = (int16_t)(int8_t)DG8(0xA0E0 + best_22 * 6);
                                                                /* @asm 0x0506CC */
            int16_t remaining = (int16_t)(cnt
                - (int16_t)DG8(0x5237 + (uint16_t)type * 14)    /* hold capacity */
                + (int16_t)U_OFF(unit_index, 0x0C));            /* already loaded
                                                                 * @asm 0x0506F1..0x0506FB */
            if (remaining < 0) remaining = 0;                   /* @asm 0x0506FD */
            DG16(0xA0DE + best_22 * 6) = (uint16_t)(
                (int16_t)((int16_t)DG16(0xA0DE + best_22 * 6) * remaining) / cnt);
                                                                /* @asm 0x050709/0x05070E */
            DG8(0xA0E0 + best_22 * 6) = (uint8_t)remaining;     /* @asm 0x050718 */
            func_0082DC_logic_sz_118(DG16(0xA0DC + best_22 * 6)); /* @asm 0x050720 */
            if (remaining == 0)                                 /* @asm 0x050728 */
                DG16(0xA0DC + best_22 * 6) = 0xFFFF;            /* @asm 0x05072F free */
        }
        goto ai11_goto_colony_35;          /* @asm 0x050757..0x05076B: dx='5',
                                            * the shared goto-colony commit */
    }
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
     * 0x4F225 then jmp 0x51C68.  0x191F:0x2EA is an RTLink SUB-SEGMENT record
     * (trailer 0x138; directory decode pending, see ovlresolve.py) -- NOT
     * page08+0x15E: that mis-resolution briefly wired the unit timer-decay
     * func_040608 here and zeroed ship types in the soak (caught by the
     * baseline pin at turn 383).  Weak-stub no-op until the sub-segment
     * directory is decoded (ROUTE_B 1.5a). */
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
     * (0x50A4D..0x50BE7)  Type 3 (missionary): scores same-region native
     * settlements by alliance(tribe, owner) x 8 / (octile+1), x1.5 when the
     * settlement's +3 bit-4 visited flag is set; goto the winner as 'J'.
     * Settlements that already hold OUR mission (+5 low nibble == owner) are
     * only revisited when the treasury is >= 2500 AND alliance(tribe,
     * current_nation) < 0x4B AND relations(tribe, nation) bit 0x20 is set AND
     * DG8(0x917C+owner) < DG8(0x917C+nation).
     * NO WINNER: the missionary is DEMOTED to type 0 (record +0x02 := 0) and
     * falls through into AI14 (the original re-reads the record in each gate;
     * the local mirror is updated to match).
     * All control flow BYTE_VERIFIED @asm 0x050A65..0x050BE7. */
    if (type != 3) goto ai14;                                   /* @asm 0x050A69 */
    {
        int16_t best_22 = -1;                                   /* @asm 0x050A73 */
        int16_t best_E0 = (int16_t)0xFC19;                      /* @asm 0x050A78 -999 */
        int16_t si_4E;                                          /* [bp-0x4E] */
        for (si_4E = 0; si_4E < (int16_t)DG16(0x539A); si_4E++) {
                                                                /* @asm 0x050A7E/0x050A9E */
            int16_t visited_D6, score_CE, d;
            func_0081F2_logic_sz_34((uint16_t)si_4E);           /* @asm 0x050AAC select */
            if ((int16_t)func_005E90_op_sz_64(DG8(DG16(0x8D4A) + 0),
                    DG8(DG16(0x8D4A) + 1)) != region)           /* @asm 0x050AC1/0x050AC9 */
                continue;
            if ((int16_t)(DG8(DG16(0x8D4A) + 5) & 0x0F) == owner) {
                                                                /* @asm 0x050AD2/0x050AD8
                                                                 * own mission present */
                int32_t treasury = (int32_t)((uint32_t)DG16(DG16(0x84FC) + 0x2A)
                              | ((uint32_t)DG16(DG16(0x84FC) + 0x2C) << 16));
                if (treasury < 0x9C4)                           /* @asm 0x050AE2..0x050AEF
                                                                 * signed-32 cmp vs 2500 */
                    continue;
                if ((int16_t)func_0082A0_logic_sz_18(DG16(0x8D52),
                        DG16(0x5398)) >= 0x4B)                  /* @asm 0x050A8E/0x050A96 */
                    continue;
                if (!(func_007F34_logic_sz_27(DG16(0x8D52),
                        DG16(0x5398)) & 0x20))                  /* @asm 0x050AFC/0x050B04 */
                    continue;
                if (DG8(0x917C + owner) >=
                    DG8(0x917C + (int16_t)DG16(0x5398)))        /* @asm 0x050B0C/0x050B14 */
                    continue;
            }
            /* candidate scoring (0x050B1A) */
            visited_D6 = (int16_t)(DG8(DG16(0x8D4A) + 3) & 4);  /* @asm 0x050B1E */
            /* @asm 0x050B28..0x050B46: muster_braves(si, &out); if result >= 0
             * the original adds out<<5 into [bp-0xCE] -- a DEAD STORE, since
             * 0x050B5A unconditionally overwrites [bp-0xCE] with the alliance
             * probe below.  The call is kept (pure reads), the bonus omitted. */
            (void)func_0460F8_muster_braves((uint16_t)si_4E);   /* @asm 0x050B30 */
            score_CE = (int16_t)func_0082A0_logic_sz_18(DG16(0x8D52),
                           (uint16_t)owner);                    /* @asm 0x050B52/0x050B5A */
            score_CE = (int16_t)(score_CE << 3);                /* @asm 0x050B5E */
            d = (int16_t)func_00493C_logic_sz_14((uint16_t)map_x, (uint16_t)map_y,
                    DG8(DG16(0x8D4A) + 0), DG8(DG16(0x8D4A) + 1)); /* @asm 0x050B78 */
            score_CE = (int16_t)(score_CE / (int16_t)(d + 1));  /* @asm 0x050B82/0x050B88 */
            if (visited_D6 != 0)                                /* @asm 0x050B8E */
                score_CE = (int16_t)(score_CE + (score_CE >> 1)); /* @asm 0x050B95 x1.5 */
            if (best_E0 < score_CE) {                           /* @asm 0x050B9F jl */
                best_E0 = score_CE;                             /* @asm 0x050BA8 */
                best_22 = si_4E;                                /* @asm 0x050BAF */
            }
        }
        if (best_22 >= 0) {                                     /* @asm 0x050BBA */
            func_0081F2_logic_sz_34((uint16_t)best_22);         /* @asm 0x050BBF select */
            func_04E2B6_unit_set_order_state((uint16_t)unit_index, 0x4A,
                DG8(DG16(0x8D4A) + 0), DG8(DG16(0x8D4A) + 1));
                          /* @asm 0x050BC7..0x050BDB: dx='J', jmp 0x4E9E5 */
            return move_eval_tail_51C68(unit_index, owner);
        }
        U_OFF(unit_index, U_TYPE) = 0;                          /* @asm 0x050BE2 demote */
        type = 0;             /* local mirror: AI14/AI16 gates re-read the record */
    }
ai14:                                                           /* 0x50BE7 */
    /* ======================= AI14: SOLDIER/SETTLER HEAD HOME ================
     * (0x50BE7..0x50C42)  Type 5 (soldier) or type 2 (farmer/settler) with no
     * active mission in this region, when the region holds an own colony:
     * goto the nearest own colony as prof 'N'.
     * BYTE_VERIFIED @asm 0x050C03..0x050C3E. */
    if (type != 5 && type != 2) goto ai15;                      /* @asm 0x050C03/0x050C0F */
    if (mission_28 != 0)        goto ai15;                      /* @asm 0x050C11 */
    if (reg_own_col != region)  goto ai15;                      /* @asm 0x050C1A */
    func_0082DC_logic_sz_118((uint16_t)col_own);                /* @asm 0x050C22 select */
    func_04E2B6_unit_set_order_state((uint16_t)unit_index, 0x4E,
        DG8(DG16(0x8542) + 0), DG8(DG16(0x8542) + 1));
                          /* @asm 0x050C2A..0x050C3E: dx='N', jmp 0x4E9E5 */
    return move_eval_tail_51C68(unit_index, owner);
ai15:                                                           /* 0x50C42 */
    /* ======================= AI15a: REASSIGN WANDER =========================
     * (0x50C5A..0x50D62)  reassign != 0: in-flight goto (orders 0x0B) exits
     * via the tail.  Otherwise pick/keep a wander heading: record byte +0x12
     * (set 0xFF by AI5) indexes the 20-entry signed delta tables DG8(0xC8+k) /
     * DG8(0xDE+k); negative -> reroll random(1,0x14)-1.  Target = map +/-
     * delta*4 (prof '8' with a live +0x11 cooldown keeps the stamped dest).
     * The target must be in bounds, not on a visited quad (DG8(0x9FAA +
     * (tx/4)*0x12 + ty/4) & 6 clear), in this region, and unowned (probe
     * 0x181F:0x6D2 < 0).  Commit: +0x11 := max(dx*4, dy*4), patience +0x10
     * -= 8 when > 8, goto (tx,ty) as '8'.  Any failure falls to AI15b.
     * BYTE_VERIFIED @asm 0x050C5A..0x050D5E. */
    if (reassign == 0) goto ai15b;                              /* @asm 0x050C5E */
    if (U_OFF(unit_index, U_ORDERS) == 0x0B)                    /* @asm 0x050C67 */
        return move_eval_tail_51C68(unit_index, owner);         /* @asm 0x050C6E */
    if ((int8_t)U_OFF(unit_index, 0x12) < 0)                    /* @asm 0x050C75 */
        U_OFF(unit_index, 0x12) =
            (uint8_t)(random_int_4D4(1, 0x14) - 1);             /* @asm 0x050C82/0x050C8A */
    {
        int16_t k_4E = (int16_t)U_OFF(unit_index, 0x12);        /* @asm 0x050C94 */
        int16_t tx_16, ty_1A;
        if (U_OFF(unit_index, U_PROF) == 0x38 &&                /* @asm 0x050C9D '8' */
            U_OFF(unit_index, 0x11) != 0) {                     /* @asm 0x050CA4 */
            tx_16 = (int16_t)U_OFF(unit_index, U_DESTX);        /* @asm 0x050CAA */
            ty_1A = (int16_t)U_OFF(unit_index, U_DESTY);        /* @asm 0x050CB1 */
        } else {
            tx_16 = (int16_t)(((int8_t)DG8(0xC8 + k_4E) << 2) + map_x);
                                                                /* @asm 0x050CBA..0x050CC6 */
            ty_1A = (int16_t)(((int8_t)DG8(0xDE + k_4E) << 2) + map_y);
                                                                /* @asm 0x050CC9..0x050CD1 */
        }
        if (func_005BFA_logic_sz_49((uint16_t)tx_16,
                                    (uint16_t)ty_1A) == 0)      /* @asm 0x050CDC */
            goto ai15b;                                         /* @asm 0x050CE6 */
        if (DG8(0x9FAA + (tx_16 >> 2) * 0x12 + (ty_1A >> 2)) & 6)
                                                                /* @asm 0x050CE8..0x050CF7 */
            goto ai15b;                                         /* @asm 0x050CFC */
        if ((int16_t)func_005E90_op_sz_64((uint16_t)tx_16,
                (uint16_t)ty_1A) != region)                     /* @asm 0x050D04/0x050D0C */
            goto ai15b;
        if ((int16_t)func_006018_logic_sz_33((uint16_t)tx_16,
                (uint16_t)ty_1A) >= 0)                          /* @asm 0x050D17/0x050D1F */
            goto ai15b;
        {
            int16_t cy = (int16_t)((int8_t)DG8(0xDE + k_4E) << 2);
                                                                /* @asm 0x050D26..0x050D2E */
            int16_t cx = (int16_t)((int8_t)DG8(0xC8 + k_4E) << 2);
                                                                /* @asm 0x050D30..0x050D35 */
            if (cx < cy) cx = cy;                               /* @asm 0x050D38 signed max */
            U_OFF(unit_index, 0x11) = (uint8_t)cx;              /* @asm 0x050D42 cooldown */
        }
        if (U_OFF(unit_index, 0x10) > 8)                        /* @asm 0x050D46 patience */
            U_OFF(unit_index, 0x10) -= 8;                       /* @asm 0x050D4D */
        func_04E2B6_unit_set_order_state((uint16_t)unit_index, 0x38,
            (uint8_t)tx_16, (uint8_t)ty_1A);
                          /* @asm 0x050D52..0x050D5E: dx='8', jmp 0x4E9E5 */
        return move_eval_tail_51C68(unit_index, owner);
    }

ai15b:                                                          /* 0x50D62 */
    /* ======================= AI15b: GARRISON-CALL RESPONSE ==================
     * (0x50D62..0x50E20)  Fast land unit (movement > 1, not ship band) with a
     * home colony (+0x06 >= 0) whose colony record raises flag +0x1B bit 2
     * ("guard requested"): scouts (type 4) ignore the call when the request
     * counter +0x1E is 0; the colony must be in this region.  Respond: clear
     * the flag bit, decrement the counter (when nonzero), goto colony as 'W'.
     * BYTE_VERIFIED @asm 0x050D7E..0x050E1B. */
    if (type >= 0x0D && type <= 0x12) goto ai16;                /* @asm 0x050D7E/0x050D85 */
    if (DG8(0x5236 + (uint16_t)type * 14) <= 1) goto ai16;      /* @asm 0x050DAB movement */
    if ((int8_t)U_OFF(unit_index, 0x06) < 0) goto ai16;         /* @asm 0x050DB4 */
    func_0082DC_logic_sz_118(
        (uint16_t)(int8_t)U_OFF(unit_index, 0x06));             /* @asm 0x050DC3 select */
    if (!(DG8(DG16(0x8542) + 0x1B) & 4)) goto ai16;             /* @asm 0x050DCF */
    if (DG8(DG16(0x8542) + 0x1E) == 0 &&                        /* @asm 0x050DD5 */
        U_OFF(unit_index, U_TYPE) == 4) goto ai16;              /* @asm 0x050DDB scout */
    if ((int16_t)func_005E90_op_sz_64(DG8(DG16(0x8542) + 0),
            DG8(DG16(0x8542) + 1)) != region) goto ai16;        /* @asm 0x050DE9/0x050DF1 */
    DG8(DG16(0x8542) + 0x1B) &= 0xFB;                           /* @asm 0x050DFA clear bit2 */
    if (DG8(DG16(0x8542) + 0x1E) != 0)                          /* @asm 0x050DFE */
        DG8(DG16(0x8542) + 0x1E) -= 1;                          /* @asm 0x050E04 */
    func_04E2B6_unit_set_order_state((uint16_t)unit_index, 0x57,
        DG8(DG16(0x8542) + 0), DG8(DG16(0x8542) + 1));
                          /* @asm 0x050E07..0x050E1B: dx='W', jmp 0x4E9E5 */
    return move_eval_tail_51C68(unit_index, owner);
ai16:                                                           /* 0x50E20 */
    /* ======================= AI16: SETTLER WORKS THE LAND ===================
     * (0x50E20..0x50EC8)  Type 2 (settler) not reassigned: decide whether to
     * start improving the current tile (orders := 9, prof := 'R', exit tail).
     * Vetoes (ok := 0):
     *   - a native settlement claims the tile: claim-tier(tribe) >= the
     *     distance to the nearest settlement AND trade tier_52 < 3
     *   - a FOREIGN colony lies within distance < 3
     * BYTE_VERIFIED @asm 0x050E3C..0x050EC3. */
    if (type != 2 || reassign != 0) goto ai16_exit;             /* @asm 0x050E3C/0x050E46 */
    {
        int16_t ok_8 = 1;                                       /* @asm 0x050E4C [bp-8] */
        if (settle_idx >= 0) {                                  /* @asm 0x050E51 */
            func_0081F2_logic_sz_34((uint16_t)settle_idx);      /* @asm 0x050E5C select */
            if ((int16_t)func_00822A_logic_sz_36(DG16(0x8D52))
                    >= settle_dist &&                           /* @asm 0x050E68/0x050E73 */
                tier_52 < 3)                                    /* @asm 0x050E79 */
                ok_8 = 0;                                       /* @asm 0x050E7F */
        }
        if (col_any >= 0) {                                     /* @asm 0x050E84 */
            func_0082DC_logic_sz_118((uint16_t)col_any);        /* @asm 0x050E8F select */
            if (DG8(DG16(0x8542) + 0x1A) != (uint8_t)owner &&   /* @asm 0x050E9F */
                col_any_dist < 3)                               /* @asm 0x050EA4 */
                ok_8 = 0;                                       /* @asm 0x050EAA */
        }
        if (ok_8 != 0) {                                        /* @asm 0x050EAF */
            U_OFF(unit_index, U_ORDERS) = 9;                    /* @asm 0x050EB9 */
            U_OFF(unit_index, U_PROF)   = 0x52;                 /* @asm 0x050EBE 'R' */
            return move_eval_tail_51C68(unit_index, owner);     /* @asm 0x050EC3 */
        }
    }

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
    /* ======================= AI17: HUNT FLAG + SHIP EXPLORE =================
     * (0x50F36..0x51099)  hunt_EA := 1 when func_04CAF6(x,y,owner,MODE 1)
     * finds no target, or for an immobile land unit; cleared for ships during
     * revolution.  Ships with hunt set, cat-3/4 tasks pending and no delivery
     * flags roll explore: flags bit 0x10 set -> 1-in-0x30 chance to clear it;
     * else 1-in-0x10 chance to pick a random far ocean tile (octile >= 8,
     * water probe + layer-164 == 1) -> set bit 0x10 and goto it as 'D'.
     * BYTE_VERIFIED @asm 0x50F36..0x51099. */
    if ((int16_t)func_04CAF6_ai_find_nearest_target((uint16_t)map_x,
            (uint16_t)map_y, (uint16_t)owner, 1) < 0)           /* @asm 0x50F4B/0x50F53 */
        hunt_EA = 1;                                            /* @asm 0x50F84 */
    else if (!(type >= 0x0D && type <= 0x12) &&                 /* @asm 0x50F59/0x50F65 */
             DG8(0x5236 + (uint16_t)type * 14) == 0)            /* @asm 0x50F7D */
        hunt_EA = 1;
    if ((type >= 0x0D && type <= 0x12) && (DG8(0x5382) & 1))    /* @asm 0x50F8E/0x50F9C */
        hunt_EA = 0;                                            /* @asm 0x50FA3 */

    if ((type >= 0x0D && type <= 0x12) &&                       /* @asm 0x50FAD/0x50FB7 */
        hunt_EA != 0 &&                                         /* @asm 0x50FC1 */
        (int16_t)(ai8_qty4_46 + ai8_qty3_48) != 0 &&            /* @asm 0x50FCB/0x50FD1 */
        ai8_flags_9A == 0 &&                                    /* @asm 0x50FD6 */
        !(DG8(0x5382) & 1)) {                                   /* @asm 0x50FE0 */
        if (U_OFF(unit_index, 0x04) & 0x10) {                   /* @asm 0x50FEA */
            if (random_int_4D4(0, 0x30) == 0)                   /* @asm 0x51084/0x5108C */
                U_OFF(unit_index, 0x04) &= 0xEF;                /* @asm 0x51094 */
        } else if (random_int_4D4(0, 0x10) == 0) {              /* @asm 0x50FFA/0x51002 */
            int16_t ex = random_int_4D4(2,
                (int16_t)(DG16(0x853A) - 3));                   /* @asm 0x51009..0x5101A */
            int16_t ey = random_int_4D4(2,
                (int16_t)(DG16(0x853C) - 3));                   /* @asm 0x5101D..0x5102E */
            if (func_0062B4_op_sz_39((uint16_t)ex,
                                     (uint16_t)ey) != 0 &&      /* @asm 0x51035/0x5103D */
                (uint8_t)(func_005DBA_logic_sz_17((uint16_t)ex,
                              (uint16_t)ey) - 1) == 0 &&        /* @asm 0x51047/0x5104F */
                (int16_t)func_00493C_logic_sz_14((uint16_t)map_x, (uint16_t)map_y,
                    (uint16_t)ex, (uint16_t)ey) >= 8) {         /* @asm 0x51061/0x51069 */
                U_OFF(unit_index, 0x04) |= 0x10;                /* @asm 0x5106E */
                func_04E2B6_unit_set_order_state((uint16_t)unit_index, 0x44,
                    (uint8_t)ex, (uint8_t)ey);
                          /* @asm 0x51073..0x5107C -> 0x50D5B: dx='D', jmp 0x4E9E5 */
                return move_eval_tail_51C68(unit_index, owner);
            }
        }
    }

    /* ======================= AI18: DIRECTION-SCORING LOOP ===================
     * (0x510B1..0x51A18)  For each of the 8 neighbours: base score by role
     * (wagon / reassign / carried-flags / colony / ability), own-colony and
     * threat bonuses, an attack evaluation (func_05CA7E) for hostile tiles,
     * a turn penalty against the last direction (+0x0B), neighbour-stack
     * penalties, and a hunt-extension probe at distance x4.  The best
     * direction lands in dir_choice; fortify_CC mirrors its attack flag.
     * Falls into AI19.  BYTE_VERIFIED @asm 0x510B1..0x51A15. */
    {
        int16_t best_E0 = (int16_t)0xFC19;                      /* @asm 0x510B1 -999 */
        int16_t d_4E;                                           /* [bp-0x4E] */
        dir_choice = 8;                                         /* @asm 0x510B7 */
        for (d_4E = 0; d_4E < 8; d_4E++) {                      /* @asm 0x510BC/0x51376 */
            int16_t tx_16, ty_1A, occ_38, oth_E, stack_5A;
            int16_t score_26, fort_7C = 0;
            ty_1A = (int16_t)((int8_t)DG8(0x00BE + d_4E) + map_y); /* @asm 0x51382 */
            tx_16 = (int16_t)((int8_t)DG8(0x00B4 + d_4E) + map_x); /* @asm 0x5138F */
            if (func_005BFA_logic_sz_49((uint16_t)tx_16,
                                        (uint16_t)ty_1A) == 0)  /* @asm 0x5139C */
                continue;                                       /* @asm 0x513A6 */
            occ_38 = (int16_t)func_00627A_op_sz_57((uint16_t)tx_16,
                                                   (uint16_t)ty_1A); /* @asm 0x513AE */
            if (occ_38 == 0x19 || occ_38 == 0x1A) {             /* @asm 0x513B9/0x513BE */
                if (ship_band == 0) continue;                   /* @asm 0x513C3 */
                if ((uint8_t)(func_005DBA_logic_sz_17((uint16_t)tx_16,
                                  (uint16_t)ty_1A) - 1) != 0)   /* @asm 0x513CF/0x513D7 */
                    continue;
            }
            oth_E = (int16_t)(int8_t)func_005DF0_logic_sz_40((uint16_t)tx_16,
                                  (uint16_t)ty_1A);             /* @asm 0x513E1/0x513E9 */
            stack_5A = (int16_t)unit_tile_head(tx_16, ty_1A);   /* @asm 0x513F3 */
            if (colony_like != 0 && ship_band == 0 &&           /* @asm 0x513FB/0x51402 */
                stack_5A >= 0 && oth_E != owner)                /* @asm 0x51408/0x51410 */
                continue;                                       /* @asm 0x51415 */
            if (ship_band != 0 &&                               /* @asm 0x51418 */
                occ_38 != 0x19 && occ_38 != 0x1A) {             /* @asm 0x51421/0x5142A */
                /* ship on open water: both probe arms skip the direction
                 * (naval movement comes from the goto orders set by AI8..AI10) */
                (void)func_005F48_logic_sz_58((uint16_t)tx_16,
                                              (uint16_t)ty_1A); /* @asm 0x51439 */
                continue;                                       /* @asm 0x51445/0x5144C */
            }

            /* ---- base score by role (0x510C4..0x51260) ---- */
            if (type == 5) {                                    /* @asm 0x510C8 wagon */
                score_26 = random_int_4D4(1, 8);                /* @asm 0x510D3 */
                if (abil_82 != 0 &&                             /* @asm 0x510DE */
                    (func_005CFE_map_tile_read_layer_15C((uint16_t)tx_16,
                         (uint16_t)ty_1A) & 0x40) &&            /* @asm 0x510EB/0x510F3 */
                    !(d_4E & 1)) {                              /* @asm 0x510F7 even dirs */
                    score_26 += 2;                              /* @asm 0x510FD */
                } else if (abil_58 != 0 &&                      /* @asm 0x51104 */
                    (func_005D32_map_tile_read_layer_160((uint16_t)tx_16,
                         (uint16_t)ty_1A) & 0x0A)) {            /* @asm 0x51110/0x51118 */
                    score_26 += 1;                              /* @asm 0x511EA shared */
                } else {
                    score_26 -= (int16_t)(3 *
                        (int16_t)DG8(0x2F76 + occ_38 * 16));    /* @asm 0x51125/0x51131 */
                }
            } else if (reassign != 0) {                         /* @asm 0x51138 */
                score_26 = (int16_t)((random_int_4D4(1, 4) +
                    (func_005EE8_logic_sz_28((uint16_t)tx_16,
                         (uint16_t)ty_1A) & 0x0F)) >> 1);       /* @asm 0x51142..0x51161 */
            } else if ((U_OFF(unit_index, U_OWNER) & 0xF0) ||   /* @asm 0x5116C/0x51172 */
                       colony_like != 0) {                      /* @asm 0x5117A */
                score_26 = random_int_4D4(1, 5);                /* @asm 0x51234 */
                if (!(stack_5A >= 0 && oth_E == owner))         /* @asm 0x5123F/0x51249 */
                    score_26 += (int16_t)((int16_t)DG8(0x2F77 + occ_38 * 16) << 2);
                                                                /* @asm 0x51254/0x5125D */
            } else if (DG8(0x523D + (uint16_t)type * 14) & 0x30) {
                                                                /* @asm 0x51196/0x5119D */
                score_26 = random_int_4D4(1, 3);                /* @asm 0x511A8 */
                if (abil_82 != 0 &&                             /* @asm 0x511B3 */
                    (func_005CFE_map_tile_read_layer_15C((uint16_t)tx_16,
                         (uint16_t)ty_1A) & 0x40) &&            /* @asm 0x511C0/0x511C8 */
                    !(d_4E & 1)) {                              /* @asm 0x511CC */
                    score_26 += 1;                              /* @asm 0x511EA */
                } else if (abil_58 != 0 &&                      /* @asm 0x511D2 */
                    (func_005D32_map_tile_read_layer_160((uint16_t)tx_16,
                         (uint16_t)ty_1A) & 0x0A)) {            /* @asm 0x511DE/0x511E6 */
                    score_26 += 1;                              /* @asm 0x511EA */
                } else {
                    score_26 -= (int16_t)DG8(0x2F76 + occ_38 * 16);
                                                                /* @asm 0x511F0/0x51131 */
                }
            } else {                                            /* 0x51200 */
                score_26 = random_int_4D4(1, 3);                /* @asm 0x51204 */
                if (DG8(0x5382) & 1)                            /* @asm 0x5120F */
                    score_26 -= (int16_t)DG8(0x2F77 + occ_38 * 16);
                                                                /* @asm 0x5121C/0x51131 */
                else
                    score_26 += (int16_t)DG8(0x2F77 + occ_38 * 16);
                                                                /* @asm 0x51228/0x5125D */
            }

            /* ---- post adjustments (0x51260..0x512EC) ---- */
            if (occ_38 == 0x1A)                                 /* @asm 0x51260 */
                score_26 -= 0x10;                               /* @asm 0x51266 */
            if (ship_band == 0 &&                               /* @asm 0x5126E/0x51275 */
                DG8(0x5236 + (uint16_t)type * 14) > 1) {        /* @asm 0x51292 */
                int16_t oth2 = (int16_t)func_005F48_logic_sz_58((uint16_t)tx_16,
                                   (uint16_t)ty_1A);            /* @asm 0x5129F */
                if (oth2 >= 0) {                                /* @asm 0x512A9 */
                    if (oth2 == owner) {                        /* @asm 0x512AF */
                        func_0082DC_logic_sz_118((uint16_t)col_own);
                                                                /* @asm 0x512B7 select */
                        if (DG8(DG16(0x8542) + 0x1B) & 0x40)    /* @asm 0x512C3 */
                            score_26 += 0x0A;                   /* @asm 0x512C9 */
                        else if (DG8(DG16(0x8542) + 0x1B) & 4)  /* @asm 0x512D0 */
                            score_26 += 6;                      /* @asm 0x512D6 */
                        else if (DG8(DG16(0x8542) + 0x1B) & 0x10) /* @asm 0x512DC */
                            score_26 += 3;                      /* @asm 0x512E2 */
                    } else {
                        score_26 += 0x10;                       /* @asm 0x512E8 */
                    }
                }
            }

            /* ---- threat analysis (0x512EC..0x51373) ---- */
            if (stack_5A < 0 &&                                 /* @asm 0x512F1 */
                (int16_t)func_006018_logic_sz_33((uint16_t)tx_16,
                    (uint16_t)ty_1A) < 0)                       /* @asm 0x512FD/0x51305 */
                goto ai18_dir_bias;                             /* @asm 0x51309 */
            if (oth_E == owner)                                 /* @asm 0x51310 */
                goto ai18_dir_bias;                             /* @asm 0x51315 */
            if (oth_E >= 4) {                                   /* @asm 0x51318 native */
                if ((int16_t)func_0082A0_logic_sz_18((uint16_t)(oth_E - 4),
                        (uint16_t)owner) < 0x4B &&              /* @asm 0x51329/0x51331 */
                    !(func_007F34_logic_sz_27((uint16_t)owner,
                        (uint16_t)oth_E) & 2))                  /* @asm 0x5133D/0x51345 */
                    continue;                                   /* @asm 0x51347 */
                if (func_007F34_logic_sz_27((uint16_t)owner,
                        (uint16_t)oth_E) & 2)                   /* @asm 0x51350/0x51358 */
                    score_26 <<= 1;                             /* @asm 0x5135C */
                if (DG8(0x94E6 + owner*16 + region) == 0)       /* @asm 0x51369 */
                    continue;                                   /* @asm 0x5136E */
                /* fall to attack */
            } else {                                            /* 0x51450 european */
                if (func_007F34_logic_sz_27((uint16_t)owner,
                        (uint16_t)oth_E) & 0x40) {              /* @asm 0x51454/0x5145C */
                    /* stack_5A may be -1 (owned empty tile): the original then
                     * reads the DGROUP byte below the table (0x312A) -- the
                     * DG8 arm reproduces that address exactly */
                    uint8_t st = (stack_5A >= 0)
                        ? U_OFF(stack_5A, U_TYPE)
                        : DG8((uint16_t)(0x3144 + stack_5A * 0x1C + U_TYPE));
                    if (type != 0x10 && st != 0x10)             /* @asm 0x51464/0x5146F */
                        continue;                               /* @asm 0x51476 */
                }
                if (DG8(0x5382) & 1) {                          /* @asm 0x51479 revolution */
                    int attack_ok = 0;
                    if (oth_E < 4 &&                            /* @asm 0x51480 */
                        DG8(0x543F + (uint16_t)oth_E * 0x34) == 0)
                                                                /* @asm 0x5148A */
                        attack_ok = 1;                          /* @asm 0x5148F */
                    if (oth_E >= 4)                             /* @asm 0x51491 */
                        attack_ok = 1;
                    if (!attack_ok)
                        continue;                               /* @asm 0x51497 */
                }
                /* fall to attack */
            }

            /* ---- attack evaluation (0x5149A..0x516E2) ---- */
            if (DG8(0x5236 + (uint16_t)type * 14) == 0)         /* @asm 0x514B0 immobile */
                continue;                                       /* @asm 0x514B7 */
            fort_7C = 1;                                        /* @asm 0x514BA */
            guard_adj_E8 = 1;                                   /* @asm 0x514C0 */
            {
                int16_t atk_E6 = func_05CA7E_attack_value((uint16_t)unit_index,
                    (uint16_t)tx_16, (uint16_t)ty_1A, 0, 0);    /* @asm 0x514D1 */
                int16_t div_EE = (int16_t)func_0073A8_logic_sz_99(
                    (uint16_t)stack_5A, 2);                     /* @asm 0x514E2 */
                int16_t flag_2 = 0;                             /* @asm 0x51553 */
                int16_t cost;
                if (div_EE < 1)                                 /* @asm 0x514EA */
                    div_EE = 1;                                 /* @asm 0x514EF
                                                                 * (the original re-calls
                                                                 * func_0073A8 on the >=1
                                                                 * arm -- pure, folded) */
                atk_E6 = (int16_t)(
                    (int16_t)((func_0073A8_logic_sz_99((uint16_t)stack_5A, 0) + 1)
                              / div_EE) * atk_E6);              /* @asm 0x5150A..0x5151C */
                cost = (int16_t)DG8(0x5239 + (uint16_t)type * 14);
                if (cost < 1) cost = 1;                         /* @asm 0x51536..0x51546
                                                                 * sbb/not/and clamp */
                atk_E6 = (int16_t)(atk_E6 / cost);              /* @asm 0x5154D */
                if ((int16_t)func_005F48_logic_sz_58((uint16_t)tx_16,
                        (uint16_t)ty_1A) >= 0) {                /* @asm 0x5155E/0x51566 */
                    atk_E6 = (int16_t)(atk_E6 * 3);             /* @asm 0x5156D */
                    flag_2 = 1;                                 /* @asm 0x51575 */
                }
                if ((int16_t)func_005F82_logic_sz_31((uint16_t)tx_16,
                        (uint16_t)ty_1A) >= 0) {                /* @asm 0x51580/0x51588 */
                    atk_E6 <<= 1;                               /* @asm 0x5158C */
                    flag_2 = 1;                                 /* @asm 0x51590 */
                }
                if (type == 0x0B && flag_2 == 0)                /* @asm 0x51599/0x515A0 */
                    atk_E6 = 0;                                 /* @asm 0x515A6 */
                if (owner == (int16_t)DG16(0x53D2) &&           /* @asm 0x515AC/0x515AF */
                    flag_2 == 0 &&                              /* @asm 0x515B5 */
                    col_own_dist != 0)                          /* @asm 0x515BB */
                    atk_E6 >>= 1;                               /* @asm 0x515C1 sar */
                if ((DG8(0x523D + (uint16_t)type * 14) & 0x10) && /* @asm 0x515DB */
                    mission_28 == 4)                            /* @asm 0x515E2 */
                    atk_E6 = (int16_t)(atk_E6 * 3);             /* @asm 0x515E8 */
                /* scout/dragoon task-saturation veto (0x515F3..0x516A2) */
                if ((type == 1 || type == 4) &&                 /* @asm 0x515F7/0x515FE */
                    (int16_t)func_005F48_logic_sz_58((uint16_t)tx_16,
                        (uint16_t)ty_1A) >= 0) {                /* @asm 0x5160E/0x51616 */
                    int16_t tgt_D8 = (int16_t)func_0073A8_logic_sz_99(
                        (uint16_t)stack_5A, 0x0B);              /* @asm 0x51622 */
                    if (tgt_D8 != 0) {                          /* @asm 0x5162E */
                        int16_t sum_6 = 0, k;                   /* @asm 0x51639 */
                        for (k = 0; k < 8; k++) {               /* @asm 0x5163E/0x5168C */
                            int16_t cy = (int16_t)((int8_t)DG8(0x00BE + k) + ty_1A);
                            int16_t cx = (int16_t)((int8_t)DG8(0x00B4 + k) + tx_16);
                            int cur = unit_tile_head(cx, cy);   /* @asm 0x5165F */
                            if (cur >= 0 &&                     /* @asm 0x51667 */
                                (U_OFF(cur, U_OWNER) & 0x0F) == (uint8_t)owner)
                                                                /* @asm 0x5166E/0x51675 */
                                sum_6 += (int16_t)func_0073A8_logic_sz_99(
                                    (uint16_t)cur, 0x0B);       /* @asm 0x5167E/0x51686 */
                        }
                        if (tgt_D8 >= sum_6)                    /* @asm 0x5169C */
                            continue;                           /* @asm 0x516A2 */
                    }
                }
                /* clamp + fold (0x516A5..0x516E2) */
                if (!(atk_E6 < 0x3E8 && atk_E6 >= 0))           /* @asm 0x516A5/0x516AD */
                    atk_E6 = 0x3E8;                             /* @asm 0x516B4 */
                if (atk_E6 < 0x0C &&                            /* @asm 0x516BA */
                    !(type >= 0x0D && type <= 0x12)) {          /* @asm 0x516C5/0x516CC */
                    score_26 -= 0x3E7;                          /* @asm 0x5170A weak land
                                                                 * attack: huge penalty */
                } else {
                    if (atk_E6 < 1)                             /* @asm 0x516D7 */
                        atk_E6 = 1;                             /* @asm 0x516DC */
                    score_26 += (int16_t)(atk_E6 << 2);         /* @asm 0x516DF/0x516E2 */
                }
            }

ai18_dir_bias:                                                  /* 0x516E5 */
            /* turn penalty vs last committed direction (+0x0B) */
            {
                int8_t last = (int8_t)U_OFF(unit_index, 0x0B);  /* @asm 0x516E9 */
                if (last >= 0 && last < 8) {                    /* @asm 0x516EE/0x516F0 */
                    int16_t delta = (int16_t)(last - d_4E);     /* @asm 0x516FC */
                    if (delta <= 0)                             /* @asm 0x51703 */
                        delta = (int16_t)-delta;                /* @asm 0x5171E not/inc */
                    if (delta > 4)                              /* @asm 0x51724 */
                        delta = (int16_t)(8 - delta);           /* @asm 0x51729 neg(x-8) */
                    score_26 -= (int16_t)((delta * delta) << 1); /* @asm 0x51733/0x51737 */
                }
            }

            /* neighbour-stack penalties (0x5173A..0x518BE) */
            {
                int16_t k;
                for (k = 0; k < 8; k++) {                       /* @asm 0x5173A/0x5183D */
                    int16_t cy_3E = (int16_t)((int8_t)DG8(0x00BE + k) + ty_1A);
                                                                /* @asm 0x51846 */
                    int16_t cx_2E = (int16_t)((int8_t)DG8(0x00B4 + k) + tx_16);
                                                                /* @asm 0x51852 */
                    int16_t pw = (int16_t)func_005F04_map_xy_bounds_or_neg1(
                        (uint16_t)cx_2E, (uint16_t)cy_3E);      /* @asm 0x5185E */
                    if (pw >= 0 && pw != owner &&               /* @asm 0x51869/0x51870 */
                        (func_007F34_logic_sz_27((uint16_t)owner,
                             (uint16_t)pw) & 0x60) == 0x20 &&   /* @asm 0x5187E/0x51888 */
                        DG8(0x5236 + (uint16_t)type * 14) == 0) { /* @asm 0x518A5 */
                        /* immobile unit near a tense power: -10 per mobile
                         * unit in that stack */
                        int cur = unit_tile_head(cx_2E, cy_3E); /* @asm 0x518B5 */
                        for (; cur >= 0; cur = unit_chain_next(cur)) {
                                                                /* @asm 0x51768/0x51773 */
                            if (DG8(0x5236 +
                                    (uint16_t)U_OFF(cur, U_TYPE) * 14) != 0)
                                                                /* @asm 0x51759 */
                                score_26 -= 0x0A;               /* @asm 0x51760 */
                        }
                    }
                    if (ship_band != 0) {                       /* @asm 0x51779/0x51783 */
                        int16_t col_90 = (int16_t)func_008D26_op_sz_69(
                            (uint16_t)cx_2E, (uint16_t)cy_3E);  /* @asm 0x51793 */
                        if (col_90 >= 0) {                      /* @asm 0x5179F */
                            uint8_t colpw = DG8(0x5D60 + (uint16_t)col_90 * 0xCA);
                                                                /* @asm 0x517AA */
                            if ((func_007F34_logic_sz_27((uint16_t)owner,
                                     (uint16_t)colpw) & 0x60) == 0x20) {
                                                                /* @asm 0x517BE/0x517C8 */
                                int16_t pen_AE = 0;             /* @asm 0x517B3 */
                                int cur;
                                if (func_00860E_logic_sz_15((uint16_t)col_90, 1))
                                                                /* @asm 0x517D2/0x517DA */
                                    pen_AE = 0x14;              /* @asm 0x517DE */
                                if (func_00860E_logic_sz_15((uint16_t)col_90, 2))
                                                                /* @asm 0x517EA/0x517F2 */
                                    pen_AE = 0x28;              /* @asm 0x517F6 */
                                cur = unit_tile_head(cx_2E, cy_3E); /* @asm 0x51802 */
                                for (; cur >= 0; cur = unit_chain_next(cur)) {
                                                                /* @asm 0x51819/0x51823 */
                                    if (U_OFF(cur, U_TYPE) == 0x0B) /* @asm 0x5180D */
                                        pen_AE += 0x1E;         /* @asm 0x51814 */
                                }
                                pen_AE = (int16_t)(pen_AE *
                                    (int16_t)U_OFF(unit_index, 0x0C)); /* @asm 0x51829/0x5182F */
                                score_26 -= pen_AE;             /* @asm 0x51837 */
                            }
                        }
                    }
                }
            }

            /* hunt-extension probe at distance x4 (0x518BE..0x519F5) */
            if (hunt_EA != 0) {                                 /* @asm 0x518BE */
                int16_t ty2 = (int16_t)(((int8_t)DG8(0x00BE + d_4E) << 2) + map_y);
                                                                /* @asm 0x518CB..0x518D7 */
                int16_t tx2 = (int16_t)(((int8_t)DG8(0x00B4 + d_4E) << 2) + map_x);
                                                                /* @asm 0x518DA..0x518E6 */
                int16_t k;
                if (DG8(0x9FAA + (tx2 >> 2) * 0x12 + (ty2 >> 2)) == 0 &&
                                                                /* @asm 0x518E9..0x518F5 */
                    func_0062B4_op_sz_39((uint16_t)tx2,
                                         (uint16_t)ty2) == 0 && /* @asm 0x51902/0x5190A */
                    func_005BFA_logic_sz_49((uint16_t)tx2,
                                            (uint16_t)ty2) != 0) /* @asm 0x51914/0x5191C */
                    score_26 += 8;                              /* @asm 0x51920 */
                if (ship_band != 0 &&                           /* @asm 0x51924 */
                    d_4E >= 5 && d_4E <= 7 &&                   /* @asm 0x5192A/0x51930 */
                    (int16_t)(DG16(0x853A) >> 1) < map_x)       /* @asm 0x51936/0x5193B */
                    score_26 += 4;                              /* @asm 0x51941 */
                for (k = 0; k < 8; k++) {                       /* @asm 0x51945/0x519EC */
                    int16_t cy = (int16_t)((int8_t)DG8(0x00BE + k) + ty2);
                                                                /* @asm 0x5194D */
                    int16_t cx = (int16_t)((int8_t)DG8(0x00B4 + k) + tx2);
                                                                /* @asm 0x51959 */
                    if (func_005BFA_logic_sz_49((uint16_t)cx,
                                                (uint16_t)cy) == 0) /* @asm 0x51965 */
                        continue;                               /* @asm 0x5196F */
                    if (owner < 4 &&                            /* @asm 0x51971 */
                        !(func_005EE8_logic_sz_28((uint16_t)cx, (uint16_t)cy)
                          & (0x10 << owner))) {                 /* @asm 0x5197E..0x51991 */
                        if (func_0062B4_op_sz_39((uint16_t)cx,
                                                 (uint16_t)cy) == 0 || /* @asm 0x5199B */
                            ship_band != 0)                     /* @asm 0x519A7 */
                            score_26 += 2;                      /* @asm 0x519AD */
                    }
                    if ((int16_t)func_005F04_map_xy_bounds_or_neg1((uint16_t)cx,
                            (uint16_t)cy) >= 0)                 /* @asm 0x519B7/0x519BF */
                        score_26 -= 2;                          /* @asm 0x519C3 */
                    if (reassign != 0)                          /* @asm 0x519C7 */
                        score_26 += (int16_t)DG8(0x2F79 +
                            func_00627A_op_sz_57((uint16_t)cx,
                                (uint16_t)cy) * 16);            /* @asm 0x519D3..0x519E6 */
                }
            }

            /* best tracking (0x519F5..0x51A15) */
            if (score_26 > best_E0) {                           /* @asm 0x519F9 jg */
                best_E0 = score_26;                             /* @asm 0x51A01 */
                dir_choice = d_4E;                              /* @asm 0x51A08 */
                fortify_CC = fort_7C;                           /* @asm 0x51A0E/0x51A11 */
            }
        }
    }
    /* falls into AI19 (0x51A18 trace gate -> 0x51A30) */

    /* ======================= AI19: the COMMIT engine ========================
     * (0x51A28..0x51C68)  Role checks, then the direction commit.  Entered by
     * fall-through from the AI18 loop (the original 0x51A18 trace gate is
     * release-dead).
     * ======================================================================== */
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
 *    0x191F:0x9A4 colonist-enter RESOLVED -> func_02EAEA_op_sz_49 (1.5b)
 *    bld_pop_helper: external body in production_support.c (0x181F:0xC7C)
 *  AI7..AI16 gates + AI11/AI12/AI13/AI14/AI15/AI16 bodies: BYTE_VERIFIED.
 *  AI8 setup (cargo scan + task counters) BYTE_VERIFIED; the AI8 delivery
 *    scoring body (0x4F883..0x50583) and AI9 carrier body (0x505D7..0x5076E)
 *    remain RUNTIME_ONLY stubs.
 *  AI17 hunt/explore + AI18 direction-scoring loop (0x50F36..0x51A18):
 *    BYTE_VERIFIED; external leaf func_05CA7E (0x191F:0xA14 combat
 *    evaluator, page 10) is declared but its 7.3KB body is unported.
 *  AI19 commit engine (0x51A28..0x51C68): BYTE_VERIFIED and LIVE (reached by
 *    fall-through from AI18 with fortify_CC / guard_adj_E8 / dir_choice set).
 *
 *  The SCORING WEIGHTS (per-candidate delta tables, colony budget tables,
 *  relation matrices) are loaded from NAMES.TXT / game data at runtime --
 *  RUNTIME_ONLY, never fabricated here.
 * ============================================================================ */
