/* The native pass — §19.11 order (game.js endTurn:10767-10780):
 *   nativeTick -> nativeDemands -> attemptConversions -> ageConverts ->
 *   nativeMoveAI (which marches war-footing braves and fires nativeRaid on
 *   arrival) -> the second @VANISH filter (raid-razed colonies leave).
 *
 * Ports, with the JS line for each: nativeTick (5929), spawnBrave (5951),
 * settlementCap (5917), missionStrength (5921), nativeDemands (5422),
 * attemptConversions (5373), ageConverts (5395), surpriseRaidCheck (5603),
 * raidOutcome (5610), raidTargetScore (5646, byte-ported func_0460F8),
 * nativeRaid (5702, gate func_05BE84), headingScore (5825, byte-decoded
 * func_046FFA), nativeMoveAI (5861).  Every EXE citation carries over from
 * the JS comments; where the JS itself is flagged (demand triggers/amounts,
 * the raid-ladder placements), this mirrors the flagged model — the JS port
 * is the parity reference, the flags stay open in both.
 *
 * Representation: braves are the unit records with owner nibble >= 4
 * (importer game.js:10431); their JS-only fields live in CR
 * (native_home / native_heading).  Converts are appended player unit
 * records with profession = the "Indian Converts" @JOB row and a CR faith
 * countdown.  Ask-events are emitted key-only with no state change — the
 * trace's stubbed askEvent (callback never runs), flagged.
 *
 * NOT mirrored (flagged): the RAIDSTORES village-side banking
 * (v.stock/v.wealth, game.js:5718 — settlement +0x08/+0x0A) has no CR home
 * yet; it feeds only village trade, which is unported.  The INDIANWAGONS
 * claim can never fire in either engine — the importer only ever seeds
 * holds on SHIPS (game.js:10463), so no Wagon Train carries cargo. */
#include <string.h>

#include "colopy_sim.h"
#include "../data/colopy_data.h"

/* the two byte-verified thresholds (game.js:4976/5091) */
#define TENSION_HOSTILE 75
#define TENSION_WAR     100
#define ALARM_RAID      0x80

/* random_int over the MSC LCG: floor(k*N/32768) is exact for N <= 32768 */
static int R(int n) { return (int)((rng_next() * (uint32_t)n) >> 15); }
/* Math.random() < p as an integer compare on k = rng_next():
 * < 0.4 <=> k <= 13107, < 0.2 <=> k <= 6553, < 0.25 <=> k <= 8191 */
static int rand_lt(int max_k) { return (int)rng_next() <= max_k; }

static int floordiv(int a, int b) {          /* Math.floor(a/b), b > 0 */
    int q = a / b;
    return (a % b != 0 && (a < 0)) ? q - 1 : q;
}

/* ---- table lookups (strcmp once, like the JS name model) --------------- */
static int g_res;
static int TY_BRAVES = -1, TY_COLONISTS = -1;
static int JOB_CONVERT = -1;                 /* @JOB row 27, class 0x1B */
static int FF_LAS_CASAS = -1, FF_SEPULVEDA = -1, FF_POCAHONTAS = -1;
static void nresolve(void) {
    if (g_res) return;
    g_res = 1;
    for (int i = 0; i < DAT_UNITS_COUNT; i++) {
        if (strcmp(dat_units[i].name, "Braves") == 0) TY_BRAVES = i;
        if (strcmp(dat_units[i].name, "Colonists") == 0) TY_COLONISTS = i;
    }
    for (int i = 0; i < DAT_JOBEXPERT_COUNT; i++)
        if (strcmp(dat_jobexpert[i], "Indian Converts") == 0) JOB_CONVERT = i;
    for (int i = 0; i < DAT_FATHERS_COUNT; i++) {
        if (strcmp(dat_fathers[i].name, "Bartolome de las Casas") == 0)
            FF_LAS_CASAS = i;
        if (strcmp(dat_fathers[i].name, "Juan de Sepulveda") == 0)
            FF_SEPULVEDA = i;
        if (strcmp(dat_fathers[i].name, "Pocahontas") == 0) FF_POCAHONTAS = i;
    }
}
static int ff_owned(int idx) {
    return idx >= 0 &&
           ((CS.powers[cs_nation()].founding_fathers >> idx) & 1);
}

