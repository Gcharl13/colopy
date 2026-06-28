// image_io.cpp -- see image_io.hpp. PPM only (PNG is in png_io.cpp via libpng).
#include "image_io.hpp"
#include <fstream>
#include <stdexcept>

namespace vc {

void write_ppm(const Image& img, const std::string& path) {
    std::ofstream f(path, std::ios::binary);
    if (!f) throw std::runtime_error("cannot write " + path);
    f << "P6\n" << img.w << " " << img.h << "\n255\n";
    f.write(reinterpret_cast<const char*>(img.rgb.data()), (std::streamsize)img.rgb.size());
}

} // namespace vc
