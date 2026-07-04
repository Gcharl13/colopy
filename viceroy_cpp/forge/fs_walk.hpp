// fs_walk.hpp -- recursive *.rec listing under a data directory, shared by
// the store boot paths. POSIX dirent everywhere except the Teensy port,
// which has no dirent: there the frontend supplies vc_teensy_listdir()
// over the SD library (teensy/src/sd_syscalls.cpp).
#pragma once
#include <algorithm>
#include <string>
#include <vector>

#ifdef VICEROY_TEENSY
extern "C" void vc_teensy_listdir(const char* dir,
                                  void (*cb)(const char* name, int is_dir,
                                             void* ud),
                                  void* ud);
namespace forge {
inline void walk_rec_files(const std::string& dir, std::vector<std::string>& out) {
    struct Ctx {
        const std::string* dir;
        std::vector<std::string>* out;
    } ctx{&dir, &out};
    vc_teensy_listdir(dir.c_str(), [](const char* name, int is_dir, void* ud) {
        Ctx& c = *(Ctx*)ud;
        std::string n = name;
        std::string p = *c.dir + "/" + n;
        if (is_dir) walk_rec_files(p, *c.out);
        else if (n.size() > 4 && n.substr(n.size() - 4) == ".rec")
            c.out->push_back(p);
    }, &ctx);
    std::sort(out.begin(), out.end());
}
} // namespace forge
#else
#include <dirent.h>
#include <sys/stat.h>
namespace forge {
inline void walk_rec_files(const std::string& dir, std::vector<std::string>& out) {
    DIR* d = opendir(dir.c_str());
    if (!d) return;
    while (dirent* e = readdir(d)) {
        std::string n = e->d_name;
        if (n == "." || n == "..") continue;
        std::string p = dir + "/" + n;
        struct stat st{};
        if (stat(p.c_str(), &st) != 0) continue;
        if (S_ISDIR(st.st_mode)) walk_rec_files(p, out);
        else if (n.size() > 4 && n.substr(n.size() - 4) == ".rec") out.push_back(p);
    }
    closedir(d);
    std::sort(out.begin(), out.end());
}
} // namespace forge
#endif
