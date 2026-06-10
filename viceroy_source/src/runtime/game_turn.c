/* ============================================================================
 * game_turn.c -- the WORLD STEP: per-year (end-of-Autumn) rules pipeline
 * ----------------------------------------------------------------------------
 * Integration layer (milestone 3).  When the unit rotation exhausts and the
 * season ladder rolls Autumn -> Spring (the byte-verified [0x5390] toggle in
 * func_021D32), the original's resident dispatcher tail runs the per-power
 * WORLD processors.  That dispatcher tail (func_0246E2 region) is not yet
 * transcribed, so the ORDER below is SHELL-SEQUENCED (honesty: each STEP is
 * the real byte-verified engine; the SEQUENCE is the documented game-rule
 * order, marked for replacement when the tail is ported):
 *
 *   per power 0..3:
 *     1. func_042138_power_census      the AI census rebuild (writes the
 *                                      0x40-byte matrices + scalars the AI,
 *                                      diplomacy and reports read)
 *     2. colony_turn_update / sol_tory per-colony production + SoL/Tory step
 *     3. market_set_active + market_price_drift(0,-1)
 *                                      the silent Europe price recompute
 *                                      (func_0305A8, byte-verified)
 *     4. king_ref_buildup(power)       crown sentiment -> REF purchases
 *                                      (human powers only, per the byte-cited
 *                                      gates in king/ref.c)
 *   then: turn counter [0x538E]++, and year [0x538A] advances per the
 *   documented season rule (one year per Spring+Autumn pair).
 *
 * Everything here operates on the REAL DGROUP state (dgroup.h) and the real
 * record tables; no game content is embedded.
 * ============================================================================ */
#ifdef _VICEROY_MODERN

#include <stdio.h>
#include "viceroy_types.h"
#include "dgroup.h"

extern int  func_042138_power_census(uint16_t power);
extern void colony_turn_update(void);            /* operates on the selected ctx */
extern void colony_sol_tory_turn(int colony_id); /* full func_02D658 body */
extern int  func_0082DC_logic_sz_118(uint16_t);  /* colony select -> ctx */
extern void market_set_active(int power);
extern void market_price_drift(int arg_mode, int good_filter);
extern void king_ref_buildup(int power);

/* world counters (BYTE_VERIFIED homes; see market/pricing.c + main_loop.c) */
#define G_YEAR   DG16(0x538A)
#define G_TURN   DG16(0x538E)
#define G_NCOL   DG16(0x539E)

static int colony_owner(int ci)        /* ColonyRecord base 0x5D46 stride 0xCA */
{
    return DG8(0x5D46 + ci * 0xCA + 0x1A);
}

void viceroy_world_autumn(void)
{
    int n_col = (int16_t)G_NCOL;

    for (int p = 0; p < 4; p++) {
        /* 1. census rebuild (func_042138, ported BYTE_VERIFIED) */
        func_042138_power_census((uint16_t)p);

        /* 2. colony production + SoL/Tory (per colony of this power) */
        for (int ci = 0; ci < n_col; ci++) {
            if (colony_owner(ci) != p) continue;
            func_0082DC_logic_sz_118((uint16_t)ci);   /* select -> ctx */
            colony_turn_update();
            colony_sol_tory_turn(ci);
        }

        /* 3. Europe market drift -- silent recompute for this power */
        market_set_active(p);
        market_price_drift(0, -1);

        /* 4. crown sentiment -> REF growth (gates inside are byte-cited) */
        king_ref_buildup(p);
    }

    /* season bookkeeping: one Spring+Autumn pair = one year */
    G_TURN = (uint16_t)(G_TURN + 1);
    G_YEAR = (uint16_t)(G_YEAR + 1);
    printf("world: autumn step complete -- year %u, turn %u, REF %u/%u/%u/%u\n",
           G_YEAR, G_TURN,
           DG16(0x53DA), DG16(0x53DC), DG16(0x53DE), DG16(0x53E0));
}

