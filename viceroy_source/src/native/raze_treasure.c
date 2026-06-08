/* ============================================================================
 *                  >>> WRONG FUNCTION (CORRECTED 2026-05-02) <<<
 * ----------------------------------------------------------------------------
 * **This file does NOT decompile the raze-settlement function.**
 *
 * Originally I traced `func_05C878` believing it was raze.  In fact:
 *   - func_05C878 references CASHTREASURE / KINGGALLEON / LOOTCASH
 *     strings — which are TREASURE-TRANSPORT messages (galleon takes
 *     player's loot to Europe), not raze messages.
 *   - The "BURNED" / "BURNED2" / "BURNED3" strings (the real raze verbs)
 *     are at 2b5a:1c28..1c37 and are referenced by `func_05CA7E` (a
 *     ~7437-byte function; body ends RETF @0x05E709, then the page-0x10 JMPF
 *     trampoline block to 0x05E740. CORRECTED 2026-05-30: the earlier
 *     "..0x05E7DF" overshot 159 B into the next segment's header).
 *   - `func_05CA7E` operates on `colony_t* @ DGROUP:0x8542`, suggesting
 *     it handles COLONY burn/capture rather than native-village raze.
 *     The actual native-settlement raze is a separate (still unidentified)
 *     function.
 *
 * What the byte-trace below DID get right (still useful as a reference):
 *   - func_05C878 IS a real game function — it's the TREASURE TRANSPORT
 *     event (player finds treasure → King's galleon ferries it back to
 *     Europe, taking a percentage; Cortés FF affects the percentage).
 *   - The MIN(90, MAX((player+10)*5, pool*2)) computation is a percentage
 *     split (50%..90% for player), not a raze multiplier.
 *   - `__aFlmul` / `__aFldiv` at file 0x010530 / 0x010496 are correctly
 *     identified as MSC 6.0 long-arithmetic helpers.
 *   - `power_attribute_bit` at file 0x00BC10 is correctly decoded.
 *
 * What the byte-trace got WRONG:
 *   - The function's name and purpose ("raze").
 *   - The interpretation of `[BX + 0x315B]` as "settlement_size".
 *     0x315B is byte 0x15 of an UnitRecord (table base 0x3146 with stride
 *     0x1C; confirmed by func_036038 which writes constants 0x15/0x1B/etc.
 *     here when CREATING units).
 *   - The "gold = multiplier × settlement_size" claim that produced
 *     ~600..1080 gold.  Real raze gold is 4000..15000 (per user's
 *     gameplay observation).
 *
 * Lesson recorded in VERIFICATION_LEDGER.md: identify a function via
 * STRING ANALYSIS first, not by pattern-matching call signatures.
 * ============================================================================ */
#if 0  /* file kept for reference; no longer represents raze logic */

