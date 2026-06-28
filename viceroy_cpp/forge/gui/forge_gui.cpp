// forge/gui/forge_gui.cpp -- Viceroy Forge desktop GUI (Dear ImGui).
//
// SCAFFOLD. This is the windowed front-end that sits on top of the already-tested
// forge backend: the balance inspector (forge/inspect.hpp), the rules overlay
// loader (forge/rules_json.hpp + sim invariants), and the map editor core
// (forge/mapedit.hpp). All game logic, curves, validation, and .MP I/O are reused
// verbatim -- this file only renders them with ImGui.
//
// It is built ONLY when configured with -DFORGE_GUI=ON, which FetchContent-pulls
// Dear ImGui + GLFW (needs network + an OpenGL dev environment). It is therefore
// NOT compiled in the default/CI build and was NOT compiled in the authoring
// environment (no GUI libs / no network). The GLFW+OpenGL3 boilerplate mirrors the
// upstream example_glfw_opengl3; the ImGui calls use the stable core API.
#include "imgui.h"
#include "backends/imgui_impl_glfw.h"
#include "backends/imgui_impl_opengl3.h"
#include <GLFW/glfw3.h>

#include "inspect.hpp"
#include "mapedit.hpp"
#include "rules_invariants.hpp"
#include "rules_json.hpp"

#include <cstdio>
#include <cstring>
#include <string>
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
};

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
    ImGui::StyleColorsDark();
    ImGui_ImplGlfw_InitForOpenGL(window, true);
    ImGui_ImplOpenGL3_Init(glsl_version);

    AppState state;
    while (!glfwWindowShouldClose(window)) {
        glfwPollEvents();
        ImGui_ImplOpenGL3_NewFrame();
        ImGui_ImplGlfw_NewFrame();
        ImGui::NewFrame();

        draw_rules_window(state);
        draw_map_window(state);

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
    ImGui::DestroyContext();
    glfwDestroyWindow(window);
    glfwTerminate();
    return 0;
}
