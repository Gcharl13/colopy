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
void europe_seed_from_load(void) {
    CR.n_europe = 0;
    CR.n_dock_units = 0;
    /* per-ship rider buffers (JS ship.cargo), filled by pass A */
    static uint8_t rid_n[COLOPY_MAX_UNITS];
    static immigrant rid[COLOPY_MAX_UNITS][EURO_PASS_MAX];
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
        int prof = w->profession;
        if (prof >= 1 && prof < DAT_JOBEXPERT_COUNT) {
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
            if (rid_n[si] < EURO_PASS_MAX) rid[si][rid_n[si]++] = e;
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
        int off = u->map_x >= COLOPY_MAP_W || u->map_y >= COLOPY_MAP_H;
        if (off) {
            if (CR.n_europe >= (int)(sizeof(CR.europe) / sizeof(CR.europe[0])))
                continue;
            euro_crossing *e = &CR.europe[CR.n_europe++];
            memset(e, 0, sizeof(*e));
            e->type = u->type;
            e->state = EURO_PORT;
            e->lane_x = e->lane_y = -1;      /* no lane: JS e.lane absent */
            int n = u->cargo_slot_count < 6 ? u->cargo_slot_count : 6;
            for (int k = 0; k < n; k++) {
                int good = (u->cargo_kind_packed[k >> 1] >>
                            ((k & 1) ? 4 : 0)) & 0x0F;
                int qty = k < 2 ? u->cargo_amount[k] : 100;
                if (qty) hold_add(e->hold, &e->n_hold, good, qty);
            }
            /* riders disembark to the dock (10484) */
            for (int r = 0; r < rid_n[i]; r++)
                if (CR.n_dock_units < (int)(sizeof(CR.dock_units) /
                                            sizeof(CR.dock_units[0])))
                    CR.dock_units[CR.n_dock_units++] = rid[i][r];
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
    e->lane_x = u->map_x;
    e->lane_y = u->map_y;
    memcpy(e->hold, CR.unit_hold[ui], sizeof(e->hold));
    e->n_hold = CR.unit_n_hold[ui];
    memcpy(e->pass, CR.unit_pass[ui], sizeof(e->pass));
    e->n_pass = CR.unit_n_pass[ui];
    unit_remove(ui);
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
        if (e->state == EURO_PORT) continue;
        if (--e->turns > 0) continue;
        if (e->state == EURO_TO_EUROPE) {
            e->state = EURO_PORT;
            if (e->damaged) {
                e->damaged = 0;
                ev_emit("REFIT", 0, 0, dat_units[e->type].name,
                        dat_nations[cs_nation()].homeport);
            }
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

/* PURCHASE_CATALOG (game.js:4388) + euroMenuCommit (4919): the cost gate
 * and the DEBIT come BEFORE the @REALLYBUY ask — a declined purchase
 * still spends the gold (the JS flow verbatim). */
static const struct { const char *unit; int32_t price; uint8_t escalates; }
PURCHASE[6] = {
    { "Artillery", 500, 1 },   { "Caravel", 1000, 0 },
    { "Merchantman", 2000, 0 }, { "Galleon", 3000, 0 },
    { "Privateer", 2000, 0 },  { "Frigate", 5000, 0 },
};
void euro_purchase(int row) {
    if (row < 0 || row >= 6) return;
    int32_t price = PURCHASE[row].price +
                    (PURCHASE[row].escalates ? CR.artillery_bought * 100 : 0);
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
