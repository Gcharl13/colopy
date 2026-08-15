/* The turn pipeline, prefix 1: header + upkeep + the per-colony turn.
 *
 * Ports game.js endTurn's opening (10724: turn/year/season cadence, moves
 * refresh, payUpkeep) and colonyTurn (3004) with its helpers
 * advanceConstruction (3114), runSchool (2760), autoExport (2832),
 * updateSoL (2807, byte-verified EMA @0x2DA1C), solAnnounce.  The JS
 * citations and FLAGGED markers carry over; anything the JS keeps as
 * runtime object state lives here in CR.col[] beside the record pools.
 *
 * Deliberate prefix limits (the parity trace excludes these, loudly):
 *   - tutorial bindings (tutOnce): not ported yet; TUTORIAL* keys are
 *     filtered from the event comparison and the tut/once masks are not
 *     projected.  TODO with the tutorial subsystem.
 *   - colonyBesieged: rival wars counted (game.js:2995); the REF-unit
 *     term joins with the WoI slice.
 *   - unit BUILD targets: the importer nulls them (bip >= 42), so the
 *     completion path handles buildings only.  TBD with the unit pipeline.
 */
#include <string.h>

#include "colopy_sim.h"
#include "../data/colopy_data.h"

#define FOOD_FOR_COLONIST 200
#define REBEL_DIVISOR_SEED 200

/* ---- name -> table-index resolution (once, strcmp like the JS) --------- */
static int g_resolved;
static int JOB_TEACHER;                  /* @JOB row for 'Teacher' */
static int BLD_STABLE, BLD_NEWSPAPER, BLD_PRESS, BLD_CUSTOM;
static int FF_JAN_DE_WITT;
static int TIER_ROW[3];                  /* Petty Criminals / Indentured / Free */
static uint64_t FACTORY_MASK;            /* BUILDING_FACTORY as index bits */

static int job_by_name(const char *n) {
    for (int i = 0; i < DAT_JOBS_COUNT; i++)
        if (strcmp(dat_jobs[i], n) == 0) return i;
    return -1;
}
static int bld_by_name(const char *n) {
    for (int i = 0; i < DAT_BUILDINGS_COUNT; i++)
        if (strcmp(dat_buildings[i].name, n) == 0) return i;
    return -1;
}
static int expert_row(const char *title) {
    for (int i = 0; i < DAT_JOBEXPERT_COUNT; i++)
        if (strcmp(dat_jobexpert[i], title) == 0) return i;
    return -1;
}
static void resolve(void) {
    static const char *FACT[] = { "Textile Mill", "Cigar Factory",
        "Rum Factory", "Fur Factory", "Iron Works", "Arsenal" };
    if (g_resolved) return;
    g_resolved = 1;
    JOB_TEACHER = job_by_name("Teacher");
    BLD_STABLE = bld_by_name("Stable");
    BLD_NEWSPAPER = bld_by_name("Newspaper");
    BLD_PRESS = bld_by_name("Printing Press");
    BLD_CUSTOM = bld_by_name("Custom House");
    TIER_ROW[0] = expert_row("Petty Criminals");
    TIER_ROW[1] = expert_row("Indentured Servants");
    TIER_ROW[2] = expert_row("Free Colonists");
    FF_JAN_DE_WITT = -1;
    for (int i = 0; i < DAT_FATHERS_COUNT; i++)
        if (strcmp(dat_fathers[i].name, "Jan de Witt") == 0) FF_JAN_DE_WITT = i;
    FACTORY_MASK = 0;
    for (unsigned i = 0; i < sizeof(FACT) / sizeof(FACT[0]); i++) {
        int b = bld_by_name(FACT[i]);
        if (b >= 0) FACTORY_MASK |= 1ull << b;
    }
}

static void wr16(uint8_t *p, uint16_t v) { p[0] = (uint8_t)v; p[1] = (uint8_t)(v >> 8); }

int father_owned(int idx) {
    return idx >= 0 && ((CS.powers[cs_nation()].founding_fathers >> idx) & 1);
}
/* JS c.buildings.includes(name) — the runtime list, membership by NAME. */
static int has_bld(int ci, int idx) {
    return idx >= 0 && colony_has_name(ci, dat_buildings[idx].name);
}

/* runtime sol (JS c.sol): seeded from the record ratio at load, then owned
 * by update_sol — the JS importer's exact life cycle. */
int rt_sol(int ci) { return CR.col[ci].sol; }

void cr_reset_from_load(void) {
    memset(&CR, 0, sizeof(CR));
    CR.zoom_colony = -1;
    CR.father_in_progress = -1;
    CR.king_war_rival = -1;
    CR.screen_map = 1;               /* importSav ends on the map screen */
    for (int i = 0; i < CS.n_colonies; i++) {
        CR.col[i].sol = (uint8_t)colony_sol(&CS.colonies[i]);
        CR.col[i].sol_band = 0xFF;
        colony_bld_seed(i);
    }
    /* natives: every non-ship record owned >= 4 is a brave (importer
     * game.js:10431); home = the tribe's nearest village by Manhattan
     * distance, first on tie (the stable-sort [0]). */
    memset(CR.native_heading, 0xFF, sizeof(CR.native_heading));
    memset(CR.native_home, 0xFF, sizeof(CR.native_home));   /* -1 */
    for (int i = 0; i < CS.n_units; i++) {
        const UnitRecord *u = &CS.units[i];
        int own = u->owner_flags & 0x0F;
        if (own < 4 || u->type >= DAT_UNITS_COUNT ||
            dat_units[u->type].hull > 0) continue;
        int best = -1, bd = 0;
        for (int v = 0; v < CS.n_villages; v++) {
            if (CS.villages[v].owner_tribe != own) continue;  /* tribe+4 */
            int dx = CS.villages[v].map_x - u->map_x;
            int dy = CS.villages[v].map_y - u->map_y;
            int d = (dx < 0 ? -dx : dx) + (dy < 0 ? -dy : dy);
            if (best < 0 || d < bd) { best = v; bd = d; }
        }
        CR.native_home[i] = (int8_t)best;
        natives_push(i);          /* the importer's G.natives.push order */
    }
    /* G.units / r.units order: the importer's two passes — ships then
     * land, each record-ascending (game.js:10422) */
    for (int pass = 0; pass < 2; pass++)
        for (int i = 0; i < CS.n_units; i++) {
            if (CS.units[i].type >= DAT_UNITS_COUNT) continue;
            int ship = dat_units[CS.units[i].type].hull > 0;
            if ((pass == 0) != (ship != 0)) continue;
            int own = CS.units[i].owner_flags & 0x0F;
            if (own == (int)cs_nation()) {
                if (unit_on_map_player(i)) units_push(i);
            } else if (own < 4) {
                runits_push(own, i);
            }
        }
    /* rivals (importer game.js:10330-10336, 10374-10380): met, attitude 8,
     * gold from the power record, colonies from the rival-owned records in
     * record order; every unit's position mirrored signed. */
    for (int i = 0; i < CS.n_units; i++) {
        CR.runit_x[i] = CS.units[i].map_x;
        CR.runit_y[i] = CS.units[i].map_y;
    }
    for (int n = 0; n < 4; n++) {
        if (n == (int)cs_nation()) continue;
        rival_rt *r = &CR.rivals[n];
        r->met = 1;
        r->attitude = 8;
        r->gold = CS.powers[n].gold;
    }
    for (int i = 0; i < CS.n_colonies; i++) {
        int own = CS.colonies[i].owner_power & 3;
        if (own == (int)cs_nation()) continue;
        rival_rt *r = &CR.rivals[own];
        if (r->n_col >= (int)(sizeof(r->col) / sizeof(r->col[0]))) continue;
        int lvl = colony_has_name(i, "Fortress") ? 3
                : colony_has_name(i, "Fort") ? 2
                : colony_has_name(i, "Stockade") ? 1 : 0;
        r->col[r->n_col].x = CS.colonies[i].map_x;
        r->col[r->n_col].y = CS.colonies[i].map_y;
        r->col[r->n_col].level = (uint8_t)lvl;
        r->col[r->n_col].pop = CS.colonies[i].population;
        r->n_col++;
    }
    /* tribes: tension toward the player from the 0x4E-stride TribeData
     * (+0x46 + nation*2, clamp 0..100 -- importer game.js:10301) */
    for (int i = 0; i < 8; i++) {
        int off = i * 0x4E + 0x46 + cs_nation() * 2;
        int v = CS.tribes[off] | (CS.tribes[off + 1] << 8);
        CR.tension[i] = (uint8_t)(v > 100 ? 100 : v);
    }
    /* villages: alarm toward the player (importer reads the u16's low byte) */
    for (int i = 0; i < CS.n_villages; i++)
        CR.alarm[i] = (uint8_t)(CS.villages[i].alarm[cs_nation()] & 0xFF);
    /* slice 2: no Go To goals; the rumour salt PINNED to the trace's 1653
     * (the engine's [0x190] is rolled at game start with the native RNG;
     * the parity harness pins it on both sides so rumour_at agrees).
     * The RECORD-side session seeding (full movement budgets, orders
     * zeroed — the JS importer copies neither) lives in
     * units_session_seed(): load itself must stay byte-pure so the
     * .SAV roundtrip contract holds. */
    for (int i = 0; i < CS.n_units; i++) {
        CR.goal_x[i] = CR.goal_y[i] = -1;
        int own = CS.units[i].owner_flags & 0x0F;
        CR.unit_rival_born[i] = (uint8_t)(own < 4 && own != (int)cs_nation());
        CR.unit_no_moves[i] = CR.unit_rival_born[i];
    }
    CR.map_seed = 1653;
    CR.rumour_floor = 1;             /* G defaults (game.js:588) */
    /* REF strength is READ from the save's global block (importer
     * game.js:10265: [0x53DA/DC/DE/E0] = globals +0x5A..0x60, Regulars /
     * Cavalry / Man-O-War / Artillery — the beginGame seedREF values are
     * overwritten by the import) + the national sentiment band, unset */
    for (int i = 0; i < 4; i++)
        CR.ref_pool[i] = (int16_t)(CS.globals[0x5A + 2 * i] |
                                   (CS.globals[0x5B + 2 * i] << 8));
    CR.nat_band = 0xFF;
    /* slice 4b: the open-village cursor, tribe war targets, and the
     * chief-seen seed (importer game.js:10315 reads flags bit 0x08) */
    CR.cur_village = -1;
    CR.cur_visitor = -1;
    memset(CR.tribe_war_with, 0xFF, sizeof(CR.tribe_war_with));  /* -1 */
    /* the importer marks every tribe met (game.js:10262) */
    memset(CR.tribe_met, 1, sizeof(CR.tribe_met));
    for (int i = 0; i < CS.n_villages; i++)
        if (CS.villages[i].flags & 0x08) CR.village_flags[i] |= 8;
    /* importer game.js:10285-10288: the artillery price-escalation
     * counter (+0x1E) AND the boycott word (+0x20) are read from the
     * PowerRecord — G.boycotts starts [] but is FILLED from the record's
     * bits on the next line (the earlier "runtime-only" reading stopped
     * one line short; corrected with slice 3). */
    CR.artillery_bought =
        (uint8_t)CS.powers[cs_nation()].artillery_bought;
    CR.boycotts = CS.powers[cs_nation()].boycott;
    /* slice 3: the Europe harbour + the ship hold/passenger mirrors
     * (importer game.js:10477 — CR-only writes, load stays byte-pure) */
    europe_seed_from_load();
}

