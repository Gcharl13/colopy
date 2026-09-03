/* The player-command layer — Phase 5 slice 2.  Each function mirrors a
 * game.js UI command over the records + CR runtime; the byte citations
 * live with the JS originals (spec/systems/terrain_improvement.md §);
 * every move target is handled: ships at sea and the sea lane, attacks
 * (native, REF, the @HALF fatigue ask), the rival land arms, village
 * entry and rumour entry.  This header used to say those were "an
 * EXPLICIT no-op, slices 3-5"; that was stale and struck 2026-08-19
 * after it had been read as current by ledger row B4.5 and by a status
 * overview.
 *
 * Movement budgets are THIRDS (MOVE_UNIT = 3): the @UNIT loader
 * multiplies the movement column by 3 (`SHL al,1 / ADD al,cl` @0x074F04,
 * unit.md §3); a road/river step costs 1. */
#include <stdio.h>
#include <stdlib.h>
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
    /* @0x61BC (func_006188): a claimed plane-3 OWNER nibble (anything
     * but 0xF -- func_005DF0) suppresses the rumour.  Mirrors game.js. */
    if ((CS.region[y * COLOPY_MAP_W + x] >> 4) != 0x0F) return 0;
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
/* scoutLevel -- func_061454 @0x0614A6-@0x0614E3 (C4.26 unit side,
 * 2026-09-02): level = 1 iff the TYPE is Scouts (`cmp [bx+0x3146], 5`);
 * the Seasoned test (`cmp [bx+0x315B], 0x16` @0x0614BB -- plain byte
 * equality, no `>= 1` guard) runs ONLY inside that branch (@0x0614B7);
 * de Soto (attribute 7, @0x0614C6) adds one ONLY when the level is
 * already non-zero (`cmp [bp-0x34], 0; je` @0x0614D8).  The port added
 * both unconditionally.  Both engines changed together. */
static int scout_level(int ui) {
    int s = strcmp(dat_units[CS.units[ui].type].name, "Scouts") == 0;
    uint8_t p = CS.units[ui].profession;
    if (s && p < DAT_JOBEXPERT_COUNT &&
        strcmp(dat_jobexpert[p], "Seasoned Scouts") == 0) s++;
    if (s && father_owned(father_by_name("Hernando de Soto"))) s++;
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
    CR.unit_moves[ui] = 0;
    CR.unit_moves_undef[ui] = 0;         /* a NUMBER was written */
}

/* setOrder (game.js:11181): orders n, moves spent.  Fortify is the one
 * order with a sound: func_021FF2 (the Fortify command; ships jump
 * straight there @0x22031) plays 0x58 @0x220F9 right before writing
 * orders = 5 @0x022105 — the same pair the @UNITOPTIONS row 4 handler
 * writes @0x2B26A/@0x2B273.  (Its adjacent-treaty-partner @HAVETREATY
 * ask @0x220CE is not modelled.) */
