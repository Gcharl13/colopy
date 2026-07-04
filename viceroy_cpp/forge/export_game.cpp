// export_game.cpp -- see export_game.hpp. Mirrors tools/package_player.py's
// curated set (which self-tests in CI); keep the two lists in step.
#include "export_game.hpp"
#include <filesystem>
#include <fstream>

namespace fs = std::filesystem;

namespace forge {

static const char* COPY_TREES[] = {
    "data",
    "data_extracted/tileset",
    "data_extracted/map",
    "data_extracted/engine",
    "data_extracted/text",
    "docs/atlas/pik",
};
static const char* COPY_FILES[] = {
    "data_extracted/palette.json",
    "docs/atlas/sprites/atlas_PARCH.png",
};

static const char* README_WIN = R"(Viceroy -- your build of the reconstructed game
================================================

Built by Forge from the project's data. Double-click Viceroy.exe (it reads
the data folders next to it). If Viceroy.exe is missing, copy the player
template next to this README -- the data here is complete without it.

Keys: Enter starts/ends turns, arrows move, Tab next unit, B founds a
colony, E Europe, F1..F10 reports, click your colony to manage it,
F11 saves, Esc backs out. Full map in the project README.

Private build: the art is converted from the original game's files --
do not redistribute.
)";

static const char* README_TEENSY = R"(Viceroy -- Teensy 4.1 microSD card image
=========================================

Copy EVERYTHING in this folder to the ROOT of the microSD card (FAT32 or
exFAT), then insert it into the Teensy 4.1.

The firmware is flashed once from the repo's teensy/ project
(`pio run -t upload`; see teensy/README.md for wiring + PSRAM). After
that, rebuilding your game = re-exporting this card from Forge.

Optional trims for boot time: data/base/sprt/ may be deleted (the player
reads the tileset sheets directly).

Private build: converted original art -- do not redistribute.
)";

ExportReport export_game_data(const std::string& project_root,
                              const std::string& out_dir, bool teensy) {
    ExportReport r;
    try {
        fs::path root(project_root.empty() ? "." : project_root);
        fs::path out(out_dir);
        fs::create_directories(out);
        const auto opts = fs::copy_options::recursive |
                          fs::copy_options::overwrite_existing;
        for (const char* tree : COPY_TREES) {
            fs::path src = root / tree;
            if (!fs::exists(src)) {
                r.message = std::string("missing in project: ") + tree;
                return r;
            }
            fs::create_directories(out / tree);
            fs::copy(src, out / tree, opts);
        }
        for (const char* f : COPY_FILES) {
            fs::path src = root / f;
            if (!fs::exists(src)) continue;          // PARCH atlas is optional
            fs::create_directories((out / f).parent_path());
            fs::copy_file(src, out / f, fs::copy_options::overwrite_existing);
        }
        // count what landed (also proves the copy is readable)
        for (auto it = fs::recursive_directory_iterator(out);
             it != fs::recursive_directory_iterator(); ++it)
            if (it->is_regular_file()) ++r.files;
        std::ofstream(out / "README.txt") << (teensy ? README_TEENSY : README_WIN);
        r.ok = true;
        r.message = "exported " + std::to_string(r.files) + " files";
    } catch (const std::exception& e) {
        r.message = std::string("export failed: ") + e.what();
    }
    return r;
}

std::string find_player_template(const std::string& argv0_dir,
                                 const std::string& project_root) {
    const char* names[] = {"Viceroy.exe", "viceroy"};
    fs::path roots[] = {fs::path(argv0_dir),
                        fs::path(project_root) / "viceroy_cpp" / "build-win",
                        fs::path(project_root) / "viceroy_cpp" / "build"};
    for (const fs::path& d : roots)
        for (const char* n : names) {
            std::error_code ec;
            fs::path p = d / n;
            if (!d.empty() && fs::exists(p, ec)) return p.string();
        }
    return "";
}

} // namespace forge
