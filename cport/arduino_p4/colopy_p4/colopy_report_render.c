/* C-port Phase 7 cluster F — the F2..F10 advisor reports.
 *
 * A transcription of the census-verified JS painters (port/src/game.js
 * drawReport:9529 and the per-report bodies), citations carried over:
 *   frame       REPORT<N>.PIK plate (F9 -> REPORT1, F10 -> WOODPANL —
 *               the capture-matched assignment, game.js:9404), title
 *               centred y=5 ink 0x90, subtitle y=12 ink 0x91, OK box
 *               (286,184,30,14) rule 0x77 caption 0x92
 *   gauge       0x181F:0x236 via func_002EE4 + func_002D74 (flags bit 0
 *               = the Bresenham leftover spread; REBUILT 2026-08-06)
 *   F2          crosses gauge @0x037990-0x0379B4 (x=0xA y=0x19 span
 *               0x12C sprite EXE 0x39)
 *   F3          bells gauge @0x037BCE-0x037BF5 (sprite EXE 0x3F; the
 *               known live-frame discrepancy recorded in the JS),
 *               rebel/tory strip, REF quartet, FF grid cols {4,82,160,
 *               238}
 *   F4          the occupation matrix: cols {2,107,212}, row0 26 pitch
 *               18, icon 81+job (capture-pinned RULINGS 2026-08-07z2)
 *   F5          ruled price table (live 74_report_F5_economic.png):
 *               headers @MISC 58/59/203/204, rules y=33+8i, values
 *               right-aligned at {92,145,200,251}, K-abbrev at 10000
 *   F6          colony rows: marker+name+pop+cargo sprites+garrison
 *   F7          the naval grid (live 75_report_F7_naval.png)
 *   F8          per-power blocks pitch 45 (live 70_report_F8.png)
 *   F9          per-tribe blocks pitch 21 (live report_F9.png), name in
 *               the tribe's own colour, portrait ICONS 116 (modal)
 *   F10         the score breakdown (live 73_report_F10.png)
 * F1 is the Colonizopedia TERRAIN page (hard rule 7), not a report. */
#include <ctype.h>
#include <stdio.h>
#include <string.h>

#include "colopy_sim.h"
#include "colopy_data.h"
#include "colopy_text.h"
#include "colopy_render.h"

#define REPORT_TITLE_INK 0x90
#define REPORT_SUB_INK   0x91
#define REPORT_NAME_INK  0x92
#define REPORT_VALUE_INK 0x61
#define REPORT_RULE_INK  0x77
#define REPORT_GREEN_INK 0x0A
#define GAUGE_MARK 55

static rd_font R_TINY;
static void rresolve(void) {
    if (!R_TINY.payload) rd_font_open(&RD.pak, "FONTTINY.FF", &R_TINY);
}
static const uint8_t *rlut(uint8_t i) {
    static uint8_t l[4];
    l[0] = 0xFF; l[1] = i; l[2] = (uint8_t)(i - 1); l[3] = 0;
    return l;
}
/* The report body's SHADOWED text.
 *
 * The original draws these labels with a black drop shadow at exactly three
 * offsets -- (+1,0), (0,+1) and (+1,+1) -- and the coloured glyph on top.
 * That is not a guess: on the census F9 frame the model reproduces the black
 * pixels EXACTLY on two independent rows, 134/134 and 88/88, with zero
 * missing and zero extra. The 4- and 8-neighbour outlines both over-predict
 * (48 and 83 extra pixels on the same row), so the shadow really is the
 * down-right quadrant and nothing else.
 *
 * The port drew the glyph alone, so every label on the screen was thinner and
 * lighter than the original's. */
static void r_text_shadow(const rd_font *f, const char *str, int x, int y,
                          const uint8_t ink[4]) {
    static const uint8_t sh[4] = { 0xFF, 0, 0, 0 };
    rd_text(f, str, x + 1, y,     sh);
    rd_text(f, str, x,     y + 1, sh);
    rd_text(f, str, x + 1, y + 1, sh);
    rd_text(f, str, x,     y,     ink);
}
static int rround(int num2) {           /* Math.round(num2/2) */
    int v = num2 + 1;
    return v >= 0 ? v / 2 : -((-v + 1) / 2);
}
static void r_center(const char *s, int cx, int y, const uint8_t ink[4]) {
    int w = rd_text_width(&R_TINY, s);
    rd_text(&R_TINY, s, rround(2 * cx - (w - 1)), y, ink);
}
static void r_right(const char *s, int rx, int y, const uint8_t ink[4]) {
    rd_text(&R_TINY, s, rx - rd_text_width(&R_TINY, s), y, ink);
}
static void r_text_shadow(const rd_font *f, const char *str, int x, int y,
                          const uint8_t ink[4]);
static void r_right_shadow(const char *s, int rx, int y, const uint8_t ink[4]) {
    r_text_shadow(&R_TINY, s, rx - rd_text_width(&R_TINY, s), y, ink);
}
static int r_fh(void) { return R_TINY.cell_h + 2; }

static int unit_row_r(const char *name) {
    for (int i = 0; i < DAT_UNITS_COUNT; i++)
        if (strcmp(dat_units[i].name, name) == 0) return i;
    return -1;
}
static int unit_icon_r(const char *name) {
    int r = unit_row_r(name);
    return r >= 0 ? (int)dat_units[r].icon - 1 : 0;
}

/* ---- the report gauge (func_002EE4 + func_002D74, game.js:9673) ---- */
static void r_gauge(int frame, int drawn, int sub, int slots, int x, int y,
                    int span, int flags, int centre_arg, int numbers) {
    if (drawn <= 0 || slots <= 0) return;
    rd_frame f;
    rd_sheet_frame(&RD.icons, frame, &f);
    int w = (flags & 2) ? f.w + 2 : f.w;
    int pitch = slots <= 1 ? 1 : (span - w) / (slots - 1);
    if (pitch > w + 1) pitch = w + 1;
    if (pitch < 1) pitch = 1;
    int run = (slots - 1) * pitch, shift = 0;
    while ((run >> shift) > span - w && shift < 16) shift++;
    int total_run = (run >> shift) + w;
    int base = (centre_arg - 1 > total_run) ? centre_arg : span;
    int leftover = base - total_run;
    int x0 = centre_arg ? (leftover >> 1) : 0;
    int n = drawn >> shift, filled = (drawn - sub) >> shift;
    int b = slots >> shift;
    int cx = x + x0, acc = 0, mark_x = -1;
    for (int i = 0; i < n; i++) {
        rd_blit(&RD.icons, frame, cx, y + 1);
        if (i == filled) mark_x = cx;
        if (i >= filled) rd_blit(&RD.icons, GAUGE_MARK, cx, y + 1);
        cx += pitch;
        if (flags & 1) {
            acc += leftover;
            while (b > 0 && acc >= b) { acc -= b; cx += 1; }
        }
    }
    if (!numbers && !(pitch == 1 && drawn > 1)) return;
    rm_count_badge(drawn - sub, x + x0 + 2, y, 0x0F);
    if (mark_x >= 0) rm_count_badge(sub, mark_x + 2, y, 0x0C);
}

