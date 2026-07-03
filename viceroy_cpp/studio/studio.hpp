// studio.hpp -- the native Forge editor's platform-driver seam.
//
// Forge (the desktop engine) is a fully NATIVE application: Dear ImGui
// widgets over a per-platform driver -- SDL2 (Linux/dev) or Win32 + Direct3D
// 11 (Windows, zero external dependencies). No web technology anywhere.
//
// The driver owns the window + renderer + ImGui platform/renderer backends;
// studio_main.cpp owns everything else (project, panels, engine calls).
#pragma once
#include <cstdint>
#include <string>

namespace studio {

// Streaming RGB24 texture for panels that blit composed frames (the game
// view). `id` is the value handed to ImGui::Image.
struct Texture {
    void*    id = nullptr;   // ImTextureID payload (backend-specific)
    int      w = 0, h = 0;
};

struct Driver {
    virtual ~Driver() = default;
    // False once the user closed the window. Pumps events into ImGui.
    virtual bool frame_begin() = 0;
    virtual void frame_end() = 0;
    virtual Texture create_texture(int w, int h) = 0;
    virtual void    update_texture(Texture& t, const uint8_t* rgb24) = 0;
};

// Create the platform driver + window (title, initial size). Initializes
// ImGui (context, docking, style). Null on failure (message on stderr).
Driver* create_driver(const std::string& title, int w, int h);
void    destroy_driver(Driver* d);

// The application body: run the editor over an opened project directory
// (already the current working directory). Returns the process exit code.
int studio_run(Driver& drv, const std::string& project_dir);

} // namespace studio
