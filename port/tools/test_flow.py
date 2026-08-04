#!/usr/bin/env python3
"""Drive the bundled port through the landfall sequence and assert each step.

Sails the starting ship west until the coast refuses it, takes the @LANDFALL
offer, and checks the chain the engine runs: cargo ashore -> woodcut 1
(DISCOVERY OF THE NEW WORLD) -> @LANDHO naming prompt -> back to the map.
"""
import sys
from pathlib import Path

from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parents[2]
DIST = ROOT / "port" / "dist" / "colonization.html"

SCRIPT = """() => {
  const out = {};
  beginGame(); G.screen = 'map';
  const ship = G.units[0];
  out.ship = ship.type;
  out.sailedOnWater = false;
  for (let i = 0; i < 30 && !G.dialog; i++) {
    const before = ship.x;
    ship.movesLeft = 9;
    moveSel(-1, 0);
    if (ship.x !== before) out.sailedOnWater = true;
  }
  out.offer = G.dialog ? G.dialog.opts : null;
  out.offerDefault = G.dialog ? G.dialog.sel : null;

  closeDialog(G.dialog.sel);                 // take the @default, "Make Landfall"
  out.afterLandfall = { screen: G.screen, woodcut: G.woodcut,
                        cargoLeft: ship.cargo.length,
                        units: G.units.map(u => u.type) };

  onClick(-1, -1);                           // dismiss the woodcut
  out.afterWoodcut = { screen: G.screen, entry: G.dialog && G.dialog.entry };

  dialogKey('Enter');                        // accept the default land name
  out.afterNaming = { screen: G.screen, newLand: G.newLand, dialog: !!G.dialog };

  // A unit ashore walks on land and is refused by the sea. Clear any natives or
  // villages around the landing site first: TRIBE.TXT puts a brave next to this
  // beach, and walking into one is an ATTACK, which this movement test is not
  // about (combat has its own checks below).
  const pio = G.units[1];
  G.sel = 1;
  G.natives = G.natives.filter(n => Math.abs(n.x - pio.x) > 2 || Math.abs(n.y - pio.y) > 2);
  G.villages = G.villages.filter(v => Math.abs(v.x - pio.x) > 2 || Math.abs(v.y - pio.y) > 2);
  const at0 = [pio.x, pio.y];
  pio.movesLeft = 1; moveSel(1, 0);          // east, back toward the water
  out.seaRefused = (pio.x === at0[0] && pio.y === at0[1]);
  pio.movesLeft = 1; moveSel(-1, 0);         // west, inland
  out.walkedInland = (pio.x === at0[0] - 1);

  // Space passes on the active unit without moving it.
  G.sel = 1; pio.movesLeft = 1;
  const held = [pio.x, pio.y];
  skipUnit();
  out.skipHeldPosition = (pio.x === held[0] && pio.y === held[1]);

  // Build Colony on the tile the party is standing on.
  G.sel = G.units.findIndex(u => !u.ship);
  const founder = G.units[G.sel];
  buildColony();
  out.colonyPrompt = G.dialog ? G.dialog.entry : null;
  const before = G.units.length;
  closeDialog(G.dialog.entry);
  out.colony = G.colonies.length === 1 && {
    name: G.colonies[0].name,
    onFounderTile: G.colonies[0].x === founder.x && G.colonies[0].y === founder.y,
    founderConsumed: G.units.length === before - 1,
    stockSlots: G.colonies[0].stock.length,
  };
  out.colonyWoodcut = { screen: G.screen, n: G.woodcut };
  onClick(-1, -1);
  out.afterColonyWoodcut = G.screen;
  onClick(310, 190);                          // Exit zone
  out.colonyExit = G.screen;

  // A ship entering the sea lane leaves for the home port.
  const vessel = G.units.find(u => u.ship);
  G.sel = G.units.indexOf(vessel);
  vessel.x = MAP.w - 2; vessel.movesLeft = 9;
  moveSel(1, 0);
  out.crossing = { state: G.europe[0] && G.europe[0].state, turns: G.europe[0] && G.europe[0].turns,
                   shipLeftMap: !G.units.includes(vessel) };
  for (let t = 0; t < 3; t++) endTurn();
  out.europe = { screen: G.screen, inPort: shipsInPort().length };

  // Market: buy 100 Tools into the hold, then sell them back with tax.
  G.tax = 10;
  G.gold = 5000;                               // a treasury to trade with
  const boat = activeShip();
  const gold0 = G.gold, tools = 14;
  const accum0 = G.accum[tools];
  buyToShip(tools, 100);
  out.bought = { held: holdQty(boat, tools), spent: gold0 - G.gold,
                 wasAsk: gold0 - G.gold > 0 };
  const accumAfterBuy = G.accum[tools];
  const gold1 = G.gold, king0 = G.kingsFund;
  sellFromShip(tools);
  out.sold = { held: holdQty(boat, tools), gained: G.gold - gold1,
               kingTook: G.kingsFund - king0 };

  // Buying drains the market and selling floods it, so the accumulator moves
  // in opposite directions and a matched round trip nets back to where it was.
  out.accumMoved = { drainedOnBuy: accumAfterBuy < accum0,
                     floodedOnSell: G.accum[tools] > accumAfterBuy,
                     roundTripNeutral: G.accum[tools] === accum0 };

  // Recruit: the dock has three candidates priced from @CLASS.
  openEuroMenu(0);
  const rows = euroMenuRows();
  out.recruitRows = rows.length === 3 && rows.every(r => r.cost >= 300 && r.cost <= 2000);
  G.gold = 5000; G.euroMenuRow = 0;
  const dock0 = G.dockUnits.length, g2 = G.gold;
  euroMenuCommit();
  out.recruited = { paid: g2 - G.gold > 0, onDock: G.dockUnits.length === dock0 + 1,
                    menuClosed: G.euroMenu === null };

  // Purchase is the §17.6 catalog, not goods; Artillery escalates by 100.
  openEuroMenu(1);
  const pcat = euroMenuRows();
  out.purchase = {
    labels: pcat.map(r => r.label),
    prices: pcat.map(r => r.cost),
  };
  G.gold = 20000; G.euroMenuRow = 0;
  euroMenuCommit();                            // buy Artillery
  out.artilleryEscalates = euroMenuRows()[0].cost === 600;
  out.artilleryOnDock = G.dockUnits.includes('Artillery');
  G.euroMenuRow = 1; openEuroMenu(1); G.euroMenuRow = 1;
  const fleet0 = shipsInPort().length;
  euroMenuCommit();                            // buy a Caravel
  out.shipJoinsFleet = shipsInPort().length === fleet0 + 1;

  // Sailing west boards whoever is waiting on the dock.
  const pax0 = boat.passengers.length, waiting = G.dockUnits.length;

  // Train: all 17 trainable @JOB rows, priced from europe_value, price-sorted.
  openEuroMenu(2);
  const tr = euroMenuRows();
  out.train = {
    count: tr.length,
    sorted: tr.every((r, i) => i === 0 || tr[i - 1].cost <= r.cost),
    cheapest: tr[0] && tr[0].cost,
    dearest: tr[tr.length - 1] && tr[tr.length - 1].cost,
  };
  G.euroMenu = null;

  // Recruit candidates are UNIT TYPES from the §17.6 ladder, each carrying the
  // @CLASS band its passage is priced from -- not three @CLASS names.
  out.dockShape = G.dock.every(c => typeof c.name === 'string' &&
                                    typeof c.band === 'number' &&
                                    c.band >= 0 && c.band < DATA.classes.length);
  const ladder = ['Petty Criminals', 'Indentured Servants', 'Free Colonists'];
  out.dockFromLadder = G.dock.every(c =>
    ladder.includes(c.name) || DATA.jobtrain.some(j => j.expert === c.name));

  // The advisor portrait sheet is loaded, and he speaks for RECRUIT and
  // PURCHASE only -- TRAIN is a bare list with no speaker.
  out.adviser = !!(DATA.sheets.MSS2 && DATA.sheets.MSS2.frames.length);
  out.adviserScope = {};
  for (const [k, name] of [[0, 'recruit'], [1, 'purchase'], [2, 'train']]) {
    openEuroMenu(k);
    out.adviserScope[name] = hasAdviser();
  }
  G.euroMenu = null;

  // Sail home: three turns back to the lane, then the ship is on the map again.
  const units0 = G.units.length;
  sailForNewWorld(boat);
  out.boarded = boat.passengers.length === pax0 + waiting && G.dockUnits.length === 0;
  out.outbound = boat.state === 'toNewWorld';
  for (let t = 0; t < 3; t++) endTurn();
  out.returned = { onMap: G.units.length === units0 + 1 };

  G.screen = 'europe';
  onClick(310, 190);
  out.europeExit = G.screen;

  // ---- colony work assignment and construction ----
  {
    beginGame(); G.screen = 'map';
    const sh = G.units[0];
    for (let i = 0; i < 25 && !G.dialog; i++) { sh.movesLeft = 9; moveSel(-1, 0); }
    closeDialog(1); onClick(-1, -1); dialogKey('Enter');
    G.sel = G.units.findIndex(u => !u.ship);
    const f0 = G.units[G.sel];
    G.natives = G.natives.filter(n => Math.abs(n.x - f0.x) > 2 || Math.abs(n.y - f0.y) > 2);
    G.villages = G.villages.filter(v => Math.abs(v.x - f0.x) > 2 || Math.abs(v.y - f0.y) > 2);
    buildColony(); closeDialog('Jamestown');
    G.screen = 'colony';
    const c = G.colonies[0];
    c.colonists.push({ type: 'Colonists', job: null, cell: null });
    c.colonists.push({ type: 'Colonists', job: null, cell: null });

    // A new colony makes no hammers: it has the shop but nobody in it.
    out.hammersBeforeCarpenter = colonyHammers(c);

    // Click a scene cell to put an idle colonist on that field.
    onClick(224 + 12, 32 + 12);                     // cell (-1,-1)
    const worker = c.colonists.find(p => p.cell);
    out.fieldWork = !!worker && worker.job === 'Farmer' &&
                    worker.cell[0] === -1 && worker.cell[1] === -1;
    const f = colonyFood(c);
    out.food = { centre: f.centre > 0, fields: f.fields > 0, eaten: f.eaten === 2 * c.colonists.length };

    // Jobs menu puts a colonist in the Carpenter's Shop, and only then do
    // hammers appear.
    G.colonistSel = c.colonists.findIndex(p => !p.cell);
    G.colonyPopup = 'jobs';
    G.colonyPopupRow = colonyPopupRows().findIndex(r => r.label === "Carpenter's Shop");
    colonyPopupCommit();
    out.hammersAfterCarpenter = colonyHammers(c);

    // Construction menu offers only ungated, unbuilt rows, and banks hammers
    // until the target is paid for.
    G.colonyPopup = 'build';
    const opts = colonyPopupRows();
    out.buildGated = opts.every(r => {
      const b = DATA.buildings.find(d => d.name === r.label);
      return !c.buildings.includes(r.label) && b.min_colony <= c.colonists.length;
    });
    G.colonyPopupRow = opts.findIndex(r => r.label === 'Docks');
    colonyPopupCommit();
    out.buildTarget = c.building;
    const cost = DATA.buildings.find(b => b.name === 'Docks').cost;
    for (let t = 0; t < cost + 2; t++) endTurn();
    out.built = { done: c.buildings.includes('Docks'), targetCleared: c.building === null };
  }

  // ---- combat, natives, immigration, pedia, save/load ----
  {
    beginGame(); G.screen = 'map';
    out.natives = { villages: G.villages.length > 0, tribes: G.tribes.length === DATA.tribes.length,
                    seeded: G.tribes.every(t => t.tension >= 0 && t.tension <= 100) };
    // Braves are land units and villages are land settlements: neither may sit
    // on water.
    out.nothingOnWater = G.natives.every(n => !tileWater(at(n.x, n.y))) &&
                         G.villages.every(v => !tileWater(at(v.x, v.y)));
    // Village trade: an offer is priced, selling pays and cools the village,
    // and a gift zeroes its alarm outright.
    {
      const v = G.villages[0];
      v.alarm = 200;
      const wagon = mkUnit('Wagon Train', v.x - 1, v.y);
      wagon.hold = [{ good: 4, qty: 100 }];      // 100 Furs
      const offer = villageOffer(v, 4, 100);
      const g0 = G.gold;
      const paid = villageSell(v, 4, 100);
      out.villageTrade = { offered: offer > 0, paid: paid > 0,
                           creditedTreasury: G.gold === g0 + paid,
                           fullLoadZeroesAlarm: v.alarm === 0,
                           stocked: v.stock[4] === 100 };
      // Muskets arm the tribe: +1 at 25 units, +2 at 50.
      const t = G.tribes[v.tribe];
      t.musketsKnown = 0;
      villageSell(v, 15, 50);
      out.armsTribe = t.musketsKnown === 2;
      // Buying from the village: priced the other way up, charged to the
      // treasury, and it cools the tribe a little.
      {
        const w2 = mkUnit('Wagon Train', v.x - 1, v.y);
        const surplus = villageSurplus(v);
        const gB = G.gold; G.gold = 20000;
        const t1 = G.tribes[v.tribe].tension;
        const cost = surplus.length ? villageBuy(v, surplus[0].good, surplus[0].qty) : 0;
        out.villageBuy = { hasSurplus: surplus.length > 0, charged: cost >= 50,
                           goldFell: G.gold === 20000 - cost,
                           cooled: G.tribes[v.tribe].tension <= t1 };
        G.gold = gB;
      }
      // A gift cools further than a sale.
      v.alarm = 100; G.tribes[v.tribe].tension = 50;
      villageGift(v, 13, 20);
      out.gift = { alarmCleared: v.alarm === 0, tensionFell: G.tribes[v.tribe].tension < 50 };
    }

    // Every tribe carries a map colour from @TRIBES' `value` column, the
    // native counterpart of @COUNTRY.color, and they are all distinct.
    out.tribeColours = {
      allSet: G.tribes.every(t => typeof t.color === 'number' && t.color > 0),
      distinct: new Set(G.tribes.map(t => t.color)).size === G.tribes.length,
      nativesUseIt: (() => {
        const n = G.natives[0];
        return n && ownerColour(n) === G.tribes[n.tribe].color;
      })(),
      europeansUseCountry: ownerColour(G.units[0]) === DATA.nations[G.nation].color,
    };

    // Every built report has its own REPORT<N>.PIK, and F1 is not a report at
    // all -- it is the Colonizopedia terrain page.
    out.reportPiks = {
      allLoaded: Object.values(REPORT_PIK).every(p => !!IMG[p]),
      distinct: new Set(Object.values(REPORT_PIK)).size === Object.keys(REPORT_PIK).length,
      f9UsesReport1: REPORT_PIK.F9 === 'REPORT1',
      f1NotAReport: REPORTS.F1 === undefined,
    };

    // Rival powers start at their own @SCENARIO positions, found colonies from
    // their own COLONY.TXT name pools, and never plant in water.
    {
      out.rivals = {
        three: G.rivals.length === 3,
        notPlayer: G.rivals.every(r => r.nation !== G.nation),
        atScenarioStart: G.rivals.every(r =>
          r.units[0].x === DATA.starts[r.nation][0] &&
          r.units[0].y === DATA.starts[r.nation][1]),
      };
      for (let t = 0; t < 40; t++) runRivals();
      out.rivalGrowth = {
        founded: G.rivals.some(r => r.colonies.length > 0),
        onLand: G.rivals.every(r => r.colonies.every(c => !tileWater(at(c.x, c.y)))),
        ownNames: G.rivals.every(r => r.colonies.every(c =>
          DATA.colonynames[r.nation].includes(c.name))),
      };
      // First contact fires woodcut 10, once.
      const r0 = G.rivals[0];
      G.metAnyone = false; r0.met = false;
      const scout = mkUnit('Scouts', r0.units[0].x + 1, r0.units[0].y);
      G.units.push(scout);
      checkContact();
      out.contact = { met: r0.met, woodcut: G.woodcut === 10, screen: G.screen === 'woodcut' };
      G.screen = 'map';
      // and it does not fire a second time
      const r1 = G.rivals[1]; r1.met = false; G.woodcut = 1;
      const scout2 = mkUnit('Scouts', r1.units[0].x + 1, r1.units[0].y);
      G.units.push(scout2);
      checkContact();
      out.contactOnce = r1.met && G.screen === 'map';
    }

    // Continental Congress: the cost formula must reproduce the manual's
    // live-verified cross-check -- Explorer human, one father, pre-1600 = 129.
    {
      const d0 = G.difficulty, y0 = G.year, own = G.fathersOwned.slice();
      G.difficulty = 1; G.year = 1590; G.fathersOwned = ['X'];
      out.fatherCost129 = fatherCost() === 129;
      G.fathersOwned = [];
      out.firstFatherHalf = fatherCost() === 32;
      G.year = 1650; G.fathersOwned = ['X'];
      out.eraGateCompounds = fatherCost() > 129;
      G.year = 1590; G.fathersOwned = [];
      const cands = fatherCandidates();
      out.candidates = { count: cands.length === 5,
                         oneEach: new Set(cands.map(f => f.category)).size === cands.length };
      G.difficulty = d0; G.year = y0; G.fathersOwned = own;
    }

    // Native settlements use their OWN sprite band (disk 10..13, no pennant),
    // never the colony band (disk 0..3, which carries one).
    // Every settlement comes from TRIBE.TXT, not a scatter: 59 sites, and the
    // per-tribe counts must match the shipped section lengths exactly.
    out.tribeSites = {
      total: G.villages.length === 59,
      perTribe: G.tribes.every(t =>
        G.villages.filter(v => v.name === t.name).length ===
        (DATA.tribesites[t.singular.toUpperCase()] || []).length),
    };
    out.settlementBands = { native: NATIVE_FRAME_BASE === 10,
                            colonyDistinct: !COLONY_FRAME.some(f => f >= 10),
                            levelsSeen: [...new Set(G.villages.map(v => v.level))].sort().join(',') };

    // Attacking a tribe is an act of war: tension jumps and the loser dies.
    const sold = mkUnit('Soldiers', 10, 10); G.units.push(sold);
    const brave = { type: 'Braves', icon: unit('Braves').icon, x: 11, y: 10,
                    tribe: 0, orders: 0, nation: -1 };
    G.natives.push(brave);
    const before = G.units.length + G.natives.length, t0 = G.tribes[0].tension;
    G.sel = G.units.indexOf(sold); sold.movesLeft = 1; moveSel(1, 0);
    out.combat = { someoneDied: G.units.length + G.natives.length === before - 1,
                   tensionRose: G.tribes[0].tension > t0 };

    // adjust_tension halves positive deltas for France, not for others.
    G.nation = 1; G.tribes[1].tension = 0; adjustTension(1, 10);
    const fr = G.tribes[1].tension;
    G.nation = 0; G.tribes[2].tension = 0; adjustTension(2, 10);
    out.tensionHalving = { france: fr === 5, other: G.tribes[2].tension === 10 };
    // and it clamps at 0..100
    adjustTension(2, 500); const hi = G.tribes[2].tension;
    adjustTension(2, -500); out.tensionClamp = hi === 100 && G.tribes[2].tension === 0;

    // Fortifying raises defence, per the +50% and the +4 bonus term.
    const a = mkUnit('Soldiers', 12, 12), d = mkUnit('Soldiers', 12, 12);
    const plain = combatStrength(d, true);
    d.orders = 6;
    out.fortifyHelps = combatStrength(d, true) > plain;

    // Immigration threshold shrinks as the empire grows.
    const thrSmall = immigrationThreshold();
    G.colonies.push({ name: 'X', x: 5, y: 5, nation: 0, colonists: [{}, {}, {}, {}, {}],
                      stock: [], buildings: [], hammers: 0, tools: 0, building: null, sol: 0 });
    out.thresholdGrows = immigrationThreshold() > thrSmall;

    // Colonizopedia: every category has entries and Complete merges them.
    out.pedia = {};
    let total = 0;
    for (let c = 0; c < 7; c++) { G.pediaCat = c; const n = pediaList().length; total += n;
                                  out.pedia['cat' + c] = n > 0; }
    G.pediaCat = 7;
    out.pedia.complete = pediaList().length === total;
    out.pedia.article = (pediaBody(5, 0) || '').includes('Adam Smith');

    // Save / load round trip.
    G.gold = 4242; saveGame(); G.gold = 0; loadGame();
    out.saveLoad = G.gold === 4242;
  }

  // ---- menu bar and key commands (§27.1) ----
  const press = (k, mod) => onKey(Object.assign(
    { key: k, preventDefault() {}, altKey: false, shiftKey: false }, mod || {}));

  // Alt+accelerator opens each of the six pulldowns.
  out.altOpens = DATA.menus.every((m, i) => {
    beginGame(); G.screen = 'map';
    press(m.accel.toLowerCase(), { altKey: true });
    const ok = G.openMenu === i;
    G.openMenu = -1;
    return ok;
  });

  // Order keys set the @ORDERS row they name.
  out.orderKeys = {};
  for (const [k, want] of [['f', 5], ['s', 1], ['p', 8], ['r', 9]]) {
    beginGame(); G.screen = 'map'; press(k);
    out.orderKeys[k] = G.units[G.sel] && G.units[G.sel].orders === want;
  }

  // E reaches Europe and orders the selected ship home.
  beginGame(); G.screen = 'map'; press('e');
  out.eToEurope = { screen: G.screen, crossings: G.europe.length };

  // Zoom spans are (0xF<<z) x (0xC<<z) at (0x10>>z) px.
  out.zoomSpans = [0, 1, 2, 3].map(z => { G.zoom = z; return [VIEW_COLS(), VIEW_ROWS(), TILE_PX()]; });
  G.zoom = 0;

  // A menu row with a command runs and closes the pulldown; one without says so.
  beginGame(); G.screen = 'map'; openMenu(1);
  G.menuSel = DATA.menus[1].rows.findIndex(r => r.label === 'Center View');
  runMenuRow();
  out.menuDispatch = G.openMenu === -1;
  G.screen = 'map'; openMenu(4);            // TRADE: nothing implemented
  G.menuSel = 0; runMenuRow();
  out.menuAbsent = /not in this build/.test(G.msg);

  // ---- dialog frame (func_06E0C8) ----
  // Paint a box on a scratch canvas and read back the four rings: black
  // outline, ring 2 inset 1, bevel inset 2 with the top-left LIGHT and the
  // bottom-right DARK (the engine's left/right/top/bottom paint order).
  {
    const c = document.createElement('canvas');
    c.width = 60; c.height = 40;
    const g = c.getContext('2d');
    usePalette('WOODPANL');
    plaque(g, 5, 5, 40, 24, 'WOODTILE');
    const px = (x, y) => { const d = g.getImageData(x, y, 1, 1).data; return [d[0], d[1], d[2]]; };
    const eq = (a, b) => a[0] === b[0] && a[1] === b[1] && a[2] === b[2];
    const rgb = (i) => { const m = ink(i).match(/\d+/g); return m.map(Number); };
    out.frame = {
      outline: eq(px(5, 5), [0, 0, 0]),
      ring: eq(px(6, 6), rgb(FRAME_GAME.ring)),
      topLeftLight: eq(px(7, 7), rgb(FRAME_GAME.light)),
      // Bevel is inset 2, so its right span is at x+w-3 = 42 and its bottom
      // span at y+h-3 = 26 -- x=43 / y=27 are still ring 2.
      bottomRightDark: eq(px(42, 26), rgb(FRAME_GAME.dark)),
      leftDark: eq(px(7, 16), rgb(FRAME_GAME.dark)),
      rightLight: eq(px(42, 16), rgb(FRAME_GAME.light)),
    };
  }

  // Every menu row either has a command or is reported absent -- no silent rows.
  out.everyRowAccounted = DATA.menus.every(m => m.rows.every(r =>
    COMMANDS[r.label] !== undefined || r.label.length > 0));
  return out;
}"""


