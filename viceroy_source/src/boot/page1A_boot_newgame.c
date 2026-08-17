/* ============================================================================
 * boot/page1A_boot_newgame.c — overlay page 0x1A (file 0x72090..0x763D0):
 *     the boot menu, new-game setup, and the save/load band.
 * ----------------------------------------------------------------------------
 * LAYER-1 EVIDENCE, not a runnable program (see viceroy_source/ROLE.md).
 * @asm-cited transcript.  The centrepiece here is func_0759E8 — the
 * @BEGINMENU dispatcher that decides what "Start a Game in NEW WORLD /
 * AMERICA / CUSTOMIZE New World / LOAD Game / Hall of Fame" each DO, the
 * exact ladder the port must mirror (it currently branches on none of the
 * three start rows and always serves AMER2 — the inverse of the original).
 *
 * @ref code/VICEROY/disasm_overlay_reseg/page_1A.asm
 * @ref spec/systems/map_generation.md §4   (the same ladder, cross-checked)
 * @ref data_extracted/viceroy_modules.json (module boot_save*)
 *
 * The 22 functions of page 0x1A and where each is documented:
 *   func_072C78  save-filename builder  COLONY<slot>.SAV      [here]
 *   func_072F7A  save_orchestrator                            spec/systems/save.md
 *   func_0734F8  save_serializer (43-block dump)              spec/systems/save.md §3
 *   func_073BB0  load_deserializer                            spec/systems/save.md
 *   func_0749E0  NAMES.TXT scenario/section loader            viceroy_source/FUNCTION_INVENTORY.md
 *   func_0755CC  new_game_state_init(premade?)                [here, full]
 *   func_0759E8  @BEGINMENU dispatcher + world-build setup     [here, full]
 *   (the render/alloc leaves 0x72090/0x72CC2/0x75FB6 … are boot plumbing [TBD])
 *
 * DGROUP data this page names (all @asm-cited at use):
 *   0x2345 "BEGINMENU"   0x234F "AMERICA"    0x2357 "*.MP"
 *   0x235C "MAPTOLOAD"   0x2366 "GAME"       0x2166 "AMER2.MP" (mutable default)
 *   0x2174  custom-map-chosen flag           0x1E7E  gen-params[5] (words)
 *   0x543F  AIPersonality.controller (stride 0x34)
 * ==========================================================================*/

#include <stdint.h>
#include "boot.h"

/* --- DGROUP ---------------------------------------------------------------*/
extern uint16_t  g_word_104;         /* 0x0104  first-boot / resume guard      */
extern uint8_t   g_flag_828, g_flag_829; /* 0x0828/0x0829  boot-state latches  */
extern uint8_t   g_flag_82a;         /* 0x082A  map-preview mode               */
extern int16_t   g_gen_params[5];    /* 0x1E7E  LAND MASS/FORM/TEMP/CLIMATE + smooth */
extern uint16_t  g_custom_map_chosen;/* 0x2174  a non-default .MP was picked   */
extern char      g_map_name_buf[];   /* 0x2166  "AMER2.MP" (mutable)           */
extern char      STR_BEGINMENU[];    /* 0x2345                                 */
extern char      STR_AMERICA[];      /* 0x234F                                 */
extern char      STR_STARMP[];       /* 0x2357  "*.MP"                         */
extern char      STR_MAPTOLOAD[];    /* 0x235C                                 */
extern char      STR_GAME[];         /* 0x2366                                 */
extern char      STR_COLONY[];       /* 0x20E2  "COLONY"                       */
extern char      STR_DOTSAV[];       /* 0x20E9  ".SAV"                         */
extern uint8_t   AIPERS_CTRL[];      /* 0x543F  AIPersonality.controller       */

