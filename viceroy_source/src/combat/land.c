/* ============================================================================
 *                  >>> BYTE_VERIFIED (control flow & headline) <<<
 * ----------------------------------------------------------------------------
 * land.c -- The LAND-combat resolution path of func_05B2C2, reconstructed from
 *   VICEROY.EXE raw bytes (Wave-7).  This file decodes what happens to a LAND
 *   attacker/defender, which combat.c / combat_modifiers.c left as the open
 *   "0x5BAA3 region" question.  It does NOT re-port the ship odds roll
 *   (combat_modifiers.c) or the demotion-table values (combat_demotion_ladder.c).
 *
 * Resolver:  func_05B2C2  @asm reseg page 0x10, file 0x5B2C2..0x5BE2C (RETF chain).
 *            ENTER 0x3A,0.  Two index args + a UI flag + a target (x,y):
 *              [bp+6] = unit_a   (the unit whose ATK is rolled; the "attacker")
 *              [bp+8] = unit_b   (the unit whose DEF is rolled; the "defender";
 *                                 <0 means "no defender")
 *              [bp+0xA] = show_ui   [bp+0xC]=tgt_x   [bp+0xE]=tgt_y
 * Binary:    COLONIZE/VICEROY.EXE
 *            sha256 a17ed64c27671e5e95236e54a7ddc85803a96ba822fbed05e1dad34d3917e2e3
 *
 * EXTENT (raw-EXE arbitration, per RULINGS 2026-05-30):
 *   Verified extent 0x5B2C2..0x5BE2C (2922 bytes of body; @0x5B2C2 raw = C8 3A 00 00
 *   `enter 0x3a,0`; tail RETF chain near 0x5BE28 raw 8B 46 CC.. `mov ax,[bp-0x34]`).
 *   functions.json reports 35 bytes (first-RET truncation at the unit>=300 guard
 *   @0x5B2E4) — overruled.  page_10.asm reseg agrees on the body; raw EXE is the
 *   arbiter for every offset below.                                          [V]
 *
 * STATUS LEGEND:
 *   [V]   BYTE_VERIFIED  — traced to a cited file offset + raw bytes (verified
 *                          against the EXE image in this session).
 *   [left unresolved] NOT statically resolvable (behind an RTLink overlay thunk: the actual
 *         decision-maker for the land win/loss is a CALLER, see HEADLINE) — NOT
 *         guessed.
 *
 * ============================================================================
 * HEADLINE FINDING (byte-proven THREE independent ways)
 * ----------------------------------------------------------------------------
 * func_05B2C2 is NOT the land win/loss DECIDER.  It is the combat-CONSEQUENCE
 * APPLIER, invoked once the result is known.  LAND combat has NO ATK-vs-DEF
 * probability roll anywhere in VICEROY.EXE:
 *
 *  Proof 1 — the per-type DEF byte (0x523b) and ATK byte (0x523c) are each read
 *    EXACTLY ONCE in the entire 494,910-byte EXE, and both reads are inside the
 *    SHIP-gated odds roll:
 *        0x523b: cmp @0x5B81A (raw BF 3B 52), mov @0x5B824 (raw 87 3B 52)   [V]
 *        0x523c: mov @0x5B83D (raw 8F 3C 52)                                [V]
 *    (exhaustive byte scan of `..87 3b 52` / `bf 3b 52` / `..8f 3c 52` over the
 *     whole image => 1 hit each, all at 0x5B81x..0x5B83x).  So there is no
 *     second, "land" ATK/DEF roll reading these stats.                      [V]
 *
 *  Proof 2 — the ship gate routes ALL land attackers PAST both the roll AND the
 *    post-roll per-power compare, straight to the outcome router:
 *        @0x5B7B6  cmp byte[unit_a +0x3146], 0x0D   (raw 80 BF 46 31 0D)    [V]
 *        @0x5B7BB  jae 0x5B7C0                       (raw 73 03)            [V]
 *        @0x5B7BD  jmp 0x5BAA3                       (raw E9 E3 02)          [V]
 *    unit_a type <0x0D (every land unit) => jmp 0x5BAA3.  The only combat
 *    random_int (@0x5B849 lcall 0x181F:0x04D4, raw 9A D4 04 1F 18) and the whole
 *    strength-compare block @0x5B85B..0x5BA2D are unreachable on the land path. [V]
 *
 *  Proof 3 — the normal land combatant path reaches the outcome WITHOUT ever
 *    consulting a roll or even the [bp-0x3a] flag: a combatant unit_a
 *    ([bp-0x16]==0) versus a LAND unit_b with NO colony/fort present flows
 *        0x5B42D -> je 0x5B49E -> 0x5B4A4 jmp 0x5B58C -> 0x5B5A1 (no fort)
 *        -> 0x5B5AA  (the DEMOTE ladder, applied to unit_a) -> exit 0x5BE28.
 *    No RNG, no stat read; unit_a is simply demoted/destroyed.  This is the
 *    consequence side of a fight unit_a already LOST; the WIN was decided by the
 *    caller before func_05B2C2 was invoked.                                 [V]
 *
 * COROLLARY — Sid Meier's Colonization land combat is decided in the
 *   unit-move / attack DISPATCHER (the caller); func_05B2C2 then turns
 *   "unit_a lost / unit_b lost / unit_a captured" into demotion, destruction,
 *   capture and the on-screen message. This confirms the open hypothesis in
 *   combat_demotion_ladder.c (lines 109-111).                               [V]
 *
 *   >>> CALLER RESOLVED 2026-05-30 (overturns the earlier [left unresolved] here). <<<
 *   The decider is NOT behind a runtime wall — the RTLink cross-page call graph
 *   is statically recoverable (see docs/OVERLAY_THUNKS.md). The land-combat
 *   decider is **func_05CA7E** (file 0x05CA7E, ENTER 0xDE, overlay page 0x10) =
 *   the per-unit move/attack dispatcher, which calls the wrapper func_05BE30,
 *   which reaches this applier func_05B2C2 via trampoline 0x5E723
 *   (`EA e0 06 1f 1a` = JMPF 0x1A1F:0x06E0 = thunk @file 0x1CCD0 -> page 0x10
 *   +0x0352). func_05CA7E is itself reached by direct LCALL 0x191F:0x0A14
 *   (thunk @file 0x1C004) from the turn loops func_02D3C6 / func_03ECF0 /
 *   func_04E2D6. (The earlier "thunk @0x1BAAA = 0x110D:0xA9DA" was a wrong
 *   address: 0x1BAAA targets page 0x08 unit-state, and 0x110D is the resident
 *   loader segment, never a target.)
 *
 *   >>> LAND-ODDS FORMULA DECODED 2026-05-30 (wave-9, see src/ai/unit_ai_leaf.c). <<<
 *   It is `ATK/(ATK+DEF)` — the SAME odds form as ships — `roll =
 *   random_int(1, atk_str+def_str); win = roll<=atk_str` @0x5D188, on DERIVED
 *   strengths from per-type columns 0x5235(def)/0x5236(atk) (×8 via accessors
 *   file 0x07C2A/0x07D3E) + a modifier chain (terrain/fort [0x8D04], difficulty,
 *   SoL). The win_flag [bp-0x9c] then selects which unit is handed to func_05BE30
 *   -> this applier as the loser. (Ships roll on raw 0x523b/0x523c; land rolls on
 *   the 0x5235/0x5236-derived strengths — that stat-pair difference is why the
 *   wave-7 0x523b/0x523c scan reported "no land roll".)
 *
 * ============================================================================
 * THE LAND OUTCOME ROUTER @0x5BAA3 (where land attackers land)
 * ----------------------------------------------------------------------------
 *   @0x5BAA3  cmp word[bp-0x3a], 0   (raw 83 7E C6 00)                       [V]
 *   @0x5BAA7  jne 0x5BAAC            (raw 75 03)                             [V]
 *   @0x5BAA9  jmp 0x5BC84            (raw E9 D8 01)                          [V]
 *   [bp-0x3a] is the "unit_a is eliminated" flag (named attacker_wins in
 *   combat.c, but its semantics on the WIN branch are "remove unit_a"; see the
 *   capture/destroy below).  For a land attacker it is whatever the pre-gate
 *   convergence @0x5B7AD set (=0, raw C7 46 C6 00 00 @0x5B7AD) UNLESS the
 *   combatant path already branched into the DEMOTE ladder (Proof 3) and never
 *   reaches here at all.                                                     [V]
 *
 *   WIN branch  @0x5BAAC.. : a per-power message-table scan + capture/destroy.
 *     Scans the 0xCA-stride table @DS:0x5D48 (entry fields 0x5D46/0x5D47/0x5D60)
 *     indexed by unit_a's owner [bp-8], to pick the outcome message, then
 *       @0x5BB9E  or byte[unit_a +0x3148], 0x80   (raw 80 8F 48 31 80)       [V]
 *     i.e. it sets the 0x80 "removed/captured" bit on unit_a's UnitRecord flags
 *     and resets its counters (0x315a,0x3150,0x314c @0x5BBA5/0x5BBA9/0x5BBAD).
 *     => the [bp-0x3a]!=0 "win" really means UNIT_A is taken off the board.  [V]
 *
 *   LOSE branch @0x5BC84.. : re-tests [bp-0x3a] (raw 83 7E C6 00 @0x5BC84); if 0,
 *     falls to 0x5BC8D, which (gated by [bp-0xa], the "was-a-ship-roll" flag set
 *     only @0x5B7FE) emits the demote/destroy message for unit_a and applies the
 *     loss.  Both branches converge to the RETF chain @0x5BE28.             [V]
 *
 * ============================================================================
 * WHAT func_05B2C2 ACTUALLY DOES TO A LAND UNIT (the consequence map)
 * ----------------------------------------------------------------------------
 * Decoded from the string keys embedded in the function (file_offset = handle +
 * 0x1D9A0; each handle is a `push 0x1bXX` immediate fed to the message printer
 * lcall 0x181F:0x652).  These keys label every land outcome branch:           [V]
 *
 *   push 0x1B13 @0x5B544 -> "LOOTCAPTURE"        (treasure captured)
 *   push 0x1B1F @0x5B566 -> "WAGONCAPTURE"       (wagon train captured)
 *   push 0x1B2C @0x5B57C -> "COLONISTCAPTURE2"   (veteran-soldier->colonist take)
 *   push 0x1B3D @0x5B584 -> "COLONISTCAPTURE"    (colonist captured)
 *   push 0x1B4D @0x5B679 -> "DEMOTE"             (land unit demoted, ladder)
 *   push 0x1B54 @0x5B6E7 -> "ARTILLERY"          (artillery -> damaged artillery)
 *   push 0x1B5E @0x5B740 -> "ARTILLERY2"         (artillery destroyed)
 *   push 0x1B69 @0x5B98C -> "CARGOCAPTURE"       (ship-path cargo capture)
 *   push 0x1B76 @0x5BC79 -> "SHIPDAMAGE"         (ship-path)
 *   push 0x1B81 @0x5BD0F -> "SHIPSUNK"           (ship-path)
 *
 *   Branch routing for a LAND unit_a (combatant, [bp-0x16]==0):
 *     @0x5B58C  imul bx,[bp+8],0x1c ; defender is ship? (0x0D..0x12)
 *               jb/ja 0x5B5A1  (raw 72 .. / 77 ..)                           [V]
 *     @0x5B5A1  cmp word[bp-0x28],0   (fort/colony present flag, raw 83 7E D8 00)
 *               je 0x5B5AA  -> DEMOTE ladder (no fort)                       [V]
 *               jmp 0x5B74B (fort present, OR defender ship => other handling)[V]
 *     @0x5B5AA  the demotion ladder (combat_demotion_ladder.c): maps unit_a
 *               type 4->1->0, 7->9->0, 8->6; veteran override; else falls to
 *               @0x5B692 destroy block (ARTILLERY/ARTILLERY2, or generic kill).[V]
 *
 *   Non-combatant unit_a (type 0xA Treasure / 0 Colonist / 0xC Wagon; [bp-0x16]
 *   set =1 @0x5B331) takes the CAPTURE path @0x5B49E..0x5B561 instead of a fight:
 *     it runs colony-entry UI (lcall 0x181F:0x812 / 0x894 / 0x844) and emits the
 *     LOOTCAPTURE/WAGONCAPTURE/COLONISTCAPTURE keys.  This is the "special unit
 *     walks into / is taken at a colony" branch, gated by the capture-eligibility
 *     threshold @0x5B451 (0x5237/0x5238; see combat_modifiers.c).            [V]
 *
 * ============================================================================
 * THE STAT TABLE THE LAND PATH *DOES* READ:  0x5235 (per-type, stride 14)
 * ----------------------------------------------------------------------------
 * The land WIN branch does not read ATK/DEF (0x523b/0x523c) — it reads a
 * DIFFERENT per-type byte, 0x5235 (g_unit_stat[type*14 + 0x05]), to size the
 * spoils/strength transfer:
 *   @0x5BBD5  mov al, byte[unit_b_type*14 + 0x5235]   (raw 8A 87 35 52)      [V]
 *   @0x5BBF0  shl word[bp-4],1   if unit_b is a ship (0x0D..0x12)            [V]
 *   @0x5BC0B  mov cl, byte[unit_a_type*14 + 0x5235]   (raw 8A 8F 35 52)      [V]
 *   @0x5BC13  cmp cx,[bp-4] ; if unit_a's 0x5235 > unit_b's, store the diff
 *             into unit_a's UnitRecord +0x315a @0x5BC1D (raw 88 97 5A 31).   [V]
 * 0x5235 is the per-type column the LAND consequence uses (a "value/weight"
 * byte: doubled for ships).  Its exact @UNIT source column is a NAMES.TXT data
 * question — see the loader note below.                                  [V/RUNTIME_ONLY (data-resident)]
 *
 * ============================================================================
 * THE @UNIT COLUMN -> STAT-OFFSET MAPPING (loader @0x74EDA) — BOUNDED, [not yet decoded]
 * ----------------------------------------------------------------------------
 * The 0x5230-family table (base DGROUP:0x5230, stride 14) is filled at game
 * start by the loader near @0x74EDA..0x74F59 (each field via the NAMES.TXT field
 * reader lcall 0x1A1F:0x88A, with one 0x1A1F:0xB22 and one 0x1A1F:0xB2E).  The
 * resolver's USE-SITE offsets are byte-certain:
 *     +0x05 (0x5235) land spoils/value  [V @0x5BBD5/0x5BC0B]
 *     +0x06 (0x5236) combat-eligibility flag (!=0 => fights) [V @0x5B404/0x5B873]
 *     +0x07 (0x5237) capture/strength term  [V @0x5B471/0x5B9C9/0x5BA80]
 *     +0x08 (0x5238) capture term           [V @0x5B48F]
 *     +0x0B (0x523b) DEFENSE (ship roll only) [V @0x5B824]
 *     +0x0C (0x523c) ATTACK  (ship roll only) [V @0x5B83D]
 * The @UNIT-column -> field-offset CORRESPONDENCE could NOT be pinned to a 1:1
 * map from this image: the loader performs ~12 field reads but a raw @UNIT row
 * has only 11 comma fields, so the alignment is non-naive and the readers' exact
 * column order is needed (a NAMES.TXT/loader-data question, not in the EXE
 * image).  RUNTIME_ONLY (data-resident); the numeric stat VALUES are likewise
 * data-resident (not in the EXE).  No guess is recorded.                [RUNTIME_ONLY (data-resident)]
 *
 * ============================================================================ */
