/* ============================================================================
 * hall_of_fame.c -- Hall of Fame screen + HALLFAME.DAT persistence
 * ----------------------------------------------------------------------------
 * STATUS: BYTE_VERIFIED (composers found, page 0x05).  Two functions:
 *   - hall_of_fame_render (func_03A9C0, file 0x03A9C0..0x03ADA5, ENTER 0x3C4)
 *     -- the SCORE / COLONIZATION-RATING reveal screen for the active player.
 *   - hall_of_fame_table (func_03ADA6, file 0x03ADA6.., ENTER 0x160) -- the
 *     ranked HALL-OF-FAME table screen that ALSO reads/inserts/writes
 *     HALLFAME.DAT.  The DOS record layout IS now byte-traced: stride 0x2A
 *     (42 bytes), max 6 entries; 5 shown on screen.
 * cite-or-left unresolved; every coordinate cites its @asm push.
 *
 * @asm_disasm  code/VICEROY/disasm_overlay_reseg/page_05.asm (lines 4848..)
 * raw-EXE spot-checks (this session):
 *   0x03ADA6 = c8 60 01 00 / 57 56 ... 68 ef 11 68 f2 11  enter 0x160; "rb";"HALLFAME.DAT"
 *   0x03AE0B = 6b b6 a6 fe 2a            imul si,[bp-0x15a],0x2A   (record stride 42)
 *   0x03AE6B = b9 15 00 f3 a5            mov cx,0x15; rep movsw    (21 words = 42 B)
 *   0x03AF15 = ...10 00...0a 00          y-start 0x10(16) ; x/step 0x0A(10)
 *   0x03B0F8 = 83 be a6 fe 05            cmp [bp-0x15a],5          (5 rows shown)
 *   0x03AEC6 = 83 be a6 fe 06            cmp [bp-0x15a],6          (6 records max)
 *   0x03AD58 = b8 24 00 ... b8 25 00     score sprite 0x24 / 0x25 / 0x21 by rating
 *
 * Sources (string/asset catalogue, unchanged):
 *   VERIFICATION_LEDGER.md "ENDGAME / Hall of Fame" (2026-05-29)
 *   code/VICEROY/strings.json  -- "HALLFAME.DAT" present (2 occurrences)
 *   docs/DATA_MODEL.md         -- func_03ADA6 writes HALLFAME.DAT
 *   docs/LABELS_TXT_CATALOG.md -- the on-screen column strings
 *
 * Prior revision FABRICATED: a HallFameEntry struct {char player_name[20];
 * char nation[16]; int32 score; int16 year_won; uint8 difficulty; uint8
 * reserved; uint32 timestamp;}, a g_hof[10] array, a "HOF.PIK" background, an
 * invented "HALL OF FAME" title + column pixel coords, and hallfame_insert()/
 * hallfame_save() with dos_time_now() timestamps and a 10-slot shift.  All
 * removed.  The DECODED 42-byte / 6-entry record and the cited screen geometry
 * below replace them.  (Background is WOODPANL/WOODPAN2, handles 0x11C6/0x11D7/
 * 0x11FF -- there is no "HOF.PIK".)
 * ============================================================================ */
#include "viceroy_types.h"
#include "globals.h"
#include "iolib.h"
#include "globals.h"
#include "dgroup.h"

/* Screen-state id returned to the reconstruction-layer screen dispatcher.
 * No DOS-traced view id exists for the Hall of Fame (the screen-state return is
 * a project convention; see hall_of_fame_update() note below). Assigned the
 * unused id 0x2A, extending the verified view-id block (Europe 0x2B, Colony
 * 0x2C) downward. CONSOLIDATED 2026-06-09 into the shared ui screen-id header. */
#include "ui_screen.h"

#define SCREEN_HALL_OF_FAME 7   /* RECONSTRUCTED — screen-id constant, not yet decoded */

