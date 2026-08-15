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
    return 0;
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
                    snprintf(nb, sizeof(nb), "%d", subs->num[k]);
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

void rm_draw_event(const char *key, const rm_subs *subs,
                   const char *speaker) {
    dresolve();
    const dat_events_entry_t *e = event_by_key(key);
    if (!e || !e->body) return;
    const rd_font *f = dfont(e->small);
    int tp = dtext(e->small);
    char lines[16][256];
    int nl = e->n_body < 16 ? e->n_body : 16;
    int cw = e->width;
    for (int i = 0; i < nl; i++) {
        fill_template(e->body[i], subs, lines[i], sizeof(lines[i]));
        int lw = stripped_width(f, lines[i]) + 10;
        if (lw > cw) cw = lw;
    }
    int w = cw + 6, h = 6 + nl * tp + 3;
    int low = speaker_low(speaker);
    /* Math.round(160 - w/2) — NO clamps on the bulletin path (drawEvent
     * has none; a wider-than-screen popup runs off both edges) */
    int x = round_half(320 - w);
    int y = round_half((low ? 260 : 200) - h);
    uint8_t base = 68, hi = 149;                    /* in-game inks */
    draw_speaker(speaker, x, y, w);
    rm_plaque(x, y, w, h);
    for (int i = 0; i < nl; i++)
        span_text(f, lines[i], x + 5, y + 6 + i * tp, base, hi);
}

/* askEvent -> drawDialog (game.js:6383/909): body + option rows, the
 * rows from the event's own tail paragraph; sel = highlighted row. */
void rm_draw_dialog_event(const char *key, const rm_subs *subs,
                          const char *speaker, int sel) {
    dresolve();
    const dat_events_entry_t *e = event_by_key(key);
    if (!e || !e->body) return;
    const rd_font *f = dfont(e->small);
    int tp = dtext(e->small), rp = drow(e->small);
    char body[16][256], rows[16][256];
    int nb = e->n_body < 16 ? e->n_body : 16;
    int nr = e->n_tail < 16 ? e->n_tail : 16;
    int cw = e->width;
    for (int i = 0; i < nb; i++) {
        fill_template(e->body[i], subs, body[i], sizeof(body[i]));
        int lw = stripped_width(f, body[i]) + 10;
        if (lw > cw) cw = lw;
    }
    for (int i = 0; i < nr; i++) {
        fill_template(e->tail[i], subs, rows[i], sizeof(rows[i]));
        int lw = stripped_width(f, rows[i]) + 10;
        if (lw > cw) cw = lw;
    }
    int w = cw + 6;
    int text_h = nb * tp;
    int h = 6 + text_h + 3 + nr * rp + 3;
    int low = speaker_low(speaker);
    int x = round_half(320 - w), y = round_half((low ? 260 : 200) - h);
    if (x + w > 320) x = 320 - w;
    if (y + h > 200) y = 200 - h;
    if (x < 0) x = 0;
    if (y < 0) y = 0;
    uint8_t base = 68, hi = 149;
    draw_speaker(speaker, x, y, w);
    rm_plaque(x, y, w, h);
    for (int i = 0; i < nb; i++)
        span_text(f, body[i], x + 5, y + 6 + i * tp, base, hi);
    int seed = y + 6 + text_h + 3;
    for (int k = 0; k < nr; k++) {
        int oy = seed + k * rp;
        if (k == sel) rd_fill(x + 4, oy, w - 8, rp - 2, SELECT_GAME);
        span_text(f, rows[k], x + 9, oy + 1, base, hi);
    }
}
