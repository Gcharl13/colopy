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
 * @asm_function  func_034318   (file 0x034318..~0x034439, ENTER 0xCE frame)
 * @asm_disasm    disasm/func_034318_unknown.asm  (per-function dump; this
 *                function is NOT covered by the re-segmented page dump, which
 *                stops at 0x033F65 — see SEGMENTS note below)
 * @verified_by   Hand-decompiled 2026-05-30; the apply + cap-75 instructions
 *                were spot-checked byte-for-byte against COLONIZE/VICEROY.EXE:
 *                  0x034318: C8 CE 00 00          enter 0xCE,0
 *                  0x03434C: 00 47 01             add byte [bx+1], al
 *                  0x03434F: 80 7F 01 4B          cmp byte [bx+1], 0x4B   ; cap=75
 *
 * SEGMENTS NOTE: the per-function disasm available for this address ends at
 * 0x034437 (boundary detector under-counted); the tail of the ENTER 0xCE frame
 * (the boycott-message/effect after the price-table compare) is NOT in any dump
 * we have, so it is marked left unresolved below — only the anchors are cited.
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
     * @asm 0x034390..0x034437 — BOYCOTT recompute (PARTIALLY traced).
     * ------------------------------------------------------------------
     * Builds a 16-entry working table from the king record's per-good price
     * dwords (king[+0xBC + good*4]) via the CRT long-arith helpers, halves/
     * quarters some accumulators (SAR), reads the boycott bitmask king[+0x20],
     * and for each good whose mask bit is clear compares a computed value
     * against the market price table at 0x5DE0 (stride 0x65 words).
     *
     *   @asm 0x0343BD push [bx+di+0xbe] / 0x0343C1 push [bx+di+0xbc]  (price dword)
     *   @asm 0x0343F4 mov ax,[bx+0x20]                                (boycott mask)
     *   @asm 0x034416 shl ax,cl ; 0x034418 test [bp-0xa4],ax          (bit per good)
     *   @asm 0x034428 imul bx,[bp-0xcc],0x65 ; 0x034433 cmp [bx+0x5de0],ax
     *
     * The branch TARGETS past 0x034437 (where a good's boycott is actually set/
     * cleared and the SOMEBOYCOTT message shown) fall in the un-dumped tail of
     * this function and are not yet decoded — DO NOT invent the set/clear rule. */
    /* not yet decoded: boycott set/clear + SOMEBOYCOTT notification (tail not in any disasm). */
}

/* ============================================================================
 * NOTES / STILL-not yet decoded
 *  - CORE (sign-normalise, apply, cap-75, change-credit, human gate):
 *    BYTE_VERIFIED.
 *  - The exact tax-rate field is PowerRecord+0x01 (cross-confirmed in
 *    king_tax_raise.c and FUNCTION_INVENTORY.md "King record byte +1 = tax").
 *  - The boycott bitmask king[+0x20] and the 0x5DE0 market price table are
 *    BYTE_VERIFIED addresses, but the per-good boycott DECISION (the code after
 *    0x034437) is not in any available disasm and is left unresolved.
 *  - crt_lmul / crt_aFldiv: crt_aFldiv (0xD1D:0xEC6) is confirmed as the __aFldiv-style
 *    32-bit long divide (cross-confirmed in diplomacy/meeting.c); crt_lmul (0xD1D:0xDDC)
 *    is the corresponding long-multiply (approx, not independently verified in this file).
 * ============================================================================ */