#include "viceroy_types.h"
#include "unit.h"        /* UnitRecord: base DGROUP:0x3144, stride 0x1C */

/* @UNIT per-type record, base DGROUP:0x5230 stride 14 (loader @0x74EDA).
 * LOCAL extern — not promoted to globals.h. */
extern unsigned char g_unit_stat[];      /* DGROUP:0x5230 */
#define UT_STRIDE          14
#define UT_VALUE(t)        (g_unit_stat[(t)*UT_STRIDE + 0x05])   /* 0x5235  [V] */
#define UT_COMBAT_ELIG(t)  (g_unit_stat[(t)*UT_STRIDE + 0x06])   /* 0x5236  [V] */

extern struct UnitRecord g_units[];      /* DGROUP:0x3144 stride 0x1C */
#define U(i)        (g_units[(i)])
#define U_TYPE(i)   (U(i).type)                 /* +0x02 (0x3146)  [V] */
#define U_OWNER(i)  (U(i).owner_flags & 0x0F)   /* +0x03 (0x3147)  [V] */

/* Per-power military-strength arrays — the resolver reads these ONLY in the
 * post-roll (ship-path) compare @0x5B85B..0x5BA2D, NOT on the land path.
 * Re-declared here only so this file documents that they are NOT land terms.
 * (Live use & citations are in combat_modifiers.c.)  Per-array semantics [not yet decoded]. */

