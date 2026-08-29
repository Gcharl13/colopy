/* Internal sim declarations — NOT part of the public API (colopy_core.h).
 * Each function mirrors a named game.js function; citations live at the
 * definitions. */
#ifndef COLOPY_SIM_H
#define COLOPY_SIM_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h>
#include <stdint.h>

#include "colopy_state.h"

/* ---- RNG: the Microsoft C runtime LCG the engine ships ----------------- */
/* state = state*214013 + 2531011; result = (state>>16) & 0x7FFF — byte-read
 * at file 0x0103D4/0x0103C2 (game.js:3344, verified against live DOSBox RAM,
 * RULINGS 2026-08-06b). */
uint32_t rng_next(void);                    /* 0..0x7FFF */
int32_t  rng_range(int32_t lo, int32_t hi); /* func_00C322: lo+((r*(hi-lo+1))>>15) */

/* ---- map/tile queries (game.js:356-455, 2415) -------------------------- */
#define TERR_OCEAN   25
#define TERR_SEALANE 26
#define ROAD_BIT 0x08
#define PLOW_BIT 0x40
#define DEPLETED_BIT 0x80   /* port-runtime marker (engine resource plane unread) */

uint8_t map_at(int x, int y);               /* terrain byte, 0 off-map */
uint8_t map_improve(int x, int y);
/* the tile's detail/prime-resource id, or -1 (tile_terrain_variant_hash
 * @0x0060A0; see colopy_map.c) */
int map_detail_id(int mx, int my, uint8_t v);          /* masked to 0x48 like the JS import */
int  tile_terrain(uint8_t v);               /* v & 0x1F */
int  tile_water(uint8_t v);
int  tile_hills(uint8_t v);
int  tile_mountains(uint8_t v);
int  tile_river(uint8_t v);                 /* 0 none / 1 minor / 2 major */
int  tile_yield_class(uint8_t v);           /* func_00624E: hills/mtn rows */
uint8_t map_improve_raw(int x, int y);      /* unmasked plane 2 byte */
int  map_count8_terr(int x, int y, int lo, int hi); /* func_0099EE */
int  tile_yield(uint8_t v, int col);        /* the nine-column terrain tables */

/* ---- goods & job tallies ---------------------------------------------- */
enum { FOOD = 0, SUGAR, TOBACCO, COTTON, FURS, LUMBER, ORE, SILVER, HORSES,
       RUM, CIGARS, CLOTH, COATS, TRADE, TOOLS, MUSKETS, N_GOODS };

typedef struct {
    int32_t out[N_GOODS];       /* net per good */
    int32_t gross[N_GOODS];     /* before converter consumption */
    int32_t consumed[N_GOODS];
    int32_t hammers, bells, crosses, teaching;
    int32_t centre;             /* the centre tile's food */
    int32_t eaten;              /* 2*population + horses_bred, @0xA5F2/@0xA63F */
    int32_t horses_bred;        /* this turn's foals, BYTE_VERIFIED @0x0A5B4.. */
    int32_t net_food;
    uint16_t outages;           /* bit per raw good that starved a converter */
    /* the engine's outage plane [-0x71A6] (set_commodity_band @0x8E32):
     * per RAW good, max(0, consumed - stock - produced); for a factory
     * chain converted to PRODUCT units (@0x8EC9..@0x8EFC).  This is the
     * crossed-out run the colony panel draws (Vlissingen's 4 lumber),
     * and it is what the product output was reduced by. */
    int32_t outage_amt[N_GOODS];
    /* the engine's [-0x71CE] plane (@0x8E20): max(0, consumed - produced)
     * per raw good = the part drawn from the warehouse; row 0 of the
     * production panel appends THIS as its crossed run (@0x027604). */
    int32_t over_amt[N_GOODS];
    int32_t sec_good, sec_amount; /* the centre's secondary yield (@0xA343) */
    int32_t depletion_pts;        /* [0xA896]: mineral wear this turn */
    int32_t fish_food;            /* [0xA895]: the fishermen's share of the
                                   * food -- the food row's shaded split
                                   * (@0x27337/@0x2737E) is fish vs land,
                                   * not centre vs fields */
} colony_output;

/* colonyProduce (game.js:2630) over the RECORD form; ci indexes CS.colonies
 * (production reads the RUNTIME SoL, which the importer seeds from the
 * record and update_sol then owns — the JS c.sol life cycle). */
void colony_produce(int ci, colony_output *r);
int  rt_sol(int ci);

/* Record-side helpers shared with later subsystems. */
int  colony_sol(const ColonyRecord *c);         /* % from +0xC2/+0xC6 */
uint64_t colony_buildings(const ColonyRecord *c); /* bit per @BUILDING id */
int  colony_has(const ColonyRecord *c, const char *building_name);

