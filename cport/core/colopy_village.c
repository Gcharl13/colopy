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
    /* the "+0x5236 posture" RESOLVED 2026-08-29: func_04B308 gates on the
     * VISITOR's @UNIT ATTACK column ([type*14+0x5236], the imul-14 chain
     * @0x4B820..@0x4B838); armed rows need attack != 0 and not a ship,
     * Live Among attack < 2, the Attack row attack > 1 (mirrors game.js) */
    int atk = dat_units[CS.units[ui].type].attack;
    int armed = !is_ship && atk != 0;
    int n = 0;
    ids[n++] = (uint8_t)(hostile ? 1 : 0);
    if (CS.units[ui].type == miss_row && !has_mission) ids[n++] = 2;
    if (has_mission && !mine) ids[n++] = 3;
    if (!hostile && CS.units[ui].type != scout_row && atk < 2) ids[n++] = 4;
    if (CS.units[ui].type == scout_row) ids[n++] = 5;
    if (armed) ids[n++] = 6;
    if (armed) ids[n++] = 7;
    if (!is_ship && atk > 1) ids[n++] = 8;
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

/* villageSkill — C1.6 closed 2026-08-29: the BYTE MODEL of the Live Among
 * handler func_04A426 + the teach-weight builder func_048F34 (stub 0x1CA24;
 * the sibling of the goods-demand table — teach weights live at [0x9E78],
 * 16 words indexed by @JOB row).  The pick runs inside its own seeded LCG
 * window — srand(((y<<8) + x + dword[0x8D80]) & 0x7FFF) @0x4A49B, the same
 * construct as colony building placement — then the engine re-seeds from
 * the clock, so the main stream is untouched.  Mirrors game.js
 * villageSkill draw for draw (a LOCAL lcg, never rng_next). */
static int att_band(int tension);
static const int8_t SKILL_RING_DX[20] = { 0, 1, 0, -1, -1, 1, 1, -1, 0, 2,
                                          0, -2, -1, 1, -1, 1, -2, -2, 2, 2 };
static const int8_t SKILL_RING_DY[20] = { -1, 0, 1, 0, -1, -1, 1, 1, -2, 0,
                                          2, 0, -2, -2, 2, 2, -1, 1, -1, 1 };
