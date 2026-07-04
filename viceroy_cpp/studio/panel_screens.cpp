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
long long rint(const Record& r, const char* name, long long dflt) {
    for (const auto& f : r.fields)
        if (f.name == name && f.value.kind == ValKind::Int) return f.value.i;
    return dflt;
}
void commit_int(const Record& rec, const char* field, long long v) {
    Value nv = Value::make_int(v);
    Store* st = forge::drydock_store();
    std::string err;
    if (!drydock::store_set(*st, rec.id, field, &nv, err))
        app().status = "edit rejected: " + err;
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
    // play mode: buttons fire their onClick events against the live session
    bool play = false;
    forge::JsonValue play_graph;     // the running graph (kept for resume)
    bool play_popup = false;
    forge::JsonValue popup;          // {title, body, choices, node, _cache}
    int popup_hover = -1;
    Texture stage{};
    bool dragging = false;
    int drag_dx = 0, drag_dy = 0;
    // background drag (click empty stage area): live offsets until release
    bool bg_dragging = false;
    int bg_press_mx = 0, bg_press_my = 0, bg_start_x = 0, bg_start_y = 0;
    int bg_live_x = 0, bg_live_y = 0;
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
const char* WTYPES[] = {"text", "sprite", "button", "message"};

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
                                                           : "255,243,93"));
        d.dict_put("text", Value::make_str(g_sc.wtext));
    }
    if (g_sc.wclick[0]) d.dict_put("onClick", Value::make_str(g_sc.wclick));
    return d;
}

// ---- play mode: run an event/graph by id against the live session ----------
// The same contract as the web /api/graph/run: run to completion or pause at a
// ShowPopup; the popup carries {node, _cache} and resumes with the choice.
void play_run(const std::string& id, const std::string& from = "",
              const std::string& choice = "") {
    if (from.empty()) {
        try {
            g_sc.play_graph = forge::load_graph(id);
        } catch (const std::exception& e) {
            app().status = std::string("event: ") + e.what();
            return;
        }
    }
    if (!g_game_active) {          // same behavior as the web route
        game_new(0, 1);
        app().game_active = true;
    }
    forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra,
                        g_active_rules, game_rng};
    forge::JsonValue cache;
    if (const forge::JsonValue* c = g_sc.popup.find("_cache")) cache = *c;
    forge::JsonValue r = forge::run_graph(g_sc.play_graph, cx, from, choice, cache);
    g_sc.play_popup = false;
    if (const forge::JsonValue* p = r.find("popup")) {
        if (p->is_object()) {
            g_sc.popup = *p;
            g_sc.play_popup = true;
            g_sc.popup_hover = -1;
        }
    }
    if (const forge::JsonValue* fx = r.find("effects")) {
        std::string s;
        for (const forge::JsonValue& e : fx->arr)
            s += (s.empty() ? "" : "; ") + e.str;
        if (!s.empty()) app().status = s;
    }
}

// dispatch one widget's onClick: goto_<screen> navigates when the screen
// exists; anything else runs as an event graph
void play_click(Store& st, const std::string& action) {
    if (action.rfind("goto_", 0) == 0) {
        std::string target = "dlog." + action.substr(5);
        if (drydock::store_find(st, target)) {
            g_sc.sel = target;
            g_sc.sel_w = -1;
            app().status = "-> " + target;
            return;
        }
    }
    play_run(action);
}

