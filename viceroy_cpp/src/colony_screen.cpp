// colony_screen.cpp -- colony screen composer, per spec/ui/colony_screen.md.
//
// Draw order follows the byte-read composer func_028592 @0x028592 (§3, 12 steps).
// The COLONY.PIK backdrop supplies the static chrome that the composer paints as
// flat region fills (func_02633E) + single-colour 1px frames (0x181F:0xE2) -- there
// are NO bevels anywhere in the colony composer (drawlist §0). Over it we overlay the
// dynamic, byte-cited elements. Citations [C-x] -> spec/ui/colony_screen.md §x.
#include "colony_screen.hpp"
#include <cstdio>
#include <string>
#include <algorithm>

namespace vc {

// ---- byte-cited geometry (spec/ui/colony_screen.md §3, all tier B) ----------------
// Panel background rects the composer fills (func_02633E x,y,w,h). The backdrop already
// carries these as wood panels; kept here as named constants documenting the layout.
namespace L {
    // §3.2 field-production panel  (push 0xE0,0x20,0x48,0x48 @0x0264E9)
    constexpr int FIELD_X = 224, FIELD_Y = 32, FIELD_W = 72, FIELD_H = 72;
    // §3.3 colonist plaza row      (push 0x00,0x82,0x78,0x30 @0x0270D6)
    constexpr int PLAZA_X = 0,   PLAZA_Y = 130, PLAZA_W = 120, PLAZA_H = 48;
    // §3.4 flag panel              (push 0x12F,0x84,0x11,0x2D @0x028540)
    constexpr int FLAG_X = 303,  FLAG_Y = 132, FLAG_W = 17,  FLAG_H = 45;
    // §3.5 surrounding-tile minimap(push 0x79,0x82,0x54,0x30 @0x027DB7)
    constexpr int SURR_X = 121,  SURR_Y = 130, SURR_W = 84,  SURR_H = 48;
    // §3.6 SoL / cargo / msg panel (push 0xD3,0x82,0x5B,0x30 @0x02814F)
    constexpr int SOL_X = 211,   SOL_Y = 130, SOL_W = 91,   SOL_H = 48;
    // §3.9 stockpile bar           (bar 0,179,320,21 @0x0281DB)
    constexpr int BAR_X = 0,     BAR_Y = 179, BAR_W = 320,  BAR_H = 21;
}

// ICONS.SS indices (spec §5): commodity good i -> good+0x17; flag 0x44; surround 0x7B.
constexpr int ICON_GOOD0 = 0x17;     // good 0 (Food) = ICONS 23
constexpr int ICON_FLAG  = 0x44;     // 68
// Stockpile bar: 16 cells, pitch 19 (0x13), icon row y=181 (0xB5), gold readout @ (306,179).
constexpr int BAR_CELLS = 16, BAR_PITCH = 19, BAR_ICON_Y = 181, GOLD_X = 306;

// UI colours (NAMES @COLORS / fonts_and_colors.md): basic green 68, hilite gold 149, white 15.
constexpr uint8_t COL_GOLD = 149, COL_WHITE = 15, COL_FRAME = 68;

// COLONY.PIK is a 320x72 SCENE STRIP (not a full-screen backdrop) -- the composer fills
// the rest of the screen with the wood pattern (func_02633E) and draws panels over it.
constexpr int SCENE_H = 72;

static void blit_icon(Surface& scr, const Sheet& icons, int idx, int x, int y) {
    if (idx >= 0 && idx < (int)icons.frames.size())
        scr.blit_frame(icons.frames[idx], x, y);
}

// Composite a PIK (its own palette) onto the surface (the active gameplay palette) by
// remapping each source index to the nearest active-palette colour. The colony screen
// runs on ONE active palette (the WOODTILE/ICONS gameplay palette); COLONY.PIK was
// authored against a different palette, so its scene strip is translated here.
static void blit_pik_remap(Surface& scr, const IndexedPng& pik, int rows) {
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
    int h = std::min(rows, pik.h);
    for (int y = 0; y < h; ++y)
        for (int x = 0; x < pik.w && x < Surface::W; ++x)
            scr.put(x, y, lut[pik.idx[y * pik.w + x]]);
}

void render_colony_screen(Surface& scr, const IndexedPng& backdrop,
                          const Sheet& woodtile, const Sheet& icons,
                          const Sheet& building, const Sheet& font,
                          const vc::sim::Colony& c, int gold, int tax_pct, int year,
                          const int stockpile[16]) {
    // --- Step 4: full-screen wood region fill (func_02633E, pattern via 0x181F:0x444).
    // WOODTILE.SS (32x24) tiled across the whole screen is that patterned background. [C-3] ---
    if (woodtile.nframes > 0 && woodtile.frames[0].w > 0) {
        const Frame& wt = woodtile.frames[0];
        for (int y = 0; y < Surface::H; y += wt.h)
            for (int x = 0; x < Surface::W; x += wt.w)
                scr.blit_frame(wt, x, y);
    }

    // --- Step 3: terrain scene -- the COLONY.PIK 320x72 strip painted over the top,
    // remapped from its own palette to the active gameplay palette. [C-3.8] ---
    blit_pik_remap(scr, backdrop, SCENE_H);

    // --- Panel frames: the composer outlines each panel with a single-colour 1px frame
    // (0x181F:0xE2, no bevels -- drawlist §0). Draw the byte-cited panel rects. [C-3.2..3.6] ---
    scr.rect_outline(L::FIELD_X, L::FIELD_Y, L::FIELD_W, L::FIELD_H, COL_FRAME);
    scr.rect_outline(L::PLAZA_X, L::PLAZA_Y, L::PLAZA_W, L::PLAZA_H, COL_FRAME);
    scr.rect_outline(L::SURR_X,  L::SURR_Y,  L::SURR_W,  L::SURR_H,  COL_FRAME);
    scr.rect_outline(L::SOL_X,   L::SOL_Y,   L::SOL_W,   L::SOL_H,   COL_FRAME);
    scr.rect_outline(L::FLAG_X,  L::FLAG_Y,  L::FLAG_W,  L::FLAG_H,  COL_FRAME);

    // --- Step 5: title text -- "Pop:/Gold:/Tax:" from LABELS @CTITLE, season @SEASONS. [C-3.1]
    // §3.1: paint origin is TBD (terminal paint past the decoded slice); rendered here at
    // an approximate top band -- tier R for x/y, the string sources are B. ---
    {
        std::string season = (year % 2 == 0) ? "Spring" : "Autumn";   // @SEASONS (2 entries)
        char line[96];
        std::snprintf(line, sizeof line, "%s %d   Pop: %d   Gold: %d   Tax: %d%%",
                      season.c_str(), year, c.population, gold, tax_pct);
        int w = font.frames.empty() ? 0 : scr.text_width(font, line);
        scr.draw_text(font, (Surface::W - w) / 2, 3, line, COL_WHITE);   // R: centered top band
    }

    // --- Step 9: flag panel -- ICONS sprite 0x44 (68) at flag panel +3, frame = nation. [C-3.4]
    // (Single-frame ICONS here; the per-nation frame select is the colony owner.) ---
    blit_icon(scr, icons, ICON_FLAG, L::FLAG_X + 3, L::FLAG_Y + 3);

    // --- Step 12 + §3.9: stockpile bar -- 16 commodity cells, ICONS good+0x17, pitch 19,
    // icon-Y 181; per-cell number = warehouse quantity. Gold readout at (306,179). [C-3.9] ---
    for (int i = 0; i < BAR_CELLS; ++i) {
        int cx = L::BAR_X + i * BAR_PITCH;
        blit_icon(scr, icons, ICON_GOOD0 + i, cx, BAR_ICON_Y);
        char q[8];
        std::snprintf(q, sizeof q, "%d", stockpile ? stockpile[i] : 0);
        scr.draw_text(font, cx + 1, BAR_ICON_Y - 6, q, COL_WHITE);       // quantity above icon
    }
    {
        char gtxt[16]; std::snprintf(gtxt, sizeof gtxt, "%d", gold);
        int gw = scr.text_width(font, gtxt);
        int gx = std::min(GOLD_X, Surface::W - gw - 2);                  // §3.9 readout @306, right-clamped
        scr.draw_text(font, gx, L::BAR_Y, gtxt, COL_GOLD);
    }

    // --- Step 12: buildings loop, 15 slots, BUILDING.SS sprite = type+1. [C-3.7]
    // The byte-exact positions come from the DGROUP table at 0x266 (stride 4) which is NOT
    // yet extracted, so we lay the constructed buildings in an approximate grid (tier R)
    // across the colony plaza area. The sprite index (type+1) and the 15-slot cap ARE B. ---
    {
        int drawn = 0;
        for (int type = 0; type < 15 && drawn < 15; ++type) {
            if (!(c.built_mask & (1ull << type))) continue;
            int gx = 8 + (drawn % 5) * 40;          // R placeholder grid
            int gy = 40 + (drawn / 5) * 28;
            int frame = type + 1;                   // BUILDING.SS = type+1 (B, @0x027087)
            if (frame >= 0 && frame < (int)building.frames.size())
                scr.blit_frame(building.frames[frame], gx, gy);
            ++drawn;
        }
    }

    // Panels §3.2/3.3/3.5/3.6 (field-production / plaza / surrounding-tile / SoL) are carried
    // by the backdrop chrome; their dynamic contents (commodity icons, colonist sprites,
    // surrounding-tile 0x7B loop, SoL/cargo/msg variants) need the per-colonist + per-tile
    // sim model that is P1+ -- left to a follow-up, the rects are documented in L:: above.
    (void)L::FIELD_X; (void)L::PLAZA_X; (void)L::SURR_X; (void)L::SOL_X;
}

} // namespace vc
