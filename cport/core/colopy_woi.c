/* The War of Independence — Phase 5 slice 5 (§18.3; spec/systems/
 * revolution.md + king.md + ref_growth.md).  Ports:
 *   nationalSoL (game.js:8856, the pop-weighted colony mean + Bolivar's
 *   byte-cited +20 @0x3BE64), declareIndependence (9007: the SoL-50 gate,
 *   the @DECLARE ask, @INDIANGRUDGE, the @SEIZURE of the Europe fleet,
 *   the first REF wave), mobilizeContinentals (9048, byte-verified
 *   promotion budget ((SoL-50)*(size/2))/50), refWave (9090, the
 *   population-weighted coastal landing), growREF (9917: the royal fund
 *   accrual (8d+10)*2^era vs the 1800 gate, byte-cited @0x3E181/@0x3E1C6,
 *   and the @KINGBUY/@KINGMOBILIZE split @0x3E2DB), runWar (9127: the
 *   sentiment bands, the capitulation ladder, the REF march, fresh waves,
 *   @KINGLOSE victory and @KINGWIN defeat), toryUprising (9306, the
 *   byte-exact nonzero-roll gate), offerMercenaries (9235, the
 *   byte-verified price shape), checkIntervention (9327, FLAGGED bell
 *   threshold).  seedREF (8869) runs at load like beginGame.
 *
 * The King's units are records with the 0x0F owner sentinel +
 * CR.unit_is_ref, listed in CR.refs_order (JS G.refUnits).  They are
 * mkUnit-born (real moves) and u.veteran = true. */
#include <string.h>

#include "colopy_sim.h"
#include "../data/colopy_data.h"

static int R(int n) { return (int)((rng_next() * (uint32_t)n) >> 15); }
static int urow(const char *name) {
    for (int i = 0; i < DAT_UNITS_COUNT; i++)
        if (strcmp(dat_units[i].name, name) == 0) return i;
    return -1;
}

void refs_push(int ui) {
    if (CR.n_refs < COLOPY_MAX_UNITS) CR.refs_order[CR.n_refs++] = (uint8_t)ui;
}

/* national_sol lives in colopy_rivals.c (the news ticker owns it). */

int woi_locked(void) {
    return (CR.woi_flags & WOI_DECLARED) && !(CR.woi_flags & WOI_WON);
}

/* coastalColonies (game.js:9086): a water tile on the 4-halo. */
static const int HALO[4][2] = { { 0, -1 }, { 1, 0 }, { 0, 1 }, { -1, 0 } };
static int coastal(int ci) {
    for (int d = 0; d < 4; d++)
        if (tile_water(map_at(CS.colonies[ci].map_x + HALO[d][0],
                              CS.colonies[ci].map_y + HALO[d][1]))) return 1;
    return 0;
}
static int n_player_colonies(void) {
    int n = 0;
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation()) n++;
    return n;
}

