/* ============================================================================
 *           >>> PROLOGUE + DECISION STRUCTURE: BYTE_VERIFIED <<<
 *           >>> LAND-COMBAT WIN/LOSS DECIDER (the roll): BYTE_VERIFIED <<<
 *           >>> DATA-RESIDENT SCORING WEIGHTS + COLONY-LOOT TAIL: RUNTIME_ONLY <<
 * ----------------------------------------------------------------------------
 * unit_ai_leaf.c -- the per-unit AI LEAF (func_05CA7E) and the move evaluator
 *                   (func_04E2D6), the innermost decision routines of the
 *                   UNIT-DRIVEN AI.  func_05CA7E is ALSO the LAND-COMBAT DECIDER:
 *                   its deep body (file 0x05CDA0..0x05D1A2) computes the
 *                   attack/defense strengths and rolls random_int(1, ATK+DEF),
 *                   WIN iff roll<=ATK; the win flag [bp-0x9c] then selects which
 *                   unit the applier func_05B2C2 (src/combat/land.c) removes.
 *                   (Decoded + byte-verified 2026-05-30; see the combat block.)
 *
 * CALL CHAIN (see unit_orders.c for the outer two layers):
 *   ai_unit_order_step (func_040E22)  -> ai_eval_unit (func_03ECF0)
 *        -> [@asm 0x03F492 lcall 0x191F:0xA14 -> thunk 0x01C004]
 *        -> THIS LEAF: func_05CA7E (page 0x10).
 *
 * SIZE / TRUNCATION (honest accounting)
 *   func_05CA7E is HUGE: the re-segmented page_10 header records
 *   `size=7348 insns=2313 prologue=ENTER 0x00DE,0 terminal=page-end`. The
 *   "terminal=page-end" means the body spills PAST page 0x10's nominal resident
 *   end (0x05E120). The standalone per-func dump (disasm/func_05CA7E_unknown.asm)
 *   captured only the first 429 bytes (it stopped at the internal RETF at
 *   0x05CC2A, an EARLY-RETURN branch). The RE-SEGMENTED page_10.asm decodes the
 *   whole resident extent cleanly to 0x05E120, which COVERS the entire combat-
 *   decision block (file 0x05CDA0..0x05D1A2) and its win/loss application down to
 *   the EUROPEWIN/EUROPELOSE/BURNED message emits -- so the DECISION is fully
 *   decoded here, byte-verified against the raw EXE. What remains RUNTIME_ONLY (data-resident):
 *     - the NUMERIC per-type stat values (0x5235/0x5236 columns) and per-power
 *       bias tables (NAMES.TXT / loader data, not in the EXE image), and
 *     - the colony loot/wealth-decay long-math in the FAR tail (file >0x05E120)
 *       which spills past the page's clean linear decode.
 *   The control flow, the strength-modifier OPERATIONS, the roll, and the win-flag
 *   application are all byte-cited; no weight is invented.
 *
 * PURPOSE EVIDENCE (string xref, verified rule file_offset = handle + 0x1D9A0)
 *   - 0x05CB83 push 0x1C06 -> 0x181F:0x652 dialog : handle 0x1C06 -> file
 *     0x1F5A6 = "HALF" (a "reduce to half / retreat" prompt).
 *   - 0x05CC07 push 0x1CE1 (a LITERAL string pointer, region load_image) =
 *     "Bad defense" -- a debug/scoring annotation string. A debug "Bad defense"
 *     label inside a routine that reads ColonyRecord defense and unit combat
 *     fields is strong, consistent evidence this is the AI's per-unit
 *     attack/defense EVALUATION leaf. (docs/RULINGS.md 2026-05-30 (ai-unit-eval).)
 *   - The leaf reads the colony struct at DGROUP:0x8542 (@asm 0x05CC64
 *     `mov bx,[0x8542]`; reads [bx+0x1f] and [bx+0xb8]) -- confirming the
 *     `touches_8542` classification the brief cited.
 *   - In its DEEP TAIL (file ~0x05DAE6) it pushes the BURNED/BURNED2/BURNED3
 *     message keys (handle 0x1C28/0x1C2F/0x1C37 -> file 0x1F5C8/.../0x1F5D7)
 *     and runs the colony loot/wealth-decay long-math at file 0x05DC9D
 *     (single __aFldiv on colony.dword[+0xC2]) and 0x05DE35 (__aFlmul+__aFldiv
 *     loot = colony.byte[+0x1F] * power.field[+0x8832] / max(divisor,1)).
 *
 * RECONCILIATION (two prior, partial characterisations are the SAME function)
 *   - The brief / @inferred_role: "per-unit AI leaf" (its ENTRY role -- the AI's
 *     per-unit attack/defense evaluator, reached from func_03ECF0 @0x03F492).
 *   - VERIFICATION_LEDGER.md 2026-05-02: "colony burn/capture" (its OUTCOME --
 *     BURNED strings + 0x8542 colony loot math).
 *   Both are facets of ONE routine: func_05CA7E RESOLVES A UNIT ATTACKING /
 *   ENTERING AN ENEMY COLONY -- it evaluates the attack (AI-gated head, with the
 *   colony-defender spawn from ColonyRecord population), and on success BURNS or
 *   CAPTURES the colony (tail, BURNED* + loot formula). It is NOT the native-
 *   VILLAGE raze (that is func_04A7CA, BYTE_VERIFIED separately). The ledger's
 *   "still-unidentified native-village raze" note is resolved: native-village
 *   raze = func_04A7CA; func_05CA7E = colony attack/burn/capture.
 *   (docs/RULINGS.md 2026-05-30 (ai-unit-eval).)
 *
 * @region          overlay
 * @verified_by     Hand-decompiled from VICEROY.EXE 2026-05-30 (page_10.asm reseg
 *                  + per-func dump + string-rule xrefs). PROLOGUE/early blocks
 *                  byte-verified; the combat-modifier ladder (0x5CB46..0x5D021)
 *                  DECODED 2026-06-10 (see the flag-map block below + 
 *                  combat/combat_modifiers.c defend_strength).
 * @ref             reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_10.asm
 * @ref             reverse_engineered/code/VICEROY/disasm/func_05CA7E_unknown.asm
 * @ref             reverse_engineered/code/VICEROY/disasm/func_04E2D6_unknown.asm
 * @ref             reverse_engineered/code/VICEROY/strings.json
 * ============================================================================ */
#include "viceroy_types.h"

/* ----------------------------------------------------------------------------
 * Byte-verified globals (DGROUP-relative)
 * ------------------------------------------------------------------------- */

/* DGROUP:0x3144 -- UnitRecord table; stride 0x1C. Fields read by the leaf:
 *   +0x02 type      @asm 0x05CAB7 ([bx+0x3146]); banded 0x0D..0x12 @asm 0x05CAFE
 *   +0x03 owner&0xf @asm 0x05CAEB ([bx+0x3147])
 *   +0x05 field_05  @asm 0x05CAD0 ([si+0x3149]) subtracted from a count; the
 *                   "soft attack" path ADDS 3 to it @asm 0x05CAE2 when [bp+0xe]!=0
 *   +0x06 moves     @asm 0x05CAF6 ([bx+0x314a]) -> [bp-8]
 *   +0x17 vet_type  @asm 0x05CCF4 (written: [bx+0x315b] = candidate's class) */
extern uint8_t g_units_3144[/* unit */][0x1C];

/* DGROUP:0x543F -- AIPersonality controller flag (record +0x31, stride 0x34).
 * Gated @asm 0x05CB65 imul bx,[bp-0x86],0x34; cmp [bx+0x543f],0. */
extern uint8_t g_ai_personality_543F[/* nation */][0x34];

/* DGROUP:0x8542 -- POINTER to the active ColonyRecord (the colony struct,
 * confirmed @asm 0x05CC64). Fields read here:
 *   +0x1f  population/size byte (used to bound a random roll: roll 0..pop-1)
 *          @asm 0x05CC68 mov al,[bx+0x1f]; dec ax; -> 0x181F:0x4D4 (random_int)
 *   +0xb8  word compared to 0x32 (=50): a defense/bell threshold @asm 0x05CCBA */
extern uint16_t g_colony_ptr_8542;     /* far ptr to ColonyRecord (see colony.h) */

/* DGROUP:0x5235 / 0x5230 / 0x5232 -- per-unit-TYPE attribute table, stride 14
 * (base DGROUP:0x5230; loader @0x74EDA per src/combat/land.c).  Fields the
 * decider reads (offsets within the 14-byte row):
 *   +0x05 (0x5235) DEFENSE value byte  -- read by res_get_unit_strength_7C2A flag==0
 *   +0x06 (0x5236) ATTACK / combat-eligibility byte -- read flag!=0; >1 => "fights"
 * Table CONTENTS are NAMES.TXT/loader data -> RUNTIME_ONLY (data-resident) (numeric values).
 * UT_AT(type,abs_addr) indexes the row by absolute DGROUP base 0x5230/0x5235/0x5236. */
