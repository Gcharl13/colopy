// studio_assets.cpp -- editor-side asset helpers. The loaders themselves
// (native assets, atlas cache, contact-sheet windows) are the shared
// platform-free provider in forge/game_assets.cpp; this file keeps only the
// ImGui/Driver-coupled pieces: sprite previews, crisp-image drawing, and the
// static texture cache.
#include "studio_shared.hpp"
#include "../drydock/core/store.hpp"
#include <cmath>
#include <cstring>

namespace studio {
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
