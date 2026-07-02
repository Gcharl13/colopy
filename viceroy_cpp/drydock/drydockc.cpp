// drydockc -- the standalone validator/compiler CLI (spec §10.4):
//
//   drydockc <data-dir> [-o game.pack]
//
// Loads <data-dir>/schema/*.rec, then every .rec under <data-dir>/base/,
// and enforces the P0 hard gates:
//   1. every record parses and canonicalizes against its schema;
//   2. per-record validation (types, ranges, required, ref shape);
//   3. whole-set checks: duplicate ids, ref targets exist;
//   4. text -> store -> text is BYTE-IDENTICAL per file (determinism, §4.2);
//   5. the 200-line data-file lint (no long files, §4.2);
// then optionally compiles the validated set to a deterministic pack.
// Exit code 0 = clean; 1 = any error. CI runs this over the full data set.
#include "text/rec_text.hpp"
#include "schema/schema.hpp"
#include "pack/pack.hpp"
#include <cstdio>
#include <cstring>
#include <fstream>
#include <sstream>
#include <set>
#include <algorithm>

#if defined(_WIN32)
#error "drydockc dir walk is POSIX for now (dev/CI hosts); port with FindFirstFile when needed"
#endif
#include <dirent.h>
#include <sys/stat.h>

using namespace drydock;

static std::string slurp(const std::string& path) {
    std::ifstream f(path);
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

int main(int argc, char** argv) {
    std::string data_dir, pack_out;
    for (int i = 1; i < argc; ++i) {
        if (!std::strcmp(argv[i], "-o") && i + 1 < argc) pack_out = argv[++i];
        else data_dir = argv[i];
    }
    if (data_dir.empty()) {
        std::fprintf(stderr, "usage: drydockc <data-dir> [-o game.pack]\n");
        return 1;
    }

    int errors = 0;
    auto fail = [&](const std::string& m) { std::fprintf(stderr, "error: %s\n", m.c_str()); ++errors; };

    // 1. schema
    std::vector<std::string> schema_files;
    walk(data_dir + "/schema", schema_files);
    std::vector<Record> schm;
    for (const auto& p : schema_files) {
        std::string err;
        if (!parse_records(slurp(p), schm, err)) fail(p + ": " + err);
    }
    Schema sc;
    {
        std::string err;
        if (!schema_load(schm, sc, err)) { fail(err); return 1; }
    }

    // 2..5. records
    std::vector<std::string> rec_files;
    walk(data_dir + "/base", rec_files);
    std::vector<Record> all;
    std::set<std::string> ids;
    for (const auto& p : rec_files) {
        std::string src = slurp(p), err;
        // lint: no long files (spec 4.2 -- fails any .rec over 200 lines)
        long lines = std::count(src.begin(), src.end(), '\n');
        if (lines > 200) fail(p + ": " + std::to_string(lines) + " lines (max 200)");
        std::vector<Record> rs;
        if (!parse_records(src, rs, err)) { fail(p + ": " + err); continue; }
        std::string canon;
        for (size_t i = 0; i < rs.size(); ++i) {
            if (!schema_canonicalize(sc, rs[i], err)) { fail(p + ": " + err); err.clear(); }
            std::vector<std::string> ve;
            schema_validate(sc, rs[i], ve);
            for (const auto& e : ve) fail(p + ": " + e);
            if (!ids.insert(rs[i].id).second) fail(p + ": duplicate id " + rs[i].id);
            if (i) canon += "\n";
            canon += serialize_record(rs[i]);
        }
        // determinism hard gate: file bytes == canonical serialization
        if (canon != src)
            fail(p + ": NOT canonical (text -> store -> text differs); run the "
                     "serializer or tools/drydock_migrate.py");
        for (auto& r : rs) all.push_back(std::move(r));
    }

    // whole-set: every ref target exists
    for (const Record& r : all)
        for (const auto& f : r.fields) {
            const TypeDef* td = sc.find(r.type());
            const FieldDef* fd = td ? td->find(f.name) : nullptr;
            if (fd && fd->type == FType::Ref && f.value.kind == ValKind::Token &&
                !ids.count(f.value.s))
                fail(r.id + "." + f.name + ": dangling ref '" + f.value.s + "'");
        }

    std::printf("drydockc: %zu schema types, %zu records, %d error(s)\n",
                sc.types.size(), all.size(), errors);
    if (errors) return 1;

    if (!pack_out.empty()) {
        std::string err;
        if (!pack_write(pack_out, all, err)) { fail(err); return 1; }
        // read-back proves the pack round-trips
        std::vector<Record> back;
        if (!pack_read(pack_out, back, err) || back.size() != all.size()) {
            fail("pack read-back failed: " + err);
            return 1;
        }
        std::printf("drydockc: wrote %s (%zu records)\n", pack_out.c_str(), back.size());
    }
    return 0;
}
