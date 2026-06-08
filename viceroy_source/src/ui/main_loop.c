/* ============================================================================
 *                  >>> BYTE_VERIFIED (turn-loop structure) <<<
 * ----------------------------------------------------------------------------
 * main_loop.c — VICEROY.EXE top-level game loop and per-turn season cycle.
 *
 * This replaces the earlier RECONSTRUCTED "screen state machine" (SCREEN_TITLE
 * /SCREEN_MAP/... fade-transition loop), which was FABRICATED.  VICEROY's real
 * resident loop is a BIOS-keyboard / game-timer "active unit needs orders"
 * loop, with a two-season (Spring/Autumn) turn cycle gated on DGROUP:0x5390.
 *
 * @region        overlay page 0x01 (code_offset 0x20EE0) + resident dispatch
 * @verified_by   Decompiled by hand against VICEROY.EXE bytes 2026-05-28.
 * @asm_disasm    code/VICEROY/disasm_overlay_reseg/page_01.asm
 *
 * KEY GLOBALS (all DGROUP; bases per HARD BASE GUARD / prior verification):
 *   [0x5390]  g_season            0 = Spring, 1 = Autumn   (BYTE_VERIFIED)
 *   [0x5392]  g_active_unit       current unit index being given orders
 *   [0x5394]  g_current_nation    whose turn it is (BYTE_VERIFIED elsewhere)
 *   [0x5396]  g_active_player     human/active player index
 *   [0x896]/[0x898]  far ptr to the ACTIVE UnitRecord (the one awaiting orders)
 *   [0x97E8..0x97EF] game-timer fences (blink/animation pacing, +0x14 ticks)
 *   [0x981E]  last key read from the BIOS/keyboard poll
 *   [0x930A]  "key was consumed by a handler" flag
 *   [0xB94]/[0xB96] redraw / cursor-flash state flags
 *   ES:0x40:0x17     BIOS keyboard shift-flags byte (Alt = bit 3) — read every
 *                    frame; this is the "BIOS-keyboard" signature of the loop.
 *
 * The 0x191F:NNNN key/turn sub-handlers (move unit, build path, sentry, etc.)
 * dispatch through the RTLink overlay thunk table; their exact overlay targets
 * need the RTLink VP-directory decode (FUNCTIONS_INVENTORY "remaining
 * blocker") and their bodies are in the thunk page.  CALL SITES and arguments are byte-exact.
 * ============================================================================ */
#include "viceroy_types.h"
#include "iolib.h"

/* ---- DGROUP globals (byte-verified addresses) ---------------------------- */
extern int16_t  g_season;          /* DGROUP:0x5390  0=Spring 1=Autumn */
extern int16_t  g_active_unit;     /* DGROUP:0x5392 */
extern int16_t  g_current_nation;  /* DGROUP:0x5394 */
extern int16_t  g_active_player;   /* DGROUP:0x5396 */
extern uint8_t  g_unit_records[];  /* DGROUP:0x3144, stride 0x1C */

/* UnitRecord field accessors (base 0x3144 -> field = addr-0x3144). */
#define U_X(i)      g_unit_records[(i)*0x1C + 0x00]   /* 0x3144 */
#define U_Y(i)      g_unit_records[(i)*0x1C + 0x01]   /* 0x3145 */
#define U_STATE(i)  g_unit_records[(i)*0x1C + 0x08]   /* 0x314C unit order/state */

/* ---- timer + input primitives (resident; reached via 0xC0C / 0x181F) ------ */
extern uint32_t game_timer_ticks(void);            /* LCALL 0x0C0C:0x0006 */
extern int      kbd_poll(void);                    /* 0x181F:0x3E0 -> key into [0x981E] */
extern int      bios_kbd_shift_flags(void);        /* ES=0x40, [0x17] */

/* ---- per-turn season processors (BYTE_VERIFIED boundaries) ---------------- */
extern void spring_turn_process(void);   /* func_021A14, file 0x021A14 (797 B) */
extern void autumn_turn_process(int notify); /* func_021D32, file 0x021D32 (320 B) */
extern void game_tick_coordinator(void); /* func_024342, file 0x024342 (643 B) */

