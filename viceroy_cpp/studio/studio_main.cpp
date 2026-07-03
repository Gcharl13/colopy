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
#include "mp.hpp"
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
#if FORGE_STUDIO_GAME
struct GameView {
    bool tex_ok = false;
    Texture tex;
    int ox = 0, oy = 0, sel = -1;
    std::string notice;
};
GameView g_gv;

vc::Map session_map() {
    vc::Map m;
    m.w = g_world.map_w;
    m.h = g_world.map_h;
    m.tiles = g_world.terrain;
    return m;
}
int next_own_unit(int from) {
    int n = (int)g_world.units.size();
    for (int k = 1; k <= n; ++k) {
        int i = (from + k) % n;
        if (g_world.units[i].alive && g_world.units[i].owner == 0) return i;
    }
    return -1;
}
void clamp_view() {
    if (g_gv.ox < 0) g_gv.ox = 0;
    if (g_gv.oy < 0) g_gv.oy = 0;
    if (g_gv.ox > g_world.map_w - 15) g_gv.ox = g_world.map_w - 15;
    if (g_gv.oy > g_world.map_h - 12) g_gv.oy = g_world.map_h - 12;
}
void center_on(int x, int y) { g_gv.ox = x - 7; g_gv.oy = y - 6; clamp_view(); }

bool try_step(int ui, int dx, int dy) {   // the sim's thirds move-credit rules
    if (ui < 0 || ui >= (int)g_world.units.size()) return false;
    vc::sim::Unit& u = g_world.units[ui];
    if (!u.alive || u.moves_left <= 0) return false;
    int nx = u.x + dx, ny = u.y + dy;
    if (nx < 0 || ny < 0 || nx >= g_world.map_w || ny >= g_world.map_h) return false;
    int id = g_world.terrain_id(nx, ny);
    bool water = (id == 25 || id == 26);
    bool naval = vc::sim::unit_stats(g_active_rules, u.type).move_class == 99;
    if (water != naval) return false;
    if (vc::sim::unit_at(g_world, nx, ny, ui) >= 0) return false;
    int base = id >= 0 && id < vc::sim::NTERRAIN
                   ? g_active_rules.terrain_move[id % vc::sim::NTERRAIN] : 1;
    u.x = nx; u.y = ny;
    u.moves_left -= naval ? 3 : base * 3;
    if (u.moves_left < 0) u.moves_left = 0;
    return true;
}

void game_end_turn() {
    game_step();
    vc::sim::refresh_moves(g_world, g_active_rules);
    g_gv.notice = g_turn_notices.empty() ? "" : g_turn_notices.back();
    g_turn_notices.clear();
    g_gv.sel = next_own_unit(g_gv.sel);
    if (g_gv.sel >= 0) center_on(g_world.units[g_gv.sel].x, g_world.units[g_gv.sel].y);
}

