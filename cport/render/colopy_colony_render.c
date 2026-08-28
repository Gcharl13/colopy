/* C-port Phase 7 cluster D — the colony screen.
 *
 * A transcription of this project's census-verified JS painter
 * (port/src/game.js drawColony:3449 and its helpers) over the C
 * records, with every byte citation carried over:
 *   plots/placement  func_025D34 @0x025D34 (the LCG placement, RULINGS
 *                    2026-08-06b), seed = ((y<<8)+x+[0x8D80]) & 0x7FFF
 *                    (func_009726, srand wrapper @0x00C30A)
 *   building frames  func_026DD4 @0x026DD4 (def+1 with the three
 *                    presence overrides)
 *   scene panel      func_0264A8 @0x0264A8 — 5x5 composited, x1.5 via
 *                    func_00531C's 2->3 duplication (cols dst%3==0,
 *                    rows dst%3==1), only the inner 3x3 shown; the 4x4
 *                    ramp dither func_005296 is NOT reproduced (TBD)
 *   tile strips      0x181F:0x236 gauge + the blocked-cell 0x0C box
 *                    (@0x026584) and worked-cell figures (@0x026763)
 *   plaza            func_0270D0 @0x0270D0 (row solve, food row,
 *                    SoL band @0x0273DC-0x027551)
 *   production panel func_0275CE (three fixed rows @0x0275EA-0x027630)
 *   count rows       func_0033F2 enqueue + func_003104 flush (the
 *                    layout solve @0x00317C-0x0031ED)
 *   ground speckle   positional-hash stand-in, TBD (noise source
 *                    unidentified — the JS approximation, mirrored)
 * Hover labels and drag highlights are pointer states the harness pins
 * off; the popup layer runs through the shared dialog framework. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../core/colopy_sim.h"
#include "../data/colopy_data.h"
#include "../data/colopy_text.h"
#include "colopy_render.h"

#define HUD_INK 68
#define STOCK_INK 0x31
#define SOL_INK 0x10
#define PANEL_INK 0x33
#define GAUGE_MARK 55
#define GAUGE_ALT 57
#define PROD_HAMMER_ICON 54

/* JOB_GOOD (game.js:2435): job row -> good, or the tally sentinels */
#define T_HAMMERS  (-1)
#define T_BELLS    (-2)
#define T_CROSSES  (-3)
#define T_TEACHING (-4)
static const int8_t RJOB_GOOD[19] = { 0, 1, 2, 3, 4, 5, 6, 7, 0,
                                      9, 10, 11, 12, T_HAMMERS, 14, 15,
                                      T_CROSSES, T_BELLS, T_TEACHING };

static rd_font C_TINY;
static void cresolve(void) {
    if (!C_TINY.payload) rd_font_open(&RD.pak, "FONTTINY.FF", &C_TINY);
}
static const uint8_t *clut(uint8_t i) {
    static uint8_t l[4];
    l[0] = 0xFF; l[1] = i; l[2] = (uint8_t)(i - 1); l[3] = 0;
    return l;
}
static void c_center(const char *s, int cx, int y, const uint8_t ink[4]) {
    int w = rd_text_width(&C_TINY, s);
    int num2 = 2 * cx - (w - 1);
    int x = num2 >= 0 ? (num2 + 1) / 2 : -((-num2) / 2);   /* Math.round */
    rd_text(&C_TINY, s, x, y, ink);
}
static void c_right(const char *s, int rx, int y, const uint8_t ink[4]) {
    rd_text(&C_TINY, s, rx - rd_text_width(&C_TINY, s), y, ink);
}

/* countBadge (func_002E4E @0x002E4E) — callable from any screen */
void rm_count_badge(int value, int x, int y, uint8_t colour) {
    if (value <= 0) return;
    cresolve();
    char s[12];
    snprintf(s, sizeof(s), "%d", value);
    rd_fill(x, y + 2, rd_text_width(&C_TINY, s) + 1, 7, 0);
    const uint8_t flat[4] = { 0xFF, colour, colour, colour };
    rd_text(&C_TINY, s, x + 1, y + 3, flat);
}

static int icon_w(int frame) {
    rd_frame f;
    return rd_sheet_frame(&RD.icons, frame, &f) ? f.w : 0;
}
static int icon_h(int frame) {
    rd_frame f;
    return rd_sheet_frame(&RD.icons, frame, &f) ? f.h : 0;
}

/* groundSpeckle (game.js:3856): deterministic positional hash, TBD */
static void ground_speckle(int x, int y, int w, int h) {
    rd_fill(x, y, w, h, 0x63);
    for (int j = 0; j < h; j++)
        for (int i = 0; i < w; i++) {
            uint32_t n = ((uint32_t)i * 73856093u) ^ ((uint32_t)j * 19349663u);
            uint32_t r = (n >> 8) % 100u;
            uint8_t c;
            if (r < 30) c = 0x62;
            else if (r < 47) c = 0x64;
            else continue;
            if (x + i < RD_W && y + j < RD_H)
                RD.fb[(y + j) * RD_W + (x + i)] = c;
        }
}

/* ---- placement (func_025D34, RULINGS 2026-08-06b) ---- */
static const int16_t PLOTS[15][2] = {
    { 56, 5 }, { 145, 7 }, { 173, 10 }, { 8, 33 }, { 37, 37 }, { 67, 46 },
    { 96, 45 }, { 6, 6 }, { 128, 45 }, { 10, 68 }, { 15, 94 }, { 87, 3 },
    { 66, 79 }, { 123, 98 }, { 123, 47 }
};
static const int8_t PLOT_COUNTS[5] = { 7, 4, 2, 1, 1 };
static const int8_t PLOT_STARTS[5] = { 0, 7, 11, 13, 14 };
static const int8_t PLOT_CATEGORY[15] = { 0,0,0,0,0,0,0, 1,1,1,1, 2,2, 3, 4 };
static const int8_t PLOT_DECOR[6] = { 45, 44, 43, 0, 46, 0 };
/* BUILDING_GROUP: RAM-read [0x8F88 + id*12] (+1 byte), measured */
static const int8_t BUILDING_GROUP[42] = {
    0,0,0, 1,1,1, 2,2,2, 3,3,3, 4,4,4, 5,5,5, 6, 7,7, 8,8,8, 9,9,9,
    10,10,10, 3,3, 11,11,11, 12,12, 13,13, 14,14,14,
};
/* the same plot table drives the JS buildingChain (game.js:2907) prereq/
 * supersede gates — exported for the input layer's construction picker */
