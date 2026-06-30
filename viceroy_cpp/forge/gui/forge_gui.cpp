// forge/gui/forge_gui.cpp -- Viceroy Forge desktop GUI (Dear ImGui + imnodes).
//
// SCAFFOLD. This is the windowed front-end that sits on top of the already-tested
// forge backend: the balance inspector (forge/inspect.hpp), the rules overlay
// loader (forge/rules_json.hpp + sim invariants), the map editor core
// (forge/mapedit.hpp), AND the data-driven game engine (forge/engine.hpp) -- the
// same node catalog / graph interpreter / binding resolver the browser IDE uses,
// here linked IN-PROCESS (no HTTP). All game logic, curves, validation, .MP I/O,
// and the engine VM are reused verbatim; this file only renders them.
//
// It is built ONLY when configured with -DFORGE_GUI=ON, which FetchContent-pulls
// Dear ImGui + imnodes + GLFW (needs network + an OpenGL dev environment). It is
// therefore NOT compiled in the default/CI build and is NOT compiled/verified in
// this authoring environment (no GUI libs / no network) -- the browser engine is
// the verified twin to diff against. The GLFW+OpenGL3 boilerplate mirrors the
// upstream example_glfw_opengl3; the ImGui calls use the stable core API; the
// node editor targets imnodes v0.5 (BeginNodeEditor/BeginNode/Link).
#include "imgui.h"
#include "imnodes.h"
#include "backends/imgui_impl_glfw.h"
#include "backends/imgui_impl_opengl3.h"
#include <GLFW/glfw3.h>

#include "engine.hpp"
#include "inspect.hpp"
#include "mapedit.hpp"
#include "ref.hpp"          // ref_start (King's starting army)
#include "rules_invariants.hpp"
#include "rules_json.hpp"

#include <cstdio>
#include <cstring>
#include <string>
#include <utility>
#include <vector>

using namespace vc::sim;

// --- a small terrain color palette for the map canvas ---
static ImU32 terrain_color(int id) {
    switch (id) {
        case 25: case 26: return IM_COL32( 40,  90, 170, 255);  // Ocean / Sea Lane
        case 24:          return IM_COL32(230, 235, 245, 255);  // Arctic
        case 27:          return IM_COL32(110, 105, 100, 255);  // Mountains
        case 28:          return IM_COL32(150, 120,  80, 255);  // Hills
        case 1:           return IM_COL32(210, 200, 120, 255);  // Desert
        case 6: case 7:   return IM_COL32( 90, 120,  90, 255);  // Marsh / Swamp
    }
    if (id >= 8 && id <= 23) return IM_COL32(30, 100, 40, 255); // forested
    return IM_COL32(90, 160, 70, 255);                          // open land
}

struct AppState {
    RuleData base = make_default_rules();
    RuleData cur  = base;
    char overlay_path[512] = "viceroy_cpp/forge/sample_rules.json";
    std::vector<std::string> overlay_warnings;

    forge::MpFile map;
    bool map_loaded = false;
    char map_path[512] = "";
    int  paint_id = 2;          // Plains
    bool paint_river = false, paint_forest = false;
    forge::MapReport map_report;
    bool map_validated = false;

    // --- in-process engine (the same node-graph VM the browser IDE runs) ---
    GameState eng_g;
    World     eng_w;
    std::vector<std::pair<int,int>> eng_colony_xy;
    forge::EngineExtra eng_extra;
    RuleData  eng_rules = make_default_rules();    // edits in Rules window can feed this
    int       eng_seed  = 0x2BAD1234;
    forge::JsonValue eng_catalog;                  // node_catalog(), populated on first frame
    forge::JsonValue eng_graph;                    // currently loaded graph
    bool      eng_loaded = false, eng_need_layout = false;
    char      eng_graph_id[128] = "kings_tax";
    std::vector<std::string> eng_log, eng_effects;
    std::string eng_status;
};

// Build an EngineCtx over the AppState's in-process game (refs + a deterministic rng).
static forge::EngineCtx engine_ctx(AppState& s) {
    auto rng = [&s](int lo, int hi) {
        s.eng_seed = s.eng_seed * 1103515245 + 12345;
        unsigned v = ((unsigned)s.eng_seed >> 16) & 0x7FFF;
        return hi <= lo ? lo : lo + (int)(v % (unsigned)(hi - lo + 1));
    };
    return forge::EngineCtx{s.eng_g, s.eng_w, s.eng_colony_xy, s.eng_extra, s.eng_rules, rng};
}

