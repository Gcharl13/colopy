/* ============================================================================
 *                       >>> BYTE_VERIFIED (model & offsets) <<<
 * ----------------------------------------------------------------------------
 * pricing.c -- European market price model, reconstructed from VICEROY.EXE.
 *
 * The "market struct" IS the active player's PowerRecord:
 *   @asm func_030550 (file 0x030550): g_market_ptr[DGROUP 0x84FC] = 0x8808 +
 *        power*0x13C  (PowerRecord base 0x8808, stride 0x13C; g_active_power 0x9E12)
 *
 * Per-turn drift engine: func_0305A8 @ file 0x0305A8..0x030B37 (1424 bytes,
 *   reseg page_04). Re-derived 2026-05-30 from the FULL re-segmented disasm —
 *   the prior body (compute_net_demand()/market_up_threshold()/market_ceiling()
 *   helper sketch) was a structurally-incomplete RECONSTRUCTION; this version is
 *   a per-basic-block hand-port of the real 524-instruction function.
 *
 * STATUS: [V] byte-verified ; [not yet decoded] data-driven (NAMES.TXT) or overlay-blocked.
 * ============================================================================ */
#include "viceroy_types.h"
#include "power.h"
#include "market.h"

#define NUM_GOODS 16   /* @CARGO tradable count; loop bound CMP ...,0x10        */

/* ----------------------------------------------------------------------------
 * Verified DGROUP globals touched by the market engine
 * ----------------------------------------------------------------------------
 * 0x84FC  near* g_market        active PowerRecord ptr (set by market_set_active)
 * 0x9E12  word  g_active_power   active power index (0..3 Euro)        [V]
 * 0x53EA  word[16] price_seed    per-good base price seed, init random[600,1000]
 *                                @asm WRITE @0x075658 (new-game init), drift
 *                                @asm decays it @0x030639 (sub). Only writers.  [V]
 * 0x538A  word  current_year     (compared 0x640=1600 / 0x6A4=1700)            [V]
 * 0x538E  word  turn_parity/phase (bit0 test @0x030970; sub @0x03090F)         [V]
 * 0x53A6  byte  difficulty       (0..4; default 2; ==4 Viceroy; price scaler).
 *                                EVIDENCE: compared ==0/1/3/4 (@0x051F5B/0x051F6A,
 *                                0x00A295), default-set =2 @0x07433C, written
 *                                @0x0705D2.  CONFLICT: VERIFICATION_LEDGER.md
 *                                line 206 labels 0x53A6 "current_player_idx" —
 *                                the ==0..4 compares + default-2 contradict that;
 *                                flagged for central RULINGS resolution.        [V*]
 *                                (active power index is the separate 0x9E12.)
 * 0x543F  byte[ ] power_is_AI    per-power flag, stride 0x34; ==0 => human
 *                                (gates auto PRICEUP/PRICEDOWN popups)          [V]
 * 0x7B44  byte[pwr*0x10+good]    published display price snapshot               [V]
 * 0x7C74  word[pwr]              per-power nation-name string ptr (msg arg)     [V]
 * 0x97C0  word[16] cargo_col0    @CARGO column-0 value, msg arg (see loader)    [V]
 * ----------------------------------------------------------------------------
 * Equivalences to include/globals.h (same DGROUP bytes, different alias):
 *   g_market           == globals.h g_active_power  (DGROUP:0x84FC)
 *   difficulty         == globals.h g_difficulty_53A6 (DGROUP:0x53A6)
 *   power_is_ai[i*0x34]== globals.h g_power_records[i][0]  (DGROUP:0x543F)
 * Declared here (not redefined) to keep this TU consistent with boycott.c.
 * ---------------------------------------------------------------------------- */
extern struct PowerRecord *g_market;     /* DGROUP:0x84FC active PowerRecord ptr [V] */
extern int                 g_active_power_index; /* DGROUP:0x9E12 active power 0..3 [V] */
typedef struct PowerRecord PowerRecord;  /* match the (PowerRecord*) cast convention */

