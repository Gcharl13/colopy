// image_io.cpp -- see image_io.hpp. Self-contained PPM + PNG (stored deflate).
#include "image_io.hpp"
#include <fstream>
#include <stdexcept>
#include <cstdint>
#include <vector>

namespace vc {

void write_ppm(const Image& img, const std::string& path) {
    std::ofstream f(path, std::ios::binary);
    if (!f) throw std::runtime_error("cannot write " + path);
    f << "P6\n" << img.w << " " << img.h << "\n255\n";
    f.write(reinterpret_cast<const char*>(img.rgb.data()), (std::streamsize)img.rgb.size());
}

// ---- minimal PNG encoder (no zlib: deflate "stored" blocks) ----
static uint32_t crc32_of(const uint8_t* p, size_t n) {
    static uint32_t tbl[256]; static bool init = false;
    if (!init) {
        for (uint32_t i = 0; i < 256; ++i) {
            uint32_t c = i;
            for (int k = 0; k < 8; ++k) c = (c & 1) ? (0xEDB88320u ^ (c >> 1)) : (c >> 1);
            tbl[i] = c;
        }
        init = true;
    }
    uint32_t c = 0xFFFFFFFFu;
    for (size_t i = 0; i < n; ++i) c = tbl[(c ^ p[i]) & 0xFF] ^ (c >> 8);
    return c ^ 0xFFFFFFFFu;
}

static void put_u32be(std::vector<uint8_t>& v, uint32_t x) {
    v.push_back((x >> 24) & 0xFF); v.push_back((x >> 16) & 0xFF);
    v.push_back((x >> 8) & 0xFF);  v.push_back(x & 0xFF);
}

static void chunk(std::vector<uint8_t>& out, const char* type, const std::vector<uint8_t>& data) {
    put_u32be(out, (uint32_t)data.size());
    std::vector<uint8_t> td(type, type + 4);
    td.insert(td.end(), data.begin(), data.end());
    out.insert(out.end(), td.begin(), td.end());
    put_u32be(out, crc32_of(td.data(), td.size()));
}

void write_png(const Image& img, const std::string& path) {
    // Raw (filtered) image data: each row prefixed with filter byte 0 (None).
    std::vector<uint8_t> raw;
    raw.reserve((size_t)(img.w * 3 + 1) * img.h);
    for (int y = 0; y < img.h; ++y) {
        raw.push_back(0);
        const uint8_t* row = &img.rgb[(size_t)y * img.w * 3];
        raw.insert(raw.end(), row, row + (size_t)img.w * 3);
    }

    // zlib stream wrapping deflate "stored" blocks.
    std::vector<uint8_t> z;
    z.push_back(0x78); z.push_back(0x01);                 // zlib header (no compression)
    size_t pos = 0;
    while (pos < raw.size()) {
        size_t n = raw.size() - pos; if (n > 65535) n = 65535;
        bool last = (pos + n == raw.size());
        z.push_back(last ? 1 : 0);                        // BFINAL + BTYPE=00 (stored)
        z.push_back(n & 0xFF); z.push_back((n >> 8) & 0xFF);
        uint16_t nlen = (uint16_t)~(uint16_t)n;
        z.push_back(nlen & 0xFF); z.push_back((nlen >> 8) & 0xFF);
        z.insert(z.end(), raw.begin() + pos, raw.begin() + pos + n);
        pos += n;
    }
    // Adler-32 of the raw data.
    uint32_t a = 1, b = 0;
    for (uint8_t byte : raw) { a = (a + byte) % 65521; b = (b + a) % 65521; }
    put_u32be(z, (b << 16) | a);

    std::vector<uint8_t> out = {0x89,'P','N','G',0x0D,0x0A,0x1A,0x0A};
    std::vector<uint8_t> ihdr;
    put_u32be(ihdr, (uint32_t)img.w); put_u32be(ihdr, (uint32_t)img.h);
    ihdr.push_back(8); ihdr.push_back(2);                 // 8-bit, truecolor RGB
    ihdr.push_back(0); ihdr.push_back(0); ihdr.push_back(0);
    chunk(out, "IHDR", ihdr);
    chunk(out, "IDAT", z);
    chunk(out, "IEND", {});

    std::ofstream f(path, std::ios::binary);
    if (!f) throw std::runtime_error("cannot write " + path);
    f.write(reinterpret_cast<const char*>(out.data()), (std::streamsize)out.size());
}

} // namespace vc
