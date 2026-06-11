/* ============================================================================
 * script_input.c -- the determinism rig's input half (ROUTE_B_PLAN 0.1).
 * ----------------------------------------------------------------------------
 * Drives the shell from a text script instead of (ahead of) SDL, so the
 * same input sequence is byte-replayable run after run -- headless included
 * (without a script, headless vid_poll_key() returns 0 forever and the
 * shell cannot be driven at all).
 *
 * Script grammar (one directive per line; '#' comments):
 *   key TOKEN     queue one keypress.  TOKEN: ESC RETURN ENTER SPACE TAB
 *                 UP DOWN LEFT RIGHT F1..F12, a single character (b e 1 ...),
 *                 or a raw code 0xNN / decimal.
 *   wait N        N empty polls (lets the shell redraw between keys)
 *   shot PATH     write a PPM screenshot checkpoint (pixdiff input)
 *   seed N        set the MSC LCG seed word (DGROUP:0x28EE) at this point
 *   quit          deliver VID_QUIT_REQUESTED
 *
 * On script exhaustion: headless delivers quit (a finished script means a
 * finished run); with a display, input falls through to SDL.
 *
 * Activation: VICEROY_SCRIPT=path env or --script=path argv (main_modern).
 * Boot-time seeding: VICEROY_SEED=N env or --seed=N (applied before the
 * first poll; `seed` directives override mid-script).
 *
 * SDL2 keysym values are the shell's native vocabulary (KEY_UP=1073741906,
 * F1..F12 = 1073741882..1073741893); tokens map onto those exact codes.
 * ============================================================================ */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "platform.h"

extern unsigned int g_rand_seed_28EE;   /* runtime/rng.c (DGROUP:0x28EE) */
extern int vid_screenshot_ppm(const char *path);

enum ev_kind { EV_KEY, EV_WAIT, EV_SHOT, EV_SEED, EV_QUIT };

struct ev {
    enum ev_kind kind;
    int value;              /* key code / wait count / seed */
    char path[200];         /* shot target */
};

#define MAX_EV 4096
static struct ev q[MAX_EV];
static int q_len = 0, q_pos = 0, q_active = 0;

static const struct { const char *name; int code; } TOKENS[] = {
    {"ESC", 27}, {"RETURN", 13}, {"ENTER", 13}, {"SPACE", 32}, {"TAB", 9},
    {"UP", 1073741906}, {"DOWN", 1073741905},
    {"LEFT", 1073741904}, {"RIGHT", 1073741903},
    {"F1", 1073741882}, {"F2", 1073741883}, {"F3", 1073741884},
    {"F4", 1073741885}, {"F5", 1073741886}, {"F6", 1073741887},
    {"F7", 1073741888}, {"F8", 1073741889}, {"F9", 1073741890},
    {"F10", 1073741891}, {"F11", 1073741892}, {"F12", 1073741893},
};

static int token_code(const char *t)
{
    for (size_t i = 0; i < sizeof TOKENS / sizeof *TOKENS; i++)
        if (!strcmp(t, TOKENS[i].name))
            return TOKENS[i].code;
    if (t[0] && !t[1])
        return (unsigned char)t[0];           /* single character */
    if (!strncmp(t, "0x", 2) || (t[0] >= '0' && t[0] <= '9'))
        return (int)strtol(t, NULL, 0);       /* raw code */
    return -1;
}

int script_input_load(const char *path)
{
    FILE *f = fopen(path, "r");
    if (!f) {
        fprintf(stderr, "script: cannot open '%s'\n", path);
        return -1;
    }
    char line[256];
    int ln = 0;
    q_len = q_pos = 0;
    while (fgets(line, sizeof line, f)) {
        ln++;
        char *p = line;
        while (*p == ' ' || *p == '\t') p++;
        char *nl = strchr(p, '\n');
        if (nl) *nl = 0;
        char *cr = strchr(p, '\r');
        if (cr) *cr = 0;
        if (!*p || *p == '#')
            continue;
        if (q_len >= MAX_EV) {
            fprintf(stderr, "script:%d: too many events (max %d)\n", ln, MAX_EV);
            fclose(f);
            return -1;
        }
        struct ev *e = &q[q_len];
        char tok[200];
        if (sscanf(p, "key %199s", tok) == 1) {
            int c = token_code(tok);
            if (c < 0) {
                fprintf(stderr, "script:%d: unknown key token '%s'\n", ln, tok);
                fclose(f);
                return -1;
            }
            e->kind = EV_KEY; e->value = c;
        } else if (sscanf(p, "wait %d", &e->value) == 1) {
            e->kind = EV_WAIT;
        } else if (sscanf(p, "shot %199s", e->path) == 1) {
            e->kind = EV_SHOT;
        } else if (sscanf(p, "seed %i", &e->value) == 1) {
            e->kind = EV_SEED;
        } else if (!strcmp(p, "quit")) {
            e->kind = EV_QUIT;
        } else {
            fprintf(stderr, "script:%d: bad directive '%s'\n", ln, p);
            fclose(f);
            return -1;
        }
        q_len++;
    }
    fclose(f);
    q_active = 1;
    fprintf(stderr, "script: %d events from '%s'\n", q_len, path);
    return 0;
}

int script_input_active(void) { return q_active && q_pos < q_len; }

/* one poll: returns the key to deliver (0 = no key this poll).
 * side-effect directives (shot/seed) run inline until a key/wait/quit. */
int script_input_poll(int headless)
{
    while (q_active && q_pos < q_len) {
        struct ev *e = &q[q_pos];
        switch (e->kind) {
        case EV_KEY:
            q_pos++;
            return e->value;
        case EV_WAIT:
            if (e->value > 0) { e->value--; return 0; }
            q_pos++;
            continue;
        case EV_SHOT:
            q_pos++;
            if (vid_screenshot_ppm(e->path) == 0)
                fprintf(stderr, "script: shot -> %s\n", e->path);
            else
                fprintf(stderr, "script: shot FAILED -> %s\n", e->path);
            continue;
        case EV_SEED:
            q_pos++;
            g_rand_seed_28EE = (unsigned int)e->value;
            fprintf(stderr, "script: seed = 0x%08X\n", (unsigned)e->value);
            continue;
        case EV_QUIT:
            q_pos++;
            return VID_QUIT_REQUESTED;
        }
    }
    if (q_active && headless)
        return VID_QUIT_REQUESTED;   /* finished script = finished run */
    return 0;
}
