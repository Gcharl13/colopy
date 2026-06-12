/* ============================================================================
 *   >>> KING EVENTS per power: ship REFIT + KINGTAX notice — BYTE_VERIFIED <<<
 * ----------------------------------------------------------------------------
 * Per-power "process the king's interactions with power N this turn" routine.
 * Despite being flagged by the wave-5 UI agent as a screen, this is GAME LOGIC:
 * it walks the UnitRecord table, advances/finishes ship REFITs in Europe,
 * spawns the refitted/king-granted unit, and (if a tax event is pending) sets
 * the KINGTAX result flag.  Identified by STRING XREF (decisive): the two
 * message handles it pushes resolve through the load-image string table
 * (file = handle + 0x1D9A0 — base BYTE_VERIFIED, see king_tax_raise.c/intervention.c):
 *     handle 0xEEF -> file 0x1E88F = "REFIT"     (@asm 0x02F1D7 push 0xeef)
 *     handle 0xF01 -> file 0x1E8A1 = "KINGTAX"   (KINGTAX result flag @0x02F201)
 *
 * @asm_function  func_02F052   (file 0x02F052..0x02F3A0, 847 bytes, RETF)
 * @asm_disasm    disasm_overlay_reseg/page_03.asm  (page 0x03; IP = file - 0x02CB00).
 *                NOTE: the per-function dump disasm/func_02F052_unknown.asm is
 *                TRUNCATED at 0x02F0C5 (it reports 117 bytes); the real extent is
 *                847 bytes ending at the RETF @0x02F3A0 — confirmed from the
 *                re-segmented page AND the raw EXE (do not trust the dump's size).
 * @verified_by   Hand-decompiled 2026-05-30; control flow + every cited operand
 *                spot-checked byte-for-byte against COLONIZE/VICEROY.EXE:
 *                  0x02F052: C8 0A 00 00       enter 0xa,0
 *                  0x02F058: A1 94 53          mov ax,[0x5394]
 *                  0x02F060: 8A 87 48 08       mov al,[bx+0x848]
 *                  0x02F0CB: 80 BF 46 31 0D    cmp byte [bx+0x3146],0x0d
 *                  0x02F338: 6A 11             push 0x11           (unit type 17)
 *                  0x02F33A: 9A 5C 09 1F 18    lcall 0x181F:0x95C  (spawn unit)
 *                  0x02F201: C7 06 4C 01 01 00 mov word [0x14c],1  (KINGTAX flag)
 *                  0x02F3A0: CB                retf
 * @ref  src/king/king_tax_raise.c  (func_034AE0 — the tax raise DECISION/amount,
 *       whose own TODO pointed here: "find via KINGTAX PUSH at 0x02f392").
 * ============================================================================ */
#include "viceroy_types.h"

/* ----------------------------------------------------------------------------
 * DGROUP globals (addresses BYTE_VERIFIED from the operands).
 * Kept LOCAL to this .c (the src/ai|unit|native|king convention) — no shared
 * header edits.
 * ---------------------------------------------------------------------------- */
extern int16_t g_subject_power_5394;   /* DGROUP:0x5394 — the power being processed this
                                         *   call (read at entry; 49 distinct readers incl.
                                         *   0x0079A0 setup, 0x02F052). Used as owner key. */
extern int16_t g_unit_count_539C;       /* DGROUP:0x539C — number of UnitRecords (cross-
                                         *   confirmed in intervention.c) */
extern int16_t g_colony_count_539E;     /* DGROUP:0x539E — number of colonies */
extern int16_t g_found_flag_014C;       /* DGROUP:0x014C — "an event fired" result flag
                                         *   (set to 1 @0x02F201 when KINGTAX applies) */
extern int16_t g_found_value_014E;      /* DGROUP:0x014E — companion value (init 0xFFFF) */
extern uint8_t g_class_table_0848[];    /* DGROUP:0x0848 — per-power class/category byte
                                         *   table; [power] passed to 0x181F:0x590 (role inferred from call context) */
extern void *  g_king_record_84FC;      /* DGROUP:0x84FC — far ptr to king PowerRecord;
                                         *   +0x0E word and +0x32/+0x33 read below */

