// sim/trade_routes.hpp -- per-turn trade-route automation (spec/systems/trade_routes.md).
//
// func_041080 (BYTE_VERIFIED): a unit whose order byte is 2 ("Trade Route",
// @ORDERS row 2, key T) is automated each turn. The arrival test @0x41034
// compares the unit's position to the current stop -- Europe (dest 0x3E7) means
// the sea-lane column; a colony means its (X,Y) from ColonyRecord +0x00/+0x01.
// On arrival the stop's good lists run through the cargo primitives
// (load/unload loop @0x411D8..0x4128C), the next stop is selected, and its
// (X,Y) is written into the unit's GoTo cache (+0x314D/+0x314E, @0x4115F).
//
// Cargo primitives:
//   LOAD  (colony -> unit)  func_00B880: sub [colony+0x9A+good*2] @0xB8A5, cap 100
//   UNLOAD(unit -> colony)  func_00B8D0: add [colony+0x9A+good*2] @0xB8F5
//   Europe (dest 0x3E7 @0x4119A): the generic Europe sell/buy subtree
//   (func_032914/func_0324F2) -- i.e. the market.md 3.1 path: sale credits gold
//   net of tax, the tax accrues to the King's REF fund, volume rides the trade
//   accumulator; buy is untaxed.
#pragma once
#include "types.hpp"
#include "game.hpp"   // World
#include "rules.hpp"

namespace vc::sim {

// One automation step for w.units[unit_idx] (order == ORDER_TRADE_ROUTE). If the
// unit stands on its current stop, runs that stop's unload+load lists and
// advances the stop cursor; then (re)targets the unit's GoTo at the current
// destination. Clears the order when the route binding is invalid (func_041080
// re-checks the order byte @0x041089 and bails). Never adds/removes units.
void trade_route_step(GameState& g, World& w, int unit_idx,
                      const RuleData& rd = default_rules());

} // namespace vc::sim
