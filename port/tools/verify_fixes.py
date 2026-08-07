#!/usr/bin/env python3
"""Drive the bundle headlessly and assert the four reported defects are fixed.

Each check is a behavioural assertion against the live page, not a code read:
the rumour marker is counted and its pixels sampled off the canvas, the pennant
is read back as colour counts, and the colony assignment is exercised through
the real click entry point.
"""
import json
import sys
from pathlib import Path

from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parents[2]
DIST = ROOT / "port" / "dist" / "colonization.html"

CHECKS = r"""
(() => {
  const out = {};

  // ---- 1. Lost City Rumours: does the hash yield tiles, and do they DRAW? ----
  beginGame(); G.screen = 'map';
  let n = 0, first = null;
  for (let y = 0; y < MAP.h; y++)
    for (let x = 0; x < MAP.w; x++)
      if (rumourAt(x, y)) { n++; if (!first) first = [x, y]; }
  out.rumourTiles = n;
  out.rumourFirst = first;
  out.rumourSeed = G.mapSeed;
  out.rumourSeedNonZero = G.mapSeed >= 1 && G.mapSeed <= 0x7FFF;

  if (first) {
    // Park the viewport on it and read the tile back off the canvas. NOTE
    // revealAll() only lifts fog around units and colonies -- an unexplored
    // tile short-circuits drawTile into the fog sprite -- so reveal this one
    // explicitly, or the check measures the fog and not the marker.
    reveal(first[0], first[1], 1);
    G.view.x = first[0]; G.view.y = first[1]; G.zoom = 0;
    const probe = document.createElement('canvas');
    probe.width = W; probe.height = H;
    const pc = probe.getContext('2d');
    drawMap(pc);
    const d = pc.getImageData(VP.x, VP.y, 16, 16).data;
    // PHYS0 0x67 is the stone ring: brown/tan, #dba675 / #a26928 / #6d3c18.
    const want = new Set(['dba675', 'a26928', '6d3c18', 'cf9634', '86511c', 'e7cb92', 'be8630', '79451c']);
    let hitPx = 0;
    for (let i = 0; i < d.length; i += 4) {
      const hex = [d[i], d[i+1], d[i+2]].map(v => v.toString(16).padStart(2, '0')).join('');
      if (want.has(hex)) hitPx++;
    }
    out.rumourRingPixels = hitPx;
  }

  // ---- 2 & 4. Colony pennant: one flag, in the nation's colour ----
  // Draw a colony marker for each power onto a scratch canvas and count the
  // pennant colours present. Two flags => two colour families survive.
  const NATION_HEX = [
    ['e30000', 'b20000'],   // 0 England  red
    ['4159a6', '34499e'],   // 1 France   blue
    ['e3c328', 'c7a220'],   // 2 Spain    yellow
    ['ff7100', 'aa4900'],   // 3 Netherlands orange
  ];
  out.pennant = [];
  for (let nat = 0; nat < 4; nat++) {
    const probe = document.createElement('canvas');
    probe.width = 64; probe.height = 64;
    const pc = probe.getContext('2d');
    usePalette('WOODTILE');
    drawSettlement(pc, 16, 16, 1, nat, 0);
    const d = pc.getImageData(0, 0, 64, 64).data;
    const counts = {};
    for (let i = 0; i < d.length; i += 4) {
      if (d[i+3] === 0) continue;
      const hex = [d[i], d[i+1], d[i+2]].map(v => v.toString(16).padStart(2, '0')).join('');
      counts[hex] = (counts[hex] || 0) + 1;
    }
    const own = NATION_HEX[nat].reduce((a, h) => a + (counts[h] || 0), 0);
    const foreign = NATION_HEX
      .filter((_, i) => i !== nat)
      .reduce((a, pair) => a + pair.reduce((b, h) => b + (counts[h] || 0), 0), 0);
    out.pennant.push({ nation: nat, ownPixels: own, foreignPixels: foreign });
  }

  // ---- 3. Colony job assignment through the real click path ----
  beginGame(); G.screen = 'map';
  const c = {
    name: 'Testburg', x: G.units[0].x, y: G.units[0].y, nation: G.nation,
    colonists: [
      { type: 'Colonists', job: null, cell: null },
      { type: 'Colonists', job: null, cell: null },
      { type: 'Colonists', job: null, cell: null },
    ],
    stock: DATA.cargo.map(() => 0), buildings: [], hammers: 0,
    building: null, sol: 0,
  };
  // Put it on land so the surrounding cells are workable.
  G.colonies = [c]; G.colony = 0; G.screen = 'colony'; G.colonyView = 0;
  G.colonistSel = 1;                     // pick the MIDDLE colonist deliberately

  // Click the scene-panel cell one to the left of centre: x 224..247 is col 1.
  onClick(224 + 12, 32 + 12 + 24);       // col 1, row 2  => dx=-1, dy=0
  out.assign = {
    selected: G.colonistSel,
    who0: c.colonists[0].cell, who1: c.colonists[1].cell, who2: c.colonists[2].cell,
    job1: c.colonists[1].job,
  };
  // The SELECTED colonist must be the one that moved.
  out.assignCorrectColonist = JSON.stringify(c.colonists[1].cell) === JSON.stringify([-1, 0])
                           && c.colonists[0].cell === null;

  // Now every colonist holds a cell; moving a WORKING one must still work.
  c.colonists[0].cell = [0, -1]; c.colonists[2].cell = [1, 0];
  G.colonistSel = 0;
  onClick(224 + 12 + 24 * 2, 32 + 12);   // col 3, row 1 => dx=1, dy=-1, empty
  out.assignWhenAllBusy = JSON.stringify(c.colonists[0].cell);
  out.assignWhenAllBusyOk = JSON.stringify(c.colonists[0].cell) === JSON.stringify([1, -1]);

  // ---- bestFieldJob must be able to return Lumberjack / Ore Miner ----
  out.fieldJobs = FIELD_JOB_NAMES;
  out.hasLumberjack = FIELD_JOB_NAMES.some(j => /Lumber/i.test(j));
  out.hasOreMiner = FIELD_JOB_NAMES.some(j => /Ore/i.test(j));

  // ---- Europe: ship boxes hit-test where they are drawn ----
  out.euroShipBox = { x: EURO_SHIP.x, y: EURO_SHIP.y, pitch: EURO_SHIP.pitch };

  return out;
})()
"""


