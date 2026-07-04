// session.cpp -- the GAME SESSION: canonical state + lifecycle of a running
// game (new game from scenario, the end-turn pipeline, notices, save/load,
// state JSON). Extracted verbatim from forge/main.cpp (N0) so the native
// application (viceroy) and the web/editor routes drive the SAME session.
// The HTTP layer stays in main.cpp and calls into here.
// forge/main.cpp -- Viceroy Forge: the headless balance inspector (F1 MVP).
//
//   forge inspect [overlay.json]
//
// Loads the default ruleset (optionally with a rules.json mod overlay applied),
// validates it with sim::check_rules(), and prints key balance curves with deltas
// vs the un-modded baseline -- so a designer can see exactly how an edit moves the
// game. It links the headless sim in-process; this is the "balance laboratory."
// The Dear ImGui GUI + editors are the next cycle (F2).
#include "ai.hpp"
#include "founding_fathers.hpp"
#include "economy.hpp"
#include "market.hpp"
#include "ref.hpp"
#include "datacheck.hpp"
#include "engine.hpp"
#include "formulas.hpp"
#include "game.hpp"
#include "httpd.hpp"
#include "inspect.hpp"
#include "json.hpp"
#include "mapedit.hpp"
#include "mod.hpp"
#include "rules.hpp"
#include "rules_invariants.hpp"
#include "rules_json.hpp"
#include "scoring.hpp"
#include "savegame.hpp"
#include "drydock_bridge.hpp"
#include "drydock_api.hpp"
#include "explore.hpp"
#include "natives.hpp"
#include "store.hpp"
#include "training.hpp"
#include "turnpipe.hpp"
#include "native_powers.hpp"
#include "mapgen.hpp"
#include "types.hpp"
#include "unit_turn.hpp"
#include "web_ui.hpp"

#include <algorithm>
#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <map>
#include <random>
#include <string>
#include <vector>
#include "session.hpp"

using namespace vc::sim;

forge::JsonValue jbool(bool b) { forge::JsonValue v; v.type = forge::JsonValue::Bool; v.b = b; return v; }
forge::JsonValue jarr() { forge::JsonValue v; v.type = forge::JsonValue::Array; return v; }
forge::JsonValue jobj() { forge::JsonValue v; v.type = forge::JsonValue::Object; return v; }
forge::JsonValue jstrs(const std::vector<std::string>& xs) {
    forge::JsonValue a = jarr();
    for (const auto& s : xs) a.arr.push_back(forge::json_str(s));
    return a;
}
forge::JsonValue jstr(const std::string& s) { return forge::json_str(s); }

// ---- in-browser playable game: the engine loop over the real sim ----

GameState g_game;
World     g_world;
std::vector<std::pair<int,int>> g_colony_xy;   // colony map positions (Forge-side)
forge::EngineExtra g_engine_extra;             // relational state the action nodes touch
bool g_game_active = false;
int  g_end_year = 1800;                        // retirement year (scenario end_year)

// The active (possibly modded) ruleset the Play game + engine VM run on. Persisted as a
// sparse overlay on disk; edits in the Rules editor are saved here and bite the sim.
const char* ACTIVE_RULES_PATH = "data_extracted/engine/rules.json";
RuleData g_active_rules = make_default_rules();

static int g_rng = 0x2BAD1234;
int game_rng(int lo, int hi) {                  // deterministic LCG in [lo,hi]
    g_rng = g_rng * 1103515245 + 12345;
    unsigned v = ((unsigned)g_rng >> 16) & 0x7FFF;
    return hi <= lo ? lo : lo + (int)(v % (unsigned)(hi - lo + 1));
}

bool game_is_water(int id) { return id == 25 || id == 26; }

// Nearest land (non-water) tile to (tx,ty) by expanding-ring scan.
static std::pair<int,int> game_find_land(int tx, int ty) {
    for (int r = 0; r < 220; ++r)
        for (int dy = -r; dy <= r; ++dy)
            for (int dx = -r; dx <= r; ++dx) {
                int x = tx + dx, y = ty + dy, id = g_world.terrain_id(x, y);
                if (id >= 0 && !game_is_water(id)) return {x, y};
            }
    return {tx, ty};
}
// Nearest water tile to (tx,ty) -- where the starting ship sits. -1,-1 if the map has none.
static std::pair<int,int> game_find_water(int tx, int ty) {
    for (int r = 0; r < 40; ++r)
        for (int dy = -r; dy <= r; ++dy)
            for (int dx = -r; dx <= r; ++dx) {
                int x = tx + dx, y = ty + dy, id = g_world.terrain_id(x, y);
                if (id >= 0 && game_is_water(id)) return {x, y};
            }
    return {-1, -1};
}

// Resolve a scenario unit-type name ("Soldiers","Caravel",...) to its type id via the
// @UNIT reference table (row index == type id), so the scenario is authored by name.
static int scenario_unit_type(const std::string& name) {
    static forge::JsonValue names; static bool loaded = false;
    if (!loaded) { loaded = true;
        try { names = forge::json_parse_file("data_extracted/tables/names_tables.json"); } catch (...) {} }
    const forge::JsonValue* sec = names.find("@UNIT"); if (!sec) return -1;
    const forge::JsonValue* rows = sec->find("rows"); if (!rows) return -1;
    for (size_t i = 0; i < rows->arr.size(); ++i) {
        const forge::JsonValue* nm = rows->arr[i].find("name");
        if (nm && nm->str == name) return (int)i;
    }
    return -1;
}

// Seed the native settlements as first-class entities: one village per (map_x,map_y) in each
// active tribe's @<TRIBE> position table (tribe_tables.json), sized by its civilization @TRIBES
// level, the first per tribe flagged Capital. Replaces the phantom global tension scalar.
static void seed_native_settlements() {
    g_engine_extra.settlements.clear();
    g_engine_extra.braves.clear();
    static const char* TRIBE_TBL[8] = {"@INCA","@AZTEC","@ARAWAK","@IROQUOIS","@CHEROKEE","@APACHE","@SIOUX","@TUPI"};
    static const int TRIBE_LEVEL[8] = {3, 2, 1, 1, 1, 0, 0, 0};
    forge::JsonValue tribes;
    try { tribes = forge::json_parse_file("data_extracted/tables/tribe_tables.json"); } catch (...) { return; }
    auto asi = [](const forge::JsonValue* v) { return v ? (v->type == forge::JsonValue::String ? std::atoi(v->str.c_str()) : (int)v->num) : 0; };
    for (int t = 0; t < 8; ++t) {
        const forge::JsonValue* sec = tribes.find(TRIBE_TBL[t]); if (!sec) continue;
        const forge::JsonValue* rows = sec->find("rows"); if (!rows) continue;
        bool first = true;
        for (const forge::JsonValue& r : rows->arr) {
            const forge::JsonValue* mx = r.find("map_x"); const forge::JsonValue* my = r.find("map_y");
            if (!mx || !my) continue;
            forge::NativeSettlement s;
            s.tribe = t; s.x = asi(mx); s.y = asi(my);
            s.population = TRIBE_LEVEL[t] * 2 + 3;      // size scales with civilization level
            s.wealth = TRIBE_LEVEL[t] * 20 + 10;
            s.capital = first; first = false;           // first settlement of each tribe = its Capital
            // The skill this village can teach (training.md 3). The per-village assignment
            // driver is RECONSTRUCTED: cycled deterministically over the learnable list.
            static const int LEARNABLE[8] = {0, 1, 2, 3, 4, 7, 8, 22};
            s.skill = LEARNABLE[(t + (int)g_engine_extra.settlements.size()) % 8];
            // Per-power alarm seed at init (func_065D26 @0x65DA6: random_int(0,14);
            // @0x65DC7: +2*difficulty iff the human power; saturate 20).
            for (int p = 0; p < 4; ++p) {
                int seed = game_rng(0, 14) + (p == 0 ? 2 * g_game.difficulty : 0);
                s.alarm[p] = seed > 20 ? 20 : seed;
            }
            // The good the village "badly needs" (@CHIEFHOWDY %STRING1) --
            // assignment driver RECONSTRUCTED: random tradable good 1..15.
            s.wanted = game_rng(1, 15);
            g_engine_extra.settlements.push_back(s);
            // field the village's wanderers: 1 brave, 2 for larger villages
            // (count driver RECONSTRUCTED; natives.md gives the villages a
            // raid budget, not a standing roster)
            const int nb = 1 + (s.population >= 6 ? 1 : 0);
            for (int bi = 0; bi < nb; ++bi)
                g_engine_extra.braves.push_back(
                    forge::NativeBrave{s.x, s.y, (int)g_engine_extra.settlements.size() - 1, t});
        }
    }
}

// Start a new game, seeded from the chosen nation + difficulty and the authored
// scenario (data_extracted/engine/scenarios/new_world.json). The scenario supplies
// the map, calendar, starting gold, colonies and units; nation/difficulty come from
// the new-game screen. Falls back to the classic 2-colony opening if the file is absent.
void game_new(int nation, int difficulty, bool random_map,
                     int p_land, int p_cont, int p_temp, int p_clim) {
    g_game = GameState{}; g_world = World{}; g_colony_xy.clear();
    // Seed the live game from entropy so real play differs each time (fidelity backlog #14).
    // Tests/selftests inject their own deterministic rng, so they are unaffected; the sandbox
    // keeps its fixed seed for reproducible experimentation.
    std::random_device rdv;
    g_engine_extra = forge::EngineExtra{}; g_rng = (int)(rdv() ^ 0x2BAD1234u);

    forge::JsonValue sc;
    if (!forge::drydock_scenario_json("new_world", sc))   // store-authoritative when loaded
        try { sc = forge::json_parse_file("data_extracted/engine/scenarios/new_world.json"); } catch (...) {}
    auto scn = [&](const char* k) -> const forge::JsonValue* {
        return sc.type == forge::JsonValue::Object ? sc.find(k) : nullptr; };

    vc::sim::MapStart gen_starts[4]; bool have_gen_starts = false;
    if (random_map) {
        // Random continental map (func_064A10, map_generation.md): P0..P6 with
        // the Customize enums; the ship anchorages come from the P6 bands.
        vc::sim::MapGenParams mp; mp.land = p_land; mp.landform = p_cont;
        mp.temperature = p_temp; mp.climate = p_clim;
        vc::sim::generate_map(g_world, mp, game_rng, gen_starts);
        have_gen_starts = true;
    } else {
        std::string mapfile = "data_extracted/map/AMER2.MP";
        if (const forge::JsonValue* m = scn("map")) mapfile = "data_extracted/map/" + m->str;
        try { forge::MpFile m = forge::load_mp(mapfile);
            g_world.map_w = m.w; g_world.map_h = m.h; g_world.terrain = m.terrain;
        } catch (...) { g_world.map_w = g_world.map_h = 0; }
    }

    g_game.difficulty = difficulty < 0 ? 0 : difficulty > 4 ? 4 : difficulty;
    g_game.nation     = nation < 0 ? 0 : nation > 3 ? 3 : nation;
    g_game.year   = scn("year")   ? (int)scn("year")->num   : 1492;
    g_game.season = scn("season") ? (int)scn("season")->num : 0;
    g_game.turn   = 0;
    g_end_year    = scn("end_year") ? (int)scn("end_year")->num : 1800;
    g_game.powers[0].gold = scn("start_gold") ? (long)scn("start_gold")->num : 500;
    // price_base = the internal supply accumulator (DGROUP 0x53EA), random-seeded per good in
    // [600,1000] (func_07561C, BYTE_VERIFIED market.md). It drives the drift; it is NOT the gold
    // price -- the player-facing buy/sell gold per unit comes from @CARGO (price_start1/2, ~1..20).
    for (int i = 0; i < NGOODS; ++i) g_game.price_base[i] = game_rng(600, 1000);
    // Published price levels: seed in [@CARGO start1, start2], clamp to the drift band, then one
    // recompute so the pooled goods start on-model (market.hpp; init RECONSTRUCTED).
    vc::sim::market_init(g_game, game_rng, g_active_rules);
    g_game.ref = ref_start(g_game.difficulty);          // the King starts with an army

    std::vector<std::pair<int,int>> cxy;                // colony coords, indexed as authored
    const int rdx[8] = {-1, 0, 1, -1, 1, -1, 0, 1};     // surrounding ring: 0=NW..7=SE
    const int rdy[8] = {-1,-1,-1,  0, 0,  1, 1, 1};
    // Seed one colony from its scenario record: built buildings + a colonist roster. A tile
    // worker's terrain is DERIVED from the map at its ring tile, so yields reflect the real map.
    auto add_colony_json = [&](const forge::JsonValue& cj) {
        auto gi = [&](const char* k, int d) { const forge::JsonValue* v = cj.find(k); return v ? (int)v->num : d; };
        auto xy = game_find_land(gi("x", 20), gi("y", 22));
        Colony c; c.owner_power = 0; c.human = true; c.rebel_A = 0; c.rebel_B = 200; c.build_target = -1;   // founding B=200/A=0 (colony.md 2, RUNTIME-CONFIRMED)
        c.x = xy.first; c.y = xy.second;                // ColonyRecord +0/+1 map position
        c.center_food = gi("center_food", 3);           // authored fallback for the town-square auto-food
        { int t = g_world.terrain_id(xy.first, xy.second); c.center_terrain = t < 0 ? 0 : (t & 0x1F); }
        if (const forge::JsonValue* bs = cj.find("buildings"))
            for (const forge::JsonValue& b : bs->arr) { int id = (int)b.num; if (id >= 0 && id < 48) c.built_mask |= (1ull << id); }
        if (const forge::JsonValue* ws = cj.find("workers"))
            for (const forge::JsonValue& w : ws->arr) {
                Colony::Worker wk;
                wk.profession = w.find("profession") ? (int)w.find("profession")->num : 19;
                wk.tile = w.find("tile") ? (int)w.find("tile")->num : -1;
                wk.good = w.find("good") ? (int)w.find("good")->num : 0;
                const forge::JsonValue* ev = w.find("expert");
                wk.expert = ev ? (ev->type == forge::JsonValue::Bool ? ev->b : ev->num != 0) : false;
                if (const forge::JsonValue* tv = w.find("terrain")) {
                    wk.terrain = (int)tv->num;              // authored terrain (deterministic yield)
                } else if (wk.tile >= 0 && wk.tile < 8) {   // else derive from the map at the ring tile
                    int tid = g_world.terrain_id(xy.first + rdx[wk.tile], xy.second + rdy[wk.tile]);
                    wk.terrain = tid < 0 ? 2 : (tid & 0x1F);
                } else wk.terrain = 0;                       // building worker (hammers/bells/crosses)
                c.workers.push_back(wk);
            }
        c.population = gi("pop", (int)c.workers.size()); if (c.population < 1) c.population = 1;
        forge::colony_compute_production(c, g_game.difficulty, g_active_rules, g_engine_extra.ff_owned,
                                     0, &g_world, g_game.rumor_seed);   // populate turn-0 output
        g_world.colonies.push_back(c); g_colony_xy.push_back(xy); cxy.push_back(xy);
        return xy;
    };
    if (!random_map)
    if (const forge::JsonValue* cols = scn("colonies"))
        for (const forge::JsonValue& c : cols->arr) add_colony_json(c);
    if (g_world.colonies.empty() && !random_map) {      // fallback: two colonies with a Farmer each
                                                        // (a random map starts at sea, colony-less)
        const char* fb = R"([{"x":20,"y":22,"buildings":[13,27],"workers":[
            {"profession":0,"good":0,"tile":0},{"profession":13,"good":16,"tile":-1}]},
            {"x":34,"y":42,"buildings":[13],"workers":[{"profession":0,"good":0,"tile":0}]}])";
        forge::JsonValue fbj = forge::json_parse(fb);
        for (const forge::JsonValue& c : fbj.arr) add_colony_json(c);
    }

    auto add_unit = [&](int type, int x, int y, int order = 0, int txx = -1, int tyy = -1,
                        int owner = 0) {
        Unit u; u.type = type; u.owner = owner; u.x = x; u.y = y;
        u.order = order; u.target_x = txx; u.target_y = tyy; u.alive = true;
        g_world.units.push_back(u);
    };
    const int dx8[8] = {1,-1,0,0,1,1,-1,-1}, dy8[8] = {0,0,1,-1,1,-1,1,-1};
    if (random_map && have_gen_starts) {
        // The classic opening loadout (func_0755CC @0x07584B..0x0758F5, all
        // BYTE-VERIFIED): per power a Caravel (Dutch power 3: Merchantman) at
        // the P6 anchorage with Pioneers (French power 1: class 0x14 Pioneer)
        // and Soldiers (Spanish power 2: class 0x15) aboard -- modeled as the
        // colonists standing on the anchorage; at difficulty <= 1 the human
        // runs the placement TWICE (the easy-mode double-units handicap).
        for (int pw = 0; pw < 4; ++pw) {
            const int passes = (pw == 0 && g_game.difficulty <= 1) ? 2 : 1;
            for (int pass = 0; pass < passes; ++pass) {
                const int sx = gen_starts[pw].x, sy = gen_starts[pw].y;
                add_unit(pw == 3 ? MERCHANTMAN : CARAVEL, sx, sy, 0, -1, -1, pw);
                add_unit(PIONEERS, sx, sy, 0, -1, -1, pw);
                g_world.units.back().profession = pw == 1 ? 0x14 : 0x13;
                add_unit(SOLDIERS, sx, sy, 0, -1, -1, pw);
                g_world.units.back().profession = pw == 2 ? 0x15 : 0x13;
            }
        }
    } else
    if (const forge::JsonValue* us = scn("units"))
        for (const forge::JsonValue& u : us->arr) {
            const int owner = u.find("owner") ? u.find("owner")->as_int(0) : 0;
            int type = scenario_unit_type(u.find("type") ? u.find("type")->str : "Colonists");
            if (type < 0) type = COLONISTS;
            if (u.find("x") && u.find("y")) {           // absolute placement (rival landfalls)
                add_unit(type, u.find("x")->as_int(0), u.find("y")->as_int(0), 0, -1, -1, owner);
                continue;
            }
            int ci = u.find("at_colony") ? (int)u.find("at_colony")->num : 0;
            if (ci < 0 || ci >= (int)cxy.size()) ci = 0;
            std::pair<int,int> base = cxy.empty() ? std::make_pair(20, 22) : cxy[ci];
            if (u.find("on_water_adjacent")) {          // a ship: adjacent water, else nearest water
                bool placed = false;
                for (int k = 0; k < 8 && !placed; ++k) { int x = base.first + dx8[k], y = base.second + dy8[k];
                    if (game_is_water(g_world.terrain_id(x, y))) { add_unit(type, x, y); placed = true; } }
                if (!placed) { auto wxy = game_find_water(base.first, base.second);
                    if (wxy.first >= 0) add_unit(type, wxy.first, wxy.second); }
            } else {
                int x = base.first + (u.find("dx") ? (int)u.find("dx")->num : 0);
                int y = base.second + (u.find("dy") ? (int)u.find("dy")->num : 0);
                if (const forge::JsonValue* g = u.find("goto_colony")) {
                    int gc = (int)g->num;               // marches toward that colony each turn
                    if (gc >= 0 && gc < (int)cxy.size()) add_unit(type, x, y, ORDER_GOTO, cxy[gc].first, cxy[gc].second);
                    else add_unit(type, x, y);
                } else add_unit(type, x, y);
            }
        }
    if (g_world.units.empty()) {                        // fallback opening force
        auto a = cxy.empty() ? std::make_pair(20, 22) : cxy[0];
        add_unit(SOLDIERS, a.first, a.second); add_unit(PIONEERS, a.first + 1, a.second);
    }
    seed_native_settlements();                          // real native villages on the map
    // Lost-City rumor presence is PROCEDURAL (events.md 6.1, func_006188): the map
    // generator seeds [0x190] with random_int(0,0x7fff) (@0x64A23) and the per-tile
    // coordinate hash decides the sites -- nothing is scattered or stored.
    g_game.rumor_seed = game_rng(0, 0x7fff);
    // Fog of war (exploration.md): the map starts hidden; the opening reveal is the
    // sight squares around the starting units + the +/-5 blocks around the colonies.
    if (g_world.map_w > 0 && g_world.map_h > 0) {
        g_world.fog.assign((size_t)g_world.map_w * g_world.map_h, 0);
        vc::sim::reveal_step(g_world, g_engine_extra.ff_owned);
    }
    g_game_active = true;
}

// Per-turn history (A4): a time series snapshotted each turn -> the history charts.
// HistPoint lives in session.hpp
std::vector<HistPoint> g_history;
void history_snapshot() {
    long pop = 0; for (const auto& c : g_world.colonies) pop += c.population;
    g_history.push_back(HistPoint{(long)g_game.turn, g_game.year,
        (long)g_game.powers[0].gold, g_engine_extra.national_sol, pop});
    if (g_history.size() > 400) g_history.erase(g_history.begin());
}

// Native braves roam near their home village (one land step per turn, pulled
// back inside radius 3 -- the roam step is RECONSTRUCTED presentation of the
// village's activity; raids/tension remain settlement-driven, natives.md).
static void native_braves_step() {
    for (forge::NativeBrave& b : g_engine_extra.braves) {
        if (b.home < 0 || b.home >= (int)g_engine_extra.settlements.size()) continue;
        const forge::NativeSettlement& h = g_engine_extra.settlements[b.home];
        int dx = game_rng(-1, 1), dy = game_rng(-1, 1);
        if (std::abs(b.x + dx - h.x) > 3) dx = h.x > b.x ? 1 : (h.x < b.x ? -1 : 0);
        if (std::abs(b.y + dy - h.y) > 3) dy = h.y > b.y ? 1 : (h.y < b.y ? -1 : 0);
        const int nx = b.x + dx, ny = b.y + dy;
        const int t = g_world.terrain_id(nx, ny);
        if (t >= 0 && !game_is_water(t)) { b.x = nx; b.y = ny; }
    }
}

