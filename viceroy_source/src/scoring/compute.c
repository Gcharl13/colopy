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
 *  IS in page 0x05 as func_039EE2 (BYTE_VERIFIED 2026-06-08; see raw_power_score
 *  below). The score COMPONENTS (all 7, plus vet_mult) are documented there.
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
 * Semantics: RUNTIME_ONLY (per-power income-rate byte; loaded with power data).*/
extern uint8_t g_power_metric_6D68[];  /* @asm [bx-0x6D68], bx=power_idx        */

/* ----------------------------------------------------------------------------
 *  gold_income_tick_for_power -- per-power periodic GOLD increment.
 *  (FORMERLY mis-named score_tick_for_power; see CORRECTION 1.)
 * ----------------------------------------------------------------------------
 *  @asm func_051EF4 @0x051EF4  (page 0x0D, 4233 B). The HEAD (0x051EF4..
 *  0x051F83) is the gold increment; the remainder is SoL/Tory/event +
 *  high-water-mark bookkeeping (decoded structurally below; thresholds 0x7D0=2000,
 *  0x3E8=1000 byte-cited; high-water targets [0x9796]/[0x97A8]/[0x97AE] RUNTIME_ONLY).
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
 *  STRUCTURAL (byte-cited, not as final-values) in the remainder of func_051EF4:
 *    - colony scan @0x051F8B..0x051FC7 (loops [0x539E] colonies via 0x181F:0x9E6;
 *      tests active-colony [0x8542]+0x1A owner & building-0xD via 0x181F:0x9FC).
 *    - SoL/Tory thresholds @0x05201A..0x0521FE read per-power bytes at
 *      [bx-0x6BE8]/[bx-0x6DA4]/[bx-0x6DA3]/[bx-0x6BF4]/[bx-0x6BEC]/[bx-0x6BDC]
 *      and compare gold dword [0x84FC]+0x2A against 0x7D0 (2000) / 0x3E8 (1000)
 *      to set event flags [bp-0xC]/[bp-0xE]; emit messages via 0x181F:0x... .
 *    - high-water-mark: @0x052157/0x052177/0x052197 keep MAX of [0x84FC]+0x2A
 *      against [0x9796]/[0x97A8]/[0x97AE] (32-bit cmp+store).
 *    - bit0 of [0x5382] (demo/endgame) zeroes the SoL branch (@0x052062).
 *  These are score-ADJACENT / record bookkeeping; formulae byte-cited above;
 *  string keys are RUNTIME_ONLY (message handles; text loaded from GAME.TXT).
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
 *  raw_power_score -- the per-power raw score VALUE.
 * ----------------------------------------------------------------------------
 *  LOCATED (2026-06-08) via the confirmed Type-A RTLink thunk format:
 *    thunk 0x191F:0x3AA @ file 0x1B99A: off=0x0092, segid=5, extra=0x02B1
 *    base[5]=0x037340 + extra*16 + off = 0x039EE2  [func start confirmed]
 *
 *  func_039EE2 @ file 0x039EE2..0x03A9BF (2781 bytes, ENTER 0x7E, retf 0x03A9BE).
 *  Immediately precedes score_endgame_rank (func_03A9C0 starts at 0x03A9C0).
 *
 *  CALL CHAIN (BYTE_VERIFIED):
 *    func_03A9C0 @ 0x03A9F6: `call 0x3B36A` (near, within page)
 *    func_03B36A @ 0x03B36A: `ljmp 0x191F:0x3AA`  [= EA AA 03 1F 19 confirmed]
 *    → RTLink thunk @ 0x1B99A → loader patches → func_039EE2
 *
 *  DUAL PURPOSE: arg==0 → compute-only (turn-loop call from endgame tick).
 *                arg!=0 → compute + render the per-component score display panel.
 *    @asm 039F42  if [bp+6]==0: jmp 0x3A09A  (arg gate, BYTE_VERIFIED)
 *
 *  HEAD (BYTE_VERIFIED — first 70 bytes):
 *    @asm 039EE2  ENTER 0x7E,0              ; 126-byte local frame
 *    @asm 039EE6  al = [0x53A8]             ; year % 100  (confirmed write sites)
 *    @asm 039EE9  CWDE → CX = al
 *    @asm 039EEC  al = 0x64                 ; 100
 *    @asm 039EEE  imul [0x53A7]             ; ax = 100 * (year/100)
 *    @asm 039EF2  [bp-0x6A] = cx + ax       ; = current game year  (e.g. 0x640=1600)
 *    @asm 039EF4..039F18  zero 11 locals    ; score component accumulators
 *    @asm 039F1C..039F3B  loop i=0..3:      ; count other active EU powers (≠ self)
 *         if i != [0x5398]: test PowerRecord[i×0x13C-0x77F8] bit 2; if set, [bp-0x56]++
 *    @asm 039F3C  [bp-0x7E] = [0x5398]     ; current power index
 *
 *  DS:0x53A7 = year / 100 (century byte).  DS:0x53A8 = year % 100.
 *  Confirmed from write sites in func_03DE46 @0x03DE65 (year%100 → [0x53A8])
 *  and @0x03DE6F (year/100 → [0x53A7]). (Previously mis-identified as king-anger.)
 *
 *  SCORE COMPONENTS (BYTE_VERIFIED structure; per byte-trace of body 2026-06-08):
 *
 *    [bp-0x6e]  score_founding   — colonist-class points over all colonies:
 *                                   per unit: class==0x1C→+2; class∈{0x19,0x1A,0x1B}→+1; else→+4
 *                                   Applied in colony loop AND native-settlement loop.
 *                @asm 03A0B5..03A153  colony loop (0x181F:0x9E6 / 0x181F:0xC54)
 *                @asm 03A154..03A1FB  unit/settlement loop (0x181F:0xB78 / 0x181F:0x2C6)
 *
 *    [bp-0x58]  score_ff_pts     — 5 points per Founding Father owned by this power
 *                                   loop i=0..24: if ff_recognized_7B4(i,power)→ +5
 *                @asm 03A2AC..03A327  (0x181F:0x7B4 = ff_recognized; @0x03A2BE add 5)
 *
 *    [bp-2]     score_gold       — PowerRecord.gold / 1000  (gold ≥ 1000 to get any credit)
 *                @asm 03A3D9..03A4A3  (0x181F:0x84FC + 0x2A:0x2C = 32-bit gold; /1000)
 *
 *    [bp-0x6c]  score_ref        — PowerRecord[+0x18] × -(difficulty+1)  [NEGATIVE penalty]
 *                                   Field +0x18 = king-enforcement counter (BYTE); 2 write sites:
 *                                     (1) @asm 0x034206: zeroed during per-nation init
 *                                     (2) @asm 0x05BF21: INC inside func_05A67E, Block B
 *                                         conditional on: atk_power < 4 AND [bx+0x543F]==0
 *                                         (human player wins the combat), followed by
 *                                         calls to 0x181F:0x0A42 and 0x181F:0x7B4
 *                                         (attack/event dispatch, force=0xA).
 *                                   Counts REF/king-force engagements where the human player
 *                                   prevailed; higher count → larger score penalty.
 *                                   (BYTE_VERIFIED 2026-06-08: init + INC site confirmed;
 *                                    "battles_won" label was correct — specifically HUMAN
 *                                    player wins against king-force units.)
 *                @asm 03A4A4..03A543  (cmp [bx+0x18],0; mov cx,0xffff; sub cx,difficulty; imul)
 *
 *    [bp-0x5a]  score_sol        — g_bolivar_meter (DGROUP:0x53D0); Bolivar/SoL meter 0..100
 *                @asm 03A544..03A5F4
 *
 *    [bp-0x64]  score_liberty    — (1780 - year) × 2  when [0x5382]&8 and year<1780
 *                                   (threshold 0x6F4=1780; revolution/war-active gate)
 *                @asm 03A5F5..03A6DB  (cmp [0x5382],8; cmp year,0x6F4; sub; shl 1)
 *
 *    [bp-0x60]  score_congress   — min(PowerRecord.congress_progress/100, 100)
 *                                   when [0x5382]&2 and congress_progress≥100
 *                @asm 03A704..03A782
 *
 *    [bp-0x54]  vet_mult (gate)  — 100>>num_other_EU_powers  when [0x5382]&8
 *                                   [bp-0x54] stores 100>>count as the gate check;
 *                                   the actual multiplier factor is 8>>count (recomputed
 *                                   fresh at @asm 03A8B4 into [bp-0x54] before the mul).
 *                                   Total scaled: total×(8+(8>>num_other_EU))/8
 *                @asm 03A783..03A87A  (sar ax,cl [ax=0x64]; lcall 0xD1D:0xF60 32-bit mul; sar×3)
 *
 *  TOTAL (@asm 03A896):
 *    raw = score_liberty + score_ff_pts + score_ref + score_congress
 *        + score_sol + score_gold + score_founding
 *    if vet_mult_gate != 0:          ; gate = 100>>count; skip if count>=7
 *        factor = 8 >> num_other_EU  ; recomputed at @asm 03A8B4
 *        raw = raw × (8 + factor) / 8  ; @asm 03A8C0..03A8DD (32-bit mul; sar×3)
 *    return raw in AX  (@asm 03A9BA)
 *
 *  0x5382 flag bits used:  &1 = independence declared;  &2 = congress progress active;
 *                           &8 = revolution/war underway;  &0x10 = independence won.
 * ---------------------------------------------------------------------------- */
extern int raw_power_score(int arg);   /* func_039EE2 — body BYTE_VERIFIED (structure) */

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
 *  the EXE; human-readable rank names are RUNTIME_ONLY (read from GAME.TXT).
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
 *  whose body is BYTE_VERIFIED as func_039EE2; see raw_power_score above.)
 * ---------------------------------------------------------------------------- */
int32_t power_current_gold(int power_idx)
{
    /* @asm PowerRecord+0x2A, base 0x8808, stride 0x13C  [BYTE_VERIFIED field] */
    extern uint8_t g_power_table[];     /* DGROUP:0x8808 */
    return *(int32_t *)(g_power_table + power_idx * POWER_RECORD_STRIDE + 0x2A);
}
