// forge/drydock_bridge -- populate RuleData from the Drydock canonical text
// (dev-build text loading per spec §4.1). See drydock_bridge.hpp.
#include "drydock_bridge.hpp"
#include "../drydock/text/rec_text.hpp"
#include "../drydock/schema/schema.hpp"
#include <dirent.h>
#include <sys/stat.h>
#include <algorithm>
#include <fstream>
#include <sstream>

namespace forge {

using namespace drydock;
using vc::sim::RuleData;

static std::string slurp(const std::string& p) {
    std::ifstream f(p);
    std::stringstream ss; ss << f.rdbuf();
    return ss.str();
}

static void walk(const std::string& dir, std::vector<std::string>& out) {
    DIR* d = opendir(dir.c_str());
    if (!d) return;
    while (dirent* e = readdir(d)) {
        std::string n = e->d_name;
        if (n == "." || n == "..") continue;
        std::string p = dir + "/" + n;
        struct stat st{};
        if (stat(p.c_str(), &st) != 0) continue;
        if (S_ISDIR(st.st_mode)) walk(p, out);
        else if (n.size() > 4 && n.substr(n.size() - 4) == ".rec") out.push_back(p);
    }
    closedir(d);
    std::sort(out.begin(), out.end());
}

static long long geti(const Record& r, const char* f, long long def = 0) {
    const Value* v = r.find(f);
    return (v && v->kind == ValKind::Int) ? v->i : def;
}

bool drydock_apply_base(RuleData& rd, const std::string& data_dir, std::string& msg) {
    struct stat st{};
    if (stat((data_dir + "/base").c_str(), &st) != 0) { msg.clear(); return false; }

    std::vector<std::string> files;
    std::vector<Record> schm, recs;
    walk(data_dir + "/schema", files);
    std::string err;
    for (const auto& p : files)
        if (!parse_records(slurp(p), schm, err)) { msg = p + ": " + err; return false; }
    Schema sc;
    if (!schema_load(schm, sc, err)) { msg = err; return false; }

    files.clear();
    walk(data_dir + "/base", files);
    for (const auto& p : files)
        if (!parse_records(slurp(p), recs, err)) { msg = p + ": " + err; return false; }

    // validate everything BEFORE touching rd (swap-on-success, spec 6.2)
    for (auto& r : recs) {
        if (!schema_canonicalize(sc, r, err)) { msg = err; return false; }
        std::vector<std::string> ve;
        schema_validate(sc, r, ve);
        if (!ve.empty()) { msg = ve.front(); return false; }
    }

    RuleData out = rd;
    drydock_apply_records(out, recs);
    int ng = 0, nu = 0, np = 0;
    for (const Record& r : recs) {
        if (r.type() == "good") ++ng; else if (r.type() == "unit") ++nu;
        else if (r.type() == "prof") ++np;
    }
    rd = out;
    msg = "drydock: rules loaded from " + data_dir + "/base (" + std::to_string(ng) +
          " goods, " + std::to_string(nu) + " units, " + std::to_string(np) + " professions)";
    return true;
}

void drydock_apply_records(RuleData& out, const std::vector<Record>& recs) {
    for (const Record& r : recs) {
        const long long idx = geti(r, "index", -1);
        if (r.type() == "good") {
            if (idx < 0 || idx >= (long long)out.cargo.size()) continue;   // Hammers.. rows 16+
            auto& c = out.cargo[idx];
            c.start1 = (int)geti(r, "price_start1", c.start1);
            c.start2 = (int)geti(r, "price_start2", c.start2);
            c.lo     = (int)geti(r, "drift_low",  c.lo);
            c.hi     = (int)geti(r, "drift_high", c.hi);
            c.burden = (int)geti(r, "burden",     c.burden);
        } else if (r.type() == "unit") {
            if (idx < 0 || idx >= (long long)out.units.size()) continue;
            auto& u = out.units[idx];
            u.attack   = (int)geti(r, "attack",   u.attack);
            u.defense  = (int)geti(r, "combat",   u.defense);
            u.cargo    = (int)geti(r, "cargo",    u.cargo);
            u.movement = (int)geti(r, "movement", u.movement);
        } else if (r.type() == "prof") {
            if (idx < 0 || idx >= (long long)out.jobs.size()) continue;
            auto& j = out.jobs[idx];
            j.school_tier = (int)geti(r, "school_tier", j.school_tier);
            j.value       = (int)geti(r, "europe_value", j.value);
        }
    }
}

} // namespace forge
