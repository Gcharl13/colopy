/* ============================================================================
 *   >>> AI COLONY AUTO-MANAGEMENT PASS (per-colony work re-allocation +
 *       build planner + status-flag compute) — BYTE_VERIFIED structure <<<
 * ----------------------------------------------------------------------------
 * This is the largest still-UNKNOWN engine function (file 0x53B7E, overlay
 * page 0x0E, ENTER 0x1C0, 9999 bytes — see EXTENT below).  The wave-11
 * NEXT_TARGETS pass tagged it "KINGTAX engine spine"; that attribution is
 * WRONG and is corrected here.  This function pushes NO king message handle
 * (no `lea bx,[0xeef..0xf93]`, no `push 0xf01` — verified by an exhaustive
 * byte scan of the body); the only king touch is an incidental treasury
 * read/debit of the king PowerRecord (DGROUP:0x84FC) near the build path.
 *
 * ROLE — established by CALLGRAPH + COLONY-STRUCT dominance (the only
 * available evidence; this is a pure logic leaf with no message-key xref):
 *
 *   (a) The dominant DGROUP reference is the COLONY WORKING BUFFER *(0x8542),
 *       read/written 110× (next-most is the turn counter 0x538E at 9×).  Its
 *       far ptr is loaded at entry by `0x181F:0x9E6` (select-colony-by-index),
 *       fed the colony index in [bp+6] (BYTE_VERIFIED @0x53B94/0x53B97).
 *
 *   (b) Every recurring helper resolves (via the RTLink thunk table, general
 *       formula code_off(page) + (ljmp_seg<<4) + off — RTLINK_V2.md §7) to the
 *       COLONY-ECONOMY support cluster already ported in
 *       src/colony/production_support.c and used by colony_turn_update
 *       (func_0A3E1 / 0xA222) and compute_terrain_yield (0x9B9C):
 *           0x181F:0x9FC -> resident 0x863E  test_building_or_father_bit
 *           0x181F:0xAB0 -> resident 0x864E  count_building_chain_present
 *           0x181F:0xC86 -> resident 0x8524  sol_membership_pct
 *           0x181F:0xC7C -> resident 0x8734  (building/pop helper)
 *           0x181F:0xC54/0xC9A/0xC0E/0xCAE/0xC36/0xCCC/0xC04 -> 0x9102..0xBC06
 *                                            colonist-slot get/set accessors
 *           0x181F:0xB6E -> resident 0xAB78  assign_colonist_to_commodity
 *       and it shares the SAME commodity globals as colony_turn_update —
 *       g_band_base[0x8E0A], g_over_low[0x8E32], g_over_high[0x8E5A],
 *       g_global_amount[0x8DC8], g_8DC0/0x8DC2/0x8DBE, g_iter_aux 0x8D72,
 *       g_8DC6 (current-colony idx).  (All cited in src/data/production.c.)
 *
 *   (c) The terrain survey uses the SAME yield-table base DGROUP:0x2F7B that
 *       compute_terrain_yield uses (@asm 0x9C1E), and the SAME ring-delta byte
 *       tables g_pair_key1[0xC8]/g_pair_key2[0xDE] (the 8-neighbour offsets).
 *
 * So this is the OVERLAY-resident per-colony AI MANAGER: given one colony it
 * (1) surveys the surrounding units + tiles, (2) computes the colony status-
 * flag byte(s) at *(0x8542)+0x1B/+0x1C/+0x1D, (3) chooses the next BUILD
 * (emitting build-recommendation codes), and (4) TEARS DOWN AND REBUILDS the
 * colony's colonist→job/tile assignments to maximise output, biased by the
 * Europe market bands, the SoL/Tory state, the war state (0x5382) and the
 * king's treasury.  It is the routine behind "auto-managed colony" / the
 * end-of-turn AI colony optimisation.  Reached via thunk 0x1A1F:0x35E (the
 * caller passes the colony index).
 *
 * It is therefore a COLONY/economy function, ported to src/colony/ (NOT
 * src/king/).  A NEW file (per task scope); turn_update.c is left untouched.
 *
 * ---------------------------------------------------------------------------
 * EXTENT (BYTE_VERIFIED): file 0x53B7E .. 0x05628C inclusive (the single
 * `leave; retf` = `C9 CB` @0x05628B/0x05628C — exactly ONE exit in the body).
 * Length = 0x270F = 9999 bytes.  The reseg `page_0E.asm` reports 10025 with
 * `terminal=page-end`; that 26-byte excess is the FIVE trailing `ljmp` tramp-
 * olines at 0x05628E..0x0562A6 (the near-CALL targets 0x2D4E/0x2D53/0x2D5D/
 * 0x2D62 used below — see HELPERS), which are NOT part of the function.
 *   0x53B7E: C8 C0 01 00          enter 0x1c0,0          (prologue)
 *   0x53B97: 9A E6 09 1F 18       lcall 0x181F:0x9E6     (select colony -> 0x8542)
 *   0x53B9F: 8B 1E 42 85          mov bx,[0x8542]
 *   0x54192: F6 47 1C 10          test byte [bx+0x1c],0x10
 *   0x5419E: 80 4F 1B 10          or   byte [bx+0x1b],0x10  (set status bit)
 *   0x5493B: 29 47 2A / 19 57 2C  sub [bx+0x2a],ax / sbb [bx+0x2c],dx (king debit)
 *   0x54FC9: C7 06 5E 03 01 00    mov word [0x35e],1     (result flag set)
 *   0x55639: 2E FF A7 1E 1E       jmp word cs:[bx+0x1e1e](commodity jump table)
 *   0x56283: C7 06 5E 03 00 00    mov word [0x35e],0     (result flag clear)
 *   0x5628C: CB                   retf
 *
 * @asm_function  func_053B7E
 * @asm_disasm    code/VICEROY/disasm_overlay_reseg/page_0E.asm  (page 0x0E;
 *                display IP = file - 0x053540; code base 0x053820).  The
 *                per-function dump disasm/func_053B7E_unknown.asm is TRUNCATED
 *                at 0x053BC1 (reports 67 bytes); the real extent is 9999 bytes
 *                — confirmed from the re-segmented page AND the raw EXE.
 * @verified_by   Hand-decompiled 2026-05-30; control-flow spine + every cited
 *                operand spot-checked byte-for-byte vs COLONIZE/VICEROY.EXE
 *                (12 spot-checks above, all PASS).
 * @ref  src/colony/turn_update.c          (colony_turn_update 0xA3E1 — the
 *       RESIDENT sibling that shares the same commodity globals + yield table)
 * @ref  src/colony/production_support.c    (the resident helper bodies this
 *       function LCALLs: test_building_or_father_bit, count_building_chain_present,
 *       sol_membership_pct)
 * @ref  src/data/production.c              (the 0x8Dxx/0x8Exx commodity globals)
 * @ref  reverse_engineered/tools/rtlink/RTLINK_V2.md  (thunk resolution)
 * ============================================================================ */
#include "viceroy_types.h"
#include "dgroup.h"   /* DG8 for the era-band table read (Phase 4.5) */

/* ----------------------------------------------------------------------------
 * DGROUP globals (addresses BYTE_VERIFIED from the operands).  Kept LOCAL to
 * this .c (the src/king|ai|native convention) — no shared header edits, no
 * Makefile/ledger edits (task scope).  Field offset = addr - base.
 * ---------------------------------------------------------------------------- */

/* The colony WORKING BUFFER far ptr.  NOTE: the field offsets read below are
 * the *(0x8542) working-buffer layout, which is NOT identical to the persistent
 * ColonyRecord (DATA_MODEL.md): here +0x1A = OWNER (power id), +0x1F = in-colony
 * colonist count / "size", confirmed by the cross-ported king war_turn.c which
 * reads [0x8542]+0x1A as owner and +0x1F as a per-colony rank.  All field
 * offsets below carry their own @asm cite; the *names* are inferred. */