/* PowerRecord market fields, by VERIFIED offset:
 *   +0x01 tax_rate (byte)        @asm 0x34535
 *   +0x20 boycott_mask (word)    @asm 0x34713 (OR), see boycott.c
 *   +0x2A gold (dword)           @asm 0x352CA SUB/SBB (raw bytes 29 47 2a 19 57 2c) [V]
 *   +0x4C price_level[16] (byte) @asm 0x0306F3 write / 0x0308AD read            [V]
 *   +0x5C vol_accum[16] (word)   @asm 0x030707 (+=) / 0x03099B (+=)             [V]
 *   +0xFC euro_supply[16] (dword) per-good European holdings; summed across the
 *         4 powers in the drift @asm 0x0305DE..0x0305F6 ([bx-0x76fc],
 *         base 0x8904 = PowerRecord+0xFC, inner stride j*0x13C + good*4)        [V] */
#define PR_PRICE_LEVEL(p,g)  (*((unsigned char *)(p) + 0x4C + (g)))
#define PR_VOL_ACCUM(p,g)    (*(short *)((char *)(p) + 0x5C + (g)*2))
#define PR_GOLD(p)           (*(long  *)((char *)(p) + 0x2A))

/* Per-good economic parameters — LOADED FROM NAMES.TXT @CARGO at game start by
 * cargo_table_load() below into DGROUP 0x96FC.  9 bytes/good, stride 9, base
 * 0x96FC (field0 @ 0x96FC == @asm [si*9 - 0x6904]).  Column order (NAMES.TXT):
 *   [0]start1 [1]start2 [2]low [3]high [4]burden [5]rise [6]fall [7]attrition
 *   [8]volatility.   THE NUMERIC VALUES ARE NOT IN THE EXE — see
 *   data/commodity_prices.c for the verbatim NAMES.TXT @CARGO table.            */
extern unsigned char g_cargo_param[NUM_GOODS * 9];           /* DGROUP 0x96FC */
#define CARGO(g,field)  g_cargo_param[(g)*9 + (field)]

/* 32-bit SIGNED LONG DIVIDE runtime helper: returns (dividend / divisor).
 * @asm LCALL 0x0D1D:0x0EC6 (direct overlay call, NOT a thunk — overlay code seg
 * 0x0D1D).  Operation IDENTIFIED via sol_membership_pct (func_008524): there
 * 0x0D1D:0x0F60 is the (×100) multiply and 0x0D1D:0x0EC6 is the divide-by-B
 * (ledger line 838).  Operand order (cdecl, right-to-left push): the divisor is
 * pushed first (deepest), the dividend pushed last.  Used in the drift @0x030759
 * and @0x030871.  Body is overlay-resident compiler runtime; contract verified.  */
extern long ldiv32(long dividend, long divisor); /* @asm 0x0D1D:0x0EC6  [contract V; body = 32-bit long divide (resident C runtime; cross-ref diplomacy/meeting.c)] */

/* random_int(lo, hi) -> uniform in [lo,hi].  @asm LCALL 0x181F:0x04D4 (Type-B,
 * resident, target file 0x00C322 — byte-verified, see rng).                     */
extern int random_int(int lo, int hi);  /* @asm 0x181F:0x04D4  [V] */

/* Overlay message/notify routines used by the drift's PRICEUP/PRICEDOWN path. */
extern void msg_set_arg(int slot, int value);          /* @asm 0x181F:0x0438  */
extern void msg_emit_num (long n, int slot);           /* @asm 0x181F:0x09AE  */
extern void msg_show     (int channel, int key_handle);/* @asm 0x181F:0x0652  */
extern long good_label_value(int good);                /* @asm near call 0x6D23 */

/* ============================================================================
 * market_set_active  --  @asm func_030550 @ file 0x030550 (21 bytes)   [V]
 * ============================================================================ */
void market_set_active(int power)
{
    g_active_power_index = power;                 /* @asm 0x030556 -> 0x9E12 */
    g_market = (PowerRecord *)(0x8808 + power * 0x13C); /* @asm 0x030559-0x030560 */
}

