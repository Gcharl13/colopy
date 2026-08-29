/* The Europe layer — Phase 5 slice 3.  Ports the game.js crossing and
 * harbour functions over CR.europe + the per-ship hold/passenger mirrors
 * (the record's cargo bytes cannot express a live hold list and stay
 * import-only):
 *   sailForEurope (3231) / sailForNewWorld (3243) / advanceCrossings
 *   (3258, SAIL_TURNS = 3), holdAdd (3300), sellFromShip (4790, with the
 *   @KISSUP boycott ask) / buyToShip (4824, the func_02A8EC space clamp),
 *   euroMenuCommit 'recruit' + PURCHASE (4919, @REALLYBUY — gold is
 *   deducted BEFORE the ask, the JS flow verbatim), euroContextCommit
 *   'arm' (4845) with the ARM_VERBS table (4608; quantities are the
 *   manual's: 50 muskets / 50 horses / 100 tools),
 *   entryType (4595) with PROFESSION_UNIT (645), bandFor (4282),
 *   importer Europe seeding (10477: off-map ships dock, reverse order).
 */
#include <stdio.h>
#include <string.h>

#include "colopy_sim.h"
#include "../data/colopy_data.h"

#define SAIL_TURNS 3
enum { EURO_PORT = 0, EURO_TO_EUROPE = 1, EURO_TO_NEWWORLD = 2 };

static int unit_row(const char *name) {
    for (int i = 0; i < DAT_UNITS_COUNT; i++)
        if (strcmp(dat_units[i].name, name) == 0) return i;
    return -1;
}

/* holdAdd (game.js:3300): merge into the good's slot; drop it at <= 0. */
void hold_add(hold_slot *hold, uint8_t *n, int good, int qty) {
    for (int i = 0; i < *n; i++)
        if (hold[i].good == good) {
            hold[i].qty = (int16_t)(hold[i].qty + qty);
            if (hold[i].qty <= 0) {
                memmove(&hold[i], &hold[i + 1],
                        (size_t)(*n - i - 1) * sizeof(hold_slot));
                (*n)--;
            }
            return;
        }
    if (qty > 0 && *n < EURO_HOLD_MAX) {
        hold[*n].good = (uint8_t)good;
        hold[*n].qty = (int16_t)qty;
        (*n)++;
    }
}
static int hold_qty(const hold_slot *hold, int n, int good) {
    for (int i = 0; i < n; i++)
        if (hold[i].good == good) return hold[i].qty;
    return 0;
}

/* PROFESSION_UNIT (game.js:645) + entryType (4595): what a dock entry is
 * EQUIPPED AS.  Returns a @UNIT row. */
int entry_unit_type(const immigrant *e) {
    if (e->type_ov) return e->type_ov - 1;
    const char *name = immigrant_name(e);
    int u = unit_row(name);
    if (u >= 0) return u;
    static const char *PU[][2] = {
        { "Veteran Soldiers", "Soldiers" }, { "Veteran Dragoons", "Dragoons" },
        { "Hardy Pioneers", "Pioneers" },   { "Seasoned Scouts", "Scouts" },
        { "Jesuit Missionaries", "Missionaries" },
    };
    for (unsigned i = 0; i < sizeof(PU) / sizeof(PU[0]); i++)
        if (strcmp(name, PU[i][0]) == 0) return unit_row(PU[i][1]);
    return unit_row("Colonists");
}

/* bandFor (game.js:4282): nearest @CLASS cost band from row 2 up. */
static int band_for(int32_t europe_value) {
    int best = 2;
    for (int i = 2; i < DAT_CLASSES_COUNT; i++) {
        int32_t da = dat_classes[i].cost - europe_value;
        int32_t db = dat_classes[best].cost - europe_value;
        if (da < 0) da = -da;
        if (db < 0) db = -db;
        if (da < db) best = i;
    }
    return best;
}
static int immigrant_band(const immigrant *m) {
    if (m->kind == 0) return m->idx;                 /* criminal / servant */
    if (m->kind == 2) return 2;                      /* Free Colonists */
    if (m->kind == 1) return band_for(dat_jobtrain[m->idx].cost);
    return 2;
}

