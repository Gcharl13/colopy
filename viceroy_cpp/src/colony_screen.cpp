// colony_screen.cpp -- colony screen composer, per docs/COLONY_SCREEN_VICEROY_DECODE.md
// + notes/SPRITE_CATALOG.md §BUILDING.SS (frame mapping).
//
// Composer order (func_028592): PARCH parchment fill -> base trees on empty plots +
// buildings on occupied plots (15 plots, 0x266 table) -> COLONY.PIK strip at the BOTTOM
// -> bottom-band panels -> stockpile bar -> title.
#include "colony_screen.hpp"
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

constexpr int PIK_Y = 128;                 // COLONY.PIK landscape strip at the bottom.
constexpr int ICON_GOOD0 = 0x17, ICON_FLAG = 0x44;
constexpr int BAR_X = 0, BAR_Y = 179, BAR_CELLS = 16, BAR_PITCH = 19, BAR_ICON_Y = 181;
constexpr uint8_t COL_WHITE = 15, COL_FRAME = 68;

static void blit_idx(Surface& scr, const Sheet& sh, int idx, int x, int y) {
    if (idx >= 0 && idx < (int)sh.frames.size() && sh.frames[idx].w > 2)
        scr.blit_frame(sh.frames[idx], x, y);
}

// Composite a PIK (its own palette) onto the active gameplay palette at (0, dstY).
static void blit_pik_remap(Surface& scr, const IndexedPng& pik, int dstY) {
    uint8_t lut[256];
    for (int i = 0; i < 256; ++i) {
        int sr = pik.pal[i*3], sg = pik.pal[i*3+1], sb = pik.pal[i*3+2];
        int best = 0, bestd = 1 << 30;
        for (int j = 0; j < 256; ++j) {
            int dr = sr - scr.pal[j*3], dg = sg - scr.pal[j*3+1], db = sb - scr.pal[j*3+2];
            int d = dr*dr + dg*dg + db*db;
            if (d < bestd) { bestd = d; best = j; }
        }
        lut[i] = (uint8_t)best;
    }
    for (int y = 0; y < pik.h && (dstY + y) < Surface::H; ++y)
        for (int x = 0; x < pik.w && x < Surface::W; ++x)
            scr.put(x, dstY + y, lut[pik.idx[y * pik.w + x]]);
}

void render_colony_screen(Surface& scr, const IndexedPng& backdrop,
                          const Sheet& parch, const Sheet& icons,
                          const Sheet& building, const Sheet& font,
                          const vc::sim::Colony& c, int gold, int tax_pct, int year,
                          const int stockpile[16]) {
    // --- Step 4: full-screen PARCHMENT fill (func_02633E; PARCH.SS 32x24 tiled). [decode §2] ---
    if (parch.nframes > 0 && parch.frames[0].w > 0) {
        const Frame& p = parch.frames[0];
        for (int y = 0; y < Surface::H; y += p.h)
            for (int x = 0; x < Surface::W; x += p.w)
                scr.blit_frame(p, x, y);
    }

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

    // --- Step 3: COLONY.PIK landscape strip at the BOTTOM (y=128); panels composite over it. ---
    blit_pik_remap(scr, backdrop, PIK_Y);

    // --- Bottom-band panel rects (decode §3); dynamic contents need the per-colonist model. ---
    scr.rect_outline(0,   130, 120, 48, COL_FRAME);
    scr.rect_outline(121, 130, 84,  48, COL_FRAME);
    scr.rect_outline(211, 130, 91,  48, COL_FRAME);
    scr.rect_outline(303, 132, 17,  45, COL_FRAME);
    scr.rect_outline(224, 32,  72,  72, COL_FRAME);
    blit_idx(scr, icons, ICON_FLAG, 303 + 3, 132 + 3);

    // --- Step 8: stockpile bar -- 16 commodity cells, ICONS good+0x17, pitch 19, icon-Y 181. ---
    for (int i = 0; i < BAR_CELLS; ++i) {
        int cx = BAR_X + i * BAR_PITCH;
        blit_idx(scr, icons, ICON_GOOD0 + i, cx, BAR_ICON_Y);
        char q[8]; std::snprintf(q, sizeof q, "%d", stockpile ? stockpile[i] : 0);
        scr.draw_text(font, cx + 1, BAR_ICON_Y - 6, q, COL_WHITE);
    }

    // --- Step 5: title strip -- colony name + season + year (gold is in the menu header). ---
    {
        std::string season = ((year % 2) == 0) ? "Spring" : "Autumn";
        char line[80]; std::snprintf(line, sizeof line, "Jamestown   %s %d", season.c_str(), year);
        int w = font.frames.empty() ? 0 : scr.text_width(font, line);
        scr.draw_text(font, (Surface::W - w) / 2, 2, line, COL_WHITE);
    }
    (void)gold; (void)tax_pct; (void)BAR_Y;
}

} // namespace vc