/* ---- shared predicates ------------------------------------------------- */
int tribe_level(int tribe) {
    return (tribe >= 0 && tribe < 8) ? CS.tribes[tribe * 0x4E + 2] : 0;
}
static int is_brave(int ui) {                /* G.natives membership */
    const UnitRecord *u = &CS.units[ui];
    if (CR.unit_in_natives[ui]) return 1;    /* the rival-capture quirk */
    return (u->owner_flags & 0x0F) >= 4 &&
           (u->owner_flags & 0x0F) != 0x0F &&   /* 0x0F = the King's REF */
           u->type < DAT_UNITS_COUNT &&
           dat_units[u->type].hull <= 0;
}
static int player_colony_count(void) {
    int n = 0;
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation()) n++;
    return n;
}
static int nth_player_colony(int n) {
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation() && n-- == 0)
            return ci;
    return -1;
}
/* colonyLevel (game.js:5002): Stockade/Fort/Fortress by name. */
static int colony_level(int ci) {
    if (colony_has_name(ci, "Fortress")) return 3;
    if (colony_has_name(ci, "Fort")) return 2;
    if (colony_has_name(ci, "Stockade")) return 1;
    return 0;
}
/* STARTING_BUILDINGS (game.js:2163): the upkeep-0 min_colony-1 rows,
 * derived from @BUILDING, matched by NAME. */
static int is_starting_name(const char *name) {
    for (int b = 0; b < DAT_BUILDINGS_COUNT; b++)
        if (dat_buildings[b].upkeep == 0 && dat_buildings[b].min_colony == 1 &&
            strcmp(dat_buildings[b].name, name) == 0) return 1;
    return 0;
}
/* The friendly/hostile claim gate: the first player colony with a village
 * of this tribe within the 7x7 box (game.js:5433/5472). */
static int colony_near_tribe(int tribe) {
    for (int ci = 0; ci < CS.n_colonies; ci++) {
        if ((CS.colonies[ci].owner_power & 3) != cs_nation()) continue;
        for (int v = 0; v < CS.n_villages; v++) {
            if (CS.villages[v].owner_tribe != tribe + 4) continue;
            int dx = CS.villages[v].map_x - CS.colonies[ci].map_x;
            int dy = CS.villages[v].map_y - CS.colonies[ci].map_y;
            if (dx < 0) dx = -dx;
            if (dy < 0) dy = -dy;
            if (dx <= 3 && dy <= 3) return ci;
        }
    }
    return -1;
}
/* Top stock at-or-above a floor: the JS sort-desc-stable [0] = the maximum
 * with the LOWEST good index on ties (game.js:5713/5475/5523). */
static int top_stock(const ColonyRecord *c, int floor_qty, int *qty) {
    int best = -1, bv = 0;
    for (int i = 0; i < N_GOODS; i++)
        if (c->stock[i] >= floor_qty && c->stock[i] > bv) {
            bv = c->stock[i];
            best = i;
        }
    *qty = bv;
    return best;
}

/* ---- the background economy (nativeTick, game.js:5929) ----------------- */
/* settlementCap (game.js:5917) = func_046DE0: 2*level+3, capital 3*level+4 */
static int settlement_cap(int vi) {
    int lv = tribe_level(CS.villages[vi].owner_tribe - 4);
    return (CS.villages[vi].flags & 0x04) ? 3 * lv + 4 : 2 * lv + 3;
}
/* missionStrength (game.js:5921): expert 4 / plain 1, x2 capital,
 * x2 las Casas, /2 Sepulveda. */
static int mission_strength(int vi) {
    const NativeSettlement *v = &CS.villages[vi];
    if (v->mission == 0xFF) return 0;
    nresolve();
    int m = (v->mission & 0x10) ? 4 : 1;
    if (v->flags & 0x04) m *= 2;
    if (ff_owned(FF_LAS_CASAS)) m *= 2;
    if (ff_owned(FF_SEPULVEDA)) m /= 2;
    return m;
}
/* spawnBrave (game.js:5951): first E/W/S/N spot that is not water, not a
 * village, not another brave. */
