// forge/savegame.hpp -- serialize/deserialize a full game (GameState + World).
//
// Save/load is an I/O concern, so it lives here (forge), NOT in the pure sim core
// -- the core stays headless/dependency-free (so it still cross-compiles for
// ESP32, which can add a compact binary writer later). The format is JSON
// (modding/debug-friendly); the runtime form is free per the fidelity policy.
#pragma once

#include "game.hpp"   // vc::sim::GameState, World
#include <string>

namespace forge {

struct LoadedGame { vc::sim::GameState g; vc::sim::World w; };

// In-memory (used by the round-trip self-test).
std::string dump_game(const vc::sim::GameState& g, const vc::sim::World& w);
LoadedGame  parse_game(const std::string& json);   // throws std::runtime_error on error

// File I/O.
void       save_game(const std::string& path, const vc::sim::GameState& g, const vc::sim::World& w);
LoadedGame load_game(const std::string& path);     // throws std::runtime_error on error

} // namespace forge