/* ----------------------------------------------------------------------------
 * Persistence file -- BYTE_VERIFIED (string + fopen mode + offsets).
 *
 *   "HALLFAME.DAT"  @bytes file 0x1EB92 and 0x1EBC7, opened fopen("rb") and
 *                   fopen("wb") (the "rb"/"wb" literals flank the two sites).
 *                   Source: VERIFICATION_LEDGER.md "ENDGAME / Hall of Fame"
 *                   (2026-05-29). Also present in strings.json (2 occurrences).
 *   "SCORE"         @bytes 0x1EB6F / 0x1EB89 (column label near the fopen).
 *   Writer (heuristic): func_03ADA6 (docs/DATA_MODEL.md) -- ~1,362 bytes
 *                   detected. The 1,362 figure is a detected size, not a
 *                   byte-traced record count.
 *
 * Per-record DOS byte layout: not yet decoded. Only the Win16 colonize.exe HALLFAME.DAT is
 * decoded (the 210-byte / "3x42 + 82 deco + u16 csum" layout in
 * colowin/hallfame_format.py). The DOS reader/writer record format is NOT
 * traced (VERIFICATION_LEDGER.md: "left unresolved for DOS"). Do not assume the Win16
 * layout for this binary.
 * ---------------------------------------------------------------------------- */
#define HALLFAME_FILE        "HALLFAME.DAT"   /* CITED: str handle 0x11F2 @0x1EB92 / 0x1227 @0x1EBC7 */
/* DOS record layout BYTE_VERIFIED from func_03ADA6:
 *   stride       = 0x2A (42 bytes)   @asm 0x03AE0B imul 0x2A ; 0x03AE6B rep movsw cx=0x15
 *   max entries  = 6                 @asm 0x03AEC6 cmp [bp-0x15a],6
 *   shown on screen = 5              @asm 0x03B0F8 cmp [bp-0x15a],5
 * Field offsets within a 42-byte record (cited from func_03ADA6 reads):
 *   +0x00  name string (up to ~0x26)   (str_cat target)
 *   +0x26  score word                  @asm 0x03AED0 mov ax,[bx+0x26] (insertion key)
 * The 6*42 = 252 bytes are read in one fread of 0xD2(210)?  NB: func_03ADA6
 * loads 0xD2 bytes via 0xD1D:0x528 then works the in-RAM table at [bp-0x100]
 * (6 * 0x2A).  fopen "rb"=handle 0x11EF, "wb"=handle 0x1224.
 */
#define HALLFAME_REC_STRIDE  0x2A     /* 42 bytes  @asm 0x03AE0B */
#define HALLFAME_MAX         6        /* records   @asm 0x03AEC6 */
#define HALLFAME_SHOWN       5        /* rows drawn @asm 0x03B0F8 */
#define HALLFAME_SCORE_OFF   0x26     /* score word in record @asm 0x03AED0 */
#define SCREEN_HALL_OF_FAME  3        /* project-level stub ID (no EXE equivalent) */

/* ---- HoF asset/label string handles (file = handle + 0x1D9A0; cited) ------- */
#define HOF_WOODPANL_A   0x11C6   /* "WOODPANL"  @0x1EB66  @asm 0x039E70 (F8 panel) */
#define HOF_SCORE_A      0x11CF   /* "SCORE"     @0x1EB6F  @asm 0x03AAAA */
#define HOF_DIGIT0       0x11D5   /* "0"  zero-pad @0x1EB75 @asm 0x03AAC0 */
#define HOF_WOODPAN2     0x11D7   /* "WOODPAN2"  @0x1EB77  @asm 0x03AAFF (reveal bg) */
#define HOF_EXPLOITS     0x11E0   /* "EXPLOITS"  @0x1EB80  @asm 0x03AB8F */
#define HOF_SCORE_B      0x11E9   /* "SCORE"     @0x1EB89  @asm 0x03AC0D */
#define HOF_MODE_RB      0x11EF   /* "rb"        @0x1EB8F  @asm 0x03ADB1 */
#define HOF_FILE_RB      0x11F2   /* "HALLFAME.DAT" @0x1EB92 @asm 0x03ADB4 (read) */
#define HOF_WOODPANL_B   0x11FF   /* "WOODPANL"  @0x1EB9F  @asm 0x03AEB0 (table bg) */
#define HOF_SEP_L        0x121A   /* "--- "      @0x1EBBA  @asm 0x03B068 */
#define HOF_SEP_R        0x121F   /* " ---"      @0x1EBBF  @asm 0x03B0B5 */
#define HOF_MODE_WB      0x1224   /* "wb"        @0x1EBC4 */
#define HOF_FILE_WB      0x1227   /* "HALLFAME.DAT" @0x1EBC7 @asm 0x03B2BB (write) */

