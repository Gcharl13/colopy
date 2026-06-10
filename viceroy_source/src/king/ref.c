/* ============================================================================
 *           >>> ROYAL EXPEDITIONARY FORCE (REF) — BYTE_VERIFIED <<<
 * ----------------------------------------------------------------------------
 * The REF composition array, its initial values at the start of the War of
 * Independence, and the per-event buildup (which arm grows, by how much, and
 * the rebel-sentiment accumulator that triggers it) are byte-traced against
 * VICEROY.EXE.  Deployment/landing-site selection is NOT byte-traced (not yet decoded).
 *
 * REF COMPOSITION — 4 contiguous words at DGROUP:0x53DA (BYTE_VERIFIED;
 *                   matches user runtime ground-truth and memory note):
 *   slot 0  0x53DA  Regulars
 *   slot 1  0x53DC  Cavalry / Dragoons
 *   slot 2  0x53DE  Man-O-War
 *   slot 3  0x53E0  Artillery
 *   NOTE the order: Man-O-War is slot 2, Artillery is slot 3.
 *
 * @verified_by  Hand-decompiled 2026-05-29 from the re-segmented overlay dump
 *               (reverse_engineered/code/VICEROY/disasm_overlay_reseg/).
 * ============================================================================ */
#include "viceroy_types.h"
#include "power.h"

/* REF arms — DGROUP words (BYTE_VERIFIED addresses). */
extern int16_t g_ref_regulars_53DA;   /* DGROUP:0x53DA */
extern int16_t g_ref_cavalry_53DC;    /* DGROUP:0x53DC */
extern int16_t g_ref_manowar_53DE;    /* DGROUP:0x53DE */
extern int16_t g_ref_artillery_53E0;  /* DGROUP:0x53E0 */
#define REF_SLOT(n) (*(&g_ref_regulars_53DA + (n)))   /* slot 0..3 -> 0x53DA..0x53E0 */

extern uint8_t  g_difficulty_53A6;     /* DGROUP:0x53A6 — difficulty 0..4 */
extern int16_t  g_year_538A;           /* DGROUP:0x538A — current year (e.g. 1492..) */
extern void *   g_king_record_84FC;    /* DGROUP:0x84FC — far ptr to king PowerRecord;
                                        * rebel-sentiment accumulator is the dword at +0x22 */

/* ============================================================================
 * king_ref_init — BYTE_VERIFIED
 *
 * @asm  inside the "declare War of Independence" handler in page_1A
 *       (file ~0x07569B..0x0756D4).  Computed purely from difficulty
 *       d = [0x53A6]:
 *
 *   @asm 0x0756A2  Regulars  = (d << 3) + 0x0F      = d*8 + 15
 *   @asm 0x0756B5  Cavalry   = (d + 1) * 5          = 5d + 5
 *   @asm 0x0756C5  Artillery = d*6 + 2
 *   @asm 0x0756D0  Man-O-War = d*3 + 2
 *
 * (Just before this, file 0x075671 zeroes the 4-word REF array and the
 *  adjacent 0x53E2 array; file 0x075645 fills a 16-word table @0x53EA with
 *  random_int(0x258,0x3E8) = random(600,1000).  RESOLVED: 0x53EA is the
 *  market price_seed[16] — per-good base European supply seed, read by the
 *  market drift @0x0305B3 and decayed @0x030639; see src/market/pricing.c.)
 *
 * Initial REF by difficulty (Discoverer..Viceroy, d = 0..4):
 *   d=0:  Reg=15  Cav=5   Art=2   MoW=2
 *   d=1:  Reg=23  Cav=10  Art=8   MoW=5
 *   d=2:  Reg=31  Cav=15  Art=14  MoW=8
 *   d=3:  Reg=39  Cav=20  Art=20  MoW=11
 *   d=4:  Reg=47  Cav=25  Art=26  MoW=14
 *
 * The user's observed in-game (Reg=23, Cav=10, Art=8, MoW=5) is the d=1
 * (Explorer) initial composition — an EXACT match, which both confirms the
 * formula and pins the slot order.
 * ============================================================================ */
void king_ref_init(void)
{
    int d = g_difficulty_53A6;
    g_ref_regulars_53DA  = d * 8 + 15;   /* @asm 0x0756A2 */
    g_ref_cavalry_53DC   = (d + 1) * 5;  /* @asm 0x0756B5 */
    g_ref_artillery_53E0 = d * 6 + 2;    /* @asm 0x0756C5 */
    g_ref_manowar_53DE   = d * 3 + 2;    /* @asm 0x0756D0 */
}

