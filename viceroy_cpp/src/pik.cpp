// pik.cpp -- see pik.hpp.
#include "pik.hpp"
#include "madspack.hpp"
#include "util.hpp"
#include <stdexcept>

namespace vc {

PikImage load_pik(const std::string& path, const uint8_t* fallback_pal) {
    auto secs = madspack_load(read_file(path));
    if (secs.size() < 2 || secs[0].data.size() < 4)
        throw std::runtime_error(path + ": malformed .PIK");

    PikImage im;
    im.h = u16le(secs[0].data.data() + 0);
    im.w = u16le(secs[0].data.data() + 2);
    const size_t npx = (size_t)im.w * im.h;
    if (im.w <= 0 || im.h <= 0)
        throw std::runtime_error(path + ": bad .PIK dimensions");

    // Pixel section = the one sized exactly w*h (usually section 1).
    int pix = -1;
    for (size_t i = 1; i < secs.size(); ++i)
        if (secs[i].data.size() == npx) { pix = (int)i; break; }
    if (pix < 0) throw std::runtime_error(path + ": no w*h pixel section");
    im.idx = secs[pix].data;

    // Palette = the last >=768-byte section (6-bit), else fall back.
    int palsec = -1;
    for (size_t i = 0; i < secs.size(); ++i)
        if ((int)i != pix && secs[i].data.size() >= 768) palsec = (int)i;
    if (palsec >= 0) {
        const auto& p6 = secs[palsec].data;
        for (int i = 0; i < 768; ++i) im.pal[i] = (uint8_t)((p6[i] << 2) | (p6[i] >> 4));
    } else if (fallback_pal) {
        for (int i = 0; i < 768; ++i) im.pal[i] = fallback_pal[i];
    } else {
        throw std::runtime_error(path + ": no palette and no fallback");
    }
    return im;
}

} // namespace vc
