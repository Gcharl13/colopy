#!/usr/bin/env python3
"""Drive the bundled JS port headless and dump sim-state oracles for the C port.

The JS port is the census-verified reference; this extracts its numbers so
the C core can be diffed against them exactly (the logic-side render_diff).

Modes:
  produce   colonyProduce over every colony of every bundled fixture save
            -> JSON on stdout {save: [{name, pop, out, centre, hammers, ...}]}

Grows the per-turn trace dumper in C-port Phase 3.
"""
import json
import sys
from pathlib import Path

from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parents[1]
DIST = ROOT / "port" / "dist" / "colonization.html"

PRODUCE = """() => {
  const fixtures = { savstart: DATA.savStart, sav1653: DATA.sav1653,
                     savraleigh: DATA.savRaleigh, savnewcolony: DATA.savNewColony };
  const out = {};
  for (const [name, b64] of Object.entries(fixtures)) {
    if (!b64) continue;
    importSav(b64bytes(b64));
    G.dialog = null; G.popups = [];
    out[name] = G.colonies.map(c => {
      const r = colonyProduce(c);
      return { name: c.name, pop: c.colonists.length, sol: c.sol,
               out: r.out, centre: r.centre, eaten: r.eaten,
               hammers: r.tally[-1], bells: r.tally[-2],
               crosses: r.tally[-3], teaching: r.tally[-4] };
    });
  }
  return out;
}"""


MARKET = """() => {
  importSav(b64bytes(DATA.sav1653));
  G.dialog = null; G.popups = []; G.eventQueue = [];
  const snap = (step) => ({ step, gold: G.gold, fund: G.kingsFund,
    market: G.market.slice(), accum: G.accum.slice(),
    tons: G.tradeTons.slice(), tgold: G.tradeGold.slice() });
  const out = [snap('load')];
  sellGoods(9, 100);  out.push(snap('sell_rum_100'));
  sellGoods(2, 50);   out.push(snap('sell_tobacco_50'));
  buyGoods(14, 30);   out.push(snap('buy_tools_30'));
  driftMarket();      out.push(snap('drift_1'));
  sellGoods(7, 200);  out.push(snap('sell_silver_200'));
  buyGoods(15, 10);   out.push(snap('buy_muskets_10'));
  for (let i = 0; i < 5; i++) driftMarket();
  out.push(snap('drift_5'));
  sellGoods(0, 500);  out.push(snap('sell_food_500'));
  buyGoods(8, 20);    out.push(snap('buy_horses_20'));
  return out;
}"""


MOVECOST = """(cases) => {
  importSav(b64bytes(DATA.sav1653));
  return cases.map(([ship, fx, fy, tx, ty]) =>
    moveCost({ ship: !!ship }, fx, fy, tx, ty));
}"""

COMBAT = """(cases) => {
  importSav(b64bytes(DATA.sav1653));
  G.dialog = null; G.popups = [];
  return cases.map(([t, x, y, def, orders, fatigue, damaged, holds, vet]) => {
    const u = mkUnit(DATA.units[t].name, x, y);
    u.orders = orders; u.fatigue = fatigue; u.damaged = !!damaged;
    if (holds) u.hold = new Array(holds).fill({ good: 0, qty: 1 });
    if (vet) u.veteran = true;
    return combatStrength(u, !!def);
  });
}"""


