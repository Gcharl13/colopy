/* --render smoke: draw a deterministic scene through the Phase-7 render
 * core and write the fb as a P6 PPM (palette-mapped RGB888).
 * tools/render_compare.py rebuilds the SAME scene straight from the
 * original assets via tools/ssdec.py and diffs pixel-exactly — an
 * oracle independent of the pak pipeline. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../render/colopy_render.h"
#include "../core/colopy_core.h"
#include "../core/colopy_sim.h"
#include "fixtures.h"

static int g_input_save_loaded;   /* the input projection's `rv` field:
                                   * rivals exist only once a game is loaded */

static uint8_t *slurp(const char *path, long *out_len) {
    FILE *f = fopen(path, "rb");
    if (!f) return 0;
    fseek(f, 0, SEEK_END);
    *out_len = ftell(f);
    fseek(f, 0, SEEK_SET);
    uint8_t *buf = (uint8_t *)malloc((size_t)*out_len);
    if (!buf || fread(buf, 1, (size_t)*out_len, f) != (size_t)*out_len) {
        fclose(f);
        free(buf);
        return 0;
    }
    fclose(f);
    return buf;
}

int render_smoke_main(const char *pak_path, const char *out_path) {
    long len;
    uint8_t *pak = slurp(pak_path, &len);
    if (!pak) { fprintf(stderr, "render: cannot read %s\n", pak_path); return 1; }
    if (!rd_init(pak, (uint32_t)len)) {
        fprintf(stderr, "render: bad pak\n");
        return 1;
    }
    /* the map screen's chrome palette (drawMap: usePalette('WOODTILE')) */
    rd_use_palette("WOODTILE.SS");

    /* 1. WOODTILE frame 0 tiled over the 320x200 logical screen */
    rd_frame wt;
    rd_sheet_frame(&RD.woodtile, 0, &wt);
    for (int y = 0; y < RD_GAME_H; y += wt.h)
        for (int x = 0; x < RD_W; x += wt.w)
            rd_blit(&RD.woodtile, 0, x, y);
    /* 2. the viewport black (drawMap VP = 0,8,240,192) */
    rd_fill(0, 8, 240, 192, 0);
    /* 3. every TERRAIN ground frame in a strip */
    for (int k = 0; k < RD.terrain.frames; k++)
        rd_blit(&RD.terrain, k, 4 + k * 17, 12);
    /* 4. a band of PHYS0 overlays (transparency over the grounds) */
    for (int k = 0; k < 24; k++)
        rd_blit(&RD.phys0, k, 4 + k * 13, 40);
    /* 5. ICONS over the wood chrome */
    for (int k = 0; k < 16; k++)
        rd_blit(&RD.icons, k, 244 + (k % 4) * 18, 12 + (k / 4) * 18);
    /* 6. text in each pak font */
    rd_font tiny, intr, king;
    const uint8_t lut15[4] = { 0xFF, 15, 14, 0 };   /* lut(i)=[i,i-1,black] */
    if (rd_font_open(&RD.pak, "FONTTINY.FF", &tiny))
        rd_text(&tiny, "COLOPY RENDER SELFTEST 0123456789", 4, 100, lut15);
    if (rd_font_open(&RD.pak, "FONTINTR.FF", &intr))
        rd_text(&intr, "Land Ho! What shall we call this new land?",
                4, 110, lut15);
    if (rd_font_open(&RD.pak, "FONTKING.FF", &king))
        rd_text(&king, "ABCXYZ abcxyz", 4, 130, lut15);

    FILE *o = fopen(out_path, "wb");
    if (!o) { fprintf(stderr, "render: cannot write %s\n", out_path); return 1; }
    fprintf(o, "P6\n%d %d\n255\n", RD_W, RD_H);
    for (int i = 0; i < RD_W * RD_H; i++)
        fwrite(RD.pal + RD.fb[i] * 3, 1, 3, o);
    fclose(o);
    printf("render selftest -> %s\n", out_path);
    free(pak);
    return 0;
}

/* --rendermap SAVE PAK OUT.ppm VX VY [SEL]: the Phase-7 map screen over
 * a loaded fixture.  Writes the fb as P6 plus OUT.ppm.idx (the raw 8-bit
 * index plane) so the compare tool can resolve palette-model deltas. */
