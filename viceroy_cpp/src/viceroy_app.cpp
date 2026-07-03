// viceroy_app.cpp -- the native application (N2 skeleton).
//
// A thin SDL2 shell over the 320x200 indexed compositor (mapview.cpp) and the
// pure sim core: the framebuffer is composed exactly like the `nativemap`
// harness frame, then integer-scaled into a window; input drives the sim
// directly (select unit, step with the thirds move-credit system, end turn
// via sim::step_turn). The full game session (colonies, Europe, natives,
// events -- the forge engine layer) arrives with the N0 session extraction;
// this skeleton is the honest playable spine the sim already provides.
//
// Modes:
//   viceroy [--root DIR] [--mp FILE] [--scale N]     interactive window (SDL2)
//   viceroy --frames N --out BASE [...]              headless: compose N frames
//                                                    to BASE_00..png and exit
//                                                    (no SDL needed -- the
//                                                    ctest smoke path)
#include "native_assets.hpp"
#include "surface.hpp"
#include "mapview.hpp"
#include "mp.hpp"
#include "sim/game.hpp"
#include "sim/unit.hpp"
#include "sim/unit_turn.hpp"
#include "sim/ref.hpp"
#include <cstdio>
#include <cstring>
#include <random>
#include <string>

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

// ---------------- game bootstrap (skeleton) ----------------
// The honest new-game landing: the human power's Caravel on open water beside
// a coastal tile, a Soldier + Pioneer ashore (the @DIFFICULTY starting party;
// scenario/colony seeding is forge-session territory -- N0).
struct App {
    Map map;
    GameState g;
    World w;
    int ox = 38, oy = 56;        // viewport top-left tile
    int sel = -1;                // selected unit index (-1 none)
    std::mt19937 rngeng{12345};
    int turn_no = 1;

    long rng(int lo, int hi) {
        if (hi <= lo) return lo;
        return lo + (int)(rngeng() % (unsigned)(hi - lo + 1));
    }
};

static bool water_tile(const Map& m, int x, int y) {
    if (x < 0 || y < 0 || x >= m.w || y >= m.h) return true;
    int id = m.tiles[y * m.w + x] & 0x1F;
    return id == 0x19 || id == 0x1A;
}

static void seed_landing(App& a) {
    // scan westward from the sea-lane edge on the viewport's middle row for
    // the first water tile whose west neighbour is land -> the landing spot.
    int row = a.oy + 6;
    for (int x = a.map.w - 2; x > 1; --x) {
        if (water_tile(a.map, x, row) && !water_tile(a.map, x - 1, row)) {
            Unit ship; ship.type = CARAVEL; ship.owner = 0; ship.x = x; ship.y = row;
            Unit sol;  sol.type = SOLDIERS; sol.owner = 0; sol.x = x - 1; sol.y = row;
            Unit pio;  pio.type = PIONEERS; pio.owner = 0; pio.x = x - 1; pio.y = row;
            a.w.units.push_back(ship);
            a.w.units.push_back(sol);
            a.w.units.push_back(pio);
            a.ox = x - 8; a.oy = row - 6;
            break;
        }
    }
    if (a.ox < 0) a.ox = 0;
    if (a.oy < 0) a.oy = 0;
}

static void clamp_view(App& a) {
    if (a.ox < 0) a.ox = 0;
    if (a.oy < 0) a.oy = 0;
    if (a.ox > a.map.w - 15) a.ox = a.map.w - 15;
    if (a.oy > a.map.h - 12) a.oy = a.map.h - 12;
}

// Direct one-tile step with the byte-verified movement rules the sim uses:
// entering costs terrain_move[id]*3 move-credits (refresh gives movement*3);
// land units keep to land, ships to water. Occupied tiles block (combat is
// session territory). Returns true if the unit moved.
static bool try_step(App& a, int ui, int dx, int dy) {
    if (ui < 0 || ui >= (int)a.w.units.size()) return false;
    Unit& u = a.w.units[ui];
    if (!u.alive || u.moves_left <= 0) return false;
    int nx = u.x + dx, ny = u.y + dy;
    if (nx < 0 || ny < 0 || nx >= a.map.w || ny >= a.map.h) return false;
    const RuleData& rd = default_rules();
    bool naval = unit_stats(rd, u.type).move_class == 99;
    if (water_tile(a.map, nx, ny) != naval) return false;
    if (unit_at(a.w, nx, ny, ui) >= 0) return false;
    int id = a.map.tiles[ny * a.map.w + nx] & 0x1F;
    int cost = naval ? 3 : (id < NTERRAIN ? rd.terrain_move[id] * 3 : 3);
    u.x = nx; u.y = ny;
    u.moves_left -= cost;
    if (u.moves_left < 0) u.moves_left = 0;
    return true;
}

static void end_turn(App& a) {
    auto rngfn = [&a](int lo, int hi) { return (int)a.rng(lo, hi); };
    step_turn(a.g, a.w, rngfn);
    refresh_moves(a.w);
    ++a.turn_no;
}

static int next_own_unit(const App& a, int from) {
    int n = (int)a.w.units.size();
    for (int k = 1; k <= n; ++k) {
        int i = (from + k) % n;
        if (a.w.units[i].alive && a.w.units[i].owner == 0) return i;
    }
    return -1;
}

