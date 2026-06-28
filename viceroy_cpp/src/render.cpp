// render.cpp -- see render.hpp. Mirrors tools/render_map.py:render_map.
#include "render.hpp"

namespace vc {

// Blit one sprite frame into `img` at pixel (dx,dy), nearest-resampling to
// tile_size if the frame isn't already tile_size square (matches the oracle's
// Image.resize(..., NEAREST)). Transparent pixels (0xFD) are skipped.
static void blit_frame(Image& img, const Frame& f, const uint8_t* pal,
                       int dx, int dy, int tile_size) {
    if (f.w <= 0 || f.h <= 0) return;
    for (int ty = 0; ty < tile_size; ++ty) {
        int sy = (f.h == tile_size) ? ty : (ty * f.h) / tile_size;
        if (sy >= f.h) sy = f.h - 1;
        for (int tx = 0; tx < tile_size; ++tx) {
            int sx = (f.w == tile_size) ? tx : (tx * f.w) / tile_size;
            if (sx >= f.w) sx = f.w - 1;
            uint8_t idx = f.px[(size_t)sy * f.w + sx];
            if (idx == SS_TRANSPARENT) continue;          // transparent
            int px = dx + tx, py = dy + ty;
            if (px < 0 || py < 0 || px >= img.w || py >= img.h) continue;
            uint8_t* o = &img.rgb[((size_t)py * img.w + px) * 3];
            o[0] = pal[idx * 3 + 0];
            o[1] = pal[idx * 3 + 1];
            o[2] = pal[idx * 3 + 2];
        }
    }
}

Image render_map(const Map& map, const Sheet& sheet, int tile_size) {
    Image img;
    img.w = map.w * tile_size;
    img.h = map.h * tile_size;
    img.rgb.assign((size_t)img.w * img.h * 3, 0);          // black background

    const int nf = (int)sheet.frames.size();
    for (int y = 0; y < map.h; ++y) {
        for (int x = 0; x < map.w; ++x) {
            uint8_t byte = map.tiles[(size_t)y * map.w + x];
            int terrain_id = byte & 0x1F;
            bool river = (byte & 0x20) != 0;

            // Skip placeholder sprite indices (CLAUDE.md hard rule #5).
            if (terrain_id == 0 || terrain_id == 16 || terrain_id == 100) continue;
            if (terrain_id >= nf) continue;                // no such sprite -> oracle 'continue'

            blit_frame(img, sheet.frames[terrain_id], sheet.pal,
                       x * tile_size, y * tile_size, tile_size);

            if (river && nf > 1) {                         // river overlay = frame 1
                blit_frame(img, sheet.frames[1], sheet.pal,
                           x * tile_size, y * tile_size, tile_size);
            }
        }
    }
    return img;
}

} // namespace vc
