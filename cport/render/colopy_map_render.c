/* C-port Phase 7 cluster B — the map screen.
 *
 * A transcription of the JS port's census-verified map painter
 * (port/src/game.js drawMap:1555, drawTile:1422, edgeBlend:1328,
 * drawSettlement:5008, nationPlate:1721, drawUnit:1727,
 * drawMenuBar:1738, drawSidebar:1914) over the C records — the same
 * O514 -> O513 -> O512 chain of §6.3-6.11 with the byte citations kept
 * at each site.  Zoom levels 0-3 ARE ported: rm_draw_map_zoom (below)
 * draws the shrunken tiles and set_zoom (colopy_input.c) clamps 0..3 on
 * z/x.  (This comment said "zoom 1/2 UNPORTED" until 2026-08-17 — true
 * of the original ILI9341 target, stale since the P4 work.)
 *
 * Palette model (flagged): the JS resolves sprites through pre-baked
 * atlas palettes and fills/text through the usePalette merge; the C fb
 * is single-palette, so rm_use_map_palette() applies the SAME merge
 * (EGA-stub low-16 -> master, magenta placeholders -> OPENMENU) and
 * the compare tool accepts the known sprite-side grey deltas. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../core/colopy_sim.h"
#include "../data/colopy_data.h"
#include "../data/colopy_ui.h"
#include "colopy_render.h"

#define TILE 16
#define VIEW_COLS 15
#define VIEW_ROWS 12
#define VP_X 0
#define VP_Y 8
#define HUD_INK 68
#define KING_COLOUR 128               /* the Crown's plate (game.js:1715) */

/* PHYS0 disk-frame bands (engine frame - 1; game.js:383 PHYS) */
enum {
    PH_RIVER_MAJOR = 0x00, PH_RIVER_MINOR = 0x10, PH_MOUNTAIN = 0x20,
    PH_HILL = 0x30, PH_FOREST = 0x40, PH_ROAD = 0x50, PH_DETAIL = 0x59,
    PH_RUMOUR = 0x67,                 /* engine 0x68, b8 68 00 @0x68411 */
    PH_STENCIL = 0x68, PH_QUAD = 0x6C, PH_MOUTH_MAJOR = 0x8C,
    PH_MOUTH_MINOR = 0x90, PH_FOG = 0x94, PH_COAST = 0x96
};

/* render-side view state (the JS G.view / G.sel / G.blink) */
typedef struct {
    int view_x, view_y;
    int sel;                          /* units_order index, -1 none */
    int blink;                        /* 1 = active unit hidden this frame */
    int show_hidden;
} rm_view;

static rd_font TINY;

/* §26.7 zoom (game.js:752): level z spans (0xF<<z) x (0xC<<z) tiles at
 * (0x10>>z) px.  Tiles only draw at native 16px, so a zoomed view is
 * composed one 15x12 subwindow at a time and downscaled (the JS
 * zoomBuffer, 1544).  zoom_pass marks a subwindow render: colony
 * names, village war-marks and the capital sparkle are zoom-0-only
 * (game.js:1582/1605); cur_zoom scales the minimap view rect. */
static int zoom_pass = 0;
static int cur_zoom = 0;

/* tile classes come from the sim's exported tile_* helpers */
#define t_hills(v)     tile_hills((uint8_t)(v))
#define t_mountains(v) tile_mountains((uint8_t)(v))
#define t_river(v)     tile_river((uint8_t)(v))

/* TERRAIN.SS frame = ground id folded per func_006204 / hard rule 3 */
static int ground_frame(int tid) {
    tid &= 0x1F;
    if (tid >= 16 && tid <= 23) tid = (tid & 7) | 8;
    if (tid <= 7) return tid;
    if (tid <= 15) return tid == 9 ? 8 : (tid & 7);
    return tid == 24 ? 9 : tid == 25 ? 10 : 11;
}
static int is_forested_id(int tid) {
    int t = tid & 0x1F;
    if (t >= 16 && t <= 23) t = (t & 7) | 8;
    return t >= 8 && t <= 15;
}
/* §6.4: forest run = band 8..0x17 minus Scrub ((id&7)==1) */
static int forest_connects(int v) {
    int t = v & 0x1F;
    return t >= 8 && t <= 0x17 && (t & 7) != 1;
}

static int river_connects(int v) { return (v & 0x40) != 0; }

/* §6.4-6.6 — 4-cardinal mask, weights N=8 S=4 W=2 E=1 (game.js:408) */
static int mask4(int mx, int my, int (*connects)(int)) {
    return (connects(map_at(mx, my - 1)) ? 8 : 0)
         | (connects(map_at(mx, my + 1)) ? 4 : 0)
         | (connects(map_at(mx - 1, my)) ? 2 : 0)
         | (connects(map_at(mx + 1, my)) ? 1 : 0);
}

/* §6.9 detail band -- the id (and its gates) now live in the core as
 * map_detail_id(): the same seeded hash doubles as the PRIME-RESOURCE id
 * for the field yield (see colopy_map.c). */
static int detail_frame(int mx, int my, int v) {
    int d = map_detail_id(mx, my, (uint8_t)v);
    return d < 0 ? -1 : PH_DETAIL + d;
}

/* sticky visibility: CS.fog plane, bit 1<<(power+4) (game.js:8571) */
int rm_is_seen(int x, int y);
int rm_is_seen(int x, int y) {
    if (x < 0 || y < 0 || x >= COLOPY_MAP_W || y >= COLOPY_MAP_H) return 0;
    return (CS.fog[y * COLOPY_MAP_W + x] & (1 << (cs_nation() + 4))) != 0;
}
static int is_seen_rm(const rm_view *vw, int x, int y) {
    if (x < 0 || y < 0 || x >= COLOPY_MAP_W || y >= COLOPY_MAP_H) return 1;
    if (vw->show_hidden) return 1;
    return (CS.fog[y * COLOPY_MAP_W + x] & (1 << (cs_nation() + 4))) != 0;
}

#define imp_at(x, y) map_improve((x), (y))
/* colonyAt (JS: the PLAYER's colony list only) */
static int player_col_at(int x, int y) {
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation() &&
            CS.colonies[ci].map_x == x && CS.colonies[ci].map_y == y)
            return ci;
    return -1;
}

/* PHYS0C blit: the coast bands key out BOTH 0xFD and 0
 * (port/tools/build_assets.py zero_transparent) */
static void blit_key0(const rd_entry *sheet, int idx, int x, int y) {
    rd_frame f;
    if (!rd_sheet_frame(sheet, idx, &f)) return;
    for (int r = 0; r < f.h; r++) {
        int dy = y + r;
        if (dy < 0 || dy >= RD_H) continue;
        for (int c = 0; c < f.w; c++) {
            int dx = x + c;
            if (dx < 0 || dx >= RD_W) continue;
            uint8_t v = f.pix[r * f.w + c];
            if (v != RD_TRANSPARENT && v != 0) RD.fb[dy * RD_W + dx] = v;
        }
    }
}

/* O512 stencil blit (game.js:1309): the neighbour's GROUND masked by
 * PHYS0 stencil frame 0x68+dir — pixels where both are opaque. */
static void stencil_blit(int dir, int ground_idx, int px, int py) {
    rd_frame g, s;
    if (!rd_sheet_frame(&RD.terrain, ground_idx, &g)) return;
    if (!rd_sheet_frame(&RD.phys0, PH_STENCIL + dir, &s)) return;
    for (int r = 0; r < TILE; r++) {
        int dy = py + r;
        if (dy < 0 || dy >= RD_H) continue;
        for (int c = 0; c < TILE; c++) {
            int dx = px + c;
            if (dx < 0 || dx >= RD_W) continue;
            if (r >= s.h || c >= s.w || r >= g.h || c >= g.w) continue;
            if (s.pix[r * s.w + c] == RD_TRANSPARENT) continue;
            uint8_t v = g.pix[r * g.w + c];
            if (v != RD_TRANSPARENT) RD.fb[dy * RD_W + dx] = v;
        }
    }
}

/* O512 (§6.11; game.js:1328) */
static const int8_t O512_DIRS[4][2] = { {0,-1}, {1,0}, {0,1}, {-1,0} };
static const int8_t O512_RING[4][2] = { {-1,0}, {0,1}, {1,0}, {0,-1} };
static void edge_blend(const rm_view *vw, int mx, int my, int px, int py,
                       int hidden) {
    int v = map_at(mx, my);
    int centre_water = tile_water(v);
    if (centre_water && !hidden) return;
    int cls = ground_frame(v);
    for (int d = 0; d < 4; d++) {
        int nx = mx + O512_DIRS[d][0], ny = my + O512_DIRS[d][1];
        if (nx < 0 || ny < 0 || nx >= COLOPY_MAP_W || ny >= COLOPY_MAP_H)
            continue;
        int nv = map_at(nx, ny);
        if (tile_water(nv) && !centre_water) {   /* land-side beach dither */
            int found = -1;
            for (int k = 0; k < 4; k++) {
                int w = map_at(nx + O512_RING[k][0], ny + O512_RING[k][1]);
                if (!tile_water(w)) { found = w; break; }
            }
            if (found < 0) continue;             /* still water: no edge */
            nv = found;
        }
        if (!is_seen_rm(vw, nx, ny)) continue;
        int ncls = ground_frame(nv);
        if (ncls == cls && !hidden) continue;    /* same class, no fog @0x68153 */
        stencil_blit(d, ncls, px, py);
    }
}

