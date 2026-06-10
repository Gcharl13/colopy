/* ============================================================================
 *                  >>> BYTE_VERIFIED (modifier mechanism) <<<
 * ----------------------------------------------------------------------------
 * combat_modifiers.c -- The fortified / Sons-of-Liberty / colony-defense
 *   modifier terms of the combat resolver func_05B2C2, reconstructed from
 *   VICEROY.EXE raw bytes.  This file DOCUMENTS the modifier mechanism; it does
 *   NOT re-port the core resolver (see combat.c, already BYTE_VERIFIED).
 *
 * Resolver:  func_05B2C2  @asm file 0x5B2C2..0x5BE30 (reseg page 0x10, ENTER 0x3A,0).
 * Binary:    COLONIZE/VICEROY.EXE
 *            sha256 a17ed64c27671e5e95236e54a7ddc85803a96ba822fbed05e1dad34d3917e2e3
 *
 * ============================================================================
 * HEADLINE FINDING (byte-proven, three independent ways)
 * ----------------------------------------------------------------------------
 * The single combat ODDS ROLL @0x5B849 uses RAW per-type stat bytes with NO
 * fortify / SoL / colony / terrain multiplier scaling ATK or DEF:
 *
 *     DEF = g_unit_stat[deftype*14 + 0x0B]   (0x523b)   @0x5B823   [V]
 *     ATK = g_unit_stat[atktype*14 + 0x0C]   (0x523c)   @0x5B83B   [V]
 *     total = DEF + ATK                                 @0x5B844   [V]
 *     roll  = random_int(1, total)           (0x181F:0x04D4) @0x5B849 [V]
 *     attacker_wins = (roll <= ATK)                     @0x5B851/0x5B854 [V]
 *
 * Proof 1 — no intervening arithmetic: between the DEF read (0x5B823) and the
 *   ATK read (0x5B83B) and the ADD (0x5B844 `03 C1` = `add ax,cx`) there is no
 *   IMUL / SHL / scaling op on AX or CX. (raw bytes @0x5B819..0x5B846)      [V]
 * Proof 2 — DEF/ATK source never modified: the defender-type local [bp-2] that
 *   indexes DEF is written ONCE (@0x5B2FA =0x10 for "no defender", else @0x5B316
 *   = defender UnitRecord.type), and never re-written by the fort block or any
 *   other path before the roll. (writes to [bp-2] = {0x5B2FA, 0x5B316} only) [V]
 * Proof 3 — table is read nowhere else: across ALL re-segmented overlay pages,
 *   0x523b (DEF) and 0x523c (ATK) are read at EXACTLY three sites, all inside
 *   this roll (page_10.asm lines for 0x5B819/0x5B823/0x5B83B). No other function
 *   reads them with (or without) a multiplier. So a "fortified ATK/DEF scaler"
 *   does not exist anywhere in the overlay image.                            [V]
 *
 * COROLLARY: the long-standing "+50% fortified" hypothesis is REFUTED for this
 * engine. VICEROY combat is base odds = ATK/(ATK+DEF); fortification and colony
 * presence change ROUTING and the post-roll military-strength comparison, not
 * the odds-roll inputs.                                                       [V]
 *
 * ============================================================================
 * WHO REACHES THE ROLL (byte-proven gate)
 * ----------------------------------------------------------------------------
 * The roll @0x5B849 is reached ONLY through the block at 0x5B7C0, which is
 * entered only when the ATTACKER unit type is a SHIP:
 *     @0x5B7B6  cmp byte[attacker+0x3146], 0x0D ; @0x5B7BB jae 0x5B7C0   (raw: 80 BF 46 31 0D / 73 03) [V]
 *     @0x5B7C0  cmp byte[attacker+0x3146], 0x12 ; @0x5B7C5 jbe 0x5B7CA   (raw: 80 BF 46 31 12 / 76 03) [V]
 *   => attacker type in [0x0D..0x12] (Caravel..Man-O-War) takes the roll; any
 *      other (land) attacker @0x5B7BD `jmp 0x5BAA3` skips it. There is exactly
 *      ONE combat random_int in the whole function (the other RNG @0x5B3B4 is the
 *      ambush 50% coin). (CFG: predecessors of 0x5B819 = {0x5B817} only)       [V]
 *   The roll's DEF input is the DEFENDER's 0x523b; ATK input is the attacking
 *   SHIP's 0x523c.  So this is naval-bombardment / ship-attacks-X odds.        [V]
 *
 * ============================================================================
 * THE FORT BLOCK @0x5B433 — what it really computes (RESOLVED)
 * ----------------------------------------------------------------------------
 * Reached only when [bp-0x16]!=0, i.e. the ATTACKER is a NON-combatant special
 * unit (type 0xA Treasure / 0 Colonist / 0xC Wagon — set @0x5B331), AND the
 * fort_path flag [bp-0x28]!=0 (a colony/fort is present), AND the defender is a
 * LAND unit (ships 0x0D..0x12 excluded @0x5B414/0x5B41B), AND [bp-2]==0x0F.
 * Then @0x5B451..0x5B497 it computes an ELIGIBILITY THRESHOLD (NOT a stat
 * scale):
 *
 *     def_term = (signed) g_unit_stat[deftype*14 + 0x07]   (0x5237)
 *                          - g_units[def].byte_0x3150;       (UnitRecord +0x0C)   @0x5B471/0x5B477  [V]
 *     atk_term = g_unit_stat[atktype*14 + 0x08]            (0x5238)               @0x5B48F          [V]
 *     if (def_term >= atk_term)  keep [bp-0x24];                                 @0x5B495 cmp / 0x5B497 jge [V]
 *     else                       [bp-0x24] = 0;                                  @0x5B499                  [V]
 *
 *   [bp-0x24] (init 1 @0x5B2D3) is a routing flag consumed @0x5B4B0
 *   (`cmp [bp-0x24],0 / je 0x5B58C`): it decides whether the special unit may
 *   *enter / capture* the fortified colony tile, then runs UI ops
 *   (0x181F:0x812 / 0x894 / 0x844 @0x5B4BC..0x5B4D8). It NEVER feeds the odds
 *   roll. So 0x5237/0x5238 are a colony-capture eligibility pair, not ATK/DEF
 *   modifiers.                                                                  [V]
 *
 * Table provenance: 0x5230-family (stride 14) is the @UNIT record, populated at
 *   game start by the loader @0x74EE0..0x74F59 from NAMES.TXT (each field via
 *   LCALL 0x1A1F:0x88A). Offsets: +0x00 icon(word), +0x06(0x5236) combat-elig,
 *   +0x07(0x5237) and +0x08(0x5238) the colony-capture pair, +0x0B(0x523b) DEF,
 *   +0x0C(0x523c) ATK, +0x0D(0x523d) flag-bits. The exact @UNIT column->field
 *   correspondence for 0x5237/0x5238 (and even for 0x523b/0x523c) is a NAMES.TXT
 *   data question RUNTIME_ONLY (data-resident): the loader @0x74EDA does 12 field-reads (1×0x1A1F:0xB22
 *   + 10×0x1A1F:0x88A + 1×0x1A1F:0xB2E) but each raw @UNIT row has only 11 comma
 *   fields, so the field->offset alignment is NOT a naive 1:1 and must be pinned
 *   from the loader's readers, not the pretty extract. CONFLICT to reconcile:
 *   combat.c's header claims "@UNIT col 3=attack, col 4=defense" map to
 *   0x523b/0x523c, but the loader puts cols 3/4 at 0x5234/0x5236, NOT 0x523b/0x523c.
 *   The ROLL semantics (0x523b=DEF, 0x523c=ATK at the win-threshold) are
 *   byte-certain; the column label is the open item. -> docs/RULINGS.md.   [V/RUNTIME_ONLY (data-resident)]
 *
 * ============================================================================
 * THE REAL MODIFIER LAYER — post-roll military-strength comparison @0x5B85B
 * ----------------------------------------------------------------------------
 * After the odds roll, the resolver runs a strength-comparison block
 * (@0x5B85B..0x5BA2D) that adjusts attacker_wins ([bp-0x3a]) using PER-POWER
 * military arrays (negative DS offsets, stride 0x13 = 19 bytes per power),
 * the per-type 0x5237 value, and a global scale factor — NOT a fortify% on
 * ATK/DEF. Byte-cited terms:
 *
 *   - per-power x per-type strength: al = [atk_owner*0x13 + (-0x6db4)]   @0x5B889 [V]
 *   - per-power cap:                 cl = [atk_owner + (-0x6d68)]        @0x5B899 [V]
 *     if (al <= cl && [owner-0x6bdc] > 8) ... else attacker_wins=0       @0x5B8A1/0x5B8A3 [V]
 *   - frigate-vs-frigate (type 0x11) special: cmp [def_owner*0x13 - 0x6da3], al  @0x5B8B3..0x5B8CB [V]
 *   - global difficulty scale: al = [atk_owner*0x13 - 0x6da3]; MUL [0x5325]      @0x5B99E/0x5B9A2 [V]
 *   - accumulate: cx -= 0x5237[deftype]; cx -= [def-0x6da4]; ...; [bp-6]=cx       @0x5B9C9..0x5B9DB [V]
 *   - weighted check: ax = lib_weighted(([owner-0x6bf0]>>2), 3, 6) (0x181F:0x35c)
 *                      if (ax > [bp-6]) attacker_wins=1                          @0x5BA0B..0x5BA28 [V]
 *
 *   These per-power arrays (-0x6db4 stride 19, -0x6da4, -0x6da3, -0x6bec,
 *   -0x6be8, -0x6bdc, -0x6bf0, -0x6d68) are the COLONY/POWER military-strength
 *   state (Sons-of-Liberty / veteran / colony-defense bookkeeping lives here,
 *   per the per-power layout). They modify the OUTCOME via comparison, not the
 *   odds-roll inputs. Their precise per-array semantics (which is SoL%, which is
 *   defense bonus) require the per-power init code and are [not yet decoded] beyond this
 *   sub-task's scope; their combat ROLE (post-roll attacker_wins adjustment) is
 *   byte-verified here.                                                          [V/not yet decoded-split]
 *
 * NOTE the global [0x5325] (MUL @0x5B9A2) is a single-byte difficulty/scale
 * factor applied to the per-power strength; not separately xref-indexed.
 * ============================================================================ */
