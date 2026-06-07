/* ============================================================================
 *  compute.c -- Colonization score computation
 * ----------------------------------------------------------------------------
 *  STATUS LEGEND (per viceroy_source/VERIFICATION_LEDGER.md):
 *    [BYTE_VERIFIED]   bytes read & hand-decompiled from COLONIZE/VICEROY.EXE
 *    [ANCHOR_VERIFIED] confirmed anchor, value/formula not byte-traced
 *    [TBD]             not located / not verified -- do NOT trust
 *
 *  Rewritten 2026-05-30 against the re-segmented disassembly
 *  (code/VICEROY/disasm_overlay_reseg/page_05.asm). This supersedes the
 *  2026-05-29 rewrite, which made TWO mistakes that are corrected here:
 *
 *  ---------------------------------------------------------------------------
 *  CORRECTION 1 — func_051EF4 is NOT the score tick; "+0x2A" is GOLD, not score.
 *  ---------------------------------------------------------------------------
 *  The 2026-05-29 version anchored scoring on func_051EF4@0x051EF4, claiming the
 *  running SCORE accumulator is the u32 at *(0x84FC)+0x2A. That conflicts with
 *  the project's OWN, empirically-verified PowerRecord layout:
 *
 *    - include/power.h:           `uint32_t gold;  // +0x2A -- treasury`
 *    - docs/DATA_MODEL.md PowerRecord +0x2A = **gold** [BYTE_VERIFIED],
 *      cross-validated against the on-screen "Gold: NNNNN%" UI
 *      ("+0x2A = 1920 displayed as Gold: 19200%"; "user's 3552 / 4032 visible").
 *    - docs/DATA_MODEL.md 0x84FC = far ptr to PowerRecord[active] "gold at +0x2A
 *      matches in-game UI".
 *
 *  So func_051EF4's `mov bx,[0x84FC]; add [bx+0x2A],ax; adc [bx+0x2C],dx`
 *  (file 0x051F7C..0x051F83) credits **gold**, and func_051EF4 is a periodic
 *  per-power GOLD/income tick, not the scoring routine. Its byte-verified
 *  arithmetic is preserved below for the record (it IS correct as bytes), but
 *  it is re-tagged: the FORMULA is BYTE_VERIFIED, the SUBSYSTEM label "score"
 *  is WITHDRAWN. (Logged as a cross-source conflict for docs/RULINGS.md.)
 *
 *  ---------------------------------------------------------------------------
 *  CORRECTION 2 — the REAL end-of-game score/rank lives in func_03A9C0 (page 05).
 *  ---------------------------------------------------------------------------
 *  The end-of-game SCORE + RANK screen is func_03A9C0@0x03A9C0 (page 0x05): it
 *  is the only function that pushes the "SCORE" GAME.TXT keys (handles 0x11CF/
 *  0x11E9, file 0x1F76F/0x1F789 = 0x11CF+0x1D9A0 etc.) and the rank title key
 *  "SCORE"+itoa(rank+1). It computes a 0..23 RANK from the raw per-power score
 *  via a (k*k)/3 threshold ladder and the difficulty factor — all byte-visible
 *  and decompiled in score_endgame_rank() below. The RAW per-power score VALUE
 *  itself is produced by an overlay-resident routine reached as 0x191F:0x3AA
 *  (via the page-05 trampoline `ljmp 0x191F:0x3AA` at file 0x03B36A); that body
 *  is NOT in the re-seg pages -> the score COMPONENTS (colonies/pop/FF/gold/
 *  bells weighting) remain [TBD]. We do NOT fabricate them.
 *
 *  @ref code/VICEROY/disasm_overlay_reseg/page_05.asm  (func_03A9C0, func_03B2F8)
 *  @ref code/VICEROY/disasm_overlay_reseg/page_0D.asm  (func_051EF4)
 *  @ref ../../docs/DATA_MODEL.md   (PowerRecord +0x2A = gold)
 *  @ref ../include/power.h
 * ============================================================================ */
#include "viceroy_types.h"
#include "power.h"

/* DGROUP globals. [BYTE_VERIFIED offsets]: */
extern uint16_t g_year;          /* 0x538A  current year (1500 + n)             */
extern uint16_t g_turn;          /* 0x538E  turn counter                        */
extern uint8_t  g_difficulty;    /* 0x53A6  difficulty / current-player byte    */
extern uint16_t g_colony_count;  /* 0x539E  active-colony loop bound            */
extern uint8_t  g_demo_flag;     /* 0x5382  bit0 = demo/endgame gate            */

/* g_active_power: far ptr to the active power's PowerRecord. [BYTE_VERIFIED].
 * @asm 0x051F7C: mov bx,[0x84FC]. +0x2A is GOLD (see CORRECTION 1).            */
extern uint8_t far *g_active_power;   /* DGROUP:0x84FC */

/* Per-power scalar byte table read by func_051EF4 at [power_idx - 0x6D68].
 * Access pattern BYTE_VERIFIED @0x051F2E `mov cl,[bx-0x6D68]`; the table's
 * SEMANTICS are [TBD].                                                         */
