/* Host smoke harness — proves the Phase-0 build wiring end to end:
 * generated data tables + record headers compile together and link, and the
 * table contents match known byte-verified oracles. Grows into the parity
 * driver in Phase 3. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../core/colopy_core.h"
#include "../core/colopy_state.h"
#include "../core/colopy_sim.h"
#include "../data/colopy_data.h"
#include "fixtures.h"

static int fail = 0;
#define CHECK(cond, ...) do { \
    if (!(cond)) { fail++; printf("FAIL: " __VA_ARGS__); printf("\n"); } \
} while (0)

/* --produce: dump colonyProduce for every PLAYER colony of every fixture,
 * one JSON line each — diffed against the JS port's numbers by
 * tools/sim_compare.py (the logic-side render_diff). */
static void dump_produce(void) {
    struct { const char *name; const uint8_t *buf; size_t len; } savs[] = {
        {"savstart", savstart, sizeof(savstart)},
        {"sav1653", sav1653, sizeof(sav1653)},
        {"savraleigh", savraleigh, sizeof(savraleigh)},
        {"savnewcolony", savnewcolony, sizeof(savnewcolony)},
    };
    for (unsigned i = 0; i < sizeof(savs) / sizeof(savs[0]); i++) {
        if (colopy_load_sav(savs[i].buf, savs[i].len) != COLOPY_OK) continue;
        for (int k = 0; k < CS.n_colonies; k++) {
            const ColonyRecord *c = colopy_colony(k);
            if ((c->owner_power & 3) != cs_nation()) continue;
            colony_output r;
            colony_produce(k, &r);
            printf("{\"save\":\"%s\",\"name\":\"%.24s\",\"pop\":%u,"
                   "\"sol\":%d,\"centre\":%d,\"eaten\":%d,"
                   "\"hammers\":%d,\"bells\":%d,\"crosses\":%d,"
                   "\"teaching\":%d,\"out\":[",
                   savs[i].name, c->name, c->population, colony_sol(c),
                   r.centre, r.eaten, r.hammers, r.bells, r.crosses,
                   r.teaching);
            for (int g = 0; g < N_GOODS; g++)
                printf("%s%d", g ? "," : "", r.out[g]);
            printf("]}\n");
        }
    }
}

/* --market: the scripted trade sequence tools/sim_trace.py mirrors in JS.
 * One JSON state line after load and after every step. */
static void dump_market_state(const char *step) {
    const PowerRecord *p = colopy_power(cs_nation());
    printf("{\"step\":\"%s\",\"gold\":%d,\"fund\":%d,\"market\":[", step,
           p->gold, p->kings_fund);
    /* the LEVEL byte, like the JS snapshot's G.market — the dump printed
     * market_bid (level−1) after the bid/ask straddle fix and this
     * oracle sat red unnoticed; repaired 2026-08-29 */
    for (int i = 0; i < N_GOODS; i++)
        printf("%s%d", i ? "," : "", p->price_level[i]);
    printf("],\"accum\":[");
    for (int i = 0; i < N_GOODS; i++) printf("%s%d", i ? "," : "", market_accum(i));
    printf("],\"tons\":[");
    for (int i = 0; i < N_GOODS; i++) printf("%s%d", i ? "," : "", p->trade_tons[i]);
    printf("],\"tgold\":[");
    for (int i = 0; i < N_GOODS; i++) printf("%s%d", i ? "," : "", p->trade_gold[i]);
    printf("]}\n");
}
static void dump_market(void) {
    colopy_load_sav(sav1653, sizeof(sav1653));
    dump_market_state("load");
    market_sell(9, 100);  dump_market_state("sell_rum_100");
    market_sell(2, 50);   dump_market_state("sell_tobacco_50");
    market_buy(14, 30);   dump_market_state("buy_tools_30");
    market_drift();       dump_market_state("drift_1");
    market_sell(7, 200);  dump_market_state("sell_silver_200");
    market_buy(15, 10);   dump_market_state("buy_muskets_10");
    for (int i = 0; i < 5; i++) market_drift();
    dump_market_state("drift_5");
    market_sell(0, 500);  dump_market_state("sell_food_500");
    market_buy(8, 20);    dump_market_state("buy_horses_20");
}

/* --raid: the raid-ladder parity probe tools/sim_trace.py RAID mirrors —
 * forty raids by village k % nv on player colony k % nc from the shared
 * seed, one JSON state line each (CORE-B 2026-09-03: the turns oracles
 * never reach a raid, so the ladder gets its own oracle). */
static void dump_raid(void) {
    colopy_load_sav(sav1653, sizeof(sav1653));
    colopy_init(1653);
    units_session_seed();
    int npc = 0;
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation()) npc++;
    for (int k = 0; k < 40 && CS.n_villages && npc; k++) {
        int vi = k % CS.n_villages;
        int want = k % npc, ci = -1;
        for (int q = 0; q < CS.n_colonies && ci < 0; q++)
            if ((CS.colonies[q].owner_power & 3) == cs_nation() && want-- == 0) ci = q;
        CR.alarm[vi] = 0x90;
        CS.villages[vi].alarm[cs_nation()] = 0x90;
        /* adversarial seeding (mirrors the JS): the fort tiers come down */
        colony_bld_remove_name(ci, "Stockade");
        colony_bld_remove_name(ci, "Fort");
        colony_bld_remove_name(ci, "Fortress");
        natives_raid_probe(vi, ci);
        const ColonyRecord *c = &CS.colonies[ci];
        printf("{\"step\":\"raid%d\",\"rng\":%u,\"gold\":%d,\"stock\":[", k,
               (unsigned)CS.rng, CS.powers[cs_nation()].gold);
        for (int g = 0; g < N_GOODS; g++) printf("%s%d", g ? "," : "", c->stock[g]);
        printf("],\"bld\":[");
        {
            uint64_t first = 0;
            for (int q = 0; q < CR.col[ci].n_bld; q++)
                first |= 1ull << bld_first_row(CR.col[ci].bld[q]);
            int fb = 1;
            for (int b = 0; b < DAT_BUILDINGS_COUNT; b++)
                if ((first >> b) & 1) { printf("%s%d", fb ? "" : ",", b); fb = 0; }
        }
        printf("],\"jobs\":[");
        for (int q = 0; q < c->population && q < 32; q++)
            printf("%s%d", q ? "," : "",
                   c->occupation[q] < DAT_JOBS_COUNT ? c->occupation[q] : -1);
        printf("],\"tension\":[");
        for (int t = 0; t < 8; t++) printf("%s%d", t ? "," : "", CR.tension[t]);
        printf("],\"alarm\":[");
        for (int v = 0; v < CS.n_villages; v++) printf("%s%d", v ? "," : "", CR.alarm[v]);
        printf("],\"tribes\":[");
        for (int t = 0; t < 8; t++)
            printf("%s[%d,%d,%d]", t ? "," : "", CR.tribe_muskets_known[t],
                   CR.tribe_horses_known[t], CR.tribe_herd[t]);
        int dmg = 0;
        for (int q = 0; q < CR.n_units_order; q++) dmg += CR.unit_damaged[CR.units_order[q]] ? 1 : 0;
        printf("],\"damaged\":%d,\"events\":[", dmg);
        colopy_event e;
        int first = 1;
        while (colopy_next_event(&e)) { printf("%s\"%s\"", first ? "" : ",", e.key); first = 0; }
        printf("]}\n");
    }
}

/* --movecost / --combat: read one case per stdin line, print one result
 * per line. The case lists are OWNED by tools/sim_compare.py, which feeds
 * the identical lists to the headless JS port. */