// Turn notices: late-game turn-loop events (Spanish Succession, Tory uprisings) surface here so
// the /api/game/turn route can present them to the player alongside the OnTurnStart event graphs.
std::vector<std::string> g_turn_notices;

// ---- In-game tutorial (spec/systems/tutorial.md) ----------------------------
// Event-driven, idempotent lessons: each @TUTORIALn owns one bit of the 16-bit
// step-shown mask [0x5386]/[0x5387] (EngineExtra.tutorial_mask, new-game init
// 0x000E @0x755EB) and fires ONCE when its event first occurs (test bit; emit;
// set bit). Only the byte-mapped steps are wired (tutorial.md 3 table); the
// unmapped bits stay dormant rather than invented. The queue drains through
// GET /api/tutorial; the client shows each as a wood-frame popup.
std::vector<std::pair<std::string, std::string>> g_tutorial_queue;
std::string game_message_text(const std::string& key);           // below
const std::vector<std::string>& labels_section(const char* s); // below
bool save_game_to(const std::string& path);                      // below (after dump_extra)
static void tutorial_emit(const std::string& key,
                          const std::vector<std::string>& s,
                          const std::vector<long>& n) {
    std::string text = game_message_text(key);           // verbatim GAME.TXT prose
    if (text == key) return;                             // record missing: stay silent
    for (size_t i = 0; i < s.size(); ++i) {
        const std::string ph = "%STRING" + std::to_string(i);
        size_t p; while ((p = text.find(ph)) != std::string::npos) text.replace(p, ph.size(), s[i]);
    }
    for (size_t i = 0; i < n.size(); ++i) {
        const std::string ph = "%NUMBER" + std::to_string(i);
        size_t p; while ((p = text.find(ph)) != std::string::npos) text.replace(p, ph.size(), std::to_string(n[i]));
    }
    g_tutorial_queue.emplace_back(key, text);
}
static bool tutorial_on() { return (g_engine_extra.game_options >> 7) & 1; }   // ~Tutorial Hints
void tutorial_fire(uint16_t bit, const std::string& key,
                          const std::vector<std::string>& s,
                          const std::vector<long>& n) {
    if (!tutorial_on()) return;
    if (g_engine_extra.tutorial_mask & bit) return;      // already shown
    g_engine_extra.tutorial_mask |= bit;
    tutorial_emit(key, s, n);
}
void tutorial_fire2(uint8_t bit, const std::string& key,   // the [0x5380] mask
                           const std::vector<std::string>& s,
                           const std::vector<long>& n) {
    if (!tutorial_on()) return;
    if (g_engine_extra.tutorial_mask2 & bit) return;
    g_engine_extra.tutorial_mask2 |= bit;
    tutorial_emit(key, s, n);
}
void tutorial_fire_x(uint8_t bit, const std::string& key,  // stepless (engine latch)
                            const std::vector<std::string>& s,
                            const std::vector<long>& n) {
    if (!tutorial_on()) return;
    if (g_engine_extra.tutorial_extra & bit) return;
    g_engine_extra.tutorial_extra |= bit;
    tutorial_emit(key, s, n);
}
// The colony display name (the NAMES colony-name pool by index, as the colony
// screen titles it).
static std::string tutorial_colony_name(int ci) {
    static const char* kPool[4] = {"ENGLISH", "FRENCH", "SPANISH", "DUTCH"};
    std::string name = "Colony " + std::to_string(ci + 1);
    const auto& pool = labels_section(kPool[g_game.nation & 3]);
    if (ci < (int)pool.size() && !pool[ci].empty()) {
        name = pool[ci];
        size_t comma = name.find(','); if (comma != std::string::npos) name.resize(comma);
    }
    return name;
}
std::string tutorial_home_port() {                // @HOMEPORT[nation] (NAMES)
    forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
    std::string p = forge::resolve_binding("@HOMEPORT[" + std::to_string(g_game.nation & 3) + "].name", cx).str;
    return p.empty() ? "Europe" : p;
}
// The per-turn tutorial checks (T5/T6/T7 sites, run after the turn pipeline).
static void tutorial_turn_checks() {
    // T5 ([0x5387]&0x01, market/king phase func_033F6A @0x3651F): immigrants
    // are waiting on the docks in Europe.
    if (!(g_engine_extra.tutorial_mask & 0x0100) && g_game.powers[0].dock_pool[0] >= 0)
        tutorial_fire(0x0100, "@TUTORIAL5",
                      {tutorial_home_port(), forge::job_name(g_game.powers[0].dock_pool[0], false)});
    // T6 ([0x5387]&0x02, colony processor func_02D658 @0x2EA4C): a colony has
    // stockpiled cargo a ship could carry to Europe.
    if (!(g_engine_extra.tutorial_mask & 0x0200))
        for (size_t ci = 0; ci < g_world.colonies.size(); ++ci) {
            const Colony& c = g_world.colonies[ci];
            if (c.owner_power != 0) continue;
            for (int gd = 1; gd < vc::sim::NGOODS && !(g_engine_extra.tutorial_mask & 0x0200); ++gd)
                if (c.stockpile[gd] > 0) {
                    forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
                    tutorial_fire(0x0200, "@TUTORIAL6",
                                  {forge::resolve_binding("@CARGO[" + std::to_string(gd) + "].name", cx).str,
                                   tutorial_colony_name((int)ci), tutorial_home_port()},
                                  {c.stockpile[gd]});
                }
            if (g_engine_extra.tutorial_mask & 0x0200) break;
        }
    // T7 ([0x5387]&0x04): a colony is growing -- suggest the Stockade once the
    // @BUILDING population gate (min_colony 3) is reachable and it isn't built.
    if (!(g_engine_extra.tutorial_mask & 0x0400))
        for (size_t ci = 0; ci < g_world.colonies.size(); ++ci) {
            const Colony& c = g_world.colonies[ci];
            if (c.owner_power != 0 || c.population < 3 || (c.built_mask & 1ull)) continue;
            tutorial_fire(0x0400, "@TUTORIAL7", {tutorial_colony_name((int)ci)});
            break;
        }
    // ---- The per-unit lessons (the func_020F50 move/land dispatcher family;
    // sites/bits byte-cited in tutorial.md 3, trigger predicates over our
    // engine's equivalents -- the EXE tile predicates 0x181F:0x768/0x7BE are
    // not fully decoded, so the spatial conditions are RECONSTRUCTED).
    if (!tutorial_on()) return;
    for (const Unit& u : g_world.units) {
        if (!u.alive || u.owner != 0) continue;
        const bool naval = unit_stats(u.type).move_class == 99;
        if (naval) {
            // T11 ([0x5387]&0x40 @0x21004): the early ship-value lesson.
            if (!(g_engine_extra.tutorial_mask & 0x4000)) {
                const char* nm = unit_stats(u.type).name;
                tutorial_fire(0x4000, "@TUTORIAL11", {nm ? nm : "ship", tutorial_home_port()});
            }
            // T2 (event flag [0x5382]&0x80 @0x20F3A, no shown-bit): land sighted.
            if (!(g_engine_extra.tutorial_extra & 1)) {
                static const int dx8[8] = {1,-1,0,0,1,1,-1,-1}, dy8[8] = {0,0,1,-1,1,-1,1,-1};
                for (int k = 0; k < 8; ++k) {
                    int t = g_world.terrain_id(u.x + dx8[k], u.y + dy8[k]);
                    if (t >= 0 && !game_is_water(t)) { tutorial_fire_x(1, "@TUTORIAL2"); break; }
                }
            }
            continue;
        }
        const int tid = g_world.terrain_id(u.x, u.y);
        if (tid < 0 || game_is_water(tid)) continue;
        // T13/T14 ([0x5380]&0x01/0x02): the arrival lessons, gated turn < 0x14
        // (cmp [0x538E],0x14 @0x21089/@0x210D3, byte-cited).
        if (g_game.turn < 0x14) {
            if (u.type == PIONEERS) tutorial_fire2(0x01, "@TUTORIAL13");
            if (u.type == SOLDIERS) tutorial_fire2(0x02, "@TUTORIAL14");
        }
        if (u.type == PIONEERS) {
            bool on_colony = false;
            for (const auto& c : g_world.colonies)
                if (c.x == u.x && c.y == u.y) { on_colony = true; break; }
            // T3 ([0x5386]&0x40): a good first-colony site; %STRING0 = the
            // tile's most abundant raw good.
            if (!(g_engine_extra.tutorial_mask & 0x0040) && !on_colony &&
                vc::sim::colony_site_value(g_world, g_active_rules, u.x, u.y, g_game.rumor_seed) > 0) {
                int best = 0, bv = -1;
                for (int gd = 0; gd < 8; ++gd) {
                    int yv = forge::terrain_good_yield(tid, gd);
                    if (yv > bv) { bv = yv; best = gd; }
                }
                forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
                tutorial_fire(0x0040, "@TUTORIAL3",
                    {forge::resolve_binding("@CARGO[" + std::to_string(best) + "].name", cx).str});
            }
            // T9 ([0x5387]&0x10): a road-worthy square (no road yet).
            if (!(g_engine_extra.tutorial_mask & 0x1000) && !(g_world.improve_at(u.x, u.y) & 0x08))
                tutorial_fire(0x1000, "@TUTORIAL9");
            // T10 ([0x5387]&0x20): a plow/clear-worthy square (forested, or unplowed).
            if (!(g_engine_extra.tutorial_mask & 0x2000) &&
                ((tid >= 8 && tid <= 23) || !(g_world.improve_at(u.x, u.y) & 0x40)))
                tutorial_fire(0x2000, "@TUTORIAL10");
        }
        if (u.type == COLONISTS) {
            // T15 ([0x5380]&0x08): a Colonists unit standing in an own colony.
            if (!(g_engine_extra.tutorial_mask2 & 0x08))
                for (size_t ci = 0; ci < g_world.colonies.size(); ++ci) {
                    const Colony& c = g_world.colonies[ci];
                    if (c.x != u.x || c.y != u.y || c.owner_power != 0) continue;
                    tutorial_fire2(0x08, "@TUTORIAL15", {tutorial_colony_name((int)ci)});
                    break;
                }
            // T8 ([0x5387]&0x08): a no-specialty colonist beside a native village.
            if (!(g_engine_extra.tutorial_mask & 0x0800) && u.profession == 0x13)
                for (const forge::NativeSettlement& s : g_engine_extra.settlements)
                    if (std::abs(s.x - u.x) <= 1 && std::abs(s.y - u.y) <= 1) {
                        tutorial_fire(0x0800, "@TUTORIAL8",
                                      {forge::job_name(u.profession, false)});
                        break;
                    }
            // T19 ([0x5380]&0x80): a native Convert (profession 0x1B @0x215E6).
            if (u.profession == 0x1B) tutorial_fire2(0x80, "@TUTORIAL19");
        }
    }
}

// Tory-militia land strength: Crown-loyalist land units (owner != rebel power 0) that arm during
// the War of Independence and fight ALONGSIDE the King's expeditionary force against the rebels.
static long tory_militia_strength() {
    long str = 0;
    for (const Unit& u : g_world.units) {
        if (!u.alive || u.owner == 0) continue;         // rebel = power 0; loyalist militia are the rest
        const UnitStats& st = unit_stats(u.type);
        if (st.move_class == 99) continue;              // ships hold no ground
        str += st.attack + st.defense;
    }
    return str;
}

// Rebel land strength: player land-combat units (attack+defense) + a per-colony defensive bump.
static long rebel_strength(int* weakest_unit = nullptr) {
    long str = 0; int weakest = -1; long weakest_str = 0;
    for (int i = 0; i < (int)g_world.units.size(); ++i) {
        const Unit& u = g_world.units[i];
        if (!u.alive || u.owner != 0) continue;
        const UnitStats& st = unit_stats(u.type);
        if (st.move_class == 99) continue;              // ships hold no ground
        long s = st.attack + st.defense; if (s <= 0) continue;
        str += s; if (weakest < 0 || s < weakest_str) { weakest = i; weakest_str = s; }
    }
    str += (long)g_world.colonies.size() * 2;           // colonies contribute walls/militia
    if (weakest_unit) *weakest_unit = weakest;
    return str;
}
static long ref_land_strength() {                       // Man-o-War is naval, weighted low for land assault
    return (long)g_game.ref.regulars * 4 + g_game.ref.cavalry * 5 + g_game.ref.artillery * 7 + g_game.ref.manowar;
}
// War of Independence, resolved per turn while declared: one engagement between the rebel army and
// the King's expeditionary force. Rebels win -> REF attrition; REF wins -> a rebel unit falls, or a
// colony is captured if undefended. The endgame fires when the REF is destroyed (win) or the last
// colony is lost (lose). Abstract strength model (RECONSTRUCTED; the real WoI runs unit-level battles).
void war_resolution_step() {
    if (!g_engine_extra.woi_declared) return;
    // Victory check (revolution.md @0x2F4D2..0x2F4E5): the surviving-REF tally
    // counts the COMBATANT types (Regulars/Cavalry/Artillery -- the Man-O-War
    // is transport); rebels win when it falls below 1 (or 8 under the
    // harder-end flag [0x5382]&0x40, not modeled) with no intervention force.
    const int surviving = g_game.ref.regulars + g_game.ref.cavalry + g_game.ref.artillery;
    if (vc::sim::ref_war_won(surviving, /*intervention*/0, /*hard*/false)) return;
    long ref_total = g_game.ref.regulars + g_game.ref.cavalry + g_game.ref.manowar + g_game.ref.artillery;
    if (ref_total <= 0 || g_world.colonies.empty()) return;   // already decided; endgame_json reports it
    int weakest = -1; long reb = rebel_strength(&weakest);
    long king = ref_land_strength() + tory_militia_strength();   // REF + any risen Tory militia
    long total = reb + king; if (total <= 0) return;
    if (game_rng(1, (int)total) <= reb) {               // rebels repel the assault -> REF attrition
        int loss = game_rng(1, 4);
        for (int k = 0; k < loss; ++k) {
            if (g_game.ref.regulars > 0) --g_game.ref.regulars;
            else if (g_game.ref.cavalry > 0) --g_game.ref.cavalry;
            else if (g_game.ref.artillery > 0) --g_game.ref.artillery;
            else if (g_game.ref.manowar > 0) --g_game.ref.manowar;
        }
    } else {                                            // REF prevails: destroy a rebel unit, else take a colony
        if (weakest >= 0) g_world.units[weakest].alive = false;
        else { g_world.colonies.pop_back(); if (!g_colony_xy.empty()) g_colony_xy.pop_back(); }
    }
}

std::string game_message_text(const std::string& key);   // defined below

// Coastal test for the ColonyRecord +0x1C & 0x40 flag consumers (mercenary.md pins
// the bit as "coastal"): any Ocean(25)/Sea Lane(26) tile in the 8-neighborhood.
static bool colony_coastal(int x, int y) {
    for (int dy = -1; dy <= 1; ++dy) for (int dx = -1; dx <= 1; ++dx) {
        if (!dx && !dy) continue;
        int nx = x + dx, ny = y + dy;
        if (nx < 0 || ny < 0 || nx >= g_world.map_w || ny >= g_world.map_h) continue;
        int t = g_world.terrain[(size_t)ny * g_world.map_w + nx] & 0x1F;
        if (t == 25 || t == 26) return true;
    }
    return false;
}

// Foreign intervention (spec/systems/{revolution,tory_uprising,mercenary}.md).
// DECLARATION (func_03D948, one-time, no roll): fires from the end-game dispatcher
// once the WoI is declared, the national SoL meter is >= 75 ([0x53D0], the @0x2391C
// high-meter branch), and the intervention bit ([0x5382] bit 1) is clear. The ally
// is the owner of the strongest eligible foreign colony (coastal +0x1C & 0x40, max
// population +0x1F); emits the verbatim @INTERVENTION and sets the bit (@0x3DA22).
// ARRIVALS (func_03D510, the shared force-landing, arg 0): per WoI turn while
// active, a population-weighted random pick among the rebel's coastal colonies
// (random_int(1, sum weights) @0x3D57E) lands a Man-O-War carrier plus a veteran
// (vet_type 0x15 @0x3D835) wartime-typed stack, emitting @INTERVENE (@0x3D7BB).
// The per-landing counts + total landings come from effects.json
// force_composition.intervention (RECONSTRUCTED; types/carrier/veteran/pick are B).
static void intervention_step() {
    forge::EngineExtra& x = g_engine_extra;
    if (!x.woi_declared) return;
    auto fill = [](std::string s, const char* tok, const std::string& v) {
        for (size_t q; (q = s.find(tok)) != std::string::npos; )
            s.replace(q, std::strlen(tok), v);
        return s;
    };
    if (!x.intervention_active) {
        if (x.national_sol < 75) return;                // the dispatcher's >= 75 gate
        int best = -1, bestpop = -1;                    // strongest coastal foreign colony
        for (const Colony& c : g_world.colonies) {
            if (c.owner_power == 0 || c.x < 0) continue;
            if (g_engine_extra.seceded_power == c.owner_power) continue;
            if (!colony_coastal(c.x, c.y)) continue;
            if (c.population > bestpop) { bestpop = c.population; best = c.owner_power; }
        }
        if (best < 0) return;                           // no eligible foreign ally yet
        x.intervention_active = true;                   // [0x5382] |= 2 (@0x3DA22)
        x.intervention_power = best;
        const int an = power_nation(g_game, best), rn = g_game.nation;
        forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
        auto tbl = [&](const char* t, int i) {
            return forge::resolve_binding(std::string(t) + "[" + std::to_string(i) + "].name", cx).str;
        };
        // Fill sources RECONSTRUCTED: %STRING0/%STRING1 = the ally / mother country
        // (@COUNTRY), %STRING2 = the ally's leader (@LEADERNAME), %STRING3 = the
        // rebel's largest colony, %STRING4 = the ally nationality (@NATIONALITY).
        int bigc = -1, bigp = -1;
        for (int i = 0; i < (int)g_world.colonies.size(); ++i)
            if (g_world.colonies[i].owner_power == 0 && g_world.colonies[i].population > bigp)
                { bigp = g_world.colonies[i].population; bigc = i; }
        std::string m = game_message_text("@INTERVENTION");
        m = fill(m, "%STRING0", tbl("@COUNTRY", an));
        m = fill(m, "%STRING1", tbl("@COUNTRY", rn));
        m = fill(m, "%STRING2", tbl("@LEADERNAME", an));
        m = fill(m, "%STRING3", bigc >= 0 ? "#" + std::to_string(bigc + 1) : "the colonies");
        m = fill(m, "%STRING4", tbl("@NATIONALITY", an));
        g_turn_notices.push_back(m);
        return;                                          // arrivals begin next turn
    }
    // Arrivals while active, up to the data cap.
    const forge::JsonValue* comp = forge::force_composition("intervention");
    if (!comp) return;
    int cap = comp->find("landings") ? comp->find("landings")->as_int(0) : 0;
    if (x.intervention_landings >= cap) return;
    long wsum = 0;                                       // pop-weighted coastal pick (@0x3D57E)
    std::vector<std::pair<int, long>> elig;              // (colony, weight)
    for (int i = 0; i < (int)g_world.colonies.size() && (int)elig.size() < 10; ++i) {
        const Colony& c = g_world.colonies[i];
        if (c.owner_power != 0 || c.x < 0 || !colony_coastal(c.x, c.y)) continue;
        elig.push_back({i, (long)c.population});
        wsum += c.population;
    }
    if (elig.empty() || wsum <= 0) return;
    long roll = game_rng(1, (int)wsum); int land = elig[0].first;
    for (const auto& e : elig) { roll -= e.second; if (roll <= 0) { land = e.first; break; } }
    const int lx = g_world.colonies[land].x, ly = g_world.colonies[land].y;
    if (const forge::JsonValue* carrier = comp->find("carrier")) {
        int cty = forge::unit_type_by_name(carrier->str);        // Man-O-War (@0x3D748)
        if (cty >= 0) { Unit u; u.type = cty; u.owner = 0; u.alive = true;
                        u.x = lx; u.y = ly; g_world.units.push_back(u); }
    }
    if (const forge::JsonValue* cats = comp->find("categories"))
        for (const forge::JsonValue& c : cats->arr) {
            const forge::JsonValue* uv = c.find("unit"); const forge::JsonValue* nv = c.find("count");
            if (!uv || !nv) continue;
            int ty = forge::unit_type_by_name(uv->str); if (ty < 0) continue;
            for (int k = 0; k < nv->as_int(0); ++k) {
                Unit u; u.type = ty; u.owner = 0; u.alive = true;
                u.profession = 0x15;                     // Veteran stamp (@0x3D835)
                u.x = lx; u.y = ly; g_world.units.push_back(u);
            }
        }
    ++x.intervention_landings;
    forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
    std::string adj = forge::resolve_binding(
        "@NATIONALITY[" + std::to_string(power_nation(g_game, x.intervention_power)) + "].name", cx).str;
    std::string m = game_message_text("@INTERVENE");
    m = fill(m, "%STRING0", "#" + std::to_string(land + 1));
    m = fill(m, "%STRING1", adj);
    g_turn_notices.push_back(m);
}

