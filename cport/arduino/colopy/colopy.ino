/* ==== Arduino IDE build config (generated: tools/gen_arduino_sketch.py)
 *
 * The IDE passes no -D flags, so the switches PlatformIO's
 * platformio.ini would set live HERE.  Everything below this banner is
 * the verbatim cport/teensy/colopy_teensy.ino; the .c/.h files beside
 * it are flattened copies of cport/{core,data,render,game} -- regenerate
 * with the tool after pulling engine changes, do not edit them here.
 *
 * Display + USB-keyboard build (the game): needs the ILI9341_t3n
 * library (github.com/KurtE/ILI9341_t3n -> Sketch > Include Library >
 * Add .ZIP Library) and USBHost_t36 + SD + SPI (all ship with
 * Teensyduino).  For the serial-only digest shell, comment the first
 * two defines out -- no display library needed.
 *
 * COLOPY_PAK_FLASH compiles the ~3.1 MB asset pak INTO the 8 MB
 * program flash (colopy_pak_blob.c beside this sketch, emitted by the
 * generator) -- NO PSRAM chip needed, and the SD card only carries the
 * .SAV.  Comment it out to load COLOPY.PAK from SD into EXTMEM
 * instead, which requires the 8 MB PSRAM soldered.
 *
 * TFT pins default to CS 10 / DC 9 (MOSI 11 / MISO 12 / SCK 13 =
 * SPI0); COLOPY_TFT_RST is the module's hardware-reset line (without
 * it an ILI9341 sits on a WHITE screen ignoring commands — use 255 if
 * your module has no RST pin).  COLOPY_TFT_SPIHZ can drop the SPI
 * clock (e.g. 10000000) for long jumper wires. */
#define COLOPY_ILI9341 1
#define COLOPY_USBHOST 1
#define COLOPY_PAK_FLASH 1
#define COLOPY_TFT_RST 0

/* Colopy on Teensy 4.1 — the serial digest shell + the Phase-8 game
 * loop.
 *
 * Drives the SAME parity-verified core the host harness runs (zero JS
 * diffs over 300 full endTurn() turns x 3 fixtures): load a .SAV from
 * the built-in microSD, step whole turns, and print colopy_digest()
 * after each — the number that must match the host run turn for turn.
 *
 * Serial commands (115200 baud, newline-terminated):
 *   l <file>    load a .SAV from SD (e.g. "l COLONY00.SAV")
 *   t [n]       run n full turns (default 1), digest per turn
 *   d           print the current digest
 *   i           overview: year/season/turn, counts, tax
 *   s <file>    write the current state to SD as a .SAV
 *   v           (ILI9341) draw the map view once
 *   g           (ILI9341) enter the game loop on the loaded save —
 *               keys drive the oracle-verified in_key layer and every
 *               event redraws the current screen
 *   k <name>    inject one key by its JS name (bench path, no USB
 *               keyboard needed: "k Space", "k ArrowUp", "k F5", or a
 *               single character; "k !<c>" sends <c> with Alt held)
 *
 * With -DCOLOPY_USBHOST a USB keyboard on the Teensy 4.1 host port
 * feeds the same in_key layer directly (USBHost_t36).
 *
 * The core never does I/O (buffer-only API); this shell owns the SD
 * card, the serial port, the panel and the keyboard.  Build with
 * PlatformIO (see README.md).  The panel/keyboard paths are UNTESTED
 * ON HARDWARE — the board checklist in README.md gates that flag.
 */
#include <SD.h>

extern "C" {
#include "colopy_core.h"
#include "colopy_state.h"
#include "colopy_sim.h"
#ifdef COLOPY_ILI9341
#include "colopy_render.h"
#include "colopy_input.h"
#include "colopy_data.h"
#endif
}

/* ---- Phase 7: the ILI9341 panel (optional; -DCOLOPY_ILI9341) --------
 * Requires the 8 MB PSRAM fitted (COLOPY.PAK is ~3 MB and lives in
 * EXTMEM) and an ILI9341 on SPI with the ILI9341_t3n library.  The fb
 * is the render core's 8-bit 320x240 plane; the flush walks it through
 * a 256-entry RGB565 LUT built from the active palette and DMA-writes
 * one row at a time.  VGA colour cycling maps to LUT rotation over the
 * CYCLE band (start/len/delay from the pak) — the DOS DAC model, no
 * pixel rewrites.  UNTESTED ON HARDWARE: this container follows the
 * board checklist in README.md; flag stays until a live panel run. */