/* player-colony iteration in JS G.colonies order */
static int next_player_col(int from) {
    for (int ci = from + 1; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation()) return ci;
    return -1;
}

/* ---- F2 Religious ---- */
static void draw_f2(void) {
    /* The gauge SPAN is the STORED threshold, PowerRecord +0x30 -- the F2
     * caller func_037958 reads the pair [bx+0x2E]/[bx+0x30] @0x0379AB/AE
     * and passes them verbatim.  The port used to recompute the formula at
     * draw time, and its unit count came out 130 where the original's
     * record iteration counts 138 (the port's G.units excludes Europe-side
     * and aboard-ship records) -- threshold 268 vs the stored 284, which
     * spread the 30 crosses ~6%% wider and leaked sprite edges through the
     * smear.  Census C4.23; the count divergence itself is flagged in the
     * ledger, not silently absorbed. */
    int thr = CR.cross_threshold ? CR.cross_threshold
                                 : immigration_threshold();
    r_gauge(0x39 - 1, CR.crosses, 0, thr, 0x0A, 0x19, 0x12C, 1, 0, 0);
}

/* ---- F3 Continental Congress ---- */
static const int16_t F3_FF_COLS[4] = { 4, 82, 160, 238 };
static void draw_f3(void) {
    int fh = r_fh();
    char buf[128];
    int y = 24;
    if (CR.father_in_progress >= 0)
        snprintf(buf, sizeof(buf), "%s: (%s)", dat_text_misc[112],
                 dat_fathers[CR.father_in_progress].name);
    else
        snprintf(buf, sizeof(buf), "%s:", dat_text_misc[112]);
    rd_text(&R_TINY, buf, 4, y, rlut(REPORT_NAME_INK));
    y += fh;
    r_gauge(0x3F - 1, CS.powers[cs_nation()].bells, 0, father_cost_now(),
            4, y, 0x12C, 1, 0, 0);
    y += 12;
    /* rebel = mean SoL across the player's colonies, Math.round */
    int total = 0, ncol = 0;
    for (int ci = next_player_col(-1); ci >= 0; ci = next_player_col(ci)) {
        total += rt_sol(ci);
        ncol++;
    }
    int rebel = ncol ? rround(2 * total / ncol) : 0;
    /* JS: Math.round(sum/n) — sum/n first, then round: redo faithfully */
    if (ncol) {
        /* Math.round(total/ncol) = floor(total/ncol + 0.5) for
         * non-negative operands */
        rebel = (2 * total + ncol) / (2 * ncol);
    }
    snprintf(buf, sizeof(buf), "%s %s: %d%%  %s %s: %d%%",
             dat_text_misc[69], dat_text_misc[71], rebel,
             dat_text_misc[70], dat_text_misc[71], 100 - rebel);
    rd_text(&R_TINY, buf, 4, y, rlut(REPORT_NAME_INK));
    y += fh;
    {
        rm_crow_cell cells[2] = {
            { 0x7B, rebel, 0, 0 }, { 0x7C, 100 - rebel, 0, 0 }
        };
        rm_draw_count_row(cells, 2, 4, y, 0x12C, 2, 1);
    }
    y += 12;
    snprintf(buf, sizeof(buf), "%s %s:", dat_nations[cs_nation()].adjective,
             dat_text_misc[85]);
    rd_text(&R_TINY, buf, 4, y, rlut(REPORT_NAME_INK));
    y += fh;
    {
        rm_crow_cell cells[4] = {
            { unit_icon_r("Regulars"), cs_ref(0), 0, 0 },
            { unit_icon_r("Cavalry"), cs_ref(1), 0, 0 },
            { unit_icon_r("Artillery"), cs_ref(3), 0, 0 },
            { unit_icon_r("Man-O-War"), cs_ref(2), 0, 0 },
        };
        rm_draw_count_row(cells, 4, 4, y, 0x12C, 2, 1);
    }
    y += 14;
    snprintf(buf, sizeof(buf), "%s:", dat_text_misc[89]);
    rd_text(&R_TINY, buf, 4, y, rlut(REPORT_NAME_INK));
    y += fh;
    int k = 0;
    for (int i = 0; i < DAT_FATHERS_COUNT; i++) {
        if (!father_owned(i)) continue;
        rd_text(&R_TINY, dat_fathers[i].name, F3_FF_COLS[k % 4],
                y + (k / 4) * fh, rlut(REPORT_VALUE_INK));
        k++;
    }
}

/* ---- F4 Labor: the occupation matrix ---- */
static const int16_t F4_COLS[3] = { 2, 107, 212 };
static const int8_t F4_ORDER[3][9] = {
    { 0, 1, 2, 3, 4, 5, 6, 7, -1 },
    { 8, 9, 10, 11, 12, 13, 14, 15, 16 },
    { 17, 20, 21, 22, 24, 25, 26, 27, 19 },
};
#define F4_ROW0 26
#define F4_PITCH 18
/* countProfession (game.js:10120): colonists + field units carrying the
 * matching specialty (the job-name compare is string-vs-index in the JS
 * and never true, so only the profession byte counts) */
static int count_profession(int job) {
    int n = 0;
    for (int ci = next_player_col(-1); ci >= 0; ci = next_player_col(ci)) {
        const ColonyRecord *c = &CS.colonies[ci];
        for (int k = 0; k < c->population && k < 32; k++)
            if (job >= 1 && c->profession[k] == job) n++;
    }
    for (int q = 0; q < CR.n_units_order; q++) {
        int ui = CR.units_order[q];
        if (job >= 1 && CS.units[ui].profession == job) n++;
    }
    return n;
}
static void draw_f4(void) {
    for (int c = 0; c < 3; c++) {
        int base = F4_COLS[c];
        for (int row = 0; row < 9; row++) {
            int job = F4_ORDER[c][row];
            if (job < 0) continue;
            const char *name = dat_jobexpert[job];
            int y = F4_ROW0 + row * F4_PITCH;
            rd_blit(&RD.icons, rm_profession_icon(job), base + 2, y - 2);
            rd_text(&R_TINY, name, base + 12, y, rlut(REPORT_NAME_INK));
            char nb[12];
            snprintf(nb, sizeof(nb), "%d", count_profession(job));
            r_center(nb, base + 39, y + 8, rlut(REPORT_VALUE_INK));
        }
    }
}

