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
| ICONS foot units 101–105/109, ships 5–7/14–15/127 | B | CLAUDE.md hard rule 6; #109 = `mov ax,0x6D @0x0265BF` |
| ICONS commodities 22–37, cursors, boycott 43 | A | `docs/GHIDRA_REFERENCE.c` (pixel-verified, not a hard rule) |
| **ICONS #100** | **TBD** | **open conflict** — rule 5 (skip) vs rule 6 (foot unit); see `notes/rulings/RULINGS.md` 2026-06-24 |
| Uncited frame role | — | shown as “—”, never guessed |

Role map lives in `lab/js/data/sprite_roles.js` (each entry tier + citation; first match wins).

## Mechanics tab
| Item | Tier | Source / note |
|------|------|----------------|
| Terrain farmer/planter/etc. yields | B | `@UNFORESTED`/`@FORESTED` (NAMES.TXT) |
| Goods base price / drift / burden | B | `@CARGO` (NAMES.TXT) |
| Growth threshold = 200 stored food | B | `func_02D658 @0x2E098` |
| Max colony size = 32 | B | `population < 0x20` |
| Expert bonus (+2 food/horses, ×2 mfg) | B | `colony.md §3` (`@0x9DAD..0x9DD2`) — *wired in M2* |
| Factory tier ×2 (3rd chain link) | B | `count_building_chain_present @0x864E` — *M2* |
| Tory penalty `tory/(10−diff)` | B | `colony.md §3` (`@0x9D14..0x9D98`) — *M2* |
| SoL EMA (1/64 decay, +2·pop) | B | `colony.md §3` (`func_02D658 @0x2DA1C`) — *M2* |
| Price drift `−(price+Σtrade)/256` | B | `market.md §3` (`func_0305A8`) — *M4* |
| Buy/sell + king tax | B | `market.md §3.1` (`@0x32914`) — *M4* |
| Luxury shared-pool coupling | B | `market.md §3` (`@0x030649..`) — *M4* |
| Boycott bitmask / back-tax ×500 | B | `boycotts.md §3` — *M4* |
| **Food consumption = pop × 2** | **R** | user-confirmed; byte-loc TBD (`colony.md §1`) — **editable** |
| **Raw→finished conversion ratios** | **R** | 5 chains known by name; exact ratios not decompiled — *M4* |
| **Ask/bid spread (`burden` role)** | **TBD** | field loaded; exact computation not decompiled |
| **Starvation rule** | **TBD** | not decompiled |
| **Tory-uprising call cadence** | **TBD** | gate known (`func_03CAC6`); WoI invocation frequency TBD |

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
