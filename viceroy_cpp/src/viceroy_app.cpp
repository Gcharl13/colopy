// viceroy_app.cpp -- the standalone game player, SDL2 edition (Linux/macOS,
// and the CI headless harness). All game behaviour lives in the shared
// platform-free forge::GameShell (map + orders, colony screen, Europe,
// advisor reports, popup flows); this file only pumps SDL events in and
// blits the 320x200 surface out at an integer scale.
//
//   viceroy [--root DIR] [--scale N]              windowed play (SDL2)
//   viceroy [--root DIR] --frames N --out BASE    headless: run N frames
//        [--shot europe|reportK]                  on a new game, write
//                                                 BASE.png -- the ctest
//                                                 smoke + packaging check.
//
// The headless mode needs no SDL.
#include "game_shell.hpp"
#include "mapview.hpp"       // MAP_MENU_X (the --shot menuN target)
#include "session.hpp"       // g_world/g_active_rules (the --shot sail target)
#include "sim/unit.hpp"
#include "surface.hpp"
#include "png_io.hpp"
#include <cstdio>
#include <cstring>
#include <string>
#include <unistd.h>          // chdir

#if VICEROY_HAVE_SDL
#include <SDL.h>
#endif

using forge::GameShell;

static const char* opt(int argc, char** argv, const char* name) {
    for (int i = 1; i + 1 < argc; ++i)
        if (std::strcmp(argv[i], name) == 0) return argv[i + 1];
    return nullptr;
}