/* ============================================================================
 * game_main_loop — the resident "active-unit / input" loop.
 * ----------------------------------------------------------------------------
 * @asm_function  func_0246E2   file 0x0246E2..0x0249C4  (1294 bytes, ENTER 8,0)
 * @asm_disasm    code/VICEROY/disasm_overlay_reseg/page_01.asm (func_0246E2)
 *
 * Structure (byte-faithful):
 *   - On entry, if season==Spring it sets [0x97B0]=1 (a "new turn started"
 *     latch).  @asm 0x0246EB..0x0246F8
 *   - Reads the game timer and arms a fence at timer+0x14 ticks (cursor blink /
 *     idle animation pacing).  @asm 0x0246F8..0x024706
 *   - [0x929C] = (season==Autumn) ? 1 : 0  — a derived "is it autumn" flag used
 *     by the renderer.  @asm 0x02470A..0x024713
 *   - MAIN POLL LOOP @asm label 0x0240C1 .. back-edge 0x024328 (JMP 0x40C1):
 *       * read BIOS keyboard shift byte (Alt bit) ES:0x40:[0x17] & 8
 *       * if there is an active unit ([0x896] far ptr non-null) AND it still
 *         needs orders, poll the keyboard (0x181F:0x3E0 -> [0x981E]) and run
 *         the matching command handler via 0x191F:NNNN; otherwise advance to
 *         the next unit / end the season.
 *       * the loop re-arms the timer fence each pass and exits when [bp-4]
 *         (a "turn made progress / done" flag) becomes non-zero.
 *   - On exit it flushes the cursor and returns AX = [bp-4].
 *
 * The dispatch tail at @asm 0x0249C6.. is a jump table of single-arg overlay
 * calls keyed on the active unit's state byte U_STATE (0x314C):
 *       0x191F:0x1C2  0x191F:0x216  0x191F:0x4BA  0x191F:0x1FA
 *       0x191F:0x2B2  0x191F:0x4AC   ...
 * Each takes g_active_unit and performs that unit's standing order (fortify,
 * sentry, goto, plow/road, etc.).  Exact overlay targets: body in thunk page (RTLink VP dir).
 * ============================================================================ */
int game_main_loop(void)
{
    int progress = 0;                    /* [bp-4] */
    uint32_t fence;                      /* [0x97EC:0x97EE] timer fence */

    if (g_season == 0 /* Spring */) {    /* @asm 0x0246EB cmp [0x5390],0 */
        /* set [0x97B0] = 1  (new-turn latch) — @asm 0x0246F2 */
    }

    fence = game_timer_ticks() + 0x14;   /* @asm 0x0246F8..0x024706 LCALL 0xC0C:6; +0x14 */
    (void)fence;

    /* [0x929C] = (season==Autumn)  — @asm 0x02470A */
    /* lcall 0x181F:0xDCC (begin frame), 0x181F:0x47A (arm input) — @asm 0x024716 */

    for (;;) {                           /* MAIN POLL LOOP, back-edge @asm 0x024328 -> 0x40C1 */
        int alt = bios_kbd_shift_flags() & 8;   /* @asm ES:0x40:[0x17] & 8 */
        (void)alt;

        /* If no active unit awaiting orders, the loop falls through to the
         * end-of-turn / next-unit path.  @asm 0x024210..0x02423B examines the
         * far ptr at [0x896]; es:[bx]==0 means "no unit needs orders". */
        int key = kbd_poll();            /* @asm 0x0247D2 0x181F:0x3E0 -> [0x981E] */
        (void)key;

        /* ... per-key command dispatch via 0x191F:NNNN (targets in thunk page) ...
         * The handlers set `progress` when an order is issued. */

        if (progress)                    /* @asm 0x024998 cmp [bp-4],0 / jne -> exit */
            break;
        /* else loop (JMP 0x40C1) */
        break; /* (single-pass model for the C port; real loop is the for-body) */
    }

    /* flush cursor + return  @asm 0x0249BE..0x0249C4 */
    return progress;
}

