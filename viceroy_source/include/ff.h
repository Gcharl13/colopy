/* ============================================================================
 *   FF-IDs + CATEGORIES: BYTE-VERIFIED   /   effect semantics: RECONSTRUCTED
 * ----------------------------------------------------------------------------
 * The Founding-Father IDs (0..24) and the per-FF CATEGORY below are transcribed
 * byte-for-byte from COLONIZE/NAMES.TXT @FATHERS @ file 0x3047 (the canonical
 * data table the game itself parses at startup, @ref MEMORY.md
 * names_txt_authoritative). They match the byte-verified id switch in
 * src/founding_fathers/effects.c (func_03BC42 @0x03BC42) and the FF_TABLE in
 * src/founding_fathers/recruit.c one-to-one.
 *
 * The EFFECT description trailing each id is still RECONSTRUCTED (accumulated
 * playthrough knowledge); DO NOT trust those specifics (percentages, etc.) for
 * gameplay — see effects.c for the byte-verified per-id behaviour. Upgrade per
 * viceroy_source/VERIFICATION_LEDGER.md.
 * ============================================================================ */

/* ============================================================================
 * ff.h -- Founding Fathers system
 * ----------------------------------------------------------------------------
 * 25 Founding Fathers in 5 CATEGORIES (Trade, Exploration, Military, Political,
 * Religious — NAMES.TXT @FATHERS "type" column 0..4, see FF_CAT_* below). Each
 * FF gives a unique passive bonus when recruited via Liberty-Bell points.
 *
 * @ref ../../../COLONIZE/NAMES.TXT @FATHERS @ file 0x3047  -- canonical id list
 * @asm src/founding_fathers/effects.c func_03BC42 @0x03BC42  (id switch)
 * ============================================================================ */
#ifndef VICEROY_FF_H
#define VICEROY_FF_H

#include "viceroy_types.h"

/* ----------------------------------------------------------------------------
 * Founding-Father IDs == NAMES.TXT @FATHERS line index (0-based), @ file 0x3047.
 * Byte-verified order; the trailing category is the @FATHERS "type" column.
 * (Effect text after the dash is RECONSTRUCTED — see effects.c for verified.)
 * ---------------------------------------------------------------------------- */
#define FF_ADAM_SMITH              0  /* Trade       — factory production */
#define FF_JAKOB_FUGGER            1  /* Trade       — clears boycott mask (verified, effects.c) */
#define FF_PETER_MINUIT            2  /* Trade       — natives don't charge for land */
#define FF_PETER_STUYVESANT        3  /* Trade       — Custom House available */
#define FF_JAN_DE_WITT             4  /* Trade       — better European prices */
#define FF_FERDINAND_MAGELLAN      5  /* Exploration — sea-lane / ship movement */
#define FF_FRANCISCO_DE_CORONADO   6  /* Exploration — reveal all colonies (verified, effects.c) */
#define FF_HERNANDO_DE_SOTO        7  /* Exploration — Lost City Rumors / sight */
#define FF_HENRY_HUDSON            8  /* Exploration — fur trade */
#define FF_SIEUR_DE_LA_SALLE       9  /* Exploration — free Stockade at pop>=3 (verified, effects.c) */
#define FF_HERNAN_CORTES          10  /* Military    — treasure arrives untaxed */
#define FF_GEORGE_WASHINGTON      11  /* Military    — veteran promotions / +atk */
#define FF_PAUL_REVERE            12  /* Military    — colonist defends colony */
#define FF_FRANCIS_DRAKE          13  /* Military    — privateer combat bonus */
#define FF_JOHN_PAUL_JONES        14  /* Military    — free Frigate (verified, effects.c) */
#define FF_THOMAS_JEFFERSON       15  /* Political    — Liberty Bell production */
#define FF_POCAHONTAS             16  /* Political    — native alarm reset (verified, effects.c) */
#define FF_THOMAS_PAINE           17  /* Political    — bell production + tax */
#define FF_SIMON_BOLIVAR          18  /* Political    — SoL meter bump (verified, effects.c) */
#define FF_BENJAMIN_FRANKLIN      19  /* Political    — diplomacy: audience can't be refused */
#define FF_WILLIAM_BREWSTER       20  /* Religious   — upgrade dock criminals/servants (verified, effects.c) */
#define FF_WILLIAM_PENN           21  /* Religious   — Crosses production */
#define FF_JEAN_DE_BREBEUF        22  /* Religious   — set mission flag on own settlements (verified, effects.c) */
#define FF_JUAN_DE_SEPULVEDA      23  /* Religious   — natives surrender / convert easily */
#define FF_BARTOLOME_DE_LAS_CASAS 24  /* Religious   — Indian Converts -> Free Colonists (verified, effects.c) */