/* importer game.js:10440-10489, two passes:
 *   pass A (sav order): a player LAND unit standing off-map or on water
 *   becomes an entry ({name: prof, type} when it has a specialty, else
 *   the plain type name) and boards the FIRST ship sharing its square —
 *   the importer runs "ships first, riders second" (game.js:10430:
 *   `pass === 0 !== isShip`), so G.units.find sees EVERY player ship,
 *   record-ascending, whatever its record index relative to the walker
 *   (the j < i reading was wrong — caught by the turns script oracle,
 *   sav1653 turn 8+); with no such ship it waits on the dock if
 *   off-map, or is dropped (the JS continue).
 *   pass B (reverse order, 10479): off-map ships leave G.units — each
 *   pushes a 'port' crossing and DISEMBARKS its riders to the dock.
 * So G.dockUnits = [unshipped off-map walkers, sav order] then [riders,
 * ships reversed, each manifest in boarding order] — the render oracle
 * sees exactly this layout (the TURNS parity trace clears the dock
 * after import on both sides).  Holds read the record's cargo bytes
 * exactly like the JS import (first two quantity bytes mapped, further
 * slots 100). */

/* The off-map sentinel is not ONE state -- it is five.
 *
 * A UnitRecord parked off the map stores x == y == BASE + power, and the
 * BASE says where in the Atlantic the unit is:
 *
 *   0xEC + power  IN EUROPE (harbour + dock).  BYTE-VERIFIED at three
 *                 independent sites, all testing `unit.x - power == 0xEC`:
 *                 @0x0421EF (func_042138's per-power recount),
 *                 @0x035E01 (the immigration accumulator) and
 *                 @0x058B8F (the REF/war sweep).
 *   0xF0 + power  BOUND FOR EUROPE ("Expected Soon").  BYTE-VERIFIED:
 *   0xF4 + power  func_042138 recounts BOTH bases into the same per-power
 *                 counter [power-0x6BAA] (@0x042455 / @0x04243F), which is
 *                 the counter the sail-for-Europe path increments
 *                 @0x041B2F before stamping UnitRecord+0x07 = 0x45
 *                 @0x041B6D -- and the fixture's only 0xF4-class record
 *                 (#31) carries exactly that 0x45.  0xEC by contrast feeds
 *                 the OTHER counter, [power-0x6BA6] (@0x0421F6).
 *   0xE4 + power  BOUND FOR THE NEW WORLD ("Bound For <region>").
 *   0xE8 + power  CAPTURE-VERIFIED for 0xE4: sav1653's Dutch Galleon
 *                 (record #56, x == y == 0xE7 == 0xE4 + 3) is drawn by the
 *                 ORIGINAL under "Bound For New Netherlands" with its three
 *                 passengers aboard, while the same screen reads "No Ships
 *                 In Port" (docs/screens/census/baseline/census_EUROPE.png).
 *                 0xE8 is the remaining slot and its direction follows from
 *                 the pairing -- it has NO site of its own.  FLAGGED.
 *
 * Before this, the port treated every off-map unit as in-port.  On the
 * census fixture that parked a crossing Galleon in the harbour and dumped
 * its three passengers onto the dock; the original shows an empty harbour
 * and six empty cargo cells (func_0314DC @0x0314F1 takes the no-ship-
 * selected branch when [0xFA2] == 0, painting all six slots from
 * func_0314AE's grid: x = 12i + 0x93, y = 0xA5, 10x12).
 *
 * NOT decoded: the progress ORDER inside each pair (0xE4 vs 0xE8, 0xF0 vs
 * 0xF4).  A restored crossing therefore gets a full SAIL_TURNS timer
 * instead of a guessed remainder -- that is a flagged approximation, not a
 * reading of the byte. */
enum { EUSENT_NONE = 0, EUSENT_EUROPE, EUSENT_TO_EUROPE, EUSENT_TO_NEWWORLD };
static int euro_sentinel(const UnitRecord *u) {
    if (u->map_x < COLOPY_MAP_W && u->map_y < COLOPY_MAP_H) return EUSENT_NONE;
    int base = (int)u->map_x - (int)(u->owner_flags & 0x0F);
    if (base == 0xF0 || base == 0xF4) return EUSENT_TO_EUROPE;
    if (base == 0xE4 || base == 0xE8) return EUSENT_TO_NEWWORLD;
    return EUSENT_EUROPE;             /* 0xEC, and any base not in the table */
}