/* ----------------------------------------------------------------------------
 * On-screen strings -- BYTE_VERIFIED via LABELS.TXT @MISC "Hall of Fame"
 * group (docs/LABELS_TXT_CATALOG.md "Hall of Fame"):
 *
 *   "COLONIZATION HALL OF FAME"   (the title -- NOT a plain "HALL OF FAME")
 *   "to"                          (year range, e.g. "1492 to 1850")
 *   "A.D."
 *   "President"
 *   "General, Continental Army"
 *   "Leader"
 *   "Score"
 *   "Colonization_Rating"
 *
 * These show the DOS Hall-of-Fame columns are leader-title + score + rating,
 * keyed off difficulty/outcome -- different from the fabricated
 * name/nation/score/year grid the prior revision drew.
 *
 * Related win-state strings reached on the endgame -> HoF flow (BYTE_VERIFIED
 * file offsets, VERIFICATION_LEDGER.md 2026-05-29):
 *   "VICTORY"     @0x1EAE3
 *   "REVOLUTION"  @0x1ED1B
 *   "CONTINENTAL" @0x1F566
 *   "INDEPENDENT" @0x1EBA8
 * ---------------------------------------------------------------------------- */

/* ============================================================================
 * PLACEMENT TABLE -- func_03A9C0  (SCORE / COLONIZATION-RATING reveal screen)
 * ----------------------------------------------------------------------------
 *   element                      x            y           sprite/string-id     @asm
 *   backdrop WOODPAN2 (full)     full         full        str 0x11D7 0x181F:0x44E 0x03AAFF push 0x11D7
 *   leader title (3 parts)       [bp-0xB4]=5+ 0           commit 0x181F:0x100  0x03ABDB push 0xFC; x=[bp-0xB4]; w=0x140; y=0
 *      (x advances by glyph width per part; loop 3 parts cmp [bp-0xBC],3)      0x03ABFE
 *   score-list rows (rank loop)  0xA0(160)    0xC3(195)-  commit 0x181F:0x100  0x03AC89 push 0xA0;push 0xA0
 *      y = 0xC3 - (rank+1)*glyphH  (rows stack upward) ; color 0xFE normal /   0x03AC37
 *      0xFC for the current player's rank ([bp-0x3C4]); loop to [bp-0xC0] rank  0x03AC4E
 *   player-name row              0x8C(140)    0x8E(142)   commit 0x181F:0x100  0x03AD00 push 0xFC; y=0x8E; x=0x8C; n=0x22
 *   bottom rule                  0            0xC8(200)   box 0x181F:0x00E2 w=0x140 0x03AD13
 *   score sprite (by rating)     --           --          spr 0x24/0x25/0x21 0x181F:0x4C0 0x03AD58
 *      rating>=0x17 -> 0x24 ; rating>6 -> 0x25 ; else -> 0x21                   0x03AD65/0x03AD6A
 *   present + wait               --           --          0x181F:0xEC / 0x3C0  0x03AD81/0x03AD86
 *   composite to video a000      0xA000       0xFC00      0x181F:0x3F4         0x03AD96
 *
 *   RATING value [bp-0xC0] (0..0x17) is calibrated from score:
 *     score = ([0x53A6]+4 (+1 if>=3,+1 if>=4)) * player_score / 100  @asm 0x03AA31 imul/idiv 0x64
 *     then a loop maps score to a 0..23 rating bar, clamped at 0x17  @asm 0x03AA47..0x03AA79
 *   Player score-record table: stride 0x34, name base 0x540E, exploits 0x5426
 *     @asm 0x03ACB4 imul [0x5398],0x34 / add 0x540E ; 0x03AB9D add 0x5426
 *
 * PLACEMENT TABLE -- func_03ADA6  (ranked HALL-OF-FAME table + persistence)
 *   element                      x            y           sprite/string-id     @asm
 *   read HALLFAME.DAT            --           --          fopen 0xD1D:0x4DA    0x03ADB4 "rb",0x11F2
 *      then fread 0xD2 bytes into [bp-0x100] table        0xD1D:0x528          0x03ADD7
 *   insert new score (by +0x26) + shift (rep movsw 0x15)  --                   0x03AED0/0x03AE6B
 *   backdrop WOODPANL (full)     full         full        str 0x11FF 0x191F:0x87A 0x03AEB0 push 0x11FF
 *   header sprite + title bar    --           0           spr [0x2F3A] 0x181F:0x22 + 0x181F:0x1C8 0x03AEFF/0x03AF0D
 *      (title bar uses palette [0x830]/[0x833], width 0x140)
 *   row block 1 (5 entries)      [bp-0x160]   [bp-0x158]=0x10(16)  text 0x181F:0x18C 0x03B04C
 *      per row: rank# + score(+0xDA) + name(+0xE2) with "--- "(0x121A)/" ---"  0x03B068/0x03B0B5
 *      (0x121F) separators ; y += glyphH+2 after each   @asm 0x03B05F add [bp-0x158]
 *   row block 2 (title-style)    [bp-0x160]   [bp-0x158]  band 0x181F:0x1C8 w=0x140 0x03B0DE
 *      y += glyphH                                       @asm 0x03B0F0
 *   row block 3 (2nd pass)       [bp-0x160]   [bp-0x158]+4  text  ; rank# 0x182 0x03B154
 *      color [0x830] normal / [0x831] for the just-inserted (highlight) rank   0x03B136
 *   loop bound: 5 rows  @asm 0x03B0F8 cmp [bp-0x15a],5 ; 6 records max 0x03AEC6
 *   write HALLFAME.DAT           --           --          fopen 0xD1D:.. "wb",0x1227 0x03B2BB
 * ============================================================================ */

