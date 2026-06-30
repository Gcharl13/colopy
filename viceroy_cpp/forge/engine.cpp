// forge/engine.cpp -- see engine.hpp. A small visual-scripting VM + binding resolver.
#include "engine.hpp"

#include "economy.hpp"   // sol_pct
#include "unit.hpp"      // unit_stats

#include <algorithm>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <map>
#include <stdexcept>

using vc::sim::GameState;
using vc::sim::World;
using vc::sim::NGOODS;

namespace forge {
namespace {

namespace fs = std::filesystem;
const char* GRAPH_DIR = "data_extracted/engine/graphs";

// ---- node catalog helpers ----
JsonValue pin(const char* name, const char* kind, const char* dir, const char* dtype = "") {
    JsonValue p; p.type = JsonValue::Object;
    p.obj["name"] = json_str(name); p.obj["kind"] = json_str(kind);
    p.obj["dir"] = json_str(dir);   if (dtype[0]) p.obj["dtype"] = json_str(dtype);
    return p;
}
JsonValue param(const char* name, const char* kind, std::vector<const char*> options = {}) {
    JsonValue p; p.type = JsonValue::Object;
    p.obj["name"] = json_str(name); p.obj["kind"] = json_str(kind);
    if (!options.empty()) {
        JsonValue o; o.type = JsonValue::Array;
        for (auto s : options) o.arr.push_back(json_str(s));
        p.obj["options"] = o;
    }
    return p;
}
JsonValue node_def(const char* type, const char* title, const char* summary,
                   std::vector<JsonValue> pins, std::vector<JsonValue> params) {
    JsonValue n; n.type = JsonValue::Object;
    n.obj["type"] = json_str(type); n.obj["title"] = json_str(title);
    n.obj["summary"] = json_str(summary);
    JsonValue ps; ps.type = JsonValue::Array; for (auto& p : pins) ps.arr.push_back(p);
    JsonValue pr; pr.type = JsonValue::Array; for (auto& p : params) pr.arr.push_back(p);
    n.obj["pins"] = ps; n.obj["params"] = pr;
    return n;
}
JsonValue category(const char* name, std::vector<JsonValue> nodes) {
    JsonValue c; c.type = JsonValue::Object; c.obj["name"] = json_str(name);
    JsonValue ns; ns.type = JsonValue::Array; for (auto& n : nodes) ns.arr.push_back(n);
    c.obj["nodes"] = ns; return c;
}

double as_num(const JsonValue& v) { return v.type == JsonValue::Number ? v.num
                                         : v.type == JsonValue::Bool ? (v.b ? 1 : 0) : 0; }

} // namespace

JsonValue node_catalog() {
    JsonValue root; root.type = JsonValue::Object;
    JsonValue cats; cats.type = JsonValue::Array;

    cats.arr.push_back(category("Triggers", {
        node_def("OnTurnStart", "On Turn Start", "Fires at the start of every turn.",
                 {pin("out","exec","out")}, {}),
        node_def("OnTestFire", "On Test Fire", "Manual entry point used by the editor's Run button.",
                 {pin("out","exec","out")}, {}),
        node_def("OnColonyFounded", "On Colony Founded", "Fires when a colony is founded.",
                 {pin("out","exec","out")}, {}),
        node_def("OnUnitEntersTile", "On Unit Enters Tile", "Fires when a unit enters a tile (e.g. a rumor).",
                 {pin("out","exec","out")}, {param("terrain","text")}),
        node_def("OnBellsThreshold", "On Bells Threshold", "Fires when liberty bells reach a founding-father cost.",
                 {pin("out","exec","out")}, {}),
    }));
    cats.arr.push_back(category("Flow", {
        node_def("Branch", "Branch (if)", "Routes flow by a boolean condition.",
                 {pin("in","exec","in"), pin("cond","data","in","bool"),
                  pin("true","exec","out"), pin("false","exec","out")}, {}),
        node_def("Sequence", "Sequence", "Fires its outputs in order.",
                 {pin("in","exec","in"), pin("0","exec","out"), pin("1","exec","out"),
                  pin("2","exec","out")}, {}),
        node_def("Roll", "Roll (random)", "A random integer in [min,max], rolled once per run.",
                 {pin("min","data","in","number"), pin("max","data","in","number"),
                  pin("value","data","out","number")},
                 {param("min","number"), param("max","number")}),
    }));
    cats.arr.push_back(category("Data", {
        node_def("Constant", "Constant", "A fixed number.",
                 {pin("value","data","out","number")}, {param("value","number")}),
        node_def("GetState", "Get Game State", "Reads a value from the live game.",
                 {pin("value","data","out","number")},
                 {param("path","binding")}),
        node_def("Math", "Math", "a (op) b.",
                 {pin("a","data","in","number"), pin("b","data","in","number"),
                  pin("value","data","out","number")},
                 {param("op","select",{"+","-","*","/","%"})}),
        node_def("Compare", "Compare", "a (op) b -> bool.",
                 {pin("a","data","in","number"), pin("b","data","in","number"),
                  pin("value","data","out","bool")},
                 {param("op","select",{">",">=","<","<=","==","!="})}),
    }));
    cats.arr.push_back(category("Actions", {
        node_def("GrantGold", "Grant Gold", "Adds gold to a power's treasury.",
                 {pin("in","exec","in"), pin("amount","data","in","number"), pin("out","exec","out")},
                 {param("power","select",{"0","1","2","3"})}),
        node_def("SetTax", "Set Tax Rate", "Sets a power's tax rate (%).",
                 {pin("in","exec","in"), pin("value","data","in","number"), pin("out","exec","out")},
                 {param("power","select",{"0","1","2","3"})}),
        node_def("SetPrice", "Set Market Price", "Sets a good's European price.",
                 {pin("in","exec","in"), pin("value","data","in","number"), pin("out","exec","out")},
                 {param("good","select",{"Food","Sugar","Tobacco","Cotton","Furs","Lumber","Ore",
                  "Silver","Horses","Rum","Cigars","Cloth","Coats","Trade goods","Tools","Muskets"})}),
        node_def("AddColonyPop", "Add Colony Population", "Adds population to a colony (by index).",
                 {pin("in","exec","in"), pin("amount","data","in","number"), pin("out","exec","out")},
                 {param("colony","number")}),
        node_def("AddREF", "Add to King's Army", "Adds units to the Royal Expeditionary Force.",
                 {pin("in","exec","in"), pin("amount","data","in","number"), pin("out","exec","out")},
                 {param("kind","select",{"regulars","cavalry","manowar","artillery"})}),
        node_def("SpawnUnit", "Spawn Unit", "Creates a unit at the first colony for a power.",
                 {pin("in","exec","in"), pin("out","exec","out")},
                 {param("type","select",{"Colonists","Soldiers","Pioneers","Dragoons","Scouts",
                  "Treasure","Artillery","Wagon Train","Caravel","Galleon","Frigate","Man-O-War"}),
                  param("power","select",{"0","1","2","3"})}),
        node_def("StepTurn", "Advance Turn", "Runs one full game turn (the sim step).",
                 {pin("in","exec","in"), pin("out","exec","out")}, {}),
        node_def("Log", "Log Message", "Appends a message to the run log (player-facing effect note).",
                 {pin("in","exec","in"), pin("out","exec","out")}, {param("message","text")}),
    }));
    cats.arr.push_back(category("Dialog", {
        node_def("ShowPopup", "Show Popup", "Shows a dialog; each choice is an exec output pin.",
                 {pin("in","exec","in")},
                 {param("title","text"), param("body","text"), param("choices","text")}),
        node_def("Navigate", "Go To Screen", "Switches the active screen (in preview/play).",
                 {pin("in","exec","in"), pin("out","exec","out")}, {param("screen","text")}),
    }));
    cats.arr.push_back(category("Notes", {
        node_def("Comment", "Comment", "A note on the canvas. Has no effect when the graph runs.",
                 {}, {param("text","text")}),
    }));

    root.obj["categories"] = cats;
    return root;
}

// ---- graph CRUD ----
std::vector<std::string> list_graphs() {
    std::vector<std::string> ids; std::error_code ec;
    for (const auto& e : fs::directory_iterator(GRAPH_DIR, ec)) {
        if (!e.is_regular_file()) continue;
        std::string fn = e.path().filename().string();
        if (fn.size() > 5 && fn.compare(fn.size() - 5, 5, ".json") == 0)
            ids.push_back(fn.substr(0, fn.size() - 5));
    }
    std::sort(ids.begin(), ids.end());
    return ids;
}
JsonValue load_graph(const std::string& id) {
    return json_parse_file(std::string(GRAPH_DIR) + "/" + id + ".json");
}
void save_graph(const std::string& id, const JsonValue& graph) {
    std::error_code ec; fs::create_directories(GRAPH_DIR, ec);
    std::ofstream f(std::string(GRAPH_DIR) + "/" + id + ".json", std::ios::binary);
    if (!f) throw std::runtime_error("engine: cannot write graph " + id);
    f << json_dump(graph);
}

// ---- screen CRUD (same shape as graphs) ----
namespace { const char* SCREEN_DIR = "data_extracted/engine/screens"; }
std::vector<std::string> list_screens() {
    std::vector<std::string> ids; std::error_code ec;
    for (const auto& e : fs::directory_iterator(SCREEN_DIR, ec)) {
        if (!e.is_regular_file()) continue;
        std::string fn = e.path().filename().string();
        if (fn.size() > 5 && fn.compare(fn.size() - 5, 5, ".json") == 0)
            ids.push_back(fn.substr(0, fn.size() - 5));
    }
    std::sort(ids.begin(), ids.end());
    return ids;
}
JsonValue load_screen(const std::string& id) {
    return json_parse_file(std::string(SCREEN_DIR) + "/" + id + ".json");
}
void save_screen(const std::string& id, const JsonValue& screen) {
    std::error_code ec; fs::create_directories(SCREEN_DIR, ec);
    std::ofstream f(std::string(SCREEN_DIR) + "/" + id + ".json", std::ios::binary);
    if (!f) throw std::runtime_error("engine: cannot write screen " + id);
    f << json_dump(screen);
}

// ---- writable bindings (State Inspector) ----
bool set_binding(const std::string& path, double value, EngineCtx& cx) {
    GameState& g = cx.g; World& w = cx.w;
    if (path == "game.year")   { g.year = (int)value; return true; }
    if (path == "game.season") { g.season = (int)value; return true; }
    if (path.rfind("power", 0) == 0) {
        int p = path[5] - '0'; size_t dot = path.find('.');
        if (p >= 0 && p < 4 && dot != std::string::npos) {
            std::string f = path.substr(dot + 1);
            if (f == "gold") { g.powers[p].gold = (long)value; return true; }
            if (f == "tax")  { g.powers[p].tax = (int)value; return true; }
        }
    }
    if (path.rfind("colony", 0) == 0) {
        size_t dot = path.find('.'); int c = std::atoi(path.c_str() + 6);
        if (dot != std::string::npos && c >= 0 && c < (int)w.colonies.size() &&
            path.substr(dot + 1) == "population") { w.colonies[c].population = (int)value; return true; }
    }
    if (path.rfind("price", 0) == 0) {
        int gi = std::atoi(path.c_str() + 6);
        if (gi >= 0 && gi < NGOODS) { g.price_base[gi] = (int)value; return true; }
    }
    return false;
}

// ---- binding resolver ----
JsonValue resolve_binding(const std::string& path, const EngineCtx& cx) {
    const GameState& g = cx.g; const World& w = cx.w;
    auto num = [](double v) { return json_num(v); };
    if (path == "game.year")    return num(g.year);
    if (path == "game.season")  return num(g.season);
    if (path == "game.turn")    return num((double)g.turn);
    if (path == "game.difficulty") return num(g.difficulty);
    if (path == "ref.regulars") return num(g.ref.regulars);
    if (path == "ref.cavalry")  return num(g.ref.cavalry);
    if (path == "ref.manowar")  return num(g.ref.manowar);
    if (path == "ref.artillery")return num(g.ref.artillery);
    if (path == "colonies.count") return num((double)w.colonies.size());
    if (path == "units.count")    return num((double)w.units.size());
    // power<N>.<field>
    if (path.rfind("power", 0) == 0) {
        int p = path[5] - '0'; size_t dot = path.find('.');
        if (p >= 0 && p < 4 && dot != std::string::npos) {
            std::string f = path.substr(dot + 1);
            if (f == "gold") return num((double)g.powers[p].gold);
            if (f == "tax")  return num(g.powers[p].tax);
            if (f == "royal_money") return num((double)g.powers[p].royal_money);
            if (f == "crosses") return num(g.powers[p].crosses_accum);
        }
    }
    // colony<N>.<field>
    if (path.rfind("colony", 0) == 0) {
        size_t dot = path.find('.');
        int c = std::atoi(path.c_str() + 6);
        if (dot != std::string::npos && c >= 0 && c < (int)w.colonies.size()) {
            std::string f = path.substr(dot + 1);
            if (f == "population") return num(w.colonies[c].population);
            if (f == "sol")        return num(vc::sim::sol_pct(w.colonies[c]));
        }
    }
    // price.<good index>
    if (path.rfind("price", 0) == 0) {
        int gi = std::atoi(path.c_str() + 6);
        if (gi >= 0 && gi < NGOODS) return num(g.price_base[gi]);
    }
    return JsonValue{};   // Null
}

// ---- graph interpreter ----
namespace {
struct Runner {
    const JsonValue& graph;
    EngineCtx& cx;
    std::map<std::string, const JsonValue*> nodes;          // id -> node
    std::map<std::string, JsonValue> dcache;                // "node|pin" -> data value
    JsonValue log, effects;
    std::string gotoScreen;
    int steps = 0;