// Nation display name for a power slot (@NATIONALITY, falling back to @COUNTRY / "power N").
std::string nation_name(int p) {
    forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
    forge::JsonValue v = forge::resolve_binding("@NATIONALITY[" + std::to_string(p) + "].name", cx);
    if (v.is_string() && !v.str.empty()) return v.str;
    v = forge::resolve_binding("@COUNTRY[" + std::to_string(p) + "].name", cx);
    return (v.is_string() && !v.str.empty()) ? v.str : ("power " + std::to_string(p));
}

// Per-power strength score (spec/systems/spanish_succession.md §2): rank powers by
// 3*mil + 2*colony_count + 1*econ (colony_count is live; mil/econ are the editable proxy stats
// standing in for the undecoded 0x9418/0x9410 arrays).
static long power_score(int p) {
    long nc = 0; for (const auto& c : g_world.colonies) if (c.owner_power == p) ++nc;
    return 3L * g_engine_extra.power_mil[p] + 2L * nc + g_engine_extra.power_econ[p];
}

// War of the Spanish Succession (spec/systems/spanish_succession.md): a scripted historical event --
// the Treaty of Utrecht (1713) ends the European war and a war-ravaged rival cedes its New-World
// possessions to another power. Fires ONCE, pre-independence, single-player: the weakest eligible AI
// (powers 1..3) is removed and its colonies/units pass to the strongest surviving power; the removed
// power is thereafter "(Withdrawn from New World)". Deterministic year gate -- the byte-verified
// dispatcher reads no RNG (spec §3); the once-flag is seceded_power ([0x53D2]).
void spanish_succession_step() {
    if (g_engine_extra.seceded_power >= 0) return;      // already happened (once-flag [0x53D2] set)
    if (g_engine_extra.woi_declared) return;            // pre-revolution only ([0x5382] gate, spec §3)
    // The byte-verified dispatcher gates (func_0235D6 @0x02391C/@0x023930):
    // national SoL below 75 (cmp [0x53D0],0x4B) and no power seceded yet --
    // there is NO year check in the handler (the earlier 1713 gate was the
    // audit-corrected invention; the per-turn enqueue odds are runtime-only,
    // modeled as a 1-in-16 turn roll, RECONSTRUCTED).
    if (g_engine_extra.national_sol >= 75) return;
    if (game_rng(1, 16) != 1) return;
    int ceder = -1; long cw = 0;                        // weakest of the AI powers 1..3 cedes
    for (int p = 1; p < 4; ++p) { long s = power_score(p);
        if (ceder < 0 || s < cw) { cw = s; ceder = p; } }
    if (ceder < 0) return;
    int benef = -1; long bw = 0;                        // strongest of the remaining powers receives
    for (int p = 0; p < 4; ++p) { if (p == ceder) continue; long s = power_score(p);
        if (benef < 0 || s > bw) { bw = s; benef = p; } }
    if (benef < 0) return;
    int moved_c = 0, moved_u = 0;
    for (auto& c : g_world.colonies) if (c.owner_power == ceder) {
        c.owner_power = benef; ++moved_c;
        c.rebel_A = 0; c.rebel_B = 200;                 // rebel counters reset on transfer
    }                                                   //   (+0xC2/+0xC6 zeroed, audit brief)
    for (auto& u : g_world.units)    if (u.alive && u.owner == ceder) { u.owner = benef; ++moved_u; }
    g_engine_extra.seceded_power = ceder;               // now shown "(Withdrawn from New World)"
    g_turn_notices.push_back(
        "War of the Spanish Succession ends in Europe! " + nation_name(ceder) +
        ", ravaged by war, cedes its New World possessions to the " + nation_name(benef) +
        " (Treaty of Utrecht, " + std::to_string(g_game.year) + "; " +
        std::to_string(moved_c) + " colonies, " + std::to_string(moved_u) + " units transferred).");
}

// Tory uprising during the War of Independence (spec/systems/tory_uprising.md, func_03CAC6): each WoI
// turn, with probability (diff+1)/(diff+2), Crown-loyal colonists rise in the rebel colony with the
// highest Tory strength = pop*2*(100-SoL%)/100 + diff + 1, arming Tory Militia (Soldiers, some promoted
// to Dragoons) on the free tiles adjacent to it. Latched per colony so it can't re-fire; suppressed
// silently (no latch) if no adjacent tile is free.
void tory_uprising_step() {
    if (!g_engine_extra.woi_declared) return;
    int diff = g_game.difficulty;
    if (game_rng(0, diff + 1) == 0) return;             // per-call gate: fires with prob (diff+1)/(diff+2)
    int best = -1; long best_str = 0;                   // rebel colony with the highest tory strength
    for (int i = 0; i < (int)g_world.colonies.size(); ++i) {
        const Colony& c = g_world.colonies[i];
        if (c.owner_power != 0 || c.tory_risen) continue;
        int sol = c.rebel_B > 0 ? (int)((long)c.rebel_A * 100 / c.rebel_B) : g_engine_extra.national_sol;
        if (sol < 0) sol = 0; else if (sol > 100) sol = 100;
        long tstr = (long)c.population * 2 * (100 - sol) / 100 + diff + 1;
        if (best < 0 || tstr > best_str) { best_str = tstr; best = i; }
    }
    if (best < 0) return;                               // no eligible colony
    int cx0 = -1, cy0 = -1;
    if (best < (int)g_colony_xy.size()) { cx0 = g_colony_xy[best].first; cy0 = g_colony_xy[best].second; }
    if (cx0 < 0) return;
    static const int DX[8] = {-1, 0, 1, -1, 1, -1, 0, 1};
    static const int DY[8] = {-1, -1, -1, 0, 0, 1, 1, 1};
    long budget = best_str; int spawned = 0;
    for (int d = 0; d < 8 && budget > 0; ++d) {         // one militia per free adjacent tile, up to strength
        int nx = cx0 + DX[d], ny = cy0 + DY[d];
        int tid = g_world.terrain_id(nx, ny);
        if (tid < 0 || tid == 24 || tid == 25 || tid == 26) continue;   // OOB / Arctic / Ocean / Sea Lane
        bool occupied = false;
        for (const Unit& u : g_world.units) if (u.alive && u.x == nx && u.y == ny) { occupied = true; break; }
        if (occupied) continue;
        Unit m; m.owner = 1; m.x = nx; m.y = ny; m.alive = true;
        m.type = (game_rng(1, 100) <= 25) ? 4 : 1;      // random upgrade gate: Soldiers(1) -> Dragoons(4)
        m.moves_left = unit_stats(m.type).movement * 3;   // thirds (unit.md 3)
        g_world.units.push_back(m);
        ++spawned; --budget;
    }
    if (spawned == 0) return;                           // no free tile -> uprising suppressed (no latch)
    g_world.colonies[best].tory_risen = true;           // latch so this colony can't re-fire
    g_turn_notices.push_back(
        "Tory uprising near the colony at (" + std::to_string(cx0) + "," + std::to_string(cy0) +
        ")! Parliament arms " + std::to_string(spawned) + " Tory Militia against the rebellion.");
}

// ---- Europe market: the byte-verified supply/price-level model (spec/systems/market.md) --------
// The full model lives in sim/market.{hpp,cpp}: price_base = the hidden per-good supply level
// (seeded [600,1000]); power.trade (+0xFC) = the per-turn volume (SELL +=, BUY -=); the published
// price_level (+0x4C) derives from the pooled supply; bid = level-1, ask = bid + @CARGO.burden + 1
// (USER RULING). Selling is taxed and the tax funds the King's REF (royal_money). These wrappers
// read the LIVE @CARGO table (so Tables-tab edits bite) into the RuleData cargo block.
static int cargo_i(const forge::EngineCtx& cx, int g, const char* col, int dflt) {
    forge::JsonValue v = forge::resolve_binding("@CARGO[" + std::to_string(g) + "]." + col, cx);
    return v.type == forge::JsonValue::Null ? dflt : (int)v.as_int(dflt);
}
// The active ruleset with its cargo block refreshed from the live @CARGO bindings.
// STRANGLER CUTOVER (Drydock P1): once the record store is loaded, GOOD records
// are the market-knob authority -- g_active_rules is kept in lockstep by the
// /api/dd mutation path, so the legacy @CARGO binding re-read is skipped
// (editing @CARGO in the Tables tab no longer drives the market; the GOOD grid
// does). Without the store (no data/ dir) the legacy path still applies.
RuleData live_market_rules(const forge::EngineCtx& cx) {
    RuleData rd = g_active_rules;
    if (forge::drydock_active()) return rd;
    for (int g = 0; g < NGOODS; ++g) {
        const vc::sim::CargoStats& d = rd.cargo[g];   // canonical defaults as fallbacks
        rd.cargo[g].start1 = cargo_i(cx, g, "price_start1", d.start1);
        rd.cargo[g].start2 = cargo_i(cx, g, "price_start2", d.start2);
        rd.cargo[g].lo     = cargo_i(cx, g, "drift_low",    d.lo);
        rd.cargo[g].hi     = cargo_i(cx, g, "drift_high",   d.hi);
        rd.cargo[g].burden = cargo_i(cx, g, "burden",       d.burden);
    }
    return rd;
}

// Auto-export (USER RULING 2026-07-02): with a Custom House the player SELECTS which
// goods auto-sell (Colony.export_mask, toggled per stockpile cell); each SELECTED good
// sells everything over 50 each turn -- crediting the owner's gold at the SAME @CARGO
// market bid + tax the manual sell route uses (so auto-selling and hand-selling price
// identically), skipping boycotted goods and Food (which feeds growth). Unselected
// goods (and colonies without a Custom House) spoil above the warehouse cap. No Crown
// market during the rebellion (spec/systems/colony.md §3: independence gates it).
// This lives Forge-side (not in the pure sim pipeline) because the sale price is @CARGO table data.
void auto_export_step() {
    if (g_engine_extra.woi_declared) return;            // no European market while at war with the Crown
    forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
    long total = 0; int sold_from = 0, spoiled_from = 0;
    for (Colony& c : g_world.colonies) {
        int owner = c.owner_power; if (owner < 0 || owner >= 4) continue;
        bool custom_house = (c.built_mask >> 18) & 1ull;                  // building 18 = Custom House
        int cap = (c.warehouse_lvl + 1) * g_active_rules.cfg.warehouse_cap_base;   // 100 / 200 / 300
        bool spoiled = false;
        for (int gd = 1; gd < NGOODS; ++gd) {           // Food(0) is the growth store, never here
            const bool selected = custom_house && ((c.export_mask >> gd) & 1u);
            if (selected && c.stockpile[gd] > 50) {
                // Custom House sells the SELECTED good's surplus over 50 directly to
                // Europe -- no ship needed (Peter Stuyvesant).
                if ((g_game.powers[0].boycotts >> gd) & 1u) continue;     // boycotted -> can't sell (+0x20)
                int excess = c.stockpile[gd] - 50; c.stockpile[gd] = 50;  // keep 50, sell the rest
                // The one market path: taxed sale at the published bid; the tax funds the REF;
                // the volume floods the market and the published price re-derives immediately.
                RuleData mrd = live_market_rules(cx);
                total += vc::sim::market_sell(g_game, owner, gd, excess, mrd);
            } else if (c.stockpile[gd] > cap) {
                // Not auto-sold: goods above the warehouse cap SPOIL. To sell, ship them
                // to Europe (/api/europe/sell), or select the good on a Custom House.
                c.stockpile[gd] = cap; spoiled = true;
            }
        }
        if (custom_house && total > 0) ++sold_from;   // (approximate per-colony flag)
        if (spoiled) ++spoiled_from;
    }
    if (total > 0)
        g_turn_notices.push_back("Custom House: auto-sold colony surplus to Europe for " +
                                 std::to_string(total) + " gold.");
    if (spoiled_from > 0)
        g_turn_notices.push_back("Warehouse overflow: surplus goods spoiled in " + std::to_string(spoiled_from) +
                                 " colony(ies) -- build a Custom House (needs Peter Stuyvesant) or ship goods to Europe to sell them.");
}

// Continental Congress bell economy (defined with the sandbox helpers below; shared by both loops).
void congress_step(forge::EngineExtra& x, int diff, int year, int bells_this_turn,
                          std::function<int(int,int)> rng);
static void apply_ff_acquire(int id);
// The engine-coded upgrade ladders (func_07464C), loaded from
// effects.json/building_chains: prereq = the previous chain member,
// superseded = any later member built (func_0B900 @0xB97D/@0xB956).
static const std::vector<std::vector<int>>& building_chains() {
    static std::vector<std::vector<int>> chains; static bool loaded = false;
    if (!loaded) {
        loaded = true;
        try {
            forge::JsonValue d = forge::json_parse_file("data_extracted/engine/effects.json");
            if (const forge::JsonValue* bc = d.find("building_chains"))
                if (const forge::JsonValue* cs = bc->find("chains"))
                    for (const forge::JsonValue& ch : cs->arr) {
                        std::vector<int> c2;
                        for (const forge::JsonValue& v : ch.arr) c2.push_back(v.as_int());
                        chains.push_back(c2);
                    }
        } catch (...) {}
    }
    return chains;
}
// nullptr = buildable; else the blocking chain member (out_blocker) with
// out_super = true when a later member supersedes the entry.
bool building_chain_blocked(const Colony& c, int bid, int* out_blocker, bool* out_super) {
    for (const auto& ch : building_chains()) {
        for (size_t k = 0; k < ch.size(); ++k) {
            if (ch[k] != bid) continue;
            if (k > 0 && !((c.built_mask >> ch[k-1]) & 1ull)) {
                if (out_blocker) *out_blocker = ch[k-1];
                if (out_super) *out_super = false;
                return true;                            // prereq missing (@0xB97D)
            }
            for (size_t m = k + 1; m < ch.size(); ++m)
                if ((c.built_mask >> ch[m]) & 1ull) {
                    if (out_blocker) *out_blocker = ch[m];
                    if (out_super) *out_super = true;
                    return true;                        // superseded (@0xB956)
                }
            return false;
        }
    }
    return false;                                       // chainless building
}


// Verbatim GAME.TXT message text by @KEY (defined with the label helpers below).
std::string game_message_text(const std::string& key);
std::string good_display(int g);

