/* The rival-power turn — rivalTurn (game.js:7514) + checkContact (7317) +
 * the AI-initiated meeting chain runMeeting/meetingTopic/meetingPeaceHub
 * (8254/8266/8384, func_057F4E / func_059B90).
 *
 * The JS rival AI is itself a FLAGGED stand-in for the engine's strategic
 * planner (func_04CC50) and per-unit pipeline (func_04E2D6) — ships sail
 * west and plant colonies, land units garrison at peace and march at war —
 * and this mirrors that stand-in draw-for-draw, since the JS port is the
 * parity reference.  Byte-cited pieces carried over: the parley gates
 * (turn >= 0x28, attitude >= 8 @0x57B1A, 16-turn lockout @0x58075), the
 * action gate random(1000) < 200*diff+100 (@0x58315), the grace period
 * 10*(10-diff) turns (@0x58374), the HELLO key build (@0x0588CD-0x058939),
 * the MEEK/MANLY tone = strength comparison (@0x5881F, proxied), and the
 * REL bit values (WAR matrix PowerRecord +0x34, TREATY +0x40).
 *
 * Trace semantics: askEvent is stubbed (key only, callback never runs), so
 * every meeting topic ENDS at its first ask — treaties, tribute payments,
 * war declarations and withdrawals never execute.  The war matrix starts
 * empty (the JS importer does not populate it — TBD against PowerRecord
 * +0x34) and no ported path writes REL.WAR, so rivalTurn's WAR branch
 * (attack march + resolveAttack + the capture path) is unreachable for
 * now; it lands with the combat-resolution slice and is marked below. */
#include <string.h>

#include "colopy_sim.h"
#include "../data/colopy_data.h"

#define REL_WAR       0x02
#define REL_PRIVATEER 0x80
#define REL_TREATY    0x40
#define PARLEY_LOCKOUT 0x10
#define PARLEY_FIRST_TURN 0x28

static int at_war(int a, int b) {
    return ((CR.war_matrix[a][b] | CR.war_matrix[b][a]) & REL_WAR) != 0;
}
static int have_treaty(int a, int b) {
    return (CR.treaty_matrix[a][b] & REL_TREATY) != 0;
}

static int is_rival_unit(int ui, int rn) {
    const UnitRecord *u = &CS.units[ui];
    return (u->owner_flags & 0x0F) == rn && u->type < DAT_UNITS_COUNT;
}

/* powerMetric (game.js:8237): FLAGGED proxy for the [0x941C] strength
 * word — total @UNIT combat over the side's units + 3 per colony. */
static int power_metric(int power) {
    int s = 0;
    if (power == (int)cs_nation()) {
        for (int ui = 0; ui < CS.n_units; ui++)
            if (unit_on_map_player(ui)) s += dat_units[CS.units[ui].type].combat;
        for (int ci = 0; ci < CS.n_colonies; ci++)
            if ((CS.colonies[ci].owner_power & 3) == cs_nation()) s += 3;
    } else {
        for (int ui = 0; ui < CS.n_units; ui++)
            if (is_rival_unit(ui, power)) s += dat_units[CS.units[ui].type].combat;
        s += CR.rivals[power].n_col * 3;
    }
    return s;
}
static int meeting_tone(int rn) {          /* 1 = B speaks MEEKLY */
    return power_metric(rn) < power_metric(cs_nation());
}

/* parleyEligible (game.js:8206).  G.attitude is 8 from boot and never
 * changes headless, so the attitude clause is always satisfied. */
static int parley_eligible(int rn) {
    if (cs_turn() < PARLEY_FIRST_TURN) return 0;
    if (CR.parley_lock[rn] > cs_turn()) return 0;
    return 1;
}

static int gate(void) {                    /* action gate @0x58315 */
    return (int)((rng_next() * 1000u) >> 15) < 200 * cs_difficulty() + 100;
}

/* meetingPeaceHub (game.js:8384) — the 4-row hub, ask-stubbed. */
static void meeting_peace_hub(int rn) {
    const char *key = have_treaty(cs_nation(), rn)
        ? (meeting_tone(rn) ? "OLDPEACEMEEK" : "OLDPEACEMANLY")
        : (meeting_tone(rn) ? "PEACEMEEK" : "PEACEMANLY");
    ev_emit(key, 0, 0, dat_nations[cs_nation()].adjective,
            dat_nations[rn].adjective);
}