/* The RUNTIME building list (JS c.buildings). The record's tier-packed
 * field cannot express a chain with a middle link torn out, but a raid
 * (game.js:5735 RAIDWREAK / 5783 RAIDBURN) removes an arbitrary list
 * member — so the sim's building queries all run over this JS-ordered
 * id list in CR.col[ci], seeded from the record at load (import order:
 * families ascending, then Warehouse Expansion) and spliced exactly like
 * the JS list. JS membership tests are by NAME (c.buildings.includes),
 * which these mirror. The record bytes are NOT rewritten on removal —
 * the engine's own raid write (dec tier @0x5C42A) differs from the JS
 * flat-list model the port mirrors; FLAGGED. */
int  colony_has_name(int ci, const char *name);   /* JS includes(name) */
int  workplace_job_for_name(const char *building_name); /* jobForBuilding */
int  colony_is_expert(uint8_t prof, int job);  /* isExpert (2526) */
/* worker slot -> cell offset (CELL_OF_WORKER, game.js:10338) */
extern const int8_t colony_cell_dx[8], colony_cell_dy[8];
int  colony_job_good(int job);   /* JOB_GOOD[job]: cargo id, or < 0 for
                                  * hammers(-1)/bells(-2)/crosses(-3)/
                                  * teaching(-4) */
int  colony_school_level(int ci);     /* schoolLevel (game.js:3042) */
int  colony_profession_class(int prof); /* professionClass: tier, 4 = none */
int  bld_first_row(int idx);         /* JS bldIndex/DATA.buildings.find */
void colony_bld_seed(int ci);        /* rebuild list from the record */
void colony_bld_append(int ci, int idx);
void colony_bld_remove_name(int ci, const char *name); /* splice(indexOf) */
int  chain_count_i(int ci, int job); /* chainCount over the runtime list */
/* per-colonist yields + the road/plow bonus (colopy_colony.c) — exported
 * for the Phase-7 colony-screen renderer */
int  improvement_bonus(int x, int y, int g);
int  field_yield(const ColonyRecord *c, int sol, int job,
                 uint8_t prof, int dx, int dy);
int  indoor_yield(int ci, int sol, int job, uint8_t prof);
void colony_centre_yield(int ci, int *food, int *good, int *amount);

/* ---- movement (colopy_move.c) ------------------------------------------ */
int move_cost(int is_ship, int fx, int fy, int tx, int ty);   /* in thirds */
int terrain_move(uint8_t v);
int terrain_defence(uint8_t v);
int improve_work(uint8_t v);        /* pioneer work threshold column */

/* ---- combat (colopy_combat.c): the §14.1-14.3 modifier chain ----------- */
typedef struct {
    uint8_t type;            /* @UNIT row */
    uint8_t terrain;         /* the tile byte the unit stands on */
    uint8_t on_colony;
    uint8_t orders;          /* 5/6 = Fortify/Fortified */
    uint8_t is_defender;
    uint8_t damaged, veteran, fatigue, holds, artillery;
    uint8_t privateer_drake, spain_attacker, woi_ref_bombard;
    uint8_t village_def;     /* func_007D3E settlement branch: 0 = none,
                              * else the 2/4/x2-capital bonus REPLACES the
                              * whole tile bonus (exclusive, @0x7D8D..) */
    int8_t  difficulty;
} combat_params;
int combat_total(const combat_params *p);

/* ---- the Europe market (colopy_market.c) ------------------------------ */
int     market_bid(int good);
int     market_ask(int good);
int     market_boycotted(int good);
void    market_drift(void);
int32_t market_sell(int good, int32_t qty);
int32_t market_buy(int good, int32_t qty);
int32_t market_accum(int good);
void    market_reset_accum(void);   /* call at load: JS-importer semantics */

/* ---- the turn pipeline (colopy_turn.c, colopy_natives.c) --------------- */
void cr_reset_from_load(void);   /* seed runtime from the loaded records */
void units_session_seed(void);   /* importer's runtime unit setup (moves,
                                  * orders) — session entry, NOT load */
void colony_turn(int ci);
void colony_advance_construction(int ci, int hammers); /* rushBuy tail */
void step_rng(const char *name); /* COLOPY_STEP_RNG=1 parity probe (stderr) */
void turn_step_prefix(void);     /* the ported endTurn prefix */
void turn_step2(void);           /* refit/improvements/immigration/congress/treasure */
void turn_step3(void);           /* the native pass (§19.11) + vanish filter */
void rival_turn(void);           /* rivalTurn (game.js:7514) + checkContact */
void turn_step5(void);           /* rivalTurn .. retirement — the endTurn tail */
int  unit_on_map_player(int ui);  /* JS G.units membership predicate */
/* trade routes (colopy_rivals.c): routeStopName/routeName/createRoute/
 * runTradeRoute/advanceTradeRoutes (game.js:7715-7815) */
void route_stop_name(int16_t stop, char *out, int cap);
void route_auto_name(const int16_t *stops, int n, char *out, int cap);
int  route_create(const int16_t *stops, int n, int sea, const char *name);
void advance_trade_routes(void);
void pick_music(void);           /* GAME "Pick Music" (func_023344) */
/* fog of war (colopy_map.c): reveal (game.js:8584), sightRadius (8576),
 * revealAll (8594) — the player's 1<<(power+4) bit in CS.fog */