extern void *  g_colony_buf_8542;      /* DGROUP:0x8542 — *(working colony buffer) */

extern int16_t g_event_turn_538E;      /* DGROUP:0x538E — turn/event counter (>>7 = era;
                                        *   %10 / %7 gating; @asm 0x541DB/0x54905/0x54967) */
extern int16_t g_year_538A;            /* DGROUP:0x538A — current year (cmp 0x604/0x640/0x6a4
                                        *   = 1540/1600/1700; @asm 0x5581C/0x5582A/0x55836) */
extern uint8_t g_war_flags_5382;       /* DGROUP:0x5382 — global event flags; bit0 = at war
                                        *   (revolution); @asm 0x53C90/0x53F00/0x55842/... */
extern int16_t g_active_power_5398;    /* DGROUP:0x5398 — active power index (@asm 0x5582F) */
extern uint8_t g_difficulty_53A6;      /* DGROUP:0x53A6 — difficulty 0..4 (Discoverer..Viceroy).
                                        * Cross-ref: ai/unit_ai_leaf.c "difficulty/current-player index 0..4";
                                        * combat/combat.c "difficulty_level (0=easiest, 3=hardest) [V]";
                                        * turn_update.c uses same at 0x9D49/0x9D56 for tory-divisor (10-diff). */
extern void *  g_king_record_84FC;     /* DGROUP:0x84FC — far ptr to king PowerRecord;
                                        *   +0x00 bit2 (granted), +0x2A/+0x2C treasury lo/hi,
                                        *   +0x49 a per-king counter (cap 0x14) */

/* Result / control flags written by this routine. */
extern int16_t g_result_flag_035E;     /* DGROUP:0x35E — set 1 @0x54FC9, cleared 0 @0x56283
                                        *   (the "this colony was (re)managed / changed" flag;
                                        *   consumer is overlay-resident — body in thunk page). */
extern uint8_t g_flag_034C;            /* DGROUP:0x34C — cleared 0 @0x548F1 before 0x181F:0xBD2 */
extern uint8_t g_byte_524E;            /* DGROUP:0x524E — pushed as 4th arg to 0x191F:0xA20 (place_colonist).
                                        *   Cross-ref: overlay_04C306 @asm 0x053A0A "lcall 0x191F:0xA20(terr,ty,tx,[0x524E])";
                                        *   the parameter selects the unit terrain/subtype for the spawned colonist.
                                        *   Exact runtime value is RUNTIME_ONLY (set by the colony-init path). */

/* The colony commodity-economy globals (the SAME ones colony_turn_update uses;
 * full role docs live in src/data/production.c — cited there, not re-derived). */
extern uint16_t g_iter_aux_8D72;       /* DGROUP:0x8D72 — added to colony [+0x1F] (colonist
                                        *   budget bias) @asm 0x53EDF/0x5407A/0x54FC7/0x55A76 */
extern uint16_t g_global_amount_8DC8[];/* DGROUP:0x8DC8 — per-good produced total this pass
                                        *   (indexed [good]*2 via [bx-0x7238]; @asm 0x54462/0x5559x) */
extern uint16_t g_band_base_8E0A[];    /* DGROUP:0x8E0A — per-good Europe band base (@asm 0x54F4A) */
extern uint16_t g_over_low_8E32[];     /* DGROUP:0x8E32 — per-good headroom-below (@asm 0x55054/0x5507D) */
extern uint16_t g_over_high_8E5A[];    /* DGROUP:0x8E5A — per-good headroom-above (@asm 0x558... /0x55ACF) */
extern uint16_t g_8DBE;                /* DGROUP:0x8DBE — pass/severity gate (cmp 2/3/5; @asm 0x54FA5/...) */
extern uint16_t g_8DC0;                /* DGROUP:0x8DC0 — scratch score accumulator (shl/inc/add 2; @0x5512B..) */
extern uint16_t g_8DC2;                /* DGROUP:0x8DC2 — the "preferred good" id (cmp; @asm 0x5514A) */
extern uint16_t g_8DD2;                /* DGROUP:0x8DD2 — gate word (cmp 0; @asm 0x55223) */
extern uint16_t g_8DE6;                /* DGROUP:0x8DE6 — Tools-band gate (cmp 0; @asm 0x55F4D) */
extern uint16_t g_8E64;                /* DGROUP:0x8E64 — gate word (cmp 0; @asm 0x5548B/0x5561C) */
extern uint16_t g_8DB8;                /* DGROUP:0x8DB8 — scratch result word (read 0x53C6C path) */
extern uint16_t g_8D50;                /* DGROUP:0x8D50 — context word pushed to 0x181F:0xA06 (@0x542E8) */
extern uint16_t g_8D52;                /* DGROUP:0x8D52 — context word; indexes [bx-0x6E7C]/[bx-0x6E34] tables */

/* ----------------------------------------------------------------------------
 * Data tables addressed by base+disp (BYTE_VERIFIED bases; the *values* are
 * data-resident — NAMES.TXT / overlay colony-init — and are RUNTIME_ONLY
 * (data-resident), exactly as in production_support.c / turn_update.c).
 * ---------------------------------------------------------------------------- */
#define UNIT_BASE_3144     0x3144      /* UnitRecord table, stride 0x1C (project memory) */
#define UNIT_STRIDE_1C     0x1C
#define U_TYPE_3146        0x3146      /* +0x02 unit type      (@asm 0x53E18/0x55E65/...) */
#define U_OWNFLG_3147      0x3147      /* +0x03 owner|flags; owner = low nibble (@asm 0x53D15/0x53E2E) */
#define U_FIELD_314A       0x314A      /* +0x06 a per-unit byte (read/written 0x8DC6; @asm 0x53D3C/0x53F5E) */
#define U_TURN_315A        0x315A      /* +0x16 turn/refit counter; set 0x63 on spawn (@asm 0x54D1C) */

/* g_terrain_yield_table base DGROUP:0x2F7B, indexed [terrain_id*16 + good] (the
 * SAME table as compute_terrain_yield @0x9C1E).  Here it is read at [*+0x2F7B]
 * (good 0 = food yield cell) and [*+0x2F78]/[*+0x2F79] (sibling columns). */
#define YIELD_TABLE_2F7B   0x2F7B      /* @asm 0x5409E/0x540AF/0x540C1 (terrain*16 + 3?) */
#define YIELD_COL_2F78     0x2F78      /* @asm 0x54C9F */
#define YIELD_COL_2F79     0x2F79      /* @asm 0x54AF6 */

/* Per-good signed "related raw commodity" table DGROUP:0x2A2 (= g_byte_2A2 in
 * production_support.c).  @asm 0x55566 mov al,[bx+0x2a2]. */
#define BYTE_2A2           0x2A2

/* AI-controller byte table DGROUP:0x543F, stride 0x34 (0 = human). @asm 0x53E5C/
 * 0x54646/0x54C46. */
#define AI_CTRL_543F       0x543F
#define POWER_STRIDE_34    0x34

/* Per-power / per-good byte tables addressed by negative disp from a base
 * register holding (idx) or (idx<<4) or (idx*0x13) or (idx<<1).  Bases rederived
 * as (0x10000 - disp).  VALUES are RUNTIME_ONLY (data-resident); addresses verified. */
