/* ============================================================================
 *      >>> SONS OF LIBERTY membership update + REBELUP/REBELDOWN — BYTE_VERIFIED <<<
 * ----------------------------------------------------------------------------
 * Per-power Sons-of-Liberty (rebel sentiment) recompute + milestone announcer.
 * Identified by STRING XREF (decisive): the three message handles this function
 * pushes resolve through the load-image string table (file = handle + 0x1D9A0):
 *     handle 0x1358 -> file 0x1ECF8 = "REBELUP50"
 *     handle 0x1362 -> file 0x1ED02 = "REBELUP"
 *     handle 0x136A -> file 0x1ED0A = "REBELDOWN"
 * (handle->file relation byte-verified from treaty.c's SIGNTREATY 0x188d->0x1F22D
 *  and confirmed here against VICEROY.EXE raw bytes.)
 *
 * @asm_function  func_03E844   (file 0x03E844..0x03E982, 319 bytes, RETF)
 * @asm_disasm    disasm_overlay_reseg/page_06.asm  (page 0x06, code_base 0x03B380;
 *                IP = file - 0x03B380)
 * @verified_by   Hand-decompiled 2026-05-30 from the re-segmented overlay dump;
 *                prologue, the PowerRecord write, and the REBELUP50 push were
 *                spot-checked byte-for-byte against COLONIZE/VICEROY.EXE:
 *                  0x03E844: C8 12 00 00          enter 0x12,0
 *                  0x03E8AA: 88 87 21 88          mov [bx-0x77df], al
 *                  0x03E91C: 68 58 13             push 0x1358 (REBELUP50)
 * ============================================================================ */
#include "viceroy_types.h"
#include "power.h"

/* ----------------------------------------------------------------------------
 * DGROUP globals (addresses BYTE_VERIFIED from the operands).
 * ---------------------------------------------------------------------------- */
extern int16_t g_active_power_5398;   /* DGROUP:0x5398 — human/active power index
                                       *   (cross-confirmed: intervention.c, func_03DE46) */
extern uint8_t g_flags_5382;          /* DGROUP:0x5382 — global event flag byte;
                                       *   bit0 = revolution/War-of-Independence in progress */
extern int16_t g_rebel_power_53D2;    /* DGROUP:0x53D2 — index of a special power that
                                       *   crossed the 50% SoL line (the "rebel"/USA slot);
                                       *   −1 until set (see func_03DE46 @0x03DE7E read). */
extern int16_t g_sol_value_53D0;      /* DGROUP:0x53D0 — scratch: this power's freshly
                                       *   computed rebel% (0..100). */
extern int16_t g_sol_prev10_53D8;     /* DGROUP:0x53D8 — last announced rebel% in units
                                       *   of 10 (prev/10); used for milestone edges. */

/* PowerRecord far base is DGROUP:0x8808 (stride 0x13C). −0x77DF ≡ +0x8821 =
 * PowerRecord + 0x19, the per-power rebel%/SoL byte this routine stores. */
#define POWER_BASE_8808     0x8808
#define POWER_STRIDE        0x13C
#define POWER_SOL_PCT_OFF   0x19      /* @asm -0x77DF -> +0x8821 -> PowerRecord+0x19 */

/* Per-power accumulated colonial-strength score table DGROUP:0x9410 — BYTE_VERIFIED 2026-06-08.
 * Compact byte array (stride 1, NOT 0x13C): DS[0x9410 + power_idx].
 *
 * @asm 0x03E8D0: cmp byte [bx-0x6bf0], 4   ; HERE bx = raw power_idx (NOT power*0x13C)
 *   −0x6BF0 ≡ +0x9410 (unsigned 16-bit), so [bx-0x6BF0] = DS[0x9410 + power_idx].
 *
 * The field is ZEROED at turn-start (@asm 0x03FD5D) then rebuilt by a per-power
 * statistics-recount function (func_03FD38, 1518 B):
 *   Write 1 (0x03FEBC): += 1 for each colonist in/adjacent to a colony
 *             (via lcall 0x181F:0xB78 "entity in colony?" predicate)
 *   Write 2 (0x040251): += entity[+0x1F] (colony population byte, 0..32 cap) per owned entity
 * Net effect: accumulated total colonist count (popsum) across all of a power's colonies.
 *
 * Thresholds (BYTE_VERIFIED from the recount function's callers):
 *   >= 4: display SoL milestone messages (this site, @0x03E8D0)
 *   >= 8: affects cavalry event probability + military outcomes (@0x055FFA, @0x05F450)
 * Parameter 1 in OTHERMIGHT/OTHERLESS messages (displayed to player as "opposing strength"). */
#define POWER_GATE_9410     0x9410   /* @asm -0x6BF0 -> +0x9410, stride 1 (compact array) */

