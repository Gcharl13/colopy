/* The Europe market — ports of game.js:4304-4374 (seed/ask/step/drift/
 * sell/buy), which encode the byte-verified @CARGO model (§9.2): start
 * window, floor/ceiling, bid/ask spread = burden+1, traffic thresholds
 * ±100·(rise|fall), per-turn attrition drift, and the volatility left-shift
 * on traded quantity.
 *
 * State mapping (all in the player's PowerRecord, .SAV-canonical):
 *   bid price   price_level[i] (+0x4C)  — the live bid, clamp-read >= 1
 *                                         exactly like the JS importer
 *   gold        gold (+0x2A)     tax    tax_rate (+0x01)
 *   king's fund kings_fund (+0x22)
 *   net counters trade_tons (+0xBC) / trade_gold (+0x7C), truncated PER LOT
 *
 * The traffic ACCUMULATOR lives in runtime state zeroed at load, mirroring
 * the JS port (whose importer never reads the record's +0x5C traffic
 * words). Reconciling the engine's own accumulator into the save flow is a
 * later pass — FLAGGED, not silently decided.
 */
#include "colopy_sim.h"
#include "colopy_data.h"

void ev_emit(const char *key, int32_t p0, int32_t p1,
             const char *s0, const char *s1);

static int32_t accum[N_GOODS];
void market_reset_accum(void) {
    for (int i = 0; i < N_GOODS; i++) accum[i] = 0;
}

static PowerRecord *me(void) { return &CS.powers[cs_nation()]; }

int market_bid(int i) {
    int p = me()->price_level[i];
    return p < 1 ? 1 : p;                      /* importer clamp, game.js:10289 */
}
int market_ask(int i) {                        /* askPrice, game.js:4312 */
    return market_bid(i) + dat_cargo[i].burden + 1;
}
/* isBoycotted (game.js:4347): the RUNTIME G.boycotts list, SEEDED from
 * the record's +0x20 word at import (10286-10288) and owned by the
 * runtime thereafter (tea parties set bits, @KISSUP clears them); the
 * record word is not rewritten. */
int market_boycotted(int i) {
    return (CR.boycotts >> i) & 1;
}

/* stepPrice (game.js:4313): walk the accumulator across its thresholds. */
static void step_price(int i) {
    const dat_cargo_t *c = &dat_cargo[i];
    int before = market_bid(i);
    int p = before;
    while (accum[i] <= -100 * c->rise && p < c->high) { p += 1; accum[i] += 100 * c->rise; }
    while (accum[i] >=  100 * c->fall && p > c->low)  { p -= 1; accum[i] -= 100 * c->fall; }
    me()->price_level[i] = (uint8_t)p;
    if (p != before)
        ev_emit(p > before ? "PRICEUP" : "PRICEDOWN", p, 0,
                c->name, dat_nations[cs_nation()].homeport);
}

/* driftMarket (game.js:4334): the per-turn attrition pass. */
void market_drift(void) {
    for (int i = 0; i < N_GOODS; i++) {
        accum[i] += dat_cargo[i].attrition;
        step_price(i);
    }
}

/* sellGoods (game.js:4344): gross at bid, tax to the King's fund, counters
 * truncated per lot, accumulator +qty<<volatility, then re-drift. */
int32_t market_sell(int i, int32_t qty) {
    if (qty <= 0 || market_boycotted(i)) return 0;
    PowerRecord *p = me();
    int32_t gross = market_bid(i) * qty;
    int32_t tax = gross * p->tax_rate / 100;
    p->gold += gross - tax;
    p->kings_fund += tax;
    p->trade_tons[i] += qty;
    p->trade_gold[i] += gross * (100 - p->tax_rate) / 100;
    accum[i] += qty << dat_cargo[i].volatility;
    step_price(i);
    return gross - tax;
}

/* buyGoods (game.js:4363): untaxed at ask; counters run the other way. */
int32_t market_buy(int i, int32_t qty) {
    if (market_boycotted(i)) return 0;
    PowerRecord *p = me();
    int32_t cost = market_ask(i) * qty;
    if (cost > p->gold) return 0;
    p->gold -= cost;
    p->trade_tons[i] -= qty;
    p->trade_gold[i] -= cost;
    accum[i] -= qty << dat_cargo[i].volatility;
    step_price(i);
    return cost;
}

int32_t market_accum(int i) { return accum[i]; }
