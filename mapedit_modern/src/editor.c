/*
 * editor.c — editor state + tools (see editor.h).
 *
 * Notes on faithfulness: the on-disk format and tile-byte semantics are
 * byte-verified, so paint/pick/overlay edits write exactly the bytes the
 * original format expects. The precise pixel-level behaviour of "Coastline
 * Protect" lives in MAPEDIT's overlay and is not fully reverse-engineered;
 * the implementation here is a faithful approximation and is flagged below.
 */
#include "editor.h"

#include <stdlib.h>
#include <string.h>

struct undo_node {
    uint8_t  *terrain;     /* snapshot of the terrain layer */
    undo_node *next;
};

#define UNDO_MAX 64

static bool is_water_id(uint8_t id) { return id == 25 || id == 26; }

editor *editor_create(mp_map *map)
{
    editor *e = calloc(1, sizeof *e);
    if (!e)
        return NULL;
    e->map = map;
    e->selected_id = 2;     /* Plains */
    e->fill_radius = 1;
    e->mode = FILL_FLOOD;
    e->coast_protect = false;
    return e;
}

void editor_destroy(editor *e)
{
    if (!e)
        return;
    while (e->undo) {
        undo_node *n = e->undo;
        e->undo = n->next;
        free(n->terrain);
        free(n);
    }
    mp_free(e->map);
    free(e);
}

static void push_undo(editor *e)
{
    size_t n = mp_tile_count(e->map);
    undo_node *node = malloc(sizeof *node);
    if (!node)
        return;
    node->terrain = malloc(n);
    if (!node->terrain) { free(node); return; }
    memcpy(node->terrain, e->map->terrain, n);
    node->next = e->undo;
    e->undo = node;
    e->undo_depth++;

    /* Trim the tail past UNDO_MAX. */
    if (e->undo_depth > UNDO_MAX) {
        undo_node *p = e->undo;
        for (int i = 1; i < UNDO_MAX; i++)
            p = p->next;
        undo_node *drop = p->next;
        p->next = NULL;
        while (drop) {
            undo_node *d = drop;
            drop = d->next;
            free(d->terrain);
            free(d);
            e->undo_depth--;
        }
    }
}

bool editor_undo(editor *e)
{
    if (!e->undo)
        return false;
    undo_node *n = e->undo;
    e->undo = n->next;
    e->undo_depth--;
    memcpy(e->map->terrain, n->terrain, mp_tile_count(e->map));
    free(n->terrain);
    free(n);
    return true;
}

void editor_select(editor *e, uint8_t id)            { e->selected_id = id & 0x1F; }
void editor_set_fill_radius(editor *e, int r)        { e->fill_radius = r < 0 ? 0 : r; }
void editor_toggle_coast_protect(editor *e)          { e->coast_protect = !e->coast_protect; }
void editor_set_mode(editor *e, fill_mode m)         { e->mode = m; }

/* Coast protection: when enabled, refuse to overwrite a water tile with land
 * (or land with water) if doing so would break the sea-lane border columns.
 * The border columns (x==0 and x==width-1) are always kept as Sea Lane (26).
 * TODO_VERIFY: the original's exact coastline-preservation rule. */
static bool coast_blocks(const editor *e, int x, int y, uint8_t new_id)
{
    if (!e->coast_protect)
        return false;
    (void)y;
    bool border = (x == 0 || x == e->map->width - 1);
    if (border && !is_water_id(new_id))
        return true;       /* keep sea-lane border intact */
    return false;
}

void editor_set_tile(editor *e, int x, int y, uint8_t tile_byte)
{
    if (!mp_in_bounds(e->map, x, y))
        return;
    push_undo(e);
    e->map->terrain[mp_idx(e->map, x, y)] = tile_byte;
}

void editor_paint(editor *e, int x, int y)
{
    if (!mp_in_bounds(e->map, x, y))
        return;
    if (coast_blocks(e, x, y, e->selected_id))
        return;
    push_undo(e);
    size_t i = mp_idx(e->map, x, y);
    /* Replace the base terrain id, keep the overlay flag bits. */
    uint8_t flags = e->map->terrain[i] & 0xE0u;
    e->map->terrain[i] = (uint8_t)(e->selected_id | flags);
}

void editor_pick(editor *e, int x, int y)
{
    if (!mp_in_bounds(e->map, x, y))
        return;
    e->selected_id = MP_TERRAIN_ID(e->map->terrain[mp_idx(e->map, x, y)]);
}