// imnodes shares ONE id space across nodes, attributes (pins) and links, so the three
// must not collide: node ids stay small (0..N-1), attributes live at ATTR_BASE + node*256
// + pinOrdinal, links at LINK_BASE + edgeIndex.
static const int ATTR_BASE = 100000;
static const int LINK_BASE = 1000000;

// The ordered pin list (name,dir) for a node type, read from the node catalog.
static std::vector<std::pair<std::string,std::string>>
catalog_pins(const forge::JsonValue& catalog, const std::string& type) {
    std::vector<std::pair<std::string,std::string>> out;
    const forge::JsonValue* cats = catalog.find("categories");
    if (!cats) return out;
    for (const auto& c : cats->arr) {
        const forge::JsonValue* ns = c.find("nodes"); if (!ns) continue;
        for (const auto& n : ns->arr) {
            const forge::JsonValue* t = n.find("type");
            if (!t || t->str != type) continue;
            const forge::JsonValue* ps = n.find("pins"); if (!ps) return out;
            for (const auto& p : ps->arr) {
                const forge::JsonValue* nm = p.find("name"); const forge::JsonValue* dr = p.find("dir");
                if (nm && dr) out.push_back({nm->str, dr->str});
            }
            return out;
        }
    }
    return out;
}

// The FULL pin list for an actual node = its type's catalog pins + any DYNAMIC pins.
// ShowPopup grows one output pin per choice (comma/newline separated), exactly as the
// interpreter does -- so the editor draws (and attr_of resolves) the choice branches.
static std::vector<std::pair<std::string,std::string>>
node_pins(const forge::JsonValue& node, const forge::JsonValue& catalog) {
    const forge::JsonValue* tv = node.find("type");
    auto pins = catalog_pins(catalog, tv ? tv->str : "");
    if (tv && tv->str == "ShowPopup") {
        const forge::JsonValue* ps = node.find("params");
        const forge::JsonValue* ch = ps ? ps->find("choices") : nullptr;
        if (ch) {
            std::string cur;
            auto push = [&]{ if (!cur.empty()) { pins.push_back({cur, "out"}); cur.clear(); } };
            for (char c : ch->str) { if (c == '\n' || c == ',') push(); else cur += c; }
            push();
        }
    }
    return pins;
}

static void draw_rules_window(AppState& s) {
    ImGui::Begin("Rules Inspector");

    if (ImGui::Button("Reset to default")) { s.cur = s.base; s.overlay_warnings.clear(); }
    ImGui::SameLine();
    ImGui::SetNextItemWidth(280);
    ImGui::InputText("##overlay", s.overlay_path, sizeof s.overlay_path);
    ImGui::SameLine();
    if (ImGui::Button("Load overlay")) {
        try {
            forge::OverlayResult o = forge::load_overlay(s.overlay_path, make_default_rules());
            s.cur = o.rules;
            s.overlay_warnings = o.warnings;
        } catch (const std::exception& e) {
            s.overlay_warnings = {std::string("ERROR: ") + e.what()};
        }
    }
    for (const auto& w : s.overlay_warnings)
        ImGui::TextColored(ImVec4(1, 0.8f, 0.2f, 1), "  %s", w.c_str());

    // live-editable scalars (a representative subset)
    ImGui::SeparatorText("Tunable scalars");
    ImGui::InputInt("warehouse_cap_base", &s.cur.cfg.warehouse_cap_base);
    ImGui::InputInt("ref_accrue_offset",  &s.cur.cfg.ref_accrue_offset);
    ImGui::InputInt("ff_human_scale",     &s.cur.cfg.ff_human_scale);
    ImGui::InputInt("price_drift_shift",  &s.cur.cfg.price_drift_shift);

    // invariants
    InvariantReport rep = check_rules(s.cur);
    ImGui::SeparatorText("Invariants");
    if (rep.ok()) ImGui::TextColored(ImVec4(0.3f, 1, 0.3f, 1), "PASS");
    else {
        ImGui::TextColored(ImVec4(1, 0.3f, 0.3f, 1), "FAIL");
        for (const auto& v : rep.violations)
            ImGui::TextColored(ImVec4(1, 0.5f, 0.5f, 1), "  ! %s", v.c_str());
    }

    // balance curves vs baseline
    ImGui::SeparatorText("Balance curves (vs default)");
    if (ImGui::BeginTable("curves", 4,
            ImGuiTableFlags_Borders | ImGuiTableFlags_RowBg | ImGuiTableFlags_ScrollY)) {
        ImGui::TableSetupColumn("section");
        ImGui::TableSetupColumn("metric");
        ImGui::TableSetupColumn("value");
        ImGui::TableSetupColumn("delta");
        ImGui::TableHeadersRow();
        for (const auto& r : forge::balance_curves(s.base, s.cur)) {
            ImGui::TableNextRow();
            ImGui::TableNextColumn(); ImGui::TextUnformatted(r.section.c_str());
            ImGui::TableNextColumn(); ImGui::TextUnformatted(r.label.c_str());
            ImGui::TableNextColumn(); ImGui::Text("%ld", r.cur);
            ImGui::TableNextColumn();
            if (r.delta()) ImGui::TextColored(ImVec4(1, 0.85f, 0.2f, 1), "%+ld", r.delta());
            else           ImGui::TextDisabled("-");
        }
        ImGui::EndTable();
    }
    ImGui::End();
}

