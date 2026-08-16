/* The village layer — Phase 5 slice 4b.  Ports enterVillage (game.js:
 * 6430), villageActions (6466), runVillageAction (6494) and the non-trade
 * @ACTIONS handlers over the records + CR runtime:
 *   establishMission (5318, the byte-verified expert bit @0x48C81 and the
 *   land-at-70 tension clamp @0x571DA), denounceHeresy (5342, fair-coin
 *   FLAGGED), liveAmong (5978, the training gates + the 200*diff+100
 *   slow-learner roll), speakToChief (6026, func_04A7CA's byte-read
 *   ladder), inciteIndians (6085, FLAGGED pricing), demandTribute (6133,
 *   func_04AC00's 10-unit ceiling + the strength contest), attackVillage
 *   (6198, §19.10 pop-counter + the byte-verified raze payout), with
 *   villageDemand/villageSurplus (5189/5269 — the CACHE is part of the
 *   parity contract: forest clears can change the map after it fills)
 *   and removeVillage (6183, the n/(n+1) herd scaling + @EXTINCT).
 * The trade rows (0/1: openVillageTrade's haggle) are slice 4c — the
 * scripted harness remaps them to Cancel on both sides.
 *
 * Headless screen semantics (the woodcut wrapper dismisses at once):
 * every entry ends back on the map, and the @INDIANWELCOME first-contact
 * ask NEVER fires headless — its woodcut after-callback is only run by a
 * live dismissal, which the trace does not model.  t.met still latches. */
#include <stdio.h>
#include <string.h>

#include "colopy_sim.h"
#include "../data/colopy_data.h"

#define TENSION_HOSTILE 75
#define MISSION_ANGER_CAP 0x46           /* 70 */
#define TRIBUTE_UNITS 10

enum { VF_GREETED = 1, VF_TAUGHT = 2, VF_TRIBUTE = 4, VF_CHIEF = 8 };

static int R(int n) { return (int)((rng_next() * (uint32_t)n) >> 15); }
static int vtribe(int vi) { return (CS.villages[vi].owner_tribe & 0x0F) - 4; }
static int urow(const char *name) {
    for (int i = 0; i < DAT_UNITS_COUNT; i++)
        if (strcmp(dat_units[i].name, name) == 0) return i;
    return -1;
}
static int jxrow(const char *name) {
    for (int i = 1; i < DAT_JOBEXPERT_COUNT; i++)
        if (strcmp(dat_jobexpert[i], name) == 0) return i;
    return -1;
}
static int prof_named(int ui, const char *name) {
    uint8_t p = CS.units[ui].profession;
    return p >= 1 && p < DAT_JOBEXPERT_COUNT &&
           strcmp(dat_jobexpert[p], name) == 0;
}

/* villageDemand (game.js:5189): the 5x5 yield census, capital-scaled,
 * CACHED on first call. */
static const int16_t *village_demand(int vi) {
    if (CR.village_demand_set[vi]) return CR.village_demand[vi];
    int16_t *d = CR.village_demand[vi];
    memset(d, 0, 16 * sizeof(int16_t));
    const NativeSettlement *v = &CS.villages[vi];
    for (int dy = -2; dy <= 2; dy++)
        for (int dx = -2; dx <= 2; dx++) {
            uint8_t tv = map_at(v->map_x + dx, v->map_y + dy);
            if (tile_water(tv)) continue;
            for (int j = 0; j < 9; j++) d[j] = (int16_t)(d[j] + tile_yield(tv, j));
        }
    int capital = tribe_level(vtribe(vi)) >= 2;  /* v.level = the TRIBE's */
    for (int g = 0; g <= 7; g++)
        if (capital) d[g] = (int16_t)(d[g] * 2);
    for (int g = 13; g <= 15; g++)
        d[g] = (int16_t)(capital ? (d[g] + 4) * 3 / 2 : d[g] + 4);
    for (int gi = 9; gi <= 12; gi++) {           /* MANUFACTURES floor */
        int floor_v = capital ? 8 : 4;
        if (d[gi] < floor_v) d[gi] = (int16_t)floor_v;
    }
    CR.village_demand_set[vi] = 1;
    return d;
}

