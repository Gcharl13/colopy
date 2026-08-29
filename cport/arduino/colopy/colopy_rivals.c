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
 * Ask semantics — CORRECTED 2026-08-19, the old wording was badly stale.
 *
 * It used to read: "askEvent is stubbed (key only, callback never runs), so
 * every meeting topic ENDS at its first ask — treaties, tribute payments,
 * war declarations and withdrawals never execute … no ported path writes
 * REL.WAR".  None of that is true any more, and it was being read as
 * current: it put "European diplomacy = STUB" into a status overview.
 *
 * What is actually true: ask_choice() RETURNS a answer and the code after
 * it runs.  In live play the board installs colopy_ask_hook (board_ask,
 * colopy_p4.ino) and the PLAYER answers; in the parity trace a scripted
 * per-prompt counter answers.  Either way meeting_topic acts on the
 * result at 13 sites — accept_treaty() writes the treaty matrix and clears
 * REL_WAR, declare_war_on() sets REL_WAR, the @PIRACY row sails every
 * player Privateer home, tribute and tension adjustments apply.
 *
 * The residual, stated narrowly so it cannot inflate again: the war matrix
 * starts EMPTY on import (the JS importer does not populate it — TBD
 * against PowerRecord +0x34), so a loaded save begins with no wars in
 * progress and rivalTurn's WAR branch only becomes reachable once a war is
 * declared in play. */
#include <stdio.h>
#include <string.h>

#include "colopy_sim.h"
#include "colopy_data.h"
#include "colopy_text.h"   /* count MACROS only — no text symbols */

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

/* demandValue (game.js:8214, byte-cited scaler @0x583A0/@0x5842B) */
int32_t demand_value(int base) {
    return base * 10 * (cs_difficulty() + 8) / 100 +
           500 * (cs_difficulty() + 1);
}
/* declareWarOn / signTreaty / acceptTreaty (game.js:8186-8202/8409) */
static void declare_war_on(int a, int b) {
    CR.war_matrix[a][b] |= REL_WAR;
    CR.treaty_matrix[a][b] &= (uint8_t)~REL_TREATY;
    CR.treaty_matrix[b][a] &= (uint8_t)~REL_TREATY;
    ev_emit("DECLAREWAR", 0, 0, dat_nations[a].adjective,
            dat_nations[b].adjective);
}
static void accept_treaty(int rn) {
    int me = cs_nation();
    CR.war_matrix[me][rn] &= (uint8_t)~REL_WAR;
    CR.war_matrix[rn][me] &= (uint8_t)~REL_WAR;
    CR.treaty_matrix[me][rn] |= REL_TREATY;
    CR.treaty_matrix[rn][me] |= REL_TREATY;
    CR.parley_lock[rn] = (uint16_t)(cs_turn() + PARLEY_LOCKOUT);
    /* silent: @SIGNTREATY belongs to the AI-AI ticker */
}
/* meetingWithdraw (game.js:8414): buy the loiterers off, or be refused. */
static void meeting_withdraw(int rn) {
    int me = cs_nation();
    int forces[64], nf = 0;
    for (int k = 0; k < CR.n_runits[rn] && nf < 64; k++) {
        int ui = CR.runits_order[rn][k];
        if (dat_units[CS.units[ui].type].hull > 0) continue;
        for (int ci = 0; ci < CS.n_colonies; ci++) {
            if ((CS.colonies[ci].owner_power & 3) != me) continue;
            int dx = CS.colonies[ci].map_x - CR.runit_x[ui];
            int dy = CS.colonies[ci].map_y - CR.runit_y[ui];
            if (dx < 0) dx = -dx;
            if (dy < 0) dy = -dy;
            if (dx <= 1 && dy <= 1) { forces[nf++] = ui; break; }
        }
    }
    if (!nf) { ev_emit("NOTHINGWITHDRAW", 0, 0, 0, 0); return; }
    int32_t price = 25 * (cs_difficulty() + 2) * nf - 50 * nf;
    if (price < 100) price = 100;
    if (at_war(me, rn)) price *= 2;
    for (int i = 0; i < DAT_FATHERS_COUNT; i++)
        if (strcmp(dat_fathers[i].name, "Benjamin Franklin") == 0 &&
            ((CS.powers[me].founding_fathers >> i) & 1)) price >>= 1;
    if (gate()) {
        ev_emit("MAYBEWITHDRAW", price, 0, dat_nations[rn].adjective, 0);
        int c = ask_choice();
        if (c == 0) {
            PowerRecord *p = &CS.powers[me];
            if (p->gold < price) { ev_emit("NOTENOUGH", p->gold, 0, 0, 0); return; }
            p->gold -= price;
            for (int k = nf - 1; k >= 0; k--)    /* descending: safe shifts */
                unit_remove(forces[k]);
            ev_emit("WITHDRAW", 0, 0, 0, 0);
        } else if (c == 1) ev_emit("THREATS", 0, 0, 0, 0);
    } else ev_emit("NOTWITHDRAW", 0, 0, dat_nations[rn].adjective, 0);
}
/* meetingPeaceHub (game.js:8384): the answered rows under the %2 policy
 * are 0 = accept the treaty, 1 = demand a withdrawal (rows 2/3 — threat
 * and alliance — are unreachable under the scripted answers). */
static void meeting_peace_hub(int rn) {
    const char *key = (CR.woi_flags & WOI_DECLARED) ? "PEACEUSA"
        : have_treaty(cs_nation(), rn)
        ? (meeting_tone(rn) ? "OLDPEACEMEEK" : "OLDPEACEMANLY")
        : (meeting_tone(rn) ? "PEACEMEEK" : "PEACEMANLY");
    ev_emit(key, 0, 0, dat_nations[cs_nation()].adjective,
            dat_nations[rn].adjective);
    int c = ask_choice();
    if (c == 0) accept_treaty(rn);
    else if (c == 1) meeting_withdraw(rn);
}

/* meetingTopic (game.js:8266) — the topic cascade.  Draw accounting is the
 * contract: each gate() draws only when its preceding conditions held, in
 * JS short-circuit order. */