void colopy_reveal(int x, int y, int r);
int  unit_sight_radius(int ui);
void colopy_reveal_all(void);

/* Combat resolution (colopy_resolve.c): resolveAttack (game.js:7219) with
 * applyDefeat (7066) and tryPromote (7185).  Both sides are unit-record
 * indexes; rival positions read/write the CR mirrors. */
int  resolve_attack(int att_ui, int def_ui); /* removed record idx, -1 none */
int  analysis_total(int ui, int is_defender); /* combatAnalysis(u,d).total */
int  tribe_level(int tribe);      /* TribeData +0x02 (the @TRIBES level) */
int  unit_pos_x(int ui);         /* record, or the rival mirror */
int  unit_pos_y(int ui);
void colony_remove(int ci);      /* immediate splice (rival capture path) */
void colony_vanish_filter(void);  /* the deferred @VANISH compaction */
void rival_colony_pass(int power); /* B3.6: func_02F052 for one rival */
void adjust_tension(int tribe, int delta, int cause);  /* game.js:5103 */
void village_first_welcome(void);
/* scoreParts — the F10 numbers (population/fathers/sentiment/razed/
 * gold/liberty/revolution, base points, the difficulty multiplier and
 * the Colonization Rating total). */
typedef struct {
    int population, fathers, sentiment, razed, gold, liberty, revolution;
    int base, mult, total;
} score_parts_t;
void score_parts(score_parts_t *s);  /* firstTribeContact's woodcut callback
                                    * (game.js:1222-1241): the
                                    * @INDIANWELCOME treaty ask — run by
                                    * the LIVE front on plate dismissal */
/* 1 = a LIVE front end drives the core (dialog-gated flows complete;
 * woodcut/select channels fill); 0 = the deterministic harness.
 * Defined in the game layer (colopy_input.c). */
extern int colopy_front_live;
int  tension_band(int n);         /* tensionBandIdx (game.js:5093) */
void colonist_remove_last(int ci);
void colonist_remove_at(int ci, int k);  /* func_008FB4 (0x181F:0xA9C) */
int  colonist_to_fence(int ci, int k);  /* colonistToFence; unit idx or -1 */
void colonist_add(ColonyRecord *c);   /* the record-slot push */
void ev_emit(const char *key, int32_t p0, int32_t p1,
             const char *s0, const char *s1);

/* Unit-pool mutators shared by the native pass (converts, braves). */
int  unit_append(int type, int owner, int x, int y);  /* record idx or -1 */
void unit_remove(int ui);        /* compact records + parallel CR arrays */
void natives_push(int ui);       /* JS G.natives.push (order matters) */
void units_push(int ui);         /* JS G.units.push */
void units_order_drop(int ui);   /* JS G.units.splice (record kept) */
void runits_push(int rn, int ui);      /* JS r.units.push */
void runits_drop(int rn, int ui);      /* JS r.units.splice (record kept) */

/* Phase 5: every askEvent site calls this ONCE (the trace increments its
 * counter on every ask, answered or not), emits an "A<choice>" marker
 * event, and applies the ported callback body under the same choice. */
int ask_choice(void);
const char *ev_last_key(void);
int ask_key_count(void);
const char *ask_key_name(int i);
uint32_t ask_key_hits(int i);
extern int (*colopy_ask_hook)(void);  /* live front end's answer path */

/* ---- player commands (colopy_cmd.c) — Phase 5 slice 2 ------------------ */
/* Each mirrors the game.js UI command over the selected unit; ui indexes
 * CS.units.  Branches a scripted trace cannot reach (ship moves, rival
 * tiles, villages, sea lane, rumour entry) are explicit no-ops pending
 * slices 3-5 — the shared script filter keeps both engines off them. */
int  unit_full_moves(int ui);         /* @UNIT movement * 3 (thirds) */
int  rumour_at(int x, int y);         /* rumourAt (game.js:8712) */
int  raid_target_score(int vi, int *score_out); /* func_0460F8 */
void cmd_move(int ui, int dx, int dy);        /* moveSel (game.js:10919) */
void cmd_skip(int ui);                        /* skipUnit (game.js:10872) */
void cmd_set_order(int ui, int n);            /* setOrder (game.js:11181) */
void cmd_improve(int ui, int n);              /* improveOrder (game.js:11191) */
void cmd_goto(int ui, int gx, int gy);        /* Go To: orders 3 + goal */
void cmd_activate(int ui);                    /* activateUnit (game.js:11228) */
int  cmd_build_colony(int ui);                /* buildColony (game.js:11258):
                                               * joined ordinal, -2 = a name
                                               * would found, else -1 */
