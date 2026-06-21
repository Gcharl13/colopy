// pik.hpp -- .PIK full-screen background loader (MADSPACK container).
//
// Sections: [0]=header (h @ u16 0, w @ u16 2), [1]=indexed pixels (w*h), and an
// optional 768-byte 6-bit palette section; if absent, fall back to VICEROY.PAL.
#pragma once
#include <cstdint>
#include <vector>
#include <string>

namespace vc {
struct PikImage {
    int w = 0, h = 0;
    std::vector<uint8_t> idx;   // w*h palette indices
    uint8_t pal[768] = {0};     // 256 * RGB (8-bit)
};

// `fallback_pal` (768 bytes, 8-bit RGB) is used when the .PIK has no embedded
// palette; pass nullptr only if you know every .PIK is self-contained.
PikImage load_pik(const std::string& path, const uint8_t* fallback_pal);
}
