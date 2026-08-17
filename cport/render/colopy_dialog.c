/* C-port Phase 7 cluster C (part 3) — the dialog/popup framework.
 *
 * Transcribed from the census-verified JS painter with the byte
 * citations carried over:
 *   drawEvent      game.js:6403 — body-only box, no OK/Continue row
 *   drawDialog     game.js:909  — body + option rows / entry field
 *   layoutDialog   game.js:864  — +10 line margin (`add ax,0x0A`
 *                  @0x06CCE3), width floor, screen clamps
 *                  (@0x06D563/@0x06D571), figure popups centre y=130 /
 *                  figureless y=100 (capture-measured, FLAGGED)
 *   dialogInks     game.js:896  — in-game 68/149 (@0x073474 reads the
 *                  NAMES @COLORS row), title 0xFE/0xFC (@0x0734BC)
 *   spanText       game.js:900  — '{...}' spans switch to the hilite
 *                  ink (struct +0x74 ink record, func_06C388)
 *   font pitches   game.js:850  — FONTINTR: text pitch glyph_h+1 = 10
 *                  (`call 0x1266; inc ax` @0x06D012), row pitch
 *                  glyph_h+3 = 12; @SMALLFONT: 6 / 8
 *   speakers       game.js:6322 — capture-anchored: IND right edge,
 *                  KING top-centre, MSS/MYR standing on the box
 *   fillTemplate   game.js:6257 — %COUNTRY + %STRINGn/%NUMBERn; a '$'
 *                  after the placeholder is KEPT (the coin glyph)
 *
 * Event/dialog text comes from the generated dat_events_index /
 * dat_dialogs_index (colopy_text.c — the same GAME.TXT content). */
#include <stdio.h>
#include <string.h>

#include "../core/colopy_sim.h"
#include "../data/colopy_data.h"
#include "../data/colopy_text.h"
#include "colopy_render.h"

#define SELECT_GAME 138

static rd_font D_TINY, D_INTR;
static void dresolve(void) {
    if (!D_TINY.payload) rd_font_open(&RD.pak, "FONTTINY.FF", &D_TINY);
    if (!D_INTR.payload) rd_font_open(&RD.pak, "FONTINTR.FF", &D_INTR);
}
static const rd_font *dfont(int small) { return small ? &D_TINY : &D_INTR; }
static int dtext(int small) { return small ? 6 : 10; }
static int drow(int small) { return small ? 8 : 12; }

static const dat_events_entry_t *event_by_key(const char *key) {
    for (int i = 0; i < DAT_EVENTS_INDEX_COUNT; i++)
        if (strcmp(dat_events_index[i].key, key) == 0)
            return &dat_events_index[i];
    /* GAME.TXT entries with entry/choice directives generate into their
     * own dat_dialogs_index (@LANDFALL, @SAILHOME, @RENAMECOLONY, the
     * @HOWMUCH family, ...).  The two entry types are field-identical,
     * so the framework serves both through one lookup — without this
     * every ask on a dialogs key was INVISIBLE on the board and
     * silently answered 0 (user report 2026-08-17: no landfall). */
    for (int i = 0; i < DAT_DIALOGS_INDEX_COUNT; i++)
        if (strcmp(dat_dialogs_index[i].key, key) == 0)
            return (const dat_events_entry_t *)&dat_dialogs_index[i];
    return 0;
}

/* the option-row count of an event key (its GAME.TXT tail lines) —
 * exported for the live front end's ask picker */
int rm_event_rows(const char *key) {
    const dat_events_entry_t *e = event_by_key(key);
    return e ? (int)e->n_tail : 0;
}

/* an entry dialog's @default (the prefill text — @LANDHO "America"),
 * or "" when the section carries none */
const char *rm_event_default(const char *key) {
    const dat_events_entry_t *e = event_by_key(key);
    return e && e->dflt ? e->dflt : "";
}

