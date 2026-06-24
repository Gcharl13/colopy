# Colopy Lab — sprite / mechanics / map verification tool

A self-contained, multi-tab **browser** tool for testing the reconstruction **without the
C++ build loop**. It loads the same committed data and sprite bundle the C++ reads, runs the
spec mechanics in JS, and lets you drive inputs and **export provenance-tagged state** for
analysis.

## Why this exists
The C++ path is slow to iterate, and a static render can't tell you whether a wrong value is a
*bug* or just a *part of the spec we haven't decompiled yet*. The Lab makes that distinction
explicit and unmissable.

## The one rule: accurate vs. modeled
Every value carries a **tier** (from `METHODOLOGY.md`) and a citation:

| Tier | Meaning | How it looks | Editable? |
|------|---------|--------------|-----------|
| **B** | byte-verified (EXE offset / NAMES-GAME.TXT) | plain white + small `B` | no |
| **A** | inferred from framework, high confidence | blue dotted underline | no |
| **R** | **modeled** assumption — *not* byte-truth | **amber, editable field** | **yes** |
| **TBD** | unknown / not decompiled | **red `?`, editable** | **yes** |

So when a number looks wrong: **B wrong → report a bug.  R/TBD wrong → a placeholder behaving
as designed → tune the assumption** (edit it in place; the flow updates live). Exports record
the tier, citation, and any override of every value — see `PROVENANCE.md` for the full ledger.

## Run it
Browsers block `fetch()` from `file://`, so serve the repo root with any static server:

```bash
cd /home/user/colopy
python3 -m http.server 8000
# then open:  http://localhost:8000/lab/
```

The tool fetches:
- `../data_extracted/palette.json`, `../data_extracted/tables/names_tables.json`,
  `../data_extracted/map/AMER2_tiles.json` (committed, **B**)
- `../viceroy_cpp/build/bundle/{manifest.json,sprites/*.{png,json}}` (regenerable — run
  `viceroy_cpp/build/viceroy_cpp import-all --colonize raw/COLONIZE --out viceroy_cpp/build/bundle`
  once if the bundle is missing)

## Tabs (built incrementally)
- **Sprites** *(M1)* — sheet picker, atlas + clickable frame boxes, full frame table, per-frame
  zoom inspector, hide-placeholders/filter, byte-cited frame roles.
- **Colony** *(M5)* — single-colony per-turn sim: per-tile production (Tory penalty, expert,
  building gate, factory), raw→finished chains, the Sons-of-Liberty EMA, and food growth.
- **Market** *(M4)* — European market: per-turn price drift, luxury shared-pool coupling, buy/sell
  with the King's tax, and boycotts (bitmask, back-tax to lift, Jakob Fugger clear-all).
- **Map** *(M3)* — AMER2.MP rendered as the FULL sprite composite (TERRAIN.SS + PHYS0.SS, ported
  1:1 from `mapview.cpp`); tile inspector with layer stack.
- **World Gen** — a live map view driven by the four byte-verified Customize-New-World inputs
  (LAND MASS / LAND FORM / TEMPERATURE / CLIMATE = `@CLAND/@CCONT/@CTEMP/@CCLIM`, `DGROUP:0x1E7E`)
  plus a seed; change any and the world rebuilds via `func_064A10`'s passes through the same renderer.
- **Settings & Export** — provenance ledger + snapshot export (JSON now, CSV series with M2).

## Status
**Complete:** M0 scaffold + provenance spine; M1 Sprites; M3 full sprite-composited Map render;
M4 European Market (drift, luxury pool, buy/sell, boycotts); M5 colony per-turn sim (production,
raw→finished chains, SoL EMA, growth); and the Customize-New-World map generator. Every value is
tier-tagged — byte-verified formulas vs modeled runtime state — and the remaining gaps are TBD-
badged in `PROVENANCE.md` (raw:finished ratio, WoI/starvation rules, byte-exact RNG), never faked.
