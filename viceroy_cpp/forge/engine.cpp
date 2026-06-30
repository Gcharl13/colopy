// forge/engine.cpp -- see engine.hpp. A small visual-scripting VM + binding resolver.
#include "engine.hpp"

#include "economy.hpp"          // sol_pct, colony_economic_step
#include "unit.hpp"             // unit_stats
#include "combat.hpp"           // resolve_land, combat_odds
#include "natives.hpp"          // apply_tension
#include "founding_fathers.hpp" // ff_available, ff_cost
#include "diplomacy.hpp"        // declare_war / at_war
#include "revolution.hpp"       // can_declare_independence, tory_uprising
#include "turn.hpp"             // advance_cadence, game_over
#include "market.hpp"           // price_drift
#include "ref.hpp"              // ref_accrue_rate
#include "scoring.hpp"          // score_difficulty_mult

#include <algorithm>
#include <cstdio>
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

// Real game message strings (GAME.TXT @sections), loaded once. A ShowPopup with a
// `textKey` shows the game's own words verbatim instead of authored prose.
const char* GAME_TEXT_FILE = "data_extracted/text/GAME_sections.json";
const std::map<std::string, std::string>& game_text_table() {
    static std::map<std::string, std::string> T; static bool loaded = false;
    if (!loaded) { loaded = true;
        try { JsonValue d = json_parse_file(GAME_TEXT_FILE);
            if (d.type == JsonValue::Object)
                for (auto& kv : d.obj) if (kv.second.type == JsonValue::String) T[kv.first] = kv.second.str;
        } catch (...) {}
    }
    return T;
}
std::string game_text(const std::string& key) {
    const auto& T = game_text_table(); auto it = T.find(key);
    return it == T.end() ? std::string() : it->second;
}

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
    // The whole game's event surface -- one trigger per spec system (spec/systems/*.md).
    // Every trigger is an entry passthrough; wire it into that system's logic.
    cats.arr.push_back(category("Game Events", {
        node_def("OnTurnEnd", "On Turn End", "End of a turn, after all powers act (cadence advance).",
                 {pin("out","exec","out")}, {}),
        node_def("OnNewYear", "On New Year", "Fires when the year advances (turn_dispatch cadence).",
                 {pin("out","exec","out")}, {}),
        node_def("OnTaxDemand", "On King's Tax Check", "The King's periodic tax-raise attempt (king.md, turn>=30).",
                 {pin("out","exec","out")}, {}),
        node_def("OnMercenaryOffer", "On Mercenary Offer", "A mercenary force is offered for gold (mercenary.md).",
                 {pin("out","exec","out")}, {}),
        node_def("OnSoLThreshold", "On Sons-of-Liberty Threshold", "National SoL meter crosses a % (revolution.md).",
                 {pin("out","exec","out")}, {param("percent","number")}),
        node_def("OnIndependenceDeclared", "On Independence Declared", "The colonies declare the War of Independence.",
                 {pin("out","exec","out")}, {}),
        node_def("OnREFArrival", "On REF Arrival", "The Royal Expeditionary Force lands (SoL>=75).",
                 {pin("out","exec","out")}, {}),
        node_def("OnInterventionForce", "On Intervention Force", "A foreign power intervenes on the rebel side.",
                 {pin("out","exec","out")}, {}),
        node_def("OnToryUprising", "On Tory Uprising", "Loyalist militia rise during the WoI (tory_uprising.md).",
                 {pin("out","exec","out")}, {}),
        node_def("OnSpanishSuccession", "On War of Spanish Succession", "Weakest rival withdraws (spanish_succession.md, SoL<75).",
                 {pin("out","exec","out")}, {}),
        node_def("OnFoundingFatherOffered", "On Founding Father Offered", "Congress offers the next Father (founding_fathers.md).",
                 {pin("out","exec","out")}, {}),
        node_def("OnImmigrantArrives", "On Immigrant Arrives", "Crosses fill the threshold; an emigrant waits at the docks.",
                 {pin("out","exec","out")}, {}),
        node_def("OnLostCityEntered", "On Lost City Entered", "A unit enters a lost-city rumor tile (events.md).",
                 {pin("out","exec","out")}, {}),
        node_def("OnNativeRaid", "On Native Raid", "A settlement's alarm triggers a raid (natives.md, alarm>=128).",
                 {pin("out","exec","out")}, {}),
        node_def("OnNativeAttitude", "On Native Attitude Change", "A tribe's attitude band shifts (Content..War).",
                 {pin("out","exec","out")}, {}),
        node_def("OnMissionAttempt", "On Mission Attempt", "A missionary attempts a conversion (natives.md).",
                 {pin("out","exec","out")}, {}),
        node_def("OnPriceDrift", "On Market Price Drift", "Per-turn European price drift (market.md).",
                 {pin("out","exec","out")}, {}),
        node_def("OnColonyProduction", "On Colony Production", "A colony's per-turn economic step (colony.md).",
                 {pin("out","exec","out")}, {}),
        node_def("OnGameOver", "On Game Over", "The game ends (year>=1725 or independence resolved); score is tallied.",
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
        node_def("FireEvent", "Fire Event Graph",
                 "Runs another graph by id against the same game (its effects are collected). "
                 "This is how the turn loop wires the whole game together -- it fires the event graphs.",
                 {pin("in","exec","in"), pin("out","exec","out")}, {param("graph","text")}),
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
        node_def("RandomChance", "Random Chance", "True with the given percent probability.",
                 {pin("value","data","out","bool")}, {param("percent","number")}),
        node_def("HasFoundingFather", "Has Founding Father",
                 "True if power 0's Congress holds the given Founding Father (id 0..24).",
                 {pin("value","data","out","bool")}, {param("father","number")}),
        node_def("CanDeclareIndependence", "Can Declare Independence",
                 "True when the national Sons-of-Liberty meter reaches 50% (revolution.hpp).",
                 {pin("value","data","out","bool")}, {}),
        node_def("FoundingFatherCost", "Founding Father Cost",
                 "The bell cost of the next Founding Father at the current year (ff_cost).",
                 {pin("value","data","out","number")}, {}),
        node_def("CombatOdds", "Combat Odds %",
                 "Attacker win chance ATK/(ATK+DEF) as a percent (combat.hpp combat_odds).",
                 {pin("atk","data","in","number"), pin("def","data","in","number"),
                  pin("value","data","out","number")},
                 {param("atk","number"), param("def","number")}),
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
        node_def("ResolveCombat", "Resolve Combat",
                 "Resolves a land attack between two on-map units (by index) via the sim "
                 "combat model; the loser is demoted/captured/destroyed.",
                 {pin("in","exec","in"), pin("out","exec","out")},
                 {param("attacker","number"), param("defender","number")}),
        node_def("ChangeNativeTension", "Change Native Tension",
                 "Applies a tension delta via the sim rule (Pocahontas halves increases); "
                 "clamped to 0..100.",
                 {pin("in","exec","in"), pin("amount","data","in","number"), pin("out","exec","out")},
                 {param("amount","number")}),
        node_def("GiveFoundingFather", "Give Founding Father",
                 "Grants a Founding Father (by id 0..24; Pocahontas is 16) to power 0's Congress.",
                 {pin("in","exec","in"), pin("out","exec","out")}, {param("father","number")}),
        node_def("AddBoycott", "Boycott Good",
                 "Marks a good as boycotted in Europe (it can no longer be sold).",
                 {pin("in","exec","in"), pin("out","exec","out")},
                 {param("good","select",{"Food","Sugar","Tobacco","Cotton","Furs","Lumber","Ore",
                  "Silver","Horses","Rum","Cigars","Cloth","Coats","Trade goods","Tools","Muskets"})}),
        node_def("DeclareWar", "Declare War",
                 "Sets two powers at war (symmetric) in the diplomacy matrix.",
                 {pin("in","exec","in"), pin("out","exec","out")},
                 {param("a","select",{"0","1","2","3"}), param("b","select",{"0","1","2","3"})}),
        node_def("GrantImmigrant", "Grant Immigrant",
                 "Places a colonist type into a power's first free emigration dock slot.",
                 {pin("in","exec","in"), pin("out","exec","out")},
                 {param("type","select",{"Colonists","Soldiers","Pioneers","Scouts"}),
                  param("power","select",{"0","1","2","3"})}),
        node_def("AdvanceCadence", "Advance Cadence", "Advances the turn/season/year (turn.hpp advance_cadence).",
                 {pin("in","exec","in"), pin("out","exec","out")}, {}),
        node_def("SetNationalSoL", "Set National Sons of Liberty", "Sets the national SoL meter 0..100 (the Bolivar meter).",
                 {pin("in","exec","in"), pin("value","data","in","number"), pin("out","exec","out")},
                 {param("value","number")}),
        node_def("DeclareIndependence", "Declare Independence",
                 "Declares the War of Independence for a power (sets the WoI flag + rebel power).",
                 {pin("in","exec","in"), pin("out","exec","out")}, {param("power","select",{"0","1","2","3"})}),
        node_def("MobilizeREF", "Mobilize the King's Army",
                 "Grows the Royal Expeditionary Force by its accrual rate (ref.hpp).",
                 {pin("in","exec","in"), pin("out","exec","out")}, {}),
        node_def("HireMercenaries", "Hire Mercenaries",
                 "Spawns a veteran mercenary stack for a power at its first colony (mercenary.md).",
                 {pin("in","exec","in"), pin("out","exec","out")},
                 {param("power","select",{"0","1","2","3"}), param("kind","select",{"Wartime","Peacetime"})}),
        node_def("WageSpanishSuccession", "War of Spanish Succession",
                 "Withdraws the weakest rival power; its colonies pass to the strongest (spanish_succession.md).",
                 {pin("in","exec","in"), pin("out","exec","out")}, {}),
        node_def("SpawnToryMilitia", "Spawn Tory Militia",
                 "Spawns loyalist Soldiers near a colony during the WoI (tory_uprising.md).",
                 {pin("in","exec","in"), pin("out","exec","out")}, {param("colony","number")}),
        node_def("OfferFoundingFather", "Offer Founding Father",
                 "Logs the next Father's bell cost from the curve (founding_fathers.hpp ff_cost).",
                 {pin("in","exec","in"), pin("out","exec","out")}, {}),
        node_def("DriftPrices", "Drift Market Prices", "Runs one per-turn European price drift (market.hpp).",
                 {pin("in","exec","in"), pin("out","exec","out")}, {}),
        node_def("ScoreGame", "Tally Score",
                 "Computes the final game score (scoring.hpp) into game.score.",
                 {pin("in","exec","in"), pin("out","exec","out")}, {}),
        node_def("ColonyStep", "Run Colony Production",
                 "Runs one per-turn economic step for a colony (economy.hpp colony_economic_step).",
                 {pin("in","exec","in"), pin("out","exec","out")}, {param("colony","number")}),
        node_def("PromoteUnit", "Promote / Train Unit",
                 "Upgrades an on-map unit (by index) to a trained type, e.g. Soldiers -> "
                 "Continental Army (training.md).",
                 {pin("in","exec","in"), pin("out","exec","out")},
                 {param("unit","number"),
                  param("to","select",{"Soldiers","Dragoons","Continental Army","Continental Cavalry","Veteran Soldiers"})}),
        node_def("Log", "Log Message", "Appends a message to the run log (player-facing effect note).",
                 {pin("in","exec","in"), pin("out","exec","out")}, {param("message","text")}),
    }));
    cats.arr.push_back(category("Dialog", {
        node_def("ShowPopup", "Show Popup",
                 "Shows a dialog; each choice is an exec output pin. textKey (e.g. @LOSTCITY3) "
                 "shows that real GAME.TXT message verbatim; textKeys (a list like "
                 "@RAIDGOLD,@RAIDSTORES,@RAIDBURN) captures an event's many messages -- one is "
                 "picked per run, as in the game. woodcut/speaker are the popup's sprite channels "
                 "(spec/ui/popups.md): woodcut = the scene illustration (e.g. WDCUT04 / Colony "
                 "Burning), speaker = the portrait (e.g. King, Native Chief).",
                 {pin("in","exec","in")},
                 {param("title","text"), param("body","text"), param("choices","text"),
                  param("textKey","text"), param("textKeys","text"),
                  param("woodcut","text"), param("speaker","text")}),
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
    if (path == "natives.tension") {
        int t = (int)value; cx.x.tension = t < 0 ? 0 : t > 100 ? 100 : t; return true;
    }
    if (path == "revolution.sol") {
        int t = (int)value; cx.x.national_sol = t < 0 ? 0 : t > 100 ? 100 : t; return true;
    }
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
    if (path == "natives.tension") return num(cx.x.tension);
    if (path == "revolution.sol")      return num(cx.x.national_sol);
    if (path == "revolution.declared") return num(cx.x.woi_declared ? 1 : 0);
    if (path == "revolution.rebel")    return num(cx.x.rebel_power);
    if (path == "succession.seceded")  return num(cx.x.seceded_power);
    if (path == "game.score")          return num((double)cx.x.score);
    if (path == "ff.count") {                       // popcount of acquired fathers
        int c = 0; for (uint32_t b = cx.x.ff_owned; b; b &= b - 1) ++c; return num(c);
    }
    // ff.<id> -> 1 if that founding father is held, else 0
    if (path.rfind("ff.", 0) == 0) {
        int id = std::atoi(path.c_str() + 3);
        if (id >= 0 && id < 32) return num((cx.x.ff_owned >> id) & 1u);
    }
    // boycott.<good index> -> 1 if boycotted
    if (path.rfind("boycott.", 0) == 0) {
        int gi = std::atoi(path.c_str() + 8);
        if (gi >= 0 && gi < 16) return num((cx.x.boycotts >> gi) & 1u);
    }
    // war.<a>.<b> -> 1 if powers a,b are at war
    if (path.rfind("war.", 0) == 0) {
        int a = -1, b = -1;
        if (std::sscanf(path.c_str() + 4, "%d.%d", &a, &b) == 2 &&
            a >= 0 && a < 4 && b >= 0 && b < 4)
            return num(vc::sim::at_war(cx.x.diplo, a, b) ? 1 : 0);
    }
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
            if (f == "bells")      return num(w.colonies[c].bells_per_turn);
            if (f == "hammers")    return num(w.colonies[c].hammers_per_turn);
            if (f == "food")       return num(w.colonies[c].food_per_turn);
            if (f == "crosses")    return num(w.colonies[c].crosses_output);
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
            } else if (t == "RandomChance") {
                int pct = (int)as_num(pget(*n, "percent"));
                JsonValue bv; bv.type = JsonValue::Bool; bv.b = cx.rng(1, 100) <= pct; out = bv;
            } else if (t == "HasFoundingFather") {
                int id = (int)as_num(pget(*n, "father"));
                JsonValue bv; bv.type = JsonValue::Bool;
                bv.b = id >= 0 && id < 32 && ((cx.x.ff_owned >> id) & 1u); out = bv;
            } else if (t == "CanDeclareIndependence") {
                JsonValue bv; bv.type = JsonValue::Bool;
                bv.b = vc::sim::can_declare_independence(cx.x.national_sol); out = bv;
            } else if (t == "FoundingFatherCost") {
                int cnt = 0; for (uint32_t b = cx.x.ff_owned; b; b &= b - 1) ++cnt;
                out = json_num(vc::sim::ff_cost(cx.g.difficulty, cx.g.year, cnt, true, cx.x.woi_declared, cx.rd));
            } else if (t == "CombatOdds") {
                int a = (int)as_num(eval_in(nodeId, "atk")), b = (int)as_num(eval_in(nodeId, "def"));
                out = json_num((int)(vc::sim::combat_odds(a, b) * 100));
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
            vc::sim::step_turn(cx.g, cx.w, cx.rng, 0, cx.rd);
            effect("advanced to year " + std::to_string(cx.g.year));
            return follow(nodeId, "out", popup);
        }
        if (t == "ResolveCombat") {
            int ai = (int)as_num(pget(*n, "attacker")), di = (int)as_num(pget(*n, "defender"));
            auto& U = cx.w.units;
            if (ai >= 0 && ai < (int)U.size() && di >= 0 && di < (int)U.size() && ai != di &&
                U[ai].alive && U[di].alive) {
                int tid = cx.w.terrain_id(U[di].x, U[di].y);
                int tdef = vc::sim::terrain_defense_value(cx.rd, tid < 0 ? 0 : tid);
                vc::sim::CombatResult cr = vc::sim::resolve_land(
                    cx.rd, U[ai], U[di], tdef, 0, cx.g.difficulty,
                    U[ai].owner == 0, U[di].owner == 0, cx.rng);
                int li = cr.attacker_won ? di : ai;     // loser
                int wi = cr.attacker_won ? ai : di;     // winner
                if (cr.loser_outcome < 0) { U[li].alive = false;
                    effect("unit " + std::to_string(li) + " destroyed"); }
                else { U[li].type = cr.loser_outcome; if (cr.captured) U[li].owner = U[wi].owner;
                    effect("unit " + std::to_string(li) + (cr.captured ? " captured" : " demoted")); }
                effect(std::string("combat: ") + (cr.attacker_won ? "attacker" : "defender") +
                       " won (" + std::to_string(cr.atk_str) + " vs " + std::to_string(cr.def_str) + ")");
            } else effect("ResolveCombat: invalid unit indices");
            return follow(nodeId, "out", popup);
        }
        if (t == "ChangeNativeTension") {
            int delta = (int)as_num(eval_in(nodeId, "amount"));
            bool poca = (cx.x.ff_owned >> 16) & 1u;
            cx.x.tension = vc::sim::apply_tension(cx.x.tension, delta, false, poca);
            effect("native tension = " + std::to_string(cx.x.tension));
            return follow(nodeId, "out", popup);
        }
        if (t == "GiveFoundingFather") {
            int id = (int)as_num(pget(*n, "father"));
            if (id >= 0 && id < 32) {
                if (vc::sim::ff_available(cx.x.ff_owned, id)) {
                    cx.x.ff_owned |= (1u << id);
                    effect("founding father " + std::to_string(id) + " joined Congress");
                } else effect("founding father " + std::to_string(id) + " already held");
            }
            return follow(nodeId, "out", popup);
        }
        if (t == "AddBoycott") {
            static const char* G[16] = {"Food","Sugar","Tobacco","Cotton","Furs","Lumber","Ore",
                "Silver","Horses","Rum","Cigars","Cloth","Coats","Trade goods","Tools","Muskets"};
            std::string gn = pget(*n, "good").str; int gi = -1;
            for (int i = 0; i < 16; ++i) if (gn == G[i]) gi = i;
            if (gi >= 0) { cx.x.boycotts |= (uint16_t)(1u << gi); effect(gn + " is now boycotted"); }
            return follow(nodeId, "out", popup);
        }
        if (t == "DeclareWar") {
            int a = std::atoi(pget(*n, "a").str.c_str()), b = std::atoi(pget(*n, "b").str.c_str());
            if (a >= 0 && a < 4 && b >= 0 && b < 4 && a != b) {
                vc::sim::declare_war(cx.x.diplo, a, b);
                effect("power " + std::to_string(a) + " declares war on power " + std::to_string(b));
            }
            return follow(nodeId, "out", popup);
        }
        if (t == "GrantImmigrant") {
            static const char* IN[4] = {"Colonists","Soldiers","Pioneers","Scouts"};
            static const int   IT[4] = {0, 1, 2, 5};
            std::string nm = pget(*n, "type").str; int type = 0;
            for (int i = 0; i < 4; ++i) if (nm == IN[i]) type = IT[i];
            int p = std::atoi(pget(*n, "power").str.c_str());
            if (p >= 0 && p < 4) {
                auto& dp = cx.g.powers[p].dock_pool; bool placed = false;
                for (int s = 0; s < 3; ++s) if (dp[s] < 0) { dp[s] = type; placed = true;
                    effect(nm + " waits on power " + std::to_string(p) + "'s dock (slot " +
                           std::to_string(s) + ")"); break; }
                if (!placed) effect("power " + std::to_string(p) + "'s dock is full");
            }
            return follow(nodeId, "out", popup);
        }
        if (t == "AdvanceCadence") {
            vc::sim::advance_cadence(cx.g);
            effect("cadence -> year " + std::to_string(cx.g.year) + " season " + std::to_string(cx.g.season));
            return follow(nodeId, "out", popup);
        }
        if (t == "SetNationalSoL") {
            int v = (int)as_num(eval_in(nodeId, "value"));
            cx.x.national_sol = v < 0 ? 0 : v > 100 ? 100 : v;
            effect("national Sons of Liberty = " + std::to_string(cx.x.national_sol));
            return follow(nodeId, "out", popup);
        }
        if (t == "DeclareIndependence") {
            int p = std::atoi(pget(*n, "power").str.c_str());
            cx.x.woi_declared = true; cx.x.rebel_power = (p >= 0 && p < 4) ? p : 0;
            effect("power " + std::to_string(cx.x.rebel_power) + " declares the War of Independence!");
            return follow(nodeId, "out", popup);
        }
        if (t == "MobilizeREF") {
            int r = vc::sim::ref_accrue_rate(cx.g.difficulty, cx.g.year, cx.rd);
            cx.g.ref.regulars += r;
            effect("King's Army mobilizes: +" + std::to_string(r) + " regulars");
            return follow(nodeId, "out", popup);
        }
        if (t == "HireMercenaries") {
            int p = std::atoi(pget(*n, "power").str.c_str());
            bool wartime = pget(*n, "kind").str == "Wartime";
            std::vector<int> types = wartime ? std::vector<int>{9, 7, 11} : std::vector<int>{4, 11};
            for (int ty : types) { vc::sim::Unit u; u.type = ty; u.owner = (p >= 0 && p < 4) ? p : 0; u.alive = true;
                if (!cx.colony_xy.empty()) { u.x = cx.colony_xy[0].first; u.y = cx.colony_xy[0].second; }
                cx.w.units.push_back(u); }
            effect(std::string(wartime ? "wartime" : "peacetime") + " mercenaries hired (" +
                   std::to_string(types.size()) + " veterans)");
            return follow(nodeId, "out", popup);
        }
        if (t == "WageSpanishSuccession") {
            int weak = -1; long best = 0;
            for (int p = 1; p < 4; ++p) { long s = cx.g.powers[p].gold; if (weak < 0 || s < best) { weak = p; best = s; } }
            cx.x.seceded_power = weak;
            effect("War of Spanish Succession: power " + std::to_string(weak) + " withdraws from the New World");
            return follow(nodeId, "out", popup);
        }
        if (t == "SpawnToryMilitia") {
            int c = (int)as_num(pget(*n, "colony"));
            vc::sim::Unit u; u.type = 1; u.owner = 0; u.alive = true;
            if (c >= 0 && c < (int)cx.colony_xy.size()) { u.x = cx.colony_xy[c].first; u.y = cx.colony_xy[c].second; }
            cx.w.units.push_back(u);
            effect("Tory militia (Soldiers) rise near colony " + std::to_string(c));
            return follow(nodeId, "out", popup);
        }
        if (t == "OfferFoundingFather") {
            int cnt = 0; for (uint32_t b = cx.x.ff_owned; b; b &= b - 1) ++cnt;
            int cost = vc::sim::ff_cost(cx.g.difficulty, cx.g.year, cnt, true, cx.x.woi_declared, cx.rd);
            effect("Continental Congress: next Father costs " + std::to_string(cost) + " liberty bells");
            return follow(nodeId, "out", popup);
        }
        if (t == "DriftPrices") {
            vc::sim::price_drift(cx.g, cx.rd);
            effect("European market prices drifted");
            return follow(nodeId, "out", popup);
        }
        if (t == "ColonyStep") {
            int c = (int)as_num(pget(*n, "colony"));
            if (c >= 0 && c < (int)cx.w.colonies.size()) {
                vc::sim::colony_economic_step(cx.w.colonies[c], cx.g.difficulty, cx.rd);
                effect("colony " + std::to_string(c) + " production: pop " +
                       std::to_string(cx.w.colonies[c].population) + ", bells " +
                       std::to_string(cx.w.colonies[c].bells_per_turn) + ", hammers " +
                       std::to_string(cx.w.colonies[c].hammers_per_turn));
            } else effect("ColonyStep: no colony " + std::to_string(c));
            return follow(nodeId, "out", popup);
        }
        if (t == "PromoteUnit") {
            static const char* PN[5] = {"Soldiers","Dragoons","Continental Army","Continental Cavalry","Veteran Soldiers"};
            static const int   PT[5] = {1, 4, 9, 7, 1};
            int ui = (int)as_num(pget(*n, "unit"));
            std::string nm = pget(*n, "to").str; int ty = 1;
            for (int i = 0; i < 5; ++i) if (nm == PN[i]) ty = PT[i];
            if (ui >= 0 && ui < (int)cx.w.units.size() && cx.w.units[ui].alive) {
                cx.w.units[ui].type = ty;
                effect("unit " + std::to_string(ui) + " promoted to " + nm);
            } else effect("PromoteUnit: no unit " + std::to_string(ui));
            return follow(nodeId, "out", popup);
        }
        if (t == "ScoreGame") {
            int mult = vc::sim::score_difficulty_mult(cx.g.difficulty);
            long pop = 0; for (auto& c : cx.w.colonies) pop += c.population;
            int ffc = 0; for (uint32_t b = cx.x.ff_owned; b; b &= b - 1) ++ffc;
            long base = pop * 2 + ffc * 5;
            if (cx.x.woi_declared) base += vc::sim::revolution_bonus(cx.g.year);
            cx.x.score = base * mult;
            effect("final score = " + std::to_string(cx.x.score) + " (x" + std::to_string(mult) + " difficulty)");
            return follow(nodeId, "out", popup);
        }
        if (t == "FireEvent") {
            std::string gid = pget(*n, "graph").str;
            try {
                JsonValue sub = load_graph(gid);
                JsonValue rep = run_graph(sub, cx);          // same cx -> same live game
                if (const JsonValue* ef = rep.find("effects"))
                    for (const auto& e : ef->arr) effect("[" + gid + "] " + e.str);
                const JsonValue* pp = rep.find("popup");
                if (pp && pp->is_object()) { const JsonValue* ti = pp->find("title");
                    effect("[" + gid + "] popup: " + (ti ? ti->str : "")); }
                else effect("fired event: " + gid);
            } catch (const std::exception&) { effect("FireEvent: cannot load graph '" + gid + "'"); }
            return follow(nodeId, "out", popup);
        }
        if (t == "Navigate") { gotoScreen = pget(*n, "screen").str; effect("go to screen: " + gotoScreen); return follow(nodeId, "out", popup); }
        if (t == "Log") { effect(pget(*n, "message").str); return follow(nodeId, "out", popup); }
        if (t == "ShowPopup") {
            popup.type = JsonValue::Object;
            // Replace {binding.path} tokens with live values; leave {highlighted terms}
            // (which don't resolve to a binding) untouched -- so the real game text's
            // {Declaration of Independence} stays, but {game.score}/{power0.gold} fill in.
            auto interp = [&](std::string s) {
                std::string out; size_t i = 0;
                while (i < s.size()) {
                    if (s[i] == '{') { size_t j = s.find('}', i);
                        if (j != std::string::npos) { std::string tok = s.substr(i + 1, j - i - 1);
                            JsonValue v = resolve_binding(tok, cx);
                            if (v.type == JsonValue::Number) {
                                double d = v.num; out += (d == (long)d) ? std::to_string((long)d) : std::to_string(d);
                                i = j + 1; continue; }
                            if (v.type == JsonValue::String) { out += v.str; i = j + 1; continue; }
                        } }
                    out += s[i++];
                }
                return out;
            };
            std::string key = pget(*n, "textKey").str, body = pget(*n, "body").str;
            // textKeys = the event's full set of possible messages (comma/newline/space
            // separated); one is picked per run, so the event varies like the real game.
            std::string keys = pget(*n, "textKeys").str;
            if (key.empty() && !keys.empty()) {
                std::vector<std::string> opts; std::string cur;
                auto push = [&]{ if (!cur.empty()) { opts.push_back(cur); cur.clear(); } };
                for (char c : keys) { if (c == '\n' || c == ',' || c == ' ' || c == '\t') push(); else cur += c; }
                push();
                if (!opts.empty()) key = opts[cx.rng(0, (int)opts.size() - 1)];
            }
            if (!key.empty()) { std::string g = game_text(key);
                if (!g.empty()) { body = g; popup.obj["textKey"] = json_str(key); } }
            popup.obj["title"] = json_str(interp(pget(*n, "title").str));
            popup.obj["body"]  = json_str(interp(body));
            // sprite channels this popup carries (spec/ui/popups.md 4-channel system)
            std::string wc = pget(*n, "woodcut").str, sp = pget(*n, "speaker").str;
            if (!wc.empty()) popup.obj["woodcut"] = json_str(wc);
            if (!sp.empty()) popup.obj["speaker"] = json_str(sp);
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