int render_map_main(const char *save, const char *pak_path,
                    const char *out_path, int vx, int vy, int sel,
                    int menu, int msel, int blink) {
    if (strcmp(save, "sav1653") == 0)
        colopy_load_sav(sav1653, sizeof(sav1653));
    else if (strcmp(save, "savraleigh") == 0)
        colopy_load_sav(savraleigh, sizeof(savraleigh));
    else if (strcmp(save, "savstart") == 0)
        colopy_load_sav(savstart, sizeof(savstart));
    else
        colopy_load_sav(savnewcolony, sizeof(savnewcolony));
    colopy_init(1653);
    units_session_seed();      /* moves full + orders 0 — both harnesses pin
                                * the same session state (sim_trace RENDERMAP
                                * mirrors this) */
    long len;
    uint8_t *pak = slurp(pak_path, &len);
    if (!pak || !rd_init(pak, (uint32_t)len)) {
        fprintf(stderr, "render: bad pak\n");
        return 1;
    }
    rm_draw_map(vx, vy, sel, blink);
    if (menu >= 0) rm_draw_pulldown(menu, msel, sel);
    FILE *o = fopen(out_path, "wb");
    if (!o) return 1;
    fprintf(o, "P6\n%d %d\n255\n", RD_W, RD_H);
    for (int i = 0; i < RD_W * RD_H; i++)
        fwrite(RD.pal + RD.fb[i] * 3, 1, 3, o);
    fclose(o);
    char idx_path[512];
    snprintf(idx_path, sizeof(idx_path), "%s.idx", out_path);
    o = fopen(idx_path, "wb");
    if (o) {
        fwrite(RD.fb, 1, RD_W * RD_H, o);
        fwrite(RD.pal, 1, 768, o);
        fclose(o);
    }
    printf("render map %s -> %s\n", save, out_path);
    free(pak);
    return 0;
}

/* --rendercolony SAVE PAK OUT.ppm CI [CSEL SHIPSEL VIEW NUMBERS]:
 * the colony screen with the placement seed pinned (G.plotSeedBase =
 * 1653 in the JS RENDERCOLONY block). */
int render_colony_main(const char *save, const char *pak_path,
                       const char *out_path, int ci, int csel, int ship_sel,
                       int view, int numbers) {
    if (strcmp(save, "sav1653") == 0)
        colopy_load_sav(sav1653, sizeof(sav1653));
    else if (strcmp(save, "savraleigh") == 0)
        colopy_load_sav(savraleigh, sizeof(savraleigh));
    else
        colopy_load_sav(savnewcolony, sizeof(savnewcolony));
    colopy_init(1653);
    units_session_seed();
    long len;
    uint8_t *pak = slurp(pak_path, &len);
    if (!pak || !rd_init(pak, (uint32_t)len)) return 1;
    /* CI is the JS G.colonies ordinal — the PLAYER's colonies in sav
     * order; CS.colonies holds every power's (importSav filters). */
    int real_ci = -1, ord = -1;
    for (int k = 0; k < CS.n_colonies; k++) {
        if ((CS.colonies[k].owner_power & 3) != cs_nation()) continue;
        if (++ord == ci) { real_ci = k; break; }
    }
    if (real_ci < 0) { fprintf(stderr, "no player colony #%d\n", ci); return 1; }
    rm_draw_colony(real_ci, CR.plot_seed, csel, ship_sel, view, numbers);
    FILE *o = fopen(out_path, "wb");
    if (!o) return 1;
    fprintf(o, "P6\n%d %d\n255\n", RD_W, RD_H);
    for (int i = 0; i < RD_W * RD_H; i++)
        fwrite(RD.pal + RD.fb[i] * 3, 1, 3, o);
    fclose(o);
    char idx_path[512];
    snprintf(idx_path, sizeof(idx_path), "%s.idx", out_path);
    o = fopen(idx_path, "wb");
    if (o) {
        fwrite(RD.fb, 1, RD_W * RD_H, o);
        fwrite(RD.pal, 1, 768, o);
        fclose(o);
    }
    printf("render colony %s #%d -> %s\n", save, ci, out_path);
    free(pak);
    return 0;
}

/* --rendereurope SAVE PAK OUT.ppm [SHIP DOCKSEL ROW MARKETSEL]:
 * the Europe screen over the fixture's own harbour state. */
