/* ============================================================================
 * runtime/dgroup.c -- the DGROUP data segment + record-table pointers
 * ----------------------------------------------------------------------------
 * Defines the data segment as a real array for the -D_VICEROY_MODERN build, and
 * the record-table pointers (unit_table / power / ai_personality) in BOTH build
 * modes. The decompiled rules layer pokes DS offsets through the DG8/DG16/...
 * accessors (include/dgroup.h) and indexes the tables by name; both resolve to
 * the SAME data segment -- g_dgroup in modern, DS:0 in DOS.
 *
 * Callers must invoke dgroup_init() at startup before touching game state.
 * ============================================================================ */
#include "dgroup.h"
#include "unit.h"
#include "power.h"
#include "ai_personality.h"
#include "colony.h"
#include <stddef.h>

/* Record-table pointers alias the flat tables at their DGROUP_MEMORY_MAP offsets,
 * so `unit_table[i].field` / `power[p].gold` read the SAME memory the offset
 * pokes touch. Local vars/params named `power` shadow the global normally. */
struct UnitRecord    far *unit_table;       /* DG_UNIT_TABLE @0x3144 */
struct PowerRecord       *power;            /* DG_POWER_TABLE @0x8808 */
struct AIPersonality     *ai_personality;   /* DG_AI_TABLE    @0x540E */
struct colony_t     far *ctx = NULL;        /* DGROUP:0x8542 current-colony pointer */

#ifdef _VICEROY_MODERN
uint8_t g_dgroup[DGROUP_SIZE];   /* zero-initialized; static window filled below */
#endif

void dgroup_init(void)
{
    /* Point the record tables at the data segment (DG_BASE+offset). */
    unit_table     = DG_UNIT_TABLE;
    power          = DG_POWER_TABLE;
    ai_personality = DG_AI_TABLE;

#ifdef _VICEROY_MODERN
    /* The DS [0x0000 .. 0x2CC5) window holds the game's INITIALIZED static data:
     * embedded control tables (NEIGHBOR_DX/DY @0x00B4/0x00BE, GOOD_TO_RAW @0x02AA,
     * GOOD_TO_CHAIN @0x02FD, terrain-yield @0x2F7B, ...) plus C-runtime stream
     * descriptors. In the original these bytes are part of VICEROY.EXE's image.
     *
     * COPYRIGHT CONSTRAINT: the modern build must NOT embed VICEROY.EXE bytes.
     * This window is reconstructed from (a) the game's own data files
     * (COLONIZE/NAMES.TXT, ...) loaded at startup and (b) a separately-maintained
     * constants source for the few embedded tables (their values are documented
     * byte-for-byte in tools/audit.py + docs/DGROUP_MEMORY_MAP.md -- analysis
     * metadata, not game bytes).
     *
     * Everything at DS >= ~0x2CC5 is BSS: zero at start, populated at runtime by
     * the game logic itself. TODO(milestone-3): populate the initialized window.
     */
#endif
}
