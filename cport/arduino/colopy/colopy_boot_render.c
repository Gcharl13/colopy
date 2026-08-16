/* C-port Phase 7 cluster H — the boot screens (§26.1-26.4).
 *
 * Transcribed from the census-verified JS painters:
 *   drawTitle      game.js:1016 — OPENMENU.PIK, the OPENTILE plaque at
 *                  MENU_BOX (77,91,166,58) with the FRAME_BOOT rings
 *                  (0x2E / light 0xFD / dark 0x37), title line with the
 *                  {..} gold span, @BEGINMENU rows at 107+8k with the
 *                  SELECT_BOOT 0x37 bar
 *   drawDifficulty game.js:1043 — DIFFICUL.PIK, cells (i%3*105+23,
 *                  i/3*96+7, 68, 90) with idx = n+1, per-row outline
 *                  inks, the stacked centre pair (y+38/y+46) in the
 *                  row's own ink (live 03_difficulty.png)
 *   drawNation     game.js:1069 — NATIONS.PIK, cells (i%2*99+112,
 *                  i/2*91+13, 88, 82), both lines in the nation's own
 *                  colour (live 04_nation.png)
 *   drawName       game.js:1087 — WOODPANL.PIK, @LEADERNAME prompt in
 *                  FONTINTR at y=88, entry field (79,98,167,14) 0xFE
 *                  (the caret is a Date-driven blink the harness pins
 *                  off) */
#include <ctype.h>
#include <stdio.h>
#include <string.h>

#include "colopy_sim.h"
#include "colopy_data.h"
#include "colopy_text.h"
#include "colopy_render.h"

#define SELECT_BOOT 0x37

static rd_font B_TINY, B_INTR;
static void bresolve(void) {
    if (!B_TINY.payload) rd_font_open(&RD.pak, "FONTTINY.FF", &B_TINY);
    if (!B_INTR.payload) rd_font_open(&RD.pak, "FONTINTR.FF", &B_INTR);
}
static const uint8_t *blut(uint8_t i) {
    static uint8_t l[4];
    l[0] = 0xFF; l[1] = i; l[2] = (uint8_t)(i - 1); l[3] = 0;
    return l;
}
static int bround(int num2) {
    int v = num2 + 1;
    return v >= 0 ? v / 2 : -((-v + 1) / 2);
}
/* Font.center + the black shadow pass (game.js:103: +1,0 / 0,+1 /
 * +1,+1 in the shadow ink, then the ink pass) */
static void center_shadow(const rd_font *f, const char *s, int cx, int y,
                          const uint8_t ink[4], int shadow) {
    int w = rd_text_width(f, s);
    int x = bround(2 * cx - (w - 1));
    if (shadow) {
        const uint8_t sh[4] = { 0xFF, 0, 0, 0 };
        rd_text(f, s, x + 1, y, sh);
        rd_text(f, s, x, y + 1, sh);
        rd_text(f, s, x + 1, y + 1, sh);
    }
    rd_text(f, s, x, y, ink);
}

/* plaque with the FRAME_BOOT rings + OPENTILE interior (game.js:795) */
static void boot_plaque(int x, int y, int w, int h) {
    rm_hollow_rect(x, y, w, h, 0);
    rm_hollow_rect(x + 1, y + 1, w - 2, h - 2, 0x2E);
    rd_fill(x + 2, y + 2, 1, h - 4, 0x37);           /* left, dark */
    rd_fill(x + w - 3, y + 2, 1, h - 4, 0xFD);       /* right, light */
    rd_fill(x + 2, y + 2, w - 4, 1, 0xFD);           /* top, light */
    rd_fill(x + 2, y + h - 3, w - 4, 1, 0x37);       /* bottom, dark */
    rd_entry ot;
    if (!rd_pak_find(&RD.pak, "OPENTILE.SS", &ot)) return;
    rd_frame t;
    if (!rd_sheet_frame(&ot, 0, &t)) return;
    int ix = x + 3, iy = y + 3, iw = w - 6, ih = h - 6;
    for (int yy = iy - 3; yy < iy + ih; yy += t.h)
        for (int xx = ix - 3; xx < ix + iw; xx += t.w)
            for (int r = 0; r < t.h; r++) {
                int dy = yy + r;
                if (dy < 0 || dy < iy || dy >= iy + ih || dy >= RD_H)
                    continue;
                for (int c = 0; c < t.w; c++) {
                    int dx = xx + c;
                    if (dx < 0 || dx < ix || dx >= ix + iw || dx >= RD_W)
                        continue;
                    uint8_t v = t.pix[r * t.w + c];
                    if (v != RD_TRANSPARENT) RD.fb[dy * RD_W + dx] = v;
                }
            }
}