/* ---- F5 Economic: the ruled price table ---- */
#define F5_RULE0 33
#define F5_PITCH 8
static const int16_t F5_HEAD_X[4] = { 76, 131, 170, 220 };
static const int16_t F5_VAL_X[4] = { 92, 145, 200, 251 };
static const int16_t F5_HEAD_MISC[4] = { 58, 59, 203, 204 };
static void f5_gold_str(int32_t v, char *out, size_t cap) {
    int32_t a = v < 0 ? -v : v;
    if (a >= 10000) snprintf(out, cap, "%dK", (int)(v / 1000));
    else snprintf(out, cap, "%d", (int)v);
}
static void draw_f5(void) {
    for (int c = 0; c < 4; c++)
        rd_text(&R_TINY, dat_text_misc[F5_HEAD_MISC[c]], F5_HEAD_X[c], 25,
                rlut(REPORT_NAME_INK));
    for (int i = 0; i <= DAT_CARGO_COUNT; i++)
        rd_fill(2, F5_RULE0 + i * F5_PITCH, 311, 1, REPORT_RULE_INK);
    /* the VERTICAL rule between the commodity names and the price
     * columns: x = 67, rows 25..176, same rule ink -- measured off the
     * census baseline (137 of its 152 rows are the untouched ink; the
     * rest is where text crosses it) */
    rd_fill(67, 25, 1, 152, REPORT_RULE_INK);
    const PowerRecord *p = &CS.powers[cs_nation()];
    for (int i = 0; i < DAT_CARGO_COUNT; i++) {
        int y = F5_RULE0 + 2 + i * F5_PITCH;
        rd_text(&R_TINY, dat_cargo[i].name, 2, y, rlut(REPORT_NAME_INK));
        char buf[24], g[16];
        snprintf(buf, sizeof(buf), "%d", (int)p->trade_tons[i]);
        r_right(buf, F5_VAL_X[0], y, rlut(REPORT_GREEN_INK));
        f5_gold_str(p->trade_gold[i], g, sizeof(g));
        snprintf(buf, sizeof(buf), "%s$", g);
        r_right(buf, F5_VAL_X[1], y, rlut(REPORT_GREEN_INK));
        snprintf(buf, sizeof(buf), "%d$", market_bid(i));
        r_right(buf, F5_VAL_X[2], y, rlut(REPORT_VALUE_INK));
        snprintf(buf, sizeof(buf), "%d$", market_ask(i));
        r_right(buf, F5_VAL_X[3], y, rlut(REPORT_VALUE_INK));
    }
}

/* ---- F6 Colony ---- */
static void draw_f6(void) {
    int i = 0;
    for (int ci = next_player_col(-1); ci >= 0 && i < 9;
         ci = next_player_col(ci), i++) {
        const ColonyRecord *c = &CS.colonies[ci];
        int y = 32 + i * 17;
        rm_draw_settlement(2, y - 2, rm_colony_level_ci(ci),
                           c->owner_power & 3, 0, 0xFF);
        char nm[25];
        memcpy(nm, c->name, 24);
        nm[24] = 0;
        rd_text(&R_TINY, nm, 25, y + 7, rlut(REPORT_NAME_INK));
        char nb[12];
        snprintf(nb, sizeof(nb), "%d", c->population);
        rd_text(&R_TINY, nb, 122, y + 7, rlut(REPORT_VALUE_INK));
        int cx = 162;
        for (int g = 0; g < 16; g++)
            if (c->stock[g] > 0 && cx < 238) {
                rd_blit(&RD.icons, 0x16 + g, cx, y);
                cx += 10;
            }
        int gar = 0;
        for (int q = 0; q < CR.n_units_order; q++) {
            int ui = CR.units_order[q];
            if (dat_units[CS.units[ui].type].hull > 0) continue;
            if (CS.units[ui].map_x == c->map_x &&
                CS.units[ui].map_y == c->map_y) gar++;
        }
        snprintf(nb, sizeof(nb), "%d", gar);
        rd_text(&R_TINY, nb, 250, y + 7, rlut(REPORT_VALUE_INK));
    }
}

/* ---- F7 Naval: the grid ---- */
#define F7_ROW0 42
#define F7_PITCH 20
/* Ship rows enter the shared panel composite (0x181F:0x2BC) at
 * func_03954C @0x039843 with bx = [bp-0x56] = 2 (the row x); sea-borne
 * LAND units enter at @0x039574 with bx = [bp-0x56]+0x56 = 88 (cargo
 * column).  The previously FITTED value 4 was compensating for
 * func_00380C's own +2 sprite offset, now modelled in rm_unit_panel. */