/* UnitRecord table @DGROUP:0x3144, stride 0x1C (BYTE_VERIFIED, project memory
 * "UnitRecord base is DGROUP:0x3144"). Field offset = addr - 0x3144. */
#define UNIT_BASE_3144   0x3144
#define UNIT_STRIDE      0x1C
#define U_TYPE_3146      0x3146   /* +0x02 type            (@asm 0x02F08F/0x02F0CB) */
#define U_OWNFLG_3147    0x3147   /* +0x03 owner|flags; owner = low nibble (@asm 0x02F0A6/AA) */
#define U_FLAGS_3148     0x3148   /* +0x04 flags; bit0x80 "in transit", bit0x40 set @0x02F37A */
#define U_XPOS_3144      0x3144   /* +0x00 map_x           (@asm 0x02F0EB/0x02F178) */
#define U_YPOS_3145      0x3145   /* +0x01 map_y           (@asm 0x02F0E4/0x02F171) */
#define U_REFIT_315A     0x315A   /* +0x16 turn_counter, reused here as REFIT progress
                                   *   (@asm 0x02F0E0 inc; 0x02F106 read; 0x02F376 store) */
#define U_ORDERS_314C    0x314C   /* +0x08 orders          (@asm 0x02F34C clear on grant) */
#define U_GOTOX_314D     0x314D   /* +0x09 goto x          (@asm 0x02F358 <- king[+0x32]) */
#define U_GOTOY_314E     0x314E   /* +0x0A goto y          (@asm 0x02F35F <- king[+0x33]) */

/* Per-type "build/refit time" table at DGROUP:0x5235, stride 7 bytes (the index
 * is type*7 via shl/add: @asm 0x02F11A..0x02F124).  [type*7 + 0x5235] is the
 * REFIT duration the 0x315A counter must reach.  @asm 0x02F126 mov al,[bx+0x5235].
 * The sibling word table at 0x5230 (same stride) holds a per-type handle/value
 * pushed to a UI helper (@asm 0x02F161). */
#define UNIT_REFIT_TABLE_5235  0x5235
#define UNIT_TYPE_WORD_5230    0x5230
#define UNIT_TYPE_STRIDE_7     7

/* Per-power AI-controller byte table @DGROUP:0x543F, stride 0x34 (0 = human;
 * cross-confirmed in tax_apply.c). @asm 0x02F147/0x02F2C3/0x02F389. */
#define AI_CTRL_543F     0x543F
#define POWER_STRIDE_34  0x34

/* Per-power name/handle word table @DGROUP:0x838C (push [bx-0x7c74] with bx=power*2;
 * 0x838C = 0 - 0x7c74 region). @asm 0x02F1BF. And @DGROUP:0x8394 (push [bx-0x7c6c])
 * the per-DIFFICULTY label table indexed by [0x53A6] (@asm 0x02F2D4). */
extern uint8_t g_difficulty_53A6;       /* DGROUP:0x53A6 — difficulty 0..4 */

/* Per-colony name word table @DGROUP:0x8D42 (push [bx-0x72be], bx=colony*2). @asm 0x02F693. */

