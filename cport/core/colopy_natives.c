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
 * The RAIDSTORES banking is the TRIBE-ARMING byte model (2026-08-29 —
 * the old "+0x08 raid budget / +0x0A wealth" gloss misread the tribe
 * pointer; see the case-1 payload).  The INDIANWAGONS claim can never
 * fire in either engine — the importer only ever seeds holds on SHIPS
 * (game.js:10463), so no Wagon Train carries cargo. */
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
/* The WAR COUNCIL of the per-tribe turn func_0485F6 @0x48632..@0x48759
 * (JS tribeWarCouncil; RULINGS 2026-09-03e): post-Declaration, once per
 * tribe (+0x03 bit 0x20), tension >= 25 draws random_int(1,400), the
 * GRUDGE bit 0x40 forces the flag, then random_int(0, 2*(5-diff)) == 0
 * -> @INDIANGRUDGE, +100 tension toward the player (the -100 toward
 * [0x53D2] is unmodeled, flagged), the player's missions on the tribe's
 * settlements are lost (func_045D00), muskets := min(n, m) * 4 (8-bit),
 * horses := min(n, h), herd := horses * 25, latch set. */
static void tribe_war_council(void) {
    if (!(CR.woi_flags & WOI_DECLARED)) return;
    for (int t = 0; t < 8; t++) {
        int tb = t * 0x4E;
        if (CR.tribe_dead[t] || (CS.tribes[tb + 3] & 0x20)) continue;
        int tension = CR.tension[t];
        int flag = 0;
        if (tension >= 25) flag = tension >= 1 + R(400) ? 1 : 0;
        if (CS.tribes[tb + 3] & 0x40) flag = 1;
        if (!flag) continue;
        if (R(2 * (5 - (int)cs_difficulty()) + 1) != 0) continue;
        ev_emit("INDIANGRUDGE", 0, 0, dat_tribes[t].name, dat_tribes[t].singular);
        adjust_tension(t, 100, 0);
        int count = 0;
        for (int v = 0; v < CS.n_villages; v++) {
            if (CS.villages[v].owner_tribe != t + 4) continue;
            count++;
            if (CS.villages[v].mission != 0xFF &&
                (CS.villages[v].mission & 0x0F) == cs_nation())
                CS.villages[v].mission = 0xFF;
        }
        int m = CR.tribe_muskets_known[t] < count ? CR.tribe_muskets_known[t] : count;
        CR.tribe_muskets_known[t] = (int16_t)((m * 4) & 0xFF);
        int h = CR.tribe_horses_known[t] < count ? CR.tribe_horses_known[t] : count;
        CR.tribe_horses_known[t] = (int16_t)h;
        CR.tribe_herd[t] = (int16_t)(h * 25);
        CS.tribes[tb + 3] |= 0x20;
    }
}
static void native_tick(void) {
    tribe_war_council();
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
        /* The claim CONTENT is the byte model of the native-meeting
         * demand handler (0x5755C..0x57A15, 2026-08-29); the trigger
         * cadence stays the flagged per-turn roll (mirrors game.js).
         * @INDIANGOLD is DEAD GAME.TXT content (zero EXE hits) — gone. */
        {
            /* the demanding village of this tribe near a colony/wagon */
            int dvi = -1;
            for (int v = 0; v < CS.n_villages && dvi < 0; v++) {
                if (CS.villages[v].owner_tribe != ti + 4) continue;
                for (int ci2 = 0; ci2 < CS.n_colonies && dvi < 0; ci2++) {
                    if ((CS.colonies[ci2].owner_power & 3) != cs_nation())
                        continue;
                    int dx = CS.villages[v].map_x - CS.colonies[ci2].map_x;
                    int dy = CS.villages[v].map_y - CS.colonies[ci2].map_y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx <= 3 && dy <= 3) dvi = v;
                }
            }
            /* @INDIANWAGONS (@0x5787E..): pressed slot by slot; a give
             * empties the slot, credits -bid*qty*4/100 and zeroes the
             * village alarm; a refusal spikes it +128 (@0x57A0B).
             * (Unreachable under the harness — no wagon carries a hold —
             * mirrored for live play.) */
            int wi = -1;
            for (int k = 0; k < CR.n_units_order && wi < 0; k++) {
                int ui = CR.units_order[k];
                if (strcmp(dat_units[CS.units[ui].type].name,
                           "Wagon Train") != 0) continue;
                int laden = 0;
                for (int hh = 0; hh < CR.unit_n_hold[ui]; hh++)
                    if (CR.unit_hold[ui][hh].qty > 0) laden = 1;
                if (!laden) continue;
                for (int v = 0; v < CS.n_villages && wi < 0; v++) {
                    if (CS.villages[v].owner_tribe != ti + 4) continue;
                    int dx = CS.villages[v].map_x - CS.units[ui].map_x;
                    int dy = CS.villages[v].map_y - CS.units[ui].map_y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx <= 3 && dy <= 3) wi = ui;
                }
            }
            if (wi >= 0) {
                for (;;) {
                    int slot = -1;
                    for (int hh = 0; hh < CR.unit_n_hold[wi] && slot < 0;
                         hh++)
                        if (CR.unit_hold[wi][hh].qty > 0) slot = hh;
                    if (slot < 0) break;
                    int good = CR.unit_hold[wi][slot].good;
                    int hq = CR.unit_hold[wi][slot].qty;
                    ev_emit("INDIANWAGONS", hq, 0, dat_tribes[ti].name,
                            dat_cargo[good].name);
                    if (ask_choice() == 0) {
                        adjust_tension(ti,
                            -((market_bid(good)) * hq * 4 / 100), 0);
                        if (dvi >= 0) {
                            CR.alarm[dvi] = 0;
                            CS.villages[dvi].alarm[cs_nation()] = 0;
                        }
                        hold_add(CR.unit_hold[wi], &CR.unit_n_hold[wi],
                                 good, -hq);
                    } else {
                        if (dvi >= 0) {
                            int a = CR.alarm[dvi] + 128;
                            CR.alarm[dvi] = (uint8_t)(a > 255 ? 255 : a);
                            CS.villages[dvi].alarm[cs_nation()] =
                                CR.alarm[dvi];
                        }
                        break;
                    }
                }
                return;
            }
            /* @INDIANCITY (@0x5755C..): argmax of value x min(100,stock),
             * value = bid level (horses -counter+10; muskets
             * +random_int(1,4)-tech+diff+4); nothing worth demanding ->
             * @INDIANCOMMENT + alarm clear; amount halves on
             * random_int(0,diff+1)==0. */
            int ci = -1;
            for (int v = 0; v < CS.n_villages && ci < 0; v++) {
                if (CS.villages[v].owner_tribe != ti + 4) continue;
                for (int c2 = 0; c2 < CS.n_colonies && ci < 0; c2++) {
                    if ((CS.colonies[c2].owner_power & 3) != cs_nation())
                        continue;
                    int dx = CS.villages[v].map_x - CS.colonies[c2].map_x;
                    int dy = CS.villages[v].map_y - CS.colonies[c2].map_y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx <= 3 && dy <= 3) ci = c2;
                }
            }
            if (ci < 0) ci = nth_player_colony(0);
            if (ci < 0) return;
            ColonyRecord *c = &CS.colonies[ci];
            int best_g = -1, best_score = 0, best_qty = 0;
            for (int g = 0; g < 16; g++) {
                int q = c->stock[g] > 100 ? 100 : c->stock[g];
                if (q < 0) q = 0;
                int val = market_bid(g);
                if (g == 8) val = val - CR.tribe_horses_known[ti] + 10;
                if (g == 15)
                    val += 1 + R(4) - tribe_level(ti) +
                           (int)cs_difficulty() + 4;
                int score = val * q;
                if (score > best_score) {
                    best_score = score;
                    best_g = g;
                    best_qty = q;
                }
            }
            if (best_g < 0) {
                if (dvi >= 0) {
                    CR.alarm[dvi] = 0;
                    CS.villages[dvi].alarm[cs_nation()] = 0;
                }
                ev_emit("INDIANCOMMENT", 0, 0, dat_tribes[ti].name, 0);
                return;
            }
            int take = best_qty;
            if (R((int)cs_difficulty() + 2) == 0) take >>= 1;
            ev_emit("INDIANCITY", take, 0, dat_tribes[ti].name,
                    dat_cargo[best_g].name);
            if (ask_choice() == 1) {
                if (dvi >= 0) {
                    CR.alarm[dvi] = 0;
                    CS.villages[dvi].alarm[cs_nation()] = 0;
                }
                int credit = -(best_score * 4 / 100);
                while ((int)CR.tension[ti] + credit > 70) credit -= 5;
                adjust_tension(ti, credit, 0);
                c->stock[best_g] = (uint16_t)(c->stock[best_g] - take);
                if (best_g == 15) CR.tribe_muskets_known[ti]++;
                if (best_g == 8) {
                    CR.tribe_herd[ti] = (int16_t)(CR.tribe_herd[ti] + 50);
                    CR.tribe_horses_known[ti]++;
                }
            } else if (dvi >= 0) {
                int a = CR.alarm[dvi] + 128;
                CR.alarm[dvi] = (uint8_t)(a > 255 ? 255 : a);
                CS.villages[dvi].alarm[cs_nation()] = CR.alarm[dvi];
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
        /* convert headroom: settled converts never age (the byte model),
         * so a mission-heavy game floods the pool without a bound.  Both
         * engines stop converting at 100 LIVING CONVERTS — a shared port
         * capacity limit, not a byte claim (the DOS pool is finite too,
         * size unread — FLAGGED).  The count is over the player's own
         * unit list, a digest-compared quantity, so the two engines
         * agree exactly; checked BEFORE the roll to keep the RNG stream
         * lockstep. */
        {
            int nconv = 0;
            for (int k = 0; k < CR.n_units_order; k++)
                if (CS.units[CR.units_order[k]].profession == JOB_CONVERT)
                    nconv++;
            if (nconv >= 100) continue;
        }
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
        if (ui >= 0)
            CS.units[ui].profession = (uint8_t)JOB_CONVERT;
        ev_emit("INDIANSCONVERT", 0, 0, CS.colonies[best].name, 0);
        /* TUTORIAL19 (bytes: the focus dispatcher's convert arm,
         * profession 0x1B, func_020F50 @0x0215EF..0x0215FA) */
        tut_once(19, 0, 0, 0, 0);
    }
}
/* @DEADCONVERTS — BYTE_VERIFIED func_02EF64 (0x191F:0xA58, read
 * 2026-08-29), replacing the unconditional 8-turn countdown: a CONVERT
 * unit (type 0 Colonists with profession 0x1B, @0x2EF99/@0x2EFA3) ticks
 * its +0x16 counter only while ON the map (@0x2EF86), NOT standing on a
 * settlement tile (village-or-colony lookup 0x181F:0x6BE -> func_005FD4,
 * improve bit 2, @0x2EFB5) and ALONE (his tile stack counts fewer than 2
 * via the chain walker func_0073A8 verb 2, @0x2EFC9) — an escorted or
 * parked convert keeps his faith.  Past 8 qualifying turns (@0x2EFDA,
 * the text's own "eight turns") he is eliminated (@0x2F00B) with
 * @DEADCONVERTS per convert.  The counter is the SAV's own +0x16
 * field (CR.unit_work), so the timer survives a save. */
