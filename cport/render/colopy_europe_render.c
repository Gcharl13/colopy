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

#include "../core/colopy_sim.h"
#include "../data/colopy_data.h"
#include "../data/colopy_text.h"
#include "colopy_render.h"

#define HUD_INK 68
#define PANEL_INK 69

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

/* entryIcon (game.js): the func_003710 resolver over a dock/crossing
 * entry — a {name,type} armed pair carries its profession in `name`, a
 * bare profession string IS the profession, a bare type name has none.
 * Settles the old FLAG: an armed passenger draws the veteran art only
 * with the matching profession, else the plain gray variant. */
static int entry_icon(const immigrant *e) {
    const char *name = immigrant_name(e);
    int prof = -1;
    for (int i = 0; i < DAT_JOBEXPERT_COUNT; i++)
        if (strcmp(dat_jobexpert[i], name) == 0) { prof = i; break; }
    return unit_icon_parts(entry_unit_type(e), prof, 0);
}


/* func_031298 @0x031298 -- the column layout by RUNNING ORDINAL (C4.11,
 * 2026-09-02).  Bins ordinal n into a band and returns the cell:
 *   n < 4          band 0, k = n       (@0x0312AC `cmp ax,4; jge`)
 *   n < 12         band 1, k = n - 4   (@0x0312BB-@0x0312C3)
 *   n - 12 < cap   band 2, k = n - 12  (@0x0312CF-@0x0312D9)
 *   else           band 3: undrawn (func_031366 tests band < 3)
 * step = 0x10 >> band (@0x0312E5-@0x0312E8) is both the cell h and the
 * pitch; band 0 adds `arg` to the pitch (@0x0312F0-@0x0312F8), band 2
 * adds 1 (`inc [bp-4]` @0x031300: pitch 5, NOT the 4 the ledger said);
 * w = h = step (@0x031303-@0x03130E); x = k * pitch + base (@0x031310-
 * @0x03131C); then per band (@0x03135A jump table): 0 -> y 0x92 (146)
 * @0x031329; 1 -> x += 2, w -= 2, y 0x89 (137) @0x031330-@0x03133F;
 * 2 -> x += 1, w -= 1, y 0x84 (132) @0x031346-@0x031353. */
typedef struct { int band, x, y, w, h; } cross_cell;
static cross_cell cross_layout(int n, int base_x, int cap, int arg) {
    cross_cell c;
    int k = 0;
    c.band = 0;
    if (n < 4) k = n;
    else if (n - 4 < 8) { c.band = 1; k = n - 4; }
    else if (n - 12 < cap) { c.band = 2; k = n - 12; }
    else c.band = 3;
    int step = 0x10 >> c.band, pitch = step;
    if (c.band == 0) pitch = step + arg;
    if (c.band == 2) pitch = step + 1;
    c.w = c.h = step;
    c.x = k * pitch + base_x;
    c.y = 0;
    if (c.band == 0) c.y = 0x92;
    else if (c.band == 1) { c.x += 2; c.w -= 2; c.y = 0x89; }
    else if (c.band == 2) { c.x += 1; c.w -= 1; c.y = 0x84; }
    return c;
}

/* func_031366 @0x031366 -- draw ONE unit at *ordinal and advance it
 * (`inc word ptr [bx]` @0x0314A9, unconditional).  A ship and its riders
 * therefore share one sequence: whoever the sentinel tile's occupancy
 * chain yields next takes the next cell.
 *   band 0/1 (@0x031393 `cmp [bp-4],2; jl`): the func_00386A composite
 *     (0x181F:0x2BC @0x0313C2) with mode 0x64 >> band (@0x0313A1-
 *     @0x0313A9: full for band 0, 0x32 half-size for band 1), W = 0x10
 *     (@0x03139F), x - (band == 1 ? 4 : 0) (@0x0313AA-@0x0313BB), flags 0.
 *     Then, for a SHIP (type 0x0D..0x12 @0x0313CB/@0x0313D5) in band 0
 *     with arg < 2 (@0x0313E8) and a non-empty hold (+0x0C @0x0313EE):
 *     the hold-0 good's icon 0x17 + get_nth_cargo(unit, 0) (0x181F:0xBE6
 *     = func_00B2A2, the +0x0D low nibble) at (x, y) @0x0313F5-@0x031417.
 *     The crossing panels pass arg 1, the harbour passes 2 -- so only a
 *     crossing ship wears its first cargo.
 *   band 2 (@0x031420 `cmp 3; jge skip`): the scaled blit 0x181F:0x2F8 =
 *     func_00E964 of the @UNIT icon byte [0x5232 + 14*type] at centre
 *     x + (w >> 1) - 1, bottom y + h - 1, pct 0x64 >> 2 = 25
 *     (@0x031426-@0x031468).
 *   cursor: when colour >= 0 and band < 3 (@0x03146D-@0x031477) a hollow
 *     rect (x-1, y-1)-(x+w, y+h) through 0x181F:0xCE (@0x0314A1),
 *     endpoint-inclusive (RULINGS 2026-09-02c): w+2 by h+2. */