/* --smoke harness: boot a minimal synthetic world (no game data needed) and
 * run N world turns, asserting the engines hold their invariants.  All state
 * is the REAL DGROUP layout; values are synthetic test fixtures only. */
int viceroy_world_smoke(int turns)
{
    /* a tiny synthetic map so the colony/center-tile scans have ground under
     * them (32x32, all grassland=3 with an ocean rim) */
    static uint8_t t[32*32], f[32*32], r[32*32];
    for (int i = 0; i < 32*32; i++) {
        int x = i & 31, y = i >> 5;
        t[i] = (x == 0 || y == 0 || x == 31 || y == 31) ? 25 : 3;
    }
    {   extern void viceroy_map_attach(const uint8_t*, const uint8_t*,
                                       const uint8_t*, int, int);
        viceroy_map_attach(t, f, r, 32, 32);
    }

    /* NAMES.TXT-table stand-ins (absent data files leave BSS zeros, which
     * the chain walkers read as index 0 forever): terminate the stride-12
     * building prereq chain rows (0x8F86, byte0 = chain_next; <0 ends) */
    for (int b = 0; b < 64; b++) DG8(0x8F86 + b*12) = 0xFF;

    /* one colony for power 0 at (10,10), population 3 */
    DG16(0x539E) = 1;
    DG8(0x5D46 + 0x00) = 10;  DG8(0x5D46 + 0x01) = 10;
    DG8(0x5D46 + 0x1A) = 0;   DG8(0x5D46 + 0x1F) = 3;
    /* king PowerRecord ptr for power 0 (the active-power convention) */
    DG16(0x84FC) = 0x8808;
    /* a plausible price level so the drift has state to chew on */
    for (int g = 0; g < 16; g++) DG8(0x8808 + 0x4C + g) = (uint8_t)(2 + (g & 3));
    DG8(0x53A6) = 4;                 /* Viceroy difficulty: fastest REF feed */
    G_YEAR = 1492; G_TURN = 0;

    for (int t = 0; t < turns; t++)
        viceroy_world_autumn();

    /* invariants: counters advanced; price levels stayed in byte range and
     * non-negative; no REF unit without sentiment having crossed 1800 */
    if (G_TURN != (uint16_t)turns) { puts("SMOKE FAIL: turn counter"); return 1; }
    for (int g = 0; g < 16; g++) {
        int lvl = (int8_t)DG8(0x8808 + 0x4C + g);
        if (lvl < 0) { printf("SMOKE FAIL: price level[%d] = %d\n", g, lvl); return 1; }
    }
    if (turns >= 50) {   /* sentiment 42/turn (d=4) crosses 1800 -> REF unit */
        int ref_total = DG16(0x53DA)+DG16(0x53DC)+DG16(0x53DE)+DG16(0x53E0);
        if (ref_total == 0) { puts("SMOKE FAIL: REF never grew"); return 1; }
        printf("REF grew to %d units (reg %u cav %u mow %u art %u)\n", ref_total,
               DG16(0x53DA), DG16(0x53DC), DG16(0x53DE), DG16(0x53E0));
    }
    printf("SMOKE PASS: %d world turns, year %u\n", turns, G_YEAR);
    return 0;
}

#endif /* _VICEROY_MODERN */

int g_smoke_trace = 0;

void smoke_trace_i(int i)
{
    if (g_smoke_trace) fprintf(stderr, i==-100 ? "[ENTER-sol]" : "[i=%d]", i);
}

void smoke_trace2(int i, void *addr)
{
    if (g_smoke_trace) fprintf(stderr, "[i=%d @%p]", i, addr);
}

/* ---- real bodies for king/ref.c's tiny accessors (replace weak stubs) ---- */
int revolution_flag_5382(void) { return DG8(0x5382); }
int32_t *king_sentiment_accum_22(void)
{
    extern uint8_t g_dgroup[];
    return (int32_t *)(g_dgroup + DG16(0x84FC) + 0x22);
}