void game_step() {
    // Advance one turn by iterating the DATA pipeline (turn.json) -- behaviorally identical
    // to sim::step_turn (asserted by the engine selftest golden-master), but moddable.
    if (g_game_active) {
        // Once independence is declared the King's expeditionary force is COMMITTED: it fights and
        // depletes, it does not keep building. Freeze the peacetime REF buildup (run_turn's
        // ref_purchase) during the war so the conflict is winnable; war_resolution_step depletes it.
        Ref ref_before = g_game.ref; int64_t rm_before = g_game.powers[0].royal_money;
        forge::set_woi(g_engine_extra.woi_declared);    // @NOWARSDURINGREV gate for the units phase
        // The native-settlement view for the AI's visit-natives missions
        // ('4'/'J', ai.md 6.2): the read-only projection of the engine-side
        // settlement entities the EXE scans ([0x539A], stride 0x12).
        std::vector<vc::sim::AiVillage> villages;
        villages.reserve(g_engine_extra.settlements.size());
        for (const forge::NativeSettlement& s : g_engine_extra.settlements)
            villages.push_back({s.x, s.y, s.capital, s.mission < 0});
        forge::run_turn(g_game, g_world, game_rng, 0, g_active_rules, g_engine_extra.ff_owned,
                        &villages);
        if (g_engine_extra.woi_declared) { g_game.ref = ref_before; g_game.powers[0].royal_money = rm_before; }
        auto_export_step();                             // auto-sell over-cap goods to Europe (peacetime)
        // (the per-turn market phase -- drift + republish + volume reset -- runs inside run_turn)
        // Continental Congress: the player's liberty bells accumulate toward the next father.
        { int bells = 0;
          for (const Colony& c : g_world.colonies)
              if (c.owner_power == 0) bells += c.bells_per_turn;
          congress_step(g_engine_extra, g_game.difficulty, g_game.year, bells, game_rng); }
          // (the per-father one-time effects -- incl. Fugger's boycott clear
          //  @0x3BD45 -- fire inside congress_step via apply_ff_acquire)
        if (g_engine_extra.woi_declared)                // scoring component 6 (RECONSTRUCTED gate)
            for (const Colony& c : g_world.colonies)
                if (c.owner_power == 0) g_engine_extra.bells_since_declaration += c.bells_per_turn;
        // Lost-City rumors resolved during the units phase: verbatim @LOSTCITY<n> /
        // @BURIAL<b> GAME.TXT text with the byte-verified %NUMBER fills as turn notices;
        // side effects the sim cannot reach (dock queue, tribe alarm) applied here.
        for (const vc::sim::RumorResult& rr : forge::rumor_log()) {
            std::string key = rr.n == 4 && rr.burial > 0
                ? ("@BURIAL" + std::to_string(rr.burial))
                : ("@LOSTCITY" + std::to_string(rr.n));
            std::string msg = game_message_text(key);
            // GAME.TXT placeholders appear as {%NUMBERn}, {%NUMBERn$}, {%NUMBERn gold}...
            // -- the suffix inside the braces is display text, so replace the token only.
            auto fill = [&](const char* ph, long v) {
                size_t p2; std::string t = std::to_string(v);
                while ((p2 = msg.find(ph)) != std::string::npos) msg.replace(p2, std::strlen(ph), t);
            };
            fill("%NUMBER0", rr.gold); fill("%NUMBER1", rr.treasure);
            if (rr.n == 8 || rr.n == 4) {               // shrines / burial mounds: find the tribe
                forge::NativeSettlement* near_v = nullptr; int best = 1 << 20;
                for (auto& sv : g_engine_extra.settlements) {
                    int dd = std::abs(sv.x - rr.x) + std::abs(sv.y - rr.y);
                    if (dd < best) { best = dd; near_v = &sv; }
                }
                std::string tribe = "natives";
                if (near_v) {
                    // Burial-ground desecration (n=4 only, @SCREWED family): tension
                    // +100 vs the desecrating power (func_045DF2 caller @0x61B84).
                    // Trespassing near shrines (n=8) displeases without the +100
                    // (its delta is the trespass table, natives.md) -- the earlier
                    // wiring on n=8 was the audit-corrected mis-mapping.
                    if (rr.n == 4)
                        forge::tension_apply(*near_v, 0, forge::TENSION_DESECRATE,
                                             g_game.nation == 1,
                                             (g_engine_extra.ff_owned >> 16) & 1u);
                    else
                        forge::tension_apply(*near_v, 0, forge::TENSION_TRESPASS_SEVERE,
                                             g_game.nation == 1,
                                             (g_engine_extra.ff_owned >> 16) & 1u);
                    forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
                    tribe = forge::resolve_binding("@TRIBES[" + std::to_string(near_v->tribe) + "].name", cx).str;
                }
                size_t p3; while ((p3 = msg.find("%STRING0")) != std::string::npos) msg.replace(p3, 8, tribe);
            }
            if (rr.immigrants > 0)                      // FoY: the next recruits are free
                g_engine_extra.free_recruits += rr.immigrants;   // (+0x49 queue @0x52682)
            if (rr.immigrants > 0) {                    // Fountain of Youth: fill the dock queue
                // the EXE queues 8 immigrants; this model's dock holds imm_dock_slots --
                // empty slots fill now, the rest arrive with the regular flow (noted cap)
                for (int sl = 0; sl < 3; ++sl)
                    if (g_game.powers[0].dock_pool[sl] < 0)
                        g_game.powers[0].dock_pool[sl] = vc::sim::immigrant_refill(
                            g_game.difficulty, (g_engine_extra.ff_owned >> 20) & 1u, game_rng, g_active_rules);
            }
            g_turn_notices.push_back(msg);
        }
        forge::rumor_log().clear();
        // School graduations (training.md 3): the verbatim @TRAINPROFESSION /
        // @TRAINFAIL records as turn notices (%STRING0 colony, %STRING1 profession).
        for (const auto& [ci, t] : forge::teach_log()) {
            const std::string clabel = "#" + std::to_string(ci + 1);
            std::string msg = game_message_text(t.no_students ? "@TRAINFAIL" : "@TRAINPROFESSION");
            size_t p2;
            while ((p2 = msg.find("%STRING0")) != std::string::npos) msg.replace(p2, 8, clabel);
            if (!t.no_students) {
                const std::string prof = forge::job_name(t.profession, true);
                while ((p2 = msg.find("%STRING1")) != std::string::npos) msg.replace(p2, 8, prof);
            }
            g_turn_notices.push_back(msg);
        }
        forge::teach_log().clear();
        // Battlefield promotions (training.md 3): the human power's units only --
        // @CONTINENTAL for the type ceiling, @VETERAN for the veteran stamp.
        for (const vc::sim::PromoteResult& pr : forge::promote_log()) {
            if (pr.owner != 0) continue;
            const bool ceiling = pr.new_type != pr.old_type;      // Soldiers->Cont. Army etc.
            std::string msg = game_message_text(ceiling ? "@CONTINENTAL" : "@VETERAN");
            const char* nm = unit_stats(pr.old_type).name;
            size_t p2;
            while ((p2 = msg.find("%STRING0")) != std::string::npos)
                msg.replace(p2, 8, nm ? nm : "troops");
            g_turn_notices.push_back(msg);
        }
        forge::promote_log().clear();
        // Shore bombardment (combat.md func_02D3C6): the verbatim @FORTFIRE +
        // @SHIPSUNK/@SHIPDAMAGE records as turn notices.
        for (const vc::sim::ShoreFire& sf : forge::shore_log()) {
            auto sfill = [](std::string s, const char* tok, const std::string& v) {
                for (size_t p2; (p2 = s.find(tok)) != std::string::npos; )
                    s.replace(p2, std::strlen(tok), v);
                return s;
            };
            const Colony& c = g_world.colonies[sf.colony];
            const bool ft = (c.built_mask >> 1) & 1ull, fs = (c.built_mask >> 2) & 1ull;
            const std::string fort_name = fs ? "Fortress" : ft ? "Fort" : "Stockade";  // @BUILDING 2/1/0
            const std::string clabel = "#" + std::to_string(sf.colony + 1);
            std::string ship_nation = "enemy", ship_name = "ship";
            if (sf.ship >= 0 && sf.ship < (int)g_world.units.size()) {
                const Unit& sh = g_world.units[sf.ship];
                ship_nation = nation_name(sh.owner);
                const char* nm = unit_stats(sh.type).name;
                if (nm) ship_name = nm;
            }
            std::string m = game_message_text("@FORTFIRE");
            m = sfill(m, "%STRING0", fort_name);  m = sfill(m, "%STRING1", clabel);
            m = sfill(m, "%STRING2", ship_nation); m = sfill(m, "%STRING3", ship_name);
            g_turn_notices.push_back(m);
            std::string m2 = game_message_text(sf.sunk ? "@SHIPSUNK" : "@SHIPDAMAGE");
            m2 = sfill(m2, "%STRING0", ship_nation); m2 = sfill(m2, "%STRING1", ship_name);
            m2 = sfill(m2, "%STRING2", sf.sunk ? fort_name : "port");   // @SHIPDAMAGE "returns
            m2 = sfill(m2, "%STRING3", clabel);                         //   to %STRING2" -- port
            g_turn_notices.push_back(m2);                               //   voyage not modeled
        }
        forge::shore_log().clear();
        // Food shortages from the production phase (colony.md 3, func_02D658
        // @0x2E219/@0x2E265): @FOODLOW warning, @STARVE1 death, @VANISH loss.
        for (auto& [ci, ev] : forge::food_log()) {
            auto ffill = [](std::string s, const char* tok, const std::string& v) {
                for (size_t p2; (p2 = s.find(tok)) != std::string::npos; )
                    s.replace(p2, std::strlen(tok), v);
                return s;
            };
            const char* key = ev == 3 ? "@VANISH" : ev == 2 ? "@STARVE1" : "@FOODLOW";
            std::string m = game_message_text(key);
            m = ffill(m, "%STRING0", "#" + std::to_string(ci + 1));
            if (ev == 1 && ci < (int)g_world.colonies.size()) {
                size_t p2; std::string t = std::to_string(g_world.colonies[ci].stockpile[0]);
                while ((p2 = m.find("%NUMBER0")) != std::string::npos) m.replace(p2, 8, t);
            }
            g_turn_notices.push_back(m);
        }
        forge::food_log().clear();
        // Mine depletions (map_system.md "Depletion writer"): the verbatim
        // @DEPLETION record, %STRING0 = the colony name.
        for (int ci : forge::depletion_log()) {
            std::string m = game_message_text("@DEPLETION");
            size_t p2;
            while ((p2 = m.find("%STRING0")) != std::string::npos)
                m.replace(p2, 8, tutorial_colony_name(ci));
            g_turn_notices.push_back(m);
        }
        forge::depletion_log().clear();
        // Per-colony SoL status announcements (colony.md 2, the func_02D658
        // hysteresis): verbatim @REBELMAJORITY/@REBELUNANIMOUS/@TORYMINORITY/
        // @TORYMAJORITY with the colony and the live membership percent.
        for (auto& [ci, ev] : forge::sol_log()) {
            static const char* KEYS[5] = {"", "@REBELMAJORITY", "@REBELUNANIMOUS",
                                          "@TORYMINORITY", "@TORYMAJORITY"};
            if (ev < 1 || ev > 4 || ci >= (int)g_world.colonies.size()) continue;
            const Colony& c = g_world.colonies[ci];
            if (c.owner_power != 0 || !c.human) continue;   // announcements are the player's
            std::string m = game_message_text(KEYS[ev]);
            auto sfill2 = [](std::string s2, const char* tok, const std::string& v) {
                for (size_t p2; (p2 = s2.find(tok)) != std::string::npos; )
                    s2.replace(p2, std::strlen(tok), v);
                return s2;
            };
            m = sfill2(m, "%STRING0", "#" + std::to_string(ci + 1));
            m = sfill2(m, "%NUMBER0", std::to_string(
                sol_pct(c, g_engine_extra.ff_owned, true)));
            g_turn_notices.push_back(m);
        }
        forge::sol_log().clear();
        // The native powers' turn (natives.md): tension decay, mission converts
        // (@INDIANSCONVERT), and raids by hostile settlements (the 6 @RAID* keys).
        {
            forge::NativeTurn nt = forge::native_turn_step(g_game, g_world, g_engine_extra, game_rng);
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            auto tname = [&](int si) {
                return forge::resolve_binding("@TRIBES[" + std::to_string(
                    g_engine_extra.settlements[si].tribe) + "].name", cx).str;
            };
            auto nfill = [](std::string s, const char* tok, const std::string& v) {
                for (size_t p2; (p2 = s.find(tok)) != std::string::npos; )
                    s.replace(p2, std::strlen(tok), v);
                return s;
            };
            for (auto& [si, ci] : nt.converts) {
                std::string m = game_message_text("@INDIANSCONVERT");
                m = nfill(m, "%STRING0", "#" + std::to_string(ci + 1));
                g_turn_notices.push_back(m);
            }
            for (auto& [si, rr] : nt.raids) {
                std::string m = game_message_text(rr.key);
                m = nfill(m, "%STRING0", tname(si));
                // find the raided colony label from the nearest own colony used
                m = nfill(m, "%STRING1", "#" + std::to_string(
                    [&]{ int best=-1; long bd=1<<20;
                         const forge::NativeSettlement& s = g_engine_extra.settlements[si];
                         for (int c2=0;c2<(int)g_world.colonies.size();++c2){
                             const Colony& c=g_world.colonies[c2]; if(c.x<0)continue;
                             long d=std::abs(c.x-s.x)+std::abs(c.y-s.y);
                             if(d<bd){bd=d;best=c2;} } return best+1; }()));
                if (rr.good >= 0)     m = nfill(m, "%STRING2", good_display(rr.good));
                if (rr.building >= 0) m = nfill(m, "%STRING2",
                    forge::resolve_binding("@BUILDING[" + std::to_string(rr.building) + "].name", cx).str);
                if (rr.ship >= 0 && rr.ship < (int)g_world.units.size())
                    m = nfill(m, "%STRING2", unit_stats(g_world.units[rr.ship].type).name);
                m = nfill(m, "%STRING3", nation_name(0));
                { size_t p2; std::string t = std::to_string(rr.gold);
                  while ((p2 = m.find("%NUMBER0")) != std::string::npos) m.replace(p2, 8, t); }
                g_turn_notices.push_back(m);
            }
        }
        // AI powers may have founded colonies this turn (ai.md settler missions):
        // keep the legacy colony_xy list in step with the world's colony roster.
        while (g_colony_xy.size() < g_world.colonies.size()) {
            const Colony& nc = g_world.colonies[g_colony_xy.size()];
            g_colony_xy.push_back({nc.x, nc.y});
        }
        spanish_succession_step();                      // scripted pre-revolution event (self-gated)
        tory_uprising_step();                           // during-WoI internal dissent (self-gated)
        intervention_step();                            // foreign ally declaration + landings (self-gated)
        long ref_pre = g_game.ref.regulars + g_game.ref.cavalry + g_game.ref.manowar + g_game.ref.artillery;
        war_resolution_step();                          // resolve the War of Independence if declared
        // HOWTOWIN ([0x5386]&0x01, test @0x5DC49): fired for the rebel power
        // ([0x5398] compare @0x5DC43) on recapturing a colony in the WoI; our
        // war model is attrition-based, so the anchor is the first rebel
        // battle win (REF depleted this turn) -- anchor RECONSTRUCTED.
        if (g_engine_extra.woi_declared &&
            g_game.ref.regulars + g_game.ref.cavalry + g_game.ref.manowar + g_game.ref.artillery < ref_pre)
            tutorial_fire(0x0001, "@HOWTOWIN");
        native_braves_step();                           // the villages' wanderers roam
        tutorial_turn_checks();                         // event-driven lessons (T5/T6/T7 sites)
        // ---- Grievance lifecycle (diplomacy.md; driver extracted 2026-07-02).
        // Accrual @0x42335: a destroyed unit adds a per-unit value to its
        // owner's grievance score (DGROUP 0x941C). The value call is
        // func_007C2A (0x181F:0x9C8 -> file 0x7C2A, decoded): defense x8 with
        // the veteran-Soldiers/Dragoons and Drake-Privateer +50% riders --
        // grievance_unit_value in sim/diplomacy.hpp. The evaluator compares
        // scores relatively (@0x3F0C5/@0x3F0CE) and raises the pending-
        // grievance bit (@0x3F0D7); per turn the bit resolves to 0x01 when
        // the parley cooldown has expired and random_int(0,3)==0 (@0x53165).
        for (const vc::sim::KillResult& kr : vc::sim::kill_log()) {
            if (kr.owner == kr.by_owner || kr.owner > 3 || kr.by_owner > 3) continue;
            const UnitStats& us = unit_stats(g_active_rules, kr.type);
            const bool drake = kr.owner == 0 && ((g_engine_extra.ff_owned >> 13) & 1u);
            long v = g_engine_extra.diplo.grievance[kr.owner] +
                     vc::sim::grievance_unit_value(us.defense, kr.type, kr.veteran, drake,
                                                   kr.cargo);
            g_engine_extra.diplo.grievance[kr.owner] = (uint16_t)std::min(v, 0xFFFFL);
            if (g_engine_extra.diplo.grievance[kr.owner] >
                g_engine_extra.diplo.grievance[kr.by_owner])
                g_engine_extra.diplo.war[kr.owner][kr.by_owner] |= vc::sim::WAR_GRIEVANCE;
        }
        vc::sim::kill_log().clear();
        for (int a = 0; a < 4; ++a) for (int b = 0; b < 4; ++b) {
            if (!(g_engine_extra.diplo.war[a][b] & vc::sim::WAR_GRIEVANCE)) continue;
            if (g_game.turn >= g_engine_extra.diplo.cooldown[a] && game_rng(0, 3) == 0) {
                g_engine_extra.diplo.war[a][b] &= ~vc::sim::WAR_GRIEVANCE;
                g_engine_extra.diplo.war[a][b] |= vc::sim::WAR_RESOLVED;   // @0x5318F
                // An AI power's resolved grievance against the HUMAN becomes a
                // reparation demand (@WANTSTUFF, func_057F4E): probability gate
                // rng(1000) < 200*diff+100 (@0x58315); value = grievance scaled
                // x10(diff+8)/100 (@0x583A0) + the 500*(diff+1) surcharge
                // (@0x5842B). The grievance-as-base is RECONSTRUCTED.
                if (a >= 1 && a <= 3 && b == 0 && g_engine_extra.demand_power < 0 &&
                    game_rng(0, 999) < 200 * g_game.difficulty + 100) {
                    long base = g_engine_extra.diplo.grievance[a];
                    g_engine_extra.demand_power = a;
                    g_engine_extra.demand_amount =
                        vc::sim::ai_demand_value(base, g_game.difficulty) +
                        vc::sim::ai_demand_surcharge(g_game.difficulty);
                }
            }
        }
        history_snapshot();
        // Autosave (save.md, BYTE_VERIFIED): the main turn loop writes the
        // rolling autosave to slot 10 (@0x5AF3), gated by the enable flag
        // [0x826] (@0x5AD7) -- here @GAMEOPTIONS "~Autosave" (bit 4) and the
        // slot-10 file savegame_auto.json.
        if ((g_engine_extra.game_options >> 4) & 1) save_game_to("data_extracted/engine/savegame_auto.json");
    }
}

static const char* GOOD_NAME[16] = {"Food","Sugar","Tobacco","Cotton","Furs","Lumber","Ore","Silver",
    "Horses","Rum","Cigars","Cloth","Coats","Trade Goods","Tools","Muskets"};
std::string good_display(int g) {
    if (g >= 0 && g < 16) return GOOD_NAME[g];
    if (g == 16) return "Hammers";
    if (g == 17) return "Crosses";
    if (g == 18) return "Bells";
    return "?";
}

// The full detail a colony screen needs: buildings built, the colonist roster (each with its
// @JOB profession + specialty + what/where it works), the production breakdown, the 16-good
// warehouse, and the build project. Served by /api/colony/detail and folded into the state.
forge::JsonValue colony_detail_json(int ci) {
    forge::JsonValue o = jobj();
    if (ci < 0 || ci >= (int)g_world.colonies.size()) { o.obj["error"] = forge::json_str("no colony"); return o; }
    const Colony& c = g_world.colonies[ci];
    forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
    o.obj["index"] = forge::json_num(ci);
    o.obj["x"] = forge::json_num(ci < (int)g_colony_xy.size() ? g_colony_xy[ci].first : 0);
    o.obj["y"] = forge::json_num(ci < (int)g_colony_xy.size() ? g_colony_xy[ci].second : 0);
    o.obj["population"] = forge::json_num(c.population);
    o.obj["sol"] = forge::json_num(sol_pct(c, g_engine_extra.ff_owned, c.human && c.owner_power == 0));
    o.obj["warehouse"] = forge::json_num(c.warehouse_lvl);
    o.obj["food_accum"] = forge::json_num((double)c.food_accum);
    forge::JsonValue prod = jobj();                               // per-turn production breakdown
    prod.obj["food"] = forge::json_num(c.food_per_turn);
    prod.obj["bells"] = forge::json_num(c.bells_per_turn);
    prod.obj["hammers"] = forge::json_num(c.hammers_per_turn);
    prod.obj["crosses"] = forge::json_num(c.crosses_output);
    o.obj["production"] = prod;
    forge::JsonValue built = jarr();                             // which buildings are constructed
    for (int b = 0; b < 48; ++b) if ((c.built_mask >> b) & 1ull) {
        forge::JsonValue bo = jobj(); bo.obj["id"] = forge::json_num(b);
        bo.obj["name"] = forge::resolve_binding("@BUILDING[" + std::to_string(b) + "].name", cx);
        built.arr.push_back(bo);
    }
    o.obj["built"] = built;
    forge::JsonValue colonists = jarr();                         // the roster: who, specialty, where
    for (const auto& wk : c.workers) {
        forge::JsonValue w = jobj();
        w.obj["profession"] = forge::json_num(wk.profession);
        w.obj["name"] = forge::json_str(forge::job_name(wk.profession, wk.expert));
        w.obj["expert"] = jbool(wk.expert);
        w.obj["good"] = forge::json_num(wk.good);
        w.obj["good_name"] = forge::json_str(good_display(wk.good));
        w.obj["tile"] = forge::json_num(wk.tile);
        w.obj["where"] = forge::json_str(wk.tile >= 0
            ? (good_display(wk.good) + " (field tile " + std::to_string(wk.tile) + ")")
            : (good_display(wk.good) + " (building)"));
        colonists.arr.push_back(w);
    }
    o.obj["colonists"] = colonists;
    forge::JsonValue stock = jarr();                            // 16-good warehouse
    for (int g = 0; g < NGOODS; ++g) {
        forge::JsonValue s = jobj(); s.obj["good"] = forge::json_str(good_display(g));
        s.obj["qty"] = forge::json_num(c.stockpile[g]); stock.arr.push_back(s);
    }
    o.obj["stockpile"] = stock;
    forge::JsonValue build = jobj();                           // current construction
    build.obj["target"] = forge::json_num(c.build_target);
    build.obj["name"] = c.build_target < 0 ? forge::json_str("") :
        forge::resolve_binding("@BUILDING[" + std::to_string(c.build_target) + "].name", cx);
    build.obj["cost"] = forge::json_num(c.build_cost);
    build.obj["bank"] = forge::json_num((double)c.build_bank);
    long rem = (long)c.build_cost - (long)c.build_bank; if (rem < 0) rem = 0;
    build.obj["remaining"] = forge::json_num((double)rem);
    o.obj["build"] = build;
    return o;
}

// ---- the native colony screen (spec/ui/colony_screen.md, composer func_028592) ----
// Everything the 12-panel composer draws, assembled server-side from live sim state +
// the verbatim text sections. The frontend places it at the byte-cited rects.
const std::vector<std::string>& labels_section(const char* section);
namespace forge { int terrain_good_yield(int terrain, int good); }
forge::JsonValue colony_screen_json(int ci) {
    forge::JsonValue o = colony_detail_json(ci);
    if (o.find("error")) return o;
    const Colony& c = g_world.colonies[ci];
    // Title fields (spec 3.1, all oracle-confirmed): colony name + @SEASONS + year + gold.
    // The name comes from the per-nation COLONY.TXT pool (spec 5 "@COLONYNAME + per-nation
    // lists") by colony index; English entries carry a ",year" suffix that is not displayed.
    static const char* kPool[4] = {"ENGLISH", "FRENCH", "SPANISH", "DUTCH"};
    std::string name = "Colony " + std::to_string(ci + 1);
    { const auto& pool = labels_section(kPool[g_game.nation & 3]);
      if (ci < (int)pool.size() && !pool[ci].empty()) {
          name = pool[ci];
          size_t comma = name.find(','); if (comma != std::string::npos) name.resize(comma);
      } }
    o.obj["name"] = forge::json_str(name);
    { const auto& seasons = labels_section("SEASONS");   // 2 entries (Spring/Autumn), spec 5
      o.obj["season_name"] = forge::json_str(
          seasons.empty() ? "" : seasons[(g_game.season & 1) % seasons.size()]); }
    o.obj["year"] = forge::json_num(g_game.year);
    o.obj["gold"] = forge::json_num((double)g_game.powers[0].gold);
    // SoL line "N% (M)" (spec 8.4): members = population - round(tory% * pop / 100).
    { int sol = sol_pct(c, g_engine_extra.ff_owned, c.human && c.owner_power == 0), tory = 100 - sol;
      int members = c.population - (int)((tory * c.population + 50) / 100);
      o.obj["sol_members"] = forge::json_num(members); }
    o.obj["warehouse_cap"] = forge::json_num(vc::sim::warehouse_cap(c, g_active_rules));
    // USER RULING (2026-07-02): the Custom House auto-sell is per-good SELECTED --
    // the screen's stockpile cells toggle export_mask; selected goods sell over 50.
    o.obj["custom_house"] = jbool((c.built_mask >> 18) & 1ull);
    o.obj["export_mask"] = forge::json_num(c.export_mask);
    // Field-production panel data (spec 3.2 / 0.5): the center tile auto-yields its food
    // band + a secondary good (func_00A222 writes [0xA891]/[0xA893]/[0xA894]; the row-2
    // good here is the center terrain's best non-food yield -- the @0x00A34D loop's pick).
    { forge::JsonValue ctr = jobj();
      int food = forge::terrain_good_yield(c.center_terrain, 0);
      if (food < c.center_food) food = c.center_food;
      int bg = -1, bc = 0;
      for (int g = 1; g <= 7; ++g) {
          int yv = forge::terrain_good_yield(c.center_terrain, g);
          if (yv > bc) { bc = yv; bg = g; }
      }
      ctr.obj["food"] = forge::json_num(food);
      ctr.obj["good"] = forge::json_num(bg);
      ctr.obj["count"] = forge::json_num(bc);
      ctr.obj["terrain"] = forge::json_num(c.center_terrain);
      o.obj["center"] = ctr; }
    // The 8 surrounding ring tiles (terrain ids) for the field panel's tile scene.
    { static const int RDX[8] = {-1,0,1,-1,1,-1,0,1}, RDY[8] = {-1,-1,-1,0,0,1,1,1};
      forge::JsonValue ring = jarr();
      int cx = ci < (int)g_colony_xy.size() ? g_colony_xy[ci].first : 0;
      int cy = ci < (int)g_colony_xy.size() ? g_colony_xy[ci].second : 0;
      for (int t = 0; t < 8; ++t) {
          int tid = g_world.terrain_id(cx + RDX[t], cy + RDY[t]);
          ring.arr.push_back(forge::json_num(tid < 0 ? 25 : tid));
      }
      o.obj["ring"] = ring; }
    // Ships in port (spec 3.5: the (121,130,84,48) panel is the port view; the shared
    // empty-panel caption @MISC[11] "No Ships In Port" when none).
    { forge::JsonValue ships = jarr();
      int cx = ci < (int)g_colony_xy.size() ? g_colony_xy[ci].first : 0;
      int cy = ci < (int)g_colony_xy.size() ? g_colony_xy[ci].second : 0;
      for (const Unit& u : g_world.units) {
          if (!u.alive || u.owner != 0 || u.x != cx || u.y != cy) continue;
          if (unit_stats(u.type).move_class != 99) continue;
          forge::JsonValue s = jobj();
          s.obj["type"] = forge::json_num(u.type);
          const char* nm = unit_stats(u.type).name;
          s.obj["name"] = forge::json_str(nm ? nm : "?");
          ships.arr.push_back(s);
      }
      o.obj["ships"] = ships; }
    return o;
}

