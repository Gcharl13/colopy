// sim/mapgen.cpp -- see mapgen.hpp for the byte citations (func_064A10).
#include "mapgen.hpp"

namespace vc::sim {

namespace {
// The generator's 8-dir compass tables (DS:0xB4 dx / 0xBE dy).
const int DX8[8] = {1, 1, 0, -1, -1, -1, 0, 1};
const int DY8[8] = {0, 1, 1, 1, 0, -1, -1, -1};
}

void generate_map(World& w, const MapGenParams& p, const RandFn& rng,
                  MapStart starts[4]) {
    const int W = MAP_W, H = MAP_H;                 // 58x72 (@0x75702/@0x75708)
    w.map_w = W; w.map_h = H;
    w.terrain.assign((size_t)W * H, 25);            // P0: all-Ocean fill (0x19 @0x64A4B)
    w.improve.clear(); w.fog.clear();
    auto at = [&](int x, int y) -> uint8_t& { return w.terrain[(size_t)y * W + x]; };
    auto in = [&](int x, int y) { return x >= 2 && x < W - 3 && y >= 2 && y < H - 2; };

    // P1: blob-growth landmass -- (p1+p2+1)*0x140 land tiles grown by 8-dir
    // random walks (@0x64AAD seed count; walk @0x64B5A). A walker restarts on
    // leaving bounds; the fill-mask trigger detail is folded into the walk.
    long budget = (long)(p.land + p.landform + 1) * 0x140;
    while (budget > 0) {
        int x = rng(W / 4, 3 * W / 4), y = rng(3, H - 4);
        for (int step = 0; step < 64 && budget > 0; ++step) {
            if (!in(x, y)) break;
            if ((at(x, y) & 0x1F) == 25) { at(x, y) = 2; --budget; }   // land (Plains stub)
            const int d = rng(0, 7);
            x += DX8[d]; y += DY8[d];
        }
    }

    // P2: latitude climate bands -> base terrain (the byte-verified inline
    // jump tables), then the feature bits. Band = (row-in-hemisphere >> 2),
    // clamped 0..5, warped one band by the temperature parameter. Feature
    // DENSITIES here are RECONSTRUCTED (climate parameter biases forest).
    for (int y = 0; y < H; ++y)
        for (int x = 0; x < W; ++x) {
            if ((at(x, y) & 0x1F) == 25) continue;
            const bool south = y >= H / 2;
            int row = south ? (H - 1 - y) : y;
            int band = (row >> 2) + (p.temperature - 1);
            if (band < 0) band = 0;
            if (band > 5) band = 5;
            int base = climate_base_terrain(band, south);
            if (base == 6 && rng(1, 2) == 2) base = 4;   // the Marsh 50% roll (@0x6500C)
            // features: hills / forest (the 0x20/0x80 board bits ~ our ids/bit6)
            const int r = rng(1, 12);
            if (r == 1)      base = 28;                  // Hills
            else if (r == 2) base = 27;                  // Mountains
            else if (base <= 7 && rng(1, 3) <= 1 + p.climate)   // wetter -> denser forest
                base = (base & 7) | 8;                   // P3 fold: unforested -> +8
            at(x, y) = (uint8_t)base;
        }

    // P3: light smoothing -- stray interior ocean surrounded by >= 6 land
    // becomes open land (the relaxation pass, budget-limited in the EXE).
    for (int y = 1; y < H - 1; ++y)
        for (int x = 1; x < W - 3; ++x) {
            if ((at(x, y) & 0x1F) != 25) continue;
            int n = 0;
            for (int d = 0; d < 8; ++d)
                if ((at(x + DX8[d], y + DY8[d]) & 0x1F) != 25) ++n;
            if (n >= 6) at(x, y) = 2;
        }

    // P4: rivers -- a few walks from high ground toward the sea setting the
    // .MP river bit (bit 5; the runtime board uses 0x40, the FILE packing
    // 0x20 -- our World carries the file packing). Count RECONSTRUCTED.
    for (int r = 0; r < 3 + p.climate; ++r) {
        int x = rng(4, W - 6), y = rng(4, H - 5);
        for (int step = 0; step < 30; ++step) {
            const int t = at(x, y) & 0x1F;
            if (t == 25 || t == 26) break;               // reached the sea
            at(x, y) |= 0x20;                            // river overlay (MP_FORMAT bit 5)
            const int d = rng(0, 7);
            x += DX8[d]; y += DY8[d];
            if (x < 1 || x >= W - 1 || y < 1 || y >= H - 1) break;
        }
    }

    // P5: borders -- top/bottom rows Arctic first (0x18 @0x6582A), THEN the
    // right two columns Sea Lane (0x1A @0x65941/@0x65975; the higher site runs
    // later, so the corners end as Sea Lane).
    for (int x = 0; x < W; ++x) { at(x, 0) = 24; at(x, H - 1) = 24; }
    for (int y = 0; y < H; ++y) { at(W - 1, y) = 26; at(W - 2, y) = 26; }

    // P6: European starts -- y = (H/5)*(p+1) bands (@0x65C9C); x walked inland
    // from the east sea lane to the first land, the ship anchoring on the
    // water tile just east of it.
    for (int pw = 0; pw < 4; ++pw) {
        int y = (H / 5) * (pw + 1);
        if (y < 1) y = 1;
        if (y > H - 2) y = H - 2;
        int sx = W - 3;
        while (sx > 1 && (at(sx, y) & 0x1F) == 25) --sx;
        starts[pw].x = (sx < W - 3) ? sx + 1 : W - 3;    // the water tile east of land
        starts[pw].y = y;
    }
}

} // namespace vc::sim
