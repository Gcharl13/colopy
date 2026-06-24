# Provenance ledger — what the Lab models vs. what is byte-accurate

Authoritative map of every value/formula the Lab uses, with its tier (`B/A/R/TBD` per
`METHODOLOGY.md`) and citation. The UI reads these tiers; this file is the human-readable
reference. **If a value here is `R` or `TBD`, a wrong result is a modeling gap, not a bug.**

## Sprites tab — all B
| Item | Tier | Source |
|------|------|--------|
| Sheet list | B | `viceroy_cpp/build/bundle/manifest.json` |
| Frame rects `i/x/y/w/h/ax/ay` | B | `bundle/sprites/<sheet>.json` (same data the C++ reads) |
| Atlas pixels | B | `bundle/sprites/<sheet>.png` (paletted) |
| Placeholder indices 0/16/100 skipped | B | CLAUDE.md hard rule 5 |
| TERRAIN base / PHYS0 overlay roles | B | CLAUDE.md hard rule 5 (amended 2026-06-22) |

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

## Map tab
| Item | Tier | Source / note |
|------|------|----------------|
| Map dimensions 58×72 | B | AMER2.MP header |
| Terrain id = `raw & 0x1F` | B | `func_006204 @0x6204` |
| Terrain id → name table | B | `formats/MP_FORMAT.md` |
| River bit 0x20 / forest bit 0x40 | B | `formats/MP_FORMAT.md` bits 5/6 |
| Sea-lane right column = id 26 | B | CLAUDE.md hard rule 2 |
| **Flat preview colors** | **A** | tool convenience; real look = sprite compositing (M3) |
| **Procedural generator** | **TBD** | DOS generator algorithm not decompiled — *M4, badged* |

## Export
The JSON snapshot embeds: `provenance.summary` (tier counts), `provenance.modeled` (every R/TBD
value + current override), and `provenance.overrides` (explicit edits, original vs. value). That
makes any exported number self-describing — accurate or modeled.
