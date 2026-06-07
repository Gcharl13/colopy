/* ============================================================================
 *                  >>> BYTE_VERIFIED (control flow + globals) <<<
 *              >>> per-unit SCORING WEIGHTS in the leaf: TBD <<<
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
 *        byte-verified; the SCORING WEIGHTS are TBD (overlay/data-resident).
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
 * @ref             code/VICEROY/disasm_overlay_reseg/page_07.asm
 * @ref             code/VICEROY/disasm_overlay_reseg/page_08.asm
 * @ref             code/VICEROY/disasm/func_040E22_unknown.asm
 * @ref             code/VICEROY/strings.json (message handles)
 * @ref             code/VICEROY/typeA_thunk_targets.json
 * ============================================================================ */
#include "viceroy_types.h"

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

/* DGROUP:0x53D2 -- per-turn index compared to the resolved confrontation index
 * `cmp [bp-0x38],[0x53d2]` (@asm 0x03EF53) and `cmp [0x5394],[0x53d2]`
 * (@asm 0x040F39). Role: "index currently being stepped". TBD exact semantics. */
extern int16_t g_step_index_53D2;

/* DGROUP:0x53A2 -- word seeded into a local at @asm 0x03F3AA (a default flag).
 * DGROUP:0x53A6 -- byte read as a small count/bonus (@asm 0x03F005 +5;
 *                  0x03F0B2 inc; 0x03F351 used as a roll input). TBD. */
extern int16_t g_word_53A2;
extern uint8_t g_byte_53A6;

/* DGROUP:0x1DD6 -- scratch "current order target" word; set to 0xFFFF as a
 * sentinel at the head/tail of the order step (@asm 0x040E32 / 0x040FCD). */
extern uint16_t g_word_1DD6;
/* DGROUP:0x5392 -- "selected unit" word, written in the order step's
 * matched-unit path (@asm 0x040F50). */
extern int16_t g_selected_unit_5392;

/* DGROUP:0x2F76 -- per-power constants table, stride 16 (`shl bx,4`); byte +0
 * read and tripled at entry (@asm 0x03ED32..0x03ED41 -> [bp-0x3e] = c*3). The
 * tripled value caps an order priority at 3 (@asm 0x03EDCC). TBD: full layout. */
extern uint8_t g_power_const_2F76[/* power */][16];

/* DGROUP:0x5236 / 0x5230 -- per-unit-type tables, stride 14 (the `*14` build at
 * @asm 0x03EED4..0x03EEE2 and 0x03F64D..0x03F659). 0x5236[type*14] is a flag
 * tested == 0 (@asm 0x03EEE4); 0x5230[type*14] a word pushed to a query
 * (@asm 0x03F65B). TBD: table contents. */
extern uint8_t g_unittype_tbl_5236[/* type */][14];
extern uint8_t g_unittype_tbl_5230[/* type */][14];

/* DGROUP:0x8D4A / 0x8D52 -- overlay-resident pointers/handles consumed by the
 * AI-controlled "increment attack-counter" path (@asm 0x03F03D mov bx,[0x8d4a];
 * inc [bx+si+0xb]) and the trade-route helpers (push [0x8d52] @asm 0x03EF98).
 * TBD: pointed-to struct. */
extern uint16_t g_ptr_8D4A;
extern uint16_t g_word_8D52;

/* ----------------------------------------------------------------------------
 * Cross-page leaves and overlay helpers (reached via RTLink far-thunks).
 * Each cites the LCALL site; the resolving thunk is in typeA_thunk_targets.json.
 * Helper SEMANTICS are from call context and are TBD where the leaf body was
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
 * byte-clear; the exact ability semantics are TBD. */
