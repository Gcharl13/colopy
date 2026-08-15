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


RENDERMAP = """([save, vx, vy, sel]) => {
  const KEY = { savstart: 'savStart', sav1653: 'sav1653',
                savraleigh: 'savRaleigh', savnewcolony: 'savNewColony' };
  importSav(b64bytes(DATA[KEY[save]]));
  G.dialog = null; G.popups = []; G.eventQueue = [];
  G.mapSeed = 1653;               // the C load pins CR.map_seed the same way
  // the C harness calls units_session_seed(): moves full, orders 0
  for (const u of G.units) { u.movesLeft = u.moves; u.orders = 0; }
  G.cyclePhase = 0;               // static frame: no colour cycling
  G.blink = true;    // the on half: the active unit is DRAWN
  G.sel = sel;
  G.zoom = 0;
  G.openMenu = -1;
  G.view = { x: vx, y: vy };
  G.screen = 'map';
  const cv = document.querySelector('canvas');
  const ctx = cv.getContext('2d');
  drawMap(ctx);
  return cv.toDataURL('image/png');
}"""


# The prefix-turn trace: EXACTLY the pipeline colopy_turn.c implements —
# header cadence, player-unit refresh, payUpkeep, colonyTurn loop, vanish
# filter. Math.random is replaced AFTER import with the same MSC LCG the C
# uses, seed 1653, so both sides draw the same stream.
TURNS = """([save, n, agitate, script, STEPRNG]) => {
  const KEY = { savstart: 'savStart', sav1653: 'sav1653',
                savraleigh: 'savRaleigh', savnewcolony: 'savNewColony' };
  importSav(b64bytes(DATA[KEY[save]]));
  G.dialog = null; G.popups = []; G.eventQueue = [];
  // beginGame ROLLS the rumour/detail salt [0x190] with the NATIVE RNG
  // (game.js:742, before the LCG below replaces it) — pin it so
  // rumourAt agrees across runs and with the C (cr_reset_from_load).
  G.mapSeed = 1653;
  let _s = 1653 >>> 0;
  Math.random = () => {
    const lo = (_s & 0xFFFF) * 214013;
    const hi = ((_s >>> 16) * 214013) & 0xFFFF;
    _s = ((((lo >>> 16) + hi) & 0xFFFF) * 0x10000 + (lo & 0xFFFF) + 2531011) >>> 0;
    G.rngState = _s;   // projected as "rng" — pins stream sync in the diff
    return ((_s >>> 16) & 0x7FFF) / 32768;
  };
  G.rngState = _s;
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
    // slice 5: prime the SoL EMA so the Sons of Liberty carry the country
    // and the DECLARE gate can open — the war chain gets parity coverage.
    for (const c of G.colonies) { c.rebelA = 20000; c.rebelB = 20000; }
  }
  const evs = [];
  const _show = showEvent, _ask = askEvent;
  showEvent = (k, subs) => { evs.push(k); return _show(k, subs); };
  // PHASE 5: asks get ANSWERED under a deterministic policy both engines
  // compute identically (choice = askSeq++ % 2), so every decision path
  // (tax demands, tea parties, treaties, tribute, buy-offs) executes and
  // lands in the parity diff.  OFF until the C ask sites carry their
  // ported callback bodies (task #88 slice 1) — flip with the C flag.
  const ANSWER_ASKS = true;
  let _askSeq = 0;
  askEvent = (k, subs, cb, opts) => {
    evs.push(k);
    if (ANSWER_ASKS) {
      const choice = _askSeq++ % 2;
      evs.push('A' + choice);
      if (cb) cb(choice);
    }
    G.dialog = null;
  };
  // A woodcut flips G.screen and would silently gate the parley check
  // (rivalTurn requires screen === 'map') for the rest of a headless run;
  // in real play the player dismisses it at once.  Model the dismissal.
  const _wc = woodcutOnce;
  woodcutOnce = (n, after) => { const r = _wc(n, after); G.screen = 'map'; return r; };
  // PHASE 5 slice 2: scripted player commands, run before each endTurn.
  // A deterministic, RNG-free policy both engines compute identically
  // (mirrored verbatim in cport/host/main.c script_commands); every move
  // target passes ONE shared legality filter — empty legal land only —
  // so branches the C has not ported yet (ships, rival tiles, villages,
  // rumour entry: slices 3-5) are never reached.  advance() is stubbed:
  // the commands' auto-advance would re-enter endTurn mid-script.
  advance = () => {};
  // openDialog (landfall / SAILHOME / LANDHO) parks a modal nobody answers
  // headless; the latch would ALSO flip askZoom onto its dialog-open branch
  // and desync the ask counter — stub it inert (slice 4c).
  openDialog = () => {};
  const DIRS8 = [[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1],[0,-1],[1,-1]];
  const tileFree = (nx, ny) => {
    if (nx < 0 || ny < 0 || nx >= MAP.w || ny >= MAP.h) return false;
    if (tileWater(at(nx, ny))) return false;
    if (G.natives.some(q => q.x === nx && q.y === ny)) return false;
    if (G.refUnits.some(q => q.x === nx && q.y === ny)) return false;
    for (const r of G.rivals) {
      if (r.units.some(q => q.x === nx && q.y === ny)) return false;
      if (r.colonies.some(q => q.x === nx && q.y === ny)) return false;
    }
    if (G.villages.some(v => v.x === nx && v.y === ny)) return false;
    return true;   // rumour squares are ENTERED (slice 4a: enterRumour)
  };
  const scriptTurn = (t) => {
    for (let k = 0; k < G.units.length; k++) {
      const u = G.units[k];
      if (u.ship) {
        // slice 3: an idle ship sails home now and then; the splice
        // shifts the list and the loop steps past the slot (mirrored).
        if (u.orders === 0 && (t + k) % 17 === 0 && t > 0 && !woiLocked()) {
          sailForEurope(u); continue;
        }
        // slice 4c: a water step (interception, naval attack, parley;
        // the sea lane's SAILHOME dialog is inert so skip its tiles)
        const [dx, dy] = DIRS8[(t + k) % 8];
        const nx = u.x + dx, ny = u.y + dy;
        if (u.movesLeft > 0 && nx >= 0 && ny >= 0 && nx < MAP.w && ny < MAP.h &&
            tileWater(at(nx, ny)) && tileTerrain(at(nx, ny)) !== TERR.SEALANE) {
          G.sel = k; moveSel(dx, dy);
        }
        continue;
      }
      const a = (t * 7 + k * 3) % 10;
      if (u.orders !== 0) {                    // busy: occasionally wake it
        if (a === 0) { G.sel = k; activateUnit(); }
        continue;
      }
      if (a < 5) {
        const [dx, dy] = DIRS8[(t + k) % 8];
        if (u.movesLeft > 0 && tileFree(u.x + dx, u.y + dy)) {
          G.sel = k; moveSel(dx, dy);
        }
      } else if (a === 5) {
        // visit an adjacent village (slice 4b) — skip tiles a native or
        // rival also occupies (those are moveSel's foe branches)
        for (const [dx, dy] of DIRS8) {
          const nx = u.x + dx, ny = u.y + dy;
          if (!G.villages.some(v2 => v2.x === nx && v2.y === ny)) continue;
          const occupied =
            G.natives.some(q => q.x === nx && q.y === ny) ||
            G.rivals.some(r => r.units.some(q => q.x === nx && q.y === ny));
          if (!occupied && u.movesLeft > 0) {
            G.sel = k; moveSel(dx, dy);
            if (G.village) {
              const rows2 = villageActions();
              runVillageAction(rows2[(t + k) % rows2.length].id);
            }
          }
          break;
        }
      } else if (a === 6) { G.sel = k; setOrder(5); }        // Fortify
      else if (a === 7) { G.sel = k; improveOrder(t % 2 ? 9 : 8); }
      else if (a === 8) {
        if (G.colonies.length) {
          u.orders = 3; u.goal = [G.colonies[0].x, G.colonies[0].y];
        }
      } else { G.sel = k; skipUnit(); }
    }
    // --- the Europe phase (slice 3), fixed order.  portIdx tracks the
    // LIVE shipsInPort index (activeShip's coordinate); seen is the
    // stable action selector.
    let portIdx = 0, seen = 0;
    for (let i = 0; i < G.europe.length; i++) {
      const e = G.europe[i];
      if (e.state !== 'port') continue;
      const a = (t * 3 + seen) % 5;
      seen++;
      G.euroShip = portIdx;
      if (a === 0) {
        for (const h of (e.hold || []).slice()) sellFromShip(h.good, h.qty);
      } else if (a === 1) {
        buyToShip((t + portIdx) % 16, 50);
      } else if (a === 2) {
        sailForNewWorld(e);
      }
      if (e.state === 'port') portIdx++;
    }
    if (t % 4 === 1 && G.dockUnits.length) {
      G.euroDockSel = 0;
      const rows = dockUnitRows().filter(r => r.act === 'arm');
      if (rows.length) euroContextCommit(rows[(t >> 2) % rows.length]);
    }
    if (t % 5 === 2) { G.euroMenu = 'recruit'; G.euroMenuRow = 1; euroMenuCommit(); }
    if (t % 9 === 4) declareIndependence();   // slice 5: gates + the DECLARE ask
    if (t % 7 === 3) { G.euroMenu = 'purchase';
                       G.euroMenuRow = Math.floor(t / 7) % 6; euroMenuCommit(); }
  };
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
  // Per-step RNG probe (STEPRNG flag): wrap each endTurn step to log
  // [name, rngState] — the C mirror is COLOPY_STEP_RNG=1 (step_rng()).
  if (STEPRNG) {
    G._steps = [];
    const wrap = (name, fn) => (...a) => {
      const r = fn(...a);
      G._steps.push([name, G.rngState >>> 0]);
      return r;
    };
    payUpkeep = wrap('payUpkeep', payUpkeep);
    advanceImprovements = wrap('advanceImprovements', advanceImprovements);
    checkImmigration = wrap('checkImmigration', checkImmigration);
    updateCongress = wrap('updateCongress', updateCongress);
    checkTreasure = wrap('checkTreasure', checkTreasure);
    nativeTick = wrap('nativeTick', nativeTick);
    nativeDemands = wrap('nativeDemands', nativeDemands);
    attemptConversions = wrap('attemptConversions', attemptConversions);
    ageConverts = wrap('ageConverts', ageConverts);
    nativeMoveAI = wrap('nativeMoveAI', nativeMoveAI);
    rivalTurn = wrap('rivalTurn', rivalTurn);
    newsTick = wrap('newsTick', newsTick);
    kingWarCycle = wrap('kingWarCycle', kingWarCycle);
    kingTaxDemand = wrap('kingTaxDemand', kingTaxDemand);
    advanceGoTo = wrap('advanceGoTo', advanceGoTo);
    runWar = wrap('runWar', runWar);
    toryUprising = wrap('toryUprising', toryUprising);
    shoreBombardment = wrap('shoreBombardment', shoreBombardment);
    spanishSuccession = wrap('spanishSuccession', spanishSuccession);
    aiDiplomacyTick = wrap('aiDiplomacyTick', aiDiplomacyTick);
    offerMercenaries = wrap('offerMercenaries', offerMercenaries);
    checkIntervention = wrap('checkIntervention', checkIntervention);
    driftMarket = wrap('driftMarket', driftMarket);
    advanceCrossings = wrap('advanceCrossings', advanceCrossings);
  }
  const out = [];
  for (let t = 0; t < n; t++) {
    if (STEPRNG) { G._steps = []; G._steps.push(['turn-start', G.rngState >>> 0]); }
    if (script) scriptTurn(t);
    // PHASE-3 CLOSE: the REAL engine step, not a hand-built prefix.
    endTurn();
    // --- projection ---
    out.push({ turn: G.turn, year: G.year, season: G.season,
      rng: G.rngState >>> 0,
      ...(STEPRNG ? { steps: G._steps.slice() } : {}),
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
      punits: G.units.map(u => [u.x, u.y, u.orders | 0, u.work | 0,
        u.movesLeft, u.tools | 0,
        u.profession ? DATA.jobexpert.indexOf(u.profession) : -1]),
      woi: [G.flags | 0, G.razed | 0, G.royalFund | 0,
        G.ref['Regulars'] | 0, G.ref['Cavalry'] | 0,
        G.ref['Man-O-War'] | 0, G.ref['Artillery'] | 0],
      refs: G.refUnits.map(u => [u.x, u.y,
        DATA.units.findIndex(x => x.name === u.type)]),
      holds: G.units.map(u => (u.hold || []).map(h => [h.good, h.qty])),
      europe: G.europe.map(e => [
        DATA.units.findIndex(x => x.name === e.type),
        e.state === 'port' ? 0 : e.state === 'toEurope' ? 1 : 2,
        e.state === 'port' ? 0 : (e.turns | 0),
        (e.hold || []).map(h => [h.good, h.qty]),
        (e.passengers || []).length]),
      units: G.units.length,
      converts: G.units.filter(u => u.profession === 'Indian Converts')
        .map(u => [u.x, u.y, u.faith === undefined ? -1 : u.faith]),
      rivals: G.rivals.map(r => ({ n: r.nation,
        cols: r.colonies.map(c => [c.x, c.y]),
        units: r.units.map(u => [u.x, u.y,
          DATA.units.findIndex(t => t.name === u.type)]),
        greeted: r.greeted ? 1 : 0,
        lock: G.parleyLock[r.nation] || 0 })),
      maphash: fnv(),
      events: evs.splice(0) });
  }
  return out;
}"""


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "produce"
    if mode not in ("produce", "market", "movecost", "combat", "turns",
                    "rendermap"):
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
        elif mode == "rendermap":
            out = page.evaluate(RENDERMAP, [sys.argv[2], int(sys.argv[3]),
                                            int(sys.argv[4]),
                                            int(sys.argv[5]) if len(sys.argv) > 5 else 0])
            browser.close()
            print(out)
            return
        elif mode == "turns":
            data = page.evaluate(TURNS, [sys.argv[2], int(sys.argv[3]),
                                         "agitate" in sys.argv[4:],
                                         "script" in sys.argv[4:],
                                         "steprng" in sys.argv[4:]])
        else:
            data = page.evaluate(COMBAT, cases)
        browser.close()
    json.dump(data, sys.stdout, indent=1, sort_keys=True)
    print()


if __name__ == "__main__":
    main()
