// native_assets.cpp -- see native_assets.hpp.
#include "native_assets.hpp"
#include "ff.hpp"        // load_font -- the game's own .FF fonts when present
#include "pik.hpp"       // load_pik -- the game's own .PIK backgrounds when present
#define STB_IMAGE_IMPLEMENTATION
#define STBI_ONLY_PNG
#define STBI_ONLY_BMP    // the asset files are 24-bit BMPs (PNG = fallback)
#include "stb_image.h"   // vendored (third_party/stb) -- no libpng dependency
#include <cstdio>
#include <cstring>
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <unordered_map>

namespace vc {

// ---------- tiny scanners for the machine-generated JSON files ----------
// (dependency-light on purpose: these files are emitted by our own tools with
// a fixed shape; a full JSON parser lives in forge/, which src/ must not need.)

static std::string slurp(const std::string& path) {
    std::ifstream f(path, std::ios::binary);
    if (!f) throw std::runtime_error("cannot open " + path);
    std::ostringstream ss;
    ss << f.rdbuf();
    return ss.str();
}

// Every occurrence of `"key":<int>` in order of appearance.
static std::vector<int> ints_after(const std::string& s, const std::string& key) {
    std::vector<int> out;
    const std::string pat = "\"" + key + "\":";
    size_t p = 0;
    while ((p = s.find(pat, p)) != std::string::npos) {
        p += pat.size();
        while (p < s.size() && (s[p] == ' ' || s[p] == '\t')) ++p;
        out.push_back(std::atoi(s.c_str() + p));
    }
    return out;
}

void load_palette_json(const std::string& path, uint8_t pal[768]) {
    const std::string s = slurp(path);
    std::vector<int> idx = ints_after(s, "index"), r = ints_after(s, "r"),
                     g = ints_after(s, "g"), b = ints_after(s, "b");
    if (idx.size() != 256 || r.size() != 256 || g.size() != 256 || b.size() != 256)
        throw std::runtime_error(path + ": expected 256 palette entries, got " +
                                 std::to_string(idx.size()));
    for (size_t i = 0; i < 256; ++i) {
        int k = idx[i];
        if (k < 0 || k > 255) throw std::runtime_error(path + ": bad index");
        pal[k * 3 + 0] = (uint8_t)r[i];
        pal[k * 3 + 1] = (uint8_t)g[i];
        pal[k * 3 + 2] = (uint8_t)b[i];
    }
}

// ---------- quantizing PNG reader ----------

IndexedPng read_png_quantized(const std::string& path, const uint8_t pal[768],
                              int* strays) {
    // The project's asset files are 24-bit BMPs (transparency = the magenta
    // colorkey below); a .png with the same stem is accepted as a fallback so
    // older project folders keep loading. stb_image decodes both.
    int w = 0, h = 0, comp = 0;
    unsigned char* px = nullptr;
    size_t dot = path.rfind('.');
    if (dot != std::string::npos) {
        std::string ext = path.substr(dot);
        if (ext == ".png" || ext == ".bmp") {
            std::string sib = path.substr(0, dot) + (ext == ".png" ? ".bmp" : ".png");
            px = stbi_load((ext == ".png" ? sib : path).c_str(), &w, &h, &comp, 4);
            if (!px) px = stbi_load((ext == ".png" ? path : sib).c_str(), &w, &h, &comp, 4);
        }
    }
    if (!px) px = stbi_load(path.c_str(), &w, &h, &comp, 4);
    if (!px) throw std::runtime_error("cannot open/decode " + path);

    IndexedPng out;
    out.w = w;
    out.h = h;
    out.idx.resize((size_t)w * h);
    for (int i = 0; i < 768; ++i) out.pal[i] = pal[i];

    // exact-match lookup: RGB24 -> index (first palette occurrence wins)
    std::unordered_map<uint32_t, uint8_t> lut;
    for (int i = 255; i >= 0; --i)
        lut[(uint32_t)pal[i * 3] << 16 | (uint32_t)pal[i * 3 + 1] << 8 | pal[i * 3 + 2]] =
            (uint8_t)i;

    int miss = 0;
    for (size_t p = 0; p < (size_t)w * h; ++p) {
        uint8_t r = px[p * 4], g = px[p * 4 + 1], b = px[p * 4 + 2], a = px[p * 4 + 3];
        uint8_t v;
        if (a < 128 || (r == 255 && g == 0 && b == 255)) {
            // alpha (PNG) or the pure-magenta colorkey (24-bit BMP has no
            // alpha channel; 255,0,255 is not a VICEROY.PAL color and no
            // asset uses it opaquely -- verified repo-wide 2026-07-04)
            v = SS_TRANSPARENT;
        } else {
            auto it = lut.find((uint32_t)r << 16 | (uint32_t)g << 8 | b);
            if (it != lut.end()) {
                v = it->second;
            } else {
                // stray (documented: <40 px repo-wide) -> nearest entry
                int best = 0;
                long bd = 1L << 30;
                for (int i = 0; i < 256; ++i) {
                    long dr = r - pal[i * 3], dg = g - pal[i * 3 + 1],
                         db = b - pal[i * 3 + 2];
                    long d = dr * dr + dg * dg + db * db;
                    if (d < bd) { bd = d; best = i; }
                }
                v = (uint8_t)best;
                ++miss;
            }
        }
        out.idx[p] = v;
    }
    stbi_image_free(px);
    if (strays) *strays += miss;
    return out;
}

// ---------- sheet builders ----------

static Frame cut(const IndexedPng& img, int x0, int y0, int w, int h) {
    Frame f;
    f.x = 0; f.y = 0; f.w = w; f.h = h;
    f.px.assign((size_t)w * h, SS_TRANSPARENT);
    for (int y = 0; y < h; ++y)
        for (int x = 0; x < w; ++x) {
            int sx = x0 + x, sy = y0 + y;
            if (sx < img.w && sy < img.h)
                f.px[(size_t)y * w + x] = img.idx[(size_t)sy * img.w + sx];
        }
    return f;
}

Sheet strip_sheet(const IndexedPng& img, int cell_w, int cell_h) {
    Sheet s;
    for (int i = 0; i < 768; ++i) s.pal[i] = img.pal[i];
    int n = img.w / cell_w;
    s.nframes = n;
    s.frames.reserve(n);
    for (int i = 0; i < n; ++i)
        s.frames.push_back(cut(img, i * cell_w, 0, cell_w, cell_h));
    return s;
}

Sheet rect_sheet(const IndexedPng& img, const std::vector<StripRect>& rects) {
    Sheet s;
    for (int i = 0; i < 768; ++i) s.pal[i] = img.pal[i];
    s.nframes = (int)rects.size();
    s.frames.reserve(rects.size());
    for (const StripRect& r : rects)
        s.frames.push_back(cut(img, r.x, 0, r.w, r.h ? r.h : img.h));
    return s;
}

// ---------- baked 5x7 font ----------
// Classic 5x7 dot-matrix glyphs, ASCII 32..126; each glyph = 7 row bytes,
// bit 4 = leftmost pixel. Authored here (not extracted); the game font
// FONTTINY.FF is absent from the repo -- APPROXIMATION, see header.
static const uint8_t F57[95][7] = {
    {0x00,0x00,0x00,0x00,0x00,0x00,0x00}, // ' '
    {0x04,0x04,0x04,0x04,0x04,0x00,0x04}, // !
    {0x0A,0x0A,0x0A,0x00,0x00,0x00,0x00}, // "
    {0x0A,0x0A,0x1F,0x0A,0x1F,0x0A,0x0A}, // #
    {0x04,0x0F,0x14,0x0E,0x05,0x1E,0x04}, // $
    {0x18,0x19,0x02,0x04,0x08,0x13,0x03}, // %
    {0x0C,0x12,0x14,0x08,0x15,0x12,0x0D}, // &
    {0x0C,0x04,0x08,0x00,0x00,0x00,0x00}, // '
    {0x02,0x04,0x08,0x08,0x08,0x04,0x02}, // (
    {0x08,0x04,0x02,0x02,0x02,0x04,0x08}, // )
    {0x00,0x04,0x15,0x0E,0x15,0x04,0x00}, // *
    {0x00,0x04,0x04,0x1F,0x04,0x04,0x00}, // +
    {0x00,0x00,0x00,0x00,0x0C,0x04,0x08}, // ,
    {0x00,0x00,0x00,0x1F,0x00,0x00,0x00}, // -
    {0x00,0x00,0x00,0x00,0x00,0x0C,0x0C}, // .
    {0x00,0x01,0x02,0x04,0x08,0x10,0x00}, // /
    {0x0E,0x11,0x13,0x15,0x19,0x11,0x0E}, // 0
    {0x04,0x0C,0x04,0x04,0x04,0x04,0x0E}, // 1
    {0x0E,0x11,0x01,0x02,0x04,0x08,0x1F}, // 2
    {0x1F,0x02,0x04,0x02,0x01,0x11,0x0E}, // 3
    {0x02,0x06,0x0A,0x12,0x1F,0x02,0x02}, // 4
    {0x1F,0x10,0x1E,0x01,0x01,0x11,0x0E}, // 5
    {0x06,0x08,0x10,0x1E,0x11,0x11,0x0E}, // 6
    {0x1F,0x01,0x02,0x04,0x08,0x08,0x08}, // 7
    {0x0E,0x11,0x11,0x0E,0x11,0x11,0x0E}, // 8
    {0x0E,0x11,0x11,0x0F,0x01,0x02,0x0C}, // 9
    {0x00,0x0C,0x0C,0x00,0x0C,0x0C,0x00}, // :
    {0x00,0x0C,0x0C,0x00,0x0C,0x04,0x08}, // ;
    {0x02,0x04,0x08,0x10,0x08,0x04,0x02}, // <
    {0x00,0x00,0x1F,0x00,0x1F,0x00,0x00}, // =
    {0x08,0x04,0x02,0x01,0x02,0x04,0x08}, // >
    {0x0E,0x11,0x01,0x02,0x04,0x00,0x04}, // ?
    {0x0E,0x11,0x01,0x0D,0x15,0x15,0x0E}, // @
    {0x0E,0x11,0x11,0x11,0x1F,0x11,0x11}, // A
    {0x1E,0x11,0x11,0x1E,0x11,0x11,0x1E}, // B
    {0x0E,0x11,0x10,0x10,0x10,0x11,0x0E}, // C
    {0x1C,0x12,0x11,0x11,0x11,0x12,0x1C}, // D
    {0x1F,0x10,0x10,0x1E,0x10,0x10,0x1F}, // E
    {0x1F,0x10,0x10,0x1E,0x10,0x10,0x10}, // F
    {0x0E,0x11,0x10,0x17,0x11,0x11,0x0F}, // G
    {0x11,0x11,0x11,0x1F,0x11,0x11,0x11}, // H
    {0x0E,0x04,0x04,0x04,0x04,0x04,0x0E}, // I
    {0x07,0x02,0x02,0x02,0x02,0x12,0x0C}, // J
    {0x11,0x12,0x14,0x18,0x14,0x12,0x11}, // K
    {0x10,0x10,0x10,0x10,0x10,0x10,0x1F}, // L
    {0x11,0x1B,0x15,0x15,0x11,0x11,0x11}, // M
    {0x11,0x11,0x19,0x15,0x13,0x11,0x11}, // N
    {0x0E,0x11,0x11,0x11,0x11,0x11,0x0E}, // O
    {0x1E,0x11,0x11,0x1E,0x10,0x10,0x10}, // P
    {0x0E,0x11,0x11,0x11,0x15,0x12,0x0D}, // Q
    {0x1E,0x11,0x11,0x1E,0x14,0x12,0x11}, // R
    {0x0F,0x10,0x10,0x0E,0x01,0x01,0x1E}, // S
    {0x1F,0x04,0x04,0x04,0x04,0x04,0x04}, // T
    {0x11,0x11,0x11,0x11,0x11,0x11,0x0E}, // U
    {0x11,0x11,0x11,0x11,0x11,0x0A,0x04}, // V
    {0x11,0x11,0x11,0x15,0x15,0x15,0x0A}, // W
    {0x11,0x11,0x0A,0x04,0x0A,0x11,0x11}, // X
    {0x11,0x11,0x11,0x0A,0x04,0x04,0x04}, // Y
    {0x1F,0x01,0x02,0x04,0x08,0x10,0x1F}, // Z
    {0x0E,0x08,0x08,0x08,0x08,0x08,0x0E}, // [
    {0x00,0x10,0x08,0x04,0x02,0x01,0x00}, // backslash
    {0x0E,0x02,0x02,0x02,0x02,0x02,0x0E}, // ]
    {0x04,0x0A,0x11,0x00,0x00,0x00,0x00}, // ^
    {0x00,0x00,0x00,0x00,0x00,0x00,0x1F}, // _
    {0x08,0x04,0x02,0x00,0x00,0x00,0x00}, // `
    {0x00,0x00,0x0E,0x01,0x0F,0x11,0x0F}, // a
    {0x10,0x10,0x16,0x19,0x11,0x11,0x1E}, // b
    {0x00,0x00,0x0E,0x10,0x10,0x11,0x0E}, // c
    {0x01,0x01,0x0D,0x13,0x11,0x11,0x0F}, // d
    {0x00,0x00,0x0E,0x11,0x1F,0x10,0x0E}, // e
    {0x06,0x09,0x08,0x1C,0x08,0x08,0x08}, // f
    {0x00,0x0F,0x11,0x11,0x0F,0x01,0x0E}, // g
    {0x10,0x10,0x16,0x19,0x11,0x11,0x11}, // h
    {0x04,0x00,0x0C,0x04,0x04,0x04,0x0E}, // i
    {0x02,0x00,0x06,0x02,0x02,0x12,0x0C}, // j
    {0x10,0x10,0x12,0x14,0x18,0x14,0x12}, // k
    {0x0C,0x04,0x04,0x04,0x04,0x04,0x0E}, // l
    {0x00,0x00,0x1A,0x15,0x15,0x11,0x11}, // m
    {0x00,0x00,0x16,0x19,0x11,0x11,0x11}, // n
    {0x00,0x00,0x0E,0x11,0x11,0x11,0x0E}, // o
    {0x00,0x00,0x1E,0x11,0x1E,0x10,0x10}, // p
    {0x00,0x00,0x0D,0x13,0x0F,0x01,0x01}, // q
    {0x00,0x00,0x16,0x19,0x10,0x10,0x10}, // r
    {0x00,0x00,0x0E,0x10,0x0E,0x01,0x1E}, // s
    {0x08,0x08,0x1C,0x08,0x08,0x09,0x06}, // t
    {0x00,0x00,0x11,0x11,0x11,0x13,0x0D}, // u
    {0x00,0x00,0x11,0x11,0x11,0x0A,0x04}, // v
    {0x00,0x00,0x11,0x11,0x15,0x15,0x0A}, // w
    {0x00,0x00,0x11,0x0A,0x04,0x0A,0x11}, // x
    {0x00,0x00,0x11,0x11,0x0F,0x01,0x0E}, // y
    {0x00,0x00,0x1F,0x02,0x04,0x08,0x1F}, // z
    {0x02,0x04,0x04,0x08,0x04,0x04,0x02}, // {
    {0x04,0x04,0x04,0x04,0x04,0x04,0x04}, // |
    {0x08,0x04,0x04,0x02,0x04,0x04,0x08}, // }
    {0x00,0x00,0x08,0x15,0x02,0x00,0x00}, // ~
};

Sheet baked_font() {
    Sheet s;
    s.nframes = 127;
    s.frames.resize(127);
    for (int c = 32; c < 127; ++c) {
        Frame f;
        f.w = 5; f.h = 7;
        f.px.assign(5 * 7, SS_TRANSPARENT);
        for (int y = 0; y < 7; ++y)
            for (int x = 0; x < 5; ++x)
                if (F57[c - 32][y] & (0x10 >> x))
                    f.px[y * 5 + x] = 15;   // any non-transparent index; draw_text recolors
        // narrow blank for space so tracking looks right
        if (c == ' ') { f.w = 3; f.px.assign(3 * 7, SS_TRANSPARENT); }
        s.frames[c] = std::move(f);
    }
    return s;
}

// ---------- one-call boot ----------

IndexedPng load_pik_bg(const std::string& root, const std::string& name,
                       const uint8_t pal[768]) {
    return read_png_quantized(root + "/docs/atlas/pik/" + name + ".png", pal);
}

NativeAssets load_native_assets(const std::string& root) {
    NativeAssets a;
    load_palette_json(root + "/data_extracted/palette.json", a.pal);
    const std::string ts = root + "/data_extracted/tileset/";

    a.terrain = strip_sheet(read_png_quantized(ts + "terrain16.png", a.pal, &a.strays), 16, 16);
    a.phys    = strip_sheet(read_png_quantized(ts + "phys0.png",     a.pal, &a.strays), 16, 16);
    a.units   = strip_sheet(read_png_quantized(ts + "units.png",     a.pal, &a.strays), 16, 16);
    {   // buildings.png: 48 cells of the FULL 56x42 native content window (the
        // BUILDING atlas is 1x, not 2x -- extract_buildingset.py 2026-07-04).
        // The in-window sprite position is the frame's own draw offset, so
        // consumers blit cells at the raw plot-table (x,y) with no extra +8.
        // The strip is ALWAYS 48 cells, so infer the cell size from the image
        // itself -- a project carrying the older 28x24-cell strip still loads
        // (at the old art quality) instead of shredding into misaligned cells.
        IndexedPng b = read_png_quantized(ts + "buildings.png", a.pal, &a.strays);
        int cw = b.w / 48;
        a.buildings = strip_sheet(b, cw > 0 ? cw : 56, b.h > 0 ? b.h : 42);
    }

    {   // icons: variable-width rects from icons.json ("frame","w","h","x" per entry)
        const std::string js = slurp(ts + "icons.json");
        std::vector<int> xs = ints_after(js, "x"), ws = ints_after(js, "w"),
                         hs = ints_after(js, "h");
        // the json carries top-level "count"/"height" too; the per-frame lists
        // line up because only frame objects carry "x"/"w" -- "h" also appears
        // per frame; sizes must match.
        if (xs.size() != ws.size() || xs.size() < 100)
            throw std::runtime_error("icons.json: unexpected shape");
        IndexedPng img = read_png_quantized(ts + "icons.png", a.pal, &a.strays);
        std::vector<StripRect> rects(xs.size());
        for (size_t i = 0; i < xs.size(); ++i)
            rects[i] = {xs[i], ws[i], i < hs.size() ? hs[i] : img.h};
        a.icons = rect_sheet(img, rects);
    }

    {   // woodtile: 32x24 crop of the WOODPANL.PIK sidebar background
        IndexedPng wp = load_pik_bg(root, "WOODPANL", a.pal);
        Sheet s;
        for (int i = 0; i < 768; ++i) s.pal[i] = a.pal[i];
        s.nframes = 1;
        s.frames.push_back(cut(wp, 32, 40, 96, 72));
        a.woodtile = std::move(s);
    }

    // Fonts: prefer the game's own FONTTINY.FF when the project carries the
    // user's game copy (raw/COLONIZE, same layout the extractors read) -- the
    // repo ships only decoded art, and .FF fonts aren't part of that set, so
    // the baked 5x7 stands in until the real file is present.
    a.font = baked_font();
    for (const char* dir : {"/raw/COLONIZE/", "/raw/", "/"}) {
        try {
            a.font = load_font(root + dir + "FONTTINY.FF");
            a.font_real = true;
            break;
        } catch (const std::exception&) {}
    }

    // Raw sheet overrides: same drop-in policy for the sprite sheets. The
    // decoded tileset PNGs preserve the ssdec frame ids (see the header), so
    // the original .SS decodes are index-compatible 1:1 -- except BUILDING,
    // whose EXE sheet is def_id+1 (colony_screen.md 0.2): the raw override
    // shifts one frame down to stay in the catalog's 0-based space.
    auto try_ss = [&](Sheet& dst, const char* name, int drop_first) {
        for (const char* dir : {"/raw/COLONIZE/", "/raw/", "/"}) {
            try {
                Sheet s = load_sheet(root + dir + name);
                if (s.nframes <= drop_first) continue;
                if (drop_first > 0) {
                    s.frames.erase(s.frames.begin(),
                                   s.frames.begin() + drop_first);
                    s.nframes -= drop_first;
                }
                dst = std::move(s);
                ++a.raw_overrides;
                return;
            } catch (const std::exception&) {}
        }
    };
    try_ss(a.terrain, "TERRAIN.SS", 0);
    try_ss(a.phys, "PHYS0.SS", 0);
    try_ss(a.icons, "ICONS.SS", 0);
    try_ss(a.buildings, "BUILDING.SS", 1);
    // (UNITS has no own sheet -- the unit figures were cut from ICONS.SS.)
    for (const char* dir : {"/raw/COLONIZE/", "/raw/", "/"}) {
        try {                                   // real wood grain for the chrome
            PikImage wp = load_pik(root + dir + "WOODPANL.PIK", a.pal);
            IndexedPng img;
            img.w = wp.w;
            img.h = wp.h;
            img.idx = std::move(wp.idx);
            Sheet s;
            for (int i = 0; i < 768; ++i) s.pal[i] = a.pal[i];
            s.nframes = 1;
            s.frames.push_back(cut(img, 32, 40, 96, 72));
            a.woodtile = std::move(s);
            ++a.raw_overrides;
            break;
        } catch (const std::exception&) {}
    }
    return a;
}

} // namespace vc
