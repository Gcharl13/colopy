// sim/trade_routes.cpp -- see trade_routes.hpp.
#include "trade_routes.hpp"
#include "market.hpp"
#include "unit.hpp"

namespace vc::sim {

namespace {

// A hold that can accept `good`: a same-good partial hold first, else an empty
// one. capacity = @UNIT cargo (hold count); -1 = no room.
int accept_hold(const Unit& u, int capacity, int good) {
    if (capacity > 6) capacity = 6;
    for (int h = 0; h < capacity; ++h)
        if (u.hold_good[h] == good && u.hold_qty[h] < 100) return h;
    for (int h = 0; h < capacity; ++h)
        if (u.hold_good[h] < 0) return h;
    return -1;
}

} // namespace

void trade_route_step(GameState& g, World& w, int unit_idx, const RuleData& rd) {
    Unit& u = w.units[unit_idx];
    // func_041080 re-checks the binding (@0x041089) and clears a broken order.
    if (u.route < 0 || u.route >= (int)g.routes.size()) {
        u.order = ORDER_NONE; u.route = -1; return;
    }
    const TradeRoute& r = g.routes[u.route];
    const int nstops = (int)r.stops.size();
    if (nstops == 0) { u.order = ORDER_NONE; return; }
    if (u.route_stop < 0 || u.route_stop >= nstops) u.route_stop = 0;
    // Skip "none" entries (dest 0x3E8) to the next defined stop.
    for (int guard = 0; r.stops[u.route_stop].dest == ROUTE_DEST_NONE && guard < nstops; ++guard)
        u.route_stop = (u.route_stop + 1) % nstops;
    if (r.stops[u.route_stop].dest == ROUTE_DEST_NONE) { u.order = ORDER_NONE; return; }
    const TradeStop& st = r.stops[u.route_stop];

    // Arrival test (@0x41034): Europe -> the Sea Lane (the EXE compares against
    // its map's sea-lane column; here: standing on a Sea Lane tile, id 26);
    // a colony -> its exact (X,Y).
    bool arrived = false;
    if (st.dest == ROUTE_DEST_EUROPE) {
        arrived = w.terrain_id(u.x, u.y) == 26;
    } else if (st.dest >= 0 && st.dest < (int)w.colonies.size()) {
        const Colony& c = w.colonies[st.dest];
        arrived = (u.x == c.x && u.y == c.y);
    } else {
        u.order = ORDER_NONE; return;              // stale colony reference
    }

    const int capacity = unit_stats(rd, u.type).cargo;

    if (arrived) {
        // Lane order (unload before load) is not byte-cited -- RECONSTRUCTED:
        // freeing holds first is the only order that lets a full ship restock.
        if (st.dest == ROUTE_DEST_EUROPE) {
            // The auto-sell loop tests the boycott bit (func_030B38 @0x41210,
            // boycotts.md): a boycotted good stays aboard (@SOMEBOYCOTT).
            const uint16_t boy = g.powers[u.owner].boycotts;
            for (int good : st.unload) {
                if (good >= 0 && good < 16 && ((boy >> good) & 1u)) continue;
                for (int h = 0; h < capacity && h < 6; ++h)
                    if (u.hold_good[h] == good && u.hold_qty[h] > 0) {
                        market_sell(g, u.owner, good, u.hold_qty[h], rd);
                        u.hold_good[h] = -1; u.hold_qty[h] = 0;
                    }
            }
            for (int good : st.load) {
                if (good < 0 || good >= NGOODS) continue;
                if (((boy >> good) & 1u)) continue;   // boycotted: cannot buy either
                int h = accept_hold(u, capacity, good);
                if (h < 0) continue;
                const int qty = 100 - u.hold_qty[h];
                const long cost = (long)market_ask(g, u.owner, good, rd) * qty;
                if (g.powers[u.owner].gold < cost) continue;   // unaffordable: skip
                market_buy(g, u.owner, good, qty, rd);
                u.hold_good[h] = good; u.hold_qty[h] += qty;
            }
        } else {
            Colony& c = w.colonies[st.dest];
            for (int good : st.unload)                          // func_00B8D0
                for (int h = 0; h < capacity && h < 6; ++h)
                    if (u.hold_good[h] == good && u.hold_qty[h] > 0) {
                        c.stockpile[good] += u.hold_qty[h];
                        u.hold_good[h] = -1; u.hold_qty[h] = 0;
                    }
            for (int good : st.load) {                          // func_00B880
                if (good < 0 || good >= NGOODS) continue;
                if (c.stockpile[good] <= 0) continue;
                int h = accept_hold(u, capacity, good);
                if (h < 0) break;                               // ship is full
                int qty = 100 - u.hold_qty[h];
                if (c.stockpile[good] < qty) qty = c.stockpile[good];
                c.stockpile[good] -= qty;
                u.hold_good[h] = good; u.hold_qty[h] += qty;
            }
        }
        // Advance the stop cursor (unit high nibble, setter func_007610), wrapping
        // past "none" entries.
        int next = (u.route_stop + 1) % nstops;
        for (int guard = 0; r.stops[next].dest == ROUTE_DEST_NONE && guard < nstops; ++guard)
            next = (next + 1) % nstops;
        u.route_stop = next;
    }

    // (Re)write the GoTo cache (+0x314D/+0x314E, @0x4115F) at the current stop.
    const TradeStop& tgt = r.stops[u.route_stop];
    if (tgt.dest == ROUTE_DEST_EUROPE) {
        // The map's right-edge column is the Sea Lane (map invariant).
        u.target_x = w.map_w > 0 ? w.map_w - 1 : u.x;
        u.target_y = u.y;
    } else if (tgt.dest >= 0 && tgt.dest < (int)w.colonies.size()) {
        u.target_x = w.colonies[tgt.dest].x;
        u.target_y = w.colonies[tgt.dest].y;
    }
}

} // namespace vc::sim
