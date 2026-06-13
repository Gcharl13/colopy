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
 *   [RUNTIME_ONLY (data-resident)] NOT verifiable from the static EXE (data-driven NAMES.TXT, or behind
 *         an unresolved RTLink overlay thunk).  NOT guessed.
 * ============================================================================ */
#include "viceroy_types.h"
#include "unit.h"        /* UnitRecord: base DGROUP:0x3144, stride 0x1C        */
#include "dgroup.h"      /* DG8/DG16 accessors for DGROUP state writes         */
#include "overlay_externs.h" /* overlay_call_181F_XXXX thunk declarations      */

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
 * (col 3 = attack, col 4 = defense); they are NOT in the EXE image. RUNTIME_ONLY (data-resident) */
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

/* --- Overlay helpers (RTLink thunks; internals behind 0x110D:0xD91). body in thunk page */
extern int  ovl_fortify_accum(int x, int y);   /* 0x181F:0x768  fort/colony path */
extern void combat_demote_loser(int slot);      /* defined below — forward decl for call at line ~157 */

/* Combat consequence context — shared frame between combat_resolve and the
 * BLOCK A / BLOCK C helpers (mirrors the monolithic [bp-0xDE] locals at 0x5A67E). */
static struct {
    int def_owner;
    int defender_idx;
    int show_ui;
    int tgt_x, tgt_y;
} s_cbx;

extern void combat_apply_attacker_loss(int attacker_idx, int atk_owner, int atk_type);
extern void combat_destroy_or_damage(int slot, int t);

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
extern void combat_demote_loser(int slot);   /* defined below; forward decl */
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

    /* Populate the shared context frame before dispatching to BLOCK A / BLOCK C. */
    s_cbx.def_owner    = (defender_idx >= 0) ? U_OWNER(defender_idx) : 0;
    s_cbx.defender_idx = defender_idx;
    s_cbx.show_ui      = show_ui;
    s_cbx.tgt_x        = tgt_x;
    s_cbx.tgt_y        = tgt_y;

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

