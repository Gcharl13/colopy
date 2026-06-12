/* ============================================================================
 * colony/turn_update.c — the colony per-turn economy update + per-tile yields
 * ----------------------------------------------------------------------------
 * This is the most-decoded large slice of VICEROY.EXE.  Wave-1 ported the
 * production-support leaves (production_support.c); this file finishes the
 * top-level bodies, FULLY byte-traced from the load-image disassembly:
 *
 *   - compute_terrain_yield   (file 0x9B9C..0x9FFB, 1120 bytes)  [full body]
 *   - colony_turn_update      (file 0xA222..0xA6A1, 1152 bytes)  [full body]
 *
 * ------------------------------------------------------------------------
 * CORRECTION (2026-05-30, BYTE_VERIFIED): the prior draft modelled
 * `compute_colony_center_yields` (0xA222) and `colony_turn_update` (0xA3E1)
 * as TWO functions joined by fall-through.  That was a DISASSEMBLER
 * SEGMENTATION ARTIFACT.  There is exactly ONE function: it begins with the
 * single `ENTER 0x2a,0` prologue at 0xA222 and ends with `POP SI / LEAVE /
 * RETF` at 0xA6A1.  The auto-segmenter's "ENTER 0x8d,0" at 0xA3E1 is a
 * MIS-DECODE: it lands mid-instruction inside
 *     0xA3DF:  C7 87 C8 8D 00 00   MOV word ptr [bx-0x7238], 0
 * (the accumulator-zeroing store, where bx-0x7238 == DGROUP:0x8DC8).  Read
 * starting at 0xA3E1 you get the bytes `C8 8D 00 00` = `ENTER 0x8d,0`, which
 * is not a real prologue.  Proof (raw VICEROY.EXE bytes @0xA3D5):
 *     c7 46 e4 00 00   MOV [bp-0x1c],0
 *     8b 5e e4         MOV bx,[bp-0x1c]
 *     d1 e3            SHL bx,1
 *     c7 87 c8 8d 00 00  MOV [bx-0x7238],0     <-- spans 0xA3DF..0xA3E4
 *     ff 46 e4         INC [bp-0x1c]
 *     83 7e e4 14      CMP [bp-0x1c],0x14
 *     7c ec            JL 0xA3DA
 * There is NO real call/jump that targets 0xA3E1 (the two "near CALL ->
 * 0xA3E1" hits in a naive scan are 16-bit &0xFFFF aliases of calls that
 * actually target file 0x1A3E1, a different function whose bytes begin
 * `50 51 52 56 1E` = PUSH ax/cx/dx/si/ds — not an ENTER).  The only entry to
 * the whole 0xA222..0xA6A1 region is 0xA222 (called near from 0xAC4B and
 * 0xBC01).  So the C below is ONE function `colony_turn_update`; the old
 * `compute_colony_center_yields` name is retained as a thin alias that just
 * calls it, to keep the colony.h decl / callgraph stable.
 *
 * @ref reverse_engineered/code/VICEROY/disasm/func_009B9C_compute_terrain_yield.asm
 * @ref reverse_engineered/code/VICEROY/disasm/func_00A222_compute_colony_center_yields.asm
 * @ref reverse_engineered/code/VICEROY/disasm/func_00A3E1_colony_turn_update.asm
 *      (NOTE: the latter two .asm dumps are the two halves of the SAME
 *       function, split by the segmentation artifact described above.)
 * ------------------------------------------------------------------------
 *
 * EVERY constant below carries an @asm file-offset cite naming the
 * instruction and its actual operand bytes, OR an explicit [not yet decoded] marker.
 *
 * --- CITE-OR-NOT-YET-DECODED LEDGER --------------------------------------------------
 *  BYTE_VERIFIED (offset + operand bytes confirmed in COLONIZE/VICEROY.EXE):
 *    - terrain*16+good yield-table base DGROUP:0x2F7B   @asm 0x9C1E: 8A 80 7B 2F
 *    - 5x5 ring scan (BOTH loops 0..4)                  @asm 0xA417 / 0xA46B
 *    - accumulator g_global_amount base DGROUP:0x8DC8   @asm 0xA462: [bx-0x7238]
 *    - accumulator zero-init loop (0..0x13)             @asm 0xA3DA..0xA3EC
 *    - expert-doubling marker job==8                    @asm 0xA44D: 80 78 20 08
 *    - SoL/Tory penalty formula (full)                  @asm 0x9D1A..0x9D81
 *    - 5 raw->finished chains + 3 band dispatches       @asm 0xA642..0xA69C
 *    - founding-father bell multipliers (op 0xF/0x11/0x12) @asm 0xA4DF..0xA57E
 *    - Fortress(0x14) x2 / Stockade(0x13) +50%          @asm 0xA587..0xA5AC
 *    - rebellion quota (divisor 0x19/0x32)              @asm 0xA5BB..0xA5E2
 *  RUNTIME_ONLY (data-resident; values live in NAMES.TXT, not in the EXE):
 *    - the NUMERIC cells of the yield table at 0x2F7B   (see src/data/production.c)
 *  library-implementation-only (overlay-thunk-resident; reached by LCALL, body not in load image):
 *    - LCALL 0x3E4:0x0E / 0x3A   base terrain id at (x,y)
 *    - LCALL 0x37F:0x10E / 0x142 / 0x4B0  feature/resource layer reads
 *    - LCALL 0x981:0x00  per-power founding-father / flag tester
 * -------------------------------------------------------------------------
 * ============================================================================ */
#include "viceroy.h"

/* ----------------------------------------------------------------------------
 * Overlay-resident helpers reached by LCALL (segment:offset target documented).
 * Bodies are NOT in the load image (library-implementation-only; body in overlay thunk page);
 * their call sites and arg/return roles are byte-verified.
 * ---------------------------------------------------------------------------- */
/* LCALL 0x3E4:0x0E -> func_00624E_logic_sz_8(feat_byte): extract terrain id from feature byte */
extern int   func_00624E_logic_sz_8(uint16_t feat_byte);
/* LCALL 0x3E4:0x3A -> func_00627A_op_sz_57(map_x, map_y): terrain id at map coordinates */
extern int   func_00627A_op_sz_57(uint16_t map_x, uint16_t map_y);
extern int   ov_feature_flags_142(int x, int y);        /* LCALL 0x37F:0x142 @asm 0x9C93 (river bit 0x40, special 0x0A, 0x04) */
extern int   ov_feature_flags_10E(int x, int y);        /* LCALL 0x37F:0x10E @asm 0x9BEB → low byte = feature/bonus byte */
extern int   ov_resource_at_4B0(int x, int y);          /* LCALL 0x37F:0x4B0 @asm 0x9C0A → special-resource id (0..?) */
extern int   ov_power_flag(int owner, int op_id);        /* LCALL 0x981:0x00  @asm 0x9F77 / 0xA4EB ... */

