// driver_sdl2.cpp -- the SDL2 + SDL_Renderer platform driver (Linux/dev).
#include "studio.hpp"
#include "imgui.h"
#include "backends/imgui_impl_sdl2.h"
#include "backends/imgui_impl_sdlrenderer2.h"
#include <SDL.h>
#include <cstdio>

namespace studio {
namespace {

struct Sdl2Driver : Driver {
    SDL_Window*   win = nullptr;
    SDL_Renderer* ren = nullptr;
    bool quit = false;
    // headless hooks (CI / remote dev): FORGE_FRAMES=N quits after N frames;
    // FORGE_SHOT=path.bmp captures the backbuffer on the last frame.
    long frame_no = 0, max_frames = 0;
    const char* shot = nullptr;

    bool frame_begin() override {
        SDL_Event e;
        while (SDL_PollEvent(&e)) {
            ImGui_ImplSDL2_ProcessEvent(&e);
            if (e.type == SDL_QUIT) quit = true;
            if (e.type == SDL_WINDOWEVENT && e.window.event == SDL_WINDOWEVENT_CLOSE &&
                e.window.windowID == SDL_GetWindowID(win)) quit = true;
        }
        if (quit) return false;
        ImGui_ImplSDLRenderer2_NewFrame();
        ImGui_ImplSDL2_NewFrame();
        ImGui::NewFrame();
        return true;
    }
    void frame_end() override {
        ImGui::Render();
        SDL_SetRenderDrawColor(ren, 24, 24, 28, 255);
        SDL_RenderClear(ren);
        ImGui_ImplSDLRenderer2_RenderDrawData(ImGui::GetDrawData(), ren);
        ++frame_no;
        if (max_frames > 0 && frame_no >= max_frames) {
            if (shot) {
                int w, h;
                SDL_GetRendererOutputSize(ren, &w, &h);
                SDL_Surface* s = SDL_CreateRGBSurfaceWithFormat(0, w, h, 24,
                                                                SDL_PIXELFORMAT_RGB24);
                if (s && SDL_RenderReadPixels(ren, nullptr, SDL_PIXELFORMAT_RGB24,
                                              s->pixels, s->pitch) == 0)
                    SDL_SaveBMP(s, shot);
                if (s) SDL_FreeSurface(s);
            }
            quit = true;
        }
        SDL_RenderPresent(ren);
    }
    Texture create_texture(int w, int h) override {
        Texture t;
        SDL_Texture* tex = SDL_CreateTexture(ren, SDL_PIXELFORMAT_RGB24,
                                             SDL_TEXTUREACCESS_STREAMING, w, h);
        SDL_SetTextureScaleMode(tex, SDL_ScaleModeNearest);   // crisp pixels
        t.id = (void*)tex;
        t.w = w; t.h = h;
        return t;
    }
    void update_texture(Texture& t, const uint8_t* rgb24) override {
        SDL_UpdateTexture((SDL_Texture*)t.id, nullptr, rgb24, t.w * 3);
    }
};

}  // namespace

Driver* create_driver(const std::string& title, int w, int h) {
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        std::fprintf(stderr, "SDL_Init: %s\n", SDL_GetError());
        return nullptr;
    }
    auto* d = new Sdl2Driver;
    d->win = SDL_CreateWindow(title.c_str(), SDL_WINDOWPOS_CENTERED,
                              SDL_WINDOWPOS_CENTERED, w, h,
                              SDL_WINDOW_RESIZABLE | SDL_WINDOW_ALLOW_HIGHDPI);
    d->ren = SDL_CreateRenderer(d->win, -1,
                                SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!d->ren) d->ren = SDL_CreateRenderer(d->win, -1, 0);   // software fallback
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGui::GetIO().ConfigFlags |= ImGuiConfigFlags_DockingEnable;
    ImGui::StyleColorsDark();
    ImGui_ImplSDL2_InitForSDLRenderer(d->win, d->ren);
    ImGui_ImplSDLRenderer2_Init(d->ren);
    if (const char* f = std::getenv("FORGE_FRAMES")) d->max_frames = std::atol(f);
    d->shot = std::getenv("FORGE_SHOT");
    return d;
}

void destroy_driver(Driver* base) {
    auto* d = (Sdl2Driver*)base;
    ImGui_ImplSDLRenderer2_Shutdown();
    ImGui_ImplSDL2_Shutdown();
    ImGui::DestroyContext();
    SDL_DestroyRenderer(d->ren);
    SDL_DestroyWindow(d->win);
    SDL_Quit();
    delete d;
}

} // namespace studio
