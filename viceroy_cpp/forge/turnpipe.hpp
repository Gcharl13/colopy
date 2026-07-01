// forge/turnpipe.hpp -- the turn loop as data (A3).
//
// step_turn's fixed 6-phase order is authored in data_extracted/engine/turn.json.
// run_turn() reads that phase list and dispatches each enabled phase to the same
// byte-verified sim function the reference sim::step_turn calls -- so the turn is
// data (reorderable / disableable, editable in the B5 turn editor) while behavior
// stays identical (a golden-master test asserts run_turn == sim::step_turn).
#pragma once

#include "game.hpp"    // vc::sim::GameState, World, RandFn

namespace forge {

// Run one turn by iterating the data pipeline (turn.json, cached on first use).
// Behaviorally identical to vc::sim::step_turn for the default pipeline.
void run_turn(vc::sim::GameState& g, vc::sim::World& w, const vc::sim::RandFn& rng,
              int player_idx, const vc::sim::RuleData& rd);

// Drop the cached turn.json (call after the turn editor saves so the next turn
// uses the edited pipeline without a restart).
void invalidate_turn_pipeline();

} // namespace forge