#define F7_PANEL_X 2
#define PW_ADD 4
#define PH_ADD 3
#define F7_PER_PAGE 7
#define F7_GRID_TOP 25
#define F7_GRID_BOT 180
#define F7_RULE0 40
#define F7_CARGO_X 88
#define F7_CARGO_PITCH 12
#define F7_CARGO_ICON 22
static const int16_t F7_COLX[5] = { 2, 82, 162, 242, 314 };
static const int16_t F7_CENTRE[4] = { 42, 122, 202, 280 };
static void draw_f7(void) {
    for (int y = F7_RULE0; y <= F7_GRID_BOT; y += F7_PITCH)
        rd_fill(F7_COLX[0], y, F7_COLX[4] - F7_COLX[0] + 1, 1,
                REPORT_RULE_INK);
    for (int c = 1; c < 4; c++)
        rd_fill(F7_COLX[c], F7_GRID_TOP, 1, F7_GRID_BOT - F7_GRID_TOP + 1,
                REPORT_RULE_INK);
    static const int16_t HEAD[4] = { 61, 62, 63, 64 };
    for (int c = 0; c < 4; c++)
        r_center(dat_text_misc[HEAD[c]], F7_CENTRE[c], 27,
                 rlut(REPORT_NAME_INK));
    int row = 0;
    /* map ships (G.units order = CR.units_order), then every crossing */
    for (int q = 0; q < CR.n_units_order && row < F7_PER_PAGE; q++) {
        int ui = CR.units_order[q];
        const UnitRecord *u = &CS.units[ui];
        if (dat_units[u->type].hull <= 0) continue;
        int y = F7_ROW0 + row * F7_PITCH;
        rm_unit_panel(F7_PANEL_X, y, 0, u->type, rm_unit_flags_ui(ui),
                   u->orders, (int)dat_nations[cs_nation()].color,
                   (int)dat_units[u->type].icon - 1, (int)cs_nation());
        rd_text(&R_TINY, dat_units[u->type].name, 26, y + 6,
                rlut(REPORT_VALUE_INK));
        /* func_03954C cargo column: one crate per occupied HOLD, engine
         * frame = (qty >= 0x64 ? 0x17 : 0x27) + good (@0x039605 full,
         * @0x0395A8 partial; goods via 0x181F:0xBE6, qty via 0xC68) =
         * bundle icon (22 + good full / 38 + good partial), at
         * x = 88 + 12k, y = row + 3.  Units aboard draw the generic
         * crate (the port's icon 22) after the goods. */
        int cx = F7_CARGO_X;
        for (int k = 0; k < CR.unit_n_hold[ui]; k++) {
            const hold_slot *h = &CR.unit_hold[ui][k];
            if (h->qty <= 0) continue;
            /* the runtime hold MERGES same-good slots (hold_add), but the
             * engine draws per RECORD slot -- one crate per 100 plus a
             * partial (rec 0's two full fur holds sit merged as
             * {furs, 200} and the baseline shows TWO crates) */
            int q = h->qty;
            while (q >= 100) {
                rd_blit(&RD.icons, 22 + h->good, cx, y + 3);
                cx += F7_CARGO_PITCH;
                q -= 100;
            }
            if (q > 0) {
                rd_blit(&RD.icons, 38 + h->good, cx, y + 3);
                cx += F7_CARGO_PITCH;
            }
        }
        for (int k = 0; k < CR.unit_n_pass[ui]; k++) {
            rd_blit(&RD.icons, F7_CARGO_ICON, cx, y + 3);
            cx += F7_CARGO_PITCH;
        }
        /* location column @0x0396A4 (formatter 0x191F:0xF82): the colony
         * NAME when the ship sits on a colony tile, else "(x, y)" */
        char loc[26];
        int docked = -1;
        for (int c = 0; c < CS.n_colonies; c++)
            if (CS.colonies[c].map_x == u->map_x &&
                CS.colonies[c].map_y == u->map_y) { docked = c; break; }
        if (docked >= 0) {
            memcpy(loc, CS.colonies[docked].name, 24);
            loc[24] = 0;
        } else {
            snprintf(loc, sizeof(loc), "(%d, %d)", u->map_x, u->map_y);
        }
        r_center(loc, F7_CENTRE[2], y + 6, rlut(REPORT_VALUE_INK));
        row++;
    }
    for (int q = 0; q < CR.n_europe && row < F7_PER_PAGE; q++) {
        const euro_crossing *e = &CR.europe[q];
        int y = F7_ROW0 + row * F7_PITCH;
        rm_unit_panel(F7_PANEL_X, y, 0, e->type, 0, 0,
                   (int)dat_nations[cs_nation()].color,
                   (int)dat_units[e->type].icon - 1, (int)cs_nation());
        rd_text(&R_TINY, dat_units[e->type].name, 26, y + 6,
                rlut(REPORT_VALUE_INK));
        r_center(dat_nations[cs_nation()].homeport, F7_CENTRE[2], y + 6,
                 rlut(REPORT_VALUE_INK));
        if (e->state != 0)
            r_center(dat_text_misc[10], F7_CENTRE[3], y + 6,
                     rlut(REPORT_VALUE_INK));
        row++;
    }
}

/* ---- F8 Foreign Affairs: per-power blocks ---- */
#define F8_BLOCK 45
#define F8_RULE0 10
#define F8_HEAD0 16
#define F8_ROW0 27
#define F8_TORY_X 80
static void draw_f8(void) {
    for (int i = 0; i < 4; i++) {
        int ry = F8_RULE0 + i * F8_BLOCK;
        rd_fill(0, ry, 320, 1, 0);
        char buf[80];
        /* G.leader is '' in the pinned import — every power shows its
         * @NATIONS leader */
        snprintf(buf, sizeof(buf), "%s's %s:", dat_nations[i].leader,
                 dat_nations[i].adjective);
        rd_text(&R_TINY, buf, 2, F8_HEAD0 + i * F8_BLOCK,
                rlut(REPORT_NAME_INK));
        int y = F8_ROW0 + i * F8_BLOCK;
        int rebels, tories;
        if (i == (int)cs_nation()) {
            rebels = tories = 0;
            for (int ci = next_player_col(-1); ci >= 0;
                 ci = next_player_col(ci)) {
                if (rt_sol(ci) >= 50) rebels++;
                else tories++;
            }
        } else {
            rebels = CR.rivals[i].n_col;
            tories = 0;
            for (int k = 0; k < CR.n_runits[i]; k++) tories++;
        }
        snprintf(buf, sizeof(buf), "%s: %d", dat_text_misc[86], rebels);
        rd_text(&R_TINY, buf, 2, y, rlut(REPORT_VALUE_INK));
        snprintf(buf, sizeof(buf), "%s: %d", dat_text_misc[87], tories);
        rd_text(&R_TINY, buf, F8_TORY_X, y, rlut(REPORT_VALUE_INK));
    }
}

/* ---- F9 Indian: per-tribe blocks ---- */
#define F9_ICON_X 10
#define F9_NAME_X 30
#define F9_COUNT_X 40
#define F9_LEVEL_RX 311
#define F9_MUSKET_X 152
#define F9_HORSE_X 208   /* = 40 + 56*3, the decoded grid; was 209 by eye */
#define F9_ICON_Y 25
#define F9_ROW0 28
#define F9_PITCH 21
/* 8 = the row loop's own bound (`cmp [bp-0x64], 8`): all eight tribes
 * draw in one pass; there is no F9 paginator (func_039E98 is the SCORE
 * screen's icon-flow placer, not a pager -- ledger B3.3) */