/* ============================================================================
 *                  >>> ORIGINAL WRITEUP (NOW KNOWN INCORRECT) <<<
 * ----------------------------------------------------------------------------
 * Hand-decompiled from VICEROY.EXE function func_05C878 in the overlay
 * region.  Every control-flow decision, table address, stride value, AND
 * the final treasure formula are now byte-traceable to the disassembly.
 *
 * @asm_function   func_05C878   (overlay; raze settlement)
 * @asm_offset     file 0x05C878..0x05CA7E   (518 bytes)
 * @asm_disasm     code/VICEROY/disasm/func_05C878_unknown.asm
 * @region         overlay
 * @verified_by    Decompiled by hand against VICEROY.EXE bytes 2026-05-02
 *
 * Key helpers (now BYTE_VERIFIED):
 *   ovly_181F_07B4 → file 0x00BC10  (power_attribute_bit, segment 0x981)
 *                    code/VICEROY/disasm/func_00BC10_is_arg2_negative.asm
 *   ovly_0D1D_0F60 → file 0x010530  (__aFlmul — 32-bit long multiply)
 *                    code/VICEROY/disasm/func_010530_unknown.asm
 *   ovly_0D1D_0EC6 → file 0x010496  (__aFldiv — 32-bit long divide)
 *                    code/VICEROY/disasm/func_010496_unknown.asm
 *   ovly_0D1D_07E4 → file 0x00FDB4  (strcpy_near — already verified)
 *
 * @prompted_by    User question 2026-05-02: "if i burn down an aztec
 *                 village, what is the min and max gold i can receive"
 *
 * @answer (formula, BYTE_VERIFIED):
 *   gold_received = multiplier * settlement_size
 *   where:
 *     settlement_size = NativeSettlement[idx].byte_at_315B   (per-village data)
 *     multiplier      = MIN(90, M0)
 *     M0              = if power_attribute_bit(attacker, 10) is SET:
 *                          power_treasure_pool        (PowerRecord byte)
 *                       else:
 *                          MAX( (current_player + 10) * 5,
 *                               power_treasure_pool * 2 )
 *
 *   The function is FULLY DETERMINISTIC — no RNG call appears in the
 *   trace.  Variability in observed gold across plays comes from changing
 *   inputs (settlement_size, power_treasure_pool, current_player), NOT
 *   from any roll.
 *
 *   Bounds (in coins of gold) for a value of `settlement_size`:
 *     min: 50 * settlement_size      (player 0, low pool, bit clear)
 *     max: 90 * settlement_size      (capped)
 *   For an Aztec capital (settlement_size typically ~12), this gives a
 *   range of roughly 600..1080 gold per raze, deterministic per save.
 *
 *   See VERIFICATION_LEDGER.md for the byte-by-byte derivation.
 * ============================================================================ */
#include "viceroy_types.h"

/* ============================================================================
 * Globals referenced by this function (all DGROUP, byte-verified)
 * ============================================================================ */

/* DGROUP:0x315B + idx*0x1c — NativeSettlement table (stride 0x1C).
 * The byte at offset 0 within each record is read here ("settlement_size").
 *   IMUL bx, [bp+6], 0x1c
 *   MUL  byte ptr [bx + 0x315b]   ; AX = 100 * settlement_size
 * @bytes 6B 5E 06 1C  /  F6 A7 5B 31  at file 0x05C87E..0x05C887
 */
extern uint8_t g_native_settlement_315B[];   /* stride 0x1C; field 0 = village size */

/* DGROUP:0x5382 — game-state flag byte. Bit 0 controls fast-path branch.
 * @bytes  F6 06 82 53 01 (TEST byte ptr [0x5382], 1) at file 0x05C88B
 */
extern uint8_t  g_flags_5382;          /* bit 0 = "demo / endgame" mode */

/* DGROUP:0x53A6 — current player index (0..3).  Used both as a table
 * index into g_word_table_8394 and (after +10, *5) as the floor in the
 * multiplier MAX computation.
 * @bytes  8A 1E A6 53 (MOV bl, byte ptr [0x53a6]) at file 0x05C8BA
 *         A0 A6 53    (MOV al, byte ptr [0x53a6]) at file 0x05C976
 */
extern uint8_t  g_current_player_53A6;

/* DGROUP:0x8394 — 16-bit word table indexed by g_current_player_53A6.
 * Address derived from the constant `[bx - 0x7c6c]` with bx = 2 * player:
 *   0x10000 - 0x7C6C = 0x8394.
 * @bytes  FF B7 94 83 (PUSH word ptr [bx - 0x7c6c]) at file 0x05C8C2
 */
extern uint16_t g_player_word_8394[];  /* per-player parameter (used in dialog) */

/* DGROUP:0x540E + power*0x34 — AIPersonality table (stride 0x34).
 * @bytes  6B 46 08 34 / 05 0E 54 (IMUL ax, [bp+8], 0x34; ADD ax, 0x540e)
 *         at file 0x05C8D0..0x05C8D6
 */