static void spawn_brave(int vi) {
    static const int8_t SDX[4] = { 1, -1, 0, 0 };
    static const int8_t SDY[4] = { 0, 0, 1, -1 };
    nresolve();
    const NativeSettlement *v = &CS.villages[vi];
    for (int s = 0; s < 4; s++) {
        int x = v->map_x + SDX[s], y = v->map_y + SDY[s];
        if (tile_water(map_at(x, y))) continue;
        int taken = 0;
        for (int w = 0; w < CS.n_villages && !taken; w++)
            if (CS.villages[w].map_x == x && CS.villages[w].map_y == y)
                taken = 1;
        for (int ui = 0; ui < CS.n_units && !taken; ui++)
            if (is_brave(ui) && CS.units[ui].map_x == x &&
                CS.units[ui].map_y == y) taken = 1;
        if (taken) continue;
        int ui = unit_append(TY_BRAVES, 4 + (v->owner_tribe - 4), x, y);
        if (ui >= 0) {
            CR.native_home[ui] = (int8_t)vi;
            natives_push(ui);
        }
        return;
    }
}
static void native_tick(void) {
    for (int vi = 0; vi < CS.n_villages; vi++) {
        NativeSettlement *v = &CS.villages[vi];
        /* growth accumulator += population, acting at 20 (settlement +0x06) */
        v->growth = (uint8_t)(v->growth + v->population);
        if (v->growth >= 20) {
            v->growth = 0;
            if (CR.brave_owed[vi]) {
                CR.brave_owed[vi] = 0;
                spawn_brave(vi);
            } else if (v->population < settlement_cap(vi)) v->population++;
        }
        /* the mission tick: 8 feeder points = one -1 tension tick, and the
         * village alarm word falls 3*M (RULINGS 2026-08-01) */
        int m = mission_strength(vi);
        if (!m || (v->mission & 0x0F) != cs_nation()) continue;
        int tribe = v->owner_tribe - 4;
        if (tribe < 0 || tribe >= 8) continue;
        CR.tribe_frac[tribe] = (uint8_t)(CR.tribe_frac[tribe] + m);
        while (CR.tribe_frac[tribe] >= 8) {
            CR.tribe_frac[tribe] -= 8;
            adjust_tension(tribe, -1, 0);
        }
        int a = CR.alarm[vi] - 3 * m;
        CR.alarm[vi] = (uint8_t)(a > 0 ? a : 0);
    }
}

/* ---- what the natives demand (nativeDemands, game.js:5422) -------------
 * Triggers and amounts are the JS port's flagged model (the manual names
 * the claims, not their numbers); mirrored draw-for-draw. */
static void native_demands(void) {
    if (!player_colony_count()) return;
    for (int ti = 0; ti < 8; ti++) {
        int tension = CR.tension[ti];
        /* the FRIENDLY half (Content band): gifts, begging, flavour */
        if (tension < 20) {
            if (R(24) != 0) continue;
            int nc = colony_near_tribe(ti);
            if (nc < 0) continue;
            ColonyRecord *c = &CS.colonies[nc];
            int roll = R(5);
            if (roll == 0 && c->stock[FOOD] < 100) {
                int gift = 20 + R(30);               /* @INDIANGIVEFOOD */
                c->stock[FOOD] = (uint16_t)(c->stock[FOOD] + gift);
                ev_emit("INDIANGIVEFOOD", gift, 0, dat_tribes[ti].name, 0);
            } else if (roll == 1) {
                int g = R(8);                        /* @INDIANGIVESTUFF */
                int gift = 10 + R(20);
                c->stock[g] = (uint16_t)(c->stock[g] + gift);
                ev_emit("INDIANGIVESTUFF", gift, 0, dat_tribes[ti].name,
                        c->name);
            } else if (roll == 2 && c->stock[FOOD] >= 40) {
                /* @INDIANBEGFOOD (game.js:5453): row 1 shares half */
                int offer = c->stock[FOOD] / 2;
                ev_emit("INDIANBEGFOOD", offer, 0, dat_tribes[ti].name,
                        c->name);
                if (ask_choice() == 1) {
                    c->stock[FOOD] = (uint16_t)(c->stock[FOOD] - offer);
                    adjust_tension(ti, -8, 0);
                } else adjust_tension(ti, 5, 0);
            } else if (roll == 3) {
                ev_emit("INDIANCOMMENT", 0, 0, dat_tribes[ti].name, 0);
            } else {
                ev_emit("INDIANCOME", 0, 0, dat_tribes[ti].name, 0);
            }
            continue;
        }
        if (tension < TENSION_HOSTILE) continue;
        if (R(24) != 0) continue;        /* rare, per tribe, per turn */
        /* @WANTSTUFF: reparations off the largest stock of a colony in
         * their country (WoI suffix TBD: fixtures undeclared) */
        {
            int wc = colony_near_tribe(ti);
            if (wc >= 0 && rand_lt(13107)) {         /* < 0.4 */
                int qty;
                int top = top_stock(&CS.colonies[wc], 10, &qty);
                if (top >= 0) {
                    int take = 15 + 5 * cs_difficulty();
                    if (take > qty) take = qty;
                    ev_emit("WANTSTUFF", take, 0, dat_tribes[ti].name,
                            dat_cargo[top].name);
                    if (ask_choice() == 1) {         /* game.js:5482 */
                        CS.colonies[wc].stock[top] =
                            (uint16_t)(CS.colonies[wc].stock[top] - take);
                        adjust_tension(ti, -10, 0);
                    } else adjust_tension(ti, 15, 5);
                    return;
                }
            }
        }
        /* @INDIANBURN: at war the tribe burns our missions */
        if (tension >= TENSION_WAR && rand_lt(6553)) {   /* < 0.2 */
            for (int vi = 0; vi < CS.n_villages; vi++) {
                NativeSettlement *v = &CS.villages[vi];
                if (v->owner_tribe != ti + 4 || v->mission == 0xFF ||
                    (v->mission & 0x0F) != cs_nation()) continue;
                v->mission = 0xFF;
                ev_emit("INDIANBURN", 0, 0, dat_tribes[ti].name,
                        dat_nations[cs_nation()].adjective);
                return;
            }
        }
        /* @RID: ordered out of the region outright (@RIDUSA once the
         * independence flag is up — game.js:5503) */
        if (tension >= TENSION_WAR && rand_lt(8191)) {   /* < 0.25 */
            ev_emit((CR.woi_flags & WOI_DECLARED) ? "RIDUSA" : "RID",
                    0, 0, dat_tribes[ti].name, dat_regionname[cs_nation()]);
            return;
        }
        /* @INDIANWAGONS: unreachable — no Wagon Train ever has a hold
         * (importer seeds holds on ships only, game.js:10463); no draw. */
        /* @INDIANCITY / @INDIANGOLD: goods from a random colony's stores,
         * else gold (both ask stubs) */
        {
            int ci = nth_player_colony(R(player_colony_count()));
            int qty;
            int top = ci >= 0 ? top_stock(&CS.colonies[ci], 20, &qty) : -1;
            if (top >= 0) {
                int take = 20 + 10 * cs_difficulty();
                if (take > qty) take = qty;
                ev_emit("INDIANCITY", take, 0, dat_tribes[ti].name,
                        dat_cargo[top].name);
                if (ask_choice() == 1) {             /* game.js:5531 */
                    CS.colonies[ci].stock[top] =
                        (uint16_t)(CS.colonies[ci].stock[top] - take);
                    adjust_tension(ti, -10, 0);
                } else adjust_tension(ti, 15, 0);
            } else {
                /* demandValue(200) (game.js:8214): the byte-cited scaler */
                int32_t want = 200 * 10 * (cs_difficulty() + 8) / 100 +
                               500 * (cs_difficulty() + 1);
                ev_emit("INDIANGOLD", want, 0, dat_tribes[ti].name, 0);
                PowerRecord *p = &CS.powers[cs_nation()];
                if (ask_choice() == 1 && p->gold >= want) {
                    p->gold -= want;
                    adjust_tension(ti, -10, 0);
                } else adjust_tension(ti, 15, 0);
            }
            return;
        }
    }
}

