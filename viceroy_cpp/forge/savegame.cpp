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
    o.obj["boycotts"]          = json_num(p.boycotts);
    o.obj["crosses_accum"]     = json_num(p.crosses_accum);
    o.obj["crosses_threshold"] = json_num(p.crosses_threshold);
    JsonValue tr = arr();
    for (int i = 0; i < NGOODS; ++i) tr.arr.push_back(json_num(p.trade[i]));
    o.obj["trade"] = tr;
    JsonValue pl = arr();
    for (int i = 0; i < NGOODS; ++i) pl.arr.push_back(json_num(p.price_level[i]));
    o.obj["price_level"] = pl;                      // published market level (+0x4C)
    JsonValue dk = arr();
    for (int i = 0; i < 3; ++i) dk.arr.push_back(json_num(p.dock_pool[i]));
    o.obj["dock_pool"] = dk;
    return o;
}

JsonValue dump_colony(const Colony& c) {
    JsonValue o = obj();
    o.obj["x"] = json_num(c.x);
    o.obj["y"] = json_num(c.y);
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
    o.obj["center_food"]     = json_num(c.center_food);
    o.obj["center_terrain"]  = json_num(c.center_terrain);
    o.obj["tory_risen"]      = [&]{ JsonValue v; v.type = JsonValue::Bool; v.b = c.tory_risen; return v; }();
    o.obj["status_latch"]    = json_num(c.status_latch);
    // stockpile + workers -- previously dropped on save (fidelity backlog #2).
    JsonValue sp = arr();
    for (int i = 0; i < NGOODS; ++i) sp.arr.push_back(json_num(c.stockpile[i]));
    o.obj["stockpile"] = sp;
    JsonValue wk = arr();
    for (const Colony::Worker& wkr : c.workers) {
        JsonValue wo = obj();
        wo.obj["profession"] = json_num(wkr.profession);
        wo.obj["tile"]    = json_num(wkr.tile);
        wo.obj["terrain"] = json_num(wkr.terrain);
        wo.obj["good"]    = json_num(wkr.good);
        wo.obj["expert"]  = [&]{ JsonValue v; v.type = JsonValue::Bool; v.b = wkr.expert; return v; }();
        wo.obj["teach"]   = json_num(wkr.teach);
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
    o.obj["tools"]      = json_num(u.tools);
    o.obj["work"]       = json_num(u.work);
    o.obj["moves_left"] = json_num(u.moves_left);
    o.obj["order"]      = json_num(u.order);
    o.obj["target_x"]   = json_num(u.target_x);
    o.obj["target_y"]   = json_num(u.target_y);
    o.obj["alive"]      = [&]{ JsonValue v; v.type = JsonValue::Bool; v.b = u.alive; return v; }();
    o.obj["route"]      = json_num(u.route);
    o.obj["route_stop"] = json_num(u.route_stop);
    o.obj["ai_state"]   = json_num(u.ai_state);
    o.obj["ai_spent"]   = json_num(u.ai_spent);
    o.obj["heading"]    = json_num(u.heading);
    o.obj["ai_flags"]   = json_num(u.ai_flags);
    o.obj["ai_steps"]   = json_num(u.ai_steps);
    JsonValue cg = arr();                       // cargo holds as [good, qty] pairs
    for (int h = 0; h < 6; ++h) {
        JsonValue pr = arr();
        pr.arr.push_back(json_num(u.hold_good[h]));
        pr.arr.push_back(json_num(u.hold_qty[h]));
        cg.arr.push_back(pr);
    }
    o.obj["cargo"] = cg;
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
    p.boycotts          = (uint16_t)gi(o, "boycotts", 0);
    p.crosses_accum     = gi(o, "crosses_accum");
    p.crosses_threshold = gi(o, "crosses_threshold");
    if (const JsonValue* tr = o.find("trade"))
        for (int i = 0; i < NGOODS && i < (int)tr->arr.size(); ++i) p.trade[i] = tr->arr[i].as_int();
    if (const JsonValue* pl = o.find("price_level"))   // absent in old saves -> stays 0 (re-seeded)
        for (int i = 0; i < NGOODS && i < (int)pl->arr.size(); ++i) p.price_level[i] = pl->arr[i].as_int();
    if (const JsonValue* dk = o.find("dock_pool"))
        for (int i = 0; i < 3 && i < (int)dk->arr.size(); ++i) p.dock_pool[i] = dk->arr[i].as_int();
}

Colony read_colony(const JsonValue& o) {
    Colony c;
    c.x                = gi(o, "x", -1);
    c.y                = gi(o, "y", -1);
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
    c.center_food      = gi(o, "center_food");
    c.center_terrain   = gi(o, "center_terrain");
    c.tory_risen       = gb(o, "tory_risen");
    c.status_latch     = gi(o, "status_latch", 0);
    if (const JsonValue* sp = o.find("stockpile"))
        for (int i = 0; i < NGOODS && i < (int)sp->arr.size(); ++i) c.stockpile[i] = sp->arr[i].as_int();
    if (const JsonValue* wk = o.find("workers"))
        for (const JsonValue& wo : wk->arr) {
            Colony::Worker wkr;
            wkr.profession = gi(wo, "profession", 19);
            wkr.tile    = gi(wo, "tile", -1);
            wkr.terrain = gi(wo, "terrain");
            wkr.good    = gi(wo, "good");
            wkr.expert  = gb(wo, "expert");
            wkr.teach   = gi(wo, "teach");     // absent in old saves -> 0
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
    u.tools      = gi(o, "tools", 100);   // absent in old saves -> the +0x15 init
    u.work       = gi(o, "work", 0);
    u.moves_left = gi(o, "moves_left");
    u.order      = gi(o, "order");
    u.target_x   = gi(o, "target_x", -1);
    u.target_y   = gi(o, "target_y", -1);
    u.alive      = gb(o, "alive", true);
    u.route      = gi(o, "route", -1);
    u.route_stop = gi(o, "route_stop", 0);
    u.ai_state   = gi(o, "ai_state", 'X');
    u.ai_spent   = gi(o, "ai_spent", 0);
    u.heading    = gi(o, "heading", 8);
    u.ai_flags   = gi(o, "ai_flags", 0);
    u.ai_steps   = gi(o, "ai_steps", 0);
    if (const JsonValue* cg = o.find("cargo"))
        for (int h = 0; h < 6 && h < (int)cg->arr.size(); ++h) {
            const JsonValue& pr = cg->arr[h];
            if (pr.arr.size() >= 2) {
                u.hold_good[h] = pr.arr[0].as_int(-1);
                u.hold_qty[h]  = pr.arr[1].as_int(0);
            }
        }
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
    gs.obj["rumor_seed"] = json_num(g.rumor_seed);
    { JsonValue rf = arr();                      // Lost-City bias state (events.md 2)
      for (int p2 = 0; p2 < 4; ++p2) rf.arr.push_back(json_num(g.rumor_floor[p2]));
      gs.obj["rumor_floor"] = rf;
      gs.obj["fountains_found"] = json_num(g.fountains_found);
      gs.obj["cibolas_found"]   = json_num(g.cibolas_found);
      JsonValue bu = arr();
      for (int p2 = 0; p2 < 4; ++p2) bu.arr.push_back(json_num(g.burial_special_used[p2] ? 1 : 0));
      gs.obj["burial_special"] = bu; }
    JsonValue rts = arr();                       // trade-route table (trade_routes.md 2)
    for (const TradeRoute& r : g.routes) {
        JsonValue ro = obj();
        ro.obj["name"] = [&]{ JsonValue v; v.type = JsonValue::String; v.str = r.name; return v; }();
        ro.obj["type"] = json_num(r.type);
        JsonValue sts = arr();
        for (const TradeStop& st : r.stops) {
            JsonValue so = obj();
            so.obj["dest"] = json_num(st.dest);
            JsonValue ld = arr(), ul = arr();
            for (int gd2 : st.load)   ld.arr.push_back(json_num(gd2));
            for (int gd2 : st.unload) ul.arr.push_back(json_num(gd2));
            so.obj["load"] = ld; so.obj["unload"] = ul;
            sts.arr.push_back(so);
        }
        ro.obj["stops"] = sts;
        rts.arr.push_back(ro);
    }
    gs.obj["routes"] = rts;
    root.obj["game"] = gs;

    JsonValue wd = obj();
    wd.obj["map_w"] = json_num(w.map_w);
    wd.obj["map_h"] = json_num(w.map_h);
    JsonValue ter = arr();
    for (uint8_t b : w.terrain) ter.arr.push_back(json_num(b));
    wd.obj["terrain"] = ter;
    if (!w.improve.empty()) {                       // plow/road plane (terrain_improvement.md)
        JsonValue imp = arr();
        for (uint8_t b : w.improve) imp.arr.push_back(json_num(b));
        wd.obj["improve"] = imp;
    }
    if (!w.fog.empty()) {                           // per-power visibility plane (exploration.md)
        JsonValue fg = arr();
        for (uint8_t b : w.fog) fg.arr.push_back(json_num(b));
        wd.obj["fog"] = fg;
    }
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
    lg.g.rumor_seed = gi(*gs, "rumor_seed", 0);
    if (const JsonValue* rf = gs->find("rumor_floor"))
        for (int p2 = 0; p2 < 4 && p2 < (int)rf->arr.size(); ++p2)
            lg.g.rumor_floor[p2] = rf->arr[p2].as_int();
    lg.g.fountains_found = gi(*gs, "fountains_found", 0);
    lg.g.cibolas_found   = gi(*gs, "cibolas_found", 0);
    if (const JsonValue* bu = gs->find("burial_special"))
        for (int p2 = 0; p2 < 4 && p2 < (int)bu->arr.size(); ++p2)
            lg.g.burial_special_used[p2] = bu->arr[p2].as_int() != 0;
    if (const JsonValue* rts = gs->find("routes"))
        for (const JsonValue& ro : rts->arr) {
            TradeRoute r;
            if (const JsonValue* nm = ro.find("name"); nm && nm->is_string()) r.name = nm->str;
            r.type = gi(ro, "type", 0);
            if (const JsonValue* sts = ro.find("stops"))
                for (const JsonValue& so : sts->arr) {
                    TradeStop st;
                    st.dest = gi(so, "dest", ROUTE_DEST_NONE);
                    if (const JsonValue* ld = so.find("load"))
                        for (const JsonValue& v : ld->arr) st.load.push_back(v.as_int());
                    if (const JsonValue* ul = so.find("unload"))
                        for (const JsonValue& v : ul->arr) st.unload.push_back(v.as_int());
                    r.stops.push_back(st);
                }
            lg.g.routes.push_back(r);
        }
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
        if (const JsonValue* imp = wd->find("improve"))   // absent in old saves -> none
            for (const auto& b : imp->arr) lg.w.improve.push_back((uint8_t)b.as_int());
        if (const JsonValue* fg = wd->find("fog"))        // absent in old saves -> fog off
            for (const auto& b : fg->arr) lg.w.fog.push_back((uint8_t)b.as_int());
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
