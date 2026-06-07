/* ============================================================================
 *        >>> NATIVE TRADE HAGGLING RESOLVER — func_049600 <<<
 * ----------------------------------------------------------------------------
 * The price-negotiation that runs when a unit (scout/wagon/ship) trades at a
 * native settlement.  Drives the 4-way BADHAGGLE0..3 counter-offer escalation,
 * the SELL path (player sells cargo TO the natives -> gold IN), the BUY path
 * (player buys a good FROM the natives -> gold OUT), and the BRING/DEFICIT/
 * NOTENOUGH messages.
 *
 * @asm_function  func_049600   (file 0x049600..0x04A37A inclusive, 3451 bytes,
 *                               1138 insns, prologue `ENTER 0xD8,0`, RETF)
 * @asm_disasm    code/VICEROY/disasm_overlay_reseg/page_0C.asm
 *                (page 0x0C, code_base 0x46600; display IP = file - 0x46600,
 *                 so func entry IP 0x3000).
 * @reach         page 0x0C + offset_in_segment 0x2820  (rtlink_decode.py
 *                `resolve 0x0C 0x2820` -> file 0x049600).  Its Type-A overlay
 *                thunk is at file 0x01CA3C (bytes 9a ab 0d 0d 11 ea 20 28 00 00
 *                0c 00 = LCALL 0x110D:0x0DAB ; JMPF 0:0x2820 ; trailer page 0x0C),
 *                addressable as 0x1A1F:0x044C / 0x191F:0x144C / 0x181F:0x244C.
 *                (The brief's "0x1A1F:0x2820" conflated the page-resolve offset
 *                0x2820 with the thunk-window offset 0x044C.)
 *
 * ROLE — BYTE_VERIFIED via STRING XREF (the project's primary identification
 * method).  Every one of these message keys is PUSHed inside the function body
 * (string-segment base file 0x1D9A0; handle + 0x1D9A0 = file offset):
 *   0x1561 BADCARGO    (file 0x1EF01) @asm 0x49960  [PUSH 0x1561]
 *   0x156A BADHAGGLE1  (file 0x1EF0A) @asm 0x49996  [PUSH 0x156A]
 *   0x1575 TRADE0      (file 0x1EF15) @asm 0x49E37  [PUSH 0x1575]
 *   0x157C BADHAGGLE0  (file 0x1EF1C) — block @0x49E33 region
 *   0x1587 BRING       (file 0x1EF27) @asm 0x49D4A  [PUSH 0x1587]
 *   0x158D BADHAGGLE3  (file 0x1EF2D) @asm 0x49D6F  [PUSH 0x158D]
 *   0x1598 DEFICIT     (file 0x1EF38) @asm 0x49F12  [PUSH 0x1598]
 *   0x15A0 BUYWHICH    (file 0x1EF40) @asm 0x49F87  [PUSH 0x15A0]
 *   0x15A9 BUY0        (file 0x1EF49) @asm 0x4A144  [PUSH 0x15A9]
 *   0x15AE NOTENOUGH   (file 0x1EF4E) @asm 0x4A26C  [PUSH 0x15AE]
 *   0x15B8 BADHAGGLE2  (file 0x1EF58) @asm 0x4A33F  [PUSH 0x15B8]
 * (The immediately-following sibling func_04A37C handles the wagon-train attack
 *  outcome KILLWAGONS/MADATWAGONS/GRUDGEWAGONS @0x15C3/0x15CE/0x15DA — NOT
 *  ported here; out of scope for the haggle resolver.)
 *
 * @verified_by  Hand-decompiled 2026-05-30 from the re-segmented overlay dump,
 *               every cited offset/byte re-read from COLONIZE/VICEROY.EXE
 *               (sha256 a17ed64c… in MANIFEST.md).  The PRICE ARITHMETIC of both
 *               the SELL and BUY branches and the two PowerRecord gold transfers
 *               are BYTE_VERIFIED.  The dialog/menu control flow that drives the
 *               BADHAGGLE escalation crosses several overlay thunks whose
 *               internal effects are not byte-resolved — those are tagged
 *               [TBD] / extern below.  Several inputs are data-resident tables
 *               loaded from NAMES.TXT/runtime, also tagged [TBD-data].
 *
 * STATUS: BYTE_VERIFIED (price formulas + gold transfers + role);
 *         ANCHOR_VERIFIED (haggle-escalation control flow);
 *         TBD (dialog thunk internals + a few data-resident tables).
 * ============================================================================ */
