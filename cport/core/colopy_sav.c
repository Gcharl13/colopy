/* .SAV load/save — the byte-preserving codec over colopy_state.
 *
 * Layout source: the JS importer (port/src/game.js importSav, re-validated
 * against the ten shipped COLONY0#.SAV files) and the serializer's 43-block
 * order (func_0734F8 @0x073562). File order:
 *
 *   prelude(0x10) globals(0x8E) mid(0xE8)
 *   colonies(ncol*0xCA) units(nunit*0x1C) powers(0x4F0) villages(nvill*0x12)
 *   tribes(0x270) blocks11-43(727) planes(4 * w*h)
 *
 * Counts nvill/nunit/ncol live in the globals block at +0x1A/+0x1C/+0x1E.
 * Everything is copied verbatim; a save we loaded writes back byte-exactly
 * (proved by the host roundtrip test on both fixtures).
 */
#include <string.h>

#include "colopy_core.h"
#include "colopy_sim.h"
#include "colopy_state.h"

colopy_state CS;

static colopy_status g_last = COLOPY_OK;
colopy_status colopy_last_error(void) { return g_last; }

static uint16_t rd16(const uint8_t *p) { return (uint16_t)(p[0] | (p[1] << 8)); }

uint16_t cs_year(void)       { return rd16(CS.globals + 0x0A); }
uint16_t cs_season(void)     { return rd16(CS.globals + 0x0C); }
uint16_t cs_turn(void)       { return rd16(CS.globals + 0x0E); }
uint8_t  cs_nation(void)     { return (uint8_t)(rd16(CS.globals + 0x14) & 3); }
uint8_t  cs_difficulty(void) { return CS.globals[0x26]; }
uint16_t cs_tut_mask(void)   { return rd16(CS.globals + 0x06); }
uint16_t cs_wc_seen(void)    { return rd16(CS.globals + 0x8A); }
uint16_t cs_ref(int i)       { return rd16(CS.globals + 0x5A + 2 * i); }
/* Block 34 = the single byte [0x336], 564 bytes past the tribe table
 * (game.js:10257) => blocks11_43[564]. */
uint8_t  cs_colony_numbers(void) { return CS.blocks11_43[564]; }

colopy_status colopy_load_sav(const uint8_t *buf, size_t len) {
    if (len < SAV_PRELUDE + SAV_GLOBALS ||
        memcmp(buf, "COLONIZE", 8) != 0 || buf[9] != 0x1A)
        return g_last = COLOPY_ERR_BAD_SAV;
    if (rd16(buf + 0x0C) != COLOPY_MAP_W || rd16(buf + 0x0E) != COLOPY_MAP_H)
        return g_last = COLOPY_ERR_BAD_SAV;

    const uint8_t *g = buf + SAV_PRELUDE;
    uint16_t nvill = rd16(g + 0x1A);
    uint16_t nunit = rd16(g + 0x1C);
    uint16_t ncol  = rd16(g + 0x1E);
    if (ncol > COLOPY_MAX_COLONIES || nunit > COLOPY_MAX_UNITS ||
        nvill > COLOPY_MAX_SETTLEMENTS)
        return g_last = COLOPY_ERR_CAPACITY;   /* reject, never truncate */

    size_t need = (size_t)SAV_PRELUDE + SAV_GLOBALS + SAV_MID +
                  (size_t)ncol * sizeof(ColonyRecord) +
                  (size_t)nunit * sizeof(UnitRecord) +
                  SAV_POWERS +
                  (size_t)nvill * sizeof(NativeSettlement) +
                  SAV_TRIBES + SAV_BLOCKS_11_43 + 4u * COLOPY_PLANE;
    if (len < need)
        return g_last = COLOPY_ERR_BAD_SAV;
    if (len - need > SAV_TAIL_MAX)
        return g_last = COLOPY_ERR_CAPACITY;

    memset(&CS, 0, sizeof(CS));
    const uint8_t *p = buf;
    memcpy(CS.prelude, p, SAV_PRELUDE);            p += SAV_PRELUDE;
    memcpy(CS.globals, p, SAV_GLOBALS);            p += SAV_GLOBALS;
    memcpy(CS.mid, p, SAV_MID);                    p += SAV_MID;
    memcpy(CS.colonies, p, (size_t)ncol * sizeof(ColonyRecord));
    p += (size_t)ncol * sizeof(ColonyRecord);
    memcpy(CS.units, p, (size_t)nunit * sizeof(UnitRecord));
    p += (size_t)nunit * sizeof(UnitRecord);
    memcpy(CS.powers, p, SAV_POWERS);              p += SAV_POWERS;
    memcpy(CS.villages, p, (size_t)nvill * sizeof(NativeSettlement));
    p += (size_t)nvill * sizeof(NativeSettlement);
    memcpy(CS.tribes, p, SAV_TRIBES);              p += SAV_TRIBES;
    memcpy(CS.blocks11_43, p, SAV_BLOCKS_11_43);   p += SAV_BLOCKS_11_43;
    memcpy(CS.terrain, p, COLOPY_PLANE);           p += COLOPY_PLANE;
    memcpy(CS.improve, p, COLOPY_PLANE);           p += COLOPY_PLANE;
    memcpy(CS.region,  p, COLOPY_PLANE);           p += COLOPY_PLANE;
    memcpy(CS.fog,     p, COLOPY_PLANE);           p += COLOPY_PLANE;
    CS.tail_len = (uint16_t)(len - need);
    memcpy(CS.tail, p, CS.tail_len);
    CS.n_colonies = ncol;
    CS.n_units = nunit;
    CS.n_villages = nvill;
    market_reset_accum();
    return g_last = COLOPY_OK;
}

