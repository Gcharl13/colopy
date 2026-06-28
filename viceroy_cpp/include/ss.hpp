// ss.hpp -- .SS sprite-sheet loader (frame descriptors + RLE pixel decode).
//
// Ported from tools/ssdec.py:load_sheet / rle_decode. A sheet is 4 MADSPACK
// sections: [0]=header (nframes @ off 38), [1]=16-byte frame descriptors,
// [2]=768-byte 6-bit palette, [3]=concatenated RLE pixel streams.
// Pixel value 0xFD == transparent.
#pragma once
#include <cstdint>
#include <vector>
#include <string>

namespace vc {
constexpr uint8_t SS_TRANSPARENT = 0xFD;

struct Frame {
    int x, y;                  // signed hotspot/offset
    int w, h;                  // dimensions
    std::vector<uint8_t> px;   // w*h indexed pixels (0xFD = transparent)
};

struct Sheet {
    int nframes = 0;
    uint8_t pal[768] = {0};    // 256 * RGB, 8-bit (6-bit expanded)
    std::vector<Frame> frames;
};

Sheet load_sheet(const std::string& path);

// RLE pixel decode for one frame stream (exposed for testing).
std::vector<uint8_t> rle_decode(const uint8_t* src, size_t n, int w, int h);
}
