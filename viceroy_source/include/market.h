/* ============================================================================
 *   MARKET STATE LAYOUT: byte-verified  |  price->coin curve: overlay-resident (TBD)
 * ----------------------------------------------------------------------------
 * Corrected 2026-05-30. The previous struct was fabricated (docs/RULINGS.md
 * 2026-05-30 / 2026-05-28 market): it claimed sensitivity[16]@+0x4C,
 * pool[16]@+0x5C, traded_volume[16]@+0x7C, eu_supply[16]@+0xBC,
 * base_value[16]@+0xFC and a "bid = base + pool/sensitivity" formula — all of
 * which contradict the BYTE_VERIFIED src/market/pricing.c (which explicitly
 * flagged that model "structurally wrong" and replaced it).
 *
 * Verified per-power market state (PowerRecord, stride 0x13C):
 *   +0x4C  price_level[16]  (byte)  running price index per good   [V] @asm 0x0306F3/0x0308AD
 *   +0x5C  vol_accum[16]    (word)  traffic-volume accumulator      [V] @asm 0x030707/0x03099B
 *   +0x20  boycott_mask     (word)  1 bit per good, boycotted=1     [V] src/market/boycott.c
 * The per-good economic parameters (start/low/high/burden/rise/fall/attrition/
 * volatility) are loaded from NAMES.TXT @CARGO into DGROUP:0x96FC — see
 * data/commodity_prices.c (CARGO_TABLE) and src/market/pricing.c.
 *
 * @ref include/power.h ; src/market/pricing.c ; src/market/boycott.c
 * ============================================================================ */
#ifndef VICEROY_MARKET_H
#define VICEROY_MARKET_H

#include "viceroy_types.h"

/* Per-power market state, embedded in PowerRecord (offsets are PowerRecord-relative).
 * Only these two arrays + the boycott word are verified; there is no
 * pool/traded_volume/eu_supply/base_value array set. */
struct MarketState {
    uint8_t  price_level[16];   /* +0x4C  running price index per good      [V] */
    int16_t  vol_accum[16];     /* +0x5C  traffic-volume accumulator         [V] */
    /* boycott bitmask is a separate WORD at PowerRecord+0x20 (not contiguous here) */
};

/* ----------------------------------------------------------------------------
 * Pricing model (verified mechanism; coin curve TBD)
 * ----------------------------------------------------------------------------
 * Per trade, vol_accum[good] changes; when it crosses the @CARGO `rise`/`fall`
 * thresholds the price_level steps, clamped to [@CARGO low, @CARGO high]. Each
 * turn `attrition` is added to vol_accum (price recovery). The exact mapping
 * from price_level to the displayed bid/ask COIN value, and the ask = bid +
 * (@CARGO burden + 1) spread application, are overlay-resident and NOT yet
 * byte-decoded ([TBD]). Tax (PowerRecord+0x01) is taken off the sell proceeds.
 * The 16 goods are good_id 0..15 in @CARGO order (Food..Muskets); see
 * data/commodity_prices.c. (The old per-good "spread[]" was the @CARGO burden.)
 * ---------------------------------------------------------------------------- */

/* ----------------------------------------------------------------------------
 * Verified DGROUP market globals (declared here, defined by the loader / engine).
 * Each is cited at its byte offset; see src/market/pricing.c for the @asm sites.
 * ---------------------------------------------------------------------------- */
extern int16_t price_seed[16];     /* 0x53EA  per-good base price seed (random[600,1000]) [V] */
extern int16_t cargo_col0[16];     /* 0x97C0  @CARGO column-0 value (PRICEUP/DOWN msg arg) [V] */
extern uint8_t display_price[];    /* 0x7B44  published price snapshot [power*0x10 + good]  [V] */
extern int16_t nation_name[];      /* 0x7C74  per-power nation-name string handle           [V] */
extern uint8_t power_is_ai[];      /* 0x543F  per-power AI flag, stride 0x34 (==0 => human)  [V] */
extern int16_t g_market_year;      /* 0x538A  current year word (1492=0x5D4 .. 0x640=1600)   [V] */
extern int16_t g_market_phase;     /* 0x538E  turn parity/phase word (bit0 tested in drift)  [V] */
extern uint8_t difficulty;         /* 0x53A6  difficulty 0..4 (default 2; ==4 Viceroy). NOTE:
                                    * VERIFICATION_LEDGER line 206 calls 0x53A6
                                    * "current_player_idx" — conflict (==0..4 compares +
                                    * default-2 favor difficulty); see pricing.c.        [V*] */

/* NAMES.TXT parser primitives (overlay-resident bodies; CONTRACT byte-cited by
 * the call pattern in cargo_table_load / func_0749E0).  [contract V; body TBD-overlay] */
extern void names_open_section(int name_handle, int mode); /* @asm LCALL 0x191F:0x0928 */
extern void names_next_record(void);                       /* @asm LCALL 0x191F:0x091C */
extern int  names_read_int_word(void);                     /* @asm LCALL 0x1A1F:0x0B22 */
extern int  names_read_int_byte(void);                     /* @asm LCALL 0x1A1F:0x088A */

/* ----------------------------------------------------------------------------
 * External interface
 * ---------------------------------------------------------------------------- */
extern void cargo_table_load(void);            /* @asm func_0749E0 @CARGO arm @0x074DDA [V] */
extern void market_set_active(int power);      /* @asm func_030550 @0x030550            [V] */
extern void market_price_drift(int arg_mode, int good_filter); /* @asm func_0305A8 @0x0305A8 [V] */

extern long market_buy(int commodity_id, int qty);   /* treasury @0x352CA [V]; value [TBD] */
extern long market_sell(int commodity_id, int qty);  /* returns gold received; value [TBD] */

/* boycott.c interface (separate translation unit) */
extern int  boycott_is_active(int good);       /* @asm func_030B38 @0x030B38            [V] */

#endif /* VICEROY_MARKET_H */
