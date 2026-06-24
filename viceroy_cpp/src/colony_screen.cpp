// colony_screen.cpp -- colony screen composer, per docs/COLONY_SCREEN_VICEROY_DECODE.md
// + notes/SPRITE_CATALOG.md §BUILDING.SS (frame mapping).
//
// Composer order (func_028592): PARCH parchment fill -> base trees on empty plots +
// buildings on occupied plots (15 plots, 0x266 table) -> COLONY.PIK strip at the BOTTOM
// -> bottom-band panels -> stockpile bar -> title.
#include "colony_screen.hpp"
#include "mapview.hpp"     // compose_map_tile (worked-tiles view = exact map terrain)
#include <cstdio>
#include <string>
#include <algorithm>

namespace vc {

// DS:0x266 plot table -- 15 building plots (x, table_y); render y = table_y + 8.
static const int PLOT[15][2] = {
    {56,5},{145,7},{173,10},{8,33},{37,37},{67,46},{96,45},{6,6},
    {128,45},{10,68},{15,94},{87,3},{66,79},{123,98},{123,47},
};
// Building TYPE (NAMES @BUILDING) -> BUILDING.SS frame, per SPRITE_CATALOG.md §BUILDING.SS
// (the 1:1 wall/dock/civic/church/edu/warehouse/blacksmith frames + the craftsman-chain
// silhouettes 21-34). -1 = no distinct sprite (custom house / press / newspaper).
static const signed char TYPE_FRAME[42] = {
    0,1,2,        // 0-2  Stockade/Fort/Fortress
    3,4,5,        // 3-5  Armory/Magazine/Arsenal
    6,7,8,        // 6-8  Docks/Drydock/Shipyard
    9,9,20,       // 9-11 Town Hall / Town Hall / Colonial Assembly
    13,13,14,     // 12-14 Schoolhouse/College/University
    15,47,35,     // 15-17 Warehouse/Expansion/Stable
    -1,-1,-1,     // 18-20 Custom House/Printing Press/Newspaper (no distinct frame)
    21,22,23,     // 21-23 Weaver's House/Shop/Textile Mill
    24,25,26,     // 24-26 Tobacconist's House/Shop/Cigar Factory
    27,28,29,     // 27-29 Rum Distiller's House/Distillery/Factory
    9,20,         // 30-31 Capitol/Capitol Expansion (civic)
    32,33,34,     // 32-34 Fur Trader's House/Post/Factory
    36,36,        // 35-36 Carpenter's Shop / Lumber Mill
    37,38,        // 37-38 Church/Cathedral
    39,40,41,     // 39-41 Blacksmith's House/Shop/Iron Works
};
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

// Upper-right "outside colony" worked-tiles grid (decode §5b): a 3x3 grid of the colony's
// real surrounding terrain, rendered with the EXACT map-view tile compositing (base ground +
// biome blend + forest/river/hills + coast) so it looks identical to the map. The 16px
// composited tiles are nearest-scaled to the 24px colony cells. Grid centre (col=row=0) =
// the colony tile (white-outlined). [decode §5b; tile compositing = mapview compose_map_tile]
static void render_worked_tiles(Surface& scr, const Sheet& terrain, const Sheet& phys,
                                const Map& map, int cx, int cy) {
    constexpr int CELL = 24, GX = 228, GY = 36;     // panel grid origin (decode: 3x3 @24px)
    // 1. compose the 3x3 region into a scratch surface at 16px (48x48 block).
    Surface tmp; tmp.set_palette(scr.pal);
    for (int row = 0; row < 3; ++row)
        for (int col = 0; col < 3; ++col)
            compose_map_tile(tmp, map, terrain, phys, cx + col - 1, cy + row - 1,
                             col * 16, row * 16);
    // 2. nearest-scale the 48x48 block up to the 72x72 panel grid.
    for (int y = 0; y < 3 * CELL; ++y)
        for (int x = 0; x < 3 * CELL; ++x) {
            int sx = x * 48 / (3 * CELL), sy = y * 48 / (3 * CELL);
            scr.put(GX + x, GY + y, tmp.idx[sy * Surface::W + sx]);
        }
    // 3. white frame around the colony (centre) tile.
    scr.rect_outline(GX + CELL, GY + CELL, CELL, CELL, COL_WHITE);
}

// COLONY.PIK is the whole bottom-band BACKGROUND (scenery + panel frames + stockpile
// cells + Europe "E" button, all baked in). Its pixels are authored against the GAMEPLAY
// palette — the embedded PIK palette is a red herring (a nearest-colour remap onto the
// gameplay palette mangled every hue). So blit the RAW indices, no remap. [decode §5/§5c,
// pixel-verified 2026-06-24: raw indices under the BUILDING palette render the scene exactly.]
static void blit_pik_raw(Surface& scr, const IndexedPng& pik, int dstY) {
    for (int y = 0; y < pik.h && (dstY + y) < Surface::H; ++y)
        for (int x = 0; x < pik.w && x < Surface::W; ++x)
            scr.put(x, dstY + y, pik.idx[y * pik.w + x]);
}

// Parchment colony-scene inset window (R — measured from the DOS capture: the buildings
// scene is a tan parchment panel inset into the wood chrome, top-left, ending before the
// worked-tiles panel and above the COLONY.PIK bottom band).
constexpr int SCENE_X = 4, SCENE_Y = 10, SCENE_W = 214, SCENE_H = 118;

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

