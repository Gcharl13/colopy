/* ============================================================================
 *                  >>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<
 * ----------------------------------------------------------------------------
 * The values, formulas, and offsets in this file are reconstructed from
 * accumulated playthrough knowledge and the project's prior reverse-engineering
 * work. They have NOT been confirmed by reading bytes from VICEROY.EXE or by
 * hand-decompiling the relevant overlay function.
 *
 * DO NOT TRUST any specific number, table value, or formula in this file
 * for gameplay decisions. To upgrade an entry to BYTE_VERIFIED, follow the
 * methodology in viceroy_source/VERIFICATION_LEDGER.md.
 *
 * Status of every claim in this file: RECONSTRUCTED (until proven otherwise).
 * ============================================================================ */

/* ============================================================================
 * power.h -- PowerRecord struct (per-nation game state, 316-byte stride)
 * ----------------------------------------------------------------------------
 * Each of the 4 European nations (English, French, Spanish, Dutch) plus
 * Native tribe slots use this 316-byte record to hold their global state:
 * treasury, tax rate, founding fathers, REF strength, market state, etc.
 *
 * @ref ../../../COLONIZATION_TECHNICAL_REFERENCE.md  §2 PowerRecord
 * @asm DGROUP:0x8808 = power_table base; stride 0x13C = 316 bytes per nation
 * @evidence 18 distinct functions index by power_idx * 0x13C
 * ============================================================================ */
#ifndef VICEROY_POWER_H
#define VICEROY_POWER_H

#include "viceroy_types.h"

#pragma pack(push, 1)
struct PowerRecord {
    uint8_t  pad_00;                  /* +0x00 — not yet decoded */
    uint8_t  tax_rate;                /* +0x01 — 0..100% */

    uint8_t  pad_02_0B[10];           /* +0x02..0x0B */

    uint16_t congress_progress;       /* +0x0C — liberty bell accumulator
                                       *         for next FF recruitment */
    uint16_t liberty_bells;           /* +0x0E — per-turn production */
    uint16_t crosses;                 /* +0x10 — per-turn immigration points */

    uint8_t  pad_12_13[2];            /* +0x12..0x13 */
    uint16_t founding_fathers_count;  /* +0x14 — total FFs recruited (max 25) */

    uint8_t  pad_16_29[20];           /* +0x16..0x29 */

    uint32_t gold;                    /* +0x2A — treasury, max ~999,999 */

    uint8_t  pad_2E_43[22];           /* +0x2E..0x43 */

    /* Royal Expeditionary Force (used post-revolution) */
    uint8_t  ref_dragoons;            /* +0x44 */
    uint8_t  ref_regulars;            /* +0x45 */
    uint8_t  ref_artillery;           /* +0x46 */

    uint8_t  pad_47_4B[5];            /* +0x47..0x4B */

    /* European Market state (16 commodity slots) */
    uint8_t  market_sensitivity[16];  /* +0x4C — price volatility per good */
    int16_t  market_pool[16];         /* +0x5C — supply/demand balance */
    int32_t  market_traded_volume[16];/* +0x7C — cumulative trade volume */
    int32_t  market_eu_supply[16];    /* +0xBC — European supply levels */
    int32_t  market_base_values[16];  /* +0xFC — initial market calibration */

    /* total = 0x13C = 316 bytes */
};
#pragma pack(pop)

#define POWER_RECORD_STRIDE 0x13C
#define POWER_TABLE_BASE    0x8808   /* DGROUP-relative */

extern struct PowerRecord power[8];   /* up to 8 powers (4 European + 4 native) */

/* ----------------------------------------------------------------------------
 * Power index conventions
 * ---------------------------------------------------------------------------- */
#define POWER_ENGLAND   0
#define POWER_FRENCH    1
#define POWER_SPANISH   2
#define POWER_DUTCH     3
/* Indices 4..7: Native tribes (Aztec, Inca, Apache, Sioux, Iroquois, Cherokee,
 *                              Tupi, Arawak — 8 tribes total, but only the
 *                              "active" ones get a power slot per game) */

/* ----------------------------------------------------------------------------
 * Accessor functions
 * ---------------------------------------------------------------------------- */

/* @asm 0x87F4..0x8805  (18 bytes)  reads 32-bit word from a PowerRecord
 * @ref FUNCTIONS_INVENTORY.md "power_record_read_dword" */
uint32_t power_record_read_dword(int power_idx);

#endif /* VICEROY_POWER_H */