int  cmd_found_colony(int ui, const char *name); /* nameAndFound tail */
void colony_capture_record(int ci, int pop);  /* @CAPTURED re-found */
int  enter_rumour(int ui, int x, int y);      /* enterRumour (game.js:8740);
                                               * 0 = the unit is gone, no step */

/* ---- the village layer (colopy_village.c) — Phase 5 slice 4b ----------- */
void village_enter(int vi, int ui);           /* enterVillage (game.js:6430) */
int  village_action_rows(uint8_t *ids_out);   /* villageActions (6466): the
                                               * open village's row ids */
void run_village_action(int id);              /* runVillageAction (6494) —
                                               * ids 0/1 (trade) are slice-4c
                                               * no-ops, script remaps to 9 */

/* ---- ship movement + naval combat (slice 4c) --------------------------- */
void run_meeting(int rn, int via_ship);       /* runMeeting (game.js:8254) */
int  naval_attack(int att_ui, int def_ui);    /* navalAttack (game.js:6895) */
int  rel_at_war(int a, int b);
/* ---- the War of Independence (colopy_woi.c) — Phase 5 slice 5 ---------- */
#define WOI_DECLARED 1
#define WOI_INTERVENTION 2
#define WOI_WON 8
int  national_sol(void);              /* nationalSoL (game.js:8856) */
int  woi_locked(void);                /* woiLocked (game.js:8145) */
void declare_independence(void);      /* declareIndependence (game.js:9007) */
void run_war(void);                   /* runWar (game.js:9127) */
void tory_uprising(void);             /* toryUprising (game.js:9306) */
void offer_mercenaries(void);         /* offerMercenaries (game.js:9235) */
void check_intervention(void);        /* checkIntervention (game.js:9327) */
void refs_push(int ui);               /* G.refUnits.push */
void end_game_sequence(void);         /* endGameSequence (game.js:8119) */
int  rel_have_treaty(int a, int b);
int  rel_parley_eligible(int rn);
void rel_declare_war(int a, int b);
void rel_set_privateer(int a, int b);
int32_t demand_value(int base);       /* demandValue (game.js:8210) */
int  father_owned(int idx);           /* G.fathersOwned.includes */
int  colony_has_bld_name(int ci, const char *name);  /* c.buildings.includes */
int  immigration_threshold(void);     /* game.js:10135 (F2 report) */
int  father_cost_now(void);           /* fatherCost (F3 report) */
int  father_by_name(const char *name);

/* ---- the Europe layer (colopy_europe.c) — Phase 5 slice 3 -------------- */
void europe_seed_from_load(void);     /* importer 10477: off-map ships dock */
void advance_crossings(void);         /* advanceCrossings (game.js:3258) */
void cmd_sail_for_europe(int ui);     /* sailForEurope (game.js:3231) */
int  nearest_sea_lane(int ui, int *x, int *y);  /* nearestSeaLane */
int  cmd_order_sail_home(int ui);     /* orderSailHome; 1 = departed */
const char *colony_suggested_name(void);  /* the @COLONY prefill */
void euro_sail_new_world(int ei);     /* sailForNewWorld (game.js:3243) */
void euro_sell_from_ship(int ei, int good, int32_t qty); /* sellFromShip */
void euro_buy_to_ship(int ei, int good, int32_t qty);    /* buyToShip */
void euro_recruit(int slot);          /* euroMenuCommit 'recruit' row */
void euro_purchase(int row);          /* euroMenuCommit PURCHASE + REALLYBUY */
void euro_train(int sorted_row);      /* euroMenuCommit 'train' row */
int32_t euro_recruit_cost(int slot);  /* the row's passage price */
int32_t euro_purchase_price(int row); /* purchasePrice incl. escalation */
int32_t euro_train_cost(int sorted_row);
int32_t euro_hold_qty(int ei, int good); /* holdQty over a port ship */
void king_petition(void);             /* petitionLowerTaxes (game.js:8898) */
void blockade_census(int *any, int *frig); /* func_042138 colony +0x1B scan */
void euro_arm_dock(int k, int verb_row); /* euroContextCommit 'arm' */
int  euro_arm_rows(int k, uint8_t *verbs_out); /* dockUnitRows arm subset */
const char *euro_purchase_unit(int row);       /* PURCHASE[row].unit */
const char *euro_train_expert(int sorted_row); /* the TRAIN list order */
/* entry_unit_type / hold_add are declared below the immigrant and
 * hold_slot typedefs. */

/* Runtime state that lives beside the save image (JS object-model fields
 * with no record home). One entry per colony, parallel to CS.colonies. */
typedef struct {
    uint8_t  sol;                /* runtime SoL % (JS c.sol) */
    uint8_t  sol_band;           /* 0xFF = unset */
    uint8_t  latch;              /* 0x04 majority / 0x02 unanimous */
    int32_t  rebelA, rebelB;     /* EMA pair; 0 = unseeded */
    uint8_t  ineff, sieged;
    uint8_t  blockade;           /* +0x1B bits: 1 = rival ship in the +-5
                                  * box, 2 = a Frigate (func_042138 census,
                                  * @0x424F3..; water-path gate unported) */
    uint8_t  tool_warned, cap_warned, vanished;
    uint16_t outage_latch;
    int32_t  crosses_turn, bells_turn;
    uint8_t  taught[32];         /* schoolhouse per-student counters */
    uint8_t  bld[48];            /* the JS-ordered building-id list */
    uint8_t  n_bld;
} colony_rt;