/* refWave (game.js:9090): the population-weighted coastal landing. */
#define REF_WAVE 6
static void ref_wave(void) {
    int pool[COLOPY_MAX_COLONIES], np = 0;
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation() && coastal(ci))
            pool[np++] = ci;
    if (!np || !n_player_colonies()) return;
    int wsum = 0;
    for (int i = 0; i < np; i++) {
        int w = CS.colonies[pool[i]].population;
        wsum += w > 0 ? w : 1;
    }
    int roll = 1 + R(wsum);
    int target = pool[0];
    for (int i = 0; i < np; i++) {
        int w = CS.colonies[pool[i]].population;
        roll -= w > 0 ? w : 1;
        if (roll <= 0) { target = pool[i]; break; }
    }
    const ColonyRecord *c = &CS.colonies[target];
    int bx = -1, by = -1;
    for (int d = 0; d < 4; d++)
        if (tile_water(map_at(c->map_x + HALO[d][0], c->map_y + HALO[d][1]))) {
            bx = c->map_x + HALO[d][0];
            by = c->map_y + HALO[d][1];
            break;
        }
    ev_emit("INVASION", 0, 0, c->name, 0);
    if (!CR.ambush_hinted) {
        CR.ambush_hinted = 1;
        ev_emit("AMBUSHHINT", 0, 0, 0, 0);
    }
    static const char *LANDERS[3] = { "Regulars", "Cavalry", "Artillery" };
    static const int POOL_IDX[3] = { 0, 1, 3 };
    int landed = 0;
    for (int ti = 0; ti < 3; ti++)
        for (int k = 0; k < REF_WAVE && CR.ref_pool[POOL_IDX[ti]] > 0 &&
                        landed < REF_WAVE; k++) {
            CR.ref_pool[POOL_IDX[ti]]--;
            int ui = unit_append(urow(LANDERS[ti]), 0x0F, c->map_x, c->map_y);
            if (ui >= 0) {
                CR.unit_is_ref[ui] = 1;
                CR.unit_veteran[ui] = 1;
                refs_push(ui);
            }
            landed++;
        }
    if (bx >= 0 && CR.ref_pool[2] > 0) {
        CR.ref_pool[2]--;
        int ui = unit_append(urow("Man-O-War"), 0x0F, bx, by);
        if (ui >= 0) {
            CR.unit_is_ref[ui] = 1;
            refs_push(ui);
        }
    }
    if (landed) ev_emit("WARN2", n_player_colonies(), 0, c->name, 0);
}

/* mobilizeContinentals (game.js:9048, byte-verified budget). */
static void mobilize_continentals(void) {
    int need = 50;                       /* the FLAGGED musket gate */
    int any = 0;
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation() &&
            CS.colonies[ci].stock[MUSKETS] >= need) any = 1;
    if (!any) { ev_emit("CANTMOBILIZE", need, 0, 0, 0); return; }
    int soldiers = urow("Soldiers"), dragoons = urow("Dragoons");
    int cont_a = urow("Cont. Army"), cont_c = urow("Cont. Cav.");
    int promoted = 0;
    for (int ci = 0; ci < CS.n_colonies; ci++) {
        ColonyRecord *c = &CS.colonies[ci];
        if ((c->owner_power & 3) != cs_nation()) continue;
        if (c->stock[MUSKETS] < need) continue;
        if (rt_sol(ci) < 50) continue;
        int budget = (rt_sol(ci) - 50) * (c->population / 2) / 50;
        if (budget < 1) budget = 1;
        int here = 0;
        for (int k = 0; k < CR.n_units_order && budget > 0; k++) {
            int ui = CR.units_order[k];
            UnitRecord *u = &CS.units[ui];
            if (u->map_x != c->map_x || u->map_y != c->map_y) continue;
            int to = u->type == soldiers ? cont_a
                   : u->type == dragoons ? cont_c : -1;
            if (to < 0) continue;
            u->type = (uint8_t)to;       /* promoted IN PLACE */
            int mv = dat_units[to].movement * 3;
            if (!CR.unit_moves_undef[ui] && u->moves_remaining > mv)
                u->moves_remaining = (uint8_t)mv;
            budget--;
            promoted++;
            here++;
        }
        if (here) ev_emit("MOBILIZE", 0, 0, c->name, 0);
    }
    if (promoted) ev_emit("MOBILIZE2", promoted, 0, 0, 0);
}

/* declareIndependence (game.js:9007). */
void declare_independence(void) {
    if (CR.woi_flags & WOI_DECLARED) {
        ev_emit("ALREADYREVOLUTION", 0, 0, 0, 0);
        return;
    }
    int meter = national_sol();
    if (meter < 50) { ev_emit("TOOTORY", meter, 0, 0, 0); return; }
    ev_emit("DECLARE", 0, 0, 0, 0);
    if (ask_choice() != 1) return;       /* row 0 is the loyal refusal */
    CR.woi_flags |= WOI_DECLARED;
    CR.declared_year = (uint16_t)cs_year();
    mobilize_continentals();
    for (int tr = 0; tr < 8; tr++)
        if (!CR.tribe_dead[tr] && CR.tension[tr] >= 75)
            ev_emit("INDIANGRUDGE", 0, 0, dat_tribes[tr].name, 0);
    ev_emit("INDEPENDENCE", 0, 0, 0, 0);
    /* the signing page func_03DA2A (DECOIND + the DEC-* signature): a
     * live-front plate; its engine dispatch site is unreachable
     * statically (TBD), so it follows @INDEPENDENCE like the JS */
    CR.decl_show = 1;
    /* @SEIZURE: the whole Europe fleet is taken at the declaration */
    for (int k = 0; k < CR.n_europe; k++)
        ev_emit("SEIZURE", 0, 0, dat_units[CR.europe[k].type].name, 0);
    CR.n_europe = 0;
    ref_wave();
}

