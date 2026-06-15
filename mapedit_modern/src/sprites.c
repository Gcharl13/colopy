/*
 * sprites.c — terrain tile drawing (see sprites.h).
 *
 * The PHYS0.SS decoder is not wired up yet (no sprite assets are bundled with
 * this repo), so sprite_have_sheet() is currently always false and every tile
 * is drawn via the colored-cell fallback. The fallback is fully featured:
 * base colour by terrain id plus distinct markers for the river/forest/prime
 * overlay bits, and a striped sea-lane so it reads differently from open ocean.
 */
#include "sprites.h"
#include "mp.h"
#include "terrain.h"

static bool g_have_sheet = false;

bool sprite_have_sheet(void) { return g_have_sheet; }

bool sprite_load_phys0(const char *colonize_dir)
{
    (void)colonize_dir;
    /* TODO: decode PHYS0.SS (see ../formats/SS.md) + apply VICEROY.PAL.
     * Until then we always use the colored-tile fallback. */
    g_have_sheet = false;
    return g_have_sheet;
}

static uint32_t darken(uint32_t c, int pct)
{
    int r = (int)((c >> 16) & 0xFF) * (100 - pct) / 100;
    int g = (int)((c >> 8) & 0xFF) * (100 - pct) / 100;
    int b = (int)(c & 0xFF) * (100 - pct) / 100;
    return RGB(r, g, b);
}

void sprite_draw_tile(fb *f, int px, int py, int tp, uint8_t tile_byte)
{
    uint8_t id = MP_TERRAIN_ID(tile_byte);
    uint32_t base = terrain_color(id);

    fb_fill_rect(f, px, py, tp, tp, base);

    /* subtle within-tile texture so large tiles don't look flat */
    if (tp >= 6 && id != 25 && id != 26) {
        uint32_t mottle = darken(base, 12);
        for (int yy = 1; yy < tp; yy += 3)
            fb_hline(f, px + 1, py + yy, tp - 2, mottle);
    }

    if (tp < 5)
        return;   /* too small for overlay markers */

    /* Forest overlay (bit 7): two dark conifer triangles. */
    if (tile_byte & MP_FLAG_FOREST) {
        uint32_t fg = RGB(0x16, 0x40, 0x1C);
        int t = tp;
        for (int dy = 0; dy < t / 2; dy++) {
            int wq = dy;
            fb_hline(f, px + t / 4 - wq / 2, py + t / 4 + dy, wq + 1, fg);
            fb_hline(f, px + 3 * t / 4 - wq / 2, py + t / 4 + dy, wq + 1, fg);
        }
    }

    /* Road / river (bit 6): blue line through the tile. */
    if (tile_byte & MP_FLAG_ROADRIVER) {
        uint32_t rv = RGB(0x30, 0x70, 0xD8);
        int cy = py + tp / 2;
        fb_fill_rect(f, px, cy - (tp >= 14 ? 1 : 0), tp, tp >= 14 ? 3 : 1, rv);
    }

    /* Prime resource (bit 5): small marker, top-right. */
    if (tile_byte & MP_FLAG_PRIME) {
        int s = tp / 4 < 2 ? 2 : tp / 4;
        fb_fill_rect(f, px + tp - s - 1, py + 1, s, s, RGB(0xFF, 0xE0, 0x40));
    }
}
