// studio_assets.cpp -- shared native assets + sprite resolution for the panels.
#include "studio_shared.hpp"
#include "pik.hpp"       // load_pik: the game's own backgrounds when present
#include "../drydock/core/store.hpp"
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
    // The committed contact sheets are 2x with a label band; the first cell's
    // face window is PNG rect (1,39) 56x42 (the web wfPortrait geometry),
    // downsampled to native 28x21 by point-sampling every other pixel.
    if (img && img->w >= 57 && img->h >= 81) {
        f.w = 28; f.h = 21; f.x = f.y = 0;
        f.px.resize((size_t)f.w * f.h);
        for (int y = 0; y < f.h; ++y)
            for (int x = 0; x < f.w; ++x)
                f.px[(size_t)y * f.w + x] =
                    img->idx[(size_t)(39 + y * 2) * img->w + (1 + x * 2)];
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