/* UI/message helpers (load-image segment 0x181F; bodies behind RTLink). */
extern int  random_int(int lo, int hi);                 /* 0x181F:0x04D4 (rng.c) [V] */
extern void msg_print_key(int handle, int arg);         /* 0x181F:0x652  [V call] */

/* combat_demotion_ladder.c provides the unit_a demotion mapping. */
extern int8_t combat_demote_unit(int unit_idx, int promote_flag);  /* @0x5B5AA */

/* ----------------------------------------------------------------------------
 * combat_land_apply -- the LAND branch of func_05B2C2 (documentation mirror;
 *   the live code is inside func_05B2C2 @0x5B58C..0x5BE28).  This is the
 *   consequence applier, NOT a decider: it is reached with the win/loss already
 *   fixed (by the caller / by the [bp-0x3a] flag), and it demotes / destroys /
 *   captures unit_a and prints the outcome message.
 *
 *   There is deliberately NO `roll = random_int(1, ATK+DEF)` here for land:
 *   that roll exists ONLY for ship attackers (combat_modifiers.c, @0x5B849), and
 *   reads stats 0x523b/0x523c which are read nowhere else in the EXE.       [V]
 *
 * @asm 0x5B58C..0x5BE28                                                      [V]
 * @param unit_a       [bp+6]  the unit being resolved (its type drives ATK/value)
 * @param unit_b       [bp+8]  the opposing unit / tile occupant (<0 = none)
 * @param fort_present [bp-0x28] OR of colony/fort presence at both tiles
 * @param show_ui      [bp+0xA]
 * @return 1 (combat handled) — like the rest of func_05B2C2.
 * ---------------------------------------------------------------------------- */
