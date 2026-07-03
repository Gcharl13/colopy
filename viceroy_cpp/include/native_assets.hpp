// native_assets.hpp -- boot the runtime renderer from the repo's decoded assets
// (data_extracted/tileset/*.{png,json}, docs/atlas/pik/*.png,
// data_extracted/palette.json) instead of the import-all bundle, whose .SS/.PIK
// originals ship only with the user's own game copy (README: the repo carries
// code/text/palette/map originals; art is committed decoded).
//
// The decoded sheets are RGBA/RGB (web-oriented); this loader QUANTIZES them
// back to palette indices by exact RGB match against palette.json -- restoring
// the mode-13h indexed pipeline (Surface) so palette application and cycling
// stay faithful. Verified 2026-07-03: phys0/icons/units/COLONY.pik quantize
// with 0 stray pixels; terrain16 has 35 and buildings 2 (nearest-entry
// fallback, counted).
//
// Frame-order facts this relies on (verified against the tileset JSONs):
//   terrain16.png  12x 16x16 cells in exactly terrain_base_frame() order
//                  (Tundra..Swamp=0..7, Forest/Hill ground=8, Arctic=9,
//                  Ocean=10, Sea Lane=11) -- no remap needed.
//   phys0.png      154x 16x16 cells preserving the ssdec frame ids, so the
//                  mapview PHYS0 lookups (stencils 0x68..0x6B, coast 0x6D,
//                  shore 0x96/0x97, forest 0x40 band) index it 1:1.
//   icons.png      131 variable-width frames (icons.json rects), ssdec ids.
//   units.png      24x 16x16 cells in @UNIT type order.
//   buildings.png  48x 28x24 cells in @BUILDING def_id order (0-based).
#pragma once
#include "ss.hpp"        // Sheet, Frame, SS_TRANSPARENT
#include "png_io.hpp"    // IndexedPng
#include <string>
#include <vector>

namespace vc {

// data_extracted/palette.json ([{index,r,g,b,hex} x256]) -> 256*RGB.
void load_palette_json(const std::string& path, uint8_t pal[768]);

// Read ANY PNG (indexed / RGB / RGBA) as indices against `pal`: exact RGB
// match; alpha < 128 -> SS_TRANSPARENT; stray colors -> nearest entry
// (squared-RGB distance), counted into *strays when non-null.
IndexedPng read_png_quantized(const std::string& path, const uint8_t pal[768],
                              int* strays = nullptr);

// Cut a horizontal strip of fixed-size cells into Sheet frames 0..n-1.
Sheet strip_sheet(const IndexedPng& img, int cell_w, int cell_h);

// Cut variable-width full-height frames at the given x offsets (icons.json).
struct StripRect { int x = 0, w = 0, h = 0; };
Sheet rect_sheet(const IndexedPng& img, const std::vector<StripRect>& rects);

// The baked 5x7 ASCII font, indexed by char code like FONTTINY (frames[c]).
// APPROXIMATION: the original FONTTINY.FF is not in the repo; this is the
// same fidelity tier as the web UI's canvas fillText stand-in.
Sheet baked_font();

// One-call boot of the full native sheet set from a repo checkout root.
struct NativeAssets {
    uint8_t pal[768] = {0};
    Sheet terrain;     // terrain16 (base grounds, terrain_base_frame order)
    Sheet phys;        // PHYS0 overlays (ssdec ids)
    Sheet icons;       // ICONS.SS frames (ssdec ids = EXE sprite id - 1)
    Sheet units;       // unit figures (@UNIT order)
    Sheet buildings;   // colony buildings (def_id order)
    Sheet woodtile;    // 32x24 wood-grain chrome tile (cropped from WOODPANL)
    Sheet font;        // FONTTINY.FF when the project has the game files
                       // (raw/COLONIZE), else baked_font()
    bool  font_real = false;   // true = the game's own FONTTINY loaded
    int   strays = 0;  // total nearest-fallback pixels across all sheets
};
NativeAssets load_native_assets(const std::string& repo_root);

// A full-screen .PIK background (docs/atlas/pik/<NAME>.png), quantized.
// (Named _bg to stay clear of the importer's load_pik in pik.hpp.)
IndexedPng load_pik_bg(const std::string& repo_root, const std::string& name,
                       const uint8_t pal[768]);

} // namespace vc
