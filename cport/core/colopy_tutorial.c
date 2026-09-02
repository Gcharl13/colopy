/* The in-game tutorial (spec/systems/tutorial.md, spec/ui/tutorial.md;
 * game.js tutOnce): nineteen @TUTORIALn lessons, each fired once at its
 * own event site.
 *
 * BYTE MODEL (re-read 2026-09-02, RULINGS 2026-09-02d):
 *   - The gate is the Tutorial-Hints OPTION bit [0x5382]&0x80 — tested at
 *     every emit site (@0x020F3A T2, @0x021E63/@0x024AC6 the focus
 *     dispatcher's callers, @0x0286DA T16, @0x028CFD T7, @0x02C67E T4,
 *     @0x02C74F T12, @0x02E9D5 T6, @0x035BDC T17, @0x036504 T5).  New game
 *     writes [0x5382]=0xC600 (@0x0755E5) and func_07431E turns the bit ON
 *     iff difficulty == 0 (@0x074341..0x074348); the @GAMEOPTIONS dialog
 *     toggles it (@0x0230F3), and a save carries it (globals +2).  So the
 *     "Discoverer only" the JS learned from live play is byte-true, but
 *     the mechanism is the option — an Explorer game with hints toggled
 *     on fires the lessons too.
 *   - Once-flags: steps 1, 3..12 own bits 4..15 of the [0x5386/7] word
 *     (globals +6; @0x020FFB, @0x021350, @0x02C74A, @0x03651F, @0x02EA4C,
 *     @0x028D41, @0x0213E9, @0x021481, @0x0215CD, @0x021079, @0x02C7BC);
 *     steps 13/14/15/16/17/19 own bits of the [0x5380] byte (globals +0;
 *     @0x0210C4, @0x021104, @0x021157, @0x0286FF, @0x035C2B, @0x0215FA).
 *     T2 has NO once-flag (func_020EFE @0x020F3A..0x020F46: the option
 *     test alone), and T18 has neither gate nor flag (the Europe buy's
 *     can't-afford branch @0x032760).  The seed 0x0E in [0x5386] marks the
 *     three SOUND switches (@SOUNDOPTIONS @0x02330D..0x023322), not steps.
 *
 * The SITES are the JS's (its flagged approximations of the dispatcher
 * predicates), mirrored one for one so the two event streams agree;
 * the byte predicates each site approximates are named at the site. */
#include <stdio.h>
#include <string.h>

#include "colopy_sim.h"

static uint16_t rd16(const uint8_t *p) { return (uint16_t)(p[0] | (p[1] << 8)); }
static void put16(uint8_t *p, uint16_t v) { p[0] = (uint8_t)v; p[1] = (uint8_t)(v >> 8); }

/* [0x5382]&0x80 — the Tutorial-Hints option (globals +2; CR.game_options
 * is its working mirror, kept in step by the loader / new game / the
 * options dialog) */
int tut_hints(void) { return (rd16(CS.globals + 2) & 0x0080) != 0; }

/* the [0x5386/7] word bit per step (0 = not this home) */
static const uint16_t WORD_BIT[20] = {
    0, 0x0010, 0, 0x0040, 0x0080, 0x0100, 0x0200, 0x0400, 0x0800, 0x1000,
    0x2000, 0x4000, 0x8000, 0, 0, 0, 0, 0, 0, 0
};
/* the [0x5380] byte bit per step */
static const uint8_t FLAG_BIT[20] = {
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x01, 0x02, 0x08, 0x10, 0x20, 0,
    0x80
};

/* tutOnce(n, subs): 1 when the lesson was emitted.  num0/s0/s1 are the
 * %NUMBER0/%STRING0/%STRING1 subs the JS passes (the event carries two of
 * each; a lesson's %STRING2 — T6's/T17's home port — is not carried, the
 * front end's limit, FLAGGED). */
int tut_once(int n, int32_t num0, int32_t num1, const char *s0,
             const char *s1) {
    if (n < 1 || n > 19) return 0;
    if (n != 18 && !tut_hints()) return 0;      /* T18 is ungated */
    if (WORD_BIT[n]) {
        uint16_t m = rd16(CS.globals + 6);
        if (m & WORD_BIT[n]) return 0;
        put16(CS.globals + 6, (uint16_t)(m | WORD_BIT[n]));
    } else if (FLAG_BIT[n]) {
        if (CS.globals[0] & FLAG_BIT[n]) return 0;
        CS.globals[0] |= FLAG_BIT[n];
    }
    /* T2, T18: no once-flag */
    static char key[12];
    snprintf(key, sizeof(key), "TUTORIAL%d", n);
    ev_emit(key, num0, num1, s0, s1);
    return 1;
}