/* villageSurplus (game.js:5269): first raw good with qty >= 25. */
static int village_surplus_good(int vi) {
    const int16_t *d = village_demand(vi);
    for (int g = 0; g <= 7; g++) {
        int qty = d[g] * 5;
        if (qty > 100) qty = 100;
        if (qty >= 25) return g;
    }
    return 4;                                    /* Furs by default */
}

/* enterVillage (game.js:6430).  The visitor's movesLeft was already spent
 * by moveSel; ships never reach this branch there. */
void village_enter(int vi, int ui) {
    int tr = vtribe(vi);
    if (tr < 0 || tr >= 8) return;
    /* the once-per-village greeting, second village of a met tribe on */
    if (!(CR.village_flags[vi] & VF_GREETED) && CR.tribe_met[tr]) {
        CR.village_flags[vi] |= VF_GREETED;
        ev_emit(CR.tension[tr] < 40 ? "INDIANHELLO1" : "INDIANHELLO2",
                0, 0, dat_tribes[tr].name, 0);
    }
    CR.cur_village = (int8_t)vi;
    CR.cur_visitor = (int16_t)ui;
    /* the screen outcome (enterVillage tail, game.js:6459) under the
     * SHARED trace conventions: the woodcutOnce stub (sim_trace.py
     * TURNS/INPUT blocks) dismisses to the map after EVERY call —
     * fired or not — so a village entry always lands back on the map
     * with G.village still set, and the after-callback (@INDIANWELCOME)
     * never runs.  Only the latches survive: first tribe contact takes
     * the per-tribe plate bit (Inca 5 / Aztec 4 / else 3, @0x56D95);
     * a met tribe's entry latches the once-per-game ENTERING INDIAN
     * VILLAGE bit 7 (the plate path skips it — the stub's forced 'map'
     * fails enterVillage's screen check).  The REAL game's staying
     * village screen (woodcutOnce(7) already latched) is the Teensy
     * loop's concern; under the harness CR.village_screen never
     * latches. */
    if (!CR.tribe_met[tr]) {
        CR.tribe_met[tr] = 1;
        int wc = tr == 0 ? 5 : tr == 1 ? 4 : 3;
        int fresh = !(CR.wc_seen & (1u << wc));
        CR.wc_seen |= (uint16_t)(1u << wc);
        /* LIVE front: the plate shows, and its dismissal runs the
         * @INDIANWELCOME chain (firstTribeContact, game.js:1222) —
         * a SEEN plate skips both, exactly the woodcutOnce(false)
         * early-out (1207: the callback never runs) */
        if (colopy_front_live && fresh) {
            CR.wc_show = (int8_t)wc;
            CR.wc_after = 1;
        }
    } else {
        int fresh = !(CR.wc_seen & (1u << 7));
        CR.wc_seen |= 1u << 7;
        if (colopy_front_live && fresh) {
            CR.wc_show = 7;
            CR.wc_after = 2;
        }
    }
    /* the harness stub forces the map (sim_trace conventions); the LIVE
     * front keeps the village open like the real enterVillage (6455) */
    CR.village_screen = (uint8_t)(colopy_front_live ? 1 : 0);
    CR.screen_map = (uint8_t)(colopy_front_live ? 0 : 1);
}

/* firstTribeContact's plate-dismissal callback (game.js:1222-1241): the
 * @INDIANWELCOME treaty ask — row 0 takes the treaty, anything else is
 * the shun: tension +100 (straight to the war band) + @INDIANSHUN. */