/* fillTemplate (game.js:6257) */
static void fill_template(const char *line, const rm_subs *subs,
                          char *out, size_t cap) {
    size_t o = 0;
    for (const char *p = line; *p && o + 1 < cap;) {
        if (*p == '%' && strncmp(p, "%COUNTRY", 8) == 0) {
            const char *c = dat_nations[cs_nation()].country;
            while (*c && o + 1 < cap) out[o++] = *c++;
            p += 8;
            continue;
        }
        int is_s = strncmp(p, "%STRING", 7) == 0 && p[7] >= '0' && p[7] <= '9';
        int is_n = strncmp(p, "%NUMBER", 7) == 0 && p[7] >= '0' && p[7] <= '9';
        if ((is_s || is_n) && subs) {
            int k = p[7] - '0';
            if (k < 4) {
                if (is_s && subs->str[k]) {
                    const char *c = subs->str[k];
                    while (*c && o + 1 < cap) out[o++] = *c++;
                } else if (is_n && subs->num_set[k]) {
                    char nb[16];
                    snprintf(nb, sizeof(nb), "%ld", (long)subs->num[k]);
                    for (const char *c = nb; *c && o + 1 < cap;)
                        out[o++] = *c++;
                }
                /* undefined -> '' (the JS rule) */
            }
            p += 8;
            continue;
        }
        out[o++] = *p++;
    }
    out[o] = 0;
}

/* width of a line with the {braces} stripped (the JS .replace) */
static int stripped_width(const rd_font *f, const char *l) {
    char buf[256];
    size_t o = 0;
    for (const char *p = l; *p && o + 1 < sizeof(buf); p++)
        if (*p != '{' && *p != '}') buf[o++] = *p;
    buf[o] = 0;
    return rd_text_width(f, buf);
}

/* spanText (game.js:900): the split is the REGEX /(\{[^}]*\})/ — only a
 * MATCHED {...} pair opens a segment; a part is hilite iff it BEGINS
 * with '{' (a matched span, or a leading unmatched '{'), and every
 * brace is stripped from the drawn text (the .replace). */
static int span_text(const rd_font *f, const char *line, int x, int y,
                     uint8_t base, uint8_t hi) {
    const char *p = line;
    while (*p) {
        /* find the next MATCHED pair from p */
        const char *open = 0, *close = 0;
        for (const char *q = p; *q; q++)
            if (*q == '{') {
                const char *r = q + 1;
                while (*r && *r != '}') r++;
                if (*r == '}') { open = q; close = r; }
                break;               /* only the FIRST '{' can open a part */
            }
        const char *seg_end = (open == p && close) ? close + 1
                            : (open && open > p) ? open
                            : p + strlen(p);
        int hilite = *p == '{';      /* part BEGINS with '{' -> hilite */
        char seg[256];
        size_t o = 0;
        for (const char *q = p; q < seg_end && o + 1 < sizeof(seg); q++)
            if (*q != '{' && *q != '}') seg[o++] = *q;
        seg[o] = 0;
        uint8_t i0 = hilite ? hi : base;
        const uint8_t l[4] = { 0xFF, i0, (uint8_t)(i0 - 1), 0 };
        x = rd_text(f, seg, x, y, l);
        p = seg_end;
    }
    return x;
}

/* Math.round = floor(v + 0.5): floor division, correct for negatives */
static int round_half(int num2) {       /* round(num2 / 2) */
    int v = num2 + 1;
    return v >= 0 ? v / 2 : -((-v + 1) / 2);
}

/* drawSpeakerSheet (game.js:6322) — capture-anchored family rules.
 * The figure ramps live at palette indices >= 128 (measured across all
 * MSS/MYR/IND/KING sheets vs VICEROY.PAL) and stream into the upper DAC
 * when the portrait shows — the single-DAC model; only the entries the
 * frame's own art uses are overlaid, so the wood chrome (128-138) and
 * the map art keep their colours.  IND3A2 and KING1 also author entries
 * BELOW 128 (16-27/32-41) — those stay un-overlaid, FLAGGED: the
 * engine's own king demand cuts to the full king screen (its own
 * palette), which is a later screen, not this popup path. */
static void draw_speaker(const char *sheet, int bx, int by, int bw) {
    if (!sheet || !sheet[0]) return;
    char nm[20];
    snprintf(nm, sizeof(nm), "%s.SS", sheet);
    rd_entry e;
    if (!rd_pak_find(&RD.pak, nm, &e)) return;
    rd_frame f;
    if (!rd_sheet_frame(&e, 0, &f) || !f.w) return;
    const uint8_t *sp = rd_sheet_pal(&e);
    if (sp) {
        uint8_t used[256] = { 0 };
        for (uint32_t i = 0; i < (uint32_t)f.w * f.h; i++)
            if (f.pix[i] != RD_TRANSPARENT) used[f.pix[i]] = 1;
        for (int i = 128; i < 256; i++)
            if (used[i]) memcpy(RD.pal + i * 3, sp + i * 3, 3);
    }
    if (strncmp(sheet, "IND", 3) == 0)
        rd_blit(&e, 0, RD_W - f.w - 20, RD_GAME_H - f.h - 8);
    else if (strncmp(sheet, "KING", 4) == 0)
        rd_blit(&e, 0, 160 - (f.w >> 1), 6);
    else if (bw > 0) {
        int y = by - f.h + 4;
        rd_blit(&e, 0, bx + (bw >> 1) - (f.w >> 1), y < 0 ? 0 : y);
    } else
        rd_blit(&e, 0, 120 - (f.w >> 1), 8);
}

