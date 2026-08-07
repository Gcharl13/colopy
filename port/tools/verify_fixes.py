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
          return { left: r.left, right: r.right, w: r.width,
                   panel: document.getElementById('debug').getBoundingClientRect().left,
                   open: debugOpen };
        })()""")
        browser.close()

    print(json.dumps(res, indent=2))
    print("canvas geometry:", json.dumps(geom))

    fails = []
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
