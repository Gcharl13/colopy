// Viceroy on the Teensy 4.1 -- the bare-metal frontend over the shared
// platform-free forge::GameShell (the same game the desktop players run).
//
// Wiring (defaults; see README.md):
//   ILI9341 320x240 SPI TFT: CS=10 DC=9 RST=8 MOSI=11 SCK=13 (SPI0), BL->3V3
//   Buttons (to GND, INPUT_PULLUP): UP=2 DOWN=3 LEFT=4 RIGHT=5 ENTER=6 ESC=7
//   Keyboard: the Teensy 4.1 USB HOST port (USBHost_t36)
//   Data: microSD (built-in socket) carrying the player package data folders
//   Memory: PSRAM soldered (8 MB minimum, 2x8 MB recommended) -- the record
//   store + decoded art live there via the operator-new override below.
//
// STATUS: compile-verified port; not yet exercised on hardware -- expect to
// tune SPI clock, input pins and boot timing on the bench.
#include <Arduino.h>
#include <SD.h>
#include <USBHost_t36.h>
#include "game_shell.hpp"
#include "surface.hpp"
#include "ili9341.hpp"
#include <cstdlib>
#include <new>

// ---------------------------------------------------------------- memory --
// Route big allocations (asset frames, record strings, the sim world) to
// PSRAM (EXTMEM heap); keep small hot allocations in the fast internal heap.
// Requires the PSRAM chip: without it extmem_malloc returns null and we fall
// back to the internal heap until it runs out.
extern "C" {
extern uint8_t external_psram_size;   // MB, set by the Teensy 4.1 startup
void* extmem_malloc(size_t);
void extmem_free(void*);
}
static void* vc_alloc(size_t n) {
    if (n >= 1024 && external_psram_size > 0)
        if (void* p = extmem_malloc(n)) return p;
    if (void* p = malloc(n)) return p;
    return nullptr;
}
static bool is_extmem(void* p) {
    return ((uint32_t)p) >= 0x70000000u;   // EXTMEM address window
}
void* operator new(size_t n) {
    void* p = vc_alloc(n);
    if (!p) { for (;;) {} }               // OOM: halt visibly (LED could blink)
    return p;
}
void* operator new[](size_t n) { return operator new(n); }
void operator delete(void* p) noexcept {
    if (!p) return;
    if (is_extmem(p)) extmem_free(p); else free(p);
}
void operator delete[](void* p) noexcept { operator delete(p); }
void operator delete(void* p, size_t) noexcept { operator delete(p); }
void operator delete[](void* p, size_t) noexcept { operator delete(p); }

// ----------------------------------------------------------------- input --
static USBHost usb_host;
static USBHub hub1(usb_host);
static KeyboardController usb_kbd(usb_host);
static volatile int g_pending_key = 0;
static volatile bool g_pending_shift = false;

static void on_usb_key(int key) {
    int k = 0;
    switch (key) {
        case KEYD_UP: k = forge::GK_UP; break;
        case KEYD_DOWN: k = forge::GK_DOWN; break;
        case KEYD_LEFT: k = forge::GK_LEFT; break;
        case KEYD_RIGHT: k = forge::GK_RIGHT; break;
        case KEYD_ENTER: case '\n': case '\r': k = forge::GK_ENTER; break;
        case KEYD_ESC: k = forge::GK_ESC; break;
        case KEYD_TAB: case '\t': k = forge::GK_TAB; break;
        case KEYD_F1: case KEYD_F2: case KEYD_F3: case KEYD_F4: case KEYD_F5:
        case KEYD_F6: case KEYD_F7: case KEYD_F8: case KEYD_F9: case KEYD_F10:
            k = forge::GK_F1 + (key - KEYD_F1);
            break;
        default:
            if (key >= 'A' && key <= 'Z') k = key - 'A' + 'a';
            else if (key > 0 && key < 128) k = key;
    }
    if (k) {
        g_pending_key = k;
        g_pending_shift = usb_kbd.getModifiers() & 0x22;   // L/R shift
    }
}

struct Btn { uint8_t pin; int key; bool was; };
static Btn g_btns[] = {
    {2, forge::GK_UP, false},   {3, forge::GK_DOWN, false},
    {4, forge::GK_LEFT, false}, {5, forge::GK_RIGHT, false},
    {6, forge::GK_ENTER, false}, {7, forge::GK_ESC, false},
};

// ------------------------------------------------------------------ shell --
static forge::GameShell g_shell;
static vc::Surface g_scr;
static Ili9341 g_tft;
static uint16_t g_pal565[256];
static uint16_t g_line[320];

static void present() {
    // palette LUT (the surface palette can cycle; rebuild each frame -- cheap)
    for (int i = 0; i < 256; ++i) {
        uint8_t r = g_scr.pal[i * 3], g = g_scr.pal[i * 3 + 1],
                b = g_scr.pal[i * 3 + 2];
        g_pal565[i] = ((r & 0xF8) << 8) | ((g & 0xFC) << 3) | (b >> 3);
    }
    // letterbox: 20 black rows above + below the 320x200 screen
    g_tft.set_window(0, 20, 320, 200);
    for (int y = 0; y < vc::Surface::H; ++y) {
        const uint8_t* row = &g_scr.idx[(size_t)y * vc::Surface::W];
        for (int x = 0; x < vc::Surface::W; ++x) g_line[x] = g_pal565[row[x]];
        g_tft.push_pixels(g_line, vc::Surface::W);
    }
}

void setup() {
    Serial.begin(115200);
    g_tft.begin();
    g_tft.fill(0x0000);

    if (!SD.begin(BUILTIN_SDCARD)) {
        g_tft.text_banner("SD card not found");
        for (;;) {}
    }
    // newlib syscalls (teensy/src/sd_syscalls.cpp) resolve relative paths
    // against the SD root, so the shared loaders read the card unmodified.
    usb_host.begin();
    usb_kbd.attachPress(on_usb_key);

    for (Btn& b : g_btns) pinMode(b.pin, INPUT_PULLUP);

    std::string err;
    if (!g_shell.boot(err)) {
        Serial.printf("boot failed: %s\n", err.c_str());
        g_tft.text_banner("data missing on SD (see serial)");
        for (;;) {}
    }
}

void loop() {
    usb_host.Task();
    if (g_pending_key) {
        int k = g_pending_key;
        g_pending_key = 0;
        g_shell.key(k, g_pending_shift);
    }
    for (Btn& b : g_btns) {
        bool down = digitalRead(b.pin) == LOW;
        if (down && !b.was) g_shell.key(b.key, false);
        b.was = down;
    }
    static uint32_t last = 0;
    uint32_t now = millis();
    if (now - last >= 66) {                       // ~15 fps
        last = now;
        g_shell.compose(g_scr, (now / 300) & 1);
        present();
    }
}