/* ---- conversions (attemptConversions/ageConverts, game.js:5373/5395) --- */
/* conversionThreshold (game.js:5367): level+2, x2 under an expert mission;
 * convert fires when floor(rand*16) < threshold (fails @0x57316). */
static void attempt_conversions(void) {
    nresolve();
    for (int vi = 0; vi < CS.n_villages; vi++) {
        const NativeSettlement *v = &CS.villages[vi];
        if (v->mission == 0xFF || (v->mission & 0x0F) != cs_nation()) continue;
        if (!player_colony_count()) continue;
        int th = tribe_level(v->owner_tribe - 4) + 2;
        if (v->mission & 0x10) th *= 2;
        if (R(16) >= th) continue;
        /* the convert appears at the nearest colony (handler takes a
         * ColonyRecord; nearest is the port's reading, flagged in JS) */
        int best = -1, bd = 0;
        for (int ci = 0; ci < CS.n_colonies; ci++) {
            if ((CS.colonies[ci].owner_power & 3) != cs_nation()) continue;
            int dx = CS.colonies[ci].map_x - v->map_x;
            int dy = CS.colonies[ci].map_y - v->map_y;
            int d = (dx < 0 ? -dx : dx) + (dy < 0 ? -dy : dy);
            if (best < 0 || d < bd) { best = ci; bd = d; }
        }
        if (best < 0) continue;
        int ui = unit_append(TY_COLONISTS, cs_nation(),
                             CS.colonies[best].map_x, CS.colonies[best].map_y);
        if (ui >= 0) {
            CS.units[ui].profession = (uint8_t)JOB_CONVERT;
            CR.unit_faith[ui] = 8;               /* CONVERT_FAITH */
        }
        ev_emit("INDIANSCONVERT", 0, 0, CS.colonies[best].name, 0);
        /* tutOnce(19): TUTORIAL* keys are excluded from the parity diff */
    }
}
static void age_converts(void) {
    nresolve();
    int lost = 0;
    /* JS iterates G.UNITS backwards (game.js:5397) — a convert CAPTURED
     * by a rival left that list and never ages again; walk the order
     * list, not the record pool */
    for (int k = CR.n_units_order - 1; k >= 0; k--) {
        int ui = CR.units_order[k];
        if (CS.units[ui].profession != JOB_CONVERT || !CR.unit_faith[ui])
            continue;
        CR.unit_faith[ui]--;
        if (CR.unit_faith[ui] > 0) continue;
        unit_remove(ui);            /* drops list slot k, re-bases */
        lost++;
    }
    if (lost) ev_emit("DEADCONVERTS", 0, 0, 0, 0);
}