void village_first_welcome(void) {
    int vi = CR.cur_village;
    if (vi < 0) return;
    int tr = vtribe(vi);
    if (tr < 0 || tr >= 8) return;
    int count = 0;
    for (int w = 0; w < CS.n_villages; w++)
        if (vtribe(w) == tr) count++;
    static char lvl[24];
    snprintf(lvl, sizeof(lvl), "%ss",
             dat_levelname[dat_tribes[tr].level]);
    ev_emit("INDIANWELCOME", count, 0, dat_tribes[tr].name, lvl);
    if (ask_choice() == 0) {
        CR.tribe_treaty[tr] = 1;
        return;
    }
    adjust_tension(tr, 100, 0);
    ev_emit("INDIANSHUN", 0, 0, dat_nations[cs_nation()].country, 0);
}

/* villageActions (game.js:6466) over the OPEN village. */
int village_action_rows(uint8_t *ids) {
    int vi = CR.cur_village, ui = CR.cur_visitor;
    if (vi < 0) return 0;
    const NativeSettlement *v = &CS.villages[vi];
    int tr = vtribe(vi);
    int hostile = CR.tension[tr] >= TENSION_HOSTILE;
    int has_mission = v->mission != 0xFF;
    int mine = has_mission && (v->mission & 0x0F) == cs_nation();
    int miss_row = urow("Missionaries"), scout_row = urow("Scouts");
    int is_ship = dat_units[CS.units[ui].type].hull > 0;
    int n = 0;
    ids[n++] = (uint8_t)(hostile ? 1 : 0);
    if (CS.units[ui].type == miss_row && !has_mission) ids[n++] = 2;
    if (has_mission && !mine) ids[n++] = 3;
    if (!hostile && CS.units[ui].type != scout_row) ids[n++] = 4;
    if (CS.units[ui].type == scout_row) ids[n++] = 5;
    ids[n++] = 6;
    if (!is_ship) ids[n++] = 7;
    ids[n++] = 8;
    ids[n++] = 9;
    return n;
}

/* establishMission (game.js:5318). */
static void establish_mission(int vi, int ui) {
    NativeSettlement *v = &CS.villages[vi];
    int tr = vtribe(vi);
    int n = CR.tension[tr];
    int band = n >= TENSION_HOSTILE ? 3 : n >= 40 ? 2 : n >= 20 ? 1 : 0;
    v->mission = (uint8_t)(cs_nation() |
        (father_owned(father_by_name("Jean de Brebeuf")) ? 0x10 : 0));
    if (CR.tension[tr] > MISSION_ANGER_CAP)
        adjust_tension(tr, MISSION_ANGER_CAP - CR.tension[tr], 0);
    unit_remove(ui);                 /* the missionary is spent */
    char key[12];
    key[0] = 'M'; key[1] = 'I'; key[2] = 'S'; key[3] = 'S';
    key[4] = 'I'; key[5] = 'O'; key[6] = 'N';
    key[7] = (char)('0' + band); key[8] = 0;
    ev_emit(key, cs_year(), 0, dat_tribes[tr].name, 0);
}

/* denounceHeresy (game.js:5342): a fair coin (FLAGGED like the JS). */
static void denounce_heresy(int vi, int ui) {
    NativeSettlement *v = &CS.villages[vi];
    int tr = vtribe(vi);
    int win = rng_next() <= 16383;               /* < 0.5 */
    unit_remove(ui);
    if (win)
        v->mission = (uint8_t)(cs_nation() |
            (father_owned(father_by_name("Jean de Brebeuf")) ? 0x10 : 0));
    ev_emit(win ? "HERESY0" : "HERESY1", 0, 0, dat_tribes[tr].name, 0);
}