void cmd_set_order(int ui, int n) {
    if (n == 5) snd_play(0x58);
    CS.units[ui].orders = (uint8_t)n;
    CR.unit_moves[ui] = 0;
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
    if (CR.unit_moves_undef[ui] || !CR.unit_moves[ui]) {
        if (CR.unit_no_moves[ui]) CR.unit_moves_undef[ui] = 1;
        else {
            CR.unit_moves_undef[ui] = 0;
            CR.unit_moves[ui] = (uint8_t)unit_full_moves(ui);
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

/* buildColony (game.js:11258): the B key.  The name dialog at the end
 * is an openDialog — inert under the shared conventions — so a
 * headless FOUNDING stops at it: only the guards, the native land
 * claim (with its tension/gold effects) and the site-scan ask chain
 * run.  JOINING a colony on the same tile completes: unitToColonist
 * (game.js:2005 — the outfit stands down into the stores) + the record
 * splice.  Returns the joined colony's PLAYER ordinal, -1 otherwise. */
static int colony_rec_at(int x, int y) {        /* player colonies only */
    for (int i = 0; i < CS.n_colonies; i++)
        if ((CS.colonies[i].owner_power & 3) == (int)cs_nation() &&
            CS.colonies[i].map_x == x && CS.colonies[i].map_y == y)
            return i;
    return -1;
}
int cmd_build_colony(int ui) {
    UnitRecord *u = &CS.units[ui];
    int x = u->map_x, y = u->map_y;
    uint8_t v = map_at(x, y);
    const char *tn = dat_units[u->type].name;
    if (dat_units[u->type].hull > 0 || tile_water(v)) {
        ev_emit("SEACOLONY", 0, 0, 0, 0);
        return -1;
    }
    if (strcmp(tn, "Wagon Train") == 0 || strcmp(tn, "Artillery") == 0 ||
        strcmp(tn, "Treasure") == 0) {           /* NOT_COLONISTS */
        ev_emit("ONLYCOL", 0, 0, 0, 0);
        return -1;
    }
    int here = colony_rec_at(x, y);
    if ((CR.woi_flags & WOI_DECLARED) && !(CR.woi_flags & WOI_WON) &&
        here < 0) {
        ev_emit("NOCOLONIESEITHER", 0, 0, 0, 0);
        return -1;
    }
    if (tile_mountains(v)) { ev_emit("TOOMOUNTAIN", 0, 0, 0, 0); return -1; }
    if (here < 0)
        for (int i = 0; i < CS.n_colonies; i++) {
            if ((CS.colonies[i].owner_power & 3) != (int)cs_nation())
                continue;
            int dx = CS.colonies[i].map_x - x, dy = CS.colonies[i].map_y - y;
            if (dx < 0) dx = -dx;
            if (dy < 0) dy = -dy;
            if ((dx > dy ? dx : dy) <= 1) {      /* chebyshev, flagged */
                ev_emit("TOONEAR", 0, 0, CS.colonies[i].name, 0);
                return -1;
            }
        }
    if (here >= 0) {                             /* Join Colony (B) */
        ColonyRecord *c = &CS.colonies[here];
        if (u->tools) c->stock[TOOLS] = (uint16_t)(c->stock[TOOLS] + u->tools);
        if (strcmp(tn, "Soldiers") == 0)
            c->stock[MUSKETS] = (uint16_t)(c->stock[MUSKETS] + 50);
        else if (strcmp(tn, "Dragoons") == 0) {
            c->stock[MUSKETS] = (uint16_t)(c->stock[MUSKETS] + 50);
            c->stock[HORSES] = (uint16_t)(c->stock[HORSES] + 50);
        } else if (strcmp(tn, "Scouts") == 0)
            c->stock[HORSES] = (uint16_t)(c->stock[HORSES] + 50);
        uint8_t prof = u->profession;
        colonist_add(c);
        if (c->population > 0)
            c->profession[c->population - 1] = prof;
        unit_remove(ui);
        int ord = -1;
        for (int i = 0; i <= here; i++)
            if ((CS.colonies[i].owner_power & 3) == (int)cs_nation()) ord++;
        return ord;
    }
    /* the founding path: the native land claim, then the site scans */
    int claim = -1;
    for (int i = 0; i < CS.n_villages; i++) {
        int dx = CS.villages[i].map_x - x, dy = CS.villages[i].map_y - y;
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        if (dx <= 2 && dy <= 2) { claim = i; break; }
    }
    int tribe = claim >= 0 ? (CS.villages[claim].owner_tribe & 0x0F) - 4 : -1;
    if (tribe >= 0 && tribe < 8) {
        if (CR.tension[tribe] < 20) {
            if (rng_next() <= 16383) {           /* Math.random() < 0.5 */
                ev_emit("INDIANTREATY", 0, 0, dat_tribes[tribe].name,
                        dat_nations[cs_nation()].adjective);
                if (ask_choice() == 0) CR.tension[tribe] = 0;
            } else {
                ev_emit("INDIANBOW", 0, 0, dat_tribes[tribe].name,
                        dat_nations[cs_nation()].adjective);
            }
        } else {
            int32_t pay = father_owned(father_by_name("Peter Minuit"))
                              ? 0 : demand_value(100);
            ev_emit("INDIANLAND", 0, pay, dat_tribes[tribe].name, 0);
            int c = ask_choice();
            if (c == 0) return -1;               /* we leave */
            if (c == 1) {
                PowerRecord *p = &CS.powers[cs_nation()];
                if (p->gold < pay) {
                    ev_emit("NOTENOUGH", p->gold, 0, 0, 0);
                    return -1;
                }
                p->gold -= pay;
                ev_emit("INDIANBRIBE", 0, 0, 0, 0);
            } else {
                adjust_tension(tribe, 15, 5);    /* @PISS5 */
            }
        }
    }
    /* the site scans (func_022542): NOPORT, then the two tutorial scans
     * below difficulty 2; row 2 ("proceed") continues the chain */
    int water = 0, productive = 0, forested = 0;
    for (int dy = -1; dy <= 1; dy++)
        for (int dx = -1; dx <= 1; dx++) {
            if (!dx && !dy) continue;
            int nx = x + dx, ny = y + dy;
            if (nx < 0 || ny < 0 || nx >= COLOPY_MAP_W || ny >= COLOPY_MAP_H)
                continue;
            uint8_t nv = map_at(nx, ny);
            if (tile_water(nv)) { water++; continue; }
            int t = tile_terrain(nv);
            if (t >= 8 && t <= 23) forested++;   /* isForested (fold) */
            if (!tile_mountains(nv) && t != 24) productive++;
        }
    const char *scans[3];
    int ns = 0;
    if (!water) scans[ns++] = "NOPORT";
    if (cs_difficulty() < 2 && productive < 4) scans[ns++] = "TUTNOSPACES";
    if (cs_difficulty() < 2 && !forested) scans[ns++] = "TUTNOLUMBER";
    for (int i = 0; i < ns; i++) {
        ev_emit(scans[i], 0, 0, 0, 0);
        if (ask_choice() != 1) return -1;        /* row 2 proceeds */
    }
    /* nameAndFound: openDialog('COLONY') — inert headless.  -2 tells a
     * LIVE front end (colopy_front_live) the scans passed and a name
     * would found; the harness treats it like -1 (the JS side's pending
     * dialog is discarded). */
    return -2;
}

/* the shared fresh-colony record shape (nameAndFound's nc object,
 * game.js:11332): empty stores, no target, the upkeep-0 min_colony-1
 * starting buildings — set on the RUNTIME list (the record's
 * tier-packed field is left zeroed, FLAGGED like the raid removals). */
static void colony_record_reset(int ci) {
    ColonyRecord *c = &CS.colonies[ci];
    c->population = 0;
    memset(c->occupation, 0xFF, sizeof(c->occupation));
    memset(c->profession, 0, sizeof(c->profession));
    memset(c->tiles, 0xFF, sizeof(c->tiles));
    memset(c->buildings, 0, sizeof(c->buildings));
    memset(c->stock, 0, sizeof(c->stock));
    c->hammers = 0;
    c->building_in_production = 0xFF;
    c->warehouse_level = 0;
    c->rebel_dividend = 0;
    c->rebel_divisor = 0;
    c->colony_flags = 0;
    CR.col[ci].n_bld = 0;
    for (int b = 0; b < DAT_BUILDINGS_COUNT; b++)
        if (dat_buildings[b].upkeep == 0 && dat_buildings[b].min_colony == 1)
            colony_bld_append(ci, b);
    CR.col[ci].sol = 0;
    CR.col[ci].sol_band = 0xFF;
    CR.col[ci].latch = 0;
    CR.col[ci].tool_warned = 0;
}

/* the rival-capture re-found (game.js:11066): our flag, the fresh
 * shape, pop colonists clamped 1..3 */
void colony_capture_record(int ci, int pop) {
    ColonyRecord *c = &CS.colonies[ci];
    c->owner_power = (uint8_t)cs_nation();
    colony_record_reset(ci);
    int n = pop < 1 ? 1 : pop > 3 ? 3 : pop;
    for (int k = 0; k < n; k++) colonist_add(c);
}

/* nameAndFound (game.js:11330), run by a LIVE front end after
 * cmd_build_colony returns -2: NULL name = the suggested
 * colonynames[nation][count % 66].  The founder stands down like a
 * joiner.  Returns the new colony's player ordinal. */
/* the name cmd_found_colony would pick — the live front's @COLONY
 * prefill (nameAndFound, game.js:2123) */
const char *colony_suggested_name(void) {
    int nplayer = 0;
    for (int i = 0; i < CS.n_colonies; i++)
        if ((CS.colonies[i].owner_power & 3) == (int)cs_nation()) nplayer++;
    const char *n = dat_colonynames[cs_nation()][nplayer % 66];
    return n ? n : "Colony";
}

int cmd_found_colony(int ui, const char *name) {
    if (CS.n_colonies >= COLOPY_MAX_COLONIES) return -1;
    UnitRecord *u = &CS.units[ui];
    int nplayer = 0;
    for (int i = 0; i < CS.n_colonies; i++)
        if ((CS.colonies[i].owner_power & 3) == (int)cs_nation()) nplayer++;
    if (!name) name = dat_colonynames[cs_nation()][nplayer % 66];
    if (!name) name = "Colony";              /* padded-table guard */
    int ci = CS.n_colonies++;
    ColonyRecord *c = &CS.colonies[ci];
    memset(c, 0, sizeof(*c));
    c->map_x = u->map_x;
    c->map_y = u->map_y;
    c->owner_power = (uint8_t)cs_nation();
    /* founding sets improvement-plane bit 0x10 on the tile
     * (func_005D4E(x,y,0x10,1) @0x0222E6..0x0222F0 / @0x0224E9..
     * 0x0224F3); removal clears 0x02 (colony_removed_fixup) (C3.10) */
    CS.improve[c->map_y * COLOPY_MAP_W + c->map_x] |= 0x10;
    /* A new colony lifts the fog over its whole working area.  The
     * colony screen's scene panel draws the 5x5 around the town
     * (spec/ui/colony_screen.md 3.8), so anything still fogged there
     * shows as fog INSIDE the colony you just built.  r=2 covers that
     * 5x5 exactly.  Fog is CR runtime, not .SAV state, so this touches
     * no record and no oracle field.  User report 2026-08-17. */
    colopy_reveal(c->map_x, c->map_y, 2);
    snprintf(c->name, sizeof(c->name), "%s", name);
    colony_record_reset(ci);
    const char *tn = dat_units[u->type].name;
    if (u->tools) c->stock[TOOLS] = (uint16_t)(c->stock[TOOLS] + u->tools);
    if (strcmp(tn, "Soldiers") == 0)
        c->stock[MUSKETS] = (uint16_t)(c->stock[MUSKETS] + 50);
    else if (strcmp(tn, "Dragoons") == 0) {
        c->stock[MUSKETS] = (uint16_t)(c->stock[MUSKETS] + 50);
        c->stock[HORSES] = (uint16_t)(c->stock[HORSES] + 50);
    } else if (strcmp(tn, "Scouts") == 0)
        c->stock[HORSES] = (uint16_t)(c->stock[HORSES] + 50);
    uint8_t prof = u->profession;
    colonist_add(c);
    if (c->population > 0) c->profession[c->population - 1] = prof;
    /* the engine seats the founder AS A FARMER: the create path calls
     * the colonist op with job 0 (0x181F:0xC36(slot, 0) @0x2ED3A ->
     * the mode-0 occupation write @0x94D6).  The +0x70 cell array
     * stays 0xFF there, so WHICH field is the port's best-food pick
     * over the eight worker cells, FLAGGED — mirrors the JS. */
    if (c->population > 0) {
        int slot = c->population - 1;
        c->occupation[slot] = 0;                 /* Farmer */
        int best = -1, best_y = -1;
        for (int k = 0; k < 8; k++) {
            int y = field_yield(c, CR.col[ci].sol, 0, prof,
                                colony_cell_dx[k], colony_cell_dy[k]);
            if (y > best_y) { best_y = y; best = k; }
        }
        if (best >= 0) c->tiles[best] = (int8_t)slot;
    }
    unit_remove(ui);
    /* sfx 0x54 for a human power's new colony — func_040C1E @0x040DF6,
     * gated on [0x5394] < 4 and controller 0 (@0x40DE3..0x40DF4), fired
     * on EVERY founding, before the once-only woodcut 2 @0x40E00 */
    snd_play(0x54);
    /* the FIRST colony fires woodcut 2, BUILDING A COLONY
     * (buildColony game.js:2150; dismissal opens the colony, 12093) */
    if (!CR.built_colony) {
        CR.built_colony = 1;
        if (!(CR.wc_seen & (1u << 2))) {
            CR.wc_seen |= 1u << 2;   /* the JS stub latches too */
            if (colopy_front_live) {
                CR.wc_show = 2;
                CR.wc_after = 0;     /* plate 2 routes by number */
            }
        }
    }
    return nplayer;
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
    CR.unit_moves[u - CS.units] = 0;
    CR.unit_moves_undef[ui] = 0;
    if (n == 9) work_objection(ui, 1);
    if (n == 8 && is_forested_id(tile_terrain(v))) work_objection(ui, 0);
}

/* moveSel (game.js:10919) — COMPLETE, and the comment that used to sit
 * here was three slices out of date.
 *
 * It said this was "the slice-2 subset: a LAND unit taking one step onto
 * empty legal ground", with ship movement, attacks, rival tiles and
 * village entry all "an explicit no-op here".  None of that is true any
 * more: attacks resolve (natives, REF, the @HALF fatigue ask), the rival
 * land arms are complete (war ladder, treaty ask, Wagon Train trade,
 * Scout dialog, parley), village_enter() runs, enter_rumour() runs, and
 * the sea lane is handled below.  Struck 2026-08-19 in the staleness
 * sweep — it had been read as current and had put a false "several move
 * targets are no-ops" row in the ledger (B4.5) and in a status overview.
 *
 * The one genuine limit that survives is narrow and immediately below:
 * a rival-born unit whose movesLeft is undefined. */
void cmd_move(int ui, int dx, int dy) {
    UnitRecord *u = &CS.units[ui];
    /* undefined movesLeft (rival-born, see colopy_sim.h) would slip the
     * JS <= 0 test and NaN-step; the shared script filter (movesLeft > 0)
     * keeps both engines off that path, so it stays unported. */
    if (CR.unit_moves_undef[ui]) return;
    if (CR.unit_moves[u - CS.units] <= 0) return;
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
            /* the landfall offer (openDialog @LANDFALL/@LANDFALL2 —
             * river-mouth variant — game.js:10899): inert under the
             * headless trace; on a LIVE front the ask goes to the
             * player and row 1 puts the party ashore (10901-10912) */
            if (colopy_front_live) {
                ev_emit(tile_river(v) ? "LANDFALL2" : "LANDFALL",
                        0, 0, 0, 0);
                if (ask_choice() == 1) {
                    int first = -1;
                    for (int p = 0; p < CR.unit_n_pass[ui]; p++) {
                        const immigrant *e = &CR.unit_pass[ui][p];
                        int t = e->kind == 4 ? e->type_ov - 1 : e->idx;
                        if (t < 0 || t >= DAT_UNITS_COUNT) continue;
                        int ni = unit_append(t, me, nx, ny);
                        if (ni < 0) continue;
                        if (e->kind == 4)
                            CS.units[ni].profession = e->idx;
                        if (strcmp(dat_units[t].name, "Pioneers") == 0)
                            CS.units[ni].tools = 100;  /* mkUnit 664 */
                        if (first < 0) first = ni;
                    }
                    CR.unit_n_pass[ui] = 0;
                    CR.unit_moves[u - CS.units] = 0;
                    /* the party ashore takes over from the ship (10905) */
                    if (first >= 0)
                        for (int k = 0; k < CR.n_units_order; k++)
                            if (CR.units_order[k] == first)
                                CR.ui_select = (int16_t)k;
                    /* first landfall: woodcut 1, DISCOVERY OF THE NEW
                     * WORLD (10909; once per game) */
                    if (!CR.land_ho) {
                        CR.land_ho = 1;
                        if (!(CR.wc_seen & (1u << 1))) {
                            CR.wc_seen |= 1u << 1;
                            CR.wc_show = 1;
                            CR.wc_after = 0;
                        }
                    }
                    /* TUTORIAL13: the pioneers have stepped ashore
                     * (landfall, game.js; bytes: pioneer focus on land,
                     * turn < 20, func_020F50 @0x0210B9..0x0210C4) */
                    tut_once(13, 0, 0, 0, 0);
                }
            }
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
                CR.unit_moves[u - CS.units] = (uint8_t)(CR.unit_moves[u - CS.units] > 3
                                                   ? CR.unit_moves[u - CS.units] - 3
                                                   : 0);
                CR.unit_moves_undef[ui] = 0;
                ev_emit("SHIPSLOW", 0, 0, dat_units[u->type].name, 0);
            }
        }
    }
    /* an occupied tile — a native/squatter (attack §14, with the §14.3
     * tired-troops @HALF ask), a rival (parley/war/trade/scout), a
     * village, a rumour square.  All of these are IMPLEMENTED; the
     * "each an EXPLICIT no-op pending slices 3-5" wording that stood
     * here was stale (see the head of this file). */
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
            int tired = CR.unit_moves[u - CS.units] < full;
            if (tired && !ship) {
                CR.unit_fatigue[ui] =
                    (uint8_t)(CR.unit_moves[u - CS.units] * 3 <= full ? 2 : 1);
                ev_emit("HALF", CR.unit_fatigue[ui] == 2 ? 1 : 2, 0, 0, 0);
                if (ask_choice() != 0) {   /* row 1: let them rest */
                    CR.unit_fatigue[ui] = 0;
                    CR.unit_moves[u - CS.units] = 0;
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
            int ruP_ship = ruP >= 0 &&
                           dat_units[CS.units[ruP].type].hull > 0;
            if (!ship) {
                /* the LAND arms (game.js:11040-11146), complete: the
                 * war ladder, the treaty ask, the Wagon Train trade,
                 * the Scout dialog, then the parley. */
                if (rel_at_war(me, rival)) {
                    if (is_col && (CR.woi_flags & WOI_DECLARED)) {
                        ev_emit("NOWARSDURINGREV", 0, 0, 0, 0);
                        return;
                    }
                    if (dat_units[u->type].attack <= 0) {
                        ev_emit("CANNOTATTACK", 0, 0, 0, 0);
                        return;
                    }
                    if (ruP >= 0) {          /* land battle */
                        resolve_attack(ui, ruP);
                        CR.ui_advance = 1;
                        return;
                    }
                    if (is_col) {
                        /* an undefended colony FALLS (@CAPTURED): the
                         * rival mirror loses it, the RECORD at the site
                         * re-founds as ours — fresh stores + the
                         * starting buildings, pop clamped 1..3; the
                         * plunder roll is the port's FLAGGED stand-in
                         * (game.js:11065) */
                        rival_rt *r = &CR.rivals[rival];
                        int rc = -1;
                        for (int k2 = 0; k2 < r->n_col; k2++)
                            if (r->col[k2].x == nx && r->col[k2].y == ny) {
                                rc = k2;
                                break;
                            }
                        if (rc >= 0) {
                            int pop = r->col[rc].pop ? r->col[rc].pop : 1;
                            int32_t loot = 10 *
                                (1 + (int)((rng_next() * 10u) >> 15)) *
                                (1 + pop);
                            CS.powers[me].gold += loot;
                            memmove(&r->col[rc], &r->col[rc + 1],
                                    (size_t)(r->n_col - rc - 1) *
                                        sizeof(r->col[0]));
                            r->n_col--;
                            int ci2 = -1;
                            for (int k2 = 0; k2 < CS.n_colonies; k2++)
                                if (CS.colonies[k2].map_x == nx &&
                                    CS.colonies[k2].map_y == ny) {
                                    ci2 = k2;
                                    break;
                                }
                            if (ci2 >= 0) colony_capture_record(ci2, pop);
                            /* sfx 0x4B: a European attacker at a colony
                             * tile with no defending unit, shown —
                             * func_05CA7E @0x5D5B7..0x5D5C7 ([bp-0xd8]
                             * = European + colony + no defender
                             * @0x5D4C4..0x5D4D8) */
                            snd_play(0x4B);
                            ev_emit((CR.woi_flags & WOI_DECLARED)
                                        ? "CAPTURED3" : "CAPTURED",
                                    loot, 0, dat_nations[me].adjective,
                                    ci2 >= 0 ? CS.colonies[ci2].name : 0);
                            CR.unit_moves[u - CS.units] = 0;
                            CR.unit_moves_undef[ui] = 0;
                            CR.ui_advance = 1;
                            return;
                        }
                    }
                    /* "the colony holds" — msg only, the move is spent */
                    CR.unit_moves[u - CS.units] = 0;
                    CR.unit_moves_undef[ui] = 0;
                    CR.ui_advance = 1;
                    return;
                }
                if (rel_have_treaty(me, rival) && ruP >= 0 && !ruP_ship) {
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
                if (is_col &&
                    strcmp(dat_units[u->type].name, "Wagon Train") == 0) {
                    /* foreign-colony TRADE (func_05A40E, game.js:11105):
                     * Jan de Witt gates it, the first hold slot barters
                     * for goods (2:1 by value) or gold (bid + 25%) —
                     * the GREATKINGS display string is FLAGGED TBD */
                    if (!father_owned(father_by_name("Jan de Witt"))) {
                        ev_emit("TRADEMERCANTILISM", 0, 0, 0, 0);
                        return;
                    }
                    int slot = -1;
                    for (int s2 = 0; s2 < CR.unit_n_hold[ui]; s2++)
                        if (CR.unit_hold[ui][s2].qty > 0) { slot = s2; break; }
                    if (slot < 0) { ev_emit("DEFICIT", 0, 0, 0, 0); return; }
                    hold_slot h = CR.unit_hold[ui][slot];
                    int32_t my_val = market_bid(h.good) * h.qty;
                    int32_t offer_gold = my_val * 5 / 4;
                    int og = (h.good + 1) % 16;
                    while (og == h.good || market_ask(og) <= 0)
                        og = (og + 1) % 16;
                    int32_t offer_qty = my_val * 2 / market_ask(og);
                    if (offer_qty < 1) offer_qty = 1;
                    ev_emit("TRADEWITH", offer_qty, h.qty,
                            dat_cargo[og].name, dat_cargo[h.good].name);
                    int c2 = ask_choice();
                    if (c2 == 0) {
                        hold_add(CR.unit_hold[ui], &CR.unit_n_hold[ui],
                                 h.good, -h.qty);
                        hold_add(CR.unit_hold[ui], &CR.unit_n_hold[ui],
                                 og, offer_qty);
                    } else if (c2 == 1) {
                        hold_add(CR.unit_hold[ui], &CR.unit_n_hold[ui],
                                 h.good, -h.qty);
                        CS.powers[me].gold += offer_gold;
                    }
                    CR.unit_moves[u - CS.units] = 0;
                    CR.unit_moves_undef[ui] = 0;
                    return;
                }
                if (is_col &&
                    strcmp(dat_units[u->type].name, "Scouts") == 0) {
                    /* scoutColony (func_05A20E, game.js:11130): mayor's
                     * reception / spy on defences / attack / leave.
                     * Mayor reveals r=3 (6967); a WON spy roll reveals
                     * r=4 (6976), a lost one LOSES the scout.  The
                     * JS X = target.colonists?.length ?? 3 — rival
                     * colonies carry no colonist list, so X is the
                     * CONSTANT 3 (the JS reading, mirrored). */
                    CR.unit_moves[u - CS.units] = 0;
                    CR.unit_moves_undef[ui] = 0;
                    ev_emit("SCOUTCOLONY", 0, 0, 0, 0);
                    int c2 = ask_choice();
                    if (c2 == 0) {
                        if (CR.woi_flags & WOI_DECLARED)
                            ev_emit("NOMAYORSDURINGREV", 0, 0, 0, 0);
                        else colopy_reveal(nx, ny, 3);
                    } else if (c2 == 1) {
                        int need = (3 + 6) * 2 + (cs_difficulty() - 2);
                        uint8_t pr = u->profession;
                        if (pr >= 1 && pr < DAT_JOBEXPERT_COUNT &&
                            strcmp(dat_jobexpert[pr], "Seasoned Scouts") == 0)
                            need >>= 1;
                        if (1 + (int)((rng_next() * 36u) >> 15) > need)
                            unit_remove(ui);   /* caught and lost */
                        else colopy_reveal(nx, ny, 4);
                    }
                    CR.ui_advance = 1;
                    return;
                }
                if (!rel_parley_eligible(rival)) return;   /* msg only */
                CR.unit_moves[u - CS.units] = 0;
                CR.unit_moves_undef[ui] = 0;
                run_meeting(rival, 1);
                return;
            }
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
            CR.unit_moves[u - CS.units] = 0;
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
            CR.unit_moves[u - CS.units] = 0;
            CR.unit_moves_undef[ui] = 0;
            village_enter(vi, ui);
            return;
        }
    /* a rumour square triggers the exploration event; one outcome
     * destroys the unit before it ever arrives (game.js:11162) */
    if (rumour_at(nx, ny) && !enter_rumour(ui, nx, ny)) return;
    /* the right-edge sea lane asks @SAILHOME via openDialog — inert
     * under the harness, and the ship does NOT step (game.js:11153).
     * A live front puts the ask to the player: WoI closes the crossing
     * (@EUROPENOTLEAVE, 11156); choice 0 sails for Europe (11157). */
    if (ship && tile_terrain(v) == TERR_SEALANE) {
        if (colopy_front_live) {
            if ((CR.woi_flags & WOI_DECLARED) && !(CR.woi_flags & WOI_WON)) {
                ev_emit("EUROPENOTLEAVE", 0, 0, 0, 0);
                return;
            }
            ev_emit("SAILHOME", 0, 0, 0, 0);
            if (ask_choice() == 0) cmd_sail_for_europe(ui);
        }
        return;
    }
    /* step (game.js:10833): one step is always affordable; the budget
     * floors at zero.  tutorial/centring are presentation; the fog
     * reveal (10839) is state — the plane rides in the .SAV. */
    int cost = move_cost(ship, u->map_x, u->map_y, nx, ny);
    CR.unit_moves[u - CS.units] = (uint8_t)(cost > CR.unit_moves[u - CS.units]
                                       ? 0 : CR.unit_moves[u - CS.units] - cost);
    u->map_x = (uint8_t)nx;
    u->map_y = (uint8_t)ny;
    /* sfx 0x52: a human Wagon Train arriving on a colony tile —
     * func_03ECF0 @0x3F5C4..0x3F5E3 (type 0xC, owner nibble < 4,
     * controller 0, after func_008D26(x,y) >= 0 @0x3F5AE).  The engine
     * tests ANY colony; the port only lands here on its own (a foreign
     * colony returns through the trade branch above). */
    if (strcmp(dat_units[u->type].name, "Wagon Train") == 0 &&
        colony_rec_at(nx, ny) >= 0)
        snd_play(0x52);
    colopy_reveal(nx, ny, unit_sight_radius(ui));
    /* DISCOVERY: byte-read 2026-09-03 (func_03FDDE @0x3FF81..@0x3FFEF,
     * RULINGS 2026-09-03f): after ANY successful move of the current
     * nation's unit, while the [0x543E] bit 0x80 latch is clear, the
     * first non-water tile of the 3x3 box around the new tile sets the
     * latch and fires func_020EFE (woodcut 1 + @LANDHO) — no sight
     * radius, no ship test (mirrors the JS step()). */
    if (!CR.land_ho && (u->owner_flags & 0x0F) == cs_nation()) {
        int land = 0;
        for (int dy = -1; dy <= 1 && !land; dy++)
            for (int dx = -1; dx <= 1 && !land; dx++)
                if (!tile_water(map_at(nx + dx, ny + dy))) land = 1;
        if (land) {
            CR.land_ho = 1;
            if (!(CR.wc_seen & (1u << 1))) {
                CR.wc_seen |= 1u << 1;
                if (colopy_front_live) {
                    CR.wc_show = 1;
                    CR.wc_after = 0;
                }
            }
        }
    }
    /* Tutorial bindings (moveUnit, game.js) — the JS's flagged
     * approximations of the focus dispatcher func_020F50 @0x020F50 and
     * the colony-screen sites func_02C5D4, mirrored one for one:
     *   a ship docking at an OWN colony teaches loading (12; bytes: at
     *   colony-screen open with a ship on the tile, @0x02C76F..0x02C7BC)
     *   or colonist delivery (15) when it carries passengers (bytes:
     *   colonist focus at a colony, turn < 40, @0x02114C..0x021157);
     *   a pioneer (20+ tools) on workable ground teaches plow/clear (10)
     *   or roads (9) (bytes: pioneer focus ADJACENT to an own colony,
     *   @0x021476/@0x0215C2); soldiers teach defence (14; bytes: soldier
     *   focus on land, turn < 20, @0x0210F9); a colonist on land teaches
     *   the terrain (3; bytes: Pioneers on a >= 5-cell site, @0x021345). */
    {
        int tc = -1;
        for (int k = 0; k < CS.n_colonies; k++)
            if ((CS.colonies[k].owner_power & 3) == me &&
                CS.colonies[k].map_x == nx && CS.colonies[k].map_y == ny) {
                tc = k;
                break;
            }
        if (ship && tc >= 0) {
            if (CR.unit_n_pass[ui] > 0)
                tut_once(15, 0, 0, CS.colonies[tc].name, 0);
            else
                tut_once(12, 0, 0, CS.colonies[tc].name, 0);
        }
        if (!ship && u->tools >= 20) {              /* canImprove */
            if (is_forested_id(tile_terrain(v)) ||
                !(map_improve(nx, ny) & PLOW_BIT))
                tut_once(10, 0, 0, 0, 0);
            else if (!(map_improve(nx, ny) & ROAD_BIT))
                tut_once(9, 0, 0, 0, 0);
        }
        const char *tn = dat_units[u->type].name;
        if (strcmp(tn, "Soldiers") == 0) tut_once(14, 0, 0, 0, 0);
        if (!ship && strcmp(tn, "Wagon Train") != 0 &&
            strcmp(tn, "Artillery") != 0 && strcmp(tn, "Treasure") != 0 &&
            !tile_water(v)) {
            /* terrainName (game.js) */
            int t = v & 0x1F;
            const char *name;
            if (tile_mountains(v)) name = "Mountains";
            else if (tile_hills(v)) name = "Hills";
            else if (t <= 7) name = dat_terrain_unforested[t];
            else if (t <= 23)
                name = dat_terrain_forested[(((t >= 16) ? (t & 7) | 8 : t) - 8) & 7];
            else name = dat_terrain_other[(t - 24) < 5 ? t - 24 : 0];
            tut_once(3, 0, 0, name, 0);
        }
    }
}
