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
 *   - colonyBesieged: returns 0 — needs the REF/rival war state (later
 *     pipeline steps).  The fixtures are siege-free; a diff will scream
 *     here if that ever stops holding.
 *   - unit BUILD targets: the importer nulls them (bip >= 42), so the
 *     completion path handles buildings only.  TBD with the unit pipeline.
 */
#include <string.h>

#include "colopy_sim.h"
#include "../data/colopy_data.h"

void ev_emit(const char *key, int32_t p0, int32_t p1,
             const char *s0, const char *s1);

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

static int father_owned(int idx) {
    return idx >= 0 && ((CS.powers[cs_nation()].founding_fathers >> idx) & 1);
}
static int has_bld(int ci, int idx) {
    if (idx < 0) return 0;
    if (colony_buildings(&CS.colonies[ci]) & (1ull << idx)) return 1;
    return 0;
}

/* runtime sol (JS c.sol): seeded from the record ratio at load, then owned
 * by update_sol — the JS importer's exact life cycle. */
int rt_sol(int ci) { return CR.col[ci].sol; }

void cr_reset_from_load(void) {
    memset(CR.col, 0, sizeof(CR.col));
    CR.upkeep_unpaid = 0;
    CR.time_changed = 0;
    for (int i = 0; i < CS.n_colonies; i++) {
        CR.col[i].sol = (uint8_t)colony_sol(&CS.colonies[i]);
        CR.col[i].sol_band = 0xFF;
    }
}

/* ---- record mutators --------------------------------------------------- */
static void colonist_add(ColonyRecord *c) {
    if (c->population >= 32) return;             /* record slot cap */
    c->occupation[c->population] = 0xFF;         /* no job (like JS null) */
    c->profession[c->population] = 0;
    c->population++;
}
static void colonist_remove_last(int ci) {
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
        }
        int excess = c->stock[i] - 50;
        c->stock[i] = 50;
        int custom = has_bld(ci, BLD_CUSTOM);
        int custom_off = custom && !((c->custom_house_flags >> i) & 1);
        /* G.declared TBD (fixtures 0) — the declared-and-no-customs waste
         * branch is unreachable until the WoI step lands */
        if (market_boycotted(i) || custom_off) {
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
    /* colonyBesieged: prefix stub (see header) */
    r->sieged = 0;
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
static int32_t total_upkeep(void) {
    int32_t due = 0;
    for (int ci = 0; ci < CS.n_colonies; ci++) {
        if ((CS.colonies[ci].owner_power & 3) != cs_nation()) continue;
        for (int b = 0; b < DAT_BUILDINGS_COUNT; b++)
            if (has_bld(ci, b)) due += dat_buildings[b].upkeep;
        if (CS.colonies[ci].warehouse_level >= 2) {
            int e = bld_by_name("Warehouse Expansion");
            if (e >= 0) due += dat_buildings[e].upkeep;
        }
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
    /* refresh the PLAYER's units (JS G.units holds only those) */
    for (int i = 0; i < CS.n_units; i++) {
        UnitRecord *u = &CS.units[i];
        if ((u->owner_flags & 0x0F) != cs_nation()) continue;
        u->moves_remaining = (uint8_t)(dat_units[u->type].movement * 3);
    }
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
    /* deferred @VANISH removals */
    for (int ci = CS.n_colonies - 1; ci >= 0; ci--) {
        if (!CR.col[ci].vanished) continue;
        memmove(&CS.colonies[ci], &CS.colonies[ci + 1],
                (size_t)(CS.n_colonies - ci - 1) * sizeof(ColonyRecord));
        memmove(&CR.col[ci], &CR.col[ci + 1],
                (size_t)(CS.n_colonies - ci - 1) * sizeof(colony_rt));
        CS.n_colonies--;
    }
}
