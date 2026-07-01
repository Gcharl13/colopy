// forge/turnpipe.cpp -- see turnpipe.hpp. The data-driven turn iterator.
#include "turnpipe.hpp"
#include "json.hpp"
#include "engine.hpp"     // colony_compute_production (shared worker->production model)

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

// Cached enabled-phase order (resettable so the turn editor's save takes effect live).
struct PhaseCache { std::vector<std::string> ids; bool loaded = false; };
PhaseCache& phase_cache() { static PhaseCache c; return c; }

// The enabled phase ids in order, cached. Falls back to default_phases().
const std::vector<std::string>& turn_phases() {
    PhaseCache& c = phase_cache();
    if (!c.loaded) { c.loaded = true;
        try {
            JsonValue d = json_parse_file(TURN_FILE);
            const JsonValue* ph = d.find("phases");
            if (ph && ph->type == JsonValue::Array) {
                for (const JsonValue& p : ph->arr) {
                    const JsonValue* id = p.find("id"); if (!id) continue;
                    const JsonValue* en = p.find("enabled");
                    if (en && en->type == JsonValue::Bool && !en->b) continue;   // disabled
                    c.ids.push_back(id->str);
                }
            }
        } catch (...) {}
        if (c.ids.empty()) c.ids = default_phases();
    }
    return c.ids;
}

// --- the phase implementations (each identical to the matching block in sim::step_turn) ---
void phase_production(GameState& g, World& w, const RuleData& rd, uint32_t ff_owned) {
    for (Colony& c : w.colonies) {
        colony_compute_production(c, g.difficulty, rd, ff_owned);   // colonists -> food/bells/hammers/goods
        colony_economic_step(c, g.difficulty, rd);                  // then SoL / build / growth off those
    }
}
void phase_market(GameState& g, World&, const RuleData& rd) { price_drift(g, rd); }
void phase_immigration(GameState& g, World& w, const RandFn& rng, int player_idx, const RuleData& rd) {
    for (int p = 0; p < 4; ++p) {
        int workers = 0, crosses = rd.cfg.imm_base_crosses;
        for (const Colony& c : w.colonies)
            if (c.owner_power == p) { workers += c.population; crosses += c.crosses_output; }
        bool is_england = (p == player_idx) && (g.nation == 0);
        immigration_step(g.powers[p], crosses, workers, /*units*/0,
                         g.difficulty, /*ai*/ p != player_idx, is_england, rng, rd);
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

void invalidate_turn_pipeline() {   // drop the cache so the next turn re-reads turn.json
    phase_cache() = PhaseCache{};
}

void run_turn(GameState& g, World& w, const RandFn& rng, int player_idx, const RuleData& rd, uint32_t ff_owned) {
    for (const std::string& id : turn_phases()) {
        if (id == "production")       phase_production(g, w, rd, ff_owned);
        else if (id == "market")      phase_market(g, w, rd);
        else if (id == "immigration") phase_immigration(g, w, rng, player_idx, rd);
        else if (id == "ref")         phase_ref(g, w, player_idx, rd);
        else if (id == "units")       phase_units(g, w, rng, rd);
        else if (id == "cadence")     phase_cadence(g, w, rd);
        // unknown phase ids are skipped (a modded pipeline may reference a not-yet-built phase)
    }
}

} // namespace forge
