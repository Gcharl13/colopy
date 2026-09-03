/* The engine's own record layouts — byte-verified, exact-size.
 *
 * These are the SAME layouts as tools/ghidra/viceroy_types.h (RECORDS table
 * in tools/ghidra/make_ghidra_scripts.py): every field offset traces to a
 * VICEROY.EXE read/write site or the .SAV cross-decode, and 17 independent
 * legacy DGROUP symbols land exactly on element-0 field boundaries (ruling
 * 2026-08-08n). Using them verbatim buys .SAV compatibility and fixed
 * memory: a save is substantially a dump of these records.
 *
 * Every struct is packed and _Static_assert-ed to its true stride, so a
 * compiler cannot silently move a field. Unmapped spans are explicit _pad
 * arrays — honest gaps, never invented names (CLAUDE.md prime directive).
 * 16-bit multi-byte fields are little-endian in the .SAV; Cortex-M7 and x86
 * hosts are both little-endian, so in-place reads are correct on both.
 */
#ifndef COLOPY_RECORDS_H
#define COLOPY_RECORDS_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

#if defined(__GNUC__)
#define COLOPY_PACKED __attribute__((packed))
#else
#error "define COLOPY_PACKED for this compiler"
#endif

/* ColonyRecord — stride 0xCA. spec/systems/save.md (SAV cross-decode,
 * 2026-08-08) + docs/DATA_MODEL.md. */
typedef struct COLOPY_PACKED {
    uint8_t  map_x;                 /* +0x00 */
    uint8_t  map_y;                 /* +0x01 */
    char     name[24];              /* +0x02 */
    uint8_t  owner_power;           /* +0x1A */
    uint8_t  _pad_1B[1];
    uint8_t  colony_flags;          /* +0x1C  b1 SoL100 b2 SoL50 b7 blink */
    uint8_t  _pad_1D[2];
    uint8_t  population;            /* +0x1F */
    uint8_t  occupation[32];        /* +0x20  per-colonist job */
    uint8_t  profession[32];        /* +0x40  per-colonist specialty */
    uint8_t  work_duration[16];     /* +0x60  4-bit pairs */
    int8_t   tiles[8];              /* +0x70  N,E,S,W,NW,NE,SE,SW */
    uint8_t  _pad_78[12];
    uint8_t  buildings[6];          /* +0x84  48-bit TIER-PACKED (17 families) */
    uint16_t custom_house_flags;    /* +0x8A */
    uint8_t  _pad_8C[6];
    uint16_t hammers;               /* +0x92 */
    uint8_t  building_in_production;/* +0x94 */
    uint8_t  warehouse_level;       /* +0x95 */
    uint8_t  _pad_96[1];
    uint8_t  depletion_counter;     /* +0x97 */
    uint16_t hammers_purchased;     /* +0x98 */
    uint16_t stock[16];             /* +0x9A */
    uint8_t  population_on_map[4];  /* +0xBA  per-power seen population */
    uint8_t  fortification_on_map[4]; /* +0xBE */
    int32_t  rebel_dividend;        /* +0xC2 */
    int32_t  rebel_divisor;         /* +0xC6 */
} ColonyRecord;

/* UnitRecord — stride 0x1C. Field-alias-confirmed offsets (UNIT_Y +0x01,
 * UNIT_TYPE +0x02, U_ORDERS +0x08, UNIT_CARGO +0x0C, U_TURN +0x16,
 * UNIT_CHAIN_* +0x18/+0x1A) plus the SAV-validated reads of the JS importer
 * (tools +0x15, profession/class +0x17 — game.js:10448/10456). Cargo
 * quantity bytes past +0x11 are NOT yet mapped (the importer treats further
 * slots as full holds) — kept as _pad, not guessed. */
