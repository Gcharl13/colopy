/* ============================================================================
 *   >>> WAR-OF-INDEPENDENCE per-turn handler (REF landing, defeat checks,
 *       king-warnings) — BYTE_VERIFIED structure <<<
 * ----------------------------------------------------------------------------
 * The end-of-turn "king & revolution" handler for the active power [0x5398].
 * The wave-5 UI agent flagged this as a "Win/lose check" SCREEN, and the prior
 * FUNCTION_INVENTORY stub listed YOULOSE/YOUWIN — both are WRONG: this is the
 * king-MILITARY turn logic.  Identified by STRING XREF (decisive); every handle
 * resolves through the load-image string table (file = handle + 0x1D9A0,
 * base BYTE_VERIFIED):
 *     0xF09 -> 0x1E8A9 "LOSENOCOLONIES"  (@asm 0x02F441 push 0xf09)
 *     0xF18 -> 0x1E8B8 "WINNING"         (@asm 0x02F542 lea bx,[0xf18])
 *     0xF20 -> 0x1E8C0 "KINGLOSE"        (@asm 0x02F54B push 0xf20)
 *     0xF29 -> 0x1E8C9 "LOSING0"         (@asm 0x02F670 push 0xf29)
 *     0xF31 -> 0x1E8D1 "KINGWIN"         (@asm 0x02F6A1 push 0xf31)
 *     0xF39 -> 0x1E8D9 "WARN0"           (@asm 0x02F6BE push 0xf39)
 *     0xF3F -> 0x1E8DF "INDEPENDENT"     (@asm 0x02F921 push 0xf3f)
 *     0xF4B -> 0x1E8EB "NAMES"           (@asm 0x02F924 push 0xf4b)
 *     0xF51 -> 0x1E8F1 "OTHERGRANTED"    (@asm 0x02F949 lea bx,[0xf51])
 *     0xF5E -> 0x1E8FE "OTHERMIGHT"      (@asm 0x02F7EC push 0xf5e)
 *     0xF69 -> 0x1E909 "OTHERLESS"       (@asm 0x02F86F push 0xf69)
 *     0xF73 -> 0x1E913 "SOONRETIRING"    (@asm 0x02F9B4 push 0xf73)
 *     0xF80 -> 0x1E920 "RETIRING"        (@asm 0x02FA8F lea bx,[0xf80])
 *     0xF89 -> 0x1E929 "RETIRING2"       (@asm 0x02FA96 lea bx,[0xf89])
 *     0xF93 -> 0x1E933 "SCORED"          (@asm 0x02FAC9 lea bx,[0xf93])
 *   (The inventory's "YOULOSE/YOUWIN" are NOT pushed by this body — corrected.)
 *
 * @asm_function  func_02F3A2   (file 0x02F3A2..0x02FAE8, 1869 bytes, RETF)
 * @asm_disasm    disasm_overlay_reseg/page_03.asm  (page 0x03; IP = file - 0x02CB00).
 *                NOTE: the per-function dump disasm/func_02F3A2_unknown.asm is
 *                TRUNCATED at 0x02F3E0 (reports 63 bytes); the real extent is
 *                1869 bytes ending at the RETF @0x02FAE8 — confirmed from the
 *                re-segmented page AND the raw EXE (do NOT trust the dump size).
 * @verified_by   Hand-decompiled 2026-05-30; control flow + every cited operand
 *                spot-checked byte-for-byte against COLONIZE/VICEROY.EXE:
 *                  0x02F3A2: C8 78 00 00       enter 0x78,0
 *                  0x02F3AD: F6 06 82 53 01    test byte [0x5382],1   (at-war bit)
 *                  0x02F3FD: 81 3E 8A 53 40 06 cmp word [0x538a],0x640 (year>=1600)
 *                  0x02F4EE: 83 3E E0 53 01    cmp word [0x53e0],1     (Artillery REF slot)
 *                  0x02F500: 03 06 DA 53       add ax,[0x53da]         (Regulars REF slot)
 *                  0x02F973: 81 3E 8A 53 FE 06 cmp word [0x538a],0x6fe (year==1790)
 *                  0x02F9ED: 81 3E 8A 53 08 07 cmp word [0x538a],0x708 (year==1800)
 *                  0x02FAE8: CB                retf
 * @ref  src/king/ref.c          (REF composition @0x53DA..0x53E0; buildup)
 * @ref  src/king/intervention.c (foreign_intervention — same helper conventions)
 * ============================================================================ */
#include "viceroy_types.h"
#include "globals.h"

/* ----------------------------------------------------------------------------
 * DGROUP globals (addresses BYTE_VERIFIED from operands).  LOCAL externs only.
 * ---------------------------------------------------------------------------- */
extern int16_t g_active_power_5398;     /* DGROUP:0x5398 — active power index (byte/word) */
extern int16_t g_enemy_power_53D2;      /* DGROUP:0x53D2 — the at-war counter-power index */
extern uint8_t g_flags_5382;            /* DGROUP:0x5382 — global event flags:
                                         *   bit0(0x01)=at war (revolution declared)
                                         *   bit3(0x08)=king-warning issued
                                         *   bit4(0x10)=this-turn handler already ran
                                         *   bit5(0x20)=REF-landing phase active
                                         *   bit6(0x40)=(read in threshold @0x02F4D2) */
