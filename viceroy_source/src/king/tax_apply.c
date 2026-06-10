/* ============================================================================
 *        >>> APPLY TAX CHANGE + CAP-AT-75 + BOYCOTT — core BYTE_VERIFIED <<<
 * ----------------------------------------------------------------------------
 * Applies a signed tax delta to the king's current tax rate (PowerRecord+0x01),
 * clamping the result into [.., 75].  This is the routine that actually mutates
 * the tax rate after the player accepts a raise (func_034AE0 in king_tax_raise.c)
 * or refuses (Boston Tea Party).  When the rate is changed, it then iterates the
 * 16 commodity slots and updates the per-good boycott state from the king
 * record's boycott bitmask (PowerRecord+0x20) and the market price table at
 * DGROUP:0x5DE0.
 *
 * @asm_function  func_034318   (file 0x034318..0x03471D, ENTER 0xCE frame)
 * @asm_disasm    disasm/func_034318.asm  (344 lines, complete; RETF at 0x03471D)
 * @verified_by   Hand-decompiled 2026-05-30 (core) and 2026-06-10 (full boycott
 *                tail); the apply + cap-75 instructions were spot-checked byte-
 *                for-byte against COLONIZE/VICEROY.EXE:
 *                  0x034318: C8 CE 00 00          enter 0xCE,0
 *                  0x03434C: 00 47 01             add byte [bx+1], al
 *                  0x03434F: 80 7F 01 4B          cmp byte [bx+1], 0x4B   ; cap=75
 *                  0x034717: 09 47 20             or  word [bx+0x20], ax   ; boycott SET
 * @ref  src/king/king_tax_raise.c   (func_034AE0 — the raise/lower DECISION)
 * @ref  FUNCTION_INVENTORY.md       ("func_034318 — Tea Party / tax application")
 * ============================================================================ */
#include "viceroy_types.h"

extern void *  g_king_record_84FC;     /* DGROUP:0x84FC — far ptr to king PowerRecord */
extern int16_t g_active_power_9E12;    /* DGROUP:0x9E12 — active power index */
extern uint8_t g_ai_personality_543F[];/* DGROUP:0x543F — controller byte, stride 0x34 (0=human) */

/* PowerRecord field offsets used here (BYTE_VERIFIED from operands). */
#define KING_TAX_RATE_OFF   0x01    /* @asm [bx+1]    — current tax %, capped at 0x4B */
#define KING_BOYCOTT_MASK   0x20    /* @asm [bx+0x20] — 16-bit boycotted-goods bitmask (word) */
#define KING_PRICE_BC       0xBC    /* @asm [bx+di+0xbc] dword — per-good EU price/supply */
#define TAX_CAP             0x4B    /* @asm 0x03434F cmp [bx+1],0x4b — hard cap = 75% */

/* Market price table at DGROUP:0x5DE0 (stride 0x65 words per power-block, 16
 * goods): @asm 0x034428 imul bx,[bp-0xcc],0x65 ; +good*2 ; cmp [bx+0x5de0],ax */
#define MARKET_PRICE_5DE0   0x5DE0
#define MARKET_BLOCK_STRIDE 0x65

/* lcall helpers (call sites + args verified; internals in thunk page):
 *   0xD1D:0xDDC / 0xD1D:0xEC6 -> C runtime long-arith helpers (mul/div on the
 *     +0xBC/+0xBE price dwords).  0xD1D is the C library overlay.
 *     0xD1D:0xEC6 = __aFldiv-style 32-bit long divide (confirmed in diplomacy/meeting.c). */
extern int32_t crt_lmul(int32_t a, int32_t b);   /* 0xD1D:0xDDC (approx) */
extern int32_t crt_aFldiv(int32_t a, int32_t b); /* 0xD1D:0xEC6 = __aFldiv 32-bit long divide */

