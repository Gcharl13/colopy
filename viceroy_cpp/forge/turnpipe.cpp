// forge/turnpipe.cpp -- see turnpipe.hpp. The data-driven turn iterator.
#include "turnpipe.hpp"
#include "json.hpp"
#include "engine.hpp"     // colony_compute_production (shared worker->production model)

#include "economy.hpp"     // colony_economic_step
#include "market.hpp"      // price_drift
#include "immigration.hpp" // immigration_step
#include "ref.hpp"         // ref_accrue_rate, ref_purchase
#include "training.hpp"    // school_teach_step
#include "ai.hpp"          // ai_power_turn (the computer players, ai.md)
#include "explore.hpp"     // reveal_step
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
std::vector<std::pair<int, vc::sim::TeachResult>> g_teach_log;   // (colony, result) per graduation
std::vector<std::pair<int, int>> g_food_log;                      // (colony, event 1/2/3) per shortage
std::vector<std::pair<int, int>> g_sol_log;                       // (colony, event 1..4) SoL status
void phase_production(GameState& g, World& w, const RandFn& rng, const RuleData& rd, uint32_t ff_owned) {
    std::vector<vc::sim::TeachResult> tr;
    for (int ci = 0; ci < (int)w.colonies.size(); ++ci) {
        Colony& c = w.colonies[ci];
        colony_compute_production(c, g.difficulty, rd, ff_owned,    // colonists -> food/bells/hammers/goods
                                  g.powers[c.owner_power & 3].tax);  //   (Paine reads the tax rate)
        int fe = 0, se = 0;
        colony_economic_step(c, g.difficulty, rd, &fe, &se);        // then SoL / build / growth off those
        if (fe) g_food_log.push_back({ci, fe});
        if (se) g_sol_log.push_back({ci, se});
        tr.clear();
        school_teach_step(c, rd, rng, &tr);                         // then the school teaches (func_02D658)
        for (const auto& t : tr) g_teach_log.push_back({ci, t});
    }
}
void phase_market(GameState& g, World&, const RuleData& rd) { market_turn(g, rd); }
void phase_immigration(GameState& g, World& w, const RandFn& rng, int player_idx, const RuleData& rd,
                       uint32_t ff_owned) {
    for (int p = 0; p < 4; ++p) {
        int workers = 0, crosses = rd.cfg.imm_base_crosses;
        for (const Colony& c : w.colonies)
            if (c.owner_power == p) { workers += c.population; crosses += c.crosses_output; }
        bool is_england = (p == player_idx) && (g.nation == 0);
        // William Brewster (FF 0x14 = 20) shifts the human power's dock refill to the top class.
        bool brewster = (p == player_idx) && ((ff_owned >> 20) & 1u);
        immigration_step(g.powers[p], crosses, workers, /*units*/0,
                         g.difficulty, /*ai*/ p != player_idx, is_england, rng, rd, brewster);
    }
}
void phase_ref(GameState& g, World&, int player_idx, const RuleData& rd) {
    g.powers[player_idx].royal_money += ref_accrue_rate(g.difficulty, g.year, rd);
    ref_purchase(g.ref, g.powers[player_idx].royal_money, rd);
}
std::vector<RumorResult> g_rumor_log;      // drained by game_step for the turn notices
std::vector<PromoteResult> g_promote_log;  // battlefield promotions (training.md 3)
std::vector<ShoreFire> g_shore_log;        // fort fire on adjacent ships (@FORTFIRE)

bool g_woi = false;                    // [0x5382] bit 0 mirror (set by the caller)
void phase_units(GameState& g, World& w, const RandFn& rng, const RuleData& rd, uint32_t ff_owned) {
    refresh_moves(w, rd);
    for (int p = 1; p < 4; ++p)        // AI powers' strategic pass (ai.md 6.3; human = 0)
        vc::sim::ai_power_turn(g, w, p, rd, rng);
    apply_orders(g, w, rng, rd, ff_owned, &g_rumor_log, &g_promote_log, g_woi);
    shore_bombardment(w, rd, &g_shore_log);   // func_02D3C6 (deterministic fort fire)
    reveal_step(w, ff_owned);          // sticky per-power fog reveal (exploration.md)
}
void phase_cadence(GameState& g, World&, const RuleData&) { advance_cadence(g); }

} // namespace

void set_woi(bool declared) { g_woi = declared; }

void invalidate_turn_pipeline() {   // drop the cache so the next turn re-reads turn.json
    phase_cache() = PhaseCache{};
}

std::vector<vc::sim::RumorResult>& rumor_log() { return g_rumor_log; }
std::vector<std::pair<int, vc::sim::TeachResult>>& teach_log() { return g_teach_log; }
std::vector<std::pair<int, int>>& food_log() { return g_food_log; }
std::vector<std::pair<int, int>>& sol_log() { return g_sol_log; }
std::vector<vc::sim::PromoteResult>& promote_log() { return g_promote_log; }
std::vector<vc::sim::ShoreFire>& shore_log() { return g_shore_log; }

const std::vector<std::string>& enabled_turn_phases() { return turn_phases(); }

void run_turn_phase(const std::string& id, GameState& g, World& w, const RandFn& rng,
                    int player_idx, const RuleData& rd, uint32_t ff_owned) {
    if (id == "production")       phase_production(g, w, rng, rd, ff_owned);
    else if (id == "market")      phase_market(g, w, rd);
    else if (id == "immigration") phase_immigration(g, w, rng, player_idx, rd, ff_owned);
    else if (id == "ref")         phase_ref(g, w, player_idx, rd);
    else if (id == "units")       phase_units(g, w, rng, rd, ff_owned);
    else if (id == "cadence")     phase_cadence(g, w, rd);
    // unknown phase ids are skipped (a modded pipeline may reference a not-yet-built phase)
}

void run_turn(GameState& g, World& w, const RandFn& rng, int player_idx, const RuleData& rd, uint32_t ff_owned) {
    for (const std::string& id : turn_phases())
        run_turn_phase(id, g, w, rng, player_idx, rd, ff_owned);
}

} // namespace forge