    // --- Scene: for each of the 15 plots, draw the occupying building (highest built tier)
    // or, if empty, a BASE TREE (forest frame 42/43/44 = un-built lot art -- SPRITE_CATALOG).
    // [decode §4 + SPRITE_CATALOG §BUILDING.SS] ---
    for (int slot = 0; slot < 15; ++slot) {
        int best_frame = -1;
        for (int t = 0; t < 42; ++t) {                 // low->high so higher tier wins
            if (TYPE_PLOT[t] != slot) continue;
            if (!((c.built_mask >> t) & 1ull)) continue;
            if (TYPE_FRAME[t] >= 0) best_frame = TYPE_FRAME[t];
        }
        int x = PLOT[slot][0], y = PLOT[slot][1] + 8;
        if (best_frame >= 0) blit_idx(scr, building, best_frame, x, y);
        else                 blit_idx(scr, building, TREE_FRAME[slot % 3], x, y);  // base tree
    }

    // --- Upper-right OUTSIDE-COLONY view: the 3x3 worked-tiles grid rendered with the EXACT
    // map-view terrain compositing (so it looks like the map), from the colony's real map
    // neighbourhood. [decode §5b] ---
    if (map) render_worked_tiles(scr, terrain, phys, *map, cx, cy);

    // --- Step 3: COLONY.PIK = the whole bottom band (y=128). It already carries the panel
    // frames, the warehouse barrels, the blue stockpile cells and the "E" button — so we do
    // NOT draw our own panel outlines/flag over it (those were scaffolding that painted wrong-
    // coloured boxes on top of the baked chrome). Dynamic per-panel content (colonist plaza,
    // surrounding tiles, SoL bar) is composited over the PIK by its sub-renderers — TBD until
    // the per-colonist / surrounding-tile model is wired in. ---
    blit_pik_raw(scr, backdrop, PIK_Y);

    // --- Step 8: stockpile bar — 16 commodity cells over the PIK's blue cells. Icon = ICONS
    // good+0x16 (Food..Muskets), centred in the 19-px cell; quantity centred just below it. ---
    for (int i = 0; i < BAR_CELLS; ++i) {
        int cellx = BAR_X0 + i * BAR_PITCH;
        int fi = ICON_GOOD0 + i;
        if (fi >= 0 && fi < (int)icons.frames.size()) {
            int iw = icons.frames[fi].w;
            blit_idx(scr, icons, fi, cellx + (BAR_PITCH - iw) / 2, BAR_ICON_Y);
        }
        char q[8]; std::snprintf(q, sizeof q, "%d", stockpile ? stockpile[i] : 0);
        int tw = font.frames.empty() ? 0 : scr.text_width(font, q);
        scr.draw_text(font, cellx + (BAR_PITCH - tw) / 2, BAR_NUM_Y, q, COL_WHITE);
    }

    // --- Top banner: a single line "Name, Season Year, Gold: N" — verbatim format from the
    // DOS session captures (SESSION_UI_CATALOG.md §2: "Plymouth, Spring 1543, Gold: 19200").
    // Name+season+year are composer-step-5 fields (§9); Gold is the treasury PowerRecord+0x2A
    // (§10), shown INLINE in this banner (not on the warehouse bar). ---
    {
        std::string season = ((year % 2) == 0) ? "Spring" : "Autumn";
        char line[96];
        std::snprintf(line, sizeof line, "Jamestown, %s, %d, Gold: %d", season.c_str(), year, gold);
        int w = font.frames.empty() ? 0 : scr.text_width(font, line);
        scr.draw_text(font, (Surface::W - w) / 2, 2, line, COL_WHITE);
    }
    (void)tax_pct;
}

} // namespace vc
