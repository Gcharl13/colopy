// madspack.cpp -- see madspack.hpp. Faithful port of ssdec.py:madspack_load.
#include "madspack.hpp"
#include "fab.hpp"
#include <stdexcept>
#include <cstring>

namespace vc {

static uint16_t rd_u16(const std::vector<uint8_t>& d, size_t o) {
    return (uint16_t)(d[o] | (d[o + 1] << 8));
}
static uint32_t rd_u32(const std::vector<uint8_t>& d, size_t o) {
    return (uint32_t)(d[o] | (d[o + 1] << 8) | (d[o + 2] << 16) | ((uint32_t)d[o + 3] << 24));
}

std::vector<Section> madspack_load(const std::vector<uint8_t>& data) {
    if (data.size() < 16 + 0xA0 || std::memcmp(data.data(), "MADSPACK", 8) != 0)
        throw std::runtime_error("not a MADSPACK container");
    const uint16_t count = rd_u16(data, 14);
    size_t off = 16 + 0xA0;                       // sections start after the 0xA0 reserve
    std::vector<Section> out;
    out.reserve(count);
    for (uint16_t i = 0; i < count; ++i) {
        const size_t e   = 16 + (size_t)i * 10;
        const int    typ = data[e];
        const uint32_t size  = rd_u32(data, e + 2);
        const uint32_t csize = rd_u32(data, e + 6);
        if (off + csize > data.size())
            throw std::runtime_error("MADSPACK section overruns file");
        Section sec;
        sec.type = typ;
        if (typ == 0) {                            // raw: truncate/pad to `size`
            sec.data.assign(size, 0);
            uint32_t n = csize < size ? csize : size;
            std::memcpy(sec.data.data(), data.data() + off, n);
        } else {                                   // FAB stream
            sec.data = fab_decompress(data.data() + off, csize, size);
        }
        out.push_back(std::move(sec));
        off += csize;
    }
    return out;
}

} // namespace vc