/* The importer's RUNTIME unit setup (mkUnit game.js:660 + the import
 * loop 10459: movesLeft = movement*3, orders = 0 — the save's own bytes
 * for both fields are DISCARDED).  Called by the session entry points
 * (host --turns/--saveout, the Teensy shell) after colopy_load_sav, NOT
 * by the loader: the Phase-1 contract keeps load→save byte-identical. */
void units_session_seed(void) {
    for (int i = 0; i < CS.n_units; i++) {
        CS.units[i].moves_remaining = (uint8_t)unit_full_moves(i);
        CS.units[i].orders = 0;
    }
}

/* ---- record mutators --------------------------------------------------- */
void colonist_add(ColonyRecord *c) {
    if (c->population >= 32) return;             /* record slot cap */
    c->occupation[c->population] = 0xFF;         /* no job (like JS null) */
    c->profession[c->population] = 0;
    c->population++;
}
void colonist_remove_last(int ci) {
    ColonyRecord *c = &CS.colonies[ci];
    if (!c->population) return;
    c->population--;
    for (int k = 0; k < 8; k++)
        if ((uint8_t)c->tiles[k] == c->population) c->tiles[k] = (int8_t)0xFF;
    CR.col[ci].taught[c->population] = 0;
}

/* Add one @BUILDING to the tier-packed field: the family's bits carry the
 * TIER as a binary value (see colony_buildings), so adding a link writes
 * tier+1 into the width. Warehouse Expansion is the level byte, not a bit
 * (importer game.js:10368). Which encoding the ENGINE writes on build is
 * unread — this inverts the byte-verified decode; FLAGGED. */
static const uint8_t FAMS[][3] = {
    {0,3,3},{3,3,3},{6,3,3},{9,3,3},{12,3,3},{15,1,1},{17,1,1},{18,1,1},
    {19,2,2},{21,3,3},{24,3,3},{27,3,3},{30,2,2},{32,3,3},{35,2,2},
    {37,2,2},{39,3,3},
};
static void building_add(int ci, int idx) {
    ColonyRecord *c = &CS.colonies[ci];
    colony_bld_append(ci, idx);      /* JS c.buildings.push(name) */
    if (idx == bld_by_name("Warehouse Expansion")) { c->warehouse_level = 2; return; }
    for (unsigned f = 0; f < sizeof(FAMS) / sizeof(FAMS[0]); f++) {
        int lo = FAMS[f][0], w = FAMS[f][1], len = FAMS[f][2];
        if (idx < lo || idx >= lo + len) continue;
        int t = 0;
        for (int j = 0; j < w; j++)
            t |= ((c->buildings[(lo + j) >> 3] >> ((lo + j) & 7)) & 1) << j;
        if (t > len) t = len;
        int nt = idx - lo + 1;
        if (nt <= t) return;                     /* already standing */
        for (int j = 0; j < w; j++) {
            int bit = lo + j;
            if ((nt >> j) & 1) c->buildings[bit >> 3] |= (uint8_t)(1 << (bit & 7));
            else c->buildings[bit >> 3] &= (uint8_t)~(1 << (bit & 7));
        }
        return;
    }
}

/* ---- SoL: updateSoL (byte-verified EMA @0x2DA1C) + solAnnounce ---------- */
static void update_sol(int ci, int bells) {
    colony_rt *r = &CR.col[ci];
    int pop = CS.colonies[ci].population;
    int32_t B = r->rebelB ? r->rebelB : REBEL_DIVISOR_SEED;
    B = B - (B >> 6);
    if (B < 1) B = 1;
    B += 2 * pop;
    int32_t A = r->rebelA + bells - (r->rebelA >> 6);
    if (A < 0) A = 0;
    if (A > B) A = B;
    r->rebelA = A;
    r->rebelB = B;
    int sol = (int)((int64_t)A * 100 / B);
    resolve();
    if (father_owned(FF_JAN_DE_WITT)) sol += 20;
    r->sol = (uint8_t)(sol > 100 ? 100 : sol);
}
static void sol_announce(int ci) {
    colony_rt *r = &CR.col[ci];
    const char *nm = CS.colonies[ci].name;
    int band = r->sol / 10;
    if (r->sol_band == 0xFF) r->sol_band = (uint8_t)band;
    else if (band > r->sol_band) { ev_emit("SONSUP", r->sol, 0, nm, 0); r->sol_band = (uint8_t)band; }
    else if (band < r->sol_band) { ev_emit("SONSDOWN", r->sol, 0, nm, 0); r->sol_band = (uint8_t)band; }
    if (r->sol >= 50 && !(r->latch & 0x04)) { r->latch |= 0x04; ev_emit("REBELMAJORITY", 0, 0, nm, 0); }
    if (r->sol >= 100 && !(r->latch & 0x02)) { r->latch |= 0x02; ev_emit("REBELUNANIMOUS", 0, 0, nm, 0); }
    if (r->sol < 95 && (r->latch & 0x02)) { r->latch &= ~0x02; ev_emit("TORYMINORITY", 0, 0, nm, 0); }
    if (r->sol < 50 && (r->latch & 0x04)) { r->latch &= ~0x04; ev_emit("TORYMAJORITY", 0, 0, nm, 0); }
}