int render_europe_main(const char *save, const char *pak_path,
                       const char *out_path, int euro_ship, int dock_sel,
                       int euro_row, int market_sel) {
    if (strcmp(save, "sav1653") == 0)
        colopy_load_sav(sav1653, sizeof(sav1653));
    else if (strcmp(save, "savraleigh") == 0)
        colopy_load_sav(savraleigh, sizeof(savraleigh));
    else
        colopy_load_sav(savnewcolony, sizeof(savnewcolony));
    colopy_init(1653);
    units_session_seed();
    long len;
    uint8_t *pak = slurp(pak_path, &len);
    if (!pak || !rd_init(pak, (uint32_t)len)) return 1;
    rm_draw_europe(euro_ship, dock_sel, euro_row, market_sel);
    FILE *o = fopen(out_path, "wb");
    if (!o) return 1;
    fprintf(o, "P6\n%d %d\n255\n", RD_W, RD_H);
    for (int i = 0; i < RD_W * RD_H; i++)
        fwrite(RD.pal + RD.fb[i] * 3, 1, 3, o);
    fclose(o);
    char idx_path[512];
    snprintf(idx_path, sizeof(idx_path), "%s.idx", out_path);
    o = fopen(idx_path, "wb");
    if (o) {
        fwrite(RD.fb, 1, RD_W * RD_H, o);
        fwrite(RD.pal, 1, 768, o);
        fclose(o);
    }
    printf("render europe %s -> %s\n", save, out_path);
    free(pak);
    return 0;
}

/* --renderreport SAVE PAK OUT.ppm FK: an F2..F10 advisor report. */
int render_report_main(const char *save, const char *pak_path,
                       const char *out_path, const char *fk) {
    if (strcmp(save, "sav1653") == 0)
        colopy_load_sav(sav1653, sizeof(sav1653));
    else if (strcmp(save, "savraleigh") == 0)
        colopy_load_sav(savraleigh, sizeof(savraleigh));
    else
        colopy_load_sav(savnewcolony, sizeof(savnewcolony));
    colopy_init(1653);
    units_session_seed();
    long len;
    uint8_t *pak = slurp(pak_path, &len);
    if (!pak || !rd_init(pak, (uint32_t)len)) return 1;
    rm_draw_report(fk);
    FILE *o = fopen(out_path, "wb");
    if (!o) return 1;
    fprintf(o, "P6\n%d %d\n255\n", RD_W, RD_H);
    for (int i = 0; i < RD_W * RD_H; i++)
        fwrite(RD.pal + RD.fb[i] * 3, 1, 3, o);
    fclose(o);
    char idx_path[512];
    snprintf(idx_path, sizeof(idx_path), "%s.idx", out_path);
    o = fopen(idx_path, "wb");
    if (o) {
        fwrite(RD.fb, 1, RD_W * RD_H, o);
        fwrite(RD.pal, 1, 768, o);
        fclose(o);
    }
    printf("render report %s %s -> %s\n", save, fk, out_path);
    free(pak);
    return 0;
}

/* --renderwoodcut SAVE PAK OUT.ppm N: a woodcut plate. */
int render_woodcut_main(const char *save, const char *pak_path,
                        const char *out_path, int n) {
    if (strcmp(save, "sav1653") == 0)
        colopy_load_sav(sav1653, sizeof(sav1653));
    else if (strcmp(save, "savraleigh") == 0)
        colopy_load_sav(savraleigh, sizeof(savraleigh));
    else
        colopy_load_sav(savnewcolony, sizeof(savnewcolony));
    colopy_init(1653);
    units_session_seed();
    long len;
    uint8_t *pak = slurp(pak_path, &len);
    if (!pak || !rd_init(pak, (uint32_t)len)) return 1;
    rm_draw_woodcut(n);
    FILE *o = fopen(out_path, "wb");
    if (!o) return 1;
    fprintf(o, "P6\n%d %d\n255\n", RD_W, RD_H);
    for (int i = 0; i < RD_W * RD_H; i++)
        fwrite(RD.pal + RD.fb[i] * 3, 1, 3, o);
    fclose(o);
    char idx_path[512];
    snprintf(idx_path, sizeof(idx_path), "%s.idx", out_path);
    o = fopen(idx_path, "wb");
    if (o) {
        fwrite(RD.fb, 1, RD_W * RD_H, o);
        fwrite(RD.pal, 1, 768, o);
        fclose(o);
    }
    printf("render woodcut %s %d -> %s\n", save, n, out_path);
    free(pak);
    return 0;
}

