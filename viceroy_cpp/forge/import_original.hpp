// import_original.hpp -- ingest the user's ORIGINAL game folder (the one
// carrying VICEROY.EXE and its data files) into the project. The EXE itself
// holds the code -- which the byte-verified reconstruction already
// reimplements -- so the import targets everything that is DATA next to it:
//
//   *.SS   sprite sheets   (MADSPACK/FAB codec, native)
//   *.PIK  backgrounds     (native)
//   *.FF   fonts           (native -- the REAL FONTTINY/FONTINTR/FONTKING)
//   *.PAL  palette         (native)
//   *.MP   maps            (native, byte-faithful)
//   *.TXT  text            (GAME/NAMES/LABELS/MENU -- the records' source)
//
// The files are copied into <project>/raw/COLONIZE/, which every loader
// already prefers over the converted stand-ins -- so one import upgrades the
// editor, the game view, and every build the editor exports.
#pragma once
#include <string>
#include <vector>

namespace forge {

struct ImportReport {
    bool ok = false;
    std::string message;               // one line for the status bar
    std::vector<std::string> notes;    // per-family results for the dialog
    int copied = 0;                    // files copied into raw/COLONIZE
    int decoded = 0;                   // files that decode with the codecs
};

// Copy + decode-verify the original game folder into project_root/raw/COLONIZE.
ImportReport import_original_game(const std::string& src_dir,
                                  const std::string& project_root);

} // namespace forge