/* §6.7 — 8-direction land bitmap N,NE,E,SE,S,SW,W,NW (game.js:1379) */
static const int8_t DIR8[8][2] = { {0,-1}, {1,-1}, {1,0}, {1,1},
                                   {0,1}, {-1,1}, {-1,0}, {-1,-1} };
static int land_bits(int mx, int my) {
    int b = 0;
    for (int d = 0; d < 8; d++)
        if (!tile_water(map_at(mx + DIR8[d][0], my + DIR8[d][1]))) b |= 1 << d;
    return b;
}
static int coast_pattern(int b) {
    if ((b & 0xDD) == 0xC1) return 0;
    if ((b & 0x77) == 0x07) return 1;
    if ((b & 0x77) == 0x70) return 2;
    if ((b & 0xDD) == 0x1C) return 3;
    return -1;
}
/* per-quadrant code (RULINGS.md 2026-08-04: |1 = COUNTER-clockwise) */
static const int8_t Q_OWN[4] = { 0, 2, 4, 6 }, Q_NEXT[4] = { 6, 0, 2, 4 },
                    Q_DIAG[4] = { 7, 1, 3, 5 };
static const int8_t Q_OFF[4][2] = { {0,0}, {8,0}, {8,8}, {0,8} };
static const int8_t HALO_DIRS[4][2] = { {0,-1}, {1,0}, {0,1}, {-1,0} };
static int halo_ground(int mx, int my) {
    int g = -1;
    for (int d = 0; d < 4; d++) {
        int n = map_at(mx + HALO_DIRS[d][0], my + HALO_DIRS[d][1]);
        if (!tile_water(n)) g = ground_frame(n & 0x1F);
    }
    return g;
}

static void draw_improvements(int mx, int my, int px, int py) {
    if (imp_at(mx, my) & ROAD_BIT) {
        rd_blit(&RD.phys0, PH_ROAD, px, py);
        for (int d = 0; d < 8; d++) {
            int nx = mx + DIR8[d][0], ny = my + DIR8[d][1];
            if ((imp_at(nx, ny) & ROAD_BIT) || player_col_at(nx, ny) >= 0)
                rd_blit(&RD.phys0, PH_ROAD + 1 + d, px, py);
        }
    }
    /* Furrows — PORT-INVENTED, flagged. The byte-verified PHYS0 band list
     * (spec/systems/map_system.md) has no plow layer at all, so what the
     * original draws here is UNKNOWN. Widened 2026-08-19 from one 4-dot row
     * on the tile's bottom edge, reported from the board as "off and mostly
     * hidden" — which it was, under any unit standing there. Bigger
     * invention, same status. */
    if (imp_at(mx, my) & PLOW_BIT)
        for (int r = 0; r < 3; r++)
            for (int k = 0; k < 4; k++)
                rd_fill(px + 2 + k * 3 + (r & 1), py + 5 + r * 4, 2, 1, 0x55);
}

/* drawTile (game.js:1422) — the O514 -> O513 -> O512 chain */
static void rm_draw_tile(const rm_view *vw, int mx, int my, int px, int py) {
    if (!is_seen_rm(vw, mx, my)) {
        rd_blit(&RD.phys0, PH_FOG, px, py);
        edge_blend(vw, mx, my, px, py, 1);
        return;
    }
    int v = map_at(mx, my);
    int water = tile_water(v);
    int ocean = ground_frame(v & 0x1F);
    rd_entry physc = RD.phys0;               /* PHYS0C = PHYS0 keyed on 0 too */

    if (!water) {
        rd_blit(&RD.terrain, ocean, px, py);
        edge_blend(vw, mx, my, px, py, 0);   /* under the overlays @0x68315 */
        if (forest_connects(v))
            rd_blit(&RD.phys0, PH_FOREST + mask4(mx, my, forest_connects),
                    px, py);
        if (t_mountains(v) || t_hills(v)) {
            int own = v & 0xA0;
            int base = t_mountains(v) ? PH_MOUNTAIN : PH_HILL;
            int m = ((map_at(mx, my - 1) & 0xA0) == own ? 8 : 0)
                  | ((map_at(mx, my + 1) & 0xA0) == own ? 4 : 0)
                  | ((map_at(mx - 1, my) & 0xA0) == own ? 2 : 0)
                  | ((map_at(mx + 1, my) & 0xA0) == own ? 1 : 0);
            rd_blit(&RD.phys0, base + m, px, py);
        }
        int r = t_river(v);
        if (r) {
            int m = mask4(mx, my, river_connects);
            if (!m) m = 0xF;                 /* isolated river forced 0xF */
            rd_blit(&RD.phys0,
                    (r == 2 ? PH_RIVER_MAJOR : PH_RIVER_MINOR) + m, px, py);
        }
        int df = detail_frame(mx, my, v);
        if (df >= 0) rd_blit(&RD.phys0, df, px, py);
        if (rumour_at(mx, my)) rd_blit(&RD.phys0, PH_RUMOUR, px, py);
        draw_improvements(mx, my, px, py);
        return;
    }
    /* water tile — §6.7 shore + clean edges + quadrant fallback */
    int bits = land_bits(mx, my);
    if (!bits) {
        rd_blit(&RD.terrain, ocean, px, py);
    } else {
        int land = halo_ground(mx, my);
        int pat = coast_pattern(bits);
        if (pat >= 0) {
            rd_blit(&RD.terrain, land >= 0 ? land : ocean, px, py);
            blit_key0(&physc, PH_COAST + pat, px, py);
        } else {
            rd_blit(&RD.terrain, ocean, px, py);
            for (int q = 0; q < 4; q++) {
                int code = ((bits >> Q_OWN[q]) & 1) * 4
                         | ((bits >> Q_NEXT[q]) & 1)
                         | ((bits >> Q_DIAG[q]) & 1) * 2;
                blit_key0(&physc, PH_QUAD + code * 4 + q,
                          px + Q_OFF[q][0], py + Q_OFF[q][1]);
            }
        }
    }
    /* §6.6 river mouths */
    if (v & 0xC0) {
        int base = (v & 0x80) ? PH_MOUTH_MAJOR : PH_MOUTH_MINOR;
        for (int d = 0; d < 4; d++) {
            int n = map_at(mx + HALO_DIRS[d][0], my + HALO_DIRS[d][1]);
            if ((n & 0x40) && !tile_water(n))
                rd_blit(&RD.phys0, base + d, px, py);
        }
    }
    int df = detail_frame(mx, my, v);
    if (df >= 0) rd_blit(&RD.phys0, df, px, py);
    draw_improvements(mx, my, px, py);
}

/* ---- markers ---- */
static const uint8_t COLONY_FRAME[4] = { 3, 0, 1, 2 };
#define NATIVE_FRAME_BASE 10
#define PENNANT_BASE 118

static void tiny_center(const char *s, int cx, int y, const uint8_t ink[4]);

/* drawSettlement (game.js:5008): marker (px-2,py); pennant ON the
 * flagpole at (px+3,py) — func_004314 @0x0043FB/@0x004404; mission
 * cross geometry func_0041AD-func_00423C. */
void rm_draw_settlement(int px, int py, int level, int nation,
                        int tribe_colour, int mission);
void rm_draw_settlement(int px, int py, int level, int nation,
                        int tribe_colour, int mission) {
    int lv = level < 0 ? 0 : level > 3 ? 3 : level;
    int frame = nation >= 0 ? COLONY_FRAME[lv] : NATIVE_FRAME_BASE + lv;
    rd_blit(&RD.icons, frame, px - 2, py);
    if (nation >= 0) {
        rd_blit(&RD.icons, PENNANT_BASE + nation, px + 3, py);
    } else {
        /* UNCITED port-invented ownership patch (game.js:5049) */
        rd_fill(px + TILE - 8, py, 8, 7, 0);
        rd_fill(px + TILE - 7, py + 1, 6, 5, (uint8_t)tribe_colour);
    }
    if (mission != 0xFF && mission >= 0) {   /* §19.7 mission cross */
        int xb = px + 6;
        int power = mission & 0x0F;
        int base = power < 4 ? (int)dat_nations[power].color : 0x0F;
        int col = (mission & 0x10) ? base : base - 8;   /* @0x41C6-0x41D4 */
        rd_fill(xb, py + 5, 5, 6, 0);
        rd_fill(xb + 2, py + 6, 1, 4, (uint8_t)col);
        rd_fill(xb + 1, py + 7, 3, 1, (uint8_t)col);
    }
}

