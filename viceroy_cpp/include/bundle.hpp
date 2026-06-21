// bundle.hpp -- the modern asset bundle (paletted-PNG atlas + frames JSON).
//
// The importer converts a decoded .SS Sheet into a bundle; the runtime loads a
// bundle back into the same Sheet structure (so the renderer is identical and
// never touches the original codec). The atlas stores palette INDICES (not baked
// RGB) so the runtime keeps an indexed framebuffer and can palette-cycle later.
#pragma once
#include "ss.hpp"
#include <string>

namespace vc {

// Offline importer: pack `sheet`'s frames into an atlas, write a paletted PNG +
// a frames.json (per-frame w,h + original .SS hotspot x,y + atlas rect ax,ay).
void write_bundle(const Sheet& sheet,
                  const std::string& atlas_png, const std::string& frames_json);

// Runtime loader: reconstruct a Sheet from the bundle (no .SS / no FAB codec).
Sheet load_bundle(const std::string& atlas_png, const std::string& frames_json);

} // namespace vc
