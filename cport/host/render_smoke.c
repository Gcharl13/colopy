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
                    int menu, int msel) {
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
    rm_draw_map(vx, vy, sel, 1);
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
    rm_draw_colony(real_ci, 1653u, csel, ship_sel, view, numbers);
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
