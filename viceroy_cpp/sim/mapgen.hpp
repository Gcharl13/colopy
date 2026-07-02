// sim/mapgen.hpp -- random-map generation (spec/systems/map_generation.md).
//
// func_064A10 (BYTE-VERIFIED control flow): P0 ocean fill (0x19) -> P1 blob-
// growth landmass (seed count (p1+p2+1)*0x140, 8-dir random walks) -> P2
// latitude climate bands (N {5,4,1,3,2,2} / S {2,3,3,4,6,7} inline jump
// tables; hills/forest feature bits) -> P3 smoothing (unforested -> forested
// +8 folds) -> P4 rivers (kernel spread, feature bit) -> P5 borders (right
// TWO columns Sea Lane 0x1A; top/bottom rows Arctic 0x18) -> P6 European
// starts (y = (H/5)*(p+1) bands, x walked inland from the east sea lane).
// The Customize menu's 4 parameters are 3-way enums 0..2
// (@CLAND/@CCONT/@CTEMP/@CCLIM, func_070060).
#pragma once
#include "game.hpp"          // World
#include "immigration.hpp"   // RandFn

namespace vc::sim {

// Random-map default dimensions (set @0x75702/0x75708).
constexpr int MAP_W = 58;   // 0x3A
constexpr int MAP_H = 72;   // 0x48

// Climate band (0..5) -> base terrain id, by hemisphere (func_064A10 inline
// jump tables): North {5,4,1,3,2,2}, South {2,3,3,4,6,7}.
//   North: Savannah,Grassland,Desert,Prairie,Plains,Plains
//   South: Plains,Prairie,Prairie,Grassland,Marsh,Swamp
inline int climate_base_terrain(int band, bool south) {
    static const int kNorth[6] = {5, 4, 1, 3, 2, 2};
    static const int kSouth[6] = {2, 3, 3, 4, 6, 7};
    if (band < 0) band = 0;
    if (band > 5) band = 5;
    return south ? kSouth[band] : kNorth[band];
}

// The Customize parameters (each 0..2): land-mass @CLAND, land-form @CCONT,
// temperature @CTEMP, climate @CCLIM.
struct MapGenParams { int land = 1, landform = 1, temperature = 1, climate = 1; };

// Generate a random continental map into `w` (terrain plane in the .MP packing:
// low 5 bits id, bit5 river, bit6 forest) and return the 4 European start
// positions (P6 bands; the ship anchors on the water tile east of the landfall).
// Feature densities inside P2/P4 (how often the sweep sets the hills/forest/
// river bits) are RECONSTRUCTED -- the pass structure, climate tables, border
// fills, seed counts, and start bands are the byte-cited parts.
struct MapStart { int x = 0, y = 0; };
void generate_map(World& w, const MapGenParams& p, const RandFn& rng,
                  MapStart starts[4]);

} // namespace vc::sim