typedef struct COLOPY_PACKED {
    uint8_t  map_x;                 /* +0x00 */
    uint8_t  map_y;                 /* +0x01 */
    uint8_t  type;                  /* +0x02 */
    uint8_t  owner_flags;           /* +0x03  low nibble = nation (>=4 tribe) */
    uint8_t  flags;                 /* +0x04 */
    uint8_t  _pad_05[1];
    uint8_t  home_settlement;       /* +0x06  home-settlement index (C3.9,
                                     * 2026-09-03): 0xFF none; spawn stores
                                     * the colony-at lookup @0x006DDA, colony
                                     * removal renumbers @0x02EF0A..0x02EF3B
                                     * (Europeans only, @0x02EF2E).  The
                                     * port's moves-in-thirds now live in
                                     * CR.unit_moves, off the record. */
    uint8_t  _pad_07[1];
    uint8_t  orders;                /* +0x08 */
    uint8_t  goto_x;                /* +0x09 */
    uint8_t  goto_y;                /* +0x0A */
    uint8_t  _pad_0B[1];
    uint8_t  cargo_slot_count;      /* +0x0C */
    uint8_t  cargo_kind_packed[3];  /* +0x0D  nibble per slot */
    uint8_t  cargo_amount[2];       /* +0x10  slots 0..1 (rest unmapped) */
    uint8_t  _pad_12[3];
    uint8_t  tools;                 /* +0x15 */
    uint8_t  turns_worked;          /* +0x16 */
    uint8_t  profession;            /* +0x17  @JOB row (SAV_PROFESSION) */
    uint16_t chain_prev;            /* +0x18 */
    uint16_t chain_next;            /* +0x1A */
} UnitRecord;

/* NativeSettlement — stride 0x12, per the SAV-validated JS importer
 * (game.js:10309-10321): flags +0x03 (0x04 capital, 0x08 chief-seen),
 * population +0x04, mission byte +0x05 (0xFF none; &0x0F power; 0x10
 * expert), growth +0x06, per-POWER alarm words +0x0A. (This supersedes the
 * older curated Ghidra-table guesses of population@+0x06 / mission@+0x0E,
 * which fall inside the alarm words.) owner_tribe is alias-confirmed
 * (NSET_OWN @0x54EE = +0x02); stored value = tribe + 4. */
typedef struct COLOPY_PACKED {
    uint8_t  map_x;                 /* +0x00 */
    uint8_t  map_y;                 /* +0x01 */
    uint8_t  owner_tribe;           /* +0x02  tribe id + 4 */
    uint8_t  flags;                 /* +0x03 */
    uint8_t  population;            /* +0x04 */
    uint8_t  mission;               /* +0x05 */
    uint8_t  growth;                /* +0x06 */
    uint8_t  walked_good;           /* +0x07  haggle memory (func_049600):
                                     * good id walked away on, 0xFE = the
                                     * buy-insult latch, 0xFF = none */
    uint8_t  last_bought;           /* +0x08  last good bought (0xFF none) */
    uint8_t  last_sold;             /* +0x09  last good sold to the player
                                     * (0xFF none; rum 9 never latches) */
    uint16_t alarm[4];              /* +0x0A  per power */
} NativeSettlement;

/* PowerRecord — stride 0x13C. Offsets = the SAV-validated JS importer reads
 * (game.js:10276-10296) + spec/systems/colony.md §PowerRecord (price ladder
 * byte-verified: ask func_030566, bid func_030590; traffic +0x5C). */
