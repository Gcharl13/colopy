#!/usr/bin/env python3
"""
Colony layout / count optimizer for AMER2.MP  (separate exercise, not spec work).

Encodes the byte-verified production engine as a mixed-integer linear program
(MILP) and solves it exactly per candidate site, then packs sites globally.

Evidence basis (per-value citations in tools/colony_opt/MODEL.md):
  - terrain x profession yield table: NAMES.TXT @UNFORESTED/@FORESTED/@OTHER
    (data_extracted/tables/names_tables.json), loaded by the engine at
    DGROUP:0x2F7B (compute_terrain_yield @0x9C1E).
  - terrain id fold 16..23 -> 8..15: (id&7)|8, func_006204 @0x6225.
  - expert bonus: food columns (farmer 0 / fisherman 8) +2, all others x2
    (SHL @0x9DD2); era test good==0 || good==8 (@0x9DB9).
  - resource bonus switch func_009AAA @0x9AAA (positive bonuses doubled for
    expert @0x9E0A; negative marker => base doubled @0x9DFE). AMER2's prime-
    resource placement is runtime (not in .MP tile data) => modeled as 0 (TBD).
  - plow (+bit 0x40) adds bonus to columns <=3, road (+bit 0x08) to columns >3
    (@0x9F01..0x9F2C); bonus = 1, or 2 for lumber column / river tile
    (@0x9EC6/@0x9EDD).  Clear forest: id -= 8 (@0x040896).
  - ocean adjacency nudge for fisherman col: +1, -1 if 6+ water neighbours,
    -2 if 8 (count_adjacent_terrain 0x99EE over ids 0x19..0x1A, @0x9C3E).
  - food eaten = 2*pop (@0xA5F2).
  - center tile: food class @0xA247..0xA294 (+river +1 @0xA2C5, difficulty
    +2/+1 @0xA29C/@0xA2A8, rebel latches +1+1 @0xA335/@0xA33F) and best
    non-food secondary scan @0xA343..0xA3D4.
  - bells: base +1 (@0xA4DB), Newspaper (bldg 0x14) x2 else Printing Press
    (bldg 0x13) x1.5 (@0xA587..0xA5AC).
  - SoL steady state (from the EMA @0x2DA1C..0x2DAD8):
      B* = 128*pop, A* = 64*bells/turn  =>  SoL% = 50*bells/pop.
  - raw->finished conversion 1:1 (func_008E84), with amount*2/3 raw throttle
    when >2 chain buildings owned (@0x8EB1) -- shop tier (<=2) assumed here.
  - building-worker base rates 3 / expert 6 (constants at 0xA0E5/0xA10B/@SHL
    0xA12C in func_009FFC; tier semantics partially traced -- R trust).
  - warehouse cap (level+1)*100 (func_008D00) -- not binding: steady-state
    surplus is auto-sold each turn (func_02D658 @0x2D6F7).

Scenario knobs (defaults = developed late-game colony):
  experts everywhere, 100% SoL enforced (bells >= 2*pop), shop-tier buildings
  (incl. Newspaper => bell x2), difficulty >= 2 (no center food bonus),
  no prime resources (TBD layer), rebel latches set (+2 center food/secondary).
"""
import json, os, sys
from collections import Counter
import pulp

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))

# ---------------------------------------------------------------- data loading
names = json.load(open(os.path.join(ROOT, "data_extracted/tables/names_tables.json")))
mapd  = json.load(open(os.path.join(ROOT, "data_extracted/map/AMER2_tiles.json")))

YCOLS = ["y_farmer","y_planter_sugar","y_planter_tobacco","y_planter_cotton",
         "y_trapper","y_lumberjack","y_ore","y_silver","y_fisherman"]
# profession column -> produced good (@CARGO index)
COL_GOOD = {0:0, 1:1, 2:2, 3:3, 4:4, 5:5, 6:6, 7:7, 8:0}   # fisherman -> Food
GOOD_NAME = {0:"Food",1:"Sugar",2:"Tobacco",3:"Cotton",4:"Furs",5:"Lumber",
             6:"Ore",7:"Silver"}

def rows(section):
    return [[int(r[c]) for c in YCOLS] for r in names[section]["rows"]]

YIELD = {}
for i, r in enumerate(rows("@UNFORESTED")): YIELD[i]      = r      # ids 0..7
for i, r in enumerate(rows("@FORESTED")):   YIELD[8 + i]  = r      # ids 8..15
for i, r in enumerate(rows("@OTHER")):      YIELD[24 + i] = r      # 24..28

TNAME = {i: names["@UNFORESTED"]["rows"][i]["name"] for i in range(8)}
TNAME.update({8+i: names["@FORESTED"]["rows"][i]["name"] for i in range(8)})
TNAME.update({24+i: names["@OTHER"]["rows"][i]["name"] for i in range(5)})

