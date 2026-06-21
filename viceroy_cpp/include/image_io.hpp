// image_io.hpp -- dependency-free image writers (PPM + minimal PNG).
#pragma once
#include "render.hpp"
#include <string>

namespace vc {
// Binary PPM (P6) -- trivial, exact, easy to diff.
void write_ppm(const Image& img, const std::string& path);
// Minimal PNG (8-bit RGB, stored/uncompressed deflate) -- viewable artifact,
// no external library.
void write_png(const Image& img, const std::string& path);
}