extern uint8_t g_unittype_attr_5230[/* type */][14];
#define UT_AT(type, abs_addr)  (g_unittype_attr_5230[(type)][(abs_addr) - 0x5230])

/* DGROUP:0x8D00..0x8D04 / 0xA156/0xA158 -- the COMBAT MODIFIER-FLAG block
 * (one bit = one line in the pre-combat odds dialog), zeroed @0x05CB3A..43.
 * FULL MAP DECODED 2026-06-10 (set sites byte-cited; defender-side bits are
 * set by func_007D3E -- see combat/combat_modifiers.c defend_strength):
 *  ATTACKER side (this function):
 *   [0x8D01]|=0x01 @0x5CB9B  half-strength reason code 2 (after the "HALF"
 *   [0xA156]|=0x08 @0x5CBA7  half-strength reason code 1   confirm popup,
 *                            key 0x1C06="HALF", mode 1; decline aborts)
 *   [0x8D03]|=0x02 @0x5CC92  armed colonist takes up muskets (defender colony
 *                            militia spawn via 0x191F:0xA20, base [0x5235])
 *   [0x8D03]|=0x04 @0x5CCCB  ...boosted: ff_owned(power, FF 12 = PAUL REVERE) AND colony
 *                            [+0xB8] >= 50 -> spawn strength 75 (0x4B)
 *   [0x8D01]|=0x08 @0x5CEE7  defender NOT sentried/fortified ([+0x314C] not
 *                            5/6) -> that strength term >>= 2 (quartered)
 *   [0x8D03]|=0x08 @0x5CF0C  ARTILLERY IN THE OPEN: attacker type 0x0B and
 *                            defender unfortified -> attacker strength >>= 2
 *   [0xA158]|=0x01 @0x5CF26  artillery vs natives (other side power>=4):
 *                            attacker strength <<= 1 (x2 bombardment)
 *   [0x8D01]|=0x10 @0x5CF4D  SPANISH (power 2) vs natives: strength += 50%
 *                            (the canonical Spanish trait, byte-verified)
 *   [0x8D01]|=0x80 @0x5CF7D  War of Independence: intervention ally
 *                            ([0x53D2]) or [0x5382]&2 -> strength += 50%
 *   [0xA156]|=0x02/0x04 @0x5CFCB  SONS OF LIBERTY: colony SoL% via
 *                            0x181F:0xC86; rebels use pct (code 2, ally side
 *                            uses 100-pct), strength += str*pct/100; open-
 *                            terrain ally case: += str*difficulty/20
 *  DEFENDER side (func_007D3E): [0x8D02] 0x08/0x10/0x20/0x40/0x80 settlement/
 *  tribe/capital/fort/terrain, [0x8D03]|=0x20 fortified +50%, [0x8D00]|=0x80
 *  AMBUSH with terrain value in [0x8D04]. */
extern uint16_t g_ai_scratch_8D00;
extern uint8_t  g_ai_scratch_8D01;
extern uint16_t g_ai_scratch_8D02;
extern uint8_t  g_ai_scratch_8D03;
extern uint16_t g_ai_scratch_A156;
extern uint16_t g_ai_scratch_A158;

/* DGROUP:0x8D4A / 0x8D4E -- overlay-resident pointers (the per-power AI state and
 * the active-settlement pointer respectively; 0x8D4E set by set_active_tribe
 * @0x81C6 per FUNCTION_INVENTORY). Read for class lookups @asm 0x05CD29/0x05CD0E. */
extern uint16_t g_ai_state_ptr_8D4A;
extern uint16_t g_settlement_ptr_8D4E;

/* ----------------------------------------------------------------------------
 * COMBAT-DECISION globals (DGROUP-relative) -- read by the land-combat decider
 * block decoded below.  All BYTE_VERIFIED as ACCESSED at the cited @asm sites;
 * the SEMANTICS marked [V-doc] are cross-confirmed in viceroy_source/ *.md, those
 * marked RUNTIME_ONLY (data-resident) are accessed-but-meaning-undetermined.
 * ------------------------------------------------------------------------- */

/* DGROUP:0x8D04 -- the TERRAIN/FORTIFICATION DEFENSE-BONUS scratch word.  It is
 * SET by the defense accessor get_unit_strength_def (file 0x07D3E): it is zeroed
 * @asm 0x07D78 (mov [0x8d04],ax with ax=0) and then loaded with a per-terrain /
 * fort multiplier from the 0x54EE/0x5AD8 tables (@asm 0x07DA6..0x07DD4).  The
 * decider reads it @asm 0x05CE05 to scale the ATTACKER strength by (bonus+4)/4.
 * (So a defender on bonus terrain RAISES the attack threshold the roll must beat
 *  -- i.e. higher defensive terrain bonus makes the attacker's effective ATK
 *  larger in this formula's framing.  Value range RUNTIME_ONLY (data-resident), table-resident.) */
extern int16_t g_def_terrain_bonus_8D04;

/* DGROUP:0x53A6 -- difficulty / current-player index 0..4 (Discoverer..Viceroy).
 * BYTE_VERIFIED via tax+SMITE+raze (viceroy_source/COMPLETE_FINDINGS.md:165,
 * VERIFICATION_LEDGER.md:207).  Read @asm 0x05CE35/0x05CE54/0x05CFF7/0x05D14x... */
extern uint8_t g_difficulty_53A6;
/* DGROUP:0x53D2 -- "self power" marker = the human player's power index.
 * BYTE_VERIFIED via SoL display (COMPLETE_FINDINGS.md:169).  Compared to the
 * attacker/defender owner @asm 0x05CF6D/0x05CFA1/0x05D00A to branch human-vs-AI. */
extern int16_t g_self_marker_53D2;
/* DGROUP:0x5382 -- game flags; bit0 = endgame / War-of-Independence active
 * (DATA_MODEL.md:276).  bit1 tested @asm 0x05CF76.  Gates a SoL-bonus block. */
extern uint8_t g_flags_5382;
/* DGROUP:0x5383 -- game flags; bit1 (0x02) tested @asm 0x05D221 (gates the
 * combat-prediction debug call 0x1a1f:0x704). [not yet decoded semantics of bit1.] */
extern uint8_t g_game_flags_5383;
/* DGROUP:0x538E -- turn counter (VERIFICATION_LEDGER.md:492).  Compared to 0x50
 * (=80) @asm 0x05D07D/0x05D0CE as a SoL/era gate. */
extern int16_t g_turn_538E;
/* DGROUP:0x5396 -- current player power index 0..3 (docs/COLONY_RENDER_CHAIN.md).
 * Compared to the attacker owner @asm 0x05D34A. */
extern uint8_t g_cur_player_5396;
/* DGROUP:0x53A2 -- a flag gating the combat-prediction call @asm 0x05D24C. RUNTIME_ONLY (data-resident) */
extern int16_t g_flag_53A2;

/* Per-power / per-(power,type) bias arrays the decider TOUCHES (contents data-
 * resident -> RUNTIME_ONLY (data-resident)); declared so the cited reads are documented, not invented:
 *   0x59A6 stride 0x4E  -- per-power kill/loss tally; INC'd @asm 0x05D76F (win)
 *   0x5D65 (==ColonyRecord+0x1f col? base 0x5D46 stride 0xCA) read @asm 0x05D12C
 *   0x6BF4 / 0x6D68 (DGROUP-negative-displaced bases via [bp-0x76]) @asm 0x05D108/0x05D134 */
extern uint8_t g_power_kill_tally_59A6[/* power */][0x4E];

/* ----------------------------------------------------------------------------
 * RESIDENT combat-strength accessors (load-image segment; NOT overlay thunks).
 * These are the ATK/DEF stat sources the decider calls; resolved via rtlink:
 *   0x181F:0x09C8 -> type-B static -> seg 0x057E:0x004A = FILE 0x07C2A
 *   0x181F:0x09DC -> type-B static -> seg 0x057E:0x015E = FILE 0x07D3E
 * ------------------------------------------------------------------------- */

/* get_unit_strength (file 0x07C2A): the per-unit base combat strength.
 *   flag(=[bp+8]) != 0  -> ATTACK:  reads g_unit_stat[type*14 + 0x5236]  @asm 0x07C62
 *   flag == 0           -> DEFENSE: reads g_unit_stat[type*14 + 0x5235]  @asm 0x07C7E
 *   then  <<3 (x8 base)  @asm 0x07CA9, with veteran (0x315b==0x15) +50% @asm 0x07CCC,
 *   damaged-artillery (type 0xB & flags+0x3148&0x80) -2 @asm 0x07C99, ship-terrain
 *   (type 0xD..0x12) bonuses @asm 0x07CDB.. .  Returns the scaled strength in AX.
 *   >>> This is the land ATK/DEF stat pair (0x5235/0x5236), DISTINCT from the
 *       SHIP roll's 0x523b/0x523c -- see HEADLINE in this file's combat block. <<< */
