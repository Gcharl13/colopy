// viceroy_app.cpp -- the native application.
//
// A thin SDL2 shell over the 320x200 indexed compositor (mapview.cpp) and the
// REAL game session (forge/session.hpp -- the same session the web editor
// drives): game_new() boots the scenario (colonies, starting units, native
// settlements, rules overlay), game_step() runs the full byte-faithful
// end-turn pipeline (production, market, immigration, natives, King/REF,
// diplomacy, events, autosave), and the frame is composed from g_game/g_world.
//
// Modes:
//   viceroy [--root DIR] [--scale N] [--nation N] [--difficulty N]   window (SDL2)
//   viceroy --frames N --out BASE [...]    headless: compose N frames (with a
//                                          unit step + full end-turn between
//                                          them) and exit -- the ctest smoke;
//                                          needs no SDL.
//
// In-session actions beyond move/end-turn (found colony, board ship, colony
// management, Europe) are the next extraction phase; today they live in the
// web routes only.
#include "native_assets.hpp"
#include "surface.hpp"
#include "mapview.hpp"
#include "mp.hpp"
#include "session.hpp"       // the game session (g_game/g_world, game_new/game_step)
#include "unit.hpp"
#include "unit_turn.hpp"
#include <cstdio>
#include <cstring>
#include <string>
#include <unistd.h>          // chdir

#if VICEROY_HAVE_SDL
#include <SDL.h>
#endif

using namespace vc;
using namespace vc::sim;

static const char* opt(int argc, char** argv, const char* key) {
    for (int i = 1; i + 1 < argc; ++i)
        if (std::strcmp(argv[i], key) == 0) return argv[i + 1];
    return nullptr;
}

// ---------------- view state ----------------
struct View {
    int ox = 0, oy = 0;      // viewport top-left tile
    int sel = -1;            // selected unit index into g_world.units (-1 none)
    std::string notice;      // latest end-of-turn notice line (drained queue)
};

static Map world_map() {     // renderer Map over the session's live terrain plane
    Map m;
    m.w = g_world.map_w;
    m.h = g_world.map_h;
    m.tiles = g_world.terrain;
    return m;
}

static void clamp_view(View& v) {
    if (v.ox < 0) v.ox = 0;
    if (v.oy < 0) v.oy = 0;
    if (v.ox > g_world.map_w - 15) v.ox = g_world.map_w - 15;
    if (v.oy > g_world.map_h - 12) v.oy = g_world.map_h - 12;
}

static int next_own_unit(int from) {
    int n = (int)g_world.units.size();
    for (int k = 1; k <= n; ++k) {
        int i = (from + k) % n;
        if (g_world.units[i].alive && g_world.units[i].owner == 0 &&
            g_world.units[i].moves_left > 0) return i;
    }
    for (int k = 1; k <= n; ++k) {              // fall back: any own unit
        int i = (from + k) % n;
        if (g_world.units[i].alive && g_world.units[i].owner == 0) return i;
    }
    return -1;
}

static void center_on(View& v, int x, int y) {
    v.ox = x - 7; v.oy = y - 6;
    clamp_view(v);
}

// Direct one-tile step with the sim's movement rules: entering costs
// terrain_move[id]*3 credits; land units keep to land, ships to water;
// occupied tiles block (bump-combat is routed through the session's order
// layer in the next phase). Returns true if the unit moved.
static bool try_step(int ui, int dx, int dy) {
    if (ui < 0 || ui >= (int)g_world.units.size()) return false;
    Unit& u = g_world.units[ui];
    if (!u.alive || u.moves_left <= 0) return false;
    int nx = u.x + dx, ny = u.y + dy;
    if (nx < 0 || ny < 0 || nx >= g_world.map_w || ny >= g_world.map_h) return false;
    int id = g_world.terrain_id(nx, ny);
    bool water = (id == 25 || id == 26);
    bool naval = unit_stats(g_active_rules, u.type).move_class == 99;
    if (water != naval) return false;
    if (unit_at(g_world, nx, ny, ui) >= 0) return false;
    int base = id >= 0 && id < NTERRAIN ? g_active_rules.terrain_move[id % NTERRAIN] : 1;
    u.x = nx; u.y = ny;
    u.moves_left -= naval ? 3 : base * 3;
    if (u.moves_left < 0) u.moves_left = 0;
    return true;
}

