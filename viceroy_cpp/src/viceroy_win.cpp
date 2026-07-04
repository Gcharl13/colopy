// viceroy_win.cpp -- the standalone game player for modern Windows: pure
// Win32 + GDI (no SDL, no Direct3D, no ImGui) over the shared platform-free
// forge::GameShell. StretchDIBits presents the 320x200 surface at the largest
// integer scale that fits the client area (letterboxed), point-sampled crisp.
//
// Viceroy.exe runs from the game folder (the one carrying data/ and
// data_extracted/) or is given it as the first command-line argument.
#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <windowsx.h>        // GET_X_LPARAM / GET_Y_LPARAM
#include "game_shell.hpp"
#include "surface.hpp"
#include <direct.h>          // _chdir
#include <string>
#include <vector>

using forge::GameShell;

static GameShell g_shell;
static vc::Surface g_scr;
static std::vector<uint8_t> g_bgra;      // 320x200 * 4, top-down DIB
static bool g_flash = false;

static void present(HWND hwnd, HDC dc) {
    g_shell.compose(g_scr, g_flash);
    vc::Image img = g_scr.to_rgb(1);
    g_bgra.resize((size_t)vc::Surface::W * vc::Surface::H * 4);
    for (size_t i = 0, n = (size_t)vc::Surface::W * vc::Surface::H; i < n; ++i) {
        g_bgra[i * 4 + 0] = img.rgb[i * 3 + 2];
        g_bgra[i * 4 + 1] = img.rgb[i * 3 + 1];
        g_bgra[i * 4 + 2] = img.rgb[i * 3 + 0];
        g_bgra[i * 4 + 3] = 255;
    }
    RECT rc;
    GetClientRect(hwnd, &rc);
    int cw = rc.right, ch = rc.bottom;
    int s = cw / vc::Surface::W < ch / vc::Surface::H ? cw / vc::Surface::W
                                                      : ch / vc::Surface::H;
    if (s < 1) s = 1;
    int dw = vc::Surface::W * s, dh = vc::Surface::H * s;
    int dx = (cw - dw) / 2, dy = (ch - dh) / 2;
    // letterbox bars
    HBRUSH black = (HBRUSH)GetStockObject(BLACK_BRUSH);
    RECT bar;
    bar = {0, 0, cw, dy}; FillRect(dc, &bar, black);
    bar = {0, dy + dh, cw, ch}; FillRect(dc, &bar, black);
    bar = {0, 0, dx, ch}; FillRect(dc, &bar, black);
    bar = {dx + dw, 0, cw, ch}; FillRect(dc, &bar, black);
    BITMAPINFO bi{};
    bi.bmiHeader.biSize = sizeof bi.bmiHeader;
    bi.bmiHeader.biWidth = vc::Surface::W;
    bi.bmiHeader.biHeight = -vc::Surface::H;   // top-down
    bi.bmiHeader.biPlanes = 1;
    bi.bmiHeader.biBitCount = 32;
    bi.bmiHeader.biCompression = BI_RGB;
    SetStretchBltMode(dc, COLORONCOLOR);       // point sampling: crisp pixels
    StretchDIBits(dc, dx, dy, dw, dh, 0, 0, vc::Surface::W, vc::Surface::H,
                  g_bgra.data(), &bi, DIB_RGB_COLORS, SRCCOPY);
}

// window client -> native 320x200 coords (same letterbox math as present)
static bool to_native(HWND hwnd, int wx, int wy, int& nx, int& ny) {
    RECT rc;
    GetClientRect(hwnd, &rc);
    int cw = rc.right, ch = rc.bottom;
    int s = cw / vc::Surface::W < ch / vc::Surface::H ? cw / vc::Surface::W
                                                      : ch / vc::Surface::H;
    if (s < 1) s = 1;
    int dw = vc::Surface::W * s, dh = vc::Surface::H * s;
    int dx = (cw - dw) / 2, dy = (ch - dh) / 2;
    nx = (wx - dx) / s;
    ny = (wy - dy) / s;
    return nx >= 0 && ny >= 0 && nx < vc::Surface::W && ny < vc::Surface::H;
}

