// studio_main.cpp -- Forge: the native desktop game-development engine.
//
// Fully native UI (Dear ImGui over a platform driver -- no web technology).
// Forge opens a PROJECT (a folder of game data; the Colonization content is
// the first project) and presents the editor: today the record database
// (browse + edit + save through the store chokepoint) and the live game
// view over the byte-faithful session; the remaining panels (rules curves,
// tables, map, screens, events) port over surface by surface.
#include "studio.hpp"
#include "studio_shared.hpp"  // AppState + shared assets + the editor panels
#include "imgui.h"
#include "imgui_internal.h"   // DockBuilder (first-run layout)

#include "drydock_api.hpp"        // drydock_store / drydock_store_init / save
#include "drydock_bridge.hpp"     // drydock_apply_records (live-rules sync)
#include "savegame.hpp"           // parse_game (File > Load Game)
#include "export_game.hpp"        // Build menu: export the game from data
#include "import_original.hpp"    // File menu: ingest the original game folder
#include <filesystem>
#include "session.hpp"            // the game session (g_game/g_world, game_new/step)
#include "unit.hpp"
#include "unit_turn.hpp"
#include "../drydock/core/store.hpp"

#include <cstdio>
#include <cstring>
#include <string>
#include <sys/stat.h>
#ifdef _WIN32
  #include <windows.h>
  #include <shobjidl.h>
#else
  #include <unistd.h>
#endif

#if FORGE_STUDIO_GAME
#include "native_assets.hpp"
#include "surface.hpp"
#include "mapview.hpp"
#include "colony_screen.hpp"   // the spec colony-screen composer
#include "mp.hpp"
#include "engine.hpp"          // colony_compute_production (worker assignment)
#include "sim/market.hpp"      // market_bid/ask/sell/buy (the Europe screen)
#include "popup_render.hpp"    // nearest_pal_index
#include "game_shell.hpp"      // the ONE engine view (shared with the players)
#endif

using drydock::Record;
using drydock::Store;
using drydock::ValKind;
using drydock::Value;

