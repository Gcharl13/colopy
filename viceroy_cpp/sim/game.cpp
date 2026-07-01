// sim/game.cpp -- see game.hpp.
#include "game.hpp"
#include "economy.hpp"
#include "market.hpp"
#include "ref.hpp"
#include "turn.hpp"
#include "unit_turn.hpp"

namespace vc::sim {

void step_turn(GameState& g, World& w, const RandFn& rng, int player_idx, const RuleData& rd) {
    // 1. Production phase: each colony updates SoL / build / growth.
    for (Colony& c : w.colonies)
        colony_economic_step(c, g.difficulty, rd);

    // 2. Market: European price drift (once).
    price_drift(g, rd);

    // 3. Immigration: every power advances its own Europe dock. crosses = base +
    //    Σ that power's colony cross output; the human is player_idx (ai otherwise).
    //    The England (power 0) bonus + AI scaling live in crosses_threshold.
    for (int p = 0; p < 4; ++p) {
        int workers = 0, crosses = rd.cfg.imm_base_crosses;
        for (const Colony& c : w.colonies)
            if (c.owner_power == p) { workers += c.population; crosses += c.crosses_output; }
        // England (@COUNTRY 0) gets the *2/3 bonus; the human's nation is g.nation, AI
        // powers' nations aren't modeled so only the human power can be England here.
        bool is_england = (p == player_idx) && (g.nation == 0);
        immigration_step(g.powers[p], crosses, workers, /*units*/0,
                         g.difficulty, /*ai*/ p != player_idx, is_england, rng, rd);
    }

    // 4. REF (King) budget accrual + unit purchase.
    g.powers[player_idx].royal_money += ref_accrue_rate(g.difficulty, g.year, rd);
    ref_purchase(g.ref, g.powers[player_idx].royal_money, rd);

    // 5. Units: refresh move points and execute standing orders (all owners).
    refresh_moves(w, rd);
    apply_orders(g, w, rng, rd);

    // 6. End of turn: advance year/season.
    advance_cadence(g);
}

} // namespace vc::sim