static void draw_map_window(AppState& s) {
    ImGui::Begin("Map Editor");

    ImGui::SetNextItemWidth(280);
    ImGui::InputText("##mappath", s.map_path, sizeof s.map_path);
    ImGui::SameLine();
    if (ImGui::Button("Load")) {
        try { s.map = forge::load_mp(s.map_path); s.map_loaded = true; s.map_validated = false; }
        catch (const std::exception& e) { std::fprintf(stderr, "load: %s\n", e.what()); }
    }
    ImGui::SameLine();
    if (ImGui::Button("Save") && s.map_loaded) {
        try { forge::save_mp(s.map_path, s.map); } catch (...) {}
    }
    ImGui::SameLine();
    if (ImGui::Button("New 56x70")) { s.map = forge::make_blank(56, 70); s.map_loaded = true; }

    if (!s.map_loaded) { ImGui::TextDisabled("No map loaded."); ImGui::End(); return; }

    ImGui::Text("size %dx%d  (%zu trailing bytes preserved)", s.map.w, s.map.h, s.map.rest.size());
    ImGui::InputInt("paint terrain id", &s.paint_id);
    if (s.paint_id < 0) s.paint_id = 0;
    if (s.paint_id > forge::MP_MAX_TERRAIN_ID) s.paint_id = forge::MP_MAX_TERRAIN_ID;
    ImGui::Checkbox("river", &s.paint_river); ImGui::SameLine();
    ImGui::Checkbox("forest", &s.paint_forest);
    if (ImGui::Button("Validate")) { s.map_report = forge::validate(s.map); s.map_validated = true; }
    if (s.map_validated) {
        ImGui::SameLine();
        ImGui::Text("land=%d ocean=%d  %s", s.map_report.land_masses, s.map_report.oceans,
                    s.map_report.ok() ? "OK" : "ISSUES");
        for (const auto& i : s.map_report.issues)
            ImGui::TextColored(ImVec4(1, 0.4f, 0.4f, 1), "  ! %s", i.c_str());
        for (const auto& wn : s.map_report.warnings)
            ImGui::TextColored(ImVec4(1, 0.85f, 0.2f, 1), "  ~ %s", wn.c_str());
    }

    // canvas: one filled rect per tile; click/drag paints the selected terrain.
    const float cell = 8.0f;
    ImVec2 origin = ImGui::GetCursorScreenPos();
    ImDrawList* dl = ImGui::GetWindowDrawList();
    for (int y = 0; y < s.map.h; ++y) {
        for (int x = 0; x < s.map.w; ++x) {
            ImVec2 p0(origin.x + x * cell, origin.y + y * cell);
            ImVec2 p1(p0.x + cell - 1, p0.y + cell - 1);
            dl->AddRectFilled(p0, p1, terrain_color(s.map.terrain_id(x, y)));
            if (s.map.has_river(x, y))  dl->AddLine(p0, p1, IM_COL32(80, 160, 255, 255));
            if (s.map.has_forest(x, y)) dl->AddRect(p0, p1, IM_COL32(0, 60, 0, 255));
        }
    }
    // an invisible button over the whole grid captures mouse painting.
    ImGui::InvisibleButton("canvas", ImVec2(s.map.w * cell, s.map.h * cell));
    if (ImGui::IsItemActive() && ImGui::IsMouseDown(ImGuiMouseButton_Left)) {
        ImVec2 m = ImGui::GetIO().MousePos;
        int x = (int)((m.x - origin.x) / cell), y = (int)((m.y - origin.y) / cell);
        if (s.map.in_bounds(x, y)) {
            forge::set_terrain(s.map, x, y, s.paint_id);
            forge::set_river(s.map, x, y, s.paint_river);
            forge::set_forest(s.map, x, y, s.paint_forest);
        }
    }
    ImGui::End();
}

