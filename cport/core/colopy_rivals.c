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
#include "../data/colopy_text.h"   /* count MACROS only — no text symbols */

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
    return (u->owner_flags & 0x0F) == rn && u->type < DAT_UNITS_COUNT &&
           !CR.unit_in_natives[ui];      /* captured units left r.units */
}
static int R(int n) { return (int)((rng_next() * (uint32_t)n) >> 15); }

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
        /* r.units order (the CR list): ships-then-land at import, plus
         * succession appends.  JS iterates a slice() snapshot; the only
         * mid-loop removal is the current attacker itself, handled at
         * the resolve sites below. */
        for (int k = 0; k < CR.n_runits[rn]; k++) {
            int ui = CR.runits_order[rn][k];
            int ship = dat_units[CS.units[ui].type].hull > 0;
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
                /* G.screen === 'map' gate (game.js:7547): the retirement
                 * report parks the screen elsewhere */
                if (!CR.screen_map || !parley_eligible(rn)) continue;
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
            /* WAR branch (game.js:7553): garrison-first, then the attack
             * mission — strike an adjacent foe, assault the palisade, or
             * march one step at the nearest player colony. */
            {
                int in_own = 0;
                for (int k = 0; k < r->n_col && !in_own; k++)
                    if (r->col[k].x == *px && r->col[k].y == *py) in_own = 1;
                int stacked = 0;
                for (int qi = 0; qi < CS.n_units && !stacked; qi++)
                    if (qi != ui && is_rival_unit(qi, rn) &&
                        dat_units[CS.units[qi].type].hull <= 0 &&
                        CR.runit_x[qi] == *px && CR.runit_y[qi] == *py)
                        stacked = 1;
                if (in_own && !stacked) continue;
                int target = -1, bd = 0;
                for (int ci = 0; ci < CS.n_colonies; ci++) {
                    if ((CS.colonies[ci].owner_power & 3) != cs_nation())
                        continue;
                    int ddx = CS.colonies[ci].map_x - *px;
                    int ddy = CS.colonies[ci].map_y - *py;
                    int d = (ddx < 0 ? -ddx : ddx) + (ddy < 0 ? -ddy : ddy);
                    if (target < 0 || d < bd) { target = ci; bd = d; }
                }
                if (target < 0) continue;
                int foe = -1;
                for (int k = 0; k < CR.n_units_order && foe < 0; k++) {
                    int pu = CR.units_order[k];      /* G.units order */
                    if (dat_units[CS.units[pu].type].hull > 0) continue;
                    int ddx = CS.units[pu].map_x - *px;
                    int ddy = CS.units[pu].map_y - *py;
                    if (ddx < 0) ddx = -ddx;
                    if (ddy < 0) ddy = -ddy;
                    if (ddx <= 1 && ddy <= 1) foe = pu;
                }
                if (foe >= 0) {
                    /* the only unit this fight can remove from THIS list
                     * is the attacker itself (death OR capture) — the JS
                     * slice() snapshot just walks on; the live list slid,
                     * so step back one slot */
                    uint16_t nb = CR.n_runits[rn];
                    resolve_attack(ui, foe);
                    if (CR.n_runits[rn] < nb) k--;
                    continue;
                }
                const ColonyRecord *tc = &CS.colonies[target];
                int adx = tc->map_x - *px, ady = tc->map_y - *py;
                if (adx < 0) adx = -adx;
                if (ady < 0) ady = -ady;
                if ((adx > ady ? adx : ady) <= 1) {
                    int inside = -1;
                    for (int k = 0; k < CR.n_units_order && inside < 0; k++) {
                        int pu = CR.units_order[k];
                        if (dat_units[CS.units[pu].type].hull <= 0 &&
                            CS.units[pu].map_x == tc->map_x &&
                            CS.units[pu].map_y == tc->map_y) inside = pu;
                    }
                    if (inside >= 0) {
                        uint16_t nb = CR.n_runits[rn];
                        resolve_attack(ui, inside);
                        if (CR.n_runits[rn] < nb) k--;
                        continue;
                    }
                    /* the empty colony falls: capture (plunder + transfer)
                     * under six colonies, razing over (@CAPTURED/@BURNED2;
                     * the burn-vs-capture selector is unread — flagged in
                     * JS, mirrored) */
                    int tx = tc->map_x, ty = tc->map_y;
                    int tpop = tc->population ? tc->population : 1;
                    colony_remove(target);
                    if (r->n_col < 6) {
                        PowerRecord *p = &CS.powers[cs_nation()];
                        int32_t plunder = 50 * tpop;
                        if (plunder > p->gold) plunder = p->gold;
                        p->gold -= plunder;
                        if (r->n_col < (int)(sizeof(r->col) / sizeof(r->col[0]))) {
                            r->col[r->n_col].x = (int16_t)tx;
                            r->col[r->n_col].y = (int16_t)ty;
                            r->col[r->n_col].level = 0;
                            r->col[r->n_col].pop = (uint8_t)tpop;
                            r->col[r->n_col].spared = 0;
                            r->n_col++;
                        }
                        ev_emit("CAPTURED", plunder, 0,
                                dat_nations[rn].adjective, 0);
                    } else {
                        ev_emit("BURNED2", 0, 0, dat_nations[rn].country, 0);
                    }
                    continue;
                }
                /* one step at the target (straight-line stand-in, flagged) */
                static const int DX[8] = { 1, -1, 0, 0, 1, 1, -1, -1 };
                static const int DY[8] = { 0, 0, 1, -1, 1, -1, 1, -1 };
                int bx = -1, by = -1, sd = 0;
                for (int s = 0; s < 8; s++) {
                    int x = *px + DX[s], y = *py + DY[s];
                    if (x < 0 || y < 0 || x >= COLOPY_MAP_W ||
                        y >= COLOPY_MAP_H) continue;
                    if (tile_water(map_at(x, y))) continue;
                    int blocked = 0;
                    for (int qi = 0; qi < CS.n_units && !blocked; qi++)
                        if (qi != ui && is_rival_unit(qi, rn) &&
                            CR.runit_x[qi] == x && CR.runit_y[qi] == y)
                            blocked = 1;
                    for (int v = 0; v < CS.n_villages && !blocked; v++)
                        if (CS.villages[v].map_x == x &&
                            CS.villages[v].map_y == y) blocked = 1;
                    if (blocked) continue;
                    int ddx = tc->map_x - x, ddy = tc->map_y - y;
                    int d = (ddx < 0 ? -ddx : ddx) + (ddy < 0 ? -ddy : ddy);
                    if (bx < 0 || d < sd) { bx = x; by = y; sd = d; }
                }
                if (bx >= 0) { *px = (int16_t)bx; *py = (int16_t)by; }
            }
        }
    }
    check_contact();
}