#define FF_COUNT                  25  /* @ref @FATHERS @ file 0x3047 (25 rows) */

/* ----------------------------------------------------------------------------
 * Founding-Father CATEGORIES — NAMES.TXT @FATHERS "type" column (0..4).
 * Index 5 (Independence) is the post-revolution pseudo-category, not a
 * recruitable FF group. Mirrors enum FfCategory in recruit.c (verified).
 * Availability is gated WITHIN a category by row order (a higher father will
 * not appear until a lower father of the SAME type has joined) — NOT by a
 * single global "age" ladder. (The earlier FF_AGE_* age model was fabricated
 * and is removed; see recruit.c ff_is_available().)
 * ---------------------------------------------------------------------------- */
#define FF_CAT_TRADE        0  /* @FATHERS type 0 (Adam Smith .. Jan de Witt) */
#define FF_CAT_EXPLORATION  1  /* @FATHERS type 1 (Magellan .. La Salle)      */
#define FF_CAT_MILITARY     2  /* @FATHERS type 2 (Cortes .. John Paul Jones) */
#define FF_CAT_POLITICAL    3  /* @FATHERS type 3 (Jefferson .. Franklin)     */
#define FF_CAT_RELIGIOUS    4  /* @FATHERS type 4 (Brewster .. Las Casas)     */
#define FF_CAT_INDEPENDENCE 5  /* @FOUNDING line 5 (non-recruit pseudo-group) */

/* ----------------------------------------------------------------------------
 * FF subsystem call map  (BYTE_VERIFIED 2026-05-30, page 0x06)
 * ----------------------------------------------------------------------------
 * Each turn:
 *   - ff_bells_tick   (func_03C322 @0x03C322, src/founding_fathers/congress.c)
 *       accrues bells into PowerRecord+0x0C (bells_toward_next) and +0x0E
 *       (per-turn); when +0x0C reaches ff_bells_required() it triggers the
 *       Continental Congress and RESETS +0x0C to 0. (Cost CURVE itself is
 *       overlay-resident/TBD — see congress.c + VERIFICATION_LEDGER.md.)
 *   - ff_congress_screen (func_03BFD2 @0x03BFD2, congress.c)
 *       builds one weighted-random candidate per category over the era-band
 *       weights and presents the "WHICHFREEDOM" election; the human's choice
 *       (or the AI pick) is staged into PowerRecord+0x12 (pending_ff).
 *
 * On acquisition (func_03BC42 @0x03BC42, src/founding_fathers/effects.c):
 *   1. ff_count++ (PowerRecord+0x14); pending_ff (PowerRecord+0x12) = 0xFFFF.
 *   2. Apply the FF's one-time effect (the per-id switch — verified in
 *      effects.c; passive FFs apply at their own subsystem tick).
 *   3. Show the FF portrait dialog ("FREEDOM" key, dgroup 0x125A; CC-NN.SS).
 *
 * The per-FF OWNED bit lives in a byte array at PowerRecord+0x07 (DGROUP
 * 0x880F), indexed by ff_id: byte = +0x07 + (ff_id>>3), bit = 1<<(ff_id&7)
 * — a full 25-bit map (NOT 16). It is set/cleared by ff_set_owned_bit
 * (func_03B900 @0x03B900, recruit.c) and queried by ff_owned (0x181F:0x07B4,
 * body overlay-resident/TBD; ff_available is its verified boolean inverse).
 */

/* CC-NN.SS sprite mapping: each FF has a portrait at CC-<n>.SS.
 * The mapping is documented in colonize_sdl/cc_unit_map.py. */

#endif /* VICEROY_FF_H */
