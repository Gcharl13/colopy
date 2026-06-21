// sim/types.hpp -- modern game-state model for the economic-spine sim core.
//
// Field-faithful to the byte-verified spec (spec/systems/*), but NOT byte-layout
// faithful: plain int/int64 are fine ("modernize the math") as long as the
// observable outputs match (REWRITE_READINESS.md §1). Comments cite the original
// ColonyRecord/PowerRecord offsets for traceability.
#pragma once
#include <cstdint>
#include <array>

namespace vc::sim {

// 16 tradable goods, index order from NAMES @CARGO (spec/systems/market.md).
enum Good : int {
    FOOD = 0, SUGAR, TOBACCO, COTTON, FURS, LUMBER, ORE, SILVER,
    HORSES, RUM, CIGARS, CLOTH, COATS, TRADE_GOODS, TOOLS, MUSKETS,
    NGOODS = 16
};

// "Era" goods get +2 from an expert; all others ("manufactured") get x2.
// (spec/systems/colony.md compute_terrain_yield @0x9DAD)
inline bool good_is_era(int g) { return g == FOOD || g == HORSES; }

struct Colony {
    int  owner_power = 0;        // ColonyRecord +0x1A
    bool human       = true;     // controller gate (+0x543F on the power)
    int  population  = 1;        // +0x1F

    // Sons-of-Liberty 32-bit EMA (rebel dividend A / divisor B).
    int32_t rebel_A = 0;         // +0xC2
    int32_t rebel_B = 1;         // +0xC6  (>=1)

    uint32_t hammers_accum = 0;  // +0x92  raw per-turn hammer sum (early gate)
    uint32_t build_bank    = 0;  // +0xB6  progress bank ("X of Y"), surplus carried
    int      build_target  = -1; // +0x94  building id (<0 = none)
    int      warehouse_lvl = 0;  // +0x95  0/1/2
    uint64_t built_mask    = 0;  // +0x84  constructed-building bits (0..47)
};

struct Power {
    int64_t royal_money = 0;         // PowerRecord +0x22 (REF budget)
    int64_t gold        = 0;         // +0x2A
    int     tax         = 0;         // +0x01
    std::array<int32_t, NGOODS> trade{};  // +0xFC cumulative trade accumulator
};

// Royal Expeditionary Force counts (DGROUP 0x53DA..0x53E0).
struct Ref { int regulars = 0, cavalry = 0, manowar = 0, artillery = 0; };

struct GameState {
    int  year   = 1492;          // [0x538A]
    int  season = 0;             // [0x538C]  0=Spring/early, 1=Autumn
    long turn   = 0;             // [0x538E]
    int  difficulty = 1;         // [0x53A6]  0..4

    std::array<Power, 4> powers{};
    std::array<int32_t, NGOODS> price_base{};  // DGROUP 0x53EA (per-good, [600,1000])
    Ref ref;
};

} // namespace vc::sim
