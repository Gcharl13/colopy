/* --render smoke: draw a deterministic scene through the Phase-7 render
 * core and write the fb as a P6 PPM (palette-mapped RGB888).
 * tools/render_compare.py rebuilds the SAME scene straight from the
 * original assets via tools/ssdec.py and diffs pixel-exactly — an
 * oracle independent of the pak pipeline. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../render/colopy_render.h"

static uint8_t *slurp(const char *path, long *out_len) {
    FILE *f = fopen(path, "rb");
    if (!f) return 0;
    fseek(f, 0, SEEK_END);
    *out_len = ftell(f);
    fseek(f, 0, SEEK_SET);
    uint8_t *buf = (uint8_t *)malloc((size_t)*out_len);
    if (!buf || fread(buf, 1, (size_t)*out_len, f) != (size_t)*out_len) {
        fclose(f);
        free(buf);
        return 0;
    }
    fclose(f);
    return buf;
}

int render_smoke_main(const char *pak_path, const char *out_path) {
    long len;
    uint8_t *pak = slurp(pak_path, &len);
    if (!pak) { fprintf(stderr, "render: cannot read %s\n", pak_path); return 1; }
    if (!rd_init(pak, (uint32_t)len)) {
        fprintf(stderr, "render: bad pak\n");
        return 1;
    }
    /* the map screen's chrome palette (drawMap: usePalette('WOODTILE')) */
    rd_use_palette("WOODTILE.SS");

    /* 1. WOODTILE frame 0 tiled over the 320x200 logical screen */
    rd_frame wt;
    rd_sheet_frame(&RD.woodtile, 0, &wt);
    for (int y = 0; y < RD_GAME_H; y += wt.h)
        for (int x = 0; x < RD_W; x += wt.w)
            rd_blit(&RD.woodtile, 0, x, y);
    /* 2. the viewport black (drawMap VP = 0,8,240,192) */
    rd_fill(0, 8, 240, 192, 0);
    /* 3. every TERRAIN ground frame in a strip */
    for (int k = 0; k < RD.terrain.frames; k++)
        rd_blit(&RD.terrain, k, 4 + k * 17, 12);
    /* 4. a band of PHYS0 overlays (transparency over the grounds) */
    for (int k = 0; k < 24; k++)
        rd_blit(&RD.phys0, k, 4 + k * 13, 40);
    /* 5. ICONS over the wood chrome */
    for (int k = 0; k < 16; k++)
        rd_blit(&RD.icons, k, 244 + (k % 4) * 18, 12 + (k / 4) * 18);
    /* 6. text in each pak font */
    rd_font tiny, intr, king;
    const uint8_t lut15[4] = { 0xFF, 15, 14, 0 };   /* lut(i)=[i,i-1,black] */
    if (rd_font_open(&RD.pak, "FONTTINY.FF", &tiny))
        rd_text(&tiny, "COLOPY RENDER SELFTEST 0123456789", 4, 100, lut15);
    if (rd_font_open(&RD.pak, "FONTINTR.FF", &intr))
        rd_text(&intr, "Land Ho! What shall we call this new land?",
                4, 110, lut15);
    if (rd_font_open(&RD.pak, "FONTKING.FF", &king))
        rd_text(&king, "ABCXYZ abcxyz", 4, 130, lut15);

    FILE *o = fopen(out_path, "wb");
    if (!o) { fprintf(stderr, "render: cannot write %s\n", out_path); return 1; }
    fprintf(o, "P6\n%d %d\n255\n", RD_W, RD_H);
    for (int i = 0; i < RD_W * RD_H; i++)
        fwrite(RD.pal + RD.fb[i] * 3, 1, 3, o);
    fclose(o);
    printf("render selftest -> %s\n", out_path);
    free(pak);
    return 0;
}