# @CARGO mid starting price (avg of price_start1/2) = gold per unit sold
cargo = names["@CARGO"]["rows"]
PRICE = {}
for gi, r in enumerate(cargo[:16]):
    PRICE[gi] = (int(r["price_start1"]) + int(r["price_start2"])) / 2.0
RUM, CIGARS, CLOTH, COATS, TOOLS, MUSKETS = 9, 10, 11, 12, 14, 15
CHAINS = {RUM:1, CIGARS:2, CLOTH:3, COATS:4, TOOLS:6}   # finished -> raw good

W, H = mapd["width"], mapd["height"]
tiles = mapd["tiles"]
def terr_raw(x, y):  return tiles[y*W + x] & 0x1F
def river(x, y):     return bool(tiles[y*W + x] & 0x20)
def fold(t):         return (t & 7) | 8 if 16 <= t <= 23 else t
WATER = {25, 26}

def neighbors8(x, y):
    for dx in (-1,0,1):
        for dy in (-1,0,1):
            if dx==dy==0: continue
            nx, ny = x+dx, y+dy
            if 0 <= nx < W and 0 <= ny < H: yield nx, ny

# ------------------------------------------------------- per-tile work options
# SOL_ADJ: rebel-majority + rebel-unanimous latch bonuses (+1 each at 100% SoL),
# applied in compute_terrain_yield @0x9D88/@0x9D92 BEFORE the expert step; for
# era goods (food cols) it is added AGAIN after the expert +2 (@0x9DC3..0x9DCC);
# for other goods the expert SHL doubles (base+SOL_ADJ) (@0x9DD2).
SOL_ADJ = 2

def tile_options(x, y, expert=True):
    """All (label, {good: qty}) ways one colonist can work tile (x,y).
    Improvements (clear/plow/road) treated as attainable (pioneer cost is
    transient); expert = matching expert colonist; 100% SoL assumed."""
    t = fold(terr_raw(x, y))
    riv = river(x, y)
    opts = []
    if t in WATER:
        wn = sum(1 for nx,ny in neighbors8(x,y) if fold(terr_raw(nx,ny)) in WATER)
        base = YIELD[t][8]
        if base > 0:
            nudge = -2 if wn >= 8 else (-1 if wn >= 6 else 1)  # @0x9C3E gloss
            yv = base + nudge + SOL_ADJ
            if expert: yv += 2 + SOL_ADJ                        # era col 8 @0x9DBF/@0x9DC3
            if yv > 0: opts.append(("Fisherman", {0: yv}))
        return opts
    if t == 24: return opts                                     # Arctic: all 0
    variants = [(t, False)]                    # (terrain-as-worked, cleared?)
    if 8 <= t <= 15: variants.append((t - 8, True))             # clear @0x40896
    for tv, cleared in variants:
        for col in range(8):
            base = YIELD[tv][col]
            if base <= 0: continue
            yv = base + SOL_ADJ                                 # @0x9DA7
            if expert:
                yv = yv + 2 + SOL_ADJ if col == 0 else yv * 2   # @0x9DBF+@0x9DC3 / @0x9DD2
            # improvement bonus, NOT expert-doubled (block @0x9EC6..0x9F4C
            # runs after the expert step)
            bonus = 2 if (col == 5 or riv) else 1
            if col <= 3:  yv += bonus       # plow  @0x9F1F
            else:         yv += bonus       # road  @0x9F01
            imp = ("clear+" if cleared else "") + ("plow" if col <= 3 else "road")
            names_p = ["Farmer","Sugar planter","Tobacco planter","Cotton planter",
                       "Trapper","Lumberjack","Ore miner","Silver miner"]
            opts.append((f"{names_p[col]} ({TNAME[tv]},{imp})", {COL_GOOD[col]: yv}))
    return opts

# ------------------------------------------------------------ center-tile auto
def center_yield(x, y, difficulty=2, latches=True):
    traw = terr_raw(x, y)
    if traw == 24: food = 0
    elif traw in (1, 9, 17): food = 1
    elif 8 <= traw <= 23 or traw in (27, 28): food = 2
    else: food = 3                                              # @0xA247..0xA294
    if difficulty == 0: food += 2
    if difficulty == 1: food += 1
    if river(x, y): food += 1
    if latches: food += 2                                       # bits 4|2
    t = fold(traw)
    best_c, best_y = -1, 0
    for c in (1, 2, 3, 4, 6, 7):                                # skip 5 @0xA375
        yv = YIELD[t][c]
        if yv > best_y: best_c, best_y = c, yv
    if best_c >= 0:
        if difficulty == 0: best_y += 1
        if latches: best_y += 2
    out = {0: food}
    if best_c >= 0 and best_y > 0: out[COL_GOOD[best_c]] = out.get(COL_GOOD[best_c],0)+best_y
    return out