/* ============================================================================
 * market_price_drift  --  per-turn / per-event market recompute.
 *   @asm func_0305A8 @ file 0x0305A8..0x030B37 (1424 bytes, 524 insns) [V]
 *
 *   C signature reconstructed from the frame: two stack args.
 *     arg_mode    [bp+6]  : 0 = silent recompute (no popups; also decays the
 *                           global price seed for the human power 0); nonzero =
 *                           interactive (emit PRICEUP/PRICEDOWN messages).
 *     good_filter [bp+8]  : <0 = process all 16 goods; >=0 = only that good.
 *
 *   LOGIC + every offset/constant below are byte-verified. The only values that
 *   come from outside the EXE are the per-good @CARGO params (g_cargo_param,
 *   loaded from NAMES.TXT) — those are honestly RUNTIME_ONLY (data-resident) but the table that
 *   holds them IS verified (see cargo_table_load + data/commodity_prices.c).
 *
 *   Frame locals (by bp-displacement):
 *     supply[16]  dword @ [bp+g*4-0x4c]   per-good total European supply (Phase 0)
 *     i / good    word  @ [bp-0x5e]
 *     p (power)   word  @ [bp-0x54]        Phase-0 inner power loop (0..3)
 *     S_pair      dword @ [bp-0xa]         a running supply pair total (Phase 2/3)
 *     lo,hi clamp dword @ [bp-0x50]        price-value clamp window
 *     mid         word  @ [bp-0x66]        (rise+fall)/2 per-good midpoint
 *     sign        word  @ [bp-0x56]        sign of a delta (+1 / -1 / 0)
 *     thresh_lim  byte  @ [bp-0xc]         per-good ceiling override (Phase 4)
 *     ceil_val    byte  @ [bp-0x5c]        per-good price ceiling (Phase 4)
 * ============================================================================ */
