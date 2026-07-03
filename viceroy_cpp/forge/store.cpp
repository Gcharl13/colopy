// forge/store.cpp -- see store.hpp. The unified cell accessor (A2).
#include "store.hpp"
#include "cfg_fields.hpp"

using vc::sim::Config;

namespace forge {
namespace {

// The scalar Config fields, addressable as cfg.<name>. Kept in step with rules.hpp Config
// (the array fields ff_gate_years / ref_accrue_gate_years are edited via the Rules overlay).

} // namespace

bool cfg_get(const Config& c, const std::string& name, double& out) {
#define X(f) if (name == #f) { out = (double)c.f; return true; }
    CFG_FIELDS(X)
#undef X
    return false;
}

const std::vector<std::string>& cfg_field_names() {
    static const std::vector<std::string> N = {
#define X(f) #f,
        CFG_FIELDS(X)
#undef X
    };
    return N;
}

JsonValue cell_get(const std::string& path, const EngineCtx& cx) {
    if (path.rfind("cfg.", 0) == 0) {
        double v; if (cfg_get(cx.rd.cfg, path.substr(4), v)) return json_num(v);
        return JsonValue{};
    }
    return resolve_binding(path, cx);   // reference (@...) + state, byte-verified resolver
}

bool cell_set(const std::string& path, double value, EngineCtx& cx) {
    if (path.rfind("cfg.", 0) == 0) return false;   // config is edited via the Rules overlay
    return set_binding(path, value, cx);
}

} // namespace forge
