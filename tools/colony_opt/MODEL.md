# Colony Layout / Count Optimization — AMER2.MP (separate exercise)

> **Scope note (per user request 2026-08-15):** this is a standalone analysis
> exercise, NOT spec work. It amends nothing in `spec/` or `docs/`. Trust labels
> follow repo convention: byte offsets = byte-verified; **(R)** = manual/classic
> reconstruction; **TBD** = unresolved.

## What it is

The per-tile production engine (`compute_terrain_yield`, file `0x9B9C..0x9FFB`)
and the colony balance laws are piecewise **linear**, so "optimal colony layout,
size and count" is a well-posed mixed-integer linear program. `optimize.py`
builds that MILP from the extracted primary data and solves it exactly (CBC)
against `data_extracted/map/AMER2_tiles.json`.

## Model (each line carries its evidence)

Per-tile yield for terrain t, profession column p, improvements I, expert e:

```
y = gate( ((T[t][p] + nudge + tory) (+) expert) + R(r,p)*(1+e) + improv(I,p) )
```
- `T` = NAMES.TXT $TERRAIN yields (names_tables.json), loaded at DGROUP:0x2F7B `@0x9C1E`.
- ids 16..23 fold to 8..15 via `(id&7)|8` `@0x6225`.
- nudge (water column): +1, or -1/-2 with 6/8 water neighbours `@0x9C3E`.
- tory: `-floor(P*(100-SoL)%/(10-difficulty))` `@0x9D49..0x9D98` (0 at SoL 100%).
- expert: food columns +2 `@0x9DBF`; all others x2 `@0x9DD2` (SHL).
- `R(r,p)`: resource switch `func_009AAA @0x9AAA`, fully decoded in this exercise
  (Oasis/Wheat/Game +2 food; Game +2 furs; Beaver +3; Prime Sugar/Tobacco/Cotton
  = base x2 via the -1 marker `@0x9DFE`; Prime Timber +2; Minerals +3 ore/+1
  silver; Ore Deposit +2; Silver Deposit +2; Fishery +3); positive bonus doubled
  for expert `@0x9E0A`. **Positions of resources are runtime (TBD)** — the
  AMER2.MP trailer decodes as 2 region-id layers, not a resource layer.
- improv: plow -> columns <=3, road -> columns >3 `@0x9F01..0x9F2C`; bonus 1, or
  2 on lumber column / river tile `@0x9EC6/@0x9EDD`. Clear = id-8 `@0x040896`.
- Center tile: food class 0/1/2/3 `@0xA247..0xA294` + river `@0xA2C5` +
  difficulty `@0xA29C` + rebel latches `@0xA335/@0xA33F`, plus best non-food
  commodity (lumber excluded `@0xA375`) `@0xA343..0xA3D4`.

Colony laws:
- food eaten = `2*pop` `@0xA5F2`.
- SoL EMA `@0x2DA1C..0x2DAD8`: `B <- B - B/64 + 2P`, `A <- A - A/64 + bells`
  => fixed points B*=128P, A*=64*bells => **SoL% = 50*bells/P** (100% needs
  bells >= 2/colonist/turn).
- bells base +1 `@0xA4DB`; Newspaper x2 else Printing Press x1.5
  `@0xA587..0xA5AC`; FF op 0xF +50% `@0xA4DF`.
- chains 1:1 (`func_008E84`), factory tier consumes 2/3 `@0x8EB1`.
- building worker rates 3 free / 6 expert, <=3 per shop, Lumber Mill x2 —
  **(R)** (constants sighted at `0xA0E5/0xA12C` in `func_009FFC`, tier
  semantics not fully traced).
- auto-sale of surplus each turn `@0x2D6F7..0x2D785`; warehouse cap
  `(level+1)*100` (`func_008D00`) non-binding in steady state.

MILP per site sigma, population P (expert scenario, 100% SoL enforced,
prices = @CARGO mid-start):

```
max  sum_g price_g*sold_g + w_H*hammers
s.t. one worker per ring tile; headcount = P; food >= 2P;
     2*(1+6s) >= 2P;  raw_g - 6*m_g = sold_g >= 0;  lumber >= 6c
```

Empire layer: `max sum v_sigma(n_sigma)` s.t. `sum n <= C`, rings disjoint
(Chebyshev >= 3) — near-concave v => greedy exchange, implemented in
`optimize.py::pack`.

## Headline results (results.json)

- Best site: **(17,28) prairie+river**, pop* = 13, **346.5 gold/turn**
  (3 farmers, 3 sugar planters on cleared Tropical->Savannah, 1 cotton planter,
  2 distillers, 2 weavers, 2 statesmen; food 26 = 2*13 exactly).
- Top sites cluster on clearable Tropical forest belts (sugar->rum) and one
  Boreal furs->coats site at (8,2).
- Colonist budget -> colony count: 16 -> 8 colonies (land-grab: free center
  tiles), 24+ -> 11 colonies, then deepen toward pop ~13 each.
- Pre-100%-SoL, the tory term is superlinear in colony size (P tiles each lose
  floor(P*...)), so K small colonies dominate one large one until bells catch up.

## Run

```
pip install pulp
python3 tools/colony_opt/optimize.py     # ~1 min; writes results.json
```

Full writeup with map, charts and derivations: published as the
"Colony Calculus" artifact (2026-08-15 session).
