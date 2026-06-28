// png_io.cpp -- see png_io.hpp. Thin libpng wrappers.
#include "png_io.hpp"
#include <cstdio>
#include <stdexcept>
#include <png.h>

namespace vc {

void write_png_indexed(const std::string& path, int w, int h,
                       const std::vector<uint8_t>& idx, const uint8_t pal[768],
                       int transparent_index) {
    FILE* fp = std::fopen(path.c_str(), "wb");
    if (!fp) throw std::runtime_error("cannot write " + path);
    png_structp png = png_create_write_struct(PNG_LIBPNG_VER_STRING, nullptr, nullptr, nullptr);
    png_infop info = png ? png_create_info_struct(png) : nullptr;
    if (!png || !info) { std::fclose(fp); throw std::runtime_error("libpng init failed"); }
    if (setjmp(png_jmpbuf(png))) {
        png_destroy_write_struct(&png, &info); std::fclose(fp);
        throw std::runtime_error("libpng write error on " + path);
    }
    png_init_io(png, fp);
    png_set_IHDR(png, info, w, h, 8, PNG_COLOR_TYPE_PALETTE,
                 PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_DEFAULT, PNG_FILTER_TYPE_DEFAULT);
    png_color plte[256];
    for (int i = 0; i < 256; ++i) {
        plte[i].red   = pal[i * 3 + 0];
        plte[i].green = pal[i * 3 + 1];
        plte[i].blue  = pal[i * 3 + 2];
    }
    png_set_PLTE(png, info, plte, 256);
    if (transparent_index >= 0 && transparent_index < 256) {
        png_byte trans[256];
        for (int i = 0; i < 256; ++i) trans[i] = (i == transparent_index) ? 0 : 255;
        png_set_tRNS(png, info, trans, 256, nullptr);
    }
    png_write_info(png, info);
    std::vector<png_bytep> rows((size_t)h);
    for (int y = 0; y < h; ++y)
        rows[y] = const_cast<png_bytep>(idx.data() + (size_t)y * w);
    png_write_image(png, rows.data());
    png_write_end(png, info);
    png_destroy_write_struct(&png, &info);
    std::fclose(fp);
}

IndexedPng read_png_indexed(const std::string& path) {
    FILE* fp = std::fopen(path.c_str(), "rb");
    if (!fp) throw std::runtime_error("cannot open " + path);
    png_structp png = png_create_read_struct(PNG_LIBPNG_VER_STRING, nullptr, nullptr, nullptr);
    png_infop info = png ? png_create_info_struct(png) : nullptr;
    if (!png || !info) { std::fclose(fp); throw std::runtime_error("libpng init failed"); }

    IndexedPng out;
    std::vector<png_bytep> rows;
    if (setjmp(png_jmpbuf(png))) {
        png_destroy_read_struct(&png, &info, nullptr); std::fclose(fp);
        throw std::runtime_error("libpng read error on " + path);
    }
    png_init_io(png, fp);
    png_read_info(png, info);
    int bit_depth, color_type;
    png_uint_32 w = 0, h = 0;
    png_get_IHDR(png, info, &w, &h, &bit_depth, &color_type, nullptr, nullptr, nullptr);
    if (color_type != PNG_COLOR_TYPE_PALETTE)
        png_error(png, "expected a paletted PNG");
    if (bit_depth < 8) png_set_packing(png);            // expand sub-byte indices to 1/px
    png_read_update_info(png, info);

    out.w = (int)w; out.h = (int)h;
    out.idx.assign((size_t)w * h, 0);
    rows.assign((size_t)h, nullptr);
    for (png_uint_32 y = 0; y < h; ++y) rows[y] = out.idx.data() + (size_t)y * w;
    png_read_image(png, rows.data());
    png_read_end(png, info);

    png_colorp plte = nullptr; int num = 0;
    png_get_PLTE(png, info, &plte, &num);
    for (int i = 0; i < num && i < 256; ++i) {
        out.pal[i * 3 + 0] = plte[i].red;
        out.pal[i * 3 + 1] = plte[i].green;
        out.pal[i * 3 + 2] = plte[i].blue;
    }
    png_destroy_read_struct(&png, &info, nullptr);
    std::fclose(fp);
    return out;
}

void write_png_rgb(const std::string& path, int w, int h, const std::vector<uint8_t>& rgb) {
    FILE* fp = std::fopen(path.c_str(), "wb");
    if (!fp) throw std::runtime_error("cannot write " + path);
    png_structp png = png_create_write_struct(PNG_LIBPNG_VER_STRING, nullptr, nullptr, nullptr);
    png_infop info = png ? png_create_info_struct(png) : nullptr;
    if (!png || !info) { std::fclose(fp); throw std::runtime_error("libpng init failed"); }
    if (setjmp(png_jmpbuf(png))) {
        png_destroy_write_struct(&png, &info); std::fclose(fp);
        throw std::runtime_error("libpng write error on " + path);
    }
    png_init_io(png, fp);
    png_set_IHDR(png, info, w, h, 8, PNG_COLOR_TYPE_RGB,
                 PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_DEFAULT, PNG_FILTER_TYPE_DEFAULT);
    png_write_info(png, info);
    std::vector<png_bytep> rows((size_t)h);
    for (int y = 0; y < h; ++y)
        rows[y] = const_cast<png_bytep>(rgb.data() + (size_t)y * w * 3);
    png_write_image(png, rows.data());
    png_write_end(png, info);
    png_destroy_write_struct(&png, &info);
    std::fclose(fp);
}

} // namespace vc