/* fill %STRING0/%STRING1 with the version pair the JS title uses */
static void title_line(char *out, size_t cap) {
    const char *t = dat_text_beginmenu[0];
    size_t o = 0;
    for (const char *p = t; *p && o + 1 < cap;) {
        if (strncmp(p, "%STRING0", 8) == 0) {
            for (const char *c = "1.0"; *c && o + 1 < cap;) out[o++] = *c++;
            p += 8;
        } else if (strncmp(p, "%STRING1", 8) == 0) {
            for (const char *c = "HTML"; *c && o + 1 < cap;) out[o++] = *c++;
            p += 8;
        } else
            out[o++] = *p++;
    }
    out[o] = 0;
}

void rm_draw_title(int menu_row) {
    bresolve();
    rd_use_palette("OPENMENU.PIK");
    rd_pik("OPENMENU.PIK");
    boot_plaque(77, 91, 166, 58);
    char title[128];
    title_line(title, sizeof(title));
    /* the {..} span renders gold 0xFC; base 0xFE (game.js:1022) */
    int tx = 77 + 5;
    const char *p = title;
    while (*p) {
        const char *open = 0, *close = 0;
        for (const char *q = p; *q; q++)
            if (*q == '{') {
                const char *r = q + 1;
                while (*r && *r != '}') r++;
                if (*r == '}') { open = q; close = r; }
                break;
            }
        const char *seg_end = (open == p && close) ? close + 1
                            : (open && open > p) ? open
                            : p + strlen(p);
        int gold = *p == '{';
        char seg[128];
        size_t o = 0;
        for (const char *q = p; q < seg_end && o + 1 < sizeof(seg); q++)
            if (*q != '{' && *q != '}') seg[o++] = *q;
        seg[o] = 0;
        tx = rd_text(&B_TINY, seg, tx, 91 + 6, blut(gold ? 0xFC : 0xFE));
        p = seg_end;
    }
    for (int k = 0; k < 5; k++) {
        const char *opt = dat_text_beginmenu[1 + k];
        int oy = 107 + 8 * k;
        if (k == menu_row) rd_fill(77 + 4, oy - 1, 158, 7, SELECT_BOOT);
        rd_text(&B_TINY, opt, 77 + 9, oy,
                blut(k == menu_row ? 0xFC : 0xFE));
    }
}

static const uint8_t DIFF_OUTLINE[5] = { 0x0A, 0x09, 0x0E, 0x0D, 0x0C };
void rm_draw_difficulty(int diff) {
    bresolve();
    rd_use_palette("DIFFICUL.PIK");
    rd_pik("DIFFICUL.PIK");
    center_shadow(&B_INTR, dat_text_misc[162], 56, 16, blut(254), 1);
    center_shadow(&B_INTR, dat_text_misc[163], 56, 29, blut(254), 1);
    int i = diff + 1;
    int cx = (i % 3) * 105 + 23, cy = (i / 3) * 96 + 7, cw = 68, ch = 90;
    rm_hollow_rect(cx, cy, cw - 1, ch - 1, DIFF_OUTLINE[diff]);
    char up[32];
    size_t n = 0;
    for (const char *c = dat_difficulty[diff]; *c && n + 2 < sizeof(up); c++)
        up[n++] = (char)toupper((unsigned char)*c);
    up[n++] = ':';
    up[n] = 0;
    /* cx + cw/2 = a .0 half here (cw 68), plain int is exact */
    center_shadow(&B_TINY, up, cx + cw / 2, cy + 38,
                  blut(DIFF_OUTLINE[diff]), 1);
    center_shadow(&B_TINY, dat_text_misc[165 + diff], cx + cw / 2, cy + 46,
                  blut(DIFF_OUTLINE[diff]), 1);
    char esc[64];
    snprintf(esc, sizeof(esc), "(%s)", dat_text_misc[161]);
    center_shadow(&B_TINY, esc, 56, 81, blut(254), 0);
}

