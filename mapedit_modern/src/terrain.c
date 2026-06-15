/*
 * terrain.c — terrain id table + palette (see terrain.h for the evidence basis).
 */
#include "terrain.h"
#include "mp.h"

#include <stdio.h>
#include <string.h>

/* id, name, group, is_water, uncertain */
static const terrain_info TERRAIN[TERRAIN_ID_MAX] = {
    /* --- UNFORESTED (verified, NAMES.TXT @UNFORESTED order) --- */
    {  0, "Tundra",    TGROUP_UNFORESTED, false, false },
    {  1, "Desert",    TGROUP_UNFORESTED, false, false },
    {  2, "Plains",    TGROUP_UNFORESTED, false, false },
    {  3, "Prairie",   TGROUP_UNFORESTED, false, false },
    {  4, "Grassland", TGROUP_UNFORESTED, false, false },
    {  5, "Savannah",  TGROUP_UNFORESTED, false, false },
    {  6, "Marsh",     TGROUP_UNFORESTED, false, false },
    {  7, "Swamp",     TGROUP_UNFORESTED, false, false },
    /* --- FORESTED (verified, NAMES.TXT @FORESTED, paired with 0..7) --- */
    {  8, "Boreal",    TGROUP_FORESTED,   false, false },
    {  9, "Scrub",     TGROUP_FORESTED,   false, false },
    { 10, "Mixed",     TGROUP_FORESTED,   false, false },
    { 11, "Broadleaf", TGROUP_FORESTED,   false, false },
    { 12, "Conifer",   TGROUP_FORESTED,   false, false },
    { 13, "Tropical",  TGROUP_FORESTED,   false, false },
    { 14, "Wetland",   TGROUP_FORESTED,   false, false },
    { 15, "Rain",      TGROUP_FORESTED,   false, false },
    /* --- 16..23 land variants: names not yet byte-verified --- */
    { 16, "Arctic",    TGROUP_OTHER,      false, true  },
    { 17, "Land(17)",  TGROUP_RESERVED,   false, true  },
    { 18, "Hills",     TGROUP_OTHER,      false, true  },
    { 19, "Mountains", TGROUP_OTHER,      false, true  },
    { 20, "Land(20)",  TGROUP_RESERVED,   false, true  },
    { 21, "Land(21)",  TGROUP_RESERVED,   false, true  },
    { 22, "Land(22)",  TGROUP_RESERVED,   false, true  },
    { 23, "Land(23)",  TGROUP_RESERVED,   false, true  },
    { 24, NULL,        TGROUP_RESERVED,   false, true  },  /* unused in stock maps */
    /* --- water (pinned via layer-3 land/water correlation) --- */
    { 25, "Ocean",     TGROUP_OTHER,      true,  false },
    { 26, "Sea Lane",  TGROUP_OTHER,      true,  false },
};

/* Editor palette order = @UNFORESTED ++ @FORESTED ++ @OTHER (Arctic, Ocean,
 * Sea Lane, Mountains, Hills). */
static const uint8_t PALETTE_IDS[] = {
    0, 1, 2, 3, 4, 5, 6, 7,            /* unforested */
    8, 9, 10, 11, 12, 13, 14, 15,      /* forested   */
    16, 25, 26, 19, 18,                /* other: Arctic, Ocean, Sea Lane, Mountains, Hills */
};

const terrain_info *terrain_by_id(uint8_t id)
{
    if (id >= TERRAIN_ID_MAX)
        return NULL;
    if (TERRAIN[id].name == NULL)
        return NULL;
    return &TERRAIN[id];
}

const terrain_info *terrain_palette(int *count)
{
    static terrain_info pal[sizeof PALETTE_IDS];
    int n = 0;
    for (size_t i = 0; i < sizeof PALETTE_IDS; i++) {
        const terrain_info *t = terrain_by_id(PALETTE_IDS[i]);
        if (t)
            pal[n++] = *t;
    }
    if (count)
        *count = n;
    return pal;
}

/* Colored-tile / minimap palette. These are the game's own colours, derived
 * from VICEROY.PAL via the byte-verified TERRAIN_PAL_INDEX table (terrain id ->
 * VGA palette index), so they match what Colonization draws on its minimap.
 * @ref tools/render_map_v2.py TERRAIN_PAL_INDEX, VICEROY.PAL */
static const uint32_t TERRAIN_RGB[TERRAIN_ID_MAX] = {
    [0]  = 0xAEA5A5,  /* Tundra    (pal 20) */
    [1]  = 0xCEB28D,  /* Desert    (pal 66) */
    [2]  = 0xBABA40,  /* Plains    (pal 54) */
    [3]  = 0xCE9534,  /* Prairie   (pal 60) */
    [4]  = 0x69B248,  /* Grassland (pal 91) */
    [5]  = 0x99CE69,  /* Savannah  (pal 40) */
    [6]  = 0x59A534,  /* Marsh     (pal 43) */
    [7]  = 0x1C7D10,  /* Swamp     (pal 46) */
    [8]  = 0xAEA5A5,  /* Boreal    */
    [9]  = 0xCEB28D,  /* Scrub     */
    [10] = 0xBABA40,  /* Mixed     */
    [11] = 0xCE9534,  /* Broadleaf */
    [12] = 0x69B248,  /* Conifer   */
    [13] = 0x99CE69,  /* Tropical  */
    [14] = 0x59A534,  /* Wetland   */
    [15] = 0x1C7D10,  /* Rain      */
    [16] = 0xDADADA,  /* Arctic    (pal 15) */
    [17] = 0x69B248,  /* extended  */
    [18] = 0xAEA5A5,  /* Hills/extended */
    [19] = 0x69B248,  /* Mountains/extended */
    [20] = 0x69B248,  /* extended  */
    [21] = 0x99CE69,  /* extended  */
    [22] = 0x59A534,  /* extended  */
    [23] = 0x69B248,  /* extended  */
    [24] = 0x000000,
    [25] = 0x202C89,  /* Ocean     (pal 45) */
    [26] = 0x384C9D,  /* Sea Lane  (pal 93) */
};

uint32_t terrain_color(uint8_t id)
{
    if (id >= TERRAIN_ID_MAX)
        return 0x202020;
    return TERRAIN_RGB[id];
}

char *terrain_describe(uint8_t tile_byte, char *buf, int bufsz)
{
    uint8_t id = MP_TERRAIN_ID(tile_byte);
    const terrain_info *t = terrain_by_id(id);
    const char *name = t ? t->name : "?";

    int k = snprintf(buf, (size_t)bufsz, "%s", name);
    if (k < 0) { if (bufsz) buf[0] = 0; return buf; }

    if (tile_byte & MP_FLAG_FOREST)
        k += snprintf(buf + k, (size_t)(bufsz - k > 0 ? bufsz - k : 0), " +forest");
    if (tile_byte & MP_FLAG_ROADRIVER)
        k += snprintf(buf + k, (size_t)(bufsz - k > 0 ? bufsz - k : 0), " +road/river");
    if (tile_byte & MP_FLAG_PRIME)
        k += snprintf(buf + k, (size_t)(bufsz - k > 0 ? bufsz - k : 0), " +prime");
    return buf;
}
