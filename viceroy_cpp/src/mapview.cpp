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

static int tid_at(const Map& m, int x, int y) {        // terrain id at (x,y), -1 off-map
    if (x < 0 || y < 0 || x >= m.w || y >= m.h) return -1;
    return m.tiles[y * m.w + x] & 0x1F;
}
static bool is_forest(int t)  { return t >= 8 && t < 24; }            // auto-forest range
static bool is_water(int t)   { return t == 0x19 || t == 0x1A; }      // Ocean / Sea-lane

// classify_terrain (lcall 0x181F:0x6AA): a tile's terrain id -> its TERRAIN.SS base
// frame (fold forest variants 8..0x17 -> 0..7, keep 0x18+). Used by the O512 blend.
static int classify_frame(int raw_id) {
    if (raw_id < 0) return -1;
    int base = (raw_id < 0x18) ? (raw_id & 7) : raw_id;
    return terrain_base_frame(base);
}

// O512 = func_067F50, the dithered terrain-edge BLEND composer (map_system.md §3
// deep-dive, RULINGS 2026-06-22). For each cardinal neighbour (N,E,S,W via DGROUP
// 4-dir tables 0xA8/0xAE) whose terrain class differs from the centre, dither the
// neighbour's terrain into this tile's edge through stencil 0x69+dir (sparse index-0
// dots = the mask written to 0x839E). Water neighbours of a LAND tile trigger the
// 8-ring walk (even 8-dir indices = the neighbour's own N/E/S/W) to the nearby land
// class -- the land-side coast dither. (Water centres skip the ring-walk; their coast
// is O513's shore 0x96 + 0x97 edges + 0x6D 8x8 quadrants.)
static void o512_blend(Surface& scr, const Sheet& terr, const Sheet& phys,
                       const Map& map, int mx, int my, int dx, int dy, int vis) {
    static const int D4X[4] = {0, 1, 0, -1};                 // N,E,S,W
    static const int D4Y[4] = {-1, 0, 1, 0};
    static const int D8X[8] = {0, 1, 1, 1, 0, -1, -1, -1};   // 8-dir ring
    static const int D8Y[8] = {-1, -1, 0, 1, 1, 1, 0, -1};
    bool center_water = is_water(vis);
    int center_frame = classify_frame(vis);
    for (int d = 0; d < 4; ++d) {
        int nid = tid_at(map, mx + D4X[d], my + D4Y[d]);
        if (nid < 0) continue;
        int nb_frame = classify_frame(nid);
        bool nb_water = is_water(nid);
        if (nb_water && !center_water) {                     // land-side coast ring walk
            int found = -1;
            for (int r = 0; r < 8; r += 2) {                 // neighbour's N,E,S,W
                int rid = tid_at(map, mx + D4X[d] + D8X[r], my + D4Y[d] + D8Y[r]);
                if (rid >= 0 && !is_water(rid)) { found = rid; break; }
            }
            if (found < 0) continue;
            nb_frame = classify_frame(found);
            nb_water = false;
        }
        if (nb_water || nb_frame < 0 || nb_frame >= (int)terr.nframes) continue;
        if (nb_frame == center_frame) continue;              // same biome -> no edge
        int sidx = 0x69 + d;                                 // dither stencil
        if (sidx >= (int)phys.nframes) continue;
        const Frame& st = phys.frames[sidx];
        const Frame& nb = terr.frames[nb_frame];
        for (int gy = 0; gy < st.h && gy < 16; ++gy)
            for (int gx = 0; gx < st.w && gx < 16; ++gx)
                if (st.px[gy * st.w + gx] == 0 && gx < nb.w && gy < nb.h) {  // dot
                    uint8_t np = nb.px[gy * nb.w + gx];
                    if (np != SS_TRANSPARENT) scr.put(dx + gx, dy + gy, np);
                }
    }
}

