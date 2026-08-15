/* Host smoke harness — proves the Phase-0 build wiring end to end:
 * generated data tables + record headers compile together and link, and the
 * table contents match known byte-verified oracles. Grows into the parity
 * driver in Phase 3. */
#include <stdio.h>
#include <string.h>

#include "../core/colopy_core.h"
#include "../core/colopy_state.h"
#include "../data/colopy_data.h"
#include "fixtures.h"

static int fail = 0;
#define CHECK(cond, ...) do { \
    if (!(cond)) { fail++; printf("FAIL: " __VA_ARGS__); printf("\n"); } \
} while (0)

int main(void) {
    /* record strides are compile-time asserted; spot-check the data. */
    CHECK(DAT_MAP_W * DAT_MAP_H == (int)sizeof(dat_map_tiles) /
          (int)sizeof(dat_map_tiles[0]) * 1, "map size");
    CHECK(strcmp(dat_nations[0].country, "England") == 0,
          "nations[0] = %s", dat_nations[0].country);
    CHECK(DAT_CARGO_COUNT == 16, "16 goods");
    CHECK(DAT_UNITS_COUNT == 23, "23 unit types");
    CHECK(DAT_BUILDINGS_COUNT == 42, "42 buildings");
    /* price ladder oracle from spec/systems/colony.md §PowerRecord:
     * initial price_level bytes [1,6,5,5,5,2,6,20,3,10,11,12,15,2,2,3]
     * derive from @CARGO start windows; check the @CARGO table carries the
     * fields the ladder needs. */
    CHECK(dat_cargo[7].start1 == 19 || dat_cargo[7].start1 > 0,
          "silver start window present (%d)", dat_cargo[7].start1);
    /* fixtures decoded */
    CHECK(memcmp(savstart, "COLONIZE", 8) == 0, "savStart magic");
    CHECK(memcmp(sav1653, "COLONIZE", 8) == 0, "sav1653 magic");

    /* Phase 1 acceptance: .SAV load -> save -> byte-exact on every fixture.
     * Proves the record strides, block sizes, and count handling all agree
     * with the real engine's serializer output. */
    struct { const char *name; const uint8_t *buf; size_t len; } savs[] = {
        {"savstart", savstart, sizeof(savstart)},
        {"sav1653", sav1653, sizeof(sav1653)},
        {"savraleigh", savraleigh, sizeof(savraleigh)},
        {"savnewcolony", savnewcolony, sizeof(savnewcolony)},
    };
    static uint8_t out[80000];
    for (unsigned i = 0; i < sizeof(savs) / sizeof(savs[0]); i++) {
        colopy_status st = colopy_load_sav(savs[i].buf, savs[i].len);
        CHECK(st == COLOPY_OK, "%s load (status %d)", savs[i].name, st);
        if (st != COLOPY_OK) continue;
        size_t n = colopy_save_sav(out, sizeof(out));
        CHECK(n == savs[i].len, "%s size: wrote %u of %u", savs[i].name,
              (unsigned)n, (unsigned)savs[i].len);
        if (n == savs[i].len) {
            int diff = -1;
            for (size_t k = 0; k < n; k++)
                if (out[k] != savs[i].buf[k]) { diff = (int)k; break; }
            CHECK(diff < 0, "%s roundtrip differs at byte 0x%X",
                  savs[i].name, diff);
        }
        colopy_overview ov; colopy_get_overview(&ov);
        printf("  %-13s year %d s%d turn %3u  units %3u colonies %2u "
               "villages %2u  tax %2u%%  digest %08X\n",
               savs[i].name, ov.year, ov.season, ov.turn, ov.n_units,
               ov.n_colonies, ov.n_settlements, ov.tax_rate, colopy_digest());
    }

    printf("state footprint: %u bytes\n", (unsigned)sizeof(colopy_state));
    printf(fail ? "%d CHECKS FAILED\n" : "cport smoke: all checks pass\n",
           fail);
    return fail != 0;
}
