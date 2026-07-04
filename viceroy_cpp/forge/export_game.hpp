// export_game.hpp -- build the standalone game from the CURRENT project data,
// engine-style: the player executable is a prebuilt export template and the
// game itself is the data the editor edits. "Build for Windows" copies the
// curated data set + the Viceroy player next to it; "Build for Teensy" lays
// out the same data as the microSD card image the firmware reads (the
// firmware in teensy/ is flashed once with PlatformIO; every later build is
// just re-exporting the card).
#pragma once
#include <string>

namespace forge {

struct ExportReport {
    bool ok = false;
    int files = 0;               // files copied
    std::string message;         // one-line outcome for the status bar
    std::string detail;          // multi-line notes (template found? next steps)
};

// Copy the game data set from `project_root` into `out_dir` (created; existing
// files overwritten). `teensy` switches the README/layout notes to the SD-card
// flavor. Does NOT save dirty records -- the caller decides (the editor saves
// first so the build reflects live edits).
ExportReport export_game_data(const std::string& project_root,
                              const std::string& out_dir, bool teensy);

// Find the prebuilt Viceroy player template: next to the running executable
// (`argv0_dir`), then the project's build trees. Empty when absent.
std::string find_player_template(const std::string& argv0_dir,
                                 const std::string& project_root);

} // namespace forge
