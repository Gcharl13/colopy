/* C-port Phase 7 cluster E — the Europe screen.
 *
 * A transcription of the census-verified JS painter (port/src/game.js
 * drawEurope:4438) over the C records, citations carried over:
 *   background      EUROPE.PIK + the usePalette merge; WOODTILE strip
 *                   clipped to the top 8 rows
 *   market bar      icons centred on 9+19i at y=181, bid/ask at y=194
 *                   ink 0x2F (capture-measured)
 *   crossings       ship + manifest, CAPTURE-PINNED 2026-08-07
 *                   (europe_1653_boundfor.png): passengers as their
 *                   profession figures at pitch 17, nation sack at
 *                   +5/+7, per-state bands y=146/137/132 (func_031298,
 *                   indexed by SLOT here — flagged approximation)
 *   dock / port     slot boxes from the live frames (232,137) pitch 17
 *                   and (145,145) pitch 18; sprite at box+(3,1) resp.
 *                   sack+(1,1)/ship+(4,1); ONLY the selected entry
 *                   wears the green cell (RE-READ 2026-08-07)
 *   cargo row       six slots x=147+12k y=165: dark cell for a real
 *                   hold, ICONS 122 cross beyond capacity
 *   recruit rows    (281, 89+11r, 37, 9) border 0x7D / 0x0F selected,
 *                   accelerator letter yellow 0x0E, rest 0x10
 *   nation sack     SACK_ROWS 7x9 pixel art (game.js:4415)
 * The euroMenu/euroMsg/drag layers are pointer states the harness pins
 * off. */
#include <stdio.h>
#include <string.h>

#include "colopy_sim.h"
#include "colopy_data.h"
#include "colopy_text.h"
#include "colopy_render.h"

#define HUD_INK 68

static rd_font E_TINY;
static void eresolve(void) {
    if (!E_TINY.payload) rd_font_open(&RD.pak, "FONTTINY.FF", &E_TINY);
}
static const uint8_t *elut(uint8_t i) {
    static uint8_t l[4];
    l[0] = 0xFF; l[1] = i; l[2] = (uint8_t)(i - 1); l[3] = 0;
    return l;
}
/* FONT.draw rounds x (Math.round, game.js:109); num2 = 2x */
static int eround(int num2) {
    int v = num2 + 1;
    return v >= 0 ? v / 2 : -((-v + 1) / 2);
}
static void e_center(const char *s, int cx, int y, const uint8_t ink[4]) {
    int w = rd_text_width(&E_TINY, s);
    rd_text(&E_TINY, s, eround(2 * cx - (w - 1)), y, ink);
}

/* drawSack (game.js:4424): the 7x9 nation sack */
static const char *const SACK_ROWS[9] = {
    ".KKKKK.", "KNNNNNK", "KNNbbNK", "KNbNNNK", "KNNbNNK",
    "KNNNbNK", "KNbbNNK", "KNNNNNK", "KKKKKKK",
};
static void draw_sack(int x, int y) {
    int c = (int)dat_nations[cs_nation()].color;
    for (int dy = 0; dy < 9; dy++)
        for (int dx = 0; dx < 7; dx++) {
            char ch = SACK_ROWS[dy][dx];
            if (ch == '.') continue;
            uint8_t ink = ch == 'K' ? 0
                        : ch == 'N' ? (uint8_t)c : (uint8_t)(c - 8);
            int px = x + dx, py = y + dy;
            if (px >= 0 && py >= 0 && px < RD_W && py < RD_H)
                RD.fb[py * RD_W + px] = ink;
        }
}

/* professionIconByName (game.js:9599) over an immigrant entry: the
 * @JOBEXPERT row's figure, or -1 when the name is not a profession
 * (a @UNIT type string / an armed entry draws its unit sprite). */
static int entry_prof_figure(const immigrant *e) {
    if (e->type_ov) return -1;                 /* armed: {name,type} */
    const char *name = immigrant_name(e);
    for (int i = 0; i < DAT_JOBEXPERT_COUNT; i++)
        if (strcmp(dat_jobexpert[i], name) == 0)
            return rm_profession_icon(i);
    return -1;
}