/* func_00386A @0x00386A -- the unit-info panel composite, mode 0x64.
 *
 * Full decode in spec/ui/render_primitives.md §1b. What matters here:
 *
 *   plate w  = strwidth(status letter) + 3      (0xC2A:6 @0x003AA8)
 *   plate h  = font height + 3                  (@0x003ABC)
 *   dx0      = x + max(0, (W - (pw + sw)) / 2)  (@0x003B23)
 *   dx       = dx0 + sw, less (pw + sw - 16) when that exceeds 16
 *                                                (@0x003BF5-@0x003C07)
 *
 * and then, by unit CLASS (@0x003C09):
 *   0 foot     plate (dx, y + sh - ph)   sprite dx0, drawn AFTER the plate
 *   1 big ship plate (dx, y)             sprite dx0, drawn BEFORE
 *   2 wheeled  plate (dx0 - pw/2 + 9, y) sprite dx0, drawn BEFORE
 *   4 = 2 with y + 2 (damaged artillery)
 *   3 mounted  plate (dx0, y)            sprite dx0 + pw, pulled back by
 *              + small ships             (pw + sw - 14) when pw + sw + 2 > 16
 *
 * The plate itself is a rect of colour 0, a rect inset 1 and 2 smaller in the
 * owner colour, and the letter at +2/+2 (@0x003D1C-@0x003D66, @0x003DF8).
 *
 * The port drew a fixed 8x9 plate at a fixed x for every unit, which is why
 * the census caught F7's rows: a Galleon (class 1) wants its plate on the
 * RIGHT of the sprite, a Merchantman (class 3) on the left. */
static int panel_class(int type, int flags148) {
    switch (type) {
    case 0x0F: case 0x10: case 0x11: case 0x12: return 1;
    case 0x0A: case 0x0C:                       return 2;
    case 0x0B:            return (flags148 & 0x80) ? 4 : 2;
    case 0x0D: case 0x0E: case 0x04: case 0x05:
    case 0x07: case 0x08: case 0x15: case 0x16: return 3;
    default:                                    return 0;
    }
}
void rm_unit_panel(int x, int y, int W, int type, int flags148,
                   int orders, int colour, int frame);
void rm_unit_panel(int x, int y, int W, int type, int flags148,
                   int orders, int colour, int frame) {
    if (!TINY.payload) rd_font_open(&RD.pak, "FONTTINY.FF", &TINY);
    const char *key = dat_orders[orders >= 0 && orders < DAT_ORDERS_COUNT
                                 ? orders : 0].key;
    int pw = rd_text_width(&TINY, key) + 3;
    int ph = TINY.cell_h + 3;
    rd_frame f;
    if (!rd_sheet_frame(&RD.icons, frame, &f)) return;
    int sw = f.w, sh = f.h;
    int total = pw + sw;
    int dx0 = x + (W > total ? (W - total) / 2 : 0);
    int dx = dx0 + sw;
    if (pw + sw > 16) dx -= (pw + sw - 16);
    int cls = panel_class(type, flags148);
    int px, py, sx = dx0, after = 0;
    switch (cls) {
    case 1:  px = dx;                      py = y;          break;
    case 2:  px = dx0 - (pw >> 1) + 9;     py = y;          break;
    case 4:  px = dx0 - (pw >> 1) + 9;     py = y + 2;      break;
    case 3:
        px = dx0; py = y; sx = dx0 + pw;
        if (pw + sw + 2 > 16) sx -= (pw + sw - 14);
        break;
    default: px = dx;                      py = y + sh - ph; after = 1; break;
    }
    /* func_00380C, the two-layer sprite draw: layer 1 is the frame as a
     * SOLID BLACK SILHOUETTE at (x, y) (colour = flags&4 ? 0x5F : 0,
     * @0x003829-@0x003834, blit 0xCD8:4), layer 2 the real sprite at
     * (x + 2, y) (`lea dx, [di + 2]` @0x003854).  So every unit panel is a
     * black shadow copy with the sprite two pixels right of it -- the
     * outlined look on the live frames.  The class-0 path defers layer 1
     * until after the plates (@0x003D71); every class draws layer 2 last
     * (@0x003D80). */
    if (!after) rd_blit_silhouette(&RD.icons, frame, sx, y, 0);
    rd_fill(px, py, pw, ph, 0);
    rd_fill(px + 1, py + 1, pw - 2, ph - 2, (uint8_t)colour);
    if (after) rd_blit_silhouette(&RD.icons, frame, sx, y, 0);
    rd_blit(&RD.icons, frame, sx + 2, y);
    const uint8_t black[4] = { 0xFF, 0, 0, 0 };
    rd_text(&TINY, key, px + 2, py + 2, black);
}

/* nationPlate (game.js:1721): 8x9 black box, 6x7 colour fill, the
 * @ORDERS status letter centred in flat black. */
void rm_nation_plate(int x, int y, int colour, int orders);
void rm_nation_plate(int x, int y, int colour, int orders) {
    /* callable from any screen (colony Units view) — resolve the font */
    if (!TINY.payload) rd_font_open(&RD.pak, "FONTTINY.FF", &TINY);
    rd_fill(x, y, 8, 9, 0);
    rd_fill(x + 1, y + 1, 6, 7, (uint8_t)colour);
    const char *key = dat_orders[orders >= 0 && orders < DAT_ORDERS_COUNT
                                 ? orders : 0].key;
    const uint8_t black[4] = { 0xFF, 0, 0, 0 };
    tiny_center(key, x + 4, y + 2, black);
}

/* the JS unit table maps the @UNIT icon column to the bundle's ICONS
 * numbering with -1 (game.js:619 `icon: r.icon - 1` — the EXE-vs-atlas
 * off-by-one recorded in spec/ui/colony_screen.md §3.7) */
static int unit_icon(int ui) { return unit_icon_of(ui); }  /* func_003710 */

int rm_owner_colour_ui(int ui);
int rm_owner_colour_ui(int ui) {
    int own = CS.units[ui].owner_flags & 0x0F;
    if (CR.unit_is_ref[ui] || own == 0x0F) return KING_COLOUR;
    if (own < 4) return (int)dat_nations[own].color;
    if (own >= 4 && own < 12) return (int)dat_tribes[own - 4].color;
    return 8;
}

static int on_any_colony(int mx, int my) {
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if (CS.colonies[ci].map_x == mx && CS.colonies[ci].map_y == my)
            return 1;
    return 0;
}
static void draw_unit_rm(const rm_view *vw, int ui, int px, int py) {
    /* the active unit blinks: DRAWN while G.blink is truthy, hidden on
     * the off half (game.js:1729 `if (sel === u && !G.blink) return`) */
    if (vw->sel >= 0 && vw->sel < CR.n_units_order &&
        CR.units_order[vw->sel] == ui && !vw->blink)
        return;
    /* a unit standing on a COLONY tile is INSIDE the colony and does not
     * draw on the map -- the census MAP baseline shows San Salvador bare
     * while the port stacked the docked Galleon over it */
    if (on_any_colony(CS.units[ui].map_x, CS.units[ui].map_y)) return;
    /* the map tile draws through the SHARED func_00386A composite: the
     * baseline's ships wear the class-1 plate at the sprite's top-RIGHT
     * with the silhouette layer, exactly like the sidebar and the dock */
    rm_unit_panel(px, py, 16, CS.units[ui].type, CS.units[ui].flags,
               CS.units[ui].orders, rm_owner_colour_ui(ui), unit_icon(ui));
}

/* ---- text helpers (FONT.tiny) ---- */
static void tiny_center(const char *s, int cx, int y, const uint8_t ink[4]) {
    /* centring is on the INK width = advance - 1 (game.js:127) */
    int w = rd_text_width(&TINY, s);
    int x = cx - (w - 1) / 2;                 /* JS Math.round((2cx-w+1)/2) */
    if (2 * cx - (w - 1) < 0 && (2 * cx - (w - 1)) % 2) x--;  /* round() */
    rd_text(&TINY, s, x, y, ink);
}
static rd_font M_INTR;
static const uint8_t *lut_of(uint8_t i) {
    static uint8_t l[4];
    l[0] = 0xFF; l[1] = i; l[2] = (uint8_t)(i - 1); l[3] = 0;
    return l;
}

