// panel_popups.cpp -- test + edit the 499 GAME.TXT message records (msge)
// through the native popup frame engine (popup_render.cpp, popups.md §2).
//
// Left: searchable record list. Right: the popup rendered live over a dimmed
// stage with test inputs for the %NUMBER/%STRING fill slots, the IND tribe
// channel, and optional choice rows (choices come from the event graphs at
// runtime, so the tester lets you type test rows). Edits (text, box, sprite,
// speaker) go through the store chokepoint -- journaled, undoable, saved to
// the project with Ctrl+S like every other record.
#include "studio_shared.hpp"
#include "imgui.h"
#include "drydock_api.hpp"
#include "../drydock/core/store.hpp"
#include "popup_render.hpp"
#include <cstring>
#include <string>
#include <vector>

using drydock::Record;
using drydock::Store;
using drydock::ValKind;
using drydock::Value;

namespace studio {
namespace {

std::string fstr(const Record& r, const char* name) {
    for (const auto& f : r.fields)
        if (f.name == name && (f.value.kind == ValKind::Str ||
                               f.value.kind == ValKind::Token))
            return f.value.s;
    return "";
}
long long fint(const Record& r, const char* name, long long dflt) {
    for (const auto& f : r.fields)
        if (f.name == name && f.value.kind == ValKind::Int) return f.value.i;
    return dflt;
}

void commit(const std::string& id, const char* field, const Value& v) {
    Store* st = forge::drydock_store();
    std::string err;
    if (!drydock::store_set(*st, id, field, &v, err))
        app().status = "edit rejected: " + err;
    else
        app().status = id + "." + std::string(field) + " set";
}

void replace_all(std::string& s, const std::string& from, const std::string& to) {
    size_t p = 0;
    while ((p = s.find(from, p)) != std::string::npos) {
        s.replace(p, from.size(), to);
        p += to.size();
    }
}

struct PopupsState {
    char search[64] = {0};
    std::string sel;
    // fill slots
    int num0 = 12, num1 = 3, tribe = 0;
    char str0[64] = "Jamestown", str1[64] = "Plymouth", str2[64] = "Cortes";
    char choices[256] = "";
    // editor buffers (reloaded when the selection changes)
    std::string loaded_for;
    char text[2048] = {0};
    // live preview
    Texture stage{};
    int hover = -1;
};
PopupsState g_pp;

// speaker channel -> contact-sheet name (popups.md §2.7; tribe feeds IND)
std::string speaker_sheet(const std::string& speaker, int tribe) {
    if (speaker == "KING1") return "KING1";
    if (speaker == "IND")   return "IND" + std::to_string(tribe) + "A0";
    if (speaker == "MYR")   return "MYR0";
    if (speaker.rfind("MSS", 0) == 0) return speaker;
    return "";
}

// msge.sprite holds a catalog sid ("woodcut.wdcut04") -> the sprt record's sheet
std::string sid_sheet(Store& st, const std::string& sid) {
    auto ti = st.type_index.find("sprt");
    if (ti == st.type_index.end()) return "";
    for (const Record& r : st.records[ti->second])
        if (fstr(r, "sid") == sid) return fstr(r, "sheet");
    return "";
}

}  // namespace

void popups_panel(Driver& drv) {
    ImGui::Begin("Popups");
    Store* st = forge::drydock_store();
    if (!st) { ImGui::TextDisabled("record store not loaded"); ImGui::End(); return; }
    if (!assets_ensure()) {
        ImGui::TextWrapped("assets: %s", assets().err.c_str());
        ImGui::End();
        return;
    }
    auto ti = st->type_index.find("msge");
    if (ti == st->type_index.end()) {
        ImGui::TextDisabled("no msge records");
        ImGui::End();
        return;
    }
    const std::vector<Record>& recs = st->records[ti->second];

    // headless/CI hook: FORGE_POPUP=@KEY preselects a message (screenshots)
    if (g_pp.sel.empty()) {
        static const char* pre = std::getenv("FORGE_POPUP");
        if (pre) {
            for (const Record& r : recs)
                if (fstr(r, "key") == pre) { g_pp.sel = r.id; break; }
            pre = nullptr;
        }
    }

    // ---- left: record list
    ImGui::BeginChild("list", ImVec2(220, 0), ImGuiChildFlags_ResizeX);
    ImGui::SetNextItemWidth(-1);
    ImGui::InputTextWithHint("##q", "search key/text", g_pp.search, sizeof g_pp.search);
    ImGui::BeginChild("keys");
    for (const Record& r : recs) {
        if (g_pp.search[0]) {
            std::string hay = fstr(r, "key") + " " + fstr(r, "text");
            std::string needle = g_pp.search;
            for (auto& c : hay) c = (char)tolower(c);
            for (auto& c : needle) c = (char)tolower(c);
            if (hay.find(needle) == std::string::npos) continue;
        }
        bool dirty = st->dirty.count(r.id) > 0;
        if (dirty) ImGui::PushStyleColor(ImGuiCol_Text, IM_COL32(255, 200, 90, 255));
        if (ImGui::Selectable(fstr(r, "key").c_str(), g_pp.sel == r.id)) {
            g_pp.sel = r.id;
            select_record(r.id);
        }
        if (dirty) ImGui::PopStyleColor();
    }
    ImGui::EndChild();
    ImGui::EndChild();
    ImGui::SameLine();

    // ---- right: preview + tester + editor
    ImGui::BeginChild("view");
    const Record* rec = g_pp.sel.empty() ? nullptr : drydock::store_find(*st, g_pp.sel);
    if (!rec) {
        ImGui::TextDisabled("select a message");
        ImGui::EndChild();
        ImGui::End();
        return;
    }
    if (g_pp.loaded_for != rec->id) {   // (re)load editor buffers
        g_pp.loaded_for = rec->id;
        std::snprintf(g_pp.text, sizeof g_pp.text, "%s", fstr(*rec, "text").c_str());
        g_pp.hover = -1;
    }

    // fill the %slots, split lines
    std::string body = g_pp.text;      // preview follows the edit buffer live
    replace_all(body, "%NUMBER0", std::to_string(g_pp.num0));
    replace_all(body, "%NUMBER1", std::to_string(g_pp.num1));
    replace_all(body, "%STRING0", g_pp.str0);
    replace_all(body, "%STRING1", g_pp.str1);
    replace_all(body, "%STRING2", g_pp.str2);
    vc::PopupSpec spec;
    {
        std::string cur;
        for (char c : body) {
            if (c == '\r') continue;
            if (c == '\n') { spec.lines.push_back(cur); cur.clear(); }
            else cur += c;
        }
        spec.lines.push_back(cur);
        cur.clear();
        for (const char* p = g_pp.choices; *p; ++p) {
            if (*p == '\n') { if (!cur.empty()) spec.choices.push_back(cur); cur.clear(); }
            else if (*p != '\r') cur += *p;
        }
        if (!cur.empty()) spec.choices.push_back(cur);
    }
    spec.box_w = (int)fint(*rec, "box_w", 0);
    spec.px = (int)fint(*rec, "x", -1);
    spec.py = (int)fint(*rec, "y", -1);
    int defi = std::atoi(fstr(*rec, "default").c_str()) - 1;   // 1-based @default
    spec.highlight = g_pp.hover >= 0 ? g_pp.hover
                     : (defi >= 0 && defi < (int)spec.choices.size() ? defi : -1);
    std::string spk = speaker_sheet(fstr(*rec, "speaker"), g_pp.tribe);
    if (!spk.empty()) spec.portrait = sheet_window(spk);
    std::string scene_sheet = sid_sheet(*st, fstr(*rec, "sprite"));
    if (!scene_sheet.empty()) spec.scene = sheet_window(scene_sheet);

    // compose the stage
    vc::Surface scr;
    scr.set_palette(assets().nat.pal);
    scr.clear(0);
    for (int y = 0; y < vc::Surface::H; ++y)      // dimmed checker stage
        for (int x = 0; x < vc::Surface::W; ++x)
            if (((x >> 3) + (y >> 3)) & 1) scr.put(x, y, 0x1F);
    vc::PopupLayout L = vc::popup_layout(assets().nat.font, spec);
    static const vc::IndexedPng no_panl;
    const vc::IndexedPng* panl = atlas_file("pik/WOODPANL.png");
    render_popup(scr, panl ? *panl : no_panl, assets().nat.font, spec, L);

    if (!g_pp.stage.id) g_pp.stage = drv.create_texture(vc::Surface::W, vc::Surface::H);
    vc::Image img = scr.to_rgb(1);
    drv.update_texture(g_pp.stage, img.rgb.data());

    float availw = ImGui::GetContentRegionAvail().x;
    float scale = stage_scale(availw);
    ImVec2 origin = ImGui::GetCursorScreenPos();
    pixel_image(g_pp.stage, ImVec2(vc::Surface::W * scale, vc::Surface::H * scale));
    // choice hover/click on the stage
    g_pp.hover = -1;
    if (ImGui::IsItemHovered()) {
        ImVec2 mp = ImGui::GetMousePos();
        int mx = (int)((mp.x - origin.x) / scale), my = (int)((mp.y - origin.y) / scale);
        for (int i = 0; i < (int)spec.choices.size(); ++i) {
            int cx, cy, cw, ch;
            vc::popup_choice_rect(L, i, cx, cy, cw, ch);
            if (mx >= cx && mx < cx + cw && my >= cy && my < cy + ch) {
                g_pp.hover = i;
                if (ImGui::IsMouseClicked(0))
                    app().status = "popup choice: " + spec.choices[i];
            }
        }
    }
    if (ImGui::IsWindowFocused() && ImGui::IsKeyPressed(ImGuiKey_Enter) &&
        defi >= 0 && defi < (int)spec.choices.size())
        app().status = "popup choice (default): " + spec.choices[defi];

    ImGui::TextDisabled("font: %s | box %d,%d %dx%d",
                        assets().nat.font_real
                            ? "FONTTINY.FF (game)"
                            : "baked 5x7 (add raw/COLONIZE/FONTTINY.FF for the game font)",
                        L.x, L.y, L.w, L.h);

    // ---- tester inputs
    if (ImGui::CollapsingHeader("Test fills", ImGuiTreeNodeFlags_DefaultOpen)) {
        ImGui::SetNextItemWidth(90);
        ImGui::InputInt("%NUMBER0", &g_pp.num0);
        ImGui::SameLine();
        ImGui::SetNextItemWidth(90);
        ImGui::InputInt("%NUMBER1", &g_pp.num1);
        ImGui::SetNextItemWidth(140);
        ImGui::InputText("%STRING0", g_pp.str0, sizeof g_pp.str0);
        ImGui::SameLine();
        ImGui::SetNextItemWidth(140);
        ImGui::InputText("%STRING1", g_pp.str1, sizeof g_pp.str1);
        ImGui::SetNextItemWidth(140);
        ImGui::InputText("%STRING2", g_pp.str2, sizeof g_pp.str2);
        if (fstr(*rec, "speaker") == "IND") {
            ImGui::SetNextItemWidth(140);
            ImGui::SliderInt("tribe (IND channel)", &g_pp.tribe, 0, 7);
        }
        ImGui::InputTextMultiline("test choices\n(one per line)", g_pp.choices,
                                  sizeof g_pp.choices, ImVec2(240, 52));
    }

    // ---- record editor (chokepoint writes)
    if (ImGui::CollapsingHeader("Edit record", ImGuiTreeNodeFlags_DefaultOpen)) {
        ImGui::TextDisabled("%s", rec->id.c_str());
        ImGui::InputTextMultiline("##text", g_pp.text, sizeof g_pp.text,
                                  ImVec2(-1, 80));
        if (ImGui::Button("Apply text"))
            commit(rec->id, "text", Value::make_str(g_pp.text));
        ImGui::SameLine();
        if (ImGui::Button("Revert"))
            std::snprintf(g_pp.text, sizeof g_pp.text, "%s",
                          fstr(*rec, "text").c_str());
        int bw = (int)fint(*rec, "box_w", 0), bx = spec.px, by = spec.py;
        ImGui::SetNextItemWidth(90);
        if (ImGui::InputInt("box_w", &bw, 0, 0, ImGuiInputTextFlags_EnterReturnsTrue))
            commit(rec->id, "box_w", Value::make_int(bw));
        ImGui::SameLine();
        ImGui::SetNextItemWidth(90);
        if (ImGui::InputInt("x", &bx, 0, 0, ImGuiInputTextFlags_EnterReturnsTrue))
            commit(rec->id, "x", Value::make_int(bx));
        ImGui::SameLine();
        ImGui::SetNextItemWidth(90);
        if (ImGui::InputInt("y", &by, 0, 0, ImGuiInputTextFlags_EnterReturnsTrue))
            commit(rec->id, "y", Value::make_int(by));
        char sbuf[64], kbuf[64];
        std::snprintf(sbuf, sizeof sbuf, "%s", fstr(*rec, "sprite").c_str());
        std::snprintf(kbuf, sizeof kbuf, "%s", fstr(*rec, "speaker").c_str());
        ImGui::SetNextItemWidth(200);
        if (ImGui::InputText("sprite (catalog sid)", sbuf, sizeof sbuf,
                             ImGuiInputTextFlags_EnterReturnsTrue))
            commit(rec->id, "sprite", Value::make_str(sbuf));
        ImGui::SetNextItemWidth(200);
        if (ImGui::InputText("speaker (KING1/IND/MSSn/MYR)", kbuf, sizeof kbuf,
                             ImGuiInputTextFlags_EnterReturnsTrue))
            commit(rec->id, "speaker", Value::make_str(kbuf));
    }
    ImGui::EndChild();
    ImGui::End();
}

} // namespace studio