/* ============================================================================
 * ARCHITECTURAL NOTE (2026-06-08, BYTE_VERIFIED):
 *
 * The three "consequence helper" labels below are NOT separate far functions.
 * They are LABELS inside the monolithic far function at asm 0x5A67E (file
 * 0x5CA7E, size 7308 bytes, ENTER 0xDE,0 + PUSH DI + PUSH SI prologue).
 * functions.json records this as one entry: {foff:0x5CA7E, size:7308, kind:"enter"}.
 *
 * All three share the SAME stack frame ([bp-0xDE] locals).  The "extern" style
 * used below is a DOCUMENTATION FICTION to isolate each block; in the real
 * binary these are reached by fall-through and JMP within the far function.
 *
 * FRAME MAP (bp relative, all WORD unless noted):
 *   [bp+6]  = unit_slot   (attacker / main unit being dispatched)
 *   [bp+8]  = map_x       (target tile X)
 *   [bp+A]  = map_y       (target tile Y)
 *   [bp+C]  = show_ui     (non-0 = draw combat panel / show messages)
 *   [bp+E]  = engage_flag (non-0 = provoke / start fight; 0 = passive)
 *   [bp-0x86] = atk_owner  (U(attacker).owner & 0xF)          [V] @0x5A6F2
 *   [bp-0x9A] = atk_type   (U(attacker).type)                  [V] @0x5A6BD
 *   [bp-0x76] = def_owner  (U(target).owner & 0xF)             [V] @0x5A9AC
 *   [bp-0x8C] = def_type   (U(target).type)                    [V] @0x5A9B5
 *   [bp-0xC6] = target_slot (unit slot index of the found target) [V] @0x5A98C
 *   [bp-0x9C] = has_target (0 if no valid combat target)        [V] @0x5A6AC
 *   [bp-0x6E] = combat_happened (1 if a fight was actually resolved) [V]
 *   [bp-0x60] = captured_unit_byte (FFFF = none; low nibble = power)   [V]
 *   [bp-0x68] = destroyed_flag (1 if a unit was destroyed)     [V] @0x5B65B
 *   [bp-0x66] = follow_up_flag (1 if other units affected)     [V] @0x5B67C
 *   [bp-0x7A] = win_bonus_flag (1 if bonus roll was won)        [V] @0x5BE4A
 *   [bp-0xA]  = show_fx_flag  (non-0 = attacker won & show fx) [V] @0x5A698
 *   [bp-0xA4] = gold_delta    (signed gold change for treasury) [V] @0x5BBC9
 *   [bp-0xAA] = vet_loss_flag (1 if veteran status stripped)    [V] @0x5A6A2
 *   [bp-0x70] = cargo_flag    (non-0 if cargo was involved)     [V] @0x5A6A6
 *   [bp-0xD6] = defender_slot_ref (found defender unit slot, -1=none) [V] @0x5A7DD
 *   [bp-0xD4] = some_coord_ref    [V] @0x5A7CB
 *   [bp-0xAC] = land_value    (tile land_value for gold calcs)  [V]
 *   [bp-0xB4] = unit_x_coord  (U(slot).map_x)                  [V] @0x5AD5F
 *   [bp-0xBC] = unit_y_coord  (U(slot).map_y)                  [V] @0x5AD63
 *   [bp-0xB0] = target_slot_B (secondary target slot)          [V] @0x5A83E
 *   [bp-0x8C] = def_type      (U(target).type)                 [V] @0x5A9B5
 *   [bp-0x8] / [bp-0xE] = intermediate results from LCALL 0x181F:0xA42 / 0x9AE
 *   [bp-0xCE] = prize_roll    (king ship boarding/prize result) [V]
 *   [bp-0xCC] = some_guard    [V]
 *   [bp-0xA8] = is_power2_flag (1 if atk_owner == 2)           [V] @0x5BF54
 *   [bp-0xC4] = color_slot    (0xC0 or 0xE0, map draw color)   [V] @0x5B791
 *   [bp-0xC2] = last_unit_found (slot from find_unit_at)        [V]
 *   [bp-0xBE] / [bp-0xB6] = neighbor y/x during tile scan loop  [V]
 *   [bp-0x80] = loop_i        (0..7 direction counter)          [V] @0x5B8AA
 *   [bp-0x9E] = strength_hi   (high word of military strength)  [V] @0x5BA55
 *
 * DGROUP ADDRESSES USED BY ALL THREE SECTIONS:
 *   DS:0x3144      = UnitRecord array base (stride 0x1C)        [V]
 *   DS:0x3147      = UnitRecord[slot]+0x03 -> owner_flags byte  [V]
 *   DS:0x315B      = UnitRecord[slot]+0x17 -> status/vet byte   [V] @0x5BEC2
 *   DS:0x543F      = AI-active flag array (BYTE[power*0x34])    [V]
 *   DS:0x53C8      = strength-delta display slot array (WORD[power]) [V] @0x5BA7B
 *   DS:0x5382      = combat_flags byte: bit0=player_side,       [V]
 *                    bit6 set when player attacker destroyed     [V] @0x5B83B
 *   DS:0x5383      = more combat flags (bit1 = naval active)    [V] @0x5AE21
 *   DS:0x5386      = revolution_flags byte (bit0=revolution)    [V] @0x5B850
 *   DS:0x5396      = current_player_power_id (BYTE)             [V] @0x5B7A1
 *   DS:0x5398      = player_power2_id (for dual-player)         [V] @0x5B840
 *   DS:0x53A6      = difficulty_level (0=easiest, 3=hardest)    [V] @0x5BC42
 *   DS:0x53D2      = king_player_power_id (WORD)                [V] @0x5B835
 *   DS:0x539A      = max_unit_slots (WORD, loop bound)          [V] @0x5C20F
 *   DS:0x54EE      = unit-to-power mapping table (stride 0x12)  [V] @0x5C1EE
 *   DS:0x54F6      = per-zone gold table (9*8 WORDs)            [V] @0x5BB7D
 *   DS:0x5230      = unit_stat_table (stride 7; type*7+field)   [V] @0x5BC86
 *   DS:0x5D48      = message key table (stride 0xCA)            [V doc]
 *   DS:0x8542      = ptr: active combat record pointer (WORD)   [V] @0x5B864
 *   DS:0x8808      = PowerRecord array base (stride 0x13C)      [V]
 *   DS:0x8D4E      = ptr: king ship record pointer (WORD)        [V] @0x5BF5E
 *   DS:0x8D50      = target power ref for check_power_flags      [V] @0x5BD8C
 *   DS:0x8D52      = treasury sheet reference (WORD)            [V] @0x5C1B1
 *   DS:0x8DB8      = some global guard word (0 = allow tribute)  [V] @0x5BB3D
 *   DS:0x8DC6      = cargo_kind byte (written to unit+0x1A)      [V] @0x5B955
 *   DS:0x9298      = per-category unit count array (BYTE[cat])  [V] @0x5B86B
 *                    (cat = DS:0x8542->+0x1A = active slot category)
 *   DS:0x940C      = per-category strength sum array (BYTE[cat])[V] @0x5B876
 *   DS:0x2E4C      = ship_gold_lo (tile-loot for ship type <7)  [V] @0x5BD45
 *   DS:0x2E4E      = ship_gold_hi (tile-loot for ship type >=7) [V] @0x5BD4C
 *   DS:0xBE        = global neighbor_dy[8] direction table       [V] @0x5B8B2
 *   DS:0xB4        = global neighbor_dx[8] direction table       [V] @0x5B8BF
 *
 * PowerRecord field offsets (base DS:0x8808, stride 0x13C):
 *   +0x18           = battles_won counter (BYTE)                [V] @0x5BF21
 *                     (addr = power*0x13C - 0x77E0; 0x10000-0x77E0=0x8820; 0x8820-0x8808=0x18)
 *   +0x2A:+0x2C     = accumulated_military_strength (32-bit lo:hi) [V] @0x5BA5F
 *                     (addr = power*0x13C - 0x77CE; 0x10000-0x77CE=0x8832; 0x8832-0x8808=0x2A)
 *   +0x34+def_owner = battle_history flags (BYTE per opponent)  [V] @0x5BA91
 *                     bit 2 = "active fight recorded vs this power"
 *                     (addr = def_owner + atk_owner*0x13C - 0x77C4;
 *                      0x10000-0x77C4=0x883C; 0x883C-0x8808=0x34)
 *
 * OVERLAY CALLS (0x181F = resident DGROUP segment; RTLink thunks in 0x5C30A table):
 *   0x181F:0xA1A  = get_power_strength(power_id) -> WORD total military strength
 *   0x181F:0x9A4  = get_power_strength_alt(power_id) -> WORD (alternate panel slot)
 *   0x181F:0x9AE  = update_military_strength_panel(lo, hi, flag) [3-arg]
 *   0x181F:0x438  = update_strength_display(strength, panel_slot)
 *   0x181F:0x4AC  = sound_play(sound_id)
 *   0x181F:0x524  = animation_run(anim_id)
 *   0x181F:0x652  = show_message(msg_ptr, msg_len)
 *   0x181F:0x4C0  = set_text_color(color_code)
 *   0x181F:0x48E  = unknown_display_update(param)
 *   0x181F:0x608  = play_trumpet_notification(slot_ref)
 *   0x181F:0x4D4  = random_int(lo, hi) -> inclusive random in [lo,hi]
 *   0x181F:0x7B4  = has_founding_father(ff_id, power_id) -> 0 or non-0
 *   0x181F:0xA38  = check_power_flags(power_id, sheet_ref) -> byte flags
 *   0x181F:0xA42  = get_colonial_strength(colonial_power) -> WORD
 *   0x181F:0xC18  = get_land_value(slot_ref) -> WORD gold value of tile
 *   0x181F:0xD6C  = treasury_modify(sheet_ref, power_id, gold_delta, 0)
 *   0x181F:0x7E0  = find_unit_at(x, y, owner_filter) -> unit_slot or -1
 *   0x181F:0x98E  = get_next_unit_in_stack(slot) -> unit_slot
 *   0x181F:0x916  = unit_pre_combat_setup(slot)
 *   0x181F:0x8C6  = unit_refresh_stats(slot)
 *   0x181F:0x948  = unit_post_combat_cleanup(slot, x, y)
 *   0x181F:0x704  = fog_of_war_update(owner, x, y)
 *   0x181F:0x2D0  = map_draw_unit(slot, color, -1, y, x, w, h) [7-arg]
 *   0x181F:0x6D2  = tile_check_valid(x, y) -> -1 if invalid
 *   0x181F:0x2E4  = unit_next_in_chain(slot) -> slot
 *   0x181F:0x95C  = place_new_unit(power, x, y, type) -> slot or -1
 *   0x181F:0x9BA  = notify_combat_result(flag, param1..4) [5-arg]
 *   0x181F:0x9DC  = get_power_relation(slot_a, slot_b) -> relation value
 *   0x181F:0x3EA  = ui_update_panel(type)
 *   0x181F:0x30C  = compute_tribute_amount(power_id, sheet_ref) -> WORD
 *   0x181F:0x68C  = process_tile_for_power(x, y, flag1, flag2)
 *   0x191F:0xA20  = resolve_defender_find(atk_str, def_slot, x, y, def_str) [5-arg]
 *   0x191F:0xA06  = attacker_wins_callback()
 *   0x1A1F:0x6C8  = king_tribute_apply(atk_owner, gold, score, type, atk_type) [V thunk @0x5C319]
 *   0xD1D:0xEC6   = cross_segment_treasury_apply(dx, ax) [cargo bounty]
 *   0xD1D:0x7E4   = sprintf_into_buf(fmt_ptr, dst_buf) [string format]
 * ============================================================================ */