#include "viceroy_types.h"
#include "unit.h"

/* @UNIT per-type record, base DGROUP:0x5230 stride 14. (loader @0x74EE0)  [V] */
extern unsigned char g_unit_stat[];
#define UT_STRIDE          14
#define UT_DEF(t)          (g_unit_stat[(t)*UT_STRIDE + 0x0B])   /* 0x523b  [V] */
#define UT_ATK(t)          (g_unit_stat[(t)*UT_STRIDE + 0x0C])   /* 0x523c  [V] */
#define UT_CAPTURE_D(t)    (g_unit_stat[(t)*UT_STRIDE + 0x07])   /* 0x5237  [V] */
#define UT_CAPTURE_A(t)    (g_unit_stat[(t)*UT_STRIDE + 0x08])   /* 0x5238  [V] */
#define UT_COMBAT_ELIG(t)  (g_unit_stat[(t)*UT_STRIDE + 0x06])   /* 0x5236  [V] */

extern struct UnitRecord g_units[];     /* DGROUP:0x3144 stride 0x1C */
#define U(i)        (g_units[(i)])

/* Per-power military-strength arrays (DGROUP negative offsets, stride 0x13=19
 * per power). LOCAL externs — these are the colony/power-defense state; the
 * resolver reads them ONLY in the post-roll comparison block @0x5B85B..0x5BA2D.
 * IDENTITY RESOLVED 2026-06-10: DS:-0x6DB4 = 0x924C = the AI-CENSUS units-by-
 * type matrix byte[power*0x13 + unit_type] (writer overlay_040C1E_04458A.c
 * @0x04242D clamp_add per unit; zeroed @0x04217A) — the post-roll block
 * consults the power's overall force composition. */
