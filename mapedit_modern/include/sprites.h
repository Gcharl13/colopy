/*
 * sprites.h — terrain tile drawing.
 *
 * Two paths, selected at runtime:
 *   - If the original PHYS0.SS sprite sheet (and VICEROY.PAL) are available,
 *     sprite_load_phys0() decodes them and tiles are drawn pixel-faithfully.
 *   - Otherwise tiles fall back to clean colored cells with overlay markers
 *     for river / forest / prime-resource bits.
 *
 * The colored-tile path has no external asset dependency, so the editor runs
 * anywhere; the sprite path is opt-in when you point it at a COLONIZE install.
 */
#ifndef MPEDIT_SPRITES_H
#define MPEDIT_SPRITES_H

#include "framebuffer.h"
#include "mp.h"
#include <stdint.h>
#include <stdbool.h>

/* Try to load PHYS0.SS + VICEROY.PAL from a COLONIZE directory. Returns true
 * if sprite rendering is now active, false if falling back to colored tiles. */
bool sprite_load_phys0(const char *colonize_dir);
bool sprite_have_sheet(void);

/* Draw one terrain tile byte into f at (px,py), tp pixels square (no context). */
void sprite_draw_tile(fb *f, int px, int py, int tp, uint8_t tile_byte);

/* Draw a map tile WITH neighbour context (real coast beach sprites, forest,
 * river/prime markers). Used by the map viewport renderer. */
void sprite_draw_map_tile(fb *f, int px, int py, int tp, const mp_map *m, int tx, int ty);

#endif /* MPEDIT_SPRITES_H */