/* ----------------------------------------------------------------------------
 * lcall / overlay helpers (call sites + args BYTE_VERIFIED; internals in thunk page).
 * Selector -> resident/overlay target resolved via thunk-table formula
 *   thunk_file = 0x2400 + (sel_seg<<4) + sel_off ; type-B targets resident.
 *   0x181F:0x0590 -> thunk 0x01AB80 (type B) -> resident 0x00BCEA  (per-power setup; arg=class byte)
 *   0x181F:0x07A0 -> thunk 0x01AD90 (type B) -> resident 0x006608  (select unit by index)
 *   0x181F:0x0302 -> thunk 0x01A8F2 (type B) -> resident 0x005BFA  is_xy_in_map_bounds(x,y)
 *   0x181F:0x0438 -> thunk 0x01AA28 (type A)                       per-power state setter (handle,flag)
 *   0x181F:0x0416 -> thunk 0x01AA06 (type A)                       blit/store ptr into msg slot
 *   0x181F:0x04C0 -> thunk 0x01AAB0 (type B) -> resident 0x00518E  set UI channel/mode(arg)
 *   0x181F:0x0652 -> thunk 0x01AC42 (type A)                       show localized message(channel,handle)
 *   0x181F:0x05FA -> thunk 0x01ABEA (type A)                       (handle,power) — record/notify
 *   0x181F:0x095C -> thunk 0x01AF4C (type B) -> resident 0x006D24  spawn_unit(type,owner,x,y)->idx  (VERIFIED role)
 *   0x181F:0x09A4 -> thunk 0x01AF94 (type B) -> resident 0x008110  power_index -> handle
 *   0x181F:0x048E -> thunk 0x01AA7E (type B) -> resident 0x0050BC  set/clear a draw attribute(arg)
 *   0x181F:0x03FE -> thunk 0x01A9EE (type A)                       message-key string -> small int (the
 *                                                                   "lookup keyed config/choice" helper)
 *   0x181F:0x0182 -> thunk 0x01A772 (type B) -> resident 0x0029DE  (helper; body in thunk page)
 *   0x191F:0x0A9E -> thunk 0x01C08E (type A)                       UI: begin/redraw subject power
 *   0x191F:0x0A90 -> thunk 0x01C080 (type A)                       UI: ...
 *   0x191F:0x0A82 -> thunk 0x01C072 (type A)                       UI: ...
 *   0x191F:0x0A74 -> thunk 0x01C064 (type A)                       UI: redraw/flush power
 *   0x191F:0x0A66 -> thunk 0x01C056 (type A)                       UI: ...
 *   0x191F:0x0950 -> thunk 0x01BF40 (type A)                       UI: per-colony refresh(colony)
 *   0x191F:0x0AEE -> thunk 0x01C0DE (type A)                       choose unit type for grant -> type byte
 *   0x191F:0x0AE0 -> thunk 0x01C0D0 (type A)                       show message(channel,handle)
 * (Helper semantics beyond arg shape are NOT byte-verified -> the prototypes
 *  below are LITERAL-faithful but their meaning is inferred from call context.) */
extern void  ovly_181F_0590(int class_byte);                 /* per-power setup */
extern void  unit_select(int unit_idx);                      /* 0x181F:0x07A0 */
extern int   is_xy_in_map_bounds(int x, int y);              /* 0x181F:0x0302 */
extern void  power_set_flag(int handle, int flag);           /* 0x181F:0x0438 */
extern void  msg_set_ptr(int slot, void *p, int a);          /* 0x181F:0x0416 (push order) */
extern void  ui_set_channel(int mode);                       /* 0x181F:0x04C0 */
extern void  ui_show_message(int channel, int msg_handle);   /* 0x181F:0x0652 */
extern void  ovly_181F_05FA(int power, int handle);          /* 0x181F:0x05FA (push order) */
extern int   spawn_unit(int type, int owner, int x, int y);  /* 0x181F:0x095C (role VERIFIED via 0x6D24) */
extern int   power_handle(int power_idx);                    /* 0x181F:0x09A4 */
extern void  ovly_181F_048E(int arg);                        /* 0x181F:0x048E */
extern int   msg_key_lookup(void *key);                      /* 0x181F:0x03FE -> small int */
extern void  ui_redraw_power(int power);                     /* 0x191F:0x0A9E / 0x0A90 / 0x0A82 / 0x0A74 / 0x0A66 */
extern void  ui_refresh_colony(int colony);                  /* 0x191F:0x0950 */
extern int   pick_grant_unit_type(int slot, int owner, int x); /* 0x191F:0x0AEE */
extern void  ui_show_message2(int a, int handle);            /* 0x191F:0x0AE0 */

/* Resolved message handles (file = handle + 0x1D9A0 — BYTE_VERIFIED). */
#define MSG_REFIT          0xEEF   /* -> "REFIT"   @ file 0x1E88F (@asm 0x02F1D7) */
#define MSG_KINGTAX        0xF01   /* -> "KINGTAX" @ file 0x1E8A1 (KINGTAX result; @asm 0x02F392 in sibling) */
#define MSG_WINNING_KEY    0xEF5   /* lea bx,[0xef5] @0x02F314 -> (0xef5+0x1D9A0=0x1E895) */
#define MSG_GRANT_FOLLOWUP 0xF01   /* "KINGTAX" @ file 0x1E8A1 (@asm 0x02F392 push 0xf01) */