static int speaker_low(const char *s) {
    return s && (strncmp(s, "MSS", 3) == 0 || strncmp(s, "MYR", 3) == 0);
}

/* drawEvent (game.js:6403): the body-only bulletin popup */
int rm_event_exists(const char *key) { return event_by_key(key) != 0; }

/* the bulletin box geometry, shared by the painter and the touch
 * hit-test so the two can never drift */
static int event_geom(const dat_events_entry_t *e, const rm_subs *subs,
                      const char *speaker, char lines[16][256],
                      int *nl_out, int *x, int *y, int *w, int *h) {
    if (!e || !e->body) return 0;
    const rd_font *f = dfont(e->small);
    int tp = dtext(e->small);
    int nl = e->n_body < 16 ? e->n_body : 16;
    int cw = e->width;
    for (int i = 0; i < nl; i++) {
        fill_template(e->body[i], subs, lines[i], sizeof(lines[i]));
        int lw = stripped_width(f, lines[i]) + 10;
        if (lw > cw) cw = lw;
    }
    *w = cw + 6;
    *h = 6 + nl * tp + 3;
    int low = speaker_low(speaker);
    /* Math.round(160 - w/2) — NO clamps on the bulletin path (drawEvent
     * has none; a wider-than-screen popup runs off both edges) */
    *x = round_half(320 - *w);
    *y = round_half((low ? 260 : 200) - *h);
    *nl_out = nl;
    return 1;
}

void rm_draw_event(const char *key, const rm_subs *subs,
                   const char *speaker) {
    dresolve();
    const dat_events_entry_t *e = event_by_key(key);
    char lines[16][256];
    int nl, x, y, w, h;
    if (!event_geom(e, subs, speaker, lines, &nl, &x, &y, &w, &h)) return;
    const rd_font *f = dfont(e->small);
    int tp = dtext(e->small);
    uint8_t base = 68, hi = 149;                    /* in-game inks */
    draw_speaker(speaker, x, y, w);
    rm_plaque(x, y, w, h);
    for (int i = 0; i < nl; i++)
        span_text(f, lines[i], x + 5, y + 6 + i * tp, base, hi);
}

/* touch front ends: 1 = (mx,my) inside the bulletin plaque drawn by
 * rm_draw_event with the same key/subs/speaker */
int rm_event_hit(const char *key, const rm_subs *subs,
                 const char *speaker, int mx, int my) {
    dresolve();
    const dat_events_entry_t *e = event_by_key(key);
    char lines[16][256];
    int nl, x, y, w, h;
    if (!event_geom(e, subs, speaker, lines, &nl, &x, &y, &w, &h)) return 0;
    return mx >= x && mx < x + w && my >= y && my < y + h;
}

/* askEvent -> drawDialog (game.js:6383/909): body + option rows, the
 * rows from the event's own tail paragraph; sel = highlighted row. */

/* the dialog box geometry, shared by the painter and the touch
 * hit-test so the two can never drift */
static int dialog_geom(const dat_events_entry_t *e, const rm_subs *subs,
                       const char *speaker, char body[16][256],
                       char rows[16][256], int *nb_out, int *nr_out,
                       int *x, int *y, int *w, int *h, int *seed,
                       const char *const *rrows, int nrr) {
    if (!e || !e->body) return 0;
    const rd_font *f = dfont(e->small);
    int tp = dtext(e->small), rp = drow(e->small);
    int nb = e->n_body < 16 ? e->n_body : 16;
    int nr = rrows ? (nrr < 16 ? nrr : 16)
                   : (e->n_tail < 16 ? e->n_tail : 16);
    int cw = e->width;
    for (int i = 0; i < nb; i++) {
        fill_template(e->body[i], subs, body[i], sizeof(body[i]));
        int lw = stripped_width(f, body[i]) + 10;
        if (lw > cw) cw = lw;
    }
    for (int i = 0; i < nr; i++) {
        if (rrows)
            snprintf(rows[i], 256, "%s", rrows[i]);
        else
            fill_template(e->tail[i], subs, rows[i], sizeof(rows[i]));
        int lw = stripped_width(f, rows[i]) + 10;
        if (lw > cw) cw = lw;
    }
    *w = cw + 6;
    int text_h = nb * tp;
    *h = 6 + text_h + 3 + nr * rp + 3;
    int low = speaker_low(speaker);
    *x = round_half(320 - *w);
    *y = round_half((low ? 260 : 200) - *h);
    if (*x + *w > 320) *x = 320 - *w;
    if (*y + *h > 200) *y = 200 - *h;
    if (*x < 0) *x = 0;
    if (*y < 0) *y = 0;
    *seed = *y + 6 + text_h + 3;
    *nb_out = nb;
    *nr_out = nr;
    return 1;
}