# The prefix-turn trace: EXACTLY the pipeline colopy_turn.c implements —
# header cadence, player-unit refresh, payUpkeep, colonyTurn loop, vanish
# filter. Math.random is replaced AFTER import with the same MSC LCG the C
# uses, seed 1653, so both sides draw the same stream.
TURNS = """([save, n, agitate]) => {
  const KEY = { savstart: 'savStart', sav1653: 'sav1653',
                savraleigh: 'savRaleigh', savnewcolony: 'savNewColony' };
  importSav(b64bytes(DATA[KEY[save]]));
  G.dialog = null; G.popups = []; G.eventQueue = [];
  let _s = 1653 >>> 0;
  Math.random = () => {
    const lo = (_s & 0xFFFF) * 214013;
    const hi = ((_s >>> 16) * 214013) & 0xFFFF;
    _s = ((((lo >>> 16) + hi) & 0xFFFF) * 0x10000 + (lo & 0xFFFF) + 2531011) >>> 0;
    return ((_s >>> 16) & 0x7FFF) / 32768;
  };
  G.crosses = 0; G.bellsTotal = 0; G.dockUnits = []; G.fatherInProgress = null;
  // Optional adversarial seeding (draw-free, mirrored in C): war-footing
  // alarm + own missions on even tribes + hostile tension, so the raid
  // ladder / conversion / mission-tick paths all get parity coverage even
  // where the fixtures are peaceful.
  if (agitate) {
    for (const v of G.villages) {
      v.alarm = 0x90;
      if (v.tribe % 2 === 0) v.mission = { power: G.nation, expert: false };
    }
    for (const t of G.tribes) t.tension = 80;
  }
  const evs = [];
  const _show = showEvent, _ask = askEvent;
  showEvent = (k, subs) => { evs.push(k); return _show(k, subs); };
  askEvent = (k, subs, cb, opts) => { evs.push(k); G.dialog = null; };
  // A woodcut flips G.screen and would silently gate the parley check
  // (rivalTurn requires screen === 'map') for the rest of a headless run;
  // in real play the player dismisses it at once.  Model the dismissal.
  const _wc = woodcutOnce;
  woodcutOnce = (n, after) => { const r = _wc(n, after); G.screen = 'map'; return r; };
  const bldIndex = (n) => DATA.buildings.findIndex(b => b.name === n);
  G.dock = [rollImmigrant(), rollImmigrant(), rollImmigrant()];
  const fnv = () => {
    let h = 2166136261 >>> 0;
    for (let i = 0; i < MAP.w * MAP.h; i++) {
      h = ((h ^ MAP.tiles[i]) >>> 0); h = Math.imul(h, 16777619) >>> 0;
      h = ((h ^ (IMPROVE[i] & 0xC8)) >>> 0); h = Math.imul(h, 16777619) >>> 0;
    }
    return h;
  };
  const fatherIdx = (n) => DATA.fathers.findIndex(f => f.name === n);
  const out = [];
  for (let t = 0; t < n; t++) {
    // --- the prefix, mirroring endTurn's opening exactly ---
    G.turn += 1;
    if (G.year < 1600) G.year += 1;
    else {
      if (!G.timeChanged) { G.timeChanged = true; showEvent('TIMECHANGE'); }
      G.season = (G.season + 1) % 2;
      if (G.season === 0) G.year += 1;
    }
    for (const u of G.units) u.movesLeft = u.moves;
    payUpkeep();
    for (const c of G.colonies) colonyTurn(c);
    if (G.colonies.some(c => c.vanished))
      G.colonies = G.colonies.filter(c => !c.vanished);
    // @REFIT (endTurn:10754)
    for (const u of G.units) {
      const home = u.ship && u.damaged && colonyAt(u.x, u.y);
      if (home && ['Drydock', 'Shipyard'].some(b => home.buildings.includes(b))) {
        u.damaged = false;
        showEvent('REFIT', { STRING0: u.type, STRING1: home.name });
      }
    }
    advanceImprovements();
    checkImmigration();
    updateCongress();
    checkTreasure();
    // the native pass (endTurn:10767-10780, §19.11 order)
    nativeTick();
    nativeDemands();
    attemptConversions();
    ageConverts();
    nativeMoveAI();
    if (G.colonies.some(c => c.vanished))
      G.colonies = G.colonies.filter(c => !c.vanished);
    rivalTurn();
    // --- projection ---
    out.push({ turn: G.turn, year: G.year, season: G.season,
      gold: G.gold, fund: G.kingsFund, tax: G.tax,
      unpaid: G.upkeepUnpaid ? 1 : 0,
      colonies: G.colonies.map(c => ({ name: c.name,
        pop: c.colonists.length, sol: c.sol, hammers: c.hammers,
        bip: c.building ? bldIndex(c.building) : -1,
        stock: c.stock.slice(),
        bld: [...new Set(c.buildings.map(bldIndex))].sort((a, b) => a - b) })),
      crosses: G.crosses, bellsTotal: G.bellsTotal, bells: G.bells,
      fip: G.fatherInProgress ? fatherIdx(G.fatherInProgress) : -1,
      fathers: G.fathersOwned.map(fatherIdx).sort((a, b) => a - b),
      dock: G.dock.map(d => d.name),
      dockUnits: G.dockUnits.map(d => d.name || d),
      tension: G.tribes.map(t => t.tension),
      frac: G.tribes.map(t => t.frac || 0),
      villages: G.villages.map(v => [v.pop, v.growth || 0, v.alarm || 0,
        v.mission ? (v.mission.power | (v.mission.expert ? 16 : 0)) : -1,
        v.braveOwed ? 1 : 0]),
      natives: G.natives.map(q => [q.x, q.y,
        q.heading === undefined ? -1 : q.heading]),
      units: G.units.length,
      converts: G.units.filter(u => u.profession === 'Indian Converts')
        .map(u => [u.x, u.y, u.faith === undefined ? -1 : u.faith]),
      rivals: G.rivals.map(r => ({ n: r.nation,
        cols: r.colonies.map(c => [c.x, c.y]),
        units: r.units.map(u => [u.x, u.y]),
        greeted: r.greeted ? 1 : 0,
        lock: G.parleyLock[r.nation] || 0 })),
      maphash: fnv(),
      events: evs.splice(0) });
  }
  return out;
}"""


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "produce"
    if mode not in ("produce", "market", "movecost", "combat", "turns"):
        raise SystemExit("unknown mode: " + mode)
    cases = (json.load(open(sys.argv[2]))
             if len(sys.argv) > 2 and mode in ("movecost", "combat") else None)
    with sync_playwright() as pw:
        browser = pw.chromium.launch(executable_path="/opt/pw-browsers/chromium")
        page = browser.new_page()
        page.goto(DIST.as_uri())
        page.wait_for_function("typeof importSav === 'function'")
        # let the boot settle (assets decode on load)
        page.wait_for_timeout(500)
        if mode == "produce":
            data = page.evaluate(PRODUCE)
        elif mode == "market":
            data = page.evaluate(MARKET)
        elif mode == "movecost":
            data = page.evaluate(MOVECOST, cases)
        elif mode == "turns":
            data = page.evaluate(TURNS, [sys.argv[2], int(sys.argv[3]),
                                         len(sys.argv) > 4 and
                                         sys.argv[4] == "agitate"])
        else:
            data = page.evaluate(COMBAT, cases)
        browser.close()
    json.dump(data, sys.stdout, indent=1, sort_keys=True)
    print()


if __name__ == "__main__":
    main()