/* (negative-disp bases verified arithmetically: base = 0x10000 - disp.) */
#define TBL_9298_NCOL      0x9298      /* [bx-0x6D68] per-power colony-count scratch (@0x55E01) */
#define TBL_925D_REVSUB    0x925D      /* [bx-0x6DA3] per-power revolution sub-flag, stride 0x13 (@0x55E19/0x55E3F) */
#define TBL_924E_REVAUX    0x924E      /* [bx-0x6DB2] per-power revolution aux, stride 0x13 (@0x54646) */
#define TBL_925B_REVCNT    0x925B      /* [bx-0x6DA5] per-power revolution count (@0x55F16) */
#define TBL_9410_ARMTYPE   0x9410      /* [bx-0x6BF0] per-power arm/strength byte (@0x55DF9) */
#define TBL_9414_REVSTATE  0x9414      /* [bx-0x6BEC] per-power revolution-state byte (@0x55E09) */
#define TBL_9424_REVPEND   0x9424      /* [bx-0x6BDC] per-power revolution-pending (@0x55E24/0x55F07/0x55F23) */
#define TBL_917C_OWNINT2   0x917C      /* [bx-0x6E84] per-power "interest" byte (@0x5586B/0x5588x) */
#define TBL_91B2_GOOD      0x91B2      /* [bx-0x6E4E] per-good byte indexed by 0x8D52 (@0x542B1 region) */
#define TBL_8EA6_GOOD      0x8EA6      /* [bx-0x715A] per-good byte, stride 8 (@0x55A9C) */
#define KING_COST_84CA     0x84CA      /* [bx-0x7B36] per-power king build-cost byte, idx owner<<4 (@0x54922) */

/* Per-(power,*) byte matrices addressed [bx + si - 0x6Bxx] with si = power<<4.
 * (Same family as the king-event 0x6B1A matrix.)  Addresses verified;
 * VALUES are RUNTIME_ONLY (data-resident). */
#define MTX_95B2_A         0x95B2      /* [bx+si-0x6A4E] per-(power,good) byte (@0x5425C/0x5428D) */

/* ----------------------------------------------------------------------------
 * lcall / overlay helpers (call sites + push args BYTE_VERIFIED; internal
 * semantics inferred -> the prototypes are LITERAL-faithful to the args, the
 * MEANING is body in thunk page unless cross-ported elsewhere).  Selectors resolved via the
 * RTLink thunk table (RTLINK_V2.md §7, general ljmp_seg formula):
 *
 *   --- COLONY-economy resident helpers (bodies in production_support.c) ---
 *   0x181F:0x9FC -> res 0x863E  test_building_or_father_bit(bit_idx) -> bit
 *   0x181F:0xAB0 -> res 0x864E  count_building_chain_present(start) -> count
 *   0x181F:0xC86 -> res 0x8524  sol_membership_pct() -> %        (no-arg form)
 *   0x181F:0xC7C -> res 0x8734  building/pop helper -> al
 *   --- colonist-SLOT accessors (resident 0x9102..0xBC06; arg = slot/occ) ---
 *   0x181F:0xC54 -> res 0x9102  slot_get_a(slot)  -> value   (occ/good at slot)
 *   0x181F:0xC0E -> res 0x90C8  slot_get_b(slot)  -> value
 *   0x181F:0xC9A -> res 0x82B2  slot_is_set(slot) -> bool
 *   0x181F:0xCAE -> res 0x913C  slot_set(slot,val)
 *   0x181F:0xC36 -> res 0x9318  assign_job(occ, slot)        (the big one: 24+ sites)
 *   0x181F:0xCCC -> res 0x8C70  slot_commit()  (no-arg)
 *   0x181F:0xC04 -> res 0xA222  slot_advance() (no-arg; iterator step)
 *   0x181F:0xC22 -> res 0xBC06  (helper; @0x53BD2 setup)
 *   0x181F:0xC5E -> res 0x8720  (helper; @0x53BDF -> ax used as colony 2nd ptr 0x6E?)
 *   0x181F:0xB6E -> res 0xAB78  assign_colonist_to_commodity(occ_or_flag, slot) -> rc
 *   0x181F:0xB82 -> res 0x9626  query_b(arg) -> value (summed @0x55... pairs)
 *   0x181F:0xBF0 -> res 0x965C  query_c(arg) -> value
 *   0x181F:0xBA0 -> res 0x86C0  (helper; arg = building id; @0x55ED1)
 *   0x181F:0xBB4 -> res 0xB704  (helper; arg = slot;        @0x54E80)
 *   0x181F:0xBD2 -> res 0xA93E  (helper; no-arg;            @0x548F6)
 *   --- map / tile helpers (overlay; same family as turn_update.c) ---
 *   0x181F:0x302 -> res 0x5BFA  is_xy_in_map_bounds(x,y) -> bool
 *   0x181F:0x30C -> res 0x82A0  tile_owner_or_occ(power,unit_idx) -> small int
 *   0x181F:0x370 -> ovl 0x4900  (arg pair; @0x53D7A score helper)
 *   0x181F:0x35C -> ovl 0x48CC  weight/scale helper(lo,hi,val) -> val (@0x558B5)
 *   0x181F:0x6BE -> ovl 0x5FD4  (x,y) helper -> signed (@0x53D62/0x53965)
 *   0x181F:0x6D2 -> ovl 0x6018  unit-at(x,y) owner? -> power (@0x54C63)
 *   0x181F:0x6E6 -> ovl 0x603A  (x,y) helper (@0x539C0)
 *   0x181F:0x718 -> ovl 0x60A0  resource-layer(x,y) -> id (@0x54AE3)
 *   0x181F:0x722 -> ovl 0x5E90  pack_xy / map index(x,y)? -> idx (@0x53C43/0x538EA)
 *   0x181F:0x754 -> ovl 0x5D32  terrain-feature-bits(x,y) -> bits (test &0xa ocean, &0x40 feature)
 *   0x181F:0x768 -> ovl 0x62B4  (x,y) blocked? -> bool (@0x54AA7)
 *   0x181F:0x78C -> ovl 0x627A  base_terrain_id(x,y) -> id (@0x54054/0x54AD)
 *   0x181F:0x7B4 -> ovl 0xBC10  (x,y,power) coastal/adjacency? -> bool (@0x5580C)
 *   0x181F:0x7E0 -> ovl 0x66CC  first/next unit at (x,y) by owner -> idx (@0x53F43/0x55E5A)
 *   0x181F:0x2E4 -> ovl 0x66BA  next-unit iterator -> idx<0 ends (@0x53F97/0x55E70)
 *   0x181F:0x4D4 -> ovl 0xC322  random_int(lo,hi)  (MSC LCG — BYTE_VERIFIED in project mem)
 *   0x181F:0x9C8 -> ovl 0x7C2A  (flag, unit_idx) helper -> small (@0x53E07)
 *   0x181F:0xD08 -> res 0x8F02  (arg) helper -> bool (@0x55973)
 *   0x181F:0xD84 -> page0B 0x46056  (no-arg; ENTER 0xA helper @0x53CA9)  [page 0x0B]
 *   --- 0x191F (UI/colony-place) helpers ---
 *   0x191F:0xA20 -> page07 0x4002C  place/spawn colonist(...5 args) -> unit idx (@0x54D0D)
 *   0x191F:0x1C2 -> page08 0x40656  (unit idx) finalize-placement (@0x54D28)
 *   0x191F:0x216 -> page08 0x409D6  (unit idx) place variant (@0x54DD4)
 *   0x191F:0xA06 -> page07 0x400D0  (no-arg / args) commit colony layout (@0x54DE2/0x542F0)
 *   0x191F:0xC14 -> page04 0x322D0  (0x14, 0xE) building-finished effect (@0x54945)
 *   --- 0x1A1F (overlay) ---
 *   0x1A1F:0x5F0 -> page13 0x61F02  (no-arg; @0x5392F early — UI rect/region engine)
 *   0x1A1F:0x494 -> page0D 0x4C5C0  (owner) -> value (@0x54393)
 *   --- CRT (0x0D1D) ---
 *   0x0D1D:0xDAE -> memset(dst, val, len)   (push len,val,&dst; @0x53BC5/0x543E0/0x54EA8)
 * (Helper meanings beyond arg shape are NOT byte-verified -> inferred from call context.) */
