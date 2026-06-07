/* ============================================================================
 *     STRUCT LAYOUT: BYTE_VERIFIED   |   PERSONALITY WEIGHTS: RECONSTRUCTED
 * ----------------------------------------------------------------------------
 * The RECORD LAYOUT below — base DGROUP:0x540E, stride 0x34, the LEADERNAME /
 * COLONYNAME string fields, and the CONTROLLER flag at +0x31 (DGROUP:0x543F) —
 * is BYTE_VERIFIED. See docs/RULINGS.md 2026-05-29 (RESOLVED) and the @asm
 * citations on each field below (init loop @0x744FE writes +0x31=1 / +0x30=0;
 * LEADERNAME strcpy `ADD ax,0x540E` @0x74C22).
 *
 * NOT verified: the per-nation PERSONALITY WEIGHTS (the former
 * aggression/expansion/militarism values). Those were RECONSTRUCTED guesses,
 * were byte-DISPROVEN as a +0x00 interpretation, and the real weights are
 * overlay-resident / data-driven from NAMES.TXT (TBD). DO NOT TRUST any
 * specific weight, table value, or formula for AI personality. To upgrade a
 * TBD entry to BYTE_VERIFIED, follow viceroy_source/VERIFICATION_LEDGER.md.
 * ============================================================================ */

/* ============================================================================
 * ai_personality.h -- AI personality + diplomatic state (52-byte stride)
 * ----------------------------------------------------------------------------
 * Each of the 4 European nations has a record at DGROUP:0x540E + nation_idx*0x34.
 * BYTE_VERIFIED (docs/RULINGS.md 2026-05-29 RESOLVED): base 0x540E (field +0x00 =
 * LEADERNAME string, strcpy'd @0x74C22); the CONTROLLER FLAG (1=AI, 0=human, 2=dead)
 * is field +0x31 (DGROUP:0x543F) — the most-referenced field (~218 refs), which is
 * why earlier notes mislabeled 0x543F as the base. The reconstructed
 * "aggression/expansion/militarism" weights are DISPROVEN/overlay-resident (TBD).
 *
 * @asm DGROUP:0x540E = ai_table base (LEADERNAME @+0x00); stride 0x34 = 52 bytes
 * @evidence init loop @0x744FE writes +0x31=1 and +0x30=0; LEADERNAME strcpy @0x74C22 -> +0x00
 * ============================================================================ */
#ifndef VICEROY_AI_PERSONALITY_H
#define VICEROY_AI_PERSONALITY_H

#include "viceroy_types.h"

#pragma pack(push, 1)
struct AIPersonality {              /* base DGROUP:0x540E, stride 0x34 (52 bytes) */
    char     leader_name[0x18]; /* +0x00 (0x540E) — LEADERNAME str (strcpy @0x74C22) */
    char     colony_name[0x18]; /* +0x18 (0x5426) — COLONYNAME default pool (strcpy @0x74BEA) */
    uint8_t  field_30;          /* +0x30 (0x543E) — zeroed beside controller in init @0x74515 */
    uint8_t  controller_flag;   /* +0x31 (0x543F) — 1=AI, 0=human, 2=dead. ~218 refs.
                                 *   BYTE_VERIFIED (init @0x744FE/@0x23D2E). NOT "aggression". */
    uint16_t named_colony_count;/* +0x32 (0x5440) — per-power counter (func_0404B0) */
};                              /* total 0x34 = 52 bytes. The old aggression/expansion/
                                 * militarism weights were DISPROVEN (RULINGS 2026-05-28 ai). */
#pragma pack(pop)

#define AI_PERSONALITY_STRIDE 0x34
#define AI_TABLE_BASE         0x540E  /* DGROUP-relative; field +0x00 = LEADERNAME */
#define AI_CONTROLLER_OFF     0x31    /* controller flag at +0x31 (DGROUP:0x543F) */

extern struct AIPersonality ai_personality[4];

/* ----------------------------------------------------------------------------
 * Pre-defined per-nation personalities — DISPROVEN / TBD.
 * ----------------------------------------------------------------------------
 * The specific aggression/expansion/militarism values once listed here were
 * RECONSTRUCTED guesses, not byte-verified (and +0x00 is the controller flag,
 * not aggression). The real per-nation AI weights are overlay-resident and TBD
 * pending re-segmentation. See docs/RULINGS.md 2026-05-28 (ai).
 */

#endif /* VICEROY_AI_PERSONALITY_H */