#ifdef COLOPY_ILI9341
#include <ILI9341_t3n.h>
#ifndef COLOPY_TFT_CS
#define COLOPY_TFT_CS 10
#endif
#ifndef COLOPY_TFT_DC
#define COLOPY_TFT_DC 9
#endif
/* the module's hardware-reset line: without it the panel powers up
 * uninitialized and shows a white screen while ignoring every command.
 * 255 = not wired (the library then relies on the software reset). */
#ifndef COLOPY_TFT_RST
#define COLOPY_TFT_RST 255
#endif
/* SPI clock: 30 MHz is the library default; drop it (e.g. 10000000)
 * for long jumper wires or a misbehaving panel. */
#ifndef COLOPY_TFT_SPIHZ
#define COLOPY_TFT_SPIHZ 30000000
#endif
static ILI9341_t3n tft(COLOPY_TFT_CS, COLOPY_TFT_DC, COLOPY_TFT_RST);
/* Two ways to hold the ~3.1 MB pak:
 *   -DCOLOPY_PAK_FLASH  the pak is COMPILED IN as a const blob
 *                       (tools/gen_arduino_sketch.py emits
 *                       colopy_pak_blob.c from cport/pak/COLOPY.PAK) —
 *                       served straight from the 8 MB program flash,
 *                       read-only and alignment-safe (the pak parser
 *                       composes u16s from bytes).  No PSRAM, no
 *                       COLOPY.PAK on SD.
 *   (default)           loaded from SD into EXTMEM — needs the 8 MB
 *                       PSRAM soldered. */
#ifdef COLOPY_PAK_FLASH
extern const uint8_t colopy_pak_blob[];
extern const uint32_t colopy_pak_blob_len;
#else
EXTMEM static uint8_t pakbuf[3500000];      /* COLOPY.PAK, from SD */
#endif
static uint16_t lut565[256];
static int pak_ready = 0;

/* VGA colour cycling (the water animation): the pak's CYCLE entry
 * (u16 start/len/delay) — each step moves every colour one index UP
 * with wrap, so palette index start+k shows the colour authored at
 * start+(k-phase) (game.js:149-165); the step clock is the engine's
 * 60.8766 Hz timer (game.js:11484).  Pure LUT work — a re-flush alone
 * animates the sea. */
