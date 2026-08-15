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

/* UnitRecord — stride 0x1C. docs/DATA_MODEL.md + tools/viceroy_symbols.json. */
typedef struct COLOPY_PACKED {
    uint8_t  map_x;                 /* +0x00 */
    uint8_t  map_y;                 /* +0x01 */
    uint8_t  type;                  /* +0x02 */
    uint8_t  owner_flags;           /* +0x03  low nibble = nation */
    uint8_t  flags;                 /* +0x04 */
    uint8_t  _pad_05[1];
    uint8_t  moves_remaining;       /* +0x06  in thirds */
    uint8_t  profession;            /* +0x07 */
    uint8_t  orders;                /* +0x08 */
    uint8_t  goto_x;                /* +0x09 */
    uint8_t  goto_y;                /* +0x0A */
    uint8_t  _pad_0B[1];
    uint8_t  cargo_slot_count;      /* +0x0C */
    uint8_t  cargo_kind_packed[3];  /* +0x0D */
    uint8_t  cargo_amount[6];       /* +0x10 */
    uint8_t  turns_worked;          /* +0x16 */
    uint8_t  _pad_17[1];
    uint16_t chain_prev;            /* +0x18 */
    uint16_t chain_next;            /* +0x1A */
} UnitRecord;

/* NativeSettlement — stride 0x12. */
typedef struct COLOPY_PACKED {
    uint8_t  map_x;                 /* +0x00 */
    uint8_t  map_y;                 /* +0x01 */
    uint8_t  owner_tribe;           /* +0x02 */
    uint8_t  _pad_03[3];
    uint8_t  population;            /* +0x06 */
    uint8_t  _pad_07[3];
    uint8_t  alarm[4];              /* +0x0A  per-power */
    uint8_t  mission_power;         /* +0x0E */
    uint8_t  _pad_0F[2];
    uint8_t  taught;                /* +0x11 */
} NativeSettlement;

/* PowerRecord — stride 0x13C. spec/systems/colony.md §PowerRecord (price
 * ladder byte-verified: ask func_030566, bid func_030590). */
typedef struct COLOPY_PACKED {
    uint8_t  _pad_00[0x20];
    uint8_t  boycott[4];            /* +0x20  per-good bitmask (32 bits used as 16) */
    uint8_t  _pad_24[6];
    uint32_t gold;                  /* +0x2A */
    uint8_t  _pad_2E[0x1E];
    uint8_t  price_level[16];       /* +0x4C  per-good market price index */
    uint16_t traffic[16];           /* +0x5C  per-good traffic accumulator */
    uint8_t  _pad_7C[0x13C - 0x7C];
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

#endif /* COLOPY_RECORDS_H */
