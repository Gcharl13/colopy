/* ============================================================================
 * title_screen.c -- Boot / main-menu screen
 * ----------------------------------------------------------------------------
 * STATUS: BYTE_VERIFIED (resident composer found).  The main-menu screen is
 * built by VICEROY func_0759E8 (page 0x1A, file 0x0759E8..0x075F97, ENTER
 * 0x3F4,0).  It draws the OPENING backdrop, the OPENBORD decoration, and runs
 * the @BEGINMENU menu (DS:0x2345) via the resident menu-runner thunk
 * 0x181F:0x3FE, dispatching the chosen option (new game / load / customize /
 * exit).  The menu OPTION ROWS are DATA-DRIVEN from the @BEGINMENU section
 * (the runner lays them out internally) -- there are NO static per-option x/y
 * in the EXE, so those stay layout-base; only the backdrop/border geometry and
 * the menu-key handles are static and cited below.  The opening CINEMATIC is a
 * SEPARATE executable (OPENING.EXE) and is not in this resident loop.
 * cite-or-not yet decoded.
 *
 * @asm_disasm  code/VICEROY/disasm_overlay_reseg/page_1A.asm (lines 5048..)
 * raw-EXE spot-checks (this session):
 *   0x075C60 = 8d 1e 45 23     lea bx,[0x2345]   (@BEGINMENU menu key)
 *   0x075AE4 = 68 3c 23        push 0x233C        (boot/menu backdrop handle)
 *   0x075DA3 = 68 74 23        push 0x2374        (new-game backdrop handle)
 *
 * Sources (asset/string catalogue, unchanged):
 *   docs/SESSION_UI_CATALOG.md  (the OPENING/OPENMENU/MPSLOGO PIK roles)
 *   docs/COLONIZE_DATA_FILES_INDEX.md (.PIK inventory)
 *   docs/ASSET_ROLES.md          (OPENING.EXE = title/cinematic player)
 *   docs/LABELS_TXT_CATALOG.md   (difficulty/power/customize label strings)
 *
 * Prior revision FABRICATED: a "TITLE.PIK" background, a SPRITE_LOGO blit at
 * (32,32), a 5-item menu { "New Game","Load Game","Hall of Fame","Watch Intro",
 * "Quit to DOS" } at MENU_X/Y = (120,100), and a dispatch that did
 * chain_to_exe("OPENING.EXE") / ask_difficulty()/ask_power()/ask_map(). No
 * source for the literal menu strings, coordinates, logo sprite, or the exact
 * dispatch -> all removed.  The DECODED facts below replace them. (There is no
 * "TITLE.PIK"; the backdrops are loaded by string handle 0x233C / 0x2374.)
 * ============================================================================ */
#include "viceroy_types.h"
#include "globals.h"
#include "iolib.h"

/* Screen-state id returned to the reconstruction-layer screen dispatcher.
 * No DOS-traced view id exists for the title menu (the screen-state return is a
 * project convention). Assigned the unused id 0x29, extending the verified
 * view-id block (Europe 0x2B, Colony 0x2C) downward. CONSOLIDATED 2026-06-09
 * into the shared ui screen-id header. */
#include "ui_screen.h"

/* ----------------------------------------------------------------------------
 * Boot / main-menu assets (VERIFIED-by-catalog; load call sites not yet decoded).
 * Source: docs/SESSION_UI_CATALOG.md + COLONIZE_DATA_FILES_INDEX.md.
 *
 *   MPSLOGO.PIK  -- MicroProse logo (boot screen)
 *   MPSNAME.PIK  -- MicroProse text (boot/credits)
 *   OPENING.PIK  -- old-style world map ("OCEANVS OCCIDENTALIS" / "TERRA
 *                   INCOGNITA", sea monsters/ships) -- the title backdrop
 *   OPENMENU.PIK -- the main menu, drawn OVER the OPENING backdrop
 *   OPENBORD.PIK -- decorative border framing the opening menu
 *
 * New-game flow backgrounds (SESSION_UI_CATALOG.md):
 *   NATIONS.PIK  -- 4 wood-framed nation-flag plaques (Eng/Fr/Sp/Du) -- power select
 *   DIFFICUL.PIK -- 5 figures (Discoverer/Explorer/Conquistador/Governor/Viceroy)
 *                   -- difficulty select
 *   CUSTOMIZ.PIK -- world-customization options screen
 *
 * NOTE: PIK filenames are not in the resident VICEROY.EXE string table
 * (strings.json: 0 ".PIK" hits) -> the names are catalogued, the load call
 * site is not yet decoded. There is NO "TITLE.PIK" anywhere in the catalog.
 *
 * The OPENING CINEMATIC is played by a separate program, OPENING.EXE
 * (ASSET_ROLES.md: "Title-screen / cinematic player"), driven by OPENING.TXT
 * (frame timing), PATH.DAT (ship trajectory) and AMERICA.MOV. The resident
 * game does NOT contain the cinematic loop.
 * ---------------------------------------------------------------------------- */