namespace studio {
namespace {

// ------------------------------------------------------------------ helpers
bool input_text_std(const char* label, std::string& s, ImGuiInputTextFlags flags = 0) {
    char buf[1024];
    std::snprintf(buf, sizeof buf, "%s", s.c_str());
    if (ImGui::InputText(label, buf, sizeof buf, flags)) { s = buf; return true; }
    return false;
}

std::string value_preview(const Value& v) {
    switch (v.kind) {
        case ValKind::Int:   return std::to_string(v.i);
        case ValKind::Float: return std::to_string(v.f);
        case ValKind::Str:   return v.s;
        case ValKind::Token: return v.s;
        case ValKind::List:  return "[" + std::to_string(v.list.size()) + " items]";
        case ValKind::Dict:  return "{" + std::to_string(v.keys.size()) + " keys}";
    }
    return "";
}

}  // namespace

// ------------------------------------------------------------------ app state
// Shared with the panels (studio_shared.hpp): one AppState singleton.
AppState& app() {
    static AppState a;
    return a;
}

void select_record(const std::string& id) {
    Store* st = forge::drydock_store();
    if (!st || !drydock::store_find(*st, id)) return;
    app().sel_id = id;
    auto ti = st->type_index.find(Record{id, {}}.type());
    if (ti != st->type_index.end()) app().sel_type = (int)ti->second;
}

namespace {

AppState& g_app = app();

// ------------------------------------------------------------ records panel
void records_panel() {
    Store* st = forge::drydock_store();
    ImGui::Begin("Records");
    if (!st) {
        ImGui::TextWrapped("Record store not loaded: %s", g_app.status.c_str());
        ImGui::End();
        return;
    }
    ImGui::BeginChild("types", ImVec2(180, 0), ImGuiChildFlags_ResizeX);
    for (int t = 0; t < (int)st->type_codes.size(); ++t) {
        char label[128];
        std::snprintf(label, sizeof label, "%s (%zu)", st->type_codes[t].c_str(),
                      st->records[t].size());
        if (ImGui::Selectable(label, g_app.sel_type == t)) {
            g_app.sel_type = t;
            g_app.sel_id.clear();
        }
    }
    ImGui::EndChild();
    ImGui::SameLine();
    ImGui::BeginChild("ids", ImVec2(0, 0));
    if (g_app.sel_type >= 0 && g_app.sel_type < (int)st->records.size()) {
        for (const Record& r : st->records[g_app.sel_type]) {
            bool dirty = st->dirty.count(r.id) > 0;
            if (dirty) ImGui::PushStyleColor(ImGuiCol_Text, IM_COL32(255, 200, 90, 255));
            if (ImGui::Selectable(r.id.c_str(), g_app.sel_id == r.id))
                g_app.sel_id = r.id;
            if (dirty) ImGui::PopStyleColor();
        }
    } else {
        ImGui::TextDisabled("select a record type");
    }
    ImGui::EndChild();
    ImGui::End();
}

// ---------------------------------------------------------- inspector panel
// Edits go through the store chokepoint (journaled, undoable) and re-apply
// the migrated rule values onto the live game -- same behavior as the web
// /api/dd/set route, minus the web.
void commit_field(const std::string& id, const std::string& field, const Value& v) {
    Store* st = forge::drydock_store();
    std::string err;
    if (!drydock::store_set(*st, id, field, &v, err)) {
        g_app.status = "edit rejected: " + err;
        return;
    }
    const Record* r = drydock::store_find(*st, id);
    if (r) forge::drydock_apply_records(g_active_rules, {*r}, /*include_conf*/false);
    g_app.status = id + "." + field + " set";
}

void inspector_panel() {
    ImGui::Begin("Inspector");
    Store* st = forge::drydock_store();
    if (!st || g_app.sel_id.empty()) {
        ImGui::TextDisabled("select a record");
        ImGui::End();
        return;
    }
    Record* r = drydock::store_find(*st, g_app.sel_id);
    if (!r) {
        ImGui::TextDisabled("record gone");
        ImGui::End();
        return;
    }
    ImGui::Text("%s", r->id.c_str());
    ImGui::Separator();
    if (ImGui::BeginTable("fields", 2,
                          ImGuiTableFlags_RowBg | ImGuiTableFlags_SizingStretchProp)) {
        ImGui::TableSetupColumn("field", ImGuiTableColumnFlags_WidthFixed, 160.0f);
        ImGui::TableSetupColumn("value");
        for (const drydock::RecField& f : r->fields) {
            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            ImGui::TextUnformatted(f.name.c_str());
            ImGui::TableNextColumn();
            ImGui::PushID(f.name.c_str());
            ImGui::SetNextItemWidth(-1);
            switch (f.value.kind) {
                case ValKind::Int: {
                    long long tmp = f.value.i;
                    if (ImGui::InputScalar("##v", ImGuiDataType_S64, &tmp, nullptr,
                                           nullptr, nullptr,
                                           ImGuiInputTextFlags_EnterReturnsTrue))
                        commit_field(r->id, f.name, Value::make_int(tmp));
                    break;
                }
                case ValKind::Float: {
                    double tmp = f.value.f;
                    if (ImGui::InputDouble("##v", &tmp, 0, 0, "%.6g",
                                           ImGuiInputTextFlags_EnterReturnsTrue))
                        commit_field(r->id, f.name, Value::make_float(tmp));
                    break;
                }
                case ValKind::Str: {
                    std::string tmp = f.value.s;
                    if (input_text_std("##v", tmp, ImGuiInputTextFlags_EnterReturnsTrue))
                        commit_field(r->id, f.name, Value::make_str(tmp));
                    break;
                }
                case ValKind::Token: {   // refs/bools: navigate on click (edit later)
                    if (ImGui::Selectable(f.value.s.c_str()) &&
                        drydock::store_find(*st, f.value.s)) {
                        g_app.sel_id = f.value.s;
                        auto ti = st->type_index.find(Record{f.value.s, {}}.type());
                        if (ti != st->type_index.end()) g_app.sel_type = (int)ti->second;
                    }
                    break;
                }
                default:
                    ImGui::TextDisabled("%s", value_preview(f.value).c_str());
            }
            ImGui::PopID();
        }
        ImGui::EndTable();
    }
    ImGui::End();
}

// ---------------------------------------------------------------- game panel
// ---------------------------------------------------------------- game panel
#if FORGE_STUDIO_GAME
// The editor hosts the SAME platform-free GameShell the standalone players
// run -- one engine view, one implementation, so every fidelity fix lands
// once. ImGui here only pumps input into the shell and presents its 320x200
// surface, plus editor conveniences: the asset/boot buttons, the trade-route
// editor window (T) and the notice log.
forge::GameShell g_shell;
struct GameHost {
    bool tex_ok = false;
    Texture tex;
    bool routes_open = false;      // T: the @TRADE editor window
} g_gh;

void game_panel(Driver& drv) {
    ImGui::Begin("Game");
    g_app.game_active = g_game_active;     // the shell owns the session state
    static bool auto_game = std::getenv("FORGE_AUTOGAME") != nullptr;
    if (!g_gh.tex_ok) {
        if (ImGui::Button("Load game assets") || auto_game) {
            if (assets_ensure()) {
                g_gh.tex = drv.create_texture(vc::Surface::W, vc::Surface::H);
                g_gh.tex_ok = true;
            } else {
                g_app.status = assets().err;
            }
        }
        ImGui::SameLine();
        ImGui::TextDisabled("(tileset + backgrounds from the project)");
        ImGui::End();
        return;
    }
    // toolbar: quick actions around the live shell
    bool want_new = ImGui::Button("New Game");
    if (auto_game && !g_app.game_active) { want_new = true; auto_game = false; }
    if (want_new) {
        g_shell.new_game();
        g_app.game_active = true;
    }
    if (g_app.game_active) {
        ImGui::SameLine();
        if (ImGui::Button("End Turn (Enter)")) g_shell.key(forge::GK_ENTER, false);
        ImGui::SameLine();
        ImGui::Text("Turn %ld  Gold %lld", (long)g_game.turn,
                    (long long)g_game.powers[0].gold);
        ImGui::SameLine();
        ImGui::TextDisabled("Esc backs out - F1..F10 reports - T trade routes");
    } else {
        ImGui::SameLine();
        ImGui::TextDisabled("(or play the boot flow on the stage below)");
    }
    // headless/CI hooks: open a subview for screenshots
    static const char* auto_col = std::getenv("FORGE_COLONY");
    if (auto_col && g_app.game_active) {
        g_shell.open_colony(std::atoi(auto_col));
        auto_col = nullptr;
    }
    static const char* auto_eur = std::getenv("FORGE_EUROPE");
    if (auto_eur && g_app.game_active) {
        g_shell.open_europe();
        auto_eur = nullptr;
    }
    static const char* auto_rep = std::getenv("FORGE_REPORT");
    if (auto_rep && g_app.game_active) {
        g_shell.open_report(std::atoi(auto_rep));
        auto_rep = nullptr;
    }

    // compose the shell frame + present at an integer scale, nearest-sampled
    vc::Surface scr;
    bool flash = ((int)(ImGui::GetTime() * 3)) & 1;
    g_shell.compose(scr, flash);
    vc::Image img = scr.to_rgb(1);
    drv.update_texture(g_gh.tex, img.rgb.data());
    float scale = studio::stage_scale(ImGui::GetContentRegionAvail().x);
    ImVec2 origin = ImGui::GetCursorScreenPos();
    studio::pixel_image(g_gh.tex,
                        ImVec2(vc::Surface::W * scale, vc::Surface::H * scale));
    // mouse -> native 320x200 coordinates
    if (ImGui::IsItemHovered() &&
        (ImGui::IsMouseClicked(0) || ImGui::IsMouseClicked(1))) {
        ImVec2 mp = ImGui::GetMousePos();
        g_shell.click((int)((mp.x - origin.x) / scale),
                      (int)((mp.y - origin.y) / scale),
                      ImGui::IsMouseClicked(1) ? 1 : 0);
    }
    // keyboard -> shell keys (Ctrl chords stay with the editor)
    if (ImGui::IsWindowFocused() && !ImGui::GetIO().KeyCtrl) {
        bool shift = ImGui::GetIO().KeyShift;
        auto k = [&](ImGuiKey ik, int gk) {
            if (ImGui::IsKeyPressed(ik)) g_shell.key(gk, shift);
        };
        k(ImGuiKey_UpArrow, forge::GK_UP);
        k(ImGuiKey_DownArrow, forge::GK_DOWN);
        k(ImGuiKey_LeftArrow, forge::GK_LEFT);
        k(ImGuiKey_RightArrow, forge::GK_RIGHT);
        k(ImGuiKey_Enter, forge::GK_ENTER);
        k(ImGuiKey_KeypadEnter, forge::GK_ENTER);
        k(ImGuiKey_Escape, forge::GK_ESC);
        k(ImGuiKey_Tab, forge::GK_TAB);
        k(ImGuiKey_Space, ' ');
        k(ImGuiKey_Minus, '-');
        for (int f = 0; f < 10; ++f)
            k((ImGuiKey)(ImGuiKey_F1 + f), forge::GK_F1 + f);
        for (int d = 0; d < 9; ++d)
            k((ImGuiKey)(ImGuiKey_1 + d), '1' + d);
        for (int c = 0; c < 26; ++c) {
            if ('a' + c == 't') continue;          // T = the routes window
            k((ImGuiKey)(ImGuiKey_A + c), 'a' + c);
        }
        if (ImGui::IsKeyPressed(ImGuiKey_T)) g_gh.routes_open = true;
    }
    g_shell.clear_quit();      // map-Esc quits the player, not the editor
    // selected-unit line + the recent-notice log
    if (g_app.game_active) {
        int sel = g_shell.selected_unit();
        if (sel >= 0 && sel < (int)g_world.units.size() &&
            g_world.units[sel].alive) {
            const vc::sim::Unit& u = g_world.units[sel];
            const char* nm = vc::sim::unit_stats(g_active_rules, u.type).name;
            ImGui::TextDisabled("%s at (%d,%d)  move credits %d  |  F/S/P/R "
                                "orders, B found, G goto, L/U/O cargo, "
                                "Shift-D disband",
                                nm ? nm : "unit", u.x, u.y, u.moves_left);
        }
        for (const std::string& s : g_shell.log())
            ImGui::TextDisabled("%s", s.c_str());
    }
    ImGui::End();
}
#endif  // FORGE_STUDIO_GAME

#if FORGE_STUDIO_GAME
// --------------------------------------------------------- trade routes (T)
// The @TRADE editor, natively: list/assign/delete + create (trade_routes.md:
// 12-route cap, unique names, 4 stops, per-stop load/unload lanes).
std::string good_name(int idx) {
    Store* st = forge::drydock_store();
    if (st) {
        auto gi = st->type_index.find("good");
        if (gi != st->type_index.end())
            for (const Record& r : st->records[gi->second]) {
                const Value* ix = r.find("index");
                const Value* nm = r.find("name");
                if (ix && nm && ix->i == idx) return nm->s;
            }
    }
    return "good " + std::to_string(idx);
}

void routes_window() {
    if (!g_gh.routes_open) return;
    ImGui::SetNextWindowSize(ImVec2(560, 430), ImGuiCond_FirstUseEver);
    if (!ImGui::Begin("Trade Routes", &g_gh.routes_open)) {
        ImGui::End();
        return;
    }
    ImGui::TextDisabled("a route needs a cargo carrier: assign it to the "
                        "selected ship/wagon; stops run on End Turn");
    for (int ri = 0; ri < (int)g_game.routes.size(); ++ri) {
        const vc::sim::TradeRoute& r = g_game.routes[ri];
        ImGui::PushID(ri);
        ImGui::SeparatorText((r.name + (r.type == 0 ? "  (sea)" : "  (land)")).c_str());
        for (const vc::sim::TradeStop& st2 : r.stops) {
            std::string d = st2.dest == vc::sim::ROUTE_DEST_EUROPE ? "Europe"
                            : st2.dest == vc::sim::ROUTE_DEST_NONE ? "(none)"
                            : "colony " + std::to_string(st2.dest);
            std::string lanes;
            for (int gg : st2.load) lanes += " +" + good_name(gg);
            for (int gg : st2.unload) lanes += " -" + good_name(gg);
            ImGui::BulletText("%s%s", d.c_str(), lanes.c_str());
        }
        ImGui::BeginDisabled(g_shell.selected_unit() < 0);
        if (ImGui::SmallButton("assign to selected unit")) {
            OrderResult res = unit_order(g_shell.selected_unit(), "T", -1, -1, ri);
            g_shell.note(res.ok ? "unit follows " + r.name : res.err);
        }
        ImGui::EndDisabled();
        ImGui::SameLine();
        if (ImGui::SmallButton("delete")) {
            std::string e = route_delete(ri);
            g_shell.note(e.empty() ? "route deleted" : e);
            ImGui::PopID();
            break;                      // indices shifted; redraw next frame
        }
        ImGui::PopID();
    }
    if (g_game.routes.empty()) ImGui::TextDisabled("no trade routes yet");

    ImGui::SeparatorText("New route");
    static char name[32] = {0};
    static int type = 0;
    static std::vector<vc::sim::TradeStop> stops;
    ImGui::SetNextItemWidth(180);
    ImGui::InputText("name", name, sizeof name);
    ImGui::SameLine();
    ImGui::SetNextItemWidth(90);
    ImGui::Combo("type", &type, "sea\0land\0");
    auto lane_combo = [&](const char* label, std::vector<int>& lane) {
        std::string preview;
        for (int gg : lane) preview += (preview.empty() ? "" : ", ") + good_name(gg);
        if (preview.empty()) preview = "(none)";
        ImGui::SetNextItemWidth(170);
        if (ImGui::BeginCombo(label, preview.c_str())) {
            for (int gg = 0; gg < vc::sim::NGOODS; ++gg) {
                bool on = std::find(lane.begin(), lane.end(), gg) != lane.end();
                if (ImGui::Checkbox(good_name(gg).c_str(), &on)) {
                    if (on) {
                        if ((int)lane.size() < vc::sim::MAX_LANE_GOODS)
                            lane.push_back(gg);
                    } else {
                        lane.erase(std::find(lane.begin(), lane.end(), gg));
                    }
                }
            }
            ImGui::EndCombo();
        }
    };
    for (int si = 0; si < (int)stops.size(); ++si) {
        ImGui::PushID(si);
        vc::sim::TradeStop& st2 = stops[si];
        std::string dprev = st2.dest == vc::sim::ROUTE_DEST_EUROPE ? "Europe"
                            : st2.dest == vc::sim::ROUTE_DEST_NONE ? "(pick)"
                            : "colony " + std::to_string(st2.dest);
        ImGui::SetNextItemWidth(140);
        if (ImGui::BeginCombo("stop", dprev.c_str())) {
            if (ImGui::Selectable("Europe", st2.dest == vc::sim::ROUTE_DEST_EUROPE))
                st2.dest = vc::sim::ROUTE_DEST_EUROPE;
            for (int ci = 0; ci < (int)g_world.colonies.size(); ++ci) {
                if (g_world.colonies[ci].owner_power != 0) continue;
                char lbl[48];
                std::snprintf(lbl, sizeof lbl, "colony %d (%d,%d)", ci,
                              g_world.colonies[ci].x, g_world.colonies[ci].y);
                if (ImGui::Selectable(lbl, st2.dest == ci)) st2.dest = ci;
            }
            ImGui::EndCombo();
        }
        ImGui::SameLine();
        lane_combo("load", st2.load);
        ImGui::SameLine();
        lane_combo("unload", st2.unload);
        ImGui::SameLine();
        if (ImGui::SmallButton("x")) {
            stops.erase(stops.begin() + si);
            ImGui::PopID();
            break;
        }
        ImGui::PopID();
    }
    if ((int)stops.size() < vc::sim::MAX_ROUTE_STOPS && ImGui::Button("+ stop"))
        stops.push_back({});
    ImGui::SameLine();
    if (ImGui::Button("Create route")) {
        std::string e = route_create(name, type, stops);
        if (e.empty()) {
            g_shell.note(std::string("route created: ") + name);
            name[0] = 0;
            stops.clear();
        } else {
            g_shell.note(e);
        }
    }
    ImGui::End();
}
#endif  // FORGE_STUDIO_GAME

// -------------------------------------------------------------------- shell
bool g_reset_layout = false;   // View > Reset window layout
bool g_show_help = false;      // Help > Keyboard commands
bool g_show_build = false;     // Build > Build game...
bool g_build_teensy = false;   // which target the Build dialog exports
bool g_show_import = false;    // File > Import original game files...
std::string g_exe_dir;         // where Forge itself runs from (template lookup)
#ifdef _WIN32
std::string pick_project_folder();   // defined below (COM folder picker)
#endif

// Import dialog: ingest the user's original game folder (VICEROY.EXE + its
// data files). The assets are copied into raw/COLONIZE, decode-verified with
// the native codecs, and the asset cache reloads so the REAL art (fonts,
// sheets, backgrounds, palette) takes over everywhere immediately.
void import_window() {
    if (!g_show_import) return;
    ImGui::SetNextWindowSize(ImVec2(560, 340), ImGuiCond_FirstUseEver);
    if (!ImGui::Begin("Import original game files", &g_show_import)) {
        ImGui::End();
        return;
    }
    ImGui::TextWrapped(
        "Point this at your original game folder -- the one containing "
        "VICEROY.EXE and its .SS / .PIK / .FF / .PAL / .TXT / .MP files. "
        "Everything is copied into raw/COLONIZE and decoded with the native "
        "codecs; the loaders prefer these originals over the converted "
        "stand-ins, so the real art takes over at once (VICEROY.EXE itself "
        "holds the code this engine reimplements -- it is kept for "
        "reference, nothing is extracted from the binary).");
    ImGui::Spacing();
    static char src[256] = {0};
    ImGui::SetNextItemWidth(400);
    ImGui::InputText("game folder", src, sizeof src);
#ifdef _WIN32
    ImGui::SameLine();
    if (ImGui::Button("Browse...")) {
        std::string p = pick_project_folder();
        if (!p.empty()) std::snprintf(src, sizeof src, "%s", p.c_str());
    }
#endif
    static forge::ImportReport rep;
    if (ImGui::Button("Import") && src[0]) {
        rep = forge::import_original_game(src, ".");
        g_app.status = rep.message;
    }
    ImGui::SameLine();
    ImGui::TextUnformatted(rep.message.c_str());
    for (const std::string& n : rep.notes) ImGui::BulletText("%s", n.c_str());
    if (rep.ok)
        ImGui::TextDisabled("(cached sprite previews refresh on restart; the "
                            "game view is live already)");
    ImGui::End();
}

// Build dialog: export the game FROM THE PROJECT DATA, engine-style. The
// player executable is a prebuilt export template (shipped next to Forge /
// found in the build trees); the game is the data being edited here.
void build_window() {
    if (!g_show_build) return;
    ImGui::SetNextWindowSize(ImVec2(560, 360), ImGuiCond_FirstUseEver);
    if (!ImGui::Begin(g_build_teensy ? "Build for Teensy 4.1" : "Build for Windows",
                      &g_show_build)) {
        ImGui::End();
        return;
    }
    // the disassembly status: what this project carries, record for record
    if (Store* st = forge::drydock_store()) {
        size_t recs = 0;
        for (const auto& v : st->records) recs += v.size();
        ImGui::TextDisabled("project: %zu records across %zu types | assets %s",
                            recs, st->type_index.size(),
                            studio::assets_ensure() ? "loaded" : "NOT loaded");
    }
    ImGui::TextWrapped("%s",
        g_build_teensy
            ? "Exports the microSD card image: copy the output folder's "
              "contents to the card root. The firmware (teensy/, flashed once "
              "with PlatformIO) reads the card -- rebuilding your game is "
              "just re-exporting it."
            : "Exports a standalone game folder: the project data plus the "
              "Viceroy player. Unsaved record edits are saved first, so the "
              "build is exactly what you see in the editor.");
    ImGui::Spacing();
    static char out[256] = {0};
    if (!out[0])
        std::snprintf(out, sizeof out, "%s",
                      g_build_teensy ? "export/Viceroy-teensy-sd"
                                     : "export/Viceroy-win64");
    ImGui::SetNextItemWidth(420);
    ImGui::InputText("output folder", out, sizeof out);
    static std::string result, detail;
    if (ImGui::Button("Build")) {
        std::string summary;
        forge::drydock_save_dirty(summary);          // build = what you edited
        forge::ExportReport r = forge::export_game_data(".", out, g_build_teensy);
        result = r.message;
        detail.clear();
        if (r.ok && !g_build_teensy) {
            std::string tpl = forge::find_player_template(g_exe_dir, ".");
            if (!tpl.empty()) {
                try {
                    std::filesystem::path dst =
                        std::filesystem::path(out) /
                        std::filesystem::path(tpl).filename();
                    std::filesystem::copy_file(
                        tpl, dst, std::filesystem::copy_options::overwrite_existing);
                    detail = "player template: " + tpl;
                } catch (const std::exception& e) {
                    detail = std::string("player copy failed: ") + e.what();
                }
            } else {
                detail = "player template not found -- put Viceroy.exe next to "
                         "Forge (it ships in the Forge zip) and rebuild, or "
                         "copy it into the output folder by hand.";
            }
        }
        if (r.ok && g_build_teensy)
            detail = "firmware: flash teensy/ once with `pio run -t upload` "
                     "(see teensy/README.md), then copy this folder to the SD "
                     "card root.";
        g_app.status = result;
    }
    ImGui::SameLine();
    ImGui::TextUnformatted(result.c_str());
    if (!detail.empty()) ImGui::TextWrapped("%s", detail.c_str());
    ImGui::End();
}

void help_window() {
    if (!g_show_help) return;
    ImGui::SetNextWindowSize(ImVec2(560, 520), ImGuiCond_FirstUseEver);
    if (!ImGui::Begin("Keyboard commands", &g_show_help)) {
        ImGui::End();
        return;
    }
    auto row = [](const char* k, const char* what) {
        ImGui::TableNextRow();
        ImGui::TableNextColumn();
        ImGui::TextUnformatted(k);
        ImGui::TableNextColumn();
        ImGui::TextWrapped("%s", what);
    };
    auto section = [&](const char* title) {
        ImGui::SeparatorText(title);
        ImGui::BeginTable(title, 2, ImGuiTableFlags_SizingStretchProp);
        ImGui::TableSetupColumn("key", ImGuiTableColumnFlags_WidthFixed, 120.0f);
        ImGui::TableSetupColumn("action");
    };
    section("Everywhere");
    row("Ctrl+S", "save the project (edited records -> data/ as text)");
    row("Ctrl+Z / Ctrl+Y", "undo / redo record edits");
    ImGui::EndTable();
    section("Game view (map)");
    row("arrows", "move the selected unit");
    row("Tab / W / Space", "next unit with moves");
    row("Enter", "end the turn");
    row("click", "select a unit / open your colony");
    row("B", "found a colony / join the colony you stand on");
    row("G", "go-to: click the target tile");
    row("F / S", "fortify / sentry");
    row("P / R", "clear-plow / build road (runs over turns)");
    row("A or -", "activate (clear orders)");
    row("L / U / O", "load / unload most valuable cargo / dump overboard");
    row("T", "trade routes (assign / create / delete)");
    row("Shift+D", "disband the unit");
    row("E", "Europe: the market + recruit dock");
    row("F1..F10", "advisor reports");
    row("Z / X / C", "zoom in / out / center on the unit");
    row("Esc", "back to the map");
    ImGui::EndTable();
    section("Colony screen");
    row("click ring tile", "assign a farmer there / take the colonist off");
    row("right-click ring", "pick the profession (all 28 jobs)");
    row("Esc", "back to the map");
    ImGui::EndTable();
    section("Europe");
    row("click a good", "sell 1 at the bid");
    row("right-click good", "buy 1 at the ask");
    row("click dock row", "recruit the waiting immigrant");
    ImGui::EndTable();
    section("Screens designer");
    row("drag widget", "move it (commits on release)");
    row("arrows / Shift", "nudge 1px / 8px");
    row("drag empty stage", "move the background PIK");
    row("Play toggle", "buttons fire their events for real");
    ImGui::EndTable();
    section("Map editor");
    row("left-drag", "paint with the selected brush");
    row("right-click", "eyedrop the terrain under the cursor");
    ImGui::EndTable();
    ImGui::End();
}

void main_menu() {
    if (ImGui::BeginMainMenuBar()) {
        if (ImGui::BeginMenu("File")) {
            if (ImGui::MenuItem("Save Project", "Ctrl+S")) {
                std::string summary;
                forge::drydock_save_dirty(summary);
                g_app.status = "saved: " + summary;
            }
            if (ImGui::MenuItem("Import original game files..."))
                g_show_import = true;
            ImGui::Separator();
            if (ImGui::MenuItem("Save Game", nullptr, false, g_app.game_active)) {
                g_app.status = save_game_to("data_extracted/engine/savegame.json")
                                   ? "game saved"
                                   : "game save FAILED";
            }
            if (ImGui::MenuItem("Load Game")) {
                try {   // the /api/game/load path, natively
                    forge::JsonValue root =
                        forge::json_parse_file("data_extracted/engine/savegame.json");
                    forge::LoadedGame lg = forge::parse_game(forge::json_dump(root));
                    g_game = lg.g;
                    g_world = lg.w;
                    g_colony_xy.clear();
                    if (const forge::JsonValue* cxy = root.find("colony_xy"))
                        for (const auto& e : cxy->arr)
                            if (e.arr.size() >= 2)
                                g_colony_xy.push_back(
                                    {(int)e.arr[0].num, (int)e.arr[1].num});
                    g_engine_extra = forge::EngineExtra{};
                    read_extra(root.find("engine_extra"), g_engine_extra);
                    g_game_active = true;
                    g_app.game_active = true;
                    g_shell.resync();
                    g_app.status = "game loaded";
                } catch (const std::exception& e) {
                    g_app.status = std::string("load failed: ") + e.what();
                }
            }
            ImGui::Separator();
            if (ImGui::MenuItem("Exit")) {
                // handled by the driver's window close; simplest portable quit:
                std::exit(0);
            }
            ImGui::EndMenu();
        }
        if (ImGui::BeginMenu("Edit")) {
            Store* st = forge::drydock_store();
            bool can = st && st->journal_pos > 0;
            if (ImGui::MenuItem("Undo", "Ctrl+Z", false, can)) {
                std::string id;
                drydock::store_undo(*st, id);
                g_app.status = "undo " + id;
            }
            bool canr = st && st->journal_pos < st->journal.size();
            if (ImGui::MenuItem("Redo", "Ctrl+Y", false, canr)) {
                std::string id;
                drydock::store_redo(*st, id);
                g_app.status = "redo " + id;
            }
            ImGui::EndMenu();
        }
        if (ImGui::BeginMenu("View")) {
            if (ImGui::MenuItem("Reset window layout"))
                g_reset_layout = true;
            ImGui::EndMenu();
        }
        if (ImGui::BeginMenu("Build")) {
            if (ImGui::MenuItem("Build game for Windows...")) {
                g_build_teensy = false;
                g_show_build = true;
            }
            if (ImGui::MenuItem("Build game for Teensy 4.1 (SD card)...")) {
                g_build_teensy = true;
                g_show_build = true;
            }
            ImGui::EndMenu();
        }
        if (ImGui::BeginMenu("Help")) {
            if (ImGui::MenuItem("Keyboard commands")) g_show_help = true;
            ImGui::EndMenu();
        }
        ImGui::Separator();
        ImGui::TextDisabled("project: %s", g_app.project.c_str());
        if (!g_app.status.empty()) {
            ImGui::Separator();
            ImGui::TextUnformatted(g_app.status.c_str());
        }
        ImGui::EndMainMenuBar();
    }
    // shortcuts
    ImGuiIO& io = ImGui::GetIO();
    if (io.KeyCtrl && ImGui::IsKeyPressed(ImGuiKey_S)) {
        std::string summary;
        forge::drydock_save_dirty(summary);
        g_app.status = "saved: " + summary;
    }
}

}  // namespace

int studio_run(Driver& drv, const std::string& project_dir) {
    g_app.project = project_dir;
    // headless/CI hook: FORGE_BUILD=<dir> runs the Build > Windows export
    // exactly as the dialog would (FORGE_BUILD_TEENSY=1 for the SD layout).
    if (const char* im = std::getenv("FORGE_IMPORT")) {
        forge::ImportReport ir = forge::import_original_game(im, ".");
        std::printf("FORGE_IMPORT: %s\n", ir.message.c_str());
        for (const std::string& n : ir.notes)
            std::printf("  - %s\n", n.c_str());
    }
    if (const char* bo = std::getenv("FORGE_BUILD")) {
        bool teensy = std::getenv("FORGE_BUILD_TEENSY") != nullptr;
        std::string summary;
        forge::drydock_save_dirty(summary);
        forge::ExportReport r = forge::export_game_data(".", bo, teensy);
        std::string tpl =
            !teensy && r.ok ? forge::find_player_template(g_exe_dir, ".") : "";
        if (!tpl.empty()) {
            try {
                std::filesystem::copy_file(
                    tpl,
                    std::filesystem::path(bo) /
                        std::filesystem::path(tpl).filename(),
                    std::filesystem::copy_options::overwrite_existing);
            } catch (const std::exception&) {}
        }
        std::printf("FORGE_BUILD: %s%s%s\n", r.message.c_str(),
                    tpl.empty() ? "" : " + player ", tpl.c_str());
    }
    std::string msg;
    g_app.store_ok = forge::drydock_store_init("data", msg);
    g_app.status = g_app.store_ok ? msg : ("store: " + msg);

    struct stat ini{};
    const bool fresh = stat("imgui.ini", &ini) != 0;   // first run in this project
    bool layout_done = !fresh;
    while (drv.frame_begin()) {
        main_menu();
        ImGuiID dsid = ImGui::DockSpaceOverViewport(0, ImGui::GetMainViewport());
        if (!layout_done || g_reset_layout) {           // default dock layout
            layout_done = true;
            g_reset_layout = false;
            ImGui::DockBuilderRemoveNode(dsid);
            ImGui::DockBuilderAddNode(dsid, ImGuiDockNodeFlags_DockSpace);
            ImGui::DockBuilderSetNodeSize(dsid, ImGui::GetMainViewport()->WorkSize);
            ImGuiID left, rest, right, center;
            ImGui::DockBuilderSplitNode(dsid, ImGuiDir_Left, 0.24f, &left, &rest);
            ImGui::DockBuilderSplitNode(rest, ImGuiDir_Right, 0.30f, &right, &center);
            ImGui::DockBuilderDockWindow("Records", left);
            ImGui::DockBuilderDockWindow("Inspector", right);
            ImGui::DockBuilderDockWindow("Game", center);       // center tabs:
            ImGui::DockBuilderDockWindow("Map", center);        // every editing
            ImGui::DockBuilderDockWindow("Events", center);     // surface lives
            ImGui::DockBuilderDockWindow("Rules", center);      // with the game
            ImGui::DockBuilderDockWindow("Tables", center);
            ImGui::DockBuilderDockWindow("Screens", center);
            ImGui::DockBuilderDockWindow("Popups", center);
            ImGui::DockBuilderDockWindow("Sprites", center);
            ImGui::DockBuilderFinish(dsid);
        }
        records_panel();
        inspector_panel();
        sprites_panel(drv);
        popups_panel(drv);
        screens_panel(drv);
        tables_panel(drv);
        rules_panel(drv);
        events_panel(drv);
        map_panel(drv);
#if FORGE_STUDIO_GAME
        game_panel(drv);
        routes_window();
        build_window();
        import_window();
#endif
        help_window();
        // headless/CI hook: FORGE_FOCUS=<window> raises a panel (screenshots)
        static const char* focus = std::getenv("FORGE_FOCUS");
        if (focus) { ImGui::SetWindowFocus(focus); focus = nullptr; }
        drv.frame_end();
    }
    return 0;
}

}  // namespace studio