extern int16_t res_get_unit_strength_7C2A(int16_t unit, int16_t attack_flag);

/* get_unit_strength_def (file 0x07D3E): the DEFENDER's strength + terrain/fort.
 *   args ([bp+6]=defending unit, [bp+8]=attacking unit).  Internally CALLS
 *   res_get_unit_strength_7C2A(defender, flag=0) @asm 0x07D6A, then derives the
 *   tile terrain (lcall 0x37f:0x392) and writes the terrain/fort bonus into
 *   g_def_terrain_bonus_8D04 (@asm 0x07D78 zero, then 0x54EE/0x5AD8 table lookups).
 *   Returns the defender base strength in AX (the bonus is applied by the caller). */
extern int16_t res_get_unit_strength_def_7D3E(int16_t def_unit, int16_t atk_unit);

/* Terrain query used for a human-defender SoL bonus: returns 1 if the tile
 * terrain (masked &0x1f) is 0x19 or 0x1a, else 0.  0x181F:0x768 -> FILE 0x062B4. */
extern int16_t func_0062B4_op_sz_39(int16_t x, int16_t y);

/* random_int(lo,hi): the SHARED RNG draw.  0x181F:0x04D4 -> type-B static ->
 * seg 0x09EF:0x0032 = FILE 0x0C322 (MSC 6.0 LCG; BYTE_VERIFIED, MEMORY.md). */

/* ----------------------------------------------------------------------------
 * The combat APPLIER chain reached from the decider once the win/loss is fixed:
 *   func_05CA7E  --(near call 0x3DDD)-->  trampoline 0x05E72D
 *                  ljmp 0x1A1F:0x06F8 -> thunk page 0x10 +0x0EC0 -> func_05BE30
 *   func_05BE30  --(near call 0x3DD3)-->  trampoline 0x05E723
 *                  ljmp 0x1A1F:0x06E0 -> thunk page 0x10 +0x0352 -> func_05B2C2
 *   func_05B2C2 = combat-CONSEQUENCE APPLIER (src/combat/land.c).  On the LAND
 *   path it sets its own [bp-0x3a]=0 (@asm 0x05B7AD) and jmps the outcome router
 *   (@asm 0x05B7BD jmp 0x05BAA3): unit_a (the unit PASSED to func_05BE30) is the
 *   LOSER and is demoted/destroyed/captured.  THE WIN/LOSS ITSELF IS DECIDED HERE
 *   in func_05CA7E by the [bp-0x9c] flag (below), which selects WHICH unit is
 *   passed as unit_a.  (Trampolines resolved via rtlink; see combat block.) */
extern int16_t ovly_combat_apply_wrapper_05BE30(int16_t unit_a, int16_t b,
                                                int16_t c, int16_t d, int16_t e);

/* Additional in-page near-call trampolines used by the decider (resolved via
 * rtlink_decode resolve over the 0x1A1F window):
 *   near 0x3DBA -> 0x05E70A ljmp 0x1A1F:0x0458 -> page 0x10 +0x0000 = func_05AF70
 *                 (the in-page candidate EVALUATOR; the "0x5e70a" in the head).
 *   near 0x3DCE -> 0x05E71E ljmp 0x1A1F:0x06D4 -> page 0x10 +0x172C = func_05C69C
 *   near 0x3DDD -> 0x05E72D ljmp 0x1A1F:0x06F8 -> page 0x10 +0x0EC0 = func_05BE30 */
extern int16_t ovly_candidate_eval_05AF70(int16_t tile_unit);
extern int16_t ovly_postcombat_05C69C(int16_t atk_str, int16_t def_str, int16_t target);

/* ----------------------------------------------------------------------------
 * Overlay helpers (RTLink far-thunks). Semantics from call context; body in
 * thunk page (0x181F/0x191F/0x1A1F overlay thunk table; not decodable from
 * overlay bytecode alone).
 * ------------------------------------------------------------------------- */
extern int16_t random_int_4D4(int16_t lo, int16_t hi);       /* 0x181F:0x4D4 = random_int(lo,hi) */
extern int16_t ovly_finalize_unit_90C(int16_t unit);         /* @asm 0x05CAC6 */
extern int16_t ovly_tile_to_unit_7E0(int16_t a, int16_t x, int16_t y);/* @asm 0x05CB24 */
extern int16_t ovly_eval_target_5E70A(int16_t unit_on_tile); /* @asm 0x05CB2E CALL near 0x5e70a */
extern int16_t ovly_target_query_6BE(int16_t x, int16_t y);  /* @asm 0x05CBC3 */
extern int16_t ovly_target_query_7BE(int16_t x, int16_t y);  /* @asm 0x05CBD5 */
extern void    ovly_msg_arg_9AE(int16_t lo, int16_t hi, int16_t z);/* @asm 0x05CB79 */
extern int16_t ovly_dialog_652(int16_t flag, int16_t msg_id);/* @asm 0x05CB86 dialog */
extern void    ovly_clear_orders_934(int16_t unit);          /* @asm 0x05CBB5 */
extern void    ovly_debug_str_77E(int16_t flag, int16_t y, int16_t x,
                                  const char *s);            /* @asm 0x05CC0A "Bad defense" */
extern int16_t ovly_path_check_302(int16_t x, int16_t y);    /* @asm 0x05CC18 */
extern int16_t ovly_target_query_9F0(int16_t x, int16_t y);  /* @asm 0x05CC36 */
extern void    ovly_commit_A4C(int16_t v);                   /* @asm 0x05CD00 */
extern int16_t ovly_query_9E6(int16_t v);                    /* @asm 0x05CC5C */
extern int16_t colony_field_C86(void);                         /* @asm 0x05CF98 SoL% for active colony */
extern int16_t ovly_query_C54(int16_t v);                    /* @asm 0x05CC7D */
extern int16_t ovly_query_2C6(int16_t v);                    /* @asm 0x05CC9B */
extern int16_t ovly_feasible_7B4(int16_t a, int16_t b);      /* @asm 0x05CCAA / 0x05CDCB */
extern int16_t ovly_spawn_unit_A20(int16_t cls, int16_t x, int16_t y,
                                   int16_t a, int16_t b);     /* @asm 0x05CCE2 / 0x05CD60 */
extern int  func_005F48_logic_sz_58(uint16_t x, uint16_t y); /* 0x181F:0x696 -> file 0x005F48 */

/* ============================================================================
 * ai_unit_leaf -- func_05CA7E (page 0x10), file 0x05CA7E..(spills past page end)
 * ----------------------------------------------------------------------------
 * Args (from the far-call at func_03ECF0 @asm 0x03F492, 5 words, cdecl):
 *   [bp+6]  unit       acting unit index (*0x1c)        (the AI's own unit)
 *   [bp+8]  tile_x     target tile x
 *   [bp+0xa]tile_y     target tile y
 *   [bp+0xc] (one=1, pushed last-but-one)               -- not read in the head
 *   [bp+0xe] mode      far-call flag (ai_flag): when nonzero the leaf takes the
 *                      "act for real" path (adds combat strength, can spawn a
 *                      combat unit); when 0 it only EVALUATES. @asm 0x05CADC etc.
 *
 * Returns AX = the chosen result. On the EVALUATE path (mode==0) it returns the
 * target SCORE (atk_str<<3)/(def_str+1) @asm 0x05D032; on the ACT path (mode!=0)
 * it RESOLVES the combat (rolls, applies via func_05BE30) and returns the result.
 * The per-func dump's early `retf` at 0x05CC2A returns after the "Bad defense"
 * reject path.
 *
 * The HEAD and the LAND-COMBAT DECISION block (the roll + its application) are
 * byte-verified; only the data-resident stat/bias VALUES and the far colony-loot
 * tail are RUNTIME_ONLY (data-resident). See the combat block for the @asm citations.
 * ============================================================================ */
