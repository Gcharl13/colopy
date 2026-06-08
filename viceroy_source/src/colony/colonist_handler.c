/* ============================================================================
 * colony/colonist_handler.c — per-colonist bell/cross/manufactured-goods producer
 * ----------------------------------------------------------------------------
 * unit_individual_handler_9FFC (file 0x9FFC..0xA221, 550 bytes)
 *
 * Called once per colonist by colony_turn_update Phase E (0xA47F..0xA4AE).
 * Dispatches on the colonist's job byte (values 9..17) and returns a yield
 * amount + output commodity index via *meta.  Colonists with jobs outside
 * 9..17 (terrain workers) have no individual-handler output; their yields come
 * from the terrain-yield scan (Phase D / compute_terrain_yield 0x9B9C).
 *
 * Jump table at CS:0x1F44 (CS base = file 0x82B0, table at file 0xA1F4):
 *   @asm 0xA1EF: 2e ff a7 44 1f   JMP WORD PTR CS:[BX+0x1F44]
 *   File 0xA1F4, 18 bytes, 9 × 2-byte LE CS-relative words:
 *     job index  0..3,5,6 (jobs 9..12,14,15) → CS:0x1ED8 = file 0xA188 (manufactured)
 *     job index  4        (job 13)            → CS:0x1E50 = file 0xA100 (Liberty Bells)
 *     job index  7        (job 16)            → CS:0x1E82 = file 0xA132 (Crosses)
 *     job index  8        (job 17)            → CS:0x1F18 = file 0xA1C8 (Liberty Flags)
 *
 * @ref code/VICEROY/disasm/func_009FFC_unknown.asm
 *
 * --- CITE-OR-TBD LEDGER ---------------------------------------------------
 *  BYTE_VERIFIED (offset + operand bytes confirmed in COLONIZE/VICEROY.EXE):
 *    0x9FFC: c8 1c 00 00             ENTER 0x1c,0
 *    0xA000: CALL 0x90C8             get job byte (current_unit_field_at_20)
 *    0xA00D: CALL 0x9102             get field40  (current_unit_field_at_40)
 *    0xA02A: CALL 0x8524             sol_membership_pct
 *    0xA0BD: c7 46 e8 ff ff          meta_out = -1 (default)
 *    0xA100: c7 46 e8 10 00          job 13 → meta_out = 0x10 (Liberty Bells)
 *    0xA144: c7 46 e8 11 00          job 16 → meta_out = 0x11 (Crosses)
 *    0xA1D1: c7 46 e8 12 00          job 17 → meta_out = 0x12 (Liberty Flags)
 *    0xA1EF: 2e ff a7 44 1f          JMP CS:[BX+0x1F44] dispatch
 *    0xA1F4: d8 1e d8 1e d8 1e d8 1e 50 1e d8 1e d8 1e 82 1e 18 1f  (jump table, 18 bytes)
 *    0xA206: 83 7e 08 00             CMP [bp+8],0  (NULL guard before *meta write)
 *    0xA217: 0b c0                   OR ax,ax (yield clamp >=0 gate)
 *    0xA221: cb                      RETF
 *  TBD:
 *    exact game-mechanic meaning of meta_out 0x12 ("Liberty Flags" — working name)
 *    ov_power_flag op 0x15 founding-father identity (Crosses +50% bonus)
 * ============================================================================ */
#include "viceroy.h"

/* Overlay-resident; call site byte-verified at 0xA15F (LCALL 0x981:0x00) */
extern int ov_power_flag(int owner, int op_id);