/* liveAmong (game.js:5978): villageSkill = OUTDOOR_JOBS[(x*7+y*13)%8]. */
static const uint8_t OUTDOOR_JOBS[8] = { 0, 1, 2, 3, 4, 7, 8, 22 };
static void live_among(int vi, int ui) {
    const NativeSettlement *v = &CS.villages[vi];
    int tr = vtribe(vi);
    int job = OUTDOOR_JOBS[(v->map_x * 7 + v->map_y * 13) % 8];
    if (CR.tension[tr] >= TENSION_HOSTILE) {
        ev_emit("LEARNMAD", 0, 0, dat_tribes[tr].name, 0);
        return;
    }
    if (prof_named(ui, "Petty Criminals")) {
        ev_emit("LEARNCRIMINAL", 0, 0, 0, 0);
        return;
    }
    if (prof_named(ui, "Indian Converts")) {
        ev_emit("TEACHCONVERT", 0, 0, 0, 0);
        return;
    }
    uint8_t p = CS.units[ui].profession;
    int has_prof = p >= 1 && p < DAT_JOBEXPERT_COUNT;
    if (has_prof && !prof_named(ui, "Free Colonists") &&
        !prof_named(ui, "Indentured Servants")) {
        ev_emit("LEARNMASTER", 0, 0, 0, 0);
        return;
    }
    if (CR.village_flags[vi] & VF_TAUGHT) {
        ev_emit("LEARNALREADY", 0, 0, 0, 0);
        return;
    }
    ev_emit("LEARNSTAY", 0, 0, dat_tribes[tr].name, 0);
    if (ask_choice() != 0) { ev_emit("LEARNLATER", 0, 0, 0, 0); return; }
    if (1 + R(1000) < 200 * cs_difficulty() + 100) {
        ev_emit("LEARNSLOW", 0, 0, 0, 0);        /* may retry */
        return;
    }
    CR.village_flags[vi] |= VF_TAUGHT;
    CS.units[ui].profession = (uint8_t)job;      /* @JOB row == expert row */
    ev_emit("LEARNDONE", 0, 0, 0, 0);
}

/* speakToChief (game.js:6026) — func_04A7CA's byte-read ladder. */
static void speak_to_chief(int vi, int ui) {
    const NativeSettlement *v = &CS.villages[vi];
    int tr = vtribe(vi);
    int seasoned = prof_named(ui, "Seasoned Scouts") ? 1 : 0;
    int ten = CR.tension[tr];
    int roll = R(101 + 40 * seasoned);
    if (ten >= TENSION_HOSTILE) {
        unit_remove(ui);
        ev_emit("CHIEFKILL", 0, 0, dat_tribes[tr].name, 0);
        return;
    }
    if (ten >= 25 && roll <= (ten >> 2)) {
        unit_remove(ui);
        ev_emit("CHIEFKILL", 0, 0, dat_tribes[tr].name, 0);
        return;
    }
    if (tr == 2 && R((((8 - cs_difficulty()) << seasoned) + 1)) == 0) {
        unit_remove(ui);                         /* the Aztec extra */
        ev_emit("CHIEFKILL", 0, 0, dat_tribes[tr].name, 0);
        return;
    }
    village_demand(vi);              /* CHIEFHOWDY fills the cache (subs) */
    ev_emit("CHIEFHOWDY", 0, 0, dat_tribes[tr].name, 0);
    if (roll <= ten) { ev_emit("CHIEFBORED", 0, 0, 0, 0); return; }
    if (CR.village_flags[vi] & VF_CHIEF) {
        ev_emit("CHIEFBORED", 0, 0, 0, 0);
        return;
    }
    CR.village_flags[vi] |= VF_CHIEF;
    int arm = 1 + R(3);
    if (arm == 1 && seasoned) arm = 2;
    if (arm == 1) {
        CS.units[ui].profession = (uint8_t)jxrow("Seasoned Scouts");
        ev_emit("CHIEFGUIDES", 0, 0, 0, 0);
    } else if (arm == 2) {
        ev_emit("CHIEFAREA", 0, 0, 0, 0);        /* the reveal is fog-side */
    } else {
        int n = 10 - cs_difficulty();
        int gold = (1 + R(6)) *
                   ((1 + R(n)) + (1 + R(n)) + (1 + R(n))) * 4 *
                   (tribe_level(tr) + 1);        /* v.level = tribe level */
        CS.powers[cs_nation()].gold += gold;
        ev_emit("CHIEFGIFT", gold, 0, 0, 0);
    }
    (void)v;
}