size_t colopy_save_sav(uint8_t *buf, size_t cap) {
    size_t need = (size_t)SAV_PRELUDE + SAV_GLOBALS + SAV_MID +
                  (size_t)CS.n_colonies * sizeof(ColonyRecord) +
                  (size_t)CS.n_units * sizeof(UnitRecord) +
                  SAV_POWERS +
                  (size_t)CS.n_villages * sizeof(NativeSettlement) +
                  SAV_TRIBES + SAV_BLOCKS_11_43 + 4u * COLOPY_PLANE +
                  CS.tail_len;
    if (cap < need) { g_last = COLOPY_ERR_BUFFER; return 0; }

    /* keep the header's counts honest before writing */
    CS.globals[0x1A] = (uint8_t)CS.n_villages;
    CS.globals[0x1B] = (uint8_t)(CS.n_villages >> 8);
    CS.globals[0x1C] = (uint8_t)CS.n_units;
    CS.globals[0x1D] = (uint8_t)(CS.n_units >> 8);
    CS.globals[0x1E] = (uint8_t)CS.n_colonies;
    CS.globals[0x1F] = (uint8_t)(CS.n_colonies >> 8);

    uint8_t *p = buf;
    memcpy(p, CS.prelude, SAV_PRELUDE);            p += SAV_PRELUDE;
    memcpy(p, CS.globals, SAV_GLOBALS);            p += SAV_GLOBALS;
    memcpy(p, CS.mid, SAV_MID);                    p += SAV_MID;
    memcpy(p, CS.colonies, (size_t)CS.n_colonies * sizeof(ColonyRecord));
    p += (size_t)CS.n_colonies * sizeof(ColonyRecord);
    memcpy(p, CS.units, (size_t)CS.n_units * sizeof(UnitRecord));
    p += (size_t)CS.n_units * sizeof(UnitRecord);
    memcpy(p, CS.powers, SAV_POWERS);              p += SAV_POWERS;
    memcpy(p, CS.villages, (size_t)CS.n_villages * sizeof(NativeSettlement));
    p += (size_t)CS.n_villages * sizeof(NativeSettlement);
    memcpy(p, CS.tribes, SAV_TRIBES);              p += SAV_TRIBES;
    memcpy(p, CS.blocks11_43, SAV_BLOCKS_11_43);   p += SAV_BLOCKS_11_43;
    memcpy(p, CS.terrain, COLOPY_PLANE);           p += COLOPY_PLANE;
    memcpy(p, CS.improve, COLOPY_PLANE);           p += COLOPY_PLANE;
    memcpy(p, CS.region,  COLOPY_PLANE);           p += COLOPY_PLANE;
    memcpy(p, CS.fog,     COLOPY_PLANE);           p += COLOPY_PLANE;
    memcpy(p, CS.tail, CS.tail_len);               p += CS.tail_len;
    g_last = COLOPY_OK;
    return (size_t)(p - buf);
}

/* ---- read-only views --------------------------------------------------- */
const ColonyRecord *colopy_colony(int i) {
    return (i >= 0 && i < CS.n_colonies) ? &CS.colonies[i] : 0;
}
const UnitRecord *colopy_unit(int i) {
    return (i >= 0 && i < CS.n_units) ? &CS.units[i] : 0;
}
const PowerRecord *colopy_power(int i) {
    return (i >= 0 && i < COLOPY_POWERS) ? &CS.powers[i] : 0;
}
const NativeSettlement *colopy_settlement(int i) {
    return (i >= 0 && i < CS.n_villages) ? &CS.villages[i] : 0;
}
const uint8_t *colopy_map_tiles(void) { return CS.terrain; }

void colopy_get_overview(colopy_overview *out) {
    out->turn = cs_turn();
    out->year = (int16_t)cs_year();
    out->season = (uint8_t)cs_season();
    out->human_power = cs_nation();
    out->difficulty = cs_difficulty();
    out->n_units = CS.n_units;
    out->n_colonies = CS.n_colonies;
    out->n_settlements = CS.n_villages;
    out->tax_rate = CS.powers[cs_nation()].tax_rate;
    out->declared = 0;   /* TBD: not yet mapped from the globals block */
}

/* FNV-1a over the state blocks — the parity/hardware digest. */
static uint32_t fnv(uint32_t h, const void *v, size_t n) {
    const uint8_t *b = (const uint8_t *)v;
    while (n--) { h ^= *b++; h *= 16777619u; }
    return h;
}
uint32_t colopy_digest(void) {
    uint32_t h = 2166136261u;
    h = fnv(h, CS.globals, SAV_GLOBALS);
    h = fnv(h, CS.colonies, (size_t)CS.n_colonies * sizeof(ColonyRecord));
    h = fnv(h, CS.units, (size_t)CS.n_units * sizeof(UnitRecord));
    h = fnv(h, CS.powers, sizeof(CS.powers));
    h = fnv(h, CS.villages, (size_t)CS.n_villages * sizeof(NativeSettlement));
    h = fnv(h, CS.terrain, sizeof(CS.terrain));
    h = fnv(h, CS.improve, sizeof(CS.improve));
    h = fnv(h, CS.fog, sizeof(CS.fog));
    h = fnv(h, &CS.rng, sizeof(CS.rng));
    return h;
}