extern uint8_t g_power_metric_6D68[];  /* @asm [bx-0x6D68], bx=power_idx        */

/* ----------------------------------------------------------------------------
 *  gold_income_tick_for_power -- per-power periodic GOLD increment.
 *  (FORMERLY mis-named score_tick_for_power; see CORRECTION 1.)
 * ----------------------------------------------------------------------------
 *  @asm func_051EF4 @0x051EF4  (page 0x0D, 4233 B). The HEAD (0x051EF4..
 *  0x051F83) is the gold increment; the remainder is SoL/Tory/event +
 *  high-water-mark bookkeeping (decoded structurally below, magnitudes TBD).
 *
 *  BYTE_VERIFIED head (the +0x2A increment itself):
 *    @asm 051F1F  ax = *(0x538A)                  ; year
 *    @asm 051F22  ax -= 0x5DC                     ; - 1500
 *    @asm 051F29  ax = ax / 50   (signed idiv 50)
 *    @asm 051F2E  cl = *(power_idx - 0x6D68)      ; per-power metric byte
 *    @asm 051F34  v  = metric + (year-1500)/50    ; -> [bp-0x10]
 *    @asm 051F39  if (*(0x538E) < 0x14) v = 0     ; turn < 20 -> none
 *    @asm 051F45  if (*(0x538A) >= 0x6A4) v <<= 1 ; year >= 1700 -> x2
 *    @asm 051F50  acc = difficulty * v   (imul *(0x53A6))
 *    @asm 051F5B  if (difficulty == 3) acc += acc>>1  ; x1.5
 *    @asm 051F6A  if (difficulty == 4) acc <<= 1       ; x2
 *    @asm 051F74  acc <<= 2                             ; x4
 *    @asm 051F7C  bx = *(0x84FC)                        ; active PowerRecord
 *    @asm 051F80  *(int32*)(bx+0x2A) += acc             ; GOLD += acc
 *
 *  [TBD] in the remainder of func_051EF4 (decoded structurally, not as values):
 *    - colony scan @0x051F8B..0x051FC7 (loops [0x539E] colonies via 0x181F:0x9E6;
 *      tests active-colony [0x8542]+0x1A owner & building-0xD via 0x181F:0x9FC).
 *    - SoL/Tory thresholds @0x05201A..0x0521FE read per-power bytes at
 *      [bx-0x6BE8]/[bx-0x6DA4]/[bx-0x6DA3]/[bx-0x6BF4]/[bx-0x6BEC]/[bx-0x6BDC]
 *      and compare gold dword [0x84FC]+0x2A against 0x7D0 (2000) / 0x3E8 (1000)
 *      to set event flags [bp-0xC]/[bp-0xE]; emit messages via 0x181F:0x... .
 *    - high-water-mark: @0x052157/0x052177/0x052197 keep MAX of [0x84FC]+0x2A
 *      against [0x9796]/[0x97A8]/[0x97AE] (32-bit cmp+store).
 *    - bit0 of [0x5382] (demo/endgame) zeroes the SoL branch (@0x052062).
 *  These are score-ADJACENT / record bookkeeping; formulae & string keys [TBD].
 * ---------------------------------------------------------------------------- */
void gold_income_tick_for_power(int power_idx)
{
    long v, acc;
    int  diff;

    /* @asm 051F1F..051F34 */
    v = (long)g_power_metric_6D68[power_idx]
        + ((int)g_year - 0x5DC) / 50;          /* metric + (year-1500)/50 */

    /* @asm 051F39 */
    if (g_turn < 0x14)
        v = 0;                                  /* turn < 20 -> none */

    /* @asm 051F45 */
    if (g_year >= 0x6A4)                         /* year >= 1700 */
        v <<= 1;

    /* @asm 051F50..051F74 : difficulty scaling, then x4 */
    diff = g_difficulty;
    acc = v * diff;
    if (diff == 3) acc += acc >> 1;             /* x1.5 */
    else if (diff == 4) acc <<= 1;              /* x2  */
    acc <<= 2;                                   /* x4  */

    /* @asm 051F7C..051F83 : 32-bit add into PowerRecord+0x2A (= GOLD) via *(0x84FC) */
    {
        long *gold = (long *)(g_active_power + 0x2A);
        *gold += acc;
    }
    (void)power_idx; (void)g_colony_count; (void)g_demo_flag;
}

/* ----------------------------------------------------------------------------
 *  raw_power_score -- the per-power raw score VALUE.  [TBD body — overlay]
 * ----------------------------------------------------------------------------
 *  func_03A9C0 obtains the raw score by `call 0x49DA` (file 0x03A9F6), which is
 *  a trampoline `ljmp 0x191F:0x3AA` (file 0x03B36A). 0x191F:0x3AA is an
 *  OVERLAY-resident routine NOT present in the re-seg pages, so the actual
 *  scoring weights (population, colonies, founding fathers, gold, liberty,
 *  difficulty bonus, revolution bonus, etc.) are [TBD]. The same routine is
 *  also invoked from page_01 (file 0x0238E2: `lcall 0x191F,0x3AA`) with arg 1.
 *
 *  func_03B2F8 (file 0x03B2F8) marshals context for it: it strcpy's the active
 *  power's name ([0x5398]*0x34 + 0x540E), captures [0x5398] (active power),
 *  [0x5382]&1 and &8 (flags), [0x538A] (year), [0x538C], [0x53A6] (difficulty),
 *  then calls 0x191F:0x3AA(0) for the raw score and 0x191F:0x3AA-family helpers
 *  (0x191F:0xF8E / 0xF9C / 0xFAA) for the title/rank text.  [BYTE_VERIFIED
 *  marshalling; the score arithmetic itself is overlay-resident = TBD.]
 * ---------------------------------------------------------------------------- */
