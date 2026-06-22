// mapview.cpp -- the main map-view screen compositor, built strictly from
// spec/ui/map_view.md. NOTHING here is invented; each element below cites its
// spec source + confidence tier.
//
// ELEMENT -> SPEC CITATION (map_view.md):
//   Background wood    WOODPANL.PIK (§3 "Sidebar bg: WOODPANL.PIK")            A
//   Menu strip         (0,0,320,9) FONTTINY green idx68; MENU ~titles (§2,§3)  B mech / R x-pos
//   Map viewport       (0,8,240,192) 15x12@16, TERRAIN.SS base + PHYS0 overlays   B (forest/river/coast);
//                      forest 0x40 band; river 0x51/0x52; COAST = water-tile        coast shore=0x96 +
//                      composition (shore 0x96 + 16x16 edge 0x97+pat OR 8x8          0x97+pat / 0x6D 8x8
//                      quadrant sub-tiles 0x6D+table[q]*4+q), map_system.md §3       (RULINGS 2026-06-22)
//   Minimap            (241,8,79,41) func_066CD6; white viewport rect idx0x0F  B geom
//   Sidebar B text     season(244,58)/gold(244,66)/tax(290,66) FONTTINY white  R (frame 1310262984, §6.3)
//   Sidebar C          selected-unit panel -- BLANK (no unit selected): the
//                      sim World has no map units yet, so nothing is drawn here
//                      (honest empty state, not a fabricated panel).
#include "mapview.hpp"
#include <string>