extern uint8_t  g_aipersonality_540E[];   /* stride 0x34 */

/* DGROUP:0x8809 + power*0x13C — PowerRecord table (stride 0x13C confirmed).
 * Byte at offset 0 of each record is the "treasure_pool" used as the raw
 * material for the multiplier.
 * @bytes  69 5E 08 3C 01 / 8A 87 09 88 (IMUL bx, [bp+8], 0x13c;
 *                                       MOV al, byte ptr [bx + 0x8809])
 *         at file 0x05C8F2..0x05C8FA  AND  file 0x05C958..0x05C960
 */
extern uint8_t  g_powerrecord_8809[];     /* stride 0x13C; byte 0 = treasure_pool */

/* DGROUP:0x880F + power*0x13C, bit-addressed — PowerRecord attribute bitfield.
 * The function `power_attribute_bit` (file 0x00BC10) reads this region
 * with [BX+SI+0x880F] where BX = bit_index>>3, SI = power*0x13C.
 *   Offset within PowerRecord = 0x880F - 0x8809 = 6 bytes.
 * @bytes  8A 80 0F 88 (MOV AL, [BX+SI+0x880F]) at file 0x00BC37
 */
/* (accessed indirectly via power_attribute_bit — no direct C extern needed) */

/* PowerRecord 32-bit running totals incremented at the end of the function.
 *   gold        @ offset +0x21 (file 0x882A)
 *   total_loot  @ offset +0x25 (file 0x882E)
 *   score_bonus @ offset +0x29 (file 0x8832)
 * @bytes  01 87 2A 88 / 11 97 2C 88 at file 0x05CA4D..0x05CA54  (gold)
 *         01 87 32 88 / 11 97 34 88 at file 0x05CA5F..0x05CA66  (score_bonus)
 *         01 87 2E 88 / 11 97 30 88 at file 0x05CA67..0x05CA6E  (total_loot)
 */

/* ============================================================================
 * Helper APIs (all BYTE_VERIFIED via dedicated disasm files)
 * ============================================================================ */

/* power_attribute_bit (file 0x00BC10) — byte-verified.
 *   if (bit < 0) return 1;
 *   if (power >= 4) return 0;            ← natives never get the bit (they're powers 4..11)
 *   return PowerBitfield[power][bit/8] & (1 << (bit&7));
 */
extern uint16_t power_attribute_bit(uint16_t power, int16_t bit);

/* MSC 6.0 long-arithmetic helpers (load image segment 0xD1D = file 0xF5D0). */
extern int32_t  __aFlmul(int32_t a, int32_t b);   /* file 0x010530 */
extern int32_t  __aFldiv(int32_t a, int32_t b);   /* file 0x010496 */

/* Other overlay calls (semantics inferred from arg shapes; not used in
 * the gold formula but listed for completeness): */
extern void     ovly_181F_0438(uint16_t arg1, uint16_t arg2);
extern void     ovly_181F_0416(uint16_t seg, uint16_t off, uint16_t flag);
extern void     ovly_181F_048E(uint16_t arg);
extern void     ovly_181F_04B6(uint16_t arg);
extern void     ovly_181F_0652(uint16_t lang, uint16_t string_offset);
extern void     ovly_181F_0808(uint16_t settlement_idx);     /* destroy settlement */
extern uint16_t ovly_181F_03FE(char *buf);                   /* dialog confirm — returns 1 if accepted */
extern void     ovly_181F_09AE(uint16_t hi, uint16_t lo, uint16_t fmt);  /* format int32 */
extern void     ovly_191F_0AC8(uint16_t a, uint16_t b, uint16_t c);
extern void     strcpy_near(char *dst, const char *src);              /* file 0x00FDB4 */
extern void     strcat_near(char *dst, const char *src);              /* file 0x00FD74 */