/* ----------------------------------------------------------------------------
 * Load-image helpers (all near-CALL within the load image; byte-verified).
 * ---------------------------------------------------------------------------- */
/* 0x9974 -> func_009974_logic_sz_18(slot, dir, out_ptr): good_id; *out_ptr = secondary result (unused by caller) */
extern int   func_009974_logic_sz_18(uint16_t slot, uint16_t dir, uint16_t *out_ptr);
extern int   feature_yield_bonus(int resource_id, int commodity); /* 0x9AAA hard-coded (resource,commodity) bonus switch */
extern int   count_adjacent_terrain(int x, int y, int lo, int hi);/* 0x99EE adjacency tally over 8 neighbours */
/* The production-support cluster (sol_membership_pct 0x8524, lookup_signed_2F4
 * 0x8D9C, test_building_or_father_bit 0x863E, count_building_chain_present 0x864E,
 * update_finished_good_from_raw 0x8E84, dispatch_via_8e02_with_band 0x8E46,
 * step_100_or_level_scaled 0x8D00, lookup_byte_from_pair 0x8956,
 * current_unit_field_at_40 0x9102) is BYTE_VERIFIED and declared in colony.h. */

/* unit_individual_handler_9FFC — per-colonist bells/crosses/manufactured-goods
 * producer.  @asm 0x009FFC..0x00A221 (550 bytes); jump-table at CS:0x1F44
 * dispatches on (job_byte-9).  Writes output commodity index to *meta; returns
 * the yield amount.  BYTE_VERIFIED 2026-06-08.
 * @ref src/colony/colonist_handler.c (full body). */
extern int   unit_individual_handler_9FFC(int colonist_idx, int *meta);

/* PowerRecord byte read for founding-father op 0x11 bonus.
 * @asm 0xA521: IMUL bx, owner, 0x13C  (PowerRecord stride 316 = 0x13C)
 * @asm 0xA525: MOV al, byte ptr [bx - 0x77F7]   (bytes 8A 87 09 88 → DGROUP:0x8809)
 * Treated as a flat byte view: g_power_byte_8809[owner*0x13C]. */
extern uint8_t g_power_byte_8809[];

/* ============================================================================
 * compute_terrain_yield — 1120 bytes; the per-(tile, worked-good) yield engine
 *
 * @asm 0x009B9C..0x009FFB  ENTER 0x2A / POP SI / LEAVE / RETF
 * @ref disasm/func_009B9C_compute_terrain_yield.asm
 *
 * Called from colony_turn_update's 5x5 scan, once per (ring_b, ring_a) cell.
 *
 * Args (byte-verified from the call site @asm 0xA41D..0xA42A; cdecl, first
 * declared parameter = lowest stack slot [bp+6]):
 *   ring_a = [bp+6]   first ring coordinate (X-driver, inner loop var)
 *   ring_b = [bp+8]   second ring coordinate (Y-driver, outer loop var)
 *   out    = [bp+0xA] -> receives the resolved good_id (or <0 if tile unworked)
 *   flag   = [bp+0xC] "settle/clear" flag: when set and good is a manufactured
 *                     good (good>=8), *out is zeroed before return @asm 0x9FC5
 * Returns: AX = the yield amount for that worked tile (clamped >= 0).
 *
 * Stack-frame local map (proven from the disasm displacements):
 *   [bp-0x24] yield (accumulator)        [bp-0x12] good_id
 *   [bp-6]    col_x      [bp-4]  col_y   [bp-0x26] feat_byte (low byte of 0x10E)
 *   [bp-0x1e] terrain    [bp-0x18] resource
 *   [bp-2]    adj (forest neighbour count)
 *   [bp-0x22] match_idx  [bp-0x20] field40_of_match
 *   [bp-0x16] is_profmatch (field40==good)      [bp-8] is_special (field40==0x1b)
 *   [bp-0x14] era_flag (good==0 || good==8)     [bp-0x1c] sol_pct
 *   [bp-0xc]  tory_count [bp-0xe] divisor       [bp-0x1a] sol_adj (signed)
 *   [bp-0x10] rbonus     [bp-0xa] feat_tier     [bp-0x28] furs_penalty_flag
 * ============================================================================ */