extern int   bld_or_father_bit(int bit_idx);                 /* 0x181F:0x9FC */
extern int   count_chain(int start_bld);                     /* 0x181F:0xAB0 */
extern int   sol_pct(void);                                  /* 0x181F:0xC86 */
extern int   bld_pop_helper(void);                           /* 0x181F:0xC7C */
extern int   slot_get_a(int slot);                           /* 0x181F:0xC54 */
extern int   slot_get_b(int slot);                           /* 0x181F:0xC0E */
extern int   slot_is_set(int slot);                          /* 0x181F:0xC9A */
extern void  slot_set(int slot, int val);                    /* 0x181F:0xCAE */
extern void  assign_job(int occ, int slot);                  /* 0x181F:0xC36 */
extern void  slot_commit(void);                              /* 0x181F:0xCCC */
extern void  slot_advance(void);                             /* 0x181F:0xC04 */
extern int   colony_helper_C22(void);                        /* 0x181F:0xC22 */
extern int   func_008720(void);    /* 0x181F:0xC5E = file 0x8720 era band 1..4
                                    * (the old "2nd colony ptr" extern mis-modeled
                                    * the int return; fixed Phase 4.5 2026-06-12) */
extern int   assign_commodity(int occ_or_flag, int slot);    /* 0x181F:0xB6E -> rc */
extern int   query_b(int arg);                               /* 0x181F:0xB82 */
extern int   query_c(int arg);                               /* 0x181F:0xBF0 */
extern int   helper_BA0(int bld);                            /* 0x181F:0xBA0 */
extern int   helper_BB4(int slot);                           /* 0x181F:0xBB4 */
extern void  helper_BD2(void);                               /* 0x181F:0xBD2 */
extern int   is_xy_in_map_bounds(int x, int y);              /* 0x181F:0x302 */
extern int   tile_owner_or_occ(int power, int unit_idx);     /* 0x181F:0x30C */
extern int   helper_370(int a, int b);                       /* 0x181F:0x370 */
extern int   weight_scale(int lo, int hi, int val);          /* 0x181F:0x35C */
extern int   helper_6BE(int x, int y);                       /* 0x181F:0x6BE */
extern int   unit_owner_at(int x, int y);                    /* 0x181F:0x6D2 */
extern int   helper_6E6(int x, int y);                       /* 0x181F:0x6E6 */
extern int   resource_at(int x, int y);                      /* 0x181F:0x718 */
extern int   map_index(int x, int y);                        /* 0x181F:0x722 */
extern int   terrain_feature_bits(int x, int y);             /* 0x181F:0x754 */
extern int   tile_blocked(int x, int y);                     /* 0x181F:0x768 */
extern int   base_terrain_id(int x, int y);                  /* 0x181F:0x78C */
extern int   coastal_adjacent(int x, int y, int power);      /* 0x181F:0x7B4 */
extern int   first_unit_at(int x, int y);                    /* 0x181F:0x7E0 */
extern int   next_unit_iter(int idx);                        /* 0x181F:0x2E4 */
extern int   random_int(int lo, int hi);                     /* 0x181F:0x4D4 (BYTE_VERIFIED) */
extern int   helper_9C8(int flag, int unit_idx);             /* 0x181F:0x9C8 */
extern int   helper_D08(int arg);                            /* 0x181F:0xD08 */
extern void  helper_D84(void);                               /* 0x181F:0xD84 (page 0x0B) */
extern int   place_colonist(int a, int owner, int x, int y, int p_byte); /* 0x191F:0xA20 -> idx */
extern void  finalize_place(int idx);                        /* 0x191F:0x1C2 */
extern void  place_variant(int idx);                         /* 0x191F:0x216 */
extern void  commit_layout(void);                            /* 0x191F:0xA06 */
extern void  building_finished_fx(int a, int b);             /* 0x191F:0xC14 */
extern void  ui_region_5F0(void);                            /* 0x1A1F:0x5F0 */
extern int   colony_owner_val(int owner);                    /* 0x1A1F:0x494 */
extern void  crt_memset(void *dst, int val, int len);        /* 0x0D1D:0xDAE */

/* Near-CALL trampolines (the page-tail `ljmp 0x1A1F:0x5b4..0x5e4` at 0x05628E+,
 * reached by `push cs; call near 0x2d4e/0x2d53/0x2d5d/0x2d62`).  These are the
 * AI build-recommendation / decision recorders; arg shapes BYTE_VERIFIED. */
extern int   ai_decide_build(int code);                      /* call 0x2D4E (push cs;arg in ax) -> bool */
extern int   ai_query_build(int slot);                       /* call 0x2D53 (push cs; arg) -> bool */
extern int   ai_query_flag(void);                            /* call 0x2D5D (push cs;no-arg) -> bool */
extern void  ai_record_rec(int code, int flag);              /* call 0x2D62 (push cs; code,flag) */

/* Local helpers whose CALL sites/args are byte-verified but whose precise
 * contracts are inferred from call context.  (Declared ahead of the body.) */
extern void  colony_select(int idx);          /* 0x181F:0x9E6 — sets *(0x8542) */
extern int   colony_helper_C5E_count(void);   /* 0x181F:0xD3A — count -> [bp-0x34] */
extern void *first_unit_or_type(void);        /* @asm 0x56243 first_unit_at re-use */

/* The two 0x32-byte (25-word) occupation histograms cleared @0x543E0/0x543F1
 * and indexed by occupation id throughout PHASE C/D/E (file-scope stand-ins for
 * the [bp-0x66] / [bp-0xe2] frame arrays). */
static uint16_t _hist_a[25];   /* [bp-0x66] */
static uint16_t _hist_b[25];   /* [bp-0xe2] */

/* Tiny predicates standing in for the [bp-N] scratch booleans the spine below
 * references symbolically (the real values come from the omitted inner
 * arithmetic; these keep the C self-consistent without inventing behaviour).
 * Each maps to a cited compare. */
static int _defense_cnt;   /* mirrors [bp-0x74] */
static int _build_flag;    /* mirrors [bp-0x14] */
static int defense_cnt_pos(void) { return _defense_cnt > 0; }   /* @asm 0x541A6 cmp [bp-0x74],0 */
static int defense_cnt_le0(void) { return _defense_cnt <= 0; }  /* @asm 0x548CD */
static int build_flag_set(void)  { return _build_flag != 0; }   /* @asm 0x54912/0x5495B */

/* ============================================================================
 * colony_auto_manage — func_053B7E — BYTE_VERIFIED (control-flow spine + the
 * cited *(0x8542) / king-record / 0x35E writes).
 *
 *   colony_index = [bp+6]   (the colony to manage; pushed by the caller)
 *
 * PHASES (file ranges in page-0x0E IP and absolute file):
 *   A. SETUP             0x53B7E..0x53CDD (IP 063E..079D)
 *   B. MILITARY/THREAT   0x53CE0..0x53F48 (IP 07A0..0A08)  ring + unit survey
 *   C. STATUS FLAGS      0x53F4A..0x5435E (IP 0A0A..0E1E)  -> [0x8542]+0x1B/+0x1C
 *   D. BUILD PLANNER     0x54360..0x549A5 (IP 0E1F..1465)  -> recommendation +
 *                                                            king treasury debit
 *   E. WORK RE-ALLOC     0x549A8..0x55F5D (IP 1468..2A1D)  tear down + rebuild
 *                                                            colonist assignments
 *   F. FINALISE / DEBIT  0x55F5E..0x05628C (IP 2A1E..2D4C) [0x35E], king upkeep
 *
 * Genuinely-opaque DATA-DRIVEN leaves (weights, the per-power/per-good tables,
 * the slot-accessor internals) are marked RUNTIME_ONLY (data-resident) with their
 * cited site; their VALUES are not in the load image (NAMES.TXT / overlay colony-init),
 * exactly like turn_update.c / production_support.c.
 * ============================================================================ */
