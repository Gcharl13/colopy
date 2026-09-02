/* Colopy on the Elecrow CrowPanel Advance 7" ESP32-P4 (1024x600
 * MIPI-DSI IPS + GT911 touch + microSD) — the Arduino-IDE game shell.
 *
 * Drives the SAME parity-verified core the host harness and the Teensy
 * build run (zero JS diffs across the turn/input/render oracles).  The
 * renderer's 8-bit 320x200 logical screen maps to the panel at an EXACT
 * 3x integer scale (960x600) with a 32-px pillarbox each side.
 *
 * Every hardware init below is taken from Elecrow's own working V1.2
 * Arduino examples (cport/p4/elecrow_ref/ + PROVENANCE.md):
 *   - LDO3 2.5 V (MIPI D-PHY) + LDO4 3.3 V (touch I2C pull-ups), then
 *     ESP32_Display_Panel `Board` init/begin  (Lesson07)
 *   - panel EK79007, 2-lane DSI @ 1000 Mbps, 51 MHz DPI,
 *     HPW 70 / HBP 160 / HFP 160, VPW 10 / VBP 23 / VFP 21
 *     (board_config.h / esp_panel_board_custom_conf.h)
 *   - GT911 via Board::getTouch()->readPoints()  (Lesson05)
 *   - microSD on SDMMC slot 0, 1-bit: CLK 43 / CMD 44 / D0 39,
 *     internal pull-ups, 10 MHz  (Lesson08)
 *
 * Serial commands (115200 baud, newline-terminated) — the same shell
 * vocabulary as the Teensy build:
 *   l <file>    load a .SAV from the SD card root
 *   t [n]       run n full turns (default 1), digest per turn
 *   d           print the current digest
 *   i           overview: year/season/turn, counts, tax
 *   s <file>    write the current state to SD as a .SAV
 *   v           draw the map view once
 *   g           enter the game loop on the loaded save
 *   k <name>    inject one key by its JS name ("k Space", "k ArrowUp",
 *               "k F5", a single character; "k !<c>" = Alt+<c>)
 *
 * Touch (in the game loop) — the board has NO keyboard path (Elecrow's
 * USB example is device-mode HID only), so play is touch-complete:
 *   tap             the pointer layer's click at the descaled game
 *                   coordinate (menus, colony, Europe, dialogs); on
 *                   the map, a tap on a tile ADJACENT to the active
 *                   unit MOVES it there (the 8-way movement keys)
 *   long-press      Space — skip the active unit (>= 600 ms); with
 *                   NOTHING active (everything fortified/sentried) it
 *                   ENDS THE TURN, as does ORDERS -> "Wait for next
 *                   unit", the one row left live in that state; on the
 *                   Europe market bar it BUYS 100 of that good (a tap
 *                   there sells, as the DOS pointer layer does)
 *   two-finger tap  Escape — close a menu/screen, dismiss a dialog
 * Menus track the finger: press a menu-bar title to open it, slide
 * across the bar to switch menus or down the rows to move the
 * highlight, and lift on the row you want (lift off the box = close).
 * A queued notice: tap dismisses.  A question dialog: tap an option
 * row to answer it, tap outside the box to dismiss.  An entry modal:
 * the on-screen pad types (digits for an amount, letters for a name),
 * OK commits (an empty entry = the full amount / the suggested name),
 * a tap on the entry line clears it, a tap outside = Escape.  Every
 * order is also in the tappable ORDERS pulldown, the reports in the
 * menu bar, and a colony's colonists are tapped in its plaza / fields.
 *
 * The core never does I/O (buffer-only API); this shell owns the SD
 * card, the serial port, the panel and the touch controller. */
#include "board_config.h"   // board pin define (Elecrow Lesson07 + SD pins)
#include <Arduino.h>

#include <string.h>
#include <esp_log.h>
#include <esp_err.h>
#include <esp_ldo_regulator.h>      // ESP32-P4 LDO management
#include <esp_heap_caps.h>          // PSRAM allocation
#include <esp_vfs_fat.h>            // SD card FAT mount (Lesson08 path)
#include <dirent.h>                 // SD .SAV listing (Load Game picker)
#include <strings.h>
#include <sdmmc_cmd.h>
#include <driver/sdmmc_host.h>

#include "esp_panel_drivers_conf.h"
#include "esp_panel_board_custom_conf.h"
#include "ESP_Panel_Library.h"
/* audio on by default; -DCOLOPY_AUDIO=0 builds a mute sketch.  Defined
 * HERE, above the include it guards — the 2026-08-17 audio merge left
 * this #if 300 lines ahead of the #define, which silently dropped the
 * I2S header. */
#ifndef COLOPY_AUDIO
#define COLOPY_AUDIO 1
#endif
#if COLOPY_AUDIO
#include <ESP_I2S.h>                // speaker I2S (Elecrow Lesson12 path)
#endif

extern "C" {
#include "colopy_core.h"
#include "colopy_state.h"
#include "colopy_sim.h"
#include "colopy_render.h"
#include "colopy_input.h"
#include "colopy_data.h"
#include "colopy_sfx.h"          /* the byte-decoded COLDIG index */
#if COLOPY_AUDIO
#include "colopy_audio.h"         /* the COLAUDIO.PAK mixer + cue engine */
#endif
}

using namespace esp_panel::drivers;
using namespace esp_panel::board;

/* ---- panel state ---------------------------------------------------- */
#define P4_W 1024
#define P4_H 600
#define P4_SCALE 3                    /* 320x200 -> 960x600 exactly */
#define P4_XOFF ((P4_W - RD_W * P4_SCALE) / 2)   /* 32-px pillarbox */

static Board *board = nullptr;
static LCD *g_lcd = nullptr;
static uint16_t *fbuf = nullptr;      /* 1024x600 RGB565, in PSRAM */
static uint8_t *pakbuf = nullptr;     /* COLOPY.PAK from SD, in PSRAM */
static uint8_t *savbuf = nullptr;     /* .SAV image buffer (~80 KB) */
static uint8_t *sidebuf = nullptr;    /* the .SAV sidecar, in PSRAM */
/* COLOPY.PAK is 3,148,409 B today. The old 3,500,000 cap left 10% headroom
 * and every asset still to ship (Part E of docs/REMAINING_WORK.md: 139 .SS
 * and 7 .PIK sheets) grows it. 8 MB of the P4's 32 MB PSRAM is cheap —
 * fbuf is 1.2 MB, savbuf 80 KB, sidebuf 8 KB — and sd_read_file() now
 * refuses an oversize file outright rather than loading a prefix. */
#define PAKBUF_CAP 8000000
#define SAVBUF_CAP 80000
#define SIDEBUF_CAP 8192
static uint16_t lut565[256];
static int pak_ready = 0;
static bool sav_loaded = false;

/* VGA colour cycling (the water animation): CYCLE.DAT ships one band
 * — the pak's CYCLE entry (u16 start/len/delay).  Each step moves
 * every colour one index UP with wrap, so palette index start+k shows
 * the colour authored at start+(k-phase) (game.js:149-165); the step
 * clock is the engine's 60.8766 Hz timer (game.js:11484).  On this
 * indexed-colour flush the rotation is pure LUT work — the fb bytes
 * never change, a re-flush alone animates the sea. */
static int cyc_start = 0, cyc_len = 0;
static uint32_t cyc_step_ms = 0;
/* The rotation is only meaningful over the MASTER map palette — a PIK
 * screen (reports, Europe, woodcuts, cinematics) loads its own palette
 * and rotating its band indices corrupts its colours.  Whoever paints
 * the fb last sets this: draw_screen for game screens, cmd_view for
 * the serial map view. */
static int cyc_wanted = 0;

static void cyc_load(void) {
    static int tried = 0;
    if (tried || !pak_ready) return;
    tried = 1;
    rd_entry e;
    if (rd_pak_find(&RD.pak, "CYCLE", &e) && e.len >= 6) {
        cyc_start = e.payload[0] | (e.payload[1] << 8);
        cyc_len = e.payload[2] | (e.payload[3] << 8);
        int delay = e.payload[4] | (e.payload[5] << 8);
        cyc_step_ms = (uint32_t)((double)delay * 1000.0 / 60.8766);
        if (!cyc_step_ms) cyc_step_ms = 1;
    }
}

static int cyc_phase(void) {
    if (cyc_len <= 0 || !cyc_step_ms) return 0;
    return (int)((millis() / cyc_step_ms) % (uint32_t)cyc_len);
}

static void build_lut(void) {
    for (int i = 0; i < 256; i++) {
        const uint8_t *c = RD.pal + i * 3;
        lut565[i] = (uint16_t)(((c[0] & 0xF8) << 8) |
                               ((c[1] & 0xFC) << 3) | (c[2] >> 3));
    }
    cyc_load();
    int phase = cyc_wanted ? cyc_phase() : 0;
    if (phase > 0) {
        for (int k = 0; k < cyc_len; k++) {
            int src = cyc_start +
                      (((k - phase) % cyc_len) + cyc_len) % cyc_len;
            const uint8_t *c = RD.pal + src * 3;
            lut565[cyc_start + k] =
                (uint16_t)(((c[0] & 0xF8) << 8) |
                           ((c[1] & 0xFC) << 3) | (c[2] >> 3));
        }
    }
}

/* the 320x200 logical rows at 3x into the full-panel buffer, then one
 * DMA draw.  (The Teensy build's rows 200..239 status strip is a
 * FLAGGED port choice with nothing load-bearing on it; at 3x only the
 * 200 Mode-13h rows fit 600 lines, so it is not shown here.) */
static void flush_fb(void) {
    if (!fbuf || !g_lcd) return;
    build_lut();                      /* palette may have changed */
    for (int y = 0; y < RD_GAME_H; y++) {
        uint16_t *d = fbuf + (uint32_t)(y * P4_SCALE) * P4_W + P4_XOFF;
        const uint8_t *src = RD.fb + y * RD_W;
        for (int x = 0; x < RD_W; x++) {
            uint16_t c = lut565[src[x]];
            d[x * 3] = c;
            d[x * 3 + 1] = c;
            d[x * 3 + 2] = c;
        }
        memcpy(d + P4_W, d, RD_W * P4_SCALE * 2);
        memcpy(d + 2 * P4_W, d, RD_W * P4_SCALE * 2);
    }
    g_lcd->drawBitmap(0, 0, P4_W, P4_H, (const uint8_t *)fbuf, -1);
}


/* ---- BLE mouse via the onboard ESP32-C6 (OPTIONAL) ------------------
 * The board carries an ESP32-C6-MINI-1 as a wireless co-processor
 * (Wi-Fi 6 + BLE 5.3); the P4 itself has no radio, so Bluetooth runs
 * over ESP-Hosted with NimBLE on this side.  arduino-esp32's BLE
 * library supports exactly that — BLEDevice.h guards its body with
 * `SOC_BLE_SUPPORTED || CONFIG_ESP_HOSTED_ENABLE_BT_NIMBLE` and ships
 * a hosted HCI transport (BLEHostedHCI.cpp) "automatically linked when
 * building for ESP32-P4".
 *
 * THREE things must all hold for this to work, and only the first is
 * under this sketch's control:
 *   1. COLOPY_BLE_MOUSE below set to 1;
 *   2. an arduino-esp32 core new enough to carry the hosted-BT build
 *      (the P4 BLE build fix is recent — arduino-esp32 issue #11788);
 *   3. the C6 running ESP-Hosted slave firmware with BT ENABLED.
 *      Elecrow ship the C6 for Wi-Fi 6 and publish no Bluetooth
 *      example, so whether their factory firmware exposes BT over the
 *      transport is UNVERIFIED here.
 * Because of 2 and 3 this is OFF by default: the shipped build is
 * unaffected and still compiles on cores without hosted BT.
 *
 * HARDWARE RESULT 2026-08-19, and it is not encouraging.  With this set
 * to 1 the board PANICS INSIDE BLEDevice::init() — the game never
 * reached the title screen.  Set back to 0, the same build boots.  So
 * one of conditions 2 and 3 does not hold on this hardware; which one
 * is not yet known, and telling them apart needs the panic backtrace.
 * The bring-up moved out of setup() into bt_begin() so the failure can
 * no longer cost you the whole game, but moving it did not make the
 * feature work: turning this on and tapping Scan still panics.  Leave
 * it at 0 until D6 in docs/REMAINING_WORK.md says otherwise.
 *
 * Only BLE mice can ever work — the C6 has no Bluetooth Classic radio,
 * so a Classic-only mouse cannot pair at any layer.
 *
 * The report parse below is the HID BOOT-mouse layout (byte 0 buttons,
 * 1 dx, 2 dy, 3 wheel, signed 8-bit).  Report formats vary by mouse
 * and the Report Map is NOT parsed here, so an unrecognised mouse will
 * move oddly; every report is dumped to serial as hex so the layout
 * can be identified from a real device.  FLAGGED: untested against
 * hardware. */
