// panel_screens.cpp -- the native screen designer over the DLOG records.
//
// A screen record is { name, background, size, widgets[] } where widgets are
// dicts: { id, type: text|sprite|button, rect:[x,y,w,h], color:"r,g,b",
// text, sheet, frame, onClick }. The panel renders the screen live on the
// 320x200 indexed surface (real PIK background + real sheets + FONTTINY),
// resolves {binding} spans against the running game when one is active,
// and edits widgets by click-select + drag-move + a property strip -- every
// mutation rebuilds the record's `widgets` list through store_set (journaled,
// undoable, Ctrl+S saves).
#include "studio_shared.hpp"
#include "imgui.h"
#include "drydock_api.hpp"
#include "../drydock/core/store.hpp"
#include "popup_render.hpp"     // nearest_pal_index
#include "engine.hpp"           // resolve_binding (live {path} values)
#include "session.hpp"          // the game session globals
#include <cstring>
#include <string>
#include <vector>

using drydock::Record;
using drydock::Store;
using drydock::ValKind;
using drydock::Value;

namespace studio {
namespace {

std::string dstr(const Value& d, const char* key, const std::string& dflt = "") {
    const Value* v = d.dict_get(key);
    return v && (v->kind == ValKind::Str || v->kind == ValKind::Token) ? v->s : dflt;
}
long long dint(const Value& d, const char* key, long long dflt) {
    const Value* v = d.dict_get(key);
    return v && v->kind == ValKind::Int ? v->i : dflt;
}
void drect(const Value& d, int r[4]) {
    r[0] = r[1] = 0; r[2] = 40; r[3] = 8;
    const Value* v = d.dict_get("rect");
    if (v && v->kind == ValKind::List)
        for (int i = 0; i < 4 && i < (int)v->list.size(); ++i)
            if (v->list[i].kind == ValKind::Int) r[i] = (int)v->list[i].i;
}
std::string rstr(const Record& r, const char* name, const std::string& dflt = "") {
    for (const auto& f : r.fields)
        if (f.name == name && (f.value.kind == ValKind::Str ||
                               f.value.kind == ValKind::Token))
            return f.value.s;
    return dflt;
}
const Value* rwidgets(const Record& r) {
    for (const auto& f : r.fields)
        if (f.name == "widgets" && f.value.kind == ValKind::List) return &f.value;
    return nullptr;
}

// "r,g,b" -> nearest palette index (the records store web-era RGB strings)
uint8_t color_idx(const uint8_t pal[768], const std::string& s, uint8_t dflt) {
    int r, g, b;
    if (std::sscanf(s.c_str(), "%d,%d,%d", &r, &g, &b) != 3) return dflt;
    return vc::nearest_pal_index(pal, r, g, b);
}

// Substitute {path} spans against the live session (raw path when inactive).
std::string resolve_text(const std::string& s) {
    std::string out;
    size_t i = 0;
    while (i < s.size()) {
        if (s[i] != '{') { out += s[i++]; continue; }
        size_t j = s.find('}', i);
        if (j == std::string::npos) { out += s.substr(i); break; }
        std::string path = s.substr(i + 1, j - i - 1);
        if (app().game_active) {
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra,
                                g_active_rules, game_rng};
            forge::JsonValue v = forge::resolve_binding(path, cx);
            if (v.type == forge::JsonValue::Number) {
                double n = v.num;
                if (n == (long long)n) out += std::to_string((long long)n);
                else { char b[32]; std::snprintf(b, sizeof b, "%g", n); out += b; }
            } else if (v.type == forge::JsonValue::String) {
                out += v.str;
            } else {
                out += "{" + path + "}";
            }
        } else {
            out += "{" + path + "}";
        }
        i = j + 1;
    }
    return out;
}

struct ScreensState {
    std::string sel;             // dlog record id
    int sel_w = -1;              // selected widget index
    Texture stage{};
    bool dragging = false;
    int drag_dx = 0, drag_dy = 0;
    // property buffers (loaded on widget select)
    std::string loaded_for;
    int loaded_w = -2;
    char wid[64] = {0}, wtext[512] = {0}, wcolor[24] = {0};
    char wsheet[24] = {0}, wclick[64] = {0};
    int wrect[4] = {0, 0, 40, 8};
    int wframe = 0;
    int wtype = 0;               // 0 text, 1 sprite, 2 button
    char new_id[48] = {0};
};
ScreensState g_sc;
const char* WTYPES[] = {"text", "sprite", "button"};

// Rebuild the whole widgets list with `mut` applied and store_set it.
void commit_widgets(const Record& rec,
                    const std::function<void(std::vector<Value>&)>& mut) {
    const Value* w = rwidgets(rec);
    std::vector<Value> list = w ? w->list : std::vector<Value>{};
    mut(list);
    Value nv = Value::make_list(std::move(list));
    Store* st = forge::drydock_store();
    std::string err;
    if (!drydock::store_set(*st, rec.id, "widgets", &nv, err))
        app().status = "edit rejected: " + err;
}

Value widget_from_buffers() {
    Value d = Value::make_dict();
    d.dict_put("id", Value::make_str(g_sc.wid));
    d.dict_put("type", Value::make_str(WTYPES[g_sc.wtype]));
    std::vector<Value> rr;
    for (int i = 0; i < 4; ++i) rr.push_back(Value::make_int(g_sc.wrect[i]));
    d.dict_put("rect", Value::make_list(std::move(rr)));
    if (g_sc.wtype == 1) {
        d.dict_put("sheet", Value::make_str(g_sc.wsheet));
        d.dict_put("frame", Value::make_int(g_sc.wframe));
    } else {
        d.dict_put("color", Value::make_str(g_sc.wcolor[0] ? g_sc.wcolor
                                                           : "255,255,255"));
        d.dict_put("text", Value::make_str(g_sc.wtext));
    }
    if (g_sc.wclick[0]) d.dict_put("onClick", Value::make_str(g_sc.wclick));
    return d;
}

void load_widget_buffers(const Value& d) {
    std::snprintf(g_sc.wid, sizeof g_sc.wid, "%s", dstr(d, "id").c_str());
    std::snprintf(g_sc.wtext, sizeof g_sc.wtext, "%s", dstr(d, "text").c_str());
    std::snprintf(g_sc.wcolor, sizeof g_sc.wcolor, "%s",
                  dstr(d, "color", "255,255,255").c_str());
    std::snprintf(g_sc.wsheet, sizeof g_sc.wsheet, "%s",
                  dstr(d, "sheet", "ICONS").c_str());
    std::snprintf(g_sc.wclick, sizeof g_sc.wclick, "%s", dstr(d, "onClick").c_str());
    drect(d, g_sc.wrect);
    g_sc.wframe = (int)dint(d, "frame", 0);
    std::string t = dstr(d, "type", "text");
    g_sc.wtype = t == "sprite" ? 1 : t == "button" ? 2 : 0;
}

}  // namespace