/* func_004314 (0x181F:0x2A8, the colony marker painter) full-size extras:
 * the POPULATION NUMBER left-aligned at (px+7, py+7) in ink 0xF -- or 0xA
 * when ColonyRecord +0x1C bit 4, 0xB when bits 4 and 2 (@0x00448B-
 * @0x0044EF) -- and the NAME left-aligned at (px+2, py+16) in ink 0xF
 * (@0x0044FA-@0x004529).  Both gated on full-size mode (si == 0x64
 * @0x004483); the si <= 0x19 path is the minimap dot.  The old centred
 * name was a guess; the MAP census baseline measures Isabella's "2" at
 * tile-relative (7,7) and the labels left-anchored. */
static void colony_marker_extras(int px, int py, int pop, uint8_t flags1c,
                                 const char *name) {
    char nb[8];
    snprintf(nb, sizeof(nb), "%d", pop);
    uint8_t ik = 0x0F;
    if (flags1c & 4) ik = (flags1c & 2) ? 0x0B : 0x0A;
    /* number font = [0x89E] = FONTTINY, name font = [0x268A] = FONTINTR
     * (spec/ui/fonts_and_colors.md's byte-verified pointer table) */
    /* FLAT single-colour glyphs: the text verb gets (ink, shadow) with
     * no ramp (0xC28:0xA args dx=0xF bx=0 @0x0044FC), and the baseline's
     * label pixels are pure white + black only */
    static uint8_t fl[4];
    fl[0] = 0xFF; fl[1] = ik; fl[2] = ik; fl[3] = 0;
    rd_text(&TINY, nb, px + 7, py + 7, fl);
    /* NO drop shadow: the baseline's glyphs carry only the font's own
     * class-3 black outline -- the 3-offset shadow block read far heavier
     * than DOS */
    static const uint8_t fw[4] = { 0xFF, 0x0F, 0x0F, 0 };
    if (!M_INTR.payload) rd_font_open(&RD.pak, "FONTINTR.FF", &M_INTR);
    rd_text(&M_INTR, name, px + 2, py + 16, fw);
}

void rm_hollow_rect(int x, int y, int w, int h, uint8_t c) {
    rd_fill(x, y, w, 1, c);
    rd_fill(x, y + h - 1, w, 1, c);
    rd_fill(x, y, 1, h, c);
    rd_fill(x + w - 1, y, 1, h, c);
}

/* drawMenuBar (game.js:1738) — no pulldown (flagged: cluster C) */
static void draw_menu_bar(void) {
    static const struct { const char *t; int x; } BAR[6] = {
        { "GAME", 17 }, { "VIEW", 49 }, { "ORDERS", 81 }, { "REPORTS", 119 },
        { "TRADE", 161 }, { "COLONIZOPEDIA", 259 }
    };
    rd_fill(0, 7, RD_W, 1, 0);
    rd_fill(240, 8, 1, RD_GAME_H - 8, 0);
    /* FLAGGED: the DOS menu face is NARROWER than FONTTINY (the
     * baseline's GAME run is 13 px where FONTTINY's is 17) but is none
     * of the shipped .FF faces -- FONT-NP scored +797 px, FONTSMAL
     * +435, FONTTINY at zero tracking +64; plain FONTTINY is the best
     * measured stand-in and stays until the face is identified. */
    for (int i = 0; i < 6; i++)
        rd_text(&TINY, BAR[i].t, BAR[i].x, 1, lut_of(HUD_INK));
}

/* colonyLevel (game.js:5002) over the runtime building list */
int rm_colony_level_ci(int ci);
int rm_colony_level_ci(int ci) {
    if (colony_has_name(ci, "Fortress")) return 3;
    if (colony_has_name(ci, "Fort")) return 2;
    if (colony_has_name(ci, "Stockade")) return 1;
    return 0;
}

/* drawSidebar (game.js:1914): minimap + HUD text + unit panel */
/* the SAMPLED minimap colour table -- built once, mirroring the engine's
 * init loop @0x0668B8-@0x066922: entry = the frame's pixel at (8, 8) of
 * a 16x16 render (func_066884 returns [bp-0x80] = buffer offset 0x88,
 * i.e. row 8 col 8; func_066850 does the same off PHYS0).  Base terrain
 * ids 0..7 are sampled from their ground frames and COPIED to the 8..15
 * and 16..23 bands (the loop stores one al to all three tables), so a
 * forested tile shows its UNFORESTED colour; 24/25/26 sample their own
 * frames; slot 0x1B samples PHYS0 frame 0x21 (mountains), 0x1C frame
 * 0x31 (hills). */