extern unsigned char g_census_units_by_type[/* power*0x13 + type */];  /* DS:0x924C (-0x6DB4) @0x5B889 [V] */
extern unsigned char g_pow_strength_cap[/* power */];                  /* DS:-0x6D68 @0x5B899 [V] */
extern unsigned char g_pow_def_term[/* power*0x13 (+...) */];          /* DS:-0x6DA4/-0x6DA3 @0x5B9D5/0x5B99E [V] */
extern unsigned char g_pow_misc_6bec[/* power */];                     /* DS:-0x6BEC @0x5B9A9 [V] */
extern unsigned char g_pow_misc_6be8[/* power */];                     /* DS:-0x6BE8 @0x5B9DE [V] */
extern unsigned char g_pow_count_6bdc[/* power */];                    /* DS:-0x6BDC @0x5B8A3/0x5B9E2 [V] */
extern unsigned char g_pow_misc_6bf0[/* power */];                     /* DS:-0x6BF0 @0x5BA11 [V] */
extern unsigned char g_combat_difficulty_scale;                        /* DS:0x5325  @0x5B9A2 [V] */

/* Library helpers (load-image segment 0x181F; bodies in runtime library,
 * library-implementation-only). random_int is the verified one (0x181F:0x04D4). */
extern int  random_int(int lo, int hi);                 /* 0x181F:0x04D4 (rng.c) [V] */
extern int  lib_weighted_pick(int a, int b, int c);     /* 0x181F:0x35C @0x5BA1B [V call] */