void rm_draw_nation(int nation) {
    bresolve();
    rd_use_palette("NATIONS.PIK");
    rd_pik("NATIONS.PIK");
    center_shadow(&B_INTR, dat_text_misc[170], 56, 36, blut(254), 1);
    center_shadow(&B_INTR, dat_text_misc[171], 56, 49, blut(254), 1);
    const dat_nations_t *nn = &dat_nations[nation];
    int cx = (nation % 2) * 99 + 112, cy = (nation / 2) * 91 + 13;
    int cw = 88, ch = 82;
    rm_hollow_rect(cx, cy, cw - 1, ch - 1, (uint8_t)nn->color);
    char up[32];
    size_t n = 0;
    for (const char *c = nn->country; *c && n + 2 < sizeof(up); c++)
        up[n++] = (char)toupper((unsigned char)*c);
    up[n++] = ':';
    up[n] = 0;
    center_shadow(&B_TINY, up, cx + cw / 2, cy + 2, blut((uint8_t)nn->color), 1);
    center_shadow(&B_TINY, dat_text_misc[173 + nation], cx + cw / 2,
                  cy + ch - 9, blut((uint8_t)nn->color), 1);
    char esc[64];
    snprintf(esc, sizeof(esc), "(%s)", dat_text_misc[161]);
    center_shadow(&B_TINY, esc, 56, 182, blut(254), 0);
}

void rm_draw_name(const char *leader) {
    bresolve();
    rd_use_palette("WOODPANL.PIK");
    rd_pik("WOODPANL.PIK");
    /* @LEADERNAME first line, carets stripped (game.js:1091) */
    char prompt[128];
    size_t o = 0;
    for (const char *p = dat_text_leadername;
         *p && *p != '\n' && o + 1 < sizeof(prompt); p++)
        if (*p != '^') prompt[o++] = *p;
    prompt[o] = 0;
    center_shadow(&B_INTR, prompt, 160, 88, blut(0xFE), 1);
    rm_hollow_rect(79, 98, 167, 14, 0xFE);
    rd_text(&B_INTR, leader ? leader : "", 84, 101, blut(0xFE));
}

/* ---- the New Game cinematic screens (Phase 9) -----------------------
 * drawBriefing (game.js:1106), drawKing (1248), drawCards (1147) —
 * the briefing pages, the King's audience with the @VICEROY scroll,
 * and the ten LEVN cards that play into beginGame. */

/* the caret markup shared by briefings/cards: '^^' deleted, '^'/'_'
 * become spaces, ends trimmed (briefLines 1102 / cardText 1134) */
static void caret_clean(const char *src, size_t n, char *out, size_t cap) {
    size_t o = 0;
    for (size_t i = 0; i < n && o + 1 < cap; i++) {
        char c = src[i];
        if (c == '^') {
            if (i + 1 < n && src[i + 1] == '^') { i++; continue; }
            c = ' ';
        } else if (c == '_')
            c = ' ';
        out[o++] = c;
    }
    out[o] = 0;
    /* trim */
    while (o && (out[o - 1] == ' ' || out[o - 1] == '\r')) out[--o] = 0;
    size_t s0 = 0;
    while (out[s0] == ' ') s0++;
    if (s0) memmove(out, out + s0, o - s0 + 1);
}

