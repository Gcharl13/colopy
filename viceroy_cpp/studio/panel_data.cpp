// panel_data.cpp -- the record-database work surfaces ported from the web UI:
//   Tables  a spreadsheet grid per record type (schema-ordered columns,
//           inline cell editing through the store chokepoint)
//   Rules   the config knobs (conf records) grouped with docs, edits applied
//           to the LIVE ruleset immediately (same as the web Rules tab)
//   Events  the typed chain events (evnt records): browse the 36 game events
//           with their commentary; field editing stays in the Inspector
#include "studio_shared.hpp"
#include "imgui.h"
#include "drydock_api.hpp"
#include "drydock_bridge.hpp"     // drydock_apply_records (live-rules sync)
#include "session.hpp"            // g_active_rules
#include "../drydock/core/store.hpp"
#include <cstring>
#include <map>
#include <string>
#include <vector>

using drydock::Record;
using drydock::Store;
using drydock::ValKind;
using drydock::Value;

namespace studio {
namespace {

bool set_and_apply(const std::string& id, const std::string& field, const Value& v,
                   bool apply_conf) {
    Store* st = forge::drydock_store();
    std::string err;
    if (!drydock::store_set(*st, id, field, &v, err)) {
        app().status = "edit rejected: " + err;
        return false;
    }
    if (const Record* r = drydock::store_find(*st, id))
        forge::drydock_apply_records(g_active_rules, {*r}, apply_conf);
    app().status = id + "." + field + " set";
    return true;
}

std::string preview(const Value& v) {
    switch (v.kind) {
        case ValKind::Int:   return std::to_string(v.i);
        case ValKind::Float: return std::to_string(v.f);
        case ValKind::Str:
        case ValKind::Token: return v.s;
        case ValKind::List:  return "[" + std::to_string(v.list.size()) + "]";
        case ValKind::Dict:  return "{" + std::to_string(v.keys.size()) + "}";
    }
    return "";
}

// One editable cell for Int/Float/Str; Token navigates; List/Dict preview.
void cell_editor(const Record& r, const drydock::RecField& f, bool apply_conf) {
    ImGui::PushID(f.name.c_str());
    ImGui::SetNextItemWidth(-1);
    switch (f.value.kind) {
        case ValKind::Int: {
            long long tmp = f.value.i;
            if (ImGui::InputScalar("##c", ImGuiDataType_S64, &tmp, nullptr, nullptr,
                                   nullptr, ImGuiInputTextFlags_EnterReturnsTrue))
                set_and_apply(r.id, f.name, Value::make_int(tmp), apply_conf);
            break;
        }
        case ValKind::Float: {
            double tmp = f.value.f;
            if (ImGui::InputDouble("##c", &tmp, 0, 0, "%.6g",
                                   ImGuiInputTextFlags_EnterReturnsTrue))
                set_and_apply(r.id, f.name, Value::make_float(tmp), apply_conf);
            break;
        }
        case ValKind::Str: {
            char buf[512];
            std::snprintf(buf, sizeof buf, "%s", f.value.s.c_str());
            if (ImGui::InputText("##c", buf, sizeof buf,
                                 ImGuiInputTextFlags_EnterReturnsTrue))
                set_and_apply(r.id, f.name, Value::make_str(buf), apply_conf);
            break;
        }
        case ValKind::Token: {
            Store* st = forge::drydock_store();
            if (ImGui::Selectable(f.value.s.c_str()) &&
                drydock::store_find(*st, f.value.s))
                select_record(f.value.s);
            break;
        }
        default:
            ImGui::TextDisabled("%s", preview(f.value).c_str());
    }
    ImGui::PopID();
}

}  // namespace

// ------------------------------------------------------------------- Tables
void tables_panel(Driver&) {
    ImGui::Begin("Tables");
    Store* st = forge::drydock_store();
    if (!st) { ImGui::TextDisabled("record store not loaded"); ImGui::End(); return; }

    static int type = -1;
    static char filter[64] = {0};
    ImGui::SetNextItemWidth(140);
    if (ImGui::BeginCombo("##type", type >= 0 ? st->type_codes[type].c_str()
                                              : "record type")) {
        for (int t = 0; t < (int)st->type_codes.size(); ++t) {
            char lbl[96];
            std::snprintf(lbl, sizeof lbl, "%s (%zu)", st->type_codes[t].c_str(),
                          st->records[t].size());
            if (ImGui::Selectable(lbl, type == t)) type = t;
        }
        ImGui::EndCombo();
    }
    ImGui::SameLine();
    ImGui::SetNextItemWidth(160);
    ImGui::InputTextWithHint("##f", "filter ids", filter, sizeof filter);
    if (type < 0 || type >= (int)st->records.size()) {
        ImGui::TextDisabled("pick a record type -- the grid shows every record "
                            "as a row, schema columns across");
        ImGui::End();
        return;
    }
    const drydock::TypeDef* td = st->schema.find(st->type_codes[type]);
    const std::vector<Record>& recs = st->records[type];
    int ncols = 1 + (td ? (int)td->fields.size() : 0);
    if (ncols > 24) ncols = 24;   // sanity; widest real type is ~15 columns
    if (ImGui::BeginTable("grid", ncols,
                          ImGuiTableFlags_Borders | ImGuiTableFlags_RowBg |
                              ImGuiTableFlags_ScrollX | ImGuiTableFlags_ScrollY |
                              ImGuiTableFlags_Resizable)) {
        ImGui::TableSetupScrollFreeze(1, 1);
        ImGui::TableSetupColumn("id", ImGuiTableColumnFlags_WidthFixed, 180.0f);
        if (td)
            for (int c = 0; c + 1 < ncols; ++c)
                ImGui::TableSetupColumn(td->fields[c].name.c_str());
        ImGui::TableHeadersRow();
        for (const Record& r : recs) {
            if (filter[0] && r.id.find(filter) == std::string::npos) continue;
            ImGui::TableNextRow();
            ImGui::TableNextColumn();
            bool dirty = st->dirty.count(r.id) > 0;
            if (dirty) ImGui::PushStyleColor(ImGuiCol_Text, IM_COL32(255, 200, 90, 255));
            if (ImGui::Selectable(r.id.c_str(), app().sel_id == r.id))
                select_record(r.id);
            if (dirty) ImGui::PopStyleColor();
            if (td)
                for (int c = 0; c + 1 < ncols; ++c) {
                    ImGui::TableNextColumn();
                    const Value* v = r.find(td->fields[c].name);
                    if (!v) { ImGui::TextDisabled("-"); continue; }
                    // find the live RecField (cell_editor commits by name)
                    for (const drydock::RecField& f : r.fields)
                        if (f.name == td->fields[c].name) {
                            ImGui::PushID(r.id.c_str());
                            cell_editor(r, f, /*apply_conf*/ true);
                            ImGui::PopID();
                            break;
                        }
                }
        }
        ImGui::EndTable();
    }
    ImGui::End();
}

// -------------------------------------------------------------------- Rules
void rules_panel(Driver&) {
    ImGui::Begin("Rules");
    Store* st = forge::drydock_store();
    if (!st) { ImGui::TextDisabled("record store not loaded"); ImGui::End(); return; }
    auto ti = st->type_index.find("conf");
    if (ti == st->type_index.end()) {
        ImGui::TextDisabled("no conf records");
        ImGui::End();
        return;
    }
    static char filter[64] = {0};
    ImGui::SetNextItemWidth(200);
    ImGui::InputTextWithHint("##f", "search knobs", filter, sizeof filter);
    ImGui::SameLine();
    ImGui::TextDisabled("edits apply to the LIVE ruleset immediately");

    // group -> records (stable order within the store)
    std::map<std::string, std::vector<const Record*>> groups;
    for (const Record& r : st->records[ti->second]) {
        if (filter[0]) {
            std::string hay = r.id;
            if (const Value* d = r.find("doc")) hay += " " + d->s;
            std::string needle = filter;
            for (auto& c : hay) c = (char)tolower(c);
            for (auto& c : needle) c = (char)tolower(c);
            if (hay.find(needle) == std::string::npos) continue;
        }
        const Value* g = r.find("group");
        groups[g ? g->s : "(ungrouped)"].push_back(&r);
    }
    ImGui::BeginChild("knobs");
    for (auto& [group, recs] : groups) {
        if (!ImGui::CollapsingHeader((group + " (" + std::to_string(recs.size()) + ")").c_str(),
                                     filter[0] ? ImGuiTreeNodeFlags_DefaultOpen : 0))
            continue;
        for (const Record* r : recs) {
            std::string knob = r->id.substr(r->id.find('.') + 1);
            bool dirty = st->dirty.count(r->id) > 0;
            ImGui::PushID(r->id.c_str());
            if (dirty) ImGui::PushStyleColor(ImGuiCol_Text, IM_COL32(255, 200, 90, 255));
            ImGui::Text("%s", knob.c_str());
            if (dirty) ImGui::PopStyleColor();
            ImGui::SameLine(260);
            for (const drydock::RecField& f : r->fields)
                if (f.name == "value") {
                    ImGui::SetNextItemWidth(140);
                    cell_editor(*r, f, /*apply_conf*/ true);
                }
            if (const Value* d = r->find("doc")) {
                ImGui::PushStyleColor(ImGuiCol_Text, IM_COL32(140, 145, 160, 255));
                ImGui::TextWrapped("%s", d->s.c_str());
                ImGui::PopStyleColor();
            }
            ImGui::Spacing();
            ImGui::PopID();
        }
    }
    ImGui::EndChild();
    ImGui::End();
}

// ------------------------------------------------------------------- Events
namespace {
// readable recursive dump of the evnt vars/steps structure
void value_tree(const Value& v, int depth) {
    switch (v.kind) {
        case ValKind::List:
            for (size_t i = 0; i < v.list.size(); ++i) {
                if (v.list[i].kind == ValKind::Dict || v.list[i].kind == ValKind::List) {
                    ImGui::PushID((int)i);
                    std::string label = "[" + std::to_string(i) + "]";
                    if (const Value* d = v.list[i].dict_get("do")) label += " " + d->s;
                    if (const Value* d = v.list[i].dict_get("id"))
                        label += " -> $" + d->s;
                    if (ImGui::TreeNodeEx(label.c_str(),
                                          depth < 2 ? ImGuiTreeNodeFlags_DefaultOpen : 0)) {
                        value_tree(v.list[i], depth + 1);
                        ImGui::TreePop();
                    }
                    ImGui::PopID();
                } else {
                    ImGui::BulletText("%s", preview(v.list[i]).c_str());
                }
            }
            break;
        case ValKind::Dict:
            for (size_t i = 0; i < v.keys.size(); ++i) {
                const Value& c = v.list[i];
                if (c.kind == ValKind::Dict || c.kind == ValKind::List) {
                    ImGui::PushID((int)i);
                    if (ImGui::TreeNodeEx(v.keys[i].c_str(),
                                          depth < 2 ? ImGuiTreeNodeFlags_DefaultOpen : 0)) {
                        value_tree(c, depth + 1);
                        ImGui::TreePop();
                    }
                    ImGui::PopID();
                } else {
                    ImGui::BulletText("%s = %s", v.keys[i].c_str(), preview(c).c_str());
                }
            }
            break;
        default:
            ImGui::BulletText("%s", preview(v).c_str());
    }
}
}  // namespace

void events_panel(Driver&) {
    ImGui::Begin("Events");
    Store* st = forge::drydock_store();
    if (!st) { ImGui::TextDisabled("record store not loaded"); ImGui::End(); return; }
    auto ti = st->type_index.find("evnt");
    if (ti == st->type_index.end()) {
        ImGui::TextDisabled("no evnt records");
        ImGui::End();
        return;
    }
    static std::string sel;
    ImGui::BeginChild("list", ImVec2(230, 0), ImGuiChildFlags_ResizeX);
    for (const Record& r : st->records[ti->second]) {
        const Value* n = r.find("name");
        std::string label = n ? n->s : r.id;
        if (ImGui::Selectable(label.c_str(), sel == r.id)) {
            sel = r.id;
            select_record(r.id);
        }
    }
    ImGui::EndChild();
    ImGui::SameLine();
    ImGui::BeginChild("detail");
    const Record* r = sel.empty() ? nullptr : drydock::store_find(*st, sel);
    if (!r) {
        ImGui::TextDisabled("select an event -- the 36 typed chain events are "
                            "the game's authored logic (kings tax, immigration, "
                            "combat, natives, ...)");
    } else {
        const Value* n = r->find("name");
        ImGui::Text("%s", n ? n->s.c_str() : r->id.c_str());
        ImGui::TextDisabled("%s", r->id.c_str());
        if (const Value* cm = r->find("comments"))
            for (const Value& c : cm->list)
                if (const Value* t = c.dict_get("text")) {
                    ImGui::PushStyleColor(ImGuiCol_Text, IM_COL32(150, 160, 140, 255));
                    ImGui::TextWrapped("%s", t->s.c_str());
                    ImGui::PopStyleColor();
                }
        ImGui::Separator();
        if (const Value* vars = r->find("vars")) {
            ImGui::SeparatorText("vars (computed inputs)");
            value_tree(*vars, 0);
        }
        if (const Value* steps = r->find("steps")) {
            ImGui::SeparatorText("steps (the chain)");
            value_tree(*steps, 0);
        }
        ImGui::Spacing();
        ImGui::TextDisabled("field editing: select the record in the Inspector");
    }
    ImGui::EndChild();
    ImGui::End();
}

} // namespace studio