static void dump_movecost(void) {
    colopy_load_sav(sav1653, sizeof(sav1653));
    int ship, fx, fy, tx, ty;
    while (scanf("%d %d %d %d %d", &ship, &fx, &fy, &tx, &ty) == 5)
        printf("%d\n", move_cost(ship, fx, fy, tx, ty));
}
static void dump_combat(void) {
    colopy_load_sav(sav1653, sizeof(sav1653));
    int type, x, y, def, orders, fatigue, damaged, holds, veteran;
    while (scanf("%d %d %d %d %d %d %d %d %d", &type, &x, &y, &def, &orders,
                 &fatigue, &damaged, &holds, &veteran) == 9) {
        combat_params p;
        memset(&p, 0, sizeof(p));
        p.type = (uint8_t)type;
        p.terrain = map_at(x, y);
        for (int i = 0; i < CS.n_colonies; i++)
            if (CS.colonies[i].map_x == x && CS.colonies[i].map_y == y)
                p.on_colony = 1;
        p.orders = (uint8_t)orders;
        p.is_defender = (uint8_t)def;
        p.damaged = (uint8_t)damaged;
        p.veteran = (uint8_t)veteran;
        p.fatigue = (uint8_t)fatigue;
        p.holds = (uint8_t)holds;
        p.artillery = strcmp(dat_units[type].name, "Artillery") == 0;
        p.difficulty = (int8_t)cs_difficulty();
        /* Drake/Spain/WOI clauses off in the sweep: the 1653 Dutch game has
         * G.nation=3 and the sweep spawns no REF units; Drake is checked
         * against the record so both sides agree either way. */
        if (strcmp(dat_units[type].name, "Privateer") == 0) {
            for (int i = 0; i < DAT_FATHERS_COUNT; i++)
                if (strcmp(dat_fathers[i].name, "Francis Drake") == 0)
                    p.privateer_drake =
                        (CS.powers[cs_nation()].founding_fathers >> i) & 1;
        }
        printf("%d\n", combat_total(&p));
    }
}

/* Slice-2 scripted commands: a deterministic, RNG-free policy BOTH
 * engines compute identically (mirrored verbatim in sim_trace.py's TURNS
 * block).  Every move target passes ONE shared legality filter — empty
 * legal land only — so the ports' not-yet-shared branches (ships, rival
 * tiles, villages, rumour entry: slices 3-5) are never reached. */
static const int DIRS8[8][2] = { { 1, 0 },  { 1, 1 },   { 0, 1 },
                                 { -1, 1 }, { -1, 0 },  { -1, -1 },
                                 { 0, -1 }, { 1, -1 } };

static int script_tile_free(int nx, int ny) {
    if (nx < 0 || ny < 0 || nx >= COLOPY_MAP_W || ny >= COLOPY_MAP_H) return 0;
    if (tile_water(map_at(nx, ny))) return 0;
    for (int k = 0; k < CR.n_natives; k++) {
        int q = CR.natives_order[k];
        if (unit_pos_x(q) == nx && unit_pos_y(q) == ny) return 0;
    }
    for (int k = 0; k < CR.n_refs; k++) {
        int q = CR.refs_order[k];
        if (CS.units[q].map_x == nx && CS.units[q].map_y == ny) return 0;
    }
    for (int rn = 0; rn < 4; rn++) {
        if (rn == (int)cs_nation()) continue;
        for (int k = 0; k < CR.n_runits[rn]; k++) {
            int q = CR.runits_order[rn][k];
            if (CR.runit_x[q] == nx && CR.runit_y[q] == ny) return 0;
        }
        for (int k = 0; k < CR.rivals[rn].n_col; k++)
            if (CR.rivals[rn].col[k].x == nx &&
                CR.rivals[rn].col[k].y == ny) return 0;
    }
    for (int v = 0; v < CS.n_villages; v++)
        if (CS.villages[v].map_x == nx && CS.villages[v].map_y == ny)
            return 0;
    return 1;   /* rumour squares are ENTERED (slice 4a: enter_rumour) */
}

static void script_commands(int t) {
    for (int k = 0; k < CR.n_units_order; k++) {
        int ui = CR.units_order[k];
        UnitRecord *u = &CS.units[ui];
        int ship = u->type < DAT_UNITS_COUNT && dat_units[u->type].hull > 0;
        if (ship) {
            /* slice 3: an idle ship is ORDERED HOME now and then.  This
             * goes through cmd_order_sail_home, not cmd_sail_for_europe,
             * so the oracle covers the whole sail-to-the-lane leg: the Go
             * To out to the nearest sea lane, advance_goto walking it
             * there, and the arrival that starts the crossing.  A ship
             * already on the lane still leaves at once, and the splice
             * shifts the list so the loop steps past the slot, exactly
             * like the JS iteration. */
            if (u->orders == 0 && (t + k) % 17 == 0 && t > 0 &&
                !woi_locked()) {
                cmd_order_sail_home(ui);
                continue;
            }
            /* slice 4c: a water step (interception, naval attack,
             * parley; the sea lane's dialog is inert so skip its tiles) */
            int sx = u->map_x + DIRS8[(t + k) % 8][0];
            int sy = u->map_y + DIRS8[(t + k) % 8][1];
            if (!CR.unit_moves_undef[ui] && u->moves_remaining > 0 &&
                sx >= 0 && sy >= 0 && sx < COLOPY_MAP_W &&
                sy < COLOPY_MAP_H && tile_water(map_at(sx, sy)) &&
                tile_terrain(map_at(sx, sy)) != TERR_SEALANE)
                cmd_move(ui, DIRS8[(t + k) % 8][0],
                         DIRS8[(t + k) % 8][1]);
            continue;
        }
        int a = (t * 7 + k * 3) % 10;
        if (u->orders != 0) {             /* busy: occasionally wake it */
            if (a == 0) cmd_activate(ui);
            continue;
        }
        if (a < 5) {
            const int *d = DIRS8[(t + k) % 8];
            if (!CR.unit_moves_undef[ui] && u->moves_remaining > 0 &&
                script_tile_free(u->map_x + d[0], u->map_y + d[1]))
                cmd_move(ui, d[0], d[1]);
        } else if (a == 5) {
            /* visit an adjacent village (slice 4b) — skip tiles a native
             * or rival also occupies (those are moveSel's foe branches) */
            for (int di = 0; di < 8; di++) {
                int nx = u->map_x + DIRS8[di][0];
                int ny = u->map_y + DIRS8[di][1];
                int vil = 0;
                for (int v = 0; v < CS.n_villages; v++)
                    if (CS.villages[v].map_x == nx &&
                        CS.villages[v].map_y == ny) vil = 1;
                if (!vil) continue;
                int occupied = 0;
                for (int q = 0; q < CR.n_natives && !occupied; q++) {
                    int nu = CR.natives_order[q];
                    if (unit_pos_x(nu) == nx && unit_pos_y(nu) == ny)
                        occupied = 1;
                }
                for (int rn = 0; rn < 4 && !occupied; rn++)
                    for (int q = 0; q < CR.n_runits[rn] && !occupied; q++) {
                        int ru = CR.runits_order[rn][q];
                        if (CR.runit_x[ru] == nx && CR.runit_y[ru] == ny)
                            occupied = 1;
                    }
                if (!occupied && !CR.unit_moves_undef[ui] &&
                    u->moves_remaining > 0) {
                    cmd_move(ui, DIRS8[di][0], DIRS8[di][1]);
                    if (CR.cur_village >= 0) {
                        uint8_t ids[10];
                        int nr = village_action_rows(ids);
                        run_village_action(nr ? ids[(t + k) % nr] : 9);
                    }
                }
                break;
            }
        } else if (a == 6) {
            cmd_set_order(ui, 5);         /* Fortify */
        } else if (a == 7) {
            cmd_improve(ui, (t % 2) ? 9 : 8);
        } else if (a == 8) {
            for (int ci = 0; ci < CS.n_colonies; ci++)
                if ((CS.colonies[ci].owner_power & 3) == cs_nation()) {
                    cmd_goto(ui, CS.colonies[ci].map_x,
                             CS.colonies[ci].map_y);
                    break;
                }
        } else {
            cmd_skip(ui);
        }
    }
    /* --- the fence (2026-08-17): now and then a colonist steps OUT of the
     * first colony that can spare him, so the oracle covers
     * colonist_to_fence — the member leaving, the unit appearing on the
     * square, and the food count dropping with the population. */
    if (t % 13 == 0 && t > 0) {
        for (int ci = 0; ci < CS.n_colonies; ci++) {
            if ((CS.colonies[ci].owner_power & 3) != cs_nation()) continue;
            if (CS.colonies[ci].population <= 1) continue;
            colonist_to_fence(ci, (t / 13) % CS.colonies[ci].population);
            break;
        }
    }
    /* --- the Europe phase (slice 3), fixed order.  portIdx tracks the
     * LIVE shipsInPort index (activeShip's coordinate); seen is the
     * stable action selector. */
    {
        int port_idx = 0, seen = 0;
        for (int i = 0; i < CR.n_europe; i++) {
            euro_crossing *e = &CR.europe[i];
            if (e->state != 0) continue;
            int a = (t * 3 + seen) % 5;
            seen++;
            if (a == 0) {
                hold_slot snap[EURO_HOLD_MAX];
                int ns = e->n_hold;
                memcpy(snap, e->hold, sizeof(snap));
                for (int h = 0; h < ns; h++)
                    euro_sell_from_ship(i, snap[h].good, snap[h].qty);
            } else if (a == 1) {
                euro_buy_to_ship(i, (t + port_idx) % 16, 50);
            } else if (a == 2) {
                euro_sail_new_world(i);
            }
            if (e->state == 0) port_idx++;
        }
        if (t % 4 == 1 && CR.n_dock_units) {
            uint8_t verbs[6];
            int n = euro_arm_rows(0, verbs);
            if (n) euro_arm_dock(0, verbs[(t >> 2) % n]);
        }
        if (t % 5 == 2) euro_recruit(0);
        if (t % 9 == 4) declare_independence();
        if (t % 7 == 3) euro_purchase((t / 7) % 6);
    }
}