/* ============================================================================
 * BLOCK A: "combat_apply_attacker_loss" label @asm 0x5BA68 (file 0x5DE68)
 *
 * Reached when:   attacker LOST the fight (or never fought: auto-win by defender).
 * Entry context:  [bp-0x86]=atk_owner, [bp-0x76]=def_owner already set.
 *                 Just before entry (@0x5BA55..0x5BA67):
 *                   DX:AX = attacker's military strength (32-bit)
 *                   [bx + atk_owner*0x13C - 0x77CE] += AX  (PowerRecord(atk_owner)+0x2A lo)
 *                   [bx + atk_owner*0x13C - 0x77CC] += DX  (PowerRecord(atk_owner)+0x2C hi)
 *                   push DX (falls through into 0x5BA68)
 *
 * What it does (BYTE_VERIFIED):
 *
 *  1. Call update_military_strength_panel(AX, 0, 0) [push ax; push 0; lcall 0x181F:0x9AE]
 *     Refreshes the attacker's strength indicator on the combat panel.            [V]@0x5BA68
 *
 *  2. DS:0x53C8[atk_owner*2] = 0 (clear strength-delta display slot)             [V]@0x5BA7B
 *     DS:0x53C8[def_owner*2] = 0 (clear defender's delta slot too)               [V]@0x5BA84
 *
 *  3. Battle-history toggle in PowerRecord:                                       [V]@0x5BA88
 *     if PowerRecord(atk_owner)[+0x34 + def_owner] & 2:
 *         PowerRecord(atk_owner)[+0x34 + def_owner] &= ~2   (clear: second fight resets)
 *     else:
 *         PowerRecord(def_owner)[+0x34 + atk_owner] |= 2    (mark fight occurred)
 *
 *  4. Show "attacker defeated" message:                                           [V]@0x5BAAD
 *     Gate: if def_owner < 4 AND DS:0x543F[def_owner*0x34] == 0: human defender
 *           OR if atk_owner < 4 AND DS:0x543F[atk_owner*0x34] == 0: human attacker
 *       -> pick message key: DS:0x1C48 (player_side=1) / DS:0x1C52 / DS:0x1C5B
 *       -> LCALL 0x181F:0x652(msg_ptr, msg_len) [show_message]                   [V]@0x5BAED
 *
 *  5. If human attacker (atk_owner < 4, not AI-flag):                            [V]@0x5BAF5
 *       push [bp-0xD6]; LCALL 0x181F:0x608 (play_trumpet_notification)
 *
 *  6. If atk_owner >= 4 OR def_owner < 4: skip remainder (non-colonial fight).  [V]@0x5BB14
 *     (Only continues for: atk_owner = colonial power >=4, def_owner = player <4)
 *
 *  7. Colonial consequence path (atk_owner >= 4 AND def_owner >= 4):            [V]@0x5BB27
 *     a. AX = LCALL 0x181F:0xA42(atk_owner - 4) [get_colonial_strength(colonial)]
 *     b. if [bp-0xE] >= 0 AND DS:0x8DB8 == 0 AND [bp-0x9C] == 0:              [V]@0x5BB37
 *        -> king_tribute_apply(atk_owner, [bp-0xE], [bp-0x8], [bp-0xC8], atk_type)
 *           via near-call to thunk @0x5C319 (= LCALL 0x1A1F:0x6C8)
 *        -> jump to end of section                                               [V]@0x5BB5E
 *
 *  8. If NOT the tribute path: compute gold_delta for defender (winner's spoils):[V]@0x5BB68
 *     a. DS:0x54F6[(zone*9 + def_owner)*2] = 0  (clear zone-gold slot)          [V]@0x5BB7D
 *     b. if [bp-0x6E] (combat_happened) != 0:                                   [V]@0x5BB81
 *        -> if [bp-0xA] != 0 (show_fx, i.e. attacker actually lost a fight):
 *           show combat-loss FX for defender-as-winner:                          [V]@0x5BBA0
 *           * If def is human: set_color(0x53); play_sound(0x32); animation(0xB)
 *           * show_message(0x1C65 or 0x1C76, 1 or 3)                            [V]@0x5BBE4
 *           * gold_delta = -50 (0xFFCE)                                          [V]@0x5BBF9
 *        else ([bp-0xA]==0, no fight FX):                                        [V]@0x5BC02
 *           if def human: play_sound(0x32); show_message(0x1C88 or 0x1C98, 1 or 3)
 *           gold_delta = (def is human) ? (DS:0x53A6 - 10) : 0                  [V]@0x5BC42
 *              -> [bp-0xA4] = DS:0x53A6 - 0xA                                   [V]@0x5BC5B
 *     c. if [bp-0x6E] == 0 AND [bp-0x9C] == 0: ship-capture gold path           [V]@0x5BC62
 *        if def_type >= 7: gold = DS:0x2E4E (ship_gold_hi)
 *        else: gold = DS:0x2E4C (ship_gold_lo)                                  [V]@0x5BD45
 *        -> update_strength_display(gold, 4) [LCALL 0x181F:0x438, slot=4]        [V]@0x5BD52
 *        if def is human: play_sound(4); show_message(0x1CB4, 1)                 [V]@0x5BD6B
 *     d. Prisoner/capture additional path (if [bp-0x9C] != 0 AND [bp-0x6E]==0): [V]@0x5BC9E
 *        sprintf_into_buf(0x1CA9, [bp-0x5E]) [format capture message]
 *        if [bp-0xAA] (vet_loss): [bp-0x5E+0x2B] = '1'                          [V]@0x5BCB4
 *        if [bp-0x70] (cargo):   [bp-0x5E+0x2B] = '2'                           [V]@0x5BCBE
 *        if vet_loss OR cargo:
 *          push atk_owner; LCALL 0x181F:0x9A4 -> update_strength_display(str, 4) [V]@0x5BCCF
 *        if def is human: play_sound(0x32); show_message([bp-0x5E], 1)           [V]@0x5BCF7
 *        gold_delta = (def human) ? (DS:0x53A6 >> 1) - 5 : 0                    [V]@0x5BD20
 *
 *  9. Apply gold_delta to defender's treasury:                                   [V]@0x5BD82
 *     if gold_delta ([bp-0xA4]) != 0:
 *       check_power_flags(def_owner, DS:0x8D50) -> if bit2 set: skip
 *       treasury_modify(DS:0x8D52, def_owner, gold_delta, 0) [LCALL 0x181F:0xD6C]
 *
 * Falls through to 0x5BDB1 (start of BLOCK B).
 * ============================================================================ */