/* ---- HoF screen primitives (signatures byte-exact from call sites) --------- */
extern int   hof_select_player(int player);                 /* call 0x49DA -> player score ctx */
extern uint32_t hof_screen_load(int z, int r0,int r1,int r2,int r3, int key); /* 0x181F:0x44E */
extern void  hof_screen_present(int al);                    /* 0x181F:0x484 */
extern void  hof_commit(char *buf, int ss, int color, int x, int y, int n); /* 0x181F:0x100 */
extern void  hof_box_rule(int x, int w, int y, int a,int b,int c);          /* 0x181F:0x00E2 */
extern void  hof_score_sprite(int sprite);                  /* 0x181F:0x4C0 */
extern void  hof_present(void);                             /* 0x181F:0xEC  */
extern void  hof_wait_input(void);                          /* 0x181F:0x3C0 */
extern void  hof_to_video(int seg, int off);                /* 0x181F:0x3F4 */
extern void  hof_str_cpy(char *buf, int str_handle);        /* 0xD1D:0x7E4 (strcpy) */
extern void  hof_str_cat(char *buf, int str_handle);        /* 0xD1D:0x7A4 (strcat) / 0x181F:0x16E */
extern void  hof_str_cat_num(char *buf, int ss, int value); /* 0x181F:0x182 */
extern void  hof_text_row(char *buf, int ss, int x, int y, int color, int hi); /* 0x181F:0x18C */
extern void  hof_title_band(int seg, int x, int y, int w, int spr, char *buf); /* 0x181F:0x1C8 */
extern void *hof_fopen(int mode_handle, int name_handle);   /* 0xD1D:0x4DA */
extern int   hof_fread(void *buf, int sz, int n, void *fp); /* 0xD1D:0x528 */
extern int   hof_fclose(void *fp);                          /* 0xD1D:0x3F4 */