/* --- RTLink thunks --------------------------------------------------------*/
extern int  run_menu(void *key_str);            /* 0x181F:0x3FE  -> 1-based row */
extern int  random_int(int lo, int hi);         /* 0x181F:0x4D4                 */
extern int  customize_screen(void);             /* 0x1A1F:0xBE4 -> func_070060  */
extern int  file_pick_mp(char *dst, void *pat,
                         void *key, void *sect); /* CS call 0x763B6 wrapper      */
extern int  str_differs(void *a, void *b);      /* 0xD1D:0x816                  */
extern void strcpy_ds(void *dst, void *src);    /* 0xD1D:0x7E4                  */
extern void strcat_itoa(void *dst, int radix);  /* 0x181F:0x182                 */
extern void itoa_field(void *dst, int val, int radix);/* 0x181F:0xE9A            */
extern void strcat_ds(void *dst, void *src);    /* 0xD1D:0x7A4                  */
extern int  america_subdialog(void *key);       /* 0x181F:0x3FE on STR_AMERICA  */
extern void new_game_state_init(int premade);   /* CS 0x763C0 -> func_0755CC    */
extern void memset_ds(void *dst, int val, int len);/* 0xD1D:0xDAE                 */
extern int  spawn_unit(int type, int owner,
                       int x, int y);           /* 0x181F:0x95C -> unit index   */
extern void sound_play_gated(int id);           /* 0x181F:0x4C0                 */
extern void sound_queue_tune(int id);           /* 0x181F:0x48E                 */
extern int  sound_pump(void);                   /* 0x181F:0x3AC                 */
extern void fill_terrain_row(int terrain, int step,
                             int w0, int w1, int w2, int w3);/* 0x181F:0xBA     */
extern void view_center(int packed_xy);         /* 0x181F:0x4CA                 */
extern int  build_world(int premade);           /* 0x1A1F:0x83E                 */
extern void save_load_driver(void *filename,
                             int is_load, int slot);/* CS 0x76370 wrapper        */
extern void hall_of_fame(void);                 /* jmp target 0x75EB0 branch    */
extern void load_game_flow(void);               /* jmp target 0x75DEA branch    */
/* (map-preview render/blit helpers 0x181F:0x53C/0x498/0x44E/0x484 … are boot
 *  plumbing; cited at their sites, bodies [TBD].) */

/* ============================================================================
 * func_072C78  (file 0x72C78, 44 B) — build the save filename COLONY<slot>.SAV.
 * @asm strcpy(dst, "COLONY" [0x20E2]) @0x72C81 ; itoa_field(dst, slot, 10)
 *      @0x72C92 (dx=2 → decimal) ; strcat(dst, ".SAV" [0x20E9]) @0x72C9D.
 * (spec/systems/save.md names the builder func_072C4E; this is the same
 *  COLONY+digit+.SAV construction — 072C4E is the caller, 072C78 the body.)
 * ==========================================================================*/
void func_072C78(char *dst, int slot)
{
    strcpy_ds(dst, STR_COLONY);          /* @0x72C81 "COLONY" */
    itoa_field(dst, slot, 2);            /* @0x72C92 append slot digit */
    strcat_ds(dst, STR_DOTSAV);          /* @0x72C9D ".SAV" */
}

/* ============================================================================
 * func_075594  (file 0x75594, 55 B) — build a per-player config/name from the
 *   template [0x2334], appending the player index when playing seat 3, then
 *   hand it to the save/load driver (load=1, slot=1).
 * @asm strcpy(buf,[0x2334]) @0x7559F ; if [0x5398]==3 strcat_itoa(buf,2)
 *      @0x755A7..0x755BA ; save_load_driver(buf,1,1) @0x755C6.
 * ==========================================================================*/
void func_075594(void)
{
    char buf[0x14];
    strcpy_ds(buf, /*[0x2334]*/ (void *)0x2334);   /* @0x7559F */
    extern uint16_t g_current_player;               /* 0x5398 */
    if (g_current_player == 3)                      /* @0x755A7 */
        strcat_itoa(buf, 2);                        /* @0x755B5 */
    save_load_driver(buf, 1, 1);                    /* @0x755C6 */
}