/* growREF (game.js:8917): fund accrual + the ratio-gap purchase. */
#define REF_UNIT_COST 1800
static int ref_era(void) {
    return cs_year() >= 1750 ? 3 : cs_year() >= 1700 ? 2
         : cs_year() >= 1600 ? 1 : 0;
}
static void grow_ref(void) {
    CR.royal_fund += (8 * cs_difficulty() + 10) * (1 << ref_era());
    while (CR.royal_fund >= REF_UNIT_COST) {
        CR.royal_fund -= REF_UNIT_COST;
        int d = cs_difficulty();
        int seed[4] = { 8 * d + 15, 5 * d + 5, 3 * d + 2, 6 * d + 2 };
        long total = 0, seed_total = 0;
        for (int i = 0; i < 4; i++) {
            total += CR.ref_pool[i];
            seed_total += seed[i];
        }
        if (!total) total = 1;
        /* gap = ref/total - seed/seedTotal, minimised — compare the
         * cross products to stay in integers (both denominators > 0) */
        int pick = 0;
        long best_n = (long)CR.ref_pool[0] * seed_total -
                      (long)seed[0] * total;
        for (int i = 1; i < 4; i++) {
            long n = (long)CR.ref_pool[i] * seed_total - (long)seed[i] * total;
            if (n < best_n) { best_n = n; pick = i; }
        }
        CR.ref_pool[pick]++;
        static const char *NAMES[4] = { "Regulars", "Cavalry", "Man-O-War",
                                        "Artillery" };
        ev_emit((CR.woi_flags & WOI_DECLARED) ? "KINGMOBILIZE" : "KINGBUY",
                0, 0, NAMES[pick], 0);
    }
}