static uint8_t mm_tab[0x1D];
static int mm_tab_ready;
static uint8_t mm_sample(const rd_entry *sheet, int frame) {
    rd_frame f;
    if (!rd_sheet_frame(sheet, frame, &f)) return 0;
    if (f.w <= 8 || f.h <= 8) return 0;
    return f.pix[8 * f.w + 8];
}
static void mm_build(void) {
    if (mm_tab_ready) return;
    for (int i = 0; i < 8; i++)
        mm_tab[i] = mm_sample(&RD.terrain, ground_frame(i));
    mm_tab[0x18] = mm_sample(&RD.terrain, ground_frame(24));
    mm_tab[0x19] = mm_sample(&RD.terrain, ground_frame(25));
    mm_tab[0x1A] = mm_sample(&RD.terrain, ground_frame(26));
    /* the engine passes 0x21/0x31 in ITS numbering; the bundle is off
     * by one (PHYS comment: "MOUNTAIN: 0x20, engine 0x21") */
    mm_tab[0x1B] = mm_sample(&RD.phys0, PH_MOUNTAIN);       /* @0x066909 */
    mm_tab[0x1C] = mm_sample(&RD.phys0, PH_HILL);           /* @0x066915 */
    mm_tab_ready = 1;
}
static uint8_t mm_owner_colour(int owner) {
    /* [0x848 + owner]: powers 0..3, tribes 4..11 */
    if (owner < 4) return (uint8_t)dat_nations[owner & 3].color;
    int ti = owner - 4;
    return (uint8_t)(ti < 8 ? dat_tribes[ti].color : 8);
}
static void draw_sidebar(const rm_view *vw) {
    const int mmx = 252, mmy = 9, mmw = 56, mmh = 39;
    mm_build();
    /* backdrop fill is (241, 8) 79x41 (@0x066CF8), the frame (251, 8)-
     * (308, 48) colour 6 (@0x066D4F) */
    /* the black backdrop runs one row BELOW the frame too -- the
     * baseline has a full-width black row at y = 49 */
    rd_fill(241, 8, 79, 42, 0);
    rm_hollow_rect(mmx - 1, mmy - 1, mmw + 2, mmh + 2, 6);
    /* the WINDOW (verb 0x181F:0x59A = @0x066928): anchored to the map
     * CURSOR [0x17C]/[0x17E] -- the active unit after a load -- with
     * sx = clamp(cx - 0x1C, 1, W - 0x39), sy = clamp(cy - 0x13, 1,
     * H - 0x28).  Low bound 1, not 0.  With no selection the port falls
     * back to the view centre as the cursor model. */
    int cx, cy;
    if (vw->sel >= 0 && vw->sel < CR.n_units_order) {
        cx = CS.units[CR.units_order[vw->sel]].map_x;
        cy = CS.units[CR.units_order[vw->sel]].map_y;
    } else {
        cx = vw->view_x + VIEW_COLS / 2;
        cy = vw->view_y + VIEW_ROWS / 2;
    }
    int sx = cx - 0x1C, sy = cy - 0x13;
    if (sx > COLOPY_MAP_W - 0x39) sx = COLOPY_MAP_W - 0x39;
    if (sx < 1) sx = 1;
    if (sy > COLOPY_MAP_H - 0x28) sy = COLOPY_MAP_H - 0x28;
    if (sy < 1) sy = 1;
    /* terrain pass (func_066968): fog -> stays black; hills/mountains
     * (terrain bit 0x20) index 0x1B (bit 0x80 set) / 0x1C; else
     * table[id] with the 8..23 bands folded to their base id */
    for (int y = 0; y < mmh; y++)
        for (int x = 0; x < mmw; x++) {
            int mx = sx + x, my = sy + y;
            if (mx >= COLOPY_MAP_W || my >= COLOPY_MAP_H) continue;
            if (!is_seen_rm(vw, mx, my)) continue;
            int v = map_at(mx, my), t = v & 0x1F;
            uint8_t c;
            if (v & 0x20) c = mm_tab[(v & 0x80) ? 0x1B : 0x1C];
            else {
                if (t >= 16 && t <= 23) t -= 16;
                else if (t >= 8 && t <= 15) t -= 8;
                c = mm_tab[t];
            }
            rd_fill(mmx + x, mmy + y, 1, 1, c);
        }
    /* unit dots (the flags-plane bit 1 branch @0x066A96): owner colour;
     * a FOREIGN Privateer with chain_next < 0 greys to 8 (@0x066AED --
     * the unidentified sail).  FLAGGED: the engine gates each unit on the
     * record owner byte's per-power seen mask, 0x10 << player
     * (@0x066ABC); the runtime mirrors carry no such mask, so both
     * engines substitute the tile's sticky visibility -- the same proxy,
     * identically, to keep JS == C. */
    for (int q = 0; q < CR.n_units_order; q++) {
        int ui = CR.units_order[q];
        int dx = CS.units[ui].map_x - sx, dy = CS.units[ui].map_y - sy;
        if (dx < 0 || dy < 0 || dx >= mmw || dy >= mmh) continue;
        if (!is_seen_rm(vw, CS.units[ui].map_x, CS.units[ui].map_y))
            continue;
        rd_fill(mmx + dx, mmy + dy, 1, 1,
                mm_owner_colour((int)cs_nation()));
    }
    for (int rn = 0; rn < 4; rn++) {
        if (rn == (int)cs_nation()) continue;
        for (int k = 0; k < CR.n_runits[rn]; k++) {
            int ui = CR.runits_order[rn][k];
            int ux = CR.runit_x[ui], uy = CR.runit_y[ui];
            int dx = ux - sx, dy = uy - sy;
            if (dx < 0 || dy < 0 || dx >= mmw || dy >= mmh) continue;
            if (!is_seen_rm(vw, ux, uy)) continue;
            uint8_t c = CS.units[ui].type == 0x10
                        ? 8 : mm_owner_colour(rn);
            rd_fill(mmx + dx, mmy + dy, 1, 1, c);
        }
    }
    for (int k = 0; k < CR.n_natives; k++) {
        int ui = CR.natives_order[k];
        int ux = CS.units[ui].map_x, uy = CS.units[ui].map_y;
        int dx = ux - sx, dy = uy - sy;
        if (dx < 0 || dy < 0 || dx >= mmw || dy >= mmh) continue;
        if (!is_seen_rm(vw, ux, uy)) continue;
        rd_fill(mmx + dx, mmy + dy, 1, 1,
                mm_owner_colour((int)CS.units[ui].owner_flags & 0x0F));
    }
    /* settlement dots draw ABOVE units (the engine's per-pixel priority
     * is colony > unit > terrain): villages in tribe colours, colonies
     * of EVERY power in the owner colour ([0x848 + owner]) */
    for (int vi = 0; vi < CS.n_villages; vi++) {
        int dx = CS.villages[vi].map_x - sx, dy = CS.villages[vi].map_y - sy;
        if (dx < 0 || dy < 0 || dx >= mmw || dy >= mmh) continue;
        if (!is_seen_rm(vw, CS.villages[vi].map_x, CS.villages[vi].map_y))
            continue;
        rd_fill(mmx + dx, mmy + dy, 1, 1,
                mm_owner_colour(CS.villages[vi].owner_tribe));
    }
    for (int ci = 0; ci < CS.n_colonies; ci++) {
        int dx = CS.colonies[ci].map_x - sx, dy = CS.colonies[ci].map_y - sy;
        if (dx < 0 || dy < 0 || dx >= mmw || dy >= mmh) continue;
        if (!is_seen_rm(vw, CS.colonies[ci].map_x, CS.colonies[ci].map_y))
            continue;
        rd_fill(mmx + dx, mmy + dy, 1, 1,
                mm_owner_colour(CS.colonies[ci].owner_power & 3));
    }
    rm_hollow_rect(mmx + (vw->view_x - sx), mmy + (vw->view_y - sy),
                VIEW_COLS << cur_zoom, VIEW_ROWS << cur_zoom, 0x0F);

    /* season/gold lines measured off the baseline: x = 242 (not 244),
     * gold row y = 58 (not 59), tax right-block shifted with it */
    char buf[64];
    snprintf(buf, sizeof(buf), "%s %u", dat_seasons[cs_season()], cs_year());
    rd_text(&TINY, buf, 242, 51, lut_of(HUD_INK));
    snprintf(buf, sizeof(buf), "Gold: %ld", (long)CS.powers[cs_nation()].gold);
    rd_text(&TINY, buf, 242, 58, lut_of(HUD_INK));
    snprintf(buf, sizeof(buf), "Tax: %u%%", CS.powers[cs_nation()].tax_rate);
    rd_text(&TINY, buf, 288, 58, lut_of(HUD_INK));

    if (vw->sel >= 0 && vw->sel < CR.n_units_order) {
        int ui = CR.units_order[vw->sel];
        const UnitRecord *u = &CS.units[ui];
        rd_frame f;
        /* the sidebar unit is the SHARED func_00386A composite -- the MAP
         * baseline shows the black silhouette layer and the class-1 plate
         * at the frigate's top-right (interior orange measured at
         * (252..256, 69..75), which the panel model reproduces from an
         * anchor of (242, 68)).  The old centred-sprite + 8x9 plate at
         * (244,72) was capture-era guesswork. */
        rm_unit_panel(242, 68, 0, u->type, u->flags, u->orders,
                   rm_owner_colour_ui(ui), unit_icon(ui));
        int whole = u->moves_remaining / 3, frac = u->moves_remaining % 3;
        if (frac)
            snprintf(buf, sizeof(buf), "Moves: %d %d/3", whole, frac);
        else
            snprintf(buf, sizeof(buf), "Moves: %d", whole);
        /* text geometry MEASURED off the MAP baseline (glyph tops):
         * Moves (260, 69), Locat (260, 77) -- pitch 8; the unit block
         * "Dutch Frigate" (242, 86), orders (242, 93), terrain (242,
         * 100) -- pitch 7.  The ORDERS line prints in YELLOW 0x95
         * (199,162,32 measured); whether that highlight is
         * active-unit-only or permanent is UNRESOLVED on one frame --
         * this panel only ever shows the active unit, so the port
         * cannot tell the difference either. */
        rd_text(&TINY, buf, 260, 69, lut_of(HUD_INK));
        snprintf(buf, sizeof(buf), "Locat: (%u, %u)", u->map_x, u->map_y);
        rd_text(&TINY, buf, 260, 77, lut_of(HUD_INK));
        snprintf(buf, sizeof(buf), "%s %s", dat_nations[cs_nation()].abbrev,
                 dat_units[u->type].name);
        rd_text(&TINY, buf, 242, 86, lut_of(HUD_INK));
        rd_text(&TINY, dat_orders[u->orders < DAT_ORDERS_COUNT ? u->orders : 0]
                           .name, 242, 93, lut_of(0x95));
        /* terrainName (game.js:461) */
        int v = map_at(u->map_x, u->map_y), t = v & 0x1F;
        const char *tn;
        if (t_mountains(v)) tn = "Mountains";
        else if (t_hills(v)) tn = "Hills";
        else if (t <= 7) tn = dat_terrain_unforested[t];
        else if (t <= 23)
            tn = dat_terrain_forested[(((t >= 16) ? (t & 7) | 8 : t) - 8) & 7];
        else tn = dat_terrain_other[t - 24];   /* Arctic/Ocean/Sea Lane */
        snprintf(buf, sizeof(buf), "(%s)", tn);
        rd_text(&TINY, buf, 242, 100, lut_of(HUD_INK));
        /* carried units (JS u.cargo) — CR.unit_pass, flagged: labels
         * shortened to the entry name */
        int cy = 128;
        for (int k = 0; k < CR.unit_n_pass[ui]; k++) {
            int ty2 = entry_unit_type(&CR.unit_pass[ui][k]);
            if (ty2 >= 0 && rd_sheet_frame(&RD.icons,
                                           (int)dat_units[ty2].icon - 1, &f))
                rd_blit(&RD.icons, (int)dat_units[ty2].icon - 1, 244, cy - 4);
            rm_nation_plate(244, cy - 4, (int)dat_nations[cs_nation()].color, 1);
            rd_text(&TINY, immigrant_name(&CR.unit_pass[ui][k]), 268, cy,
                    lut_of(HUD_INK));
            rd_text(&TINY, "Sentry", 268, cy + 8, lut_of(HUD_INK));
            cy += 20;
        }
    }
}

/* the JS usePalette merge (game.js:36): base palette, magenta
 * placeholders patched from OPENMENU, EGA-stub low-16 from the master */
static void rm_use_map_palette(void) {
    rd_use_palette(0);                       /* master into RD.pal */
    uint8_t master[768];
    memcpy(master, RD.pal, 768);
    rd_entry wt, om;
    const uint8_t *wp = 0, *op = 0;
    if (rd_pak_find(&RD.pak, "WOODTILE.SS", &wt)) wp = rd_sheet_pal(&wt);
    if (rd_pak_find(&RD.pak, "OPENMENU.PIK", &om) &&
        om.len == (uint32_t)om.w * om.h + 768)
        op = om.payload + (uint32_t)om.w * om.h;
    if (!wp) return;
    memcpy(RD.pal, wp, 768);
    static const uint8_t EGA[48] = {
        0,0,0, 0,0,170, 0,170,0, 0,170,170, 170,0,0, 170,0,170,
        170,85,0, 170,170,170, 85,85,85, 85,85,255, 85,255,85,
        85,255,255, 255,85,85, 255,85,255, 255,255,85, 255,255,255 };
    rd_pal_fill_placeholders(RD.pal, master, op);
    if (memcmp(wp, EGA, 48) == 0)
        memcpy(RD.pal, master, 48);
}

