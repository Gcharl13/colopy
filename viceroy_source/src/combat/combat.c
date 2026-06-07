/* ============================================================================
 *                       >>> BYTE_VERIFIED (structure & roll) <<<
 * ----------------------------------------------------------------------------
 * combat.c -- Combat resolution, reconstructed from VICEROY.EXE bytes.
 *
 * Resolver:  func_05B2C2  @asm file 0x5B2C2..0x5BE30  (2926 bytes, overlay, RETF)
 * Binary:    COLONIZE/VICEROY.EXE   (disasm verified with capstone CS_MODE_16;
 *            the per-function split file func_05B2C2_unknown.asm is truncated to
 *            35 bytes at the first early return — the real body is 2926 bytes,
 *            ending where functions.json's next entry 0x5BE84 begins.)
 *
 * This SUPERSEDES src/combat/resolve.c, which was RECONSTRUCTED (NOT verified)
 * and is wrong on: the RNG call form, the strength modifiers, the stat-table
 * shape, and the unit-type enum.  See docs/RULINGS.md 2026-05-28 (combat).
 *
 * SCOPE CLARIFICATION (2026-05-30, RULINGS wave-6/7/9/10):
 * func_05B2C2 is the combat-CONSEQUENCE applier, not the win/loss decider.
 * The ATK/(ATK+DEF) odds roll @0x5B819 below fires ONLY for SHIP attackers
 * (type 0x0D..0x12; gate @0x5B7B6 routes land attackers to 0x5BAA3) and rolls on
 * the RAW per-type stats 0x523b(DEF)/0x523c(ATK).
 *   LAND combat ALSO uses ATK/(ATK+DEF) — RESOLVED wave-9 (see src/ai/unit_ai_leaf.c
 *   func_05CA7E @0x5D188): `roll=random_int(1,atk_str+def_str); win=roll<=atk_str`,
 *   but on DERIVED strengths from a DIFFERENT stat pair, columns 0x5235(def)/
 *   0x5236(atk), read via accessors (file 0x07C2A/0x07D3E) — which is why the
 *   wave-7 scan, scoped to 0x523b/0x523c, reported "no land roll". func_05CA7E
 *   (the per-unit dispatcher) is the decider; it computes win_flag, then this
 *   func_05B2C2 applies the pre-decided result (demote/destroy/capture/spoils).
 * @UNIT column -> stat-offset mapping RESOLVED wave-10 (loader @0x74EC3, see
 *   docs/COMBAT_STATS.md): col3 ATTACK -> 0x5236, col4 combat/DEFENSE -> 0x5235
 *   (LAND); col9 guns -> 0x523b, col10 hull -> 0x523c (SHIP). The use-site OFFSET
 *   roles below are byte-certain; the earlier "@UNIT col3/col4 -> 0x523b/0x523c"
 *   LABEL was wrong (those are the ship guns/hull columns).
 *
 * STATUS PER ITEM:
 *   [V]   BYTE_VERIFIED  — traced to a cited file offset + instruction.
 *   [TBD] NOT verifiable from the static EXE (data-driven NAMES.TXT, or behind
 *         an unresolved RTLink overlay thunk).  NOT guessed.
 * ============================================================================ */
#include "viceroy_types.h"
#include "unit.h"        /* UnitRecord: base DGROUP:0x3144, stride 0x1C        */

/* --- RNG (rng.c): rand() @0x103D4, random_int @0xC322 (inclusive range).
 * Reached from this overlay via LCALL 0x181F:0x04D4.                    [V] */
extern int random_int(int lo, int hi);     /* returns r in [lo, hi]         */

/* --- Unit-type stat table -------------------------------------------------
 * @asm base DGROUP:0x5230, stride 14 (0xE); indexed by unit type (@UNIT order).
 *   +0x06 (0x5236): combat-eligibility flag (!=0 => fights)  [V] @0x5B404
 *   +0x07 (0x5237): military weight (post-combat bookkeeping) [V] @0x5BA80
 *   +0x0B (0x523B): DEFENSE stat                             [V] @0x5B823
 *   +0x0C (0x523C): ATTACK  stat                             [V] @0x5B83B
 * The NUMERIC stat values are loaded at game start from NAMES.TXT @UNIT
 * (col 3 = attack, col 4 = defense); they are NOT in the EXE image. [TBD vals] */
#define UTYPE_STRIDE       14
extern unsigned char g_unit_stat[/* type*14 + field */];   /* DGROUP:0x5230 */
#define UNIT_ATTACK(t)     (g_unit_stat[(t)*UTYPE_STRIDE + 0x0C])   /* [V] */
#define UNIT_DEFENSE(t)    (g_unit_stat[(t)*UTYPE_STRIDE + 0x0B])   /* [V] */
#define UNIT_IS_COMBAT(t)  (g_unit_stat[(t)*UTYPE_STRIDE + 0x06])   /* [V] */

