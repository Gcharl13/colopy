/* The Europe market — ports of game.js:4304-4374 (seed/ask/step/drift/
 * sell/buy), which encode the byte-verified @CARGO model (§9.2): start
 * window, floor/ceiling, the bid/ask straddle (see below), traffic thresholds
 * ±100·(rise|fall), per-turn attrition drift, and the volatility left-shift
 * on traded quantity.
 *
 * State mapping (all in the player's PowerRecord, .SAV-canonical):
 *   price level price_level[i] (+0x4C)  — the raw record byte; the BID and
 *                                         ASK straddle it (see below)
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
#include "../data/colopy_data.h"

void ev_emit(const char *key, int32_t p0, int32_t p1,
             const char *s0, const char *s1);

static int32_t accum[N_GOODS];
void market_reset_accum(void) {
    for (int i = 0; i < N_GOODS; i++) accum[i] = 0;
}

static PowerRecord *me(void) { return &CS.powers[cs_nation()]; }

/* The record byte at +0x4C is the PRICE LEVEL, and neither quoted number
 * equals it -- they straddle it.  BYTE-VERIFIED:
 *
 *   BID  func_030590 @0x030590:  al = power[+0x4C + good]; dec ax;
 *                                jns -> keep, else 0
 *                                => bid = max(0, level - 1)
 *   ASK  commodity_current_price @0x030566:  cx = [good*9 - 0x6900];
 *                                al = power[+0x4C + good]; add ax, cx;
 *                                jns -> keep, else 0
 *                                => ask = max(0, level + spread)
 *
 * The @CARGO table at [good*9 - 0x6900] (stride 9) holds the spread, which
 * is the number dat_cargo[].burden already carries -- the port's ask was
 * `burden + 1` and its bid was the level itself, so BOTH quotes came out one
 * high.  The census measured exactly that: all sixteen prices on the 1653
 * Europe market bar read one above the original's (DOS 0/8 6/8 4/6 4/6 5/7
 * ... 1/2 9/10 against the port's 1/9 7/9 5/7 5/7 6/8 ... 2/3 10/11).
 *
 * Not a new finding, either -- docs/COLONIZATION_TECHNICAL_REFERENCE.md:1421
 * has read "Display: sell = level - 1, buy = level + burden" since the
 * PowerRecord table was written, with the worked example at :1433.  Neither
 * engine implemented it.
 *
 * The old `p < 1 ? 1 : p` read-clamp is gone with it: it clamped the LEVEL,
 * and the original clamps the RESULT.  A level of 1 is legal and quotes 0/8,
 * which is what the original's first market cell shows. */
static int market_level(int i) { return me()->price_level[i]; }
int market_bid(int i) {                        /* func_030590 @0x030590 */
    int p = market_level(i) - 1;
    return p < 0 ? 0 : p;
}
int market_ask(int i) {                        /* func_030566 @0x030566 */
    int p = market_level(i) + dat_cargo[i].burden;
    return p < 0 ? 0 : p;
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
    int before = market_level(i);              /* the LEVEL walks, not the bid */
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
