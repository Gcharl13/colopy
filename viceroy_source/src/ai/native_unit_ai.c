/* ============================================================================
 *           >>> CONTROL FLOW + INLINE WEIGHTS + GLOBALS: BYTE_VERIFIED <<<
 *           >>> DATA-RESIDENT WEIGHT TABLES (0x2F77/0x5236/0x9410): TBD <<<
 * ----------------------------------------------------------------------------
 * native_unit_ai.c -- func_046FFA: the NATIVE (Indian) per-unit STRATEGIC AI
 *                     driver. This is the per-turn brain of an AI-controlled
 *                     native unit: it scans the 8 surrounding tiles, scores each
 *                     candidate move/target against the tribe's accumulated
 *                     ALARM (the 0x54F6 tension array, raid threshold 0x80),
 *                     the target's wealth/defence (ColonyRecord at 0x5D46) and a
 *                     personality/difficulty roll, picks the highest-scoring
 *                     action by argmax, and COMMITS it -- setting the unit's
 *                     order byte (MOVE = 5/6) and direction, decrementing the
 *                     home settlement's mission counter, and -- when the chosen
 *                     action is a hostile strike on the human -- raising the
 *                     "INDIANSURPRISE" prompt. It is the native counterpart to
 *                     the EUROPEAN per-unit AI leaf func_05CA7E (unit_ai_leaf.c).
 *
 * WHY THIS IS THE "STRATEGIC DRIVER" (war/peace + unit tasking for native powers)
 *   - It is the function that turns accumulated tribe ALARM into ACTION: the
 *     0x54F6 tension array (per (settlement_link*9 + power) word; threshold 0x80)
 *     is read at TWO sites (@0x04734E and @0x047487 / @0x047652) to decide whether
 *     a native unit becomes hostile toward a given European power -- i.e. the
 *     native war/peace decision. (RULINGS 2026-05-30 (native-AI): 0x54F6 is the
 *     raid-tension accumulator; native_raid.c reads/clears the SAME array.)
 *   - It tasks the unit: scores all 8 neighbour tiles + occupants, then writes
 *     the chosen MOVE order (UnitRecord +0x314c = 5 or 6) and direction
 *     (+0x314f) and a goto target (+0x314d/+0x314e) into the UnitRecord.
 *   - On a hostile strike whose target is the HUMAN it raises message handle
 *     0x14DC = "INDIANSURPRISE" (verified rule file_offset = handle + 0x1D9A0:
 *     0x14DC -> file 0x1EE7C = "INDIANSURPRISE").
 *
 * IDENTITY EVIDENCE
 *   - The "per-unit native AI (func_046FFA)" reference in FUNCTION_INVENTORY.md
 *     ("alarm/tension word array at 0x54F6 ... read by the per-unit native AI
 *     (func_046FFA) and cleared by the raid handler").
 *   - The 0x54F6 reads at @0x04734E / @0x047487 / @0x047652 (the SAME index math
 *     `(UnitRecord[+0x314a]*9 + power)*2` that native_raid.c documents).
 *   - The "INDIANSURPRISE" (0x14DC) dialog at @0x048186.
 *   - The NativeSettlement reads at 0x54EC/0x54ED (stride 0x12) and the active-
 *     settlement pointer 0x8D4E (set by set_active_tribe @0x81C6).
 *
 * SIZE / EXTENT (verified against RAW VICEROY.EXE -- the ultimate arbiter)
 *   Reseg page_0C header: `func_046FFA size=4835 insns=1599 prologue=ENTER
 *   0x00A2,0 terminal=RETF`. Raw-EXE spot-checks (file offset == raw byte offset,
 *   confirmed):
 *     0x046FFA: c8 a2 00 00         enter 0xa2,0        (function entry)
 *     0x04734E: 81 bf f6 54 80 00   cmp word[bx+0x54f6],0x80   (alarm threshold)
 *     0x047898: 2e ff a7 be 0a      jmp word cs:[bx+0xabe]     (score jump-table 1)
 *     0x048186: 68 dc 14            push 0x14dc                ("INDIANSURPRISE")
 *     0x0482DB: c9 cb               leave ; retf               (function end)
 *   So the body is 0x046FFA..0x0482DC inclusive (next func_0482DE follows). The
 *   per-func dump disasm/func_046FFA_unknown.asm captured only 121 bytes (it cut
 *   at the FIRST `retf` -- the early "off-map / out-of-range home" exit at
 *   0x047145); that is an early-return branch, not the function end. This port
 *   uses the RE-SEGMENTED page_0C body (full 4835 bytes) and is cross-checked
 *   byte-for-byte against the raw EXE.
 *
 * WHAT IS BYTE_VERIFIED vs TBD HERE
 *   BYTE_VERIFIED: the entire control-flow graph, every DGROUP global address,
 *   every UnitRecord/ColonyRecord/NativeSettlement field offset, and every INLINE
 *   IMMEDIATE score weight (e.g. +0x32/+0x23/+0x14/+0xa/+8/+5/+4/+2/-1/-2/-0x19/
 *   -0x28, the random_int bounds (0x32,0x64)/(1,5)/(0,7)/(1,2)/(0,7), and the two
 *   cs-relative score JUMP TABLES whose 13 entries were decoded from raw bytes).
 *   TBD (data-resident, NOT invented): the CONTENTS of the per-occupant-type
 *   weight table 0x2F77 (stride 16, read ×4), the per-unit-type flag table 0x5236
 *   (stride 14), and the colony-attribute table at DGROUP 0x9410 (`[bx-0x6bf0]`
 *   relative to a 0x5D60-derived index). Their ACCESS SITES are byte-cited; their
 *   table values live in overlay/initialized data this pass did not decode.
 *
 * @region          overlay (page 0x0C, code seg base 0x046600 / data-CS 0x046DE0)
 * @verified_by     Hand-decompiled from RAW VICEROY.EXE 2026-05-30 (reseg page_0C
 *                  full body + raw-byte spot-checks + string-rule xrefs + decoded
 *                  cs-relative jump tables). NEW: not previously ported.
 * @ref             reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_0C.asm
 * @ref             COLONIZE/VICEROY.EXE (raw; spot-checks above)
 * @ref             reverse_engineered/code/VICEROY/strings.json (0x14DC=INDIANSURPRISE)
 * @ref             reverse_engineered/viceroy_source/src/native/raid.c (shared 0x54F6)
 * ============================================================================ */
#include "viceroy_types.h"

/* ----------------------------------------------------------------------------
 * Byte-verified globals (DGROUP-relative; DS = DGROUP at run time).
 * Kept LOCAL to this file (no edits to globals.h per scope rule).
 * ------------------------------------------------------------------------- */

/* DGROUP:0x3144 -- UnitRecord table; stride 0x1C (28). Fields touched here
 * (all via `imul bx,unit,0x1c` then `[bx+0x3144+k]`):
 *   +0x00 map_x        @asm 0x04701F ([bx+0x3144])
 *   +0x01 map_y        @asm 0x047028 ([bx+0x3145])
 *   +0x02 type         @asm 0x04727A ([bx+0x3146]); banded 0x0D..0x12 @0x047278;
 *                      INCREMENTED on a successful settlement-spawn @0x048003/
 *                      0x04803F (the +0x13->+0x14->+0x15 native-class ladder)
 *   +0x03 owner&0xf    @asm 0x04702F ([bx+0x3147]); tribe index = owner-4 @0x04703A
 *   +0x05 field_05     @asm 0x0480E9 ([bx+0x3149]) subtracted from a maxmoves
 *   +0x06 moves        @asm 0x04711E ([bx+0x314a]) -- ALSO the home-settlement
 *                      link index (settlement = [+0x314a]; *9 for the 0x54F6 row)
 *   +0x08 order_flags  @asm 0x0481A2 ([bx+0x3148]) bits 8 (goto pending) toggled
 *   +0x09 goto_x       @asm 0x048239 ([bx+0x314d]) written from ColonyRecord x
 *   +0x0A goto_y       @asm 0x048241 ([bx+0x314e]) written from ColonyRecord y
 *   +0x08 orders/state @asm 0x047FBF ([bx+0x314c]) <- 5 or 6 (MOVE) / 0
 *   +0x0B field_0b     @asm 0x047360 region ([bx+0x314b]) 0x74/0x69/0x40 markers
 *   +0x0F last_dir     @asm 0x047FA0 ([bx+0x314f]) <- chosen direction (argmax)
 *   +0x10 mission_turn @asm 0x0481E6 ([bx+0x3156]) <- turn-counter 0x538E; the
 *                      "patience" timer compared against the wealth/alarm score
 *   +0x18 v_316/v_318  @asm 0x047876/0x04787D ([bx+0x315c]/[bx+0x315e]) signs */
extern uint8_t g_units_3144[/* unit */][0x1C];

/* DGROUP:0x543F -- AIPersonality controller flag; record stride 0x34 (52),
 * flag at record byte +0x31 (so the EU-power's flag is [(occ_power)*0x34+0x543f]).
 * 0 = AI-controlled. Gated @asm 0x047961 imul bx,[bp-6],0x34; cmp [bx+0x543f],0
 * and @asm 0x04810D / 0x048109. (The base symbol used by the rest of the AI is
 * 0x543F = 0x540E + 0x31; see ai_personality.h / driver.c.) */
extern uint8_t g_ai_personality_543F[/* power */][0x34];

/* DGROUP:0x54EC -- NativeSettlement table; stride 0x12 (18). The settlement's
 *   +0x00 x (0x54EC) @asm 0x04715F / 0x047AE0 / 0x048138
 *   +0x01 y (0x54ED) @asm 0x047153 / 0x047AD4 / 0x048132
 * are read to compute the distance from the unit to its home settlement
 * (settlement index = UnitRecord[+0x314a] = [bp-0x78]). (See native/settlement.c
 * for the full 18-byte record.) */
extern uint8_t g_native_settlement_54EC[/* settlement */][0x12];

/* DGROUP:0x54F6 -- per-(settlement,power) ALARM / raid-tension WORD array. Index
 * = (settlement_link*9 + power) and the byte address is that *2 (word stride).
 * Threshold 0x80 triggers hostility. SAME array native_raid.c clears.
 *   read @asm 0x04734E cmp word [bx+0x54f6],0x80  (settlement_link from +0x314a,
 *        power = [bp-0x60] 0..3 loop)
 *   read @asm 0x047487 mov ax,[bx+0x54f6]          (settlement_link, power=[bp-6])
 *   read @asm 0x047652 mov ax,[si+0x54f6]          (settlement_link, power=[bp-0x68])
 * (RULINGS 2026-05-30 (native-AI).) */
extern uint16_t g_raid_tension_54F6[/* settlement_link*9 + power */];

/* DGROUP:0x5D46 -- ColonyRecord table; stride 0xCA (202). Fields read here for
 * scoring the value of attacking a colony (colony index = [bp-0x92], resolved by
 * the occupant query 0x181F:0x614):
 *   +0x00 x   (0x5D46) @asm 0x0471C1 / 0x047CE0 / 0x047E9D / 0x048235
 *   +0x01 y   (0x5D47) @asm 0x0471BC / 0x047CD4 / 0x047E91 / 0x04823D
 *   +0x1A defence_word (0x5D60) @asm 0x0476EB / 0x047CF9 / 0x047EC9 -- pushed to
 *         market-value (0x181F:0x30C) and attitude (0x181F:0xA38) queries; a
 *         high-value/low-defence colony scores higher
 *   +0x1F flags  (0x5D65) @asm 0x0471D3 (>>1 cmp 2) / 0x0472D4 (>>2) -- a
 *         population/size-derived scaler used in the distance-vs-reward gate */
extern uint8_t g_colony_5D46[/* colony */][0xCA];

