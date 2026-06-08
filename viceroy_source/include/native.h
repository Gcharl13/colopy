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
 *   STRUCT + TRIBE DATA: sourced  |  not yet decoded fields marked inline
 * ----------------------------------------------------------------------------
 * Corrected 2026-05-30. The NativeSettlement layout is BYTE_VERIFIED (see its
 * own @asm note). The tribe ids / advancement levels / settlement-name table
 * are now sourced from NAMES.TXT @TRIBES + @LEVELS (cross-checked vs the
 * colonize_sdl engine). The earlier blanket "RECONSTRUCTED — NOT BYTE-VERIFIED"
 * banner is replaced: trust the cited tribe/@LEVELS data; anything still marked
 * left unresolved/FABRICATED inline is not yet verified. (Prior fabricated tribe ordering
 * + binary nomadic/advanced model were corrected — see docs/RULINGS.md.)
 * ============================================================================ */

/* ============================================================================
 * native.h -- Native settlement / tribe state
 * ----------------------------------------------------------------------------
 * Native (American Indian) settlements are tracked in an 18-byte (0x12) stride
 * table at DGROUP:0x54EC (live-count @0x539A, max 84). The base/stride and the
 * x/y/owner/mission fields are BYTE_VERIFIED (2026-05-28); other fields not yet decoded.
 *
 * @asm 18-byte (0x12) record at DGROUP:0x54EC; verified `imul *,0x12` then
 *      `[bx+0x54EC]` at VICEROY.EXE 0x46035; 18-byte record copy at 0x46F40;
 *      count INC/DEC at 0x46E2E/0x46F5D. (The prior 200-byte/0xC8/0x9100/0x4850
 *      model was fabricated — see docs/RULINGS.md 2026-05-28.)
 * ============================================================================ */
#ifndef VICEROY_NATIVE_H
#define VICEROY_NATIVE_H

#include "viceroy_types.h"

#pragma pack(push, 1)
struct NativeSettlement {             /* 18 bytes (0x12) */
    uint8_t  x;                       /* +0x00 — map X position (BYTE_VERIFIED) */
    uint8_t  y;                       /* +0x01 — map Y position (BYTE_VERIFIED) */
    uint8_t  owner;                   /* +0x02 — owning POWER INDEX (BYTE_VERIFIED).
                                       *   = tribe_id + 4 (natives occupy power
                                       *   ids 4..11; 0..3 are the EU powers).
                                       *   func_046FC2 matches it as (tribe+4);
                                       *   func_046DE0 indexes a table by
                                       *   (owner-4).  Raw tribe id = owner - 4. */
    uint8_t  field_03;                /* +0x03 — flags; bit 0x04 = developed/visited
                                       *   modifier (test [bx+0x54EF],4 @0x046E05). not yet decoded rest */
    uint8_t  population;              /* +0x04 — population (CHIEFKILL raze input) */
    uint8_t  mission;                 /* +0x05 — mission flag (0x10 | owner_idx) (BYTE_VERIFIED) */
    uint8_t  field_06;                /* +0x06 — cleared to 0 at create (@0x046E7B); not yet decoded */
    uint8_t  field_07;                /* +0x07 — set 0xFF at create (@0x046EAE [0x54F3]); not yet decoded */
    uint8_t  field_08;                /* +0x08 — set 0xFF at create (@0x046EB2 [0x54F4]).  A
                                       *   STORES raid does `inc byte [rec+8]` (@0x05C3E1) and
                                       *   the tribe-death redistribute reads it as a byte
                                       *   (settlement.c STEP 3, [si+8]).  Exact meaning not yet decoded
                                       *   (note the 0xFF init vs inc — possibly a counter that
                                       *   is reset before use). [byte ops verified; role not yet decoded] */
    uint8_t  field_09;                /* +0x09 — set 0xFF at create (@0x046EB6 [0x54F5]); not yet decoded */
    uint16_t field_0A;                /* +0x0A — word.  A STORES raid does
                                       *   `add word [rec+0xA],0x19` (@0x05C3E4); the
                                       *   tribe-death redistribute reads it as a word
                                       *   (settlement.c STEP 3, [si+0xA]). Role not yet decoded
                                       *   [byte ops verified; semantics not yet decoded] */
    uint8_t  data_0C_11[6];           /* +0x0C..0x11 — not yet decoded layout */
};
#pragma pack(pop)

#define NATIVE_SETTLEMENT_STRIDE 0x12   /* 18 bytes; @asm imul *,0x12 @0x46035 */

/* ----------------------------------------------------------------------------
 * Owner-field <-> tribe-id helpers.  NativeSettlement.owner (+0x02) stores the
 * POWER INDEX; the eight native tribes are powers 4..11.  (BYTE_VERIFIED — see
 * src/native/tribe_query.c func_046FC2 and settlement.c func_046DE0.)
 * ---------------------------------------------------------------------------- */
#define NATIVE_POWER_BASE        4
#define TRIBE_TO_POWER(tribe)    ((tribe) + NATIVE_POWER_BASE)
#define POWER_TO_TRIBE(power)    ((power) - NATIVE_POWER_BASE)

/* ----------------------------------------------------------------------------
 * Per-pair ALARM / raid-tension accumulator — a SEPARATE word array at
 * DGROUP:0x54F6 (NOT part of the 18-byte settlement records).  Indexed
 * word[A*9 + B] (row stride 9); threshold 0x80 = "high alarm".  BYTE_VERIFIED
 * index shape + threshold at 0x04734E / 0x047487 (read, vs 0x80) and 0x05C651
 * (post-raid clear).  One axis is the raiding settlement / unit-home index, the
 * other a power index (0..8).  Stored-value units + what raises it are not yet decoded.
 * See src/native/raid.c for the full citation set.
 * ---------------------------------------------------------------------------- */