#define F9_PER_PAGE 8
#define F9_PORTRAIT 116
/* NAMES @LEVELS singular/plural (the JS TRIBE_LEVELS table) */
static const struct { const char *name, *one, *many; } R_LEVELS[4] = {
    { "Semi-Nomadic", "Camp", "Camps" },
    { "Agrarian", "Village", "Villages" },
    { "Advanced", "City", "Cities" },
    { "Civilized", "City", "Cities" },
};
static void draw_f9(void) {
    const uint8_t black[4] = { 0xFF, 0, 0, 0 };
    int row = 0;
    for (int ti = 0; ti < 8 && row < F9_PER_PAGE; ti++) {
        /* WHICH TRIBES GET A ROW -- byte-verified at @0x03784C-@0x037860.
         *
         * The row loop calls the relation getter (0x181F:0xA38 =
         * func_007F34) with (tribe + 4, power) and draws the row when
         * `al & 0x20`; failing that it falls back on TribeRecord +0x03 bit
         * 0x80, and only if BOTH are clear does it skip to the next tribe.
         * The pitch in the same loop is `add [bp-0x5C], 0x15` = 21, which
         * is F9_PITCH, and the bound is `cmp [bp-0x64], 8`.
         *
         * The port used to list a tribe when it had a village on an
         * EXPLORED tile.  That is a different question and it got the
         * census frame wrong twice over: it dropped the three EXTINCT
         * tribes the original lists (Incas, Aztecs, Tupi -- contacted, then
         * wiped out, drawn as "<name>: Extinct"), and it happened to agree
         * about the Iroquois only by accident.  The original skips the
         * Iroquois because their relation byte is 0 -- never contacted --
         * even though they own ELEVEN villages on that save. */
        const uint8_t *trec = &CS.tribes[ti * 0x4E];
        if (!CR.tribe_met[ti] && !(trec[0x03] & 0x80)) continue;
        int n = 0;
        for (int v = 0; v < CS.n_villages; v++)
            if (CS.villages[v].owner_tribe - 4 == ti) n++;
        int y = F9_ROW0 + row * F9_PITCH;
        int lv = tribe_level(ti);
        if (lv < 0) lv = 0;
        if (lv > 3) lv = 3;
        rd_blit(&RD.icons, F9_PORTRAIT, F9_ICON_X,
                F9_ICON_Y + row * F9_PITCH);
        /* the Sioux row is HARDCODED red: the painter overrides power
         * index 0xA (tribe 6) to ink 0xC (@0x037496-@0x03749B) */
        const uint8_t *tk = rlut(ti == 6 ? 0x0C
                                 : (uint8_t)dat_tribes[ti].color);
        char buf[64];
        if (!n) {
            snprintf(buf, sizeof(buf), "%s: %s", dat_tribes[ti].name,
                     dat_text_misc[130]);
            r_text_shadow(&R_TINY, buf, F9_NAME_X, y, tk);
            row++;
            continue;
        }
        snprintf(buf, sizeof(buf), "%s:", dat_tribes[ti].name);
        r_text_shadow(&R_TINY, buf, F9_NAME_X, y, tk);
        r_right_shadow(R_LEVELS[lv].name, F9_LEVEL_RX, y, tk);
        snprintf(buf, sizeof(buf), "%d %s", n,
                 n == 1 ? R_LEVELS[lv].one : R_LEVELS[lv].many);
        rd_text(&R_TINY, buf, F9_COUNT_X, y + 8, black);
        /* The sub-line is FOUR cells at pitch 0x38 = 56, decoded from the
         * row loop itself: settlements (F9_COUNT_X 40), missions (96),
         * muskets (F9_MUSKET_X 152) and horse herds (F9_HORSE_X 209) --
         * `add word ptr [bp-0x68], 0x38` three times, @0x037728,
         * @0x037783, @0x0377D2.  The two capture-derived x's the port
         * already carried land exactly on 40 + 56k.
         *
         * MUSKETS (@0x03766D-@0x0376B1): seed from TribeRecord +0x07, add
         * one per unit of that tribe whose type is 0x14 (Armed Braves) or
         * 0x16 (Mtd. Warriors) -- `cmp [bx+0x3146], 0x14 / 0x16` @0x03768E
         * and @0x037695 -- then multiply by 50 (`mov ax, 0x32; imul`
         * @0x0376AB).  Drawn only when nonzero (@0x037787).
         * HORSE HERDS (@0x0377D6): TribeRecord +0x08 verbatim, drawn only
         * when nonzero.  On the census fixture the Apache carry +0x07 = 0
         * with one Armed Brave -> "50 Muskets", and +0x08 = 1 -> "1 Horse
         * Herds", which is exactly what the original's row shows.
         *
         * The port used to read these from a RUNTIME v.stock map that the
         * import leaves empty, so both cells never drew at all.
         *
         * MISSIONS (C4.17, 2026-09-02): the second cell, x = 40 + 0x38 = 96
         * (`add [bp-0x68], 0x38` @0x037728).  Count (@0x037638-@0x03766B):
         * for each settlement whose tribe byte +0x02 equals this row's
         * (`cmp [bx+0x54ee], cl` @0x03763E) the engine selects it
         * (0x181F:0xA4C) and, when `([0x8D4A]+5 & 0xF) == [bp+6]` -- the
         * mission byte's low nibble equals the viewing power (@0x037650-
         * @0x03765E; +5 is 0xFF when no mission, so a bare settlement can
         * never match a power < 4) -- increments [bp-0x56].  Drawn only
         * when non-zero (`cmp [bp-0x56], 0; je` @0x03772C): itoa
         * (0x181F:0x182) + the separator 0x181F:0x178 = func_0028B0 =
         * strcat(buf, DGROUP:0x50) = " " + [0x2DF0] for a count of 1
         * (`cmp 1; jne` @0x037752) else [0x2DF2] (@0x037758/@0x03775E) --
         * the LABELS MISC loader @0x075226-@0x07523C stores slot O as
         * @MISC (O - 0x2DBA)/2, so 27 "Mission" / 28 "Missions" -- through
         * 0x181F:0x13C at ([bp-0x68], [bp-0x6C]) with colour 0 (@0x03776E-
         * @0x03777B), the same y + 8 sub-line as the settlements cell.
         * The census fixture carries no Dutch mission; the synthetic
         * `--renderreport ... F9 mission` scene stamps some so the C and
         * JS agree on it. */
        int missions = 0;
        for (int v = 0; v < CS.n_villages; v++) {
            const NativeSettlement *nv = &CS.villages[v];
            if (nv->owner_tribe - 4 != ti || nv->mission == 0xFF) continue;
            if ((nv->mission & 0x0F) == (int)cs_nation()) missions++;
        }
        if (missions) {
            snprintf(buf, sizeof(buf), "%d %s", missions,
                     dat_text_misc[missions == 1 ? 27 : 28]);
            rd_text(&R_TINY, buf, F9_COUNT_X + 0x38, y + 8, black);
        }
        int armed = 0;
        for (int u = 0; u < CS.n_units; u++)
            if ((CS.units[u].owner_flags & 0x0F) == ti + 4 &&
                (CS.units[u].type == 0x14 || CS.units[u].type == 0x16))
                armed++;
        int muskets = ((int)trec[0x07] + armed) * 50;
        if (muskets) {
            snprintf(buf, sizeof(buf), "%d %s", muskets, dat_cargo[15].name);
            rd_text(&R_TINY, buf, F9_MUSKET_X, y + 8, black);
        }
        if (trec[0x08]) {
            snprintf(buf, sizeof(buf), "%d %s", (int)trec[0x08],
                     dat_text_misc[45]);
            rd_text(&R_TINY, buf, F9_HORSE_X, y + 8, black);
        }
        row++;
    }
}