/* ---- the raid-target scorer (game.js:5646, func_0460F8 byte-ported) ---- */
static const int8_t RING_DX[20] = { 0, 1, 0, -1, -1, 1, 1, -1, 0, 2, 0, -2,
                                    -1, 1, -1, 1, -2, -2, 2, 2 };
static const int8_t RING_DY[20] = { -1, 0, 1, 0, -1, -1, 1, 1, -2, 0, 2, 0,
                                    -2, -2, 2, 2, -1, 1, -1, 1 };
static const int8_t FORT_W[5][2] = { {1, 2}, {3, 4}, {1, 1}, {3, 2}, {2, 1} };
int raid_target_score(int vi, int *score_out) {
    nresolve();
    const NativeSettlement *v = &CS.villages[vi];
    int area[4] = { 0, 0, 0, 0 };
    for (int k = 0; k < 20; k++) {
        int x = v->map_x + RING_DX[k], y = v->map_y + RING_DY[k];
        if (x < 1 || y < 1 || x >= COLOPY_MAP_W - 1 || y >= COLOPY_MAP_H - 1)
            continue;
        if (tile_water(map_at(x, y))) continue;
        int s = 0, owner = -1;
        /* player units first (G.units), then rivals in nation order —
         * ships never score and never claim the tile (@0x46172-0x4617E) */
        for (int ui = 0; ui < CS.n_units; ui++) {
            if (!unit_on_map_player(ui)) continue;
            const UnitRecord *u = &CS.units[ui];
            if (u->map_x != x || u->map_y != y) continue;
            if (dat_units[u->type].hull > 0) continue;
            int a = dat_units[u->type].attack;
            if (a > 1) s += a;
            if (owner < 0) owner = cs_nation();
        }
        for (int nn = 0; nn < 4; nn++) {
            if (nn == cs_nation()) continue;
            for (int ui = 0; ui < CS.n_units; ui++) {
                const UnitRecord *u = &CS.units[ui];
                if ((u->owner_flags & 0x0F) != nn) continue;
                if (CR.runit_x[ui] != x || CR.runit_y[ui] != y) continue;
                if (u->type >= DAT_UNITS_COUNT ||
                    dat_units[u->type].hull > 0) continue;
                int a = dat_units[u->type].attack;
                if (a > 1) s += a;
                if (owner < 0) owner = nn;
            }
        }
        if (owner < 0 || !s) continue;
        /* any colony on the tile halves (the layer-2 bit approximation) */
        for (int ci = 0; ci < CS.n_colonies; ci++)
            if (CS.colonies[ci].map_x == x && CS.colonies[ci].map_y == y) {
                s >>= 1;
                break;
            }
        if (RING_DX[k] > 1 || RING_DX[k] < -1 ||
            RING_DY[k] > 1 || RING_DY[k] < -1) s >>= 1;
        area[owner] += s;
    }
    int d = cs_difficulty();
    if (d < 0) d = 0;
    if (d > 4) d = 4;
    int w = FORT_W[d][0], dv = FORT_W[d][1];
    int lvl = tribe_level(v->owner_tribe - 4);
    int best = -1, best_score = -1;
    for (int ci = 0; ci < CS.n_colonies; ci++) {
        const ColonyRecord *c = &CS.colonies[ci];
        if ((c->owner_power & 3) != cs_nation()) continue;
        int dx = c->map_x - v->map_x, dy = c->map_y - v->map_y;
        int dist = (dx < 0 ? -dx : dx) + (dy < 0 ? -dy : dy);
        if (dist > 6) continue;
        int pop = c->population;
        int fort = (CR.col[ci].n_bld * w / dv - 8) >> 2;   /* arithmetic >> */
        int p6 = pop - 6;
        if (p6 < 0) p6 = 0;
        int cap = pop >> 1 < lvl ? pop >> 1 : lvl;
        int p_min6 = pop < 6 ? pop : 6;
        int s = floordiv((2 * p6 + cap + p_min6 + fort) * 2 - dist - 1,
                         dist + 4);
        /* different map region halves (layer-3 low nibble, func_005D9C) */
        if ((CS.region[v->map_y * COLOPY_MAP_W + v->map_x] & 0x0F) !=
            (CS.region[c->map_y * COLOPY_MAP_W + c->map_x] & 0x0F)) s >>= 1;
        s += area[cs_nation()];
        if (cs_nation() == 1) s >>= 1;               /* France @0x46388 */
        if (ff_owned(FF_POCAHONTAS)) s >>= 1;        /* attr bit 0x10 */
        if (s > best_score) { best_score = s; best = ci; }
    }
    /* mission tail @0x4645E-0x464AD */
    if (best >= 0 && best_score > 0 && v->mission != 0xFF) {
        if ((v->mission & 0x0F) != cs_nation())
            best_score = (v->mission & 0x10) ? best_score << 1
                                             : best_score + (best_score >> 1);
        else
            best_score = (v->mission & 0x10) ? best_score >> 1
                                             : best_score - (best_score >> 2);
    }
    *score_out = best >= 0 ? best_score : -1;
    return best;
}

