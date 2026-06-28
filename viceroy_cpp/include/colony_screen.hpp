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
#include "mp.hpp"          // Map (surrounding terrain for the worked-tiles grid)
#include "sim/types.hpp"

namespace vc {

// Render the 320x200 colony screen. `backdrop` = COLONY.PIK (bottom band), `parch` =
// PARCH.SS (the colony-scene inset), `woodtile` = WOODTILE.SS (the screen background —
// the colony screen is wood chrome with a parchment scene window, NOT full parchment),
// `icons` = ICONS.SS, `building` = BUILDING.SS, `font` = FONTTINY, `terrain` = TERRAIN.SS,
// `phys` = PHYS0.SS (the worked-tiles grid uses the exact map-view terrain compositing).
// `map`/`cx`/`cy` = the colony's map + position; if `map` is null the worked-tiles grid is
// skipped. `stockpile` = the 16 warehouse good quantities.
void render_colony_screen(Surface& scr, const IndexedPng& backdrop,
                          const Sheet& parch, const Sheet& woodtile, const Sheet& icons,
                          const Sheet& building, const Sheet& font,
                          const Sheet& terrain, const Sheet& phys,
                          const Map* map, int cx, int cy,
                          const vc::sim::Colony& c, int gold, int tax_pct, int year,
                          const int stockpile[16]);

} // namespace vc
