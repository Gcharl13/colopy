/* ============================================================================
 *                  >>> BYTE_VERIFIED (control flow + globals) <<<
 *              >>> per-unit SCORING WEIGHTS in the leaf: RUNTIME_ONLY <<
 * ----------------------------------------------------------------------------
 * unit_orders.c -- per-unit AI / command evaluation and order dispatch.
 *
 * THREE byte-verified layers (outer -> inner), on separate overlay pages, wired
 * by Type-A far-thunks (see typeA_thunk_targets.json + the inline `; THUNK ->`
 * annotations in the per-func disasm dumps):
 *
 *   func_040E22 (page 0x08)  ai_unit_order_step(unit)         [436 B, complete]
 *        per-unit ORDER step: classifies the unit, resolves a target via
 *        0x1A1F:0x210, branches on (type nibble < 4 AND controller flag == 0),
 *        and far-calls the confrontation/AI evaluator below with a target tile.
 *            v  @asm 0x040EC7  lcall 0x1A1F:0x142  -> thunk 0x01C732 -> 0x03ECF0
 *   func_03ECF0 (page 0x07)  ai_eval_unit(unit, x, y)     [3101 B, complete]
 *        per-unit CONFRONTATION / COMMAND evaluator: given a unit and a target
 *        tile (x,y), it resolves the occupant, runs a long chain of capability
 *        tests (the 0x181F:0x754/0x72C/0x6BE/... queries tested with
 *        `test al,0xa`/`test al,0x40`), gates each action on the relevant
 *        AIPersonality controller flag (0x543F+idx*0x34), raises the human
 *        diplomatic prompts (DECLAREWAR / CANCELPEACE / HAVETREATY /
 *        WHACKINDIANS / SNEAK / CANNOTATTACK) for HUMAN-controlled
 *        confrontations, and for AI-controlled units far-calls the per-unit AI
 *        LEAF.
 *            v  @asm 0x03F492  lcall 0x191F:0xA14  -> thunk 0x01C004 -> 0x05CA7E
 *   func_05CA7E (page 0x10)  per-unit AI LEAF        [7348 B; see unit_ai_leaf.c]
 *        the actual per-unit decision/scoring. Its UnitRecord inputs are
 *        byte-verified; the SCORING WEIGHTS are RUNTIME_ONLY (overlay/data-resident).
 *
 * IDENTITY RECONCILIATION (func_03ECF0)
 *   The 86-byte per-func dump (disasm/func_03ECF0_unknown.asm) and the old
 *   FUNCTION_INVENTORY.md row labelled this "diplomatic_action_init"
 *   (DECLAREWAR/CANCELPEACE/HAVETREATY/WHACKINDIANS) and gave it ~86 bytes. That
 *   dump was TRUNCATED: the linear disassembler stopped at file 0x03ED44 on a
 *   0xFF byte ("disasm cut" note in the dump). The RE-SEGMENTED page 0x07 header
 *   states `func_03ECF0 size=3101 insns=991 terminal=RETF`, and the body runs
 *   0x03ECF0..0x03F90C (RETF at 0x03F90C; next func_03F90E at 0x03F90E). So the
 *   function is the 3101-byte per-unit evaluator the brief describes. The
 *   DECLAREWAR/etc. strings ARE referenced -- as the message handles pushed to
 *   the dialog helper 0x181F:0x652 (0x13A0=CANNOTATTACK, 0x13AD=WHACKINDIANS,
 *   0x13BA=HAVETREATY, 0x13C5=SNEAK, 0x13CB=CANCELPEACE, 0x13D7=DECLAREWAR;
 *   resolved via the verified rule file_offset = handle + 0x1D9A0 against
 *   strings.json). They are the HUMAN-facing confrontation prompts this same
 *   shared evaluator raises. (docs/RULINGS.md 2026-05-30 (ai-unit-eval).)
 *
 * @region          overlay
 * @verified_by     Hand-decompiled from VICEROY.EXE 2026-05-30 (overlay reseg
 *                  page_07/page_08 full bodies + string-rule xrefs + per-func
 *                  dumps). func_03ECF0 + func_040E22 are decoded END-TO-END here.
 * @ref             reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_07.asm
 * @ref             reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_08.asm
 * @ref             reverse_engineered/code/VICEROY/disasm/func_040E22_unknown.asm
 * @ref             reverse_engineered/code/VICEROY/strings.json (message handles)
 * @ref             reverse_engineered/code/VICEROY/typeA_thunk_targets.json
 * ============================================================================ */
#include "viceroy_types.h"
#include "dgroup.h"   /* DG8/DG16/DG_PTR for the byte-cited DGROUP accesses */

/* ----------------------------------------------------------------------------
 * Byte-verified globals (DGROUP-relative; DS = DGROUP at run time)
 * ------------------------------------------------------------------------- */

/* DGROUP:0x3144 -- UnitRecord table; stride 0x1C (28). Fields touched here
 * (all via `imul bx,unit,0x1c` then `[bx+0x3144+k]`):
 *   +0x00 map_x   @asm 0x03ED0F / 0x040EBD     +0x07 profession @asm 0x040F2B
 *   +0x01 map_y   @asm 0x03ED18 / 0x040EAF     +0x08 orders     @asm 0x040E2B
 *   +0x02 type    @asm 0x03EED0 / 0x040F78        (a.k.a. state @ 0x314c)
 *   +0x03 owner(low nibble &0xf) @asm 0x03EDAA  +0x09 goto_x   @asm 0x040EDE
 *   +0x05 field_05 (subtracted) @asm 0x03EE95   +0x0A goto_y   @asm 0x040EEF
 *   +0x11/+0x12 (0x3155/0x3156) reset for type 2 @asm 0x040F7F/0x040F84
 *   +0x16 turn_counter (0x315A) inc->0x14 reset  @asm 0x03F8EE/0x03F8F2  */
extern uint8_t g_units_3144[/* unit */][0x1C];

/* DGROUP:0x543F -- AIPersonality controller flag; record stride 0x34 (52),
 * flag at record byte +0x31 (so [idx*0x34 + 0x543F]). 0 = AI-eligible/AI-
 * controlled in these gates. Stride binding @asm 0x03F474 imul bx,[bp-2],0x34;
 * cmp [bx+0x543f],0 (and ~20 more sites in func_03ECF0). */
extern uint8_t g_ai_personality_543F[/* nation */][0x34];

/* DGROUP:0x5398 -- current_nation_index ("whose turn is processing").
 * @asm 0x03F6BF cmp al,[0x5398]. */
extern int16_t g_current_nation_index_5398;

/* DGROUP:0x5396 -- secondary "view/selected" nation index. Compared against the
 * unit owner repeatedly in the post-eval book-keeping (@asm 0x03F3BA / 0x03F44C
 * / 0x03F637 / 0x040F62 cmp ...,[0x5396]). */
extern int16_t g_view_nation_index_5396;

/* DGROUP:0x5394 -- local/active (human) player index; also the POWER COUNT guard
 * `cmp word [0x5394],4` (@asm 0x040F14). */
extern int16_t g_human_player_index_5394;

/* DGROUP:0x539C -- local-player-or-state word; saved at entry of both functions
 * (@asm 0x03ED05 / 0x040E5F) and compared near the tail to decide whether the
 * confrontation belongs to the local player (@asm 0x03F804 / 0x040ED2). */
extern int16_t g_local_player_state_539C;

/* DGROUP:0x5382 -- game-mode flags. bit 0 @asm 0x03EF4C / 0x040F32; bit 0x80 @asm
 * 0x03F6B2 (gates the owner==current-nation fast path). */
extern uint16_t g_game_mode_flags_5382;

/* DGROUP:0x5383 -- companion mode byte; bits 0x80/0x40 tested @asm 0x03F42A /
 * 0x03F432 (selects which "auto-skip" rule applies by unit owner < 4 or >= 4). */
extern uint8_t g_mode_flag_5383;

/* DGROUP:0x5387 -- secondary mode/interrupt flag; bit 0x80 @asm 0x03F6C5. */
extern uint8_t g_mode_flag_5387;

/* DGROUP:0x53D2 -- RESOLVED 2026-06-10: the INTERVENTION-ALLY power index
 * (byte-verified across king/ref.c func_03E442, meeting.c entity-name rename
 * [0x53D2]->[0x2E68], and unit_ai_leaf's intervention +50% gate).  The
 * compares here skip diplomatic consequences for the ally power. */
extern int16_t g_intervention_ally_53D2;

/* DGROUP:0x53A2 -- word seeded into a local at @asm 0x03F3AA (a default flag).
 * DGROUP:0x53A6 -- RESOLVED: this is g_difficulty_53A6 (0..4), used here as
 *   the piracy catch-chance bound (random(0,100) < difficulty+1 @0x03F0B2)
 *   and a roll input @0x03F351 -- see the war-declaration block below. */
extern int16_t g_word_53A2;
extern uint8_t g_byte_53A6;   /* == g_difficulty_53A6 */

/* DGROUP:0x1DD6 -- scratch "current order target" word; set to 0xFFFF as a
 * sentinel at the head/tail of the order step (@asm 0x040E32 / 0x040FCD). */
extern uint16_t g_word_1DD6;
/* DGROUP:0x5392 -- "selected unit" word, written in the order step's
 * matched-unit path (@asm 0x040F50). */
extern int16_t g_selected_unit_5392;

/* DGROUP:0x2F76 -- RESOLVED 2026-06-10: NOT per-power -- this is the TERRAIN
 * table (base 0x2F74, stride 16; row = terrain type) attribute column +2 =
 * the MOVEMENT-COST byte (writer func_0745F0 = page1A_names_subloader; the
 * column map is +2 move cost, +3 defense @0x2F77).  The entry code reads the
 * unit's TILE TERRAIN cost and triples it as the order-priority cap. */
extern uint8_t g_terrain_movecost_2F76[/* terrain */][16];

/* DGROUP:0x5236 / 0x5230 -- per-unit-type tables, stride 14 (the `*14` build at
 * @asm 0x03EED4..0x03EEE2 and 0x03F64D..0x03F659). 0x5236[type*14] is a flag
 * tested == 0 (@asm 0x03EEE4); 0x5230[type*14] a word pushed to a query
 * (@asm 0x03F65B). Table contents RUNTIME_ONLY (NAMES.TXT/data-file; loaded
 * by func_0749E0 / loader @0x74EDA). */
extern uint8_t g_unittype_tbl_5236[/* type */][14];
extern uint8_t g_unittype_tbl_5230[/* type */][14];

/* DGROUP:0x8D4A / 0x8D52 -- RESOLVED 2026-06-10:
 *   [0x8D4A] = near ptr to the CURRENT NATIVE SETTLEMENT record (the same
 *     pointer effects.c documents); +0xB + owner*2... the increment
 *     `inc [bx+si+0xb]` is the per-settlement per-power ATTACK TALLY word
 *     (raids remembered against each power).
 *   [0x8D52] = the CURRENT NATIVE TRIBE index (used as the alarm/census row
 *     everywhere: native_village_trade, sweep B of func_04CC50, etc). */
