/* ============================================================================
 * colony/production_support.c — the colony production-support helper cluster
 * ----------------------------------------------------------------------------
 * These are the small byte-functions that the three big colony-economy
 * functions in turn_update.c (compute_terrain_yield 0x9B9C,
 * compute_colony_center_yields 0xA222, colony_turn_update 0xA3E1) and the
 * per-colonist handler 0x9FFC depend on.  Until now they were declared
 * `extern` in turn_update.c with one-line cites and left UNDEFINED, and the
 * load_image auto-skeleton (src/load_image/load_image_008262_008C6F.c) carried
 * empty `return 0; /* TODO */` stubs.  Here they are hand-ported in full from
 * the VICEROY.EXE bytes (capstone-disassembled, 16-bit real mode), with each
 * basic block cited to its file offset.
 *
 * IDENTIFICATION NOTE (cite-or-not yet decoded honesty): none of these helpers has a
 * direct message-key STRING xref — they are pure bit/table/arithmetic leaves.
 * Their roles are therefore established by (a) byte-trace of the actual
 * instructions and (b) the callgraph (which big colony function calls them and
 * with what arguments).  Where a role is corroborated by a sibling string
 * family it is noted (e.g. the SoL% function feeds the REBELMAJORITY /
 * REBELUNANIMOUS / TORY* message keys in strings.json).
 *
 * --- CITE-OR-NOT-YET-DECODED LEDGER ----------------------------------------
 *  BYTE_VERIFIED (full body decoded; offsets + operand bytes confirmed):
 *    - test_colony_building_bit          0x860E..0x861D  (ColonyRecord bit @ 0x5DCA + idx*0xCA)
 *    - test_building_or_father_bit       0x863E..0x864D  (forwards current-colony idx g_8DC6)
 *    - count_building_chain_present      0x864E..0x8684  (walks g_chain_8F86 stride-12)
 *    - count_building_chain_present_colony 0x8686..0x86BF
 *    - building_chain_walk_to_top        0x86C0..0x86E2
 *    - highest_building_chain_bit_set    0x86E4..0x871F  (= the old highest_building_le)
 *    - sol_membership_pct (rebel_sentiment_pct) 0x8524..0x85B1  ((C2*100)/C6, +20 FF, clamp 100)
 *    - lookup_signed_2F4                 0x8D9C..0x8DBA  (signed byte DGROUP:0x2F4[idx], -1 if>=0x13)
 *    - commodity_net_minus_chain (func_008DBC) 0x8DBC..0x8E00
 *    - update_finished_good_from_raw     0x8E84..0x8F01  (raw->finished band + over_high tracking)
 *  RUNTIME_ONLY (data-resident; values live in NAMES.TXT / overlay, not in the EXE here):
 *    - the NUMERIC contents of DGROUP:0x2F4 (chain-start building id per good)
 *    - the NUMERIC contents of DGROUP:0x2A2 (related-commodity id per good)
 *    - the contents of the stride-12 chain table at DGROUP:0x8F86
 *    - which @BUILDING level a chain count of >2 corresponds to
 *    - the writer of g_8DC6 (current-colony index) is overlay-resident (body in thunk page)
 * ---------------------------------------------------------------------------
 *
 * @ref code/VICEROY/disasm/func_008524_unknown.asm
 * @ref code/VICEROY/disasm/func_00860E_unknown.asm
 * @ref code/VICEROY/disasm/func_00863E_wrapper_with_global_8DC6.asm
 * @ref code/VICEROY/disasm/func_00864E_unknown.asm
 * @ref code/VICEROY/disasm/func_0086E4_unknown.asm
 * @ref code/VICEROY/disasm/func_008D9C_lookup_table_2F4_signed.asm
 * @ref code/VICEROY/disasm/func_008E84_unknown.asm
 * (full bodies re-disassembled from COLONIZE/VICEROY.EXE; the *.asm files were
 *  truncated by the auto-segmenter — boundaries here come from the true
 *  ENTER/PUSH-BP prologues and RETF terminals + functions.json sizes.)
 * ============================================================================ */
#include "viceroy.h"

/* ----------------------------------------------------------------------------
 * Data tables touched by this cluster (byte-verified addresses; values RUNTIME_ONLY (data-resident)).
 * ---------------------------------------------------------------------------- */

/* The persistent ColonyRecord bit-array base: test_colony_building_bit reads
 * byte[ (bit_idx>>3) + colony_idx*0xCA + 0x5DCA ].  0xCA = 202 = ColonyRecord
 * stride; 0x5DCA is the bit-array field inside that record (the colony table
 * base is DGROUP:0x5D46/0x5D60 per VERIFICATION_LEDGER; 0x5DCA is +0x6A..+0x84
 * into the record — the building/feature bit-array).
 * @asm 0x8629: MOV al, byte ptr [bx + si + 0x5dca]   (bytes 8A 80 CA 5D) */
extern uint8_t g_colony_bits_5DCA[];      /* DGROUP:0x5DCA, indexed [colony_idx*0xCA + byteoff] */

/* current-colony INDEX (NOT the working-buffer far ptr at 0x8542).  This is the
 * table row that test_building_or_father_bit implicitly targets.
 * @asm 0x8644: PUSH word ptr [0x8dc6]   (bytes FF 36 C6 8D)
 * Writer is overlay-resident (set when a colony is selected/entered) — body in thunk page. */
extern uint16_t g_8DC6;                   /* DGROUP:0x8DC6 */

/* Stride-12 building-prerequisite/upgrade chain table.  Each link's byte[0]
 * (= byte[idx*12]) is the NEXT chain id (signed; <0 ends the chain).
 * @asm 0x8674/0x86AF/0x86DA/0x870D: MOV al, byte ptr [bx - 0x707a] with
 *      bx = (idx*3)<<2 = idx*12, and (0x10000-0x707a)=0x8F86.
 * Declared in globals.h as g_table_8F86_stride12[]. */
#define g_chain_next(idx)  (g_table_8F86_stride12[(idx) * 12])

/* signed-byte table at DGROUP:0x2F4 — per-good "chain-start building id".
 * @asm 0x8DAE: MOV al, byte ptr [bx + 0x2f4]   (bytes 8A 87 F4 02) */
extern int8_t  g_byte_2F4[];              /* DGROUP:0x2F4 */

/* signed-byte table at DGROUP:0x2A2 — per-good "related raw commodity id".
 * @asm 0x8DDA: MOV al, byte ptr [bx + 0x2a2]   (bytes 8A 87 A2 02) */
extern int8_t  g_byte_2A2[];              /* DGROUP:0x2A2 */

/* ============================================================================
 * test_colony_building_bit — 16 bytes
 *
 * @asm 0x00860E..0x0086_1D  PUSH BP / MOV BP,SP / PUSH SI ... POP SI / LEAVE / RETF
 *
 * Tests bit `bit_idx` of the building/feature bit-array inside ColonyRecord
 * number `colony_idx` (persistent table, stride 0xCA, bit-array at +0x5DCA).
 *
 * Args (cdecl; first declared param = lowest stack slot):
 *   bit_idx    = [bp+8]   the bit index (building / founding-father flag id)
 *   colony_idx = [bp+6]   which colony record (0-based table row)
 * Returns: AX = (byte & mask)  — nonzero if the bit is set, 0 otherwise.
 *          Returns 0 immediately when bit_idx < 0.
 *
 * @asm 0x8612: CMP word ptr [bp+8],0 / JGE          (bit_idx<0 → return 0)
 * @asm 0x861E: IMUL si, [bp+6], 0xCA                (colony_idx * 202)
 * @asm 0x8623: SAR bx,3  (bx=[bp+8]>>3)             (byte index = bit_idx/8)
 * @asm 0x8629: MOV al, byte[bx+si+0x5DCA]           (the bit-array byte)
 * @asm 0x862E: CL=[bp+8]&7; DX=1<<CL; AX &= DX      (isolate the bit)
 * ============================================================================ */
int test_colony_building_bit(int bit_idx, int colony_idx)
{
    if (bit_idx < 0) return 0;                         /* @asm 0x8612/0x8616 */
    int byte_off = (colony_idx * 0xCA) + (bit_idx >> 3); /* @asm 0x861E/0x8623 (SAR is arithmetic) */
    uint8_t b = g_colony_bits_5DCA[byte_off];          /* @asm 0x8629 */
    return b & (1u << (bit_idx & 7));                  /* @asm 0x862E..0x8639 */
}

/* ============================================================================
 * test_building_or_father_bit — 16 bytes
 *
 * @asm 0x00863E..0x00864D  PUSH-BP-MOV-BP-SP ... CALL 0x860E / LEAVE / RETF
 *
 * Thin wrapper: tests bit `bit_idx` in the CURRENT colony (index g_8DC6).
 * This is the form every colony-economy function calls (9 call sites incl.
 * colony_turn_update 0xA3E1, compute_terrain_yield 0x9B9C, 0x9FFC).
 *
 * @asm 0x8641: PUSH [bp+6]      (bit_idx → 2nd arg of 0x860E)
 * @asm 0x8644: PUSH [0x8DC6]    (current colony idx → 1st arg)
 * @asm 0x8649: CALL 0x860E
 * ============================================================================ */
int test_building_or_father_bit(int bit_idx)
{
    return test_colony_building_bit(bit_idx, (int)g_8DC6); /* @asm 0x8641..0x8649 */
}

/* ============================================================================
 * count_building_chain_present — 55 bytes
 *
 * @asm 0x00864E..0x008684  ENTER 2 / ... / LEAVE / RETF
 *
 * Walks the building-prerequisite chain starting at `start_idx`, counting how
 * many links along the chain have their bit set in the CURRENT colony.  The
 * chain is g_table_8F86_stride12: from a link `i`, the next link is the signed
 * byte g_chain_next(i); a negative value terminates the walk.
 *
 * @asm 0x8652: tally = 0
 * @asm 0x8657: loop head — PUSH [bp+6]; CALL 0x863E (test current-colony bit)
 * @asm 0x8661: OR ax,ax / JE → if set, INC tally  (@asm 0x8665)
 * @asm 0x8668: bx = [bp+6]; bx = (bx + bx*2) ... actually bx=idx; AX=idx;
 *              bx=(idx<<1)+idx=idx*3; bx<<=2 → idx*12; al=byte[bx-0x707a]=chain_next
 * @asm 0x8679: [bp+6] = chain_next  (CWDE sign-extend)
 * @asm 0x867C: OR ax,ax / JGE 0x8657  (continue while chain_next >= 0)
 * Returns tally.
 *
 * NOTE: the caller update_finished_good_from_raw treats `count > 2` as the
 *       "factory present" threshold (@asm 0x8EA9 CMP ax,2 / JLE).
 * ============================================================================ */
int count_building_chain_present(int start_idx)
{
    int tally = 0;                                     /* @asm 0x8652 */
    int idx = start_idx;
    for (;;) {
        if (test_building_or_father_bit(idx))          /* @asm 0x8657..0x865E CALL 0x863E */
            tally++;                                   /* @asm 0x8665 INC */
        int next = g_chain_next(idx);                  /* @asm 0x8668..0x8674 byte[idx*12 + 0x8F86] */
        if (next < 0) break;                           /* @asm 0x867C OR/ JGE-continue */
        idx = next;                                    /* @asm 0x8679 store back */
    }
    return tally;                                      /* @asm 0x8680 */
}

/* ============================================================================
 * count_building_chain_present_colony — 58 bytes
 *
 * @asm 0x008686..0x0086BF  ENTER 2 / ... / LEAVE / RETF
 *
 * Same chain walk as 0x864E but for an arbitrary colony (calls the 2-arg
 * 0x860E with (start_idx, colony_idx)).  No load_image caller in the callgraph
 * (callers are overlay-resident → not yet decoded); the body is fully byte-verified.
 *
 * @asm 0x868F: PUSH [bp+8]; PUSH [bp+6]; CALL 0x860E   (test_colony_building_bit(bit=[bp+8], col=[bp+6]))
 * @asm 0x86A3: chain walk via [bp+8] = g_chain_next([bp+8])
 * ============================================================================ */
int count_building_chain_present_colony(int colony_idx, int start_idx)
{
    int tally = 0;                                     /* @asm 0x868A */
    int idx = start_idx;
    for (;;) {
        if (test_colony_building_bit(idx, colony_idx)) /* @asm 0x868F..0x8699 CALL 0x860E */
            tally++;                                   /* @asm 0x86A0 */
        int next = g_chain_next(idx);                  /* @asm 0x86A3..0x86AF */
        if (next < 0) break;                           /* @asm 0x86B7 */
        idx = next;                                    /* @asm 0x86B4 */
    }
    return tally;                                      /* @asm 0x86BB */
}

/* ============================================================================
 * building_chain_walk_to_top — 19 bytes
 *
 * @asm 0x0086C0..0x0086E2  PUSH-BP-MOV-BP-SP / ... / LEAVE / RETF
 *
 * Follows the chain from `start_idx` (in [bp+6]) to its end (no bit test),
 * returning the last index reached (the value held in [bp+6] when chain_next
 * first goes negative).  No load_image caller (overlay-resident → not yet decoded).
 *
 * @asm 0x86C3: JMP into the test at 0x86CE
 * @asm 0x86C6: [bp+6] = chain_next  (loop body)
 * @asm 0x86CE: bx = [bp+6]; bx=idx*12; CMP byte[bx-0x707a],0 / JGE 0x86C6
 * @asm 0x86E1: LEAVE/RETF — the function value in AX is the last chain_next
 *              that was >= 0 (= the final idx) WHEN the loop ran at least once.
 *
 * EDGE-CASE [not yet decoded]: the prologue JMPs straight to the test (0x86C3 → 0x86CE), so
 *   if chain_next(start_idx) < 0 on the very first read the loop body never runs
 *   and AX is left UNINITIALIZED (whatever the caller passed in).  We return
 *   start_idx in that case — a defined approximation; the original's value there
 *   is indeterminate.  Harmless because the only-known use of a chain walk feeds
 *   indices that have a non-terminal first link.  No load_image caller (callers
 *   overlay-resident → role not yet decoded).
 * ============================================================================ */
int building_chain_walk_to_top(int start_idx)
{
    int idx = start_idx;
    while (g_chain_next(idx) >= 0) {                   /* @asm 0x86CE..0x86DF */
        idx = g_chain_next(idx);                       /* @asm 0x86C6..0x86CB */
    }
    return idx;
}

/* ============================================================================
 * highest_building_chain_bit_set — 28 bytes  (was: highest_building_le)
 *
 * @asm 0x0086E4..0x00871F  ENTER 4 / ... / LEAVE / RETF
 *
 * Walks the chain from `start_idx`; returns the index of the HIGHEST link
 * whose bit is set in the current colony, or -1 if none is set.  Sole
 * load_image caller is unit_individual_handler_9FFC (0x9FFC).
 *
 * @asm 0x86E8: result = 0xFFFF (-1)
 * @asm 0x86ED: JMP to test at 0x8715
 * @asm 0x86F0: loop body — PUSH [bp+6]; CALL 0x863E
 * @asm 0x86FA: OR ax,ax / JE 0x871B (bit not set → stop, keep prior result)
 * @asm 0x86FE: result = [bp+6]  (this link's index)
 * @asm 0x8704: [bp+6] = g_chain_next([bp+6])
 * @asm 0x8715: CMP [bp+6],0 / JGE 0x86F0  (continue while next >= 0)
 * Returns result.
 * ============================================================================ */
int highest_building_chain_bit_set(int start_idx)
{
    int result = -1;                                   /* @asm 0x86E8 */
    int idx = start_idx;
    while (idx >= 0) {                                 /* @asm 0x8715 */
        if (!test_building_or_father_bit(idx))         /* @asm 0x86F0..0x86FC */
            break;                                     /* @asm 0x86FC JE → 0x871B (stop) */
        result = idx;                                  /* @asm 0x86FE..0x8701 */
        idx = g_chain_next(idx);                       /* @asm 0x8704..0x8712 */
    }
    return result;                                     /* @asm 0x871B */
}

/* Compatibility aliases for the names turn_update.c / data/production.c already
 * reference (one-line cites there).  building_present_count(bit) was documented
 * as "0 or 1" but the byte trace shows it is the chain-present COUNT; we keep
 * the alias mapping to the verified body and leave the corrected semantics in
 * the comment above so callers see the truth. */
int building_present_count(int bit_idx) { return count_building_chain_present(bit_idx); }
int highest_building_le(int bit_idx)    { return highest_building_chain_bit_set(bit_idx); }

/* ============================================================================
 * sol_membership_pct — 142 bytes   (the function turn_update.c calls
 *                                   rebel_sentiment_pct; 0x8524)
 *
 * @asm 0x008524..0x0085B1  ENTER 0xA / ... / LEAVE / RETF
 *
 * Computes the colony's Sons-of-Liberty membership percentage from the two
 * 32-bit accumulators in the working-buffer colony struct:
 *   A = colony[+0xC2..+0xC5]   (bells accumulated)        @asm 0x8531/0x8535
 *   B = colony[+0xC6..+0xC9]   (bells threshold / divisor) @asm 0x8542/0x8539
 * If B <= 0 the percentage is 0; otherwise pct = (A * 100) / B via the MSC 6.0
 * 32-bit long mul/div runtime helpers, then a +20 founding-father bonus, then
 * clamp to 100.
 *
 * @asm 0x8528: result = 0
 * @asm 0x852D: bx = *(0x8542) (the working colony far ptr base, via DS)
 * @asm 0x8531: AX = colony[+0xC2]; @asm 0x8535: DX = colony[+0xC4]   (A, lo/hi)
 * @asm 0x8539: CMP colony[+0xC8],0 / JL 0x8566 (B negative→pct stays 0)
 * @asm 0x853E: JG 0x8549 (B hi>0 → divide); else CMP colony[+0xC6],0 / JE→pct 0
 * @asm 0x8549: PUSH B.hi, B.lo, 0, 0x64(=100), A.hi(dx), A.lo(ax)
 * @asm 0x8557: LCALL 0xD1D:0xF60   (= __aFlmul-style: (A) * 100, 32-bit)
 * @asm 0x855E: LCALL 0xD1D:0xEC6   (= __aFldiv-style: product / B, 32-bit)
 * @asm 0x8563: result = AX  (the quotient = pct)
 * @asm 0x8569: pct_out = result   ([bp-6])
 * @asm 0x856C: PUSH 0x12; PUSH colony[+0x1A](owner); LCALL 0x981:0  (FF op 0x12 test)
 * @asm 0x8580: OR ax,ax / JE 0x85A5 (no FF → skip bonus)
 * @asm 0x8588: CMP colony[+0x1A],4 / JAE 0x85A5 (owner must be a real power 0..3)
 * @asm 0x8593: IMUL bx, owner, 0x34; CMP byte[bx+0x543F],ah(=0) / JNE 0x85A5
 *              (controller byte must be 0 → human/active power)
 * @asm 0x859C: pct_out += 0x14  (+20)
 * @asm 0x85A5: if (pct_out > 100) pct_out = 100   (@asm 0x85A8 CMP 0x64 / MOV 0x64)
 * Returns pct_out.
 *
 * ROLE CORROBORATION: this is the SoL membership %, the input to the
 * REBELMAJORITY / REBELUNANIMOUS / TORYMINORITY / TORYMAJORITY / REBELUP* /
 * REBELDOWN message keys (strings.json).  The +20 bonus matches the founding
 * father (Jan de Witt, op 0x12 in the per-power FF flag-test 0x981:0).
 *
 * ARITHMETIC NOTE: the *100 and /B are literal in the call sequence (PUSH 0x64
 *   = 100; the two D1D long-math thunks).  The exact MSC helper at 0xD1D:0xF60
 *   / 0xEC6 are runtime long mul/div (see D1D_181F_RUNTIME.md); their identity
 *   is BYTE-cited at the call site, their internal bodies are runtime-resident.
 * ============================================================================ */
extern long  ov_long_mul_F60(long a, int zero, int hundred); /* LCALL 0xD1D:0xF60 — 32-bit multiply */
extern long  ov_long_div_EC6(long product, long divisor);    /* LCALL 0xD1D:0xEC6 — 32-bit divide   */
extern int   ov_power_flag(int owner, int op_id);            /* LCALL 0x981:0 — per-power FF/flag test */

int sol_membership_pct(void)
{
    int pct = 0;                                       /* @asm 0x8528 result=0 */

    /* @asm 0x852D..0x8547  read the two 32-bit accumulators from the colony
     * struct.  A = bells numerator [+0xC2]/[+0xC4]; B = threshold [+0xC6]/[+0xC8]. */
    uint32_t A = ((uint32_t)ctx->field_at_c4 << 16) | ctx->field_at_c2;   /* @asm 0x8531/0x8535 */
    uint32_t B = ((uint32_t)ctx->cumulative_c8 << 16) | ctx->cumulative_c6; /* @asm 0x8539/0x8542 */

    if ((int32_t)B > 0) {                              /* @asm 0x8539..0x8547 (B<=0 → pct 0) */
        long product = ov_long_mul_F60((long)A, 0, 100); /* @asm 0x8557 LCALL 0xD1D:0xF60 (A*100) */
        pct = (int)ov_long_div_EC6(product, (long)B);  /* @asm 0x855E LCALL 0xD1D:0xEC6 (/B) */
    }

    /* @asm 0x856C..0x85A2  founding-father (op 0x12) +20 bonus */
    if (ov_power_flag(ctx->owner_power, 0x12)) {       /* @asm 0x8578 LCALL 0x981:0 */
        if (ctx->owner_power < 4 &&                    /* @asm 0x8588 CMP [+0x1A],4 / JAE */
            g_power_records[ctx->owner_power][0] == 0) /* @asm 0x8596 CMP byte[owner*0x34+0x543F],0 / JNE */
        {
            pct += 0x14;                               /* @asm 0x859F ADD 0x14 (+20) */
        }
    }

    if (pct > 100) pct = 100;                          /* @asm 0x85A8 clamp */
    return pct;                                        /* @asm 0x85A5 */
}

/* Alias for the name turn_update.c already calls. */
int rebel_sentiment_pct(void) { return sol_membership_pct(); }

/* ============================================================================
 * lookup_signed_2F4 — 31 bytes
 *
 * @asm 0x008D9C..0x008DBA  ENTER 2 / ... / LEAVE / RETF
 *
 * Returns the signed byte g_byte_2F4[index] sign-extended, or -1 when
 * index >= 0x13 (out of the 0..0x12 commodity/good domain).  In the production
 * pipeline this gives the "chain-start building id" for a finished good
 * (passed to count_building_chain_present by update_finished_good_from_raw).
 *
 * @asm 0x8DA0: result = -1
 * @asm 0x8DA5: CMP [bp+6],0x13 / JGE 0x8DB6 (out of range → keep -1)
 * @asm 0x8DAB: bx=[bp+6]; al = byte[bx+0x2F4]; CWDE; result = ax
 * Returns result.
 * ============================================================================ */
int lookup_signed_2F4(int index)
{
    if (index >= 0x13) return -1;                      /* @asm 0x8DA5/0x8DA9 */
    return (int)(int8_t)g_byte_2F4[index];             /* @asm 0x8DAE CWDE (signed) */
}

/* ============================================================================
 * commodity_net_minus_chain — 69 bytes   (func_008DBC; no name in inventory)
 *
 * @asm 0x008DBC..0x008E00  ENTER 2 / ... / LEAVE / RETF
 *
 * Returns the "net produced minus boycott/overflow chain" amount for commodity
 * `idx`, optionally writing the subtracted over_high term through out_ptr:
 *   net = g_global_amount[idx] - g_band_base[idx]
 *   rel = g_byte_2A2[idx]                 (related raw commodity; signed)
 *   if (rel >= 0):
 *       net -= g_over_high[rel]
 *       if (out_ptr) *out_ptr = g_over_high[rel]
 *   return net
 *
 * @asm 0x8DC0: bx=[bp+6]<<1; AX = g_global_amount[idx] (DGROUP:0x8DC8)
 * @asm 0x8DC9: AX -= g_band_base[idx]  (DGROUP:0x8E0A, [bx-0x71F6])
 * @asm 0x8DD0: bx=[bp+6]; CMP byte[bx+0x2A2],0 / JL 0x8DFC (rel<0 → skip)
 * @asm 0x8DDA: rel = byte[bx+0x2A2] (CWDE); bx=rel<<1; AX -= g_over_high[rel]
 * @asm 0x8DED: CMP [bp+8],0 / JE 0x8DFC; else *[bp+8] = g_over_high[rel]
 * Returns AX.
 *
 * No load_image caller (callers overlay-resident, e.g. Europe market screen → not yet decoded);
 * body fully byte-verified.
 * ============================================================================ */
int commodity_net_minus_chain(int idx, uint16_t far *out_ptr)
{
    int net = (int)g_global_amount[idx] - (int)g_band_base[idx]; /* @asm 0x8DC0..0x8DCD */
    int rel = (int)(int8_t)g_byte_2A2[idx];                      /* @asm 0x8DD3..0x8DDE */
    if (rel >= 0) {                                              /* @asm 0x8DD3 JL skip */
        net -= (int)g_over_high[rel];                            /* @asm 0x8DE6 */
        if (out_ptr) *out_ptr = g_over_high[rel];                /* @asm 0x8DED..0x8DFA */
    }
    return net;                                                 /* @asm 0x8DFC */
}

/* ============================================================================
 * update_finished_good_from_raw — 126 bytes   (THE per-chain production step)
 *
 * @asm 0x008E84..0x008F01  ENTER 6 / ... / LEAVE / RETF
 *
 * Called five times by colony_turn_update (0xA3E1) — once per raw->finished
 * chain (Ore->Tools, Tobacco->Cigars, Cotton->Cloth, Furs->Coats, Sugar->Rum).
 *
 * Args (cdecl; byte-verified from the call sites @asm 0xA65B `PUSH 0xE; PUSH 6`):
 *   raw_id      = [bp+6]   the source commodity (6=Ore, 2=Tobacco, ...)
 *   finished_id = [bp+8]   the manufactured output (0xE=Tools, 0xA=Cigars, ...)
 *
 * Body:
 *   amt   = g_global_amount[finished_id]              @asm 0x8E88 (DGROUP:0x8DC8)
 *   conv  = amt                                       @asm 0x8E91/0x8E94 ([bp-6],[bp-4])
 *   chain = lookup_signed_2F4(finished_id)            @asm 0x8E9B CALL 0x8D9C
 *   level = count_building_chain_present(chain)       @asm 0x8EA3 CALL 0x864E
 *   if (level > 2)  conv = (conv * 2) / 3             @asm 0x8EA9 CMP 2/JLE; 0x8EB1 SHL; cx=3; IDIV
 *   dispatch_via_8e02_with_band(raw_id, conv)         @asm 0x8EC3 CALL 0x8E46
 *   // surplus carry on the RAW commodity's over_high slot (DGROUP:0x8E5A):
 *   if (g_over_high[raw_id] != 0 && amt != conv) {     @asm 0x8ECE..0x8EDB
 *       if (g_over_high[raw_id] != conv)               @asm 0x8EDD CMP/JNE
 *           g_over_high[raw_id] = (g_over_high[raw_id]*3)/2 ... // @asm 0x8EED..0x8EFC
 *       else
 *           g_over_high[raw_id] = amt;                 @asm 0x8EE3 (returns/stores [bp-6])
 *   }
 *
 * VERIFIED ratios: the ×2/3 cap (when chain level > 2, i.e. a factory-tier
 *   building is present) and the ×3/2 surplus rescale are literal in the
 *   instruction stream (SHL ax,1 → ×2 ; MOV cx,3 ; IDIV ; and ADD ax,cx+SAR for
 *   ×3 then SAR ÷2).  Which @BUILDING the >2 chain-count corresponds to is the
 *   RUNTIME_ONLY (data-resident): @BUILDING column in NAMES.TXT determines exact chain-count threshold.
 *
 * Reconciliation of the 0x8EED..0x8EFA tail (×3/2): the bytes are
 *   cx=ax; ax<<=1 (×2); ax+=cx (×3); cdq; ax-=dx; sar ax,1 (÷2 with round-toward
 *   -inf correction) → ax = (over_high*3)/2.  Stored to g_over_high[raw_id].
 * ============================================================================ */
void update_finished_good_from_raw(int raw_id, int finished_id)
{
    uint16_t amt  = g_global_amount[finished_id];      /* @asm 0x8E88 */
    int      conv = (int)amt;                          /* @asm 0x8E94 [bp-4] */

    int chain = lookup_signed_2F4(finished_id);        /* @asm 0x8E9B CALL 0x8D9C */
    int level = count_building_chain_present(chain);   /* @asm 0x8EA3 CALL 0x864E */
    if (level > 2) {                                   /* @asm 0x8EA9 CMP ax,2 / JLE */
        conv = (conv * 2) / 3;                         /* @asm 0x8EB1 SHL; cx=3; IDIV */
    }

    dispatch_via_8e02_with_band(raw_id, (uint16_t)conv); /* @asm 0x8EBC..0x8EC3 (raw_id, conv) */

    /* surplus carry on the raw commodity's over_high slot */
    if (g_over_high[raw_id] != 0 && (int)amt != conv) {  /* @asm 0x8ECE..0x8EDB */
        if ((int)g_over_high[raw_id] != conv) {          /* @asm 0x8EDD CMP/JNE */
            int v = (int)g_over_high[raw_id];
            g_over_high[raw_id] = (uint16_t)((v * 3) / 2); /* @asm 0x8EED..0x8EFC ×3 then ÷2 */
        } else {
            g_over_high[raw_id] = amt;                   /* @asm 0x8EE3 → [bp-6] = amt */
        }
    }
}
