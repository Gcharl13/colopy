/* colopy_extras.c — the .SAV SIDECAR.
 *
 * The DOS save format is fixed and this port writes it back byte-exact
 * (cport/host/main.c's roundtrip check is an oracle), so anything the
 * port models that the 1994 format has no room for cannot ride in the
 * .SAV.  Two things are in that position:
 *
 *   1. A colony BUILDING A UNIT.  The DOS colony record's
 *      `building_in_production` byte only names buildings; the port
 *      carries a unit target as its own marker 0xC0+u, which
 *      colopy_save_sav() must strip back to 0xFF (colopy_sav.c:118) or
 *      the file stops being a legal DOS save.  Without a sidecar the
 *      target is lost across save/load.
 *   2. TRADE ROUTES.  game.js keeps G.routes as pure session runtime
 *      (game.js:7713) and the .SAV has no field for them, so a saved
 *      game came back with every route gone and every assigned wagon
 *      unassigned.
 *
 * So the shells write a companion file next to the .SAV holding
 * exactly those two things.  It is OPTIONAL in both directions: a save
 * with no sidecar loads exactly as before, and the sidecar is ignored
 * unless it matches the save it was written beside (colony and unit
 * counts must agree, or it is dropped rather than misapplied).
 *
 * Nothing here is called by the parity harness — the oracles run the
 * engine, not the shells — so the format is ours to choose and it
 * changes no game behaviour.
 */
#include <string.h>

#include "colopy_core.h"
#include "colopy_records.h"
#include "colopy_sim.h"

#define CPX_MAGIC   0x31585043u        /* 'CPX1' little-endian */
#define CPX_VERSION 1

static void put32(unsigned char *p, unsigned long v) {
    p[0] = (unsigned char)(v & 0xFF);
    p[1] = (unsigned char)((v >> 8) & 0xFF);
    p[2] = (unsigned char)((v >> 16) & 0xFF);
    p[3] = (unsigned char)((v >> 24) & 0xFF);
}

static unsigned long get32(const unsigned char *p) {
    return (unsigned long)p[0] | ((unsigned long)p[1] << 8) |
           ((unsigned long)p[2] << 16) | ((unsigned long)p[3] << 24);
}

/* layout (little-endian):
 *   u32 magic, u32 version, u32 n_colonies, u32 n_units
 *   u32 n_build   then n_build * { u16 colony, u8 marker }
 *   u32 n_routes  then n_routes * { char name[26], i8 sea, i8 n_stops,
 *                                   i16 stops[4] }
 *   u32 n_assign  then n_assign * { u16 unit, i16 route, u8 stop }
 */
size_t colopy_extras_write(unsigned char *buf, size_t cap) {
    size_t o = 0;
    if (cap < 20) return 0;
    put32(buf + 0, CPX_MAGIC);
    put32(buf + 4, CPX_VERSION);
    put32(buf + 8, (unsigned long)CS.n_colonies);
    put32(buf + 12, (unsigned long)CS.n_units);
    o = 16;

    /* 1. unit-build targets the .SAV cannot carry */
    size_t nb_at = o;
    unsigned long nb = 0;
    o += 4;
    for (int i = 0; i < CS.n_colonies; i++) {
        unsigned char m = CS.colonies[i].building_in_production;
        if (m < 0xC0 || m >= 0xC7) continue;
        if (o + 3 > cap) return 0;
        buf[o++] = (unsigned char)(i & 0xFF);
        buf[o++] = (unsigned char)((i >> 8) & 0xFF);
        buf[o++] = m;
        nb++;
    }
    put32(buf + nb_at, nb);

    /* 2. the trade-route table */
    if (o + 4 > cap) return 0;
    put32(buf + o, (unsigned long)CR.n_routes);
    o += 4;
    for (int r = 0; r < CR.n_routes; r++) {
        if (o + 26 + 2 + 8 > cap) return 0;
        memcpy(buf + o, CR.routes[r].name, 26);
        o += 26;
        buf[o++] = (unsigned char)CR.routes[r].sea;
        buf[o++] = (unsigned char)CR.routes[r].n_stops;
        for (int k = 0; k < COLOPY_MAX_STOPS; k++) {
            int v = CR.routes[r].stops[k];
            buf[o++] = (unsigned char)(v & 0xFF);
            buf[o++] = (unsigned char)((v >> 8) & 0xFF);
        }
    }

    /* 3. which unit runs which route, and where it is on it */
    size_t na_at = o;
    unsigned long na = 0;
    if (o + 4 > cap) return 0;
    o += 4;
    for (int u = 0; u < CS.n_units; u++) {
        if (CR.unit_route[u] < 0) continue;
        if (o + 5 > cap) return 0;
        buf[o++] = (unsigned char)(u & 0xFF);
        buf[o++] = (unsigned char)((u >> 8) & 0xFF);
        buf[o++] = (unsigned char)(CR.unit_route[u] & 0xFF);
        buf[o++] = (unsigned char)((CR.unit_route[u] >> 8) & 0xFF);
        buf[o++] = CR.unit_stop_index[u];
        na++;
    }
    put32(buf + na_at, na);
    return o;
}