/* ====================================================================
 * The endTurn tail past rivalTurn — newsTick (game.js:7366), kingWarCycle
 * (8956), kingTaxDemand (8647), shoreBombardment (6934), spanishSuccession
 * (6998), aiDiplomacyTick (8484), the retirement clock (10800) — plus the
 * steps that are structurally no-ops headless, named where they fall.
 * ==================================================================== */

/* nationalSoL (game.js:8856): pop-weighted colony SoL + Simon Bolivar. */
static int national_sol(void) {
    int pop = 0;
    long acc = 0;
    for (int ci = 0; ci < CS.n_colonies; ci++) {
        if ((CS.colonies[ci].owner_power & 3) != cs_nation()) continue;
        pop += CS.colonies[ci].population;
        acc += (long)rt_sol(ci) * CS.colonies[ci].population;
    }
    int m = pop ? (int)(acc / pop) : 0;
    for (int i = 0; i < DAT_FATHERS_COUNT; i++)
        if (strcmp(dat_fathers[i].name, "Simon Bolivar") == 0 &&
            ((CS.powers[cs_nation()].founding_fathers >> i) & 1)) m += 20;
    return m < 0 ? 0 : m > 100 ? 100 : m;
}
static int rival_colony_level(int ci) {          /* colonyLevel by name */
    if (colony_has_name(ci, "Fortress")) return 3;
    if (colony_has_name(ci, "Fort")) return 2;
    if (colony_has_name(ci, "Stockade")) return 1;
    return 0;
}

/* newsTick (game.js:7366) — the third-party bulletin bus; rates flagged
 * in the JS, mirrored draw-for-draw. */
