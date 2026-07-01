// sim/market.hpp -- the European commodity market (spec/systems/market.md).
//
// The byte-verified model, in full:
//  - price_base[good] (DGROUP 0x53EA) is the HIDDEN SUPPLY level per good, random-seeded in
//    [600,1000] at game start (market.md:52-55; there is no fixed price table).
//  - power.trade[good] (+0xFC) is the per-turn trade volume: SELL adds qty (@0x323BC), BUY
//    subtracts (@0x32324). It builds as you flood the market and collapses as you buy it out.
//  - Per-turn drift (func_0305A8): price_base[g] -= (price_base[g] + Σ_p max(trade[p][g],0))
//    >> cfg.price_drift_shift -- heavy selling folds into the base, permanently depressing it.
//  - The PUBLISHED price level (+0x4C) derives from supply (market.md:135-164):
//      supply[g] = price_base[g] + Σ_p max(trade[p][g], 0)
//      S_pair    = max(1, supply[Rum]+supply[Cigars]+supply[Cloth]+supply[Coats])
//      target[i] = (S_pair * 3) / supply[i]      for the finished pool {9..12}
//                  and the raw inputs {1..4} (Furs supply halved; +1 if year<1700, +1 if
//                  year<1600 -- attach point RECONSTRUCTED, spec sentence is ambiguous)
//      price_level[i] = clamp(target, @CARGO.drift_low, @CARGO.drift_high)
//    Goods outside {1..4, 9..12} move by the byte-cited +/-1 steppers (func_032262/032278)
//    on each transaction (their per-turn driver is not byte-cited -- RECONSTRUCTED).
//  - Published prices (@0x30566/@0x30590): the market PAYS bid = max(price_level-1, 0); you
//    PAY ask = bid + @CARGO.burden + 1 (the per-good defined spread -- USER RULING).
//  - SELL is taxed: tax = gross*tax%/100 reduces the player's take AND accrues to the King's
//    REF fund royal_money (+0x22, king.md:92). BUY is untaxed (market.md 3.1).
#pragma once
#include "types.hpp"
#include "rules.hpp"        // RuleData / default_rules() / CargoStats
#include "immigration.hpp"  // RandFn

namespace vc::sim {

// func_0305A8 (re-verified @0x305A8): for each good, subtract
//   (price_base[g] + Σ_players max(trade[p][g], 0)) >> cfg.price_drift_shift
// from price_base[g]. Heavy selling raises the accumulator -> price falls faster.
void price_drift(GameState& g, const RuleData& rd = default_rules());

// The hidden supply level behind a good: base + all players' clamped this-turn sell volume.
int market_supply(const GameState& g, int good);

// Recompute the published price_level for the pooled goods (finished 9..12 + raw 1..4) from
// supply, clamped to each good's @CARGO drift band. Writes every power's price_level (the
// supply pool is global, so all home markets see the same level).
void market_recompute(GameState& g, const RuleData& rd = default_rules());

// Published prices for a power's home market.
int market_bid(const GameState& g, int power, int good);                       // market pays
int market_ask(const GameState& g, int power, int good,
               const RuleData& rd = default_rules());                          // you pay

// Sell qty of a good: gold += bid*qty*(100-tax)/100 (clamped [0,999999]), the TAX accrues to
// royal_money (the REF fund), trade[good] += qty, then the non-pool -1 stepper / pool
// recompute. Returns the player's net proceeds.
long market_sell(GameState& g, int power, int good, int qty,
                 const RuleData& rd = default_rules());

// Buy qty of a good (untaxed): gold -= ask*qty, trade[good] -= qty, then the non-pool +1
// stepper / pool recompute. Returns the cost. Caller validates affordability.
long market_buy(GameState& g, int power, int good, int qty,
                const RuleData& rd = default_rules());

// Seed the published price levels at game start: level = clamp(rng(start1,start2), lo, hi)
// then one recompute so the pooled goods start on-model. RECONSTRUCTED (no byte-cited init).
void market_init(GameState& g, const RandFn& rng, const RuleData& rd = default_rules());

// The per-turn market phase: drift the supply bases (using this turn's accumulated trade),
// recompute the published levels, then reset the per-turn trade volumes. (The EXE's turn
// driver zeroes the +0xFC accumulators around the drift; zeroing AFTER the drift keeps the
// byte-verified Σ max(trade) term meaningful -- order RECONSTRUCTED.)
void market_turn(GameState& g, const RuleData& rd = default_rules());

} // namespace vc::sim