// End-game score: the spec/systems/scoring.md model (the same vc::sim::score_game the
// F10 report and the ScoreGame node use -- one scoring formula everywhere).
static long compute_score() {
    long pop_score = 0;
    for (const Colony& c : g_world.colonies)
        if (c.owner_power == 0)
            for (const Colony::Worker& w : c.workers) pop_score += w.expert ? 4 : 2;
    int ffc = 0; for (uint32_t b = g_engine_extra.ff_owned; b; b &= b - 1) ++ffc;
    return vc::sim::score_game(g_game.difficulty, pop_score, ffc,
                               g_engine_extra.national_sol, g_engine_extra.razed_settlements,
                               (long)g_game.powers[0].gold,
                               g_engine_extra.bells_since_declaration,
                               g_engine_extra.declaration_year, g_engine_extra.woi_declared);
}
// Endgame evaluation: independence won (REF destroyed), defeat (all colonies lost),
// or retirement at the scenario end year -- with the final score + Hall-of-Fame rank.
static forge::JsonValue endgame_json() {
    long ref_total = g_game.ref.regulars + g_game.ref.cavalry + g_game.ref.manowar + g_game.ref.artillery;
    bool over = false, won = false; std::string reason;
    if (g_engine_extra.woi_declared && ref_total == 0) {
        over = true; won = true; reason = "Independence won -- the King's forces are defeated!";
    } else if (g_game_active && g_world.colonies.empty()) {
        over = true; won = false; reason = "All colonies are lost. The venture ends.";
    } else if (g_engine_extra.retired || g_game.year >= g_end_year) {
        // scenario end year, or the player accepted the @GAME "Retire" dialog
        over = true; won = true; reason = "You retire to Europe in " + std::to_string(g_game.year) + ".";
    }
    long score = compute_score(); g_engine_extra.score = score;
    forge::JsonValue o = jobj();
    o.obj["over"] = jbool(over); o.obj["won"] = jbool(won);
    o.obj["reason"] = forge::json_str(reason);
    o.obj["score"] = forge::json_num((double)score);
    o.obj["rank"] = forge::json_num(vc::sim::score_rank((int)score));
    return o;
}

// ---- unit ownership chip (unit_orders.md Â§2.2/Â§2.3 + NAMES @COUNTRY/@TRIBES) --------
// The on-map status glyph is the 0x54DE accelerator/status-letter array
// {'-','S','T','G','L','F','F','B','P','R','-','-','-'}, indexed by the EXE order
// code (UnitRecord 0x314C, row == code); renderer func @0x0386A. Our spine Order
// enum has its own ordering, so each order maps to its byte-verified row letter.
static char unit_status_glyph(const Unit& u) {
    // Override (@0x0393B): a ship not owned by the viewer draws its cargo count
    // as an ASCII digit ('0'+count) instead of an order letter (types 0x0D..0x12,
    // own-viewer test @0x03935).
    if (unit_stats(u.type).move_class == 99 && u.owner != 0) {
        int n = 0;
        for (int h = 0; h < 6; ++h) if (u.hold_good[h] >= 0) ++n;
        return (char)('0' + n);
    }
    // Override (@0x0397B): AI units draw the persistent AI mission char
    // (UnitRecord 0x314B, ai.md Â§4), replaced by 'E' when >= 0x80 (@0x03986).
    // The si-state gate over which passes render it is undecoded; RECONSTRUCTED
    // as "AI-owned units with a live mission char".
    if (u.owner != 0 && (unsigned char)u.ai_state >= 0x80) return 'E';
    if (u.owner != 0 && u.ai_state && u.ai_state != 'X') return (char)u.ai_state;
    switch (u.order) {
        case ORDER_SENTRY:      return 'S';   // EXE code 1
        case ORDER_TRADE_ROUTE: return 'T';   // EXE code 2
        case ORDER_GOTO:        return 'G';   // EXE code 3
        case ORDER_FORTIFY:                   // EXE code 5 (in progress) and
        case ORDER_FORTIFIED:   return 'F';   // EXE code 6 (active) share 'F'
        case ORDER_CLEAR_PLOW:  return 'P';   // EXE code 8
        case ORDER_ROAD:        return 'R';   // EXE code 9
        default:                return '-';   // EXE code 0 / reserved AI rows
    }
}

// Owner-chip fill colors as VICEROY.PAL indices: EU powers from NAMES @COUNTRY.color
// (legend "color => must be 9-15": England 12, France 9, Spain 14, Netherlands 13),
// tribes from the NAMES @TRIBES 5th column (file legend "tech-level, color": Inca 97,
// Aztec 149, Arawak 54, Iroquois 87, Cherokee 67, Apache 111, Sioux 118, Tupi 71;
// EXE tribe order = PowerRecord idx 4..11). Resolved live so table edits bite.
static forge::JsonValue chip_colors_json() {
    forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
    auto cell_int = [&](const std::string& path, int def) {
        forge::JsonValue v = forge::resolve_binding(path, cx);
        if (v.is_number()) return v.as_int(def);
        if (v.is_string() && !v.str.empty()) return atoi(v.str.c_str());
        return def;
    };
    forge::JsonValue o = jobj(), pw = jarr(), tr = jarr();
    for (int p = 0; p < 4; ++p)                          // chip idx per power SLOT
        pw.arr.push_back(forge::json_num(cell_int(
            "@COUNTRY[" + std::to_string(power_nation(g_game, p)) + "].color", 15)));
    for (int t = 0; t < 8; ++t)                          // chip idx per tribe
        tr.arr.push_back(forge::json_num(cell_int(
            "@TRIBES[" + std::to_string(t) + "].value", 15)));
    o.obj["powers"] = pw; o.obj["tribes"] = tr;
    return o;
}

forge::JsonValue game_state_json() {
    forge::JsonValue o = jobj();
    o.obj["active"] = jbool(g_game_active);
    o.obj["endgame"] = endgame_json();
    { forge::JsonValue war = jobj();          // War of Independence status
      war.obj["declared"] = jbool(g_engine_extra.woi_declared);
      war.obj["national_sol"] = forge::json_num(g_engine_extra.national_sol);
      war.obj["rebel_strength"] = forge::json_num((double)rebel_strength());
      war.obj["ref_strength"] = forge::json_num((double)ref_land_strength());
      war.obj["tory_strength"] = forge::json_num((double)tory_militia_strength());
      war.obj["ref_total"] = forge::json_num((double)(g_game.ref.regulars + g_game.ref.cavalry + g_game.ref.manowar + g_game.ref.artillery));
      war.obj["intervention_active"] = jbool(g_engine_extra.intervention_active);   // [0x5382] bit 1
      war.obj["intervention_power"] = forge::json_num(g_engine_extra.intervention_power);
      war.obj["intervention_landings"] = forge::json_num(g_engine_extra.intervention_landings);
      o.obj["war"] = war; }
    // War of the Spanish Succession: the rival withdrawn from the New World, -1 if none yet.
    o.obj["seceded_power"] = forge::json_num(g_engine_extra.seceded_power);
    if (g_engine_extra.seceded_power >= 0)
        o.obj["seceded_name"] = forge::json_str(nation_name(g_engine_extra.seceded_power));
    o.obj["w"] = forge::json_num(g_world.map_w);
    o.obj["h"] = forge::json_num(g_world.map_h);
    forge::JsonValue terr = jarr();
    for (uint8_t b : g_world.terrain) terr.arr.push_back(forge::json_num(b));
    o.obj["terrain"] = terr;
    if (!g_world.fog.empty()) {          // per-power visibility plane (bit player+4)
        forge::JsonValue fg = jarr();
        for (uint8_t b : g_world.fog) fg.arr.push_back(forge::json_num(b));
        o.obj["fog"] = fg;
    }
    if (!g_world.improve.empty()) {      // plow 0x40 / road 0x08 per tile
        forge::JsonValue im = jarr();
        for (uint8_t b : g_world.improve) im.arr.push_back(forge::json_num(b));
        o.obj["improve"] = im;
    }
    { forge::JsonValue ru = jarr();      // active Lost-City rumor sites (procedural hash)
      for (int y = 0; y < g_world.map_h; ++y)
          for (int x = 0; x < g_world.map_w; ++x)
              if (vc::sim::rumor_present(g_world, x, y, g_game.rumor_seed)) {
                  forge::JsonValue pt = jarr();
                  pt.arr.push_back(forge::json_num(x)); pt.arr.push_back(forge::json_num(y));
                  ru.arr.push_back(pt);
              }
      o.obj["rumors"] = ru; }
    { forge::JsonValue rs = jarr();      // prime resources (procedural, func_0060A0:
      for (int y = 0; y < g_world.map_h; ++y)      // same map seed as the rumor hash)
          for (int x = 0; x < g_world.map_w; ++x) {
              int r = vc::sim::resource_at(g_world, x, y, g_game.rumor_seed);
              if (r < 0) continue;
              forge::JsonValue pt = jarr();
              pt.arr.push_back(forge::json_num(x)); pt.arr.push_back(forge::json_num(y));
              pt.arr.push_back(forge::json_num(r));
              rs.arr.push_back(pt);
          }
      o.obj["resources"] = rs; }
    o.obj["year"] = forge::json_num(g_game.year);
    o.obj["season"] = forge::json_num(g_game.season);
    o.obj["turn"] = forge::json_num((double)g_game.turn);
    o.obj["nation"] = forge::json_num(g_game.nation);
    o.obj["chip"] = chip_colors_json();
    o.obj["difficulty"] = forge::json_num(g_game.difficulty);
    o.obj["gold"] = forge::json_num((double)g_game.powers[0].gold);
    o.obj["royal_money"] = forge::json_num((double)g_game.powers[0].royal_money);
    forge::JsonValue ref = jobj();
    ref.obj["regulars"] = forge::json_num(g_game.ref.regulars);
    ref.obj["cavalry"]  = forge::json_num(g_game.ref.cavalry);
    ref.obj["manowar"]  = forge::json_num(g_game.ref.manowar);
    ref.obj["artillery"]= forge::json_num(g_game.ref.artillery);
    o.obj["ref"] = ref;
    forge::JsonValue prices = jarr();
    for (int i = 0; i < NGOODS; ++i) prices.arr.push_back(forge::json_num(g_game.price_base[i]));
    o.obj["prices"] = prices;
    forge::JsonValue cols = jarr();
    for (size_t i = 0; i < g_world.colonies.size(); ++i) {
        const Colony& c = g_world.colonies[i];
        forge::JsonValue cj = jobj();
        cj.obj["x"] = forge::json_num(i < g_colony_xy.size() ? g_colony_xy[i].first : 0);
        cj.obj["y"] = forge::json_num(i < g_colony_xy.size() ? g_colony_xy[i].second : 0);
        cj.obj["owner"] = forge::json_num(c.owner_power);
        cj.obj["population"] = forge::json_num(c.population);
        cj.obj["sol"] = forge::json_num(sol_pct(c, g_engine_extra.ff_owned, c.human && c.owner_power == 0));
        // production summary + counts so the map HUD has them; /api/colony/detail has the rest.
        forge::JsonValue prod = jobj();
        prod.obj["food"] = forge::json_num(c.food_per_turn); prod.obj["bells"] = forge::json_num(c.bells_per_turn);
        prod.obj["hammers"] = forge::json_num(c.hammers_per_turn); prod.obj["crosses"] = forge::json_num(c.crosses_output);
        cj.obj["production"] = prod;
        int nb = 0; for (int b = 0; b < 48; ++b) if ((c.built_mask >> b) & 1ull) ++nb;
        cj.obj["buildings"] = forge::json_num(nb);
        // the map sprite's fortification tier (ICONS frames: 3 open colony,
        // 0 stockade, 1 fort, 2 fortress -- @BUILDING ids 0/1/2)
        cj.obj["fort"] = forge::json_num((c.built_mask >> 2) & 1ull ? 2 :
                                         (c.built_mask >> 1) & 1ull ? 1 :
                                         (c.built_mask & 1ull) ? 0 : -1);
        cj.obj["colonists"] = forge::json_num((double)c.workers.size());
        cols.arr.push_back(cj);
    }
    o.obj["colonies"] = cols;
    // native settlements (first-class map entities): tribe name + position + capital + player alarm
    forge::JsonValue nats = jarr();
    for (const forge::NativeSettlement& s : g_engine_extra.settlements) {
        forge::JsonValue so = jobj();
        so.obj["tribe"] = forge::json_num(s.tribe);
        so.obj["name"] = forge::resolve_binding("@TRIBES[" + std::to_string(s.tribe) + "].name",
            forge::EngineCtx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng});
        so.obj["x"] = forge::json_num(s.x); so.obj["y"] = forge::json_num(s.y);
        so.obj["capital"] = jbool(s.capital); so.obj["population"] = forge::json_num(s.population);
        so.obj["alarm"] = forge::json_num(s.alarm[0]);   // the human player's alarm at this village
        static const int TRIBE_LEVEL[8] = {3, 2, 1, 1, 1, 0, 0, 0};   // @TRIBES.level (natives.md)
        so.obj["level"] = forge::json_num(s.tribe >= 0 && s.tribe < 8 ? TRIBE_LEVEL[s.tribe] : 0);
        nats.arr.push_back(so);
    }
    o.obj["settlements"] = nats;
    // the villages' wandering braves (map presentation; unit type 19 sprite)
    forge::JsonValue brs = jarr();
    for (const forge::NativeBrave& b : g_engine_extra.braves) {
        forge::JsonValue bj = jobj();
        bj.obj["x"] = forge::json_num(b.x); bj.obj["y"] = forge::json_num(b.y);
        bj.obj["tribe"] = forge::json_num(b.tribe);
        brs.arr.push_back(bj);
    }
    o.obj["braves"] = brs;
    forge::JsonValue us = jarr();
    for (int i = 0; i < (int)g_world.units.size(); ++i) {
        const Unit& u = g_world.units[i];
        if (!u.alive) continue;
        forge::JsonValue uj = jobj();
        uj.obj["id"] = forge::json_num(i);              // stable index into g_world.units
        uj.obj["x"] = forge::json_num(u.x); uj.obj["y"] = forge::json_num(u.y);
        uj.obj["type"] = forge::json_num(u.type);
        const char* nm = unit_stats(u.type).name;
        uj.obj["name"] = forge::json_str(nm ? nm : "?");
        uj.obj["owner"] = forge::json_num(u.owner);
        uj.obj["order"] = forge::json_num(u.order);
        {   // ownership-chip status letter (unit_orders.md Â§2.3)
            char gl[2] = {unit_status_glyph(u), 0};
            uj.obj["glyph"] = forge::json_str(gl);
        }
        uj.obj["moves"] = forge::json_num(u.moves_left);
        uj.obj["target_x"] = forge::json_num(u.target_x);
        uj.obj["target_y"] = forge::json_num(u.target_y);
        uj.obj["naval"] = jbool(unit_stats(u.type).move_class == 99);
        uj.obj["profession"] = forge::json_num(u.profession);
        uj.obj["tools"] = forge::json_num(u.tools);
        uj.obj["work"] = forge::json_num(u.work);
        uj.obj["cargo_cap"] = forge::json_num(unit_stats(u.type).cargo);
        if (u.owner != 0) {                          // the AI mission char (ai.md 4) --
            char sc[2] = {(char)u.ai_state, 0};      // the F8 "Show Strategy" overlay data
            uj.obj["ai_state"] = forge::json_str(sc);
        }
        uj.obj["route"] = forge::json_num(u.route);
        uj.obj["route_stop"] = forge::json_num(u.route_stop);
        forge::JsonValue cg = jarr();               // occupied holds: [good, qty]
        for (int h = 0; h < 6; ++h)
            if (u.hold_good[h] >= 0) {
                forge::JsonValue pr = jarr();
                pr.arr.push_back(forge::json_num(u.hold_good[h]));
                pr.arr.push_back(forge::json_num(u.hold_qty[h]));
                cg.arr.push_back(pr);
            }
        uj.obj["cargo"] = cg;
        us.arr.push_back(uj);
    }
    o.obj["units"] = us;
    // Trade-route table (trade_routes.md 2: seg 0x1B22, max 12 x 4 stops).
    forge::JsonValue rts = jarr();
    for (const TradeRoute& r : g_game.routes) {
        forge::JsonValue ro = jobj();
        ro.obj["name"] = forge::json_str(r.name);
        ro.obj["type"] = forge::json_num(r.type);
        forge::JsonValue sts = jarr();
        for (const TradeStop& st : r.stops) {
            forge::JsonValue so = jobj();
            so.obj["dest"] = forge::json_num(st.dest);
            forge::JsonValue ld = jarr(), ul = jarr();
            for (int gg : st.load)   ld.arr.push_back(forge::json_num(gg));
            for (int gg : st.unload) ul.arr.push_back(forge::json_num(gg));
            so.obj["load"] = ld; so.obj["unload"] = ul;
            sts.arr.push_back(so);
        }
        ro.obj["stops"] = sts;
        rts.arr.push_back(ro);
    }
    o.obj["routes"] = rts;
    return o;
}

