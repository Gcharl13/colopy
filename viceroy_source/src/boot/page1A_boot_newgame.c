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
 *   func_0755CC  new_game_state_init(premade?)                spec/systems/map_generation.md
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