int combat_land_apply(int unit_a, int unit_b, int fort_present, int show_ui)
{
    int a_type = U_TYPE(unit_a);
    int a_noncombatant = (a_type == 0xA || a_type == 0 || a_type == 0xC); /* @0x5B31D..0x5B331 [V] */

    if (a_noncombatant) {
        /* CAPTURE path @0x5B49E..0x5B561 — special unit taken / walks colony.
         * Eligibility threshold @0x5B451 (0x5237/0x5238, see combat_modifiers.c).
         * Emits LOOTCAPTURE / WAGONCAPTURE / COLONISTCAPTURE per a_type.       [V] */
        /* msg_print_key(0x1B13/0x1B1F/0x1B2C/0x1B3D, ...) @0x5B544.. */
        (void)show_ui;
        return 1;
    }

    /* combatant unit_a -------------------------------------------------------- */
    if (unit_b >= 0 && U_TYPE(unit_b) >= 0x0D && U_TYPE(unit_b) <= 0x12) {
        /* defender is a SHIP -> ship-vs-X handling @0x5B74B (other file/path) */
        return 1;                                  /* @0x5B59E jmp 0x5B74B [V] */
    }

    if (fort_present == 0) {                        /* @0x5B5A1 cmp [bp-0x28],0 [V] */
        /* No colony/fort: unit_a lost -> demote (or destroy) it. NO roll.      [V] */
        int8_t to = combat_demote_unit(unit_a, show_ui);   /* @0x5B5AA ladder; */
        if (to < 0) {
            /* @0x5B692 destroy block: ARTILLERY/ARTILLERY2 (push 0x1B54/0x1B5E)
             * or generic kill (set flags+0x04 bit 0x80 @0x5B6F6).              [V] */
        } else {
            /* @0x5B68B  mov byte[unit_a +0x3146], to ; emit DEMOTE (0x1B4D).   [V] */
        }
        return 1;
    }

    /* fort_present != 0 -> @0x5B74B (colony defense path; ship-vs-ship sub-call
     * lcall via trampoline @0x5E70F = 0x1A1F:0x6B0, behind RTLink).        [not yet decoded] */
    return 1;
}