static void end_turn(View& v) {
    game_step();                                  // the FULL session pipeline
    refresh_moves(g_world, g_active_rules);
    v.notice = g_turn_notices.empty() ? "" : g_turn_notices.back();
    g_turn_notices.clear();
    v.sel = next_own_unit(v.sel);
    if (v.sel >= 0) center_on(v, g_world.units[v.sel].x, g_world.units[v.sel].y);
}

// ---------------- frame composition ----------------
static void compose(const NativeAssets& as, const View& v, Surface& scr, bool flash_on) {
    Map m = world_map();
    render_mapview(scr, m, as.terrain, as.phys, as.woodtile, as.font,
                   g_game, g_world, v.ox, v.oy);
    auto on_screen = [&](int x, int y, int& px, int& py) {
        int vx = x - v.ox, vy = y - v.oy;
        if (vx < 0 || vy < 0 || vx >= 15 || vy >= 12) return false;
        px = vx * 16; py = 8 + vy * 16;
        return true;
    };
    // colonies: marker box + population count (the web Play view's scheme;
    // the sprite-faithful colony icon comes with the screens port)
    for (const Colony& c : g_world.colonies) {
        int px, py;
        if (c.x < 0 || !on_screen(c.x, c.y, px, py)) continue;
        scr.fill_rect(px + 2, py + 2, 12, 12, 6);        // brown block
        scr.rect_outline(px + 2, py + 2, 12, 12, 15);
        scr.draw_text(as.font, px + 5, py + 5, std::to_string(c.population), 15);
    }
    // units
    for (int i = 0; i < (int)g_world.units.size(); ++i) {
        const Unit& u = g_world.units[i];
        int px, py;
        if (!u.alive || !on_screen(u.x, u.y, px, py)) continue;
        if (u.type >= 0 && u.type < as.units.nframes)
            scr.blit_frame(as.units.frames[u.type], px, py);
        if (i == v.sel && flash_on)
            scr.rect_outline(px, py, 16, 16, 15);
    }
    // sidebar C: selected-unit readout
    if (v.sel >= 0 && v.sel < (int)g_world.units.size() && g_world.units[v.sel].alive) {
        const Unit& u = g_world.units[v.sel];
        const UnitStats& st = unit_stats(g_active_rules, u.type);
        scr.draw_text(as.font, 244, 140, st.name, 15);
        scr.draw_text(as.font, 244, 150,
                      "Moves: " + std::to_string(u.moves_left / 3) + "/" +
                      std::to_string(st.movement), 15);
        scr.draw_text(as.font, 244, 160,
                      "(" + std::to_string(u.x) + "," + std::to_string(u.y) + ")", 15);
    }
    scr.draw_text(as.font, 244, 180, "Turn " + std::to_string((long)g_game.turn), 15);
    // latest end-of-turn notice, bottom strip
    if (!v.notice.empty())
        scr.draw_text(as.font, 2, 193, v.notice.substr(0, 52), 15);
}

