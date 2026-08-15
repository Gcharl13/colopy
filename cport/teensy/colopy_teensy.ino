/* Colopy on Teensy 4.1 — the Phase-4 serial digest shell.
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
 *
 * The core never does I/O (buffer-only API); this shell owns the SD
 * card and the serial port.  Build with PlatformIO (see README.md).
 */
#include <SD.h>

extern "C" {
#include "colopy_core.h"
#include "colopy_state.h"
#include "colopy_sim.h"
#ifdef COLOPY_ILI9341
#include "colopy_render.h"
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
static ILI9341_t3n tft(COLOPY_TFT_CS, COLOPY_TFT_DC);
EXTMEM static uint8_t pakbuf[3500000];      /* COLOPY.PAK, from SD */
static uint16_t lut565[256];
static int pak_ready = 0;

static void build_lut(void) {
    for (int i = 0; i < 256; i++) {
        const uint8_t *c = RD.pal + i * 3;
        lut565[i] = (uint16_t)(((c[0] & 0xF8) << 8) |
                               ((c[1] & 0xFC) << 3) | (c[2] >> 3));
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
    if (!pak_ready) {
        File f = SD.open("COLOPY.PAK", FILE_READ);
        if (!f) { Serial.println("no COLOPY.PAK on SD"); return; }
        size_t n = f.read(pakbuf, sizeof(pakbuf));
        f.close();
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
#endif /* COLOPY_ILI9341 */

/* One .SAV image is ~22-28 KB; 80 KB covers every fixture with room. */
static uint8_t savbuf[80000];

static void run_turn(void) {
    turn_step_prefix();
    turn_step2();
    turn_step3();
    turn_step5();
}

static void cmd_load(const char *name) {
    File f = SD.open(name, FILE_READ);
    if (!f) { Serial.printf("no such file: %s\n", name); return; }
    size_t n = f.read(savbuf, sizeof(savbuf));
    f.close();
    colopy_status st = colopy_load_sav(savbuf, n);
    if (st != COLOPY_OK) { Serial.printf("load failed: %d\n", (int)st); return; }
    colopy_init(1653);              /* the shared parity seed */
    for (int d = 0; d < 3; d++) roll_immigrant(&CR.dock[d]);
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
    tft.begin();
    tft.setRotation(1);                     /* 320x240 landscape */
    tft.fillScreen(ILI9341_BLACK);
    Serial.println("ILI9341 up (v = draw map view)");
#endif
}

void loop() {
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
#endif
        case 't': {
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
        default: Serial.println("commands: l <f> / t [n] / d / i / s <f>");
        }
    }
}
