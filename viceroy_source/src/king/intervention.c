/* ============================================================================
 *        >>> FOREIGN INTERVENTION event (War of Independence) — BYTE_VERIFIED <<<
 * ----------------------------------------------------------------------------
 * When the rebel player is at war with the king, a sympathetic European power
 * intervenes on the rebels' side.  This routine picks the player's "best"
 * colony (the one with the highest value of colony-field +0x1F among colonies
 * flagged 0x40), spawns the intervention force there, announces it, and sets
 * the global "intervention has occurred" flag.
 *
 * Identified by STRING XREF (decisive): the two message handles pushed resolve
 * through the load-image string table (file = handle + 0x1D9A0):
 *     handle 0x12D4 -> file 0x1EC74 = "FRIEND"
 *     handle 0x12DB -> file 0x1EC7B = "INTERVENTION"
 *
 * @asm_function  func_03D948   (file 0x03D948..0x03DA28, 225 bytes, RETF)
 * @asm_disasm    disasm_overlay_reseg/page_06.asm  (page 0x06, code_base 0x03B380)
 * @verified_by   Hand-decompiled 2026-05-30; prologue, the INTERVENTION push,
 *                and the flag-set were spot-checked against COLONIZE/VICEROY.EXE:
 *                  0x03D948: C8 06 00 00          enter 6,0
 *                  0x03DA1A: 68 DB 12             push 0x12DB (INTERVENTION)
 *                  0x03DA22: 80 0E 82 53 02       or byte [0x5382], 2
 * ============================================================================ */
#include "viceroy_types.h"

/* ----------------------------------------------------------------------------
 * DGROUP globals (addresses BYTE_VERIFIED from operands).
 * ---------------------------------------------------------------------------- */
extern uint8_t g_active_power_5398;   /* DGROUP:0x5398 — active/human power index (byte read here) */
extern void *  g_colony_base_8542;    /* DGROUP:0x8542 — far ptr to the "current colony" struct
                                       *   (project memory: VICEROY *(0x8542) is the colony struct) */
extern int16_t g_colony_count_539E;   /* DGROUP:0x539E — number of colonies */
extern int16_t g_unit_count_539C;     /* DGROUP:0x539C — number of units (unused in the kept path) */
extern int16_t g_intervene_target_53D4; /* DGROUP:0x53D4 — chosen intervention power/handle */
extern uint8_t g_flags_5382;          /* DGROUP:0x5382 — global event flags; bit1 set = "intervention done" */

/* Colony-struct field offsets (BYTE_VERIFIED from the [bx+off] operands; the
 * colony stride is 0xCA = 202, project-confirmed). */
#define COL_OWNER_1A    0x1A    /* @asm 0x03D96E cmp byte [bx+0x1a], al  ; owner == active power */
#define COL_RANK_1F     0x1F    /* @asm 0x03D98B mov al, byte [bx+0x1f]  ; ranked attribute (size?) */
#define COL_STRIDE      0xCA    /* colony stride 202 */

/* A per-colony flag table at DGROUP:0x5D62 (stride 0xCA): bit 0x40 marks the
 * colonies eligible to host the intervention.
 * @asm 0x03D973 imul bx,[bp-6],0xCA ; 0x03D978 test byte [bx+0x5d62],0x40 */
#define COL_FLAG_TABLE_5D62  0x5D62
#define COL_FLAG_INTERVENE   0x40

/* Per-colony record table at DGROUP:0x5D48 (stride 0xCA) — the spawn target the
 * intervention force is attached to.
 * @asm 0x03D9ED imul ax,[bp-2],0xCA ; 0x03D9F2 add ax,0x5D48 ; push ds; push ax */
#define COL_RECORD_TABLE_5D48  0x5D48

/* lcall / overlay helpers (call sites + args verified; internals body in thunk page).
 *   0x181F:0x09E6 -> file 0x2701C (type B) — select/activate colony by index.
 *   0x181F:0x04AC -> file 0x22340 (type B) — set UI/animation channel mode.
 *   0x191F:0x0AC8 -> file 0x25D04 (type A) — flash/redraw a power's UI.
 *   0x181F:0x0422 -> file (type A)         — blit/draw helper (coords).
 *   0x181F:0x0416 -> file (type A)         — blit/draw helper (ptr).
 *   0x181F:0x09A4 -> file 0x5FE0C (type B) — power index -> handle.
 *   0x181F:0x0438 -> file 0x25CEC (type A) — per-power state setter (handle, flag).
 *   0x181F:0x0652 -> file 0x290A2 (type A) — show localized message by handle. */
extern void    colony_select(int colony_idx);              /* 0x181F:0x09E6 */
extern void    ui_set_channel(int mode);                   /* 0x181F:0x04AC */
extern void    ui_flash_power(int power, int a, int b);    /* 0x191F:0x0AC8 */
/* NB: args below are listed in PUSH ORDER (first-pushed first); the true
 * left-to-right parameter order/semantics of these helpers are inferred from call context. */
extern void    ui_blit_coords(int a0, int a1, int a2);     /* 0x181F:0x0422 */
extern void    ui_blit_ptr(int a0, void *a1, int a2);      /* 0x181F:0x0416 */
extern int     power_handle(int power_idx);                /* 0x181F:0x09A4 */
extern void    power_set_flag(int handle, int flag);       /* 0x181F:0x0438 */
extern void    ui_show_message(int channel, int msg_handle); /* 0x181F:0x0652 */

/* Resolved message handles (file = handle + 0x1D9A0 — BYTE_VERIFIED). */
#define MSG_FRIEND        0x12D4   /* -> "FRIEND"       @ file 0x1EC74 */
#define MSG_INTERVENTION  0x12DB   /* -> "INTERVENTION" @ file 0x1EC7B */

