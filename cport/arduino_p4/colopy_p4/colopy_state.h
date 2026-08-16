/* The whole game state — laid out as the engine's own .SAV image.
 *
 * Design rule: the canonical state IS the save format. The .SAV is
 * substantially a dump of the engine's DGROUP records (serializer
 * func_0734F8 @0x073562, 43-block order read 2026-08-07; layout re-validated
 * against the ten shipped COLONY0#.SAV files — see importSav's header note
 * in port/src/game.js). So the C core keeps its state in exactly those
 * blocks, and:
 *
 *   - load  = header checks + memcpy into the blocks below
 *   - save  = write the blocks back in file order
 *   - any block the sim does not yet MODEL is still PRESERVED verbatim,
 *     so load->save is byte-exact by construction and nothing unmodeled is
 *     invented or lost (CLAUDE.md prime directive, applied to state).
 *
 * Named fields inside the opaque blocks are reached through the accessors
 * in colopy_state.c, each carrying the same offset citation as the JS
 * importer (globals block g+0x0A year, g+0x1E ncol, ...).
 *
 * Static footprint (see cport/MEMORY_BUDGET.md): ~47 KB — fits the Teensy's
 * 512 KB OCRAM many times over.
 */
#ifndef COLOPY_STATE_H
#define COLOPY_STATE_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h>
#include <stdint.h>

#include "colopy_records.h"

#define COLOPY_MAP_W 58
#define COLOPY_MAP_H 72
#define COLOPY_PLANE (COLOPY_MAP_W * COLOPY_MAP_H)

/* .SAV block sizes (file order). */
#define SAV_PRELUDE   0x10   /* "COLONIZE" 00 1A + u16 + w,h u16 */
#define SAV_GLOBALS   0x8E   /* block 3: the [0x5380..] globals window */
#define SAV_MID       (0xD0 + 0x18)  /* blocks between globals and colonies */
#define SAV_POWERS    (COLOPY_POWERS * 0x13C)
#define SAV_TRIBES    0x270  /* 8 TribeData records, stride 0x4E */
#define SAV_BLOCKS_11_43 727 /* fixed-size tail blocks, preserved verbatim */
/* After the four planes the serializer writes more fixed blocks: 48-51 are
 * documented (spec/systems/save.md: pathfinding/region scratch 0x10E x2 +
 * AI word arrays 0x20 x2 = 604 bytes); the remaining bytes (898 in all four
 * fixtures, total tail 1502) are TBD-unmodeled.  Preserved verbatim either
 * way, with the measured length, so the roundtrip stays byte-exact. */
#define SAV_TAIL_MAX 2048

typedef struct {
    /* verbatim .SAV blocks, file order ------------------------------- */
    uint8_t  prelude[SAV_PRELUDE];
    uint8_t  globals[SAV_GLOBALS];
    uint8_t  mid[SAV_MID];
    ColonyRecord     colonies[COLOPY_MAX_COLONIES];
    UnitRecord       units[COLOPY_MAX_UNITS];
    PowerRecord      powers[COLOPY_POWERS];
    NativeSettlement villages[COLOPY_MAX_SETTLEMENTS];
    uint8_t  tribes[SAV_TRIBES];
    uint8_t  blocks11_43[SAV_BLOCKS_11_43];
    uint8_t  terrain[COLOPY_PLANE];   /* plane 1  [0x15C] */
    uint8_t  improve[COLOPY_PLANE];   /* plane 2  [0x160] */
    uint8_t  region [COLOPY_PLANE];   /* plane 3  [0x164] low nibble = region */
    uint8_t  fog    [COLOPY_PLANE];   /* plane 4  [0x168] 1<<(power+4) bits */
    uint8_t  tail[SAV_TAIL_MAX];      /* blocks 48+ — preserved verbatim */
    uint16_t tail_len;
    /* live counts (also mirrored inside globals on save) -------------- */
    uint16_t n_colonies, n_units, n_villages;
    /* port-side runtime (not in the .SAV) ----------------------------- */
    uint32_t rng;                     /* the one seeded PRNG stream */
} colopy_state;

extern colopy_state CS;

/* Globals-block accessors — offsets per the JS importer (game.js:10219+),
 * each byte-cited there against the serializer read. */
uint16_t cs_year(void);          /* g+0x0A */
uint16_t cs_season(void);        /* g+0x0C */
uint16_t cs_turn(void);          /* g+0x0E */
uint8_t  cs_nation(void);        /* g+0x14 & 3 */
uint8_t  cs_difficulty(void);    /* g+0x26 */
uint16_t cs_tut_mask(void);      /* g+0x06 [0x5386] */
uint16_t cs_wc_seen(void);       /* g+0x8A [0x540A] */
uint16_t cs_ref(int i);          /* g+0x5A + 2i: Regulars/Cavalry/MoW/Artillery */
uint8_t  cs_colony_numbers(void);/* block 34: single byte [0x336] */

#ifdef __cplusplus
}
#endif
#endif /* COLOPY_STATE_H */