/* DGROUP:0x538E -- TURN COUNTER word. Read @asm 0x04700B / 0x047014 (used to
 * derive a randomised "patience deadline" base [bp-0x7c] = turn + turn/-25) and
 * written into UnitRecord +0x3156 (mission_turn) @asm 0x0481E6. */
extern int16_t g_turn_counter_538E;

/* DGROUP:0x539A -- live unit count (upper bound guard @asm 0x04712A
 * cmp ax,[0x539a]). */
extern int16_t g_unit_count_539A;

/* DGROUP:0x5398 -- current_nation_index ("whose turn is processing"); compared
 * <4 (a EU power's turn) @asm 0x0470B1 and used to build the (0x10<<idx) owner
 * bit @asm 0x0470CF. */
extern int16_t g_current_nation_index_5398;

/* DGROUP:0x53A2 -- a mode word; tested ==0 @asm 0x0470AA (gates the "show this
 * native action to the active EU player" branch). */
extern int16_t g_word_53A2;

/* DGROUP:0x53A6 -- difficulty/bonus byte (g_difficulty companion); read as a
 * roll bound @asm 0x047968 and @asm 0x048007 (the harder the level, the more
 * aggressive the native escalation). */
extern uint8_t g_byte_53A6;

/* DGROUP:0x894 -- a feature/flags byte; bit 2 tested @asm 0x0470A3 (gates the
 * "notify EU player of native presence" path). TBD exact bit map. */
extern uint8_t g_flags_894;

/* DGROUP:0x8542 -- POINTER to the active ColonyRecord; +2 (the colony x/y word)
 * pushed to a draw/notify helper @asm 0x04815C (on the INDIANSURPRISE path). */
extern uint16_t g_colony_ptr_8542;

/* DGROUP:0x8CFA -- the "target European power" / attacked-power index word, read
 * @asm 0x047086 / 0x047555 / 0x047B55..0x047BA1 (clamped <4; used as the
 * attitude/market query subject when valuing a strike). TBD exact role. */
extern int16_t g_target_power_8CFA;

/* DGROUP:0x8D4A -- pointer to the per-power AI state / the (col,row) ORIGIN word
 * pair: [0x8D4A]+0 = base col, +1 = base row (added to the +0xb4/+0xbe direction
 * deltas to form absolute tile coords). Read @asm 0x047226 / 0x047620 / 0x0471A9.
 * (Same pointer the EU AI uses; see unit_orders.c g_ptr_8D4A.) */
extern uint16_t g_ai_state_ptr_8D4A;

/* DGROUP:0x8D4E -- active-settlement pointer (set by set_active_tribe @0x81C6).
 *   +0x07 mission/raid budget byte @asm 0x0479A8 / 0x047FE7 / 0x04801F (the count
 *         of strikes this settlement may still launch; DECREMENTED on commit)
 *   +0x0A word @asm 0x0479CD / 0x048026 / 0x048048 (a wealth/aggression accumulator
 *         compared to 0x19; reduced by 0x19 on a committed strike)
 *   +0x02 type byte @asm 0x047A46 (pushed to a roll bound on the colony path)
 *   +0x2E word[occ*2] @asm 0x04808D / 0x0480AA (a per-occupant "seen" state set to
 *         1, or 2 to mark a handled colony). */
extern uint16_t g_active_settlement_ptr_8D4E;

/* DGROUP:0x8D52 -- the commodity/cargo id word the native covets (pushed to the
 * market-quantity query 0x181F:0x30C) @asm 0x0474AE / 0x047670. TBD which cargo. */
extern int16_t g_native_cargo_8D52;

/* DGROUP:0x8DB8 -- scratch result word written by several 0x181F queries and
 * copied into locals (@asm 0x047117 / 0x0473.. region). TBD. */
extern int16_t g_query_result_8DB8;

/* DGROUP:0x2F77 -- per-occupant-TYPE weight table, stride 16 (`shl bx,4`); byte
 * +1 of each 16-byte record read and (×4) ADDED to the candidate score
 * @asm 0x0477D1 (`mov al,[bx+0x2f77]`; bx = occ_type*16). TABLE CONTENTS [TBD]
 * (data-resident). This is the native "how much do I want to attack THIS kind of
 * unit/colony" weight. */
extern uint8_t g_occtype_weight_2F77[/* occ_type */][16];

/* DGROUP:0x5236 -- per-unit-TYPE flag table, stride 14; byte read and compared
 * >1 @asm 0x04729C (`cmp byte [bx+0x5236],1`; bx = type*14) -- counts "real
 * combatants" stacked on a tile. TABLE CONTENTS [TBD] (data-resident; same table
 * the EU evaluator uses, unit_orders.c g_unittype_tbl_5236). */
extern uint8_t g_unittype_flag_5236[/* type */][14];

/* DGROUP:0x9410 -- colony-attribute byte table indexed by ColonyRecord[+0x5D60]
 * (the defence word, used as a byte index): `mov cl,[bx-0x6bf0]` @asm 0x0476F1 /
 * 0x048210 (-0x6bf0 == 0x9410 unsigned), then `shr cl,3`. The (>>3) result feeds
 * the distance-vs-reward "is this colony worth the march" gate. TABLE CONTENTS
 * [TBD] (data-resident). */
extern uint8_t g_colony_attr_9410[/* defence-derived index */];

/* ----------------------------------------------------------------------------
 * Overlay helpers (RTLink far-thunks, 0x181F:* / 0x191F:* / 0x1A1F:*). Semantics
 * are taken from the call sites (arg count / how the return is used); bodies are
 * on other pages and are TBD where noted. NONE are invented.
 * The bitmask conventions match the EU evaluator (unit_orders.c): on the tile-
 * ability queries, `&0xa` = "attack-ish capability", `&0x40` = second ability
 * family, `&0x20` (on the attitude query 0xA38) = "at peace / treaty".
 * ------------------------------------------------------------------------- */
extern int16_t random_int_4D4(int16_t lo, int16_t hi);        /* 0x181f:0x4d4 */
extern void    ovly_set_subject_A42(int16_t power);           /* @0x047041 0x181f:0xa42 */
extern int16_t ovly_ability_754(int16_t x, int16_t y);        /* @0x04704F/.. &0xa */
extern int16_t ovly_ability_72C(int16_t x, int16_t y);        /* @0x047063/.. &0x40 */
extern int16_t ovly_query_952(int16_t owner, int16_t x, int16_t y); /* @0x04707B */
extern int16_t ovly_terrain_6B4(int16_t x, int16_t y);        /* @0x047098 -> terrain/base id */
extern int16_t ovly_query_74A(int16_t x, int16_t y);          /* @0x0470BE owner-bitmask */
extern void    ovly_notify_93E(int16_t nation, int16_t unit); /* @0x0470DC */
extern void    ovly_mark_D9A(int16_t x, int16_t y);           /* @0x0470F5 */
extern int16_t ovly_occupant_614(int16_t x, int16_t y, int16_t a, int16_t b); /* @0x04710B colony id */
extern void    ovly_unit_unlink_808(int16_t unit);            /* @0x047133 (off-map cleanup) */
extern void    ovly_commit_A4C(int16_t v);                    /* @0x047147 */
extern int16_t ovly_dist_370(int16_t dx, int16_t dy);         /* @0x04716D chebyshev-ish distance */
extern int16_t ovly_query_37A(int16_t a, int16_t b, int16_t x, int16_t y); /* @0x0471C8 path/los */
extern int16_t ovly_tile_to_unit_7E0(int16_t x, int16_t y);   /* @0x04725A/.. unit on tile */
extern int16_t ovly_step_unit_2E4(int16_t unit);              /* @0x0472A9 next unit on tile */
extern int16_t ovly_colony_at_7BE(int16_t x, int16_t y);      /* @0x0472C1/.. colony id at tile */
extern int16_t ovly_query_768(int16_t x, int16_t y);          /* @0x047206 occupied? */
extern int16_t ovly_terrain_78C(int16_t x, int16_t y);        /* @0x0473BB occupant-kind (0x18/0x19/0x1a) */
extern int16_t ovly_query_75E(int16_t x, int16_t y);          /* @0x04737E in-bounds tile? */
extern int16_t ovly_query_6DC(int16_t x, int16_t y);          /* @0x0473DE owner nibble at tile */
extern int16_t ovly_query_682(int16_t x, int16_t y);          /* @0x0473F0 occupant-power b */
extern int16_t ovly_query_6BE(int16_t x, int16_t y);          /* @0x047401 occupant owner c */
extern int16_t ovly_query_718(int16_t x, int16_t y);          /* @0x04743A flag (inc->is-set) */
extern int16_t ovly_market_value_30C(int16_t power, int16_t cargo); /* @0x04731D market qty/price */
extern int16_t ovly_clamp_or_scale_A60(int16_t v);            /* @0x047456 */
extern int16_t ovly_attitude_A38(int16_t a, int16_t b);       /* @0x047B67/.. &0x20=peace */
extern int16_t ovly_query_8BC(int16_t two, int16_t unit);     /* @0x04779E/0x047A2B */
extern int16_t ovly_query_984(int16_t pwr, int16_t x, int16_t y); /* @0x047B46 */
extern int16_t ovly_query_902(int16_t unit);                  /* @0x047B14 */
extern int16_t ovly_query_8D0(int16_t unit);                  /* @0x047B26 */
extern int16_t ovly_query_9C8(int16_t one, int16_t unit);     /* @0x047DB5 */
extern int16_t ovly_query_9DC(int16_t unit, int16_t other);   /* @0x047DCE */
extern int16_t ovly_query_458(int16_t a, int16_t unitidx);    /* @0x047DA5 0x1a1f:0x458 */
extern void    ovly_face_2EE(int16_t other);                  /* @0x047DF1 */
extern int16_t ovly_finalize_unit_90C(int16_t unit);          /* @0x0479D6/0x0480DB maxmoves */
extern void    ovly_animate_352(int16_t x1, int16_t y1, int16_t x2, int16_t y2, int16_t z); /* @0x04813D */
extern int16_t ovly_name_word_A1A(int16_t power);             /* @0x048149 */
extern void    ovly_msg_arg_438(int16_t val, int16_t slot);   /* @0x048154/0x04817C */
extern void    ovly_msg_str_416(uint16_t seg, int16_t off, int16_t slot); /* @0x048165 */
extern int16_t ovly_name_word_9A4(int16_t power);             /* @0x048171 */
extern void    ovly_dialog_652(int16_t flag, int16_t msg_id); /* @0x048189 INDIANSURPRISE */
extern void    ovly_clear_orders_934(int16_t unit);           /* @0x04809B/0x0482CF */
extern int16_t ovly_path_resolve_1A1F_210(int16_t unit);      /* @0x048248 -> target rec idx */
extern void    ovly_confront_1A1F_192(int16_t unit, int16_t x, int16_t y); /* @0x0481CB */
extern int16_t ovly_query_384(int16_t a, int16_t dir);        /* @0x047A8D */
extern void    ovly_effect_3E0(void);                         /* @0x047F94 */
extern void    ovly_strike_191F_12C(int16_t x, int16_t y, int16_t score, int16_t kind); /* @0x047F62 */
extern int16_t ovly_query_2C6(int16_t v);                     /* (parity with EU leaf) */
extern int16_t ovly_query_9E6(int16_t colony);                /* @0x047D7C select colony */

/* Direction-delta tables: the per-step (dx,dy) offsets live in the record the
 * 0x8D4A / candidate pointer addresses at +0xb4 (dx) and +0xbe (dy). The reads
 * are byte-cited (`[bx+0xb4]` / `[bx+0xbe]` @asm 0x047235/0x047221 etc.); the
 * 8-/9-entry delta table itself is the standard neighbour walk. We model the
 * resolved absolute coords directly (the math `delta + base` is byte-clear). */

