/* C-port Phase 7 — platform-free renderer over an 8-bit indexed
 * framebuffer, fed by the Phase-6 COLOPY.PAK (cport/data/colopy_pak.h).
 *
 * Geometry: the original screens are Mode 13h 320x200; the ILI9341 panel
 * is 320x240.  The port TOP-ALIGNS the 200 rows and leaves rows 200..239
 * as a status strip (FLAGGED choice per the Phase-7 plan — the DOS game
 * has no 240-row mode to cite).  All drawing uses the 320x200 logical
 * space; rd_flush_* is where a platform maps fb rows to the panel.
 *
 * Sprite semantics are the .SS semantics (formats/SS.md): pixel value
 * 0xFD is transparent (rle_decode's sentinel), everything else is a
 * palette index.  Fonts are the engine-native .FF payloads (formats/
 * FF.md): width(ch) = width_table[ch-1], 2bpp MSB-first glyphs, each
 * ink level 0..3 mapped through a caller 4-entry palette LUT exactly
 * like the EXE's rasteriser core func_00E51C (0xFF = skip). */
#ifndef COLOPY_RENDER_H
#define COLOPY_RENDER_H
#include <stdint.h>
#include <stddef.h>

#define RD_W 320
#define RD_H 240
#define RD_GAME_H 200                 /* the Mode 13h logical screen */
#define RD_TRANSPARENT 0xFD           /* .SS transparent index */

/* ---- pak access (buffer-backed; host mmaps/reads the whole file) ---- */
typedef struct {
    const uint8_t *buf;
    uint32_t len;
    uint16_t count;
} rd_pak;

typedef struct {
    char name[13];
    const uint8_t *payload;
    uint32_t len;
    uint16_t w, h, frames;
} rd_entry;

int  rd_pak_open(rd_pak *pk, const uint8_t *buf, uint32_t len);
/* Entry by TOC name ("TERRAIN.SS", "VICEROY.PAL", ...); 0 = not found. */
int  rd_pak_find(const rd_pak *pk, const char *name, rd_entry *out);

/* One sheet frame's geometry + pixels (sheet payload per colopy_pak.h). */
typedef struct {
    int16_t x, y;                     /* the .SS frame placement offsets */
    uint16_t w, h;
    const uint8_t *pix;               /* w*h bytes, 0xFD transparent */
} rd_frame;
int  rd_sheet_frame(const rd_entry *sheet, int idx, rd_frame *out);
/* A sheet's appended RGB888 palette (WOODTILE/WOODFRAM), or NULL. */
const uint8_t *rd_sheet_pal(const rd_entry *sheet);

/* ---- framebuffer state ---- */
typedef struct {
    uint8_t fb[RD_W * RD_H];
    uint8_t pal[768];                 /* active RGB888 palette */
    rd_pak pak;
    rd_entry terrain, phys0, icons, woodtile;   /* hot sheets, cached */
} rd_state;

extern rd_state RD;

/* Open the pak, cache the hot sheets, load VICEROY.PAL, clear the fb. */
int  rd_init(const uint8_t *pak_buf, uint32_t pak_len);

/* usePalette (game.js:1563 call sites): the master VICEROY.PAL with a
 * named sheet/PIK palette overriding — pass NULL for the master alone. */
void rd_use_palette(const char *entry_name);

void rd_fill(int x, int y, int w, int h, uint8_t colour);
/* Blit frame idx of a sheet at (x,y) — .SS transparency honoured. */
void rd_blit(const rd_entry *sheet, int idx, int x, int y);
void rd_blit_name(const char *sheet_name, int idx, int x, int y);
/* A PIK background at (0,0) (and its palette, when embedded, is NOT
 * auto-applied — call rd_use_palette for that, like the JS). */
void rd_pik(const char *name);

/* ---- text (FF fonts, func_00E51C semantics) ----
 * ink = 4 palette indices for the 2bpp levels 0..3; 0xFF = transparent.
 * Advance = glyph width (glyphs carry their own trailing spacing column;
 * a missing glyph advances width(' ') or 3 — the JS Font class rule).
 * Returns the final pen x. */
typedef struct {
    const uint8_t *payload;           /* engine-native FF payload */
    uint32_t len;
    uint8_t cell_h, max_w;
} rd_font;
int  rd_font_open(const rd_pak *pk, const char *name, rd_font *out);
int  rd_text(const rd_font *f, const char *s, int x, int y,
             const uint8_t ink[4]);
int  rd_text_width(const rd_font *f, const char *s);

/* ---- screens (cluster B+) ---- */
/* drawMap (game.js:1555) at zoom 0 over the loaded sim state.  sel is a
 * units_order index (-1 = none); blink hides the active unit's frame. */
void rm_draw_map(int view_x, int view_y, int sel, int blink);
/* drawPulldown (game.js:1836) over an open bar title; the ORDERS menu
 * builds its rows from the selected unit's context (game.js:1780). */
void rm_draw_pulldown(int menu_idx, int menu_sel, int sel);
/* one composited scene tile + its settlement (colony panel, game.js:3565) */
void rm_scene_tile(int mx, int my, int px, int py);
/* drawColony (game.js:3449): the full colony screen over CS/CR state */
/* shared unit chrome (colopy_map_render.c) */
void rm_nation_plate(int x, int y, int colour, int orders);
int  rm_profession_icon(int jobexpert_row);   /* colopy_colony_render.c */
void rm_draw_settlement(int px, int py, int level, int nation,
                        int tribe_colour, int mission);
int  rm_colony_level_ci(int ci);
int  rm_is_seen(int x, int y);
/* the func_0033F2/003104 count-row machinery (colopy_colony_render.c) */
typedef struct { int frame, count, sub, flags; } rm_crow_cell;
void rm_draw_count_row(const rm_crow_cell *cells, int ncells, int x0, int y,
                       int span, int gap0, int numbers);
void rm_count_badge(int value, int x, int y, uint8_t colour);
void rm_draw_report(const char *fkey);        /* colopy_report_render.c */
void rm_draw_europe(int euro_ship, int dock_sel, int euro_row,
                    int market_sel);          /* colopy_europe_render.c */
int  rm_owner_colour_ui(int ui);
void rm_draw_colony(int ci, uint32_t plot_seed_base, int colonist_sel,
                    int ship_sel, int view, int numbers);
/* shared chrome primitives (plaque game.js:795, FRAME_GAME rings) */
void rm_plaque(int x, int y, int w, int h);
void rm_hollow_rect(int x, int y, int w, int h, uint8_t c);
/* the dialog framework (drawEvent game.js:6403 / drawDialog 909):
 * subs = up to 4 STRING + 4 NUMBER substitutions (NULL/unused = empty) */
typedef struct {
    const char *str[4];
    int32_t num[4];
    uint8_t num_set[4];
} rm_subs;
int  rm_event_exists(const char *key);
void rm_draw_event(const char *key, const rm_subs *subs,
                   const char *speaker);
void rm_draw_dialog_event(const char *key, const rm_subs *subs,
                          const char *speaker, int sel);

#endif /* COLOPY_RENDER_H */