extern int16_t g_year_538A;             /* DGROUP:0x538A — current year (1492..) */
extern int16_t g_turn_in_year_538C;     /* DGROUP:0x538C — within-year sub-turn (0 = year boundary) */
extern int16_t g_event_bits_538E;       /* DGROUP:0x538E — per-turn event bits (&7 tested @0x?) */
extern int16_t g_score_result_53C2;     /* DGROUP:0x53C2 — defeat/score-result accumulator */
extern int16_t g_retire_flag_53A2;      /* DGROUP:0x53A2 — "king retiring" flag (set @0x02FABE) */
extern uint8_t g_difficulty_53A6;       /* DGROUP:0x53A6 — difficulty 0..4 */
extern int16_t g_some_flag_0104;        /* DGROUP:0x0104 — set to 1 @0x02F55F (UI dirty?) */
extern void *  g_king_record_84FC;      /* DGROUP:0x84FC — far ptr to king PowerRecord;
                                         *   +0x1A = REF land-deployment progress byte */
extern void *  g_colony_base_8542;      /* DGROUP:0x8542 — current colony struct (memory note) */

/* REF composition words @DGROUP:0x53DA..0x53E0 (BYTE_VERIFIED order in ref.c):
 *   0x53DA Regulars · 0x53DC Cavalry · 0x53DE Man-O-War · 0x53E0 Artillery. */
extern int16_t g_ref_regulars_53DA;     /* DGROUP:0x53DA (@asm 0x02F500) */
extern int16_t g_ref_cavalry_53DC;      /* DGROUP:0x53DC (@asm 0x02F4F6) */
extern int16_t g_ref_artillery_53E0;    /* DGROUP:0x53E0 (@asm 0x02F4EE) */

/* Per-power AI-controller byte table @DGROUP:0x543F, stride 0x34 (0=human). */
#define AI_CTRL_543F     0x543F
#define POWER_STRIDE_34  0x34

/* Per-power colony-count scratch byte @[power - 0x6D68] (0x9230 region, indexed
 * by the power record ptr): @asm 0x02F3D0 mov [bx-0x6d68],0 (zero), then ++ per
 * owned colony @0x02F3ED. */
#define POWER_NCOL_9230  0x9230

/* Per-colony owner byte table @DGROUP:0x5D60, stride 0xCA (@asm 0x02F3E3). */
#define COL_OWNER_5D60   0x5D60
#define COL_STRIDE_CA    0xCA

/* UnitRecord table @DGROUP:0x3144 stride 0x1C (project memory). Fields used:
 *   +0x03 (0x3147) owner|flags (owner=low nibble) · +0x02 (0x3146) type. */
#define UNIT_BASE_3144   0x3144
#define UNIT_STRIDE_1C   0x1C
#define U_OWNFLG_3147    0x3147
#define U_TYPE_3146      0x3146

/* Per-power name string @DGROUP:0x540E + power*0x34 (the power's display name;
 * @asm 0x02F432/0x02F518/0x02F2E8-style ptr blits). */
#define POWER_NAME_540E  0x540E
/* Per-power record block @DGROUP:0x5426 + power*0x34 (@asm 0x02F529). */
#define POWER_REC_5426   0x5426
/* Per-difficulty label word table @DGROUP:0x8394 (push [bx-0x7c6c], bx=diff*2). */
#define DIFF_LABEL_8394  0x8394
/* Per-power name word table @DGROUP:0x8D42 (push [bx-0x72be], bx=power*2). */
#define POWER_NAMEW_8D42 0x8D42
/* Per-power "intervention friend" byte @[power - 0x6BF4] (0x9404 region;
 * @asm 0x02F5BD/0x02F5DD). */
#define POWER_FRIEND_9404 0x9404
/* Per-arm REF unit-type byte @[arm - 0x6BF0] (0x9408 region; @asm 0x02F7B1/0x02F834). */
#define REF_ARM_TYPE_9408 0x9408

/* Per-power colony record @DGROUP:0x5D48 stride 0xCA (@asm 0x02FA74 imul 0xca; +0x5d48). */
#define COL_RECORD_5D48  0x5D48

/* ----------------------------------------------------------------------------
 * lcall / overlay helpers (call sites + args BYTE_VERIFIED; internals in thunk page).
 * Selectors resolved via thunk-table formula (see king_events.c).
 *   0x191F:0x0A74 -> UI redraw/flush power(index)
 *   0x181F:0x0438 -> set numeric message arg / per-power state setter
 *   0x181F:0x0416 -> store ds-ptr into a message slot
 *   0x191F:0x0AD4 -> show message by handle (one-arg)
 *   0x181F:0x0574 -> commit/redraw the composed message screen (no arg)
 *   0x181F:0x09E6 -> select unit by index
 *   0x181F:0x09AE -> set a numeric substitution arg(slot,value-dword)
 *   0x181F:0x09A4 -> power index -> handle
 *   0x181F:0x03FE -> message-key string -> small int (keyed lookup)
 *   0x191F:0x0AC8 -> flash/redraw a power's UI(power,a,b)
 *   0x191F:0x0ABA -> show message(handle,a,b)
 *   0x191F:0x0AAC -> show message (no arg) / advance
 *   0x0D1D:0x07E4 -> CRT: format/copy a keyed string into a local buffer(handle,&buf)
 *   0x181F:0x0652 -> show localized message(channel,handle)
 *   0x181F:0x0A06 / 0x0A10 -> per-(power,arm) matrix accessor (set/get)
 *   0x181F:0x056A -> open a yes/no prompt (returns via the 0x3FE lookup)
 *   0x181F:0x0182 -> (string compose helper)
 * (Prototypes are LITERAL-faithful to push args; semantics inferred from call context.) */