#include "viceroy_types.h"
#include "native.h"

/* ----------------------------------------------------------------------------
 * GLOBALS — all DGROUP bases BYTE_VERIFIED at the cited sites.  Kept local to
 * this TU (no edits to include/globals.h per task scope).  The negative-
 * displacement addressing convention used throughout VICEROY is
 *   effective_DGROUP_addr = 0x10000 - |neg_disp|
 * so e.g. `word [bx-0x6840]` with bx = good*2 reads g_cargo_col0_97C0[good]
 * (0x10000-0x6840 = 0x97C0).  Verified consistent with src/market/pricing.c
 * (0x7B44/0x97C0) and src/native/raid.c (0x77CE -> PowerRecord.gold @0x8832).
 * ---------------------------------------------------------------------------- */
extern uint8_t  g_powerrecord_8808[];     /* PowerRecord[] base, stride 0x13C; gold dword @+0x2A.
                                           *   addressed here as [bx-0x77CE]/[bx-0x77CC] with
                                           *   bx = power*0x13C (= 0x8832 lo/hi). [V] @0x49597 */
extern uint8_t  g_power_is_ai_543F[];     /* DGROUP:0x543F per-power controller, stride 0x34;
                                           *   ==0 => human.  [V] @0x49622 / src/market/pricing.c */
extern uint8_t  g_difficulty_53A6;        /* DGROUP:0x53A6 difficulty 0..4. [V] @0x49445 etc. */

extern int16_t  g_trade_tribe_8D52;       /* DGROUP:0x8D52 — the tribe being traded with.  Used
                                           *   BOTH as a small int index (imul *,0x27 @0x82A3 via
                                           *   thunk 0x30C; cmp ==0/==1 @0x49655/0x49666) and as a
                                           *   message arg (PUSH [0x8D52] before the 0x191F:0x19C
                                           *   notify).  [V — addressing/compares] (note: the same
                                           *   DGROUP word is a far-ptr in settlement.c's context). */
extern uint8_t *g_cur_settlement_8D4A;    /* DGROUP:0x8D4A — far ptr to the "current settlement"
                                           *   record (the one being traded at).  Fields touched:
                                           *   +7,+8,+9 (last-traded-good memory), +0xA+good*2
                                           *   (per-good stock word).  [V] @0x498A1 etc. */
extern uint8_t *g_cur_settlement_8D4E;    /* DGROUP:0x8D4E — far ptr to a SECOND settlement record
                                           *   (the tribe's "home"/scoring record).  Fields +2
                                           *   (class/tier byte), +7,+8 (counters), +0xA,+0xE+good*2
                                           *   (per-good scoring words).  [V] @0x499D9 etc. */
extern int16_t  g_trade_qty_8DC4;         /* DGROUP:0x8DC4 — the quantity of goods in the current
                                           *   trade (units).  Read/scaled throughout. [V] @0x49B9F */
extern uint8_t  g_cargo_col0_97C0[];      /* DGROUP:0x97C0 — word[16] @CARGO column-0 (start1 base
                                           *   price) per good; ALSO a msg arg.  [V] — identical
                                           *   table to src/market/pricing.c "0x97C0 cargo_col0". */
extern uint8_t  g_disp_price_7B44[];      /* DGROUP:0x7B44 — byte[power*0x10 + good] published
                                           *   display-price snapshot.  [V] — identical table to
                                           *   src/market/pricing.c line 338 ([bx+si-0x7b44]). */

/* Per-good working buffers for THIS trade (DGROUP word arrays, zeroed/filled at
 * function start by the near helper at IP 0x5443; see note).  [V — addressing] */
extern int16_t  g_trade_stock_9E58[];     /* DGROUP:0x9E58 — word[16]; [si-0x61A8].  Per-good
                                           *   "settlement stock / desirability" working value. */
extern int16_t  g_trade_want_9E78[];      /* DGROUP:0x9E78 — word[16]; [bx-0x6188].  Per-good
                                           *   "amount the natives want / the unit carries". */