// ---------------- frame composition ----------------
static void compose(App& a, const NativeAssets& as, Surface& scr, bool flash_on) {
    render_mapview(scr, a.map, as.terrain, as.phys, as.woodtile, as.font,
                   a.g, a.w, a.ox, a.oy);
    // units overlay (map_view.md: viewport tiles at (x-ox)*16, 8+(y-oy)*16)
    for (int i = 0; i < (int)a.w.units.size(); ++i) {
        const Unit& u = a.w.units[i];
        if (!u.alive) continue;
        int vx = u.x - a.ox, vy = u.y - a.oy;
        if (vx < 0 || vy < 0 || vx >= 15 || vy >= 12) continue;
        int px = vx * 16, py = 8 + vy * 16;
        if (u.type >= 0 && u.type < as.units.nframes)
            scr.blit_frame(as.units.frames[u.type], px, py);
        if (i == a.sel && flash_on)
            scr.rect_outline(px, py, 16, 16, 15);     // selection flash, white
    }
    // sidebar C: selected-unit readout (approx text tier, same as sidebar B)
    if (a.sel >= 0 && a.sel < (int)a.w.units.size() && a.w.units[a.sel].alive) {
        const Unit& u = a.w.units[a.sel];
        const UnitStats& st = unit_stats(u.type);
        scr.draw_text(as.font, 244, 140, st.name, 15);
        scr.draw_text(as.font, 244, 150,
                      "Moves: " + std::to_string(u.moves_left / 3) + "/" +
                      std::to_string(st.movement), 15);
        scr.draw_text(as.font, 244, 160,
                      "(" + std::to_string(u.x) + "," + std::to_string(u.y) + ")", 15);
    }
    scr.draw_text(as.font, 244, 180, "Turn " + std::to_string(a.turn_no), 15);
}

// ---------------- main ----------------
int main(int argc, char** argv) {
    std::string root = opt(argc, argv, "--root") ? opt(argc, argv, "--root") : ".";
    std::string mp = opt(argc, argv, "--mp") ? opt(argc, argv, "--mp")
                                             : root + "/data_extracted/map/AMER2.MP";
    int scale  = opt(argc, argv, "--scale")  ? std::atoi(opt(argc, argv, "--scale"))  : 3;
    int frames = opt(argc, argv, "--frames") ? std::atoi(opt(argc, argv, "--frames")) : 0;
    const char* out = opt(argc, argv, "--out");

    NativeAssets as;
    App a;
    try {
        as = load_native_assets(root);
        a.map = load_mp(mp);
    } catch (const std::exception& e) {
        std::fprintf(stderr, "viceroy: %s\n", e.what());
        return 1;
    }
    a.g.difficulty = 1;
    a.g.powers[0].gold = 600;
    a.g.ref = ref_start(a.g.difficulty);
    seed_landing(a);
    clamp_view(a);
    refresh_moves(a.w);
    a.sel = next_own_unit(a, -1);

    if (frames > 0) {           // ---- headless smoke: compose frames, exit ----
        if (!out) { std::fprintf(stderr, "--frames needs --out BASE\n"); return 2; }
        for (int t = 0; t < frames; ++t) {
            Surface scr;
            scr.set_palette(as.pal);
            compose(a, as, scr, true);
            Image img = scr.to_rgb(scale);
            char name[512];
            std::snprintf(name, sizeof name, "%s_%02d.png", out, t);
            write_png_rgb(name, img.w, img.h, img.rgb);
            // exercise the loop between frames: move the selected unit east,
            // then end the turn -- proves sim+render round-trip headlessly.
            try_step(a, a.sel, 1, 0);
            end_turn(a);
        }
        std::printf("viceroy: wrote %d headless frame(s) %s_00..%02d.png\n",
                    frames, out, frames - 1);
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
                    case SDLK_TAB:    a.sel = next_own_unit(a, a.sel); break;
                    case SDLK_RETURN:
                    case SDLK_e:      end_turn(a); break;
                    case SDLK_UP:    dy = -1; break;
                    case SDLK_DOWN:  dy = 1;  break;
                    case SDLK_LEFT:  dx = -1; break;
                    case SDLK_RIGHT: dx = 1;  break;
                    case SDLK_w: a.oy -= 2; clamp_view(a); break;   // scroll
                    case SDLK_s: a.oy += 2; clamp_view(a); break;
                    case SDLK_a: a.ox -= 2; clamp_view(a); break;
                    case SDLK_d: a.ox += 2; clamp_view(a); break;
                    default: break;
                }
                if ((dx || dy) && a.sel >= 0) {
                    try_step(a, a.sel, dx, dy);
                    // keep the selected unit in view
                    const Unit& u = a.w.units[a.sel];
                    if (u.x < a.ox + 1)  a.ox = u.x - 1;
                    if (u.x > a.ox + 13) a.ox = u.x - 13;
                    if (u.y < a.oy + 1)  a.oy = u.y - 1;
                    if (u.y > a.oy + 10) a.oy = u.y - 10;
                    clamp_view(a);
                }
            } else if (e.type == SDL_MOUSEBUTTONDOWN) {
                int mx = e.button.x / scale, my = e.button.y / scale;
                if (mx < 240 && my >= 8) {              // inside the viewport
                    int tx = a.ox + mx / 16, ty = a.oy + (my - 8) / 16;
                    int ui = unit_at(a.w, tx, ty);
                    if (ui >= 0 && a.w.units[ui].owner == 0) a.sel = ui;
                }
            }
        }
        bool flash = ((SDL_GetTicks() - t0) / 300) & 1;
        Surface scr;
        scr.set_palette(as.pal);
        compose(a, as, scr, flash);
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