/* Near-call thunk trampolines inside page 0x06 (each is an `ljmp` to a far
 * overlay/load-image routine; internals TBD, call sites verified):
 *   cs:0x368B -> ljmp 0x191F:0x364   (set/flag the 50%-crossed power)   @0x03EA0B
 *   cs:0x3695 -> ljmp 0x1A1F:0x07E                                       @0x03EA15
 *   cs:0x36CC -> ljmp 0x1A1F:0x126   (rebel% recompute, "below 50" path) @0x03EA4C
 *   cs:0x36D1 -> ljmp 0x1A1F:0x134   (rebel% recompute, returns AL=pct)  @0x03EA51 */
extern void    sol_mark_rebel_power(void);          /* cs:0x368B  TBD internals */
extern void    sol_helper_3695(int power);          /* cs:0x3695  TBD internals */
extern void    sol_recompute_lowpath(int power);    /* cs:0x36CC  TBD internals */
extern uint8_t sol_recompute_pct(int power);        /* cs:0x36D1  -> rebel% in AL  */

/* lcall helpers (call sites + args verified; internals TBD).
 *   0x181F:0x04AC -> file 0x22340 (type B) — set a UI/animation channel mode.
 *   0x181F:0x09AE -> file 0x25D2C (type A) — push a numeric value for a message.
 *   0x191F:0x0AC8 -> file 0x25D04 (type A) — flash/redraw a power's colony UI.
 *   0x181F:0x0652 -> file 0x290A2 (type A) — show localized message by handle. */
extern void    ui_set_channel(int mode);                       /* 0x181F:0x04AC */
extern void    ui_push_value(int32_t v);                       /* 0x181F:0x09AE */
extern void    ui_flash_power(int power, int a, int b);        /* 0x191F:0x0AC8 */
extern void    ui_show_message(int channel, int msg_handle);   /* 0x181F:0x0652 */

/* Resolved message handles (file = handle + 0x1D9A0 — BYTE_VERIFIED mapping). */
#define MSG_REBELUP50   0x1358    /* -> "REBELUP50"  @ file 0x1ECF8 */
#define MSG_REBELUP     0x1362    /* -> "REBELUP"    @ file 0x1ED02 */
#define MSG_REBELDOWN   0x136A    /* -> "REBELDOWN"  @ file 0x1ED0A */

static inline uint8_t *sol_pct_cell(int power)
{
    uint8_t *base = (uint8_t *)POWER_BASE_8808;
    return base + (unsigned)power * POWER_STRIDE + POWER_SOL_PCT_OFF;
}

/* ============================================================================
 * sons_of_liberty_update — func_03E844 — BYTE_VERIFIED (control flow + writes)
 *
 * Recomputes one power's Sons-of-Liberty percentage, stores it in
 * PowerRecord+0x19, and — only for the human/active power, and only once the
 * revolution flag is set — announces a milestone when the rounded-to-10%
 * membership crosses up (REBELUP / REBELUP50 at the 50 line) or down
 * (REBELDOWN).  The "_53D8" latch (prev pct / 10) makes each 10-point band emit
 * its message exactly once.
 *
 * @param power_id  == [bp+6]
 * ============================================================================ */