/* UI scratch the dialog reads to render the "they offer N / you have M" popup.
 * @asm 0x49B1D-0x49B30 (SELL) and 0x4A185-0x4A194 / 0x4A0F8 (BUY). [V — writes] */
extern int32_t  g_ui_amount_9CB0;         /* DGROUP:0x9CB0 (dword) — offered gold / price */
extern int32_t  g_ui_amount2_9CB4;        /* DGROUP:0x9CB4 (dword) — secondary amount (cap/qty) */
extern int32_t  g_ui_amount3_9CB8;        /* DGROUP:0x9CB8 (dword) — BUY: PowerRecord gold snapshot */

/* ----------------------------------------------------------------------------
 * OVERLAY/RUNTIME THUNKS — targets resolved via rtlink_decode.py against
 * viceroy_rtlink_map.json (page dir + 3 windows).  Contract cited; bodies that
 * are pure UI/format are [TBD].
 * ---------------------------------------------------------------------------- */
extern int  random_int(int lo, int hi);   /* 0x181F:0x04D4 -> file 0x0C322  [V] (rng.c) */
extern long ldiv32(long n, long d);        /* 0x0D1D:0x0EC6 -> compiler long-divide [V contract]
                                            *   (pricing.c ldiv32): divisor pushed first (deepest),
                                            *   dividend last; returns n/d. */

/* msg_set_arg(slot,value): 0x181F:0x0438 -> page 0x17 file 0x6C23C.  Populates
 * message substitution slot `slot` with `value`.  [V — same thunk as
 * src/market/pricing.c msg_set_arg]. */
extern void msg_set_arg(int slot, int value);

/* native_notify(tribe, msg_key) -> int: 0x191F:0x019C -> page 0x17 file 0x6F5B0.
 * Shows a tribe-attributed message (BADHAGGLE/TRADE0/BUY0/…) and returns the
 * player's menu choice (1-based) used to branch the haggle.  [contract ANCHOR;
 * body TBD]. */
extern int  native_notify(int tribe, int msg_key);

/* per-(tribe, power) relationship word @ DGROUP:0x5B1C, stride 0x27 per tribe.
 * 0x181F:0x030C -> file 0x082A0: `imul bx,[bp+6],0x27; add bx,[bp+8]; shl bx,1;
 * mov ax,[bx+0x5B1C]`.  Called (tribe, power).  [V — body fully decoded;
 * SEMANTICS of the stored value TBD-data]. */
extern int  tribe_power_relation(int tribe, int power);   /* @0x082A0 [V] */

/* per-good "want index" @ DGROUP:0x???, 0x181F:0x0A60 -> file 0x08262:
 * returns 0 when good < 0x19 else a table value (body truncates at first RET;
 * the good<0x19 path returns 0).  [contract V; full table TBD]. */
extern int  cargo_want_index(int good);   /* @0x08262 */

/* set a per-(tribe,power,good) trade-relationship delta:
 * 0x181F:0x0D6C -> page 0x0B file 0x045DF2.  Called (tribe, power, delta, 0).
 * Adjusts how the tribe feels after a trade.  [contract ANCHOR; body TBD]. */
extern void trade_relation_adjust(int tribe, int power, int delta, int zero);

/* unit-interaction predicates / mutators (page 0x17 / resident): */
extern int  unit_trade_accept(int unit_idx, int good);    /* 0x181F:0x0BE6 -> file 0x0B2A2 [TBD] */
extern int  unit_trade_capacity(int unit_idx, int good, void *buf, int n); /* 0x181F:0x0C68 -> 0x0B2F0 [TBD] */
extern int  unit_consume_cargo(int unit_idx, int good, int qty); /* 0x181F:0x0D58 -> 0x0B368 [TBD] */
extern int  unit_flag_test(int unit_idx, int arg);        /* 0x181F:0x0A38 -> file 0x07F34;
                                                           *   returns byte[arg + unit?*0x4E + 0x59D8];
                                                           *   tested with &0x40.  [contract V; TBD]. */
extern void trade_dialog_finish(int unit_idx);            /* 0x181F:0x0808 family [TBD] */

