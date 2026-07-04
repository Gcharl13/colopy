// colony_screen.cpp -- colony screen composer, per docs/COLONY_SCREEN_VICEROY_DECODE.md
// + notes/SPRITE_CATALOG.md §BUILDING.SS (frame mapping).
//
// Composer order (func_028592): PARCH parchment fill -> base trees on empty plots +
// buildings on occupied plots (15 plots, 0x266 table) -> COLONY.PIK strip at the BOTTOM
// -> bottom-band panels -> stockpile bar -> title.
#include "colony_screen.hpp"
#include "mapview.hpp"     // compose_map_tile (worked-tiles view = exact map terrain)
#include "popup_render.hpp" // nearest_pal_index (title green / border black / qty navy)
#include <cstdio>
#include <string>
#include <algorithm>

namespace vc {

// DS:0x266 plot table -- 15 building plots (x, table_y); render y = table_y + 8.
static const int PLOT[15][2] = {
    {56,5},{145,7},{173,10},{8,33},{37,37},{67,46},{96,45},{6,6},
    {128,45},{10,68},{15,94},{87,3},{66,79},{123,98},{123,47},
};
// Occupied-plot frame = def_id in bundle space with def_id 0 -> 16 (func_026DD4
// @0x026E4E, live-verified colony_screen.md §0.2) -- the old TYPE_FRAME hand-map
// is superseded by that direct rule.
// WARNING (2026-06-24): this TYPE_PLOT table is a PLACEHOLDER, not the real placement.
// The actual which-building-in-which-plot is RNG-driven (func_025D34: random_int within
// 5 category plot-ranges, seeded per colony) -- see decode §12. This static arrangement
// is NOT faithful; rendering correct placement requires porting the RNG+seed+frame table.
static const signed char TYPE_PLOT[42] = {
    7,7,7, 14,14,14, -1,-1,-1, 0,0,0, 12,12,12, 2,-1,10, -1,-1,-1,
    4,4,4, 5,5,5, 6,6,6, 1,1, 8,8,8, 3,3, 11,11, 9,9,9,
};
// Empty-plot "base tree" / forest sprites (SPRITE_CATALOG.md: frames 42/43/44 = empty land lot).
static const int TREE_FRAME[3] = {42, 43, 44};

constexpr int PIK_Y = 128;                 // COLONY.PIK bottom band (320x72 → y=200-72).
// Stockpile bar: 16 cells, pitch 19, start x=1, icon-Y 179 (decode §6). Icon = good+0x16
// ⇒ ICONS frame 22 = Food … 37 = Muskets. NOTE: the EXE literal is good+0x17 but that
// indexes the EXE's frame numbering; in OUR bundle frame 22 is Food (pixel-verified: corn
// cob; frame 23 is the sugar-cane the old 0x17 base wrongly drew first). DOS ground-truth +
// sprite pixels outrank the spec's "23" per notes/TRUTH_HIERARCHY.md.
constexpr int ICON_GOOD0 = 0x16;
// The PIK's blue stockpile-cell interior is screen y=180..198 (pixel-measured). Icons are
// 12px tall, numbers 6px — so they stack icon-over-number inside the 19px cell. Drop the icon
// off the top border (was y=179, sitting ON the border → "too high") to y=181, with the
// quantity on the bottom row y=193.
constexpr int BAR_X0 = 1, BAR_CELLS = 16, BAR_PITCH = 19, BAR_ICON_Y = 181, BAR_NUM_Y = 193;
constexpr uint8_t COL_WHITE = 15;

static void blit_idx(Surface& scr, const Sheet& sh, int idx, int x, int y) {
    if (idx >= 0 && idx < (int)sh.frames.size() && sh.frames[idx].w > 2)
        scr.blit_frame(sh.frames[idx], x, y);
}

// Blit a frame clipped to a rect [cx0,cx1) x [cy0,cy1) — keeps the colony scene inside the
// parchment window so buildings/trees never spill onto the surrounding wood chrome.
static void blit_idx_clip(Surface& scr, const Sheet& sh, int idx, int x, int y,
                          int cx0, int cy0, int cx1, int cy1) {
    if (idx < 0 || idx >= (int)sh.frames.size() || sh.frames[idx].w <= 2) return;
    const Frame& f = sh.frames[idx];
    for (int gy = 0; gy < f.h; ++gy)
        for (int gx = 0; gx < f.w; ++gx) {
            int px = x + gx, py = y + gy;
            if (px < cx0 || py < cy0 || px >= cx1 || py >= cy1) continue;
            uint8_t p = f.px[gy * f.w + gx];
            if (p != SS_TRANSPARENT) scr.put(px, py, p);
        }
}

// Tile a sheet frame across a rect (used for the wood-grain screen background and the
// parchment scene inset).
static void tile_fill(Surface& scr, const Sheet& sh, int x0, int y0, int w, int h) {
    if (sh.nframes == 0 || sh.frames[0].w <= 0) return;
    const Frame& f = sh.frames[0];
    for (int y = y0; y < y0 + h; y += f.h)
        for (int x = x0; x < x0 + w; x += f.w) {
            for (int gy = 0; gy < f.h && y + gy < y0 + h; ++gy)
                for (int gx = 0; gx < f.w && x + gx < x0 + w; ++gx) {
                    uint8_t p = f.px[gy * f.w + gx];
                    if (p != SS_TRANSPARENT) scr.put(x + gx, y + gy, p);
                }
        }
}

// NAMES.TXT @UNFORESTED(0-7)/@FORESTED(8-15) per-terrain yields (byte-verified):
// Farmer/food, Planter-sugar, Planter-tobacco, Planter-cotton, Trapper/furs, Lumberjack/
// lumber, OreMiner/ore, SilverMiner/silver, Fisherman.
static const signed char YIELD[16][9] = {
    {2,0,0,0,0,0,2,0,0},{1,0,0,1,0,0,2,0,0},{4,0,0,2,0,0,1,0,0},{2,0,0,3,0,0,0,0,0}, // Tundra..Prairie
    {2,0,3,0,0,0,0,0,0},{3,3,0,0,0,0,0,0,0},{2,0,2,0,0,0,2,0,0},{2,2,0,0,0,0,2,0,0}, // Grassland..Swamp
    {1,0,0,0,3,2,1,0,0},{1,0,0,1,2,1,1,0,0},{2,0,0,1,3,3,0,0,0},{1,0,0,1,2,2,0,0,0}, // Boreal..Broadleaf
    {1,0,1,0,2,3,0,0,0},{2,1,0,0,2,2,0,0,0},{1,0,1,0,2,2,1,0,0},{1,1,0,0,1,2,1,0,0}, // Conifer..Rain
};
static const int YIELD_GOOD[9] = {0,1,2,3,4,5,6,7,0};   // yield column -> @CARGO good id

// classify terrain id -> yield row 0..15 (unforested 0-7 / forested fold 8-15); -1 = water/arctic.
static int yield_row(int id) {
    id &= 0x1F;
    if (id < 8)    return id;
    if (id < 0x18) return (id & 7) | 8;
    return -1;
}

// Upper-right "outside colony" worked-tiles grid (decode §5b): a 3x3 grid of the colony's
// real surrounding terrain, rendered with the EXACT map-view tile compositing (so it looks
// identical to the map), then overlaid with the colony sprite on the centre tile, the
// founding colonist on the tile it works, and the per-tile production value (good icon +
// quantity) from the byte-verified terrain yields. 16px tiles nearest-scaled to 24px cells.
static void render_worked_tiles(Surface& scr, const Sheet& terrain, const Sheet& phys,
                                const Sheet& icons, const Sheet& /*font*/,
                                const Map& map, int cx, int cy) {
    constexpr int CELL = 24, GX = 224, GY = 32;     // byte-exact: cell_x=200+24*col(1..3), cell_y=8+24*row(1..3)
    // 1. terrain: compose the 3x3 region at 16px, nearest-scale to the 72x72 panel.
    Surface tmp; tmp.set_palette(scr.pal);
    for (int row = 0; row < 3; ++row)
        for (int col = 0; col < 3; ++col)
            compose_map_tile(tmp, map, terrain, phys, cx + col - 1, cy + row - 1, col * 16, row * 16);
    for (int y = 0; y < 3 * CELL; ++y)
        for (int x = 0; x < 3 * CELL; ++x)
            scr.put(GX + x, GY + y, tmp.idx[(y * 48 / (3 * CELL)) * Surface::W + (x * 48 / (3 * CELL))]);

    auto tile_id = [&](int col, int row) {
        int x = cx + col - 1, y = cy + row - 1;
        if (x < 0 || y < 0 || x >= map.w || y >= map.h) return 25;     // ocean
        return (int)(map.tiles[(size_t)y * map.w + x] & 0x1F);
    };
    // The figure (colonist/colony) sits at the BOTTOM-CENTRE of the cell, facing RIGHT (sheet
    // art faces left → flip via the engine's 0x8000 flag, func_00E76A).
    auto blit_worker = [&](int fi, int col, int row) {
        if (fi < 0 || fi >= (int)icons.frames.size()) return;
        const Frame& f = icons.frames[fi];
        scr.blit_frame_flip(f, GX + col * CELL + (CELL - f.w) / 2, GY + row * CELL + CELL - f.h - 1);
    };
    auto blit_colony = [&](int fi, int col, int row) {               // colony sprite, bottom-centre
        if (fi < 0 || fi >= (int)icons.frames.size()) return;
        const Frame& f = icons.frames[fi];
        scr.blit_frame(f, GX + col * CELL + (CELL - f.w) / 2, GY + row * CELL + CELL - f.h - 1);
    };
    // Produced good = a HORIZONTAL ROW of the good's sprite (ICONS good+0x16), centred ABOVE the
    // colonist near the top of the cell (good sprite over the worker, both centred — DOS layout).
    auto row_good = [&](int col, int row, int good, int qty) {
        int fi = 0x16 + good;
        if (fi < 0 || fi >= (int)icons.frames.size() || qty <= 0) return;
        const Frame& f = icons.frames[fi];
        int avail = CELL - 1;
        int step = (qty <= 1) ? 0 : std::min(f.w, (avail - f.w) / (qty - 1));
        if (qty > 1 && step < 2) step = 2;
        int total = f.w + step * (qty - 1);
        int bx = GX + col * CELL + (CELL - total) / 2;               // centred horizontally
        int by = GY + row * CELL + 1;                                // top of the cell, above the figure
        for (int k = 0; k < qty && k < 5; ++k) scr.blit_frame(f, bx + k * step, by);
    };

    // 2. the founding colonist works the best adjacent LAND tile; show the colonist + the
    //    byte-verified yield of the good it produces. The centre tile auto-produces food.
    int best_col = -1, best_row = -1, best_g = 0, best_q = 0;
    for (int row = 0; row < 3; ++row)
        for (int col = 0; col < 3; ++col) {
            if (col == 1 && row == 1) continue;
            int yr = yield_row(tile_id(col, row));
            if (yr < 0) continue;
            for (int j = 0; j < 8; ++j) {                              // best produced good on the tile
                int q = YIELD[yr][j];
                if (q > best_q) { best_q = q; best_g = YIELD_GOOD[j]; best_col = col; best_row = row; }
            }
        }
    // 3. centre = the colony sprite (ICONS frame 0) at the bottom + its auto food above.
    blit_colony(0, 1, 1);
    int cyr = yield_row(tile_id(1, 1));
    if (cyr >= 0) row_good(1, 1, 0 /*Food*/, YIELD[cyr][0]);          // centre auto food (farmer yield)
    // 4. the worker = a Free Colonist (ICONS frame 100) bottom-centre facing right, produced good
    //    centred above it.
    if (best_col >= 0) {
        blit_worker(100, best_col, best_row);                        // Free Colonist, bottom-centre, facing right
        row_good(best_col, best_row, best_g, best_q);                // produced good, above the colonist
    }
    scr.rect_outline(GX + CELL, GY + CELL, CELL, CELL, COL_WHITE);    // white frame on the colony tile
}

// COLONY.PIK is the whole bottom-band BACKGROUND (scenery + panel frames + stockpile
// cells + Europe "E" button, all baked in). Its pixels are authored against the GAMEPLAY
// palette — the embedded PIK palette is a red herring (a nearest-colour remap onto the
// gameplay palette mangled every hue). So blit the RAW indices, no remap. [decode §5/§5c,
// pixel-verified 2026-06-24: raw indices under the BUILDING palette render the scene exactly.]
// Tiny 3x5 digit face at FONTTINY metrics (4x6 fixed cell, fonts_and_colors.md:
// FONTTINY is "6 x 4 fixed" and the .FF file is not part of the decoded art set,
// so these glyph shapes are a RECONSTRUCTED stand-in at the correct cell size --
// the capture's warehouse digits are ~4x6 dark-navy figures).
static const uint8_t TINY_ROWS[10][5] = {   // 5 rows x 3 bits per digit, MSB = left
    {7,5,5,5,7},   // 0
    {2,6,2,2,7},   // 1
    {7,1,7,4,7},   // 2
    {7,1,3,1,7},   // 3
    {5,5,7,1,1},   // 4
    {7,4,7,1,7},   // 5
    {7,4,7,5,7},   // 6
    {7,1,2,2,2},   // 7
    {7,5,7,5,7},   // 8
    {7,5,7,1,7},   // 9
};
static int tiny_num_width(const char* s) {
    int n = 0;
    for (; *s; ++s) ++n;
    return n ? n * 4 - 1 : 0;
}
static void draw_tiny_num(Surface& scr, int x, int y, const char* s, uint8_t color) {
    for (; *s; ++s) {
        if (*s >= '0' && *s <= '9') {
            const uint8_t* rows = TINY_ROWS[*s - '0'];
            for (int j = 0; j < 5; ++j)
                for (int i = 0; i < 3; ++i)
                    if (rows[j] & (4 >> i)) scr.put(x + i, y + j, color);
        }
        x += 4;
    }
}

static void blit_pik_raw(Surface& scr, const IndexedPng& pik, int dstY) {
    for (int y = 0; y < pik.h && (dstY + y) < Surface::H; ++y)
        for (int x = 0; x < pik.w && x < Surface::W; ++x)
            scr.put(x, dstY + y, pik.idx[y * pik.w + x]);
}

// Parchment colony-scene window (wood chrome with a parchment scene region). Buildings draw
// at the byte-verified plot coords (x = DS:0x266, y = DS:0x268 + 8; x 6..173, y 13..106 per
// the layout agent), so the scene region spans the building area, left of the worked-tiles panel.
// Scene rect + borders are pixel-measured from the live capture
// docs/screens/colony_live_1505.png: parchment spans (0,8)..(198,127), a 1-px
// black column at x=199 separates it from the wood, a full-width black rule
// sits at y=7 (under the title strip) and at y=128 (over the PIK band top),
// and the field-production panel (224,32,72,72) has a 1-px black outline.
constexpr int SCENE_X = 0, SCENE_Y = 8, SCENE_W = 199, SCENE_H = 120;

// Plot → category map (func_025D34 flatten of counts [7,4,2,1,1] / bases [0,7,11,13,14]):
// 0x8D62 = [0×7, 1×4, 2×2, 3, 4]. Byte-verified (agent trace 2026-06-24, flatten @0x025DA3).
static const int PLOT_CAT[15] = {0,0,0,0,0,0,0, 1,1,1,1, 2,2, 3, 4};
// Empty / not-yet-built plot sprite per category = BUILDING frame DS:0x260[cat] − 1 =
// [44,43,42,—,45] (tree/grove decorations; spec/ui/colony_screen.md §0.2 plot table +
// empty-plot painter func_026FF2: "frame = DS:0x260[category] − 1", table [45,44,43,0,46],
// 0 ⇒ category 3 draws none). The earlier [45,44,43,0,46] here was the RAW table (off by one).
static const int EMPTY_LOT_FRAME[5] = {44, 43, 42, 0, 45};

void render_colony_screen(Surface& scr, const IndexedPng& backdrop,
                          const Sheet& parch, const Sheet& woodtile, const Sheet& icons,
                          const Sheet& building, const Sheet& font,
                          const Sheet& terrain, const Sheet& phys,
                          const Map* map, int cx, int cy,
                          const vc::sim::Colony& c, int gold, int tax_pct, int year,
                          const int stockpile[16]) {
    // --- Background = WOOD chrome (WOODTILE.SS tiled), NOT parchment. The colony screen is
    // a wood-framed window; only the colony SCENE is a parchment inset. [DOS capture] ---
    tile_fill(scr, woodtile, 0, 0, Surface::W, Surface::H);

    // --- Colony-scene parchment inset (top-left): PARCH.SS tiled inside the scene window. ---
    tile_fill(scr, parch, SCENE_X, SCENE_Y, SCENE_W, SCENE_H);

    // --- Scene: 15 plots, each drawing its built building (type-specific BUILDING.SS sprite via
    // func_026DD4) or, if empty, its CATEGORY cleared-lot frame (45/44/43/–/46). PLACEMENT is the
    // byte-computed result of func_025D34 for THIS colony (20,25): the MSC-LCG claim permutation
    // (seed=(uint16)((y<<8)+x)=0x1914) + the +0x84 produced-good pass gives slot→good 0x8E82 =
    // [27,-1,24,21,-1,-1,32,39,-1,35,-1,-1,9,-1,-1]. (Agent-verified; the general algorithm is
    // documented — re-run it if cx/cy or the base seed [0x8D80] change.) ---
    // Occupied-plot frame = def_id in bundle space (EXE draws def_id+1 in EXE-sheet
    // space; the ssdec decode cancels it -- func_026DD4 @0x026E4E, live-verified in
    // spec/ui/colony_screen.md §0.2), with the byte-read special case def_id 0 → 16.
    static const signed char SLOT_GOOD[15] = {27,-1,24,21,-1,-1,32,39,-1,35,-1,-1,9,-1,-1};
    auto def_frame = [](int def_id) { return def_id == 0 ? 16 : def_id; };
    for (int slot = 0; slot < 15; ++slot) {
        int good = (cx == 20 && cy == 25) ? SLOT_GOOD[slot] : -2;    // computed layout for the default founding
        int frame;
        if (good >= 0) frame = def_frame(good);                      // built: frame = def_id
        else if (good == -2) {                                       // other colony: fall back to mask+plot
            int bf = -1;
            for (int t = 0; t < 42; ++t)
                if (TYPE_PLOT[t] == slot && ((c.built_mask >> t) & 1ull)) bf = def_frame(t);
            if (bf >= 0) frame = bf;
            else { int ef = EMPTY_LOT_FRAME[PLOT_CAT[slot]]; if (ef <= 0) continue; frame = ef; }
        } else { int ef = EMPTY_LOT_FRAME[PLOT_CAT[slot]]; if (ef <= 0) continue; frame = ef; }  // cleared lot
        // The bundle cells are the FULL 56x42 native windows whose in-window sprite
        // position bakes the frame's own draw offset -- blit at the raw plot-table
        // (x, y) (PLOT stores table_y-8, so +8 restores it); capture-calibrated:
        // the frame-9 Town Hall window lands on the live capture at exactly this.
        int x = PLOT[slot][0], y = PLOT[slot][1] + 8;               // byte-verified plot coords (DS:0x266)
        blit_idx_clip(scr, building, frame, x, y,
                      SCENE_X, SCENE_Y, SCENE_X + SCENE_W, SCENE_Y + SCENE_H);
    }

    // --- Upper-right OUTSIDE-COLONY view: the 3x3 worked-tiles grid rendered with the EXACT
    // map-view terrain compositing (so it looks like the map), from the colony's real map
    // neighbourhood. [decode §5b] ---
    if (map) render_worked_tiles(scr, terrain, phys, icons, font, *map, cx, cy);

    // --- Step 3: COLONY.PIK = the whole bottom band (y=128). It already carries the panel
    // frames, the warehouse barrels, the blue stockpile cells and the "E" button — so we do
    // NOT draw our own panel outlines/flag over it (those were scaffolding that painted wrong-
    // coloured boxes on top of the baked chrome). Dynamic per-panel content (colonist plaza,
    // surrounding tiles, SoL bar) is composited over the PIK by its sub-renderers — TBD until
    // the per-colonist / surrounding-tile model is wired in. ---
    blit_pik_raw(scr, backdrop, PIK_Y);

    // --- Screen-portion separators (capture-measured, colony_live_1505.png): the black
    // rules that frame the scene / wood / PIK regions and the field panel. ---
    {
        uint8_t black = nearest_pal_index(scr.pal, 0, 0, 0);
        for (int x = 0; x < Surface::W; ++x) {
            scr.put(x, 7, black);                       // under the title strip
            scr.put(x, PIK_Y, black);                   // over the PIK band top row
        }
        for (int y = SCENE_Y; y < SCENE_Y + SCENE_H; ++y)
            scr.put(SCENE_X + SCENE_W, y, black);       // scene | wood column (x=199)
        for (int x = 223; x <= 296; ++x) {              // field-panel 1-px outline
            scr.put(x, 31, black);
            scr.put(x, 104, black);
        }
        for (int y = 31; y <= 104; ++y) {
            scr.put(223, y, black);
            scr.put(297, y, black);
        }
    }

    // --- Colonist plaza (LEFT panel 0..120, func_0270D0): colonist figures + SoL%/Tory (y=132)
    // + the Food/Crosses/Bells production row (y=163). All drawn HERE (the SoL attribution to
    // func_02814C in decode §7 was an over-read — agent-traced). ---
    // All positions below are ABSOLUTE SCREEN coords (agent-verified: func_0270D0 draws to the
    // 320x200 back buffer with no panel-origin transform — 132/142/163 are screen-y).
    {
        int pop = c.population < 1 ? 1 : c.population;
        // SoL% = (rebel_A*100)/rebel_B, +20 human latch, clamp 100 (func_008524,
        // colony_screen.md §0.6). Member count in parens is RECONSTRUCTED as
        // round-up pop*SoL% (matches the capture's "100% (1)" at pop=1).
        int sol = c.rebel_B > 0 ? (int)((int64_t)c.rebel_A * 100 / c.rebel_B) : 0;
        if (c.human) sol += 20;
        if (sol > 100) sol = 100;
        if (sol < 0) sol = 0;
        int members = (pop * sol + 99) / 100;
        // y=132 row: Tory crown (ICONS 0x7C) @ (2,132) + Tory COUNT; SoL% right-aligned @ x=0x75-w.
        blit_idx(scr, icons, 0x7C, 2, 132);
        char tn[16]; std::snprintf(tn, sizeof tn, "%d", pop - members);   // Tory count
        scr.draw_text(font, 16, 133, tn, COL_WHITE);
        char sols[24]; std::snprintf(sols, sizeof sols, "%d%% (%d)", sol, members);
        int sw = font.frames.empty() ? 0 : scr.text_width(font, sols);
        scr.draw_text(font, 0x75 - sw, 133, sols, COL_WHITE);  // right-aligned at x=117-width (@0x027589)
        // y=142 row: colonist figures (screen x≈2, y=142; @0x0270FF), facing right (flip).
        if (100 < (int)icons.frames.size()) {
            const Frame& cf = icons.frames[100];
            int px = 2;
            for (int k = 0; k < pop && k < 8; ++k) { scr.blit_frame_flip(cf, px, 142); px += cf.w + 6; }
        }
        // y=163 production row, CENTRED in span [2,120] (flush 0x22C @0x0273D7). Food/Crosses/Bells
        // as LAYERED sprites (never numbers). Counts from the byte-verified terrain yields (founding).
        int food = 0, crosses = 0, bells = 0;
        if (map) {
            auto tid = [&](int dx, int dy) {
                int x = cx + dx, y = cy + dy;
                if (x < 0 || y < 0 || x >= map->w || y >= map->h) return 25;
                return (int)(map->tiles[(size_t)y * map->w + x] & 0x1F);
            };
            int cr = yield_row(tid(0, 0));   // colony-centre auto food
            if (cr >= 0) food += YIELD[cr][0];
            int bestf = 0;
            for (int dy = -1; dy <= 1; ++dy) for (int dx = -1; dx <= 1; ++dx) {
                if (!dx && !dy) continue;
                int yr = yield_row(tid(dx, dy));
                if (yr >= 0 && YIELD[yr][0] > bestf) bestf = YIELD[yr][0];
            }
            food += bestf;                                 // TOTAL food produced (centre + worked tile)
        }
        auto iw = [&](int f) { return (f >= 0 && f < (int)icons.frames.size() && icons.frames[f].w > 2) ? icons.frames[f].w : 6; };
        int total = food * iw(22) + crosses * iw(56) + bells * iw(62);   // centred row width
        int rx = 2 + (118 - total) / 2; if (rx < 2) rx = 2;
        auto prod = [&](int frame, int val) {
            for (int k = 0; k < val && k < 12; ++k) { blit_idx(scr, icons, frame, rx, 163); rx += iw(frame); }
        };
        prod(22, food);                                    // Food (good 0) — layered
        prod(56, crosses);                                 // Crosses — layered
        prod(62, bells);                                   // Bells — layered
    }
    // --- Ship/cargo "No Ships In Port" — kept centred where it was (user directive). ---
    {
        const char* s = "No Ships In Port";
        int tw = font.frames.empty() ? 0 : scr.text_width(font, s);
        scr.draw_text(font, 163 - tw / 2, 136, s, COL_WHITE);
    }
    // --- Production/build button slots (far-right column above the Exit button). ICONS blue-
    // button frames 67/68/69 = the lumber/tools/hammer production chain. ---
    for (int i = 0; i < 3; ++i)
        blit_idx(scr, icons, 67 + i, 303, 132 + i * 15);

    // --- Step 8: stockpile bar — 16 commodity cells over the PIK's blue cells. Icon = ICONS
    // good+0x16 (Food..Muskets), centred in the 19-px cell and top-anchored at y=181, clipped
    // above the quantity row; quantity in the capture's dark navy (#181c7d) FONTTINY-sized
    // digits at y=193 (colony_screen.md §0.3; the live capture stacks icon OVER number). ---
    {
        uint8_t navy = nearest_pal_index(scr.pal, 0x18, 0x1c, 0x7d);
        for (int i = 0; i < BAR_CELLS; ++i) {
            int cellx = BAR_X0 + i * BAR_PITCH;
            int fi = ICON_GOOD0 + i;
            if (fi >= 0 && fi < (int)icons.frames.size()) {
                int iw = icons.frames[fi].w;
                blit_idx_clip(scr, icons, fi, cellx + (BAR_PITCH - iw) / 2, BAR_ICON_Y,
                              cellx, BAR_ICON_Y, cellx + BAR_PITCH, BAR_NUM_Y - 1);
            }
            char q[8]; std::snprintf(q, sizeof q, "%d", stockpile ? stockpile[i] : 0);
            int tw = tiny_num_width(q);
            draw_tiny_num(scr, cellx + (BAR_PITCH - tw) / 2, BAR_NUM_Y, q, navy);
        }
    }

    // --- Top banner: "Name.  Season, Year.  Gold: N" in the green title latch at (90,1)
    // (colony_screen.md §0.5: green FONTTINY x90 y1; glyph green sampled (85,150,52) from
    // the live capture — the EXE emits it via the screen-latched handle, fonts_and_colors.md). ---
    {
        uint8_t green = nearest_pal_index(scr.pal, 85, 150, 52);
        std::string season = ((year % 2) == 0) ? "Spring" : "Autumn";
        char line[96];
        std::snprintf(line, sizeof line, "Jamestown.  %s, %d.  Gold: %d", season.c_str(), year, gold);
        scr.draw_text(font, 90, 1, line, green);
    }
    (void)tax_pct;
}

} // namespace vc
