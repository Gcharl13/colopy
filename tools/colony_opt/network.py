#!/usr/bin/env python3
"""
Northern-cluster road network on the AMER2 grid (rev 4).

Logistics rules (player-confirmed; NOT yet byte-traced — flagged (R)):
  - wagon cap: at most (number of colonies - 1) wagon trains
  - wagon: 2 holds x 100 units, one good per hold
  - wagon 2 MP; road tile costs 1/3 MP  =>  6 road tiles / turn
  - round-trip throughput per wagon = 200 / (2 * one-way turns)
  - ships are OUTSIDE the wagon cap (galleon 6 holds)

Design consequences encoded here:
  - hub placed COASTAL (exports leave by sea, spending no wagons)
  - spokes ship the factory need (48/turn), not the harvest (66) — surplus
    banks locally until a new colony founding adds a wagon
  - an all-indoor importer hub works zero land tiles, so it may legally sit
    adjacent to a spoke's ring (colony min-distance permitting)

Nodes: hub H=(7,10) coastal grassland (cigar/cloth/coat factories + armory +
3 statesmen); F=(7,2) furs, T=(7,8) tobacco, R=(12,10) horse ranch,
C=(10,14) cotton, O=(14,21) ore.  6 colonies -> 5 wagons = one per edge,
exactly at cap.  Paths are 8-directional BFS over land (roads equalize tile
cost). Emits the grid SVG body used by the report.
"""
import json, math, os, sys
from collections import deque
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from optimize import terr_raw, fold, WATER, W, H, river, neighbors8, TNAME

HUB = (7, 10)
NODES = {'H': HUB, 'F': (7, 2), 'T': (7, 8), 'R': (12, 10),
         'C': (10, 14), 'O': (14, 21)}
EDGES = ['F', 'T', 'R', 'C', 'O']

def land(x, y):
    t = fold(terr_raw(x, y)); return t not in WATER and t != 24

def bfs_path(src, dst):
    dist = {src: 0}; q = deque([src])
    while q:
        x, y = q.popleft()
        for dx in (-1, 0, 1):
            for dy in (-1, 0, 1):
                if dx == dy == 0: continue
                n = (x+dx, y+dy)
                if 0 <= n[0] < W and 0 <= n[1] < H and n not in dist and land(*n):
                    dist[n] = dist[(x, y)] + 1; q.append(n)
    p = [dst]; cur = dst
    while cur != src:
        x, y = cur
        cur = min(((x+dx, y+dy) for dx in (-1, 0, 1) for dy in (-1, 0, 1)
                   if not dx == dy == 0 and (x+dx, y+dy) in dist),
                  key=lambda n: dist[n])
        p.append(cur)
    return list(reversed(p))

def main():
    here = os.path.dirname(os.path.abspath(__file__))
    paths = {k: bfs_path(HUB, NODES[k]) for k in EDGES}
    summary = {}
    for k in EDGES:
        tiles = len(paths[k]) - 1
        turns = math.ceil(tiles / 6)
        summary[k] = {"site": list(NODES[k]), "road_tiles": tiles,
                      "one_way_turns": turns,
                      "wagon_capacity_per_turn": 200 // (2 * turns)}
        print(k, NODES[k], f"{tiles} road tiles, {turns} turn(s) one-way,"
              f" {summary[k]['wagon_capacity_per_turn']}/turn per wagon")
    json.dump({"hub": list(HUB), "colonies": len(NODES),
               "wagon_cap": len(NODES) - 1, "edges": summary},
              open(os.path.join(here, 'network_paths.json'), 'w'), indent=1)

if __name__ == '__main__':
    main()