static void toggle_flag(editor *e, int x, int y, uint8_t flag)
{
    if (!mp_in_bounds(e->map, x, y))
        return;
    push_undo(e);
    e->map->terrain[mp_idx(e->map, x, y)] ^= flag;
}

void editor_toggle_river(editor *e, int x, int y)  { toggle_flag(e, x, y, MP_FLAG_ROADRIVER); }
void editor_toggle_forest(editor *e, int x, int y) { toggle_flag(e, x, y, MP_FLAG_FOREST); }
void editor_toggle_prime(editor *e, int x, int y)  { toggle_flag(e, x, y, MP_FLAG_PRIME); }

static void radius_fill(editor *e, int cx, int cy)
{
    uint8_t flags_keep = 0xE0u;
    for (int y = cy - e->fill_radius; y <= cy + e->fill_radius; y++)
        for (int x = cx - e->fill_radius; x <= cx + e->fill_radius; x++) {
            if (!mp_in_bounds(e->map, x, y))
                continue;
            if (coast_blocks(e, x, y, e->selected_id))
                continue;
            size_t i = mp_idx(e->map, x, y);
            e->map->terrain[i] = (uint8_t)(e->selected_id | (e->map->terrain[i] & flags_keep));
        }
}

static void flood_fill(editor *e, int cx, int cy)
{
    uint8_t target = MP_TERRAIN_ID(e->map->terrain[mp_idx(e->map, cx, cy)]);
    if (target == e->selected_id)
        return;

    size_t n = mp_tile_count(e->map);
    int *stack = malloc(n * sizeof(int));
    if (!stack)
        return;
    int sp = 0;
    stack[sp++] = (int)mp_idx(e->map, cx, cy);

    while (sp > 0) {
        int idx = stack[--sp];
        int x = idx % e->map->width;
        int y = idx / e->map->width;
        size_t i = (size_t)idx;
        if (MP_TERRAIN_ID(e->map->terrain[i]) != target)
            continue;
        if (coast_blocks(e, x, y, e->selected_id))
            continue;
        e->map->terrain[i] = (uint8_t)(e->selected_id | (e->map->terrain[i] & 0xE0u));
        if (x > 0)                    stack[sp++] = idx - 1;
        if (x < e->map->width - 1)    stack[sp++] = idx + 1;
        if (y > 0)                    stack[sp++] = idx - e->map->width;
        if (y < e->map->height - 1)   stack[sp++] = idx + e->map->width;
    }
    free(stack);
}

void editor_fill(editor *e, int x, int y)
{
    if (!mp_in_bounds(e->map, x, y))
        return;
    push_undo(e);
    if (e->mode == FILL_RADIUS)
        radius_fill(e, x, y);
    else
        flood_fill(e, x, y);
}

/* Connected-component count over 4-neighbours, partitioned by land vs water. */
void editor_count_masses(const editor *e, int *out_continents, int *out_oceans)
{
    const mp_map *m = e->map;
    size_t n = mp_tile_count(m);
    uint8_t *seen = calloc(n, 1);
    int *stack = malloc(n * sizeof(int));
    int continents = 0, oceans = 0;
    if (!seen || !stack) { free(seen); free(stack); if (out_continents)*out_continents=0; if(out_oceans)*out_oceans=0; return; }

    for (size_t s = 0; s < n; s++) {
        if (seen[s])
            continue;
        bool water = is_water_id(MP_TERRAIN_ID(m->terrain[s]));
        if (water) oceans++; else continents++;

        int sp = 0;
        stack[sp++] = (int)s;
        seen[s] = 1;
        while (sp > 0) {
            int idx = stack[--sp];
            int x = idx % m->width, y = idx / m->width;
            int nb[4] = {
                x > 0              ? idx - 1         : -1,
                x < m->width - 1   ? idx + 1         : -1,
                y > 0              ? idx - m->width  : -1,
                y < m->height - 1  ? idx + m->width  : -1,
            };
            for (int k = 0; k < 4; k++) {
                int j = nb[k];
                if (j < 0 || seen[j])
                    continue;
                if (is_water_id(MP_TERRAIN_ID(m->terrain[j])) == water) {
                    seen[j] = 1;
                    stack[sp++] = j;
                }
            }
        }
    }
    free(seen);
    free(stack);
    if (out_continents) *out_continents = continents;
    if (out_oceans)     *out_oceans = oceans;
}