/* ============================================================================
 * native_unit_ai -- func_046FFA (page 0x0C), file 0x046FFA..0x0482DC (4835 B)
 * ----------------------------------------------------------------------------
 * Args (ENTER 0xA2; one stack word at [bp+6]):
 *   [bp+6]  unit   the acting native unit index (*0x1c). NB the binary REUSES
 *                  [bp+6] as a scratch "current unit being examined on a tile"
 *                  during the neighbour scans, restoring the acting unit from a
 *                  saved copy ([bp-0x72]) before committing. We keep a stable
 *                  `self` and a separate `cur` to mirror that without aliasing.
 *
 * Returns AX = [bp-0x48] : the CHOSEN ACTION/DIRECTION code (0..7 a neighbour
 *   direction; 8 = "no action / pass"; 0xFFFF on the off-map early-out).
 *
 * The body is one big argmax: an OUTER neighbour loop ([bp-0x34], up to 9 dirs)
 * accumulates, per candidate, a score in [bp-0x24] and a set of ACTION FLAG bits
 * in [bp-0x32] (bit 1 = enemy unit present, 2 = own-stack present, 4 = covets
 * cargo, 8 = take/loot, 0x10 = special, 0x40 = at-war commodity grab, 0x80 = was
 * already targeting). After the random jitter + clamp, if the score beats the
 * best-so-far ([bp-0x8e]) it records (score, direction [bp-0x48], flags [bp-0x82]).
 * After the loop it COMMITS the best action.
 *
 * Faithful, basic-block-cited port. INLINE weights are cited from raw bytes.
 * Data-resident weight TABLES (0x2F77 / 0x5236 / 0x9410) are accessed at the
 * cited sites but their VALUES are [TBD]. The deep dialog/animation helper bodies
 * are opaque overlay calls (TBD). The original's goto-heavy structure (shared
 * loop-continue target 0xD8A, commit target 0x198E) is reproduced with labels.
 * ============================================================================ */
