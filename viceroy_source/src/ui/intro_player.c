/* ============================================================================
 * intro_player.c -- ROUTE_B Phase 6.4: the boxed-experience opening sequence.
 * ----------------------------------------------------------------------------
 * The original boots OPENING.EXE (a separate 89 KB MADS media player) before
 * VICEROY.EXE. OPENING.EXE reads OPENING.TXT (the human-readable animation
 * SCRIPT), draws the OPENING.PIK backdrop + palette and the OPEN*.SS sprite
 * series, runs the timed credits + animation sequence, prints "Loading
 * Game...", then chains to the title.
 *
 * This is the modern port of that player, data-driven from the user's own
 * files (copyright rule): every frame/timing/sprite comes from OPENING.TXT +
 * OPENING.PIK + the OPEN*.SS sheets. The script format is self-documented in
 * OPENING.TXT:
 *     @CREDITS : start_frame, end_frame, series, sprite   (timed credit cards)
 *     @OPENING : series, frame, repeats, baseX            (animation triggers)
 *     @MESSAGES: the "Loading Game..." string
 *
 * Series -> sheet binding is BYTE-DERIVED from the shipped .SS filenames, which
 * match the script's own inline labels 1:1 (Wind1=OPENWND1, Sun=OPENSUN, ...).
 *
 * FIDELITY NOTE: the per-frame sprite layout and the exact tick rate live in
 * OPENING.EXE's player loop (324 functions decompiled; 16-bit MZ string-xref
 * recovery is partial, so the precise frame cadence is RECONSTRUCTED here and
 * the rendering rides the existing platform pik/ss/video layer). The SCHEDULE
 * (what plays at which frame) is exact, straight from OPENING.TXT. Full
 * byte-verification of OPENING.EXE's cadence/positioning is the remaining
 * refinement; see docs/INTRO_PLAYER.md.
 * ============================================================================ */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INTRO_MAX_CREDITS 64
#define INTRO_MAX_ANIMS   32

typedef struct { int start, end, series, sprite; } intro_credit_t;
typedef struct { int series, frame, repeats, basex; } intro_anim_t;

static intro_credit_t g_credits[INTRO_MAX_CREDITS];
static intro_anim_t   g_anims[INTRO_MAX_ANIMS];
static int g_ncredits, g_nanims, g_end_frame;
static char g_loading_msg[64];

/* @OPENING series index -> sprite sheet (derived from the .SS filenames, which
 * match OPENING.TXT's inline labels exactly). Index is the script's "series". */
static const char *const g_anim_sheet[10] = {
    "OPENWND1.SS", /* 0 Wind 1            */
    "OPENSUN.SS",  /* 1 Sun               */
    "OPENMON1.SS", /* 2 Monster 1         */
    "OPENWND2.SS", /* 3 Wind 2            */
    "OPENMON2.SS", /* 4 Monster 2         */
    "OPENMON3.SS", /* 5 Monster 3         */
    "OPENFISH.SS", /* 6 Fish              */
    "OPENGUY.SS",  /* 7 Guy getting out   */
    "OPENLOGO.SS", /* 8 Opening logo      */
    "OPENBONK.SS", /* 9 Bonk into land    */
};
/* @CREDITS series index -> credit-card sheet. */
static const char *const g_credit_sheet[3] = {
    "OPENCRD1.SS", "OPENCRD2.SS", "OPENCRD3.SS",
};

const char *intro_anim_sheet(int series)
{
    return (series >= 0 && series < 10) ? g_anim_sheet[series] : 0;
}
const char *intro_credit_sheet(int series)
{
    return (series >= 0 && series < 3) ? g_credit_sheet[series] : 0;
}

/* ----------------------------------------------------------------------------
 * intro_load_script -- parse OPENING.TXT into the credit/anim schedule.
 * Mirrors the original player's section reader (the same @SECTION + CSV-with-
 * ';' comment grammar used by NAMES.TXT/GAME.TXT). Returns 0 on success.
 * -------------------------------------------------------------------------- */