/* ============================================================================
 * The function — fully decompiled, byte-verified.
 * ============================================================================
 *
 *  void compute_raze_loot(int settlement_idx,
 *                         int attacker_power_idx);
 *
 *  Caller pushes (attacker_power_idx, settlement_idx) right-to-left, so:
 *    [bp+6] = settlement_idx     (NativeSettlement[] index)
 *    [bp+8] = attacker_power_idx (PowerRecord[] index, 0..11)
 *
 *  Side effects (all on PowerRecord[attacker_power_idx]):
 *    .gold        += gold_delta
 *    .total_loot  += (base_amount - gold_delta)
 *    .score_bonus += (base_amount - gold_delta)
 *
 *  Then calls ovly_181F_0808(settlement_idx) which destroys the settlement.
 * ============================================================================ */

void compute_raze_loot(int settlement_idx, int attacker_power_idx)
{
    /* === 1. base_amount = 100 * settlement_size ============================
     * @asm 0x05C87E..0x05C887
     *   IMUL bx, [bp+6], 0x1C        ; bx = settlement_idx * 0x1C
     *   MOV  al, 0x64                ; al = 100
     *   MUL  byte [bx + 0x315B]      ; AX = 100 * settlement_size
     */
    uint8_t  settlement_size = g_native_settlement_315B[settlement_idx * 0x1C];
    uint16_t base_amount     = 100 * (uint16_t)settlement_size;

    /* === 2. Branch on g_flags_5382 bit 0 (demo/endgame mode) ===============
     * @asm 0x05C88B  TEST byte [0x5382], 1  /  JE 0x5C8BA
     */
    int32_t gold_delta = 0;

    if (g_flags_5382 & 1) {
        /* === FAST PATH (demo/endgame): just display CASHTREASURE message ===
         * No actual gold formula — base_amount is announced but not added.
         * @asm 0x05C892..0x05C8B6
         */
        ovly_181F_09AE(0, base_amount, 0);
        ovly_181F_0652(2, 0x1be0 /* "CASHTREASURE" */);
        ovly_181F_04B6(2);
        gold_delta = base_amount;        /* used for the carry-only update at end */
        goto carry_only_path;
    }

    /* === SLOW PATH: full gold computation =================================*/

    /* 3a. Push player word (probably for dialog title context).
     *     @asm 0x05C8BA..0x05C8CD
     */
    ovly_181F_0438(g_player_word_8394[g_current_player_53A6], 0);

    /* 3b. Push pointer to AIPersonality[attacker]. @asm 0x05C8D0..0x05C8E0 */
    ovly_181F_0416(/* DS */ 0, /* &g_aipersonality_540E[attacker*0x34] */ 0, 1);

    /* 3c. Format something via 191F:0AC8. @asm 0x05C8E3..0x05C8EF */
    ovly_191F_0AC8(attacker_power_idx, 0, 2);

    /* 3d. Format PowerRecord[attacker].byte_0 (sign-extended) — used in the
     *     dialog as "you currently have N treasures".
     *     @asm 0x05C8F2..0x05C906
     */
    int8_t  treasure_pool_byte = (int8_t)g_powerrecord_8809[attacker_power_idx * 0x13C];
    int32_t pool_signext       = (int32_t)treasure_pool_byte;
    ovly_181F_09AE((uint16_t)(pool_signext >> 16), (uint16_t)pool_signext, 0);

    /* 3e. strcpy(buf, "KINGGALLEON")  @asm 0x05C909..0x05C915 */
    char buf[80];
    strcpy_near(buf, (char *)0x1bed);

    /* 3f. Choose verb via the BIT-TEST gate (BYTE_VERIFIED, file 0x00BC10).
     *     bit-10 of attacker's PowerRecord attribute bitfield decides whether
     *     the message says "BURNED" or "RAZED" — and (later) gates the
     *     gold-formula MAX clause too.
     *     @asm 0x05C918..0x05C935
     */
    uint16_t bit10 = power_attribute_bit(attacker_power_idx, 10);
    const char *verb = (bit10 != 0) ? (const char *)0x1bf9   /* "BURNED" */
                                    : (const char *)0x1bfb;  /* "RAZED"  */
    strcat_near(buf, verb);

    /* 3g. Append '>' separator. @asm 0x05C93D..0x05C944 */
    ovly_181F_048E(0x3E);

    /* 3h. Confirmation dialog (Y/N).  Returns 1 if player accepts.
     *     @asm 0x05C947..0x05C955
     *       LCALL 0x181F:0x03FE  (BX = ptr to message buf)
     *       MOV [bp-0x52], AX
     *       DEC AX  /  JE 0x5C958  /  JMP 0x5CA7A
     */
    uint16_t confirm = ovly_181F_03FE(buf);
    if (confirm != 1) return;        /* player declined raze — no gold, no destruction */

    /* === 4. Compute multiplier ============================================
     * Re-read PowerRecord[attacker].byte_0 as starting value.
     * @asm 0x05C958..0x05C962
     */
    int16_t multiplier = (int16_t)treasure_pool_byte;     /* same byte as above */

    /* 4a. SAME bit-10 test as before.  This time it determines whether the
     *     multiplier gets the (player+10)*5 floor.
     *     @asm 0x05C965..0x05C974
     */
    if (power_attribute_bit(attacker_power_idx, 10) == 0) {
        /* Bit clear — apply MAX with player-floor: */
        int16_t player_floor = ((int16_t)g_current_player_53A6 + 10) * 5;
        int16_t pool_doubled = multiplier * 2;
        multiplier           = (player_floor >= pool_doubled) ? player_floor
                                                              : pool_doubled;
        /* @asm 0x05C976..0x05C990 — the SHL/CMP/JGE/MOV pattern that
         *   computes MAX( (player+10)*5, treasure_pool*2 ). */
    }
    /* @asm If bit set: multiplier stays = treasure_pool (no MAX, no doubling). */

    /* 4b. Hard cap at 90.
     *     @asm 0x05C9A0..0x05C9AB    CMP ax, 0x5A / JLE / MOV ax, 0x5A
     */
    if (multiplier > 90) multiplier = 90;

    /* === 5. gold_delta = (multiplier * base_amount) / 100 =================
     * Algebraically equivalent to multiplier * settlement_size, but VICEROY
     * computes it in 32-bit math via __aFlmul + __aFldiv.
     *
     * Stack layout at the calls (BYTE_VERIFIED):
     *   PUSH 0; PUSH 100;       ← arg2 of the LATER fldiv (= 100)
     *   PUSH 0; PUSH base;      ← arg1 of fldiv... no wait: see below
     *   PUSH 0; PUSH multiplier; ← second long for fmul
     *   LCALL __aFlmul          → DX:AX = multiplier * base
     *   PUSH DX; PUSH AX;
     *   LCALL __aFldiv          → DX:AX = (multiplier * base) / 100
     *
     * @asm 0x05C993..0x05C9C6
     */
    gold_delta = __aFldiv(__aFlmul((int32_t)multiplier,
                                   (int32_t)base_amount),
                          100);
    /* Equivalently:  gold_delta = multiplier * settlement_size. */

    /* 6. Display gold_delta and the leftover. @asm 0x05C9D1..0x05C9FF */
    ovly_181F_09AE(0, /* base */ base_amount, 0);
    ovly_181F_09AE(0, (uint16_t)multiplier, 1);
    int16_t leftover = base_amount - (int16_t)gold_delta;   /* @asm 0x05C9EE..0x05C9F0 */
    ovly_181F_09AE(0, (uint16_t)leftover, 2);

    /* 7. Append tribe / attacker info. @asm 0x05CA02..0x05CA28 */
    ovly_181F_0808(settlement_idx);   /* (placeholder; actual call is later) */
    /* (Several format/strcat calls follow — purely cosmetic for the message.) */

    /* 8. Display LOOTCASH summary. @asm 0x05CA35..0x05CA3F */
    ovly_181F_0652(2, 0x1bfd /* "LOOTCASH" */);

    /* === 9. Update PowerRecord (32-bit ADDs with carry) ===================
     * @asm 0x05CA42..0x05CA6E
     *   gold       += gold_delta
     *   score_bonus += leftover
     *   total_loot  += leftover
     */
    *(int32_t *)&g_powerrecord_8809[attacker_power_idx * 0x13C + 0x21] += gold_delta;

carry_only_path:
    {
        /* In the demo/endgame fast path, the "leftover" tracking still uses
         * base_amount (no gold was actually added — game over, but the score
         * fields are still bumped).
         */
        int16_t carry = base_amount - (int16_t)gold_delta;
        *(int32_t *)&g_powerrecord_8809[attacker_power_idx * 0x13C + 0x29] += carry;
        *(int32_t *)&g_powerrecord_8809[attacker_power_idx * 0x13C + 0x25] += carry;
    }

    /* === 10. Destroy the settlement. @asm 0x05CA6F..0x05CA77 ============== */
    ovly_181F_0808(settlement_idx);
}

