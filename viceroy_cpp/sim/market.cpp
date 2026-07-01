// sim/market.cpp -- see market.hpp for the full byte-verified model + citations.
#include "market.hpp"

namespace vc::sim {

void price_drift(GameState& g, const RuleData& rd) {
    const int shift = rd.cfg.price_drift_shift;
    for (int good = 0; good < NGOODS; ++good) {
        int64_t acc = g.price_base[good];
        for (int p = 0; p < 4; ++p) {
            int32_t v = g.powers[p].trade[good];
            if (v > 0) acc += v;                    // clamp negatives to 0
        }
        g.price_base[good] -= (int32_t)(acc >> shift);  // proportional decay /256
    }
}

int market_supply(const GameState& g, int good) {
    int64_t s = g.price_base[good];
    for (int p = 0; p < 4; ++p) {
        int32_t v = g.powers[p].trade[good];
        if (v > 0) s += v;                          // Σ max(trade, 0)  (@0x0305AE)
    }
    return (int)s;
}

// A good priced by the finished-goods pool coupling: the four luxuries Rum..Coats and their
// raw inputs Sugar..Furs (market.md:135-164).
static bool pool_priced(int good) {
    return (good >= RUM && good <= COATS) || (good >= SUGAR && good <= FURS);
}

void market_recompute(GameState& g, const RuleData& rd) {
    int64_t s_pair = 0;
    for (int i = RUM; i <= COATS; ++i) s_pair += market_supply(g, i);
    if (s_pair < 1) s_pair = 1;                     // clamp >=1 (@0x030649)
    for (int i = 0; i < NGOODS; ++i) {
        if (!pool_priced(i)) continue;              // other goods keep their stepped level
        int64_t v = market_supply(g, i);
        if (i == FURS) v /= 2;                      // Furs supply halved (@0x0307C9)
        if (v < 1) v = 1;
        int target = (int)((s_pair * 3) / v);       // target = S_pair*3 / supply (@0x030745)
        if (i == FURS) {                            // year bumps -- attach point RECONSTRUCTED
            if (g.year < 1700) target += 1;
            if (g.year < 1600) target += 1;
        }
        const CargoStats& c = rd.cargo[i];
        if (target < c.lo) target = c.lo;
        if (target > c.hi) target = c.hi;
        for (int p = 0; p < 4; ++p) g.powers[p].price_level[i] = target;
    }
}

int market_bid(const GameState& g, int power, int good) {
    int b = g.powers[power].price_level[good] - 1;  // sell price = level - 1 (@0x30590)
    return b < 0 ? 0 : b;
}

int market_ask(const GameState& g, int power, int good, const RuleData& rd) {
    // buy price = bid + burden + 1: the per-good defined spread from @CARGO (USER RULING).
    return market_bid(g, power, good) + rd.cargo[good].burden + 1;
}

// The byte-cited +/-1 steppers on the published level (func_032262/func_032278), used for
// the goods outside the pool; clamped to the good's @CARGO drift band.
static void step_level(GameState& g, int good, int delta, const RuleData& rd) {
    const CargoStats& c = rd.cargo[good];
    for (int p = 0; p < 4; ++p) {
        int v = g.powers[p].price_level[good] + delta;
        if (v < c.lo) v = c.lo;
        if (v > c.hi) v = c.hi;
        g.powers[p].price_level[good] = v;
    }
}

long market_sell(GameState& g, int power, int good, int qty, const RuleData& rd) {
    if (qty <= 0 || good < 0 || good >= NGOODS) return 0;
    Power& pw = g.powers[power];
    long gross = (long)market_bid(g, power, good) * qty;
    long tax   = gross * pw.tax / 100;              // sale tax (market.md:170)
    long net   = gross - tax;
    pw.gold += net;
    if (pw.gold < 0) pw.gold = 0;                   // clamp [0, 999999] (@0x32a82)
    if (pw.gold > 999999) pw.gold = 999999;
    pw.royal_money += tax;                          // the King's cut funds the REF (king.md:92)
    pw.trade[good] += qty;                          // SELL adds volume (@0x323BC)
    if (pool_priced(good)) market_recompute(g, rd); // post-transaction re-price (@0x32902)
    else step_level(g, good, -1, rd);               // non-pool: -1 stepper (RECONSTRUCTED driver)
    return net;
}

long market_buy(GameState& g, int power, int good, int qty, const RuleData& rd) {
    if (qty <= 0 || good < 0 || good >= NGOODS) return 0;
    Power& pw = g.powers[power];
    long cost = (long)market_ask(g, power, good, rd) * qty;   // untaxed (market.md 3.1)
    pw.gold -= cost;
    if (pw.gold < 0) pw.gold = 0;
    pw.trade[good] -= qty;                          // BUY removes volume (@0x32324)
    if (pool_priced(good)) market_recompute(g, rd);
    else step_level(g, good, +1, rd);               // non-pool: +1 stepper (RECONSTRUCTED driver)
    return cost;
}

void market_init(GameState& g, const RandFn& rng, const RuleData& rd) {
    for (int i = 0; i < NGOODS; ++i) {
        const CargoStats& c = rd.cargo[i];
        int lo = c.start1 < c.start2 ? c.start1 : c.start2;
        int hi = c.start2 > c.start1 ? c.start2 : c.start1;
        int lvl = rng(lo, hi);
        if (lvl < c.lo) lvl = c.lo;
        if (lvl > c.hi) lvl = c.hi;
        for (int p = 0; p < 4; ++p) g.powers[p].price_level[i] = lvl;
    }
    market_recompute(g, rd);                        // pooled goods start on-model
}

void market_turn(GameState& g, const RuleData& rd) {
    price_drift(g, rd);                             // fold this turn's volume into the base
    market_recompute(g, rd);                        // republish the pooled levels
    for (int p = 0; p < 4; ++p)                     // reset the per-turn volumes
        for (int i = 0; i < NGOODS; ++i) g.powers[p].trade[i] = 0;
}

} // namespace vc::sim