int intro_load_script(const char *dir)
{
    char path[512], line[256];
    snprintf(path, sizeof path, "%s/OPENING.TXT", dir);
    FILE *f = fopen(path, "r");
    if (!f) return -1;

    enum { NONE, CREDITS, OPENING, MESSAGES } sect = NONE;
    g_ncredits = g_nanims = 0; g_end_frame = 0; g_loading_msg[0] = 0;

    while (fgets(line, sizeof line, f)) {
        char *p = line + strspn(line, " \t");
        char *semi = strchr(p, ';'); if (semi) *semi = 0;       /* strip comment */
        size_t len = strcspn(p, "\r\n"); p[len] = 0;
        /* trim trailing ws */
        while (len && (p[len-1] == ' ' || p[len-1] == '\t')) p[--len] = 0;
        if (!p[0]) continue;
        if (p[0] == '@') {
            if      (!strncmp(p, "@CREDITS", 8))  sect = CREDITS;
            else if (!strncmp(p, "@OPENING", 8))  sect = OPENING;
            else if (!strncmp(p, "@MESSAGES", 9)) sect = MESSAGES;
            else sect = NONE;
            continue;
        }
        if (sect == CREDITS && g_ncredits < INTRO_MAX_CREDITS) {
            intro_credit_t c;
            if (sscanf(p, "%d , %d , %d , %d", &c.start, &c.end, &c.series, &c.sprite) == 4) {
                g_credits[g_ncredits++] = c;
                if (c.end > g_end_frame) g_end_frame = c.end;
            }
        } else if (sect == OPENING && g_nanims < INTRO_MAX_ANIMS) {
            intro_anim_t a;
            if (sscanf(p, "%d , %d , %d , %d", &a.series, &a.frame, &a.repeats, &a.basex) == 4) {
                g_anims[g_nanims++] = a;
                if (a.frame > g_end_frame) g_end_frame = a.frame;   /* -1 series = END marker */
            }
        } else if (sect == MESSAGES && !g_loading_msg[0]) {
            strncpy(g_loading_msg, p, sizeof g_loading_msg - 1);
        }
    }
    fclose(f);
    return (g_ncredits || g_nanims) ? 0 : -1;
}

int intro_credit_count(void)        { return g_ncredits; }
int intro_anim_count(void)          { return g_nanims; }
int intro_end_frame(void)           { return g_end_frame; }
const char *intro_loading_msg(void) { return g_loading_msg; }

/* ----------------------------------------------------------------------------
 * intro_play -- run the opening sequence, then return (caller shows the title).
 *
 * Renders through the platform layer when a display is present; headless it
 * walks the schedule (so the sequencing is exercised and self-checkable). The
 * frame loop advances frame 0..end_frame, firing each @OPENING animation at its
 * trigger frame and showing each @CREDITS card during its [start,end] window;
 * at the end it presents the @MESSAGES "Loading Game..." line.
 * -------------------------------------------------------------------------- */
int intro_play(const char *dir)
{
    if (intro_load_script(dir) != 0) return -1;

    /* backdrop + palette: OPENING.PIK (MADSPACK 2.0; pik.c). Optional sheets are
     * loaded lazily per series by the render hook. */
    extern int  intro_render_open(const char *dir);   /* platform: load PIK/sheets, 0 ok */
    extern void intro_render_frame(int frame, const intro_credit_t *creds, int nc,
                                   const intro_anim_t *anims, int na);
    extern void intro_render_message(const char *msg);
    extern void intro_render_close(void);
    extern int  intro_aborted(void);                  /* platform: key/ESC pressed */

    int have_video = (intro_render_open(dir) == 0);
    for (int frame = 0; frame <= g_end_frame; frame++) {
        if (have_video) {
            intro_render_frame(frame, g_credits, g_ncredits, g_anims, g_nanims);
            if (intro_aborted()) break;               /* original: any key skips */
        }
    }
    if (have_video) {
        intro_render_message(g_loading_msg);
        intro_render_close();
    }
    return 0;
}

/* Weak headless defaults for the platform render hooks: open returns -1 (no
 * display), so intro_play validates+loads the script without drawing. A real
 * SDL renderer (src/platform/) provides strong overrides that decode OPENING.PIK
 * + the OPEN*.SS series and blit the frames. */
__attribute__((weak)) int  intro_render_open(const char *dir) { (void)dir; return -1; }
__attribute__((weak)) void intro_render_frame(int frame, const intro_credit_t *c, int nc,
                                              const intro_anim_t *a, int na)
{ (void)frame; (void)c; (void)nc; (void)a; (void)na; }
__attribute__((weak)) void intro_render_message(const char *m) { (void)m; }
__attribute__((weak)) void intro_render_close(void) {}
__attribute__((weak)) int  intro_aborted(void) { return 0; }