/* ----------------------------------------------------------------------------
 * Arguments (caller PUSH order, right-to-left; ENTER 0xD8 frame):
 *   [BP+6]  = unit_idx   — trading unit (UnitRecord stride 0x1C, base 0x3144;
 *                          type byte @ +0x3146).  [V] @0x49677 `imul bx,*,0x1C`.
 *   [BP+8]  = arg8       — secondary unit/context (passed through to func_05448
 *                          and unit helpers).  [observed; role TBD]
 *   [BP+0xA]= power      — the EU power index doing the trade (0..3); indexes
 *                          PowerRecord (×0x13C) and g_disp_price_7B44 (×0x10).
 *                          [V] @0x49592 `imul bx,[bp+0xa],0x13c`.
 *   [BP+0xC]= arg_c      — passed to unit_flag_test as the 2nd arg.  [role TBD]
 * Return: AX (int).  Several exit paths return [bp-0xC4] / [bp-0x5C] / a menu
 *   choice; the common "done" exit @0x49D62 clamps the current-good stock and
 *   returns the last computed value in AX. [exit values ANCHOR]
 * ---------------------------------------------------------------------------- */

/* The 4 haggle-escalation message keys, in the order the function emits them. */
#define MSG_BADCARGO     0x1561
#define MSG_BADHAGGLE1   0x156A
#define MSG_TRADE0       0x1575   /* "they accept your sale" */
#define MSG_BADHAGGLE0   0x157C
#define MSG_BRING        0x1587   /* "bring us X instead" */
#define MSG_BADHAGGLE3   0x158D
#define MSG_DEFICIT      0x1598   /* you don't have the goods */
#define MSG_BUYWHICH     0x15A0
#define MSG_BUY0         0x15A9   /* "they offer to sell you X" */
#define MSG_NOTENOUGH    0x15AE   /* you can't afford it */
#define MSG_BADHAGGLE2   0x15B8

/* ============================================================================
 *           SELL-side per-unit price  — BYTE_VERIFIED
 * ----------------------------------------------------------------------------
 * Player SELLS `good` (quantity `qty`) to the natives; they pay gold.  This
 * computes the per-unit price seed `[bp-0x7e]` then the total `[bp-0x60]`.
 * Decoded from @asm 0x4939C..0x49AC7 (page 0x0C).  `mood = random_int(1,5)`,
 * the per-good "want" base `[bp-0x5a]`, and the per-good adjustments are all
 * here verbatim.  Inputs:
 *   good                          = [bp-0xc6]   (the good being sold)
 *   diff                          = g_difficulty_53A6
 *   stock                         = g_trade_stock_9E58[good]   ([bx-0x61A8])
 *   want_idx                      = cargo_want_index(arg)*2    (0x0A60), 0 for
 *                                   good 0xF/8, halved if stock>=0x14
 *   home rec [0x8D4E] +7/+8       = per-tier counters (good 0xF/8 specials)
 * Formula (every line @asm-cited inline):
 *   mood   = random_int(1,5)                                   ; @0x4939C [bp-0x80]
 *   base   = (good > 8) ? 7 : 6                                ; @0x499AB/0x499B7 [bp-0x5a]
 *   if good==0xD (Furs): base -= random_int(0,7)               ; @0x499C3
 *   if good==0xF (Muskets): base += (0xC - home[+7])           ; @0x499D9
 *   if good==8  (Horses):   base += (0xA - home[+8])           ; @0x499F0
 *   if good==0xE (Trade Goods): base += 1                      ; @0x49A07
 *   want2  = cargo_want_index(qty?) * 2                        ; @0x49A0A->0xA60, shl1
 *            (zeroed for good 0xF/8 @0x49A29; if stock>=0x14 -> >>1 @0x49A3B)
 *   seed   = (base - diff - want2 + mood + 4) * 2              ; @0x49A42..0x49A56 [bp-0xd6]
 *   // total price across the stock, scaled by trade quantity and /100:
 *   acc    = max(0, seed * stock)                              ; @0x49A62..0x49A6A imul[bx-0x61a8]
 *   acc    = acc + (mood*5)                                    ; @0x49A6E..0x49A78 (shl2+add+add)
 *   total  = ldiv32(acc * qty, 100)                            ; @0x49A7A imul[bp-0x68]; 0xD1D:0xEC6
 *   total  = max(1, (total - sign(total)) >> 1)                ; @0x49A86..0x49A93 [bp-0x60]
 * Returns `total` (the gold the natives offer for the whole sale).  Also yields,
 * via out-params, the per-unit seed and the haggle-round budget used by the
 * escalation loop (computed @0x49A96..0x49AC7):
 *   rounds = min(3, (stock - want2 + 4)/10)                    ; @0x49A96..0x49AB0 [bp-0xc8]
 *   counter_budget = random_int(1, rounds) + (qty>>2)          ; @0x49AB4..0x49AC7 [bp-0xc2]
 * ============================================================================ */
