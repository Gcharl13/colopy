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
- **building worker rates — BYTE-DECODED (rev 2, 2026-08-15)**, `func_009FFC`
  full trace (was SKELETON):
  ```
  rate = base + sol      base: 3 free/expert, 2 servant, 1 criminal/convert @0xA0D7..A0F8
                         sol : +1 rebel-majority latch (+0x1C bit 4),
                               +1 rebel-unanimous latch (bit 2)             @0xA098..A0AC
  shop tier   (chain count > 1): rate += base                               @0xA1A4
  factory tier(chain count > 2): rate += rate/2                             @0xA1B2
  expert match: rate *= 2   (applied LAST)                                  @0xA127/@0xA12C
  ```
  Jump table CS:0x1F44 (base 0x82B0): jobs 9..15 -> generic converter
  @0xA188 (output good = job index); job 13 Carpenter -> Hammers @0xA100
  (expert flat 6 + sol, **Lumber Mill x2 = building 0x24 @0xA11C — now B**);
  job 16 Preacher -> Crosses @0xA132 (Cathedral 0x26 x2 @0xA14F, FF op 0x15
  +50% @0xA15F); job 17 Statesman -> Bells @0xA1C8 (expert x2 only).
  => expert in factory at 100% SoL: **24 out / 16 in** (18/12 below rebel
  majority); Elder Statesman **10 bells**; Master Carpenter + Mill **16
  hammers**. Only "<=3 workers per shop" and the carpenter 1:1 lumber debit
  remain **(R)**.
- tile-side SoL latches: +1/+1 added @0x9D88/@0x9D92 BEFORE the expert step;
  for food/era columns added AGAIN after the expert +2 (@0x9DC3..0x9DCC).
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

## Rev 3 — resource-flow framing (2026-08-15, user directive)

Market prices removed from the analysis (they drift with sales volume; the
user wants physical production). The unit of account is now flows/turn.
`configs.py` defines the configuration catalog (docstring there) and scores
every AMER2 site per configuration; the standard cluster (5 outposts + ranch +
factory capital + armory town, pop 76) nets per turn: **72 each of
rum/cigars/cloth/coats + 72 muskets + 24 tools + 24 horses**, food
self-balancing (+43). Horses, not muskets, are the military bottleneck
(stock-growth law); bells and hammers are per-colony and non-importable.
Best outpost sites: Sugar (19,29)=71, Tobacco (7,8)=71, Cotton (10,14)=70,
Furs (7,2)=71, Ore (14,21)=60, Granary (12,10)=+77.
The gold-objective solver below (rev 2) is retained as a legacy mode.

## Headline results (results.json, rev 2 rates)

- Best site: **(17,28) prairie+river**, pop* = 14, **1,199.5 gold/turn**
  (5 sugar planters on cleared Tropical->Savannah, 1 cotton planter, 2 farmers,
  3 Master Distillers = 72 rum, 1 weaver = 24 cloth, 2 statesmen = 42 bells;
  food 28 = 2*14 exactly). Pop 15+ is MILP-infeasible self-sufficiently —
  the 8-tile ring cannot feed more AND supply the shops; imports required.
- One maximal factory (72 out / 48 in) needs ~6 expert planters behind it, so
  a colony hosts ~1.5 factories; multi-chain capitals must import raw.
- Colonist budget -> colony count: 16 -> 8 colonies (land-grab: free center
  tiles), 24+ -> 9 colonies, then deepen toward pop ~13-14 each.
- Pre-100%-SoL, the tory term is superlinear in colony size (P tiles each lose
  floor(P*...)), so K small colonies dominate one large one until bells catch up.
- 100% SoL compounding: the +2 latch bonus lands BEFORE tier/expert multipliers,
  so unanimity is worth +6/expert in a factory, not +2.

## Run

```
pip install pulp
python3 tools/colony_opt/optimize.py     # ~1 min; writes results.json
```

Full writeup with map, charts and derivations: published as the
"Colony Calculus" artifact (2026-08-15 session).