/* A dock/passenger ENTRY (game.js:4590): a plain name — kind 0 = @CLASS
 * row, kind 1 = a jobtrain expert (rollImmigrant), kind 2 = the "Free
 * Colonists" literal, kind 3 = a @UNIT type name, kind 4 = a @JOBEXPERT
 * profession name — until Europe ARMS it, after which it carries a type
 * override ({ name, type }, type_ov = @UNIT row + 1).  no_board is the
 * @ARMOPTIONS "Don't get on next ship" flag. */
typedef struct { uint8_t kind, idx, type_ov, no_board; } immigrant;

/* one Hall of Fame record (HALLFAME.DAT fields: +0x18 nation, +0x1a
 * declared, +0x1c independence-won, +0x1e year, +0x22 difficulty,
 * +0x24 score points, +0x26 rating % — the ranking key) */
typedef struct {
    char name[24];
    uint8_t nation, difficulty, declared, independent;
    uint16_t year;
    int32_t score, rating;
} colopy_hof_rec;

/* A hold slot (JS { good, qty }); holds are LISTS with holdAdd merge
 * semantics (game.js:3300), not per-good arrays. */
typedef struct { uint8_t good; int16_t qty; } hold_slot;
#define EURO_HOLD_MAX 8
#define EURO_PASS_MAX 8

/* A crossing / port ship (JS G.europe member, game.js:3231-3298). */
typedef struct {
    uint8_t type;                /* @UNIT row */
    uint8_t state;               /* 0 port / 1 toEurope / 2 toNewWorld */
    uint8_t turns, damaged;
    uint8_t work;                /* the +0x16 repair counter, riding along */
    int16_t lane_x, lane_y;      /* the sea-lane square it left from */
    hold_slot hold[EURO_HOLD_MAX];
    uint8_t n_hold;
    immigrant pass[EURO_PASS_MAX];
    uint8_t n_pass;
} euro_crossing;

int  entry_unit_type(const immigrant *e);      /* entryType (game.js:4595) */
void hold_add(hold_slot *hold, uint8_t *n, int good, int qty); /* holdAdd */

/* A rival power's colony (JS r.colonies member): a runtime OBJECT, not a
 * record — the importer builds these from the rival-owned ColonyRecords
 * (game.js:10374-10380) and rivalTurn founds new ones with no record at
 * all.  Coordinates are SIGNED like the JS numbers: the sailer's y-drift
 * can step off the map edge (off-map reads Ocean, game.js:469), and the
 * port mirrors that arithmetic rather than wrapping it. */
/* sol: the colony's rebel/SoL % (func_008524: 100·(+0xC2)/(+0xC6)),
 * imported once — rival colonies produce no bells (B3.6), so it is
 * static; runtime-founded ones start at 0. */
typedef struct { int16_t x, y; uint8_t level, pop, spared, sol; } rival_colony;
typedef struct {
    uint8_t met, greeted;
    uint8_t next_colony;         /* colony-name rotation counter */
    uint8_t n_col;
    rival_colony col[48];
    int32_t gold;                /* seeded from the power record +0x2A */
    uint8_t attitude;            /* importer seeds 8 (game.js:10333) */
    uint8_t rebel_pct;           /* newsTick independence walk (flagged) */
    uint8_t last_pct, independent;   /* +0x1A last-announced pct mirror */
} rival_rt;