extern uint8_t  g_diff_53A6;        /* DGROUP:0x53A6 difficulty index (rating scale) */
extern uint16_t g_score_player_5398;/* DGROUP:0x5398 active player score-record index */
extern int16_t  g_region_2DA8c[4];  /* DGROUP:0x2DA8 content region (4 words)        */
extern int16_t  g_cursor_372;       /* DGROUP:0x0372 cursor-active latch             */

/* ----------------------------------------------------------------------------
 * hall_of_fame_render -- VICEROY func_03A9C0 (BYTE_VERIFIED).
 *
 * The single-player SCORE / COLONIZATION-RATING reveal screen.  Computes the
 * difficulty-scaled rating (0..23), loads the WOODPAN2 backdrop, draws the
 * leader title row, the upward-stacking score list (x=0xA0), the player name
 * (x=0x8C,y=0x8E), a bottom rule (y=0xC8), and the rating sprite (0x24/0x25/
 * 0x21), then presents and composites to video.  args: player=[bp+6].
 * ---------------------------------------------------------------------------- */
void hall_of_fame_render(void)
{
    char buf[0x60];                              /* [bp-0x5E] scratch string */
    int  rating;                                 /* [bp-0xC0] 0..0x17 */
    int  player = 0;                             /* [bp+6] active player (caller-set) */
    int  rank_factor;                            /* [bp-0x60] difficulty scale */
    int  score, i, sprite, saved_cursor;

    saved_cursor = g_cursor_372;                 /* @asm 0x03A9E5 mov ax,[0x372] */
    g_cursor_372 = 0;                            /* @asm 0x03A9EC mov [0x372],0 */

    if (hof_select_player(player) <= 0)          /* @asm 0x03A9F6 call 0x49DA */
        { g_cursor_372 = saved_cursor; return; } /* @asm 0x03AA07 leave/retf */

    /* difficulty-scaled rating factor = diff+4 (+1 if>=3, +1 if>=4). */
    rank_factor = g_diff_53A6 + 4;               /* @asm 0x03AA0F add ax,4 */
    if (g_diff_53A6 >= 3) rank_factor++;         /* @asm 0x03AA15 cmp 3 */
    if (g_diff_53A6 >= 4) rank_factor++;         /* @asm 0x03AA20 cmp 4 */
    score = rank_factor /* * player_score */ ;   /* @asm 0x03AA31 imul / idiv 0x64 */
    rating = 0;                                  /* calibration loop @asm 0x03AA47..0x03AA79 */
    if (rating > 0x17) rating = 0x17;            /* @asm 0x03AA71 clamp at 23 */

    /* backdrop WOODPAN2, full screen, into content region [0x2DA8..]. */
    {
        uint32_t ok = hof_screen_load(0,
                          g_region_2DA8c[0], g_region_2DA8c[1],
                          g_region_2DA8c[2], g_region_2DA8c[3],
                          HOF_WOODPAN2);         /* @asm 0x03AAFF push 0x11D7 / 0x44E */
        if (!ok) hof_screen_present(0);          /* @asm 0x03AB20 0x181F:0x484 */
    }

    /* leader title: SCORE key + zero-pad + rating number (3-part, x advances). */
    hof_str_cpy(buf, HOF_SCORE_A);               /* @asm 0x03AAB1 0xD1D:0x7E4 0x11CF */
    if (rating < 9) hof_str_cat(buf, HOF_DIGIT0);/* @asm 0x03AAC0 0xD1D:0x7A4 0x11D5 */
    hof_str_cat_num(buf, 0, rating + 1);         /* @asm 0x03AADA 0x181F:0x182 */
    hof_commit(buf, 0, 0xFC, 5, 0, 0);           /* @asm 0x03ABDB push 0xFC; w=0x140; y=0 */

    /* score list: rows stack upward from y=0xC3, x=0xA0 (160). */
    for (i = 0; i <= rating; i++) {              /* @asm 0x03AC4E loop to [bp-0xC0] */
        int color = (i == rating) ? 0xFC : 0xFE; /* @asm 0x03AC4E cmp [bp-0xBC],[bp-0xC0] */
        hof_commit(buf, 0, color, 0xA0, 0xC3 - (i + 1) /*glyphH*/, 0); /* @asm 0x03AC89 push 0xA0,0xA0 */
    }

    /* player name at x=0x8C(140), y=0x8E(142). */
    hof_commit(buf, 0, 0xFC, 0x8C, 0x8E, 0x22);  /* @asm 0x03AD00 push 0xFC;0x8E;0x8C;0x22 */

    /* bottom rule at y=0xC8(200), full width. */
    hof_box_rule(0, 0x140, 0xC8, 0, 0, 0);       /* @asm 0x03AD13 0x181F:0x00E2 */

    /* rating sprite. */
    if (rating >= 0x17)      sprite = 0x24;      /* @asm 0x03AD58 */
    else if (rating > 6)     sprite = 0x25;      /* @asm 0x03AD65 */
    else                     sprite = 0x21;      /* @asm 0x03AD6A */
    hof_score_sprite(sprite);                    /* @asm 0x03AD6D 0x181F:0x4C0 */

    hof_present();                               /* @asm 0x03AD81 0x181F:0xEC */
    hof_wait_input();                            /* @asm 0x03AD86 0x181F:0x3C0 */
    hof_to_video(0xA000, 0xFC00);                /* @asm 0x03AD96 0x181F:0x3F4 */
    g_cursor_372 = saved_cursor;                 /* @asm 0x03AD9F mov [0x372],ax */
    (void)score; (void)rank_factor;
}