extern int16_t ovly_unit_ability_754(int16_t x, int16_t y);  /* @asm 0x03ED4A/0x03ED5C */
extern int16_t ovly_unit_ability_72C(int16_t x, int16_t y);  /* @asm 0x03ED73/0x03ED85 */
extern int16_t ovly_occupant_at_6BE(int16_t x, int16_t y);   /* @asm 0x03EDBA -> owner-nibble holder */
extern int16_t ovly_tile_to_unit_7E0(int16_t x, int16_t y);  /* @asm 0x03EDDD -> unit idx (or <0) */
extern int16_t ovly_attackable_6F0(int16_t x, int16_t y);    /* @asm 0x03EE1D */
extern int16_t ovly_relation_A38(int16_t a, int16_t b);      /* @asm 0x03EFC0.. test al,4/0x40 */
extern int16_t ovly_name_word_9A4(int16_t idx);              /* @asm 0x03F237/0x03F24A power-name word */
extern int16_t ovly_relation_query_826(int16_t owner, int16_t x, int16_t y); /* @asm 0x03F3CB */
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
extern void    ovly_clear_orders_934(int16_t unit);          /* @asm 0x03EEC1/0x03F5EB clears state */
extern void    ovly_finalize_unit_90C(int16_t unit);         /* @asm 0x03EE87/0x03F31F */