// ---- isolated colony sandbox (#67): a second, self-contained world -------------------
// A fresh single colony you can grow, build in, and step -- with every outside variable
// (gold, tax, population, stockpile, price) directly editable -- without touching the
// real Play game. Reuses the same sim (colony_economic_step via step_turn, start_building,
// rush_build) so behavior matches the game exactly.
GameState g_sb_game; World g_sb_world;
std::vector<std::pair<int,int>> g_sb_colony_xy;
forge::EngineExtra g_sb_extra;
bool g_sb_active = false;
static int g_sb_rng = 0x51EDF00D;
int sb_rng(int lo, int hi) {
    g_sb_rng = g_sb_rng * 1103515245 + 12345;
    unsigned v = ((unsigned)g_sb_rng >> 16) & 0x7FFF;
    return hi <= lo ? lo : lo + (int)(v % (unsigned)(hi - lo + 1));
}
void sandbox_new(int pop) {
    g_sb_game = GameState{}; g_sb_world = World{}; g_sb_colony_xy.clear();
    g_sb_extra = forge::EngineExtra{}; g_sb_rng = 0x51EDF00D;
    g_sb_game.difficulty = 1; g_sb_game.year = 1600; g_sb_game.season = 0;
    g_sb_game.powers[0].gold = 1000; g_sb_game.powers[0].tax = 0;
    g_sb_game.ref = vc::sim::ref_start(g_sb_game.difficulty);   // the King's Expeditionary Force (grows each turn)
    // The hidden supply seed is random per good in [600,1000] (market.md, same as a real game),
    // and the published price levels seed from @CARGO -- the sandbox market IS the real model.
    for (int i = 0; i < NGOODS; ++i) g_sb_game.price_base[i] = sb_rng(600, 1000);
    vc::sim::market_init(g_sb_game, sb_rng, g_active_rules);
    Colony c; c.owner_power = 0; c.human = true;
    c.rebel_A = 0; c.rebel_B = 200; c.build_target = -1;   // founding B=200/A=0 (colony.md 2, RUNTIME-CONFIRMED)
    c.center_terrain = 2; c.center_food = 5;                 // town-square auto-food (center tile)
    // A REAL colonist roster (Worker = {profession, tile, terrain, good, expert}) so production is
    // DERIVED from who works where, not seeded as flat numbers. Farmers on plains -> food, an expert
    // Lumberjack on forest -> lumber, a Carpenter -> hammers, a Statesman -> bells.
    c.workers.push_back(Colony::Worker{ 0,  0, 2,  0, false});   // Farmer            field tile 0 -> Food
    c.workers.push_back(Colony::Worker{ 0,  6, 2,  0, false});   // Farmer            field tile 6 -> Food
    c.workers.push_back(Colony::Worker{ 5,  4, 8,  5, true });   // Expert Lumberjack field tile 4 -> Lumber
    c.workers.push_back(Colony::Worker{13, -1, 0, 16, false});   // Carpenter         building     -> Hammers
    c.workers.push_back(Colony::Worker{17, -1, 0, 18, false});   // Statesman         building     -> Bells
    c.built_mask = (1ull << 9) | (1ull << 35) | (1ull << 37);   // Town Hall / Carpenter's Shop / Church
    c.population = (int)c.workers.size();
    if (pop > (int)c.workers.size() && pop <= 32) c.population = pop;
    forge::colony_compute_production(c, g_sb_game.difficulty, g_active_rules, g_sb_extra.ff_owned,
                                     0, &g_sb_world, g_sb_game.rumor_seed);   // roster -> *_per_turn
    g_sb_world.colonies.push_back(c); g_sb_colony_xy.push_back({0, 0});
    g_sb_active = true;
}
// --- Continental Congress bell economy (spec/systems/founding_fathers.md §3, BYTE_VERIFIED) ---
// Bells required for the next founding father. Human European power path; compounds x1.5 per era
// gate reached (1600/1650/1700/1750), grows with #fathers owned, first father is half price.
static int ff_bells_required(int diff, int year, int ff_count) {
    long cost = (long)(diff + 3) * 16;                        // human European power
    for (int gate : {1600, 1650, 1700, 1750}) if (year >= gate) cost += cost >> 1;
    cost = (long)(ff_count + 1) * cost + 1;
    if (ff_count == 0) cost >>= 1;
    return (int)cost;
}
// A father is offerable when it is not yet owned AND every lower-index father in its own category
// Any un-acquired father is offerable: the byte-verified Congress pick is a
// WEIGHTED RANDOM over ALL 25 minus the owned set (func_03BFD2 @0x03C035..
// @0x03C0C4) -- there is no category-ordering gate (the earlier gate was an
// invention; sim/founding_fathers.cpp records its removal).
static bool ff_offerable(int id, uint32_t owned) {
    return !((owned >> id) & 1u);
}
// Pick the next father the Congress offers: era-weighted random over the offerable fathers
// (spec §3 father selection). Reads the three @FATHERS weight columns via the binding grammar.
// The era band (0/1/2 = <1600 / 1600-1699 / >=1700) is vc::sim::ff_era_band.
static int ff_pick_next(uint32_t owned, int year, std::function<int(int,int)> rng) {
    forge::EngineCtx cx{g_sb_game, g_sb_world, g_sb_colony_xy, g_sb_extra, g_active_rules, rng};
    int band = vc::sim::ff_era_band(year);
    const char* col = band == 0 ? "weight_1500_1600"
                    : band == 1 ? "weight_1600_1700" : "weight_1700plus";
    int weight[25], total = 0, offer[25], noff = 0;
    for (int i = 0; i < 25; ++i) {
        if (!ff_offerable(i, owned)) continue;
        forge::JsonValue wv = forge::resolve_binding("@FATHERS[" + std::to_string(i) + "]." + col, cx);
        int w = (wv.type == forge::JsonValue::String) ? std::atoi(wv.str.c_str())
                : (wv.type == forge::JsonValue::Number ? (int)wv.num : 0);
        if (w < 0) w = 0;                    // a 0-weight father is era-locked (@FATHERS data)
        offer[noff] = i; weight[noff] = w; total += w; ++noff;
    }
    if (noff == 0) return -1;
    if (total == 0) return offer[0];         // all weights 0: degenerate fallback (noted)
    int budget = rng(1, total);
    for (int k = 0; k < noff; ++k) { budget -= weight[k]; if (budget <= 0) return offer[k]; }
    return offer[noff - 1];
}
// Make sure the Congress is offering a valid, still-offerable father (picks one, era-weighted, if
// the slot is empty or the offered father was already acquired). Stored in EngineExtra so the offer
// is stable across state reads. Returns the offered id (-1 when all 25 are owned).
static int congress_ensure_offer(forge::EngineExtra& x, int year, std::function<int(int,int)> rng) {
    if (x.offered_ff < 0 || !ff_offerable(x.offered_ff, x.ff_owned))
        x.offered_ff = ff_pick_next(x.ff_owned, year, rng);
    return x.offered_ff;
}
// The one-time on-acquire effect dispatch (func_03BC42 @0x03BC42..0x03BFD0,
// if-ladder on ff_id; all 9 immediate effects byte-verified,
// founding_fathers.md 3). Continuous effects live at their systems' sites.
static void apply_ff_acquire(int id) {
    using namespace vc::sim;
    World& w = g_world; GameState& g = g_game; forge::EngineExtra& x = g_engine_extra;
    switch (id) {
    case 1:                                    // Jakob Fugger: clear ALL boycotts
        g.powers[0].boycotts = 0;              //   (+0x20 := 0, @0x3BD45)
        break;
    case 6:                                    // Coronado: reveal every colony
        for (const Colony& c : w.colonies)     //   (per-colony 0x181F:0x7AA @0x3BF54;
            if (c.x >= 0)                      //    reveal radius RECONSTRUCTED = 1)
                reveal_around(w, c.x, c.y, 1, 0);
        break;
    case 9:                                    // La Salle: free Stockade at size >= 3
        for (Colony& c : w.colonies)           //   (0x181F:0xBBE @0x3BD4A)
            if (c.owner_power == 0 && c.human && c.population >= 3)
                c.built_mask |= 1ull;          //   building 0 = Stockade
        break;
    case 14: {                                 // John Paul Jones: a free Frigate
        Unit f; f.type = FRIGATE; f.owner = 0; //   (spawn_unit 0x181F:0x95C, type 0x11
        f.x = w.map_w > 0 ? w.map_w - 1 : 0;   //    @0x3BD8B; placement RECONSTRUCTED:
        f.y = w.map_h / 2;                     //    the east sea lane, mid-map)
        for (const Colony& c : w.colonies)     //   ...at the first own colony's row
            if (c.owner_power == 0 && c.x >= 0) { f.y = c.y; break; }
        f.moves_left = unit_stats(FRIGATE).movement * 3;
        w.units.push_back(f);
        break;
    }
    case 16:                                   // Pocahontas: native attitudes reset
        for (auto& st : x.settlements) {       //   to content (0x181F:0xA42 @0x3BDDD)
            st.tension[0] = 0;
            st.alarm[0] = 0;
        }
        break;
    case 18:                                   // Simon Bolivar: +20 national SoL,
        x.national_sol += 20;                  //   capped 100 ([0x53D0] @0x3BE64)
        if (x.national_sol > 100) x.national_sol = 100;
        break;
    case 20:                                   // Brewster: no criminals/servants on
        for (auto& d : g.powers[0].dock_pool)  //   the docks (+0x02..+0x04 @0x3BF85)
            if (d == 0x19 || d == 0x1A) d = 0x1C;
        break;
    case 22:                                   // Brebeuf: existing own missions become
        for (auto& st : x.settlements)         //   expert (+5 |= 0x10, @0x3BE77)
            if (st.mission == 0) st.mission_expert = true;
        break;
    case 24:                                   // Las Casas: all own Indian Converts
        for (Unit& u : w.units)                //   (class 0x1B) -> Free Colonists
            if (u.alive && u.owner == 0 && u.profession == 0x1B)
                u.profession = 0x1C;           //   (@0x3BEB2)
        for (Colony& c : w.colonies)
            if (c.owner_power == 0 && c.human)
                for (auto& wk : c.workers)
                    if (wk.profession == 0x1B) wk.profession = 0x1C;
        break;
    default: break;                            // the other 16 are continuous effects
    }
}
// Accumulate this turn's bells into the pool and, when the pool reaches the threshold, acquire the
// offered father, reset the pool, record it for the Congress reveal, and offer the next father.
void congress_step(forge::EngineExtra& x, int diff, int year, int bells_this_turn,
                          std::function<int(int,int)> rng) {
    x.congress_bells += bells_this_turn;
    int ff_count = 0; for (uint32_t b = x.ff_owned; b; b &= b - 1) ++ff_count;
    if (ff_count >= 25) { x.offered_ff = -1; return; }
    int offer = congress_ensure_offer(x, year, rng);
    if (offer < 0) return;
    int need = ff_bells_required(diff, year, ff_count);
    if (x.congress_bells >= need) {
        x.ff_owned |= (1u << offer);
        x.last_ff = offer;
        x.congress_bells = 0;                  // the pool RESETS on acquisition
                                               //   (PowerRecord +0x0C, founding_fathers.md)
        apply_ff_acquire(offer);               // the func_03BC42 one-time effect
        x.offered_ff = -1;                     // Congress offers the next father from now on
        congress_ensure_offer(x, year, rng);
    }
}

// Verbatim UI labels from LABELS.TXT, by section + line index. Every screen pulls its exact
// strings from here (title @MISC[37], "OK" @MISC[46], the advisor titles, @EUROLABEL rows, ...)
// -- the text is the game's own, never retyped. Sections parse once from the newline-joined
// LABELS_sections.json strings and cache.
// Verbatim text-section lines by name. LABELS.TXT first (@MISC/@CTITLE/@CMISC/...), then
// NAMES.TXT (@SEASONS/...) and COLONY.TXT (the per-nation colony-name pools) -- every screen
// string is pulled from these files, never authored.
const std::vector<std::string>& labels_section(const char* section) {
    if (forge::drydock_active()) {              // store-authoritative when loaded;
        static std::map<std::string, std::vector<std::string>> live;   // re-read every
        std::vector<std::string> lines;                                 // call so edits follow
        if (forge::drydock_text_lines(section, lines))
            return live[section] = std::move(lines);
    }
    static std::map<std::string, std::vector<std::string>> cache;
    auto it = cache.find(section);
    if (it != cache.end()) return it->second;
    std::vector<std::string> lines;
    static const char* kSources[] = {"data_extracted/text/LABELS_sections.json",
                                     "data_extracted/text/NAMES_sections.json",
                                     "data_extracted/text/COLONY_sections.json"};
    for (const char* src : kSources) {
        try {
            forge::JsonValue d = forge::json_parse_file(src);
            const forge::JsonValue* m = d.find(std::string("@") + section);
            if (m && m->type == forge::JsonValue::String) {
                std::string cur;
                for (char ch : m->str) { if (ch == '\n') { lines.push_back(cur); cur.clear(); } else cur += ch; }
                lines.push_back(cur);
                break;
            }
        } catch (...) {}
    }
    return cache.emplace(section, std::move(lines)).first->second;
}
static const std::string& misc_label(int idx) {
    static const std::string empty;
    const std::vector<std::string>& lines = labels_section("MISC");
    return (idx >= 0 && idx < (int)lines.size()) ? lines[idx] : empty;
}

// The verbatim GAME.TXT text for a message @KEY (the record store when loaded,
// else the frozen messages.json extraction, cached).
// Falls back to the key itself so a missing record is visible, never invented.
std::string game_message_text(const std::string& key) {
    if (forge::dd_message_hook) {              // store-authoritative when loaded
        forge::DDMsgView v = forge::dd_message_hook(key);
        if (v.found) return v.text;
    }
    static std::map<std::string, std::string> cache; static bool loaded = false;
    if (!loaded) { loaded = true;
        try {
            forge::JsonValue d = forge::json_parse_file("data_extracted/engine/messages.json");
            if (const forge::JsonValue* rows = d.find("messages"))
                for (const auto& r : rows->arr) {
                    const forge::JsonValue* k = r.find("key");
                    const forge::JsonValue* t = r.find("text");
                    if (k && t) cache[k->str] = t->str;
                }
        } catch (...) {}
    }
    auto it = cache.find(key);
    return it == cache.end() ? key : it->second;
}

forge::JsonValue sandbox_state_json() {
    if (!g_sb_active) sandbox_new(3);
    forge::EngineCtx cx{g_sb_game, g_sb_world, g_sb_colony_xy, g_sb_extra, g_active_rules, sb_rng};
    const Colony& c = g_sb_world.colonies[0];
    forge::JsonValue o = jobj();
    o.obj["year"] = forge::json_num(g_sb_game.year);
    o.obj["season"] = forge::json_num(g_sb_game.season);
    o.obj["turn"] = forge::json_num((double)g_sb_game.turn);
    o.obj["gold"] = forge::json_num((double)g_sb_game.powers[0].gold);
    o.obj["tax"] = forge::json_num(g_sb_game.powers[0].tax);
    o.obj["population"] = forge::json_num(c.population);
    o.obj["sol"] = forge::json_num(sol_pct(c, g_engine_extra.ff_owned, c.human && c.owner_power == 0));
    o.obj["bells"] = forge::json_num(c.bells_per_turn);
    o.obj["hammers"] = forge::json_num(c.hammers_per_turn);
    o.obj["food"] = forge::json_num(c.food_per_turn);
    o.obj["crosses"] = forge::json_num(c.crosses_output);
    o.obj["build_target"] = forge::json_num(c.build_target);
    o.obj["build_cost"] = forge::json_num(c.build_cost);
    o.obj["build_bank"] = forge::json_num((double)c.build_bank);
    long rem = (long)c.build_cost - (long)c.build_bank; if (rem < 0) rem = 0;
    o.obj["build_remaining"] = forge::json_num((double)rem);
    o.obj["building_name"] = c.build_target < 0 ? forge::json_str("") :
        forge::resolve_binding("@BUILDING[" + std::to_string(c.build_target) + "].name", cx);
    forge::JsonValue sp = jarr();
    for (int i = 0; i < NGOODS; ++i) sp.arr.push_back(forge::json_num(c.stockpile[i]));
    o.obj["stockpile"] = sp;
    forge::JsonValue built = jarr();
    for (int b = 0; b < 48; ++b) if ((c.built_mask >> b) & 1ull) built.arr.push_back(forge::json_num(b));
    o.obj["built"] = built;
    // The colonist roster -- who is here, their specialty, and where they work -- plus the
    // food-growth accumulator, so the sandbox screen can show the mechanics, not just totals.
    forge::JsonValue colonists = jarr();
    for (const auto& wk : c.workers) {
        forge::JsonValue w = jobj();
        w.obj["name"] = forge::json_str(forge::job_name(wk.profession, wk.expert));
        w.obj["expert"] = jbool(wk.expert);
        w.obj["produces"] = forge::json_str(good_display(wk.good));
        w.obj["tile"] = forge::json_num(wk.tile);
        w.obj["where"] = forge::json_str(wk.tile >= 0 ? ("field tile " + std::to_string(wk.tile)) : "building");
        colonists.arr.push_back(w);
    }
    o.obj["colonists"] = colonists;
    o.obj["food_accum"] = forge::json_num((double)c.food_accum);
    o.obj["center_food"] = forge::json_num(c.center_food);
    // 200 stored food -> a new colonist (USER RULING + warehousing.md:61-62; single threshold)
    o.obj["food_threshold"] = forge::json_num(g_active_rules.cfg.food_growth_threshold);
    // Sons-of-Liberty production bonus (+1 at >=50%, +2 at 100%) + the owned founding fathers, so
    // the screen can show the multiplier and which fathers are boosting production.
    int sbsol = sol_pct(c, g_engine_extra.ff_owned, c.human && c.owner_power == 0);
    o.obj["sol_bonus"] = forge::json_num(sbsol >= 100 ? 2 : (sbsol >= 50 ? 1 : 0));
    o.obj["ff_owned"] = forge::json_num((double)g_sb_extra.ff_owned);
    forge::JsonValue ffa = jarr();
    for (int i = 0; i < 32; ++i) if ((g_sb_extra.ff_owned >> i) & 1u) ffa.arr.push_back(forge::json_num(i));
    o.obj["fathers"] = ffa;
    // Continental Congress progress: bells/turn, the bell pool toward the next father, the bell-cost
    // threshold, the currently-offered father, and the most-recently-acquired father (the reveal).
    int ff_count = 0; for (uint32_t b = g_sb_extra.ff_owned; b; b &= b - 1) ++ff_count;
    forge::JsonValue cong = jobj();
    cong.obj["bells_per_turn"] = forge::json_num(c.bells_per_turn);
    cong.obj["bells_pool"]     = forge::json_num(g_sb_extra.congress_bells);
    int need = ff_bells_required(g_sb_game.difficulty, g_sb_game.year, ff_count);
    cong.obj["threshold"]      = forge::json_num(need);
    cong.obj["remaining"]      = forge::json_num(need > g_sb_extra.congress_bells ? need - g_sb_extra.congress_bells : 0);
    cong.obj["ff_count"]       = forge::json_num(ff_count);
    int nextff = (ff_count >= 25) ? -1 : congress_ensure_offer(g_sb_extra, g_sb_game.year, sb_rng);
    cong.obj["offered"]        = forge::json_num(nextff);   // -1 when all 25 are owned
    cong.obj["last_ff"]        = forge::json_num(g_sb_extra.last_ff);
    cong.obj["national_sol"]   = forge::json_num(g_sb_extra.national_sol);
    // The King's Expeditionary Force (REF) by unit type -- shown on the Activities screen. Order
    // matches the DGROUP array (spec/ui/continental_congress.md §5): Regulars/Cavalry/Man-O-War/Artillery.
    forge::JsonValue ref = jobj();
    ref.obj["regulars"]  = forge::json_num(g_sb_game.ref.regulars);
    ref.obj["cavalry"]   = forge::json_num(g_sb_game.ref.cavalry);
    ref.obj["manowar"]   = forge::json_num(g_sb_game.ref.manowar);
    ref.obj["artillery"] = forge::json_num(g_sb_game.ref.artillery);
    cong.obj["ref"] = ref;
    // Verbatim UI label strings pulled from LABELS.TXT @MISC (spec §3), so the screen text is the
    // game's own, not invented.
    forge::JsonValue lab = jobj();
    lab.obj["title"]     = forge::json_str(misc_label(37));    // CONTINENTAL CONGRESS ACTIVITIES
    lab.obj["congress"]  = forge::json_str(misc_label(134));   // Continental Congress
    lab.obj["session"]   = forge::json_str(misc_label(112));   // Next Continental Congress Session
    lab.obj["rebel"]     = forge::json_str(misc_label(69));     // Rebel
    lab.obj["tory"]      = forge::json_str(misc_label(70));     // Tory
    lab.obj["sentiment"] = forge::json_str(misc_label(71));     // Sentiment
    lab.obj["ref"]       = forge::json_str(misc_label(85));     // Expeditionary Force
    lab.obj["fathers"]   = forge::json_str(misc_label(89));     // Founding Fathers
    lab.obj["ok"]        = forge::json_str(misc_label(46));      // OK
    cong.obj["labels"] = lab;
    o.obj["congress"] = cong;
    // Market: whether the colony has a Custom House (auto-sell to Europe), the tax, and the per-good
    // Europe bid price -- so the screen can offer a "ship & sell" action and show the auto-sell state.
    o.obj["custom_house"] = jbool((c.built_mask >> 18) & 1ull);
    o.obj["tax"] = forge::json_num(g_sb_game.powers[0].tax);
    // Live market (the byte-verified model): per-good the published bid/ask, the published price
    // level (+0x4C), and the HIDDEN VOLUME that drives it -- supply = price_base (the seeded base)
    // + this turn's sell volume (trade, +0xFC). The four finished goods price off the pooled
    // S_pair; every level is clamped to the good's @CARGO drift band; ask = bid + burden + 1.
    RuleData mrd = live_market_rules(cx);
    int64_t s_pair = 0;
    for (int i = vc::sim::RUM; i <= vc::sim::COATS; ++i) s_pair += vc::sim::market_supply(g_sb_game, i);
    if (s_pair < 1) s_pair = 1;
    o.obj["s_pair"] = forge::json_num((double)s_pair);
    forge::JsonValue market = jarr();
    for (int gd = 0; gd < NGOODS; ++gd) {
        forge::JsonValue m = jobj();
        m.obj["good"] = forge::json_str(good_display(gd));
        m.obj["bid"] = forge::json_num(vc::sim::market_bid(g_sb_game, 0, gd));
        m.obj["ask"] = forge::json_num(vc::sim::market_ask(g_sb_game, 0, gd, mrd));
        m.obj["level"] = forge::json_num(g_sb_game.powers[0].price_level[gd]);   // published +0x4C
        m.obj["base"] = forge::json_num(g_sb_game.price_base[gd]);               // hidden supply seed
        m.obj["trade"] = forge::json_num(g_sb_game.powers[0].trade[gd]);          // this turn's volume
        m.obj["supply"] = forge::json_num(vc::sim::market_supply(g_sb_game, gd)); // base + volume
        m.obj["low"] = forge::json_num(mrd.cargo[gd].lo);
        m.obj["high"] = forge::json_num(mrd.cargo[gd].hi);
        m.obj["burden"] = forge::json_num(mrd.cargo[gd].burden);
        m.obj["boycott"] = jbool((g_sb_game.powers[0].boycotts >> gd) & 1u);
        market.arr.push_back(m);
    }
    o.obj["market"] = market;
    // keep a flat bid array for the older price dropdown
    forge::JsonValue pr = jarr();
    for (int gd = 0; gd < NGOODS; ++gd) pr.arr.push_back(forge::json_num(vc::sim::market_bid(g_sb_game, 0, gd)));
    o.obj["prices"] = pr;
    return o;
}

// The complete founding-father reference (all 25, spec/systems/founding_fathers.md): id + @FATHERS
// name + byte-verified effect; `production` marks the ones colony_compute_production actually
// applies (Adam Smith, Henry Hudson, Thomas Jefferson, William Penn).
forge::JsonValue fathers_json() {
    struct FF { const char* effect; bool prod; };
    static const FF FX[25] = {
        {"Enables factory-tier buildings; factory output no longer throttled", true},   // 0  Adam Smith
        {"Clears all boycotts in Europe", false},                                        // 1  Jakob Fugger
        {"No payment to natives for land", false},                                       // 2  Peter Minuit
        {"Enables the Custom House (auto-sell without shipping)", false},                // 3  Peter Stuyvesant
        {"Reveals foreign colony / scout information", false},                           // 4  Jan de Witt
        {"Atlantic crossing takes 1 turn instead of 2", false},                          // 5  Ferdinand Magellan
        {"Reveals all colonies on the map", false},                                      // 6  Francisco Coronado
        {"Lost-city rumors always positive; +1 naval sight", false},                     // 7  Hernando de Soto
        {"Doubles fur production (Furs x2)", true},                                      // 8  Henry Hudson
        {"Free Stockade for colonies of size >= 3", false},                              // 9  Sieur de La Salle
        {"King's treasure cut capped at the tax rate", false},                           // 10 Hernan Cortes
        {"Combat winners auto-promote", false},                                          // 11 George Washington
        {"Undefended colony with muskets defends at strength 75", false},                // 12 Paul Revere
        {"Privateer combat strength +50%", false},                                       // 13 Sir Francis Drake
        {"Free Frigate", false},                                                         // 14 John Paul Jones
        {"Bell production +50%", true},                                                  // 15 Thomas Jefferson
        {"Resets native attitudes; halves native tension increases", false},             // 16 Pocahontas
        {"Bell production scales with the tax rate (+tax%)", false},                      // 17 Thomas Paine
        {"+20% Sons of Liberty", false},                                                 // 18 Simon Bolivar
        {"Foreign powers offer peace", false},                                           // 19 Benjamin Franklin
        {"No criminals / servants arrive on the docks", false},                          // 20 William Brewster
        {"Crosses production +50%", true},                                               // 21 William Penn
        {"All missionaries become expert", false},                                       // 22 Jean de Brebeuf
        {"+4 native-conversion strength", false},                                        // 23 Juan de Sepulveda
        {"Converts become free colonists", false},                                       // 24 Bartolome de las Casas
    };
    // @FOUNDING category names (index = @FATHERS.type). Continental Congress groups the 25 fathers
    // into these 5 categories, 5 each -- the predefined layout every father slots into.
    static const char* CAT[5] = {"Trade", "Exploration", "Military", "Political", "Religious"};
    forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
    forge::JsonValue arr = jarr();
    for (int i = 0; i < 25; ++i) {
        forge::JsonValue o = jobj();
        o.obj["id"] = forge::json_num(i);
        forge::JsonValue nm = forge::resolve_binding("@FATHERS[" + std::to_string(i) + "].name", cx);
        o.obj["name"] = (nm.type == forge::JsonValue::String && !nm.str.empty()) ? nm
                        : forge::json_str("Father #" + std::to_string(i));
        // category (type) from @FATHERS; falls back to i/5 (the fixed 5-per-category layout).
        forge::JsonValue ty = forge::resolve_binding("@FATHERS[" + std::to_string(i) + "].type", cx);
        int cat = (ty.type == forge::JsonValue::String) ? std::atoi(ty.str.c_str())
                  : (ty.type == forge::JsonValue::Number ? (int)ty.num : i / 5);
        if (cat < 0 || cat > 4) cat = i / 5;
        o.obj["type"] = forge::json_num(cat);
        o.obj["category"] = forge::json_str(CAT[cat]);
        o.obj["slot"] = forge::json_num(i % 5);   // column within the category row
        // CC-NN portrait (1:1 with @FATHERS order, spec/ui/continental_congress.md §3), cropped
        // out of the atlas sheet by tools/extract_cc_portraits.py and served via the sliced route.
        char pf[40]; std::snprintf(pf, sizeof pf, "sliced/fathers/CC-%02d.png", i);
        o.obj["portrait"] = forge::json_str(pf);
        o.obj["effect"] = forge::json_str(FX[i].effect);
        o.obj["production"] = jbool(FX[i].prod);
        arr.arr.push_back(o);
    }
    return arr;
}

