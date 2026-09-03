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
#include <strings.h>

#include "../core/colopy_sim.h"
#include "../data/colopy_data.h"
#include "../data/colopy_text.h"
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
            /* func_004B72's switch on n-2 (@0x004C0D) registers slots
             * for cards 2/3/4 only (%STRING0/1 via 0x181f:0x438/0x416
             * @0x004C1C..0x004C96); card 7's "%STRING0" has NO
             * registration — slot 0 still holds card 4's nation name
             * (nothing clears it between cards), so the nation name is
             * the byte-true result by slot persistence. */
            if (card == 1) {
                s0 = dat_text_misc[165 + (difficulty < 5 ? difficulty : 0)];
                s1 = leader;
            } else if (card == 2) s0 = nn->homeport;
            else if (card == 3) { s0 = nn->country; s1 = dat_myleader[nation & 3]; }
            else if (card == 6) s0 = nn->country;   /* slot persistence */
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
            /* renderer func_004B72: the text goes through the popup
             * engine (`lcall 0x181f,0x3fe` @0x004CE5 on @BUILDn, own
             * directives @width=310 @y=30) with the popup INK SLOTS
             * [0x1F4A]=0x0E / [0x1F50]=0x36 (@0x004CD6/@0x004CDC —
             * palette indices under the LEVN palette, NOT a pen; the
             * old "pen (14,54)" reading is corrected, RULINGS
             * 2026-09-02f).  y=54 / pitch 9 / the shadow flag are the
             * port's MEASURED stand-ins for that layout, kept until a
             * DOS capture of a card exists to diff against (TBD). */
            center_shadow(&B_TINY, out, 160, y, blut(0x0E), 1);
            y += 9;
        }
        if (!le) break;
        p = le + 1;
    }
    /* no caption: the engine draws none — the cards advance on the
     * sequencer's timer (func_004D1E), see in_tick */
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

/* the King's audience (drawKing; painter func_075352 @0x075352 called
 * by func_075594 with variant 1/1 and key "VICEROY"/"VICEROY2" for the
 * Dutch @0x0755A7): KINGLSS1.PIK (@0x07536E) + the nation banner sheet
 * ENGLND1/FRANCE1/SPAIN1/DUTCH1 (@0x0753B8 switch on [0x5398]) + KING1
 * (@0x07543C; the boot variant also queues tune 0x3E @0x07544B), then
 * FONTKING (@0x0754F2) and the @VICEROY scroll through the popup engine
 * (@0x075540) from the section's own directives @width=78 @x=232 @y=21
 * — '^^' lines centred in the column, body wrapped. */
/* the @-text runner of the king pages (0x181F:0x3FE with the key,
 * func_075352 @0x75540, FONTKING @0x754F6): one 8px line per source
 * line laid out by the key's directives -- blank `^` lines consume a
 * slot, `^^` lines are centred in the column, body lines left-aligned
 * at X and wrapped at WIDTH (the JS drawKingText).  %COUNTRY is filled
 * (1255); the ink 36 is the audience page's measured stand-in. */
