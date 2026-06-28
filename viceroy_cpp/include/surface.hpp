// surface.hpp -- a 320x200 mode-13h INDEXED framebuffer + blit/draw primitives.
//
// The original game renders into a single 256-color indexed surface (mode 13h)
// with one active palette; we mirror that: blit indexed sprite/glyph frames and
// fill rects by palette INDEX, then convert to RGB only when writing the PNG.
// This keeps colors faithful (the assets are authored against one palette) and
// leaves palette-cycling possible later. Transparent pixel = 0xFD (SS_TRANSPARENT).
//
// This is a mechanical primitive only -- the screen LAYOUT lives in mapview.cpp,
// where every element cites its spec/ui/map_view.md source.
#pragma once
#include "ss.hpp"        // Frame, Sheet, SS_TRANSPARENT
#include "png_io.hpp"    // IndexedPng
#include "render.hpp"    // Image
#include <cstdint>
#include <string>
#include <vector>

namespace vc {

struct Surface {
    static constexpr int W = 320, H = 200;
    std::vector<uint8_t> idx;     // W*H palette indices (0 = default/black)
    uint8_t pal[768] = {0};       // 256 * RGB, 8-bit (the one active palette)

    Surface();
    void set_palette(const uint8_t p[768]);

    void clear(uint8_t color = 0);
    void put(int x, int y, uint8_t color);
    void fill_rect(int x, int y, int w, int h, uint8_t color);
    void hline(int x, int y, int w, uint8_t color);
    void vline(int x, int y, int h, uint8_t color);
    void rect_outline(int x, int y, int w, int h, uint8_t color);

    // Blit an indexed sprite Frame at (dx,dy); skips 0xFD; clips to the surface.
    void blit_frame(const Frame& f, int dx, int dy);
    // Same, horizontally mirrored (engine 0x8000 flip flag) — e.g. to face a figure right.
    void blit_frame_flip(const Frame& f, int dx, int dy);
    // Opaque copy of a sub-region of an indexed image (e.g. a .PIK background).
    void blit_region(const IndexedPng& img, int sx, int sy, int sw, int sh,
                     int dx, int dy);

    // Bitmap-font text: each glyph is font.frames[char]; any non-0xFD glyph pixel
    // is drawn in `color` (the glyph engine maps the foreground to the pushed
    // palette index -- spec/ui/fonts_and_colors.md). Advances by glyph width.
    int  text_width(const Sheet& font, const std::string& s) const;
    void draw_text(const Sheet& font, int x, int y, const std::string& s, uint8_t color);

    // Convert to an RGB Image (integer nearest-scale) for PNG output.
    Image to_rgb(int scale = 1) const;
};

} // namespace vc