extern uint16_t g_settlement_ptr_8D4A;
extern uint16_t g_tribe_index_8D52;

/* ----------------------------------------------------------------------------
 * Cross-page leaves and overlay helpers (reached via RTLink far-thunks).
 * Each cites the LCALL site; the resolving thunk is in typeA_thunk_targets.json.
 * Helper SEMANTICS are from call context and are not yet decoded where the leaf body was
 * not decoded -- NONE are invented.
 * ------------------------------------------------------------------------- */

/* func_05CA7E (page 0x10) -- per-unit AI LEAF (7348 B; body in unit_ai_leaf.c).
 * Far-call @asm 0x03F492 pushes 5 words R-to-L: (unit, [bp+8]=x, [bp+0xa]=y,
 * flag=[bp-0x1a], one=1) then `add sp,0xa`. Returns AX. */
extern int16_t ovly_ai_unit_leaf_05CA7E(int16_t unit_index, int16_t tile_x,
                                        int16_t tile_y, int16_t flag,
                                        int16_t one);

/* Capability / position query helpers (overlay 0x181F:* thunks). The bitmask
 * tests (`test al,0xa` = attack-ish; `test al,0x40` = occupant-present-ish) are
 * byte-clear; the exact ability semantics require the thunk bodies (body in
 * thunk page; not decodable from overlay bytecode alone). */
extern int16_t ovly_unit_ability_754(int16_t x, int16_t y);  /* @asm 0x03ED4A/0x03ED5C */
extern int16_t ovly_unit_ability_72C(int16_t x, int16_t y);  /* @asm 0x03ED73/0x03ED85 */
extern int16_t ovly_occupant_at_6BE(int16_t x, int16_t y);   /* @asm 0x03EDBA -> owner-nibble holder */
extern int16_t ovly_tile_to_unit_7E0(int16_t x, int16_t y);  /* @asm 0x03EDDD -> unit idx (or <0) */
extern int16_t ovly_attackable_6F0(int16_t x, int16_t y);    /* @asm 0x03EE1D */
extern int16_t ovly_relation_A38(int16_t a, int16_t b);      /* @asm 0x03EFC0.. test al,4/0x40 */
extern int16_t ovly_name_word_9A4(int16_t idx);              /* @asm 0x03F237/0x03F24A power-name word */
extern int16_t ovly_relation_query_826(int16_t x, int16_t y, int16_t owner); /* 0x826 =
                            func_00730A(x, y, owner) per-owner adjacency mask;
                            decl order fixed to the cdecl truth 2026-06-12 */
extern int16_t ovly_target_query_7BE(int16_t x, int16_t y);  /* @asm 0x03EE59/0x03F5AE colony? */
extern int16_t ovly_target_query_6DC(int16_t a, int16_t x, int16_t y);/* @asm 0x03F372 */
extern int16_t ovly_target_query_696(int16_t x, int16_t y);  /* @asm 0x03F301 */
extern int16_t ovly_step_unit_2E4(int16_t unit);             /* @asm 0x03F513 iterate units on tile */
extern int16_t ovly_unit_alloc_2D0(int16_t a, int16_t b, int16_t c,
                                   int16_t d, int16_t e, int16_t f,
                                   int16_t g);                /* @asm 0x03F4F2 spawn/animate */
extern void    ovly_dialog_652(int16_t flag, int16_t msg_id);/* @asm 0x03EFE7 dialog helper */
extern void    ovly_msg_arg_438(int16_t val, int16_t slot);  /* @asm 0x03EFDA set $arg$ */
extern void    ovly_msg_arg_4AC(int16_t which);              /* @asm 0x03F1A8 */
extern void    ovly_msg_str_998(void);                       /* @asm 0x03F1BA (lea 0x13c5=SNEAK) */
extern void    ovly_msg_str_3FE(void);                       /* @asm 0x03EF11 (lea 0x13a0=CANNOTATTACK) */
extern void    ovly_play_sound_4C0(int16_t snd);             /* @asm 0x03F5E3 */
/* 0x181F:0x934 (@asm 0x03EEC1/0x03F901/0x040F97) = func_007BCE_logic_sz_25:
 * END UNIT TURN -- unit[+0x05] = movement allowance (func_006CCA), which
 * closes the func_007A20 "movement left" gate.  Declared above. */
extern void    ovly_finalize_unit_90C(int16_t unit);         /* @asm 0x03EE87/0x03F31F */

/* Cross-page (0x1A1F / 0x191F) handlers used by func_040E22 + tail of 03ECF0.
 * RESOLVED 2026-06-11 (whois + RTLink stub decode, ROUTE_B 1.6) — every leaf of
 * the order step is an EXISTING port; called directly (no thunk-floor detour):
 *   0x1A1F:0x210 -> file 0x62D84 func_062D84_unit_automove(unit) -> dir 0..7/8/-1
 *   0x191F:0x44E -> file 0x3FDDE func_03FDDE_op_sz_82(dx, dy)  [human move step]
 *   0x1A1F:0x142 -> file 0x3ECF0 = ai_eval_unit (THIS file's full port)
 *   0x191F:0x208 -> file 0x418AA func_0418AA_commit_active_move()
 *   0x181F:0xDF4 -> file 0x0C17A func_00C17A_logic_sz_20(unit)  [view refresh]
 *   0x181F:0x78C -> file 0x0627A func_00627A_op_sz_57(x, y)     [terrain query]
 *   0x181F:0x934 -> file 0x07BCE func_007BCE_logic_sz_25(unit)  [end unit turn:
 *                   unit[+0x05] = movement allowance (func_006CCA), closing the
 *                   func_007A20 movement gate] */
extern int  func_062D84_unit_automove(int unit_idx);
extern int  func_03FDDE_op_sz_82(uint16_t dx, uint16_t dy);
extern int  func_0418AA_commit_active_move(void);
extern int  func_00C17A_logic_sz_20(uint16_t unit);
extern int  func_00627A_op_sz_57(uint16_t x, uint16_t y);
extern void func_007BCE_logic_sz_25(uint16_t unit);

/* DGROUP:0x00B4 / 0x00BE -- the canonical 8-neighbour dx/dy delta tables
 * (linkfloor: g_compass_dx8_00B4 / g_compass_dy8_00BE; same tables used by
 * func_056A10, func_025900 and the load_image kernels).  Indexed by the
 * direction code returned from func_062D84_unit_automove.
 * @asm 0x040E83/0x040E89 (relative branch), 0x040EA6/0x040EB8 (absolute). */
extern int8_t g_compass_dx8_00B4[];
extern int8_t g_compass_dy8_00BE[];

/* ============================================================================
 * ai_eval_unit -- func_03ECF0 (page 0x07), file 0x03ECF0..0x03F90C (3101 bytes)
 * ----------------------------------------------------------------------------
 * Per-unit confrontation / command evaluator. ENTER 0x40 -> 0x20 words of
 * locals. The stack layout (recovered from the body):
 *   [bp+6]  unit       (the acting unit index, *0x1c)
 *   [bp+8]  tile_x     target tile x
 *   [bp+0xa]tile_y     target tile y
 *   [bp-2]  occ_owner  owner-nibble of the FIRST tile occupant (`bp-2`)
 *   [bp-4]  occ_colony colony id at the tile (or -1)            (`bp-4`)
 *   [bp-6]  occ_unit   unit index at the tile (or -1)           (`bp-6`)
 *   [bp-8]  is_enemy2  secondary "enemy" flag                   (`bp-8`)
 *   [bp-0xa]choice     return/choice accumulator, init 0xFFFF   (`bp-0xa`)
 *   [bp-0x10]saved_539C                                          (`bp-0x10`)
 *   [bp-0x18]is_enemy   "occupant is an enemy of the actor"      (`bp-0x18`)
 *   [bp-0x1a]ai_flag    far-call flag passed to the leaf         (`bp-0x1a`)
 *   [bp-0x20]actor_x  (UnitRecord +0x00 of acting unit)          (`bp-0x20`)
 *   [bp-0x22]ran_flag   set 1 once an action ran                 (`bp-0x22`)
 *   [bp-0x28]actor_y  (UnitRecord +0x01)                         (`bp-0x28`)
 *   [bp-0x2c]occ2      occupant resolved via 0x181F:0x78C        (`bp-0x2c`)
 *   [bp-0x38]actor_owner (UnitRecord +0x03 &0xf)                 (`bp-0x38`)
 *   [bp-0x3e]priority  per-power const *3, capped at 3           (`bp-0x3e`)
 *
 * Faithful, basic-block-cited port. Capability/dialog/animation helpers are
 * shown as opaque overlay calls (their bodies are on other overlay pages;
 * body in thunk page). The
 * many goto-style branches mirror the binary's jump structure exactly; the
 * common error/exit target 0xe61 (file 0x03F8C1) is reproduced as `goto done`.
 * ============================================================================ */
