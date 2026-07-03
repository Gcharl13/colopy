// popup_render.cpp -- see popup_render.hpp for the spec/ui/popups.md §2 map.
#include "popup_render.hpp"
#include <algorithm>

namespace vc {
namespace {

// A body/choice line with the {highlight} braces stripped (measurement +
// non-highlight rendering paths both need the bare text).
std::string strip_braces(const std::string& s) {
    std::string out;
    out.reserve(s.size());
    for (char c : s)
        if (c != '{' && c != '}') out += c;
    return out;
}

// The four chrome colors, resolved against the active palette once per draw.
// RGB targets are the web frame engine's (the reference implementation of the
// same byte-verified geometry): border 0x5a3d20, inset 0x2e1f10, ink 0x1a1206,
// highlight 0xfff6d8.
struct Chrome {
    uint8_t border, inset, ink, hi;
};
Chrome chrome_for(const uint8_t pal[768]) {
    return {nearest_pal_index(pal, 0x5a, 0x3d, 0x20),
            nearest_pal_index(pal, 0x2e, 0x1f, 0x10),
            nearest_pal_index(pal, 0x1a, 0x12, 0x06),
            nearest_pal_index(pal, 0xff, 0xf6, 0xd8)};
}

// Draw one line honoring {braces}: bracketed spans use the highlight color.
void draw_marked(Surface& scr, const Sheet& font, int x, int y,
                 const std::string& s, uint8_t ink, uint8_t hi) {
    int cx = x;
    bool mark = false;
    std::string run;
    auto flush = [&] {
        if (run.empty()) return;
        scr.draw_text(font, cx, y, run, mark ? hi : ink);
        cx += scr.text_width(font, run) + 1;   // keep the 1px inter-glyph pace
        run.clear();
    };
    for (char c : s) {
        if (c == '{' || c == '}') { flush(); mark = (c == '{'); continue; }
        run += c;
    }
    flush();
}

}  // namespace

uint8_t nearest_pal_index(const uint8_t pal[768], int r, int g, int b) {
    int best = 0;
    long best_d = 1 << 30;
    for (int i = 0; i < 256; ++i) {
        long dr = pal[i * 3] - r, dg = pal[i * 3 + 1] - g, db = pal[i * 3 + 2] - b;
        long d = dr * dr + dg * dg + db * db;
        if (d < best_d) { best_d = d; best = i; }
    }
    return (uint8_t)best;
}

PopupLayout popup_layout(const Sheet& font, const PopupSpec& p) {
    PopupLayout L;
    Surface probe;   // text_width is const state-free, but lives on Surface
    int longest = 0;
    for (const std::string& l : p.lines)
        longest = std::max(longest, probe.text_width(font, strip_braces(l)));
    for (const std::string& c : p.choices)
        longest = std::max(longest, probe.text_width(font, strip_braces(c)));
    L.content_w = std::max({80, longest + 10, p.box_w});          // @0x06D392
    L.w = L.content_w + 6;                                        // 3px border x2
    int nl = (int)p.lines.size(), nc = (int)p.choices.size();
    L.choice_y0 = 5 + nl * PopupLayout::ROW + 3;
    L.h = nl * PopupLayout::ROW + (nc ? nc * PopupLayout::CHROW + 3 : 0) + 6 + 10;
    L.x = p.px >= 0 ? p.px : (Surface::W - L.w) / 2;              // @0x06D522
    L.y = p.py >= 0 ? p.py : (Surface::H - L.h) / 2;              // @0x06D53B
    if (L.x + L.w > Surface::W) L.x = Surface::W - L.w;           // clamp @0x06D563
    if (L.y + L.h > Surface::H) L.y = Surface::H - L.h;
    if (L.x < 0) L.x = 0;
    if (L.y < 0) L.y = 0;
    return L;
}

void popup_choice_rect(const PopupLayout& L, int i, int& x, int& y, int& w, int& h) {
    x = L.x + 3 + 5;
    y = L.y + 3 + L.choice_y0 + i * PopupLayout::CHROW;
    w = L.content_w - 10;
    h = PopupLayout::ROW;
}

void render_popup(Surface& scr, const IndexedPng& woodpanl, const Sheet& font,
                  const PopupSpec& p, const PopupLayout& L) {
    const Chrome C = chrome_for(scr.pal);

    // body: WOODPANL tiled in SCREEN space (the web tiles the 320x200 image
    // over the full screen, so the panel grain stays put wherever the box is)
    for (int y = L.y; y < L.y + L.h; ++y)
        for (int x = L.x; x < L.x + L.w; ++x) {
            if (x < 0 || y < 0 || x >= Surface::W || y >= Surface::H) continue;
            uint8_t px = woodpanl.w > 0
                             ? woodpanl.idx[(size_t)(y % woodpanl.h) * woodpanl.w +
                                            (x % woodpanl.w)]
                             : C.inset;
            scr.put(x, y, px);
        }
    // 3px wood border + 2px darker inset (func_06C520 +0x46/+0x48)
    for (int t = 0; t < 3; ++t)
        scr.rect_outline(L.x + t, L.y + t, L.w - 2 * t, L.h - 2 * t, C.border);
    for (int t = 3; t < 5; ++t)
        scr.rect_outline(L.x + t, L.y + t, L.w - 2 * t, L.h - 2 * t, C.inset);

    // body text: 5px inset inside the border, 8px row pitch
    const int bx = L.x + 3 + 5, by = L.y + 3 + 5;
    for (int i = 0; i < (int)p.lines.size(); ++i)
        draw_marked(scr, font, bx, by + i * PopupLayout::ROW, p.lines[i],
                    C.ink, C.hi);

    // choice rows: centered, boxed; the highlighted row gets the light fill
    for (int i = 0; i < (int)p.choices.size(); ++i) {
        int cx, cy, cw, ch;
        popup_choice_rect(L, i, cx, cy, cw, ch);
        if (i == p.highlight) scr.fill_rect(cx, cy, cw, ch, C.hi);
        scr.rect_outline(cx, cy, cw, ch, C.inset);
        std::string bare = strip_braces(p.choices[i]);
        int tw = scr.text_width(font, bare);
        scr.draw_text(font, cx + (cw - tw) / 2, cy + 1, bare,
                      i == p.highlight ? C.inset : C.ink);
    }

    // speaker portrait above the box's top-left corner; woodcut scene above
    // the top-right (§2.7 channels; landing pixel adaptation, see header)
    if (p.portrait)
        scr.blit_frame(*p.portrait, L.x - 2, L.y - (p.portrait->h + 2));
    if (p.scene)
        scr.blit_frame(*p.scene, L.x + L.w - p.scene->w + 2,
                       L.y - (p.scene->h + 2));
}

} // namespace vc