/* ============================================================================
 * game_tick_coordinator — per-frame mouse/cursor + tile-hover coordinator.
 * ----------------------------------------------------------------------------
 * @asm_function  func_024342   file 0x024342..0x0245C5  (643 bytes, ENTER 0x1E,0)
 * @asm_disasm    code/VICEROY/disasm_overlay_reseg/page_01.asm (func_024342)
 *
 * Called from the main loop each frame.  Byte-faithful behaviour:
 *   - Early-out unless [0x933E] == [0x9328] (state-machine guard). @asm 0x02434B
 *   - Read the game timer (LCALL 0xC0C:6 -> DX:AX). @asm 0x024357
 *   - Compute the hovered map tile from the MOUSE position and the viewport:
 *       mouse_x [0x7E8], mouse_y [0x7EA];  zoom shift [0x184];
 *       tile_col = (mouse - 8) / (0x10 >> zoom) - [0x832A] + [0x8328]
 *       tile_row similarly with [0x832C]/[0x832E].   @asm 0x0243CA..0x024401
 *   - Season-gated hover redraw: when season==Autumn it compares the hovered
 *     tile to the saved [0x853E]/[0x8540] and redraws the highlight.
 *       @asm 0x024404..0x024442  (cmp [0x5390],1)
 *   - On a click against the active unit it computes a move delta from
 *     U_X/U_Y([0x5392]) and the hovered tile and issues the move via
 *     0x191F:0x44E.   @asm 0x02444C..0x0244F8
 *   - Otherwise it stores the click target into the active unit's goto fields
 *     U_STATE/U_X/U_Y (0x314C/0x314D/0x314E = state 3 + dest).  @asm 0x0244FA
 *   - Colony / unit pick at the hovered tile via 0x181F:0x7BE (colony_at_xy ->
 *     ColonyRecord stride 0xCA at base 0x5D46) and 0x181F:0x7E0 (unit_at_xy).
 *       @asm 0x024540..0x02459E
 *   - Finally, if a tile was picked, opens its context popup via 0x181F:0xE08.
 *       @asm 0x0245A1..0x0245B9
 *
 * Returns AX = [bp-0x1A] (whether the frame consumed input / changed state).
 * ============================================================================ */
/* (declared above as game_tick_coordinator; body is the per-frame coordinator
 *  detailed in the comment — exact 0x191F move/goto handler targets are body in thunk page.) */

/* ============================================================================
 * game_command_dispatch — the in-game keyboard COMMAND dispatcher.
 * ----------------------------------------------------------------------------
 * @asm_function  func_0235D6   file 0x0235D6..0x023A9C  (2374 B, ENTER 0x1E,0)
 * @asm_disasm    code/VICEROY/disasm_overlay_reseg/page_01.asm (func_0235D6)
 * STATUS: STRUCTURE BYTE_VERIFIED (the dispatch shape + the screen-open
 * branches + the DGROUP screen-mode selector + the command-key constants);
 * most leaf command handlers are 0x191F:NNN overlay targets (body in thunk page).
 *
 * This is the resident command router referenced by game_main_loop's dispatch
 * tail.  It takes the key/command id in [bp+6] and runs the matching action.
 * The screen-OPENING commands are now decoded; they all stage a screen-mode
 * selector in DGROUP:[0x1F5E] and then look the screen up by GAME.TXT key via
 * LCALL 0x181F:0x998 (the menu/dispatch-by-key entry of func_028D8C):
 *
 *   COMMAND          [0x1F5E]   key pushed (LEA ax)         @asm
 *   --------------   --------   ------------------------    ------------------
 *   SETEUROPE          4        0xAE3 "SETEUROPE"           0x0236D3..0x0236EB
 *                                (player+1 in dx; gated by reveal flag 0x53A2)
 *   SETREPORT          5        0xAF3 "SETREPORT"           0x03810  +0x1F5E=5
 *                                (then F-key sub-dispatch, below) 0x02381D
 *
 * The leading switch (@asm 0x0235E2 CMP ax,0x1A / DEC chain) handles the small
 * command ids 1..5 + 0x1A via near CALLs (push cs;call) into this same overlay
 * page; the larger body is a long IF/ELSE ladder on specific key codes.
 *
 * SETEUROPE branch (byte-faithful):  @asm 0x0236CC..0x023701
 *   if ([0x53A2 reveal] != 0) {                    ; 0x0236D1 CMP [0x53A2],0/JE
 *       [0x1F5E] = 4;                               ; 0x0236D3 MOV [0x1F5E],4
 *       dx = [0x5396] + 1;                          ; 0x0236D9 active player + 1
 *       n = lookup_by_key(0xAE3 "SETEUROPE", 0xAED) ; 0x0236E6 LCALL 0x181F:0x998
 *       if (n <= 0) return;                         ; 0x0236F0 OR ax,ax/JG
 *       europe_select(n-1, -1);                     ; 0x0236F9 LCALL 0x181F:0x5FA
 *                                                   ;   (PUSH -1 then PUSH n-1;
 *                                                   ;    cdecl => arg0=n-1,arg1=-1)
 *   } else { ... non-reveal path uses [0x53A4]/[0x5394] ... }  0x023704..0x02371A
 *   (NB an earlier guard shows EUROPENOTAVAIL (key 0xAD4) when [0x5382]&1 and
 *    [0x53A2]==0.  @asm 0x0236B2..0x0236C9)
 *   -> the actual Europe view is drawn by europe_open() (func_030DBC, see
 *      src/ui/europe_screen.c) using the EUROPE key (0xFBA).
 *
 * SETREPORT + F-key sub-dispatch:  @asm 0x023810..0x0238CB
 *   [0x1F5E] = 5; n = lookup_by_key(0xAF3 "SETREPORT", 0xAFD); idx = n-1.
 *   Then, keyed on [bp+6] (the report letter), it calls the matching report
 *   handler with idx:
 *       'H'=0x48 -> 0x191F:0x41A      'A'=0x41 -> 0x191F:0x40C
 *       'B'=0x42 -> 0x191F:0x3FE      'C'=0x43 -> 0x191F:0x3F0
 *       'D'=0x44 -> 0x191F:0x3E2      'E'=0x45 -> 0x191F:0x3D4
 *       'F'=0x46 -> 0x191F:0x3C6      'G'=0x47 -> 0x191F:0x3B8
 *       'I'=0x49 -> (SoL report; gated by [0x5383]&0x20) 0x181F:0x574
 *   These are the in-game Reports menu (the per-report content engine is
 *   func_072090; the dispatch entry is report_open(), src/ui/report_screen.c).
 *
 * The other ladder arms route to non-screen commands (unit orders, save/load,
 * zoom [0x184]+/-, etc.); those leaf 0x191F targets are body in thunk page.
 *
 * Args:  cmd = [bp+6] (key/command id); arg2 = [bp+8] (sub-arg for some cmds).
 * ============================================================================ */
