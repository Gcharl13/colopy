/* ============================================================================
 *           >>> MOSTLY left unresolved — storage layout PARTIALLY BYTE-VERIFIED <<<
 * ----------------------------------------------------------------------------
 * What IS byte-verified (from func_057DC0 @0x057DC0, see treaty.c):
 *   - The per-power relation/treaty STATE is a 1-byte-per-other-power array
 *     embedded in PowerRecord at offset +0x40 (DGROUP:0x8848, stride 0x13C),
 *     written SYMMETRICALLY, holding 0 (no treaty/war) or 1 (treaty/alliance).
 *   - The relation FLAG bits read via the 0x181F:0x0A38 accessor: bit 0x02
 *     (war/hostile), bit 0x20 (peace-pending), bit 0x40 (treaty in force).
 *
 * What is NOT verified (DELETED from the prior reconstruction):
 *   - Any numeric "relationship score" (-100..100), per-event deltas, clamp
 *     range, REL_PEACE/REL_WAR/REL_ALLIANCE enum values, AI state-transition
 *     thresholds, and the Pocahontas "+20 to all" magnitude.  The earlier file
 *     invented all of these; they had no byte backing and are removed.
 *
 * Upgrade per viceroy_source/VERIFICATION_LEDGER.md.
 * ============================================================================ */

/* ============================================================================
 * relations.c -- per-power diplomatic relation state
 * ----------------------------------------------------------------------------
 * @ref ../docs/EUROPEAN_DIPLOMACY.md
 * @asm PowerRecord+0x40 relation-state array (DGROUP:0x8848, stride 0x13C)
 * @asm 0x181F:0x0A38 relation-flag accessor (bits 0x02/0x20/0x40)
 * ============================================================================ */
#include "viceroy_types.h"
#include "power.h"

/* VERIFIED relation-flag bits returned by rel_query (0x181F:0x0A38). */
#define REL_FLAG_WAR            0x02   /* @asm 057E05 test al,2  */
#define REL_FLAG_PEACE_PENDING  0x20   /* @asm 057DF0 test al,0x20 */
#define REL_FLAG_TREATY         0x40   /* @asm 057E7D test al,0x40 */

/* VERIFIED relation-state cell layout (see treaty.c rel_state_cell()). */
#define REL_STATE_BASE   0x8848        /* PowerRecord+0x40 ; @asm -0x77B8 */
#define POWER_STRIDE     0x13C
#define REL_STATE_NONE   0             /* @asm 057F23 sub al,al (cleared/war) */
#define REL_STATE_TREATY 1             /* @asm 057EBB mov al,1  (treaty/ally) */

extern uint8_t rel_query(int power_self, int power_other);   /* 0x181F:0x0A38 */

/* Read the symmetric relation-state byte for the ordered pair (self, other). */
uint8_t rel_state_get(int power_self, int power_other)
{
    /* @asm matrix[self][other] = *(0x8848 + self*0x13C + other) */
    const uint8_t *base = (const uint8_t *)REL_STATE_BASE;
    return base[(unsigned)power_self * POWER_STRIDE + (unsigned)power_other];
}

/* Convenience predicates over the VERIFIED flag accessor. */
int rel_at_war(int self, int other)        { return (rel_query(self, other) & REL_FLAG_WAR)   != 0; }
int rel_has_treaty(int self, int other)    { return (rel_query(self, other) & REL_FLAG_TREATY)!= 0; }
int rel_peace_pending(int self, int other) { return (rel_query(self, other) & REL_FLAG_PEACE_PENDING) != 0; }

/* ============================================================================
 *   >>> WAR / TREATY MENU MUTATIONS — func_03ECF0 — BYTE_VERIFIED (2026-05-30) <<<
 * ----------------------------------------------------------------------------
 * The right-click unit "give command" handler (func_03ECF0, file
 * 0x03ECF0..~0x03F8FE, page 0x07) builds the diplomacy sub-menu and, on a
 * choice, mutates the European relation matrices directly.  Identified by
 * STRING XREF (file = handle + 0x1D9A0):
 *     handle 0x13AD -> file 0x1ED4D = "WHACKINDIANS"  (@asm 0x03EFE4 push 0x13ad)
 *     handle 0x13BA -> file 0x1ED5A = "HAVETREATY"    (@asm 0x03F130 push 0x13ba)
 *     handle 0x13CB -> file 0x1ED6B = "CANCELPEACE"   (@asm 0x03F22F push 0x13cb)
 *     handle 0x13D7 -> file 0x1ED77 = "DECLAREWAR"    (@asm 0x03F262 push 0x13d7)
 *
 * THE WAR-FLAG MATRIX IS A SECOND, SEPARATE PER-PAIR ARRAY AT PowerRecord+0x34
 * (base DGROUP:0x883C), distinct from the treaty-STATE byte at +0x40 (0x8848):
 *   @asm 0x03F290  imul si,[bp-2],0x13c
 *   @asm 0x03F298  or  byte [bx+si-0x77c4], 2     ; SET war bit (−0x77C4 ≡ +0x883C
 *                                                 ; = PowerRecord+0x34)
 *   @asm 0x03F2B5  and byte [bx+si-0x77c4], 0xFE  ; CLEAR bit0 (cancel path)
 * Verified against COLONIZE/VICEROY.EXE: 0x03F298 = 80 88 3C 88 02 (or [..],2).
 *
 * The menu gates each option on the relation flags via the SAME accessors used
 * by treaty_set_state (treaty.c):
 *   rel_query   (0x181F:0x0A38)  test al,0x40  -> "treaty in force?"   (many sites)
 *   rel_clear_event (0x181F:0x0A10) clear mask 0x40 -> break the treaty (@0x03F2A5)
 * and the treaty-STATE byte at −0x77B8 (≡ +0x8848) is read at @0x03F163
 * (`cmp byte [bx+si-0x77b8],0`), re-confirming treaty.c's +0x40 mapping.
 *
 * BYTE_VERIFIED: a second relation matrix lives at PowerRecord+0x34 (base
 * 0x883C); its bit 0x02 is the "at war" flag (matches REL_FLAG_WAR=0x02), set on
 * DECLAREWAR and cleared on cancel.  The treaty-in-force bit lives in the
 * accessor's return (rel_query bit 0x40) and the treaty-STATE byte at +0x40.
 * ============================================================================ */