#ifndef COLOPY_BLE_MOUSE
#define COLOPY_BLE_MOUSE 0
#endif

#if COLOPY_BLE_MOUSE
/* Included HERE rather than down beside the implementation, because the
 * IDE hoists its generated prototypes ABOVE this file's own #includes
 * and a prototype naming a BLE type must not land before the header.
 * Even this is not sufficient on its own — the hoist point is above the
 * FIRST function definition, which is earlier still — so the notify
 * callback is a lambda with no name to hoist. See the note at
 * bt_connect(). */
#include <BLEDevice.h>
static int  bt_mode = 0;              /* 0 off, 1 the pairing screen */
static int  bt_state = 0;             /* 0 idle, 1 scanning, 2 list,
                                       * 3 connecting, 4 connected, 5 fail */
static void bt_init(void);
static void bt_begin(void);      /* the real BLE bring-up, on first use */
static void bt_pump(void);
static void bt_ui_draw(void);
static int  bt_ui_tap(int gx, int gy);
#else
static int  bt_mode = 0;
static void bt_init(void) {}
static void bt_pump(void) {}
static void bt_ui_draw(void) {}
static int  bt_ui_tap(int gx, int gy) { (void)gx; (void)gy; return 0; }
#endif

/* THE LAST #include IN THIS FILE, AND IT MUST STAY UNCONDITIONAL.
 * It is here because on 2026-08-17 the audio merge moved <ESP_I2S.h>
 * up, leaving <BLEDevice.h> (guarded by COLOPY_BLE_MOUSE, off by
 * default) as the last include in the file, and the sketch then failed
 * with "not declared in this scope" at the first forward call — every
 * generated prototype had landed somewhere inert.  An unconditional
 * include here fixed it and has held since, so it stays.
 *
 * CORRECTION 2026-08-19: this used to assert that the IDE hoists its
 * prototypes "to just after the last #include", and that model is
 * WRONG.  A real IDE build (esp32 core 3.3.11) put a prototype ABOVE
 * this file's own includes — above the first function definition, which
 * is line ~180, far earlier than any include down here — and died on a
 * BLE type it could not see.  The 2026-08-17 mechanism above was
 * inferred from its symptom and was never verified; what is verified is
 * that the fix worked.  Do not reason from the old model.  The gate
 * that models this properly is tools/ino_mock/. */
#include <stddef.h>

/* the title screen's Bluetooth row.  SHELL CHROME: the DOS main menu
 * has five rows only (dat_text_beginmenu[1..5], drawn by rm_draw_title
 * inside the plaque at 77,91,166,58 -> rows y=107..147), so the pairing
 * entry sits just BELOW the plaque and never disturbs the game's own
 * menu geometry.  Drawn only when the build has BLE compiled in. */
#define BT_ROW_Y 155
static void draw_bt_row(void) {
#if COLOPY_BLE_MOUSE
    if (!pak_ready) return;
    static rd_font btf;
    if (!btf.payload && !rd_font_open(&RD.pak, "FONTTINY.FF", &btf)) return;
    const uint8_t ink[4] = { 0xFF, 0xFE, 0xFD, 0 };
    rd_fill(77, BT_ROW_Y - 2, 166, 11, 0x2E);
    rd_text(&btf, bt_state == 4 ? "Bluetooth mouse: connected"
                                : "Bluetooth mouse...",
            77 + 9, BT_ROW_Y, ink);
#endif
}

/* ---- touch ----------------------------------------------------------
 * Classified on the RELEASE edge so a long-press can differ from a
 * tap: TAP / LONG (>= 600 ms) / ESC (a second finger seen during the
 * press).  TAP and LONG carry the descaled 320x200 game coordinate of
 * the press point. */
enum { TT_NONE = 0, TT_TAP, TT_LONG, TT_ESC, TT_KEY };
/* Touch feel — override these in the config banner at the top of the
 * sketch.  TT_DEBOUNCE_MS: after an accepted tap, new presses are
 * ignored for this long (stops double-fires).  TT_RELEASE_MS: the
 * finger must stay off this long before a release counts (the GT911
 * micro-drops mid-press, which would otherwise read as extra taps).
 * TT_LONG_MS: hold time for the long-press (= Space). */
#ifndef TT_DEBOUNCE_MS
#define TT_DEBOUNCE_MS 300
#endif
#ifndef TT_RELEASE_MS
#define TT_RELEASE_MS 80
#endif
#ifndef TT_LONG_MS
#define TT_LONG_MS 600
#endif

/* the live press position while a finger is down — the menu tracker
 * reads it so the highlight can follow the finger (see menu_track) */
static int touch_down = 0, touch_hx = 0, touch_hy = 0;

static int touch_poll(int *gx, int *gy) {
    static bool armed = false;            /* a debounced press in flight */
    static bool multi = false;
    static unsigned long t_down = 0;      /* press start */
    static unsigned long t_seen = 0;      /* last moment a finger was seen */
    static unsigned long t_fired = 0;     /* last accepted event */
    static int px = 0, py = 0;
    if (!board) return TT_NONE;
    Touch *touch = board->getTouch();
    if (!touch) return TT_NONE;
    TouchPoint pt[2];
    int n = touch->readPoints(pt, 2, 0);
    unsigned long now = millis();
    int ev = TT_NONE;
    if (n > 0) {
        t_seen = now;
        if (!armed) {                     /* press start (debounced) */
            if (t_fired && now - t_fired < TT_DEBOUNCE_MS)
                return TT_NONE;           /* too soon after the last tap */
            armed = true;
            multi = false;
            t_down = now;
        }
        /* TRACK the finger: the release point is where it ENDED, so a
         * press can slide onto the row it means to pick */
        px = pt[0].x;
        py = pt[0].y;
        if (n >= 2) multi = true;
        {
            int lx = px - P4_XOFF, ly = py;
            if (lx >= 0 && lx < RD_W * P4_SCALE &&
                ly >= 0 && ly < RD_GAME_H * P4_SCALE) {
                touch_hx = lx / P4_SCALE;
                touch_hy = ly / P4_SCALE;
                touch_down = 1;
            }
        }
    } else if (armed && now - t_seen >= TT_RELEASE_MS) {
        touch_down = 0;
        /* a STABLE release (not a GT911 dropout): classify */
        armed = false;
        t_fired = now;
        if (multi) {
            ev = TT_ESC;
        } else {
            int x = px - P4_XOFF, y = py;
            if (x >= 0 && x < RD_W * P4_SCALE && y >= 0 &&
                y < RD_GAME_H * P4_SCALE) {
                *gx = x / P4_SCALE;
                *gy = y / P4_SCALE;
                ev = (t_seen - t_down >= TT_LONG_MS) ? TT_LONG : TT_TAP;
            }
        }
    }
    if (n <= 0 && !armed) touch_down = 0;
    return ev;
}

/* ---- SD card (Elecrow Lesson08: SDMMC slot 0, 1-bit, 10 MHz) -------- */
static bool sd_ready = false;

static void sd_mount(void) {
    esp_vfs_fat_sdmmc_mount_config_t mount_config = {};
    mount_config.format_if_mount_failed = false;
    mount_config.max_files = 4;
    mount_config.allocation_unit_size = 16 * 1024;
    sdmmc_card_t *card = NULL;
    sdmmc_host_t host = SDMMC_HOST_DEFAULT();
    host.slot = SDMMC_HOST_SLOT_0;
    host.max_freq_khz = 10000;
    sdmmc_slot_config_t slot_config = SDMMC_SLOT_CONFIG_DEFAULT();
    slot_config.clk = (gpio_num_t)SD_GPIO_MMC_CLK;
    slot_config.cmd = (gpio_num_t)SD_GPIO_MMC_CMD;
    slot_config.d0 = (gpio_num_t)SD_GPIO_MMC_D0;
    slot_config.width = 1;
    slot_config.flags |= SDMMC_SLOT_FLAG_INTERNAL_PULLUP;
    esp_err_t r = esp_vfs_fat_sdmmc_mount("/sdcard", &host, &slot_config,
                                          &mount_config, &card);
    if (r != ESP_OK) {
        Serial.printf("SD mount FAILED: %s\n", esp_err_to_name(r));
        return;
    }
    sd_ready = true;
}

/* read a whole SD file into buf; returns the byte count, 0 on error */
static size_t sd_read_file(const char *name, uint8_t *buf, size_t cap) {
    char path[96];
    snprintf(path, sizeof(path), "/sdcard/%s", name);
    FILE *f = fopen(path, "rb");
    if (!f) return 0;
    /* Size it first. A plain fread(cap) on an oversize file returns a
     * truncated PREFIX, and rd_init() accepts a prefix whose header still
     * parses — the pack would come up quietly missing its tail assets with
     * no error anywhere. Refuse instead, and say what the numbers are. */
    size_t sz = 0;
    if (fseek(f, 0, SEEK_END) == 0) {
        long end = ftell(f);
        if (end > 0) sz = (size_t)end;
        rewind(f);
    }
    if (sz > cap) {
        Serial.printf("%s is %u B but the buffer is %u B — refusing to load "
                      "a truncated file; raise the cap and reflash\n",
                      name, (unsigned)sz, (unsigned)cap);
        fclose(f);
        return 0;
    }
    size_t n = fread(buf, 1, cap, f);
    fclose(f);
    return n;
}
/* ---- audio ----------------------------------------------------------
 * TWO paths share the one I2S port and the choice is made ONCE at boot;
 * whichever wins owns `i2s_spk` for the session (they cannot coexist —
 * the pack engine runs mono at AU_MIX_RATE off a task, the COLDIG path
 * runs stereo and re-clocks per sample).
 *
 *   1. COLAUDIO.PAK on the card -> the cport/audio engine
 *      (docs/AUDIO_PORT.md): music AND mixed cues, a FreeRTOS task
 *      pulling au_render().  The full experience.
 *   2. no pack -> COLDIG.BIN direct: the game's own 993 KB sample bank,
 *      one blocking voice, no music.  KEPT on purpose — COLAUDIO.PAK is
 *      25.9 MB, gitignored, and has to be rebuilt from a DOSBox capture
 *      run, so making it mandatory would silence every board whose owner
 *      has not been through that pipeline (merge decision 2026-08-17).
 *
 * Hardware numbers are Elecrow's Lesson12 for this exact board
 * (cport/p4/elecrow_ref/lesson12_audio.ino + lesson12_board_config.h,
 * PROVENANCE.md — vendored by the audio branch, which is what finally
 * resolved this file's one broken citation chain): plain I2S std mode
 * into the on-board amplifier (no codec chip), LRCLK 21 / BCLK 22 /
 * SDATA 23, audio power gate GPIO 30 (LOW = on).
 *
 * MUSIC comes only from path 1.  The tunes are synthesised inside the
 * `?SOUND.COL` driver overlays, so there is no music file to play; the
 * pack carries offline renders of the ORIGINAL driver under emulation.
 * Nothing here invents one (CLAUDE.md prime directive). */
#define AUDIO_GPIO_CTRL   30          /* audio power, LOW = enabled */
#define AUDIO_POWER_ON    LOW
#define AUDIO_POWER_OFF   HIGH
#define AUDIO_GPIO_LRCLK  21
#define AUDIO_GPIO_BCLK   22
#define AUDIO_GPIO_SDATA  23

#if COLOPY_AUDIO
static I2SClass i2s_spk;         /* <ESP_I2S.h> is included at the top */
static int audio_ready = 0;
static int audio_pack_live = 0;          /* 1 = path 1 owns the I2S port */
static int audio_rate = 0;               /* the rate I2S is running at */

static int audio_set_rate(int hz) {
    if (!audio_ready || hz == audio_rate) return audio_ready;
    if (audio_rate) i2s_spk.end();
    audio_ready = i2s_spk.begin(I2S_MODE_STD, hz,
                                I2S_DATA_BIT_WIDTH_16BIT,
                                I2S_SLOT_MODE_STEREO, I2S_STD_SLOT_BOTH);
    audio_rate = audio_ready ? hz : 0;
    return audio_ready;
}