// ---- Advisor-report state (spec/ui/advisor_reports.md): one endpoint assembling the live rows
// every F1-F10 report body draws. Text comes verbatim from LABELS/NAMES via /api/labels and the
// binding grammar; this carries only the numbers/rows. Report geometry lives in the renderer.
forge::JsonValue report_state_json() {
    forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
    auto tcell = [&](const std::string& p) { return forge::resolve_binding(p, cx); };
    forge::JsonValue o = jobj();
    o.obj["year"] = forge::json_num(g_game.year);
    o.obj["season"] = forge::json_num(g_game.season);
    o.obj["gold"] = forge::json_num((double)g_game.powers[0].gold);
    o.obj["tax"] = forge::json_num(g_game.powers[0].tax);

    // F1 Terrain: the encyclopedia rows -- name/move/defense/farmer-food from @UNFORESTED
    // (+Arctic), plus this-nation unit/colony counts per base ground (func_3744A: the
    // right-justified x=0x136 counts; base = id 0-7, forested variants 8..23 fold to
    // their base, Arctic id 24 -> row 8).
    int t_units[9] = {0}, t_cols[9] = {0};
    auto base_ground = [](int id) {
        id &= 0x1F;
        if (id < 8) return id;
        if (id < 24) return (id - 8) & 7;
        return id == 24 ? 8 : -1;      // ocean/sea lane/mountains/hills: not F1 rows
    };
    for (const Unit& u : g_world.units)
        if (u.alive && u.owner == 0) {
            int b = base_ground(g_world.terrain_id(u.x, u.y));
            if (b >= 0) ++t_units[b];
        }
    for (const Colony& c : g_world.colonies)
        if (c.owner_power == 0 && c.x >= 0) {
            int b = base_ground(g_world.terrain_id(c.x, c.y));
            if (b >= 0) ++t_cols[b];
        }
    forge::JsonValue terr = jarr();
    for (int t = 0; t < 9; ++t) {
        forge::JsonValue r = jobj();
        // rows 0..7 = the base grounds (@UNFORESTED); row 8 = Arctic (@OTHER[0])
        std::string sec = t < 8 ? "@UNFORESTED[" + std::to_string(t) + "]" : "@OTHER[0]";
        r.obj["name"] = tcell(sec + ".name");
        r.obj["move"] = tcell(sec + ".movement");
        r.obj["defense"] = tcell(sec + ".defensive");
        r.obj["food"] = tcell(sec + ".y_farmer");
        r.obj["value"] = tcell(sec + ".value");
        r.obj["units"] = forge::json_num(t_units[t]);
        r.obj["colonies"] = forge::json_num(t_cols[t]);
        terr.arr.push_back(r);
    }
    o.obj["terrain"] = terr;

    // F2 Religious: the crosses gauge (+0x2E of +0x30) + per-colony cross rows.
    forge::JsonValue rel = jobj();
    rel.obj["accum"] = forge::json_num(g_game.powers[0].crosses_accum);
    rel.obj["threshold"] = forge::json_num(g_game.powers[0].crosses_threshold);
    forge::JsonValue relc = jarr();
    for (size_t i = 0; i < g_world.colonies.size(); ++i) {
        if (g_world.colonies[i].owner_power != 0) continue;
        forge::JsonValue r = jobj();
        r.obj["colony"] = forge::json_num((double)i);
        r.obj["crosses"] = forge::json_num(g_world.colonies[i].crosses_output);
        relc.arr.push_back(r);
    }
    rel.obj["colonies"] = relc;
    // The waiting dock immigrants (func_37958's optional next-immigrant text,
    // template @0x11A9 -- the template string is not extracted, so the record
    // ships the raw @JOB class names; the renderer draws them without prose).
    { forge::JsonValue dk = jarr();
      for (int i = 0; i < 3; ++i) {
          int cls = g_game.powers[0].dock_pool[i];
          if (cls < 0) continue;
          dk.arr.push_back(forge::json_str(forge::job_name(cls, false)));
      }
      rel.obj["dock"] = dk; }
    o.obj["religious"] = rel;

    // F3 Congress: pool/threshold/offer/REF/sentiment (the game loop runs congress_step).
    { forge::JsonValue cg = jobj();
      int ffc = 0; for (uint32_t b = g_engine_extra.ff_owned; b; b &= b - 1) ++ffc;
      int bells = 0; for (const Colony& c : g_world.colonies) if (c.owner_power == 0) bells += c.bells_per_turn;
      cg.obj["bells_per_turn"] = forge::json_num(bells);
      cg.obj["bells_pool"] = forge::json_num(g_engine_extra.congress_bells);
      int need = ff_bells_required(g_game.difficulty, g_game.year, ffc);
      cg.obj["threshold"] = forge::json_num(need);
      cg.obj["remaining"] = forge::json_num(need > g_engine_extra.congress_bells ? need - g_engine_extra.congress_bells : 0);
      cg.obj["ff_count"] = forge::json_num(ffc);
      cg.obj["offered"] = forge::json_num(ffc >= 25 ? -1 : congress_ensure_offer(g_engine_extra, g_game.year, game_rng));
      cg.obj["last_ff"] = forge::json_num(g_engine_extra.last_ff);
      cg.obj["national_sol"] = forge::json_num(g_engine_extra.national_sol);
      forge::JsonValue ffa = jarr();
      for (int i = 0; i < 25; ++i) if ((g_engine_extra.ff_owned >> i) & 1u) ffa.arr.push_back(forge::json_num(i));
      cg.obj["fathers"] = ffa;
      forge::JsonValue ref = jobj();
      ref.obj["regulars"] = forge::json_num(g_game.ref.regulars);
      ref.obj["cavalry"] = forge::json_num(g_game.ref.cavalry);
      ref.obj["manowar"] = forge::json_num(g_game.ref.manowar);
      ref.obj["artillery"] = forge::json_num(g_game.ref.artillery);
      cg.obj["ref"] = ref;
      o.obj["congress"] = cg; }

    // F4 Labor: the occupation tally -- colonists per @JOB profession across the player's colonies.
    { std::map<int, int> tally;
      for (const Colony& c : g_world.colonies)
          if (c.owner_power == 0)
              for (const Colony::Worker& w : c.workers) tally[w.profession]++;
      forge::JsonValue lab = jarr();
      for (auto& kv : tally) {
          forge::JsonValue r = jobj();
          r.obj["job"] = tcell("@JOB[" + std::to_string(kv.first) + "].name");
          r.obj["count"] = forge::json_num(kv.second);
          lab.arr.push_back(r);
      }
      o.obj["labor"] = lab; }

    // F5 Economic: per-good total stock across the player's colonies + the published market.
    { forge::JsonValue eco = jarr();
      RuleData mrd = live_market_rules(cx);
      for (int gd = 0; gd < NGOODS; ++gd) {
          long stock = 0;
          for (const Colony& c : g_world.colonies)
              if (c.owner_power == 0) stock += c.stockpile[gd];
          forge::JsonValue r = jobj();
          r.obj["good"] = forge::json_str(good_display(gd));
          r.obj["stock"] = forge::json_num((double)stock);
          r.obj["bid"] = forge::json_num(vc::sim::market_bid(g_game, 0, gd));
          r.obj["ask"] = forge::json_num(vc::sim::market_ask(g_game, 0, gd, mrd));
          r.obj["boycott"] = jbool((g_game.powers[0].boycotts >> gd) & 1u);
          eco.arr.push_back(r);
      }
      o.obj["economic"] = eco; }

    // F6 Colony: one row per player colony (pitch 17, 9/page in the renderer).
    { forge::JsonValue cols = jarr();
      for (size_t i = 0; i < g_world.colonies.size(); ++i) {
          const Colony& c = g_world.colonies[i];
          if (c.owner_power != 0) continue;
          forge::JsonValue r = jobj();
          r.obj["i"] = forge::json_num((double)i);
          r.obj["x"] = forge::json_num(i < g_colony_xy.size() ? g_colony_xy[i].first : 0);
          r.obj["y"] = forge::json_num(i < g_colony_xy.size() ? g_colony_xy[i].second : 0);
          r.obj["population"] = forge::json_num(c.population);
          r.obj["sol"] = forge::json_num(sol_pct(c, g_engine_extra.ff_owned, c.human && c.owner_power == 0));
          int nb = 0; for (int b = 0; b < 48; ++b) if ((c.built_mask >> b) & 1ull) ++nb;
          r.obj["buildings"] = forge::json_num(nb);
          r.obj["food"] = forge::json_num(c.stockpile[0]);
          r.obj["muskets"] = forge::json_num(c.stockpile[15]);
          r.obj["horses"] = forge::json_num(c.stockpile[8]);
          cols.arr.push_back(r);
      }
      o.obj["colonies"] = cols; }

    // F7 Naval: the player's ships (move_class 99), two passes are the renderer's concern.
    { forge::JsonValue nav = jarr();
      for (const auto& u : g_world.units) {
          if (!u.alive || u.owner != 0) continue;
          if (g_active_rules.units[u.type].move_class != 99) continue;
          forge::JsonValue r = jobj();
          r.obj["name"] = forge::json_str(g_active_rules.units[u.type].name);
          r.obj["x"] = forge::json_num(u.x); r.obj["y"] = forge::json_num(u.y);
          r.obj["order"] = forge::json_str(u.order == vc::sim::ORDER_GOTO ? "GOTO"
                            : u.order == vc::sim::ORDER_FORTIFY ? "FORTIFY"
                            : u.order == vc::sim::ORDER_FORTIFIED ? "FORTIFIED"
                            : u.order == vc::sim::ORDER_SENTRY ? "SENTRY" : "-");
          r.obj["tx"] = forge::json_num(u.target_x); r.obj["ty"] = forge::json_num(u.target_y);
          r.obj["cap"] = forge::json_num(g_active_rules.units[u.type].cargo);
          { forge::JsonValue cg = jarr();          // laden holds: the good per hold
            for (int h2 = 0; h2 < 6; ++h2)
                if (u.hold_good[h2] >= 0) cg.arr.push_back(forge::json_num(u.hold_good[h2]));
            r.obj["cargo"] = cg; }
          nav.arr.push_back(r);
      }
      o.obj["naval"] = nav; }

    // F8 Foreign Affairs: the four powers' strength rows (+ war/peace vs the player).
    { forge::JsonValue fp = jarr();
      for (int p = 0; p < 4; ++p) {
          forge::JsonValue r = jobj();
          r.obj["name"] = tcell("@COUNTRY[" + std::to_string(p) + "].name");
          int ncol = 0; long pop = 0;
          for (const Colony& c : g_world.colonies)
              if (c.owner_power == p) { ++ncol; pop += c.population; }
          // the @MISC 95..100 strength rows: Colonies / Population / Average Colony /
          // Military Power (armed land units) / Naval Power (armed ships) / Merchant Marine
          // (unarmed cargo ships)
          int mil = 0, navy = 0, merchant = 0;
          for (const auto& u : g_world.units) {
              if (!u.alive || u.owner != p) continue;
              const auto& st = g_active_rules.units[u.type];
              if (st.move_class == 99) { if (st.attack > 0) ++navy; else ++merchant; }
              else if (st.attack > 0) ++mil;
          }
          r.obj["colonies"] = forge::json_num(ncol);
          r.obj["population"] = forge::json_num((double)pop);
          r.obj["avg_colony"] = forge::json_num(ncol > 0 ? (int)(pop / ncol) : 0);
          r.obj["military"] = forge::json_num(mil + g_engine_extra.power_mil[p]);
          r.obj["naval"] = forge::json_num(navy);
          r.obj["merchant"] = forge::json_num(merchant);
          r.obj["gold"] = forge::json_num((double)g_game.powers[p].gold);
          r.obj["at_war"] = jbool(p != 0 && vc::sim::at_war(g_engine_extra.diplo, 0, p));
          r.obj["seceded"] = jbool(g_engine_extra.seceded_power == p);
          fp.arr.push_back(r);
      }
      o.obj["foreign"] = fp; }
    // F8 revolution gate (@0x39892): the table is unavailable during the WoI --
    // ship the verbatim @FOREIGNNOTAVAIL text for the report to show instead.
    o.obj["woi_declared"] = jbool(g_engine_extra.woi_declared);
    if (g_engine_extra.woi_declared)
        o.obj["foreign_notavail"] = forge::json_str(game_message_text("@FOREIGNNOTAVAIL"));

    // F9 Indian: one row per native settlement (tribe name via @TRIBES). The report
    // body is GATED in the dispatcher (@0x0238D1, [DS:0x5383] bit 0x20 -- natives
    // discovered); the bit's write site is untraced, RECONSTRUCTED as: at least one
    // settlement stands on a tile the player has revealed (fog bit 0x10).
    { bool discovered = false;
      if (!g_world.fog.empty())
          for (const auto& s : g_engine_extra.settlements) {
              size_t k = (size_t)s.y * g_world.map_w + s.x;
              if (k < g_world.fog.size() && (g_world.fog[k] & 0x10)) { discovered = true; break; }
          }
      o.obj["natives_discovered"] = jbool(discovered); }
    { forge::JsonValue ind = jarr();
      for (const auto& s : g_engine_extra.settlements) {
          forge::JsonValue r = jobj();
          r.obj["tribe"] = tcell("@TRIBES[" + std::to_string(s.tribe) + "].name");
          r.obj["x"] = forge::json_num(s.x); r.obj["y"] = forge::json_num(s.y);
          r.obj["population"] = forge::json_num(s.population);
          r.obj["alarm"] = forge::json_num(s.alarm[0]);
          r.obj["mission"] = forge::json_num(s.mission);
          r.obj["capital"] = jbool(s.capital);
          ind.arr.push_back(r);
      }
      o.obj["indian"] = ind; }

    // F10 Score: the scoring.md component breakdown (the same math as the ScoreGame node).
    { forge::JsonValue sc = jobj();
      long pop_score = 0;
      for (const Colony& c : g_world.colonies)
          if (c.owner_power == 0)
              for (const Colony::Worker& w : c.workers) pop_score += w.expert ? 4 : 2;
      int ffc = 0; for (uint32_t b = g_engine_extra.ff_owned; b; b &= b - 1) ++ffc;
      sc.obj["population"] = forge::json_num((double)pop_score);
      sc.obj["fathers"] = forge::json_num(ffc * 5);
      sc.obj["sentiment"] = forge::json_num(g_engine_extra.national_sol);
      sc.obj["razed"] = forge::json_num(-g_engine_extra.razed_settlements * (g_game.difficulty + 1));
      sc.obj["gold"] = forge::json_num((double)(g_game.powers[0].gold / 1000));
      long pb = g_engine_extra.bells_since_declaration / 100; if (pb > 100) pb = 100;
      sc.obj["war_bells"] = forge::json_num((double)pb);
      sc.obj["revolution"] = forge::json_num(
          (g_engine_extra.woi_declared && g_engine_extra.declaration_year > 0)
              ? vc::sim::revolution_bonus(g_engine_extra.declaration_year) : 0);
      long total = vc::sim::score_game(g_game.difficulty, pop_score, ffc,
                                       g_engine_extra.national_sol, g_engine_extra.razed_settlements,
                                       (long)g_game.powers[0].gold,
                                       g_engine_extra.bells_since_declaration,
                                       g_engine_extra.declaration_year, g_engine_extra.woi_declared);
      sc.obj["total"] = forge::json_num((double)total);
      sc.obj["rank"] = forge::json_num(vc::sim::score_rank((int)total));
      sc.obj["mult"] = forge::json_num(vc::sim::score_difficulty_mult(g_game.difficulty));
      o.obj["score"] = sc; }

    return o;
}

