/* Combat resolution — resolveAttack (game.js:7219), applyDefeat (7066),
 * tryPromote (7185), becomeType/removeUnit (7057/7040), over the record
 * pool + CR mirrors.  The strength chain itself is combat_total
 * (colopy_combat.c, §14.1-14.3, sweep-verified); this file builds its
 * params from live unit state exactly as combatAnalysis (6810) reads a
 * unit object:
 *   - runtime ORDERS start 0: the JS importer never copies the record's
 *     orders byte onto its unit objects, so no imported unit is Fortified
 *     in the JS — mirrored here (an import gap, FLAGGED in the ledger);
 *   - fatigue and holds are 0 on every reachable path (attackers are
 *     rival LAND units, defenders player LAND units; neither carries);
 *   - veteran = the profession title (rival objects carry none).
 *
 * Reachable-path scope, marked where skipped: the REF (-2) clauses
 * (@HOWTOWIN, @SEIZURE*), and the tribe-winner clauses (@LOSTOURSCOUTS,
 * @INDIANWIN*) — braves fight through the raid ladder, never through
 * resolveAttack, in the ported chain. */
#include <string.h>

#include "colopy_sim.h"
#include "../data/colopy_data.h"

static int g_res;
static int JX_VET_SOLDIERS = -1, JX_VET_DRAGOONS = -1, JX_SEASONED = -1;
static int JX_PETTY = -1, JX_INDENT = -1, JX_FREE = -1, JX_JESUIT = -1;
static int FF_WASHINGTON = -1, FF_DRAKE = -1;
static void rresolve(void) {
    if (g_res) return;
    g_res = 1;
    for (int i = 0; i < DAT_JOBEXPERT_COUNT; i++) {
        const char *n = dat_jobexpert[i];
        if (strcmp(n, "Veteran Soldiers") == 0 && JX_VET_SOLDIERS < 0) JX_VET_SOLDIERS = i;
        if (strcmp(n, "Veteran Dragoons") == 0 && JX_VET_DRAGOONS < 0) JX_VET_DRAGOONS = i;
        if (strcmp(n, "Seasoned Scouts") == 0 && JX_SEASONED < 0) JX_SEASONED = i;
        if (strcmp(n, "Petty Criminals") == 0 && JX_PETTY < 0) JX_PETTY = i;
        if (strcmp(n, "Indentured Servants") == 0 && JX_INDENT < 0) JX_INDENT = i;
        if (strcmp(n, "Free Colonists") == 0 && JX_FREE < 0) JX_FREE = i;
        if (strcmp(n, "Jesuit Missionaries") == 0 && JX_JESUIT < 0) JX_JESUIT = i;
    }
    for (int i = 0; i < DAT_FATHERS_COUNT; i++) {
        if (strcmp(dat_fathers[i].name, "George Washington") == 0) FF_WASHINGTON = i;
        if (strcmp(dat_fathers[i].name, "Francis Drake") == 0) FF_DRAKE = i;
    }
}
static int ff(int idx) {
    return idx >= 0 && ((CS.powers[cs_nation()].founding_fathers >> idx) & 1);
}
static int prof_is(int ui, int row) {
    uint8_t p = CS.units[ui].profession;
    return row >= 0 && p >= 1 && p < DAT_JOBEXPERT_COUNT &&
           strcmp(dat_jobexpert[p], dat_jobexpert[row]) == 0;
}
static int is_rival_side(int ui) {
    int own = CS.units[ui].owner_flags & 0x0F;
    return own < 4 && own != (int)cs_nation();
}
int unit_pos_x(int ui) {
    return is_rival_side(ui) ? CR.runit_x[ui] : CS.units[ui].map_x;
}
int unit_pos_y(int ui) {
    return is_rival_side(ui) ? CR.runit_y[ui] : CS.units[ui].map_y;
}
static void unit_pos_set(int ui, int x, int y) {
    CR.runit_x[ui] = (int16_t)x;
    CR.runit_y[ui] = (int16_t)y;
    if (!is_rival_side(ui)) {
        CS.units[ui].map_x = (uint8_t)x;
        CS.units[ui].map_y = (uint8_t)y;
    }
}
static int player_colony_at(int x, int y) {
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation() &&
            CS.colonies[ci].map_x == x && CS.colonies[ci].map_y == y)
            return ci;
    return -1;
}
static int unit_by_type(const char *name) {
    for (int i = 0; i < DAT_UNITS_COUNT; i++)
        if (strcmp(dat_units[i].name, name) == 0) return i;
    return -1;
}
static int R(int n) { return (int)((rng_next() * (uint32_t)n) >> 15); }