/* ============================================================================
 * foreign_intervention — func_03D948 — BYTE_VERIFIED (control flow + writes)
 *
 * Selects the active power's highest-ranked (+0x1F) eligible (flag 0x40) colony,
 * spawns the intervention force there, runs the announcement (FRIEND/
 * INTERVENTION), and sets [0x5382] bit1.
 * ============================================================================ */
void foreign_intervention(void)
{
    int best_idx = -1;        /* [bp-2] — chosen colony index */
    int best_rank = 0xFFFF;   /* [bp-4] — running max of +0x1F (init 0xFFFF) */
    int i;                    /* [bp-6] — loop var */

    /* @asm 0x03D959..0x03D9A1 — scan all colonies for the active power's
     * eligible colony with the largest +0x1F. */
    for (i = 0; i < g_colony_count_539E; i++) {            /* @asm 0x03D99B cmp [bp-6],[0x539e] */
        colony_select(i);                                 /* @asm 0x03D95F lcall 0x181F:0x9E6 */

        /* @asm 0x03D967 — colony owner ([bx+0x1a]) must be the active power. */
        {
            uint8_t *col = (uint8_t *)g_colony_base_8542;
            if (col[COL_OWNER_1A] != g_active_power_5398)  /* @asm 0x03D96E cmp [bx+0x1a],al */
                continue;                                  /* @asm 0x03D971 jne next */
        }

        /* @asm 0x03D973 — colony must carry the intervention-eligible flag. */
        {
            uint8_t *flags = (uint8_t *)COL_FLAG_TABLE_5D62;
            if (!(flags[i * COL_STRIDE] & COL_FLAG_INTERVENE)) /* @asm 0x03D978 test ...,0x40 */
                continue;                                  /* @asm 0x03D97D je next */
        }

        /* @asm 0x03D97F — keep the colony with the highest +0x1F.  NB the test
         * is an 8-bit SIGNED `cmp [bx+0x1f], al; jle` (al = best_rank low byte);
         * strictly-greater wins, and with the 0xFFFF (≡ −1) init the first
         * eligible colony always passes. */
        {
            uint8_t *col = (uint8_t *)g_colony_base_8542;
            int rank = col[COL_RANK_1F];                   /* @asm 0x03D98B mov al,[bx+0x1f] */
            if (rank <= best_rank) continue;               /* @asm 0x03D986 cmp [bx+0x1f],al; jle */
            best_rank = rank;                              /* @asm 0x03D98F mov [bp-4],ax */
            best_idx  = i;                                 /* @asm 0x03D995 mov [bp-2],ax */
        }
    }

    /* @asm 0x03D9A3 — channel = 3 (intervention animation). */
    ui_set_channel(3);                                     /* @asm 0x03D9A5 lcall 0x181F:0x4AC */

    /* @asm 0x03D9AD..0x03D9CA — flash both the intervening power and the
     * active(rebel) power's UI. */
    ui_flash_power(g_intervene_target_53D4, 1, 0);         /* @asm 0x03D9B5 lcall 0x191F:0xAC8 */
    ui_flash_power(g_active_power_5398, 0, 1);             /* @asm 0x03D9C5 lcall 0x191F:0xAC8 */

    /* @asm 0x03D9CD..0x03DA15 — draw the intervention force onto the chosen
     * colony (blit helpers using [0x53d4], the FRIEND label @0x12D4, the colony
     * record at 0x5D48 + best_idx*0xCA, and tag the target power via
     * power_set_flag(power_handle([0x53d4]), 4)). */
    ui_blit_coords(g_intervene_target_53D4, MSG_FRIEND, 0x87C); /* @asm 0x03D9D7 lcall 0x181F:0x422 */
    {
        void *col_rec = DGROUP_PTR(COL_RECORD_TABLE_5D48 + best_idx * COL_STRIDE);
        ui_blit_ptr(2, DGROUP_PTR(0x833C), 0);             /* @asm 0x03D9E5 lcall 0x181F:0x416 (ptr 0x833C) */
        ui_blit_ptr(3, col_rec, 0);                        /* @asm 0x03D9F9 lcall 0x181F:0x416 (colony rec) */
    }
    power_set_flag(power_handle(g_intervene_target_53D4), 4); /* @asm 0x03DA10 lcall 0x181F:0x438 (flag 4) */

    /* @asm 0x03DA18 — announce "INTERVENTION". */
    ui_show_message(1, MSG_INTERVENTION);                  /* @asm 0x03DA1A push 0x12DB; lcall 0x181F:0x652 */

    /* @asm 0x03DA22 — set the global "intervention has happened" flag (bit 1). */
    g_flags_5382 |= 2;                                     /* @asm 0x03DA22 or byte [0x5382],2 */
}

/* ============================================================================
 * NOTES / STILL left unresolved
 *  - WHICH European power intervenes ([0x53D4]) and the SIZE/composition of the
 *    intervention force are set up by the CALLER (not located) — not yet decoded.
 *  - colony fields +0x1A (owner) and +0x1F (ranked attribute) are BYTE_VERIFIED
 *    addresses; +0x1F's exact meaning (colony size? rebel sentiment?) is inferred
 *    as "size/rank" and marked left unresolved.
 *  - The 0x5D62 (flag) and 0x5D48 (record) per-colony tables are verified by the
 *    stride-0xCA indexing; their full layout is documented in the colony module.
 *  - ui_blit_* / ui_flash_power arg semantics (the literal 1/0/2/3 selectors)
 *    are literal-verified but their meaning is inferred from call context.
 *  - DGROUP_PTR() (from viceroy_types.h) wraps a 16-bit DGROUP offset as a near
 *    data pointer — these tables are DS-relative in the 16-bit original.
 * ============================================================================ */