void rm_draw_dialog_rows(const char *key, const rm_subs *subs,
                         const char *speaker, int sel,
                         const char *const *rrows, int nrr) {
    dresolve();
    const dat_events_entry_t *e = event_by_key(key);
    char body[16][256], rows[16][256];
    int nb, nr, x, y, w, h, seed;
    if (!dialog_geom(e, subs, speaker, body, rows, &nb, &nr,
                     &x, &y, &w, &h, &seed, rrows, nrr))
        return;
    const rd_font *f = dfont(e->small);
    int tp = dtext(e->small), rp = drow(e->small);
    uint8_t base = 68, hi = 149;
    draw_speaker(speaker, x, y, w);
    rm_plaque(x, y, w, h);
    for (int i = 0; i < nb; i++)
        span_text(f, body[i], x + 5, y + 6 + i * tp, base, hi);
    for (int k = 0; k < nr; k++) {
        int oy = seed + k * rp;
        if (k == sel) rd_fill(x + 4, oy, w - 8, rp - 2, SELECT_GAME);
        span_text(f, rows[k], x + 9, oy + 1, base, hi);
    }
}

void rm_draw_dialog_event(const char *key, const rm_subs *subs,
                          const char *speaker, int sel) {
    rm_draw_dialog_rows(key, subs, speaker, sel, 0, 0);
}

/* ---- the village screen (drawVillage game.js:6746) ------------------
 * The map stays underneath; a dialog-chrome plaque carries the band
 * greeting body + the @ACTIONS rows; the chief figure stands at the
 * bottom-right.  Band: alarm >= 0x80 is War (4), else the tension
 * bands 75/40/20 (villageBand 6710 / missionBand 5308 — the engine's
 * own presence-score banding is FLAGGED unread). */
static const char *const VILLAGE_GREETING[5] = {
    "VILLAGEHAPPY", "VILLAGEMEDIUM", "VILLAGESAVAGE",
    "VILLAGEBAD", "VILLAGEWAR"
};

static int village_band(int vi) {
    int tr = (CS.villages[vi].owner_tribe - 4) & 7;
    if (CR.alarm[vi] >= 0x80) return 4;
    int n = CR.tension[tr];
    return n >= 75 ? 3 : n >= 40 ? 2 : n >= 20 ? 1 : 0;
}