int compute_terrain_yield(int ring_a, int ring_b, int *out, int flag)
{
    int yield        = 0;   /* [bp-0x24] */
    int era_flag     = 0;   /* [bp-0x14] */
    int furs_penalty = 0;   /* [bp-0x28] */
    uint16_t rtig_inner = 0; /* [bp-0x2A] output pointer passed to func_009974; written but not read */

    /* --- step 1: which good is worked on this tile? --- */
    int good_id = (int)func_009974_logic_sz_18((uint16_t)ring_a, (uint16_t)ring_b, &rtig_inner); /* @asm 0x9BB7 CALL 0x9974 */
    *out = good_id;                                     /* @asm 0x9BC3 MOV [bx],ax */
    if (good_id < 0) return 0;                          /* @asm 0x9BC5/0x9BC9 JMP 0x9FF6 */

    /* --- step 2: world coordinates of the worked tile --- */
    /* @asm 0x9BCC..0x9BE7  bx=*(0x8542); col_x=[+0]+ring_a-2; col_y=[+1]+ring_b-2 */
    int col_x = (int)(uint8_t)ctx->map_x + ring_a - 2;  /* @asm 0x9BDE MOV al,[bx];   ADD [bp+6]; DEC;DEC */
    int col_y = (int)(uint8_t)ctx->map_y + ring_b - 2;  /* @asm 0x9BD0 MOV al,[bx+1]; ADD [bp+8]; DEC;DEC */

    /* --- steps 3-5: feature / terrain / resource at that tile ---
     * NOTE arg order at each LCALL is (col_x, col_y): col_y pushed first
     * (@asm 0x9BD?), col_x pushed second → cdecl param1=col_x. */
    int feat_byte = ov_feature_flags_10E(col_x, col_y) & 0xFF; /* @asm 0x9BEB LCALL 0x37F:0x10E; AL kept */
    int terrain   = func_00624E_logic_sz_8((uint16_t)feat_byte); /* @asm 0x9BF9 LCALL 0x3E4:0x0E: feat_byte → terrain id */
    int resource  = ov_resource_at_4B0(col_x, col_y);          /* @asm 0x9C0A LCALL 0x37F:0x4B0 */

    /* --- step 6: base yield from the terrain x good table ---
     * @asm 0x9C15: si=terrain<<4; bx=good_id; al=g_terrain_yield_table[bx+si+0x2F7B] */
    yield = g_terrain_yield_table[terrain * 16 + good_id];      /* RUNTIME_ONLY (data-resident): numeric cells loaded from NAMES.TXT */

    if (yield != 0) {                                  /* @asm 0x9C27 OR ax,ax / JNE */
        /* --- step 7: forest / adjacency tier nudge (land goods only, good>=8) --- */
        if (good_id >= 8) {                            /* @asm 0x9C2E CMP bx,8 / JL 0x9C87 */
            int adj = count_adjacent_terrain(col_x, col_y, 0x19, 0x1A); /* @asm 0x9C3E CALL 0x99EE (lo=0x19,hi=0x1A) */
            /* BYTE-EXACT REACHABLE behaviour (verified against raw bytes
             *   8946fe 3d0800 7c06 836edc02 eb35 3d0600 7c05 ff4edc eb2b
             *   3d0600 7d05 ff46dc eb21 ...):
             *     adj >= 8     -> yield -= 2   (@asm 0x9C4A JL 0x9C52 not taken; 0x9C4C SUB 2)
             *     adj in [6,8) -> yield -= 1   (@asm 0x9C55 JL 0x9C5C not taken; 0x9C57 DEC)
             *     adj <  6     -> yield += 1   (@asm 0x9C5F JGE 0x9C66 NOT taken since adj<6;
             *                                   0x9C61 INC; 0x9C64 JMP 0x9C87)
             *   The +2/+3/+4 tails at 0x9C66/0x9C72/0x9C7E are EMITTED but
             *   UNREACHABLE: control only reaches 0x9C5C when adj<6, so the
             *   0x9C5F `JGE 0x9C66` never branches and 0x9C61 INC + 0x9C64 JMP
             *   skip the whole tier ladder.  (Dead-code preserved as comment,
             *   not executed — confirms the original draft was right and the
             *   2026-05-30 "5-way ladder" attempt was a mis-read.) */
            if      (adj >= 8) yield -= 2;             /* @asm 0x9C47 CMP 8/JL; 0x9C4C SUB 2 */
            else if (adj >= 6) yield -= 1;             /* @asm 0x9C52 CMP 6/JL; 0x9C57 DEC   */
            else               yield += 1;             /* @asm 0x9C5C..0x9C64 (adj<6) INC; JMP */
        }
        /* --- step 8a: Furs(4) gets +1 on a 0x0A feature bit --- */
        if (good_id == 4) {                            /* @asm 0x9C87 CMP [bp-0x12],4 */
            if (ov_feature_flags_142(col_x, col_y) & 0x0A) yield += 1; /* @asm 0x9C93 LCALL 0x37F:0x142; TEST al,0x0A; 0x9C9F INC */
        }
        /* --- step 8b: river/special bits in feat_byte --- */
        if (feat_byte & 0x40) {                        /* @asm 0x9CA2 TEST [bp-0x26],0x40 */
            yield += 1;                                /* @asm 0x9CA8 INC */
            if (feat_byte & 0x80) yield += 1;          /* @asm 0x9CAB TEST 0x80; 0x9CB1 INC */
        }
    }
    if (yield < 0) yield = 0;                          /* @asm 0x9CB4..0x9CBD clamp >=0 */

    /* --- step 9a: profession-match + special-terrain flags --- */
    int match_idx = lookup_byte_from_pair(ring_a, ring_b);   /* @asm 0x9CC7 CALL 0x8956 (CWDE) */
    int field40   = current_unit_field_at_40(match_idx);     /* @asm 0x9CD3 CALL 0x9102 */
    int is_profmatch = (field40 == good_id) ? 1 : 0;         /* @asm 0x9CDC CMP ax,[bp-0x12] -> [bp-0x16] */
    int is_special   = (field40 == 0x1b)    ? 1 : 0;         /* @asm 0x9CEB CMP 0x1b -> [bp-8] */

    /* era_flag = 1 when good is Food(0) or Horses(8) @asm 0x9CFB..0x9D0E */
    if (good_id == 0 || good_id == 8) era_flag = 1; else era_flag = 0;

    /* --- step 9b: the SoL/Tory bell penalty (sol_adj, signed) ---
     * FULLY decoded (was left unresolved in prior draft):
     *   sol_pct   = sol_membership_pct()                              @asm 0x9D14 CALL 0x8524
     *   tory_pct  = 100 - sol_pct                                     @asm 0x9D1A/0x9D1D
     *   tory_cnt  = (population * tory_pct + 50) / 100   [round]       @asm 0x9D23..0x9D32
     *   divisor   = (owner<4 && controller==0) ? (10 - difficulty)    @asm 0x9D49..0x9D51
     *                                          : 10                   @asm 0x9D56
     *               (difficulty = byte[0x53A6])
     *   if NOT (owner<4 && controller==0):  tory_cnt = 0              @asm 0x9D5F..0x9D73
     *   sol_adj   = -(tory_cnt / divisor)                             @asm 0x9D78..0x9D81
     *   if (flags_at_1c & 4) sol_adj += 1                             @asm 0x9D88..0x9D8F
     *   if (flags_at_1c & 2) sol_adj += 1                             @asm 0x9D92..0x9D98 */
    {
        int sol_pct  = sol_membership_pct();                  /* @asm 0x9D14 CALL 0x8524 */
        int tory_pct = 100 - sol_pct;                         /* @asm 0x9D1A MOV cx,0x64; 0x9D1D SUB cx,ax */
        int pop      = (int)(uint8_t)ctx->population;         /* @asm 0x9D23 MOV al,[bx+0x1f]; CWDE */
        int tory_cnt = (pop * tory_pct + 0x32) / 100;         /* @asm 0x9D27 IMUL; 0x9D29 ADD 0x32; 0x9D30 IDIV 100 */
        int active   = (ctx->owner_power < 4 &&               /* @asm 0x9D35 CMP [+0x1a],4/JAE */
                        g_power_records[ctx->owner_power][0] == 0); /* @asm 0x9D43 CMP byte[owner*0x34+0x543F],0/JNE */
        int divisor;
        if (active) {
            divisor = 0xA - (int)g_difficulty_53A6;           /* @asm 0x9D49 MOV al,[0x53A6]; SUB 0xA; NEG = 10-diff */
        } else {
            divisor = 0xA;                                    /* @asm 0x9D56 MOV [bp-0xe],0xA */
        }
        if (!active) tory_cnt = 0;                            /* @asm 0x9D5F..0x9D73 zero count for non-active */
        int sol_adj = -(tory_cnt / divisor);                  /* @asm 0x9D78 CDQ; IDIV [bp-0xe]; 0x9D7F NEG */
        if (ctx->flags_at_1c & 4) sol_adj += 1;               /* @asm 0x9D88 TEST 4; 0x9D8E INC */
        if (ctx->flags_at_1c & 2) sol_adj += 1;               /* @asm 0x9D92 TEST 2; 0x9D98 INC */

        /* --- step 9c: apply positive sol_adj, then expert/match bonus --- */
        if (yield != 0 && sol_adj > 0)                        /* @asm 0x9D9B/0x9DA1 */
            yield += sol_adj;                                 /* @asm 0x9DA7 ADD [bp-0x24],ax */

        if (is_profmatch && yield != 0) {                     /* @asm 0x9DAD/0x9DB3 */
            if (era_flag != 0) {                              /* @asm 0x9DB9 CMP [bp-0x14],0/JE 0x9DD2 */
                yield += 2;                                   /* @asm 0x9DBF ADD 2 (Food/Horses match) */
                if (sol_adj > 0) yield += sol_adj;            /* @asm 0x9DC3..0x9DCC */
            } else {
                yield <<= 1;                                  /* @asm 0x9DD2 SHL — non-era goods DOUBLE on match */
            }
        }

        /* --- step 10: special-resource bonus --- */
        int rbonus = feature_yield_bonus(resource, good_id);  /* @asm 0x9DDE CALL 0x9AAA (resource, *out) */
        if (resource == 7 && yield <= 0) rbonus = 0;          /* @asm 0x9DE7..0x9DF3 */
        if (rbonus < 0) {                                     /* @asm 0x9DF8 CMP/JGE */
            yield <<= 1;                                      /* @asm 0x9DFE SHL (penalty resource doubles base) */
        } else {
            if (is_profmatch) rbonus <<= 1;                   /* @asm 0x9E04 CMP [bp-0x16]/JE; 0x9E0A SHL */
            yield += rbonus;                                  /* @asm 0x9E0D..0x9E10 */
        }

        /* --- A896 side-count tracking (goods 6/7/12) + Furs(7) no-feature path ---
         * @asm 0x9E13..0x9EA6.  These write the global running byte at
         * DGROUP:0xA896 and (for the resource==-1 furs path) can FORCE yield. */
        if (resource == 6) {                                  /* @asm 0x9E13 CMP [bp-0x18],6 */
            if (good_id == 6) g_table_A896 += 1;              /* @asm 0x9E1C CMP *out,6; 0x9E21 INC [0xA896] */
            if (good_id == 7) g_table_A896 += 2;              /* @asm 0x9E25 CMP *out,7; 0x9E2A ADD [0xA896],2 */
        }
        if (resource == 0xC && good_id == 7) g_table_A896 += 1; /* @asm 0x9E2F CMP 0xC; 0x9E38 CMP *out,7; 0x9E3D INC */
        if (good_id == 7 && resource == -1) {                 /* @asm 0x9E41 CMP *out,7; 0x9E49 CMP [bp-0x18],-1 */
            if ((ov_feature_flags_142(col_x, col_y) & 4) == 0)/* @asm 0x9E55 LCALL 0x37F:0x142; TEST al,4 */
                furs_penalty = 1;                             /* @asm 0x9E61 MOV [bp-0x28],1 (penalty set) */
            if (good_id == 7) {                               /* @asm 0x9E69 CMP *out,7 (always true here) */
                if ((ov_feature_flags_142(col_x, col_y) & 4) == 0 && yield != 0) { /* @asm 0x9E74/0x9E80 */
                    /* @asm 0x9E8C re-read 0x142; TEST al,0x0A */
                    if ((ov_feature_flags_142(col_x, col_y) & 0x0A) || is_profmatch)
                        yield = 1;                            /* @asm 0x9E9E MOV [bp-0x24],1 */
                    else
                        yield = 0;                            /* @asm 0x9EA6 MOV [bp-0x24],0 */
                }
            }
        }
        if (good_id == 5) yield <<= 1;                        /* @asm 0x9EAB CMP 5 / SHL (Lumber doubles) */

        /* --- step 11a: building-feature add (tier 1 or 2) for select goods --- */
        if (yield > 0 && furs_penalty == 0) {                 /* @asm 0x9EB4 CMP yield/JG; 0x9EBD CMP furs/JE */
            int tier = 1;                                     /* @asm 0x9EC6 MOV [bp-0xa],1 */
            /* tier becomes 2 when (BYTE-EXACT @asm 0x9ECB..0x9EDD):
             *   is_profmatch==0  -> 2 iff good==5
             *   is_profmatch==1  -> 2 if era_flag==0, else 2 iff good==5 */
            if ((!is_profmatch && good_id == 5) ||            /* @asm 0x9ECF JE 0x9ED7; 0x9ED7 CMP 5/JNE */
                ( is_profmatch && era_flag == 0) ||           /* @asm 0x9ED1 CMP era/JE 0x9EDD */
                ( is_profmatch && good_id == 5))              /* @asm 0x9ED7 CMP 5 (profmatch+era path) */
                tier = 2;                                     /* @asm 0x9EDD MOV [bp-0xa],2 */
            int add = 0;                                      /* @asm 0x9EE2 MOV [bp-0x10],0 */
            if (good_id == 0) add = tier;                     /* @asm 0x9EE7 CMP 0; 0x9EED MOV add,tier (Food) */
            if ((ov_feature_flags_142(col_x, col_y) & 0x0A) && good_id > 3) /* @asm 0x9EF9 0x142; TEST 0x0A; 0x9F05 CMP 3/JLE */
                add += tier;                                  /* @asm 0x9F0B..0x9F0E */
            if ((ov_feature_flags_142(col_x, col_y) & 0x40) && good_id <= 3)/* @asm 0x9F17 0x142; TEST 0x40; 0x9F23 CMP 3/JG */
                add += tier;                                  /* @asm 0x9F29..0x9F2C */
            if (feat_byte & 0x40) {                           /* @asm 0x9F2F TEST [bp-0x26],0x40 */
                add += tier;                                  /* @asm 0x9F35..0x9F38 */
                if ((feat_byte & 0x80) && add == tier)        /* @asm 0x9F3B TEST 0x80; 0x9F41 CMP add,tier/JNE */
                    add += tier;                              /* @asm 0x9F46 */
            }
            yield += add;                                     /* @asm 0x9F49..0x9F4C */
        }

        /* --- step 11b: building-presence gates --- */
        if (good_id >= 8) {                                   /* @asm 0x9F4F CMP 8 */
            if (test_building_or_father_bit(6) == 0)          /* @asm 0x9F55 PUSH 6; CALL 0x863E */
                yield = 0;                                    /* @asm 0x9F62 */
        }
        if (good_id == 4) {                                   /* @asm 0x9F65 CMP 4 (Furs) */
            if (ov_power_flag(ctx->owner_power, 8))           /* @asm 0x9F77 LCALL 0x981:0 (FF op 8) */
                yield <<= 1;                                  /* @asm 0x9F83 */
        }

        /* --- step 11c: is_special "+1 staple" bump --- */
        if (is_special && yield > 0) {                        /* @asm 0x9F86 CMP [bp-8],0/JE; 0x9F8C CMP yield/JLE */
            /* applies to staple goods {0,2,3,1,4} or any good>=8 @asm 0x9F92..0x9FB4 */
            if (good_id == 0 || good_id == 2 || good_id == 3 ||
                good_id == 1 || good_id == 4 || good_id >= 8)
                yield += 1;                                   /* @asm 0x9FB6 INC */
        }

        /* --- step 12: clamps + manufactured-good clear-on-settle + neg sol_adj --- */
        if (yield < 0) yield = 0;                             /* @asm 0x9FB9..0x9FC2 */
        if (flag != 0 && good_id >= 8) *out = 0;              /* @asm 0x9FC5..0x9FD4 (manufactured cleared on settle) */
        if (yield != 0 && sol_adj < 0) {                      /* @asm 0x9FD8..0x9FE2 */
            yield += sol_adj;                                 /* @asm 0x9FE7 */
            if (yield < 0) yield = 0;                         /* @asm 0x9FED..0x9FF3 */
        }
    }
    return yield;                                             /* @asm 0x9FF6 MOV ax,[bp-0x24] */
}

