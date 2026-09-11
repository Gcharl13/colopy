/* The New World builder — func_064A10 @0x064A10..0x065D07, read WHOLE on
 * 2026-09-09 (RULINGS 2026-09-09d) and ported pass for pass, draw for
 * draw on the SHARED random stream (every `lcall 0x181F:0x4D4` below is
 * the sim's random_int on [0x28EE]; the salt draw @0x064A16 is the first
 * of them and colopy_newgame.c already takes it).  This replaces the
 * 2026-09-09c reconstruction.
 *
 * Layers (the descriptor quads the code pushes): [0x85A8] = the terrain
 * plane [0x15C] (CS.terrain); [0x85B0] = plane 2 [0x160] (CS.improve),
 * used as the ELEVATION scratch until P6a wipes it; [0x85C0] = plane 4
 * [0x168] (CS.fog), the walkers' stamp scratch and the river pass's
 * backup copy; [0x85B8] = plane 3 (CS.region), written by the landmass
 * labeller func_063880 (0x1A1F:0x7DC) — colopy_newgame.c's
 * build_regions is this tree's port of that labeller.
 *
 * Helpers, all read: stamp func_064154; walkers func_0641EC (diagonal,
 * 2x2 stamps), func_064266 (diagonal, stamps + four 1-in-4 extra stamps),
 * func_06436C (cardinal, single tiles); grower func_0643F8; flatten test
 * func_064534; rivers func_0645F6; the primitives 0x181F:0x302 in-bounds
 * (1..w-2, 1..h-2), 0x768 is-water (base 0x19 / 0x1A), 0x78C base id,
 * 0x718 = map_detail_id, 0x68C = OR a bit into plane 2, 0xBA filled band,
 * 0xCE hollow rectangle, 0x484 layer fill.  Direction tables DS:0xB4/0xBE
 * (8-ring N,NE,E,SE,S,SW,W,NW then two zero pads), DS:0xA8/0xAE (N,E,S,W),
 * DS:0xC8/0xDE (the 20-cell kernel).  Switch tables (overlay cs base
 * 0x64150): cs:0xBAC latitude band -> base {5,4,1,3,2,2}; cs:0xEFE the
 * east-west moisture ladder; cs:0x11CE the relaxation ladder.
 *
 * DOS CAPTURE ORACLE (2026-09-10, tools/dos_world_capture.py +
 * tools/dos_world_oracle.py): two worlds the original built under DOSBox
 * (a NEW WORLD with words [1,3,0,0,3] and a CUSTOMIZE with [1,1,1,1,1]) are
 * reproduced by this port BYTE FOR BYTE -- terrain, the plane-2 bits, the
 * landmass labels -- from the 15-bit clock seed the salt [0x190] pins.
 * Three port faults it found and the bytes confirmed: the P1 landmass
 * count is the LAND class's size table (counting the ocean's id drew one
 * island too few); the relaxation ladder's cases 4/5 jump PAST the
 * `or 0x80` (@0x0652B5 -> 0x65198: elevation 1, no mountain bit); the
 * P4b coast scan starts on column w-1 (@0x065736), where a polar arctic
 * dot counts as the coast.
 *
 * FLAGGED (named, small): (1) the relaxation tail's hill/mountain rolls
 * read two locals ([bp-0x20]/[bp-0x26]) that only the flat path sets --
 * an ocean visit zeroes them first (@0x0651BA), so only a MOUNTAIN or
 * HILLS visit before the first non-elevated visit reads the residue,
 * which is stack content of the pre-builder calls (non-zero: a return
 * IP, a saved BP, the band-fill offset), so the original draws
 * random_int(0, residue) once per such leading visit -- modelled as no
 * roll; neither captured world reached it.  (3) Out-of-plane kernel reads
 * in the river pass (a source on row 1 or h-2) are skipped; the original
 * reads, and on a head writes, past the plane through the unchecked
 * far-address helper 0xA4E:0x8 (row 1 wraps 64 KB up; row h-2 runs into
 * the block's slack / the next block).  Closed: (2) the P1 landmass count
 * is the land class's size table (landmass_count); (4) the two
 * [0x2174]-gated 0xA0 writes DO apply on the AMERICA path (P6d).  The
 * premade path's plane-2 bits and start squares are diffed against
 * savstart (1309/1309 western-sea tiles, the H/5-band starts). */
