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
#include <string.h>
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

/* NATIVE AI UNIT TURNS: the per-unit native AI (native_unit_ai, full port)
 * runs for every tribe-owned unit (owner >= 4) with movement left.
 *
 * European AI unit dispatch is NOT here.  The real chain (decoded 2026-06-11,
 * ROUTE_B 1.6) is: func_005760 (main turn loop, PORTED) calls 0x181F:0x638 =
 * func_052F7E per AI slot ([0x543F+p*0x34]==1, @asm 0x0059EF/0x005A33); its
 * PHASE 6 marches each unit while the movement gate func_007A20 holds, through
 * func_051D56 -> unit_move_step / ai_unit_order_step.
 *
 * SHELL-SEQUENCED: native unit AI outer loop not yet located in the EXE.
 * The forward-scan, movement-gate loop below matches the byte-verified
 * entry order until the real native dispatcher is decoded. */
static void viceroy_native_unit_turns(void)
{
    extern int16_t native_unit_ai(int16_t self);
    int n = (int16_t)DG16(0x539C);
    for (int u = 0; u < n; u++) {
        int owner = DG8(0x3144 + u * 0x1C + 3) & 0x0F;
        /* (the old "+0x06 <= 0 -> no movement" gate here was a misread:
         * +0x06/0x314A is the HOME-SETTLEMENT LINK.  native_unit_ai's own
         * validity/cleanup checks gate the call; no shell pre-gate.) */
        if (owner >= 4)
            native_unit_ai((int16_t)u);
    }
}

/* TURN-HEAD MOVEMENT RESET: the original main turn loop zeroes every unit's
 * moves-used counter (+0x05, abs 0x3149) at the top of each interactive turn
 * (func_005760 @asm 0x005872: for u in 0..[0x539C): [u*0x1C+0x3149]=0).  This
 * is what re-opens the func_007A20 movement gate each turn. */
static void viceroy_turn_movement_reset(void)
{
    int n = (int16_t)DG16(0x539C);
    for (int u = 0; u < n; u++)
        DG8(0x3144 + u * 0x1C + 0x05) = 0;     /* @asm 0x005872 */
}