/* body + rows + box geometry, shared by the painter and the tap test */
static int village_geom(char body[16][256], int *nb_out,
                        char rows[12][96], int *nr_out,
                        int *x, int *y, int *w, int *h, int *seed) {
    int vi = CR.cur_village;
    if (vi < 0 || vi >= CS.n_villages) return 0;
    int tr = (CS.villages[vi].owner_tribe - 4) & 7;
    const rd_font *f = dfont(0);
    int tp = dtext(0), rp = drow(0);
    /* villageBody (game.js:6714) */
    const dat_events_entry_t *e = event_by_key(VILLAGE_GREETING[village_band(vi)]);
    rm_subs subs;
    memset(&subs, 0, sizeof(subs));
    int lvl = dat_tribes[tr].level;
    subs.str[0] = dat_levelname[lvl < 5 ? lvl : 4];
    subs.str[1] = dat_tribes[tr].name;
    int nb = 0;
    if (e && e->body)
        for (int i = 0; i < e->n_body && nb < 15; i++)
            fill_template(e->body[i], &subs, body[nb++], sizeof(body[0]));
    if (CS.villages[vi].mission != 0xFF) {
        int mp = CS.villages[vi].mission & 0x0F;
        snprintf(body[nb], sizeof(body[0]),
                 "A {%s} mission stands here%s.",
                 mp < 4 ? dat_nations[mp].adjective : "foreign",
                 (CS.villages[vi].mission & 0x10) ? " (expert)" : "");
        nb++;
    }
    /* villageActions rows (6466) + actionLabel (6485) */
    uint8_t ids[12];
    int nr = village_action_rows(ids);
    for (int k = 0; k < nr; k++) {
        if (ids[k] == 3 && CS.villages[vi].mission != 0xFF) {
            int mp = CS.villages[vi].mission & 0x0F;
            const char *adj = mp < 4 ? dat_nations[mp].adjective : "foreign";
            snprintf(rows[k], sizeof(rows[0]), "%s", dat_actions[3]);
            char *at = strstr(rows[k], "%Fs");
            if (at) {
                /* splice the adjective over the %Fs token, bounded */
                char tail[96];
                snprintf(tail, sizeof(tail), "%.90s", at + 3);
                size_t cap = sizeof(rows[0]) - (size_t)(at - rows[k]);
                snprintf(at, cap, "%.20s%.60s", adj, tail);
            }
        } else
            snprintf(rows[k], sizeof(rows[0]), "%s", dat_actions[ids[k]]);
    }
    /* villageBox (6727): @width=190 floor, centred, y clamped to 10 */
    int cw = 190;
    for (int i = 0; i < nb; i++) {
        int lw = stripped_width(f, body[i]);
        if (lw > cw) cw = lw;
    }
    for (int k = 0; k < nr; k++) {
        int lw = stripped_width(f, rows[k]) + 20;
        if (lw > cw) cw = lw;
    }
    *w = cw + 6;
    int text_h = nb * tp;
    *h = 6 + text_h + 3 + nr * rp + 3;
    *x = round_half(320 - *w);
    int y0 = round_half(200 - *h);
    *y = y0 < 10 ? 10 : y0;
    *seed = *y + 6 + text_h + 3;
    *nb_out = nb;
    *nr_out = nr;
    return 1;
}

void rm_draw_village(int village_row) {
    dresolve();
    char body[16][256], rows[12][96];
    int nb, nr, x, y, w, h, seed;
    if (!village_geom(body, &nb, rows, &nr, &x, &y, &w, &h, &seed)) return;
    const rd_font *f = dfont(0);
    int tp = dtext(0), rp = drow(0);
    int vi = CR.cur_village;
    int tr = (CS.villages[vi].owner_tribe - 4) & 7;
    /* the chief (villageSpeaker 6742): IND<tribe%8>A<min(3,band)> at the
     * bottom-right corner, art palette streamed like every speaker */
    {
        char nm[20];
        int band = village_band(vi);
        snprintf(nm, sizeof(nm), "IND%dA%d.SS", tr % 8,
                 band < 3 ? band : 3);
        rd_entry e2;
        rd_frame fr;
        if (rd_pak_find(&RD.pak, nm, &e2) && rd_sheet_frame(&e2, 0, &fr) &&
            fr.w) {
            const uint8_t *sp = rd_sheet_pal(&e2);
            if (sp) {
                uint8_t used[256] = { 0 };
                for (uint32_t i = 0; i < (uint32_t)fr.w * fr.h; i++)
                    if (fr.pix[i] != RD_TRANSPARENT) used[fr.pix[i]] = 1;
                for (int i = 128; i < 256; i++)
                    if (used[i]) memcpy(RD.pal + i * 3, sp + i * 3, 3);
            }
            rd_blit(&e2, 0, RD_W - fr.w, RD_GAME_H - fr.h);
        }
    }
    rm_plaque(x, y, w, h);
    for (int i = 0; i < nb; i++)
        span_text(f, body[i], x + 5, y + 6 + i * tp, 0xFE, 0xFC);
    for (int k = 0; k < nr; k++) {
        int oy = seed + k * rp;
        if (k == village_row)
            rd_fill(x + 3, oy, w - 6, rp - 2, SELECT_GAME);
        const uint8_t ink[4] = { 0xFF,
                                 (uint8_t)(k == village_row ? 0xFC : 0xFE),
                                 (uint8_t)((k == village_row ? 0xFC : 0xFE)
                                           - 1),
                                 0 };
        rd_text(f, rows[k], x + 9, oy + 1, ink);
    }
}

/* the action row under (mx,my): row index, -2 on the box off-rows,
 * -1 outside (the touch front's leave gesture) */
int rm_village_row_hit(int cur, int mx, int my) {
    (void)cur;
    dresolve();
    char body[16][256], rows[12][96];
    int nb, nr, x, y, w, h, seed;
    if (!village_geom(body, &nb, rows, &nr, &x, &y, &w, &h, &seed))
        return -2;
    if (mx < x || mx >= x + w || my < y || my >= y + h) return -1;
    int rp = drow(0);
    if (my >= seed) {
        int k = (my - seed) / rp;
        if (k >= 0 && k < nr) return k;
    }
    return -2;
}

