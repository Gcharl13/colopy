// import_original.cpp -- see import_original.hpp.
#include "import_original.hpp"
#include "game_assets.hpp"
#include "ss.hpp"
#include "ff.hpp"
#include "pik.hpp"
#include "pal.hpp"
#include "mp.hpp"
#include <algorithm>
#include <cctype>
#include <cstring>
#include <filesystem>

namespace fs = std::filesystem;

namespace forge {

static std::string upper(std::string s) {
    for (char& c : s) c = (char)std::toupper((unsigned char)c);
    return s;
}

ImportReport import_original_game(const std::string& src_dir,
                                  const std::string& project_root) {
    ImportReport r;
    try {
        fs::path src(src_dir);
        if (!fs::is_directory(src)) {
            r.message = "not a folder: " + src_dir;
            return r;
        }
        // ---- recognize the game folder -----------------------------------
        bool has_exe = false, has_assets = false;
        for (const auto& e : fs::directory_iterator(src)) {
            if (!e.is_regular_file()) continue;
            std::string n = upper(e.path().filename().string());
            if (n == "VICEROY.EXE") has_exe = true;
            std::string ext = n.size() > 3 ? n.substr(n.size() - 3) : "";
            if (ext == ".SS" || n.size() > 4) {
                std::string e4 = n.size() > 4 ? n.substr(n.size() - 4) : "";
                if (e4 == ".PIK" || e4 == ".TXT" || ext == ".SS") has_assets = true;
            }
        }
        if (!has_exe && !has_assets) {
            r.message = "no VICEROY.EXE or game data found in " + src_dir;
            return r;
        }
        // ---- copy everything into raw/COLONIZE (uppercase names: the
        //      loaders look for the DOS spellings) --------------------------
        fs::path dst = fs::path(project_root.empty() ? "." : project_root) /
                       "raw" / "COLONIZE";
        fs::create_directories(dst);
        for (const auto& e : fs::directory_iterator(src)) {
            if (!e.is_regular_file()) continue;
            fs::copy_file(e.path(), dst / upper(e.path().filename().string()),
                          fs::copy_options::overwrite_existing);
            ++r.copied;
        }
        // ---- decode-verify with the native codecs ------------------------
        uint8_t pal[768] = {0};
        bool pal_ok = false;
        try {
            vc::Palette p = vc::load_pal((dst / "VICEROY.PAL").string());
            std::memcpy(pal, p.rgb, sizeof pal);
            pal_ok = true;
        } catch (const std::exception&) {}
        r.notes.push_back(pal_ok ? "palette: VICEROY.PAL decoded"
                                 : "palette: VICEROY.PAL missing (converted "
                                   "palette.json stays in use)");
        auto try_each = [&](const char* what, const char* ext,
                            auto&& decode) {
            int ok = 0, bad = 0;
            std::string first_bad;
            for (const auto& e : fs::directory_iterator(dst)) {
                std::string n = e.path().filename().string();
                if (n.size() <= std::strlen(ext) ||
                    n.substr(n.size() - std::strlen(ext)) != ext)
                    continue;
                try {
                    decode(e.path().string());
                    ++ok;
                } catch (const std::exception&) {
                    ++bad;
                    if (first_bad.empty()) first_bad = n;
                }
            }
            r.decoded += ok;
            char line[160];
            std::snprintf(line, sizeof line, "%s: %d decoded%s%s%s", what, ok,
                          bad ? ", " : "", bad ? std::to_string(bad).c_str() : "",
                          bad ? (" failed (first: " + first_bad + ")").c_str()
                              : "");
            r.notes.push_back(line);
        };
        try_each("sprite sheets (.SS)", ".SS",
                 [](const std::string& p) { vc::load_sheet(p); });
        try_each("fonts (.FF)", ".FF",
                 [](const std::string& p) { vc::load_font(p); });
        try_each("backgrounds (.PIK)", ".PIK",
                 [&](const std::string& p) { vc::load_pik(p, pal); });
        try_each("maps (.MP)", ".MP",
                 [](const std::string& p) { vc::load_mp(p); });
        int txt = 0;
        for (const char* t : {"GAME.TXT", "NAMES.TXT", "LABELS.TXT", "MENU.TXT"})
            if (fs::exists(dst / t)) ++txt;
        r.notes.push_back("text: " + std::to_string(txt) +
                          "/4 sections present (records already carry their "
                          "content; kept for reference)");
        if (fs::exists(dst / "VICEROY.EXE"))
            r.notes.push_back("VICEROY.EXE: kept for reference -- its code is "
                              "what this engine reimplements; nothing to "
                              "extract from the binary at import time");
        // ---- flush the asset caches so the real art shows immediately ----
        GameAssets& a = game_assets();
        a = GameAssets{};
        game_assets_ensure();
        r.notes.push_back(a.ok ? ("assets reloaded: " +
                                  std::to_string(a.nat.raw_overrides) +
                                  " raw overrides active" +
                                  (a.nat.font_real ? ", REAL game font" : ""))
                               : "asset reload failed: " + a.err);
        r.ok = true;
        r.message = "imported " + std::to_string(r.copied) + " files, " +
                    std::to_string(r.decoded) + " decoded";
    } catch (const std::exception& e) {
        r.message = std::string("import failed: ") + e.what();
    }
    return r;
}

} // namespace forge
