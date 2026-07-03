// popup_render.hpp -- the shared gameplay-popup frame engine, native edition
// (spec/ui/popups.md §2, BYTE-VERIFIED geometry; same numbers as the web
// wfShow implementation it replaces).
//
// Geometry (all byte-cited in popups.md):
//   content width = max(80, longest_line + 10, record @width)   func_06D316 @0x06D392
//   box           = content + 3px wood border each side          func_06C520 +0x46/+0x48
//   position      = centered on (160,100) unless the record pins @x/@y,
//                   clamped to 320x200                            @0x06D522/3B/63/71
//   body          = WOODPANL-tiled fill inside the border
//   text          = FONTTINY rows, 8px pitch, 5px inset; {braces} in GAME.TXT
//                   bodies mark highlighted words (glyph-engine highlight color)
//   choices       = centered rows below the body, 11px pitch; the record's
//                   @default (1-based) starts pre-highlighted
//   speaker       = portrait channel anchored above the box's top-left corner
//                   (the EXE computes the landing pixel at runtime, popups.md
//                   §2.7.1 -- this anchor is the same adaptation the web uses).
#pragma once
#include "surface.hpp"
#include "png_io.hpp"
#include <string>
#include <vector>

namespace vc {

struct PopupSpec {
    std::vector<std::string> lines;    // body lines, %slots already filled
    std::vector<std::string> choices;  // option rows (supplied by the caller)
    int box_w = 0;                     // record @width (0 = auto)
    int px = -1, py = -1;              // record @x/@y pin (-1 = centered)
    int highlight = -1;                // choice index drawn highlighted
    const Frame* portrait = nullptr;   // speaker window (28x21), above box TL
    const Frame* scene = nullptr;      // woodcut scene window, above box TR
};

struct PopupLayout {
    int x = 0, y = 0, w = 0, h = 0;    // outer box rect (3px border included)
    int content_w = 0;                 // inner text width
    int choice_y0 = 0;                 // first choice row, content-box coords
    static constexpr int ROW = 8;      // FONTTINY row pitch
    static constexpr int CHROW = 11;   // choice row pitch (8 + 3 gap)
};

// Compute the box rect for a spec (text measured with `font`).
PopupLayout popup_layout(const Sheet& font, const PopupSpec& p);

// Screen-coords rect of choice i (for hit-testing in interactive shells).
void popup_choice_rect(const PopupLayout& L, int i, int& x, int& y, int& w, int& h);

// Draw the popup onto `scr`. `woodpanl` is the WOODPANL.PIK image (tiled body).
void render_popup(Surface& scr, const IndexedPng& woodpanl, const Sheet& font,
                  const PopupSpec& p, const PopupLayout& L);

// Nearest palette index to (r,g,b) -- squared-RGB distance over all 256 entries.
uint8_t nearest_pal_index(const uint8_t pal[768], int r, int g, int b);

} // namespace vc