/* touch front ends: the option row under (mx,my) for the dialog
 * rm_draw_dialog_event draws with the same key/subs/speaker — the row
 * band is the selection-fill band (x+4..x+w-4, rp tall from its seed).
 * Returns the row index, -2 = inside the plaque off the rows,
 * -1 = outside the plaque. */
int rm_dialog_rows_hit(const char *key, const rm_subs *subs,
                       const char *speaker, int mx, int my,
                       const char *const *rrows, int nrr) {
    dresolve();
    const dat_events_entry_t *e = event_by_key(key);
    char body[16][256], rows[16][256];
    int nb, nr, x, y, w, h, seed;
    if (!dialog_geom(e, subs, speaker, body, rows, &nb, &nr,
                     &x, &y, &w, &h, &seed, rrows, nrr))
        return -1;
    if (mx < x || mx >= x + w || my < y || my >= y + h) return -1;
    int rp = drow(e->small);
    if (mx >= x + 4 && mx < x + w - 4 && my >= seed) {
        int k = (my - seed) / rp;
        if (k >= 0 && k < nr) return k;
    }
    return -2;
}

int rm_dialog_row_hit(const char *key, const rm_subs *subs,
                      const char *speaker, int mx, int my) {
    return rm_dialog_rows_hit(key, subs, speaker, mx, my, 0, 0);
}



/* ---- the colony popups (drawColonyPopup, game.js:3955) --------------
 * A WOODTILE plaque titled from LABELS @CTITLE (4 "Select An Item To
 * Build" / 8 "Select a Profession for <who>"), then label rows with a
 * right-aligned NOTE column (build: "(N Hammers) (M Tools)"; jobs:
 * "job - made").  The BUILD picker runs at the SMALL pitches with a
 * bright-gold "(F1 for Help)" footer (census3_build_picker); the jobs
 * popup keeps the framework font.  The row model is the input layer's
 * (build_rows/jobs_rows) — this draws and hit-tests it. */
static int cpop_geom(const char *title, const char *const *labels,
                     const char *const *notes, int n, int small,
                     int *x, int *y, int *w, int *h, int *seed) {
    dresolve();
    const rd_font *f = dfont(small);
    int tp = dtext(small), rp = drow(small);
    int cw = 0x50;
    for (int i = 0; i < n; i++) {
        int lw = rd_text_width(f, labels[i]) +
                 (notes && notes[i] ? rd_text_width(f, notes[i]) : 0) + 20;
        if (lw > cw) cw = lw;
    }
    if (title) {
        int tw = rd_text_width(f, title) + 10;
        if (tw > cw) cw = tw;
    }
    int foot = small ? 10 : 0;
    *w = cw + 6;
    *h = 6 + tp + 3 + n * rp + 3 + foot;
    *x = round_half(320 - *w);
    {
        int yy = round_half(200 - *h);
        *y = yy < 2 ? 2 : yy;
    }
    *seed = *y + 6 + tp + 3;
    return 1;
}

void rm_draw_colony_popup(const char *title, const char *const *labels,
                          const char *const *notes, int n, int row,
                          int small) {
    int x, y, w, h, seed;
    if (n < 0) n = 0;
    if (!cpop_geom(title, labels, notes, n, small, &x, &y, &w, &h, &seed))
        return;
    const rd_font *f = dfont(small);
    int rp = drow(small);
    rm_plaque(x, y, w, h);
    if (title) {
        const uint8_t ink[4] = { 0xFF, 0xFE, 0xFD, 0 };
        rd_text(f, title, x + 5, y + 6, ink);
    }
    for (int k = 0; k < n; k++) {
        int ry = seed + k * rp;
        int sel = k == row;
        if (sel) rd_fill(x + 3, ry, w - 6, rp - 2, SELECT_GAME);
        const uint8_t ink[4] = { 0xFF, (uint8_t)(sel ? 0xFC : 0xFE),
                                 (uint8_t)(sel ? 0xFB : 0xFD), 0 };
        rd_text(f, labels[k], x + 9, ry + 1, ink);
        if (notes && notes[k] && notes[k][0])
            rd_text(f, notes[k],
                    x + w - 8 - rd_text_width(f, notes[k]), ry + 1, ink);
    }
    if (small) {
        const uint8_t ink[4] = { 0xFF, 0xFC, 0xFB, 0 };
        const char *f1 = "(F1 for Help)";
        rd_text(f, f1, x + w - 8 - rd_text_width(f, f1), y + h - 11, ink);
    }
}