static void age_converts(void) {
    nresolve();
    /* JS iterates G.UNITS backwards (game.js:5397) — a convert CAPTURED
     * by a rival left that list and never ages again; walk the order
     * list, not the record pool */
    for (int k = CR.n_units_order - 1; k >= 0; k--) {
        int ui = CR.units_order[k];
        const UnitRecord *u = &CS.units[ui];
        if (u->profession != JOB_CONVERT || u->type != TY_COLONISTS)
            continue;
        int settled = 0;
        for (int ci = 0; ci < CS.n_colonies && !settled; ci++)
            if (CS.colonies[ci].map_x == u->map_x &&
                CS.colonies[ci].map_y == u->map_y) settled = 1;
        for (int v = 0; v < CS.n_villages && !settled; v++)
            if (CS.villages[v].map_x == u->map_x &&
                CS.villages[v].map_y == u->map_y) settled = 1;
        if (settled) continue;
        int stack = 0;
        for (int q = 0; q < CR.n_units_order && stack < 2; q++) {
            int uj = CR.units_order[q];
            if (CS.units[uj].map_x == u->map_x &&
                CS.units[uj].map_y == u->map_y) stack++;
        }
        if (stack >= 2) continue;
        CR.unit_work[ui]++;
        if (CR.unit_work[ui] <= 8) continue;
        unit_remove(ui);            /* drops list slot k, re-bases */
        ev_emit("DEADCONVERTS", 0, 0, 0, 0);
    }
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

/* ---- one raid attempt: nativeRaid = func_05BE84, re-read whole
 * 2026-09-03 (RULINGS 2026-09-03c; the JS comment block carries the
 * per-site citations).  force = 0 here (the Braves-vs-Artillery forcing
 * lives in the combat resolver the port's arrival model skips); the
 * clock reseed @0x5BEED is not mirrored (RULINGS 2026-09-03b). ------- */
/* the raid chain table (ANCHOR: consecutive @BUILDING families, the Stable
 * and the Capitol their own roots — the WREAK payload has a Capitol case
 * @0x5C46A, so root(0x1E) != 9) */
static const int8_t RAID_CHAIN_FIRST[42] = {
    0, 0, 0, 3, 3, 3, 6, 6, 6, 9, 9, 9, 12, 12, 12, 15, 15, 17, 18, 19, 19,
    21, 21, 21, 24, 24, 24, 27, 27, 27, 30, 30, 32, 32, 32, 35, 35, 37, 37,
    39, 39, 39 };
static int raid_chain_next(int b) {
    return (b + 1 < 42 && RAID_CHAIN_FIRST[b + 1] == RAID_CHAIN_FIRST[b]) ? b + 1 : -1;
}
/* DS:0x2CA (file 0x1DC6A): the chain-root JOB per @BUILDING row, -1 none */
static const int8_t RAID_ROOT_JOB[42] = {
    21, 21, 21, 15, 15, 15, -1, -1, -1, 17, 17, 17, 18, 18, 18, -1, -1, -1,
    -1, -1, -1, 11, 11, 11, 10, 10, 10, 9, 9, 9, 17, 17, 12, 12, 12, 13, 13,
    16, 16, 14, 14, 14 };
/* has_building for the raid: the Warehouse/Capitol EXPANSIONS live in the
 * +0x95/+0x96 level bytes, never in the bitset — rows 16/31 test absent */
static int raid_has(int ci, int b) {
    if (b == 16 || b == 31) return 0;
    return colony_has_name(ci, dat_buildings[b].name);
}
/* [0x9410 + p] population census stand-in (units + colony population,
 * flagged — the same one news_tick uses) */
static int pop_census_player(void) {
    int n = CR.n_units_order;
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation())
            n += CS.colonies[ci].population;
    return n;
}
static void native_raid(int vi, int ci) {
    int tribe = CS.villages[vi].owner_tribe - 4;
    ColonyRecord *c = &CS.colonies[ci];
    int human = 1;
    /* gate: random_int(0,12) - 1 (+ difficulty - 2 for a human owner)
     * against K = 3 * (chain-0 tiers present) + 1 */
    int roll = R(13) - 1;
    if (human) roll += (int)cs_difficulty() - 2;
    int K = 3 * colony_level(ci) + 1;
    if (roll < K) return;                        /* force = 0 */
    /* @INDIANSURPRISE: a raid from a still-calm tribe (band < restless) */
    if (tribe >= 0 && tribe < 8 && tension_band(CR.tension[tribe]) < 2)
        ev_emit("INDIANSURPRISE", 0, 0, dat_tribes[tribe].name, c->name);
    int out = 1 + R(4);
    if ((int)cs_turn() < 40 * (2 - (int)cs_difficulty()) && cs_difficulty() <= 1 &&
        (out == 2 || out == 3)) out = 0;
    if (out == 2) {
        int k = human ? (int)cs_difficulty() : 1;
        if (R(9) > k + 2) out = 1;
        if (raid_has(ci, 1)) out = 1;            /* Fort */
    }
    if (out == 4 && raid_has(ci, 0)) out = 1;    /* Stockade */
    if (out == 3 && raid_has(ci, 2)) out = 0;    /* Fortress */
    if (out == 1 && raid_has(ci, 0) && R(9) > (int)cs_difficulty()) out = 0;
    int good = -1, bld = -1, ship = -1;
    int32_t take = 0;
    if (out == 1) {
        /* STORES picker @0x5C03E..@0x5C0C7 (+ the dead muskets draw) */
        int tries = 0;
        for (;;) {
            tries++;
            good = R(16);
            if (tribe >= 0 && tribe < 8 && CR.tribe_horses_known[tribe] == 0 &&
                tries == 1 && c->stock[good] > 52 && R(2) == 0) good = 8;
            if (good == 15) (void)rng_next();    /* random_int(0,200), unread */
            if (tries < 100 && c->stock[good] < 10) continue;
            break;
        }
        if (tries >= 100) out = 0;
    } else if (out == 2) {
        /* WREAK picker @0x5C0CA..@0x5C1A8 + the climb @0x5C214..@0x5C24F */
        int bipv = (int8_t)c->building_in_production;
        int bip = (bipv >= 0 && bipv < 42) ? RAID_CHAIN_FIRST[bipv] : -1;
        int tries = 0, valid = 1;
        for (;;) {
            valid = 1;
            tries++;
            bld = R(42);
            if (bld == 0x23) valid = 0;
            if (RAID_CHAIN_FIRST[bld] == 9) valid = 0;
            if (bip >= 0 && RAID_CHAIN_FIRST[bld] == bip) valid = 0;
            if (bld == 0x27 || bld == 0x15 || bld == 0x18 || bld == 0x1B ||
                bld == 0 || bld == 1 || bld == 2 || bld == 0x20) valid = 0;
            if (tries < 100 && (!raid_has(ci, bld) || !valid)) continue;
            break;
        }
        if (tries >= 100 || !valid) out = 0;
        else for (;;) {
            int nxt = raid_chain_next(bld);
            if (nxt >= 0 && raid_has(ci, nxt)) bld = nxt; else break;
        }
    } else if (out == 3) {
        /* SHIP @0x5C252: the tile stack's first ship (G.units order) */
        for (int k = 0; k < CR.n_units_order && ship < 0; k++) {
            int ui = CR.units_order[k];
            if (dat_units[CS.units[ui].type].hull > 0 &&
                CS.units[ui].map_x == c->map_x &&
                CS.units[ui].map_y == c->map_y) ship = ui;
        }
        if (ship < 0) out = 0;
    } else if (out == 4) {
        /* GOLD @0x5C29A..@0x5C31F */
        PowerRecord *p = &CS.powers[cs_nation()];
        int64_t mx = (int64_t)p->gold * c->population / (pop_census_player() + 1) + 10;
        if (mx > 0x7FFF) mx = 0x7FFF;
        take = 0x32 + floordiv((int)rng_next() * ((int)mx - 0x32 + 1), 32768);
        if (p->gold < take || take < 0x32) out = 0;
    }
    switch (out) {
    case 1: {                                        /* @RAIDSTORES */
        if (c->stock[good] <= 0) break;              /* @0x5C351: silent */
        int half = c->stock[good] >> 1;
        int lo = half < 10 ? half : 10;
        int qty = lo + R(half - lo + 1);
        if (qty > c->stock[good]) qty = c->stock[good];
        if (qty < 1) qty = 1;
        c->stock[good] = (uint16_t)(c->stock[good] - qty);
        ev_emit("RAIDSTORES", qty, 0, c->name, dat_cargo[good].name);
        if (tribe >= 0 && tribe < 8) {
            if (good == 8) {
                CR.tribe_horses_known[tribe]++;
                CR.tribe_herd[tribe] = (int16_t)(CR.tribe_herd[tribe] + 25);
            }
            if (good == 15)
                CR.tribe_muskets_known[tribe] =
                    (int16_t)(CR.tribe_muskets_known[tribe] + (qty >= 50 ? 2 : 1));
        }
        adjust_tension(tribe, -4, 0);        /* push -4 @0x5C416 (war bit unmodeled) */
        break;
    }
    case 2: {                                        /* @RAIDBURN (WREAK) */
        const char *name = dat_buildings[bld].name;
        if (bld == 15) {
            if (colony_has_name(ci, "Warehouse Expansion")) {
                colony_bld_remove_name(ci, "Warehouse Expansion");
                name = "Warehouse Expansion";
            } else colony_bld_remove_name(ci, "Warehouse");
        } else if (bld == 30) {
            name = "Capitol Expansion";              /* always (@0x5C486) */
            if (colony_has_name(ci, "Capitol Expansion"))
                colony_bld_remove_name(ci, "Capitol Expansion");
            else colony_bld_remove_name(ci, "Capitol");
        } else {
            if (RAID_CHAIN_FIRST[bld] == bld) {
                /* func_009818: n = colonists working the root's job; every
                 * colonist whose OCCUPATION == n becomes a Carpenter
                 * (@0x5C4B6..@0x5C4E1 — the compare is against the
                 * count; ported literally, mirrors the JS) */
                int job = RAID_ROOT_JOB[bld], n = 0;
                if (job >= 0)
                    for (int k = 0; k < c->population && k < 32; k++)
                        if (c->occupation[k] == job) n++;
                for (int k = 0; k < c->population && k < 32; k++)
                    if (c->occupation[k] == n) {
                        c->occupation[k] = 13;
                        for (int w = 0; w < 8; w++)      /* p.cell = null */
                            if ((uint8_t)c->tiles[w] == k) c->tiles[w] = -1;
                    }
            }
            colony_bld_remove_name(ci, name);
        }
        ev_emit("RAIDBURN", 0, 0, c->name, name);
        adjust_tension(tribe, -12, 0);               /* push -0xC @0x5C52E */
        break;
    }
    case 3:                                          /* @RAIDSHIP */
        CR.unit_damaged[ship] = 1;                   /* func_05B2C2 stand-in */
        ev_emit("RAIDSHIP", 0, 0, c->name, dat_units[CS.units[ship].type].name);
        adjust_tension(tribe, -16, 0);               /* push -0x10 @0x5C5BC */
        break;
    case 4:                                          /* @RAIDGOLD */
        CS.powers[cs_nation()].gold -= take;
        ev_emit("RAIDGOLD", take, 0, c->name, 0);
        adjust_tension(tribe, -8, 0);                /* push -8 @0x5C617 */
        break;
    default:
        ev_emit("RAIDNOTHING", 0, 0, 0, 0);          /* @RAIDNOTHING */
        break;
    }
    /* @0x5C642: the home settlement's alarm word toward the owner := 0 */
    CR.alarm[vi] = 0;
    CS.villages[vi].alarm[cs_nation()] = 0;
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

/* func_008262 (0x181f:0xa60): tension <25 -> 0, <50 -> 1, <75 -> 2, else 3 */
static int tension_band4(int tension) {
    return tension >= 75 ? 3 : tension >= 50 ? 2 : tension >= 25 ? 1 : 0;
}

/* ---- the idle mover (headingScore, game.js / func_046FFA) ---------------
 * The engine's ring DS:0xB4/0xBE (N, E, S, W, NW, NE, SE, SW) -- the
 * candidate order is the tie-break order.  The 2026-09-03 terms (the +4
 * pair, the +5 unclaimed, the war block, the besieger, the rumour skip)
 * carry the JS comment block's citations; the flags there apply here. */
static const int8_t HS_DX[8] = { 0, 1, 0, -1, -1, 1, 1, -1 };
static const int8_t HS_DY[8] = { -1, 0, 1, 0, -1, -1, 1, 1 };
/* func_004900 (0x181F:0x370): max(|dx|,|dy|) + (min >> 1) */
static int engine_dist(int dx, int dy) {
    int a = dx < 0 ? -dx : dx, b = dy < 0 ? -dy : dy;
    return b < a ? (b >> 1) + a : (a >> 1) + b;
}
/* func_00624E: 0x1B Mountains / 0x1C Hills for a relief tile, else id */
static int terrain_class(uint8_t v) {
    if (v & 0x20) return (v & 0x80) ? 0x1B : 0x1C;
    return v & 0x1F;
}
static int occupied_by_unit(int self, int x, int y) {
    for (int ui = 0; ui < CS.n_units; ui++) {
        if (ui == self) continue;
        const UnitRecord *u = &CS.units[ui];
        if (is_brave(ui) && u->map_x == x && u->map_y == y) return 1;
        if (unit_on_map_player(ui) && u->map_x == x && u->map_y == y) return 1;
        int own = u->owner_flags & 0x0F;
        if (own < 4 && own != cs_nation() && u->type < DAT_UNITS_COUNT &&
            !CR.unit_in_natives[ui] &&
            CR.runit_x[ui] == x && CR.runit_y[ui] == y)
            return 1;
    }
    return 0;
}
static int player_colony_idx(int x, int y) {
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation() &&
            CS.colonies[ci].map_x == x && CS.colonies[ci].map_y == y) return ci;
    return -1;
}
/* JS settlementOwner: player colony -> nation, rival colony (the CR stub
 * list) -> its nation, village -> tribe + 4, else -1 */