static int cyc_start = 0, cyc_len = 0;
static uint32_t cyc_step_ms = 0;
/* The rotation is only meaningful over the MASTER map palette — a PIK
 * screen loads its own palette and rotating its band indices corrupts
 * its colours.  Whoever paints the fb last sets this. */
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
static void flush_fb(void) {
    static uint16_t row[RD_W];
    build_lut();                             /* palette may have changed */
    for (int y = 0; y < RD_H; y++) {
        const uint8_t *src = RD.fb + y * RD_W;
        for (int x = 0; x < RD_W; x++) row[x] = lut565[src[x]];
        tft.writeRect(0, y, RD_W, 1, row);
    }
}
static void cmd_view(void) {                 /* 'v': render the map view */
    cyc_wanted = 1;                          /* the map palette is up */
    if (!pak_ready) {
#ifdef COLOPY_PAK_FLASH
        if (!rd_init(colopy_pak_blob, colopy_pak_blob_len)) {
            Serial.println("bad flash pak");
            return;
        }
#else
        File f = SD.open("COLOPY.PAK", FILE_READ);
        if (!f) { Serial.println("no COLOPY.PAK on SD"); return; }
        size_t n = f.read(pakbuf, sizeof(pakbuf));
        f.close();
        if (!rd_init(pakbuf, (uint32_t)n)) {
            Serial.println("bad pak");
            return;
        }
#endif
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
/* ---- Phase 8: the game loop --------------------------------------
 * UI.screen drives the Phase-7 renderer; the pending game event (the
 * JS G.eventQueue head) overlays as a popup and swallows the next key
 * (the modal rule, game.js:12403).  Every consumed key redraws. */
static int game_mode = 0;
static colopy_event pending_ev;
static int have_pending = 0;
/* the active unit's blink: DRAWN while truthy, hidden on the off half
 * — the JS ticks G.blink = (tick % 32) < 20 at 60 fps (game.js:12690),
 * i.e. on ~333 ms / off ~200 ms */
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

static void draw_screen(void) {
    /* sea animation only where the master map palette is on screen */
    cyc_wanted = (UI.screen == SCR_MAP || UI.screen == SCR_VILLAGE ||
                  UI.screen == SCR_OPTIONS);
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
    case SCR_WOODCUT:
        rm_draw_woodcut(UI.woodcut);
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
    case SCR_VILLAGE:
        rm_draw_map(UI.view_x, UI.view_y, UI.sel, 1);
        rm_draw_village(UI.village_row);
        break;
    default:                                 /* map + everything else */
        /* 4th arg = the BLINK flag (unit drawn while truthy), NOT
         * show_hidden — passing 0 there kept the active unit hidden */
        rm_draw_map_zoom(UI.view_x, UI.view_y, UI.sel, map_blink,
                         UI.zoom);
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
        rm_subs subs = { { dat_cargo[UI.dlg_good].name, UI.dlg_entry, 0, 0 },
                         { UI.dlg_max, 0, 0, 0 },
                         { 1, 0, 0, 0 } };
        rm_draw_event(UI.dlg == 4 ? "RENAMECOLONY" : "HOWMUCH5",
                      &subs, 0);
    }
    flush_fb();
}

/* ---- the player-answer layer (colopy_ask_hook) -------------------
 * While board_ask blocks inside the core, keys must reach ITS loop,
 * not the dispatcher: game_key captures into ask_key instead. */
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
    if (UI.request) {                        /* Save/Load menu rows: on
                                              * this shell the serial
                                              * commands own the disk */
        Serial.println(UI.request == 'S' ? "save: use `s <file>` over serial"
                                         : "load: use `l <file>` over serial");
        UI.request = 0;
    }
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

#ifdef COLOPY_USBHOST
/* USB keyboard -> the same in_key names the JS dispatcher uses.
 * HID usage ids per the USB HUT; printable keys via getKey(). */
#include <USBHost_t36.h>
static USBHost usbh;
static USBHub hub1(usbh);
static KeyboardController usbkb(usbh);
static void usb_key_press(int unicode) {
    if (!game_mode) return;
    int oem = usbkb.getOemKey();
    int mods = usbkb.getModifiers();
    int alt = (mods & 0x44) != 0;
    int shift = (mods & 0x22) != 0;
    const char *name = 0;
    char one[2] = { 0, 0 };
    switch (oem) {
    case 0x28: name = "Enter"; break;
    case 0x29: name = "Escape"; break;
    case 0x2A: name = "Backspace"; break;
    case 0x2B: name = "Tab"; break;
    case 0x2C: name = " "; break;
    case 0x4F: name = "ArrowRight"; break;
    case 0x50: name = "ArrowLeft"; break;
    case 0x51: name = "ArrowDown"; break;
    case 0x52: name = "ArrowUp"; break;
    default:
        if (oem >= 0x3A && oem <= 0x45) {    /* F1..F12 */
            static char fbuf[4];
            snprintf(fbuf, sizeof(fbuf), "F%d", oem - 0x39);
            name = fbuf;
        } else if (unicode >= 32 && unicode < 127) {
            one[0] = (char)unicode;
            name = one;
        }
        break;
    }
    if (name) game_key(name, alt, shift);
}
#endif /* COLOPY_USBHOST */

/* the blocking answer pump: USB keys arrive via usb_key_press ->
 * game_key (captured while ask_active); serial accepts the same
 * "k <name>" bench lines */
static const char *ask_wait_key(void) {
    static char line[96];
    int len = 0;
    ask_key[0] = 0;
    for (;;) {
#ifdef COLOPY_USBHOST
        usbh.Task();
#endif
        if (ask_key[0]) return ask_key;
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
                    return ask_key;
                }
            } else if (len < 94) {
                line[len++] = ch;
            }
        }
    }
}