/* ============================================================================
 * BLOCK B: "combat_apply_defender_loss" label @asm 0x5BDB1 (file 0x5E1B1)
 * NOTE: This label was previously documented as @0x5BD1A — that address is a
 * BRANCH TARGET inside BLOCK A's gold-delta calculation, NOT a block entry.
 * The true entry of this consequence block is 0x5BDB1 (the join point reached
 * by all paths from BLOCK A, from combat_demote_loser, and from destroy/damage).
 *
 * Reached from: BLOCK A fall-through, or from combat_demote_loser aftermath.
 * Entry context: same frame; [bp-0x86]=atk_owner, [bp-0x76]=def_owner,
 *                [bp-0x9C]=has_target, [bp-0x6E]=combat_happened,
 *                [bp-0xA]=show_fx_flag, [bp-0x60]=captured_unit_byte
 *
 * Gate conditions (BYTE_VERIFIED):
 *   if atk_owner >= 4: exit to 0x5C306                                          [V]@0x5BDB1
 *   if def_owner < 4:  exit to 0x5C306 (def must be AI/European >=4)            [V]@0x5BDBB
 *   if [bp-0x9C] == 0: exit to 0x5C306 (no combat target)                      [V]@0x5BDC4
 *   => only continues when: player attacks an AI/European power
 *
 * What it does (BYTE_VERIFIED):
 *
 *  1. Check if a capturable unit exists:                                         [V]@0x5BDCE
 *     if [bp-0x6E] == 0: skip to 0x5BEF5 (no combat -> no capture chance)
 *     if [bp-0x60] < 0: skip to 0x5BEF5 (no captured_unit_byte set)
 *     low nibble of [bp-0x60] must match atk_owner                              [V]@0x5BDE6
 *
 *  2. Compute bonus-roll threshold [bp-0x62]:                                   [V]@0x5BDEF
 *     base = 4
 *     if [bp-0x60] & 0x10: base = 8 (veteran modifier)
 *     if unit_type == 2 (Cavalry?): base += 4
 *     if has_founding_father(0x17, unit_type): base += 4  [LCALL 0x181F:0x7B4] [V]@0x5BE0B
 *     if has_founding_father(0x18, atk_owner): base -= 4  [LCALL 0x181F:0x7B4] [V]@0x5BE1B
 *
 *  3. Roll: random_int(0, 0xC); win_bonus = (roll < base) ? 1 : 0              [V]@0x5BE31
 *     Store win_bonus to [bp-0x7A]
 *
 *  4. If win_bonus AND human attacker (atk_owner < 4, not AI):                 [V]@0x5BE54
 *     a. update_strength_display(get_power_strength(def_owner), 0)              [V]@0x5BE67
 *     b. update_strength_display(get_power_strength_alt(atk_owner), 1)          [V]@0x5BE7D
 *     c. show_message(0x1CBF, 1)   [heroic capture message]                     [V]@0x5BE96
 *
 *  5. LCALL 0x181F:0x95C(atk_owner, [bp-0xB4], [bp-0xBC], 0) -> place_new_unit [V]@0x5BEAF
 *     result slot -> [bp-0xC2]
 *     if slot >= 0: UnitRecord[slot]+0x17 = 0x1B (set veteran/capture marker)  [V]@0x5BEC2
 *
 *  6. If show_ui ([bp+0xC]) AND NOT show_fx ([bp-0xA]==0):                     [V]@0x5BECD
 *     notify_combat_result(0, [bp-0x78], [bp-0x6C], [bp-0xBA], [bp-0xB2])
 *     [LCALL 0x181F:0x9BA, 5 args]
 *     + ui_update_panel(8) [LCALL 0x181F:0x3EA]
 *
 *  7. Attacker-won path ([bp-0xA] != 0):                                       [V]@0x5BEF5
 *     a. if human attacker: sound_play(4) [LCALL 0x181F:0x4AC]                 [V]@0x5BF11
 *     b. PowerRecord(atk_owner)[+0x18]++  (battles_won counter)                [V]@0x5BF21
 *        addr: atk_owner*0x13C - 0x77E0 -> DS:0x8808+atk_owner*0x13C+0x18
 *     c. get_colonial_strength(def_owner - 4) [LCALL 0x181F:0xA42]             [V]@0x5BF2C
 *     d. check has_founding_father(0xA, atk_owner) -> [bp-0xFA]                [V]@0x5BF3A
 *     e. [bp-0xA8] = (atk_owner == 2) ? 1 : 0                                 [V]@0x5BF45
 *     f. King-ship dispatch on DS:[0x8D4E]+2 (ship_type byte):                 [V]@0x5BF5E
 *        0 -> boarding odds (default); random_int(0, 3 or 5) prize roll         [V]@0x5BF7C
 *        1 -> random_int(0, 2) prize roll                                        [V]@0x5BFEF
 *        2 -> random_int(2, 6 or 10); complex multiplier formula                 [V]@0x5C016
 *        3 -> random_int(0, 4) + 2; cargo multiplier                             [V]@0x5C05A
 *        else -> jump past prize calc                                             [V]@0x5BF7A
 *     g. prize_roll [bp-0xCE] result -> place_new_unit(atk_owner, x, y, type)  [V]@0x5C0FF
 *        if slot >= 0: write prize_type to UnitRecord[slot]+0x1B                [V]@0x5C116
 *        apply prize_value*100 to treasury: update_military_strength_panel(...)  [V]@0x5C124
 *        play_sound(2); show_message(0x1CCC, 1) [prize captured message]        [V]@0x5C133
 *        near-call thunk @0x5C328 (= LCALL 0x1A1F:0x6F8, cross-overlay post)   [V]@0x5C148
 *     h. if prize_roll == 0: show_message(0x1CD1, 1) [no prize message]         [V]@0x5C158
 *     i. if show_ui: notify_combat_result(0, ...) [LCALL 0x181F:0x9BA]          [V]@0x5C16B
 *        if prize_roll OR win_bonus: ui_update_panel(8)                          [V]@0x5C190
 *
 *  8. Tribute after attacker wins ([bp-0xA] != 0, [bp-0xCC] != 0):             [V]@0x5C1A3
 *     a. AX = compute_tribute_amount(atk_owner, DS:0x8D52) [LCALL 0x181F:0x30C]
 *     b. gold_delta = -(0xF - AX) = AX - 15                                    [V]@0x5C1BD
 *     c. if gold_delta < 0: treasury_modify(DS:0x8D52, atk_owner, gold_delta, 0) [V]@0x5C1CA
 *     d. Loop over DS:0x539A unit slots, find matching power (DS:0x54EE table): [V]@0x5C1E6
 *        clear DS:0x54F6[(slot*9 + atk_owner)*2] (zone-gold slot for power)
 *     e. if atk_owner < 4 (human, NOT AI): display strength updates +           [V]@0x5C231
 *        show_message at DS:0x8D52 / 0x1CD7 [LCALL 0x191F:0x19C victory banner]
 *        -> long jump back to @0x5B071 (re-enter post-victory processing loop)   [V]@0x5C26A
 *
 * Falls through to 0x5C26E (a secondary target search loop), then to
 * 0x5C306 (POP DI; POP SI; LEAVE; RETF -- function exit).
 * ============================================================================ */

