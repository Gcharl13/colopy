// ff.hpp -- .FF bitmap-font decoder (format CRACKED 2026-06-21, see formats/FF.md).
//
// Payload (after MADSPACK/FAB): [0]=height, [1]=maxwidth, [2..130)=width table
// (char 0..127), [130..386)=offset table (u16 per char), [386..)=glyph bitmaps
// (2bpp, MSB-first, row-major). A glyph is a Sheet frame so it reuses the bundle
// pipeline; pixel level 0 -> transparent (SS_TRANSPARENT), 1/2/3 -> ink shades.
#pragma once
#include "ss.hpp"      // Sheet / Frame / SS_TRANSPARENT
#include <string>

namespace vc {

// Decode a .FF into a Sheet of 128 glyph frames (frame index = char code).
// pal[1..3] = grayscale ink shades; level 0 maps to SS_TRANSPARENT.
Sheet load_font(const std::string& path);

}