void market_price_drift(int arg_mode, int good_filter)
{
    long supply[NUM_GOODS];          /* [bp+g*4-0x4c] */
    long S_pair;                     /* [bp-0xa:-8]   */
    long clamp_lo_hi;                /* [bp-0x50:-0x4e] */
    int  i, p, mid, sign;
    int  ceil_val;                   /* [bp-0x5c] */

    /* ---- PHASE 0: per-good supply = seed + sum over 4 powers of euro holdings.
     * @asm 0x0305AE-0x030646 ----------------------------------------------- */
    for (i = 0; i < NUM_GOODS; ++i) {                 /* @asm i=0 @0x0305AE; loop @0x030640 */
        /* seed (signed) -> 32-bit supply[i]                @asm 0x0305B3-0x0305C9 */
        supply[i] = (long)(short)price_seed[i];       /* word[0x53ea + i*2], cdq */

        for (p = 0; p < 4; ++p) {                      /* @asm p=0 @0x0305C9; loop @0x0305F9 */
            /* PowerRecord[p].euro_supply[i]  (dword @ +0xFC)  @asm 0x0305CE-0x0305DC */
            long h = *(long *)((char *)(0x8808 + p * 0x13C) + 0xFC + i * 4);
            if (h < 0) h = 0;                          /* @asm 0x0305E0-0x0305E8 (or dx,dx; clamp 0) */
            supply[i] += h;                            /* @asm 0x0305F0-0x0305F3 (add/adc) */
        }

        /* @asm 0x0305FF-0x030646: silent recompute for the human power (0) decays
         * the global price seed by supply[i] >> 8 (eight sar/rcr pairs = /256). */
        if (arg_mode == 0 && g_active_power_index == 0) {
            long dec = supply[i] >> 8;                 /* @asm 0x030618-0x030632 (8x sar,rcr) */
            price_seed[i] -= (short)dec;               /* @asm 0x030639 sub [bx+0x53ea],ax */
        }
    }

    /* ---- PHASE 2: finished-goods (9..12) total -> S_pair, used as a value base.
     * @asm 0x030649-0x030677 ----------------------------------------------- */
    {
        long t = supply[9] + supply[10] + supply[11] + supply[12]; /* @asm 0x030649-0x03065E */
        if (t < 1) t = 1;                              /* @asm 0x030661-0x03066E clamp min 1 */
        S_pair = t;                                    /* @asm 0x030671 -> [bp-0xa] */
    }

    /* ---- PHASE 3a: refine finished goods 9..12 (Rum,Cigars,Cloth,Coats).
     * @asm 0x030677-0x03078E.  Per good i: clamp supply[i]>=1, compute a target
     * value clamp = (S_pair*3) / supply[i]  [supply-inverse price: more supply =>
     * lower price; S_pair is shl+add => *3], derive the 3-way signum of
     * (price_level[i]-clamp) and mid=(rise+fall)/2, then:
     *   interactive (arg_mode!=0): price_level[i] = clamp, clamped to [low,high].
     *   silent      (arg_mode==0): vol_accum[i] += signum * mid * 100. -------- */
    for (i = 9; i <= 12; ++i) {                        /* @asm i=9 @0x030677; bound CMP ...,0xc @0x03070D */
        if (good_filter >= 0 && i != good_filter)      /* @asm 0x030713-0x03071F */
            continue;

        if (supply[i] < 1) supply[i] = 1;              /* @asm 0x030721-0x030740 (min 1) */

        /* clamp = (S_pair*3) / supply[i].  Operands @asm 0x030743-0x03075E:
         * divisor=supply[i] pushed first; dividend=S_pair*3 pushed last.        */
        clamp_lo_hi = ldiv32(S_pair * 3L, supply[i]);  /* lcall 0x0D1D:0x0EC6 (divide) */

        /* 3-way signum of (price_level[i] - clamp).  @asm 0x030764-0x030789
         * + shared tail @0x0307D0-0x0307DB (jl -> -1, else 0; >0 path -> +1).    */
        {
            int delta = (int)(signed char)PR_PRICE_LEVEL(g_market, i) - (int)clamp_lo_hi;
            sign = (delta > 0) ? 1 : (delta < 0) ? -1 : 0;
        }
        mid = ((int)(signed char)CARGO(i, 5) + (int)(signed char)CARGO(i, 6)) / 2; /* @0x0307E7 (field5+field6)/2 */

        if (arg_mode != 0) {
            /* clamp value into [CARGO.low, CARGO.high] and store as price_level.
             * @asm 0x0306B3-0x0306F6:  field2=low @[si*9-0x6902], field3=high
             * @[si*9-0x6901].  clamp = min(max(clamp, low), high).               */
            int lo = (signed char)CARGO(i, 2);          /* @asm 0x0306B3 low  */
            int hi = (signed char)CARGO(i, 3);          /* @asm 0x0306E1 high */
            if ((int)clamp_lo_hi < lo) clamp_lo_hi = lo;
            if ((int)clamp_lo_hi > hi) clamp_lo_hi = hi;
            PR_PRICE_LEVEL(g_market, i) = (unsigned char)clamp_lo_hi; /* @asm 0x0306F3 */
        } else {
            PR_VOL_ACCUM(g_market, i) += (short)(sign * mid * 0x64); /* @asm 0x0306F8-0x030707 (×0x64) */
        }
    }

    /* ---- PHASE 3b: raw goods 1..4 (Sugar,Tobacco,Cotton,Furs).  @asm 0x0307C9-
     * 0x0308CB.  Always-silent variant of 3a (no message branch):
     *   v = supply[i] (HALVED if i==4) clamped >=1;
     *   clamp = (S_pair*3) / v;  if i==4: clamp += (year<1700) + (year<1600);
     *   signum = sgn(price_level[i]-clamp);  vol_accum[i] += signum * mid  (NO *100).
     * (NOTE: Food=good0 is intentionally skipped — the loop starts at i=1.) --- */
    for (i = 1; i <= 4; ++i) {                          /* @asm i=1 @0x0307C9; bound 0x03080C jle 4 */
        long v;
        if (good_filter >= 0 && i != good_filter)       /* @asm 0x030815-0x030821 */
            continue;
        v = supply[i];                                  /* @asm 0x030823-0x030832 */
        if (i == 4) v >>= 1;                            /* @asm 0x030835-0x030842 (sar/rcr, good4 only) */
        if (v < 1) v = 1;                               /* @asm 0x030845-0x030852 (min 1) */
        clamp_lo_hi = ldiv32(S_pair * 3L, v);           /* @asm 0x03085D-0x030876 lcall 0x0D1D:0x0EC6 (divide) */
        if (i == 4) {                                   /* @asm 0x03087C-0x0308A2 */
            if (g_market_year < 0x6A4) clamp_lo_hi += 1;/* year < 1700 */
            if (g_market_year < 0x640) clamp_lo_hi += 1;/* year < 1600 */
        }
        {
            int delta = (int)(signed char)PR_PRICE_LEVEL(g_market, i) - (int)clamp_lo_hi; /* @asm 0x0308AD-0x0308BB */
            sign = (delta > 0) ? 1 : (delta < 0) ? -1 : 0; /* @asm 0x0308BE-0x0307DB */
        }
        mid = ((int)(signed char)CARGO(i, 6) + (int)(signed char)CARGO(i, 5)) / 2; /* @asm 0x0307E7-0x0307F8 */
        PR_VOL_ACCUM(g_market, i) += (short)(sign * mid); /* @asm 0x0307FD-0x030806 (NO ×0x64) */
    }

    /* ---- PHASE 4: the actual price-STEP loop (rise/fall by 1, clamp, publish).
     * @asm 0x0308CC-0x030B33.  This is the core "drift" the player observes. -- */
    for (i = 0; i < NUM_GOODS; ++i) {                  /* @asm i=0 @0x0308CC; bound 0x030B2B */
        if (good_filter >= 0 && i != good_filter)      /* @asm 0x0308D1-0x0308DD */
            continue;

        /* ceil_val := CARGO[i].field3 (the @CARGO "high" column) — per-good price
         * ceiling.  @asm 0x0308E2-0x0308F0 ([i*9-0x6901] = field3).               */
        ceil_val = (signed char)CARGO(i, 3);

        /* Goods >=14 (Trade Goods, Tools, Muskets) get an extra demand bump from
         * elapsed game time, gated to AI powers (human suppressed).
         * @asm 0x0308F3-0x030951:
         *   if (i>=0xE && (active<4 ? power_is_AI[active]==0 : true)) {
         *       t = (year - 0x258(600)) / 0x64(100);
         *       ceil_val += ((difficulty-4)*2 + t);
         *       if (silent && price_level[i] > ceil_val)
         *           vol_accum[i] += CARGO[i].field6 * 100;
         *   }                                                                    */
        if (i >= 0xE) {
            int gated = (g_active_power_index >= 4) ||
                        (power_is_ai[g_active_power_index * 0x34] == 0); /* @0x030900-0x03090A */
            if (gated) {
                int t = (g_market_year - 0x258) / 0x64;           /* @asm 0x03090C-0x030918 */
                ceil_val += ((int)(signed char)difficulty - 4) * 2 + t; /* @asm 0x03091C-0x030933 */
                if (good_filter < 0 /* full-turn only @0x030926 cmp [bp+8],0;jge */ &&
                    PR_PRICE_LEVEL(g_market, i) > ceil_val) {     /* @asm 0x030936-0x030949 */
                    PR_VOL_ACCUM(g_market, i) +=
                        (short)((signed char)CARGO(i, 6) * 0x64);  /* @asm 0x03094A-0x030951 */
                }
            }
        }

        /* up_step := CARGO[i].field7 (attrition) ; doubled in a special period:
         * @asm 0x030957-0x03097C: if (active==3 && (turn_parity&1)) up_step *= 2.
         * rise threshold := 0x9C * CARGO[i].field5 ; fall threshold := 0x64 *
         * CARGO[i].field6.  (C89: declarations grouped at block start.)          */
        {
            int up_step  = (signed char)CARGO(i, 7);              /* @asm 0x030961 [i*9-0x68fd]=field7 */
            int rise_thr = (int)(0x9C * (signed char)CARGO(i, 5));/* @asm 0x030986 mov al,0x9c; imul field5 */
            int fall_thr = (int)(0x64 * (signed char)CARGO(i, 6));/* @asm 0x030A22 mov al,0x64; imul field6 */

            if (g_active_power_index == 3 && (g_market_phase & 1))/* @asm 0x030969-0x030975 */
                up_step *= 2;                                     /* @asm 0x030977 */

            PR_VOL_ACCUM(g_market, i) += (short)up_step;          /* @asm 0x03099B add [bx+si+0x5c],cx */

            /* PRICE UP: accumulator crossed the rise threshold. @asm 0x0309A1   */
            if ((int)PR_VOL_ACCUM(g_market, i) >= rise_thr) {     /* @asm 0x0309A1 cmp ax,cx */
                PR_VOL_ACCUM(g_market, i) -= (short)rise_thr;     /* @asm 0x0309A5-0x0309A7 */
                if (PR_PRICE_LEVEL(g_market, i) < ceil_val)       /* @asm 0x0309B0 */
                    PR_PRICE_LEVEL(g_market, i)++;                /* @asm 0x0309B5 inc [bx+di+0x4c] */
                /* popup only for AI-free human-visible markets    @asm 0x0309B8-0x030A0C */
                if (g_active_power_index < 4 &&
                    power_is_ai[g_active_power_index * 0x34] == 0) {
                    msg_set_arg(0, cargo_col0[i]);                 /* @asm 0x0309CB-0x0309D6 (arg [si-0x6840]) */
                    msg_set_arg(1, nation_name[g_active_power_index]); /* @asm 0x0309D9-0x0309EA ([bx-0x7c74]) */
                    msg_emit_num(good_label_value(i), 0);          /* @asm 0x0309ED-0x030A02 (call 0x6d23) */
                    msg_show(2, 0xFA8 /* "PRICEUP" */);            /* @asm 0x030A02-0x030A0C */
                }
            }

            /* PRICE DOWN: accumulator at/above the fall threshold.
             * @asm 0x030A18-0x030AA6.                                            */
            if (fall_thr <= (int)PR_VOL_ACCUM(g_market, i)) {     /* @asm 0x030A36 cmp ax,[..] */
                PR_VOL_ACCUM(g_market, i) -= (short)fall_thr;     /* @asm 0x030A3B sub [..],ax */
                if (PR_PRICE_LEVEL(g_market, i) > (signed char)CARGO(i, 2)) /* @asm 0x030A40-0x030A47 field?[di-0x6902] */
                    PR_PRICE_LEVEL(g_market, i)--;                /* @asm 0x030A4C dec [bx+di+0x4c] */
                if (g_active_power_index < 4 &&
                    power_is_ai[g_active_power_index * 0x34] == 0) {
                    msg_set_arg(0, cargo_col0[i]);                 /* @asm 0x030A62 */
                    msg_set_arg(1, nation_name[g_active_power_index]); /* @asm 0x030A70 */
                    msg_emit_num(good_label_value(i), 0);          /* @asm 0x030A84 */
                    msg_show(2, 0xFB0 /* "PRICEDOWN" */);          /* @asm 0x030A9B-0x030AA6 */
                }
            }
        }

        /* post-step decay: vol_accum[i] -= CARGO[i].attrition, when processing a
         * single good (good_filter>=0).  @asm 0x030AA6-0x030AB8 (cmp [bp+8],0; jl skip) */
        if (good_filter >= 0)
            PR_VOL_ACCUM(g_market, i) -= (short)(signed char)CARGO(i, 7);

        /* ---- CLAMP & PUBLISH.  @asm 0x030ABB-0x030B27 ----------------------
         * Ceiling override for goods 8 / 14 / 15 (Horses, Tools, Muskets):
         *   ceil = ( -(difficulty-4) * 3 ) / 2 + 3 ; clamp price_level down to it.
         * else ceiling defaults to 0x19 (25).  @asm 0x030ACE-0x030B0A.          */
        {
            int hard_ceil = 0x19;                                 /* @asm 0x030ACE mov [bp-0xc],0x19 */
            if (i == 0xF || i == 0xE || i == 8) {                 /* @asm 0x030AD2-0x030AE2 */
                int d = -((int)(signed char)difficulty - 4);      /* @asm 0x030AE4-0x030AEC neg */
                hard_ceil = (d * 3) / 2 + 3;                      /* @asm 0x030AEE-0x030AF6 */
                if (hard_ceil <= PR_PRICE_LEVEL(g_market, i))     /* @asm 0x030B02 */
                    hard_ceil = PR_PRICE_LEVEL(g_market, i);      /* @asm 0x030B07 (take max) */
                PR_PRICE_LEVEL(g_market, i) = (unsigned char)hard_ceil; /* @asm 0x030B0A */
            }

            /* published display price = price_level - 1, floored at 0.
             * @asm 0x030B0D-0x030B27 -> 0x7B44[active*0x10 + i].                 */
            {
                int disp = (signed char)PR_PRICE_LEVEL(g_market, i) - 1; /* @asm 0x030B14-0x030B18 dec */
                if (disp < 0) disp = 0;                           /* @asm 0x030B19-0x030B1B */
                display_price[g_active_power_index * 0x10 + i] = (unsigned char)disp; /* @asm 0x030B24 [bx+si-0x7b44] */
            }
        }
    }
}