static void news_tick(void) {
    int me = cs_nation();
    for (int rn = 0; rn < 4; rn++) {
        if (rn == me) continue;
        rival_rt *r = &CR.rivals[rn];
        if (!r->met) continue;
        /* the independence race (PowerRecord +0x02 unmodeled — a flagged
         * random walk stands in) */
        if (cs_year() >= 1650 && !r->independent) {
            int v = r->rebel_pct + ((int)rng_next() <= 19660 ? 1 : -1);
            if (v < 0) v = 0;
            r->rebel_pct = (uint8_t)v;
            if (v >= 40 && !r->might_warned) {
                r->might_warned = 1;
                ev_emit("OTHERMIGHT", v, 0, dat_nations[rn].country, 0);
            } else if (r->might_warned && v < 35 && !r->less_noted) {
                r->less_noted = 1;
                ev_emit("OTHERLESS", v, 0, dat_nations[rn].country, 0);
            } else if (v >= 60) {
                r->independent = 1;
                ev_emit("OTHERGRANTED", v, 0, dat_nations[rn].country, 0);
            }
        }
        /* @VIOLATE: a rival unit loitering beside our colony at peace */
        if (!at_war(me, rn) && R(24) == 0) {
            int tres = -1;
            for (int k = 0; k < CR.n_runits[rn] && tres < 0; k++) {
                int ui = CR.runits_order[rn][k];       /* r.units order */
                for (int ci = 0; ci < CS.n_colonies; ci++) {
                    if ((CS.colonies[ci].owner_power & 3) != me) continue;
                    int dx = CS.colonies[ci].map_x - CR.runit_x[ui];
                    int dy = CS.colonies[ci].map_y - CR.runit_y[ui];
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx <= 1 && dy <= 1) { tres = ui; break; }
                }
            }
            if (tres >= 0)
                ev_emit("VIOLATE", 0, 0, dat_nations[rn].adjective, 0);
        }
        /* @SNEAK: undeclared hostilities — war lands as it fires */
        if (!at_war(me, rn) && R(60) == 0) {
            int agg = -1, prey = -1;
            for (int rk = 0; rk < CR.n_runits[rn] && agg < 0; rk++) {
                int ui = CR.runits_order[rn][rk];    /* r.units order */
                if (dat_units[CS.units[ui].type].hull > 0) continue;
                for (int k = 0; k < CR.n_units_order; k++) {
                    int pu = CR.units_order[k];      /* G.units order */
                    if (dat_units[CS.units[pu].type].hull > 0) continue;
                    int dx = CS.units[pu].map_x - CR.runit_x[ui];
                    int dy = CS.units[pu].map_y - CR.runit_y[ui];
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx <= 1 && dy <= 1) { agg = ui; prey = pu; break; }
                }
            }
            if (agg >= 0 && prey >= 0) {
                ev_emit("SNEAK", 0, 0, dat_nations[rn].adjective, 0);
                CR.war_matrix[rn][me] |= REL_WAR;
                resolve_attack(agg, prey);
                continue;                        /* game.js:7411 */
            }
        }
        /* @LOOTFOREIGN: a rival treasure fleet reaches home (simulated) */
        if (R(60) == 0 && r->n_col) {
            int booty = 100 * (2 + R(11));
            r->gold += booty;
            ev_emit("LOOTFOREIGN", booty, 0, dat_nations[rn].adjective, 0);
        }
        /* @GIVECASH: a threatened AI colony buys the player off (stub) */
        if (at_war(me, rn)) {
            int scared = -1;
            for (int k = 0; k < r->n_col && scared < 0; k++) {
                if (r->col[k].spared) continue;
                for (int pu = 0; pu < CS.n_units; pu++) {
                    if (!unit_on_map_player(pu) ||
                        dat_units[CS.units[pu].type].hull > 0 ||
                        dat_units[CS.units[pu].type].attack <= 0) continue;
                    int dx = r->col[k].x - CS.units[pu].map_x;
                    int dy = r->col[k].y - CS.units[pu].map_y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx <= 1 && dy <= 1) { scared = k; break; }
                }
            }
            if (scared >= 0 && R(6) == 0) {
                r->col[scared].spared = 1;
                ev_emit("GIVECASH", 0, 0, 0, 0);     /* ask stub */
            }
        }
        /* native-vs-rival raiding (simulated; rates flagged in JS) */
        if (!r->n_col) continue;
        if (R(24) != 0) continue;
        int rci = R(r->n_col);
        rival_colony *rc = &r->col[rci];
        int vi = -1;
        for (int v = 0; v < CS.n_villages && vi < 0; v++) {
            if (CR.alarm[v] < 0x80) continue;
            int dx = CS.villages[v].map_x - rc->x;
            int dy = CS.villages[v].map_y - rc->y;
            if (dx < 0) dx = -dx;
            if (dy < 0) dy = -dy;
            if (dx <= 4 && dy <= 4) vi = v;
        }
        if (vi < 0) continue;
        {
            int tribe = CS.villages[vi].owner_tribe - 4;
            if (tribe < 0 || tribe >= 8) continue;
            int k = (int)rng_next();
            int pop = rc->pop ? rc->pop : 1;
            if (k <= 6553 && pop <= 1) {             /* < 0.2 */
                memmove(&r->col[rci], &r->col[rci + 1],
                        (size_t)(r->n_col - rci - 1) * sizeof(rival_colony));
                r->n_col--;
                ev_emit("INDIANBURNCOLONY2", 0, 0, dat_tribes[tribe].name, 0);
            } else if (k <= 16383) {                 /* < 0.5 */
                rc->pop = (uint8_t)(pop - 1 > 1 ? pop - 1 : 1);
                ev_emit("INDIANWINCOLONY2", 0, 0, dat_tribes[tribe].name, 0);
            } else {
                ev_emit("INDIANLOSE", 0, 0, dat_tribes[tribe].name, 0);
            }
        }
    }
    /* rival-vs-rival wars (simulated tick; bulletins byte-read) */
    {
        int list[3], nl = 0;
        for (int n = 0; n < 4; n++)
            if (n != me) list[nl++] = n;
        for (int i = 0; i < nl; i++)
            for (int j = i + 1; j < nl; j++) {
                int a = list[i], b = list[j];
                if (!CR.rivals[a].met || !CR.rivals[b].met) continue;
                if (!CR.rival_wars[a][b]) {
                    if (R(80) == 0) CR.rival_wars[a][b] = 1;
                    continue;
                }
                if (R(80) == 0) { CR.rival_wars[a][b] = 0; continue; }
                int k = (int)rng_next();
                if (k <= 2730) {                     /* < 1/12: a battle */
                    (void)((int)rng_next() <= 16383 ? a : b);  /* winner */
                    (void)R(5);                      /* the unit type */
                    ev_emit((int)rng_next() <= 16383 ? "EUROPEWIN"
                                                     : "EUROPELOSE",
                            0, 0, 0, 0);
                } else if (k <= 3549 && CR.rivals[b].n_col) { /* < 13/120 */
                    int victim = ((int)rng_next() <= 16383 &&
                                  CR.rivals[a].n_col) ? a : b;
                    int winner = victim == a ? b : a;
                    rival_rt *vr = &CR.rivals[victim], *wr = &CR.rivals[winner];
                    int vi2 = R(vr->n_col);
                    rival_colony vc = vr->col[vi2];
                    memmove(&vr->col[vi2], &vr->col[vi2 + 1],
                            (size_t)(vr->n_col - vi2 - 1) * sizeof(rival_colony));
                    vr->n_col--;
                    if ((int)rng_next() <= 16383 && wr->n_col < 6) {
                        if (wr->n_col < (int)(sizeof(wr->col) / sizeof(wr->col[0])))
                            wr->col[wr->n_col++] = vc;
                        ev_emit("CAPTURED2", 0, 0, dat_nations[winner].country, 0);
                    } else {
                        ev_emit("BURNED3", 0, 0, dat_nations[winner].country, 0);
                    }
                }
            }
    }
}

