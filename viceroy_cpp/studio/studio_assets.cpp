// studio_assets.cpp -- shared native assets + sprite resolution for the panels.
#include "studio_shared.hpp"
#include "pik.hpp"       // load_pik: the game's own backgrounds when present
#include "../drydock/core/store.hpp"
#include <cmath>
#include <cstring>

namespace studio {

StudioAssets& assets() {
    static StudioAssets a;
    return a;
}

bool assets_ensure() {
    StudioAssets& a = assets();
    if (a.tried) return a.ok;
    a.tried = true;
    try {
        a.nat = vc::load_native_assets(".");
        a.ok = true;
    } catch (const std::exception& e) {
        a.err = e.what();
        a.ok = false;
    }
    return a.ok;
}

const vc::IndexedPng* atlas_file(const std::string& rel) {
    StudioAssets& a = assets();
    if (!a.ok) return nullptr;
    auto it = a.files.find(rel);
    if (it != a.files.end()) return it->second.w > 0 ? &it->second : nullptr;
    vc::IndexedPng img;
    // Prefer the game's own .PIK when the project carries the user's copy
    // (raw/COLONIZE) -- indices are palette-native, no quantization needed.
    if (rel.rfind("pik/", 0) == 0 && rel.size() > 8) {
        std::string name = rel.substr(4, rel.size() - 8);   // strip pik/ + .png
        for (const char* dir : {"raw/COLONIZE/", "raw/"}) {
            try {
                vc::PikImage p = vc::load_pik(dir + name + ".PIK", a.nat.pal);
                img.w = p.w;
                img.h = p.h;
                img.idx = std::move(p.idx);
                break;
            } catch (const std::exception&) {}
        }
    }
    if (img.w == 0)
        try {
            img = vc::read_png_quantized("docs/atlas/" + rel, a.nat.pal);
        } catch (const std::exception&) {
            img = {};   // cache the miss (w=0) so we don't re-stat every frame
        }
    auto& slot = a.files[rel] = std::move(img);
    return slot.w > 0 ? &slot : nullptr;
}

const vc::Sheet* tileset_sheet(const std::string& sheet) {
    StudioAssets& a = assets();
    if (!a.ok) return nullptr;
    if (sheet == "TERRAIN")  return &a.nat.terrain;
    if (sheet == "PHYS0")    return &a.nat.phys;
    if (sheet == "UNITS")    return &a.nat.units;
    if (sheet == "BUILDING") return &a.nat.buildings;
    if (sheet == "ICONS")    return &a.nat.icons;
    return nullptr;
}

const vc::Frame* sheet_window(const std::string& sheet) {
    StudioAssets& a = assets();
    if (!a.ok) return nullptr;
    auto it = a.windows.find(sheet);
    if (it != a.windows.end()) return it->second.w > 0 ? &it->second : nullptr;
    vc::Frame f{};
    // the game's own .SS first: the REAL portrait/scene at native size
    for (const char* dir : {"raw/COLONIZE/", "raw/"}) {
        try {
            vc::Sheet s = vc::load_sheet(std::string(dir) + sheet + ".SS");
            if (s.nframes > 0 && s.frames[0].w > 0) {
                auto& slot = a.windows[sheet] = s.frames[0];
                return &slot;
            }
        } catch (const std::exception&) {}
    }
    const vc::IndexedPng* img = atlas_file("sprites/atlas_" + sheet + ".png");
    // The committed contact sheets have a label band; the first cell's content
    // window is PNG rect (1,39) 56x42 (the web wfPortrait geometry). The DRAW
    // SCALE varies per sheet (measured 2026-07-04): atlas_ICONS is a clean 2x
    // pixel-double (parity blockiness 1.000) while atlas_BUILDING / atlas_PARCH
    // are native 1x. Detect via 2x2-block uniformity: >=0.9 means 2x (sample
    // every second pixel at the best parity), else copy 1:1. Either way the
    // cell pads the real frame with OPAQUE BLACK, so tighten to the non-black
    // bounding box -- otherwise tiles (PARCH) carry black gutters.
    if (img && img->w >= 57 && img->h >= 81) {
        const int WW = 56, WH = 42;
        auto at = [&](int x, int y) {
            return img->idx[(size_t)(39 + y) * img->w + (1 + x)];
        };
        auto is_pad = [&](uint8_t i) {
            if (i == vc::SS_TRANSPARENT) return true;
            const uint8_t* p = &a.nat.pal[i * 3];
            return p[0] == 0 && p[1] == 0 && p[2] == 0;
        };
        float best = -1.0f;
        int bdx = 0, bdy = 0;
        for (int dy = 0; dy < 2; ++dy)
            for (int dx = 0; dx < 2; ++dx) {
                int ok = 0, tot = 0;
                for (int y = dy; y < WH - 1; y += 2)
                    for (int x = dx; x < WW - 1; x += 2) {
                        uint8_t v = at(x, y);
                        tot += 3;
                        ok += (at(x + 1, y) == v) + (at(x, y + 1) == v) +
                              (at(x + 1, y + 1) == v);
                    }
                float s = tot ? (float)ok / tot : 0.0f;
                if (s > best) { best = s; bdx = dx; bdy = dy; }
            }
        std::vector<uint8_t> win;
        int ww, wh;
        if (best >= 0.9f) {              // 2x sheet: parity-aligned downsample
            ww = (WW - bdx) / 2;
            wh = (WH - bdy) / 2;
            win.resize((size_t)ww * wh);
            for (int y = 0; y < wh; ++y)
                for (int x = 0; x < ww; ++x)
                    win[(size_t)y * ww + x] = at(bdx + 2 * x, bdy + 2 * y);
        } else {                         // native 1x sheet: copy as-is
            ww = WW; wh = WH;
            win.resize((size_t)ww * wh);
            for (int y = 0; y < wh; ++y)
                for (int x = 0; x < ww; ++x)
                    win[(size_t)y * ww + x] = at(x, y);
        }
        int x0 = ww, y0 = wh, x1 = -1, y1 = -1;
        for (int y = 0; y < wh; ++y)
            for (int x = 0; x < ww; ++x)
                if (!is_pad(win[(size_t)y * ww + x])) {
                    if (x < x0) x0 = x;
                    if (y < y0) y0 = y;
                    if (x > x1) x1 = x;
                    if (y > y1) y1 = y;
                }
        if (x1 >= x0 && y1 >= y0) {
            f.w = x1 - x0 + 1;
            f.h = y1 - y0 + 1;
            f.x = f.y = 0;
            f.px.resize((size_t)f.w * f.h);
            for (int y = 0; y < f.h; ++y)
                for (int x = 0; x < f.w; ++x)
                    f.px[(size_t)y * f.w + x] = win[(size_t)(y0 + y) * ww + (x0 + x)];
        }
    }
    auto& slot = a.windows[sheet] = std::move(f);
    return slot.w > 0 ? &slot : nullptr;
}

namespace {

void checker_fill(vc::Image& out, int w, int h) {
    out.w = w; out.h = h;
    out.rgb.assign((size_t)w * h * 3, 0);
    for (int y = 0; y < h; ++y)
        for (int x = 0; x < w; ++x) {
            uint8_t v = (((x >> 2) + (y >> 2)) & 1) ? 52 : 40;
            uint8_t* p = &out.rgb[((size_t)y * w + x) * 3];
            p[0] = p[1] = v; p[2] = v + 6;
        }
}

void blit_indexed(vc::Image& out, const uint8_t* idx, int w, int h,
                  const uint8_t pal[768]) {
    for (int y = 0; y < h && y < out.h; ++y)
        for (int x = 0; x < w && x < out.w; ++x) {
            uint8_t i = idx[(size_t)y * w + x];
            if (i == vc::SS_TRANSPARENT) continue;
            uint8_t* p = &out.rgb[((size_t)y * out.w + x) * 3];
            p[0] = pal[i * 3]; p[1] = pal[i * 3 + 1]; p[2] = pal[i * 3 + 2];
        }
}

std::string rec_str(const drydock::Record& r, const char* field) {
    for (const auto& f : r.fields)
        if (f.name == field &&
            (f.value.kind == drydock::ValKind::Str ||
             f.value.kind == drydock::ValKind::Token))
            return f.value.s;
    return "";
}
long long rec_int(const drydock::Record& r, const char* field, long long dflt) {
    for (const auto& f : r.fields)
        if (f.name == field && f.value.kind == drydock::ValKind::Int)
            return f.value.i;
    return dflt;
}

}  // namespace

bool sprite_image(const drydock::Record& r, vc::Image& out,
                  int* native_w, int* native_h) {
    if (!assets_ensure()) return false;
    StudioAssets& a = assets();
    const std::string kind  = rec_str(r, "kind");
    const std::string sheet = rec_str(r, "sheet");
    const std::string file  = rec_str(r, "file");

    if (const vc::Sheet* sh = tileset_sheet(sheet)) {       // frame-based kinds
        int fi = (int)rec_int(r, "frame", -1);
        if (fi < 0 || fi >= sh->nframes) return false;
        const vc::Frame& f = sh->frames[fi];
        if (f.w <= 0 || f.h <= 0) return false;
        checker_fill(out, f.w, f.h);
        blit_indexed(out, f.px.data(), f.w, f.h, a.nat.pal);
        if (native_w) *native_w = f.w;
        if (native_h) *native_h = f.h;
        return true;
    }
    if (kind == "portrait" || kind == "woodcut") {          // contact-sheet cell
        if (const vc::Frame* f = sheet_window(sheet)) {
            checker_fill(out, f->w, f->h);
            blit_indexed(out, f->px.data(), f->w, f->h, a.nat.pal);
            if (native_w) *native_w = f->w;
            if (native_h) *native_h = f->h;
            return true;
        }
        return false;
    }
    if (!file.empty()) {                                    // whole-file kinds
        if (const vc::IndexedPng* img = atlas_file(file)) {
            checker_fill(out, img->w, img->h);
            blit_indexed(out, img->idx.data(), img->w, img->h, a.nat.pal);
            if (native_w) *native_w = img->w;
            if (native_h) *native_h = img->h;
            return true;
        }
    }
    return false;
}

// --------------------------------------------------------- crisp rendering
void pixel_image(const Texture& t, const ImVec2& size) {
    ImGuiPlatformIO& pio = ImGui::GetPlatformIO();
    ImDrawList* dl = ImGui::GetWindowDrawList();
    // DX11 backend: swap to the point sampler for this image, restore after.
    // SDL backend: per-texture nearest is already set at creation.
    if (pio.DrawCallback_SetSamplerNearest)
        dl->AddCallback(pio.DrawCallback_SetSamplerNearest, nullptr);
    ImGui::Image((ImTextureID)(intptr_t)t.id, size);
    if (pio.DrawCallback_SetSamplerLinear)
        dl->AddCallback(pio.DrawCallback_SetSamplerLinear, nullptr);
}

float stage_scale(float avail_w) {
    float s = std::floor(avail_w / (float)vc::Surface::W);
    return s < 1.0f ? 1.0f : s > 4.0f ? 4.0f : s;
}

// ------------------------------------------------------------ texture cache
namespace {
struct TexCache {
    std::map<std::string, Texture> made;   // filled once
    std::map<std::string, bool> failed;    // don't retry every frame
};
TexCache& tc() { static TexCache t; return t; }
}  // namespace

Texture* static_texture(Driver& drv, const std::string& key,
                        const std::function<bool(vc::Image&)>& make) {
    auto it = tc().made.find(key);
    if (it != tc().made.end()) return &it->second;
    if (tc().failed.count(key)) return nullptr;
    vc::Image img;
    if (!make(img) || img.w <= 0 || img.h <= 0) {
        tc().failed[key] = true;
        return nullptr;
    }
    Texture t = drv.create_texture(img.w, img.h);
    drv.update_texture(t, img.rgb.data());
    auto& slot = tc().made[key] = t;
    return &slot;
}

void invalidate_texture(const std::string& key) {
    tc().made.erase(key);      // driver texture leaks until exit; acceptable
    tc().failed.erase(key);    // for an editor-session-scoped cache
}

} // namespace studio
