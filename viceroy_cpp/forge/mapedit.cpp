// forge/mapedit.cpp -- see mapedit.hpp.
#include "mapedit.hpp"

#include <fstream>
#include <sstream>
#include <stdexcept>

namespace forge {
namespace {

uint16_t u16le(const uint8_t* p) { return (uint16_t)(p[0] | (p[1] << 8)); }

bool is_water(int id) { return id == MP_OCEAN || id == MP_SEA_LANE; }

}  // namespace

MpFile load_mp(const std::string& path) {
    std::ifstream f(path, std::ios::binary);
    if (!f) throw std::runtime_error("mapedit: cannot open " + path);
    std::vector<uint8_t> d((std::istreambuf_iterator<char>(f)),
                           std::istreambuf_iterator<char>());
    if (d.size() < 4) throw std::runtime_error(path + ": too small for .MP header");
    MpFile m;
    m.w = u16le(d.data() + 0);
    m.h = u16le(d.data() + 2);
    size_t ntiles = (size_t)m.w * m.h;
    if (m.w <= 0 || m.h <= 0 || 4 + ntiles > d.size())
        throw std::runtime_error(path + ": tile array overruns file");
    m.terrain.assign(d.begin() + 4, d.begin() + 4 + ntiles);
    m.rest.assign(d.begin() + 4 + ntiles, d.end());   // L2/L3 + metadata, opaque
    return m;
}

void save_mp(const std::string& path, const MpFile& m) {
    if ((int)m.terrain.size() != m.w * m.h)
        throw std::runtime_error("mapedit: terrain size != w*h");
    std::ofstream f(path, std::ios::binary);
    if (!f) throw std::runtime_error("mapedit: cannot write " + path);
    uint8_t hdr[4] = {(uint8_t)(m.w & 0xFF), (uint8_t)((m.w >> 8) & 0xFF),
                      (uint8_t)(m.h & 0xFF), (uint8_t)((m.h >> 8) & 0xFF)};
    f.write((const char*)hdr, 4);
    f.write((const char*)m.terrain.data(), (std::streamsize)m.terrain.size());
    if (!m.rest.empty()) f.write((const char*)m.rest.data(), (std::streamsize)m.rest.size());
    if (!f) throw std::runtime_error("mapedit: write failed for " + path);
}

MpFile make_blank(int w, int h) {
    MpFile m;
    m.w = w; m.h = h;
    m.terrain.assign((size_t)w * h, (uint8_t)MP_OCEAN);
    for (int y = 0; y < h; ++y) m.terrain[m.idx(w - 1, y)] = (uint8_t)MP_SEA_LANE;  // hard rule 2
    return m;
}

void set_terrain(MpFile& m, int x, int y, int terrain_id) {
    if (!m.in_bounds(x, y)) return;
    uint8_t& t = m.terrain[m.idx(x, y)];
    t = (uint8_t)((t & ~MP_ID_MASK) | (terrain_id & MP_ID_MASK));   // keep overlay bits
}

void set_river(MpFile& m, int x, int y, bool on) {
    if (!m.in_bounds(x, y)) return;
    uint8_t& t = m.terrain[m.idx(x, y)];
    if (on) t |= MP_RIVER_BIT; else t &= ~MP_RIVER_BIT;
}

void set_forest(MpFile& m, int x, int y, bool on) {
    if (!m.in_bounds(x, y)) return;
    uint8_t& t = m.terrain[m.idx(x, y)];
    if (on) t |= MP_FOREST_BIT; else t &= ~MP_FOREST_BIT;
}

void fill_terrain(MpFile& m, int cx, int cy, int terrain_id, int radius) {
    for (int y = cy - radius; y <= cy + radius; ++y)
        for (int x = cx - radius; x <= cx + radius; ++x)
            set_terrain(m, x, y, terrain_id);
}

// Count 4-connected components of land and water (MAPEDIT continent/ocean warning).
static void count_masses(const MpFile& m, int& land, int& water) {
    std::vector<uint8_t> seen((size_t)m.w * m.h, 0);
    std::vector<int> stack;
    land = water = 0;
    for (int y = 0; y < m.h; ++y) {
        for (int x = 0; x < m.w; ++x) {
            int start = m.idx(x, y);
            if (seen[start]) continue;
            bool comp_water = is_water(m.terrain_id(x, y));
            if (comp_water) ++water; else ++land;
            stack.clear(); stack.push_back(start); seen[start] = 1;
            while (!stack.empty()) {
                int i = stack.back(); stack.pop_back();
                int px = i % m.w, py = i / m.w;
                const int dx[4] = {1, -1, 0, 0}, dy[4] = {0, 0, 1, -1};
                for (int k = 0; k < 4; ++k) {
                    int nx = px + dx[k], ny = py + dy[k];
                    if (!m.in_bounds(nx, ny)) continue;
                    int ni = m.idx(nx, ny);
                    if (seen[ni]) continue;
                    if (is_water(m.terrain_id(nx, ny)) != comp_water) continue;
                    seen[ni] = 1; stack.push_back(ni);
                }
            }
        }
    }
}

MapReport validate(const MpFile& m) {
    MapReport r;
    auto issue = [&](const std::string& s) { r.issues.push_back(s); };

    if (m.w <= 0 || m.h <= 0) { issue("non-positive dimensions"); return r; }
    if ((int)m.terrain.size() != m.w * m.h) { issue("terrain size != w*h"); return r; }

    for (int y = 0; y < m.h; ++y) {
        for (int x = 0; x < m.w; ++x) {
            int id = m.terrain_id(x, y);
            if (id > MP_MAX_TERRAIN_ID)
                issue("tile (" + std::to_string(x) + "," + std::to_string(y) +
                      "): terrain id " + std::to_string(id) + " > 28");
            // bit 6 is "forest" on land but a "special" marker on water (fishing
            // grounds etc.) per MP_FORMAT.md, so only flag it where it is truly
            // meaningless: polar ice and bare mountain peaks.
            if (m.has_forest(x, y) && (id == MP_ARCTIC || id == MP_MOUNTAINS))
                issue("tile (" + std::to_string(x) + "," + std::to_string(y) +
                      "): forest overlay on non-land terrain");
            if (m.has_river(x, y) && is_water(id))
                issue("tile (" + std::to_string(x) + "," + std::to_string(y) +
                      "): river overlay on water");
        }
    }
    // hard rule 2: the right-edge column is the sea lane. CLAUDE.md's rule is
    // "never desert/land" there; the canonical AMER2 carries Ocean (not Sea Lane)
    // on the top/bottom polar rows, so accept Ocean at the edge too.
    for (int y = 0; y < m.h; ++y) {
        int id = m.terrain_id(m.w - 1, y);
        if (id != MP_SEA_LANE && id != MP_OCEAN) {
            issue("right-edge column is land (id " + std::to_string(id) +
                  ") at row " + std::to_string(y) + " -- must be Sea Lane/Ocean");
            break;
        }
    }

    count_masses(m, r.land_masses, r.oceans);
    if (r.land_masses > 15) r.warnings.push_back("more than 15 land masses (" +
                                                 std::to_string(r.land_masses) + ")");
    if (r.oceans > 15) r.warnings.push_back("more than 15 oceans (" +
                                            std::to_string(r.oceans) + ")");
    return r;
}

} // namespace forge
