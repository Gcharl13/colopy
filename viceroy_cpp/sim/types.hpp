// sim/types.hpp -- modern game-state model for the economic-spine sim core.
//
// Field-faithful to the byte-verified spec (spec/systems/*), but NOT byte-layout
// faithful: plain int/int64 are fine ("modernize the math") as long as the
// observable outputs match (REWRITE_READINESS.md §1). Comments cite the original
// ColonyRecord/PowerRecord offsets for traceability.
#pragma once
#include <cstdint>
#include <array>
#include <vector>

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
    int  population  = 1;        // +0x1F  (max 32)

    // Sons-of-Liberty 32-bit EMA (rebel dividend A / divisor B).
    int32_t rebel_A = 0;         // +0xC2
    int32_t rebel_B = 1;         // +0xC6  (>=1)

    uint32_t hammers_accum = 0;  // +0x92  raw per-turn hammer sum (early gate)
    uint32_t build_bank    = 0;  // +0xB6  progress bank ("X of Y"), surplus carried
    int      build_target  = -1; // +0x94  building id (<0 = none)
    int      build_cost    = 0;  // cost of build_target (from @BUILDING)
    int      warehouse_lvl = 0;  // +0x95  0/1/2
    uint64_t built_mask    = 0;  // +0x84  constructed-building bits (0..47)
    uint32_t food_accum    = 0;  // +0xAA  food-growth store (spec/systems/colony.md §3; threshold
                                 //        25 with Stable / 50 without). NOT +0xC8 -- that offset is
                                 //        the rebel_divisor high word of the SoL EMA (colony.md q2).

    // Per-turn production inputs (fed by the colonist/profession model, P1+):
    int bells_per_turn   = 0;    // statesmen -> good 0x12
    int hammers_per_turn = 0;    // carpenters -> good 0x10
    int food_per_turn    = 0;    // net food surplus
    int crosses_output   = 0;    // +0x05  preacher crosses (feeds immigration)
    int center_food      = 0;    // authored fallback for the town-square auto-food
    int center_terrain   = 0;    // the colony's own tile terrain id (center auto-produces its food)
    bool tory_risen      = false;// +0x1C bit0 latch: a Tory uprising has already fired here (no re-fire)

    // Worker/stockpile model (spec/systems/colony.md §3). Each Worker is a colonist assigned
    // to a tile (raw goods 0..7 from the terrain-yield table) or a building (bells/hammers/
    // crosses); production accumulates into the per-good stockpile (+0x9A, capped by warehouse).
    std::array<int32_t, NGOODS> stockpile{};   // +0x9A  current cargo per good
    // Each Worker is one colonist: a profession (@JOB id, +0x40 colonist_job_skills, the
    // identity/skill), assigned either to a surrounding ring tile (tile 0..7, +0x70
    // tile_worker_assignment) producing a raw good (good 0..7), or to a building slot
    // (tile = -1) producing Hammers(16)/Crosses(17)/Bells(18). expert = the colonist is a
    // specialist at that good (era good +2, manufactured x2).
    struct Worker { int profession = 19; int tile = -1; int terrain = 0; int good = 0; bool expert = false; };
    std::vector<Worker> workers;               // colonist roster (job + tile assignment)
};

struct Power {
    int64_t royal_money = 0;         // PowerRecord +0x22 (REF budget; SALES TAX accrues here, king.md:92)
    int64_t gold        = 0;         // +0x2A
    int     tax         = 0;         // +0x01
    std::array<int32_t, NGOODS> trade{};  // +0xFC per-turn trade volume: SELL += qty, BUY -= qty
                                          // (market.md @0x323BC/@0x32324); reset by the turn drift
    std::array<int32_t, NGOODS> price_level{};  // +0x4C published per-good price level: the market
                                          // pays bid = max(level-1, 0); you pay ask = bid+burden+1
                                          // (market.md @0x30566/@0x30590 + @CARGO.burden, USER RULING)

    int crosses_accum     = 0;       // +0x2E  accumulated crosses
    int crosses_threshold = 0;       // +0x30  spawn threshold (recomputed each turn)
    std::array<int, 3> dock_pool{{-1, -1, -1}};  // +0x02..+0x04 waiting immigrant types
};

// Royal Expeditionary Force counts (DGROUP 0x53DA..0x53E0).
struct Ref { int regulars = 0, cavalry = 0, manowar = 0, artillery = 0; };

struct GameState {
    int  year   = 1492;          // [0x538A]
    int  season = 0;             // [0x538C]  0=Spring/early, 1=Autumn
    long turn   = 0;             // [0x538E]
    int  difficulty = 1;         // [0x53A6]  0..4
    int  nation = 0;             // human player's @COUNTRY (0=England..3=Netherlands)

    std::array<Power, 4> powers{};
    std::array<int32_t, NGOODS> price_base{};  // DGROUP 0x53EA (per-good, [600,1000])
    Ref ref;
};

} // namespace vc::sim
