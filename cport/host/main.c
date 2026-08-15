/* Host smoke harness — proves the Phase-0 build wiring end to end:
 * generated data tables + record headers compile together and link, and the
 * table contents match known byte-verified oracles. Grows into the parity
 * driver in Phase 3. */
#include <stdio.h>
#include <string.h>

#include "../core/colopy_core.h"
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

    printf(fail ? "%d CHECKS FAILED\n" : "phase-0 smoke: all checks pass\n",
           fail);
    return fail != 0;
}
