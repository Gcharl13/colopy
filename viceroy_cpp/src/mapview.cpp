// mapview.cpp -- the main map-view screen compositor, built strictly from
// spec/ui/map_view.md. NOTHING here is invented; each element below cites its
// spec source + confidence tier.
//
// ELEMENT -> SPEC CITATION (map_view.md):
//   Background wood    WOODPANL.PIK (§3 "Sidebar bg: WOODPANL.PIK")            A
//   Menu strip         (0,0,320,9) FONTTINY green idx68; MENU ~titles (§2,§3)  B mech / R x-pos
//   Map viewport       (0,8,240,192) 15x12@16, terrain_id->sprite (§2,§6.2)    B (naive; sub-cell chain deferred)
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
    if (forested) {
        int fmask = mask4(is_forest);
        int f = 0x40 + fmask;
        if (f < (int)phys.nframes) scr.blit_frame(phys.frames[f], dx, dy);
    }

    // River overlay (land tiles, terrain bit 0x20). Per tile_dispatch: isolated =
    // 0x51; else for each connected DIR8 direction draw 0x52+dir (river segments
    // stack into a path). River-neighbor = adjacent tile also has bit 0x20.
    uint8_t raw = map.tiles[my * map.w + mx];
    if ((raw & 0x20) && !is_water(vis)) {
        static const int D8X[8] = {0, 1, 1, 1, 0, -1, -1, -1};   // DIR8 (N,NE,E,SE,S,SW,W,NW)
        static const int D8Y[8] = {-1, -1, 0, 1, 1, 1, 0, -1};
        int rmask = 0;
        for (int i = 0; i < 8; ++i) {
            int nx = mx + D8X[i], ny = my + D8Y[i];
            if (nx >= 0 && ny >= 0 && nx < map.w && ny < map.h &&
                (map.tiles[ny * map.w + nx] & 0x20)) rmask |= (1 << i);
        }
        if (rmask == 0) {
            if (0x51 < (int)phys.nframes) scr.blit_frame(phys.frames[0x51], dx, dy);
        } else {
            for (int i = 0; i < 8; ++i)
                if ((rmask & (1 << i)) && (0x52 + i) < (int)phys.nframes)
                    scr.blit_frame(phys.frames[0x52 + i], dx, dy);
        }
    }

    // Coast -- the byte-verified composer (tile_compose_subcells / func_067F50,
    // map_system.md §1b): for a WATER tile, each cardinal direction (DIR4 = N,E,S,W)
    // whose neighbour is LAND draws the per-direction stipple frame 0x69+dir AND
    // emit_terrain_sprite(neighbour) -- i.e. the neighbour's LAND terrain stamped at
    // the stipple-mask positions, a dithered shoreline. (0x95 is the PLOW, not coast;
    // 105-108 carry only transparent + index-0, so they are masks, not drawable.)
    if (is_water(vis)) {
        static const int D4X[4] = {0, 1, 0, -1};   // DIR4_DX (N,E,S,W)
        static const int D4Y[4] = {-1, 0, 1, 0};   // DIR4_DY
        for (int d = 0; d < 4; ++d) {
            int nt = tid_at(map, mx + D4X[d], my + D4Y[d]);
            if (nt < 0 || is_water(nt)) continue;          // land neighbour only
            int stencilIdx = 0x69 + d;
            if (stencilIdx >= (int)phys.nframes) continue;
            const Frame& st = phys.frames[stencilIdx];     // dither stipple mask
            int nbase = (nt >= 0x18) ? nt : (nt & 7);
            if (nbase == 1 && !is_forest(nt)) nbase = 0x11;
            int nf = terrain_base_frame(nbase);
            if (nf < 0 || nf >= terr.nframes) continue;
            const Frame& land = terr.frames[nf];           // neighbour's land terrain
            for (int gy = 0; gy < st.h; ++gy)
                for (int gx = 0; gx < st.w; ++gx)
                    if (st.px[gy * st.w + gx] != SS_TRANSPARENT) {   // stipple dot
                        if (gx < land.w && gy < land.h) {
                            uint8_t lp = land.px[gy * land.w + gx];
                            if (lp != SS_TRANSPARENT) scr.put(dx + gx, dy + gy, lp);
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