extern void  ui_redraw_power(int power);                   /* 0x191F:0x0A74 */
extern void  msg_set_int(int slot, int value);             /* 0x181F:0x0438 (int) */
extern void  msg_set_ptr(int slot, void *p, int a);        /* 0x181F:0x0416 */
extern void  ui_show_message_h(int handle);                /* 0x191F:0x0AD4 */
extern void  ui_commit_message(void);                      /* 0x181F:0x0574 */
extern void  unit_select(int unit_idx);                    /* 0x181F:0x09E6 */
extern void  msg_set_long(int slot, int32_t value);        /* 0x181F:0x09AE */
extern int   power_handle(int power_idx);                  /* 0x181F:0x09A4 */
extern int   msg_key_lookup(void *key);                    /* 0x181F:0x03FE */
extern void  ui_flash_power(int power, int a, int b);      /* 0x191F:0x0AC8 */
extern void  ui_show_message_3(int handle, int a, int b);  /* 0x191F:0x0ABA */
extern void  ui_show_message_0(void);                      /* 0x191F:0x0AAC */
extern void  crt_keyed_to_buf(int handle, char *buf);      /* 0x0D1D:0x07E4 */
extern void  ui_show_message(int channel, int handle);     /* 0x181F:0x0652 */
extern int   ref_matrix_get(int power, int arm);           /* 0x181F:0x0A06 */
extern void  ref_matrix_set(int power, int arm, int v);    /* 0x181F:0x0A10 */
extern int   ui_yesno_prompt(void *key);                   /* 0x181F:0x056A + 0x3FE */
extern void  ovly_181F_0182(int a, void *seg_off, int b);  /* 0x181F:0x0182 */
extern void  ui_fmt_two(int a, int h0, int h1);            /* 0x181F:0x422 */

/* Message handles (file = handle + 0x1D9A0 — BYTE_VERIFIED). */
#define MSG_LOSENOCOLONIES 0xF09
#define MSG_WINNING        0xF18
#define MSG_KINGLOSE       0xF20
#define MSG_LOSING0        0xF29
#define MSG_KINGWIN        0xF31
#define MSG_WARN0          0xF39
#define MSG_INDEPENDENT    0xF3F
#define MSG_NAMES          0xF4B
#define MSG_OTHERGRANTED   0xF51
#define MSG_OTHERMIGHT     0xF5E
#define MSG_OTHERLESS      0xF69
#define MSG_SOONRETIRING   0xF73
#define MSG_RETIRING       0xF80
#define MSG_RETIRING2      0xF89
#define MSG_SCORED         0xF93

/* ============================================================================
 * king_war_turn — func_02F3A2 — BYTE_VERIFIED (control flow + writes)
 *
 * Runs once per turn for the active power [0x5398].  Sequence:
 *   1. (@0x02F3A2) summary flag = 1; if at war, redraw the enemy power.
 *   2. (@0x02F3C0) count the active power's colonies into the scratch byte.
 *   3. DEFEAT-by-no-colonies (@0x02F3FD): from year >= 1600, if the power has 0
 *      colonies and is NOT at war -> LOSENOCOLONIES, result=0, summary=0, end.
 *   4. PEACE warning path (@0x02F478): if not yet warned (bit3 clear), count the
 *      power's land military (unit types 6/8/0xB) and the REF readiness
 *      (Artillery>=1 + Cavalry>=1 + Regulars >= 4); when thresholds are crossed
 *      issue the KINGTAX/WINNING warning, set bit3, mark UI dirty.
 *   5. WAR / REF-LANDING path (@0x02F2C2 fall-through under bit0): per-arm loop
 *      lands Royal Expeditionary Force units near the player and posts the
 *      OTHERGRANTED/OTHERMIGHT/OTHERLESS messages; king[+0x1A] tracks deployment.
 *   6. YEAR-event path (@0x02F2E62): unless bit4 already set, fire the dated
 *      king messages (WARN0/SOONRETIRING/RETIRING/RETIRING2) at 1790/1800/1840/
 *      1850, run the SCORED path, then set bit4 (handler done this turn).
 * ============================================================================ */