void viceroy_world_autumn(void)
{
    int n_col = (int16_t)G_NCOL;

    viceroy_turn_movement_reset();             /* @asm 0x005872 (func_005760 turn head) */
    viceroy_native_unit_turns();

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

        /* 5. royal-event cadence (human powers only; the gate is inside) */
        {   extern void king_demand_cadence(int power_id);
            king_demand_cadence(p);
        }

        /* 6. AI power turn: census + planners + PHASE-6 per-unit dispatch
         * (func_005760 calls 0x181F:0x638 = func_052F7E when the slot state
         * byte is exactly 1 — @asm 0x0059EF cmp [0x543F+p*0x34],1 / 0x005A33). */
        if (DG8(0x543F + p * 0x34) == 1) {
            extern int func_052F7E_ai_power_asset_census(uint16_t);
            func_052F7E_ai_power_asset_census((uint16_t)p);
        }
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

    /* @UNIT-table stand-ins (table 0x5234, stride 14; RUNTIME data from
     * NAMES.TXT/UNIT rows).  Column +0 = movement allowance: read by
     * func_006CCA and compared against moves-used (+0x05) by the dispatch
     * gate func_007A20 (0x181F:0x97A) — zero allowance keeps the PHASE-6
     * gate shut and no euro-AI unit would ever dispatch.  Column +9 bit0
     * (0x523D) gates the unit_move_step call inside func_051D56
     * (@asm 0x051D7D test [bx+0x523D],1). */
    DG8(0x5234 + 0x00*14 + 0) = 2;   /* type 0 (land):  2 moves */
    DG8(0x5234 + 0x0E*14 + 0) = 4;   /* type 0x0E ship: 4 moves */
    DG8(0x5234 + 0x00*14 + 9) |= 1;  /* unit_move_step eligible */
    DG8(0x5234 + 0x0E*14 + 9) |= 1;

    /* Compass delta tables DS:0xB4/0xBE (DGROUP-image data, zero without
     * VICEROY.EXE): the standard 8-neighbour steps N,NE,E,SE,S,SW,W,NW —
     * read by the march handler (func_040E22 @asm 0x040E83/0x040EA6) and
     * automove (func_062D84). */
    {
        static const int8_t dx8[8] = { 0, 1, 1, 1, 0,-1,-1,-1 };
        static const int8_t dy8[8] = {-1,-1, 0, 1, 1, 1, 0,-1 };
        for (int d = 0; d < 8; d++) {
            DG8(0xB4 + d) = (uint8_t)dx8[d];
            DG8(0xBE + d) = (uint8_t)dy8[d];
        }
    }

    /* one colony for power 0 at (10,10), population 3 */
    DG16(0x539E) = 1;
    DG8(0x5D46 + 0x00) = 10;  DG8(0x5D46 + 0x01) = 10;
    DG8(0x5D46 + 0x1A) = 0;   DG8(0x5D46 + 0x1F) = 3;
    /* king PowerRecord ptr for power 0 (the active-power convention) */
    DG16(0x84FC) = 0x8808;
    /* Founding-Father init (game-init parity for the wired bells tick):
     * pending-FF slot (+0x12) starts "none" = 0xFFFF (the acquire path
     * writes the same sentinel @asm 0x3BD3A), and the per-FF first-owner
     * table is 0xFF-filled (func_0757C4: memset 0x53A9,0xFF,25). */
    for (int p = 0; p < 4; p++)
        DG16(0x8808 + p*0x13C + 0x12) = 0xFFFF;
    for (int q = 0; q < 25; q++) DG8(0x53A9 + q) = 0xFF;   /* @asm func_0757C4 */
    /* a plausible price level so the drift has state to chew on */
    for (int g = 0; g < 16; g++) DG8(0x8808 + 0x4C + g) = (uint8_t)(2 + (g & 3));
    DG8(0x53A6) = 4;                 /* Viceroy difficulty: fastest REF feed */
    G_YEAR = 1492; G_TURN = 0;

    /* a native brave (tribe 4) two tiles from the colony, homed to a real
     * settlement.  +0x06 (0x314A) is the HOME-SETTLEMENT LINK (the byte-true
     * meaning — the pre-1.6 shell misread it as "moves left"): native_unit_ai
     * destroys any tribe unit whose link is invalid (@asm 0x047128 ->
     * 0x181F:0x808 off-map cleanup), so the fixture supplies settlement 0. */
    DG16(0x539C) = 1;
    DG8(0x3144 + 0) = 12; DG8(0x3144 + 1) = 10;   /* x,y */
    DG8(0x3144 + 2) = 0;                          /* type: brave-ish */
    DG8(0x3144 + 3) = 4;                          /* owner nibble = tribe 4 */
    DG8(0x3144 + 6) = 0;                          /* home settlement link = 0 */
    DG16(0x3144 + 0x18) = 0xFFFF;                 /* on-map gate */
    DG16(0x3144 + 0x1A) = 0xFFFF;                 /* chain terminator */
    {   extern void tilehead_set(int,int,int);
        tilehead_set(12, 10, 0); }
    /* NativeSettlement[0] @0x54EC (stride 0x12): x,y at +0/+1 (cites in
     * native_unit_ai.c @asm 0x047153/0x04715F home-distance reads). */
    DG16(0x539A) = 1;                             /* native settlement count */
    DG8(0x54EC + 0) = 14; DG8(0x54EC + 1) = 10;   /* settlement at (14,10) */

    /* ---- European-AI fixture: three power-1 units exercising the 0x4E2D6
     * EXIT TAIL (unit/move.c move_eval_tail_51C68) through the autumn loop:
     *   unit 1 (20,20) orders 0  -> auto-sentry, then WAKE each turn on the
     *          at-war occupant painted at (21,20)
     *   unit 2 (25,25) orders 0  -> auto-sentry, no neighbours -> stays 5
     *   unit 3 (5,5)   ship band (type 0x0E), orders 0x0B with dest==pos
     *          -> goto-arrival promotes prof 0x31 -> 0x42 ('B')           */
    {
        extern void tilehead_set(int,int,int);
        extern uint8_t *viceroy_layer_addr(int layer, int x, int y);
        #define UREC(i,k) DG8(0x3144 + (i)*0x1C + (k))
        DG8(0x543F + 1*0x34) = 1;            /* power 1 is an AI power */
        DG16(0x539C) = 4;
        for (int u = 1; u <= 3; u++) {
            DG16(0x3144 + u*0x1C + 0x18) = 0xFFFF;
            DG16(0x3144 + u*0x1C + 0x1A) = 0xFFFF;
            UREC(u, 3) = 1;  UREC(u, 6) = 1;  /* owner 1, one move */
        }
        UREC(1,0) = 20; UREC(1,1) = 20; UREC(1,2) = 0;
        UREC(1,7) = 0;  UREC(1,8) = 0;                    tilehead_set(20,20,1);
        UREC(2,0) = 25; UREC(2,1) = 25; UREC(2,2) = 0;
        UREC(2,7) = 0;  UREC(2,8) = 0;                    tilehead_set(25,25,2);
        UREC(3,0) = 5;  UREC(3,1) = 5;  UREC(3,2) = 0x0E; /* ship band */
        UREC(3,7) = 0x31; UREC(3,8) = 0x0B;               /* goto, in flight */
        UREC(3,9) = 8;  UREC(3,0x0A) = 5;                 /* dest (8,5): 3 east */
        tilehead_set(5,5,3);
        /* the at-war occupant at (21,20): the wake probe (0x181F:0x696 ->
         * func_005F48) reads ONLY the map layers, so paint the occupancy
         * directly -- layer-160 bit1 (host layer 1, now a platform working
         * copy, so write through viceroy_layer_addr) + layer-164 high
         * nibble = power 2 (host layer 3, the writable region buffer) */
        *viceroy_layer_addr(1, 21, 20) |= 2;
        *viceroy_layer_addr(3, 21, 20) |= (uint8_t)(2 << 4);
        /* power 1 at war with power 2: relations byte (func_007F34 model:
         * PowerRecord[1]+0x34[2]) bit 0x40 */
        DG8(0x8808 + 1*0x13C + 0x34 + 2) |= 0x40;
    }

    /* ---- GATE-G1 SOAK INSTRUMENTATION (harness-side only) ----
     * Per euro-AI unit-turn, diff (pos, state, moves-used) across the world
     * step and tally the outcome class.  The engines are untouched; this is
     * the "AI move distribution sanity report" required by Gate G1. */
    {
        unsigned long d_moved = 0, d_restate = 0, d_exhaust = 0, d_idle = 0;
        for (int t = 0; t < turns; t++) {
            uint8_t pre[4][4];
            int n = (int16_t)DG16(0x539C);
            if (n > 4) n = 4;
            for (int u = 0; u < n; u++) {
                pre[u][0] = DG8(0x3144 + u*0x1C + 0);   /* x  */
                pre[u][1] = DG8(0x3144 + u*0x1C + 1);   /* y  */
                pre[u][2] = DG8(0x3144 + u*0x1C + 8);   /* state */
                pre[u][3] = DG8(0x3144 + u*0x1C + 5);   /* moves-used */
            }
            viceroy_world_autumn();
            for (int u = 0; u < n; u++) {
                if ((DG8(0x3144 + u*0x1C + 3) & 0x0F) != 1)
                    continue;                            /* euro-AI power only */
                if (pre[u][0] != DG8(0x3144 + u*0x1C + 0) ||
                    pre[u][1] != DG8(0x3144 + u*0x1C + 1))      d_moved++;
                else if (pre[u][2] != DG8(0x3144 + u*0x1C + 8)) d_restate++;
                else if (pre[u][3] != DG8(0x3144 + u*0x1C + 5)) d_exhaust++;
                else                                            d_idle++;
            }
        }
        printf("AI distribution (%d turns x 3 euro units): moved %lu, "
               "re-stated %lu, exhausted-in-place %lu, idle %lu\n",
               turns, d_moved, d_restate, d_exhaust, d_idle);
    }

    /* ---- EURO-AI END-STATE BASELINE (re-derived 2026-06-11, PLANNERS LIVE:
     * 7ADF queue rebuild + 7AB2 strategic plan with the byte-restored per-unit
     * loop, PHASE-6/7 slot capture, and the byte-true target probe
     * func_04CAF6/func_04CA86 — the old 3-arg "provocative" port had the
     * EU-power arm INVERTED: code < 4 RETURNS the code @asm 0x04CA8F ->
     * 0x04CAEA, it is not -1).  Derived per-turn flow, all cited:
     *   u1 (type 0, (20,20)): the plan loop resets any stale state
     *     (@0x4CF40 >= 0xA && prof != '1' -> 0), then the 8-neighbour probe
     *     finds the power-2 claim painted at (21,20): func_005FD4 returns
     *     owner 2, func_04CA86(1,2,1,-1) -> 2 (EU code = always target) ->
     *     state 0xA (@0x4CF73).  A REAL target acquisition.  The dispatcher
     *     then end-turns state-0xA units (051D56 switch sel 3 -> 0x934).
     *     END: orders 0x0A, prof 0.
     *   u2 (type 0, (25,25)): no foreign neighbours -> chosen -1, state
     *     stays 0; PHASE-6 prologue stamps prof '?' (@0x4E202 state < 0xA);
     *     QUEUE_A is empty on this fixture (no emits) so the slot loop
     *     assigns nothing.  END: orders 0, prof 0x3F.
     *   u3 (ship 0x0E, goto (8,5), prof '1'): exempt from the state reset
     *     (@0x4CF47 prof == 0x31) and from PHASE-6 (state 0x0B not in
     *     {0,5,6} @0x4E20C); the dispatcher marches it through
     *     ai_unit_order_step + the stuck-tracker as before.
     *     END: orders 0x0B, prof 0x31.
     * March fidelity (positions) still pends the eval/plotter leaf audit. */
    {
        printf("euro-AI end-state: u1 o=%02X p=%02X d=(%d,%d)  "
               "u2 o=%02X p=%02X d=(%d,%d)  u3 o=%02X p=%02X\n",
               UREC(1,8), UREC(1,7), UREC(1,9), UREC(1,0x0A),
               UREC(2,8), UREC(2,7), UREC(2,9), UREC(2,0x0A),
               UREC(3,8), UREC(3,7));
        if (!(UREC(1,8) == 0x0A && UREC(1,7) == 0)) {
            printf("SMOKE FAIL: u1 target-acquire baseline (orders %02X prof %02X)\n",
                   UREC(1,8), UREC(1,7));
            return 1;
        }
        if (!(UREC(2,8) == 0 && UREC(2,7) == 0x3F)) {
            printf("SMOKE FAIL: u2 idle baseline (orders %02X prof %02X)\n",
                   UREC(2,8), UREC(2,7));
            return 1;
        }
        if (!(UREC(3,8) == 0x0B && UREC(3,7) == 0x31)) {
            printf("SMOKE FAIL: u3 in-flight baseline (orders %02X prof %02X)\n",
                   UREC(3,8), UREC(3,7));
            return 1;
        }
        puts("euro-AI baseline: planner live — u1 real target 0xA, u2 idle '?', u3 in-flight hold");
        #undef UREC
    }

    /* invariants: counters advanced; price levels stayed in byte range and
     * non-negative; no REF unit without sentiment having crossed 1800 */
    if (G_TURN != (uint16_t)turns) { puts("SMOKE FAIL: turn counter"); return 1; }
    for (int g = 0; g < 16; g++) {
        int lvl = (int8_t)DG8(0x8808 + 0x4C + g);
        if (lvl < 0) { printf("SMOKE FAIL: price level[%d] = %d\n", g, lvl); return 1; }
    }
    /* ---- ECONOMY ASSERTION: the decoded trade formulas on live state ----
     * bid = level-1; gross = bid*100; tax = gross*rate/100; net to gold;
     * tax into the crown pool king[+0x22] (the REF feed). */
    {
        extern void market_set_active(int power);
        extern long market_sell(int good, int qty);
        extern int  market_bid_price(int good);
        extern uint8_t g_dgroup[];
        market_set_active(0);
        DG8(0x8808 + 1) = 10;                      /* tax rate 10% */
        DG8(0x8808 + 0x4C + 0) = 6;                /* level 6 -> bid 5 */
        int32_t *gold  = (int32_t *)(g_dgroup + 0x8808 + 0x2A);
        int32_t *crown = (int32_t *)(g_dgroup + 0x8808 + 0x22);
        int32_t g0 = *gold, c0 = *crown;
        int bid = market_bid_price(0);
        long net = market_sell(0, 100);
        long gross = (long)bid * 100, tax = gross * 10 / 100;
        if (bid != 5 || net != gross - tax || *gold - g0 != net ||
            *crown - c0 != tax) {
            printf("SMOKE FAIL: economy (bid=%d net=%ld gold+%d)\n",
                   bid, net, *gold - g0);
            return 1;
        }
        printf("economy: sold 100 @ bid %d -> gross %ld, tax %ld, net %ld "
               "(crown +%d)\n", bid, gross, tax, net, *crown - c0);
    }

    /* ---- SAVE/LOAD ROUND-TRIP against the ORIGINAL format ---- */
    {
        extern int save_game_state(const char *path);
        extern int load_savegame(const char *path);
        extern uint8_t g_dgroup[];
        static uint8_t snap[0x200];
        memcpy(snap, g_dgroup + 0x8808, 0x200);        /* PowerRecord 0 window */
        uint16_t y0 = G_YEAR;
        if (save_game_state("/tmp/viceroy_smoke.sav") != 0) {
            puts("SMOKE FAIL: save_game_state");
            return 1;
        }
        memset(g_dgroup + 0x8808, 0xAA, 0x200);        /* trash it */
        G_YEAR = 1;
        if (load_savegame("/tmp/viceroy_smoke.sav") != 0) {
            puts("SMOKE FAIL: load_savegame");
            return 1;
        }
        if (memcmp(snap, g_dgroup + 0x8808, 0x200) != 0 || G_YEAR != y0) {
            int bad = -1;
            for (int k = 0; k < 0x200; k++)
                if (snap[k] != g_dgroup[0x8808 + k]) { bad = k; break; }
            printf("SMOKE FAIL: round-trip mismatch (first byte +0x%X: %02X->%02X; year %u vs %u)\n",
                   bad, bad>=0?snap[bad]:0, bad>=0?g_dgroup[0x8808+bad]:0, y0, G_YEAR);
            return 1;
        }
        printf("save/load: %u-byte PowerRecord window + year survive the "
               "original-format round-trip\n", 0x200);
        remove("/tmp/viceroy_smoke.sav");
    }

    /* Combat exercise (real-data validation of the ported resolver func_05B2C2
     * = combat_resolve, reached through the page-10 trampoline func_05E723).
     * Runs after the soak so the REF baseline is untouched; its stub hits (if
     * any) are caught by the stub-report below. */
    {
        extern int func_05E723(int start_idx, int defender, int show_ui, int x, int y);
        (void)func_05E723(1, 0, 0, 12, 10);   /* power-1 unit vs tribe-4 brave @ (12,10) */
        /* combat_resolve returns 1 on every path (it means "resolved", not "who
         * won"). The validation point: the wired trampolic resolver runs on real
         * data through the odds roll + demote ladder; the stub-report below names
         * the two consequence appliers it reaches (the next combat-porting gap). */
        printf("combat: func_05E723 resolver ran on real data (consequence layer reached)\n");
    }

    if (turns >= 50) {   /* sentiment 42/turn (d=4) crosses 1800 -> REF unit */
        int ref_total = DG16(0x53DA)+DG16(0x53DC)+DG16(0x53DE)+DG16(0x53E0);
        if (ref_total == 0) { puts("SMOKE FAIL: REF never grew"); return 1; }
        printf("REF grew to %d units (reg %u cav %u mow %u art %u)\n", ref_total,
               DG16(0x53DA), DG16(0x53DC), DG16(0x53DE), DG16(0x53E0));
    }
    /* Gate-G1 stub-hit table: which unported leaves the soak actually
     * reached (tools/stub_hits.c; counter bumped by every generated weak
     * stub).  The gate demands ZERO hits for AI-ENGINE symbols; remaining
     * rows are the ranked Phase-4 wiring worklist. */
    {   extern int viceroy_stub_report(void);
        viceroy_stub_report();
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