void sons_of_liberty_update(int power_id)
{
    /* @asm 0x03E848..0x03E866 — decide `is_rebel_view` ([bp-2]):
     *   set 1 if power_id == active power, OR (revolution flag set AND
     *   power_id == g_rebel_power_53D2); else 0. */
    int is_rebel_view;
    if (power_id == g_active_power_5398) {                 /* @asm 0x03E84B je */
        is_rebel_view = 1;                                 /* @asm 0x03E85F */
    } else if ((g_flags_5382 & 1) &&                       /* @asm 0x03E850 test [0x5382],1 */
               power_id == g_rebel_power_53D2) {           /* @asm 0x03E85A cmp [0x53D2] */
        is_rebel_view = 1;                                 /* @asm 0x03E85F */
    } else {
        is_rebel_view = 0;                                 /* @asm 0x03E866 */
    }

    /* @asm 0x03E86B — if revolution NOT yet declared, skip the "low path"
     * branching and just recompute+store (jump to the common store at 0x3508). */
    if (g_flags_5382 & 1) {                                /* @asm 0x03E86B test [0x5382],1 */
        /* @asm 0x03E872 — during the revolution: if this isn't a rebel view,
         * bail entirely (no recompute for non-participants). */
        if (!is_rebel_view) return;                        /* @asm 0x03E876 jne / 0x03E878 -> 0x3601 */
        /* @asm 0x03E87B — rebel view during revolution: low-path recompute then
         * RETURN (the milestone announcer below is for the pre-revolution game). */
        sol_recompute_lowpath(power_id);                   /* @asm 0x03E87F call 0x36CC */
        return;                                            /* @asm 0x03E886 retf */
    }

    /* ----- pre-revolution path ----- */
    /* @asm 0x03E888 — if rebel view, run the alternate recompute helper first. */
    if (is_rebel_view)                                     /* @asm 0x03E88C je */
        sol_helper_3695(power_id);                         /* @asm 0x03E892 call 0x3695 */

    /* @asm 0x03E898 — recompute rebel% -> AL, kept in [bp-0xE]. */
    uint8_t pct = sol_recompute_pct(power_id);             /* @asm 0x03E89C call 0x36D1 */

    /* @asm 0x03E8A5 — store rebel% into PowerRecord[power]+0x19. */
    *sol_pct_cell(power_id) = pct;                         /* @asm 0x03E8AA mov [bx-0x77df],al */

    /* @asm 0x03E8AE — non-rebel-view powers: store only, no announcement. */
    if (!is_rebel_view) return;                            /* @asm 0x03E8B2 jne / 0x03E8B4 -> 0x3601 */

    /* @asm 0x03E8B7 — publish this power's pct to the scratch global. */
    g_sol_value_53D0 = pct;                                /* @asm 0x03E8BA mov [0x53D0],ax */

    /* @asm 0x03E8BD — first time this power reaches 50% while no rebel power has
     * been designated yet, mark it as the rebel/USA power. */
    if (pct >= 0x32 && g_rebel_power_53D2 < 0)             /* @asm 0x03E8C0 jl / 0x03E8C2 cmp [0x53D2],0 */
        sol_mark_rebel_power();                            /* @asm 0x03E8CA call 0x368B */

    /* @asm 0x03E8CD — gate: only announce for a power whose accumulated colonial-strength
     * score (DS[0x9410+power], = total colonist popsum) is >= 4. Else just return. */
    {
        const uint8_t *gate = (const uint8_t *)POWER_GATE_9410;
        if (gate[(unsigned)power_id] < 4)                  /* @asm 0x03E8D0 cmp [bx-0x6bf0],4  (bx=power_id, stride 1) */
            return;                                        /* @asm 0x03E8D5 jae / 0x03E8D7 -> 0x3601 */
    }

    /* @asm 0x03E8DA — milestone test (UP edge): if (pct/10) > prev10 announce up. */
    if (g_sol_value_53D0 / 10 > g_sol_prev10_53D8) {       /* @asm 0x03E8E3 cmp ax,[0x53D8]; jle down */
        ui_set_channel(3);                                 /* @asm 0x03E8EB lcall 0x181F:0x4AC (push 3) */
        ui_push_value(g_sol_value_53D0);                   /* @asm 0x03E8FB lcall 0x181F:0x9AE */
        ui_flash_power(g_active_power_5398, 0, 0);         /* @asm 0x03E90B lcall 0x191F:0xAC8 */
        /* @asm 0x03E913 — at/over 50%? REBELUP50, else REBELUP. */
        if (g_sol_value_53D0 >= 0x32)                      /* @asm 0x03E918 jl */
            ui_show_message(1, MSG_REBELUP50);             /* @asm 0x03E91C push 0x1358 */
        else
            ui_show_message(1, MSG_REBELUP);               /* @asm 0x03E924 push 0x1362 */
        /* @asm 0x03E92F jmp 0x35F5 -> latch update */
    } else {
        /* @asm 0x03E932 — DOWN edge: if ((pct+4)/10) >= prev10, no message. */
        if ((g_sol_value_53D0 + 4) / 10 >= g_sol_prev10_53D8)  /* @asm 0x03E93B cmp; jge 0x3601 */
            return;                                        /* @asm 0x03E93F retf (via 0x3601) */
        ui_set_channel(1);                                 /* @asm 0x03E943 lcall 0x181F:0x4AC (push 1) */
        ui_push_value(g_sol_value_53D0);                   /* @asm 0x03E953 lcall 0x181F:0x9AE */
        ui_flash_power(g_active_power_5398, 0, 0);         /* @asm 0x03E963 lcall 0x191F:0xAC8 */
        ui_show_message(1, MSG_REBELDOWN);                 /* @asm 0x03E96D push 0x136A */
    }

    /* @asm 0x03E975 — latch prev10 = current pct / 10 (so each band fires once). */
    g_sol_prev10_53D8 = g_sol_value_53D0 / 10;             /* @asm 0x03E97E mov [0x53D8],ax */
}

/* ============================================================================
 * NOTES
 *  - The PowerRecord+0x19 SoL-byte offset is BYTE_VERIFIED from the write
 *    operand (−0x77DF).
 *  - POWER_GATE_9410 ">= 4" gate: BYTE_VERIFIED 2026-06-08 (see define above).
 *    Stride is 1 (compact byte array); "bx = power*0x13C" in the original comment
 *    was WRONG — bx = raw power_idx here. Values = total colonist popsum.
 *  - sol_recompute_pct / sol_recompute_lowpath / sol_helper_3695 are RTLink
 *    thunks (ljmp into 0x1A1F:...) — the actual rebel% arithmetic lives in those
 *    targets and is NOT byte-traced here (TBD).  This routine is the *driver*
 *    and announcer; the arithmetic is a separate target.
 *  - The numeric channel ids passed to ui_set_channel (3 vs 1) and the third/
 *    fourth args of ui_flash_power are literal-verified but their semantics TBD.
 * ============================================================================ */