/* ============================================================================
 * king_process_power_events — func_02F052 — BYTE_VERIFIED (control flow + writes)
 *
 * For the power g_subject_power_5394 (= "P"):
 *   PHASE A (@asm 0x02F052..0x02F207) — scan UnitRecords for P's units that are
 *     "in transit" (flag 0x80) and either a type-0xB unit OR a type 0xD..0x12
 *     unit; advance/complete their REFIT in Europe; when a unit's REFIT counter
 *     0x315A reaches its per-type duration ([type*7 + 0x5235]) it is brought
 *     ashore (flag 0x80 cleared @0x02F135) and the REFIT message is shown.
 *   PHASE B (@asm 0x02F20A..0x02F3A0) — redraw P's units (0x191F helpers), clear
 *     king[+0x0E], walk colonies to refresh P's, then (gated on P being a human
 *     player with a live revolution event) GRANT a king unit: spawn type 0x11
 *     (17) via spawn_unit, set its goto-coords from king[+0x32]/[+0x33], and show
 *     KINGTAX/INDEPENDENT-class follow-up text.
 *
 * The KINGTAX *amount* is decided elsewhere (func_034AE0, king_tax_raise.c);
 * this routine sets the "an event fired" flag [0x014C]=1 (@0x02F201) used by the
 * caller to know a king interaction happened this turn.
 * ============================================================================ */