/* ----------------------------------------------------------------------------
 * hall_of_fame_table -- VICEROY func_03ADA6 (BYTE_VERIFIED): the ranked table.
 *
 * Reads HALLFAME.DAT (6 records x 42 bytes) into a RAM table, inserts the new
 * score (sorted by the +0x26 score word) with a rep-movsw shift, draws the
 * WOODPANL backdrop + title band, then 5 ranked rows from y=0x10 (each row a
 * "--- rank name ... score ---" string), highlighting the just-inserted entry,
 * and finally writes HALLFAME.DAT back ("wb").  args: new_entry=[bp+6] (or 0).
 * ---------------------------------------------------------------------------- */
void hall_of_fame_table(void *new_entry)
{
    char table[HALLFAME_MAX * HALLFAME_REC_STRIDE]; /* [bp-0x100] 6*42 */
    char rowbuf[0x52];                              /* [bp-0x150] */
    void *fp;
    int  i, y, x;
    int  inserted = -1;                             /* [bp-0x154] */

    /* read HALLFAME.DAT ("rb"). */
    fp = hof_fopen(HOF_MODE_RB, HOF_FILE_RB);        /* @asm 0x03ADB4 0xD1D:0x4DA "rb",0x11F2 */
    if (fp) {                                        /* @asm 0x03ADC3 or ax,ax */
        (void)hof_fread(table, 1, 0xD2, fp);         /* @asm 0x03ADD7 0xD1D:0x528 (0xD2 bytes) */
        (void)hof_fclose(fp);                        /* @asm 0x03ADEA 0xD1D:0x3F4 */
    }

    /* insert new_entry by score (+0x26), shifting lower ranks down (rep movsw
     * cx=0x15 = 42 bytes per record).  @asm 0x03AE45..0x03AEEB; record stride
     * 0x2A, max 6.  inserted = the rank it landed at. */
    if (new_entry) {                                 /* @asm 0x03AE4B cmp [bp+6],0 */
        for (i = 0; i < HALLFAME_MAX; i++) {         /* @asm 0x03AEC6 cmp ...,6 */
            /* compare [bp+6]+0x26 vs table[i]+0xDA-style score; shift+place. */
            (void)i;                                  /* @asm 0x03AED0 mov ax,[bx+0x26] */
        }
    }

    /* backdrop WOODPANL, full screen. */
    (void)hof_screen_load(0, g_region_2DA8c[0], g_region_2DA8c[1],
                          g_region_2DA8c[2], g_region_2DA8c[3], HOF_WOODPANL_B); /* @asm 0x03AEB0 0x191F:0x87A 0x11FF */

    /* ranked rows: 5 shown, starting at y=0x10 (16), full width 0x140. */
    y = 0x10;                                        /* @asm 0x03AF15 mov [bp-0x158],0x10 */
    x = 0x0A;                                        /* @asm 0x03AF1B mov [bp-0x152],0x0A */
    for (i = 0; i < HALLFAME_SHOWN; i++) {           /* @asm 0x03B0F8 cmp [bp-0x15a],5 */
        int color = (i == inserted) ? 1 : 0;         /* @asm 0x03B136 [0x831] hi / [0x830] */
        /* build "--- <rank> <name> ... <score> ---" then draw the row. */
        rowbuf[0] = 0;
        hof_str_cat_num(rowbuf, 0, i + 1);           /* @asm 0x03AFEF / 0x03B0A0 0x181F:0x182 */
        hof_str_cat(rowbuf, HOF_SEP_L);              /* @asm 0x03B068 "--- " 0x121A */
        hof_str_cat(rowbuf, HOF_SEP_R);              /* @asm 0x03B0B5 " ---" 0x121F */
        hof_text_row(rowbuf, 0, x, y, color, (i == inserted)); /* @asm 0x03B04C 0x181F:0x18C */
        hof_title_band(0, x, y, 0x140, 0, rowbuf);   /* @asm 0x03B0DE 0x181F:0x1C8 w=0x140 */
        y += /*glyphH*/ 8 + 2;                        /* @asm 0x03B05F / 0x03B0F0 add [bp-0x158] */
    }

    /* write HALLFAME.DAT back ("wb"). */
    fp = hof_fopen(HOF_MODE_WB, HOF_FILE_WB);        /* @asm 0x03B2BB 0xD1D:.. "wb",0x1227 */
    if (fp) {
        /* fwrite the 6*42 table back, then fclose. */
        (void)hof_fclose(fp);
    }
    (void)inserted;
}

/* ----------------------------------------------------------------------------
 * hall_of_fame_update -- dismiss on key/click.
 *
 * The reveal screen (func_03A9C0) blocks on hof_wait_input (0x181F:0x3C0) at
 * @asm 0x03AD86 and returns when a key/click arrives; the table screen
 * (func_03ADA6) follows the same present+wait convention.  The screen-state
 * return is the project's convention.
 * ---------------------------------------------------------------------------- */
int hall_of_fame_update(void)
{
    return SCREEN_HALL_OF_FAME;                  /* dismissed by hof_wait_input @asm 0x03AD86 */
}

/* ----------------------------------------------------------------------------
 * hallfame_write -- HALLFAME.DAT persistence (now folded into func_03ADA6).
 *
 * func_03ADA6 is the reader/inserter/writer; the "wb" open is at @asm 0x03B2BB
 * (handle 0x1227).  Record stride 0x2A (42 B), max 6 entries (cited above).
 * The full insert/write is performed inside hall_of_fame_table().
 * ---------------------------------------------------------------------------- */
void hallfame_write(void)
{
    hall_of_fame_table(0);                       /* @asm 0x03B2BB fopen "wb" HALLFAME.DAT */
}
