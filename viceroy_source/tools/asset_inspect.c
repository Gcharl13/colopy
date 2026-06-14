/* asset_inspect.c -- dev tool: dump a .PIK or .SS asset to PPM + print palette.
 * Links against the engine's pik_load/ss_load. NOT part of the game build.
 *   usage: asset_inspect pik  PATH out.ppm
 *          asset_inspect ss   PATH frame out.ppm
 *          asset_inspect pal   PATH            (print 6-bit palette indices)
 */
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "platform.h"

static void write_ppm_idx(const char *out, const uint8_t *px, int w, int h,
                          const uint8_t *pal /*8-bit rgb*/)
{
    FILE *f = fopen(out, "wb");
    fprintf(f, "P6\n%d %d\n255\n", w, h);
    for (int i = 0; i < w*h; i++) {
        uint8_t c = px[i];
        fputc(pal[c*3+0], f); fputc(pal[c*3+1], f); fputc(pal[c*3+2], f);
    }
    fclose(f);
}

int main(int argc, char **argv)
{
    if (argc < 3) { fprintf(stderr, "usage: %s pik|ss|pal PATH ...\n", argv[0]); return 1; }
    if (!strcmp(argv[1], "pik")) {
        pik_image_t img;
        if (pik_load(argv[2], &img) != 0) { fprintf(stderr, "pik_load failed\n"); return 1; }
        printf("PIK %dx%d has_pal=%d\n", img.w, img.h, img.has_pal);
        write_ppm_idx(argv[3], img.pixels, img.w, img.h, img.pal);
        return 0;
    }
    if (!strcmp(argv[1], "ss")) {
        ss_sheet_t s;
        if (ss_load(argv[2], &s) != 0) { fprintf(stderr, "ss_load failed\n"); return 1; }
        printf("SS nframes=%d has_pal=%d\n", s.nframes, s.has_pal);
        for (int i = 0; i < s.nframes && i < 8; i++)
            printf("  frame %d: %dx%d at (%d,%d)\n", i,
                   s.frames[i].w, s.frames[i].h, s.frames[i].x, s.frames[i].y);
        int fr = argc > 3 ? atoi(argv[3]) : 0;
        if (fr < s.nframes) {
            uint8_t pal[768];
            for (int i = 0; i < 768; i++)
                pal[i] = (uint8_t)((s.pal6[i] << 2) | (s.pal6[i] >> 4));
            ss_frame_t *F = &s.frames[fr];
            /* expand transparent to magenta for visibility */
            uint8_t *buf = malloc(F->w * F->h);
            memcpy(buf, F->pixels, F->w * F->h);
            write_ppm_idx(argv[4], buf, F->w, F->h, pal);
            free(buf);
        }
        return 0;
    }
    if (!strcmp(argv[1], "pikpal")) {
        pik_image_t img;
        if (pik_load(argv[2], &img) == 0 && img.has_pal) {
            for (int i = 0; i < 256; i++) {
                int r=img.pal[i*3], g=img.pal[i*3+1], b=img.pal[i*3+2];
                const char *tag="";
                if (g>r+40 && g>b+40) tag=" <-GREENish";
                if (r>120 && g>90 && b<80 && r>=g) tag=" <-GOLDish";
                printf("%3d: %02x %02x %02x%s\n", i, r, g, b, tag);
            }
        }
        return 0;
    }
    if (!strcmp(argv[1], "pal")) {
        ss_sheet_t s;
        if (ss_load(argv[2], &s) == 0 && s.has_pal) {
            for (int i = 0; i < 256; i++)
                printf("%3d: %02x %02x %02x\n", i,
                       s.pal6[i*3]<<2, s.pal6[i*3+1]<<2, s.pal6[i*3+2]<<2);
        }
        return 0;
    }
    return 1;
}