extern int raw_power_score(int arg);   /* 0x191F:0x3AA -- body TBD (overlay-resident) */

/* ----------------------------------------------------------------------------
 *  score_endgame_rank -- map a raw score to the 0..23 RANK (title index).
 * ----------------------------------------------------------------------------
 *  @asm func_03A9C0 @0x03A9C0, head 0x03AA0A..0x03AA79 (page 0x05). BYTE_VERIFIED.
 *
 *  The end-of-game screen computes a difficulty-weighted percentile of the raw
 *  score and bins it through a quadratic threshold ladder to get a rank 0..23,
 *  which selects the title string "SCORE"+itoa(rank+1) (itoa @0x03AADA).
 *
 *    @asm 03AA0A  factor = difficulty + 4                         ; [bp-0x60]
 *    @asm 03AA15  if (difficulty >= 3) factor++
 *    @asm 03AA20  if (difficulty >= 4) factor++
 *                  -> factor for diff 0..4 = {4, 5, 6, 8, 10}
 *    @asm 03AA2A  if (raw_score != 0)
 *    @asm 03AA31      pct = (factor * raw_score) / 100             ; [bp-2]
 *    @asm 03AA47  rank = -1 (0xFFFF); for (k = 1; k <= 0x18; k++)  ; [bp-0xC0],[bp-0xBC]
 *    @asm 03AA4D      if ((k*k)/3 < pct) rank = k - 1;             ; largest k-1 with (k^2)/3 < pct
 *    @asm 03AA6A  pct >>= 1                                        ; (used for the bar width)
 *    @asm 03AA6D  if (rank > 0x17) rank = 0x17                     ; clamp to 23
 *
 *  Returns the rank 0..23 (or -1 if raw_score == 0, i.e. below the lowest
 *  threshold). The TITLE STRINGS themselves are GAME.TXT "@SCORE1".."@SCORE24"
 *  (key built at @asm 0x03AAB0 / 0x03AADA); their text is data-resident, not in
 *  the EXE, so the human-readable rank names are [TBD here] (read from GAME.TXT).
 * ---------------------------------------------------------------------------- */
int score_endgame_rank(int raw_score)
{
    int factor;   /* [bp-0x60] */
    long pct;     /* [bp-2]    (32-bit product before /100) */
    int rank;     /* [bp-0xC0] */
    int k;        /* [bp-0xBC] */

    /* @asm 03AA0A..03AA27 : difficulty factor {4,5,6,8,10} for diff 0..4 */
    factor = (int)g_difficulty + 4;
    if (g_difficulty >= 3) factor++;
    if (g_difficulty >= 4) factor++;

    /* @asm 03AA2A : score 0 -> rank -1 (the 0xFFFF sentinel set at func entry) */
    if (raw_score == 0)
        return -1;

    /* @asm 03AA31..03AA3E : pct = factor * raw_score / 100 (signed) */
    pct = ((long)factor * (long)raw_score) / 100;

    /* @asm 03AA47..03AA68 : quadratic threshold ladder, k = 1..24 */
    rank = -1;
    for (k = 1; k <= 0x18; k++) {                 /* @asm 03AA63 cmp [bp-0xBC],0x18 / jle */
        if (((long)k * k) / 3 < pct)              /* @asm 03AA4D imul / idiv 3 / cmp [bp-2] */
            rank = k - 1;                         /* @asm 03AA5A dec cx / mov [bp-0xC0],cx */
    }

    /* @asm 03AA6D..03AA79 : clamp rank to 0x17 (23) */
    if (rank > 0x17) rank = 0x17;
    return rank;                                   /* 0..23 */
}

/* ----------------------------------------------------------------------------
 *  Convenience accessor for the BYTE_VERIFIED gold field (PowerRecord +0x2A).
 *  (Renamed from the prior `power_current_score` — +0x2A is GOLD, not score;
 *  see CORRECTION 1. The per-power SCORE value comes from raw_power_score(),
 *  whose body is overlay-resident = TBD.)
 * ---------------------------------------------------------------------------- */
int32_t power_current_gold(int power_idx)
{
    /* @asm PowerRecord+0x2A, base 0x8808, stride 0x13C  [BYTE_VERIFIED field] */
    extern uint8_t g_power_table[];     /* DGROUP:0x8808 */
    return *(int32_t *)(g_power_table + power_idx * POWER_RECORD_STRIDE + 0x2A);
}