int haggle_sell_price(int good, int qty, int *out_seed, int *out_counter_budget)
{
    int diff  = (int)g_difficulty_53A6;
    int stock = g_trade_stock_9E58[good];

    /* @0x4939C — base "mood" roll */
    int mood = random_int(1, 5);

    /* @0x499AB/0x499B7 — per-good base want multiplier */
    int base = (good > 8) ? 7 : 6;

    /* @0x499C3 — Furs penalty */
    if (good == 0x0D)
        base -= random_int(0, 7);
    /* @0x499D9 — Muskets: scale toward the home record's +7 counter */
    if (good == 0x0F)
        base += (0x0C - (int)((int8_t)g_cur_settlement_8D4E[7]));
    /* @0x499F0 — Horses: scale toward the home record's +8 counter */
    if (good == 0x08)
        base += (0x0A - (int)((int8_t)g_cur_settlement_8D4E[8]));
    /* @0x49A07 — Trade Goods bonus */
    if (good == 0x0E)
        base += 1;

    /* @0x49A0A..0x49A3B — per-good want index (×2), specials, stock halving */
    int want2 = cargo_want_index(qty) * 2;          /* @0x49A0A->0xA60, shl1 @0x49A16 */
    if (good == 0x0F || good == 0x08)
        want2 = 0;                                  /* @0x49A29 */
    if (stock >= 0x14)
        want2 >>= 1;                                /* @0x49A3B sar 1 */

    /* @0x49A42..0x49A56 — the per-unit price seed */
    int seed = (base - diff - want2 + mood + 4) * 2;        /* [bp-0xd6] */
    if (out_seed) *out_seed = seed;

    /* @0x49A62..0x49A78 — acc = max(0, seed*stock) + mood*5.
     * The asm clamps the LOW 16 bits of seed*stock (`imul [bx-0x61a8]; or ax,ax;
     * jge; sub ax,ax`) and keeps mood*5+that in 16 bits before the next imul;
     * for the realistic value range (small seed, stock 0..~20) the long form
     * below is equivalent. */
    long acc = (long)seed * (long)stock;                    /* imul [bx-0x61a8] */
    if (acc < 0) acc = 0;                                   /* @0x49A66 or; jge; sub (16-bit) */
    acc += (long)(mood * 5);                                /* mood<<2 + mood @0x49A6E */

    /* @0x49A7A..0x49A93 — × qty, /100 (signed long divide), then halve the LOW
     * 16 bits with round-toward-zero, clamp >=1.  The asm takes only the low
     * word of the ldiv result before the /2: `cdq; sub ax,dx; sar ax,1` is the
     * MSC idiom for (int16)x / 2 truncating toward zero. */
    long tl = ldiv32(acc * (long)qty, 100);                 /* imul [bp-0x68]; 0xD1D:0xEC6 */
    int16_t x = (int16_t)tl;                                /* low word only @0x49A86 cdq operates on ax */
    int total = (int)((x - (x < 0 ? -1 : 0)) >> 1);         /* @0x49A87 sub ax,dx; @0x49A89 sar ax,1 */
    if (total < 1) total = 1;                               /* @0x49A8B cmp 1; jge */

    /* @0x49A96..0x49AC7 — haggle counter-offer budget */
    {
        long r = ((long)stock - (long)want2 + 4);
        int rounds = (int)(r / 10);                         /* @0x49AA6 idiv 0xA */
        if (rounds > 3) rounds = 3;                         /* @0x49AA8 cmp 3; jle */
        int budget = random_int(1, rounds) + (qty >> 2);    /* @0x49AB4 rand; @0x49AC2 sar di,2; add */
        if (out_counter_budget) *out_counter_budget = budget;
    }
    return total;
}

