// surface.cpp -- 320x200 indexed framebuffer primitives (see surface.hpp).
#include "surface.hpp"

namespace vc {

Surface::Surface() : idx(W * H, 0) {}

void Surface::set_palette(const uint8_t p[768]) {
    for (int i = 0; i < 768; ++i) pal[i] = p[i];
}

void Surface::clear(uint8_t color) {
    std::fill(idx.begin(), idx.end(), color);
}

void Surface::put(int x, int y, uint8_t color) {
    if (x < 0 || y < 0 || x >= W || y >= H) return;
    idx[y * W + x] = color;
}

void Surface::fill_rect(int x, int y, int w, int h, uint8_t color) {
    for (int yy = y; yy < y + h; ++yy)
        for (int xx = x; xx < x + w; ++xx)
            put(xx, yy, color);
}

void Surface::hline(int x, int y, int w, uint8_t color) {
    for (int xx = x; xx < x + w; ++xx) put(xx, y, color);
}
void Surface::vline(int x, int y, int h, uint8_t color) {
    for (int yy = y; yy < y + h; ++yy) put(x, yy, color);
}
void Surface::rect_outline(int x, int y, int w, int h, uint8_t color) {
    hline(x, y, w, color);
    hline(x, y + h - 1, w, color);
    vline(x, y, h, color);
    vline(x + w - 1, y, h, color);
}

void Surface::blit_frame(const Frame& f, int dx, int dy) {
    for (int yy = 0; yy < f.h; ++yy) {
        for (int xx = 0; xx < f.w; ++xx) {
            uint8_t p = f.px[yy * f.w + xx];
            if (p == SS_TRANSPARENT) continue;
            put(dx + xx, dy + yy, p);
        }
    }
}

// Horizontal-flip blit (the engine's 0x8000 frame-flag → func_00E76A @0x00E786 mirrors the
// sprite). Used to face colonist/unit figures right when the sheet art faces left.
void Surface::blit_frame_flip(const Frame& f, int dx, int dy) {
    for (int yy = 0; yy < f.h; ++yy) {
        for (int xx = 0; xx < f.w; ++xx) {
            uint8_t p = f.px[yy * f.w + xx];
            if (p == SS_TRANSPARENT) continue;
            put(dx + (f.w - 1 - xx), dy + yy, p);
        }
    }
}

void Surface::blit_region(const IndexedPng& img, int sx, int sy, int sw, int sh,
                          int dx, int dy) {
    for (int yy = 0; yy < sh; ++yy) {
        int srcy = sy + yy;
        if (srcy < 0 || srcy >= img.h) continue;
        for (int xx = 0; xx < sw; ++xx) {
            int srcx = sx + xx;
            if (srcx < 0 || srcx >= img.w) continue;
            put(dx + xx, dy + yy, img.idx[srcy * img.w + srcx]);
        }
    }
}

int Surface::text_width(const Sheet& font, const std::string& s) const {
    int w = 0;
    for (unsigned char c : s) {
        if (c < font.frames.size()) w += font.frames[c].w + 1;
    }
    return w > 0 ? w - 1 : 0;
}

void Surface::draw_text(const Sheet& font, int x, int y, const std::string& s,
                        uint8_t color) {
    int cx = x;
    for (unsigned char c : s) {
        if (c >= font.frames.size()) continue;
        const Frame& g = font.frames[c];
        for (int yy = 0; yy < g.h; ++yy)
            for (int xx = 0; xx < g.w; ++xx)
                if (g.px[yy * g.w + xx] != SS_TRANSPARENT)
                    put(cx + xx, y + yy, color);
        cx += g.w + 1;   // 1px tracking between glyphs
    }
}

Image Surface::to_rgb(int scale) const {
    Image im;
    im.w = W * scale;
    im.h = H * scale;
    im.rgb.resize((size_t)im.w * im.h * 3);
    for (int y = 0; y < im.h; ++y) {
        for (int x = 0; x < im.w; ++x) {
            uint8_t p = idx[(y / scale) * W + (x / scale)];
            size_t o = ((size_t)y * im.w + x) * 3;
            im.rgb[o + 0] = pal[p * 3 + 0];
            im.rgb[o + 1] = pal[p * 3 + 1];
            im.rgb[o + 2] = pal[p * 3 + 2];
        }
    }
    return im;
}

} // namespace vc
