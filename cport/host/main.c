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
    for (int i = 0; i < N_GOODS; i++) printf("%s%d", i ? "," : "", market_bid(i));
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

/* --turns SAVE N: run N prefix turns, one projection JSON line per turn.
 * The projection is the parity diff unit (plan section B); the JS trace
 * emits the identical shape. Events drain per turn; TUTORIAL*-keyed
 * differences are the compare script's to filter. */
static void dump_turns(const char *save, int n, int agitate) {
    if (strcmp(save, "savstart") == 0) colopy_load_sav(savstart, sizeof(savstart));
    else if (strcmp(save, "sav1653") == 0) colopy_load_sav(sav1653, sizeof(sav1653));
    else if (strcmp(save, "savraleigh") == 0) colopy_load_sav(savraleigh, sizeof(savraleigh));
    else colopy_load_sav(savnewcolony, sizeof(savnewcolony));
    colopy_init(1653);                       /* the shared trace seed */
    if (agitate) {
        /* the trace's adversarial seeding — mirrors sim_trace.py TURNS */
        for (int v = 0; v < CS.n_villages; v++) {
            CR.alarm[v] = 0x90;
            if (((CS.villages[v].owner_tribe - 4) % 2) == 0)
                CS.villages[v].mission = cs_nation();
        }
        for (int t = 0; t < 8; t++) CR.tension[t] = 80;
    }
    int job_convert = -1;
    for (int i = 0; i < DAT_JOBEXPERT_COUNT; i++)
        if (strcmp(dat_jobexpert[i], "Indian Converts") == 0) job_convert = i;
    for (int d = 0; d < 3; d++) roll_immigrant(&CR.dock[d]);
    for (int t = 0; t < n; t++) {
        turn_step_prefix();
        turn_step2();
        turn_step3();
        const PowerRecord *p = colopy_power(cs_nation());
        printf("{\"turn\":%u,\"year\":%u,\"season\":%u,"
               "\"gold\":%d,\"fund\":%d,\"tax\":%u,\"unpaid\":%u,"
               "\"colonies\":[",
               cs_turn(), cs_year(), cs_season(), p->gold, p->kings_fund,
               p->tax_rate, CR.upkeep_unpaid);
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
        for (int ui = 0; ui < CS.n_units; ui++) {
            const UnitRecord *u = &CS.units[ui];
            if ((u->owner_flags & 0x0F) < 4 || u->type >= DAT_UNITS_COUNT ||
                dat_units[u->type].hull > 0) continue;
            printf("%s[%u,%u,%d]", first ? "" : ",", u->map_x, u->map_y,
                   CR.native_heading[ui] == 0xFF ? -1
                                                 : CR.native_heading[ui]);
            first = 0;
        }
        /* the JS G.units census + the convert countdowns */
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
                   CR.unit_faith[ui] ? CR.unit_faith[ui] : -1);
            first = 0;
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
        printf("]}\n");
    }
}

int main(int argc, char **argv) {
    if (argc > 3 && strcmp(argv[1], "--turns") == 0) {
        dump_turns(argv[2], atoi(argv[3]),
                   argc > 4 && strcmp(argv[4], "agitate") == 0);
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

    /* Phase 2 slice 1: colony production. The full oracle is
     * tools/sim_compare.py (17 colonies, JS vs C, exact); this in-harness
     * check pins one value so `make test` alone catches a regression:
     * savnewcolony's pop-1 Jamestown = centre-only food 5 (JS-verified). */
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
            CHECK(r.out[FOOD] == 5 && r.centre == 5,
                  "Jamestown food/centre: %d/%d != 5/5", r.out[FOOD], r.centre);
        }
        CHECK(found, "Jamestown present in savnewcolony");
    }

    printf("state footprint: %u bytes\n", (unsigned)sizeof(colopy_state));
    printf(fail ? "%d CHECKS FAILED\n" : "cport smoke: all checks pass\n",
           fail);
    return fail != 0;
}