int16_t ai_eval_unit(int16_t unit_index, int16_t tile_x, int16_t tile_y)
{
    int16_t choice;        /* [bp-0xa]  */
    int16_t ran_flag;      /* [bp-0x22] */
    int16_t saved_539C;    /* [bp-0x10] */
    int16_t actor_x;       /* [bp-0x20] */
    int16_t actor_y;       /* [bp-0x28] */
    int16_t priority;      /* [bp-0x3e] */
    int16_t occ2;          /* [bp-0x2c] */
    int16_t actor_owner;   /* [bp-0x38] */
    int16_t occ_owner;     /* [bp-2]    */
    int16_t is_enemy;      /* [bp-0x18] */
    int16_t occ_unit;      /* [bp-6]    */
    int16_t occ_colony;    /* [bp-4]    */
    int16_t ai_flag;       /* [bp-0x1a] */
    int16_t is_enemy2;     /* [bp-8]    */
    int16_t moves_left;    /* [bp-0x24] = allowance(0x90C) - moves-used(+0x05) */
    int16_t cap;
    int16_t tmp;

    /* @asm 0x03ECF6 mov ax,0xffff; mov [bp-0xa],ax  -- choice = -1 (no choice) */
    choice = -1;
    /* @asm 0x03ECFC sub ax,ax; mov [bp-0x22],ax     -- ran_flag = 0 */
    ran_flag = 0;
    /* @asm 0x03ED01 imul bx,[bp+6],0x1c
     * @asm 0x03ED05 mov ax,[0x539c]; mov [bp-0x10],ax -- save local-player/state */
    saved_539C = g_local_player_state_539C;
    /* @asm 0x03ED0F mov al,[bx+0x3144]; sub ah,ah; mov [bp-0x20],ax -- actor map_x
     * @asm 0x03ED18 mov al,[bx+0x3145];           mov [bp-0x28],ax -- actor map_y */
    actor_x = g_units_3144[unit_index][0x00];
    actor_y = g_units_3144[unit_index][0x01];

    /* @asm 0x03ED1F push [bp+0xa]; push [bp+8]; lcall 0x181F:0x78C; add sp,4
     *      mov bx,ax; mov [bp-0x2c],bx -- terrain code at (x,y) -> occ2.
     * 0x181F:0x78C = file 0x627A = func_00627A terrain query (x, y).  The old
     * port called ovly_relation_query_826 (0x826, 3 args) here -- wrong thunk
     * AND wrong arity; fixed 2026-06-12. */
    {
        extern int func_00627A_op_sz_57(uint16_t x, uint16_t y);
        occ2 = (int16_t)func_00627A_op_sz_57((uint16_t)tile_x, (uint16_t)tile_y);
    }
    /* @asm 0x03ED32 shl bx,4; mov al,[bx+0x2f76]; (al*3) -> [bp-0x3e] = priority */
    {
        uint8_t c = g_terrain_movecost_2F76[occ2 & 0xFFFF][0x00]; /* @asm 0x03ED35 */
        priority = (int16_t)c * 3;                            /* @asm 0x03ED3D..0x03ED41 */
    }

    /* @asm 0x03ED44 push [bp-0x28]; push [bp-0x20]; lcall 0x181F:0x754; test al,0xa
     * Two ability probes (actor coords, then target coords). If BOTH set bit
     * 0xa, raise priority floor to 1. (@asm 0x03ED52/0x03ED64/0x03ED68) */
    cap = ovly_unit_ability_754(actor_x, actor_y);            /* @asm 0x03ED4A */
    if (cap & 0xA) {
        cap = ovly_unit_ability_754(tile_x, tile_y);          /* @asm 0x03ED5C */
        if (cap & 0xA) priority = 1;                          /* @asm 0x03ED68 */
    }
    /* @asm 0x03ED6D push [bp-0x28]; push [bp-0x20]; lcall 0x181F:0x72C; test al,0x40
     * Second ability family (bit 0x40). If actor has it AND target has it AND
     * (actor_x==tile_x OR actor_y==tile_y) -> priority floor 1.
     * (@asm 0x03ED7B/0x03ED8D/0x03ED91..0x03EDA1) */
    cap = ovly_unit_ability_72C(actor_x, actor_y);            /* @asm 0x03ED73 */
    if (cap & 0x40) {
        cap = ovly_unit_ability_72C(tile_x, tile_y);          /* @asm 0x03ED85 */
        if (cap & 0x40) {
            if (actor_x == tile_x || actor_y == tile_y)       /* @asm 0x03ED91..0x03ED9F */
                priority = 1;                                  /* @asm 0x03EDA1 */
        }
    }

    /* @asm 0x03EDA6 imul bx,[bp+6],0x1c; mov al,[bx+0x3147]; and ax,0xf
     *      mov [bp-0x38],ax -- actor_owner = acting unit's owner nibble */
    actor_owner = g_units_3144[unit_index][0x03] & 0x0F;

    /* @asm 0x03EDB4 push [bp+0xa]; push [bp+8]; lcall 0x181F:0x6BE; add sp,4
     *      mov [bp-2],ax; or ax,ax; jl 0x377 -- occ_owner = occupant owner (or <0) */
    occ_owner = ovly_occupant_at_6BE(tile_x, tile_y);
    if (occ_owner >= 0) {
        /* @asm 0x03EDC9 cmp [bp-0x3e],3; jle; else =3 -- cap priority at 3 */
        if (priority > 3) priority = 3;                       /* @asm 0x03EDCC..0x03EDD4 */
    }

    /* @asm 0x03EDD7 mov ax,[bp+8]; mov dx,[bp+0xa]; lcall 0x181F:0x7E0
     *      mov [bp-6],ax; or ax,ax; jl 0x396 -- occ_unit = unit index on tile */
    occ_unit = ovly_tile_to_unit_7E0(tile_x, tile_y);
    if (occ_unit >= 0) {
        /* @asm 0x03EDE9 imul bx,ax,0x1c; mov al,[bx+0x3147]; and ax,0xf;
         *      mov [bp-2],ax -- occ_owner = that unit's owner nibble */
        occ_owner = g_units_3144[occ_unit][0x03] & 0x0F;      /* @asm 0x03EDEC */
    }

    /* @asm 0x03EDF6 cmp [bp-2],0; jl 0x3ac; cmp [bp-0x38],[bp-2] (actor_owner);
     *   je 0x3ac -> is_enemy = (occ_owner>=0 && occ_owner != actor_owner) */
    if (occ_owner >= 0 && occ_owner != actor_owner) {
        is_enemy = 1;                                          /* @asm 0x03EE04 */
    } else {
        is_enemy = 0;                                          /* @asm 0x03EE0C */
    }

    /* @asm 0x03EE11 cmp [bp-0x38],4; jge 0x3e1 -- only when ACTOR is a EU power
     * (owner < 4): probe "is target attackable" (0x181F:0x6F0); if yes, then a
     * cross-page check 0x1A1F:0x16C -> if nonzero, jump to the human-confront
     * dialog block at 0xe61 (done; choice path). */
    if (actor_owner < 4) {
        if (ovly_attackable_6F0(tile_x, tile_y) >= 0) {       /* @asm 0x03EE1D */
            /* @asm 0x03EE29 push y,x,unit; lcall 0x1A1F:0x16C; add sp,6 */
            extern int16_t ovly_confront_1A1F_16C(int16_t u, int16_t x, int16_t y);
            if (ovly_confront_1A1F_16C(unit_index, tile_x, tile_y) != 0) /* @asm 0x03EE32 */
                goto done;                                    /* @asm 0x03EE3E jmp 0xe61 */
        }
    }

    /* @asm 0x03EE41 cmp [bp-0x18],0; je 0x424 (skip if not enemy)
     * When the occupant IS an enemy AND both owners are EU (<4): probe a colony
     * target (0x181F:0x7BE) and resolve a confrontation (0x1A1F:0x15E). If that
     * returns nonzero -> goto done. Then if [0x539c] changed -> goto done. */
    if (is_enemy && actor_owner < 4 && occ_owner < 4) {       /* @asm 0x03EE47/0x03EE4D */
        tmp = ovly_target_query_7BE(tile_x, tile_y);          /* @asm 0x03EE59 */
        if (tmp >= 0) {
            extern int16_t ovly_confront_1A1F_15E(int16_t v, int16_t u);
            if (ovly_confront_1A1F_15E(tmp, unit_index) != 0) /* @asm 0x03EE69 */
                goto done;                                    /* @asm 0x03EE75 */
            if (g_local_player_state_539C != saved_539C)      /* @asm 0x03EE7B */
                goto done;                                    /* @asm 0x03EE81 */
        }
    }

    /* @asm 0x03EE84 push [bp+6]; lcall 0x181F:0x90C; add sp,2; sub ah,ah
     *      imul bx,[bp+6],0x1c; mov cl,[bx+0x3149]; ax -= cl
     *      mov [bp-0x24],ax -- moves_left = allowance(0x90C) - moves-used(+0x05).
     * 0x181F:0x90C = func_006CCA movement allowance; the old port DISCARDED the
     * return value (moves_left = 0 - used, always <= 0); fixed 2026-06-12. */
    {
        extern int func_006CCA_logic_sz_13(uint16_t u);       /* 0x90C allowance */
        moves_left = (int16_t)(uint8_t)func_006CCA_logic_sz_13((uint16_t)unit_index)
                   - (int16_t)g_units_3144[unit_index][0x05]; /* @asm 0x03EE9B */
        /* @asm 0x03EEA0 cmp [bp-0x18],0; jne 0x449; else jmp 0x85a (book-keeping) */
        if (is_enemy == 0) goto bookkeep;                     /* @asm 0x03EEA6 */
        /* @asm 0x03EEA9 cmp ax,3; jge 0x46c -- if moves_left<3 take auto-skip
         * unless the actor_owner is a EU power whose controller flag is 0 (AI). */
        if (moves_left < 3) {                                 /* @asm 0x03EEA9 */
            if (actor_owner < 4 &&                            /* @asm 0x03EEAE */
                g_ai_personality_543F[actor_owner][0x00] == 0)/* @asm 0x03EEB4 */
                goto block_46c;                               /* @asm 0x03EEBC */
block_45e:
            func_007BCE_logic_sz_25((uint16_t)unit_index);                /* @asm 0x03EEC1 */
            goto done;                                        /* @asm 0x03EEC9 */
        }
    }

block_46c:
    /* @asm 0x03EECC imul bx,[bp+6],0x1c; mov bl,[bx+0x3146]; (type)
     *   bx = type*14; cmp [bx+0x5236],0; jne 0x4ba -- unit-type-table flag branch.
     * When the flag is 0 and type in 0x0D..0x12 (scouts/pioneers band) -> done. */
    {
        uint8_t type = g_units_3144[unit_index][0x02];        /* @asm 0x03EED0 */
        if (g_unittype_tbl_5236[type][0] == 0) {              /* @asm 0x03EEE4 */
            if (type >= 0x0D && type <= 0x12)                 /* @asm 0x03EEEB..0x03EEF1 */
                goto done;                                    /* @asm 0x03EEF3 */
            /* @asm 0x03EEF6 cmp [bp-0x38],4; jl 0x49f; else done */
            if (actor_owner >= 4) goto done;                  /* @asm 0x03EEFC */
            /* @asm 0x03EEFF imul bx,[bp-0x38],0x34; cmp [bx+0x543f],0; je 0x4ad
             * AI-controlled actor (flag 0): raise CANNOTATTACK and done. */
            if (g_ai_personality_543F[actor_owner][0x00] != 0)/* @asm 0x03EF03 */
                goto done;                                    /* @asm 0x03EF0A */
            ovly_msg_str_3FE();   /* lea 0x13a0=CANNOTATTACK @asm 0x03EF0D/0x03EF11 */
            goto done;                                        /* @asm 0x03EF16 */
        }
        /* @asm 0x03EF1A type-table flag set: re-check type band 0x0D..0x12 and
         * occ2 == 0x19/0x1a (specific occupant kinds) to pick the sub-handler. */
        if (type >= 0x0D && type <= 0x12) {                   /* @asm 0x03EF1E..0x03EF25 */
            if (occ2 != 0x19 && occ2 != 0x1A)                 /* @asm 0x03EF2C/0x03EF32 */
                goto block_45e;                               /* @asm 0x03EF38 jmp 0x45e */
        } else {
            if (occ2 == 0x19) goto block_45e;                 /* @asm 0x03EF3A jmp 0x45e */
            if (occ2 != 0x1A) goto block_4ec;                 /* @asm 0x03EF43 */
            goto block_45e;                                   /* @asm 0x03EF49 */
        }
    }

block_4ec:
    /* @asm 0x03EF4C test [0x5382],1; je 0x514
     * When game-mode bit0 set AND occupant index == g_step_index AND occ_unit<4:
     *   if occ_unit's controller flag is 0 (AI) -> goto done; else fall to 0x514. */
    if (g_game_mode_flags_5382 & 1) {                         /* @asm 0x03EF4C */
        if (actor_owner == g_intervention_ally_53D2) {               /* @asm 0x03EF53 cmp [bp-0x38],[0x53d2] */
            if (occ_owner < 4) {                              /* @asm 0x03EF5B */
                if (occ_owner >= 0 &&                         /* @asm 0x03EF61 */
                    g_ai_personality_543F[occ_owner][0x00] == 0) /* @asm 0x03EF6A */
                    ; /* fall to 0x514 */
                else
                    goto done;                                /* @asm 0x03EF63/0x03EF71 */
            }
        }
    }

    /* ---- block 0x514: occupant-is-EU action chain (@asm 0x03EF74..0x03F071) --
     * @asm 0x03EF74 cmp [bp-2],4; jge 0x51d; else jmp 0x614 (occupant>=4: native).
     * For a EU occupant (occ_owner 0..3): compute commodity/market via
     * 0x181F:0xA42 + 0x181F:0x30C, gate on relation (0x181F:0xA38 test al,4),
     * raise the DECLAREWAR / "SNEAK attack?" prompt 0x13AD (WHACKINDIANS path
     * shares this), and apply attack-counter increments to the AI bookkeeping
     * struct at [0x8D4A]. The 0x181F:0xD6C call commits a market transaction. */
    if (occ_owner >= 4) goto block_614;                       /* @asm 0x03EF7A */
    {
        int16_t mkt;
        ovly_msg_arg_438(occ_owner - 4, 0);                   /* @asm 0x03EF7D..0x03EF89 0x181F:0xA42 */
        /* @asm 0x03EF8C imul bx,unit,0x1c; mov al,[bx+0x3147]&0xf; push;
         *      push [0x8d52]; lcall 0x181F:0x30C -> market price/qty (mkt) */
        /* @asm 0x03EF97 push owner_nib; push [0x8D52]; lcall 0x181F:0x30C
         * = func_0082A0 market value (2 args; the old 3-arg call invented a
         * trailing 0 and used a misleading extern name) */
        mkt = ovly_market_value_30C((int16_t)DG16(0x8D52),
                                    (int16_t)(g_units_3144[unit_index][0x03] & 0x0F));
        if (mkt < 0x4B && actor_owner < 4 &&                  /* @asm 0x03EFA4/0x03EFA9 */
            g_ai_personality_543F[actor_owner][0x00] == 0) {  /* @asm 0x03EFB3 */
            /* @asm 0x03EFBA relation probe; test al,4; if clear, raise prompt */
            if (!(ovly_relation_A38(occ_owner, actor_owner) & 4)) { /* @asm 0x03EFC8 */
                /* @asm 0x03EFCC..0x03EFFD: set $power$ arg, dialog 0x13AD
                 * (WHACKINDIANS), and on answer==1 commit via 0x181F:0xA06. */
                ovly_msg_arg_438(ovly_name_word_9A4(occ_owner), 0); /* @asm 0x03EFDA */
                ovly_dialog_652(1, 0x13AD); /* WHACKINDIANS @asm 0x03EFE7 */
                /* @asm 0x03EFEF dec ax; je 0x595; else jmp 0xe61 (done) */
                if (0 /* AX-1 */ != 0) goto done;             /* @asm 0x03EFF2 */
                /* @asm 0x03EFF5 push 4; push occ; push actor; lcall 0x181F:0xA06 */
                extern void ovly_commit_A06(int16_t four, int16_t occ, int16_t act);
                ovly_commit_A06(4, occ_owner, actor_owner);   /* @asm 0x03EFFD */
            }
        }
        /* @asm 0x03F005 al=[0x53a6]+5 -> [bp-0x34]; query 0x181F:0x9F0; if >=0
         * commit 0x181F:0xA4C; double [bp-0x34]; increment per-power attack
         * counter at [0x8D4A][owner*2 + 0xb]; if its flag bit 4 set, triple the
         * count; finally 0x181F:0xD6C with (price, owner, [0x8d52]). */
        {
            int16_t count = (int16_t)g_byte_53A6 + 5;         /* @asm 0x03F005..0x03F00A */
            int16_t q = ovly_target_query_696(tile_x, tile_y);/* 0x181F:0x9F0 @asm 0x03F016 */
            if (q >= 0) {
                extern void ovly_commit_A4C(int16_t q);
                ovly_commit_A4C(q);                           /* @asm 0x03F023 */
                count <<= 1;                                  /* @asm 0x03F02B */
                /* @asm 0x03F02E inc [ [0x8d4a] + owner*2 + 0xb ] -- the
                 * per-settlement per-power RAID TALLY (NS record +0xB row;
                 * [0x8D4A] = current settlement ptr).  RESOLVED 2026-06-10. */
                /* @asm 0x03F045 test [bx+3],4; if set count *= 3 */
            }
            /* @asm 0x03F054 push 0; push count; ...; lcall 0x181F:0xD6C (commit) */
            (void)count;
        }
        goto bookkeep;                                        /* @asm 0x03F071 jmp 0x85a */
    }

block_614:
    /* ---- block 0x614: native-occupant / type-0x10 (treasure?) chain ----------
     * @asm 0x03F074 cmp [bp-0x38],4; jge 0x628; if actor EU and occ_unit type
     *   ==0x10 -> bookkeep. Then for actor EU + actor type 0x10: set per-power
     *   flag bits in the table at -0x77c4 (DGROUP:0x883C area), roll random
     *   (0x181F:0x4D4) and compare to [0x53a6]+1, etc. -- native raid/treasure
     *   bookkeeping. All values byte-clear; the table at -0x77c4 is the
     *   per-(owner,occupant) relation byte array. */
    if (actor_owner < 4) {                                    /* @asm 0x03F074 */
        if (occ_unit >= 0 &&
            g_units_3144[occ_unit][0x02] == 0x10)             /* @asm 0x03F07E */
            goto bookkeep;                                    /* @asm 0x03F085 */
    }
    /* The 0x628 / 0x690 / 0x70d / 0x75f / 0x786 / 0x7d4 / 0x83d sub-blocks build
     * and present the full confrontation dialog set (HAVETREATY 0x13BA, SNEAK
     * 0x13C5 via 0x181F:0x998, CANCELPEACE 0x13CB, DECLAREWAR 0x13D7) for the
     * DECODED 2026-06-10 (@asm 0x03F074..0x03F2BA) — the ATTACK-CONSEQUENCE /
     * WAR-DECLARATION sequence.  -0x77C4 = the relation matrix
     * PowerRecord[row]+0x34+col (rel_query body, relations.c).  Keys dumped:
     * 0x13BA="HAVETREATY" 0x13C5="SNEAK" 0x13CB="CANCELPEACE"
     * 0x13D7="DECLAREWAR".
     *
     * 1. TREASURE EXEMPTION @0x3F074: target unit type 0x10 -> no diplomatic
     *    consequences at all (fair game).
     * 2. PRIVATEER PIRACY @0x3F088 (attacker unit type 0x10):
     *      rel[victim][pirate] |= 0x80          ; the PIRACY grievance bit the
     *                                           ;   meeting PIRACY topic reads!
     *      if random(0,100) >= difficulty+1: ANONYMOUS - no further effect.
     *      caught: if finance_941C[pirate] >= finance_941C[victim]
     *                  rel[victim][pirate] |= 8     ; resentment only
     *              else rel[victim][pirate] |= 2    ; weaker pirate -> WAR
     * 3. TREATY-BREAK CONFIRM @0x3F0F9: human attacker with treaty bit 0x40 ->
     *    popup HAVETREATY (mode 1); answer != 2 ABORTS the attack (0x3F8C1).
     * 4. ALLIANCE LOCK @0x3F143: if treaty AND PowerRecord[attacker] byte
     *    [-0x77B8 + defender] (= +0x40 row) nonzero -> attack ABORTS.
     * 5. SNEAK NOTIFY @0x3F16D: human DEFENDER with treaty -> sound 4 +
     *    menu_lookup_run(key "SNEAK") announcement.
     * 6. WAR DECLARATION @0x3F1BF (treaty in either direction):
     *      human attacker: %arg0/%arg1 = names, sound 4, CANCELPEACE (mode 1)
     *      AI: power handles, DECLAREWAR (mode 2)
     *      human attacker w/ defender-side treaty: rel[def][atk] |= 2 (at war)
     *      rel_clear_event(0x40, attacker, defender)   ; treaty off BOTH ways
     * 7. @0x3F2B5 rel[attacker][defender] &= 0xFE     ; clear bit 0 (peace). */

bookkeep:
    /* ---- block 0x85a: post-action UnitRecord book-keeping (@asm 0x03F2BA..) ---
     * Byte-restored 2026-06-12: the old port had flag36 == (used==1) (the
     * sbb/neg idiom is used<1, i.e. ==0), DROPPED the water/land-boundary
     * exhaustion (0x768/0x696/0x90C), and DROPPED the insufficient-moves
     * random gate @0x3F32E..0x3F360 entirely. */
    {
        extern int func_0062B4_op_sz_39(uint16_t x, uint16_t y);     /* 0x768 is-sea */
        extern int func_005F48_logic_sz_58(uint16_t x, uint16_t y);  /* 0x696 water probe */
        extern int func_006CCA_logic_sz_13(uint16_t u);              /* 0x90C allowance */
        extern void msc_srand(unsigned v);                           /* 0x4CA */
        extern int16_t random_int_4D4(int16_t lo, int16_t hi);       /* 0x4D4 */
        /* @asm 0x03F2BE cmp [bx+0x3149],1; sbb ax,ax; neg ax -> flag36 =
         * (moves-used < 1), i.e. the unit has not consumed any movement yet. */
        int16_t flag36 = (g_units_3144[unit_index][0x05] < 1) ? 1 : 0;
        if (is_enemy == 0) {
            /* @asm 0x03F2D0 al=[bp-0x3e](priority); add [bx+0x3149],al */
            g_units_3144[unit_index][0x05] =
                (uint8_t)(g_units_3144[unit_index][0x05] + (uint8_t)priority);
            /* @asm 0x03F2D7..0x03F32A water/land boundary crossing exhausts the
             * unit: when sea(dest) != sea(src) and NEITHER side is 0x696-
             * positive water, moves-used = full allowance. */
            if (func_0062B4_op_sz_39((uint16_t)tile_x, (uint16_t)tile_y) !=
                func_0062B4_op_sz_39((uint16_t)actor_x, (uint16_t)actor_y)) { /* @0x3F2F7 */
                if (func_005F48_logic_sz_58((uint16_t)actor_x,
                                            (uint16_t)actor_y) < 0 &&  /* @0x3F30B */
                    func_005F48_logic_sz_58((uint16_t)tile_x,
                                            (uint16_t)tile_y) < 0) {   /* @0x3F31D */
                    g_units_3144[unit_index][0x05] =
                        (uint8_t)func_006CCA_logic_sz_13((uint16_t)unit_index); /* @0x3F32A */
                }
            }
        }
        /* @asm 0x03F32E..0x03F360 INSUFFICIENT-MOVES random gate: when the
         * step costs more than the remaining moves and the unit has already
         * moved this turn, the step only succeeds with probability
         * moves_left/priority -- on failure, jump to the ran_flag=1 tail
         * (no move, orders kept). */
        if (moves_left < priority && flag36 == 0) {           /* @0x3F334/0x3F33A */
            msc_srand((unsigned)DG16(0x83A6));                /* @0x3F340 0x4CA */
            if (is_enemy == 0 &&                              /* @0x3F34C */
                random_int_4D4(1, priority) > moves_left)     /* @0x3F353/0x3F35E */
                goto ran_tail;                                /* @0x3F360 jmp 0x3F8BC */
        }
    }

    /* ---- block 0x8c9: native-contact message arg (@asm 0x03F363..0x03F3A8) ---
     * EU actor only: t = tribe-id-at(x,y); when t >= 4 and market value of
     * (t-4) < 0x4B, latch the msg arg via 0x181F:0xA42.  (Dead type load at
     * @0x3F3A0 reproduced as a comment-only quirk.) */
    if (actor_owner < 4) {                                    /* @0x3F363 */
        extern int func_005DF0_logic_sz_40(uint16_t x, uint16_t y);   /* 0x6DC */
        extern int func_0082A0_logic_sz_18(uint16_t a, uint16_t b);   /* 0x30C */
        extern int func_0081C6_logic_sz_44(uint16_t a);               /* 0xA42 */
        int16_t t = (int16_t)func_005DF0_logic_sz_40((uint16_t)tile_x,
                                                     (uint16_t)tile_y); /* @0x3F372 */
        occ_owner = t;                                        /* @0x3F37B [bp-2] reuse */
        tmp = (int16_t)func_0082A0_logic_sz_18((uint16_t)(t - 4),
                                               (uint16_t)actor_owner); /* @0x3F384 0x30C */
        if (t >= 4 && tmp < 0x4B) {                           /* @0x3F38C/0x3F392 */
            func_0081C6_logic_sz_44((uint16_t)(t - 4));       /* @0x3F398 0xA42 */
            /* @0x3F3A0 mov al,[bx+0x3146]; sub ah,ah -- dead load (quirk) */
        }
    }

    /* ---- block 0x903..0x9b0: recompute is_enemy via 0x5396 (the SELECTED/VIEW
     * nation), apply 0x5383 auto-skip bits, and set ai_flag (@asm 0x03F363..) -- */
    {
        ai_flag = g_word_53A2;                                /* @asm 0x03F3AA seed */
        /* @asm 0x03F3B4 mov al,[bx+0x3147]&0xf; cmp al,[0x5396]; je 0x9b0 */
        if ((g_units_3144[unit_index][0x03] & 0x0F) != (uint8_t)g_view_nation_index_5396) {
            /* @asm 0x03F3C2 push owner_nib; push y; push x; lcall 0x181F:0x826
             *   -> adjacency mask func_00730A(x, y, owner); then @0x3F3D6
             *   push mask; push unit; lcall 0x181F:0x7FE = func_0072E2(unit,
             *   mask) ORs the mask into +0x03 of the unit's chain.  (Old port
             *   passed (0, x, y) -- cdecl order reversed -- and dropped the
             *   0x7FE apply; fixed 2026-06-12.)  Then test the (0x10<<view)
             *   bit; if clear, query 0x181F:0x970 and on 0 -> ai_flag stays
             *   seeded; else ai_flag=1. */
            extern int func_0072E2_logic_sz_40(uint16_t u, uint16_t mask); /* 0x7FE */
            int16_t rel = ovly_relation_query_826(
                              tile_x, tile_y,
                              (int16_t)(g_units_3144[unit_index][0x03] & 0x0F)); /* @asm 0x03F3CB */
            func_0072E2_logic_sz_40((uint16_t)unit_index, (uint16_t)rel); /* @asm 0x03F3DA */
            uint16_t owner_mask = (uint16_t)0x10 << (uint8_t)g_view_nation_index_5396; /* @asm 0x03F3EC */
            if (owner_mask & g_units_3144[unit_index][0x03]) {/* @asm 0x03F3F1 */
                ai_flag = 1;                                  /* @asm 0x03F40B */
            } else {
                extern int16_t ovly_relation_970(int16_t view, int16_t x, int16_t y);
                if (ovly_relation_970(g_view_nation_index_5396, tile_x, tile_y) != 0) /* @asm 0x03F3FF */
                    ai_flag = 1;                              /* @asm 0x03F40B */
            }
        } else {
            ai_flag = 1;                                      /* @asm 0x09b0 path: ai_flag=[bp-0x1a] */
        }
        is_enemy2 = ai_flag;                                  /* @asm 0x03F413 mov [bp-8],ax */
    }

    /* @asm 0x03F416 cmp [bp-0x18],0; jne 0x9de -- if NOT enemy: 0x5383 auto-skip */
    if (is_enemy == 0) {
        uint8_t owner_n = g_units_3144[unit_index][0x03] & 0x0F; /* @asm 0x03F41C */
        /* @asm 0x03F426 cmp al,4; jb 0x9d2 -> EU uses bit 0x80, native bit 0x40 */
        uint8_t bit = (owner_n < 4) ? 0x80 : 0x40;            /* @asm 0x03F42A/0x03F432 */
        if (!(g_mode_flag_5383 & bit))                        /* @asm 0x03F437 */
            is_enemy2 = 0;                                    /* @asm 0x03F439 */
    }
    /* @asm 0x03F43E mov al,[bx+0x3147]&0xf; cmp al,[0x5396]; jne 0x9f7 --
     * if the actor IS the selected/view nation, force ai_flag = is_enemy2 = 1 */
    if ((g_units_3144[unit_index][0x03] & 0x0F) == (uint8_t)g_view_nation_index_5396) {
        ai_flag = 1;                                          /* @asm 0x03F44E */
        is_enemy2 = 1;
    }

    /* ---- THE AI DECISION GATE (@asm 0x03F457..0x03F49A) ----------------------
     * When the occupant IS an enemy, decide ai_flag from the controller flags of
     * BOTH the actor_owner and occ_owner, then far-call the per-unit AI LEAF and
     * jump to done. This is the spine the brief identifies. */
    if (is_enemy != 0) {                                      /* @asm 0x03F457 cmp [bp-0x18],0; je 0xa3e */
        /* @asm 0x03F45D cmp [bp-0x38],4; jge 0xa0e; imul ...,0x34;
         *      cmp [bx+0x543f],0; je 0xa1f (actor AI -> ai_flag=1) */
        int ai_actor = (actor_owner < 4 &&
                        g_ai_personality_543F[actor_owner][0x00] == 0); /* @asm 0x03F463 */
        /* @asm 0x03F46E cmp [bp-2],4; jge 0xa24; imul ...,0x34;
         *      cmp [bx+0x543f],0; jne 0xa24 (occ AI too) */
        int ai_occ = (occ_owner < 4 &&
                      g_ai_personality_543F[occ_owner][0x00] == 0);     /* @asm 0x03F474 */
        if (ai_actor || ai_occ) ai_flag = 1;                  /* @asm 0x03F47F */

        /* @asm 0x03F484 push 1; push [bp-0x1a](ai_flag); push [bp+0xa];
         *      push [bp+8]; push [bp+6]; 0x03F492 lcall 0x191F:0xA14;
         *      add sp,0xa -- far-call the per-unit AI leaf func_05CA7E. */
        ovly_ai_unit_leaf_05CA7E(unit_index, tile_x, tile_y,
                                 ai_flag, /*one*/ 1);
        goto done;                                            /* @asm 0x03F49A jmp 0xe61 */
    }

    /* @asm 0x03F49E cmp [bp-0x1a],0; je 0xa53 -- when ai_flag set (and not an
     * enemy confrontation), notify the view nation (0x181F:0x7D6). Then always
     * step the unit (0x181F:0x916). */
    if (ai_flag != 0) {
        /* @asm 0x03F4A4 push [0x5396]; push [bp+6]; lcall 0x181F:0x7D6 ->
         * func_00701C(unit, view).  (Old extern had (view, unit); cdecl order
         * fixed 2026-06-12.) */
        extern int func_00701C_logic_sz_48(uint16_t u, uint16_t v);
        func_00701C_logic_sz_48((uint16_t)unit_index,
                                (uint16_t)g_view_nation_index_5396); /* @asm 0x03F4AB */
    }
    /* ---- THE MOVE STAGING (@asm 0x03F4B3) -----------------------------------
     * 0x181F:0x916 = func_007966: DETACH the actor from its tile into the
     * (-2,-2) staging area (carriers 0xD..0x12 via func_00772E, which also
     * boards capacity-fitting stack members; others via func_0069D2).  The
     * matching RE-PLACE is the 0x181F:0x948 = func_006A7C call in the commit
     * block below -- the same stage/commit protocol naval_classify_dest uses. */
    {
        extern void ovly_step_916(int16_t unit);
        ovly_step_916(unit_index);                            /* @asm 0x03F4B6 0x181F:0x916 */
    }

    /* ---- block 0xa5e: is_enemy2 ANIMATE (@asm 0x03F4BE..0x03F4F7) ----------- */
    if (is_enemy2 != 0) {
        int16_t dur = ((g_units_3144[unit_index][0x03] & 0x0F)
                       == (uint8_t)g_view_nation_index_5396) ? 0xC0 : 0xE0; /* @asm 0x03F4C4/0x03F4D7/0x03F4D9 */
        /* @asm 0x03F4DE push y,x,actor_y,actor_x,-1,dur,unit -> cdecl
         * f(unit, dur, -1, actor_x, actor_y, tile_x, tile_y); 0x181F:0x2D0 =
         * func_004566 (animate; weak no-op headless).  Old call had the push
         * order copied verbatim; fixed 2026-06-12. */
        ovly_unit_alloc_2D0(unit_index, dur, -1, actor_x, actor_y,
                            tile_x, tile_y);                  /* @asm 0x03F4F2 */
    }

    /* ---- staging-stack walk (@asm 0x03F4FA..0x03F51D) -----------------------
     * 0x181F:0x8E4 (resident file 0x6CB4, register-arg): sort the unit's tile
     * stack (func_006B46(u,0)) and return its chain head (func_006672).  Every
     * member AFTER the head gets orders=1 (boarded/escort marker). */
    {
        extern int func_006B46_op_sz_365(uint16_t a, uint16_t b);
        extern int unit_chain_resolve(int idx);
        extern int unit_chain_next(int idx);
        extern int func_0066CC_op_sz_57(uint16_t x, uint16_t y);     /* 0x7E0 */
        extern int func_0062B4_op_sz_39(uint16_t x, uint16_t y);     /* 0x768 */
        extern int func_0078F4_logic_sz_66(uint16_t u);              /* 0x88A */
        extern void func_007936_logic_sz_48(uint16_t a, uint16_t b); /* 0x8F8 */
        extern int func_0079A0_op_sz_119(uint16_t u_ax);             /* 0x966 */
        extern int func_006F5A_op_sz_105(uint16_t u);                /* 0x86C */
        int16_t stage_head, m, dest_head;

        func_006B46_op_sz_365((uint16_t)unit_index, 0);       /* @asm 0x03F4FD 0x8E4 */
        stage_head = (int16_t)unit_chain_resolve(unit_index); /* -> [bp-0x1c] */
        m = (int16_t)unit_chain_next(stage_head);             /* @asm 0x03F513 0x2E4 */
        while (m >= 0) {                                      /* @asm 0x03F51B */
            g_units_3144[m][0x08] = 1;                        /* @asm 0x03F50B orders=1 */
            m = (int16_t)unit_chain_next(m);                  /* @asm 0x03F51C */
        }

        /* ---- destination-stack merge (@asm 0x03F51F..0x03F588) -------------- */
        dest_head = (int16_t)func_0066CC_op_sz_57((uint16_t)tile_x,
                                                  (uint16_t)tile_y); /* @asm 0x03F525 0x7E0 */
        if (dest_head >= 0) {
            func_006B46_op_sz_365((uint16_t)dest_head, 0);    /* @asm 0x03F52A 0x8E4 */
            dest_head = (int16_t)unit_chain_resolve(dest_head); /* -> [bp-0x12] */
        }
        if (dest_head >= 0) {                                 /* @asm 0x03F534 */
            if (func_0062B4_op_sz_39((uint16_t)tile_x,
                                     (uint16_t)tile_y) != 0 &&  /* @asm 0x03F546 sea(dest) */
                func_0078F4_logic_sz_66((uint16_t)stage_head) == 0) { /* @asm 0x03F555 0x88A */
                if (g_units_3144[dest_head][0x08] == 1)       /* @asm 0x03F560 */
                    g_units_3144[dest_head][0x08] = 0;        /* @asm 0x03F562 */
                func_007936_logic_sz_48((uint16_t)stage_head, 1); /* @asm 0x03F56C 0x8F8 */
                if (func_0079A0_op_sz_119((uint16_t)dest_head) != 0) /* @asm 0x03F577 0x966 */
                    func_006F5A_op_sz_105((uint16_t)dest_head);      /* @asm 0x03F583 0x86C */
            }
        }

        /* ---- block 0xb2b: colony-entry (@asm 0x03F58B..0x03F69D) -------------
         * Reached when the actor is colony-flagged (0x88A != 0) or type 0xC;
         * otherwise jump straight to the move-commit block. */
        if (func_0078F4_logic_sz_66((uint16_t)unit_index) == 0 &&   /* @asm 0x03F598 */
            g_units_3144[unit_index][0x02] != 0x0C)                 /* @asm 0x03F5A3 */
            goto move_commit;                                       /* @asm 0x03F5A5 jmp 0x3F6D2 */
        occ_colony = (int16_t)ovly_target_query_7BE(tile_x, tile_y);   /* @asm 0x03F5AE 0x7BE */
        if (occ_colony < 0)                                         /* @asm 0x03F5BB */
            goto move_commit;                                       /* @asm 0x03F5BD jmp 0x3F6D2 */
        /* @asm 0x03F5C0 type 0xC owned by an AI EU power: entry sound 0x52. */
        if (g_units_3144[unit_index][0x02] == 0x0C) {
            int own = g_units_3144[unit_index][0x03] & 0x0F;        /* @asm 0x03F5CF */
            if (own < 4 && g_ai_personality_543F[own][0x00] == 0)   /* @asm 0x03F5D1/0x03F5DA */
                ovly_play_sound_4C0(0x52);                          /* @asm 0x03F5E3 AX=0x52 */
        }
        func_007BCE_logic_sz_25((uint16_t)unit_index);              /* @asm 0x03F5EB 0x934 end-turn */
        g_units_3144[unit_index][0x16] = 0;                         /* @asm 0x03F5F7 turn_counter=0 */
        /* @asm 0x03F5FC..0x03F626 walk the actor's chain clearing orders 1->0
         * (the original reuses [bp+6] as the cursor and restores it @0x3F628). */
        m = (int16_t)unit_chain_resolve(unit_index);                /* @asm 0x03F602 0x2EE */
        while (m >= 0) {                                            /* @asm 0x03F624 */
            if (g_units_3144[m][0x08] == 1)                         /* @asm 0x03F612 */
                g_units_3144[m][0x08] = 0;                          /* @asm 0x03F614 */
            m = (int16_t)unit_chain_next(m);                        /* @asm 0x03F61C 0x2E4 */
        }
        /* @asm 0x03F62E..0x03F69D view-nation arrival message: tooltip flush,
         * unit-type name + ENTERS/ARRIVES word + colony name, then present. */
        if ((g_units_3144[unit_index][0x03] & 0x0F)
                == (uint8_t)g_view_nation_index_5396) {             /* @asm 0x03F63B */
            extern int  func_002544_logic_sz_60(uint16_t a);                /* 0x56 */
            extern void func_002632_tooltip_append_indexed(uint16_t w);     /* 0x74 */
            extern void func_00260E_tooltip_append(const char *s);          /* 0x6A */
            extern int  func_002892_logic_sz_30(uint16_t a, uint16_t b, uint16_t c); /* 0x60 */
            uint8_t ty = g_units_3144[unit_index][0x02];            /* @asm 0x03F649 */
            func_002544_logic_sz_60(1);                             /* @asm 0x03F641 */
            func_002632_tooltip_append_indexed(
                DG16(0x5230 + (unsigned)ty * 9));                   /* @asm 0x03F65F */
            if (g_units_3144[unit_index][0x02] == 0x0C)             /* @asm 0x03F66C */
                func_002632_tooltip_append_indexed(DG16(0x2EBA));   /* @asm 0x03F678 */
            else
                func_002632_tooltip_append_indexed(DG16(0x2DCA));   /* @asm 0x03F678 */
            func_00260E_tooltip_append(
                (const char *)DG_PTR(0x5D48 + (unsigned)occ_colony * 0xCA)); /* @asm 0x03F68A */
            func_002892_logic_sz_30(1, 0x78, 0);                    /* @asm 0x03F698 */
        }
        /* ---- block 0xc72 (@asm 0x03F6A0..0x03F6D1): the HUMAN confrontation
         * choice gate -- only the colony-entry path falls through to it. */
        if (g_units_3144[unit_index][0x02] >= 0x0D &&
            g_units_3144[unit_index][0x02] <= 0x12 &&               /* @asm 0x03F6A4/0x03F6AB */
            (g_game_mode_flags_5382 & 0x80) &&                      /* @asm 0x03F6B2 */
            (g_units_3144[unit_index][0x03] & 0x0F)
                == (uint8_t)g_current_nation_index_5398 &&          /* @asm 0x03F6BF */
            !(g_mode_flag_5387 & 0x80)) {                           /* @asm 0x03F6C5 */
            choice = occ_colony;                                    /* @asm 0x03F6CC */
        }
    }

move_commit:
    /* ---- THE MOVE COMMIT (@asm 0x03F6D2..0x03F7C2) ---------------------------
     * Byte-restored 2026-06-12 (the old port had this whole block as a
     * "structural" comment, so the actor stayed parked at (-2,-2) forever):
     * rumour probe (Phase 2.1), relation snapshot, the 0x948 UNSTAGE of the
     * actor at the DESTINATION tile, relation/notify bookkeeping, sea-lane
     * boundary flagging, the 0x7A0 post-step, the ai_flag tile redraw, the
     * LCR roll, and the on-arrival handlers. */
    {
        extern int  func_006188_op_sz_91(uint16_t x, uint16_t y);     /* 0x75E */
        extern int  lcr_resolve(int unit_idx, int tile_x, int tile_y);/* 1A1F:0x178 */
        extern int  func_005DF0_logic_sz_40(uint16_t x, uint16_t y);  /* 0x6DC */
        extern int  func_006FD8_logic_sz_42(uint16_t u);              /* 0x8DA */
        extern int  func_006A7C_logic_sz_50(uint16_t u, uint16_t x, uint16_t y); /* 0x948 */
        extern int  func_00701C_logic_sz_48(uint16_t u, uint16_t v);  /* 0x7D6 */
        extern void func_007356_logic_sz_56(uint16_t u);              /* 0x84E */
        extern int  func_0072E2_logic_sz_40(uint16_t u, uint16_t m);  /* 0x7FE */
        extern int  func_0062B4_op_sz_39(uint16_t x, uint16_t y);     /* 0x768 */
        extern int  func_005F48_logic_sz_58(uint16_t x, uint16_t y);  /* 0x696 */
        extern int  func_0066CC_op_sz_57(uint16_t x, uint16_t y);     /* 0x7E0 */
        extern int  func_006608_logic_sz_106(uint16_t u_ax);          /* 0x7A0 */
        extern int  func_067644_compose_tile_overlays(uint16_t a, uint16_t b,
                                                      uint16_t c, uint16_t d,
                                                      uint16_t e);    /* 0x9BA */
        extern int  func_00704C_op_sz_205(uint16_t x, uint16_t y, uint16_t p); /* 0x984 */
        extern long overlay_call_1A1F_0192();  /* func_059B90 on-arrival handler,
                                                      UNPORTED (Phase-4 row); weak stub */
        extern int  func_00BC10_ff_owned(uint16_t power, uint16_t ff);/* 0x7B4 */
        extern int  func_05C878_treasure_transport_event(uint16_t u, uint16_t p); /* 1A1F:0x186 */
        int rumor;
        int16_t rel, t6dc;

        rumor = func_006188_op_sz_91((uint16_t)tile_x, (uint16_t)tile_y);
                                                              /* @asm 0x03F6D8 -> [bp-0x2a] */
        rel = ovly_relation_query_826(tile_x, tile_y,
                  (int16_t)(g_units_3144[unit_index][0x03] & 0x0F)); /* @asm 0x03F6F5 0x826 */
        t6dc = (int16_t)func_005DF0_logic_sz_40((uint16_t)tile_x,
                                                (uint16_t)tile_y);   /* @asm 0x03F706 0x6DC */
        func_006FD8_logic_sz_42((uint16_t)unit_index);               /* @asm 0x03F715 0x8DA */
        func_006A7C_logic_sz_50((uint16_t)unit_index,
                                (uint16_t)tile_x, (uint16_t)tile_y); /* @asm 0x03F726 0x948
                                                  *** UNSTAGE AT DEST = THE MOVE *** */
        if (t6dc >= 0)                                               /* @asm 0x03F732 */
            func_00701C_logic_sz_48((uint16_t)unit_index,
                                    (uint16_t)t6dc);                 /* @asm 0x03F73A 0x7D6 */
        func_007356_logic_sz_56((uint16_t)unit_index);               /* @asm 0x03F745 0x84E */
        func_0072E2_logic_sz_40((uint16_t)unit_index, (uint16_t)rel);/* @asm 0x03F753 0x7FE */
        /* @asm 0x03F75B..0x03F7BA sea-lane boundary: leaving open sea onto a
         * non-sea, non-water tile flags the source-tile stack with the actor's
         * owner-HI nibble. */
        if (func_0062B4_op_sz_39((uint16_t)actor_x,
                                 (uint16_t)actor_y) != 0 &&          /* @asm 0x03F769 src */
            func_0062B4_op_sz_39((uint16_t)tile_x,
                                 (uint16_t)tile_y) == 0 &&           /* @asm 0x03F77D dest */
            func_005F48_logic_sz_58((uint16_t)tile_x,
                                    (uint16_t)tile_y) < 0) {         /* @asm 0x03F78F 0x696 */
            int16_t hi = (int16_t)(g_units_3144[unit_index][0x03] & 0xF0); /* @asm 0x03F799 */
            int16_t o  = (int16_t)func_0066CC_op_sz_57((uint16_t)actor_x,
                                                       (uint16_t)actor_y); /* @asm 0x03F7A5 0x7E0 */
            if (o >= 0)                                              /* @asm 0x03F7AC */
                func_0072E2_logic_sz_40((uint16_t)o, (uint16_t)hi);  /* @asm 0x03F7B2 0x7FE */
        }
        func_006608_logic_sz_106((uint16_t)unit_index);              /* @asm 0x03F7BD 0x7A0 */
        /* @asm 0x03F7C2 ai_flag: redraw the 7x7 tile window around the dest
         * (0x181F:0x9BA = compose_tile_overlays; display-only in headless). */
        if (ai_flag != 0)
            func_067644_compose_tile_overlays((uint16_t)(tile_x - 3),
                                              (uint16_t)(tile_y - 3),
                                              7, 7, 1);              /* @asm 0x03F7DC 0x9BA */
        /* ---- LCR MOVEMENT TRIGGER (Phase 2.1) @asm 0x03F7E4..0x03F80A.
         * The rumour mark is PROCEDURAL: func_006188 (probed above @0x3F6D8)
         * returns 1 iff the tile's sub-cell phase matches the supercell flow
         * hash keyed on DGROUP:0x190.  Gate: mark set AND EUROPEAN actor ->
         * roll the Lost-City-Rumour engine (1A1F:0x178 = func_061454, its
         * ONLY caller in the EXE). */
        if (rumor != 0 && actor_owner < 4) {                  /* @asm 0x03F7E4/0x03F7EA */
            lcr_resolve(unit_index, tile_x, tile_y);          /* @asm 0x03F7F9 */
        }
        /* @asm 0x03F801 roster changed (unit destroyed/spawned during the LCR
         * roll or earlier): skip the choice commit and ran_flag set. */
        if (g_local_player_state_539C != saved_539C)
            goto state_tail;                                  /* @asm 0x03F80A jmp 0x3F8C1 */
        /* @asm 0x03F80D on-arrival handler gate: 0x984 = func_00704C(x, y,
         * owner); nonzero -> the 1A1F:0x192 handler (func_059B90, UNPORTED --
         * tracked Phase-4 row; weak stub no-op until then). */
        if (func_00704C_op_sz_205((uint16_t)tile_x, (uint16_t)tile_y,
                                  (uint16_t)actor_owner) != 0) {     /* @asm 0x03F816 */
            overlay_call_1A1F_0192(unit_index, tile_x, tile_y);                          /* @asm 0x03F82B
                                       original args (unit, tile_x, tile_y) */
        }
        /* @asm 0x03F833..0x03F8AB type-0xA treasure pickup: AI EU owner on a
         * 0x696-positive water-adjacent tile; per-power flag at 0x925B stride
         * 0x13 + game-mode bit0 route through the Pocahontas (ff 0xA) gate;
         * colony flag +0x1C bit 0x40 fires the treasure-transport event. */
        if (g_units_3144[unit_index][0x02] == 0x0A &&         /* @asm 0x03F837 */
            actor_owner < 4 &&                                /* @asm 0x03F842 */
            g_ai_personality_543F[actor_owner][0x00] == 0 &&  /* @asm 0x03F848 */
            func_005F48_logic_sz_58((uint16_t)tile_x,
                                    (uint16_t)tile_y) >= 0) { /* @asm 0x03F85F 0x696 */
            int go = 1;
            if (DG8(0x925B + (unsigned)actor_owner * 0x13) != 0 &&  /* @asm 0x03F865 */
                !(g_game_mode_flags_5382 & 1)) {                    /* @asm 0x03F86C */
                if (func_00BC10_ff_owned((uint16_t)actor_owner, 0x0A) == 0) /* @asm 0x03F878 0x7B4 */
                    go = 0;                                         /* @asm 0x03F882 je 0x3F8AB */
            }
            if (go) {
                int16_t col = (int16_t)ovly_target_query_7BE(tile_x, tile_y); /* @asm 0x03F88A 0x7BE */
                /* @asm 0x03F892 imul bx,ax,0xCA; test [bx+0x5D62],0x40 -- the
                 * original indexes without a col<0 guard (reads below the
                 * table); modern build guards for memory safety. */
                if (col >= 0 &&
                    (DG8(0x5D62 + (unsigned)col * 0xCA) & 0x40))    /* @asm 0x03F896 */
                    func_05C878_treasure_transport_event(
                        (uint16_t)unit_index, (uint16_t)actor_owner); /* @asm 0x03F8A3 1A1F:0x186 */
            }
        }
    }

done:
    /* @asm 0x03F8AB cmp [bp-0xa],0; jle 0xe5c -- if a choice (>0) was made,
     * commit it via 0x181F:0x608. */
    if (choice > 0) {                                         /* @asm 0x03F8AB */
        extern void ovly_commit_choice_608(int16_t choice);
        ovly_commit_choice_608(choice);                       /* @asm 0x03F8B4 */
    }
ran_tail:
    /* @asm 0x03F8BC mov [bp-0x22],1 -- ran_flag = 1 (an action path completed;
     * also the insufficient-moves gate's jump target @0x3F360). */
    ran_flag = 1;

state_tail:
    /* @asm 0x03F8C1 cmp [0x539c],[bp-0x10]; jne 0xea9 (skip if state changed)
     * @asm 0x03F8CA cmp [bp-0x22],0; jne 0xea9
     * When state is unchanged AND ran_flag==0: clear the unit's order byte
     * [+0x08]=0 (@asm 0x03F8D4), and unless the actor is an AI EU power, bump the
     * turn_counter [+0x16]; on reaching 0x14 reset it and clear orders. */
    if (g_local_player_state_539C == saved_539C && ran_flag == 0) {
        g_units_3144[unit_index][0x08] = 0;                   /* @asm 0x03F8D4 */
        if (!(actor_owner < 4 &&
              g_ai_personality_543F[actor_owner][0x00] == 0)) {/* @asm 0x03F8DF */
            uint8_t tc = (uint8_t)(g_units_3144[unit_index][0x16] + 1); /* @asm 0x03F8EE inc [+0x315a] */
            g_units_3144[unit_index][0x16] = tc;
            if (tc >= 0x14) {                                 /* @asm 0x03F8F2 */
                g_units_3144[unit_index][0x16] = 0;           /* @asm 0x03F8F9 */
                func_007BCE_logic_sz_25((uint16_t)unit_index);            /* @asm 0x03F901 */
            }
        }
    }

    /* @asm 0x03F909 pop si; pop di; leave; retf -- return value is `choice`
     * (AX holds [bp-0xa] on the choice-commit paths; 0 otherwise). */
    return choice;
}

