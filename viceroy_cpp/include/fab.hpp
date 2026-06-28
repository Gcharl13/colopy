// fab.hpp -- FAB (MicroProse LZ77) decompressor.
//
// Ported from the byte-verified `fab_decompress` in tools/ssdec.py, which is
// itself a verbatim port of the in-EXE routine in
// ghidra_export/VICEROY_decompiled.named.c. The decisive correctness test is
// that every section expands to EXACTLY its directory `unpacked` size.
//
// @asm fab_decompress (VICEROY.EXE library) -- BYTE_VERIFIED via ssdec.py
#pragma once
#include <cstdint>
#include <cstddef>
#include <vector>

namespace vc {
// Decompress a FAB stream `src[0..srclen)` into exactly `dstsize` bytes.
std::vector<uint8_t> fab_decompress(const uint8_t* src, size_t srclen, size_t dstsize);
}
