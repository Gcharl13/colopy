// sim/mapgen.hpp -- random-map generation (spec/systems/map_generation.md).
#pragma once

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

} // namespace vc::sim
