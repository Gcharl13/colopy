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
#include "game.hpp"      // vc::sim::GameState, World
#include <functional>
#include <string>
#include <utility>
#include <vector>

namespace forge {

// The live game the engine binds to / mutates. Colony map positions live Forge-side
// (the sim's economic Colony has no coords), mirroring main.cpp's g_colony_xy.
struct EngineCtx {
    vc::sim::GameState& g;
    vc::sim::World&     w;
    std::vector<std::pair<int,int>>& colony_xy;
    std::function<int(int,int)> rng;      // deterministic [lo,hi]
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

// Resolve a binding path (e.g. "game.year", "power0.gold", "ref.regulars",
// "colony0.population") against the live game. Returns a JSON number/string, or Null.
JsonValue resolve_binding(const std::string& path, const EngineCtx& cx);

// Run a node graph against the game. Executes exec flow from the entry (Trigger) node,
// evaluating data pins on demand, applying Action nodes to the sim. Returns a report:
//   { "log":[strings], "effects":[strings], "popup": {title,body,choices:[...]} | null,
//     "paused_at": nodeId | null }
// When the flow reaches a ShowPopup node it returns the popup and pauses; call again with
// `from_node` = that node id and `choice` = the chosen pin to resume down that branch.
JsonValue run_graph(const JsonValue& graph, EngineCtx& cx,
                    const std::string& from_node = "", const std::string& choice = "");

} // namespace forge
