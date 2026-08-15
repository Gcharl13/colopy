/* The player-command layer — Phase 5 slice 2.  Each function mirrors a
 * game.js UI command over the records + CR runtime; the byte citations
 * live with the JS originals (spec/systems/terrain_improvement.md §);
 * where a branch is not yet portable (ships at sea, rival tiles,
 * villages, rumour entry — slices 3-5) it is an EXPLICIT no-op and the
 * scripted parity harness keeps both engines off it with one shared
 * legality filter.
 *
 * Movement budgets are THIRDS (MOVE_UNIT = 3): the @UNIT loader
 * multiplies the movement column by 3 (`SHL al,1 / ADD al,cl` @0x074F04,
 * unit.md §3); a road/river step costs 1. */
#include <string.h>

#include "colopy_sim.h"
#include "../data/colopy_data.h"

int unit_full_moves(int ui) {
    const UnitRecord *u = &CS.units[ui];
    if (u->type >= DAT_UNITS_COUNT) return 0;
    return dat_units[u->type].movement * 3;
}

/* rumourAt (game.js:8712): the [0x190]-salted 32-bucket hash over the
 * tile's quad, gated off Arctic/Ocean/Sea Lane (id >= 0x18).  The JS
 * rumoursDone set stays EMPTY under the slice-2 script (rumour tiles are
 * filtered, never entered), so the consumed-set has no C mirror yet —
 * rumour ENTRY (enterRumour, slice 4) will add it. */
int rumour_at(int x, int y) {
    if (!CR.map_seed) return 0;
    int t = tile_terrain(map_at(x, y));
    if (t >= 0x18) return 0;
    int h = (((y >> 2) * 0x13 + (x >> 2) * 0x11 + CR.map_seed + 8) & 0x1F);
    return h - (x & 3) * 4 == (y & 3);
}

/* skipUnit (game.js:10872): give up the rest of the turn's moves. */
void cmd_skip(int ui) {
    CS.units[ui].moves_remaining = 0;
    CR.unit_moves_undef[ui] = 0;         /* a NUMBER was written */
}

/* setOrder (game.js:11181): orders n, moves spent. */
void cmd_set_order(int ui, int n) {
    CS.units[ui].orders = (uint8_t)n;
    CS.units[ui].moves_remaining = 0;
    CR.unit_moves_undef[ui] = 0;
}

/* Go To: the picker writes orders 3 + the goal; advanceGoTo (ported in
 * colopy_rivals.c's endTurn tail) walks it a step a turn. */
void cmd_goto(int ui, int gx, int gy) {
    CS.units[ui].orders = 3;
    CR.goal_x[ui] = (int16_t)gx;
    CR.goal_y[ui] = (int16_t)gy;
}

/* activateUnit (game.js:11228): wake the unit; an empty budget refills —
 * to u.moves, which a rival-born object does not have (undefined). */
void cmd_activate(int ui) {
    CS.units[ui].orders = 0;
    if (CR.unit_moves_undef[ui] || !CS.units[ui].moves_remaining) {
        if (CR.unit_no_moves[ui]) CR.unit_moves_undef[ui] = 1;
        else {
            CR.unit_moves_undef[ui] = 0;
            CS.units[ui].moves_remaining = (uint8_t)unit_full_moves(ui);
        }
    }
}

/* clearObjection / roadObjection (game.js:5549/5569): a village within 2
 * of the work site whose tribe's tension has reached 40 objects, with a
 * buy-off (Peter Minuit zeroes it).  Row 0 stops the work, row 1 pays
 * (tension -5) or stops if the purse is short, row 2 works on anyway
 * (@PISS2 forest / @PISS1 road). */
static void work_objection(int ui, int road) {
    UnitRecord *u = &CS.units[ui];
    int near = -1;
    for (int v = 0; v < CS.n_villages; v++) {
        int dx = CS.villages[v].map_x - u->map_x;
        int dy = CS.villages[v].map_y - u->map_y;
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        if (dx <= 2 && dy <= 2) { near = v; break; }
    }
    if (near < 0) return;
    int tribe = (CS.villages[near].owner_tribe & 0x0F) - 4;
    if (tribe < 0 || tribe >= 8 || CR.tension[tribe] < 40) return;
    int32_t pay = father_owned(father_by_name("Peter Minuit"))
                      ? 0 : demand_value(100);
    ev_emit(road ? "INDIANROAD" : "INDIANFOREST", 0, (int32_t)pay,
            dat_tribes[tribe].name, 0);
    int c = ask_choice();
    if (c == 0) { u->orders = 0; CR.unit_work[ui] = 0; return; }
    if (c == 1) {
        PowerRecord *p = &CS.powers[cs_nation()];
        if (p->gold >= pay) { p->gold -= pay; adjust_tension(tribe, -5, 0); }
        else { u->orders = 0; CR.unit_work[ui] = 0; }
        return;
    }
    adjust_tension(tribe, 10, road ? 1 : 2);   /* @PISS1 / @PISS2 */
}