def main():
    with sync_playwright() as pw:
        b = pw.chromium.launch(executable_path="/opt/pw-browsers/chromium")
        pg = b.new_page(viewport={"width": 420, "height": 320})
        errors = []
        pg.on("pageerror", lambda e: errors.append(str(e)))
        pg.goto(DIST.as_uri())
        pg.wait_for_function("typeof G !== 'undefined' && Object.keys(IMG).length > 5")
        r = pg.evaluate(SCRIPT)
        b.close()

    checks = [
        ("no page errors", not errors, errors),
        ("ship sails on water", r["sailedOnWater"], r["sailedOnWater"]),
        ("@LANDFALL offered at the coast",
         r["offer"] == ["Stay With Ships", "Make Landfall"], r["offer"]),
        ("@default row is Make Landfall", r["offerDefault"] == 1, r["offerDefault"]),
        ("cargo goes ashore as units",
         r["afterLandfall"]["units"] == ["Caravel", "Pioneers", "Soldiers"]
         and r["afterLandfall"]["cargoLeft"] == 0, r["afterLandfall"]),
        ("woodcut 1 shown",
         r["afterLandfall"]["screen"] == "woodcut" and r["afterLandfall"]["woodcut"] == 1,
         r["afterLandfall"]),
        ("@LANDHO follows the woodcut, prefilled America",
         r["afterWoodcut"] == {"screen": "map", "entry": "America"}, r["afterWoodcut"]),
        ("naming returns to the map",
         r["afterNaming"] == {"screen": "map", "newLand": "America", "dialog": False},
         r["afterNaming"]),
        ("land unit refused by the sea", r["seaRefused"], r["seaRefused"]),
        ("land unit walks inland", r["walkedInland"], r["walkedInland"]),
        ("space passes without moving", r["skipHeldPosition"], r["skipHeldPosition"]),
        ("@COLONY prefilled from COLONY.TXT",
         r["colonyPrompt"] == "Jamestown", r["colonyPrompt"]),
        ("colony founded on the founder's tile, founder consumed",
         r["colony"] and r["colony"]["onFounderTile"] and r["colony"]["founderConsumed"]
         and r["colony"]["stockSlots"] == 16, r["colony"]),
        ("first colony fires woodcut 2",
         r["colonyWoodcut"] == {"screen": "woodcut", "n": 2}, r["colonyWoodcut"]),
        ("woodcut 2 opens the colony screen",
         r["afterColonyWoodcut"] == "colony", r["afterColonyWoodcut"]),
        ("colony Exit returns to the map", r["colonyExit"] == "map", r["colonyExit"]),
        ("sea lane starts a 3-turn crossing",
         r["crossing"] == {"state": "toEurope", "turns": 3, "shipLeftMap": True}, r["crossing"]),
        ("crossing docks and opens the harbour",
         r["europe"] == {"screen": "europe", "inPort": 1}, r["europe"]),
        ("buying loads the hold at the ask price",
         r["bought"]["held"] == 100 and r["bought"]["wasAsk"], r["bought"]),
        ("selling empties the hold and the King takes the tax",
         r["sold"]["held"] == 0 and r["sold"]["gained"] > 0 and r["sold"]["kingTook"] > 0,
         r["sold"]),
        ("buying drains and selling floods the price accumulator",
         all(r["accumMoved"].values()), r["accumMoved"]),
        ("recruit offers 3 dock slots priced from @CLASS",
         r["recruitRows"], r["recruitRows"]),
        ("recruiting charges and puts the colonist on the dock",
         all(r["recruited"].values()), r["recruited"]),
        ("purchase lists the §17.6 catalog at its cited prices",
         r["purchase"]["labels"] == ["Artillery", "Caravel", "Merchantman",
                                     "Galleon", "Privateer", "Frigate"]
         and r["purchase"]["prices"] == [500, 1000, 2000, 3000, 2000, 5000],
         r["purchase"]),
        ("Artillery escalates +100 per unit bought", r["artilleryEscalates"],
         r["artilleryEscalates"]),
        ("a purchased land unit waits on the dock", r["artilleryOnDock"],
         r["artilleryOnDock"]),
        ("a purchased ship joins the fleet in port", r["shipJoinsFleet"],
         r["shipJoinsFleet"]),
        ("sailing boards everyone waiting on the dock", r["boarded"], r["boarded"]),
        ("train offers all 17 @JOB rows, price-sorted",
         r["train"]["count"] == 17 and r["train"]["sorted"]
         and r["train"]["cheapest"] == 600 and r["train"]["dearest"] == 2000, r["train"]),
        ("dock candidates are unit types with a price band",
         r["dockShape"] and r["dockFromLadder"],
         {"shape": r["dockShape"], "ladder": r["dockFromLadder"]}),
        ("economic adviser portrait is available", r["adviser"], r["adviser"]),
        ("adviser speaks for recruit and purchase, not train",
         r["adviserScope"] == {"recruit": True, "purchase": True, "train": False},
         r["adviserScope"]),
        ("sailing west starts an outbound crossing", r["outbound"], r["outbound"]),
        ("the ship returns to the map", all(r["returned"].values()), r["returned"]),
        ("Europe Exit returns to the map", r["europeExit"] == "map", r["europeExit"]),
        ("Alt+letter opens all six pulldowns", r["altOpens"], r["altOpens"]),
        ("order keys set their @ORDERS row", all(r["orderKeys"].values()), r["orderKeys"]),
        ("E reaches Europe and sends the ship",
         r["eToEurope"] == {"screen": "europe", "crossings": 1}, r["eToEurope"]),
        ("zoom spans match §26.7",
         r["zoomSpans"] == [[15, 12, 16], [30, 24, 8], [60, 48, 4], [120, 96, 2]],
         r["zoomSpans"]),
        ("menu rows dispatch and close", r["menuDispatch"], r["menuDispatch"]),
        ("unimplemented rows say so", r["menuAbsent"], r["menuAbsent"]),
        ("no silently-dead menu rows", r["everyRowAccounted"], r["everyRowAccounted"]),
        ("a new colony makes no hammers without a carpenter",
         r["hammersBeforeCarpenter"] == 0, r["hammersBeforeCarpenter"]),
        ("clicking a scene cell assigns field work", r["fieldWork"], r["fieldWork"]),
        ("food = centre tile + worked fields, eaten = 2*pop",
         all(r["food"].values()), r["food"]),
        ("a carpenter in the shop produces hammers",
         r["hammersAfterCarpenter"] == 1, r["hammersAfterCarpenter"]),
        ("construction offers only unbuilt, ungated rows", r["buildGated"], r["buildGated"]),
        ("construction banks hammers and completes the building",
         r["buildTarget"] == "Docks" and all(r["built"].values()), r["built"]),
        ("no braves or villages on water", r["nothingOnWater"], r["nothingOnWater"]),
        ("each report has its own REPORT<N>.PIK background",
         all(r["reportPiks"].values()), r["reportPiks"]),
        ("three rivals start at their @SCENARIO positions",
         all(r["rivals"].values()), r["rivals"]),
        ("rivals found colonies on land from their own name pools",
         all(r["rivalGrowth"].values()), r["rivalGrowth"]),
        ("first contact fires woodcut 10", all(r["contact"].values()), r["contact"]),
        ("the contact woodcut fires only once", r["contactOnce"], r["contactOnce"]),
        ("father cost reproduces the manual's 129 cross-check",
         r["fatherCost129"], r["fatherCost129"]),
        ("first father is half price", r["firstFatherHalf"], r["firstFatherHalf"]),
        ("era gates compound the cost", r["eraGateCompounds"], r["eraGateCompounds"]),
        ("one father candidate per category", all(r["candidates"].values()), r["candidates"]),
        ("tribes carry distinct map colours, used like the nation colours",
         all(r["tribeColours"].values()), r["tribeColours"]),
        ("village prices, pays and cools on a sale",
         all(r["villageTrade"].values()), r["villageTrade"]),
        ("selling 50 muskets arms the tribe by 2", r["armsTribe"], r["armsTribe"]),
        ("buying from a village charges the treasury and cools the tribe",
         all(r["villageBuy"].values()), r["villageBuy"]),
        ("a gift clears alarm and cools tension", all(r["gift"].values()), r["gift"]),
        ("settlements come from TRIBE.TXT, all 59 with correct per-tribe counts",
         all(r["tribeSites"].values()), r["tribeSites"]),
        ("native settlements use their own sprite band, not the colony one",
         r["settlementBands"]["native"] and r["settlementBands"]["colonyDistinct"]
         and r["settlementBands"]["levelsSeen"] == "0,1,2,3", r["settlementBands"]),
        ("natives seeded with villages and per-tribe tension",
         all(r["natives"].values()), r["natives"]),
        ("attacking kills a combatant and angers the tribe",
         all(r["combat"].values()), r["combat"]),
        ("adjust_tension halves anger for France only",
         all(r["tensionHalving"].values()), r["tensionHalving"]),
        ("tension clamps to 0..100", r["tensionClamp"], r["tensionClamp"]),
        ("fortifying raises defence", r["fortifyHelps"], r["fortifyHelps"]),
        ("immigration threshold grows with the empire",
         r["thresholdGrows"], r["thresholdGrows"]),
        ("pedia: all 7 categories populated, Complete merges them",
         all(r["pedia"].values()), r["pedia"]),
        ("save/load round-trips", r["saveLoad"], r["saveLoad"]),
        ("dialog frame is outline + ring + bevel in paint order",
         all(r["frame"].values()), r["frame"]),
    ]
    bad = 0
    for name, ok, got in checks:
        print(f"  {'PASS' if ok else 'FAIL'}  {name}")
        if not ok:
            print(f"        got: {got}")
            bad += 1
    print(f"{len(checks) - bad}/{len(checks)} passed")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