/* A ship's manifest is in CHAIN order, not record order.
 *
 * UnitRecord +0x18/+0x1A are the alias-confirmed chain links, and a ship is
 * the HEAD of its own manifest: on the census fixture the Dutch Galleon
 * (#56) has chain_prev = 0xFFFF and chain_next = 87, #87 links on to 86 and
 * 86 to 85 -- the reverse of the order those three records appear in the
 * file.  Corroborated on two other ships in the same save (#28's only rider
 * #52 carries chain_prev = 28; nation 1's #49 heads #40).
 *
 * It matters because the manifest is drawn left to right. The 2026-08-07
 * capture analysis identified the Galleon's three passengers as Expert
 * Farmer / Master Distiller / Master Gunsmith in that order, matched 1.0 --
 * which is professions 0, 9, 15, i.e. records 87, 86, 85. The port collected
 * them 85, 86, 87 and drew the manifest backwards.
 *
 * Riders that are not on the chain keep their relative order behind the ones
 * that are, rather than being dropped. */
static void rid_chain_order(int ship, immigrant *e, uint16_t *u, int n) {
    int rank[EURO_PASS_MAX];
    for (int k = 0; k < n; k++) rank[k] = 1000 + k;
    int r = 0, cur = (int)CS.units[ship].chain_next, guard = 0;
    while (cur != 0xFFFF && cur < CS.n_units && guard++ < COLOPY_MAX_UNITS) {
        for (int k = 0; k < n; k++)
            if (u[k] == (uint16_t)cur) { rank[k] = r++; break; }
        cur = (int)CS.units[cur].chain_next;
    }
    for (int a = 1; a < n; a++)
        for (int b = a; b > 0 && rank[b] < rank[b - 1]; b--) {
            int tr = rank[b]; rank[b] = rank[b - 1]; rank[b - 1] = tr;
            immigrant te = e[b]; e[b] = e[b - 1]; e[b - 1] = te;
            uint16_t tu = u[b]; u[b] = u[b - 1]; u[b - 1] = tu;
        }
}