/* ---- path 1: the COLAUDIO.PAK engine ---- */
static FILE *audio_f = nullptr;
static int audio_rd(void *ctx, uint32_t off, void *dst, uint32_t len) {
    (void)ctx;
    return audio_f && fseek(audio_f, (long)off, SEEK_SET) == 0 &&
           fread(dst, 1, len, audio_f) == len;
}
static void audio_task(void *arg) {
    (void)arg;
    static int16_t abuf[512];
    for (;;) {
        au_render(abuf, 512);                /* task context: SD reads OK */
        i2s_spk.write((uint8_t *)abuf, sizeof abuf);
    }
}
static int audio_pack_init(void) {
    audio_f = fopen("/sdcard/COLAUDIO.PAK", "rb");
    if (!audio_f) return 0;                  /* fall back to COLDIG */
    fseek(audio_f, 0, SEEK_END);
    long sz = ftell(audio_f);
    if (!au_init_stream(audio_rd, nullptr, (uint32_t)sz)) {
        Serial.println("COLAUDIO.PAK unreadable -- audio silent");
        fclose(audio_f);
        audio_f = nullptr;
        return 0;
    }
    au_seed((uint32_t)esp_random());
    pinMode(AUDIO_GPIO_CTRL, OUTPUT);
    digitalWrite(AUDIO_GPIO_CTRL, LOW);      /* amp power on (Lesson12) */
    i2s_spk.setPins(AUDIO_GPIO_BCLK, AUDIO_GPIO_LRCLK, AUDIO_GPIO_SDATA);
    if (!i2s_spk.begin(I2S_MODE_STD, AU_MIX_RATE, I2S_DATA_BIT_WIDTH_16BIT,
                       I2S_SLOT_MODE_MONO, I2S_STD_SLOT_LEFT)) {
        Serial.println("I2S init failed -- audio silent");
        digitalWrite(AUDIO_GPIO_CTRL, HIGH);
        fclose(audio_f);
        audio_f = nullptr;
        return 0;
    }
    xTaskCreate(audio_task, "colopy_audio", 4096, nullptr, 3, nullptr);
    Serial.printf("audio up: COLAUDIO.PAK %ld bytes, I2S %d Hz\n",
                  sz, AU_MIX_RATE);
    return 1;
}

/* scheduler tick: the war flag + the func_004EE6 pump */
static void audio_tick(void) {
    /* [0x5382]&1.  The audio branch read a `declared` field off
     * PowerRecord that no version of the records carries; the WoI
     * flag lives in CR.woi_flags (colopy_sim.h). */
    au_set_war((CR.woi_flags & WOI_DECLARED) != 0);
    au_pump();
}
/* shell-side cue edges (the core/game layers stay untouched): new game =
 * the BRIEFING->MAP transition; woodcut = a new plate on screen */
static void audio_screen_edges(void) {
    static int last_screen = SCR_TITLE, last_wc = -1;
    if (last_screen == SCR_BRIEFING && UI.screen == SCR_MAP)
        au_on_new_game();
    if (UI.screen == SCR_WOODCUT) {
        if (UI.woodcut != last_wc) {
            au_on_woodcut(UI.woodcut);
            last_wc = UI.woodcut;
        }
    } else {
        last_wc = -1;
    }
    /* the score plate's tune (func_03A9C0 @0x3AD51..0x3AD6D via the
     * 0x181F:0x4C0 gate = au_cmd): 0x24 top band, 0x25 above band 6,
     * else 0x21 */
    if (UI.screen == SCR_SCORE && last_screen != SCR_SCORE)
        au_cmd((uint16_t)RM_SCORE_TUNE(UI.score_panel));
    last_screen = UI.screen;
}

/* ---- path 2: COLDIG.BIN direct ---- */
/* play one COLDIG.BIN sample by the ENGINE'S sound id (0x40..0x5D).
 * colopy_sfx_index() is the driver's own id -> index jump table and
 * colopy_sfx[] its (offset, length, rate) row, both generated from the
 * driver bytes.  The bank is 8-bit UNSIGNED mono: (b - 128) << 8 makes
 * signed 16-bit, written twice for the stereo slot pair.  Blocking —
 * the longest sample is under 6 s and the DOS game blocked here too.
 * Silent when SOUND EFFECTS is off in @SOUNDOPTIONS ([0xA4], the bit
 * the C core keeps in CR.sound_options). */
static void sfx_play(int id) {
    int idx = colopy_sfx_index(id);
    if (idx < 0 || !audio_ready || !sd_ready) return;
    if (!(CR.sound_options & 0x04)) return;
    const colopy_sfx_rec *r = &colopy_sfx[idx];
    FILE *f = fopen("/sdcard/COLDIG.BIN", "rb");
    if (!f) return;
    if (fseek(f, (long)r->offset, SEEK_SET) != 0) { fclose(f); return; }
    if (!audio_set_rate(r->rate)) { fclose(f); return; }
    /* heap, not statics: internal SRAM is 320 KB and near full, so
     * every buffer this sketch adds comes out of PSRAM */
    uint8_t *src = (uint8_t *)malloc(256);
    int16_t *dst = (int16_t *)malloc(512 * sizeof(int16_t));
    if (!src || !dst) { free(src); free(dst); fclose(f); return; }
    uint32_t left = r->length;
    digitalWrite(AUDIO_GPIO_CTRL, AUDIO_POWER_ON);
    while (left) {
        size_t want = left > 256 ? 256 : left;
        size_t n = fread(src, 1, want, f);
        if (!n) break;
        for (size_t i = 0; i < n; i++) {
            int16_t v = (int16_t)(((int)src[i] - 128) << 8);
            dst[i * 2] = v;
            dst[i * 2 + 1] = v;
        }
        i2s_spk.write((uint8_t *)dst, n * 2 * sizeof(int16_t));
        left -= (uint32_t)n;
    }
    digitalWrite(AUDIO_GPIO_CTRL, AUDIO_POWER_OFF);
    free(src);
    free(dst);
    fclose(f);
}

/* play a 16-bit PCM WAV from the SD card (the 44-byte canonical header
 * is skipped, exactly as Lesson12 does).  Blocking, so it is used for
 * short cues only; SOUND EFFECTS off in @SOUNDOPTIONS silences it. */
static void audio_play_wav(const char *name) {
    if (!audio_ready || !sd_ready) return;
    if (!(CR.sound_options & 0x04)) return;   /* Sound Effects switch */
    char path[64];
    snprintf(path, sizeof(path), "/sdcard/%s", name);
    FILE *f = fopen(path, "rb");
    if (!f) return;
    if (fseek(f, 44, SEEK_SET) != 0) { fclose(f); return; }
    static int16_t buf[512];
    digitalWrite(AUDIO_GPIO_CTRL, AUDIO_POWER_ON);
    for (;;) {
        size_t n = fread(buf, sizeof(int16_t), 512, f);
        if (!n) break;
        i2s_spk.write((uint8_t *)buf, n * sizeof(int16_t));
    }
    digitalWrite(AUDIO_GPIO_CTRL, AUDIO_POWER_OFF);
    fclose(f);
}
static void audio_init(void) {
    pinMode(AUDIO_GPIO_CTRL, OUTPUT);
    digitalWrite(AUDIO_GPIO_CTRL, AUDIO_POWER_OFF);
    i2s_spk.setPins(AUDIO_GPIO_BCLK, AUDIO_GPIO_LRCLK, AUDIO_GPIO_SDATA);
    if (sd_ready && audio_pack_init()) {  /* path 1 wins if the pack is there */
        audio_pack_live = 1;
        return;
    }
    audio_ready = 1;                      /* path 2: COLDIG on demand */
    if (!audio_set_rate(16000)) {
        Serial.println("audio: I2S init failed");
        return;
    }
    Serial.println(sd_ready ? "audio: COLDIG.BIN cues (no COLAUDIO.PAK)"
                            : "audio: silent (no SD)");
}
#else
static void audio_init(void) {}
static void audio_play_wav(const char *name) { (void)name; }
static void sfx_play(int id) { (void)id; }
static void audio_tick(void) {}
static void audio_screen_edges(void) {}
#endif

/* ---- Phase 7/8: the screens + the game loop (mirrors the Teensy
 * shell — cport/teensy/colopy_teensy.ino) ---------------------------- */
static int game_mode = 0;
static colopy_event pending_ev;
static int have_pending = 0;
/* the active unit's blink: DRAWN while truthy, hidden on the off half
 * — the JS ticks it at 60 fps with G.blink = (tick % 32) < 20
 * (game.js:12690), i.e. on ~333 ms / off ~200 ms */
static int map_blink = 1;
static int blink_now(void) { return (int)((millis() % 533u) < 333u); }

static int ui_colony_cs_index(void) {
    int ord = -1;
    for (int k = 0; k < CS.n_colonies; k++) {
        if ((CS.colonies[k].owner_power & 3) != cs_nation()) continue;
        if (++ord == UI.colony) return k;
    }
    return -1;
}

/* the open amount modal's subs — shared by the painter and the tap
 * hit-test so the two agree */
/* ---- the shell's touch keyboard (SHELL CHROME) --------------------
 * Overlaid on the name-entry screen so a custom leader name needs no
 * serial console: three rows of keys at the screen's foot, tap types,
 * < deletes, OK commits (the empty entry keeps the suggested name —
 * the same Enter rule the key layer implements). */
static const char *const KBD_ROWS[3] = {
    "ABCDEFGHIJ", "KLMNOPQRST", "UVWXYZ .<#"
};
#define KBD_Y 146
#define KBD_KW 30
#define KBD_KH 15

static void draw_kbd(void) {
    static rd_font kf;
    if (!kf.payload && !rd_font_open(&RD.pak, "FONTTINY.FF", &kf)) return;
    const uint8_t ink[4] = { 0xFF, 68, 67, 0 };
    for (int r = 0; r < 3; r++)
        for (int c = 0; c < 10; c++) {
            char ch = KBD_ROWS[r][c];
            int x = 10 + c * KBD_KW, y = KBD_Y + r * (KBD_KH + 2);
            rm_plaque(x, y, KBD_KW - 2, KBD_KH);
            char lab[3] = { ch, 0, 0 };
            if (ch == '<') { lab[0] = '<'; lab[1] = '-'; }
            if (ch == '#') { lab[0] = 'O'; lab[1] = 'K'; }
            rd_text(&kf, lab, x + (KBD_KW - 2) / 2 - 4, y + 4, ink);
        }
}

static char kbd_hit(int gx, int gy) {
    if (gy < KBD_Y || gx < 10 || gx >= 10 + 10 * KBD_KW) return 0;
    int r = (gy - KBD_Y) / (KBD_KH + 2);
    int c = (gx - 10) / KBD_KW;
    if (r < 0 || r > 2 || c < 0 || c > 9) return 0;
    return KBD_ROWS[r][c];
}

/* the AMOUNT modals' numeric keypad (SHELL CHROME): the board has no
 * keyboard, so without this a touch player could only ever take the
 * dialog's full amount (Enter on an empty entry).  Same tap/OK/back
 * rhythm as the alpha keyboard above. */
static const char *const KPAD_ROWS[4] = { "123", "456", "789", "0<#" };
#define KPAD_Y 138
#define KPAD_KW 46
#define KPAD_KH 13
#define KPAD_X0 (160 - (3 * KPAD_KW) / 2)

static void draw_kpad(void) {
    static rd_font pf;
    if (!pf.payload && !rd_font_open(&RD.pak, "FONTTINY.FF", &pf)) return;
    const uint8_t ink[4] = { 0xFF, 68, 67, 0 };
    for (int r = 0; r < 4; r++)
        for (int c = 0; c < 3; c++) {
            char ch = KPAD_ROWS[r][c];
            int x = KPAD_X0 + c * KPAD_KW, y = KPAD_Y + r * (KPAD_KH + 2);
            rm_plaque(x, y, KPAD_KW - 2, KPAD_KH);
            char lab[3] = { ch, 0, 0 };
            if (ch == '<') { lab[0] = '<'; lab[1] = '-'; }
            if (ch == '#') { lab[0] = 'O'; lab[1] = 'K'; }
            rd_text(&pf, lab, x + (KPAD_KW - 2) / 2 - 4, y + 3, ink);
        }
}

static char kpad_hit(int gx, int gy) {
    if (gy < KPAD_Y || gx < KPAD_X0 || gx >= KPAD_X0 + 3 * KPAD_KW) return 0;
    int r = (gy - KPAD_Y) / (KPAD_KH + 2);
    int c = (gx - KPAD_X0) / KPAD_KW;
    if (r < 0 || r > 3 || c < 0 || c > 2) return 0;
    return KPAD_ROWS[r][c];
}