/* UnitRecord accessors (base 0x3144, stride 0x1C — see unit.h / RULINGS). */
extern struct UnitRecord g_units[];          /* DGROUP:0x3144 */
#define U(i)        (g_units[(i)])
#define U_TYPE(i)   (U(i).type)               /* +0x02 (0x3146)  [V] @0x5B310 */
#define U_OWNER(i)  (U(i).owner_flags & 0x0F) /* +0x03 (0x3147)  [V] @0x5B306 */

/* --- Overlay helpers (RTLink thunks; internals behind 0x110D:0xD91). [TBD] */
extern int  ovl_fortify_accum(int x, int y);   /* 0x181F:0x768  fort/colony path */

#define COMBAT_DEFENDER_WINS 0
#define COMBAT_ATTACKER_WINS 1

/* ============================================================================
 * combat_resolve  --  @asm func_05B2C2 @ file 0x5B2C2
 *   attacker_idx [bp+6], defender_idx [bp+8], show_ui [bp+0xA],
 *   tgt_x [bp+0xC], tgt_y [bp+0xE].   Far function; returns 1 = combat handled.
 *
 * Core decision (the heart, @asm 0x5B819..0x5B856):
 *     roll = random_int(1, ATK + DEF);          // inclusive  @0x5B849
 *     attacker_wins = (roll <= ATK);            //            @0x5B851/0x5B854
 *   => P(attacker wins) = ATK / (ATK + DEF).  Single roll, no HP rounds.
 *   ATK/DEF are the RAW per-type bytes from g_unit_stat; NO terrain/fortified/
 *   SoL/FoundingFather multiplier scales them inside this function.        [V]
 * ============================================================================ */