# --- drag-and-drop: driven with REAL pointer events, not synthetic calls -----
# Each case sets the game up, drags logical (x0,y0) -> (x1,y1) through
# page.mouse, and reads the resulting state back.

SETUP_COLONY = r"""
(() => {
  beginGame(); G.screen = 'map';
  const u = G.units.find(x => !x.ship) || G.units[0];
  const c = {
    name: 'Dragtown', x: u.x, y: u.y, nation: G.nation,
    colonists: [
      { type: 'Colonists', job: null, cell: null },
      { type: 'Colonists', job: null, cell: null },
    ],
    stock: DATA.cargo.map(() => 50), buildings: ['Carpenter\'s Shop'],
    hammers: 0, building: null, sol: 0,
  };
  G.colonies = [c]; G.colony = 0; G.colonistSel = 0;
  G.screen = 'colony'; G.colonyView = 0;
  return { plaza: plazaRow(c).filter(e => e.colonist >= 0).map(e => ({ x: e.x, w: e.w, i: e.colonist })) };
})()
"""

SETUP_EUROPE = r"""
(() => {
  beginGame(); G.screen = 'map';
  G.gold = 10000; G.boycotts = [];
  G.europe = [{ type: 'Caravel', icon: 5, hold: [{ good: 2, qty: 100 }], state: 'port' }];
  G.euroShip = 0; G.dockUnits = ['Expert Farmer'];
  G.screen = 'europe'; G.euroMsg = '';
  return { hold: G.europe[0].hold.map(h => ({ ...h })), gold: G.gold };
})()
"""


