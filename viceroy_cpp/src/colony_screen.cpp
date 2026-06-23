// colony_screen.cpp -- colony screen composer, per docs/COLONY_SCREEN_VICEROY_DECODE.md.
//
// Draw order follows the byte-read composer func_028592 (decode §2): wood fill ->
// buildings (upper-left, real 0x266 plot table + BUILDING.SS frame_base table) ->
// COLONY.PIK landscape strip at the BOTTOM (decode §5c) -> bottom-band panels ->
// stockpile bar -> title. Tables (PLOT, FRAME_BASE) extracted from VICEROY.EXE.
#include "colony_screen.hpp"
#include <cstdio>
#include <string>
#include <algorithm>

namespace vc {

// ---- byte-extracted tables (VICEROY.EXE, DGROUP base 0x1D9A0) -----------------------
// DS:0x266 plot table -- 15 building plots (x, table_y); render y = table_y + 8 (decode §4b).
static const int PLOT[15][2] = {
    {56,5},{145,7},{173,10},{8,33},{37,37},{67,46},{96,45},{6,6},
    {128,45},{10,68},{15,94},{87,3},{66,79},{123,98},{123,47},
};
// DS:0x2CA frame-base table -- BUILDING.SS frame per building type 0..41 (255 = wall/no sprite).
static const unsigned char FRAME_BASE[42] = {
    21,21,21, 15,15,15, 255,255,255, 17,17,17, 18,18,18, 255,255,255,255,255,255,
    11,11,11, 10,10,10, 9,9,9, 17,17, 12,12,12, 13,13, 16,16, 14,14,14,
};
// Building type -> plot slot (chains share a plot; highest built tier wins by draw order).
// The real per-colony assignment is the runtime fill func_025D34; this is a faithful static
// arrangement of the byte-verified plots for the buildings that carry a sprite.
static const signed char TYPE_PLOT[42] = {
    7,7,7,        // 0-2  defense (Stockade/Fort/Fortress)
    14,14,14,     // 3-5  Armory chain
    -1,-1,-1,     // 6-8  Docks chain (no sprite)
    0,0,0,        // 9-11 Town Hall
    12,12,12,     // 12-14 School/College/University
    -1,-1,-1,-1,-1,-1, // 15-20 warehouse/stable/customhouse/press (no sprite)
    4,4,4,        // 21-23 Weaver
    5,5,5,        // 24-26 Tobacconist
    6,6,6,        // 27-29 Rum
    1,1,          // 30-31 Capitol
    8,8,8,        // 32-34 Fur Trader
    3,3,          // 35-36 Carpenter/Lumber Mill
    11,11,        // 37-38 Church/Cathedral
    9,9,9,        // 39-41 Blacksmith
};

// COLONY.PIK is a 320x72 landscape STRIP placed at the BOTTOM of the screen (decode §5c).
constexpr int PIK_Y = 128;
// ICONS.SS indices (decode §6): commodity good i -> good+0x17; flag 0x44.
constexpr int ICON_GOOD0 = 0x17, ICON_FLAG = 0x44;
// Stockpile bar (decode §6): 16 cells, pitch 19 (0x13), icon row y=181 (0xB5).
constexpr int BAR_X = 0, BAR_Y = 179, BAR_CELLS = 16, BAR_PITCH = 19, BAR_ICON_Y = 181;
// UI colours (fonts_and_colors.md): white 15, basic green 68.
constexpr uint8_t COL_WHITE = 15, COL_FRAME = 68;

static void blit_icon(Surface& scr, const Sheet& icons, int idx, int x, int y) {
    if (idx >= 0 && idx < (int)icons.frames.size())
        scr.blit_frame(icons.frames[idx], x, y);
}

// Composite a PIK (its own palette) onto the active gameplay palette by nearest-colour
// remap, at (0, dstY). Used for the COLONY.PIK landscape strip.
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
                          const Sheet& woodtile, const Sheet& icons,
                          const Sheet& building, const Sheet& font,
                          const vc::sim::Colony& c, int gold, int tax_pct, int year,
                          const int stockpile[16]) {
    // --- Step 4: full-screen wood region fill (func_02633E; WOODTILE.SS tiled). [decode §2] ---
    if (woodtile.nframes > 0 && woodtile.frames[0].w > 0) {
        const Frame& wt = woodtile.frames[0];
        for (int y = 0; y < Surface::H; y += wt.h)
            for (int x = 0; x < Surface::W; x += wt.w)
                scr.blit_frame(wt, x, y);
    }

    // --- Step 12: buildings loop -- 15 plots, upper-left. For each built building type
    // (built_mask bit) that carries a sprite, blit BUILDING.SS[frame_base] at (plot_x,
    // plot_y + 8). Chains share a plot; iterating low->high tier lets the highest tier win
    // (Weaver's Shop over House, etc -- decode §4 construction-complete). [decode §4] ---
    for (int t = 0; t < 42; ++t) {
        if (!((c.built_mask >> t) & 1ull)) continue;
        int fb = FRAME_BASE[t];
        int slot = TYPE_PLOT[t];
        if (fb == 255 || slot < 0) continue;            // wall / no-sprite category
        if (fb < (int)building.frames.size())
            scr.blit_frame(building.frames[fb], PLOT[slot][0], PLOT[slot][1] + 8);
    }

    // --- Step 3: COLONY.PIK landscape strip at the BOTTOM (y=128), own palette remapped
    // onto the active gameplay palette. The bottom-band panels composite OVER it. [decode §5c] ---
    blit_pik_remap(scr, backdrop, PIK_Y);

    // --- Bottom-band panels (decode §3 region map): flat rects the composer fills; drawn as
    // framed regions here so their geometry is visible. Their dynamic contents (colonist
    // sprites, surrounding-tile loop) need the per-colonist model -- left for a follow-up. ---
    scr.rect_outline(0,   130, 120, 48, COL_FRAME);     // §7 colonist plaza
    scr.rect_outline(121, 130, 84,  48, COL_FRAME);     // §7 surrounding minimap
    scr.rect_outline(211, 130, 91,  48, COL_FRAME);     // §7 SoL / cargo / msg
    scr.rect_outline(303, 132, 17,  45, COL_FRAME);     // §7 flag panel
    scr.rect_outline(224, 32,  72,  72, COL_FRAME);     // §3.2 field-production panel
    blit_icon(scr, icons, ICON_FLAG, 303 + 3, 132 + 3); // flag sprite

    // --- Step 8: stockpile bar (decode §6) -- 16 commodity cells, ICONS good+0x17, pitch 19,
    // icon-Y 181; per-cell number = warehouse quantity (white). The right-end readout at
    // (306,179) is a heap caption, NOT gold (decode §6), so it is omitted. ---
    for (int i = 0; i < BAR_CELLS; ++i) {
        int cx = BAR_X + i * BAR_PITCH;
        blit_icon(scr, icons, ICON_GOOD0 + i, cx, BAR_ICON_Y);
        char q[8];
        std::snprintf(q, sizeof q, "%d", stockpile ? stockpile[i] : 0);
        scr.draw_text(font, cx + 1, BAR_ICON_Y - 6, q, COL_WHITE);
    }

    // --- Step 5: title strip (decode §9) -- colony name + season + year, centred near y=5.
    // (Gold is in the menu header, not here; see decode §10.) ---
    {
        std::string season = ((year % 2) == 0) ? "Spring" : "Autumn";   // @SEASONS (2 entries)
        char line[80];
        std::snprintf(line, sizeof line, "Jamestown   %s %d", season.c_str(), year);
        int w = font.frames.empty() ? 0 : scr.text_width(font, line);
        scr.draw_text(font, (Surface::W - w) / 2, 2, line, COL_WHITE);
    }
    (void)gold; (void)tax_pct; (void)BAR_Y;
}

} // namespace vc
