// mp.hpp -- .MP map loader (header + tile bytes).
//
// Layout (formats/MP_FORMAT.md): u16 width, u16 height, then width*height tile
// bytes (row-major). Per tile byte: bits 0-4 terrain id, bit5 (0x20) river,
// bit6 (0x40) forest, bit7 (0x80) explored. Per-tile metadata follows the tile
// array (Colony/Unit/Native records) -- not needed for rendering.
#pragma once
#include <cstdint>
#include <vector>
#include <string>

namespace vc {
struct Map {
    int w = 0, h = 0;
    std::vector<uint8_t> tiles;   // w*h tile bytes
};
Map load_mp(const std::string& path);
}