void king_process_power_events(void)
{
    int  P     = g_subject_power_5394;        /* [bp-8]  @asm 0x02F058 */
    int  i;                                    /* [bp-6]  unit/colony loop */
    int  found_idx;                            /* reused */

    /* @asm 0x02F060..0x02F06C — per-power setup keyed on the class byte. */
    ovly_181F_0590(g_class_table_0848[P]);     /* @asm 0x02F067 lcall 0x181F:0x590 */

    /* @asm 0x02F06F..0x02F079 — reset the "event fired" result pair. */
    g_found_flag_014C  = 0;                    /* @asm 0x02F071 */
    g_found_value_014E = (int16_t)0xFFFF;      /* @asm 0x02F074 */

    /* ------------------------------------------------------------------ PHASE A
     * @asm 0x02F07A..0x02F207 — walk UnitRecords from the top down. */
    for (i = g_unit_count_539C - 1; i >= 0; i--) {         /* @asm 0x02F07A dec; 0x02F099 cmp>=0 */
        uint8_t *u = (uint8_t *)DGROUP_PTR(UNIT_BASE_3144 + i * UNIT_STRIDE);

        /* @asm 0x02F0A6 — unit must belong to P (owner = low nibble of +0x03). */
        if ((u[U_OWNFLG_3147 - UNIT_BASE_3144] & 0x0F) != P) /* @asm 0x02F0AA and 0xf; 0x02F0AC cmp [bp-8] */
            continue;                                       /* @asm 0x02F0AF jne -> next */

        /* @asm 0x02F0B1..0x02F0BD — select the unit, then call the near helper
         * func_02FAEA (CALL rel16: file 0x02F0C0 + 0x0A2A = 0x02FAEA, which is a
         * LJMP 0x191F:0xA58 trampoline) to classify it; 0 -> skip the unit. */
        unit_select(i);                                     /* @asm 0x02F0B4 lcall 0x181F:0x7A0 */
        if (unit_class_check(i) == 0)                       /* @asm 0x02F0BD e8 2a 0a call near -> file 0x02FAEA */
            continue;                                       /* @asm 0x02F0C5 je -> next */

        /* @asm 0x02F0C7..0x02F0D9 — type filter: type 0xB falls through to the
         * REFIT body (the JNE at 0x02F094 lands at 0x02F0DC); types 0x0D..0x12
         * loop to the in-transit body at 0x02F084; everything else skipped. */
        {
            int type = u[U_TYPE_3146 - UNIT_BASE_3144];     /* @asm 0x02F0CB */
            if (type < 0x0D) {                              /* @asm 0x02F0D0 jb -> next */
                continue;
            }
            if (type > 0x12) {                              /* @asm 0x02F0D7 jbe body; else next */
                continue;
            }
            /* type 0x0D..0x12: in-transit handling at @asm 0x02F084 (re-checks
             * +0x04 bit 0x80 and type==0xB) — folded into the REFIT body below. */
        }

        /* @asm 0x02F0DC..0x02F102 — REFIT body. Bump the refit counter, and if a
         * follow helper (0x181F:0x302 = is_xy_in_map_bounds on x,y) says the unit
         * is on the map, bump it once more. */
        u[U_REFIT_315A - UNIT_BASE_3144]++;                 /* @asm 0x02F0E0 inc [bx+0x315a] */
        if (is_xy_in_map_bounds(u[U_XPOS_3144 - UNIT_BASE_3144],
                                u[U_YPOS_3145 - UNIT_BASE_3144]) != 0)  /* @asm 0x02F0F2 lcall 0x181F:0x302 */
            u[U_REFIT_315A - UNIT_BASE_3144]++;             /* @asm 0x02F0FE inc [si+0x315a] */

        /* @asm 0x02F102..0x02F130 — compare progress against the per-type REFIT
         * duration [type*7 + 0x5235]; if progress has NOT reached it, skip. */
        {
            int type     = u[U_TYPE_3146 - UNIT_BASE_3144];  /* @asm 0x02F112 mov bl,[si] (si=&+0x3146) */
            int progress = u[U_REFIT_315A - UNIT_BASE_3144]; /* @asm 0x02F106 */
            int duration = ((uint8_t *)DGROUP_PTR(UNIT_REFIT_TABLE_5235))[type * UNIT_TYPE_STRIDE_7]; /* @asm 0x02F126 */
            if (duration - progress > 0)                     /* @asm 0x02F12A sub ax,di; 0x02F12E jle */
                continue;                                    /* @asm 0x02F130 jmp next */
        }

        /* @asm 0x02F133..0x02F14E — REFIT complete: bring the unit ashore
         * (clear the in-transit bit 0x80), then gate the announcement on P being
         * a HUMAN player (index < 4 and AI-controller byte == 0). */
        u[U_FLAGS_3148 - UNIT_BASE_3144] &= 0x7F;           /* @asm 0x02F135 and [bx+0x3148],0x7f */
        if (P >= 4) continue;                               /* @asm 0x02F13E jl; else next */
        if (((uint8_t *)DGROUP_PTR(AI_CTRL_543F))[P * POWER_STRIDE_34] != 0) /* @asm 0x02F147 */
            continue;                                       /* @asm 0x02F14C je body; else next */

        /* @asm 0x02F151..0x02F1FE — ANNOUNCE the refit: select unit on map
         * (using its per-type word handle 0x5230), then if it is still flagged
         * in-transit re-pick a deploy slot (0x181F:0x7BE), compose the REFIT
         * message (handle 0xEEF) with the unit/colony name, and show it. */
        {
            int type = u[U_TYPE_3146 - UNIT_BASE_3144];     /* @asm 0x02F151 */
            ui_select_on_map(((uint16_t *)DGROUP_PTR(UNIT_TYPE_WORD_5230))[type * UNIT_TYPE_STRIDE_7 / 2],
                             0);                            /* @asm 0x02F161 push [bx+0x5230]; 0x02F169 lcall 0x181F:0x438 */
            /* @asm 0x02F171..0x02F1B7 — if still in transit, find a landing slot
             * for (x,y) via 0x181F:0x7BE; on success format the colony name. */
            if (unit_class_check2(u[U_XPOS_3144 - UNIT_BASE_3144],
                                  u[U_YPOS_3145 - UNIT_BASE_3144]) != 0) { /* @asm 0x02F17D lcall 0x181F:0x302 */
                int slot = find_landing_slot(u[U_XPOS_3144 - UNIT_BASE_3144],
                                             u[U_YPOS_3145 - UNIT_BASE_3144]); /* @asm 0x02F195 lcall 0x181F:0x7BE */
                if (slot >= 0) {                            /* @asm 0x02F1A2 jl */
                    void *colrec = DGROUP_PTR(0x5D48 + slot * 0xCA); /* @asm 0x02F1A4 imul 0xca; +0x5d48 */
                    msg_set_ptr(1, colrec, 0);              /* @asm 0x02F1AF lcall 0x181F:0x416 */
                } else {
                    /* @asm 0x02F1BA — fall-back: use P's name word [P*2 + 0x838C]. */
                    msg_set_int(1, ((uint16_t *)DGROUP_PTR(0x838C))[P]); /* @asm 0x02F1BF push [bx-0x7c74]; 0x02F1C5 lcall 0x181F:0x438 */
                }
            }
            ui_set_channel(0x54);                           /* @asm 0x02F1CD mov ax,0x54; 0x02F1D0 lcall 0x181F:0x4C0 */
            ui_show_message(0, MSG_REFIT);                  /* @asm 0x02F1D7 push 0xeef; 0x02F1DA lcall 0x181F:0x652 */
            /* @asm 0x02F1E2..0x02F1FE — re-test the unit; if still flagged, loop. */
            if (unit_class_check(i) != 0) continue;         /* @asm 0x02F1F2 lcall 0x181F:0x302; 0x02F1FC jmp next */
            g_found_flag_014C = 1;                          /* @asm 0x02F201 mov word [0x14c],1  (KINGTAX/event fired) */
            continue;                                       /* @asm 0x02F207 jmp next */
        }
    }

    /* ------------------------------------------------------------------ PHASE B
     * @asm 0x02F20A..0x02F243 — redraw P's units and reset king[+0x0E]. */
    ui_redraw_power(P);                                     /* @asm 0x02F20D lcall 0x191F:0xA9E */
    ui_redraw_power(P);                                     /* @asm 0x02F218 lcall 0x191F:0xA90 */
    ui_flush();                                             /* @asm 0x02F220 lcall 0x191F:0xA82 (no arg) */
    if (g_found_flag_014C != 0)                             /* @asm 0x02F225 cmp [0x14c],0 */
        ovly_181F_05FA(P, g_found_value_014E);              /* @asm 0x02F233 lcall 0x181F:0x5FA */
    ((int16_t *)g_king_record_84FC)[0x0E / 2] = 0;          /* @asm 0x02F23F mov word [bx+0xe],0 */

    /* @asm 0x02F244..0x02F26E — refresh every colony owned by P. */
    for (i = g_colony_count_539E - 1; i >= 0; i--) {        /* @asm 0x02F247 dec; 0x02F26A cmp>=0 */
        uint8_t *col_owner = (uint8_t *)DGROUP_PTR(0x5D60 + i * 0xCA); /* @asm 0x02F251 imul 0xca; +0x5d60 */
        if (*col_owner == (uint8_t)P)                       /* @asm 0x02F256 cmp [bx+0x5d60],al */
            ui_refresh_colony(i);                           /* @asm 0x02F25F lcall 0x191F:0x950 */
    }
    ui_redraw_power(P);                                     /* @asm 0x02F273 lcall 0x191F:0xA74 */
    ui_redraw_power(P);                                     /* @asm 0x02F27E lcall 0x191F:0xA66 */

    /* @asm 0x02F286..0x02F294 — gate the king-GRANT on game phase:
     * skip unless ([0xA89B]!=0 || [0xA89A]>3). (Phase/turn-stage globals — RUNTIME_ONLY.) */
    if (!(*(uint8_t *)DGROUP_PTR(0xA89B) != 0 ||            /* @asm 0x02F286 cmp [0xa89b],0; jne */
          *(uint8_t *)DGROUP_PTR(0xA89A) > 3))              /* @asm 0x02F28D cmp [0xa89a],3; ja */
        return;                                             /* @asm 0x02F294 jmp -> RETF */

    /* @asm 0x02F297..0x02F2A2 — skip if P's revolution sub-flag [P*0x13 - 0x6DA3]
     * is set (i.e. already handled). (0x9258 region per-power byte table.) */
    if (((uint8_t *)DGROUP_PTR(0x9258))[P * 0x13] != 0)     /* @asm 0x02F29B cmp [bx-0x6da3],0; je */
        return;                                             /* @asm 0x02F2A2 jmp -> RETF */

    /* @asm 0x02F2A5..0x02F2B6 — skip unless a revolution is live AND certain
     * event bits are pending: [0x5382] bit0 must be CLEAR and [0x538E]&7 clear. */
    if (*(uint8_t *)DGROUP_PTR(0x5382) & 1) return;         /* @asm 0x02F2A5 test [0x5382],1; jne RETF */
    if (*(uint8_t *)DGROUP_PTR(0x538E) & 7) return;         /* @asm 0x02F2AF test [0x538e],7; jne RETF */

    /* @asm 0x02F2B9..0x02F320 — for a HUMAN P (idx<4, AI byte==0): announce the
     * king-grant using P's per-difficulty label [diff*2 + 0x8394], format args,
     * and look up the keyed message INDEPENDENT (handle 0xF18 = "WINNING") -> a
     * small int into [bp-2].  (For AI/out-of-range P, [bp-2] is forced to 1.) */
    int decision;                                            /* [bp-2] */
    if (P < 4 &&                                             /* @asm 0x02F2B9 cmp [bp-8],4; jge else */
        ((uint8_t *)DGROUP_PTR(AI_CTRL_543F))[P * POWER_STRIDE_34] == 0) { /* @asm 0x02F2C3 cmp [bx+0x543f],0; jne else */
        msg_set_int(0, ((uint16_t *)DGROUP_PTR(0x8394))[g_difficulty_53A6]); /* @asm 0x02F2D4 push [bx-0x7c6c]; 0x02F2DC lcall 0x181F:0x438 */
        msg_set_ptr(1, DGROUP_PTR(0x540E + P * 0x34), 0);   /* @asm 0x02F2E8 push ds; push 0x540e+P*0x34; 0x02F2EC lcall 0x181F:0x416 */
        msg_set_int(2, power_label(P));                     /* @asm 0x02F2F7 lcall 0x181F:0x9A4; 0x02F302 lcall 0x181F:0x438 */
        ovly_181F_048E(0x3E);                               /* @asm 0x02F30A push 0x3e; 0x02F30C lcall 0x181F:0x48E */
        decision = msg_key_lookup(DGROUP_PTR(MSG_WINNING_KEY)); /* @asm 0x02F314 lea bx,[0xef5]; 0x02F318 lcall 0x181F:0x3FE */
    } else {
        decision = 1;                                       /* @asm 0x02F322 mov word [bp-2],1 */
    }

    /* @asm 0x02F327..0x02F32B — only proceed if the keyed lookup == 1. */
    if (decision != 1) return;                              /* @asm 0x02F32B jne -> RETF */

    /* @asm 0x02F32D..0x02F377 — GRANT: spawn a type-0x11 (17) unit for P at
     * (P-0x18, P-0x18) (the king's-gift staging coords), clear its orders, copy
     * the king's goto-coords king[+0x32]/[+0x33] into the new unit, then choose a
     * concrete grant type via 0x191F:0xAEE and mark it (+0x04 bit 0x40). */
    /* @asm 0x02F32D..0x02F33F — pushes are (P-0x18),(P-0x18),P,0x11 (right-to-
     * left); func_006D24 reads them as bp+6=type, bp+8=owner, bp+0xA=x, bp+0xC=y.
     * So: spawn_unit(type=0x11, owner=P, x=(P-0x18), y=(P-0x18)). */
    found_idx = spawn_unit(/*type*/0x11, /*owner*/P, /*x*/P - 0x18, /*y*/P - 0x18); /* lcall 0x181F:0x95C */
    if (found_idx < 0) return;                              /* @asm 0x02F347 jl -> RETF */
    {
        uint8_t *nu  = (uint8_t *)DGROUP_PTR(UNIT_BASE_3144 + found_idx * UNIT_STRIDE); /* @asm 0x02F349 imul 0x1c */
        uint8_t *kr  = (uint8_t *)g_king_record_84FC;       /* @asm 0x02F351 mov si,[0x84fc] */
        nu[U_ORDERS_314C - UNIT_BASE_3144] = 0;             /* @asm 0x02F34C mov [bx+0x314c],0 */
        nu[U_GOTOX_314D - UNIT_BASE_3144] = kr[0x32];       /* @asm 0x02F355/0x02F358 <- king[+0x32] */
        nu[U_GOTOY_314E - UNIT_BASE_3144] = kr[0x33];       /* @asm 0x02F35C/0x02F35F <- king[+0x33] */
        nu[U_REFIT_315A - UNIT_BASE_3144] =
            (uint8_t)pick_grant_unit_type(kr[0x33], 0, found_idx); /* @asm 0x02F369 push [bp-6]; 0x02F36E lcall 0x191F:0xAEE; 0x02F376 store */
        nu[U_FLAGS_3148 - UNIT_BASE_3144] |= 0x40;          /* @asm 0x02F37A or [si+0x3148],0x40 */
    }

    /* @asm 0x02F37F..0x02F39A — if P is human and not AI-controlled, show the
     * INDEPENDENT-class follow-up (handle 0xF01 region, channel arg 0x0A). */
    if (P < 4 &&                                            /* @asm 0x02F37F cmp [bp-8],4; jge skip */
        ((uint8_t *)DGROUP_PTR(AI_CTRL_543F))[P * POWER_STRIDE_34] == 0) /* @asm 0x02F389 cmp [bx+0x543f],0; jne skip */
        overlay_call_191F_0AE0(0xf01, 0xa);         /* @asm 0x02F390 push 0xa; push 0xf01; 0x02F395 lcall 0x191F:0xAE0 */

    /* @asm 0x02F39D — pop si/di; leave; retf. */
}