/* meetingTopic (game.js:8266) — the topic cascade.  Draw accounting is the
 * contract: each gate() draws only when its preceding conditions held, in
 * JS short-circuit order. */
static void meeting_topic(int rn) {
    int me = cs_nation();
    int in_grace = cs_turn() < 10 * (10 - cs_difficulty());
    /* @PIRACY — needs the privateer hidden-attribution bit (unset while
     * the importer leaves the war matrix empty) */
    if ((CR.war_matrix[me][rn] & REL_PRIVATEER) && !at_war(me, rn)) {
        CR.war_matrix[me][rn] &= (uint8_t)~REL_PRIVATEER;
        ev_emit("PIRACY", 0, 0, dat_nations[me].adjective,
                dat_regionname[rn]);       /* ask stub */
        return;
    }
    /* @SIEGES — player attack-capable land units beside B's colonies */
    if (!at_war(me, rn)) {
        int besiegers = 0;
        for (int ui = 0; ui < CS.n_units && !besiegers; ui++) {
            if (!unit_on_map_player(ui)) continue;
            const UnitRecord *u = &CS.units[ui];
            if (dat_units[u->type].hull > 0 ||
                dat_units[u->type].attack <= 0) continue;
            const rival_rt *r = &CR.rivals[rn];
            for (int k = 0; k < r->n_col; k++) {
                int dx = r->col[k].x - u->map_x, dy = r->col[k].y - u->map_y;
                if (dx < 0) dx = -dx;
                if (dy < 0) dy = -dy;
                if (dx <= 1 && dy <= 1) { besiegers = 1; break; }
            }
        }
        if (besiegers && gate()) {
            ev_emit("SIEGES", 0, 0, dat_nations[me].adjective,
                    dat_nations[rn].adjective);   /* ask stub */
            return;
        }
    }
    /* @APOSTATES — a third power B is at war with while we hold a treaty
     * (unreachable while both matrices are empty; scan kept for order) */
    {
        int third = -1;
        for (int x = 0; x < 4 && third < 0; x++)
            if (x != me && x != rn && CR.rivals[x].met &&
                have_treaty(me, x) && at_war(rn, x)) third = x;
        if (third >= 0 && gate()) {
            ev_emit("APOSTATES", 0, 0, dat_nations[third].adjective, 0);
            return;
        }
    }
    /* @HEATHEN — first tribe at the 40-tension band (port stand-in,
     * flagged in JS): gate() then the 0.34 roll, short-circuit order */
    {
        int heathen = -1;
        for (int t = 0; t < 8 && heathen < 0; t++)
            if (CR.tension[t] >= 40) heathen = t;
        if (heathen >= 0 && !at_war(me, rn) && gate() &&
            (int)rng_next() <= 11141) {    /* Math.random() < 0.34 */
            ev_emit("HEATHEN", 0, 0, dat_tribes[heathen].name, 0);
            return;
        }
    }
    /* @TRIBUTE — B's gold extortion, after the grace period */
    if (!in_grace && !at_war(me, rn) && gate()) {
        ev_emit("TRIBUTE", 0, 0, dat_nations[me].adjective,
                dat_regionname[rn]);       /* ask stub */
        return;
    }
    /* @WORTHY — the AI-proposed demarcation treaty */
    if (!have_treaty(me, rn) && !at_war(me, rn) && gate()) {
        ev_emit("WORTHY", 0, 0, dat_nations[me].adjective,
                dat_nations[rn].adjective);   /* ask stub */
        return;
    }
    meeting_peace_hub(rn);
}

/* runMeeting (game.js:8254).  unitIn is always a LAND unit here (only the
 * land-garrison branch parleys), so the ungreeted key is HELLOFIRST. */
static void run_meeting(int rn) {
    rival_rt *r = &CR.rivals[rn];
    const char *key = !r->greeted ? "HELLOFIRST"
        : meeting_tone(rn) ? "HELLOMEEK" : "HELLOMANLY";
    r->greeted = 1;
    CR.parley_lock[rn] = (uint16_t)(cs_turn() + PARLEY_LOCKOUT);
    ev_emit(key, 0, 0, dat_regionname[rn], 0);
    meeting_topic(rn);
}

/* checkContact (game.js:7317): every imported rival is already met
 * (importer game.js:10333 seeds met: true), so this is a no-op until
 * fresh-game seeding lands — kept for pipeline-order fidelity. */