/* ============================================================================
 * unit_individual_handler_9FFC — per-colonist building-output engine
 *
 * @asm 0x009FFC..0x00A221  ENTER 0x1c,0 / POP SI / LEAVE / RETF
 *
 * Args (cdecl, confirmed from Phase-E call site @asm 0xA488):
 *   colonist_idx = [bp+6]   which colonist (0..population-1)
 *   meta         = [bp+8]   out-pointer; receives the output commodity index,
 *                           or -1 if this colonist produces no individual yield
 * Returns: AX = yield amount (clamped >=0 before return).
 *
 * Stack-frame locals (ENTER 0x1c = 28 bytes):
 *   [bp-0x1c] job_byte   [bp-0x1a] field40   [bp-0x18] is_profmatch
 *   [bp-0x16] tory_pct   [bp-0x14] tory_cnt  [bp-0x12] active
 *   [bp-0x10] divisor    [bp-0x0e] sol_adj    [bp-0x0c] base_mult
 *   [bp-0x0a] chain_id   [bp-0x08] (highest; result discarded)
 *   [bp-0x06] yield      [bp-0xe8] meta_out   (e8 = signed -0x18)
 * ============================================================================ */
int unit_individual_handler_9FFC(int colonist_idx, int *meta)
{
    int base_mult;

    /* @asm 0xA000 CALL 0x90C8  (= current_unit_field_at_20) */
    int job_byte = current_unit_field_at_20(colonist_idx);
    /* @asm 0xA00D CALL 0x9102  (= current_unit_field_at_40) */
    int field40  = current_unit_field_at_40(colonist_idx);
    /* @asm 0xA01A CMP ax,[bp-0x1c] → is_profmatch */
    int is_profmatch = (field40 == job_byte) ? 1 : 0;

    /* ---- SoL/Tory penalty (same formula as compute_terrain_yield) ---- */
    /* @asm 0xA02A CALL 0x8524 */
    int sol_pct  = sol_membership_pct();
    /* @asm 0xA030..0xA036 */
    int tory_pct = 100 - sol_pct;
    /* @asm 0xA03A: al=[bx+0x1f] (population); 0xA03E IMUL; 0xA040 ADD 0x32; 0xA045 IDIV */
    int pop      = (int)(uint8_t)ctx->population;
    int tory_cnt = (pop * tory_pct + 0x32) / 100;
    /* @asm 0xA048 CMP [+0x1a],4/JAE; 0xA056 CMP byte[owner*0x34+0x543F],0/JNE */
    int active   = (ctx->owner_power < 4 &&
                    g_power_records[ctx->owner_power][0] == 0);
    /* @asm 0xA05C MOV al,[0x53a6]; SUB 0xa; NEG  →  10 - difficulty */
    int divisor  = active ? (0xA - (int)g_difficulty_53A6) : 0xA;
    /* @asm 0xA087 — tory penalty only applies to active (human) colonies */
    if (!active) tory_cnt = 0;
    /* @asm 0xA08A CDQ; 0xA08C IDIV [bp-0x10]; 0xA08F NEG ax */
    int sol_adj  = -(tory_cnt / divisor);
    /* @asm 0xA09C TEST [+0x1c],4; 0xA0A2 INC */
    if (ctx->flags_at_1c & 4) sol_adj++;
    /* @asm 0xA0A6 TEST [+0x1c],2; 0xA0AC INC */
    if (ctx->flags_at_1c & 2) sol_adj++;

    /* ---- fallback yield and default meta ---- */
    /* @asm 0xA0B3 SBB ax,ax; 0xA0B5 AND al,0xfe; 0xA0B7 ADD ax,3  →  1 or 3 */
    int yield    = is_profmatch ? 3 : 1;
    /* @asm 0xA0BD: c7 46 e8 ff ff */
    int meta_out = -1;

    /* @asm 0xA0C6 CALL 0x8D9C  (lookup_signed_2F4) */
    int chain_id = lookup_signed_2F4(job_byte);
    /* @asm 0xA0D1 CALL 0x86E4  (highest_building_chain_bit_set; return value discarded) */
    highest_building_chain_bit_set(chain_id);

    /* ---- base_mult from field40 unit-type tier ----
     * @asm 0xA0DA SUB [bp-0x1a],0x19; 0xA0DE JE +2; 0xA0E0 JL +3; 0xA0E2 CMP 2; JLE +1; else +3 */
    {
        int fx = field40 - 0x19;
        if      (fx == 0) base_mult = 2;   /* field40 == 0x19 (Indentured Servant) */
        else if (fx <  0) base_mult = 3;   /* field40  < 0x19 (Free Colonist class) */
        else if (fx <= 2) base_mult = 1;   /* field40 == 0x1A or 0x1B (lowest tier)  */
        else              base_mult = 3;   /* field40 >= 0x1C (Expert class)          */
    }

    /* ---- dispatch on job_byte ----
     * @asm 0xA1E4: SUB ax,9; CMP ax,8; JA 0xA206 (exit); JMP CS:[BX+0x1F44] */
    if (job_byte < 9 || job_byte > 17) goto exit_handler;

    switch (job_byte) {

    case 13:  /* Liberty Bells — Town Hall workers */
        /* @asm 0xA100: c7 46 e8 10 00 */
        meta_out = 0x10;
        /* @asm 0xA105..0xA113: profmatch → 6, else base_mult */
        yield    = is_profmatch ? 6 : base_mult;
        /* @asm 0xA116..0xA119 */
        yield   += sol_adj;
        /* @asm 0xA11C push 0x24; CALL 0x863E; 0xA127 OR ax,ax; JNE 0xA12C; SHL */
        if (test_building_or_father_bit(0x24)) yield <<= 1;
        break;

    case 16:  /* Crosses — Church workers */
        /* @asm 0xA132..0xA141 */
        yield    = is_profmatch ? 6 : base_mult;
        /* @asm 0xA144: c7 46 e8 11 00 */
        meta_out = 0x11;
        /* @asm 0xA149 */
        yield   += sol_adj;
        /* @asm 0xA14F push 0x26; CALL 0x863E; double if set */
        if (test_building_or_father_bit(0x26)) yield <<= 1;
        /* @asm 0xA15F LCALL 0x981:0x00 (FF op 0x15); 0xA17D SAR ax,1; 0xA17F ADD */
        if (ov_power_flag(ctx->owner_power, 0x15)) {
            yield += yield >> 1;   /* +50% founding-father bonus */
        }
        break;

    case 17:  /* Liberty Flags [TBD: working name; meta 0x12] */
        /* @asm 0xA1C8..0xA1CE */
        yield    = base_mult + sol_adj;
        /* @asm 0xA1D1: c7 46 e8 12 00 */
        meta_out = 0x12;
        /* @asm 0xA1DA CMP is_profmatch,0; 0xA1DC SHL ax,1 */
        if (is_profmatch) yield <<= 1;
        break;

    default:  /* jobs 9..12, 14, 15 — manufactured goods */
        /* @asm 0xA18B */
        meta_out = job_byte;
        /* @asm 0xA18E..0xA194 */
        yield    = base_mult + sol_adj;
        {
            /* @asm 0xA197 CALL 0x864E  (count_building_chain_present) */
            int level = count_building_chain_present(chain_id);
            /* @asm 0xA1A4 CMP ax,1; 0xA1A7 JLE; 0xA1A9 ADD [bp-6],bx  (+base_mult) */
            if (level > 1) yield += base_mult;
            /* @asm 0xA1B2 CMP ax,2; 0xA1B5 JLE; SAR [bp-6],1 → h; ADD [bp-6],h */
            if (level > 2) { int h = yield >> 1; yield += h; }
            /* @asm 0xA1C4 JMP 0xA127; 0xA127 OR ax,ax; JNE 0xA12C; SHL [bp-6],1
             * AX = level on entry; nonzero (>=1 building) doubles the yield */
            if (level > 0) yield <<= 1;
        }
        break;
    }

exit_handler:
    /* @asm 0xA206: 83 7e 08 00  CMP [bp+8],0 / JE skip */
    if (meta != NULL) *meta = meta_out;
    /* @asm 0xA214 MOV ax,[bp-6]; 0xA217: 0b c0 OR ax,ax; 0xA219: JGE skip; 0xA21B SUB ax,ax */
    if (yield < 0) yield = 0;
    return yield;   /* @asm 0xA221 RETF */
}