// Compose one 16x16 tile: TERRAIN.SS base ground + PHYS0 overlays, per the
// byte-verified per-tile dispatch (VICEROY_decompiled.named.c `tile_dispatch`).
// Neighbor masks follow nmask4_forest's bit order (N=8,S=4,W=2,E=1). `terr`=
// TERRAIN.SS, `phys`=PHYS0.SS. Forest/coast use the TERRAIN layer (the feature
// layer is empty in AMER2). mountains/hills(27/28) base is an R approximation.
static void terrain_compose(Surface& scr, const Sheet& terr, const Sheet& phys,
                            const Map& map, int mx, int my, int dx, int dy) {
    int vis = tid_at(map, mx, my);
    bool forested = is_forest(vis);

    int frame;
    if (is_water(vis)) {                         // Ocean / Sea-lane base
        frame = terrain_base_frame(vis);
    } else if (vis >= 0x18) {                    // Arctic(24)/Mountains(27)/Hills(28)
        frame = (vis == 27 || vis == 28) ? 2     // mtn/hills sit on a land base (R)
                                         : terrain_base_frame(vis);
    } else {                                     // land: strip forest -> base 0..7
        int land_base = vis & 7;
        if (land_base == 1 && !forested) land_base = 0x11;   // desert special (@45384)
        frame = terrain_base_frame(land_base);
    }
    if (frame < 0) frame = 0;
    if (frame >= terr.nframes) frame = terr.nframes - 1;
    scr.blit_frame(terr.frames[frame], dx, dy);              // opaque base ground

    // O512 dithered terrain-edge blend (neighbour biomes/coast stipple into the edge).
    o512_blend(scr, terr, phys, map, mx, my, dx, dy, vis);

    // 4-neighbor masks (N=8, S=4, W=2, E=1) -- nmask4_forest bit order.
    auto mask4 = [&](bool (*pred)(int)) {
        int m = 0;
        if (pred(tid_at(map, mx, my - 1))) m |= 8;
        if (pred(tid_at(map, mx, my + 1))) m |= 4;
        if (pred(tid_at(map, mx - 1, my))) m |= 2;
        if (pred(tid_at(map, mx + 1, my))) m |= 1;
        return m;
    };

    // Forest overlay: transition frame from the 0x40 band by forest-neighbor mask
    // (tile_dispatch: draw_tile_marker(0x41 + nmask4_forest()); the band is 64..79).
    // Biome-aware (colonize_sdl STEP 5, RULINGS 2026-05-19d "forest in the desert"):
    // bases 8/9/16/17/18/22 (boreal/scrub/ice + AMER2 extended) already encode their
    // biome texture (cacti/ice) in the base, so the generic GREEN canopy is suppressed.
    if (forested && vis != 8 && vis != 9 && vis != 16 && vis != 17 && vis != 18 && vis != 22) {
        int fmask = mask4(is_forest);
        int f = 0x40 + fmask;
        if (f < (int)phys.nframes) scr.blit_frame(phys.frames[f], dx, dy);
    }

    // River overlay (land tiles, terrain bit 0x20) -- the BLUE river band 0x01/0x11
    // (CLAUDE.md hard rule #4), drawn per func_0681A8 @0x6838A: base + 4-cardinal
    // river-neighbour mask (func_067b84, bit order N=8/S=4/W=2/E=1; isolated -> 0xf).
    // Base 0x01 (feature bit 0x80 / main trunk) vs 0x11 -- approximated here from the
    // forested terrain id (R: the exact feature-plane bit isn't in this terrain-only
    // Map). NOT the 0x51..0x5E ROAD band (brown, separate layer @0x6842B, empty on new
    // maps -- "no roads in new maps").
    uint8_t raw = map.tiles[my * map.w + mx];
    if ((raw & 0x20) && !is_water(vis)) {
        auto river_at = [&](int x, int y) {
            if (x < 0 || y < 0 || x >= map.w || y >= map.h) return false;
            return (map.tiles[y * map.w + x] & 0x20) != 0;
        };
        int rmask = 0;                                   // 4-cardinal: N=8,S=4,W=2,E=1
        if (river_at(mx, my - 1)) rmask |= 8;
        if (river_at(mx, my + 1)) rmask |= 4;
        if (river_at(mx - 1, my)) rmask |= 2;
        if (river_at(mx + 1, my)) rmask |= 1;
        if (rmask == 0) rmask = 0xf;                     // isolated -> full cross (@0x683BB)
        // major (forested river = main trunk, row 0x11) vs minor (row 0x01) -- RULINGS
        // 2026-05-19b: forest+river clusters on the main trunks. R approximation (the
        // exact major flag is a feature-plane bit not in this terrain-only Map).
        int base = is_forest(vis) ? 0x11 : 0x01;
        int f = base + rmask;
        if (f < (int)phys.nframes) scr.blit_frame(phys.frames[f], dx, dy);
    }

    // Coast -- the water-tile composition, byte-verified vs func_0681A8 +
    // analyse_connections (func_067A24), map_system.md §3 item 7 (corrected 2026-06-22;
    // RULINGS 2026-06-22). A WATER tile examines its 8 neighbours (clockwise from N,
    // exact DGROUP dx@0xB4/dy@0xBE order) and builds a LAND-neighbour bitmap [0xA8A6]
    // (water/off-map neighbours skipped). From it: a shore base 0x96, then EITHER one
    // 16x16 directional edge 0x97+pattern (clean land-bitmap patterns) OR -- the
    // complex-coastline fallback -- four 8x8 quadrant sub-tiles 0x6D + table[q]*4 + q.
    // This is NOT a road draw (the old "0x6D = roads" was a mislabel); 0x95 is the FOG
    // sprite, not coast.
    if (is_water(vis)) {
        // 8-direction offsets, exact DGROUP order: N,NE,E,SE,S,SW,W,NW.
        static const int D8X[8] = {0, 1, 1, 1, 0, -1, -1, -1};
        static const int D8Y[8] = {-1, -1, 0, 1, 1, 1, 0, -1};
        int land = 0;                            // [0xA8A6] land-neighbour bitmap (bit d)
        int qtab[4] = {0, 0, 0, 0};              // [0x2D24] per-quadrant land bitmask
        for (int d = 0; d < 8; ++d) {
            int nt = tid_at(map, mx + D8X[d], my + D8Y[d]);
            if (nt < 0 || is_water(nt)) continue;        // land neighbour only
            land |= (1 << d);
            if (d & 1) {                                  // diagonal -> one quadrant |= 2
                qtab[((d + 1) & 6) >> 1] |= 2;
            } else {                                      // cardinal -> two quadrants |=4/|=1
                int q1 = d >> 1, q2 = (q1 + 1) & 3;
                qtab[q1] |= 4;
                qtab[q2] |= 1;
            }
        }
        if (land) {                              // shore base 0x96 (R: approximates [0xA89F]&0x40)
            if (0x96 < (int)phys.nframes) scr.blit_frame(phys.frames[0x96], dx, dy);
            // Clean-edge land patterns -> a single 16x16 edge (@0x68479..0x6850D).
            int pat = -1;                        // sequential match, later pattern wins (as in EXE)
            if ((land & 0xDD) == 0xC1) pat = 0;
            if ((land & 0x77) == 0x07) pat = 1;
            if ((land & 0x77) == 0x70) pat = 2;
            if ((land & 0xDD) == 0x1C) pat = 3;
            if (pat >= 0) {
                int f = 0x97 + pat;
                if (f < (int)phys.nframes) scr.blit_frame(phys.frames[f], dx, dy);
            } else {
                // Complex coastline -> 4x 8x8 quadrant sub-tiles at TL/TR/BR/BL (@0x684BC).
                static const int QDX[4] = {0, 8, 8, 0};  // (((q+1)&3)&0x3E)<<2
                static const int QDY[4] = {0, 0, 8, 8};  // (q&0xFE)<<2
                for (int q = 0; q < 4; ++q) {
                    int f = 0x6D + qtab[q] * 4 + q;
                    if (f < 0 || f >= (int)phys.nframes) continue;
                    const Frame& sub = phys.frames[f];
                    // Sub-cell blit. These 8x8 frames carry index 0 (black); the all-0
                    // corner frames 109-111 must render as transparent (the ocean base is
                    // blue, the 16x16 coast frames use no index 0) -- so we skip BOTH 0 and
                    // 253 here. TBD: confirm the sub-cell blitter (0x181f:0x254) index-0 rule.
                    for (int gy = 0; gy < sub.h; ++gy)
                        for (int gx = 0; gx < sub.w; ++gx) {
                            uint8_t p = sub.px[gy * sub.w + gx];
                            if (p != SS_TRANSPARENT && p != 0)
                                scr.put(dx + QDX[q] + gx, dy + QDY[q] + gy, p);
                        }
                }
            }
        }
    }

    if (vis == 27 && (int)phys.nframes > 0x21) scr.blit_frame(phys.frames[0x21], dx, dy); // mountains
    if (vis == 28 && (int)phys.nframes > 0x31) scr.blit_frame(phys.frames[0x31], dx, dy); // hills
    // River (MP feature/resfog connectivity) stays a labeled TBD pending the
    // 3-layer .MP decode + func_O512 connectivity (AMER2 feature layer is empty).
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