/* ---- construction (advanceConstruction, game.js:3114) ------------------ */
static void advance_construction(int ci, int hammers) {
    ColonyRecord *c = &CS.colonies[ci];
    colony_rt *r = &CR.col[ci];
    c->hammers = (uint16_t)(c->hammers + hammers);
    int bip = c->building_in_production;
    if (bip >= DAT_BUILDINGS_COUNT) return;      /* none / unit target (TBD) */
    const dat_buildings_t *b = &dat_buildings[bip];
    int need_tools = b->tools_x10 * 10;
    if (r->sieged) return;
    if (c->hammers < b->cost) { r->tool_warned = 0; return; }
    resolve();
    if (has_bld(ci, bip) ||
        (bip == bld_by_name("Warehouse Expansion") && c->warehouse_level >= 2)) {
        ev_emit(strcmp(b->name, "Warehouse Expansion") == 0 ?
                "NOMOREWAREHOUSE" : "ALREADYHAVE", 0, 0, c->name, b->name);
        c->building_in_production = 0xFF;
        return;
    }
    if (c->stock[TOOLS] < need_tools) {
        if (!r->tool_warned) {
            r->tool_warned = 1;
            ev_emit(c->stock[TOOLS] > 0 ? "NEEDTOOLS" : "NEEDTOOLS0",
                    need_tools, c->stock[TOOLS], c->name, b->name);
            /* askZoom (game.js:6372 via 3155): choice 1 zooms to the
             * colony — G.screen leaves 'map', closing the parley gate. */
            if (ask_choice() == 1) {
                CR.screen_map = 0;
                int ord = -1;
                for (int q = 0; q <= ci; q++)
                    if ((CS.colonies[q].owner_power & 3) == cs_nation())
                        ord++;
                CR.zoom_colony = (int16_t)ord;
            }
        }
        return;
    }
    r->tool_warned = 0;
    c->hammers = (uint16_t)(c->hammers - b->cost);
    c->stock[TOOLS] = (uint16_t)(c->stock[TOOLS] - need_tools);
    building_add(ci, bip);
    if ((FACTORY_MASK >> bip) & 1) {
        PowerRecord *p = &CS.powers[cs_nation()];
        if (p->tax_rate < 75) {                  /* WOI flag TBD: fixtures 0 */
            p->tax_rate++;
            ev_emit("MERCANTILISM", 1, p->tax_rate, b->name,
                    dat_nations[cs_nation()].adjective);
        }
    }
    c->building_in_production = 0xFF;
    ev_emit("BUILT", 0, 0, c->name, b->name);
}

/* ---- schooling (runSchool, spec/systems/training.md) ------------------- */
static int profession_class(uint8_t prof) {
    if (prof < 1 || prof >= DAT_JOBEXPERT_COUNT) return 4;
    int i = expert_row(dat_jobexpert[prof]);     /* first row with the title */
    return i < 0 ? 4 : dat_jobtier[i];
}
static int school_level(int ci) {
    resolve();
    if (has_bld(ci, bld_by_name("University"))) return 3;
    if (has_bld(ci, bld_by_name("College"))) return 2;
    if (has_bld(ci, bld_by_name("Schoolhouse"))) return 1;
    return 0;
}
/* exported for the input layer's teacherGuard mirror (game.js:3050) */
int colony_school_level(int ci) { return school_level(ci); }
int colony_profession_class(int prof) {
    return profession_class((uint8_t)prof);
}
static int tier_rank(uint8_t prof) {             /* -1 unless a student tier */
    for (int t = 0; t < 3; t++)
        if (TIER_ROW[t] >= 0 && prof >= 1 && prof < DAT_JOBEXPERT_COUNT &&
            strcmp(dat_jobexpert[prof], dat_jobexpert[TIER_ROW[t]]) == 0)
            return t;
    return -1;
}
static void run_school(int ci) {
    static const int TEACH_TURNS[4] = { 0, 4, 6, 8 };
    ColonyRecord *c = &CS.colonies[ci];
    colony_rt *r = &CR.col[ci];
    int level = school_level(ci);
    if (!level) return;
    resolve();
    int faculty[3], nf = 0;
    for (int k = 0; k < c->population && nf < level; k++)
        if (c->occupation[k] == JOB_TEACHER && c->profession[k] &&
            profession_class(c->profession[k]) <= level)
            faculty[nf++] = k;
    if (!nf) return;
    for (int f = 0; f < nf; f++) {
        int teacher = faculty[f];
        int cls = profession_class(c->profession[teacher]);
        if (cls < 1 || cls > 3) continue;
        int need = TEACH_TURNS[cls];
        int student = -1;
        for (int k = 0; k < c->population; k++) {
            if (k == teacher || c->occupation[k] == JOB_TEACHER) continue;
            if (!c->profession[k] || tier_rank(c->profession[k]) >= 0) {
                student = k;
                break;
            }
        }
        if (student < 0) { ev_emit("TRAINFAIL", 0, 0, 0, 0); continue; }
        r->taught[student]++;
        if (r->taught[student] < need) continue;
        r->taught[student] = 0;
        int rung = tier_rank(c->profession[student]);
        if (rung == 0) {
            c->profession[student] = (uint8_t)TIER_ROW[1];
            ev_emit("TRAINCRIMINAL", 0, 0, c->name, 0);
        } else if (rung == 1) {
            c->profession[student] = (uint8_t)TIER_ROW[2];
            ev_emit("TRAININDENTURED", 0, 0, c->name, 0);
        } else {
            c->profession[student] = c->profession[teacher];
            ev_emit("TRAINPROFESSION", 0, 0, c->name,
                    dat_jobexpert[c->profession[teacher]]);
        }
    }
}

/* ---- over-100 disposal (autoExport, game.js:2832; gate func_02D606) ---- */
static void auto_export(int ci) {
    ColonyRecord *c = &CS.colonies[ci];
    colony_rt *r = &CR.col[ci];
    PowerRecord *p = &CS.powers[cs_nation()];
    int spoiled_good = -1, spoiled_qty = 0, n_spoiled = 0;
    resolve();
    int smith = 0;
    for (int b = 0; b < DAT_BUILDINGS_COUNT; b++)
        if (strstr(dat_buildings[b].name, "Blacksmith") && has_bld(ci, b)) smith = 1;
    for (int i = 0; i < N_GOODS; i++) {
        if (c->stock[i] < 100) continue;
        int prot = (i == FOOD || i == LUMBER || i == HORSES ||
                    i == TOOLS || i == MUSKETS) || (i == ORE && smith);
        if (prot) {
            if (i != FOOD && !((r->cargo_ready >> i) & 1)) {
                r->cargo_ready |= (uint16_t)(1 << i);
                ev_emit("CARGOREADY0", 0, 0, c->name, dat_cargo[i].name);
            }
            continue;
        }
        if (!((r->cargo_ready >> i) & 1)) {
            r->cargo_ready |= (uint16_t)(1 << i);
            ev_emit(c->warehouse_level < 2 ? "CARGOREADY1" : "CARGOREADY2",
                    100, 0, c->name, dat_cargo[i].name);
            /* askZoom (game.js:6372 via 2863): same colony-zoom ask. */
            if (ask_choice() == 1) {
                CR.screen_map = 0;
                int ord = -1;
                for (int q = 0; q <= ci; q++)
                    if ((CS.colonies[q].owner_power & 3) == cs_nation())
                        ord++;
                CR.zoom_colony = (int16_t)ord;
            }
        }
        int excess = c->stock[i] - 50;
        c->stock[i] = 50;
        int custom = has_bld(ci, BLD_CUSTOM);
        int custom_off = custom && !((c->custom_house_flags >> i) & 1);
        /* once independence is declared the excess is WASTED unless a
         * Custom House trades on ([0x5382]&1 @0x2D728; game.js:2871) */
        if (market_boycotted(i) ||
            ((CR.woi_flags & WOI_DECLARED) && !custom) || custom_off) {
            n_spoiled++;
            if (n_spoiled == 1) { spoiled_good = i; spoiled_qty = excess; }
            continue;
        }
        int32_t gross = excess * market_bid(i);
        int32_t tax = gross * p->tax_rate / 100;
        p->gold += gross - tax;
        p->kings_fund += tax;
    }
    for (int i = 0; i < N_GOODS; i++)
        if (c->stock[i] < 100) r->cargo_ready &= (uint16_t)~(1 << i);
    if (n_spoiled == 1)
        ev_emit(c->warehouse_level < 2 ? "SPOIL1" : "SPOIL3",
                spoiled_qty, 0, c->name, dat_cargo[spoiled_good].name);
    else if (n_spoiled > 1)
        ev_emit(c->warehouse_level < 2 ? "SPOIL2" : "SPOIL4", 0, 0, c->name, 0);
}