/* ---- one raid attempt (nativeRaid, game.js:5702 / func_05BE84) --------- */
static void native_raid(int vi, int ci) {
    int tribe = CS.villages[vi].owner_tribe - 4;
    ColonyRecord *c = &CS.colonies[ci];
    /* gate: random_int(1,12)-1 + (difficulty-2) vs 3*K+1, K = the
     * fortification count (func_00864E, RULINGS 2026-08-07c) */
    int gate = R(12) + cs_difficulty() - 2;
    if (gate < 3 * colony_level(ci) + 1) return;
    /* @INDIANSURPRISE: a raid from a still-calm tribe (band < restless) */
    if (tribe >= 0 && tribe < 8 && tension_band(CR.tension[tribe]) < 2)
        ev_emit("INDIANSURPRISE", 0, 0, dat_tribes[tribe].name, c->name);
    /* outcome random_int(1,4), softened while turn < 40*(2-difficulty) */
    int out = 1 + R(4);
    if ((int)cs_turn() < 40 * (2 - (int)cs_difficulty())) out -= 1;
    if (out < 0) out = 0;
    switch (out) {
    case 1: {                                        /* @RAIDSTORES */
        int qty;
        int g = top_stock(c, 0, &qty);
        if (g < 0 || !qty) { ev_emit("RAIDNOTHING", 0, 0, 0, 0); break; }
        c->stock[g] = 0;
        /* village banking (+0x08/+0x0A, @0x5C3E1) unmodeled — see header */
        adjust_tension(tribe, -4, 0);        /* push -4 @0x5C416 */
        ev_emit("RAIDSTORES", qty, 0, c->name, dat_cargo[g].name);
        break;
    }
    case 2: {                                        /* @RAIDWREAK */
        const colony_rt *r = &CR.col[ci];
        int pick[48], np = 0;
        for (int k = 0; k < r->n_bld; k++)
            if (!is_starting_name(dat_buildings[r->bld[k]].name))
                pick[np++] = r->bld[k];
        if (np)
            colony_bld_remove_name(ci, dat_buildings[pick[R(np)]].name);
        ev_emit("RAIDWREAK", 0, 0, c->name, 0);
        break;
    }
    case 3: {                                        /* @RAIDGOLD */
        PowerRecord *p = &CS.powers[cs_nation()];
        int32_t cap = p->gold < 0x7FFF ? p->gold : 0x7FFF;
        int32_t take = cap >= 0x32 ? 0x32 + R((int)(cap - 0x32 + 1))
                                   : p->gold;
        p->gold -= take;
        adjust_tension(tribe, -16, 0);       /* push -0x10 @0x5C5BC */
        ev_emit("RAIDGOLD", take, 0, c->name, 0);
        break;
    }
    case 4: {                                        /* @RAIDBURN/@RAIDSHIP */
        int ship = -1;
        for (int k = 0; k < CR.n_units_order && ship < 0; k++) {
            int ui = CR.units_order[k];      /* G.units order */
            if (dat_units[CS.units[ui].type].hull > 0 &&
                CS.units[ui].map_x == c->map_x &&
                CS.units[ui].map_y == c->map_y) ship = ui;
        }
        if (ship >= 0) {
            CR.unit_damaged[ship] = 1;
            ev_emit("RAIDSHIP", 0, 0, c->name,
                    dat_units[CS.units[ship].type].name);
            break;
        }
        const colony_rt *r = &CR.col[ci];
        int pick[48], np = 0;
        for (int k = 0; k < r->n_bld; k++)
            if (!is_starting_name(dat_buildings[r->bld[k]].name))
                pick[np++] = r->bld[k];
        int defended = 0;
        for (int ui = 0; ui < CS.n_units && !defended; ui++)
            if (unit_on_map_player(ui) &&
                dat_units[CS.units[ui].type].hull <= 0 &&
                CS.units[ui].map_x == c->map_x &&
                CS.units[ui].map_y == c->map_y) defended = 1;
        if (!np && c->population <= 1 && !defended) {
            /* @INDIANBURNCOLONY — razed outright (threshold flagged) */
            ev_emit("INDIANBURNCOLONY", 0, 0, dat_tribes[tribe].name,
                    c->name);
            CR.col[ci].vanished = 1;
            break;
        }
        if (!np && c->population > 1 && !defended) {
            /* @INDIANWINCOLONY (@0x5E01F): dec size while > 1 @0x5D67A */
            colonist_remove_last(ci);
            ev_emit("INDIANWINCOLONY", 0, 0, dat_tribes[tribe].name,
                    c->name);
            break;
        }
        if (!np) { ev_emit("RAIDWREAK", 0, 0, c->name, 0); break; }
        {
            int b = pick[R(np)];
            colony_bld_remove_name(ci, dat_buildings[b].name);
            ev_emit("RAIDBURN", 0, 0, c->name, dat_buildings[b].name);
        }
        break;
    }
    default:
        ev_emit("RAIDNOTHING", 0, 0, 0, 0);          /* @RAIDNOTHING */
        break;
    }
    /* woodcut 13, INDIAN RAID (@0x05D219): once-per-game latch into the
     * wcSeen word (globals +0x8A) — no event key (drawn, not shown) */
    if (!CR.raid_seen) {
        CR.raid_seen = 1;
        uint16_t wc = (uint16_t)(CS.globals[0x8A] | (CS.globals[0x8B] << 8));
        wc |= 1u << 13;
        CS.globals[0x8A] = (uint8_t)wc;
        CS.globals[0x8B] = (uint8_t)(wc >> 8);
        CR.screen_map = 1;   /* the trace dismisses the woodcut to the map */
    }
}