def drag(page, geom, x0, y0, x1, y1, hold_ms=200):
    """Press at logical (x0,y0), hold, move to (x1,y1), release."""
    s, left, top = geom["scale"], geom["left"], geom["top"]
    px = lambda x, y: (left + (x + 0.5) * s, top + (y + 0.5) * s)
    ax, ay = px(x0, y0)
    bx, by = px(x1, y1)
    page.mouse.move(ax, ay)
    page.mouse.down()
    page.wait_for_timeout(hold_ms)
    # Several small steps, the way a hand moves -- one jump can be coalesced.
    for k in range(1, 6):
        page.mouse.move(ax + (bx - ax) * k / 5, ay + (by - ay) * k / 5)
        page.wait_for_timeout(20)
    page.mouse.up()
    page.wait_for_timeout(60)


def main() -> int:
    errors = []
    with sync_playwright() as p:
        browser = p.chromium.launch(executable_path="/opt/pw-browsers/chromium")
        page = browser.new_page(viewport={"width": 1400, "height": 900})
        page.on("pageerror", lambda e: errors.append(f"pageerror: {e}"))
        page.on("console", lambda m: errors.append(f"console.{m.type}: {m.text}")
                if m.type == "error" else None)
        page.goto(DIST.as_uri())
        page.wait_for_function("typeof G !== 'undefined' && typeof beginGame === 'function'",
                               timeout=30000)
        page.wait_for_timeout(400)
        res = page.evaluate(CHECKS)

        # The canvas must not be clipped off the left edge by the debug column.
        geom = page.evaluate("""(() => {
          const r = document.getElementById('screen').getBoundingClientRect();
          return { left: r.left, top: r.top, right: r.right, w: r.width, scale: scale,
                   panel: document.getElementById('debug').getBoundingClientRect().left,
                   open: debugOpen };
        })()""")

        drags = {}

        # 1. Colony: drag the plaza colonist onto the field cell left of centre.
        plaza = page.evaluate(SETUP_COLONY)["plaza"]
        src = plaza[0]
        drag(page, geom, src["x"] + src["w"] // 2, 148, 224 + 12, 32 + 12 + 24)
        drags["plazaToField"] = page.evaluate(
            "({cell: G.colonies[0].colonists[0].cell, job: G.colonies[0].colonists[0].job,"
            " drag: G.drag, msg: G.msg})")

        # 2. Colony: drag that worker back to the plaza.
        drag(page, geom, 224 + 12, 32 + 12 + 24, 40, 150)
        drags["fieldToPlaza"] = page.evaluate(
            "({cell: G.colonies[0].colonists[0].cell, job: G.colonies[0].colonists[0].job})")

        # 3. Colony: drag a colonist onto a building in the building field.
        plot = page.evaluate(r"""(() => {
          const c = G.colonies[0], present = colonyPlacement(c);
          for (let i = PLOTS.length - 1; i >= 0; i--) {
            const id = present[i];
            if (id < 0) continue;
            const nm = DATA.buildings[id] && DATA.buildings[id].name;
            if (!nm || !c.buildings.includes(nm) || !workplaceFor(nm)) continue;
            const [px, py] = PLOTS[i];
            const [fw, fh] = frameSize('BUILDING', buildingFrame(c, id));
            return { x: px + (fw >> 1), y: py + 8 + (fh >> 1), name: nm };
          }
          return null;
        })()""")
        if plot:
            p2 = page.evaluate(
                "plazaRow(G.colonies[0]).filter(e=>e.colonist>=0).map(e=>({x:e.x,w:e.w}))")
            drag(page, geom, p2[0]["x"] + p2[0]["w"] // 2, 148, plot["x"], plot["y"])
            drags["plazaToBuilding"] = page.evaluate(
                "({job: G.colonies[0].colonists[0].job, cell: G.colonies[0].colonists[0].cell})")
            drags["plazaToBuilding"]["want"] = page.evaluate(
                f"jobForBuilding({json.dumps(plot['name'])})")

        # 4. Europe: drag a market good onto the ship = BUY.
        before = page.evaluate(SETUP_EUROPE)
        drag(page, geom, 19 * 4 + 9, 189, 147 + 6, 170, hold_ms=40)
        drags["marketToHold"] = page.evaluate(
            "({hold: G.europe[0].hold.map(h=>({...h})), gold: G.gold, msg: G.euroMsg})")
        drags["marketToHold"]["goldBefore"] = before["gold"]

        # 5. Europe: drag a full hold onto the market strip = SELL.
        page.evaluate(SETUP_EUROPE)
        drag(page, geom, 147 + 6, 170, 19 * 2 + 9, 189, hold_ms=40)
        drags["holdToMarket"] = page.evaluate(
            "({hold: G.europe[0].hold.map(h=>({...h})), gold: G.gold, msg: G.euroMsg})")

        # 6. Europe: drag a dock unit onto the ship = board.
        page.evaluate(SETUP_EUROPE)
        drag(page, geom, 232 + 9, 137 + 9, 145 + 9, 145 + 9, hold_ms=40)
        drags["dockToShip"] = page.evaluate(
            "({dock: G.dockUnits.slice(), pax: G.europe[0].passengers || [], msg: G.euroMsg})")

        # 7. A press-and-release with no motion must stay a CLICK, not a drop.
        page.evaluate(SETUP_COLONY)
        s, left, top = geom["scale"], geom["left"], geom["top"]
        page.mouse.move(left + 40 * s, top + 150 * s)
        page.mouse.down()
        page.wait_for_timeout(260)          # past the hold deadline
        page.mouse.up()
        page.wait_for_timeout(80)
        drags["holdNoMove"] = page.evaluate(
            "({sel: G.colonistSel, cell: G.colonies[0].colonists[0].cell,"
            " job: G.colonies[0].colonists[0].job, drag: G.drag})")

        # 8. The ghost must actually render while a drag is live.
        page.evaluate(SETUP_COLONY)
        p3 = page.evaluate(
            "plazaRow(G.colonies[0]).filter(e=>e.colonist>=0).map(e=>({x:e.x,w:e.w}))")
        page.mouse.move(left + (p3[0]["x"] + p3[0]["w"] // 2) * s, top + 148 * s)
        page.mouse.down()
        page.wait_for_timeout(220)
        page.mouse.move(left + 150 * s, top + 60 * s)
        page.wait_for_timeout(120)
        drags["ghost"] = page.evaluate(r"""(() => {
          if (!G.drag) return { live: false };
          const p = document.createElement('canvas'); p.width = W; p.height = H;
          const pc = p.getContext('2d');
          drawDragGhost(pc);
          const d = pc.getImageData(0, 0, W, H).data;
          let n = 0;
          for (let i = 3; i < d.length; i += 4) if (d[i]) n++;
          return { live: true, frame: G.drag.frame, pixels: n, at: [PTR.x, PTR.y] };
        })()""")
        page.mouse.up()

        # 9. Map pulldowns track the cursor while held and commit on release.
        page.evaluate("beginGame(); G.screen='map'; openMenu(0); G.menuSel=0;")
        rowbox = page.evaluate(
            "(() => { const b = pulldownBox(0); return { x: b.x + 4, y0: b.y + 2 }; })()")
        page.mouse.move(left + rowbox["x"] * s, top + (rowbox["y0"] + 4) * s)
        page.mouse.down()
        page.mouse.move(left + rowbox["x"] * s, top + (rowbox["y0"] + 8 * 2 + 4) * s)
        page.wait_for_timeout(60)
        drags["menuHover"] = page.evaluate("G.menuSel")
        page.mouse.up()
        page.wait_for_timeout(60)

        # 10. The nation picker is drag-live.
        page.evaluate("G.screen='nation'; G.nation=0;")
        cell = page.evaluate("(() => { const r = NAT_CELL(3); return { x: r.x + 20, y: r.y + 20 }; })()")
        page.mouse.move(left + 10 * s, top + 10 * s)
        page.mouse.down()
        page.mouse.move(left + cell["x"] * s, top + cell["y"] * s)
        page.wait_for_timeout(60)
        drags["nationDrag"] = page.evaluate("G.nation")
        page.mouse.up()

        browser.close()

    print(json.dumps(res, indent=2))
    print("canvas geometry:", json.dumps(geom))
    print("drag results:", json.dumps(drags, indent=2))

    fails = []
    d = drags
    if d["plazaToField"]["cell"] != [-1, 0]:
        fails.append(f"drag plaza->field did not place the colonist: {d['plazaToField']}")
    if not d["plazaToField"]["job"]:
        fails.append("drag plaza->field left the colonist jobless")
    if d["plazaToField"]["drag"] is not None:
        fails.append("the drag payload was not cleared on drop")
    if d["fieldToPlaza"]["cell"] is not None:
        fails.append(f"drag field->plaza did not free the cell: {d['fieldToPlaza']}")
    if "plazaToBuilding" in d:
        b = d["plazaToBuilding"]
        if b["job"] != b["want"]:
            fails.append(f"drag plaza->building gave job {b['job']!r}, want {b['want']!r}")
        if b["cell"] is not None:
            fails.append("a building job must clear the field cell")
    mh = d["marketToHold"]
    if not any(h["good"] == 4 and h["qty"] >= 100 for h in mh["hold"]):
        fails.append(f"drag market->hold did not buy: {mh}")
    if mh["gold"] >= mh["goldBefore"]:
        fails.append(f"drag market->hold cost nothing: {mh['gold']} vs {mh['goldBefore']}")
    hm = d["holdToMarket"]
    if any(h["good"] == 2 and h["qty"] for h in hm["hold"]):
        fails.append(f"drag hold->market did not sell: {hm}")
    ds = d["dockToShip"]
    if ds["dock"] or "Expert Farmer" not in ds["pax"]:
        fails.append(f"drag dock->ship did not board the unit: {ds}")
    hn = d["holdNoMove"]
    if hn["cell"] is not None or hn["job"] is not None:
        fails.append(f"a press-and-release with no motion acted as a drop: {hn}")
    if hn["drag"] is not None:
        fails.append("a stationary press left a drag payload behind")
    gh = d["ghost"]
    if not gh.get("live"):
        fails.append("no drag payload while the button was held over a colonist")
    elif gh.get("pixels", 0) <= 0:
        fails.append(f"the drag ghost drew nothing: {gh}")
    if d["menuHover"] != 2:
        fails.append(f"pulldown did not track the cursor while held: menuSel={d['menuHover']}")
    if d["nationDrag"] != 3:
        fails.append(f"nation picker not drag-live: nation={d['nationDrag']}")
    if res["rumourTiles"] <= 0:
        fails.append(f"no rumour tiles on the map ({res['rumourTiles']})")
    if not res["rumourSeedNonZero"]:
        fails.append(f"map seed out of range: {res['rumourSeed']}")
    if res.get("rumourRingPixels", 0) <= 0:
        fails.append("rumour marker drew no stone-ring pixels")
    for e in res["pennant"]:
        if e["ownPixels"] <= 0:
            fails.append(f"nation {e['nation']}: own pennant not drawn")
        if e["foreignPixels"] > 0:
            fails.append(
                f"nation {e['nation']}: {e['foreignPixels']} foreign flag pixels "
                "survive -- two flags are showing")
    if not res["assignCorrectColonist"]:
        fails.append(f"field click moved the wrong colonist: {res['assign']}")
    if not res["assignWhenAllBusyOk"]:
        fails.append(f"could not move a working colonist: {res['assignWhenAllBusy']}")
    if not res["hasLumberjack"]:
        fails.append("bestFieldJob can never return Lumberjack")
    if not res["hasOreMiner"]:
        fails.append("bestFieldJob can never return Ore Miner")
    if geom["left"] < 0:
        fails.append(f"canvas clipped off the left edge at {geom['left']}px")
    if geom["right"] > geom["panel"] + 1:
        fails.append(f"canvas runs under the debug panel ({geom['right']} > {geom['panel']})")
    if errors:
        fails.extend(errors)

    for f in fails:
        print("FAIL:", f)
    if not fails:
        print("\nAll checks passed.")
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