/* ----------------------------------------------------------------------------
 * combat_capture_eligible — the fort block @0x5B433 threshold (documentation
 * mirror; the live code is inside combat_resolve / func_05B2C2 @0x5B451).
 *
 *   Returns nonzero if the special attacker (treasure/colonist/wagon) may take
 *   the fortified colony tile defended by a type-0x0F unit. NOT a stat scaler.
 * @asm 0x5B451..0x5B497                                                     [V] */
int combat_capture_eligible(int attacker_idx, int defender_idx)
{
    int def_type = U(defender_idx).type;                 /* @0x5B457 */
    int atk_type = U(attacker_idx).type;                 /* @0x5B47D */
    /* signed: 0x5237[deftype] - defender.UnitRecord[+0x0C] (struct field
     * cargo_slot_count @0x3150; here used as a dynamic capture-resistance term) */
    int def_term = (int)UT_CAPTURE_D(def_type)
                 - (int)U(defender_idx).cargo_slot_count; /* @0x5B45D/0x5B471..0x5B477 (sub cx,ax) */
    int atk_term = (int)UT_CAPTURE_A(atk_type);           /* @0x5B48F */
    return (def_term >= atk_term);                        /* @0x5B495/0x5B497 jge => eligible */
}

/* ----------------------------------------------------------------------------
 * combat_ship_odds — the ONE odds roll @0x5B849 (documentation mirror; live in
 * func_05B2C2). Fires only for ship attackers (type 0x0D..0x12). RAW stats.
 * @asm 0x5B819..0x5B854                                                      [V] */
int combat_ship_odds(int attacker_idx, int defender_type)
{
    int def = UT_DEF(defender_type);          /* 0x523b @0x5B823 */
    int atk;
    int total, roll;
    if (def == 0) return 1;                   /* @0x5B819 DEF==0 -> skip combat (return "handled") */
    atk   = UT_ATK(U(attacker_idx).type);     /* 0x523c @0x5B83B (attacker is the ship) */
    total = def + atk;                        /* @0x5B844 (raw sum, NO modifier) */
    roll  = random_int(1, total);             /* @0x5B849 */
    return (roll <= atk);                     /* @0x5B851/0x5B854 attacker(ship) wins iff roll<=ATK */
}