#include <string.h>

#include "colopy_core.h"
#include "colopy_sim.h"
#include "colopy_state.h"

#define W COLOPY_MAP_W
#define H COLOPY_MAP_H
#define OCEAN  0x19
#define LANE   0x1A
#define ARCTIC 0x18

/* DS:0xB4 / DS:0xBE — the 8-ring plus the two zero pads the relaxation
 * pass's random_int(0,8) can index */
static const int8_t DX8[10] = { 0, 1, 1, 1, 0, -1, -1, -1, 0, 0 };
static const int8_t DY8[10] = { -1, -1, 0, 1, 1, 1, 0, -1, 0, 0 };
/* DS:0xA8 / DS:0xAE — N, E, S, W */
static const int8_t DX4[4] = { 0, 1, 0, -1 };
static const int8_t DY4[4] = { -1, 0, 1, 0 };
/* DS:0xC8 / DS:0xDE — the 20-cell kernel */
static const int8_t KX[20] = { 0, 1, 0,-1,-1, 1, 1,-1, 0, 2, 0,-2,-1, 1,-1, 1,-2,-2, 2, 2 };
static const int8_t KY[20] = {-1, 0, 1, 0,-1,-1, 1, 1,-2, 0, 2, 0,-2,-2, 2, 2,-1, 1,-1, 1 };

/* the walker bounds [0x2D1E..0x2D21] and the stamp count [0x2D22] */
static int g_xmin, g_xmax, g_ymin, g_ymax, g_count;

static uint8_t *T = CS.terrain, *E = CS.improve, *F = CS.fog;
#define AT(L, x, y) ((L)[(y) * W + (x)])

static int in_bounds(int x, int y) {               /* func_005BFA */
    return x >= 1 && y >= 1 && x <= W - 2 && y <= H - 2;
}
static int is_water(int x, int y) {                /* func_0062B4 */
    int b = AT(T, x, y) & 0x1F;
    return b == OCEAN || b == LANE;
}
static int r(int lo, int hi) { return (int)rng_range(lo, hi); }
/* 0x181F:0x78C = func_00627A -> func_00624E: the CLASS id, so a hills or
 * mountains square answers 28 / 27 and never carries the high bits */
static int cls(int x, int y) {
    int v = AT(T, x, y);
    if (v & 0x20) return (v & 0x80) ? 27 : 28;
    return v & 0x1F;
}

/* func_064154: a 2x2-ish stamp into the scratch plane */
static void stamp(int x, int y) {
    if (x == 0 || y == 0 || x >= W || y >= H) return;
    AT(F, x, y) = 1;
    if (x < W - 1) AT(F, x + 1, y) = 1;
    if (y < H - 1) AT(F, x, y + 1) = 1;
}
static int walker_in(int x, int y) {
    return g_xmin < x && x < g_xmax && g_ymin < y && y < g_ymax;
}
/* func_0641EC: 2+random_int(1,0x40) diagonal steps, stamping */
static void walker1(int x, int y) {
    int n = r(1, 0x40) + 2;
    while (n-- > 0) {
        if (!walker_in(x, y)) break;
        stamp(x, y);
        int d = 2 * r(1, 4) - 1;                  /* NE, SE, SW, NW */
        x += DX8[d]; y += DY8[d];
    }
}
/* func_064266: 2+random_int(1,0x30) diagonal steps, stamping, with four
 * independent 1-in-4 diagonal side stamps per step */