/* UI.dlg kinds -> their GAME.TXT sections (colopy_input.h): 1 Europe
 * sell, 2 colony load, 3 colony unload, 4 colony rename, 5 trade-route
 * name, 6 the new land, 7 a founding, 8 Find Colony.  Kinds >= 4
 * take TEXT (alpha
 * keyboard), 1-3 an AMOUNT (the keypad).  Every kind but 1 used to
 * draw @HOWMUCH5's sell prompt. */
static const char *dlg_key(void) {
    switch (UI.dlg) {
    case 2: return "HOWMUCH1";
    case 3: return "HOWMUCH2";
    case 4: return "RENAMECOLONY";
    case 5: return "TRADENAME";
    case 6: return "LANDHO";
    case 7: return "COLONY";
    case 8: return "FINDCITY";
    }
    return "HOWMUCH5";
}
static int dlg_is_text(void) { return UI.dlg >= 4; }

/* the JS askAmount substitutions: HOWMUCH1 {cargo, ship}, HOWMUCH2
 * {cargo, ship, colony}, HOWMUCH5 {cargo, price, homeport} — all with
 * NUMBER0 = the bound (game.js:4820/11247/11268). */
static void dlg_subs(rm_subs *subs) {
    static char shipn[24], coln[26];
    memset(subs, 0, sizeof(*subs));
    if (dlg_is_text()) return;               /* body has no %fields */
    subs->str[0] = dat_cargo[UI.dlg_good].name;
    subs->num[0] = UI.dlg_max;
    subs->num_set[0] = 1;
    if (UI.dlg == 1) {
        subs->num[1] = market_bid(UI.dlg_good);
        subs->num_set[1] = 1;
        subs->str[2] = dat_nations[cs_nation()].homeport;
        return;
    }
    if (UI.dlg_unit >= 0 && UI.dlg_unit < CS.n_units)
        snprintf(shipn, sizeof(shipn), "%s",
                 dat_units[CS.units[UI.dlg_unit].type].name);
    else
        shipn[0] = 0;
    subs->str[1] = shipn;
    if (UI.dlg == 3 && UI.dlg_port >= 0 && UI.dlg_port < CS.n_colonies) {
        snprintf(coln, sizeof(coln), "%.24s", CS.colonies[UI.dlg_port].name);
        subs->str[2] = coln;
    }
}

/* ---- the byte-verified sound cues -----------------------------------
 * VICEROY.EXE plays a sound by `mov ax,<id>` + `lcall 0x181F:0x4C0`
 * (the gated play thunk).  Every one of those 40 call sites is
 * inventoried by tools/decode_coldig.py into
 * data_extracted/coldig_index.json; where the cue belongs to a message
 * emit, the key string is pushed within the same block, so the EXE
 * names the event itself.  The table below is exactly those named
 * sites whose id is a digital effect (0x40..0x5D) — no inference:
 *
 *   0x54 REFIT       @0x2F1CD   0x56 TEAPARTY    @0x346F6
 *   0x53 HERESY1     @0x48EE6   0x55 CHIEFKILL   @0x4AB9E
 *   0x4F RAIDSTORES  @0x5C3C2   0x53 RAIDBURN    @0x5C501
 *   0x4B RAIDSHIP    @0x5C569   0x4D RAIDSHIP    @0x5C571 (a PAIR:
 *        the ship branch fires both, in that order)
 *   0x4E RAIDGOLD    @0x5C5ED   0x5B RAIDNOTHING @0x5C62D
 *
 * Plus two cues this project traced earlier, cited to their own sites
 * rather than to a pushed key: sfx 0x54 when the first colony is built
 * (@0x040DF6, woodcut 2) and sfx 0x53 when a colony burns (@0x05DFB7,
 * woodcut 11 — the same site also pushes INDIANBURNCOLONY).
 *
 * The other 24 call sites are real cues whose event is still TBD (four
 * of them compute the id at runtime).  They stay SILENT: nothing here
 * guesses an id or an event (CLAUDE.md prime directive).
 *
 * A cue is queued rather than played inline so the frame reaches the
 * panel first; sfx_play() blocks for the length of the sample. */
static const struct { const char *key; uint8_t id; uint8_t id2; }
EVENT_SFX[] = {
    { "REFIT",            0x54, 0 },
    { "TEAPARTY",         0x56, 0 },
    { "HERESY1",          0x53, 0 },
    { "CHIEFKILL",        0x55, 0 },
    { "RAIDSTORES",       0x4F, 0 },
    { "RAIDBURN",         0x53, 0 },
    { "RAIDSHIP",         0x4B, 0x4D },
    { "RAIDGOLD",         0x4E, 0 },
    { "RAIDNOTHING",      0x5B, 0 },
    { "INDIANBURNCOLONY", 0x53, 0 },
};
static const struct { uint8_t woodcut; uint8_t id; } WOODCUT_SFX[] = {
    { 2, 0x54 }, { 11, 0x53 },
};
static int sfx_pending = -1, sfx_pending2 = -1;
static int sfx_last_woodcut = -1;

static int event_sfx(const char *key, int *second) {
    *second = -1;
    for (unsigned i = 0; i < sizeof(EVENT_SFX) / sizeof(EVENT_SFX[0]); i++)
        if (strcmp(key, EVENT_SFX[i].key) == 0) {
            if (EVENT_SFX[i].id2) *second = EVENT_SFX[i].id2;
            return EVENT_SFX[i].id;
        }
    return -1;
}

static void draw_screen(void) {
    /* sea animation only where the master map palette is on screen */
    cyc_wanted = (UI.screen == SCR_MAP || UI.screen == SCR_VILLAGE ||
                  UI.screen == SCR_OPTIONS || UI.screen == SCR_TRADE);
    switch (UI.screen) {
    case SCR_TITLE:
        rm_draw_title(UI.menu_row);
        draw_bt_row();               /* SHELL CHROME under the plaque */
        break;
    case SCR_DIFFICULTY: rm_draw_difficulty(UI.difficulty); break;
    case SCR_NATION: rm_draw_nation(UI.nation); break;
    case SCR_NAME:
        rm_draw_name(UI.leader);
        draw_kbd();                  /* the shell's touch keyboard */
        break;
    case SCR_REPORT: rm_draw_report(UI.report); break;
    case SCR_HOF:
        rm_draw_hof();
        break;
    case SCR_PEDIA:
        rm_draw_pedia(UI.pedia_cat, UI.pedia_sel, UI.pedia_mode);
        break;
    case SCR_OPTIONS:
        rm_draw_map(UI.view_x, UI.view_y, UI.sel, 1);
        rm_draw_options(UI.options_which, UI.options_row);
        break;
    case SCR_COLONY: {
        int ci = ui_colony_cs_index();
        if (ci >= 0)
            rm_draw_colony(ci, CR.plot_seed, UI.colonist_sel,
                           UI.colony_ship_sel, UI.colony_view,
                           cs_colony_numbers());
        /* the jobs / construction popup over it (drawColonyPopup) */
        if (UI.colony_popup) {
            static char cl[64][40], cn[64][40], ct[64];
            static const char *clp[64], *cnp[64];
            int pn = ui_colony_popup_model(cl, cn, ct, (int)sizeof(ct), 64);
            for (int i = 0; i < pn; i++) { clp[i] = cl[i]; cnp[i] = cn[i]; }
            rm_draw_colony_popup(ct, clp, cnp, pn, UI.colony_popup_row,
                                 ui_colony_popup_small());
        }
        break;
    }
    case SCR_EUROPE:
        rm_draw_europe(UI.euro_ship, UI.euro_dock_sel, UI.euro_row,
                       UI.market_sel);
        /* an open recruit/purchase/train/ship/dock menu: the dialog
         * framework over the shared row model (the economic adviser
         * fronts the two menus that quote his GAME.TXT captions) */
        if (UI.euro_menu) {
            static char er[24][64], en2[24][64];
            static const char *erp[24], *enp[24];
            int en = ui_euro_menu_rows(er, en2, 24);
            for (int i = 0; i < en; i++) { erp[i] = er[i]; enp[i] = en2[i]; }
            rm_subs subs;
            memset(&subs, 0, sizeof(subs));
            rm_draw_dialog_rows_notes(ui_euro_menu_caption(), &subs,
                                      UI.euro_menu <= 2 ? "MSS2" : 0,
                                      UI.euro_menu_row, erp, en, enp);
        }
        break;
    case SCR_WOODCUT:
        rm_draw_woodcut(UI.woodcut);
        if (UI.woodcut != sfx_last_woodcut) {
            sfx_last_woodcut = UI.woodcut;
            for (unsigned i = 0;
                 i < sizeof(WOODCUT_SFX) / sizeof(WOODCUT_SFX[0]); i++)
                if (WOODCUT_SFX[i].woodcut == UI.woodcut)
                    sfx_pending = WOODCUT_SFX[i].id;
        }
        break;
    case SCR_BRIEFING:
        rm_draw_briefing(UI.nation, UI.brief_page);
        break;
    case SCR_KING:
        rm_draw_king(UI.nation);
        break;
    case SCR_CARDS:
        rm_draw_cards(UI.card, UI.nation, UI.difficulty, UI.leader);
        break;
    /* the Part E plate pages (docs/REMAINING_WORK.md Part E) */
    case SCR_CONGRESS:
        rm_draw_congress(UI.ff_new);
        break;
    case SCR_DECLARATION:
        rm_draw_declaration(rm_declaration_name(), UI.decl_step);
        break;
    case SCR_SCORE:
        rm_draw_score(UI.score_panel);
        break;
    case SCR_ENDKING:
        rm_draw_king_plate(UI.king_plate == 1);
        break;
    case SCR_VILLAGE:
        rm_draw_map(UI.view_x, UI.view_y, UI.sel, 1);
        rm_draw_village(UI.village_row);
        break;
    case SCR_TRADE: {
        rm_draw_map(UI.view_x, UI.view_y, UI.sel, 1);
        static char trows[20][64];
        static const char *trp[20];
        int tn = ui_trade_rows(trows, 20);
        for (int i = 0; i < tn; i++) trp[i] = trows[i];
        char sofar[128];
        ui_trade_sofar(sofar, (int)sizeof(sofar));
        /* the cargo editor encodes its phase as 40+phase (B3.4) */
        rm_draw_trade(UI.trade_mode == 4 ? 40 + UI.trade_phase
                                         : UI.trade_mode,
                      UI.trade_n_stops + 1, sofar,
                      trp, tn, UI.trade_row);
        break;
    }
    default:                                 /* map + everything else */
        /* 4th arg = the BLINK flag (unit drawn while truthy), NOT
         * show_hidden — passing 0 there kept the active unit invisible
         * on the board (user report 2026-08-16, the hidden caravel) */
        rm_draw_map_zoom(UI.view_x, UI.view_y, UI.sel, map_blink,
                         UI.zoom);
        if (UI.open_menu >= 0)
            rm_draw_pulldown(UI.open_menu, UI.menu_sel, UI.sel);
        break;
    }
#if COLOPY_AUDIO
    audio_screen_edges();
#endif
    if (!have_pending && colopy_next_event(&pending_ev)) {
        have_pending = 1;
        /* whichever audio path owns the port takes the cue: the pack
         * engine mixes it, otherwise the byte-decoded COLDIG table
         * plays it straight (see the audio block above). */
#if COLOPY_AUDIO
        if (audio_pack_live) au_on_event(pending_ev.key, pending_ev.p[0]);
        else sfx_pending = event_sfx(pending_ev.key, &sfx_pending2);
#else
        sfx_pending = event_sfx(pending_ev.key, &sfx_pending2);
#endif
    }
    /* the Combat Analysis panel sits over whatever screen is up, read
     * first and dismissed first (the JS draw order) */
    if (CR.combat.active) rm_draw_combat();
    if (have_pending && rm_event_exists(pending_ev.key)) {
        rm_subs subs = { { pending_ev.s[0], pending_ev.s[1], 0, 0 },
                         { pending_ev.p[0], pending_ev.p[1], 0, 0 },
                         { 1, 1, 0, 0 } };
        rm_draw_event(pending_ev.key, &subs, 0);
    }
    /* an open numeric dialog (@HOWMUCH5): the framework body with the
     * live entry as STRING0's tail — a functional stand-in for the JS
     * entry-line caret (drawDialog, game.js:909); FLAGGED cosmetic */
    if (UI.dlg) {
        rm_subs subs;
        dlg_subs(&subs);
        rm_draw_event(dlg_key(), &subs, 0);
        /* the live entry line + the kind's pad (text = letters,
         * amount = digits) — the JS draws a caret in the box itself */
        int py = dlg_is_text() ? KBD_Y : KPAD_Y;
        static rd_font ef;
        if (ef.payload || rd_font_open(&RD.pak, "FONTTINY.FF", &ef)) {
            const uint8_t ink[4] = { 0xFF, 68, 67, 0 };
            rd_fill(8, py - 13, 304, 11, 0x2E);
            rd_text(&ef, UI.dlg_entry, 12, py - 11, ink);
        }
        if (dlg_is_text()) draw_kbd();
        else draw_kpad();
    }
    if (bt_mode) bt_ui_draw();
    if (UI.screen != SCR_WOODCUT) sfx_last_woodcut = -1;
    flush_fb();
    if (sfx_pending >= 0) {
        int id = sfx_pending, id2 = sfx_pending2;
        sfx_pending = sfx_pending2 = -1;
        sfx_play(id);
        if (id2 >= 0) sfx_play(id2);     /* RAIDSHIP fires a pair */
    }
}