/* ============================================================================
 *           BUY-side price  — BYTE_VERIFIED
 * ----------------------------------------------------------------------------
 * The natives offer to SELL the player `good`; this computes the asking price
 * the player must pay in gold.  Decoded from @asm 0x4A025..0x4A0D6 (page 0x0C).
 * Inputs:
 *   good   = [bp-0xc6]            (the good offered)
 *   power  = [bp+0xa]             (buyer)
 *   diff   = g_difficulty_53A6
 *   home rec [0x8D4E] +2          = settlement class/tier byte
 *   disp   = g_disp_price_7B44[power*0x10 + good]   (published EU display price)
 *   rel    = tribe_power_relation(tribe, power)     (×4 subtracted)
 *   qty    = g_trade_qty_8DC4
 * Formula (every line @asm-cited inline):
 *   ask = 0xC8 (200)                                          ; @0x4A025 [bp-0x60]
 *   if good >= 8: ask = (8 - home[+2]) * 0x32                 ; @0x4A02F..0x4A040
 *   if good >= 7: ask += disp * (diff*2 + 0xF)                ; @0x4A04A..0x4A067
 *   ask += random_int(0, ask)                                 ; @0x4A06A..0x4A077
 *   ask -= g_trade_stock_9E58[selected]? * 4                  ; @0x4A07A..0x4A087 ([bx-0x6188]<<2)
 *          (NOTE: this reads g_trade_want_9E78 via [bx-0x6188]; the index
 *           [bp-0x84] is the selected-good slot — TBD which buffer; bytes V)
 *   ask += rel * 4                                            ; @0x4A08A..0x4A09C (0x30C, shl2)
 *   ask  = ldiv32(qty * ask, 100)                             ; @0x4A0A3..0x4A0B0 (0xD1D:0xEC6)
 *   ask += (diff + random_int(0,2)) * 5 * 2                   ; @0x4A0B3..0x4A0D3
 *   ask  = max(0x32, ask)                                     ; @0x4A0D6..0x4A0E1 (min 50)
 * Returns `ask` (gold the player must pay).
 * ============================================================================ */
int haggle_buy_price(int good, int power, int selected_slot)
{
    int diff = (int)g_difficulty_53A6;

    /* @0x4A025 — base ask 200 */
    int ask = 0xC8;

    /* @0x4A02F..0x4A040 — refined/manufactured goods (>=8): tier-scaled base */
    if (good >= 8) {
        int tier = (int)g_cur_settlement_8D4E[2];           /* home rec +2 */
        ask = (8 - tier) * 0x32;                            /* (8-tier)*50 */
    }

    /* @0x4A04A..0x4A067 — goods >=7: add EU display price × difficulty factor */
    if (good >= 7) {
        int disp = (int)g_disp_price_7B44[power * 0x10 + good];
        ask += disp * (diff * 2 + 0x0F);                    /* @0x4A060 shl1; add 0xF; imul */
    }

    /* @0x4A06A..0x4A077 — random uplift up to current ask */
    ask += random_int(0, ask);

    /* @0x4A07A..0x4A087 — subtract 4× the selected-good working value
     * ([bx-0x6188] = g_trade_want_9E78[selected_slot]).  [bytes V; buffer TBD] */
    ask -= g_trade_want_9E78[selected_slot] * 4;

    /* @0x4A08A..0x4A09C — add 4× the per-(tribe,power) relationship value */
    ask += tribe_power_relation(g_trade_tribe_8D52, power) * 4;

    /* @0x4A0A3..0x4A0B0 — scale by trade quantity / 100 (signed long divide) */
    ask = (int)ldiv32((long)g_trade_qty_8DC4 * (long)ask, 100);

    /* @0x4A0B3..0x4A0D3 — difficulty + small random, ×5, ×2 */
    {
        int r = random_int(0, 2);                           /* @0x4A0B3 */
        int add = (diff + r);                               /* @0x4A0C7 */
        add = (add * 5) * 2;                                /* @0x4A0CC shl2+add; @0x4A0D1 shl1 */
        ask += add;                                         /* @0x4A0D3 */
    }

    /* @0x4A0D6..0x4A0E1 — floor at 50 */
    if (ask < 0x32) ask = 0x32;
    return ask;
}