/* the frame + its index plane, the way every --render* mode emits them */
static int write_frame(const char *out_path) {
    FILE *o = fopen(out_path, "wb");
    if (!o) return 0;
    fprintf(o, "P6\n%d %d\n255\n", RD_W, RD_H);
    for (int i = 0; i < RD_W * RD_H; i++)
        fwrite(RD.pal + RD.fb[i] * 3, 1, 3, o);
    fclose(o);
    char idx_path[512];
    snprintf(idx_path, sizeof(idx_path), "%s.idx", out_path);
    o = fopen(idx_path, "wb");
    if (o) {
        fwrite(RD.fb, 1, RD_W * RD_H, o);
        fwrite(RD.pal, 1, 768, o);
        fclose(o);
    }
    return 1;
}
static void load_fixture(const char *save) {
    if (strcmp(save, "sav1653") == 0)
        colopy_load_sav(sav1653, sizeof(sav1653));
    else if (strcmp(save, "savraleigh") == 0)
        colopy_load_sav(savraleigh, sizeof(savraleigh));
    else
        colopy_load_sav(savnewcolony, sizeof(savnewcolony));
    colopy_init(1653);
    units_session_seed();
}

/* --rendercongress SAVE PAK OUT.ppm MASK: the Continental Congress
 * portrait page with the owned set PINNED from a 25-bit mask (bit i =
 * @FATHERS index i), like sim_trace's rendercongress. */
int render_congress_main(const char *save, const char *pak_path,
                         const char *out_path, long mask) {
    load_fixture(save);
    CS.powers[cs_nation()].founding_fathers = (uint32_t)mask;
    long len;
    uint8_t *pak = slurp(pak_path, &len);
    if (!pak || !rd_init(pak, (uint32_t)len)) return 1;
    rm_draw_congress(-1);
    if (!write_frame(out_path)) return 1;
    printf("render congress %s %ld -> %s\n", save, mask, out_path);
    free(pak);
    return 0;
}

/* --renderdeclaration SAVE PAK OUT.ppm NAME STEP: the Declaration
 * signing page with the signer's name and the stroke step pinned. */
int render_declaration_main(const char *save, const char *pak_path,
                            const char *out_path, const char *name,
                            int step) {
    load_fixture(save);
    snprintf(CR.leader, sizeof(CR.leader), "%s", name);
    long len;
    uint8_t *pak = slurp(pak_path, &len);
    if (!pak || !rd_init(pak, (uint32_t)len)) return 1;
    rm_draw_declaration(name, step);
    if (!write_frame(out_path)) return 1;
    printf("render declaration %s '%s' %d -> %s\n", save, name, step,
           out_path);
    free(pak);
    return 0;
}

/* --renderscore SAVE PAK OUT.ppm PANEL NAME: the end-game score plate
 * with the band and the signer's name pinned (the rating is the
 * fixture's own score_parts). */
int render_score_main(const char *save, const char *pak_path,
                      const char *out_path, int panel, const char *name) {
    load_fixture(save);
    snprintf(CR.leader, sizeof(CR.leader), "%s", name);
    long len;
    uint8_t *pak = slurp(pak_path, &len);
    if (!pak || !rd_init(pak, (uint32_t)len)) return 1;
    rm_draw_score(panel);
    if (!write_frame(out_path)) return 1;
    printf("render score %s %d '%s' -> %s\n", save, panel, name, out_path);
    free(pak);
    return 0;
}

/* --renderendking SAVE PAK OUT.ppm WIN: the King's audience at the
 * war's end (1 = victory / KINGLOSE, 0 = defeat / KINGWIN). */
int render_endking_main(const char *save, const char *pak_path,
                        const char *out_path, int win) {
    load_fixture(save);
    long len;
    uint8_t *pak = slurp(pak_path, &len);
    if (!pak || !rd_init(pak, (uint32_t)len)) return 1;
    rm_draw_king_plate(win);
    if (!write_frame(out_path)) return 1;
    printf("render endking %s %d -> %s\n", save, win, out_path);
    free(pak);
    return 0;
}

/* --renderlogo PAK OUT.ppm TICK: the MicroProse boot logo at a pacer
 * tick (no sav). */
int render_logo_main(const char *pak_path, const char *out_path, int tick) {
    long len;
    uint8_t *pak = slurp(pak_path, &len);
    if (!pak || !rd_init(pak, (uint32_t)len)) return 1;
    rm_draw_mpslogo(tick);
    if (!write_frame(out_path)) return 1;
    printf("render logo %d -> %s\n", tick, out_path);
    free(pak);
    return 0;
}