/* the colony scene panel composites tiles through the SAME drawTile
 * chain (game.js:3565) — exported for colopy_colony_render.c */
void rm_scene_tile(int mx, int my, int px, int py) {
    rm_view vw = { 0, 0, -1, 0, 0 };
    rm_draw_tile(&vw, mx, my, px, py);
    /* settlements land on their tiles too (game.js:3568) */
    for (int q = 0; q < CS.n_colonies; q++) {
        const ColonyRecord *oc = &CS.colonies[q];
        if (oc->map_x != mx || oc->map_y != my) continue;
        if ((oc->owner_power & 3) == cs_nation())
            rm_draw_settlement(px, py, rm_colony_level_ci(q), oc->owner_power & 3,
                            0, 0xFF);
    }
    for (int rn = 0; rn < 4; rn++) {
        if (rn == (int)cs_nation()) continue;
        for (int k = 0; k < CR.rivals[rn].n_col; k++) {
            const rival_colony *rc = &CR.rivals[rn].col[k];
            if (rc->x == mx && rc->y == my)
                rm_draw_settlement(px, py, rc->level, rn, 0, 0xFF);
        }
    }
    for (int v = 0; v < CS.n_villages; v++) {
        const NativeSettlement *vs = &CS.villages[v];
        if (vs->map_x != mx || vs->map_y != my) continue;
        int ti = vs->owner_tribe - 4;
        rm_draw_settlement(px, py, tribe_level(ti), -1,
                        ti >= 0 && ti < 8 ? (int)dat_tribes[ti].color : 8,
                        vs->mission);
    }
}

/* drawMap (game.js:1555) at native 16px — one 15x12 window; the
 * pulldown/dialog layers are cluster C */
static void draw_map_native(int view_x, int view_y, int sel, int blink) {
    rm_view vw = { view_x, view_y, sel, blink, 0 };
    if (!TINY.payload) rd_font_open(&RD.pak, "FONTTINY.FF", &TINY);
    rm_use_map_palette();

    rd_frame wt;
    rd_sheet_frame(&RD.woodtile, 0, &wt);
    for (int y = 0; y < RD_GAME_H; y += wt.h)
        for (int x = 0; x < RD_W; x += wt.w)
            rd_blit(&RD.woodtile, 0, x, y);
    rd_fill(VP_X, VP_Y, 240, 192, 0);
    for (int ty = 0; ty < VIEW_ROWS; ty++)
        for (int tx = 0; tx < VIEW_COLS; tx++)
            rm_draw_tile(&vw, view_x + tx, view_y + ty,
                         VP_X + tx * TILE, VP_Y + ty * TILE);
    /* colonies (player list = record order, owner == nation) */
    for (int ci = 0; ci < CS.n_colonies; ci++) {
        const ColonyRecord *c = &CS.colonies[ci];
        if ((c->owner_power & 3) != cs_nation()) continue;
        int tx = c->map_x - view_x, ty = c->map_y - view_y;
        if (tx < 0 || ty < 0 || tx >= VIEW_COLS || ty >= VIEW_ROWS) continue;
        int px = VP_X + tx * TILE, py = VP_Y + ty * TILE;
        rm_draw_settlement(px, py, rm_colony_level_ci(ci), c->owner_power & 3,
                        0, 0xFF);
        if (!zoom_pass) {              /* names at zoom 0 only (1582) */
            char nm[25];
            memcpy(nm, c->name, 24);
            nm[24] = 0;
            colony_marker_extras(px, py, c->population, c->colony_flags, nm);
        }
    }
    /* native settlements */
    for (int vi = 0; vi < CS.n_villages; vi++) {
        const NativeSettlement *v = &CS.villages[vi];
        int tx = v->map_x - view_x, ty = v->map_y - view_y;
        if (tx < 0 || ty < 0 || tx >= VIEW_COLS || ty >= VIEW_ROWS) continue;
        if (!is_seen_rm(&vw, v->map_x, v->map_y)) continue;
        int ti = v->owner_tribe - 4;
        int px = VP_X + tx * TILE, py = VP_Y + ty * TILE;
        rm_draw_settlement(px, py, tribe_level(ti), -1,
                        ti >= 0 && ti < 8 ? (int)dat_tribes[ti].color : 8,
                        v->mission);
        /* §19.6 war-stance marks: count = raid-target score / 4 + 1
         * (0x181F:0x316 = func_0460F8; RULINGS 2026-08-07e) */
        int score, best = raid_target_score(vi, &score);
        if (!zoom_pass && best >= 0 && score >= 0) {
            int alarm = CR.alarm[vi];
            int tension = ti >= 0 && ti < 8 ? CR.tension[ti] : 0;
            int level = tension >= 75 ? 3
                      : (alarm >> 5) < 3 ? (alarm >> 5) : 3;
            static const uint8_t MC[4] = { 0x0A, 0x0B, 0x0E, 0x0C };
            int colour = MC[level];
            int xb = px + 6;
            for (int s = score; s >= 0; s -= 4) {
                int c2 = s <= 2 ? colour - 8 : colour;   /* dim @0x412F */
                rd_fill(xb, py + 4, 3, 7, 0);
                rd_fill(xb + 1, py + 5, 1, 4, (uint8_t)c2);
                rd_fill(xb + 1, py + 9, 1, 1, (uint8_t)c2);
                xb += 2;
            }
        }
        if (!zoom_pass && (v->flags & 0x04)) /* capital sparkle @0x4051 */
            rd_blit(&RD.icons, 17, px, py);
    }
    /* braves + natives-parked units (G.natives order) -- through the
     * shared func_00386A composite like every other map unit */
    for (int k = 0; k < CR.n_natives; k++) {
        int ui = CR.natives_order[k];
        int ux = CS.units[ui].map_x, uy = CS.units[ui].map_y;
        int tx = ux - view_x, ty = uy - view_y;
        if (tx < 0 || ty < 0 || tx >= VIEW_COLS || ty >= VIEW_ROWS) continue;
        if (!is_seen_rm(&vw, ux, uy)) continue;
        if (on_any_colony(ux, uy)) continue;
        int px = VP_X + tx * TILE, py = VP_Y + ty * TILE;
        rm_unit_panel(px, py, 16, CS.units[ui].type, CS.units[ui].flags,
                   CS.units[ui].orders, rm_owner_colour_ui(ui),
                   unit_icon(ui));
    }
    /* rivals: colonies then units, per power */
    for (int rn = 0; rn < 4; rn++) {
        if (rn == (int)cs_nation()) continue;
        for (int k = 0; k < CR.rivals[rn].n_col; k++) {
            const rival_colony *rc = &CR.rivals[rn].col[k];
            int tx = rc->x - view_x, ty = rc->y - view_y;
            if (tx < 0 || ty < 0 || tx >= VIEW_COLS || ty >= VIEW_ROWS)
                continue;
            if (!is_seen_rm(&vw, rc->x, rc->y)) continue;
            rm_draw_settlement(VP_X + tx * TILE, VP_Y + ty * TILE,
                            rc->level, rn, 0, 0xFF);
            /* func_004314 draws the number + name for EVERY colony -- the
             * MAP baseline shows St. Louis (French) with both.  The rival
             * mirror carries no +0x1C flags; the record is at hand. */
            if (!zoom_pass) {
                for (int q2 = 0; q2 < CS.n_colonies; q2++) {
                    const ColonyRecord *oc = &CS.colonies[q2];
                    if (oc->map_x != rc->x || oc->map_y != rc->y) continue;
                    char nm[25];
                    memcpy(nm, oc->name, 24);
                    nm[24] = 0;
                    colony_marker_extras(VP_X + tx * TILE, VP_Y + ty * TILE,
                                         oc->population, oc->colony_flags,
                                         nm);
                    break;
                }
            }
        }
        for (int k = 0; k < CR.n_runits[rn]; k++) {
            int ui = CR.runits_order[rn][k];
            int ux = CR.runit_x[ui], uy = CR.runit_y[ui];
            int tx = ux - view_x, ty = uy - view_y;
            if (tx < 0 || ty < 0 || tx >= VIEW_COLS || ty >= VIEW_ROWS)
                continue;
            if (!is_seen_rm(&vw, ux, uy)) continue;
            if (on_any_colony(ux, uy)) continue;
            int px = VP_X + tx * TILE, py = VP_Y + ty * TILE;
            rm_unit_panel(px, py, 16, CS.units[ui].type,
                       CS.units[ui].flags, CS.units[ui].orders,
                       (int)dat_nations[rn].color, unit_icon(ui));
        }
    }
    /* the King's REF */
    for (int k = 0; k < CR.n_refs; k++) {
        int ui = CR.refs_order[k];
        int ux = CS.units[ui].map_x, uy = CS.units[ui].map_y;
        int tx = ux - view_x, ty = uy - view_y;
        if (tx < 0 || ty < 0 || tx >= VIEW_COLS || ty >= VIEW_ROWS) continue;
        if (on_any_colony(ux, uy)) continue;
        int px = VP_X + tx * TILE, py = VP_Y + ty * TILE;
        rm_unit_panel(px, py, 16, CS.units[ui].type, CS.units[ui].flags,
                   CS.units[ui].orders, KING_COLOUR, unit_icon(ui));
    }
    /* player units, selected last (stack top) */
    for (int pass = 0; pass < 2; pass++)
        for (int k = 0; k < CR.n_units_order; k++) {
            if ((pass == 1) != (k == sel)) continue;
            int ui = CR.units_order[k];
            int tx = CS.units[ui].map_x - view_x;
            int ty = CS.units[ui].map_y - view_y;
            if (tx < 0 || ty < 0 || tx >= VIEW_COLS || ty >= VIEW_ROWS)
                continue;
            draw_unit_rm(&vw, ui, VP_X + tx * TILE, VP_Y + ty * TILE);
        }
    draw_menu_bar();
    draw_sidebar(&vw);
}