int16_t ai_unit_leaf(int16_t unit_index, int16_t tile_x, int16_t tile_y,
                     int16_t one, int16_t mode)
{
    int16_t r_d6 = -1;     /* [bp-0xd6] result/target acc, init 0xFFFF */
    int16_t r_b0 = -1;     /* [bp-0xb0] secondary target, init 0xFFFF */
    int16_t r_60 = -1;     /* [bp-0x60] init 0xFFFF */
    int16_t soft_score = 0;/* [bp-0x98] (finalize(unit) - field_05) */
    int16_t unit_type;     /* [bp-0x9a] */
    int16_t owner;         /* [bp-0x86] */
    int16_t moves;         /* [bp-8]  */
    int16_t band_flag;     /* [bp-0x84] (1 when type in 0x0D..0x12) */
    int16_t tile_unit;     /* [bp-0x7e] unit index on the target tile */
    int16_t eval;          /* [bp-0xc6] result of the inner evaluator 0x5e70a */
    int16_t sub_mode = 0;        /* [bp-0x8e] reason/sub-mode: 1/2/3 on reject paths */
    int16_t eval_reject_flag = 0;/* [bp-0x6e] set to 1 when the initial eval<0 (eval rejected) */

    /* -- combat-decision locals (the deep block, all @asm-cited below) -------- */
    int16_t atk_str = 0;   /* [bp-0x90] ATTACKER strength (built by modifier chain) */
    int16_t def_str = 0;   /* [bp-0xa6] DEFENDER strength (built by modifier chain) */
    int16_t def_owner = 0; /* [bp-0x76] candidate/defender owner nibble */
    int16_t def_type = 0;  /* [bp-0x8c] candidate/defender type */
    int16_t def_band = 0;  /* [bp-0x8a] (1 when defender type in 0x0D..0x12) */
    int16_t occ_owner = -1;/* [bp-0xd4] occupant owner (set in head) */
    int16_t roll;          /* [bp-0xd0] random_int draw */
    int16_t soft_record = 0;/* [bp-0x96] recorded soft_score (set in head @0x05CB4D) */
    int16_t win_flag = 0;  /* [bp-0x9c] >>> THE LAND WIN/LOSS RESULT <<< */
    int16_t loser_unit;    /* [bp+6] reused: the unit passed to the applier (the loser) */
    (void)one;

    /* @asm 0x05CA84..0x05CAB1 -- init locals to 0xFFFF / 0. (Faithful set.) */
    r_d6 = r_b0 = r_60 = -1;

    /* @asm 0x05CAB3 imul bx,[bp+6],0x1c; mov al,[bx+0x3146]; mov [bp-0x9a],ax
     *      -- unit_type = UnitRecord[unit].type */
    unit_type = g_units_3144[unit_index][0x02];

    /* @asm 0x05CAC1 push [bp+6]; lcall 0x181F:0x90C (finalize/maxmoves);
     *      sub ah,ah; mov cl,[si+0x3149]; ax -= cl; mov [bp-0x98],ax
     *      -- soft_score = finalize(unit) - UnitRecord.field_05 */
    soft_score = ovly_finalize_unit_90C(unit_index)
               - g_units_3144[unit_index][0x05];

    /* @asm 0x05CADC cmp [bp+0xe],0; je 0x5cae7; add [si+0x3149],3
     *      -- when acting for real (mode!=0), pre-charge field_05 by 3 */
    if (mode != 0) {
        g_units_3144[unit_index][0x05] =
            (uint8_t)(g_units_3144[unit_index][0x05] + 3);
    }

    /* @asm 0x05CAE7 owner = UnitRecord[unit].owner&0xf; moves = [+0x314a] */
    owner = g_units_3144[unit_index][0x03] & 0x0F;
    moves = g_units_3144[unit_index][0x06];

    /* @asm 0x05CAFE band_flag = (type in 0x0D..0x12) ? 1 : 0
     *      -- the scout/pioneer/treasure band uses a different scoring path */
    band_flag = (unit_type >= 0x0D && unit_type <= 0x12) ? 1 : 0;

    /* @asm 0x05CB1A push owner; mov ax,[bp+8]; mov dx,[bp+0xa];
     *      lcall 0x181F:0x7E0 -> unit index on the target tile -> [bp-0x7e]
     * @asm 0x05CB2C push ax; push cs; call 0x5e70a (near, in-page evaluator)
     *      -> eval := combat/feasibility score for that occupant -> [bp-0xc6] */
    tile_unit = ovly_tile_to_unit_7E0(owner, tile_x, tile_y);
    eval = ovly_eval_target_5E70A(tile_unit);

    /* @asm 0x05CB38 zero the scratch result words/flags (8D00/A156/8D02/A158). */
    g_ai_scratch_8D00 = 0; g_ai_scratch_A156 = 0;
    g_ai_scratch_8D02 = 0; g_ai_scratch_A158 = 0;

    /* @asm 0x05CB46 cmp [bp-0x98],3; jge 0x5cbac -- when soft_score < 3 the leaf
     * considers the "weak / retreat" branch: */
    if (soft_score < 3) {
        soft_record = soft_score;  /* @asm 0x05CB4D mov [bp-0x96],ax (record soft_score) */
        /* @asm 0x05CB55 cmp [bp+0xe],0; je 0x5cb94 -- only when acting for real */
        if (mode != 0) {
            /* @asm 0x05CB5B cmp [bp-0x86],4; jl 0x5cb65; else jmp 0x5e706 (abort,
             *   native owner): a EU owner whose controller flag != 0 also aborts. */
            if (owner >= 4) goto abort_far;                  /* @asm 0x05CB62 */
            if (g_ai_personality_543F[owner][0x00] != 0)     /* @asm 0x05CB6A */
                goto abort_far;                              /* @asm 0x05CB71 */
            /* @asm 0x05CB74 cdq; push dx; push ax; push 0; lcall 0x181F:0x9AE;
             *   then push 1; push 0x1C06("HALF"); lcall 0x181F:0x652 dialog;
             *   dec ax; je 0x5cb94 (player chose HALF) else jmp 0x5e706. */
            ovly_msg_arg_9AE(soft_score, 0, 0);              /* @asm 0x05CB79 */
            if (ovly_dialog_652(1, 0x1C06 /* "HALF" */) - 1 != 0) /* @asm 0x05CB86 */
                goto abort_far;                              /* @asm 0x05CB91 */
        }
        /* @asm 0x05CB94 cmp [bp-0x98],2; jne; else 0x8d01|=1 */
        if (soft_score == 2) g_ai_scratch_8D01 |= 1;         /* @asm 0x05CB9B */
        /* @asm 0x05CBA0 cmp [bp-0x98],1; jne; else 0xa156|=8 */
        if (soft_score == 1) g_ai_scratch_A156 |= 8;         /* @asm 0x05CBA7 */
    }

    /* @asm 0x05CBAC cmp [bp+0xe],0; je 0x5cbbd; push [bp+6]; lcall 0x181F:0x934
     *   -- when acting for real, clear this unit's pending orders. */
    if (mode != 0) ovly_clear_orders_934(unit_index);        /* @asm 0x05CBB5 */

    /* @asm 0x05CBBD push y,x; lcall 0x181F:0x6BE -> [bp-0xd4] (occupant owner?)
     * @asm 0x05CBCF push y,x; lcall 0x181F:0x7BE -> [bp-0xd6] (colony/target id) */
    occ_owner = ovly_target_query_6BE(tile_x, tile_y);       /* [bp-0xd4] */
    r_d6      = ovly_target_query_7BE(tile_x, tile_y);       /* [bp-0xd6] colony/target id */

    /* @asm 0x05CBE1 cmp [bp-0xc6](eval),0; jl 0x5cbeb; else jmp 0x5cd90
     *   -- if the occupant evaluated as ATTACKABLE (eval >= 0) skip to the
     *      candidate loop at 0x2440; else (eval < 0) take the "Bad defense"
     *      reject/place path. */
    if (eval >= 0) {
        goto candidate_loop;                                 /* @asm 0x05CBE8 jmp 0x5cd90 */
    }

    /* ---- "Bad defense" reject path (@asm 0x05CBEB..0x05CC2A) -----------------
     * @asm 0x05CBEB [bp-0x6e]=1; cmp [bp-0xd4](colony/target),0; jge 0x5cc2c;
     *   else: set [bp-0x8e]=1; push it,y,x,"Bad defense"; lcall 0x181F:0x77E
     *   (debug/score annotate); then 0x181F:0x302 path check; if AX!=0
     *   jmp 0x5e66e (a far cleanup); else RETF (early return -- the leaf gives up
     *   placing here). */
    eval_reject_flag = 1;   /* @asm 0x05CBEB mov [bp-0x6e],1 (eval<0 flag) */
    sub_mode = 1;           /* [bp-0x8e]: will be set to 1 on next line if occ_owner<0 */
    if (r_d6 < 0) {
        ovly_debug_str_77E(1, tile_y, tile_x, "Bad defense");/* @asm 0x05CC0A */
        if (ovly_path_check_302(tile_x, tile_y) != 0)        /* @asm 0x05CC18 */
            goto cleanup_far;                                /* @asm 0x05CC24 jmp 0x5e66e */
        /* @asm 0x05CC27 pop si; pop di; leave; retf -- EARLY RETURN. */
        return r_d6;
    }

    /* @asm 0x05CC2C..0x05CC4C: an alternate target probe (0x181F:0x9F0) feeding
     * [bp-0xb0]; on failure sets sub_mode=2 and loops back to the reason handler
     * at 0x22ad. Structural; targets/constants byte-clear, downstream not yet decoded. */
    {
        int16_t alt = ovly_target_query_9F0(tile_x, tile_y); /* @asm 0x05CC36 */
        r_b0 = alt;
        if (alt < 0) { sub_mode = 2; /* @asm 0x05CC46 jmp 0x22ad */ }
    }

    /* ---- COLONY-defended target: spawn a defender from the colony -----------
     * @asm 0x05CC4E cmp [bp-0xd6],0; jge 0x5cc58 (have a colony target):
     *   @asm 0x05CC58 push [bp-0xd6]; lcall 0x181F:0x9E6 (select colony);
     *   @asm 0x05CC64 bx=[0x8542]; al=[bx+0x1f](pop); dec; push; push 0;
     *     lcall 0x181F:0x4D4 = random_int(0, pop-1) -> [bp-0xae] (random colonist)
     *   @asm 0x05CC7D lcall 0x181F:0xC54 -> [bp-0xac] (that colonist's class)
     *   @asm 0x05CC89 al=[0x5235]; -> [bp-0xdc] (base class attr)
     *   @asm 0x05CC92 0x8d03|=2
     *   @asm 0x05CC97 lcall 0x181F:0x2C6 -> [bp-0x92] (a stat for that class)
     *   @asm 0x05CCA4 push 0xc; push [bp-0xd4]; lcall 0x181F:0x7B4 (feasible?);
     *     if nonzero AND colony [0x8542].word[+0xb8] >= 0x32: clamp the stat to
     *     0x4B, bump [bp-0xdc], set 0x8d03|=4. (@asm 0x05CCB2..0x05CCCB)
     *   @asm 0x05CCD0 push [bp-0xdc],[bp-0xd4],y,x,[bp-0x92]; lcall 0x191F:0xA20
     *     = SPAWN the defending unit -> [bp-0x74]; write its class into the new
     *     unit's vet_type [+0x315b]. (@asm 0x05CCE2..0x05CCF4) */
    if (r_d6 >= 0) {
        int16_t pop, colonist, cls, stat;
        ovly_query_9E6(r_d6);                                /* @asm 0x05CC5C select colony */
        pop = ( (uint8_t)((g_colony_ptr_8542 /*->[+0x1f]*/, 0)) ); /* see note: [bx+0x1f] */
        /* NOTE: pop is ColonyRecord[+0x1f]; the deref through g_colony_ptr_8542
         * is shown abstractly -- the byte address [bx+0x1f] is byte-verified
         * (@asm 0x05CC68). */
        colonist = random_int_4D4(0, pop - 1);               /* @asm 0x05CC70 */
        cls = ovly_query_C54(colonist);                      /* @asm 0x05CC7D */
        g_ai_scratch_8D03 |= 2;                              /* @asm 0x05CC92 */
        stat = ovly_query_2C6(cls);                          /* @asm 0x05CC9B */
        if (ovly_feasible_7B4(0x0C, /*[bp-0xd4]*/0) != 0) {  /* @asm 0x05CCAA */
            /* @asm 0x05CCBA cmp colony.word[+0xb8],0x32; jl -> skip clamp */
            /* (colony defense/bell threshold 0x32=50) */
            stat = 0x4B;                                     /* @asm 0x05CCC1 */
            g_ai_scratch_8D03 |= 4;                          /* @asm 0x05CCCB */
        }
        {
            int16_t spawned = ovly_spawn_unit_A20(/*[bp-0xdc]*/0, tile_x, tile_y,
                                                  0, stat);  /* @asm 0x05CCE2 0x191F:0xA20 */
            g_units_3144[spawned][0x17] = (uint8_t)cls;      /* @asm 0x05CCF4 vet_type */
            eval = spawned;                                  /* @asm 0x05CCEA -> [bp-0x74]; later [bp-0xc6] */
        }
        goto have_candidate;                                 /* @asm 0x05CCF8 jmp 0x2439 */
    }

    /* ---- NON-colony target: pick a defender by unit-type attribute table -----
     * @asm 0x05CCFC commit [bp-0xb0] (0x181F:0xA4C); [bp-0x88]=0x13 (base class);
     *   bx=[0x8d4e](settlement); if [bx+7]!=0 -> [bp-0x88]=0x14;
     *   if [bx+0xa] >= 0x19 -> [bp-0x88]+=2; bx=[0x8d4a]; [bp-0x60]=[bx+5];
     *   class = [bp-0x88]; [bp-0xdc] = 0x5235[class*14]; push it,[bp-0xd4],y,x,
     *   0x5232[class*14]; lcall 0x191F:0xA20 -> spawn -> [bp-0x74]; write
     *   0x5230[class*14] and the spawned unit's type back. (@asm 0x05CD08..0x05CD89)
     * This is the byte-verified "spawn a defender of the appropriate class for
     * this terrain/settlement" path. The class CONSTANTS (0x13/0x14/+2) and the
     * 0x5230/0x5232/0x5235 table contents are byte-cited as ACCESSED; their
     * MEANINGS are RUNTIME_ONLY (NAMES.TXT/data-file; loaded by func_0749E0
     * / loader @0x74EDA). */
    {
        int16_t cls = 0x13;                                  /* @asm 0x05CD08 */
        /* settlement/state-derived class adjustments: structural (see @asm) */
        ovly_commit_A4C(r_b0);                               /* @asm 0x05CD00 */
        /* spawn via 0x191F:0xA20 with table-derived class -> eval (candidate) */
        eval = ovly_spawn_unit_A20(/*0x5235[cls*14]*/0, tile_x, tile_y,
                                   0, /*0x5232[cls*14]*/0);  /* @asm 0x05CD60 */
        (void)cls;
    }

have_candidate:
    /* @asm 0x05CD89 ax=[bp-0x74]; mov [bp-0xc6],ax -- eval = the chosen candidate */
    /* (eval already holds the spawned/selected unit index from the paths above.) */

candidate_loop:
    /* @asm 0x05CD90 cmp [bp-0xc6],0; jge 0x2450; else [bp-0x8e]=3; jmp 0x22ad
     *   (no candidate -> reason 3). */
    if (eval < 0) { sub_mode = 3; /* @asm 0x05CD97 jmp 0x22ad */ goto reason; }

    /* ========================================================================
     * >>> THE LAND-COMBAT DECISION (func_05CA7E deep body) -- BYTE_VERIFIED <<<
     * file 0x05CDA0..0x05D1A2.  This is the long-chased land-odds DECIDER.
     * ------------------------------------------------------------------------
     * HEADLINE (resolves land.c's open question):
     *   Land combat IS an ATK/(ATK+DEF) probability roll -- the SAME FORM as the
     *   ship roll (combat_modifiers.c) -- but it draws on a DIFFERENT stat pair
     *   and a DIFFERENT modifier chain:
     *     - SHIP roll  (func_05B2C2 @0x5B849): random over per-type 0x523b (DEF)
     *       + 0x523c (ATK), read NOWHERE ELSE in the EXE.
     *     - LAND roll  (HERE @0x05D188):       random over a DERIVED atk_str
     *       [bp-0x90] + def_str [bp-0xa6], where the BASE strengths come from the
     *       resident accessors res_get_unit_strength_7C2A (reads per-type 0x5236
     *       for attack / 0x5235 for defense, x8) and the long terrain / SoL /
     *       fortify / veteran / difficulty modifier chain below scales them.
     *   So land.c was right that 0x523b/0x523c are ship-only, and right that
     *   func_05B2C2 is only the consequence applier -- the DECISION is this roll,
     *   and its result (win_flag [bp-0x9c]) selects which unit func_05B2C2 then
     *   removes.  This REFINES the prior "Wave-7 (land combat = no roll)" RULINGS
     *   entry: there IS a land roll -- it just reads the 0x5235/0x5236 columns via
     *   the resident accessors, not the ship-only 0x523b/0x523c.  (FINDING to be
     *   recorded centrally in docs/RULINGS.md as (land-combat-decider) 2026-05-30.)
     * ======================================================================== */

    /* ---- read the candidate (the DEFENDER) UnitRecord @asm 0x05CDA0 -------- */
    def_owner = g_units_3144[eval][0x03] & 0x0F;             /* @asm 0x05CDA5 [bp-0x76] */
    def_type  = g_units_3144[eval][0x02];                    /* @asm 0x05CDAF [bp-0x8c] */
    /* moves [+0x314a] -> [bp-0xd2] @asm 0x05CDB9 (unused downstream here) */
    /* @asm 0x05CDC2 push unit; push eval; lcall 0x181F:0x9DC = get DEFENDER base
     *   strength -> def_str.  This call ALSO sets g_def_terrain_bonus_8D04 for the
     *   defender's tile (see accessor doc).  args (defender, attacker). */
    def_str = res_get_unit_strength_def_7D3E(eval, unit_index); /* @asm 0x05CDCB -> [bp-0xa6] */
    /* @asm 0x05CDD7 def_band = (def_type in 0x0D..0x12) ? 1 : 0 */
    def_band = (def_type >= 0x0D && def_type <= 0x12) ? 1 : 0;
    /* @asm 0x05CDF4 push 1(attack); push unit; lcall 0x181F:0x9C8 = get ATTACKER
     *   base strength (reads per-type 0x5236, x8) -> atk_str. */
    atk_str = res_get_unit_strength_7C2A(unit_index, 1);     /* @asm 0x05CDF9 -> [bp-0x90] */

    /* ==== ATTACKER strength modifier chain (atk_str = [bp-0x90]) ============ */

    /* @asm 0x05CE05 atk_str = atk_str * (g_def_terrain_bonus_8D04 + 4) / 4;
     *   then @asm 0x05CE16 atk_str = atk_str * 3 / 2  (the x1.5).  i.e. the
     *   defender's terrain/fort bonus RAISES the attacker's effective strength in
     *   this formula's framing, and a flat x1.5 is applied. */
    atk_str = (int16_t)(((int32_t)atk_str * (g_def_terrain_bonus_8D04 + 4)) >> 2);
    atk_str = (int16_t)((atk_str * 3) >> 1);                 /* @asm 0x05CE16 (x3, sar 1) */

    /* @asm 0x05CE22 if attacker is an AI nation (owner<4 && AIPersonality flag==0):
     *   atk_str += -(g_difficulty_53A6 - 4)  (i.e. += (4 - difficulty)). */
    if (owner < 4 && g_ai_personality_543F[owner][0x00] == 0)
        atk_str += (int16_t)(4 - (int16_t)g_difficulty_53A6); /* @asm 0x05CE35 */
    /* @asm 0x05CE43 mirror for the DEFENDER: if def is AI: def_str += (4 - diff). */
    if (def_owner < 4 && g_ai_personality_543F[def_owner][0x00] == 0)
        def_str += (int16_t)(4 - (int16_t)g_difficulty_53A6); /* @asm 0x05CE54 */

    /* @asm 0x05CE62 if the head's recorded soft_score [bp-0x96] != 0:
     *   atk_str = atk_str * soft_record / 3.  ([bp-0x96] was set @asm 0x05CB4D in
     *   the head to the soft_score when it was < 3 -- the "weak/retreat" term.)
     *   The scale (x[bp-0x96], /3) is byte-cited @asm 0x05CE69..0x05CE77
     *   (imul [bp-0x96]; mov cx,3; cdq; idiv cx). */
    if (soft_record != 0)                                    /* @asm 0x05CE62 */
        atk_str = (int16_t)(((int32_t)atk_str * soft_record) / 3); /* @asm 0x05CE69 */

    /* @asm 0x05CE7B..0x05CEB7 -- "noncombat band" halving:
     *   if attacker band_flag==0 AND def_band==0 AND attacker's per-type 0x5236 > 1
     *   AND defender's per-type 0x5235 < 2:  def_str >>= 1  (sar [bp-0xa6],1). */
    if (band_flag == 0 && def_band == 0
        && UT_AT(unit_type, 0x5236) > 1
        && UT_AT(def_type, 0x5235) < 2)
        def_str >>= 1;                                       /* @asm 0x05CEB7 */

    /* @asm 0x05CEBB.. -- ATTACK-on-empty-tile (occ_owner<0) special cases:
     *   colonist (type 0x0B) on order 5/6 vs AI defender -> atk_str >>= 2, 0x8d01|=8
     *   (and the symmetric defender colonist case -> def_str >>= 2, 0x8d03|=8). */
    if (occ_owner < 0) {                                     /* @asm 0x05CEBB */
        if (unit_type == 0x0B) {                             /* @asm 0x05CEC2 */
            uint8_t ord = g_units_3144[eval][0x08];          /* [+0x314c] order */
            if ((ord == 5 || ord == 6) && def_owner >= 4) {
                /* fall through: no scale */
            } else {
                atk_str >>= 2; g_ai_scratch_8D01 |= 8;       /* @asm 0x05CEE2/0x05CEE7 */
            }
        }
        if (def_type == 0x0B) {                              /* @asm 0x05CEEC */
            uint8_t ord = g_units_3144[eval][0x08];
            if ((ord == 5 || ord == 6) && def_owner >= 4) {
                /* no scale */
            } else {
                g_ai_scratch_8D03 |= 8; def_str >>= 2;       /* @asm 0x05CF0C/0x05CF11 */
            }
        }
    } else {
        /* @asm 0x05CF18 occ_owner>=0: if def_type==0x0B and attacker owner>=4
         *   (AI vs colonist on a colony) -> 0xa158|=1; def_str <<= 1. */
        if (def_type == 0x0B && owner >= 4) {
            g_ai_scratch_A158 |= 1; def_str <<= 1;           /* @asm 0x05CF26/0x05CF2B */
        }
    }

    /* @asm 0x05CF2F -- attacker owner==2 vs AI defender on a colony tile:
     *   atk_str += atk_str/2 (x1.5), 0x8d01|=0x10.  (owner 2 = a specific nation.) */
    if (owner == 2 && def_owner >= 4 && occ_owner >= 0) {    /* @asm 0x05CF2F..0x05CF41 */
        atk_str += (int16_t)(atk_str >> 1);                  /* @asm 0x05CF43 */
        g_ai_scratch_8D01 |= 0x10;                           /* @asm 0x05CF4D */
    }

    /* ==== SoL / human-player block, gated by g_flags_5382 bit0 ========= */
    /* @asm 0x05CF52 test [0x5382],1; jz skip(0x26d1).  @asm 0x05CF5C if owner>=4
     *   skip.  Then a chain keyed on whether the ATTACKER or DEFENDER is the human
     *   self-power g_self_marker_53D2 (@asm 0x05CF6D/0x05CFA1/0x05D00A): it applies
     *   a Sons-of-Liberty / rebel-sentiment scale to atk_str using a per-colony
     *   value fetched via 0x181F:0xC86 (@asm 0x05CF98) and the difficulty byte
     *   (atk_str = atk_str*[0x53a6]/0x14 @asm 0x05CFFC for the human path).  The
     *   exact SoL value source ([bp-0xa2] from 0x181F:0xC86) is overlay-resident
     *   -> its NUMERIC contribution is RUNTIME_ONLY (data-resident); the CONTROL FLOW + the /0x14
     *   and /0x64 divisors are byte-cited.  (Structural; not invented.) */
    if ((g_flags_5382 & 1) && owner < 4) {              /* @asm 0x05CF52/0x05CF5C */
        if (r_d6 >= 0) {                                     /* @asm 0x05CF66 colony path */
            /* @asm 0x05CF6D: self_power==owner OR war-of-independence ally flag (bit1) */
            if (owner == g_self_marker_53D2 || (g_flags_5382 & 2)) {
                g_ai_scratch_8D01 |= 0x80;                   /* @asm 0x05CF7D */
                atk_str += (int16_t)(atk_str >> 1);          /* @asm 0x05CF82 +50% */
            }
            {   /* @asm 0x05CF8C: fetch SoL% for this colony */
                int16_t sol_pct, sol_flag;
                ovly_query_9E6(r_d6);                        /* @asm 0x05CF90 set active colony */
                sol_pct = colony_field_C86();                  /* @asm 0x05CF98 -> [bp-0xa2] */
                if (owner == g_self_marker_53D2) {            /* @asm 0x05CFA1 */
                    sol_flag = 2;                            /* @asm 0x05CFAA [bp-0xc]=2 */
                    sol_pct  = (int16_t)(100 - sol_pct);     /* @asm 0x05CFAF rebel uses tory% */
                } else {
                    sol_flag = 4;                            /* @asm 0x05CFBC [bp-0xc]=4 */
                }
                if (sol_pct != 0) {                          /* @asm 0x05CFC1 */
                    g_ai_scratch_A156 |= (uint16_t)sol_flag; /* @asm 0x05CFCB */
                    atk_str += (int16_t)(((int32_t)sol_pct * atk_str) / 100); /* @asm 0x05CFCF/0x05D003 /0x64 */
                }
            }
        } else {                                             /* @asm 0x05CFDC open-terrain path */
            /* @asm 0x05CFDC: human player only; terrain NOT 0x19/0x1A */
            if (owner == g_self_marker_53D2) {
                if (!func_0062B4_op_sz_39(tile_x, tile_y)) /* @asm 0x05CFE5/0x05CFF3 */
                    atk_str += (int16_t)(((int32_t)g_difficulty_53A6 * atk_str) / 20); /* @asm 0x05CFFA/0x05D000 /0x14 */
            }
        }
        /* @asm 0x05D00A: if owner==self_power call func_005F48 (result discarded) */
        if (owner == g_self_marker_53D2)
            func_005F48_logic_sz_58((uint16_t)tile_x, (uint16_t)tile_y); /* @asm 0x05D013 */
    }

    /* ==== terrain/era SoL adjustments (only when mode==0, i.e. EVALUATE) ===== */
    /* @asm 0x05D021 cmp [bp+0xe],0; jne 0x26f6 (when ACTING for real, skip this
     *   whole evaluate-only fast path which RETURNS atk_str*8/(def_str+1) early
     *   @asm 0x05D032..0x05D044).  The early-return value is the EVALUATE score:
     *       return (atk_str << 3) / (def_str + 1);
     *   This is the score the AI uses to RANK targets when it is not committing. */
    if (mode == 0) {                                         /* @asm 0x05D021 */
        if (eval_reject_flag != 0) ovly_postcombat_05C69C(0,0,0); /* @asm 0x05D027/0x05D02D [bp-0x6e] */
        return (int16_t)(((int32_t)atk_str << 3) / (def_str + 1)); /* @asm 0x05D032 EVALUATE score */
    }

    /* ==== terrain/era atk_str/def_str adjustments (mode!=0, ACT FOR REAL) ======
     * @asm 0x05D046..0x05D14D -- byte-cited; per-power bias table VALUES are
     * RUNTIME_ONLY (data-resident, not in EXE image). */

    if (g_difficulty_53A6 <= 1) {                            /* @asm 0x05D046 jbe 0x5D050 */
        /* WoI + banded-unit skip: when WoI active AND colony target AND attacker is
         * the ship/band class (0x0D..0x12), the first two scale blocks are skipped.
         * @asm 0x05D050..0x05D06A */
        if (!((g_flags_5382 & 1) && r_d6 >= 0
              && unit_type >= 0x0D && unit_type <= 0x12)) {
            /* First scale: defender is AI + early-era (turn<0x50) + colony target.
             * @asm 0x05D06C..0x05D0A9 */
            if (def_owner < 4 && g_ai_personality_543F[def_owner][0x00] == 0
                && g_turn_538E < 0x50 && r_d6 >= 0) {       /* @asm 0x05D06C..0x05D084 */
                if (g_difficulty_53A6 != 0)
                    atk_str >>= 1;                           /* @asm 0x05D092 diff=1: halve */
                else
                    atk_str -= (int16_t)(atk_str >> 2);      /* @asm 0x05D09C diff=0: *3/4 */
                /* @asm 0x05D0A3: eval_reject_flag AND diff==0 -> zero */
                if (eval_reject_flag != 0 && g_difficulty_53A6 == 0)
                    atk_str = 0;                             /* @asm 0x05D0B0 */
            }
        }
        /* Second halving: def is AI, personality==0, AND (attacker is EU OR early-era).
         * @asm 0x05D0B6..0x05D0D7 */
        if (def_owner < 4 && g_ai_personality_543F[def_owner][0x00] == 0) {
            if (owner < 4 || g_turn_538E < 0x50)            /* @asm 0x05D0C7..0x05D0D3 */
                atk_str >>= 1;                               /* @asm 0x05D0D5 */
        }
    }

    /* @asm 0x05D0D9: natives-favor -- difficulty==0, AI EU attacker, personality==0 */
    if (g_difficulty_53A6 == 0 && owner < 4
        && g_ai_personality_543F[owner][0x00] == 0)
        atk_str <<= 1;                                       /* @asm 0x05D0F3 */

    /* @asm 0x05D0F7..0x05D150: per-power bias (r_d6>=0 gate) -- RUNTIME_ONLY tables.
     * Two table reads are DGROUP-offset indexed by def_owner:
     *   [def_owner - 0x6D68] (owner>=4 path): forces atk_str=0 when table==1.
     *   g_col_data_5D65[r_d6*0xCA] vs g_pwr_bias_6BF4[def_owner]>>1 (def AI path):
     *     if threshold <= colony score: def_str += (4 - difficulty) * 4.
     * Control flow byte-cited; table VALUES data-resident -> NOT invented. */
    if (r_d6 >= 0) {                                         /* @asm 0x05D0F7 */
        if (owner >= 4) {                                    /* @asm 0x05D0FE */
            /* @asm 0x05D105: DGROUP[def_owner - 0x6D68] == 1 -> atk_str = 0;
             * table access documented; RUNTIME_ONLY value (data-resident). */
        }
        if (def_owner < 4                                    /* @asm 0x05D115 */
            && g_ai_personality_543F[def_owner][0x00] == 0) {
            /* @asm 0x05D126: bias = g_col_data_5D65[r_d6 * 0xCA];
             * @asm 0x05D134: threshold = DGROUP[def_owner - 0x6BF4] >> 1;
             * @asm 0x05D13C: if threshold <= bias:
             *   def_str += (4 - difficulty) * 4;   @asm 0x05D14D
             * RUNTIME_ONLY table values (data-resident). */
        }
    }

    /* ======================================================================== *
     *   >>> THE ROLL: random over (DEF + ATK); WIN iff roll <= ATK <<<          *
     *   @asm 0x05D17D..0x05D1A2  (all 9 opcodes byte-verified against raw EXE)   *
     * ------------------------------------------------------------------------ *
     *   05D17D  mov ax,[bp-0xa6]      ; def_str                                 *
     *   05D181  add ax,[bp-0x90]      ; + atk_str   => hi = ATK + DEF           *
     *   05D186  push 1 ; push (atk+def)                                         *
     *   05D188  lcall 0x181F:0x04D4   ; roll = random_int(1, ATK+DEF)           *
     *   05D194  cmp ax,[bp-0x90]      ; roll  vs atk_str                        *
     *   05D198  jg 0x2850             ; roll >  ATK -> LOSE                      *
     *   05D19A  mov ax,1              ; roll <= ATK -> WIN                       *
     *   05D1A2  mov [bp-0x9c],ax      ; win_flag                                *
     * ======================================================================== */
    /* @asm 0x05D151 reload acting unit's nation/owner bytes into [bp-0xb4]/[bp-0xbc]
     *   (0x3144/0x3145) and 0x181F:0x916 / 0x181F:0x89E bookkeeping -- structural. */
    roll = random_int_4D4(1, (int16_t)(def_str + atk_str));  /* @asm 0x05D188 */
    win_flag = (roll <= atk_str) ? 1 : 0;                    /* @asm 0x05D194..0x05D1A2 */

    /* @asm 0x05D1A6 -- a single forced-loss override: if attacker is AI (owner>=4)
     *   AND defender is human (def_owner<4, AIPersonality==0) AND attacker type
     *   ==0x13 AND defender type==0x0B: win_flag=0, [bp-0xc8]=1 (an AI never auto-
     *   takes a human colonist with a base soldier here). */
    if (owner >= 4 && def_owner < 4 && g_ai_personality_543F[def_owner][0x00] == 0
        && unit_type == 0x13 && def_type == 0x0B) {
        win_flag = 0;                                        /* @asm 0x05D1CC */
        /* [bp-0xc8]=1 @asm 0x05D1D2 (a "special reject" marker) */
    }

    /* ======================================================================== *
     *   APPLY THE RESULT: win_flag selects WHICH unit becomes the applier's     *
     *   unit_a (the LOSER).  func_05B2C2 then removes/demotes that unit_a.       *
     * ------------------------------------------------------------------------ */
    /* The big tail @asm 0x05D1D8..page-end consumes win_flag:
     *   - It prints the player-facing result message keyed by win_flag:
     *       win_flag!=0 -> "EUROPEWIN"  (msg key 0x1c13 @asm 0x05D9F3, gated by
     *                       cmp [bp-0x9c],0 jz @0x05D9DC)
     *       win_flag==0 -> "EUROPELOSE" (msg key 0x1c1d @asm 0x05DA20)
     *     and, if the target was a COLONY ([bp-0xa]!=0), the BURNED/BURNED2/BURNED3
     *     keys (0x1c28/0x1c2f/0x1c37 @asm 0x05DAE6/0x05DB0B/0x05DB12) for the
     *     colony loot/burn outcome (the loot long-math at file 0x05DC9D/0x05DE35).
     *   - LOSE branch (win_flag==0) @asm 0x05D7B4: it calls the applier WRAPPER
     *       func_05BE30 with the ATTACKER (unit_index, in [bp+6]) as unit_a
     *       @asm 0x05D7E8 (call 0x3ddd) -> func_05B2C2 demotes/destroys the
     *       attacker.  (Also calls func_05C69C @asm 0x05D7C8 = post-combat fx.)
     *   - WIN  branch (win_flag!=0) @asm 0x05D7B1 -> 0x05DB2C: [bp+6] is
     *       re-pointed to the DEFENDER/colony-occupant (via 0x181F:0x7E0/0x98E
     *       @asm 0x05DB54/0x05DB6A) and func_05BE30 is called with THAT as unit_a
     *       @asm 0x05DB5F (call 0x3ddd) -> func_05B2C2 removes the defender.
     *   In func_05B2C2 the LAND path always sets its [bp-0x3a]=0 (@asm 0x05B7AD)
     *   and jmps the outcome router (@asm 0x05B7BD), i.e. it ALWAYS treats the
     *   unit_a it is handed as the loser -- which is exactly the unit win_flag
     *   selected here. THIS is the win-flag write func_05B2C2 later reads. */
    loser_unit = (win_flag != 0)
               ? eval        /* WIN  -> the defender is removed (it is what [bp+6]
                              *          gets re-bound to before the WIN-branch call) */
               : unit_index; /* LOSE -> the attacker (the head's [bp+6]) is removed */
    /* Both branches funnel into func_05BE30(loser, ...).  The wrapper's FIRST arg
     * (callee [bp+6], = the LAST push) is the loser unit_a; the trailing args differ
     * by branch (LOSE pushes [bp-0xbc],[bp-0xb4],[bp+0xc],[bp-0xc6],loser @asm 0x05D7E8;
     * WIN pushes the re-derived occupant [bp-0xc2],...,loser @asm 0x05DB5F) and are
     * the (x,y,nation,owner) context func_05B2C2 uses for messaging -- they do not
     * change which unit is removed.  Shown here as one representative call. */
    ovly_combat_apply_wrapper_05BE30(loser_unit, eval, occ_owner,
                                     g_units_3144[unit_index][0x01],
                                     g_units_3144[unit_index][0x00]); /* @asm 0x05D7E8/0x05DB5F */

    /* The remaining tail (founding-father bonus tallies into g_power_kill_tally_59A6
     *   @asm 0x05D76F, the colony loot/wealth-decay long-math, and the AI scratch-
     *   flag finalisation) SPILLS PAST page 0x10's clean linear decode (the reseg
     *   stops at the page end 0x05E120; the body continues into 0x05E1xx).  Those
     *   tail EFFECTS are documented but their data-resident WEIGHTS remain
     *   RUNTIME_ONLY (data-resident); the WIN/LOSS DECISION and its application are fully resolved. */
    r_d6 = win_flag;         /* the decided result feeds the return */

reason:
    /* @asm 0x22ad (file region ~0x05CBFD) -- common "reason handler": maps
     * sub_mode (1/2/3) to a result code, finalises scratch flags, and falls to
     * the return. Structure byte-clear; the exact result encoding is not yet decoded. */
    return r_d6;

abort_far:
    /* @asm 0x05E706 ljmp/jmp far cleanup region -> returns a negative sentinel. */
    return -1;

cleanup_far:
    /* @asm 0x05E66E far cleanup -> returns the placed/committed result. */
    return r_d6;
}