static void meeting_topic(int rn) {
    int me = cs_nation();
    int in_grace = cs_turn() < 10 * (10 - cs_difficulty());
    /* @PIRACY — B's accusation once the Privateer hidden-attribution
     * bit is set against him (game.js:8275; reachable since the ship
     * command layer can strike at peace).  Row 1 withdraws: every player
     * Privateer sails for Europe (in G.units order — the crossing-list
     * order is part of the parity contract); either row then falls to
     * the peace hub. */
    if ((CR.war_matrix[me][rn] & REL_PRIVATEER) && !at_war(me, rn)) {
        CR.war_matrix[me][rn] &= (uint8_t)~REL_PRIVATEER;
        ev_emit((CR.woi_flags & WOI_DECLARED) ? "PIRACYUSA" : "PIRACY",
                0, 0, dat_nations[me].adjective, dat_regionname[rn]);
        int k = ask_choice();
        if (k == 1) {
            int priv = -1;
            for (int i = 0; i < DAT_UNITS_COUNT; i++)
                if (strcmp(dat_units[i].name, "Privateer") == 0) priv = i;
            int uis[64], nu = 0;
            for (int q = 0; q < CR.n_units_order && nu < 64; q++) {
                int ui = CR.units_order[q];
                if (CS.units[ui].type == priv) uis[nu++] = ui;
            }
            for (int q = 0; q < nu; q++) {
                cmd_sail_for_europe(uis[q]);
                for (int w = q + 1; w < nu; w++)   /* records compacted */
                    if (uis[w] > uis[q]) uis[w]--;
            }
        }
        meeting_peace_hub(rn);
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
            ev_emit((CR.woi_flags & WOI_DECLARED) ? "SIEGESUSA" : "SIEGES", 0, 0, dat_nations[me].adjective,
                    dat_nations[rn].adjective);
            /* game.js:8302: row 1 recalls the besiegers to the nearest own
             * colony (the engine sends them "to Europe"; nearest-colony is
             * the JS's flagged stand-in), then the hub either way */
            if (ask_choice() == 1) {
                for (int ui = 0; ui < CS.n_units; ui++) {
                    if (!unit_on_map_player(ui)) continue;
                    UnitRecord *u = &CS.units[ui];
                    if (dat_units[u->type].hull > 0 ||
                        dat_units[u->type].attack <= 0) continue;
                    int near_rc = 0;
                    const rival_rt *r = &CR.rivals[rn];
                    for (int k = 0; k < r->n_col && !near_rc; k++) {
                        int dx = r->col[k].x - u->map_x;
                        int dy = r->col[k].y - u->map_y;
                        if (dx < 0) dx = -dx;
                        if (dy < 0) dy = -dy;
                        if (dx <= 1 && dy <= 1) near_rc = 1;
                    }
                    if (!near_rc) continue;
                    int best = -1, bd = 0;
                    for (int ci = 0; ci < CS.n_colonies; ci++) {
                        if ((CS.colonies[ci].owner_power & 3) != me) continue;
                        int dx = CS.colonies[ci].map_x - u->map_x;
                        int dy = CS.colonies[ci].map_y - u->map_y;
                        int d = (dx < 0 ? -dx : dx) + (dy < 0 ? -dy : dy);
                        if (best < 0 || d < bd) { best = ci; bd = d; }
                    }
                    if (best >= 0) {
                        u->map_x = CS.colonies[best].map_x;
                        u->map_y = CS.colonies[best].map_y;
                        CR.runit_x[ui] = u->map_x;
                        CR.runit_y[ui] = u->map_y;
                    }
                }
            }
            meeting_peace_hub(rn);
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
            ev_emit((CR.woi_flags & WOI_DECLARED) ? "APOSTATESUSA" : "APOSTATES", 0, 0, dat_nations[third].adjective, 0);
            /* game.js:8326: row 1 breaks the treaty and joins B's war */
            if (ask_choice() == 1) {
                CR.treaty_matrix[me][third] &= (uint8_t)~REL_TREATY;
                CR.treaty_matrix[third][me] &= (uint8_t)~REL_TREATY;
                declare_war_on(me, third);
            }
            meeting_peace_hub(rn);
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
            ev_emit((CR.woi_flags & WOI_DECLARED) ? "HEATHENUSA" : "HEATHEN", 0, 0, dat_tribes[heathen].name, 0);
            /* game.js:8340: row 1 turns on the tribe (@PISS4 cause) */
            if (ask_choice() == 1) adjust_tension(heathen, 100, 4);
            meeting_peace_hub(rn);
            return;
        }
    }
    /* @TRIBUTE — B's gold extortion, after the grace period */
    if (!in_grace && !at_war(me, rn) && gate()) {
        int32_t want = demand_value(500);
        ev_emit((CR.woi_flags & WOI_DECLARED) ? "TRIBUTEUSA" : "TRIBUTE", want, 0, dat_nations[me].adjective,
                dat_regionname[rn]);
        /* game.js:8350: row 1 pays (NOTENOUGH if broke); a refusal that
         * passes the action gate escalates to war (@WARMEEK/@WARMANLY) */
        if (ask_choice() == 1) {
            PowerRecord *p = &CS.powers[me];
            if (p->gold < want) ev_emit("NOTENOUGH", p->gold, 0, 0, 0);
            else { p->gold -= want; CR.rivals[rn].gold += want; }
            meeting_peace_hub(rn);
        } else if (gate()) {
            ev_emit(meeting_tone(rn) ? "WARMEEK" : "WARMANLY", 0, 0,
                    dat_regionname[rn], 0);
            declare_war_on(rn, me);
        } else meeting_peace_hub(rn);
        return;
    }
    /* @WORTHY — the AI-proposed demarcation treaty */
    if (!have_treaty(me, rn) && !at_war(me, rn) && gate()) {
        ev_emit("WORTHY", 0, 0, dat_nations[me].adjective,
                dat_nations[rn].adjective);
        /* game.js:8375: row 0 accepts, anything else falls to the hub */
        if (ask_choice() == 0) accept_treaty(rn);
        else meeting_peace_hub(rn);
        return;
    }
    meeting_peace_hub(rn);
}

/* runMeeting (game.js:8254).  The AI-initiated parley has no player unit
 * (HELLOFIRST when ungreeted); a player SHIP knocking is HELLOAHOY. */
void run_meeting(int rn, int via_ship) {
    rival_rt *r = &CR.rivals[rn];
    const char *key = (CR.woi_flags & WOI_DECLARED) ? "HELLOUSA"
        : !r->greeted ? (via_ship ? "HELLOAHOY" : "HELLOFIRST")
        : meeting_tone(rn) ? "HELLOMEEK" : "HELLOMANLY";
    r->greeted = 1;
    CR.parley_lock[rn] = (uint16_t)(cs_turn() + PARLEY_LOCKOUT);
    ev_emit(key, 0, 0, dat_regionname[rn], 0);
    meeting_topic(rn);
}

/* Relation accessors for the command layer (colopy_cmd.c) — the REL
 * bit constants stay private to this unit. */
