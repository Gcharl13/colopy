/* ============================================================================
 *   STRUCT: PARTIALLY BYTE-VERIFIED  |  MARKET ARRAYS: RECONSTRUCTED
 * ----------------------------------------------------------------------------
 * Reconciled 2026-06-08 against docs/DGROUP_MEMORY_MAP.md §3.5. BYTE_VERIFIED
 * fields (base 0x8808, stride 0x13C): +0x01 tax_rate, +0x07 FF bitmap, +0x0C/+0x0E
 * bells, +0x12 pending-FF slot, +0x14 ff_count, +0x20 boycott mask, +0x2A gold
 * (dword), +0x32/+0x33 home x/y, +0x34 war matrix, +0x4C price levels. The table
 * is physically **4 EU records** (0x8808..0x8CF8); native "powers" 4..11 do NOT
 * own 0x13C records (their state is in the 0x54EC settlement table). The market
 * pool/volume/supply/base arrays below (+0x5C onward) are RECONSTRUCTED — widths
 * and meanings are NOT byte-confirmed; do not trust them for gameplay.
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
    uint8_t  tax_rate;                /* +0x01 — 0..100% (BYTE_VERIFIED) */

    uint8_t  pad_02_06[5];            /* +0x02..0x06 — not yet decoded */
    uint8_t  ff_owned_bitmap[5];      /* +0x07..0x0B — Founding-Fathers OWNED bitmap
                                       *   (BYTE_VERIFIED offset; 25 FFs -> 4-5 bytes.
                                       *   The acquire path sets the COUNT (+0x14) and
                                       *   pending slot (+0x12); the owned bit is set here
                                       *   by the congress-grant path. DGROUP_MEMORY_MAP §3.5) */

    uint16_t congress_progress;       /* +0x0C — liberty-bell accumulator (current) */
    uint16_t liberty_bells;           /* +0x0E — bells total/per-turn */
    uint16_t crosses;                 /* +0x10 — per-turn immigration points */

    uint16_t ff_pending_slot;         /* +0x12 — pending/last-acquired FF slot
                                       *   (set to 0xFFFF on acquire). BYTE_VERIFIED. */
    uint16_t founding_fathers_count;  /* +0x14 — total FFs recruited (max 25). BYTE_VERIFIED */

    uint8_t  pad_16_1F[10];           /* +0x16..0x1F — not yet decoded */
    uint16_t boycott_mask;            /* +0x20 — per-commodity boycott bitmap (cleared
                                       *   whole by Jakob Fugger). BYTE_VERIFIED. */
    uint8_t  pad_22_29[8];            /* +0x22..0x29 — not yet decoded */

    uint32_t gold;                    /* +0x2A — treasury (dword), max ~999,999. BYTE_VERIFIED */

    uint8_t  pad_2E_31[4];            /* +0x2E..0x31 — not yet decoded */
    uint8_t  home_x;                  /* +0x32 — home-port X (copied into new units). VERIFIED */
    uint8_t  home_y;                  /* +0x33 — home-port Y. VERIFIED */
    uint8_t  war_matrix[8];           /* +0x34 (abs 0x883C) — per-power war/relations row.
                                       *   BYTE_VERIFIED offset; width (8) is the power-count
                                       *   upper bound, not independently confirmed. */
    uint8_t  pad_3C_43[8];            /* +0x3C..0x43 — not yet decoded */

    /* Royal Expeditionary Force (used post-revolution) */
    uint8_t  ref_dragoons;            /* +0x44 */
    uint8_t  ref_regulars;            /* +0x45 */
    uint8_t  ref_artillery;           /* +0x46 */

    uint8_t  pad_47_4B[5];            /* +0x47..0x4B */

    /* European Market state (16 commodity slots). +0x4C is BYTE_VERIFIED as the
     * per-good PRICE-LEVEL array (DGROUP_MEMORY_MAP §3.5); the remaining arrays
     * below are RECONSTRUCTED — offsets fill the record to 0x13C but the widths
     * and meanings are NOT byte-confirmed. */
    uint8_t  market_sensitivity[16];  /* +0x4C — price levels per good (BYTE_VERIFIED offset) */
    int16_t  market_pool[16];         /* +0x5C — RECONSTRUCTED: supply/demand balance */
    int32_t  market_traded_volume[16];/* +0x7C — RECONSTRUCTED: cumulative trade volume */
    int32_t  market_eu_supply[16];    /* +0xBC — RECONSTRUCTED: European supply levels */
    int32_t  market_base_values[16];  /* +0xFC — RECONSTRUCTED: initial calibration */

    /* total = 0x13C = 316 bytes (layout verified consistent 2026-06-08) */
};
#pragma pack(pop)

#define POWER_RECORD_STRIDE 0x13C
#define POWER_TABLE_BASE    0x8808   /* DGROUP-relative */

/* Physically 4 EU records at DGROUP:0x8808 (0x8808..0x8CF8). The [8] is a logical
 * convenience for power-index args 0..7; native "powers" 4..11 do NOT own a full
 * 0x13C PowerRecord (their state lives in the 0x54EC NativeSettlement table). See
 * DGROUP_MEMORY_MAP §3.5 / §5.3. Do not index beyond 3 expecting real EU state. */
extern struct PowerRecord power[8];

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