/* ---- the player-answer layer (colopy_ask_hook) -------------------- */
static volatile int ask_active = 0;
static char ask_key[16];

static void game_key(const char *name, int alt, int shift) {
    if (ask_active) {                        /* the ask's own pump */
        snprintf(ask_key, sizeof(ask_key), "%s", name);
        (void)alt; (void)shift;
        return;
    }
    if (have_pending) {                      /* the modal swallow */
        have_pending = 0;
        draw_screen();
        return;
    }
    in_key(name, alt, shift);
    hof_save_sd();
    if (UI.request) { service_request(); return; }
    draw_screen();
}

/* LIVE menu tracking (SHELL CHROME, user report 2026-08-17: "the
 * screen is small, so my fingers don't always hit the right one").
 * While a finger is DOWN on the map's menu bar or an open pulldown,
 * the highlight follows it: pressing a bar title opens that menu at
 * once, sliding across the bar switches menus, sliding down the rows
 * moves the selection bar (drawPulldown paints UI.menu_sel).  The lift
 * commits whatever is highlighted — game_tap already reads the release
 * point, which now tracks the finger.  Redraws only on a CHANGE. */
static uint8_t *menu_bg = nullptr;     /* the map behind an open menu */

/* Re-compositing the map for every highlight step would crawl (15x12
 * tiles + the 3x flush), so the map is cached ONCE when the menu opens
 * and each step just restores it and repaints the pulldown.  Heap, not
 * .bss — 64 KB of static data overflows this board's internal SRAM. */
static void menu_cache(void) {
    if (!menu_bg) menu_bg = (uint8_t *)malloc(RD_W * RD_GAME_H);
    rm_draw_map_zoom(UI.view_x, UI.view_y, UI.sel, map_blink, UI.zoom);
    if (menu_bg) memcpy(menu_bg, RD.fb, RD_W * RD_GAME_H);
}
static void menu_repaint(void) {
    if (!menu_bg) { draw_screen(); return; }
    memcpy(RD.fb, menu_bg, RD_W * RD_GAME_H);
    if (UI.open_menu >= 0)
        rm_draw_pulldown(UI.open_menu, UI.menu_sel, UI.sel);
    flush_fb();
}

static void menu_track(int gx, int gy) {
    if (UI.screen != SCR_MAP || UI.dlg || have_pending) return;
    int bar = gy < 10 ? rm_menubar_hit(gx) : -1;
    if (bar >= 0) {                       /* on a bar title */
        if (bar != UI.open_menu) {
            int had = UI.open_menu >= 0;
            in_click(gx, gy < 8 ? gy : 7, 0);   /* openMenu(bar) */
            if (UI.request) { service_request(); return; }
            if (!had) menu_cache();             /* snapshot the map once */
            menu_repaint();
        }
        return;
    }
    if (UI.open_menu < 0) return;
    int bx, by, bw, bh;
    rm_pulldown_box(UI.open_menu, UI.sel, &bx, &by, &bw, &bh);
    if (gx < bx || gx >= bx + bw || gy < by || gy >= by + bh) return;
    rm_mrow rows[64];
    int n = rm_menu_rows(UI.open_menu, UI.sel, rows);
    int py = by + 2, r = -1;
    for (int k = 0; k < n; k++) {
        int rh = rows[k].sep ? 7 : 8;
        if (gy >= py && gy < py + rh) { r = k; break; }
        py += rh;
    }
    if (r >= 0 && r != UI.menu_sel && rows[r].label && !rows[r].sep &&
        !rows[r].dim) {
        UI.menu_sel = (int8_t)r;
        menu_repaint();
    }
}

/* a LONG-press in the game loop.  Space (skip the unit) everywhere but
 * the Europe market bar, where it BUYS: the pointer layer's market
 * click is sell-only (game.js:12563 routes it to sellFromShip) and
 * buying is the L/= key or a drag — neither reachable by touch, so a
 * board player could never stock a ship.  SHELL CHROME: it just sets
 * the market cursor and sends the core's own buy key. */
static void game_long(int gx, int gy) {
    if (!ask_active && !have_pending && !UI.dlg &&
        UI.screen == SCR_EUROPE && !UI.euro_menu && gy >= 179) {
        int i = gx / 19;
        if (i >= 0 && i < 16) {
            UI.market_sel = (int8_t)i;
            game_key("l", 0, 0);             /* buyToShip(sel, 100) */
            return;
        }
    }
    game_key(" ", 0, 0);
}

/* a tap in the game loop (outside an ask) */
static void game_tap(int gx, int gy) {
    if (bt_mode) { bt_ui_tap(gx, gy); return; }
    if (UI.screen == SCR_TITLE && !have_pending && !UI.dlg &&
        gy >= BT_ROW_Y - 1 && gy < BT_ROW_Y + 8 &&
        gx >= 81 && gx < 81 + 158) {
        bt_mode = 1;                         /* SHELL CHROME row */
        draw_screen();
        return;
    }
    if (have_pending) {                      /* the modal swallow */
        have_pending = 0;
        draw_screen();
        return;
    }
    if (UI.dlg) {                 /* entry modal: pad types, box = Enter */
        rm_subs subs;
        dlg_subs(&subs);
        int epy = (dlg_is_text() ? KBD_Y : KPAD_Y) - 13;
        if (gy >= epy && gy < epy + 11 && gx >= 8 && gx < 312) {
            /* tap the entry line to CLEAR it: typing APPENDS to the
             * prefill (dialogKey, game.js:988), so a rename would
             * otherwise need one tap back per prefilled letter.
             * Shell chrome — the core keeps the JS key semantics. */
            while (UI.dlg_entry[0]) in_key("Backspace", 0, 0);
            draw_screen();
            return;
        }
        char ch = dlg_is_text() ? kbd_hit(gx, gy) : kpad_hit(gx, gy);
        if (ch == '<') in_key("Backspace", 0, 0);
        else if (ch == '#') in_key("Enter", 0, 0);
        else if (ch) {
            char one[2] = { ch, 0 };
            in_key(one, 0, 0);
        } else
            in_key(rm_event_hit(dlg_key(), &subs, 0, gx, gy) ? "Enter"
                                                             : "Escape",
                   0, 0);
        draw_screen();
        return;
    }
    if (UI.screen == SCR_NAME) {     /* the touch keyboard owns taps */
        char ch = kbd_hit(gx, gy);
        if (ch == '<') in_key("Backspace", 0, 0);
        else if (ch == '#') in_key("Enter", 0, 0);
        else if (ch) {
            char one[2] = { ch, 0 };
            in_key(one, 0, 0);
        }
        draw_screen();
        return;
    }
    /* the menu bar is an 8-px strip (24 panel px) at the very top edge
     * where the touch panel is least accurate — accept taps a little
     * below it as bar hits (the 2 borrowed px are the first tile row's
     * top edge, never a distinct target) */
    if (UI.screen == SCR_MAP && gy < 10) {
        /* the tracker opens a menu on PRESS, so a release on the title
         * it opened must not toggle it shut again */
        if (UI.open_menu >= 0 && rm_menubar_hit(gx) == UI.open_menu) return;
        in_click(gx, gy < 8 ? gy : 7, 0);
        if (UI.request) { service_request(); return; }
        draw_screen();
        return;
    }
    if (UI.screen == SCR_TRADE) {
        static char trows[20][64];
        static const char *trp[20];
        int tn = ui_trade_rows(trows, 20);
        for (int i = 0; i < tn; i++) trp[i] = trows[i];
        char sofar[128];
        ui_trade_sofar(sofar, (int)sizeof(sofar));
        int r = rm_trade_row_hit(UI.trade_mode, UI.trade_n_stops + 1,
                                 sofar, trp, tn, gx, gy);
        if (r >= 0) {
            UI.trade_row = (int8_t)r;
            in_key("Enter", 0, 0);
        } else if (r == -1)
            in_key("Escape", 0, 0);
        draw_screen();
        return;
    }
    /* open pulldown: pick the tapped VISIBLE row and commit with Enter.
     * FLAGGED shell divergence from the DOS/JS pointer path (in_click,
     * game.js:12296), which clamps the clicked row at the MASTER row
     * count — REPORTS shows 12 rows (separators included) over a master
     * count of 10, so its last two rows (F8 Foreign Affairs / F9 Indian
     * Advisor) are unreachable by pointer there.  The keyboard path
     * (arrows + Enter, run_menu_row over the visible-row model) reaches
     * every row; this maps the tap onto that path instead. */
    if (UI.screen == SCR_MAP && UI.open_menu >= 0) {
        int bx, by, bw, bh;
        rm_pulldown_box(UI.open_menu, UI.menu_sel, &bx, &by, &bw, &bh);
        if (gx >= bx && gx < bx + bw && gy >= by && gy < by + bh) {
            /* walk the rows with the painter's pitch (8 px per row,
             * 7 px per separator — drawPulldown) to find the tap */
            rm_mrow rows[64];
            int n = rm_menu_rows(UI.open_menu, UI.sel, rows);
            int py = by + 2, r = -1;
            for (int k = 0; k < n; k++) {
                int rh = rows[k].sep ? 7 : 8;
                if (gy >= py && gy < py + rh) { r = k; break; }
                py += rh;
            }
            if (r >= 0 && rows[r].label && !rows[r].sep && !rows[r].dim) {
                UI.menu_sel = (int8_t)r;
                in_key("Enter", 0, 0);
                if (UI.request) { service_request(); return; }
            }
            draw_screen();
            return;
        }
        /* off the box falls through to in_click (closes the menu) */
    }
    /* map viewport, no menu open: a tap on a tile ADJACENT to the
     * active unit is that direction's movement key (the click layer
     * itself never moves — the DOS game moved by keys/drag).  The
     * active unit's own tile falls through to the click layer's
     * stacked-unit cycling; everything else clicks. */
    if (UI.screen == SCR_MAP && UI.open_menu < 0 && !UI.view_mode &&
        UI.zoom == 0 &&                /* 16px tiles only; zoomed taps
                                        * go to in_click (TILE_PX-aware) */
        gx < 240 && gy >= 8 &&
        UI.sel >= 0 && UI.sel < CR.n_units_order) {
        int u = CR.units_order[UI.sel];
        int tx = UI.view_x + gx / 16;
        int ty = UI.view_y + (gy - 8) / 16;
        int dx = tx - CS.units[u].map_x;
        int dy = ty - CS.units[u].map_y;
        if ((dx || dy) && dx >= -1 && dx <= 1 && dy >= -1 && dy <= 1) {
            static const char *DK[3][3] = {
                { "7", "ArrowUp", "9" },
                { "ArrowLeft", "", "ArrowRight" },
                { "1", "ArrowDown", "3" },
            };
            in_key(DK[dy + 1][dx + 1], 0, 0);
            draw_screen();
            return;
        }
    }
    in_click(gx, gy, 0);
    hof_save_sd();
    if (UI.request) { service_request(); return; }
    draw_screen();
}

/* "k <name>" — the serial bench path for the game loop */
static void cmd_key(const char *arg) {
    if (!game_mode) { Serial.println("not in game mode (g)"); return; }
    int alt = 0;
    if (arg[0] == '!' && arg[1]) { alt = 1; arg++; }
    if (strcmp(arg, "Space") == 0) game_key(" ", alt, 0);
    else game_key(arg, alt, 0);
}

