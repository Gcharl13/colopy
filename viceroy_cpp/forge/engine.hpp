// forge/engine.hpp -- the data-driven game-engine layer for the Forge IDE.
//
// The game becomes DATA: visual node graphs (logic/events) + screen definitions,
// authored in the browser IDE and RUN by this engine. This header exposes:
//   - the Node Catalog (the palette the editor draws + the types the interpreter runs),
//   - graph load/save/list (JSON files under data_extracted/engine/graphs/),
//   - a binding resolver (read a game-state path), and
//   - a graph interpreter (run a node graph against the live game; may mutate it).
//
// Logic is authored visually (Blueprint-inspired node graph), never as code; the JSON
// here is only the serialization behind the editor.
#pragma once

#include "json.hpp"
#include "game.hpp"        // vc::sim::GameState, World
#include "diplomacy.hpp"   // vc::sim::Diplomacy
#include <cstdint>
#include <functional>
#include <string>
#include <utility>
#include <vector>

namespace forge {

// Game state the action nodes need that the pure sim GameState/World don't carry
// (the sim core is economic; these are the relational fields the events touch).
// Lives Forge-side and persists across requests, like colony_xy.
struct EngineExtra {
    int      tension  = 0;        // native tension 0..100 (sim/natives.hpp scale)
    uint32_t ff_owned = 0;        // bit i set = founding father i acquired
    uint16_t boycotts = 0;        // bit g set = good g boycotted in Europe
    vc::sim::Diplomacy diplo;     // inter-power war/treaty matrices
    // Revolution / late-game state the spec systems drive (DGROUP 0x53D0.. in the original).
    int  national_sol  = 0;       // national Sons of Liberty meter 0..100 ([0x53D0])
    bool woi_declared  = false;   // War of Independence declared ([0x5382] bit 0)
    int  rebel_power   = -1;      // power that declared independence ([0x5398])
    int  seceded_power = -1;      // power withdrawn by War of Spanish Succession ([0x53D2])
    long score         = 0;       // last computed game score
    // Per-power stat arrays the Spanish-Succession rank reads (real, editable data):
    // score = 3*mil + 2*colony_count + 1*econ  (spec 3*[0x9418]+2*[0x9298]+1*[0x9410];
    // colony_count is computed live, mil/econ proxy the undecoded 0x9418/0x9410 arrays).
    int  power_mil[4]  = {0, 0, 0, 0};
    int  power_econ[4] = {0, 0, 0, 0};
    int  congress_bells = 0;      // bell pool toward the next Founding Father ([0x0C], resets on acquire)
};

// The live game the engine binds to / mutates. Colony map positions live Forge-side
// (the sim's economic Colony has no coords), mirroring main.cpp's g_colony_xy.
struct EngineCtx {
    vc::sim::GameState& g;
    vc::sim::World&     w;
    std::vector<std::pair<int,int>>& colony_xy;
    EngineExtra&        x;                 // relational state the actions touch
    const vc::sim::RuleData& rd;           // active (possibly modded) ruleset
    std::function<int(int,int)> rng;       // deterministic [lo,hi]
};

// The Node Catalog: every node type the palette offers and the interpreter runs.
// Shape: { "categories":[ { "name", "nodes":[ {
//   "type","title","summary","pins":[{"name","kind":"exec|data","dir":"in|out","dtype"}],
//   "params":[{"name","kind":"number|text|select|binding","options?":[...] }] } ] } ] }
JsonValue node_catalog();

// Graphs are JSON documents under data_extracted/engine/graphs/<id>.json:
//   { "id","name","nodes":[{"id","type","x","y","params":{...}}],
//     "edges":[{"from":{"node","pin"},"to":{"node","pin"}}] }
std::vector<std::string> list_graphs();
JsonValue load_graph(const std::string& id);            // throws std::runtime_error if missing
void      save_graph(const std::string& id, const JsonValue& graph);

// Screen definitions live under data_extracted/engine/screens/<id>.json (phase E4).
std::vector<std::string> list_screens();
JsonValue load_screen(const std::string& id);
void      save_screen(const std::string& id, const JsonValue& screen);

// Write a few editable binding paths (the State Inspector "manipulate the I/O").
// Returns false if the path is not writable. Writable: game.year/season,
// power<N>.gold/tax, colony<N>.population, price.<good>.
bool set_binding(const std::string& path, double value, EngineCtx& cx);

// Resolve a binding path (e.g. "game.year", "power0.gold", "ref.regulars",
// "colony0.population", or a data-table cell "@BUILDING[name:Fort].cost" /
// "@CLASS[3].transport_cost") against the live game. Returns a JSON number/string, or Null.
JsonValue resolve_binding(const std::string& path, const EngineCtx& cx);

// Drop the cached data tables (call after the Tables tab saves so a newly added row /
// edited cell is picked up by the next @SECTION[...] binding lookup without a restart).
void invalidate_tables();

// Run a node graph against the game. Executes exec flow from the entry (Trigger) node,
// evaluating data pins on demand, applying Action nodes to the sim. Returns a report:
//   { "log":[strings], "effects":[strings], "popup": {title,body,choices:[...]} | null,
//     "paused_at": nodeId | null }
// When the flow reaches a ShowPopup node it returns the popup and pauses; call again with
// `from_node` = that node id and `choice` = the chosen pin to resume down that branch.
JsonValue run_graph(const JsonValue& graph, EngineCtx& cx,
                    const std::string& from_node = "", const std::string& choice = "");

} // namespace forge
