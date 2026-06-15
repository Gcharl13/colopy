/*
 * terrain.h — terrain id model and editor palette.
 *
 * The base terrain id is the low 5 bits of a layer-1 tile byte (MP_TERRAIN_ID).
 * Evidence basis (see docs/MP_FORMAT.md and the parent project's RE notes):
 *
 *   ids 0..7   UNFORESTED group, names from NAMES.TXT @UNFORESTED   [verified]
 *   ids 8..15  FORESTED  group, names from NAMES.TXT @FORESTED       [verified]
 *   id  25     Ocean  )  pinned by correlating layer-1 ids against the layer-3
 *   id  26     Sea Lane) land/water classifier and the sea-lane edge columns
 *   ids 16..23 additional land terrains (Arctic / Mountains / Hills + stock-map
 *              variants). Exact name<->id assignment is NOT byte-verified yet
 *              and is flagged TERRAIN_UNCERTAIN. Editing/round-trip is exact
 *              regardless, because raw tile bytes are always preserved.
 *
 * The editor palette (what the user can paint) is the 21 entries listed by
 * NAMES.TXT as @UNFORESTED (8) + @FORESTED (8) + @OTHER (5).
 */
#ifndef MPEDIT_TERRAIN_H
#define MPEDIT_TERRAIN_H

#include <stdint.h>
#include <stdbool.h>

#define TERRAIN_ID_MAX 27   /* ids 0..26 are meaningful; 27 reserved */

typedef enum {
    TGROUP_UNFORESTED = 0,
    TGROUP_FORESTED,
    TGROUP_OTHER,
    TGROUP_RESERVED
} terrain_group;

typedef struct {
    uint8_t       id;            /* base terrain id (0..26)              */
    const char   *name;          /* display name (NAMES.TXT)             */
    terrain_group group;
    bool          is_water;      /* Ocean / Sea Lane                     */
    bool          uncertain;     /* name<->id not yet byte-verified      */
} terrain_info;

/* Lookup by base id (0..26). Returns NULL for ids with no known terrain. */
const terrain_info *terrain_by_id(uint8_t id);

/* The ordered editor palette (21 paintable terrains). */
const terrain_info *terrain_palette(int *count);

/* Human label for a full layer-1 tile byte, e.g. "Prairie +forest +river".
 * Writes into buf and returns buf. */
char *terrain_describe(uint8_t tile_byte, char *buf, int bufsz);

/* Packed 0x00RRGGBB colour for the colored-tile fallback / minimap, keyed by
 * base terrain id. */
uint32_t terrain_color(uint8_t id);

#endif /* MPEDIT_TERRAIN_H */