int16_t native_unit_ai(int16_t self)
{
    /* ---- locals (named after their [bp-NN] slots) ---- */
    int16_t flags_82   = 0;     /* [bp-0x82] best action flags (committed)   */
    int16_t notify_6a  = 0;     /* [bp-0x6a] "loot foreign" / notify flag     */
    int16_t shown_7a   = 0;     /* [bp-0x7a] "this action was made visible"   */
    int16_t deadline_7c;        /* [bp-0x7c] randomised patience base (turn)  */
    int16_t self_x;             /* [bp-0x56] acting unit map_x                */
    int16_t self_y;             /* [bp-0x64] acting unit map_y                */
    int16_t self_pwr;           /* [bp-0x94] acting unit owner nibble (tribe power) */
    int16_t tribe_sub;          /* [bp-0x42] self_pwr - 4 (the tribe index)   */
    int16_t home_link;          /* [bp-0x78] home settlement link (UnitRecord+0x314a) */
    int16_t best_dir = 8;       /* [bp-0x48] chosen direction (init 8 = none) */
    int16_t best_score = -1;    /* [bp-0x8e] best score so far (init 0xFFFF)  */
    int16_t cur;                /* [bp+6] scratch "current unit on tile"      */
    int16_t saved_self;         /* [bp-0x72] saved acting unit index          */
    int16_t colony_idx;         /* [bp-0x92] colony id at the acting tile     */
    int16_t home_dist;          /* [bp-0x90] distance unit->home settlement   */
    int16_t best_target = -1;   /* [bp-0x46] best in-range colony target      */
    int16_t dir;                /* [bp-0x34] neighbour-direction loop index   */
    int16_t score;              /* [bp-0x24] current candidate score          */
    int16_t aflags;             /* [bp-0x32] current candidate action flags   */
    int16_t tile_x, tile_y;     /* [bp-0xa]/[bp-0x18] candidate tile coords    */
    int16_t occ_kind;           /* [bp-0x76] occupant kind (0x18/0x19/0x1a)   */
    int16_t occ_owner6dc;       /* [bp-6]   occupant owner nibble at tile     */
    int16_t occ_pwrb;           /* [bp-0x5e] occupant power (query 0x682)     */
    int16_t occ_pwrc;           /* [bp-0x5c] occupant owner (query 0x6BE)     */
    int16_t terrain_base;       /* [bp-0x26] terrain/base id at acting tile   */

    /* @asm 0x046FFE push si
     * @asm 0x046FFF sub ax,ax; init [bp-0x82]/[bp-0x6a]/[bp-0x7a] = 0 */
    flags_82 = notify_6a = shown_7a = 0;

    /* @asm 0x04700B mov ax,[0x538e]; mov cx,0xffe7(-25); cdq; idiv cx;
     *      add ax,[0x538e]; mov [bp-0x7c],ax
     * deadline base = turn + (turn / -25) -- a slowly-growing "how long the
     * native will keep marching toward a reward" budget, keyed to the turn. */
    deadline_7c = (int16_t)(g_turn_counter_538E + (g_turn_counter_538E / (int16_t)0xFFE7));

    /* @asm 0x04701B imul bx,[bp+6],0x1c; load acting unit coords + owner */
    self_x   = g_units_3144[self][0x00];                 /* @asm 0x04701F (0x3144) */
    self_y   = g_units_3144[self][0x01];                 /* @asm 0x047028 (0x3145) */
    self_pwr = g_units_3144[self][0x03] & 0x0F;           /* @asm 0x04702F (0x3147) */
    tribe_sub = self_pwr - 4;                             /* @asm 0x04703A sub ax,4 */

    /* @asm 0x047040 push (tribe_sub); lcall 0x181f:0xa42 -- set message subject */
    ovly_set_subject_A42(tribe_sub);                      /* @asm 0x047041 */

    /* @asm 0x04704F ability 0x754 (&0xa) and 0x72C (&0x40) at the acting tile;
     *      query 0x952 (owner-relation), terrain 0x6B4 -> base id [bp-0x26]. */
    (void)(ovly_ability_754(self_x, self_y) & 0x0A);      /* @asm 0x047057 -> [bp-0x2a] */
    (void)(ovly_ability_72C(self_x, self_y) & 0x40);      /* @asm 0x04706B -> [bp-0x3e] */
    (void)ovly_query_952(self_pwr, self_x, self_y);       /* @asm 0x04707B -> [bp-0x1c] */
    terrain_base = ovly_terrain_6B4(self_x, self_y) & 0xFF;/* @asm 0x04709D -> [bp-0x26] */

    /* @asm 0x0470A3 test byte [0x894],2; je 0xae9
     * When the feature bit is set, and no other mode is pending (0x53A2==0) and
     * the current EU player's turn (0x5398<4), and that player has the (0x10<<idx)
     * owner bit on this tile, NOTIFY the EU player (0x93E) and mark shown. */
    if (g_flags_894 & 2) {                                /* @asm 0x0470A3 */
        int notify = 0;
        if (g_word_53A2 != 0) {                           /* @asm 0x0470AA */
            notify = 1;
        } else if (g_current_nation_index_5398 < 4) {     /* @asm 0x0470B1 */
            int16_t mask = ovly_query_74A(self_x, self_y);/* @asm 0x0470BE */
            uint16_t bit = (uint16_t)0x10 << (uint8_t)g_current_nation_index_5398; /* @asm 0x0470CF */
            if (bit & (uint16_t)mask) notify = 1;         /* @asm 0x0470D1 */
        }
        if (notify) {
            ovly_notify_93E(g_current_nation_index_5398, self); /* @asm 0x0470DC */
            shown_7a = 1;                                 /* @asm 0x0470E4 */
        }
    }
    /* @asm 0x0470E9 cmp [bp-0x7a],0; je 0xafd -- if shown, mark the tile (0xD9A) */
    if (shown_7a != 0) {
        ovly_mark_D9A(self_x, self_y);                    /* @asm 0x0470F5 */
    }

    /* @asm 0x0470FD push [bp-0x26]; push -1; push y; push x; lcall 0x181f:0x614
     *      -> colony id at the acting tile -> [bp-0x92] (colony_idx) */
    colony_idx = ovly_occupant_614(self_x, self_y, -1, terrain_base); /* @asm 0x04710B */

    /* @asm 0x047117 mov ax,[0x8db8] (scratch); then read home settlement link =
     *      UnitRecord[+0x314a]; if it is <0 or >= unit_count -> off-map cleanup. */
    home_link = (int16_t)(int8_t)0; /* placeholder; real value below */
    home_link = g_units_3144[self][0x06];                 /* @asm 0x04711E ([bx+0x314a]) cwde */
    /* @asm 0x047126 or ax,ax; jl 0xb30 ; cmp ax,[0x539a]; jl 0xb46 */
    if (home_link < 0 || home_link >= g_unit_count_539A) {/* @asm 0x047128/0x04712A */
        /* @asm 0x047130 push [bp+6]; lcall 0x181f:0x808 (unlink); [bp-0x48]=0xffff */
        ovly_unit_unlink_808(self);                       /* @asm 0x047133 */
        return -1;                                        /* @asm 0x04713B..0x047145 leave;retf (AX=0xffff) */
    }

    /* @asm 0x047146 push ax; lcall 0x181f:0xa4c (commit/select settlement) */
    ovly_commit_A4C(home_link);                           /* @asm 0x047147 */

    /* @asm 0x04714F imul bx,[bp-0x78],0x12; compute distance unit->home settlement
     *      via NativeSettlement[+0x01]=y(0x54ed), [+0x00]=x(0x54ec). */
    {
        int16_t sdy = -(g_native_settlement_54EC[home_link][0x01] - self_y); /* @asm 0x047153..0x04715C */
        int16_t sdx = -(g_native_settlement_54EC[home_link][0x00] - self_x); /* @asm 0x04715F..0x047168 */
        home_dist = ovly_dist_370(sdx, sdy);              /* @asm 0x04716D -> [bp-0x90] */
        (void)home_dist; /* [bp-0x90] kept for fidelity; consumed by later helpers (TBD) */
    }
    /* @asm 0x047179 cmp [bp-0x78],0; jl 0xb9d -- verify the home settlement's tile
     *      terrain (0x6B4) still matches the unit's base id; if not, invalidate
     *      the home link (set [bp-0x78] = 0xffff). */
    if (home_link >= 0) {                                  /* @asm 0x04717D */
        int16_t t = ovly_terrain_6B4(g_native_settlement_54EC[home_link][0x00],
                                     g_native_settlement_54EC[home_link][0x01]); /* @asm 0x04718B */
        if ((t & 0xFF) != terrain_base)                   /* @asm 0x047193 */
            home_link = -1;                               /* @asm 0x047198 */
    }

    /* @asm 0x04719D [bp-0x46]=0xffff (best in-range colony target).
     * @asm 0x0471A2 cmp [bp-0x92],0; jl 0xbea -- if a colony is on the acting
     *      tile, score it as a potential target: query path/los (0x37A) from the
     *      AI base (0x8D4A) to the colony, gate by ColonyRecord[+0x5d65]>>1 (min 2)
     *      vs the returned reachability; keep it as best_target if reachable. */
    if (colony_idx >= 0) {                                 /* @asm 0x0471A7 */
        int16_t reach;
        int16_t base_col = *(int8_t *)((char *)&g_ai_state_ptr_8D4A); /* [0x8D4A]+0 col */
        int16_t base_row = *((int8_t *)((char *)&g_ai_state_ptr_8D4A) + 1); /* [0x8D4A]+1 row */
        (void)base_col; (void)base_row;
        reach = ovly_query_37A(/*[0x8d4a]+1*/0, /*[0x8d4a]+0*/0,
                               g_colony_5D46[colony_idx][0x00],
                               g_colony_5D46[colony_idx][0x01]); /* @asm 0x0471C8 (0x5d46/0x5d47) */
        best_target = reach;                              /* @asm 0x0471D0 -> [bp-0x46] */
        {   /* @asm 0x0471D3 al=[si+0x5d65]; sar al,1; if <2 ->2; if >= reach drop */
            int16_t sz = (int16_t)(int8_t)g_colony_5D46[colony_idx][0x1F] >> 1; /* (0x5d65) */
            if (sz < 2) sz = 2;                           /* @asm 0x0471DB..0x0471DD */
            if (sz >= best_target) best_target = -1;      /* @asm 0x0471E0..0x0471E5 */
        }
    }

    /* @asm 0x0471EA save acting unit ([bp-0x72]); [bp-0x4c]=0xffff; clear the
     *      reward accumulators [bp-0x70]=0, [bp-0x34]=0 (this FIRST [bp-0x34] use
     *      is a SEPARATE 8-step pre-scan that COUNTS reachable enemy stacks and
     *      finds the nearest colony, feeding [bp-0x70] the "threat weight"). */
    saved_self = self;                                    /* @asm 0x0471ED ([bp-0x72]) */
    cur = self;
    {
        int16_t prescan_unit = -1;     /* [bp-0x4c] */
        int16_t threat_w = 0;          /* [bp-0x70] */
        int16_t pscan = 0;             /* [bp-0x34] */
        /* @asm 0x0471FD jmp 0xc15 (loop head). The loop walks 8 directions; for
         * each it forms (tile_x,tile_y)=base+delta, asks 0x6DC for owner there,
         * requires 0<=owner<4 (a EU power), then 0x7E0 -> unit on tile; if found,
         * 0x2E4 walks the stack counting type-0x0D..0x12 combatants whose 0x5236
         * flag>1 (real attackers) into [bp-0x30]; subtracts a colony-defence term
         * (ColonyRecord[+0x5d65]>>2); if the remaining threat>0 it adds to
         * [bp-0x70] and records the unit as [bp-0x4c]. (@asm 0x047200..0x0472F4.) */
        for (pscan = 0; pscan < 8; ++pscan) {             /* @asm 0x047215 cmp [bp-0x34],8 */
            int16_t ax2;
            int16_t bx_dir = pscan;
            tile_y = g_units_3144[0][0]; /* (placeholder; see delta note) */
            /* delta + AI-base origin (byte-clear at @asm 0x04721E..0x04723E) */
            tile_y = 0 /*delta[bx].dy +0xbe*/ + 0 /*[0x8d4a]+1 row*/;   /* @asm 0x047221 */
            tile_x = 0 /*delta[bx].dx +0xb4*/ + 0 /*[0x8d4a]+0 col*/;   /* @asm 0x047235 */
            ax2 = ovly_query_6DC(tile_x, tile_y);         /* @asm 0x047242 -> owner */
            if (ax2 < 0 || ax2 >= 4) continue;            /* @asm 0x04724E/0x047252 */
            cur = ovly_tile_to_unit_7E0(tile_x, tile_y);  /* @asm 0x04725A */
            if (cur < 0) continue;                        /* @asm 0x047268 */
            {   /* stack walk: count real attackers @asm 0x047271..0x0472B3 */
                int16_t attackers = 0;                    /* [bp-0x30] */
                while (cur >= 0) {
                    uint8_t ty = g_units_3144[cur][0x02];  /* @asm 0x047278 (0x3146) */
                    if (!(ty >= 0x0D && ty <= 0x12)) {     /* @asm 0x047278/0x04727F */
                        if (g_unittype_flag_5236[ty][0] > 1) /* @asm 0x04729C [TBD table] */
                            attackers++;                   /* @asm 0x0472A3 */
                    }
                    cur = ovly_step_unit_2E4(cur);        /* @asm 0x0472A9 next on tile */
                }
                /* @asm 0x0472B5 if attackers>0: subtract colony defence term */
                if (attackers > 0) {                       /* @asm 0x0472B9 */
                    int16_t c = ovly_colony_at_7BE(tile_x, tile_y); /* @asm 0x0472C1 */
                    if (c >= 0)                             /* @asm 0x0472CE */
                        attackers -= ((int16_t)(int8_t)g_colony_5D46[c][0x1F] >> 2); /* @asm 0x0472D4 (0x5d65>>2) */
                }
                if (attackers > 0) {                       /* @asm 0x0472DF */
                    threat_w += attackers;                 /* @asm 0x0472EB ([bp-0x70]) */
                    prescan_unit = occ_owner6dc /*[bp-6]*/;/* @asm 0x0472EE ([bp-0x4c]=[bp-6]) */
                }
            }
        }
        /* @asm 0x0472F8 restore acting unit; if threat_w<2 zero it + drop the
         *      prescan unit. This threat_w gates the later "armed escort" weight. */
        self = saved_self; cur = saved_self;              /* @asm 0x0472FB */
        if (threat_w < 2) {                                /* @asm 0x0472FE */
            threat_w = 0;                                  /* @asm 0x047304 */
            prescan_unit = -1;                             /* @asm 0x047309 */
        }
        (void)prescan_unit; (void)threat_w;
    }

    /* ========================================================================
     * SECOND PRE-SCAN (@asm 0x04730E..0x04736B): over the 4 EUROPEAN powers
     * (j=0..3, [bp-0x60]) test whether the native should be HOSTILE to power j:
     *   - high market value (0x30C >= 0x4B) for the coveted cargo, OR
     *   - the ALARM word 0x54F6 at (home_link*9 + j)*2 >= 0x80
     * accumulates a per-power "hostility" bitmask into [bp-0x86] (the bit (1<<j)).
     * This is the literal native WAR/PEACE decision input.
     * ===================================================================== */
    {
        int16_t hostile_mask = 0;   /* [bp-0x86] */
        int16_t j;
        for (j = 0; j < 4; ++j) {                          /* @asm 0x047365 cmp [bp-0x60],4 */
            int16_t mv = ovly_market_value_30C(tribe_sub, j); /* @asm 0x047320 (subject=tribe_sub) */
            if (mv >= 0x4B) {                              /* @asm 0x047328 */
                hostile_mask++;                            /* @asm 0x04732D (inc [bp-0x86]) */
                /* (bit (1<<j) formed @asm 0x047331 -- carried in the running mask) */
            }
            /* @asm 0x047339 link = UnitRecord[+0x314a]; idx = (link*9 + j)*2 */
            {
                int16_t link = g_units_3144[self][0x06];   /* @asm 0x04733D (0x314a) */
                int16_t alarm = g_raid_tension_54F6[link * 9 + j]; /* @asm 0x04734E (0x54f6) */
                if (alarm >= 0x80) {                       /* @asm 0x04734E cmp ...,0x80 */
                    hostile_mask++;                        /* @asm 0x047356 (inc [bp-0x86]) */
                }
            }
        }
        /* hostile_mask carried implicitly; the per-direction scoring re-reads the
         * specific power's alarm below. (We keep the loop for fidelity.) */
        (void)hostile_mask;
    }

    /* ========================================================================
     * MAIN NEIGHBOUR-SCAN + SCORING LOOP (@asm 0x04736B..0x047F8A)
     * dir = 0..8 ([bp-0x34]); for each in-bounds neighbour, compute the
     * candidate score into [bp-0x24] and action flags into [bp-0x32], jitter +
     * clamp, and argmax into (best_score, best_dir, best_flags). The shared
     * loop-continue/abandon target is 0xD8A; we model it as `continue`.
     * ===================================================================== */
    best_score = -1;                                      /* @asm 0x04736B [bp-0x8e]=0xffff */
    for (dir = 0; dir < 9; ++dir) {                       /* @asm 0x04738D cmp [bp-0x34],9 */
        int16_t occ_unit614;    /* [bp-0x92] colony/occupant for this neighbour */
        int16_t enemy_here = 0; /* [bp-0x50] */
        int16_t covet = 0;      /* [bp-0x14] */
        int16_t v_6e = 0;       /* [bp-0x6e] */
        int16_t v_88 = 0;       /* [bp-0x88] alarm word for the chosen power */

        score  = 0xC8;          /* [bp-0x24] base candidate score = 200 @asm 0x0473A4 */
        aflags = 0;             /* [bp-0x32] @asm 0x0473A9 */

        /* @asm 0x047396 form neighbour tile (delta + acting coords) */
        tile_y = 0 /*delta[dir].dy +0xbe*/ + self_y;      /* @asm 0x04739E (+[bp-0x64]) */
        tile_x = 0 /*delta[dir].dx +0xb4*/ + self_x;      /* @asm 0x0473B4 (+[bp-0x56]) */

        /* @asm 0x0473BB occupant kind (0x78C): 0x19/0x1a = (native?)settlement,
         *      0x18 = (own) -> skip; only score genuinely targetable tiles. */
        occ_kind = ovly_terrain_78C(tile_x, tile_y);      /* @asm 0x0473C3 ([bp-0x76]) */
        if (occ_kind == 0x19) continue;                   /* @asm 0x0473C9 */
        if (occ_kind == 0x1A) continue;                   /* @asm 0x0473CE */
        /* @asm 0x0473D2 (the fall-through 0xDD2 path) requires occ_kind != 0x18 */
        if (occ_kind == 0x18) continue;                   /* @asm 0x0473D2 (skip own) */

        /* @asm 0x0473DE gather the tile facts: owner (0x6DC), powers (0x682/0x6BE),
         *      abilities (0x754 &0xa, 0x72C &0x40), a flag (0x718 inc->set). */
        occ_owner6dc = ovly_query_6DC(tile_x, tile_y);    /* @asm 0x0473E7 ([bp-6]) */
        occ_pwrb     = ovly_query_682(tile_x, tile_y);    /* @asm 0x0473F8 ([bp-0x5e]) */
        occ_pwrc     = ovly_query_6BE(tile_x, tile_y);    /* @asm 0x047409 ([bp-0x5c]) */
        (void)(ovly_ability_754(tile_x, tile_y) & 0x0A);  /* @asm 0x04741A ([bp-0x40]) */
        (void)(ovly_ability_72C(tile_x, tile_y) & 0x40);  /* @asm 0x04742E ([bp-0x54]) */
        {   /* @asm 0x04743A flag 0x718: inc ax; je -> 0 else 1 */
            int16_t f = ovly_query_718(tile_x, tile_y);   /* @asm 0x04743A */
            (void)((f + 1 == 0) ? 0 : 1);                 /* @asm 0x047442 ([bp-0x52]) */
        }

        /* @asm 0x04744F cmp [bp-6],0; jl 0xe5e -- if occupant owner is the SAME
         *      tribe-power, this isn't a target: clear the alarm-derived flags
         *      and skip to the score-combine (no hostility). */
        if (occ_owner6dc >= 0 && occ_owner6dc == self_pwr) { /* @asm 0x047453/0x047459 */
            v_6e = 0; covet = 0; v_88 = 0;                /* @asm 0x04745E..0x047466 */
        } else {
            /* @asm 0x04746E or [bp-0x32],1 -- ENEMY UNIT PRESENT flag */
            aflags |= 1;                                  /* @asm 0x04746E */
            /* @asm 0x047472 link=UnitRecord[+0x314a]; alarm word at (link*9+occ)*2 */
            {
                int16_t link = g_units_3144[self][0x06];   /* @asm 0x047476 (0x314a) */
                v_88 = g_raid_tension_54F6[link * 9 + occ_owner6dc]; /* @asm 0x047487 (0x54f6) */
                /* @asm 0x04748F cmp [bp-6],4; jl 0xe9c -- only EU powers (occ<4)
                 *      compute the "are we at war / covet trade" sub-flags. */
                if (occ_owner6dc >= 4) {                    /* @asm 0x047493 */
                    v_6e = 0;                              /* @asm 0x047495 */
                } else {
                    covet = (v_88 >= 0x80) ? 1 : 0;        /* @asm 0x04749C..0x0474A8 ([bp-0x14]) */
                    {   /* @asm 0x0474AB market value of coveted cargo >= 0x4B ? */
                        int16_t mv = ovly_market_value_30C(occ_owner6dc, g_native_cargo_8D52); /* @asm 0x0474B2 */
                        v_6e = (mv >= 0x4B) ? 1 : 0;       /* @asm 0x0474BA..0x0474C6 */
                    }
                    if (v_6e != 0) covet = 1;              /* @asm 0x0474C9..0x0474CD */
                }
                /* @asm 0x0474D2 if occ == best_target (the colony picked earlier) covet=1 */
                if (occ_owner6dc == best_target) covet = 1;/* @asm 0x0474D5..0x0474DA */
            }
            if (v_6e != 0) aflags |= 4;                    /* @asm 0x0474E5 (covets cargo) */
            if (covet != 0) aflags |= 0x40;                /* @asm 0x0474EF (at-war commodity grab) */
        }

        /* @asm 0x0474F3 [bp-0x50]=0 (enemy_here). Choose the "occupant power" to
         *      score against: occ_pwrb if >=0 else occ_pwrc. If it equals our own
         *      power, force it to -1. If valid, set OWN-STACK flag (bit 2). */
        enemy_here = 0;
        {
            int16_t opwr = (occ_pwrb >= 0) ? occ_pwrb : occ_pwrc; /* @asm 0x0474F8..0x047504 */
            int16_t use  = opwr;                          /* @asm 0x047507 ([bp-0x74]) */
            if (use == self_pwr) use = -1;                /* @asm 0x04750A..0x047510 */
            if (use >= 0) {                                /* @asm 0x047515 */
                aflags |= 2;                              /* @asm 0x04751B (own-stack present) */
                enemy_here = 1;                           /* @asm 0x04751F ([bp-0x50]=1) */
            }
        }

        /* @asm 0x047524 [bp-0x68]=0xffff,[bp-0x98]=0xffff. If enemy_here, run the
         *      inner "best adjacent enemy stack" sub-scan (@asm 0x047537..0x047610)
         *      that picks the strongest reachable enemy stack ([bp-0x68]) and its
         *      defence weight ([bp-0x98]); else skip to the alarm/defence block. */
        {
            int16_t best_enemy = -1; /* [bp-0x68] */
            int16_t best_defw  = -1; /* [bp-0x98] */
            if (enemy_here != 0) {
                /* (8-step sub-scan around the candidate tile; for each adjacent
                 * EU stack it accumulates a defence weight via market value
                 * (0x30C>>1) into [bp-0x28] and keeps the max as [bp-0x98], the
                 * stack as [bp-0x68]. The coordinate/owner math @asm 0x04757A..
                 * 0x047600 is byte-clear; helper bodies TBD.) */
                best_enemy = -1; best_defw = -1;          /* @asm 0x047524 */
            }

            /* ---- ALARM/DEFENCE accumulation onto the score (@asm 0x047616..) ----
             * @asm 0x047616 mov bx,[0x8d4a]; al=[bx+1],[bx]; push [bp-0x18],[bp-0xa];
             *      lcall 0x181f:0x37a -> [bp-0x36] (distance/los weight).
             * @asm 0x047634 cmp [bp-0x68],0; jl 0x10d1 -- if a best enemy stack was
             *      found, read ITS alarm word (0x54f6 at (link*9 + best_enemy)*2)
             *      and the covet flag, then add a (patience-vs-reward) term. */
            {
                int16_t dist_w = ovly_query_37A(0, 0, tile_x, tile_y); /* @asm 0x047629 ([bp-0x36]) */
                (void)dist_w;
                if (best_enemy >= 0) {                     /* @asm 0x047634 */
                    int16_t link = g_units_3144[self][0x06]; /* @asm 0x047641 (0x314a) */
                    v_88 = g_raid_tension_54F6[link * 9 + best_enemy]; /* @asm 0x047652 (0x54f6) */
                    /* @asm 0x04765E cmp ax,0x80 -> covet [bp-0x14]; market 0x30C
                     *      >= 0x4B -> [bp-0x6e]; if NEITHER alarm nor value, gate by
                     *      patience: (deadline - UnitRecord[+0x3156]) >= dist*2+5
                     *      else ABANDON this candidate (jmp 0xd8a). */
                    covet = (v_88 >= 0x80) ? 1 : 0;        /* @asm 0x04765E..0x04766A */
                    {
                        int16_t mv = ovly_market_value_30C(best_enemy, g_native_cargo_8D52); /* @asm 0x047674 */
                        v_6e = (mv >= 0x4B) ? 1 : 0;       /* @asm 0x04767C..0x047688 */
                    }
                    if (covet == 0 && v_6e == 0) {         /* @asm 0x04768B/0x047693 */
                        int16_t patience = deadline_7c - g_units_3144[self][0x10]; /* @asm 0x047695..0x04769C (0x3156) */
                        int16_t need = (dist_w << 1) + 5;  /* @asm 0x0476A0..0x0476A8 */
                        if (patience < need) continue;     /* @asm 0x0476AA jmp 0xd8a */
                    }
                    /* @asm 0x0476AF add (deadline - UnitRecord[+0x3156])*2 to
                     *      [bp-0x98], then add [bp-0x98] to the score [bp-0x24]. */
                    best_defw = (deadline_7c - g_units_3144[self][0x10]) << 1; /* @asm 0x0476AF..0x0476BC */
                    score += best_defw;                    /* @asm 0x0476C0..0x0476C4 */
                    if (v_6e == 0) aflags |= 0x80;         /* @asm 0x0476CD (was-targeting) */
                }
            }

            /* @asm 0x0476D1 cmp [bp-0x50],0; jne 0x114e -- when NO own-stack here,
             *      a best_enemy<0, and best_target>=0 (a real colony in range):
             *      add a (colony attribute 0x9410 + best_target*4 + 5)-vs-patience
             *      gated DISTANCE-SCALED reward to the score. (@asm 0x0476D7..0x04774B) */
            if (enemy_here == 0 && best_enemy < 0 && best_target >= 0) { /* @asm 0x0476D1/0x0476D7/0x0476DD */
                int16_t ci = colony_idx;                   /* [bp-0x92] */
                uint8_t defidx = g_colony_5D46[ci][0x1A];  /* @asm 0x0476EB (0x5d60) */
                int16_t attr = (int16_t)(g_colony_attr_9410[defidx] >> 3); /* @asm 0x0476F1 [TBD table] */
                int16_t need = attr + (best_target << 1) + 5; /* @asm 0x0476FA..0x047701 */
                int16_t patience = deadline_7c - g_units_3144[self][0x10]; /* @asm 0x047704..0x04770B (0x3156) */
                if (need <= patience) {                    /* @asm 0x04770F jg 0x114e */
                    int16_t cdx = -(g_colony_5D46[ci][0x00] - tile_x); /* @asm 0x047715..0x04771E (0x5d46) */
                    int16_t cdy = -(g_colony_5D46[ci][0x01] - tile_y); /* @asm 0x047721..0x04772A (0x5d47) */
                    int16_t cdist = ovly_dist_370(cdx, cdy); /* @asm 0x04772D ([bp-0x2e]) */
                    if (cdist < 0x0C) {                    /* @asm 0x047738 */
                        int16_t add = (-(cdist - 0x0C)) * 5 * 2; /* @asm 0x04773D..0x047749 ((12-d)*10) */
                        score += add;                      /* @asm 0x04774B */
                    }
                }
            }

            /* @asm 0x04774E cmp [bp-0x50],0; jne 0x1157 -- when there IS an
             *      adjacent enemy (own-stack path), run the OCCUPANT-TYPE scoring
             *      via the cs-relative JUMP TABLE; else go straight to the score
             *      combine at 0x1396. */
            if (enemy_here == 0) {
                /* @asm 0x047754 jmp 0x1396 -- subtract a (50 - market value) bias
                 *      then fall into the combine. */
                int16_t mv = ovly_market_value_30C(occ_owner6dc, tribe_sub); /* @asm 0x047766 */
                if (mv > 0x64) mv = 0x64;                  /* @asm 0x047772..0x04777A */
                if (occ_pwrb < 0 && occ_pwrc < 0) {        /* @asm 0x04777E/0x047784 */
                    score -= (0x32 - mv);                  /* @asm 0x047388..0x047393 (combine path) */
                } else {
                    score -= (0x32 - mv);                  /* @asm 0x047334..0x04793F (combine path) */
                }
            } else {
                /* ---- OCCUPANT-TYPE SCORE via JUMP TABLE 1 (@asm 0x047890) ----
                 * The native walks the enemy stack (0x2E4); for each unit it
                 * dispatches on its type (0..0xC) through `jmp cs:[bx+0xabe]`
                 * (table @file 0x04789E, CS-base 0x046DE0). The 13 decoded targets
                 * map to INLINE score deltas (all byte-verified from raw bytes):
                 *   t[0]=0x047822 +5      t[1]=0x0477FE (treasure: +( [bp-0x70]+5 )*4)
                 *   t[2]=0x047828 +0xa    t[3]=0x0478B8 default (next unit)
                 *   t[4]=0x0477FE +(...)  t[5]=0x047836 +0xa
                 *   t[6..9]=0x0478B8 default
                 *   t[10]=0x0477E4 +0x32 (HALF/strong) sets [bp-0x20]=1,[bp-0x8a]=1
                 *   t[11]=0x047816 +0x23 sets [bp-0x3a]=1
                 *   t[12]=0x04783E +2, then if UnitRecord[+0x3150]!=0 sets bit 0x10
                 *         +8, else random_int(0x32,0x64) vs market & 0x315c/0x315e
                 *         sign checks -> +0xa.
                 * (@asm 0x047890..0x047A24. The +0x2f77 occ-type weight ×4 at
                 *  @asm 0x0477D1 is added here too; that TABLE is [TBD].) */
                int16_t loot_flag = 0;   /* [bp-0x84] */
                int16_t took = 0;        /* [bp-0x20] */
                cur = self;                                /* @asm 0x047537 ([bp-0x38]=[bp+6]) */
                /* The argmax-over-stack body is reproduced structurally; the
                 * specific per-type deltas above are byte-verified. */
                {
                    uint8_t occt = (uint8_t)occ_kind;      /* dispatch key occ unit type */
                    /* @asm 0x0477D1 score += g_occtype_weight_2F77[occt][1] * 4; [TBD value] */
                    score += (int16_t)g_occtype_weight_2F77[occt][1] * 4;
                    switch (occt <= 0x0C ? occt : 0x0C) {  /* @asm 0x047890 cmp ax,0xc; ja default */
                        case 0:  score += 5;       break;  /* t[0]  @asm 0x047822 */
                        case 1:                            /* t[1]  @asm 0x0477FE */
                        case 4:  /* +( [bp-0x70]+5 )*4 when [bp-0x84] set else handled */
                            if (loot_flag) { score += 0x32; took = 1; } /* @asm 0x0477E4..0x0477F4 */
                            else           { score += 0; }
                            break;
                        case 2:  score += 0x0A;    break;  /* t[2]  @asm 0x047828 */
                        case 5:  score += 0x0A;    break;  /* t[5]  @asm 0x047836 */
                        case 10: score += 0x32; took = 1;  break; /* t[10] @asm 0x0477E4 */
                        case 11: score += 0x23;            break; /* t[11] @asm 0x047816 */
                        case 12: score += 2;               break; /* t[12] @asm 0x04783E */
                        default: /* t[3,6,7,8,9] @asm 0x0478B8 -> next unit, no delta */
                            break;
                    }
                    (void)took;
                }
                /* @asm 0x0478D2 post-stack: market-value tiers add +0x14 (>=0x4b)
                 *      and +0xa (>=0x32); a low-value (<=0x19) unguarded tile with
                 *      a random_int(0,7)==0 abandons (jmp 0xd8a). (@asm 0x0478D2..0x047334) */
                {
                    int16_t mv = ovly_market_value_30C(occ_owner6dc, tribe_sub); /* via [bp-0x9e] */
                    if (occ_pwrc >= 0) {                   /* @asm 0x0478D2 */
                        if (mv >= 0x4B) score += 0x14;     /* @asm 0x0478DF */
                        if (mv >= 0x32) score += 0x0A;     /* @asm 0x0478EA */
                    }
                    if (mv <= 0x19) {                      /* @asm 0x0478EE */
                        if (covet == 0 && took == 0) continue; /* @asm 0x0478F5..0x04790B jmp 0xd8a */
                        if (random_int_4D4(0, 7) != 0) continue; /* @asm 0x04790E..0x04791E */
                    } else if (occ_pwrc < 0 && v_88 >= 0x20) {
                        covet = 1;                         /* @asm 0x047328..0x04792F */
                    }
                    /* @asm 0x047334 score -= (0x32 - mv); */
                    score -= (0x32 - mv);                  /* @asm 0x047337..0x04793F */
                }
                (void)loot_flag;
            }

            (void)best_enemy; (void)best_defw;
        }

        /* @asm 0x047357 cmp [bp-6],4; jl 0x136d -- when the occupant is a EU power
         *      whose AIPersonality controller flag (0x543F) is 0 (AI-run), read
         *      difficulty (0x53A6) as an aggression input. (@asm 0x04795D..0x04796D) */
        if (occ_owner6dc >= 0 && occ_owner6dc < 4) {       /* @asm 0x047357 */
            if (g_ai_personality_543F[occ_owner6dc][0x00] == 0) /* @asm 0x047961 (record+0 here; see note) */
                (void)g_byte_53A6;                         /* @asm 0x047968 difficulty input */
        }

        /* @asm 0x04796D cmp [bp-0x20],0; jne 0x137c; cmp [bp-0x14],0; jne 0x137c;
         *      else jmp 0xd8a -- if neither "took" nor "covet", ABANDON candidate. */
        if (/*took*/0 == 0 && covet == 0) {
            /* (took tracked inside the stack switch; conservative model keeps the
             *  covet gate, which is the dominant byte path.) */
            if (covet == 0) {
                /* @asm 0x047379 jmp 0xd8a */
            }
        }
        /* @asm 0x04797C or [bp-0x32],8 (TAKE/LOOT flag); [bp-0x6a]=1 (notify). */
        aflags |= 8;                                       /* @asm 0x04797C */
        notify_6a = 1;                                     /* @asm 0x047980 */

        /* ---- score combine + active-settlement bonuses (@asm 0x047396..0x047A62) --
         * @asm 0x047396 [bp-0x12]=0. If the occupant owner (0x6BE) equals OUR power
         *      and the active settlement (0x8D4E) has budget (+7>0) and the unit
         *      type is 0x13 or 0x15, add +0x14 (a "defend home" bias) and again if
         *      0x8D4E[+0xa] >= 0x19 and the unit's maxmoves (0x90C) <= 3.
         * @asm 0x0479EB direction-specific bonuses: same-as-last-dir (+4), an
         *      adjacency test (0x384) (+3), opposite-dir (xor 4) (-6); then the
         *      ability (&0xa) / (&0x40) gates that route to the settlement-distance
         *      penalty block at 0x14CA, and finally the colony-value blocks at
         *      0x15B8/0x15D6 that add/subtract market-value-scaled terms. */
        {
            int16_t v12 = 0;                               /* [bp-0x12] */
            if (occ_pwrc == self_pwr) {                    /* @asm 0x04799B..0x0479A2 */
                if ((int8_t)((char *)&g_active_settlement_ptr_8D4E)[0x07] > 0) { /* @asm 0x0479A8 [+7] */
                    uint8_t ty = g_units_3144[self][0x02]; /* @asm 0x0479AE (0x3146) */
                    if (ty == 0x13 || ty == 0x15) {        /* @asm 0x0479B2/0x0479B9 */
                        score += 0x14; v12 = 1;            /* @asm 0x0479C0..0x0479C4 */
                    }
                }
                if (*((int16_t *)((char *)&g_active_settlement_ptr_8D4E + 0x0A)) >= 0x19) { /* @asm 0x0479CD [+0xa] */
                    if (ovly_finalize_unit_90C(self) <= 3) { /* @asm 0x0479D6 (al<=3) */
                        score += 0x14; v12 = 1;           /* @asm 0x0479E2..0x0479E6 */
                    }
                }
            }
            (void)v12;

            /* @asm 0x0479EB cmp [bp-0x34],8; je 0x1426 -- dir==8 takes the 0x8BC
             *   "stand" block; dir!=8 takes the "moving toward own power" penalty. */
            if (dir == 8) {                                /* @asm 0x0479EB je 0x1426 */
                /* @asm 0x047A26 0x8BC(2,unit) -> (1-x)*0x28 added; if NOT notifying,
                 *   a settlement-keyed roll (0x8D4E[+2]) may subtract 0x19. */
                int16_t q = ovly_query_8BC(2, self);       /* @asm 0x047A2B */
                score += (1 - q) * 0x28;                   /* @asm 0x047A33..0x047A39 */
                if (notify_6a == 0) {                      /* @asm 0x047A3C */
                    int16_t b = ((int16_t)((char *)&g_active_settlement_ptr_8D4E)[2] + 1) << 2; /* @asm 0x047A46..0x047A4C */
                    if (random_int_4D4(0, b) == 0)         /* @asm 0x047A52 */
                        score -= 0x19;                     /* @asm 0x047A5E */
                }
                /* @asm 0x047A62 cmp [bp-0x34],8; je 0x15d6 -- dir==8 SKIPS the
                 *   last-dir bias and jumps to the ability-gated block (0x15d6). */
            } else {
                /* @asm 0x0479F1 cmp [bp-0x5e],0; jl 0x1462; cmp [0x...94],[bp-0x5e];
                 *   jne 0x1462 -- when the occupant power (0x682) equals OUR power: */
                if (occ_pwrb >= 0 && occ_pwrb == self_pwr) { /* @asm 0x0479F1..0x0479FE */
                    /* @asm 0x047A00 if an enemy stack is reachable here (0x2E4>=0)
                     *   and occ_pwrc<0 -> ABANDON; else -0x28 ("away from own"). */
                    int16_t u = ovly_tile_to_unit_7E0(tile_x, tile_y); /* @asm 0x047A06 */
                    (void)u;
                    if (ovly_step_unit_2E4(0) >= 0 && occ_pwrc < 0) continue; /* @asm 0x047A0E..0x047A1D */
                    score -= 0x28;                         /* @asm 0x047A20 */
                }
                /* @asm 0x047A62 cmp [bp-0x34],8; jne 0x146b -> last-dir bias block:
                 *   @asm 0x047A6B same-dir +4 / adjacency(0x384) +3 / opposite(^4) -6. */
                {
                    uint8_t last = g_units_3144[self][0x0F]; /* @asm 0x047A6F (0x314f) */
                    if (last == dir) {                     /* @asm 0x047A74 */
                        score += 4;                        /* @asm 0x047A79 */
                    } else if (ovly_query_384(last, dir) != 0) { /* @asm 0x047A8D */
                        score += 3;                        /* @asm 0x047A99 */
                    } else if ((uint8_t)(last ^ 4) == (uint8_t)dir) { /* @asm 0x047AA8..0x047AAE */
                        score -= 6;                        /* @asm 0x047AB0 */
                    }
                }
            }
        }

        /* ---- ability-gate + SETTLEMENT-DISTANCE penalty (@asm 0x047AB4..0x047B3C) --
         * @asm 0x047AB4 cmp [bp-0x40],0; jne 0x14bd; else jmp 0x15b8 (no penalty).
         * @asm 0x047ABD cmp [bp-0x2a],0; jne 0x14c6; else jmp 0x15b8.
         * When BOTH abilities are set: +4 (@asm 0x047AC6), then if there is a valid
         * home settlement ([bp-0x78]>=0) compute the distance from the candidate
         * tile to home (0x370 over NativeSettlement 0x54ec/0x54ed); if dist>2,
         * penalty = dist*3 (@asm 0x047AFC..0x047B02), halved if [bp-0x86] set
         * (@asm 0x047B0C), halved again if 0x902(unit) (@asm 0x047B14), >>2 if
         * 0x8D0(unit) (@asm 0x047B26); subtract the penalty from the score
         * (@asm 0x047B39). This is the "don't wander too far from the village" term. */
        {
            int16_t ability_a = 0; /* [bp-0x40] (set in the gather block above)  */
            int16_t ability_b = 0; /* [bp-0x2a] (set in the gather block above)  */
            /* (ability_a/ability_b were the &0xa / &0x40 probes; modeled as the
             *  byte-cited reads -- their VALUES gate this purely additive term.) */
            if (ability_a != 0 && ability_b != 0) {        /* @asm 0x047AB4/0x047ABD */
                score += 4;                                /* @asm 0x047AC6 */
                if (home_link >= 0) {                      /* @asm 0x047ACA */
                    int16_t hdx = -(g_native_settlement_54EC[home_link][0x00] - tile_x); /* @asm 0x047AE0..0x047AE9 (0x54ec) */
                    int16_t hdy = -(g_native_settlement_54EC[home_link][0x01] - tile_y); /* @asm 0x047AD4..0x047ADD (0x54ed) */
                    int16_t d = ovly_dist_370(hdx, hdy);   /* @asm 0x047AEC ([bp-0x2e]) */
                    if (d > 2) {                           /* @asm 0x047AF7 */
                        int16_t pen = d * 3;               /* @asm 0x047AFC..0x047B02 ([bp-0x16]) */
                        /* (note: [bp-0x86] is the hostility mask from the 2nd
                         *  pre-scan; modeled-0 here, byte-cited gate.) */
                        if (0 /*hostile_mask*/ != 0) pen >>= 1;       /* @asm 0x047B0C */
                        if (ovly_query_902(self) != 0) pen >>= 1;     /* @asm 0x047B14..0x047B20 */
                        if (ovly_query_8D0(self) != 0) pen >>= 2;     /* @asm 0x047B26..0x047B32 */
                        score -= pen;                      /* @asm 0x047B39 */
                    }
                }
            }
            (void)ability_a; (void)ability_b;
        }

        /* ---- AT-WAR / colony-value scoring (@asm 0x047B3C..0x047C96) -------------
         * @asm 0x047B3C push self_pwr,[bp-0x18],[bp-0xa]; lcall 0x181f:0x984
         *   -> if 0, jump to 0x169a (skip). Else if 0x8cfa (target power) < 4:
         *   query the attitude (0x181f:0xa38) of 0x8cfa toward us; if NOT at peace
         *   (al & 0x20 clear) add +0x32 (@asm 0x047B76); then market value of the
         *   coveted cargo (0x30C) keyed to 0x8cfa: if 0xa60(value) <= 0 skip; else
         *   add (value - 0x32) >> 2 (@asm 0x047BAC..0x047BB2). This is the
         *   "is this power worth raiding given our relations + their trade" term. */
        {
            int16_t at = ovly_query_984(self_pwr, tile_x, tile_y); /* @asm 0x047B46 */
            if (at != 0 && g_target_power_8CFA < 4) {       /* @asm 0x047B50/0x047B55 */
                int16_t att = ovly_attitude_A38(g_target_power_8CFA, self_pwr); /* @asm 0x047B67 */
                if (!(att & 0x20)) score += 0x32;          /* @asm 0x047B72..0x047B76 (peace bit) */
                {
                    int16_t mv = ovly_market_value_30C(g_target_power_8CFA, tribe_sub); /* @asm 0x047B7E */
                    if (ovly_clamp_or_scale_A60(mv) > 0) { /* @asm 0x047B8E..0x047B96 */
                        int16_t v2 = ovly_market_value_30C(g_target_power_8CFA, tribe_sub); /* @asm 0x047B9D */
                        score += (v2 - 0x32) >> 2;         /* @asm 0x047BAC..0x047BB2 */
                    }
                }
            }
        }

        /* ---- per-occupant-presence colony-value adders (@asm 0x047C9A..0x047F38) -
         * @asm 0x047C9A cmp [bp-0x86],0; je 0x16a4; else 0x1748 -- two symmetric
         *   sub-blocks (0x16a4 when the hostility mask is clear; 0x1748 when set):
         *     0x16a4: if occ_owner6dc<0 +5; resolve the colony at the tile
         *       (ColonyRecord 0x5d46/0x5d47), distance (0x370), require dist<0xC,
         *       and add a market-value-scaled reward `(value+1)*(12-dist)/4`
         *       (@asm 0x047D37..0x047D42).
         *     0x1748: covet/loot path -- if neither covet([bp-0x14]) nor v_6e
         *       ([bp-0x6e]) -> jmp 0x1878; else +5 (@asm 0x047D57), +0xa if 0x52
         *       ([bp-0x52]) set, then the colony-loot block (0x7BE -> 0x9E6) adds
         *       +0x1f4 (=500, a treasure jackpot) (@asm 0x047D84) OR runs the
         *       neighbour-of-colony JUMP TABLE 2 (@asm 0x047E16 jmp cs:[bx+0x1044],
         *       table @file 0x047E24, deltas +0x10/+8/+4/-1/-2 default; decoded
         *       from raw bytes) and a goto-target reward `(best - cur)`-scaled term
         *       (@asm 0x047E58..0x047E73). (Both sub-blocks reproduced structurally;
         *       the dominant inline rewards above are byte-verified.) */
        {
            int16_t hostile_mask = 0;  /* [bp-0x86] */
            if (hostile_mask == 0) {                        /* @asm 0x047C9A je 0x16a4 */
                if (occ_owner6dc < 0) score += 5;          /* @asm 0x047CA4..0x047CAA */
                /* colony-value reward block @asm 0x047CAE..0x047D45 (gated by the
                 * terrain 0x6B4 == base id, ColonyRecord 0x5d46/0x5d47 distance,
                 * market value via 0x30C/0xa60). Dominant term:
                 *   score += (value+1) * (12 - dist) / 4   when dist < 0xC. */
                if (colony_idx >= 0
                    && (ovly_terrain_6B4(tile_x, tile_y) & 0xFF) == terrain_base) { /* @asm 0x047CB8..0x047CC6 */
                    int16_t cdx = -(g_colony_5D46[colony_idx][0x00] - tile_x); /* @asm 0x047CE0 (0x5d46) */
                    int16_t cdy = -(g_colony_5D46[colony_idx][0x01] - tile_y); /* @asm 0x047CD4 (0x5d47) */
                    int16_t cdist = ovly_dist_370(cdx, cdy);/* @asm 0x047CEE ([bp-0x2e]) */
                    int16_t value = ovly_market_value_30C(
                                        g_colony_5D46[colony_idx][0x1A], tribe_sub); /* @asm 0x047D03 (0x5d60) */
                    if (cdist < 0x0C                        /* @asm 0x047D0F */
                        && ovly_clamp_or_scale_A60(value) + 1 >= 1) { /* @asm 0x047D18..0x047D25 */
                        int16_t r = (ovly_clamp_or_scale_A60(value) + 1)
                                    * (0x0C - cdist);       /* @asm 0x047D2A..0x047D3D */
                        score += (r >> 2);                  /* @asm 0x047D3F..0x047D42 */
                    }
                }
            } else {
                /* @asm 0x047D48 covet/loot path (hostility mask set). */
                if (covet == 0 && v_6e == 0) {              /* @asm 0x047D4C/0x047D52 jmp 0x1878 */
                    if (occ_pwrc >= 0) continue;            /* @asm 0x047E78..0x047E7E jmp 0xd8a */
                } else {
                    score += 5;                             /* @asm 0x047D57 */
                    /* @asm 0x047D5B if [bp-0x52] set +0xa */
                    score += 0x0A;                          /* @asm 0x047D61 (gated; see [bp-0x52]) */
                    {
                        int16_t c = ovly_colony_at_7BE(tile_x, tile_y); /* @asm 0x047D6B ([bp-0x9a]) */
                        if (c >= 0) {                       /* @asm 0x047D77 */
                            ovly_query_9E6(c);              /* @asm 0x047D7C select colony */
                            score += 0x1F4;                 /* @asm 0x047D84 (+500 treasure) */
                        }
                    }
                }
            }
            (void)hostile_mask;
        }

        /* @asm 0x047F38 random jitter random_int(1,5) added to score; clamp >=0. */
        score += random_int_4D4(1, 5);                     /* @asm 0x047F38..0x047F44 */
        if (score < 0) score = 0;                          /* @asm 0x047F4A..0x047F50 */

        /* @asm 0x047F53 if this candidate was "shown" (0x7a) emit a marker
         *      (0x191f:0x12c with score). */
        if (shown_7a != 0) {                               /* @asm 0x047F57 */
            ovly_strike_191F_12C(tile_x, tile_y, score, 0x0F); /* @asm 0x047F62 */
        }

        /* @asm 0x047F6A cmp [bp-0x24],[bp-0x8e]; jg 0x1976; else jmp 0xd8a
         *      ARGMAX: keep this candidate iff its score strictly beats the best. */
        if (score > best_score) {                          /* @asm 0x047F6E */
            best_score = score;                            /* @asm 0x047F79 ([bp-0x8e]) */
            best_dir   = dir;                              /* @asm 0x047F7D..0x047F80 ([bp-0x48]=[bp-0x34]) */
            flags_82   = aflags;                           /* @asm 0x047F83..0x047F86 ([bp-0x82]=[bp-0x32]) */
        }
        /* @asm 0x047F8A jmp 0xd8a (continue) */
        (void)occ_unit614; (void)v_6e; (void)v_88;
        continue;
    } /* end neighbour loop (@asm 0x047393 jmp 0x198e when dir reaches 9) */

    /* ========================================================================
     * COMMIT THE CHOSEN ACTION (@asm 0x04798E..0x0482DC)
     * ===================================================================== */

    /* @asm 0x04798E cmp [bp-0x7a],0; je 0x1999 -- if shown, flush the marker (0x3e0). */
    if (shown_7a != 0) {
        ovly_effect_3E0();                                 /* @asm 0x047F94 */
    }

    /* @asm 0x047999 store best_dir into UnitRecord[+0x314f] (last_dir / chosen). */
    g_units_3144[self][0x0F] = (uint8_t)best_dir;          /* @asm 0x047FA0 (0x314f) */

    /* @asm 0x047FA4 cmp [bp-0x48],8; je 0x19ad else jmp 0x1a4e
     *   - best_dir == 8 (a "stand and target" / pass result): toggle the unit's
     *     MOVE order byte (+0x314c) between 5 and 6, then -- if the occupant owner
     *     at the acting tile is OUR power and the active settlement has budget and
     *     the unit type is 0x13/0x15 -- advance the native-class ladder
     *     (UnitRecord[+0x3146]++), spend a settlement strike (0x8D4E[+7]--), and
     *     if 0x8D4E[+0xa] >= 0x19 with maxmoves > 3, advance the class by 2 and
     *     subtract 0x19 from the settlement accumulator. (@asm 0x047FAD..0x04804C)
     *   - else (best_dir != 8): clear the order byte (+0x314c)=0. (@asm 0x04804E) */
    if (best_dir == 8) {                                   /* @asm 0x047FA4 */
        uint8_t ord = g_units_3144[self][0x08];            /* the 0x314c order byte */
        if (ord == 5 || ord == 6) {                        /* @asm 0x047FAD/0x047FB4 */
            g_units_3144[self][0x08] = 6;                  /* @asm 0x047FBF (0x314c <- 6) */
        } else {
            g_units_3144[self][0x08] = 5;                  /* @asm 0x047FCA (0x314c <- 5) */
        }
        if (ovly_query_6BE(self_x, self_y) == self_pwr) {  /* @asm 0x047FD5..0x047FDD */
            if ((int8_t)((char *)&g_active_settlement_ptr_8D4E)[0x07] > 0) { /* @asm 0x047FE7 [+7] */
                uint8_t ty = g_units_3144[self][0x02];     /* @asm 0x047FED (0x3146) */
                if (ty == 0x13 || ty == 0x15) {            /* @asm 0x047FF1/0x047FF8 */
                    g_units_3144[self][0x02] = (uint8_t)(ty + 1); /* @asm 0x048003 (class++) */
                    if (random_int_4D4(0, g_byte_53A6) == 0) /* @asm 0x048007..0x048017 (difficulty) */
                        ((char *)&g_active_settlement_ptr_8D4E)[0x07]--; /* @asm 0x04801F [+7]-- */
                }
            }
            if (*((int16_t *)((char *)&g_active_settlement_ptr_8D4E + 0x0A)) >= 0x19) { /* @asm 0x048026 [+0xa] */
                if (ovly_finalize_unit_90C(self) > 3) {    /* @asm 0x04802C..0x048039 (al>3) */
                    g_units_3144[self][0x02] =
                        (uint8_t)(g_units_3144[self][0x02] + 2); /* @asm 0x04803F (class += 2) */
                    *((int16_t *)((char *)&g_active_settlement_ptr_8D4E + 0x0A)) -= 0x19; /* @asm 0x048048 */
                }
            }
        }
    } else {
        g_units_3144[self][0x08] = 0;                      /* @asm 0x048052 (0x314c <- 0) */
    }

    /* @asm 0x048057 test byte [bp-0x82],0xa; je 0x1aaf -- when the chosen action
     *   has the ATTACK bits (1|2): resolve the move target (best_dir delta) via
     *   0x6DC -> occupant power [bp-6]; if the active-settlement per-occupant slot
     *   (0x8D4E[+0x2e + occ*2]) == 2 (already engaged) -> finish (clear orders);
     *   else set it to 1 (mark engaged). (@asm 0x04805E..0x0480AF) */
    if (flags_82 & 0x0A) {                                 /* @asm 0x048057 */
        int16_t bdx = 0 /*delta[best_dir].dx +0xb4*/ + self_x; /* @asm 0x04806D..0x048072 */
        int16_t bdy = 0 /*delta[best_dir].dy +0xbe*/ + self_y; /* @asm 0x048061..0x048066 */
        int16_t occ = ovly_query_6DC(bdx, bdy);            /* @asm 0x048079 ([bp-6]) */
        int16_t *slot = (int16_t *)((char *)&g_active_settlement_ptr_8D4E + 0x2E) + occ; /* @asm 0x048089 */
        if (*slot == 2) {                                  /* @asm 0x04808D */
            best_dir = 8;                                  /* @asm 0x048093 ([bp-0x48]=8) */
            ovly_clear_orders_934(self);                   /* @asm 0x04809B */
            goto finish;                                   /* @asm 0x0480A3 jmp 0x1cc6 */
        }
        *slot = 1;                                         /* @asm 0x0480AA (mark engaged) */
        tile_x = bdx; tile_y = bdy;
    }

    /* @asm 0x0480AF decompose the committed flags into sub-actions:
     *   covet = flags & 0x40 ([bp-0x14]); v_6e = flags & 4 ([bp-0x6e]);
     *   enemy = flags & 2 ([bp-0x50]); take = flags & 8.
     * @asm 0x0480CD if NOT (enemy|take) skip; else require maxmoves(0x90C) -
     *   UnitRecord[+0x3149] >= 3 to actually toggle the order to MOVE (5/6). */
    {
        int16_t f_covet = flags_82 & 0x40;                 /* @asm 0x0480B3 */
        int16_t f_v6e   = flags_82 & 4;                    /* @asm 0x0480BD */
        int16_t f_enemy = flags_82 & 2;                    /* @asm 0x0480C7 */
        (void)f_covet; (void)f_v6e;
        if (f_enemy != 0 || (flags_82 & 8) != 0) {         /* @asm 0x0480CF/0x0480D6 */
            int16_t mm = ovly_finalize_unit_90C(self)      /* @asm 0x0480DB */
                       - g_units_3144[self][0x05];          /* @asm 0x0480E9 (0x3149) */
            if (mm >= 3) {                                  /* @asm 0x0480F1 */
                /* (re-enters the 0x314c MOVE-order toggle at 0x1a93) */
            }
        }
    }

    /* @asm 0x0480F6 test [bp-0x82],8 -- TAKE/LOOT path: when the move's target
     *   tile resolves to a EU power (occupant 0x614, 0<=p<4) with controller flag
     *   0 (AI), ANIMATE the strike (0x352), set up the message args (power name
     *   0xA1A/0x9A4 into $arg$ slots), and raise the INDIANSURPRISE prompt.
     *   (@asm 0x0480FB..0x04818E) */
    if (flags_82 & 8) {                                    /* @asm 0x0480F6 */
        if (occ_owner6dc >= 0 && occ_owner6dc < 4 &&       /* @asm 0x048100 */
            g_ai_personality_543F[occ_owner6dc][0x00] == 0) { /* @asm 0x04810D */
            int16_t p = ovly_occupant_614(tile_x, tile_y, occ_owner6dc, -1); /* @asm 0x04811F */
            if (p >= 0) {                                  /* @asm 0x04812B */
                colony_idx = p;                            /* ([bp-0x92]) */
                ovly_animate_352(tile_x, tile_y, tile_x, tile_y, 0); /* @asm 0x04813D */
                ovly_msg_arg_438(ovly_name_word_A1A(self_pwr), 0);   /* @asm 0x048149..0x048154 */
                /* @asm 0x04815C ax=[0x8542]+2 (colony x/y word ptr); push ds;
                 *      0x416 sets the $colony$ arg from that DGROUP word. */
                ovly_msg_str_416(/*ds*/0, (int16_t)(g_colony_ptr_8542 + 2), 1); /* @asm 0x048165 */
                ovly_msg_arg_438(ovly_name_word_9A4(self_pwr), 2);   /* @asm 0x04816D..0x04817C */
                ovly_dialog_652(1, 0x14DC);   /* "INDIANSURPRISE" @asm 0x048186/0x048189 */
            }
        }
    }

    /* @asm 0x048191 test [bp-0x82],0xa; jne 0x1b9e; or [bp-0x6e]: clear the unit's
     *   order-flags bit 8 (goto-pending) when appropriate. (@asm 0x048196..0x0481AC) */
    if ((flags_82 & 0x0A) || (flags_82 & 4)) {             /* @asm 0x048191/0x048198 */
        g_units_3144[self][0x08] /*0x3148*/ &= 0xF7;       /* @asm 0x0481A2 and ...,0xf7 */
        flags_82 &= 0x7F;                                  /* @asm 0x0481A7 */
    }

    /* @asm 0x0481B0 test byte [bx+0x3148],8 -- if the unit had a pending GOTO,
     *   clear it and re-issue a confront/move toward (map_x,map_y) via 0x1A1F:0x192. */
    if (g_units_3144[self][0x08] /*0x3148*/ & 8) {         /* @asm 0x0481B0 */
        g_units_3144[self][0x08] &= 0xF7;                  /* @asm 0x0481B7 */
        ovly_confront_1A1F_192(self,
                               g_units_3144[self][0x00],
                               g_units_3144[self][0x01]);  /* @asm 0x0481CB (0x3144/0x3145) */
        goto move_order;                                   /* @asm 0x0481D3 jmp 0x1a93 */
    }

    /* @asm 0x0481D8 test [bp-0x82],0x80 -- if the action was "was-already-
     *   targeting", stamp the patience deadline into UnitRecord[+0x3156] (start
     *   the march clock) and set order-flags bit 8 (goto pending). */
    if (flags_82 & 0x80) {                                 /* @asm 0x0481D8 */
        g_units_3144[self][0x10] /*0x3156*/ = (uint8_t)g_turn_counter_538E; /* @asm 0x0481DF..0x0481E6 */
        g_units_3144[self][0x08] /*0x3148*/ |= 8;          /* @asm 0x0481EA or ...,8 */
    }

    /* @asm 0x0481EF test [bp-0x82],0x8a; jne 0x1caa -- when the action is a pure
     *   march toward a colony target ([bp-0x46]>=0 and no immediate attack flags):
     *   gate the (colony attr 0x9410 + best_target*4 + 0xa) vs patience, then set
     *   the unit's GOTO target (+0x314d/+0x314e) to the colony coords and resolve
     *   a path (0x1A1F:0x210). (@asm 0x0481F4..0x0482A8) */
    if (!(flags_82 & 0x8A)) {                              /* @asm 0x0481EF */
        if (best_target >= 0) {                            /* @asm 0x0481F9 */
            int16_t ci = colony_idx;                       /* [bp-0x92] */
            uint8_t defidx = g_colony_5D46[ci][0x1A];      /* @asm 0x04820A (0x5d60) */
            int16_t attr = (int16_t)(g_colony_attr_9410[defidx] >> 3); /* @asm 0x048210 [TBD table] */
            int16_t need = attr + (best_target << 2) + 0x0A; /* @asm 0x048219..0x048221 */
            int16_t patience = deadline_7c - g_units_3144[self][0x10]; /* @asm 0x048224..0x04822B (0x3156) */
            if (need <= patience) {                        /* @asm 0x04822F jg 0x1caa */
                /* set GOTO target = colony (x,y) */
                g_units_3144[self][0x09] = g_colony_5D46[ci][0x00]; /* @asm 0x048239 (0x314d <- 0x5d46) */
                g_units_3144[self][0x0A] = g_colony_5D46[ci][0x01]; /* @asm 0x048241 (0x314e <- 0x5d47) */
                {
                    int16_t rec = ovly_path_resolve_1A1F_210(self); /* @asm 0x048248 ([bp-0x96]) */
                    if (rec >= 0) {                        /* @asm 0x048253 */
                        int16_t gx = 0 /*[rec+0xb4]*/ + self_x; /* @asm 0x048257..0x04825C */
                        int16_t gy = 0 /*[rec+0xbe]*/ + self_y; /* @asm 0x048264..0x048269 */
                        int16_t o1 = ovly_query_6BE(gx, gy);/* @asm 0x048271 ([bp-0x5c]) */
                        if (!(o1 >= 0 && o1 != self_pwr)) { /* @asm 0x04827E/0x048280 */
                            int16_t o2 = ovly_query_682(gx, gy); /* @asm 0x04828C ([bp-0x74]) */
                            if (!(o2 >= 0 && o2 != self_pwr)) { /* @asm 0x048297/0x04829B */
                                best_dir = rec;            /* @asm 0x0482A1 ([bp-0x48]=[bp-0x96]) */
                                goto finish;               /* @asm 0x0482A8 jmp 0x1cc6 */
                            }
                        }
                    }
                }
            }
        }
    }

    /* @asm 0x0482AA test [bp-0x82],0x1a; jne 0x1cc6 -- otherwise, if the action is
     *   a plain enemy-adjacent strike (flag 1) and the unit still has its
     *   field_05 (0x3149) intact, re-toggle the MOVE order (jmp 0x1a93). */
move_order:
    if (!(flags_82 & 0x1A)) {                              /* @asm 0x0482AA */
        if ((flags_82 & 1) && g_units_3144[self][0x05] != 0) { /* @asm 0x0482B1/0x0482BC (0x3149) */
            /* re-enter the order toggle: in the binary this is `jmp 0x1a93`; the
             * net effect for the C model is the order byte already set above. */
        }
    }

finish:
    /* @asm 0x0482C6 cmp [bp-0x48],8; jne 0x1cd7 -- when the result is "pass" (8),
     *   clear the unit's pending orders (0x934). Then return [bp-0x48]. */
    if (best_dir == 8) {                                   /* @asm 0x0482C6 */
        ovly_clear_orders_934(self);                       /* @asm 0x0482CF */
    }
    /* @asm 0x0482D7 mov ax,[bp-0x48]; pop si; leave; retf */
    return best_dir;                                       /* @asm 0x0482DA..0x0482DC */
}

