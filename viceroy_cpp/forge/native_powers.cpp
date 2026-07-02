// forge/native_powers.cpp -- see native_powers.hpp for the byte citations.
#include "native_powers.hpp"
#include "unit.hpp"

#include <cstdlib>

using namespace vc::sim;

namespace forge {

// @TRIBES[t].level (the TribeData +2 column), live-table aware.
int tribe_level(int tribe) {
    JsonValue v = table_cell("@TRIBES[" + std::to_string(tribe) + "].level");
    if (v.is_number()) return (int)v.num;
    if (v.is_string()) { try { return std::stoi(v.str); } catch (...) {} }
    return 1;
}

namespace {
} // namespace

int tension_apply(NativeSettlement& s, int power, int delta,
                  bool is_france, bool pocahontas) {
    if (power < 0 || power > 3) return 0;
    if (delta > 0 && is_france)   delta >>= 1;      // French halving (@0x45E21)
    if (delta > 0 && pocahontas)  delta >>= 1;      // Pocahontas FF 16 (@0x45E30)
    int v = s.tension[power] + delta;
    if (v < 0) v = 0; if (v > 100) v = 100;         // clamp [0,100] (@0x45E4A)
    s.tension[power] = v;
    return v;
}

bool mission_convert_roll(int tl, bool brebeuf, const RandFn& rng) {
    int threshold = tl + 2;                          // TribeData[+2] + 2
    if (brebeuf) threshold <<= 1;                    // Jean de Brebeuf doubling (@0x57300)
    return rng(0, 15) < threshold;                   // fails on roll >= threshold (@0x57316)
}

int native_trade_price(int difficulty, int tax_pct) {
    int offer = 5 * difficulty + 50;                 // the floor (@0x5C976)
    if (2 * tax_pct > offer) offer = 2 * tax_pct;    // max(floor, 2*tax) (@0x5C985)
    if (offer > 90) offer = 90;                      // cap 0x5A (@0x5C9A3)
    return offer;
}

long raze_treasure_gold(int difficulty, int tl, const RandFn& rng) {
    long sum = 0;                                    // sum of 3 x rng(0, 10-diff)
    for (int i = 0; i < 3; ++i) sum += rng(0, 10 - difficulty);
    return sum * rng(0, 6) * 4 * (tl + 1);           // @0x4AAD0..0x4AB35
}

RaidResult native_raid(GameState& g, World& w, NativeSettlement& s, int ci,
                       long turn, bool human_target, const RandFn& rng) {
    RaidResult r;
    Colony& c = w.colonies[ci];
    // Gate roll (@0x5BEFD): random_int(1,12)-1, +(difficulty-2) for a human
    // European target (@0x5BF1A), vs threshold 3*K+1 (@0x5BEE5; K RECONSTRUCTED
    // as the colony's fortification level).
    const bool st = (c.built_mask >> 0) & 1ull, ft = (c.built_mask >> 1) & 1ull,
               fs = (c.built_mask >> 2) & 1ull;
    const int K = ((st || ft || fs) ? 1 : 0) + ((ft || fs) ? 1 : 0);
    int gate = rng(1, 12) - 1;
    if (human_target) gate += g.difficulty - 2;
    if (gate < 3 * K + 1) return r;                  // repelled -> @RAIDNOTHING
    // Base outcome (@0x5BF35), downgraded in the early game (@0x5BF44).
    int outcome = rng(1, 4);
    if (turn < 40 * (2 - g.difficulty) && outcome > 0) --outcome;
    r.outcome = outcome;
    switch (outcome) {
        case 1: {                                    // @RAIDSTORES: loot a stocked good
            for (int gd = 0; gd < NGOODS; ++gd)
                if (c.stockpile[gd] > 0 && (r.good < 0 || c.stockpile[gd] > c.stockpile[r.good]))
                    r.good = gd;
            if (r.good < 0) { r.outcome = 0; break; }
            int take = c.stockpile[r.good] / 2;      // "large quantities" (share RECONSTRUCTED)
            if (take < 1) take = c.stockpile[r.good];
            c.stockpile[r.good] -= take;
            s.wealth += 25;                          // the +0x0A wealth bump (@0x5C3E4)
            r.key = "@RAIDSTORES";
            break;
        }
        case 2: {                                    // @RAIDWREAK: havoc -- build bank razed
            c.build_bank = 0; c.hammers_accum = 0;   //   (target RECONSTRUCTED: work undone)
            r.key = "@RAIDWREAK";
            break;
        }
        case 3: {                                    // @RAIDGOLD: strongboxes plundered
            Power& p = g.powers[c.owner_power];
            long take = p.gold / 10;                 // share RECONSTRUCTED (the %NUMBER0 fill)
            if (take > 100) take = 100;
            if (take < 0) take = 0;
            p.gold -= take; r.gold = take;
            s.wealth += (int)(take / 4);
            r.key = "@RAIDGOLD";
            break;
        }
        case 4: {                                    // @RAIDBURN / @RAIDSHIP family
            for (int i = 0; i < (int)w.units.size(); ++i) {
                const Unit& u = w.units[i];
                if (u.alive && u.owner == c.owner_power && u.x == c.x && u.y == c.y &&
                    u.type >= CARAVEL && u.type <= MAN_O_WAR) { r.ship = i; break; }
            }
            if (r.ship >= 0) {                       // a docked ship takes the hit
                w.units[r.ship].moves_left = 0;
                r.key = "@RAIDSHIP";
            } else {                                 // else burn the highest built building
                for (int b = 47; b >= 0; --b)
                    if ((c.built_mask >> b) & 1ull) { r.building = b; break; }
                if (r.building >= 0) c.built_mask &= ~(1ull << r.building);
                r.key = r.building >= 0 ? "@RAIDBURN" : "@RAIDWREAK";
            }
            break;
        }
        default: break;                              // 0 -> @RAIDNOTHING
    }
    return r;
}

ChiefKillResult chiefkill(const vc::sim::GameState& g, const NativeSettlement& s,
                          int attacker_class, const vc::sim::RandFn& rng) {
    ChiefKillResult r;
    const int scout = attacker_class == 0x16 ? 1 : 0;    // Seasoned Scout (@0x4A7D9)
    const int sz = s.population;
    if (sz >= 75) {                                      // big-treasure branch (@0x4A802)
        r.razed = true;
    } else {
        int bound = s.tribe == 2 ? ((8 - g.difficulty) << scout)   // tribe-2 special (@0x4A84A)
                                 : (40 * scout + 100);             // (@0x4A81A)
        if (bound < 1) bound = 1;
        int roll = rng(0, bound);
        if (sz >= 25)                                    // size re-roll (@0x4A832..41)
            for (int t = 0; t < 16 && sz / 4 >= roll; ++t) roll = rng(0, bound);
        r.razed = roll >= s.alarm[0];                    // escape check vs alarm (@0x4A97A;
    }                                                    //   direction RECONSTRUCTED)
    if (r.razed)
        r.gold = raze_treasure_gold(g.difficulty, tribe_level(s.tribe), rng);
    return r;
}

int settlement_attitude(int presence_x, int alarm) {
    // Attitude banding (natives.md @0x048AFE / @0x048B62..@0x048B90):
    // score = 8*X - 5; bands < -5 Content(0) / -5..0 Uneasy(1) / 0..<10
    // Restless(2) / >= 10 Angry(3). War(4) is the separate alarm >= 128
    // state. X = the colonial-presence score (its composition is not
    // decomposed in the trace -- callers supply it).
    if (alarm >= 128) return 4;
    const int score = 8 * presence_x - 5;
    if (score < -5) return 0;
    if (score <= 0) return 1;
    if (score < 10) return 2;
    return 3;
}

NativeTurn native_turn_step(GameState& g, World& w, EngineExtra& x, const RandFn& rng) {
    NativeTurn out;
    for (int si = 0; si < (int)x.settlements.size(); ++si) {
        NativeSettlement& s = x.settlements[si];
        // Per-turn tension normalization decay (the @0x485E7 loop).
        for (int p = 0; p < 4; ++p)
            if (s.tension[p] > 0) --s.tension[p];
        // Mission conversion (func_0572E6): the mission's owner may gain a convert.
        if (s.mission >= 0 && s.mission < 4) {
            const bool brebeuf = s.mission == 0 && ((x.ff_owned >> 22) & 1u);  // FF 0x16
            if (mission_convert_roll(tribe_level(s.tribe), brebeuf, rng)) {
                int best = -1; long bd = 1 << 20;
                for (int ci = 0; ci < (int)w.colonies.size(); ++ci) {
                    const Colony& c = w.colonies[ci];
                    if (c.owner_power != s.mission || c.x < 0) continue;
                    long d = std::abs(c.x - s.x) + std::abs(c.y - s.y);
                    if (d < bd) { bd = d; best = ci; }
                }
                if (best >= 0) {
                    Colony::Worker wk;                 // the convert: class 0x1B
                    wk.profession = 0x1B; wk.tile = 0; wk.good = 0;
                    wk.terrain = w.colonies[best].center_terrain;
                    w.colonies[best].workers.push_back(wk);
                    w.colonies[best].population += 1;
                    out.converts.push_back({si, best});
                }
            }
        }
        // Raids: hostile toward a power (tension >= 75 or alarm >= 128) -> raid
        // that power's nearest colony (one raid per settlement per turn), gated
        // by the byte-verified probability rolls: the global aggressive-action
        // gate random_int(1000) < 200*diff + 100 (10%..90%, @0x4A73D/@0x58315)
        // and the per-settlement attack chance random_int((5-diff)*2) == 0
        // (@0x48697 -- the bound shrinks at higher difficulty).
        for (int p = 0; p < 4; ++p) {
            if (s.tension[p] < TENSION_HOSTILE && s.alarm[p] < 128) continue;
            if (rng(0, 999) >= 200 * g.difficulty + 100) continue;
            { const int bound = (5 - g.difficulty) * 2;
              if (bound > 1 && rng(0, bound - 1) != 0) continue; }
            int best = -1; long bd = 1 << 20;
            for (int ci = 0; ci < (int)w.colonies.size(); ++ci) {
                const Colony& c = w.colonies[ci];
                if (c.owner_power != p || c.x < 0) continue;
                long d = std::abs(c.x - s.x) + std::abs(c.y - s.y);
                if (d < bd) { bd = d; best = ci; }
            }
            if (best < 0) continue;
            RaidResult rr = native_raid(g, w, s, best, g.turn, p == 0, rng);
            out.raids.push_back({si, rr});
            break;
        }
    }
    return out;
}

int tribe_attitude(bool human, int difficulty, int tribe_level, int tribe_value,
                   int prior, bool& hostile) {
    int v;
    if (human) { v = 2 * (difficulty + 3) + tribe_level + tribe_value - prior;   // @0x46500
                 hostile = v >= 0x41; }
    else       { v = tribe_level + tribe_value - difficulty + 12 - prior;        // @0x46538
                 hostile = v >= 0x32; }
    return v;
}

} // namespace forge