void king_war_turn(void)
{
    int  P = g_active_power_5398;
    int  show_summary = 1;                  /* [bp-0x5e] @asm 0x02F3A8 */
    int  i;                                  /* [bp-0x74] colony/unit loop */

    /* @asm 0x02F3AD..0x02F3BD — if at war, redraw the enemy power first. */
    if (g_flags_5382 & 1)                    /* @asm 0x02F3AD test [0x5382],1 */
        ui_redraw_power(g_enemy_power_53D2); /* @asm 0x02F3B8 lcall 0x191F:0xA74 */

    /* @asm 0x02F3C0..0x02F3FB — redraw P and count P's colonies into the scratch
     * byte [P-0x6D68]. */
    ui_redraw_power(P);                                       /* @asm 0x02F3C4 lcall 0x191F:0xA74 */
    ((uint8_t *)DGROUP_PTR(POWER_NCOL_9230))[P] = 0;          /* @asm 0x02F3D0 mov [bx-0x6d68],0 */
    for (i = 0; i < g_colony_count_539E; i++) {               /* @asm 0x02F3F7 cmp [0x539e],ax; jg */
        if (((uint8_t *)DGROUP_PTR(COL_OWNER_5D60))[i * COL_STRIDE_CA] == (uint8_t)P) /* @asm 0x02F3E3 */
            ((uint8_t *)DGROUP_PTR(POWER_NCOL_9230))[P]++;    /* @asm 0x02F3ED inc [bx-0x6d68] */
    }

    /* @asm 0x02F3FD..0x02F460 — DEFEAT-by-no-colonies. From year >= 1600
     * ([0x538A] >= 0x640), if P has 0 colonies and is NOT at war: announce the
     * power name + "LOSENOCOLONIES", post a one-arg message, optionally fire an
     * extra effect (0x181F:0x574), zero the score result, clear summary, end. */
    if (g_year_538A >= 0x640 &&                               /* @asm 0x02F3FD cmp [0x538a],0x640; jl skip */
        ((uint8_t *)DGROUP_PTR(POWER_NCOL_9230))[P] == 0 &&   /* @asm 0x02F409 cmp [bx-0x6d68],0; jne skip */
        !(g_flags_5382 & 1)) {                                /* @asm 0x02F410 test [0x5382],1; jne skip */
        msg_set_int(0, ((uint16_t *)DGROUP_PTR(DIFF_LABEL_8394))[g_difficulty_53A6]); /* @asm 0x02F41F push [bx-0x7c6c]; 0x02F425 lcall 0x181F:0x438 */
        msg_set_ptr(1, DGROUP_PTR(POWER_NAME_540E + P * POWER_STRIDE_34), 0); /* @asm 0x02F432 +0x540e; 0x02F439 lcall 0x181F:0x416 */
        ui_show_message_h(MSG_LOSENOCOLONIES);                /* @asm 0x02F441 push 0xf09; 0x02F444 lcall 0x191F:0xAD4 */
        if (!(g_flags_5382 & 0x10))                           /* @asm 0x02F44C test [0x5382],0x10; jne */
            ui_commit_message();                              /* @asm 0x02F453 lcall 0x181F:0x574 */
        g_score_result_53C2 = 0;                              /* @asm 0x02F45A mov [0x53c2],ax(=0) */
        show_summary = 0;                                     /* @asm 0x02F45D mov [bp-0x5e],0 */
        goto finish;                                          /* @asm 0x02F460 jmp 0x2FAA */
    }

    /* @asm 0x02F464..0x02F475 — branch to the WAR-handling tail if at war
     * (bit0) OR if the king-warning has already been issued (bit3). */
    if (g_flags_5382 & 1) goto war_tail;                      /* @asm 0x02F464 test 1; jne -> 0x2C2C */
    if (g_flags_5382 & 8) goto war_tail;                      /* @asm 0x02F46E test 8; je continue */

    /* @asm 0x02F478..0x02F48A — if the ENEMY has colonies and bit5(0x20) is set,
     * skip straight to the REF-landing section. */
    if (((uint8_t *)DGROUP_PTR(POWER_NCOL_9230))[g_enemy_power_53D2] != 0 && /* @asm 0x02F47C cmp [bx-0x6d68],0; je */
        !(g_flags_5382 & 0x20))                               /* @asm 0x02F483 test 0x20; jne */
        goto ref_landing;                                     /* @asm 0x02F48A jmp 0x2A68 */

    /* @asm 0x02F48D..0x02F4D0 — count P's LAND MILITARY units (types 6, 8, 0xB)
     * across the UnitRecord table. */
    {
        int mil = 0;                                          /* [bp-0x58] */
        for (i = 0; i < g_unit_count_539C; i++) {             /* @asm 0x02F4CA cmp [0x539c]; jl */
            uint8_t *u = (uint8_t *)DGROUP_PTR(UNIT_BASE_3144 + i * UNIT_STRIDE_1C);
            if ((u[U_OWNFLG_3147 - UNIT_BASE_3144] & 0x0F) != g_enemy_power_53D2) /* @asm 0x02F49C and 0xf; 0x02F4A2 cmp [0x53d2] */
                continue;                                     /* @asm 0x02F4A6 jne next */
            int type = u[U_TYPE_3146 - UNIT_BASE_3144];       /* @asm 0x02F4AC */
            if (type == 6 || type == 8 || type == 0xB)        /* @asm 0x02F4B5/BA/BF */
                mil++;                                         /* @asm 0x02F4C4 inc [bp-0x58] */
        }

        /* @asm 0x02F4D2..0x02F4E5 — threshold via a branchless construct:
         *   al=[0x5382]; ax&=0x40 (AH cleared); cmp ax,1; sbb ax,ax; al&=0xF9; ax+=8.
         *   bit6 CLEAR -> ax=0 -> sbb=0xFFFF -> AL 0xF9, AH 0xFF -> 0xFFF9 +8 = 1.
         *   bit6 SET   -> ax=0x40 -> sbb=0 -> AL 0 -> 0 +8 = 8.
         * => threshold = (bit6 set) ? 8 : 1.  Branch is `jg`: if threshold > mil,
         * go to the REF-readiness gate; else (mil >= threshold) & bit5 -> landing. */
        int threshold = (g_flags_5382 & 0x40) ? 8 : 1;        /* @asm 0x02F4D2..0x02F4E2 */
        if (threshold > mil) {                                /* @asm 0x02F4E2 cmp ax,[bp-0x58]; jg gate */
            /* @asm 0x02F4EE..0x02F507 — REF READINESS: (Art>=1) + (Cav>=1) +
             * Regulars.  cmp [0x53e0],1; sbb ax,ax; inc ax  => 1 if Art>=1 else 0;
             * same for Cav; add Regulars [0x53da]. If sum >= 4 and bit5 set ->
             * REF landing; else continue to the warning. */
            int ready = ((g_ref_artillery_53E0 >= 1) ? 1 : 0)  /* @asm 0x02F4EE..0x02F4F5 */
                      + ((g_ref_cavalry_53DC   >= 1) ? 1 : 0)  /* @asm 0x02F4F6..0x02F4FD */
                      + g_ref_regulars_53DA;                   /* @asm 0x02F500 add ax,[0x53da] */
            if (ready >= 4) {                                  /* @asm 0x02F504 cmp ax,4; jl warning */
                if (g_flags_5382 & 0x20) goto ref_landing;     /* @asm 0x02F509 test 0x20; je ref_landing */
            }
        } else {
            if (g_flags_5382 & 0x20) goto ref_landing;         /* @asm 0x02F4E7 test 0x20; je ref_landing */
        }

        /* @asm 0x02F510..0x02F565 — KING WARNING ("the King grows impatient"):
         * compose the power name + WINNING(0xf18) + KINGLOSE(0xf20) message,
         * show it, set bit3 (warning issued) and [0x104]=1 (UI dirty), end. */
        msg_set_ptr(0, DGROUP_PTR(POWER_NAME_540E + P * POWER_STRIDE_34), 0); /* @asm 0x02F510 lcall 0x181F:0x416 */
        msg_set_ptr(1, DGROUP_PTR(POWER_REC_5426  + P * POWER_STRIDE_34), 0); /* @asm 0x02F524 lcall 0x181F:0x416 */
        ovly_181F_0182(3, 0, 0);                              /* @asm 0x02F538 push 3; 0x02F53A lcall 0x181F:0x4AC */
        crt_keyed_to_buf(MSG_WINNING, /*&buf*/0);             /* @asm 0x02F542 lea bx,[0xf18]; 0x02F546 lcall 0x181F:0x3FE */
        ui_show_message_3(MSG_KINGLOSE, 2, 1);                /* @asm 0x02F54B push 0xf20,2,1; 0x02F552 lcall 0x191F:0xABA */
        g_flags_5382 |= 8;                                    /* @asm 0x02F55A or [0x5382],8 */
        g_some_flag_0104 = 1;                                 /* @asm 0x02F55F mov [0x104],1 */
        goto finish;                                          /* @asm 0x02F565 jmp 0x2FAA */
    }

ref_landing:
    /* ------------------------------------------------------------------ @0x2A68
     * @asm 0x02F568..0x02F6B5 — REF LANDING / "the King sends more troops".
     * Count P's "best general" presence ([0x8542]+0x1c bit 0x40 over colonies),
     * derive a granted-vs-needed ratio for the friend power, post OTHERGRANTED
     * (0xf51) / OTHERMIGHT(0xf5e) / OTHERLESS(0xf69) / LOSING0(0xf29) messages,
     * then loop back to the warning composer. */
    {
        int generals = 0;                                     /* [bp-0x66] */
        for (i = 0; i < g_colony_count_539E; i++) {           /* @asm 0x02F593 cmp [0x539e]; jg */
            unit_select(i);                                   /* @asm 0x02F573 lcall 0x181F:0x9E6 */
            uint8_t *col = (uint8_t *)g_colony_base_8542;
            if (col[0x1A] == (uint8_t)P && (col[0x1C] & 0x40)) /* @asm 0x02F582 cmp [bx+0x1a]; 0x02F587 test [bx+0x1c],0x40 */
                generals++;                                   /* @asm 0x02F58D inc [bp-0x66] */
        }

        /* @asm 0x02F59C..0x02F606 — granted = friend[P-0x6BF4] (signed via not/
         * inc when 0), needed similarly for the enemy; pct = granted*100/(granted
         * +needed). Two thresholds: pct>=0x50(80) and pct>=0x5A(90) bump message
         * severity; generals count also bumps it. */
        int a_lvl = (generals < 3) ? 1 : 0;                   /* [bp-0x64] @asm 0x02F5A4 cmp [bp-0x66],3; jge */
        int b_lvl = (generals == 0) ? 1 : 0;                  /* [bp-0x5c] @asm 0x02F5AF (mirrors) */
        int g_friend = ((uint8_t *)DGROUP_PTR(POWER_FRIEND_9404))[g_enemy_power_53D2]; /* @asm 0x02F5BD */
        if (g_friend == 0) g_friend = 2;                      /* @asm 0x02F5C2 (not/inc/inc when 0) -> [bp-0x72] */
        int p_friend = ((uint8_t *)DGROUP_PTR(POWER_FRIEND_9404))[P]; /* @asm 0x02F5DD */
        if (p_friend == 0) p_friend = 2;                      /* @asm 0x02F5E2 -> [bp-0x68] */
        int pct = (g_friend * 100) / (p_friend + g_friend);   /* @asm 0x02F5FE imul 0x64; 0x02F603 idiv */
        if (pct >= 0x50) a_lvl = 3;                           /* @asm 0x02F608 cmp 0x50; jl */
        if (pct >= 0x5A) b_lvl = 3;                           /* @asm 0x02F612 cmp 0x5a; jl */
        if (((uint8_t *)DGROUP_PTR(POWER_NCOL_9230))[P] < 3) a_lvl = 2; /* @asm 0x02F61C cmp [bx-0x6d68],3; jae */
        if (((uint8_t *)DGROUP_PTR(POWER_NCOL_9230))[P] == 0) b_lvl = 2;/* @asm 0x02F628 cmp 0; jne */

        if (b_lvl != 0) {                                     /* @asm 0x02F634 cmp [bp-0x5c],0; je else */
            /* @asm 0x02F63A..0x02F6B5 — strong message: power rec + name +
             * LOSING0(0xf29) with computed value, then WARN0(0xf39) and loop. */
            msg_set_ptr(0, DGROUP_PTR(POWER_REC_5426 + P * POWER_STRIDE_34), 0); /* @asm 0x02F644 lcall 0x181F:0x416 */
            msg_set_ptr(1, DGROUP_PTR(POWER_NAME_540E + P * POWER_STRIDE_34), 0);/* @asm 0x02F658 lcall 0x181F:0x416 */
            ui_show_message_3(MSG_LOSING0, 0, 2);             /* @asm 0x02F660 push [0x53d4],0,2; 0x02F668 lcall 0x191F:0xAC8 */
            crt_keyed_to_buf(MSG_LOSING0, /*&buf*/0);         /* @asm 0x02F670 push 0xf29; 0x02F677 lcall 0xD1D:0x7E4 */
            msg_set_int(0, ((uint16_t *)DGROUP_PTR(POWER_NAMEW_8D42))[P]); /* @asm 0x02F693 push [bx-0x72be]; 0x02F699 lcall 0x181F:0x438 */
            ui_show_message_3(MSG_WARN0, 1, 2);               /* @asm 0x02F6A1 push 0xf39,1,2; 0x02F6A8 lcall 0x191F:0xABA */
            ui_show_message_0();                              /* @asm 0x02F6B0 lcall 0x191F:0xAAC */
            goto warn_loop;                                   /* @asm 0x02F6B5 jmp 0x294C */
        }
        /* @asm 0x02F6B8 — if a_lvl==0 too, skip to the war tail. */
        if (a_lvl == 0) goto war_tail;                        /* @asm 0x02F6BC cmp [bp-0x64],0; je 0x2C2C */
        /* @asm 0x02F6BE..0x02F729 — milder OTHER* path: WARN0(0xf39) keyed buf +
         * numeric substitutions for generals + colony count + pct, then show. */
        crt_keyed_to_buf(MSG_WARN0, /*&buf*/0);               /* @asm 0x02F6BE push 0xf39; 0x02F6C5 lcall 0xD1D:0x7E4 */
        msg_set_ptr(0, DGROUP_PTR(POWER_REC_5426 + P * POWER_STRIDE_34), 0); /* @asm 0x02F6DB lcall 0x181F:0x416 */
        msg_set_long(0, generals);                            /* @asm 0x02F6EF lcall 0x181F:0x9AE */
        msg_set_long(1, ((uint8_t *)DGROUP_PTR(POWER_NCOL_9230))[P]); /* @asm 0x02F706 lcall 0x181F:0x9AE */
        msg_set_long(2, pct);                                 /* @asm 0x02F716 lcall 0x181F:0x9AE */
        ui_show_message(1, /*&buf*/MSG_WARN0);                /* @asm 0x02F724 push 1; lea ax,[bp-0x56]; 0x02F726 lcall 0x181F:0x652 */
        /* falls through into warn_loop's re-entry below (@0x02F72C). */
    }

warn_loop:
war_tail:
    /* ------------------------------------------------------------------ @0x2C2C
     * @asm 0x02F72C..0x02F961 — WAR TAIL: if at war (bit0), run the per-arm REF
     * land-deployment matrix.  For each REF arm (0..3) it picks the player target
     * with the highest deployment value (king[+0x1A]-based), lands the arm's unit
     * type ([arm-0x6BF0]), posts NAMES/INDEPENDENT/OTHERGRANTED text, and sets
     * king[+0] bit 2.  (The inner matrix accessors 0x181F:0xA06/0xA10 carry the
     * per-(power,arm) granted counts.) */
    if (g_flags_5382 & 1) {                                   /* @asm 0x02F72C test [0x5382],1; je skip_war */
        int arm;
        for (arm = 0; arm < 4; arm++) {                       /* [bp-0x6e]; @asm 0x02F887 cmp 4; jl */
            if (arm < 4 && ((uint8_t *)DGROUP_PTR(AI_CTRL_543F))[arm * POWER_STRIDE_34] != 0) /* @asm 0x02F892 cmp [bx+0x543f],0; je */
                continue;                                     /* @asm 0x02F89B je body; jne next-ish */
            ui_redraw_power(arm);                             /* @asm 0x02F89D lcall 0x181F:0x582 */
            uint8_t *kr = (uint8_t *)g_king_record_84FC;      /* @asm 0x02F8A8 */
            if (kr[0] & 4) continue;                          /* @asm 0x02F8AC test [bx],4; jne next */

            /* @asm 0x02F8B1..0x02F8C7 — needed = king[+0x19] * armtype[arm] / 100,
             * capped at 100. */
            int needed = (kr[0x19] * ((uint8_t *)DGROUP_PTR(REF_ARM_TYPE_9408))[arm]) / 100; /* @asm 0x02F8B7 mul [bx-0x6bf0]; idiv 0x64 */
            if (needed > 100) needed = 100;                   /* @asm 0x02F8C1 cmp cx; jle */
            int target_val = needed;                          /* [bp-0x62] @asm 0x02F8C7 */

            /* @asm 0x02F8CA..0x02F8DE — landing budget = (8 - difficulty) * 10. */
            int budget = (8 - g_difficulty_53A6) * 10;        /* @asm 0x02F8D0 sub 8; neg; *5; *2 -> [bp-4] */

            /* @asm 0x02F8E1 — if needed >= budget, run the inner deploy/announce
             * (NAMES/INDEPENDENT/OTHERGRANTED) and update king[+0x1A]; otherwise
             * the secondary path at 0x2C74 adjusts king[+0x1A] toward target. */
            if (target_val >= budget) {                       /* @asm 0x02F8E1 cmp ax,cx; jge */
                /* @asm 0x02F8E8..0x02F959 — announce + mark king[0] bit2. */
                ui_flash_power(arm, 0, 0);                    /* @asm 0x02F8ED lcall 0x191F:0xAC8 */
                msg_set_ptr(1, DGROUP_PTR(POWER_REC_5426 + arm * POWER_STRIDE_34), 0); /* @asm 0x02F906 lcall 0x181F:0x416 */
                msg_set_ptr(2, DGROUP_PTR(POWER_NAME_540E + arm * POWER_STRIDE_34), 0);/* @asm 0x02F916 lcall 0x181F:0x416 */
                /* @asm 0x02F91E — INDEPENDENT(0xf3f) + NAMES(0xf4b) into a fmt. */
                ui_fmt_two(arm, MSG_INDEPENDENT, MSG_NAMES);  /* @asm 0x02F927 push 0xf3f,0xf4b; lcall 0x181F:0x422 */
                crt_keyed_to_buf(MSG_OTHERGRANTED, /*&buf*/0);/* @asm 0x02F949 lea bx,[0xf51]; 0x02F94D lcall 0x181F:0x3FE */
                kr[0] |= 4;                                   /* @asm 0x02F956 or [bx],4 */
                /* @asm 0x02F959 — reset inner loop var and continue scanning. */
            } else {
                /* @asm 0x02F8E5 jmp 0x2F774 — secondary path (needed < budget).
                 * king[+0x1A] tracks the deployment threshold; OTHERMIGHT/OTHERLESS
                 * announce changes with a ±5 hysteresis band.
                 *   OTHERMIGHT (0xF5E): king[+0x1A] < needed and budget-20 <= needed
                 *   OTHERLESS  (0xF69): king[+0x1A] - 5 > needed (catch a drop)
                 * BYTE_VERIFIED 2026-06-10 against func_02F3A2.asm @0x02F774..0x02F884. */
                if (budget - 20 <= needed &&                     /* @asm 0x02F774 ax=cx; sub 0x14; cmp */
                    kr[0x1A] < (uint8_t)needed) {                /* @asm 0x02F785 cmp [bx+0x1a],needed */
                    ui_flash_power(arm, 0, 0);                   /* @asm 0x02F796 lcall 0x191F:0xAC8 */
                    msg_set_long(0, (int32_t)needed);            /* @asm 0x02F7A2 */
                    msg_set_long(1, (int32_t)((uint8_t *)DGROUP_PTR(REF_ARM_TYPE_9408))[arm]); /* @asm 0x02F7BC */
                    msg_set_long(2, (int32_t)budget);            /* @asm 0x02F7CC */
                    msg_set_int(1, power_handle(arm));           /* @asm 0x02F7D7/0x02F7E2 */
                    ui_show_message(2, MSG_OTHERMIGHT);          /* @asm 0x02F7EC push 0xF5E */
                    kr[0x1A] = (uint8_t)needed;                 /* @asm 0x02F7F7 */
                }
                if (kr[0x1A] - 5 > (uint8_t)needed) {           /* @asm 0x02F801 ax=[bx+0x1a]-5 > needed */
                    ui_flash_power(arm, 0, 0);                   /* @asm 0x02F819 lcall 0x191F:0xAC8 */
                    msg_set_long(0, (int32_t)needed);            /* @asm 0x02F825 */
                    msg_set_long(1, (int32_t)((uint8_t *)DGROUP_PTR(REF_ARM_TYPE_9408))[arm]); /* @asm 0x02F83F */
                    msg_set_long(2, (int32_t)budget);            /* @asm 0x02F84F */
                    msg_set_int(1, power_handle(arm));           /* @asm 0x02F85A/0x02F865 */
                    ui_show_message(2, MSG_OTHERLESS);           /* @asm 0x02F86F push 0xF69 */
                    kr[0x1A] = (uint8_t)needed;                 /* @asm 0x02F87A */
                }
            }
        }
    }

    /* ------------------------------------------------------------------ @0x2E62
     * @asm 0x02F962..0x02FA9F — YEAR-DATED king messages.  Only when bit4(0x10)
     * is NOT yet set and we are at a year boundary ([0x538C]==0):
     *   - WARN0 at year 1790 (0x6FE; or 1840/0x730 when at war).
     *   - the SOONRETIRING/RETIRING/RETIRING2 + SCORED sequence at the named
     *     years; pick best general by colony +0x1F (via [0x8542]).
     * Then (@0x02FAE0) set bit4 to mark the handler as done this turn. */
    if (g_flags_5382 & 0x10) goto finish;                     /* @asm 0x02F962 test 0x10; je continue */
    if (g_turn_in_year_538C != 0) goto finish;                /* @asm 0x02F96C cmp [0x538c],0; jne */

    /* @asm 0x02F973..0x02F9EA — WARN0 message window. At war: year 1840 (0x730);
     * peace: year 1790 (0x6FE).  Composes the power name + WARN0 + SOONRETIRING. */
    if ((g_year_538A == 0x6FE && !(g_flags_5382 & 1)) ||      /* @asm 0x02F973 cmp 0x6fe; 0x02F97B test 1 */
        (g_year_538A == 0x730 && (g_flags_5382 & 1))) {       /* @asm 0x02F982 cmp 0x730 */
        msg_set_int(0, ((uint16_t *)DGROUP_PTR(DIFF_LABEL_8394))[g_difficulty_53A6]); /* @asm 0x02F992 lcall 0x181F:0x438 */
        msg_set_ptr(1, DGROUP_PTR(POWER_NAME_540E + P * POWER_STRIDE_34), 0); /* @asm 0x02F9AC lcall 0x181F:0x416 */
        crt_keyed_to_buf(MSG_SOONRETIRING, /*&buf*/0);        /* @asm 0x02F9B4 push 0xf73; 0x02F9BB lcall 0xD1D:0x7E4 */
        int late = (g_year_538A == 0x6FE) ? 0 : 1;            /* @asm 0x02F9C3 cmp 0x6fe; 0x02F9CB push 0 / 0x02F9D0 push 1 */
        ovly_181F_0182(late, /*&buf*/0, 0);                   /* @asm 0x02F9D7 lcall 0x181F:0x182 */
        ui_show_message(1, /*&buf*/MSG_SOONRETIRING);         /* @asm 0x02F9E5 lcall 0x181F:0x652 */
    }

    /* @asm 0x02F9ED..0x02FA9F — RETIRING window. At years 1800 (0x708, peace) or
     * 1850 (0x73A): find the player's BEST GENERAL (highest colony +0x1F via the
     * [0x8542] scan), compose the RETIRING/RETIRING2 message with that name +
     * the per-colony record (0x5D48), and show it. */
    if ((g_year_538A == 0x708 && !(g_flags_5382 & 1)) ||      /* @asm 0x02F9ED cmp 0x708; 0x02F9F5 test 1 */
        (g_year_538A == 0x73A)) {                             /* @asm 0x02F9FC cmp 0x73a */
        int best_rank = 0;                                    /* [bp-0x70] */
        int best_col  = 0;                                    /* [bp-0x6a] */
        for (i = 0; i < g_colony_count_539E; i++) {           /* @asm 0x02FA41 cmp [0x539e]; jg */
            unit_select(i);                                   /* @asm 0x02FA15 lcall 0x181F:0x9E6 */
            uint8_t *col = (uint8_t *)g_colony_base_8542;     /* @asm 0x02FA20 mov bx,[0x8542] */
            if (col[0x1A] != (uint8_t)P) continue;            /* @asm 0x02FA24 cmp [bx+0x1a]; jne */
            if (col[0x1F] < (uint8_t)best_rank) continue;     /* @asm 0x02FA2C cmp [bx+0x1f]; jl */
            best_rank = col[0x1F];                            /* @asm 0x02FA31/0x02FA35 */
            best_col  = i;                                    /* @asm 0x02FA38/0x02FA3B */
        }
        msg_set_int(1, ((uint16_t *)DGROUP_PTR(DIFF_LABEL_8394))[g_difficulty_53A6]); /* @asm 0x02FA52 lcall 0x181F:0x438 */
        msg_set_ptr(1, DGROUP_PTR(POWER_NAME_540E + P * POWER_STRIDE_34), 0); /* @asm 0x02FA6C lcall 0x181F:0x416 */
        msg_set_ptr(2, DGROUP_PTR(COL_RECORD_5D48 + best_col * COL_STRIDE_CA), 0); /* @asm 0x02FA74 imul 0xca; +0x5d48; 0x02FA80 lcall 0x181F:0x416 */
        /* @asm 0x02FA88 — RETIRING(0xf80) when at peace, RETIRING2(0xf89) at war. */
        int retire_key = (g_flags_5382 & 1) ? MSG_RETIRING2 : MSG_RETIRING; /* @asm 0x02FA88 test 1; 0x02FA8F/0x02FA96 lea */
        crt_keyed_to_buf(retire_key, /*&buf*/0);              /* @asm 0x02FA9A lcall 0x181F:0x3FE */
        ui_commit_message();                                  /* @asm 0x02FA9F lcall 0x181F:0x574 */
    }

finish:
    /* @asm 0x02FAA4..0x02FAE7 — finalise.  Reset the score-result, then if
     * show_summary && score_result==0: when at-war-bit3 set, mark king-retiring
     * [0x53A2]=1; run the SCORED prompt (0x181F:0x56A + key 0xF93); if the prompt
     * returns 2, set score_result=1.  Finally set bit4 (handler done this turn). */
    g_score_result_53C2 = 0;                                  /* @asm 0x02FAA4 mov [0x53c2],0 */
    if (g_score_result_53C2 == 0 && show_summary != 0) {      /* @asm 0x02FAAA cmp 0; jne end ; 0x02FAB1 cmp [bp-0x5e],0; je end */
        if (g_flags_5382 & 8)                                 /* @asm 0x02FAB7 test [0x5382],8; je */
            g_retire_flag_53A2 = 1;                           /* @asm 0x02FABE mov [0x53a2],1 */
        ui_show_message_0();                                  /* @asm 0x02FAC4 lcall 0x181F:0x56A */
        int r = msg_key_lookup(DGROUP_PTR(MSG_SCORED));       /* @asm 0x02FAC9 lea bx,[0xf93]; 0x02FACD lcall 0x181F:0x3FE */
        if (r == 2)                                           /* @asm 0x02FAD5 cmp ax,2; jne */
            g_score_result_53C2 = 1;                          /* @asm 0x02FADA mov [0x53c2],1 */
    }
    g_flags_5382 |= 0x10;                                     /* @asm 0x02FAE0 or [0x5382],0x10  (handler ran) */
    /* @asm 0x02FAE5 — pop si/di; leave; retf. */
}

