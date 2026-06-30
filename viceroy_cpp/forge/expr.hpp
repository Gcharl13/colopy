// forge/expr.hpp -- a tiny dependency-free numeric expression evaluator for the Formula node.
//
// One Formula node holds a text expression that references the game's variables directly --
// live state (game.turn, power0.gold, colony0.hammers, revolution.sol) and data-table cells
// (@BUILDING[name:Fort].cost, @CLASS[3].transport_cost) -- plus arithmetic, comparisons,
// min/max/clamp/abs/floor/ceil, a ternary cond?a:b, and roll(lo,hi). This collapses long
// Constant/Math/Compare node chains into a single readable node.
#pragma once

#include <functional>
#include <string>

namespace forge {

// Evaluate `expr`. `var` resolves an identifier (e.g. "power0.gold", "@BUILDING[1].cost",
// or a Formula pin "a".."d") to a number. `rng(lo,hi)` backs roll(lo,hi). Best-effort:
// never throws -- a parse/lookup error yields 0 and (optionally) an error string in *err.
double eval_expr(const std::string& expr,
                 const std::function<double(const std::string&)>& var,
                 const std::function<int(int, int)>& rng,
                 std::string* err = nullptr);

} // namespace forge
