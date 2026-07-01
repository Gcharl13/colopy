// forge/turnpipe.cpp -- see turnpipe.hpp. The data-driven turn iterator.
#include "turnpipe.hpp"
#include "json.hpp"

#include "economy.hpp"     // colony_economic_step
#include "market.hpp"      // price_drift
#include "immigration.hpp" // immigration_step
#include "ref.hpp"         // ref_accrue_rate, ref_purchase
#include "unit_turn.hpp"   // refresh_moves, apply_orders
#include "turn.hpp"        // advance_cadence
#include "rules.hpp"       // Config

#include <string>
#include <vector>

using namespace vc::sim;

namespace forge {
namespace {

const char* TURN_FILE = "data_extracted/engine/turn.json";

// The default phase order -- the fallback when turn.json is missing/unreadable, so the
// runtime is self-contained. Matches sim::step_turn exactly.
const std::vector<std::string>& default_phases() {
    static const std::vector<std::string> P =
        {"production", "market", "immigration", "ref", "units", "cadence"};
    return P;
}

// The enabled phase ids in order, cached. Falls back to default_phases().
const std::vector<std::string>& turn_phases() {
    static std::vector<std::string> P; static bool loaded = false;
    if (!loaded) { loaded = true;
        try {
            JsonValue d = json_parse_file(TURN_FILE);
            const JsonValue* ph = d.find("phases");
            if (ph && ph->type == JsonValue::Array) {
                for (const JsonValue& p : ph->arr) {
                    const JsonValue* id = p.find("id"); if (!id) continue;
                    const JsonValue* en = p.find("enabled");
                    if (en && en->type == JsonValue::Bool && !en->b) continue;   // disabled
                    P.push_back(id->str);
                }
            }
        } catch (...) {}
        if (P.empty()) P = default_phases();
    }
    return P;
}

// --- the phase implementations (each identical to the matching block in sim::step_turn) ---
void phase_production(GameState& g, World& w, const RuleData& rd) {
    for (Colony& c : w.colonies) colony_economic_step(c, g.difficulty, rd);
}
void phase_market(GameState& g, World&, const RuleData& rd) { price_drift(g, rd); }
void phase_immigration(GameState& g, World& w, const RandFn& rng, int player_idx, const RuleData& rd) {
    for (int p = 0; p < 4; ++p) {
        int workers = 0, crosses = rd.cfg.imm_base_crosses;
        for (const Colony& c : w.colonies)
            if (c.owner_power == p) { workers += c.population; crosses += c.crosses_output; }
        immigration_step(g.powers[p], crosses, workers, /*units*/0,
                         g.difficulty, /*ai*/ p != player_idx, p, rng, rd);
    }
}
void phase_ref(GameState& g, World&, int player_idx, const RuleData& rd) {
    g.powers[player_idx].royal_money += ref_accrue_rate(g.difficulty, g.year, rd);
    ref_purchase(g.ref, g.powers[player_idx].royal_money, rd);
}
void phase_units(GameState& g, World& w, const RandFn& rng, const RuleData& rd) {
    refresh_moves(w, rd);
    apply_orders(g, w, rng, rd);
}
void phase_cadence(GameState& g, World&, const RuleData&) { advance_cadence(g); }

} // namespace

void invalidate_turn_pipeline() {
    // force turn_phases() to reload by rebuilding the static -- simplest: not trivially
    // resettable with a function-local static, so callers rebuild by restart; the editor
    // save path can call this once we move the cache to a struct. For now, a no-op stub
    // keeps the API; the cache reloads on process start.
}

void run_turn(GameState& g, World& w, const RandFn& rng, int player_idx, const RuleData& rd) {
    for (const std::string& id : turn_phases()) {
        if (id == "production")       phase_production(g, w, rd);
        else if (id == "market")      phase_market(g, w, rd);
        else if (id == "immigration") phase_immigration(g, w, rng, player_idx, rd);
        else if (id == "ref")         phase_ref(g, w, player_idx, rd);
        else if (id == "units")       phase_units(g, w, rng, rd);
        else if (id == "cadence")     phase_cadence(g, w, rd);
        // unknown phase ids are skipped (a modded pipeline may reference a not-yet-built phase)
    }
}

} // namespace forge