/* ----------------------------------------------------------------------------
 * Forward-declared local helpers whose CALL sites are byte-verified but whose
 * bodies live in other overlay pages (semantics inferred from call context).
 * ---------------------------------------------------------------------------- */
extern int  unit_class_check(int unit_idx);          /* near func_02FAEA (file 0x02FAEA) -> 0x191F:0xA58 */
extern int  unit_class_check2(int x, int y);         /* 0x181F:0x302 reuse (is_xy_in_map_bounds) */
extern int  find_landing_slot(int x, int y);         /* 0x181F:0x7BE */
extern void ui_select_on_map(int handle, int a);     /* 0x181F:0x438 */
extern void msg_set_int(int slot, int value);        /* 0x181F:0x438 (int form) */
extern void ui_flush(void);                          /* 0x191F:0xA82 */
extern int  power_label(int power_idx);              /* 0x181F:0x9A4 -> handle */

/* MSG_WINNING_KEY / MSG_GRANT_FOLLOWUP defined near the top with the other MSG_* constants. */

/* ============================================================================
 * NOTES / NOT YET VERIFIED
 *  - CORE control flow + every cited DGROUP/UnitRecord/king-record write:
 *    BYTE_VERIFIED (spot-checks in the header).
 *  - "REFIT" / "KINGTAX" identity: BYTE_VERIFIED via the handle->file rule.
 *  - spawn_unit (0x181F:0x95C -> resident func_006D24) role is VERIFIED (that
 *    helper allocates a UnitRecord slot, sets +0x02 type / +0x03 owner /
 *    +0x07 prof 0x58 / places via 0x5EB:0xA76, returns the new index).
 *  - Helper PROTOTYPES (ui_*, msg_*, power_*) are LITERAL-faithful to the push
 *    args but the helpers' precise semantics are inferred from call context.
 *  - Phase/stage globals 0xA89A/0xA89B and the per-power tables at 0x9258 /
 *    0x540E / 0x838C / 0x8394 are BYTE_VERIFIED *addresses*; their full layout is
 *    documented elsewhere (or not yet decoded).
 *  - The keyed-lookup helper 0x181F:0x3FE returns a small int compared to 1; its
 *    exact contract (menu choice vs config value) is inferred from call context.
 *  - MSG handle 0xEF5 = "KINGFRIGATE" (confirmed via strings.json lookup 2026-06-10).
 * ============================================================================ */
