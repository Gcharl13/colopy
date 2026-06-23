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
// `icons` = ICONS.SS, `building` = BUILDING.SS, `font` = FONTTINY. `stockpile` =
// the 16 warehouse good quantities (ColonyRecord +0x9A; not yet in the sim model,
// so main passes a demo array). `tax_pct` from the owning power.
void render_colony_screen(Surface& scr, const IndexedPng& backdrop,
                          const Sheet& woodtile, const Sheet& icons,
                          const Sheet& building, const Sheet& font,
                          const vc::sim::Colony& c, int gold, int tax_pct, int year,
                          const int stockpile[16]);

} // namespace vc