namespace vc {

// Palette indices, valid under PHYS0's embedded palette -- the single active
// map-view palette (resolved from evidence: the gameplay screen uses PHYS0's
// terrain palette, which WOODPANL/ICONS/fonts all share within ~2 indices; it
// differs from the 4-byte-per-entry VICEROY.PAL in 197/256 entries).
// map_view.md / fonts_and_colors.md:
static constexpr uint8_t COL_MENU_GREEN = 68;   // menu titles, ui_color_for(0x52,0x8A,0x31)
static constexpr uint8_t COL_WHITE      = 15;   // 0x0F sidebar text + minimap viewport rect

// Map-view geometry (map_view.md §2, tier A pixel-measured):
static constexpr int VP_X = 0,   VP_Y = 8,  VP_W = 240, VP_H = 192;  // viewport
static constexpr int TILE = 16,  VP_COLS = 15, VP_ROWS = 12;
static constexpr int MM_X = 241, MM_Y = 8,  MM_W = 79,  MM_H = 41;   // minimap (func_066CD6)

// terrain_cell_transform (VICEROY_decompiled.named.c @18195): terrain code ->
// TERRAIN.SS base-ground frame index.
static int terrain_base_frame(int code) {
    if (code == 0x11 || code == 0x09) return 8;
    if (code >= 8) return code - 0xF;
    return code;
}

// ===== Ported from mapedit_modern/src/sprites.c (the working modern map-editor
// renderer, branch claude/clever-franklin-kx8gse). L1 terrain byte: bits 0-4 base
// id (8..23 forest variants), 0x20 = hills/mountains, 0x40 = river, 0x80 = mountain
// (vs hill). The feature/resfog planes are empty on stock .MP, so every "feature"
// read is the L1 byte's high bits. =====

static uint8_t L1at(const Map& m, int x, int y) {       // L1 byte, off-map = 0
    if (x < 0 || y < 0 || x >= m.w || y >= m.h) return 0;
    return m.tiles[y * m.w + x];
}
static bool is_water(int id) { return id == 0x19 || id == 0x1A; }    // Ocean / Sea-lane
static bool water_at(const Map& m, int x, int y) {      // off-map counts as sea
    if (x < 0 || y < 0 || x >= m.w || y >= m.h) return true;
    return is_water(m.tiles[y * m.w + x] & 0x1F);
}
// L3 resfog class at (x,y): 1 = open ocean, 2+ = inland lake/land region. Off-map or
// no-L3 -> 1 (treat as ocean). Distinguishes ocean coasts (sand beach) from lake shores.
static int resfog_at(const Map& m, int x, int y) {
    if (m.resfog.empty() || x < 0 || y < 0 || x >= m.w || y >= m.h) return 1;
    return m.resfog[y * m.w + x];
}
static bool is_ocean_tile(const Map& m, int x, int y) { return resfog_at(m, x, y) == 1; }
// Remap a green "grassy shore" pixel to beach sand (ocean coasts), preserving brightness;
// water/sand pixels pass through. Sand indices 88/89/111 = dark/mid/light beach sand.
static uint8_t shore_to_sand(uint8_t p, const uint8_t* pal) {
    int r = pal[p * 3], g = pal[p * 3 + 1], b = pal[p * 3 + 2];
    if (g > r + 5 && g > b + 5) {                       // a green land pixel
        int lum = (r + g + b) / 3;
        return lum > 130 ? 111 : (lum > 90 ? 89 : 88);
    }
    return p;
}
// a water-blue palette pixel (so the blend can avoid dithering Marsh/Swamp water onto land).
static bool is_water_px(uint8_t p, const uint8_t* pal) {
    int r = pal[p * 3], g = pal[p * 3 + 1], b = pal[p * 3 + 2];
    return b > r && b > g && b > 90;
}
// classify_terrain (func_006204, map view): id&0x1F; fold forest 8..0x17 -> (id&7)|8.
static int classify_vis(uint8_t b) {
    int id = b & 0x1F;
    if (id >= 8 && id < 0x18) return (id & 7) | 8;
    if (id == 25) return 0x19;
    if (id == 26) return 0x1A;
    return id;
}
// O513 base-ground id (6b): land_base = vis<0x18 ? vis&7 : vis, Desert group -> 0x11.
static int land_base_of(uint8_t id) {
    int vis = id & 0x1F;
    bool forested = (vis >= 8 && vis < 0x18);
    int lb = (vis < 0x18) ? (vis & 7) : vis;
    if (lb == 1 && !forested) lb = 0x11;
    return lb;
}
// forest_neighbour (func_067C54): forest iff base>=0x18, or 8..0x17 with (b&7)!=1.
static bool forest_neighbour(const Map& m, int x, int y) {
    int b = L1at(m, x, y) & 0x1F;
    if (b >= 0x18) return true;
    if ((b & 7) == 1) return false;
    return b > 7;
}
static int forest_nmask(const Map& m, int x, int y) {            // N=8,S=4,W=2,E=1
    int k = 0;
    if (forest_neighbour(m, x, y - 1)) k |= 8;
    if (forest_neighbour(m, x, y + 1)) k |= 4;
    if (forest_neighbour(m, x - 1, y)) k |= 2;
    if (forest_neighbour(m, x + 1, y)) k |= 1;
    return k;
}
// river continuity: a cardinal continues the river if the neighbour carries the
// river bit 0x40 OR is open water (the river MOUTH flows into the sea / a lake).
static bool river_link(const Map& m, int x, int y) {
    uint8_t b = L1at(m, x, y);
    return (b & 0x40) || is_water(b & 0x1F);
}
static int river_nmask(const Map& m, int x, int y) {            // N=8,S=4,W=2,E=1; isolated->0xF
    int k = 0;
    if (river_link(m, x, y - 1)) k |= 8;
    if (river_link(m, x, y + 1)) k |= 4;
    if (river_link(m, x - 1, y)) k |= 2;
    if (river_link(m, x + 1, y)) k |= 1;
    return k ? k : 0x0F;
}
static int feat_hi_nmask(const Map& m, int x, int y) {         // (nb&0xA0)==self_hi
    int self_hi = L1at(m, x, y) & 0xA0, k = 0;
    if ((L1at(m, x, y - 1) & 0xA0) == self_hi) k |= 8;
    if ((L1at(m, x, y + 1) & 0xA0) == self_hi) k |= 4;
    if ((L1at(m, x - 1, y) & 0xA0) == self_hi) k |= 2;
    if ((L1at(m, x + 1, y) & 0xA0) == self_hi) k |= 1;
    return k;
}

// O512 land-biome edge dither (func_067F50 main path, land centres): for each cardinal
// LAND neighbour whose base biome differs, dither the neighbour's TERRAIN.SS texture
// into this tile's edge through the dither stencil 0x69+dir (index-0 dots = the 0x839E
// mask). This is the soft biome transition DOS draws between adjacent land terrains;
// land/water edges are the coast (compose_coast), not this. map_system.md §3, RULINGS.
static void blend_land_edges(Surface& scr, const Sheet& terr, const Sheet& phys,
                             const Map& map, int mx, int my, int dx, int dy, uint8_t cb) {
    // The dither stencils are 16x16 EDGE strips: 0x69 = East (right cols), 0x6A =
    // South (bottom rows), 0x6B = West (left cols) -- 3px deep, index-0 dots. There
    // is no North strip; the N boundary is dithered by the north neighbour's S edge.
    struct Edge { int dx, dy, st; };
    static const Edge edges[3] = {{1, 0, 0x69}, {0, 1, 0x6A}, {-1, 0, 0x6B}};   // E,S,W
    int cbase = land_base_of(cb);
    for (const Edge& e : edges) {
        int nx = mx + e.dx, ny = my + e.dy;
        if (nx < 0 || ny < 0 || nx >= map.w || ny >= map.h) continue;
        uint8_t nb = map.tiles[ny * map.w + nx];
        if (is_water(nb & 0x1F)) continue;                  // coast, not biome blend
        int nbase = land_base_of(nb);
        if (nbase == cbase) continue;                       // same biome -> no edge
        int nf = terrain_base_frame(nbase);
        if (nf < 0 || nf >= (int)terr.nframes || e.st >= (int)phys.nframes) continue;
        const Frame& st = phys.frames[e.st];                // 16x16 edge strip
        const Frame& nbf = terr.frames[nf];
        for (int gy = 0; gy < st.h && gy < 16; ++gy)
            for (int gx = 0; gx < st.w && gx < 16; ++gx)
                if (st.px[gy * st.w + gx] == 0 && gx < nbf.w && gy < nbf.h) {   // dot
                    uint8_t p = nbf.px[gy * nbf.w + gx];
                    // dither the neighbour's LAND texture only -- never its water-blue
                    // pixels (Marsh/Swamp), which would read as water on the land side.
                    if (p != SS_TRANSPARENT && !is_water_px(p, terr.pal)) scr.put(dx + gx, dy + gy, p);
                }
    }
}

// blit a PHYS0/TERRAIN frame with a black colour-key (index 0 AND 253 transparent) --
// the coast sub-tiles (row 0x70) use index-0 black as the "ocean shows here" key.
static void blit_key(Surface& scr, const Frame& fr, int dx, int dy) {
    for (int gy = 0; gy < fr.h; ++gy)
        for (int gx = 0; gx < fr.w; ++gx) {
            uint8_t p = fr.px[gy * fr.w + gx];
            if (p != SS_TRANSPARENT && p != 0) scr.put(dx + gx, dy + gy, p);
        }
}

// Base TERRAIN.SS frame for a tile. Scrub / forested-desert (classified id 9 --
// terrain_cell_transform's 0x09/0x11 -> 8 special case) uses the brush/cacti frame 8,
// distinct from plain Desert's frame 1; everything else folds to its land base.
static int base_frame_of(uint8_t b) {
    if (classify_vis(b) == 9) return 8;          // Scrub (brush forest / forested desert)
    if ((b & 0x1F) == 1) return 1;               // plain Desert -> bare sand (not 0x11->8)
    return terrain_base_frame(land_base_of(b));
}

// draw_ground (6b): fill the terrain's flat colour then blit its TERRAIN.SS texture
// (so transparent gaps in the texture show the biome colour, not black).
static void draw_ground(Surface& scr, const Sheet& terr, uint8_t b, int dx, int dy) {
    int bf = base_frame_of(b);
    if (bf < 0 || bf >= (int)terr.nframes) return;
    const Frame& f = terr.frames[bf];
    if (f.w > 0 && f.h > 0) {
        uint8_t c = f.px[(f.h / 2) * f.w + f.w / 2];     // sampled base colour index
        scr.fill_rect(dx, dy, 16, 16, c == SS_TRANSPARENT ? 0 : c);
    }
    scr.blit_frame(f, dx, dy);
}

// "black -> nearest terrain": for an index-0 (black key) pixel of a coast sub-tile at
// tile-local (gx,gy), return the terrain of the nearest CARDINAL neighbour (land tile ->
// its ground, water tile -> ocean), sampled at (gx,gy). So the land-facing key pixels of
// the coast show land, not deep ocean.
static uint8_t nearest_terrain_px(const Sheet& terr, const Map& map, int tx, int ty, int gx, int gy) {
    int m = gy, nx = tx, ny = ty - 1;                   // nearest of top/bottom/left/right edge
    if (15 - gy < m) { m = 15 - gy; nx = tx; ny = ty + 1; }
    if (gx < m)      { m = gx;      nx = tx - 1; ny = ty; }
    if (15 - gx < m) { m = 15 - gx; nx = tx + 1; ny = ty; }
    uint8_t nb = (nx < 0 || ny < 0 || nx >= map.w || ny >= map.h) ? 0x19 : map.tiles[ny * map.w + nx];
    int bf = is_water(nb & 0x1F) ? terrain_base_frame(0x19) : base_frame_of(nb);
    if (bf >= 0 && bf < (int)terr.nframes) {
        const Frame& f = terr.frames[bf];
        if (gx < f.w && gy < f.h) { uint8_t p = f.px[gy * f.w + gx]; if (p != SS_TRANSPARENT) return p; }
    }
    return 59;
}

// compose_coast (func_067F50 / MAPEDIT 0xBC1E): WATER-tile only. Walk the 8 neighbours;
// each LAND neighbour contributes to a 3-bit per-quadrant config (cardinal -> bit2 in
// its quadrant + bit0 in the next; diagonal -> bit1). Clean diagonal patterns draw the
// adjacent land's ground + the full-tile beach 0x96+pattern; otherwise 4 quadrant 8x8
// sub-tiles PHYS0 0x6C + config*4 + q (config 0 = black null-pad -> open ocean).
static void compose_coast(Surface& scr, const Sheet& terr, const Sheet& phys,
                          const Map& map, int tx, int ty, int dx, int dy) {
    static const int CDX[8] = {0, 1, 1, 1, 0, -1, -1, -1};   // N,NE,E,SE,S,SW,W,NW
    static const int CDY[8] = {-1, -1, 0, 1, 1, 1, 0, -1};
    uint8_t cfg[4] = {0, 0, 0, 0};
    int conn = 0;
    for (int dir = 0; dir < 8; ++dir) {
        if (water_at(map, tx + CDX[dir], ty + CDY[dir])) continue;
        conn |= (1 << dir);
        if (dir & 1) cfg[((dir + 1) & 6) >> 1] |= 2;
        else { cfg[dir >> 1] |= 4; cfg[((dir >> 1) + 1) & 3] |= 1; }
    }
    if (!conn) return;                                       // open ocean
    // 1-tile lake = water enclosed on all 4 CARDINALS by land (conn bits N0/E2/S4/W6
    // = 0x55). The 0x6C+cfg sub-tiles are transparent at the outer corners, so the
    // ocean base shows on the coast side ("water on the coast side"). Render it as a
    // pond: surrounding land at the edges (transparent shows the land base) + lake
    // water in the centre (the sub-tiles' index-0 key, drawn as water not ocean base).
    if ((conn & 0x55) == 0x55) {
        static const int c4dx[4] = {0, 1, 0, -1}, c4dy[4] = {-1, 0, 1, 0};
        int nb = -1;
        for (int k = 0; k < 4; ++k)
            if (!water_at(map, tx + c4dx[k], ty + c4dy[k]))
                nb = map.tiles[(ty + c4dy[k]) * map.w + (tx + c4dx[k])] & 0x1F;
        if (nb >= 0) draw_ground(scr, terr, (uint8_t)nb, dx, dy);
        uint8_t wat = 59;                                    // lake-water palette index
        int of = terrain_base_frame(0x19);
        if (of >= 0 && of < (int)terr.nframes) {
            const Frame& o = terr.frames[of];
            if (o.w > 0 && o.h > 0) {
                uint8_t c = o.px[(o.h / 2) * o.w + o.w / 2];
                if (c != SS_TRANSPARENT) wat = c;
            }
        }
        static const int lqx[4] = {0, 8, 8, 0}, lqy[4] = {0, 0, 8, 8};
        for (int q = 0; q < 4; ++q) {
            int f = 0x6C + cfg[q] * 4 + q;                    // per-quadrant sub-tile
            if (f < 0 || f >= (int)phys.nframes) continue;
            const Frame& sub = phys.frames[f];
            for (int gy = 0; gy < sub.h; ++gy)
                for (int gx = 0; gx < sub.w; ++gx) {
                    uint8_t p = sub.px[gy * sub.w + gx];
                    if (p == SS_TRANSPARENT) continue;        // land base shows (coast)
                    scr.put(dx + lqx[q] + gx, dy + lqy[q] + gy, p == 0 ? wat : p);
                }
        }
        return;
    }
    int pattern = -1;
    if ((conn & 0xDD) == 0xC1) pattern = 0;                  // land in NW corner
    if ((conn & 0x77) == 0x07) pattern = 1;                  // NE
    if ((conn & 0x77) == 0x70) pattern = 2;                  // SW
    if ((conn & 0xDD) == 0x1C) pattern = 3;                  // SE
    if (pattern >= 0) {
        static const int c4dx[4] = {0, 1, 0, -1}, c4dy[4] = {-1, 0, 1, 0};
        int nb = -1;
        for (int k = 0; k < 4; ++k)
            if (!water_at(map, tx + c4dx[k], ty + c4dy[k]))
                nb = map.tiles[(ty + c4dy[k]) * map.w + (tx + c4dx[k])] & 0x1F;
        if (nb >= 0) draw_ground(scr, terr, (uint8_t)nb, dx, dy);
        int f = 0x96 + pattern;
        if (f < (int)phys.nframes) blit_key(scr, phys.frames[f], dx, dy);
        return;
    }
    static const int qx[4] = {0, 8, 8, 0}, qy[4] = {0, 0, 8, 8};   // NW,NE,SE,SW
    // Per sub-tile pixel: index-0 (black key) -> NEAREST TERRAIN (land-facing key shows
    // land, ocean-facing shows ocean); the grassy shore -> SAND on an ocean coast (L3==1),
    // kept green on a lake; the sub-tile's own water band is kept. 253 -> ocean base.
    bool ocean = is_ocean_tile(map, tx, ty);
    for (int q = 0; q < 4; ++q) {
        int f = 0x6C + cfg[q] * 4 + q;
        if (f < 0 || f >= (int)phys.nframes) continue;
        const Frame& sub = phys.frames[f];
        for (int gy = 0; gy < sub.h; ++gy)
            for (int gx = 0; gx < sub.w; ++gx) {
                uint8_t p = sub.px[gy * sub.w + gx];
                int TX = qx[q] + gx, TY = qy[q] + gy;            // tile-local 0..15
                if (p == SS_TRANSPARENT) continue;               // -> ocean base
                uint8_t out = (p == 0) ? nearest_terrain_px(terr, map, tx, ty, TX, TY)
                            : (ocean ? shore_to_sand(p, phys.pal) : p);
                scr.put(dx + TX, dy + TY, out);
            }
    }
}

// Neighbour-aware tile composition (port of sprite_draw_map_tile = the O513/O512 stack).
static void terrain_compose(Surface& scr, const Sheet& terr, const Sheet& phys,
                            const Map& map, int mx, int my, int dx, int dy) {
    uint8_t b = map.tiles[my * map.w + mx];
    int id = b & 0x1F;
    int vis = classify_vis(b);

    draw_ground(scr, terr, b, dx, dy);                       // 6b base ground

    if (is_water(id)) {                                      // water -> coast, done
        compose_coast(scr, terr, phys, map, mx, my, dx, dy);
        return;
    }
    blend_land_edges(scr, terr, phys, map, mx, my, dx, dy, b);   // soft biome transitions

    // 6c forest canopy (visible band 8..0x17, EXCEPT the Desert/Scrub land_base==1).
    if (vis >= 8 && vis < 0x18 && land_base_of(b) != 1) {
        int f = 0x40 + forest_nmask(map, mx, my);
        if (f < (int)phys.nframes) scr.blit_frame(phys.frames[f], dx, dy);
    }
    // 6d river-on-terrain (bit 0x40): PHYS0 river row 0x00 + continuity mask.
    if (b & 0x40) {
        int f = 0x00 + river_nmask(map, mx, my);
        if (f < (int)phys.nframes) scr.blit_frame(phys.frames[f], dx, dy);
    }
    // 6e hills / mountains (bit 0x20; bit 0x80 = mountain) + same-class mask.
    if (b & 0x20) {
        int base = (b & 0x80) ? 0x20 : 0x30;
        int f = base + feat_hi_nmask(map, mx, my);
        if (f < (int)phys.nframes) scr.blit_frame(phys.frames[f], dx, dy);
    }
}

// Sample a base-terrain frame's representative (center) color index for the minimap.
static uint8_t tile_color(const Sheet& terr, uint8_t raw) {
    int vis = raw & 0x1F;
    int frame = (vis == 0x19 || vis == 0x1A) ? terrain_base_frame(vis)
              : (vis >= 0x18 ? terrain_base_frame(vis < 27 ? vis : 2)
                             : terrain_base_frame(vis & 7));
    if (frame < 0 || frame >= terr.nframes) return 0;
    const Frame& f = terr.frames[frame];
    if (f.w <= 0 || f.h <= 0) return 0;
    uint8_t c = f.px[(f.h / 2) * f.w + (f.w / 2)];
    return c == SS_TRANSPARENT ? 0 : c;
}

void render_mapview(Surface& scr, const Map& map, const Sheet& terrain,
                    const Sheet& tiles, const IndexedPng& woodpanl,
                    const Sheet& font, const vc::sim::GameState& g,
                    const vc::sim::World& w, int ox, int oy) {
    (void)w;  // colonies are not yet placed on the map (no owner-dots / unit panel)

    // --- Background: WOODPANL wood (menu strip + sidebar). ------------------
    scr.blit_region(woodpanl, 0, 0, Surface::W, Surface::H, 0, 0);

    // --- Map viewport (0,8,240,192): 15x12 tiles @16px, layered terrain
    //     composition (TERRAIN.SS base ground + PHYS0 overlays), map_view.md §2. -
    for (int row = 0; row < VP_ROWS; ++row) {
        for (int col = 0; col < VP_COLS; ++col) {
            int mx = ox + col, my = oy + row;
            if (mx < 0 || my < 0 || mx >= map.w || my >= map.h) continue;
            terrain_compose(scr, terrain, tiles, map, mx, my, VP_X + col * TILE, VP_Y + row * TILE);
        }
    }

    // --- Minimap (241,8,79,41): whole map squashed in; current view = white rect.
    for (int my = 0; my < MM_H; ++my) {
        for (int mx = 0; mx < MM_W; ++mx) {
            int tx = map.w ? mx * map.w / MM_W : 0;
            int ty = map.h ? my * map.h / MM_H : 0;
            uint8_t b = map.tiles[ty * map.w + tx];
            scr.put(MM_X + mx, MM_Y + my, tile_color(terrain, b));
        }
    }
    if (map.w && map.h) {                                  // white viewport rectangle (idx 0x0F)
        int rx = MM_X + ox * MM_W / map.w;
        int ry = MM_Y + oy * MM_H / map.h;
        int rw = VP_COLS * MM_W / map.w;
        int rh = VP_ROWS * MM_H / map.h;
        scr.rect_outline(rx, ry, rw > 1 ? rw : 2, rh > 1 ? rh : 2, COL_WHITE);
    }

    // --- Menu strip (0,0,320,9): MENU ~titles, FONTTINY green, left->right
    //     (mechanism B; item x-positions R per §6.4 glyph-grid). ---------------
    static const char* MENU[]  = {"GAME","VIEW","ORDERS","REPORTS","TRADE","CHEAT","COLONIZOPEDIA"};
    static const int    MENU_X[] = {6, 44, 82, 132, 188, 226, 258};   // spread x-origins (R, §6.4)
    for (int i = 0; i < 7; ++i)
        scr.draw_text(font, MENU_X[i], 1, MENU[i], COL_MENU_GREEN);

    // --- Sidebar B (240,72,80,64): season / gold / tax, FONTTINY white, at the
    //     R coords pixel-measured from frame 1310262984 (map_view.md §6.3). -----
    const char* season = (g.season == 0) ? "Spring" : "Autumn";   // NAMES @SEASONS
    scr.draw_text(font, 244, 58, std::string(season) + " " + std::to_string(g.year), COL_WHITE);
    scr.draw_text(font, 244, 66, "Gold: " + std::to_string((long long)g.powers[0].gold), COL_WHITE);
    scr.draw_text(font, 290, 66, "Tax: " + std::to_string(g.powers[0].tax) + "%", COL_WHITE);

    // Sidebar C (240,136,80,64): intentionally left as the wood panel -- no map
    // unit is selected (the headless World has no units yet), so drawing a unit
    // panel here would be fabrication. Honest empty state.
}

} // namespace vc