/* ============================================================================
 * king_ref_buildup — BYTE_VERIFIED
 *
 * @asm_function  func_03E162  (file 0x03E162..0x03E288, 391 bytes)
 * @asm_disasm    disasm_overlay_reseg/page_06.asm (page 0x06, code_base 0x3A...).
 *
 * Called when the active power generates rebel sentiment (after the revolution
 * flag, [0x5382] bit 0, is NOT yet set).  It accrues "sentiment points" into a
 * 32-bit accumulator in the king's record (+0x22) and, each time the
 * accumulator crosses 0x708 (1800), adds ONE unit to whichever REF arm is
 * furthest below its target ratio.
 *
 * STEP 1 — point increment (scaled by difficulty and era):
 *   @asm 0x03E17C  inc = (difficulty << 3) + 0x0A          = d*8 + 10
 *   @asm 0x03E18A  if (year >= 0x640 / 1600)  inc *= 2
 *   @asm 0x03E197  if (year >= 0x6A4 / 1700)  inc *= 2
 *   @asm 0x03E1A2  if (year >= 0x6D6 / 1750)  inc *= 2      (up to *8 late game)
 *   @asm 0x03E1B5  king[+0x22] (dword) += inc
 *   @asm 0x03E1C6  if (king[+0x22] < 0x708) return          ; below threshold
 *
 * STEP 2 — pick the arm to grow (keep target ratios):
 *   @asm 0x03E1D5  slot = 0 (Regulars) by default
 *   @asm 0x03E1E0  if ((Reg+2)/3   > Cavalry)   slot = 1
 *   @asm 0x03E1FA  if ( Reg/4       > Artillery) slot = 3
 *   @asm 0x03E217  if ((Reg+Cav+Art+5)/10 > ManOWar) slot = 2
 *     i.e. target Cav ~= Reg/3, Art ~= Reg/4, MoW ~= total/10.
 *
 * STEP 3 — add the unit and consume the points:
 *   @asm 0x03E22A  pick a concrete unit type for the slot (CALL near 0x3690)
 *   @asm 0x03E238  inc word [slot*2 + 0x53DA]               ; the REF arm++
 *   @asm 0x03E271  king[+0x22] -= 0x708                     ; consume threshold
 *   @asm 0x03E283  king[+0xE]  += unit_cost([type-0x6BF8])  ; running REF "value"
 *
 * This is why a single Boston Tea Party at low rebel sentiment does NOT grow
 * the REF: one event adds only d*8+10 points (≥ era multiplier), far short of
 * the 1800-point threshold for a unit.
 *
 * +0x22 IDENTITY ENRICHED 2026-06-10: the same dword is the king's CROWN-
 * REVENUE pool, fed by THREE byte-verified writers:
 *   1. this per-turn sentiment increment (d*8+10, era-doubled)   @0x03E1B5
 *   2. TAX COLLECTED on every Europe sale: king[+0x22] += gross*tax%/100
 *      (market sell executor func_032914 @0x032A92 — see market/pricing.c)
 *   3. BOYCOTT back-taxes: += ask*500 on a boycott lift (func_03334E
 *      @0x033413) and the boycott-accept path
 * REF units are "bought" from this pool at 1800/unit — i.e. the more tax the
 * crown actually collects, the faster the Royal Expeditionary Force grows.
 * ============================================================================ */
extern int      revolution_flag_5382(void);    /* DGROUP:0x5382 bit 0 = at war */
extern int32_t *king_sentiment_accum_22(void); /* &king_record[0x22] (dword) */
extern void     king_register_ref_unit(int slot);

void king_ref_buildup(int active_power)
{
    (void)active_power;

    /* @asm 0x03E172 — only accrues before the revolution flag is set. */
    if (revolution_flag_5382() & 1) return;

    /* STEP 1 — @asm 0x03E17C..0x03E1AC */
    int32_t inc = (int32_t)g_difficulty_53A6 * 8 + 10;
    if (g_year_538A >= 0x640) inc *= 2;   /* 1600 */
    if (g_year_538A >= 0x6A4) inc *= 2;   /* 1700 */
    if (g_year_538A >= 0x6D6) inc *= 2;   /* 1750 */

    int32_t *accum = king_sentiment_accum_22();   /* king[+0x22] dword */
    *accum += inc;
    if (*accum < 0x708) return;                   /* @asm 0x03E1C6 threshold */

    /* STEP 2 — pick the arm furthest below its ratio (@asm 0x03E1D5..0x03E21D) */
    int reg = g_ref_regulars_53DA;
    int cav = g_ref_cavalry_53DC;
    int art = g_ref_artillery_53E0;
    int mow = g_ref_manowar_53DE;

    int slot = 0;                                       /* Regulars */
    if ((reg + 2) / 3 > cav)                  slot = 1; /* Cavalry  */
    if (reg / 4       > art)                  slot = 3; /* Artillery */
    if ((reg + cav + art + 5) / 10 > mow)     slot = 2; /* Man-O-War */

    /* STEP 3 — add the unit, consume 0x708 points (@asm 0x03E238..0x03E283) */
    REF_SLOT(slot) += 1;
    *accum -= 0x708;
    king_register_ref_unit(slot);   /* CALL near 0x3690 + king[+0xE] += cost */
}