/* ============================================================================
 * func_0759E8  (file 0x759E8, 1455 B) — THE @BEGINMENU DISPATCHER.
 *
 * Draws the OPENMENU backdrop + map preview (the 0x759E8..0x75C5A prologue is
 * render plumbing — palette/layer blits via 0x181F:0x53C/0x498/0x44E/0x484,
 * transcribed as a summary), runs @BEGINMENU, then dispatches the chosen row.
 *
 * The ladder (@0x75C64..0x75C83), byte-exact — `sel` is the 1-based row:
 *   run_menu("BEGINMENU") -> sel                          @0x75C64
 *   sel==0 (cancel)                       -> exit         @0x75C6D/0x75C70
 *   sel in {1,2,3}  NEW WORLD/AMERICA/CUSTOMIZE -> shared world-build @0x75C75
 *   sel==4          LOAD Game             -> load_game    @0x75C78/0x75C7A
 *   sel==5          Hall of Fame          -> hall_of_fame @0x75C7E/0x75C80
 *
 * The three start rows SHARE the world-build path but differ INSIDE it:
 *   - gen-params[0..4]: CUSTOMIZE seeds them all to 1 (neutral middle);
 *     NEW WORLD & AMERICA roll each random_int(0,3).      @0x75C86..0x75CC2
 *   - CUSTOMIZE (sel 3) then opens the customize screen.  @0x75CC4..0x75CD4
 *   - AMERICA (sel 2) then runs the @AMERICA sub-dialog: "Original Americas"
 *     keeps AMER2.MP; "Map Editor" opens a *.MP file picker (@MAPTOLOAD),
 *     sets the custom-map flag and copies the chosen name into 0x2166.
 *                                                          @0x75CDE..0x75D49
 *   - new_game_state_init(premade): premade = (sel==2) ? 1 : 0 — AMERICA
 *     loads a premade map, NEW WORLD & CUSTOMIZE generate.  @0x75D53..0x75D67
 *
 * Returns via the shared boot epilogue (0x75F7D/0x75F87/0x75F8D exits).
 * ==========================================================================*/
void func_0759E8(void)
{
    int sel, cancel = 0;

    /* ---- boot backdrop + map preview render (summarised plumbing) -------
     * @0x759E8..0x75C5A: set the 320x200 (0xC8 x 0x140) 0xA000 target,
     * branch on [0x104]/[0x828]/[0x82A] for first-boot vs resume vs preview,
     * blit OPENMENU + the current map into the clip rect [0x839E..0x83A4].
     * Detail bodies [TBD] — render plumbing, not game logic. */

restart_menu:
    cancel = 0;
    sel = run_menu(STR_BEGINMENU);                 /* @0x75C64 */

    if (sel - 1 < 0) goto exit_cancel;             /* @0x75C6D: sel 0 = cancel */
    if (sel - 3 <= 0) goto world_build;            /* @0x75C75: rows 1,2,3     */
    if (sel == 4) { load_game_flow(); goto epi; }  /* @0x75C78: LOAD Game      */
    if (sel == 5) { hall_of_fame();  goto epi; }   /* @0x75C7E: Hall of Fame   */
    goto exit_cancel;                              /* @0x75C83 */

world_build:
    /* seed the five generator parameters @0x75C86..0x75CC2 */
    for (int i = 0; i < 5; i++) {                  /* @0x75CA8 */
        if (sel == 3)                              /* @0x75CAF: CUSTOMIZE */
            g_gen_params[i] = 1;                   /* @0x75CBC: neutral middle */
        else
            g_gen_params[i] = random_int(0, 3);    /* @0x75C92: NEW WORLD/AMERICA */
    }

    /* CUSTOMIZE: open the 4x3 grid screen (func_070060) @0x75CC4 */
    if (sel == 3) {
        if (customize_screen() == 0)               /* @0x75CCB: ESC = cancel */
            cancel = 1;                            /* @0x75CD4 */
    }

    /* AMERICA: the @AMERICA sub-dialog @0x75CDE */
    if (sel == 2) {
        int a = america_subdialog(STR_AMERICA);    /* @0x75CE9 */
        if (a < 1) {                               /* @0x75CF2: cancelled */
            cancel = 1;
        } else if (a > 1) {                        /* @0x75D00: "Map Editor" */
            char picked[0x50];
            int r = file_pick_mp(picked, STR_STARMP,
                                 STR_MAPTOLOAD, STR_GAME); /* @0x75D14 */
            if (r >= 0 &&
                str_differs(picked, g_map_name_buf)) {     /* @0x75D2A vs 0x2166 */
                g_custom_map_chosen = 1;           /* @0x75D36: [0x2174] */
                strcpy_ds(g_map_name_buf, picked); /* @0x75D44: -> 0x2166 */
            }
        }
        /* a == 1 "Original Americas": fall through, AMER2.MP stays. */
    }

    /* start the game @0x75D53: premade iff AMERICA (row 2) */
    if (!cancel) {
        int premade = (sel == 2) ? 1 : 0;          /* @0x75D53..0x75D60 */
        new_game_state_init(premade);              /* @0x75D64 -> func_0755CC */
        /* new_game_state_init returns a status; 1 = start the game loop,
         * else re-show the menu (the 0x75D6E..0x75D7C dec/cmp). */
    }
    if (cancel) goto restart_menu;                 /* @0x75D81 path */

epi:
exit_cancel:
    /* shared boot epilogue: tear down the preview buffer, return to caller
     * (0x75F7D/0x75F87/0x75F8D). [TBD] render teardown. */
    return;
}