int rm_building_group(int id) {
    return (id >= 0 && id < 42) ? BUILDING_GROUP[id] : -1;
}

typedef struct { uint32_t s; } crng;
static int crng_next(crng *r) {
    r->s = r->s * 214013u + 2531011u;
    return (int)((r->s >> 16) & 0x7FFF);
}
static int crng_range(crng *r, int lo, int hi) {
    return lo + ((crng_next(r) * (hi - lo + 1)) >> 15);
}

/* colonyPlacement (game.js:3386) over the runtime building list */
static void colony_placement(int ci, uint32_t plot_seed_base, int8_t out[15]) {
    const ColonyRecord *c = &CS.colonies[ci];
    uint32_t seed = ((((uint32_t)c->map_y << 8) + c->map_x + plot_seed_base))
                    & 0x7FFF;
    crng rng = { seed };
    int8_t shuffle[15];
    memset(shuffle, -1, sizeof(shuffle));
    for (int i = 0; i < 15; i++) {
        int cat = PLOT_CATEGORY[i], plot;
        do {
            plot = crng_range(&rng, 0, PLOT_COUNTS[cat] - 1) + PLOT_STARTS[cat];
        } while (shuffle[plot] >= 0);
        shuffle[plot] = (int8_t)i;
    }
    int8_t group_slot[15];
    memset(group_slot, -1, sizeof(group_slot));
    int next_in_cat[5] = { 0, 0, 0, 0, 0 };
    for (int id = 0; id < DAT_BUILDINGS_COUNT && id < 42; id++) {
        int g = BUILDING_GROUP[id];
        if (group_slot[g] < 0) {
            int cat = (int)dat_buildings[id].size;
            group_slot[g] = (int8_t)(PLOT_STARTS[cat] + next_in_cat[cat]++);
        }
    }
    /* have = the runtime list's ids (names resolve to the LOWEST def id,
     * the JS reading) plus def 0 */
    uint8_t have[42] = { 0 };
    have[0] = 1;
    for (int k = 0; k < CR.col[ci].n_bld; k++) {
        int id = CR.col[ci].bld[k];
        int first = bld_first_row(id);
        if (first >= 0 && first < 42) have[first] = 1;
    }
    memset(out, -1, 15);
    for (int id = 0; id < DAT_BUILDINGS_COUNT && id < 42; id++) {
        if (!have[id]) continue;
        out[shuffle[group_slot[BUILDING_GROUP[id]]]] = (int8_t)id;
    }
}

/* buildingFrame (func_026DD4 @0x026DD4), bundle space (EXE-1) */
static int building_frame(int ci, int id) {
    int frame = id + 1;
    if (id == 0 && !colony_has_name(ci, dat_buildings[0].name)) frame = 0x11;
    if (id == 0x0F || id == 0x11) {
        if (!colony_has_name(ci, dat_buildings[0x0F].name)) frame = 0x2F;
        else if (colony_has_name(ci, dat_buildings[0x11].name)) frame = 0x30;
    }
    return frame - 1;
}

/* colonistFigure (game.js:9606): profession figure, else 100 */
static const int8_t PROF_FIG_HI[10] = { 99, 100, 58, 59, 60, 104,
                                        61, 106, 107, 66 };
int rm_profession_icon(int job) {
    if (job < 0) return -1;
    if (job <= 17) return 81 + job;
    if (job >= 18 && job <= 27) return PROF_FIG_HI[job - 18];
    return -1;
}
static int colonist_figure(uint8_t prof) {
    /* the sav byte indexes @JOBEXPERT directly; byte 0 IS the Expert
     * Farmer (C4.26 resolved 2026-08-28 — the DOS expert test @0x9CDC is
     * plain byte equality and the Vlissingen scene badges prove prof-0
     * farmers expert); 28 = no specialty -> the plain figure 100 */
    if (prof <= 27) {
        int f = rm_profession_icon(prof);
        if (f >= 0) return f;
    }
    return 100;
}

/* jobForBuilding (game.js:2473) — the WORKPLACES chain->job binding */
static const struct { const char *bld; const char *job; } WORKPLACE[24] = {
    { "Weaver's House", "Weaver" }, { "Weaver's Shop", "Weaver" },
    { "Textile Mill", "Weaver" },
    { "Tobacconist's House", "Tobacconist" },
    { "Tobacconist's Shop", "Tobacconist" }, { "Cigar Factory", "Tobacconist" },
    { "Rum Distiller's House", "Distiller" }, { "Rum Distillery", "Distiller" },
    { "Rum Factory", "Distiller" },
    { "Fur Trader's House", "Fur Trader" }, { "Fur Trading Post", "Fur Trader" },
    { "Fur Factory", "Fur Trader" },
    { "Blacksmith's House", "Blacksmith" }, { "Blacksmith's Shop", "Blacksmith" },
    { "Iron Works", "Blacksmith" },
    { "Armory", "Gunsmith" }, { "Magazine", "Gunsmith" },
    { "Arsenal", "Gunsmith" },
    { "Carpenter's Shop", "Carpenter" }, { "Lumber Mill", "Carpenter" },
    { "Town Hall", "Statesman" },
    { "Church", "Preacher" }, { "Cathedral", "Preacher" },
    { "Schoolhouse", "Teacher" },
};
static int job_row(const char *job) {
    for (int i = 0; i < 28; i++)
        if (strcmp(dat_jobs[i], job) == 0) return i;
    return -1;
}
static int job_for_building_name(const char *name) {
    for (int i = 0; i < 24; i++)
        if (strcmp(WORKPLACE[i].bld, name) == 0)
            return job_row(WORKPLACE[i].job);
    if (strcmp(name, "College") == 0 || strcmp(name, "University") == 0)
        return job_row("Teacher");
    return -1;
}

/* ---- the count-row machinery (func_0033F2/003104) ---- */
typedef struct {
    const rm_crow_cell *cell;
    int x, step, total, filled, w;
} crow_ent;

