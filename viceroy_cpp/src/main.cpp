// main.cpp -- asset-pipeline subcommands (§4a of REWRITE_READINESS.md):
//   import-all : COLONIZE/ dir  --(decode .SS + .PIK)-->  full modern bundle
//   import     : one PHYS0.SS   --(decode + atlas pack)-->  sprite bundle
//   render     : bundle + .MP   --(no codec)-->  map image (PNG + PPM)
// The runtime `render` path never touches the original codec.
#include "ss.hpp"        // load_sheet (importer only)
#include "pik.hpp"       // load_pik   (importer only)
#include "ff.hpp"        // load_font  (importer only)
#include "bundle.hpp"    // write_bundle / load_bundle
#include "pal.hpp"
#include "png_io.hpp"    // write_png_indexed / write_png_rgb
#include "mp.hpp"
#include "render.hpp"
#include "image_io.hpp"  // write_ppm
#include <cstdio>
#include <cstring>
#include <string>
#include <vector>
#include <algorithm>
#include <fstream>
#include <filesystem>

using namespace vc;
namespace fs = std::filesystem;

static const char* opt(int argc, char** argv, const char* key) {
    for (int i = 2; i + 1 < argc; ++i)
        if (std::strcmp(argv[i], key) == 0) return argv[i + 1];
    return nullptr;
}

static int cmd_import(int argc, char** argv) {
    const char* ss     = opt(argc, argv, "--ss");
    const char* atlas  = opt(argc, argv, "--atlas");
    const char* frames = opt(argc, argv, "--frames");
    if (!ss || !atlas || !frames) {
        std::fprintf(stderr, "usage: viceroy_cpp import --ss FILE --atlas PNG --frames JSON\n");
        return 2;
    }
    Sheet s = load_sheet(ss);
    write_bundle(s, fs::path(ss).stem().string(), atlas, frames);
    std::printf("import: %s -> %s + %s (%d frames)\n", ss, atlas, frames, s.nframes);
    return 0;
}

static int cmd_import_font(int argc, char** argv) {
    const char* ff     = opt(argc, argv, "--ff");
    const char* atlas  = opt(argc, argv, "--atlas");
    const char* frames = opt(argc, argv, "--frames");
    if (!ff || !atlas || !frames) {
        std::fprintf(stderr, "usage: viceroy_cpp import-font --ff FILE --atlas PNG --frames JSON\n");
        return 2;
    }
    Sheet s = load_font(ff);                       // 128 glyph frames (index = char code)
    write_bundle(s, fs::path(ff).stem().string(), atlas, frames);
    std::printf("import-font: %s -> %s + %s (128 glyphs)\n", ff, atlas, frames);
    return 0;
}

// Collect *.EXT (upper-case) filenames in `dir`, sorted for determinism.
static std::vector<fs::path> list_ext(const fs::path& dir, const std::string& ext) {
    std::vector<fs::path> out;
    for (const auto& e : fs::directory_iterator(dir)) {
        if (!e.is_regular_file()) continue;
        std::string s = e.path().extension().string();
        std::transform(s.begin(), s.end(), s.begin(), ::toupper);
        if (s == ext) out.push_back(e.path());
    }
    std::sort(out.begin(), out.end());
    return out;
}

static void json_list(std::ofstream& f, const char* key,
                      const std::vector<std::string>& v, bool last) {
    f << "  \"" << key << "\": [";
    for (size_t i = 0; i < v.size(); ++i)
        f << (i ? ", " : "") << '"' << v[i] << '"';
    f << "]" << (last ? "" : ",") << "\n";
}

