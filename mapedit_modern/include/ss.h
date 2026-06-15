/*
 * ss.h — decoder for MicroProse MADS ".SS" sprite sheets (PHYS0.SS, TERRAIN.SS,
 * ICONS.SS, ...). Container is MADSPACK 2.0 with FAB-compressed sections; each
 * frame is an MS_SPRITE RLE bitmap over a 256-colour VGA palette.
 *
 * This is a from-scratch C port of the decode validated in Python against the
 * original assets (tools/fab_solve.py, tools/extract_phys0.py). Transparent
 * pixels (palette index 0xFD) decode to alpha 0.
 */
#ifndef MPEDIT_SS_H
#define MPEDIT_SS_H

#include <stdint.h>

typedef struct {
    int       w, h;
    uint32_t *rgba;     /* w*h, 0xAARRGGBB; alpha 0 = transparent */
} ss_frame;

typedef struct {
    int       count;
    ss_frame *frames;
} ss_sheet;

/* Load + fully decode a .SS file. Returns NULL on failure. */
ss_sheet *ss_load(const char *path);
void      ss_free(ss_sheet *s);

#endif /* MPEDIT_SS_H */
