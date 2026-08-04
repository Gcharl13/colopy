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

  // A unit ashore walks on land and is refused by the sea.
  const pio = G.units[1];
  G.sel = 1;
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
  const pax0 = boat.passengers.length, g2 = G.gold;
  euroMenuCommit();
  out.recruited = { paid: g2 - G.gold > 0, boarded: boat.passengers.length === pax0 + 1,
                    menuClosed: G.euroMenu === null };

  // Train: 17 trainable jobs, priced from @JOB europe_value.
  openEuroMenu(2);
  out.trainRows = euroMenuRows().length === 17;
  G.euroMenu = null;

  // Sail home: three turns back to the lane, then the ship is on the map again.
  const units0 = G.units.length;
  sailForNewWorld(boat);
  out.outbound = G.europe[0].state === 'toNewWorld';
  for (let t = 0; t < 3; t++) endTurn();
  out.returned = { onMap: G.units.length === units0 + 1, inPort: shipsInPort().length === 0 };

  G.screen = 'europe';
  onClick(310, 190);
  out.europeExit = G.screen;
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
        ("recruiting charges and boards the ship",
         all(r["recruited"].values()), r["recruited"]),
        ("train offers the 17 @JOB rows", r["trainRows"], r["trainRows"]),
        ("sailing west starts an outbound crossing", r["outbound"], r["outbound"]),
        ("the ship returns to the map", all(r["returned"].values()), r["returned"]),
        ("Europe Exit returns to the map", r["europeExit"] == "map", r["europeExit"]),
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