void europe_seed_from_load(void) {
    CR.n_europe = 0;
    CR.n_dock_units = 0;
    /* per-ship rider buffers (JS ship.cargo), filled by pass A */
    static uint8_t rid_n[COLOPY_MAX_UNITS];
    static immigrant rid[COLOPY_MAX_UNITS][EURO_PASS_MAX];
    static uint16_t rid_u[COLOPY_MAX_UNITS][EURO_PASS_MAX];
    memset(rid_n, 0, sizeof(rid_n));
    for (int i = 0; i < CS.n_units; i++) {
        const UnitRecord *w = &CS.units[i];
        if ((w->owner_flags & 0x0F) != cs_nation()) continue;
        if (w->type >= DAT_UNITS_COUNT || dat_units[w->type].hull > 0)
            continue;
        int off = w->map_x >= COLOPY_MAP_W || w->map_y >= COLOPY_MAP_H;
        int water = !off && tile_water(map_at(w->map_x, w->map_y));
        if (!off && !water) continue;
        immigrant e;
        memset(&e, 0, sizeof(e));
        /* Profession 0 IS a profession -- Expert Farmers, @JOBEXPERT row 0.
         * The port's `prof >= 1` guard treated it as "no specialty" and drew
         * the man as a generic colonist; the no-specialty value is 28, the
         * row count (spec/systems/save.md, ColonyRecord +0x20: "28 = no
         * specialty"), which `prof < DAT_JOBEXPERT_COUNT` already excludes. */
        int prof = w->profession;
        if (prof >= 0 && prof < DAT_JOBEXPERT_COUNT) {
            e.kind = 4;                   /* { name: prof, type } */
            e.idx = (uint8_t)prof;
            e.type_ov = (uint8_t)(w->type + 1);
        } else {
            e.kind = 3;                   /* plain type-name string */
            e.idx = w->type;
        }
        int si = -1;
        for (int j = 0; j < CS.n_units; j++) {  /* all ships, sav order */
            const UnitRecord *u = &CS.units[j];
            if ((u->owner_flags & 0x0F) != cs_nation()) continue;
            if (u->type >= DAT_UNITS_COUNT || dat_units[u->type].hull <= 0)
                continue;
            if (u->map_x == w->map_x && u->map_y == w->map_y) { si = j; break; }
        }
        if (si >= 0) {
            if (rid_n[si] < EURO_PASS_MAX) {
                rid_u[si][rid_n[si]] = (uint16_t)i;
                rid[si][rid_n[si]++] = e;
            }
        } else if (off) {
            if (CR.n_dock_units < (int)(sizeof(CR.dock_units) /
                                        sizeof(CR.dock_units[0])))
                CR.dock_units[CR.n_dock_units++] = e;
        }
        /* on-water with no ship: the JS drops the unit (10451 continue) */
    }
    for (int i = CS.n_units - 1; i >= 0; i--) {
        const UnitRecord *u = &CS.units[i];
        if ((u->owner_flags & 0x0F) != cs_nation()) continue;
        if (u->type >= DAT_UNITS_COUNT || dat_units[u->type].hull <= 0)
            continue;
        rid_chain_order(i, rid[i], rid_u[i], rid_n[i]);
        int off = u->map_x >= COLOPY_MAP_W || u->map_y >= COLOPY_MAP_H;
        if (off) {
            if (CR.n_europe >= (int)(sizeof(CR.europe) / sizeof(CR.europe[0])))
                continue;
            euro_crossing *e = &CR.europe[CR.n_europe++];
            memset(e, 0, sizeof(*e));
            e->type = u->type;
            int sent = euro_sentinel(u);
            e->state = sent == EUSENT_TO_EUROPE   ? EURO_TO_EUROPE
                     : sent == EUSENT_TO_NEWWORLD ? EURO_TO_NEWWORLD
                                                  : EURO_PORT;
            e->turns = e->state == EURO_PORT ? 0 : SAIL_TURNS;
            e->lane_x = e->lane_y = -1;      /* no lane: JS e.lane absent */
            int n = u->cargo_slot_count < 6 ? u->cargo_slot_count : 6;
            for (int k = 0; k < n; k++) {
                int good = (u->cargo_kind_packed[k >> 1] >>
                            ((k & 1) ? 4 : 0)) & 0x0F;
                int qty = k < 2 ? u->cargo_amount[k] : 100;
                if (qty) hold_add(e->hold, &e->n_hold, good, qty);
            }
            /* A ship IN EUROPE unloads: its riders disembark to the dock
             * (10484).  A ship still AT SEA keeps them aboard -- that is
             * what the original draws, three figures trailing the Galleon
             * in the "Bound For" column. */
            for (int r = 0; r < rid_n[i]; r++) {
                if (e->state != EURO_PORT) {
                    if (e->n_pass < EURO_PASS_MAX) e->pass[e->n_pass++] = rid[i][r];
                } else if (CR.n_dock_units < (int)(sizeof(CR.dock_units) /
                                                   sizeof(CR.dock_units[0]))) {
                    CR.dock_units[CR.n_dock_units++] = rid[i][r];
                }
            }
        } else {
            /* on-map ship: seed its live hold + passenger mirrors */
            int n = u->cargo_slot_count < 6 ? u->cargo_slot_count : 6;
            for (int k = 0; k < n; k++) {
                int good = (u->cargo_kind_packed[k >> 1] >>
                            ((k & 1) ? 4 : 0)) & 0x0F;
                int qty = k < 2 ? u->cargo_amount[k] : 100;
                if (qty) hold_add(CR.unit_hold[i], &CR.unit_n_hold[i],
                                  good, qty);
            }
            CR.unit_n_pass[i] = 0;
            for (int r = 0; r < rid_n[i]; r++)
                if (CR.unit_n_pass[i] < EURO_PASS_MAX)
                    CR.unit_pass[i][CR.unit_n_pass[i]++] = rid[i][r];
        }
    }
}

/* sailForEurope (game.js:3231): the ship leaves the map wholesale (the
 * JS deletes the object; a NEW one is minted on return). */
void cmd_sail_for_europe(int ui) {
    if (CR.n_europe >= (int)(sizeof(CR.europe) / sizeof(CR.europe[0])))
        return;
    UnitRecord *u = &CS.units[ui];
    euro_crossing *e = &CR.europe[CR.n_europe++];
    memset(e, 0, sizeof(*e));
    e->type = u->type;
    e->state = EURO_TO_EUROPE;
    e->turns = SAIL_TURNS;
    e->damaged = CR.unit_damaged[ui];
    e->work = CR.unit_work[ui];
    e->lane_x = u->map_x;
    e->lane_y = u->map_y;
    memcpy(e->hold, CR.unit_hold[ui], sizeof(e->hold));
    e->n_hold = CR.unit_n_hold[ui];
    memcpy(e->pass, CR.unit_pass[ui], sizeof(e->pass));
    e->n_pass = CR.unit_n_pass[ui];
    unit_remove(ui);
}