/* the tapped row, -1 outside the box (the JS dismisses and falls
 * through), -2 inside the box but off the rows */
int rm_colony_popup_hit(const char *title, const char *const *labels,
                        const char *const *notes, int n, int small,
                        int mx, int my) {
    int x, y, w, h, seed;
    if (n < 0) n = 0;
    if (!cpop_geom(title, labels, notes, n, small, &x, &y, &w, &h, &seed))
        return -1;
    if (mx < x || mx >= x + w || my < y || my >= y + h) return -1;
    int rp = drow(small);
    if (mx >= x + 3 && mx < x + w - 3 && my >= seed) {
        int k = (my - seed) / rp;
        if (k >= 0 && k < n) return k;
    }
    return -2;
}

/* ---- the trade-route screen (drawTrade, game.js:7896) ---------------
 * Over the map: a WOODTILE plaque with the mode's GAME.TXT head
 * (@TRADESTART with NUMBER0 = the next stop number / @TRADEDELETE /
 * @TRADESELECT), the create mode's running "So far" line, and the
 * caller's runtime rows at the tiny 8px pitch. */
static int trade_geom(int mode, int step_no, const char *sofar,
                      const char *const *rows, int n,
                      char head[2][256], int *nh_out,
                      int *x, int *y, int *w, int *h, int *seed) {
    dresolve();
    const dat_events_entry_t *e =
        event_by_key(mode == 1 ? "TRADESTART"
                   : mode == 3 ? "TRADEDELETE" : "TRADESELECT");
    if (!e || !e->n_body) return 0;
    rm_subs subs;
    memset(&subs, 0, sizeof(subs));
    subs.num[0] = step_no;
    subs.num_set[0] = 1;
    int nh = 0;
    fill_template(e->body[0], &subs, head[nh++], 256);
    if (mode == 1 && sofar && sofar[0])
        snprintf(head[nh++], 256, "%s", sofar);
    int cw = 190;
    for (int i = 0; i < nh; i++) {
        int lw = stripped_width(&D_TINY, head[i]);
        if (lw > cw) cw = lw;
    }
    for (int i = 0; i < n; i++) {
        int lw = rd_text_width(&D_TINY, rows[i]) + 20;
        if (lw > cw) cw = lw;
    }
    *w = cw + 6;
    int text_h = nh * 6;
    *h = 6 + text_h + 3 + n * 8 + 3;
    *x = round_half(320 - *w);
    /* y = max(10, round(100 - h/2)) (game.js:7911) */
    {
        int yy = round_half(200 - *h);
        *y = yy < 10 ? 10 : yy;
    }
    *seed = *y + 6 + text_h + 3;
    *nh_out = nh;
    return 1;
}

void rm_draw_trade(int mode, int step_no, const char *sofar,
                   const char *const *rows, int n, int sel) {
    char head[2][256];
    int nh, x, y, w, h, seed;
    if (!trade_geom(mode, step_no, sofar, rows, n, head, &nh,
                    &x, &y, &w, &h, &seed))
        return;
    rm_plaque(x, y, w, h);
    for (int i = 0; i < nh; i++)
        span_text(&D_TINY, head[i], x + 5, y + 6 + i * 6, 0xFE, 0xFC);
    for (int k = 0; k < n; k++) {
        int ry = seed + k * 8;
        if (k == sel) rd_fill(x + 3, ry, w - 6, 8, SELECT_GAME);
        const uint8_t ink[4] = { 0xFF, (uint8_t)(k == sel ? 0xFC : 0xFE),
                                 0, 0 };
        rd_text(&D_TINY, rows[k], x + 9, ry + 1, ink);
    }
}

int rm_trade_row_hit(int mode, int step_no, const char *sofar,
                     const char *const *rows, int n, int mx, int my) {
    char head[2][256];
    int nh, x, y, w, h, seed;
    if (!trade_geom(mode, step_no, sofar, rows, n, head, &nh,
                    &x, &y, &w, &h, &seed))
        return -1;
    if (mx < x || mx >= x + w || my < y || my >= y + h) return -1;
    if (mx >= x + 3 && mx < x + w - 3 && my >= seed) {
        int k = (my - seed) / 8;
        if (k >= 0 && k < n) return k;
    }
    return -2;
}