/* Cross-page (0x1A1F / 0x191F) handlers used by func_040E22 + tail of 03ECF0. */
extern int16_t ovly_target_resolve_1A1F_210(int16_t unit);   /* @asm 0x040E4B -> 0..7 target id */
extern int16_t ovly_path_step_191F_44E(int16_t gy, int16_t gx);/* @asm 0x040E91 */
extern void    ovly_eval_unit_thunk_1A1F_142(int16_t unit, int16_t x, int16_t y);/* -> 0x03ECF0 */
extern int16_t ovly_move_resolve_191F_208(void);             /* @asm 0x040F53 */
extern void    ovly_route_helper_181F_DF4(int16_t unit);     /* @asm 0x040F6C */

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
 * shown as opaque overlay calls (their bodies are on other pages / TBD). The
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
     *      mov bx,ax; mov [bp-0x2c],bx -- resolve occupant id at (x,y) -> occ2 */
    occ2 = ovly_relation_query_826(0, tile_x, tile_y); /* 0x181F:0x78C; args (y,x) */
    /* @asm 0x03ED32 shl bx,4; mov al,[bx+0x2f76]; (al*3) -> [bp-0x3e] = priority */
    {
        uint8_t c = g_power_const_2F76[occ2 & 0xFFFF][0x00]; /* @asm 0x03ED35 */
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
     *      mov [bp-0x24],ax -- ax = finalize(unit) - UnitRecord.field_05 */
    {
        int16_t moves_left;
        ovly_finalize_unit_90C(unit_index);                   /* @asm 0x03EE87, returns AX */
        moves_left = 0 /* AX */ - g_units_3144[unit_index][0x05]; /* @asm 0x03EE9B */
        /* @asm 0x03EEA0 cmp [bp-0x18],0; jne 0x449; else jmp 0x85a (book-keeping) */
        if (is_enemy == 0) goto bookkeep;                     /* @asm 0x03EEA6 */
        /* @asm 0x03EEA9 cmp ax,3; jge 0x46c -- if moves_left<3 take auto-skip
         * unless the actor_owner is a EU power whose controller flag is 0 (AI). */
        if (moves_left < 3) {                                 /* @asm 0x03EEA9 */
            if (actor_owner < 4 &&                            /* @asm 0x03EEAE */
                g_ai_personality_543F[actor_owner][0x00] == 0)/* @asm 0x03EEB4 */
                goto block_46c;                               /* @asm 0x03EEBC */
            ovly_clear_orders_934(unit_index);                /* @asm 0x03EEC1 */
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
        if (actor_owner == g_step_index_53D2) {               /* @asm 0x03EF53 cmp [bp-0x38],[0x53d2] */
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
        mkt = ovly_target_query_826(g_units_3144[unit_index][0x03] & 0x0F,
                                    g_word_8D52, 0);          /* @asm 0x03EF9C */
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
                /* @asm 0x03F02E inc [ [0x8d4a] + owner*2 + 0xb ] (attack tally) */
                /* (pointer struct TBD; the increment + bit-4 triple are byte-clear) */
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
     * various (actor controller flag, occupant relation) combinations, then OR
     * relation bits into the -0x77c4 table and clear bit 0 (0xfe mask). They are
     * a long sequence of `cmp [bp-0x38],4 / imul ...,0x34 / cmp [bx+0x543f],0 /
     * 0x181F:0xA38 test al,0x40` gates feeding 0x181F:0x652 dialog calls. The
     * message handles are byte-verified (above); the precise human-vs-AI routing
     * for each combination is reproduced structurally and the per-relation table
     * semantics at -0x77c4 are TBD. (@asm 0x03F088..0x03F2BA.) */

bookkeep:
    /* ---- block 0x85a: post-action UnitRecord book-keeping (@asm 0x03F2BA..) ---
     * @asm 0x03F2BA imul bx,unit,0x1c; cmp [bx+0x3149],1; sbb/neg -> a 0/1 flag
     *   into [bp-0x36]. If NOT enemy: add priority to [bx+0x3149]; compare two
     *   tile->unit lookups (0x181F:0x768) and adjacency (0x181F:0x696); if the
     *   actor advanced, store the new tile-unit into [bx+0x3149]. */
    {
        int16_t flag36 = (g_units_3144[unit_index][0x05] == 1) ? 1 : 0; /* @asm 0x03F2BE..0x03F2C7 */
        if (is_enemy == 0) {
            /* @asm 0x03F2D0 al=[bp-0x3e](priority); add [bx+0x3149],al */
            g_units_3144[unit_index][0x05] =
                (uint8_t)(g_units_3144[unit_index][0x05] + (uint8_t)priority);
        }
        (void)flag36;
    }

    /* ---- block 0x903..0x9b0: recompute is_enemy via 0x5396 (the SELECTED/VIEW
     * nation), apply 0x5383 auto-skip bits, and set ai_flag (@asm 0x03F363..) -- */
    {
        ai_flag = g_word_53A2;                                /* @asm 0x03F3AA seed */
        /* @asm 0x03F3B4 mov al,[bx+0x3147]&0xf; cmp al,[0x5396]; je 0x9b0 */
        if ((g_units_3144[unit_index][0x03] & 0x0F) != (uint8_t)g_view_nation_index_5396) {
            /* @asm 0x03F3C2 query relation 0x181F:0x826; then 0x181F:0x7FE; then
             * test the (0x10<<view) bit of [si+0x3147]; if clear, query
             * 0x181F:0x970 and on 0 -> ai_flag stays seeded; else ai_flag=1. */
            int16_t rel = ovly_relation_query_826(
                              0, tile_x, tile_y);             /* @asm 0x03F3CB */
            (void)rel;
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
        extern void ovly_notify_view_7D6(int16_t view, int16_t unit);
        ovly_notify_view_7D6(g_view_nation_index_5396, unit_index); /* @asm 0x03F4AB */
    }
    {
        extern void ovly_step_916(int16_t unit);
        ovly_step_916(unit_index);                            /* @asm 0x03F4B6 0x181F:0x916 */
    }

    /* ---- block 0xa5e..0xb2b: when is_enemy2 set, ANIMATE the unit moving onto
     * the tile (0x181F:0x2D0 spawn/animate with a duration 0xC0 or 0xE0 keyed on
     * whether the actor is the view nation), then walk the tile's unit chain via
     * 0x181F:0x2E4 / 0x8E4 setting order byte [+0x08]=1 on each, and possibly
     * clear it (=0) on the matched neighbour. (@asm 0x03F4BE..0x03F588.) */
    if (is_enemy2 != 0) {
        int16_t dur = ((g_units_3144[unit_index][0x03] & 0x0F)
                       == (uint8_t)g_view_nation_index_5396) ? 0xC0 : 0xE0; /* @asm 0x03F4C4/0x03F4D7/0x03F4D9 */
        ovly_unit_alloc_2D0(tile_y, tile_x, actor_y, actor_x,
                            -1, dur, unit_index);             /* @asm 0x03F4F2 */
        /* (chain walk + order-byte updates: structural; see @asm 0x03F4FA..0x03F588) */
    }

    /* ---- block 0xb2b..0xc72: when this unit hits a colony tile (type 0xc or a
     * colony id from 0x181F:0x88A/0x7BE), play the entry sound (0x181F:0x4C0
     * snd 0x52) for an AI-controlled adjacent EU, clear UnitRecord turn_counter
     * [+0x16]=0 (@asm 0x03F5F7), walk units on the tile, and (for native units
     * type 0x0D..0x12 owned by the view nation) emit the colony/native message
     * via 0x181F:0x74 with the unit-type table [0x5230]/[0x2EBA]/[0x2DCA] and a
     * colony record at (0x5D48 + colony*0xCA). (@asm 0x03F58B..0x03F69D.) */

    /* ---- block 0xc72..0xe5c: the HUMAN confrontation entry. When the acting
     * unit is in the type band 0x0D..0x12, game-mode bit 0x80 is set, the unit
     * owner == current_nation (0x5398), and 0x5387 bit 0x80 is clear, store the
     * colony id into `choice` (@asm 0x03F6CC). Then resolve the occupant
     * (0x181F:0x75E -> [bp-0x2a]), query relations (0x181F:0x826/0x6DC), and run
     * the long human-interaction tail (0x1A1F:0x178/0x192/0x186 cross-page
     * handlers, colony record at 0x5D62 bit-0x40 test). (@asm 0x03F6A0..0x03F8AB.)
     * These present the player's options; the byte logic is reproduced as the
     * fast-path gate below and the rest is structurally cited. */
    if (g_units_3144[unit_index][0x02] >= 0x0D &&
        g_units_3144[unit_index][0x02] <= 0x12 &&             /* @asm 0x03F6A4/0x03F6AB */
        (g_game_mode_flags_5382 & 0x80) &&                    /* @asm 0x03F6B2 */
        (g_units_3144[unit_index][0x03] & 0x0F)
            == (uint8_t)g_current_nation_index_5398 &&        /* @asm 0x03F6BF */
        !(g_mode_flag_5387 & 0x80)) {                         /* @asm 0x03F6C5 */
        choice = occ_colony;                                  /* @asm 0x03F6CC mov ax,[bp-4]; [bp-0xa]=ax */
    }
    /* (occupant resolution + relation queries + cross-page human handlers:
     *  @asm 0x03F6D2..0x03F8AB -- structural; helper bodies TBD.) */

done:
    /* @asm 0x03F8AB cmp [bp-0xa],0; jle 0xe5c -- if a choice (>0) was made,
     * commit it via 0x181F:0x608. */
    if (choice > 0) {                                         /* @asm 0x03F8AB */
        extern void ovly_commit_choice_608(int16_t choice);
        ovly_commit_choice_608(choice);                       /* @asm 0x03F8B4 */
    }
    /* @asm 0x03F8BC mov [bp-0x22],1 -- ran_flag = 1 (an action path completed) */
    ran_flag = 1;

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
                ovly_clear_orders_934(unit_index);            /* @asm 0x03F901 */
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

    /* @asm 0x040E48 mov ax,[bp+6]; lcall 0x1A1F:0x210 -> target id */
    target = ovly_target_resolve_1A1F_210(unit_index);
    /* @asm 0x040E50 or ax,ax; jl 0x40fb4 ; 0x040E57 cmp ax,8; jl ...; else 0x40fb4 */
    if (target < 0 || target >= 8) goto finalize8;            /* @asm 0x040E54/0x040E5C */

    /* @asm 0x040E5F mov cx,[0x539c]; mov [bp-2],cx -- save state */
    saved_539C = g_local_player_state_539C;

    /* @asm 0x040E66 imul bx,[bp+6],0x1c; mov cl,[bx+0x3147]; and cl,0xf;
     *      cmp cl,4; jae 0x40ea4 (manual path) */
    type_nibble = g_units_3144[unit_index][0x03] & 0x0F;
    if (type_nibble < 4 &&
        /* @asm 0x040E78 imul si,cx,0x34; cmp [si+0x543f],ch(=0); jne 0x40ea4 */
        g_ai_personality_543F[type_nibble][0x00] == 0) {
        /* ---- AI sub-path (@asm 0x040E81..0x040EA2) ----
         * si=ax(target); push [si+0xbe]; push [si+0xb4]; si=bx(unit);
         * lcall 0x191F:0x44E; if AX!=0 clear unit order byte [+0x08]=0.
         * The target record base is the value returned by 0x1A1F:0x210 used as a
         * byte index; +0xb4/+0xbe are a coordinate pair in that record. */
        int16_t gx = 0; /* [target+0xb4] -- target-record base TBD */
        int16_t gy = 0; /* [target+0xbe] */
        if (ovly_path_step_191F_44E(gy, gx) != 0) {           /* @asm 0x040E91 */
            g_units_3144[unit_index][0x08] = 0;               /* @asm 0x040E9D */
        }
    } else {
        /* ---- manual / other path (@asm 0x040EA4..0x040ECC) ----
         * bx=ax(target); push (target.[+0xbe] + unit.map_y[+0x01]) as y;
         *                push (target.[+0xb4] + unit.map_x[+0x00]) as x;
         * push unit; lcall 0x1A1F:0x142 -> ai_eval_unit (func_03ECF0).
         * (target-record base for +0xb4/+0xbe is TBD; the +unit-coord math is
         *  byte-clear at @asm 0x040EAF/0x040EBD.) */
        int16_t y = 0 /* target.[+0xbe] */ + g_units_3144[unit_index][0x01];
        int16_t x = 0 /* target.[+0xb4] */ + g_units_3144[unit_index][0x00];
        ovly_eval_unit_thunk_1A1F_142(unit_index, x, y);      /* @asm 0x040EC7 -> 0x03ECF0 */
    }

    /* @asm 0x040ECF mov ax,[0x539c]; cmp [bp-2],ax; jne 0x40fcd
     * Only continue when the local-player state is unchanged. */
    if (saved_539C != g_local_player_state_539C) goto finalize;/* @asm 0x040ED7 */

    /* @asm 0x040EDA imul bx,[bp+6],0x1c; mov al,[bx+0x3144];
     *      cmp [bx+0x314d],al; jne 0x40fcd -- map_x == goto_x ?
     * @asm 0x040EEB mov cl,[bx+0x3145]; cmp [bx+0x314e],cl; jne 0x40fcd -- map_y==goto_y? */
    if (g_units_3144[unit_index][0x09] != g_units_3144[unit_index][0x00] ||
        g_units_3144[unit_index][0x0A] != g_units_3144[unit_index][0x01])
        goto finalize;

    /* @asm 0x040EF8 push goto_y(cl); push map_x(ax via [+0x3144]); lcall 0x181F:0x78C;
     *      cmp ax,0x1a; jne 0x40f74 -- occupant kind == 0x1a (a colony?) */
    {
        int16_t occ = ovly_relation_query_826(
                          0,
                          g_units_3144[unit_index][0x00],
                          g_units_3144[unit_index][0x01]);     /* @asm 0x040F00 0x181F:0x78C */
        if (occ != 0x1A) goto finalize;                        /* @asm 0x040F08 */
        /* @asm 0x040F0D cmp [si+0x314c],0xc; je 0x40f74 (order==sentinel -> skip) */
        if (g_units_3144[unit_index][0x08] == 0x0C) goto finalize; /* @asm 0x040F0D */

        /* @asm 0x040F14 cmp [0x5394],4; jge 0x40f27 -- power-count guard.
         * @asm 0x040F1B imul bx,[0x5394],0x34; cmp [bx+0x543f],0; je 0x40f32
         * Else require unit profession [+0x07]==0x45 (@asm 0x040F2B). */
        if (g_human_player_index_5394 < 4 &&
            g_ai_personality_543F[g_human_player_index_5394][0x00] != 0) {
            if (g_units_3144[unit_index][0x07] != 0x45) goto finalize; /* @asm 0x040F2B */
        }

        /* @asm 0x040F32 test [0x5382],1; je 0x40f4d
         * @asm 0x040F39 mov ax,[0x53d2]; cmp [0x5394],ax; jne 0x40f74
         * @asm 0x040F42 cmp [bx+0x3146],0x12; jne 0x40f74 -- type==0x12 gate */
        if (g_game_mode_flags_5382 & 1) {
            if (g_human_player_index_5394 != g_step_index_53D2) goto finalize; /* @asm 0x040F40 */
            if (g_units_3144[unit_index][0x02] != 0x12) goto finalize;          /* @asm 0x040F4B */
        }

        /* @asm 0x040F4D mov ax,[bp+6]; mov [0x5392],ax -- mark unit selected.
         * @asm 0x040F53 lcall 0x191F:0x208 (move-resolve). */
        g_selected_unit_5392 = unit_index;
        ovly_move_resolve_191F_208();                          /* @asm 0x040F53 */

        /* @asm 0x040F58 mov al,[bx+0x3147]&0xf; cmp al,[0x5396]; jne 0x40f74
         * @asm 0x040F68 push [0x5392]; lcall 0x181F:0xDF4 (route helper, view) */
        if ((g_units_3144[unit_index][0x03] & 0x0F) == (uint8_t)g_view_nation_index_5396) {
            ovly_route_helper_181F_DF4(g_selected_unit_5392);  /* @asm 0x040F6C */
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
        ovly_clear_orders_934(unit_index);                     /* @asm 0x040F97 */
    }
    /* @asm 0x040F9F cmp [bx+0x314c],2; je 0x40fcd; cmp ...,0xc; je 0x40fcd;
     *   else fall to 0x40fc8: clear order byte. (@asm 0x040FA3..0x040FC8) */
    if (g_units_3144[unit_index][0x08] != 2 &&
        g_units_3144[unit_index][0x08] != 0x0C) {
        g_units_3144[unit_index][0x08] = 0;                    /* @asm 0x040FC8 */
    }
    g_word_1DD6 = 0xFFFF;                                       /* @asm 0x040FCD */
    return 0;                                                   /* @asm 0x040FD3 mov ax,[bp-2]? -> AX; net 0 */

finalize8:
    /* @asm 0x040FB4 cmp ax,8; jne 0x40fc4; imul ...; cmp [bx+0x314c],2; je 0x40fcd;
     *   else clear order byte. (target id == 8 special-case.) */
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
 *    are TBD here; their argument/return shapes are taken from the call sites,
 *    NOT invented.
 *  - The 0x181F:0x652 dialog message handles inside func_03ECF0 are byte-verified
 *    via the string rule (0x13A0=CANNOTATTACK, 0x13AD=WHACKINDIANS,
 *    0x13BA=HAVETREATY, 0x13C5=SNEAK, 0x13CB=CANCELPEACE, 0x13D7=DECLAREWAR).
 *  - Target-record base for the +0xb4/+0xbe coordinate pair (func_040E22 @asm
 *    0x040E83/0x040EA6, returned by 0x1A1F:0x210) is TBD -- modeled as 0 inputs.
 *  - The per-(owner,occupant) relation byte array at DGROUP base (si - 0x77c4 /
 *    -0x77b8) used for war/treaty/sneak bookkeeping: stride 0x13C, indexed
 *    [occ*0x13c + owner] -- byte-clear addressing, table CONTENTS TBD.
 *  - The AI attack-tally struct at [0x8D4A] (+0xb + owner*2, bit-4 triple) and
 *    market commit chain (0x181F:0x30C/0xD6C/0xA06/0xA4C): addressing byte-clear,
 *    pointed-to structs TBD.
 *  - PER-UNIT SCORING WEIGHTS live in the leaf func_05CA7E (see unit_ai_leaf.c)
 *    and the move evaluator func_04E2D6 -- TBD, overlay/data-resident, NOT
 *    invented here.
 * ============================================================================ */
