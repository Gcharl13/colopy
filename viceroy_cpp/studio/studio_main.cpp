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
    int colony_view = -1;        // >= 0: the colony screen is open
    bool europe_view = false;    // the Europe harbor/market screen
    int report_view = 0;         // 1..10: an advisor report (F1..F10) is open
    int prof_pick_tile = -1;     // colony ring tile awaiting a profession pick
    bool goto_mode = false;      // G: the next map click is a GOTO target
    std::string notice;
    std::vector<std::string> log;   // recent turn notices / command feedback
    // found-colony confirmation (the @TUTNO*/@INDIANLAND flow)
    bool confirm_open = false;
    std::string confirm_key;
    std::vector<std::string> confirm_lines, confirm_choices;
    std::vector<std::string> found_acks;
    int confirm_hover = -1;
};
GameView g_gv;

int next_own_unit(int from);   // defined below with the view helpers

void game_log(const std::string& s) {
    g_gv.log.push_back(s);
    if (g_gv.log.size() > 8) g_gv.log.erase(g_gv.log.begin());
    g_app.status = s;
}

// run the found/join command and route the outcome (ok / error / confirm popup)
void found_attempt(const std::string& land_choice) {
    FoundResult fr = found_colony(g_gv.sel, g_gv.found_acks, land_choice);
    if (!fr.confirm.empty()) {
        g_gv.confirm_key = fr.confirm;
        g_gv.confirm_lines.clear();
        g_gv.confirm_choices.clear();
        std::vector<std::string> lines;
        std::string cur;
        for (char c : fr.text) {
            if (c == '\r') continue;
            if (c == '\n') { lines.push_back(cur); cur.clear(); }
            else cur += c;
        }
        lines.push_back(cur);
        while (!lines.empty() && lines.back().empty()) lines.pop_back();
        int nch = fr.choices > 0 ? fr.choices : 2;      // web default
        for (size_t i = 0; i < lines.size(); ++i) {
            if ((int)(lines.size() - i) <= nch) g_gv.confirm_choices.push_back(lines[i]);
            else g_gv.confirm_lines.push_back(lines[i]);
        }
        while (!g_gv.confirm_lines.empty() && g_gv.confirm_lines.back().empty())
            g_gv.confirm_lines.pop_back();
        g_gv.confirm_open = true;
        g_gv.confirm_hover = -1;
        return;
    }
    if (fr.ok) {
        g_gv.found_acks.clear();
        game_log("colony founded");
        g_gv.sel = next_own_unit(g_gv.sel);
    } else {
        g_gv.found_acks.clear();
        game_log(fr.err);
    }
}