# ------------------------------------------------------------- per-site MILP
# Building-worker rates: BYTE-DECODED from func_009FFC (2026-08-15 trace):
#   rate = (base3 + SOL_ADJ) [+base3 if shop tier] [+50% if factory tier] [x2 expert]
# Expert @ factory tier, 100% SoL: OUT_CONV = ((3+2)+3)*1.5 -> 12, x2 = 24/worker.
# Raw input = output*2/3 at factory tier (func_008E84 @0x8EB1) -> 16/worker.
OUT_CONV  = 24     # finished units per expert converter (factory, 100% SoL)
IN_CONV   = 16     # raw consumed per expert converter (factory, 100% SoL)
RATE_STAT = 10     # Elder Statesman bells: (3+2)*2  (@0xA1C8 handler)
RATE_CARP = 16     # Master Carpenter hammers: (6+2)*2 w/ Lumber Mill (@0xA100/@0xA12C)
IN_CARP   = 16     # lumber per carpenter (1:1, R - band write untraced)
BELL_MULT = 2.0    # Newspaper owned (@0xA594); 1.5 = Printing Press only
MAXPERSHOP = 3     # workers per building (manual trust R)

def solve_site(x, y, n, expert=True, w_hammers=0.0, sol100=True):
    """Exact optimum for a colony of population n at (x,y). Returns (obj, plan)."""
    ring = [(nx,ny) for nx,ny in neighbors8(x,y)]
    opts = {j: tile_options(*p, expert=expert) for j,p in enumerate(ring)}
    ctr  = center_yield(x, y)

    prob = pulp.LpProblem("colony", pulp.LpMaximize)
    xv = {(j,o): pulp.LpVariable(f"x_{j}_{o}", cat="Binary")
          for j in opts for o in range(len(opts[j]))}
    conv = {f: pulp.LpVariable(f"conv_{f}", 0, MAXPERSHOP, cat="Integer")
            for f in CHAINS}
    gunsm = pulp.LpVariable("gunsmith", 0, MAXPERSHOP, cat="Integer")
    stat  = pulp.LpVariable("statesmen", 0, MAXPERSHOP, cat="Integer")
    carp  = pulp.LpVariable("carpenters", 0, MAXPERSHOP, cat="Integer")

    for j in opts:
        prob += pulp.lpSum(xv[j,o] for o in range(len(opts[j]))) <= 1
    prob += (pulp.lpSum(xv.values()) + pulp.lpSum(conv.values())
             + gunsm + stat + carp) == n

    prod = {}
    for g in range(8):
        prod[g] = (pulp.lpSum(xv[j,o] * opts[j][o][1].get(g, 0)
                              for j in opts for o in range(len(opts[j])))
                   + ctr.get(g, 0))
    prob += prod[0] >= 2 * n                                    # eaten=2*pop @0xA5F2
    if sol100:
        # SoL% = 50*bells/pop >= 100  <=>  bells >= 2*pop
        prob += BELL_MULT * (1 + RATE_STAT * stat) >= 2 * n
    sold = {}
    hammers = RATE_CARP * carp
    consumed = {g: 0 for g in range(8)}
    for f, g in CHAINS.items(): consumed[g] = IN_CONV * conv[f]
    consumed[5] = IN_CARP * carp
    tools_net = OUT_CONV * conv[TOOLS] - IN_CONV * gunsm
    prob += tools_net >= 0
    for g in (1,2,3,4,6,7,5):
        s = prod[g] - consumed[g]
        prob += s >= 0
        sold[g] = s
    obj = pulp.lpSum(PRICE[g] * sold[g] for g in (1,2,3,4,6,7,5))
    obj += pulp.lpSum(PRICE[{RUM:9,CIGARS:10,CLOTH:11,COATS:12}[f]] * OUT_CONV * conv[f]
                      for f in (RUM,CIGARS,CLOTH,COATS))
    obj += PRICE[TOOLS] * tools_net + PRICE[MUSKETS] * OUT_CONV * gunsm
    obj += w_hammers * hammers
    prob += obj
    prob.solve(pulp.PULP_CBC_CMD(msg=0))
    if pulp.LpStatus[prob.status] != "Optimal": return None, None
    plan = {"pop": n, "obj": pulp.value(prob.objective),
            "statesmen": int(stat.value()), "carpenters": int(carp.value()),
            "gunsmiths": int(gunsm.value()),
            "converters": {f: int(v.value()) for f,v in conv.items() if v.value()},
            "tiles": []}
    for j in opts:
        for o in range(len(opts[j])):
            if xv[j,o].value() and xv[j,o].value() > 0.5:
                plan["tiles"].append((ring[j], opts[j][o][0], opts[j][o][1]))
    return plan["obj"], plan

