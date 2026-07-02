// drydock/pack -- deterministic pack writer/reader (spec §4.1, §10.4).
#include "pack.hpp"
#include <algorithm>
#include <cstdio>
#include <cstring>

namespace drydock {

static void put_u32(std::string& b, uint32_t v) {
    b.push_back((char)(v & 0xFF)); b.push_back((char)((v >> 8) & 0xFF));
    b.push_back((char)((v >> 16) & 0xFF)); b.push_back((char)((v >> 24) & 0xFF));
}
static bool get_u32(const std::string& b, size_t& p, uint32_t& v) {
    if (p + 4 > b.size()) return false;
    v = (uint8_t)b[p] | ((uint8_t)b[p+1] << 8) | ((uint8_t)b[p+2] << 16) | ((uint8_t)b[p+3] << 24);
    p += 4;
    return true;
}

bool pack_write(const std::string& path, std::vector<Record> records, std::string& err) {
    std::sort(records.begin(), records.end(),
              [](const Record& a, const Record& b) { return a.id < b.id; });
    std::string out = "DDPK1\n";
    put_u32(out, (uint32_t)records.size());
    for (const Record& r : records) {
        std::string body = serialize_record(r);
        put_u32(out, (uint32_t)r.id.size());
        out += r.id;
        put_u32(out, (uint32_t)body.size());
        out += body;
    }
    FILE* f = std::fopen(path.c_str(), "wb");
    if (!f) { err = "cannot write " + path; return false; }
    size_t n = std::fwrite(out.data(), 1, out.size(), f);
    std::fclose(f);
    if (n != out.size()) { err = "short write to " + path; return false; }
    return true;
}

bool pack_read(const std::string& path, std::vector<Record>& out, std::string& err) {
    FILE* f = std::fopen(path.c_str(), "rb");
    if (!f) { err = "cannot read " + path; return false; }
    std::string b;
    char buf[65536];
    size_t n;
    while ((n = std::fread(buf, 1, sizeof buf, f)) > 0) b.append(buf, n);
    std::fclose(f);
    if (b.rfind("DDPK1\n", 0) != 0) { err = path + ": not a drydock pack"; return false; }
    size_t p = 6;
    uint32_t count = 0;
    if (!get_u32(b, p, count)) { err = "truncated pack header"; return false; }
    for (uint32_t i = 0; i < count; ++i) {
        uint32_t idl = 0, bl = 0;
        if (!get_u32(b, p, idl) || p + idl > b.size()) { err = "truncated pack id"; return false; }
        std::string id = b.substr(p, idl);
        p += idl;
        if (!get_u32(b, p, bl) || p + bl > b.size()) { err = "truncated pack body"; return false; }
        std::string body = b.substr(p, bl);
        p += bl;
        std::vector<Record> rs;
        if (!parse_records(body, rs, err) || rs.size() != 1 || rs[0].id != id) {
            err = "pack body mismatch for " + id + (err.empty() ? "" : ": " + err);
            return false;
        }
        out.push_back(std::move(rs[0]));
    }
    return true;
}

} // namespace drydock