/* returns 1 when the sidecar was applied, 0 when it was ignored.
 * MUST be called after the .SAV is loaded — it validates against the
 * loaded counts and drops itself rather than write into a save it does
 * not belong to. */
int colopy_extras_read(const unsigned char *buf, size_t len) {
    size_t o = 16;
    if (len < 20) return 0;
    if (get32(buf) != CPX_MAGIC || get32(buf + 4) != CPX_VERSION) return 0;
    if ((int)get32(buf + 8) != CS.n_colonies ||
        (int)get32(buf + 12) != CS.n_units)
        return 0;

    if (o + 4 > len) return 0;
    unsigned long nb = get32(buf + o);
    o += 4;
    if (nb > (unsigned long)CS.n_colonies || o + nb * 3 > len) return 0;
    for (unsigned long i = 0; i < nb; i++) {
        int ci = buf[o] | (buf[o + 1] << 8);
        unsigned char m = buf[o + 2];
        o += 3;
        if (ci >= 0 && ci < CS.n_colonies && m >= 0xC0 && m < 0xC7)
            CS.colonies[ci].building_in_production = m;
    }

    if (o + 4 > len) return 0;
    unsigned long nr = get32(buf + o);
    o += 4;
    if (nr > COLOPY_MAX_ROUTES || o + nr * 36 > len) return 0;
    CR.n_routes = (signed char)nr;
    for (unsigned long r = 0; r < nr; r++) {
        memcpy(CR.routes[r].name, buf + o, 26);
        CR.routes[r].name[25] = 0;
        o += 26;
        CR.routes[r].sea = (signed char)buf[o++];
        CR.routes[r].n_stops = (signed char)buf[o++];
        if (CR.routes[r].n_stops < 0 ||
            CR.routes[r].n_stops > COLOPY_MAX_STOPS)
            CR.routes[r].n_stops = 0;
        for (int k = 0; k < COLOPY_MAX_STOPS; k++) {
            CR.routes[r].stops[k] = (short)(buf[o] | (buf[o + 1] << 8));
            o += 2;
        }
    }

    if (o + 4 > len) return 0;
    unsigned long na = get32(buf + o);
    o += 4;
    if (o + na * 5 > len) return 0;
    for (unsigned long i = 0; i < na; i++) {
        int ui = buf[o] | (buf[o + 1] << 8);
        short rt = (short)(buf[o + 2] | (buf[o + 3] << 8));
        unsigned char si = buf[o + 4];
        o += 5;
        if (ui < 0 || ui >= CS.n_units) continue;
        if (rt < 0 || rt >= CR.n_routes) continue;
        CR.unit_route[ui] = rt;
        CR.unit_stop_index[ui] = si;
    }
    return 1;
}
