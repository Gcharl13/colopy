/* ============================================================================
 * test_frame_setup.c -- DGROUP-state assertions for the PORTED func_06787C
 * (render_frame_setup, file 0x6787C..0x67A22).  Expected values follow the
 * decoded arithmetic directly; run after any render-geometry change:
 *   gcc -D_VICEROY_MODERN -Iinclude tests/test_frame_setup.c \
 *       tools/generated/linkfloor_stubs.c tools/generated/thunk_keepalive.c \
 *       build_modern/libviceroy_rules.a tools/generated/linkfloor.ld \
 *       tools/generated/thunk_wiring.ld tools/linkfloor_extra.ld -o t && ./t
 * ============================================================================ */
#include <stdio.h>
#include "viceroy_types.h"
#include "dgroup.h"

extern void dgroup_init(void);
extern void render_frame_setup(void);

static int fails;
static void eq(const char *what, int got, int want)
{
    if (got != want) { printf("FAIL %s: got %d want %d\n", what, got, want); fails++; }
}

int main(void)
{
    dgroup_init();

    /* AMER2 dims, mid-map center, zoom 0, slow path */
    DG16(0x853A) = 58; DG16(0x853C) = 72;
    DG16(0x017C) = 29; DG16(0x017E) = 36;
    DG16(0x0184) = 0;  DG16(0x015A) = 0; DG16(0x018A) = 0;
    render_frame_setup();
    eq("origin_col", (int16_t)DG16(0x8328), 22);   /* center-7  @0x678BC.. */
    eq("origin_row", (int16_t)DG16(0x832E), 30);   /* center-6 */
    eq("span_w", DG16(0x8544), 15);
    eq("span_h", DG16(0x8546), 12);
    eq("max_col", DG16(0x8804), 36);
    eq("max_row", DG16(0x8806), 41);
    eq("stride(slow)=map_w", DG16(0x8548), 58);    /* @0x679E8 */
    eq("rows(slow)=map_h", DG16(0x854A), 72);
    eq("win_base_col=origin-1", (int16_t)DG16(0x854C), 21); /* @0x67962 */
    eq("win_base_row=origin-1", (int16_t)DG16(0x854E), 29);
    eq("tile_px", DG16(0x5AD4), 16);
    eq("metric_186", DG16(0x0186), 0x64);
    eq("metric_188", DG16(0x0188), 10);            /* (5<<0)+5 @0x67A00 */

    /* edge clamps: center at the map corner */
    DG16(0x017C) = 0; DG16(0x017E) = 0;
    render_frame_setup();
    eq("clamp origin_col>=1", (int16_t)DG16(0x8328), 1);
    eq("clamp origin_row>=1", (int16_t)DG16(0x832E), 1);
    DG16(0x017C) = 57; DG16(0x017E) = 71;
    render_frame_setup();
    eq("clamp col<=w-span-1", (int16_t)DG16(0x8328), 58-15-1);
    eq("clamp row<=h-span-1", (int16_t)DG16(0x832E), 72-12-1);

    /* fast path stride/rows @0x67982-0x67992 */
    DG16(0x015A) = 1; DG16(0x017C) = 29; DG16(0x017E) = 36;
    render_frame_setup();
    eq("stride(fast)=(0xF<<z)+2", DG16(0x8548), 17);
    eq("rows(fast)=(0xC<<z)+2", DG16(0x854A), 14);

    printf(fails ? "FAILURES: %d\n" : "ALL PASS\n", fails);
    return fails != 0;
}
