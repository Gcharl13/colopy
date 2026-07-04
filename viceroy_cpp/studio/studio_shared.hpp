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
#include "../forge/game_assets.hpp"   // the shared platform-free asset provider
#include "imgui.h"
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
// The asset provider itself is platform-free and shared with the standalone
// player + Teensy frontends (forge/game_assets.hpp) -- the studio names alias
// it so the panels keep reading naturally.
using StudioAssets = forge::GameAssets;
inline StudioAssets& assets() { return forge::game_assets(); }
inline bool assets_ensure() { return forge::game_assets_ensure(); }
using forge::atlas_file;
using forge::tileset_sheet;
using forge::sheet_window;

// Render a sprt record to RGB24 over a checkerboard (transparency visible).
// native_w/h receive the unscaled sprite size. False if unresolvable.
bool sprite_image(const drydock::Record& r, vc::Image& out,
                  int* native_w = nullptr, int* native_h = nullptr);

// --------------------------------------------------------- crisp rendering
// Draw a game texture with NEAREST sampling (pixel-art crisp on every
// backend; the editor UI keeps its linear sampler). ALWAYS use this for the
// 320x200 stages and sprite images -- plain ImGui::Image goes through the
// backend's default bilinear sampler and blurs every upscale.
void pixel_image(const Texture& t, const ImVec2& size);

// The INTEGER stage scale for a native 320x200 view fit to `avail_w` px
// (1..4): fractional scales make pixel columns uneven even under nearest.
float stage_scale(float avail_w);

// ------------------------------------------------------------ texture cache
// Static images: created + filled once per key. Live views should own their
// texture and update it each frame instead.
Texture* static_texture(Driver& drv, const std::string& key,
                        const std::function<bool(vc::Image&)>& make);
void invalidate_texture(const std::string& key);

// Advisor reports live in the shared layer (forge/game_reports.cpp).
using forge::compose_report;

// ---------------------------------------------------------------- panels
void sprites_panel(Driver& drv);
void popups_panel(Driver& drv);
void screens_panel(Driver& drv);
void tables_panel(Driver& drv);
void rules_panel(Driver& drv);
void events_panel(Driver& drv);
void map_panel(Driver& drv);

} // namespace studio
