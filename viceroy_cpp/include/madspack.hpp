// madspack.hpp -- MADSPACK 2.0 container (.SS / .PIK / .FF).
//
// Ported from tools/ssdec.py:madspack_load (byte-verified vs the in-EXE
// madspack_load). Layout (see formats/SS.md):
//   0x00  "MADSPACK 2.0\x1A\x00"   (loader checks first 8 bytes "MADSPACK")
//   0x0E  u16  section count
//   0x10  count * 10-byte dir entries: type(1) _(1) unpacked(u32) packed(u32)
//   0xB0  section data (FIXED start = 16 + 0xA0 reserve); type!=0 -> FAB, ==0 raw
#pragma once
#include <cstdint>
#include <vector>

namespace vc {
struct Section { int type; std::vector<uint8_t> data; };

// Decode every section (decompressing FAB sections) from a MADSPACK blob.
std::vector<Section> madspack_load(const std::vector<uint8_t>& data);
}