static void check_contact(void) {
    for (int rn = 0; rn < 4; rn++) {
        if (rn == (int)cs_nation()) continue;
        if (CR.rivals[rn].met) continue;
        /* TBD with seedRivals: the near-scan + REL.MET + woodcut 10 */
    }
}

void rival_turn(void) {
    for (int rn = 0; rn < 4; rn++) {
        if (rn == (int)cs_nation()) continue;
        rival_rt *r = &CR.rivals[rn];
        int war = at_war(cs_nation(), rn);
        /* JS iterates r.units = ships (record order) then land units
         * (record order) — the importer's two-pass build. */
        for (int pass = 0; pass < 2; pass++)
        for (int ui = 0; ui < CS.n_units; ui++) {
            if (!is_rival_unit(ui, rn)) continue;
            int ship = dat_units[CS.units[ui].type].hull > 0;
            if ((pass == 0) != (ship != 0)) continue;
            int16_t *px = &CR.runit_x[ui], *py = &CR.runit_y[ui];
            if (ship) {
                /* westward settler: coast ahead (W, N, S; off-map reads
                 * Ocean, game.js:469) plants a colony */
                static const int LDX[3] = { -1, 0, 0 };
                static const int LDY[3] = { 0, -1, 1 };
                int lx = 0, ly = 0, land = 0;
                for (int k = 0; k < 3 && !land; k++) {
                    int x = *px + LDX[k], y = *py + LDY[k];
                    if (!tile_water(map_at(x, y))) { lx = x; ly = y; land = 1; }
                }
                if (land && r->n_col < 6) {
                    int taken = 0;
                    for (int ci = 0; ci < CS.n_colonies && !taken; ci++)
                        if ((CS.colonies[ci].owner_power & 3) == cs_nation() &&
                            CS.colonies[ci].map_x == lx &&
                            CS.colonies[ci].map_y == ly) taken = 1;
                    for (int k = 0; k < r->n_col && !taken; k++)
                        if (r->col[k].x == lx && r->col[k].y == ly) taken = 1;
                    for (int v = 0; v < CS.n_villages && !taken; v++)
                        if (CS.villages[v].map_x == lx &&
                            CS.villages[v].map_y == ly) taken = 1;
                    if (!taken) {
                        if (r->n_col < (int)(sizeof(r->col) / sizeof(r->col[0]))) {
                            r->col[r->n_col].x = (int16_t)lx;
                            r->col[r->n_col].y = (int16_t)ly;
                            r->col[r->n_col].level = 0;
                            r->col[r->n_col].pop = 1;
                            r->n_col++;
                        }
                        r->next_colony++;    /* name rotation (names unused) */
                        int nx2 = *px + 3;   /* stand off, look for another */
                        *px = (int16_t)(nx2 > COLOPY_MAP_W - 1 ?
                                        COLOPY_MAP_W - 1 : nx2);
                        continue;
                    }
                }
                {
                    int nx = *px - 1;
                    if (nx >= 0 && tile_water(map_at(nx, *py))) *px = (int16_t)nx;
                    else *py = (int16_t)(*py + ((*py % 2) ? 1 : -1));
                }
                continue;
            }
            /* land units: garrison at peace; the parley when beside the
             * player's people (screen is 'map', no dialog — headless) */
            if (!war) {
                if (!parley_eligible(rn)) continue;
                int near = 0;
                for (int pu = 0; pu < CS.n_units && !near; pu++) {
                    if (!unit_on_map_player(pu)) continue;
                    int dx = CS.units[pu].map_x - *px;
                    int dy = CS.units[pu].map_y - *py;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx <= 1 && dy <= 1) near = 1;
                }
                for (int ci = 0; ci < CS.n_colonies && !near; ci++) {
                    if ((CS.colonies[ci].owner_power & 3) != cs_nation())
                        continue;
                    int dx = CS.colonies[ci].map_x - *px;
                    int dy = CS.colonies[ci].map_y - *py;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx <= 1 && dy <= 1) near = 1;
                }
                if (near) run_meeting(rn);
                continue;
            }
            /* WAR branch (game.js:7553-7603): garrison-first, attack the
             * nearest player colony through resolveAttack, the capture/
             * burn aftermath.  UNREACHABLE until a ported path sets
             * REL.WAR — lands with the combat-resolution slice. */
        }
    }
    check_contact();
}