#define NATIVE_ALARM_ROW_STRIDE  9      /* @asm bx = A*9 + B before <<1 */
#define NATIVE_ALARM_THRESHOLD   0x80   /* @asm cmp word [bx+0x54F6],0x80 */

/* ----------------------------------------------------------------------------
 * Tribe ids = the line index of the 8 playable tribes in NAMES.TXT @TRIBES,
 * in file order. This id is stored in NativeSettlement.owner (+0x02).
 * @source extracted/text/NAMES_sections.json @TRIBES (cols:
 *         plural, singular, treasure_type, level(0..3), VGA_color):
 *           Incas,    Inca,     Jewelled Relics, 3, 97
 *           Aztecs,   Aztec,    Gold Bars,       2, 149
 *           Arawaks,  Arawak,   Bone Jewelry,    1, 54
 *           Iroquois, Iroquois, Wood Carvings,   1, 87
 *           Cherokee, Cherokee, Turquoise,       1, 67
 *           Apache,   Apache,   Beads,           0, 111
 *           Sioux,    Sioux,    Beads,           0, 118
 *           Tupi,     Tupi,     Gems,            0, 71
 * Cross-checked against the colonize_sdl parsed form (game_data.py TRIBE_DEFS),
 * which reads the same file.  (The earlier Aztec=0 / Inca=1 / Tupi=3 / Apache=4
 * ordering here was FABRICATED — it matched neither @TRIBES nor the engine.)
 * ---------------------------------------------------------------------------- */
#define TRIBE_INCA       0   /* Civilized   (lvl 3); treasure "Jewelled Relics"; color 97  */
#define TRIBE_AZTEC      1   /* Advanced    (lvl 2); treasure "Gold Bars";       color 149 */
#define TRIBE_ARAWAK     2   /* Agrarian    (lvl 1); treasure "Bone Jewelry";    color 54  */
#define TRIBE_IROQUOIS   3   /* Agrarian    (lvl 1); treasure "Wood Carvings";   color 87  */
#define TRIBE_CHEROKEE   4   /* Agrarian    (lvl 1); treasure "Turquoise";       color 67  */
#define TRIBE_APACHE     5   /* Semi-Nomadic(lvl 0); treasure "Beads";           color 111 */
#define TRIBE_SIOUX      6   /* Semi-Nomadic(lvl 0); treasure "Beads";           color 118 */
#define TRIBE_TUPI       7   /* Semi-Nomadic(lvl 0); treasure "Gems";            color 71  */

/* ----------------------------------------------------------------------------
 * Advancement level = NAMES.TXT @TRIBES column 4 (0..3), an index into @LEVELS.
 * @source @LEVELS (cols: advancement, settlement_singular, settlement_plural):
 *           Semi-Nomadic, Camp,    Camps
 *           Agrarian,     Village, Villages
 *           Advanced,     City,    Cities
 *           Civilized,    City,    Cities
 *           <Any>,        Capital, Capitals
 * Wealth / raze-treasure magnitude scales with THIS level (Semi-Nomadic poorest,
 * Civilized richest), NOT with the tribe id.  This is exactly why Apache/Sioux/
 * Tupi (level 0) must be far poorer than Aztec (2) and Inca (3).  There are FOUR
 * advancement tiers, not the binary "nomadic vs advanced" the old code assumed.
 * ---------------------------------------------------------------------------- */
#define TRIBE_LEVEL_SEMI_NOMADIC  0
#define TRIBE_LEVEL_AGRARIAN      1
#define TRIBE_LEVEL_ADVANCED      2
#define TRIBE_LEVEL_CIVILIZED     3

/* Settlement-name index (@LEVELS col 1/2). Camp/Village/City follow from the
 * tribe's advancement level above; Capital is the 5th @LEVELS entry ("<Any>"),
 * applied to any level's capital — it is NOT a 4th advancement tier. */
#define SETTLEMENT_CAMP     0   /* @LEVELS[0] Semi-Nomadic    */
#define SETTLEMENT_VILLAGE  1   /* @LEVELS[1] Agrarian        */
#define SETTLEMENT_CITY     2   /* @LEVELS[2] / [3] Advanced/Civilized */
#define SETTLEMENT_CAPITAL  4   /* @LEVELS[4] "<Any>" Capital */

/* ----------------------------------------------------------------------------
 * TRIBE.TXT is the "Tribe Dispersal Chart" — historical map PLACEMENT
 * coordinates per tribe for American-map generation, NOT a stats table.
 * Its actual per-tribe coordinate counts (TRIBE.TXT file order) are:
 *   Iroquois 11, Cherokee 4, Arawak 5, Inca 5, Sioux 7, Apache 7, Aztec 4, Tupi 16.
 * (The earlier "settlement counts [4,4,3,5,4,3,5,3]" and the
 * homeland_terrain / aggression / learnability / giftability fields were
 * RECONSTRUCTED guesses with no citation and are REMOVED. Any per-tribe
 * behavioural stats remain not yet decoded pending a trace of the native AI tables.)
 * ---------------------------------------------------------------------------- */

/* Native village placement function — overlay-resident; called during
 * map setup after Phase 8 of map generation. */
extern void native_settle_tribes_for_scenario(int scenario_id);

#endif /* VICEROY_NATIVE_H */