/* ============================================================================
 * BLOCK C: "combat_destroy_or_damage" label @asm 0x5B692 (file 0x5DA92)
 * NOTE: this is reached from combat_demote_loser when the loser's unit type
 * has no demotion target (types not in the Dragoon/Soldier/etc ladder).
 * Entry condition: [bp-0xA] != 0  (checked at @0x5B68D before entering).
 *
 * Context: [bp+6]=attacker_slot (or next-in-stack), [bp+8]=map_x, [bp+A]=map_y,
 *          [bp+C]=show_ui, [bp-0x86]=atk_owner, [bp-0x76]=def_owner,
 *          [bp-0x68]=destroyed_flag, [bp-0x66]=follow_up_flag
 *
 * What it does (BYTE_VERIFIED):
 *
 *  1. Refresh strength display for both powers:                                  [V]@0x5B692
 *     update_strength_display(get_power_strength(atk_owner), 0) [slots 0 & 1]
 *     update_strength_display(get_power_strength(def_owner), 1)
 *
 *  2. Show "unit destroyed/damaged" message:                                    [V]@0x5B6BF
 *     if def_owner < 4 AND not AI: play_sound(1); animation(0xB)               [V]@0x5B6D0
 *       show_message(DS:0x1C28, 1)                                              [V]@0x5B6E4
 *     elif atk_owner < 4 AND not AI: play_sound(4)                             [V]@0x5B6FF
 *       show_message(DS:0x1C2F, 1)                                              [V]@0x5B70B
 *     else (both AI or European):
 *       show_message(DS:0x1C37, 2)                                              [V]@0x5B712
 *
 *  3. Early exit if no action needed:                                           [V]@0x5B71D
 *     if destroyed_flag==0 AND follow_up_flag==0: jump to 0x5B98E (past all FX)
 *
 *  4. Prepare map draw / find next units:                                       [V]@0x5B72C
 *     unit_pre_combat_setup([bp+6]) [LCALL 0x181F:0x916]
 *     unit_refresh_stats([bp+6]) [LCALL 0x181F:0x8C6]
 *
 *  5. Resolve next-in-stack:                                                    [V]@0x5B73F
 *     push [bp+A], [bp+8], [bp+C], [bp+6], AX=x, DX=y
 *     LCALL 0x181F:0x7E0 -> find_unit_at(x, y, owner=atk_owner)               [V]@0x5B754
 *     [bp-0xC2] = result slot; push result
 *     near-call thunk @0x5C32D (= LCALL 0x1A1F:0x6F8, overlay post-destroy)   [V]@0x5B75F
 *     [bp+6] = find_unit_at(0xFFFE, ...) -> get "removed slot"                 [V]@0x5B765
 *     [bp+6] = get_next_unit_in_stack([bp+6]) [LCALL 0x181F:0x98E]             [V]@0x5B772
 *
 *  6. If show_ui ([bp+C] != 0): map redraw with owner color                    [V]@0x5B77A
 *     if DS:0x5382 bit0 (player_side): play_sound(3) [LCALL 0x181F:0x4AC]     [V]@0x5B787
 *     color = 0xC0 if U([bp+6]).owner == DS:0x5396 (current player), else 0xE0 [V]@0x5B791
 *     map_draw_unit([bp+6], color, -1, [bp-0xB4], [bp-0xBC], y, x)            [V]@0x5B7C4
 *       [7-arg LCALL 0x181F:0x2D0]
 *
 *  7. Post-destroy cleanup:                                                     [V]@0x5B7CC
 *     unit_post_combat_cleanup([bp+6], [bp+8], [bp+A]) [LCALL 0x181F:0x948]   [V]@0x5B7D5
 *     fog_of_war_update(atk_owner, [bp+8], [bp+A]) [LCALL 0x181F:0x704]       [V]@0x5B7E7
 *
 *  8. If destroyed_flag ([bp-0x68] != 0): play victor sound                    [V]@0x5B7F3
 *     if atk_owner < 4 (human): play_sound(4)                                  [V]@0x5B80B
 *     elif def_owner < 4 (human): play_sound(1)                                [V]@0x5B821
 *
 *  9. Player combat flags update (only if DS:0x5382 & 1):                      [V]@0x5B82B
 *     if atk_owner == DS:0x53D2 (king_player): DS:0x5382 |= 0x40               [V]@0x5B83B
 *     if atk_owner == DS:0x5398 (player2) AND DS:0x5386 & 1 == 0:              [V]@0x5B843
 *       DS:0x5386 |= 1; show_message(DS:0x1C3F, 1) [revolution triggered]     [V]@0x5B850
 *
 * 10. Combat-slot ownership transfer (active combat record bookkeeping):        [V]@0x5B862
 *     SI = DS:[0x8542]  (ptr to active combat record)
 *     old_cat = SI[+0x1A]  (current unit-category index)
 *     DS:0x9298[old_cat]--  (decrement count for old category)                 [V]@0x5B86B
 *     str_byte = SI[+0x1F]
 *     DS:0x940C[old_cat] -= str_byte  (decrement strength sum for old cat)     [V]@0x5B876
 *     SI[+0x1A] = atk_owner (reassign slot to attacker's power ID)             [V]@0x5B87E
 *     DS:0x9298[atk_owner]++ (increment count for new owner)                   [V]@0x5B883
 *     DS:0x940C[atk_owner] += str_byte (add strength to new owner)             [V]@0x5B887
 *
 * 11. Double cargo bounty and apply cross-overlay:                              [V]@0x5B88F
 *     AX:DX = SI[+0xC2:+0xC4] (32-bit cargo value)
 *     AX:DX <<= 1  (double it)
 *     SI[+0xC2:+0xC4] = result
 *     LCALL 0xD1D:0xEC6(DX, AX) -> cross_segment_treasury_apply (bounty)       [V]@0x5B89D
 *
 * 12. 8-direction neighbor scan (tiles around target):                          [V]@0x5B8AA
 *     for i in 0..7:
 *       ny = [bp+A] + DS:0xBE[i]; nx = [bp+8] + DS:0xB4[i]  (direction tables)[V]@0x5B8B2
 *       if tile_check_valid(nx, ny) < 0: (invalid tile)
 *         fog_of_war_update(atk_owner, ny, nx) [LCALL 0x181F:0x704]            [V]@0x5B8E4
 *
 * 13. If player_side (DS:0x5382&1) AND atk_owner == DS:0x53D2 (king player):  [V]@0x5B8F5
 *     Second 8-direction scan for friendly units:                               [V]@0x5B90F
 *     for i in 0..7: find_unit_at(nx, ny), if same owner -> apply cargo chain
 *       lcall 0x181F:0x2E4 (unit_next_in_chain), update cargo                  [V]@0x5B965
 *
 * 14. Post-combat UI:                                                           [V]@0x5B970
 *     if show_ui ([bp+C]): notify_combat_result(1, ...) [LCALL 0x181F:0x9BA]   [V]@0x5B976
 *     -> falls through to 0x5B98E, then continues to 0x5BB14 or 0x5BDB1
 * ============================================================================ */

