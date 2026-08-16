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
 *   long-press      Space — skip the active unit (>= 600 ms)
 *   two-finger tap  Escape — close a menu/screen, dismiss a dialog
 * A queued notice: tap dismisses.  A question dialog: tap an option
 * row to answer it, tap outside the box to dismiss.  An amount modal:
 * tap the box = Enter (empty entry = the full amount), outside =
 * Escape (typed digits come over serial).  Every order is also in the
 * tappable ORDERS pulldown, and the reports in the menu bar.
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
#include <sdmmc_cmd.h>
#include <driver/sdmmc_host.h>

#include "esp_panel_drivers_conf.h"
#include "esp_panel_board_custom_conf.h"
#include "ESP_Panel_Library.h"

extern "C" {
#include "colopy_core.h"
#include "colopy_state.h"
#include "colopy_sim.h"
#include "colopy_render.h"
#include "colopy_input.h"
#include "colopy_data.h"
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
#define PAKBUF_CAP 3500000
#define SAVBUF_CAP 80000
static uint16_t lut565[256];
static int pak_ready = 0;
static bool sav_loaded = false;

static void build_lut(void) {
    for (int i = 0; i < 256; i++) {
        const uint8_t *c = RD.pal + i * 3;
        lut565[i] = (uint16_t)(((c[0] & 0xF8) << 8) |
                               ((c[1] & 0xFC) << 3) | (c[2] >> 3));
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
            px = pt[0].x;
            py = pt[0].y;
        }
        if (n >= 2) multi = true;
    } else if (armed && now - t_seen >= TT_RELEASE_MS) {
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
    size_t n = fread(buf, 1, cap, f);
    fclose(f);
    return n;
}

/* ---- Phase 7/8: the screens + the game loop (mirrors the Teensy
 * shell — cport/teensy/colopy_teensy.ino) ---------------------------- */
static int game_mode = 0;
static colopy_event pending_ev;
static int have_pending = 0;

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
static void dlg_subs(rm_subs *subs) {
    memset(subs, 0, sizeof(*subs));
    subs->str[0] = dat_cargo[UI.dlg_good].name;
    subs->str[1] = UI.dlg_entry;
    subs->num[0] = UI.dlg_max;
    subs->num_set[0] = 1;
}

static void draw_screen(void) {
    switch (UI.screen) {
    case SCR_TITLE: rm_draw_title(UI.menu_row); break;
    case SCR_DIFFICULTY: rm_draw_difficulty(UI.difficulty); break;
    case SCR_NATION: rm_draw_nation(UI.nation); break;
    case SCR_NAME: rm_draw_name(UI.leader); break;
    case SCR_REPORT: rm_draw_report(UI.report); break;
    case SCR_COLONY: {
        int ci = ui_colony_cs_index();
        if (ci >= 0)
            rm_draw_colony(ci, 1653u, -1, 0, UI.colony_view,
                           cs_colony_numbers());
        break;
    }
    case SCR_EUROPE:
        rm_draw_europe(UI.euro_ship, UI.euro_dock_sel, UI.euro_row,
                       UI.market_sel);
        break;
    default:                                 /* map + everything else */
        rm_draw_map(UI.view_x, UI.view_y, UI.sel, UI.show_hidden);
        if (UI.open_menu >= 0)
            rm_draw_pulldown(UI.open_menu, UI.menu_sel, UI.sel);
        break;
    }
    if (!have_pending && colopy_next_event(&pending_ev))
        have_pending = 1;
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
        rm_draw_event("HOWMUCH5", &subs, 0);
    }
    flush_fb();
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
    draw_screen();
}