/* ============================================================================
 * ai_move_eval -- func_04E2D6 (page 0x0D), file 0x04E2D6.. (14975 bytes)
 * ----------------------------------------------------------------------------
 * The per-unit MOVE / ORDER evaluator. Reseg page_0D header:
 * `size=14975 insns=4858 prologue=ENTER 0x00EE,0 terminal=RETF`. Reached via
 * Type-A thunk 0x01CAE4 (0x181F:0x24F4) but has NO static LCALL caller -> it is
 * invoked INDIRECTLY (callback / function pointer); the registration site is not yet decoded.
 * It ALSO far-calls the per-unit AI leaf (@asm 0x0514D1 lcall 0x191F:0xA14 ->
 * func_05CA7E), so it shares this leaf.
 *
 * BYTE-VERIFIED HEAD (per-func dump + page_0D):
 *   [bp+6] = unit (*0x1c). @asm 0x04E2EF.
 *   Reads owner nibble [+0x3147]&0xf (@asm 0x04E2F3) and switches on the unit's
 *   ORDER byte [+0x08]=0x314c testing 0, 5, 6, 0xa (@asm 0x04E2FE/0x04E305/
 *   0x04E30C/0x04E313) -- the order-type dispatch. The AI10..AI19 strings
 *   (handles 0x177C+, file 0x1F11C+) are debug labels for the AI move sub-states.
 *
 * The 14975-byte body (per-order move planning + the scoring weights it applies)
 * is FAR too large to decode in this pass; its weights are RUNTIME_ONLY/overlay-
 * resident. Documented here as the shared MOVE evaluator; full port deferred.
 * (Inputs byte-verified; weights RUNTIME_ONLY -- NOT invented.)
 *
 * @ref reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_0D.asm (func_04E2D6)
 * @ref reverse_engineered/code/VICEROY/disasm/func_04E2D6_unknown.asm
 * ============================================================================ */
