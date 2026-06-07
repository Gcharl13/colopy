/* ============================================================================
 *           >>> NATIVE MISSION — mission flag BYTE_VERIFIED; rest TBD <<<
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
void mission_establish(int settlement_index, int owner_power)   /* encoding verified; gating TBD */
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
 *                  >>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<
 * ----------------------------------------------------------------------------
 * Convert spawning and the FF (Las Casas / Brebeuf) interactions are carried
 * over from the prior reconstruction.  Conversion production is gated on the
 * BYTE_VERIFIED mission-active bit above, but the production RATE and the
 * convert unit placement are TBD (rate tables load from NAMES.TXT; spawn
 * crosses overlay thunks).
 * ============================================================================ */
extern uint32_t game_random_range(uint32_t lo, uint32_t hi);

void spawn_indian_convert(int settlement_index)   /* RECONSTRUCTED */
{
    int owner = mission_owner(settlement_index);
    if (owner < 0) return;          /* mission-active check is BYTE_VERIFIED */
    /* placement + Las Casas (FF) upgrade to Free Colonist — TBD */
}
