/* ============================================================================
 * main_modern.c -- modern-host entry point (milestone 3)
 * ----------------------------------------------------------------------------
 * Replaces the DOS pair boot/entry.c + runtime/cstart.c.  Current scope is the
 * FIRST-LIGHT executable: initialize the DGROUP memory layer, drive one
 * render+update pass of the real (byte-traced) title-screen logic, and exit
 * cleanly.  Platform leaves (video/input/audio) are still the generated weak
 * no-op floor, so nothing draws yet -- the milestone is real rules code
 * executing on a modern host against g_dgroup state.
 *
 * Build: cmake target `viceroy_modern` (links libviceroy_rules.a + the
 * generated link floor; regenerate with tools/thunkwire.py + tools/linkgap.py
 * after any library change).
 *
 * Next steps here, in order (docs/LINK_GAP.md tracks the floor shrinking):
 *   1. dgroup_init() population of the initialized static window
 *      (DS 0x0000..0x2CC5) from the game's data files -- never from
 *      VICEROY.EXE bytes (copyright).
 *   2. SDL window + input swap-in for the render/input leaves.
 *   3. The in-game loop: game_main_loop() / game_tick_coordinator().
 * ============================================================================ */
#include <stdio.h>

#include "viceroy_types.h"
#include "dgroup.h"
#include "ui_screen.h"

extern void dgroup_init(void);
extern void title_screen_render(void);
extern int  title_screen_update(void);

int main(void)
{
    printf("viceroy_modern: first-light harness\n");

    dgroup_init();
    printf("  dgroup_init    : ok (DGROUP %u bytes at %p)\n",
           (unsigned)DGROUP_SIZE, (void *)g_dgroup);

    /* One pass of the real title-screen composer + menu dispatch.  All draw
     * leaves are weak no-ops, so this exercises control flow + DGROUP state,
     * not pixels. */
    title_screen_render();
    printf("  title render   : ok\n");

    int next = title_screen_update();
    printf("  title update   : ok (next screen id 0x%02X%s)\n",
           next, next == SCREEN_TITLE ? " = SCREEN_TITLE" : "");

    printf("viceroy_modern: clean exit\n");
    return 0;
}