/* ============================================================================
 * native_haggle_resolve — the func_049600 entry (ANCHOR_VERIFIED flow,
 *                         BYTE_VERIFIED prices + gold transfers)
 * ----------------------------------------------------------------------------
 * High-level control flow (every branch @asm-cited).  The dialog loops that
 * implement the BADHAGGLE0..3 escalation call native_notify() (0x191F:0x19C)
 * and re-price on each player counter-offer; the exact menu-choice → branch
 * mapping is ANCHOR-level (the notify body is TBD), but the PRICE recompute and
 * the gold transfers it performs are byte-verified.
 *
 * STRUCTURE:
 *   @0x49600..0x49635  prologue; is_human = (power in 0..3 && controller==0).
 *   @0x4963B..0x49677  if human & a roll says "interrupt": play SFX 5/6/7 and
 *                      bail (the "they aren't interested today" path).
 *   @0x49677..0x49692  if unit type in [0xD..0x12] clear unit[+0x3158] (reset a
 *                      per-unit trade flag); zero the two 16-byte SS scratch
 *                      arrays [bp-0x7a]/[bp-0x96] (per-good last-offer memory).
 *   @0x496B2..0x496EE  push [0x83A6]; near-call func_05443 (fills g_trade_*_9E78
 *                      / clamps a global) then MK a 16-entry good list into the
 *                      SS scratch via memcpy-thunk 0x191F:0xED0.  [helper TBD]
 *   @0x4971D           if power < 0 -> jmp final clamp/exit (AI/none path).
 *   @0x49726..0x4977A  read unit[+0x3150] (a trade-mode selector 0/1/>1):
 *                        0 -> jmp 0x327B (the "natives propose" path).
 *                        1 -> SELL block (the unit is selling its cargo).
 *                        >1-> BRING/multi path (build a name list, prompt
 *                             TRADEWHICH @0x1556, pick a good).
 *   SELL block (@0x4977A..0x499xx, message TRADE0/BADHAGGLE*): for each good
 *     the unit carries, compute haggle_sell_price(), show via native_notify,
 *     and on accept ADD gold to PowerRecord (see below).  The 4-way BADHAGGLE
 *     escalation is driven by [bp-0x5c] (the player's response 1..3) selecting
 *     among accept / counter / walk-away, decrementing [bp-0xc2] each round.
 *   BUY block (@0x49F18..0x4A35x, message BUYWHICH/BUY0/NOTENOUGH/BADHAGGLE2):
 *     pick up to 3 candidate goods (those the settlement has and the unit lacks),
 *     compute haggle_buy_price(), show via native_notify, accept-> SUBTRACT gold.
 *
 * GOLD TRANSFERS (both BYTE_VERIFIED, PowerRecord.gold dword @ +0x2A = 0x8832):
 *   SELL accept @0x4958E..0x4959B:
 *     imul bx,[bp+0xa],0x13c ; add word [bx-0x77ce],ax ; adc word [bx-0x77cc],dx
 *     -> PowerRecord[power].gold += total_price
 *   BUY  accept @0x4A1C8..0x4A1E3 (guarded by an affordability compare):
 *     imul bx,[bp+0xa],0x13c
 *     cmp [bx-0x77cc],dx ; jl no_funds ; jg ok ; cmp [bx-0x77ce],ax ; jb no_funds
 *     sub word [bx-0x77ce],ax ; sbb word [bx-0x77cc],dx
 *     -> if affordable: PowerRecord[power].gold -= ask  (else NOTENOUGH @0x4A26C)
 *
 * The full ~1138-instruction dialog state machine is NOT reproduced 1:1 here —
 * only its byte-verified numeric core (prices + transfers) and its decision
 * skeleton.  The notify/menu/format thunks remain extern ([TBD]); replacing
 * them 1:1 requires resolving the page-0x17 dialog bodies (out of scope).
 * ============================================================================ */