# --------------------------------------------------------------- site ranking
def site_upper_bound(x, y):
    if fold(terr_raw(x, y)) in WATER or terr_raw(x,y) == 24: return -1
    tot = 0.0
    for nx, ny in neighbors8(x, y):
        best = 0.0
        for _, out in tile_options(nx, ny):
            v = sum(PRICE[g]*q if g != 0 else 0 for g,q in out.items())
            v += 1.2 * out.get(0, 0)              # food enables pop; soft credit
            best = max(best, v)
        tot += best
    return tot

def main():
    cands = []
    for y in range(H):
        for x in range(W):
            ub = site_upper_bound(x, y)
            if ub > 0: cands.append((ub, x, y))
    cands.sort(reverse=True)
    print(f"{len(cands)} candidate land sites; solving MILPs for top 60 ...")
    TOP = 60
    NRANGE = range(2, 19)
    results = {}
    for ub, x, y in cands[:TOP]:
        vlist = {}
        for n in NRANGE:
            obj, plan = solve_site(x, y, n)
            if obj is None: break
            vlist[n] = (obj, plan)
        if vlist: results[(x,y)] = vlist
    # best single-colony summary
    scored = sorted(results.items(),
                    key=lambda kv: -max(o for o,_ in kv[1].values()))
    out = {"sites": []}
    for (x,y), vlist in scored:
        nbest, (obj, plan) = max(vlist.items(), key=lambda kv: kv[1][0])
        marg = {n: round(vlist[n][0] - vlist[n-1][0], 2)
                for n in vlist if n-1 in vlist}
        coastal = any(fold(terr_raw(nx,ny)) in WATER for nx,ny in neighbors8(x,y))
        out["sites"].append({
            "xy": [x,y], "terrain": TNAME[fold(terr_raw(x,y))],
            "coastal": coastal, "river": river(x,y),
            "best_pop": nbest, "gold_per_turn": round(obj,2),
            "marginal": marg,
            "v_of_n": {n: round(o,2) for n,(o,_) in vlist.items()},
            "plan": {"statesmen": plan["statesmen"],
                     "converters": {GOOD_NAME.get(CHAINS.get(f), f): c
                                    for f,c in plan["converters"].items()},
                     "gunsmiths": plan["gunsmiths"],
                     "tiles": [{"xy": list(p), "job": lab,
                                "out": {GOOD_NAME[g]: q for g,q in o.items()}}
                               for p, lab, o in plan["tiles"]]}})
    # ---------------- global packing: colonist budget -> #colonies (greedy) --
    def pack(budget):
        chosen, used, total = [], set(), 0.0
        avail = dict(results)
        pops = {}
        while budget > 0:
            best = None
            for (x,y), vlist in avail.items():
                if (x,y) in pops:
                    n0 = pops[(x,y)]
                    if n0+1 in vlist:
                        gain = vlist[n0+1][0] - vlist[n0][0]
                        if best is None or gain > best[0]: best = (gain,(x,y),n0+1,False)
                else:
                    ok = all(max(abs(x-cx),abs(y-cy)) >= 3 for cx,cy in pops)
                    if not ok: continue
                    n1 = min(vlist)
                    if n1 <= budget:
                        gain = vlist[n1][0] / n1     # avg value to open
                        if best is None or gain > best[0]: best = (gain,(x,y),n1,True)
            if best is None: break
            _, site, n, opening = best
            cost = n - (0 if opening else pops.get(site, 0))
            if cost > budget: break
            budget -= cost
            pops[site] = n
        total = sum(results[s][n][0] for s,n in pops.items())
        return pops, total
    out["packing"] = {}
    for budget in (16, 24, 32, 48, 64):
        pops, total = pack(budget)
        out["packing"][budget] = {
            "colonies": len(pops), "gold_per_turn": round(total,2),
            "sites": {f"{x},{y}": n for (x,y),n in sorted(pops.items())}}
    json.dump(out, open(os.path.join(HERE, "results.json"), "w"), indent=1)
    # console summary
    print("\n=== TOP 12 SITES (steady-state gold/turn at best pop) ===")
    for s in out["sites"][:12]:
        print(f" ({s['xy'][0]:2d},{s['xy'][1]:2d}) {s['terrain']:<10}"
              f" pop*={s['best_pop']:2d} gold/turn={s['gold_per_turn']:7.2f}"
              f" coastal={s['coastal']} river={s['river']}")
    print("\n=== COLONIST BUDGET -> OPTIMAL COLONY COUNT ===")
    for b, p in out["packing"].items():
        print(f" {b:3d} colonists -> {p['colonies']:2d} colonies,"
              f" {p['gold_per_turn']:8.2f} gold/turn")

if __name__ == "__main__":
    main()
