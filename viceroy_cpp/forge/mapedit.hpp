// forge/mapedit.hpp -- the map editor's core: byte-faithful .MP I/O, edit ops,
// and validation. This supplies the net-new .MP WRITE path (the renderer's
// src/mp.cpp is decode-only) plus the editable model + checks the MAPEDIT-style
// GUI will sit on top of.
//
// Faithfulness strategy: the editor owns the L1 terrain plane (bytes after the
// 4-byte header) and preserves EVERYTHING after it (L2/L3 planes + the
// Colony/Unit/Native metadata) as an opaque blob. So an unedited file round-trips
// byte-for-byte without the editor needing the (only partly-specified) trailing
// layout (formats/MP_FORMAT.md).
//
// Tile byte (formats/MP_FORMAT.md / CLAUDE.md): bits 0-4 terrain id, bit5 (0x20)
// river overlay, bit6 (0x40) forest overlay, bit7 (0x80) explored(?). Terrain ids:
// 0-7 base land, 8-23 forested variants, 24 Arctic, 25 Ocean, 26 Sea Lane,
// 27 Mountains, 28 Hills.
#pragma once

#include <cstdint>
#include <string>
#include <vector>

namespace forge {

constexpr uint8_t MP_ID_MASK     = 0x1F;
constexpr uint8_t MP_RIVER_BIT   = 0x20;
constexpr uint8_t MP_FOREST_BIT  = 0x40;
constexpr int MP_MAX_TERRAIN_ID  = 28;
constexpr int MP_ARCTIC = 24, MP_OCEAN = 25, MP_SEA_LANE = 26, MP_MOUNTAINS = 27, MP_HILLS = 28;

struct MpFile {
    int w = 0, h = 0;
    std::vector<uint8_t> terrain;   // L1 plane, w*h bytes (the editable layer)
    std::vector<uint8_t> rest;      // everything after L1 (preserved verbatim)

    int     idx(int x, int y) const { return y * w + x; }
    bool    in_bounds(int x, int y) const { return x >= 0 && x < w && y >= 0 && y < h; }
    uint8_t raw(int x, int y) const { return terrain[idx(x, y)]; }
    int     terrain_id(int x, int y) const { return raw(x, y) & MP_ID_MASK; }
    bool    has_river(int x, int y) const { return (raw(x, y) & MP_RIVER_BIT) != 0; }
    bool    has_forest(int x, int y) const { return (raw(x, y) & MP_FOREST_BIT) != 0; }
};

// I/O. load throws std::runtime_error on a malformed/too-small file.
MpFile load_mp(const std::string& path);
void   save_mp(const std::string& path, const MpFile& m);

// Make a blank map: every tile Ocean, with the right-edge column = Sea Lane.
MpFile make_blank(int w, int h);

// Edit ops (no-ops out of bounds). set_terrain preserves the overlay bits.
void set_terrain(MpFile& m, int x, int y, int terrain_id);
void set_river(MpFile& m, int x, int y, bool on);
void set_forest(MpFile& m, int x, int y, bool on);
void fill_terrain(MpFile& m, int cx, int cy, int terrain_id, int radius);

// Validation against the load-bearing invariants + MAPEDIT-style warnings.
struct MapReport {
    std::vector<std::string> issues;     // hard rule violations
    std::vector<std::string> warnings;   // MAPEDIT-style (e.g. > 15 land masses)
    int land_masses = 0, oceans = 0;
    bool ok() const { return issues.empty(); }
};
MapReport validate(const MpFile& m);

} // namespace forge
