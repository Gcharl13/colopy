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
#include "surface.hpp"   // Surface (P4 presentation)
#include "mapview.hpp"   // render_mapview
#include "colony_screen.hpp" // render_colony_screen
#include "sim/game.hpp"  // GameState, World, step_turn
#include "sim/ref.hpp"   // ref_start
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

    // Orphan sheet never loaded by the engine (CLAUDE.md hard rule #5, amended
    // 2026-06-22: TERRAIN.SS is the base-ground sheet and IS bundled; only
    // BDARK.SS is orphan).
    const std::vector<std::string> orphan_ss = {"BDARK"};
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

// Compose the spec-faithful map-view SCREEN (320x200) from the bundle + the
// headless sim, and write N PNG frames. Every drawn element traces to
// spec/ui/map_view.md (see mapview.cpp). The map-view active palette is
// VICEROY.PAL (resolved from evidence: all gameplay assets share it).
static int cmd_mapview(int argc, char** argv) {
    using namespace vc::sim;
    const char* bundle = opt(argc, argv, "--bundle");
    const char* mp     = opt(argc, argv, "--mp");
    const char* out    = opt(argc, argv, "--out");
    if (!bundle || !mp || !out) {
        std::fprintf(stderr, "usage: viceroy_cpp mapview --bundle DIR --mp FILE --out BASE "
                             "[--turns N] [--scale S] [--ox X --oy Y]\n");
        return 2;
    }
    int turns = opt(argc, argv, "--turns") ? std::atoi(opt(argc, argv, "--turns")) : 0;
    int scale = opt(argc, argv, "--scale") ? std::atoi(opt(argc, argv, "--scale")) : 3;
    int ox    = opt(argc, argv, "--ox") ? std::atoi(opt(argc, argv, "--ox")) : 38;
    int oy    = opt(argc, argv, "--oy") ? std::atoi(opt(argc, argv, "--oy")) : 56;
    std::string bd = bundle;

    Sheet terrain = load_bundle(bd + "/sprites/TERRAIN.png", bd + "/sprites/TERRAIN.json");
    Sheet tiles   = load_bundle(bd + "/sprites/PHYS0.png",   bd + "/sprites/PHYS0.json");
    Sheet font    = load_bundle(bd + "/fonts/FONTTINY.png",  bd + "/fonts/FONTTINY.json");
    Sheet woodtile = load_bundle(bd + "/sprites/WOODTILE.png", bd + "/sprites/WOODTILE.json");
    Map map = load_mp(mp);

    // A minimal, honest game state: one colony of the human power building.
    GameState g; g.difficulty = 1; g.powers[0].gold = 600; g.ref = ref_start(g.difficulty);
    World w; Colony c;
    c.owner_power = 0; c.population = 3; c.bells_per_turn = 6; c.hammers_per_turn = 10;
    c.food_per_turn = 40; c.build_target = 0; c.build_cost = 64; c.crosses_output = 1;
    w.colonies.push_back(c);
    auto rng = [](int lo, int) { return lo; };

    for (int t = 0; t <= turns; ++t) {
        Surface scr;
        // Active map-view palette = PHYS0's embedded palette (resolved from evidence:
        // PHYS0 differs from VICEROY.PAL in 197/256 entries -- VICEROY.PAL is 4 bytes/
        // entry; WOODPANL + ICONS + fonts all share PHYS0's palette within ~2 indices).
        scr.set_palette(tiles.pal);
        render_mapview(scr, map, terrain, tiles, woodtile, font, g, w, ox, oy);
        Image img = scr.to_rgb(scale);
        char name[256];
        std::snprintf(name, sizeof name, "%s_%02d.png", out, t);
        write_png_rgb(name, img.w, img.h, img.rgb);
        if (t < turns) step_turn(g, w, rng);
    }
    std::printf("mapview: wrote %d frame(s) %s_00..%02d.png (320x200 x%d)\n",
                turns + 1, out, turns, scale);
    return 0;
}