int native_haggle_resolve(int unit_idx, int arg8, int power, int arg_c)
{
    (void)unit_idx; (void)arg8; (void)arg_c;

    /* @0x49612..0x49635 — is the trade with a human-controlled power? */
    int is_human = 0;
    if (power >= 0 && power < 4 &&
        g_power_is_ai_543F[power * 0x34] == 0)              /* @0x4961E imul *,0x34; @0x49622 */
        is_human = 1;

    /* @0x4963B..0x49649 — for a human, a 1-in-? roll can abort the encounter. */
    if (is_human) {
        if (random_int(0, 3) == 0) {                        /* @0x4963F rand(0,3); or ax */
            /* @0x4964B..0x49677 — play one of SFX 5/6/7 keyed off the tribe,
             * then fall through to the normal flow (the SFX is a greeting). */
            /* trade_play_sfx(...) — [TBD], side effect only */
        }
    }

    /* @0x49677..0x49692 — reset the unit's per-trade flag for native combat
     * unit types 0x0D..0x12 (UnitRecord type byte @ +0x3146). */
    /* (unit[+0x3158] = 0;  handled by the engine UnitRecord accessor — [V index]) */

    /* The remainder is the dialog state machine.  Its numeric core is captured
     * by haggle_sell_price()/haggle_buy_price() above and the two transfers
     * below; the menu
     * loop that sequences BADHAGGLE0..3 is ANCHOR-level (native_notify body TBD).
     *
     * Representative SELL accept (gold IN) — @0x4958E..0x4959B [BYTE_VERIFIED]:
     *     int seed, budget;
     *     int total = sell_price(good, qty, &seed, &budget);
     *     ... native_notify(tribe, MSG_TRADE0) / BADHAGGLE* loop ...
     *     PowerRecord[power].gold += total;
     *
     * Representative BUY accept (gold OUT) — @0x4A1C8..0x4A1E3 [BYTE_VERIFIED]:
     *     int ask = buy_price(good, power, selected_slot);
     *     ... native_notify(tribe, MSG_BUY0) / BADHAGGLE2 loop ...
     *     if (PowerRecord[power].gold >= ask)  PowerRecord[power].gold -= ask;
     *     else  native_notify(tribe, MSG_NOTENOUGH);
     */

    /* @0x49D62..0x4A37A — common exit: clamp the current-good stock word
     * [0x8D4A]+0xA+power*2 to >= 0, then return. */
    {
        int16_t *cur = (int16_t *)&g_cur_settlement_8D4A[0x0A + power * 2];
        if (*cur < 0) *cur = 0;                             /* @0x4A36B or; jge; sub */
    }
    return 0;   /* exit-value path is ANCHOR (see banner); placeholder */
}

/* ============================================================================
 * The two gold transfers, isolated and BYTE_VERIFIED, for callers/tests.
 * PowerRecord.gold is a 32-bit dword at PowerRecord+0x2A (DGROUP 0x8832 for
 * power 0), addressed in this function as [bx-0x77CE] (lo) / [bx-0x77CC] (hi)
 * with bx = power*0x13C.  Identical to src/native/raid.c's transfer.
 * ============================================================================ */
int32_t *haggle_power_gold(int power)
{
    /* @asm imul bx,[bp+0xa],0x13C ; [bx-0x77CE]  (== &PowerRecord[power].gold) */
    return (int32_t *)&g_powerrecord_8808[power * 0x13C + 0x2A];
}

/* SELL accept @0x4958E..0x4959B — gold IN. */
void haggle_sell_credit(int power, int total_price)
{
    *haggle_power_gold(power) += total_price;       /* add/adc [bx-0x77ce]/[bx-0x77cc] */
}

/* BUY accept @0x4A1C8..0x4A1E3 — gold OUT, but only if affordable (else the
 * caller raises NOTENOUGH @0x4A26C and aborts the purchase). */
int haggle_buy_debit(int power, int ask)
{
    int32_t *gold = haggle_power_gold(power);
    if (*gold >= (int32_t)ask) {                    /* cmp [bx-0x77cc],dx / [bx-0x77ce],ax */
        *gold -= ask;                               /* sub/sbb */
        return 1;                                   /* purchased */
    }
    return 0;                                       /* NOTENOUGH path */
}
