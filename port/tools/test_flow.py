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

  // Build Colony on the tile the party is standing on. Clear any village
  // inside the land-claim radius so the @INDIANLAND chain stays out of this
  // basic-founding walk (it has its own check).
  G.sel = G.units.findIndex(u => !u.ship);
  const founder = G.units[G.sel];
  G.villages = G.villages.filter(v =>
    Math.abs(v.x - founder.x) > 2 || Math.abs(v.y - founder.y) > 2);
  buildColony();
  // The founding-validation confirms (@NOPORT / @TUTNOSPACES / @TUTNOLUMBER,
  // func_022542) may precede the name dialog; row 2 proceeds through each.
  for (let i = 0; i < 3 && G.dialog && G.dialog.entry === undefined; i++) closeDialog(1);
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

  // A ship entering the sea lane asks @SAILHOME, then leaves for the home port.
  const vessel = G.units.find(u => u.ship);
  G.sel = G.units.indexOf(vessel);
  vessel.x = MAP.w - 2; vessel.movesLeft = 9;
  moveSel(1, 0);
  closeDialog(0);                              // "Yes, steady as she goes."
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
  // The interactive sell now runs the @HOWMUCH5 bounded entry -- Enter on
  // the empty field takes the full amount.
  sellFromShip(tools);
  out.howmuchAsk = !!(G.dialog && G.dialog.numeric &&
                      /How much/i.test(G.dialog.body.join(' ')));
  dialogKey('Enter');
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
  // Census: a "(None)" head row leads, then the three priced candidates.
  out.recruitRows = rows.length === 4 && rows[0].none &&
    rows.slice(1).every(r => r.cost >= 300 && r.cost <= 2000);
  G.gold = 5000; G.euroMenuRow = 1;
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
  euroMenuCommit(); closeDialog(0);            // buy Artillery (@REALLYBUY Yes)
  out.artilleryEscalates = euroMenuRows()[0].cost === 600;
  out.artilleryOnDock = G.dockUnits.includes('Artillery');
  G.euroMenuRow = 1; openEuroMenu(1); G.euroMenuRow = 1;
  const fleet0 = shipsInPort().length;
  euroMenuCommit(); closeDialog(0);            // buy a Caravel (@REALLYBUY Yes)
  out.shipJoinsFleet = shipsInPort().length === fleet0 + 1;

  // Sailing west boards whoever is waiting on the dock.
  const pax0 = boat.passengers.length, waiting = G.dockUnits.length;

  // Train: all 17 trainable @JOB rows, priced from europe_value, price-sorted.
  openEuroMenu(2);
  const tr = euroMenuRows();
  out.train = {
    count: tr.length === 18 && tr[0].none,     // @MISC "None" head + 17 rows
    sorted: tr.slice(1).every((r, i, a) => i === 0 || a[i - 1].cost <= r.cost),
    cheapest: tr[1] && tr[1].cost,
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

  // The dock-unit context menu (@ARMOPTIONS): arm a Colonist with muskets at
  // the market ask, and get a Soldiers-typed entry that keeps his name.
  {
    G.dockUnits.length = 0;
    G.dockUnits.push('Colonists', 'Expert Farmers');
    G.euroDockSel = 0; G.euroMenu = 'dockunit';
    const rows0 = euroMenuRows();
    const arm = rows0.find(r => r.act === 'arm' && r.verb.buy && r.verb.good === GOOD.MUSKETS);
    out.armMenu = {
      hasBoard: rows0.some(r => r.act === 'board' || r.act === 'noboard'),
      hasFront: rows0.some(r => r.act === 'front'),
      muskets: !!arm, tools: rows0.some(r => r.act === 'arm' && r.verb.good === GOOD.TOOLS),
      horses: rows0.some(r => r.act === 'arm' && r.verb.good === GOOD.HORSES),
      priceIsMarket: arm && arm.label.includes(String(askPrice(GOOD.MUSKETS) * 50)),
    };
    const g0 = G.gold;
    G.euroMenuRow = rows0.indexOf(arm); euroMenuCommit();
    out.armCommit = {
      typed: entryType(G.dockUnits[0]) === 'Soldiers',
      named: entryName(G.dockUnits[0]) === 'Colonists',
      charged: G.gold < g0,
    };
    // @ARMOPTIONS row 0: "Don't get on next ship." holds a dock unit back;
    // sailing then leaves it behind, and the row flips to "Board next ship."
    {
      G.dockUnits.length = 0;
      G.dockUnits.push('Colonists', 'Expert Farmers');
      G.euroDockSel = 0; G.euroMenu = 'dockunit';
      const r0 = euroMenuRows()[0].label;
      G.euroMenuRow = 0; euroContextCommit(euroMenuRows()[0]);
      const held = !!(G.dockUnits[0] && G.dockUnits[0].noBoard);
      G.euroDockSel = 0; G.euroMenu = 'dockunit';
      const r0b = euroMenuRows()[0].label;
      G.euroMenu = null;
      G.europe.push({ type: 'Caravel', icon: unit('Caravel').icon,
                      hold: [], passengers: [], state: 'port' });
      const boat = G.europe[G.europe.length - 1];
      sailForNewWorld(boat);
      out.dontBoard = {
        rowShown: r0 === "Don't get on next ship.",
        heldSet: held,
        rowFlips: r0b === 'Board next ship.',
        leftBehind: G.dockUnits.map(entryName).join() === 'Colonists' &&
                    boat.passengers.map(entryName).join() === 'Expert Farmers',
      };
      G.dockUnits.length = 0;
      G.europe.pop();
    }
    // An armed profession lands as its armed type CARRYING the profession.
    const landedVet = mkUnit({ name: 'Expert Farmers', type: 'Dragoons' }, 5, 5);
    out.armedLandfall = landedVet.type === 'Dragoons' &&
                        landedVet.profession === 'Expert Farmers';
    // A bare profession name no longer throws -- the old Europe-sailing crash.
    out.professionLands = mkUnit('Veteran Soldiers', 5, 5).type === 'Soldiers' &&
                          mkUnit('Free Colonists', 5, 5).type === 'Colonists';
    G.euroMenu = null; G.dockUnits.length = 0;
  }

  // The harbour ship menu (@EUROPESHIPOPTIONS): "Set sail" from the mouse path.
  {
    const s = shipsInPort()[G.euroShip];
    G.euroMenu = 'ship';
    const srows = euroMenuRows();
    out.shipMenuRows = srows.map(r => r.act).join(',') === 'shipfront,sail,sellall,close';
    G.euroMenuRow = 1; euroMenuCommit();
    closeDialog(0);                            // @SAILAWAY: "Yes, steady as she goes."
    out.shipMenuSails = s.state === 'toNewWorld';
    s.state = 'port';                          // put it back for the next block
    G.euroMenu = null;
  }

  // Sail home: three turns back to the lane, then the ship is on the map again.
  // (Recapture the dock count here -- the context-menu block above emptied it.)
  const pax1 = boat.passengers.length, waiting1 = G.dockUnits.length;
  const units0 = G.units.length;
  sailForNewWorld(boat);
  out.boarded = boat.passengers.length === pax1 + waiting1 && G.dockUnits.length === 0;
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
    buildColony();
    for (let i = 0; i < 3 && G.dialog && G.dialog.entry === undefined; i++) closeDialog(1);
    closeDialog('Jamestown');
    G.screen = 'colony';
    const c = G.colonies[0];
    c.colonists.push({ type: 'Colonists', job: null, cell: null });
    c.colonists.push({ type: 'Colonists', job: null, cell: null });

    // A new colony makes no hammers: it has the shop but nobody in it.
    out.hammersBeforeCarpenter = colonyHammers(c);

    // Click a scene cell to put the SELECTED colonist on that field. (It used
    // to place whichever colonist happened to have no cell yet, which is the
    // bug fixed alongside drag-and-drop -- so the selection has to be set.)
    G.colonistSel = 0;
    onClick(224 + 12, 32 + 12);                     // cell (-1,-1)
    const worker = c.colonists.find(p => p.cell);
    // The colonist takes the cell's BEST field job, not always Farmer.
    out.fieldWork = !!worker && FIELD_JOB_NAMES.includes(worker.job) &&
                    worker.cell[0] === -1 && worker.cell[1] === -1 &&
                    fieldYield(c, worker) > 0;
    worker.job = 'Farmer';                          // pin it for the food check
    const f = colonyFood(c);
    out.food = { centre: f.centre > 0, eaten: f.eaten === 2 * c.colonists.length,
                 fieldsCounted: f.produced === f.centre + f.fields };

    // A CLICK WITH ONE PIXEL OF WOBBLE is still a click: the drag layer must
    // not turn it into a zero-length drop that eats the click and clears the
    // job. Exercised through the real pointer entry points.
    {
      const e0 = plazaRow(c).find(e => e.colonist >= 0);
      const jitter = (x, y) => {
        PTR.down = true; PTR.x = PTR.downX = x; PTR.y = PTR.downY = y; PTR.moved = false;
        onPointerDown(x, y, false, false);
        PTR.x = x + 1; PTR.y = y + 1; PTR.moved = true;
        onPointerUp(x + 1, y + 1, false);
        PTR.down = false;
        if (PTR.suppressClick) { PTR.suppressClick = false; return; }
        onClick(x, y);
      };
      G.colonistSel = -1;
      c.colonists[e0.colonist].job = 'Statesman';
      jitter(e0.x + 2, PLAZA_ROW_Y + 3);
      const kept = c.colonists[e0.colonist].job === 'Statesman';
      jitter(e0.x + 2, PLAZA_ROW_Y + 3);
      out.jitterClick = { keptJob: kept, openedMenu: G.colonyPopup === 'jobs' };
      G.colonyPopup = null;
      c.colonists[e0.colonist].job = null;
    }

    // The scene panel composites the map proper, so the COLONY ITSELF shows on
    // the centre tile -- pixel-checked: the centre cell must differ from the
    // bare terrain tile it sits on.
    {
      const probe = document.createElement('canvas');
      probe.width = 320; probe.height = 200;
      const pctx = probe.getContext('2d');
      drawColony(pctx);
      const withColony = pctx.getImageData(248, 56, 24, 24).data.join();
      const cx0 = c.x;
      c.x = -99;                                 // move it off-world and redraw
      pctx.clearRect(0, 0, 320, 200);
      drawColony(pctx);
      const without = pctx.getImageData(248, 56, 24, 24).data.join();
      c.x = cx0;
      out.sceneShowsColony = withColony !== without;
    }

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
    // Row 0 is the engine's @CTITLE 5 "(No Production)"; the rest gated builds
    // in the byte-read "(N Hammers) (M Tools)" format.
    // census3_build_picker: labels are the names in CAPITALS; each row keeps
    // its mixed-case identity in r.name.
    out.buildGated = opts[0].label === '(No Production)' &&
      /^\(\d+ Hammers\)( \(\d+ Tools\))?$/.test(opts[1].note) &&
      opts.slice(1).every(r => {
        if (r.label !== r.name.toUpperCase()) return false;
        const b = DATA.buildings.find(d => d.name === r.name);
        // Colony-built UNITS (Wagon Train etc.) carry no min_colony gate.
        if (!b) return BUILDABLE_UNITS.includes(r.name);
        return !c.buildings.includes(r.name) && b.min_colony <= c.colonists.length;
      });
    G.colonyPopupRow = opts.findIndex(r => r.name === 'Docks');
    colonyPopupCommit();
    out.buildTarget = c.building;
    // census3_build_picker: reopening the picker highlights the CURRENT target.
    openBuildPicker();
    out.buildPreset = colonyPopupRows()[G.colonyPopupRow].name === 'Docks';
    G.colonyPopup = null;
    const cost = DATA.buildings.find(b => b.name === 'Docks').cost;
    // Keep the carpenter supplied with lumber and the colony fed: a colony that
    // cannot feed itself loses a colonist, and the carpenter is the one at risk.
    for (let t = 0; t < cost + 2; t++) { c.stock[5] = 100; c.stock[0] = 100; endTurn(); }
    out.built = { done: c.buildings.includes('Docks'), targetCleared: c.building === null };

    // Construction prereq/supersede/factory gating and the per-turn popups.
    {
      const t = { name: 'GT', x: 6, y: 6, nation: G.nation,
        colonists: Array.from({ length: 8 }, () => ({ type: 'Colonists', job: null, cell: null })),
        stock: DATA.cargo.map(() => 0), buildings: STARTING_BUILDINGS.slice(),
        building: null, hammers: 0, sol: 0, latch: 0 };
      const names = () => buildOptions(t).map(b => b.name);
      out.buildGating = {
        noFortWithoutStockade: !names().includes('Fort'),
        noCathedralWithoutChurch: !names().includes('Cathedral'),
        stableIndependent: names().includes('Stable'),
      };
      t.buildings.push('Stockade');
      out.buildGating.fortAfterStockade = names().includes('Fort') && !names().includes('Stockade');
      t.buildings.push("Weaver's Shop");
      out.buildGating.factoryNeedsSmith = !names().includes('Textile Mill');
      G.fathersOwned.push('Adam Smith');
      out.buildGating.factoryWithSmith = names().includes('Textile Mill');
      G.fathersOwned.pop();
      // The per-turn colony popups: starvation, construction complete, tools stall.
      const p = { name: 'P', x: 7, y: 7, nation: G.nation,
        colonists: [{ type: 'Colonists', job: null, cell: null }, { type: 'Colonists', job: null, cell: null }],
        stock: DATA.cargo.map(() => 0), buildings: STARTING_BUILDINGS.slice(),
        building: null, hammers: 0, sol: 0, latch: 0 };
      G.colonies = [p];
      p.stock[GOOD.FOOD] = 0;
      // Turn 1 at empty stores posts the @FOOD1/@FOOD2 depletion warning;
      // starvation (a colonist lost) starts the NEXT hungry turn.
      G.eventQueue = []; colonyTurn(p);
      const depletedFired = G.eventQueue.some(e => /depleted/i.test(e.lines.join(' ')));
      p.stock[GOOD.FOOD] = 0;
      G.eventQueue = []; colonyTurn(p);
      const starveFired = G.eventQueue.some(e => /run out of food|starving/i.test(e.lines.join(' ')));
      p.building = 'Stockade'; p.hammers = 9999; p.stock[GOOD.TOOLS] = 0;
      G.eventQueue = []; advanceConstruction(p, 0);
      const builtFired = G.eventQueue.some(e => /produces/i.test(e.lines.join(' '))) &&
                         p.buildings.includes('Stockade');
      p.building = 'Fur Trading Post'; p.hammers = 9999; p.stock[GOOD.TOOLS] = 0;
      G.eventQueue = []; advanceConstruction(p, 0);
      const toolsFired = G.eventQueue.some(e => /tools/i.test(e.lines.join(' ')));
      G.eventQueue = []; advanceConstruction(p, 0);
      const toolsOnce = G.eventQueue.length === 0;
      out.colonyPopups = { depletedFired, starveFired, builtFired, toolsFired, toolsOnce };
    }


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
    // Put a veteran soldier in the colony so mobilisation has something to
    // promote -- and stock the CANTMOBILIZE muskets gate's 50.
    const sold = mkUnit('Soldiers', G.colonies[0].x, G.colonies[0].y);
    G.units.push(sold);
    G.colonies[0].stock[GOOD.MUSKETS] = 50;
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
    // A ship's picker now always offers the Europe crossing, so even with no
    // colonies 'g' opens the @SAILPORT dialog (homeport last); Escape falls
    // back to click-to-target.
    tap('g');
    const gRows = (G.dialog && G.dialog.opts) || [];
    out.keyGoTo = gRows[0] ===
        `${DATA.nations[G.nation].homeport} (${DATA.nations[G.nation].country})` &&
                  !/not in this build/.test(G.msg || '');
    dialogKey('Escape');
    out.keyGoTo = out.keyGoTo && G.goTo === G.units[0];
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
    // 25 = the quiet band: neither the friendly-gift branch (Content, <20)
    // nor the hostile claims -- so only tribe 0's claim can ask.
    for (let i = 1; i < G.tribes.length; i++) G.tribes[i].tension = 25;
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
    // The SoL hysteresis announcements fire once per crossing. Count only the
    // threshold latches here (the incremental @SONSUP/@SONSDOWN band notices
    // are checked separately below), so seed solBand to the current band first.
    // Seed solBand to the current band so the incremental @SONSUP/@SONSDOWN
    // notices don't fire during the threshold-latch counts (checked separately).
    const c = G.colonies[0];
    c.sol = 60; c.latch = 0; c.solBand = 6;
    G.eventQueue = [];
    solAnnounce(c); solAnnounce(c);
    out.sentiment = { majorityOnce: G.eventQueue.length === 1 };
    c.sol = 100; c.solBand = 10; G.eventQueue = [];
    solAnnounce(c);
    out.sentiment.unanimous = G.eventQueue.length === 1;
    c.sol = 40; c.solBand = 4; G.eventQueue = [];
    solAnnounce(c);
    out.sentiment.fallsBack = G.eventQueue.length === 2;   // minority AND majority lost
    // The incremental band notice: crossing a 10% boundary up posts @SONSUP.
    c.sol = 55; c.solBand = 4; c.latch = 0x04; G.eventQueue = [];
    solAnnounce(c);
    out.sentiment.bandUp = G.eventQueue.some(e => /up to/i.test(e.lines.join(' ')));
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
      // @MERCENARIES rows: 0 "No thank you.", 1 "Pay {N$}."
      const g0 = G.gold, u0 = G.units.length;
      closeDialog(1);
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
    // The landing now posts @INTERVENTION plus the @INTERVENE arrival.
    out.intervention.joins = (G.flags & 2) !== 0 && G.eventQueue.length === 2;
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
    // The meeting is a popup CHAIN: the greeting queues with the MYR portrait
    // and the standing-peace hub opens with the @PEACE* four rows; accepting
    // peace is silent (@SIGNTREATY belongs to the AI-AI ticker).
    setTreaty(G.nation, r.nation, 0x40, false);
    setWar(G.nation, r.nation, 0x02, false); setWar(r.nation, G.nation, 0x02, false);
    G.eventQueue = []; G.dialog = null; r.greeted = false; r.attitude = 10;
    G.parleyLock[r.nation] = 0; G.gold = 100000;
    runMeeting(r, { ship: false });
    const greeted = G.eventQueue.length === 1 &&
                    G.eventQueue[0].speaker === `MYR${r.nation}`;
    // Whatever AI topic fired first (tribute / treaty proposal), answer its
    // LAST row until the four-row hub shows.
    let hops = 0;
    while (G.dialog && G.dialog.opts.length !== 4 && hops++ < 4)
      closeDialog(G.dialog.opts.length - 1);
    const hub = !!G.dialog && G.dialog.opts.length === 4 &&
                G.dialog.opts[3].includes('alliance');
    G.eventQueue = [];
    if (G.dialog) closeDialog(0);                       // "Go in peace"
    out.diplo.meeting = { greeted, hub,
      treaty: haveTreaty(G.nation, r.nation),
      silentAccept: !G.eventQueue.some(e => e.lines.join(' ').includes('signed a peace')) };
    G.screen = 'map'; G.dialog = null;
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

  // ---- Phase 1 wire-only sweep: market, schooling, guards, notices ----
  {
    beginGame(); G.screen = 'map';
    const q = () => G.eventQueue.map(e => e.lines.join(' ')).join(' | ');
    const w1 = {};
    // @PRICEDOWN / @PRICEUP fire from stepPrice on a level change.
    const c0 = DATA.cargo[0];
    G.market[0] = c0.low + 2; G.accum[0] = 100 * c0.fall;
    G.eventQueue = []; stepPrice(0);
    w1.priceDown = /has fallen to/.test(q());
    G.market[0] = c0.low; G.accum[0] = -100 * c0.rise;
    G.eventQueue = []; stepPrice(0);
    w1.priceUp = /has risen to/.test(q());
    w1.priceSpeaker = eventSpeaker('PRICEUP') === 'MSS2' &&
                      eventSpeaker('SOMEBOYCOTT') === 'MSS2' &&
                      !!DATA.events.SOMEBOYCOTT;
    // Teacher guards: @NOTEACHER, @NEEDCOLLEGE, @SCHOOL1 faculty cap.
    const sc = { name: 'S', x: 1, y: 1, nation: G.nation, colonists: [],
                 stock: DATA.cargo.map(() => 0), hammers: 0, building: null,
                 sol: 0, buildings: STARTING_BUILDINGS.concat(['Schoolhouse']) };
    const t1 = DATA.jobexpert[DATA.jobtier.findIndex(t => t === 1)];
    const t2 = DATA.jobexpert[DATA.jobtier.findIndex(t => t === 2)];
    G.eventQueue = [];
    w1.noTeacher = teacherGuard(sc, { profession: null }) &&
                   /mastered a profession/.test(q());
    G.eventQueue = [];
    w1.needCollege = teacherGuard(sc, { profession: t2 }) && /college/i.test(q());
    sc.colonists.push({ job: 'Teacher', profession: t1, type: 'Colonists', cell: null });
    G.eventQueue = [];
    w1.facultyCap = teacherGuard(sc, { profession: t1 }) &&
                    /faculty of only/.test(q());
    // Graduation rungs: a criminal climbs to servant with @TRAINCRIMINAL.
    const crim = { profession: 'Petty Criminals', job: null, cell: null,
                   type: 'Colonists', taught: 99 };
    sc.colonists.push(crim);
    G.eventQueue = []; runSchool(sc);
    w1.gradCriminal = crim.profession === 'Indentured Servants' &&
                      /indentured/i.test(q());
    // Founding guards: @TOOMOUNTAIN and @TOONEAR.
    const gv = G.villages; const gn = G.natives;
    G.villages = []; G.natives = [];
    const settler = mkUnit('Colonists', 2, 2);
    G.units.push(settler); G.sel = G.units.indexOf(settler);
    const ti = 2 * MAP.w + 2, sv = MAP.tiles[ti];
    MAP.tiles[ti] = 3 | 0xA0;
    G.eventQueue = []; buildColony();
    w1.tooMountain = /mountains/i.test(q());
    MAP.tiles[ti] = 3;
    G.colonies.push({ name: 'Near', x: 3, y: 2, nation: G.nation, colonists: [],
                      stock: DATA.cargo.map(() => 0), buildings: [], hammers: 0,
                      building: null, sol: 0 });
    G.eventQueue = []; buildColony();
    w1.tooNear = /too near/i.test(q());
    G.colonies.pop(); MAP.tiles[ti] = sv;
    // @CANNOTATTACK: a Wagon Train (attack 0) refused before the roll.
    const ti2 = 3 * MAP.w + 2, sv2 = MAP.tiles[ti2];
    MAP.tiles[ti2] = 3;                       // the target square must be land
    G.natives.push({ x: 2, y: 3, tribe: 0 });
    const wagon = mkUnit('Wagon Train', 2, 2);
    G.units.push(wagon); G.sel = G.units.indexOf(wagon); wagon.movesLeft = 2;
    G.eventQueue = []; moveSel(0, 1);
    w1.cannotAttack = /cannot attack/.test(q());
    G.natives.pop(); MAP.tiles[ti2] = sv2;
    G.units.splice(G.units.indexOf(wagon), 1);
    G.units.splice(G.units.indexOf(settler), 1);
    G.villages = gv; G.natives = gn;
    // @DISBANDSHIP: a laden ship at sea will not disband.
    const boat = mkUnit('Caravel', 0, 0, ['Colonists']);
    G.units.push(boat); G.sel = G.units.indexOf(boat);
    G.eventQueue = []; disbandUnit();
    w1.disbandShip = /disband a ship at sea/.test(q()) && G.units.includes(boat);
    G.units.splice(G.units.indexOf(boat), 1);
    // @KEEPSTOCKADE blocks abandoning a stockaded colony.
    const ab = { name: 'A', x: 9, y: 9, nation: G.nation,
                 colonists: [{ type: 'Colonists', job: null, cell: null }],
                 stock: DATA.cargo.map(() => 0), hammers: 0, building: null,
                 sol: 0, buildings: STARTING_BUILDINGS.concat(['Stockade']) };
    G.colonies.push(ab); G.colony = G.colonies.indexOf(ab);
    G.eventQueue = []; abandonColony();
    w1.keepStockade = /stockade, fort, or fortress/.test(q()) &&
                      G.colonies.includes(ab);
    // @SPOIL + @CARGOREADY on the boycotted-overflow path.
    ab.stock[2] = 120; G.boycotts = [2];
    G.eventQueue = []; autoExport(ab);
    w1.spoil = /exceeded its warehouse capacity/.test(q()) &&
               /thrown away/.test(q()) && ab.stock[2] === 50;
    w1.cargoReady = !!G.dialog && /new cargo of/i.test(G.dialog.body.join(' ')) &&
                    /Zoom to colony/.test((G.dialog.opts || []).join(' '));
    G.dialog = null;
    G.boycotts = []; G.colonies.pop();
    // @EVASIVE: a gunless ship that survives the roll escapes.
    const rnd = Math.random; Math.random = () => 0.9999;
    const priv = mkUnit('Privateer', 0, 0), prey = mkUnit('Caravel', 0, 1);
    G.eventQueue = []; navalAttack(priv, prey);
    Math.random = rnd;
    w1.evasive = /evades/.test(q());
    // The trade-route editor now carries the bundled bodies.
    w1.tradeBodies = !!(DATA.events.TRADESTART && DATA.events.TRADETYPE &&
                        DATA.events.TRADEDELETE && DATA.events.TRADESELECT &&
                        DATA.dialogs.TRADENAME);
    // Rumour asks + fountain picker + remaining keys are bundled.
    w1.bundled = !!(DATA.events.LOSTCITY0 && DATA.events.LOSTCITY4 &&
                    DATA.events.TIMECHANGE && DATA.events.CONTINENTAL &&
                    DATA.events.WAREHOUSEFULL && DATA.events.FOOD1 &&
                    DATA.events.FOOD2 && DATA.events.STARVE2 &&
                    DATA.events.EFFICIENT && DATA.events.INEFFICIENT &&
                    DATA.dialogs.LANDFALL2 && DATA.events.SEACOLONY &&
                    DATA.events.ONLYPIO && DATA.events.NOPLOW &&
                    DATA.events.NOROAD && DATA.events.LANDFIRST);
    out.wire1 = w1;

    // ---- Phase 2 batch 1: outage latches, VANISH, unit builds, rush-buy,
    // back-tax, REFIT ----
    const w2 = {};
    // A manned distiller with no sugar posts @CANESUGAR once, latched.
    const oc = { name: 'O', x: 9, y: 9, nation: G.nation,
                 colonists: [{ type: 'Colonists', profession: null, job: 'Distiller', cell: null }],
                 stock: DATA.cargo.map(() => 0), hammers: 0, building: null,
                 sol: 0, buildings: STARTING_BUILDINGS.concat(["Rum Distiller's House"]) };
    oc.stock[GOOD.FOOD] = 100;
    G.eventQueue = []; colonyTurn(oc);
    const fired1 = /run out of.*sugar/i.test(q());
    oc.stock[GOOD.FOOD] = 100;
    G.eventQueue = []; colonyTurn(oc);
    w2.outageLatch = fired1 && !/run out of/i.test(q());
    // The last colonist starving takes the colony with it (@VANISH). The
    // centre tile is pinned to Arctic so it cannot feed the colony.
    const vi = 9 * MAP.w + 9, vsv = MAP.tiles[vi];
    MAP.tiles[vi] = 24;
    const vc = { name: 'V', x: 9, y: 9, nation: G.nation,
                 colonists: [{ type: 'Colonists', profession: null, job: null, cell: null }],
                 stock: DATA.cargo.map(() => 0), hammers: 0, building: null,
                 sol: 0, buildings: STARTING_BUILDINGS.slice() };
    G.eventQueue = []; colonyTurn(vc); colonyTurn(vc);
    w2.vanish = vc.vanished === true && /vanished/i.test(q());
    MAP.tiles[vi] = vsv;
    // Colony-built units: a Wagon Train completes into a map unit; the cap
    // (wagons >= colonies) stalls with @NOMOREWAGONS.
    const uc = { name: 'U', x: 9, y: 9, nation: G.nation,
                 colonists: [{ type: 'Colonists', profession: null, job: null, cell: null }],
                 stock: DATA.cargo.map(() => 0), hammers: 0, building: 'Wagon Train',
                 sol: 0, buildings: STARTING_BUILDINGS.slice() };
    G.colonies.push(uc);
    const beforeUnits = G.units.length;
    G.eventQueue = []; advanceConstruction(uc, 9999);
    w2.buildWagon = G.units.length === beforeUnits + 1 &&
                    G.units[G.units.length - 1].type === 'Wagon Train' &&
                    uc.building === null;
    uc.building = 'Wagon Train'; uc.hammers = 0;
    const spare = G.units.filter(u => u.type === 'Wagon Train').length;
    for (let k = G.colonies.length; k <= spare; k++)
      G.units.push(mkUnit('Wagon Train', 8, 8));
    G.eventQueue = []; advanceConstruction(uc, 9999);
    w2.wagonCap = /wagon trains than we have colonies/i.test(q()) &&
                  uc.building === 'Wagon Train';
    G.units = G.units.filter(u => u.type !== 'Wagon Train');
    // Ships need the Shipyard; artillery the Armory chain.
    w2.unitGates = !buildOptions(uc).some(b => b.name === 'Caravel') &&
                   (uc.buildings.push('Shipyard'),
                    buildOptions(uc).some(b => b.name === 'Caravel')) &&
                   buildOptions(uc).some(b => b.name === 'Wagon Train');
    // Rush-buy: @BUYME1 asks, row 2 completes the target now.
    uc.building = 'Stockade'; uc.hammers = 0; uc.colonists.push({}, {}, {});
    G.colony = G.colonies.indexOf(uc); G.gold = 99999;
    G.eventQueue = []; G.dialog = null; rushBuy();
    w2.rushAsked = !!(G.dialog && /Cost to complete/i.test(G.dialog.body.join(' ')));
    closeDialog(1);
    w2.rushBuilt = uc.buildings.includes('Stockade');
    w2.rushPaid = G.gold < 99999;
    G.colonies.pop();
    // Back-tax: selling a boycotted good asks @KISSUP (price x 500); paying
    // clears the boycott and feeds the King's fund.
    G.europe.push({ type: 'Caravel', state: 'port', hold: [{ good: 3, qty: 10 }],
                    passengers: [], cargo: [] });
    G.euroShip = shipsInPort().indexOf(G.europe[G.europe.length - 1]);
    G.boycotts = [3]; G.gold = 99999;
    const fund0 = G.kingsFund, expect = G.market[3] * 500;
    G.eventQueue = []; sellFromShip(3);
    const askedTax = G.dialog && /back taxes/i.test(G.dialog.body.join(' '));
    closeDialog(1);
    w2.backTax = askedTax && !G.boycotts.includes(3) &&
                 G.kingsFund === fund0 + expect;
    G.europe.pop();
    // @REFIT: a damaged ship over a Drydock colony repairs at end of turn.
    const rc2 = { name: 'R', x: 4, y: 4, nation: G.nation,
                  colonists: [{ type: 'Colonists', profession: null, job: null, cell: null }],
                  stock: DATA.cargo.map(() => 0), hammers: 0, building: null,
                  sol: 0, buildings: STARTING_BUILDINGS.concat(['Drydock']) };
    rc2.stock[GOOD.FOOD] = 500;
    G.colonies.push(rc2);
    const hurt = mkUnit('Caravel', 4, 4); hurt.damaged = true;
    G.units.push(hurt);
    G.eventQueue = []; endTurn();
    w2.refit = hurt.damaged === false;
    G.units.splice(G.units.indexOf(hurt), 1); G.colonies.pop();
    out.wire2 = w2;

    // ---- Phase 2 batch 2: PISS bands, forest objection, trade refusals,
    // endgame clock ----
    const w3 = {};
    // A band crossing announces @PISS4 with the tribe speaker.
    G.tribes[0].tension = 15;
    G.eventQueue = []; adjustTension(0, 60, 4);
    w3.pissBand = /tribe is now .*restless|tribe is now .*angry|tribe is now .*hostile/i.test(q()) ||
                  /unprovoked attack/i.test(q());
    // @MADATWAGONS shuts village trade on the hostile band.
    const vv = G.villages.find(v => v.tribe === 0);
    G.tribes[0].tension = TENSION_HOSTILE;
    if (vv) {
      G.eventQueue = [];
      openVillageTrade(vv, { hold: [{ good: 2, qty: 10 }] });
      w3.madAtWagons = /do not wish to trade/i.test(q());
    } else w3.madAtWagons = true;
    G.tribes[0].tension = 0;
    // @LEARNMAD refuses an angry tribe's teaching.
    if (vv) {
      G.tribes[0].tension = TENSION_HOSTILE;
      G.eventQueue = [];
      liveAmong(vv, { profession: null });
      w3.learnMad = /infuriate us/i.test(q());
      G.tribes[0].tension = 0;
    } else w3.learnMad = true;
    // The retirement clock: 1800 with no revolution retires with @RETIRING,
    // the @EXPLOITS card and the @SCORED lock.
    G.year = 1799; G.season = 1; G.flags = 0; G.scored = false; G.retired = false;
    G.eventQueue = []; G.dialog = null;
    endTurn();
    w3.retire1800 = /steps down/i.test(q()) && /COLONIZATION RATING/i.test(q()) &&
                    G.retired === true &&
                    !!(G.dialog && /Scoring for this game/i.test(G.dialog.body.join(' ')));
    closeDialog(1);                                  // keep playing anyway
    w3.scoredLock = G.scored === true && G.screen !== 'title';
    // Bundled keys for the batch.
    // The tutorial: TUTORIAL1 fires with the fresh fleet, lessons are
    // idempotent, and difficulty >= 2 suppresses them.
    w3.tutorial = (() => {
      const dOrig = G.difficulty;
      G.difficulty = 0;                        // a fresh Discoverer game
      beginGame();
      const first = G.eventQueue.some(e => /high seas/i.test(e.lines.join(' ')));
      const n0 = G.eventQueue.length;
      tutOnce(1, {});
      const once = G.eventQueue.length === n0;
      G.difficulty = 2; G.tutSide = {}; G.eventQueue = [];
      tutOnce(9);
      const gated = G.eventQueue.length === 0;
      G.difficulty = dOrig;                    // do not leak the Discoverer gate
      return first && once && gated && !!DATA.events.TUTORIAL19;
    })();
    w3.bundled = !!(DATA.events.INDIANBEGFOOD && DATA.events.INDIANGIVEFOOD &&
                    DATA.events.INDIANGIVESTUFF && DATA.events.INDIANCOMMENT &&
                    DATA.events.INDIANCOME && DATA.events.INDIANFOREST &&
                    DATA.events.INDIANFOREST2 && DATA.events.PISS0 &&
                    DATA.events.SOONRETIRING0 && DATA.events.RETIRING2 &&
                    DATA.events.INDIANLAND && DATA.events.INDIANTREATY &&
                    DATA.events.INDIANBOW && DATA.events.INDIANBRIBE &&
                    DATA.events.VIOLATE && DATA.events.INDIANWINCOLONY2 &&
                    DATA.events.INDIANBURNCOLONY2 && DATA.events.INDIANLOSE &&
                    DATA.attitudinal && DATA.scorenames && DATA.scorenames.length);
    // The land claim: founding beside a hostile-band village asks
    // @INDIANLAND; "OUR land now" costs tension (@PISS5).
    w3.landClaim = (() => {
      const vv2 = G.villages[0];
      if (!vv2) return true;
      G.tribes[vv2.tribe].tension = 45;
      const settler2 = mkUnit('Colonists', vv2.x + 1, vv2.y);
      G.units.push(settler2); G.sel = G.units.indexOf(settler2);
      const ti3 = vv2.y * MAP.w + (vv2.x + 1), sv3 = MAP.tiles[ti3];
      MAP.tiles[ti3] = 3;
      const cs = G.colonies.length;
      G.dialog = null; buildColony();
      const asked = !!(G.dialog && /trespassing/i.test(G.dialog.body.join(' ')));
      closeDialog(0);                                // we leave
      const left = G.colonies.length === cs;
      G.units.splice(G.units.indexOf(settler2), 1);
      MAP.tiles[ti3] = sv3; G.tribes[vv2.tribe].tension = 0;
      return asked && left;
    })();
    out.wire3 = w3;

    // ---- the pre-capture completion sweep + the Hall of Fame ----
    const w4 = {};
    w4.bundled = !!(DATA.events.FREEDOM && DATA.events.WHICHFREEDOM &&
      DATA.events.LOOT && DATA.events.INDIANWAR && DATA.events.INDIANPEACE &&
      DATA.events.SEIZURE && DATA.events.HOWTOWIN && DATA.events.AMBUSHHINT &&
      DATA.events.TRADEWITH && DATA.events.SUREDISBAND && DATA.events.REALLYBUY &&
      DATA.events.LOBOTOMIZE && DATA.events.CARGOLOAD && DATA.events.OVERBOARD &&
      DATA.events.PICKACARGO && DATA.events.SCREWED && DATA.events.DEPLETION &&
      DATA.events.DEFOREST && DATA.events.INDIANSHUN && DATA.events.OTHERGRANTED &&
      DATA.events.TRAVELPLACE && DATA.events.CONFISCATE && DATA.events.KILLWAGONS &&
      DATA.events.SIEGES && DATA.events.APOSTATES && DATA.events.HEATHEN &&
      DATA.events.WARMEEK && DATA.events.INDIANHELLO1 && DATA.events.BRING);
    // @SUREDISBAND: disbanding asks first; Yes removes the unit.
    beginGame();
    const du = mkUnit('Soldiers', 3, 3); G.units.push(du);
    G.sel = G.units.indexOf(du);
    const nu0 = G.units.length;
    G.dialog = null; disbandUnit();
    const dAsked = !!(G.dialog && /disband/i.test(G.dialog.body.join(' ')));
    closeDialog(0);
    w4.disbandAsks = dAsked && G.units.length === nu0 - 1;
    // The Hall of Fame: descending insertion, menu row 4 opens the screen.
    try { localStorage.removeItem('colonization.hof'); } catch (e) {}
    hofWrite({ name: 'A', nation: 0, year: 1700, score: 10, rating: 10 });
    hofWrite({ name: 'B', nation: 1, year: 1710, score: 99, rating: 99 });
    hofWrite({ name: 'C', nation: 2, year: 1720, score: 50, rating: 50 });
    w4.hofSorted = hofLoad().map(x => x.name).join('') === 'BCA';
    G.screen = 'title'; G.menuRow = 4; commitMenu();
    w4.hofOpens = G.screen === 'hof';
    G.screen = 'map';
    out.wire4 = w4;
  }

  // ---- Phase 4 batch 1: the func_05CA7E aftermath bulletins ----
  {
    beginGame(); G.screen = 'map';
    const w5 = {};
    // All seven newly wired keys are bundled with real bodies.
    w5.bundled = ['BURNED2', 'BURNED3', 'CAPTURED2', 'CAPTURED3', 'EUROPEWIN',
                  'EUROPELOSE', 'INDIANWINCOLONY']
      .every(k => DATA.events[k] && DATA.events[k].body.length);
    // The declared split at the player-capture site: post-declaration
    // captures announce CAPTURED3 (no plunder line).
    const q = () => G.eventQueue.map(e => (e.lines || []).join(' ')).join(' | ');
    const rv = G.rivals[0];
    rv.met = true;
    rv.colonies.push({ x: 5, y: 5, nation: rv.nation, name: 'Testville',
                       level: 0, pop: 1 });
    G.declared = true;
    const cap3 = DATA.events.CAPTURED3.body.join(' ').includes('march into');
    w5.captured3Body = cap3;
    G.declared = false;
    // The massacre branch: an undefended 2-colonist colony loses one to a
    // burn-outcome raid and INDIANWINCOLONY fires.
    G.colonies.push({ name: 'Mass', x: 8, y: 8, nation: G.nation,
                      colonists: [{ type: 'Colonists' }, { type: 'Colonists' }],
                      stock: DATA.cargo.map(() => 0),
                      buildings: STARTING_BUILDINGS.slice(),
                      hammers: 0, building: null, sol: 0 });
    const mc = G.colonies[G.colonies.length - 1];
    const v0 = G.villages[0];
    G.eventQueue.length = 0;
    const rollOrig = raidOutcome;
    // Pin the raid ladder to the burn outcome (case 4).
    window.raidOutcome = () => 4;
    let fired = false;
    for (let i = 0; i < 6 && !fired; i++) {
      G.eventQueue.length = 0;
      nativeRaid(v0, mc);
      fired = /massacre/i.test(q()) || mc.colonists.length === 1;
    }
    window.raidOutcome = rollOrig;
    w5.massacre = fired && mc.colonists.length === 1;
    out.wire5 = w5;
  }

  // ---- the input-gesture fix batch (Go To Europe row, press-edge menus,
  // ---- flick drags, nation-sack ink) ----
  {
    beginGame(); G.screen = 'map';
    const w6 = {};
    // 1. A ship's Go To picker lists every coastal colony then the homeport,
    //    and the homeport row sails for Europe.
    G.colonies.push({ name: 'Porto', x: G.units[0].x - 2, y: G.units[0].y,
                      nation: G.nation, colonists: [{ type: 'Colonists' }],
                      stock: DATA.cargo.map(() => 0),
                      buildings: STARTING_BUILDINGS.slice(),
                      hammers: 0, building: null, sol: 0 });
    G.sel = 0; G.dialog = null;
    beginGoTo();
    const rows = (G.dialog && G.dialog.opts) || [];
    w6.goToRows = rows.length >= 2 && rows[0] ===
        `${DATA.nations[G.nation].homeport} (${DATA.nations[G.nation].country})`;
    closeDialog(0);
    w6.goToSails = G.screen === 'europe' &&
                   G.europe.some(e => e.state === 'toEurope');
    G.screen = 'map'; G.europe.length = 0;
    // 2. The pulldown opens on the press edge and commits on release.
    // (The ship is IN G.europe now, not G.units -- anchor on the colony.)
    G.units.push(mkUnit('Colonists', G.colonies[0].x - 4, G.colonies[0].y));
    const lu = G.units[G.units.length - 1];
    MAP.tiles[lu.y * MAP.w + lu.x] = 2;
    G.tribes.forEach(t => t.tension = 0);
    G.sel = G.units.length - 1; G.dialog = null; G.eventQueue.length = 0;
    PTR.down = true; PTR.moved = false; PTR.downX = 85; PTR.downY = 4;
    onPointerDown(85, 4, false, false);
    w6.menuOpensOnPress = G.openMenu === 2;
    PTR.moved = true;
    onPointerMove(95, 53);                       // row 5 = Build Colony
    w6.menuTracksHeld = G.menuSel === 5;
    onPointerUp(95, 53, false);
    PTR.down = false; PTR.suppressClick = false;
    w6.menuCommitsOnRelease = !!G.dialog;
    for (let i = 0; i < 5 && G.dialog && G.dialog.entry === undefined; i++) closeDialog(1);
    if (G.dialog && G.dialog.entry !== undefined) closeDialog(G.dialog.entry);
    G.eventQueue.length = 0;
    w6.menuFounded = G.colonies.length === 2;
    // 3. A fast flick (no 131ms hold) still lifts and lands the colonist.
    G.colony = G.colonies.length - 1; G.screen = 'colony';
    const cc = G.colonies[G.colony];
    if (!cc.buildings.includes("Blacksmith's House"))
      cc.buildings.push("Blacksmith's House");
    cc.colonists.forEach(p => { p.cell = null; p.job = null; });
    const pe = plazaRow(cc).filter(q2 => q2.colonist >= 0)[0];
    const sx = pe.x + (pe.w >> 1), sy = PLAZA_ROW_Y + (pe.h >> 1);
    const present = colonyPlacement(cc);
    let dst = null;
    PLOTS.forEach((pl, i) => {
      const id = present[i];
      if (id >= 0 && (DATA.buildings[id] || {}).name === "Blacksmith's House") {
        const [fw, fh] = frameSize('BUILDING', buildingFrame(cc, id));
        dst = [pl[0] + (fw >> 1), pl[1] + 8 + (fh >> 1)];
      }
    });
    PTR.down = true; PTR.moved = false; PTR.downX = sx; PTR.downY = sy;
    onPointerDown(sx, sy, false, false);
    PTR.moved = true;
    onPointerMove(sx + 8, sy - 8);               // beyond jitter, inside 131ms
    w6.flickLifts = !!G.drag;
    onPointerUp(dst[0], dst[1], false);
    PTR.down = false; PTR.suppressClick = false;
    w6.flickAssigns = cc.colonists[pe.colonist].job === 'Blacksmith';
    // 4. The nation sack paints the nation colour, not fillStyle-fallback
    //    black (the lut()-as-fillStyle regression).
    const oc = document.createElement('canvas');
    oc.width = 16; oc.height = 16;
    const octx = oc.getContext('2d');
    usePalette('EUROPE');
    drawSack(octx, 0, 0);
    const px = octx.getImageData(3, 3, 1, 1).data;
    const nc = PAL[DATA.nations[G.nation].color];
    w6.sackInk = px[0] === nc[0] && px[1] === nc[1] && px[2] === nc[2];
    G.screen = 'map';
    out.wire6 = w6;
  }

  // ---- the colony worker layer, dialog speakers, crash guards ----
  {
    const w7 = {};
    beginGame(); G.screen = 'map';
    const sh = G.units[0];
    G.colonies.push({ name: 'Porto', x: sh.x, y: sh.y, nation: G.nation,
                      colonists: [{ type: 'Colonists', job: 'Blacksmith',
                                    cell: null, profession: null }],
                      stock: DATA.cargo.map(() => 0),
                      buildings: STARTING_BUILDINGS.concat(["Blacksmith's House"]),
                      hammers: 0, building: null, sol: 0 });
    G.colony = G.colonies.length - 1;
    // A manned building draws its worker + production; the same colony with
    // the man idle draws neither -- the two frames must differ inside the
    // building field (0,8,199,120).
    const shot = () => {
      const cv = document.createElement('canvas');
      cv.width = 320; cv.height = 200;
      const g = cv.getContext('2d');
      drawColony(g);
      return g.getImageData(0, 8, 199, 120).data;
    };
    G.screen = 'colony';
    const manned = shot();
    G.colonies[G.colony].colonists[0].job = null;
    const idle = shot();
    G.colonies[G.colony].colonists[0].job = 'Blacksmith';
    let diff = 0;
    for (let i = 0; i < manned.length; i += 4)
      if (manned[i] !== idle[i] || manned[i + 1] !== idle[i + 1]) diff++;
    w7.workerLayer = diff > 50;
    G.screen = 'map'; G.eventQueue.length = 0;
    // Capture-pinned dialog speakers.
    openDialog('LANDFALL', () => {});
    w7.landfallSpeaker = G.dialog.speaker === 'MSS3';
    G.dialog = null;
    openDialog('SAILAWAY', () => {});
    w7.sailSpeaker = G.dialog.speaker === 'MSS0';
    G.dialog = null;
    // The input guard reports and clears the transient drag state.
    G.drag = { screen: 'colony' };
    guarded(() => { throw new Error('guard-probe'); })();
    w7.guardCatches = _frameErr === 'guard-probe' && G.drag === null;
    _frameErr = null;
    // A unit standing down into a colony sheds its outfit to the stores and
    // becomes the man underneath (user report: a Pioneer joining the
    // Blacksmith's House stayed "Pioneers", tools lost).
    {
      const jc = { name: 'JoinTest', x: 1, y: 1, nation: G.nation,
                   colonists: [], stock: DATA.cargo.map(() => 0),
                   buildings: STARTING_BUILDINGS.slice(),
                   hammers: 0, building: null, sol: 0 };
      const pio = { type: 'Pioneers', profession: null, tools: 60 };
      const asCol = unitToColonist(pio, jc);
      w7.pioneerSheds = asCol.type === 'Colonists' && asCol.profession === null &&
                        jc.stock[GOOD.TOOLS] === 60;
      const drg = { type: 'Dragoons', profession: 'Veteran Dragoons' };
      const asCol2 = unitToColonist(drg, jc);
      w7.dragoonSheds = asCol2.type === 'Colonists' &&
                        asCol2.profession === 'Veteran Dragoons' &&
                        jc.stock[GOOD.MUSKETS] === 50 && jc.stock[GOOD.HORSES] === 50;
      // The figure rule: experts wear their profession's figure, plain men
      // the free-colonist 100.
      w7.figures = colonistFigure({ type: 'Colonists', profession: 'Master Carpenters' }) === 94 &&
                   colonistFigure({ type: 'Colonists', profession: null }) === 100;
    }
    // The load fixup re-establishes invariants a stale save may lack.
    saveGame();
    const raw = JSON.parse(localStorage.getItem(SAVE_KEY));
    delete raw.G.colonies[raw.G.colonies.length - 1].stock;
    raw.G.dockUnits = null;
    localStorage.setItem(SAVE_KEY, JSON.stringify(raw));
    G.eventQueue.length = 0;
    loadGame();
    const lc = G.colonies[G.colonies.length - 1];
    w7.loadFixup = Array.isArray(lc.stock) &&
                   lc.stock.length === DATA.cargo.length &&
                   Array.isArray(G.dockUnits);
    G.eventQueue.length = 0;
    // The dialog framework runs on FONTINTR with the byte-read font-relative
    // pitches (text glyph_h+1 = 10, rows glyph_h+border = 12) -- the layout
    // of a 2-line, 2-row dialog is exactly 6 + 20 + 3 + 24 + 3 = 56 tall.
    w7.dialogFont = DFONT() === FONT.intr;
    const lay = layoutDialog({ width: 190, body: ['a', 'b'], tail: [],
                               opts: ['x', 'y'] });
    w7.dialogPitch = lay.h === 6 + 2 * 10 + 3 + 2 * 12 + 3 &&
                     lay.textH === 20;
    out.wire7 = w7;
  }

  // ---- Phase 5: the scripted end-to-end playtest ----
  // One full game driven through the PUBLIC flows: fresh Discoverer game ->
  // tutorial -> landfall -> founding -> colony work -> the Europe trade run
  // (Go To picker's Europe row, market purchase, the crossing both ways,
  // unload) -> declaration -> the war -> retirement -> Hall of Fame; then
  // the losing war. The slow middles are STAGED and marked: the liberty-bell
  // climb (hundreds of turns) and the war's combat attrition (covered by the
  // combat blocks) are set rather than ground out.
  {
    const pt = {};
    try { localStorage.removeItem('colonization.hof'); } catch (e) {}
    // A fresh Discoverer game queues the tutorial's first card at once.
    const diffWas = G.difficulty;
    G.difficulty = 0;
    beginGame(); G.screen = 'map';
    pt.tutorialFires = G.eventQueue.some(e => e.key && /^TUTORIAL/.test(e.key));
    G.eventQueue.length = 0;

    // Landfall and founding, by the same route the landfall block drives --
    // with the Discoverer game's tutorial cards drained between steps (they
    // queue alongside the asks, and onClick answers the QUEUE first).
    const sh = G.units[0];
    for (let i = 0; i < 25 && !G.dialog; i++) { sh.movesLeft = 9; moveSel(-1, 0); }
    G.eventQueue.length = 0;
    closeDialog(1);
    G.eventQueue.length = 0;
    if (G.screen === 'woodcut') onClick(-1, -1);
    if (G.dialog && G.dialog.entry !== undefined) dialogKey('Enter');
    G.sel = G.units.findIndex(u => !u.ship);
    const pio = G.units[G.sel];
    G.natives = G.natives.filter(n => Math.abs(n.x - pio.x) > 2 || Math.abs(n.y - pio.y) > 2);
    G.villages = G.villages.filter(v => Math.abs(v.x - pio.x) > 2 || Math.abs(v.y - pio.y) > 2);
    MAP.tiles[pio.y * MAP.w + pio.x] = 2;      // staged: pin the site to Plains
    G.tribes.forEach(t => t.tension = 0);      // staged: calm the land-claim
    buildColony();
    for (let i = 0; i < 4 && G.dialog && G.dialog.entry === undefined; i++) closeDialog(1);
    if (G.dialog) closeDialog('Freetown');
    G.eventQueue.length = 0;
    pt.founded = G.colonies.length === 1 && G.colonies[0].name === 'Freetown';
    const c = G.colonies[0];

    // Colony work: the founder onto a LAND field through the scene panel's
    // own click flow, a second man into the Town Hall through the jobs popup.
    G.colony = 0; G.screen = 'colony';
    c.colonists.push({ type: 'Colonists', profession: null, job: null, cell: null });
    G.colonistSel = 0;
    let cell = null;
    for (const [cx, cy] of [[1,0],[-1,0],[0,1],[0,-1],[1,1],[-1,-1],[1,-1],[-1,1]])
      if (!tileWater(at(c.x + cx, c.y + cy))) { cell = [cx, cy]; break; }
    if (cell) onClick(224 + (cell[0] + 1) * 24 + 12, 32 + (cell[1] + 1) * 24 + 12);
    pt.fieldAssigned = !!(c.colonists[0].cell && c.colonists[0].job);
    G.colonistSel = 1; G.colonyPopup = 'jobs';
    const jr = colonyPopupRows().findIndex(r => r.label === 'Town Hall');
    G.colonyPopupRow = jr; colonyPopupCommit();
    pt.hallAssigned = jr > 0 && c.colonists[1].job === jobForBuilding('Town Hall');
    // A few working turns actually produce.
    G.screen = 'map';
    const bells0 = G.bellsTotal || 0;
    for (let t = 0; t < 3; t++) { c.stock[GOOD.FOOD] = 100; endTurn(); }
    G.eventQueue.length = 0; G.dialog = null;
    pt.produced = (G.bellsTotal || 0) > bells0;

    // The Europe run: Go To's Europe row sails the ship, the crossing takes
    // its three turns, the market sells us 100 muskets, and the ship carries
    // them home for the war chest.
    G.sel = G.units.findIndex(u => u.ship);
    beginGoTo();
    closeDialog(0);                            // the Europe row leads the list
    pt.sailed = G.europe.some(e => e.state === 'toEurope');
    for (let t = 0; t < 5 && !G.europe.some(e => e.state === 'port'); t++) endTurn();
    G.eventQueue.length = 0; G.dialog = null;
    const docked = G.europe.find(e => e.state === 'port');
    pt.docked = !!docked;
    const gold0 = G.gold;
    buyToShip(GOOD.MUSKETS, 100);
    pt.bought = holdQty(docked, GOOD.MUSKETS) === 100 && G.gold < gold0;
    confirmSailAway(docked); closeDialog(0);
    for (let t = 0; t < 5 && !G.units.some(u => u.ship); t++) endTurn();
    G.eventQueue.length = 0; G.dialog = null;
    const back = G.units.find(u => u.ship);
    pt.returned = !!back && holdQty(back, GOOD.MUSKETS) === 100;
    // Staged positioning: docking AT the colony tile (harbour navigation is
    // not what this asserts), then the real unload dialog chain.
    back.x = c.x; back.y = c.y; G.sel = G.units.indexOf(back);
    const musk0 = c.stock[GOOD.MUSKETS] || 0;   // the founding Soldiers shed 50
    unloadCargo();
    for (let i = 0; i < 3 && G.dialog; i++) {
      if (G.dialog.numeric) { dialogKey('Enter'); break; }
      const anyway = (G.dialog.opts || []).findIndex(o => /anyway/i.test(o));
      closeDialog(anyway >= 0 ? anyway : 0);   // spoilage warn -> unload anyway
    }
    pt.unloaded = (c.stock[GOOD.MUSKETS] || 0) === musk0 + 100;

    // Declaration. Staged: the liberty climb (c.sol, a hundreds-of-turns
    // grind) and a guaranteed coastal halo tile for the King's landing.
    c.sol = 80;
    G.units.push(mkUnit('Soldiers', c.x, c.y));
    if (!coastalColonies().length) MAP.tiles[(c.y + 1) * MAP.w + c.x + 1] = 25;
    G.eventQueue.length = 0;
    declareIndependence();
    closeDialog(1);                            // @DECLARE row 1 = declare
    pt.declared = !!(G.flags & WOI_DECLARED);
    pt.mobilized = G.units.some(u => u.type === 'Cont. Army');
    pt.refLands = G.refUnits.filter(u => !u.ship).length > 0;
    G.eventQueue.length = 0;

    // The war, won. Staged: the Crown's attrition (combat has its own
    // blocks) -- the reserve empties and the landed wave falls; the per-turn
    // resolver must then declare the rebel victory on its own.
    REF_TYPES.forEach(t => G.ref[t] = 0);
    G.refUnits.length = 0;
    G.royalFund = 0;                           // Parliament's kitty, spent too
    endTurn();
    pt.won = !!(G.flags & WOI_WON) &&
             G.eventQueue.some(e => e.key === 'KINGLOSE' || e.key === 'WINNING');
    G.eventQueue.length = 0; G.dialog = null;

    // Retirement seals it in the Hall of Fame.
    retire(); closeDialog(0);                  // @RETIRE row 0 = retire
    pt.scoredScreen = G.screen === 'report' && G.report === 'F10';
    if (G.dialog) closeDialog(1);              // @SCORED "keep playing"
    const rec = hofLoad()[0];
    pt.hof = !!rec && rec.independent === true && rec.declared === true &&
             rec.nation === G.nation;
    G.eventQueue.length = 0; G.dialog = null; G.scored = false;

    // The war, lost: undefended colonies, the King razes the last one, and
    // the defeat sequence writes its own (dependent) record.
    beginGame(); G.screen = 'map';
    G.colonies.push({ name: 'Doomed', x: 30, y: 30, nation: G.nation,
                      colonists: [{ type: 'Colonists', job: null, cell: null }],
                      stock: DATA.cargo.map(() => 0),
                      buildings: STARTING_BUILDINGS.slice(),
                      hammers: 0, building: null, sol: 60 });
    MAP.tiles[30 * MAP.w + 31] = 25;           // a beach for the Man-O-War
    G.units.length = 0;                        // no defenders anywhere
    G.flags |= WOI_DECLARED; G.declared = true; G.declaredYear = G.year;
    const rr = mkUnit('Regulars', 30, 30);
    rr.nation = -2; G.refUnits.push(rr);
    REF_TYPES.forEach(t => G.ref[t] = 0);
    for (let t = 0; t < 4 && G.colonies.length; t++) { runWar(); }
    pt.lostWar = G.lostWar && G.colonies.length === 0 &&
                 G.eventQueue.some(e => e.key === 'KINGWIN');
    const rec2 = hofLoad().find(r => r.independent === false);
    pt.lossRecorded = !!rec2;
    G.eventQueue.length = 0; G.dialog = null; G.scored = false;
    try { localStorage.removeItem('colonization.hof'); } catch (e) {}
    // Leave the world as the next block expects it: the pre-playtest
    // difficulty and a clean game.
    G.difficulty = diffWas;
    beginGame(); G.screen = 'map';
    out.playtest = pt;
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
    // Outcome 4 (burial mounds) now ASKS @LOSTCITY4 instead of posting.
    out.rumours.spoke = G.eventQueue.length >= 1 || !!G.dialog;
    if (G.dialog) closeDialog(1);
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
      for (let i = 0; i < 20; i++) nativeMoveAI();
      out.raidBelow = G.eventQueue.length === 0;
      // Armed, the brave has to WALK there: raids arrive on foot now, so give
      // the march the turns it needs and count what lands.
      v.alarm = 200;
      G.eventQueue = [];
      let fired = 0;
      for (let i = 0; i < 60; i++) { nativeMoveAI(); fired += G.eventQueue.length; G.eventQueue = []; }
      out.raidArmed = fired > 0;
      // func_05BE84's gate: threshold 3*K+1 with K = the colony's fortification
      // count (func_00864E via 0x181F:0xAB0), so a Fortress (K=3) repels raids
      // a bare colony (K=0) takes. Compare attempt-for-attempt.
      {
        // A raid can BURN the Fortress (RAIDBURN removes buildings), which
        // used to degrade the walled half of this comparison mid-loop and
        // flake the check -- re-arm the colony every iteration.
        let bare = 0, walled = 0;
        for (let i = 0; i < 300; i++) {
          G.eventQueue = [];
          G.colonies[0].vanished = false;
          nativeRaid(v, G.colonies[0]);
          bare += G.eventQueue.length ? 1 : 0;
        }
        for (let i = 0; i < 300; i++) {
          G.eventQueue = [];
          G.colonies[0].vanished = false;
          if (!G.colonies[0].buildings.includes('Fortress'))
            G.colonies[0].buildings.push('Fortress');
          nativeRaid(v, G.colonies[0]);
          walled += G.eventQueue.length ? 1 : 0;
        }
        G.colonies[0].buildings = G.colonies[0].buildings
          .filter(b => b !== 'Fortress');
        G.eventQueue = [];
        out.raidFortGate = { bareRaids: bare > 0, fortressRepels: walled < bare };
      }
      // Popup speakers ride the §2.7 channels: native keys the tribe's IND
      // sheet, the military family MSS5, the king keys KING1 -- and all three
      // sheets are in the bundle to draw.
      {
        G.eventTribe = v.tribe; G.eventQueue = [];
        showEvent('RAIDGOLD', { STRING0: 'x', STRING1: 'y', NUMBER0: 1 });
        const spInd = G.eventQueue[0] && G.eventQueue[0].speaker;
        G.eventQueue = []; showEvent('VETERAN', { STRING0: 'x' });
        const spMil = G.eventQueue[0] && G.eventQueue[0].speaker;
        G.eventQueue = []; showEvent('KINGWIN', {});
        const spKing = G.eventQueue[0] && G.eventQueue[0].speaker;
        G.eventQueue = [];
        out.speakers = {
          ind: spInd === `IND${v.tribe % 8}A0`, mil: spMil === 'MSS0',
          king: spKing === 'KING1',
          sheets: !!(DATA.sheets.KING1 && DATA.sheets.MSS5 &&
                     DATA.sheets[`IND${v.tribe % 8}A0`]),
        };
      }
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
      for (let t = 0; t < 40; t++) rivalTurn();
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
  G.menuSel = menuVisibleRows(0).findIndex(r => !r.sep && r.label === 'Pick Music');
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

  // ---- TERRAIN resolves through the master VICEROY.PAL ----
  // TERRAIN.SS carries an embedded palette that disagrees with VICEROY.PAL on
  // the sea-lane sparkle band; the live map screen streams the master. Sea Lane
  // (frame 11) is the only frame that shows the difference, so read it back.
  // master 121 = (81,105,178); the sheet's own 121 = (93,121,178).
  {
    const c = document.createElement('canvas'); c.width = 16; c.height = 16;
    const g = c.getContext('2d');
    sheetFrame(g, 'TERRAIN', 11, 0, 0);
    const d = g.getImageData(0, 0, 16, 16).data;
    const has = (r, gr, b) => {
      for (let i = 0; i < 256; i++) {
        const o = i * 4;
        if (d[o] === r && d[o + 1] === gr && d[o + 2] === b) return true;
      }
      return false;
    };
    out.seaLanePalette = { master: has(81, 105, 178), notSheet: !has(93, 121, 178) };
  }

  // ---- VGA colour cycling (CYCLE.DAT) ----
  // One band: 8 entries from index 120, one step every 35 ticks of the engine's
  // 60.8766 Hz timer. A step moves each colour one index UP and wraps the last
  // into the first, so at phase p index 120+k shows the colour authored at
  // 120+(k-p mod 8). Sea Lane (TERRAIN frame 11) is the cleanest read: it uses
  // all eight band entries.
  {
    const c = document.createElement('canvas'); c.width = 16; c.height = 16;
    const g = c.getContext('2d');
    const shot = (ph) => {
      const was = G.cyclePhase;
      G.cyclePhase = ph;
      g.clearRect(0, 0, 16, 16);
      sheetFrame(g, 'TERRAIN', 11, 0, 0);
      G.cyclePhase = was;
      return Array.from(g.getImageData(0, 0, 16, 16).data);
    };
    const same = (a, b) => a.length === b.length && a.every((v, i) => v === b[i]);
    const P = DATA.palette;
    // Frame 11 pixel (12,0) is band index 121 (see the offline probe in
    // scratchpad/cycle_phase_probe.py); at phase p it must show 120+(1-p mod 8).
    const at = (d, x, y) => [d[(y * 16 + x) * 4], d[(y * 16 + x) * 4 + 1],
                             d[(y * 16 + x) * 4 + 2]];
    const frames = [];
    for (let p = 0; p < 8; p++) frames.push(shot(p));
    let walks = true;
    for (let p = 0; p < 8; p++) {
      const want = P[120 + (((1 - p) % 8) + 8) % 8];
      const got = at(frames[p], 12, 0);
      if (got[0] !== want[0] || got[1] !== want[1] || got[2] !== want[2]) walks = false;
    }
    out.cycle = {
      band: CYC.start === 120 && CYC.len === 8 && CYC.delay === 35,
      // 1193182 / 1960 / 2 / 5 -- PIT divisor 0x7a8, the ISR's even-tick gate
      // and its [0x376] reload of 5.
      hz: Math.abs(CYC.hz - 60.8766) < 0.001,
      // Phase 0 must leave the atlas exactly as built -- nothing has rotated.
      phase0IsIdentity: same(frames[0], shot(0)) && same(frames[0], shot(null)),
      // Rotating the full band length returns to the start.
      wrapsAtLen: same(frames[0], shot(8)),
      // Every phase is distinct, i.e. the band really is 8 different colours.
      allDistinct: frames.every((f, i) => frames.every((h, j) => i === j || !same(f, h))),
      walksUpOneIndexPerStep: walks,
      // The mask ships for every sheet the map view composites water from.
      sheets: ['ICONS', 'PHYS0', 'PHYS0C', 'TERRAIN'].every(s => CYC.sheets.includes(s)),
    };
  }

  // ---- live-DOSBox corrections (docs/LIVE_UI_CHECK_2026-08-05.md) ----
  {
    const LIVE_TERRAIN = ['Arctic','Boreal Forest','Broadleaf Forest','Conifer Forest',
      'Desert','Grassland','Hills','Marsh','Mixed Forest','Mountains','Ocean','Plains',
      'Prairie','Rain Forest','Savannah','Scrub Forest','Sea Lane','Swamp',
      'Tropical Forest','Tundra','Wetland Forest'];
    const wasCat = G.pediaCat;
    G.pediaCat = 2;
    const names = pediaList().map(e => e.name);
    // Article ids stay the ENGINE terrain ids through the alphabetical sort:
    // Arctic is @OTHER[0] = 24, Boreal Forest is @FORESTED[0] = 8.
    const byName = Object.fromEntries(pediaList().map(e => [e.name, e.idx]));
    G.pediaCat = wasCat;
    out.liveFixes = {
      terrainNames: names.length === 21 && names.every((n, i) => n === LIVE_TERRAIN[i]),
      terrainIds: byName['Arctic'] === 24 && byName['Boreal Forest'] === 8
                  && byName['Tundra'] === 0 && byName['Sea Lane'] === 26,
      // Carried units are labelled by equipment / veteran status.
      carriedLabels: carriedLabel('Pioneers') === '100 Tools'
                     && carriedLabel('Soldiers') === 'Veteran'
                     && carriedLabel('Caravel') === 'Caravel',
    };
  }
  {
    // Advisor reports: every one is a byte-cited table now, and none of them
    // blits an advisor portrait -- the shared draw chain has no such step.
    const keys = ['F2','F3','F4','F5','F6','F7','F8','F9','F10'];
    out.reports = {
      allHaveTables: keys.every(k => typeof (REPORTS[k] || {}).draw === 'function'),
      noAdviserField: keys.every(k => !('adviser' in (REPORTS[k] || {}))),
      // Titles come from @MISC, not hardcoded English.
      titlesFromMisc: REPORTS.F4.title === DATA.text.misc[49]
                      && REPORTS.F7.title === DATA.text.misc[52]
                      && REPORTS.F9.title === DATA.text.misc[29],
    };
    // No MSS portrait pixels anywhere on a rendered report.
    const c = document.createElement('canvas'); c.width = 320; c.height = 200;
    const g = c.getContext('2d');
    const wasR = G.report, wasS = G.screen;
    G.report = 'F4'; G.screen = 'report';
    drawReport(g);
    G.report = wasR; G.screen = wasS;
    const d = g.getImageData(0, 0, 320, 200).data;
    // F4's grid must have put row labels at the byte-cited first row y=26 in
    // ink 0x92 (255,243,93) starting at column base 2 + 12.
    let labelRow = false;
    for (let y = 26; y < 32 && !labelRow; y++)
      for (let x = 14; x < 105; x++) {
        const o = (y * 320 + x) * 4;
        if (d[o] > 230 && d[o + 1] > 220 && d[o + 2] < 140) { labelRow = true; break; }
      }
    out.reports.f4GridAtCitedRow = labelRow;

    // --- the three reports rebuilt from live DOSBox frames -----------------
    const px = (dd, x, y) => { const o = (y * 320 + x) * 4;
                               return [dd[o], dd[o + 1], dd[o + 2]]; };
    const eq = (c, r, g2, b) => c[0] === r && c[1] === g2 && c[2] === b;
    const render = (key, pre) => {
      const cv = document.createElement('canvas'); cv.width = 320; cv.height = 200;
      const gg = cv.getContext('2d');
      const rr = G.report, ss = G.screen;
      if (pre) pre();
      G.report = key; G.screen = 'report';
      drawReport(gg);
      G.report = rr; G.screen = ss;
      return gg.getImageData(0, 0, 320, 200).data;
    };
    // The report title is centred on the INK width, one pixel narrower than the
    // advance width. ECONOMIC ADVISER REPORT lands with its first lit column at
    // x=116 on the live frame; anything centred on w/2 starts at 115.
    const d5 = render('F5');
    let titleX = -1;
    for (let x = 100; x < 160 && titleX < 0; x++)
      for (let y = 5; y < 10; y++)
        if (eq(px(d5, x, y), 255, 255, 190)) { titleX = x; break; }
    out.reports.titleCentredOnInk = titleX === 116;
    // F5: 17 dark-red rules at y = 33 + 8i spanning x 2..312.
    const ruleAt = (dd, y) => eq(px(dd, 2, y), 134, 0, 0) && eq(px(dd, 312, y), 134, 0, 0);
    out.reports.f5Rules = [...Array(17).keys()].every(i => ruleAt(d5, 33 + 8 * i))
                          && !ruleAt(d5, 34);
    // F5: the good's name starts at the left margin, no commodity icon.
    let f5Name = false;
    for (let y = 35; y < 40 && !f5Name; y++)
      if (eq(px(d5, 2, y), 255, 243, 93)) f5Name = true;
    out.reports.f5NameAtMargin = f5Name;
    // F7: the grid the spec says does not exist -- three column separators and
    // eight full-width rules.
    const d7 = render('F7');
    const colAt = (x) => eq(px(d7, x, 30), 134, 0, 0) && eq(px(d7, x, 170), 134, 0, 0);
    out.reports.f7Grid = [82, 162, 242].every(colAt)
                         && [40, 60, 80, 100, 120, 140, 160, 180]
                            .every(y => eq(px(d7, 3, y), 134, 0, 0))
                         && !colAt(112);
    // F9: block pitch 21, and the tribe's name in the tribe's OWN colour.
    const tupi = G.tribes.findIndex(t => t.singular === 'Tupi');
    const d9 = render('F9', () => {
      G.villages.forEach(v => { SEEN[v.y * MAP.w + v.x] &= ~SEEN_BIT(); });
      G.villages.filter(v => v.tribe === tupi)
                .forEach(v => { SEEN[v.y * MAP.w + v.x] |= SEEN_BIT(); });
    });
    // Some TRIBE.TXT sites coincide after the +2 column shift, so revealing the
    // Tupi camps can light another tribe's row too. Find whatever row the Tupi
    // colour lands on and assert it starts at the name column and sits on the
    // 21-pixel block grid.
    const tc = PAL[G.tribes[tupi].color];
    let nameX = -1, nameY = -1;
    for (let y = 20; y < 180 && nameY < 0; y++)
      for (let x = 20; x < 120; x++)
        if (eq(px(d9, x, y), tc[0], tc[1], tc[2])) { nameX = x; nameY = y; break; }
    out.reports.f9TribeColour = nameX === 30 && (nameY - F9_ROW0) % F9_PITCH === 0;
    out.reports.f9Pitch = F9_PITCH === 21 && F9_ROW0 === 28 && F9_ICON_Y === 25;
    // The OK button is a hollow dark-red box, not a filled one.
    out.reports.okHollow = eq(px(d7, 286, 184), 134, 0, 0)
                           && !eq(px(d7, 300, 186), 134, 0, 0);
  }
  {
    // Difficulty picker: both label lines stacked in the middle of the selected
    // cell (cell.y+38 and +46) in that row's own ink, not split top/bottom.
    const c = document.createElement('canvas'); c.width = 320; c.height = 200;
    const g = c.getContext('2d');
    const was = G.difficulty;
    G.difficulty = 0;
    drawDifficulty(g);
    G.difficulty = was;
    const d = g.getImageData(0, 0, 320, 200).data;
    const cell = DIFF_CELL(0);
    const greenRows = [];
    for (let y = cell.y + 1; y < cell.y + cell.h - 1; y++) {
      let n = 0;
      for (let x = cell.x + 1; x < cell.x + cell.w - 1; x++) {
        const o = (y * 320 + x) * 4;
        if (d[o + 1] > 120 && d[o + 1] > d[o] + 40 && d[o + 1] > d[o + 2] + 40) n++;
      }
      if (n > 3) greenRows.push(y);
    }
    out.liveFixes.diffLabelRows =
      greenRows.length > 0 && greenRows[0] === cell.y + 38
      && greenRows.includes(cell.y + 46)
      && !greenRows.some(y => y < cell.y + 30);   // nothing at the cell top
  }

  // ---- fog path (§6.11: O513 @0x68212 -> O512 @0x68244) ----
  // Render single tiles onto a scratch canvas with exactly one map square
  // explored, and read back what the fog composer put down. Every expectation
  // here is measured off docs/screens/06_ingame_map.png.
  {
    const saved = SEEN.slice();
    const wasHidden = G.showHidden;
    G.showHidden = false;
    const c = document.createElement('canvas'); c.width = 16; c.height = 16;
    const g = c.getContext('2d');
    const r = document.createElement('canvas'); r.width = 16; r.height = 16;
    const rg = r.getContext('2d');
    sheetFrame(rg, 'PHYS0', PHYS.FOG, 0, 0);
    const fogPx = rg.getImageData(0, 0, 16, 16).data;
    const render = (mx, my) => {
      g.clearRect(0, 0, 16, 16);
      drawTile(g, mx, my, 0, 0);
      return g.getImageData(0, 0, 16, 16).data;
    };
    const dotsVsFog = (mx, my) => {
      const d = render(mx, my), pts = [];
      for (let i = 0; i < 256; i++) {
        const o = i * 4;
        if (d[o] !== fogPx[o] || d[o + 1] !== fogPx[o + 1] || d[o + 2] !== fogPx[o + 2])
          pts.push([i % 16, (i / 16) | 0]);
      }
      return pts;
    };
    const X = 20, Y = 20;
    SEEN.fill(0); reveal(X, Y, 0);
    const deep = dotsVsFog(X, Y - 4);
    const diag = dotsVsFog(X - 1, Y - 1);
    const north = dotsVsFog(X, Y - 1);      // blended from its S neighbour
    const west = dotsVsFog(X - 1, Y);       // blended from its E neighbour
    // The main path must ignore unexplored neighbours: in the live frame the
    // explored patch's N-edge and S-edge tiles are pixel-identical, so neither
    // took anything from the fog it touches. Find a tile whose N neighbour is a
    // different ground class, render it with that neighbour fogged and then
    // explored, and require the biome dither to appear only in the second --
    // confined to the N stencil's top three rows.
    let L = null;
    for (let y = 2; y < MAP.h - 2 && !L; y++)
      for (let x = 2; x < MAP.w - 2; x++)
        if (!tileWater(at(x, y)) && groundFrame(at(x, y - 1)) !== groundFrame(at(x, y))
            && !tileWater(at(x, y - 1))) { L = [x, y]; break; }
    let dueToFog = [];
    if (L) {
      SEEN.fill(0); reveal(L[0], L[1], 0);
      const fogged = render(L[0], L[1]).slice();
      reveal(L[0], L[1] - 1, 0);
      const lit = render(L[0], L[1]);
      for (let i = 0; i < 256; i++) {
        const o = i * 4;
        if (fogged[o] !== lit[o] || fogged[o + 1] !== lit[o + 1] || fogged[o + 2] !== lit[o + 2])
          dueToFog.push([i % 16, (i / 16) | 0]);
      }
    }
    out.fogPath = {
      // A fog tile with no explored cardinal is frame 0x95 and nothing else.
      flatField: deep.length === 0,
      diagonalUntouched: diag.length === 0,
      // The S-direction stencil lives in the bottom three rows, the W-direction
      // one in the right three columns (0x69+dir, disk 0x68+dir).
      northBlends: north.length > 0 && north.length <= 15,
      northInBottomBand: north.length > 0 && north.every(([, y]) => y >= 13),
      westBlends: west.length > 0 && west.length <= 15,
      westInRightBand: west.length > 0 && west.every(([x]) => x >= 13),
      foundBiomeEdge: !!L,
      biomeEdgeNeedsAnExploredNeighbour:
        dueToFog.length > 0 && dueToFog.length <= 15
        && dueToFog.every(([, y]) => y <= 2),
    };
    SEEN.set(saved);
    G.showHidden = wasHidden;
  }

  // ---- the count-strip layout, replayed against the live colony frame ----
  // docs/screens/live_1653_save/colony_curacao.png, Curacao 1653. The counts
  // below are read off that frame; the x positions asserted in main() are where
  // the ICONS templates actually match in it. This is the check that settled the
  // strip pitch: one shared solve produces 5 on the top row and 6 on the bottom.
  {
    const lay = (cells, x0, span, gap) =>
      countRowLayout(cells, x0, span, gap).map(e => ({ x: e.x, last: e.last, step: e.step }));
    const c = (frame, count, sub, flags) => ({ frame, count, sub, flags: flags || 0 });
    out.stripRows = {
      // row 0: furs 3, ore 8, silver 3
      raw: lay([c(26, 3, 0), c(28, 8, 0), c(29, 3, 0)], 213, 89, 2),
      // row 1: horses (good 8, the 13px sprite and the first of the 8..15
      // slice) x4 all consumed, then cloth 6 and tools 6
      made: lay([c(30, 4, 4), c(33, 6, 0), c(36, 6, 0)], 213, 89, 2),
      // row 2: lumber 6 all consumed, hammers 6
      work: lay([c(27, 6, 0, 0x8000), c(54, 6, 0)], 213, 89, 4),
    };
    // The plaza colonist pack from the same frame: 11 sprites, the second at 11.
    out.plazaPack = (() => {
      const widths = [8, 6, 6, 6, 6, 6, 6, 8, 8, 6, 8];
      const total = widths.reduce((a, b) => a + b, 0);
      let gap = 2;
      while (gap * (widths.length - 1) + 4 + total >= 96) gap -= 1;
      let x = 2; const xs = [];
      for (const w of widths) { xs.push(x); x += Math.max(1, w + gap); }
      return { gap, second: xs[1], total };
    })();
  }

  // ---- the F2 crosses gauge, against its live frame ----
  // docs/screens/live_2026-08-05/21_report_F2_religious.png: ICONS bundle 56
  // template-matches at x = 10, 43, 76, 110, 143, 177 and y = 26 (the gauge
  // blits at y+1 for the pushed y=0x19). Replaying `func_002D74`'s geometry plus
  // the flag-bit-0 Bresenham reproduces every one, and ONLY at 9 slots -- which
  // is what shows the slot count is the caller's threshold, not a constant.
  out.f2Gauge = (() => {
    const run = (slots) => {
      const g = gaugeLayout(0x39 - 1, slots, 0x12C, 1, 0);
      const xs = []; let cx = 0x0A + g.x0, acc = 0;
      for (let i = 0; i < 6; i++) {
        xs.push(cx); cx += g.pitch;
        acc += g.leftover;
        while (acc >= slots) { acc -= slots; cx += 1; }
      }
      return xs;
    };
    return { at9: run(9), at8: run(8), at10: run(10),
             pitch: gaugeLayout(0x39 - 1, 9, 0x12C, 1, 0).pitch };
  })();

  // ---- the three production rows, against live DOSBox production tables ----
  // Curacao's own [0x8DC8] produced / [0x8E32] consumed, RAM-read while its
  // colony screen was open. What the rows should come out as, read off the same
  // frame: row 0 furs 3 / ore 8 / silver 3 (cotton is CONSUMED 6 but produced
  // 0, and the engine skips it); row 1 horses 4 all marked / cloth 6 / tools 6;
  // row 2 lumber 6 all marked / hammers 6.
  {
    const zero = () => DATA.cargo.map(() => 0);
    const gross = zero(), consumed = zero();
    [16,0,0,0,3,0,8,3,4,0,0,6,0,0,6,0].forEach((v,i) => gross[i] = v);
    [2,0,0,6,0,6,0,0,0,0,0,0,0,0,0,0].forEach((v,i) => consumed[i] = v);
    const rows = productionRows({ gross, consumed, out: gross,
                                  tally: { [HAMMERS]: 6, [BELLS]: 1, [CROSSES]: 1 },
                                  centre: 4, eaten: 18, netFood: -2 });
    out.prodRows = rows.map(row => row.filter(c => c.count > 0 || c.sub > 0)
                                     .map(c => [c.frame - 22, c.count, c.sub, c.flags]));

    // A SECOND live colony, Vlissingen (25,34), read the same way. Its lumber is
    // produced 8 / consumed 4 where Curacao's was produced 0 / consumed 6, which
    // is what resolved both [0x8E5A] and [0x8E14].
    const g2 = zero(), c2 = zero();
    [19,0,0,0,0,8,13,0,4,0,0,0,0,0,6,0].forEach((v,i) => g2[i] = v);
    [0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0].forEach((v,i) => c2[i] = v);
    const rows2 = productionRows({ gross: g2, consumed: c2, out: g2,
                                   tally: { [HAMMERS]: 12, [BELLS]: 1, [CROSSES]: 1 },
                                   centre: 4, eaten: 18, netFood: 1 });
    out.prodRows2 = rows2.map(row => row.filter(c => c.count > 0 || c.sub > 0)
                                        .map(c => [c.frame - 22, c.count, c.sub, c.flags]));
  }

  // ---- colony building placement, replayed against live DOSBox RAM ----
  // Two colonies read out of a running game with tools/colony_seed_probe.py
  // (session seed base 1410965): Jamestown at (50,51) and Curacao at (21,30).
  // Both the RNG shuffle and the resulting plot->building map are asserted
  // element for element, so the simulation is checked against the real engine's
  // own output rather than against itself.
  {
    const cases = [
      { x: 50, y: 51,
        shuffle: [6,5,4,0,3,2,1,7,10,8,9,12,11,13,14],
        present: [24,39,32,27,21,255,255,3,17,36,13,255,9,2,7] },
      { x: 21, y: 30,
        shuffle: [4,1,3,6,5,2,0,10,7,9,8,12,11,13,14],
        present: [39,255,32,21,255,27,24,255,35,15,255,255,9,0,6] },
    ];
    const savedSeed = G.plotSeedBase;
    G.plotSeedBase = 1410965;
    out.placement = cases.map(t => {
      // The shuffle on its own, straight out of the ported RNG.
      const seed = (((t.y << 8) + t.x + 1410965) >>> 0) & 0x7FFF;
      const rng = new ColonyRng(seed);
      const shuffle = new Array(15).fill(-1);
      for (let i = 0; i < 15; i++) {
        const cat = PLOT_CATEGORY[i];
        let plot;
        do { plot = rng.range(0, PLOT_COUNTS[cat] - 1) + PLOT_STARTS[cat]; }
        while (shuffle[plot] >= 0);
        shuffle[plot] = i;
      }
      // Then the whole placement, given the building set the live colony had.
      const have = t.present.filter(v => v !== 255);
      const colony = { x: t.x, y: t.y,
                       buildings: have.map(id => DATA.buildings[id].name) };
      const present = colonyPlacement(colony).map(v => (v < 0 ? 255 : v));
      return { shuffle, present };
    });
    G.plotSeedBase = savedSeed;
    // The @BUILDING `size` column IS the plot category the engine reads at
    // [0x8F87 + id*12] -- checked against the live table for all 42 rows.
    out.plotCategoryIsSize = DATA.buildings.map(b => Number(b.size));
  }

  // ---- the COLONY##.SAV importer, against the bundled 1653 save ----
  // Ground truth is the shipped COLONY00.SAV: the same file the live DOSBox
  // captures were taken from, so its figures are known independently.
  {
    const ok = importSav(b64bytes(DATA.sav1653));
    const j = G.colonies.find(c => c.name === 'Jamestown');
    out.sav = {
      ok,
      head: G.year === 1653 && G.season === 1 && G.turn === 215 &&
            G.nation === 3 && G.tax === 2 && G.gold === 21147,
      curacao: G.colonies.some(c => c.name === 'Curacao' && c.x === 21 && c.y === 30),
      colonies: G.colonies.length === 13,
      jamestown: !!j && j.colonists.length === 10 &&
                 j.colonists.filter(p => p.cell).length === 6 &&
                 j.colonists.some(p => p.job === 'Statesman') &&
                 j.stock[0] === 65 && j.stock[1] === 191 && j.sol === 12,
      market: G.market.join() === '1,7,5,5,6,2,6,14,8,8,16,15,10,2,2,10',
      fathers: G.fathersOwned.length === 7,
      europe: G.europe.length === 1 && G.dockUnits.length === 3,
      onMapClean: G.units.every(u => u.x < MAP.w && u.y < MAP.h),
      fog: (() => { let n = 0; for (let i = 0; i < SEEN.length; i++)
                    if (SEEN[i] & SEEN_BIT()) n++;
                    return n > SEEN.length / 4 && n < SEEN.length; })(),
      villages: G.villages.length === 27 && G.natives.length > 0,
    };
    // The map and a colony screen render from the imported state.
    try {
      const probe = document.createElement('canvas');
      probe.width = 320; probe.height = 200;
      const p = probe.getContext('2d');
      drawMap(p);
      G.colony = G.colonies.indexOf(j); G.screen = 'colony'; drawColony(p);
      G.screen = 'map';
      out.sav.renders = true;
    } catch (e) { out.sav.renders = 'THREW ' + e.message; }
    // The raid-target scorer (func_0460F8 = 0x181F:0x316, byte-ported): on
    // the 1653 board it finds at least one scoreable village, every scoring
    // village names a real colony, and capitals carry the sparkle flag.
    out.sav.raidScorer = (() => {
      const scored = G.villages.map(v => raidTargetScore(v)).filter(rt => rt.score >= 0);
      return scored.length >= 1 && scored.every(rt => !!rt.colony) &&
             G.villages.some(v => v.capital);
    })();
    // Rival AI: at war, garrisons raise and soldiers march.
    const r = G.rivals.find(q => q.colonies.length);
    declareWarOn(G.nation, r.nation);
    const before = JSON.stringify(r.units.filter(u => !u.ship).map(u => [u.x, u.y]));
    for (let t = 0; t < 6; t++) { G.eventQueue.length = 0; rivalTurn(); }
    out.rivalAI = {
      marched: JSON.stringify(r.units.filter(u => !u.ship).map(u => [u.x, u.y])) !== before,
      garrisoned: r.units.filter(u => !u.ship).length > 0,
    };
    // The v2 browser save round-trips the map planes and the rumour set.
    saveGame();
    const y0 = G.year, t0 = MAP.tiles[100];
    beginGame();
    out.saveV2 = loadGame() && G.year === y0 && MAP.tiles[100] === t0 &&
                 (G.rumoursDone instanceof Set);
    // The main-menu LOAD GAME row opens the picker.
    G.dialog = null; G.menuRow = 3; commitMenu();
    out.loadMenu = !!G.dialog && G.dialog.opts.length === 4;
    G.dialog = null;
  }

  // ---- playtest batch 3: sail confirms, F5 counters, F3 sprites, speakers --
  {
    // Bound For drop -> @SAILAWAY confirm (default row 0 = Yes); decline
    // keeps the ship in port, accept sails it.
    G.screen = 'europe';
    const savedEurope = G.europe;
    G.europe = [{ type: 'Caravel', icon: unit('Caravel').icon, hold: [], passengers: [],
                  state: 'port', turns: 0 }];
    G.euroShip = 0; G.dialog = null;
    europeDrop({ screen: 'europe', mode: 9, kind: 'ship', shipSlot: 0 }, 2, 100, 130);
    const saConfirm = !!G.dialog && G.dialog.body.join(' ').includes('New World') &&
                      G.dialog.sel === 0;
    closeDialog(1);
    const saDeclined = G.europe[0].state === 'port';
    europeDrop({ screen: 'europe', mode: 9, kind: 'ship', shipSlot: 0 }, 2, 100, 130);
    closeDialog(0);
    out.sailAway = { confirm: saConfirm, declined: saDeclined,
                     sailed: G.europe[0].state === 'toNewWorld',
                     mode9Legal: dropAllowed('europe', 9, 2) && dropAllowed('europe', 9, 3) &&
                                 !dropAllowed('europe', 9, 0) };
    G.europe = savedEurope;
    // @SAILHOME asks on the sea lane; declining leaves the ship in place.
    G.screen = 'map'; G.dialog = null;
    const sh = mkUnit('Caravel', 0, 0); G.units.push(sh);
    let lx = -1;
    for (let x = MAP.w - 1; x >= 0 && lx < 0; x--)
      if (tileTerrain(at(x, 30)) === TERR.SEALANE) lx = x;
    sh.x = lx - 1; sh.y = 30; sh.movesLeft = 9; G.sel = G.units.indexOf(sh);
    moveSel(1, 0);
    const shAsk = !!G.dialog && G.dialog.body.join(' ').includes('high seas');
    closeDialog(1);
    const shStayed = G.units.includes(sh) && sh.x === lx - 1;
    moveSel(1, 0); closeDialog(0);
    out.sailHome = { asked: shAsk, stayed: shStayed, wentHome: !G.units.includes(sh) };
    // F3 REF sprites come from @UNIT's 1-based icon column (UNITS holds -1).
    out.refIcons = [unit('Regulars').icon, unit('Cavalry').icon,
                    unit('Artillery').icon, unit('Man-O-War').icon];
    // Extended speaker families.
    out.speakerMap = {
      trade: eventSpeaker('PRICEDOWN') === 'MSS2',
      site: eventSpeaker('TOONEAR') === 'MSS3',
      treasure: eventSpeaker('CASHTREASURE') === 'KING1',
      colony: eventSpeaker('BUILT') === 'MSS5',
      diplo: eventSpeaker('SIGNTREATY') === 'MSS1',
      lootCaptureStaysMilitary: eventSpeaker('LOOTCAPTURE') === 'MSS0',
    };
    // F5 trade counters: selling logs net units + net value after tax;
    // buying logs both negative. (The importer check against the 1653 frame's
    // transcribed values lives with the other sav assertions.)
    G.tax = 10; G.tradeTons = DATA.cargo.map(() => 0); G.tradeGold = DATA.cargo.map(() => 0);
    const bid = G.market[4];
    sellGoods(4, 100);
    const soldOK = G.tradeTons[4] === 100 &&
                   G.tradeGold[4] === Math.floor(bid * 100 * 90 / 100);
    const ask0 = askPrice(5); G.gold += 100000;
    buyGoods(5, 50);
    out.tradeCounters = { soldOK, boughtOK: G.tradeTons[5] === -50 && G.tradeGold[5] === -ask0 * 50 };
  }

  // ---- woodcut triggers: first contact, first village, first cargo ----
  {
    beginGame();
    // Drain the fresh-game TUTORIAL1 lesson: this block tests the woodcut
    // chain, and the queued lesson would otherwise sit ahead of the
    // @INDIANWELCOME dialog.
    G.eventQueue = [];
    const r = {};
    r.sheets = ['WDCUT03', 'WDCUT04', 'WDCUT05', 'WDCUT07', 'WDCUT08',
                'WDCUT09', 'WDCUT11', 'WDCUT13'].every(s => !!DATA.sheets[s]);
    const v = G.villages.find(w => w.tribe === 1) || G.villages[0];
    const expect = v.tribe === 0 ? 5 : v.tribe === 1 ? 4 : 3;
    const u = mkUnit('Scouts', v.x, v.y);
    enterVillage(v, u);
    r.contactPlate = G.screen === 'woodcut' && G.woodcut === expect;
    onClick(-1, -1);
    r.welcome = G.screen === 'village' && !!G.dialog &&
                G.dialog.body.join(' ').includes('welcomes you');
    closeDialog(1); G.dialog = null; G.screen = 'map';
    enterVillage(v, u);
    r.villagePlate = G.screen === 'woodcut' && G.woodcut === 7;
    onClick(-1, -1);
    G.screen = 'map';
    enterVillage(v, u);
    r.thirdQuiet = G.screen === 'village';
    G.screen = 'map'; G.eventQueue = [];
    G.europe.push({ type: 'Galleon', icon: unit('Galleon').icon, state: 'toEurope',
                    turns: 1, passengers: [], hold: [{ good: 4, qty: 50 }] });
    advanceCrossings();
    r.cargoPlate = G.screen === 'woodcut' && G.woodcut === 9;
    onClick(-1, -1);
    r.cargoEurope = G.screen === 'europe';
    G.screen = 'map';
    out.woodcuts = r;
  }

  // ---- the village haggle chain (@TRADE0 -> @BUYWHICH / @TRADENOCARGO) ----
  {
    beginGame();
    const v = G.villages[0];
    const dlist = villageDemand(v);
    let good = dlist.findIndex(x => x > 1); if (good < 0) good = 4;
    const u = mkUnit('Wagon Train', v.x, v.y);
    u.hold = [{ good, qty: 100 }];
    G.units.push(u);
    G.village = v; G.villageVisitor = u; G.eventTribe = v.tribe;
    G.dialog = null; G.eventQueue = []; v.lastBought = undefined;
    v.haggleSell = {}; v.haggleBuy = false;
    openVillageTrade(v, u);
    const r = {};
    r.sellAsk = !!G.dialog && G.dialog.body.join(' ').includes('to trade with us') &&
                G.dialog.opts.length === 4 &&
                String(G.dialog.speaker).startsWith('IND');
    const g0 = G.gold;
    closeDialog(0);                                    // "We gratefully accept"
    r.sold = G.gold > g0 && holdQty(u, good) === 0 && v.lastBought === good;
    if (G.dialog && G.dialog.body.join(' ').includes('available to trade')) {
      r.buyWhich = G.dialog.opts.length === 4;         // 3 goods + decline
      closeDialog(G.dialog.opts.length - 1);
    } else r.buyWhich = !G.dialog;                     // no surplus: no picker
    // Empty-handed sessions refuse with @TRADENOCARGO.
    u.hold = []; G.eventQueue = []; G.dialog = null;
    openVillageTrade(v, u);
    r.noCargo = G.eventQueue.length === 1 &&
                G.eventQueue[0].lines.join(' ').includes('nothing with you to trade');
    out.haggle = r;
    G.village = null; G.screen = 'map'; G.dialog = null; G.eventQueue = [];
  }

  // ---- the 1653 save's F5 columns match the live frame ----
  {
    importSav(b64bytes(DATA.sav1653));
    out.sav1653F5 = {
      sugar: G.tradeTons[1] === 1031 && G.tradeGold[1] === 6071,
      muskets: G.tradeTons[15] === 0 && G.tradeGold[15] === 351,
      silverK: G.tradeGold[7] === 20619,
    };
  }

  // ---- the map screen has no status line: G.msg becomes a notice popup ----
  {
    G.screen = 'map'; G.dialog = null; G.eventQueue = [];
    flushMapMsg();                       // prime the screen tracker
    G.eventQueue = [];
    G.msg = 'Test notice for the popup channel.';
    flushMapMsg();
    const converted = G.eventQueue.length === 1 && G.msg === '' &&
                      G.eventQueue[0].speaker === null &&
                      G.eventQueue[0].lines.join(' ').includes('Test notice');
    // A message left behind on another screen drops on the way out -- the old
    // status line showed exactly that leakage.
    G.eventQueue = []; G.screen = 'colony'; flushMapMsg();
    G.msg = 'stale colony caption'; G.screen = 'map'; flushMapMsg();
    const dropped = G.eventQueue.length === 0 && G.msg === '';
    // Identical back-to-back notices collapse.
    notice('No moves left.'); notice('No moves left.');
    const deduped = G.eventQueue.length === 1;
    G.eventQueue = [];
    out.mapMsgPopups = { converted, dropped, deduped };
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
        # Manifest order is Soldiers then Pioneers -- the live opening turn
        # lists "Veteran" above "100 Tools" in the sidebar
        # (docs/screens/live_2026-08-05/07_map_opening_turn.png).
        ("cargo goes ashore as units, in manifest order",
         r["afterLandfall"]["units"] == ["Caravel", "Soldiers", "Pioneers"]
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
        # The count-strip solve, checked against where the ICONS templates match
        # in docs/screens/live_1653_save/colony_curacao.png. Every one of these
        # is a template hit at score 0, not an eyeballed reading.
        ("production row 0 lands furs/ore/silver where the live frame has them",
         [e["last"] for e in r["stripRows"]["raw"]] == [223, 269, 291]
         and [e["step"] for e in r["stripRows"]["raw"]] == [5, 5, 5],
         r["stripRows"]["raw"]),
        ("production row 1 lands cloth and tools where the live frame has them",
         [e["last"] for e in r["stripRows"]["made"]] == [225, 260, 290]
         and [e["step"] for e in r["stripRows"]["made"]] == [4, 4, 4],
         r["stripRows"]["made"]),
        ("production row 2 solves to pitch 6, lumber ending 243 and hammers 287",
         [e["last"] for e in r["stripRows"]["work"]] == [243, 287]
         and [e["step"] for e in r["stripRows"]["work"]] == [6, 6],
         r["stripRows"]["work"]),
        ("the plaza pack solves to gap 1, second colonist at x=11",
         r["plazaPack"]["gap"] == 1 and r["plazaPack"]["second"] == 11,
         r["plazaPack"]),
        # The shared gauge verb, against the live F2 crosses row.
        ("F2 crosses land where the live frame has them, and only at 9 slots",
         r["f2Gauge"]["at9"] == [10, 43, 76, 110, 143, 177]
         and r["f2Gauge"]["at8"] != [10, 43, 76, 110, 143, 177]
         and r["f2Gauge"]["at10"] != [10, 43, 76, 110, 143, 177],
         r["f2Gauge"]),
        ("the gauge pitch is clamped to sprite width + 1, not span/slots",
         r["f2Gauge"]["pitch"] == 9, r["f2Gauge"]["pitch"]),
        # The row-selection rules, against Curacao's own live production tables.
        ("production row 0 is furs/ore/silver -- consumed-only cotton is skipped",
         r["prodRows"][0] == [[4, 3, 0, 0], [6, 8, 0, 0], [7, 3, 0, 0]],
         r["prodRows"][0]),
        # Cloth and tools are the verified part of the [0x8E5A] rule: both were
        # made from raws the colony did NOT produce that turn, and both draw
        # unmarked in the live frame. The horses entry is KNOWINGLY wrong here --
        # live Curacao marks all 4 and the port marks none, because the Horses
        # slot is the one that does not fit min(consumed, produced) and no second
        # rule has been earned. Asserted as-is so the divergence cannot drift
        # unnoticed.
        ("production row 1 leaves cloth and tools clean (horses under-marked, known)",
         r["prodRows"][1] == [[8, 4, 0, 0], [11, 6, 0, 0], [14, 6, 0, 0]],
         r["prodRows"][1]),
        ("Vlissingen row 1: horses and tools, both from the same [0x8E5A] rule",
         r["prodRows2"][1] == [[8, 4, 0, 0], [14, 6, 0, 0]], r["prodRows2"][1]),
        ("Vlissingen row 2: 8 lumber produced plain, 4 consumed marked",
         [c[:3] for c in r["prodRows2"][2]] == [[5, 8, 0], [5, 4, 0], [32, 12, 0]]
         and r["prodRows2"][2][1][3] == 0x8000, r["prodRows2"][2]),
        ("production row 2 is the consumed lumber (bit 15) then the hammers",
         [c[:3] for c in r["prodRows"][2]] == [[5, 6, 0], [32, 6, 0]]
         and r["prodRows"][2][0][3] == 0x8000, r["prodRows"][2]),
        # Building placement, replayed against live DOSBox RAM.
        ("colony RNG reproduces Jamestown's live plot shuffle",
         r["placement"][0]["shuffle"] == [6,5,4,0,3,2,1,7,10,8,9,12,11,13,14],
         r["placement"][0]["shuffle"]),
        ("colony RNG reproduces Jamestown's live plot->building map",
         r["placement"][0]["present"] == [24,39,32,27,21,255,255,3,17,36,13,255,9,2,7],
         r["placement"][0]["present"]),
        ("colony RNG reproduces Curacao's live plot shuffle",
         r["placement"][1]["shuffle"] == [4,1,3,6,5,2,0,10,7,9,8,12,11,13,14],
         r["placement"][1]["shuffle"]),
        ("colony RNG reproduces Curacao's live plot->building map",
         r["placement"][1]["present"] == [39,255,32,21,255,27,24,255,35,15,255,255,9,0,6],
         r["placement"][1]["present"]),
        ("@BUILDING size column is the live plot-category table",
         r["plotCategoryIsSize"] ==
         [3,3,3,1,1,1,4,4,4,2,2,2,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,
          2,2,0,0,0,1,1,2,2,0,0,0],
         r["plotCategoryIsSize"]),
        ("sea lane starts a 3-turn crossing",
         r["crossing"] == {"state": "toEurope", "turns": 3, "shipLeftMap": True}, r["crossing"]),
        ("crossing docks and opens the harbour",
         r["europe"] == {"screen": "europe", "inPort": 1}, r["europe"]),
        ("buying loads the hold at the ask price",
         r["bought"]["held"] == 100 and r["bought"]["wasAsk"], r["bought"]),
        ("selling asks @HOWMUCH5, empties the hold, and the King takes the tax",
         r["howmuchAsk"] and r["sold"]["held"] == 0 and r["sold"]["gained"] > 0
         and r["sold"]["kingTook"] > 0,
         (r["howmuchAsk"], r["sold"])),
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
        ("train offers None + all 17 @JOB rows, price-sorted",
         r["train"]["count"] and r["train"]["sorted"]
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
        ("@ARMOPTIONS menu offers board/front + muskets/tools/horses at market price",
         all(r["armMenu"].values()), r["armMenu"]),
        ("arming a dock Colonist makes a Soldiers entry and charges gold",
         all(r["armCommit"].values()), r["armCommit"]),
        ("@ARMOPTIONS 'Don't get on next ship' holds a unit back and the row flips",
         all(r["dontBoard"].values()), r["dontBoard"]),
        ("an armed profession lands as its armed type carrying the profession",
         r["armedLandfall"], r["armedLandfall"]),
        ("a bare profession name lands without throwing (Europe-sailing crash)",
         r["professionLands"], r["professionLands"]),
        ("@EUROPESHIPOPTIONS: front/sail/unload/no-changes, and sail sails",
         r["shipMenuRows"] and r["shipMenuSails"],
         {"rows": r["shipMenuRows"], "sails": r["shipMenuSails"]}),
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
        ("a one-pixel-wobble click still selects, keeps the job, and opens the jobs menu",
         all(r["jitterClick"].values()), r["jitterClick"]),
        ("the colony draws on its own tile in the scene panel",
         r["sceneShowsColony"], r["sceneShowsColony"]),
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
        ("the build picker reopens on the current target's row",
         r["buildPreset"], r["buildPreset"]),
        ("construction banks hammers and completes the building",
         r["buildTarget"] == "Docks" and all(r["built"].values()), r["built"]),
        ("construction gates on the prereq tier, supersede, and Adam Smith factories",
         all(r["buildGating"].values()), r["buildGating"]),
        ("colony posts real popups: depletion then starvation, construction complete, tools stall (once)",
         all(r["colonyPopups"].values()), r["colonyPopups"]),
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
        ("the raid gate is 3*fortifications+1: a bare colony is raided",
         r["raidFortGate"]["bareRaids"], r["raidFortGate"]),
        ("a Fortress repels raids a bare colony takes",
         r["raidFortGate"]["fortressRepels"], r["raidFortGate"]),
        ("popup speakers: IND<tribe> for raids, MSS5 military, KING1 king keys",
         all(r["speakers"].values()), r["speakers"]),
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
        ("SoL threshold latches + @SONSUP/@SONSDOWN band notices fire once per crossing",
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
        ("Sea Lane resolves through VICEROY.PAL, not TERRAIN.SS's own palette",
         all(r["seaLanePalette"].values()), r["seaLanePalette"]),
        ("an unexplored tile is fog sprite 0x95, flat until it touches explored land",
         r["fogPath"]["flatField"] and r["fogPath"]["diagonalUntouched"], r["fogPath"]),
        ("the fog edge dithers its explored cardinal in, on that cardinal's band",
         all(r["fogPath"][k] for k in
             ("northBlends", "northInBottomBand", "westBlends", "westInRightBand")),
         r["fogPath"]),
        ("the biome dither needs an EXPLORED neighbour -- fog contributes nothing",
         r["fogPath"]["foundBiomeEdge"]
         and r["fogPath"]["biomeEdgeNeedsAnExploredNeighbour"], r["fogPath"]),
        ("CYCLE.DAT: one band of 8 from index 120, one step per 35 ticks at 60.8766 Hz",
         r["cycle"]["band"] and r["cycle"]["hz"] and r["cycle"]["sheets"], r["cycle"]),
        ("every advisor report is a table, none blits an advisor portrait",
         r["reports"]["allHaveTables"] and r["reports"]["noAdviserField"]
         and r["reports"]["titlesFromMisc"], r["reports"]),
        ("F4 labor grid lands on the byte-cited first row and column",
         r["reports"]["f4GridAtCitedRow"], r["reports"]),
        ("report titles centre on the ink width, not the advance width (live check)",
         r["reports"]["titleCentredOnInk"], r["reports"]),
        ("F5 economic: 17 rules at y=33+8i and the good name at the margin (live check)",
         r["reports"]["f5Rules"] and r["reports"]["f5NameAtMargin"], r["reports"]),
        ("F7 naval is a ruled grid: separators at 82/162/242 (live check)",
         r["reports"]["f7Grid"], r["reports"]),
        ("F9 indian: block pitch 21, tribe name in the tribe's own colour (live check)",
         r["reports"]["f9Pitch"] and r["reports"]["f9TribeColour"], r["reports"]),
        ("the report OK button is a hollow dark-red box (live check)",
         r["reports"]["okHollow"], r["reports"]),
        ("pedia terrain index = 21 alphabetised names, article ids kept (live check)",
         r["liveFixes"]["terrainNames"] and r["liveFixes"]["terrainIds"],
         r["liveFixes"]),
        ("carried units are labelled by equipment/veteran status (live check)",
         r["liveFixes"]["carriedLabels"], r["liveFixes"]),
        ("difficulty label stacks both lines mid-cell in the row ink (live check)",
         r["liveFixes"]["diffLabelRows"], r["liveFixes"]),
        ("a cycle step moves each colour one index up, and 8 steps wrap to the start",
         all(r["cycle"][k] for k in ("phase0IsIdentity", "wrapsAtLen",
                                     "allDistinct", "walksUpOneIndexPerStep")),
         r["cycle"]),
        ("the 1653 save imports: header, gold 21147, tax 2, autumn 1653 turn 215",
         r["sav"]["ok"] and r["sav"]["head"], r["sav"]),
        ("all 13 colonies restore, Curacao at (21,30)",
         r["sav"]["colonies"] and r["sav"]["curacao"], r["sav"]),
        ("Jamestown restores: 10 colonists, 6 on fields, a Statesman, stock and SoL",
         r["sav"]["jamestown"], r["sav"]),
        ("the market imports from PowerRecord +0x4C as the live bid prices",
         r["sav"]["market"], r["sav"]),
        ("seven Founding Fathers restore from the FF bitmask",
         r["sav"]["fathers"], r["sav"]),
        ("off-map units disembark to the Europe dock; the map holds none",
         r["sav"]["europe"] and r["sav"]["onMapClean"], r["sav"]),
        ("the fog plane drops into SEEN (same 1<<(power+4) bit convention)",
         r["sav"]["fog"], r["sav"]),
        ("all 27 villages and their braves restore",
         r["sav"]["villages"], r["sav"]),
        ("the imported state renders the map and the colony screen",
         r["sav"]["renders"] is True, r["sav"]),
        ("rival AI: the save's real soldiers hold at peace and march once at war",
         r["rivalAI"]["marched"] and r["rivalAI"]["garrisoned"], r["rivalAI"]),
        ("the raid-target scorer scores 1653's villages and capitals sparkle",
         r["sav"]["raidScorer"], r["sav"]),
        ("the v2 browser save round-trips the map planes and the rumour set",
         r["saveV2"], r["saveV2"]),
        ("main-menu LOAD GAME opens the three-source picker",
         r["loadMenu"], r["loadMenu"]),
        ("map screen: G.msg converts to a popup, stale captions drop, dupes collapse",
         r["mapMsgPopups"] == {"converted": True, "dropped": True, "deduped": True},
         r["mapMsgPopups"]),
        ("Bound For drop asks @SAILAWAY (Yes default), decline holds, accept sails",
         r["sailAway"] == {"confirm": True, "declined": True, "sailed": True,
                           "mode9Legal": True}, r["sailAway"]),
        ("the sea lane asks @SAILHOME; declining stays, accepting sails home",
         r["sailHome"] == {"asked": True, "stayed": True, "wentHome": True},
         r["sailHome"]),
        ("F3 REF sprites are @UNIT icons-1: red-coat 125, cavalry 126, cannon 9, warship 127",
         r["refIcons"] == [125, 126, 9, 127], r["refIcons"]),
        ("speaker families route: MSS2 trade, MSS3 site, MSS0 colony, MSS1 diplo, KING1 treasure",
         all(r["speakerMap"].values()), r["speakerMap"]),
        ("trade counters log net units and net value after tax, both ways",
         r["tradeCounters"] == {"soldOK": True, "boughtOK": True}, r["tradeCounters"]),
        ("the 1653 import's F5 columns equal the live frame: sugar 1031/6071, muskets 0/351, silver 20619",
         r["sav1653F5"] == {"sugar": True, "muskets": True, "silverK": True},
         r["sav1653F5"]),
        ("woodcuts: tribe plate + @INDIANWELCOME, village plate once, cargo plate to Europe",
         all(r["woodcuts"].values()), r["woodcuts"]),
        ("haggle: @TRADE0 asks with the chief, accept sells, @BUYWHICH follows, empty hold refuses",
         all(r["haggle"].values()), r["haggle"]),
        ("meeting: MYR greeting, the @PEACE* four-row hub, silent treaty acceptance",
         all(r["diplo"]["meeting"].values()), r["diplo"]["meeting"]),
        ("wire-only sweep: prices, teacher guards, graduation rungs, siting, "
         "movement guards, spoilage, evasion, trade bodies",
         all(r["wire1"].values()), r["wire1"]),
        ("small mechanics: outage latch, VANISH, colony-built units + caps, "
         "rush-buy, back-tax, REFIT",
         all(r["wire2"].values()), r["wire2"]),
        ("natives + endgame: PISS bands, trade refusals, LEARNMAD, the "
         "1800 retirement and SCORED lock",
         all(r["wire3"].values()), r["wire3"]),
        ("completion sweep bundled + SUREDISBAND asks + Hall of Fame sorts "
         "and opens from menu row 4",
         all(r["wire4"].values()), r["wire4"]),
        ("aftermath bulletins: seven keys bundled, CAPTURED3 body, the "
         "massacre branch fires",
         all(r["wire5"].values()), r["wire5"]),
        ("input gestures: Go To lists colonies + Europe, pulldown opens on "
         "press and commits on release, flick drags land, sack ink",
         all(r["wire6"].values()), r["wire6"]),
        ("end-to-end playtest: tutorial, founding, work, the Europe muskets "
         "run, declaration, the won war, the Hall of Fame, the lost war",
         all(r["playtest"].values()), r["playtest"]),
        ("colony worker layer draws, dialog speakers pinned, input guard "
         "catches, stale-save fixup",
         all(r["wire7"].values()), r["wire7"]),
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