// ---------------- main ----------------
int main(int argc, char** argv) {
    std::string root = opt(argc, argv, "--root") ? opt(argc, argv, "--root") : ".";
    int scale  = opt(argc, argv, "--scale")  ? std::atoi(opt(argc, argv, "--scale"))  : 3;
    int frames = opt(argc, argv, "--frames") ? std::atoi(opt(argc, argv, "--frames")) : 0;
    int nation = opt(argc, argv, "--nation") ? std::atoi(opt(argc, argv, "--nation")) : 0;
    int diff   = opt(argc, argv, "--difficulty") ? std::atoi(opt(argc, argv, "--difficulty")) : 1;
    const char* out = opt(argc, argv, "--out");

    // The session reads data_extracted/ relative to the cwd (like `forge`).
    if (root != "." && chdir(root.c_str()) != 0) {
        std::fprintf(stderr, "viceroy: cannot chdir to %s\n", root.c_str());
        return 1;
    }
    NativeAssets as;
    try {
        as = load_native_assets(".");
    } catch (const std::exception& e) {
        std::fprintf(stderr, "viceroy: %s\n(run from the repo root or pass --root)\n",
                     e.what());
        return 1;
    }
    game_new(nation, diff);                       // the REAL scenario boot
    refresh_moves(g_world, g_active_rules);
    View v;
    v.sel = next_own_unit(-1);
    if (v.sel >= 0) center_on(v, g_world.units[v.sel].x, g_world.units[v.sel].y);

    if (frames > 0) {           // ---- headless smoke: compose frames, exit ----
        if (!out) { std::fprintf(stderr, "--frames needs --out BASE\n"); return 2; }
        for (int t = 0; t < frames; ++t) {
            Surface scr;
            scr.set_palette(as.pal);
            compose(as, v, scr, true);
            Image img = scr.to_rgb(scale);
            char name[512];
            std::snprintf(name, sizeof name, "%s_%02d.png", out, t);
            write_png_rgb(name, img.w, img.h, img.rgb);
            try_step(v.sel, 1, 0);
            end_turn(v);
        }
        std::printf("viceroy: wrote %d headless frame(s) %s_00..%02d.png "
                    "(turn %ld, %zu colonies, %zu units)\n",
                    frames, out, frames - 1, (long)g_game.turn,
                    g_world.colonies.size(), g_world.units.size());
        return 0;
    }

#if VICEROY_HAVE_SDL
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        std::fprintf(stderr, "SDL_Init: %s\n", SDL_GetError());
        return 1;
    }
    SDL_Window* win = SDL_CreateWindow("Viceroy",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        Surface::W * scale, Surface::H * scale, 0);
    SDL_Renderer* ren = SDL_CreateRenderer(win, -1, SDL_RENDERER_PRESENTVSYNC);
    SDL_Texture* tex = SDL_CreateTexture(ren, SDL_PIXELFORMAT_RGB24,
                                         SDL_TEXTUREACCESS_STREAMING,
                                         Surface::W, Surface::H);
    bool running = true;
    uint32_t t0 = SDL_GetTicks();
    while (running) {
        SDL_Event e;
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT) running = false;
            else if (e.type == SDL_KEYDOWN) {
                int dx = 0, dy = 0;
                switch (e.key.keysym.sym) {
                    case SDLK_ESCAPE: running = false; break;
                    case SDLK_TAB: {
                        v.sel = next_own_unit(v.sel);
                        if (v.sel >= 0)
                            center_on(v, g_world.units[v.sel].x, g_world.units[v.sel].y);
                        break;
                    }
                    case SDLK_RETURN:
                    case SDLK_e:      end_turn(v); break;
                    case SDLK_UP:    dy = -1; break;
                    case SDLK_DOWN:  dy = 1;  break;
                    case SDLK_LEFT:  dx = -1; break;
                    case SDLK_RIGHT: dx = 1;  break;
                    case SDLK_w: v.oy -= 2; clamp_view(v); break;   // scroll
                    case SDLK_s: v.oy += 2; clamp_view(v); break;
                    case SDLK_a: v.ox -= 2; clamp_view(v); break;
                    case SDLK_d: v.ox += 2; clamp_view(v); break;
                    default: break;
                }
                if ((dx || dy) && v.sel >= 0) {
                    try_step(v.sel, dx, dy);
                    const Unit& u = g_world.units[v.sel];
                    if (u.x < v.ox + 1 || u.x > v.ox + 13 ||
                        u.y < v.oy + 1 || u.y > v.oy + 10)
                        center_on(v, u.x, u.y);
                }
            } else if (e.type == SDL_MOUSEBUTTONDOWN) {
                int mx = e.button.x / scale, my = e.button.y / scale;
                if (mx < 240 && my >= 8) {              // inside the viewport
                    int tx = v.ox + mx / 16, ty = v.oy + (my - 8) / 16;
                    int ui = unit_at(g_world, tx, ty);
                    if (ui >= 0 && g_world.units[ui].owner == 0) v.sel = ui;
                }
            }
        }
        bool flash = ((SDL_GetTicks() - t0) / 300) & 1;
        Surface scr;
        scr.set_palette(as.pal);
        compose(as, v, scr, flash);
        Image img = scr.to_rgb(1);
        SDL_UpdateTexture(tex, nullptr, img.rgb.data(), Surface::W * 3);
        SDL_RenderClear(ren);
        SDL_RenderCopy(ren, tex, nullptr, nullptr);
        SDL_RenderPresent(ren);
    }
    SDL_DestroyTexture(tex);
    SDL_DestroyRenderer(ren);
    SDL_DestroyWindow(win);
    SDL_Quit();
    return 0;
#else
    std::fprintf(stderr, "viceroy: built without SDL2 -- only --frames N --out "
                         "BASE (headless) is available.\n");
    return 2;
#endif
}
