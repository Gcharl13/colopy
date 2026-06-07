/* ============================================================================
 *        >>> SUBSYSTEM DOES NOT EXIST IN VICEROY.EXE (BYTE_VERIFIED) <<<
 * ----------------------------------------------------------------------------
 * disease.c — Per-colony disease / plague random events.
 *
 * FINDING (2026-05-28): *Sid Meier's Colonization* (VICEROY.EXE) has NO
 * disease / plague subsystem.  The previous contents of this file (a
 * per-terrain `base_disease_risk_for_terrain`, a population/no-doctor risk
 * bump, and a population-loss roll) were FABRICATED.  Colonization colonies
 * lose population to STARVATION (food deficit) and to COMBAT/RAZE, never to a
 * random disease check.
 *
 * EVIDENCE (string-first, per MEMORY.md methodology):
 *   - GAME.TXT (COLONIZE/GAME.TXT) has NO disease/plague/epidemic event key.
 *     A case-insensitive scan finds exactly one "disease" hit:
 *       line 2814  "An Infectious Disease, %STRING0 Fever"
 *     which sits inside the @SCORE block (GAME.TXT 0x... near "@SCORE",
 *     lines 2813-2837).  @SCORE is the END-GAME flavor list of things named
 *     after the player based on final rating ("X Fever", "X Fly", "X Ivy",
 *     "X Rattlesnake", ... "Republic of X", "A CONTINENT! Xica").  It is pure
 *     scoring cosmetic text and has nothing to do with a colony disease
 *     mechanic.
 *   - code/VICEROY/strings.json contains NO plague / epidemic token.
 *   - No overlay function (disasm_overlay_reseg/page_*.asm) references a
 *     per-colony disease roll or a "doctor present" predicate.
 *
 * WHAT ACTUALLY REDUCES COLONY POPULATION (the real mechanics):
 *   - Starvation: food stores hit zero -> colonists starve.  Messages
 *     @FOOD1/@FOOD2/@STARVE1/@STARVE2/@VANISH (GAME.TXT 0x2976..).  This is a
 *     deterministic food-balance check in the colony turn update, not random.
 *     See src/colony/turn_update.c.
 *   - Combat losses and colony capture/burn.  See src/combat/ and
 *     src/native/.
 *
 * This file is intentionally left as a documented stub.  Do NOT re-introduce a
 * disease mechanic without a VICEROY.EXE citation; there is none to cite.
 *
 * @verified_by   String-table + GAME.TXT scan, 2026-05-28.
 * @status        BYTE_VERIFIED (absence): no disease subsystem in VICEROY.EXE.
 * ============================================================================ */
#include "viceroy_types.h"

/* No disease risk table, no disease check, no doctor predicate.
 * VICEROY.EXE has none of these.  Colony population loss is starvation and
 * combat only.  See header block for the byte evidence. */