/* kingWarCycle (game.js:8956): the Crown's European war — grant + veteran
 * soldiers on entry, tax relief on exit, mercy/frigate rolls between. */
static void king_war_cycle(void) {
    if (CR.retired) return;                      /* (and never once WoI) */
    int me = cs_nation();
    PowerRecord *p = &CS.powers[me];
    if (CR.king_war_rival < 0) {
        if (cs_turn() < 40 || R(40) != 0) return;
        int foes[3], nf = 0;
        for (int n = 0; n < 4; n++)
            if (n != me && CR.rivals[n].met) foes[nf++] = n;
        if (!nf) return;
        int foe = foes[R(nf)];
        CR.king_war_rival = (int8_t)foe;
        CR.king_war_turns = (uint8_t)(8 + R(8));
        p->gold += 300;
        int c0 = -1;
        for (int ci = 0; ci < CS.n_colonies && c0 < 0; ci++)
            if ((CS.colonies[ci].owner_power & 3) == me) c0 = ci;
        if (c0 >= 0) {
            int ts = -1, vet = -1;
            for (int i = 0; i < DAT_UNITS_COUNT; i++)
                if (strcmp(dat_units[i].name, "Soldiers") == 0) ts = i;
            for (int i = 0; i < DAT_JOBEXPERT_COUNT; i++)
                if (strcmp(dat_jobexpert[i], "Veteran Soldiers") == 0 &&
                    vet < 0) vet = i;
            for (int k = 0; k < 2; k++) {
                int ui = unit_append(ts, me, CS.colonies[c0].map_x,
                                     CS.colonies[c0].map_y);
                if (ui >= 0 && vet >= 0)
                    CS.units[ui].profession = (uint8_t)vet;
            }
        }
        CR.treaty_matrix[me][foe] &= (uint8_t)~REL_TREATY;   /* symmetric */
        CR.treaty_matrix[foe][me] &= (uint8_t)~REL_TREATY;
        CR.war_matrix[me][foe] |= REL_WAR;
        ev_emit("KINGNEWWAR", 300, 2, dat_nations[foe].adjective, 0);
        return;
    }
    CR.king_war_turns--;
    if (CR.king_war_turns == 0) {
        p->tax_rate = (uint8_t)(p->tax_rate >= 2 ? p->tax_rate - 2 : 0);
        ev_emit("KINGVICTORY", 2, p->tax_rate,
                dat_nations[CR.king_war_rival].adjective, 0);
        CR.war_matrix[me][CR.king_war_rival] &= (uint8_t)~REL_WAR;
        CR.king_war_rival = -1;
        return;
    }
    int roll = R(24);
    if (roll == 0) {
        p->tax_rate = (uint8_t)(p->tax_rate >= 1 ? p->tax_rate - 1 : 0);
        ev_emit("KINGMERCY", 1, p->tax_rate, 0, 0);
    } else if (roll == 1) {
        /* @KINGFRIGATE needs a fleet: an on-map ship or one in Europe
         * (off-map).  G.kingFrigate is only set in the callback — never
         * headless — so the offer can repeat, like the JS. */
        int fleet = 0;
        for (int ui = 0; ui < CS.n_units && !fleet; ui++) {
            const UnitRecord *u = &CS.units[ui];
            if ((u->owner_flags & 0x0F) != me ||
                u->type >= DAT_UNITS_COUNT ||
                dat_units[u->type].hull <= 0) continue;
            fleet = 1;                   /* on map or parked in Europe */
        }
        if (fleet) ev_emit("KINGFRIGATE", 0, 0, 0, 0);   /* ask stub */
    }
}