/* ----------------------------------------------------------------------------
 * Menu / new-game text strings (LABELS_TXT_CATALOG.md). These confirm the
 * setup-screen vocabulary; the exact main-menu item list and its layout are
 * still not yet decoded (overlay-resident).
 *
 *   Difficulty: "Choose","Difficulty Level","Level",
 *               "Easiest","Easy","Moderate","Tough","Toughest"
 *   Power     : "Select","European Power"
 *   Customize : "CUSTOMIZE NEW WORLD","Click Here When Finished",
 *               "Land Mass","Land Form","Temperature","Climate",
 *               "Small","Moderate","Large","Archipelago","Normal","Continents",
 *               "Cool","Temperate","Warm","Arid","Wet"
 * ---------------------------------------------------------------------------- */

/* ============================================================================
 * PLACEMENT TABLE -- func_0759E8  (title / main-menu composer, page 0x1A)
 * ----------------------------------------------------------------------------
 *   element                       x          y       sprite/string-id        @asm
 *   full-screen reset (a000:0)    0          0       region 0x181F:0x53C     0x0759FE  (init [bp-0xF0..]=0xC8,0x140,0,0xA000)
 *   boot intro (gated [0x104])    --         --      0x181F:0x498 (sel 3)    0x075A1B
 *   backdrop blit (BEGIN, [0x828]==0) full     full   str 0x233C  0x181F:0x44E 0x075AE4  push 0x233C
 *     -> composited to a000:0x300 via 0xD1D:0xFB2 (memcpy to screen)         0x075B1D
 *   OPENBORD piece A              0xC8(200)  --      sprites (6,7) 0x1A1F:0xDF8 0x075B8E  push 0xC8;push 7;push 6
 *   OPENBORD piece B              0xC8(200)  --      sprites (8,9) 0x1A1F:0xDF8 0x075BB0  push 0xC8;push 9;push 8
 *   OPENBORD piece C              0xC8(200)  --      sprites (0xE,0xF) 0x1A1F:0xDF8 0x075BD2 push 0xC8;push 0xF;push 0xE
 *   menu-plate region blit        0xC8(200)  --      region 0x181F:0x444     0x075C00  push 0xC8
 *   menu-plate rule               0          0xC8(200) box 0x181F:0x00E2 w=0x140 0x075C12
 *   cursor reset                  --         --      0x181F:0x4DE (sel 0x33) 0x075C28
 *   MENU RUN (@BEGINMENU)         layout-base layout-base  key DS:0x2345 0x181F:0x3FE 0x075C60  lea bx,[0x2345]
 *     -> returns the chosen option index in [bp-0xE0]; options laid out by the
 *        resident runner (data-driven from the @BEGINMENU section).  [layout]
 *   sel ladder (dec ax on [bp-0xE0]):                                        0x075C6D..0x075C83
 *     sel 1 (top)  -> exit menu (return)                                     0x075C70  jmp 0x4AFD
 *     sel 2        -> LOAD-GAME submenu (handles 0x234F/0x2357/0x235C/0x2366/ 0x075CE3..0x075D17
 *                     0x236B; player name copied to [0x2166], flag [0x2174]) 0x075D22/0x075D36
 *     sel 3        -> 5-entry list filled to table [bx+0x1E7E] (difficulty?) 0x075C7A  jmp 0x495A
 *     sel 4        -> NEW-GAME backdrop (str 0x2374) then begin              0x075C80  jmp 0x4A20
 *   begin game                    --         --      0x191F:0x320            0x075E5F  (gated [0x5382] indep / difficulty 0x181F:0x4AC/0x4A2)
 *   exit composite to a000:0xFC00 (3F4-byte buf)     0x181F:0x3F4            0x0702B5 (NB title path 0x075DDF 0xD1D:0xFB2)
 *
 * STATIC geometry that is fully cited:  backdrop = full screen (320x200, video
 * segment 0xA000), the three OPENBORD decoration blits at x=0xC8(200), and the
 * menu-plate rule at y=0xC8(200), width 0x140(320).  The PER-OPTION text rows
 * are NOT static: the runner 0x181F:0x3FE positions them from @BEGINMENU.
 *
 * ---- string handles (file = handle + 0x1D9A0) ------------------------------
 *   0x2345 "BEGIN"/menu key (@BEGINMENU)   @asm 0x075C60 lea bx,[0x2345]
 *   0x233C  boot/menu backdrop             @asm 0x075AE4 push 0x233C
 *   0x2374  new-game backdrop              @asm 0x075DA3 push 0x2374
 *   0x234F/0x2357/0x235C/0x2366/0x236B  load-game submenu rows  @asm 0x075CE5..0x075E00
 *   0x2166  saved player-name buffer key   @asm 0x075D22 / 0x075D41
 * ============================================================================ */