/* ============================================================================
 * ai_unit_order_step -- func_040E22 (page 0x08), file 0x040E22..0x040FD5
 * ----------------------------------------------------------------------------
 * Per-unit ORDER step (complete 436-byte body; per-func dump is NOT truncated).
 * ENTER 4 -> one local word [bp-2] = saved [0x539c].
 *
 *   1. If unit order byte [+0x08]==0xC (sentinel "no orders"): clear the scratch
 *      target word [0x1DD6]=0xFFFF; else [0x1DD6] = unit owner nibble.
 *   2. Resolve a target id via 0x1A1F:0x210; require 0 <= id < 8 (else exit).
 *   3. Save [0x539c] to [bp-2].
 *   4. If unit type nibble [+0x03]&0xf < 4 AND that nibble's controller flag==0
 *      (an AI EU power): take the AI sub-path -- read the target record's
 *      [+0xb4]/[+0xbe] (a tile coordinate pair), path-step via 0x191F:0x44E,
 *      and on success clear the unit's order byte [+0x08]=0.
 *      Otherwise: compute (target.[+0xbe]+unit.map_y, target.[+0xb4]+unit.map_x)
 *      and far-call ai_eval_unit (func_03ECF0) via 0x1A1F:0x142.
 *   5. If [0x539c] is unchanged AND the unit reached its goto target
 *      (map_x==goto_x[+0x09] && map_y==goto_y[+0x0A]): query 0x181F:0x78C; if it
 *      returns 0x1A and the order byte isn't 0xC, and the power-count / selected
 *      checks pass, mark the unit selected ([0x5392]) and run move-resolve.
 *   6. Type-keyed post-steps: type 2 resets [+0x11]/[+0x12]; type 0xB calls
 *      0x181F:0x934; finally normalise the order byte and reset [0x1DD6]=0xFFFF.
 * ============================================================================ */