static int settlement_owner(int x, int y) {
    if (player_colony_idx(x, y) >= 0) return cs_nation();
    for (int rn = 0; rn < 4; rn++) {
        if (rn == (int)cs_nation()) continue;
        const rival_rt *r = &CR.rivals[rn];
        for (int k = 0; k < r->n_col; k++)
            if (r->col[k].x == x && r->col[k].y == y) return rn;
    }
    for (int v = 0; v < CS.n_villages; v++)
        if (CS.villages[v].map_x == x && CS.villages[v].map_y == y)
            return CS.villages[v].owner_tribe;
    return -1;
}
/* the besieger ring count: armed (attack > 1, non-ship) player + rival
 * units on (x,y), minus the colony's size >> 2 (JS order: G.units, then
 * rivals in nation order) */
static int armed_stack(int x, int y) {
    int n = 0;
    for (int q = 0; q < CR.n_units_order; q++) {
        const UnitRecord *u = &CS.units[CR.units_order[q]];
        if (u->map_x == x && u->map_y == y && dat_units[u->type].hull <= 0 &&
            dat_units[u->type].attack > 1) n++;
    }
    for (int rn = 0; rn < 4; rn++) {
        if (rn == (int)cs_nation()) continue;
        for (int k = 0; k < CR.n_runits[rn]; k++) {
            int ui = CR.runits_order[rn][k];
            const UnitRecord *u = &CS.units[ui];
            if (CR.runit_x[ui] == x && CR.runit_y[ui] == y &&
                u->type < DAT_UNITS_COUNT && dat_units[u->type].hull <= 0 &&
                dat_units[u->type].attack > 1) n++;
        }
    }
    return n;
}
static void heading_score(int ui, int home_vi) {
    UnitRecord *u = &CS.units[ui];
    const NativeSettlement *home = &CS.villages[home_vi];
    int tr2 = (u->owner_flags & 0x0F) - 4;
    int tension = (tr2 >= 0 && tr2 < 8) ? CR.tension[tr2] : 0;
    int own = (u->owner_flags & 0x0F);                       /* [bp-0x94] */
    int war_mode = tension >= 75 || CR.alarm[home_vi] >= 0x80;
    /* [bp-0x4C]: the besieger of the home settlement */
    int besieger = -1, total = 0;
    for (int i = 0; i < 8; i++) {
        int x = home->map_x + HS_DX[i], y = home->map_y + HS_DY[i];
        if (x < 0 || y < 0 || x >= COLOPY_MAP_W || y >= COLOPY_MAP_H) continue;
        int owner = CS.region[y * COLOPY_MAP_W + x] >> 4;
        if (owner == 0x0F || owner >= 4) continue;
        if (tile_water(map_at(x, y))) continue;
        int n = armed_stack(x, y);
        if (n <= 0) continue;
        int pci = player_colony_idx(x, y);
        if (pci >= 0) n -= CS.colonies[pci].population >> 2;
        else {
            for (int rn = 0; rn < 4; rn++) {
                if (rn == (int)cs_nation()) continue;
                const rival_rt *r = &CR.rivals[rn];
                for (int k = 0; k < r->n_col; k++)
                    if (r->col[k].x == x && r->col[k].y == y) { n -= r->col[k].pop >> 2; rn = 4; break; }
            }
        }
        if (n > 0) { total += n; besieger = owner; }
    }
    if (total < 2) besieger = -1;
    int unit_road = CS.improve[u->map_y * COLOPY_MAP_W + u->map_x] & 0x0A;
    int unit_river = map_at(u->map_x, u->map_y) & 0x40;
    int leash_home = (CS.region[home->map_y * COLOPY_MAP_W + home->map_x] & 0x0F) ==
                     (CS.region[u->map_y * COLOPY_MAP_W + u->map_x] & 0x0F);
    int best = 8, best_score = -1, best_colony = -1;
    int alarmed = 0;                 /* [bp-0x14] survives an owner >= 4 */
    for (int cand = 0; cand <= 8; cand++) {
        int x = cand == 8 ? u->map_x : u->map_x + HS_DX[cand];
        int y = cand == 8 ? u->map_y : u->map_y + HS_DY[cand];
        if (x < 0 || y < 0 || x >= COLOPY_MAP_W || y >= COLOPY_MAP_H)
            continue;
        uint8_t tv = map_at(x, y);
        int tc = terrain_class(tv);
        if (tc == 0x19 || tc == 0x1A) continue;
        if (rumour_at(x, y)) continue;
        if (tc == 0x18) continue;
        int idx = y * COLOPY_MAP_W + x;
        int owner = (CS.region[idx] >> 4) == 0x0F ? -1 : (CS.region[idx] >> 4);
        int s_owner = settlement_owner(x, y);
        int prime = map_detail_id(x, y, tv) >= 0;
        int tense = 0;
        if (owner < 0 || owner == own) { tense = 0; alarmed = 0; }
        else if (owner >= 4) { tense = 0; }
        else {
            int al = owner == (int)cs_nation() ? CR.alarm[home_vi] : 0;
            alarmed = al >= 0x80 ? 1 : 0;
            tense = (owner == (int)cs_nation() && tension >= 75) ? 1 : 0;
            if (tense) alarmed = 1;
            if (owner == besieger) alarmed = 1;
        }
        int hostile = alarmed || tense;
        int pc = player_colony_idx(x, y);
        int colony_pick = -1;
        if (cand != 8) {
            if (occupied_by_unit(ui, x, y)) continue;
            if (s_owner >= 4 || (s_owner >= 0 && s_owner != (int)cs_nation()))
                continue;
            if (pc >= 0 && !(war_mode && hostile)) continue;
            if (pc >= 0) colony_pick = pc;
        }
        int s = 200;                                 /* base @0x0473A4 */
        int h = CR.native_heading[ui];
        if (cand != 8 && h < 8) {                    /* continuity */
            if (cand == h) s += 4;                   /* @0x047A79 */
            else if (((h + 1) & 7) == cand || ((h + 7) & 7) == cand)
                s += 3;                              /* @0x047A99 */
            else if ((h ^ 4) == cand) s -= 6;        /* @0x047AB0 */
        }
        if ((CS.improve[idx] & 0x0A) && unit_road) s += 4;
        else if (!(cand & 1) && (tv & 0x40) && unit_river) s += 4;
        if (leash_home) {
            /* the leash @0x47ACA..@0x47B39: the 0x370 metric, > 2 costs
             * 3*d, halved on a war footing (@0x47B05), armed / mounted
             * halvings; only on the unit tile's landmass (@0x4718B) */
            int d = engine_dist(x - home->map_x, y - home->map_y);
            if (d > 2) {
                int pen = 3 * d;
                if (war_mode) pen >>= 1;
                const char *tn = dat_units[u->type].name;
                int armed = strcmp(tn, "Armed Braves") == 0 ||
                            strcmp(tn, "Mtd. Warriors") == 0;
                int mounted = strcmp(tn, "Mtd. Braves") == 0 ||
                              strcmp(tn, "Mtd. Warriors") == 0;
                if (armed) pen >>= 1;
                if (mounted) pen >>= 2;
                s -= pen;
            }
        }
        /* the FRONTIER term (@0x47B3C..@0x47C96; player pieces only) */
        {
            int foreign_tribe = 0, euro = 0;
            for (int nd = 0; nd < 8; nd++) {
                int nx = x + HS_DX[nd], ny = y + HS_DY[nd];
                for (int q = 0; q < CR.n_natives && !foreign_tribe; q++) {
                    int qi = CR.natives_order[q];
                    if (qi == ui) continue;
                    if (((CS.units[qi].owner_flags & 0x0F) - 4) != tr2 &&
                        CS.units[qi].map_x == nx && CS.units[qi].map_y == ny)
                        foreign_tribe = 1;
                }
                for (int q = 0; q < CR.n_units_order && !euro; q++) {
                    int qi = CR.units_order[q];
                    if (CS.units[qi].map_x == nx && CS.units[qi].map_y == ny)
                        euro = 1;
                }
                for (int ci = 0; ci < CS.n_colonies && !euro; ci++)
                    if ((CS.colonies[ci].owner_power & 3) == cs_nation() &&
                        CS.colonies[ci].map_x == nx &&
                        CS.colonies[ci].map_y == ny) euro = 1;
            }
            if (euro) {
                s += 50;
                if (tension_band4(tension) > 0) s += (tension - 50) >> 2;
            } else if (foreign_tribe) s -= 25;
        }
        if (!war_mode) {
            if (owner < 0) s += 5;                   /* @0x47CA4 */
            int best_d = 99;
            for (int ci = 0; ci < CS.n_colonies; ci++) {
                if ((CS.colonies[ci].owner_power & 3) != cs_nation())
                    continue;
                int dx = x - CS.colonies[ci].map_x;
                int dy = y - CS.colonies[ci].map_y;
                if (dx < 0) dx = -dx;
                if (dy < 0) dy = -dy;
                int d2 = dx > dy ? dx : dy;
                if (d2 < best_d) best_d = d2;
            }
            if (best_d < 12)
                s += ((tension_band4(tension) + 1) * (12 - best_d)) >> 2;
        } else if (hostile) {
            s += 5;                                  /* @0x47D57 */
            if (prime) s += 10;                      /* @0x47D61 */
            if (colony_pick >= 0) s += 500;          /* @0x47D84 */
        } else if (s_owner >= 0) continue;           /* @0x47E78 */
        s += 1 + R(5);                               /* jitter @0x047F44 */
        if (s < 0) s = 0;                            /* clamp @0x047F6E */
        if (s > best_score) { best_score = s; best = cand; best_colony = colony_pick; }
    }
    if (best < 8) {
        if (best_colony >= 0) {
            native_raid(home_vi, best_colony);   /* the attack, as the raid */
            CR.native_heading[ui] = (uint8_t)best;
            return;
        }
        u->map_x = (uint8_t)(u->map_x + HS_DX[best]);
        u->map_y = (uint8_t)(u->map_y + HS_DY[best]);
        CR.native_heading[ui] = (uint8_t)best;
    }
}

/* ---- the mover (nativeMoveAI) ---------------------------------------- */
static void native_move_ai(void) {
    /* iterate in G.natives LIST order — the RNG draw order contract */
    for (int k = 0; k < CR.n_natives; k++) {
        int ui = CR.natives_order[k];
        int vi = CR.native_home[ui];
        if (vi < 0 || vi >= CS.n_villages) continue;
        heading_score(ui, vi);       /* func_046FFA, war footing included */
    }
}

/* the raid-ladder parity probe (tools/sim_compare.py raid): one raid by
 * village vi on player colony ci, straight into the ladder */
void natives_raid_probe(int vi, int ci) {
    nresolve();
    native_raid(vi, ci);
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