int combat_resolve(int attacker_idx, int defender_idx,
                   int show_ui, int tgt_x, int tgt_y)
{
    int atk_owner, def_owner, atk_type, def_type;
    int fort_path  = 0;     /* [bp-0x28] colony/fort presence selector  [V]   */
    int attacker_wins = 1;  /* [bp-0x3A] pre-set 1  @asm 0x5B7FB         [V]   */
    int atk_str, def_str, total, roll;

    /* --- sanity / early outs --------------------------------------- [V] --- */
    if (attacker_idx >= 300) return COMBAT_DEFENDER_WINS;   /* @0x5B2D8 */
    atk_owner = U_OWNER(attacker_idx);                      /* @0x5B2EA */
    if (defender_idx < 0) {                                 /* @0x5B2F4 */
        attacker_wins = 1;            /* no defender => auto-win @0x5BA5D */
        goto apply_outcome;
    }
    def_owner = U_OWNER(defender_idx);                      /* @0x5B306 */
    def_type  = U_TYPE(defender_idx);                       /* @0x5B310 */
    atk_type  = U_TYPE(attacker_idx);
    (void)def_owner; (void)show_ui; (void)tgt_x; (void)tgt_y;

    /* attacker non-combatant (Colonist 0 / Treasure 0xA / Wagon 0xC) handled
     * on a separate path.  @asm 0x5B319..0x5B338                              */

    /* --- defensive-structure accumulator (colony/fort presence) ----- [V] --
     * fort_path (LOCAL [bp-0x28]) = OR of ovl_fortify_accum (LCALL 0x181F:0x768)
     * for defender(x,y) @0x5B367 and attacker(x,y) @0x5B394, each gated by helper
     * 0x181F:0x302 (@0x5B355 / @0x5B378). Accumulated via `OR [bp-0x28],ax`
     * @0x5B36F / @0x5B39C.
     * VERIFIED 2026-05-30 (page_10.asm): fort_path is a ROUTING FLAG, NOT a stat
     * scaler. It is consumed ONLY by `CMP word [bp-0x28],0` branches @0x5B422 /
     * @0x5B445 / @0x5B54F / @0x5B5A1, and the core odds roll @0x5B819 reads the
     * RAW def byte (0x523B) + atk byte (0x523C) with NO fort term added
     * (@0x5B844 `ADD ax,cx` = def+atk only). So the resolver applies no
     * terrain/fortify multiplier to ATK/DEF.
     * Fort-flag routing target — RESOLVED 2026-05-30 (raw-EXE trace, see the
     * COMBAT MODIFIERS block below). The first branch (@0x5B414/0x5B41B) excludes
     * SHIPS (defender 0x0D..0x12); the block @0x5B433 re-checks the tile
     * (0x181F:0x302) and fort_path, and on [bp-2]==0x0F @0x5B44B runs a defender
     * THRESHOLD test using the per-unit-type tables 0x5237/0x5238 — it is an
     * eligibility gate that sets [bp-0x24], NOT a multiplier on ATK/DEF. The
     * exact comparison is byte-verified below.                                  */
    fort_path |= ovl_fortify_accum(U(defender_idx).map_x, U(defender_idx).map_y);
    fort_path |= ovl_fortify_accum(U(attacker_idx).map_x, U(attacker_idx).map_y);
    (void)fort_path;

    /* --- ambush / first-strike 50% coin --------------------------- [V] ----
     * @asm 0x5B39F..0x5B3BE: only if attacker owner >= 4 (a European power)
     * and (UnitRecord.flags & 0x10) == 0.  On success, native-war counters at
     * [owner*0x4E + 0x59A5]/+0x59A8 are bumped (@0x5B3D2/0x5B3F0).            */
    if (atk_owner >= 4 && !(U(attacker_idx).flags & 0x10)) {
        if (random_int(0, 1) == 0) {       /* @0x5B3B4 */
            /* no ambush this turn */
        }
    }

    /* ====================================================================
     *  CORE ODDS ROLL  -- @asm 0x5B819..0x5B856                          [V]
     * ==================================================================== */
    def_str = UNIT_DEFENSE(def_type);          /* @0x5B823 (0x523B) */
    if (def_str == 0) goto skip_combat;        /* @0x5B819 def DEF==0 -> skip */
    atk_str = UNIT_ATTACK(atk_type);           /* @0x5B83B (0x523C) */
    total   = def_str + atk_str;               /* @0x5B844 */

    roll = random_int(1, total);               /* @0x5B849  LCALL 0x181F:0x04D4 */
    attacker_wins = (roll <= atk_str);         /* @0x5B851/0x5B854 (win iff roll<=ATK) */

apply_outcome:
    if (defender_idx < 0) attacker_wins = 1;   /* @0x5BA57 */

    if (!attacker_wins) {
        /* attacker LOST: defender military-strength bookkeeping (@0x5BA68:
         * per-power arrays at DS:[owner-0x6BEC]/-0x6DB4/-0x6BDC)        [V] */
        combat_apply_attacker_loss(attacker_idx, atk_owner, atk_type);
        combat_demote_loser(attacker_idx);     /* @0x5B5AA */
        return 1;
    }
    /* attacker WON: win FX + capture/destroy + popups; @0x5BAAC scans a
     * 0xCA-stride message table at DS:0x5D48 for the outcome key.       [V struct] */
    combat_apply_defender_loss(defender_idx, def_type, show_ui);
    return 1;

skip_combat:
    return 1;                                  /* @0x5BAA3 path */
}

/* ============================================================================
 * combat_demote_loser  --  @asm 0x5B5AA..0x5B68B  [V]
 * Fixed @UNIT type-remap (NOT a rebellion check). Writes new type to +0x02.
 *   Dragoon(4)->Soldier(1) -> Colonist(0);  Cont.Cav(7)->Cont.Army(9)->Colonist(0);
 *   Cavalry(8)->Regular(6); Artillery(0xB)/ships -> damaged-or-destroyed.
 * ============================================================================ */
void combat_demote_loser(int slot)
{
    int t  = U_TYPE(slot);
    int to = -1;                               /* [bp-0x22]=0xFFFF @0x5B5AA */
    if (t == 4) to = 1;                        /* @0x5B5BA */
    if (t == 1) to = 0;                        /* @0x5B5CA */
    if (t == 9) to = 0;                        /* @0x5B5DA */
    if (t == 7) to = 9;                        /* @0x5B5EA */
    if (t == 8) to = 6;                        /* @0x5B5FA */
    if (to < 0) {                              /* @0x5B603 -> 0x5B692 */
        combat_destroy_or_damage(slot, t);     /* damaged vs destroyed via flags&0x80 */
        return;
    }
    if (to > 0 && U(slot).vet_type == 0x18) to = 3;   /* @0x5B615 */
    U_TYPE(slot) = (unsigned char)to;          /* @0x5B68B */
}

/* consequence helpers — structurally verified; leaf details TBD ------------ */
extern void combat_apply_attacker_loss(int slot, int owner, int type);  /* @0x5BA68 [V struct] */
extern void combat_apply_defender_loss(int slot, int type, int show);   /* @0x5BD1A+        */
extern void combat_destroy_or_damage(int slot, int type);               /* @0x5B692+        */