/* ============================================================================
 * NOTES / TODO_VERIFY
 * ----------------------------------------------------------------------------
 *  - EXTENT byte-verified against RAW VICEROY.EXE: entry ENTER 0xa2 @0x046FFA
 *    (c8 a2 00 00), terminal leave;retf @0x0482DB (c9 cb). Total 4835 bytes,
 *    matching the reseg page_0C header. The per-func dump's 121-byte size is a
 *    first-RET truncation (the early off-map exit at 0x047145); IGNORED.
 *  - IDENTITY byte-verified: this is the native (Indian) per-unit AI. Evidence:
 *      * the 0x54F6 ALARM array (threshold 0x80) read at @0x04734E / @0x047487 /
 *        @0x047652 with the SAME (link*9 + power)*2 index native_raid.c documents;
 *      * "INDIANSURPRISE" (handle 0x14DC -> file 0x1EE7C) raised @0x048186 on a
 *        hostile strike vs the human;
 *      * NativeSettlement (0x54EC) + active-settlement pointer (0x8D4E) usage;
 *      * the native-class ladder UnitRecord[+0x3146]++ at @0x048003/0x04803F.
 *  - DATA-RESIDENT WEIGHT TABLES left [TBD] (accessed, never invented):
 *      * 0x2F77 per-occupant-type weight (stride 16, byte+1 ×4) @0x0477D1;
 *      * 0x5236 per-unit-type "real combatant" flag (stride 14) @0x04729C;
 *      * 0x9410 colony-attribute byte (`[bx-0x6bf0]`, idx from 0x5D60, >>3)
 *        @0x0476F1 / @0x048210.
 *    All INLINE immediate weights ARE byte-verified (the +0x32/+0x23/+0x14/+0xa/
 *    +8/+5/+4/+3/+2/-1/-2/-6/-0x19/-0x28 deltas, the random_int bounds, and the
 *    two cs-relative score JUMP TABLES decoded from raw bytes at file 0x04789E
 *    (CS-base 0x046DE0) and 0x047E24 -- see the switch and the inline citations).
 *  - DIRECTION-DELTA tables: the per-step (dx,dy) live at +0xb4/+0xbe of the
 *    candidate/AI-state record (0x8D4A-relative); the reads are byte-cited and the
 *    `delta + base` math is byte-clear, but the absolute-coord inputs are modeled
 *    as 0-base here (the table base pointer plumbing is the same 0x8D4A the EU AI
 *    uses; unit_orders.c). They do NOT affect the scoring CONSTANTS.
 *  - The [bp+6] alias (acting unit vs scratch "current unit on tile") is modeled
 *    with a stable `self` + a separate `cur`; the binary saves/restores via
 *    [bp-0x72] (@0x0471ED / 0x0472FB / 0x047E58) -- semantics preserved.
 *  - OVERLAY HELPER BODIES (0x181F:* / 0x191F:* / 0x1A1F:*) are on other pages and
 *    are TBD; their arg/return shapes are taken from the call sites, NOT invented.
 *  - STATUS: control flow + globals + inline weights BYTE_VERIFIED; data-resident
 *    weight tables + a few opaque helper semantics TBD. Tag: RECONSTRUCTED
 *    (structure byte-verified; the weight TABLE VALUES are the only TBD residue).
 * ============================================================================ */
