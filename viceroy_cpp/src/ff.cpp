// ff.cpp -- see ff.hpp.
#include "ff.hpp"
#include "madspack.hpp"
#include "util.hpp"
#include <stdexcept>

namespace vc {

Sheet load_font(const std::string& path) {
    auto secs = madspack_load(read_file(path));
    if (secs.empty()) throw std::runtime_error(path + ": empty .FF");
    const std::vector<uint8_t>& p = secs[0].data;
    if (p.size() < 386) throw std::runtime_error(path + ": .FF payload too small");

    const int H = p[0];
    Sheet s;
    s.nframes = 128;
    // 4-level grayscale ink palette; level 0 = transparent (SS_TRANSPARENT).
    for (int lvl = 1; lvl <= 3; ++lvl) {
        uint8_t g = (uint8_t)(lvl * 85);          // 85,170,255
        s.pal[lvl * 3 + 0] = s.pal[lvl * 3 + 1] = s.pal[lvl * 3 + 2] = g;
    }

    // Table entry t holds the glyph for char (t+1); frame index = char code.
    s.frames.resize(128);
    for (int t = 0; t < 127; ++t) {
        int ch = t + 1;
        int w = p[2 + t];
        uint32_t o0 = u16le(p.data() + 130 + 2 * t);
        uint32_t o1 = u16le(p.data() + 130 + 2 * (t + 1));
        Frame f;
        f.x = 0; f.y = 0; f.w = w; f.h = H;
        f.px.assign((size_t)w * H, SS_TRANSPARENT);
        if (w > 0 && o1 > o0 && o1 <= p.size()) {
            int rb = (w * 2 + 7) / 8;              // bytes per row (2bpp)
            const uint8_t* bm = p.data() + o0;
            for (int r = 0; r < H; ++r) {
                const uint8_t* row = bm + (size_t)r * rb;
                for (int x = 0; x < w; ++x) {
                    int bi = x / 4;
                    int sh = (3 - (x % 4)) * 2;     // MSB-first within the byte
                    int v  = (row[bi] >> sh) & 3;
                    f.px[(size_t)r * w + x] = (v == 0) ? SS_TRANSPARENT : (uint8_t)v;
                }
            }
        }
        s.frames[ch] = std::move(f);
    }
    return s;
}

} // namespace vc