typedef struct {
    uint8_t upkeep_unpaid;       /* @UPKEEP half-rate latch */
    uint8_t time_changed;        /* @TIMECHANGE one-shot */
    int32_t crosses;             /* immigration accumulator (JS G.crosses) */
    int32_t cross_threshold;     /* F2 gauge span (JS G.crossThreshold) */
    int32_t bells_total;         /* whole-game bells (JS G.bellsTotal) */
    int16_t father_in_progress;  /* dat_fathers index, -1 = none */
    immigrant dock[3];           /* the three Europe dock candidates */
    immigrant dock_units[64];    /* recruits waiting on the dock */
    uint8_t n_dock_units;
    uint8_t tension[8];          /* per-tribe anger toward the player, 0..100 */
    uint8_t tribe_frac[8];       /* mission-tick feeder (JS t.frac) */
    uint8_t alarm[COLOPY_MAX_SETTLEMENTS];  /* per-village (JS v.alarm) */
    uint8_t brave_owed[COLOPY_MAX_SETTLEMENTS]; /* JS v.braveOwed */
    uint8_t unit_work[COLOPY_MAX_UNITS];    /* pioneer work counters */
    /* JS u.sailHome: this ship is under a Go To whose destination is
     * the sea lane it was ordered home through, so ARRIVING there
     * departs instead of just clearing the order. */
    uint8_t unit_sail_home[COLOPY_MAX_UNITS];
    uint8_t unit_offered[COLOPY_MAX_UNITS]; /* treasure offer latch */
    uint8_t unit_damaged[COLOPY_MAX_UNITS]; /* JS u.damaged (raids/refit) */
    uint8_t unit_fatigue[COLOPY_MAX_UNITS]; /* JS u.fatigue (§14.3 tired) */
    uint8_t native_heading[COLOPY_MAX_UNITS]; /* 0..7, 0xFF = unset */
    int8_t  native_home[COLOPY_MAX_UNITS];  /* home-village index, -1 none */
    uint8_t raid_seen;           /* woodcut-13 latch (JS G.raidSeen) */
    /* Rival unit positions live HERE, signed, after load (JS r.units[].x/y
     * go negative off the west edge; the record byte cannot).  Every
     * rival-position read goes through these; the record coords are stale
     * once rivalTurn has moved a unit — FLAGGED like the building list. */
    int16_t runit_x[COLOPY_MAX_UNITS], runit_y[COLOPY_MAX_UNITS];
    rival_rt rivals[4];          /* indexed by NATION; player's entry unused */
    uint16_t parley_lock[4];     /* G.parleyLock, per rival nation */
    uint8_t war_matrix[4][4];    /* REL bits, G.warMatrix — empty at load */
    uint8_t treaty_matrix[4][4]; /* REL bits, G.treatyMatrix */
    uint8_t rival_wars[4][4];    /* the rival-vs-rival news-war flags */
    /* JS G.natives membership beyond braves: a rival-captured unit is
     * PUSHED TO G.NATIVES (applyDefeat game.js:7111 — its else-arm), so it
     * leaves r.units/G.units yet still occupies its tile.  The flag keeps
     * the C lists honest to that quirk. */
    uint8_t unit_in_natives[COLOPY_MAX_UNITS];
    /* G.natives INSERTION ORDER (record indexes): the brave mover draws
     * RNG per member in list order, so the order is part of the parity
     * contract — imported braves first (record order), then every
     * spawnBrave/capture APPEND, exactly like the JS pushes. */
    uint8_t natives_order[COLOPY_MAX_UNITS];
    uint16_t n_natives;
    /* G.units INSERTION ORDER (record indexes): the importer builds it
     * ships-then-land (each record-ascending), and every later join —
     * converts, the King's veterans, a rival unit CAPTURED by the player
     * (applyDefeat game.js:7109 pushes it at the END) — appends.  The
     * first-adjacent-foe scans walk this order, so it is part of the
     * parity contract exactly like natives_order. */
    uint8_t units_order[COLOPY_MAX_UNITS];
    uint16_t n_units_order;
    /* r.units INSERTION ORDER per rival nation: seeded ships-then-land
     * from the records; spanishSuccession APPENDS the ceded power's
     * units to the winner's list (game.js:7015) — record order cannot
     * express that. */
    uint8_t runits_order[4][COLOPY_MAX_UNITS];
    uint16_t n_runits[4];
    int16_t king_war_stamp[4];   /* G.kingWars: per-rival declaration turn
                                  * ([0x53C8+b*2] @0x36128), -1 = none;
                                  * expires 16 turns later (@0x57FFF) */
    uint8_t king_weddings;       /* [0x53A7]: lifetime wedding count, cap 30 */
    uint8_t king_war_country;    /* [0x53A8]: last @KINGWAR country, 1..8 */
    uint8_t succession;          /* spanishSuccession latch */
    uint8_t retired, soon_warned;
    uint8_t scored;              /* G.scored (the SCORED answer latch) */
    uint16_t boycotts;           /* G.boycotts — RUNTIME, [] at import
                                  * (game.js:10287); the record's +0x20
                                  * word is NOT what the JS reads */
    uint32_t ask_seq;            /* the scripted-answer counter — the trace
                                  * answers every ask with askSeq++ % 2 and
                                  * RUNS the callback; ask_choice() mirrors */
    uint8_t ui_advance;          /* a cmd branch that ends in the JS
                                  * advance() ran — the input layer
                                  * consumes it */
    int16_t zoom_colony;         /* askZoom answer-1 target: the PLAYER
                                  * colony ordinal to open, -1 none (the
                                  * input layer consumes it) */
    uint8_t screen_map;          /* G.screen === 'map' (parley gate); the
                                  * retirement report leaves the map, a
                                  * woodcut dismissal returns to it */
    /* Slice 2 — the player-command layer.  u.movesLeft lives in the
     * RECORD's moves_remaining byte, in THIRDS (the @UNIT loader
     * multiplies the column by 3, unit.md §3 / game.js:660); seeded full
     * at load (mkUnit — the JS importer ignores the save's byte) and
     * refreshed at the top of endTurn (game.js:10740).
     * Go To executor state (JS u.orders === 3 + u.goal; advanceGoTo
     * game.js:2274).  -1 = no goal. */
    int16_t goal_x[COLOPY_MAX_UNITS], goal_y[COLOPY_MAX_UNITS];
    /* JS OBJECT PROVENANCE: a unit born on a rival's side (importer
     * game.js:10443 or a rivalTurn spawn) is a bare {type,icon,x,y,
     * nation,orders,ship} object — NO moves, NO tools, NO profession.
     * Captured into G.units it keeps that shape, so its first endTurn
     * refresh sets movesLeft = u.moves = UNDEFINED and it never passes
     * a movesLeft > 0 test again.  unit_rival_born records the
     * provenance (permanent); unit_moves_undef mirrors "movesLeft is
     * currently undefined/NaN" (set by the refresh, cleared when a
     * command writes a number). */
    /* Slice 3 — the Europe layer.  Crossings (JS G.europe), the ship
     * hold/passenger mirrors (JS u.hold / u.cargo — the record's cargo
     * bytes cannot express them and stay import-only), and the
     * purchase-escalation counter. */
    euro_crossing europe[24];
    uint8_t n_europe;
    uint8_t artillery_bought;    /* G.artilleryBought (+100$ per) */
    hold_slot unit_hold[COLOPY_MAX_UNITS][EURO_HOLD_MAX];
    uint8_t   unit_n_hold[COLOPY_MAX_UNITS];
    immigrant unit_pass[COLOPY_MAX_UNITS][EURO_PASS_MAX];
    uint8_t   unit_n_pass[COLOPY_MAX_UNITS];
    /* Slice 4b — the village layer (enterVillage game.js:6430 + the
     * @ACTIONS handlers).  Per-village runtime flags (v.greeted/taught/
     * tributePaid are runtime; chiefSeen SEEDS from the record's flags
     * bit 0x08 and is runtime after), the demand cache (villageDemand
     * caches on first call — the CACHING is part of the parity contract
     * because clears can change the map after it), per-tribe runtime
     * (t.met/treaty/shunned/dead/warWith/musketsKnown/horsesKnown/herd —
     * beginGame objects carry none of these), and the open-village
     * cursor (G.village/G.villageVisitor). */
    uint8_t village_flags[COLOPY_MAX_SETTLEMENTS];  /* 1 greeted 2 taught
                                                     * 4 tributePaid
                                                     * 8 chiefSeen */
    int16_t village_demand[COLOPY_MAX_SETTLEMENTS][16];
    uint8_t village_demand_set[COLOPY_MAX_SETTLEMENTS];
    uint8_t tribe_met[8], tribe_treaty[8], tribe_shunned[8], tribe_dead[8];
    int8_t  tribe_war_with[8];       /* rival nation, -1 none */
    int16_t tribe_muskets_known[8], tribe_horses_known[8], tribe_herd[8];
    int8_t  cur_village;             /* G.village index, -1 closed */
    uint8_t village_screen;          /* enterVillage outcome: 1 = the
                                      * village screen stays open (no
                                      * fresh woodcut fired) */
    int8_t  wc_show;                 /* LIVE FRONT: a woodcut plate to
                                      * display (-1 none) — the harness
                                      * stub never sets it */
    int8_t  wc_after;                /* its dismissal: 0 map / 1 village
                                      * + the @INDIANWELCOME chain /
                                      * 2 village (plates 1/2 route by
                                      * number, onClick game.js:12086) */
    int16_t ui_select;               /* LIVE FRONT: select this
                                      * units_order index (-1 none) —
                                      * the landfall party (10905) */
    uint8_t land_ho;                 /* woodcut-1 latch (G.landHo;
                                      * loads import it true, 10240) */
    char leader[24];                 /* G.leader — the front sets it at
                                      * New Game; empty = the nation's
                                      * default leader */
    uint8_t built_colony;            /* woodcut-2 latch (G.builtColony) */
    uint16_t wc_seen;                /* G.wcSeen runtime mask (init 0 —
                                      * the importer does NOT restore
                                      * [0x540A], game.js:710) */
    int16_t cur_visitor;             /* G.villageVisitor record idx */
    /* Slice 4a — Lost City Rumours (enterRumour game.js:8740). */
    uint8_t rumours_done[(COLOPY_MAP_W * COLOPY_MAP_H + 7) / 8];
    uint8_t rumour_floor;        /* anti-streak floor, 1..3 (G.rumourFloor) */
    uint8_t found_fountain, found_cibola;
    uint16_t unit_treasure[COLOPY_MAX_UNITS]; /* JS u.treasure (value/100) */
    uint8_t unit_slip[COLOPY_MAX_UNITS]; /* u.slipChecked: one interception
                                          * check per move order, reset by
                                          * the endTurn refresh */
    /* Slice 5 — the War of Independence (§18.3; game.js:8865-9356).
     * The King's expeditionary units are records with the 0x0F owner
     * sentinel + unit_is_ref (JS G.refUnits, mkUnit-born, veteran). */
    uint8_t woi_flags;               /* 1 declared / 2 intervention / 8 won */
    uint16_t declared_year;
    colopy_hof_rec hof[6];           /* the Hall of Fame table
                                      * (HALLFAME.DAT semantics,
                                      * capture-pinned 2026-08-07);
                                      * the SHELL loads/persists it */
    uint8_t n_hof, hof_dirty;
    uint16_t game_options, colony_options, sound_options;
                                     /* G option words (defaults 0x0200 /
                                      * 0 / 0x07, game.js:580); Combat
                                      * Analysis = game bit 0x0200 */
    int16_t ref_pool[4];             /* Regulars/Cavalry/Man-O-War/Artillery */
    int32_t royal_fund;
    uint8_t razed;
    uint8_t nat_band;                /* national SoL band, 0xFF unset */
    uint8_t warned_ports, warned_pop, lost_war, ambush_hinted;
    uint8_t merc_seen, intervention_watch;
    uint8_t how_to_won;              /* @HOWTOWIN one-shot (G.howToWon) */
    uint8_t unit_is_ref[COLOPY_MAX_UNITS];
    uint8_t unit_veteran[COLOPY_MAX_UNITS];  /* JS u.veteran object flag */
    uint8_t refs_order[COLOPY_MAX_UNITS];    /* G.refUnits order */
    uint16_t n_refs;
    uint8_t unit_rival_born[COLOPY_MAX_UNITS];
    /* "u.moves is undefined": seeded = rival_born, but CLEARED by
     * becomeType (game.js:7061 assigns u.moves) — a demoted rival object
     * gains a real budget and refreshes normally thereafter. */
    uint8_t unit_no_moves[COLOPY_MAX_UNITS];
    uint8_t unit_moves_undef[COLOPY_MAX_UNITS];
    /* The rumour salt word [0x190] (JS G.mapSeed).  beginGame ROLLS it
     * (game.js:742) with the native RNG, so the trace PINS it (1653) after
     * import on both sides — the sim never reads it except through
     * rumour_at.  0 disables rumours (@0x6191). */
    uint16_t map_seed;
    uint32_t plot_seed;              /* G.plotSeedBase — the colony-layout
                                      * seed (beginGame game.js:677; loads
                                      * pin 1653 per the trace convention) */
    colony_rt col[COLOPY_MAX_COLONIES];
    /* LIVE-FRONT presentation channel: the runtime option rows of the
     * NEXT ask (the JS askEvent's rows argument — goto port picker,
     * @CUSTOM export toggles).  A live front draws them in place of
     * the event's static tail rows and clears the count; the harness
     * ask policy never reads them. */
    uint8_t tune;                    /* G.tune = the engine's [0x96]:
                                      * the tune id Pick Music selects
                                      * (0x20-0x3E, spec/ui/
                                      * options_dialogs.md §3) */
    int8_t  ask_sel;                 /* LIVE FRONT: the row an ask opens
                                      * HIGHLIGHTED on (the JS sets
                                      * G.dialog.sel); 0 unless set */
    char new_land[24];               /* G.newLand — what the player
                                      * named the New World (@LANDHO) */
    char ask_rows[18][26];
    int8_t n_ask_rows;
    /* trade routes (game.js:7713: MAX_ROUTES 12, MAX_STOPS 4, Europe
     * stop id 999).  Session-runtime like the JS G.routes — never in
     * the .SAV; stops are PLAYER-colony ordinals (G.colonies index). */
    struct colopy_route {
        char    name[26];
        int8_t  sea;
        int8_t  n_stops;
        int16_t stops[4];
        /* per-stop cargo lanes — the record's nibble-packed good lists
         * (+0x03..+0x05 LOAD / +0x06..+0x08 UNLOAD, six nibbles each;
         * trade_routes.md §2).  B3.4. */
        uint8_t n_load[4], n_unload[4];
        uint8_t load[4][6], unload[4][6];
    } routes[12];
    int8_t  n_routes;
    int16_t unit_route[COLOPY_MAX_UNITS];       /* u.route, -1 none */
    uint8_t unit_stop_index[COLOPY_MAX_UNITS];  /* u.stopIndex */
} colopy_runtime;

/* the .SAV sidecar (colopy_extras.c): the two things the port models
 * that the fixed DOS save has no room for — a colony's UNIT build
 * target and the trade-route table.  Shell-only; the parity harness
 * never calls these. */
size_t colopy_extras_write(unsigned char *buf, size_t cap);
int    colopy_extras_read(const unsigned char *buf, size_t len);

#define COLOPY_MAX_ROUTES 12
#define COLOPY_MAX_STOPS  4
#define COLOPY_STOP_EUROPE 999
extern colopy_runtime CR;

void roll_immigrant(immigrant *out);
const char *immigrant_name(const immigrant *m);

#ifdef __cplusplus
}
#endif
#endif /* COLOPY_SIM_H */