/* ---- the per-colony turn (colonyTurn, game.js:3004) -------------------- */
static const char *OUTAGE_KEY_OF(int raw) {
    switch (raw) {
    case SUGAR: return "CANESUGAR"; case TOBACCO: return "TOBACCO";
    case COTTON: return "COTTON"; case FURS: return "FURS";
    case LUMBER: return "LUMBER"; case ORE: return "ORE";
    case TOOLS: return "TOOLS"; default: return 0;
    }
}
void colony_turn(int ci) {
    ColonyRecord *c = &CS.colonies[ci];
    colony_rt *r = &CR.col[ci];
    colony_output o;
    colony_produce(ci, &o);
    /* colonyBesieged (game.js:2995): REF + at-war rival land units within
     * 1 of the colony outnumbering the player's attack-capable land units
     * there. */
    {
        int me = cs_nation(), enemies = 0, friends = 0;
        for (int ui = 0; ui < CS.n_units; ui++) {
            const UnitRecord *u = &CS.units[ui];
            if (u->type >= DAT_UNITS_COUNT ||
                dat_units[u->type].hull > 0) continue;
            int own = u->owner_flags & 0x0F;
            if (CR.unit_is_ref[ui]) {
                int dx = u->map_x - c->map_x, dy = u->map_y - c->map_y;
                if (dx < 0) dx = -dx;
                if (dy < 0) dy = -dy;
                if (dx <= 1 && dy <= 1) enemies++;
            } else if (own < 4 && own != me && !CR.unit_in_natives[ui]) {
                if (!((CR.war_matrix[me][own] | CR.war_matrix[own][me]) & 0x02))
                    continue;
                int dx = CR.runit_x[ui] - c->map_x;
                int dy = CR.runit_y[ui] - c->map_y;
                if (dx < 0) dx = -dx;
                if (dy < 0) dy = -dy;
                if (dx <= 1 && dy <= 1) enemies++;
            } else if (own == me && unit_on_map_player(ui) &&
                       dat_units[u->type].attack > 0) {
                int dx = u->map_x - c->map_x, dy = u->map_y - c->map_y;
                if (dx < 0) dx = -dx;
                if (dy < 0) dy = -dy;
                if (dx <= 1 && dy <= 1) friends++;
            }
        }
        if (enemies > friends) {
            if (!r->sieged) { r->sieged = 1; ev_emit("SIEGE", 0, 0, 0, 0); }
        } else r->sieged = 0;
    }
    for (int raw = 0; raw < N_GOODS; raw++) {
        const char *key = OUTAGE_KEY_OF(raw);
        if (!((o.outages >> raw) & 1)) { if (key) r->outage_latch &= (uint16_t)~(1 << raw); continue; }
        if (!key || ((r->outage_latch >> raw) & 1)) continue;
        r->outage_latch |= (uint16_t)(1 << raw);
        ev_emit(key, 0, 0, c->name, 0);
    }
    for (int i = 0; i < N_GOODS; i++) {
        int32_t v = (int32_t)c->stock[i] + o.out[i];
        c->stock[i] = (uint16_t)(v < 0 ? 0 : v);
    }
    {
        int32_t f = (int32_t)c->stock[FOOD] - o.eaten;
        c->stock[FOOD] = (uint16_t)(f < 0 ? 0 : f);
    }
    int pre_winter = cs_year() >= 1600 && cs_season() == 1;
    if (o.net_food < 0 && c->stock[FOOD] == 0) {
        if (!r->food_depleted) {
            r->food_depleted = 1;
            ev_emit(pre_winter ? "FOOD2" : "FOOD1", 0, 0, c->name, 0);
        } else if (c->population > 1) {
            colonist_remove_last(ci);
            ev_emit(pre_winter ? "STARVE2" : "STARVE1", 0, 0, c->name, 0);
            r->food_warned = 0;
        } else {
            r->vanished = 1;
            ev_emit("VANISH", 0, 0, c->name, 0);
        }
    } else if (o.net_food < 0 && c->stock[FOOD] < FOOD_FOR_COLONIST &&
               !r->food_warned) {
        r->food_warned = 1;
        ev_emit("FOODLOW", c->stock[FOOD], 0, c->name, 0);
    } else if (o.net_food >= 0) {
        r->food_warned = 0;
        r->food_depleted = 0;
    }
    if (c->stock[FOOD] >= FOOD_FOR_COLONIST) {
        c->stock[FOOD] = (uint16_t)(c->stock[FOOD] - FOOD_FOR_COLONIST);
        colonist_add(c);
        ev_emit("NEWCOLONIST", 0, 0, c->name, 0);
    }
    /* horses breed: threshold 25 with a Stable, 50 without (@0xA5BB) */
    resolve();
    {
        int herd = c->stock[HORSES];
        if (herd >= (has_bld(ci, BLD_STABLE) ? 25 : 50)) {
            int grow = herd / 10;
            c->stock[HORSES] = (uint16_t)(herd + (grow < 1 ? 1 : grow));
        }
    }
    /* tutorial bindings: NOT ported (see header) */
    /* @DEPLETION roll per worked silver cell, 1/50 (flagged in JS) */
    for (int k = 0; k < 8; k++) {
        int w = (uint8_t)c->tiles[k];
        if (w == 0xFF || w >= c->population) continue;
        if (c->occupation[w] != 7) continue;     /* @JOB row 7 = Silver Miner */
        static const int8_t DX[8] = {0,1,0,-1,-1,1,1,-1};
        static const int8_t DY[8] = {-1,0,1,0,-1,-1,1,1};
        int mi = (c->map_y + DY[k]) * COLOPY_MAP_W + (c->map_x + DX[k]);
        if (!(CS.improve[mi] & 0x80) && (int)((rng_next() * 50u) >> 15) == 0) {
            CS.improve[mi] |= 0x80;
            ev_emit("DEPLETION", 0, 0, c->name, 0);
        }
    }
    r->crosses_turn = o.crosses;
    {
        int bells = o.bells;
        if (has_bld(ci, BLD_NEWSPAPER)) bells *= 2;
        else if (has_bld(ci, BLD_PRESS)) bells = bells * 3 / 2;
        r->bells_turn = bells;
        update_sol(ci, bells);
    }
    sol_announce(ci);
    {
        /* the @INEFFICIENT latch reads the tory penalty off the runtime sol */
        int pop = c->population;
        int tories = (pop * (100 - r->sol) + 50) / 100;
        int pen = -(tories / (10 - cs_difficulty()));
        if (r->sol >= 50) pen += 1;
        if (r->sol >= 100) pen += 1;
        if (pen < 0 && !r->ineff) {
            r->ineff = 1;
            ev_emit("INEFFICIENT", 10 - cs_difficulty(), 0, c->name, 0);
        } else if (pen >= 0 && r->ineff) {
            r->ineff = 0;
            ev_emit("EFFICIENT", 0, 0, c->name, 0);
        }
    }
    advance_construction(ci, o.hammers);
    run_school(ci);
    auto_export(ci);
}

