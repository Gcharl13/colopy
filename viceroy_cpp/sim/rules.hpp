// sim/rules.hpp -- RuleData: the data-driven, moddable parameter set.
//
// This is the "RuleData seam": the sim reads its balance numbers from a RuleData
// instance rather than from file-static literals, so the same headless core can be
// driven by edited data (the modding tool / "Forge"), shared by every front-end
// (Godot, ESP32) without forking logic. It is injected like the RNG (RandFn):
// pass a `const RuleData&` to the functions that need it, or use the free-function
// overloads that fall back to default_rules().
//
// default_rules() is value-identical to the original literals -- the existing
// golden-master vectors hold unchanged. A JSON loader (kept OUT of this pure,
// dependency-free core; it lives in the importer/Forge) can override the
// balance fields from data_extracted/tables/*.json.
//
// What is data (moddable) vs code (structural):
//   - units[i].attack/defense/cargo  <- @UNIT attack/combat/cargo (value-identical)
//   - terrain_defense[id]            <- @TERRAIN "Defensive" column
//   - units[i].name / units[i].move_class  stay CODE-side: the names are display
//     strings and move_class (1=land / 99=naval / 6=treasure / 0=native) is a
//     structural classification not present in @UNIT. See notes/rulings.
#pragma once

#include "unit.hpp"
#include <array>

namespace vc::sim {

// Number of distinct terrain ids (0..28): 0..7 base, 8..23 forest variants,
// 24 Arctic, 25 Ocean, 26 Sea Lane, 27 Mountains, 28 Hills.
constexpr int NTERRAIN = 29;

struct RuleData {
    std::array<UnitStats, NUNITTYPES> units{};
    std::array<int, NTERRAIN> terrain_defense{};   // "Defensive" value by terrain id
    // Later F1 increments extend this: cargo/market params (@CARGO),
    // building costs (@BUILDING), founding-father curve, economy scalars.
};

// Build a fresh default ruleset (value-identical to the historical literals).
RuleData make_default_rules();

// The shared canonical default ruleset (built once).
const RuleData& default_rules();

} // namespace vc::sim