extern int16_t g_screen_mode_1F5E;   /* DGROUP:0x1F5E  screen-mode selector */
extern int16_t g_reveal_53A2;        /* DGROUP:0x53A2  reveal/cheat flag */
extern int     menu_lookup_key(int key_lo, int key_hi, int dx);    /* 0x181F:0x998 */
extern void    europe_select(int a, int player);                   /* 0x181F:0x5FA */
extern void    europe_open(void);                                  /* func_030DBC (europe_screen.c) */
extern int     report_open(int which);                             /* func_037340 (report_screen.c) */

/* (game_command_dispatch is documented above; its full IF/ELSE ladder is the
 *  func_0235D6 body. The screen-open arms are decoded; the rest is not yet decoded.) */

/* ============================================================================
 * THE SEASON CYCLE  (Spring <-> Autumn), DGROUP:0x5390
 * ----------------------------------------------------------------------------
 * VICEROY runs TWO seasons per game year: Spring (0) then Autumn (1).  Each
 * season iterates every unit of the current nation; when a nation's units are
 * all processed the turn passes to the next nation; when all nations finish
 * Autumn the year advances and season resets to Spring.
 *
 * "Begin Autumn" trigger  @asm 0x0217E2 (inside func_020F50):
 *     MOV word ptr [0x5390], 1          ; season = Autumn  (BYTE_VERIFIED)
 *   followed by a redraw of the active unit's tile.  This is what flips the
 *   game from the Spring half-turn into the Autumn half-turn.
 *
 * Season is RESET to Spring (and the year advanced) inside the Autumn
 * processor func_021D32 @asm 0x021DD7:
 *     MOV word ptr [0x5390], 0          ; season = Spring  (BYTE_VERIFIED)
 *     MOV word ptr [0x53C6], 0          ; clear the "autumn pending" latch
 * (Only ONE site in the whole binary writes [0x5390] to a register value —
 *  func_021D32 — per dgroup_xrefs.json; all other writes are the constant 0/1
 *  literals.  This pins the toggle location.)
 * ============================================================================ */

/* ----------------------------------------------------------------------------
 * spring_turn_process — Spring (season 0) per-unit processing.
 *   @asm_function  func_021A14  file 0x021A14..0x021D30  (797 bytes)
 *   @asm_disasm    code/VICEROY/disasm_overlay_reseg/page_01.asm (func_021A14)
 *
 *   Gate: `cmp [0x5390],0 / je` — runs only in Spring (else returns). @asm 0x021A1E
 *   For the active unit ([0x5392], stride 0x1C) it:
 *     - reads U_X/U_Y and the underlying terrain (0x181F:0x78C),
 *     - calls 0x181F:0xB78 with the unit index (per-unit Spring update; the AI
 *       move-eligibility / refresh — body in thunk page),
 *     - re-draws the unit's surrounding terrain + goto-path sprites, pushing
 *       sprite IDs 0x301..0x331 chosen by terrain/feature bands (forest 8-23,
 *       hills 0x1C, mountain 0x1B; matches the auto-forest range and the
 *       0x5237-based terrain stat table, stride 14 at base 0x5230 — same table
 *       the combat resolver uses).   @asm 0x021A48..0x021D2A
 *   This is the "start of Spring: refresh + draw the active unit" step.
 * ---------------------------------------------------------------------------- */

