/*
 * shot.c — render the editor screen for a map to a BMP, headless.
 *
 * This exercises the entire UI renderer (menu bar, map viewport, palette,
 * status bar) with no windowing system, so the layout can be verified in CI
 * or by eyeballing a screenshot.
 *
 *   mpedit-shot FILE.MP OUT.bmp [zoom 0..3] [cursorx cursory] [open-menu 0..3]
 */
#include "ui.h"
#include "sprites.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
    if (argc < 3) {
        fprintf(stderr, "usage: mpedit-shot FILE.MP OUT.bmp [zoom] [cx cy] [menu]\n");
        return 2;
    }
    char err[256];
    mp_map *m = mp_load(argv[1], err, sizeof err);
    if (!m) { fprintf(stderr, "load failed: %s\n", err); return 1; }

    const char *adir = getenv("COLONIZE_DIR");
    adir = adir ? adir : "../raw/COLONIZE";
    sprite_load_phys0(adir);   /* real art if present */
    ui_load_fonts(adir);       /* real game fonts if present */

    editor *e = editor_create(m);
    ui_view v;
    ui_view_init(&v);

    if (argc > 3) v.zoom = atoi(argv[3]) & 3;
    e->cursor_x = (argc > 5) ? atoi(argv[4]) : m->width / 2;
    e->cursor_y = (argc > 5) ? atoi(argv[5]) : m->height / 2;
    if (argc > 6) {
        int mv = atoi(argv[6]);
        if (mv == 9) v.tile_select_open = 1;   /* 9 = open Map Tile Select popup */
        else         v.menu_open = mv;
    }
    editor_select(e, 4);   /* Grassland, for a visible selection highlight */

    ui_center_on(&v, e, e->cursor_x, e->cursor_y);

    fb *f = fb_create(UI_WIN_W, UI_WIN_H);
    ui_render(f, e, &v);

    /* upscale the native 320x200 frame by UI_SCALE for a modern-size image */
    int S = UI_SCALE;
    fb *big = fb_create(UI_WIN_W * S, UI_WIN_H * S);
    for (int y = 0; y < big->h; y++)
        for (int x = 0; x < big->w; x++)
            big->px[(size_t)y * big->w + x] = f->px[(size_t)(y / S) * f->w + (x / S)];

    const char *out = argv[2];
    size_t L = strlen(out);
    int rc = (L >= 4 && (out[L-3]=='p'||out[L-3]=='P'))
                 ? fb_save_png(big, out) : fb_save_bmp(big, out);
    if (rc == 0) printf("wrote %s (%dx%d)\n", out, big->w, big->h);
    else fprintf(stderr, "save failed\n");
    fb_free(big);

    fb_free(f);
    editor_destroy(e);
    return rc ? 1 : 0;
}
