// forge/savegame.cpp -- see savegame.hpp.
#include "savegame.hpp"

#include "json.hpp"

#include <fstream>
#include <sstream>
#include <stdexcept>

using namespace vc::sim;

namespace forge {
namespace {

// --- builders ---
JsonValue arr() { JsonValue v; v.type = JsonValue::Array; return v; }
JsonValue obj() { JsonValue v; v.type = JsonValue::Object; return v; }

JsonValue dump_power(const Power& p) {
    JsonValue o = obj();
    o.obj["royal_money"]       = json_num((double)p.royal_money);
    o.obj["gold"]              = json_num((double)p.gold);
    o.obj["tax"]               = json_num(p.tax);
    o.obj["crosses_accum"]     = json_num(p.crosses_accum);
    o.obj["crosses_threshold"] = json_num(p.crosses_threshold);
    JsonValue tr = arr();
    for (int i = 0; i < NGOODS; ++i) tr.arr.push_back(json_num(p.trade[i]));
    o.obj["trade"] = tr;
    JsonValue dk = arr();
    for (int i = 0; i < 3; ++i) dk.arr.push_back(json_num(p.dock_pool[i]));
    o.obj["dock_pool"] = dk;
    return o;
}

JsonValue dump_colony(const Colony& c) {
    JsonValue o = obj();
    o.obj["owner_power"]      = json_num(c.owner_power);
    o.obj["human"]           = [&]{ JsonValue v; v.type = JsonValue::Bool; v.b = c.human; return v; }();
    o.obj["population"]      = json_num(c.population);
    o.obj["rebel_A"]         = json_num(c.rebel_A);
    o.obj["rebel_B"]         = json_num(c.rebel_B);
    o.obj["hammers_accum"]   = json_num((double)c.hammers_accum);
    o.obj["build_bank"]      = json_num((double)c.build_bank);
    o.obj["build_target"]    = json_num(c.build_target);
    o.obj["build_cost"]      = json_num(c.build_cost);
    o.obj["warehouse_lvl"]   = json_num(c.warehouse_lvl);
    o.obj["built_mask"]      = json_num((double)c.built_mask);     // <=48 bits, exact in double
    o.obj["food_accum"]      = json_num((double)c.food_accum);
    o.obj["bells_per_turn"]  = json_num(c.bells_per_turn);
    o.obj["hammers_per_turn"]= json_num(c.hammers_per_turn);
    o.obj["food_per_turn"]   = json_num(c.food_per_turn);
    o.obj["crosses_output"]  = json_num(c.crosses_output);
    // stockpile + workers -- previously dropped on save (fidelity backlog #2).
    JsonValue sp = arr();
    for (int i = 0; i < NGOODS; ++i) sp.arr.push_back(json_num(c.stockpile[i]));
    o.obj["stockpile"] = sp;
    JsonValue wk = arr();
    for (const Colony::Worker& wkr : c.workers) {
        JsonValue wo = obj();
        wo.obj["terrain"] = json_num(wkr.terrain);
        wo.obj["good"]    = json_num(wkr.good);
        wo.obj["expert"]  = [&]{ JsonValue v; v.type = JsonValue::Bool; v.b = wkr.expert; return v; }();
        wk.arr.push_back(wo);
    }
    o.obj["workers"] = wk;
    return o;
}

JsonValue dump_unit(const Unit& u) {
    JsonValue o = obj();
    o.obj["type"]       = json_num(u.type);
    o.obj["owner"]      = json_num(u.owner);
    o.obj["x"]          = json_num(u.x);
    o.obj["y"]          = json_num(u.y);
    o.obj["profession"] = json_num(u.profession);
    o.obj["moves_left"] = json_num(u.moves_left);
    o.obj["order"]      = json_num(u.order);
    o.obj["target_x"]   = json_num(u.target_x);
    o.obj["target_y"]   = json_num(u.target_y);
    o.obj["alive"]      = [&]{ JsonValue v; v.type = JsonValue::Bool; v.b = u.alive; return v; }();
    return o;
}

// --- readers ---
int    gi(const JsonValue& o, const char* k, int d = 0)    { const JsonValue* v = o.find(k); return v ? v->as_int(d) : d; }
double gd(const JsonValue& o, const char* k, double d = 0)  { const JsonValue* v = o.find(k); return v ? v->as_double(d) : d; }
bool   gb(const JsonValue& o, const char* k, bool d = false){ const JsonValue* v = o.find(k); return v && v->type == JsonValue::Bool ? v->b : d; }

void read_power(const JsonValue& o, Power& p) {
    p.royal_money       = (int64_t)gd(o, "royal_money");
    p.gold              = (int64_t)gd(o, "gold");
    p.tax               = gi(o, "tax");
    p.crosses_accum     = gi(o, "crosses_accum");
    p.crosses_threshold = gi(o, "crosses_threshold");
    if (const JsonValue* tr = o.find("trade"))
        for (int i = 0; i < NGOODS && i < (int)tr->arr.size(); ++i) p.trade[i] = tr->arr[i].as_int();
    if (const JsonValue* dk = o.find("dock_pool"))
        for (int i = 0; i < 3 && i < (int)dk->arr.size(); ++i) p.dock_pool[i] = dk->arr[i].as_int();
}

Colony read_colony(const JsonValue& o) {
    Colony c;
    c.owner_power      = gi(o, "owner_power");
    c.human            = gb(o, "human", true);
    c.population       = gi(o, "population", 1);
    c.rebel_A          = gi(o, "rebel_A");
    c.rebel_B          = gi(o, "rebel_B", 1);
    c.hammers_accum    = (uint32_t)gd(o, "hammers_accum");
    c.build_bank       = (uint32_t)gd(o, "build_bank");
    c.build_target     = gi(o, "build_target", -1);
    c.build_cost       = gi(o, "build_cost");
    c.warehouse_lvl    = gi(o, "warehouse_lvl");
    c.built_mask       = (uint64_t)gd(o, "built_mask");
    c.food_accum       = (uint32_t)gd(o, "food_accum");
    c.bells_per_turn   = gi(o, "bells_per_turn");
    c.hammers_per_turn = gi(o, "hammers_per_turn");
    c.food_per_turn    = gi(o, "food_per_turn");
    c.crosses_output   = gi(o, "crosses_output");
    if (const JsonValue* sp = o.find("stockpile"))
        for (int i = 0; i < NGOODS && i < (int)sp->arr.size(); ++i) c.stockpile[i] = sp->arr[i].as_int();
    if (const JsonValue* wk = o.find("workers"))
        for (const JsonValue& wo : wk->arr) {
            Colony::Worker wkr;
            wkr.terrain = gi(wo, "terrain");
            wkr.good    = gi(wo, "good");
            wkr.expert  = gb(wo, "expert");
            c.workers.push_back(wkr);
        }
    return c;
}

Unit read_unit(const JsonValue& o) {
    Unit u;
    u.type       = gi(o, "type");
    u.owner      = gi(o, "owner");
    u.x          = gi(o, "x");
    u.y          = gi(o, "y");
    u.profession = gi(o, "profession");
    u.moves_left = gi(o, "moves_left");
    u.order      = gi(o, "order");
    u.target_x   = gi(o, "target_x", -1);
    u.target_y   = gi(o, "target_y", -1);
    u.alive      = gb(o, "alive", true);
    return u;
}

}  // namespace

std::string dump_game(const GameState& g, const World& w) {
    JsonValue root = obj();
    root.obj["version"] = json_num(1);

    JsonValue gs = obj();
    gs.obj["year"] = json_num(g.year);
    gs.obj["season"] = json_num(g.season);
    gs.obj["turn"] = json_num((double)g.turn);
    gs.obj["difficulty"] = json_num(g.difficulty);
    gs.obj["nation"] = json_num(g.nation);
    JsonValue powers = arr();
    for (int i = 0; i < 4; ++i) powers.arr.push_back(dump_power(g.powers[i]));
    gs.obj["powers"] = powers;
    JsonValue pb = arr();
    for (int i = 0; i < NGOODS; ++i) pb.arr.push_back(json_num(g.price_base[i]));
    gs.obj["price_base"] = pb;
    JsonValue ref = obj();
    ref.obj["regulars"] = json_num(g.ref.regulars);
    ref.obj["cavalry"] = json_num(g.ref.cavalry);
    ref.obj["manowar"] = json_num(g.ref.manowar);
    ref.obj["artillery"] = json_num(g.ref.artillery);
    gs.obj["ref"] = ref;
    root.obj["game"] = gs;

    JsonValue wd = obj();
    wd.obj["map_w"] = json_num(w.map_w);
    wd.obj["map_h"] = json_num(w.map_h);
    JsonValue ter = arr();
    for (uint8_t b : w.terrain) ter.arr.push_back(json_num(b));
    wd.obj["terrain"] = ter;
    JsonValue cols = arr();
    for (const Colony& c : w.colonies) cols.arr.push_back(dump_colony(c));
    wd.obj["colonies"] = cols;
    JsonValue units = arr();
    for (const Unit& u : w.units) units.arr.push_back(dump_unit(u));
    wd.obj["units"] = units;
    root.obj["world"] = wd;

    return json_dump(root);
}

LoadedGame parse_game(const std::string& json) {
    JsonValue root = json_parse(json);
    LoadedGame lg;
    const JsonValue* gs = root.find("game");
    if (!gs) throw std::runtime_error("savegame: missing 'game'");
    lg.g.year       = gi(*gs, "year", 1492);
    lg.g.season     = gi(*gs, "season");
    lg.g.turn       = (long)gd(*gs, "turn");
    lg.g.difficulty = gi(*gs, "difficulty", 1);
    lg.g.nation     = gi(*gs, "nation", 0);
    if (const JsonValue* pw = gs->find("powers"))
        for (int i = 0; i < 4 && i < (int)pw->arr.size(); ++i) read_power(pw->arr[i], lg.g.powers[i]);
    if (const JsonValue* pb = gs->find("price_base"))
        for (int i = 0; i < NGOODS && i < (int)pb->arr.size(); ++i) lg.g.price_base[i] = pb->arr[i].as_int();
    if (const JsonValue* rf = gs->find("ref")) {
        lg.g.ref.regulars  = gi(*rf, "regulars");
        lg.g.ref.cavalry   = gi(*rf, "cavalry");
        lg.g.ref.manowar   = gi(*rf, "manowar");
        lg.g.ref.artillery = gi(*rf, "artillery");
    }

    const JsonValue* wd = root.find("world");
    if (wd) {
        lg.w.map_w = gi(*wd, "map_w");
        lg.w.map_h = gi(*wd, "map_h");
        if (const JsonValue* ter = wd->find("terrain"))
            for (const auto& b : ter->arr) lg.w.terrain.push_back((uint8_t)b.as_int());
        if (const JsonValue* cols = wd->find("colonies"))
            for (const auto& c : cols->arr) lg.w.colonies.push_back(read_colony(c));
        if (const JsonValue* units = wd->find("units"))
            for (const auto& u : units->arr) lg.w.units.push_back(read_unit(u));
    }
    return lg;
}

void save_game(const std::string& path, const GameState& g, const World& w) {
    std::ofstream f(path, std::ios::binary);
    if (!f) throw std::runtime_error("savegame: cannot write " + path);
    f << dump_game(g, w);
    if (!f) throw std::runtime_error("savegame: write failed for " + path);
}

LoadedGame load_game(const std::string& path) {
    std::ifstream f(path, std::ios::binary);
    if (!f) throw std::runtime_error("savegame: cannot open " + path);
    std::ostringstream ss; ss << f.rdbuf();
    return parse_game(ss.str());
}

} // namespace forge
