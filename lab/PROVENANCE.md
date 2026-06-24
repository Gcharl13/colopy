# Provenance ledger — what the Lab models vs. what is byte-accurate

Authoritative map of every value/formula the Lab uses, with its tier (`B/A/R/TBD` per
`METHODOLOGY.md`) and citation. The UI reads these tiers; this file is the human-readable
reference. **If a value here is `R` or `TBD`, a wrong result is a modeling gap, not a bug.**

## Sprites tab — frames B; semantic roles carry their own tier
| Item | Tier | Source |
|------|------|--------|
| Sheet list | B | `viceroy_cpp/build/bundle/manifest.json` |
| Frame rects `i/x/y/w/h/ax/ay` | B | `bundle/sprites/<sheet>.json` (same data the C++ reads) |
| Atlas pixels + per-frame zoom crop | B | `bundle/sprites/<sheet>.png` (paletted) |
| Per-sheet stats (real / placeholder / sizes) | B | derived from the byte-true frame list |
| Placeholder indices 0/16/100 + 1×1 stubs | B | CLAUDE.md hard rule 5 |
| TERRAIN base / PHYS0 overlay roles | B | CLAUDE.md hard rule 5 (amended 2026-06-22) |
| PHYS0 rivers (1/17), true coast (150–153) | B | CLAUDE.md hard rule 4 |
| ICONS foot units 100–105/109, ships 5–7/14–15/127 | B | CLAUDE.md hard rule 6; #109 = `mov ax,0x6D @0x0265BF` |
| ICONS commodities 22–37, cursors, boycott 43 | A | `docs/GHIDRA_REFERENCE.c` (pixel-verified, not a hard rule) |
| Placeholder skip {0,16,100} is **PHYS0-scoped** (1×1 artifacts) | B | resolved 2026-06-24 (RULINGS); ICONS #100 = real foot unit |
| Uncited frame role | — | shown as “—”, never guessed |

Role map lives in `lab/js/data/sprite_roles.js` (each entry tier + citation; first match wins).

## Colony tab — per-turn sim (M5)
| Item | Tier | Source / note |
|------|------|----------------|
| Terrain farmer/planter/etc. yields | B | `@UNFORESTED`/`@FORESTED` (NAMES.TXT), `@0x9C1E` |
| Tory penalty `−floor(toryCnt/(10−diff))` | B | `compute_terrain_yield @0x9D14..0x9D98` (divisor `@0x9D49`) |
| Expert bonus (+2 food/horses, ×2 mfg) | B | `@0x9DAD..0x9DD2` |
| Manufacturing building gate (g≥8 ⇒ 0) | B | `@0x9F4F` (bit 6) |
| Factory tier ×2 (3rd chain link) | A | `count_building_chain_present>2 @0x8EA9`; ×2 application inferred |
| SoL % = 100·A/B | B | `sol_membership_pct @0x8557` |
| SoL EMA (A,B 1/64 decay, B+=2·pop, A+=bells) | B | `func_02D658 @0x2DA1C..0x2DAD8` |
| SoL steady state ≈ 50·bells/pop | A | derived consequence of the EMA (`colony.md §3`) |
| Growth store = 200, max pop = 32 | B | `func_02D658 @0x2E098`; `population<0x20 @0x009432` |
| **Food consumption = pop × 2** | **R** | user-confirmed; byte-loc TBD — **editable** |
| **WoI bells halving / <pop pressure** | **TBD** | omitted from the EMA sim (noted, not folded in silently) |
| **Starvation rule** | **TBD** | not decompiled |

## Market tab (M4)
| Item | Tier | Source / note |
|------|------|----------------|
| Goods order (16, index 0..15) | B | runtime-verified (`market.md §2`) |
| `@CARGO` price params (start/band/rise/fall/attrition) | B | NAMES.TXT |
| Price drift `base −= (base+Σclamped_trade)/256` | B | `func_0305A8 @0x30618` |
| Price seed random [600,1000]/good | B | `func_07561C @0x75645` |
| Supply `seed + Σ max(accum,0)` | B | `@0x0305AE` |
| Luxury pool `target=(S_pair·3)/supply[i]` | B | `@0x030649` / `@0x030745`; Furs halved `@0x0307C9` |
| SELL `gross→tax→net→gold` (clamp [0,999999]) | B | `func@0x32914`; gold helper `func@0x8806 @0x32a82` |
| King tax = sale·tax%/100 → REF +0x22 | B | `@0x32a4a` (`king.md`) |
| BUY untaxed inline debit | B | page-13 sites |
| **Live state (seed, accumulators, tax %, qty)** | **R** | runtime — modeled/editable inputs the B formulas run on |
| **Boycott bitmask / back-tax** | **B (data); not yet wired** | `boycotts.md §3` (`+0x20`) — future |
| **Raw→finished conversion ratios** | **R** | 5 chains known by name; exact ratios not decompiled |

## Map tab — full sprite-composited render (M3)
| Item | Tier | Source / note |
|------|------|----------------|
| Map dimensions 58×72 | B | AMER2.MP header |
| Terrain id = `raw & 0x1F`, `classify_vis` | B | `func_006204 @0x6204` |
| Terrain id → name table | B | `formats/MP_FORMAT.md` |
| L1 bit semantics: 0x20 hills/mtn, 0x40 river, 0x80 mountain | B | `viceroy_cpp/src/mapview.cpp` (NOT the old M0 0x20/0x40 reading) |
| Forest = id band 8..23 (not a bit) | B | CLAUDE.md hard rule 3 (`@0x6204`) |
| Sea-lane right column = id 26 | B | CLAUDE.md hard rule 2 |
| **Frame pixels** (TERRAIN.SS + PHYS0.SS) | **B** | bundle indexed PNGs, decoded to indices (`png_indexed.js`) |
| **Layer order + sprite selection** | **B** | hard rules 3/4/5/7; port of `mapview.cpp` `terrain_compose` |
| Active palette = PHYS0 embedded PLTE | B | `main.cpp:225` (`scr.set_palette(tiles.pal)`) |
| **Edge-blend + coast-connectivity heuristics** | **A** | inherit `mapview.cpp`'s tier (RULINGS 2026-06-22 / INGAME_MAP_RENDER_TRACE) |
| **Procedural generator** | **TBD** | DOS generator algorithm not decompiled — *M4, badged* |

The render pipeline (`js/data/png_indexed.js` → `js/sim/sheet.js` → `js/sim/surface.js` →
`js/sim/mapview.js`) is a 1:1 JS port of the C++ reference renderer: it decodes the SAME
indexed atlases the C++ reads, reconstructs each frame's palette-index pixels, composites on
an indexed Surface, and resolves to RGB through PHYS0's palette — so the lab map is the
byte-faithful image, not a recolor.

## Export
The JSON snapshot embeds: `provenance.summary` (tier counts), `provenance.modeled` (every R/TBD
value + current override), and `provenance.overrides` (explicit edits, original vs. value). That
makes any exported number self-describing — accurate or modeled.
