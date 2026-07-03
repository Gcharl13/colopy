// forge/turnpipe.cpp -- see turnpipe.hpp. The data-driven turn iterator.
#include "turnpipe.hpp"
#include "json.hpp"
#include "engine.hpp"     // colony_compute_production (shared worker->production model)

#include "economy.hpp"     // colony_economic_step
#include "market.hpp"      // price_drift
#include "immigration.hpp" // immigration_step
#include "ref.hpp"         // ref_accrue_rate, ref_purchase
#include "training.hpp"    // school_teach_step
#include "events.hpp"      // resource_at / DEPLETED_BIT (mine depletion)
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
std::vector<int> g_depletion_log;                                 // colony per fired depletion event
// Production for ONE power's colonies (func_02F052 @0x2F25F: the per-power
// colony loop of the turn_dispatch.md interleave). only_power < 0 = all.
void phase_production_p(GameState& g, World& w, const RandFn& rng, const RuleData& rd,
                        uint32_t ff_owned, int only_power) {
    static const int rdx[8] = {-1, 0, 1, -1, 1, -1, 0, 1};   // ring order 0=NW..7=SE
    static const int rdy[8] = {-1,-1,-1,  0, 0,  1, 1, 1};
    std::vector<vc::sim::TeachResult> tr;
    for (int ci = 0; ci < (int)w.colonies.size(); ++ci) {
        Colony& c = w.colonies[ci];
        if (only_power >= 0 && c.owner_power != only_power) continue;
        int pressure = 0;                                            // [0xA896] per colony scan
        colony_compute_production(c, g.difficulty, rd, ff_owned,    // colonists -> food/bells/hammers/goods
                                  g.powers[c.owner_power & 3].tax,   //   (Paine reads the tax rate)
                                  &w, g.rumor_seed, &pressure);      //   + prime resources / mining pressure
        // Mine depletion (map_system.md "Depletion writer", @0x2EA62..0x2EA9D): per unit of
        // mining pressure, a NONZERO rng(0, difficulty+1) roll bumps the colony counter
        // (+0x97); at >= 50 it wraps and the worked deposits deplete (func_02D30A scan).
        for (; pressure > 0; --pressure) {
            if (rng(0, g.difficulty + 1) == 0) continue;
            if (++c.depletion_counter < 50) continue;
            c.depletion_counter -= 50;
            bool fired = false;
            for (const auto& wk : c.workers) {                       // the worked-slot scan
                if (wk.tile < 0 || wk.tile > 7 || (wk.good != 6 && wk.good != 7)) continue;
                int tx = c.x + rdx[wk.tile], ty = c.y + rdy[wk.tile];
                int res = resource_at(w, tx, ty, g.rumor_seed);
                if (res == 6 || res == 12) { w.improve_set(tx, ty, DEPLETED_BIT); fired = true; }
            }
            if (fired) g_depletion_log.push_back(ci);
        }
        int fe = 0, se = 0;
        colony_economic_step(c, g.difficulty, rd, &fe, &se);        // then SoL / build / growth off those
        if (fe) g_food_log.push_back({ci, fe});
        if (se) g_sol_log.push_back({ci, se});
        tr.clear();
        school_teach_step(c, rd, rng, &tr);                         // then the school teaches (func_02D658)
        for (const auto& t : tr) g_teach_log.push_back({ci, t});
    }
}
void phase_production(GameState& g, World& w, const RandFn& rng, const RuleData& rd, uint32_t ff_owned) {
    phase_production_p(g, w, rng, rd, ff_owned, -1);
}
void phase_market(GameState& g, World&, const RuleData& rd) { market_turn(g, rd); }
void phase_immigration_p(GameState& g, World& w, const RandFn& rng, int player_idx,
                         const RuleData& rd, uint32_t ff_owned, int p) {
    int workers = 0, crosses = rd.cfg.imm_base_crosses;
    for (const Colony& c : w.colonies)
        if (c.owner_power == p) { workers += c.population; crosses += c.crosses_output; }
    // Colonist-carrying field units feed the -2 override (func_035D9A
    // @0x35DE7..0x35E2B; person types <= Cont. Army, RECONSTRUCTED map).
    int fieldc = 0;
    for (const Unit& u : w.units)
        if (u.alive && u.owner == p && u.type <= CONT_ARMY) ++fieldc;
    bool is_england = (p == player_idx) && (g.nation == 0);
    // William Brewster (FF 0x14 = 20) shifts the human power's dock refill to the top class.
    bool brewster = (p == player_idx) && ((ff_owned >> 20) & 1u);
    immigration_step(g.powers[p], crosses, workers, /*units*/0,
                     g.difficulty, /*ai*/ p != player_idx, is_england, rng, rd, brewster,
                     fieldc);
}
void phase_immigration(GameState& g, World& w, const RandFn& rng, int player_idx, const RuleData& rd,
                       uint32_t ff_owned) {
    for (int p = 0; p < 4; ++p)
        phase_immigration_p(g, w, rng, player_idx, rd, ff_owned, p);
}
void phase_ref(GameState& g, World&, int player_idx, const RuleData& rd) {
    g.powers[player_idx].royal_money += ref_accrue_rate(g.difficulty, g.year, rd);
    ref_purchase(g.ref, g.powers[player_idx].royal_money, rd);
}
std::vector<RumorResult> g_rumor_log;      // drained by game_step for the turn notices
std::vector<PromoteResult> g_promote_log;  // battlefield promotions (training.md 3)
std::vector<ShoreFire> g_shore_log;        // fort fire on adjacent ships (@FORTFIRE)

