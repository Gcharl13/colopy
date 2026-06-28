// pal.cpp -- see pal.hpp.
#include "pal.hpp"
#include "util.hpp"
#include <stdexcept>

namespace vc {

Palette load_pal(const std::string& path) {
    auto d = read_file(path);
    // VICEROY.PAL = 256 entries * 4 bytes (R,G,B,pad), 6-bit channels.
    if (d.size() < 256u * 4)
        throw std::runtime_error(path + ": expected 1024-byte VICEROY.PAL");
    Palette p;
    for (int i = 0; i < 256; ++i) {
        for (int c = 0; c < 3; ++c) {
            uint8_t v = d[(size_t)i * 4 + c];                 // stride 4
            p.rgb[i * 3 + c] = (uint8_t)((v << 2) | (v >> 4)); // 6-bit -> 8-bit
        }
    }
    return p;
}

} // namespace vc