static void walker2(int x, int y) {
    int n = r(1, 0x30) + 2;
    while (n-- > 0) {
        if (!walker_in(x, y)) break;
        stamp(x, y);
        if (r(1, 4) == 1) stamp(x + 1, y + 1);
        if (r(1, 4) == 1) stamp(x - 1, y + 1);
        if (r(1, 4) == 1) stamp(x + 1, y - 1);
        if (r(1, 4) == 1) stamp(x - 1, y - 1);
        int d = 2 * r(1, 4) - 1;
        x += DX8[d]; y += DY8[d];
    }
}
/* func_06436C: 2+random_int(1,16) cardinal steps, single tiles */
static void walker3(int x, int y) {
    int n = r(1, 0x10) + 2;
    while (n-- > 0) {
        if (!walker_in(x, y)) break;
        AT(F, x, y) = 1;
        int d = 2 * (r(1, 4) - 1);                /* N, E, S, W */
        x += DX8[d]; y += DY8[d];
    }
}
/* func_0643F8: one landmass (island != 0: a small one on open water),
 * merged into the elevation plane; every stamped tile counts */
static void grow(int island, int land_form) {
    memset(F, 0, COLOPY_PLANE);
    int x, y;
    for (;;) {
        x = r(1, W - 16) + 7;
        y = r(1, H - 8) + 3;
        if (!island || AT(E, x, y) == 0) break;
    }
    if (island) {
        int k = r(1, 10);
        walker3(x, y);
        if (k >= 7) walker3(x, y);
        if (k >= 8) walker3(x, y);
    } else if (land_form >= 2) {
        walker2(x, y);
    } else {
        walker1(x, y);
    }
    for (int i = 0; i < COLOPY_PLANE; i++)
        if (F[i]) { E[i]++; g_count++; }
}
/* func_064534: a mountain with all four diagonal neighbours on land
 * loses its elevation (the transient 0x19 write is overwritten by the
 * caller's write-back; the diagonal test is on the whole byte) */
static int flatten(int x, int y) {
    if (!in_bounds(x, y)) return 0;
    if (AT(T, x - 1, y - 1) == OCEAN || AT(T, x - 1, y + 1) == OCEAN ||
        AT(T, x + 1, y - 1) == OCEAN || AT(T, x + 1, y + 1) == OCEAN)
        return 0;
    AT(T, x, y) = OCEAN;
    return 1;
}
/* func_008352: any of the 8 in-bounds neighbours is water */
static int coast(int x, int y) {
    for (int k = 0; k < 8; k++) {
        int nx = x + DX8[k], ny = y + DY8[k];
        if (in_bounds(nx, ny) && is_water(nx, ny)) return 1;
    }
    return 0;
}
/* the P1 count @0x064AC4..@0x064AE4: the non-zero entries of the 16-word
 * size table [0x85C8] the labeller copies out (@0x063BAC), which is the
 * LAND class's -- the number of land-class ids 1..15 present.  (Counting
 * every id, water bodies included, gave 1 at P1 -- when the terrain plane
 * is still all ocean and the ocean is id 1 -- so the port drew one island
 * fewer than the original: the DOS capture oracle found the missing blob
 * on both worlds it saw, 2026-09-10.) */
static int landmass_count(void) {
    int seen[16] = {0}, n = 0;
    for (int i = 0; i < COLOPY_PLANE; i++)
        if (!tile_water(CS.terrain[i])) seen[CS.region[i] & 0x0F] = 1;
    for (int k = 1; k < 16; k++) n += seen[k];
    return n;
}
/* 0x181F:0xCE — hollow rectangle */
static void hollow(int x0, int y0, int x1, int y1, uint8_t v) {
    for (int x = x0; x <= x1; x++) { AT(T, x, y0) = v; AT(T, x, y1) = v; }
    for (int y = y0; y <= y1; y++) { AT(T, x0, y) = v; AT(T, x1, y) = v; }
}
/* 0x181F:0xBA — filled band */
static void band(int x0, int y0, int w, uint8_t v, int rows) {
    for (int y = y0; y < y0 + rows; y++)
        for (int x = x0; x < x0 + w; x++) AT(T, x, y) = v;
}

