// colony_screen.hpp -- compose the colony screen from spec/ui/colony_screen.md.
//
// Mirrors the byte-read composer draw order (func_028592, 12 steps): the COLONY.PIK
// backdrop carries the static wood chrome (the composer's flat region fills + 1px
// frames), and the dynamic elements (title text, stockpile bar, flag, buildings) are
// overlaid at their byte-cited rects/sprite indices. Every element below cites its
// spec/ui/colony_screen.md source; gaps (per-good stockpile array, DGROUP building
// position table) are called out in the .cpp and rendered as honest R placeholders.
#pragma once
#include "surface.hpp"
#include "ss.hpp"
#include "png_io.hpp"      // IndexedPng (COLONY.PIK backdrop)
#include "sim/types.hpp"

namespace vc {

// Render the 320x200 colony screen. `backdrop` = COLONY.PIK (bundle background),
// `icons` = ICONS.SS, `building` = BUILDING.SS, `font` = FONTTINY, `terrain` =
// TERRAIN.SS (base-ground tiles for the outside-colony worked-tiles grid). `stockpile`
// = the 16 warehouse good quantities. `surround` (may be null) = the 3x3 terrain ids
// around the colony (row-major, index 4 = centre = the colony tile), used to draw the
// upper-right worked-tiles grid from the real map; null skips that panel.
void render_colony_screen(Surface& scr, const IndexedPng& backdrop,
                          const Sheet& woodtile, const Sheet& icons,
                          const Sheet& building, const Sheet& font,
                          const Sheet& terrain,
                          const vc::sim::Colony& c, int gold, int tax_pct, int year,
                          const int stockpile[16], const int surround[9]);

} // namespace vc