/* ============================================================================
 * cargo_table_load  --  load the per-good @CARGO economic columns from NAMES.TXT
 *   @asm block in func_0749E0 @ file 0x074DDA..0x074EC1 (reseg page_1A)  [V]
 *
 *   This is the @CARGO arm of the big NAMES.TXT section loader (func_0749E0,
 *   the section table walker the anchor_map listed as "NOT FOUND YET"). It is
 *   driven by the overlay NAMES.TXT parser primitives (segments 0x191F/0x1A1F),
 *   whose internal bodies are overlay-resident — but their CONTRACT is fixed by
 *   the call pattern and is byte-cited here:
 *     names_open_section(name_ptr, mode)  @asm LCALL 0x191F:0x0928
 *     names_next_record()                 @asm LCALL 0x191F:0x091C
 *     names_read_int_word() -> word       @asm LCALL 0x1A1F:0x0B22  [contract V; body in thunk page]
 *     names_read_int_byte() -> byte       @asm LCALL 0x1A1F:0x088A  [contract V; body in thunk page]
 *
 *   The NAMES.TXT @CARGO data has 16 tradable rows (Food..Muskets), each with 9
 *   signed numbers (start1,start2,low,high,burden,rise,fall,attrition,volatility),
 *   followed by 4 nameless non-traded rows (Hammers,Crosses,Liberty Bells,Flags).
 *   @source extracted/text/NAMES_sections.json @CARGO.
 * ============================================================================ */
