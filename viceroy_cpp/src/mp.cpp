// mp.cpp -- see mp.hpp.
#include "mp.hpp"
#include "util.hpp"
#include <stdexcept>

namespace vc {

Map load_mp(const std::string& path) {
    auto d = read_file(path);
    if (d.size() < 4) throw std::runtime_error(path + ": too small for .MP header");
    Map m;
    m.w = u16le(d.data() + 0);
    m.h = u16le(d.data() + 2);
    size_t ntiles = (size_t)m.w * m.h;
    if (4 + ntiles > d.size())
        throw std::runtime_error(path + ": tile array overruns file");
    m.tiles.assign(d.begin() + 4, d.begin() + 4 + ntiles);
    return m;
}

} // namespace vc
