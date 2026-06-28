// render.hpp -- composite an .MP map into an RGB image using PHYS0.SS sprites.
//
// Replicates tools/render_map.py exactly so the C++ output can be pixel-diffed
// against the Python visual oracle:
//   * sprite_idx = terrain_id (byte & 0x1F); skip placeholder indices 0/16/100
//     (CLAUDE.md hard rule #5)
//   * river bit (0x20) overlays sprite frame 1 (PHYS0 row 0x01 = river)
//   * sprites colorized with the sheet's embedded palette; 0xFD = transparent
// The naive terrain_id->sprite mapping is the P0 milestone; the
// func_O514->O513->O512 sub-cell transition chain (CLAUDE.md hard rule #7) is a
// later phase. TBD: @asm func_O512/O513/O514.
#pragma once
#include <cstdint>
#include <vector>
#include "mp.hpp"
#include "ss.hpp"

namespace vc {
struct Image { int w = 0, h = 0; std::vector<uint8_t> rgb; };

Image render_map(const Map& map, const Sheet& sheet, int tile_size = 16);
}