// a confirm choice was clicked: the web's routing (nvBuild), natively
void found_choice(const std::string& c) {
    g_gv.confirm_open = false;
    auto has = [&](const char* w) {
        std::string lc = c;
        for (auto& ch : lc) ch = (char)tolower(ch);
        return lc.find(w) != std::string::npos;
    };
    if (g_gv.confirm_key == "@INDIANLAND") {
        if (has("offer")) {                    // "We offer you {%NUMBER1$}"
            g_gv.found_acks.push_back(g_gv.confirm_key);
            found_attempt("pay");
        } else if (has("mistaken")) {          // "You are mistaken; this is ours"
            g_gv.found_acks.push_back(g_gv.confirm_key);
            found_attempt("claim");
        } else {
            g_gv.found_acks.clear();           // "we shall respect your wishes"
        }
        return;
    }
    if (has("anyway")) {                       // @TUTNO*: "Build colony anyway."
        g_gv.found_acks.push_back(g_gv.confirm_key);
        found_attempt("");
    } else {
        g_gv.found_acks.clear();
    }
}

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
    for (const std::string& n : g_turn_notices) game_log(n);   // drain them ALL
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
    // headless/CI hooks: FORGE_COLONY=N / FORGE_EUROPE=1 open a screen (shots)
    static const char* auto_col = std::getenv("FORGE_COLONY");
    if (auto_col && g_app.game_active) {
        g_gv.colony_view = std::atoi(auto_col);
        auto_col = nullptr;
    }
    static const char* auto_eur = std::getenv("FORGE_EUROPE");
    if (auto_eur && g_app.game_active) {
        g_gv.europe_view = true;
        auto_eur = nullptr;
    }
    static const char* auto_rep = std::getenv("FORGE_REPORT");
    if (auto_rep && g_app.game_active) {
        g_gv.report_view = std::atoi(auto_rep);
        auto_rep = nullptr;
    }
    if (g_app.game_active) {
        ImGui::SameLine();
        if (ImGui::Button("End Turn (Enter)")) game_end_turn();
        ImGui::SameLine();
        ImGui::Text("Turn %ld  Gold %lld", (long)g_game.turn,
                    (long long)g_game.powers[0].gold);

        ImGui::SameLine();
        if (g_gv.colony_view < 0 && !g_gv.europe_view && g_gv.report_view == 0) {
            if (ImGui::Button("Europe (E)")) g_gv.europe_view = true;
            ImGui::SameLine();
            ImGui::TextDisabled("F1-F10 reports");
        } else {
            if (ImGui::Button("Back to map (Esc)") ||
                (ImGui::IsWindowFocused() && ImGui::IsKeyPressed(ImGuiKey_Escape))) {
                g_gv.colony_view = -1;
                g_gv.europe_view = false;
                g_gv.report_view = 0;
            }
        }
        // the advisor reports open from anywhere in the game view
        if (ImGui::IsWindowFocused())
            for (int fk = 0; fk < 10; ++fk)
                if (ImGui::IsKeyPressed((ImGuiKey)(ImGuiKey_F1 + fk))) {
                    g_gv.report_view = fk + 1;
                    g_gv.colony_view = -1;
                    g_gv.europe_view = false;
                }
        if (g_gv.report_view > 0) {
            vc::Surface scr;
            scr.set_palette(A.pal);
            if (studio::compose_report(scr, g_gv.report_view)) {
                vc::Image img = scr.to_rgb(1);
                drv.update_texture(g_gv.tex, img.rgb.data());
                float availw = ImGui::GetContentRegionAvail().x;
                float scale = availw / vc::Surface::W;
                if (scale > 3.0f) scale = 3.0f;
                if (scale < 1.0f) scale = 1.0f;
                ImGui::Image((ImTextureID)(intptr_t)g_gv.tex.id,
                             ImVec2(vc::Surface::W * scale, vc::Surface::H * scale));
                ImGui::TextDisabled("advisor report F%d -- F1..F10 switch, Esc closes",
                                    g_gv.report_view);
            }
            ImGui::End();
            return;
        }

        // --- colony screen (spec composer): opened by clicking an own colony.
        // Click a ring cell of the worked-tiles grid to assign a colonist
        // there (Farmer, the /api/colony/assign default) or take one off.
        if (g_gv.colony_view >= 0 &&
            g_gv.colony_view < (int)g_world.colonies.size()) {
            vc::sim::Colony& c = g_world.colonies[g_gv.colony_view];
            const vc::IndexedPng* backdrop = studio::atlas_file("pik/COLONY.png");
            static vc::Sheet parch;          // PARCH tile from the contact sheet
            if (parch.nframes == 0)
                if (const vc::Frame* pf = studio::sheet_window("PARCH")) {
                    parch.nframes = 1;
                    parch.frames.push_back(*pf);
                }
            if (backdrop && parch.nframes > 0) {
                vc::Surface scr;
                scr.set_palette(A.pal);
                vc::Map m = session_map();
                int stock[16];
                for (int i = 0; i < 16; ++i)
                    stock[i] = i < (int)c.stockpile.size() ? c.stockpile[i] : 0;
                render_colony_screen(scr, *backdrop, parch, A.woodtile, A.icons,
                                     A.buildings, A.font, A.terrain, A.phys, &m,
                                     c.x, c.y, c, (int)g_game.powers[0].gold,
                                     g_game.powers[0].tax, (int)g_game.year, stock);
                vc::Image img = scr.to_rgb(1);
                drv.update_texture(g_gv.tex, img.rgb.data());
                float availw = ImGui::GetContentRegionAvail().x;
                float scale = availw / vc::Surface::W;
                if (scale > 3.0f) scale = 3.0f;
                if (scale < 1.0f) scale = 1.0f;
                ImVec2 origin = ImGui::GetCursorScreenPos();
                ImGui::Image((ImTextureID)(intptr_t)g_gv.tex.id,
                             ImVec2(vc::Surface::W * scale, vc::Surface::H * scale));
                // worked-tiles grid hit test (colony_screen.cpp: CELL=24 at
                // 224,32; ring order = the assign route's RDX/RDY table).
                // Left-click: quick Farmer assign / take off. Right-click:
                // pick the profession from the 28 @JOB rows.
                static const int RDX[8] = {-1, 0, 1, -1, 1, -1, 0, 1};
                static const int RDY[8] = {-1, -1, -1, 0, 0, 1, 1, 1};
                auto assign_worker = [&](int tile, int profession, int good) {
                    for (int w = 0; w < (int)c.workers.size(); ++w)
                        if (c.workers[w].tile == tile) {
                            c.workers.erase(c.workers.begin() + w);
                            break;
                        }
                    vc::sim::Colony::Worker wk;
                    wk.profession = profession;
                    wk.tile = tile;
                    wk.good = good;
                    wk.expert = false;
                    int tid = g_world.terrain_id(c.x + RDX[tile], c.y + RDY[tile]);
                    wk.terrain = tid < 0 ? 2 : (tid & 0x1F);
                    c.workers.push_back(wk);
                    if ((int)c.workers.size() > c.population)
                        c.population = (int)c.workers.size();
                    forge::colony_compute_production(
                        c, g_game.difficulty, g_active_rules,
                        g_engine_extra.ff_owned, 0, &g_world, g_game.rumor_seed);
                };
                if (ImGui::IsItemHovered() &&
                    (ImGui::IsMouseClicked(0) || ImGui::IsMouseClicked(1))) {
                    ImVec2 mp = ImGui::GetMousePos();
                    int mx = (int)((mp.x - origin.x) / scale);
                    int my = (int)((mp.y - origin.y) / scale);
                    int col = (mx - 224) / 24, row = (my - 32) / 24;
                    if (mx >= 224 && my >= 32 && col >= 0 && col < 3 &&
                        row >= 0 && row < 3 && !(col == 1 && row == 1)) {
                        int tile = -1;
                        for (int t = 0; t < 8; ++t)
                            if (RDX[t] == col - 1 && RDY[t] == row - 1) tile = t;
                        if (ImGui::IsMouseClicked(1)) {          // profession pick
                            g_gv.prof_pick_tile = tile;
                            ImGui::OpenPopup("colprof");
                        } else {
                            int existing = -1;
                            for (int w = 0; w < (int)c.workers.size(); ++w)
                                if (c.workers[w].tile == tile) existing = w;
                            if (existing >= 0) {
                                c.workers.erase(c.workers.begin() + existing);
                                g_app.status = "colonist taken off the fields";
                                forge::colony_compute_production(
                                    c, g_game.difficulty, g_active_rules,
                                    g_engine_extra.ff_owned, 0, &g_world,
                                    g_game.rumor_seed);
                            } else {
                                assign_worker(tile, 19, 0);   // Farmer default
                                g_app.status = "farmer assigned to the fields";
                            }
                        }
                    }
                }
                // the profession picker: the 28 @JOB rows + the good each makes
                if (ImGui::BeginPopup("colprof")) {
                    Store* st = forge::drydock_store();
                    if (st) {
                        auto pi = st->type_index.find("prof");
                        auto gi = st->type_index.find("good");
                        if (pi != st->type_index.end()) {
                            // sort by @JOB index for a stable, spec-ordered list
                            std::vector<const Record*> profs;
                            for (const Record& p : st->records[pi->second])
                                profs.push_back(&p);
                            std::sort(profs.begin(), profs.end(),
                                      [](const Record* a, const Record* b) {
                                          const Value* ia = a->find("index");
                                          const Value* ib = b->find("index");
                                          return (ia ? ia->i : 0) < (ib ? ib->i : 0);
                                      });
                            for (const Record* p : profs) {
                                const Value* ix = p->find("index");
                                const Value* nm = p->find("name");
                                const Value* pr = p->find("produces");
                                if (!ix || !nm) continue;
                                int good = 0;
                                std::string glabel;
                                if (pr && gi != st->type_index.end())
                                    for (const Record& gr : st->records[gi->second])
                                        if (gr.id == pr->s) {
                                            const Value* gx = gr.find("index");
                                            const Value* gn = gr.find("name");
                                            if (gx) good = (int)gx->i;
                                            if (gn) glabel = gn->s;
                                        }
                                std::string label = nm->s;
                                if (!glabel.empty()) label += "  (" + glabel + ")";
                                if (ImGui::Selectable(label.c_str())) {
                                    assign_worker(g_gv.prof_pick_tile, (int)ix->i,
                                                  good);
                                    g_app.status = nm->s + " assigned";
                                }
                            }
                        }
                    }
                    ImGui::EndPopup();
                }
                ImGui::TextDisabled("click a surrounding tile to assign/remove a "
                                    "colonist (right-click picks the profession)");
            } else {
                ImGui::TextDisabled("COLONY.PIK / PARCH sheet unavailable");
            }
            ImGui::End();
            return;
        }

        // --- Europe screen (europe_screen.md): the harbor + the 16-good
        // market bar (0,179) stride 19, icons 22..37, bid/ask published from
        // the live model. Click a good to SELL 1, right-click to BUY 1.
        if (g_gv.europe_view) {
            const vc::IndexedPng* backdrop = studio::atlas_file("pik/EUROPE.png");
            vc::Surface scr;
            scr.set_palette(A.pal);
            scr.clear(0);
            if (backdrop)
                scr.blit_region(*backdrop, 0, 0, backdrop->w, backdrop->h, 0, 0);
            uint8_t title_c = vc::nearest_pal_index(A.pal, 255, 255, 190);
            uint8_t val_c = vc::nearest_pal_index(A.pal, 247, 243, 199);
            char tl[96];
            std::snprintf(tl, sizeof tl, "London, England.  Year %d.  Tax: %d%%  Gold: %lld",
                          (int)g_game.year, g_game.powers[0].tax,
                          (long long)g_game.powers[0].gold);
            scr.draw_text(A.font, 8, 1, tl, title_c);
            for (int gd = 0; gd < 16; ++gd) {           // the market bar
                int cx = gd * 19;
                int fi = 22 + gd;                        // goods icons (png ids)
                if (fi < A.icons.nframes) {
                    const vc::Frame& f = A.icons.frames[fi];
                    scr.blit_frame(f, cx + (19 - f.w) / 2, 180);
                }
                int bid = vc::sim::market_bid(g_game, 0, gd);
                int ask = vc::sim::market_ask(g_game, 0, gd, g_active_rules);
                char pr[16];
                std::snprintf(pr, sizeof pr, "%d/%d", bid, ask);
                int tw = scr.text_width(A.font, pr);
                scr.draw_text(A.font, cx + (19 - tw) / 2, 194, pr, val_c);
            }
            // the recruit dock (immigration.md 3): the three waiting slots;
            // the cost is the class's @CLASS transport_cost (FoY makes free)
            auto recruit_cost = [&](int cls) -> long {
                if (g_engine_extra.free_recruits > 0) return 0;
                forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra,
                                    g_active_rules, game_rng};
                int row = cls == 0x19 ? 0 : cls == 0x1A ? 1 : 2;
                long cost = forge::resolve_binding(
                    "@CLASS[" + std::to_string(row) + "].transport_cost", cx).as_int();
                return cost < 0 ? 0 : cost;
            };
            auto slot_name = [&](int cls) -> std::string {
                if (cls < 0) return "-";
                if (cls < vc::sim::NUNITTYPES) {
                    const char* n = vc::sim::unit_stats(g_active_rules, cls).name;
                    return n ? n : "colonist";
                }
                return forge::job_name(cls, false);
            };
            scr.draw_text(A.font, 146, 108, "On the dock (click to recruit):",
                          title_c);
            for (int s = 0; s < 3; ++s) {
                int cls = g_game.powers[0].dock_pool[s];
                std::string row = std::to_string(s + 1) + ". " + slot_name(cls);
                if (cls >= 0)
                    row += "  (" + std::to_string(recruit_cost(cls)) + ")";
                scr.draw_text(A.font, 146, 117 + s * 9, row, val_c);
            }
            vc::Image img = scr.to_rgb(1);
            drv.update_texture(g_gv.tex, img.rgb.data());
            float availw = ImGui::GetContentRegionAvail().x;
            float scale = availw / vc::Surface::W;
            if (scale > 3.0f) scale = 3.0f;
            if (scale < 1.0f) scale = 1.0f;
            ImVec2 origin = ImGui::GetCursorScreenPos();
            ImGui::Image((ImTextureID)(intptr_t)g_gv.tex.id,
                         ImVec2(vc::Surface::W * scale, vc::Surface::H * scale));
            if (ImGui::IsItemHovered()) {
                ImVec2 mp = ImGui::GetMousePos();
                int mx = (int)((mp.x - origin.x) / scale);
                int my = (int)((mp.y - origin.y) / scale);
                // dock slots: click recruits (mirrors /api/europe/recruit)
                if (mx >= 146 && my >= 117 && my < 144 && ImGui::IsMouseClicked(0)) {
                    int s = (my - 117) / 9;
                    int cls = s >= 0 && s < 3 ? g_game.powers[0].dock_pool[s] : -1;
                    if (cls >= 0) {
                        long cost = recruit_cost(cls);
                        if (g_engine_extra.free_recruits > 0) {
                            --g_engine_extra.free_recruits;
                        } else if (g_game.powers[0].gold < cost) {
                            g_app.status = "not enough gold to recruit";
                            cls = -2;
                        } else {
                            g_game.powers[0].gold -= cost;
                        }
                        if (cls >= 0) {
                            vc::sim::Unit u;
                            u.owner = 0;
                            u.alive = true;
                            if (cls < vc::sim::NUNITTYPES) u.type = cls;
                            else { u.type = vc::sim::COLONISTS; u.profession = cls; }
                            if (!g_colony_xy.empty()) {
                                u.x = g_colony_xy[0].first;
                                u.y = g_colony_xy[0].second;
                            }
                            g_world.units.push_back(u);
                            g_game.powers[0].dock_pool[s] = -1;
                            g_app.status = "recruited " + slot_name(cls) + " for " +
                                           std::to_string(cost);
                        }
                    }
                }
                if (my >= 179 && mx < 304) {
                    int gd = mx / 19;
                    if (gd >= 0 && gd < 16) {
                        int bid = vc::sim::market_bid(g_game, 0, gd);
                        int ask = vc::sim::market_ask(g_game, 0, gd, g_active_rules);
                        ImGui::SetTooltip("good %d -- pays %d, costs %d\n"
                                          "click: sell 1   right-click: buy 1",
                                          gd, bid, ask);
                        if (ImGui::IsMouseClicked(0)) {
                            long net = vc::sim::market_sell(g_game, 0, gd, 1,
                                                            g_active_rules);
                            g_app.status = "sold 1 for " + std::to_string(net);
                        }
                        if (ImGui::IsMouseClicked(1)) {
                            if (g_game.powers[0].gold >= ask) {
                                long cost = vc::sim::market_buy(g_game, 0, gd, 1,
                                                                g_active_rules);
                                g_app.status = "bought 1 for " + std::to_string(cost);
                            } else {
                                g_app.status = "not enough gold";
                            }
                        }
                    }
                }
            }
            // artillery purchase: base + 100 per prior purchase (@0x035282)
            long art_cost = g_active_rules.cfg.artillery_base_cost +
                            (long)g_engine_extra.artillery_bought * 100;
            char abuf[48];
            std::snprintf(abuf, sizeof abuf, "Buy Artillery (%ld)", art_cost);
            if (ImGui::Button(abuf)) {
                if (g_game.powers[0].gold < art_cost) {
                    g_app.status = "not enough gold for artillery";
                } else {
                    g_game.powers[0].gold -= art_cost;
                    ++g_engine_extra.artillery_bought;
                    vc::sim::Unit u;
                    u.type = vc::sim::ARTILLERY;
                    u.owner = 0;
                    u.alive = true;
                    if (!g_colony_xy.empty()) {
                        u.x = g_colony_xy[0].first;
                        u.y = g_colony_xy[0].second;
                    }
                    g_world.units.push_back(u);
                    g_app.status = "artillery purchased for " +
                                   std::to_string(art_cost);
                }
            }
            ImGui::SameLine();
            ImGui::TextDisabled("market: click sells 1, right-click buys 1; "
                                "dock rows recruit");
            ImGui::End();
            return;
        }

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

        // the found-colony confirmation, in the game's popup chrome
        vc::PopupSpec cs;
        vc::PopupLayout csL{};
        if (g_gv.confirm_open) {
            cs.lines = g_gv.confirm_lines;
            cs.choices = g_gv.confirm_choices;
            cs.highlight = g_gv.confirm_hover;
            csL = vc::popup_layout(A.font, cs);
            static const vc::IndexedPng no_panl;
            const vc::IndexedPng* panl = studio::atlas_file("pik/WOODPANL.png");
            render_popup(scr, panl ? *panl : no_panl, A.font, cs, csL);
        }

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
        // clicks: confirm choices > goto target > open colony > select unit
        if (ImGui::IsItemHovered()) {
            ImVec2 mp = ImGui::GetMousePos();
            int mx = (int)((mp.x - origin.x) / scale), my = (int)((mp.y - origin.y) / scale);
            if (g_gv.confirm_open) {
                g_gv.confirm_hover = -1;
                for (int i = 0; i < (int)cs.choices.size(); ++i) {
                    int cx, cy, cw, ch;
                    vc::popup_choice_rect(csL, i, cx, cy, cw, ch);
                    if (mx >= cx && mx < cx + cw && my >= cy && my < cy + ch) {
                        g_gv.confirm_hover = i;
                        if (ImGui::IsMouseClicked(0)) found_choice(cs.choices[i]);
                    }
                }
            } else if (ImGui::IsMouseClicked(0) && mx < 240 && my >= 8) {
                int tx = g_gv.ox + mx / 16, ty = g_gv.oy + (my - 8) / 16;
                if (g_gv.goto_mode && g_gv.sel >= 0) {
                    g_gv.goto_mode = false;
                    OrderResult r = unit_order(g_gv.sel, "", tx, ty);
                    game_log(r.ok ? "going to (" + std::to_string(tx) + "," +
                                        std::to_string(ty) + ") -- moves on End Turn"
                                  : r.err);
                } else {
                    bool opened = false;
                    for (int ci = 0; ci < (int)g_world.colonies.size(); ++ci) {
                        const vc::sim::Colony& c = g_world.colonies[ci];
                        if (c.x == tx && c.y == ty && c.owner_power == 0) {
                            g_gv.colony_view = ci;   // own colony: open its screen
                            opened = true;
                            break;
                        }
                    }
                    if (!opened) {
                        int ui = vc::sim::unit_at(g_world, tx, ty);
                        if (ui >= 0 && g_world.units[ui].owner == 0) g_gv.sel = ui;
                    }
                }
            }
        }
        if (ImGui::IsWindowFocused() && !g_gv.confirm_open) {
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
            if (ImGui::IsKeyPressed(ImGuiKey_E)) g_gv.europe_view = true;
            // the @ORDERS accelerators (unit_orders.md) on the selected unit
            if (g_gv.sel >= 0) {
                auto named = [&](const char* o, const char* what) {
                    OrderResult r = unit_order(g_gv.sel, o);
                    game_log(r.ok ? what : r.err);
                };
                if (ImGui::IsKeyPressed(ImGuiKey_F)) named("F", "fortifying");
                if (ImGui::IsKeyPressed(ImGuiKey_S)) named("S", "sentry");
                if (ImGui::IsKeyPressed(ImGuiKey_P)) named("P", "clearing / plowing");
                if (ImGui::IsKeyPressed(ImGuiKey_R)) named("R", "building a road");
                if (ImGui::IsKeyPressed(ImGuiKey_Minus)) named("-", "orders cleared");
                if (ImGui::IsKeyPressed(ImGuiKey_L)) named("L", "loaded the most valuable good");
                if (ImGui::IsKeyPressed(ImGuiKey_U)) named("U", "unloaded the most valuable hold");
                if (ImGui::IsKeyPressed(ImGuiKey_O)) named("O", "cargo dumped overboard");
                if (ImGui::GetIO().KeyShift && ImGui::IsKeyPressed(ImGuiKey_D)) {
                    named("D", "unit disbanded");
                    g_gv.sel = next_own_unit(-1);
                }
                if (ImGui::IsKeyPressed(ImGuiKey_B)) {
                    g_gv.found_acks.clear();
                    found_attempt("");
                }
                if (ImGui::IsKeyPressed(ImGuiKey_G)) {
                    g_gv.goto_mode = true;
                    game_log("go-to: click the target tile");
                }
            }
        }
        // selected-unit line + the recent-notice log
        if (g_gv.sel >= 0 && g_gv.sel < (int)g_world.units.size() &&
            g_world.units[g_gv.sel].alive) {
            const vc::sim::Unit& u = g_world.units[g_gv.sel];
            const char* nm = vc::sim::unit_stats(g_active_rules, u.type).name;
            ImGui::TextDisabled("%s at (%d,%d)  move credits %d  |  F/S/P/R "
                                "orders, B found, G goto, L/U/O cargo, "
                                "Shift-D disband",
                                nm ? nm : "unit", u.x, u.y, u.moves_left);
        }
        for (const std::string& s : g_gv.log) ImGui::TextDisabled("%s", s.c_str());
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