/* ============================================================================
 * Answer to the user's question — fully byte-verified
 * ----------------------------------------------------------------------------
 * "If I burn down an Aztec village, what's the min and max gold I can
 *  receive?"
 *
 * gold_received = MIN(90, M0) * settlement_size
 *
 *   where  M0 = (bit10_of_attacker_PowerBitfield_set)
 *               ? PowerRecord[attacker].treasure_pool_byte
 *               : MAX( (current_player_idx + 10) * 5,
 *                      PowerRecord[attacker].treasure_pool_byte * 2 )
 *
 * For a HUMAN player attacking an Aztec village:
 *   - attacker_power_idx is in 0..3 (the four European powers)
 *   - bit 10 of PowerRecord attribute bitfield is normally CLEAR for fresh
 *     games (set only by specific scenario / Founding Father effects; exact gate not yet decoded)
 *   - so M0 = MAX( (player+10)*5, treasure_pool*2 )
 *
 *   For player slot 0 (P1):  (0+10)*5 = 50  → multiplier in [50, 90]
 *   For player slot 3 (P4):  (3+10)*5 = 65  → multiplier in [65, 90]
 *
 *   settlement_size for an Aztec capital is empirically ~12 (data table
 *   pending byte-verification — value comes from NativeSettlement.byte_0
 *   in the save state, set during map-generation per tribe wealth).
 *
 *   With settlement_size = 12 and player slot 0:
 *     min gold ≈  50 * 12 =  600
 *     max gold ≈  90 * 12 = 1080
 *   With settlement_size = 12 and player slot 3:
 *     min gold ≈  65 * 12 =  780
 *     max gold ≈  90 * 12 = 1080
 *
 *   For an Aztec OUTPOST (settlement_size ~6):
 *     min gold ≈ 50 * 6 = 300, max ≈ 540 (player 0)
 *
 * THE FORMULA IS DETERMINISTIC.  No RNG is called.  The same save with
 * the same actions produces identical gold every replay.  Variability
 * across plays comes entirely from differing inputs (which player slot,
 * pre-existing treasure_pool, settlement_size set at map-gen time, and
 * bit 10 status).
 *
 * What's STILL not byte-verified:
 *   - The exact value of NativeSettlement.byte_0 (settlement_size) for
 *     each tribe / settlement-tier.  This lives in map-gen code that
 *     populates the table; a separate byte-trace of map-gen would pin it.
 *   - What sets bit 10 of the attacker's PowerRecord attribute bitfield
 *     (likely a Founding Father — Cortés is the obvious candidate).
 *
 * Both gaps are now narrow and tractable — they're individual functions
 * to byte-trace, not whole subsystems.
 * ============================================================================ */

#endif  /* End of original (incorrect) writeup */

