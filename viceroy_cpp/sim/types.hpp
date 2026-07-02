// sim/types.hpp -- modern game-state model for the economic-spine sim core.
//
// Field-faithful to the byte-verified spec (spec/systems/*), but NOT byte-layout
// faithful: plain int/int64 are fine ("modernize the math") as long as the
// observable outputs match (REWRITE_READINESS.md §1). Comments cite the original
// ColonyRecord/PowerRecord offsets for traceability.
#pragma once
#include <cstdint>
#include <array>
#include <string>
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
    int  x = -1, y = -1;         // ColonyRecord +0x00 / +0x01 map position (-1 = unplaced)
    int  owner_power = 0;        // ColonyRecord +0x1A
    bool human       = true;     // controller gate (+0x543F on the power)
    int  population  = 1;        // +0x1F  (max 32)

    // Sons-of-Liberty 32-bit EMA (rebel dividend A / divisor B).
    int32_t rebel_A = 0;         // +0xC2
    int32_t rebel_B = 200;       // +0xC6  (>=1) -- founding init B=200/A=0, RUNTIME-
                                 //   CONFIRMED (colony_jamestown.bin, colony.md 2);
                                 //   the 1/64 EMA decays it toward 128*pop

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
    int  status_latch    = 0;    // +0x1C bits 0x04/0x02: SoL announcement hysteresis latches
                                 //   (majority announced / unanimous announced; func_02D658
                                 //   @0x2DB29/@0x2DB6E/@0x2DBB4/@0x2DBFA)

    // Worker/stockpile model (spec/systems/colony.md §3). Each Worker is a colonist assigned
    // to a tile (raw goods 0..7 from the terrain-yield table) or a building (bells/hammers/
    // crosses); production accumulates into the per-good stockpile (+0x9A, capped by warehouse).
    std::array<int32_t, NGOODS> stockpile{};   // +0x9A  current cargo per good
    // Each Worker is one colonist: a profession (@JOB id, +0x40 colonist_job_skills, the
    // identity/skill), assigned either to a surrounding ring tile (tile 0..7, +0x70
    // tile_worker_assignment) producing a raw good (good 0..7), or to a building slot
    // (tile = -1) producing Hammers(16)/Crosses(17)/Bells(18). expert = the colonist is a
    // specialist at that good (era good +2, manufactured x2).
    // teach = the per-student school counter (spec/systems/training.md 3: read/incremented
    // each turn via 0x181F:0xD1C, reset on graduation; graduates at 4/6/8 turns by tier).
    struct Worker { int profession = 19; int tile = -1; int terrain = 0; int good = 0;
                    bool expert = false; int teach = 0; };
    std::vector<Worker> workers;               // colonist roster (job + tile assignment)
};