/* func_0645F6 — rivers */
static void rivers(int climate, int land_mass) {
    int attempts = 0, made = 0;
    do {
        memcpy(F, T, COLOPY_PLANE);                 /* backup @0x064616 */
        attempts++;
        int steps = 0, x, y, v;
        for (;;) {
            x = r(1, W - 2);
            y = r(1, H - 2);
            v = AT(F, x, y);
            if (v & 0x20) continue;
            if (is_water(x, y)) continue;
            break;
        }
        int sx = x, sy = y;
        int dir = 2 * r(0, 3);
        int turn = r(0, 1);
        int reached = 0, lx = x, ly = y;
        for (;;) {
            AT(T, x, y) = (uint8_t)(v | 0x40);
            steps++;
            for (int k = 0; k < 4 && !reached; k++) {
                int nx = x + DX4[k], ny = y + DY4[k];
                if (!is_water(nx, ny) && !(AT(F, nx, ny) & 0x40)) continue;
                reached = 1;
                AT(T, nx, ny) = (uint8_t)(AT(T, nx, ny) | 0x40);
                lx = x; ly = y;
            }
            int roll = r(0, 0x63), nd;
            if (roll < 0x3C) nd = dir;
            else {
                if (roll > 0x5F) turn = !turn;
                nd = turn ? (dir + 2) % 8 : (dir + 6) % 8;
                turn = !turn;
            }
            dir = nd;
            y += DY8[dir]; x += DX8[dir];
            v = AT(F, x, y);
            if (reached) break;
            if (in_bounds(x, y) && !(v & 0x40) && !(v & 0x20)) continue;
            break;
        }
        if (!reached && !(v & 0x40)) { memcpy(T, F, COLOPY_PLANE); continue; }
        if (steps < 3)              { memcpy(T, F, COLOPY_PLANE); continue; }
        made++;
        if (reached && r(1, 2 * (climate + 6)) > 6) {
            int n = r(1, 2 * climate + 3);
            int cx = lx, cy = ly;
            for (;;) {
                AT(T, cx, cy) = (uint8_t)(AT(T, cx, cy) | 0x80);
                int found = -1;
                for (int k = 0; k < 4 && found < 0; k++) {
                    int nx = cx + DX4[k], ny = cy + DY4[k];
                    int tv = AT(T, nx, ny);
                    if ((tv & 0x40) && !(tv & 0x80)) { found = k; cx = nx; cy = ny; }
                }
                if (--n <= 0 || found < 0) break;
            }
        }
        for (int k = 0; k < 20; k++) {
            int nx = sx + KX[k], ny = sy + KY[k];
            int idx = ny * W + nx;                  /* the engine's linear index */
            if (idx < 0 || idx >= COLOPY_PLANE) continue;   /* FLAGGED (3) */
            int tv = T[idx];
            if ((tv & 0x1F) >= 0x10) continue;
            if (r(0, 1) != 0) T[idx] = (uint8_t)(tv + 8);
        }
    } while (attempts < 0x200 && (climate + land_mass + 2) * 8 > made);
}


#if COLOPY_ORACLE
#include <stdio.h>
#include <stdlib.h>
/* COLOPY_MAPGEN_DUMP=prefix: the terrain plane after each pass, for the
 * DOS capture oracle's pass-by-pass triage (tools/dos_world_oracle.py) */
static void mg_dump(const char *tag) {
    const char *pre = getenv("COLOPY_MAPGEN_DUMP");
    if (!pre) return;
    char path[512];
    snprintf(path, sizeof(path), "%s_%s.bin", pre, tag);
    FILE *f = fopen(path, "wb");
    if (!f) return;
    fwrite(CS.terrain, 1, COLOPY_PLANE, f);
    fwrite(CS.improve, 1, COLOPY_PLANE, f);
    fclose(f);
}
#define MG_DUMP(tag) mg_dump(tag)
#else
#define MG_DUMP(tag) ((void)0)
#endif