/* kingTaxDemand (game.js:8647): cadence func_036138, raise func_034AE0,
 * pretext severity @0x361CC — the ask is stubbed, so the tax never moves
 * headless (row 0 is the callback's). */
static void king_tax_demand(void) {
    int me = cs_nation();
    PowerRecord *p = &CS.powers[me];
    if (cs_turn() < 30 || p->tax_rate > 85) return;
    int base = cs_year() >= 1750 ? 9 : cs_year() >= 1700 ? 12
             : cs_year() >= 1600 ? 15 : 18;
    int interval = base - (cs_difficulty() - 2);
    if (interval < 2) interval = 2;
    if (cs_turn() % interval != 0) return;
    int candidate = (((cs_difficulty() & 0xFE) << 1) + 4) *
                    ((int)cs_turn() / 400 + 1);
    if (p->tax_rate <= candidate && 1 + R(cs_difficulty() + 1) == 1) return;
    /* raise clamp (unused headless) and the Party-good scan (subs only) */
    int sev = 1 + R(1000) + (2 * national_sol() - p->tax_rate) * 5 +
              (int)(p->gold / 100) + (int)cs_turn() / 30;
    const char *key;
    if (sev < 0x28A) {
        if (!CR.king_wed) { CR.king_wed = 1; key = "KINGWIFE"; }
        else key = "KINGTAX";
    } else if (sev < 0x3B6) key = "KINGWAR";
    else if (sev < 0x44C) key = "KINGNAVACT";
    else key = "KINGSTAMPACT";
    ev_emit(key, 0, 0, 0, 0);                    /* ask stub */
}