static int count_row_layout(const rm_crow_cell *cells, int ncells, int x0,
                            int span, int gap0, crow_ent *out) {
    rm_crow_cell const *row[16];
    int n = 0;
    for (int i = 0; i < ncells; i++)
        if (cells[i].count > 0 || cells[i].sub > 0) row[n++] = &cells[i];
    if (!n) return 0;
    int multi = 0, extras = 0, total_w = 0;
    for (int i = 0; i < n; i++) {
        if (row[i]->count > 1) { multi++; extras += row[i]->count - 1; }
        total_w += icon_w(row[i]->frame);
    }
    int gap = gap0, spacing = 0, avail = 0;
    for (int guard = 0; guard < 4096; guard++) {
        int slack = total_w - n * spacing;
        if (slack < 0) slack = 0;
        avail = span - (n - 1) * gap - slack;
        if (avail < multi) {
            if (gap > 0) { gap--; continue; }
            if (slack > 0) { spacing++; continue; }
            avail = multi;
        }
        if (multi <= avail) break;
    }
    int shift = 0, pitch = 0;
    if (extras) {
        pitch = avail / extras;
        if (pitch == 0)
            do { shift++; } while ((extras >> shift) > avail && shift < 16);
    }
    int x = x0, no = 0;
    for (int i = 0; i < n; i++) {
        int w = icon_w(row[i]->frame);
        int step = pitch == 0 ? 1 : (w + 1 < pitch ? w + 1 : pitch);
        int total = row[i]->count >> shift;
        int filled = (row[i]->count - row[i]->sub) >> shift;
        out[no++] = (crow_ent){ row[i], x, step, total, filled, w };
        int run = total - 1;
        if (run < 0) run = 0;
        x += run * step + w - spacing + gap;
    }
    return no;
}

void rm_draw_count_row(const rm_crow_cell *cells, int ncells, int x0, int y,
                       int span, int gap0, int numbers) {
    crow_ent es[16];
    int n = count_row_layout(cells, ncells, x0, span, gap0, es);
    for (int e = 0; e < n; e++) {
        int always = (es[e].cell->flags & 0x8000) != 0;
        int alt = (es[e].cell->flags & 0x4000) != 0;
        int mark_x = -1, x = es[e].x;
        for (int i = 0; i < es[e].total; i++) {
            if (alt && i < es[e].filled)
                rd_blit(&RD.icons, GAUGE_ALT, x, y);
            else {
                rd_blit(&RD.icons, es[e].cell->frame, x, y);
                if (always || (i >= es[e].filled && !alt))
                    rd_blit(&RD.icons, GAUGE_MARK, x, y);
            }
            if (i == es[e].filled) mark_x = x;
            x += es[e].step;
        }
        if (!(numbers || (es[e].step == 1 && es[e].cell->count > 1)))
            continue;
        rm_count_badge(alt ? es[e].cell->count
                        : es[e].cell->count - es[e].cell->sub,
                    es[e].x + 2, y, always ? 0x0C : 0x0F);
        if (mark_x >= 0 && !alt)
            rm_count_badge(es[e].cell->sub, mark_x + 2, y, 0x0C);
    }
}

/* gauge (0x181F:0x236; game.js:9672) — the tile-panel strips */
static void gauge_strip(int frame, int drawn, int sub, int slots, int x,
                        int y, int span, int numbers) {
    if (drawn <= 0 || slots <= 0) return;
    int w = icon_w(frame);
    int pitch = slots <= 1 ? 1 : (span - w) / (slots - 1);
    if (pitch > w + 1) pitch = w + 1;
    if (pitch < 1) pitch = 1;
    int run = (slots - 1) * pitch, shift = 0;
    while ((run >> shift) > span - w && shift < 16) shift++;
    int n = drawn >> shift, filled = (drawn - sub) >> shift;
    int cx = x, mark_x = -1;
    for (int i = 0; i < n; i++) {
        rd_blit(&RD.icons, frame, cx, y + 1);
        if (i == filled) mark_x = cx;
        if (i >= filled) rd_blit(&RD.icons, GAUGE_MARK, cx, y + 1);
        cx += pitch;
    }
    if (!numbers && !(pitch == 1 && drawn > 1)) return;
    rm_count_badge(drawn - sub, x + 2, y, 0x0F);
    if (mark_x >= 0) rm_count_badge(sub, mark_x + 2, y, 0x0C);
}

/* centreYield — now the core's byte model (compute_colony_center_yields
 * func_00A222, read end to end @0xA222..@0xA3D1; see colopy_colony.c).
 * Isabella: savannah sugar 3 + the difficulty +1 = the baseline's 4;
 * Vlissingen: rain-forest ore 1 + Minerals 3 + 1 = 5 (the "(Minerals)"
 * sidebar line, runtime-captured 2026-08-28). */
static void centre_yield(const ColonyRecord *c, int *food, int *good,
                         int *amount) {
    colony_centre_yield((int)(c - CS.colonies), food, good, amount);
}

/* The area-view colour jitter — BYTE_VERIFIED func_005296 @0x5296..@0x531B
 * (2026-08-28): a deterministic per-pixel dither inside the palette ramp.
 * Position hash = (rows_left & 3) + ((dest_offset & 3) << 2); colours
 * outside 0x10..0x87 pass through; band 0x10..0x30 uses mask 0x1F shift 0,
 * 0x31..0x40 mask 0xF shift 2, else mask 7 shift 2.  The delta flips sign
 * when it would leave the colour's ramp band. */
static uint8_t area_jitter(uint8_t al, uint8_t bl, int rows_left, int di) {
    if (al < 0x10 || al >= 0x88) return al;
    int shift = 2, mask = 7;
    if (al <= 0x30) { shift = 0; mask = 0x1F; }
    else if (al <= 0x40) { shift = 2; mask = 0xF; }
    int dh = (rows_left & 3) + ((di & 3) << 2);
    int dl = (bl + dh) & 0xF;
    if (dl == 0 || dl == 8) return al;
    int d = dl < 8 ? -((dl + 1) >> shift) : (dl - 7) >> shift;
    int cl = ((al - 0x10) & mask) + d;
    if (cl < 0 || cl > mask) d = -d;
    return (uint8_t)(al + d);
}

/* func_00531C — the area view's 2->3 upscale, now the LITERAL loop
 * (@0x531C..@0x53DC): the FULL 80x80 scene upscales to 120x120 (even
 * source columns and odd source rows double) and the panel shows the
 * (24,24)+72x72 window of it; every output pixel runs through
 * area_jitter with the running salt bx (+0xD when rows_left%4==0, +0x11
 * at each 4-aligned write, the duplicate-write bumps undone at each row
 * pass end).  Emulating the full frame matters because the off-window
 * writes advance the salt.  Model fit vs the DOS COLONY baseline: 3,555
 * of 5,184 window pixels reproduce exactly (the plain resample managed
 * 1,400); the residual is FLAGGED — a phase or source detail is still
 * unread, and no better variant was found in the parameter sweep. */
