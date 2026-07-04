// forge/drydock_api -- see drydock_api.hpp.
#include "drydock_api.hpp"
#include "drydock_bridge.hpp"
#include "engine.hpp"
#include "json.hpp"
#include "../drydock/core/store.hpp"
#include "../drydock/pack/pack.hpp"
#include "fs_walk.hpp"
#include <sys/stat.h>
#include <algorithm>
#include <fstream>
#include <functional>
#include <sstream>

namespace forge {

using namespace drydock;

static Store g_store;
static std::string g_data_dir;
static bool g_ready = false;

// ---- helpers -------------------------------------------------------------------

static std::string slurp(const std::string& p) {
    std::ifstream f(p);
    std::stringstream ss; ss << f.rdbuf();
    return ss.str();
}
static void walk(const std::string& dir, std::vector<std::string>& out) {
    walk_rec_files(dir, out);
}
static std::string dd_qparam(const std::string& query, const std::string& key) {
    size_t i = 0;
    while (i < query.size()) {
        size_t amp = query.find('&', i);
        std::string kv = query.substr(i, amp == std::string::npos ? std::string::npos : amp - i);
        size_t eq = kv.find('=');
        if (eq != std::string::npos && kv.substr(0, eq) == key) {
            std::string v = kv.substr(eq + 1);           // minimal decode: %2E + '+' only
            std::string o;
            for (size_t j = 0; j < v.size(); ++j) {
                if (v[j] == '+') o += ' ';
                else if (v[j] == '%' && j + 2 < v.size())
                    { o += (char)std::stoi(v.substr(j + 1, 2), nullptr, 16); j += 2; }
                else o += v[j];
            }
            return o;
        }
        if (amp == std::string::npos) break;
        i = amp + 1;
    }
    return "";
}

// Value <-> JSON (the web views speak JSON; the store speaks Values)
static JsonValue value_to_json(const Value& v) {
    switch (v.kind) {
        case ValKind::Int:   return json_num((double)v.i);
        case ValKind::Float: return json_num(v.f);
        case ValKind::Str:   return json_str(v.s);
        case ValKind::Token: { JsonValue o; o.type = JsonValue::Object;
            o.obj["ref"] = json_str(v.s); return o; }
        case ValKind::List: { JsonValue a; a.type = JsonValue::Array;
            for (const auto& x : v.list) a.arr.push_back(value_to_json(x));
            return a; }
        case ValKind::Dict: { JsonValue o; o.type = JsonValue::Object;
            for (size_t i = 0; i < v.keys.size(); ++i)
                o.obj[v.keys[i]] = value_to_json(v.list[i]);
            return o; }
    }
    return json_str("");
}
static Value json_any_to_value(const JsonValue& j);   // defined with the DLOG cutover

// JSON -> Value, guided by the schema field kind (so 3 becomes Int for int
// fields, "good.rum" becomes a ref Token for ref fields, etc.)
static bool json_to_value(const JsonValue& j, const FieldDef& fd, Value& out, std::string& err) {
    switch (fd.type) {
        case FType::Int:
            if (!j.is_number()) { err = "expected number"; return false; }
            out = Value::make_int((long long)j.num);
            return true;
        case FType::Float:
            if (!j.is_number()) { err = "expected number"; return false; }
            out = Value::make_float(j.num);
            return true;
        case FType::Str:
            if (!j.is_string()) { err = "expected string"; return false; }
            out = Value::make_str(j.str);
            return true;
        case FType::Ref:
            if (!j.is_string()) { err = "expected ref id string"; return false; }
            out = Value::make_token(j.str);
            return true;
        case FType::ListInt:
        case FType::ListStr: {
            if (!j.is_array()) { err = "expected array"; return false; }
            std::vector<Value> xs;
            for (const JsonValue& x : j.arr) {
                if (fd.type == FType::ListInt) {
                    if (!x.is_number()) { err = "expected number element"; return false; }
                    xs.push_back(Value::make_int((long long)x.num));
                } else {
                    if (!x.is_string()) { err = "expected string element"; return false; }
                    xs.push_back(Value::make_str(x.str));
                }
            }
            out = Value::make_list(std::move(xs));
            return true;
        }
        case FType::ListDict: {
            if (!j.is_array()) { err = "expected array of objects"; return false; }
            std::vector<Value> xs;
            for (const JsonValue& x : j.arr) {
                if (!x.is_object()) { err = "expected object element"; return false; }
                xs.push_back(json_any_to_value(x));
            }
            out = Value::make_list(std::move(xs));
            return true;
        }
        default:
            err = "field kind not editable over the API yet";
            return false;
    }
}

// ---- legacy-table write-through (strangler seam, GAP-ANALYSIS §5) ---------------
// Legacy readers still resolve @SECTION[row].col from the JSON extraction tables
// (terrain yields via terrain_good_yield, job/unit display names, ...). Until
// each consumer is cut over to the store, every store mutation patches the
// mapped in-memory JSON cells so ALL of them follow Drydock edits live -- which
// is what lets the Tables-tab rows for these sections retire honestly. Field
// names == column names (the drydock_migrate.py mapping is the identity);
// store-only fields (prof.produces) have no JSON column and are skipped.
static const char* GOOD_COLS[] = {"name","price_start1","price_start2","drift_low",
    "drift_high","burden","rise","fall","attrition","volatility",nullptr};
static const char* UNIT_COLS[] = {"name","icon","movement","attack","combat","cargo",
    "size","cost","tools","guns","hull","ai_role_bits",nullptr};
static const char* PROF_COLS[] = {"name","expert_name","school_tier","europe_value",nullptr};
static const char* BLDG_COLS[] = {"name","cost","tools_x10","size","min_colony","upkeep",nullptr};
static const char* FFAT_COLS[] = {"name","type","weight_1500_1600","weight_1600_1700",
    "weight_1700plus",nullptr};
static const char* NATN_COLS[] = {"name","color",nullptr};   // @COUNTRY half; @NATIONALITY below
static const char* TERR_JCOLS[] = {"name","movement","defensive","improvement","value",
    "y_farmer","y_planter_sugar","y_planter_tobacco","y_planter_cotton","y_trapper",
    "y_lumberjack","y_ore","y_silver","y_fisherman",nullptr};

static void patch_record_tables(const Record& r) {
    const std::string ty = r.type();
    const Value* iv = r.find("index");
    if (!iv || iv->kind != ValKind::Int) return;         // conf (no index) / adds beyond rows
    const int idx = (int)iv->i;
    const char* const* cols;
    std::string section;
    int row = idx;
    if      (ty == "good") { cols = GOOD_COLS; section = "@CARGO"; }
    else if (ty == "unit") { cols = UNIT_COLS; section = "@UNIT"; }
    else if (ty == "prof") { cols = PROF_COLS; section = "@JOB"; }
    else if (ty == "bldg") { cols = BLDG_COLS; section = "@BUILDING"; }
    else if (ty == "ffat") { cols = FFAT_COLS; section = "@FATHERS"; }
    else if (ty == "natn") {
        // one record fans out to the two row-parallel legacy tables
        cols = NATN_COLS; section = "@COUNTRY";
        if (const Value* v = r.find("nationality"); v && v->kind == ValKind::Str)
            table_patch_cell("@NATIONALITY", idx, "name", v->s);
    }
    else if (ty == "terr") {
        cols = TERR_JCOLS;
        // the two forested bands fold onto the same 8 @FORESTED rows (legacy
        // readers index (t-8)%8); on a full repatch band 2 writes last
        if (idx < 8)       { section = "@UNFORESTED"; }
        else if (idx < 24) { section = "@FORESTED"; row = (idx - 8) % 8; }
        else               { section = "@OTHER"; row = idx - 24; }
    }
    else return;                                          // conf/phas: no JSON section
    for (int i = 0; cols[i]; ++i) {
        const Value* v = r.find(cols[i]);
        std::string s;                                    // absent -> "" (empty extraction cell)
        if (v) {
            if (v->kind == ValKind::Int) s = std::to_string(v->i);
            else if (v->kind == ValKind::Str || v->kind == ValKind::Token) s = v->s;
            else continue;
        }
        table_patch_cell(section, row, cols[i], s);
    }
}

void drydock_repatch_tables() {
    if (!g_ready) return;
    for (const auto& bucket : g_store.records)
        for (const auto& r : bucket) patch_record_tables(r);
}

// ---- P5 overlay subsumption: rules-overlay JSON -> store edits --------------------
// The mod overlay ({cfg:{...}, units:{Name:{...}}, terrain_defense/move:{id:v}})
// is now an IMPORT/EXPORT format; the record store is the single live rules
// authority. Importing converts each diff to a store_set through the chokepoint
// (validated, journaled, undoable), skipping no-ops, then syncs the live rules.
static void sync_rules(vc::sim::RuleData* rd);         // defined below
static bool import_set(const std::string& id, const char* field, Value v, int& applied) {
    const Record* r = store_find(g_store, id);
    if (!r) return false;
    if (const Value* old = r->find(field); old && value_equal(*old, v)) return true;
    std::string err;
    if (!store_set(g_store, id, field, &v, err)) return false;
    ++applied;
    return true;
}

bool drydock_import_overlay(const JsonValue& root, vc::sim::RuleData* rd, std::string& summary) {
    if (!g_ready || !root.is_object()) return false;
    int applied = 0;
    std::vector<std::string> skipped;
    if (const JsonValue* cfg = root.find("cfg"); cfg && cfg->is_object()) {
        for (const auto& [k, v] : cfg->obj) {
            if (v.is_array()) {                       // ff_gate_years / ref_accrue_gate_years
                std::vector<Value> xs;
                for (const JsonValue& x : v.arr) xs.push_back(Value::make_int((long long)x.num));
                if (!import_set("conf." + k, "values", Value::make_list(std::move(xs)), applied))
                    skipped.push_back("cfg." + k);
            } else if (v.is_number()) {
                if (!import_set("conf." + k, "value", Value::make_int((long long)v.num), applied))
                    skipped.push_back("cfg." + k);
            }
        }
    }
    if (const JsonValue* units = root.find("units"); units && units->is_object()) {
        auto ti = g_store.type_index.find("unit");
        for (const auto& [name, u] : units->obj) {
            std::string rid;                          // unit record by its name field
            if (ti != g_store.type_index.end())
                for (const Record& r : g_store.records[ti->second])
                    if (const Value* n = r.find("name"); n && n->s == name) { rid = r.id; break; }
            if (rid.empty()) { skipped.push_back("units." + name); continue; }
            // overlay field -> record column (defense is the @UNIT combat column);
            // move_class/capbits are not record-represented and stay skipped
            static const std::pair<const char*, const char*> M[] = {
                {"attack", "attack"}, {"defense", "combat"},
                {"cargo", "cargo"}, {"movement", "movement"}};
            for (const auto& [ov, col] : M)
                if (const JsonValue* x = u.find(ov); x && x->is_number())
                    import_set(rid, col, Value::make_int((long long)x->num), applied);
            for (const char* nr : {"move_class", "capbits"})
                if (u.find(nr)) skipped.push_back("units." + name + "." + nr);
        }
    }
    for (const auto& [sec, col] : {std::pair<const char*, const char*>{"terrain_defense", "defensive"},
                                   std::pair<const char*, const char*>{"terrain_move", "movement"}}) {
        const JsonValue* t = root.find(sec);
        if (!t || !t->is_object()) continue;
        auto ti = g_store.type_index.find("terr");
        for (const auto& [ids, v] : t->obj) {
            std::string rid;
            long long want = std::atoll(ids.c_str());
            if (ti != g_store.type_index.end())
                for (const Record& r : g_store.records[ti->second])
                    if (const Value* ix = r.find("index"); ix && ix->i == want) { rid = r.id; break; }
            if (rid.empty() || !v.is_number()) { skipped.push_back(std::string(sec) + "." + ids); continue; }
            import_set(rid, col, Value::make_int((long long)v.num), applied);
        }
    }
    sync_rules(rd);
    summary = "drydock: overlay imported into the store (" + std::to_string(applied) + " edits";
    if (!skipped.empty()) {
        summary += ", skipped:";
        for (const auto& s : skipped) summary += " " + s;
    }
    summary += ")";
    return true;
}

// ---- MSGE consumer cutover (strangler): @KEY -> store record --------------------
// The message readers are keyed lookups, so they cut over directly instead of
// using the JSON write-through: dd_message_hook (engine.hpp) serves message_meta
// and game_message_text from the store; /api/messages is rebuilt from it too.
static std::unordered_map<std::string, std::string> g_msg_index;   // "@KEY" -> record id

static void rebuild_msg_index() {
    g_msg_index.clear();
    auto ti = g_store.type_index.find("msge");
    if (ti == g_store.type_index.end()) return;
    for (const Record& r : g_store.records[ti->second])
        if (const Value* k = r.find("key"); k && k->kind == ValKind::Str)
            g_msg_index[k->s] = r.id;
}

static DDMsgView dd_message_provider(const std::string& key) {
    DDMsgView v;
    auto it = g_msg_index.find(key);
    if (it == g_msg_index.end()) return v;
    const Record* r = store_find(g_store, it->second);
    if (!r) return v;
    v.found = true;
    auto s = [&](const char* f) { const Value* x = r->find(f);
        return (x && x->kind == ValKind::Str) ? x->s : std::string(); };
    auto i = [&](const char* f, int def) { const Value* x = r->find(f);
        return (x && x->kind == ValKind::Int) ? (int)x->i : def; };
    v.text = s("text");
    v.box_w = i("box_w", 0); v.x = i("x", -1); v.y = i("y", -1);
    v.sprite = s("sprite"); v.speaker = s("speaker"); v.def = s("default");
    return v;
}

// ---- TEXT consumer cutover: @SECTION line lists ---------------------------------
// labels_section (main.cpp) and /api/text serve label/menu/name-pool lines; the
// migrated sections come from the store. Index keeps the legacy source
// precedence (LABELS, then NAMES, then COLONY; MENU sections don't collide).
static std::unordered_map<std::string, std::string> g_text_index;   // "@MISC" -> record id

static void rebuild_text_index() {
    g_text_index.clear();
    auto ti = g_store.type_index.find("text");
    if (ti == g_store.type_index.end()) return;
    static const char* PRECEDENCE[] = {"MENU", "COLONY", "NAMES", "LABELS"};   // later wins
    for (const char* want : PRECEDENCE)
        for (const Record& r : g_store.records[ti->second]) {
            const Value* sec = r.find("section");
            const Value* src = r.find("source");
            if (sec && sec->kind == ValKind::Str && src && src->kind == ValKind::Str &&
                src->s == want)
                g_text_index[sec->s] = r.id;
        }
}

bool drydock_text_lines(const std::string& section, std::vector<std::string>& out) {
    if (!g_ready) return false;
    auto it = g_text_index.find(section.rfind("@", 0) == 0 ? section : "@" + section);
    if (it == g_text_index.end()) return false;
    const Record* r = store_find(g_store, it->second);
    const Value* lines = r ? r->find("lines") : nullptr;
    if (!lines || lines->kind != ValKind::List) return false;
    out.clear();
    for (const Value& x : lines->list)
        out.push_back(x.kind == ValKind::Str ? x.s : std::string());
    return true;
}

void drydock_text_overlay(JsonValue& doc, const std::string& file) {
    if (!g_ready || doc.type != JsonValue::Object) return;
    auto ti = g_store.type_index.find("text");
    if (ti == g_store.type_index.end()) return;
    for (const Record& r : g_store.records[ti->second]) {
        const Value* src = r.find("source");
        const Value* sec = r.find("section");
        const Value* lines = r.find("lines");
        if (!src || src->kind != ValKind::Str || src->s != file) continue;
        if (!sec || sec->kind != ValKind::Str || !lines || lines->kind != ValKind::List) continue;
        std::string joined;
        for (size_t i = 0; i < lines->list.size(); ++i) {
            if (i) joined += '\n';
            if (lines->list[i].kind == ValKind::Str) joined += lines->list[i].s;
        }
        JsonValue v; v.type = JsonValue::String; v.str = std::move(joined);
        doc.obj[sec->s] = std::move(v);
    }
}

// ---- DLOG consumer cutover: the screen CRUD ---------------------------------------
// list/load/save route through dlog records; a designer save becomes ordinary
// store_set calls (validated, journaled, undoable, saved as canonical text).
static JsonValue json_int_num(long long i) { return json_num((double)i); }

// generic JSON -> Value (screens are int/str/list/dict; bools map to 0/1,
// non-integral numbers become floats)
static Value json_any_to_value(const JsonValue& j) {
    switch (j.type) {
        case JsonValue::Number:
            if (j.num == (double)(long long)j.num) return Value::make_int((long long)j.num);
            return Value::make_float(j.num);
        case JsonValue::Bool:   return Value::make_int(j.b ? 1 : 0);
        case JsonValue::String: return Value::make_str(j.str);
        case JsonValue::Array: {
            std::vector<Value> xs;
            for (const JsonValue& x : j.arr) xs.push_back(json_any_to_value(x));
            return Value::make_list(std::move(xs));
        }
        case JsonValue::Object: {
            Value d; d.kind = ValKind::Dict;
            for (const auto& [k, x] : j.obj) {   // std::map: keys sorted == canonical form
                d.keys.push_back(k);
                d.list.push_back(json_any_to_value(x));
            }
            return d;
        }
        default: return Value::make_str("");
    }
}

static std::vector<std::string> dd_screen_list() {
    std::vector<std::string> ids;
    auto ti = g_store.type_index.find("dlog");
    if (ti == g_store.type_index.end()) return ids;
    for (const Record& r : g_store.records[ti->second])
        ids.push_back(r.id.substr(5));                    // "dlog.colony" -> "colony"
    std::sort(ids.begin(), ids.end());
    return ids;
}

static bool dd_screen_load(const std::string& id, JsonValue& out) {
    const Record* r = store_find(g_store, "dlog." + id);
    if (!r) return false;
    out = JsonValue{}; out.type = JsonValue::Object;
    out.obj["id"] = json_str(id);
    for (const auto& f : r->fields)
        if (f.name != "notes") out.obj[f.name] = value_to_json(f.value);
    return true;
}

static bool dd_screen_save(const std::string& id, const JsonValue& screen, std::string& err) {
    const std::string rid = "dlog." + id;
    if (!store_find(g_store, rid)) {                      // new screen: add COMPLETE
        Record nr; nr.id = rid;                           // (store_add validates required fields)
        for (const char* f : {"name", "background", "size", "widgets"})
            if (const JsonValue* v = screen.find(f))
                nr.fields.push_back({f, json_any_to_value(*v)});
        return store_add(g_store, std::move(nr), err);
    }
    for (const char* f : {"name", "background", "size", "widgets"}) {
        const JsonValue* v = screen.find(f);
        if (!v) continue;
        Value val = json_any_to_value(*v);
        const Record* cur = store_find(g_store, rid);
        const Value* old = cur ? cur->find(f) : nullptr;
        if (old && value_equal(*old, val)) continue;      // unchanged: keep the journal clean
        if (!store_set(g_store, rid, f, &val, err)) return false;
    }
    return true;
}

static const DDScreenHooks DD_SCREEN_HOOKS = {dd_screen_list, dd_screen_load, dd_screen_save};

// ---- GRPH/EVNT consumer cutover: the node-graph CRUD (EVNT-0/1) -------------------
// Behavior lives in the store two ways: pure exec chains as TYPED evnt records
// (spec 8 steps -- the legible outline form), everything else as lossless grph
// records. The Logic canvas + run_graph/FireEvent flow through this CRUD; a
// canvas save reclassifies (still a chain -> evnt, gained branches -> grph),
// and every save is a journaled store edit.

// The FULL typed event form (spec 8, EVNT-3). Exec flow decompiles to a
// nested step tree: { do = <Type>, ...params, args = { <pin> = "$<var>" },
// branches = [{ pin = <label>, steps = [...] }] }, the 'out' continuation
// being the next step in the enclosing list. Data producers hoist to `vars`
// (a DAG keyed by original node id; sharing is exact -- one node, many
// consumers -- so an impure Roll still rolls once). Exec JOINS are walked once
// per inbound path -- the tail is DUPLICATED (behavior identical: each run
// executes one path). Comments carry losslessly. Only true cycles,
// multi-triggers and mixed/multi-'out' pins fall back to the lossless grph
// form. The type key is `do` ("op" is a real Math/Compare param); compiled
// synthetic node ids are '#'-prefixed (no authored id starts with '#').
// Deepest nesting level of a value tree (scalar/empty container = 0; each
// enclosing container +1) == the deepest recursion the canonical-text parser
// makes, which it refuses past 32. A typed tree beyond that must stay in the
// flat grph form -- otherwise the written record would fail to PARSE at boot.
static int json_depth(const JsonValue& v) {
    int d = 0;
    if (v.type == JsonValue::Array)
        for (const JsonValue& c : v.arr) d = std::max(d, 1 + json_depth(c));
    else if (v.type == JsonValue::Object)
        for (const auto& [k, c] : v.obj) d = std::max(d, 1 + json_depth(c));
    return d;
}

static bool graph_as_typed(const JsonValue& graph, JsonValue& vars_out,
                           JsonValue& steps_out, JsonValue& comments_out) {
    const JsonValue* nodes = graph.find("nodes");
    if (!nodes || !nodes->is_array()) return false;
    const JsonValue* trig = nullptr;
    std::map<std::string, const JsonValue*> byid;
    std::set<std::string> comment_ids;
    comments_out = JsonValue{}; comments_out.type = JsonValue::Array;
    for (const JsonValue& n : nodes->arr) {
        const JsonValue* ty = n.find("type");
        const JsonValue* nid = n.find("id");
        if (!ty || !nid) return false;
        // ('#'-prefixed ids are legitimate here: the compiler emits synthetic
        // #s/#c ids for steps/comments, whose ids the typed form discards --
        // only PRODUCER ids round-trip and are checked below)
        if (nid->str.empty()) return false;
        if (!byid.emplace(nid->str, &n).second) return false;     // duplicate node id
        if (const JsonValue* p = n.find("params"); p && !p->is_object())
            return false;                                         // params must be a dict
        if (ty->str == "Comment") {
            comment_ids.insert(nid->str);
            JsonValue c; c.type = JsonValue::Object;
            const JsonValue* p = n.find("params");
            if (p)                             // lossless means text-only string comments
                for (const auto& [k, v] : p->obj)
                    if (k != "text" || v.type != JsonValue::String) return false;
            c.obj["text"] = json_str(p && p->find("text") ? p->find("text")->str : "");
            c.obj["x"] = json_num(n.find("x") ? n.find("x")->num : 0);
            c.obj["y"] = json_num(n.find("y") ? n.find("y")->num : 0);
            comments_out.arr.push_back(std::move(c));
            continue;
        }
        if (ty->str.rfind("On", 0) == 0) { if (trig) return false; trig = &n; }
    }
    if (!trig) return false;
    // edges: exec successors (pin -> target) and data feeds (pin <- producer)
    std::map<std::string, std::map<std::string, std::string>> succ;   // node -> pin -> target
    std::map<std::string, std::map<std::string, std::string>> data_in; // node -> pin -> producer
    std::set<std::string> has_exec;
    if (const JsonValue* edges = graph.find("edges"); edges && edges->is_array())
        for (const JsonValue& e : edges->arr) {
            const JsonValue* f = e.find("from");
            const JsonValue* t = e.find("to");
            if (!f || !t || !f->find("node") || !t->find("node") ||
                !f->find("pin") || !t->find("pin")) return false;
            const std::string fn = f->find("node")->str, tn = t->find("node")->str;
            if (comment_ids.count(fn) || comment_ids.count(tn)) return false;
            if (t->find("pin")->str == "in") {             // exec edge
                if (!succ[fn].emplace(f->find("pin")->str, tn).second)
                    return false;                          // duplicate pin (multi-out)
                has_exec.insert(fn); has_exec.insert(tn);
            } else {                                       // data edge
                if (f->find("pin")->str != "value") return false;
                if (!data_in[tn].emplace(t->find("pin")->str, fn).second)
                    return false;                          // two feeds into one pin
            }
        }
    std::set<std::string> producers;
    for (const auto& [tn, feeds] : data_in)
        for (const auto& [pin, src] : feeds) producers.insert(src);
    for (const std::string& pid : producers) {
        if (has_exec.count(pid)) return false;             // producers never exec
        auto b = byid.find(pid);
        if (b == byid.end() || b->second->find("type")->str.rfind("On", 0) == 0)
            return false;
        if (pid[0] == '#') return false;                   // reserved synthetic prefix
    }
    for (const auto& [n, pins] : succ)                     // no out+label mix
        if (pins.count("out") && pins.size() > 1) return false;
    // vars: every producer, sorted by id (std::set iterates sorted)
    vars_out = JsonValue{}; vars_out.type = JsonValue::Array;
    for (const std::string& pid : producers) {
        const JsonValue* pn = byid[pid];
        JsonValue v; v.type = JsonValue::Object;
        v.obj["do"] = json_str(pn->find("type")->str);
        v.obj["id"] = json_str(pid);
        if (const JsonValue* pp = pn->find("params"); pp && pp->is_object())
            for (const auto& [k, val] : pp->obj) {
                if (k == "do" || k == "id" || k == "args") return false;
                v.obj[k] = val;
            }
        if (auto di = data_in.find(pid); di != data_in.end()) {
            JsonValue args; args.type = JsonValue::Object;
            for (const auto& [pin, src] : di->second)
                args.obj[pin] = json_str("$" + src);
            v.obj["args"] = std::move(args);
        }
        vars_out.arr.push_back(std::move(v));
    }
    // exec tree with per-path cycle detection; joins re-walk (tail duplication)
    std::set<std::string> emitted;
    std::function<bool(const std::string&, std::set<std::string>, JsonValue&)> walk =
        [&](const std::string& start, std::set<std::string> path, JsonValue& list) -> bool {
        list = JsonValue{}; list.type = JsonValue::Array;
        std::string cur = start;
        while (!cur.empty()) {
            if (path.count(cur)) return false;             // true cycle
            path.insert(cur);
            auto b = byid.find(cur);
            if (b == byid.end()) return false;
            const JsonValue* n = b->second;
            JsonValue step; step.type = JsonValue::Object;
            step.obj["do"] = json_str(n->find("type")->str);
            if (const JsonValue* p = n->find("params"); p && p->is_object())
                for (const auto& [k, v] : p->obj) {
                    if (k == "do" || k == "args" || k == "branches") return false;
                    step.obj[k] = v;
                }
            if (auto di = data_in.find(cur); di != data_in.end()) {
                JsonValue args; args.type = JsonValue::Object;
                for (const auto& [pin, src] : di->second)
                    args.obj[pin] = json_str("$" + src);
                step.obj["args"] = std::move(args);
            }
            emitted.insert(cur);
            std::string nxt;
            JsonValue branches; branches.type = JsonValue::Array;
            if (auto s = succ.find(cur); s != succ.end())
                for (const auto& [pin, tgt] : s->second) { // std::map: pin-sorted
                    if (pin == "out") { nxt = tgt; continue; }
                    JsonValue br; br.type = JsonValue::Object;
                    br.obj["pin"] = json_str(pin);
                    JsonValue body;
                    if (!walk(tgt, path, body)) return false;
                    br.obj["steps"] = std::move(body);
                    branches.arr.push_back(std::move(br));
                }
            if (!branches.arr.empty()) step.obj["branches"] = std::move(branches);
            list.arr.push_back(std::move(step));
            cur = nxt;
        }
        return true;
    };
    if (!walk(trig->find("id")->str, {}, steps_out)) return false;
    // coverage: every non-comment node is exec-reached or a producer
    for (const auto& [nid, n] : byid)
        if (!comment_ids.count(nid) && !emitted.count(nid) && !producers.count(nid))
            return false;
    if (json_depth(steps_out) > 32) return false;          // parser nesting guard
    return true;
}

// evnt record -> graph JSON the interpreter runs. Deterministic layout: the
// exec tree left-to-right/top-down, vars in a column beneath, comments verbatim.
static bool dd_compile_evnt(const Record& r, const std::string& id, JsonValue& out) {
    const Value* steps = r.find("steps");
    if (!steps || steps->kind != ValKind::List) return false;
    // step 0 of the top list must be the On* trigger, or run_graph/FireEvent
    // would have no entry point and the compiled graph silently does nothing
    if (steps->list.empty() || steps->list[0].kind != ValKind::Dict) return false;
    if (const Value* d0 = steps->list[0].dict_get("do");
        !d0 || d0->kind != ValKind::Str || d0->s.rfind("On", 0) != 0) return false;
    out = JsonValue{}; out.type = JsonValue::Object;
    out.obj["id"] = json_str(id);
    if (const Value* n = r.find("name"); n && n->kind == ValKind::Str)
        out.obj["name"] = json_str(n->s);
    JsonValue nodes; nodes.type = JsonValue::Array;
    JsonValue edges; edges.type = JsonValue::Array;
    auto edge = [&](const std::string& an, const std::string& ap,
                    const std::string& bn, const std::string& bp) {
        JsonValue e; e.type = JsonValue::Object;
        JsonValue f; f.type = JsonValue::Object;
        f.obj["node"] = json_str(an); f.obj["pin"] = json_str(ap);
        JsonValue t; t.type = JsonValue::Object;
        t.obj["node"] = json_str(bn); t.obj["pin"] = json_str(bp);
        e.obj["from"] = std::move(f); e.obj["to"] = std::move(t);
        edges.arr.push_back(std::move(e));
    };
    // vars first: node id = var id verbatim (round-trips), args -> data edges.
    // Pass 1 collects the ids (the DAG may reference forward) so every "$ref"
    // -- var or step args -- is checked to name a REAL var, not a ghost edge
    // that would shadow a same-named param and silently evaluate to 0.
    std::set<std::string> var_ids;
    const Value* vars = r.find("vars");
    if (vars) {
        if (vars->kind != ValKind::List) return false;
        for (const Value& v : vars->list) {
            if (v.kind != ValKind::Dict) return false;
            const Value* vid = v.dict_get("id");
            if (!vid || vid->kind != ValKind::Str || vid->s.empty() || vid->s[0] == '#')
                return false;
            if (!var_ids.insert(vid->s).second) return false;   // duplicate var id
        }
    }
    auto var_ref = [&](const Value& ref) {                 // "$id" naming a var
        return ref.kind == ValKind::Str && ref.s.size() > 1 && ref.s[0] == '$' &&
               var_ids.count(ref.s.substr(1)) != 0;
    };
    if (vars) {
        double vy = 420;
        for (const Value& v : vars->list) {
            JsonValue pn; pn.type = JsonValue::Object;
            JsonValue pp; pp.type = JsonValue::Object;
            std::string vid;
            for (size_t k = 0; k < v.keys.size(); ++k) {
                const std::string& key = v.keys[k];
                if (key == "do") {
                    if (v.list[k].kind != ValKind::Str) return false;
                    pn.obj["type"] = json_str(v.list[k].s);
                    continue;
                }
                if (key == "id") { vid = v.list[k].s; continue; }
                if (key == "args") {
                    const Value& a = v.list[k];
                    if (a.kind != ValKind::Dict) return false;
                    for (size_t q = 0; q < a.keys.size(); ++q)
                        if (!var_ref(a.list[q])) return false;
                    continue;
                }
                pp.obj[key] = value_to_json(v.list[k]);
            }
            if (!pn.find("type")) return false;            // a var must carry 'do'
            pn.obj["id"] = json_str(vid);
            pn.obj["x"] = json_num(40);
            pn.obj["y"] = json_num(vy); vy += 70;
            pn.obj["params"] = std::move(pp);
            nodes.arr.push_back(std::move(pn));
            if (const Value* a = v.dict_get("args"))
                for (size_t q = 0; q < a->keys.size(); ++q)
                    edge(a->list[q].s.substr(1), "value", vid, a->keys[q]);
        }
    }
    // exec tree: nodes #s<counter>, DFS; branch pin edges to each body's head
    int counter = 0;
    std::function<bool(const Value&, int, std::string&)> emit_list =
        [&](const Value& list, int depth, std::string& head) -> bool {
        if (list.kind != ValKind::List) return false;
        std::string prev;
        head.clear();
        for (size_t si = 0; si < list.list.size(); ++si) {
            const Value& s = list.list[si];
            if (s.kind != ValKind::Dict) return false;
            const std::string sid = "#s" + std::to_string(counter++);
            if (head.empty()) head = sid;
            JsonValue n; n.type = JsonValue::Object;
            n.obj["id"] = json_str(sid);
            n.obj["x"] = json_num(40.0 + 220.0 * (double)(counter - 1));
            n.obj["y"] = json_num(60.0 + 90.0 * (double)depth);
            JsonValue params; params.type = JsonValue::Object;
            const Value* branches = nullptr;
            for (size_t k = 0; k < s.keys.size(); ++k) {
                const std::string& key = s.keys[k];
                if (key == "do") { n.obj["type"] = json_str(s.list[k].s); continue; }
                if (key == "branches") { branches = &s.list[k]; continue; }
                if (key == "args") {
                    const Value& a = s.list[k];
                    if (a.kind != ValKind::Dict) return false;
                    for (size_t q = 0; q < a.keys.size(); ++q) {
                        if (!var_ref(a.list[q])) return false;
                        edge(a.list[q].s.substr(1), "value", sid, a.keys[q]);
                    }
                    continue;
                }
                params.obj[key] = value_to_json(s.list[k]);
            }
            if (!n.find("type")) return false;
            n.obj["params"] = std::move(params);
            nodes.arr.push_back(std::move(n));
            if (!prev.empty()) edge(prev, "out", sid, "in");
            prev = sid;
            if (branches) {
                // the interpreter never follows 'out' from a branching node
                // (Branch/Switch resolve a labeled pin), so a sibling after a
                // branch-bearing step would be silently dead code -- reject
                if (si + 1 != list.list.size()) return false;
                if (branches->kind != ValKind::List) return false;
                std::set<std::string> seen_pins;
                for (const Value& br : branches->list) {
                    if (br.kind != ValKind::Dict) return false;
                    const Value* pin = br.dict_get("pin");
                    const Value* body = br.dict_get("steps");
                    if (!pin || pin->kind != ValKind::Str || pin->s == "out" || !body)
                        return false;
                    if (!seen_pins.insert(pin->s).second) return false;
                    // an empty body would emit no edge, and a Switch with no
                    // edge for a value pin falls through to 'default' -- the
                    // typed form cannot hold an explicit empty case
                    if (body->kind != ValKind::List || body->list.empty()) return false;
                    std::string bhead;
                    if (!emit_list(*body, depth + 1, bhead)) return false;
                    edge(sid, pin->s, bhead, "in");
                }
            }
        }
        return true;
    };
    std::string head;
    if (!emit_list(*steps, 0, head)) return false;
    if (const Value* cs = r.find("comments"); cs && cs->kind == ValKind::List)
        for (size_t j = 0; j < cs->list.size(); ++j) {
            const Value& c = cs->list[j];
            if (c.kind != ValKind::Dict) continue;
            JsonValue cn; cn.type = JsonValue::Object;
            cn.obj["id"] = json_str("#c" + std::to_string(j));
            cn.obj["type"] = json_str("Comment");
            JsonValue cp; cp.type = JsonValue::Object;
            for (size_t k = 0; k < c.keys.size(); ++k) {
                if (c.keys[k] == "x") cn.obj["x"] = value_to_json(c.list[k]);
                else if (c.keys[k] == "y") cn.obj["y"] = value_to_json(c.list[k]);
                else cp.obj[c.keys[k]] = value_to_json(c.list[k]);
            }
            cn.obj["params"] = std::move(cp);
            nodes.arr.push_back(std::move(cn));
        }
    out.obj["nodes"] = std::move(nodes);
    out.obj["edges"] = std::move(edges);
    return true;
}

static std::vector<std::string> dd_graph_list() {
    std::vector<std::string> ids;
    for (const char* ty : {"grph", "evnt"}) {
        auto ti = g_store.type_index.find(ty);
        if (ti == g_store.type_index.end()) continue;
        for (const Record& r : g_store.records[ti->second])
            ids.push_back(r.id.substr(5));                // "grph.combat" -> "combat"
    }
    std::sort(ids.begin(), ids.end());
    // a grph/evnt twin pair (possible via the generic /api/dd/add or a
    // hand-authored data tree) must not list its id twice
    ids.erase(std::unique(ids.begin(), ids.end()), ids.end());
    return ids;
}

static bool dd_graph_load(const std::string& id, JsonValue& out) {
    if (const Record* r = store_find(g_store, "grph." + id)) {
        out = JsonValue{}; out.type = JsonValue::Object;
        out.obj["id"] = json_str(id);
        for (const auto& f : r->fields)
            if (f.name != "notes") out.obj[f.name] = value_to_json(f.value);
        return true;
    }
    if (const Record* r = store_find(g_store, "evnt." + id))
        return dd_compile_evnt(*r, id, out);
    return false;
}

static bool dd_graph_save(const std::string& id, const JsonValue& graph, std::string& err) {
    JsonValue vars, steps, comments;
    const bool typed = graph_as_typed(graph, vars, steps, comments);
    const bool has_vars = typed && !vars.arr.empty();
    const bool has_comments = typed && !comments.arr.empty();
    // Structural pre-check BEFORE any mutation. The update path below applies
    // field-by-field through store_set; without this, a payload that passes
    // the first put but fails a later one (e.g. name-only, no nodes) would
    // half-apply -- name committed, journaled and flushed, save reported
    // failed. After this check every remaining put is either guaranteed valid
    // (decompiler output) or an optional-field clear.
    if (!typed) {
        const JsonValue* nn = graph.find("nodes");
        if (!nn || !nn->is_array()) { err = "graph needs a nodes array"; return false; }
        for (const JsonValue& n : nn->arr)
            if (!n.is_object()) { err = "graph nodes must be objects"; return false; }
        if (const JsonValue* ee = graph.find("edges")) {
            if (!ee->is_array()) { err = "graph edges must be a list"; return false; }
            for (const JsonValue& e : ee->arr)
                if (!e.is_object()) { err = "graph edges must be objects"; return false; }
        }
    }
    if (const JsonValue* n = graph.find("name"); n && n->type != JsonValue::String) {
        err = "graph name must be a string";
        return false;
    }
    const std::string rid = std::string(typed ? "evnt." : "grph.") + id;
    const std::string other = std::string(typed ? "grph." : "evnt.") + id;
    // reclassification is ADD-then-DELETE: if the new form failed validation
    // after the twin were already deleted, the graph would be destroyed (and
    // the next dd-save would drop its .rec from disk)
    auto drop_twin = [&]() {
        return !store_find(g_store, other) || store_delete(g_store, other, err);
    };
    if (!store_find(g_store, rid)) {                      // new/reclassified: add COMPLETE
        Record nr; nr.id = rid;                           // (store_add validates required fields)
        if (const JsonValue* n = graph.find("name"))
            nr.fields.push_back({"name", json_any_to_value(*n)});
        if (typed) {
            if (has_vars) nr.fields.push_back({"vars", json_any_to_value(vars)});
            nr.fields.push_back({"steps", json_any_to_value(steps)});
            if (has_comments)
                nr.fields.push_back({"comments", json_any_to_value(comments)});
        } else {
            if (const JsonValue* v = graph.find("nodes"))
                nr.fields.push_back({"nodes", json_any_to_value(*v)});
            if (const JsonValue* v = graph.find("edges"))
                nr.fields.push_back({"edges", json_any_to_value(*v)});
        }
        // the canvas never carries the record's prose -- carry it across the
        // reclassification instead of silently destroying it
        if (const Record* tw = store_find(g_store, other))
            if (const Value* notes = tw->find("notes"))
                nr.fields.push_back({"notes", *notes});
        if (!store_add(g_store, std::move(nr), err)) return false;
        return drop_twin();
    }
    auto put = [&](const char* f, const JsonValue* v) {
        const Record* cur = store_find(g_store, rid);
        const Value* old = cur ? cur->find(f) : nullptr;
        if (!v) {                                         // clear (e.g. last comment removed)
            if (!old) return true;
            return store_set(g_store, rid, f, nullptr, err);
        }
        Value val = json_any_to_value(*v);
        if (old && value_equal(*old, val)) return true;   // unchanged: keep the journal clean
        return store_set(g_store, rid, f, &val, err);
    };
    if (!put("name", graph.find("name"))) return false;
    if (typed) {
        if (!put("vars", has_vars ? &vars : nullptr)) return false;
        if (!put("steps", &steps)) return false;
        if (!put("comments", has_comments ? &comments : nullptr)) return false;
    } else {
        if (!put("nodes", graph.find("nodes"))) return false;
        if (!put("edges", graph.find("edges"))) return false;
    }
    return drop_twin();                                   // update landed: clear any stale twin
}


static const DDScreenHooks DD_GRAPH_HOOKS = {dd_graph_list, dd_graph_load, dd_graph_save};

// ---- SCEN consumer cutover: scenario seed data -----------------------------------
std::vector<std::string> drydock_scenario_ids() {
    std::vector<std::string> ids;
    if (!g_ready) return ids;
    auto ti = g_store.type_index.find("scen");
    if (ti == g_store.type_index.end()) return ids;
    for (const Record& r : g_store.records[ti->second])
        ids.push_back(r.id.substr(5));                    // "scen.new_world" -> "new_world"
    std::sort(ids.begin(), ids.end());
    return ids;
}

bool drydock_scenario_json(const std::string& id, JsonValue& out) {
    if (!g_ready) return false;
    const Record* r = store_find(g_store, "scen." + id);
    if (!r) return false;
    out = JsonValue{}; out.type = JsonValue::Object;
    out.obj["id"] = json_str(id);
    for (const auto& f : r->fields)
        out.obj[f.name == "notes" ? "_doc" : f.name] = value_to_json(f.value);
    return true;
}

// ---- SPRT/PLTT consumer cutover --------------------------------------------------
// The sprite catalog (/api/sprites -> web SPRITECAT keyed by the verbatim sid)
// and the palette asset (/assets/palette.json -> NVPAL) rebuild from the store.
bool drydock_sprites_json(std::string& out) {
    if (!g_ready) return false;
    auto ti = g_store.type_index.find("sprt");
    if (ti == g_store.type_index.end()) return false;
    JsonValue rows; rows.type = JsonValue::Array;
    for (const Record& r : g_store.records[ti->second]) {
        JsonValue o; o.type = JsonValue::Object;
        auto s = [&](const char* f) { const Value* x = r.find(f);
            return (x && x->kind == ValKind::Str) ? x->s : std::string(); };
        auto i = [&](const char* f) { const Value* x = r.find(f);
            return (x && x->kind == ValKind::Int) ? (int)x->i : 0; };
        o.obj["id"] = json_str(s("sid"));               // consumers key on the catalog id
        o.obj["label"] = json_str(s("label"));
        o.obj["kind"] = json_str(s("kind"));
        if (const Value* x = r.find("sheet")) o.obj["sheet"] = json_str(x->s);
        if (const Value* x = r.find("frame")) o.obj["frame"] = json_num((double)x->i);
        if (const Value* x = r.find("file"))  o.obj["file"] = json_str(x->s);
        o.obj["w"] = json_num(i("w"));
        o.obj["h"] = json_num(i("h"));
        rows.arr.push_back(std::move(o));
    }
    JsonValue doc; doc.type = JsonValue::Object;
    doc.obj["count"] = json_num((double)rows.arr.size());
    doc.obj["sprites"] = std::move(rows);
    out = json_dump(doc);
    return true;
}

bool drydock_palette_json(std::string& out) {
    if (!g_ready) return false;
    const Record* r = store_find(g_store, "pltt.viceroy");
    const Value* cols = r ? r->find("colors") : nullptr;
    if (!cols || cols->kind != ValKind::List) return false;
    JsonValue arr; arr.type = JsonValue::Array;
    for (size_t i = 0; i < cols->list.size(); ++i) {
        const std::string& hex = cols->list[i].s;       // "#rrggbb"
        if (cols->list[i].kind != ValKind::Str || hex.size() != 7) continue;
        auto hx = [&](int off) { return (int)std::strtol(hex.substr(off, 2).c_str(), nullptr, 16); };
        JsonValue o; o.type = JsonValue::Object;
        o.obj["index"] = json_num((double)i);
        o.obj["r"] = json_num(hx(1));
        o.obj["g"] = json_num(hx(3));
        o.obj["b"] = json_num(hx(5));
        o.obj["hex"] = json_str(hex);
        arr.arr.push_back(std::move(o));
    }
    out = json_dump(arr);
    return true;
}

bool drydock_messages_json(std::string& out) {
    if (!g_ready) return false;
    JsonValue rows; rows.type = JsonValue::Array;
    for (const auto& [key, id] : g_msg_index) {
        DDMsgView v = dd_message_provider(key);
        if (!v.found) continue;
        JsonValue o; o.type = JsonValue::Object;
        o.obj["key"] = json_str(key);
        o.obj["text"] = json_str(v.text);
        o.obj["box_w"] = json_num(v.box_w);
        o.obj["x"] = json_num(v.x);
        o.obj["y"] = json_num(v.y);
        o.obj["sprite"] = json_str(v.sprite);
        o.obj["speaker"] = json_str(v.speaker);
        o.obj["default"] = json_str(v.def);
        rows.arr.push_back(std::move(o));
    }
    JsonValue doc; doc.type = JsonValue::Object;
    doc.obj["messages"] = std::move(rows);
    out = json_dump(doc);
    return true;
}

// after any mutation: keep the live game's rules AND the legacy JSON readers in
// lockstep with the store. CONF applies live too (P5: the store is the single
// rules authority; the overlay is subsumed as an import/export format).
static void sync_rules(vc::sim::RuleData* rd) {
    drydock_repatch_tables();
    rebuild_msg_index();               // key edits retarget the @KEY lookups
    rebuild_text_index();
    if (!rd) return;
    std::vector<Record> all;
    for (const auto& bucket : g_store.records)
        for (const auto& r : bucket) all.push_back(r);
    drydock_apply_records(*rd, all, /*include_conf=*/true);
}

// ---- init ----------------------------------------------------------------------

bool drydock_store_init(const std::string& data_dir, std::string& msg,
                        const std::string& pack_path) {
    std::vector<Record> schm, recs;
    std::string err;
    bool from_pack = false;
    if (!pack_path.empty()) {
        // release path: the drydockc pack carries schema + data in one artifact
        std::vector<Record> all;
        if (!pack_read(pack_path, all, err)) { msg = pack_path + ": " + err; return false; }
        for (auto& r : all)
            (r.type() == "schm" ? schm : recs).push_back(std::move(r));
        from_pack = true;
    } else {
        struct stat st{};
        if (stat((data_dir + "/base").c_str(), &st) != 0) { msg = "no " + data_dir + "/base"; return false; }
        std::vector<std::string> files;
        walk(data_dir + "/schema", files);
        for (const auto& p : files)
            if (!parse_records(slurp(p), schm, err)) { msg = p + ": " + err; return false; }
        files.clear();
        walk(data_dir + "/base", files);
        for (const auto& p : files)
            if (!parse_records(slurp(p), recs, err)) { msg = p + ": " + err; return false; }
    }
    Schema sc;
    if (!schema_load(schm, sc, err)) { msg = err; return false; }
    // the registry describes itself (spec §7 / migration order item 8): the
    // schm.* records join the store, browsable like any type -- schm.schm is
    // the meta-schema fixed point. Live schm edits are data-only until the
    // next rebuild regenerates dd_gen.hpp (noted in the meta-schema doc).
    for (auto& r : schm) recs.push_back(r);
    for (auto& r : recs)
        if (!schema_canonicalize(sc, r, err)) { msg = err; return false; }
    g_store = Store{};
    if (!store_init(g_store, std::move(sc), std::move(recs), err)) { msg = err; return false; }
    g_data_dir = data_dir;
    g_ready = true;
    drydock_repatch_tables();      // legacy JSON readers follow the store from boot
    rebuild_msg_index();
    rebuild_text_index();
    dd_message_hook = dd_message_provider;   // @KEY message lookups cut over
    dd_screen_hooks = &DD_SCREEN_HOOKS;      // screen CRUD cut over to dlog records
    dd_graph_hooks  = &DD_GRAPH_HOOKS;       // graph CRUD cut over to grph records
    size_t n = 0;
    for (const auto& b : g_store.records) n += b.size();
    msg = "drydock store: " + std::to_string(g_store.type_codes.size()) + " types, " +
          std::to_string(n) + " records" +
          (from_pack ? " (from pack " + pack_path + ")" : " (from canonical text)");
    return true;
}

bool drydock_handles(const std::string& path) { return path.rfind("/api/dd/", 0) == 0; }
bool drydock_active() { return g_ready; }
drydock::Store* drydock_store() { return g_ready ? &g_store : nullptr; }

// ---- save: dirty records -> canonical text, one per file -------------------------

int drydock_save_dirty(std::string& summary, int* removed_out) {
    int written = 0, removed = 0;
    for (const auto& id : g_store.dirty) {
        auto dot = id.find('.');
        // schm records ARE the schema files (data/schema/<code>.rec); everything
        // else is one-record-per-file under data/base/<type>/
        std::string dir = (id.rfind("schm.", 0) == 0) ? g_data_dir + "/schema"
                                                      : g_data_dir + "/base/" + id.substr(0, dot);
        std::string path = dir + "/" + id.substr(dot + 1) + ".rec";
        const Record* r = store_find(g_store, id);
        if (!r) { std::remove(path.c_str()); ++removed; continue; }
#ifdef _WIN32
        mkdir(dir.c_str());
#else
        mkdir(dir.c_str(), 0755);
#endif
        std::ofstream f(path);
        f << serialize_record(*r);
        ++written;
    }
    g_store.dirty.clear();
    summary = std::to_string(written) + " written, " + std::to_string(removed) + " removed";
    if (removed_out) *removed_out = removed;
    return written;
}

static HttpResponse dd_save() {
    std::string summary;
    int removed = 0;
    int written = drydock_save_dirty(summary, &removed);
    JsonValue o; o.type = JsonValue::Object;
    o.obj["written"] = json_num(written);
    o.obj["removed"] = json_num(removed);
    return {200, "application/json", json_dump(o)};
}

// ---- the routes ------------------------------------------------------------------

HttpResponse drydock_route(const std::string& method, const std::string& path,
                           const std::string& query, const std::string& body,
                           vc::sim::RuleData* live_rules) {
    auto J = [](int st, const JsonValue& v) { return HttpResponse{st, "application/json", json_dump(v)}; };
    auto ERR = [&](int st, const std::string& m) {
        JsonValue o; o.type = JsonValue::Object;
        o.obj["error"] = json_str(m);
        return J(st, o);
    };
    if (!g_ready) return ERR(503, "drydock store not loaded");

    if (path == "/api/dd/types") {                       // Object Window tree
        JsonValue a; a.type = JsonValue::Array;
        for (size_t t = 0; t < g_store.type_codes.size(); ++t) {
            JsonValue o; o.type = JsonValue::Object;
            o.obj["code"] = json_str(g_store.type_codes[t]);
            o.obj["count"] = json_num((double)g_store.records[t].size());
            const TypeDef* td = g_store.schema.find(g_store.type_codes[t]);
            JsonValue fs; fs.type = JsonValue::Array;
            if (td) for (const auto& fd : td->fields) {
                JsonValue f; f.type = JsonValue::Object;
                f.obj["name"] = json_str(fd.name);
                f.obj["kind"] = json_num((double)(int)fd.type);
                if (fd.type == FType::Ref) f.obj["ref"] = json_str(fd.ref_type);
                if (fd.min) f.obj["min"] = json_num((double)*fd.min);
                if (fd.max) f.obj["max"] = json_num((double)*fd.max);
                f.obj["required"] = json_num(fd.required ? 1 : 0);
                if (!fd.doc.empty()) f.obj["doc"] = json_str(fd.doc);
                fs.arr.push_back(f);
            }
            o.obj["fields"] = fs;
            a.arr.push_back(o);
        }
        return J(200, a);
    }

    if (path == "/api/dd/records") {                     // grid rows for one type
        std::string type = dd_qparam(query, "type");
        auto ti = g_store.type_index.find(type);
        if (ti == g_store.type_index.end()) return ERR(404, "unknown type " + type);
        JsonValue a; a.type = JsonValue::Array;
        for (const Record& r : g_store.records[ti->second]) {
            JsonValue o; o.type = JsonValue::Object;
            o.obj["id"] = json_str(r.id);
            o.obj["dirty"] = json_num(g_store.dirty.count(r.id) ? 1 : 0);
            for (const auto& f : r.fields) o.obj[f.name] = value_to_json(f.value);
            a.arr.push_back(o);
        }
        return J(200, a);
    }

    if (path == "/api/dd/record") {                      // one record + its text + used-by
        std::string id = dd_qparam(query, "id");
        const Record* r = store_find(g_store, id);
        if (!r) return ERR(404, "no record " + id);
        JsonValue o; o.type = JsonValue::Object;
        o.obj["id"] = json_str(r->id);
        JsonValue fs; fs.type = JsonValue::Object;
        for (const auto& f : r->fields) fs.obj[f.name] = value_to_json(f.value);
        o.obj["fields"] = fs;
        o.obj["text"] = json_str(serialize_record(*r));
        JsonValue ub; ub.type = JsonValue::Array;
        for (const auto& [src, field] : store_used_by(g_store, id)) {
            JsonValue u; u.type = JsonValue::Object;
            u.obj["src"] = json_str(src);
            u.obj["field"] = json_str(field);
            ub.arr.push_back(u);
        }
        o.obj["used_by"] = ub;
        o.obj["dirty"] = json_num(g_store.dirty.count(id) ? 1 : 0);
        return J(200, o);
    }

    if (path == "/api/dd/set" && method == "POST") {     // THE edit chokepoint
        JsonValue b = json_parse(body);
        const JsonValue* id = b.find("id");
        const JsonValue* field = b.find("field");
        const JsonValue* val = b.find("value");          // absent/null => clear
        if (!id || !field) return ERR(400, "need {id, field, value?}");
        const Record* r = store_find(g_store, id->str);
        if (!r) return ERR(404, "no record " + id->str);
        const TypeDef* td = g_store.schema.find(r->type());
        const FieldDef* fd = td ? td->find(field->str) : nullptr;
        if (!fd) return ERR(400, "unknown field " + field->str);
        std::string err;
        if (val && val->type != JsonValue::Null) {
            Value v;
            if (!json_to_value(*val, *fd, v, err)) return ERR(400, field->str + ": " + err);
            if (!store_set(g_store, id->str, field->str, &v, err)) return ERR(400, err);
        } else {
            if (!store_set(g_store, id->str, field->str, nullptr, err)) return ERR(400, err);
        }
        sync_rules(live_rules);
        JsonValue o; o.type = JsonValue::Object;
        o.obj["ok"] = json_num(1);
        return J(200, o);
    }

    if (path == "/api/dd/add" && method == "POST") {     // duplicate-as-new / new record
        JsonValue b = json_parse(body);
        const JsonValue* id = b.find("id");
        const JsonValue* from = b.find("from");          // optional: copy fields from
        if (!id) return ERR(400, "need {id, from?}");
        Record nr;
        nr.id = id->str;
        if (from && from->type == JsonValue::String) {
            const Record* src = store_find(g_store, from->str);
            if (!src) return ERR(404, "no record " + from->str);
            nr.fields = src->fields;
        }
        std::string err;
        if (!store_add(g_store, std::move(nr), err)) return ERR(400, err);
        sync_rules(live_rules);
        JsonValue o; o.type = JsonValue::Object;
        o.obj["ok"] = json_num(1);
        return J(200, o);
    }

    if (path == "/api/dd/delete" && method == "POST") {  // ref-checked
        JsonValue b = json_parse(body);
        const JsonValue* id = b.find("id");
        if (!id) return ERR(400, "need {id}");
        std::string err;
        if (!store_delete(g_store, id->str, err)) return ERR(409, err);
        sync_rules(live_rules);
        JsonValue o; o.type = JsonValue::Object;
        o.obj["ok"] = json_num(1);
        return J(200, o);
    }

    if ((path == "/api/dd/undo" || path == "/api/dd/redo") && method == "POST") {
        std::string err;
        bool ok = (path == "/api/dd/undo") ? store_undo(g_store, err) : store_redo(g_store, err);
        if (!ok) return ERR(409, err);
        sync_rules(live_rules);
        JsonValue o; o.type = JsonValue::Object;
        o.obj["ok"] = json_num(1);
        o.obj["undo_depth"] = json_num((double)g_store.journal_pos);
        o.obj["redo_depth"] = json_num((double)(g_store.journal.size() - g_store.journal_pos));
        return J(200, o);
    }

    if (path == "/api/dd/save" && method == "POST") return dd_save();

    if (path == "/api/dd/status") {
        JsonValue o; o.type = JsonValue::Object;
        o.obj["dirty"] = json_num((double)g_store.dirty.size());
        o.obj["undo_depth"] = json_num((double)g_store.journal_pos);
        o.obj["redo_depth"] = json_num((double)(g_store.journal.size() - g_store.journal_pos));
        return J(200, o);
    }

    return ERR(404, "unknown drydock route " + path);
}

} // namespace forge
