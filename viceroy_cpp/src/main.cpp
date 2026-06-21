// main.cpp -- P0 entry point: decode VICEROY.PAL + PHYS0.SS + AMER2.MP from the
// original game files and emit a map render (PNG + PPM). The proof that the C++
// asset pipeline matches the byte-verified Python decoder (tools/ssdec.py) and
// visual oracle (tools/render_map.py).
#include "ss.hpp"
#include "mp.hpp"
#include "render.hpp"
#include "image_io.hpp"
#include <cstdio>
#include <string>

using namespace vc;

int main(int argc, char** argv) {
    std::string colonize = "../../raw/COLONIZE";   // default: repo raw/ tree
    std::string outbase  = "map";
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a == "--colonize" && i + 1 < argc) colonize = argv[++i];
        else if (a == "--out" && i + 1 < argc)  outbase  = argv[++i];
        else { std::fprintf(stderr, "usage: %s [--colonize DIR] [--out BASE]\n", argv[0]); return 2; }
    }

    try {
        Sheet phys0 = load_sheet(colonize + "/PHYS0.SS");
        std::printf("PHYS0.SS: %d frames, palette loaded\n", phys0.nframes);

        Map map = load_mp(colonize + "/AMER2.MP");
        std::printf("AMER2.MP: %dx%d tiles\n", map.w, map.h);

        Image img = render_map(map, phys0, 16);
        std::printf("rendered %dx%d px\n", img.w, img.h);

        write_ppm(img, outbase + ".ppm");
        write_png(img, outbase + ".png");
        std::printf("wrote %s.ppm and %s.png\n", outbase.c_str(), outbase.c_str());
    } catch (const std::exception& e) {
        std::fprintf(stderr, "error: %s\n", e.what());
        return 1;
    }
    return 0;
}
