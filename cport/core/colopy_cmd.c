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
    if (h - (x & 3) * 4 != (y & 3)) return 0;
    int bit = y * COLOPY_MAP_W + x;      /* rumoursDone consumed-set */
    return !((CR.rumours_done[bit >> 3] >> (bit & 7)) & 1);
}

/* enterRumour (game.js:8740) — the Lost City Rumour tree.  d/dsum are
 * the JS 1+floor(random*n) rolls; the anti-streak floor climbs 1 per
 * rumour and caps at 3; quality = d(100) + scout*10 against 10/25.
 * Returns 0 when the ENTERING unit is gone (the vanish outcome, or the
 * @SCREWED desecration) — the caller must not step it. */
static int d_roll(int n) { return 1 + (int)((rng_next() * (uint32_t)n) >> 15); }
static int dsum_roll(int k, int n) {
    int t = 0;
    for (int i = 0; i < k; i++) t += d_roll(n);
    return t;
}
static int scout_level(int ui) {          /* scoutLevel (game.js:8726) */
    int s = 0;
    if (strcmp(dat_units[CS.units[ui].type].name, "Scouts") == 0) s++;
    uint8_t p = CS.units[ui].profession;
    if (p >= 1 && p < DAT_JOBEXPERT_COUNT &&
        strcmp(dat_jobexpert[p], "Seasoned Scouts") == 0) s++;
    if (father_owned(father_by_name("Hernando de Soto"))) s++;
    return s;
}
static int type_row(const char *name) {
    for (int i = 0; i < DAT_UNITS_COUNT; i++)
        if (strcmp(dat_units[i].name, name) == 0) return i;
    return -1;
}
int enter_rumour(int ui, int x, int y) {
    int bit = y * COLOPY_MAP_W + x;
    CR.rumours_done[bit >> 3] |= (uint8_t)(1u << (bit & 7));
    int s = scout_level(ui);
    int n = d_roll(9);
    if (n < CR.rumour_floor) n = CR.rumour_floor;
    if (CR.rumour_floor < 3) CR.rumour_floor++;
    int quality = d_roll(100) + s * 10;
    if (n == 1 && (CR.found_fountain || quality < 10))
        n = quality < 10 ? 5 : 6;
    if (n == 2 && (CR.found_cibola || quality < 25)) n = 4;
    int tribe = (int)((rng_next() * 8u) >> 15);   /* G.tribes draw */
    PowerRecord *pw = &CS.powers[cs_nation()];
    switch (n) {
    case 1: {                        /* Fountain of Youth: 8 picked arrivals */
        CR.found_fountain = 1;
        CR.screen_map = 1;           /* woodcut 8 + the trace's dismissal */
        ev_emit("LOSTCITY1", 0, 0, 0, 0);
        for (int k = 0; k < 8; k++) {
            immigrant cands[3];
            for (int c = 0; c < 3; c++) roll_immigrant(&cands[c]);
            ev_emit("LOSTCITY0", 0, 0, 0, 0);
            int c = ask_choice();
            if (c < 0 || c > 2) c = 0;
            if (CR.n_dock_units <
                (int)(sizeof(CR.dock_units) / sizeof(CR.dock_units[0])))
                CR.dock_units[CR.n_dock_units++] = cands[c];
        }
        break;
    }
    case 2: {                        /* Cibola: a Treasure unit */
        CR.found_cibola = 1;
        int value = 10 * (s + 2) + d_roll(20);
        int t = unit_append(type_row("Treasure"), (int)cs_nation(), x, y);
        if (t >= 0) CR.unit_treasure[t] = (uint16_t)value;
        ev_emit("LOSTCITY2", value * 100, 0, 0, 0);
        break;
    }
    case 3: {                        /* ruins */
        int gold = 10 * dsum_roll(3, 8) * (s + 2) / 2;
        pw->gold += gold;
        ev_emit("LOSTCITY3", gold, 0, 0, 0);
        break;
    }
    case 4: {                        /* burial mounds: ask FIRST */
        ev_emit("LOSTCITY4", 0, 0, 0, 0);
        if (ask_choice() != 0) break;         /* stayed clear */
        int roll = d_roll(3);
        if (roll == 1) ev_emit("BURIAL1", 0, 0, 0, 0);
        else if (roll == 2) {
            int gold = 10 * dsum_roll(3, 8);
            pw->gold += gold;
            ev_emit("BURIAL2", gold, 0, 0, 0);
        } else {
            int value = 2 * (d_roll(8) + 2 * (s + 5));
            int t = unit_append(type_row("Treasure"), (int)cs_nation(), x, y);
            if (t >= 0) CR.unit_treasure[t] = (uint16_t)value;
            ev_emit("BURIAL3", value * 100, 0, 0, 0);
        }
        /* @SCREWED: a HOSTILE tribe's grounds — the unit is lost and the
         * tribe goes to the war footing (func_045DF2 @0x61B84). */
        if (CR.tension[tribe] >= 75) {
            ev_emit("SCREWED", 0, 0, dat_tribes[tribe].name, 0);
            unit_remove(ui);
            adjust_tension(tribe, 100, 4);
            return 0;                /* JS steps a DEAD object: no C step */
        }
        break;
    }
    case 5:                          /* the expedition vanishes */
        unit_remove(ui);
        ev_emit("LOSTCITY5", 0, 0, 0, 0);
        return 0;
    case 6:
        ev_emit("LOSTCITY6", 0, 0, 0, 0);
        break;
    case 7: {                        /* a friendly tribe's gift */
        int gold = 2 * dsum_roll(4, 10);
        pw->gold += gold;
        ev_emit("LOSTCITY7", gold, 0, 0, 0);
        break;
    }
    case 8:                          /* trespass on holy ground */
        adjust_tension(tribe, 20, 0);
        ev_emit("LOSTCITY8", 0, 0, dat_tribes[tribe].name, 0);
        break;
    default: {                       /* survivors swear allegiance */
        int first = -1;
        for (int ci = 0; ci < CS.n_colonies && first < 0; ci++)
            if ((CS.colonies[ci].owner_power & 3) == cs_nation()) first = ci;
        if (first >= 0) colonist_add(&CS.colonies[first]);
        else unit_append(type_row("Colonists"), (int)cs_nation(), x, y);
        ev_emit("LOSTCITY9", 0, 0, 0, 0);
        break;
    }
    }
    return 1;
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
    int me = (int)cs_nation();
    if (ship && !tile_water(v)) {
        /* a ship ordered onto land (game.js:10926): with land units
         * aboard the landing square must be clear of enemies
         * (@LANDFIRST); the landfall offer itself is an openDialog the
         * headless trace stubs inert, so nothing else happens. */
        if (CR.unit_n_pass[ui] > 0) {
            int hostile = 0;
            for (int k = 0; k < CR.n_natives && !hostile; k++) {
                int q = CR.natives_order[k];
                if (unit_pos_x(q) == nx && unit_pos_y(q) == ny) hostile = 1;
            }
            for (int rn = 0; rn < 4 && !hostile; rn++) {
                if (rn == me || !CR.rivals[rn].met ||
                    !rel_at_war(me, rn)) continue;
                for (int k = 0; k < CR.n_runits[rn] && !hostile; k++) {
                    int q = CR.runits_order[rn][k];
                    if (CR.runit_x[q] == nx && CR.runit_y[q] == ny)
                        hostile = 1;
                }
                for (int k = 0; k < CR.rivals[rn].n_col && !hostile; k++)
                    if (CR.rivals[rn].col[k].x == nx &&
                        CR.rivals[rn].col[k].y == ny) hostile = 1;
            }
            if (hostile) { ev_emit("LANDFIRST", 0, 0, 0, 0); return; }
        }
        return;
    }
    if (!ship && tile_water(v)) return;     /* land units stay ashore */
    if (ship) {
        /* @SHIPLAKE is INERT in the reference: its REGION plane labels
         * LAND components only, so every water tile compares 0 == 0
         * (game.js:482-503 vs 10950).  The interception zone
         * (func_059B90, game.js:10961): one check per move order. */
        int menace = -1, owner = -1;
        for (int rn = 0; rn < 4 && menace < 0; rn++) {
            if (rn == me || !CR.rivals[rn].met || !rel_at_war(me, rn))
                continue;
            for (int k = 0; k < CR.n_runits[rn] && menace < 0; k++) {
                int q = CR.runits_order[rn][k];
                if (dat_units[CS.units[q].type].hull <= 0) continue;
                if (dat_units[CS.units[q].type].attack <= 0) continue;
                int ax = CR.runit_x[q] - nx, ay = CR.runit_y[q] - ny;
                if (ax < 0) ax = -ax;
                if (ay < 0) ay = -ay;
                if (ax <= 1 && ay <= 1) { menace = q; owner = rn; }
            }
        }
        (void)owner;
        if (menace >= 0 && !CR.unit_slip[ui]) {
            CR.unit_slip[ui] = 1;
            if (rng_next() <= 16383) {
                ev_emit("SHIPRUN", 0, 0, dat_units[u->type].name, 0);
            } else {
                u->moves_remaining = (uint8_t)(u->moves_remaining > 3
                                                   ? u->moves_remaining - 3
                                                   : 0);
                CR.unit_moves_undef[ui] = 0;
                ev_emit("SHIPSLOW", 0, 0, dat_units[u->type].name, 0);
            }
        }
    }
    /* an occupied tile — a native/squatter (attack §14, with the §14.3
     * tired-troops @HALF ask), a rival (parley/war/trade/scout), a
     * village, a rumour square: each an EXPLICIT no-op pending slices
     * 3-5; the scripted harness filters these targets on both sides, so
     * a no-op here is parity-safe and no unexercised port ships. */
    {
        /* a native brave or a King's unit on the target square is an
         * attack (§14; game.js:10984): @CANNOTATTACK gates a zero-
         * rating land attacker, tired troops get the §14.3 @HALF ask
         * BEFORE the roll, natives take the act-of-war tension hit
         * (@PISS4), and the JS ends every arm in advance(). */
        int foe = -1, foe_tribe = -1;
        for (int k = 0; k < CR.n_natives && foe < 0; k++) {
            int q = CR.natives_order[k];
            if (unit_pos_x(q) == nx && unit_pos_y(q) == ny) {
                foe = q;
                foe_tribe = (CS.units[q].owner_flags & 0x0F) - 4;
            }
        }
        for (int k = 0; k < (int)CR.n_refs && foe < 0; k++) {
            int q = CR.refs_order[k];
            if (unit_pos_x(q) == nx && unit_pos_y(q) == ny) foe = q;
        }
        if (foe >= 0) {
            if (!ship && dat_units[u->type].attack <= 0) {
                ev_emit("CANNOTATTACK", 0, 0, 0, 0);
                return;
            }
            int full = unit_full_moves(ui);
            int tired = u->moves_remaining < full;
            if (tired && !ship) {
                CR.unit_fatigue[ui] =
                    (uint8_t)(u->moves_remaining * 3 <= full ? 2 : 1);
                ev_emit("HALF", CR.unit_fatigue[ui] == 2 ? 1 : 2, 0, 0, 0);
                if (ask_choice() != 0) {   /* row 1: let them rest */
                    CR.unit_fatigue[ui] = 0;
                    u->moves_remaining = 0;
                    CR.unit_moves_undef[ui] = 0;
                    CR.ui_advance = 1;
                    return;
                }
            } else
                CR.unit_fatigue[ui] = 0;
            int removed = resolve_attack(ui, foe);
            if (foe_tribe >= 0 && foe_tribe < 8)
                adjust_tension(foe_tribe, 100, 4);
            /* strike()'s u.fatigue = 0 — on the surviving record only
             * (the JS writes a dead object, which is inert) */
            int at = ui;
            if (removed >= 0 && removed < at) at--;
            if (removed != ui) CR.unit_fatigue[at] = 0;
            CR.ui_advance = 1;
            return;
        }
    }
    /* a rival power's unit or colony (game.js:11023): at peace a SHIP
     * knocks (parley / privateer strike / treaty break); at war ship vs
     * ship is navalAttack.  The LAND-side rival branches (resolveAttack,
     * colony capture, trade, scout) stay with slice 5 — the scripted
     * harness filters land moves off rival tiles. */
    {
        int rival = -1, ruP = -1, is_col = 0;
        for (int rn = 0; rn < 4 && rival < 0; rn++) {
            if (rn == me || !CR.rivals[rn].met) continue;
            for (int k = 0; k < CR.n_runits[rn] && ruP < 0; k++) {
                int q = CR.runits_order[rn][k];
                if (CR.runit_x[q] == nx && CR.runit_y[q] == ny) ruP = q;
            }
            for (int k = 0; k < CR.rivals[rn].n_col; k++)
                if (CR.rivals[rn].col[k].x == nx &&
                    CR.rivals[rn].col[k].y == ny) is_col = 1;
            if (ruP >= 0 || is_col) rival = rn;
        }
        if (rival >= 0) {
            if (!ship) return;               /* land rival moves: slice 5 */
            int ruP_ship = ruP >= 0 &&
                           dat_units[CS.units[ruP].type].hull > 0;
            /* the Privateer's HIDDEN attribution (war_matrix 0x80
             * @0x3F0A1): strike rival shipping at peace */
            if (!rel_at_war(me, rival) &&
                strcmp(dat_units[u->type].name, "Privateer") == 0 &&
                ruP >= 0 && ruP_ship) {
                rel_set_privateer(me, rival);
                naval_attack(ui, ruP);
                return;
            }
            /* @HAVETREATY: attacking a treaty partner asks first */
            if (!rel_at_war(me, rival) && rel_have_treaty(me, rival) &&
                ruP >= 0 && ruP_ship) {      /* same element: both ships */
                ev_emit("HAVETREATY", 0, 0,
                        dat_nations[rival].adjective, 0);
                if (ask_choice() == 1) {
                    ev_emit("CANCELPEACE", 0, 0,
                            dat_nations[me].adjective,
                            dat_nations[rival].adjective);
                    rel_declare_war(me, rival);
                }
                return;
            }
            if (rel_at_war(me, rival)) {
                if (ruP >= 0 && ruP_ship) { naval_attack(ui, ruP); return; }
                return;                      /* other war arms: slice 5 */
            }
            /* peace: the parley (water tiles carry no colony, so the
             * trade/scout arms cannot arise here) */
            if (!rel_parley_eligible(rival)) return;   /* msg only */
            u->moves_remaining = 0;
            CR.unit_moves_undef[ui] = 0;
            run_meeting(rival, 1);
            return;
        }
    }
    for (int vi = 0; vi < CS.n_villages; vi++)
        if (CS.villages[vi].map_x == nx && CS.villages[vi].map_y == ny) {
            /* enterVillage (game.js:11146): the move is spent and the
             * @ACTIONS menu opens (CR.cur_village); the action itself
             * comes from the caller (the script / future UI). */
            u->moves_remaining = 0;
            CR.unit_moves_undef[ui] = 0;
            village_enter(vi, ui);
            return;
        }
    /* a rumour square triggers the exploration event; one outcome
     * destroys the unit before it ever arrives (game.js:11162) */
    if (rumour_at(nx, ny) && !enter_rumour(ui, nx, ny)) return;
    /* the right-edge sea lane asks @SAILHOME via openDialog — stubbed
     * inert headless, and the ship does NOT step (game.js:11153) */
    if (ship && tile_terrain(v) == TERR_SEALANE) return;
    /* step (game.js:10833): one step is always affordable; the budget
     * floors at zero.  reveal/tutorial/centring are presentation. */
    int cost = move_cost(ship, u->map_x, u->map_y, nx, ny);
    u->moves_remaining = (uint8_t)(cost > u->moves_remaining
                                       ? 0 : u->moves_remaining - cost);
    u->map_x = (uint8_t)nx;
    u->map_y = (uint8_t)ny;
}
