/* ============================================================================
 * dgroup.h -- the VICEROY DGROUP (data segment) memory model
 * ----------------------------------------------------------------------------
 * The original game keeps ALL mutable global state in one 16-bit data segment
 * (DGROUP), reached as DS-relative offsets -- e.g. `*(uint16_t near*)0x8542`.
 * The reconstruction faithfully preserves those offsets (see DGROUP_MEMORY_MAP.md).
 * This header is the bridge that lets the SAME byte-exact code build and run in
 * two worlds:
 *
 *   DOS (period toolchain, default):  DS == DGROUP, so a `near` pointer to
 *       offset N already addresses the real datum.  DG_BASE is 0.
 *
 *   MODERN (-D_VICEROY_MODERN):  there is no DGROUP segment, so the 64 KB data
 *       segment is allocated as a real array g_dgroup[] and every DS offset N
 *       maps to &g_dgroup[N].  The byte-exact pokes then read/write the real
 *       game state living in g_dgroup -- they COMPILE and RUN.  A modern front
 *       end (SDL graphics / input / sound) operates on that same g_dgroup state,
 *       so the decompiled rules layer is reused verbatim.
 *
 * USE: replace raw `*(uint16_t near*)0xADDR` pokes with the typed accessors
 * below (DG16(0xADDR) etc.).  This is mechanical and preserves the address, so
 * the @asm citations stay valid.  The named globals (globals.h) and the record
 * tables (unit_table@0x3144, ColonyRecord@0x5D46, PowerRecord@0x8808, ...) alias
 * into g_dgroup at their DGROUP_MEMORY_MAP offsets via DG_TABLE(), giving one
 * source of truth.
 *
 * @ref docs/DGROUP_MEMORY_MAP.md   (every offset -> field)
 * @ref docs/dgroup_map.json        (machine-readable index for the conversion)
 * ============================================================================ */
#ifndef VICEROY_DGROUP_H
#define VICEROY_DGROUP_H

#include "viceroy_types.h"

#define DGROUP_SIZE  0x10000u    /* 64 KB data segment (DS:0x0000..0xFFFF) */

#ifdef _VICEROY_MODERN
extern uint8_t g_dgroup[DGROUP_SIZE];     /* the real data segment (runtime/dgroup.c) */
#  define DG_BASE   (g_dgroup)
#else
#  define DG_BASE   ((uint8_t near *)0)    /* DS-relative: offset 0 == DGROUP:0 */
#endif

/* Pointer to a DS offset (replaces `(T near*)0xADDR` / DGROUP_PTR). */
#define DG_PTR(off)   ((void near *)(DG_BASE + (uint16_t)(off)))

/* Typed scalar accessors (replace raw `*(T near*)0xADDR` pokes).
 * NOTE: 16/32-bit accessors assume the x86 unaligned-load semantics the original
 * relies on; on the period target and on x86 modern hosts this is exact. */
#define DG8(off)      (*(uint8_t  near *)(DG_BASE + (uint16_t)(off)))
#define DGS8(off)     (*(int8_t   near *)(DG_BASE + (uint16_t)(off)))
#define DG16(off)     (*(uint16_t near *)(DG_BASE + (uint16_t)(off)))
#define DGS16(off)    (*(int16_t  near *)(DG_BASE + (uint16_t)(off)))
#define DG32(off)     (*(uint32_t near *)(DG_BASE + (uint16_t)(off)))
#define DGS32(off)    (*(int32_t  near *)(DG_BASE + (uint16_t)(off)))

/* Typed table base at a DS offset: DG_TABLE(struct UnitRecord, 0x3144)[i].field
 * aliases the flat record table in g_dgroup (no separate allocation). */
#define DG_TABLE(type, off)   ((type near *)(DG_BASE + (uint16_t)(off)))

/* Canonical table bases (offsets proven in DGROUP_MEMORY_MAP.md). */
#define DG_UNIT_TABLE     DG_TABLE(struct UnitRecord,       0x3144)  /* stride 0x1C, 300 max */
#define DG_AI_TABLE       DG_TABLE(struct AIPersonality,    0x540E)  /* stride 0x34, 4 EU    */
#define DG_SETTLE_TABLE   DG_TABLE(struct NativeSettlement, 0x54EC)  /* stride 0x12, 84 max  */
#define DG_COLONY_TABLE   DG_TABLE(struct ColonyRecord,     0x5D46)  /* stride 0xCA          */
#define DG_POWER_TABLE    DG_TABLE(struct PowerRecord,      0x8808)  /* stride 0x13C, 4 EU   */

/* Make the legacy DGROUP_PTR (viceroy_types.h) memory-model-aware too, so files
 * that include dgroup.h get correct modern behavior without edits. */
#undef  DGROUP_PTR
#define DGROUP_PTR(addr)  DG_PTR(addr)

/* Modern build: g_dgroup is zero-initialized; dgroup_init() reconstructs the
 * INITIALIZED static-data window (DS 0x0000..0x2CC5) from the game data files
 * -- NOT from VICEROY.EXE bytes (copyright). Everything >= ~0x2CC5 is BSS. */
#ifdef _VICEROY_MODERN
void dgroup_init(void);
#endif

#endif /* VICEROY_DGROUP_H */