static void area_upscale(const uint8_t *scene80) {
    int bx = 0, bp2 = 0, dl = 0, dsty = 0;
    for (int k = 0; k < 80; k++) {
        int rows_left = 80 - k;
        int passes = (k & 1) ? 2 : 1;
        for (int p = 0; p < passes; p++) {
            if ((rows_left & 3) == 0) { bx += 0x0D; bp2 = 0; }
            int dstx = 0;
            for (int sx = 0; sx < 80; sx++) {
                uint8_t al = scene80[k * 80 + sx];
                for (int dup = 0; dup < 2; dup++) {
                    if (dup == 0) {
                        if ((dstx & 3) == 0) bx += 0x11;
                    } else {
                        dl = ~dl & 0xFF;
                        if (!dl) break;
                        if ((dstx & 3) == 0) { bx += 0x11; bp2 += 0x11; }
                    }
                    int wx = dstx - 24, wy = dsty - 24;
                    if (wx >= 0 && wx < 72 && wy >= 0 && wy < 72)
                        RD.fb[(32 + wy) * RD_W + 224 + wx] =
                            area_jitter(al, (uint8_t)bx, rows_left, dstx);
                    dstx++;
                }
            }
            bx -= bp2;
            dsty++;
        }
    }
}

/* worker-slot cell offsets (game.js:10338, colopy_colony.c) */
static const int8_t RCELL_DX[8] = { 0, 1, 0, -1, -1, 1, 1, -1 };
static const int8_t RCELL_DY[8] = { -1, 0, 1, 0, -1, -1, 1, 1 };

/* which colonist works surrounding cell (dx,dy); -1 = none */
static int worker_at_cell(const ColonyRecord *c, int dx, int dy) {
    for (int s = 0; s < 8; s++) {
        if (RCELL_DX[s] != dx || RCELL_DY[s] != dy) continue;
        int8_t k8 = c->tiles[s];
        int k = (uint8_t)k8;
        if (k != 0xFF && k < c->population && k < 32) return k;
        (void)k8;
    }
    return -1;
}

/* ---- the scene panel (func_0264A8) ---- */
static uint8_t scene80[80 * 80];
static void scene_grab(int px, int py, uint8_t *dst, int tw, int th) {
    for (int r = 0; r < th; r++)
        for (int cc = 0; cc < tw; cc++) {
            int sx = px + cc, sy = py + r;
            dst[r * tw + cc] = (sx >= 0 && sy >= 0 && sx < RD_W && sy < RD_H)
                                   ? RD.fb[sy * RD_W + sx] : 0;
        }
}

/* the plaza row's colonist under (mx,my) — the SAME pack the painter
 * solves (func_0270D0): people first, then the garrison after a 4-px
 * gap.  Garrison entries are units, not colonists, so they answer -1
 * (game.js:12193 skips e.colonist < 0). */
int rm_plaza_hit(int ci, int mx, int my) {
    if (ci < 0 || ci >= CS.n_colonies) return -1;
    const ColonyRecord *c = &CS.colonies[ci];
    int icons[64], nicons = 0, npeople;
    for (int k = 0; k < c->population && k < 32; k++)
        icons[nicons++] = colonist_figure(c->profession[k]);
    npeople = nicons;
    for (int q = 0; q < CR.n_units_order && nicons < 64; q++) {
        int ui = CR.units_order[q];
        if (dat_units[CS.units[ui].type].cargo > 0) continue;  /* dock strip */
        if (CS.units[ui].map_x == c->map_x && CS.units[ui].map_y == c->map_y)
            icons[nicons++] = (int)dat_units[CS.units[ui].type].icon - 1;
    }
    if (!nicons) return -1;
    int total_w = 0;
    for (int i = 0; i < nicons; i++) total_w += icon_w(icons[i]);
    int extra = nicons > npeople ? 4 : 0;
    int gap = 2;
    while (gap * (nicons - 1) + extra + total_w >= 96) gap--;
    int x = 2;
    for (int i = 0; i < nicons; i++) {
        int w = icon_w(icons[i]), h = icon_h(icons[i]);
        if (i < npeople && mx >= x && mx < x + w &&
            my >= 142 && my < 142 + h)
            return i;
        int adv = w + gap;
        x += adv > 1 ? adv : 1;
        if (i == npeople - 1) x += 4;
    }
    return -1;
}

/* the GARRISON half of the same pack: which CR.units_order index is under
 * (mx,my), or -1.  rm_plaza_hit answers only for the members before the 4-px
 * break; a figure past it is a unit, and clicking one opens @UNITOPTIONS
 * (game.js plazaUnitAt).  The order index is returned, not the record index,
 * because CR.units_order mirrors the JS G.units order the menu reorders. */
int rm_plaza_unit_hit(int ci, int mx, int my) {
    if (ci < 0 || ci >= CS.n_colonies) return -1;
    const ColonyRecord *c = &CS.colonies[ci];
    int icons[64], order[64], nicons = 0, npeople;
    for (int k = 0; k < c->population && k < 32; k++) {
        icons[nicons] = colonist_figure(c->profession[k]);
        order[nicons++] = -1;
    }
    npeople = nicons;
    for (int q = 0; q < CR.n_units_order && nicons < 64; q++) {
        int ui = CR.units_order[q];
        if (dat_units[CS.units[ui].type].cargo > 0) continue;  /* dock strip */
        if (CS.units[ui].map_x == c->map_x && CS.units[ui].map_y == c->map_y) {
            icons[nicons] = (int)dat_units[CS.units[ui].type].icon - 1;
            order[nicons++] = q;
        }
    }
    if (!nicons) return -1;
    int total_w = 0;
    for (int i = 0; i < nicons; i++) total_w += icon_w(icons[i]);
    int extra = nicons > npeople ? 4 : 0;
    int gap = 2;
    while (gap * (nicons - 1) + extra + total_w >= 96) gap--;
    int x = 2;
    for (int i = 0; i < nicons; i++) {
        int w = icon_w(icons[i]), h = icon_h(icons[i]);
        if (order[i] >= 0 && mx >= x && mx < x + w &&
            my >= 142 && my < 142 + h)
            return order[i];
        int adv = w + gap;
        x += adv > 1 ? adv : 1;
        if (i == npeople - 1) x += 4;
    }
    return -1;
}