/* ============================================================================
 * func_0755CC  (file 0x755CC..0x759C7, 1020 B) — NEW-GAME STATE INIT.
 *
 * `enter 0xE,0` @0x755CC; one arg at [bp+6] = `premade` (1 = load a .MP map,
 * 0 = generate).  Returns [bp-2]: 1 = abort back to the menu, 2 = a world was
 * built but the run was cut short, 0 = the game is live.  Locals:
 *   [bp-2]  status      [bp-6]  power index (the per-power loop)
 *   [bp-8]  "this power is controller 0" flag
 *   [bp-0xA] scratch loop counter        [bp-0xC] last spawned unit index
 *
 * ---- What this pins down (all byte-verified here, cross-checked below) ----
 * The globals block base is DGROUP 0x5380: every write in the opening
 * paragraph lands at `g + (addr - 0x5380)`, and four of them match fields the
 * port already restores verbatim — [0x5386] = g+0x06 (0x0E, the shared sound/
 * tutorial word), [0x53DA/DC/DE/E0] = g+0x5A..0x60 (the REF counts),
 * [0x540A] = g+0x8A (the woodcut shown-bitmask, cleared here with a 4-byte
 * memset).  See spec/systems/save.md §3.
 *
 * REF seeding from difficulty d (@0x7569B..0x756D0), read off the shifts:
 *   Regulars  = 8d + 15     (shl ax,3 ; add ax,0xF)
 *   Cavalry   = 5(d + 1)    (inc cx ; shl cx,2 ; add cx,dx)
 *   Artillery = 6d + 2      (shl ax,1 ; add ax,cx ; shl ax,1 ; inc ; inc)
 *   Man-O-War = 3d + 2      (shl dx,1 ; add dx,ax ; inc ; inc)
 * These agree exactly with cport/core/colopy_newgame.c, which reached them
 * through the JS port — an independent confirmation, not a new claim.
 *
 * Start of play: year 1492 (0x5D4 @0x757E7), turn 0, season 0.
 * ==========================================================================*/