/* nearestSeaLane (game.js, next to onSeaLane): the closest terrain-26
 * square by CHEBYSHEV distance — ships step 8-way, so that IS the turn
 * count.  GAME_MANUAL.md p18/p57: a ship bound for Europe "must enter a
 * Sea Lane square on the map display, then move toward the nearest map
 * edge", so the lane is where a crossing BEGINS.  Terrain 26 is hard
 * rule 2 (CLAUDE.md).  Ties break on the first square in scan order, to
 * keep this and the JS on the same answer. */
int nearest_sea_lane(int ui, int *out_x, int *out_y) {
    int bx = -1, by = -1;
    long bd = -1;
    int ux = CS.units[ui].map_x, uy = CS.units[ui].map_y;
    for (int y = 0; y < COLOPY_MAP_H; y++)
        for (int x = 0; x < COLOPY_MAP_W; x++) {
            if (tile_terrain(map_at(x, y)) != TERR_SEALANE) continue;
            int ax = x > ux ? x - ux : ux - x;
            int ay = y > uy ? y - uy : uy - y;
            long d = ax > ay ? ax : ay;
            if (bd < 0 || d < bd) { bd = d; bx = x; by = y; }
        }
    if (bx < 0) return 0;
    *out_x = bx;
    *out_y = by;
    return 1;
}

/* orderSailHome (game.js, next to nearestSeaLane): a ship already ON the
 * lane leaves at once; one in open water is ordered to the NEAREST lane
 * and departs the moment advance_goto lands it there.  Until 2026-08-17
 * the port lifted the ship off the map from wherever it stood, which is
 * neither the manual's model nor what the player sees (user report).
 * Returns 1 when the crossing began this instant — the callers use that
 * to decide whether to open the Europe screen. */
int cmd_order_sail_home(int ui) {
    if (tile_terrain(map_at(CS.units[ui].map_x, CS.units[ui].map_y)) ==
        TERR_SEALANE) {
        cmd_sail_for_europe(ui);
        return 1;
    }
    int lx, ly;
    if (!nearest_sea_lane(ui, &lx, &ly)) return 0;   /* G.msg only */
    CR.unit_sail_home[ui] = 1;
    cmd_goto(ui, lx, ly);
    return 0;
}

/* sailForNewWorld (game.js:3243): dock units board in order, skipping
 * any held back by the no-board flag, to the 6-passenger cap. */
void euro_sail_new_world(int ei) {
    euro_crossing *e = &CR.europe[ei];
    for (int i = 0; i < CR.n_dock_units && e->n_pass < 6; ) {
        if (CR.dock_units[i].no_board) { i++; continue; }
        if (e->n_pass < EURO_PASS_MAX)
            e->pass[e->n_pass++] = CR.dock_units[i];
        memmove(&CR.dock_units[i], &CR.dock_units[i + 1],
                (size_t)(CR.n_dock_units - i - 1) * sizeof(immigrant));
        CR.n_dock_units--;
    }
    e->state = EURO_TO_NEWWORLD;
    e->turns = SAIL_TURNS;
}

