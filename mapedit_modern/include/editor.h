/*
 * editor.h — map editor state and tools.
 *
 * Models the editing operations exposed by MAPEDIT's menus and status bar:
 *   - Map Tile Select        (choose the terrain to paint)
 *   - Shift-Left: Paint/Add  (paint base terrain / add overlay)
 *   - Shift-Right: Remove/Pick up (clear overlay / sample terrain)
 *   - Fill Mode Change       (flood fill; "Fill radius: %d")
 *   - Toggle Coastline Protect
 *   - Find Continents        (count land masses / oceans)
 *   - Undo Last Change
 *
 * Tools operate on an mp_map and keep an undo stack of terrain-layer
 * snapshots. Raw tile bytes are preserved by load/save, so any sequence of
 * edits that ends where it began yields a byte-identical file.
 */
#ifndef MPEDIT_EDITOR_H
#define MPEDIT_EDITOR_H

#include "mp.h"
#include "terrain.h"

typedef enum {
    FILL_FLOOD = 0,   /* fill the contiguous same-terrain region */
    FILL_RADIUS       /* fill a square radius around the cursor   */
} fill_mode;

typedef struct undo_node undo_node;

typedef struct {
    mp_map   *map;
    uint8_t   selected_id;     /* terrain id chosen in the palette */
    int       fill_radius;     /* "Fill radius: %d" (radius tool)  */
    fill_mode mode;
    bool      coast_protect;   /* "Coast Protect: ON/OFF"          */
    int       cursor_x, cursor_y;
    undo_node *undo;           /* stack head                       */
    int        undo_depth;
} editor;

editor *editor_create(mp_map *map);   /* takes ownership of map */
void    editor_destroy(editor *e);

/* Selection / options. */
void editor_select(editor *e, uint8_t terrain_id);
void editor_set_fill_radius(editor *e, int r);
void editor_toggle_coast_protect(editor *e);
void editor_set_mode(editor *e, fill_mode m);

/* Edits (each pushes one undo step). Coordinates are tile space. */
void editor_paint(editor *e, int x, int y);         /* set base terrain = selected */
void editor_set_tile(editor *e, int x, int y, uint8_t tile_byte);
void editor_pick(editor *e, int x, int y);          /* sample terrain into selection */
void editor_toggle_river(editor *e, int x, int y);  /* flip road/river bit  */
void editor_toggle_forest(editor *e, int x, int y); /* flip forest overlay  */
void editor_toggle_prime(editor *e, int x, int y);  /* flip prime-resource  */
void editor_fill(editor *e, int x, int y);          /* flood/radius per mode */

/* Undo the most recent edit. Returns true if something was undone. */
bool editor_undo(editor *e);

/* Analysis: count contiguous land masses and ocean bodies (4-connectivity).
 * Used by "Find Continents" and the ">15 oceans" warning. */
void editor_count_masses(const editor *e, int *out_continents, int *out_oceans);

#endif /* MPEDIT_EDITOR_H */