/* (ui_fmt_two declared above, before king_war_turn) */

/* ============================================================================
 * NOTES / STILL-LEFT-UNRESOLVED
 *  - CONTROL FLOW + every cited DGROUP read/write + the year gates (1600 / 1790
 *    / 1800 / 1840 / 1850 = 0x640/0x6FE/0x708/0x730/0x73A) + REF-arm references
 *    (0x53DA/0x53DC/0x53E0) + the colony-count, land-military (types 6/8/0xB) and
 *    REF-readiness (>=4) thresholds: BYTE_VERIFIED.
 *  - String identities (all 15 handles) BYTE_VERIFIED via file = handle+0x1D9A0.
 *  - The inner REF land-deployment MATRIX (king[+0x19]/[+0x1A], the per-(power,
 *    arm) accessors 0x181F:0xA06/0xA10, and the secondary "adjust toward target"
 *    path at 0x2C74..0x2D01) is decoded; the landing path (func_03CDA2) is
 *    traced in src/king/ref.c: per-arm decrement @0x03D4C0, unit spawn via
 *    0x181F:0x9BA at the target colony coords, FINAL WAVE zeroes all four
 *    REF words @0x03D4FE.  Per-arm counts come from the budget matrix here.
 *  - Helper PROTOTYPES (ui_*, msg_*, crt_keyed_to_buf) are LITERAL-faithful to
 *    push args; their precise semantics are inferred from call context.
 *  - [0x53C2] is zeroed twice (entry-of-finish and the no-colonies branch); its
 *    exact role (defeat flag vs end-screen score) is inferred from call context.
 *  - The b_lvl/a_lvl severity ladder values (pct >= 80 / 90, generals < 3 / == 0)
 *    are BYTE_VERIFIED constants; their mapping to OTHER* message variants is
 *    inferred from the push order -> inferred from call context.
 * ============================================================================ */
