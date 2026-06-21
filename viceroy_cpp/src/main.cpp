// main.cpp -- two subcommands embodying the asset-pipeline split (§4a of
// REWRITE_READINESS.md):
//   import : original PHYS0.SS  --(MADSPACK/FAB/SS decode + atlas pack)-->  bundle
//   render : bundle + AMER2.MP  --(no codec)-->  map image (PNG + PPM)
// The runtime `render` path never touches the original codec.
#include "ss.hpp"        // load_sheet (importer only)
#include "bundle.hpp"    // write_bundle / load_bundle
#include "mp.hpp"
#include "render.hpp"
#include "image_io.hpp"  // write_ppm
#include "png_io.hpp"    // write_png_rgb
#include <cstdio>
#include <cstring>
#include <string>

using namespace vc;

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
    write_bundle(s, atlas, frames);
    std::printf("import: %s -> %s + %s (%d frames)\n", ss, atlas, frames, s.nframes);
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
        std::fprintf(stderr, "usage: viceroy_cpp <import|render> [options]\n");
        return 2;
    }
    try {
        if (std::strcmp(argv[1], "import") == 0) return cmd_import(argc, argv);
        if (std::strcmp(argv[1], "render") == 0) return cmd_render(argc, argv);
        std::fprintf(stderr, "unknown command '%s' (expected import|render)\n", argv[1]);
        return 2;
    } catch (const std::exception& e) {
        std::fprintf(stderr, "error: %s\n", e.what());
        return 1;
    }
}