/* ---- cluster C: the pulldown layer (game.js:1738-1862) ---------------- */
/* FRAME_GAME plaque rings (game.js:794); the bevel paint ORDER is
 * load-bearing (top after left, bottom last — game.js:801). */
void rm_plaque(int x, int y, int w, int h) {
    rm_hollow_rect(x, y, w, h, 0);
    rm_hollow_rect(x + 1, y + 1, w - 2, h - 2, 134);
    rd_fill(x + 2, y + 2, 1, h - 4, 138);            /* left, dark */
    rd_fill(x + w - 3, y + 2, 1, h - 4, 128);        /* right, light */
    rd_fill(x + 2, y + 2, w - 4, 1, 128);            /* top, light */
    rd_fill(x + 2, y + h - 3, w - 4, 1, 138);        /* bottom, dark */
    /* interior: WOODTILE tiled, grid anchored at ix-3/iy-3 under the
     * clip (func_00E350 @0x00E371-A2) */
    int ix = x + 3, iy = y + 3, iw = w - 6, ih = h - 6;
    rd_frame wt;
    if (!rd_sheet_frame(&RD.woodtile, 0, &wt)) return;
    for (int yy = iy - 3; yy < iy + ih; yy += wt.h)
        for (int xx = ix - 3; xx < ix + iw; xx += wt.w)
            for (int r = 0; r < wt.h; r++) {
                int dy = yy + r;
                if (dy < 0 || dy < iy || dy >= iy + ih || dy >= RD_H)
                    continue;
                for (int c = 0; c < wt.w; c++) {
                    int dx = xx + c;
                    /* clip to the SCREEN as well as the interior rect: a
                     * wider-than-screen popup has ix < 0, and a negative
                     * dx would wrap fb[dy*W+dx] into the previous row */
                    if (dx < 0 || dx < ix || dx >= ix + iw || dx >= RD_W)
                        continue;
                    uint8_t v = wt.pix[r * wt.w + c];
                    if (v != RD_TRANSPARENT) RD.fb[dy * RD_W + dx] = v;
                }
            }
}

/* menuVisibleRows (game.js:1811): GAME/VIEW/REPORTS group by label
 * prefix with separators; ORDERS is context-built from the selected
 * unit (ordersMenuRows, game.js:1780 — the gating is CAPTURE-DERIVED
 * from the census frigate/wagon frames, flagged like the JS). */
#define MENU_SEP_H 7

/* accel comes from the ORDERS master rows by label match (drawPulldown
 * game.js:1854 `m.rows.find(q => q.label === r.label)`) */
static const char *orders_accel(const char *label) {
    for (int mi = 0; mi < DAT_MENUS_COUNT; mi++) {
        if (strcmp(dat_menus[mi].title, "ORDERS") != 0) continue;
        for (int k = 0; k < dat_menus[mi].row_count; k++) {
            const dat_menu_rows_t *r = &dat_menu_rows[dat_menus[mi].row_start + k];
            if (strcmp(r->label, label) == 0) return r->accel;
        }
    }
    return "";
}
static int orders_rows(int sel, rm_mrow *out) {
    int n = 0;
#define PUSH(l, d) out[n++] = (rm_mrow){ (l), orders_accel(l), (d) ? 1 : 0, 0 }
#define SEP() out[n++] = (rm_mrow){ 0, 0, 0, 1 }
    if (sel < 0 || sel >= CR.n_units_order) {
        /* no unit: every master row, dimmed (game.js:1782) — EXCEPT, on a
         * LIVE front end, "Wait for next unit".
         *
         * Once next_unit learned to skip a unit under a standing order
         * (2026-08-17), "nothing is active" became an ordinary state:
         * fortify or sentry everything and the cycle offers nobody.  The
         * JS reaches advance() only through a selected unit, so with all
         * 20 rows dim the pulldown opened DEAD and the turn could not be
         * ended from it at all — the board's long-press was the only exit,
         * and an undiscoverable one (user report 2026-08-17).
         *
         * "Wait for next unit" is a SHIPPED @ORDERS row (no End-of-Turn
         * row exists in the DOS menu, so none is invented here); with
         * nobody to wait for, run_menu_row rolls the turn instead.
         * front_live gates it, like the Space affordance in colopy_input.c,
         * so the harness and the JS are untouched and stay in parity. */
        for (int mi = 0; mi < DAT_MENUS_COUNT; mi++) {
            if (strcmp(dat_menus[mi].title, "ORDERS") != 0) continue;
            for (int k = 0; k < dat_menus[mi].row_count; k++) {
                const dat_menu_rows_t *r =
                    &dat_menu_rows[dat_menus[mi].row_start + k];
                int dim = !(colopy_front_live && r->label &&
                            strcmp(r->label, "Wait for next unit") == 0);
                out[n++] = (rm_mrow){ r->label, r->accel, (int8_t)dim, 0 };
            }
        }
        return n;
    }
    int ui = CR.units_order[sel];
    const UnitRecord *u = &CS.units[ui];
    const dat_units_t *t = &dat_units[u->type];
    int ship = t->hull > 0;
    int at_own = player_col_at(u->map_x, u->map_y) >= 0;
    int carrier = t->cargo > 0;
    int pioneer = strstr(t->name, "Pioneer") != 0;
    /* NOT_COLONISTS (game.js:1977): the three non-person kinds */
    int founder = !ship && strcmp(t->name, "Wagon Train") != 0 &&
                  strcmp(t->name, "Artillery") != 0 &&
                  strcmp(t->name, "Treasure") != 0;
    int v = map_at(u->map_x, u->map_y);
    int forest = !ship && is_forested_id(v & 0x1F);
    int hold = CR.unit_n_hold[ui] > 0 || CR.unit_n_pass[ui] > 0;
    int sea_lane = (v & 0x1F) == TERR_SEALANE;   /* the Return gate */
    PUSH("Activate unit", 0); PUSH("Wait for next unit", 0);
    PUSH("Fortify", 0); PUSH("Sentry", 0);
    SEP();
    if (founder) { PUSH("Build Colony", 0); PUSH("Join Colony (B)", 0); }
    if (forest) PUSH("Clear Forest (P)", !pioneer);
    else PUSH("Plow Fields  (P)", ship || !pioneer);
    PUSH("Build Road", ship || !pioneer);
    PUSH("Load Cargo", !(carrier && at_own));
    PUSH("Unload Cargo", !(carrier && at_own && hold));
    SEP();
    PUSH(ship ? "Go to Port" : "Go to Place", 0);
    PUSH("Begin Trade Route", 0);
    if (ship) PUSH("Return to Europe", !sea_lane);
    if (founder) PUSH("Pillage", 0);
    SEP();
    PUSH("No Orders (space bar)", 0);
    SEP();
    PUSH("Dump Cargo Overboard", !hold);
    PUSH("Disband Unit (shift-D)", 0);
#undef PUSH
#undef SEP
    return n;
}

