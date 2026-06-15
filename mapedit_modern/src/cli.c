/*
 * cli.c — "mpedit", a headless driver for the map core.
 *
 * Subcommands:
 *   mpedit info   FILE            dimensions, layer/terrain stats, mass counts
 *   mpedit verify FILE            load -> save -> byte-compare (round-trip proof)
 *   mpedit ascii  FILE            print an ASCII minimap
 *   mpedit new    W H OUT         create a blank W x H map (ocean fill)
 *
 * The "verify" path is the format guarantee that backs the editor's
 * save/export: a clean load/save reproduces the input byte-for-byte.
 */
#include "mp.h"
#include "terrain.h"
#include "editor.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int read_file(const char *path, uint8_t **out, size_t *len)
{
    FILE *f = fopen(path, "rb");
    if (!f) return -1;
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    rewind(f);
    if (sz < 0) { fclose(f); return -1; }
    uint8_t *b = malloc((size_t)sz ? (size_t)sz : 1);
    if (fread(b, 1, (size_t)sz, f) != (size_t)sz) { free(b); fclose(f); return -1; }
    fclose(f);
    *out = b; *len = (size_t)sz;
    return 0;
}

static int cmd_info(const char *path)
{
    char err[256];
    mp_map *m = mp_load(path, err, sizeof err);
    if (!m) { fprintf(stderr, "load failed: %s\n", err); return 1; }

    size_t n = mp_tile_count(m);
    long counts[32] = {0};
    int prime = 0, river = 0, forest = 0;
    for (size_t i = 0; i < n; i++) {
        uint8_t b = m->terrain[i];
        counts[MP_TERRAIN_ID(b)]++;
        if (b & MP_FLAG_PRIME) prime++;
        if (b & MP_FLAG_ROADRIVER) river++;
        if (b & MP_FLAG_FOREST) forest++;
    }

    printf("file         : %s\n", path);
    printf("dimensions   : %u x %u  (%zu tiles)\n", m->width, m->height, n);
    printf("on-disk size : %zu bytes  (header 4 + 3 layers + %zu trailer)\n",
           mp_file_size(m), m->trailer_len);
    printf("overlays     : prime=%d road/river=%d forest=%d\n", prime, river, forest);

    editor *e = editor_create(m);
    int cont = 0, ocean = 0;
    editor_count_masses(e, &cont, &ocean);
    printf("masses       : %d continents, %d oceans%s\n",
           cont, ocean, ocean > 15 ? "  (WARNING: >15 oceans)" : "");

    printf("terrain id histogram:\n");
    for (int id = 0; id < 32; id++) {
        if (!counts[id]) continue;
        const terrain_info *t = terrain_by_id((uint8_t)id);
        printf("  %2d  %-10s %6ld%s\n", id, t ? t->name : "?",
               counts[id], (t && t->uncertain) ? "  [name TODO_VERIFY]" : "");
    }
    editor_destroy(e);   /* frees m */
    return 0;
}

static int cmd_verify(const char *path)
{
    char err[256];
    mp_map *m = mp_load(path, err, sizeof err);
    if (!m) { fprintf(stderr, "load failed: %s\n", err); return 1; }

    const char *tmp = "._mpedit_verify.tmp";
    if (mp_save(m, tmp) != 0) { fprintf(stderr, "save failed\n"); mp_free(m); return 1; }
    mp_free(m);

    uint8_t *a = NULL, *b = NULL; size_t la = 0, lb = 0;
    int rc = 1;
    if (read_file(path, &a, &la) == 0 && read_file(tmp, &b, &lb) == 0) {
        if (la == lb && memcmp(a, b, la) == 0) {
            printf("ROUND-TRIP PASS: %s  (%zu bytes identical)\n", path, la);
            rc = 0;
        } else {
            printf("ROUND-TRIP FAIL: sizes %zu vs %zu\n", la, lb);
            for (size_t i = 0; i < (la < lb ? la : lb); i++)
                if (a[i] != b[i]) { printf("  first diff at byte %zu: %02x vs %02x\n", i, a[i], b[i]); break; }
        }
    }
    free(a); free(b);
    remove(tmp);
    return rc;
}

static int cmd_ascii(const char *path)
{
    char err[256];
    mp_map *m = mp_load(path, err, sizeof err);
    if (!m) { fprintf(stderr, "load failed: %s\n", err); return 1; }

    for (int y = 0; y < m->height; y++) {
        for (int x = 0; x < m->width; x++) {
            uint8_t id = MP_TERRAIN_ID(m->terrain[mp_idx(m, x, y)]);
            const terrain_info *t = terrain_by_id(id);
            char c = '?';
            if (t && t->is_water)               c = (id == 26) ? ':' : '~';
            else if (t && t->group == TGROUP_FORESTED) c = '#';
            else if (t)                         c = '.';
            putchar(c);
        }
        putchar('\n');
    }
    mp_free(m);
    return 0;
}

static int cmd_new(const char *ws, const char *hs, const char *out)
{
    int w = atoi(ws), h = atoi(hs);
    if (w <= 0 || h <= 0) { fprintf(stderr, "bad dimensions\n"); return 1; }
    mp_map *m = mp_new((uint16_t)w, (uint16_t)h);
    if (!m) { fprintf(stderr, "alloc failed\n"); return 1; }
    /* Ocean fill with sea-lane border columns, like a fresh editor map. */
    for (int y = 0; y < h; y++)
        for (int x = 0; x < w; x++)
            m->terrain[mp_idx(m, x, y)] = (x == 0 || x == w - 1) ? 26 : 25;
    int rc = mp_save(m, out) == 0 ? 0 : 1;
    if (rc == 0) printf("wrote %s (%dx%d, %zu bytes)\n", out, w, h, mp_file_size(m));
    mp_free(m);
    return rc;
}

static int usage(void)
{
    fprintf(stderr,
        "usage:\n"
        "  mpedit info   FILE\n"
        "  mpedit verify FILE\n"
        "  mpedit ascii  FILE\n"
        "  mpedit new    W H OUT\n");
    return 2;
}

int main(int argc, char **argv)
{
    if (argc < 2) return usage();
    if (!strcmp(argv[1], "info")   && argc == 3) return cmd_info(argv[2]);
    if (!strcmp(argv[1], "verify") && argc == 3) return cmd_verify(argv[2]);
    if (!strcmp(argv[1], "ascii")  && argc == 3) return cmd_ascii(argv[2]);
    if (!strcmp(argv[1], "new")    && argc == 5) return cmd_new(argv[2], argv[3], argv[4]);
    return usage();
}
