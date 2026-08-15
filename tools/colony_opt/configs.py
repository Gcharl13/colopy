#!/usr/bin/env python3
"""
Configuration placement scorer (rev 3, resource-flow framing — no prices).

For every land site on AMER2, computes the best achievable 6-tile export ring
per raw good (the "planter outpost" shape: 6 producers + 2 farmers + 1
statesman, pop 9) and the granary net-food figure (8 farmers + 1 statesman),
using the byte-decoded tile rates from optimize.tile_options (expert, 100% SoL,
improvements complete). Writes site_profiles.json and prints the top 3
non-overlapping sites per configuration.

Configuration catalog itself (flows/turn, derived from the decoded rates —
see MODEL.md):
  Planter outpost  pop 9   -> 66 raw (54 ore) + 7 food
  Granary          pop 9   -> +76 food
  Factory capital  pop 14  <- 192 raw + 28 food -> 72 each of rum/cigars/cloth/coats
  Armory town      pop 8   <- 48 ore + 16 food  -> 72 muskets + 24 tools
  Horse ranch      pop 9   -> +24 horses + 52 food (herd held ~299, Stable+Warehouse)
  Hammer phase     pop 10  -> 48 hammers (LOCAL — hammers never travel)
  Statehouse       pop 4   -> 62 bells to the national Congress pool
  Mission          pop 5   -> 48 crosses (72 with the +50% FF)
Bells and hammers are per-colony (EMA inflow 2*pop @0x2DA64; build bank
@0x2E50F): neither can be imported, so every configuration carries its own
statesman and passes through its own hammer phase.
"""
import json, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from optimize import tile_options, center_yield, neighbors8, terr_raw, fold, WATER, W, H

GOODS = {1:'Sugar',2:'Tobacco',3:'Cotton',4:'Furs',5:'Lumber',6:'Ore',0:'Food'}

def site_profile(x, y):
    if fold(terr_raw(x, y)) in WATER or terr_raw(x, y) == 24: return None
    ring = list(neighbors8(x, y))
    if len(ring) < 8: return None
    per_good = {g: [] for g in GOODS}
    for nx, ny in ring:
        best = {g: 0 for g in GOODS}
        for _, out in tile_options(nx, ny):
            for g, q in out.items():
                if g in best: best[g] = max(best[g], q)
        for g in GOODS: per_good[g].append(best[g])
    ctr = center_yield(x, y)
    prof = {}
    for g in GOODS:
        ys = sorted(per_good[g], reverse=True)
        if g == 0:
            prof['Food'] = sum(ys[:8]) + ctr.get(0, 0) - 18       # granary net
        else:
            top6 = [v for v in ys[:6] if v > 0]
            foods = sorted(per_good[0], reverse=True)[:2]
            ok = sum(foods) + ctr.get(0, 0) >= 18 and len(top6) == 6
            prof[GOODS[g]] = sum(top6) if ok else 0
    return prof

def main():
    here = os.path.dirname(os.path.abspath(__file__))
    profiles = {}
    for y in range(H):
        for x in range(W):
            p = site_profile(x, y)
            if p: profiles[(x, y)] = p
    json.dump({f"{x},{y}": p for (x, y), p in profiles.items()},
              open(os.path.join(here, 'site_profiles.json'), 'w'))
    for cat in ['Sugar', 'Tobacco', 'Cotton', 'Furs', 'Ore', 'Food']:
        ranked = sorted(profiles.items(), key=lambda kv: -kv[1].get(cat, 0))
        picked = []
        for (x, y), p in ranked:
            if p.get(cat, 0) <= 0: break
            if all(max(abs(x-a), abs(y-b)) >= 3 for a, b in picked):
                picked.append((x, y))
            if len(picked) == 3: break
        print(cat, [(xy, profiles[xy][cat]) for xy in picked])

if __name__ == '__main__':
    main()