// imnodes attribute id for (nodeId, pinName): node_index*256 + pin_ordinal (catalog order).
static int attr_of(AppState& s, const std::string& nodeId, const std::string& pin) {
    const forge::JsonValue* nodes = s.eng_graph.find("nodes"); if (!nodes) return -1;
    for (size_t i = 0; i < nodes->arr.size(); ++i) {
        const forge::JsonValue* idv = nodes->arr[i].find("id");
        if (!idv || idv->str != nodeId) continue;
        auto pins = node_pins(nodes->arr[i], s.eng_catalog);
        for (size_t pi = 0; pi < pins.size(); ++pi)
            if (pins[pi].first == pin) return ATTR_BASE + (int)i * 256 + (int)pi;
        return -1;
    }
    return -1;
}

static void engine_reset_game(AppState& s) {
    s.eng_g = GameState{}; s.eng_w = World{}; s.eng_colony_xy.clear();
    s.eng_extra = forge::EngineExtra{}; s.eng_seed = 0x2BAD1234;
    s.eng_g.powers[0].gold = 500;
    for (int i = 0; i < NGOODS; ++i) s.eng_g.price_base[i] = 800;
    s.eng_g.ref = ref_start(s.eng_g.difficulty);
}

// The engine tab: node palette + imnodes graph canvas + Run + bindings, all driven
// by the same forge::engine API the browser IDE uses (node_catalog/load_graph/run_graph).
static void draw_engine_window(AppState& s) {
    if (!s.eng_catalog.find("categories")) s.eng_catalog = forge::node_catalog();

    ImGui::Begin("Engine - Node Graph");

    ImGui::SetNextItemWidth(180);
    ImGui::InputText("##gid", s.eng_graph_id, sizeof s.eng_graph_id);
    ImGui::SameLine();
    if (ImGui::Button("Load")) {
        try { s.eng_graph = forge::load_graph(s.eng_graph_id);
              s.eng_loaded = true; s.eng_need_layout = true;
              s.eng_status = std::string("loaded ") + s.eng_graph_id; }
        catch (const std::exception& e) { s.eng_status = std::string("load failed: ") + e.what(); }
    }
    ImGui::SameLine();
    if (ImGui::Button("Run") && s.eng_loaded) {
        forge::EngineCtx cx = engine_ctx(s);
        forge::JsonValue rep = forge::run_graph(s.eng_graph, cx);
        s.eng_log.clear(); s.eng_effects.clear();
        if (const forge::JsonValue* l = rep.find("log")) for (auto& m : l->arr) s.eng_log.push_back(m.str);
        if (const forge::JsonValue* e = rep.find("effects")) for (auto& m : e->arr) s.eng_effects.push_back(m.str);
        const forge::JsonValue* pop = rep.find("popup");
        s.eng_status = (pop && pop->is_object()) ? "paused at popup" : "ran to completion";
    }
    ImGui::SameLine();
    if (ImGui::Button("Reset game")) engine_reset_game(s);
    ImGui::SameLine(); ImGui::TextDisabled("%s", s.eng_status.c_str());

    // left: node palette (the catalog the editor offers); right: the graph canvas.
    ImGui::BeginChild("palette", ImVec2(220, 0), true);
    ImGui::SeparatorText("Node palette");
    if (const forge::JsonValue* cats = s.eng_catalog.find("categories"))
        for (const auto& c : cats->arr) {
            const forge::JsonValue* cn = c.find("name");
            if (ImGui::TreeNode(cn ? cn->str.c_str() : "?")) {
                if (const forge::JsonValue* ns = c.find("nodes"))
                    for (const auto& n : ns->arr) {
                        const forge::JsonValue* ti = n.find("title");
                        ImGui::BulletText("%s", ti ? ti->str.c_str() : "?");
                        const forge::JsonValue* su = n.find("summary");
                        if (su && ImGui::IsItemHovered()) ImGui::SetTooltip("%s", su->str.c_str());
                    }
                ImGui::TreePop();
            }
        }
    ImGui::EndChild();
    ImGui::SameLine();

    ImGui::BeginChild("canvas", ImVec2(0, -160), true);
    ImNodes::BeginNodeEditor();
    if (const forge::JsonValue* nodes = s.eng_graph.find("nodes")) {
        for (size_t i = 0; i < nodes->arr.size(); ++i) {
            const forge::JsonValue& nd = nodes->arr[i];
            const forge::JsonValue* tv = nd.find("type"); if (!tv) continue;
            int nid = (int)i;
            if (s.eng_need_layout) {
                const forge::JsonValue* xv = nd.find("x"); const forge::JsonValue* yv = nd.find("y");
                ImNodes::SetNodeGridSpacePos(nid, ImVec2(xv ? (float)xv->num : 40.0f * i,
                                                         yv ? (float)yv->num : 40.0f));
            }
            ImNodes::BeginNode(nid);
            ImNodes::BeginNodeTitleBar(); ImGui::TextUnformatted(tv->str.c_str()); ImNodes::EndNodeTitleBar();
            auto pins = node_pins(nd, s.eng_catalog);
            for (size_t pi = 0; pi < pins.size(); ++pi) {
                int attr = ATTR_BASE + nid * 256 + (int)pi;
                if (pins[pi].second == "in") {
                    ImNodes::BeginInputAttribute(attr);
                    ImGui::TextUnformatted(pins[pi].first.c_str()); ImNodes::EndInputAttribute();
                } else {
                    ImNodes::BeginOutputAttribute(attr);
                    ImGui::TextUnformatted(pins[pi].first.c_str()); ImNodes::EndOutputAttribute();
                }
            }
            ImNodes::EndNode();
        }
        if (const forge::JsonValue* edges = s.eng_graph.find("edges"))
            for (size_t e = 0; e < edges->arr.size(); ++e) {
                const forge::JsonValue* fr = edges->arr[e].find("from");
                const forge::JsonValue* to = edges->arr[e].find("to");
                if (!fr || !to) continue;
                const forge::JsonValue* fn = fr->find("node"); const forge::JsonValue* fp = fr->find("pin");
                const forge::JsonValue* tn = to->find("node"); const forge::JsonValue* tp = to->find("pin");
                if (!fn || !fp || !tn || !tp) continue;
                int a = attr_of(s, fn->str, fp->str), b = attr_of(s, tn->str, tp->str);
                if (a >= 0 && b >= 0) ImNodes::Link(LINK_BASE + (int)e, a, b);
            }
    }
    ImNodes::EndNodeEditor();
    s.eng_need_layout = false;
    ImGui::EndChild();

    // bottom: live bindings + the last run's log/effects.
    ImGui::BeginChild("engfoot", ImVec2(0, 0), false);
    ImGui::Columns(3, "engcols", true);
    ImGui::SeparatorText("Bindings");
    {
        forge::EngineCtx cx = engine_ctx(s);
        for (const char* p : {"power0.gold", "natives.tension", "ff.count", "units.count", "colonies.count"}) {
            forge::JsonValue v = forge::resolve_binding(p, cx);
            if (v.type == forge::JsonValue::Number) ImGui::Text("%s = %ld", p, (long)v.num);
            else ImGui::Text("%s = -", p);
        }
    }
    ImGui::NextColumn();
    ImGui::SeparatorText("Effects");
    for (const auto& m : s.eng_effects) ImGui::TextWrapped("%s", m.c_str());
    ImGui::NextColumn();
    ImGui::SeparatorText("Log");
    for (const auto& m : s.eng_log) ImGui::TextDisabled("%s", m.c_str());
    ImGui::Columns(1);
    ImGui::EndChild();

    ImGui::End();
}