// EngineExtra (the relational/Forge-side state) + colony_xy round-trip -- these were
// dropped by the (GameState,World)-only save (fidelity backlog #2/#3). Serialized here
// because they live Forge-side; the sim save stays pure.
static forge::JsonValue dump_extra(const forge::EngineExtra& x) {
    forge::JsonValue o = jobj();
    o.obj["tension"] = forge::json_num(x.tension);
    o.obj["ff_owned"] = forge::json_num((double)x.ff_owned);
    o.obj["boycotts"] = forge::json_num((double)x.boycotts);
    o.obj["national_sol"] = forge::json_num(x.national_sol);
    o.obj["woi_declared"] = jbool(x.woi_declared);
    o.obj["rebel_power"] = forge::json_num(x.rebel_power);
    o.obj["intervention_active"] = jbool(x.intervention_active);
    o.obj["intervention_power"] = forge::json_num(x.intervention_power);
    o.obj["intervention_landings"] = forge::json_num(x.intervention_landings);
    o.obj["seceded_power"] = forge::json_num(x.seceded_power);
    o.obj["score"] = forge::json_num((double)x.score);
    o.obj["congress_bells"] = forge::json_num(x.congress_bells);
    o.obj["merc_primed"] = jbool(x.merc_primed);
    o.obj["merc_price"] = forge::json_num((double)x.pending_merc_price);
    { forge::JsonValue mc = jarr();
      for (int i = 0; i < 4; ++i) mc.arr.push_back(forge::json_num(x.pending_merc_cat[i]));
      o.obj["merc_cat"] = mc; }
    o.obj["merc_wartime"] = jbool(x.pending_merc_wartime);
    o.obj["merc_force"] = forge::json_str(x.pending_merc_force);
    o.obj["free_recruits"] = forge::json_num(x.free_recruits);
    o.obj["artillery_bought"] = forge::json_num(x.artillery_bought);
    o.obj["tutorial_mask"] = forge::json_num(x.tutorial_mask);   // [0x5386]/[0x5387]
    o.obj["tutorial_mask2"] = forge::json_num(x.tutorial_mask2); // [0x5380]
    o.obj["tutorial_extra"] = forge::json_num(x.tutorial_extra); // T2/T18 engine latches
    o.obj["game_options"] = forge::json_num(x.game_options);
    o.obj["colony_options"] = forge::json_num(x.colony_options);
    o.obj["sound_options"] = forge::json_num(x.sound_options);
    o.obj["music_pick"] = forge::json_num(x.music_pick);
    o.obj["retired"] = jbool(x.retired);
    forge::JsonValue mil = jarr(), econ = jarr();
    for (int i = 0; i < 4; ++i) { mil.arr.push_back(forge::json_num(x.power_mil[i]));
        econ.arr.push_back(forge::json_num(x.power_econ[i])); }
    o.obj["power_mil"] = mil; o.obj["power_econ"] = econ;
    forge::JsonValue war = jarr(), rel = jarr(), cd = jarr();
    for (int a = 0; a < 4; ++a) for (int b = 0; b < 4; ++b) {
        war.arr.push_back(forge::json_num(x.diplo.war[a][b]));
        rel.arr.push_back(forge::json_num(x.diplo.rel[a][b])); }
    for (int a = 0; a < 4; ++a) cd.arr.push_back(forge::json_num(x.diplo.cooldown[a]));
    o.obj["diplo_war"] = war; o.obj["diplo_rel"] = rel; o.obj["diplo_cooldown"] = cd;
    { forge::JsonValue gv = jarr();
      for (int a = 0; a < 4; ++a) gv.arr.push_back(forge::json_num(x.diplo.grievance[a]));
      o.obj["diplo_grievance"] = gv; }                           // DGROUP 0x941C
    { forge::JsonValue at = jarr();
      for (int a = 0; a < 4; ++a) at.arr.push_back(forge::json_num(x.diplo.attitude[a]));
      o.obj["diplo_attitude"] = at; }                            // DGROUP 0x940C
    o.obj["demand_power"]  = forge::json_num(x.demand_power);
    o.obj["demand_amount"] = forge::json_num((double)x.demand_amount);
    forge::JsonValue st = jarr();
    for (const forge::NativeSettlement& s : x.settlements) {
        forge::JsonValue so = jobj();
        so.obj["tribe"] = forge::json_num(s.tribe); so.obj["x"] = forge::json_num(s.x); so.obj["y"] = forge::json_num(s.y);
        so.obj["population"] = forge::json_num(s.population); so.obj["wealth"] = forge::json_num(s.wealth);
        so.obj["mission"] = forge::json_num(s.mission); so.obj["capital"] = jbool(s.capital);
        so.obj["skill"] = forge::json_num(s.skill); so.obj["taught"] = jbool(s.taught);
        so.obj["mission_expert"] = jbool(s.mission_expert);
        so.obj["wanted"] = forge::json_num(s.wanted);
        forge::JsonValue al = jarr(); for (int p = 0; p < 4; ++p) al.arr.push_back(forge::json_num(s.alarm[p]));
        so.obj["alarm"] = al;
        forge::JsonValue tn = jarr(); for (int p = 0; p < 4; ++p) tn.arr.push_back(forge::json_num(s.tension[p]));
        so.obj["tension"] = tn; st.arr.push_back(so);
    }
    o.obj["settlements"] = st;
    forge::JsonValue bv = jarr();
    for (const forge::NativeBrave& b : x.braves) {
        forge::JsonValue bj = jobj();
        bj.obj["x"] = forge::json_num(b.x); bj.obj["y"] = forge::json_num(b.y);
        bj.obj["home"] = forge::json_num(b.home); bj.obj["tribe"] = forge::json_num(b.tribe);
        bv.arr.push_back(bj);
    }
    o.obj["braves"] = bv;
    return o;
}
// Serialize the full live game (world + colony_xy + EngineExtra) to a file --
// the /api/game/save body and the turn-loop autosave (save.md slot 10) share it.
bool save_game_to(const std::string& path) {
    if (!g_game_active) return false;
    forge::JsonValue root = forge::json_parse(forge::dump_game(g_game, g_world));
    forge::JsonValue cxy = jarr();
    for (auto& p : g_colony_xy) { forge::JsonValue e = jarr();
        e.arr.push_back(forge::json_num(p.first)); e.arr.push_back(forge::json_num(p.second));
        cxy.arr.push_back(e); }
    root.obj["colony_xy"] = cxy;
    root.obj["engine_extra"] = dump_extra(g_engine_extra);
    std::ofstream f(path, std::ios::binary);
    f << forge::json_dump(root);
    return (bool)f;
}
void read_extra(const forge::JsonValue* o, forge::EngineExtra& x) {
    if (!o) return;
    auto gi = [&](const char* k, int d) { const forge::JsonValue* v = o->find(k); return v ? v->as_int(d) : d; };
    x.tension = gi("tension", 0);
    if (const forge::JsonValue* v = o->find("ff_owned")) x.ff_owned = (uint32_t)v->num;
    if (const forge::JsonValue* v = o->find("boycotts")) x.boycotts = (uint16_t)v->num;
    x.national_sol = gi("national_sol", 0);
    if (const forge::JsonValue* v = o->find("woi_declared")) x.woi_declared = v->type == forge::JsonValue::Bool ? v->b : false;
    x.rebel_power = gi("rebel_power", -1);
    { const forge::JsonValue* v = o->find("intervention_active");
      x.intervention_active = v && v->type == forge::JsonValue::Bool ? v->b : false; }
    x.intervention_power = gi("intervention_power", -1);
    x.intervention_landings = gi("intervention_landings", 0);
    x.seceded_power = gi("seceded_power", -1);
    if (const forge::JsonValue* v = o->find("score")) x.score = (long)v->num;
    x.congress_bells = gi("congress_bells", 0);
    { const forge::JsonValue* v = o->find("merc_primed");
      x.merc_primed = v && v->type == forge::JsonValue::Bool ? v->b : false; }
    x.pending_merc_price = gi("merc_price", 0);
    if (const forge::JsonValue* v = o->find("tutorial_mask")) x.tutorial_mask = (uint16_t)v->num;
    if (const forge::JsonValue* v = o->find("tutorial_mask2")) x.tutorial_mask2 = (uint8_t)v->num;
    if (const forge::JsonValue* v = o->find("tutorial_extra")) x.tutorial_extra = (uint8_t)v->num;
    if (const forge::JsonValue* v = o->find("game_options")) x.game_options = (uint16_t)v->num;
    if (const forge::JsonValue* v = o->find("colony_options")) x.colony_options = (uint16_t)v->num;
    if (const forge::JsonValue* v = o->find("sound_options")) x.sound_options = (uint16_t)v->num;
    x.music_pick = gi("music_pick", -1);
    { const forge::JsonValue* v = o->find("retired");
      x.retired = v && v->type == forge::JsonValue::Bool ? v->b : false; }
    if (const forge::JsonValue* mc = o->find("merc_cat"))
        for (int i = 0; i < 4 && i < (int)mc->arr.size(); ++i)
            x.pending_merc_cat[i] = mc->arr[i].as_int();
    { const forge::JsonValue* v = o->find("merc_wartime");
      x.pending_merc_wartime = v && v->type == forge::JsonValue::Bool ? v->b : false; }
    { const forge::JsonValue* v = o->find("merc_force");
      if (v && v->type == forge::JsonValue::String) x.pending_merc_force = v->str; }
    x.free_recruits = gi("free_recruits", 0);
    x.artillery_bought = gi("artillery_bought", 0);
    if (const forge::JsonValue* m = o->find("power_mil"))
        for (int i = 0; i < 4 && i < (int)m->arr.size(); ++i) x.power_mil[i] = m->arr[i].as_int();
    if (const forge::JsonValue* e = o->find("power_econ"))
        for (int i = 0; i < 4 && i < (int)e->arr.size(); ++i) x.power_econ[i] = e->arr[i].as_int();
    if (const forge::JsonValue* w = o->find("diplo_war"))
        for (int a = 0; a < 4; ++a) for (int b = 0; b < 4; ++b) { int k = a * 4 + b;
            if (k < (int)w->arr.size()) x.diplo.war[a][b] = (uint8_t)w->arr[k].as_int(); }
    if (const forge::JsonValue* r = o->find("diplo_rel"))
        for (int a = 0; a < 4; ++a) for (int b = 0; b < 4; ++b) { int k = a * 4 + b;
            if (k < (int)r->arr.size()) x.diplo.rel[a][b] = (uint8_t)r->arr[k].as_int(); }
    if (const forge::JsonValue* c = o->find("diplo_cooldown"))
        for (int a = 0; a < 4 && a < (int)c->arr.size(); ++a) x.diplo.cooldown[a] = c->arr[a].as_int();
    if (const forge::JsonValue* gv = o->find("diplo_grievance"))
        for (int a = 0; a < 4 && a < (int)gv->arr.size(); ++a) x.diplo.grievance[a] = (uint16_t)gv->arr[a].as_int();
    if (const forge::JsonValue* at = o->find("diplo_attitude"))
        for (int a = 0; a < 4 && a < (int)at->arr.size(); ++a) x.diplo.attitude[a] = (uint8_t)at->arr[a].as_int();
    if (const forge::JsonValue* v = o->find("demand_power"))  x.demand_power  = v->as_int();
    if (const forge::JsonValue* v = o->find("demand_amount")) x.demand_amount = (long)v->num;
    x.settlements.clear();
    x.braves.clear();
    if (const forge::JsonValue* bv = o->find("braves"))
        for (const forge::JsonValue& b : bv->arr)
            x.braves.push_back(forge::NativeBrave{
                b.find("x") ? b.find("x")->as_int(0) : 0,
                b.find("y") ? b.find("y")->as_int(0) : 0,
                b.find("home") ? b.find("home")->as_int(-1) : -1,
                b.find("tribe") ? b.find("tribe")->as_int(0) : 0});
    if (const forge::JsonValue* st = o->find("settlements"))
        for (const forge::JsonValue& s : st->arr) {
            forge::NativeSettlement ns;
            auto si = [&](const char* k, int d) { const forge::JsonValue* v = s.find(k); return v ? v->as_int(d) : d; };
            ns.tribe = si("tribe", 0); ns.x = si("x", 0); ns.y = si("y", 0);
            ns.population = si("population", 1); ns.wealth = si("wealth", 0); ns.mission = si("mission", -1);
            ns.skill = si("skill", 0);
            const forge::JsonValue* cap = s.find("capital"); ns.capital = cap && cap->type == forge::JsonValue::Bool ? cap->b : false;
            const forge::JsonValue* tg = s.find("taught"); ns.taught = tg && tg->type == forge::JsonValue::Bool ? tg->b : false;
            const forge::JsonValue* mx = s.find("mission_expert"); ns.mission_expert = mx && mx->type == forge::JsonValue::Bool ? mx->b : false;
            ns.wanted = si("wanted", 1);
            if (const forge::JsonValue* al = s.find("alarm"))
                for (int p = 0; p < 4 && p < (int)al->arr.size(); ++p) ns.alarm[p] = al->arr[p].as_int();
            if (const forge::JsonValue* tn = s.find("tension"))
                for (int p = 0; p < 4 && p < (int)tn->arr.size(); ++p) ns.tension[p] = tn->arr[p].as_int();
            x.settlements.push_back(ns);
        }
}

// ---- shared player commands (session.hpp) ----------------------------------
// The bodies moved verbatim from the /api/game/{order,found} routes so the
// HTTP server and the native editor run the SAME mechanics (N0 policy).

OrderResult unit_order(int ui, const std::string& o, int tx, int ty,
                       int route, int hold) {
    OrderResult r;
    if (ui < 0 || ui >= (int)g_world.units.size() || !g_world.units[ui].alive) {
        r.err = "bad unit";
        return r;
    }
    Unit& u = g_world.units[ui];
    if (o.empty()) {                                     // GOTO to (tx,ty)
        if (tx < 0 || ty < 0) { r.err = "need a target tile"; return r; }
        u.order = ORDER_GOTO;
        u.target_x = tx;
        u.target_y = ty;
        r.ok = true;
        return r;
    }
    if (o == "P")      u.order = ORDER_CLEAR_PLOW;
    else if (o == "R") u.order = ORDER_ROAD;
    else if (o == "F") u.order = ORDER_FORTIFY;
    else if (o == "S") u.order = ORDER_SENTRY;
    else if (o == "-") { u.order = ORDER_NONE; u.route = -1; }
    else if (o == "T") {
        // @ORDERS row 2 "Trade Route, T" (order byte 2 @0x22E05).
        if (unit_stats(u.type).cargo <= 0) { r.err = "unit has no cargo holds"; return r; }
        if (route < 0 || route >= (int)g_game.routes.size()) { r.err = "need a valid route"; return r; }
        const bool naval = unit_stats(u.type).move_class == 99;
        if (g_game.routes[route].type == 0 ? !naval : naval) {
            r.err = g_game.routes[route].type == 0 ? "a sea route needs a ship"
                                                   : "a land route needs a wagon train";
            return r;
        }
        u.order = ORDER_TRADE_ROUTE; u.route = route; u.route_stop = 0;
    }
    else if (o == "D") {                                 // Disband (shift-D)
        u.alive = false;
        r.ok = true;
        return r;
    }
    else if (o == "L" || o == "U" || o == "O") {
        // Load/Unload "most valuable" + Dump Overboard over the byte-verified
        // hold layout (unit_orders.md 0x3150..; metric RECONSTRUCTED).
        const int cap = std::min(6, unit_stats(u.type).cargo);
        if (cap <= 0) { r.err = "unit has no cargo holds"; return r; }
        if (o == "O") {
            for (int h = 0; h < cap; ++h)
                if (hold < 0 || hold == h) { u.hold_good[h] = -1; u.hold_qty[h] = 0; }
            r.ok = true;
            return r;
        }
        Colony* col = nullptr;
        for (auto& c : g_world.colonies)
            if (c.x == u.x && c.y == u.y && c.owner_power == u.owner) { col = &c; break; }
        if (!col) { r.err = "must be in one of your colonies"; return r; }
        if (o == "L") {
            int best = -1; long bv = 0;
            for (int gd = 0; gd < NGOODS; ++gd) {
                if (col->stockpile[gd] <= 0) continue;
                long v = (long)market_bid(g_game, u.owner, gd) * col->stockpile[gd];
                if (best < 0 || v > bv) { best = gd; bv = v; }
            }
            if (best < 0) { r.err = "nothing to load"; return r; }
            int h = -1;
            for (int i2 = 0; i2 < cap; ++i2)
                if (u.hold_good[i2] == best && u.hold_qty[i2] < 100) { h = i2; break; }
            if (h < 0) for (int i2 = 0; i2 < cap; ++i2)
                if (u.hold_good[i2] < 0) { h = i2; break; }
            if (h < 0) { r.err = "all holds are full"; return r; }
            const int have = (u.hold_good[h] == best) ? u.hold_qty[h] : 0;
            const int qty = std::min(100 - have, (int)col->stockpile[best]);
            u.hold_good[h] = best; u.hold_qty[h] = have + qty;
            col->stockpile[best] -= qty;
            r.ok = true;
            return r;
        }
        int h = -1; long bv = 0;                          // "U": most valuable out
        for (int i2 = 0; i2 < cap; ++i2) {
            if (u.hold_good[i2] < 0 || u.hold_qty[i2] <= 0) continue;
            long v = (long)market_bid(g_game, u.owner, u.hold_good[i2]) * u.hold_qty[i2];
            if (h < 0 || v > bv) { h = i2; bv = v; }
        }
        if (h < 0) { r.err = "no cargo to unload"; return r; }
        col->stockpile[u.hold_good[h]] += u.hold_qty[h];
        u.hold_good[h] = -1; u.hold_qty[h] = 0;
        r.ok = true;
        return r;
    }
    else { r.err = "unknown order (use P/R/F/S/T/D/L/U/O/-)"; return r; }
    u.work = 0;                                          // fresh improvement start
    r.ok = true;
    return r;
}

FoundResult found_colony(int ui, const std::vector<std::string>& acks,
                         const std::string& land_choice) {
    FoundResult r;
    auto acked = [&](const char* k) {
        for (const std::string& a : acks) if (a == k) return true;
        return false;
    };
    if (ui < 0 || ui >= (int)g_world.units.size() || !g_world.units[ui].alive) {
        r.err = "bad unit";
        return r;
    }
    Unit& u = g_world.units[ui];
    if (unit_stats(u.type).move_class == 99) { r.err = "a ship cannot found a colony"; return r; }
    int id = g_world.terrain_id(u.x, u.y);
    if (id < 0 || game_is_water(id)) { r.err = "must found on land"; return r; }
    // Site warnings @TUTNOSPACES / @TUTNOLUMBER (tutorial.md 2, func_022542):
    // gated on difficulty < 2 (@0x22763); counts byte-cited, predicate RECONSTRUCTED.
    {
        bool on_colony = false;
        for (const auto& jc : g_world.colonies)
            if (jc.x == u.x && jc.y == u.y) { on_colony = true; break; }
        if (!on_colony && g_game.difficulty < 2) {
            int productive = 0, forested = 0;
            static const int ddx[8] = {1,-1,0,0,1,1,-1,-1}, ddy[8] = {0,0,1,-1,1,-1,1,-1};
            for (int k = 0; k < 8; ++k) {
                int t = g_world.terrain_id(u.x + ddx[k], u.y + ddy[k]);
                if (t < 0) continue;
                const int tid = t & 0x1F;
                if (tid != 24 && tid != 25 && tid != 26) ++productive;
                if (tid >= 8 && tid <= 23) ++forested;
            }
            const char* warn = nullptr;
            if (productive < 4 && !acked("@TUTNOSPACES")) warn = "@TUTNOSPACES";
            else if (forested == 0 && !acked("@TUTNOLUMBER")) warn = "@TUTNOLUMBER";
            if (warn) {
                r.confirm = warn;
                r.text = game_message_text(warn);
                r.choices = 2;
                return r;
            }
        }
    }
    // "Join Colony (~B)": standing on an own colony joins it instead.
    for (auto& jc : g_world.colonies) {
        if (jc.x != u.x || jc.y != u.y) continue;
        if (jc.owner_power != u.owner) { r.err = "cannot join a foreign colony"; return r; }
        if (jc.population >= 32) { r.err = "colony is full"; return r; }
        jc.population += 1;
        Colony::Worker wk; wk.profession = u.profession; wk.tile = 0; wk.good = 0;
        int t = g_world.terrain_id(u.x, u.y + 1);
        wk.terrain = t < 0 ? (id & 0x1F) : (t & 0x1F);
        jc.workers.push_back(wk);
        forge::colony_compute_production(jc, g_game.difficulty, g_active_rules,
                                         g_engine_extra.ff_owned, 0, &g_world,
                                         g_game.rumor_seed);
        u.alive = false;
        r.ok = true;
        return r;
    }
    // Native land demand @INDIANLAND (func_0464C2 price; claim radius 2 RECONSTRUCTED).
    {
        int best = -1; int bd = 99;
        for (int si = 0; si < (int)g_engine_extra.settlements.size(); ++si) {
            const auto& sv = g_engine_extra.settlements[si];
            int d = std::max(std::abs(sv.x - u.x), std::abs(sv.y - u.y));
            if (d <= 2 && d < bd) { bd = d; best = si; }
        }
        if (best >= 0) {
            auto& sv = g_engine_extra.settlements[best];
            const bool minuit = (g_engine_extra.ff_owned >> 2) & 1u;
            const bool res = resource_at(g_world, u.x, u.y, g_game.rumor_seed) >= 0;
            forge::EngineCtx tcx{g_game, g_world, g_colony_xy, g_engine_extra,
                                 g_active_rules, game_rng};
            const int tl = (int)forge::resolve_binding(
                "@TRIBES[" + std::to_string(sv.tribe) + "].level", tcx).num;
            const int tv = (int)forge::resolve_binding(
                "@TRIBES[" + std::to_string(sv.tribe) + "].value", tcx).num;
            const long price = forge::native_land_price(tl, tv, sv.capital,
                                                        g_game.difficulty, bd,
                                                        u.owner == 0, res, minuit);
            if (price > 0 && !acked("@INDIANLAND")) {
                r.confirm = "@INDIANLAND";
                std::string m = game_message_text("@INDIANLAND");
                std::string tn = forge::resolve_binding(
                    "@TRIBES[" + std::to_string(sv.tribe) + "].name", tcx).str;
                size_t p2;
                while ((p2 = m.find("%STRING0")) != std::string::npos) m.replace(p2, 8, tn);
                while ((p2 = m.find("%NUMBER1")) != std::string::npos)
                    m.replace(p2, 8, std::to_string(price));
                r.text = m;
                r.choices = 3;
                r.price = price;
                return r;
            }
            if (price > 0 && acked("@INDIANLAND")) {
                if (land_choice == "pay") {              // "We offer you {%NUMBER1$}"
                    auto& pw = g_game.powers[u.owner & 3];
                    if (pw.gold < price) { r.err = "not enough gold for the land"; return r; }
                    pw.gold -= price;
                } else {                                 // squatting: +8 tension step
                    forge::tension_apply(sv, u.owner & 3, 8, false, false);
                }
            }
        }
    }
    Colony c; c.owner_power = u.owner; c.human = true; c.population = 1;
    c.rebel_A = 0; c.rebel_B = 200; c.build_target = -1;   // founding B=200/A=0
    c.x = u.x; c.y = u.y;
    c.center_terrain = id & 0x1F; c.center_food = 3;
    { Colony::Worker wk; wk.profession = 19; wk.tile = 0; wk.good = 0;
      int t = g_world.terrain_id(u.x, u.y + 1); wk.terrain = t < 0 ? (id & 0x1F) : (t & 0x1F);
      c.workers.push_back(wk); }
    forge::colony_compute_production(c, g_game.difficulty, g_active_rules,
                                     g_engine_extra.ff_owned, 0, &g_world,
                                     g_game.rumor_seed);
    g_world.colonies.push_back(c);
    g_colony_xy.push_back({u.x, u.y});
    u.alive = false;
    r.ok = true;
    return r;
}

std::string route_create(const std::string& name, int type,
                         const std::vector<TradeStop>& stops) {
    if ((int)g_game.routes.size() >= MAX_TRADE_ROUTES)
        return "Only 12 trade routes can be defined";        // @TRADEMANY
    TradeRoute r;
    r.name = name.substr(0, 31);                             // 32 B name field
    if (r.name.empty()) return "the route needs a name";
    for (const TradeRoute& ex : g_game.routes)
        if (ex.name == r.name) return "route name already in use";
    r.type = type;
    for (const TradeStop& so : stops) {
        if ((int)r.stops.size() >= MAX_ROUTE_STOPS) break;   // 4-stop cap
        if (so.dest != ROUTE_DEST_EUROPE && so.dest != ROUTE_DEST_NONE &&
            (so.dest < 0 || so.dest >= (int)g_world.colonies.size()))
            return "bad stop destination";
        TradeStop st = so;
        if ((int)st.load.size() > MAX_LANE_GOODS) st.load.resize(MAX_LANE_GOODS);
        if ((int)st.unload.size() > MAX_LANE_GOODS) st.unload.resize(MAX_LANE_GOODS);
        r.stops.push_back(std::move(st));
    }
    g_game.routes.push_back(std::move(r));
    return "";
}

std::string route_delete(int ri) {
    if (ri < 0 || ri >= (int)g_game.routes.size()) return "bad route";
    g_game.routes.erase(g_game.routes.begin() + ri);
    // Rebind carriers (the EXE shifts records @0x605DB; higher indices slide).
    for (Unit& u : g_world.units) {
        if (u.route == ri) {
            u.route = -1;
            u.route_stop = 0;
            if (u.order == ORDER_TRADE_ROUTE) u.order = ORDER_NONE;
        } else if (u.route > ri) {
            --u.route;
        }
    }
    return "";
}
