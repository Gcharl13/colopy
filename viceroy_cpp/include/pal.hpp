// pal.hpp -- VICEROY.PAL loader (global 256-color VGA palette).
//
// VICEROY.PAL is 256 * 4 bytes (R,G,B,pad) with 6-bit channel values; expand
// 6-bit -> 8-bit via (v<<2)|(v>>4). (PHYS0.SS carries an identical embedded
// palette; the renderer uses the sheet palette to match the visual oracle.)
#pragma once
#include <cstdint>
#include <array>
#include <string>

namespace vc {
struct Palette { uint8_t rgb[768]; };   // 256 * RGB, 8-bit
Palette load_pal(const std::string& path);
}