int rm_menu_rows(int mi, int sel, rm_mrow *out);
int rm_menu_rows(int mi, int sel, rm_mrow *out) {
    if (strcmp(dat_menus[mi].title, "ORDERS") == 0)
        return orders_rows(sel, out);
    static const char *GROUPS_GAME[][2] = {
        { "Game Options", "Colony Report Options" }, { "Sound Options", "Pick Music" },
        { "Save Game", "Load Game" }, { "Declare Independence", 0 },
        { "Retire", "Exit to DOS" } };
    static const char *GROUPS_VIEW[][3] = {
        { "Move Pieces", "View Pieces", "European Status" }, { "Find Colony", 0, 0 },
        { "Zoom In", "Zoom Out", 0 }, { "Zoom Level", 0, 0 },
        { "Show Hidden Terrain", "Center View", 0 } };
    static const char *GROUPS_REP[][4] = {
        { "F1", 0, 0, 0 }, { "F2", "F3", "F4", "F5" },
        { "F6", "F7", "F8", "F9" }, { "F10", 0, 0, 0 } };
    const dat_menus_t *m = &dat_menus[mi];
    int n = 0;
    int ngroups = 0, gw = 0;
    const char *const *groups = 0;
    if (strcmp(m->title, "GAME") == 0) { groups = &GROUPS_GAME[0][0]; ngroups = 5; gw = 2; }
    else if (strcmp(m->title, "VIEW") == 0) { groups = &GROUPS_VIEW[0][0]; ngroups = 5; gw = 3; }
    else if (strcmp(m->title, "REPORTS") == 0) { groups = &GROUPS_REP[0][0]; ngroups = 4; gw = 4; }
    uint8_t used[64] = { 0 };
    if (groups) {
        for (int g = 0; g < ngroups; g++) {
            int any = 0;
            for (int k = 0; k < m->row_count; k++) {
                if (used[k]) continue;
                const dat_menu_rows_t *r = &dat_menu_rows[m->row_start + k];
                int hit = 0;
                for (int p = 0; p < gw && groups[g * gw + p]; p++)
                    if (strncmp(r->label, groups[g * gw + p],
                                strlen(groups[g * gw + p])) == 0) hit = 1;
                if (!hit) continue;
                if (!any && n) out[n++] = (rm_mrow){ 0, 0, 0, 1 };
                any = 1;
                used[k] = 1;
                out[n++] = (rm_mrow){ r->label, r->accel, r->disabled, 0 };
            }
        }
    }
    for (int k = 0; k < m->row_count; k++) {
        if (used[k]) continue;
        const dat_menu_rows_t *r = &dat_menu_rows[m->row_start + k];
        out[n++] = (rm_mrow){ r->label, r->accel, r->disabled, 0 };
    }
    return n;
}

/* drawPulldown (game.js:1836) — the four static menus */
static const int BAR_X[6] = { 17, 49, 81, 119, 161, 259 };

/* pulldownBox (game.js:1827) — shared with the pointer layer */
void rm_pulldown_box(int mi, int sel, int *bx, int *by, int *bw, int *bh);
void rm_pulldown_box(int mi, int sel, int *bx, int *by, int *bw, int *bh) {
    if (!TINY.payload) rd_font_open(&RD.pak, "FONTTINY.FF", &TINY);
    rm_mrow rows[64];
    int n = rm_menu_rows(mi, sel, rows);
    int w = 0, h = 4;
    for (int k = 0; k < n; k++) {
        if (rows[k].sep) { h += MENU_SEP_H; continue; }
        int lw = rd_text_width(&TINY, rows[k].label);
        if (lw > w) w = lw;
        h += 8;
    }
    w += 16;
    int x = BAR_X[mi] - 2;
    if (x > RD_W - w - 2) x = RD_W - w - 2;
    *bx = x;
    *by = 8;
    *bw = w;
    *bh = h;
}

/* the menubar title under mx (onClick, game.js:12303): mx in
 * [x-2, x+width(title)+2) — the menu index, or -1 */
int rm_menubar_hit(int mx);
int rm_menubar_hit(int mx) {
    if (!TINY.payload) rd_font_open(&RD.pak, "FONTTINY.FF", &TINY);
    for (int i = 0; i < DAT_MENUS_COUNT; i++) {
        int w = rd_text_width(&TINY, dat_menus[i].title);
        if (mx >= BAR_X[i] - 2 && mx < BAR_X[i] + w + 2) return i;
    }
    return -1;
}

void rm_draw_pulldown(int mi, int menu_sel, int sel) {
    if (mi < 0 || mi >= DAT_MENUS_COUNT) return;
    if (!TINY.payload) rd_font_open(&RD.pak, "FONTTINY.FF", &TINY);
    rm_mrow rows[64];
    int n = rm_menu_rows(mi, sel, rows);
    int x, y, w, h;
    rm_pulldown_box(mi, sel, &x, &y, &w, &h);
    /* selected-title highlight on the bar (drawMenuBar, game.js:1746) */
    rd_fill(BAR_X[mi] - 2, 0, rd_text_width(&TINY, dat_menus[mi].title) + 4,
            7, 0x37);
    rd_text(&TINY, dat_menus[mi].title, BAR_X[mi], 1, lut_of(HUD_INK));
    rm_plaque(x, y, w, h);
    int py = y + 2;
    for (int k = 0; k < n; k++) {
        if (rows[k].sep) {
            rd_fill(x + 2, py + 3, w - 4, 1, HUD_INK);
            py += MENU_SEP_H;
            continue;
        }
        int sel = k == menu_sel;
        if (sel) rd_fill(x + 2, py, w - 4, 8, 138);   /* SELECT_GAME */
        int base = rows[k].dim ? 0x2F : (sel ? 0xFC : 0xFE);
        /* DECLARE INDEPENDENCE capitalises (census GAME frame) */
        char label[64];
        snprintf(label, sizeof(label), "%s", rows[k].label);
        if (strncmp(label, "Declare Independence", 20) == 0)
            for (char *p = label; *p; p++)
                if (*p >= 'a' && *p <= 'z') *p -= 32;
        int tx = x + 6;
        int ai = -1;
        if (rows[k].accel && rows[k].accel[0] && !rows[k].dim)
            for (int c = 0; label[c]; c++) {
                char u = label[c] >= 'a' && label[c] <= 'z' ? label[c] - 32
                                                            : label[c];
                if (u == rows[k].accel[0]) { ai = c; break; }
            }
        if (ai < 0) {
            rd_text(&TINY, label, tx, py + 1, lut_of((uint8_t)base));
        } else {
            char pre[64], mid[2] = { label[ai], 0 };
            memcpy(pre, label, (size_t)ai);
            pre[ai] = 0;
            tx = rd_text(&TINY, pre, tx, py + 1, lut_of((uint8_t)base));
            tx = rd_text(&TINY, mid, tx, py + 1, lut_of(0x0E));
            rd_text(&TINY, label + ai + 1, tx, py + 1, lut_of((uint8_t)base));
        }
        py += 8;
    }
}


/* drawMap over G.zoom (game.js:1569-1686): zoom 0 draws straight to
 * the fb; a zoomed view renders each 15x12 subwindow at native 16px
 * and downscales it (nearest-neighbour — the JS drawImage scaling is
 * a canvas artefact, FLAGGED) into the same 240x192 viewport, then
 * one native pass lays down the chrome (bar/sidebar) around it. */
void rm_draw_map_zoom(int view_x, int view_y, int sel, int blink,
                      int zoom) {
    if (zoom < 0) zoom = 0;
    if (zoom > 3) zoom = 3;
    cur_zoom = zoom;
    if (zoom == 0) {
        draw_map_native(view_x, view_y, sel, blink);
        return;
    }
    /* The compose buffer lives on the HEAP, not in .bss — 45 KB of
     * static data overflowed the ESP32-P4's internal SRAM (user build
     * 2026-08-17).  On that board a malloc this size is served from
     * PSRAM (the Arduino core routes big allocations there when PSRAM
     * is enabled); on OOM the view falls back to zoom 0. */
    static uint8_t *zbuf;
    if (!zbuf) zbuf = (uint8_t *)malloc(240 * 192);
    if (!zbuf) {
        draw_map_native(view_x, view_y, sel, blink);
        return;
    }
    int S = 1 << zoom;
    zoom_pass = 1;
    for (int j = 0; j < S; j++)
        for (int i = 0; i < S; i++) {
            draw_map_native(view_x + i * VIEW_COLS,
                            view_y + j * VIEW_ROWS, sel, blink);
            int qw = 240 / S, qh = 192 / S;
            int qx = i * qw, qy = j * qh;
            for (int y = 0; y < qh; y++) {
                const uint8_t *src =
                    RD.fb + (VP_Y + y * S) * RD_W + VP_X;
                uint8_t *dst = zbuf + (qy + y) * 240 + qx;
                for (int x = 0; x < qw; x++) dst[x] = src[x * S];
            }
        }
    zoom_pass = 0;
    draw_map_native(view_x, view_y, sel, blink);   /* the chrome pass */
    for (int y = 0; y < 192; y++)
        memcpy(RD.fb + (VP_Y + y) * RD_W + VP_X, zbuf + y * 240, 240);
}

void rm_draw_map(int view_x, int view_y, int sel, int blink) {
    rm_draw_map_zoom(view_x, view_y, sel, blink, 0);
}
