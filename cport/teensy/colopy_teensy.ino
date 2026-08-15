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
}

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