int main(int argc, char** argv) {
    const char* root = opt(argc, argv, "--root");
    if (root && chdir(root) != 0) {
        std::fprintf(stderr, "viceroy: cannot chdir to %s\n", root);
        return 2;
    }
    GameShell shell;
    std::string err;
    if (!shell.boot(err)) {
        std::fprintf(stderr, "viceroy: %s\n(run from the game folder -- the one "
                             "with data/ and data_extracted/)\n", err.c_str());
        return 2;
    }

    // ---------------- headless: the ctest smoke + the packaging self-test --
    const char* frames_s = opt(argc, argv, "--frames");
    if (frames_s) {
        int frames = std::atoi(frames_s);
        const char* out = opt(argc, argv, "--out");
        std::string s = opt(argc, argv, "--shot") ? opt(argc, argv, "--shot") : "";
        if (s.rfind("boot", 0) == 0) {
            // boot-flow screenshots: walk the stages without starting a game
            if (s == "boot-diff") shell.key(forge::GK_ENTER, false);
            if (s == "boot-nation") {
                shell.key(forge::GK_ENTER, false);
                shell.key(forge::GK_ENTER, false);
            }
            if (s == "boot-scene")
                for (int i = 0; i < 3; ++i) shell.key(forge::GK_ENTER, false);
        } else {
            shell.new_game();
            if (s == "europe") shell.key('e', false);
            if (s.rfind("report", 0) == 0)
                shell.key(forge::GK_F1 + std::atoi(s.c_str() + 6) - 1, false);
            if (s.rfind("menu", 0) == 0)     // menuN: open pulldown N's dropdown
                shell.click(vc::MAP_MENU_X[std::atoi(s.c_str() + 4)], 3, 0);
            if (s == "colony") shell.open_colony(0);
            if (s == "buildmenu") {          // colony 0's construction menu
                shell.open_colony(0);
                shell.key('b', false);
            }
            if (s == "buildstart") {         // pick row 1, then reopen (shows
                shell.open_colony(0);        // the progress line + BUY row)
                shell.key('b', false);
                shell.key(forge::GK_DOWN, false);
                shell.key(forge::GK_ENTER, false);
                shell.key('b', false);
            }
            if (s == "sail") {               // caravel sails east, crosses,
                int ship = -1;               // then the Europe docks show it
                for (int i = 0; i < (int)g_world.units.size(); ++i) {
                    const vc::sim::Unit& u = g_world.units[i];
                    if (u.alive && u.owner == 0 &&
                        vc::sim::unit_stats(g_active_rules, u.type).move_class == 99) {
                        ship = i;
                        break;
                    }
                }
                for (int t = 0; t < 64 && shell.selected_unit() != ship; ++t)
                    shell.key(forge::GK_TAB, false);
                shell.key('e', false);       // Return to Europe (the ship)
                shell.key(forge::GK_ENTER, false);
                shell.key(forge::GK_ENTER, false);
                shell.key('e', false);       // open the Europe docks
            }
        }
        vc::Surface scr;
        bool booted = s.rfind("boot", 0) != 0;
        // end-turn ticks only on views where Enter is not a dialog action
        bool ticks = s.empty() || s == "europe" || s.rfind("report", 0) == 0;
        for (int f = 0; f < frames; ++f) {
            if (booted && ticks && f && (f % 3) == 0)
                shell.key(forge::GK_ENTER, false);   // end turns while playing
            shell.compose(scr, (f / 3) & 1);
        }
        if (out) {
            vc::Image img = scr.to_rgb(2);
            vc::write_png_rgb(std::string(out) + ".png", img.w, img.h, img.rgb);
            std::printf("viceroy: wrote %s.png (%dx%d)\n", out, img.w, img.h);
        }
        std::printf("viceroy: headless ok (%d frames, status: %s)\n", frames,
                    shell.status.c_str());
        return 0;
    }

#if VICEROY_HAVE_SDL
    int scale = opt(argc, argv, "--scale") ? std::atoi(opt(argc, argv, "--scale")) : 3;
    if (scale < 1) scale = 1;
    if (scale > 6) scale = 6;
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        std::fprintf(stderr, "SDL_Init: %s\n", SDL_GetError());
        return 1;
    }
    SDL_Window* win = SDL_CreateWindow("Viceroy",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        vc::Surface::W * scale, vc::Surface::H * scale, SDL_WINDOW_RESIZABLE);
    SDL_Renderer* ren = SDL_CreateRenderer(win, -1, SDL_RENDERER_PRESENTVSYNC);
    SDL_RenderSetLogicalSize(ren, vc::Surface::W, vc::Surface::H);
    SDL_RenderSetIntegerScale(ren, SDL_TRUE);
    SDL_Texture* tex = SDL_CreateTexture(ren, SDL_PIXELFORMAT_RGB24,
                                         SDL_TEXTUREACCESS_STREAMING,
                                         vc::Surface::W, vc::Surface::H);
    SDL_SetTextureScaleMode(tex, SDL_ScaleModeNearest);
    bool running = true;
    vc::Surface scr;
    while (running && !shell.quit_requested) {
        SDL_Event e;
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT) running = false;
            else if (e.type == SDL_KEYDOWN) {
                bool shift = (e.key.keysym.mod & KMOD_SHIFT) != 0;
                int k = 0;
                switch (e.key.keysym.sym) {
                    case SDLK_UP: k = forge::GK_UP; break;
                    case SDLK_DOWN: k = forge::GK_DOWN; break;
                    case SDLK_LEFT: k = forge::GK_LEFT; break;
                    case SDLK_RIGHT: k = forge::GK_RIGHT; break;
                    case SDLK_RETURN: case SDLK_KP_ENTER: k = forge::GK_ENTER; break;
                    case SDLK_ESCAPE: k = forge::GK_ESC; break;
                    case SDLK_TAB: k = forge::GK_TAB; break;
                    case SDLK_F11:
                        shell.status = shell.save("viceroy_save.json");
                        break;
                    default:
                        if (e.key.keysym.sym >= SDLK_F1 &&
                            e.key.keysym.sym <= SDLK_F10)
                            k = forge::GK_F1 + (int)(e.key.keysym.sym - SDLK_F1);
                        else if (e.key.keysym.sym > 0 && e.key.keysym.sym < 128)
                            k = (int)e.key.keysym.sym;
                }
                if (k) shell.key(k, shift);
            } else if (e.type == SDL_MOUSEBUTTONDOWN) {
                // logical size maps window coords into the 320x200 space
                shell.click(e.button.x, e.button.y,
                            e.button.button == SDL_BUTTON_RIGHT ? 1 : 0);
            }
        }
        shell.compose(scr, ((SDL_GetTicks() / 300) & 1) != 0);
        vc::Image img = scr.to_rgb(1);
        SDL_UpdateTexture(tex, nullptr, img.rgb.data(), vc::Surface::W * 3);
        SDL_RenderClear(ren);
        SDL_RenderCopy(ren, tex, nullptr, nullptr);
        SDL_RenderPresent(ren);
        SDL_SetWindowTitle(win, shell.status.empty()
                                    ? "Viceroy"
                                    : ("Viceroy -- " + shell.status).c_str());
    }
    SDL_DestroyTexture(tex);
    SDL_DestroyRenderer(ren);
    SDL_DestroyWindow(win);
    SDL_Quit();
    return 0;
#else
    std::fprintf(stderr, "viceroy: built without SDL2 -- only --frames N "
                         "--out BASE headless mode is available.\n");
    return 2;
#endif
}