/* the blocking answer pump: serial "k <name>" lines or a touch tap.
 * Returns TT_TAP with the game coordinate in (*gx,*gy), or TT_KEY
 * with the key name in ask_key[].  (No sketch-defined types in
 * signatures — the IDE's auto-prototypes land above any typedef.) */
static int ask_wait(int *gx, int *gy) {
    static char line[96];
    int len = 0;
    ask_key[0] = 0;
    for (;;) {
#if COLOPY_AUDIO
        audio_tick();                /* keep the rotation alive in asks */
#endif
        int ev = touch_poll(gx, gy);
        if (ev == TT_ESC) {                  /* two-finger = Escape */
            snprintf(ask_key, sizeof(ask_key), "Escape");
            return TT_KEY;
        }
        if (ev == TT_TAP || ev == TT_LONG)   /* long-press = a tap here */
            return TT_TAP;
        while (Serial.available()) {
            char ch = (char)Serial.read();
            if (ch == '\n' || ch == '\r') {
                line[len] = 0;
                len = 0;
                if (line[0] == 'k' && line[1] == ' ') {
                    const char *a = line + 2;
                    if (a[0] == '!' && a[1]) a++;
                    snprintf(ask_key, sizeof(ask_key), "%s",
                             strcmp(a, "Space") == 0 ? " " : a);
                    return TT_KEY;
                }
            } else if (len < 94) {
                line[len++] = ch;
            }
        }
        delay(5);
    }
}

/* ---- the shell's disk UI (Save Game / Load Game menu rows) --------
 * The core never does I/O: a GAME-menu row sets UI.request ('S'/'L')
 * and the shell services it here with a list modal.  This box is
 * SHELL CHROME (the DOS save dialog is a different, undocumented
 * screen — not reproduced): plaque + tiny-font rows, tap a row or
 * arrows+Enter, tap outside / Escape cancels. */
static const char *pick_rows[12];

static int shell_pick(const char *title, int n) {
    if (n < 1 || !pak_ready) return -1;
    static rd_font f;
    if (!f.payload && !rd_font_open(&RD.pak, "FONTTINY.FF", &f)) return -1;
    int w = 150, h = 14 + n * 10 + 4;
    int x = (320 - w) / 2, y = (200 - h) / 2;
    int sel = 0;
    const uint8_t ink[4] = { 0xFF, 68, 67, 0 };
    for (;;) {
        rm_plaque(x, y, w, h);
        rd_text(&f, title, x + 6, y + 4, ink);
        for (int i = 0; i < n; i++) {
            int oy = y + 14 + i * 10;
            if (i == sel) rd_fill(x + 3, oy - 1, w - 6, 9, 138);
            rd_text(&f, pick_rows[i], x + 8, oy, ink);
        }
        flush_fb();
        int gx, gy;
        int ev = ask_wait(&gx, &gy);
        if (ev == TT_TAP) {
            if (gx < x || gx >= x + w || gy < y || gy >= y + h) return -1;
            int i = (gy - (y + 14)) / 10;
            if (gy >= y + 14 && i >= 0 && i < n) return i;
            continue;
        }
        const char *k = ask_key;
        if (strcmp(k, "ArrowUp") == 0) sel = (sel + n - 1) % n;
        else if (strcmp(k, "ArrowDown") == 0) sel = (sel + 1) % n;
        else if (strcmp(k, "Enter") == 0 || strcmp(k, " ") == 0) return sel;
        else if (strcmp(k, "Escape") == 0) return -1;
    }
}

static void land_view(void);             /* fwd: the post-load view */

static void service_request(void) {
    if (!UI.request) return;
    char r = (char)UI.request;
    UI.request = 0;
    if (sd_ready && r == 'S') {
        /* ten numbered slots, as the DOS game had.  SHELL CHROME: each
         * row says whether the slot is already taken so a save cannot
         * silently land on top of another game. */
        static char names[10][16], rows[10][32];
        for (int i = 0; i < 10; i++) {
            snprintf(names[i], sizeof(names[i]), "COLONY0%d.SAV", i);
            char path[64];
            snprintf(path, sizeof(path), "/sdcard/%s", names[i]);
            FILE *pf = fopen(path, "rb");
            int used = pf != NULL;
            if (pf) fclose(pf);
            snprintf(rows[i], sizeof(rows[i]), "%s  %s", names[i],
                     used ? "(in use)" : "(empty)");
            pick_rows[i] = rows[i];
        }
        int k = shell_pick("SAVE GAME - pick a slot", 10);
        if (k >= 0) cmd_save(names[k]);
    } else if (sd_ready && r == 'L') {
        static char names[10][32];
        int n = 0;
        DIR *d = opendir("/sdcard");
        if (d) {
            struct dirent *e;
            while ((e = readdir(d)) != NULL && n < 10) {
                const char *nm = e->d_name;
                size_t L = strlen(nm);
                if (L > 4 && strcasecmp(nm + L - 4, ".SAV") == 0) {
                    snprintf(names[n], sizeof(names[n]), "%s", nm);
                    pick_rows[n] = names[n];
                    n++;
                }
            }
            closedir(d);
        }
        int k = shell_pick("LOAD GAME - pick a save", n);
        if (k >= 0) {
            cmd_load(pick_rows[k]);
            UI.screen = SCR_MAP;
            land_view();
        }
    }
    draw_screen();
}

/* colopy_ask_hook: the core emits the question's prompt event, then
 * calls this.  Earlier queued notices show as plain popups (any key or
 * tap dismisses); the prompt draws through the dialog framework with
 * its GAME.TXT tail rows as options — tap a row (or arrows + Enter)
 * answers it, tap outside the box (or Escape) dismisses (-1, the JS
 * closeDialog(-1) reading). */
static int board_ask(void) {
    colopy_event q[8];
    int n = 0;
    colopy_event e2;
    while (colopy_next_event(&e2)) {
#if COLOPY_AUDIO
        au_on_event(e2.key, e2.p[0]);
#endif
        if (n < 8) q[n++] = e2;
    }
    ask_active = 1;
    for (int i = 0; i + 1 < n; i++) {
        if (!rm_event_exists(q[i].key)) continue;
        rm_subs subs = { { q[i].s[0], q[i].s[1], 0, 0 },
                         { q[i].p[0], q[i].p[1], 0, 0 },
                         { 1, 1, 0, 0 } };
        rm_draw_event(q[i].key, &subs, 0);
        flush_fb();
        int gx, gy;
        ask_wait(&gx, &gy);                  /* any input dismisses */
    }
    int ret = 0;
    /* runtime option rows (the JS askEvent rows argument) arrive on the
     * live-front channel — snapshot and clear before pumping input */
    char rr[18][26];
    const char *rp[18];
    int nrr = CR.n_ask_rows;
    if (nrr > 18) nrr = 18;
    for (int i = 0; i < nrr; i++) {
        memcpy(rr[i], CR.ask_rows[i], sizeof(rr[i]));
        rp[i] = rr[i];
    }
    CR.n_ask_rows = 0;
    if (n > 0 && rm_event_exists(q[n - 1].key)) {
        int rows = nrr > 0 ? nrr : rm_event_rows(q[n - 1].key);
        if (rows < 1) rows = 1;
        /* the ask may open HIGHLIGHTED on a row (the JS G.dialog.sel —
         * Pick Music preselects the current tune's row) */
        int sel = CR.ask_sel > 0 && CR.ask_sel < rows ? CR.ask_sel : 0;
        for (;;) {
            rm_subs subs = { { q[n - 1].s[0], q[n - 1].s[1], 0, 0 },
                             { q[n - 1].p[0], q[n - 1].p[1], 0, 0 },
                             { 1, 1, 0, 0 } };
            if (nrr > 0)
                rm_draw_dialog_rows(q[n - 1].key, &subs, 0, sel, rp, nrr);
            else
                rm_draw_dialog_event(q[n - 1].key, &subs, 0, sel);
            flush_fb();
            int gx, gy;
            int ev = ask_wait(&gx, &gy);
            if (ev == TT_TAP) {
                int r = nrr > 0
                    ? rm_dialog_rows_hit(q[n - 1].key, &subs, 0, gx, gy,
                                         rp, nrr)
                    : rm_dialog_row_hit(q[n - 1].key, &subs, 0, gx, gy);
                if (r >= 0) { ret = r; break; }      /* tap a row */
                if (r == -1) { ret = -1; break; }    /* outside = dismiss */
                continue;                            /* body: ignore */
            }
            const char *k = ask_key;
            if (strcmp(k, "ArrowUp") == 0) sel = (sel + rows - 1) % rows;
            else if (strcmp(k, "ArrowDown") == 0) sel = (sel + 1) % rows;
            else if (strcmp(k, "Enter") == 0 || strcmp(k, " ") == 0) {
                ret = sel;
                break;
            } else if (strcmp(k, "Escape") == 0) {
                ret = -1;
                break;
            }
        }
    }
    ask_active = 0;
    return ret;
}

/* ---- BLE mouse: the implementation (needs draw_screen/game_tap) --- */
#if COLOPY_BLE_MOUSE

#define BT_MAX_DEV 8
static int  bt_n = 0, bt_sel = 0;
static char bt_name[BT_MAX_DEV][28];
static char bt_addr[BT_MAX_DEV][20];
static BLEClient *bt_client = nullptr;
/* cursor state, in the 320x200 logical space */
static int  ms_x = 160, ms_y = 100, ms_btn = 0, ms_moved = 0;

static void bt_report(uint8_t *d, size_t n) {
    if (n < 3) return;
    int8_t dx = (int8_t)d[1], dy = (int8_t)d[2];
    int b = d[0] & 0x07;
    ms_x += dx;
    ms_y += dy;
    if (ms_x < 0) ms_x = 0;
    if (ms_x > RD_W - 1) ms_x = RD_W - 1;
    if (ms_y < 0) ms_y = 0;
    if (ms_y > RD_GAME_H - 1) ms_y = RD_GAME_H - 1;
    if (dx || dy) ms_moved = 1;
    ms_btn = b;
}

/* The notify callback is a CAPTURELESS LAMBDA at its registration site
 * (see bt_connect below), not a named function, and that placement is
 * load-bearing rather than stylistic.
 *
 * The IDE generates a prototype for every function definition it finds
 * in the .ino and hoists the whole block ABOVE this file's own
 * #includes.  A prototype naming BLERemoteCharacteristic therefore
 * lands where <BLEDevice.h> has not been seen yet, and the sketch dies
 * with "variable or field 'bt_notify_cb' declared void" — reported
 * from a real Arduino IDE 3.3.11 / esp32 core build, 2026-08-19.
 *
 * The previous guard here was a one-space indent, on the belief that
 * the generator only picks up definitions starting at column 0.  That
 * is FALSE on the current toolchain: the indented definition was
 * hoisted regardless.  A lambda has no name to hoist, so it cannot be,
 * whatever the generator's heuristics turn out to be next.  Do not
 * lift this back out into a named function. */

/* scan for devices ADVERTISING the HID service (0x1812) */
static void bt_scan(void) {
    bt_begin();                  /* first use is where BLE may fail */
    bt_state = 1;
    bt_n = 0;
    BLEScan *scan = BLEDevice::getScan();
    scan->setActiveScan(true);
    BLEScanResults *res = scan->start(5, false);
    for (int i = 0; res && i < res->getCount() && bt_n < BT_MAX_DEV; i++) {
        BLEAdvertisedDevice d = res->getDevice(i);
        if (!d.isAdvertisingService(BLEUUID((uint16_t)0x1812))) continue;
        snprintf(bt_name[bt_n], sizeof(bt_name[0]), "%s",
                 d.getName().length() ? d.getName().c_str() : "(unnamed)");
        snprintf(bt_addr[bt_n], sizeof(bt_addr[0]), "%s",
                 d.getAddress().toString().c_str());
        bt_n++;
    }
    scan->clearResults();
    bt_state = 2;
    bt_sel = 0;
}

static void bt_connect(int i) {
    if (i < 0 || i >= bt_n) return;
    bt_state = 3;
    if (!bt_client) bt_client = BLEDevice::createClient();
    BLEAddress addr(bt_addr[i]);
    if (!bt_client->connect(addr)) { bt_state = 5; return; }
    BLERemoteService *svc = bt_client->getService(BLEUUID((uint16_t)0x1812));
    if (!svc) { bt_client->disconnect(); bt_state = 5; return; }
    /* subscribe to every Report characteristic (0x2A4D) the mouse has */
    int subscribed = 0;
    std::map<std::string, BLERemoteCharacteristic *> *cs =
        svc->getCharacteristics();
    if (cs)
        for (auto &kv : *cs) {
            BLERemoteCharacteristic *ch = kv.second;
            if (!ch->getUUID().equals(BLEUUID((uint16_t)0x2A4D))) continue;
            if (!ch->canNotify()) continue;
            ch->registerForNotify(
                [](BLERemoteCharacteristic *rc, uint8_t *d, size_t n,
                   bool isNotify) {
                    (void)rc; (void)isNotify;
                    bt_report(d, n);
                });
            subscribed++;
        }
    bt_state = subscribed ? 4 : 5;
}