/* --turns SAVE N: run N prefix turns, one projection JSON line per turn.
 * The projection is the parity diff unit (plan section B); the JS trace
 * emits the identical shape. Events drain per turn; TUTORIAL*-keyed
 * differences are the compare script's to filter. */
static void print_projection(int job_convert);

static void dump_turns(const char *save, int n, int agitate, int script) {
    if (strcmp(save, "savstart") == 0) colopy_load_sav(savstart, sizeof(savstart));
    else if (strcmp(save, "sav1653") == 0) colopy_load_sav(sav1653, sizeof(sav1653));
    else if (strcmp(save, "savraleigh") == 0) colopy_load_sav(savraleigh, sizeof(savraleigh));
    else colopy_load_sav(savnewcolony, sizeof(savnewcolony));
    colopy_init(1653);                       /* the shared trace seed */
    units_session_seed();
    CR.n_dock_units = 0;   /* the trace clears G.dockUnits after import */
    CR.crosses = 0;        /* sim_trace.py:490 zeroes G.crosses too */
    CR.cross_threshold = 0;
    if (agitate) {
        /* the trace's adversarial seeding — mirrors sim_trace.py TURNS */
        for (int v = 0; v < CS.n_villages; v++) {
            CR.alarm[v] = 0x90;
            if (((CS.villages[v].owner_tribe - 4) % 2) == 0)
                CS.villages[v].mission = cs_nation();
        }
        for (int t = 0; t < 8; t++) CR.tension[t] = 80;
        /* slice 5: prime the SoL EMA so the DECLARE gate can open */
        for (int ci = 0; ci < CS.n_colonies; ci++)
            if ((CS.colonies[ci].owner_power & 3) == cs_nation()) {
                CR.col[ci].rebelA = 20000;
                CR.col[ci].rebelB = 20000;
            }
    }
    int job_convert = -1;
    for (int i = 0; i < DAT_JOBEXPERT_COUNT; i++)
        if (strcmp(dat_jobexpert[i], "Indian Converts") == 0) job_convert = i;
    for (int d = 0; d < 3; d++) roll_immigrant(&CR.dock[d]);
    for (int t = 0; t < n; t++) {
        if (script) script_commands(t);
        step_rng("turn-start");
        turn_step_prefix();
        step_rng("prefix");
        turn_step2();
        turn_step3();
        turn_step5();
        print_projection(job_convert);
    }
}

/* one JSON projection line of the CURRENT state — shared by the TURNS
 * and NEWGAME oracles (the JS mirror is sim_trace.py's proj()) */