/* ---- the idle mover (headingScore, game.js:5825 / func_046FFA) --------- */
static const int8_t DIRS_DX[8] = { 1, -1, 0, 0, 1, 1, -1, -1 };
static const int8_t DIRS_DY[8] = { 0, 0, 1, -1, 1, -1, 1, -1 };
static int tile_occupied(int self, int x, int y) {
    for (int ui = 0; ui < CS.n_units; ui++) {
        if (ui == self) continue;
        const UnitRecord *u = &CS.units[ui];
        if (is_brave(ui) && u->map_x == x && u->map_y == y) return 1;
        if (unit_on_map_player(ui) && u->map_x == x && u->map_y == y) return 1;
        int own = u->owner_flags & 0x0F;
        if (own < 4 && own != cs_nation() && u->type < DAT_UNITS_COUNT &&
            CR.runit_x[ui] == x && CR.runit_y[ui] == y)
            return 1;
    }
    for (int v = 0; v < CS.n_villages; v++)
        if (CS.villages[v].map_x == x && CS.villages[v].map_y == y) return 1;
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation() &&
            CS.colonies[ci].map_x == x && CS.colonies[ci].map_y == y)
            return 1;
    return 0;
}
static void heading_score(int ui, int home_vi) {
    UnitRecord *u = &CS.units[ui];
    const NativeSettlement *home = &CS.villages[home_vi];
    int best = 8, best_score = -1;
    for (int cand = 0; cand <= 8; cand++) {
        int x = cand == 8 ? u->map_x : u->map_x + DIRS_DX[cand];
        int y = cand == 8 ? u->map_y : u->map_y + DIRS_DY[cand];
        if (x < 0 || y < 0 || x >= COLOPY_MAP_W || y >= COLOPY_MAP_H)
            continue;
        int t = tile_terrain(map_at(x, y));
        /* dest Ocean/Sea Lane/Arctic: reject @0x0473BB */
        if (t == TERR_OCEAN || t == TERR_SEALANE || t == 24) continue;
        if (cand != 8 && tile_occupied(ui, x, y)) continue;
        int s = 200;                                 /* base @0x0473A4 */
        int h = CR.native_heading[ui];
        if (cand != 8 && h < 8) {                    /* continuity */
            if (cand == h) s += 4;                   /* @0x047A79 */
            else if (((h + 1) & 7) == cand || ((h + 7) & 7) == cand)
                s += 3;                              /* @0x047A99 */
            else if ((h ^ 4) == cand) s -= 6;        /* @0x047AB0 */
        }
        /* the home-settlement leash @0x047AD0-0x047B39 */
        {
            int dx = x - home->map_x, dy = y - home->map_y;
            if (dx < 0) dx = -dx;
            if (dy < 0) dy = -dy;
            int d = dx > dy ? dx : dy;
            if (d > 2) s -= 3 * d;
        }
        s += 1 + R(5);                               /* jitter @0x047F44 */
        if (s < 0) s = 0;                            /* clamp @0x047F6E */
        if (s > best_score) { best_score = s; best = cand; }
    }
    if (best < 8) {
        u->map_x = (uint8_t)(u->map_x + DIRS_DX[best]);
        u->map_y = (uint8_t)(u->map_y + DIRS_DY[best]);
        CR.native_heading[ui] = (uint8_t)best;
    }
}