typedef struct COLOPY_PACKED {
    uint8_t  _pad_00[1];
    uint8_t  tax_rate;              /* +0x01 */
    uint8_t  _pad_02[5];
    uint32_t founding_fathers;      /* +0x07  bit i = fathers[i] owned */
    uint8_t  _pad_0B[1];
    uint16_t bells;                 /* +0x0C */
    uint8_t  _pad_0E[0x10];
    uint16_t artillery_bought;      /* +0x1E  price-escalation counter */
    uint16_t boycott;               /* +0x20  bit per good */
    int32_t  kings_fund;            /* +0x22 */
    uint8_t  _pad_26[4];
    int32_t  gold;                  /* +0x2A */
    uint16_t crosses_accum;         /* +0x2E  crosses toward next immigrant */
    uint16_t cross_threshold;       /* +0x30  the immigration threshold */
    uint16_t ref_strength;          /* +0x32  (docs/DATA_MODEL.md) */
    /* +0x34  the WAR-RELATION row, one byte per target: 4 powers then
     * 8 tribes (the newgame zero loop @0x7583A runs to 0xC).  Bits:
     * 0x01 resolved @0x5318F, 0x02 war @0x58A7B, 0x08 grievance
     * @0x3F0D7, 0x20 peace-pending @0x57DF0, 0x40 TREATY (SIGNTREATY
     * @0x57E91 / cleared @0x57F3C; the @TRADEATWAR gate @0x5A450),
     * 0x80 privateer attribution @0x3F0A1.  Loaded into CR.war_matrix
     * and folded back on save (B4.6, 2026-09-02). */
    uint8_t  war_rel[12];
    uint8_t  rel_timer[4];          /* +0x40  per-pair timer: 1 at signing
                                     * @0x57EC5, decremented @0x531A3 */
    uint8_t  _unk_44[4];            /* +0x44  (js-dos "REF" — TBD) */
    uint8_t  _unk_48;               /* +0x48  zeroed at newgame @0x365D9 */
    uint8_t  musket_lots;           /* +0x49  free 50-musket lots from AI
                                     * overflow @0x2E73B, spent @0x52688 */
    uint16_t horse_pool;            /* +0x4A  AI overflow horses @0x2E75C */
    uint8_t  price_level[16];       /* +0x4C  live bid prices */
    uint16_t traffic[16];           /* +0x5C  per-good traffic accumulator */
    int32_t  trade_gold[16];        /* +0x7C  F5 net trade value */
    int32_t  trade_tons[16];        /* +0xBC  F5 net trade units */
    /* +0xFC  per-good running trade total, 16 x int32.  IDENTIFIED
     * 2026-08-17 (RULINGS 2026-08-17b): the market drift pass
     * func_0305A8 reads these four records at bx = p*0x13C + i*4
     * (@0x305D8), clamps negatives to 0, and decays the global price
     * pool at globals g+0x6A toward minus their sum.  Preserved
     * verbatim by the roundtrip; the port's own market does not read
     * it yet (it is oracle-locked to the JS, which starts at zero). */
    int32_t  trade_total[16];       /* +0xFC */
} PowerRecord;

/* AIPersonality — stride 0x34; only +0x31 controller is mapped (0 = human). */
typedef struct COLOPY_PACKED {
    uint8_t  _pad_00[0x31];
    uint8_t  controller;            /* +0x31 */
    uint8_t  _pad_32[2];
} AIPersonality;

#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L
#define COLOPY_SIZE_CHECK(T, N) _Static_assert(sizeof(T) == (N), #T " stride")
#else
#define COLOPY_SIZE_CHECK(T, N) \
    typedef char colopy_size_check_##T[(sizeof(T) == (N)) ? 1 : -1]
#endif

COLOPY_SIZE_CHECK(ColonyRecord, 0xCA);
COLOPY_SIZE_CHECK(UnitRecord, 0x1C);
COLOPY_SIZE_CHECK(NativeSettlement, 0x12);
COLOPY_SIZE_CHECK(PowerRecord, 0x13C);
COLOPY_SIZE_CHECK(AIPersonality, 0x34);

/* Static pool CAPACITIES — a port memory-budget choice, NOT engine facts.
 * The .SAV header carries variable counts (nvill/nunit/ncol at header
 * +0x1A/+0x1C/+0x1E, per importSav); the engine's own DGROUP table caps are
 * not byte-verified, so these are sized generously and the loader REJECTS a
 * save that exceeds them rather than truncating silently. POWERS = 4 is an
 * engine fact (four European powers). */
#define COLOPY_MAX_COLONIES     48
#define COLOPY_MAX_UNITS        256
#define COLOPY_MAX_SETTLEMENTS  64
#define COLOPY_POWERS           4

#ifdef __cplusplus
}
#endif
#endif /* COLOPY_RECORDS_H */
