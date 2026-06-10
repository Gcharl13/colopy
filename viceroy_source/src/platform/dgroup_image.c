/* ============================================================================
 * dgroup_image.c -- load the DGROUP initialized-data window from the user's
 *                   own VICEROY.EXE at runtime
 * ----------------------------------------------------------------------------
 * The DS [0x0000 .. 0x2CC5) window holds the game's INITIALIZED static data
 * (embedded control tables: NEIGHBOR_DX/DY @0x00B4/0x00BE, sprite dims
 * @0x0230/0x0236, building slot positions @0x0266, GOOD_TO_RAW @0x02AA,
 * terrain-yield @0x2F7B is past the window, ...).  In the original these
 * bytes are part of VICEROY.EXE's load image.
 *
 * COPYRIGHT CONSTRAINT: the modern build must NOT embed VICEROY.EXE bytes.
 * Exactly like the .PIK/.SS/.TXT assets, the window is read at RUNTIME from
 * the user-supplied install (game_data/VICEROY.EXE) -- nothing is stored in
 * the repository or the built binary.
 *
 * File mapping (BYTE_VERIFIED): the resident formula file = 0x2400 + seg*16
 * puts DGROUP (DS para 0x1B5A) at file 0x1D9A0; anchored by audit.py's
 * NEIGHBOR_DX check "00 01 01 01 00 ff ff ff" @ file 0x1DA54 = 0x1D9A0+0xB4.
 * ============================================================================ */
#ifdef _VICEROY_MODERN

#include <stdio.h>
#include <string.h>
#include <stdint.h>

extern unsigned char g_dgroup[];

#define DGROUP_FILE_BASE  0x1D9A0u   /* DS para 0x1B5A << 4, + 0x2400 */
#define DGROUP_INIT_SIZE  0x2CC5u    /* initialized window; >= is BSS */

/* Load the initialized window from <data_dir>/VICEROY.EXE.
 * Returns 0 on success (window loaded and anchor verified), -1 otherwise.
 * Call AFTER dgroup_init() and BEFORE the .TXT table loaders (those own and
 * overwrite their regions). */
int dgroup_load_image(const char *data_dir)
{
    static const uint8_t anchor[8] =        /* NEIGHBOR_DX[8] @DS:0xB4 */
        { 0x00, 0x01, 0x01, 0x01, 0x00, 0xFF, 0xFF, 0xFF };
    char path[512];
    FILE *f = NULL;
    size_t got;

    snprintf(path, sizeof path, "%s/VICEROY.EXE", data_dir);
    f = fopen(path, "rb");
    if (!f) {
        snprintf(path, sizeof path, "%s/COLONIZE/VICEROY.EXE", data_dir);
        f = fopen(path, "rb");
    }
    if (!f) return -1;

    if (fseek(f, DGROUP_FILE_BASE, SEEK_SET) != 0) { fclose(f); return -1; }
    got = fread(g_dgroup, 1, DGROUP_INIT_SIZE, f);
    fclose(f);
    if (got != DGROUP_INIT_SIZE) return -1;

    if (memcmp(g_dgroup + 0xB4, anchor, sizeof anchor) != 0) {
        /* not the expected image (different EXE build?) -- zero the window
         * back rather than run on a misaligned table set */
        memset(g_dgroup, 0, DGROUP_INIT_SIZE);
        return -1;
    }
    return 0;
}

#endif /* _VICEROY_MODERN */