/* ============================================================================
 * tax_apply_delta — func_034318 — core BYTE_VERIFIED
 *
 * Applies a signed tax delta to king[+1], clamps the lower path so it can't go
 * below 0, and caps the result at 75%.  NB this is a DISTINCT function from the
 * `apply_tax_change` referenced in king_tax_raise.c (that one is the near CALL
 * at 0x35418 = func_0353DE — a different routine); do not conflate them.
 *
 * @param delta  signed tax change ([bp+8]).  Positive = raise, negative = the
 *               Tea-Party "lower" path.
 * ============================================================================ */
void tax_apply_delta(int delta)
{
    uint8_t *king = (uint8_t *)g_king_record_84FC;

    /* @asm 0x03431E..0x034342 — normalise the lower path:
     *   if delta < 0:  mag = -delta (NOT al; INC al = two's complement)
     *                  if mag > current_tax:  delta = -(current_tax)   ; clamp
     *   (a positive delta passes through unchanged.) */
    if (delta < 0) {                                       /* @asm 0x034322 jge skip */
        int8_t mag = (int8_t)(~(uint8_t)delta + 1);        /* @asm 0x03432F not al; 0x034331 inc al */
        if (mag > (int8_t)king[KING_TAX_RATE_OFF]) {       /* @asm 0x034337 cmp al,[bx+1]; jle */
            delta = -(int8_t)king[KING_TAX_RATE_OFF];      /* @asm 0x034340 neg ax -> [bp+8] */
        }
    }

    /* @asm 0x034345..0x03434C — apply the (clamped) delta to the tax rate. */
    king[KING_TAX_RATE_OFF] = (uint8_t)(king[KING_TAX_RATE_OFF] + (int8_t)delta); /* @asm 0x03434C add [bx+1],al */

    /* @asm 0x03434F..0x03436B — HARD CAP at 75%: if the new rate exceeds 75,
     * clamp to 75 and credit the overflow back into `delta` (so the caller's
     * notion of "how much actually changed" stays consistent). */
    if ((int8_t)king[KING_TAX_RATE_OFF] > TAX_CAP) {       /* @asm 0x03434F cmp [bx+1],0x4b; jle */
        int over = (int)king[KING_TAX_RATE_OFF] - TAX_CAP; /* @asm 0x03435B sub ax,0x4b */
        king[KING_TAX_RATE_OFF] = (uint8_t)(king[KING_TAX_RATE_OFF] - over); /* @asm 0x034364 -> 0x4b */
        delta -= over;                                     /* @asm 0x03436B sub [bp+8],ax */
    }

    /* @asm 0x03436E — no net change -> done. */
    if (delta == 0) return;                                /* @asm 0x034372 jne; 0x034374 -> 0x3471A */

    /* @asm 0x034377 — only the human-controlled active power runs the boycott
     * update (AI powers and out-of-range indices return). */
    if (g_active_power_9E12 >= 4) return;                  /* @asm 0x03437C jl; else -> 0x3471A */
    if (g_ai_personality_543F[g_active_power_9E12 * 0x34] != 0) return; /* @asm 0x034386 cmp [bx+0x543f],0; jne */

    /* ------------------------------------------------------------------
     * @asm 0x034390..0x03451C — BUILD MARKET YIELD TABLE + SELECT GOOD.
     * ------------------------------------------------------------------
     * Builds a 16-word yield table [bp-0xca+good*2] from king[+0xBC+good*4]
     * price dwords (pushed then divided via crt_lmul/crt_aFldiv).  SAR shifts
     * scale some accumulators.  Reads boycott mask king[+0x20] into [bp-0xa4].
     *
     * Outer loop (0..[bp-0xcc] < g_colony_count_539E): for each non-boycotted
     * good, if yield[good] > MARKET_PRICE_5DE0[[bp-0xcc]*0x65+good], replace
     * yield[good] with that market price and save [bp-0xcc] into [bp-0xa2+good*2].
     * (The effective address for the market word is ([bp-0xcc]*0x65+good)*2 from
     * base 0x5DE0; stride 0x65 per "block", same as meeting.c WANTSTUFF.)
     *
     * Accumulate yield[good] (excl. boycotted or zero-yield goods) into total_val.
     * random_int(1, total_val) → walk the yield table until cumsum >= random →
     * winner stored as selected_good in [bp-2] (0xFFFF if no valid good found).
     *
     *   @asm 0x0343BD  push [bx+di+0xbe]/0x0343C1 [bx+di+0xbc] (price dword)
     *   @asm 0x0343F4  mov ax,[bx+0x20]                         (boycott mask → [bp-0xa4])
     *   @asm 0x034428  imul bx,[bp-0xcc],0x65; cmp [bx+0x5de0] (market compare)
     *   @asm 0x0344b8  lcall 0x181f:0x4d4  random_int(1, total_val)
     *   @asm 0x034510  mov [bp-2],ax   selected_good = winner index (0..15)
     *
     * @asm 0x034513..0x03458B — ANNOUNCE TAX CHANGE + GATE BOYCOTT OFFER:
     *   msg_set_long(0, |delta|)      @asm 0x034529 lcall 0x181f:0x9ae
     *   msg_set_long(1, new_tax_rate) @asm 0x03453E lcall 0x181f:0x9ae
     *   Gate: if [bp-2]<0 (no good) OR delta<0 (tax lower) → skip boycott dialog
     *   Gate: if boycott mask bit for selected_good ALREADY set → skip dialog
     *   Non-dialog path (tax lower or good already boycotted):
     *     play_sound(0x4b6 variant for lower) or play_sound(0x3E=62 for raise)
     *     [0x1f5c]=8; show_msg(0x181f:0x3fe, power_id); return.
     * BYTE_VERIFIED 2026-06-10 against func_034318.asm @0x034513..0x03458B.
     *
     * @asm 0x03458C..0x03471D — BOYCOTT DIALOG + EXECUTE (BYTE_VERIFIED):
     * ------------------------------------------------------------------
     * si = selected_good * 2.
     * power_idx = [bp+si-0xa2]  (saved during market loop above)
     * [bp-0xa6] = power_idx.
     *
     * Format good name into stack buf [bp-0x52]:
     *   crt_keyed_to_buf(0x5D48 + power_idx*0xCA, buf)   @asm 0x0345a5 lcall 0xd1d:0x7e4
     *   str_append(buf)                                   @asm 0x0345b1 lcall 0x181f:0x178
     *   str_fmt_int(DGROUP:0x97C0[selected_good*2], buf)  @asm 0x0345c1 lcall 0x181f:0x16e
     *     (DGROUP:0x97C0 = per-good string-handle table; accessed as [si-0x6840])
     * str_msg_set_ptr(3, ss:buf)   @asm 0x0345d0 lcall 0x181f:0x416
     * [0x1f5c] = 8                 @asm 0x0345d8
     * dlg_handle = dlg_open(0x87C, power_id)  @asm 0x0345e7 lcall 0x191f:0x182
     * if dlg_handle == 0: return   @asm 0x0345f6 jmp 0x3471A
     *
     * Add option 1 (ds:0x833C) and option 2 (ss:buf) to the dialog:
     *   @asm 0x034618 lcall 0x191f:0x176  (option 1 at slot 1)
     *   @asm 0x034641 lcall 0x191f:0x176  (option 2 at slot 2, buf)
     * play_sound(0x3E=62)   @asm 0x03464c lcall 0x181f:0x4c0
     * dlg_show(dlg_handle)  @asm 0x034657 lcall 0x191f:0x16a → dlg_result
     * dlg_run(dlg_handle)   @asm 0x034665 lcall 0x191f:0x1a8
     * flush_ui()            @asm 0x03466a lcall 0x181f:0x56a
     * if dlg_result != 2: player refused → return (no boycott).
     *   @asm 0x034673 je 0x34678 / 0x034675 jmp 0x3471A
     *
     * --- Player accepted boycott (dlg_result == 2) @0x034678 ---
     * Reverse tax change: king[+1] -= (uint8_t)delta
     *   @asm 0x03467f sub [bx+1],al
     * market_val = MARKET_PRICE_5DE0[power_idx*0x65 + selected_good]:
     *   @asm 0x034682 imul bx,[bp-0xa6],0x65 / add bx,[bp-2] / shl bx,1
     *   @asm 0x03468c mov ax,[bx+0x5de0]
     * if market_val > 100: market_val = 100   (cap @asm 0x034695 mov ax,0x64)
     * MARKET_PRICE_5DE0[power_idx*0x65 + selected_good] -= market_val
     *   @asm 0x03469b sub [bx+0x5de0],ax
     * DGROUP:0x5E08[power_idx*0xCA] += (int32_t)market_val  (dword accumulator)
     *   @asm 0x0346a3 imul bx,[bp-0xa6],0xca / 0x0346a9 add [bx+0x5e08],ax
     *   @asm 0x0346ad adc [bx+0x5e0a],dx
     * msg_set_long(0, market_val)                            @asm 0x0346b7 lcall 0x181f:0x9ae
     * msg_set_ptr(1, ds:[power_idx*0xCA+0x5d48])            @asm 0x0346da lcall 0x181f:0x416
     * msg_set_handle(2, DGROUP:0x838C[active_power*2])       @asm 0x0346ee lcall 0x181f:0x438
     *   (power name handle table at DGROUP:0x838C, accessed as [bx-0x7c74] with bx=power*2)
     * play_sound(0x56=86)                                    @asm 0x0346f9 lcall 0x181f:0x4c0
     * show_message(1, MSG_SOMEBOYCOTT=0x106A)                @asm 0x034703 lcall 0x181f:0x652
     * SET BOYCOTT BIT: king[+0x20] |= (1 << selected_good)
     *   @asm 0x03470b cl=[bp-2] / 0x03470e ax=1 / 0x034711 shl ax,cl
     *   @asm 0x034717 or word [bx+0x20],ax  ← BYTE_VERIFIED boycott bit SET
     * BYTE_VERIFIED 2026-06-10 against func_034318.asm @0x03458C..0x03471D. */
}

