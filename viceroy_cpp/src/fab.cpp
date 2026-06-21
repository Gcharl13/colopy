// fab.cpp -- see fab.hpp. Faithful port of ssdec.py:fab_decompress.
#include "fab.hpp"
#include <stdexcept>
#include <string>

namespace vc {

std::vector<uint8_t> fab_decompress(const uint8_t* src, size_t srclen, size_t dstsize) {
    if (srclen < 6 || src[0] != 'F' || src[1] != 'A' || src[2] != 'B')
        throw std::runtime_error("not a FAB stream");
    const int shift = src[3];
    if (shift < 10 || shift > 13)
        throw std::runtime_error("bad FAB shift " + std::to_string(shift));
    const int ofs_shift = 16 - shift;
    const int ofs_mask  = (0xFF << (shift - 8)) & 0xFF;
    const int len_mask  = (1 << ofs_shift) - 1;

    size_t   p      = 6;
    uint32_t bitbuf = (uint32_t)src[4] | ((uint32_t)src[5] << 8);
    int      bits   = 16;
    std::vector<uint8_t> dst(dstsize);
    size_t   out    = 0;

    // Pull one bit LSB-first, refilling the 16-bit window from `src` (which
    // carries a 1-bit overlap, exactly as the original asm does).
    auto bit = [&]() -> int {
        bits -= 1;
        if (bits == 0) {
            if (p + 2 > srclen) throw std::runtime_error("FAB underrun");
            bitbuf = (((uint32_t)src[p] | ((uint32_t)src[p + 1] << 8)) << 1) | (bitbuf & 1u);
            p += 2;
            bits = 16;
        }
        int b = (int)(bitbuf & 1u);
        bitbuf >>= 1;
        return b;
    };

    for (;;) {
        if (bit()) {                                  // literal byte
            dst[out++] = src[p++];
            continue;
        }
        int clen;
        int cofs;                                     // always negative (back-ref)
        if (bit() == 0) {                             // short back-ref
            int b1 = bit(), b0 = bit();
            clen = ((b1 << 1) | b0) + 2;
            cofs = (int)src[p] - 256; p += 1;
        } else {                                      // long back-ref
            cofs = ((((src[p + 1] >> ofs_shift) | ofs_mask) << 8) | src[p]) - 0x10000;
            clen = src[p + 1] & len_mask;
            p += 2;
            if (clen == 0) {
                clen = src[p]; p += 1;
                if (clen == 0) break;                 // end of stream
                if (clen == 1) continue;              // bitstream realign
                clen += 1;
            } else {
                clen += 2;
            }
        }
        while (clen > 0) {
            long s = (long)out + cofs;                // signed: |cofs| <= out
            dst[out] = dst[(size_t)s];
            out += 1; clen -= 1;
        }
    }
    if (out != dstsize)
        throw std::runtime_error("FAB produced " + std::to_string(out) +
                                 " bytes, expected " + std::to_string(dstsize));
    return dst;
}

} // namespace vc