/* ============================================================================
 * colony_turn_update — 1152 bytes; the WHOLE per-colony turn-end economy update
 *
 * @asm 0x00A222..0x00A6A1  ENTER 0x2A / POP SI / LEAVE / RETF  (ONE function;
 *      see the CORRECTION banner at the top of this file).
 * @ref disasm/func_00A222_compute_colony_center_yields.asm  (bytes 0xA222..0xA3E0)
 * @ref disasm/func_00A3E1_colony_turn_update.asm            (bytes 0xA3E1..0xA6A1)
 *
 * Phase layout (proven from the disasm):
 *   A. center-tile food class + best-non-food scan        (0xA227..0xA3D4)
 *   B. zero the 20-word commodity accumulator              (0xA3D5..0xA3EC)
 *   C. apply center yields to the accumulator              (0xA3EE..0xA40C)
 *   D. 5x5 ring scan via compute_terrain_yield             (0xA40D..0xA478)
 *   E. per-colonist individual-handler pass                (0xA47F..0xA4AE)
 *   F. bell / building / founding-father multipliers       (0xA4B0..0xA5AC)
 *   G. liberty / rebellion quota                           (0xA5B0..0xA63F)
 *   H. production-chain dispatch (5 raw->finished + 3 band) (0xA642..0xA69C)
 *
 * Stack-frame locals (proven): [bp-0x1c] loop counter (reused 3 ways),
 *   [bp-0x18] inner ring var, [bp-0x1a] outer ring var, [bp-0x16] good_id,
 *   [bp-0x10] tile yield, [bp-0x26] handler out-idx, [bp-0xa] handler yield,
 *   [bp-0x24] center terrain id, [bp-0x14] center resource, [bp-2] center feat,
 *   [bp-0x12] center feat_tier, [bp-6] center scan yield, [bp-0xe] center modifier,
 *   [bp-0x1e] rebellion divisor, [bp-0x22]/[bp-0xc] rebellion quota,
 *   [bp-4] food band qty, [bp-8] (pop*2 - amount) clamp, [bp-0x20] pressure,
 *   [bp-0x2a] turn_step.
 * ============================================================================ */
