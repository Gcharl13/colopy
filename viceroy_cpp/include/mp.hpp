// mp.hpp -- .MP map loader (header + tile bytes).
//
// Layout (formats/MP_FORMAT.md): u16 width, u16 height, then 3 width*height
// planes (row-major): L1 terrain (bits 0-4 id, 0x20 hills/mtn, 0x40 river,
// 0x80 mtn-vs-hill), L2 feature (empty on stock maps), L3 resfog (land/water/
// resource class: 0 border, 1 ocean, 2+ land/lake regions). Per-tile metadata
// (Colony/Unit/Native records) follows -- not needed for rendering.
#pragma once
#include <cstdint>
#include <vector>
#include <string>

namespace vc {
struct Map {
    int w = 0, h = 0;
    std::vector<uint8_t> tiles;   // L1 terrain bytes
    std::vector<uint8_t> resfog;  // L3 resfog class (empty if absent)
};
Map load_mp(const std::string& path);
}