static void cross_unit(int type, int frame, int colour, int cargo_good,
                       int base_x, int cap, int arg, int *ordinal,
                       int cursor_colour) {
    cross_cell c = cross_layout(*ordinal, base_x, cap, arg);
    (*ordinal)++;
    if (c.band < 2) {
        rm_unit_panel_mode(c.x - (c.band == 1 ? 4 : 0), c.y, 0x10, type, 0,
                           0, colour, frame, 0x64 >> c.band);
        if (type >= 0x0D && type <= 0x12 && c.band == 0 && arg < 2 &&
            cargo_good >= 0)
            rd_blit(&RD.icons, 0x16 + cargo_good, c.x, c.y);
    } else if (c.band < 3) {
        rd_blit_scaled(&RD.icons, (int)dat_units[type].icon - 1,
                       c.x + (c.w >> 1) - 1, c.y + c.h - 1, 0x64 >> 2);
    }
    if (cursor_colour >= 0 && c.band < 3)
        rm_hollow_rect(c.x - 1, c.y - 1, c.w + 2, c.h + 2,
                       (uint8_t)cursor_colour);
}

/* One crossing panel: func_0318D2 ("Expected Soon", base 2 @0x031915)
 * and func_0317CC ("Bound For", base 0x49 = 73 @0x031841).  Each resets
 * the ordinal once (@0x03191A / @0x031846) and walks TWO sentinel-tile
 * occupancy chains through 0x181F:0x7E0 = func_0066CC (head of the
 * first record at (p-0x10, p-0x10) then (p-0xC, ..) for Expected Soon
 * @0x03191F/@0x031954; (p-0x1C) then (p-0x18) for Bound For @0x03184B/
 * @0x031880), stepping the +0x1A link (0x181F:0x2E4 = func_0066BA), and
 * calls func_031366 for EVERY unit on them (@0x03193F/@0x031975,
 * @0x03186B/@0x0318A1) with cap 0xD, arg 1, colour -1.
 *
 * The port's crossing record is {ship, riders in chain order} (the
 * importer's rid_chain_order), so a ship followed by its riders IS the
 * chain the fixture carries (Galleon #56 heads 87 -> 86 -> 85).  FLAGGED:
 * two ships on one sentinel interleave by the tile chain, and the record
 * keeps no cross-ship link, so they draw ship-then-riders each in
 * CR.europe order; and which of the pair's two bases (0xE4/0xE8,
 * 0xF0/0xF4) a ship sat on is not kept either -- save state the ports
 * do not carry (research TBD 4). */