/* runWar (game.js:9127). */
void run_war(void) {
    if (!(CR.woi_flags & WOI_DECLARED) || (CR.woi_flags & WOI_WON)) return;
    grow_ref();
    /* the national sentiment bands */
    int pct = national_sol();
    int band = pct / 10;
    if (CR.nat_band == 0xFF) CR.nat_band = (uint8_t)band;
    else if (band > CR.nat_band) {
        ev_emit(pct >= 50 && CR.nat_band < 5 ? "REBELUP50" : "REBELUP",
                pct, 0, 0, 0);
        CR.nat_band = (uint8_t)band;
    } else if (band < CR.nat_band) {
        ev_emit("REBELDOWN", pct, 0, 0, 0);
        CR.nat_band = (uint8_t)band;
    }
    /* the capitulation ladder (flagged like the JS: control = lost) */
    int ports = 0;
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation() && coastal(ci))
            ports++;
    int ncol = n_player_colonies();
    if (ncol && ports == 1 && !CR.warned_ports) {
        CR.warned_ports = 1;
        ev_emit("WARN1", 1, 0, 0, 0);
    }
    int pop_pct = 100 * CR.razed / (CR.razed + ncol > 0 ? CR.razed + ncol : 1);
    if (pop_pct >= 75 && pop_pct < 90 && !CR.warned_pop) {
        CR.warned_pop = 1;
        ev_emit("WARN3", pop_pct, 0, 0, 0);
    }
    if (!CR.lost_war && ncol) {
        if (ports == 0) {
            CR.lost_war = 1;
            ev_emit("LOSING1", 0, 0, 0, 0);
            end_game_sequence();
            return;
        }
        if (pop_pct >= 90) {
            CR.lost_war = 1;
            ev_emit("LOSING3", pop_pct, 0, 0, 0);
            end_game_sequence();
            return;
        }
    }
    /* the REF march (list order, iterated from the END like the JS) */
    for (int i = CR.n_refs - 1; i >= 0; i--) {
        int ui = CR.refs_order[i];
        UnitRecord *u = &CS.units[ui];
        u->moves_remaining = (uint8_t)(dat_units[u->type].movement * 3);
        if (dat_units[u->type].hull > 0) continue;
        int best = -1, bd = 0;
        for (int ci = 0; ci < CS.n_colonies; ci++) {
            if ((CS.colonies[ci].owner_power & 3) != cs_nation()) continue;
            int dx = CS.colonies[ci].map_x - u->map_x;
            int dy = CS.colonies[ci].map_y - u->map_y;
            if (dx < 0) dx = -dx;
            if (dy < 0) dy = -dy;
            if (best < 0 || dx + dy < bd) { best = ci; bd = dx + dy; }
        }
        if (best < 0) continue;
        ColonyRecord *c = &CS.colonies[best];
        int dx = c->map_x > u->map_x ? 1 : c->map_x < u->map_x ? -1 : 0;
        int dy = c->map_y > u->map_y ? 1 : c->map_y < u->map_y ? -1 : 0;
        if (dx == 0 && dy == 0) {
            /* standing in a rebel colony: fight the garrison or take it */
            int def = -1;
            for (int k = 0; k < CR.n_units_order && def < 0; k++) {
                int q = CR.units_order[k];
                if (dat_units[CS.units[q].type].hull > 0) continue;
                if (CS.units[q].map_x == c->map_x &&
                    CS.units[q].map_y == c->map_y) def = q;
            }
            if (def >= 0) {
                /* unit_remove already re-bases refs_order on any removal;
                 * only the CURRENT attacker can leave the list, and the
                 * descending walk is safe against that like the JS. */
                resolve_attack(ui, def);
                continue;
            }
            colony_remove(best);
            CR.razed++;
            CR.screen_map = 1;           /* WDCUT11 + the trace dismissal */
            ev_emit("BURNED", 0, 0, c->name, 0);
            continue;
        }
        if (!tile_water(map_at(u->map_x + dx, u->map_y + dy))) {
            u->map_x = (uint8_t)(u->map_x + dx);
            u->map_y = (uint8_t)(u->map_y + dy);
        } else if (!tile_water(map_at(u->map_x + dx, u->map_y))) {
            u->map_x = (uint8_t)(u->map_x + dx);
        } else if (!tile_water(map_at(u->map_x, u->map_y + dy))) {
            u->map_y = (uint8_t)(u->map_y + dy);
        }
    }
    /* fresh waves while the Crown has troops left */
    long afloat = 0;
    for (int i = 0; i < 4; i++) afloat += CR.ref_pool[i];
    int landed = 0;
    for (int i = 0; i < CR.n_refs; i++)
        if (dat_units[CS.units[CR.refs_order[i]].type].hull <= 0) landed++;
    if (afloat > 0 && landed == 0) ref_wave();
    landed = 0;
    for (int i = 0; i < CR.n_refs; i++)
        if (dat_units[CS.units[CR.refs_order[i]].type].hull <= 0) landed++;
    if (landed == 0 && afloat == 0) {
        CR.woi_flags |= WOI_WON;
        ev_emit("KINGLOSE", 0, 0, 0, 0);
        ev_emit("WINNING", 0, 0, 0, 0);
    }
    if (!n_player_colonies() && !(CR.woi_flags & WOI_WON) && !CR.lost_war) {
        CR.lost_war = 1;
        ev_emit("LOSING2", 0, 0, 0, 0);
        ev_emit("KINGWIN", 0, 0, 0, 0);
        end_game_sequence();
    }
}

/* toryUprising (game.js:9306): the byte-exact nonzero-roll gate. */
void tory_uprising(void) {
    if (!(CR.woi_flags & WOI_DECLARED) || (CR.woi_flags & WOI_WON)) return;
    for (int ci = 0; ci < CS.n_colonies; ci++) {
        if ((CS.colonies[ci].owner_power & 3) != cs_nation()) continue;
        if (rt_sol(ci) >= 50) continue;
        if (R(cs_difficulty() + 2) == 0) continue;
        if (R(12) != 0) continue;        /* the port's call frequency */
        int ui = unit_append(urow("Regulars"), 0x0F,
                             CS.colonies[ci].map_x, CS.colonies[ci].map_y);
        if (ui >= 0) {
            CR.unit_is_ref[ui] = 1;
            refs_push(ui);
        }
        ev_emit("TORYUPRISING", 0, 0, CS.colonies[ci].name, 0);
        return;
    }
}