static void bt_ui_draw(void) {
    rm_plaque(30, 40, 260, 120);
    static rd_font bf;
    if (!bf.payload && !rd_font_open(&RD.pak, "FONTTINY.FF", &bf)) return;
    const uint8_t ink[4] = { 0xFF, 0xFE, 0xFD, 0 };
    const uint8_t hi[4] = { 0xFF, 0xFC, 0xFB, 0 };
    rd_text(&bf, "Bluetooth mouse", 40, 48, hi);
    const char *msg = bt_state == 1 ? "Scanning..."
                    : bt_state == 3 ? "Connecting..."
                    : bt_state == 4 ? "Connected - tap to play"
                    : bt_state == 5 ? "Failed - tap Scan to retry"
                    : bt_n ? "Tap a device to pair:"
                           : "No BLE mice found - tap Scan";
    rd_text(&bf, msg, 40, 60, ink);
    for (int i = 0; i < bt_n; i++) {
        int y = 74 + i * 9;
        if (i == bt_sel) rd_fill(38, y - 1, 244, 9, 138);
        rd_text(&bf, bt_name[i], 42, y, i == bt_sel ? hi : ink);
        rd_text(&bf, bt_addr[i], 190, y, ink);
    }
    rd_text(&bf, "[Scan]", 40, 148, hi);
    rd_text(&bf, "[Close]", 240, 148, hi);
}

/* returns 1 when the tap was consumed by the pairing screen */
static int bt_ui_tap(int gx, int gy) {
    if (!bt_mode) return 0;
    if (gy >= 145 && gy < 158) {
        if (gx < 120) { bt_scan(); draw_screen(); return 1; }
        bt_mode = 0;
        draw_screen();
        return 1;
    }
    for (int i = 0; i < bt_n; i++) {
        int y = 74 + i * 9;
        if (gy >= y - 1 && gy < y + 8) {
            bt_sel = i;
            draw_screen();          /* show the highlight before blocking */
            bt_connect(i);
            draw_screen();
            return 1;
        }
    }
    return 1;                        /* the screen swallows stray taps */
}

/* the software cursor: save the patch under it so a move costs a small
 * restore + redraw rather than a whole frame */
static uint8_t ms_save[10 * 10];
static int ms_shown = 0, ms_sx = 0, ms_sy = 0;
static void cursor_hide(void) {
    if (!ms_shown) return;
    for (int y = 0; y < 10; y++) {
        int fy = ms_sy + y;
        if (fy < 0 || fy >= RD_GAME_H) continue;
        for (int x = 0; x < 10; x++) {
            int fx = ms_sx + x;
            if (fx < 0 || fx >= RD_W) continue;
            RD.fb[fy * RD_W + fx] = ms_save[y * 10 + x];
        }
    }
    ms_shown = 0;
}
static void cursor_show(void) {
    ms_sx = ms_x;
    ms_sy = ms_y;
    for (int y = 0; y < 10; y++) {
        int fy = ms_sy + y;
        for (int x = 0; x < 10; x++) {
            int fx = ms_sx + x;
            ms_save[y * 10 + x] = (fx >= 0 && fx < RD_W && fy >= 0 &&
                                   fy < RD_GAME_H)
                                      ? RD.fb[fy * RD_W + fx] : 0;
        }
    }
    for (int i = 0; i < 8; i++) {          /* a simple arrow in 0x0F/0 */
        if (ms_y + i < RD_GAME_H) RD.fb[(ms_y + i) * RD_W + ms_x] = 0x0F;
        if (ms_x + i < RD_W) RD.fb[ms_y * RD_W + ms_x + i] = 0x0F;
    }
    ms_shown = 1;
}

/* called from loop(): move the cursor and turn buttons into taps */
static void bt_pump(void) {
    static int last_btn = 0;
    if (bt_state != 4 || !game_mode || ask_active) return;
    if (ms_moved) {
        ms_moved = 0;
        cursor_hide();
        cursor_show();
        flush_fb();
    }
    if (ms_btn != last_btn) {
        int pressed = ms_btn & ~last_btn;
        last_btn = ms_btn;
        if (pressed & 0x01) {            /* left button = a tap */
            cursor_hide();
            if (bt_mode) bt_ui_tap(ms_x, ms_y);
            else game_tap(ms_x, ms_y);
            cursor_show();
            flush_fb();
        } else if (pressed & 0x02) {     /* right button = Escape */
            cursor_hide();
            game_key("Escape", 0, 0);
            cursor_show();
            flush_fb();
        }
    }
}

/* LAZY, and that is the point.  BLEDevice::init() brings up the NimBLE
 * host over the ESP-Hosted link to the C6, and on a board whose C6 runs
 * Wi-Fi-only slave firmware that init ABORTS — which on the ESP32 means
 * a panic and a reboot, i.e. the game never boots at all.  Two of the
 * three conditions in the banner at the top of this file are outside
 * this sketch's control and one of them is explicitly unverified, so
 * this must not sit in setup().  Calling it from the Bluetooth row
 * instead means a broken or absent hosted-BT stack costs you Bluetooth
 * and nothing else.
 *
 * bt_init() is therefore a no-op at boot; bt_begin() does the real work
 * on first use and remembers whether it has run. */
static int bt_started = 0;
static void bt_init(void) {}
static void bt_begin(void) {
    if (bt_started) return;
    bt_started = 1;
    Serial.println("BLE: bringing up the host over the C6...");
    Serial.flush();          /* so the line survives a panic in init() */
    BLEDevice::init("Colopy");
    Serial.println("BLE: host up (hosted C6). Tap Scan to look for a "
                   "mouse.");
}
#endif

/* ---- stack headroom -------------------------------------------------
 * The UI paints from the Arduino loop task, whose stack is only a few
 * KB.  A fat painter frame is a CRASH, not a slowdown: the colony
 * screen once put a 25,600-byte scene band on the stack, which smashed
 * it (fixed 2026-08-17; the host build now fails on any frame over
 * 4 KB).  This prints the low-water mark so headroom is observable on
 * the real board instead of inferred — 'w' over serial, and once at
 * boot.  A number near zero means the next deep screen will crash. */
static void stack_report(const char *when) {
    UBaseType_t left = uxTaskGetStackHighWaterMark(NULL);
    Serial.printf("stack: %u bytes never used (%s)\n",
                  (unsigned)(left * sizeof(StackType_t)), when);
}

/* 'm': the memory census, measured on the board rather than asserted.
 * cport/MEMORY_BUDGET.md records the host-measured static sizes (they are
 * platform-independent), but how much internal SRAM this core actually
 * leaves after the IDF, the DPI driver and the Arduino runtime have taken
 * their share is a hardware fact — so read it, do not quote it. */
static void mem_report(void) {
    Serial.printf("internal SRAM: %u free of %u, largest block %u, "
                  "min ever free %u\n",
                  (unsigned)heap_caps_get_free_size(MALLOC_CAP_INTERNAL),
                  (unsigned)heap_caps_get_total_size(MALLOC_CAP_INTERNAL),
                  (unsigned)heap_caps_get_largest_free_block(MALLOC_CAP_INTERNAL),
                  (unsigned)heap_caps_get_minimum_free_size(MALLOC_CAP_INTERNAL));
    Serial.printf("PSRAM:         %u free of %u, largest block %u\n",
                  (unsigned)heap_caps_get_free_size(MALLOC_CAP_SPIRAM),
                  (unsigned)heap_caps_get_total_size(MALLOC_CAP_SPIRAM),
                  (unsigned)heap_caps_get_largest_free_block(MALLOC_CAP_SPIRAM));
    Serial.printf("our PSRAM:     fbuf %u, pakbuf %u, savbuf %u, sidebuf %u\n",
                  (unsigned)((size_t)P4_W * P4_H * 2), (unsigned)PAKBUF_CAP,
                  (unsigned)SAVBUF_CAP, (unsigned)SIDEBUF_CAP);
    stack_report("now");
}

/* ---- the serial shell (mirrors the Teensy build) ------------------- */
static void run_turn(void) {
    turn_step_prefix();
    turn_step2();
    turn_step3();
    turn_step5();
}

/* ---- the .SAV sidecar -----------------------------------------------
 * The .SAV is written byte-exact, so a colony's UNIT build target (the
 * port's own 0xC0+u marker, stripped by the writer) and the trade-route
 * table have nowhere to live in it.  They go in a companion file with
 * the same stem and a .CPX extension; colopy_extras_read() validates it
 * against the loaded save and drops itself if it does not belong, so a
 * missing or stale sidecar simply means the old behaviour. */
static void sidecar_path(const char *name, char *out, size_t cap) {
    snprintf(out, cap, "/sdcard/%s", name);
    size_t l = strlen(out);
    if (l > 4 && strcasecmp(out + l - 4, ".SAV") == 0)
        snprintf(out + l - 4, cap - (l - 4), ".CPX");
    else
        snprintf(out + l, cap - l, ".CPX");
}

static void sidecar_save(const char *name) {
    if (!sidebuf) return;            /* PSRAM, not a static: the core's
                                      * own statics already crowd internal
                                      * SRAM — 'm' prints what is left */
    size_t sn = colopy_extras_write(sidebuf, SIDEBUF_CAP);
    if (!sn) return;
    char path[112];
    sidecar_path(name, path, sizeof(path));
    FILE *f = fopen(path, "wb");
    if (!f) return;
    fwrite(sidebuf, 1, sn, f);
    fclose(f);
}

static void sidecar_load(const char *name) {
    if (!sidebuf) return;
    char path[112];
    sidecar_path(name, path, sizeof(path));
    FILE *f = fopen(path, "rb");
    if (!f) return;
    size_t sn = fread(sidebuf, 1, SIDEBUF_CAP, f);
    fclose(f);
    if (sn && colopy_extras_read(sidebuf, sn))
        Serial.println("sidecar applied (build targets + trade routes)");
}

static void cmd_load(const char *name) {
    if (!sd_ready) { Serial.println("no SD card"); return; }
    size_t n = sd_read_file(name, savbuf, SAVBUF_CAP);
    if (!n) { Serial.printf("no such file: %s\n", name); return; }
    colopy_status st = colopy_load_sav(savbuf, n);
    if (st != COLOPY_OK) { Serial.printf("load failed: %d\n", (int)st); return; }
    colopy_init(1653);              /* the shared parity seed */
    sidecar_load(name);             /* build targets + trade routes */
    units_session_seed();           /* importer runtime setup: full moves,
                                     * orders 0 — without it the first
                                     * digest diverges from the host */
    for (int d = 0; d < 3; d++) roll_immigrant(&CR.dock[d]);
    sav_loaded = true;
#if COLOPY_AUDIO
    /* the save's [0x5386] mirror low bits: bit1 BG / bit2 Event / bit3
     * SFX (spec §2, pinned @0x023301) */
    au_load_switches((uint8_t)(cs_tut_mask() & 0x0E));
#endif
    Serial.printf("loaded %u bytes, digest %08lX\n", (unsigned)n,
                  (unsigned long)colopy_digest());
}

static void cmd_save(const char *name) {
    if (!sd_ready) { Serial.println("no SD card"); return; }
    size_t n = colopy_save_sav(savbuf, SAVBUF_CAP);
    if (!n) { Serial.println("save failed"); return; }
    char path[96];
    snprintf(path, sizeof(path), "/sdcard/%s", name);
    FILE *f = fopen(path, "wb");
    if (!f || fwrite(savbuf, 1, n, f) != n) {
        if (f) fclose(f);
        Serial.println("SD write failed");
        return;
    }
    fclose(f);
    sidecar_save(name);
    Serial.printf("wrote %u bytes, digest %08lX\n", (unsigned)n,
                  (unsigned long)colopy_digest());
}

static void cmd_info(void) {
    colopy_overview ov;
    colopy_get_overview(&ov);
    Serial.printf("year %d s%u turn %u  units %u colonies %u villages %u"
                  "  tax %u%%\n", ov.year, ov.season, ov.turn, ov.n_units,
                  ov.n_colonies, ov.n_settlements, ov.tax_rate);
}