/* advanceCrossings (game.js:3258), iterated from the END like the JS. */
void advance_crossings(void) {
    for (int k = CR.n_europe - 1; k >= 0; k--) {
        euro_crossing *e = &CR.europe[k];
        /* Damaged-ship repair, Europe half — BYTE_VERIFIED func_02F052
         * @0x2F0E0..@0x2F1E2 (read 2026-08-29): every damaged ship ticks
         * +1 a turn; the on-map bounds bonus (@0x2F0FE) fails off-map,
         * so ships in Europe (crossing or docked) mend at HALF the map
         * rate.  Complete at the @UNIT defense column (+0x5235 =
         * dat_units[].combat, @0x2F126); @REFIT names the homeport
         * (@0x2F1BA).  The counter reset is the port's own hygiene (the
         * engine leaves +0x16 stale), flagged. */
        if (e->damaged) {
            e->work++;
            if ((int)e->work >= (int)dat_units[e->type].combat) {
                e->damaged = 0;
                e->work = 0;
                ev_emit("REFIT", 0, 0, dat_units[e->type].name,
                        dat_nations[cs_nation()].homeport);
            }
        }
        if (e->state == EURO_PORT) continue;
        if (--e->turns > 0) continue;
        if (e->state == EURO_TO_EUROPE) {
            e->state = EURO_PORT;
            /* (the old instant damage-clear on docking is gone: repair
             * is the byte-verified timer above) */
            for (int p = 0; p < e->n_pass; p++)
                if (CR.n_dock_units <
                    (int)(sizeof(CR.dock_units) / sizeof(CR.dock_units[0])))
                    CR.dock_units[CR.n_dock_units++] = e->pass[p];
            e->n_pass = 0;
            /* arrival opens the harbour: G.screen = 'europe' closes the
             * parley gate — UNLESS the hold carries cargo, in which case
             * the CARGO woodcut fires and the trace's dismissal wrapper
             * puts the screen back on the map. */
            int any_cargo = 0, any_boycott = 0;
            for (int h = 0; h < e->n_hold; h++)
                if (e->hold[h].qty > 0) {
                    any_cargo = 1;
                    if (market_boycotted(e->hold[h].good)) any_boycott = 1;
                }
            CR.screen_map = 0;
            if (any_boycott) ev_emit("SOMEBOYCOTT", 0, 0, 0, 0);
            if (any_cargo) CR.screen_map = 1;   /* woodcut 9 + dismissal */
            continue;
        }
        /* back on the map, on the sea lane it left from — or the JS
         * default (MAP.w - 1, 20) when the ship never had one
         * (game.js:3292: purchased / import-docked ships) */
        int lx = e->lane_x >= 0 ? e->lane_x : COLOPY_MAP_W - 1;
        int ly = e->lane_x >= 0 ? e->lane_y : 20;
        int ui = unit_append(e->type, (int)cs_nation(), lx, ly);
        if (ui >= 0) {
            memcpy(CR.unit_hold[ui], e->hold, sizeof(e->hold));
            CR.unit_n_hold[ui] = e->n_hold;
            memcpy(CR.unit_pass[ui], e->pass, sizeof(e->pass));
            CR.unit_n_pass[ui] = e->n_pass;
            if (e->damaged) {
                CR.unit_damaged[ui] = 1;
                CR.unit_work[ui] = e->work;
            }
        }
        memmove(&CR.europe[k], &CR.europe[k + 1],
                (size_t)(CR.n_europe - k - 1) * sizeof(euro_crossing));
        CR.n_europe--;
    }
}

/* sellFromShip (game.js:4790) with an EXPLICIT qty (the automated stop's
 * no-ask path) — except the boycott branch, which is the @KISSUP ask. */
void euro_sell_from_ship(int ei, int good, int32_t qty) {
    euro_crossing *e = &CR.europe[ei];
    if (market_boycotted(good)) {
        int32_t tax = market_bid(good) * 500;
        ev_emit("KISSUP", tax, 0, dat_cargo[good].name,
                dat_nations[cs_nation()].homeport);
        if (ask_choice() == 1) {
            PowerRecord *p = &CS.powers[cs_nation()];
            if (p->gold < tax) {
                ev_emit("KISSSORRY", p->gold, 0, 0, 0);
            } else {
                p->gold -= tax;
                p->kings_fund += tax;
                CR.boycotts &= (uint16_t)~(1u << good);
            }
        }
        return;
    }
    int have = hold_qty(e->hold, e->n_hold, good);
    if (!have) return;
    if (qty > have) qty = have;
    if (!qty) return;
    market_sell(good, qty);
    hold_add(e->hold, &e->n_hold, good, -qty);
}

/* buyToShip (game.js:4824): the func_02A8EC space clamp, then buyGoods. */
void euro_buy_to_ship(int ei, int good, int32_t qty) {
    euro_crossing *e = &CR.europe[ei];
    int cap = dat_units[e->type].cargo;
    int used = e->n_pass + e->n_hold;
    int slot = hold_qty(e->hold, e->n_hold, good);
    int has_slot = 0;
    for (int i = 0; i < e->n_hold; i++)
        if (e->hold[i].good == good) has_slot = 1;
    int space = (cap - used > 0 ? cap - used : 0) * 100 +
                (has_slot ? (100 - slot > 0 ? 100 - slot : 0) : 0);
    if (space <= 0) return;
    if (qty > space) qty = space;
    if (!market_buy(good, qty)) return;
    hold_add(e->hold, &e->n_hold, good, qty);
}

/* euroMenuCommit 'recruit' (game.js:4928): pay the class-band passage,
 * the recruit waits on the dock, the slot refills. */