void game_panel(Driver& drv) {
    ImGui::Begin("Game");
    static bool auto_game = std::getenv("FORGE_AUTOGAME") != nullptr;
    if (!g_gv.tex_ok) {
        if (ImGui::Button("Load game assets") || auto_game) {
            if (assets_ensure()) {
                g_gv.tex = drv.create_texture(vc::Surface::W, vc::Surface::H);
                g_gv.tex_ok = true;
            } else {
                g_app.status = assets().err;
            }
        }
        ImGui::SameLine();
        ImGui::TextDisabled("(tileset + backgrounds from the project)");
        ImGui::End();
        return;
    }
    vc::NativeAssets& A = assets().nat;
    bool want_new = ImGui::Button(g_app.game_active ? "New Game" : "New Game##start");
    if (auto_game && !g_app.game_active) { want_new = true; auto_game = false; }
    if (want_new) {
        game_new(0, 1);
        vc::sim::refresh_moves(g_world, g_active_rules);
        g_app.game_active = true;
        g_gv.sel = next_own_unit(-1);
        if (g_gv.sel >= 0)
            center_on(g_world.units[g_gv.sel].x, g_world.units[g_gv.sel].y);
    }
    if (g_app.game_active) {
        ImGui::SameLine();
        if (ImGui::Button("End Turn (Enter)")) game_end_turn();
        ImGui::SameLine();
        ImGui::Text("Turn %ld  Gold %lld", (long)g_game.turn,
                    (long long)g_game.powers[0].gold);

        // compose the frame from the live session
        vc::Surface scr;
        scr.set_palette(A.pal);
        vc::Map m = session_map();
        render_mapview(scr, m, A.terrain, A.phys,
                       A.woodtile, A.font, g_game, g_world,
                       g_gv.ox, g_gv.oy);
        auto on_screen = [&](int x, int y, int& px, int& py) {
            int vx = x - g_gv.ox, vy = y - g_gv.oy;
            if (vx < 0 || vy < 0 || vx >= 15 || vy >= 12) return false;
            px = vx * 16; py = 8 + vy * 16;
            return true;
        };
        for (const vc::sim::Colony& c : g_world.colonies) {
            int px, py;
            if (c.x < 0 || !on_screen(c.x, c.y, px, py)) continue;
            scr.fill_rect(px + 2, py + 2, 12, 12, 6);
            scr.rect_outline(px + 2, py + 2, 12, 12, 15);
            scr.draw_text(A.font, px + 5, py + 5,
                          std::to_string(c.population), 15);
        }
        bool flash = ((int)(ImGui::GetTime() * 3)) & 1;
        for (int i = 0; i < (int)g_world.units.size(); ++i) {
            const vc::sim::Unit& u = g_world.units[i];
            int px, py;
            if (!u.alive || !on_screen(u.x, u.y, px, py)) continue;
            if (u.type >= 0 && u.type < A.units.nframes)
                scr.blit_frame(A.units.frames[u.type], px, py);
            if (i == g_gv.sel && flash) scr.rect_outline(px, py, 16, 16, 15);
        }
        if (!g_gv.notice.empty())
            scr.draw_text(A.font, 2, 193, g_gv.notice.substr(0, 52), 15);

        vc::Image img = scr.to_rgb(1);
        drv.update_texture(g_gv.tex, img.rgb.data());
        // fit: scale to the available width, integer-ish
        float availw = ImGui::GetContentRegionAvail().x;
        float scale = availw / vc::Surface::W;
        if (scale > 3.0f) scale = 3.0f;
        if (scale < 1.0f) scale = 1.0f;
        ImVec2 sz(vc::Surface::W * scale, vc::Surface::H * scale);
        ImVec2 origin = ImGui::GetCursorScreenPos();
        ImGui::Image((ImTextureID)(intptr_t)g_gv.tex.id, sz);
        // input: click to select; arrows step; Tab next; Enter end turn
        if (ImGui::IsItemHovered() && ImGui::IsMouseClicked(0)) {
            ImVec2 mp = ImGui::GetMousePos();
            int mx = (int)((mp.x - origin.x) / scale), my = (int)((mp.y - origin.y) / scale);
            if (mx < 240 && my >= 8) {
                int tx = g_gv.ox + mx / 16, ty = g_gv.oy + (my - 8) / 16;
                int ui = vc::sim::unit_at(g_world, tx, ty);
                if (ui >= 0 && g_world.units[ui].owner == 0) g_gv.sel = ui;
            }
        }
        if (ImGui::IsWindowFocused()) {
            int dx = 0, dy = 0;
            if (ImGui::IsKeyPressed(ImGuiKey_UpArrow))    dy = -1;
            if (ImGui::IsKeyPressed(ImGuiKey_DownArrow))  dy = 1;
            if (ImGui::IsKeyPressed(ImGuiKey_LeftArrow))  dx = -1;
            if (ImGui::IsKeyPressed(ImGuiKey_RightArrow)) dx = 1;
            if ((dx || dy) && g_gv.sel >= 0) {
                try_step(g_gv.sel, dx, dy);
                const vc::sim::Unit& u = g_world.units[g_gv.sel];
                if (u.x < g_gv.ox + 1 || u.x > g_gv.ox + 13 ||
                    u.y < g_gv.oy + 1 || u.y > g_gv.oy + 10)
                    center_on(u.x, u.y);
            }
            if (ImGui::IsKeyPressed(ImGuiKey_Tab)) {
                g_gv.sel = next_own_unit(g_gv.sel);
                if (g_gv.sel >= 0)
                    center_on(g_world.units[g_gv.sel].x, g_world.units[g_gv.sel].y);
            }
            if (ImGui::IsKeyPressed(ImGuiKey_Enter)) game_end_turn();
        }
    }
    ImGui::End();
}
#endif  // FORGE_STUDIO_GAME

// -------------------------------------------------------------------- shell
bool g_reset_layout = false;   // View > Reset window layout

void main_menu() {
    if (ImGui::BeginMainMenuBar()) {
        if (ImGui::BeginMenu("File")) {
            if (ImGui::MenuItem("Save Project", "Ctrl+S")) {
                std::string summary;
                forge::drydock_save_dirty(summary);
                g_app.status = "saved: " + summary;
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
            ImGui::DockBuilderDockWindow("Screens", center);    // the editing
            ImGui::DockBuilderDockWindow("Popups", center);     // surfaces live
            ImGui::DockBuilderDockWindow("Sprites", center);    // with the game
            ImGui::DockBuilderFinish(dsid);
        }
        records_panel();
        inspector_panel();
        sprites_panel(drv);
        popups_panel(drv);
        screens_panel(drv);
#if FORGE_STUDIO_GAME
        game_panel(drv);
#endif
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
    studio::Driver* drv = studio::create_driver("Forge", 1440, 900);
    if (!drv) return 1;
    int rc = studio::studio_run(*drv, proj);
    studio::destroy_driver(drv);
    return rc;
}
