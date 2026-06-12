/* ============================================================================
 *                  >>> BYTE_VERIFIED <<<
 * ----------------------------------------------------------------------------
 * The deterministic RNG behind every Colonization roll.  Two functions:
 *   - `rand()` at file 0x0103D4 — MSC 6.0 standard LCG
 *   - `random_int(lo, hi)` at file 0x00C322 — scales to a range
 *
 * The seed is stored at DGROUP:0x28EE (low word) and DGROUP:0x28F0 (high
 * word). Initialized via `srand(int seed)` at file 0x0103C2.
 *
 * Every game-system roll (combat outcome, raid outcome, market drift,
 * king tax decision, LCR result, ...) calls `random_int(lo, hi)` from
 * the overlay-thunk at `LCALL 0x181F:0x04D4`. With the seed and call
 * sequence, all game randomness is exactly reproducible.
 *
 * @verified_by    Hand-decompiled from VICEROY.EXE bytes 2026-05-02
 * ============================================================================ */
#include "viceroy_types.h"

/* ============================================================================
 * MSC 6.0 standard rand() — BYTE_VERIFIED.
 *
 * @asm_function   func_0103D4
 * @asm_offset     file 0x0103D4..0x0103FB  (40 bytes)
 * @region         load_image
 *
 * Algorithm: linear congruential generator with the Microsoft MSC 6.0
 * library constants.  Equivalent to the rand() in any MSC 6.0 application.
 *
 * @bytes
 *   B8 FD 43          MOV AX, 0x43FD            ; multiplier_low  = 0x43FD
 *   BA 03 00          MOV DX, 0x0003            ; multiplier_high = 0x0003
 *   52 50             PUSH DX, PUSH AX          ; long arg = 0x000343FD = 213245
 *   FF 36 F0 28       PUSH word [DGROUP:0x28F0] ; seed.high
 *   FF 36 EE 28       PUSH word [DGROUP:0x28EE] ; seed.low
 *   9A 60 0F 1D 0D    LCALL __aFlmul            ; DX:AX = seed * 213245
 *   05 C3 9E          ADD AX, 0x9EC3            ; += 0x269EC3 (low part)
 *   83 D2 26          ADC DX, 0x0026            ; += 0x269EC3 (high part)
 *   A3 EE 28          MOV [DGROUP:0x28EE], AX   ; store new seed.low
 *   89 16 F0 28       MOV [DGROUP:0x28F0], DX   ; store new seed.high
 *   8B C2             MOV AX, DX                ; return upper 16 bits
 *   80 E4 7F          AND AH, 0x7F              ; mask to 15-bit positive
 *   CB                RETF
 * ============================================================================ */
extern uint32_t g_rand_seed_28EE;   /* DGROUP:0x28EE..0x28F0 — 32-bit seed */

int rand(void)
{
    g_rand_seed_28EE = g_rand_seed_28EE * 0x000343FDU + 0x00269EC3U;
    return (int)(g_rand_seed_28EE >> 16) & 0x7FFF;
}

/* ============================================================================
 * MSC 6.0 srand() — BYTE_VERIFIED.
 *
 * @asm_function   func_0103C2
 * @asm_offset     file 0x0103C2..0x0103D3  (17 bytes)
 * @region         load_image
 * @bytes
 *   8B 46 06          MOV AX, [BP+6]            ; seed argument
 *   A3 EE 28          MOV [DGROUP:0x28EE], AX   ; seed.low  = arg
 *   C7 06 F0 28 00 00 MOV [DGROUP:0x28F0], 0    ; seed.high = 0
 * Reached via 0x0D1D:0x0DF2 (the RTL entry); callers mask `AND AH,0x7F`
 * before the call (func_00C30A wrapper, the 0x181F:0x04CA tick re-seed).
 * ============================================================================ */
void msc_srand(unsigned v)
{
    g_rand_seed_28EE = (uint16_t)v;
}

/* ============================================================================
 * random_int(lo, hi) — BYTE_VERIFIED.
 *
 * @asm_function   func_00C322
 * @asm_offset     file 0x00C322..0x00C360  (63 bytes)
 * @region         load_image
 * @thunk          0x181F:0x04D4 (Type B, ljmp 0x09EF:0x0032)
 *
 * Returns a random integer in [lo, hi] inclusive.  Uses MSC 6.0 rand()
 * (15-bit) and scales via signed multiply-then-shift.
 *
 * Algorithm:
 *   r       = rand()                     // [0, 32767], 15-bit
 *   range   = hi - lo + 1
 *   product = r * range                  // signed 32-bit (DX:AX)
 *   scaled  = product >> 15              // shift right 15 bits = [0, range-1]
 *   return scaled + lo
 *
 * The shift-right-by-15 is implemented as 1 byte-swap (8 bits) plus 7
 * SAR/RCR pairs (7 bits) = 15 total.
 *
 * @bytes
 *   C8 04 00 00       ENTER 4, 0
 *   9A 04 0E 1D 0D    LCALL 0xD1D:0xE04         ; r = rand()
 *   8B C8             MOV CX, AX                ; CX = r
 *   8B 46 08          MOV AX, [BP+8]            ; AX = hi
 *   2B 46 06          SUB AX, [BP+6]            ; AX = hi - lo
 *   40                INC AX                    ; AX = hi - lo + 1 = range
 *   F7 E9             IMUL CX                   ; DX:AX = r * range
 *   8A C4             MOV AL, AH                ; ─┐
 *   8A E2             MOV AH, DL                ;   shift DX:AX right by 8 bits
 *   8A D6             MOV DL, DH                ; ─┘
 *   D0 E6             SHL DH, 1                 ; ─┐
 *   1A F6             SBB DH, DH                ;   sign-extend DH for signed shift
 *   D1 FA / D1 D8     SAR DX, 1; RCR AX, 1      ; (×7) — shift DX:AX right by 7 more
 *   ...
 *   03 46 06          ADD AX, [BP+6]            ; AX += lo
 *   C9 CB             LEAVE; RETF
 * ============================================================================ */
int random_int(int lo, int hi)
{
    int r = rand();                    /* 0..32767 */
    int range = hi - lo + 1;
    int scaled = (int)(((int32_t)r * range) >> 15);
    return scaled + lo;
}

/* ============================================================================
 * Implications
 *
 * Every game roll in VICEROY.EXE flows through these two functions:
 *
 *   - Native raid outcome (`func_05BE84`): `random_int(0, 12)` chooses raid
 *     intensity, then per-outcome rolls determine specifics
 *   - King tax raise decision (`func_034AE0`): `random_int(1, player+1)`
 *     drives whether the king actually demands a raise this turn
 *   - Combat outcomes (`func_05B2C2` and callers): combat roll vs combined
 *     strength
 *   - Market price drift (`func_0305A8`): per-commodity price change
 *   - LCR (Lost City Rumor) outcome: 11-way roll
 *   - Map generation: terrain placement, rivers, settlements all via this
 *
 * Because the LCG is deterministic, replays from the same save with the
 * same actions produce identical outcomes.  Variance comes only from:
 *   - The initial seed (set at game-start from DOS clock)
 *   - The exact sequence of actions taken (each consumes RNG calls)
 *
 * To predict a roll: track the seed through the call sequence using the
 * formula `seed = seed * 0x343FD + 0x269EC3`.
 * ============================================================================ */
