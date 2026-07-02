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

// A native settlement -- a first-class map entity (NativeSettlement record, spec/systems/natives.md):
// a tribe's village at (x,y) with a per-power alarm[4], a size (population -> CHIEFKILL treasure),
// wealth (trade/tribute), an optional mission (which power converted it, -1 none), and a Capital flag.
struct NativeSettlement {
    int  tribe = 0;              // @TRIBES row (0 Inca..7 Tupi)
    int  x = 0, y = 0;           // +0x00 / +0x01 map position
    int  population = 1;         // +0x04 size byte (feeds CHIEFKILL treasure)
    int  wealth = 0;             // trade/tribute wealth
    int  mission = -1;           // power that established a mission here, -1 = none
    bool capital = false;        // +0x03 bit 0x04 Capital marker
    int  alarm[4] = {0, 0, 0, 0};// +0x0A + power*2 per-European-power alarm (>=128 -> war)
    int  tension[4] = {0, 0, 0, 0};// the 0x5B1C anger meter [0,100] per power
                                 //   (func_045DF2; 75 hostile / 100 war -- a parallel,
                                 //   distinct signal from alarm[], natives.md)
    int  skill = 0;              // the @JOB profession this village can teach (training.md 3;
                                 //   which skill a given village carries is RECONSTRUCTED --
                                 //   assigned from the learnable list at seeding)
    bool taught = false;         // +0x03 bit 0x02 "already taught" once-only latch (@0x04A78A)
    bool mission_expert = false; // +0x05 bit 0x10 expert mission (set for existing missions by
                                 //   Jean de Brebeuf on acquire, @0x3BE77)
};

// Game state the action nodes need that the pure sim GameState/World don't carry
// (the sim core is economic; these are the relational fields the events touch).
// Lives Forge-side and persists across requests, like colony_xy.
struct EngineExtra {
    int      tension  = 0;        // native tension 0..100 (sim/natives.hpp scale) -- global legacy scalar
    std::vector<NativeSettlement> settlements;   // real native villages (first-class entities)
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
    int  last_ff        = -1;     // most recently acquired father id (drives the Congress reveal), -1 = none
    int  offered_ff     = -1;     // father the Congress is currently offering ([0x12]), -1 = none/unpicked
    // Scoring inputs (spec/systems/scoring.md components):
    int  declaration_year = 0;    // year independence was declared (revolution bonus), 0 = never
    int  razed_settlements = 0;   // native settlements this power destroyed (-(diff+1) each)
    // Mercenary offer state (mercenary.md func_03E442): the first-eligible-call
    // skip bit (PowerRecord +0x00 bit 0x08, set-then-return @0x03E4BC/@0x03E4CD)
    // and the PRE-ROLLED pending offer -- counts/price roll BEFORE the
    // @MERCENARIES dialog so %NUMBER0/%STRING1 bind the real force.
    int  free_recruits = 0;       // Fountain-of-Youth free-recruit queue (+0x49, @0x52682)
    int  artillery_bought = 0;    // Europe artillery escalation counter (PowerRecord +0x1E,
                                  //   cost = base + count*100, @0x035124/@0x035282)
    bool merc_primed = false;
    long pending_merc_price = 0;
    int  pending_merc_cat[4] = {0, 0, 0, 0};
    bool pending_merc_wartime = false;
    std::string pending_merc_force;
    long bells_since_declaration = 0;  // bells produced after the declaration (component 6;
                                       // spec gates on the intervention flag [0x5382]&2 --
                                       // gating on the declaration is RECONSTRUCTED)
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

// Compute a colony's per-turn production from its colonist roster (spec/systems/colony.md §3):
// tile workers -> raw goods (terrain table + tory/expert), building workers -> Hammers/Crosses/
// Bells, then a gated raw->finished conversion; banks the stockpile and sets *_per_turn. Shared
// by the turn pipeline and the ColonyProduce node. Reads @UNFORESTED/@FORESTED/@OTHER + @BUILDING.
// ff_owned = the owner power's acquired-founding-father bitmask (EngineExtra.ff_owned); production
// applies the byte-verified father effects (Henry Hudson furs x2, Jefferson +50% bells, Penn +50%
// crosses, Adam Smith un-throttles factory tier) and the Sons-of-Liberty bonus (+1 at >=50%, +2 at
// 100%). 0 = no fathers.
void colony_compute_production(vc::sim::Colony& col, int difficulty, const vc::sim::RuleData& rd,
                               uint32_t ff_owned = 0, int tax_pct = 0);

// The @JOB display name for a profession id (the expert_name column for an expert, else name).
std::string job_name(int profession, bool expert);

// Resolve one reference-table cell "@SECTION[row].col" against the live
// (edit-aware) table data. Null JsonValue when the path does not resolve.
JsonValue table_cell(const std::string& path);

// Base terrain yield of raw good g (0..7) on a terrain id, read live from the yield tables
// (@UNFORESTED / @FORESTED / @OTHER). Used by production and the colony-screen field panel.
int terrain_good_yield(int terrain, int good);

// Run a node graph against the game. Executes exec flow from the entry (Trigger) node,
// evaluating data pins on demand, applying Action nodes to the sim. Returns a report:
//   { "log":[strings], "effects":[strings], "popup": {title,body,choices:[...]} | null,
//     "paused_at": nodeId | null }
// When the flow reaches a ShowPopup node it returns the popup and pauses; call again with
// `from_node` = that node id and `choice` = the chosen pin to resume down that branch. The
// popup carries a `_cache` of the data values computed so far; echo it back as `cache` on the
// resume call so rolled/computed values (the offered outcome) stay stable through the choice.
JsonValue run_graph(const JsonValue& graph, EngineCtx& cx,
                    const std::string& from_node = "", const std::string& choice = "",
                    const JsonValue& cache = JsonValue{});

} // namespace forge