static void draw_crossing_panel(int state, int base_x) {
    int ordinal = 0;
    int colour = (int)dat_nations[cs_nation()].color;
    for (int q = 0; q < CR.n_europe; q++) {
        const euro_crossing *e = &CR.europe[q];
        if (e->state != state) continue;
        cross_unit(e->type, (int)dat_units[e->type].icon - 1, colour,
                   e->n_hold > 0 ? (int)e->hold[0].good : -1,
                   base_x, 0xD, 1, &ordinal, -1);
        for (int i = 0; i < e->n_pass; i++)
            cross_unit(entry_unit_type(&e->pass[i]), entry_icon(&e->pass[i]),
                       colour, -1, base_x, 0xD, 1, &ordinal, -1);
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
    /* TWO spaces after the country, not one.  The census caught it as a
     * clean 2 px width difference: the top bar matched the original EXACTLY
     * either side of one point -- every 8-px window left of x=136 fit at
     * shift +1 with zero differing pixels, every window right of x=144 fit at
     * shift -1 with zero -- and the gap between "Netherlands." and "Autumn"
     * measured 7 px on the original against the port's 5, which is exactly
     * the difference between the double space this string already uses after
     * the year (7 px on both sides) and a single one.  One character, and it
     * was 578 px of the screen: rows 0-6 now diff to ZERO. */
    snprintf(band, sizeof(band), "%s, %s.  %s, %u.  Tax:%d%%  Gold: %ld$",
             n->homeport, n->country, dat_seasons[cs_season()], cs_year(),
             (int)CS.powers[cs_nation()].tax_rate,
             (long)CS.powers[cs_nation()].gold);
    e_center(band, 160, 1, elut(HUD_INK));

    /* market bar */
    for (int i = 0; i < DAT_CARGO_COUNT; i++) {
        rd_frame f;
        rd_sheet_frame(&RD.icons, 0x16 + i, &f);
        /* The ICON blit, read from the bar's OWN drawer func_0310B4
         * (C4.10, 2026-09-02): cell_x = 1 + 0x13*i (@0x0310CA, @0x03124C),
         * frame 0x17 + i EXE = bundle 0x16 + i (@0x0310F2), width = the
         * runtime record's +8 word of that frame (`es:[bx+si+0x152]`
         * @0x0310FC), x = cell_x - (w >> 1) + 9 (@0x031101-@0x031105)
         * = 19i + 10 - (w >> 1), y = 0xB5 (@0x0310CF), through
         * 0x181F:0x254 = func_00E76A which adds no per-frame offset
         * (@0x00E7E7).  The census EUROPE frame fits all sixteen icons at
         * shift 0 (per-cell sweep 2026-09-02): delta 0 -> 0. */
        rd_blit(&RD.icons, 0x16 + i, 10 + 19 * i - (f.w >> 1), 181);
        char pr[16];
        snprintf(pr, sizeof(pr), "%d/%d", market_bid(i), market_ask(i));
        e_center(pr, 9 + 19 * i, 194, elut(0x2F));
        /* The cursor is 0x181F:0xCE with x0 = cell_x - 1 = 19i (`dec ax`
         * @0x031241), x1 = cell_x + 0x12 = 19i + 19, y0 = 179, y1 = 199
         * (@0x031242-@0x031247): endpoint-INCLUSIVE -- the DOS frame paints
         * column 19 in ink 14 on rows 179..199 -- so 20 wide, not 19.
         * Measured: the 40 px of cells 0/1 (both edge columns). */
        if (i == market_sel)
            rm_hollow_rect(19 * i, 179, 20, 21, 0x0E);
    }

    /* THE THREE PANEL HEADINGS -- centred, ink 69, and the port had all
     * three wrong.
     *
     * Ink: every heading is palette 69, not the 68 the top bar uses.
     * Measured on four independent captures (the census baseline plus the
     * three 2026-08-07 Europe frames). 69 is not a @COLORS slot, so the
     * VALUE comes from the frames and its SOURCE is unidentified -- flagged.
     *
     * Centring, and why it has to be centring rather than the fixed x's the
     * port carried: panel 3's heading MOVES with its content. Across those
     * frames "No Ships In Port" sits at 156..209 while "Loading:" sits at
     * 168..194 with the ship's name on a SECOND line at 160..205 -- so the
     * port was wrong twice there, once about the x and once about putting
     * the ship name on the same line. Panel 2 settles the convention:
     * "Bound For" (ink 33) at 91 and the region name (ink 56) at 79 are two
     * strings of different widths that solve to the SAME centre under
     * e_center's own rule, cx = 107 -- and they must be centred anyway,
     * because dat_regionname varies by nation and a fixed x could only ever
     * be right for one. Panel 3's two strings likewise both solve to
     * cx = 183.
     *
     * FLAGGED: "Loading:" alone solves to cx = 181..181.5, ~1.5 px off the
     * 183 its own second line gives. A trailing space in the engine's string
     * would close it exactly -- that is a guess, and is not made here.
     * Panel 1's heading never changes, so its cx = 36 is a one-string fit,
     * indistinguishable from a fixed x = 12 on every frame available. */
    e_center("Expected Soon", 36, 120, elut(PANEL_INK));
    /* base 2 (@0x031915) -- the port's old 13 had no byte behind it */
    draw_crossing_panel(1 /* toEurope */, 2);
    e_center("Bound For", 107, 120, elut(PANEL_INK));
    e_center(dat_regionname[cs_nation()], 107, 127, elut(PANEL_INK));
    draw_crossing_panel(2 /* toNewWorld */, 0x49);    /* 73 @0x031841 */

    /* the ship at the dock */
    int port[24], nport = 0;
    for (int q = 0; q < CR.n_europe; q++)
        if (CR.europe[q].state == 0) port[nport++] = q;
    const euro_crossing *ship =
        (euro_ship >= 0 && euro_ship < nport) ? &CR.europe[port[euro_ship]]
                                              : 0;
    e_center(ship ? "Loading:" : "No Ships In Port", 183, 120,
             elut(PANEL_INK));
    if (ship)
        e_center(dat_units[ship->type].name, 183, 127, elut(PANEL_INK));

    /* dock units (EURO_DOCK 232,137 pitch 17) */
    for (int d = 0; d < CR.n_dock_units && d < 6; d++) {
        const immigrant *e = &CR.dock_units[d];
        int x = 232 + d * 17;
        draw_sack(x + 9, 137 + 8);
        int fig = entry_icon(e);             /* func_003710 */
        rd_blit_silhouette(&RD.icons, fig, x + 1, 137 + 1, 0);
        rd_blit(&RD.icons, fig, x + 3, 137 + 1);
        if (d == dock_sel) rm_hollow_rect(x, 137, 18, 18, 0x0A);
    }
    /* Ships in port: the same func_031366 verb from the dock painter
     * func_0314DC -- base 0x92 = 146 (@0x031631), cap 5, arg 2
     * (@0x0316AD-@0x0316B1), ordinal reset once (@0x031638), iterating
     * the ship LIST 0..[0xFA2] (@0x031642-@0x0316C7, not a tile chain),
     * cursor 0xA for the selected index [0x9E1C] (@0x03166C; the 0xF
     * drag states @0x031686/@0x0316A1 are pointer states the harness pins
     * off).  So ordinal k sits at x = 146 + 18k, y = 146, composite W =
     * 16 -- the capture-pinned "sack at cell+(1,1), sprite at cell+(4,1)"
     * IS this composite's class-3 plate at x_c and its sprite at
     * x_c + LW - max(0, LW+SW-14) + 2 (149 for a 13-wide hull); the
     * separate sack the port drew on top of the plate is gone.  Cursor
     * (x-1, y-1)-(x+16, y+16) inclusive = the old (145+18k, 145, 18, 18).
     * arg 2 -> no cargo icon in the harbour. */
    {
        int ordinal = 0;
        int colour = (int)dat_nations[cs_nation()].color;
        for (int s = 0; s < nport; s++)
            cross_unit(CR.europe[port[s]].type,
                       (int)dat_units[CR.europe[port[s]].type].icon - 1,
                       colour, -1, 0x92, 5, 2, &ordinal,
                       s == euro_ship ? 0x0A : -1);
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

    /* Recruit-menu rows: @EUROLABEL first 3 at (281, 89+11r, 37, 9).
     *
     * The frame is a BEVEL, not a one-colour hollow rect: top edge and left
     * column in 0x39, bottom edge and right column in 0x30. Read straight off
     * the census frame, where all three buttons carry it identically -- rows
     * 89 and 97 are 37 px of 0x39 and 0x30 respectively, and rows 90..96 have
     * 0x39 at x=281 and 0x30 at x=317. The port drew a flat 0x7D box, which
     * is why the two edge rows differed across their whole width.
     *
     * FLAGGED: the original shows NO selected row on any Europe frame
     * available, so the 0x0F highlight below is the port's own affordance for
     * a click cursor the original may not have. It is kept, and the census
     * renders with euro_row = -1 to match the state the captures are in. */
    for (int r = 0; r < 3; r++) {
        int y = 89 + 11 * r;
        if (r == euro_row) {
            rm_hollow_rect(281, y, 37, 9, 0x0F);
        } else {
            rd_fill(281, y, 37, 1, 0x39);          /* top    */
            rd_fill(281, y, 1, 9, 0x39);           /* left   */
            rd_fill(281, y + 8, 37, 1, 0x30);      /* bottom */
            rd_fill(281 + 36, y, 1, 9, 0x30);      /* right  */
        }
        const char *lbl = dat_eurolabel[r];
        int w = rd_text_width(&E_TINY, lbl);
        /* x0 = 281 + (37-w)/2, fractional — FONT.draw rounds it */
        int x0 = eround(2 * 281 + 37 - w);
        char first[2] = { lbl[0], 0 };
        rd_text(&E_TINY, first, x0, y + 2, elut(0x0E));
        /* The tail of the label is 0x0F (white), not 0x10 -- measured on the
         * census frame, where "ECRUIT"/"URCHASE"/"RAIN" are all 0x0F while
         * only the accelerator letter is 0x0E. */
        rd_text(&E_TINY, lbl + 1, x0 + rd_text_width(&E_TINY, first), y + 2,
                elut(0x0F));
    }

    rd_text(&E_TINY, "Exit", 306, 181, elut(0x0F));
}