static void print_projection(int job_convert) {
    {
        const PowerRecord *p = colopy_power(cs_nation());
        printf("{\"turn\":%u,\"year\":%u,\"season\":%u,\"rng\":%u,"
               "\"gold\":%d,\"fund\":%d,\"tax\":%u,\"unpaid\":%u,",
               cs_turn(), cs_year(), cs_season(), CS.rng, p->gold,
               p->kings_fund, p->tax_rate, CR.upkeep_unpaid);
        /* the tutorial's three flag homes (sim_trace tutm/once/gopt):
         * the [0x5386/7] shown word, the [0x5380] once byte, the
         * [0x5382] options word whose 0x80 gates the lessons */
        printf("\"tutm\":%u,\"once\":%u,\"gopt\":%u,",
               cs_tut_mask(), CS.globals[0], CR.game_options);
        /* every power's market row + pool, and the rivals' gold (the JS
         * mkt/acc/rmkt/racc/rgold) — per-power market parity (B3.6) */
        printf("\"mkt\":[");
        for (int g = 0; g < N_GOODS; g++)
            printf("%s%u", g ? "," : "", p->price_level[g]);
        printf("],\"acc\":[");
        for (int g = 0; g < N_GOODS; g++)
            printf("%s%d", g ? "," : "", (int)(int16_t)p->traffic[g]);
        printf("],\"rmkt\":[");
        for (int q = 0; q < 4; q++) {
            printf("%s[", q ? "," : "");
            for (int g = 0; g < N_GOODS; g++)
                printf("%s%u", g ? "," : "", CS.powers[q].price_level[g]);
            printf("]");
        }
        printf("],\"racc\":[");
        for (int q = 0; q < 4; q++) {
            printf("%s[", q ? "," : "");
            for (int g = 0; g < N_GOODS; g++)
                printf("%s%d", g ? "," : "",
                       (int)(int16_t)CS.powers[q].traffic[g]);
            printf("]");
        }
        printf("],\"rgold\":[");
        {
            int fr = 1;
            for (int q = 0; q < 4; q++) {
                if (q == (int)cs_nation()) continue;
                printf("%s%d", fr ? "" : ",", CR.rivals[q].gold);
                fr = 0;
            }
        }
        printf("],\"war\":[");
        for (int a = 0; a < 4; a++) {
            printf("%s[", a ? "," : "");
            for (int b = 0; b < 4; b++)
                printf("%s%u", b ? "," : "", CR.war_matrix[a][b]);
            printf("]");
        }
        printf("],\"treaty\":[");
        for (int a = 0; a < 4; a++) {
            printf("%s[", a ? "," : "");
            for (int b = 0; b < 4; b++)
                printf("%s%u", b ? "," : "", CR.treaty_matrix[a][b]);
            printf("]");
        }
        printf("],\"rtimer\":[");
        for (int a = 0; a < 4; a++) {
            printf("%s[", a ? "," : "");
            for (int b = 0; b < 4; b++)
                printf("%s%u", b ? "," : "", CR.rel_timer[a][b]);
            printf("]");
        }
        printf("],\"rcol\":[");
        {
            /* the rivals' FULL colonies, rival by rival in record order
             * (the JS r.colonies keeps import = record order) */
            int fr = 1;
            for (int q = 0; q < 4; q++) {
                if (q == (int)cs_nation()) continue;
                for (int ci = 0; ci < CS.n_colonies; ci++) {
                    const ColonyRecord *c = &CS.colonies[ci];
                    if ((c->owner_power & 3) != q) continue;
                    printf("%s{\"name\":\"%.24s\",\"pop\":%u,"
                           "\"hammers\":%u,\"fe\":[%d,%d],\"stock\":[",
                           fr ? "" : ",", c->name, c->population,
                           c->hammers, CR.col[ci].dbg_food,
                           CR.col[ci].dbg_eat);
                    fr = 0;
                    for (int g = 0; g < N_GOODS; g++)
                        printf("%s%u", g ? "," : "", c->stock[g]);
                    printf("]}");
                }
            }
        }
        printf("],\"colonies\":[");
        int first = 1;
        for (int ci = 0; ci < CS.n_colonies; ci++) {
            const ColonyRecord *c = &CS.colonies[ci];
            if ((c->owner_power & 3) != cs_nation()) continue;
            printf("%s{\"name\":\"%.24s\",\"pop\":%u,\"sol\":%u,"
                   "\"hammers\":%u,\"bip\":%d,\"stock\":[",
                   first ? "" : ",", c->name, c->population, CR.col[ci].sol,
                   c->hammers,
                   c->building_in_production < DAT_BUILDINGS_COUNT ?
                       c->building_in_production : -1);
            first = 0;
            for (int g = 0; g < N_GOODS; g++)
                printf("%s%u", g ? "," : "", c->stock[g]);
            printf("],\"bld\":[");
            /* Mirror the JS projection exactly: the RUNTIME building list,
             * names collapsed to their FIRST @BUILDING row (upgrade tiers
             * reuse display names -- rows 9..11 are all "Town Hall"), then
             * dedup + sort. */
            {
                uint64_t first = 0;
                for (int k = 0; k < CR.col[ci].n_bld; k++)
                    first |= 1ull << bld_first_row(CR.col[ci].bld[k]);
                int fb = 1;
                for (int b = 0; b < DAT_BUILDINGS_COUNT; b++)
                    if ((first >> b) & 1) {
                        printf("%s%d", fb ? "" : ",", b);
                        fb = 0;
                    }
            }
            printf("]}");
        }
        printf("],\"crosses\":%d,\"bellsTotal\":%d,\"bells\":%u,"
               "\"fip\":%d,\"fathers\":[",
               CR.crosses, CR.bells_total, p->bells, CR.father_in_progress);
        first = 1;
        for (int i = 0; i < DAT_FATHERS_COUNT; i++)
            if ((p->founding_fathers >> i) & 1) {
                printf("%s%d", first ? "" : ",", i);
                first = 0;
            }
        printf("],\"dock\":[");
        for (int d = 0; d < 3; d++)
            printf("%s\"%s\"", d ? "," : "", immigrant_name(&CR.dock[d]));
        printf("],\"dockUnits\":[");
        for (int d = 0; d < CR.n_dock_units; d++)
            printf("%s\"%s\"", d ? "," : "", immigrant_name(&CR.dock_units[d]));
        printf("],\"tension\":[");
        for (int d = 0; d < 8; d++)
            printf("%s%u", d ? "," : "", CR.tension[d]);
        printf("],\"frac\":[");
        for (int d = 0; d < 8; d++)
            printf("%s%u", d ? "," : "", CR.tribe_frac[d]);
        /* villages [pop, growth, alarm, mission|-1, braveOwed] */
        printf("],\"villages\":[");
        for (int v = 0; v < CS.n_villages; v++) {
            const NativeSettlement *vs = &CS.villages[v];
            printf("%s[%u,%u,%u,%d,%u]", v ? "," : "", vs->population,
                   vs->growth, CR.alarm[v],
                   vs->mission == 0xFF ? -1 : (vs->mission & 0x1F),
                   CR.brave_owed[v]);
        }
        /* natives (braves) [x, y, heading|-1] in G.natives order */
        printf("],\"natives\":[");
        first = 1;
        for (int k = 0; k < CR.n_natives; k++) {
            int ui = CR.natives_order[k];
            printf("%s[%u,%u,%d]", first ? "" : ",", CS.units[ui].map_x,
                   CS.units[ui].map_y,
                   CR.native_heading[ui] == 0xFF ? -1
                                                 : CR.native_heading[ui]);
            first = 0;
        }
        /* the JS G.units census + per-unit command state (slice 2) —
         * [x, y, orders, work, movesLeft] in G.units insertion order */
        printf("],\"punits\":[");
        for (int k = 0; k < CR.n_units_order; k++) {
            int ui = CR.units_order[k];
            printf("%s[%u,%u,%u,%u,", k ? "," : "", CS.units[ui].map_x,
                   CS.units[ui].map_y, CS.units[ui].orders,
                   CR.unit_work[ui]);
            /* a rival-born member's movesLeft is UNDEFINED after its
             * first refresh (no u.moves on the JS object) — JSON null */
            if (CR.unit_moves_undef[ui]) printf("null");
            else printf("%u", CS.units[ui].moves_remaining);
            printf(",%u,%d]", CS.units[ui].tools,
                   /* 0 = Expert Farmers counts; 28 = none (C4.26) */
                   CS.units[ui].profession < DAT_JOBEXPERT_COUNT
                       ? CS.units[ui].profession : -1);
        }
        printf("],\"woi\":[%u,%u,%d,%d,%d,%d,%d],\"refs\":[",
               CR.woi_flags, CR.razed, CR.royal_fund, CR.ref_pool[0],
               CR.ref_pool[1], CR.ref_pool[2], CR.ref_pool[3]);
        for (int k = 0; k < CR.n_refs; k++) {
            int ui = CR.refs_order[k];
            printf("%s[%u,%u,%u]", k ? "," : "", CS.units[ui].map_x,
                   CS.units[ui].map_y, CS.units[ui].type);
        }
        printf("],\"holds\":[");
        for (int k = 0; k < CR.n_units_order; k++) {
            int ui = CR.units_order[k];
            printf("%s[", k ? "," : "");
            for (int h = 0; h < CR.unit_n_hold[ui]; h++)
                printf("%s[%u,%d]", h ? "," : "", CR.unit_hold[ui][h].good,
                       CR.unit_hold[ui][h].qty);
            printf("]");
        }
        printf("],\"europe\":[");
        for (int k = 0; k < CR.n_europe; k++) {
            const euro_crossing *e = &CR.europe[k];
            printf("%s[%u,%u,%u,[", k ? "," : "", e->type, e->state,
                   e->state == 0 ? 0 : e->turns);
            for (int h = 0; h < e->n_hold; h++)
                printf("%s[%u,%d]", h ? "," : "", e->hold[h].good,
                       e->hold[h].qty);
            printf("],%u]", e->n_pass);
        }
        {
            int nu = 0;
            for (int ui = 0; ui < CS.n_units; ui++)
                if (unit_on_map_player(ui)) nu++;
            printf("],\"units\":%d,\"converts\":[", nu);
        }
        first = 1;
        for (int ui = 0; ui < CS.n_units; ui++) {
            const UnitRecord *u = &CS.units[ui];
            if (!unit_on_map_player(ui) || u->profession != job_convert)
                continue;
            printf("%s[%u,%u,%d]", first ? "" : ",", u->map_x, u->map_y,
                   CR.unit_work[ui] ? CR.unit_work[ui] : -1);
            first = 0;
        }
        /* rivals in nation order (the JS G.rivals build order); units in
         * the r.units order = ships then land, each record-ascending */
        printf("],\"rivals\":[");
        first = 1;
        for (int rn = 0; rn < 4; rn++) {
            if (rn == (int)cs_nation()) continue;
            const rival_rt *r = &CR.rivals[rn];
            printf("%s{\"n\":%d,\"cols\":[", first ? "" : ",", rn);
            first = 0;
            for (int k = 0; k < r->n_col; k++)
                printf("%s[%d,%d]", k ? "," : "", r->col[k].x, r->col[k].y);
            printf("],\"units\":[");
            int fu = 1;
            for (int k = 0; k < CR.n_runits[rn]; k++) {
                int ui = CR.runits_order[rn][k];     /* r.units order */
                printf("%s[%d,%d,%d]", fu ? "" : ",", CR.runit_x[ui],
                       CR.runit_y[ui], CS.units[ui].type);
                fu = 0;
            }
            printf("],\"greeted\":%u,\"lock\":%u}", r->greeted,
                   CR.parley_lock[rn]);
        }
        {
            uint32_t h = 2166136261u;
            for (int i = 0; i < COLOPY_PLANE; i++) {
                h ^= CS.terrain[i]; h *= 16777619u;
                h ^= (uint8_t)(CS.improve[i] & 0xC8); h *= 16777619u;
            }
            printf("],\"maphash\":%u", h);
        }
        printf(",\"events\":[");
        colopy_event e;
        first = 1;
        while (colopy_next_event(&e)) {
            printf("%s\"%s\"", first ? "" : ",", e.key);
            first = 0;
        }
        /* the ACTION sound cues fired this turn (sim_trace's `sx`): verb
         * letter + hex arg — p play, q queue-tune, o class one-shot, r
         * class request, s class set, t pick, w switches */
        printf("],\"sx\":[");
        colopy_sound snd;
        first = 1;
        while (colopy_next_sound(&snd)) {
            printf("%s\"%c%X\"", first ? "" : ",", "pqorstw"[snd.verb % 7],
                   snd.arg);
            first = 0;
        }
        printf("]}\n");
    }
}