/* ----------------------------------------------------------------------------
 * combat_outcome_router -- @0x5BAA3..0x5BC84 (documentation mirror).
 *   The single point where the [bp-0x3a] "remove unit_a" flag is dispatched.
 *   For land attackers this is reached via @0x5B7BD jmp 0x5BAA3.              [V]
 *
 *   elim != 0  -> WIN branch  @0x5BAAC : per-power message scan @DS:0x5D48
 *                 (stride 0xCA), then OR unit_a flags |= 0x80 (remove/capture)
 *                 @0x5BB9E, and transfer value via the per-type 0x5235 byte.
 *   elim == 0  -> LOSE branch @0x5BC84 -> 0x5BC8D : SHIPDAMAGE/SHIPSUNK (ship
 *                 path) or fall through to the unit_a demote/destroy already
 *                 applied; both converge to RETF @0x5BE28.
 * ---------------------------------------------------------------------------- */
int combat_outcome_router(int unit_a, int elim, int show_ui)
{
    (void)show_ui;
    if (elim != 0) {                                /* @0x5BAA3 cmp [bp-0x3a],0 [V] */
        /* WIN branch @0x5BAAC: */
        /*   scan 0xCA-stride table @0x5D48 by owner; pick message;            [V] */
        /*   U(unit_a).flags |= 0x80;  reset counters 0x315a/0x3150/0x314c;     [V] */
        /*   spoils via UT_VALUE(unit_b_type) vs UT_VALUE(unit_a_type) @0x5BBD5/0x5BC0B */
        U(unit_a).flags |= 0x80;                    /* @0x5BB9E (raw 80 8F 48 31 80) [V] */
        (void)UT_VALUE(0); (void)UT_COMBAT_ELIG(0); /* keep accessors referenced */
        return 1;
    }
    /* LOSE branch @0x5BC84 -> 0x5BC8D: demote/destroy unit_a + message.        [V] */
    return 1;
}