/* ---- F10 Colonization Score ---- */
#define F10_X 16
#define F10_ROW0 24
#define F10_PITCH 28
#define F10_GREEN 68
static void draw_f10(void) {
    score_parts_t s;
    score_parts(&s);
    const dat_nations_t *nat = &dat_nations[cs_nation()];
    char buf[128];
    /* G.leader is '' in the pinned import — the JS prints the double
     * space the empty string leaves */
    snprintf(buf, sizeof(buf), "%s  of the %s: %s %u",
             dat_difficulty[cs_difficulty()], nat->adjective,
             dat_seasons[cs_season()], cs_year());
    r_center(buf, 160, 13, rlut(REPORT_TITLE_INK));
    static const struct { int misc, sprite; } ROWS[2] = {
        { 115, 0x66 }, { 196, 0x3F }
    };
    int vals[2] = { 0, 0 };
    vals[0] = s.population;
    vals[1] = s.fathers;
    for (int i = 0; i < 2; i++) {
        int y = F10_ROW0 + i * F10_PITCH;
        snprintf(buf, sizeof(buf), "%s %s: +%d", nat->adjective,
                 dat_text_misc[ROWS[i].misc], vals[i]);
        rd_text(&R_TINY, buf, F10_X, y, rlut(F10_GREEN));
        rm_crow_cell cell = { ROWS[i].sprite,
                              vals[i] < 12 ? vals[i] : 12, 0, 0 };
        rm_draw_count_row(&cell, 1, F10_X, y + 8, 0x12C, 2, 1);
    }
    snprintf(buf, sizeof(buf), "%s: (%ld$ x%d)", dat_text_misc[59],
             (long)CS.powers[cs_nation()].gold, s.mult);
    rd_text(&R_TINY, buf, F10_X, 150, rlut(F10_GREEN));
    snprintf(buf, sizeof(buf), "%s: %d", dat_text_misc[121], s.total);
    rd_text(&R_TINY, buf, F10_X, 162, rlut(F10_GREEN));
}

/* ---- the shared frame (drawReport, game.js:9529) ---- */
static const struct {
    const char *fk, *pik;
    int title_misc, sub_misc;           /* -1 = none */
    void (*draw)(void);
} R_TAB[] = {
    { "F2", "REPORT2.PIK", 30, -1, draw_f2 },
    { "F3", "REPORT3.PIK", 37, -1, draw_f3 },
    { "F4", "REPORT4.PIK", 49, 56, draw_f4 },
    { "F5", "REPORT5.PIK", 50, 206, draw_f5 },
    { "F6", "REPORT6.PIK", 51, 208, draw_f6 },   /* f6View default 2 */
    { "F7", "REPORT7.PIK", 52, -1, draw_f7 },
    { "F8", "REPORT8.PIK", 93, -1, draw_f8 },
    { "F9", "REPORT1.PIK", 29, -1, draw_f9 },
    { "F10", "WOODPANL.PIK", 114, -1, draw_f10 },
};

void rm_draw_report(const char *fkey) {
    rresolve();
    for (unsigned i = 0; i < sizeof(R_TAB) / sizeof(R_TAB[0]); i++) {
        if (strcmp(R_TAB[i].fk, fkey) != 0) continue;
        rd_use_palette(R_TAB[i].pik);
        rd_pik(R_TAB[i].pik);
        char title[64];
        const char *t = dat_text_misc[R_TAB[i].title_misc];
        size_t n = 0;
        for (; t[n] && n + 1 < sizeof(title); n++)
            title[n] = (char)toupper((unsigned char)t[n]);
        title[n] = 0;
        r_center(title, 160, 5, rlut(REPORT_TITLE_INK));
        if (R_TAB[i].sub_misc >= 0)
            r_center(dat_text_misc[R_TAB[i].sub_misc], 160, 12,
                     rlut(REPORT_SUB_INK));
        R_TAB[i].draw();
        /* okButton (game.js:9562): hollow 0x77 box + @MISC 46 caption */
        rm_hollow_rect(286, 184, 30, 14, REPORT_RULE_INK);
        r_center(dat_text_misc[46], 286 + 15, 188, rlut(REPORT_NAME_INK));
        return;
    }
}

/* debug probe (env-guarded like COLOPY_COLONY_PROBE) */
void rm_report_probe(void);
void rm_report_probe(void) {
    int total = 0, ncol = 0;
    for (int ci = next_player_col(-1); ci >= 0; ci = next_player_col(ci)) {
        fprintf(stderr, "sol[%d]=%d\n", ncol, rt_sol(ci));
        total += rt_sol(ci);
        ncol++;
    }
    fprintf(stderr, "rebel=%d bells=%d cost=%d ref=%d,%d,%d,%d\n",
            ncol ? (2 * total + ncol) / (2 * ncol) : 0,
            (int)CS.powers[cs_nation()].bells, father_cost_now(),
            cs_ref(0), cs_ref(1), cs_ref(2), cs_ref(3));
    for (int i = 0; i < DAT_FATHERS_COUNT; i++)
        if (father_owned(i)) fprintf(stderr, "father %s\n", dat_fathers[i].name);
}

void rm_score_probe(void);
void rm_score_probe(void) {
    score_parts_t s;
    score_parts(&s);
    fprintf(stderr, "pop=%d fathers=%d sent=%d razed=%d gold=%d lib=%d rev=%d base=%d mult=%d total=%d\n",
            s.population, s.fathers, s.sentiment, s.razed, s.gold,
            s.liberty, s.revolution, s.base, s.mult, s.total);
    /* the population component per colony (score_parts' own classes) */
    for (int ci = 0; ci < CS.n_colonies; ci++) {
        const ColonyRecord *c = &CS.colonies[ci];
        if ((c->owner_power & 3) != cs_nation()) continue;
        int sum = 0;
        fprintf(stderr, "%s ; %d ; ", c->name, c->population);
        for (int k = 0; k < c->population && k < 32; k++) {
            int prof = c->profession[k];
            int v = (prof >= 25 && prof <= 27) ? 1
                  : (prof == 0 || prof >= 28 || prof == 19) ? 2 : 4;
            sum += v;
            fprintf(stderr, "%d%s", prof, k + 1 < c->population ? "|" : "");
        }
        fprintf(stderr, " ; sum %d\n", sum);
    }
}

/* ---- the woodcut plates (drawWoodcut, game.js:1180; §26.14) ----
 * Black clear, WOODFRAM + WDCUT<n> placed by their own sheet-header
 * anchors (hx-(w>>1), hy-h+1), the NAMEPLAT caption strip at y=162 and
 * the @WOODCUT caption at y=165 in FONT-NP with the sheet-palette inks
 * 0x5C/0x5D/0x5E (the woodcut sheets' own dark browns). */