void euro_recruit(int slot) {
    if (slot < 0 || slot > 2) return;
    int32_t cost = dat_classes[immigrant_band(&CR.dock[slot])].cost;
    PowerRecord *p = &CS.powers[cs_nation()];
    if (cost > p->gold) return;
    p->gold -= cost;
    if (CR.n_dock_units <
        (int)(sizeof(CR.dock_units) / sizeof(CR.dock_units[0]))) {
        immigrant m = CR.dock[slot];
        m.type_ov = 0;
        m.no_board = 0;
        CR.dock_units[CR.n_dock_units++] = m;
    }
    roll_immigrant(&CR.dock[slot]);
}

/* a port ship's hold quantity of one good (holdQty, game.js:3306) —
 * exported for the input layer's @HOWMUCH5 amount bound */
int32_t euro_hold_qty(int ei, int good) {
    if (ei < 0 || ei >= CR.n_europe) return 0;
    return hold_qty(CR.europe[ei].hold, CR.europe[ei].n_hold, good);
}

/* the recruit row's passage price (euroMenuRows, game.js:4665) —
 * exported so the input layer can mirror euroMenuCommit's generic
 * gold gate (menu stays open when it fails) */
int32_t euro_recruit_cost(int slot) {
    if (slot < 0 || slot > 2) return 0;
    return dat_classes[immigrant_band(&CR.dock[slot])].cost;
}

/* the TRAIN menu order (euroMenuRows, game.js:4670): the jobtrain rows
 * sorted by cost — Array.sort is stable, so ties keep table order
 * (insertion sort mirrors that) */
static void euro_train_order(int order[DAT_JOBTRAIN_COUNT]) {
    for (int i = 0; i < DAT_JOBTRAIN_COUNT; i++) {
        int j = i;
        while (j > 0 &&
               dat_jobtrain[order[j - 1]].cost > dat_jobtrain[i].cost) {
            order[j] = order[j - 1];
            j--;
        }
        order[j] = i;
    }
}
int32_t euro_train_cost(int sorted_row) {
    if (sorted_row < 0 || sorted_row >= DAT_JOBTRAIN_COUNT) return 0;
    int order[DAT_JOBTRAIN_COUNT];
    euro_train_order(order);
    return dat_jobtrain[order[sorted_row]].cost;
}
/* euroMenuCommit 'train' (game.js:4933): pay the Royal University, the
 * trainee waits on the dock; @PURCHASETAX is the port's FLAGGED 1-in-3
 * stand-in for the unread trigger rate (the roll is consumed before
 * the tax cap test, like the JS && order). */
void euro_train(int sorted_row) {
    if (sorted_row < 0 || sorted_row >= DAT_JOBTRAIN_COUNT) return;
    int order[DAT_JOBTRAIN_COUNT];
    euro_train_order(order);
    int j = order[sorted_row];
    PowerRecord *p = &CS.powers[cs_nation()];
    if (dat_jobtrain[j].cost > p->gold) return;
    p->gold -= dat_jobtrain[j].cost;
    if (CR.n_dock_units <
        (int)(sizeof(CR.dock_units) / sizeof(CR.dock_units[0]))) {
        immigrant *m = &CR.dock_units[CR.n_dock_units++];
        memset(m, 0, sizeof(*m));
        m->kind = 1;                         /* a jobtrain expert */
        m->idx = (uint8_t)j;
    }
    if ((int)((rng_next() * 3u) >> 15) == 0 && p->tax_rate < 75) {
        p->tax_rate++;
        ev_emit("PURCHASETAX", 1, p->tax_rate, 0, 0);
    }
}

/* PURCHASE_CATALOG (game.js:4388) + euroMenuCommit (4919): the cost gate
 * and the DEBIT come BEFORE the @REALLYBUY ask — a declined purchase
 * still spends the gold (the JS flow verbatim). */