void colony_turn_update(void)
{
    /* ======================= Phase A: center-tile food class ================= */
    g_table_A895 = 0;       /* @asm 0xA227 SUB AL,AL; MOV [0xA895],AL */
    g_table_A896 = 0;       /* @asm 0xA22C MOV [0xA896],AL */

    /* @asm 0xA22F..0xA241  LCALL 0x3E4:0x3A(map_x, map_y) → terrain id */
    int terrain = func_00627A_op_sz_57((uint16_t)ctx->map_x, (uint16_t)ctx->map_y); /* LCALL 0x3E4:0x3A */

    /* @asm 0xA247..0xA294  classify terrain → food class 0..3 */
    if (terrain == 0x18) {                              /* @asm 0xA247 sealane/dead */
        g_table_A891 = 0;                               /* @asm 0xA24C */
    } else if (terrain == 1 || terrain == 0x11 || terrain == 9) { /* @asm 0xA254/0xA259/0xA25E desert/dry */
        g_table_A891 = 1;                               /* @asm 0xA263 */
    } else if (terrain == 0x1B || terrain == 0x1C ||    /* @asm 0xA26A/0xA26F */
               (terrain >= 8 && terrain < 0x10) ||      /* @asm 0xA274 CMP 8/JL; 0xA279 CMP 0x10/JL forested */
               (terrain >= 0x10 && terrain < 0x18)) {   /* @asm 0xA27E CMP 0x10/JL; 0xA283 CMP 0x18/JGE hill/mtn */
        g_table_A891 = 2;                               /* @asm 0xA288 */
    } else {
        g_table_A891 = 3;                               /* @asm 0xA290 plains/grassland/prairie */
    }

    /* @asm 0xA295..0xA2AB  era bonus from DGROUP:0x53A6 (difficulty) */
    if (g_difficulty_53A6 == 0) g_table_A891 += 2;      /* @asm 0xA295 CMP 0/JNE; 0xA29C ADD 2 */
    if (g_difficulty_53A6 == 1) g_table_A891 += 1;      /* @asm 0xA2A1 CMP 1/JNE; 0xA2A8 INC */

    /* @asm 0xA2AC..0xA2C8  river bonus (0x142 bit 0x40) */
    if (ov_feature_flags_142(ctx->map_x, ctx->map_y) & 0x40) /* @asm 0xA2B9 LCALL 0x37F:0x142; TEST 0x40 */
        g_table_A891 += 1;                              /* @asm 0xA2C5 */

    /* @asm 0xA2C9..0xA313  center resource + feature-tier */
    int center_resource = ov_resource_at_4B0(ctx->map_x, ctx->map_y);   /* @asm 0xA2D6 LCALL 0x37F:0x4B0 -> [bp-0x14] */
    int center_feat     = ov_feature_flags_10E(ctx->map_x, ctx->map_y) & 0xFF; /* @asm 0xA2F3 LCALL 0x37F:0x10E -> [bp-2] */
    int feature_tier = 0;                               /* @asm 0xA2E1 MOV [bp-0x12],0 */
    if (center_feat & 0x40) {                           /* @asm 0xA300 TEST al,0x40 */
        feature_tier = 1;                               /* @asm 0xA304 */
        if (center_feat & 0x80) feature_tier = 2;       /* @asm 0xA309 TEST 0x80; 0xA30F MOV 2 */
    }

    /* @asm 0xA314..0xA32A  +2 food for special resources 1/9/2 */
    if (center_resource == 1 || center_resource == 9 || center_resource == 2)
        g_table_A891 += 2;                              /* @asm 0xA326 ADD [0xA891],2 */

    /* @asm 0xA32B..0xA342  colony-flag food bonuses (bits 4, 2) */
    if (ctx->flags_at_1c & 4) g_table_A891 += 1;        /* @asm 0xA32F TEST 4; 0xA335 INC */
    if (ctx->flags_at_1c & 2) g_table_A891 += 1;        /* @asm 0xA339 TEST 2; 0xA33F INC */

    /* @asm 0xA343..0xA3A3  scan commodities 1..7 (skip 5=Lumber) for best non-food */
    g_table_A893 = (int8_t)0xFF;                        /* @asm 0xA343 MOV [0xA893],0xFF */
    g_table_A894 = 0;                                   /* @asm 0xA348 */
    {
        int commodity;
        for (commodity = 1; commodity < 8; commodity++) { /* @asm 0xA34D start 1; 0xA36F CMP 8/JGE */
            if (commodity == 5) continue;               /* @asm 0xA375 CMP 5/JE skip (Lumber) */
            /* @asm 0xA37B si=terrain<<4; bx=commodity; base=g_terrain_yield_table[bx+si+0x2F7B] */
            int base = g_terrain_yield_table[terrain * 16 + commodity]; /* RUNTIME_ONLY (data-resident): numeric cells from NAMES.TXT */
            int modifier = feature_yield_bonus(center_resource, commodity); /* @asm 0xA392 CALL 0x9AAA */
            int y;
            if (modifier >= 0) y = base;                /* @asm 0xA39B OR/JGE 0xA354 */
            else               y = base * 2;            /* @asm 0xA39F SHL [bp-6],1 */
            y += modifier;                              /* @asm 0xA354 ADD [bp-6],ax */
            if ((int)(uint8_t)g_table_A894 < y) {       /* @asm 0xA357 al=[0xA894]; CWDE; 0xA35B CMP/JGE keep-max */
                g_table_A893 = (int8_t)commodity;       /* @asm 0xA360..0xA363 */
                g_table_A894 = (uint8_t)y;              /* @asm 0xA366..0xA369 */
            }
        }
    }

    /* @asm 0xA3A4..0xA3D4  post-process best-commodity yield */
    if ((int8_t)g_table_A893 >= 0) {                    /* @asm 0xA3A4 CMP [0xA893],0/JL 0xA3D5 */
        if (g_difficulty_53A6 == 0) g_table_A894 += 1;  /* @asm 0xA3AB CMP [0x53A6],0/JNE; 0xA3B2 INC */
        g_table_A894 += (uint8_t)feature_tier;          /* @asm 0xA3B6 al=[bp-0x12]; 0xA3B9 ADD [0xA894],al */
        if (ctx->flags_at_1c & 4) g_table_A894 += 1;    /* @asm 0xA3C1 TEST 4; 0xA3C7 INC */
        if (ctx->flags_at_1c & 2) g_table_A894 += 1;    /* @asm 0xA3CB TEST 2; 0xA3D1 INC */
    }

    /* ===== Phase B: zero the 20-word commodity accumulator (0..0x13) =====
     * @asm 0xA3D5..0xA3EC.  g_global_amount base = DGROUP:0x8DC8 ([bx-0x7238],
     * bx=i*2).  (This is the zeroing loop the segmentation artifact hid.) */
    {
        int i;
        for (i = 0; i < 0x14; i++) {                    /* @asm 0xA3D5 init 0; 0xA3E8 CMP 0x14/JL 0xA3DA */
            g_global_amount[i] = 0;                     /* @asm 0xA3DF MOV [bx-0x7238],0 (bx=i*2) */
        }
    }

    /* ===== Phase C: apply center-tile yields to the accumulator ===== */
    /* @asm 0xA3EE..0xA3F3  g_global_amount[Food] += g_table_A891 */
    g_global_amount[COMMODITY_FOOD] += (uint8_t)g_table_A891;
    /* @asm 0xA3F7..0xA40C  if best-non-food chosen: g_global_amount[A893] += A894 */
    if ((int8_t)g_table_A893 >= 0) {                    /* @asm 0xA3F7 CMP [0xA893],ah(=0)/JL */
        g_global_amount[(uint8_t)g_table_A893] += (uint8_t)g_table_A894; /* @asm 0xA401 bx=A893*2; 0xA409 ADD */
    }

    /* ===== Phase D: scan the colony's 5x5 surround for production tallies =====
     * @asm 0xA40D..0xA478  outer ring_x 0..4 (0xA46B); inner ring_y 0..4 (0xA417).
     * call is compute_terrain_yield(ring_y=[bp-0x18], ring_x=[bp-0x1a], &good, 1). */
    {
        int ring_x, ring_y;
        for (ring_x = 0; ring_x < 5; ring_x++) {        /* @asm 0xA40D init 0; 0xA46B CMP 5/JGE 0xA478 */
            for (ring_y = 0; ring_y < 5; ring_y++) {    /* @asm 0xA471 init 0; 0xA417 CMP 5/JGE 0xA468 */
                int good_id;                            /* [bp-0x16] */
                int yield = compute_terrain_yield(ring_y, ring_x, &good_id, 1); /* @asm 0xA42A CALL 0x9B9C (args: ring_y, ring_x, &good, 1) */
                if (good_id < 0) continue;              /* @asm 0xA433 CMP [bp-0x16],0/JL 0xA414 */

                /* expert-colonist surplus tracking: job==8 adds to A895 too */
                int match = lookup_byte_from_pair(ring_y, ring_x); /* @asm 0xA440 CALL 0x8956 (ring_y, ring_x) */
                if (ctx->job_at_20[match] == 8) {       /* @asm 0xA44D CMP [bx+si+0x20],8 */
                    g_table_A895 += (uint8_t)yield;     /* @asm 0xA456 ADD [0xA895],al */
                }
                g_global_amount[good_id] += yield;      /* @asm 0xA45D bx=good*2; 0xA462 ADD [bx-0x7238],ax */
            }
        }
    }

    /* ===== Phase E: per-colonist individual-handler pass (bells/crosses) =====
     * @asm 0xA47F..0xA4AE  loop i = 0..colony[+0x1F]-1 */
    {
        int i;
        for (i = 0; i < (int)(uint8_t)ctx->population; i++) { /* @asm 0xA4A3 al=[bx+0x1f]; CWDE; 0xA4AB CMP/JG 0xA480 */
            int meta;                                   /* [bp-0x26] out: output commodity index */
            int unit_yield = unit_individual_handler_9FFC(i, &meta); /* @asm 0xA488 CALL 0x9FFC */
            if (meta >= 0) {                            /* @asm 0xA491 CMP [bp-0x26],0/JL 0xA4A0 */
                g_global_amount[meta] += unit_yield;    /* @asm 0xA497 bx=meta*2; 0xA49C ADD [bx-0x7238],ax */
            }
        }
    }

    /* ===== Phase F: tory / building / founding-father bell multipliers ===== */
    g_8DEA++;                                            /* @asm 0xA4B0 INC [0x8DEA] */
    if (test_building_or_father_bit(0x25)) g_8DEA++;     /* @asm 0xA4B4 PUSH 0x25; CALL 0x863E; 0xA4C1 INC */
    if (test_building_or_father_bit(0x26)) g_8DEA++;     /* @asm 0xA4C5 PUSH 0x26; 0xA4D2 INC */
    g_table_A892 = 0;                                    /* @asm 0xA4D6 MOV [0xA892],0 */
    g_8DEC++;                                            /* @asm 0xA4DB INC [0x8DEC] */

    /* @asm 0xA4DF..0xA4FC  FF op 0xF → +50% on bells (0x8DEC) */
    if (ov_power_flag(ctx->owner_power, 0x0F)) {         /* @asm 0xA4DF PUSH 0xF; LCALL 0x981:0 */
        g_8DEC += g_8DEC >> 1;                           /* @asm 0xA4F7 ax=[0x8DEC]; SHR 1; ADD */
    }
    /* @asm 0xA500..0xA535  FF op 0x11 → +pct% (pct = byte[0x8809 + owner*0x13C]).
     * BYTE-EXACT: the MUL high word is DISCARDED by `SUB dx,dx` (@asm 0xA531)
     * before the DIV, so the product is truncated to 16 bits first. */
    if (ov_power_flag(ctx->owner_power, 0x11)) {         /* @asm 0xA500 PUSH 0x11 */
        int pct = (int)(uint8_t)g_power_byte_8809[ctx->owner_power * 0x13C]; /* @asm 0xA521 IMUL 0x13C; 0xA525 MOV al,[bx-0x77F7]; CWDE */
        uint16_t prod = (uint16_t)(pct * (int)g_8DEC);   /* @asm 0xA52A MUL [0x8DEC] (low16 kept) */
        g_8DEC += prod / 100;                            /* @asm 0xA52E cx=100; 0xA531 SUB dx,dx; 0xA533 DIV; 0xA535 ADD */
    }
    /* @asm 0xA539..0xA57A  FF op 0x12 → +(pop+3)/5 bell bonus, applied ONLY to
     * powers that are NOT active-human, i.e. owner>=4 OR controller!=0.
     * (Contrast sol_membership_pct's op-0x12 +20 which is the OPPOSITE gate —
     * applied only to active-human powers.  Both gates are byte-verified from
     * their own disasm; the asymmetry is real, not a transcription error.) */
    if (ov_power_flag(ctx->owner_power, 0x12)) {         /* @asm 0xA539 PUSH 0x12 */
        int active = (ctx->owner_power < 4 &&            /* @asm 0xA555 CMP [+0x1a],4/JAE 0xA569 */
                      g_power_records[ctx->owner_power][0] == 0); /* @asm 0xA563 CMP byte[owner*0x34+0x543F],0/JE 0xA57E (skip if active) */
        if (!active) {                                   /* bonus applies to owner>=4 OR controller!=0 */
            g_8DEC += ((int)(uint8_t)ctx->population + 3) / 5; /* @asm 0xA571 al=[+0x1f]; ADD 3; cx=5; IDIV */
        }
    }
    g_8DEC += (uint8_t)g_table_A892;                     /* @asm 0xA57E al=[0xA892]; 0xA583 ADD [0x8DEC],ax */

    /* @asm 0xA587..0xA5AC  Fortress(0x14) doubles, else Stockade(0x13) +50% */
    if (test_building_or_father_bit(0x14)) {             /* @asm 0xA587 PUSH 0x14; CALL 0x863E */
        g_8DEC <<= 1;                                    /* @asm 0xA594 SHL [0x8DEC],1 */
    } else if (test_building_or_father_bit(0x13)) {      /* @asm 0xA59A PUSH 0x13 */
        g_8DEC += g_8DEC >> 1;                           /* @asm 0xA5A7 ax=[0x8DEC]; SHR 1; ADD */
    }

    /* ===== Phase G: liberty / rebellion quota =====
     * Two distinct quota values live in the frame and must NOT be merged:
     *   quota_raw    = [bp-0xc]   the liberty-based quota (used for g_8DD8)
     *   quota_capped = [bp-0x22]  = min((surplus+1)/2, quota_raw)
     *                              (used to bound the food-pressure term) */
    /* @asm 0xA5B0..0xA5E8  init both = ceil(liberty/divisor)*2 (0 if liberty<2) */
    int quota_raw = 0;                                   /* [bp-0xc] */
    int quota_capped = 0;                                /* [bp-0x22] */
    if (ctx->liberty_aa >= 2) {                          /* @asm 0xA5B4 CMP [bx+0xaa],2/JL 0xA5E6 */
        int divisor = test_building_or_father_bit(0x11) ? 0x19 : 0x32; /* @asm 0xA5BB MOV 0x19; 0xA5C3 CALL 0x863E; 0xA5CD MOV 0x32 if clear */
        quota_raw = (((int)ctx->liberty_aa + divisor - 1) / divisor) * 2; /* @asm 0xA5D6..0xA5E2 (ceil) *2 */
    }
    quota_capped = quota_raw;                            /* @asm 0xA5E8 [bp-0x22]=ax; 0xA5EB [bp-0xc]=ax */

    /* @asm 0xA5EE..0xA611  pop*2; food SURPLUS over maintenance = max(0,
     * food_accum - pop*2); then quota_capped = min((surplus+1)/2, quota_raw). */
    int pop2 = (int)(uint8_t)ctx->population * 2;        /* @asm 0xA5EE al=[+0x1f]; CWDE; 0xA5F2 SHL 1 -> [bp-4] */
    int food_surplus = (int)g_global_amount[COMMODITY_FOOD] - pop2; /* @asm 0xA5F7 SUB [0x8DC8]; 0xA5FB NEG */
    if (food_surplus < 0) food_surplus = 0;              /* @asm 0xA5FD..0xA601 clamp>=0 -> [bp-8] */
    {
        int half = (food_surplus + 1) >> 1;              /* @asm 0xA606 INC; 0xA607 SAR 1 */
        if (half <= quota_raw) quota_capped = half;      /* @asm 0xA609 CMP [bp-0xc]/JLE; 0xA60E else keep quota_raw -> [bp-0x22] */
    }

    /* @asm 0xA614..0xA62F  pressure = min( max(0, step - liberty), quota_capped ) */
    int turn_step = step_100_or_level_scaled();          /* @asm 0xA615 CALL 0x8D00 -> [bp-0x2a] */
    int pressure = turn_step - (int)ctx->liberty_aa;     /* @asm 0xA61F SUB [bx+0xaa] */
    if (pressure < 0) pressure = 0;                      /* @asm 0xA623 JNS/SUB ax,ax */
    if (pressure > quota_capped) pressure = quota_capped;/* @asm 0xA627 CMP [bp-0x22]/JLE; 0xA62C keep min -> [bp-0x20] */

    /* @asm 0xA632..0xA63F  work-points + Food band target */
    g_8DD8 += (uint16_t)quota_raw;                       /* @asm 0xA632 cx=[bp-0xc]; 0xA635 ADD [0x8DD8],cx */
    g_8E6A = (uint16_t)(quota_raw - pressure);           /* @asm 0xA639 SUB cx,ax; 0xA63B MOV [0x8E6A],cx */
    int food_band = pop2 + pressure;                     /* @asm 0xA63F ADD [bp-4],ax (pop2 + final pressure) */

    /* ===== Phase H: production-chain dispatch (THE SMOKING GUN) =====
     * @asm 0xA642..0xA69C — Food/Lumber/Tools band dispatch + 5 raw->finished. */
    dispatch_via_8e02_with_band(COMMODITY_FOOD,   (uint16_t)food_band); /* @asm 0xA642 PUSH [bp-4]; PUSH 0; CALL 0x8E46 */
    dispatch_via_8e02_with_band(COMMODITY_LUMBER, g_8DE8);             /* @asm 0xA64E PUSH [0x8DE8]; PUSH 5; CALL 0x8E46 */
    update_finished_good_from_raw(COMMODITY_ORE,     COMMODITY_TOOLS); /* @asm 0xA65B PUSH 0xE; PUSH 6; CALL 0x8E84  (6→14) */
    update_finished_good_from_raw(COMMODITY_TOBACCO, COMMODITY_CIGARS);/* @asm 0xA666 PUSH 0xA; PUSH 2 (2→10) */
    update_finished_good_from_raw(COMMODITY_COTTON,  COMMODITY_CLOTH); /* @asm 0xA671 PUSH 0xB; PUSH 3 (3→11) */
    update_finished_good_from_raw(COMMODITY_FURS,    COMMODITY_COATS); /* @asm 0xA67C PUSH 0xC; PUSH 4 (4→12) */
    update_finished_good_from_raw(COMMODITY_SUGAR,   COMMODITY_RUM);   /* @asm 0xA687 PUSH 9;  PUSH 1  (1→9) */
    dispatch_via_8e02_with_band(COMMODITY_TOOLS, g_8DE6);              /* @asm 0xA692 PUSH [0x8DE6]; PUSH 0xE; CALL 0x8E46 */

    /* @asm 0xA69F..0xA6A1  POP SI; LEAVE; RETF */
}

/* ============================================================================
 * compute_colony_center_yields — RETAINED NAME (alias).
 *
 * This was historically modelled as a separate function at 0xA222 that
 * "fell through" into colony_turn_update at 0xA3E1.  The byte trace proves
 * 0xA222..0xA6A1 is a SINGLE function (see the CORRECTION banner at the top).
 * The colony.h decl + callgraph still reference this symbol, and the two
 * near-call sites (0xAC4B, 0xBC01) target 0xA222 — i.e. they call the WHOLE
 * turn update.  So this alias simply runs colony_turn_update().
 * ============================================================================ */
void compute_colony_center_yields(void)
{
    colony_turn_update();   /* @asm 0xA222 is the single entry to the whole body */
}