/* --renderboot KIND PAK OUT.ppm ARG: a boot screen (no sav). */
int render_boot_main(const char *kind, const char *pak_path,
                     const char *out_path, int arg) {
    long len;
    uint8_t *pak = slurp(pak_path, &len);
    if (!pak || !rd_init(pak, (uint32_t)len)) return 1;
    if (strcmp(kind, "title") == 0) rm_draw_title(arg);
    else if (strcmp(kind, "difficulty") == 0) rm_draw_difficulty(arg);
    else if (strcmp(kind, "nation") == 0) rm_draw_nation(arg);
    else rm_draw_name(arg ? "Willem" : "");
    FILE *o = fopen(out_path, "wb");
    if (!o) return 1;
    fprintf(o, "P6\n%d %d\n255\n", RD_W, RD_H);
    for (int i = 0; i < RD_W * RD_H; i++)
        fwrite(RD.pal + RD.fb[i] * 3, 1, 3, o);
    fclose(o);
    char idx_path[512];
    snprintf(idx_path, sizeof(idx_path), "%s.idx", out_path);
    o = fopen(idx_path, "wb");
    if (o) {
        fwrite(RD.fb, 1, RD_W * RD_H, o);
        fwrite(RD.pal, 1, 768, o);
        fclose(o);
    }
    printf("render boot %s %d -> %s\n", kind, arg, out_path);
    free(pak);
    return 0;
}

/* --input [SAVE]: the Phase-8 keyboard oracle.  Events on stdin, one
 * per line: "K <key> <alt> <shift>".  With a SAVE the session starts on
 * the map over the loaded fixture (the JS import path); without, at the
 * title screen.  A projection JSON prints after every event. */