// the msge record for a popup title key (box geometry + speaker channel)
const Record* msge_for_key(Store& st, const std::string& key) {
    auto ti = st.type_index.find("msge");
    if (ti == st.type_index.end()) return nullptr;
    for (const Record& r : st.records[ti->second]) {
        const Value* k = r.find("key");
        if (k && k->s == key) return &r;
    }
    return nullptr;
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
    g_sc.wtype = t == "sprite" ? 1 : t == "button" ? 2 : t == "message" ? 3 : 0;
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
    // screen header: play toggle + name + background picker
    {
        if (ImGui::Checkbox("Play", &g_sc.play)) {
            g_sc.sel_w = -1;
            g_sc.play_popup = false;
            app().status = g_sc.play ? "play mode: buttons fire their events"
                                     : "edit mode";
        }
        ImGui::SameLine();
        char nbuf[64];
        std::snprintf(nbuf, sizeof nbuf, "%s", rstr(*rec, "name").c_str());
        ImGui::SetNextItemWidth(200);
        if (ImGui::InputText("name", nbuf, sizeof nbuf,
                             ImGuiInputTextFlags_EnterReturnsTrue)) {
            Value v = Value::make_str(nbuf);
            std::string err;
            if (!drydock::store_set(*st, rec->id, "name", &v, err))
                app().status = "edit rejected: " + err;
        }
        ImGui::SameLine();
        std::string bg = rstr(*rec, "background");
        ImGui::SetNextItemWidth(180);
        if (ImGui::BeginCombo("background", bg.empty() ? "(none)" : bg.c_str())) {
            if (ImGui::Selectable("(none)", bg.empty())) {
                Value v = Value::make_str("");
                std::string err;
                drydock::store_set(*st, rec->id, "background", &v, err);
            }
            auto si = st->type_index.find("sprt");
            if (si != st->type_index.end())
                for (const Record& s : st->records[si->second]) {
                    if (s.find("kind") && s.find("kind")->s != "background") continue;
                    const Value* sheet = s.find("sheet");
                    if (!sheet) continue;
                    if (ImGui::Selectable(sheet->s.c_str(), bg == sheet->s)) {
                        Value v = Value::make_str(sheet->s);
                        std::string err;
                        if (!drydock::store_set(*st, rec->id, "background", &v, err))
                            app().status = "edit rejected: " + err;
                    }
                }
            ImGui::EndCombo();
        }
        ImGui::SameLine();
        int bx = (int)rint(*rec, "bg_x", 0), by = (int)rint(*rec, "bg_y", 0);
        ImGui::SetNextItemWidth(70);
        if (ImGui::InputInt("bg x", &bx, 0, 0, ImGuiInputTextFlags_EnterReturnsTrue))
            commit_int(*rec, "bg_x", bx);
        ImGui::SameLine();
        ImGui::SetNextItemWidth(70);
        if (ImGui::InputInt("y##bgy", &by, 0, 0, ImGuiInputTextFlags_EnterReturnsTrue))
            commit_int(*rec, "bg_y", by);
        ImGui::SameLine();
        ImGui::TextDisabled("font: %s",
                            assets().nat.font_real ? "FONTTINY.FF"
                                                   : "baked 5x7 (add raw/COLONIZE/FONTTINY.FF)");
    }

    const Value* widgets = rwidgets(*rec);
    const int nwidgets = widgets ? (int)widgets->list.size() : 0;

    // compose the screen
    vc::Surface scr;
    scr.set_palette(assets().nat.pal);
    scr.clear(0);
    std::string bg = rstr(*rec, "background");
    int bgx = (int)rint(*rec, "bg_x", 0), bgy = (int)rint(*rec, "bg_y", 0);
    if (g_sc.bg_dragging) { bgx = g_sc.bg_live_x; bgy = g_sc.bg_live_y; }
    if (!bg.empty())
        if (const vc::IndexedPng* pik = atlas_file("pik/" + bg + ".png"))
            scr.blit_region(*pik, 0, 0, pik->w, pik->h, bgx, bgy);
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
        } else if (type == "buildmenu") {
            // the colony construction menu: buildable rows from the bldg
            // records (not built + min_colony met; the FF/chain gates live in
            // the session's build route). Play-click starts the build.
            uint8_t col = color_idx(assets().nat.pal, dstr(d, "color", "220,220,220"), 15);
            int ci = (int)dint(d, "colony", 0);
            if (app().game_active && ci >= 0 && ci < (int)g_world.colonies.size()) {
                const vc::sim::Colony& cc = g_world.colonies[ci];
                auto bi = st->type_index.find("bldg");
                int y = r[1], colx = r[0];
                if (bi != st->type_index.end())
                    for (const Record& b : st->records[bi->second]) {
                        const Value* ix = b.find("index");
                        const Value* nm = b.find("name");
                        const Value* cost = b.find("cost");
                        const Value* minc = b.find("min_colony");
                        if (!ix || !nm) continue;
                        if (cc.built_mask >> ix->i & 1) continue;
                        if (minc && cc.population < minc->i) continue;
                        std::string row = nm->s + " (" +
                                          (cost ? std::to_string(cost->i) : "?") + ")";
                        bool building = cc.build_target == (int)ix->i;
                        scr.draw_text(assets().nat.font, colx, y, row,
                                      building ? 15 : col);
                        y += 9;
                        if (y + 9 > r[1] + r[3]) {       // next column
                            y = r[1];
                            colx += 150;
                            if (colx + 60 > r[0] + r[2]) break;
                        }
                    }
            } else {
                scr.draw_text(assets().nat.font, r[0], r[1],
                              "[buildmenu: start a game to populate]", col);
            }
        } else if (type == "message") {
            // the game's message-box format: the wood-frame popup engine
            // pinned at the widget rect, box width from the rect
            vc::PopupSpec ps;
            std::string body = resolve_text(dstr(d, "text")), cur;
            for (char c : body) {
                if (c == '\r') continue;
                if (c == '\n') { ps.lines.push_back(cur); cur.clear(); }
                else cur += c;
            }
            ps.lines.push_back(cur);
            ps.box_w = r[2] > 6 ? r[2] - 6 : 0;   // rect w = outer box incl border
            ps.px = r[0];
            ps.py = r[1];
            vc::PopupLayout L = vc::popup_layout(assets().nat.font, ps);
            static const vc::IndexedPng no_panl;
            const vc::IndexedPng* panl = atlas_file("pik/WOODPANL.png");
            render_popup(scr, panl ? *panl : no_panl, assets().nat.font, ps, L);
        } else {
            uint8_t col = color_idx(assets().nat.pal, dstr(d, "color"), 15);
            std::string text = resolve_text(dstr(d, "text"));
            if (type == "button") {
                // the game's button chrome (advisor OK, report_framework.md /
                // web nsOK): dark plate, 1px label-color frame, centered
                // FONTTINY label in the label color (0x92)
                uint8_t ink = vc::nearest_pal_index(assets().nat.pal, 0, 0, 0);
                scr.fill_rect(r[0], r[1], r[2], r[3], ink);
                scr.rect_outline(r[0], r[1], r[2], r[3], col);
                int tw = scr.text_width(assets().nat.font, text);
                scr.draw_text(assets().nat.font, r[0] + (r[2] - tw) / 2,
                              r[1] + (r[3] - 7) / 2 + 1, text, col);
            } else {
                scr.draw_text(assets().nat.font, r[0], r[1], text, col);
            }
        }
        if (i == g_sc.sel_w && !g_sc.play)     // selection flash (edit mode)
            if (((int)(ImGui::GetTime() * 3)) & 1)
                scr.rect_outline(r[0] - 1, r[1] - 1, r[2] + 2, r[3] + 2, 15);
    }

    // play mode: the running event's popup, in the game's own chrome
    vc::PopupSpec pp;
    vc::PopupLayout ppL{};
    if (g_sc.play && g_sc.play_popup) {
        std::string pbody, cur;
        if (const forge::JsonValue* b = g_sc.popup.find("body")) pbody = b->str;
        for (char c : pbody) {
            if (c == '\r') continue;
            if (c == '\n') { pp.lines.push_back(cur); cur.clear(); }
            else cur += c;
        }
        pp.lines.push_back(cur);
        if (const forge::JsonValue* ch = g_sc.popup.find("choices"))
            for (const forge::JsonValue& c : ch->arr) pp.choices.push_back(c.str);
        std::string key;
        if (const forge::JsonValue* t = g_sc.popup.find("title")) key = t->str;
        int defi = -1;
        if (const Record* mr = msge_for_key(*st, key)) {
            pp.box_w = (int)rint(*mr, "box_w", 0);
            pp.px = (int)rint(*mr, "x", -1);
            pp.py = (int)rint(*mr, "y", -1);
            defi = std::atoi(rstr(*mr, "default").c_str()) - 1;
            std::string spk = rstr(*mr, "speaker");
            std::string sheet = spk == "KING1" ? "KING1"
                                : spk == "IND" ? "IND0A0"
                                : spk == "MYR" ? "MYR0"
                                : spk.rfind("MSS", 0) == 0 ? spk : "";
            if (!sheet.empty()) pp.portrait = sheet_window(sheet);
        }
        pp.highlight = g_sc.popup_hover >= 0 ? g_sc.popup_hover
                       : (defi >= 0 && defi < (int)pp.choices.size() ? defi : -1);
        ppL = vc::popup_layout(assets().nat.font, pp);
        static const vc::IndexedPng no_panl;
        const vc::IndexedPng* panl = atlas_file("pik/WOODPANL.png");
        render_popup(scr, panl ? *panl : no_panl, assets().nat.font, pp, ppL);
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

    // play mode: buttons fire their onClick; popup choices click through
    if (g_sc.play) {
        if (ImGui::IsItemHovered()) {
            ImVec2 mp = ImGui::GetMousePos();
            int mx = (int)((mp.x - origin.x) / scale);
            int my = (int)((mp.y - origin.y) / scale);
            if (g_sc.play_popup) {
                g_sc.popup_hover = -1;
                for (int i = 0; i < (int)pp.choices.size(); ++i) {
                    int cx, cy, cw, ch;
                    vc::popup_choice_rect(ppL, i, cx, cy, cw, ch);
                    if (mx >= cx && mx < cx + cw && my >= cy && my < cy + ch) {
                        g_sc.popup_hover = i;
                        if (ImGui::IsMouseClicked(0)) {
                            std::string node;
                            if (const forge::JsonValue* n = g_sc.popup.find("node"))
                                node = n->str;
                            play_run("", node, pp.choices[i]);
                        }
                    }
                }
                if (pp.choices.empty() && ImGui::IsMouseClicked(0))
                    g_sc.play_popup = false;             // no-choice box: dismiss
            } else if (ImGui::IsMouseClicked(0)) {
                for (int i = nwidgets - 1; i >= 0; --i) {   // topmost first
                    const Value& d = widgets->list[i];
                    if (d.kind != ValKind::Dict) continue;
                    int r[4];
                    drect(d, r);
                    if (mx < r[0] || mx >= r[0] + r[2] || my < r[1] ||
                        my >= r[1] + r[3])
                        continue;
                    // buildmenu rows: same layout math as the renderer
                    if (dstr(d, "type", "text") == "buildmenu" &&
                        app().game_active) {
                        int ci = (int)dint(d, "colony", 0);
                        if (ci >= 0 && ci < (int)g_world.colonies.size()) {
                            vc::sim::Colony& cc = g_world.colonies[ci];
                            auto bi = st->type_index.find("bldg");
                            int y = r[1], colx = r[0];
                            if (bi != st->type_index.end())
                                for (const Record& b : st->records[bi->second]) {
                                    const Value* ix = b.find("index");
                                    const Value* nm = b.find("name");
                                    const Value* cost = b.find("cost");
                                    const Value* minc = b.find("min_colony");
                                    if (!ix || !nm) continue;
                                    if (cc.built_mask >> ix->i & 1) continue;
                                    if (minc && cc.population < minc->i) continue;
                                    if (mx >= colx && mx < colx + 150 &&
                                        my >= y && my < y + 9) {
                                        cc.build_target = (int)ix->i;
                                        cc.build_cost = cost ? (int)cost->i : 0;
                                        app().status = "now building " + nm->s;
                                        break;
                                    }
                                    y += 9;
                                    if (y + 9 > r[1] + r[3]) {
                                        y = r[1];
                                        colx += 150;
                                        if (colx + 60 > r[0] + r[2]) break;
                                    }
                                }
                        }
                        break;
                    }
                    std::string action = dstr(d, "onClick");
                    if (action.empty()) continue;
                    play_click(*st, action);
                    break;
                }
            }
        }
    }
    // select on click, move by drag (commit on release) -- edit mode only
    if (!g_sc.play && (ImGui::IsItemHovered() || g_sc.dragging)) {
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
            } else if (!bg.empty()) {
                // no widget under the cursor: drag the background PIK
                g_sc.bg_dragging = true;
                g_sc.bg_press_mx = mx;
                g_sc.bg_press_my = my;
                g_sc.bg_start_x = bgx;
                g_sc.bg_start_y = bgy;
                g_sc.bg_live_x = bgx;
                g_sc.bg_live_y = bgy;
            }
        }
        if (g_sc.bg_dragging) {
            if (ImGui::IsMouseDown(0)) {
                g_sc.bg_live_x = g_sc.bg_start_x + (mx - g_sc.bg_press_mx);
                g_sc.bg_live_y = g_sc.bg_start_y + (my - g_sc.bg_press_my);
            } else {
                g_sc.bg_dragging = false;
                commit_int(*rec, "bg_x", g_sc.bg_live_x);
                commit_int(*rec, "bg_y", g_sc.bg_live_y);
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
    // cursor readout (320x200 space) + arrow-key nudge (1px, Shift = 8px)
    if (ImGui::IsItemHovered()) {
        ImVec2 mp = ImGui::GetMousePos();
        ImGui::SameLine();
        ImGui::TextDisabled("(%d,%d)", (int)((mp.x - origin.x) / scale),
                            (int)((mp.y - origin.y) / scale));
    }
    bool have_nudge = !g_sc.play && g_sc.sel_w >= 0 && g_sc.sel_w < nwidgets &&
                      !g_sc.dragging &&
                      ImGui::IsWindowFocused(ImGuiFocusedFlags_ChildWindows) &&
                      !ImGui::GetIO().WantTextInput;
    if (have_nudge) {
        int dx = 0, dy = 0;
        if (ImGui::IsKeyPressed(ImGuiKey_LeftArrow))  dx = -1;
        if (ImGui::IsKeyPressed(ImGuiKey_RightArrow)) dx = 1;
        if (ImGui::IsKeyPressed(ImGuiKey_UpArrow))    dy = -1;
        if (ImGui::IsKeyPressed(ImGuiKey_DownArrow))  dy = 1;
        if (dx || dy) {
            int step = ImGui::GetIO().KeyShift ? 8 : 1;
            commit_widgets(*rec, [&](std::vector<Value>& list) {
                if (g_sc.sel_w >= (int)list.size()) return;
                Value& d = list[g_sc.sel_w];
                int r[4];
                drect(d, r);
                std::vector<Value> rr{Value::make_int(r[0] + dx * step),
                                      Value::make_int(r[1] + dy * step),
                                      Value::make_int(r[2]), Value::make_int(r[3])};
                for (size_t k = 0; k < d.keys.size(); ++k)
                    if (d.keys[k] == "rect") { d.list[k] = Value::make_list(rr); return; }
                d.dict_put("rect", Value::make_list(rr));
            });
            g_sc.loaded_w = -2;
        }
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
    if (ImGui::Button("+ button")) {
        commit_widgets(*rec, [&](std::vector<Value>& list) {
            Value d = Value::make_dict();
            d.dict_put("id", Value::make_str("w" + std::to_string(nwidgets)));
            d.dict_put("type", Value::make_str("button"));
            // the advisor OK plate geometry (spec rect 289,183,27,14)
            std::vector<Value> rr{Value::make_int(289), Value::make_int(183),
                                  Value::make_int(27), Value::make_int(14)};
            d.dict_put("rect", Value::make_list(std::move(rr)));
            d.dict_put("color", Value::make_str("255,243,93"));
            d.dict_put("text", Value::make_str("OK"));
            list.push_back(std::move(d));
        });
        g_sc.sel_w = nwidgets;
        g_sc.loaded_w = -2;
    }
    ImGui::SameLine();
    if (ImGui::Button("+ message")) {
        commit_widgets(*rec, [&](std::vector<Value>& list) {
            Value d = Value::make_dict();
            d.dict_put("id", Value::make_str("w" + std::to_string(nwidgets)));
            d.dict_put("type", Value::make_str("message"));
            std::vector<Value> rr{Value::make_int(60), Value::make_int(70),
                                  Value::make_int(200), Value::make_int(40)};
            d.dict_put("rect", Value::make_list(std::move(rr)));
            d.dict_put("color", Value::make_str("255,243,93"));
            d.dict_put("text", Value::make_str("A message in the game's\n"
                                               "wood-frame box format."));
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
        ImGui::Combo("type", &g_sc.wtype, WTYPES, 4);
        ImGui::SetNextItemWidth(220);
        ImGui::InputInt4("rect", g_sc.wrect);
        if (g_sc.wtype == 1) {
            static const char* SHEETS[] = {"TERRAIN", "PHYS0", "UNITS",
                                           "BUILDING", "ICONS"};
            ImGui::SetNextItemWidth(150);
            if (ImGui::BeginCombo("sheet", g_sc.wsheet)) {
                for (const char* s : SHEETS)
                    if (ImGui::Selectable(s, std::strcmp(s, g_sc.wsheet) == 0))
                        std::snprintf(g_sc.wsheet, sizeof g_sc.wsheet, "%s", s);
                ImGui::EndCombo();
            }
            const vc::Sheet* sh = tileset_sheet(g_sc.wsheet);
            ImGui::SetNextItemWidth(150);
            ImGui::InputInt("frame", &g_sc.wframe);
            if (sh) {
                if (g_sc.wframe < 0) g_sc.wframe = 0;
                if (g_sc.wframe >= sh->nframes) g_sc.wframe = sh->nframes - 1;
                ImGui::SameLine();
                ImGui::TextDisabled("of %d", sh->nframes);
                // live frame preview at 2x, drawn straight from the sheet
                if (g_sc.wframe >= 0 && g_sc.wframe < sh->nframes) {
                    char key[64];
                    std::snprintf(key, sizeof key, "frm:%s:%d", g_sc.wsheet,
                                  g_sc.wframe);
                    const vc::Frame& f = sh->frames[g_sc.wframe];
                    Texture* tex = static_texture(drv, key, [&](vc::Image& img) {
                        if (f.w <= 0 || f.h <= 0) return false;
                        img.w = f.w; img.h = f.h;
                        img.rgb.assign((size_t)f.w * f.h * 3, 32);
                        for (int y = 0; y < f.h; ++y)
                            for (int x = 0; x < f.w; ++x) {
                                uint8_t i = f.px[(size_t)y * f.w + x];
                                if (i == vc::SS_TRANSPARENT) continue;
                                uint8_t* p = &img.rgb[((size_t)y * f.w + x) * 3];
                                const uint8_t* pal = assets().nat.pal;
                                p[0] = pal[i * 3]; p[1] = pal[i * 3 + 1];
                                p[2] = pal[i * 3 + 2];
                            }
                        return true;
                    });
                    if (tex)
                        ImGui::Image((ImTextureID)(intptr_t)tex->id,
                                     ImVec2(tex->w * 2.0f, tex->h * 2.0f));
                }
            }
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
