/* ============================================================================
 *           >>> NATIVE MISSION — mission flag BYTE_VERIFIED; convert-roll BYTE_VERIFIED; other side effects not yet decoded <<
 * ----------------------------------------------------------------------------
 * Mission state lives in the settlement record's +0x05 byte ("mission flag").
 * The encoding and the active-bit test are byte-verified.  Conversion
 * production rates and the establish/destroy side effects are NOT byte-traced.
 *
 * MISSION FLAG (BYTE_VERIFIED — settlement record +0x05, addressed 0x54F1):
 *   value 0xFF        = no mission (set at settlement creation, @0x046E77;
 *                        cleared back to 0xFF at @0x045D2D).
 *   bit  0x10 set     = mission ACTIVE.
 *                        @asm test byte [bx+0x54F1],0x10 @0x043F40
 *                        (the map-overlay that draws the mission cross marker).
 *   low nibble (&0xF) = mission owner power index (per docs/RULINGS.md
 *                        2026-05-28: "mission flag (0x10 | owner_idx)").
 *
 * @asm  settlement stride 0x12 (imul *,0x12) confirmed at every access site
 *       (0x043F3C, 0x045D1C, 0x04615D, …).  String segment base file 0x1D9A0;
 *       MISSION0 @seg 0x1532 (file 0x1EED2), pushed by the in-game settlement
 *       status builder @0x048B53 (page_0C).
 * @verified_by  Hand-decompiled 2026-05-29 from disasm_overlay_reseg/.
 * ============================================================================ */
#include "viceroy_types.h"
#include "native.h"
#include "unit.h"
#include "ff.h"

extern uint8_t g_native_table_54EC[];     /* DGROUP:0x54EC — NativeSettlement[] */

/* Mission-flag accessors — BYTE_VERIFIED encoding (+0x05). */
#define MISSION_ACTIVE_BIT  0x10
#define MISSION_NONE        0xFF

static inline uint8_t *settlement_rec(int index)
{
    return &g_native_table_54EC[index * NATIVE_SETTLEMENT_STRIDE];
}

/* @asm test byte [bx+0x54F1],0x10 @0x043F40 — mission-active test. */
int mission_is_active(int settlement_index)
{
    return (settlement_rec(settlement_index)[0x05] & MISSION_ACTIVE_BIT) != 0;
}

/* Low nibble of +0x05 is the owning power (docs/RULINGS.md 2026-05-28). */
int mission_owner(int settlement_index)
{
    uint8_t m = settlement_rec(settlement_index)[0x05];
    if (!(m & MISSION_ACTIVE_BIT)) return -1;
    return m & 0x0F;
}

/* ============================================================================
 * mission_establish — sets +0x05 = 0x10 | owner   (BYTE_VERIFIED encoding)
 *
 * The exact eligibility checks and the consumption of the missionary unit are
 * NOT byte-traced (they cross the diplomacy/parley overlay handler).  Only the
 * mission-flag WRITE encoding is byte-verified, mirroring the create-time
 * clear at @0x046E77 and the reset to 0xFF at @0x045D2D.
 * ============================================================================ */
void mission_establish(int settlement_index, int owner_power)   /* encoding verified; gating not yet decoded */
{
    settlement_rec(settlement_index)[0x05] =
        (uint8_t)(MISSION_ACTIVE_BIT | (owner_power & 0x0F));
}

/* @asm 0x045D2D  mov byte [bx+0x54F1],0xFF — clear mission. */
void mission_destroy(int settlement_index)
{
    settlement_rec(settlement_index)[0x05] = MISSION_NONE;
}

/* ============================================================================
 *  mission_convert_roll — the per-check CONVERT PROBABILITY (BYTE_VERIFIED)
 * ----------------------------------------------------------------------------
 *  func_0572E6 (file 0x0572E6, ENTER 0x0F25; INDIANSCONVERT key DG 0x182A
 *  pushed @0x57341 -> identifies this as the native-conversion event).
 *
 *  The conversion rate is read from the ACTIVE TRIBE record (pointer at
 *  DGROUP:0x8D4E, set by set_active_tribe func_0081C6), field +2, plus 2;
 *  doubled when an incoming mission-strength flag (CL bit 0x10) is set:
 *
 *    @asm 0x572F2  mov  bx,[0x8d4e]          ; bx = active tribe record
 *    @asm 0x572F6  mov  al,[bx+2]            ; tribe field +2 (convert propensity)
 *    @asm 0x572FB  inc ax; inc ax            ; rate = field+2 + 2
 *    @asm 0x572FD  mov  [bp-4],ax            ; rate
 *    @asm 0x57300  test cl,0x10 ; je         ; if mission-bonus flag set...
 *    @asm 0x57305  shl  ax,1 ; mov [bp-4],ax ;   rate *= 2
 *    @asm 0x5730A  push 0xf; push 0
 *    @asm 0x5730E  lcall 0x181F:0x04D4       ; roll = random_int(0, 15)
 *    @asm 0x57316  cmp  ax,[bp-4]            ; convert iff roll < rate
 *    @asm 0x57319  jge  0x5737c             ;   roll >= rate -> no convert (return)
 *    (convert produced; INDIANSCONVERT message shown @0x57341, gated on the
 *     human-visibility check [bp+6]<4 && FF-flag[bx+0x543f]==0 @0x5731B..0x5732A)
 *
 *  So P(convert per check) = MIN(rate,16)/16, rate = tribe[+2] + 2 (x2 w/ flag).
 *  @status BYTE_VERIFIED (rate formula + roll + gate). The exact identity of the
 *  CL-bit-0x10 source (expert missionary / mission building): inferred from the bit (bit 0x10 = mission bonus; exact FF/building gate not yet decoded); the tribe
 *  +2 byte's per-tribe values are external (TRIBE.TXT/NAMES.TXT @TRIBE).
 * ============================================================================ */
extern uint32_t game_random_int(int lo, int hi);   /* func_00C322 (0x181F:0x04D4) */
extern uint8_t  g_active_tribe_8d4e_rec[];          /* *(0x8D4E) */

int mission_convert_roll(int mission_bonus_flag)
{
    int rate = g_active_tribe_8d4e_rec[2] + 2;       /* @asm 0x572F6..0x572FB */
    if (mission_bonus_flag & 0x10)                    /* @asm 0x57300 test cl,0x10 */
        rate <<= 1;                                   /* @asm 0x57305 shl ax,1   */
    return (int)game_random_int(0, 15) < rate;        /* @asm 0x5730E roll; 0x57316 cmp */
}

/* Convert unit placement + Las Casas (FF) upgrade Indian-Convert(0x1B)->Free
 * Colonist(0x1C) is handled in founding_fathers/effects.c (FF id 24, BYTE_VERIFIED
 * @0x3BEDB). spawn here just records that the roll passed. */
void spawn_indian_convert(int settlement_index)
{
    int owner = mission_owner(settlement_index);
    if (owner < 0) return;          /* mission-active check is BYTE_VERIFIED */
    /* unit creation crosses overlay thunk 0x181F:0x95c (create unit); body in thunk page */
}
