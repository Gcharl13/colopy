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

// terrain_cell_transform (mapview.cpp / VICEROY_decompiled @18195): L1 terrain code
// (id & 0x1F) -> TERRAIN.SS base-ground frame index. Same mapping the map view uses.
static int terrain_base_frame(int code) {
    if (code == 0x11 || code == 0x09) return 8;
    if (code >= 8) return code - 0xF;
    return code;
}

// Blit a sheet frame nearest-scaled to dw x dh at (dx,dy). Opaque (terrain ground has no
// transparency); SS_TRANSPARENT pixels are still skipped so any holes show the panel bg.
static void blit_scaled(Surface& scr, const Frame& f, int dx, int dy, int dw, int dh) {
    if (f.w <= 0 || f.h <= 0) return;
    for (int y = 0; y < dh; ++y)
        for (int x = 0; x < dw; ++x) {
            uint8_t p = f.px[(y * f.h / dh) * f.w + (x * f.w / dw)];
            if (p != SS_TRANSPARENT) scr.put(dx + x, dy + y, p);
        }
}

// Upper-right "outside colony" worked-tiles grid (decode §5b): a 3x3 grid of the colony's
// surrounding terrain, 24px cells, top-left of each tile at (252 + 24*col, 60 + 24*row);
// centre (col=row=0) = the colony tile. Terrain art = TERRAIN.SS base ground (16px) scaled
// to 24px. NOTE: the exact in-game tile sheet/frame for this panel is decode-TBD
// (frame=id+0x5a from [0x839E]); this draws the *real* surrounding terrain via the map-view
// TERRAIN base mapping — faithful terrain, approximate tile art (R). The crops/worker
// overlays per tile are not drawn (need the per-tile work table).
static void render_outside_view(Surface& scr, const Sheet& terrain, const int surround[9]) {
    constexpr int CELL = 24, CX = 252, CY = 60;
    for (int row = -1; row <= 1; ++row)
        for (int col = -1; col <= 1; ++col) {
            int id = surround[(row + 1) * 3 + (col + 1)] & 0x1F;
            int fr = terrain_base_frame(id);
            int dx = CX + CELL * col, dy = CY + CELL * row;
            if (fr >= 0 && fr < (int)terrain.frames.size())
                blit_scaled(scr, terrain.frames[fr], dx, dy, CELL, CELL);
        }
    // 1px white frame around the colony (centre) tile so "this tile = the colony" reads.
    scr.rect_outline(CX, CY, CELL, CELL, COL_WHITE);
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

void render_colony_screen(Surface& scr, const IndexedPng& backdrop,
                          const Sheet& parch, const Sheet& icons,
                          const Sheet& building, const Sheet& font,
                          const Sheet& terrain,
                          const vc::sim::Colony& c, int gold, int tax_pct, int year,
                          const int stockpile[16], const int surround[9]) {
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

    // --- Upper-right OUTSIDE-COLONY view: the 3x3 worked-tiles grid from the real
    // surrounding terrain (the colony's map neighbourhood). [decode §5b] ---
    if (surround) render_outside_view(scr, terrain, surround);

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
        std::snprintf(line, sizeof line, "Jamestown, %s %d, Gold: %d", season.c_str(), year, gold);
        int w = font.frames.empty() ? 0 : scr.text_width(font, line);
        scr.draw_text(font, (Surface::W - w) / 2, 2, line, COL_WHITE);
    }
    (void)tax_pct;
}

} // namespace vc