/* offerMercenaries (game.js:9235): the byte-verified price shape. */
void offer_mercenaries(void) {
    if (!(CR.woi_flags & WOI_DECLARED)) return;
    if (!CR.merc_seen) { CR.merc_seen = 1; return; }
    if (R(3) != 0) return;
    int hi = (4 - cs_difficulty()) / 2 + 2;
    int span = hi - 1 > 1 ? hi - 1 : 1;
    int count = 2 + R(span);
    int32_t per_unit = ((cs_difficulty() + 3) * 2 + R(7)) * 100;
    int32_t price = per_unit * (1 * 2 + count);
    PowerRecord *p = &CS.powers[cs_nation()];
    if (price > p->gold) return;         /* only offered if affordable */
    static const char *WARTIME[2] = { "Cont. Cav.", "Artillery" };
    int extra = R(2);
    ev_emit("MERCENARIES", price, count, WARTIME[extra], 0);
    if (ask_choice() != 1 || p->gold < price) return;
    p->gold -= price;
    int cx = -1, cy = -1;
    for (int ci = 0; ci < CS.n_colonies && cx < 0; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation()) {
            cx = CS.colonies[ci].map_x;
            cy = CS.colonies[ci].map_y;
        }
    if (cx < 0 && CR.n_units_order) {
        int u0 = CR.units_order[0];
        cx = CS.units[u0].map_x;
        cy = CS.units[u0].map_y;
    }
    if (cx < 0) return;
    for (int i = 0; i < count; i++) {
        int ui = unit_append(urow("Cont. Army"), (int)cs_nation(), cx, cy);
        if (ui >= 0) CR.unit_veteran[ui] = 1;
    }
    unit_append(urow(WARTIME[extra]), (int)cs_nation(), cx, cy);
    ev_emit("MERCS", count + 1, 0, 0, 0);
}

/* checkIntervention (game.js:9327): FLAGGED 2000-bell threshold. */
#define INTERVENTION_BELLS 2000
void check_intervention(void) {
    if (!(CR.woi_flags & WOI_DECLARED) ||
        (CR.woi_flags & WOI_INTERVENTION)) return;
    int ally = -1;
    for (int rn = 0; rn < 4 && ally < 0; rn++)
        if (rn != (int)cs_nation() && CR.rivals[rn].met &&
            !rel_at_war((int)cs_nation(), rn)) ally = rn;
    if (ally < 0) return;
    if (!CR.intervention_watch) {
        CR.intervention_watch = 1;
        ev_emit("CONSIDER", INTERVENTION_BELLS, 0,
                dat_nations[ally].adjective, 0);
        return;
    }
    if (CR.bells_total < INTERVENTION_BELLS) return;
    CR.woi_flags |= WOI_INTERVENTION;
    ev_emit("INTERVENTION", 0, 0, dat_nations[ally].adjective, 0);
    int target = -1;
    for (int ci = 0; ci < CS.n_colonies && target < 0; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation() && coastal(ci))
            target = ci;
    if (target < 0)
        for (int ci = 0; ci < CS.n_colonies && target < 0; ci++)
            if ((CS.colonies[ci].owner_power & 3) == cs_nation()) target = ci;
    if (target < 0) return;
    ev_emit("INTERVENE", 0, 0, CS.colonies[target].name,
            dat_nations[ally].adjective);
    for (int i = 0; i < 4; i++) {
        int ui = unit_append(urow(i == 3 ? "Artillery" : "Cont. Army"),
                             (int)cs_nation(), CS.colonies[target].map_x,
                             CS.colonies[target].map_y);
        if (ui >= 0) CR.unit_veteran[ui] = 1;
    }
}