static int village_skill(int vi) {
    const NativeSettlement *v = &CS.villages[vi];
    int tr = vtribe(vi);
    int tech = tribe_level(tr);
    /* mask: box cells worked by any colony (@0x48F7D..@0x4904A),
     * transcribed literally — the bounds probe (func_005BFA, interior
     * 1..W-2/1..H-2) and the marked index both use village-relative
     * arithmetic where colony-box coordinates belong (the engine's own
     * quirk).  Player colonies contribute centre + worked cells (the
     * +0x70 plot array through lookup_byte_from_pair — only the 8-ring
     * both ports track); rival colonies (JS stubs) centre only. */
    uint8_t mask[25];
    memset(mask, 0, sizeof(mask));
    for (int ci = 0; ci < CS.n_colonies; ci++) {
        const ColonyRecord *c = &CS.colonies[ci];
        if ((c->owner_power & 3) != cs_nation()) continue;
        for (int k = -1; k < 8; k++) {
            int dx0 = 2, dy0 = 2;
            if (k >= 0) {
                if (c->tiles[k] < 0 || c->tiles[k] >= c->population) continue;
                dx0 = colony_cell_dx[k] + 2;
                dy0 = colony_cell_dy[k] + 2;
            }
            int rx = v->map_x - c->map_x + dx0;      /* [bp-4]    */
            int ry = v->map_y - c->map_y + dy0;      /* [bp-0x5A] */
            if (!(rx - 2 >= 1 && rx - 2 <= COLOPY_MAP_W - 2 &&
                  ry - 2 >= 1 && ry - 2 <= COLOPY_MAP_H - 2)) continue;
            if (rx < 0 || rx >= 5 || ry < 0 || ry >= 5) continue;
            mask[dy0 * 5 + dx0] = 1;                 /* @0x49002 */
        }
    }
    for (int p = 0; p < 4; p++) {
        if (p == cs_nation()) continue;
        for (int k = 0; k < CR.rivals[p].n_col; k++) {
            int rx = v->map_x - CR.rivals[p].col[k].x + 2;
            int ry = v->map_y - CR.rivals[p].col[k].y + 2;
            if (!(rx - 2 >= 1 && rx - 2 <= COLOPY_MAP_W - 2 &&
                  ry - 2 >= 1 && ry - 2 <= COLOPY_MAP_H - 2)) continue;
            if (rx < 0 || rx >= 5 || ry < 0 || ry >= 5) continue;
            mask[2 * 5 + 2] = 1;
        }
    }
    /* 5x5 terrain scan (@0x4904A..@0x49242); ids per func_00627A =
     * tile_yield_class (0x18 Arctic, 0x19/0x1A water, 0x1B mtn, 0x1C
     * hills, 8..0x17 forested). */
    int mtn = 0, hills = 0, c_arc = 0, fur_prime = 0, forest = 0, food = 0,
        sugar = 0, tobacco = 0, cotton = 0, ore2 = 0, ore_cnt = 0, wrun = 0;
    for (int ty = v->map_y - 2; ty <= v->map_y + 2; ty++)
        for (int tx = v->map_x - 2; tx <= v->map_x + 2; tx++) {
            if (!(tx >= 1 && tx <= COLOPY_MAP_W - 2 &&
                  ty >= 1 && ty <= COLOPY_MAP_H - 2)) continue;
            if (mask[(ty - v->map_y + 2) * 5 + (tx - v->map_x + 2)]) continue;
            int tt = tile_yield_class(map_at(tx, ty));
            if (tt == 0x1B) mtn++;                     /* @0x49195 */
            else if (tt == 0x1C) hills++;              /* @0x4919E */
            else if (tt == 0x18) c_arc += 4;           /* @0x491A7 */
            if (tt >= 8 && tt < 0x18) {                /* forest variants */
                food++;                                /* @0x491C5 */
                int base = tt >= 0x10 ? tt - 0x10 : tt - 8;
                if (base < 3) { fur_prime++; c_arc += 2; }  /* @0x4905C */
                else {
                    forest++; ore_cnt++;               /* @0x491F9 */
                    if (base == 5) sugar += 2;
                    if (base == 4) tobacco += 2;
                    if (base == 3) cotton += 2;
                }
            } else if (tt == 0x19 || tt == 0x1A) {     /* water @0x49072 */
                wrun += tech + 1;
                while (wrun >= 3) { food += 2; wrun -= 3; }
            } else if (tt < 8) {                       /* @0x4909B.. */
                if (tt == 5) sugar += 4;
                if (tt == 7) sugar += 2;
                if (tt == 4) tobacco += 4;
                if (tt == 6) tobacco += 2;
                if (tt == 3) cotton += 4;
                if (tt == 0) ore2 += 2;
                if (tt == 2) { cotton += 1; food += 2; }
                if (tt > 1) {                          /* @0x490E4 */
                    food += 2;
                    if (tt >= 6) ore2++;
                    else {
                        food++;
                        if (tt & 4) ore_cnt += 2;      /* 4, 5 */
                        else c_arc += 2;               /* 2, 3 */
                    }
                } else if (tt == 1) ore_cnt += 4;      /* @0x49112 */
                else c_arc += 3;                       /* tt == 0 */
            }
        }
    (void)c_arc; (void)ore_cnt;   /* feed only unwritten/demand rows */
    /* weight assembly (@0x49242..@0x49386) + the caller's tech gates
     * (@0x4A4CF..@0x4A51D).  Rows 5, 9, 10 and 13..15 are never written. */
    int pop1 = v->population + 1;
    int vcount = 0;
    for (int wv = 0; wv < CS.n_villages; wv++)
        if (vtribe(wv) == tr) vcount++;
    int tb = tr * 0x4E;
    int hoard = (int16_t)(CS.tribes[tb + 0x0C] | (CS.tribes[tb + 0x0D] << 8));
    int w[16];
    memset(w, 0, sizeof(w));
    w[0] = ((tech + pop1) * food) / (7 - tech);            /* Farmer      */
    w[1] = sugar;                                          /* Sugar       */
    w[2] = tobacco;                                        /* Tobacco     */
    w[3] = cotton;                                         /* Cotton      */
    w[4] = (2 * fur_prime + (forest >> 1)) / (tech + 1);   /* Fur Trapper */
    if (tech >= 1) {
        w[6] = 2 * hills + mtn + ore2;                     /* Ore Miner   */
        if (tech >= 2)
            /* tribe +0x0C word (role otherwise unread — FLAGGED "hoard")
             * over the tribe's settlement count, + 4/mtn (8 at tech 3). */
            w[7] = hoard / (vcount > 0 ? vcount : 1) +
                   (tech > 2 ? 8 : 4) * mtn;               /* Silver      */
    }
    w[12] = 2 * ((w[4] + tech) >> 1);                      /* Fur Trader  */
    w[11] = 2 * ((w[3] + tech) >> 1);                      /* Weaver      */
    if (tech < 1) { w[12] = 0; w[6] = 0; w[0] >>= 1; }
    if (tech < 2) { w[11] = 0; w[7] = 0; w[0] -= w[0] >> 2; }
    if (tech == 3) w[7] += w[7] >> 1;                      /* @0x4A512 */
    /* the seeded pick (@0x4A521..@0x4A5F1) on a LOCAL lcg */
    uint32_t s = ((uint32_t)((v->map_y << 8) + v->map_x) + CR.plot_seed)
                 & 0x7FFF;
    int sum = 0;
    for (int i = 0; i < 16; i++) sum += w[i];
    if (sum < 1) return 0;      /* all-zero table: the EXE would walk off */
    s = s * 214013u + 2531011u;
    int cnt = 1 + (int)((((s >> 16) & 0x7FFF) * (uint32_t)sum) >> 15);
    int j = -1;
    do { cnt -= w[++j]; } while (cnt > 0);
    if (j == 4 && (v->map_x + v->map_y) % 3 == 0) j = 0x16;    /* Scout */
    if (j == 0) {               /* Fisherman ring roll @0x4A595..@0x4A5EB */
        int n = 0;
        for (int k = 0; k < 20; k++) {
            int raw = map_at(v->map_x + SKILL_RING_DX[k],
                             v->map_y + SKILL_RING_DY[k]) & 0x1F;
            if (raw == 0x19 || raw == 0x1A) n++;
        }
        s = s * 214013u + 2531011u;
        if (1 + (int)((((s >> 16) & 0x7FFF) * 20u) >> 15) < n) j = 8;
    }
    return j;
}