    Runner(const JsonValue& gr, EngineCtx& c) : graph(gr), cx(c) {
        log.type = JsonValue::Array; effects.type = JsonValue::Array;
        if (const JsonValue* ns = graph.find("nodes"))
            for (const JsonValue& n : ns->arr)
                if (const JsonValue* id = n.find("id")) nodes[id->str] = &n;
    }
    const JsonValue* node(const std::string& id) {
        auto it = nodes.find(id); return it == nodes.end() ? nullptr : it->second;
    }
    std::string ptype(const JsonValue& n) {
        const JsonValue* t = n.find("type"); return t ? t->str : "";
    }
    JsonValue pget(const JsonValue& n, const char* key, JsonValue def = {}) {
        const JsonValue* ps = n.find("params"); if (!ps) return def;
        const JsonValue* v = ps->find(key); return v ? *v : def;
    }
    void logmsg(const std::string& m) { log.arr.push_back(json_str(m)); }
    void effect(const std::string& m) { effects.arr.push_back(json_str(m)); }

    // The (fromNode,fromPin) feeding a given input (toNode,toPin), or {} if unwired.
    bool incoming(const std::string& toNode, const std::string& toPin,
                  std::string& fromNode, std::string& fromPin) {
        const JsonValue* es = graph.find("edges"); if (!es) return false;
        for (const JsonValue& e : es->arr) {
            const JsonValue* to = e.find("to"); const JsonValue* fr = e.find("from");
            if (!to || !fr) continue;
            const JsonValue* tn = to->find("node"); const JsonValue* tp = to->find("pin");
            if (tn && tp && tn->str == toNode && tp->str == toPin) {
                const JsonValue* fn = fr->find("node"); const JsonValue* fp = fr->find("pin");
                if (fn && fp) { fromNode = fn->str; fromPin = fp->str; return true; }
            }
        }
        return false;
    }
    // Evaluate a node's data-output pin (memoized).
    JsonValue eval_out(const std::string& nodeId, const std::string& pin) {
        std::string key = nodeId + "|" + pin;
        auto it = dcache.find(key); if (it != dcache.end()) return it->second;
        JsonValue out;
        const JsonValue* n = node(nodeId);
        if (n) {
            std::string t = ptype(*n);
            if (t == "Constant")      out = json_num(as_num(pget(*n, "value")));
            else if (t == "GetState") out = resolve_binding(pget(*n, "path").str, cx);
            else if (t == "Roll") {
                int lo = (int)as_num(eval_in(nodeId, "min", pget(*n, "min")));
                int hi = (int)as_num(eval_in(nodeId, "max", pget(*n, "max")));
                out = json_num(cx.rng(lo, hi));
            } else if (t == "Math") {
                double a = as_num(eval_in(nodeId, "a")), b = as_num(eval_in(nodeId, "b"));
                std::string op = pget(*n, "op").str; double r = 0;
                if (op == "+") r = a + b; else if (op == "-") r = a - b;
                else if (op == "*") r = a * b; else if (op == "/") r = b ? a / b : 0;
                else if (op == "%") r = b ? (double)((long)a % (long)b) : 0;
                out = json_num(r);
            } else if (t == "Compare") {
                double a = as_num(eval_in(nodeId, "a")), b = as_num(eval_in(nodeId, "b"));
                std::string op = pget(*n, "op").str; bool r = false;
                if (op == ">") r = a > b; else if (op == ">=") r = a >= b;
                else if (op == "<") r = a < b; else if (op == "<=") r = a <= b;
                else if (op == "==") r = a == b; else if (op == "!=") r = a != b;
                JsonValue bv; bv.type = JsonValue::Bool; bv.b = r; out = bv;
            }
        }
        dcache[key] = out; return out;
    }
    // Evaluate an input data pin: wired source, else the same-named param, else def.
    JsonValue eval_in(const std::string& nodeId, const std::string& pin, JsonValue def = {}) {
        std::string fn, fp;
        if (incoming(nodeId, pin, fn, fp)) return eval_out(fn, fp);
        const JsonValue* n = node(nodeId);
        if (n) { JsonValue pv = pget(*n, pin.c_str()); if (pv.type != JsonValue::Null) return pv; }
        return def;
    }
    // Follow the exec edge out of (nodeId,pin) and execute the target.
    JsonValue follow(const std::string& nodeId, const std::string& pin, JsonValue& popup) {
        const JsonValue* es = graph.find("edges"); if (!es) return {};
        for (const JsonValue& e : es->arr) {
            const JsonValue* fr = e.find("from");
            if (!fr) continue;
            const JsonValue* fn = fr->find("node"); const JsonValue* fp = fr->find("pin");
            if (fn && fp && fn->str == nodeId && fp->str == pin) {
                const JsonValue* to = e.find("to"); const JsonValue* tn = to ? to->find("node") : nullptr;
                if (tn) return exec(tn->str, popup);
            }
        }
        return {};
    }
    // Execute a node and return the node id it paused at (for ShowPopup), or "".
    JsonValue exec(const std::string& nodeId, JsonValue& popup) {
        if (++steps > 1000) { logmsg("! step limit reached"); return {}; }
        const JsonValue* n = node(nodeId); if (!n) return {};
        std::string t = ptype(*n);
        logmsg("exec " + t + " (" + nodeId + ")");
        if (t == "Sequence") { follow(nodeId, "0", popup); follow(nodeId, "1", popup); return follow(nodeId, "2", popup); }
        if (t.rfind("On", 0) == 0) return follow(nodeId, "out", popup);   // any trigger = entry passthrough
        if (t == "Branch") {
            bool c = as_num(eval_in(nodeId, "cond")) != 0;
            return follow(nodeId, c ? "true" : "false", popup);
        }
        if (t == "GrantGold") {
            int p = std::atoi(pget(*n, "power").str.c_str());
            long amt = (long)as_num(eval_in(nodeId, "amount"));
            if (p >= 0 && p < 4) { cx.g.powers[p].gold += amt;
                effect("power" + std::to_string(p) + ".gold += " + std::to_string(amt)); }
            return follow(nodeId, "out", popup);
        }
        if (t == "SetTax") {
            int p = std::atoi(pget(*n, "power").str.c_str());
            int v = (int)as_num(eval_in(nodeId, "value"));
            if (p >= 0 && p < 4) { cx.g.powers[p].tax = v;
                effect("power" + std::to_string(p) + ".tax = " + std::to_string(v)); }
            return follow(nodeId, "out", popup);
        }
        if (t == "SetPrice") {
            // good param is a name; map to index via the catalog order
            static const char* G[16] = {"Food","Sugar","Tobacco","Cotton","Furs","Lumber","Ore",
                "Silver","Horses","Rum","Cigars","Cloth","Coats","Trade goods","Tools","Muskets"};
            std::string gn = pget(*n, "good").str; int gi = -1;
            for (int i = 0; i < 16; ++i) if (gn == G[i]) gi = i;
            int v = (int)as_num(eval_in(nodeId, "value"));
            if (gi >= 0) { cx.g.price_base[gi] = v; effect(gn + " price = " + std::to_string(v)); }
            return follow(nodeId, "out", popup);
        }
        if (t == "AddColonyPop") {
            int c = (int)as_num(pget(*n, "colony"));
            int amt = (int)as_num(eval_in(nodeId, "amount"));
            if (c >= 0 && c < (int)cx.w.colonies.size()) { cx.w.colonies[c].population += amt;
                effect("colony" + std::to_string(c) + ".population += " + std::to_string(amt)); }
            return follow(nodeId, "out", popup);
        }
        if (t == "AddREF") {
            std::string k = pget(*n, "kind").str; int a = (int)as_num(eval_in(nodeId, "amount"));
            if (k == "regulars") cx.g.ref.regulars += a; else if (k == "cavalry") cx.g.ref.cavalry += a;
            else if (k == "manowar") cx.g.ref.manowar += a; else if (k == "artillery") cx.g.ref.artillery += a;
            effect("REF " + k + " += " + std::to_string(a));
            return follow(nodeId, "out", popup);
        }
        if (t == "SpawnUnit") {
            static const char* UN[12] = {"Colonists","Soldiers","Pioneers","Dragoons","Scouts",
                "Treasure","Artillery","Wagon Train","Caravel","Galleon","Frigate","Man-O-War"};
            static const int UT[12] = {0,1,2,4,5,10,11,12,13,15,17,18};
            std::string nm = pget(*n, "type").str; int type = 0;
            for (int i = 0; i < 12; ++i) if (nm == UN[i]) type = UT[i];
            int p = std::atoi(pget(*n, "power").str.c_str());
            vc::sim::Unit u; u.type = type; u.owner = p; u.alive = true;
            if (!cx.colony_xy.empty()) { u.x = cx.colony_xy[0].first; u.y = cx.colony_xy[0].second; }
            cx.w.units.push_back(u);
            effect("spawned " + nm + " for power " + std::to_string(p));
            return follow(nodeId, "out", popup);
        }
        if (t == "StepTurn") {
            vc::sim::step_turn(cx.g, cx.w, cx.rng, 0);
            effect("advanced to year " + std::to_string(cx.g.year));
            return follow(nodeId, "out", popup);
        }
        if (t == "Navigate") { gotoScreen = pget(*n, "screen").str; effect("go to screen: " + gotoScreen); return follow(nodeId, "out", popup); }
        if (t == "Log") { effect(pget(*n, "message").str); return follow(nodeId, "out", popup); }
        if (t == "ShowPopup") {
            popup.type = JsonValue::Object;
            popup.obj["title"] = json_str(pget(*n, "title").str);
            popup.obj["body"]  = json_str(pget(*n, "body").str);
            popup.obj["node"]  = json_str(nodeId);
            JsonValue ch; ch.type = JsonValue::Array;
            // choices: newline- or comma-separated; each becomes an exec pin
            std::string raw = pget(*n, "choices").str; std::string cur;
            auto push = [&]{ if (!cur.empty()) { ch.arr.push_back(json_str(cur)); cur.clear(); } };
            for (char c : raw) { if (c == '\n' || c == ',') push(); else cur += c; }
            push();
            popup.obj["choices"] = ch;
            return json_str(nodeId);     // pause
        }
        return follow(nodeId, "out", popup);
    }
};
} // namespace

JsonValue run_graph(const JsonValue& graph, EngineCtx& cx,
                    const std::string& from_node, const std::string& choice) {
    Runner r(graph, cx);
    JsonValue popup;   // filled if a ShowPopup is hit
    if (!from_node.empty()) {
        r.follow(from_node, choice, popup);            // resume down the chosen pin
    } else {
        // entry = first Trigger node, else first node
        std::string entry;
        if (const JsonValue* ns = graph.find("nodes")) {
            for (const JsonValue& n : ns->arr) {
                const JsonValue* t = n.find("type");
                if (t && t->str.rfind("On", 0) == 0) {           // any trigger node is an entry
                    if (const JsonValue* id = n.find("id")) { entry = id->str; break; }
                }
            }
            if (entry.empty() && !ns->arr.empty())
                if (const JsonValue* id = ns->arr[0].find("id")) entry = id->str;
        }
        if (!entry.empty()) r.exec(entry, popup);
    }
    JsonValue out; out.type = JsonValue::Object;
    out.obj["log"] = r.log; out.obj["effects"] = r.effects;
    out.obj["popup"] = popup.type == JsonValue::Object ? popup : JsonValue{};
    if (!r.gotoScreen.empty()) out.obj["goto"] = json_str(r.gotoScreen);
    return out;
}

} // namespace forge