colopy_status colopy_generate_world(const colopy_world_options *world,
                                    int premade, uint8_t starts[4][2]) {
    static const uint8_t BAND_BASE[6] = { 5, 4, 1, 3, 2, 2 };   /* cs:0xBAC */
    if (!world || !starts) return COLOPY_ERR_BAD_COMMAND;
    int p0 = world->land_mass, p1 = world->land_form,
        p2 = world->temperature, p3 = world->climate;
    int p4 = world->iterations;                     /* [0x1E86] */
    int north = 0;
    /* the title dispatcher draws each word as random_int(0, 3) for NEW
     * WORLD / AMERICA (@0x075C8E..@0x075CA0), so 3 is a legal value */
    if (p0 > 3 || p1 > 3 || p2 > 3 || p3 > 3 || p4 > 3) return COLOPY_ERR_BAD_COMMAND;

    if (!premade) {
        /* P0 @0x064A35 */
        memset(T, OCEAN, COLOPY_PLANE);
        memset(E, 0, COLOPY_PLANE);
        g_xmin = 3; g_xmax = W - 6; g_ymin = 0; g_ymax = H;
        north = r(0, 1);
        if (north) g_ymin = 5; else g_ymax = H - 6;
        /* P1 @0x064AA4: grow to the land target, then islands */
        g_count = 0;
        do grow(0, p1); while ((p1 + p0 + 1) * 0x140 > g_count);
        colopy_build_regions();
        int islands = 15 - landmass_count();
        if (islands > 0 && p1 > 0) islands -= r(0, islands);
        for (int i = 0; i < islands; i++) grow(1, p1);
        /* P1b @0x064B28: the diagonal-gap fill on the elevation plane */
        {
            int y = 1;
            while (y < H - 1) {
                int x = 1;
                while (x < W - 1) {
                    int bits = (AT(E, x, y) != 0) | ((AT(E, x + 1, y) != 0) << 1) |
                               ((AT(E, x, y + 1) != 0) << 2) |
                               ((AT(E, x + 1, y + 1) != 0) << 3);
                    if (bits == 6 || bits == 9) {
                        AT(E, x + 1, y) = 1; AT(E, x, y + 1) = 1; AT(E, x + 1, y + 1) = 1;
                        if (x) x--;
                        if (y) y--;
                    }
                    x++;
                }
                y++;
            }
        }
        MG_DUMP("p1");
        /* P2 @0x064C6E: latitude bands -> base terrain, elevation -> bits */
        for (int y = 0; y < H; y++)
            for (int x = 0; x < W; x++) {
                int m = AT(E, x, y);
                int c = H / 2 - r(1, 16) - y + 8, b;
                if (c > 0) b = H / 2 - r(1, 16) - y + 8;
                else       b = -(H / 2 - r(1, 16) - y + 8);
                b += 2 * (1 - p2);
                if (b < 0) b = 0;
                b >>= 2;
                int t = b > 5 ? 0 : BAND_BASE[b];
                if (m == 0) t = OCEAN;
                if (m >= 2) t |= 0x20;
                if (m >= 3) t |= 0x80;
                AT(T, x, y) = (uint8_t)t;
            }
        MG_DUMP("p2");
        /* P2b @0x064DCC: the moisture sweeps, west->east then east->west */
        for (int y = 0; y < H; y++) {
            int dist = H / 2 - y; if (dist < 0) dist = -dist;
            int a = H / 4 - dist; if (a <= 0) a = -a;
            int cnt = r(0, a + 4 * p3);
            for (int x = 0; x < W; x++) {
                int v = AT(T, x, y), base = v & 0x1F;
                if (v == OCEAN) {
                    int cap = H / 4 - dist; if (cap <= 0) cap = -cap;
                    if (cap + 4 * p3 > cnt) cnt++;
                    continue;
                }
                if (v & 0x80) cnt -= 3;
                else if (v & 0x20) v &= 0x5F;
                else if (cnt < 0) {
                    switch (base) {
                    case 0: AT(E, x, y) = 2; break;
                    case 2: base = 0; break;
                    case 3: if (r(0, cnt > 0 ? cnt : -cnt) != 0) base = 1;
                            else { base = 2; cnt--; }
                            break;
                    case 4: base = 3; break;
                    default: break;
                    }
                } else if (cnt > 0) {
                    switch (base) {
                    case 0: base = 2; break;
                    case 2: base = 3; break;
                    case 3: base = 4; break;
                    case 4: cnt -= 2; if (r(0, 3) == 0) base = 6; break;
                    case 5: cnt -= 2; if (r(0, 3) == 0) base = 7; break;
                    default: break;
                    }
                }
                if (cnt > 0) cnt -= r(1, 7 - 2 * p3);
                else if (cnt < 0) cnt++;
                AT(T, x, y) = (uint8_t)((v & 0xE0) | base);
            }
            cnt = 0;
            for (int x = W - 1; x >= 0; x--) {
                int v = AT(T, x, y), base = v & 0x1F;
                if (v == OCEAN) {
                    if ((dist >> 1) + p3 > cnt) cnt++;
                    continue;
                }
                if (v & 0x80) cnt -= 3;
                else if (v & 0x20) v &= 0x5F;
                else if (cnt > 0 && base <= 5) {
                    switch (base) {                 /* cs:0xEFE */
                    case 0: base = 2; break;
                    case 1: base = 3; break;
                    case 2: base = 3; break;
                    case 3: base = 4; break;
                    case 4: cnt -= 2; if (r(0, 1) == 0) base = 6; break;
                    case 5: cnt -= 2; base = 7; break;
                    }
                }
                if (cnt > 0) cnt -= r(1, 7 - 2 * p3);
                else if (cnt < 0) cnt++;
                AT(T, x, y) = (uint8_t)((v & 0xE0) | base);
            }
        }
        MG_DUMP("p2b");
        /* P3 @0x065114: relaxation, (p4+1)*0x320 visits */
        {
            int x = 0, y = 0, p20 = 0, p26 = 0;    /* FLAGGED (1) */
            for (int it = 0; (p4 + 1) * 0x320 > it; it++) {
                if (it & 1) {
                    int d = r(0, 8);
                    x += DX8[d]; y += DY8[d];
                } else {
                    x = r(1, W - 2);
                    y = r(1, H - 2);
                }
                int v = AT(T, x, y), base = v & 0x1F;
                if (v & 0x80) {
                    if (flatten(x, y)) v &= 0x5F;
                } else if (v & 0x20) {
                    v |= 0x80;
                    AT(E, x, y) = 1;
                } else {
                    p20 = 0; p26 = 0;               /* @0x0651BA, every non-elevated visit */
                    if (base <= 7) switch (base) {  /* cs:0x11CE */
                    case 0: p20 = 1; p26 = 0; if (r(0, 1) == 0) base = 2; break;
                    case 1: p20 = 1; p26 = 1; if (r(0, 1) == 0) base = 3; break;
                    case 2: case 3:
                        if (base == 3 && r(0, 2) == 0) base = 2;
                        p26 = 2; p20 = 2;
                        if (r(0, 1) == 0) AT(E, x, y) = 2;
                        break;
                    case 4: p20 = 3; p26 = 1;
                        if (r(0, 1) == 0) base = 6;
                        if (r(0, 1) == 0) AT(E, x, y) = 1;   /* -> @0x65198, past the or 0x80 */
                        break;
                    case 5: p20 = 3; p26 = 2;
                        if (r(0, 1) == 0) base = 7;
                        if (r(0, 1) == 0) AT(E, x, y) = 1;   /* -> @0x65198, past the or 0x80 */
                        break;
                    case 6: p20 = 5; p26 = 3;
                        if (r(0, 1) == 0) base = 4;
                        if (r(0, 1) == 0) AT(E, x, y) = 2;
                        break;
                    case 7: p20 = 5; p26 = 3;
                        if (r(0, 1) != 0) base = 5;
                        if (r(0, 1) != 0) AT(E, x, y) = 2;
                        break;
                    }
                }
                /* the shared tail @0x06532E -- runs for every visit: with p20
                 * != 0 (`cmp [bp-0x20],0; je` @0x06532E -- the bytes sit right
                 * after the cs:0x11CE jump table, where the listing mis-decodes
                 * them) it rolls random_int(0, p20) for hills, then with p26 != 0
                 * random_int(0, p26) for a mountain (@0x065349); a hills /
                 * mountain visit rolls with the PREVIOUS flat visit's p20/p26
                 * (FLAGGED (1): before any flat visit they are stack garbage,
                 * modelled as 0) */
                if (p20 != 0 && r(0, p20) == 0) {
                    v |= 0x20;
                    if (p26 != 0 && r(0, p26) == 0) v |= 0x80;
                }
                AT(T, x, y) = (uint8_t)((v & 0xE0) | base);
            }
        }
        MG_DUMP("p3");
        /* P3b @0x0653C8: forest */
        for (int y = 0; y < H; y++)
            for (int x = 0; x < W; x++) {
                int v = AT(T, x, y);
                if (v == OCEAN) continue;
                if (AT(E, x, y) == 1) {
                    v += r(0, 8) == 0 ? 8 : 0x10;
                } else if (coast(x, y)) {
                    if (r(0, 1) == 0) v += 8;
                    else if (r(0, 4) != 0) v += 0x10;
                }
                AT(T, x, y) = (uint8_t)v;
            }
        MG_DUMP("p3b");
        /* P3c @0x0654BA */
        rivers(p3, p0);
        MG_DUMP("p3c");
        /* P3d: the pole band the walkers were kept out of, the ocean ring
         * at columns 2 / w-3, forty scattered Arctic tiles on rows 1 / h-2 */
        band(0, north ? 0 : H - 4, W, OCEAN, 4);
        hollow(2, 0, W - 3, H - 1, OCEAN);
        for (int k = 0; k < 0x28; k++) {
            AT(T, r(1, W) - 1, 1) = ARCTIC;
            AT(T, r(1, W) - 1, H - 2) = ARCTIC;
        }
        MG_DUMP("p3d");
        /* P4a @0x065590: the east sea lane, west to the first coast */
        for (int y = 1; y < H - 1; y++)
            for (int x = W - 1; x >= W / 2; x--) {
                if (!is_water(x, y)) break;
                AT(T, x, y) = (uint8_t)((AT(T, x, y) & 0xE0) | LANE);
            }
        /* P4b @0x06562A: water within three columns east of a coast, in the
         * seven rows around it, goes back to ocean */
        for (int y = 1; y < H - 1; y++) {
            int cx = -1;
            /* the scan starts on the LAST column (@0x065736: x = w-1), where
             * a P3d arctic dot on row 1 counts as the coast -- the DOS capture
             * oracle (2026-09-10) caught the port starting at w-2 */
            for (int x = W - 1; x >= 1 && cx < 0; x--)
                if (!is_water(x, y)) cx = x;
            if (cx < 0) continue;
            int x = cx + 3; if (x > W - 2) x = W - 2;
            for (int yy = y - 3; yy <= y + 3; yy++) {   /* x carries over @0x06568F */
                if (!in_bounds(x, yy)) continue;
                while (!is_water(x, yy) && x < W - 2) x++;
                if (!is_water(x, yy)) continue;
                AT(T, x, yy) = (uint8_t)((AT(T, x, yy) & 0xE0) | OCEAN);
            }
        }
        /* P4c @0x06573C: west of the lane run, every water tile is ocean */
        for (int y = 1; y < H - 1; y++) {
            int in_lane = 1;
            for (int x = W - 2; x >= 1; x--) {
                if (in_lane) {
                    if ((AT(T, x, y) & 0x1F) == LANE) continue;
                    in_lane = 0;                    /* @0x0657CD: this square is skipped */
                    continue;
                }
                if (is_water(x, y))
                    AT(T, x, y) = (uint8_t)((AT(T, x, y) & 0xE0) | OCEAN);
            }
        }
        /* P4d @0x0657F4: the polar rows, bottom then top */
        for (int pass = 0; pass < 2; pass++)
            for (int x = 0; x < W; x++) {
                int y = pass ? 1 : H - 2;
                if (!is_water(x, y)) AT(T, x, y) = ARCTIC;
                /* rows 2 / h-3 and 3 / h-4: the value rewritten is the CLASS
                 * id (0x181F:0x78C) & 0xE0 = 0 with the pole bits or'd in, so
                 * elevation and forest are dropped along with the base */
                y = pass ? 2 : H - 3;
                if (!is_water(x, y))
                    AT(T, x, y) = (uint8_t)(r(0, 1) == 1 ? ARCTIC : 0);
                y = pass ? 3 : H - 4;
                if (r(0, 1) != 0 && !is_water(x, y))
                    AT(T, x, y) = 0;
            }
    }

    MG_DUMP("p4");
    /* P5 @0x065941 (both paths): the outline, then the fold */
    hollow(0, 0, W - 1, H - 1, LANE);
    hollow(1, 0, W - 2, H - 1, LANE);
    band(0, 0, W, ARCTIC, 1);
    band(0, H - 1, W, ARCTIC, 1);
    for (int x = 0; x < W; x++)
        for (int y = 0; y < H; y++) {
            int v = AT(T, x, y), base = v & 0x1F;
            if (base >= 0x18) continue;
            if (v & 0x20) AT(T, x, y) = (uint8_t)((v & 0xE0) | (base & 7));
            else if (base >= 16) AT(T, x, y) = (uint8_t)(v - 8);
        }
    MG_DUMP("p5");
    /* P6a @0x065AA0: landmasses, then planes 2 and 4 wiped */
    colopy_build_regions();
    memset(E, 0, COLOPY_PLANE);
    memset(F, 0, COLOPY_PLANE);
    /* P6b @0x065AD3: the western sea, row by row up to the first coast */
    {
        int limit = premade ? W - 16 : W / 2;
        for (int y = 1; y < H - 1; y++)
            for (int x = 1; x < limit && is_water(x, y); x++)
                AT(E, x, y) |= 0x20;
    }
    /* P6c @0x065B32: offshore detail tiles with no land in the kernel */
    for (int y = 0; y < H; y++)
        for (int x = 0; x < W; x++) {
            if (!is_water(x, y)) continue;
            if (map_detail_id(x, y, AT(T, x, y)) == -1) continue;
            int land = 0;
            for (int k = 0; k < 20 && !land; k++) {
                int nx = x + KX[k], ny = y + KY[k];
                if (in_bounds(nx, ny) && !is_water(nx, ny)) land = 1;
            }
            if (!land) AT(E, x, y) |= 4;
        }
    /* P6d @0x065BF0..@0x065C21: on the premade path, with the custom-map
     * flag [0x2174] clear (its only writer is the Map Editor's MAPTOLOAD
     * picker @0x075D36, so every normal AMERICA game sees 0), OR 0xA0
     * (mountains) into T(21,1) and T(43,68) -- func_005CE6 takes x first
     * (push 1; push 0x15 = (x 21, y 1); push 0x44; push 0x2B = (43, 68)).
     * AMER2.MP holds 0x00 at both, every AMERICA fixture 0xA0 (the earlier
     * "not applied" FLAG had read the transposed square). */
    if (premade) {
        AT(T, 21, 1) |= 0xA0;
        AT(T, 43, 68) |= 0xA0;
    }
    /* P6e @0x065C25: the four H/5 bands, dealt to the powers at random
     * starting from the human; the start is the first Sea Lane square
     * east of the band's coast */
    {
        int8_t slot[4] = { -1, -1, -1, -1 };
        int human = cs_nation();
        for (int i = 0; i < 4; i++) {
            int nation = (i + human) % 4;
            for (;;) {
                int s = (i == 0 && !premade) ? r(1, 2) : r(0, 3);
                if (slot[s] < 0) { slot[s] = (int8_t)nation; break; }
            }
        }
        for (int si = 0; si < 4; si++) {
            int y = (H / 5) * (si + 1), x = W - 2;
            while (x > 2 && cls(x, y) == LANE) x--;
            x++;
            starts[slot[si]][0] = (uint8_t)x;
            starts[slot[si]][1] = (uint8_t)y;
        }
    }
    return COLOPY_OK;
}