/* one crossing band: ship + its manifest (drawEurope crossingCell) */
static const int16_t CROSS_BANDS[3] = { 146, 137, 132 };
static void crossing_cell(const euro_crossing *e, int x, int k) {
    int y = CROSS_BANDS[k < 2 ? k : 2];
    rd_blit(&RD.icons, (int)dat_units[e->type].icon - 1, x + 3, y);
    int np = e->n_pass < 3 ? e->n_pass : 3;
    for (int i = 0; i < np; i++) {
        int px = x + 20 + i * 17;
        draw_sack(px + 5, y + 7);
        int fig = entry_prof_figure(&e->pass[i]);
        if (fig < 0)
            fig = (int)dat_units[entry_unit_type(&e->pass[i])].icon - 1;
        rd_blit(&RD.icons, fig, px, y);
    }
}

void rm_draw_europe(int euro_ship, int dock_sel, int euro_row,
                    int market_sel);

void rm_draw_europe(int euro_ship, int dock_sel, int euro_row,
                    int market_sel) {
    eresolve();
    /* THE MASTER PALETTE, NOT EUROPE.PIK's — census C4.5, 2026-08-19.
     *
     * The port used to take EUROPE.PIK's embedded palette here. The DOS
     * capture says the original does not: at all 22 indices where the two
     * disagree, the live screen matches VICEROY.PAL. Byte-checked at 54..59
     * — PIK holds (113,142,198)..(57,69,150), master and DOS both hold
     * (105,138,195)..(40,56,146).
     *
     * Measured, not argued: substituting master for PIK took the census's
     * EUROPE row from 12,817 px to 5,448 px (57% of its divergence).
     *
     * Scoped to Europe on purpose. Whether the engine ignores EVERY PIK's
     * palette is UNTESTED: the five report screens show 0 px of palette
     * divergence, so their plates agree with the master anyway and cannot
     * discriminate. Do not generalise this to rd_use_palette() without a
     * screen whose palette actually differs. */
    rd_use_palette(0);
    rd_pik("EUROPE.PIK");
    /* WOODTILE strip: SEVEN rows, y0..6, then a black separator at y7.
     *
     * spec/ui/europe_screen.md:51 has said "WOODTILE tiled y0..6 (7px only)
     * + black separator at y7" (measured from capture, A) since the screen
     * was specified. Both engines tiled EIGHT rows and drew no separator, so
     * row 7 came out wood instead of black -- all 320 px of it wrong, and no
     * gate could see it because C and JS were wrong identically. The census
     * caught it against the live DOS frame (2026-08-19, C4.6).
     *
     * The spec was right and the code never followed it; that is the whole
     * failure, and it is why "the spec says X" is worth checking against a
     * capture rather than assuming the implementation read it. */
    rd_entry wt;
    if (rd_pak_find(&RD.pak, "WOODTILE.SS", &wt)) {
        rd_frame f;
        if (rd_sheet_frame(&wt, 0, &f))
            for (int x0 = 0; x0 < RD_W; x0 += f.w)
                for (int r = 0; r < 7 && r < f.h; r++)
                    for (int cx = 0; cx < f.w && x0 + cx < RD_W; cx++) {
                        uint8_t v = f.pix[r * f.w + cx];
                        if (v != RD_TRANSPARENT)
                            RD.fb[r * RD_W + x0 + cx] = v;
                    }
    }
    rd_fill(0, 7, RD_W, 1, 0);            /* the y7 black separator */
    const dat_nations_t *n = &dat_nations[cs_nation()];
    char band[128];
    snprintf(band, sizeof(band), "%s, %s. %s, %u.  Tax:%d%%  Gold: %ld$",
             n->homeport, n->country, dat_seasons[cs_season()], cs_year(),
             (int)CS.powers[cs_nation()].tax_rate,
             (long)CS.powers[cs_nation()].gold);
    e_center(band, 160, 1, elut(HUD_INK));

    /* market bar */
    for (int i = 0; i < DAT_CARGO_COUNT; i++) {
        rd_frame f;
        rd_sheet_frame(&RD.icons, 0x16 + i, &f);
        rd_blit(&RD.icons, 0x16 + i, 9 + 19 * i - (f.w >> 1), 181);
        char pr[16];
        snprintf(pr, sizeof(pr), "%d/%d", market_bid(i), market_ask(i));
        e_center(pr, 9 + 19 * i, 194, elut(0x2F));
        if (i == market_sel)
            rm_hollow_rect(19 * i, 179, 19, 21, 0x0E);
    }

    /* panels */
    rd_text(&E_TINY, "Expected Soon", 16, 120, elut(HUD_INK));
    int k = 0;
    for (int q = 0; q < CR.n_europe && k < 2; q++)
        if (CR.europe[q].state == 1)
            crossing_cell(&CR.europe[q], 13, k++);
    rd_text(&E_TINY, "Bound For", 87, 120, elut(HUD_INK));
    rd_text(&E_TINY, dat_regionname[cs_nation()], 87, 127, elut(HUD_INK));
    k = 0;
    for (int q = 0; q < CR.n_europe && k < 2; q++)
        if (CR.europe[q].state == 2)
            crossing_cell(&CR.europe[q], 72, k++);

    /* the ship at the dock */
    int port[24], nport = 0;
    for (int q = 0; q < CR.n_europe; q++)
        if (CR.europe[q].state == 0) port[nport++] = q;
    const euro_crossing *ship =
        (euro_ship >= 0 && euro_ship < nport) ? &CR.europe[port[euro_ship]]
                                              : 0;
    rd_text(&E_TINY, ship ? "Loading:" : "No Ships In Port", 150, 120,
            elut(HUD_INK));
    if (ship)
        rd_text(&E_TINY, dat_units[ship->type].name, 186, 120,
                elut(HUD_INK));

    /* dock units (EURO_DOCK 232,137 pitch 17) */
    for (int d = 0; d < CR.n_dock_units && d < 6; d++) {
        const immigrant *e = &CR.dock_units[d];
        int x = 232 + d * 17;
        draw_sack(x + 9, 137 + 8);
        int fig = entry_prof_figure(e);
        if (fig < 0)
            fig = (int)dat_units[entry_unit_type(e)].icon - 1;
        rd_blit(&RD.icons, fig, x + 3, 137 + 1);
        if (d == dock_sel) rm_hollow_rect(x, 137, 18, 18, 0x0A);
    }
    /* ships in port (EURO_SHIP 145,145 pitch 18) */
    for (int s = 0; s < nport && s < 6; s++) {
        int x = 145 + s * 18;
        draw_sack(x + 1, 145 + 1);
        rd_blit(&RD.icons, (int)dat_units[CR.europe[port[s]].type].icon - 1,
                x + 4, 145 + 1);
        if (s == euro_ship) rm_hollow_rect(x, 145, 18, 18, 0x0A);
    }

    /* The cargo row: a dark cell per real hold, ICONS 122 beyond capacity.
     *
     * The grid is BYTE-VERIFIED, func_0314AE @0x0314AE: slot i sits at
     * x = 12*i + 0x93 (147), y = 0xA5 (165), w = 0x0A (10), h = 0x0C (12) —
     * the four words the function stores through its out-pointers.
     *
     * It is drawn UNCONDITIONALLY, which the port used to get wrong: this
     * loop hung off `if (ship)`, so an empty harbour left the row showing
     * bare backdrop.  func_0314DC @0x0314F1 branches the other way — with
     * no ship selected ([0xFA2] == 0) it walks i = 0..5 through that same
     * grid and paints EVERY slot from one sprite (@0x03154F, frame 0x7B).
     * The census caught it on the 1653 frame, where the original reads
     * "No Ships In Port" over six drawn-empty slots. */
    {
        int holds = ship ? (int)dat_units[ship->type].cargo : 0;
        for (int c = 0; c < 6; c++) {
            int x = 147 + 12 * c;
            if (c < holds) rd_fill(x, 165, 10, 12, 0);
            else rd_blit(&RD.icons, 122, x, 165);
        }
    }

    /* recruit-menu rows: @EUROLABEL first 3 at (281, 89+11r, 37, 9) */
    for (int r = 0; r < 3; r++) {
        int y = 89 + 11 * r;
        rm_hollow_rect(281, y, 37, 9, r == euro_row ? 0x0F : 0x7D);
        const char *lbl = dat_eurolabel[r];
        int w = rd_text_width(&E_TINY, lbl);
        /* x0 = 281 + (37-w)/2, fractional — FONT.draw rounds it */
        int x0 = eround(2 * 281 + 37 - w);
        char first[2] = { lbl[0], 0 };
        rd_text(&E_TINY, first, x0, y + 2, elut(0x0E));
        rd_text(&E_TINY, lbl + 1, x0 + rd_text_width(&E_TINY, first), y + 2,
                elut(0x10));
    }

    rd_text(&E_TINY, "Exit", 306, 181, elut(0x0F));
}