/* combatAnalysis(u, isDefender).total for a live unit (see header). */
static int analysis_total(int ui, int is_defender) {
    rresolve();
    const UnitRecord *u = &CS.units[ui];
    combat_params p;
    memset(&p, 0, sizeof(p));
    p.type = u->type;
    p.terrain = map_at(unit_pos_x(ui), unit_pos_y(ui));
    p.on_colony = player_colony_at(unit_pos_x(ui), unit_pos_y(ui)) >= 0;
    p.orders = 0;                 /* runtime orders — see header */
    p.is_defender = (uint8_t)is_defender;
    p.damaged = CR.unit_damaged[ui];
    p.veteran = !is_rival_side(ui) &&
                (prof_is(ui, JX_VET_SOLDIERS) || prof_is(ui, JX_VET_DRAGOONS));
    p.artillery = strcmp(dat_units[u->type].name, "Artillery") == 0;
    p.privateer_drake = strcmp(dat_units[u->type].name, "Privateer") == 0 &&
                        ff(FF_DRAKE);
    p.spain_attacker = cs_nation() == 2 && !is_rival_side(ui) &&
                       (u->owner_flags & 0x0F) == cs_nation() && !is_defender;
    p.difficulty = (int8_t)cs_difficulty();
    return combat_total(&p);
}

/* becomeType (game.js:7057): record type change; the moves clamp only
 * matters for player records (rival moves are unmodeled). */
static void become_type(int ui, const char *name) {
    int t = unit_by_type(name);
    if (t < 0) return;
    UnitRecord *u = &CS.units[ui];
    u->type = (uint8_t)t;
    int mv = dat_units[t].movement * 3;
    if (u->moves_remaining > mv) u->moves_remaining = (uint8_t)mv;
}

/* applyDefeat (game.js:7066).  Returns the removed record index, or -1 —
 * the caller re-bases its own indexes past a removal (the JS works on
 * object references and needs no such care). */
static int apply_defeat(int loser, int winner) {
    rresolve();
    const dat_units_t *t = &dat_units[CS.units[loser].type];
    /* SHIPS: damaged first, sunk only if already damaged */
    if (t->hull > 0) {
        if (!CR.unit_damaged[loser]) {
            CR.unit_damaged[loser] = 1;
            ev_emit("SHIPDAMAGE", 0, 0, t->name, 0);
            return -1;
        }
        unit_remove(loser);
        ev_emit("SHIPSUNK", 0, 0, t->name, 0);
        return loser;
    }
    /* ARTILLERY: damaged, then destroyed */
    if (strcmp(t->name, "Artillery") == 0) {
        if (!CR.unit_damaged[loser]) {
            CR.unit_damaged[loser] = 1;
            ev_emit("ARTILLERY", 0, 0, t->name, 0);
            return -1;
        }
        unit_remove(loser);
        ev_emit("ARTILLERY2", 0, 0, t->name, 0);
        return loser;
    }
    /* CAPTURE: Colonists / Treasure / Wagon Train from a European owner */
    {
        const char *cap = 0;
        if (strcmp(t->name, "Colonists") == 0) cap = "COLONISTCAPTURE";
        else if (strcmp(t->name, "Treasure") == 0) cap = "LOOTCAPTURE";
        else if (strcmp(t->name, "Wagon Train") == 0) cap = "WAGONCAPTURE";
        int loser_nation = CS.units[loser].owner_flags & 0x0F;
        if (cap && loser_nation < 4) {
            int vet_lost = prof_is(loser, JX_VET_SOLDIERS);
            int was_rival = is_rival_side(loser);
            int wn = CS.units[winner].owner_flags & 0x0F;
            /* transfer: owner nibble; sync positions across the ownership
             * change (records are authoritative for player units, the CR
             * mirrors for rival units) */
            if (was_rival) {
                CS.units[loser].map_x = (uint8_t)CR.runit_x[loser];
                CS.units[loser].map_y = (uint8_t)CR.runit_y[loser];
            } else {
                CR.runit_x[loser] = CS.units[loser].map_x;
                CR.runit_y[loser] = CS.units[loser].map_y;
            }
            CS.units[loser].owner_flags =
                (uint8_t)((CS.units[loser].owner_flags & 0xF0) | (wn & 0x0F));
            if (vet_lost) CS.units[loser].profession = 0;
            CS.units[loser].orders = 0;
            if (wn != (int)cs_nation()) {
                /* the JS else-arm parks it in G.natives (see colopy_sim.h) */
                CR.unit_in_natives[loser] = 1;
                natives_push(loser);
            }
            ev_emit(vet_lost && cap[0] == 'C' ? "COLONISTCAPTURE2" : cap,
                    0, 0, t->name, 0);
            return -1;
        }
    }
    /* (@LOSTOURSCOUTS/@LOSTTHEIRSCOUTS/@INDIANWIN*: tribe-side clauses,
     * unreachable — resolveAttack never fires with a brave party here) */
    /* THE DEMOTION LADDER */
    {
        const char *down = 0;
        if (strcmp(t->name, "Dragoons") == 0) down = "Soldiers";
        else if (strcmp(t->name, "Soldiers") == 0) down = "Colonists";
        else if (strcmp(t->name, "Cont. Cav.") == 0) down = "Cont. Army";
        else if (strcmp(t->name, "Cavalry") == 0) down = "Regulars";
        else if (strcmp(t->name, "Cont. Army") == 0) down = "Colonists";
        if (down) {
            int was_vet = prof_is(loser, JX_VET_SOLDIERS) ||
                          prof_is(loser, JX_VET_DRAGOONS);
            if (strcmp(down, "Colonists") == 0 && prof_is(loser, JX_JESUIT))
                become_type(loser, "Missionaries");
            else become_type(loser, down);
            if (was_vet) CS.units[loser].profession = 0;
            ev_emit("DEMOTE", 0, 0, dat_units[CS.units[loser].type].name, 0);
            return -1;
        }
    }
    unit_remove(loser);                          /* destroyed, message only */
    return loser;
}