static rd_font W_NP;
static void blit_anchored(const char *sheet, int idx) {
    rd_entry e;
    if (!rd_pak_find(&RD.pak, sheet, &e)) return;
    rd_frame f;
    if (!rd_sheet_frame(&e, idx, &f)) return;
    rd_blit(&e, idx, f.x - (f.w >> 1), f.y - f.h + 1);
}
void rm_draw_woodcut(int n) {
    if (!W_NP.payload) rd_font_open(&RD.pak, "FONT-NP.FF", &W_NP);
    rd_use_palette("WOODFRAM.SS");
    rd_fill(0, 0, RD_W, RD_GAME_H, 0);
    blit_anchored("WOODFRAM.SS", 0);
    char nm[16];
    snprintf(nm, sizeof(nm), "WDCUT%02d.SS", n);
    blit_anchored(nm, 0);
    const char *caption = (n >= 0 && n < 17) ? dat_woodcuts[n] : "";
    const uint8_t np[4] = { 0xFF, 0x5C, 0x5D, 0x5E };
    int cap_w = rd_text_width(&W_NP, caption);
    rd_entry pl;
    if (rd_pak_find(&RD.pak, "NAMEPLAT.SS", &pl)) {
        rd_frame l, m;
        rd_sheet_frame(&pl, 0, &l);
        rd_sheet_frame(&pl, 1, &m);
        int a = cap_w + 8 - 2 * l.w;
        int tiles = a > 0 ? (a + m.w - 1) / m.w : 0;   /* Math.ceil */
        if (tiles < 1) tiles = 1;
        int sx = rround(2 * 160 - (2 * l.w + tiles * m.w));
        rd_blit(&pl, 0, sx, 162);
        sx += l.w;
        for (int i = 0; i < tiles; i++, sx += m.w) rd_blit(&pl, 1, sx, 162);
        rd_blit(&pl, 2, sx, 162);
    }
    int w = rd_text_width(&W_NP, caption);
    rd_text(&W_NP, caption, rround(2 * 160 - (w - 1)), 165, np);
}

/* ---- Part E: the Continental Congress portrait page ----
 * func_03BB4A @0x03BB4A: CCBKGD.PIK full-screen (buffer -> screen 320x200
 * @0x3BBB5, its own palette to the DAC @0x3BB87), then func_03BAA6
 * @0x03BAA6 walks the 25-entry DGROUP draw-order table at file 0x1EBDA
 * (DG 0x123A, read @0x3BAB8) and, for every father the power owns
 * (power_has_father 0x181F:0x7B4 @0x3BAC5), builds "CC-" + NN
 * (@0x3BAD1..0x3BAFD; NN = the table VALUE = the @FATHERS index,
 * zero-padded @0x3BAE0/0x3BAE6) and blits its frame 1 anchored at the
 * sheet's own (es:[bx+0x46], es:[bx+0x48]) at 100% @0x3BB25..0x3BB36 —
 * every portrait's position is baked into its .SS; the table is only
 * the paint order.  The reveal (@0x3BBBA..0x3BC0C: bit cleared, page
 * drawn + presented, bit set, drawn again + staged present arg 8) is a
 * wipe collapsed here to its final frame (the wipe verb 0x181F:0x3EA is
 * TBD).  Key/click wait @0x3BC14.  No title, frame or OK widget.
 * Callers: the @FREEDOM acquisition (func_03BC42 @0x3BD1D, then the
 * Founding Father pedia page @0x3BD26) and the F3 dismissal (func_037A20
 * @0x38073, new_ff = -1).  A Teensy pak built with `--board teensy`
 * lacks CCBKGD/CC-*: rd_pak_find fails and the page stays black. */
static const uint8_t FF_DRAW_ORDER[25] = {
    6, 20, 1, 23, 24, 22, 7, 3, 8, 18, 4, 21, 10, 13, 0,
    17, 5, 12, 15, 11, 2, 9, 14, 19, 16
};
void rm_draw_congress(int new_ff) {
    (void)new_ff;                    /* the final frame shows him lit */
    rd_use_palette("CCBKGD.PIK");
    rd_fill(0, 0, RD_W, RD_GAME_H, 0);
    rd_pik("CCBKGD.PIK");
    for (int i = 0; i < 25; i++) {
        int id = FF_DRAW_ORDER[i];
        if (!father_owned(id)) continue;
        char nm[16];
        snprintf(nm, sizeof(nm), "CC-%02d.SS", id);
        blit_anchored(nm, 0);
    }
}

/* ---- Part E: the Declaration of Independence signing ----
 * func_03DA2A @0x03DA2A: DECOIND.PIK full-screen (@0x3DA47 load, @0x3DA6A
 * its palette to the DAC, @0x3DA98 buffer->screen; DECLARAT.PIK has no
 * loader in any EXE), then the leader name (0x540E + player*0x34
 * @0x3DAB4) lower-cased (strlwr 0xD1D:0xD46 @0x3DACD, A..Z only) and
 * word-initial capitalised (@0x3DB06..0x3DB3C: an alpha after a non-
 * alpha, if lower, -= 0x20; ctype table file 0x2018D, MSC bits 0 upper /
 * 1 lower / 2 digit / 3 space / 4 punct).  Pen seed x=0x7E (126)
 * @0x3DC3C, y=0x94 (148) @0x3DC42 — x is the dx register of the top-left
 * blit 0x181F:0x254 @0x3DD36, y its stack arg @0x3DD2C.  Per char
 * (@0x3DC58..0x3DCFD): space|punct -> x+3, y-1, no sheet; not alpha ->
 * DEC-SQIG 10 frames, y-4, then STOP; upper -> DEC-UPP<c> 10 frames,
 * y-3; lower -> DEC-LOW<c> 7 frames, y-2.  Frames i=0..n-1 are engine
 * frames i+2 = disk descriptors 1..n (@0x3DD30/0x3DD31), each drawn at
 * the pen and presented; then x += the descriptor-0 width (es:[bx+0x4A]
 * @0x3DD16, applied @0x3DDD9), y += the class delta (@0x3DDE0).  Loop
 * head @0x3DDE8..0x3DE0F: stop on the end flag or NUL; x >= 0xDC (220)
 * forces the SQIG-and-stop path (@0x3DE04).  Cadence @0x3DD51..0x3DDC3:
 * one 0xC0C:6 tick per frame = the 60.8766 Hz counter [0x92E8]
 * ([0x267A] @0xC857), the >= 5 ISR-tick floor (8.2 ms) being under one
 * tick; a key/click sets the skip flag (@0x3DD74/0x3DD88); the finished
 * page waits for a key/click @0x3DE17.  Its engine dispatch site is
 * unreachable statically (TBD).  The JS twin is declEvents/drawDeclaration
 * (game.js). */
static int decl_class(unsigned char c) {   /* file 0x2018D class sets */
    if (c >= 'A' && c <= 'Z') return 2;
    if (c >= 'a' && c <= 'z') return 3;
    if (c == ' ' || (c >= 9 && c <= 13)) return 1;
    if (strchr("!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~", (int)c) && c) return 1;
    return 0;                        /* digits, controls, >= 0x80 */
}
/* walks the signature in engine order, drawing the events below `step`
 * when draw != 0; returns the total event count */