/* ============================================================================
 * NOTES
 *  - CORE (sign-normalise, apply, cap-75, change-credit, human gate):
 *    BYTE_VERIFIED.
 *  - BOYCOTT PATH: fully decoded 2026-06-10 against func_034318.asm @0x03458C..
 *    0x03471D.  Previous note "tail not in any available disasm" was WRONG —
 *    func_034318.asm is 344 lines, complete, RETF at 0x03471D.
 *  - king[+0x20] boycott bitmask: SET confirmed at @asm 0x034717 (`or [bx+0x20],ax`).
 *    CLEAR operation is not in this function; cleared elsewhere (treaty/trade path).
 *  - MSG_SOMEBOYCOTT = 0x106A  (@asm 0x034703 push 0x106a).
 *  - MARKET_PRICE_5DE0 (0x5DE0): stride 0x65 per block; same table used in
 *    meeting.c WANTSTUFF transfer (confirmed cross-file).
 *  - 0x5E08 dword accumulator (stride 0xCA per power): receives the market
 *    supply amount deducted when player accepts boycott.
 *  - DGROUP:0x97C0: per-good string-handle table (accessed as [si-0x6840], si=good*2).
 *  - DGROUP:0x838C: per-power name-handle table (accessed as [bx-0x7C74], bx=power*2).
 *  - crt_keyed_to_buf at 0xD1D:0x7E4: CRT name helper; arg = 0x5D48+power*0xCA.
 *  - crt_lmul/crt_aFldiv (0xD1D:0xDDC / 0xD1D:0xEC6): confirmed in yield-table
 *    build loop; crt_aFldiv cross-confirmed in diplomacy/meeting.c.
 * ============================================================================ */