static const struct { const char *unit; int32_t price; uint8_t escalates; }
PURCHASE[6] = {
    { "Artillery", 500, 1 },   { "Caravel", 1000, 0 },
    { "Merchantman", 2000, 0 }, { "Galleon", 3000, 0 },
    { "Privateer", 2000, 0 },  { "Frigate", 5000, 0 },
};
const char *euro_purchase_unit(int row) {
    return row >= 0 && row < 6 ? PURCHASE[row].unit : "";
}
int32_t euro_purchase_price(int row) {
    if (row < 0 || row >= 6) return 0;
    return PURCHASE[row].price +
           (PURCHASE[row].escalates ? CR.artillery_bought * 100 : 0);
}
void euro_purchase(int row) {
    if (row < 0 || row >= 6) return;
    int32_t price = euro_purchase_price(row);
    PowerRecord *p = &CS.powers[cs_nation()];
    if (price > p->gold) return;
    p->gold -= price;
    ev_emit("REALLYBUY", price, 0, PURCHASE[row].unit, 0);
    if (ask_choice() != 0) return;
    if (PURCHASE[row].escalates) CR.artillery_bought++;
    int t = unit_row(PURCHASE[row].unit);
    if (t < 0) return;
    if (dat_units[t].hull > 0) {
        if (CR.n_europe < (int)(sizeof(CR.europe) / sizeof(CR.europe[0]))) {
            euro_crossing *e = &CR.europe[CR.n_europe++];
            memset(e, 0, sizeof(*e));
            e->type = (uint8_t)t;
            e->state = EURO_PORT;
            e->lane_x = e->lane_y = -1;      /* purchased: no lane */
        }
    } else if (CR.n_dock_units <
               (int)(sizeof(CR.dock_units) / sizeof(CR.dock_units[0]))) {
        immigrant *m = &CR.dock_units[CR.n_dock_units++];
        memset(m, 0, sizeof(*m));
        m->kind = 3;
        m->idx = (uint8_t)t;
    }
}

/* ARM_VERBS (game.js:4608).  from/to are @UNIT type names. */
static const struct {
    uint8_t good; int16_t qty; uint8_t buy;
    const char *from1, *to1, *from2, *to2;
} ARM[6] = {
    { MUSKETS, 50, 1, "Colonists", "Soldiers", "Scouts", "Dragoons" },
    { MUSKETS, 50, 0, "Soldiers", "Colonists", "Dragoons", "Scouts" },
    { TOOLS, 100, 1, "Colonists", "Pioneers", 0, 0 },
    { TOOLS, 100, 0, "Pioneers", "Colonists", 0, 0 },
    { HORSES, 50, 1, "Colonists", "Scouts", "Soldiers", "Dragoons" },
    { HORSES, 50, 0, "Scouts", "Colonists", "Dragoons", "Soldiers" },
};
static int arm_target(int verb, int type_row) {
    const char *tn = dat_units[type_row].name;
    if (ARM[verb].from1 && strcmp(tn, ARM[verb].from1) == 0)
        return unit_row(ARM[verb].to1);
    if (ARM[verb].from2 && strcmp(tn, ARM[verb].from2) == 0)
        return unit_row(ARM[verb].to2);
    return -1;
}
/* dockUnitRows' 'arm' subset (game.js:4633): the applicable verbs for
 * the entry's current type, in table order.  Returns the count. */
/* the sorted-row expert name (the TRAIN list order) */
const char *euro_train_expert(int sorted_row) {
    if (sorted_row < 0 || sorted_row >= DAT_JOBTRAIN_COUNT) return "";
    int order[DAT_JOBTRAIN_COUNT];
    euro_train_order(order);
    return dat_jobtrain[order[sorted_row]].expert;
}
int euro_arm_rows(int k, uint8_t *verbs_out) {
    if (k < 0 || k >= CR.n_dock_units) return 0;
    int t = entry_unit_type(&CR.dock_units[k]);
    int n = 0;
    for (int v = 0; v < 6; v++)
        if (t >= 0 && arm_target(v, t) >= 0) verbs_out[n++] = (uint8_t)v;
    return n;
}
/* euroContextCommit 'arm' (game.js:4872): buy at ask / sell at bid, the
 * entry re-types.  The dim gate (price > gold or boycott) is exactly
 * what market_buy refuses, so a refusal leaves the entry unchanged. */
void euro_arm_dock(int k, int verb) {
    if (k < 0 || k >= CR.n_dock_units || verb < 0 || verb >= 6) return;
    immigrant *e = &CR.dock_units[k];
    int t = entry_unit_type(e);
    int to = t >= 0 ? arm_target(verb, t) : -1;
    if (to < 0) return;
    if (ARM[verb].buy) {
        if (!market_buy(ARM[verb].good, ARM[verb].qty)) return;
    } else {
        market_sell(ARM[verb].good, ARM[verb].qty);
    }
    e->type_ov = (uint8_t)(to + 1);      /* { name, type: r.to } */
}