#define WAR_FLAG_MATRIX_BASE  0x883C   /* @asm -0x77C4 -> +0x883C = PowerRecord+0x34 */
#define WAR_FLAG_AT_WAR       0x02     /* @asm 0x03F298 or [...],2 (== REL_FLAG_WAR) */

extern void rel_clear_event(int mask, int power_a, int handle); /* 0x181F:0x0A10 */
extern int  power_handle(int power_idx);                        /* 0x181F:0x09A4 / 0x0A1A */

/* Read/raise the symmetric war bit for the ordered pair (self, other).
 * @asm matrix[self][other] |= 2  at base 0x883C, stride 0x13C. */
static inline uint8_t *war_flag_cell(int power_self, int power_other)
{
    uint8_t *base = (uint8_t *)WAR_FLAG_MATRIX_BASE;
    return base + (unsigned)power_self * POWER_STRIDE + (unsigned)power_other;
}

/* rel_declare_war — the DECLAREWAR menu effect (func_03ECF0 @0x03F290..0x03F2B5).
 * Sets the war bit in the +0x34 matrix for `attacker` vs `defender`, then clears
 * the treaty (mask 0x40) and bit0 in the symmetric +0x34 cell.  The full menu
 * also touches unit field +0x3149 and the UI; only the relation mutation is
 * reproduced here (BYTE_VERIFIED). */
void rel_declare_war(int attacker, int defender)
{
    /* @asm 0x03F284 rel_query(attacker,defender) & 0x40 gates this branch. */
    if (rel_query(attacker, defender) & REL_FLAG_TREATY) {  /* @asm 0x03F28C test al,0x40 */
        *war_flag_cell(attacker, defender) |= WAR_FLAG_AT_WAR; /* @asm 0x03F298 or [..-0x77c4],2 */
    }
    /* @asm 0x03F29D — clear the treaty bit (mask 0x40) on the defender. */
    rel_clear_event(REL_FLAG_TREATY, defender, power_handle(defender)); /* @asm 0x03F2A5 lcall 0xa10 */
    /* @asm 0x03F2AD — clear bit0 of the symmetric +0x34 cell. */
    *war_flag_cell(defender, attacker) &= (uint8_t)0xFE;    /* @asm 0x03F2B5 and [..-0x77c4],0xfe */
}

/* ============================================================================
 * EVERYTHING BELOW IS not yet decoded (NOT byte-verified)
 * ----------------------------------------------------------------------------
 * The original maintains a richer per-power attitude model (the AI uses it to
 * decide demands, war, and alliances), but the scoring fields, the per-event
 * deltas, and the AI transition rules have NOT been located in VICEROY.EXE.
 * The prior reconstruction's numbers (+1 trade, -25 colony loss, +20
 * Pocahontas, clamp [-100,100], 50+/-aggression thresholds) were fabricated
 * and are intentionally NOT reproduced here.
 *
 * Anchors for future work:
 *   - rel_query accessor body: 0x181F:0x0A38 -> file 0x5FC30 (decompile to learn
 *     where the 0x02/0x20/0x40 bits live and how they relate to PowerRecord+0x40).
 *   - rel_apply_event 0x181F:0x0A06 (file 0x5FCD2) and rel_clear_event
 *     0x181F:0x0A10 (file 0x5FCFC): the set/clear-with-mask helpers.
 *   - cs:0x3f30 / cs:0x3f58 near-calls in page 0x0F (relation mutate/predicate).
 * ============================================================================ */
#if 0  /* not yet decoded — numeric attitude model not yet reverse-engineered */
int  rel_score_get(int a, int b);                 /* not yet decoded: is there a signed score at all? */
void rel_score_apply_event(int a, int b, int e);  /* not yet decoded: event->delta table unknown */
void rel_event_pocahontas(int recruiting_power);  /* not yet decoded: magnitude unknown (FF id 16 effect
                                                   *      clears native alarm, NOT European
                                                   *      relation score — see effects.c) */
#endif