static int decl_walk(const char *name, int step, int draw) {
    char s[32];
    size_t n = 0;
    int word_start = 1;
    for (const char *p = name; *p && n + 1 < sizeof(s); p++) {
        unsigned char c = (unsigned char)*p;
        if (decl_class(c) == 2) c = (unsigned char)(c + 0x20);   /* strlwr */
        int cl = decl_class(c);
        if (cl == 2 || cl == 3) {
            if (word_start && cl == 3) c = (unsigned char)(c - 0x20);
            word_start = 0;
        } else word_start = 1;
        s[n++] = (char)c;
    }
    s[n] = 0;
    int x = 126, y = 148, ev = 0;
    for (size_t i = 0; i < n; i++) {
        unsigned char c = (unsigned char)s[i];
        int cl = decl_class(c);
        if (x >= 220) cl = 0;                     /* @0x3DE04 -> @0x3DC88 */
        char nm[16] = "";
        int frames = 0, adv = 3, dy = -1;
        if (cl == 0) { snprintf(nm, sizeof(nm), "DEC-SQIG.SS"); frames = 10; dy = -4; }
        else if (cl == 2) { snprintf(nm, sizeof(nm), "DEC-UPP%c.SS", c); frames = 10; dy = -3; }
        else if (cl == 3) { snprintf(nm, sizeof(nm), "DEC-LOW%c.SS", c - 0x20); frames = 7; dy = -2; }
        if (nm[0]) {
            rd_entry e;
            rd_frame f;
            int have = rd_pak_find(&RD.pak, nm, &e) && rd_sheet_frame(&e, 0, &f);
            adv = have ? f.w : 0;
            for (int k = 0; k < frames; k++, ev++)
                if (draw && have && ev < step) rd_blit(&e, k + 1, x, y);
        }
        x += adv;
        y += dy;
        if (cl == 0) break;                       /* the end flag [bp-0x56] */
    }
    return ev;
}
void rm_draw_declaration(const char *name, int step) {
    rd_use_palette("DECOIND.PIK");
    rd_fill(0, 0, RD_W, RD_GAME_H, 0);
    rd_pik("DECOIND.PIK");
    decl_walk(name, step, 1);
}
int rm_declaration_total(const char *name) {
    return decl_walk(name, 0, 0);
}
const char *rm_declaration_name(void) {
    return CR.leader[0] ? CR.leader : dat_nations[cs_nation()].leader;
}

/* ---- Part E: the end-game score plate, func_03A9C0 @0x03A9C0 ----
 * The selector (score_panel, colopy_rivals.c) picks the band from the
 * UN-halved mult*base/100 (@0x3AA41..0x3AA68), halving after (@0x3AA6A).
 * Page (@0x3AAA5..0x3AD9F): "SCORE" + ("0" if panel < 9) + (panel+1)
 * (@0x3AAAA..0x3AADA); WOODPAN2.PIK into the screen surface (@0x3AAFF),
 * then the sheet loads with the palette-receive pointer [0x23F2:0x23F4]
 * aimed at the PIK's palette buffer (@0x3AB46..0x3AB68), so the DAC
 * upload @0x3AB84 is the PLATE's table and WOODPAN2 shows through it.
 * Text, all FONTTINY ([0x89E]) through the centred verb 0x181F:0x100
 * (str, x, w, y, colour): the three @EXPLOITS lines (%STRING0 = the name
 * at 0x5426 + player*0x34, read here as the country; %NUMBER0 = the
 * halved rating, @0x3AB9D..0x3ABB9) at x=0 w=320, y = 5, 5+(H+1),
 * 5+2(H+1), colour 0xFC (@0x3ABC7..0x3AC0B); @SCORE rows i = 0..panel
 * (@0x3AC1A..0x3ACA8) at y = 0xC3 - (H+1)(i+1), each split at its comma
 * (0x191F:0xFC4 = file 0x6FA3E, the second field left-trimmed by
 * 0x1A1F:0xB44 = file 0xD972), the first field centred in x=0xA0 w=0xA0
 * (@0x3AC89/0x3AC8C), colour 0xFE, or 0xFC on row i == panel
 * (@0x3AC3E..0x3AC4E); the caption = the last row's second field with
 * %STRING0 = strrchr(name, ' ') (0xD1D:0xD1A = file 0x102EA: the pointer
 * AT the last space, so the surname keeps its leading space) or the
 * whole name (@0x3ACB2..0x3ACE2), centred in x=0x22 w=0x8C at y=0x8E,
 * colour 0xFC (@0x3ACF6..0x3AD0B); the plate's frame 1 anchored at its
 * own descriptor at 100% (@0x3AD2F..0x3AD4C); tune RM_SCORE_TUNE
 * (@0x3AD51..0x3AD6D, the shell's au_cmd); key/click wait @0x3AD86.
 * JS twin: drawScoreScreen (game.js). */
void rm_draw_score(int panel) {
    rresolve();
    if (panel < 0) panel = 0;
    if (panel > 23) panel = 23;
    char plate[16];
    snprintf(plate, sizeof(plate), "SCORE%02d.SS", panel + 1);
    rd_use_palette(plate);
    rd_fill(0, 0, RD_W, RD_GAME_H, 0);
    rd_pik("WOODPAN2.PIK");
    int H = R_TINY.cell_h;
    score_parts_t s;
    score_parts(&s);
    int rating = s.base > 0 ? (s.mult * s.base / 100) >> 1 : 0;
    rm_subs subs;
    memset(&subs, 0, sizeof(subs));
    subs.str[0] = dat_nations[cs_nation()].country;
    subs.num[0] = rating;
    subs.num_set[0] = 1;
    int nb = 0;
    const char *const *ex = rm_event_body("EXPLOITS", &nb);
    char buf[256];
    int y = 5;
    for (int i = 0; i < 3 && i < nb; i++, y += H + 1) {
        rm_fill_template(ex[i], &subs, buf, sizeof(buf));
        r_center(buf, 160, y, rlut(0xFC));
    }
    char caption[128] = "";
    for (int i = 0; i <= panel && i < DAT_SCORENAMES_COUNT; i++) {
        const char *row = dat_scorenames[i];
        const char *k = strchr(row, ',');
        char f1[128];
        if (k) {
            size_t n = (size_t)(k - row);
            if (n >= sizeof(f1)) n = sizeof(f1) - 1;
            memcpy(f1, row, n);
            f1[n] = 0;
            const char *f2 = k + 1;
            while (*f2 == ' ' || *f2 == '\t') f2++;       /* the ltrim */
            snprintf(caption, sizeof(caption), "%s", f2);
        } else {
            snprintf(f1, sizeof(f1), "%s", row);
            caption[0] = 0;
        }
        r_center(f1, 0xA0 + 0xA0 / 2, 0xC3 - (H + 1) * (i + 1),
                 rlut(i == panel ? 0xFC : 0xFE));
    }
    const char *name = rm_declaration_name();
    const char *sp = strrchr(name, ' ');
    rm_subs cs;
    memset(&cs, 0, sizeof(cs));
    cs.str[0] = sp ? sp : name;
    rm_fill_template(caption, &cs, buf, sizeof(buf));
    r_center(buf, 0x22 + 0x8C / 2, 0x8E, rlut(0xFC));
    blit_anchored(plate, 0);
}
