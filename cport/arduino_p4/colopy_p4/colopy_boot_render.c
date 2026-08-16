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
