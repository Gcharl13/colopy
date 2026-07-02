// sim/game.cpp -- see game.hpp.
#include "game.hpp"
#include "ai.hpp"
#include "combat.hpp"    // shore_bombardment
#include "economy.hpp"
#include "explore.hpp"
#include "market.hpp"
#include "ref.hpp"
#include "training.hpp"
#include "turn.hpp"
#include "unit_turn.hpp"

namespace vc::sim {

void step_turn(GameState& g, World& w, const RandFn& rng, int player_idx, const RuleData& rd,
               uint32_t ff_owned) {
    // The byte-verified per-power interleave (turn_dispatch.md 3, func_005760):
    // for each power 0..3 the five phases run in order -- King -> Orders(+REF
    // accrual @0x24B42, +AI @0x24731) -> Production(+immigration @0x2F218) ->
    // Diplomacy -> Periodic -- then the once-per-turn year/cadence block.
    // King/Diplomacy/Periodic have no sim-core body (the king dialogs, king-tax
    // dispatch and Congress live in the event layer above); the market drift
    // stays once-per-turn below (the EXE nests drift in each power's production
    // slice @0x363D3, but our validated drift folds all four powers' volumes in
    // ONE decay step -- splitting it would change the byte-derived decay rate;
    // a model-shape note, not a missing behavior).
    refresh_moves(w, rd);                       // turn-start budget reset (@0x005872, global)
    for (int p = 0; p < 4; ++p) {
        // --- 2. Orders (+REF accrual, +AI strategic pass) ---
        if (p == player_idx) {
            g.powers[p].royal_money += ref_accrue_rate(g.difficulty, g.year, rd);
            ref_purchase(g.ref, g.powers[p].royal_money, rd);
        } else {
            ai_power_turn(g, w, p, rd, rng);    // controller gate skips the human (@0x58A6)
        }
        apply_orders(g, w, rng, rd, ff_owned, nullptr, nullptr, false, /*only_owner*/p);

        // --- 3. Production (per-power colony loop func_02F052 @0x2F25F) ---
        for (Colony& c : w.colonies)
            if (c.owner_power == p) {
                colony_economic_step(c, g.difficulty, rd);
                school_teach_step(c, rd, rng);
            }
        // Immigration rides the production slice (func_0363A2 @0x363E2).
        {
            int workers = 0, crosses = rd.cfg.imm_base_crosses;
            for (const Colony& c : w.colonies)
                if (c.owner_power == p) { workers += c.population; crosses += c.crosses_output; }
            bool is_england = (p == player_idx) && (g.nation == 0);
            immigration_step(g.powers[p], crosses, workers, /*units*/0,
                             g.difficulty, /*ai*/ p != player_idx, is_england, rng, rd);
        }
    }

    // Market once per turn (see the model-shape note above).
    market_turn(g, rd);

    // Defensive fortifications fire on adjacent enemy ships after all movement
    // (func_02D3C6, deterministic), then the sticky per-power fog reveal.
    shore_bombardment(w, rd);
    reveal_step(w, ff_owned);

    // 6. End of turn: advance year/season (once, gated [0x53C2]).
    advance_cadence(g);
}

} // namespace vc::sim