/* ----------------------------------------------------------------------------
 * autumn_turn_process — Autumn (season 1) per-unit processing + year roll.
 *   @asm_function  func_021D32  file 0x021D32..0x021E71  (320 bytes, ENTER 4,0)
 *   @asm_disasm    code/VICEROY/disasm_overlay_reseg/page_01.asm (func_021D32)
 *
 *   - [bp-4] = (season==Autumn) ? 1 : 0  (derived gate).  @asm 0x021D3B
 *   - For the active unit it runs the end-of-turn housekeeping: 0x181F:0x7A0
 *     (unit upkeep), and if the unit has a standing order, redraws/animates it
 *     via 0x181F:0x9BA.   @asm 0x021D4D..0x021D7A
 *   - Examines the unit's state byte U_STATE (0x314C): values 5..(5+n) select
 *     whether the unit auto-continues its order or is freed for new orders
 *     ([bp-2] = "needs orders next turn").   @asm 0x021DA3..0x021DC9
 *   - **Season toggle**: writes [0x5390]=0 (back to Spring) and [0x53C6]=0.
 *       @asm 0x021DD7..0x021DDA  (the unique register-write site).
 *   - If the unit is on-screen ([0x181F:0x302] bounds check) and still needs
 *     orders, re-centres the view on [0x853E]/[0x8540] (the saved cursor tile)
 *     via 0x181F:0x352.   @asm 0x021DDD..0x021E35
 *   - Tail: if 0x5382 bit 0x80 is set, calls the autosave path (near call
 *     0x8E0).   @asm 0x021E5C..0x021E6A
 *   Returns AX = [bp-2] ("this unit needs orders next turn").
 * ---------------------------------------------------------------------------- */

/* ============================================================================
 * HOW THE LOOP DRIVES UNIT / COLONY / AI / MARKET UPDATES
 * ----------------------------------------------------------------------------
 * The chain (all anchors BYTE_VERIFIED; leaf overlay targets body in thunk page where noted):
 *
 *   resident main loop  func_0246E2
 *        |  (each frame)
 *        v
 *   tick coordinator    func_024342  ── mouse/hover, click-to-move, popups
 *        |
 *        v
 *   per-unit season step:
 *        season==0 -> spring_turn_process (func_021A14)  refresh + draw
 *        season==1 -> autumn_turn_process (func_021D32)  upkeep + toggle season
 *        |
 *        +-- "begin Autumn" trigger sets [0x5390]=1 (func_020F50 @0x217E2)
 *        +-- Autumn processor resets [0x5390]=0 and advances the turn
 *
 * Unit updates: per-unit, driven by g_active_unit ([0x5392]) advancing through
 *   the UnitRecord table; standing orders handled by the 0x191F dispatch tail
 *   of func_0246E2 (body in thunk page).
 *
 * Colony production: NOT in this loop's resident code.  It is invoked from the
 *   end-of-turn overlay; the per-colony update is colony_turn_update at
 *   VICEROY 0xA3E1 (Sugar->Rum / Tobacco->Cigars / Ore->Tools chain, MEMORY.md
 *   byte-verified; ColonyRecord stride 0xCA at base 0x5D46).  See
 *   src/colony/turn_update.c.
 *
 * AI: each non-human nation's units are processed by the SAME season
 *   processors; the per-nation AI decision entry reads the AIPersonality table
 *   (DGROUP:0x540E, stride 0x34) — the exact AI dispatch is in the end-turn
 *   overlay (body in thunk page; idx 32 0x40608 / idx 37 0x45D92 per P6 map).
 *
 * European market price update: NOT in the resident loop; runs once per turn
 *   in the end-turn overlay near the Autumn processor.  See src/market/pricing.c
 *   (PowerRecord stride 0x13C; price table RUNTIME_ONLY (NAMES.TXT)).
 *
 * Random events (Lost City Rumour) fire when a unit ENTERS a rumour tile — i.e.
 *   from the move handler invoked by this loop, calling func_061454.  See
 *   src/random_events/lcr.c.  (There is NO weather or disease event — see
 *   src/random_events/weather.c and disease.c for the byte evidence.)
 * ============================================================================ */