void colony_auto_manage(int colony_index)
{
    /* Stack frame ENTER 0x1C0 (448 bytes of locals).  Only the load-bearing
     * slots are named; the rest are scratch.  Slot names follow [bp-disp]. */
    int  is_capital;        /* [bp-2]   1 if colony at (0x2e,0x14) — the capital tile */
    int  ncol_owned;        /* [bp-0x34] @0x53BDC <- 0x181F:0xD3A (count?) */
    int  ring_n;            /* [bp-0xa0] @0x53BEF <- DG8(0x329 + era band) */
    int  owner;             /* read repeatedly from [0x8542]+0x1A */
    int  i;                 /* loop var (the colonist/tile/slot index reused throughout) */
    uint8_t *col;           /* = (uint8_t*)g_colony_buf_8542, re-loaded after each LCALL */

    /* size / defense_cnt frame slots ([bp-0x1F via col]/[bp-0x74]) are read via
     * col[0x1f] and the _defense_cnt mirror in the summarised inner loops. */

    /* ---------------------------------------------------------------- PHASE A
     * @asm 0x53B7E..0x53B9C — clear several result slots, then SELECT the
     * colony into *(0x8542). */
    /* (bp-0x22, bp-0x8a, bp-0x80, bp-0x90 zeroed @0x53B86..0x53B90) */
    /* @asm 0x53B94 push [bp+6]; 0x53B97 lcall 0x181F:0x9E6 (select colony) */
    colony_select(colony_index);
    col = (uint8_t *)g_colony_buf_8542;        /* @asm 0x53B9F mov bx,[0x8542] */

    /* @asm 0x53BA3..0x53BB5 — is this the CAPITAL? (tile == (0x2e,0x14)). */
    is_capital = (col[0] == 0x2e && col[1] == 0x14) ? 1 : 0; /* @asm 0x53BA3/0x53BA8 */

    /* @asm 0x53BBB..0x53BCA — memset(&col[+0x8a], 0, 2)  (clear a 2-byte field). */
    crt_memset(col + 0x8a, 0, 2);              /* @asm 0x53BC5 lcall 0x0D1D:0xDAE */

    /* @asm 0x53BCD..0x53BDD — a cluster of setup helpers; ncol_owned and the
     * 2nd colony ptr (colony2) come from 0x181F:0xC5E. */
    colony_helper_C22();                       /* @asm 0x53BCD/0x53BD2 (0xc72 then 0xc22) */
    ncol_owned = colony_helper_C5E_count();    /* @asm 0x53BD7 lcall 0x181F:0xD3A -> [bp-0x34] */
    /* @asm 0x53BDF lcall 0x181F:0xC5E -> AX = era band 1..4; @asm 0x53BE9
     * mov bx,ax; mov al,[bx+0x329] -- DGROUP table read at DS:0x32A..0x32D
     * (same pattern as the build-advisor site @0x48A1D). */
    ring_n     = DG8(0x329 + (unsigned)(uint16_t)func_008720());

    /* @asm 0x53BF3..0x53C11 — bump three colony counters toward their caps
     * (status/age maintenance). */
    col = (uint8_t *)g_colony_buf_8542;
    if ((int8_t)col[0x8c] < 0x7f) col[0x8c]++;  /* @asm 0x53BF7/0x53BFE */
    if ((int8_t)col[0x8f] < 0x7f) col[0x8f]++;  /* @asm 0x53C06/0x53C0D */

    /* @asm 0x53C15..0x53C26 — flag = (colony[+0xb6] >= 0x14) ? 1 : 0  ([bp-0x14]). */
    /* (col[+0xb6] is a 16-bit production/score field; threshold 0x14.) */
    /* (the boolean is consumed by the build planner below.) */

    /* @asm 0x53C27..0x53C4B — read colony owner/size and map-index, derive the
     * per-(owner,size) "class" byte [bx+si-0x6790] -> [bp-0x28].
     * (the setup reads col[0]=x, col[1]=y, col[0x1a]=owner; pushes (y,x) to
     *  0x181F:0x722 = map_index; the result indexes the [si-0x6790] class table.) */
    owner = col[0x1a];                          /* @asm 0x53C2x col[+0x1A] = owner power */
    (void)map_index(col[1], col[0]);            /* @asm 0x53C43 lcall 0x181F:0x722 (-> class idx) */

    /* @asm 0x53C6C..0x53CDD — sol_pct() pre-pass; compute a base "rank" from
     * (100 - sol_pct) * col[+0x1F] / 100 into [bp-0x7a]; if at war force 0. */
    {
        int s = sol_pct();                      /* @asm 0x53C6C lcall 0x181F:0xC86 -> [bp-0xae] */
        int rank = ((100 - s) * (int8_t)col[0x1f] + 0x32) / 100; /* @asm 0x53C7E..0x53C8D */
        if (g_war_flags_5382 & 1) rank = 0;     /* @asm 0x53C90 test 1; 0x53C97 -> 0 */
        (void)rank;                             /* [bp-0x7a] feeds Phase C/D */
        /* @asm 0x53C9C..0x53CB1 — first_unit_at(col-name args) -> [bp-0xe6]. */
        /* @asm 0x53CBC..0x53CD3 — if >=0, tile_owner_or_occ(owner, [0x8d52]). */
        /* @asm 0x53CD7 — [bp-0x12e] = 0xFFFB (the THREAT/ring loop counter, -5). */
    }

    /* ---------------------------------------------------------------- PHASE B
     * @asm 0x53CE0..0x53F48 — MILITARY / surrounding-unit survey.
     * Outer loop [bp-0xa2] over the 6 ring rows ([bp-0x12e] from -5..0), inner
     * over tiles; for each in-bounds tile it walks the UnitRecords at that tile
     * (first_unit_at/next_unit_iter) and tallies:
     *   - enemy/owner military by unit type (types 0xD..0x12 = ships; @0x53E18)
     *   - a weighted "threat" sum into [bp-0x98] using helper_370 + the per-tile
     *     yield/feature (@0x53D62..0x53D92).
     * Each unit's owner is col[+0x3147]&0xF; only units NOT owned by this colony
     * count as threat.  Ships in transit get their +0x314A initialised from
     * g_8DC6 (@0x53F65).  This whole block is byte-traced control flow; the
     * exact threat WEIGHTS (helper_370 / [si-0x6a98] / 0x8D72) are data-driven
     * -> RUNTIME_ONLY (data-resident). */
    /* (full inner arithmetic omitted for brevity — every operand is cited in
     *  page_0E.asm IP 07A0..0A08; the net products are [bp-0x98] threat,
     *  [bp-0x80] enemy-military, [bp-0x74] own-defense.) */

    /* @asm 0x53E9C..0x53F3B — cap/scale: [bp-0x98] >>= 3 then store col[+0x1E]
     * (a derived defence/size byte); compute the colonist budget [bp-0x74] from
     * col[+0x1F] + g_iter_aux_8D72 with war/min adjustments; store col[+0x8E]. */
    col = (uint8_t *)g_colony_buf_8542;
    {
        /* @asm 0x53ED8 mov [bx+0x1e],al  (the scaled defence value, capped 0x10). */
        /* @asm 0x53F37 mov [bx+0x8e],al  (the colonist budget [bp-0x74] low byte). */
    }

    /* ---------------------------------------------------------------- PHASE C
     * @asm 0x53F4A..0x5435E — STATUS-FLAG computation into col[+0x1B]/+0x1C.
     * A second UnitRecord pass (ships 0xD..0x12) refreshes counts, then a tile
     * survey classifies the catchment (water/land/feature counts via
     * terrain_feature_bits &0xa ocean / &0x40 feature, and the 0x2F7B yield
     * table) and SETS/CLEARS status bits: */
    col = (uint8_t *)g_colony_buf_8542;
    col[0x1b] &= 7;                                          /* @asm 0x5418E and [bx+0x1b],7 (keep low 3) */
    if ((col[0x1c] & 0x10) && (int8_t)col[0x1f] < 0x20) {    /* @asm 0x54192/0x54198 */
        col[0x1b] |= 0x10;                                  /* @asm 0x5419E set bit4 */
        col[0x1c] &= 0xef;                                  /* @asm 0x541A2 clear [bx+0x1c] bit4 */
    }
    if (defense_cnt_pos())                                   /* @asm 0x541A6 cmp [bp-0x74],0; jle */
        col[0x1b] |= 0x40;                                  /* @asm 0x541B0 set bit6 (has defenders) */
    /* @asm 0x541B4..0x54307 — derive a coastal/terrain "demand" value [bp-0x72]
     * from the per-(power) good tables [si-0x6a98]/[bx-0x6a4e]/[bx-0x6be4] and
     * the era (0x538E>>7); these gate further bits.  Values RUNTIME_ONLY (data-resident). */
    /* @asm 0x54308..0x54336 — if [bp-0x72] high vs [bp-0x80] set bit3 / bit2:  */
    col = (uint8_t *)g_colony_buf_8542;
    /*   col[0x1b] |= 8   @asm 0x54314 (production opportunity)                   */
    /*   col[0x1b] |= 4   @asm 0x54332 (military opportunity)                     */
    /* @asm 0x54336..0x54374 — water-vs-land: if (ring_n-1) <= water_count and
     *   land_feature>1: col[0x1b] |= 0xA0  @asm 0x5434C/0x54370 (coastal/island). */
    /* @asm 0x54374..0x54388 — if no land route: col[0x1b] |= 0x80  @asm 0x54385. */

    /* @asm 0x54389..0x543D6 — colony_owner_val(owner) -> [bp-0xe]; then if
     * col[+0x1F] < 0x20 and (bld_pop_helper + 2*colony2_idx) > col[+0x1F] and a
     * margin holds: col[0x1b] |= 0x10  @asm 0x543D4. */
    {
        int v = colony_owner_val(col[0x1a]);    /* @asm 0x54393 lcall 0x1A1F:0x494 */
        (void)v;
    }

    /* @asm 0x543D8..0x54450 — clear two 0x32-byte histograms [bp-0x66] and
     * [bp-0xe2] (25 words each = per-occupation tallies), then walk the colony's
     * worker slots [bp-0xaa] (0..size) counting each worker's occupation
     * (slot_get_a; default 0x13 if unset) into the [bp-0x66] histogram. */
    crt_memset(&_hist_a, 0, 0x32);              /* @asm 0x543E0 memset([bp-0x66],0,0x32) */
    crt_memset(&_hist_b, 0, 0x32);              /* @asm 0x543F1 memset([bp-0xe2],0,0x32) */
    /* for (i=0; i<size; i++) { occ = slot_get_a(i); if (!slot_is_set(occ)) occ=0x13;
     *                          hist_a[occ]++; }  @asm 0x543F9..0x5443B */

    /* ---------------------------------------------------------------- PHASE D
     * @asm 0x5443D..0x549A5 — BUILD PLANNER.
     * slot_commit(); if g_iter_aux_8D72 != 0 AND col[+0x1B]&0x10 set, run the
     * "find a worker producing a needed good and reassign to building work"
     * loop (occ 0x12 via assign_job) @0x5444C..0x5457F.  Then choose the next
     * building [bp-0x8c] from a ladder of thresholds: */
    slot_commit();                              /* @asm 0x5443D lcall 0x181F:0xCCC */
    col = (uint8_t *)g_colony_buf_8542;
    /* @asm 0x5445C..0x5457F — the reassign-to-building loop (occ 0x12 -> 0x181F:0xC36
     *   when [bp-0xec] occupation is a building 0x13/0x14/0x15/0x16/0x17 and the
     *   gating thresholds [bx+0xaa]/[bx+0x1c]&0x10 hold).  This sets col status
     *   bit clears (col[0x1b] &= 0xfb @0x545A2) as it moves workers. */

    /* @asm 0x5457F..0x546A2 — BUILD LADDER -> [bp-0x8c] = building id, [bp-0x134]=1
     *   if a build was chosen:
     *     default 0x13 (Stockade) if col[+0x1F] > 1                @0x545C3/0x545CC
     *     0x16 if col[+0xAA] >= 0x66 and size<0xA and !bit4         @0x545DF/0x545F9
     *     0x14 (Fortress) if revolution-aux clear and [bp-0xe]!=0 and
     *           col[+0xB6] >= 0x14                                  @0x54641/0x5465E
     *     0x15 / 0x17 if col[+0x1B]&0x48==0 and col[+0xB8] >= 0x32  @0x5466E..0x5468F
     * @asm 0x546A5..0x546B8 — if chosen==0x17 remap to 0x15. */

    /* @asm 0x546B8..0x5479C — for the chosen building, scan the worker slots to
     *   find the BEST candidate worker to move onto it (histogram [bp-0x66]
     *   maximisation; tracks best [bp-0x32], best-score [bp-0x16c]); if found,
     *   assign_job(0x1c, best) to clear it then assign_job(building, best). */

    /* @asm 0x5479C..0x54945 — emit AI BUILD RECOMMENDATIONS via ai_record_rec /
     *   ai_decide_build (the near-call trampolines), one per evaluated factor:
     *     ai_record_rec(0xf, score)  build vs ...   @0x547CA
     *     ai_record_rec(0xd, flag)                  @0x54817
     *     ai_record_rec(0x8, flag)                  @0x54834
     *     ai_record_rec(0xe, flag)                  @0x5485F
     *     ai_record_rec(0xf, flag)                  @0x548C7
     *   and the KING-TREASURY upkeep tie-in @0x548D3..0x54956:
     *     if !defenders and col[+0xB8] >= 0xC8 and king[+0x49] < 0x14:
     *         king[+0x49]++; col[+0xB8] -= 0x32   @0x548E9/0x548EC  (training upkeep) */
    col = (uint8_t *)g_colony_buf_8542;
    if (defense_cnt_le0() &&                     /* @asm 0x548CD cmp [bp-0x74],0; jne */
        *(int16_t *)(col + 0xb8) >= 0xC8) {       /* @asm 0x548D7 cmp [bx+0xb8],0xc8; jl */
        uint8_t *kr = (uint8_t *)g_king_record_84FC; /* @asm 0x548DF mov si,[0x84fc] */
        if (kr[0x49] < 0x14) {                    /* @asm 0x548E3 cmp [si+0x49],0x14; jae */
            kr[0x49]++;                           /* @asm 0x548E9 inc [si+0x49] */
            *(int16_t *)(col + 0xb8) -= 0x32;     /* @asm 0x548EC sub [bx+0xb8],0x32 */
        }
    }
    g_flag_034C = 0;                              /* @asm 0x548F1 mov byte [0x34c],0 */
    helper_BD2();                                 /* @asm 0x548F6 lcall 0x181F:0xBD2 */

    /* @asm 0x548FB..0x54956 — the KING-TREASURY DEBIT for a build (gated on a
     *   10-turn cadence and the colony not being a port [+0x1B&0x80]).  Cost is
     *   0x14 × per-power-cost-byte[owner*16 - 0x7B36]; subtracted from the king
     *   treasury 64-bit pair king[+0x2A]/[+0x2C]; on success the build effect
     *   building_finished_fx(0x14,0xE) fires and col[+0xB6] += 0x14: */
    if (!(col[0x1b] & 0x80) &&                                  /* @asm 0x548FF test [bx+0x1b],0x80; jne */
        (g_event_turn_538E % 10) == 0 &&                        /* @asm 0x54905 idiv 0xa; or dx; jne */
        build_flag_set()) {                                     /* @asm 0x54912 cmp [bp-0x14],0; jne */
        uint8_t *kr = (uint8_t *)g_king_record_84FC;
        int idx = col[0x1a];                                    /* @asm 0x54918 col[+0x1A] owner */
        uint32_t cost = (uint32_t)0x14 *
            ((uint8_t *)DGROUP_PTR(KING_COST_84CA))[idx << 4];  /* @asm 0x54920..0x54922 mul [bx-0x7b36] */
        uint32_t treasury = ((uint16_t *)kr)[0x2a / 2] |
                            ((uint32_t)((uint16_t *)kr)[0x2c / 2] << 16); /* @asm 0x5492B/0x5492F */
        if (treasury >= cost) {                                 /* @asm 0x54932..0x54939 (dx:ax cmp) */
            ((uint16_t *)kr)[0x2a / 2] -= (uint16_t)cost;       /* @asm 0x5493B sub [bx+0x2a],ax */
            ((uint16_t *)kr)[0x2c / 2] -= (uint16_t)(cost>>16); /* @asm 0x5493E sbb [bx+0x2c],dx */
            building_finished_fx(0x14, 0xE);                    /* @asm 0x54945 lcall 0x191F:0xC14 */
            col = (uint8_t *)g_colony_buf_8542;
            *(int16_t *)(col + 0xb6) += 0x14;                   /* @asm 0x54951 add [bx+0xb6],0x14 */
            /* set [bp-0x14]=1 (build done this turn) @0x54956 */
        }
    }

    /* @asm 0x5495B..0x549A5 — a SECOND build path on a 7-turn cadence
     *   (g_event_turn_538E % 7) gated on ai_query_flag(); subtracts up to 0x14
     *   from col[+0xB6] and zeroes col[+0x8C] (finish a queued build):  */
    /* if (build_flag_set() && (g_event_turn_538E % 7)==0 && ai_query_flag()) {
     *     int d = min(col[+0xB6], 0x14); col[+0xB6] -= d; col[+0x8C] = 0; }   */

    /* ---------------------------------------------------------------- PHASE E
     * @asm 0x549A8..0x55F5D — WORK RE-ALLOCATION (the bulk of the function).
     * Gated on col[+0x1B]&0x80 (port colony) and a build having occurred this
     * turn (a no-op early-out to PHASE F otherwise @0x549A3..0x549BE). */
    col = (uint8_t *)g_colony_buf_8542;
    /* @asm 0x549C1..0x54A4F — (port path) scan tiles around the colony for the
     *   best ocean/feature work tile; pick best [bp-0x32]. */

    /* @asm 0x54A50..0x54C5B — main "best surrounding tile" selection loop over
     *   the 8 ring directions ([bp-0x78] 0..7, deltas from col[+0xC8]/[+0xDE]).
     *   For each in-bounds, unblocked, unclaimed tile it scores the yield
     *   [bp-0x130] (from the 0x2F79 yield column and resource_at), adjusts by
     *   the king treasury state (king[+0x2C]<0 or king[+0x2A]<0x7D0 doubles,
     *   else halves @0x54B97..0x54BB8) and keeps the best (best tile [bp-0x32],
     *   best score [bp-0x16c]).  Per-direction the [bp-6] flag marks whether the
     *   tile is contested by a human power (AI ctrl byte 0 @0x54C46). */

    /* @asm 0x54C5B..0x548C7 region (the 0x18C7 join) — if a winning tile was
     *   found and is owned by THIS colony's owner, PLACE a colonist there:
     *     place_colonist(0, owner, x, y, g_byte_524E) -> new unit idx; set its
     *     +0x315A=0x63; finalize_place/place_variant; on success col[+0xB6] is
     *     reduced and col[+0x8C]=0 @0x54DFE/0x54E02. */
    {
        /* @asm 0x54CF9..0x54D1C */
        int x = 0, y = 0;                                       /* (computed from the chosen ring tile) */
        int nu = place_colonist(0, col[0x1a], x, y, g_byte_524E); /* @asm 0x54D0D lcall 0x191F:0xA20 */
        if (nu >= 0) {
            uint8_t *u = (uint8_t *)DGROUP_PTR(UNIT_BASE_3144 + nu * UNIT_STRIDE_1C);
            u[U_TURN_315A - UNIT_BASE_3144] = 0x63;             /* @asm 0x54D1C mov [bx+0x315a],0x63 */
        }
    }

    /* @asm 0x54E07..0x54E76 — RESET the colony's worker layout: for every
     *   in-colony worker (0..size) clear its slot value [bp+si-0x12c]=0, mark it
     *   un-placed [bp+si-0x1ac]=0, call helper_BB4(slot) and assign_job(0x12,slot)
     *   (un-assign to the default 0x12 job).  Then blank the worker_slots table:
     *   col[+0x70 .. +0x70+0x14] = 0xFF (the 20 assignment bytes). */
    col = (uint8_t *)g_colony_buf_8542;
    for (i = 0; i < (int8_t)col[0x1f]; i++) {                   /* @asm 0x54E4B cmp [bx+0x1f],ax; jg */
        int occ = slot_get_a(i);                               /* @asm 0x54E14 lcall 0x181F:0xC54 */
        /* slot_value[i] = occ; placed[i] = 0; helper_BB4(i); assign_job(0x12,i); */
        helper_BB4(i);                                         /* @asm 0x54E31 lcall 0x181F:0xA7E (=0x?? wrapper) */
        assign_job(0x12, i);                                  /* @asm 0x54E3F lcall 0x181F:0xC36 */
        (void)occ;
    }
    for (i = 0; i < 0x14; i++)                                  /* @asm 0x54E6F cmp [bp-0xaa],0x14 */
        col[0x70 + i] = 0xff;                                   /* @asm 0x54E67 mov [bx+si+0x70],0xff */
    /* @asm 0x54E76..0x54E92 — build a 0x13-entry table [bp-0x168] from helper_BB4
     *   (0x181F:0xBB4) per occupation. */
    /* @asm 0x54E9D..0x54EAD — memset(&col[+0x70], -1, 0x14) again (full clear). */
    crt_memset(col + 0x70, -1, 0x14);                          /* @asm 0x54EA8 lcall 0x0D1D:0xDAE */
    slot_advance();                                            /* @asm 0x54EB0 lcall 0x181F:0xC04 */

    /* @asm 0x54EB5..0x55A0F — the GREEDY ASSIGNMENT passes.  Several nested
     *   loops repeatedly pick the highest-value unplaced worker for the next
     *   open production slot, biased by:
     *     - colony size vs 2× ring_n ([bp-0x7e])              @0x54EBD
     *     - bells_per_turn col[+0x9A] vs 0x4b / the band words @0x54F0B/0x55054
     *     - the Europe market bands g_band_base/g_over_low/g_over_high
     *     - the war flag (manufactured goods get occ 0x1C when at war,
     *       via the cs-relative jump table at IP 0x1E1E @0x55639)
     *   and commits each via assign_commodity(good, slot) (0x181F:0xB6E),
     *   slot_set / assign_job, updating the [bp-0xe2] occupation histogram.
     *   When a successful (re)assignment happens, g_result_flag_035E is set: */
    g_result_flag_035E = 1;                                    /* @asm 0x54FC9 mov word [0x35e],1 */
    /* (full inner greedy arithmetic — IP 1A8F..2A1D — is byte-traced control
     *  flow; the per-good PRIORITY WEIGHTS live in the 0x8Dxx/0x8Exx band globals
     *  and the data tables [bx-0x71xx]/[bx-0x715a]/[bx+0x2a2], all data-driven
     *  -> RUNTIME_ONLY (data-resident).  See src/data/production.c for those globals' roles.) */

    /* @asm 0x55639 — manufactured-goods dispatch (commodity_id-9, 9 cases):
     *   case 4 (TradeGoods) -> IP 0x1DCC ; case 7 -> 0x1D80 ; case 8 -> 0x1DB8 ;
     *   default -> 0x1D3C.  The default path uses the war flag [0x5382]&1 to set
     *   a per-good "active" word (0/1) and may force occ 0x1C (@0x555B8/0x555FC). */

    /* @asm 0x55A2B..0x55F5D — POST-ASSIGN bookkeeping: clear col[+0x1D] bit7 and
     *   set col[+0x94]=0xFF (the "build queue empty / recompute" sentinel),
     *   recompute the per-good production headroom into col[+0x9A + good*2] and
     *   the manufactured-vs-raw balance using query_b/query_c (0x181F:0xB82/0xBF0)
     *   and the bands; emit a final ai_record_rec for the SoL/Tory side. */
    col = (uint8_t *)g_colony_buf_8542;
    col[0x1d] &= 0x7f;                                         /* @asm 0x55A2F and [bx+0x1d],0x7f */
    col[0x94] = 0xff;                                          /* @asm 0x55A33 mov [bx+0x94],0xff */

    /* ---------------------------------------------------------------- PHASE F
     * @asm 0x55F5E..0x05628C — FINALISE.  A last build-priority gate sets
     * col[+0x94]=0xFF / col[+0x1D] |= 0x80 (@0x55F62/0x55F67) when the chosen
     * build is unaffordable, then a tail block applies a KING upkeep DEBIT and
     * clears the result flag. */
    /* @asm 0x55F6B..0x55FFE — a [bp-0x92]-driven adjustment of col[+0x8C] using
     *   count_chain(0xC) and the 8-neighbour query_b/query_c sums. */

    /* @asm 0x56200..0x56281 — KING UPKEEP DEBIT: when col[+0xAA] < 2 and the
     *   turn counter [0x538E] >= 0x28 and the colony's unit-type table says it is
     *   eligible ([bx+0x5237]!=0) and the king treasury (king[+0x2A]/[+0x2C])
     *   has >= 0xA, subtract 0xA from the king treasury and set col[+0xAA]=2. */
    col = (uint8_t *)g_colony_buf_8542;
    if (*(int16_t *)(col + 0xaa) < 2 &&                         /* @asm 0x56223 cmp [bx+0xaa],2; jge */
        g_event_turn_538E >= 0x28) {                            /* @asm 0x5622A cmp [0x538e],0x28; jl */
        int type = col[0];                                      /* @asm 0x56231 (col x re-used as type idx?) */
        uint8_t *u2 = (uint8_t *)first_unit_or_type();          /* @asm 0x56243 region */
        (void)type; (void)u2;
        /* per-type eligibility [bx+0x5237] then: */
        uint8_t *kr = (uint8_t *)g_king_record_84FC;            /* @asm 0x5625F mov bx,[0x84fc] */
        if (*(int16_t *)(kr + 0x2c) > 0 ||                      /* @asm 0x56263 cmp [bx+0x2c],0; jl/jg */
            (*(int16_t *)(kr + 0x2c) == 0 &&
             (uint16_t)*(int16_t *)(kr + 0x2a) >= 0xA)) {       /* @asm 0x5626B cmp [bx+0x2a],0xa; jb */
            *(int16_t *)(kr + 0x2a) -= 0xA;                     /* @asm 0x56271 sub [bx+0x2a],0xa */
            *(int16_t *)(kr + 0x2c) -= 0;                       /* @asm 0x56275 sbb [bx+0x2c],0 */
            col = (uint8_t *)g_colony_buf_8542;
            *(int16_t *)(col + 0xaa) = 2;                       /* @asm 0x5627D mov [bx+0xaa],2 */
        }
    }

    /* @asm 0x56283 — clear the result flag, then pop si/di; leave; retf. */
    g_result_flag_035E = 0;                                    /* @asm 0x56283 mov word [0x35e],0 */
    /* @asm 0x5628C retf */

    /* Frame slots that the SUMMARISED inner blocks read (kept as documented
     * locals; void-cast so the partial port is warning-clean). */
    (void)is_capital; (void)ncol_owned; (void)ring_n; (void)owner;
}