extern int16_t ovly_ai_unit_leaf_05CA7E(int16_t unit, int16_t x, int16_t y,
                                        int16_t flag, int16_t one);

/* int16_t ai_move_eval(int16_t unit_index);  -- body in overlay page (page 0x0D; see note above). */

/* Alias name used by move.c AI8 engine (lcall 0x191F:0xA14 -> func_05CA7E). */
int16_t func_05CA7E_attack_value(uint16_t unit, uint16_t x, uint16_t y,
                                 uint16_t f1, uint16_t f2)
{
    return ai_unit_leaf((int16_t)unit, (int16_t)x, (int16_t)y,
                        (int16_t)f1, (int16_t)f2);
}

/* ============================================================================
 * NOTES / TODO_VERIFY
 * ----------------------------------------------------------------------------
 *  - func_05CA7E PROLOGUE + decision blocks + the LAND-COMBAT DECISION block
 *    (file 0x05CDA0..0x05D1A2) + its win-flag application (down to the
 *    EUROPEWIN/EUROPELOSE/BURNED emits and the func_05BE30 applier calls) are
 *    byte-verified against page_10.asm and the raw EXE.
 *  - THE LAND ODDS FORM = SHIP ODDS FORM: random_int(1, ATK+DEF), WIN iff
 *    roll<=ATK (@asm 0x05D188/0x05D194).  DIFFERENCE from ships: land uses the
 *    DERIVED strengths atk_str[bp-0x90]/def_str[bp-0xa6] (base from the resident
 *    0x5235/0x5236 columns via the 0x07C2A/0x07D3E accessors, x8, then the
 *    terrain/SoL/veteran/difficulty modifier chain), NOT the ship-only raw
 *    0x523b/0x523c.  (Resolves the land.c open question; land.c's "no land roll"
 *    finding was scoped to 0x523b/0x523c only -- correct as far as it went.)
 *  - NOT YET VERIFIED (NOT in the EXE image, so not guessable here):
 *      * numeric VALUES of the per-type 0x5235 (defense) / 0x5236 (attack) columns
 *        (NAMES.TXT @UNIT / loader @0x74EDA);
 *      * the per-terrain/fort bonus table 0x54EE/0x5AD8 feeding g_def_terrain_bonus_8D04;
 *      * the SoL value from 0x181F:0xC86 ([bp-0xa2]) and the per-power bias tables
 *        (0x5D65 stride 0xCA, the 0x6BF4/0x6D68 [bp-0x76]-displaced bases);
 *      * the colony loot/wealth-decay long-math in the FAR tail (file >0x05E120).
 *  - ColonyRecord (DGROUP:0x8542) field offsets used here (+0x1f population,
 *    +0xb8 defense/bell threshold compared to 0x32) are byte-cited as ACCESSED;
 *    cross-check against colony.h before relying on the field NAMES.
 *  - Strings byte-verified via the +0x1D9A0 rule: "HALF" 0x1C06, "Bad defense"
 *    literal 0x1CE1, "EVASIVE" 0x1C0B, "EUROPEWIN" 0x1C13, "EUROPELOSE" 0x1C1D,
 *    "BURNED"/"BURNED2"/"BURNED3" 0x1C28/0x1C2F/0x1C37.
 *  - Trampolines resolved via reverse_engineered/tools/rtlink/rtlink_decode.py:
 *      near 0x3DDD -> 0x05E72D ljmp 0x1A1F:0x6F8 -> func_05BE30 (applier wrapper)
 *      near 0x3DD3 -> 0x05E723 ljmp 0x1A1F:0x6E0 -> func_05B2C2 (consequence applier)
 *      0x181F:0x9C8 -> FILE 0x07C2A (strength accessor); 0x181F:0x9DC -> 0x07D3E
 *      0x181F:0x04D4 -> FILE 0x0C322 (random_int, MSC 6.0 LCG).
 *  - func_04E2D6 (move evaluator) head is byte-verified (order-byte dispatch on
 *    0/5/6/0xa); its 14975-byte body is not yet decoded; scoring weights are RUNTIME_ONLY.
 *  - NO scoring weight, comparison constant, or per-nation bias VALUE is invented
 *    in this file; every operation cites an @asm offset, every undeterminable
 *    value is RUNTIME_ONLY (data-resident) with its cited access site.
 * ============================================================================ */
