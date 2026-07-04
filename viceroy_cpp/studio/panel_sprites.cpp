// panel_sprites.cpp -- the sprite-catalog browser (every sprt record, drawn
// from the real sheets). Selecting a sprite also selects its record, so the
// Inspector edits labels/fields through the store chokepoint as usual.
#include "studio_shared.hpp"
#include "imgui.h"
#include "drydock_api.hpp"
#include "../drydock/core/store.hpp"
#include <cmath>
#include <cstring>
#include <vector>

using drydock::Record;
using drydock::Store;
using drydock::ValKind;

namespace studio {
namespace {

std::string field_str(const Record& r, const char* name) {
    for (const auto& f : r.fields)
        if (f.name == name && (f.value.kind == ValKind::Str ||
                               f.value.kind == ValKind::Token))
            return f.value.s;
    return "";
}
long long field_int(const Record& r, const char* name, long long dflt) {
    for (const auto& f : r.fields)
        if (f.name == name && f.value.kind == ValKind::Int) return f.value.i;
    return dflt;
}

const char* KINDS[] = {"all", "terrain", "overlay", "unit", "building",
                       "icon",  "woodcut", "portrait", "background"};

struct SpritesState {
    int kind = 0;              // KINDS index
    char search[64] = {0};
    std::string sel;           // selected sprt record id
    float zoom = 4.0f;
};
SpritesState g_sp;

}  // namespace

void sprites_panel(Driver& drv) {
    ImGui::Begin("Sprites");
    Store* st = forge::drydock_store();
    if (!st) { ImGui::TextDisabled("record store not loaded"); ImGui::End(); return; }
    if (!assets_ensure()) {
        ImGui::TextWrapped("assets: %s", assets().err.c_str());
        ImGui::End();
        return;
    }
    auto ti = st->type_index.find("sprt");
    if (ti == st->type_index.end()) {
        ImGui::TextDisabled("no sprt records");
        ImGui::End();
        return;
    }
    const std::vector<Record>& recs = st->records[ti->second];

    // toolbar: kind filter + search + zoom
    ImGui::SetNextItemWidth(120);
    if (ImGui::BeginCombo("##kind", KINDS[g_sp.kind])) {
        for (int i = 0; i < (int)(sizeof KINDS / sizeof *KINDS); ++i)
            if (ImGui::Selectable(KINDS[i], g_sp.kind == i)) g_sp.kind = i;
        ImGui::EndCombo();
    }
    ImGui::SameLine();
    ImGui::SetNextItemWidth(160);
    ImGui::InputTextWithHint("##q", "search", g_sp.search, sizeof g_sp.search);
    ImGui::SameLine();
    ImGui::SetNextItemWidth(120);
    ImGui::SliderFloat("zoom", &g_sp.zoom, 1.0f, 8.0f, "%.0fx");

    // filtered list
    std::vector<const Record*> shown;
    shown.reserve(recs.size());
    for (const Record& r : recs) {
        if (g_sp.kind != 0 && field_str(r, "kind") != KINDS[g_sp.kind]) continue;
        if (g_sp.search[0]) {
            std::string hay = r.id + " " + field_str(r, "label");
            std::string needle = g_sp.search;
            for (auto& c : hay) c = (char)tolower(c);
            for (auto& c : needle) c = (char)tolower(c);
            if (hay.find(needle) == std::string::npos) continue;
        }
        shown.push_back(&r);
    }
    ImGui::TextDisabled("%zu sprites", shown.size());

    // grid (left) + preview (right)
    const float cell = 56.0f;
    ImGui::BeginChild("grid", ImVec2(ImGui::GetContentRegionAvail().x * 0.62f, 0),
                      ImGuiChildFlags_Borders);
    int cols = (int)(ImGui::GetContentRegionAvail().x / (cell + 6));
    if (cols < 1) cols = 1;
    for (int i = 0; i < (int)shown.size(); ++i) {
        const Record& r = *shown[i];
        if (i % cols) ImGui::SameLine();
        ImGui::PushID(r.id.c_str());
        ImVec2 pos = ImGui::GetCursorScreenPos();
        bool selected = g_sp.sel == r.id;
        if (ImGui::Selectable("##cell", selected, 0, ImVec2(cell, cell))) {
            g_sp.sel = r.id;
            select_record(r.id);
        }
        if (ImGui::IsItemHovered()) {
            ImGui::SetTooltip("%s\n%s", field_str(r, "label").c_str(), r.id.c_str());
        }
        int nw = 0, nh = 0;
        Texture* tex = static_texture(drv, "sprt:" + r.id, [&](vc::Image& img) {
            return sprite_image(r, img, &nw, &nh);
        });
        if (tex) {
            float s = cell / (float)(tex->w > tex->h ? tex->w : tex->h);
            if (s > 3.0f) s = std::floor(s) > 3.0f ? 3.0f : std::floor(s);
            ImVec2 sz(tex->w * s, tex->h * s);
            ImVec2 at(pos.x + (cell - sz.x) / 2, pos.y + (cell - sz.y) / 2);
            ImDrawList* dl = ImGui::GetWindowDrawList();
            ImGuiPlatformIO& pio = ImGui::GetPlatformIO();
            if (pio.DrawCallback_SetSamplerNearest)
                dl->AddCallback(pio.DrawCallback_SetSamplerNearest, nullptr);
            dl->AddImage((ImTextureID)(intptr_t)tex->id,
                         at, ImVec2(at.x + sz.x, at.y + sz.y));
            if (pio.DrawCallback_SetSamplerLinear)
                dl->AddCallback(pio.DrawCallback_SetSamplerLinear, nullptr);
        } else {
            ImGui::GetWindowDrawList()->AddText(pos, IM_COL32(160, 90, 90, 255), "?");
        }
        ImGui::PopID();
    }
    ImGui::EndChild();

    // preview pane
    ImGui::SameLine();
    ImGui::BeginChild("preview", ImVec2(0, 0), ImGuiChildFlags_Borders);
    const Record* sel = nullptr;
    for (const Record* r : shown)
        if (r->id == g_sp.sel) { sel = r; break; }
    if (!sel && !g_sp.sel.empty()) sel = drydock::store_find(*st, g_sp.sel);
    if (sel) {
        ImGui::Text("%s", field_str(*sel, "label").c_str());
        ImGui::TextDisabled("%s", sel->id.c_str());
        Texture* tex = static_texture(drv, "sprt:" + sel->id, [&](vc::Image& img) {
            return sprite_image(*sel, img);
        });
        if (tex) {
            float z = std::floor(g_sp.zoom);
            float availw = ImGui::GetContentRegionAvail().x - 8;
            while (z > 1 && tex->w * z > availw) --z;
            pixel_image(*tex, ImVec2(tex->w * z, tex->h * z));
            ImGui::TextDisabled("%dx%d px", tex->w, tex->h);
        } else {
            ImGui::TextDisabled("(no image -- sheet/frame unresolved)");
        }
        ImGui::Separator();
        ImGui::TextDisabled("kind  %s", field_str(*sel, "kind").c_str());
        ImGui::TextDisabled("sheet %s", field_str(*sel, "sheet").c_str());
        long long fr = field_int(*sel, "frame", -1);
        if (fr >= 0) ImGui::TextDisabled("frame %lld", fr);
        std::string file = field_str(*sel, "file");
        if (!file.empty()) ImGui::TextDisabled("file  %s", file.c_str());
        ImGui::Spacing();
        ImGui::TextWrapped("Edit the label/fields in the Inspector "
                           "(this sprite's record is selected there).");
    } else {
        ImGui::TextDisabled("select a sprite");
    }
    ImGui::EndChild();
    ImGui::End();
}

} // namespace studio