// ---------------------------------------------------------------- entrypoint
namespace {

bool is_project_dir(const std::string& dir) {
    struct stat st{};
    return stat((dir + "/data_extracted/engine").c_str(), &st) == 0;
}

std::string exe_dir(const char* argv0) {
#ifdef _WIN32
    (void)argv0;
    char buf[MAX_PATH] = {0};
    GetModuleFileNameA(nullptr, buf, MAX_PATH);
    std::string p = buf;
    size_t k = p.find_last_of("\\/");
    return k == std::string::npos ? "." : p.substr(0, k);
#else
    std::string p = argv0 ? argv0 : "";
    size_t k = p.find_last_of('/');
    return k == std::string::npos ? "." : p.substr(0, k);
#endif
}

#ifdef _WIN32
std::string pick_project_folder() {
    std::string out;
    if (FAILED(CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED))) return out;
    IFileOpenDialog* dlg = nullptr;
    if (SUCCEEDED(CoCreateInstance(CLSID_FileOpenDialog, nullptr, CLSCTX_ALL,
                                   IID_IFileOpenDialog, (void**)&dlg))) {
        DWORD opts = 0;
        dlg->GetOptions(&opts);
        dlg->SetOptions(opts | FOS_PICKFOLDERS | FOS_PATHMUSTEXIST);
        dlg->SetTitle(L"Open a Forge project (the folder containing data_extracted)");
        if (SUCCEEDED(dlg->Show(nullptr))) {
            IShellItem* item = nullptr;
            if (SUCCEEDED(dlg->GetResult(&item))) {
                PWSTR w = nullptr;
                if (SUCCEEDED(item->GetDisplayName(SIGDN_FILESYSPATH, &w))) {
                    int len = WideCharToMultiByte(CP_UTF8, 0, w, -1, nullptr, 0,
                                                  nullptr, nullptr);
                    std::string s(len > 0 ? len - 1 : 0, '\0');
                    WideCharToMultiByte(CP_UTF8, 0, w, -1, s.data(), len, nullptr,
                                        nullptr);
                    out = s;
                    CoTaskMemFree(w);
                }
                item->Release();
            }
        }
        dlg->Release();
    }
    CoUninitialize();
    return out;
}
#endif

}  // namespace

