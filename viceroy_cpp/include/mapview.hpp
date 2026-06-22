// mapview.hpp -- compose the main map-view screen from spec/ui/map_view.md.
//
// Every element is placed at a coordinate cited from map_view.md (see the
// element->spec-citation table in mapview.cpp). B-tier elements are byte-grounded;
// the sidebar per-line text and menu item x-positions are R (frame-measured /
// glyph-grid) and rendered from the CITED approximate data -- nothing invented.
#pragma once
#include "surface.hpp"
#include "ss.hpp"
#include "mp.hpp"
#include "png_io.hpp"
#include "sim/types.hpp"
#include "sim/game.hpp"

namespace vc {

// Render the 320x200 map-view screen. `terrain` = TERRAIN.SS base-ground sheet,
// `tiles` = PHYS0 overlay sheet, `woodtile` = WOODTILE.SS 32x24 wood-grain tile
// (tiled across the menu bar + sidebar, per the in-game chrome), `font` = FONTTINY.
// (ox,oy) = top-left map tile of the 15x12 viewport. Live values come from the sim.
void render_mapview(Surface& scr, const Map& map, const Sheet& terrain,
                    const Sheet& tiles, const Sheet& woodtile,
                    const Sheet& font, const vc::sim::GameState& g,
                    const vc::sim::World& w, int ox, int oy);

} // namespace vc