static void dump_newgame(int nation, int diff, int n) {
    colopy_init(1653);                       /* the shared trace seed */
    colopy_new_game((uint8_t)nation, (uint8_t)diff, 0);
    int job_convert = -1;
    for (int i = 0; i < DAT_JOBEXPERT_COUNT; i++)
        if (strcmp(dat_jobexpert[i], "Indian Converts") == 0) job_convert = i;
    print_projection(job_convert);           /* the fresh state, turn 0 */
    for (int t = 0; t < n; t++) {
        turn_step_prefix();
        turn_step2();
        turn_step3();
        turn_step5();
        print_projection(job_convert);
    }
}

int main(int argc, char **argv) {
    /* --pak FILE: validate COLOPY.PAK and dump its census (Phase 6) */
    if (argc > 2 && strcmp(argv[1], "--pak") == 0) {
        extern int pak_check_main(const char *path);
        return pak_check_main(argv[2]);
    }
    /* --audio: deterministic cport/audio engine tests (audio milestone) */
    if (argc > 1 && strcmp(argv[1], "--audio") == 0) {
        extern int audio_smoke_main(void);
        return audio_smoke_main();
    }
    /* --audiopak FILE [COLDIG.BIN]: validate COLAUDIO.PAK; with the bank
     * present also prove every PCM payload is a verbatim slice */
    if (argc > 2 && strcmp(argv[1], "--audiopak") == 0) {
        extern int audio_pak_check_main(const char *path, const char *coldig);
        return audio_pak_check_main(argv[2], argc > 3 ? argv[3] : 0);
    }
    /* --render PAK OUT.ppm: Phase-7 render-core selftest scene */
    if (argc > 3 && strcmp(argv[1], "--render") == 0) {
        extern int render_smoke_main(const char *pak, const char *out);
        return render_smoke_main(argv[2], argv[3]);
    }
    /* --rendermap SAVE PAK OUT.ppm VX VY [SEL [MENU MSEL [BLINK]]] */
    if (argc > 6 && strcmp(argv[1], "--rendermap") == 0) {
        extern int render_map_main(const char *save, const char *pak,
                                   const char *out, int vx, int vy, int sel,
                                   int menu, int msel, int blink);
        return render_map_main(argv[2], argv[3], argv[4], atoi(argv[5]),
                               atoi(argv[6]), argc > 7 ? atoi(argv[7]) : 0,
                               argc > 8 ? atoi(argv[8]) : -1,
                               argc > 9 ? atoi(argv[9]) : 0,
                               argc > 10 ? atoi(argv[10]) : 1);
    }
    /* --rendercolony SAVE PAK OUT.ppm CI [CSEL SHIPSEL VIEW NUM] */
    if (argc > 5 && strcmp(argv[1], "--rendercolony") == 0) {
        extern int render_colony_main(const char *save, const char *pak,
                                      const char *out, int ci, int csel,
                                      int ship_sel, int view, int numbers);
        return render_colony_main(argv[2], argv[3], argv[4], atoi(argv[5]),
                                  argc > 6 ? atoi(argv[6]) : -1,
                                  argc > 7 ? atoi(argv[7]) : 0,
                                  argc > 8 ? atoi(argv[8]) : 0,
                                  argc > 9 ? atoi(argv[9]) : 1);
    }
    /* --rendereurope SAVE PAK OUT.ppm [SHIP DOCKSEL ROW MARKETSEL] */
    if (argc > 4 && strcmp(argv[1], "--rendereurope") == 0) {
        extern int render_europe_main(const char *save, const char *pak,
                                      const char *out, int euro_ship,
                                      int dock_sel, int euro_row,
                                      int market_sel);
        return render_europe_main(argv[2], argv[3], argv[4],
                                  argc > 5 ? atoi(argv[5]) : 0,
                                  argc > 6 ? atoi(argv[6]) : 0,
                                  argc > 7 ? atoi(argv[7]) : 0,
                                  argc > 8 ? atoi(argv[8]) : -1);
    }
    if (argc > 2 && strcmp(argv[1], "--reportprobe") == 0) {
        extern void rm_report_probe(void);
        if (strcmp(argv[2], "sav1653") == 0) colopy_load_sav(sav1653, sizeof(sav1653));
        else colopy_load_sav(savnewcolony, sizeof(savnewcolony));
        colopy_init(1653);
        units_session_seed();
        rm_report_probe();
        { extern void rm_score_probe(void); rm_score_probe(); }
        return 0;
    }
    /* --input [SAVE]: keyboard-event oracle (events on stdin) */
    if (argc > 1 && strcmp(argv[1], "--input") == 0) {
        extern int input_main(const char *save);
        return input_main(argc > 2 ? argv[2] : 0);
    }
    /* --renderboot KIND PAK OUT.ppm ARG */
    if (argc > 5 && strcmp(argv[1], "--renderboot") == 0) {
        extern int render_boot_main(const char *kind, const char *pak,
                                    const char *out, int arg);
        return render_boot_main(argv[2], argv[3], argv[4], atoi(argv[5]));
    }
    /* --rendercongress SAVE PAK OUT.ppm MASK (Part E plate pages) */
    if (argc > 5 && strcmp(argv[1], "--rendercongress") == 0) {
        extern int render_congress_main(const char *save, const char *pak,
                                        const char *out, long mask);
        return render_congress_main(argv[2], argv[3], argv[4],
                                    atol(argv[5]));
    }
    /* --renderdeclaration SAVE PAK OUT.ppm NAME STEP */
    if (argc > 6 && strcmp(argv[1], "--renderdeclaration") == 0) {
        extern int render_declaration_main(const char *save, const char *pak,
                                           const char *out, const char *name,
                                           int step);
        return render_declaration_main(argv[2], argv[3], argv[4], argv[5],
                                       atoi(argv[6]));
    }
    /* --renderscore SAVE PAK OUT.ppm PANEL NAME */
    if (argc > 6 && strcmp(argv[1], "--renderscore") == 0) {
        extern int render_score_main(const char *save, const char *pak,
                                     const char *out, int panel,
                                     const char *name);
        return render_score_main(argv[2], argv[3], argv[4], atoi(argv[5]),
                                 argv[6]);
    }
    /* --renderendking SAVE PAK OUT.ppm WIN */
    if (argc > 5 && strcmp(argv[1], "--renderendking") == 0) {
        extern int render_endking_main(const char *save, const char *pak,
                                       const char *out, int win);
        return render_endking_main(argv[2], argv[3], argv[4], atoi(argv[5]));
    }
    /* --renderlogo PAK OUT.ppm TICK */
    if (argc > 4 && strcmp(argv[1], "--renderlogo") == 0) {
        extern int render_logo_main(const char *pak, const char *out,
                                    int tick);
        return render_logo_main(argv[2], argv[3], atoi(argv[4]));
    }
    /* --renderwoodcut SAVE PAK OUT.ppm N */
    if (argc > 5 && strcmp(argv[1], "--renderwoodcut") == 0) {
        extern int render_woodcut_main(const char *save, const char *pak,
                                       const char *out, int n);
        return render_woodcut_main(argv[2], argv[3], argv[4], atoi(argv[5]));
    }
    /* --renderreport SAVE PAK OUT.ppm FK [SYNTH] */
    if (argc > 5 && strcmp(argv[1], "--renderreport") == 0) {
        extern int render_report_main(const char *save, const char *pak,
                                      const char *out, const char *fk,
                                      const char *synth);
        return render_report_main(argv[2], argv[3], argv[4], argv[5],
                                  argc > 6 ? argv[6] : 0);
    }
    /* --renderevent SAVE PAK OUT.ppm KEY MODE SEL [SPEAKER] */
    if (argc > 7 && strcmp(argv[1], "--renderevent") == 0) {
        extern int render_event_main(const char *save, const char *pak,
                                     const char *out, const char *key,
                                     int mode, int sel, const char *spk);
        return render_event_main(argv[2], argv[3], argv[4], argv[5],
                                 atoi(argv[6]), atoi(argv[7]),
                                 argc > 8 ? argv[8] : 0);
    }
    if (argc > 3 && strcmp(argv[1], "--newgame") == 0) {
        dump_newgame(atoi(argv[2]), atoi(argv[3]),
                     argc > 4 ? atoi(argv[4]) : 0);
        return 0;
    }
    if (argc > 3 && strcmp(argv[1], "--turns") == 0) {
        int agitate = 0, script = 0;
        for (int i = 4; i < argc; i++) {
            if (strcmp(argv[i], "agitate") == 0) agitate = 1;
            if (strcmp(argv[i], "script") == 0) script = 1;
        }
        dump_turns(argv[2], atoi(argv[3]), agitate, script);
        return 0;
    }
    /* --savfile IN OUT: load any .SAV from disk, print the decoded route
     * table / route-bound units / unit build targets (C3.7), write the
     * image back to OUT and report whether it is byte-identical. */
    if (argc > 3 && strcmp(argv[1], "--savfile") == 0) {
        static uint8_t in[80000], out[80000];
        FILE *f = fopen(argv[2], "rb");
        if (!f) { printf("no such file: %s\n", argv[2]); return 1; }
        size_t n = fread(in, 1, sizeof(in), f);
        fclose(f);
        colopy_status st = colopy_load_sav(in, n);
        if (st != COLOPY_OK) { printf("load failed: %d\n", (int)st); return 1; }
        printf("routes %d\n", CR.n_routes);
        for (int r = 0; r < CR.n_routes; r++) {
            const struct colopy_route *rt = &CR.routes[r];
            printf(" [%d] \"%s\" %s stops", r, rt->name, rt->sea ? "sea" : "land");
            for (int k = 0; k < rt->n_stops; k++) {
                printf(" %d(L", rt->stops[k]);
                for (int j = 0; j < rt->n_load[k]; j++)
                    printf("%s%d", j ? "," : "", rt->load[k][j]);
                printf("/U");
                for (int j = 0; j < rt->n_unload[k]; j++)
                    printf("%s%d", j ? "," : "", rt->unload[k][j]);
                printf(")");
            }
            printf("\n");
        }
        for (int i = 0; i < CS.n_units; i++)
            if (CR.unit_route[i] >= 0)
                printf(" unit %d %s route %d stop %d orders %d\n", i,
                       dat_units[CS.units[i].type].name, CR.unit_route[i],
                       CR.unit_stop_index[i], CS.units[i].orders);
        for (int i = 0; i < CS.n_colonies; i++) {
            int t = build_target_unit_type(CS.colonies[i].building_in_production);
            if (t >= 0)
                printf(" colony %d %.24s builds %s (0x%02X)\n", i,
                       CS.colonies[i].name, dat_units[t].name,
                       CS.colonies[i].building_in_production);
        }
        size_t m = colopy_save_sav(out, sizeof(out));
        int same = m == n && memcmp(in, out, n) == 0;
        printf("roundtrip %s (%u -> %u bytes)\n", same ? "byte-exact" : "DIFFERS",
               (unsigned)n, (unsigned)m);
        if (!same)
            for (size_t k = 0; k < n && k < m; k++)
                if (in[k] != out[k]) { printf(" first diff at 0x%X\n", (unsigned)k); break; }
        f = fopen(argv[3], "wb");
        if (f) { fwrite(out, 1, m, f); fclose(f); }
        return same ? 0 : 1;
    }
    /* --saveout SAVE N FILE: run N full turns, write the .SAV image —
     * the Phase-3 cross-load acceptance (the JS port must import it). */
    if (argc > 4 && strcmp(argv[1], "--saveout") == 0) {
        if (strcmp(argv[2], "sav1653") == 0) colopy_load_sav(sav1653, sizeof(sav1653));
        else if (strcmp(argv[2], "savraleigh") == 0) colopy_load_sav(savraleigh, sizeof(savraleigh));
        else colopy_load_sav(savnewcolony, sizeof(savnewcolony));
        colopy_init(1653);
        units_session_seed();
        CR.n_dock_units = 0;   /* mirror of the trace preamble */
        CR.crosses = 0;
        CR.cross_threshold = 0;
        for (int d = 0; d < 3; d++) roll_immigrant(&CR.dock[d]);
        for (int t = 0; t < atoi(argv[3]); t++) {
            turn_step_prefix();
            turn_step2();
            turn_step3();
            turn_step5();
        }
        static uint8_t out[80000];
        size_t n = colopy_save_sav(out, sizeof(out));
        FILE *f = fopen(argv[4], "wb");
        if (!f || fwrite(out, 1, n, f) != n) { printf("WRITE FAIL\n"); return 1; }
        fclose(f);
        printf("wrote %u bytes, digest %08X\n", (unsigned)n, colopy_digest());
        return 0;
    }
    if (argc > 1 && strcmp(argv[1], "--movecost") == 0) { dump_movecost(); return 0; }
    if (argc > 1 && strcmp(argv[1], "--combat") == 0) { dump_combat(); return 0; }
    if (argc > 1 && strcmp(argv[1], "--produce") == 0) {
        dump_produce();
        return 0;
    }
    if (argc > 1 && strcmp(argv[1], "--market") == 0) {
        dump_market();
        return 0;
    }
    if (argc > 1 && strcmp(argv[1], "--raid") == 0) {
        dump_raid();
        return 0;
    }
    /* record strides are compile-time asserted; spot-check the data. */
    CHECK(DAT_MAP_W * DAT_MAP_H == (int)sizeof(dat_map_tiles) /
          (int)sizeof(dat_map_tiles[0]) * 1, "map size");
    CHECK(strcmp(dat_nations[0].country, "England") == 0,
          "nations[0] = %s", dat_nations[0].country);
    CHECK(DAT_CARGO_COUNT == 16, "16 goods");
    CHECK(DAT_UNITS_COUNT == 23, "23 unit types");
    CHECK(DAT_BUILDINGS_COUNT == 42, "42 buildings");
    /* price ladder oracle from spec/systems/colony.md §PowerRecord:
     * initial price_level bytes [1,6,5,5,5,2,6,20,3,10,11,12,15,2,2,3]
     * derive from @CARGO start windows; check the @CARGO table carries the
     * fields the ladder needs. */
    CHECK(dat_cargo[7].start1 == 19 || dat_cargo[7].start1 > 0,
          "silver start window present (%d)", dat_cargo[7].start1);
    /* fixtures decoded */
    CHECK(memcmp(savstart, "COLONIZE", 8) == 0, "savStart magic");
    CHECK(memcmp(sav1653, "COLONIZE", 8) == 0, "sav1653 magic");

    /* Phase 1 acceptance: .SAV load -> save -> byte-exact on every fixture.
     * Proves the record strides, block sizes, and count handling all agree
     * with the real engine's serializer output. */
    struct { const char *name; const uint8_t *buf; size_t len; } savs[] = {
        {"savstart", savstart, sizeof(savstart)},
        {"sav1653", sav1653, sizeof(sav1653)},
        {"savraleigh", savraleigh, sizeof(savraleigh)},
        {"savnewcolony", savnewcolony, sizeof(savnewcolony)},
    };
    static uint8_t out[80000];
    for (unsigned i = 0; i < sizeof(savs) / sizeof(savs[0]); i++) {
        colopy_status st = colopy_load_sav(savs[i].buf, savs[i].len);
        CHECK(st == COLOPY_OK, "%s load (status %d)", savs[i].name, st);
        if (st != COLOPY_OK) continue;
        size_t n = colopy_save_sav(out, sizeof(out));
        CHECK(n == savs[i].len, "%s size: wrote %u of %u", savs[i].name,
              (unsigned)n, (unsigned)savs[i].len);
        if (n == savs[i].len) {
            int diff = -1;
            for (size_t k = 0; k < n; k++)
                if (out[k] != savs[i].buf[k]) { diff = (int)k; break; }
            CHECK(diff < 0, "%s roundtrip differs at byte 0x%X",
                  savs[i].name, diff);
        }
        colopy_overview ov; colopy_get_overview(&ov);
        printf("  %-13s year %d s%d turn %3u  units %3u colonies %2u "
               "villages %2u  tax %2u%%  digest %08X\n",
               savs[i].name, ov.year, ov.season, ov.turn, ov.n_units,
               ov.n_colonies, ov.n_settlements, ov.tax_rate, colopy_digest());
    }

    /* C3.7 (2026-09-02): the unit-build target and the trade-route table
     * ride IN the .SAV — +0x94 = 0x2A + (type - 0x0B) (func_00B5A8) and
     * the trailing 12 x 0x4A route block (@0x073A73) plus the carriers'
     * +0x17 route/stop nibbles (func_0075D4/func_0075FE).  Plant both
     * kinds of state, serialise, wipe, reload, compare.  The byte-exact
     * check above still runs on the untouched fixtures. */
    {
        colopy_load_sav(savraleigh, sizeof(savraleigh));
        CHECK(CS.n_colonies > 0, "savtail: fixture has colonies");
        CHECK(CS.tail_len == 1502, "savtail: fixture tail is 1502 bytes");
        CHECK(build_target_unit_type(0x2C) == 0x0D &&
              strcmp(dat_units[0x0D].name, "Caravel") == 0,
              "savtail: 0x2C decodes as the Caravel");
        CHECK(build_target_unit_type(0x29) < 0 && build_target_unit_type(0x31) < 0
              && build_target_unit_type(0xFF) < 0,
              "savtail: building ids / none are not unit targets");
        CS.colonies[0].building_in_production = build_target_for_unit_type(0x0D);
        CR.n_routes = 2;
        memcpy(CR.routes[0].name, "Sugar Run", 10);
        CR.routes[0].sea = 1;
        CR.routes[0].n_stops = 2;
        CR.routes[0].stops[0] = 0;
        CR.routes[0].stops[1] = 999;                    /* Europe */
        CR.routes[0].n_load[0] = 2;
        CR.routes[0].load[0][0] = 3; CR.routes[0].load[0][1] = 5;
        CR.routes[0].n_unload[1] = 1;
        CR.routes[0].unload[1][0] = 14;
        memcpy(CR.routes[1].name, "Ore Loop", 9);
        CR.routes[1].sea = 0;
        CR.routes[1].n_stops = 1;
        CR.routes[1].stops[0] = 1;
        int carrier = -1;
        for (int i = 0; i < CS.n_units && carrier < 0; i++)
            if (dat_units[CS.units[i].type].cargo > 0 &&
                (CS.units[i].owner_flags & 0x0F) == cs_nation()) carrier = i;
        CHECK(carrier >= 0, "savtail: fixture has a carrier");
        CR.unit_route[carrier] = 1;
        CR.unit_stop_index[carrier] = 0;
        CS.units[carrier].orders = 2;

        static uint8_t img[80000];
        size_t sn = colopy_save_sav(img, sizeof(img));
        CHECK(sn == sizeof(savraleigh), "savtail: image keeps the file size");
        CHECK(img[SAV_PRELUDE + 0x20] == 2, "savtail: [0x53A0] route count written");

        colopy_load_sav(savraleigh, sizeof(savraleigh));  /* wipe */
        CHECK(CS.colonies[0].building_in_production != 0x2C,
              "savtail: reload cleared the build target");
        CHECK(CR.n_routes == 0, "savtail: reload cleared the routes");

        CHECK(colopy_load_sav(img, sn) == COLOPY_OK, "savtail: image loads");
        CHECK(CS.colonies[0].building_in_production == 0x2C,
              "savtail: build target restored (0x2A + 2 = Caravel)");
        CHECK(CR.n_routes == 2, "savtail: route count restored");
        CHECK(strcmp(CR.routes[0].name, "Sugar Run") == 0,
              "savtail: route 0 name restored");
        CHECK(CR.routes[0].sea == 1 && CR.routes[0].stops[1] == 999,
              "savtail: the Europe stop survived");
        CHECK(CR.routes[0].n_load[0] == 2 && CR.routes[0].load[0][1] == 5 &&
              CR.routes[0].n_unload[1] == 1 && CR.routes[0].unload[1][0] == 14,
              "savtail: cargo lanes restored");
        CHECK(CR.routes[1].sea == 0 && CR.routes[1].n_stops == 1 &&
              CR.routes[1].stops[0] == 1,
              "savtail: route 1 restored");
        CHECK(CR.unit_route[carrier] == 1 && CS.units[carrier].orders == 2,
              "savtail: unit binding restored from +0x17 / orders 2");

        /* C3.5: route deletion per func_0612E6 — the carrier on the
         * deleted route is unbound (orders 2 -> 0), a carrier on a HIGHER
         * route is renumbered; stop deletion per func_06046E and the
         * colony removal fixup func_02EE34 (stop == idx deleted, > idx
         * renumbered, tile bit 0x02 cleared).  On the 1653 game, which
         * has several Dutch ships. */
        colopy_load_sav(sav1653, sizeof(sav1653));
        CR.n_routes = 3;
        memcpy(CR.routes[0].name, "First", 6);
        CR.routes[0].sea = 1; CR.routes[0].n_stops = 2;
        CR.routes[0].stops[0] = 0; CR.routes[0].stops[1] = 999;
        memcpy(CR.routes[1].name, "Second", 7);
        CR.routes[1].sea = 1; CR.routes[1].n_stops = 2;
        CR.routes[1].stops[0] = 3; CR.routes[1].stops[1] = 999;
        memcpy(CR.routes[2].name, "Third", 6);
        CR.routes[2].sea = 1; CR.routes[2].n_stops = 3;
        CR.routes[2].stops[0] = 999; CR.routes[2].stops[1] = 2; CR.routes[2].stops[2] = 1;
        int c1 = -1, c2 = -1;
        for (int i = 0; i < CS.n_units; i++) {
            if (!(dat_units[CS.units[i].type].cargo > 0) ||
                (CS.units[i].owner_flags & 0x0F) != cs_nation()) continue;
            if (c1 < 0) c1 = i; else if (c2 < 0) c2 = i;
        }
        CHECK(c1 >= 0 && c2 >= 0, "routes: the 1653 game has two Dutch carriers");
        CR.unit_route[c1] = 1; CR.unit_stop_index[c1] = 1; CS.units[c1].orders = 2;
        CR.unit_route[c2] = 2; CR.unit_stop_index[c2] = 2; CS.units[c2].orders = 2;
        route_delete(1);
        CHECK(CR.n_routes == 2 && strcmp(CR.routes[1].name, "Third") == 0,
              "routes: delete spliced the table");
        CHECK(CR.unit_route[c1] == -1 && CS.units[c1].orders == 0 &&
              CR.unit_stop_index[c1] == 0,
              "routes: the carrier on the deleted route is unbound");
        CHECK(CR.unit_route[c2] == 1 && CS.units[c2].orders == 2,
              "routes: a carrier on a higher route is renumbered");
        /* remove player colony ordinal 1: route 1's stop [2] == 1 is
         * deleted, stop [1] == 2 becomes 1; the carrier's stop index 2
         * steps back to 1 */
        int rec1 = -1, seen = -1;
        for (int i = 0; i < CS.n_colonies && rec1 < 0; i++)
            if ((CS.colonies[i].owner_power & 3) == cs_nation() && ++seen == 1) rec1 = i;
        CHECK(rec1 >= 0, "routes: fixture has two player colonies");
        {
            int ti = CS.colonies[rec1].map_y * COLOPY_MAP_W + CS.colonies[rec1].map_x;
            CS.improve[ti] |= 0x02;
            colony_remove(rec1);
            CHECK(!(CS.improve[ti] & 0x02), "routes: colony tile bit 0x02 cleared");
        }
        CHECK(CR.routes[1].n_stops == 2 && CR.routes[1].stops[0] == 999 &&
              CR.routes[1].stops[1] == 1,
              "routes: stop == idx deleted, stop > idx renumbered");
        CHECK(CR.unit_stop_index[c2] == 1,
              "routes: the carrier's stop nibble stepped back");
    }

    /* C3.1: the last colonist out — validator order func_025A1E
     * (Stockade & size <= 3 -> 21, siege -> 20, size 1 -> 3) and the
     * eject op func_009318 mode 2 emptying the colony -> record gone. */
    {
        colopy_load_sav(savnewcolony, sizeof(savnewcolony));
        int ci = -1;
        for (int i = 0; i < CS.n_colonies && ci < 0; i++)
            if ((CS.colonies[i].owner_power & 3) == cs_nation() &&
                CS.colonies[i].population == 1) ci = i;
        CHECK(ci >= 0, "lastout: savnewcolony has a size-1 player colony");
        int ncol = CS.n_colonies, nunits = CS.n_units;
        CHECK(colony_siege_excess(ci) == 0, "lastout: no siege on the fixture");
        CHECK(colonist_out_refusal(ci, 0x13) == 3, "lastout: size 1 -> code 3 (@ABANDON)");
        CS.colonies[ci].buildings[0] |= 0x01;            /* Stockade bit */
        colony_bld_seed(ci);                             /* runtime list */
        CHECK(colonist_out_refusal(ci, 0x13) == 21, "lastout: Stockade & size<=3 -> 21");
        CS.colonies[ci].buildings[0] &= (uint8_t)~0x01;
        colony_bld_seed(ci);
        CS.colonies[ci].stock[TOOLS] = 57;
        int x = CS.colonies[ci].map_x, y = CS.colonies[ci].map_y;
        int ui = colonist_eject(ci, 0, 0x14);            /* out as a Pioneer */
        CHECK(ui >= 0 && CS.units[ui].type == 2 && CS.units[ui].tools == 40 &&
              CS.units[ui].map_x == x && CS.units[ui].map_y == y,
              "lastout: a Pioneer with min(100, 57/20*20) = 40 tools on the tile");
        CHECK(CS.n_units == nunits + 1, "lastout: one unit spawned");
        CHECK(CS.n_colonies == ncol - 1, "lastout: the emptied colony record is gone");
    }

    /* Phase 2 slice 1: colony production. The full oracle is
     * tools/sim_compare.py (17 colonies, JS vs C, exact); this in-harness
     * check pins one value so `make test` alone catches a regression:
     * savnewcolony's pop-1 Jamestown = centre-only food 4 (the func_00A222
     * band model: forested centre band 2 + easy-difficulty 2). */
    colopy_load_sav(savnewcolony, sizeof(savnewcolony));
    {
        int found = 0;
        for (int i = 0; i < CS.n_colonies; i++) {
            const ColonyRecord *c = colopy_colony(i);
            if (strncmp(c->name, "Jamestown", 9) != 0) continue;
            if (c->owner_power != cs_nation()) continue;
            found = 1;
            colony_output r;
            colony_produce(i, &r);
            printf("  Jamestown pop %u  food %d (centre %d) hammers %d "
                   "bells %d crosses %d\n", c->population, r.out[FOOD],
                   r.centre, r.hammers, r.bells, r.crosses);
            CHECK(r.out[FOOD] == 4 && r.centre == 4,
                  "Jamestown food/centre: %d/%d != 4/4", r.out[FOOD], r.centre);
        }
        CHECK(found, "Jamestown present in savnewcolony");
    }

    printf("state footprint: %u bytes\n", (unsigned)sizeof(colopy_state));
    printf(fail ? "%d CHECKS FAILED\n" : "cport smoke: all checks pass\n",
           fail);
    return fail != 0;
}