/* improveOrder (game.js:11191).  Orders 8 = Clear/Plow, 9 = Build Road
 * (dispatcher @0x051D56); refusals @ONLYPIO/@NOROAD/@NOPLOW. */
static int is_forested_id(int t) { return t >= 8 && t <= 23; }
void cmd_improve(int ui, int n) {
    UnitRecord *u = &CS.units[ui];
    int ship = u->type < DAT_UNITS_COUNT && dat_units[u->type].hull > 0;
    /* canImprove (game.js:2325): a land unit carrying >= 20 tools */
    if (ship || u->tools < 20) { ev_emit("ONLYPIO", 0, 0, 0, 0); return; }
    uint8_t v = map_at(u->map_x, u->map_y);
    if (tile_water(v)) { ev_emit("ONLYPIO", 0, 0, 0, 0); return; }
    if (n == 9 && (map_improve(u->map_x, u->map_y) & ROAD_BIT)) {
        ev_emit("NOROAD", 0, 0, 0, 0);
        return;
    }
    if (n == 8 && !is_forested_id(tile_terrain(v)) &&
        (map_improve(u->map_x, u->map_y) & PLOW_BIT)) {
        ev_emit("NOPLOW", 0, 0, 0, 0);
        return;
    }
    u->orders = (uint8_t)n;
    CR.unit_work[ui] = 0;
    u->moves_remaining = 0;
    CR.unit_moves_undef[ui] = 0;
    if (n == 9) work_objection(ui, 1);
    if (n == 8 && is_forested_id(tile_terrain(v))) work_objection(ui, 0);
}

/* moveSel (game.js:10919) — the slice-2 subset: a LAND unit taking one
 * step onto empty legal ground.  Ship movement (landfall, SHIPLAKE,
 * interception, sea lane), attacks, rival tiles (parley/war/trade/
 * scout) and village entry stay with slices 3-5 — each such target is
 * an explicit no-op here, and the scripted harness filters them on both
 * sides with one shared legality test. */
void cmd_move(int ui, int dx, int dy) {
    UnitRecord *u = &CS.units[ui];
    /* undefined movesLeft (rival-born, see colopy_sim.h) would slip the
     * JS <= 0 test and NaN-step; the shared script filter (movesLeft > 0)
     * keeps both engines off that path, so it stays unported. */
    if (CR.unit_moves_undef[ui]) return;
    if (u->moves_remaining <= 0) return;
    int nx = u->map_x + dx, ny = u->map_y + dy;
    if (nx < 0 || ny < 0 || nx >= COLOPY_MAP_W || ny >= COLOPY_MAP_H) return;
    uint8_t v = map_at(nx, ny);
    int ship = u->type < DAT_UNITS_COUNT && dat_units[u->type].hull > 0;
    if (ship) return;                       /* ship moves: slice 3 */
    if (tile_water(v)) return;              /* land units stay ashore */
    /* an occupied tile — a native/squatter (attack §14, with the §14.3
     * tired-troops @HALF ask), a rival (parley/war/trade/scout), a
     * village, a rumour square: each an EXPLICIT no-op pending slices
     * 3-5; the scripted harness filters these targets on both sides, so
     * a no-op here is parity-safe and no unexercised port ships. */
    for (int k = 0; k < CR.n_natives; k++) {
        int q = CR.natives_order[k];
        if (unit_pos_x(q) == nx && unit_pos_y(q) == ny) return;
    }
    for (int rn = 0; rn < 4; rn++) {
        if (rn == (int)cs_nation()) continue;
        for (int k = 0; k < CR.n_runits[rn]; k++) {
            int q = CR.runits_order[rn][k];
            if (CR.runit_x[q] == nx && CR.runit_y[q] == ny) return;
        }
        for (int k = 0; k < CR.rivals[rn].n_col; k++)
            if (CR.rivals[rn].col[k].x == nx && CR.rivals[rn].col[k].y == ny)
                return;
    }
    for (int vi = 0; vi < CS.n_villages; vi++)
        if (CS.villages[vi].map_x == nx && CS.villages[vi].map_y == ny) return;
    if (rumour_at(nx, ny)) return;
    /* step (game.js:10833): one step is always affordable; the budget
     * floors at zero.  reveal/tutorial/centring are presentation. */
    int cost = move_cost(0, u->map_x, u->map_y, nx, ny);
    u->moves_remaining = (uint8_t)(cost > u->moves_remaining
                                       ? 0 : u->moves_remaining - cost);
    u->map_x = (uint8_t)nx;
    u->map_y = (uint8_t)ny;
}