/* ---- the mover (nativeMoveAI, game.js:5861) ---------------------------- */
static void native_move_ai(void) {
    /* iterate in G.natives LIST order — the RNG draw order contract */
    for (int k = 0; k < CR.n_natives; k++) {
        int ui = CR.natives_order[k];
        int vi = CR.native_home[ui];
        if (vi < 0 || vi >= CS.n_villages) continue;
        UnitRecord *u = &CS.units[ui];
        int hostile = CR.alarm[vi] >= ALARM_RAID && player_colony_count();
        if (hostile) {
            /* the raid scorer picks the target; nearest colony to the
             * BRAVE as the fallback (stable sort [0] = first on tie) */
            int score, ci = raid_target_score(vi, &score);
            if (ci < 0) {
                int bd = 0;
                for (int k = 0; k < CS.n_colonies; k++) {
                    if ((CS.colonies[k].owner_power & 3) != cs_nation())
                        continue;
                    int dx = CS.colonies[k].map_x - u->map_x;
                    int dy = CS.colonies[k].map_y - u->map_y;
                    int d = (dx < 0 ? -dx : dx) + (dy < 0 ? -dy : dy);
                    if (ci < 0 || d < bd) { ci = k; bd = d; }
                }
            }
            const ColonyRecord *c = &CS.colonies[ci];
            int adx = c->map_x - u->map_x, ady = c->map_y - u->map_y;
            if (adx < 0) adx = -adx;
            if (ady < 0) ady = -ady;
            if ((adx > ady ? adx : ady) <= 1) {
                /* at the palisade: the raid fires, the party turns home */
                native_raid(vi, ci);
                const NativeSettlement *v = &CS.villages[vi];
                u->map_x = v->map_x;
                u->map_y = (uint8_t)(v->map_y + 1);
                if (tile_water(map_at(u->map_x, u->map_y))) {
                    u->map_x = (uint8_t)(v->map_x + 1);
                    u->map_y = v->map_y;
                }
                CR.native_heading[ui] = 0xFF;
                continue;
            }
            /* one straight-line step (goto-executor stand-in, flagged) */
            int bx = -1, by = -1, bd = 0;
            for (int s = 0; s < 8; s++) {
                int x = u->map_x + DIRS_DX[s], y = u->map_y + DIRS_DY[s];
                if (x < 0 || y < 0 || x >= COLOPY_MAP_W || y >= COLOPY_MAP_H)
                    continue;
                if (tile_water(map_at(x, y))) continue;
                int blocked = 0;
                for (int w = 0; w < CS.n_villages && !blocked; w++)
                    if (CS.villages[w].map_x == x && CS.villages[w].map_y == y)
                        blocked = 1;
                for (int qi = 0; qi < CS.n_units && !blocked; qi++) {
                    if (qi == ui) continue;
                    if ((is_brave(qi) || unit_on_map_player(qi)) &&
                        CS.units[qi].map_x == x && CS.units[qi].map_y == y)
                        blocked = 1;
                }
                for (int k = 0; k < CS.n_colonies && !blocked; k++)
                    if ((CS.colonies[k].owner_power & 3) == cs_nation() &&
                        CS.colonies[k].map_x == x && CS.colonies[k].map_y == y)
                        blocked = 1;
                if (blocked) continue;
                int dx = c->map_x - x, dy = c->map_y - y;
                int d = (dx < 0 ? -dx : dx) + (dy < 0 ? -dy : dy);
                if (bx < 0 || d < bd) { bx = x; by = y; bd = d; }
            }
            if (bx >= 0) { u->map_x = (uint8_t)bx; u->map_y = (uint8_t)by; }
            continue;
        }
        /* at peace: func_046FFA decides, including the stay candidate */
        heading_score(ui, vi);
    }
}

/* ---- pipeline step 3 --------------------------------------------------- */
void turn_step3(void) {
    native_tick();               step_rng("nativeTick");
    native_demands();            step_rng("nativeDemands");
    attempt_conversions();       step_rng("attemptConversions");
    age_converts();              step_rng("ageConverts");
    native_move_ai();            step_rng("nativeMoveAI");
    colony_vanish_filter();      /* raid-razed colonies leave (js:10777) */
}