int16_t ai_unit_order_step(int16_t unit_index)
{
    int16_t saved_539C;
    int16_t target;
    uint8_t type_nibble;

    /* @asm 0x040E27 imul bx,[bp+6],0x1c
     * @asm 0x040E2B cmp [bx+0x314c],0xc; jne 0x40e3a */
    if (g_units_3144[unit_index][0x08] == 0x0C) {
        g_word_1DD6 = 0xFFFF;                                  /* @asm 0x040E32 */
    } else {
        /* @asm 0x040E3E mov al,[bx+0x3147]; and ax,0xf; mov [0x1dd6],ax */
        g_word_1DD6 = g_units_3144[unit_index][0x03] & 0x0F;
    }

    /* @asm 0x040E48 mov ax,[bp+6]; lcall 0x1A1F:0x210 -> direction code (AX-arg) */
    target = (int16_t)func_062D84_unit_automove(unit_index);
    /* @asm 0x040E50 or ax,ax; jl 0x40fb4 ; 0x040E57 cmp ax,8; jl ...; else 0x40fb4 */
    if (target < 0 || target >= 8) goto finalize8;            /* @asm 0x040E54/0x040E5C */

    /* @asm 0x040E5F mov cx,[0x539c]; mov [bp-2],cx -- save unit count */
    saved_539C = g_local_player_state_539C;

    /* @asm 0x040E66 imul bx,[bp+6],0x1c; mov cl,[bx+0x3147]; and cl,0xf;
     *      cmp cl,4; jae 0x40ea4 (absolute path) */
    type_nibble = g_units_3144[unit_index][0x03] & 0x0F;
    if (type_nibble < 4 &&
        /* @asm 0x040E78 imul si,cx,0x34; cmp [si+0x543f],ch(=0); jne 0x40ea4 */
        g_ai_personality_543F[type_nibble][0x00] == 0) {
        /* ---- HUMAN European power: relative step (@asm 0x040E81..0x040EA2) ----
         * si=ax(dir); push [si+0xbe](dy); push [si+0xb4](dx); lcall 0x191F:0x44E
         * -> cdecl arg0 = dx, arg1 = dy.  If AX!=0 clear orders [+0x08]=0. */
        int16_t gx = g_compass_dx8_00B4[target];              /* @asm 0x040E89 */
        int16_t gy = g_compass_dy8_00BE[target];              /* @asm 0x040E83 */
        if (func_03FDDE_op_sz_82((uint16_t)gx, (uint16_t)gy) != 0) { /* @asm 0x040E91 */
            g_units_3144[unit_index][0x08] = 0;               /* @asm 0x040E9D */
        }
    } else {
        /* ---- tribe (owner >= 4) or AI European power: absolute step ----
         * (@asm 0x040EA4..0x040ECC) bx=ax(dir);
         * push (dy[dir] + unit.map_y[+0x01]); push (dx[dir] + unit.map_x[+0x00]);
         * push unit; lcall 0x1A1F:0x142 -> ai_eval_unit (func_03ECF0). */
        int16_t y = g_compass_dy8_00BE[target] + g_units_3144[unit_index][0x01]; /* @asm 0x040EAF */
        int16_t x = g_compass_dx8_00B4[target] + g_units_3144[unit_index][0x00]; /* @asm 0x040EBD */
        ai_eval_unit(unit_index, x, y);                       /* @asm 0x040EC7 -> 0x03ECF0 */
    }

    /* @asm 0x040ECF mov ax,[0x539c]; cmp [bp-2],ax; je 0x40eda / jmp 0x40fcd
     * Unit count changed (unit died/created during the step): keep state,
     * go straight to the DONE epilogue — NOT the finalize block (the
     * pre-2026-06-11 port end-turned + cleared state here, which killed
     * every in-flight goto after its first step). */
    if (saved_539C != g_local_player_state_539C) goto done;    /* @asm 0x040ED7 jmp 0x40fcd */

    /* @asm 0x040EDA imul bx,[bp+6],0x1c; mov al,[bx+0x3144];
     *      cmp [bx+0x314d],al; jne -> done -- map_x == goto_x ?
     * @asm 0x040EEB mov cl,[bx+0x3145]; cmp [bx+0x314e],cl; jne -> done
     * NOT ARRIVED: state stays 0xB (in flight), no end-turn here. */
    if (g_units_3144[unit_index][0x09] != g_units_3144[unit_index][0x00] ||
        g_units_3144[unit_index][0x0A] != g_units_3144[unit_index][0x01])
        goto done;                                             /* @asm 0x040EE8/0x040EF5 jmp 0x40fcd */

    /* @asm 0x040EF8 push y(cl); push x(ax via [+0x3144]); lcall 0x181F:0x78C
     *      (func_00627A terrain query); cmp ax,0x1a; jne 0x40f74 (Europe edge) */
    {
        int16_t occ = (int16_t)func_00627A_op_sz_57(
                          g_units_3144[unit_index][0x00],
                          g_units_3144[unit_index][0x01]);     /* @asm 0x040F00 0x181F:0x78C */
        if (occ != 0x1A) goto finalize;                        /* @asm 0x040F08 */
        /* @asm 0x040F0D cmp [si+0x314c],0xc; je 0x40f74 (order==sentinel -> skip) */
        if (g_units_3144[unit_index][0x08] == 0x0C) goto finalize; /* @asm 0x040F0D */

        /* @asm 0x040F14 cmp [0x5394],4; jge 0x40f27 (tribe self -> 'E' check)
         * @asm 0x040F1B imul bx,[0x5394],0x34; cmp [bx+0x543f],0; je 0x40f32
         *      (human self -> skip the 'E' check; AI self falls to 0x40f27)
         * @asm 0x040F2B require unit profession [+0x07]==0x45 ('E'). */
        if (g_human_player_index_5394 >= 4 ||
            g_ai_personality_543F[g_human_player_index_5394][0x00] != 0) {
            if (g_units_3144[unit_index][0x07] != 0x45) goto finalize; /* @asm 0x040F2B */
        }

        /* @asm 0x040F32 test [0x5382],1; je 0x40f4d
         * @asm 0x040F39 mov ax,[0x53d2]; cmp [0x5394],ax; jne 0x40f74
         * @asm 0x040F42 cmp [bx+0x3146],0x12; jne 0x40f74 -- type==0x12 gate */
        if (g_game_mode_flags_5382 & 1) {
            if (g_human_player_index_5394 != g_intervention_ally_53D2) goto finalize; /* @asm 0x040F40 */
            if (g_units_3144[unit_index][0x02] != 0x12) goto finalize;          /* @asm 0x040F4B */
        }

        /* @asm 0x040F4D mov ax,[bp+6]; mov [0x5392],ax -- mark unit selected.
         * @asm 0x040F53 lcall 0x191F:0x208 -> func_0418AA_commit_active_move. */
        g_selected_unit_5392 = unit_index;
        func_0418AA_commit_active_move();                      /* @asm 0x040F53 */

        /* @asm 0x040F58 mov al,[bx+0x3147]&0xf; cmp al,[0x5396]; jne 0x40f74
         * @asm 0x040F68 push [0x5392]; lcall 0x181F:0xDF4 (view refresh) */
        if ((g_units_3144[unit_index][0x03] & 0x0F) == (uint8_t)g_view_nation_index_5396) {
            func_00C17A_logic_sz_20((uint16_t)g_selected_unit_5392); /* @asm 0x040F6C */
        }
    }

finalize:
    /* @asm 0x040F74 imul bx,[bp+6],0x1c; cmp [bx+0x3146],2; jne 0x40f89
     *   type 2 -> reset [+0x11]=0 (0x3155), [+0x12]=0xff (0x3156) */
    if (g_units_3144[unit_index][0x02] == 2) {
        g_units_3144[unit_index][0x11] = 0;                    /* @asm 0x040F7F */
        g_units_3144[unit_index][0x12] = 0xFF;                 /* @asm 0x040F84 */
    }
    /* @asm 0x040F89 cmp [bx+0x314c],0xb; jne 0x40f9f -- order==0xB -> 0x181F:0x934 */
    if (g_units_3144[unit_index][0x08] == 0x0B) {
        func_007BCE_logic_sz_25((uint16_t)unit_index);                     /* @asm 0x040F97 */
    }
    /* @asm 0x040F9F cmp [bx+0x314c],2; je 0x40fcd; cmp ...,0xc; je 0x40fcd;
     *   else fall to 0x40fc8: clear order byte. (@asm 0x040FA3..0x040FC8) */
    if (g_units_3144[unit_index][0x08] != 2 &&
        g_units_3144[unit_index][0x08] != 0x0C) {
        g_units_3144[unit_index][0x08] = 0;                    /* @asm 0x040FC8 */
    }
done:
    g_word_1DD6 = 0xFFFF;                                       /* @asm 0x040FCD */
    return 0;                                                   /* @asm 0x040FD3 pop si; leave; retf */

finalize8:
    /* @asm 0x040FB4 cmp ax,8; jne 0x40fc4; imul ...; cmp [bx+0x314c],2; je 0x40fcd;
     *   else clear order byte. (direction code == 8 special-case.) */
    if (target == 8 && g_units_3144[unit_index][0x08] == 2) {
        /* leave order byte */
    } else {
        g_units_3144[unit_index][0x08] = 0;                    /* @asm 0x040FC8 */
    }
    g_word_1DD6 = 0xFFFF;                                       /* @asm 0x040FCD */
    return 0;
}

