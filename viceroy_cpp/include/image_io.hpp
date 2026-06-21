// image_io.hpp -- binary PPM writer (exact, dependency-free, easy to diff).
// PNG read/write lives in png_io.hpp (libpng).
#pragma once
#include "render.hpp"
#include <string>

namespace vc {
void write_ppm(const Image& img, const std::string& path);
}