/* inciteIndians (game.js:6085) + incitePrice (6078, FLAGGED pricing). */
static void incite_indians(int vi, int ui) {
    int tr = vtribe(vi);
    int mets[3], nm = 0;
    for (int rn = 0; rn < 4; rn++)
        if (rn != (int)cs_nation() && CR.rivals[rn].met) mets[nm++] = rn;
    if (!nm) return;                             /* notice() only */
    int target;
    if (nm > 1) {
        ev_emit("INDIANWARPATH", 0, 0, dat_tribes[tr].name, 0);
        int k = ask_choice();
        if (k < 0 || k >= nm) return;
        target = mets[k];
    } else target = mets[0];
    int missions = 0;
    for (int w = 0; w < CS.n_villages; w++)
        if (vtribe(w) == tr && CS.villages[w].mission != 0xFF &&
            (CS.villages[w].mission & 0x0F) == cs_nation()) missions++;
    int32_t base = 1000 + 20 * CR.tension[tr] - 100 * missions;
    int32_t price = (base >= 0 ? base / 100 : -((-base + 99) / 100)) * 100 +
                    100 * target;                /* floor(base/100)*100 */
    if (price < 100) price = 100;
    ev_emit("INDIANWARPATH2", price, 0, dat_nations[target].adjective, 0);
    if (ask_choice() != 0) return;
    PowerRecord *p = &CS.powers[cs_nation()];
    if (p->gold < price) { ev_emit("NOTENOUGH", p->gold, 0, 0, 0); return; }
    p->gold -= price;
    CR.tribe_war_with[tr] = (int8_t)target;
    ev_emit("INDIANWARFARE", 0, 0, dat_tribes[tr].name,
            dat_nations[target].adjective);
    (void)ui;
}

/* militaryScore (game.js:6128): G.units land combat, x1.5 Spain/Cortes. */
static int military_score(void) {
    int s = 0;
    for (int k = 0; k < CR.n_units_order; k++) {
        int ui = CR.units_order[k];
        if (dat_units[CS.units[ui].type].hull > 0) continue;
        s += dat_units[CS.units[ui].type].combat;
    }
    if (cs_nation() == 2 || father_owned(father_by_name("Hernan Cortes")))
        s = s * 3 / 2;
    return s;
}

/* demandTribute (game.js:6133) — the 10-unit ceiling (RULINGS 2026-08-01
 * item 7) + the strength contest. */
static void demand_tribute(int vi, int ui) {
    NativeSettlement *v = &CS.villages[vi];
    int tr = vtribe(vi);
    if (CR.village_flags[vi] & VF_TRIBUTE) {
        ev_emit("EXTORTPOOR", 0, 0, 0, 0);
        return;
    }
    int mine = R(military_score() + 1);
    int theirs = R(2 * v->population * (tribe_level(tr) + 1) + 1);
    adjust_tension(tr, 3, 0);
    if (mine <= theirs) {
        ev_emit(CR.tension[tr] >= TENSION_HOSTILE ? "EXTORTLAUGH"
                                                  : "EXTORTNO",
                0, 0, dat_tribes[tr].name, 0);
        return;
    }
    CR.village_flags[vi] |= VF_TRIBUTE;
    int good = village_surplus_good(vi);
    int best = -1, bd = 0;                       /* nearest player colony */
    for (int ci = 0; ci < CS.n_colonies; ci++) {
        if ((CS.colonies[ci].owner_power & 3) != cs_nation()) continue;
        int dx = CS.colonies[ci].map_x - v->map_x;
        int dy = CS.colonies[ci].map_y - v->map_y;
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        if (best < 0 || dx + dy < bd) { best = ci; bd = dx + dy; }
    }
    /* the LAND visitor never carries a hold (only ships get one) — the
     * goods land in the nearest colony's stores */
    if (best >= 0)
        CS.colonies[best].stock[good] =
            (uint16_t)(CS.colonies[best].stock[good] + TRIBUTE_UNITS);
    ev_emit("EXTORTSTUFF", TRIBUTE_UNITS, 0, dat_cargo[good].name,
            best >= 0 ? CS.colonies[best].name : 0);
    (void)ui;
}

