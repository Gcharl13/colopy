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
// river continuity mask (func_067B84(0x40,3)): 4 cardinal neighbours carrying the river
// bit 0x40; N=8,S=4,W=2,E=1; isolated -> 0xF (@0x683BB). NOT linked to open water -- the
// in-game river band does not connect to the sea.
static int river_nmask(const Map& m, int x, int y) {
    int k = 0;
    if (L1at(m, x, y - 1) & 0x40) k |= 8;
    if (L1at(m, x, y + 1) & 0x40) k |= 4;
    if (L1at(m, x - 1, y) & 0x40) k |= 2;
    if (L1at(m, x + 1, y) & 0x40) k |= 1;
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

// O512 terrain-edge blend (func_067F50): for each cardinal neighbour whose classified
// terrain differs and is LAND, dither its ground texture into the matching edge. The
// in-game mechanism is: the dither stencil writes index-0 holes, then emit_terrain
// backfills them with the neighbour's ground -- equivalently, draw the neighbour's
// ground at the stencil's index-0 dots. Stencils (my frames, = game 0x69+dir): dir 0..3
// = N,E,S,W -> 0x68/0x69/0x6A/0x6B with dots on the top/right/bottom/left edge (verified,
// docs/INGAME_MAP_RENDER_TRACE §6.1). Runs for BOTH land tiles (biome blend) and water
// tiles -- where a LAND neighbour dithers in as the BEACH HALO showing the real land
// terrain (sand for a desert coast, grass for a grass coast).
static int base_frame_of(uint8_t b);   // defined below (uses classify_vis/land_base_of)
static void blend_edges(Surface& scr, const Sheet& terr, const Sheet& phys,
                        const Map& map, int mx, int my, int dx, int dy) {
    static const int D4X[4] = {0, 1, 0, -1}, D4Y[4] = {-1, 0, 1, 0};   // N,E,S,W
    int cclass = classify_vis(map.tiles[my * map.w + mx]);
    for (int d = 0; d < 4; ++d) {
        int nx = mx + D4X[d], ny = my + D4Y[d];
        if (nx < 0 || ny < 0 || nx >= map.w || ny >= map.h) continue;
        uint8_t nb = map.tiles[ny * map.w + nx];
        int nclass = classify_vis(nb);
        if (is_water(nclass)) continue;                     // water neighbour -> no dither
        if (nclass == cclass) continue;                     // same biome -> no edge
        int nf = base_frame_of(nb);                         // neighbour ground frame
        int sidx = 0x68 + d;                                // stencil N/E/S/W
        if (nf < 0 || nf >= (int)terr.nframes || sidx >= (int)phys.nframes) continue;
        const Frame& st = phys.frames[sidx];
        const Frame& nbf = terr.frames[nf];
        for (int gy = 0; gy < st.h && gy < 16; ++gy)
            for (int gx = 0; gx < st.w && gx < 16; ++gx)
                if (st.px[gy * st.w + gx] == 0 && gx < nbf.w && gy < nbf.h) {   // stencil hole
                    uint8_t p = nbf.px[gy * nbf.w + gx];
                    if (p != SS_TRANSPARENT) scr.put(dx + gx, dy + gy, p);
                }
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

// Draw a PHYS0 coast sub-tile AS-IS over the ocean base: the sprite's blue shallows
// and green/sand shore draw straight from the sheet; index 0 (the sprite's deep-water
// cutout) and 253 are keyed so the ocean ground base painted by draw_ground shows
// through. This is the in-game blit model -- emit_terrain_sprite backfills the index-0
// holes with the WATER id (ocean), NOT the nearest land (docs/INGAME_MAP_RENDER_TRACE
// §3). No neighbour-terrain invention. (ox,oy) = the sub-tile's offset in the 16x16 tile.
static void blit_subtile(Surface& scr, const Frame& fr, int dx, int dy, int ox, int oy) {
    for (int gy = 0; gy < fr.h; ++gy)
        for (int gx = 0; gx < fr.w; ++gx) {
            uint8_t p = fr.px[gy * fr.w + gx];
            if (p == 0 || p == SS_TRANSPARENT) continue;     // deep-water cutout -> ocean base
            scr.put(dx + ox + gx, dy + oy + gy, p);
        }
}

// compose_coast (O513 step 10 = analyse_connections, WATER tiles only). Build the
// 8-neighbour land bitmap `conn` + the per-quadrant land mask `cfg[q]` (0..7: diagonal
// corner |=2, the two flanking cardinals |=4/|=1), then SELECT and draw PHYS0 coast
// sprites AS-IS over the ocean base -- pure sprite selection, exactly the in-game
// formula (no nearest-land fill):
//   - clean edge pattern -> one 16x16 diagonal beach, frame 0x96+pattern (150..153);
//   - else 4 quadrant 8x8 sub-tiles, frame 0x6C + cfg[q]*4 + q (108..139; cfg=0 -> the
//     blank 108..111 = open ocean in that quadrant).
static void compose_coast(Surface& scr, const Sheet& phys,
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
    int pattern = -1;
    if ((conn & 0xDD) == 0xC1) pattern = 0;                  // clean NW-corner diagonal
    if ((conn & 0x77) == 0x07) pattern = 1;                  // NE
    if ((conn & 0x77) == 0x70) pattern = 2;                  // SW
    if ((conn & 0xDD) == 0x1C) pattern = 3;                  // SE
    if (pattern >= 0) {
        int f = 0x96 + pattern;                              // 150..153 diagonal beach edges
        if (f < (int)phys.nframes) blit_subtile(scr, phys.frames[f], dx, dy, 0, 0);
        return;
    }
    static const int qx[4] = {0, 8, 8, 0}, qy[4] = {0, 0, 8, 8};   // NW,NE,SE,SW
    for (int q = 0; q < 4; ++q) {
        int f = 0x6C + cfg[q] * 4 + q;                       // 108 + table[q]*4 + q
        if (f >= 0 && f < (int)phys.nframes) blit_subtile(scr, phys.frames[f], dx, dy, qx[q], qy[q]);
    }
}

// Neighbour-aware tile composition (port of sprite_draw_map_tile = the O513/O512 stack).
static void terrain_compose(Surface& scr, const Sheet& terr, const Sheet& phys,
                            const Map& map, int mx, int my, int dx, int dy) {
    uint8_t b = map.tiles[my * map.w + mx];
    int id = b & 0x1F;
    int vis = classify_vis(b);

    draw_ground(scr, terr, b, dx, dy);                       // 1. base ground (emit_ground)

    if (is_water(id)) {                                      // 10. coast (water tiles), done
        compose_coast(scr, phys, map, mx, my, dx, dy);
        return;
    }
    blend_edges(scr, terr, phys, map, mx, my, dx, dy);       // 2. O512 land biome blend
    // 4. forest canopy (visible band 8..0x17, EXCEPT Desert/Scrub land_base==1): 0x41+mask.
    if (vis >= 8 && vis < 0x18 && land_base_of(b) != 1) {
        int f = 0x40 + forest_nmask(map, mx, my);            // my 0x40 = game 0x41
        if (f < (int)phys.nframes) scr.blit_frame(phys.frames[f], dx, dy);
    }
    // 7. river band (bit 0x40): base (bit 0x80 ? 0x00 : 0x10) + 4-cardinal river mask.
    if (b & 0x40) {
        int f = ((b & 0x80) ? 0x00 : 0x10) + river_nmask(map, mx, my);   // game 0x01/0x11
        if (f < (int)phys.nframes) scr.blit_frame(phys.frames[f], dx, dy);
    }
    // 6. hills / mountains (bit 0x20; bit 0x80 = mountain) + same-class mask.
    if (b & 0x20) {
        int base = (b & 0x80) ? 0x20 : 0x30;
        int f = base + feat_hi_nmask(map, mx, my);
        if (f < (int)phys.nframes) scr.blit_frame(phys.frames[f], dx, dy);
    }
}

void render_mapview(Surface& scr, const Map& map, const Sheet& terrain,
                    const Sheet& tiles, const Sheet& woodtile,
                    const Sheet& font, const vc::sim::GameState& g,
                    const vc::sim::World& w, int ox, int oy) {
    (void)w;  // colonies are not yet placed on the map (no owner-dots / unit panel)

    // --- Background: WOODTILE.SS (32x24) tiled across the chrome (menu bar +
    //     sidebar), per the in-game wood fill. Tiled over the whole screen; the
    //     map viewport is painted with terrain on top. ------------------------
    if (woodtile.nframes > 0) {
        const Frame& wt = woodtile.frames[0];
        if (wt.w > 0 && wt.h > 0)
            for (int y = 0; y < Surface::H; y += wt.h)
                for (int x = 0; x < Surface::W; x += wt.w)
                    scr.blit_frame(wt, x, y);
    }

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
    // Per-tile colour = the in-game minimap table (TERRAIN_PAL_INDEX -> VICEROY.PAL,
    // resolved to the nearest PHYS0 palette index; func_066CD6 blits a pre-rendered
    // bitmap built from this table). docs/INGAME_MAP_RENDER_TRACE §6.3.
    static const uint8_t MM_COLOR[27] = {
        7, 88, 72, 80, 67, 66, 68, 70, 7, 88, 72, 80, 67, 66, 68, 70,
        20, 67, 7, 67, 67, 66, 68, 67, 0, 60, 124 };
    for (int my = 0; my < MM_H; ++my) {
        for (int mx = 0; mx < MM_W; ++mx) {
            int tx = map.w ? mx * map.w / MM_W : 0;
            int ty = map.h ? my * map.h / MM_H : 0;
            int id = map.tiles[ty * map.w + tx] & 0x1F;
            scr.put(MM_X + mx, MM_Y + my, id < 27 ? MM_COLOR[id] : 0);
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