static void pak_load(void) {
    if (pak_ready) return;
    if (!sd_ready) { Serial.println("no SD card"); return; }
    size_t n = sd_read_file("COLOPY.PAK", pakbuf, PAKBUF_CAP);
    if (!n) { Serial.println("no COLOPY.PAK on SD"); return; }
    if (!rd_init(pakbuf, (uint32_t)n)) {
        Serial.println("bad pak");
        return;
    }
    pak_ready = 1;
}

static void cmd_view(void) {                 /* 'v': render the map view */
    pak_load();
    if (!pak_ready) return;
    cyc_wanted = 1;                          /* the map palette is up */
    /* centre on the first player unit (centerView semantics) */
    int vx = 0, vy = 0;
    if (CR.n_units_order) {
        const UnitRecord *u = &CS.units[CR.units_order[0]];
        vx = u->map_x - 7;
        vy = u->map_y - 6;
        if (vx < 0) vx = 0;
        if (vy < 0) vy = 0;
        if (vx > COLOPY_MAP_W - 15) vx = COLOPY_MAP_W - 15;
        if (vy > COLOPY_MAP_H - 12) vy = COLOPY_MAP_H - 12;
    }
    unsigned long t0 = micros();
    rm_draw_map(vx, vy, 0, 1);
    unsigned long t1 = micros();
    flush_fb();
    Serial.printf("map view (%d,%d): draw %lu us, flush %lu us\n",
                  vx, vy, t1 - t0, micros() - t1);
}

/* the importer's landing view/sel (game.js:10490) — shared by 'g' and
 * the in-game Load Game picker */
static void land_view(void) {
    UI.sel = 0;
    for (int q = 0; q < CR.n_units_order; q++) {
        int u2 = CR.units_order[q];
        if (dat_units[CS.units[u2].type].hull <= 0) {
            UI.sel = q;
            break;
        }
    }
    int cx = -1, cy = -1;
    if (CR.n_units_order) {
        int u2 = CR.units_order[UI.sel];
        cx = CS.units[u2].map_x;
        cy = CS.units[u2].map_y;
    } else
        for (int q = 0; q < CS.n_colonies; q++)
            if ((CS.colonies[q].owner_power & 3) == cs_nation()) {
                cx = CS.colonies[q].map_x;
                cy = CS.colonies[q].map_y;
                break;
            }
    if (cx >= 0) {
        int tx = cx - 7, ty = cy - 6;
        if (tx > COLOPY_MAP_W - 15) tx = COLOPY_MAP_W - 15;
        if (ty > COLOPY_MAP_H - 12) ty = COLOPY_MAP_H - 12;
        if (tx < 0) tx = 0;
        if (ty < 0) ty = 0;
        UI.view_x = tx;
        UI.view_y = ty;
    }
}

/* enter the game UI at the TITLE screen — the real boot: New Game runs
 * the full flow (difficulty/nation/name/briefing -> colopy_new_game),
 * LOAD GAME opens the shell's SD picker.  Needs only the pak. */
static void hof_load_sd(void) {
    if (!sd_ready) return;
    FILE *f = fopen("/sdcard/HOF.DAT", "rb");
    if (!f) return;
    size_t n = fread(CR.hof, sizeof(colopy_hof_rec), 6, f);
    fclose(f);
    CR.n_hof = (uint8_t)n;
}

static void hof_save_sd(void) {
    if (!sd_ready || !CR.hof_dirty) return;
    CR.hof_dirty = 0;
    FILE *f = fopen("/sdcard/HOF.DAT", "wb");
    if (!f) return;
    fwrite(CR.hof, sizeof(colopy_hof_rec), CR.n_hof, f);
    fclose(f);
}

static void boot_title(void) {
    pak_load();
    if (!pak_ready) return;
    game_mode = 1;
    colopy_front_live = 1;       /* complete the dialog-gated flows
                                  * (founding, set-sail) on-board */
    colopy_ask_hook = board_ask; /* questions go to the PLAYER */
    colopy_front_seed = esp_random();  /* the DOS engine seeds from the
                                        * BIOS clock; the P4 has a TRNG */
    ui_init();                   /* SCR_TITLE */
    hof_load_sd();               /* the Hall of Fame table (HOF.DAT) */
    draw_screen();
    Serial.println("title up (touch; or l <sav> + g for a direct load)");
}

static void start_game(void) {               /* 'g': enter on a loaded save */
    if (!sav_loaded) { Serial.println("load a save first (l <file>)"); return; }
    pak_load();
    if (!pak_ready) return;
    game_mode = 1;
    colopy_front_live = 1;
    colopy_ask_hook = board_ask;
    ui_init();
    UI.screen = SCR_MAP;
    UI.nation = (int8_t)cs_nation();
    UI.difficulty = (int8_t)cs_difficulty();
    land_view();
    draw_screen();
    Serial.println("game loop on (tap the screen, or k <name> over serial)");
}

/* ---- Arduino entry points ------------------------------------------ */
void setup() {
    Serial.begin(115200);
    unsigned long t0 = millis();
    while (!Serial && millis() - t0 < 3000) {}

    /* --- Power (Elecrow Lesson07): LDO3 2.5 V for the MIPI D-PHY,
     * LDO4 3.3 V for the touch I2C pull-ups --- */
    esp_ldo_channel_handle_t ldo3_handle = NULL;
    esp_ldo_channel_config_t ldo3_cfg = {
        .chan_id = 3,
        .voltage_mv = 2500,
    };
    esp_err_t err = esp_ldo_acquire_channel(&ldo3_cfg, &ldo3_handle);
    if (err != ESP_OK)
        Serial.printf("LDO3 error: %s\n", esp_err_to_name(err));
    esp_ldo_channel_handle_t ldo4_handle = NULL;
    esp_ldo_channel_config_t ldo4_cfg = {
        .chan_id = 4,
        .voltage_mv = 3300,
    };
    err = esp_ldo_acquire_channel(&ldo4_cfg, &ldo4_handle);
    if (err != ESP_OK)
        Serial.printf("LDO4 error: %s\n", esp_err_to_name(err));

    /* --- Display + touch (ESP32_Display_Panel Board, Elecrow config) --- */
    board = new Board();
    if (!board->init()) {
        Serial.println("panel init FAILED");
        board = nullptr;
    } else if (!board->begin()) {
        Serial.println("panel begin FAILED");
        board = nullptr;
    } else {
        g_lcd = board->getLCD();
        Serial.println("panel up (EK79007 + GT911)");
    }

    /* --- PSRAM buffers (the P4NRW32 module has 32 MB) --- */
    fbuf = (uint16_t *)heap_caps_malloc((size_t)P4_W * P4_H * 2,
                                        MALLOC_CAP_SPIRAM);
    pakbuf = (uint8_t *)heap_caps_malloc(PAKBUF_CAP, MALLOC_CAP_SPIRAM);
    savbuf = (uint8_t *)heap_caps_malloc(SAVBUF_CAP, MALLOC_CAP_SPIRAM);
    sidebuf = (uint8_t *)heap_caps_malloc(SIDEBUF_CAP, MALLOC_CAP_SPIRAM);
    if (!fbuf || !pakbuf || !savbuf)
        Serial.println("PSRAM alloc FAILED (is PSRAM enabled in Tools?)");
    if (fbuf && g_lcd) {                     /* black screen + pillarbox */
        memset(fbuf, 0, (size_t)P4_W * P4_H * 2);
        g_lcd->drawBitmap(0, 0, P4_W, P4_H, (const uint8_t *)fbuf, -1);
    }

    sd_mount();

    bt_init();         /* deliberately a NO-OP: the BLE host comes up on
                        * first use, not at boot — see bt_begin() */
    Serial.println(sd_ready ? "SD up" : "SD unavailable");
    audio_init();      /* picks COLAUDIO.PAK or COLDIG.BIN, or stays mute */
    stack_report("boot");
    Serial.println("colopy shell ready (l/t/d/i/s/v/g/k)");

    if (sd_ready && fbuf && g_lcd) {
#ifdef COLOPY_AUTOBOOT
        /* skip the title: straight into the named save (banner config) */
        cmd_load(COLOPY_AUTOBOOT);
        if (sav_loaded) { start_game(); return; }
#endif
        boot_title();                /* the real boot: the main menu */
    }
}

void loop() {
    /* touch drives the pointer layer whenever the game loop is on
     * (asks pump their own touch inside board_ask): tap = click /
     * adjacent-tile move, long-press = Space (skip the active unit),
     * two-finger tap = Escape */
    bt_pump();                 /* BLE mouse (no-op unless enabled) */
    if (game_mode && !ask_active) {
#if COLOPY_AUDIO
        audio_tick();
#endif
        int gx, gy;
        int ev = touch_poll(&gx, &gy);
        if (ev == TT_ESC) game_key("Escape", 0, 0);
        else if (ev == TT_LONG) game_long(gx, gy);
        else if (ev == TT_TAP) game_tap(gx, gy);
        else if (touch_down) menu_track(touch_hx, touch_hy);
        /* animation: redraw the map when the unit blink flips; re-flush
         * (LUT only, no redraw) when the water cycle steps a phase */
        int bl = blink_now();
        /* the Declaration signature: one stroke frame per 60.8766 Hz
         * tick from the moment the page opened (func_03DA2A's per-frame
         * wait on the [0x92E8] counter, @0x3DD51..0x3DDC3); a tap jumps
         * it to the end (declaration_key) */
        static int decl_open = 0;
        static unsigned long decl_t0 = 0;
        if (UI.screen == SCR_DECLARATION) {
            if (!decl_open) { decl_open = 1; decl_t0 = millis(); }
            int total = rm_declaration_total(rm_declaration_name());
            if (UI.decl_step < total) {
                long want = (long)((millis() - decl_t0) *
                                   (RM_DECL_TICK_HZ / 1000.0));
                if (want > total) want = total;
                if ((int)want != UI.decl_step) {
                    UI.decl_step = (int16_t)want;
                    draw_screen();
                }
            }
        } else decl_open = 0;
        /* zoom >= 2 composes 16-64 subwindows per frame — too dear for
         * the 3 Hz blink; the unit stays drawn (FLAGGED perf choice) */
        if (UI.screen == SCR_MAP && UI.zoom < 2 && bl != map_blink) {
            map_blink = bl;
            draw_screen();
        } else if (cyc_wanted) {
            static int last_phase = 0;
            int ph = cyc_phase();
            if (ph != last_phase) {
                last_phase = ph;
                flush_fb();
            }
        }
    }
    static char line[64];
    static size_t len = 0;
    while (Serial.available()) {
        char c = (char)Serial.read();
        if (c != '\n' && c != '\r') {
            if (len < sizeof(line) - 1) line[len++] = c;
            continue;
        }
        line[len] = 0;
        len = 0;
        if (!line[0]) continue;
        const char *arg = line + 1;
        while (*arg == ' ') arg++;
        switch (line[0]) {
        case 'l': cmd_load(arg); break;
        case 's': cmd_save(arg); break;
        case 'w': stack_report("now"); break;
        case 'm': mem_report(); break;
        case 'd':
            Serial.printf("digest %08lX\n", (unsigned long)colopy_digest());
            break;
        case 'i': cmd_info(); break;
        case 'v': cmd_view(); break;
        case 'g': start_game(); break;
        case 'k': cmd_key(arg); break;
        case 't': {
            if (!sav_loaded && !CS.n_units) { Serial.println("no game state (l <file> or New Game)"); break; }
            int n = atoi(arg);
            if (n < 1) n = 1;
            unsigned long t0 = micros();
            for (int k = 0; k < n; k++) {
                run_turn();
                Serial.printf("turn %u digest %08lX\n",
                              (unsigned)cs_turn(),
                              (unsigned long)colopy_digest());
            }
            Serial.printf("(%lu us/turn)\n", (micros() - t0) / (unsigned long)n);
            break;
        }
        default:
            Serial.println("commands:");
            Serial.println("  l <file>  load a .SAV from the SD card");
            Serial.println("  s <file>  save the current game to the card");
            Serial.println("  g         start a new game");
            Serial.println("  t [n]     run n turns headless, digest each");
            Serial.println("  d         print the state digest");
            Serial.println("  i         one-line overview (year/units/...)");
            Serial.println("  v         render the map view");
            Serial.println("  k <key>   inject a key as if typed on the board");
            Serial.println("  w         loop-task stack high-water mark");
            Serial.println("  m         memory census (SRAM/PSRAM, measured)");
        }
    }
    delay(2);
}