int main(int argc, char** argv) {
    std::string proj;
    if (argc >= 2 && argv[1][0] != '-') proj = argv[1];
    if (proj.empty() && is_project_dir(".")) proj = ".";
    if (proj.empty() && is_project_dir(exe_dir(argv[0]))) proj = exe_dir(argv[0]);
#ifdef _WIN32
    if (proj.empty() || !is_project_dir(proj)) {
        proj = pick_project_folder();
        if (proj.empty() || !is_project_dir(proj)) {
            MessageBoxA(nullptr,
                        "Pick the project folder that contains data_extracted\\engine\n"
                        "(for Colonization: the repository checkout).",
                        "Forge - no project selected", MB_ICONINFORMATION);
            return 1;
        }
    }
    SetCurrentDirectoryA(proj.c_str());
#else
    if (proj.empty() || !is_project_dir(proj)) {
        std::fprintf(stderr, "Forge: no project found. Run from a project folder "
                             "or: forge-studio /path/to/project\n");
        return 1;
    }
    if (chdir(proj.c_str()) != 0) {
        std::fprintf(stderr, "Forge: cannot enter %s\n", proj.c_str());
        return 1;
    }
#endif
    studio::g_exe_dir = exe_dir(argv[0]);
    studio::Driver* drv = studio::create_driver("Forge", 1440, 900);
    if (!drv) return 1;
    int rc = studio::studio_run(*drv, proj);
    studio::destroy_driver(drv);
    return rc;
}