/* a centred FONTTINY line with {..} gold spans (drawBriefing 1113) */
static void center_spans(const char *l, int cx, int y) {
    char plain[192];
    size_t o = 0;
    for (const char *p = l; *p && o + 1 < sizeof(plain); p++)
        if (*p != '{' && *p != '}') plain[o++] = *p;
    plain[o] = 0;
    int w = rd_text_width(&B_TINY, plain);
    int x = bround(2 * cx - w);
    const char *p = l;
    while (*p) {
        /* one part: a {..} span, or the run up to the next '{' */
        const char *q;
        int gold = 0;
        if (*p == '{') {
            q = strchr(p + 1, '}');
            q = q ? q + 1 : p + strlen(p);
            gold = 1;
        } else {
            q = strchr(p, '{');
            if (!q) q = p + strlen(p);
        }
        char seg[192];
        size_t so = 0;
        for (const char *r = p; r < q && so + 1 < sizeof(seg); r++)
            if (*r != '{' && *r != '}') seg[so++] = *r;
        seg[so] = 0;
        x = rd_text(&B_TINY, seg, x, y, blut(gold ? 0xFC : 0xFE));
        p = q;
    }
}

void rm_draw_briefing(int nation, int page) {
    bresolve();
    rd_use_palette("WOODPANL.PIK");
    rd_pik("WOODPANL.PIK");
    char up[32];
    size_t n = 0;
    for (const char *c = dat_nations[nation & 3].country;
         *c && n + 1 < sizeof(up); c++)
        up[n++] = (char)toupper((unsigned char)*c);
    up[n] = 0;
    center_shadow(&B_INTR, up, 160, 18, blut(0xFC), 1);
    /* briefLines (1100): split lines, caret-clean, DROP element 0 */
    const char *raw = dat_briefings[nation & 3][page ? 1 : 0];
    int y = page == 0 ? 38 : 66;
    int li = 0;
    const char *p = raw;
    while (*p) {
        const char *e = strchr(p, '\n');
        size_t len = e ? (size_t)(e - p) : strlen(p);
        char line[192];
        caret_clean(p, len, line, sizeof(line));
        if (li++ > 0) {
            if (!line[0]) y += 5;
            else { center_spans(line, 160, y); y += 9; }
        }
        if (!e) break;
        p = e + 1;
    }
    center_shadow(&B_TINY, page == 0 ? "(more)" : "(click to continue)",
                  160, 188, blut(0xFC), 1);
}

/* cardText (game.js:1132): caret-clean, drop empties, per-card subs */
void rm_draw_cards(int card, int nation, int difficulty,
                   const char *leader) {
    bresolve();
    char key[16];
    int cn = card < 0 ? 1 : card % 10 + 1;
    snprintf(key, sizeof(key), "LEVN%04d.PIK", cn % 10000);
    rd_entry e;
    if (rd_pak_find(&RD.pak, key, &e)) {
        rd_use_palette(key);
        rd_pik(key);
    } else
        rd_fill(0, 0, RD_W, RD_GAME_H, 0);
    const dat_nations_t *nn = &dat_nations[nation & 3];
    const char *raw = dat_cards[card < 0 ? 0 : card % 10];
    int y = 54;
    const char *p = raw;
    while (*p) {
        const char *le = strchr(p, '\n');
        size_t len = le ? (size_t)(le - p) : strlen(p);
        char line[192];
        caret_clean(p, len, line, sizeof(line));
        if (line[0]) {
            /* the per-card %STRING subs (1138-1143) */
            char out[224];
            const char *s0 = 0, *s1 = 0;
            if (card == 1) {
                s0 = dat_text_misc[165 + (difficulty < 5 ? difficulty : 0)];
                s1 = leader;
            } else if (card == 2) s0 = nn->homeport;
            else if (card == 3) { s0 = nn->country; s1 = dat_myleader[nation & 3]; }
            else if (card == 6) s0 = nn->country;
            size_t o = 0;
            for (const char *r = line; *r && o + 1 < sizeof(out);) {
                if (s0 && strncmp(r, "%STRING0", 8) == 0) {
                    for (const char *c = s0; *c && o + 1 < sizeof(out);)
                        out[o++] = *c++;
                    r += 8;
                } else if (s1 && strncmp(r, "%STRING1", 8) == 0) {
                    for (const char *c = s1; *c && o + 1 < sizeof(out);)
                        out[o++] = *c++;
                    r += 8;
                } else
                    out[o++] = *r++;
            }
            out[o] = 0;
            /* renderer func_004B72: pen ink 0x0E, centred (1153) */
            center_shadow(&B_TINY, out, 160, y, blut(0x0E), 1);
            y += 9;
        }
        if (!le) break;
        p = le + 1;
    }
    center_shadow(&B_TINY, "(click to continue)", 160, 190, blut(0x0E), 1);
}

