// game_assets.hpp -- the platform-free game asset provider shared by every
// frontend (the Forge editor's game view, the standalone Viceroy player, the
// Teensy port). Tileset sheets + palette (NativeAssets) plus a lazy cache of
// quantized docs/atlas images (PIK backgrounds, contact sheets). No ImGui, no
// SDL, no OS calls beyond file reads -- everything renders into vc::Surface.
#pragma once
#include "native_assets.hpp"   // NativeAssets, IndexedPng, Sheet/Frame
#include "surface.hpp"
#include <map>
#include <string>

namespace forge {

struct GameAssets {
    bool ok = false;
    bool tried = false;
    std::string err;
    vc::NativeAssets nat;
    std::map<std::string, vc::IndexedPng> files;   // docs/atlas-relative -> image
    std::map<std::string, vc::Frame> windows;      // cached contact-sheet windows
};
GameAssets& game_assets();
bool game_assets_ensure();                         // lazy load; false + err on fail

// A quantized docs/atlas image by repo-relative path under docs/atlas/
// (e.g. "pik/COLONY.png", "sprites/atlas_WDCUT04.png"). Null if unreadable.
const vc::IndexedPng* atlas_file(const std::string& rel);

// The tileset Sheet for a catalog sheet name (TERRAIN/PHYS0/UNITS/BUILDING/
// ICONS); null for file-based sheets.
const vc::Sheet* tileset_sheet(const std::string& sheet);

// The native content window of a contact sheet's first cell (the popup
// speaker/scene channel adaptation). The draw scale is detected per sheet
// (2x pixel-double vs native 1x). Null if the sheet is missing.
// `sheet` is the bare name ("KING1", "PARCH", "WDCUT04", "CC-19").
const vc::Frame* sheet_window(const std::string& sheet);

// Compose advisor report F1..F10 (f = 1..10) onto a 320x200 surface from the
// live session (report_state_json). False when assets are unavailable.
bool compose_report(vc::Surface& scr, int f);

} // namespace forge