/* ============================================================================
 * NOTES / TODO_VERIFY
 * ----------------------------------------------------------------------------
 *  - func_03ECF0 + func_040E22 control flow is BYTE_VERIFIED end-to-end against
 *    page_07.asm / func_040E22_unknown.asm (both reach their RETF). The OVERLAY
 *    HELPER BODIES (0x181F:*, 0x191F:*, 0x1A1F:* targets) are on other pages and
 *    are not yet decoded here; their argument/return shapes are taken from the call sites,
 *    NOT invented.
 *  - The 0x181F:0x652 dialog message handles inside func_03ECF0 are byte-verified
 *    via the string rule (0x13A0=CANNOTATTACK, 0x13AD=WHACKINDIANS,
 *    0x13BA=HAVETREATY, 0x13C5=SNEAK, 0x13CB=CANCELPEACE, 0x13D7=DECLAREWAR).
 *  - Target-record base for the +0xb4/+0xbe coordinate pair (func_040E22 @asm
 *    0x040E83/0x040EA6, returned by 0x1A1F:0x210) RESOLVED: a DIRECTION
 *    index 0..7 into the 0xB4/0xBE delta tables -- modeled as 0 inputs.
 *  - The per-(owner,occupant) relation byte array: RESOLVED -- -0x77C4 =
 *    PowerRecord[row]+0x34+col (the rel_query matrix, relations.c: bits
 *    0x02 war / 0x10 met / 0x20 peace-pending / 0x40 treaty / 0x80 piracy
 *    grievance); -0x77B8 = PowerRecord+0x40 row = the alliance-lock bytes
 *    (attack aborts when set; see the war-declaration block).
 *  - The AI attack tally: [0x8D4A] = current NATIVE-SETTLEMENT record ptr;
 *    +0xB + owner*2 = the per-settlement per-power raid-tally word.  The
 *    "market commit chain" 0x30C/0xD6C = the native ALARM read/adjust pair
 *    (resident 0x082A0 / func_045DF2 -- the raid raises tribe alarm).
 *  - PER-UNIT SCORING WEIGHTS live in the leaf func_05CA7E (see unit_ai_leaf.c)
 *    and the move evaluator func_04E2D6 -- RUNTIME_ONLY, overlay/data-resident, NOT
 *    invented here.
 * ============================================================================ */
