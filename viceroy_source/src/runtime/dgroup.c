/* ============================================================================
 * runtime/dgroup.c -- the modern-build DGROUP data segment
 * ----------------------------------------------------------------------------
 * Defines the 64 KB data segment as a real array for the -D_VICEROY_MODERN
 * build. Under the period DOS toolchain this file compiles to nothing (DS is
 * the real DGROUP segment; see include/dgroup.h).
 *
 * The decompiled rules layer pokes DS offsets through the DG8/DG16/... accessors
 * (include/dgroup.h), which index this array. A modern front end shares the same
 * g_dgroup state, so no game logic is duplicated.
 * ============================================================================ */
#include "dgroup.h"

#ifdef _VICEROY_MODERN

uint8_t g_dgroup[DGROUP_SIZE];   /* zero-initialized; static window filled by dgroup_init() */

void dgroup_init(void)
{
    /* The DS [0x0000 .. 0x2CC5) window holds the game's INITIALIZED static data:
     * the embedded control tables (NEIGHBOR_DX/DY @0x00B4/0x00BE, GOOD_TO_RAW
     * @0x02AA, GOOD_TO_CHAIN @0x02FD, terrain-yield @0x2F7B, ...) plus C-runtime
     * string/stream descriptors. In the original these bytes are part of
     * VICEROY.EXE's load image.
     *
     * COPYRIGHT CONSTRAINT: the modern build must NOT embed VICEROY.EXE bytes.
     * This window is therefore reconstructed from (a) the game's own data files
     * (COLONIZE/NAMES.TXT, TRIBE.TXT, ...) loaded at startup, and (b) a
     * separately-maintained constants source for the handful of embedded tables
     * (their values are documented byte-for-byte in tools/audit.py and
     * docs/DGROUP_MEMORY_MAP.md, which are analysis metadata, not game bytes).
     *
     * Everything at DS >= ~0x2CC5 is BSS: zero at start, populated at runtime by
     * the game logic itself, so it needs no initialization here.
     *
     * TODO(milestone-3): populate the initialized window. Until then g_dgroup is
     * all-zero, which is correct for the BSS region and a safe default for the
     * static window (the game overwrites most of it during new-game setup).
     */
}

#endif /* _VICEROY_MODERN */
