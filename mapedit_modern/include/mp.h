/*
 * mp.h — Sid Meier's Colonization ".MP" map file format.
 *
 * This is a clean-room, modern-C model of the on-disk format used by both
 * VICEROY.EXE (game) and MAPEDIT.EXE (the standalone map editor). The layout
 * below is byte-verified against the stock map AMER2.MP (12,534 bytes):
 *
 *     offset  size            field
 *     ------  --------------  ---------------------------------------------
 *     0       u16  LE         width   (58 in AMER2)
 *     2       u16  LE         height  (72 in AMER2)
 *     4       W*H bytes       terrain layer  (layer 1)
 *     4+N     W*H bytes       feature layer  (layer 2)
 *     4+2N    W*H bytes       special layer  (layer 3 — land/water + resource)
 *     4+3N    rest            trailer (0x0000 in AMER2; preserved verbatim)
 *
 * with N = width*height. AMER2 satisfies 4 + 3*4176 + 2 == 12534 exactly, and
 * the alignment is pinned by the sea-lane border rule: the left/right edge
 * columns decode to terrain id 26 (Sea Lane) only under the 4-byte header.
 *
 * The three layers are SEPARATE planar arrays (not interleaved): layer 2 is
 * nearly all-zero on a fresh map (features added during play) and layer 3
 * holds the land/water + prime-resource classification.
 *
 * Terrain-byte (layer 1) bit layout, consistent with the byte-verified
 * VICEROY terrain handling:
 *     bits 0..4 : base terrain id (0..26; see terrain.h)
 *     bit  5    : prime-resource flag
 *     bit  6    : road / river flag
 *     bit  7    : forest sprite overlay
 */
#ifndef MPEDIT_MP_H
#define MPEDIT_MP_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#define MP_HEADER_BYTES   4u
#define MP_LAYERS         3u

/* terrain-byte (layer 1) decode */
#define MP_TERRAIN_ID(b)     ((uint8_t)((b) & 0x1Fu))
#define MP_FLAG_PRIME        0x20u   /* prime resource present on this tile */
#define MP_FLAG_ROADRIVER    0x40u   /* road or river crosses this tile     */
#define MP_FLAG_FOREST       0x80u   /* forest sprite overlaid on base tile  */

typedef struct {
    uint16_t width;
    uint16_t height;
    uint8_t *terrain;     /* layer 1, row-major: terrain[y*width + x] */
    uint8_t *feature;     /* layer 2 */
    uint8_t *special;     /* layer 3 */
    uint8_t *trailer;     /* bytes following the three layers (preserved) */
    size_t   trailer_len;
} mp_map;

/* Allocate a blank map (all layers zeroed, 2-byte zero trailer as in AMER2). */
mp_map *mp_new(uint16_t width, uint16_t height);

/* Load a .MP file. On error returns NULL and (if err != NULL) fills err. */
mp_map *mp_load(const char *path, char *err, size_t errsz);

/* Write a .MP file. Returns 0 on success, -1 on error (errno set). */
int mp_save(const mp_map *m, const char *path);

void mp_free(mp_map *m);

/* Geometry helpers. */
size_t mp_tile_count(const mp_map *m);   /* width*height                     */
size_t mp_file_size(const mp_map *m);    /* exact on-disk byte size           */
bool   mp_in_bounds(const mp_map *m, int x, int y);

static inline size_t mp_idx(const mp_map *m, int x, int y)
{
    return (size_t)y * m->width + (size_t)x;
}

#endif /* MPEDIT_MP_H */