#include "../game/colopy_input.h"
#include "../data/colopy_data.h"
static void in_project(void) {
    int su = (UI.sel >= 0 && UI.sel < CR.n_units_order)
                 ? CR.units_order[UI.sel] : -1;
    printf("{\"s\":%d,\"mr\":%d,\"d\":%d,\"n\":%d,\"ldr\":\"%s\","
           "\"bp\":%d,\"rep\":\"%s\",\"sel\":%d,\"vx\":%d,"
           "\"vy\":%d,\"om\":%d,\"ms\":%d,\"vm\":%d,\"z\":%d,"
           "\"col\":%d,\"cv\":%d,\"mks\":%d,\"sh\":%d,"
           "\"cn\":%d,\"vr\":%d,\"cp\":%d,\"cpr\":%d,\"cs\":%d,"
           "\"em\":%d,\"emr\":%d,\"dg\":%d,\"dge\":\"%s\","
           "\"bld\":\"%s\",",
           UI.screen, UI.menu_row, UI.difficulty, UI.nation, UI.leader,
           UI.brief_page, UI.report, UI.sel, UI.view_x, UI.view_y,
           UI.open_menu, UI.menu_sel, UI.view_mode, UI.zoom,
           UI.colony, UI.colony_view, UI.market_sel, UI.show_hidden,
           UI.colony_numbers, UI.village_row,
           UI.colony_popup, UI.colony_popup_row, UI.colonist_sel,
           UI.euro_menu, UI.euro_menu_row, UI.dlg, UI.dlg_entry,
           ui_build_target_probe());
    /* the whole unit cycle's orders+moves, mirroring sim_trace's
     * `ord` — the projection field that pins WHICH units next_unit
     * is allowed to skip. */
    /* the OPEN Europe menu's row text, mirroring sim_trace's `emrows`.
     * Added 2026-08-17: `em`/`emr` pinned WHICH menu and WHICH row but
     * never what the rows SAID, so the C could serve
     * "Soldiers (buy 50 Muskets)" against the JS's "Arm with Muskets
     * (costs 600$)." for months with the oracle green. Both now read the
     * GAME.TXT sections, and this field is what keeps them there. */
    /* how many times each prompt has been asked — compared on the
     * INTERSECTION by input_compare, so a key only one engine asks (B4.6)
     * is reported rather than failed, while a shared key with different
     * counts is the real drift (G2c). */
    /* the Combat Analysis latch (sim_trace's `cb`): a modal the next key
     * dismisses — a latch only one engine holds swallows a key the other
     * acts on (2026-09-02) */
    printf("\"cb\":%d,", CR.combat.active ? 1 : 0);
    /* the selected unit's TYPE (sim_trace `ut`): two engines can agree on
     * a unit's position and moves and still hold different units there */
    printf("\"ut\":\"%s\",", su >= 0 ? dat_units[CS.units[su].type].name : "");
    printf("\"askmap\":{");
    for (int i = 0; i < ask_key_count(); i++)
        printf("%s\"%s\":%u", i ? "," : "", ask_key_name(i),
               (unsigned)ask_key_hits(i));
    printf("},");
    /* the rivals' unit and colony positions (sim_trace's `rv`): the
     * input scripts step onto rival tiles, and a list drift between the
     * engines was invisible until this field (2026-09-02) */
    printf("\"rv\":[");
    {
        int fr = 1;
        /* no rivals exist before a game starts (JS G.rivals = []) */
        for (int rn = 0; rn < (g_input_save_loaded ? 4 : 0); rn++) {
            if (rn == (int)cs_nation()) continue;
            printf("%s{\"n\":%d,\"u\":[", fr ? "" : ",", rn);
            fr = 0;
            for (int k = 0; k < CR.n_runits[rn]; k++) {
                int q = CR.runits_order[rn][k];
                printf("%s[%d,%d]", k ? "," : "", CR.runit_x[q],
                       CR.runit_y[q]);
            }
            printf("],\"c\":[");
            for (int k = 0; k < CR.rivals[rn].n_col; k++)
                printf("%s[%d,%d]", k ? "," : "", CR.rivals[rn].col[k].x,
                       CR.rivals[rn].col[k].y);
            printf("]}");
        }
    }
    printf("],");
    /* Every euro menu now, not just the two harbour ones. The scoping was
     * D12's fault: the shop menus baked "(Cost: N)" into the row string
     * here and carried it as a separate right-aligned column in the JS, so
     * the strings could never match. With the price split out into notes
     * on both sides the labels agree and all five menus are compared. */
    printf("\"emrows\":[");
    {
        char rows[24][64], notes[24][64];
        int nr = UI.euro_menu ? ui_euro_menu_rows(rows, notes, 24) : 0;
        for (int i = 0; i < nr; i++) {
            printf("%s\"", i ? "," : "");
            for (const char *q = rows[i]; *q; q++) {
                if (*q == '"' || *q == '\\') putchar('\\');
                putchar(*q);
            }
            putchar('"');
        }
        printf("],\"emnotes\":[");
        for (int i = 0; i < nr; i++) {
            printf("%s\"", i ? "," : "");
            for (const char *q = notes[i]; *q; q++) {
                if (*q == '"' || *q == '\\') putchar('\\');
                putchar(*q);
            }
            putchar('"');
        }
    }
    printf("],");
    printf("\"ord\":[");
    for (int i = 0; i < CR.n_units_order; i++) {
        int uu = CR.units_order[i];
        printf("%s[%d,%d]", i ? "," : "", CS.units[uu].orders,
               CR.unit_moves_undef[uu] ? -1 : CS.units[uu].moves_remaining);
    }
    printf("],");
    if (su >= 0)
        printf("\"u\":[%d,%d,%d,%d],", CS.units[su].map_x,
               CS.units[su].map_y, CS.units[su].orders,
               CR.unit_moves_undef[su] ? -1 : CS.units[su].moves_remaining);
    else
        printf("\"u\":null,");
    printf("\"gold\":%d,\"year\":%u}\n",
           CS.powers[cs_nation()].gold, cs_year());
}
int input_main(const char *save) {
    g_input_save_loaded = save != 0;
    ui_init();
    /* the pulldown/menubar hit-tests need the pak fonts */
    {
        long plen;
        uint8_t *pak = slurp("../pak/COLOPY.PAK", &plen);
        if (pak) rd_init(pak, (uint32_t)plen);
    }
    if (save) {
        if (strcmp(save, "sav1653") == 0)
            colopy_load_sav(sav1653, sizeof(sav1653));
        else if (strcmp(save, "savraleigh") == 0)
            colopy_load_sav(savraleigh, sizeof(savraleigh));
        else
            colopy_load_sav(savnewcolony, sizeof(savnewcolony));
        colopy_init(1653);
        units_session_seed();
        /* the TURNS-trace dock convention (sim_trace.py:465): three
         * candidates rolled from the shared stream */
        for (int d = 0; d < 3; d++) roll_immigrant(&CR.dock[d]);
        UI.screen = SCR_MAP;
        UI.nation = (int8_t)cs_nation();
        UI.difficulty = (int8_t)cs_difficulty();
        UI.colony_numbers = (int8_t)(cs_colony_numbers() ? 1 : 0);
        /* the importer's landing view/sel (game.js:10490): first LAND
         * unit selected, view centred on it */
        UI.sel = 0;
        for (int q = 0; q < CR.n_units_order; q++) {
            int ui = CR.units_order[q];
            if (dat_units[CS.units[ui].type].hull <= 0) { UI.sel = q; break; }
        }
        int cx = -1, cy = -1;
        if (CR.n_units_order) {
            int ui = CR.units_order[UI.sel];
            cx = CS.units[ui].map_x;
            cy = CS.units[ui].map_y;
        } else {
            /* no unit: the importer centres on the first player colony
             * (game.js:10492) */
            for (int q = 0; q < CS.n_colonies; q++)
                if ((CS.colonies[q].owner_power & 3) == cs_nation()) {
                    cx = CS.colonies[q].map_x;
                    cy = CS.colonies[q].map_y;
                    break;
                }
        }
        if (cx >= 0) {
            int tx = cx - 7, ty = cy - 6;
            if (tx > COLOPY_MAP_W - 15) tx = COLOPY_MAP_W - 15;
            if (ty > COLOPY_MAP_H - 12) ty = COLOPY_MAP_H - 12;
            if (tx < 0) tx = 0;
            if (ty < 0) ty = 0;
            UI.view_x = tx;
            UI.view_y = ty;
        }
    }
    char line[128];
    while (fgets(line, sizeof(line), stdin)) {
        char key[64];
        int alt = 0, shift = 0, cx, cy;
        if (sscanf(line, "C %d %d", &cx, &cy) == 2) {
            in_click(cx, cy, 0);
            in_project();
            continue;
        }
        if (sscanf(line, "K %63s %d %d", key, &alt, &shift) < 1) continue;
        if (strcmp(key, "Space") == 0) strcpy(key, " ");
        in_key(key, alt, shift);
        in_project();
    }
    return 0;
}

