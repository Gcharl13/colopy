/* The external-framebuffer contract (COLOPY_EXTERNAL_FRAMEBUFFER=1, the
 * ESP32-P4 layout) proved on the host: EVERY unit is compiled with the
 * pointer layout for this binary.  Adopted from the sibling port
 * 2026-09-09, with its optional PAK/PPM pass through the real renderer.
 * `make render-storage`. */
#include <stdio.h>
#include <string.h>
#include "../render/colopy_render.h"

#if !COLOPY_EXTERNAL_FRAMEBUFFER
#error This test requires COLOPY_EXTERNAL_FRAMEBUFFER=1
#endif

static unsigned checks, failures;
#define CHECK(expr) do { ++checks; if (!(expr)) { ++failures; \
    fprintf(stderr, "FAIL line %d: %s\n", __LINE__, #expr); } } while (0)

static uint8_t first[RD_W * RD_H + 2], second[RD_W * RD_H + 2];
static int all_equal(const uint8_t *p, size_t n, uint8_t value) {
    while (n--) if (*p++ != value) return 0;
    return 1;
}
extern int render_smoke_main(const char *pak, const char *ppm);

int main(int argc, char **argv) {
    const char *names[] = {"TERRAIN.SS", "PHYS0.SS", "ICONS.SS", "WOODTILE.SS"};
    uint8_t pak[6 + 4 * 26] = {'C', 'P', 'A', 'K', 4, 0};
    for (int i = 0; i < 4; ++i)
        memcpy(pak + 6 + i * 26, names[i], strlen(names[i]));
    CHECK(sizeof(RD) < 2048); /* no hidden inline framebuffer remains */
    CHECK(!rd_init(pak, sizeof(pak))); /* unbound: fail before touching RAM */
    CHECK(!rd_bind_framebuffer(NULL, RD_W * RD_H));
    CHECK(!rd_bind_framebuffer(first + 1, RD_W * RD_H - 1));
    CHECK(RD.fb == NULL);
    memset(first, 0xa5, sizeof(first));
    CHECK(rd_bind_framebuffer(first + 1, RD_W * RD_H));
    CHECK(rd_init(pak, sizeof(pak)));
    CHECK(RD.fb == first + 1);
    CHECK(all_equal(RD.fb, RD_W * RD_H, 0));
    CHECK(first[0] == 0xa5 && first[sizeof(first) - 1] == 0xa5);
    rd_fill(-4, -4, RD_W + 8, RD_H + 8, 37);
    CHECK(all_equal(RD.fb, RD_W * RD_H, 37));
    CHECK(first[0] == 0xa5 && first[sizeof(first) - 1] == 0xa5);
    CHECK(!rd_bind_framebuffer(NULL, RD_W * RD_H));
    CHECK(!rd_bind_framebuffer(second + 1, 0));
    CHECK(RD.fb == first + 1 && RD.fb[0] == 37);
    CHECK(rd_init(pak, sizeof(pak))); /* repeated init must not lose binding */
    CHECK(RD.fb == first + 1 && all_equal(RD.fb, RD_W * RD_H, 0));
    CHECK(!rd_init(pak, 0));
    CHECK(RD.fb == first + 1);
    CHECK(rd_init(pak, sizeof(pak))); /* recover after failed PAK init */
    memset(second, 0x5a, sizeof(second));
    CHECK(rd_bind_framebuffer(second + 1, RD_W * RD_H));
    CHECK(rd_init(pak, sizeof(pak)));
    rd_fill(0, 0, RD_W, RD_H, 19);
    CHECK(all_equal(second + 1, RD_W * RD_H, 19));
    CHECK(all_equal(first + 1, RD_W * RD_H, 0));
    CHECK(second[0] == 0x5a && second[sizeof(second) - 1] == 0x5a);
    if (argc == 3) {
        CHECK(render_smoke_main(argv[1], argv[2]) == 0);
        CHECK(RD.fb == second + 1);
        CHECK(second[0] == 0x5a && second[sizeof(second) - 1] == 0x5a);
    }
    printf("External framebuffer: %u/%u PASS\n", checks - failures, checks);
    return failures ? 1 : 0;
}