// Compose the colony screen from spec/ui/colony_screen.md (see colony_screen.cpp).
// Loads the COLONY.PIK backdrop + ICONS/BUILDING/FONTTINY from the bundle and a
// minimal colony state, writes one 320x200 PNG.
static int cmd_colony(int argc, char** argv) {
    using namespace vc::sim;
    const char* bundle = opt(argc, argv, "--bundle");
    const char* out    = opt(argc, argv, "--out");
    if (!bundle || !out) {
        std::fprintf(stderr, "usage: viceroy_cpp colony --bundle DIR --out FILE.png [--scale S]\n");
        return 2;
    }
    int scale = opt(argc, argv, "--scale") ? std::atoi(opt(argc, argv, "--scale")) : 3;
    std::string bd = bundle;

    vc::IndexedPng backdrop = vc::read_png_indexed(bd + "/backgrounds/COLONY.png");
    vc::Sheet icons    = vc::load_bundle(bd + "/sprites/ICONS.png",    bd + "/sprites/ICONS.json");
    vc::Sheet building = vc::load_bundle(bd + "/sprites/BUILDING.png", bd + "/sprites/BUILDING.json");
    vc::Sheet parch    = vc::load_bundle(bd + "/sprites/PARCH.png",    bd + "/sprites/PARCH.json");
    vc::Sheet terrain  = vc::load_bundle(bd + "/sprites/TERRAIN.png",  bd + "/sprites/TERRAIN.json");
    vc::Sheet font     = vc::load_bundle(bd + "/fonts/FONTTINY.png",   bd + "/fonts/FONTTINY.json");

    // --- Scenario: a colony a colonist JUST founded. Jamestown, 1612, treasury 872 gold,
    // on a coastal tile of AMER2.MP. Fresh founding => population 1, NO buildings built,
    // empty warehouse. The colony's surrounding terrain (for the outside-colony grid) is
    // read straight from the map at (x,y). ---
    const char* mp   = opt(argc, argv, "--mp")   ? opt(argc, argv, "--mp")   : "raw/COLONIZE/AMER2.MP";
    int cx   = opt(argc, argv, "--x")    ? std::atoi(opt(argc, argv, "--x"))    : 20;
    int cy   = opt(argc, argv, "--y")    ? std::atoi(opt(argc, argv, "--y"))    : 25;
    int year = opt(argc, argv, "--year") ? std::atoi(opt(argc, argv, "--year")) : 1612;
    int gold = opt(argc, argv, "--gold") ? std::atoi(opt(argc, argv, "--gold")) : 872;

    int surround[9];
    bool have_surround = false;
    try {
        vc::Map m = vc::load_mp(mp);
        for (int dy = -1; dy <= 1; ++dy)
            for (int dx = -1; dx <= 1; ++dx) {
                int x = cx + dx, y = cy + dy;
                int id = (x < 0 || y < 0 || x >= m.w || y >= m.h) ? 25   // off-map => Ocean
                                                                  : (m.tiles[(size_t)y * m.w + x] & 0x1F);
                surround[(dy + 1) * 3 + (dx + 1)] = id;
            }
        have_surround = true;
        std::printf("colony: founded at %s (%d,%d), surrounding terrain captured\n", mp, cx, cy);
    } catch (const std::exception& e) {
        std::fprintf(stderr, "colony: could not load map %s (%s) — skipping outside view\n", mp, e.what());
    }

    Colony c; c.owner_power = 0; c.population = 1;
    c.built_mask = 0;                                 // freshly founded: nothing built yet
    int stockpile[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};   // empty warehouse at founding

    vc::Surface scr;
    // Active palette = the gameplay palette shared by BUILDING/PARCH/ICONS/TERRAIN/font.
    scr.set_palette(building.pal);
    vc::render_colony_screen(scr, backdrop, parch, icons, building, font, terrain, c,
                             gold, /*tax*/ 0, year, stockpile,
                             have_surround ? surround : nullptr);
    vc::Image img = scr.to_rgb(scale);
    vc::write_png_rgb(out, img.w, img.h, img.rgb);
    std::printf("colony: wrote %s (320x200 x%d)\n", out, scale);
    return 0;
}

int main(int argc, char** argv) {
    if (argc < 2) {
        std::fprintf(stderr, "usage: viceroy_cpp <import-all|import|render|mapview|colony> [options]\n");
        return 2;
    }
    try {
        if (std::strcmp(argv[1], "import-all") == 0)  return cmd_import_all(argc, argv);
        if (std::strcmp(argv[1], "import-font") == 0) return cmd_import_font(argc, argv);
        if (std::strcmp(argv[1], "import") == 0)      return cmd_import(argc, argv);
        if (std::strcmp(argv[1], "render") == 0)      return cmd_render(argc, argv);
        if (std::strcmp(argv[1], "mapview") == 0)     return cmd_mapview(argc, argv);
        if (std::strcmp(argv[1], "colony") == 0)      return cmd_colony(argc, argv);
        std::fprintf(stderr, "unknown command '%s'\n", argv[1]);
        return 2;
    } catch (const std::exception& e) {
        std::fprintf(stderr, "error: %s\n", e.what());
        return 1;
    }
}