/* ============================================================================
 *        REF STRENGTH / WAR-END / SECOND ARMY — BYTE_VERIFIED 2026-06-10
 * ----------------------------------------------------------------------------
 * The old "ref_effective_strength" reconstruction (weighted 2/3/4/6 sum with
 * FF/SoL modifiers) was FICTION and is DELETED: no weighted REF strength
 * exists anywhere in VICEROY.EXE.  The byte-verified reality:
 *
 * 1. DISPLAY (Continental Congress report, func_037A10 @0x037D8A..0x037E5B):
 *    raw counts only.  total = sum REF[0..3] (0x53DA row) + sum SECOND-ARMY
 *    [0..3] (0x53E2 row); each arm rendered as <icon> x count via
 *    0x181F:0x222 (sprites [0x5286]/[0x52A2]/[0x52CC]/[0x532E]).
 *
 * 2. WAR-END TEST (func_03E442 @0x03E471..0x03E4B1, the intervention-power
 *    turn): the war is LOST by the crown when
 *        regulars(0x53DA) + (cavalry(0x53DC) > 0) + (artillery(0x53E0) > 0)
 *    == 0 - i.e. land arms exhausted; MAN-O-WARS DO NOT SUSTAIN THE WAR.
 *    Non-zero -> near 0x3EA3D(rebel) war continues; zero -> near 0x3EA47
 *    (rebel) victory path.
 *
 * 3. MERCENARY OFFER (same func_03E442 @0x03E4E8..0x03E65C): each aid turn,
 *    if random(0,2)==0:
 *        n_regulars = random(2, 2 + (4-difficulty)/2)
 *        coin-flip: offer also includes 1 cavalry OR 1 artillery
 *        unit_price = ((difficulty+3)*2 + random(0,6)) * 100
 *        total = (n + 2*(has_cav + has_art)) * unit_price
 *    affordable -> show "MERCENARIES" (key 0x1340 -> file 0x1ECE0, dumped);
 *    accept (==2) -> gold -= total, near 0x3EA42(1) spawns them.
 *
 * 4. SECOND 4-WORD ARMY at 0x53E2/0x53E4/0x53E6/0x53E8 (the array zeroed
 *    beside the REF at init): the TORY / loyalist-intervention force,
 *    GENERATED at war time by func_03DE46 @0x03DF2C..0x03DFF9 from the
 *    REBEL'S OWN CENSUS (power index [0x53D4]):
 *        Reg(0x53E2) = pop[0x9410]/10 - difficulty + 8
 *        Cav(0x53E4) = (cargo_total[0x942C]+1)/16 + (4-difficulty)/2 + 1
 *        MoW(0x53E6) = (4-difficulty)/2 + colonyrow_sum[0x925C/D] + 3
 *        Art(0x53E8) = (4-difficulty)/2 + (finance[0x941C]+1)/32 + 3
 *    then ALL FOUR are round-up halved ((x+1)/2) and capped:
 *        Art <= 2*MoW;  Cav <= 2*MoW;  Reg <= 6*MoW - Art - Cav
 *    (census tables are the per-power AI census - see diplomacy/meeting.c.)
 *    Losses: func_03D510 decrements 0x53E2-row words as those units land/die
 *    (@0x03D8AF dec word [bx+0x53E2]).
 *
 * 5. LANDING (func_03CDA2): per-arm decrement @0x03D4C0 (dec [bx+0x53DA]);
 *    spawned via 0x181F:0x9BA with the colony coords; on the FINAL WAVE
 *    ([bp-6] set) all four 0x53DA words are zeroed (@0x03D4FE loop) - the
 *    crown commits everything.  Landing eligibility/budget is the
 *    war_turn.c matrix (king[+0x19]/[+0x1A], budget=(8-difficulty)*10).
 * ============================================================================ */
/* (ref_effective_strength deleted - no such concept in the original binary.) */
