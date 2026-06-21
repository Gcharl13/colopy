// bundle.cpp -- see bundle.hpp.
#include "bundle.hpp"
#include "png_io.hpp"
#include <cstdio>
#include <fstream>
#include <stdexcept>

namespace vc {

namespace {
struct Rect { int ax, ay; };   // atlas placement per frame

// Simple shelf packer: lay frames left-to-right, wrap past TARGET_W.
std::vector<Rect> pack(const Sheet& s, int& atlasW, int& atlasH, int TARGET_W = 256) {
    std::vector<Rect> r(s.frames.size());
    int X = 0, Y = 0, shelf = 0; atlasW = 0;
    for (size_t i = 0; i < s.frames.size(); ++i) {
        int w = s.frames[i].w, h = s.frames[i].h;
        if (w < 1) w = 1;
        if (h < 1) h = 1;
        if (X > 0 && X + w > TARGET_W) { X = 0; Y += shelf; shelf = 0; }
        r[i] = { X, Y };
        X += w;
        if (h > shelf) shelf = h;
        if (X > atlasW) atlasW = X;
    }
    atlasH = Y + shelf;
    if (atlasW < 1) atlasW = 1;
    if (atlasH < 1) atlasH = 1;
    return r;
}
} // namespace

void write_bundle(const Sheet& sheet,
                  const std::string& atlas_png, const std::string& frames_json) {
    int atlasW, atlasH;
    std::vector<Rect> rect = pack(sheet, atlasW, atlasH);

    // Compose the atlas (transparent background = SS_TRANSPARENT).
    std::vector<uint8_t> atlas((size_t)atlasW * atlasH, SS_TRANSPARENT);
    for (size_t i = 0; i < sheet.frames.size(); ++i) {
        const Frame& f = sheet.frames[i];
        for (int y = 0; y < f.h; ++y) {
            for (int x = 0; x < f.w; ++x) {
                int ax = rect[i].ax + x, ay = rect[i].ay + y;
                atlas[(size_t)ay * atlasW + ax] = f.px[(size_t)y * f.w + x];
            }
        }
    }
    write_png_indexed(atlas_png, atlasW, atlasH, atlas, sheet.pal, SS_TRANSPARENT);

    // frames.json (valid JSON; one frame object per line for easy parsing).
    std::ofstream js(frames_json);
    if (!js) throw std::runtime_error("cannot write " + frames_json);
    js << "{\n  \"sheet\": \"PHYS0\",\n  \"nframes\": " << sheet.frames.size()
       << ",\n  \"atlas\": { \"w\": " << atlasW << ", \"h\": " << atlasH << " },\n"
       << "  \"frames\": [\n";
    for (size_t i = 0; i < sheet.frames.size(); ++i) {
        const Frame& f = sheet.frames[i];
        js << "    {\"i\":" << i << ",\"x\":" << f.x << ",\"y\":" << f.y
           << ",\"w\":" << f.w << ",\"h\":" << f.h
           << ",\"ax\":" << rect[i].ax << ",\"ay\":" << rect[i].ay << "}"
           << (i + 1 < sheet.frames.size() ? "," : "") << "\n";
    }
    js << "  ]\n}\n";
}

Sheet load_bundle(const std::string& atlas_png, const std::string& frames_json) {
    IndexedPng atlas = read_png_indexed(atlas_png);

    Sheet s;
    for (int i = 0; i < 768; ++i) s.pal[i] = atlas.pal[i];

    // Parse frames.json line-by-line (each frame is one object with 7 ints).
    std::ifstream js(frames_json);
    if (!js) throw std::runtime_error("cannot open " + frames_json);
    struct FR { int i, x, y, w, h, ax, ay; };
    std::vector<FR> frs;
    int maxi = -1;
    std::string line;
    while (std::getline(js, line)) {
        FR fr;
        if (std::sscanf(line.c_str(),
                " {\"i\":%d,\"x\":%d,\"y\":%d,\"w\":%d,\"h\":%d,\"ax\":%d,\"ay\":%d",
                &fr.i, &fr.x, &fr.y, &fr.w, &fr.h, &fr.ax, &fr.ay) == 7) {
            frs.push_back(fr);
            if (fr.i > maxi) maxi = fr.i;
        }
    }
    if (frs.empty()) throw std::runtime_error("no frames parsed from " + frames_json);

    s.nframes = maxi + 1;
    s.frames.resize(s.nframes);
    for (const FR& fr : frs) {
        Frame f;
        f.x = fr.x; f.y = fr.y; f.w = fr.w; f.h = fr.h;
        f.px.assign((size_t)f.w * f.h, SS_TRANSPARENT);
        for (int y = 0; y < f.h; ++y)
            for (int x = 0; x < f.w; ++x)
                f.px[(size_t)y * f.w + x] =
                    atlas.idx[(size_t)(fr.ay + y) * atlas.w + (fr.ax + x)];
        s.frames[fr.i] = std::move(f);
    }
    return s;
}

} // namespace vc
