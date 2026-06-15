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

/* Colored-tile palette: chosen to read like the original minimap (greens for
 * vegetation, blue water, tan desert, white arctic, gray mountains). */
static const uint32_t TERRAIN_RGB[TERRAIN_ID_MAX] = {
    [0]  = 0x9DB0A0,  /* Tundra    */
    [1]  = 0xD9C18A,  /* Desert    */
    [2]  = 0x9CCB6B,  /* Plains    */
    [3]  = 0xB7C957,  /* Prairie   */
    [4]  = 0x5FAE4B,  /* Grassland */
    [5]  = 0x8AA03C,  /* Savannah  */
    [6]  = 0x6B8E5A,  /* Marsh     */
    [7]  = 0x5C7348,  /* Swamp     */
    [8]  = 0x2F6B3A,  /* Boreal    */
    [9]  = 0x6E8B3D,  /* Scrub     */
    [10] = 0x3E7E3A,  /* Mixed     */
    [11] = 0x4C8A39,  /* Broadleaf */
    [12] = 0x2E6E40,  /* Conifer   */
    [13] = 0x357A33,  /* Tropical  */
    [14] = 0x3F6B4A,  /* Wetland   */
    [15] = 0x276B34,  /* Rain      */
    [16] = 0xF0F4F8,  /* Arctic    */
    [17] = 0x8C9A6A,  /* Land(17)  */
    [18] = 0xA98C5A,  /* Hills     */
    [19] = 0x8C8C8C,  /* Mountains */
    [20] = 0x9AA46A,  /* Land(20)  */
    [21] = 0x7FA05A,  /* Land(21)  */
    [22] = 0x9A8C6A,  /* Land(22)  */
    [23] = 0x6FA050,  /* Land(23)  */
    [24] = 0x000000,
    [25] = 0x2A5FA8,  /* Ocean     */
    [26] = 0x4E86C8,  /* Sea Lane  */
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