int main(int, char**) {
    if (!glfwInit()) { std::fprintf(stderr, "glfwInit failed\n"); return 1; }
    const char* glsl_version = "#version 130";
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 0);
    GLFWwindow* window = glfwCreateWindow(1280, 800, "Viceroy Forge", nullptr, nullptr);
    if (!window) { glfwTerminate(); return 1; }
    glfwMakeContextCurrent(window);
    glfwSwapInterval(1);

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImNodes::CreateContext();
    ImGui::StyleColorsDark();
    ImGui_ImplGlfw_InitForOpenGL(window, true);
    ImGui_ImplOpenGL3_Init(glsl_version);

    AppState state;
    engine_reset_game(state);
    while (!glfwWindowShouldClose(window)) {
        glfwPollEvents();
        ImGui_ImplOpenGL3_NewFrame();
        ImGui_ImplGlfw_NewFrame();
        ImGui::NewFrame();

        draw_rules_window(state);
        draw_map_window(state);
        draw_engine_window(state);

        ImGui::Render();
        int dw, dh; glfwGetFramebufferSize(window, &dw, &dh);
        glViewport(0, 0, dw, dh);
        glClearColor(0.10f, 0.10f, 0.12f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());
        glfwSwapBuffers(window);
    }

    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplGlfw_Shutdown();
    ImNodes::DestroyContext();
    ImGui::DestroyContext();
    glfwDestroyWindow(window);
    glfwTerminate();
    return 0;
}