/* removeVillage (game.js:6183): natives detach, the record splices, the
 * surviving tribe's herd scales n/(n+1), the last village is @EXTINCT. */
static void remove_village(int vi) {
    int tr = vtribe(vi);
    /* natives homed here leave the world (descending record order keeps
     * the earlier removals' indices valid) */
    for (int ui = CS.n_units - 1; ui >= 0; ui--)
        if (CR.native_home[ui] == vi) unit_remove(ui);
    /* splice the record + every parallel per-village CR column */
    size_t n = (size_t)(CS.n_villages - vi - 1);
    memmove(&CS.villages[vi], &CS.villages[vi + 1],
            n * sizeof(NativeSettlement));
    memmove(&CR.alarm[vi], &CR.alarm[vi + 1], n);
    memmove(&CR.brave_owed[vi], &CR.brave_owed[vi + 1], n);
    memmove(&CR.village_flags[vi], &CR.village_flags[vi + 1], n);
    memmove(&CR.village_demand[vi], &CR.village_demand[vi + 1],
            n * sizeof(CR.village_demand[0]));
    memmove(&CR.village_demand_set[vi], &CR.village_demand_set[vi + 1], n);
    CS.n_villages--;
    for (int ui = 0; ui < CS.n_units; ui++)
        if (CR.native_home[ui] > vi) CR.native_home[ui]--;
    int left = 0;
    for (int w = 0; w < CS.n_villages; w++)
        if (vtribe(w) == tr) left++;
    if (!left) {
        CR.tribe_dead[tr] = 1;
        ev_emit("EXTINCT", 0, 0, dat_tribes[tr].name, 0);
        return;
    }
    CR.tribe_herd[tr] = (int16_t)(CR.tribe_herd[tr] * left / (left + 1));
    CR.tribe_horses_known[tr] =
        (int16_t)(CR.tribe_horses_known[tr] * left / (left + 1));
}

/* attackVillage (game.js:6198) — §19.10. */
static void attack_village(int vi, int ui) {
    int tr = vtribe(vi);
    ev_emit("WHACKINDIANS", 0, 0, dat_tribes[tr].name, 0);
    if (ask_choice() != 0) return;
    NativeSettlement *v = &CS.villages[vi];
    if (!CR.tribe_shunned[tr]) {
        CR.tribe_shunned[tr] = 1;
        ev_emit("INDIANSHUN", 0, 0, dat_tribes[tr].name, 0);
    }
    adjust_tension(tr, 100, 4);                  /* an act of war (@PISS4) */
    int A = analysis_total(ui, 0);
    combat_params dp;
    memset(&dp, 0, sizeof(dp));
    dp.type = (uint8_t)urow("Braves");
    dp.terrain = map_at(v->map_x, v->map_y);
    dp.orders = 6;                               /* Fortified */
    dp.is_defender = 1;
    dp.difficulty = (int8_t)cs_difficulty();
    int lvl = tribe_level(tr);                   /* v.level = tribe level */
    int D = combat_total(&dp) * (4 + lvl) / 4;
    int win = 1 + R(A + D) <= A;
    if (!win) { unit_remove(ui); return; }       /* msg only in JS */
    CS.units[ui].moves_remaining = 0;
    CR.unit_moves_undef[ui] = 0;
    if (v->population > 1) { v->population--; return; }
    /* raze: the byte-verified payout, credited straight to gold */
    int sum = 0;
    for (int i = 0; i < 3; i++) sum += R(11 - cs_difficulty());
    int gold = sum * R(7) * 4 * (v->population + 1);
    CS.powers[cs_nation()].gold += gold;
    /* t.avenge: the post-Declaration flag — WoI-side, latched via shun
     * state only when that slice lands; the JS boolean has no other
     * reader in the ported chain */
    int had_our_mission = v->mission != 0xFF &&
                          (v->mission & 0x0F) == cs_nation();
    ev_emit(gold > 0 ? "LOOT" : (v->mission != 0xFF ? "LOOT2" : "NOLOOT"),
            gold, 0, dat_tribes[tr].name, 0);
    if (had_our_mission) {
        int first = -1;
        for (int ci = 0; ci < CS.n_colonies && first < 0; ci++)
            if ((CS.colonies[ci].owner_power & 3) == cs_nation()) first = ci;
        if (first >= 0) {
            /* the flock converts: a colonist with the Convert class */
            ColonyRecord *c = &CS.colonies[first];
            if (c->population < 32) {
                colonist_add(c);
                int cv = jxrow("Indian Converts");
                if (cv > 0)
                    c->profession[c->population - 1] = (uint8_t)cv;
            }
            ev_emit("INDIANSLAVES", 0, 0, dat_tribes[tr].name, 0);
        }
    }
    remove_village(vi);
}