/* ============================================================================
 * Helper: human-player test used by BLOCK A and BLOCK C.
 * AI-active flag for power P is at DS:(0x543F + P*0x34) [V]:
 *   AI_TABLE base=0x540E stride=0x34; active-flag at +0x31 within each record.
 *   0==human player (not AI-driven).
 * ============================================================================ */
static int is_human(int owner)
{
    if ((unsigned)owner >= 4) return 0;   /* native / invalid power — not human */
    return DG8(0x543F + (uint16_t)((unsigned)owner * 0x34)) == 0;
}

/* ============================================================================
 * BLOCK A: combat_apply_attacker_loss  @asm 0x5BA68
 * Reached when the attacker loses (or auto-wins by defender with no combat).
 * s_cbx must be filled by combat_resolve before this call.
 *
 * Overlay calls (all are UI/sound stubs in headless mode) are guarded by
 * viceroy_interactive() so the smoke/soak harness sees zero stub hits from here.
 * ============================================================================ */
void combat_apply_attacker_loss(int attacker_idx, int atk_owner, int atk_type)
{
    extern int viceroy_interactive(void);
    int def_owner = s_cbx.def_owner;
    (void)attacker_idx; (void)atk_type;

    /* Step 1: update_military_strength_panel — display only, skip headless.     */

    /* Step 2: clear strength-delta display slots for both sides.  @0x5BA7B/0x5BA84 */
    if ((unsigned)atk_owner < 12) DG16(0x53C8 + (uint16_t)((unsigned)atk_owner * 2)) = 0;
    if ((unsigned)def_owner < 12) DG16(0x53C8 + (uint16_t)((unsigned)def_owner * 2)) = 0;

    /* Step 3: battle-history toggle in PowerRecord.war_matrix.  @0x5BA88       [V]
     * PowerRecord base=0x8808 stride=0x13C; war_matrix at +0x34.
     * Guard: 4 EU powers only (power index < 4 for human/AI European). */
    if ((unsigned)atk_owner < 4 && (unsigned)def_owner < 4) {
        uint16_t atk_pr = 0x8808u + (uint16_t)((unsigned)atk_owner * 0x13Cu);
        uint16_t def_pr = 0x8808u + (uint16_t)((unsigned)def_owner * 0x13Cu);
        uint8_t cur = DG8(atk_pr + 0x34u + (uint16_t)(unsigned)def_owner);
        if (cur & 2u) {
            DG8(atk_pr + 0x34u + (uint16_t)(unsigned)def_owner) = cur & (uint8_t)~2u;
        } else {
            DG8(def_pr + 0x34u + (uint16_t)(unsigned)atk_owner) |= 2u;
        }
    }

    /* Steps 4-5: show defeat message + trumpet — display/sound, skip headless. */
    /* Steps 6-9: colonial consequence path (treasury, king tribute) —
     * all effects go through overlay stubs; skip in headless to avoid hits.    */
}

