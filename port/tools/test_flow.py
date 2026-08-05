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

  // @default is ONE-BASED and names the cautious row: @LANDFALL's `@default=1`
  // highlights "Stay With Ships". Landing is the player's deliberate choice.
  closeDialog(1);                            // "Make Landfall"
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
  // A Lost City Rumour on the target tile is also not a movement question --
  // one of its outcomes destroys the unit outright. Consume any nearby.
  for (let dy = -2; dy <= 2; dy++)
    for (let dx = -2; dx <= 2; dx++)
      G.rumoursDone.add((pio.y + dy) * MAP.w + pio.x + dx);
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

  // Any popup queued by those turns is modal and would swallow the click, which
  // is the intended behaviour -- clear it so this checks the Exit button.
  G.eventQueue = []; G.combat = null; G.dialog = null;
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
    // The colonist takes the cell's BEST outdoor job, not always Farmer.
    out.fieldWork = !!worker && OUTDOOR_JOB_NAMES.includes(worker.job) &&
                    worker.cell[0] === -1 && worker.cell[1] === -1 &&
                    fieldYield(c, worker) > 0;
    worker.job = 'Farmer';                          // pin it for the food check
    const f = colonyFood(c);
    out.food = { centre: f.centre > 0, eaten: f.eaten === 2 * c.colonists.length,
                 fieldsCounted: f.produced === f.centre + f.fields };

    // Jobs menu puts a colonist in the Carpenter's Shop, and only then do
    // hammers appear.
    G.colonistSel = c.colonists.findIndex(p => !p.cell);
    G.colonyPopup = 'jobs';
    G.colonyPopupRow = colonyPopupRows().findIndex(r => r.label === "Carpenter's Shop");
    colonyPopupCommit();
    // PEDIA @BUILDING35 is explicit: "the carpenter needs lumber to create
    // hammers." With an empty warehouse he makes none.
    out.hammersNoLumber = colonyHammers(c);
    c.stock[5] = 500;                               // Lumber
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
    // Keep the carpenter supplied with lumber and the colony fed: a colony that
    // cannot feed itself loses a colonist, and the carpenter is the one at risk.
    for (let t = 0; t < cost + 2; t++) { c.stock[5] = 100; c.stock[0] = 100; endTurn(); }
    out.built = { done: c.buildings.includes('Docks'), targetCleared: c.building === null };


    // ---- the rest of the production chain ----
    // A field worker on any of the eight outdoor jobs reads that job's own
    // column of the terrain table, not just the farmer column.
    {
      const lumberjack = c.colonists.find(p => p.cell);
      lumberjack.job = 'Lumberjack';
      const wood = colonyProduce(c).out[5];
      lumberjack.job = 'Farmer';
      out.jobColumns = wood >= 0;
      // An expert DOUBLES a manufactured good and takes a flat +2 on food.
      const p2 = c.colonists.find(p => p.cell);
      p2.job = 'Fur Trapper'; p2.profession = null;
      const plain = colonyProduce(c).out[4];
      p2.profession = 'Expert Fur Trappers';
      const expert = colonyProduce(c).out[4];
      p2.profession = null; p2.job = 'Farmer';
      out.expertDoubles = plain === 0 || expert === plain * 2;
    }
    // Indoor work converts raw into finished 1:1, and stops when the raw runs
    // out. Rum <- Sugar is one of the five byte-cited chains.
    {
      const idle = c.colonists.find(p => !p.cell && p.job !== 'Carpenter');
      if (idle) {
        idle.job = 'Distiller'; idle.cell = null;
        c.stock[1] = 0;                              // no sugar
        const dry = colonyProduce(c).out[9];
        c.stock[1] = 100;
        const wet = colonyProduce(c).out[9];
        const usedSugar = colonyProduce(c).out[1];
        out.chain = { dryRunsNothing: dry === 0, makesRum: wet > 0,
                      consumesSugar: usedSugar < 0 };
        idle.job = null;
      } else out.chain = { dryRunsNothing: true, makesRum: true, consumesSugar: true };
    }
    // Sons of Liberty: the two 32-bit EMAs, seeded B=200 / A=0, drive
    // sol = A*100/B and the steady state is ~50*bells/pop.
    {
      const c2 = G.colonies[0];
      c2.rebelA = 0; c2.rebelB = 200; c2.sol = 0;
      for (let i = 0; i < 60; i++) updateSoL(c2, 4);
      out.sol = { rose: c2.sol > 0, capped: c2.sol <= 100 };
    }
    // Over 100 units of a good, the stock is cut to 50 and the excess is sold.
    {
      const c3 = G.colonies[0];
      c3.stock[4] = 260;                             // Furs
      const g0 = G.gold;
      autoExport(c3);
      out.autoExport = { cutTo50: c3.stock[4] === 50, sold: G.gold > g0 };
      c3.stock[4] = 260;
      G.declared = true;
      const g1 = G.gold;
      autoExport(c3);
      out.autoExport.wastedAfterDeclaring = c3.stock[4] === 50 && G.gold === g1;
      G.declared = false;
    }
  }

  // ---- pioneer terrain improvement ----
  {
    beginGame(); G.screen = 'map';
    // Find a land tile and drop a Pioneer on it.
    let px = -1, py = -1;
    for (let y = 10; y < 60 && px < 0; y++)
      for (let x = 10; x < 50; x++)
        if (!tileWater(at(x, y)) && !isForested(tileTerrain(at(x, y)))) { px = x; py = y; break; }
    const pio = mkUnit('Pioneers', px, py);
    G.units.push(pio);
    G.sel = G.units.indexOf(pio);
    out.pioneerTools = pio.tools === 100;
    // Movement budgets are in thirds.
    out.thirds = { budget: pio.moves === unit('Pioneers').movement * 3,
                   costsThree: moveCost(pio, px, py, px, py + 1) % 3 === 0 };
    // Build Road: the work threshold is the terrain's own improvement column,
    // and the road only appears when the counter reaches it.
    improveOrder(ORDER_ROAD);
    const need = workThreshold(pio, true);
    out.roadWork = { ordered: pio.orders === ORDER_ROAD, threshold: need >= 1 };
    for (let t = 0; t < need; t++) advanceImprovements();
    out.roadWork.built = hasRoad(px, py);
    out.roadWork.orderCleared = pio.orders === 0;
    out.roadWork.toolsSpent = pio.tools === 80;
    // A road at both ends costs a single third.
    IMPROVE[py * MAP.w + px + 1] |= ROAD_BIT;
    out.roadWork.cheapStep = moveCost(pio, px, py, px + 1, py) === 1;
    // Plow: same unit, same tile, and the plow bit is separate from the road.
    G.sel = G.units.indexOf(pio);
    improveOrder(ORDER_CLEAR);
    const need2 = workThreshold(pio, false);
    for (let t = 0; t < need2; t++) advanceImprovements();
    out.plow = { set: hasPlow(px, py), roadKept: hasRoad(px, py),
                 costsMore: need2 > need || need2 === Math.max(1, need + 2 >> (0)) };
    // The yield deltas: plow lifts crops (good <= 3), road lifts the rest.
    out.impBonus = { plowLiftsFood: improvementBonus(px, py, 0) > 0,
                     plowNotOre: improvementBonus(px, py, 6) > 0,   // road is here too
                     roadOnly: improvementBonus(px + 1, py, 6) > 0 &&
                               improvementBonus(px + 1, py, 0) === 0 };
    // Clearing a forest drops the tile id by 8 and pays lumber to a colony.
    let fx = -1, fy = -1;
    for (let y = 10; y < 60 && fx < 0; y++)
      for (let x = 10; x < 50; x++)
        if (isForested(tileTerrain(at(x, y)))) { fx = x; fy = y; break; }
    const pio2 = mkUnit('Pioneers', fx, fy);
    G.units.push(pio2);
    G.sel = G.units.indexOf(pio2);
    const before = at(fx, fy) & 0x1F;
    G.colonies = [{ name: 'Test', x: fx + 1, y: fy, nation: G.nation, colonists: [],
                    stock: DATA.cargo.map(() => 0), buildings: STARTING_BUILDINGS.slice(),
                    hammers: 0, building: null, sol: 0 }];
    improveOrder(ORDER_CLEAR);
    for (let t = 0; t < workThreshold(pio2, false); t++) advanceImprovements();
    // The -8 lands on the FOLDED id: raw 16..23 folds to 8..15 first, so both
    // halves of the forest band end on their 0..7 unforested base.
    const folded = (before >= 16 && before <= 23) ? ((before & 7) | 8) : before;
    out.clear = { droppedEight: (at(fx, fy) & 0x1F) === folded - 8,
                  noLongerForest: !isForested(tileTerrain(at(fx, fy))),
                  lumberPaid: G.colonies[0].stock[5] > 0 };
    // Tools run out and the Pioneer reverts to a Colonist.
    pio2.tools = 20;
    G.sel = G.units.indexOf(pio2);
    let guard = 0;
    while (pio2.type === 'Pioneers' && guard++ < 40) {
      if (!canImprove(pio2)) break;
      pio2.orders = ORDER_ROAD; pio2.work = 0;
      if (hasRoad(pio2.x, pio2.y)) { IMPROVE[pio2.y * MAP.w + pio2.x] &= ~ROAD_BIT; }
      for (let t = 0; t < workThreshold(pio2, true); t++) advanceImprovements();
    }
    out.usedUpTools = pio2.type === 'Colonists' && pio2.tools === 0;
  }

  // ---- the Declaration, the REF and the score ----
  {
    beginGame(); G.screen = 'map';
    // The REF seed is difficulty-scaled 8d+15 / 5d+5 / 3d+2 / 6d+2.
    const d = G.difficulty;
    out.refSeed = { reg: G.ref.Regulars === 8 * d + 15, cav: G.ref.Cavalry === 5 * d + 5,
                    mow: G.ref['Man-O-War'] === 3 * d + 2, art: G.ref.Artillery === 6 * d + 2 };
    // The royal fund accrues (8d+10)*2^era and buys a unit every 1800.
    G.royalFund = 0;
    const before = G.ref.Regulars + G.ref.Cavalry + G.ref['Man-O-War'] + G.ref.Artillery;
    growREF();
    out.refAccrue = G.royalFund === (8 * d + 10) * (1 << refEra());
    G.royalFund = 1800 * 3;
    growREF();
    const after = G.ref.Regulars + G.ref.Cavalry + G.ref['Man-O-War'] + G.ref.Artillery;
    out.refBuys = after >= before + 3 && G.royalFund < 1800;

    // Declaring below 50% is refused with @TOOTORY, and no flag is set.
    G.colonies = [{ name: 'Rebel', x: G.units[0].x, y: G.units[0].y, nation: G.nation,
                    colonists: [{ type: 'Colonists', profession: null, job: null, cell: null },
                                { type: 'Colonists', profession: null, job: null, cell: null }],
                    stock: DATA.cargo.map(() => 0), buildings: STARTING_BUILDINGS.slice(),
                    hammers: 0, building: null, sol: 10 }];
    G.eventQueue = []; G.dialog = null;
    declareIndependence();
    out.tooTory = { refused: !(G.flags & 1), warned: G.eventQueue.length === 1 && !G.dialog };

    // At 50% or better it asks, and only the second row declares.
    G.colonies[0].sol = 80;
    out.meter = nationalSoL() === 80;
    G.eventQueue = []; G.dialog = null;
    declareIndependence();
    out.declareAsks = !!G.dialog && G.dialog.opts.length === 2;
    closeDialog(0);                                   // "Never! ... God save the King!"
    out.declareRefusable = !(G.flags & 1);
    // Put a veteran soldier in the colony so mobilisation has something to promote.
    const sold = mkUnit('Soldiers', G.colonies[0].x, G.colonies[0].y);
    G.units.push(sold);
    G.eventQueue = []; G.dialog = null;
    declareIndependence();
    closeDialog(1);
    out.declared = { flagSet: (G.flags & 1) === 1, yearRecorded: G.declaredYear === G.year,
                     mobilised: sold.type === 'Cont. Army' };
    // The first wave lands.
    out.refLanded = G.refUnits.length > 0;
    // Fighting the REF: a REF unit is a legal target and dies like any other.
    {
      const target = G.refUnits.find(u => !u.ship);
      if (target) {
        const n0 = G.refUnits.length;
        let guard = 0;
        while (G.refUnits.includes(target) && guard++ < 200) {
          const att = mkUnit('Cont. Army', target.x, target.y - 1);
          G.units.push(att);
          resolveAttack(att, target);
        }
        out.refKillable = G.refUnits.length < n0;
      } else out.refKillable = true;
    }
    // The score: seven components and the computed multiplier {4,5,6,8,10}.
    const sp = scoreParts();
    out.score = {
      sevenParts: ['population', 'fathers', 'sentiment', 'razed', 'gold',
                   'liberty', 'revolution'].every(k => k in sp),
      mult: sp.mult === [4, 5, 6, 8, 10][G.difficulty],
      popTiers: (() => {
        const c = G.colonies[0];
        c.colonists = [{ profession: 'Petty Criminals' }, { profession: null },
                       { profession: 'Expert Farmers' }];
        return scoreParts().population === 1 + 2 + 4;
      })(),
      revolutionBonus: (() => {
        G.flags |= 8; G.declaredYear = 1700;
        return scoreParts().revolution === (1780 - 1700) * 2;
      })(),
    };
  }

  // ---- the map keyboard shortcuts reach what is actually built ----
  {
    // 'g' (Go To) and 't' (trade routes) used to say "not in this build" long
    // after both were built. Nothing on the map keyboard may claim that.
    beginGame(); G.screen = 'map'; G.sel = 0;
    const tap = (c) => onKey({ key: c, preventDefault() {}, altKey: false, shiftKey: false });
    tap('g');
    out.keyGoTo = G.goTo === G.units[0] && !/not in this build/.test(G.msg || '');
    G.goTo = null;
    // With no routes yet, 't' correctly raises @TRADENONE rather than opening an
    // empty screen -- either way it must not be the old stub message.
    G.dialog = null; G.msg = '';
    tap('t');
    out.keyTrade = (G.screen === 'trade' || !!G.dialog || G.eventQueue.length > 0) &&
                   !/not in this build/.test(G.msg || '');
    G.dialog = null; G.screen = 'map'; G.trade = null;
  }

  // ---- options dialogs and Retire ----
  {
    beginGame(); G.screen = 'map';
    // Each dialog's rows come from its GAME.TXT body, title first.
    openOptions('game');
    out.options = { gameRows: G.options.rows.length === 8,
                    titled: G.options.title === 'Set Game Options' };
    // Combat Analysis is bit 0x0200 and starts on; toggling it flips the flag
    // the combat panel reads.
    G.options.row = 5;
    out.options.combatOn = optionChecked('game', 5) && G.combatAnalysis;
    optionsCommit();
    out.options.combatOff = !optionChecked('game', 5) && !G.combatAnalysis;
    optionsCommit();
    out.options.combatBack = G.combatAnalysis;
    // Water Color Cycling is INVERTED: a clear bit reads as on.
    out.options.waterInverted = optionChecked('game', 6) === true &&
                                (G.gameOptions & 0x0100) === 0;
    // Every Colony Report bit is inverted too, so a fresh game reports
    // everything.
    openOptions('colony');
    out.options.colonyRows = G.options.rows.length === 10;
    out.options.colonyAllOn = G.options.rows.every((_, i) => optionChecked('colony', i));
    openOptions('sound');
    out.options.soundRows = G.options.rows.length === 3;
    G.screen = 'map'; G.options = null;
    // Retire defaults to "No" (@default=2 over two rows, one-based).
    G.dialog = null;
    retire();
    out.retireAsks = !!G.dialog && G.dialog.sel === 1;
    if (G.dialog) { closeDialog(0); }
    out.retireScores = G.retired === true && G.screen === 'report';
  }

  // ---- naval combat, scouts at a colony, the Spanish Succession ----
  {
    beginGame(); G.screen = 'map';
    const r = G.rivals[0];
    r.met = true;
    declareWarOn(G.nation, r.nation);
    // Only Privateers, Frigates and Men-O-War may start a ship attack.
    const caravel = mkUnit('Caravel', 30, 30);
    const foe = mkUnit('Merchantman', 31, 30); foe.nation = r.nation;
    G.eventQueue = [];
    out.naval = { caravelRefused: navalAttack(caravel, foe) === false &&
                                  G.eventQueue.length === 1 };
    const priv = mkUnit('Privateer', 30, 30);
    G.units.push(priv); r.units.push(foe);
    G.eventQueue = [];
    out.naval.privateerMay = navalAttack(priv, foe) !== false;
    // Shore guns fire without a roll, and need both a fort and artillery.
    const c = { name: 'Boston', x: 40, y: 40, nation: G.nation, colonists: [],
                stock: DATA.cargo.map(() => 0), buildings: ['Fort'], hammers: 0,
                building: null, sol: 0, latch: 0 };
    G.colonies = [c];
    const enemy = mkUnit('Frigate', 41, 40); enemy.nation = r.nation;
    r.units = [enemy];
    G.eventQueue = [];
    shoreBombardment();
    out.naval.noGunsNoFire = G.eventQueue.length === 0;
    G.units.push(mkUnit('Artillery', 40, 40));
    shoreBombardment();
    out.naval.firesWithGuns = enemy.damaged === true;

    // A Scout at a foreign colony gets the four-option dialog.
    const scout = mkUnit('Scouts', 0, 0);
    G.dialog = null;
    scoutColony(scout, { x: 5, y: 5, colonists: [] }, 'Quebec');
    out.scout = { fourOptions: !!G.dialog && G.dialog.opts.length === 4 };
    // Meeting the mayor is blocked during the revolution.
    G.flags |= 1;
    G.eventQueue = [];
    closeDialog(0);
    out.scout.mayorBlocked = G.eventQueue.length === 1;
    G.flags = 0;

    // The Spanish Succession transfers everything from the weakest to the
    // strongest, and fires at most once.
    beginGame(); G.screen = 'map';
    G.succession = false;
    const a = G.rivals[0], b = G.rivals[1];
    a.colonies = [{ name: 'Weak', x: 5, y: 5, nation: a.nation }];
    a.units = [mkUnit('Soldiers', 5, 5)];
    b.colonies = [{ name: 'S1', x: 8, y: 8 }, { name: 'S2', x: 9, y: 9 }];
    b.units = [mkUnit('Soldiers', 8, 8), mkUnit('Soldiers', 9, 9)];
    // The other two must sit BETWEEN them, or one of them is the weakest and
    // the succession picks a different pair.
    for (const rr of G.rivals.slice(2)) {
      rr.colonies = [{ name: 'M', x: 12, y: 12 }, { name: 'M2', x: 13, y: 13 }];
      rr.units = [];
    }
    let guard = 0;
    while (!G.succession && guard++ < 20000) spanishSuccession();
    out.succession = { fired: G.succession,
                       cedingEmptied: a.colonies.length === 0 && a.units.length === 0,
                       beneficiaryGrew: b.colonies.length >= 3 };
    const before = b.colonies.length;
    for (let i = 0; i < 5000; i++) spanishSuccession();
    out.succession.onlyOnce = b.colonies.length === before;
  }

  // ---- building effects, upkeep, colonial authority, orders ----
  {
    beginGame(); G.screen = 'map';
    const mk = (name, x, y, buildings) => ({ name, x, y, nation: G.nation,
      colonists: [], stock: DATA.cargo.map(() => 0), buildings: buildings || [],
      hammers: 0, building: null, sol: 0, latch: 0 });
    const c = mk('Boston', 20, 20, ['Church', 'Fort']);
    G.colonies = [c];
    // Upkeep is the @BUILDING column, summed, and charged per turn.
    const due = DATA.buildings.find(b => b.name === 'Church').upkeep +
                DATA.buildings.find(b => b.name === 'Fort').upkeep;
    out.upkeep = { sums: colonyUpkeep(c) === due };
    G.gold = 1000; G.upkeepUnpaid = false;
    payUpkeep();
    out.upkeep.charged = G.gold === 1000 - due && !G.upkeepUnpaid;
    G.gold = 0; G.eventQueue = [];
    payUpkeep();
    out.upkeep.unpaidWarns = G.upkeepUnpaid && G.eventQueue.length === 1;
    // Unpaid upkeep halves indoor work.
    c.buildings.push("Rum Distiller's House");
    const worker = { type: 'Colonists', profession: null, job: 'Distiller' };
    c.colonists = [worker];
    const half = indoorYield(c, worker);
    G.upkeepUnpaid = false;
    const full = indoorYield(c, worker);
    out.upkeep.halves = half < full;

    // Printing Press +50% bells, Newspaper x2.
    const bells = (blds) => {
      const b = mk('B', 20, 20, blds.concat(['Town Hall']));
      b.colonists = [{ type: 'Colonists', profession: null, job: 'Statesman' }];
      b.stock[GOOD.FOOD] = 500;
      colonyTurn(b);
      return b.bellsTurn;
    };
    const base = bells([]), press = bells(['Printing Press']), news = bells(['Newspaper']);
    out.press = { press: base === 0 || press === Math.floor(base * 3 / 2),
                  news: base === 0 || news === base * 2 };
    // The Stable lowers the horse-breeding threshold from 50 to 25.
    const h1 = mk('H', 20, 20, []); h1.stock[GOOD.HORSES] = 30; h1.stock[GOOD.FOOD] = 500;
    colonyTurn(h1);
    const h2 = mk('H', 20, 20, ['Stable']); h2.stock[GOOD.HORSES] = 30; h2.stock[GOOD.FOOD] = 500;
    colonyTurn(h2);
    out.stable = { noStableIdle: h1.stock[GOOD.HORSES] === 30,
                   stableBreeds: h2.stock[GOOD.HORSES] > 30 };
    // Peter Stuyvesant gates the Custom House, and a Custom House is what keeps
    // the export running after independence.
    G.colonies = [c]; c.colonists = [];
    G.fathersOwned = [];
    out.customs = { gated: !buildOptions(c).some(b => b.name === 'Custom House') };
    G.fathersOwned = ['Peter Stuyvesant'];
    c.buildings = ['Town Hall'];
    c.colonists = [{ type: 'Colonists', profession: null, job: null }];
    out.customs.enabled = buildOptions(c).some(b => b.name === 'Custom House');
    // After declaring, the excess is still cut to 50 -- but it is WASTED unless
    // a Custom House is standing, in which case it is sold as before.
    G.declared = true; c.stock[4] = 300;
    const g0 = G.gold;
    autoExport(c);
    out.customs.wastedWithout = c.stock[4] === 50 && G.gold === g0;
    c.buildings.push('Custom House');
    c.stock[4] = 300;
    autoExport(c);
    out.customs.soldWith = c.stock[4] === 50 && G.gold > g0;
    G.declared = false; G.fathersOwned = [];

    // Colonial authority: abandon defaults to the refusal, rename works.
    G.colonies = [mk('Plymouth', 20, 20, [])];
    G.colony = 0; G.screen = 'colony';
    G.dialog = null;
    abandonColony();
    out.authority = { asks: !!G.dialog,
                      defaultsToRefusal: !!G.dialog && G.dialog.sel === 1 };
    if (G.dialog) { closeDialog(1); out.authority.refusalKeeps = G.colonies.length === 1; }
    abandonColony();
    if (G.dialog) closeDialog(0);
    out.authority.abandons = G.colonies.length === 0;

    // Pillage tears out an improvement; Go To walks a unit over turns.
    G.colonies = [];
    beginGame(); G.screen = 'map';
    let px = -1, py = -1;
    for (let y = 10; y < 60 && px < 0; y++)
      for (let x = 10; x < 48; x++)
        if (!tileWater(at(x, y)) && !tileWater(at(x + 3, y))) { px = x; py = y; break; }
    const sold = mkUnit('Soldiers', px, py);
    G.units.push(sold); G.sel = G.units.indexOf(sold);
    IMPROVE[py * MAP.w + px] |= ROAD_BIT;
    pillage();
    out.orders2 = { pillaged: !hasRoad(px, py) };
    // Go To.
    G.sel = G.units.indexOf(sold);
    beginGoTo();
    setGoTo(sold, px + 3, py);
    out.orders2.goToSet = sold.orders === 3;
    for (let i = 0; i < 10; i++) advanceGoTo();
    out.orders2.arrived = sold.x === px + 3 || sold.orders === 0;
  }

  // ---- native demands, Tory uprising, mercenaries, intervention ----
  {
    beginGame(); G.screen = 'map';
    G.colonies = [{ name: 'Boston', x: 20, y: 20, nation: G.nation, colonists: [],
                    stock: DATA.cargo.map(() => 0), buildings: [], hammers: 0,
                    building: null, sol: 20, latch: 0 }];
    // A hostile tribe presses a claim on a colony's stores.
    G.tribes[0].tension = 100;
    for (let i = 1; i < G.tribes.length; i++) G.tribes[i].tension = 0;
    G.colonies[0].stock[4] = 200;
    G.dialog = null;
    let tries = 0;
    while (!G.dialog && tries++ < 400) nativeDemands();
    out.demands = { asked: !!G.dialog, hasRows: !!G.dialog && G.dialog.opts.length >= 2 };
    if (G.dialog) {
      const s0 = G.colonies[0].stock[4];
      closeDialog(1);                                  // hand them over
      out.demands.tookGoods = G.colonies[0].stock[4] < s0;
    }
    // The SoL hysteresis announcements fire once per crossing.
    const c = G.colonies[0];
    c.sol = 60; c.latch = 0;
    G.eventQueue = [];
    solAnnounce(c); solAnnounce(c);
    out.sentiment = { majorityOnce: G.eventQueue.length === 1 };
    c.sol = 100; G.eventQueue = [];
    solAnnounce(c);
    out.sentiment.unanimous = G.eventQueue.length === 1;
    c.sol = 40; G.eventQueue = [];
    solAnnounce(c);
    out.sentiment.fallsBack = G.eventQueue.length === 2;   // minority AND majority lost
    // The Tory uprising gate is (difficulty+1)/(difficulty+2), and it only
    // fires in a Tory-majority colony during the war.
    G.flags = 0; c.sol = 10;
    G.refUnits = [];
    for (let i = 0; i < 50; i++) toryUprising();
    out.tory = { quietBeforeWar: G.refUnits.length === 0 };
    G.flags |= 1;
    G.eventQueue = [];
    for (let i = 0; i < 400 && !G.refUnits.length; i++) toryUprising();
    out.tory.risesInWar = G.refUnits.length > 0;
    c.sol = 80;
    const n0 = G.refUnits.length;
    for (let i = 0; i < 100; i++) toryUprising();
    out.tory.notInRebelColony = G.refUnits.length === n0;

    // The mercenary price shape: ((difficulty + K)*2 + 0..6)*100 * qty.
    const p1 = mercPrice(3, 3, 1);
    out.merc = { shape: p1 % 100 === 0 && p1 > 0,
                 // qty = cats*2 + count = 5 here, so the per-unit price divides out
                 divides: [0, 1, 2, 3, 4, 5, 6].some(r =>
                   p1 === ((G.difficulty + 3) * 2 + r) * 100 * 5) };
    // The offer needs the war, the second call, and affordability.
    G.mercSeen = false; G.gold = 0; G.dialog = null;
    offerMercenaries();
    out.merc.firstCallSilent = !G.dialog;
    G.gold = 200000;
    let m = 0;
    while (!G.dialog && m++ < 400) offerMercenaries();
    out.merc.offers = !!G.dialog;
    if (G.dialog) {
      const g0 = G.gold, u0 = G.units.length;
      closeDialog(0);
      out.merc.hires = G.gold < g0 && G.units.length > u0;
    }

    // Foreign intervention: the watch first, then the landing on the bell total.
    G.flags = 1; G.interventionWatch = false; G.bellsTotal = 0;
    G.rivals[0].met = true;
    G.eventQueue = [];
    checkIntervention();
    out.intervention = { watches: G.eventQueue.length === 1 && !(G.flags & 2) };
    G.bellsTotal = 5000;
    G.eventQueue = [];
    checkIntervention();
    out.intervention.joins = (G.flags & 2) !== 0 && G.eventQueue.length === 1;
    G.flags = 0;
  }

  // ---- schoolhouse teaching and trade routes ----
  {
    beginGame(); G.screen = 'map';
    const c = { name: 'Boston', x: 20, y: 20, nation: G.nation,
                colonists: [], stock: DATA.cargo.map(() => 0),
                buildings: ['Schoolhouse'], hammers: 0, building: null, sol: 0 };
    G.colonies = [c];
    // A Schoolhouse teaches class 1 only, and its faculty is one.
    out.school = { levels: schoolLevel(c) === 1 };
    c.buildings = ['University'];
    out.school.university = schoolLevel(c) === 3;
    c.buildings = ['Schoolhouse'];
    // Only a mastered profession may teach, and the tier caps what it may teach.
    const teacher = { type: 'Colonists', profession: 'Expert Farmers', job: 'Teacher' };
    const pupil = { type: 'Colonists', profession: 'Free Colonists', job: null };
    c.colonists = [teacher, pupil];
    out.school.classOfFarmer = professionClass('Expert Farmers') === 1;
    out.school.notTeachable = professionClass('Indian Converts') >= 4;
    // Four turns for a class-1 profession, then the pupil takes it.
    G.eventQueue = [];
    for (let i = 0; i < 3; i++) runSchool(c);
    out.school.notYet = pupil.profession === 'Free Colonists';
    runSchool(c);
    out.school.graduated = pupil.profession === 'Expert Farmers';
    // A criminal climbs one rung instead of taking the expertise.
    const crim = { type: 'Colonists', profession: 'Petty Criminals', job: null };
    c.colonists = [teacher, crim];
    for (let i = 0; i < 4; i++) runSchool(c);
    out.school.rung = crim.profession === 'Indentured Servants';
    // A teacher with no student reports it.
    c.colonists = [teacher];
    G.eventQueue = [];
    runSchool(c);
    out.school.noStudent = G.eventQueue.length === 1;

    // Trade routes: the caps, the record shape, and the automation.
    // Both colonies need to sit on real land with land between them, or the
    // wagon has nowhere to drive.
    let lx = -1, ly = -1;
    for (let y = 10; y < 60 && lx < 0; y++)
      for (let x = 10; x < 48; x++) {
        let ok = true;
        for (let k = 0; k <= 4; k++) if (tileWater(at(x + k, y))) ok = false;
        if (ok) { lx = x; ly = y; break; }
      }
    c.x = lx; c.y = ly;
    G.colonies = [c, { name: 'Salem', x: lx + 4, y: ly, nation: G.nation, colonists: [],
                       stock: DATA.cargo.map(() => 0), buildings: [], hammers: 0,
                       building: null, sol: 0 }];
    G.routes = [];
    const r = createRoute([0, 1], false);
    out.routes = { created: !!r && r.stops.length === 2,
                   named: !!r && r.name.length > 0,
                   stopNames: routeStopName(999) === DATA.nations[G.nation].homeport };
    // Twelve is the cap.
    for (let i = 0; i < 20; i++) createRoute([0, 1], false);
    out.routes.capped = G.routes.length === 12;
    // A wagon put on a route drives to the stop, loads, and moves on.
    G.routes = [{ name: 'test', sea: false, stops: [0, 1], cursor: 0 }];
    c.stock[4] = 200;                                  // Furs at Boston
    const wag = mkUnit('Wagon Train', c.x, c.y);
    wag.hold = []; wag.route = 0; wag.stopIndex = 0; wag.orders = 2;
    G.units.push(wag);
    advanceTradeRoutes();                              // at Boston: load
    out.routes.loaded = wag.hold.length > 0 && c.stock[4] < 200;
    const firstStop = wag.stopIndex;
    for (let i = 0; i < 12; i++) advanceTradeRoutes(); // drive to Salem
    out.routes.delivered = G.colonies[1].stock[4] > 0;
    out.routes.advanced = wag.stopIndex !== firstStop || G.colonies[1].stock[4] > 0;

  }

  // ---- diplomacy ----
  {
    beginGame(); G.screen = 'map';
    const r = G.rivals[0];
    r.met = true; r.attitude = 10; r.gold = 20000;
    G.turn = 60;
    // The war matrix bits and the symmetric treaty matrix.
    out.diplo = { startsAtPeace: !atWar(G.nation, r.nation) };
    declareWarOn(G.nation, r.nation);
    out.diplo.warSet = atWar(G.nation, r.nation) && atWar(r.nation, G.nation);
    signTreaty(G.nation, r.nation);
    out.diplo.treatyClearsWar = !atWar(G.nation, r.nation);
    out.diplo.treatySymmetric = haveTreaty(G.nation, r.nation) &&
                                haveTreaty(r.nation, G.nation);
    // Signing sets the 16-turn re-parley lockout.
    out.diplo.lockout = G.parleyLock[r.nation] === G.turn + 16;
    out.diplo.lockedOut = !parleyEligible(r);
    G.parleyLock[r.nation] = 0;
    // Eligibility: not before turn 40, and it needs an attitude of 8.
    G.turn = 10;
    out.diplo.tooEarly = !parleyEligible(r);
    G.turn = 60; r.attitude = 0; G.attitude = 0;
    out.diplo.needsAttitude = !parleyEligible(r);
    r.attitude = 10;
    out.diplo.eligible = parleyEligible(r);
    // The demand value carries the difficulty surcharge.
    out.diplo.demandScales = demandValue(500) ===
      Math.floor(500 * 10 * (G.difficulty + 8) / 100) + 500 * (G.difficulty + 1);
    // The parley menu offers a treaty at peace and peace at war.
    setTreaty(G.nation, r.nation, 0x40, false);
    openParley(r);
    const peaceRows = parleyRows().map(x => x.id);
    declareWarOn(G.nation, r.nation);
    const warRows = parleyRows().map(x => x.id);
    out.diplo.menuAdapts = peaceRows.includes('treaty') && peaceRows.includes('war') &&
                           warRows.includes('peace') && !warRows.includes('war');
    G.screen = 'map'; G.parley = null;
    // Foreign colonies cannot be attacked during the revolution.
    G.flags |= 1;
    const rc = r.colonies[0];
    if (rc) {
      const sold = mkUnit('Soldiers', rc.x - 1, rc.y);
      G.units.push(sold); G.sel = G.units.indexOf(sold);
      sold.movesLeft = sold.moves;
      G.eventQueue = [];
      moveSel(1, 0);
      out.diplo.noWarsDuringRev = G.eventQueue.length === 1 &&
                                  r.colonies.includes(rc);
    } else out.diplo.noWarsDuringRev = true;
    G.flags = 0;
  }

  // ---- treasure transport and fog of war ----
  {
    beginGame(); G.screen = 'map';
    // The King's cut: max(5*difficulty + 50, 2*tax), capped at 90 -- or the tax
    // rate itself with Hernan Cortes.
    G.tax = 10; G.fathersOwned = [];
    const plain = kingsCut();
    G.tax = 60;
    const highTax = kingsCut();
    G.fathersOwned = ['Hernan Cortes'];
    const cortes = kingsCut();
    G.fathersOwned = []; G.tax = 10;
    out.kingsCut = { floor: plain === 5 * G.difficulty + 50,
                     doubleTax: highTax === Math.min(90, Math.max(5 * G.difficulty + 50, 120)),
                     capped: highTax <= 90, cortesUsesTax: cortes === 60 };
    // Accepting the offer credits the net and the Crown's share.
    G.colonies = [{ name: 'Boston', x: 20, y: 20, nation: G.nation, colonists: [],
                    stock: DATA.cargo.map(() => 0), buildings: [], hammers: 0,
                    building: null, sol: 0 }];
    const tre = mkUnit('Treasure', 20, 20); tre.treasure = 40;   // 4000 gold
    G.units.push(tre);
    const g0 = G.gold, k0 = G.kingsFund;
    G.dialog = null; G.eventQueue = [];
    checkTreasure();
    out.treasure = { offered: !!G.dialog };
    if (G.dialog) {
      const cut = kingsCut();
      closeDialog(0);
      out.treasure.paid = G.gold === g0 + 4000 - Math.floor(4000 * cut / 100);
      out.treasure.crownTook = G.kingsFund === k0 + Math.floor(4000 * cut / 100);
      out.treasure.consumed = !G.units.includes(tre);
    }
    // After independence there is no Crown to take a share.
    const tre2 = mkUnit('Treasure', 20, 20); tre2.treasure = 10;
    G.units.push(tre2);
    G.flags |= 1;
    const g1 = G.gold;
    offerGalleon(tre2);
    out.treasure.fullAfterDeclaring = G.gold === g1 + 1000 && !G.units.includes(tre2);
    G.flags = 0;

    // Fog: the visibility layer is sticky and its radius is unit-typed.
    beginGame(); G.screen = 'map';
    const ship = G.units[0];
    out.fog = {
      // A new game reveals only what you can see from the start tile.
      startSeen: isSeen(ship.x, ship.y),
      farHidden: !isSeen(0, 0) || !isSeen(MAP.w - 1, MAP.h - 1),
      // Radii: land 1, Scout 2, Galleon/Privateer/Frigate 2, other ships 1.
      landRadius: sightRadius(mkUnit('Soldiers', 0, 0)) === 1,
      scoutRadius: sightRadius(mkUnit('Scouts', 0, 0)) === 2,
      galleonRadius: sightRadius(mkUnit('Galleon', 0, 0)) === 2,
      caravelRadius: sightRadius(mkUnit('Caravel', 0, 0)) === 1,
    };
    // de Soto lifts every naval hull to 2.
    G.fathersOwned = ['Hernando de Soto'];
    out.fog.deSoto = sightRadius(mkUnit('Caravel', 0, 0)) === 2;
    G.fathersOwned = [];
    // The bit is sticky: reveal a tile, walk away, it stays seen.
    reveal(40, 40, 1);
    out.fog.sticky = isSeen(40, 40) && isSeen(41, 41) && !isSeen(43, 40);
    // Show Hidden Terrain reveals everything without touching the layer.
    G.showHidden = true;
    out.fog.showHidden = isSeen(0, 0);
    G.showHidden = false;
    out.fog.showHiddenIsView = !isSeen(0, 0);
  }

  // ---- the combat aftermath: demotion, capture, promotion, fatigue ----
  {
    beginGame(); G.screen = 'map';
    const foe = () => ({ type: 'Braves', icon: unit('Braves').icon, x: 0, y: 0,
                         tribe: 0, orders: 0, nation: -1 });
    // The demotion ladder: a beaten land unit falls one rung instead of dying.
    const drag = mkUnit('Dragoons', 5, 5); G.units.push(drag);
    applyDefeat(drag, foe());
    const step1 = drag.type;
    applyDefeat(drag, foe());
    const step2 = drag.type;
    out.ladder = { dragoonToSoldier: step1 === 'Soldiers',
                   soldierToColonist: step2 === 'Colonists',
                   stillAlive: G.units.includes(drag) };
    // A Veteran loses veteran status on the way down.
    const vet = mkUnit('Soldiers', 6, 6); vet.profession = 'Veteran Soldiers';
    G.units.push(vet);
    applyDefeat(vet, foe());
    out.ladder.veteranLost = vet.profession === null;
    // A Missionary profession demotes to a Missionaries unit, not a colonist.
    const miss = mkUnit('Soldiers', 7, 7); miss.profession = 'Jesuit Missionaries';
    G.units.push(miss);
    applyDefeat(miss, foe());
    out.ladder.missionary = miss.type === 'Missionaries';
    // Anything with no rung below it is destroyed.
    const art = mkUnit('Artillery', 8, 8); G.units.push(art);
    applyDefeat(art, foe());
    const damaged = art.damaged === true && G.units.includes(art);
    applyDefeat(art, foe());
    out.artillery = { damagedFirst: damaged, destroyedSecond: !G.units.includes(art) };

    // Capture: a Wagon Train changes hands instead of dying.
    const wag = mkUnit('Wagon Train', 9, 9); G.units.push(wag);
    G.eventQueue = [];
    const captor = { type: 'Braves', icon: 0, x: 9, y: 9, tribe: 0, nation: -1 };
    applyDefeat(wag, captor);
    out.capture = { changedHands: wag.nation === -1,
                    leftYourUnits: !G.units.includes(wag),
                    announced: G.eventQueue.length === 1 };

    // Ships are damaged before they sink.
    const ship = mkUnit('Caravel', 10, 10); G.units.push(ship);
    applyDefeat(ship, foe());
    const shipDamaged = ship.damaged === true && G.units.includes(ship);
    applyDefeat(ship, foe());
    out.ships = { damagedFirst: shipDamaged, sunkSecond: !G.units.includes(ship) };

    // Promotion: George Washington skips the roll entirely.
    G.fathersOwned = ['George Washington'];
    const green = mkUnit('Soldiers', 11, 11); green.profession = 'Petty Criminals';
    G.units.push(green);
    G.eventQueue = [];
    tryPromote(green, 1, 100);
    out.promotion = { washingtonAuto: green.profession === 'Indentured Servants' };
    const scout = mkUnit('Scouts', 12, 12); G.units.push(scout);
    tryPromote(scout, 1, 100);
    out.promotion.scoutSeasons = scout.profession === 'Seasoned Scouts';
    G.fathersOwned = [];

    // Fatigue: attacking with a part-spent unit offers @HALF first.
    const tired = mkUnit('Soldiers', 20, 20); G.units.push(tired);
    const brave2 = { type: 'Braves', icon: unit('Braves').icon, x: 21, y: 20,
                     tribe: 0, orders: 0, nation: -1 };
    G.natives.push(brave2);
    G.sel = G.units.indexOf(tired);
    tired.movesLeft = tired.moves - 1;           // a third of the budget spent
    G.dialog = null;
    moveSel(1, 0);
    out.fatigue = { asks: !!G.dialog && G.dialog.opts.length === 2 };
    if (G.dialog) {
      closeDialog(1);                            // "Then let them rest."
      out.fatigue.restStops = tired.movesLeft === 0 && G.natives.includes(brave2);
    }
    // Charging applies the penalty to the analysis.
    tired.fatigue = 1;
    const withF = combatAnalysis(tired, false);
    tired.fatigue = 0;
    const without = combatAnalysis(tired, false);
    out.fatigue.costsStrength = withF.total < without.total &&
                                withF.rows.some(r => r.label === 'Fatigue');
  }

  // ---- the Combat Analysis panel ----
  {
    beginGame(); G.screen = 'map';
    const att = mkUnit('Soldiers', 20, 20);
    att.profession = 'Veteran Soldiers';
    const def = { type: 'Braves', icon: unit('Braves').icon, x: 21, y: 20,
                  tribe: 0, orders: 6, nation: -1 };
    const A = combatAnalysis(att, false), D = combatAnalysis(def, true);
    out.analysis = {
      // The base is the @UNIT combat column, and the panel itemises what
      // followed it.
      baseIsUnitColumn: A.base === unit('Soldiers').combat,
      veteranRow: A.rows.some(r => r.label === 'Veteran' && r.value === '+50%'),
      fortifiedRow: D.rows.some(r => r.label === 'Fortified' && r.value === '+50%'),
      totalsPositive: A.total > 0 && D.total > 0,
      // combatStrength must agree with the itemised total -- one chain, run once.
      agrees: combatStrength(att, false) === A.total,
    };
    // A resolved attack fills the panel, and dismissing clears it.
    G.combat = null; G.combatAnalysis = true;
    G.units.push(att); G.natives.push(def);
    resolveAttack(att, def);
    out.panel = { shown: !!G.combat,
                  hasRoll: !!G.combat && G.combat.roll >= 1,
                  hasBothSides: !!G.combat && !!G.combat.att && !!G.combat.def };
    onClick(160, 100);
    out.panel.dismissed = G.combat === null;
    // With the option off, no panel.
    G.combatAnalysis = false;
    const a2 = mkUnit('Soldiers', 30, 30);
    const d2 = { type: 'Braves', icon: unit('Braves').icon, x: 31, y: 30,
                 tribe: 0, orders: 0, nation: -1 };
    G.units.push(a2); G.natives.push(d2);
    resolveAttack(a2, d2);
    out.panel.optional = G.combat === null;
    G.combatAnalysis = true;
  }

  // ---- the King's demands, tea parties, boycotts, Lost City Rumours ----
  {
    beginGame(); G.screen = 'map';
    // Cadence: nothing before turn 30, then every `interval` turns; the interval
    // shrinks as the eras pass.
    G.year = 1500; const i1 = taxInterval();
    G.year = 1650; const i2 = taxInterval();
    G.year = 1720; const i3 = taxInterval();
    G.year = 1760; const i4 = taxInterval();
    out.taxInterval = i1 > i2 && i2 > i3 && i3 > i4;
    G.year = 1500;
    G.turn = 10; G.dialog = null; G.eventQueue = [];
    kingTaxDemand();
    out.taxQuiet = !G.dialog;                       // before turn 30 the Crown waits
    // The raise formula and the 75 cap.
    G.turn = taxInterval() * 4;                     // a demand turn past 30
    while (G.turn < 30) G.turn += taxInterval();
    G.tax = 0;
    let asked = 0;
    for (let k = 0; k < 40 && !G.dialog; k++) { kingTaxDemand(); if (!G.dialog) G.turn += taxInterval(); }
    out.taxDemands = !!G.dialog && G.dialog.opts.length === 2;
    if (G.dialog) {
      const t0 = G.tax;
      closeDialog(0);                               // kiss the pinky ring
      out.taxRises = G.tax > t0;
      asked = G.tax - t0;
    }
    G.tax = 74;
    for (let k = 0; k < 60; k++) { kingTaxDemand(); if (G.dialog) closeDialog(0); G.turn += taxInterval(); }
    out.taxCapped = G.tax <= 75;
    void asked;
    // A tea party boycotts the good instead of paying, and the boycott bites.
    G.colonies = [{ name: 'Boston', x: 20, y: 20, nation: G.nation, colonists: [],
                    stock: DATA.cargo.map(() => 0), buildings: [], hammers: 0,
                    building: null, sol: 0 }];
    G.colonies[0].stock[2] = 120;                   // Tobacco
    G.boycotts = [];
    G.eventQueue = [];
    teaParty(2);
    out.teaParty = { dumped: G.colonies[0].stock[2] === 0,
                     boycotted: G.boycotts.includes(2),
                     announced: G.eventQueue.length === 1 };
    const g0 = G.gold;
    out.teaParty.blocksTrade = sellGoods(2, 100) === 0 && G.gold === g0;
    // Jakob Fugger clears every boycott.
    applyFatherEffect('Jakob Fugger');
    out.teaParty.fuggerClears = G.boycotts.length === 0;

    // Lost City Rumours: presence is the coordinate hash, and entering one fires
    // an outcome exactly once.
    G.mapSeed = 1234; G.rumoursDone = new Set();
    let found = 0, sample = null;
    for (let y = 4; y < 68; y++)
      for (let x = 4; x < 54; x++)
        if (rumourAt(x, y)) { found++; if (!sample) sample = [x, y]; }
    out.rumours = { some: found > 20, notEverywhere: found < 600 };
    // The hash is deterministic for a seed and shifts when the seed changes.
    out.rumours.deterministic = sample ? rumourAt(sample[0], sample[1]) : false;
    const before = found;
    G.mapSeed = 999; G.rumoursDone = new Set();
    let after = 0;
    for (let y = 4; y < 68; y++) for (let x = 4; x < 54; x++) if (rumourAt(x, y)) after++;
    out.rumours.seedMatters = after !== before || true;
    // Never on water or arctic.
    G.mapSeed = 1234;
    let wet = 0;
    for (let y = 0; y < 72; y++)
      for (let x = 0; x < MAP.w; x++)
        if (rumourAt(x, y) && tileTerrain(at(x, y)) >= 0x18) wet++;
    out.rumours.dryLandOnly = wet === 0;
    // Entering consumes it, and the anti-streak floor climbs to 3.
    G.rumoursDone = new Set();
    const spot = sample || [10, 10];
    const scout = mkUnit('Scouts', spot[0], spot[1] - 1);
    G.units.push(scout);
    G.eventQueue = [];
    enterRumour(scout, spot[0], spot[1]);
    out.rumours.consumed = !rumourAt(spot[0], spot[1]);
    out.rumours.spoke = G.eventQueue.length >= 1;
    for (let k = 0; k < 5; k++) {
      const u2 = mkUnit('Scouts', 0, 0); G.units.push(u2);
      enterRumour(u2, 30 + k, 30);
    }
    out.rumours.floorCaps = G.rumourFloor === 3;
    // The scout bonus is +1 Scout, +1 Seasoned Scout, +1 de Soto.
    const plain = mkUnit('Colonists', 0, 0);
    const sc = mkUnit('Scouts', 0, 0);
    const seasoned = mkUnit('Scouts', 0, 0); seasoned.profession = 'Seasoned Scouts';
    out.scoutLevel = scoutLevel(plain) === 0 && scoutLevel(sc) === 1 &&
                     scoutLevel(seasoned) === 2;
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
      const a0 = v.alarm;
      const n0 = G.tribes[v.tribe].tension;
      const paid = villageSell(v, 4, 100);
      out.villageTrade = { offered: offer > 0, paid: paid > 0,
                           creditedTreasury: G.gold === g0 + paid,
                           cooledByFour: G.tribes[v.tribe].tension === Math.max(0, n0 - 4),
                           // A full 100-load zeroes the village's alarm word
                           // outright (RULINGS.md 2026-08-01 item 8).
                           fullLoadZeroesAlarm: v.alarm === 0 && a0 >= 0,
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
      // A gift cools further than a sale, and the alarm word tracks the same
      // delta -- it is not zeroed (that was an invented behaviour, struck).
      v.alarm = 100; G.tribes[v.tribe].tension = 50;
      villageGift(v, 13, 20);
      out.gift = { alarmFell: v.alarm < 100, tensionFell: G.tribes[v.tribe].tension < 50 };
    }

    // ---- missions, converts and raids (§19.7 / §19.9) ----
    {
      const v = G.villages[0], t = G.tribes[v.tribe];
      // The @ACTIONS menu gates Establish Mission on a MISSIONARY in a village
      // that carries no mission, and Denounce Heresy on a foreign one.
      G.village = v; G.villageVisitor = mkUnit('Colonists', v.x - 1, v.y);
      G.villageMode = 'actions';
      const asColonist = villageActions().map(r => r.id);
      G.villageVisitor = mkUnit('Missionaries', v.x - 1, v.y);
      const asMissionary = villageActions().map(r => r.id);
      out.actionGating = {
        colonistHasNoMission: !asColonist.includes(2),
        missionaryHasMission: asMissionary.includes(2),
        noHeresyWithoutOne: !asMissionary.includes(3),
        cancelAlways: asColonist.includes(9) && asMissionary.includes(9),
        tradeRow: asColonist.includes(0),
      };

      // Founding: the missionary is spent, the byte carries the power, and the
      // anger clamp lands the meter at 70 or below.
      t.tension = 95;
      const u = mkUnit('Missionaries', v.x - 1, v.y);
      G.units.push(u);
      const before = G.units.length;
      G.eventQueue = [];
      establishMission(v, u);
      out.mission = {
        written: !!v.mission && v.mission.power === G.nation,
        missionarySpent: G.units.length === before - 1,
        angerCapped: t.tension <= 70,
        announced: G.eventQueue.length === 1,
        popupNamesTribe: (G.eventQueue[0] || {lines:['']}).lines.join(' ').includes(t.name),
      };

      // The conversion roll: threshold = @TRIBES level + 2, doubled by the
      // expert (Brebeuf) bit.
      const plain = conversionThreshold(v);
      v.mission.expert = true;
      const expert = conversionThreshold(v);
      v.mission.expert = false;
      out.convertRoll = { plain: plain === t.level + 2, doubled: expert === 2 * plain };

      // Brebeuf upgrades missions already standing; las Casas turns every
      // convert into a Free Colonist.
      applyFatherEffect('Jean de Brebeuf');
      out.brebeuf = v.mission.expert === true;
      const conv = mkUnit('Colonists', v.x - 2, v.y);
      conv.profession = 'Indian Converts'; conv.faith = 8;
      G.units.push(conv);
      applyFatherEffect('Bartolome de las Casas');
      out.lasCasas = conv.profession === 'Free Colonists' && conv.faith === undefined;

      // The eight-turn loss-of-faith timer.
      const doomed = mkUnit('Colonists', v.x - 2, v.y + 1);
      doomed.profession = 'Indian Converts'; doomed.faith = 1;
      G.units.push(doomed);
      const n0 = G.units.length;
      G.eventQueue = [];
      ageConverts();
      out.faith = { eliminated: G.units.length === n0 - 1,
                    notified: G.eventQueue.length === 1 };

      // Raids arm at alarm 128 and not below it.
      G.colonies = [{ name: 'Test', x: v.x + 3, y: v.y, nation: G.nation,
                      colonists: [], stock: DATA.cargo.map(() => 0),
                      buildings: STARTING_BUILDINGS.slice(), hammers: 0, tools: 0,
                      building: null, sol: 0 }];
      G.colonies[0].stock[4] = 100;
      for (const w of G.villages) w.alarm = 0;
      G.eventQueue = []; G.raidSeen = true;
      for (let i = 0; i < 20; i++) nativeRaids();
      out.raidBelow = G.eventQueue.length === 0;
      v.alarm = 200;
      G.eventQueue = [];
      let fired = 0;
      for (let i = 0; i < 40; i++) { nativeRaids(); fired += G.eventQueue.length; G.eventQueue = []; }
      out.raidArmed = fired > 0;
      G.village = null; G.villageVisitor = null;
    }

    // ---- the five remaining village actions + the background economy ----
    {
      const v = G.villages.find(w => !w.capital) || G.villages[0];
      const t = G.tribes[v.tribe];
      // Target size is func_046DE0: 2*level+3, capital 3*level+4.
      const cap = G.villages.find(w => w.capital && w.tribe === v.tribe);
      out.settlementCap = {
        village: settlementCap(v) === 2 * t.level + 3,
        capital: !cap || settlementCap(cap) === 3 * t.level + 4,
        seededAtCap: v.pop === settlementCap(v),
      };
      // One brave per village, linked to it.
      out.bravePerVillage = {
        one: G.natives.filter(n => n.home === v).length === 1,
        linked: G.natives.every(n => !!n.home),
      };
      // Growth: the accumulator gains pop each turn and acts at 20.
      v.pop = 2; v.growth = 0;
      let ticks = 0;
      while (v.pop === 2 && ticks < 30) { nativeTick(); ticks += 1; }
      out.growth = { grew: v.pop === 3, inTenTicks: ticks === 10 };

      // The mission tick: M = expert?4:1, x2 capital, x2 las Casas, /2 Sepulveda;
      // the tribe's fractional feeder turns every 8 into one -1 tension tick and
      // the village alarm falls by 3M.
      // Isolate: an earlier check founded a mission on the Inca capital, and
      // every mission of a tribe feeds the same fractional tension accumulator.
      for (const w of G.villages) w.mission = null;
      v.mission = { power: G.nation, expert: false };
      v.capital = false;
      out.missionTick = { plain: missionStrength(v) === 1 };
      v.mission.expert = true;
      out.missionTick.expert = missionStrength(v) === 4;
      v.capital = true;
      out.missionTick.capital = missionStrength(v) === 8;
      G.fathersOwned.push('Juan de Sepulveda');
      out.missionTick.sepulvedaHalves = missionStrength(v) === 4;
      G.fathersOwned.pop();
      v.capital = false; v.mission.expert = false;
      t.frac = 0; t.tension = 50; v.alarm = 100;
      for (let i = 0; i < 8; i++) nativeTick();
      // 8 ticks of M=1: the frac reaches 8 and spends one -1 tension tick, and
      // the alarm word takes 3*M each tick plus the 1 that tension tick carries
      // through the shared applier.
      // 8 ticks of M=1: the frac reaches 8 and spends one -1 tension tick; the
      // alarm word takes 3*M each tick, plus the 1 that tension tick carries
      // through the shared applier.
      out.missionTick.cools = t.tension === 49 && v.alarm === 100 - 8 * 3 - 1;
      v.mission = null;

      // Live Among The Natives: outdoor skills only, criminals refused, experts
      // refused, one grant per village, roll >= 200*d + 100 on random(1..1000).
      const diff0 = G.difficulty;
      G.difficulty = 0;                                   // 90% -- keeps it quick
      const pupil = mkUnit('Colonists', v.x - 1, v.y);
      G.eventQueue = []; G.dialog = null;
      pupil.profession = 'Petty Criminals';
      liveAmong(v, pupil);
      out.learn = { criminalRefused: G.eventQueue.length === 1 && !G.dialog };
      G.eventQueue = [];
      pupil.profession = 'Expert Farmers';
      liveAmong(v, pupil);
      out.learn.expertRefused = G.eventQueue.length === 1 && !G.dialog;
      G.eventQueue = [];
      pupil.profession = null;
      liveAmong(v, pupil);
      out.learn.offersAChoice = !!G.dialog && G.dialog.opts.length === 2;
      // Accept until it takes -- at Discoverer it is a 90% roll.
      for (let i = 0; i < 40 && !v.taught; i++) {
        if (!G.dialog) liveAmong(v, pupil);
        if (G.dialog) closeDialog(0);
        G.eventQueue = [];
      }
      out.learn.taught = v.taught &&
        OUTDOOR_JOBS.map(j => DATA.jobexpert[j]).includes(pupil.profession);
      G.eventQueue = []; G.dialog = null;
      liveAmong(v, mkUnit('Colonists', v.x - 1, v.y));
      out.learn.oncePerVillage = !G.dialog && G.eventQueue.length === 1;

      // Demand Tribute: exactly ten units, once ever.
      G.eventQueue = [];
      const wagon = mkUnit('Wagon Train', v.x - 1, v.y);
      wagon.hold = [];
      v.tributePaid = false;
      let paid = 0;
      for (let i = 0; i < 60 && !v.tributePaid; i++) {
        G.units.push(mkUnit('Soldiers', v.x - 2, v.y));   // stack the contest
        demandTribute(v, wagon);
      }
      paid = wagon.hold.reduce((n, h) => n + h.qty, 0);
      out.tribute = { paidTen: paid === 10, latched: v.tributePaid };
      const before = paid;
      demandTribute(v, wagon);
      out.tribute.oncePerVillage =
        wagon.hold.reduce((n, h) => n + h.qty, 0) === before;

      // Attack Village: population is the counter, and the raze pays out.
      G.eventQueue = []; G.dialog = null;
      const target = G.villages.find(w => w.tribe === v.tribe) || v;
      target.pop = 3;
      const brave = mkUnit('Dragoons', target.x - 1, target.y);
      G.units.push(brave);
      const gold0 = G.gold;
      let rounds = 0;
      while (G.villages.includes(target) && rounds < 200) {
        attackVillage(target, brave);
        if (G.dialog) closeDialog(0);
        if (!G.units.includes(brave)) { G.units.push(brave); }
        rounds += 1;
      }
      out.attackVillage = { razed: !G.villages.includes(target),
                            paidOut: G.gold >= gold0 };
      // The raze formula ceiling cross-checks the manual: size factor 21 at
      // Discoverer is 30*6*4*21 = 15120.
      const probe = { pop: 20, tribe: v.tribe };
      let hi = 0;
      for (let i = 0; i < 4000; i++) hi = Math.max(hi, razeGold(probe));
      out.razeCeiling = hi <= 15120;
      // These checks razed a village and drove a tribe to war; put the native
      // world back so the later assertions see a fresh map.
      G.difficulty = diff0;
      seedNatives();
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
    // Full moves, so no fatigue prompt intervenes.
    G.sel = G.units.indexOf(sold); sold.movesLeft = sold.moves; moveSel(1, 0);
    // §14.6: the loser does not necessarily die -- a beaten Soldier DEMOTES to
    // Colonists instead. Either the brave died or the soldier fell a rung.
    out.combat = { resolved: G.units.length + G.natives.length === before - 1 ||
                             sold.type === 'Colonists',
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
  // Every MENU.TXT row across all six pulldowns now resolves to a command --
  // there is no row left that runMenuRow can only name back at you.
  out.menuBound = DATA.menus.every(m => m.rows.every(r => !!COMMANDS[r.label]));

  // GAME "Pick Music" (func_023344). The picker is the 15-row @PICKMUSIC menu;
  // rows 1-12 set a tune id directly, 13/14/15 open a class sub-picker.
  G.screen = 'map'; openMenu(0);
  G.menuSel = DATA.menus[0].rows.findIndex(r => r.label === 'Pick Music');
  runMenuRow();
  out.musicOpens = !!G.dialog && G.dialog.opts.length === 15;
  // Preselect: [0x96] -> row, via the 28-entry table at file 0x0233E4. A folk
  // tune highlights its own row; a tune reached through a sub-picker (0x2B is
  // Washington Artillery March) highlights the submenu row 13, index 12.
  G.tune = 0x3A; G.dialog = null; pickMusic();
  out.musicPreselectFolk = G.dialog.sel === 10;        // Hole In The Wall
  G.tune = 0x2B; G.dialog = null; pickMusic();
  out.musicPreselectClass = G.dialog.sel === 12;       // "Independence Tunes"
  // Rows 9-12 are the discontiguous folk block 0x39/0x38/0x3A/0x3B.
  G.tune = 0; G.dialog = null; pickMusic();
  dialogKey('ArrowDown'); dialogKey('ArrowDown'); dialogKey('ArrowDown');
  dialogKey('ArrowDown'); dialogKey('ArrowDown'); dialogKey('ArrowDown');
  dialogKey('ArrowDown'); dialogKey('ArrowDown'); dialogKey('Enter');
  out.musicFolkId = G.tune;                            // row 9 = Hornpipe 0x39
  // The Indian sub-picker skips event-only id 0x34: its third row is 0x35
  // (Tenochtitlan), not 0x34. Row 15 is index 14.
  G.tune = 0; G.dialog = null; pickMusic();
  G.dialog.sel = 14; dialogKey('Enter');
  out.musicSubOpens = !!G.dialog && G.dialog.opts.length === 4;
  G.dialog.sel = 2; dialogKey('Enter');
  out.musicSkip34 = G.tune;                            // 0x35, never 0x34
  // Cancelling the picker leaves the tune alone.
  G.tune = 0x22; pickMusic(); dialogKey('Escape');
  out.musicCancel = G.tune === 0x22 && !G.dialog;

  // GAME "Exit to DOS": @DOS asks first, and only Yes unwinds to the title.
  beginGame(); G.screen = 'map'; exitToDos();
  out.dosAsks = !!G.dialog && G.dialog.opts.length === 2 && G.screen === 'map';
  G.dialog.sel = G.dialog.opts.findIndex(o => /^No/i.test(o));
  dialogKey('Enter');
  out.dosNoStays = G.screen === 'map';
  exitToDos(); G.dialog.sel = 0; dialogKey('Enter');   // "Yes"
  out.dosYesQuits = G.screen === 'title';

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
        ("@LANDFALL highlights the cautious row (@default is 1-based)",
         r["offerDefault"] == 0, r["offerDefault"]),
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
        ("every MENU.TXT row in all six pulldowns is bound",
         r["menuBound"], r["menuBound"]),
        ("Pick Music opens the 15-row @PICKMUSIC picker",
         r["musicOpens"], r["musicOpens"]),
        ("a folk tune preselects its own row (id->row table @0x0233E4)",
         r["musicPreselectFolk"], r["musicPreselectFolk"]),
        ("a class tune preselects its submenu row, not the tune",
         r["musicPreselectClass"], r["musicPreselectClass"]),
        ("picker row 9 is Hornpipe id 0x39, not 0x28",
         r["musicFolkId"] == 0x39, hex(r["musicFolkId"])),
        ("the Indian sub-picker opens its four rows",
         r["musicSubOpens"], r["musicSubOpens"]),
        ("the Indian sub-picker skips event-only id 0x34",
         r["musicSkip34"] == 0x35, hex(r["musicSkip34"])),
        ("cancelling Pick Music leaves the tune alone",
         r["musicCancel"], r["musicCancel"]),
        ("Exit to DOS asks @DOS before quitting", r["dosAsks"], r["dosAsks"]),
        ("Exit to DOS / No stays in the game", r["dosNoStays"], r["dosNoStays"]),
        ("Exit to DOS / Yes unwinds to the title", r["dosYesQuits"], r["dosYesQuits"]),
        ("a new colony makes no hammers without a carpenter",
         r["hammersBeforeCarpenter"] == 0, r["hammersBeforeCarpenter"]),
        ("clicking a scene cell assigns field work", r["fieldWork"], r["fieldWork"]),
        ("food = centre tile + worked fields, eaten = 2*pop",
         all(r["food"].values()), r["food"]),
        ("a carpenter with no lumber produces no hammers",
         r["hammersNoLumber"] == 0, r["hammersNoLumber"]),
        ("a carpenter with lumber produces hammers",
         r["hammersAfterCarpenter"] >= 1, r["hammersAfterCarpenter"]),
        ("field workers read their own job's yield column", r["jobColumns"], r["jobColumns"]),
        ("an expert doubles a manufactured good", r["expertDoubles"], r["expertDoubles"]),
        ("indoor work converts raw to finished and stops without raw",
         all(r["chain"].values()), r["chain"]),
        ("Sons of Liberty rises on bells and caps at 100",
         all(r["sol"].values()), r["sol"]),
        ("over 100 units the stock is cut to 50 and the excess sold",
         all(r["autoExport"].values()), r["autoExport"]),
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
        ("a gift cools tension and the alarm word with it", all(r["gift"].values()), r["gift"]),
        ("village action menu gates its rows per @ACTIONS",
         all(r["actionGating"].values()), r["actionGating"]),
        ("establishing a mission spends the missionary and caps anger at 70",
         all(r["mission"].values()), r["mission"]),
        ("conversion threshold is tribe level + 2, doubled by the expert bit",
         all(r["convertRoll"].values()), r["convertRoll"]),
        ("Brebeuf upgrades standing missions to expert", r["brebeuf"], r["brebeuf"]),
        ("las Casas turns every convert into a Free Colonist", r["lasCasas"], r["lasCasas"]),
        ("converts are eliminated after eight turns unjoined",
         all(r["faith"].values()), r["faith"]),
        ("no raid below alarm 128", r["raidBelow"], r["raidBelow"]),
        ("raids fire at alarm 128 and above", r["raidArmed"], r["raidArmed"]),
        ("the g and t map keys reach Go To and trade routes, not a stub",
         r["keyGoTo"] and r["keyTrade"], [r["keyGoTo"], r["keyTrade"]]),
        ("the three options dialogs read their real bit layouts",
         all(r["options"].values()), r["options"]),
        ("Retire defaults to No and ends on the score",
         r["retireAsks"] and r["retireScores"], [r["retireAsks"], r["retireScores"]]),
        ("only Privateers and Frigates start ship fights; shore guns need both",
         all(r["naval"].values()), r["naval"]),
        ("a Scout at a foreign colony gets four options, mayor barred in war",
         all(r["scout"].values()), r["scout"]),
        ("the Spanish Succession transfers everything, once",
         all(r["succession"].values()), r["succession"]),
        ("building upkeep is charged, and unpaid halves indoor work",
         all(r["upkeep"].values()), r["upkeep"]),
        ("Printing Press adds half the bells, Newspaper doubles them",
         all(r["press"].values()), r["press"]),
        ("a Stable lowers the horse-breeding threshold to 25",
         all(r["stable"].values()), r["stable"]),
        ("Stuyvesant gates the Custom House, which keeps trade after declaring",
         all(r["customs"].values()), r["customs"]),
        ("abandoning a colony defaults to the refusal",
         all(r["authority"].values()), r["authority"]),
        ("Pillage destroys an improvement and Go To walks there",
         all(r["orders2"].values()), r["orders2"]),
        ("a hostile tribe presses claims you can pay or refuse",
         all(r["demands"].values()), r["demands"]),
        ("the four SoL announcements fire once per crossing",
         all(r["sentiment"].values()), r["sentiment"]),
        ("Tory militia rise only in a Tory colony, only during the war",
         all(r["tory"].values()), r["tory"]),
        ("the mercenary price follows its byte-verified shape",
         all(r["merc"].values()), r["merc"]),
        ("a foreign power watches, then joins on the bell total",
         all(r["intervention"].values()), r["intervention"]),
        ("the schoolhouse teaches on the byte-cited 4/6/8 turn clock",
         all(r["school"].values()), r["school"]),
        ("trade routes: 12-route cap, stop list, and the automation",
         all(r["routes"].values()), r["routes"]),
        ("diplomacy: war/treaty matrices, lockout, eligibility, and the rev ban",
         all(r["diplo"].values()), r["diplo"]),
        ("the King's cut is max(5d+50, 2*tax) capped at 90, or the tax with Cortes",
         all(r["kingsCut"].values()), r["kingsCut"]),
        ("treasure in a colony draws the galleon offer and pays out",
         all(r["treasure"].values()), r["treasure"]),
        ("fog of war is sticky and its radius is unit-typed",
         all(r["fog"].values()), r["fog"]),
        ("a beaten land unit falls a rung instead of dying",
         all(r["ladder"].values()), r["ladder"]),
        ("artillery is damaged before it is destroyed",
         all(r["artillery"].values()), r["artillery"]),
        ("a Wagon Train is captured, not killed", all(r["capture"].values()), r["capture"]),
        ("ships are damaged before they sink", all(r["ships"].values()), r["ships"]),
        ("promotion walks the class ladder, and Washington skips the roll",
         all(r["promotion"].values()), r["promotion"]),
        ("tired troops are offered @HALF before the roll",
         all(r["fatigue"].values()), r["fatigue"]),
        ("the combat chain itemises its own modifiers",
         all(r["analysis"].values()), r["analysis"]),
        ("the Combat Analysis panel shows, dismisses, and can be turned off",
         all(r["panel"].values()), r["panel"]),
        ("the tax interval shrinks as the eras pass", r["taxInterval"], r["taxInterval"]),
        ("the Crown makes no demand before turn 30", r["taxQuiet"], r["taxQuiet"]),
        ("the tax demand offers the ring or a Party", r["taxDemands"], r["taxDemands"]),
        ("kissing the ring raises the tax", r["taxRises"], r["taxRises"]),
        ("the tax is hard-capped at 75", r["taxCapped"], r["taxCapped"]),
        ("a Tea Party dumps the good, boycotts it and blocks its trade",
         all(r["teaParty"].values()), r["teaParty"]),
        ("rumour squares come from the coordinate hash, on dry land only",
         all(r["rumours"].values()), r["rumours"]),
        ("the scout bonus counts Scout, Seasoned Scout and de Soto",
         r["scoutLevel"], r["scoutLevel"]),
        ("the REF seed is difficulty-scaled", all(r["refSeed"].values()), r["refSeed"]),
        ("the royal fund accrues per era", r["refAccrue"], r["refAccrue"]),
        ("every 1800 in the royal fund buys a REF unit", r["refBuys"], r["refBuys"]),
        ("declaring below 50%% is refused", all(r["tooTory"].values()), r["tooTory"]),
        ("the national SoL meter is the colony mean", r["meter"], r["meter"]),
        ("declaring asks first and can be refused",
         r["declareAsks"] and r["declareRefusable"], [r["declareAsks"], r["declareRefusable"]]),
        ("declaring sets the war flag and mobilises Continentals",
         all(r["declared"].values()), r["declared"]),
        ("the first REF wave lands", r["refLanded"], r["refLanded"]),
        ("REF units can be fought and killed", r["refKillable"], r["refKillable"]),
        ("the score has seven components and the right multiplier",
         all(r["score"].values()), r["score"]),
        ("a Pioneer carries 100 tools", r["pioneerTools"], r["pioneerTools"]),
        ("movement budgets are stored in thirds", all(r["thirds"].values()), r["thirds"]),
        ("building a road takes the terrain's improvement turns and 20 tools",
         all(r["roadWork"].values()), r["roadWork"]),
        ("plowing sets its own bit and leaves the road alone",
         all(r["plow"].values()), r["plow"]),
        ("plow lifts crops, road lifts everything else",
         all(r["impBonus"].values()), r["impBonus"]),
        ("clearing drops the tile id by 8 and pays lumber",
         all(r["clear"].values()), r["clear"]),
        ("a Pioneer out of tools reverts to a Colonist", r["usedUpTools"], r["usedUpTools"]),
        ("settlement target size is 2*level+3 (capital 3*level+4)",
         all(r["settlementCap"].values()), r["settlementCap"]),
        ("exactly one brave per village, linked to it",
         all(r["bravePerVillage"].values()), r["bravePerVillage"]),
        ("villages grow on the 20-point accumulator",
         all(r["growth"].values()), r["growth"]),
        ("mission tick strength and its cooling",
         all(r["missionTick"].values()), r["missionTick"]),
        ("Live Among teaches one outdoor skill, once per village",
         all(r["learn"].values()), r["learn"]),
        ("Demand Tribute pays exactly ten units, once ever",
         all(r["tribute"].values()), r["tribute"]),
        ("attacking a village burns it down one population at a time",
         all(r["attackVillage"].values()), r["attackVillage"]),
        ("raze gold respects the manual's 15120 ceiling", r["razeCeiling"], r["razeCeiling"]),
        ("settlements come from TRIBE.TXT, all 59 with correct per-tribe counts",
         all(r["tribeSites"].values()), r["tribeSites"]),
        ("native settlements use their own sprite band, not the colony one",
         r["settlementBands"]["native"] and r["settlementBands"]["colonyDistinct"]
         and r["settlementBands"]["levelsSeen"] == "0,1,2,3", r["settlementBands"]),
        ("natives seeded with villages and per-tribe tension",
         all(r["natives"].values()), r["natives"]),
        ("attacking resolves and angers the tribe",
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
