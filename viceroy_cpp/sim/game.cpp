// sim/game.cpp -- see game.hpp.
#include "game.hpp"
#include "economy.hpp"
#include "market.hpp"
#include "ref.hpp"
#include "turn.hpp"

namespace vc::sim {

void step_turn(GameState& g, World& w, const RandFn& rng, int player_idx) {
    // 1. Production phase: each colony updates SoL / build / growth.
    for (Colony& c : w.colonies)
        colony_economic_step(c, g.difficulty);

    // 2. Market: European price drift (once).
    price_drift(g);

    // 3. Immigration: crosses = 2 base + Σ this power's colony cross output.
    int workers = 0, crosses = 2;
    for (const Colony& c : w.colonies)
        if (c.owner_power == player_idx) { workers += c.population; crosses += c.crosses_output; }
    immigration_step(g.powers[player_idx], crosses, workers, /*units*/0,
                     g.difficulty, /*ai*/false, player_idx, rng);

    // 4. REF (King) budget accrual + unit purchase.
    g.powers[player_idx].royal_money += ref_accrue_rate(g.difficulty, g.year);
    ref_purchase(g.ref, g.powers[player_idx].royal_money);

    // 5. End of turn: advance year/season.
    advance_cadence(g);
}

} // namespace vc::sim