/* --renderevent SAVE PAK OUT.ppm KEY MODE SEL [SPEAKER]: an event popup
 * (MODE 0) or ask dialog (MODE 1) over the map screen, with the PINNED
 * substitution set the JS RENDEREVENT block mirrors. */
int render_event_main(const char *save, const char *pak_path,
                      const char *out_path, const char *key, int mode,
                      int sel, const char *speaker) {
    if (strcmp(save, "sav1653") == 0)
        colopy_load_sav(sav1653, sizeof(sav1653));
    else if (strcmp(save, "savraleigh") == 0)
        colopy_load_sav(savraleigh, sizeof(savraleigh));
    else
        colopy_load_sav(savnewcolony, sizeof(savnewcolony));
    colopy_init(1653);
    units_session_seed();
    long len;
    uint8_t *pak = slurp(pak_path, &len);
    if (!pak || !rd_init(pak, (uint32_t)len)) return 1;
    rm_draw_map(20, 30, 0, 1);
    extern int rm_event_exists(const char *key);
    if (!rm_event_exists(key)) {
        fprintf(stderr, "render: unknown event key %s\n", key);
        return 2;
    }
    rm_subs subs = { { "Jamestown", "Dutch", "Amsterdam", "Plymouth" },
                     { 42, 7, 1350, 3 }, { 1, 1, 1, 1 } };
    if (mode == 1) rm_draw_dialog_event(key, &subs, speaker, sel);
    else rm_draw_event(key, &subs, speaker);
    FILE *o = fopen(out_path, "wb");
    if (!o) return 1;
    fprintf(o, "P6\n%d %d\n255\n", RD_W, RD_H);
    for (int i = 0; i < RD_W * RD_H; i++)
        fwrite(RD.pal + RD.fb[i] * 3, 1, 3, o);
    fclose(o);
    char idx_path[512];
    snprintf(idx_path, sizeof(idx_path), "%s.idx", out_path);
    o = fopen(idx_path, "wb");
    if (o) {
        fwrite(RD.fb, 1, RD_W * RD_H, o);
        fwrite(RD.pal, 1, 768, o);
        fclose(o);
    }
    printf("render event %s %s -> %s\n", save, key, out_path);
    free(pak);
    return 0;
}
