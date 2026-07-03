// driver_win32_dx11.cpp -- the Win32 + Direct3D 11 platform driver (Windows).
// Zero external dependencies: user32/d3d11/dxgi ship with Windows + MinGW.
#include "studio.hpp"
#include "imgui.h"
#include "backends/imgui_impl_win32.h"
#include "backends/imgui_impl_dx11.h"
#include <windows.h>
#include <d3d11.h>
#include <cstdio>

extern IMGUI_IMPL_API LRESULT ImGui_ImplWin32_WndProcHandler(HWND, UINT, WPARAM, LPARAM);

namespace studio {
namespace {

struct Dx11Driver : Driver {
    HWND hwnd = nullptr;
    ID3D11Device*           dev = nullptr;
    ID3D11DeviceContext*    ctx = nullptr;
    IDXGISwapChain*         swap = nullptr;
    ID3D11RenderTargetView* rtv = nullptr;
    bool quit = false;
    bool resize_pending = false;
    UINT resize_w = 0, resize_h = 0;

    void create_rtv() {
        ID3D11Texture2D* back = nullptr;
        swap->GetBuffer(0, IID_PPV_ARGS(&back));
        dev->CreateRenderTargetView(back, nullptr, &rtv);
        back->Release();
    }
    bool frame_begin() override {
        MSG msg;
        while (PeekMessage(&msg, nullptr, 0, 0, PM_REMOVE)) {
            TranslateMessage(&msg);
            DispatchMessage(&msg);
            if (msg.message == WM_QUIT) quit = true;
        }
        if (quit) return false;
        if (resize_pending && dev) {
            if (rtv) { rtv->Release(); rtv = nullptr; }
            swap->ResizeBuffers(0, resize_w, resize_h, DXGI_FORMAT_UNKNOWN, 0);
            create_rtv();
            resize_pending = false;
        }
        ImGui_ImplDX11_NewFrame();
        ImGui_ImplWin32_NewFrame();
        ImGui::NewFrame();
        return true;
    }
    void frame_end() override {
        ImGui::Render();
        const float bg[4] = {0.09f, 0.09f, 0.11f, 1.0f};
        ctx->OMSetRenderTargets(1, &rtv, nullptr);
        ctx->ClearRenderTargetView(rtv, bg);
        ImGui_ImplDX11_RenderDrawData(ImGui::GetDrawData());
        swap->Present(1, 0);
    }
    Texture create_texture(int w, int h) override {
        Texture t; t.w = w; t.h = h;
        D3D11_TEXTURE2D_DESC td{};
        td.Width = w; td.Height = h;
        td.MipLevels = 1; td.ArraySize = 1;
        td.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
        td.SampleDesc.Count = 1;
        td.Usage = D3D11_USAGE_DYNAMIC;
        td.BindFlags = D3D11_BIND_SHADER_RESOURCE;
        td.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
        ID3D11Texture2D* tex = nullptr;
        dev->CreateTexture2D(&td, nullptr, &tex);
        ID3D11ShaderResourceView* srv = nullptr;
        dev->CreateShaderResourceView(tex, nullptr, &srv);
        tex->Release();                         // srv keeps a reference
        t.id = (void*)srv;
        return t;
    }
    void update_texture(Texture& t, const uint8_t* rgb24) override {
        auto* srv = (ID3D11ShaderResourceView*)t.id;
        ID3D11Resource* res = nullptr;
        srv->GetResource(&res);
        D3D11_MAPPED_SUBRESOURCE m{};
        if (SUCCEEDED(ctx->Map(res, 0, D3D11_MAP_WRITE_DISCARD, 0, &m))) {
            for (int y = 0; y < t.h; ++y) {
                auto* dst = (uint8_t*)m.pData + (size_t)y * m.RowPitch;
                const uint8_t* src = rgb24 + (size_t)y * t.w * 3;
                for (int x = 0; x < t.w; ++x) {
                    dst[x * 4 + 0] = src[x * 3 + 0];
                    dst[x * 4 + 1] = src[x * 3 + 1];
                    dst[x * 4 + 2] = src[x * 3 + 2];
                    dst[x * 4 + 3] = 0xFF;
                }
            }
            ctx->Unmap(res, 0);
        }
        res->Release();
    }
};

Dx11Driver* g_drv = nullptr;

LRESULT WINAPI wnd_proc(HWND h, UINT m, WPARAM w, LPARAM l) {
    if (ImGui_ImplWin32_WndProcHandler(h, m, w, l)) return 1;
    switch (m) {
        case WM_SIZE:
            if (g_drv && w != SIZE_MINIMIZED) {
                g_drv->resize_pending = true;
                g_drv->resize_w = LOWORD(l);
                g_drv->resize_h = HIWORD(l);
            }
            return 0;
        case WM_DESTROY:
            PostQuitMessage(0);
            return 0;
    }
    return DefWindowProc(h, m, w, l);
}

}  // namespace

Driver* create_driver(const std::string& title, int w, int h) {
    auto* d = new Dx11Driver;
    g_drv = d;
    WNDCLASSEXA wc{sizeof(wc), CS_CLASSDC, wnd_proc, 0, 0,
                   GetModuleHandle(nullptr), nullptr, LoadCursor(nullptr, IDC_ARROW),
                   nullptr, nullptr, "ForgeStudio", nullptr};
    RegisterClassExA(&wc);
    d->hwnd = CreateWindowA("ForgeStudio", title.c_str(), WS_OVERLAPPEDWINDOW,
                            CW_USEDEFAULT, CW_USEDEFAULT, w, h,
                            nullptr, nullptr, wc.hInstance, nullptr);
    DXGI_SWAP_CHAIN_DESC sd{};
    sd.BufferCount = 2;
    sd.BufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    sd.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
    sd.OutputWindow = d->hwnd;
    sd.SampleDesc.Count = 1;
    sd.Windowed = TRUE;
    sd.SwapEffect = DXGI_SWAP_EFFECT_DISCARD;
    D3D_FEATURE_LEVEL lvl;
    if (FAILED(D3D11CreateDeviceAndSwapChain(nullptr, D3D_DRIVER_TYPE_HARDWARE,
            nullptr, 0, nullptr, 0, D3D11_SDK_VERSION, &sd, &d->swap, &d->dev,
            &lvl, &d->ctx)) &&
        FAILED(D3D11CreateDeviceAndSwapChain(nullptr, D3D_DRIVER_TYPE_WARP,
            nullptr, 0, nullptr, 0, D3D11_SDK_VERSION, &sd, &d->swap, &d->dev,
            &lvl, &d->ctx))) {
        std::fprintf(stderr, "Forge: Direct3D 11 init failed\n");
        delete d;
        return nullptr;
    }
    d->create_rtv();
    ShowWindow(d->hwnd, SW_SHOWDEFAULT);
    UpdateWindow(d->hwnd);
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGui::GetIO().ConfigFlags |= ImGuiConfigFlags_DockingEnable;
    ImGui::StyleColorsDark();
    ImGui_ImplWin32_Init(d->hwnd);
    ImGui_ImplDX11_Init(d->dev, d->ctx);
    return d;
}

void destroy_driver(Driver* base) {
    auto* d = (Dx11Driver*)base;
    ImGui_ImplDX11_Shutdown();
    ImGui_ImplWin32_Shutdown();
    ImGui::DestroyContext();
    if (d->rtv) d->rtv->Release();
    if (d->swap) d->swap->Release();
    if (d->ctx) d->ctx->Release();
    if (d->dev) d->dev->Release();
    DestroyWindow(d->hwnd);
    g_drv = nullptr;
    delete d;
}

} // namespace studio