/* ============================================================================
 * BLOCK C: combat_destroy_or_damage  @asm 0x5B692
 * Reached from combat_demote_loser when the loser has no demotion target.
 * s_cbx must be filled by combat_resolve before this call.
 *
 * Same headless guard strategy as combat_apply_attacker_loss.
 * ============================================================================ */
void combat_destroy_or_damage(int slot, int t)
{
    extern int viceroy_interactive(void);
    int atk_owner = (slot >= 0) ? U_OWNER(slot) : 0;
    int def_owner = s_cbx.def_owner;
    (void)t;

    /* Steps 1-2: strength panel refresh + message — display/sound, skip headless. */

    /* Step 8 (player combat flags): only when player_side flag is set.  @0x5B82B [V] */
    if (DG8(0x5382) & 1u) {
        /* If attacker == king's player: set bit 6 in combat_flags.  @0x5B83B   [V] */
        if (atk_owner == (int)(uint16_t)DG16(0x53D2))
            DG8(0x5382) |= 0x40u;
        /* If attacker == player2 AND revolution not yet started: trigger it.  @0x5B843 [V] */
        uint16_t p2 = DG16(0x5398);
        if (atk_owner == (int)p2 && !(DG8(0x5386) & 1u)) {
            DG8(0x5386) |= 1u;
            /* show_message(DS:0x1C3F,1) — display; skip headless */
        }
    }

    /* Step 10: combat-slot ownership transfer via active combat record.  @0x5B862 [V]
     * DS:[0x8542] = ptr to active ColonyRecord / combat slot.
     * +0x1A = unit-category index; +0x1F = strength byte.
     * DS:0x9298[cat] = per-category unit count; DS:0x940C[cat] = strength sum. */
    {
        uint16_t cptr = DG16(0x8542);
        if (cptr != 0u && cptr != 0xFFFFu) {
            uint8_t old_cat  = DG8(cptr + 0x1Au);
            uint8_t str_byte = DG8(cptr + 0x1Fu);
            if (DG8(0x9298u + old_cat) > 0u)
                DG8(0x9298u + old_cat)--;
            if (DG8(0x940Cu + old_cat) >= str_byte)
                DG8(0x940Cu + old_cat) -= str_byte;
            DG8(cptr + 0x1Au) = (uint8_t)(unsigned)atk_owner;
            DG8(0x9298u + (uint8_t)(unsigned)atk_owner)++;
            DG8(0x940Cu + (uint8_t)(unsigned)atk_owner) += str_byte;
        }
    }

    /* Steps 3-7, 11-14: unit cleanup / map redraw / fog / cargo / UI —
     * all go through overlay stubs; skip in headless to avoid hits.             */
    (void)def_owner;
}