/* colopy_ask_hook: the core emits the question's prompt event, then
 * calls this.  Earlier queued notices show as plain popups (any key
 * dismisses); the prompt draws through the dialog framework with its
 * GAME.TXT tail rows as options — arrows pick, Enter/space answers,
 * Escape dismisses (-1, the JS closeDialog(-1) reading). */
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
        ask_wait_key();
    }
    int ret = 0;
    /* runtime option rows (the JS askEvent rows argument) on the
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
        int sel = 0;
        for (;;) {
            rm_subs subs = { { q[n - 1].s[0], q[n - 1].s[1], 0, 0 },
                             { q[n - 1].p[0], q[n - 1].p[1], 0, 0 },
                             { 1, 1, 0, 0 } };
            if (nrr > 0)
                rm_draw_dialog_rows(q[n - 1].key, &subs, 0, sel, rp, nrr);
            else
                rm_draw_dialog_event(q[n - 1].key, &subs, 0, sel);
            flush_fb();
            const char *k = ask_wait_key();
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

#endif /* COLOPY_ILI9341 */

/* One .SAV image is ~22-28 KB; 80 KB covers every fixture with room. */
/* RAM2/OCRAM — RAM1 must keep room for the ITCM code copy (see the
 * rd_state RD placement note in colopy_render.c) */
DMAMEM static uint8_t savbuf[80000];

static void run_turn(void) {
    turn_step_prefix();
    turn_step2();
    turn_step3();
    turn_step5();
}

static bool sav_loaded = false;

static void cmd_load(const char *name) {
    File f = SD.open(name, FILE_READ);
    if (!f) { Serial.printf("no such file: %s\n", name); return; }
    size_t n = f.read(savbuf, sizeof(savbuf));
    f.close();
    colopy_status st = colopy_load_sav(savbuf, n);
    if (st != COLOPY_OK) { Serial.printf("load failed: %d\n", (int)st); return; }
    colopy_init(1653);              /* the shared parity seed */
    units_session_seed();           /* importer runtime setup: full moves,
                                     * orders 0 — the host entries do the
                                     * same after init; without it the
                                     * first digest diverges */
    for (int d = 0; d < 3; d++) roll_immigrant(&CR.dock[d]);
    sav_loaded = true;
    Serial.printf("loaded %u bytes, digest %08lX\n", (unsigned)n,
                  (unsigned long)colopy_digest());
}

static void cmd_save(const char *name) {
    size_t n = colopy_save_sav(savbuf, sizeof(savbuf));
    if (!n) { Serial.println("save failed"); return; }
    SD.remove(name);
    File f = SD.open(name, FILE_WRITE);
    if (!f || f.write(savbuf, n) != n) { Serial.println("SD write failed"); return; }
    f.close();
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

void setup() {
    Serial.begin(115200);
    while (!Serial && millis() < 4000) {}
    if (!SD.begin(BUILTIN_SDCARD)) Serial.println("SD init FAILED");
    else Serial.println("colopy shell ready (l/t/d/i/s)");
#ifdef COLOPY_ILI9341
    tft.begin(COLOPY_TFT_SPIHZ);
    tft.setRotation(1);                     /* 320x240 landscape */
    tft.fillScreen(ILI9341_BLACK);
    Serial.println("ILI9341 up (v = map view, g = game loop)");
#ifdef COLOPY_USBHOST
    usbh.begin();
    usbkb.attachPress(usb_key_press);
    Serial.println("USB host keyboard attached");
#endif
#endif
}

void loop() {
#if defined(COLOPY_ILI9341) && defined(COLOPY_USBHOST)
    usbh.Task();
#endif
#ifdef COLOPY_ILI9341
    /* animation: redraw the map when the unit blink flips; re-flush
     * (LUT only) when the water cycle steps a phase */
    if (game_mode && !ask_active) {
        int bl = blink_now();
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
#endif
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
#ifdef COLOPY_ILI9341
        case 'v': cmd_view(); break;
        case 'g':
            if (!sav_loaded) { Serial.println("load a save first (l <file>)"); break; }
            if (!pak_ready) { cmd_view(); }  /* loads the pak + first draw */
            if (!pak_ready) break;
            game_mode = 1;
            colopy_front_live = 1;   /* complete the dialog-gated flows
                                      * (founding, set-sail) on-board */
            colopy_ask_hook = board_ask;  /* questions go to the PLAYER */
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
                        if ((CS.colonies[q].owner_power & 3) ==
                            cs_nation()) {
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
            Serial.println("game loop on (keys via USB keyboard or k <name>)");
            break;
        case 'k': cmd_key(arg); break;
#endif
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
#ifdef COLOPY_ILI9341
                           " / v / g / k <key>"
#endif
                           );
        }
    }
}