/* shoreBombardment (game.js:6934): fort guns fire on a hostile ship
 * beside a fortified colony with stacked Artillery.  One volley a turn. */
static void shore_bombardment(void) {
    int me = cs_nation();
    for (int ci = 0; ci < CS.n_colonies; ci++) {
        if ((CS.colonies[ci].owner_power & 3) != me) continue;
        int level = rival_colony_level(ci);
        if (!level) continue;
        int guns = 0;
        for (int ui = 0; ui < CS.n_units; ui++)
            if (unit_on_map_player(ui) &&
                strcmp(dat_units[CS.units[ui].type].name, "Artillery") == 0 &&
                CS.units[ui].map_x == CS.colonies[ci].map_x &&
                CS.units[ui].map_y == CS.colonies[ci].map_y) guns++;
        if (!guns) continue;
        for (int rn = 0; rn < 4; rn++) {
            if (rn == me || !at_war(me, rn)) continue;
            int ship = -1;
            for (int k = 0; k < CR.n_runits[rn] && ship < 0; k++) {
                int ui = CR.runits_order[rn][k];     /* r.units order */
                if (dat_units[CS.units[ui].type].hull <= 0) continue;
                int dx = CR.runit_x[ui] - CS.colonies[ci].map_x;
                int dy = CR.runit_y[ui] - CS.colonies[ci].map_y;
                if (dx < 0) dx = -dx;
                if (dy < 0) dy = -dy;
                if (dx <= 1 && dy <= 1) ship = ui;
            }
            if (ship < 0) continue;
            ev_emit("FORTFIRE", 0, 0, CS.colonies[ci].name,
                    dat_units[CS.units[ship].type].name);
            if (!CR.unit_damaged[ship]) CR.unit_damaged[ship] = 1;
            else unit_remove(ship);
            return;
        }
    }
}

/* spanishSuccession (game.js:6998, func_03C638): the Treaty of Utrecht —
 * weakest AI cedes everything to the strongest, once per game. */
static int power_strength(int rn) {
    int s = CR.rivals[rn].n_col * 3;
    for (int ui = 0; ui < CS.n_units; ui++)
        if (is_rival_unit(ui, rn)) s++;
    return s;
}
static void spanish_succession(void) {
    if (CR.succession) return;                   /* (and never once WoI) */
    if (national_sol() >= 75) return;
    int me = cs_nation();
    int list[3], nl = 0;
    for (int n = 0; n < 4; n++)
        if (n != me) list[nl++] = n;
    if (nl < 2) return;
    if (R(600) != 0) return;
    /* stable sort by strength ascending (JS Array.sort is stable) */
    for (int i = 1; i < nl; i++) {
        int v = list[i], j = i - 1;
        while (j >= 0 && power_strength(list[j]) > power_strength(v)) {
            list[j + 1] = list[j];
            j--;
        }
        list[j + 1] = v;
    }
    int ceding = list[0], winner = list[nl - 1];
    if (ceding == winner) return;
    CR.succession = 1;
    ev_emit("SUCCESSION", 0, 0, dat_nations[ceding].country,
            dat_nations[winner].adjective);
    rival_rt *cr_ = &CR.rivals[ceding], *wr = &CR.rivals[winner];
    for (int k = 0; k < cr_->n_col; k++)
        if (wr->n_col < (int)(sizeof(wr->col) / sizeof(wr->col[0])))
            wr->col[wr->n_col++] = cr_->col[k];
    cr_->n_col = 0;
    /* units transfer in the ceding LIST order, APPENDED to the winner's
     * list (game.js:7015 winner.units.push) */
    for (int k = 0; k < CR.n_runits[ceding]; k++) {
        int ui = CR.runits_order[ceding][k];
        CS.units[ui].owner_flags = (uint8_t)
            ((CS.units[ui].owner_flags & 0xF0) | (winner & 0x0F));
        runits_push(winner, ui);
    }
    CR.n_runits[ceding] = 0;
}

