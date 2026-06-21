// ss.cpp -- see ss.hpp. Faithful port of ssdec.py:load_sheet / rle_decode.
#include "ss.hpp"
#include "madspack.hpp"
#include "util.hpp"
#include <stdexcept>

namespace vc {

std::vector<uint8_t> rle_decode(const uint8_t* src, size_t n, int w, int h) {
    std::vector<uint8_t> out((size_t)w * h, SS_TRANSPARENT);
    size_t i = 0; int px = 0, line = 0;
    while (i < n) {
        uint8_t cmd = src[i++];
        if (cmd == 0xFC) return out;                 // end of frame
        if (cmd == 0xFF) { line++; px = 0; continue; } // next line
        if (line >= h) return out;
        size_t base = (size_t)line * w;
        if (cmd == 0xFD) {                            // run-encoded line
            while (i < n) {
                uint8_t count = src[i++];
                if (count == 0xFF) break;
                if (i >= n) break;
                uint8_t pixel = src[i++];
                while (count > 0 && px < w) {
                    out[base + px] = (pixel == 0xFD) ? SS_TRANSPARENT : pixel;
                    px++; count--;
                }
            }
        } else {                                      // literal line (cmd = marker)
            size_t j = i;
            while (j < n) {
                uint8_t c = src[j++];
                if (c == 0xFF) break;
                if (c == 0xFE) {                      // inline run
                    if (j + 1 >= n) break;
                    uint8_t count = src[j]; uint8_t pixel = src[j + 1]; j += 2;
                    while (count > 0 && px < w) {
                        out[base + px] = (pixel == 0xFD) ? SS_TRANSPARENT : pixel;
                        px++; count--;
                    }
                } else if (px < w) {
                    out[base + px] = (c == 0xFD) ? SS_TRANSPARENT : c;
                    px++;
                }
            }
            i = j;
        }
        line++; px = 0;
    }
    return out;
}

Sheet load_sheet(const std::string& path) {
    auto secs = madspack_load(read_file(path));
    if (secs.size() < 4) throw std::runtime_error(path + ": expected >=4 MADSPACK sections");
    const auto& hdr  = secs[0].data;
    const auto& desc = secs[1].data;
    const auto& pal6 = secs[2].data;
    const auto& pix  = secs[3].data;

    Sheet s;
    s.nframes = u16le(hdr.data() + 38);
    for (int i = 0; i < 768; ++i)
        s.pal[i] = (uint8_t)((pal6[i] << 2) | (pal6[i] >> 4));   // 6-bit -> 8-bit

    s.frames.reserve(s.nframes);
    for (int k = 0; k < s.nframes; ++k) {
        const uint8_t* e = desc.data() + (size_t)k * 16;
        uint32_t off  = u32le(e + 0);
        uint32_t size = u32le(e + 4);
        Frame f;
        f.x = i16le(e + 8);
        f.y = i16le(e + 10);
        f.w = u16le(e + 12);
        f.h = u16le(e + 14);
        f.px = rle_decode(pix.data() + off, size, f.w, f.h);
        s.frames.push_back(std::move(f));
    }
    return s;
}

} // namespace vc