struct Power {
    int64_t royal_money = 0;         // PowerRecord +0x22 (REF budget; SALES TAX accrues here, king.md:92)
    int64_t gold        = 0;         // +0x2A
    int     tax         = 0;         // +0x01
    uint16_t boycotts   = 0;         // +0x20 per-good boycott bitmask (boycotts.md: set on a
                                     //   Tea Party @0x34717, tested by the sell logic
                                     //   func_030B38, cleared on back-tax payment @0x33423
                                     //   or in full by Jakob Fugger FF 1 @0x3BD45)
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

// --- Trade routes (spec/systems/trade_routes.md, BYTE_VERIFIED layout) ---
// The EXE keeps route definitions in segment 0x1B22 (record stride 0x4A, max 12
// routes, active count [0x53A0] capped 0xC @0x610B5 -> @TRADEMANY). Record:
// +0x00 name (32 B, uniqueness strcmp @0x611FF), +0x20 type byte (0=sea 1=land
// @0x61282), +0x21 stop cursor, +0x22 stop array (stride 0x0A, up to 4 stops).
// Stop entry: +0x00 dest word (colony id, 0x3E7=Europe, 0x3E8=none), +0x02
// packed counts (low nibble = UNLOAD, high nibble = LOAD, func_060382), then
// nibble-packed good ids: LOAD lane +0x03..+0x05, UNLOAD lane +0x06..+0x08
// (lane split byte-confirmed func_060D8C @0x060E83).
constexpr int MAX_TRADE_ROUTES  = 12;    // [0x53A0] cap 0xC
constexpr int MAX_ROUTE_STOPS   = 4;     // (0x4A-0x22)/0x0A
constexpr int MAX_LANE_GOODS    = 6;     // 3 lane bytes x 2 good nibbles per lane
constexpr int ROUTE_DEST_EUROPE = 999;   // 0x3E7
constexpr int ROUTE_DEST_NONE   = 1000;  // 0x3E8

struct TradeStop {
    int dest = ROUTE_DEST_NONE;   // colony index, ROUTE_DEST_EUROPE, or _NONE
    std::vector<int> load;        // good ids to LOAD here  (+0x03..+0x05, @CARGOLOAD)
    std::vector<int> unload;      // good ids to UNLOAD here (+0x06..+0x08, @CARGOUNLOAD)
};
struct TradeRoute {
    std::string name;             // +0x00 (@TRADENAMES offers 5 presets)
    int type = 0;                 // +0x20: 0 = sea, 1 = land
    std::vector<TradeStop> stops; // +0x22 (up to MAX_ROUTE_STOPS)
};

struct GameState {
    int  year   = 1492;          // [0x538A]
    int  season = 0;             // [0x538C]  0=Spring/early, 1=Autumn
    long turn   = 0;             // [0x538E]
    int  difficulty = 1;         // [0x53A6]  0..4
    int  nation = 0;             // human player's @COUNTRY (0=England..3=Netherlands)
    int  rumor_seed = 0;         // [0x190] map seed for the Lost-City rumor coordinate
                                 //   hash (func_064A10 stores random_int(0,0x7fff) @0x64A23)

    std::array<Power, 4> powers{};
    std::array<int32_t, NGOODS> price_base{};  // DGROUP 0x53EA (per-good, [600,1000])
    Ref ref;
    std::vector<TradeRoute> routes;            // segment 0x1B22 route table (max 12)

    // Strategic plan-map (spec/systems/ai.md 6.1, BYTE-VERIFIED layout): the
    // 4-byte records at DS:0x98B0, POWER-indexed 4x64 (byte addr =
    // ((power<<6)+slot)<<2). goal_type 0xFF = empty; 0..7 = the capbit position
    // a matching unit must carry ((1<<G) & @UNIT capbits, reader @0x04DFF4).
    // Setter func_04C3A2 priority-inserts; clearer func_04C1F0 writes {FF,0}.
    // Per-turn scratch, refilled by the strategic pass -- not persisted.
    struct PlanSlot { int x = 0, y = 0, goal_type = 0xFF, priority = 0; };
    std::array<std::array<PlanSlot, 64>, 4> plan{};

    // Lost-City rumor bias state (events.md 2): the per-power anti-streak
    // floor [bp-0x2C] (min(prev+1,3) each rumor -- FoY/Cibola only reachable
    // on the FIRST rumors), the per-game rare-outcome caps [0x1DC6]/[0x1DC7]
    // (max 1 Fountain / 7 Cibolas), and the once-per-power burial special
    // (AIPersonality +0x30 bit 0x40 @0x6186B).
    std::array<int, 4> rumor_floor{};
    int fountains_found = 0;
    int cibolas_found   = 0;
    std::array<bool, 4> burial_special_used{};
};

// The power's @NATIONALITY row (national_powers.md 2): in the EXE the power
// INDEX is the nationality (0 English / 1 French / 2 Spanish / 3 Dutch) and
// every national effect is a literal index test. Our engine fixes the human
// at slot 0 playing game.nation, so slot 0 maps to the chosen nation and the
// AI slots keep their index. (When the human picks a rival's nation the
// nationality is duplicated across two powers -- an engine artifact, noted.)
inline int power_nation(const GameState& g, int power) {
    return power == 0 ? g.nation : power;
}

} // namespace vc::sim