/* ---- the prefix turn step ---------------------------------------------- */
/* colonyUpkeep (game.js:2487): reduce over the LIST entries, each priced by
 * DATA.buildings.find(name) — the first row with that name. */
static int32_t total_upkeep(void) {
    int32_t due = 0;
    for (int ci = 0; ci < CS.n_colonies; ci++) {
        if ((CS.colonies[ci].owner_power & 3) != cs_nation()) continue;
        const colony_rt *r = &CR.col[ci];
        for (int k = 0; k < r->n_bld; k++)
            due += dat_buildings[bld_first_row(r->bld[k])].upkeep;
    }
    return due;
}

void turn_step_prefix(void) {
    /* header (game.js:10725): year cadence, 1600 season split */
    wr16(CS.globals + 0x0E, (uint16_t)(cs_turn() + 1));
    if (cs_year() < 1600) wr16(CS.globals + 0x0A, (uint16_t)(cs_year() + 1));
    else {
        if (!CR.time_changed) { CR.time_changed = 1; ev_emit("TIMECHANGE", 0, 0, 0, 0); }
        wr16(CS.globals + 0x0C, (uint16_t)((cs_season() + 1) % 2));
        if (cs_season() == 0) wr16(CS.globals + 0x0A, (uint16_t)(cs_year() + 1));
    }
    /* refresh the PLAYER's MAP units (JS G.units membership).  A
     * rival-born member has NO u.moves (see unit_rival_born) — the JS
     * assignment makes its movesLeft UNDEFINED, not full. */
    for (int i = 0; i < CS.n_units; i++)
        if (unit_on_map_player(i)) {
            if (CR.unit_no_moves[i]) { CR.unit_moves_undef[i] = 1; continue; }
            CR.unit_moves_undef[i] = 0;
            CS.units[i].moves_remaining =
                (uint8_t)(dat_units[CS.units[i].type].movement * 3);
        }
    for (int i = 0; i < CS.n_units; i++)
        if (unit_on_map_player(i)) CR.unit_slip[i] = 0;  /* u.slipChecked */
    /* payUpkeep */
    {
        int32_t due = total_upkeep();
        PowerRecord *p = &CS.powers[cs_nation()];
        if (!due) CR.upkeep_unpaid = 0;
        else if (p->gold >= due) { p->gold -= due; CR.upkeep_unpaid = 0; }
        else { CR.upkeep_unpaid = 1; ev_emit("UPKEEP", due, 0, 0, 0); }
    }
    /* the colony loop (player colonies, record order, like JS G.colonies) */
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation())
            colony_turn(ci);
    colony_vanish_filter();
}

/* deferred @VANISH removals (game.js:10745 and again at 10777 after the
 * native pass — raid-razed colonies leave the same way) */
void colony_vanish_filter(void) {
    for (int ci = CS.n_colonies - 1; ci >= 0; ci--) {
        if (!CR.col[ci].vanished) continue;
        memmove(&CS.colonies[ci], &CS.colonies[ci + 1],
                (size_t)(CS.n_colonies - ci - 1) * sizeof(ColonyRecord));
        memmove(&CR.col[ci], &CR.col[ci + 1],
                (size_t)(CS.n_colonies - ci - 1) * sizeof(colony_rt));
        CS.n_colonies--;
    }
}

/* Unit-pool mutators for the native pass. The JS lists are G.units /
 * G.natives; the C pool is the record array plus the parallel CR arrays,
 * so append/remove keep every per-unit runtime column aligned. */
int unit_append(int type, int owner, int x, int y) {
    if (CS.n_units >= COLOPY_MAX_UNITS) return -1;  /* capacity, not engine */
    int i = CS.n_units++;
    UnitRecord *u = &CS.units[i];
    memset(u, 0, sizeof(*u));
    u->map_x = (uint8_t)x;
    u->map_y = (uint8_t)y;
    u->type = (uint8_t)type;
    u->owner_flags = (uint8_t)(owner & 0x0F);
    u->moves_remaining = (uint8_t)(dat_units[type].movement * 3);
    CR.runit_x[i] = (int16_t)x;
    CR.runit_y[i] = (int16_t)y;
    if ((owner & 0x0F) == cs_nation()) units_push(i);   /* G.units.push */
    CR.unit_work[i] = 0;
    CR.unit_offered[i] = 0;
    CR.unit_faith[i] = 0;
    CR.unit_damaged[i] = 0;
    CR.unit_in_natives[i] = 0;
    CR.native_heading[i] = 0xFF;
    CR.native_home[i] = -1;
    CR.goal_x[i] = CR.goal_y[i] = -1;
    CR.unit_rival_born[i] =
        (uint8_t)((owner & 0x0F) < 4 && (owner & 0x0F) != (int)cs_nation());
    CR.unit_no_moves[i] = CR.unit_rival_born[i];
    CR.unit_moves_undef[i] = 0;
    CR.unit_n_hold[i] = 0;
    CR.unit_n_pass[i] = 0;
    CR.unit_treasure[i] = 0;
    CR.unit_slip[i] = 0;
    CR.unit_is_ref[i] = 0;
    CR.unit_veteran[i] = 0;
    return i;
}
void unit_remove(int ui) {
    size_t n = (size_t)(CS.n_units - ui - 1);
    memmove(&CS.units[ui], &CS.units[ui + 1], n * sizeof(UnitRecord));
    memmove(&CR.unit_work[ui], &CR.unit_work[ui + 1], n);
    memmove(&CR.unit_offered[ui], &CR.unit_offered[ui + 1], n);
    memmove(&CR.unit_faith[ui], &CR.unit_faith[ui + 1], n);
    memmove(&CR.unit_damaged[ui], &CR.unit_damaged[ui + 1], n);
    memmove(&CR.native_heading[ui], &CR.native_heading[ui + 1], n);
    memmove(&CR.native_home[ui], &CR.native_home[ui + 1], n);
    memmove(&CR.unit_in_natives[ui], &CR.unit_in_natives[ui + 1], n);
    memmove(&CR.runit_x[ui], &CR.runit_x[ui + 1], n * sizeof(int16_t));
    memmove(&CR.runit_y[ui], &CR.runit_y[ui + 1], n * sizeof(int16_t));
    memmove(&CR.goal_x[ui], &CR.goal_x[ui + 1], n * sizeof(int16_t));
    memmove(&CR.goal_y[ui], &CR.goal_y[ui + 1], n * sizeof(int16_t));
    memmove(&CR.unit_rival_born[ui], &CR.unit_rival_born[ui + 1], n);
    memmove(&CR.unit_no_moves[ui], &CR.unit_no_moves[ui + 1], n);
    memmove(&CR.unit_moves_undef[ui], &CR.unit_moves_undef[ui + 1], n);
    memmove(&CR.unit_treasure[ui], &CR.unit_treasure[ui + 1],
            n * sizeof(uint16_t));
    memmove(&CR.unit_slip[ui], &CR.unit_slip[ui + 1], n);
    memmove(&CR.unit_is_ref[ui], &CR.unit_is_ref[ui + 1], n);
    memmove(&CR.unit_veteran[ui], &CR.unit_veteran[ui + 1], n);
    memmove(&CR.unit_hold[ui], &CR.unit_hold[ui + 1],
            n * sizeof(CR.unit_hold[0]));
    memmove(&CR.unit_n_hold[ui], &CR.unit_n_hold[ui + 1], n);
    memmove(&CR.unit_pass[ui], &CR.unit_pass[ui + 1],
            n * sizeof(CR.unit_pass[0]));
    memmove(&CR.unit_n_pass[ui], &CR.unit_n_pass[ui + 1], n);
    CS.n_units--;
    /* keep the G.natives / G.units order lists aligned: drop the removed
     * member, re-base every index past it */
    for (int k = 0; k < CR.n_natives; k++) {
        if (CR.natives_order[k] == ui) {
            memmove(&CR.natives_order[k], &CR.natives_order[k + 1],
                    (size_t)(CR.n_natives - k - 1));
            CR.n_natives--;
            k--;
            continue;
        }
        if (CR.natives_order[k] > ui) CR.natives_order[k]--;
    }
    for (int k = 0; k < CR.n_units_order; k++) {
        if (CR.units_order[k] == ui) {
            memmove(&CR.units_order[k], &CR.units_order[k + 1],
                    (size_t)(CR.n_units_order - k - 1));
            CR.n_units_order--;
            k--;
            continue;
        }
        if (CR.units_order[k] > ui) CR.units_order[k]--;
    }
    for (int rn = 0; rn < 4; rn++)
        for (int k = 0; k < CR.n_runits[rn]; k++) {
            if (CR.runits_order[rn][k] == ui) {
                memmove(&CR.runits_order[rn][k], &CR.runits_order[rn][k + 1],
                        (size_t)(CR.n_runits[rn] - k - 1));
                CR.n_runits[rn]--;
                k--;
                continue;
            }
            if (CR.runits_order[rn][k] > ui) CR.runits_order[rn][k]--;
        }
    for (int k = 0; k < CR.n_refs; k++) {
        if (CR.refs_order[k] == ui) {
            memmove(&CR.refs_order[k], &CR.refs_order[k + 1],
                    (size_t)(CR.n_refs - k - 1));
            CR.n_refs--;
            k--;
            continue;
        }
        if (CR.refs_order[k] > ui) CR.refs_order[k]--;
    }
}
/* The scripted-answer policy (see colopy_sim.h): choice = seq++ % 2,
 * with an A<choice> marker in the event stream so the parity diff pins
 * every decision. */