/* ============================================================================
 * defend_strength — func_007D3E (0x181F:0x9DC, resident, 502B)
 *                       >>> BYTE_VERIFIED 2026-06-10 — full body <<<
 * ----------------------------------------------------------------------------
 * THE DEFENDER STRENGTH FORMULA with every situational modifier, plus the
 * MODIFIER-FLAG block at DGROUP:0x8D00..0x8D04 the pre-combat odds dialog
 * renders (one bit = one modifier line).  All quarter-step multipliers:
 *
 *     strength = base * (4 + bonus) / 4        @asm 0x007F26..0x007F2F
 *     base     = strength_query(def_unit, 0)   ; near 0x7C2A (= 0x181F:0x9C8)
 *
 * bonus accumulation (mutually exclusive location branches):
 *  IN NATIVE SETTLEMENT (0x37F:0x392 probe >= 0):       @asm 0x007D8D..0x007DDE
 *     bonus = 2 (+50%)
 *     if tribe_tech[0x5AD8 + (tribe-4)*0x4E] >= 2:  bonus = 4 (+100%),
 *                                                   [0x8D02] |= 0x10
 *     if settlement[+0x54EF] & 4 (CAPITAL):         bonus <<= 1 (double),
 *                                                   [0x8D02] |= 0x20
 *     always:                                       [0x8D02] |= 0x08
 *  IN COLONY (0x37F:0x358 probe >= 0):                  @asm 0x007DF4..0x007E1D
 *     bonus += (fort_level + 1) * 2                 ; stockade +4/4, fort +6/4,
 *                                                   ;   fortress +8/4 (raw level
 *                                                   ;   via 0x5EB:0x2C + near 0x7BE8)
 *     [0x8D02] |= 0x40
 *  OPEN TERRAIN:                                        @asm 0x007E20..0x007EFE
 *     terrain = tile type (0x3E4:0x3A);  defcol = byte[0x2F77 + terrain*16]
 *               (terrain-table attribute col +3 = the NAMES.TXT terrain
 *                DEFENSE column; table base 0x2F74 stride 16)
 *     eligible for the bonus when: defender is native, OR attacker is native,
 *       OR (post-revolution + attacker AI), OR attacker is a human European
 *       and BOTH units stand outside colonies:
 *         bonus += defcol;  [0x8D02] |= 0x80
 *     else EUROPEAN AMBUSH RULE:                        @asm 0x007E74..0x007EF9
 *         if defender's order state [+0x314C] != 6 (not FORTIFIED):
 *             [0x8D04] = defcol     ; the terrain bonus is handed to the
 *                                   ;   ATTACKER as an ambush value
 *             [0x8D00] |= 0x80      ; "AMBUSH!" flag
 *  FORTIFIED-ORDER bonus (any branch):                  @asm 0x007EFE..0x007F21
 *     if def order [+0x314C] == 6 and def is not a ship (type 0x0D..0x12)
 *        and bonus < 5:   bonus += 2 (+50%);  [0x8D03] |= 0x20
 *
 * MODIFIER-FLAG MAP (the odds-dialog lines; attacker-side bits are set by the
 * caller func_05CA7E — see ai/unit_ai_leaf.c):
 *   [0x8D00] bit7 0x80  AMBUSH (attacker receives [0x8D04] terrain value)
 *   [0x8D02] bit3 0x08  in native settlement (+50%)
 *   [0x8D02] bit4 0x10  aggressive-tribe settlement (+100% replaces +50%)
 *   [0x8D02] bit5 0x20  settlement is the tribal CAPITAL (x2)
 *   [0x8D02] bit6 0x40  colony fortification ((level+1)*2 quarters)
 *   [0x8D02] bit7 0x80  terrain defense bonus (column 0x2F77)
 *   [0x8D03] bit5 0x20  unit FORTIFIED order (+50%, capped: only if bonus<5)
 *   [0x8D04]            ambush terrain value handed to the attacker
 * Attacker-side (func_05CA7E sites): [0x8D01] bits 0/3/4/7, [0xA156] bit3,
 * [0xA158] bit0, [0x8D03] bits 1/2 — see unit_ai_leaf.c for the set sites.
 *
 * NEW IDENTITIES pinned by this body:
 *   unit[+0x314C] = ORDER STATE byte; 6 = FORTIFIED (cross-ref: the Europe
 *     purchase dialog sets 0/1 = at-sea/on-dock for new units)
 *   0x2F77 = terrain DEFENSE column (terrain table 0x2F74 stride 16: +2 move
 *     cost, +3 defense)
 *   0x5AD8 stride 0x4E = per-tribe row (tech/aggression byte at +0)
 *   settlement[+0x54EF] bit2 = CAPITAL flag
 * ============================================================================ */
int defend_strength_007D3E(int def_unit, int atk_unit);  /* documented above */