void screens_panel(Driver& drv) {
    ImGui::Begin("Screens");
    Store* st = forge::drydock_store();
    if (!st) { ImGui::TextDisabled("record store not loaded"); ImGui::End(); return; }
    if (!assets_ensure()) {
        ImGui::TextWrapped("assets: %s", assets().err.c_str());
        ImGui::End();
        return;
    }
    auto ti = st->type_index.find("dlog");
    if (ti == st->type_index.end()) {
        ImGui::TextDisabled("no dlog records");
        ImGui::End();
        return;
    }

    // headless/CI hook: FORGE_SCREEN=dlog.<id> preselects a screen (screenshots)
    if (g_sc.sel.empty()) {
        static const char* pre = std::getenv("FORGE_SCREEN");
        if (pre) {
            if (drydock::store_find(*st, pre)) g_sc.sel = pre;
            pre = nullptr;
        }
    }

    // ---- left: screen list + create
    ImGui::BeginChild("list", ImVec2(180, 0), ImGuiChildFlags_ResizeX);
    for (const Record& r : st->records[ti->second]) {
        bool dirty = st->dirty.count(r.id) > 0;
        if (dirty) ImGui::PushStyleColor(ImGuiCol_Text, IM_COL32(255, 200, 90, 255));
        if (ImGui::Selectable(r.id.c_str(), g_sc.sel == r.id)) {
            g_sc.sel = r.id;
            g_sc.sel_w = -1;
            select_record(r.id);
        }
        if (dirty) ImGui::PopStyleColor();
    }
    ImGui::Separator();
    ImGui::SetNextItemWidth(-1);
    ImGui::InputTextWithHint("##nid", "new screen id", g_sc.new_id, sizeof g_sc.new_id);
    if (ImGui::Button("New Screen", ImVec2(-1, 0)) && g_sc.new_id[0]) {
        Record nr;
        nr.id = std::string("dlog.") + g_sc.new_id;
        nr.fields.push_back({"name", Value::make_str(g_sc.new_id)});
        nr.fields.push_back({"background", Value::make_str("")});
        std::vector<Value> sz{Value::make_int(320), Value::make_int(200)};
        nr.fields.push_back({"size", Value::make_list(std::move(sz))});
        nr.fields.push_back({"widgets", Value::make_list({})});
        std::string err;
        if (!drydock::store_add(*st, nr, err)) app().status = "add rejected: " + err;
        else { g_sc.sel = nr.id; g_sc.sel_w = -1; g_sc.new_id[0] = 0; }
    }
    ImGui::EndChild();
    ImGui::SameLine();

    // ---- right: stage + properties
    ImGui::BeginChild("view");
    const Record* rec = g_sc.sel.empty() ? nullptr : drydock::store_find(*st, g_sc.sel);
    if (!rec) {
        ImGui::TextDisabled("select a screen");
        ImGui::EndChild();
        ImGui::End();
        return;
    }
    const Value* widgets = rwidgets(*rec);
    const int nwidgets = widgets ? (int)widgets->list.size() : 0;

    // compose the screen
    vc::Surface scr;
    scr.set_palette(assets().nat.pal);
    scr.clear(0);
    std::string bg = rstr(*rec, "background");
    if (!bg.empty())
        if (const vc::IndexedPng* pik = atlas_file("pik/" + bg + ".png"))
            scr.blit_region(*pik, 0, 0, pik->w, pik->h, 0, 0);
    for (int i = 0; i < nwidgets; ++i) {
        const Value& d = widgets->list[i];
        if (d.kind != ValKind::Dict) continue;
        int r[4];
        drect(d, r);
        std::string type = dstr(d, "type", "text");
        if (type == "sprite") {
            if (const vc::Sheet* sh = tileset_sheet(dstr(d, "sheet"))) {
                int fi = (int)dint(d, "frame", 0);
                if (fi >= 0 && fi < sh->nframes)
                    scr.blit_frame(sh->frames[fi], r[0], r[1]);
            }
        } else {
            uint8_t col = color_idx(assets().nat.pal, dstr(d, "color"), 15);
            std::string text = resolve_text(dstr(d, "text"));
            if (type == "button") {
                // wood-tile button face + outline (the DLOG buttons are the
                // editor-era chrome; native menus draw their own plates)
                for (int y = r[1]; y < r[1] + r[3]; ++y)
                    for (int x = r[0]; x < r[0] + r[2]; ++x) {
                        const vc::Frame& t = assets().nat.woodtile.frames[0];
                        if (t.w > 0)
                            scr.put(x, y, t.px[(size_t)(y % t.h) * t.w + (x % t.w)]);
                    }
                scr.rect_outline(r[0], r[1], r[2], r[3], col);
                int tw = scr.text_width(assets().nat.font, text);
                scr.draw_text(assets().nat.font, r[0] + (r[2] - tw) / 2,
                              r[1] + (r[3] - 7) / 2 + 1, text, col);
            } else {
                scr.draw_text(assets().nat.font, r[0], r[1], text, col);
            }
        }
        if (i == g_sc.sel_w)     // selection flash
            if (((int)(ImGui::GetTime() * 3)) & 1)
                scr.rect_outline(r[0] - 1, r[1] - 1, r[2] + 2, r[3] + 2, 15);
    }

    if (!g_sc.stage.id) g_sc.stage = drv.create_texture(vc::Surface::W, vc::Surface::H);
    vc::Image img = scr.to_rgb(1);
    drv.update_texture(g_sc.stage, img.rgb.data());

    float availw = ImGui::GetContentRegionAvail().x;
    float scale = availw / vc::Surface::W;
    if (scale > 2.5f) scale = 2.5f;
    if (scale < 1.0f) scale = 1.0f;
    ImVec2 origin = ImGui::GetCursorScreenPos();
    ImGui::Image((ImTextureID)(intptr_t)g_sc.stage.id,
                 ImVec2(vc::Surface::W * scale, vc::Surface::H * scale));

    // select on click, move by drag (commit on release)
    if (ImGui::IsItemHovered() || g_sc.dragging) {
        ImVec2 mp = ImGui::GetMousePos();
        int mx = (int)((mp.x - origin.x) / scale), my = (int)((mp.y - origin.y) / scale);
        if (ImGui::IsMouseClicked(0) && ImGui::IsItemHovered()) {
            int hit = -1;
            for (int i = nwidgets - 1; i >= 0; --i) {   // topmost first
                const Value& d = widgets->list[i];
                if (d.kind != ValKind::Dict) continue;
                int r[4];
                drect(d, r);
                if (mx >= r[0] && mx < r[0] + r[2] && my >= r[1] && my < r[1] + r[3]) {
                    hit = i;
                    break;
                }
            }
            g_sc.sel_w = hit;
            if (hit >= 0) {
                int r[4];
                drect(widgets->list[hit], r);
                g_sc.dragging = true;
                g_sc.drag_dx = mx - r[0];
                g_sc.drag_dy = my - r[1];
            }
        }
        if (g_sc.dragging && g_sc.sel_w >= 0 && g_sc.sel_w < nwidgets) {
            if (ImGui::IsMouseDown(0)) {
                // live-move via the buffers; committed on release
                g_sc.wrect[0] = mx - g_sc.drag_dx;
                g_sc.wrect[1] = my - g_sc.drag_dy;
            } else {
                g_sc.dragging = false;
                int nx = mx - g_sc.drag_dx, ny = my - g_sc.drag_dy;
                if (nx < 0) nx = 0;
                if (ny < 0) ny = 0;
                commit_widgets(*rec, [&](std::vector<Value>& list) {
                    if (g_sc.sel_w >= (int)list.size()) return;
                    Value& d = list[g_sc.sel_w];
                    int r[4];
                    drect(d, r);
                    std::vector<Value> rr{Value::make_int(nx), Value::make_int(ny),
                                          Value::make_int(r[2]), Value::make_int(r[3])};
                    for (size_t k = 0; k < d.keys.size(); ++k)
                        if (d.keys[k] == "rect") { d.list[k] = Value::make_list(rr); return; }
                    d.dict_put("rect", Value::make_list(rr));
                });
                g_sc.loaded_w = -2;   // force property reload
            }
        }
    }

    // drag preview: draw the moving rect over the image (screen coords)
    if (g_sc.dragging && g_sc.sel_w >= 0) {
        ImVec2 a(origin.x + g_sc.wrect[0] * scale, origin.y + g_sc.wrect[1] * scale);
        ImVec2 b(a.x + g_sc.wrect[2] * scale, a.y + g_sc.wrect[3] * scale);
        ImGui::GetWindowDrawList()->AddRect(a, b, IM_COL32(255, 255, 120, 255));
    }

    // ---- widget strip: list + reorder + add/delete
    ImGui::BeginChild("wlist", ImVec2(190, 0), ImGuiChildFlags_Borders);
    ImGui::TextDisabled("widgets");
    for (int i = 0; i < nwidgets; ++i) {
        const Value& d = widgets->list[i];
        std::string label = std::to_string(i) + " " + dstr(d, "id", "?") + " (" +
                            dstr(d, "type", "text") + ")";
        if (ImGui::Selectable(label.c_str(), g_sc.sel_w == i)) g_sc.sel_w = i;
    }
    ImGui::Separator();
    if (ImGui::Button("+ text")) {
        commit_widgets(*rec, [&](std::vector<Value>& list) {
            Value d = Value::make_dict();
            d.dict_put("id", Value::make_str("w" + std::to_string(nwidgets)));
            d.dict_put("type", Value::make_str("text"));
            std::vector<Value> rr{Value::make_int(10), Value::make_int(10),
                                  Value::make_int(80), Value::make_int(8)};
            d.dict_put("rect", Value::make_list(std::move(rr)));
            d.dict_put("color", Value::make_str("255,255,255"));
            d.dict_put("text", Value::make_str("new text"));
            list.push_back(std::move(d));
        });
        g_sc.sel_w = nwidgets;
        g_sc.loaded_w = -2;
    }
    ImGui::SameLine();
    if (ImGui::Button("+ sprite")) {
        commit_widgets(*rec, [&](std::vector<Value>& list) {
            Value d = Value::make_dict();
            d.dict_put("id", Value::make_str("w" + std::to_string(nwidgets)));
            d.dict_put("type", Value::make_str("sprite"));
            std::vector<Value> rr{Value::make_int(10), Value::make_int(24),
                                  Value::make_int(16), Value::make_int(16)};
            d.dict_put("rect", Value::make_list(std::move(rr)));
            d.dict_put("sheet", Value::make_str("ICONS"));
            d.dict_put("frame", Value::make_int(22));
            list.push_back(std::move(d));
        });
        g_sc.sel_w = nwidgets;
        g_sc.loaded_w = -2;
    }
    bool have_sel = g_sc.sel_w >= 0 && g_sc.sel_w < nwidgets;
    if (have_sel) {
        if (ImGui::Button("up") && g_sc.sel_w > 0) {
            commit_widgets(*rec, [&](std::vector<Value>& list) {
                std::swap(list[g_sc.sel_w], list[g_sc.sel_w - 1]);
            });
            --g_sc.sel_w;
            g_sc.loaded_w = -2;
        }
        ImGui::SameLine();
        if (ImGui::Button("down") && g_sc.sel_w + 1 < nwidgets) {
            commit_widgets(*rec, [&](std::vector<Value>& list) {
                std::swap(list[g_sc.sel_w], list[g_sc.sel_w + 1]);
            });
            ++g_sc.sel_w;
            g_sc.loaded_w = -2;
        }
        ImGui::SameLine();
        if (ImGui::Button("delete")) {
            commit_widgets(*rec, [&](std::vector<Value>& list) {
                if (g_sc.sel_w < (int)list.size())
                    list.erase(list.begin() + g_sc.sel_w);
            });
            g_sc.sel_w = -1;
            g_sc.loaded_w = -2;
        }
    }
    ImGui::EndChild();
    ImGui::SameLine();

    // ---- property editor for the selected widget
    ImGui::BeginChild("props", ImVec2(0, 0), ImGuiChildFlags_Borders);
    if (have_sel) {
        if (g_sc.loaded_for != rec->id || g_sc.loaded_w != g_sc.sel_w) {
            g_sc.loaded_for = rec->id;
            g_sc.loaded_w = g_sc.sel_w;
            load_widget_buffers(widgets->list[g_sc.sel_w]);
        }
        ImGui::TextDisabled("widget %d", g_sc.sel_w);
        ImGui::SetNextItemWidth(150);
        ImGui::InputText("id", g_sc.wid, sizeof g_sc.wid);
        ImGui::SetNextItemWidth(150);
        ImGui::Combo("type", &g_sc.wtype, WTYPES, 3);
        ImGui::SetNextItemWidth(220);
        ImGui::InputInt4("rect", g_sc.wrect);
        if (g_sc.wtype == 1) {
            ImGui::SetNextItemWidth(150);
            ImGui::InputText("sheet", g_sc.wsheet, sizeof g_sc.wsheet);
            ImGui::SetNextItemWidth(150);
            ImGui::InputInt("frame", &g_sc.wframe);
        } else {
            ImGui::SetNextItemWidth(150);
            ImGui::InputText("color r,g,b", g_sc.wcolor, sizeof g_sc.wcolor);
            ImGui::InputTextMultiline("text\n({path} binds)", g_sc.wtext,
                                      sizeof g_sc.wtext, ImVec2(-1, 44));
        }
        ImGui::SetNextItemWidth(150);
        ImGui::InputText("onClick", g_sc.wclick, sizeof g_sc.wclick);
        if (ImGui::Button("Apply widget")) {
            commit_widgets(*rec, [&](std::vector<Value>& list) {
                if (g_sc.sel_w < (int)list.size())
                    list[g_sc.sel_w] = widget_from_buffers();
            });
        }
        ImGui::SameLine();
        if (ImGui::Button("Revert##w")) g_sc.loaded_w = -2;
    } else {
        ImGui::TextDisabled("click a widget on the stage\n(or in the list) to edit it");
        if (!app().game_active)
            ImGui::TextWrapped("\nStart a game in the Game panel to see "
                               "{bindings} resolve to live values.");
    }
    ImGui::EndChild();
    ImGui::EndChild();
    ImGui::End();
}

} // namespace studio