int ask_choice(void) {
    int c = (int)(CR.ask_seq++ % 2u);
    ev_emit(c ? "A1" : "A0", 0, 0, 0, 0);
    return c;
}

void natives_push(int ui) {
    if (CR.n_natives < COLOPY_MAX_UNITS)
        CR.natives_order[CR.n_natives++] = (uint8_t)ui;
}
void units_push(int ui) {
    if (CR.n_units_order < COLOPY_MAX_UNITS)
        CR.units_order[CR.n_units_order++] = (uint8_t)ui;
}
void units_order_drop(int ui) {
    for (int k = 0; k < CR.n_units_order; k++)
        if (CR.units_order[k] == ui) {
            memmove(&CR.units_order[k], &CR.units_order[k + 1],
                    (size_t)(CR.n_units_order - k - 1));
            CR.n_units_order--;
            return;
        }
}
void runits_push(int rn, int ui) {
    if (CR.n_runits[rn] < COLOPY_MAX_UNITS)
        CR.runits_order[rn][CR.n_runits[rn]++] = (uint8_t)ui;
}
void runits_drop(int rn, int ui) {
    for (int k = 0; k < CR.n_runits[rn]; k++)
        if (CR.runits_order[rn][k] == ui) {
            memmove(&CR.runits_order[rn][k], &CR.runits_order[rn][k + 1],
                    (size_t)(CR.n_runits[rn] - k - 1));
            CR.n_runits[rn]--;
            return;
        }
}

/* ======================================================================
 * Pipeline step 2: advanceImprovements + checkImmigration + updateCongress
 * + checkTreasure (game.js:10858/10153/7656/8558), in endTurn order.
 * ====================================================================== */

/* Is this record one of the JS port's MAP units (G.units membership)?
 * The importer (game.js:10417-10484) excludes: other owners, landless
 * walkers on water/off-map (cargo or dock), and off-map ships (parked in
 * Europe).  Everything counting "your units" counts THESE. */
int unit_on_map_player(int ui) {
    const UnitRecord *u = &CS.units[ui];
    if ((u->owner_flags & 0x0F) != cs_nation()) return 0;
    int ship = dat_units[u->type].hull > 0;
    int off = u->map_x >= COLOPY_MAP_W || u->map_y >= COLOPY_MAP_H;
    if (!ship && (off || tile_water(map_at(u->map_x, u->map_y)))) return 0;
    if (off) return 0;
    return 1;
}

/* adjustTension (game.js:5103): France and Pocahontas halve anger; band
 * crossings announce INDIANWAR/INDIANPEACE at the War edge, PISS<cause>
 * elsewhere; every village of the tribe takes the delta on its alarm. */
int father_by_name(const char *n) {
    for (int i = 0; i < DAT_FATHERS_COUNT; i++)
        if (strcmp(dat_fathers[i].name, n) == 0) return i;
    return -1;
}
int tension_band(int n) {
    return n >= 100 ? 4 : n >= 75 ? 3 : n >= 40 ? 2 : n >= 20 ? 1 : 0;
}
void adjust_tension(int tribe, int delta, int cause) {
    if (tribe < 0 || tribe >= 8) return;
    if (delta > 0 && (cs_nation() == 1 ||
                      father_owned(father_by_name("Pocahontas"))))
        delta /= 2;
    int before = tension_band(CR.tension[tribe]);
    int t = CR.tension[tribe] + delta;
    if (t < 0) t = 0;
    if (t > 100) t = 100;
    CR.tension[tribe] = (uint8_t)t;
    int after = tension_band(t);
    if (after == 4 && before < 4)
        ev_emit("INDIANWAR", 0, 0, dat_tribes[tribe].name, 0);
    else if (before == 4 && after < 4)
        ev_emit("INDIANPEACE", 0, 0, dat_tribes[tribe].name,
                dat_nations[cs_nation()].adjective);
    else if (after > before) {
        char key[8] = "PISS0";
        key[4] = (char)('0' + cause);
        ev_emit(key, 0, 0, dat_nations[cs_nation()].adjective,
                dat_tribes[tribe].name);
    }
    for (int i = 0; i < CS.n_villages; i++)
        if (CS.villages[i].owner_tribe == tribe + 4) {
            int a = CR.alarm[i] + delta;
            if (a < 0) a = 0;
            if (a > 255) a = 255;
            CR.alarm[i] = (uint8_t)a;
        }
}

/* spendTools (game.js:2396): -20 per finished job; below 20 the pioneer
 * puts the kit down and reverts to Colonists. */
static void spend_tools(int ui) {
    UnitRecord *u = &CS.units[ui];
    int t = u->tools - 20;
    if (t >= 20) { u->tools = (uint8_t)t; return; }
    u->tools = 0;
    for (int i = 0; i < DAT_UNITS_COUNT; i++)
        if (strcmp(dat_units[i].name, "Colonists") == 0) u->type = (uint8_t)i;
    ev_emit("USEDUPTOOLS", 0, 0, 0, 0);
}

/* advanceImprovements (game.js:10858). Orders 8 = clear/plow, 9 = road.
 * Iterates G.units INSERTION order (the JS `G.units.slice()`), not
 * record order — the nearest-colony lumber grant and the event stream
 * depend on it once the command layer sets orders. */