void cargo_table_load(void)
{
    int good;

    /* @asm 0x074DDA: open @CARGO  (string handle 0x2252 = "CARGO", mode 0). */
    names_open_section(/*0x2252 "CARGO"*/ 0x2252, 0);   /* @asm 0x074DDA-0x074DE4 */

    /* @asm 0x074DEC-0x074E69: per good (loop bound 0x14 = 20) -------------- */
    for (good = 0; good < 0x14; ++good) {
        names_next_record();                            /* @asm 0x074DEC LCALL 0x191F:0x091C */

        /* column-0 read as a WORD into the cargo_col0[16] table @ 0x97C0.
         * @asm 0x074DF1-0x074DFB ([good*2 - 0x6840]).                         */
        cargo_col0[good] = names_read_int_word();       /* @asm 0x074DF1 LCALL 0x1A1F:0x0B22 */

        /* only the 16 tradable goods get the 9-byte economic record.
         * @asm 0x074DFF cmp [bp-8],0x10 ; jge skip.                           */
        if (good < NUM_GOODS) {
            /* 9 consecutive int-byte tokens -> g_cargo_param[good*9 + 0..8].
             * Stores @ [good*9 + {-0x6904..-0x68fc}] == DGROUP 0x96FC..0x9704.
             * @asm 0x074E05-0x074E61 (nine LCALL 0x1A1F:0x088A, one per field). */
            CARGO(good, 0) = names_read_int_byte();      /* @asm 0x074E05/0x074E14  -> 0x96FC start1 */
            CARGO(good, 1) = names_read_int_byte();      /* @asm 0x074E1A/0x074E1F  -> 0x96FD start2 */
            CARGO(good, 2) = names_read_int_byte();      /* @asm 0x074E23/0x074E28  -> 0x96FE low    */
            CARGO(good, 3) = names_read_int_byte();      /* @asm 0x074E2C/0x074E31  -> 0x96FF high   */
            CARGO(good, 4) = names_read_int_byte();      /* @asm 0x074E35/0x074E3A  -> 0x9700 burden */
            CARGO(good, 5) = names_read_int_byte();      /* @asm 0x074E3E/0x074E43  -> 0x9701 rise   */
            CARGO(good, 6) = names_read_int_byte();      /* @asm 0x074E47/0x074E4C  -> 0x9702 fall   */
            CARGO(good, 7) = names_read_int_byte();      /* @asm 0x074E50/0x074E55  -> 0x9703 attrition */
            CARGO(good, 8) = names_read_int_byte();      /* @asm 0x074E59/0x074E5E  -> 0x9704 volatility */
        }
    }

    /* @asm 0x074E6B-0x074EC1: a derived 29-row table at DGROUP 0x2F7A is filled
     * here too (max over k=1..8 of CARGO[k].field1 * tableB[row][k]); this writes
     * 0x2F7A, NOT market state, so it belongs to another subsystem and is left
     * un-ported here (out of src/market scope).  Recorded for traceability.     */
}