void rm_draw_colony(int ci, uint32_t plot_seed_base, int colonist_sel,
                    int ship_sel, int view, int numbers);

void rm_draw_colony(int ci, uint32_t plot_seed_base, int colonist_sel,
                    int ship_sel, int view, int numbers) {
    cresolve();
    const ColonyRecord *c = &CS.colonies[ci];
    rd_use_palette("WOODTILE.SS");
    rd_frame wt;
    rd_sheet_frame(&RD.woodtile, 0, &wt);
    for (int y = 0; y < RD_GAME_H; y += wt.h)
        for (int x = 0; x < RD_W; x += wt.w)
            rd_blit(&RD.woodtile, 0, x, y);

    /* building field */
    ground_speckle(0, 8, 199, 120);
    int8_t present[15];
    colony_placement(ci, plot_seed_base, present);
    rd_entry bld;
    if (!rd_pak_find(&RD.pak, "BUILDING.SS", &bld)) return;
    for (int i = 0; i < 15; i++) {
        int id = present[i];
        int px = PLOTS[i][0], py = PLOTS[i][1];
        if (id < 0) {
            int decor = PLOT_DECOR[PLOT_CATEGORY[i]];
            if (decor) rd_blit(&bld, decor - 1, px, py + 8);
            continue;
        }
        rd_blit(&bld, building_frame(ci, id), px, py + 8);
    }
    /* the worker + production layer */
    const char *probe = getenv("COLOPY_COLONY_PROBE");
    if (probe) {
        char pn[25]; memcpy(pn, c->name, 24); pn[24] = 0;
        fprintf(stderr, "COLONY %s x=%d y=%d n_bld=%d bld=[", pn,
                c->map_x, c->map_y, CR.col[ci].n_bld);
        for (int k = 0; k < CR.col[ci].n_bld; k++)
            fprintf(stderr, "%s%d", k ? "," : "", CR.col[ci].bld[k]);
        fprintf(stderr, "]\n");
    }
    int sol = rt_sol(ci);
    for (int i = 0; i < 15; i++) {
        int id = present[i];
        if (probe && id < 0)
            fprintf(stderr, "PLOT %d id=-1 decor=%d\n", i,
                    PLOT_DECOR[PLOT_CATEGORY[i]]);
        if (id < 0) continue;
        const char *name = dat_buildings[id].name;
        rd_frame pf;
        if (probe) {
            rd_sheet_frame(&bld, building_frame(ci, id), &pf);
            fprintf(stderr,
                    "PLOT %d id=%d fr=%d fw=%d fh=%d name=%s manned=%d\n",
                    i, id, building_frame(ci, id), pf.w, pf.h, name,
                    colony_has_name(ci, name));
        }
        if (!colony_has_name(ci, name)) continue;
        int job = job_for_building_name(name);
        if (job < 0) continue;
        /* crew: not on a field cell, occupation == job, first 3 */
        int crew[3], nc = 0, made = 0;
        for (int k = 0; k < c->population && k < 32 && nc < 3; k++) {
            if (c->occupation[k] != job) continue;   /* raw @JOB row */
            int on_cell = 0;
            for (int s = 0; s < 8; s++)
                if ((uint8_t)c->tiles[s] == k) on_cell = 1;
            if (on_cell) continue;
            crew[nc++] = k;
            made += indoor_yield(ci, sol, job, c->profession[k]);
        }
        if (probe) {
            fprintf(stderr, "  crew=[");
            for (int k = 0; k < nc; k++)
                fprintf(stderr, "%s%d", k ? "," : "",
                        colonist_figure(c->profession[crew[k]]));
            fprintf(stderr, "] made=%d job=%d\n", made, job);
        }
        if (!nc) continue;
        rd_frame bf;
        rd_sheet_frame(&bld, building_frame(ci, id), &bf);
        int px = PLOTS[i][0], py = PLOTS[i][1];
        int g = job < 19 ? RJOB_GOOD[job] : -99;
        int icon = g >= 0 ? 0x16 + g
                 : g == T_HAMMERS ? PROD_HAMMER_ICON
                 : g == T_BELLS ? 62 : g == T_CROSSES ? 56 : -1;
        if (icon >= 0)
            for (int j = 0; j < (made < 8 ? made : 8); j++)
                rd_blit(&RD.icons, icon, px + 6 * j, py + 9);
        for (int k = 0; k < nc; k++)
            rd_blit(&RD.icons, colonist_figure(c->profession[crew[k]]),
                    px + (bf.w >> 1) + 5 - 9 * k, py + 8 + bf.h - 13);
    }

    /* title strip */
    char title[80], nm[25];
    memcpy(nm, c->name, 24);
    nm[24] = 0;
    snprintf(title, sizeof(title), "%s, %s, %u, Gold: %ld$", nm,
             dat_seasons[cs_season()], cs_year(),
             (long)CS.powers[cs_nation()].gold);
    c_center(title, 160, 1, clut(HUD_INK));

    /* 5x5 scene composited in a corner buffer, then 2->3 upscaled */
    {
        /* HEAP, not a local and not a static: 80*320 = 25,600 bytes was
         * by far the largest stack frame in the port (a smash on a
         * board whose UI task stack is a few KB), and as a static it
         * moved the same bytes into internal .bss, which overflowed the
         * P4's internal-RAM link budget.  A heap block is neither —
         * on the board it comes out of PSRAM.  Allocated once; the
         * painter is single-threaded so one band is enough.
         * Found 2026-08-17 chasing a board crash. */
        static uint8_t *save;
        if (!save) save = (uint8_t *)malloc(80 * RD_W);
        if (!save) return;
        memcpy(save, RD.fb, 80 * RD_W);         /* borrow rows 0..79 */
        for (int ty = 0; ty < 5; ty++)
            for (int tx = 0; tx < 5; tx++) {
                int wx = c->map_x - 2 + tx, wy = c->map_y - 2 + ty;
                rm_scene_tile(wx, wy, tx * 16, ty * 16);
            }
        scene_grab(0, 0, scene80, 80, 80);
        memcpy(RD.fb, save, 80 * RD_W);         /* restore */
        area_upscale(scene80);
        rm_hollow_rect(223, 31, 74, 74, 0);
    }

    /* the tile panel (func_0264A8): strips + workers over the scene */
    {
        int cfood, cgood, camount;
        centre_yield(c, &cfood, &cgood, &camount);
        for (int row = 1; row <= 3; row++)
            for (int col = 1; col <= 3; col++) {
                int x = 200 + 24 * col, y = 8 + 24 * row;
                int dx = col - 2, dy = row - 2;
                if (dx == 0 && dy == 0) {
                    /* the CENTRE TILE wears a white hollow rect --
                     * (248,56)-(271,79) on the Isabella baseline.
                     * FLAGGED: Vlissingen's sits at (252,59)-(278,84),
                     * so the true anchor tracks something runtime (the
                     * strip extents?); the fixed cell is the better of
                     * the two models measured (net -35 px) */
                    rm_hollow_rect(x, y, 24, 24, 0x0F);
                    gauge_strip(22 + FOOD, cfood, 0, cfood, x, y, 24, numbers);
                    if (cgood >= 0)
                        gauge_strip(22 + cgood, camount, 0, camount, x,
                                    y + 13, 24, numbers);
                    continue;
                }
                int wx = c->map_x + dx, wy = c->map_y + dy;
                int blocked = 0;
                for (int v = 0; v < CS.n_villages && !blocked; v++)
                    if (CS.villages[v].map_x == wx &&
                        CS.villages[v].map_y == wy) blocked = 1;
                for (int q = 0; q < CS.n_colonies && !blocked; q++)
                    if (q != ci && CS.colonies[q].map_x == wx &&
                        CS.colonies[q].map_y == wy &&
                        (CS.colonies[q].owner_power & 3) == cs_nation())
                        blocked = 1;
                for (int rn = 0; rn < 4 && !blocked; rn++) {
                    if (rn == (int)cs_nation()) continue;
                    for (int k = 0; k < CR.rivals[rn].n_col && !blocked; k++)
                        if (CR.rivals[rn].col[k].x == wx &&
                            CR.rivals[rn].col[k].y == wy) blocked = 1;
                }
                if (blocked) rm_hollow_rect(x, y, 24, 24, 0x0C);
                int k = worker_at_cell(c, dx, dy);
                if (k >= 0) {
                    int job = c->occupation[k];
                    int g = (job >= 0 && job < 19) ? RJOB_GOOD[job] : -99;
                    int amount = field_yield(c, sol, job, c->profession[k],
                                             dx, dy);
                    if (g >= 0) {
                        int gf = tile_water(map_at(wx, wy)) ? GAUGE_ALT
                                                            : 22 + g;
                        if (amount > 0)
                            gauge_strip(gf, amount, 0, amount, x, y, 24,
                                        numbers);
                        else {
                            int fw = icon_w(gf);
                            rd_blit(&RD.icons, gf, x + ((16 - fw) >> 1),
                                    y + 1);
                            rd_blit(&RD.icons, 64, x, y);
                        }
                    }
                }
                /* map units standing on the tile (func_026374) */
                int stander = -1;
                for (int q = 0; q < CR.n_natives && stander < 0; q++) {
                    int ui = CR.natives_order[q];
                    if (unit_pos_x(ui) == wx && unit_pos_y(ui) == wy)
                        stander = ui;
                }
                for (int q = 0; q < CR.n_units_order && stander < 0; q++) {
                    int ui = CR.units_order[q];
                    if (CS.units[ui].map_x == wx && CS.units[ui].map_y == wy)
                        stander = ui;
                }
                for (int q = 0; q < CR.n_refs && stander < 0; q++) {
                    int ui = CR.refs_order[q];
                    if (CS.units[ui].map_x == wx && CS.units[ui].map_y == wy)
                        stander = ui;
                }
                if (stander >= 0)
                    rd_blit(&RD.phys0, 0x5A + CS.units[stander].type,
                            x + 4, y + 4);
                if (k >= 0)
                    rd_blit(&RD.icons, colonist_figure(c->profession[k]),
                            x + 14, y + 6);
                if (k >= 0 && k == colonist_sel)
                    rm_hollow_rect(x, y, 24, 24, 0x0A);
            }
    }

    /* COLONY.PIK town strip at y=128 */
    {
        rd_entry pik;
        if (rd_pak_find(&RD.pak, "COLONY.PIK", &pik)) {
            for (int r = 0; r < pik.h && 128 + r < RD_H; r++)
                memcpy(RD.fb + (128 + r) * RD_W, pik.payload
                       + (uint32_t)r * pik.w,
                       (size_t)(pik.w < RD_W ? pik.w : RD_W));
        }
    }

    /* plaza: colonist + garrison row (func_0270D0's solve) */
    colony_output r;
    colony_produce(ci, &r);
    {
        int icons[64], nicons = 0, npeople = 0;
        for (int k = 0; k < c->population && k < 32; k++)
            icons[nicons++] = colonist_figure(c->profession[k]);
        npeople = nicons;
        for (int q = 0; q < CR.n_units_order && nicons < 64; q++) {
            int ui = CR.units_order[q];
            /* cargo carriers live in the DOCK strip, not the plaza row --
             * the Vlissingen DOS baseline shows the Wagon Train beside the
             * Galleon in the dock and absent from the row */
            if (dat_units[CS.units[ui].type].cargo > 0) continue;
            if (CS.units[ui].map_x == c->map_x &&
                CS.units[ui].map_y == c->map_y)
                icons[nicons++] = (int)dat_units[CS.units[ui].type].icon - 1;
        }
        if (nicons) {
            int total_w = 0;
            for (int i = 0; i < nicons; i++) total_w += icon_w(icons[i]);
            int extra = nicons > npeople ? 4 : 0;
            int gap = 2;
            while (gap * (nicons - 1) + extra + total_w >= 96) gap--;
            int x = 2;
            for (int i = 0; i < nicons; i++) {
                int w = icon_w(icons[i]), h = icon_h(icons[i]);
                rd_blit(&RD.icons, icons[i], x, 142);
                if (i < npeople && i == colonist_sel)
                    rm_hollow_rect(x - 1, 143, w + 2, h, 0x0A);
                int adv = w + gap;
                x += adv > 1 ? adv : 1;
                if (i == npeople - 1) x += 4;
            }
        }
        /* the food / crosses / bells row (@0x027330-0x0273C7, re-read
         * 2026-08-28): the shaded sub-runs split FISH food ([0xA895])
         * from land food — the old model read the split off the CENTRE
         * yield, which matched only when the fixture's fish happened to
         * equal it.  Surplus branch (@0x27337, [0x8E32]==0): cell 1 =
         * eaten with sub eaten−min(fish, eaten); cell 2 = surplus with
         * sub surplus−leftover_fish.  Shortfall branch (@0x2737E): cell
         * 1 = produced with sub produced−fish; cell 2 = the overdraw
         * [0x8E32], 0x8000-marked. */
        int P = r.gross[FOOD], E = r.eaten, F = r.fish_food;
        rm_crow_cell cells[4];
        int nc = 0;
        if (E > P) {
            int s1 = P - F;
            cells[nc++] = (rm_crow_cell){ 22 + FOOD, P, s1 > 0 ? s1 : 0, 0x4000 };
            cells[nc++] = (rm_crow_cell){ 22 + FOOD, E - P, 0, 0x8000 };
        } else {
            int a = F < E ? F : E;
            int left = F - a; if (left < 0) left = 0;
            cells[nc++] = (rm_crow_cell){ 22 + FOOD, E, E - a, 0x4000 };
            cells[nc++] = (rm_crow_cell){ 22 + FOOD, P - E,
                                       (P - E) - left, 0x4000 };
        }
        cells[nc++] = (rm_crow_cell){ 56, r.crosses, 0, 0 };
        cells[nc++] = (rm_crow_cell){ 62, r.bells, 0, 0 };
        rm_draw_count_row(cells, nc, 2, 163, 118, 4, numbers);
        /* the SoL band (@0x0273DC-0x027551) */
        int pop = c->population;
        int sol_pct = sol, tory_pct = 100 - sol_pct;
        int tory_n = (tory_pct * pop + 50) / 100;
        int sol_n = pop - tory_n;
        char buf[32];
        int fw = icon_w(123), cw = icon_w(124);
        rd_blit(&RD.icons, 123, 2, 132);
        snprintf(buf, sizeof(buf), "%d%% (%d)", sol_pct, sol_n);
        rd_text(&C_TINY, buf, fw + 2, 133, clut(SOL_INK));
        int crown_x = 117 - cw;
        snprintf(buf, sizeof(buf), "%d%% (%d)", tory_pct, tory_n);
        c_right(buf, crown_x, 133, clut(SOL_INK));
        rd_blit(&RD.icons, 124, crown_x, 132);
    }

    /* right panel (207,130,95,48) — drawColonyPanel (game.js:4141) */
    if (view == 1) {
        /* Units Present (census3_colony_view1): @CMISC row 1 centred at
         * (254,132), then up to 6 unit figures on a 15px pitch, sprites
         * bottom-anchored at y=162 with the nation plate at y=150 */
        c_center(dat_text_cmisc[1], 254, 132, clut(PANEL_INK));
        int n = 0;
        for (int q = 0; q < CR.n_units_order && n < 6; q++) {
            int ui = CR.units_order[q];
            if (CS.units[ui].map_x != c->map_x ||
                CS.units[ui].map_y != c->map_y) continue;
            int ic = (int)dat_units[CS.units[ui].type].icon - 1;
            rd_frame f;
            rd_sheet_frame(&RD.icons, ic, &f);
            rd_blit(&RD.icons, ic, 209 + n * 15, 162 - f.h);
            rm_nation_plate(209 + n * 15, 150, rm_owner_colour_ui(ui),
                            CS.units[ui].orders);
            n++;
        }
    } else if (view == 2) {
        /* the Build view (census3_colony_view2): target name centred,
         * BUY (216,137,18,11) / CHANGE (270,137,29,11) plate buttons */
        int bip = c->building_in_production;
        const char *bn = bip < DAT_BUILDINGS_COUNT
                             ? dat_buildings[bip].name : dat_text_misc[32];
        c_center(bn, 254, 132, clut(PANEL_INK));
        static const struct { int x, y, w, h, lbl; } BB[2] = {
            { 216, 137, 18, 11, 2 }, { 270, 137, 29, 11, 3 }
        };
        for (int b = 0; b < 2; b++) {
            rd_fill(BB[b].x, BB[b].y, BB[b].w, BB[b].h, 1);
            rm_hollow_rect(BB[b].x, BB[b].y, BB[b].w, BB[b].h, 0x0F);
            c_center(dat_text_ctitle[BB[b].lbl], BB[b].x + (BB[b].w >> 1),
                     BB[b].y + 3, clut(15));
        }
    }
    /* right panel: the production strips (view 0 — func_0275CE), fed by
     * the engine's band planes (func_008E02): a raw good shows its
     * PRODUCTION (Vlissingen ore 13 = miners 8 + centre secondary 5) and
     * consumption is invisible while stock+intake covers it — only the
     * OUTAGE crosses out (Vlissingen's 4 lumber); a product cell shows
     * its post-outage output; the horses cell shows the bred WANT with
     * the unfed foals crossed (the baseline's 1 white + 3 red badges). */
    if (view == 0) {
        rm_crow_cell row0[8], row1[8], row2[4];
        int n0 = 0, n1 = 0, n2 = 0;
        /* row 0 (@0x027604): count = produced + [0x8E32] (the warehouse
         * overdraw, max(0, consumed - produced)), sub = that overdraw; a
         * good with NOTHING produced is skipped even if consumed. */
        for (int i = 1; i <= 7; i++) {
            if (i == 5 || r.gross[i] == 0) continue;
            row0[n0++] = (rm_crow_cell){ 22 + i,
                                      r.gross[i] + r.over_amt[i],
                                      r.over_amt[i], 0 };
        }
        /* row 1 (@0x027646): each manufacture pairs with byte[0x2A2+i] and
         * crosses out [0x8E5A + src*2] -- the source's OUTAGE (horses
         * source themselves: [0x8E6A] = foals that found no food). */
        static const int8_t RAW_SRC[16] = { -1, -1, -1, -1, -1, -1, -1, -1,
                                            8, 1, 2, 3, 4, -1, 6, 14 };
        for (int i = 8; i <= 15; i++) {
            int src = RAW_SRC[i];
            int amt = src >= 0 ? r.outage_amt[src] : 0;
            int cnt = r.gross[i] > amt ? r.gross[i] : amt;
            row1[n1++] = (rm_crow_cell){ 22 + i, cnt, amt, 0 };
        }
        /* row 2 (@0x0276AF): FOUR cells, each surplus-then-shortfall --
         * lumber PRODUCED plain, the lumber OUTAGE ([0x8E64]) as its own
         * 0x8000-marked run, the POST-OUTAGE hammers plain, then the
         * hammer shortfall as another marked run (the Vlissingen baseline
         * draws [8 planks][4X][8 hammers][4X] as four separate groups). */
        row2[n2++] = (rm_crow_cell){ 22 + LUMBER, r.gross[LUMBER], 0, 0 };
        row2[n2++] = (rm_crow_cell){ 22 + LUMBER, r.outage_amt[LUMBER], 0,
                                     0x8000 };
        row2[n2++] = (rm_crow_cell){ PROD_HAMMER_ICON, r.hammers, 0, 0 };
        row2[n2++] = (rm_crow_cell){ PROD_HAMMER_ICON,
                                     r.outage_amt[LUMBER], 0, 0x8000 };
        rm_draw_count_row(row0, n0, 213, 134, 89, 2, numbers);
        rm_draw_count_row(row1, n1, 213, 148, 89, 2, numbers);
        rm_draw_count_row(row2, n2, 213, 162, 89, 4, numbers);
    }
    /* view buttons */
    for (int k = 0; k < 3; k++) {
        int by = 132 + k * 15;                /* VIEW_BTN y=132 pitch 15 */
        rd_blit(&RD.icons, 67 + k, 303, by);
        if (k == view) rm_hollow_rect(302, by - 1, 16, 15, 0x0F);
    }

    /* dock */
    {
        int ships[20], nships = 0;
        for (int q = 0; q < CR.n_units_order && nships < 20; q++) {
            int ui = CR.units_order[q];
            /* membership = CARGO CAPACITY > 0, not hull: the DOS
             * baseline docks the Wagon Train beside the Galleon (and the
             * engine's y-1 @0x2801A applies only to types 0x0D..0x12,
             * which is exactly the tell that non-ship carriers reach this
             * strip) */
            if (dat_units[CS.units[ui].type].cargo > 0 &&
                CS.units[ui].map_x == c->map_x &&
                CS.units[ui].map_y == c->map_y)
                ships[nships++] = ui;
        }
        /* headline: verb 0x181F:0x100 @0x27DCE / @0x27E95 centres the
         * string in the rect x=0x79(121) w=0x54(84) at y=0x84(132) --
         * centre 163, and the DOS baseline measures the text at
         * 135..194 (centre 164.5), rows from 132.  (160,130) was the
         * old fitted guess. */
        if (!nships) {
            c_center("No Ships In Port", 163, 132, clut(PANEL_INK));
            for (int k = 0; k < 6; k++)
                rd_blit(&RD.icons, 122, 127 + 12 * k, 165);
        } else {
            int sel = ship_sel < nships ? ship_sel : 0;
            char buf[48];
            snprintf(buf, sizeof(buf), "Loading: %s",
                     dat_units[CS.units[ships[sel]].type].name);
            c_center(buf, 163, 132, clut(PANEL_INK));
            /* the ship strip goes through the SHARED panel composite --
             * @0x28049-@0x2805D calls 0x181F:0x2BC (func_00386A) with
             * mode 0x64, centre-width 0x10, y = 147 minus 1 for a ship
             * type (always here) minus 1 more for ordinal > 0
             * (@0x2801A-@0x2803D), x = 130 + 18k (@0x27FA2 pitch). */
            for (int k = 0; k < (nships < 4 ? nships : 4); k++) {
                int x = 130 + k * 18;
                int ui2 = ships[k];
                /* the y-1 (and -1 more past ordinal 0) applies ONLY to
                 * ship types 0x0D..0x12 (@0x2801A-@0x2803D); a wagon
                 * stays at 147 */
                int isship = CS.units[ui2].type >= 0x0D &&
                             CS.units[ui2].type <= 0x12;
                int y = 147 - (isship ? 1 + (k > 0 ? 1 : 0) : 0);
                rm_unit_panel(x, y, 16, CS.units[ui2].type,
                           CS.units[ui2].flags, CS.units[ui2].orders,
                           (int)dat_nations[cs_nation()].color,
                           (int)dat_units[CS.units[ui2].type].icon - 1);
                if (k == sel) rm_hollow_rect(x - 1, 146, 18, 18, 0x0A);
            }
            int ui = ships[sel];
            int cap = (int)dat_units[CS.units[ui].type].cargo;
            int taken = CR.unit_n_pass[ui];
            for (int k = 0; k < 6; k++) {
                int x = 127 + 12 * k;
                if (k >= cap) { rd_blit(&RD.icons, 122, x, 165); continue; }
                if (k < taken) {
                    int ty = entry_unit_type(&CR.unit_pass[ui][k]);
                    if (ty >= 0)
                        rd_blit(&RD.icons, (int)dat_units[ty].icon - 1, x,
                                168);
                    continue;
                }
                /* the runtime hold MERGES same-good slots; the engine
                 * draws per RECORD slot -- expand one crate per 100 plus
                 * a partial, like the F7 grid */
                int hs = k - taken, acc = 0, f = -1;
                for (int m = 0; m < CR.unit_n_hold[ui] && f < 0; m++) {
                    const hold_slot *sl = &CR.unit_hold[ui][m];
                    int q = sl->qty;
                    while (q >= 100 && f < 0) {
                        if (acc++ == hs) f = 0x16 + sl->good;
                        q -= 100;
                    }
                    if (q > 0 && f < 0 && acc++ == hs)
                        f = 0x26 + sl->good;
                }
                if (f >= 0) {
                    rd_frame ff;
                    rd_sheet_frame(&RD.icons, f, &ff);
                    /* crate placement @0x28063-@0x280AF: x centred as
                     * cellx + (cellw-1)/2 - w/2 + 1 = x + 5 - w/2, y =
                     * the cell y verbatim -- NO vertical centring */
                    rd_blit(&RD.icons, f, x + 5 - (ff.w >> 1), 165);
                }
            }
        }
    }

    /* stockpile bar */
    for (int i = 0; i < 16; i++) {
        int fw = icon_w(0x16 + i);
        rd_blit(&RD.icons, 0x16 + i, 9 + 19 * i - (fw >> 1), 181);
        char buf[12];
        snprintf(buf, sizeof(buf), "%u", c->stock[i]);
        c_center(buf, 9 + 19 * i, 194, clut(STOCK_INK));
    }
    rd_text(&C_TINY, "Exit", 306, 181, clut(0x31));

    /* separators */
    rd_fill(0, 7, RD_W, 1, 0);
    rd_fill(0, 128, RD_W, 1, 0);
    rd_fill(199, 7, 1, 122, 0);
}