static int is_forested_id(int t) { return t >= 8 && t <= 23; }
static void advance_improvements(void) {
    for (int k = 0; k < CR.n_units_order; k++) {
        int ui = CR.units_order[k];
        UnitRecord *u = &CS.units[ui];
        if (u->orders != 8 && u->orders != 9) continue;
        int road = u->orders == 9;
        int mi = u->map_y * COLOPY_MAP_W + u->map_x;
        if (road && (map_improve(u->map_x, u->map_y) & ROAD_BIT)) {
            u->orders = 0;
            CR.unit_work[ui] = 0;
            continue;
        }
        CR.unit_work[ui]++;
        /* workThreshold (game.js:2327): column + 2 off-road, Hardy halves */
        int thr = improve_work(map_at(u->map_x, u->map_y)) + (road ? 0 : 2);
        if (u->profession >= 1 && u->profession < DAT_JOBEXPERT_COUNT &&
            strcmp(dat_jobexpert[u->profession], "Hardy Pioneers") == 0)
            thr >>= 1;
        if (thr < 1) thr = 1;
        if (CR.unit_work[ui] < thr) continue;
        CR.unit_work[ui] = 0;
        u->orders = 0;
        if (road) {
            CS.improve[mi] |= ROAD_BIT;
        } else if (is_forested_id(tile_terrain(map_at(u->map_x, u->map_y)))) {
            /* clear: lumber grant from the LUMBERJACK column x10 (flagged in
             * game.js -- the spec's +0x2F80 column conflicts), then fold the
             * id and drop 8 (CLAUDE.md hard rule 3: fold 16..23 first). */
            int lumber = tile_yield(map_at(u->map_x, u->map_y), 5) * 10;
            int t = tile_terrain(CS.terrain[mi]);
            if (t >= 16 && t <= 23) t = (t & 7) | 8;
            CS.terrain[mi] = (uint8_t)((CS.terrain[mi] & ~0x1F) | (t - 8));
            int best = -1, bd = 0;
            for (int ci = 0; ci < CS.n_colonies; ci++) {
                const ColonyRecord *c = &CS.colonies[ci];
                if ((c->owner_power & 3) != cs_nation()) continue;
                int d = (c->map_x > u->map_x ? c->map_x - u->map_x : u->map_x - c->map_x) +
                        (c->map_y > u->map_y ? c->map_y - u->map_y : u->map_y - c->map_y);
                if (best < 0 || d < bd) { best = ci; bd = d; }
            }
            if (best >= 0 && lumber > 0) {
                ColonyRecord *c = &CS.colonies[best];
                c->stock[LUMBER] = (uint16_t)(c->stock[LUMBER] + lumber);
                ev_emit("CLEARCUT", lumber, 0, c->name, 0);
                int woods = 0;
                for (int dy = -1; dy <= 1; dy++)
                    for (int dx = -1; dx <= 1; dx++)
                        if (is_forested_id(tile_terrain(
                                map_at(u->map_x + dx, u->map_y + dy)))) woods++;
                if (!woods) ev_emit("DEFOREST", 0, 0, c->name, 0);
                for (int v = 0; v < CS.n_villages; v++) {
                    int ax = CS.villages[v].map_x - u->map_x;
                    int ay = CS.villages[v].map_y - u->map_y;
                    if (ax < 0) ax = -ax;
                    if (ay < 0) ay = -ay;
                    if (ax <= 2 && ay <= 2) {
                        int tr = CS.villages[v].owner_tribe - 4;
                        ev_emit("INDIANFOREST2", 0, 0,
                                tr >= 0 && tr < 8 ? dat_tribes[tr].name : 0,
                                c->name);
                        adjust_tension(tr, 5, 2);
                        break;
                    }
                }
            }
        } else {
            CS.improve[mi] |= PLOW_BIT;
        }
        spend_tools(ui);
    }
}

/* rollImmigrant (game.js:4284): every 4th turn a trainable expert;
 * otherwise the criminal/servant/free ladder off two rolls. */
void roll_immigrant(immigrant *out) {
    /* fresh JS object: no noBoard / type override — callers hand in stack
     * locals (the Fountain's cands[3]), so every field must be written */
    memset(out, 0, sizeof(*out));
    int thr = (cs_difficulty() + 3) >> 1;
    if ((cs_turn() & 3) == 0 && cs_turn() > 0) {
        out->kind = 1;
        out->idx = (uint8_t)((rng_next() * (uint32_t)DAT_JOBTRAIN_COUNT) >> 15);
        return;
    }
    if ((int)((rng_next() * 15u) >> 15) + 1 <= thr) { out->kind = 0; out->idx = 0; return; }
    if ((int)((rng_next() * 10u) >> 15) + 1 <= thr) { out->kind = 0; out->idx = 1; return; }
    out->kind = 2;
    out->idx = 0;
}
const char *immigrant_name(const immigrant *m) {
    if (m->kind == 1) return dat_jobtrain[m->idx].expert;
    if (m->kind == 0) return dat_classes[m->idx].name;
    if (m->kind == 3) return dat_units[m->idx].name;    /* a @UNIT type */
    if (m->kind == 4) return dat_jobexpert[m->idx];     /* a profession */
    return "Free Colonists";
}

/* checkImmigration (game.js:10153). The Brewster branch mirrors the trace's
 * stubbed askEvent (key emitted, callback never run) -- flagged; real play
 * wiring lands with the command loop. */

/* immigrationThreshold (game.js:10135) — exported for the F2 report. */
int immigration_threshold(void) {
    int accum = 0;
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation())
            accum += CS.colonies[ci].population;
    for (int ui = 0; ui < CS.n_units; ui++)
        if (unit_on_map_player(ui)) accum++;
    if (accum < 4000) accum *= 2;
    accum += 8;
    if (accum > 4000) accum = 4000;
    accum = accum * (8 - cs_difficulty()) / 8;
    if (cs_nation() == 0) accum = accum * 2 / 3;
    return accum;
}

static void check_immigration(void) {
    int per = 0;
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation())
            per += CR.col[ci].crosses_turn;
    CR.crosses += per;
    int accum = immigration_threshold();
    if (CR.crosses < accum) return;
    CR.crosses -= accum;
    resolve();
    if (father_owned(father_by_name("William Brewster"))) {
        /* @RECRUITCHOOSE (game.js:10164): the answered slot recruits and
         * refills; no @UNREST on this branch */
        ev_emit("RECRUITCHOOSE", 0, 0, dat_nations[cs_nation()].homeport, 0);
        int slot2 = ask_choice();
        if (slot2 < 0 || slot2 > 2) slot2 = 0;
        if (CR.n_dock_units < sizeof(CR.dock_units) / sizeof(CR.dock_units[0]))
            CR.dock_units[CR.n_dock_units++] = CR.dock[slot2];
        roll_immigrant(&CR.dock[slot2]);
        return;
    }
    int slot = (int)((rng_next() * 3u) >> 15);
    if (CR.n_dock_units < sizeof(CR.dock_units) / sizeof(CR.dock_units[0]))
        CR.dock_units[CR.n_dock_units++] = CR.dock[slot];
    roll_immigrant(&CR.dock[slot]);
    ev_emit("UNREST", 0, 0, dat_nations[cs_nation()].homeport,
            immigrant_name(&CR.dock[0]));
}


/* fatherCost (game.js:7620) — exported for the F3 report. */
int father_cost_now(void) {
    int owned = 0;
    for (int i = 0; i < DAT_FATHERS_COUNT; i++)
        if (father_owned(i)) owned++;
    int base = (cs_difficulty() + 3) * 16;
    int gates[4] = { 1600, 1650, 1700, 1750 };
    for (int g = 0; g < 4; g++)
        if (cs_year() >= gates[g]) base += base >> 1;
    int cost = (owned + 1) * base + 1;
    if (owned == 0) cost >>= 1;
    return cost;
}