static int cmd_import_all(int argc, char** argv) {
    fs::path colonize = opt(argc, argv, "--colonize") ? opt(argc, argv, "--colonize")
                                                      : "../../raw/COLONIZE";
    fs::path outdir   = opt(argc, argv, "--out") ? opt(argc, argv, "--out") : "bundle";
    fs::path palpath  = opt(argc, argv, "--pal") ? opt(argc, argv, "--pal")
                                                 : (colonize / "VICEROY.PAL");

    // Orphan sheets never loaded by the engine (CLAUDE.md hard rule #5).
    const std::vector<std::string> orphan_ss = {"TERRAIN", "BDARK"};
    auto is_orphan = [&](const std::string& n) {
        return std::find(orphan_ss.begin(), orphan_ss.end(), n) != orphan_ss.end();
    };

    Palette gp = load_pal(palpath.string());           // global palette (PIK fallback)
    fs::create_directories(outdir / "sprites");
    fs::create_directories(outdir / "backgrounds");
    fs::create_directories(outdir / "fonts");

    std::vector<std::string> sprites, backgrounds, fonts, skipped;

    for (const auto& p : list_ext(colonize, ".SS")) {
        std::string name = p.stem().string();
        if (is_orphan(name)) { skipped.push_back(name + ".SS (orphan)"); continue; }
        try {
            Sheet s = load_sheet(p.string());
            write_bundle(s, name,
                         (outdir / "sprites" / (name + ".png")).string(),
                         (outdir / "sprites" / (name + ".json")).string());
            sprites.push_back(name);
        } catch (const std::exception& e) {
            skipped.push_back(name + ".SS (" + e.what() + ")");
        }
    }

    for (const auto& p : list_ext(colonize, ".PIK")) {
        std::string name = p.stem().string();
        try {
            PikImage im = load_pik(p.string(), gp.rgb);
            write_png_indexed((outdir / "backgrounds" / (name + ".png")).string(),
                              im.w, im.h, im.idx, im.pal, -1);
            backgrounds.push_back(name);
        } catch (const std::exception& e) {
            skipped.push_back(name + ".PIK (" + e.what() + ")");
        }
    }

    // Fonts (.FF) are typically alongside, or in col.zip; bundle any present.
    for (const auto& p : list_ext(colonize, ".FF")) {
        std::string name = p.stem().string();
        if (name == "FONTSMAL") { skipped.push_back(name + ".FF (orphan)"); continue; }
        try {
            Sheet s = load_font(p.string());
            write_bundle(s, name,
                         (outdir / "fonts" / (name + ".png")).string(),
                         (outdir / "fonts" / (name + ".json")).string());
            fonts.push_back(name);
        } catch (const std::exception& e) {
            skipped.push_back(name + ".FF (" + e.what() + ")");
        }
    }

    std::ofstream man((outdir / "manifest.json").string());
    if (!man) { std::fprintf(stderr, "cannot write manifest\n"); return 1; }
    man << "{\n";
    man << "  \"format\": \"viceroy_cpp asset bundle v1\",\n";
    json_list(man, "sprites", sprites, false);
    json_list(man, "backgrounds", backgrounds, false);
    json_list(man, "fonts", fonts, false);
    json_list(man, "skipped", skipped, true);
    man << "}\n";

    std::printf("import-all: %zu sprites, %zu backgrounds, %zu fonts, %zu skipped -> %s/\n",
                sprites.size(), backgrounds.size(), fonts.size(), skipped.size(),
                outdir.string().c_str());
    for (const auto& s : skipped) std::printf("  skip: %s\n", s.c_str());
    return 0;
}

static int cmd_render(int argc, char** argv) {
    const char* atlas  = opt(argc, argv, "--atlas");
    const char* frames = opt(argc, argv, "--frames");
    const char* mp     = opt(argc, argv, "--mp");
    const char* out    = opt(argc, argv, "--out");
    if (!atlas || !frames || !mp || !out) {
        std::fprintf(stderr, "usage: viceroy_cpp render --atlas PNG --frames JSON --mp FILE --out BASE\n");
        return 2;
    }
    Sheet s = load_bundle(atlas, frames);          // runtime: bundle only, no codec
    std::printf("render: bundle %s (%d frames)\n", atlas, s.nframes);
    Map m = load_mp(mp);
    std::printf("render: %s %dx%d tiles\n", mp, m.w, m.h);
    Image img = render_map(m, s, 16);
    write_ppm(img, std::string(out) + ".ppm");
    write_png_rgb(std::string(out) + ".png", img.w, img.h, img.rgb);
    std::printf("render: wrote %s.png and %s.ppm (%dx%d)\n", out, out, img.w, img.h);
    return 0;
}

int main(int argc, char** argv) {
    if (argc < 2) {
        std::fprintf(stderr, "usage: viceroy_cpp <import-all|import|render> [options]\n");
        return 2;
    }
    try {
        if (std::strcmp(argv[1], "import-all") == 0)  return cmd_import_all(argc, argv);
        if (std::strcmp(argv[1], "import-font") == 0) return cmd_import_font(argc, argv);
        if (std::strcmp(argv[1], "import") == 0)      return cmd_import(argc, argv);
        if (std::strcmp(argv[1], "render") == 0)      return cmd_render(argc, argv);
        std::fprintf(stderr, "unknown command '%s'\n", argv[1]);
        return 2;
    } catch (const std::exception& e) {
        std::fprintf(stderr, "error: %s\n", e.what());
        return 1;
    }
}
