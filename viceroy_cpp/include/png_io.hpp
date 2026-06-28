// png_io.hpp -- PNG read/write via libpng (a standard library, not a game codec).
// The runtime uses these instead of the original MADSPACK/FAB codec.
#pragma once
#include <cstdint>
#include <vector>
#include <string>

namespace vc {

// 8-bit paletted (indexed) image: `idx` are palette indices, `pal` is 256*RGB.
struct IndexedPng {
    int w = 0, h = 0;
    std::vector<uint8_t> idx;   // w*h palette indices
    uint8_t pal[768] = {0};     // 256 * RGB (8-bit)
};

// Write an 8-bit paletted PNG (color type 3) with PLTE; if transparent_index >= 0
// also emit tRNS so that index is rendered transparent.
void write_png_indexed(const std::string& path, int w, int h,
                       const std::vector<uint8_t>& idx, const uint8_t pal[768],
                       int transparent_index = -1);

// Read an 8-bit paletted PNG back into indices + palette.
IndexedPng read_png_indexed(const std::string& path);

// Write a 24-bit RGB PNG (for the final composited map render).
void write_png_rgb(const std::string& path, int w, int h, const std::vector<uint8_t>& rgb);

} // namespace vc