/* aiDiplomacyTick (game.js:8484): AI-AI peace/treaty signings. */
static void ai_diplomacy_tick(void) {
    if (cs_turn() < 0x28 || cs_turn() % 3) return;
    int me = cs_nation();
    int list[3], nl = 0;
    for (int n = 0; n < 4; n++)
        if (n != me && CR.rivals[n].met) list[nl++] = n;
    for (int i = 0; i < nl; i++)
        for (int j = i + 1; j < nl; j++) {
            int a = list[i], b = list[j];
            /* both attitudes are 8 — the <8 && <8 skip never fires */
            if (R(1000) >= 200 * cs_difficulty() + 100) continue;
            if (at_war(a, b)) {
                CR.war_matrix[a][b] &= (uint8_t)~REL_WAR;
                CR.war_matrix[b][a] &= (uint8_t)~REL_WAR;
                ev_emit("SIGNTREATY", 0, 0, dat_nations[a].adjective,
                        dat_nations[b].adjective);
            } else if (!have_treaty(a, b)) {
                CR.treaty_matrix[a][b] |= REL_TREATY;
                CR.treaty_matrix[b][a] |= REL_TREATY;
                ev_emit("SIGNTREATY", 0, 0, dat_nations[a].adjective,
                        dat_nations[b].adjective);
            }
        }
}

/* endGameSequence (game.js:8119): the HoF write is browser-side (n.a.);
 * what the sim sees is the retired latch, the @EXPLOITS card, ONE draw
 * for the @SCORE joke-name pick, the @SCORED ask (stubbed), and the
 * screen leaving the map — which closes the parley gate.  scoreParts is
 * draw-free.  DAT_SCORENAMES_COUNT is a scalar macro from the text
 * header; the strings themselves stay in the droppable text unit. */
static void end_game_sequence(void) {
    CR.retired = 1;
    ev_emit("EXPLOITS", 0, 0, 0, 0);
    (void)R(DAT_SCORENAMES_COUNT);       /* the joke-name notice pick */
    CR.screen_map = 0;                   /* G.screen = 'report' */
    ev_emit("SCORED", 0, 0, 0, 0);       /* ask stub */
}

/* The retirement clock (endTurn:10800). */
static void retirement_check(void) {
    if (CR.retired) return;
    int ncol = 0;
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation()) ncol++;
    if (cs_year() >= 1600 && !ncol && cs_turn() > 30) {
        ev_emit("LOSENOCOLONIES", 0, 0, 0, 0);
        end_game_sequence();
        return;
    }
    if (cs_year() >= 1790 && !CR.soon_warned) {
        CR.soon_warned = 1;
        ev_emit("SOONRETIRING0", 0, 0, 0, 0);
    }
    if (cs_year() >= 1800) {
        ev_emit("RETIRING", 0, 0, 0, 0);
        end_game_sequence();
    }
}

/* The full endTurn tail, in engine order (endTurn:10781-10821).  Steps
 * that are structural no-ops headless are named in place:
 *   advanceTradeRoutes/advanceGoTo — no unit carries runtime trade/goto
 *     orders (the importer starts every unit at orders 0);
 *   runWar/toryUprising/offerMercenaries/checkIntervention — WoI-gated
 *     (G.flags stays 0: the declaration is an ask the stub never answers);
 *   advanceCrossings — every imported Europe ship is state 'port'. */
void turn_step5(void) {
    rival_turn();
    news_tick();
    king_war_cycle();
    king_tax_demand();
    /* advanceTradeRoutes(); advanceGoTo(); — no-ops (above) */
    /* runWar(); toryUprising(); — WoI-gated */
    shore_bombardment();
    spanish_succession();
    ai_diplomacy_tick();
    /* offerMercenaries(); checkIntervention(); — WoI-gated */
    market_drift();
    /* advanceCrossings(); — no-op (above) */
    retirement_check();
}