bool g_woi = false;                    // [0x5382] bit 0 mirror (set by the caller)
// Orders for ONE power (turn_dispatch.md 3, phase 2 of the interleave): the
// REF accrual rides here for the crown-facing power (@0x24B42), the AI
// strategic pass for computer powers (@0x24731), then that power's standing
// orders. Shore fire + the fog sweep run once after the whole power loop.
void phase_orders_p(GameState& g, World& w, const RandFn& rng, int player_idx,
                    const RuleData& rd, uint32_t ff_owned, int p,
                    const std::vector<vc::sim::AiVillage>* villages = nullptr) {
    if (p == player_idx) {
        g.powers[p].royal_money += ref_accrue_rate(g.difficulty, g.year, rd);
        ref_purchase(g.ref, g.powers[p].royal_money, rd);
    } else {
        vc::sim::ai_power_turn(g, w, p, rd, rng, villages);
    }
    apply_orders(g, w, rng, rd, ff_owned, &g_rumor_log, &g_promote_log, g_woi, p);
}
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
std::vector<int>& depletion_log() { return g_depletion_log; }
std::vector<std::pair<int, int>>& sol_log() { return g_sol_log; }
std::vector<vc::sim::PromoteResult>& promote_log() { return g_promote_log; }
std::vector<vc::sim::ShoreFire>& shore_log() { return g_shore_log; }

const std::vector<std::string>& enabled_turn_phases() { return turn_phases(); }

void run_turn_phase(const std::string& id, GameState& g, World& w, const RandFn& rng,
                    int player_idx, const RuleData& rd, uint32_t ff_owned) {
    if (id == "orders") {
        refresh_moves(w, rd);
        for (int p = 0; p < 4; ++p) phase_orders_p(g, w, rng, player_idx, rd, ff_owned, p);
        shore_bombardment(w, rd, &g_shore_log);
        reveal_step(w, ff_owned);
    }
    else if (id == "production")  phase_production(g, w, rng, rd, ff_owned);
    else if (id == "market")      phase_market(g, w, rd);
    else if (id == "immigration") phase_immigration(g, w, rng, player_idx, rd, ff_owned);
    else if (id == "ref")         phase_ref(g, w, player_idx, rd);
    else if (id == "units")       phase_units(g, w, rng, rd, ff_owned);
    else if (id == "cadence")     phase_cadence(g, w, rd);
    // unknown phase ids are skipped (a modded pipeline may reference a not-yet-built phase)
}

void run_turn(GameState& g, World& w, const RandFn& rng, int player_idx, const RuleData& rd, uint32_t ff_owned,
              const std::vector<vc::sim::AiVillage>* villages) {
    // The byte-verified per-power interleave (turn_dispatch.md 3, func_005760):
    // King -> Orders(+REF,+AI) -> Production -> Diplomacy -> Periodic per power
    // 0..3, then the global tail (market once -- see the model-shape note in
    // sim/game.cpp -- shore fire, fog sweep, cadence). turn.json still gates
    // which phases are enabled; per-power phases run inside the power loop in
    // list order, globals after it.
    const std::vector<std::string>& ids = turn_phases();
    auto on = [&](const char* k) {
        for (const std::string& id : ids) if (id == k) return true;
        return false;
    };
    const bool orders  = on("orders") || on("units");   // legacy id kept enabled
    const bool prod    = on("production");
    const bool imm     = on("immigration");
    const bool ref_leg = on("ref");                     // legacy separate-REF pipeline
    if (orders) refresh_moves(w, rd);                   // budget reset (@0x005872, global)
    for (int p = 0; p < 4; ++p) {
        if (orders) {
            if (ref_leg && p == player_idx) {           // legacy: REF phase listed apart --
                vc::sim::ai_power_turn(g, w, p, rd, rng, villages);   // (no-op for the human; keeps
                apply_orders(g, w, rng, rd, ff_owned, &g_rumor_log, &g_promote_log, g_woi, p);
            } else {
                phase_orders_p(g, w, rng, player_idx, rd, ff_owned, p, villages);
            }
        }
        if (prod) phase_production_p(g, w, rng, rd, ff_owned, p);
        if (imm)  phase_immigration_p(g, w, rng, player_idx, rd, ff_owned, p);
    }
    if (ref_leg) phase_ref(g, w, player_idx, rd);       // legacy position (post-loop)
    if (on("market")) phase_market(g, w, rd);
    if (orders) {
        shore_bombardment(w, rd, &g_shore_log);         // func_02D3C6 (after all movement)
        reveal_step(w, ff_owned);
    }
    if (on("cadence")) phase_cadence(g, w, rd);
}

} // namespace forge
