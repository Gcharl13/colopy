// forge/turnpipe.hpp -- the turn loop as data (A3).
//
// step_turn's fixed 6-phase order is authored in data_extracted/engine/turn.json.
// run_turn() reads that phase list and dispatches each enabled phase to the same
// byte-verified sim function the reference sim::step_turn calls -- so the turn is
// data (reorderable / disableable, editable in the B5 turn editor) while behavior
// stays identical (a golden-master test asserts run_turn == sim::step_turn).
#pragma once

#include "game.hpp"      // vc::sim::GameState, World, RandFn
#include "events.hpp"    // vc::sim::RumorResult
#include "training.hpp"  // vc::sim::TeachResult
#include "unit_turn.hpp" // vc::sim::PromoteResult

#include <string>
#include <utility>
#include <vector>

namespace forge {

// Run one turn by iterating the data pipeline (turn.json, cached on first use).
// Behaviorally identical to vc::sim::step_turn for the default pipeline. ff_owned is the human
// power's founding-father bitmask (production applies the father effects); 0 = none.
void run_turn(vc::sim::GameState& g, vc::sim::World& w, const vc::sim::RandFn& rng,
              int player_idx, const vc::sim::RuleData& rd, uint32_t ff_owned = 0);

// Run ONE named phase of the pipeline (the same dispatch run_turn uses). The Systems
// browser's per-turn trace steps the pipeline phase-by-phase, snapshotting each phase's
// declared writes between calls. Unknown ids are a no-op.
void run_turn_phase(const std::string& id, vc::sim::GameState& g, vc::sim::World& w,
                    const vc::sim::RandFn& rng, int player_idx, const vc::sim::RuleData& rd,
                    uint32_t ff_owned = 0);

// The enabled phase ids in pipeline order (turn.json, cached; default order fallback).
const std::vector<std::string>& enabled_turn_phases();

// Lost-City rumor events resolved during the units phase (events.md), accumulated
// for the caller to drain into turn notices / popups.
std::vector<vc::sim::RumorResult>& rumor_log();

// School graduations / no-student stalls from the production phase, as
// (colony index, result) -- drained into the @TRAINPROFESSION/@TRAINFAIL notices.
std::vector<std::pair<int, vc::sim::TeachResult>>& teach_log();

// Battlefield promotions from the units phase (training.md 3) -- drained into
// the @VETERAN/@CONTINENTAL notices.
std::vector<vc::sim::PromoteResult>& promote_log();

// Drop the cached turn.json (call after the turn editor saves so the next turn
// uses the edited pipeline without a restart).
void invalidate_turn_pipeline();

} // namespace forge