/* sheetAnchored (game.js:1165): the frame's own (hx, hy) descriptor is
 * an (anchor-x = centre-x, anchor-y = bottom-y) pair (ruling
 * 2026-07-31) — KING1 resolves to (0,12), ENGLND1 to (32,0) */
static void sheet_anchored(const char *name) {
    char nm[20];
    snprintf(nm, sizeof(nm), "%s.SS", name);
    rd_entry e;
    rd_frame f;
    if (!rd_pak_find(&RD.pak, nm, &e) || !rd_sheet_frame(&e, 0, &f) || !f.w)
        return;
    rd_blit(&e, 0, f.x - (f.w >> 1), f.y - f.h + 1);
}

static int wrap_next(const rd_font *f, const char *p, int width,
                     char *out, size_t cap) {
    /* wrapText (game.js:1274): greedy space wrap; returns chars taken */
    size_t best = 0, o = 0, i = 0;
    while (p[i] && o + 1 < cap) {
        out[o++] = p[i++];
        out[o] = 0;
        if (p[i] == ' ' || !p[i]) {
            if (rd_text_width(f, out) > width && best) {
                out[best] = 0;
                return (int)best + 1;      /* skip the space */
            }
            best = o;
        }
    }
    out[o] = 0;
    return (int)i;
}

/* the King's audience (drawKing 1248): KINGLSS1 throne room, the
 * nation canopy banner, the KING1 figure, and the GAME.TXT @VICEROY
 * scroll laid out by its own directives @width=78 @x=232 @y=21 in
 * FONTKING ink 36 — '^^' lines centred in the column, body wrapped. */
void rm_draw_king(int nation) {
    static const char *const STEM[4] = { "ENGLND1", "FRANCE1", "SPAIN1",
                                         "DUTCH1" };
    static rd_font KINGF;
    bresolve();
    if (!KINGF.payload) rd_font_open(&RD.pak, "FONTKING.FF", &KINGF);
    rd_use_palette("KINGLSS1.PIK");
    rd_pik("KINGLSS1.PIK");
    sheet_anchored(STEM[nation & 3]);
    sheet_anchored("KING1");
    const char *src = dat_viceroy[(nation & 3) == 3 ? 1 : 0];
    const int X = 232, WIDTH = 78, CX = X + WIDTH / 2;
    int y = 21;
    const char *p = src;
    while (*p) {
        const char *le = strchr(p, '\n');
        size_t len = le ? (size_t)(le - p) : strlen(p);
        char raw[192];
        size_t o = 0;
        /* %COUNTRY substitution (1255) */
        for (size_t i = 0; i < len && o + 1 < sizeof(raw); i++) {
            if (p[i] == '%' && i + 8 <= len &&
                strncmp(p + i, "%COUNTRY", 8) == 0) {
                for (const char *c = dat_nations[nation & 3].country;
                     *c && o + 1 < sizeof(raw);)
                    raw[o++] = *c++;
                i += 7;
            } else
                raw[o++] = p[i];
        }
        raw[o] = 0;
        int m = 0;
        while (raw[m] == '^') m++;
        char text[192];
        snprintf(text, sizeof(text), "%s", raw + m);
        size_t tl = strlen(text);
        while (tl && (text[tl - 1] == ' ' || text[tl - 1] == '\r'))
            text[--tl] = 0;
        size_t t0 = 0;
        while (text[t0] == ' ') t0++;
        if (text[t0]) {
            if (m >= 2) {
                center_shadow(&KINGF, text + t0, CX, y, blut(36), 0);
                y += 8;
            } else {
                const char *w = text + t0;
                while (*w) {
                    char seg[192];
                    int took = wrap_next(&KINGF, w, WIDTH, seg,
                                         sizeof(seg));
                    rd_text(&KINGF, seg, X, y, blut(36));
                    y += 8;
                    w += took;
                }
            }
        } else
            y += 8;
        if (!le) break;
        p = le + 1;
    }
    center_shadow(&B_TINY, "(click to begin)", CX, 186, blut(0xFC), 1);
}
