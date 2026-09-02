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
#include "colopy_data.h"

static int g_res;
static int JX_VET_SOLDIERS = -1, JX_VET_DRAGOONS = -1;
static int JX_PETTY = -1, JX_INDENT = -1, JX_FREE = -1, JX_JESUIT = -1;
static int JX_CONVERT = -1;
static int FF_WASHINGTON = -1, FF_DRAKE = -1;
static void rresolve(void) {
    if (g_res) return;
    g_res = 1;
    for (int i = 0; i < DAT_JOBEXPERT_COUNT; i++) {
        const char *n = dat_jobexpert[i];
        if (strcmp(n, "Veteran Soldiers") == 0 && JX_VET_SOLDIERS < 0) JX_VET_SOLDIERS = i;
        if (strcmp(n, "Veteran Dragoons") == 0 && JX_VET_DRAGOONS < 0) JX_VET_DRAGOONS = i;
        if (strcmp(n, "Petty Criminals") == 0 && JX_PETTY < 0) JX_PETTY = i;
        if (strcmp(n, "Indentured Servants") == 0 && JX_INDENT < 0) JX_INDENT = i;
        if (strcmp(n, "Free Colonists") == 0 && JX_FREE < 0) JX_FREE = i;
        if (strcmp(n, "Jesuit Missionaries") == 0 && JX_JESUIT < 0) JX_JESUIT = i;
        if (strcmp(n, "Indian Converts") == 0 && JX_CONVERT < 0) JX_CONVERT = i;
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
    return row >= 0 && p < DAT_JOBEXPERT_COUNT /* 0 = Expert Farmers; 28 = none (C4.26 unit side) */ &&
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
/* the modifier inputs of one side (shared by the resolver's total and
 * the Combat Analysis rows) */
static void analysis_params(int ui, int is_defender, combat_params *pp) {
    rresolve();
    const UnitRecord *u = &CS.units[ui];
    combat_params p;
    memset(&p, 0, sizeof(p));
    p.type = u->type;
    p.terrain = map_at(unit_pos_x(ui), unit_pos_y(ui));
    p.on_colony = player_colony_at(unit_pos_x(ui), unit_pos_y(ui)) >= 0;
    /* func_007D3E settlement branch: 2 / 4 at tribe tech >= 2 / x2 for
     * the capital (@0x7D8D..@0x7DD9) — exclusive of the tile bonus */
    for (int v = 0; v < CS.n_villages; v++)
        if (CS.villages[v].map_x == unit_pos_x(ui) &&
            CS.villages[v].map_y == unit_pos_y(ui)) {
            int b = tribe_level(CS.villages[v].owner_tribe - 4) >= 2 ? 4 : 2;
            if (CS.villages[v].flags & 0x04) b *= 2;
            p.village_def = (uint8_t)b;
            break;
        }
    /* runtime orders: the importer starts every unit at 0, but the
     * slice-2 command layer can Fortify a player unit (orders 5/6 → the
     * +4 defence bonus).  Rival unit OBJECTS always carry orders 0
     * (importer game.js:10444) — their record byte is not what the JS
     * reads. */
    p.orders = is_rival_side(ui) ? 0 : CS.units[ui].orders;
    p.is_defender = (uint8_t)is_defender;
    p.damaged = CR.unit_damaged[ui];
    /* §14.3 fatigue: the tired-troops charge set by the move handler
     * (JS u.fatigue; rival objects never carry one) */
    p.fatigue = is_rival_side(ui) ? 0 : CR.unit_fatigue[ui];
    /* veteran = the profession title OR the u.veteran object flag
     * (game.js:6821 — REF landings, mercenaries, the intervention) */
    p.veteran = CR.unit_veteran[ui] ||
                (!is_rival_side(ui) &&
                 (prof_is(ui, JX_VET_SOLDIERS) || prof_is(ui, JX_VET_DRAGOONS)));
    p.artillery = strcmp(dat_units[u->type].name, "Artillery") == 0;
    p.privateer_drake = strcmp(dat_units[u->type].name, "Privateer") == 0 &&
                        ff(FF_DRAKE);
    p.spain_attacker = cs_nation() == 2 && !is_rival_side(ui) &&
                       (u->owner_flags & 0x0F) == cs_nation() && !is_defender;
    /* §14.3 step 5 (game.js:6875): the King's forces fight at +50%
     * while the declared war is on. */
    p.woi_ref_bombard = (CR.woi_flags & WOI_DECLARED) && CR.unit_is_ref[ui];
    p.difficulty = (int8_t)cs_difficulty();
    /* the display-only row inputs (game.js combatAnalysis): the
     * colony's fortification tier and the SoL of the colony the
     * unit stands in */
    {
        int ci = player_colony_at(unit_pos_x(ui), unit_pos_y(ui));
        if (ci >= 0) {
            p.colony_level = (uint8_t)(colony_has_name(ci, "Fortress") ? 3
                             : colony_has_name(ci, "Fort") ? 2
                             : colony_has_name(ci, "Stockade") ? 1 : 0);
            p.has_home = 1;
            p.home_sol = (uint8_t)rt_sol(ci);
        }
    }
    *pp = p;
}
int analysis_total(int ui, int is_defender) {
    combat_params p;
    analysis_params(ui, is_defender, &p);
    return combat_total(&p);
}

/* becomeType (game.js:7057): record type change; the moves clamp only
 * matters for player records (rival moves are unmodeled). */
static void become_type(int ui, const char *name) {
    int t = unit_by_type(name);
    if (t < 0) return;
    UnitRecord *u = &CS.units[ui];
    u->type = (uint8_t)t;
    /* becomeType ASSIGNS u.moves (game.js:7061) — a bare rival object
     * gains a real budget here; its movesLeft stays NaN (undef) until
     * the next refresh if it was undefined going in. */
    CR.unit_no_moves[ui] = 0;
    int mv = dat_units[t].movement * 3;
    if (!CR.unit_moves_undef[ui] && u->moves_remaining > mv)
        u->moves_remaining = (uint8_t)mv;
}

/* applyDefeat (game.js:7066).  Returns the removed record index, or -1 —
 * the caller re-bases its own indexes past a removal (the JS works on
 * object references and needs no such care). */
static int apply_defeat(int loser, int winner) {
    rresolve();
    /* @HOWTOWIN: the one-shot strategy card after the player's first
     * victory over the King's forces (game.js:7067). */
    if (CR.unit_is_ref[loser] &&
        (CS.units[winner].owner_flags & 0x0F) == cs_nation() &&
        !CR.unit_is_ref[winner] && !CR.how_to_won) {
        CR.how_to_won = 1;
        ev_emit("HOWTOWIN", 0, 0, 0, 0);
    }
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
            int was_rival = is_rival_side(loser);
            /* veteranLost reads the JS OBJECT's profession.  A loser
             * coming straight off a rival's r.units list is the BARE
             * importer object (game.js:10443) — no profession, no tools;
             * its record bytes are stale import data, not object state.
             * Once a rival-born unit has crossed to the player's side
             * its bytes are zeroed below and thereafter maintained as
             * the object mirror (tryPromote can even make it a Veteran),
             * so on any LATER capture the record speaks for the object. */
            int rival_born = CR.unit_rival_born[loser];
            int bare = was_rival && !CR.unit_in_natives[loser] && rival_born;
            int vet_lost = !bare && prof_is(loser, JX_VET_SOLDIERS);
            int old_owner = CS.units[loser].owner_flags & 0x0F;
            int wn = CS.units[winner].owner_flags & 0x0F;
            if (was_rival) runits_drop(old_owner, loser);   /* removeUnit */
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
            if (bare) {
                /* first crossing off the rival side: shed the record's
                 * stale import bytes — the JS object had neither */
                CS.units[loser].tools = 0;
                CS.units[loser].profession = DAT_JOBEXPERT_COUNT; /* none (28) */
            }
            CS.units[loser].owner_flags =
                (uint8_t)((CS.units[loser].owner_flags & 0xF0) | (wn & 0x0F));
            if (vet_lost) CS.units[loser].profession = DAT_JOBEXPERT_COUNT; /* none (28) */
            CS.units[loser].orders = 0;
            /* winner.nation === -2: the Crown's own captures go to
             * G.refUnits with @SEIZURELAND/@SEIZURESEA, and the capture
             * key does NOT fire (game.js:7110-7116). */
            if (CR.unit_is_ref[winner]) {
                units_order_drop(loser);
                refs_push(loser);
                /* loser.nation = winner.nation = -2 (game.js:7104): the
                 * seized unit IS a REF unit now — it marches, draws the
                 * declared-war bombard bonus, and its own captures seize */
                CR.unit_is_ref[loser] = 1;
                ev_emit(dat_units[CS.units[loser].type].hull > 0
                            ? "SEIZURESEA" : "SEIZURELAND",
                        0, 0, t->name, 0);
                return -1;
            }
            units_order_drop(loser);         /* removeUnit: leaves G.units */
            /* removeUnit also splices G.natives (game.js:7049) — a loser
             * that had been parked there leaves before re-joining a side */
            if (CR.unit_in_natives[loser]) {
                CR.unit_in_natives[loser] = 0;
                for (int k = 0; k < CR.n_natives; k++)
                    if (CR.natives_order[k] == loser) {
                        memmove(&CR.natives_order[k], &CR.natives_order[k + 1],
                                (size_t)(CR.n_natives - k - 1));
                        CR.n_natives--;
                        break;
                    }
            }
            if (wn != (int)cs_nation()) {
                /* the JS else-arm parks it in G.natives (see colopy_sim.h) */
                CR.unit_in_natives[loser] = 1;
                natives_push(loser);
            } else {
                units_push(loser);           /* G.units.push at the END */
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
            /* Jesuit -> Missionaries: `cmp [bx+0x315B], 0x18` @0x05B60E */
            if (strcmp(down, "Colonists") == 0 && prof_is(loser, JX_JESUIT))
                become_type(loser, "Missionaries");
            else become_type(loser, down);
            /* The DEMOTE branch (@0x05B5AA-@0x05B68F, key @0x05B679) is a
             * TYPE ladder only: func_05B2C2's sole write of +0x17 is the
             * colonist-CAPTURE strip @0x05B577 (0x15 -> 0x1C, above).  The
             * port used to clear a Veteran's profession here too -- never
             * in the bytes (C4.26 unit side, 2026-09-02). */
            ev_emit("DEMOTE", 0, 0, dat_units[CS.units[loser].type].name, 0);
            return -1;
        }
    }
    unit_remove(loser);                          /* destroyed, message only */
    return loser;
}

/* func_0082B2 (0x181F:0xC9A), the engine's "is an expert" predicate:
 * 0 ONLY for 0x1C (none), 0x13 Free Colonists, 0x19 Indentured Servants,
 * 0x1A Petty Criminals, 0x1B Indian Converts (@0x0082B5-@0x0082D1); every
 * other byte, INCLUDING 0 = Expert Farmers, is an expert (@0x0082D3). */
static int is_expert_class(int p) {
    return !(p == DAT_JOBEXPERT_COUNT || p == JX_FREE || p == JX_INDENT ||
             p == JX_PETTY || p == JX_CONVERT);
}

/* func_05C69C @0x05C69C, the combat promoter, re-read 2026-09-02 (C4.26
 * unit side).  Gates, in order: only TYPES 1 Soldiers / 4 Dragoons
 * (@0x05C6A5-@0x05C6B3); a Veteran (0x15 @0x05C6BA) continues only under
 * declared war ([0x5382] bit 0 @0x05C6C1) AND PowerRecord +0 bit 0x08
 * (@0x05C6CB-@0x05C6D6 -- semantics unread, NOT modelled, FLAGGED); any
 * other EXPERT (func_0082B2 != 0 @0x05C6E0-@0x05C6F2, so profession 0
 * too) is skipped before the roll.  Then S = total + strength +/-
 * difficulty (human +, AI -, @0x05C6F5-@0x05C729) - 10 for 0x1A / 5 for
 * 0x19 (@0x05C738-@0x05C746), random_int(1, S) unless Washington (attr
 * 0xB, @0x05C74A-@0x05C769), and the rung table func_05C65A (@0x05C65A-
 * @0x05C696): default 0x15; 0x15 at war -> -1 (type step); 0x1A -> 0x19;
 * 0x19 -> 0x1C (plain, NOT Free Colonists); 0x1B -> 0x1B, a no-op via
 * `cmp ax, [bp-6]; jne` @0x05C78D.  The type step (@0x05C795-@0x05C7B5)
 * is human-only, 1 -> 9 and 4 -> 7.  Keys @0x05C834 VETERAN / @0x05C868
 * VALOR.  Removed from here: the port's "Scout hardens to Seasoned"
 * branch -- the engine's WELLSEASONED site is the village-entry roll
 * @0x04A9DD (`mov [bx+0x315B], 0x16`, key @0x04AA14), not combat;
 * FLAGGED as not modelled on that path. */
static void try_promote(int winner, int w_strength, int total) {
    rresolve();
    if ((CS.units[winner].owner_flags & 0x0F) != cs_nation() ||
        is_rival_side(winner)) return;
    const char *ty = dat_units[CS.units[winner].type].name;
    if (CS.units[winner].type != 1 && CS.units[winner].type != 4) return;
    int from = CS.units[winner].profession;   /* 28 = none; any other
                                                 stray byte is an expert
                                                 to func_0082B2 */
    if (from == JX_VET_SOLDIERS) {
        if (!(CR.woi_flags & WOI_DECLARED)) return;
    } else if (is_expert_class(from)) {
        return;
    }
    int penalty = from == JX_PETTY ? 10 : from == JX_INDENT ? 5 : 0;
    int S = total + cs_difficulty() - penalty;
    if (S < 1) S = 1;
    if (!ff(FF_WASHINGTON) && 1 + R(S) > w_strength) return;
    int next = JX_VET_SOLDIERS;                       /* func_05C65A */
    if (from == JX_VET_SOLDIERS) next = -1;
    else if (from == JX_PETTY) next = JX_INDENT;
    else if (from == JX_INDENT) next = DAT_JOBEXPERT_COUNT;   /* 0x1C */
    else if (from == JX_CONVERT) next = JX_CONVERT;
    if (next == from) return;                         /* @0x05C78D */
    if (next < 0) {
        /* @CONTINENTAL: at the ceiling the TYPE advances (reached only at
         * war): Soldiers -> Cont. Army, Dragoons -> Cont. Cav. */
        const char *to = strcmp(ty, "Soldiers") == 0 ? "Cont. Army"
                       : strcmp(ty, "Dragoons") == 0 ? "Cont. Cav." : 0;
        if (to) {
            become_type(winner, to);
            ev_emit("CONTINENTAL", 0, 0, ty, 0);
        }
        return;
    }
    CS.units[winner].profession = (uint8_t)next;
    ev_emit(next == JX_VET_SOLDIERS ? "VETERAN" : "VALOR", 0, 0, ty, 0);
}

int resolve_attack(int att_ui, int def_ui) {
    combat_params pa, pd;
    analysis_params(att_ui, 0, &pa);
    analysis_params(def_ui, 1, &pd);
    int A = combat_total(&pa);
    int D = combat_total(&pd);

    int roll = 1 + R(A + D);
    int win = roll <= A;
    /* the Combat Analysis panel (G.combat, game.js resolveAttack):
     * Game Options bit 0x0200; filled BEFORE the defeat shuffles the
     * unit indices, shown over the map until the next key/click */
    if (CR.game_options & 0x0200) {
        combat_panel *c = &CR.combat;
        memset(c, 0, sizeof(*c));
        c->active = 1;
        c->win = (uint8_t)win;
        c->att_type = CS.units[att_ui].type;
        c->def_type = CS.units[def_ui].type;
        c->att_icon = (uint8_t)unit_icon_of(att_ui);
        c->def_icon = (uint8_t)unit_icon_of(def_ui);
        int b;
        c->att_n = (uint8_t)combat_rows(&pa, c->att_rows, &b);
        c->att_base = (int16_t)b;
        c->def_n = (uint8_t)combat_rows(&pd, c->def_rows, &b);
        c->def_base = (int16_t)b;
        c->att_total = (int16_t)A;
        c->def_total = (int16_t)D;
        c->roll = (int16_t)roll;
    }
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
    /* att.movesLeft = 0 (game.js:7242) — written on ANY attacker object,
     * rival included: a captured attacker enters G.units showing the
     * NUMBER 0 until its first refresh makes it undefined. */
    if (att_ui >= 0) {
        CS.units[att_ui].moves_remaining = 0;
        CR.unit_moves_undef[att_ui] = 0;
    }
    return removed;
}

/* navalAttack (game.js:6895): the raw guns/hull roll.  Only Privateers,
 * Frigates and Men-O-War may START a ship attack (@SHIPCOMBAT); a
 * gunless defender that survives the roll EVADES (flagged stand-in like
 * the JS); a damaged loser's hold is seized — @PICKACARGO asks when a
 * player winner has a choice.  Returns 0 only on the refusal. */
static int ship_attacker_type(int type) {
    const char *n = dat_units[type].name;
    return strcmp(n, "Privateer") == 0 || strcmp(n, "Frigate") == 0 ||
           strcmp(n, "Man-O-War") == 0;
}
int naval_attack(int att_ui, int def_ui) {
    rresolve();
    if (!ship_attacker_type(CS.units[att_ui].type)) {
        ev_emit("SHIPCOMBAT", 0, 0, 0, 0);
        return 0;
    }
    const dat_units_t *ta = &dat_units[CS.units[att_ui].type];
    const dat_units_t *td = &dat_units[CS.units[def_ui].type];
    int A = ta->attack ? ta->attack : ta->combat;
    int D = td->hull ? td->hull : td->combat;
    int win = 1 + R(A + D) <= A;
    if (!win && !ship_attacker_type(CS.units[def_ui].type)) {
        ev_emit("EVASIVE", 0, 0, td->name, ta->name);
        CS.units[att_ui].moves_remaining = 0;
        CR.unit_moves_undef[att_ui] = 0;
        return 1;
    }
    int loser = win ? def_ui : att_ui, winner = win ? att_ui : def_ui;
    /* a hold going down is seized (pre-battle damaged = this hit sinks) */
    hold_slot spoils[EURO_HOLD_MAX];
    int ns = 0;
    for (int i = 0; i < CR.unit_n_hold[loser]; i++)
        if (CR.unit_hold[loser][i].qty > 0)
            spoils[ns++] = CR.unit_hold[loser][i];
    if (ns && CR.unit_damaged[loser]) {
        int winner_is_player =
            (CS.units[winner].owner_flags & 0x0F) == cs_nation();
        int pick = 0;
        if (ns > 1 && winner_is_player) {
            ev_emit("PICKACARGO", 0, 0, 0, 0);
            int k = ask_choice();
            pick = (k >= 0 && k < ns) ? k : 0;
        }
        ev_emit("CARGOCAPTURE", spoils[pick].qty, 0,
                dat_cargo[spoils[pick].good].name,
                dat_units[CS.units[winner].type].name);
        hold_add(CR.unit_hold[winner], &CR.unit_n_hold[winner],
                 spoils[pick].good, spoils[pick].qty);
    }
    int rem = apply_defeat(loser, winner);
    if (rem >= 0 && rem < att_ui) att_ui--;
    else if (rem == att_ui) att_ui = -1;     /* the attacker sank */
    if (att_ui >= 0) {
        CS.units[att_ui].moves_remaining = 0;    /* att.movesLeft = 0 */
        CR.unit_moves_undef[att_ui] = 0;
    }
    return 1;
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