/* liveAmong — func_04A426's own ladder order (@0x4A64C..@0x4A78E). */
static void live_among(int vi, int ui) {
    NativeSettlement *v = &CS.villages[vi];
    int tr = vtribe(vi);
    int job = village_skill(vi);
    /* @LEARNMAD: attitude band (25/50/75) above 1 — tension >= 50 —
     * refuses AND costs 3 tension (the applier call @0x4A669). */
    if (att_band(CR.tension[tr]) > 1) {
        ev_emit("LEARNMAD", 0, 0, dat_tribes[tr].name, 0);
        adjust_tension(tr, 3, 0);
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
    /* the taught latch (settlement +0x03 bit 1) only blocks NON-capitals
     * (@0x4A6EE skips @LEARNALREADY on the capital flag, bit 2) */
    if ((CR.village_flags[vi] & VF_TAUGHT) && !(v->flags & 0x04)) {
        ev_emit("LEARNALREADY", 0, 0, 0, 0);
        return;
    }
    ev_emit("LEARNSTAY", 0, 0, dat_tribes[tr].name, 0);
    if (ask_choice() != 0) { ev_emit("LEARNLATER", 0, 0, 0, 0); return; }
    /* the failure roll only runs at band > 0 (tension >= 25, @0x4A728) —
     * a content tribe always teaches */
    if (att_band(CR.tension[tr]) > 0 &&
        1 + R(1000) < 200 * cs_difficulty() + 100) {
        ev_emit("LEARNSLOW", 0, 0, 0, 0);        /* may retry */
        return;
    }
    CR.village_flags[vi] |= VF_TAUGHT;
    v->flags |= 0x02;                            /* @0x4A78A */
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

/* ---- the village trade haggle — the BYTE MODEL of func_049600
 * (0x049600..0x04A37A, tail read 2026-08-29; JS tradeSellPick..
 * tradeBuyRound mirrored draw-for-draw).  The scripted harness still
 * remaps the trade rows to Cancel on both sides, so this path runs only
 * in live play. ------------------------------------------------------- */

/* func_008262 (0x181f:0xa60): tension <25 -> 0, <50 -> 1, <75 -> 2, else 3 */
static int att_band(int tension) {
    return tension >= 75 ? 3 : tension >= 50 ? 2 : tension >= 25 ? 1 : 0;
}
/* the tribe's goods-stock words, TribeRecord +0x0E..+0x2D (@0x49BAC) */
static int tstock_get(int tr, int g) {
    int off = tr * 0x4E + 0x0E + g * 2;
    return (int16_t)(CS.tribes[off] | (CS.tribes[off + 1] << 8));
}
static void tstock_add(int tr, int g, int d) {
    int v = tstock_get(tr, g) + d;
    if (v < 0) v = 0;
    int off = tr * 0x4E + 0x0E + g * 2;
    CS.tribes[off] = (uint8_t)(v & 0xFF);
    CS.tribes[off + 1] = (uint8_t)((v >> 8) & 0xFF);
}
/* the sell quote — @0x4999C..@0x49B02 (see game.js sellQuote for the
 * per-line citations); out: offer/want/att */
static void sell_quote(int vi, int good, int qty,
                       int *offer, int *want_out, int *att_out) {
    int tr = vtribe(vi);
    int want = village_demand(vi)[good];
    int mood = 1 + R(5);
    int base = good >= 9 ? 7 : 6;
    if (good == 13) base -= R(8);                    /* Trade Goods */
    if (good == 15) base += 12 - CR.tribe_muskets_known[tr];
    if (good == 8) base += 10 - CR.tribe_horses_known[tr];
    if (good == 14) base += 1;                       /* Tools */
    int att = 2 * att_band(CR.tension[tr]);
    if (good == 15 || good == 8) att = 0;
    if (want >= 20) att >>= 1;
    int seed = 2 * (base - (int)cs_difficulty() - att + mood + 4);
    int sw = seed * want;
    if (sw < 0) sw = 0;
    int of = ((sw + 5 * mood) * qty / 100) / 2;
    if (of < 1) of = 1;
    *offer = of; *want_out = want; *att_out = att;
}
/* the sale bookkeeping (villageSell): gold in, tribe stock in, alarm off
 * by the load (100 zeroes, @0x49BE4..@0x49BF8), arming counters
 * (@0x49C1E..@0x49C69), tension credit from the caller */
static void village_sell_qty(int vi, int good, int qty, int paid, int credit) {
    int tr = vtribe(vi);
    CS.powers[cs_nation()].gold += paid;
    tstock_add(tr, good, qty);
    NativeSettlement *v = &CS.villages[vi];
    int a = CR.alarm[vi];
    CR.alarm[vi] = (uint8_t)(qty >= 100 ? 0 : (a > qty ? a - qty : 0));
    v->alarm[cs_nation()] = CR.alarm[vi];
    adjust_tension(tr, credit, 0);
    if (good == 15)
        CR.tribe_muskets_known[tr] = (int16_t)(CR.tribe_muskets_known[tr] +
            (qty >= 50 ? 2 : qty >= 25 ? 1 : 0));
    if (good == 8) {
        CR.tribe_horses_known[tr] = (int16_t)(CR.tribe_horses_known[tr] +
            (qty >= 50 ? 2 : qty >= 25 ? 1 : 0));
        CR.tribe_herd[tr] = (int16_t)(CR.tribe_herd[tr] + qty / 4);
    }
}
/* a gift (@0x49E4C): double alarm cut, one arming tick, caller's credit */
static void village_gift_qty(int vi, int good, int qty, int credit) {
    int tr = vtribe(vi);
    tstock_add(tr, good, qty);
    int a = CR.alarm[vi];
    CR.alarm[vi] = (uint8_t)(qty >= 100 ? 0 : (a > 2 * qty ? a - 2 * qty : 0));
    CS.villages[vi].alarm[cs_nation()] = CR.alarm[vi];
    adjust_tension(tr, credit, 0);
    if (good == 15) CR.tribe_muskets_known[tr]++;
    if (good == 8) {
        CR.tribe_herd[tr] = (int16_t)(CR.tribe_herd[tr] + qty / 4);
        CR.tribe_horses_known[tr]++;             /* @0x49EFA -> @0x49C66 */
    }
}
static void trade_buy_phase(int vi, int ui, int sold_good);
/* the sell rounds — @0x49B02..@0x49E4C */
static void trade_sell_round(int vi, int ui, int slot, int good, int qty) {
    NativeSettlement *v = &CS.villages[vi];
    int tr = vtribe(vi);
    int offer, want, att;
    sell_quote(vi, good, qty, &offer, &want, &att);
    int budget = R(2) + ((want - att + 4) >> 2);      /* @0x49AB4 */
    int ceiling = (want + 1) * 4 + offer;             /* @0x49AD1 */
    int round = 0;
    for (;;) {
        int qual = (want - att + 4) / 10;             /* @VALUES row @0x49AA0 */
        if (qual < 0) qual = 0;
        if (qual > 3) qual = 3;
        ev_emit(round == 0 ? "TRADE0" : "TRADE1", offer, ceiling,
                dat_values[qual], dat_cargo[good].name);
        int k = ask_choice();
        int gift_row = round == 0 ? 2 : -1;
        if (k == 0) {                                 /* accept @0x49B80 */
            village_sell_qty(vi, good, qty, offer,
                             -2 * (budget > 0 ? budget : 0));
            hold_add(CR.unit_hold[ui], &CR.unit_n_hold[ui], good, -qty);
            v->walked_good = 0xFF;
            v->last_bought = (uint8_t)(good == 15 || good == 8 ? 0xFF : good);
            trade_buy_phase(vi, ui, good);
            return;
        }
        if (k == 1) {                                 /* haggle @0x49D76 */
            if (budget > 0 &&
                1 + R(8 * budget) > (int)cs_difficulty()) {
                budget--;
                int lo = (want >> 1) + 1, hi = 2 * want + 1;
                int bump = (lo + R(hi - lo + 1)) * qty / 100;
                if (bump < 1) bump = 1;
                offer += bump;
                if (offer >= ceiling) ceiling = offer + 10;
                round = 1;
                continue;
            }
            /* the walk-away (@0x49DFE): the good is remembered, tension
             * rises att/2+1, the session ends (no buy phase) */
            v->walked_good = (uint8_t)good;
            adjust_tension(tr, (att >> 1) + 1, 0);
            ev_emit("BADHAGGLE0", 0, 0, 0, dat_cargo[good].name);
            return;
        }
        if (k == gift_row) {                          /* gift @0x49E4C */
            village_gift_qty(vi, good, qty,
                             -4 * ((budget > 0 ? budget : 0) + 1));
            hold_add(CR.unit_hold[ui], &CR.unit_n_hold[ui], good, -qty);
            v->walked_good = 0xFF;
            v->last_bought = (uint8_t)(good == 15 || good == 8 ? 0xFF : good);
            trade_buy_phase(vi, ui, good);
            return;
        }
        return;               /* never mind: no buy phase (@0x49E42) */
    }
    (void)slot;
}
static void trade_sell_offer(int vi, int ui, int slot) {
    NativeSettlement *v = &CS.villages[vi];
    int good = CR.unit_hold[ui][slot].good;
    int qty = CR.unit_hold[ui][slot].qty;
    /* settlement +0x07: offering the walked-away good again (@0x49976) */
    if (v->walked_good == (uint8_t)good) {
        ev_emit("BADHAGGLE1", 0, 0, dat_cargo[good].name, 0);
        trade_buy_phase(vi, ui, -1);
        return;
    }
    const int16_t *dem = village_demand(vi);
    /* the last-bought refusal (+0x08; the engine's 0xFF-exception check
     * compares the UNIT index @0x49BFD — an authentic bug; the intended
     * good semantics kept, natives.md) */
    if (v->last_bought == (uint8_t)good && good != 15) {
        int w1 = -1, w2 = -1, w3 = -1;
        for (int g = 0; g < 16; g++) {
            if (g == good) continue;
            if (w1 < 0 || dem[g] > dem[w1]) { w3 = w2; w2 = w1; w1 = g; }
            else if (w2 < 0 || dem[g] > dem[w2]) { w3 = w2; w2 = g; }
            else if (w3 < 0 || dem[g] > dem[w3]) w3 = g;
        }
        ev_emit("BADCARGO", 0, 0, dat_cargo[good].name,
                w1 >= 0 ? dat_cargo[w1].name : "");
        (void)w3;
        return;                     /* @BADCARGO ends the session (@0x4996F) */
    }
    if (dem[good] <= 1) {
        ev_emit("TRADENOWANT", qty, 0, dat_cargo[good].name, 0);
        trade_buy_phase(vi, ui, -1);
        return;
    }
    trade_sell_round(vi, ui, slot, good, qty);
}
static void trade_sell_pick(int vi, int ui) {
    int slots[EURO_HOLD_MAX], ns = 0;
    for (int i = 0; i < CR.unit_n_hold[ui]; i++)
        if (CR.unit_hold[ui][i].qty > 0) slots[ns++] = i;
    if (!ns) { trade_buy_phase(vi, ui, -1); return; }
    if (ns == 1) { trade_sell_offer(vi, ui, slots[0]); return; }
    ev_emit("TRADEWHICH", 0, 0, 0, 0);
    int k = ask_choice();
    /* cancel ends the session (@0x49845 -> @0x4A362) */
    if (k >= 0 && k < ns) trade_sell_offer(vi, ui, slots[k]);
}
/* the buy ask — @0x4A025..@0x4A0E1 (see game.js villageAsk) */
static int village_ask_price(int vi, int good, int qty) {
    int tr = vtribe(vi);
    int ask = good >= 8 ? (8 - tribe_level(tr)) * 50 : 200;
    if (good >= 7) ask += (market_bid(good) + 1) * (15 + 2 * (int)cs_difficulty());
    ask += R(ask + 1);
    ask -= 4 * village_demand(vi)[good];
    ask += 4 * CR.tension[tr];
    ask = qty * ask / 100;
    ask += ((int)cs_difficulty() + R(3)) * 10;
    return ask < 50 ? 50 : ask;
}
/* the buy rounds — @0x4A144..@0x4A34C */
static void trade_buy_round(int vi, int ui, int good, int qty) {
    NativeSettlement *v = &CS.villages[vi];
    int tr = vtribe(vi);
    int demand = village_demand(vi)[good];
    int ask = village_ask_price(vi, good, qty);
    int floor_p = ask >> 1; if (floor_p < 10) floor_p = 10;   /* @0x4A15F */
    int step = ask >> 2; if (step < 1) step = 1;              /* @0x4A170 */
    int round = 0;
    PowerRecord *p = &CS.powers[cs_nation()];
    for (;;) {
        ev_emit(round == 0 ? "BUY0" : "BUY1", ask, floor_p,
                dat_cargo[good].name, dat_units[CS.units[ui].type].name);
        int k = ask_choice();
        if (k == 0) {                                 /* pay @0x4A1C8 */
            if (ask > p->gold) {
                ev_emit("NOTENOUGH", (int32_t)p->gold, 0, 0, 0);
                adjust_tension(tr, 1, 0);             /* @0x4A277 */
                return;
            }
            p->gold -= ask;
            tstock_add(tr, good, -qty);
            hold_add(CR.unit_hold[ui], &CR.unit_n_hold[ui], good, qty);
            v->last_sold = (uint8_t)(good == 9 ? 0xFF : good);  /* rum */
            adjust_tension(tr, -R(ask / 25 + 2), 0);  /* @0x4A21D */
            return;
        }
        if (k == 1) {                                 /* haggle @0x4A27E */
            int roll = R(demand / 25 + 9);
            if (ask > 10 && roll > (int)cs_difficulty() + 1) {
                ask -= step;
                if (ask < 10) ask = 10;
                if (1 + R(8 - (int)cs_difficulty()) == 1)
                    adjust_tension(tr, 1, 0);         /* @0x4A2CA */
                round = 1;
                continue;
            }
            adjust_tension(tr, 2, 0);
            v->walked_good = 0xFE;                    /* the insult latch */
            ev_emit("BADHAGGLE2", 0, 0, 0, 0);
            return;
        }
        return;
    }
}
static void trade_buy_phase(int vi, int ui, int sold_good) {
    NativeSettlement *v = &CS.villages[vi];
    /* a free cargo slot (@UNIT cargo column vs the load, @0x49C92) */
    int t = CS.units[ui].type;
    int used = CR.unit_n_hold[ui];    /* JS counts hold + passenger slots */
    if (dat_units[t].cargo - used < 1) return;
    if (v->walked_good == 0xFE) {                     /* @0x49D5E */
        ev_emit("BADHAGGLE3", 0, 0, 0, 0);
        return;
    }
    /* @BRING (@0x49CF0): the sold good is not among the top two wants */
    const int16_t *dem = village_demand(vi);
    int w1 = 0, w2 = -1, w3 = -1;
    for (int g = 1; g < 16; g++) {
        if (dem[g] > dem[w1]) { w3 = w2; w2 = w1; w1 = g; }
        else if (w2 < 0 || dem[g] > dem[w2]) { w3 = w2; w2 = g; }
        else if (w3 < 0 || dem[g] > dem[w3]) w3 = g;
    }
    if (sold_good >= 0 && w1 != sold_good && w2 != sold_good)
        ev_emit("BRING", 0, 0, dat_cargo[w1].name,
                w2 >= 0 ? dat_cargo[w2].name : "");
    (void)w3;
    /* villageSurplus: raw goods with qty >= 25, up to three */
    int offers[3], oq[3], no = 0;
    for (int g = 0; g <= 7 && no < 3; g++) {
        int q = dem[g] * 5;
        if (q > 100) q = 100;
        if (q >= 25) { offers[no] = g; oq[no] = q; no++; }
    }
    if (!no) return;
    ev_emit("BUYWHICH", 0, 0, dat_cargo[offers[0]].name,
            no > 1 ? dat_cargo[offers[1]].name : "");
    int k = ask_choice();
    if (k < 0 || k >= no) return;
    /* ships carry a QUARTER load (@0x4A012); clamp to hold room */
    int qty = oq[k];
    if (dat_units[t].hull > 0) qty >>= 2;
    int slot_room = 0;
    for (int i = 0; i < CR.unit_n_hold[ui]; i++)
        if (CR.unit_hold[ui][i].good == offers[k])
            slot_room = 100 - CR.unit_hold[ui][i].qty;
    int space = (dat_units[t].cargo - used) * 100 + slot_room;
    if (qty > space) qty = space;
    if (qty <= 0) return;
    trade_buy_round(vi, ui, offers[k], qty);
}

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
    /* an empty hold meets @DEFICIT and the visit ends (@0x49F0E) */
    if (!laden) { ev_emit("DEFICIT", 0, 0, 0, 0); return; }
    trade_sell_pick(vi, ui);
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