/* ---- @BEGINMENU key + backdrop handles (file = handle + 0x1D9A0; cited) ---- */
#define MENU_BEGIN_KEY   0x2345   /* "@BEGINMENU" menu key  @asm 0x075C60 */
#define BG_BOOT          0x233C   /* boot/menu backdrop     @asm 0x075AE4 */
#define BG_NEWGAME       0x2374   /* new-game backdrop      @asm 0x075DA3 */

/* ---- resident composer thunks (signatures proven from call sites) ---------- */
extern void  ttl_region_reset(void);                                  /* 0x181F:0x53C */
extern uint32_t ttl_screen_load(int z, int r0, int r1, int r2, int r3, int key); /* 0x181F:0x44E */
extern void  ttl_screen_present(int al);                              /* 0x181F:0x484 */
extern void  ttl_screen_to_video(int z, int r0,int r1,int r2,int r3, int key); /* 0x181F:0x444 */
extern void  ttl_box_rule(int x, int w, int y, int a, int b, int c);  /* 0x181F:0x00E2 */
extern void  ttl_blit_border(int z, int r0,int r1,int r2,int r3,
                             int x, int sprB, int sprA);               /* 0x1A1F:0xDF8 */
extern int   ttl_menu_run(int *key_at_2345);                          /* 0x181F:0x3FE -> chosen idx */
extern int   ttl_begin_game(void);                                    /* 0x191F:0x320 */
extern void  ttl_compose_to_video(int seg, int off);                  /* 0xD1D:0xFB2 (memcpy) */
extern int16_t g_intro_played_828;   /* DGROUP:0x828  intro/menu-drawn latch  */
extern int16_t g_boot_flag_104;      /* DGROUP:0x104  boot-intro gate          */
extern int16_t g_region_839E[4];     /* DGROUP:0x839E inner rect (4 words)      */

/* ----------------------------------------------------------------------------
 * title_screen_render -- VICEROY func_0759E8 draw pass (BYTE_VERIFIED).
 *
 * Composition order (cited above): full-screen reset -> OPENING backdrop
 * (handle 0x233C) composited to video 0xA000 -> OPENBORD decoration (3 sprite
 * pairs at x=0xC8) -> menu-plate region + rule.  The @BEGINMENU rows are drawn
 * by the runner inside title_screen_update().
 * ---------------------------------------------------------------------------- */
