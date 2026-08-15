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


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "produce"
    if mode not in ("produce", "market"):
        raise SystemExit("unknown mode: " + mode)
    with sync_playwright() as pw:
        browser = pw.chromium.launch(executable_path="/opt/pw-browsers/chromium")
        page = browser.new_page()
        page.goto(DIST.as_uri())
        page.wait_for_function("typeof importSav === 'function'")
        # let the boot settle (assets decode on load)
        page.wait_for_timeout(500)
        data = page.evaluate(PRODUCE if mode == "produce" else MARKET)
        browser.close()
    json.dump(data, sys.stdout, indent=1, sort_keys=True)
    print()


if __name__ == "__main__":
    main()