/* updateCongress (game.js:7656) + fatherCandidates/fatherCost/effects. */
static void update_congress(void) {
    int bpt = 0;
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation())
            bpt += CR.col[ci].bells_turn;
    if (!bpt) return;
    PowerRecord *p = &CS.powers[cs_nation()];
    p->bells = (uint16_t)(p->bells + bpt);
    CR.bells_total += bpt;
    if (CR.father_in_progress < 0) {
        int era = cs_year() < 1600 ? 0 : cs_year() < 1700 ? 1 : 2;
        int cand[5], nc = 0;
        for (int cat = 0; cat < 5; cat++) {
            int pool[32], np = 0, total = 0;
            for (int i = 0; i < DAT_FATHERS_COUNT; i++)
                if (dat_fathers[i].category == cat &&
                    dat_fathers[i].weights[era] > 0 &&
                    !father_owned(i)) {
                    pool[np++] = i;
                    total += dat_fathers[i].weights[era];
                }
            if (!np) continue;
            int budget = 1 + (int)((rng_next() * (uint32_t)total) >> 15);
            int pick = pool[np - 1];
            for (int k = 0; k < np; k++) {
                budget -= dat_fathers[pool[k]].weights[era];
                if (budget <= 0) { pick = pool[k]; break; }
            }
            cand[nc++] = pick;
        }
        if (!nc) return;
        /* @WHICHFREEDOM (game.js:7666): default = the first candidate,
         * the answered choice re-picks within the candidate rows */
        CR.father_in_progress = (int16_t)cand[0];
        ev_emit("WHICHFREEDOM", 0, 0, 0, 0);
        {
            int c = ask_choice();
            if (c >= 0 && c < nc)
                CR.father_in_progress = (int16_t)cand[c];
        }
    }
    /* fatherCost (game.js:7620) */
    {
        int cost = father_cost_now();
        /* after the Declaration: cost = d*1500 + 2000 (game.js:7626) */
        if (CR.woi_flags & WOI_DECLARED)
            cost = cs_difficulty() * 1500 + 2000;
        if (p->bells < cost) return;
        p->bells = (uint16_t)(p->bells - cost);
    }
    int f = CR.father_in_progress;
    p->founding_fathers |= 1u << f;
    ev_emit("FREEDOM", 0, 0, dat_fathers[f].name,
            dat_nations[cs_nation()].adjective);
    /* applyFatherEffect (game.js:7683) -- the wired three */
    if (strcmp(dat_fathers[f].name, "Jakob Fugger") == 0)
        CR.boycotts = 0;                 /* G.boycotts = [] (runtime) */
    if (strcmp(dat_fathers[f].name, "Jean de Brebeuf") == 0)
        for (int v = 0; v < CS.n_villages; v++)
            if (CS.villages[v].mission != 0xFF &&
                (CS.villages[v].mission & 0x0F) == cs_nation())
                CS.villages[v].mission |= 0x10;
    if (strcmp(dat_fathers[f].name, "Bartolome de las Casas") == 0) {
        int conv = expert_row("Indian Converts");
        if (conv >= 0) {
            for (int ui = 0; ui < CS.n_units; ui++)
                if ((CS.units[ui].owner_flags & 0x0F) == cs_nation() &&
                    CS.units[ui].profession == conv)
                    CS.units[ui].profession = (uint8_t)TIER_ROW[2];
            for (int ci = 0; ci < CS.n_colonies; ci++) {
                ColonyRecord *c = &CS.colonies[ci];
                if ((c->owner_power & 3) != cs_nation()) continue;
                for (int k = 0; k < c->population; k++)
                    if (c->profession[k] == conv)
                        c->profession[k] = (uint8_t)TIER_ROW[2];
            }
        }
    }
    CR.father_in_progress = -1;
}

/* checkTreasure (game.js:8558): one offer per turn; the ask is stubbed in
 * the trace, so only the latch + key are visible (flagged). */
static void check_treasure(void) {
    resolve();
    int galleon = 0, ty_treasure = -1, ty_galleon = -1;
    for (int i = 0; i < DAT_UNITS_COUNT; i++) {
        if (strcmp(dat_units[i].name, "Treasure") == 0) ty_treasure = i;
        if (strcmp(dat_units[i].name, "Galleon") == 0) ty_galleon = i;
    }
    for (int ui = 0; ui < CS.n_units; ui++)
        if (unit_on_map_player(ui) && CS.units[ui].type == ty_galleon)
            galleon = 1;
    /* hasGalleon (game.js:8520) counts the Europe fleet too */
    for (int k = 0; k < CR.n_europe; k++)
        if (CR.europe[k].type == ty_galleon) galleon = 1;
    for (int k = 0; k < CR.n_units_order; k++) {
        int ui = CR.units_order[k];          /* G.units order */
        UnitRecord *u = &CS.units[ui];
        if (u->type != ty_treasure || CR.unit_offered[ui]) continue;
        int on_colony = 0;
        for (int ci = 0; ci < CS.n_colonies; ci++)
            if (CS.colonies[ci].map_x == u->map_x &&
                CS.colonies[ci].map_y == u->map_y &&
                (CS.colonies[ci].owner_power & 3) == cs_nation()) on_colony = 1;
        if (!on_colony) continue;
        CR.unit_offered[ui] = 1;
        /* with independence declared there is no Crown to take a share:
         * cashTreasureInFull (game.js:8524/8536) — full value, no ask */
        if (CR.woi_flags & WOI_DECLARED) {
            int32_t gross_full = (int32_t)CR.unit_treasure[ui] * 100;
            CS.powers[cs_nation()].gold += gross_full;
            unit_remove(ui);
            ev_emit("CASHTREASURE", gross_full, 0, 0, 0);
            return;
        }
        /* offerGalleon (game.js:8532): gross = (u.treasure||0)*100 —
         * u.treasure comes from the LCR/burial finds (slice 4); imported
         * treasures carry 0 (the importer never reads the class byte).
         * kingsCut (8515): Cortes -> the tax rate, else
         * max(5*difficulty+50, 2*tax) capped 90. */
        int32_t gross = (int32_t)CR.unit_treasure[ui] * 100;
        int32_t cut = father_owned(father_by_name("Hernan Cortes"))
            ? CS.powers[cs_nation()].tax_rate
            : (5 * cs_difficulty() + 50 >
                   2 * CS.powers[cs_nation()].tax_rate
                   ? 5 * cs_difficulty() + 50
                   : 2 * CS.powers[cs_nation()].tax_rate);
        if (cut > 90) cut = 90;
        ev_emit(galleon ? "KINGGALLEON3" : "KINGGALLEON2", cut, 0, 0, 0);
        if (ask_choice() == 0) {
            int32_t take = gross * cut / 100;
            PowerRecord *p = &CS.powers[cs_nation()];
            p->gold += gross - take;
            p->kings_fund += take;
            unit_remove(ui);
            ev_emit("LOOTCASH", gross, cut, 0, 0);
        }
        return;
    }
}

/* @REFIT (game.js:10754): a damaged ship spending the turn in a port with a
 * Drydock/Shipyard is fixed — the one-turn timer is the JS port's flagged
 * stand-in (the engine's repair timer is unread). */
static void refit_ships(void) {
    for (int ui = 0; ui < CS.n_units; ui++) {
        if (!unit_on_map_player(ui)) continue;
        if (dat_units[CS.units[ui].type].hull <= 0 || !CR.unit_damaged[ui])
            continue;
        int home = -1;
        for (int ci = 0; ci < CS.n_colonies; ci++)
            if ((CS.colonies[ci].owner_power & 3) == cs_nation() &&
                CS.colonies[ci].map_x == CS.units[ui].map_x &&
                CS.colonies[ci].map_y == CS.units[ui].map_y) { home = ci; break; }
        if (home < 0) continue;
        if (colony_has_name(home, "Drydock") ||
            colony_has_name(home, "Shipyard")) {
            CR.unit_damaged[ui] = 0;
            ev_emit("REFIT", 0, 0, dat_units[CS.units[ui].type].name,
                    CS.colonies[home].name);
        }
    }
}

/* per-step RNG probe (COLOPY_STEP_RNG=1): parity-debug only, stderr */
#include <stdio.h>
#include <stdlib.h>
void step_rng(const char *name) {
    static int on = -1;
    if (on < 0) on = getenv("COLOPY_STEP_RNG") != 0;
    if (on) fprintf(stderr, "STEP %s %lu\n", name, (unsigned long)CS.rng);
}

void turn_step2(void) {
    refit_ships();               step_rng("refit");
    advance_improvements();      step_rng("advanceImprovements");
    check_immigration();         step_rng("checkImmigration");
    update_congress();           step_rng("updateCongress");
    check_treasure();            step_rng("checkTreasure");
}