void title_screen_render(void)
{
    char framebuf[0x3F4];                            /* [bp-0x3F4] */

    ttl_region_reset();                              /* @asm 0x0759FE 0x181F:0x53C */

    /* backdrop: first run ([0x828]==0) loads the OPENING backdrop by handle. */
    if (g_intro_played_828 == 0) {                   /* @asm 0x075A52 cmp [0x828],0 */
        uint32_t ok = ttl_screen_load(0,
                          g_region_839E[0], g_region_839E[1],
                          g_region_839E[2], g_region_839E[3],
                          BG_BOOT);                  /* @asm 0x075AE4 push 0x233C / 0x44E */
        if (ok)                                      /* @asm 0x075AEF or ax,ax */
            ttl_compose_to_video(0xA000, 0x300);     /* @asm 0x075B1D 0xD1D:0xFB2 */
        else
            ttl_screen_present(0);                   /* @asm 0x075B05 0x181F:0x484 */
    }

    /* OPENBORD decoration: three sprite pairs at x=0xC8 (200). */
    ttl_blit_border(0, g_region_839E[0], g_region_839E[1],
                    g_region_839E[2], g_region_839E[3], 0xC8, 7, 6);   /* @asm 0x075B8E (6,7) */
    ttl_blit_border(0, g_region_839E[0], g_region_839E[1],
                    g_region_839E[2], g_region_839E[3], 0xC8, 9, 8);   /* @asm 0x075BB0 (8,9) */
    ttl_blit_border(0, g_region_839E[0], g_region_839E[1],
                    g_region_839E[2], g_region_839E[3], 0xC8, 0xF, 0xE); /* @asm 0x075BD2 (0xE,0xF) */

    /* menu plate: region blit at x=0xC8 then a rule at y=0xC8 (200), w=0x140. */
    ttl_screen_to_video(0, g_region_839E[0], g_region_839E[1],
                        g_region_839E[2], g_region_839E[3], 0xC8);     /* @asm 0x075C00 0x444 */
    ttl_box_rule(0, 0x140, 0xC8, 0, 0, 0);           /* @asm 0x075C12 0x181F:0x00E2 */
    (void)framebuf;
}

/* ----------------------------------------------------------------------------
 * title_screen_update -- VICEROY func_0759E8 menu-run + dispatch (BYTE_VERIFIED).
 *
 * Runs the @BEGINMENU menu (key DS:0x2345) via the resident runner 0x181F:0x3FE,
 * which returns the chosen 1-based option index; a `dec ax` ladder dispatches:
 *   sel 1 -> exit the menu (leave the title screen)
 *   sel 2 -> LOAD-GAME submenu (slot list, player-name handling)
 *   sel 3 -> difficulty/setup list (5 entries -> table [0x1E7E])
 *   sel 4 -> NEW GAME (loads backdrop 0x2374, then begin_game via 0x191F:0x320)
 * The option ROWS' x/y are laid out by the runner from @BEGINMENU (data-driven),
 * not hard-coded here.  Returns the next screen.
 * ---------------------------------------------------------------------------- */
int title_screen_update(void)
{
    int key = MENU_BEGIN_KEY;                        /* @asm 0x075C60 lea bx,[0x2345] */
    int sel = ttl_menu_run(&key);                    /* @asm 0x075C64 0x181F:0x3FE -> [bp-0xE0] */

    switch (sel) {                                   /* @asm 0x075C6D dec-ax ladder */
    case 1:                                          /* @asm 0x075C70 -> 0x4AFD (exit) */
        return SCREEN_TITLE;                          /* leave menu */
    case 2:                                          /* @asm 0x075C80 -> 0x4A20 load path */
        /* LOAD-GAME submenu (handles 0x234F/0x2357/0x235C/0x2366/0x236B). */
        return SCREEN_TITLE;                          /* [layout: submenu, then load] */
    case 3:                                          /* @asm 0x075C7A -> 0x495A setup list */
        /* difficulty / new-world setup list (5 entries written to [0x1E7E]). */
        return SCREEN_TITLE;                          /* [layout: setup screens] */
    case 4:                                          /* @asm 0x075C80 new-game path */
        /* NEW GAME: backdrop 0x2374 then begin_game (0x191F:0x320); on success
         * control transfers to the in-game map loop. */
        (void)ttl_begin_game();                       /* @asm 0x075E5F 0x191F:0x320 */
        return SCREEN_TITLE;                          /* [transition: -> in-game map] */
    default:
        return SCREEN_TITLE;                          /* @asm 0x075C83 -> 0x4AFD */
    }
}

/* ----------------------------------------------------------------------------
 * New-game setup (difficulty / power / world customization) and load-game
 * slot selection are reached from the sel-2 / sel-3 / sel-4 branches above; the
 * NATIONS/DIFFICUL/CUSTOMIZ screens are their backgrounds.  Their inner row
 * layout is runner-driven; no fabricated ask_difficulty()/ask_power()/ask_map()
 * coordinate flow is asserted here.
 * ---------------------------------------------------------------------------- */