/* tryPromote (game.js:7185): §14.6 — only the player's own men. */
static void try_promote(int winner, int w_strength, int total) {
    rresolve();
    if ((CS.units[winner].owner_flags & 0x0F) != cs_nation() ||
        is_rival_side(winner)) return;
    int penalty = prof_is(winner, JX_PETTY) ? 10
                : prof_is(winner, JX_INDENT) ? 5 : 0;
    int S = total + cs_difficulty() - penalty;
    if (S < 1) S = 1;
    if (!ff(FF_WASHINGTON) && 1 + R(S) > w_strength) return;
    const char *ty = dat_units[CS.units[winner].type].name;
    if (strcmp(ty, "Scouts") == 0 && !prof_is(winner, JX_SEASONED)) {
        CS.units[winner].profession = (uint8_t)JX_SEASONED;
        ev_emit("WELLSEASONED", 0, 0, 0, 0);
        return;
    }
    /* SAV_PROFESSION (game.js:10207): bytes outside 1..27 read as NO
     * profession — the ladder's null rung. */
    uint8_t from = CS.units[winner].profession;
    int next = -1;
    if (from == 0 || from >= DAT_JOBEXPERT_COUNT) next = JX_VET_SOLDIERS;
    else if (prof_is(winner, JX_PETTY)) next = JX_INDENT;
    else if (prof_is(winner, JX_INDENT)) next = JX_FREE;
    else if (prof_is(winner, JX_FREE)) next = JX_VET_SOLDIERS;
    if (next >= 0 && !prof_is(winner, JX_VET_SOLDIERS)) {
        CS.units[winner].profession = (uint8_t)next;
        ev_emit(next == JX_VET_SOLDIERS ? "VETERAN" : "VALOR", 0, 0, ty, 0);
        return;
    }
    /* @CONTINENTAL: type-advance, WoI only — flags are 0 here */
}

int resolve_attack(int att_ui, int def_ui) {
    int A = analysis_total(att_ui, 0);
    int D = analysis_total(def_ui, 1);

    int roll = 1 + R(A + D);
    int win = roll <= A;
    int loser = win ? def_ui : att_ui, winner = win ? att_ui : def_ui;
    int dx = unit_pos_x(def_ui), dy = unit_pos_y(def_ui);
    int removed = apply_defeat(loser, winner);
    if (removed >= 0) {
        if (winner > removed) winner--;
        if (att_ui > removed) att_ui--;
        else if (att_ui == removed) att_ui = -1;
    }
    try_promote(winner, win ? A : D, A + D);
    /* the winner takes the emptied tile (attacker only, game.js:7237) */
    if (win && att_ui >= 0) {
        int blocked = player_colony_at(dx, dy) >= 0;
        for (int ui = 0; ui < CS.n_units && !blocked; ui++) {
            if (unit_on_map_player(ui) &&
                CS.units[ui].map_x == dx && CS.units[ui].map_y == dy)
                blocked = 1;
            /* G.natives: braves + the captured-unit quirk */
            int own = CS.units[ui].owner_flags & 0x0F;
            int brave = own >= 4 && CS.units[ui].type < DAT_UNITS_COUNT &&
                        dat_units[CS.units[ui].type].hull <= 0;
            if ((brave || CR.unit_in_natives[ui]) &&
                unit_pos_x(ui) == dx && unit_pos_y(ui) == dy) blocked = 1;
        }
        if (!blocked) unit_pos_set(att_ui, dx, dy);
    }
    if (att_ui >= 0 && !is_rival_side(att_ui))
        CS.units[att_ui].moves_remaining = 0;
    return removed;
}

/* Immediate colony splice (rival capture, game.js:7578) — the vanish
 * filter's memmove pair, without the flag round trip. */
void colony_remove(int ci) {
    memmove(&CS.colonies[ci], &CS.colonies[ci + 1],
            (size_t)(CS.n_colonies - ci - 1) * sizeof(ColonyRecord));
    memmove(&CR.col[ci], &CR.col[ci + 1],
            (size_t)(CS.n_colonies - ci - 1) * sizeof(colony_rt));
    CS.n_colonies--;
}