/* ============================================================================
 * Trade primitives.  Treasury update is byte-verified (32-bit SUB/SBB on gold
 * @+0x2A: raw bytes 29 47 2a 19 57 2c @ file 0x352CA). Tax via PowerRecord +0x01.
 *
 * The price-level -> coin VALUE curve (the bid/ask the player actually pays /
 * receives, and the ask = bid + (@CARGO burden + 1) spread) is computed inside
 * the trade dialog, in a region the re-segmenter could not linearly disassemble
 * (the jump-table at 0x033F65 truncates page_04 into a data blob; the per-func
 * pass also misses the body around 0x352CA). The leaf at the price-coin thunk
 * 0x181F:0x09A4 -> file 0x008110 is only a 14-byte difficulty clamp, not the
 * full curve. So the exact coin formula remains *** [not yet decoded] — do NOT fabricate it.
 * ============================================================================ */
extern long market_good_value(int good, int qty);   /* [not yet decoded] trade-dialog-resident */

long market_buy(int good, int qty)
{
    if (boycott_is_active(good) || qty <= 0) return 0;
    {
        long value = market_good_value(good, qty);      /* [not yet decoded] */
        PR_GOLD(g_market) -= value;                      /* @asm 0x352CA SUB/SBB (29 47 2a 19 57 2c) [V] */
        PR_VOL_ACCUM(g_market, good) -= (short)qty;      /* buy lowers traffic accumulator */
        return value;
    }
}

long market_sell(int good, int qty)
{
    if (boycott_is_active(good) || qty <= 0) return 0;
    {
        long value = market_good_value(good, qty);      /* [not yet decoded] (net of tax @+0x01) */
        PR_GOLD(g_market) += value;
        PR_VOL_ACCUM(g_market, good) += (short)qty;      /* sell raises traffic accumulator */
        return value;
    }
}