int func_0755CC(int premade)
{
    int status, i, power, is_ctrl0, unit;

    strcpy_ds(G_MAP_NAME_ACTIVE, g_map_name_buf);  /* @0x755D7: 0x2166->0x8554 */
    g_premade_flag = premade;                      /* @0x755E2: [0x5388]=g+0x08 */

    g_game_phase_flags = 0xC600;                   /* @0x755E5: [0x5382]=g+0x02 */
    g_sound_tutorial_word = 0x0E;                  /* @0x755EB: g+0x06 — the
                                                    * three sound switches ON */
    status = 1;                                    /* @0x755F1 */
    g_music_background = 1;                        /* @0x755F7: [0xA2] */
    g_music_event      = 1;                        /* @0x755FA: [0xA0] */
    g_sound_effects    = 1;                        /* @0x755FD: [0xA4] */

    g_word_53a4 = -1;                              /* @0x75603: g+0x24 */
    g_self_power_idx = -1;                         /* @0x75606: g+0x52 */
    g_word_53d4 = -1;                              /* @0x75609: g+0x54 */
    g_word_53d6 = -1;                              /* @0x7560C: g+0x56 */
    g_current_nation = 0;                          /* @0x75611: g+0x14 */
    g_active_human_player = 0;                     /* @0x75614: g+0x16 */
    g_word_53a0 = 0;                               /* @0x75617: g+0x20 */
    g_word_53a2 = 0;                               /* @0x7561A: g+0x22 */
    g_word_5380 = 0;                               /* @0x7561D: g+0x00 */
    g_rebel_sentiment = 0;                         /* @0x75620: g+0x50 */
    g_word_53d8 = 0;                               /* @0x75623: g+0x58 */

    for (i = 0; i < 4; i++)                        /* @0x7562C..0x7563E */
        g_word_53c8[i] = -1;                       /* g+0x48..0x4E */

    /* g+0x6A..0x89 — SIXTEEN words, one per cargo, each seeded
     * random_int(600, 1000).  @0x75645..0x75663.  See the note below: this
     * is the per-good market word the port currently leaves at 0. */
    for (i = 0; i < 16; i++)
        g_market_word[i] = random_int(600, 1000);  /* @0x7564B/0x75658 */

    for (i = 0; i < 4; i++) {                      /* @0x7566A..0x75680 */
        g_ref_counts[i] = 0;                       /* g+0x5A..0x60 */
        g_word_53e2[i] = 0;                        /* g+0x62..0x68 */
    }
    memset_ds(G_WOODCUT_SHOWN, 0, 4);              /* @0x75688: g+0x8A, 4 B */

    if (near_call_0x76389() != 0)                  /* @0x75691 */
        goto ret;                                  /* @0x75698 -> 0x759AF, status 1 */

    /* ---- the REF, sized by difficulty @0x7569B ---------------------------*/
    {
        int d = g_difficulty;                      /* g+0x26, byte */
        g_ref_regulars  = 8 * d + 15;              /* @0x756A8: g+0x5A */
        g_ref_cavalry   = 5 * (d + 1);             /* @0x756B5: g+0x5C */
        g_ref_artillery = 6 * d + 2;               /* @0x756C5: g+0x60 */
        g_ref_manowar   = 3 * d + 2;               /* @0x756D0: g+0x5E */
    }

    if (g_flag_828 == 0)                           /* @0x756D4 */
        near_call_0x763bb();                       /* @0x756DC [TBD] */
    lcall_181f_4f2();                              /* @0x756DF [TBD] */
    sound_play_gated(0x39);                        /* @0x756E4: the new-game
                                                    * tune (manual 24.4) */
    sound_pump();                                  /* @0x756EC */

    status = 2;                                    /* @0x756F1 */

    /* ---- map dimensions: GENERATED games get the built-in 58x72 ----------*/
    if (premade == 0) {                            /* @0x756F6 */
        g_word_18c   = 1;                          /* @0x756FC */
        g_map_width  = 0x3A;                       /* @0x75702: 58 */
        g_map_height = 0x48;                       /* @0x75708: 72 */
        g_word_85a4  = 0x1050;                     /* @0x7570E */
        g_word_85a6  = 0;                          /* @0x75714 */
    }
    /* premade != 0: the dimensions come from the .MP header instead. */

    if (lcall_1a1f_c80(0) != 0) goto ret;          /* @0x7571C [TBD] alloc? */
    sound_pump();                                  /* @0x75728 */

    if (premade != 0) {                            /* @0x7572D */
        if (lcall_1a1f_c8e() != 0) {               /* @0x75733 [TBD] .MP load */
            g_word_822 = g_word_158;               /* @0x7573C: error code out */
            goto ret;                              /* @0x75742, status 2 */
        }
    } else {
        /* GENERATED maps get their polar rows stamped: two calls that differ
         * only in the row (dx = 0, then dx = height-1), both with bx = map
         * width and terrain 0x18 = 24 = Arctic (CLAUDE.md hard rule 2's
         * ordering note).  READING, not a decode of the callee: the callee
         * body (0x181F:0xBA) is [TBD], so "ice caps on the top and bottom
         * rows" is the natural reading of the arguments, not a proven fact.
         * @0x75746..0x75785 */
        fill_terrain_row(0x18, 1, g_word_85a8, g_word_85aa,
                         g_word_85ac, g_word_85ae);          /* row 0     */
        fill_terrain_row(0x18, 1, g_word_85a8, g_word_85aa,
                         g_word_85ac, g_word_85ae);          /* row h-1   */
    }

    sound_pump();                                  /* @0x7578A */
    view_center(g_word_83a6);                      /* @0x75793 */
    build_world(premade);                          /* @0x7579E: 0x1A1F:0x83E —
                                                    * generate or place from
                                                    * the loaded .MP [TBD] */
    sound_pump();                                  /* @0x757A6 */
    lcall_1a1f_976();                              /* @0x757AB [TBD] */
    lcall_191f_b6c();                              /* @0x757B0 [TBD] */
    lcall_1a1f_7ea();                              /* @0x757B5 [TBD] */
    lcall_1a1f_7f8();                              /* @0x757BA [TBD] */
    sound_pump();                                  /* @0x757BF */

    /* ---- the Founding Fathers table: 25 bytes of 0xFF = nobody holds any --
     * @0x757CB.  25 == DAT_FATHERS_COUNT, and the fixtures confirm the
     * reading: savstart is 25x0xFF, sav1653 and savraleigh carry a mix of
     * 00/01/02/03 (the owning power) and 0xFF. */
    memset_ds(G_FATHER_OWNER, -1, 0x19);           /* @0x757CB: g+0x29, 25 B */

    g_king_anger = 0;                              /* @0x757D3: g+0x27 */
    g_anger_event = random_int(1, 8);              /* @0x757E4: g+0x28 */
    g_year = 0x5D4;                                /* @0x757E7: 1492 */
    g_turn = 0;                                    /* @0x757EF: g+0x0E */
    g_word_538c = 0;                               /* @0x757F2: g+0x0C */

    g_current_nation = g_chosen_nation;            /* @0x757F8: g+0x18 -> g+0x14 */
    g_active_human_player = g_chosen_nation;       /* @0x757FB */
    if (g_word_53a4 >= 0)                          /* @0x757FE */
        g_active_human_player = g_word_53a4;       /* @0x75808 */
    view_center(g_word_83a6);                      /* @0x7580F */

    /* ---- starting forces, one power at a time @0x75817 -------------------
     * Loop control (@0x75939..0x75966) reads AIPersonality.controller
     * (stride 0x34, base 0x543F):
     *   controller == 2  -> the power is absent; skip it entirely  @0x75943
     *   controller == 0  -> is_ctrl0 = 1 for this power            @0x75957
     * Each surviving power gets THREE units, all spawned at x = y = power-0x1C
     * (i.e. -28..-25, an off-map sentinel, NOT the start tile), then the
     * power's own start position is copied out of its PowerRecord. */
    for (power = 0; power < 4; power++) {
        if (AIPERS_CTRL[power * 0x34] == 2) continue;          /* @0x75943 */
        is_ctrl0 = (AIPERS_CTRL[power * 0x34] == 0);           /* @0x75957 */

        for (i = 0; i < 12; i++)                               /* @0x7582A */
            POWER_WAR_MATRIX[power * 0x13C + i] = 0;           /* PR +0x34, 12 B */

        /* unit 1 — the ship.  type 0x0D, except power 3 which is patched to
         * 0x0E right after the spawn (@0x7587B).  The port reads these as
         * Caravel / Merchantman (the Dutch bonus). */
        unit = spawn_unit(0x0D, power, power - 0x1C, power - 0x1C); /* @0x7584D */
        UNIT[unit].byte_05 = 0;                                /* @0x7585B */
        UNIT[unit].byte_06 = POWER[power].start_x;             /* @0x75869: PR+0x32 */
        UNIT[unit].byte_07 = POWER[power].start_y;             /* @0x75871: PR+0x33 */
        if (power == 3) UNIT[unit].type = 0x0E;                /* @0x7587B */

        /* unit 2 — type 2; power 1 gets profession 0x14 */
        unit = spawn_unit(2, power, power - 0x1C, power - 0x1C);    /* @0x7588D */
        UNIT[unit].byte_05 = 1;                                /* @0x7589B */
        UNIT[unit].byte_06 = POWER[power].start_x;             /* @0x758A9 */
        UNIT[unit].byte_07 = POWER[power].start_y;             /* @0x758B1 */
        if (power == 1) UNIT[unit].class_profession = 0x14;    /* @0x758BB */

        /* unit 3 — type 1; profession 0x15 when
         *   (this is a controller-0 power AND difficulty <= 1)  @0x758F5
         *   OR power == 2                                       @0x75902 */
        unit = spawn_unit(1, power, power - 0x1C, power - 0x1C);    /* @0x758CD */
        UNIT[unit].byte_05 = 1;                                /* @0x758DB */
        UNIT[unit].byte_06 = POWER[power].start_x;             /* @0x758E9 */
        UNIT[unit].byte_07 = POWER[power].start_y;             /* @0x758F1 */
        if ((is_ctrl0 && g_difficulty <= 1) || power == 2)
            UNIT[unit].class_profession = 0x15;                /* @0x7590C */

        /* the view/cursor follows the last power set up @0x75911 */
        g_word_17c = g_word_8540 = POWER[power].start_x;       /* @0x7591F */
        g_word_17e = g_word_853e = POWER[power].start_y;       /* @0x75929 */
        AIPERS[power].word_01 = 0;                             /* @0x75930 */
    }

    lcall_1a1f_87c();                              /* @0x7596A [TBD] */
    while (sound_pump() == 0) { }                  /* @0x7596F..0x75976 */
    lcall_191f_aac();                              /* @0x75978 [TBD] */
    lcall_1a1f_a5c();                              /* @0x7597D [TBD] */
    screen_restore(0xA000, 0xFC00);                /* @0x75988: 0x181F:0x3F4 */
    if (g_flag_828 == 0 && g_word_83ac != 0)       /* @0x7598D/0x75994 */
        lcall_181f_4e8();                          /* @0x7599B [TBD] */
    sound_queue_tune(0x25);                        /* @0x759A2 (manual 24.4) */
    status = 0;                                    /* @0x759AA: the game is live */

ret:
    if (g_flag_828 == 0 && g_word_83ac != 0)       /* @0x759AF/0x759B6 */
        lcall_181f_4e8();                          /* @0x759BD [TBD] */
    return status;                                 /* @0x759C2..0x759C7 retf */
}

/* --- tail: the abort stub at 0x759C8 --------------------------------------
 * A separate 21-byte entry (0x759C8..0x759DC): screen teardown
 * (0x181F:0x3B6), the same 0xA000/0xFC00 restore, then `call 0x76393` and
 * `retf`.  Reached only through the CS-relative wrappers at the end of the
 * page; callers [TBD]. */