int rel_at_war(int a, int b) { return at_war(a, b); }
int rel_have_treaty(int a, int b) { return have_treaty(a, b); }
int rel_parley_eligible(int rn) { return parley_eligible(rn); }
void rel_declare_war(int a, int b) { declare_war_on(a, b); }
void rel_set_privateer(int a, int b) {
    CR.war_matrix[a][b] |= REL_PRIVATEER;   /* setWar(.., PRIVATEER, true) */
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
        /* B3.6: the power's own colony pass (func_02F052) runs first —
         * same body as the player's, popups silenced.  Mirrors the JS
         * rivalTurn head draw for draw. */
        rival_colony_pass(rn);
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
                            r->col[r->n_col].sol = 0;
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
                if (near) run_meeting(rn, 0);
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
                    /* burn-vs-capture BYTE-READ 2026-08-29 (func_05CA7E
                     * @0x5D574..@0x5D5D0): a EUROPEAN winner always
                     * CAPTURES; only a tribe burns, and only a size-1
                     * colony (bigger ones lose one colonist).  The razing
                     * fallback below is the port's own array-capacity
                     * artifact, not an engine rule (mirrors game.js). */
                    int tx = tc->map_x, ty = tc->map_y;
                    int tpop = tc->population ? tc->population : 1;
                    colony_remove(target);
                    if (r->n_col < 48) {
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
                            r->col[r->n_col].sol = 0;
                            r->n_col++;
                        }
                        /* the @CAPTURED family split @0x5DED1, same gate
                         * the player's own capture uses (colopy_cmd.c):
                         * declared -> CAPTURED3 (no plunder line).  This
                         * site emitted a hard-coded "CAPTURED" until
                         * 2026-08-17, when a Go To timing change let a
                         * rival take a colony after the declaration and
                         * the turns oracle caught it. */
                        ev_emit((CR.woi_flags & WOI_DECLARED)
                                    ? "CAPTURED3" : "CAPTURED",
                                plunder, 0, dat_nations[rn].adjective, 0);
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
int national_sol(void) {
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
        /* the independence bulletin — BYTE_VERIFIED end to end 2026-08-29
         * (func_02F736..@0x2F962, per AI power): pct = min(100,
         * PowerRecord[+0x19] × population_census / 100) (@0x2F8B1) against
         * a GRANT threshold of (8 − difficulty) × 10
         * (@0x2F8CA..@0x2F8DE: Discoverer 80 .. Viceroy 40).  Rising past
         * the stored last-announced value (+0x1A) posts @OTHERMIGHT and
         * stores; falling 5 below it posts @OTHERLESS and stores
         * (@0x2F774..@0x2F87D — NUMBER0 = pct, NUMBER1 = the population
         * census, NUMBER2 = the threshold).  At the threshold
         * @OTHERGRANTED sets the power's flag +0x00 bit 2 and resets its
         * diplomacy vs everyone (@0x2F94D..@0x2F95E — the 0xa06/0xa10
         * write pair's semantics are unread, not modeled).
         *
         * The +0x19 SENTIMENT DRIVER is func_03C424 (stored @0x3E8AA by
         * the per-power updater func_03E844): the power's population-
         * weighted average colony SoL, Σ(size × colonySoL) / Σ(size),
         * with colonySoL = func_008524 = 100·(+0xC2)/(+0xC6).  The port
         * carries each rival colony's imported SoL — static, since rival
         * colonies produce no bells (B3.6); the old random-walk stand-in
         * is gone. */
        if (cs_year() >= 1650 && !r->independent &&
            !(CR.woi_flags & WOI_DECLARED)) {
            int sp = 0, ss = 0;
            for (int k = 0; k < r->n_col; k++) {
                sp += r->col[k].pop;
                ss += r->col[k].pop * r->col[k].sol;
            }
            int sent = sp ? ss / sp : 0;         /* PowerRecord +0x19 */
            int thr = (8 - (int)cs_difficulty()) * 10;
            int pop = CR.n_runits[rn];           /* the census population */
            for (int k = 0; k < r->n_col; k++) pop += r->col[k].pop;
            int v = sent * pop / 100;            /* @0x2F8B1 */
            if (v > 100) v = 100;
            r->rebel_pct = (uint8_t)v;
            if (v >= thr) {
                r->independent = 1;
                ev_emit("OTHERGRANTED", v, pop, dat_nations[rn].country, 0);
            } else if (v > (int)r->last_pct) {
                r->last_pct = (uint8_t)v;
                ev_emit("OTHERMIGHT", v, pop, dat_nations[rn].country, 0);
            } else if ((int)r->last_pct - 5 > v) {
                r->last_pct = (uint8_t)v;
                ev_emit("OTHERLESS", v, pop, dat_nations[rn].country, 0);
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
                int32_t purse = 100 + 50 *
                    (r->col[scared].pop ? r->col[scared].pop : 1);
                ev_emit("GIVECASH", purse, 0, 0, 0);
                if (ask_choice() == 0) {             /* game.js:7435 */
                    CS.powers[me].gold += purse;
                    r->gold = r->gold > purse ? r->gold - purse : 0;
                }
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

/* kingWarCycle — the Crown's European-war cycle, the byte model (read
 * 2026-08-29; the old grant/mercy/frigate reconstruction is gone).
 *
 * @KINGNEWWAR = func_035E80 (0x035E80..0x036137, run per player turn from
 * the immigration/king tick func_0363A2 @0x3656E): HUMAN power only
 * (@0x35EA5), independence attribute clear (@0x35EAF), (diff+2)*turn >=
 * 800 (@0x35EC1); needs >=1 treaty partner (rel & 0x40, @0x35F75) and no
 * royal peace-pending pair ((rel&0x60)==0x20, @0x35F82 — unmodeled here);
 * fires when random_int(0, ((P+2)*2-T)*20) <= difficulty (@0x35F9E).
 * Target: a random treaty partner (@0x35FC6 reroll loop).  soldiers = 1,
 * grant = (diff+1)*100 (@0x35FF6); if the target's census strength byte
 * [0x942C+b] beats ours, d = theirs-ours, soldiers = (d>>3)+1, grant +=
 * 25*d (@0x36007..); clamps soldiers <= 6-diff, grant <= (5-diff)*500
 * (@0x36032..).  Gold += grant; the Veteran Soldier units spawn AT
 * NEGATIVE COORDS = the Europe dock (@0x360DC); treaty bit cleared +
 * king-war bit 0x10 set (@0x36108..) and [0x53C8+b*2] = turn (@0x36128).
 * The war expires at the next diplomatic meeting 16 turns on
 * (diplomacy_meeting_dispatch @0x57FFF); the port clears on expiry
 * directly — flagged proxy (no player-rival meeting dispatcher).
 *
 * @KINGFRIGATE = the func_02F052 upkeep tail (@0x2F286..@0x2F39D): every
 * 8th turn, pre-independence, when the census counts >=1 Frigate-blockaded
 * colony ([0xA89B]) or >3 ship-blockaded ones ([0xA89A]); the per-power
 * byte [0x925D+p*0x13] gate (@0x2F29B) is unread — omitted, TBD.  "Yes"
 * lands a free Frigate on the Europe dock (@0x2F32D) and raises the tax
 * by 10 via @KINGTAX (func_034318(0xF01,10) @0x2F390, cap 75 @0x3434F).
 * No latch — the tallies and the tax cost re-gate it.  @KINGMERCY is dead
 * GAME.TXT content (0 hits in VICEROY.EXE); @KINGVICTORY belongs to the
 * tax-demand bands (king_tax_demand), not to the war end.
 *
 * Strength proxy: the EXE's census byte saturates the per-unit strength
 * query 0x181f:0x9c8 (unread); both ports sum @UNIT attack+combat, cap
 * 255 — FLAGGED. */
static int power_strength_units(void) {
    int s = 0;
    for (int k = 0; k < CR.n_units_order; k++) {
        int t = CS.units[CR.units_order[k]].type;
        if (t < DAT_UNITS_COUNT) {
            s += dat_units[t].attack + dat_units[t].combat;
            if (s > 255) s = 255;
        }
    }
    return s;
}
static int power_strength_rival(int rn) {
    int s = 0;
    for (int k = 0; k < CR.n_runits[rn]; k++) {
        int t = CS.units[CR.runits_order[rn][k]].type;
        if (t < DAT_UNITS_COUNT) {
            s += dat_units[t].attack + dat_units[t].combat;
            if (s > 255) s = 255;
        }
    }
    return s;
}
static void king_war_cycle(void) {
    if (CR.retired) return;
    int me = cs_nation();
    PowerRecord *p = &CS.powers[me];
    /* king-war expiry: 16 turns after the stamp (@0x57FFF) */
    for (int n = 0; n < 4; n++) {
        if (CR.king_war_stamp[n] < 0) continue;
        if ((int)cs_turn() >= CR.king_war_stamp[n] + 16) {
            CR.war_matrix[me][n] &= (uint8_t)~REL_WAR;  /* JS setWar: one way */
            CR.king_war_stamp[n] = -1;
        }
    }
    if (CR.woi_flags & WOI_DECLARED) return;
    /* ---- @KINGFRIGATE (func_02F052 tail) ---- */
    if ((cs_turn() & 7) == 0) {
        int any = 0, frig = 0;
        blockade_census(&any, &frig);
        if (frig != 0 || any > 3) {
            ev_emit("KINGFRIGATE", 0, 0, dat_nations[me].adjective, 0);
            if (ask_choice() == 0) {
                if (CR.n_europe <
                    (int)(sizeof(CR.europe) / sizeof(CR.europe[0]))) {
                    euro_crossing *e = &CR.europe[CR.n_europe++];
                    memset(e, 0, sizeof(*e));
                    for (int ti = 0; ti < DAT_UNITS_COUNT; ti++)
                        if (strcmp(dat_units[ti].name, "Frigate") == 0)
                            e->type = (uint8_t)ti;
                    e->state = 0;                 /* port */
                    e->lane_x = e->lane_y = -1;   /* no lane */
                }
                /* func_034318(+10): tax += 10, capped at 75, @KINGTAX */
                int raise = 75 - p->tax_rate;
                if (raise > 10) raise = 10;
                if (raise > 0) {
                    p->tax_rate = (uint8_t)(p->tax_rate + raise);
                    ev_emit("KINGTAX", raise, p->tax_rate, 0, 0);
                }
            }
        }
    }
    /* ---- @KINGNEWWAR (func_035E80) ---- */
    if ((cs_difficulty() + 2) * (int)cs_turn() < 800) return;
    int partners[3], T = 0;
    for (int n = 0; n < 4; n++)
        if (n != me && CR.rivals[n].met && have_treaty(me, n))
            partners[T++] = n;
    if (!T) return;
    /* P (royal peace-pending pairs) is unmodeled -> 0 */
    if (R((4 - T) * 20 + 1) > cs_difficulty()) return;
    int foe = partners[R(T)];
    int soldiers = 1, grant = (cs_difficulty() + 1) * 100;
    int theirs = power_strength_rival(foe);
    int ours = power_strength_units();
    if (theirs > ours) {
        int d = theirs - ours;
        soldiers = (d >> 3) + 1;
        grant += 25 * d;
    }
    if (soldiers > 6 - cs_difficulty()) soldiers = 6 - cs_difficulty();
    if (grant > (5 - cs_difficulty()) * 500)
        grant = (5 - cs_difficulty()) * 500;
    p->gold += grant;
    /* the King's veterans arrive ON THE EUROPE DOCK (@0x360DC) */
    int vet = -1;
    for (int i = 0; i < DAT_JOBEXPERT_COUNT; i++)
        if (strcmp(dat_jobexpert[i], "Veteran Soldiers") == 0 && vet < 0)
            vet = i;
    for (int k = 0; k < soldiers && vet >= 0; k++)
        if (CR.n_dock_units <
            (int)(sizeof(CR.dock_units) / sizeof(CR.dock_units[0]))) {
            immigrant *m = &CR.dock_units[CR.n_dock_units++];
            memset(m, 0, sizeof(*m));
            m->kind = 4;                 /* a profession-name entry */
            m->idx = (uint8_t)vet;
        }
    CR.treaty_matrix[me][foe] &= (uint8_t)~REL_TREATY;  /* both ways (JS) */
    CR.treaty_matrix[foe][me] &= (uint8_t)~REL_TREATY;
    CR.war_matrix[me][foe] |= REL_WAR;
    CR.king_war_stamp[foe] = (int16_t)cs_turn();
    ev_emit("KINGNEWWAR", grant, soldiers, dat_nations[foe].adjective, 0);
}

/* petitionLowerTaxes (game.js:8898): the Europe screen's 'k' key.  A
 * rock-bottom rate backfires (@KINGRAISE); a rate above the era cap MAY
 * drop (@KINGLOWER — the roll is behind the cap test, JS && order);
 * else @KINGNOTHING. */
void king_petition(void) {
    PowerRecord *p = &CS.powers[cs_nation()];
    int d = cs_difficulty();
    if (p->tax_rate <= 1) {
        int delta = 2 * (1 + R(d > 1 ? d : 1));
        p->tax_rate = (uint8_t)(p->tax_rate + delta);
        ev_emit("KINGRAISE", delta, p->tax_rate, 0, 0);
        return;
    }
    int cap = ((d & ~1) * 2 + 4) * ((int)cs_turn() / 400 + 1);
    if (p->tax_rate > cap + 5 && 1 + R(d + 1) == 1) {
        int delta = 1 + R(5 - d > 1 ? 5 - d : 1);
        if (delta > p->tax_rate) delta = p->tax_rate;
        p->tax_rate = (uint8_t)(p->tax_rate - delta);
        ev_emit("KINGLOWER", delta, p->tax_rate, 0, 0);
        return;
    }
    ev_emit("KINGNOTHING", 0, 0, 0, 0);
}

/* The Crown's tax/war cycle — BYTE_VERIFIED end to end 2026-08-29
 * (king_tax_demand_and_pretext, func_036138 @0x36138..@0x363A0),
 * replacing the func_034AE0-based candidate gate (that math belongs to
 * the PETITION path above) and the invented pretext-only bands:
 *
 *   gate     >= 1 colony (@0x36146), turn >= 30 (@0x36150),
 *            tax <= 85 (0x55, @0x361C3)
 *   cadence  base 18, 15 past 1600, 12 past 1700, 9 past 1750
 *            (@0x3615A..@0x36174), MINUS 2 x (difficulty - 2) for the
 *            human (@0x361AE shl dx,1); fires on turn %% interval == 0
 *   severity roll = random_int(1,1000)
 *            + 5 x (2 x rebel_meter - tax) (@0x361F9..@0x36208)
 *            + gold/100 (@0x361DC) + population census [-0x6BF0]
 *            (@0x3620A) + turn/30 (@0x36216)
 *   bands    < 100          @KINGVICTORY: tax CUT min(random_int(2,5),
 *                           tax) — zero = no event (@0x36276) — naming
 *                           the REMEMBERED war country ([0x53A8] - 1
 *                           into @COUNTRIES, @0x3628F)
 *            < 650, and     @KINGWIFE: +1; the wedding counter [0x53A7]
 *            weddings < 30  increments and picks the @ORDINAL word
 *                           (@0x362BB..@0x362E8 — the 30-entry ordinal
 *                           list IS the cap); at 30 weddings the band
 *                           falls through to the war test
 *            < 950          @KINGWAR: +2; country = random_int(1,8)
 *                           rerolled while equal to the last
 *                           (@0x3630B..@0x3631F), remembered in [0x53A8]
 *            < 1100         @KINGNAVACT: +random_int(3,4) (@0x36339)
 *            else           @KINGSTAMPACT: +random_int(5,8) (@0x3634E)
 *
 * The raise lands in PowerRecord +0x10 and the ask (@TAXOPTIONS / tea
 * party) follows; the VICTORY cut applies directly (the port's reading
 * of the negative amount @0x3627D — no tea party against good news,
 * FLAGGED).  [0x53A7]/[0x53A8] live in the persisted globals block —
 * the importers do not read that block yet, FLAGGED. */
static const char *KING_COUNTRIES[8] = {
    "the Holy Roman Empire", "the Portuguese", "the Ottoman Turks",
    "the Barbary Pirates", "Russia", "Prussia", "Sweden", "Denmark" };
static const char *KING_ORDINAL[30] = {
    "first", "second", "third", "fourth", "fifth", "sixth", "seventh",
    "eighth", "ninth", "tenth", "eleventh", "twelfth", "thirteenth",
    "fourteenth", "fifteenth", "sixteenth", "seventeenth", "eighteenth",
    "nineteenth", "twentieth", "twenty first", "twenty second",
    "twenty third", "twenty fourth", "twenty fifth", "twenty sixth",
    "twenty seventh", "twenty eighth", "twenty ninth", "thirtieth" };
static void king_tax_demand(void) {
    if (CR.woi_flags & WOI_DECLARED) return;   /* no King to obey (8648) */
    int me = cs_nation();
    PowerRecord *p = &CS.powers[me];
    int ncol = 0, pop = 0;
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == me) {
            ncol++;
            pop += CS.colonies[ci].population;
        }
    if (!ncol || cs_turn() < 30 || p->tax_rate > 85) return;
    int base = cs_year() >= 1750 ? 9 : cs_year() >= 1700 ? 12
             : cs_year() >= 1600 ? 15 : 18;
    int interval = base - 2 * (cs_difficulty() - 2);
    if (interval < 2) interval = 2;
    if (cs_turn() % interval != 0) return;
    /* the [-0x6BF0] census: colony sizes + valid units (0x181F:0xB78
     * validity unread — every player unit counts here, FLAGGED) */
    pop += CR.n_units_order;
    int sev = 1 + R(1000) + (2 * national_sol() - p->tax_rate) * 5 +
              (int)(p->gold / 100) + pop + (int)cs_turn() / 30;
    int raise;
    const char *key, *s2 = 0;
    if (sev < 100) {
        int cut = 2 + R(4);
        if (cut > p->tax_rate) cut = p->tax_rate;
        if (cut <= 0) return;
        p->tax_rate = (uint8_t)(p->tax_rate - cut);
        int wc = CR.king_war_country >= 1 && CR.king_war_country <= 8
                     ? CR.king_war_country : 1;
        ev_emit("KINGVICTORY", cut, p->tax_rate, KING_COUNTRIES[wc - 1], 0);
        return;
    } else if (sev < 0x28A && CR.king_weddings < 30) {
        raise = 1;
        CR.king_weddings++;
        key = "KINGWIFE";
        s2 = KING_ORDINAL[CR.king_weddings - 1];
    } else if (sev < 0x3B6) {
        raise = 2;
        int pick;
        do pick = 1 + R(8); while (pick == CR.king_war_country);
        CR.king_war_country = (uint8_t)pick;
        key = "KINGWAR";
        s2 = KING_COUNTRIES[pick - 1];
    } else if (sev < 0x44C) {
        raise = 3 + R(2);
        key = "KINGNAVACT";
    } else {
        raise = 5 + R(4);
        key = "KINGSTAMPACT";
        s2 = dat_nations[me].country;
    }
    /* the Party good: the good your colonies hold most of (game.js:8658,
     * strict-greater scan from 0 — lowest index on ties) */
    int good = 0;
    {
        long tot[16] = { 0 };
        for (int ci = 0; ci < CS.n_colonies; ci++) {
            if ((CS.colonies[ci].owner_power & 3) != me) continue;
            for (int g = 0; g < 16; g++) tot[g] += CS.colonies[ci].stock[g];
        }
        for (int g = 1; g < 16; g++)
            if (tot[g] > tot[good]) good = g;
    }
    ev_emit(key, raise, p->tax_rate + raise, s2 ? s2 : dat_cargo[good].name, 0);
    /* @TAXOPTIONS (game.js:8667): row 0 kisses the ring, row 1 holds the
     * Party — teaParty (8676): the good is dumped at the first colony
     * holding it, the tax is NOT raised, and the good is boycotted
     * (RUNTIME G.boycotts) */
    if (ask_choice() == 1) {
        int ci = -1;
        for (int k = 0; k < CS.n_colonies && ci < 0; k++)
            if ((CS.colonies[k].owner_power & 3) == me &&
                CS.colonies[k].stock[good] > 0) ci = k;
        if (ci < 0)
            for (int k = 0; k < CS.n_colonies && ci < 0; k++)
                if ((CS.colonies[k].owner_power & 3) == me) ci = k;
        int32_t tons = ci >= 0 ? CS.colonies[ci].stock[good] : 0;
        if (ci >= 0) CS.colonies[ci].stock[good] = 0;
        CR.boycotts |= (uint16_t)(1 << good);
        ev_emit("TEAPARTY", tons, 0, dat_cargo[good].name,
                ci >= 0 ? CS.colonies[ci].name : 0);
    } else {
        int t = p->tax_rate + raise;
        p->tax_rate = (uint8_t)(t > 75 ? 75 : t);
    }
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
    if (CR.succession) return;
    /* never once independence is declared (game.js:7000) — the gate sits
     * BEFORE the R(600) draw, so it also keeps the streams aligned */
    if (CR.woi_flags & WOI_DECLARED) return;
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
    /* the ColonyRecords change hands too (JS c.nation = winner) — the
     * per-power colony pass keys off the record owner (B3.6) */
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 0x0F) == (ceding & 0x0F))
            CS.colonies[ci].owner_power = (uint8_t)
                ((CS.colonies[ci].owner_power & 0xF0) | (winner & 0x0F));
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
/* scoreParts (game.js:8100 family) — moved from the F10 report painter
 * so the endgame can write the Hall of Fame record (hofWrite). */
void score_parts(score_parts_t *s) {
    /* SCORE_PLAIN = Indentured Servants / Petty Criminals / Indian
     * Converts (@JOBEXPERT rows 25/26/27); Free Colonists = row 19 */
    int population = 0;
    for (int ci = 0; ci < CS.n_colonies; ci++) {
        const ColonyRecord *c = &CS.colonies[ci];
        if ((c->owner_power & 3) != cs_nation()) continue;
        for (int k = 0; k < c->population && k < 32; k++) {
            int prof = c->profession[k];
            /* SAV_PROFESSION: a byte outside 1..27 is null -> the +2
             * plain-colonist score (game.js:10207/10096) */
            if (prof >= 25 && prof <= 27) population += 1;
            else if (prof == 0 || prof >= 28 || prof == 19) population += 2;
            else population += 4;
        }
    }
    int owned = 0;
    for (int i = 0; i < DAT_FATHERS_COUNT; i++)
        if (father_owned(i)) owned++;
    s->population = population;
    s->fathers = owned * 5;
    s->sentiment = national_sol();
    s->razed = -(int)CR.razed * (1 + cs_difficulty());
    int g = CS.powers[cs_nation()].gold / 100;
    s->gold = g < 100 ? g : 100;
    s->liberty = (int)(CR.bells_total / 1000);
    s->revolution = ((CR.woi_flags & WOI_WON) && CR.declared_year)
                        ? (1780 - CR.declared_year) * 2 : 0;
    s->base = s->population + s->fathers + s->sentiment + s->razed +
              s->gold + s->liberty + s->revolution;
    s->mult = cs_difficulty() + 4 + (cs_difficulty() >= 3 ? 1 : 0) +
              (cs_difficulty() >= 4 ? 1 : 0);
    /* Math.floor(mult*base/100) >> 1 — floor semantics for negatives */
    int mb = s->mult * s->base;
    int fl = mb >= 0 ? mb / 100 : -((-mb + 99) / 100);
    s->total = fl >> 1;
}

/* hofWrite (game.js:12333): descending insertion on the RATING word
 * (func_03ADA6 @0x3AECD), list capped at 6. */
static void hof_write(void) {
    score_parts_t s;
    score_parts(&s);
    colopy_hof_rec r;
    memset(&r, 0, sizeof(r));
    snprintf(r.name, sizeof(r.name), "%s",
             CR.leader[0] ? CR.leader : dat_nations[cs_nation()].leader);
    r.nation = cs_nation();
    r.difficulty = cs_difficulty();
    r.year = cs_year();
    r.score = s.base;
    r.rating = s.total;
    r.declared = (CR.woi_flags & WOI_DECLARED) ? 1 : 0;
    r.independent = (CR.woi_flags & WOI_WON) ? 1 : 0;
    int k = 0;
    while (k < CR.n_hof && CR.hof[k].rating >= r.rating) k++;
    for (int j = (CR.n_hof < 6 ? CR.n_hof : 5); j > k; j--)
        CR.hof[j] = CR.hof[j - 1];
    if (k < 6) {
        CR.hof[k] = r;
        if (CR.n_hof < 6) CR.n_hof++;
        CR.hof_dirty = 1;            /* the shell persists the list */
    }
}

void end_game_sequence(void) {
    CR.retired = 1;
    hof_write();                     /* endGameSequence (game.js:8122) */
    ev_emit("EXPLOITS", 0, 0, 0, 0);
    (void)R(DAT_SCORENAMES_COUNT);       /* the joke-name notice pick */
    CR.screen_map = 0;                   /* G.screen = 'report' */
    ev_emit("SCORED", 0, 0, 0, 0);
    ask_choice();                        /* game.js:8141: sets G.scored;
                                          * the retired latch already
                                          * gates re-entry here */
    CR.scored = 1;
}

/* The retirement clock (endTurn:10800). */
static void retirement_check(void) {
    if (CR.retired) return;
    if (!(CR.woi_flags & WOI_DECLARED)) {
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
    } else if (!(CR.woi_flags & WOI_WON)) {
        /* the war-weary clock (endTurn:10815): G.soonWarned2 shares the
         * CR field with the pre-war warning — both fire once and the
         * branches are exclusive by WOI_DECLARED, so one latch serves
         * only if the declaration cannot happen after 1790; it can, so
         * the second warning gets its own bit (the high bit). */
        if (cs_year() >= 1840 && !(CR.soon_warned & 0x80)) {
            CR.soon_warned |= 0x80;
            ev_emit("SOONRETIRING1", 0, 0, 0, 0);
        }
        if (cs_year() >= 1850) {
            ev_emit("RETIRING2", 0, 0, 0, 0);
            end_game_sequence();
        }
    }
}

/* advanceGoTo (game.js:2274): one step a turn toward the goal, trying
 * the diagonal then each axis; a blocked turn cancels the order.  The
 * element test bars a land unit from water unless a (player) colony
 * sits there, and a ship from land outright; natives block. */

/* ---- trade routes (game.js:7713-7815) -------------------------------
 * Session-runtime automation: a route is a stop list (player-colony
 * ordinals + the 999 Europe id); a ship/wagon with orders 2 and a
 * route steps toward its current stop each turn, loading at the FIRST
 * stop and unloading at every other (the port's documented default).
 * Under the parity harness no route can exist (@TRADENAME's openDialog
 * is inert there), so the step never draws RNG and the turn chain is
 * untouched. */
static int pcol_rec(int ord) {
    int o = -1;
    for (int i = 0; i < CS.n_colonies; i++)
        if ((CS.colonies[i].owner_power & 3) == cs_nation() && ++o == ord)
            return i;
    return -1;
}

void route_stop_name(int16_t stop, char *out, int cap) {
    if (stop == COLOPY_STOP_EUROPE) {
        snprintf(out, (size_t)cap, "%s", dat_nations[cs_nation()].homeport);
        return;
    }
    int ci = pcol_rec(stop);
    if (ci >= 0)
        snprintf(out, (size_t)cap, "%.24s", CS.colonies[ci].name);
    else
        snprintf(out, (size_t)cap, "?");
}

/* routeName (7723): @TRADENAMES noun — Run/Ferry/Cargo by route count,
 * Triangle from three stops up */
void route_auto_name(const int16_t *stops, int n, char *out, int cap) {
    const char *noun = n >= 3 ? dat_tradenames[4]
                              : dat_tradenames[CR.n_routes % 3];
    char sn[26];
    route_stop_name(n ? stops[0] : 0, sn, (int)sizeof(sn));
    snprintf(out, (size_t)cap, "%s %s", sn, noun);
}

int route_create(const int16_t *stops, int n, int sea, const char *name) {
    if (CR.n_routes >= COLOPY_MAX_ROUTES) {
        ev_emit("TRADEMANY", COLOPY_MAX_ROUTES, 0, 0, 0);
        return -1;
    }
    struct colopy_route *r = &CR.routes[CR.n_routes];
    if (name && name[0])
        snprintf(r->name, sizeof(r->name), "%s", name);
    else
        route_auto_name(stops, n, r->name, (int)sizeof(r->name));
    r->sea = (int8_t)(sea ? 1 : 0);
    r->n_stops = (int8_t)(n > COLOPY_MAX_STOPS ? COLOPY_MAX_STOPS : n);
    for (int i = 0; i < r->n_stops; i++) r->stops[i] = stops[i];
    memset(r->n_load, 0, sizeof(r->n_load));       /* lanes start empty */
    memset(r->n_unload, 0, sizeof(r->n_unload));
    return CR.n_routes++;
}

/* runTradeRoute (7739) */
static void run_trade_route(int ui) {
    UnitRecord *u = &CS.units[ui];
    if (CR.unit_route[ui] < 0 || CR.unit_route[ui] >= CR.n_routes) {
        u->orders = 0;
        return;
    }
    struct colopy_route *r = &CR.routes[CR.unit_route[ui]];
    if (r->n_stops < 2) {                    /* @ROUTELOOP */
        ev_emit("ROUTELOOP", 0, 0, r->name, 0);
        CR.unit_route[ui] = -1;
        u->orders = 0;
        return;
    }
    int ship = u->type < DAT_UNITS_COUNT && dat_units[u->type].hull > 0;
    /* @KILLWAGONS/@LOOTWAGONS: a wagon within 2 of a war-band village
     * (1/40; loss vs loot at evens).  The JS %STRING3 nearest-colony
     * substitution has no slot on the two-string event bus — FLAGGED
     * blank on the board. */
    if (strcmp(dat_units[u->type].name, "Wagon Train") == 0) {
        int hv = -1;
        for (int v = 0; v < CS.n_villages && hv < 0; v++) {
            int dx = CS.villages[v].map_x - u->map_x;
            int dy = CS.villages[v].map_y - u->map_y;
            if (dx < 0) dx = -dx;
            if (dy < 0) dy = -dy;
            if (CR.alarm[v] >= 0x80 && dx <= 2 && dy <= 2) hv = v;
        }
        if (hv >= 0 && (int)((rng_next() * 40u) >> 15) == 0) {
            int ti = CS.villages[hv].owner_tribe - 4;
            const char *tn = ti >= 0 && ti < 8 ? dat_tribes[ti].name : "";
            if (rng_next() < 16384) {        /* random < 0.5 */
                ev_emit("KILLWAGONS", 0, 0, tn, 0);
                unit_remove(ui);             /* the JS G.sel clamp is the
                                              * front layer's advance */
                return;
            }
            ev_emit("LOOTWAGONS", 0, 0, tn, 0);
            CR.unit_n_hold[ui] = 0;          /* u.hold = [] */
        }
    }
    int stop = r->stops[CR.unit_stop_index[ui] % r->n_stops];
    if (stop == COLOPY_STOP_EUROPE) {
        if (!ship) { u->orders = 0; return; }
        cmd_sail_for_europe(ui);
        return;
    }
    int ci = pcol_rec(stop);
    if (ci < 0) { u->orders = 0; return; }
    ColonyRecord *c = &CS.colonies[ci];
    if (u->map_x == c->map_x && u->map_y == c->map_y) {
        /* per-stop cargo lanes (B3.4) — the automation loop @0x411D8:
         * UNLOAD func_00B8D0 adds the unit's tons to the colony store,
         * LOAD func_00B880 draws up to 100 (@0xB8A5).  Routes with no
         * lanes anywhere keep the port's documented default below. */
        int si = CR.unit_stop_index[ui] % r->n_stops;
        int has_lists = 0;
        for (int k = 0; k < r->n_stops; k++)
            if (r->n_load[k] || r->n_unload[k]) has_lists = 1;
        if (has_lists) {
            int cap = dat_units[u->type].cargo;
            for (int k = 0; k < r->n_unload[si]; k++) {
                int g = r->unload[si][k];
                for (int h = CR.unit_n_hold[ui] - 1; h >= 0; h--) {
                    hold_slot hs = CR.unit_hold[ui][h];
                    if (hs.good != g) continue;
                    c->stock[g] = (uint16_t)(c->stock[g] + hs.qty);
                    hold_add(CR.unit_hold[ui], &CR.unit_n_hold[ui],
                             g, -hs.qty);
                }
            }
            for (int k = 0; k < r->n_load[si]; k++) {
                if (CR.unit_n_hold[ui] >= cap) break;
                int g = r->load[si][k];
                int take = c->stock[g] < 100 ? c->stock[g] : 100;
                if (take <= 0) continue;
                c->stock[g] = (uint16_t)(c->stock[g] - take);
                hold_add(CR.unit_hold[ui], &CR.unit_n_hold[ui], g, take);
            }
            CR.unit_stop_index[ui] =
                (uint8_t)((CR.unit_stop_index[ui] + 1) % r->n_stops);
            return;
        }
        /* first stop loads, every other unloads (the flagged default) */
        if (si == 0) {
            int cap = dat_units[u->type].cargo;
            for (int i = 0; i < 16 && CR.unit_n_hold[ui] < cap; i++) {
                if (i == FOOD || c->stock[i] < 50) continue;
                int take = c->stock[i] < 100 ? c->stock[i] : 100;
                c->stock[i] = (uint16_t)(c->stock[i] - take);
                hold_add(CR.unit_hold[ui], &CR.unit_n_hold[ui], i, take);
            }
        } else {
            for (int h = CR.unit_n_hold[ui] - 1; h >= 0; h--) {
                hold_slot hs = CR.unit_hold[ui][h];
                c->stock[hs.good] = (uint16_t)(c->stock[hs.good] + hs.qty);
                hold_add(CR.unit_hold[ui], &CR.unit_n_hold[ui],
                         hs.good, -hs.qty);
            }
        }
        CR.unit_stop_index[ui] =
            (uint8_t)((CR.unit_stop_index[ui] + 1) % r->n_stops);
        return;
    }
    /* one step toward the stop, element-respecting (7809) */
    int dx = c->map_x > u->map_x ? 1 : c->map_x < u->map_x ? -1 : 0;
    int dy = c->map_y > u->map_y ? 1 : c->map_y < u->map_y ? -1 : 0;
    int tries[3][2] = { { dx, dy }, { dx, 0 }, { 0, dy } };
    for (int t = 0; t < 3; t++) {
        int mx = tries[t][0], my = tries[t][1];
        if (!mx && !my) continue;
        int nx = u->map_x + mx, ny = u->map_y + my;
        if (nx < 0 || ny < 0 || nx >= COLOPY_MAP_W || ny >= COLOPY_MAP_H)
            continue;
        int water = tile_water(map_at(nx, ny));
        int own_col = 0;
        for (int k = 0; k < CS.n_colonies; k++)
            if ((CS.colonies[k].owner_power & 3) == cs_nation() &&
                CS.colonies[k].map_x == nx && CS.colonies[k].map_y == ny)
                own_col = 1;
        if ((ship != water) && !(own_col && !ship)) continue;
        u->map_x = (uint8_t)nx;
        u->map_y = (uint8_t)ny;
        colopy_reveal(nx, ny, unit_sight_radius(ui));
        return;
    }
}

/* advanceTradeRoutes (7813) */
void advance_trade_routes(void) {
    for (int k = 0; k < CR.n_units_order; k++) {
        int ui = CR.units_order[k];
        if (CS.units[ui].orders == 2 && CR.unit_route[ui] >= 0)
            run_trade_route(ui);
    }
}

/* gotoPathStep (game.js) — func_062D84 (0x1a1f:0x210, the goto direction
 * chooser) + its 16x16 goal-centred pathfinder func_061F02 (0x1a1f:0x5f0),
 * BYTE MODEL read 2026-08-29; mirrors the JS draw-for-draw (no RNG).
 * Adjacent goal steps straight (@0x62E55); within the window a Dijkstra
 * from the GOAL over a 16x16 byte cost plane (queue cap 225, tile cap 99)
 * with step costs road/river-improve both = 1 (@0x622A1), terrain river
 * bit 0x40 both = 1 (@0x622C6), one-move unit = 3, else 3 x the terrain
 * Movement column (@0x622FA); foreign units/settlements block, +8 beside
 * a foreign settlement; step picked by lowest plane+step cost, ties by
 * straight distance (@0x62374..). Beyond 7 the engine paths to a
 * 4x4-sector waypoint (func_061E10, unread) — the goal is clamped to 7
 * along the line instead, a flagged proxy. The planes are STATIC like the
 * engine's DGROUP buffers (0xA270/0xA372) — this chain runs deep in the
 * end-turn stack (see the 2026-08-17 overflow note above). */
static uint8_t gp_cost[256];
static uint8_t gp_qx[256], gp_qy[256];
static int gp_enterable(int ui, int x, int y) {
    UnitRecord *u = &CS.units[ui];
    if (x < 0 || y < 0 || x >= COLOPY_MAP_W || y >= COLOPY_MAP_H) return 0;
    if (x == u->map_x && y == u->map_y) return 1;
    int t = tile_terrain(map_at(x, y));
    int water = t == TERR_OCEAN || t == TERR_SEALANE;
    int is_ship = u->type < DAT_UNITS_COUNT && dat_units[u->type].hull > 0;
    int col_own = -1;
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if (CS.colonies[ci].map_x == x && CS.colonies[ci].map_y == y) {
            col_own = CS.colonies[ci].owner_power & 3;
            break;
        }
    if (col_own >= 0) {
        if (col_own != (int)cs_nation()) return 0;   /* foreign colony */
    } else if (water != is_ship) return 0;
    for (int q = 0; q < CR.n_natives; q++) {
        int n = CR.natives_order[q];
        if (unit_pos_x(n) == x && unit_pos_y(n) == y) return 0;
    }
    for (int v = 0; v < CS.n_villages; v++)
        if (CS.villages[v].map_x == x && CS.villages[v].map_y == y) return 0;
    for (int rn = 0; rn < 4; rn++) {
        if (rn == (int)cs_nation()) continue;
        for (int q = 0; q < CR.n_runits[rn]; q++) {
            int n = CR.runits_order[rn][q];
            if (CS.units[n].map_x == x && CS.units[n].map_y == y) return 0;
        }
        for (int c = 0; c < CR.rivals[rn].n_col; c++)
            if (CR.rivals[rn].col[c].x == x && CR.rivals[rn].col[c].y == y)
                return 0;
    }
    return 1;
}
static int gp_step_cost(int ui, int fx, int fy, int tx, int ty) {
    if ((map_improve(fx, fy) & 0x0A) && (map_improve(tx, ty) & 0x0A))
        return 1;
    if ((map_at(fx, fy) & 0x40) && (map_at(tx, ty) & 0x40)) return 1;
    if (dat_units[CS.units[ui].type].movement == 1) return 3;
    return 3 * terrain_move(map_at(tx, ty));
}
static int gp_near_settle(int x, int y) {
    for (int v = 0; v < CS.n_villages; v++) {
        int dx = CS.villages[v].map_x - x, dy = CS.villages[v].map_y - y;
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        if (dx <= 1 && dy <= 1) return 1;
    }
    for (int rn = 0; rn < 4; rn++) {
        if (rn == (int)cs_nation()) continue;
        for (int c = 0; c < CR.rivals[rn].n_col; c++) {
            int dx = CR.rivals[rn].col[c].x - x;
            int dy = CR.rivals[rn].col[c].y - y;
            if (dx < 0) dx = -dx;
            if (dy < 0) dy = -dy;
            if (dx <= 1 && dy <= 1) return 1;
        }
    }
    return 0;
}
static const int8_t GP_DX[8] = { 1, -1, 0, 0, 1, 1, -1, -1 };
static const int8_t GP_DY[8] = { 0, 0, 1, -1, 1, -1, 1, -1 };
/* returns 1 with nx_out/ny_out set, else 0 */
static int goto_path_step(int ui, int gx, int gy, int *nx_out, int *ny_out) {
    UnitRecord *u = &CS.units[ui];
    int adx = gx - u->map_x, ady = gy - u->map_y;
    if (adx < 0) adx = -adx;
    if (ady < 0) ady = -ady;
    if (adx <= 1 && ady <= 1) {
        if (!gp_enterable(ui, gx, gy)) return 0;
        *nx_out = gx;
        *ny_out = gy;
        return 1;
    }
    int wx = gx, wy = gy;
    if (adx >= 7 || ady >= 7) {
        int cx = gx - u->map_x, cy = gy - u->map_y;
        if (cx > 7) cx = 7;
        if (cx < -7) cx = -7;
        if (cy > 7) cy = 7;
        if (cy < -7) cy = -7;
        wx = u->map_x + cx;
        wy = u->map_y + cy;
    }
    int ox = wx - 8, oy = wy - 8;
    memset(gp_cost, 0, sizeof(gp_cost));
    int qn = 0;
    gp_qx[qn] = (uint8_t)(wx - ox);
    gp_qy[qn] = (uint8_t)(wy - oy);
    qn = 1;
    gp_cost[(wx - ox) * 16 + (wy - oy)] = 1;
    int bound = 999;
    for (int head = 0; head < qn && head < 225; head++) {
        int cx = gp_qx[head] + ox, cy = gp_qy[head] + oy;
        int c0 = gp_cost[(cx - ox) * 16 + (cy - oy)];
        if (c0 > bound) continue;
        if (cx == u->map_x && cy == u->map_y) { bound = c0; continue; }
        for (int d = 0; d < 8; d++) {
            int nx = cx + GP_DX[d], ny = cy + GP_DY[d];
            int ddx = nx - wx, ddy = ny - wy;
            if (ddx < 0) ddx = -ddx;
            if (ddy < 0) ddy = -ddy;
            if (ddx >= 8 || ddy >= 8) continue;
            if (!gp_enterable(ui, nx, ny) && !(nx == wx && ny == wy))
                continue;
            int nc = c0 + gp_step_cost(ui, cx, cy, nx, ny);
            if (gp_near_settle(nx, ny)) nc += 8;
            int k = (nx - ox) * 16 + (ny - oy);
            if (gp_cost[k] != 0 && gp_cost[k] <= nc) continue;
            gp_cost[k] = (uint8_t)(nc > 255 ? 255 : nc);
            if (qn < 256) {
                gp_qx[qn] = (uint8_t)(nx - ox);
                gp_qy[qn] = (uint8_t)(ny - oy);
                qn++;
            }
        }
    }
    int best = -1, best_total = 99, best_dist = 9999;
    for (int d = 0; d < 8; d++) {
        int nx = u->map_x + GP_DX[d], ny = u->map_y + GP_DY[d];
        int ddx = nx - wx, ddy = ny - wy;
        if (ddx < 0) ddx = -ddx;
        if (ddy < 0) ddy = -ddy;
        if (ddx >= 8 || ddy >= 8) continue;
        if (!gp_enterable(ui, nx, ny)) continue;
        int k = (nx - ox) * 16 + (ny - oy);
        if (gp_cost[k] == 0) continue;
        int total = gp_cost[k] + gp_step_cost(ui, u->map_x, u->map_y, nx, ny);
        int gdx = nx - gx, gdy = ny - gy;
        if (gdx < 0) gdx = -gdx;
        if (gdy < 0) gdy = -gdy;
        int dist = gdx > gdy ? gdx : gdy;
        if (total < best_total || (total == best_total && dist < best_dist)) {
            best_total = total;
            best_dist = dist;
            best = d;
        }
    }
    if (best < 0) return 0;
    *nx_out = u->map_x + GP_DX[best];
    *ny_out = u->map_y + GP_DY[best];
    return 1;
}

static void advance_goto(void) {
    /* Ships that reached their sea lane this turn are MARKED, not sailed
     * in place: cmd_sail_for_europe calls unit_remove, which compacts the
     * very arrays this loop is walking.
     *
     * The mark rides in CR.unit_sail_home itself (2 = "arrived, pending
     * departure") rather than a local array.  An `int arrived[256]` here
     * put 1,216 bytes on the stack of a function deep in the end-turn
     * chain, and founding a colony — which removes the founder and so
     * runs that whole chain from inside the key dispatcher's own 3 KB
     * frame — overflowed the board's task stack and crashed it (user
     * report 2026-08-17).  CR is static, already compacted by
     * unit_remove, and the mark never outlives this call. */
    for (int k = 0; k < CR.n_units_order; k++) {
        int ui = CR.units_order[k];
        UnitRecord *u = &CS.units[ui];
        if (u->orders != 3 || CR.goal_x[ui] < 0) continue;
        int gx = CR.goal_x[ui], gy = CR.goal_y[ui];
        if (u->map_x == gx && u->map_y == gy) {
            u->orders = 0;
            CR.goal_x[ui] = CR.goal_y[ui] = -1;
            if (CR.unit_sail_home[ui]) CR.unit_sail_home[ui] = 2;
            continue;
        }
        /* steps along the pathfinder's route (func_061F02), spending
         * the move allowance per step like the engine's order loop
         * (C1.3 closed 2026-08-29; first step always allowed) */
        int nx, ny, moved = 0;
        int is_ship2 = u->type < DAT_UNITS_COUNT &&
                       dat_units[u->type].hull > 0;
        for (int steps = 0;; steps++) {
            if (!goto_path_step(ui, gx, gy, &nx, &ny)) break;
            if (nx == u->map_x && ny == u->map_y) break;
            int cost = move_cost(is_ship2, u->map_x, u->map_y, nx, ny);
            if (steps > 0 && cost > u->moves_remaining) break;
            u->moves_remaining = (uint8_t)(cost > u->moves_remaining
                                               ? 0
                                               : u->moves_remaining - cost);
            u->map_x = (uint8_t)nx;
            u->map_y = (uint8_t)ny;
            colopy_reveal(nx, ny, unit_sight_radius(ui));
            moved = 1;
            if (u->map_x == gx && u->map_y == gy) break;
        }
        if (moved && u->map_x == gx && u->map_y == gy) {
            u->orders = 0;
            CR.goal_x[ui] = CR.goal_y[ui] = -1;
            if (CR.unit_sail_home[ui]) CR.unit_sail_home[ui] = 2;
        }
        if (!moved) {
            u->orders = 0;
            CR.goal_x[ui] = CR.goal_y[ui] = -1;
            CR.unit_sail_home[ui] = 0;
        }
    }
    /* Arrival on the lane IS the departure — no @SAILHOME ask, the player
     * already gave the order that sent the ship here.  Re-scanning from
     * the front after each removal keeps this in G.units order (the JS
     * departs its `arrived` list in collection order) without holding
     * indices across the compaction unit_remove performs. */
    for (;;) {
        int ui = -1;
        for (int k = 0; k < CR.n_units_order; k++)
            if (CR.unit_sail_home[CR.units_order[k]] == 2) {
                ui = CR.units_order[k];
                break;
            }
        if (ui < 0) break;
        CR.unit_sail_home[ui] = 0;
        int is_ship = CS.units[ui].type < DAT_UNITS_COUNT &&
                      dat_units[CS.units[ui].type].hull > 0;
        if (is_ship &&
            tile_terrain(map_at(CS.units[ui].map_x, CS.units[ui].map_y)) ==
                TERR_SEALANE)
            cmd_sail_for_europe(ui);
    }
}

/* The full endTurn tail, in engine order (endTurn:10781-10821).  Steps
 * that are structural no-ops headless are named in place:
 *   advanceTradeRoutes — live under the harness too, but no route can
 *     exist there (@TRADENAME's openDialog is inert), so it never acts;
 *   runWar/toryUprising/offerMercenaries/checkIntervention — WoI-gated
 *     (G.flags stays 0: the declaration is an ask the stub never answers);
 */
void turn_step5(void) {
    rival_turn();          step_rng("rivalTurn");
    news_tick();           step_rng("newsTick");
    king_war_cycle();      step_rng("kingWarCycle");
    king_tax_demand();     step_rng("kingTaxDemand");
    advance_trade_routes(); step_rng("advanceTradeRoutes");
    advance_goto();        step_rng("advanceGoTo");
    run_war();             step_rng("runWar");
    tory_uprising();       step_rng("toryUprising");
    shore_bombardment();   step_rng("shoreBombardment");
    spanish_succession();  step_rng("spanishSuccession");
    ai_diplomacy_tick();   step_rng("aiDiplomacyTick");
    offer_mercenaries();   step_rng("offerMercenaries");
    check_intervention();  step_rng("checkIntervention");
    market_drift();        step_rng("driftMarket");
    advance_crossings();   step_rng("advanceCrossings");
    retirement_check();    step_rng("retirement");
}
