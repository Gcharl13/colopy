/*
 * test_mp.c — core unit tests.
 *
 *  1. Byte-exact round-trip of a real stock map (AMER2.MP) if available.
 *  2. Synthetic round-trip (new map -> edits -> undo back to start).
 *  3. Tile bitfield + terrain-table sanity.
 *
 * Usage: test_mp [path-to-AMER2.MP]
 */
#include "mp.h"
#include "terrain.h"
#include "editor.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int failures = 0;
#define CHECK(cond, ...) do { \
    if (!(cond)) { printf("FAIL: "); printf(__VA_ARGS__); printf("\n"); failures++; } \
} while (0)

static int read_file(const char *p, uint8_t **out, size_t *len)
{
    FILE *f = fopen(p, "rb");
    if (!f) return -1;
    fseek(f, 0, SEEK_END); long sz = ftell(f); rewind(f);
    if (sz < 0) { fclose(f); return -1; }
    uint8_t *b = malloc((size_t)sz ? (size_t)sz : 1);
    size_t got = fread(b, 1, (size_t)sz, f);
    fclose(f);
    if (got != (size_t)sz) { free(b); return -1; }
    *out = b; *len = (size_t)sz;
    return 0;
}

static void test_real_map(const char *path)
{
    char err[256];
    mp_map *m = mp_load(path, err, sizeof err);
    if (!m) { printf("SKIP real-map test (%s)\n", err); return; }

    CHECK(m->width > 0 && m->height > 0, "dimensions");
    const char *tmp = "._test_rt.tmp";
    CHECK(mp_save(m, tmp) == 0, "save");

    uint8_t *a = NULL, *b = NULL; size_t la = 0, lb = 0;
    CHECK(read_file(path, &a, &la) == 0, "read orig");
    CHECK(read_file(tmp, &b, &lb) == 0, "read saved");
    CHECK(la == lb, "size match %zu vs %zu", la, lb);
    CHECK(a && b && la == lb && memcmp(a, b, la) == 0, "byte-exact round-trip of %s", path);
    printf("real-map round-trip: %s  %ux%u  %zu bytes  %s\n",
           path, m->width, m->height, la,
           (a && b && la == lb && memcmp(a, b, la) == 0) ? "PASS" : "FAIL");
    free(a); free(b); remove(tmp);
    mp_free(m);
}

static void test_synthetic(void)
{
    mp_map *m = mp_new(20, 15);
    CHECK(m != NULL, "mp_new");
    CHECK(mp_file_size(m) == 4 + 3u * 20 * 15 + 2, "file size formula");

    /* snapshot the starting layer */
    size_t n = mp_tile_count(m);
    uint8_t *before = malloc(n);
    memcpy(before, m->terrain, n);

    editor *e = editor_create(m);
    editor_select(e, 4 /*Grassland*/);
    editor_paint(e, 5, 5);
    editor_toggle_river(e, 5, 5);
    editor_toggle_forest(e, 6, 6);
    CHECK(MP_TERRAIN_ID(m->terrain[mp_idx(m, 5, 5)]) == 4, "paint set base id");
    CHECK((m->terrain[mp_idx(m, 5, 5)] & MP_FLAG_ROADRIVER) != 0, "river bit set");

    /* undo all three edits -> back to start */
    CHECK(editor_undo(e), "undo 1");
    CHECK(editor_undo(e), "undo 2");
    CHECK(editor_undo(e), "undo 3");
    CHECK(memcmp(before, m->terrain, n) == 0, "undo restores original layer");

    free(before);
    editor_destroy(e);   /* frees m */
}

static void test_terrain_table(void)
{
    CHECK(terrain_by_id(0)  && strcmp(terrain_by_id(0)->name, "Tundra") == 0, "id0=Tundra");
    CHECK(terrain_by_id(25) && terrain_by_id(25)->is_water, "id25=water");
    CHECK(terrain_by_id(26) && terrain_by_id(26)->is_water, "id26=water");
    CHECK(terrain_by_id(24) == NULL, "id24 unused");
    int n = 0;
    terrain_palette(&n);
    CHECK(n == 21, "palette has 21 entries (got %d)", n);

    char buf[64];
    /* verified classification: bit 0x20 = hills/mtn (0x80 = mtn); 0x40 = river */
    terrain_describe((uint8_t)(21 | 0x20), buf, sizeof buf);
    CHECK(strstr(buf, "Hills"), "describe hills: '%s'", buf);
    terrain_describe((uint8_t)(21 | 0x20 | 0x80), buf, sizeof buf);
    CHECK(strstr(buf, "Mountains"), "describe mtn: '%s'", buf);
    terrain_describe((uint8_t)(2 | MP_FLAG_ROADRIVER), buf, sizeof buf);
    CHECK(strstr(buf, "Plains") && strstr(buf, "river"), "describe river: '%s'", buf);
}

int main(int argc, char **argv)
{
    test_synthetic();
    test_terrain_table();
    if (argc > 1)
        test_real_map(argv[1]);
    else
        printf("(pass AMER2.MP path to also run the real-map round-trip)\n");

    if (failures == 0) { printf("ALL TESTS PASSED\n"); return 0; }
    printf("%d TEST(S) FAILED\n", failures);
    return 1;
}
