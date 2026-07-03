// studio_shared.hpp -- state + assets shared by the Forge editor panels.
//
// The shell (studio_main.cpp) owns the AppState singleton and the record
// store; the panels (panel_sprites/panel_popups/panel_screens) render against
// the shared native asset set and talk to the store through the same
// chokepoint the Inspector uses (store_set -> journaled, undoable, dirty).
#pragma once
#include "studio.hpp"
#include "native_assets.hpp"   // NativeAssets, IndexedPng, Sheet/Frame
#include "surface.hpp"
#include <functional>
#include <map>
#include <string>

namespace drydock { struct Record; }

namespace studio {

// ---------------------------------------------------------------- app state
struct AppState {
    std::string project;
    bool store_ok = false;
    std::string status;              // one-line status/toast
    int sel_type = -1;               // records browser selection
    std::string sel_id;
    bool game_active = false;
};
AppState& app();

// Jump the Records browser + Inspector to a record id (panel cross-navigation).
void select_record(const std::string& id);

// ------------------------------------------------------------ shared assets
// The tileset sheets + palette (NativeAssets) plus a cache of quantized
// docs/atlas images (PIK backgrounds, contact sheets), loaded on first use.
struct StudioAssets {
    bool ok = false;
    bool tried = false;
    std::string err;
    vc::NativeAssets nat;
    std::map<std::string, vc::IndexedPng> files;   // docs/atlas-relative -> image
    std::map<std::string, vc::Frame> windows;      // cached 28x21 sheet windows
};
StudioAssets& assets();
bool assets_ensure();                              // lazy load; false + err on fail

// A quantized docs/atlas image by repo-relative path under docs/atlas/
// (e.g. "pik/COLONY.png", "sprites/atlas_WDCUT04.png"). Null if unreadable.
const vc::IndexedPng* atlas_file(const std::string& rel);

// The tileset Sheet for a catalog sheet name (TERRAIN/PHYS0/UNITS/BUILDING/
// ICONS); null for file-based sheets.
const vc::Sheet* tileset_sheet(const std::string& sheet);

// The 28x21 native content window of a 928x82 contact sheet's first cell
// (the popup speaker/scene channel adaptation -- same window the web uses:
// PNG rect (1,39) 56x42 at 2x, downsampled). Null if the sheet is missing.
// `sheet` is the bare name ("KING1", "IND0A0", "WDCUT04", "CC-19").
const vc::Frame* sheet_window(const std::string& sheet);

// Render a sprt record to RGB24 over a checkerboard (transparency visible).
// native_w/h receive the unscaled sprite size. False if unresolvable.
bool sprite_image(const drydock::Record& r, vc::Image& out,
                  int* native_w = nullptr, int* native_h = nullptr);

// ------------------------------------------------------------ texture cache
// Static images: created + filled once per key. Live views should own their
// texture and update it each frame instead.
Texture* static_texture(Driver& drv, const std::string& key,
                        const std::function<bool(vc::Image&)>& make);
void invalidate_texture(const std::string& key);

// ---------------------------------------------------------------- panels
void sprites_panel(Driver& drv);
void popups_panel(Driver& drv);
void screens_panel(Driver& drv);

} // namespace studio