/* ---- the options dialogs (drawOptions game.js:7969) -----------------
 * @GAMEOPTIONS/@COLONYOPTIONS/@SOUNDOPTIONS: body[0] is the title, the
 * rest are rows, each wearing a ROUND radio mark (ring; orange 0x0E
 * centre dot when on — census-corrected 2026-08-08).  Game bits
 * [0x8000,0x4000,0x1000,0x0800,0x0400,0x0200,0x0100,0x0080]; colony
 * bits 1<<(row+1); water cycling (0x0100) and every colony row are
 * INVERTED (a set bit reads unchecked). */
static const char *const OPT_KEYS[3] = {
    "GAMEOPTIONS", "COLONYOPTIONS", "SOUNDOPTIONS"
};
static const uint16_t GAME_OPT_BITS[8] = {
    0x8000, 0x4000, 0x1000, 0x0800, 0x0400, 0x0200, 0x0100, 0x0080
};

static uint16_t *opt_word(int which) {
    return which == 1 ? &CR.colony_options
         : which == 2 ? &CR.sound_options : &CR.game_options;
}

static uint16_t opt_bit(int which, int row) {
    if (which == 0) return row < 8 ? GAME_OPT_BITS[row] : 0;
    return (uint16_t)(1u << (row + 1));
}

static int opt_checked(int which, int row) {
    uint16_t bit = opt_bit(which, row);
    int on = (*opt_word(which) & bit) != 0;
    int inverted = which == 1 || (which == 0 && bit == 0x0100);
    return inverted ? !on : on;
}

int rm_options_rows(int which) {
    const dat_events_entry_t *e = event_by_key(OPT_KEYS[which & 3]);
    return e && e->n_body > 1 ? e->n_body - 1 : 0;
}

void rm_options_toggle(int which, int row) {   /* optionsCommit (7963) */
    *opt_word(which) ^= opt_bit(which, row);
}

static int options_geom(int which, int *x, int *y, int *w, int *h,
                        int *seed, const dat_events_entry_t **eo) {
    const dat_events_entry_t *e = event_by_key(OPT_KEYS[which & 3]);
    if (!e || e->n_body < 2) return 0;
    const rd_font *f = dfont(0);
    int tp = dtext(0), rp = drow(0);
    int nr = e->n_body - 1;
    int cw = 190;
    for (int k = 0; k < nr; k++) {
        int lw = stripped_width(f, e->body[1 + k]) + 28;
        if (lw > cw) cw = lw;
    }
    *w = cw + 6;
    *h = 6 + tp + 3 + nr * rp + 3;
    *x = round_half(320 - *w);
    int y0 = round_half(200 - *h);
    *y = y0 < 10 ? 10 : y0;
    *seed = *y + 6 + tp + 3;
    *eo = e;
    return 1;
}

void rm_draw_options(int which, int row) {
    dresolve();
    const dat_events_entry_t *e;
    int x, y, w, h, seed;
    if (!options_geom(which, &x, &y, &w, &h, &seed, &e)) return;
    const rd_font *f = dfont(0);
    int rp = drow(0);
    rm_plaque(x, y, w, h);
    {
        const uint8_t tk[4] = { 0xFF, 0xFC, 0xFB, 0 };
        rd_text(f, e->body[0], x + 5, y + 6, tk);
    }
    int nr = e->n_body - 1;
    for (int k = 0; k < nr; k++) {
        int ry = seed + k * rp;
        int is = k == row;
        if (is) rd_fill(x + 3, ry, w - 6, rp - 2, SELECT_GAME);
        /* the radio ring + the on-dot */
        int mx2 = x + 10, my2 = ry + 4;
        rd_fill(mx2 - 2, my2 - 3, 4, 1, 0xFE);
        rd_fill(mx2 - 2, my2 + 2, 4, 1, 0xFE);
        rd_fill(mx2 - 3, my2 - 2, 1, 4, 0xFE);
        rd_fill(mx2 + 2, my2 - 2, 1, 4, 0xFE);
        if (opt_checked(which, k)) rd_fill(mx2 - 1, my2 - 1, 2, 2, 0x0E);
        span_text(f, e->body[1 + k], x + 18, ry + 1,
                  (uint8_t)(is ? 0xFC : 0xFE), 0x0E);
    }
}

int rm_options_row_hit(int which, int mx, int my) {
    dresolve();
    const dat_events_entry_t *e;
    int x, y, w, h, seed;
    if (!options_geom(which, &x, &y, &w, &h, &seed, &e)) return -1;
    if (mx < x || mx >= x + w || my < y || my >= y + h) return -1;
    int rp = drow(0);
    if (my >= seed) {
        int k = (my - seed) / rp;
        if (k >= 0 && k < e->n_body - 1) return k;
    }
    return -2;
}