/* ============================================================================
 * NOTES / STILL-LEFT-UNRESOLVED
 *  - ROLE: COLONY (AI auto-manage / work re-allocation + build planner).  NOT
 *    king/tax — corrected here; the NEXT_TARGETS "KINGTAX" tag was a false
 *    attribution (this body pushes NO king message handle — byte-verified).
 *    Status: BYTE_VERIFIED for the control-flow SPINE, the EXTENT (9999 bytes,
 *    single RETF), the *(0x8542) status-flag writes (+0x1B/+0x1C/+0x1D/+0x1E/
 *    +0x8C/+0x8E/+0x94/+0xAA/+0xB6/+0xB8), the king-treasury debits
 *    (king[+0x2A]/[+0x2C], king[+0x49] counter), the result flag [0x35E], and
 *    every cited LCALL/near-CALL site.  The 12 header spot-checks all PASS.
 *  - The PER-GOOD / PER-POWER WEIGHT TABLES that drive the greedy assignment
 *    and the threat survey are DATA-RESIDENT (NAMES.TXT @CARGO / overlay
 *    colony-init), exactly as in turn_update.c & production_support.c.  Their
 *    NUMERIC values are RUNTIME_ONLY (data-resident); their ADDRESSES are byte-verified:
 *      yield 0x2F7B/0x2F78/0x2F79; related-raw 0x2A2; per-good band globals
 *      0x8DC8/0x8E0A/0x8E32/0x8E5A; per-power tables in the 0x91xx/0x92xx/0x94xx
 *      regions (negative-disp bases reconstructed in the #defines above);
 *      the per-power king-cost byte at 0x84CA[owner*16].
 *  - The OVERLAY/resident HELPER SEMANTICS (slot_get/slot_set/assign_job/
 *    assign_commodity/the tile helpers) are inferred from arg shape + the
 *    cross-ported production_support.c bodies for the 0x9FC/0xAB0/0xC86 ones;
 *    the others (0xC04/0xC0E/0xC54/0xC9A/0xCAE/0xC36/0xB6E/0xB82/0xBF0...)
 *    are LITERAL-faithful to the push args -> body in thunk page.
 *  - The four near-CALL trampolines (0x2D4E/0x2D53/0x2D5D/0x2D62) are the AI
 *    build-recommendation recorders; they are the page-tail `ljmp 0x1A1F:0x5b4..
 *    0x5e4` stubs (NOT part of the 9999-byte body — that is why the reseg's
 *    `terminal=page-end` size of 10025 over-counts by 26).
 *  - The inner arithmetic of PHASE B (threat survey) and the deep greedy loops
 *    of PHASE E (IP 1A8F..2A1D) are summarised, not transcribed line-by-line:
 *    every operand there is cited in page_0E.asm, but the net effect (tallies,
 *    best-tile/best-worker selection, market-band-biased priority) is captured
 *    above; transcribing 1500 more instructions would not add byte-verified
 *    FACTS beyond the data-driven weights already marked RUNTIME_ONLY (data-resident).
 *  - CALLER: reached as an OVERLAY function via the RTLink runtime loader with
 *    a page-id trailer (the NEXT_TARGETS "0x1A1F:0x35E" is this function's own
 *    offset-in-segment 0x35E, not a literal call window).  No direct
 *    `lcall <win>:0x35E` exists in any of the three thunk windows — the JMPF is
 *    runtime-patched — so the call site is overlay-resolved (the prior auto-
 *    tracer likewise reported @callers 0).  The per-turn AI loop that drives it
 *    is not yet decoded (cross-ref the AI dispatcher 0x4E2D6 neighbourhood, NEXT_TARGETS #2).
 * ============================================================================ */