static LRESULT CALLBACK wndproc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp) {
    switch (msg) {
        case WM_DESTROY:
            PostQuitMessage(0);
            return 0;
        case WM_PAINT: {
            PAINTSTRUCT ps;
            HDC dc = BeginPaint(hwnd, &ps);
            present(hwnd, dc);
            EndPaint(hwnd, &ps);
            return 0;
        }
        case WM_TIMER:
            g_flash = !g_flash;
            InvalidateRect(hwnd, nullptr, FALSE);
            if (g_shell.quit_requested) DestroyWindow(hwnd);
            return 0;
        case WM_LBUTTONDOWN:
        case WM_RBUTTONDOWN: {
            int nx, ny;
            if (to_native(hwnd, GET_X_LPARAM(lp), GET_Y_LPARAM(lp), nx, ny))
                g_shell.click(nx, ny, msg == WM_RBUTTONDOWN ? 1 : 0);
            InvalidateRect(hwnd, nullptr, FALSE);
            return 0;
        }
        case WM_KEYDOWN: {
            bool shift = (GetKeyState(VK_SHIFT) & 0x8000) != 0;
            int k = 0;
            switch (wp) {
                case VK_UP: k = forge::GK_UP; break;
                case VK_DOWN: k = forge::GK_DOWN; break;
                case VK_LEFT: k = forge::GK_LEFT; break;
                case VK_RIGHT: k = forge::GK_RIGHT; break;
                case VK_RETURN: k = forge::GK_ENTER; break;
                case VK_ESCAPE: k = forge::GK_ESC; break;
                case VK_TAB: k = forge::GK_TAB; break;
                case VK_SPACE: k = ' '; break;
                case VK_F11:
                    g_shell.status = g_shell.save("viceroy_save.txt");
                    break;
                case VK_OEM_MINUS: k = '-'; break;
                default:
                    if (wp >= VK_F1 && wp <= VK_F10)
                        k = forge::GK_F1 + (int)(wp - VK_F1);
                    else if (wp >= 'A' && wp <= 'Z')
                        k = (int)wp - 'A' + 'a';       // shell takes lowercase
                    else if (wp >= '0' && wp <= '9')
                        k = (int)wp;
            }
            if (k) g_shell.key(k, shift);
            InvalidateRect(hwnd, nullptr, FALSE);
            return 0;
        }
    }
    return DefWindowProcA(hwnd, msg, wp, lp);
}

int WINAPI WinMain(HINSTANCE hi, HINSTANCE, LPSTR cmdline, int) {
    if (cmdline && cmdline[0]) {
        std::string dir = cmdline;
        if (dir.size() >= 2 && dir.front() == '"' && dir.back() == '"')
            dir = dir.substr(1, dir.size() - 2);
        _chdir(dir.c_str());
    }
    std::string err;
    if (!g_shell.boot(err)) {
        MessageBoxA(nullptr,
                    ("Could not load the game data:\n\n" + err +
                     "\n\nPut Viceroy.exe in the game folder (the one with "
                     "data\\ and data_extracted\\), or pass that folder as "
                     "the command line argument.")
                        .c_str(),
                    "Viceroy", MB_ICONERROR);
        return 2;
    }

    WNDCLASSA wc{};
    wc.lpfnWndProc = wndproc;
    wc.hInstance = hi;
    wc.hCursor = LoadCursor(nullptr, IDC_ARROW);
    wc.lpszClassName = "ViceroyPlayer";
    RegisterClassA(&wc);
    RECT want{0, 0, vc::Surface::W * 3, vc::Surface::H * 3};
    AdjustWindowRect(&want, WS_OVERLAPPEDWINDOW, FALSE);
    HWND hwnd = CreateWindowA("ViceroyPlayer", "Viceroy", WS_OVERLAPPEDWINDOW,
                              CW_USEDEFAULT, CW_USEDEFAULT,
                              want.right - want.left, want.bottom - want.top,
                              nullptr, nullptr, hi, nullptr);
    ShowWindow(hwnd, SW_SHOW);
    SetTimer(hwnd, 1, 300, nullptr);     // selected-unit blink + repaint tick

    MSG msg;
    while (GetMessageA(&msg, nullptr, 0, 0) > 0) {
        TranslateMessage(&msg);
        DispatchMessageA(&msg);
    }
    return 0;
}
#endif // _WIN32