/* a tap in the game loop (outside an ask) */
static void game_tap(int gx, int gy) {
    if (have_pending) {                      /* the modal swallow */
        have_pending = 0;
        draw_screen();
        return;
    }
    if (UI.dlg) {                            /* amount modal: box = Enter */
        rm_subs subs;
        dlg_subs(&subs);
        in_key(rm_event_hit("HOWMUCH5", &subs, 0, gx, gy) ? "Enter"
                                                          : "Escape", 0, 0);
        draw_screen();
        return;
    }
    /* map viewport, no menu open: a tap on a tile ADJACENT to the
     * active unit is that direction's movement key (the click layer
     * itself never moves — the DOS game moved by keys/drag).  The
     * active unit's own tile falls through to the click layer's
     * stacked-unit cycling; everything else clicks. */
    if (UI.screen == SCR_MAP && UI.open_menu < 0 && !UI.view_mode &&
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
    while (colopy_next_event(&e2))
        if (n < 8) q[n++] = e2;
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
    if (n > 0 && rm_event_exists(q[n - 1].key)) {
        int rows = rm_event_rows(q[n - 1].key);
        if (rows < 1) rows = 1;
        int sel = 0;
        for (;;) {
            rm_subs subs = { { q[n - 1].s[0], q[n - 1].s[1], 0, 0 },
                             { q[n - 1].p[0], q[n - 1].p[1], 0, 0 },
                             { 1, 1, 0, 0 } };
            rm_draw_dialog_event(q[n - 1].key, &subs, 0, sel);
            flush_fb();
            int gx, gy;
            int ev = ask_wait(&gx, &gy);
            if (ev == TT_TAP) {
                int r = rm_dialog_row_hit(q[n - 1].key, &subs, 0, gx, gy);
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

/* ---- the serial shell (mirrors the Teensy build) ------------------- */
static void run_turn(void) {
    turn_step_prefix();
    turn_step2();
    turn_step3();
    turn_step5();
}

static void cmd_load(const char *name) {
    if (!sd_ready) { Serial.println("no SD card"); return; }
    size_t n = sd_read_file(name, savbuf, SAVBUF_CAP);
    if (!n) { Serial.printf("no such file: %s\n", name); return; }
    colopy_status st = colopy_load_sav(savbuf, n);
    if (st != COLOPY_OK) { Serial.printf("load failed: %d\n", (int)st); return; }
    colopy_init(1653);              /* the shared parity seed */
    units_session_seed();           /* importer runtime setup: full moves,
                                     * orders 0 — without it the first
                                     * digest diverges from the host */
    for (int d = 0; d < 3; d++) roll_immigrant(&CR.dock[d]);
    sav_loaded = true;
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

static void cmd_view(void) {                 /* 'v': render the map view */
    if (!pak_ready) {
        if (!sd_ready) { Serial.println("no SD card"); return; }
        size_t n = sd_read_file("COLOPY.PAK", pakbuf, PAKBUF_CAP);
        if (!n) { Serial.println("no COLOPY.PAK on SD"); return; }
        if (!rd_init(pakbuf, (uint32_t)n)) {
            Serial.println("bad pak");
            return;
        }
        pak_ready = 1;
    }
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

static void start_game(void) {               /* 'g': enter the game loop */
    if (!sav_loaded) { Serial.println("load a save first (l <file>)"); return; }
    if (!pak_ready) { cmd_view(); }          /* loads the pak + first draw */
    if (!pak_ready) return;
    game_mode = 1;
    colopy_front_live = 1;       /* complete the dialog-gated flows
                                  * (founding, set-sail) on-board */
    colopy_ask_hook = board_ask; /* questions go to the PLAYER */
    ui_init();
    UI.screen = SCR_MAP;
    UI.nation = (int8_t)cs_nation();
    UI.difficulty = (int8_t)cs_difficulty();
    {   /* the importer's landing view/sel (game.js:10490) */
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
    if (!fbuf || !pakbuf || !savbuf)
        Serial.println("PSRAM alloc FAILED (is PSRAM enabled in Tools?)");
    if (fbuf && g_lcd) {                     /* black screen + pillarbox */
        memset(fbuf, 0, (size_t)P4_W * P4_H * 2);
        g_lcd->drawBitmap(0, 0, P4_W, P4_H, (const uint8_t *)fbuf, -1);
    }

    sd_mount();
    Serial.println(sd_ready ? "SD up" : "SD unavailable");
    Serial.println("colopy shell ready (l/t/d/i/s/v/g/k)");

#ifdef COLOPY_AUTOBOOT
    /* boot straight into the game on the named save (banner config) */
    if (sd_ready && fbuf && g_lcd) {
        cmd_load(COLOPY_AUTOBOOT);
        if (sav_loaded) start_game();
    }
#endif
}

void loop() {
    /* touch drives the pointer layer whenever the game loop is on
     * (asks pump their own touch inside board_ask): tap = click /
     * adjacent-tile move, long-press = Space (skip the active unit),
     * two-finger tap = Escape */
    if (game_mode && !ask_active) {
        int gx, gy;
        int ev = touch_poll(&gx, &gy);
        if (ev == TT_ESC) game_key("Escape", 0, 0);
        else if (ev == TT_LONG) game_key(" ", 0, 0);
        else if (ev == TT_TAP) game_tap(gx, gy);
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
        case 'd':
            Serial.printf("digest %08lX\n", (unsigned long)colopy_digest());
            break;
        case 'i': cmd_info(); break;
        case 'v': cmd_view(); break;
        case 'g': start_game(); break;
        case 'k': cmd_key(arg); break;
        case 't': {
            if (!sav_loaded) { Serial.println("load a save first (l <file>)"); break; }
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
            Serial.println("commands: l <f> / t [n] / d / i / s <f>"
                           " / v / g / k <key>");
        }
    }
    delay(2);
}
