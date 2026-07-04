// panel_map.cpp -- the native map editor over the byte-faithful .MP model
// (forge/mapedit.hpp: L1 terrain plane editable, everything after preserved
// verbatim). The stage renders every tile through compose_map_tile -- the
// EXACT map-view tile stack (base ground + biome blend + forest/river/hills +
// coast) -- so what you paint is what the game draws. Terrain names come from
// the terr records (index 0..28), never invented.
#include "studio_shared.hpp"
#include "imgui.h"
#include "drydock_api.hpp"
#include "../drydock/core/store.hpp"
#include "mapedit.hpp"       // forge::MpFile load/save/set_*/validate
#include "mapview.hpp"       // vc::compose_map_tile
#include <cstring>
#include <string>
#include <vector>

using drydock::Record;
using drydock::Store;

namespace studio {
namespace {

struct MapState {
    char path[256] = "data_extracted/map/AMER2.MP";
    forge::MpFile mp;
    bool loaded = false;
    bool dirty = false;
    vc::Map vmap;                 // renderer mirror of mp.terrain
    vc::Image img;                // the composed full-map RGB
    Texture tex{};
    int tex_w = 0, tex_h = 0;
    int brush = 0;                // 0 terrain, 1 river+, 2 river-, 3 forest+, 4 forest-
    int terrain_id = 4;          // Grassland
    int last_tx = -1, last_ty = -1;
    std::vector<std::string> report;
};
MapState g_mp;

const char* BRUSHES[] = {"terrain", "river +", "river -", "forest +", "forest -"};

// terr records: index -> name (the 29 terrain ids, data-sourced)
std::string terrain_name(int id) {
    Store* st = forge::drydock_store();
    if (st) {
        auto ti = st->type_index.find("terr");
        if (ti != st->type_index.end())
            for (const Record& r : st->records[ti->second]) {
                const drydock::Value* ix = r.find("index");
                const drydock::Value* nm = r.find("name");
                if (ix && nm && ix->i == id) return nm->s;
            }
    }
    return "terrain " + std::to_string(id);
}

// recompose tile (mx,my) into the big image via the real map-view tile stack
void compose_one(vc::Surface& scr, int mx, int my) {
    vc::compose_map_tile(scr, g_mp.vmap, assets().nat.terrain, assets().nat.phys,
                         mx, my, 0, 0);
    for (int y = 0; y < 16; ++y)
        for (int x = 0; x < 16; ++x) {
            uint8_t i = scr.idx[(size_t)y * vc::Surface::W + x];
            uint8_t* p = &g_mp.img.rgb[(((size_t)(my * 16 + y) * g_mp.img.w) +
                                        (mx * 16 + x)) * 3];
            p[0] = scr.pal[i * 3];
            p[1] = scr.pal[i * 3 + 1];
            p[2] = scr.pal[i * 3 + 2];
        }
}

void compose_all() {
    g_mp.img.w = g_mp.mp.w * 16;
    g_mp.img.h = g_mp.mp.h * 16;
    g_mp.img.rgb.assign((size_t)g_mp.img.w * g_mp.img.h * 3, 0);
    vc::Surface scr;
    scr.set_palette(assets().nat.pal);
    for (int y = 0; y < g_mp.mp.h; ++y)
        for (int x = 0; x < g_mp.mp.w; ++x) compose_one(scr, x, y);
}

// after an edit at (tx,ty): sync the renderer mirror + recompose the 3x3
// neighbourhood (blend/coast/forest masks reach one ring out)
void recompose_around(int tx, int ty) {
    g_mp.vmap.tiles = g_mp.mp.terrain;
    vc::Surface scr;
    scr.set_palette(assets().nat.pal);
    for (int y = ty - 1; y <= ty + 1; ++y)
        for (int x = tx - 1; x <= tx + 1; ++x)
            if (g_mp.mp.in_bounds(x, y)) compose_one(scr, x, y);
}

bool map_load() {
    try {
        g_mp.mp = forge::load_mp(g_mp.path);
    } catch (const std::exception& e) {
        app().status = e.what();
        return false;
    }
    g_mp.vmap.w = g_mp.mp.w;
    g_mp.vmap.h = g_mp.mp.h;
    g_mp.vmap.tiles = g_mp.mp.terrain;
    g_mp.vmap.resfog.clear();
    compose_all();
    g_mp.loaded = true;
    g_mp.dirty = false;
    g_mp.tex_w = 0;   // force texture rebuild
    g_mp.report.clear();
    app().status = std::string("map loaded: ") + g_mp.path;
    return true;
}

void paint(int tx, int ty) {
    switch (g_mp.brush) {
        case 0: forge::set_terrain(g_mp.mp, tx, ty, g_mp.terrain_id); break;
        case 1: forge::set_river(g_mp.mp, tx, ty, true); break;
        case 2: forge::set_river(g_mp.mp, tx, ty, false); break;
        case 3: forge::set_forest(g_mp.mp, tx, ty, true); break;
        case 4: forge::set_forest(g_mp.mp, tx, ty, false); break;
    }
    recompose_around(tx, ty);
    g_mp.dirty = true;
}

}  // namespace

void map_panel(Driver& drv) {
    bool visible = ImGui::Begin("Map");
    if (!assets_ensure()) {
        ImGui::TextWrapped("assets: %s", assets().err.c_str());
        ImGui::End();
        return;
    }
    static bool auto_tried = false;   // open the project map on first view
    if (visible && !g_mp.loaded && !auto_tried) {
        auto_tried = true;
        map_load();
    }
    ImGui::SetNextItemWidth(280);
    ImGui::InputText("##path", g_mp.path, sizeof g_mp.path);
    ImGui::SameLine();
    if (ImGui::Button("Load")) map_load();
    ImGui::SameLine();
    if (ImGui::Button(g_mp.dirty ? "Save*" : "Save") && g_mp.loaded) {
        try {
            forge::save_mp(g_mp.path, g_mp.mp);
            g_mp.dirty = false;
            app().status = std::string("map saved: ") + g_mp.path;
        } catch (const std::exception& e) {
            app().status = e.what();
        }
    }
    ImGui::SameLine();
    if (ImGui::Button("Validate") && g_mp.loaded) {
        forge::MapReport rep = forge::validate(g_mp.mp);
        g_mp.report.clear();
        for (const std::string& s : rep.issues) g_mp.report.push_back("ISSUE: " + s);
        for (const std::string& s : rep.warnings) g_mp.report.push_back("warn: " + s);
        if (g_mp.report.empty()) g_mp.report.push_back("map OK");
        g_mp.report.push_back("land masses: " + std::to_string(rep.land_masses) +
                              ", oceans: " + std::to_string(rep.oceans));
    }
    if (!g_mp.loaded) {
        ImGui::TextDisabled("load a .MP map (byte-faithful: only the terrain "
                            "plane is edited, everything else round-trips)");
        ImGui::End();
        return;
    }

    // brush strip
    ImGui::SetNextItemWidth(100);
    ImGui::Combo("brush", &g_mp.brush, BRUSHES, 5);
    if (g_mp.brush == 0) {
        ImGui::SameLine();
        ImGui::SetNextItemWidth(190);
        if (ImGui::BeginCombo("##tid", (terrain_name(g_mp.terrain_id) + " (" +
                                        std::to_string(g_mp.terrain_id) + ")").c_str())) {
            for (int id = 0; id <= forge::MP_MAX_TERRAIN_ID; ++id)
                if (ImGui::Selectable((terrain_name(id) + " (" +
                                       std::to_string(id) + ")").c_str(),
                                      g_mp.terrain_id == id))
                    g_mp.terrain_id = id;
            ImGui::EndCombo();
        }
    }
    ImGui::SameLine();
    ImGui::TextDisabled("%dx%d | left-drag paints, right-click picks", g_mp.mp.w,
                        g_mp.mp.h);
    if (!g_mp.report.empty()) {
        ImGui::BeginChild("rep", ImVec2(0, 60), ImGuiChildFlags_Borders);
        for (const std::string& s : g_mp.report) ImGui::TextWrapped("%s", s.c_str());
        ImGui::EndChild();
    }

    // the stage: full map texture in a scrollable child
    if (g_mp.tex_w != g_mp.img.w || g_mp.tex_h != g_mp.img.h) {
        g_mp.tex = drv.create_texture(g_mp.img.w, g_mp.img.h);   // old one leaks; rare
        g_mp.tex_w = g_mp.img.w;
        g_mp.tex_h = g_mp.img.h;
    }
    drv.update_texture(g_mp.tex, g_mp.img.rgb.data());
    ImGui::BeginChild("stage", ImVec2(0, 0), ImGuiChildFlags_Borders,
                      ImGuiWindowFlags_HorizontalScrollbar);
    ImVec2 origin = ImGui::GetCursorScreenPos();
    ImGui::Image((ImTextureID)(intptr_t)g_mp.tex.id,
                 ImVec2((float)g_mp.img.w, (float)g_mp.img.h));
    if (ImGui::IsItemHovered()) {
        ImVec2 mp = ImGui::GetMousePos();
        int tx = (int)((mp.x - origin.x) / 16), ty = (int)((mp.y - origin.y) / 16);
        if (g_mp.mp.in_bounds(tx, ty)) {
            ImGui::SetTooltip("(%d,%d) %s%s%s", tx, ty,
                              terrain_name(g_mp.mp.terrain_id(tx, ty)).c_str(),
                              g_mp.mp.has_river(tx, ty) ? " +river" : "",
                              g_mp.mp.has_forest(tx, ty) ? " +forest" : "");
            if (ImGui::IsMouseDown(0)) {
                if (tx != g_mp.last_tx || ty != g_mp.last_ty ||
                    ImGui::IsMouseClicked(0)) {
                    paint(tx, ty);
                    g_mp.last_tx = tx;
                    g_mp.last_ty = ty;
                }
            } else {
                g_mp.last_tx = g_mp.last_ty = -1;
            }
            if (ImGui::IsMouseClicked(1)) {          // eyedropper
                g_mp.terrain_id = g_mp.mp.terrain_id(tx, ty);
                g_mp.brush = 0;
                app().status = "picked " + terrain_name(g_mp.terrain_id);
            }
        }
    }
    ImGui::EndChild();
    ImGui::End();
}

} // namespace studio