static rd_font KINGF;
static void king_text(const char *src, int nation, int X, int WIDTH,
                      int y) {
    const int CX = X + WIDTH / 2;
    const char *p = src;
    while (*p) {
        const char *le = strchr(p, '\n');
        size_t len = le ? (size_t)(le - p) : strlen(p);
        char raw[192];
        size_t o = 0;
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
}
/* func_075352(N, sub, key) @0x075352: KINGLSS<N>.PIK (@0x7536E..0x753A9)
 * with the <NATION><N> banner (@0x753BB..0x7542B) and one king sheet
 * composited INTO the PIK buffer (@0x75477..0x7549D), the PIK's palette
 * to the DAC (@0x754AD), buffer -> screen (@0x754DB), then the key's
 * text in FONTKING.  Sheet select @0x75430..0x75461: (1,1) -> KING1 (the
 * audience), (1,other) -> KINGLOSE, (2,*) -> KINGWIN.  Every sheet lands
 * at its own descriptor anchor. */
static void king_page(const char *pik, const char *banner,
                      const char *king) {
    bresolve();
    if (!KINGF.payload) rd_font_open(&RD.pak, "FONTKING.FF", &KINGF);
    rd_use_palette(pik);
    rd_fill(0, 0, RD_W, RD_GAME_H, 0);
    rd_pik(pik);
    sheet_anchored(banner);
    sheet_anchored(king);
}
void rm_draw_king(int nation) {
    static const char *const STEM[4] = { "ENGLND1", "FRANCE1", "SPAIN1",
                                         "DUTCH1" };
    king_page("KINGLSS1.PIK", STEM[nation & 3], "KING1");
    king_text(dat_viceroy[(nation & 3) == 3 ? 1 : 0], nation, 232, 78, 21);
    /* no caption: neither func_075352 (read whole, 0x075352..0x075593)
     * nor the DOS capture docs/screens/07_king_audience.png carries one;
     * the wait is the popup engine's modal wait on the scroll
     * (@0x075540).  The scroll's own inks are the popup slots
     * [0x1F4A]=0xF2 / [0x1F50]=0x2F / [0x1F52]=0 (@0x075526..0x075532,
     * under KINGLSS1's palette); the single ink 36 in king_text is the
     * pixel-measured stand-in (RULINGS 2026-07-31 batch 3) until the
     * 2bpp glyph level -> slot mapping is read (TBD). */
}
/* the war's end (func_02F3A2): win = @WINNING then func_075352(1, 2,
 * "KINGLOSE") @0x2F542..0x2F55F -> KINGLSS1 + <NATION>1 + KINGLOSE.SS
 * with @KINGLOSE laid out by its directives @width=68 @x=232 @y=31
 * (GAME.TXT 3328-3331); lose = @LOSING<n> then func_075352(2, 1,
 * "KINGWIN") @0x2F670..0x2F6B0 -> KINGLSS2 + <NATION>2 + KINGWIN.SS with
 * @KINGWIN (@width=90 @x=202 @y=125, %STRING0 = the country, GAME.TXT
 * 3338-3341).  The pen seeds @0x75526/@0x7552C are register seeds the
 * runner re-lays-out (RULINGS 2026-07-31).  KING2/WIN/WIN-FWRK have no
 * loader -- never drawn. */
void rm_draw_king_plate(int win) {
    static const char *const STEM1[4] = { "ENGLND1", "FRANCE1", "SPAIN1",
                                          "DUTCH1" };
    static const char *const STEM2[4] = { "ENGLND2", "FRANCE2", "SPAIN2",
                                          "DUTCH2" };
    int nation = cs_nation() & 3;
    king_page(win ? "KINGLSS1.PIK" : "KINGLSS2.PIK",
              (win ? STEM1 : STEM2)[nation], win ? "KINGLOSE" : "KINGWIN");
    int nb = 0;
    const char *const *body = rm_event_body(win ? "KINGLOSE" : "KINGWIN",
                                            &nb);
    rm_subs subs;
    memset(&subs, 0, sizeof(subs));
    subs.str[0] = dat_nations[nation].country;
    char src[1024];
    size_t o = 0;
    for (int i = 0; i < nb && o + 2 < sizeof(src); i++) {
        char line[256];
        rm_fill_template(body[i], &subs, line, sizeof(line));
        if (i) src[o++] = '\n';
        for (const char *c = line; *c && o + 2 < sizeof(src);) src[o++] = *c++;
    }
    src[o] = 0;
    if (win) king_text(src, nation, 232, 68, 31);
    else king_text(src, nation, 202, 90, 125);
}

/* ---- the MicroProse boot logo, OPENING.EXE _do_logo @0x1700 / pacer
 * @0x1916 (VICEROY.EXE never references the sheets).  The pacer steps
 * once per [0x50] = 6 ticks of the 60.8766 Hz clock [0x5CB6] (ISR /2 /5
 * of 608.766 Hz @0x3E0D/@0x3E5D..0x3EA9; timer_install @0x3FC5..0x3FD9):
 * tick [0xD2]++ then _do_logo, which places a frame at top-left
 * (xa - (w>>1), ya - h + 0x17) from its own descriptor (@0x170D..0x1742
 * / @0x1796..0x17AE) -- the logo, all 16 frames (163,118) 155x119, at
 * (86,22) -- draws the NAME frame [0xD6] first (@0x1836) and the logo
 * frame [0xD4] over it (@0x1850), then [0xD4]++ wrapping to 1 past
 * nframes (@0x18F2..0x1903) and, in the name phase (tick >= 0x5C = 92
 * @0x175C), [0xD6]++ (@0x190F) clamped at nframes = 29 (@0x176F..
 * 0x177C).  Both counters start at 1 (DGROUP 0xD4/0xD6), so tick t shows
 * logo disk frame (t-1) mod 16 and, for t >= 92, name disk frame
 * min(t-92, 28).  The phase ends past tick 0xE4 = 228 (@0x196E..0x1976).
 * TBD: the DAC reload from [0x4AE8] at tick 0xC4 = 196 (@0x194B..0x196B)
 * -- the sheets' own palette is kept; the backdrop under the frames --
 * black here.  Any key ends the phase (func_001522, cinematics.md §9). */
static void logo_frame_at(const char *sheet, int idx) {
    rd_entry e;
    rd_frame f;
    if (!rd_pak_find(&RD.pak, sheet, &e) || !rd_sheet_frame(&e, idx, &f))
        return;
    rd_blit(&e, idx, f.x - (f.w >> 1), f.y - f.h + 0x17);
}
void rm_draw_mpslogo(int tick) {
    rd_use_palette("MPSLOGO.SS");
    rd_fill(0, 0, RD_W, RD_GAME_H, 0);
    if (tick < 1) return;
    rd_entry e;
    if (tick >= 92 && rd_pak_find(&RD.pak, "MPSNAME.SS", &e) && e.frames) {
        int k = tick - 92;
        if (k > e.frames - 1) k = e.frames - 1;
        logo_frame_at("MPSNAME.SS", k);
    }
    if (rd_pak_find(&RD.pak, "MPSLOGO.SS", &e) && e.frames)
        logo_frame_at("MPSLOGO.SS", (tick - 1) % e.frames);
}

/* the Hall of Fame table (drawHof game.js:12358) — REBUILT from the
 * Phase-4 live capture (hof_01_table.png): three text lines per
 * record, title glyph-top y=3, record k at y=20+36k (+0/+11/+22),
 * rank at x=10, text at x=25, line 3 centred, single green ink 68.
 * Records come from CR.hof (HALLFAME.DAT semantics; the shell
 * persists the list). */
void rm_draw_hof(void) {
    bresolve();
    rd_use_palette("WOODPANL.PIK");
    rd_pik("WOODPANL.PIK");
    const uint8_t *ink = blut(68);
    center_shadow(&B_INTR, dat_text_misc[192], 160, 3, ink, 0);
    int n = CR.n_hof < 5 ? CR.n_hof : 5;
    for (int k = 0; k < n; k++) {
        const colopy_hof_rec *r = &CR.hof[k];
        int y = 20 + 36 * k;
        const char *adj = dat_nations[r->nation & 3].adjective;
        char buf[160];
        snprintf(buf, sizeof(buf), "%d.", k + 1);
        rd_text(&B_INTR, buf, 10, y, ink);
        snprintf(buf, sizeof(buf), "%s %s of the %s%s%s",
                 dat_difficulty[r->difficulty < 5 ? r->difficulty : 0],
                 r->name, r->declared ? dat_text_misc[191] : "",
                 r->declared ? " " : "", adj);
        rd_text(&B_INTR, buf, 25, y, ink);
        char career[96];
        if (r->independent)
            snprintf(career, sizeof(career), "%s, %s", dat_text_misc[195],
                     dat_independent[r->nation & 3]);
        else if (r->declared)
            snprintf(career, sizeof(career), "%s", dat_text_misc[196]);
        else
            snprintf(career, sizeof(career), "%s, %s Colonies",
                     dat_text_misc[197], adj);
        snprintf(buf, sizeof(buf), "%s %s %s %u.  %s: %ld", career,
                 dat_text_misc[193], dat_text_misc[194], r->year,
                 dat_text_misc[198], (long)r->score);
        rd_text(&B_INTR, buf, 25, y + 11, ink);
        char rating[64];
        size_t o = 0;
        for (const char *c = dat_text_misc[199];
             *c && o + 1 < sizeof(rating); c++)
            rating[o++] = *c == '_' ? ' ' : *c;
        rating[o] = 0;
        snprintf(buf, sizeof(buf), "--- %s: %ld%% ---", rating,
                 (long)r->rating);
        center_shadow(&B_INTR, buf, 160, y + 22, ink, 0);
    }
}

/* ---- the Colonizopedia (drawPedia game.js:10671) --------------------
 * Index: column-major, 22 rows x up to 3 columns, pitch 7, first row
 * y=26, columns at x=7+104c; masthead @MISC[108] WHITE (WOODPANL 15);
 * (More)/(Exit) @MISC[109]/[110].  Entry page: name + category line,
 * the PEDIA.TXT article wrapped at 300 with {..} gold spans, then the
 * NAMES stat block in ink 0x0E.  Terrain ids are NOT contiguous
 * (@UNFORESTED 0..7, @FORESTED 8..15, @OTHER 24..28); category lists
 * sort alphabetically (localeCompare — mirrored case-insensitive). */
#define PEDIA_PER_COL 22
#define PEDIA_COLS 3

typedef struct { const char *name; char buf[40]; int cat, idx; } pedia_row;

static const char *const PEDIA_KEYS[7] = {
    "CARGO", "UNIT", "TERRAIN", "JOB", "BUILDING", "FATHER", 0
};

static int pedia_misc_count(void) {
    for (int i = 0; i < 165; i++)
        if (strcmp(dat_pedia_entries_keys[i], "MISCELLANEOUS") == 0) {
            int n = 0;
            const char *p = dat_pedia_entries_vals[i];
            while (*p >= '0' && *p <= '9') n = n * 10 + *p++ - '0';
            return n;
        }
    return 0;
}

static const char *pedia_misc_name(int idx, char *buf, size_t cap) {
    for (int i = 0; i < 165; i++)
        if (strcmp(dat_pedia_entries_keys[i], "MISCELLANEOUS") == 0) {
            const char *p = strchr(dat_pedia_entries_vals[i], '\n');
            for (int k = 0; p && k < idx; k++) p = strchr(p + 1, '\n');
            if (!p) return "";
            p++;
            const char *e = strchr(p, '\n');
            size_t n = e ? (size_t)(e - p) : strlen(p);
            while (n && (*p == ' ')) { p++; n--; }
            while (n && p[n - 1] == ' ') n--;
            if (n >= cap) n = cap - 1;
            memcpy(buf, p, n);
            buf[n] = 0;
            return buf;
        }
    return "";
}

/* one category's rows, unsorted counts (pediaNames 10611) */
static int pedia_cat_count(int cat) {
    switch (cat) {
    case 0: return DAT_CARGO_COUNT;
    case 1: return DAT_UNITS_COUNT;
    case 2: return 21;
    case 3: return 28;
    case 4: return DAT_BUILDINGS_COUNT;
    case 5: return DAT_FATHERS_COUNT;
    case 6: return pedia_misc_count();
    default: return 0;
    }
}

static void pedia_cat_row(int cat, int i, pedia_row *r) {
    r->cat = cat;
    r->idx = i;
    r->name = "";
    switch (cat) {
    case 0: r->name = dat_cargo[i].name; break;
    case 1: r->name = dat_units[i].name; break;
    case 2:
        if (i < 8) { r->name = dat_terrain_unforested[i]; r->idx = i; }
        else if (i < 16) {
            snprintf(r->buf, sizeof(r->buf), "%s %s",
                     dat_terrain_forested[i - 8], dat_terrain_othernames[0]);
            r->name = r->buf;
            r->idx = i;                      /* engine ids 8..15 */
        } else {
            r->name = dat_terrain_other[i - 16];
            r->idx = 24 + (i - 16);          /* @OTHER ids 24..28 */
        }
        break;
    case 3: r->name = dat_jobs[i]; break;
    case 4: r->name = dat_buildings[i].name; break;
    case 5: r->name = dat_fathers[i].name; break;
    case 6: r->name = pedia_misc_name(i, r->buf, sizeof(r->buf)); break;
    }
}

/* the browse list: one category alphabetised, or 7 = Complete (every
 * category merged, alphabetised) — max 165ish rows */
#define PEDIA_MAX 200
/* ONE scratch list for every pedia entry point (2026-09-03): each of
 * rm_pedia_row_of / rm_pedia_count / rm_draw_pedia used to hold its own
 * `static pedia_row rows[PEDIA_MAX]` -- 11,200 B apiece, 33,600 B of
 * internal SRAM on the P4, which pushed the sketch's globals past the
 * 320 KB DRAM limit.  None of the three nests inside another (the two
 * helpers are called only from the input layer, and rm_draw_pedia calls
 * only pedia_build), so the buffer is pure scratch and can be shared. */
static pedia_row g_pedia_rows[PEDIA_MAX];
static int pedia_build(int cat, pedia_row *rows) {
    int n = 0;
    if (cat == 7) {
        for (int c = 0; c < 7; c++)
            for (int i = 0; i < pedia_cat_count(c) && n < PEDIA_MAX; i++)
                pedia_cat_row(c, i, &rows[n++]);
    } else {
        for (int i = 0; i < pedia_cat_count(cat) && n < PEDIA_MAX; i++)
            pedia_cat_row(cat, i, &rows[n++]);
    }
    /* insertion sort, case-insensitive (localeCompare mirror; ties by
     * strcmp — FLAGGED approximation) */
    for (int i = 1; i < n; i++) {
        pedia_row t = rows[i];
        int j = i - 1;
        while (j >= 0) {
            int c = strcasecmp(rows[j].name, t.name);
            if (c < 0 || (c == 0 && strcmp(rows[j].name, t.name) <= 0)) break;
            rows[j + 1] = rows[j];
            j--;
        }
        /* re-anchor buf-backed names after the moves */
        rows[j + 1] = t;
    }
    for (int i = 0; i < n; i++)
        if (rows[i].name != rows[i].buf && rows[i].buf[0] &&
            strcmp(rows[i].name, rows[i].buf) == 0)
            rows[i].name = rows[i].buf;
    return n;
}

int rm_pedia_row_of(int cat, int idx) {
    pedia_row *rows = g_pedia_rows;
    int n = pedia_build(cat, rows);
    for (int i = 0; i < n; i++)
        if (rows[i].cat == cat && rows[i].idx == idx) return i;
    return -1;
}
int rm_pedia_count(int cat) {
    pedia_row *rows = g_pedia_rows;
    return pedia_build(cat, rows);
}

static const char *pedia_body(int cat, int idx) {
    if (cat < 0 || cat > 6 || !PEDIA_KEYS[cat]) return 0;
    char key[24];
    snprintf(key, sizeof(key), "%s%d", PEDIA_KEYS[cat], idx);
    for (int i = 0; i < 165; i++)
        if (strcmp(dat_pedia_entries_keys[i], key) == 0)
            return dat_pedia_entries_vals[i];
    return 0;
}

/* left-aligned {..} gold spans (spanText) */
static int left_spans(const char *l, int x, int y) {
    const char *p = l;
    while (*p) {
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
        char seg[256];
        size_t o = 0;
        for (const char *r = p; r < q && o + 1 < sizeof(seg); r++)
            if (*r != '{' && *r != '}') seg[o++] = *r;
        seg[o] = 0;
        x = rd_text(&B_TINY, seg, x, y, blut(gold ? 0xFC : 0xFE));
        p = q;
    }
    return x;
}

static int pedia_wrap(const char *s, int width, int start, char *out,
                      size_t cap) {
    size_t best = 0, o = 0;
    size_t i = (size_t)start;
    while (s[i] && o + 1 < cap) {
        out[o++] = s[i++];
        out[o] = 0;
        if (s[i] == ' ' || !s[i]) {
            char plain[256];
            size_t po = 0;
            for (const char *r = out; *r && po + 1 < sizeof(plain); r++)
                if (*r != '{' && *r != '}') plain[po++] = *r;
            plain[po] = 0;
            if (rd_text_width(&B_TINY, plain) > width && best) {
                out[best] = 0;
                return start + (int)best + 1;
            }
            best = o;
        }
    }
    out[o] = 0;
    return start + (int)i - start;
}

void rm_draw_pedia(int cat, int sel, int mode) {
    bresolve();
    rd_use_palette("WOODPANL.PIK");
    rd_pik("WOODPANL.PIK");
    pedia_row *rows = g_pedia_rows;
    int n = pedia_build(cat, rows);
    center_shadow(&B_TINY, dat_text_misc[108], 160, 5, blut(15), 0);
    if (sel < 0) sel = 0;
    if (sel >= n) sel = n ? n - 1 : 0;
    if (mode == 0) {                         /* the index */
        int per = PEDIA_PER_COL * PEDIA_COLS;
        int page = (sel / per) * per;
        for (int k = 0; k < per && page + k < n; k++) {
            int x = 7 + (k / PEDIA_PER_COL) * 104;
            int y = 26 + (k % PEDIA_PER_COL) * 7;
            int is = page + k == sel;
            if (is) rd_fill(x - 2, y - 1, 102, 7, 138);
            rd_text(&B_TINY, rows[page + k].name, x, y,
                    blut(is ? 0xFC : 0xFE));
        }
        if (page + per < n)
            rd_text(&B_TINY, dat_text_misc[109], 246, 5, blut(68));
        rd_text(&B_TINY, dat_text_misc[110], 295, 5, blut(68));
        return;
    }
    const pedia_row *e = &rows[sel];
    char head[96];
    snprintf(head, sizeof(head), "%s   %s", e->name,
             dat_pedia_categories[e->cat < 7 ? e->cat : 6]);
    center_shadow(&B_TINY, head, 160, 12, blut(0xFC), 0);
    int y = 12 + 5 + 0xE;
    const char *body = pedia_body(e->cat, e->idx);
    if (body) {
        const char *p = body;
        while (*p && y < 178) {
            const char *le = strchr(p, '\n');
            size_t len = le ? (size_t)(le - p) : strlen(p);
            char para[512];
            if (len >= sizeof(para)) len = sizeof(para) - 1;
            memcpy(para, p, len);
            para[len] = 0;
            /* trim */
            size_t pl = strlen(para);
            while (pl && para[pl - 1] == ' ') para[--pl] = 0;
            const char *t0 = para;
            while (*t0 == ' ') t0++;
            if (!*t0)
                y += 4;
            else {
                int at = 0;
                while (t0[at] && y < 178) {
                    char line[256];
                    at = pedia_wrap(t0, 300, at, line, sizeof(line));
                    left_spans(line, 10, y);
                    y += 6;
                }
            }
            if (!le) break;
            p = le + 1;
        }
    } else {
        rd_text(&B_TINY, "(no article in PEDIA.TXT for this entry)",
                10, y, blut(0x5D));
        y += 9;
    }
    y += 4;
    char st[96];
    if (e->cat == 0) {
        const dat_cargo_t *c = &dat_cargo[e->idx];
        snprintf(st, sizeof(st), "Price %ld-%ld gold", (long)c->start1,
                 (long)c->start2);
        rd_text(&B_TINY, st, 10, y, blut(0x0E));
        y += 6;
        snprintf(st, sizeof(st), "Spread %ld", (long)c->burden + 1);
        rd_text(&B_TINY, st, 10, y, blut(0x0E));
    } else if (e->cat == 1) {
        const dat_units_t *u = &dat_units[e->idx];
        snprintf(st, sizeof(st), "Moves %ld   Attack %ld   Defend %ld",
                 (long)u->movement, (long)u->attack, (long)u->combat);
        rd_text(&B_TINY, st, 10, y, blut(0x0E));
        y += 6;
        if (u->cargo) {
            snprintf(st, sizeof(st), "Cargo %ld", (long)u->cargo);
            rd_text(&B_TINY, st, 10, y, blut(0x0E));
            y += 6;
        }
        if (u->hull) {
            snprintf(st, sizeof(st), "Hull %ld", (long)u->hull);
            rd_text(&B_TINY, st, 10, y, blut(0x0E));
        }
    } else if (e->cat == 4) {
        const dat_buildings_t *b = &dat_buildings[e->idx];
        if (b->tools_x10)
            snprintf(st, sizeof(st), "%ld hammers, %ld tools",
                     (long)b->cost, (long)b->tools_x10 * 10);
        else
            snprintf(st, sizeof(st), "%ld hammers", (long)b->cost);
        rd_text(&B_TINY, st, 10, y, blut(0x0E));
        y += 6;
        snprintf(st, sizeof(st), "Needs %ld colonists", (long)b->min_colony);
        rd_text(&B_TINY, st, 10, y, blut(0x0E));
        y += 6;
        if (b->upkeep)
            snprintf(st, sizeof(st), "Upkeep %ld", (long)b->upkeep);
        else
            snprintf(st, sizeof(st), "No upkeep");
        rd_text(&B_TINY, st, 10, y, blut(0x0E));
    }
    center_shadow(&B_TINY, "(Esc back)", 160, 190, blut(0x5D), 0);
}