/* openVillageTrade (game.js:6524) — the anger refusals and the empty-
 * wagon turn-away.  The sell/buy HAGGLE beyond them needs a cargo-laden
 * visitor, which no scripted path can produce yet (wagons load cargo
 * through the colony Load picker — a later slice); if a laden visitor
 * ever reaches this, the parity diff will flag the gap loudly. */
static void open_village_trade(int vi, int ui) {
    int tr = vtribe(vi);
    UnitRecord *u = &CS.units[ui];
    int wagon = strcmp(dat_units[u->type].name, "Wagon Train") == 0;
    int laden = 0;
    for (int i = 0; i < CR.unit_n_hold[ui]; i++)
        if (CR.unit_hold[ui][i].qty > 0) laden = 1;
    if (CR.tension[tr] >= TENSION_HOSTILE) {
        if (wagon && laden) {
            ev_emit("CONFISCATE", 0, 0, dat_tribes[tr].name, 0);
            CR.unit_n_hold[ui] = 0;          /* u.hold = [] */
            return;
        }
        ev_emit("MADATWAGONS", 0, 0, dat_tribes[tr].name, 0);
        return;
    }
    /* (@MADATSHIPS is the restless-band SHIP refusal — ships cannot
     * open a village through moveSel, so it stays unreachable) */
    if (CR.tension[tr] >= 40 && wagon)
        ev_emit("GRUDGEWAGONS", 0, 0, dat_tribes[tr].name, 0);
    if (!laden) { ev_emit("TRADENOCARGO", 0, 0, 0, 0); return; }
    /* the haggle proper: tradeSellPick .. tradeBuyRound — unreachable
     * until a load-cargo command exists; deliberately unported. */
}

/* runVillageAction (game.js:6494).  Every non-trade row leaves the
 * village screen for the map. */
void run_village_action(int id) {
    int vi = CR.cur_village, ui = CR.cur_visitor;
    CR.cur_village = -1;
    CR.screen_map = 1;
    if (vi < 0 || ui < 0) return;
    switch (id) {
    case 0: case 1: open_village_trade(vi, ui); return;
    case 2: establish_mission(vi, ui); return;
    case 3: denounce_heresy(vi, ui); return;
    case 4: live_among(vi, ui); return;
    case 5: speak_to_chief(vi, ui); return;
    case 6: incite_indians(vi, ui); return;
    case 7: demand_tribute(vi, ui); return;
    case 8: attack_village(vi, ui); return;
    default: return;                 /* 9 Cancel */
    }
}
