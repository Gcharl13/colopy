# port/ — Colonization, HTML/canvas port

A Layer-3 implementation built **from the spec**
(`docs/COLONIZATION_TECHNICAL_REFERENCE.md` + `spec/`), following
`REWRITE_READINESS.md` §1: **preserve every player-visible number and layout,
modernize the form.** Every screen's geometry cites the manual section it came
from.

## Milestone M0 — the start sequence (done)

Title/main menu → difficulty → nation → leader name → nation briefings →
the 10-card intro slideshow → the King's audience → the map view.

| Screen | Source | Fidelity notes |
|---|---|---|
| Main menu | §26.1 | `OPENMENU.PIK`; plaque (77,91,166,58), `OPENTILE.SS` tiled fill, FONTTINY, `{}`-span gold 0xFC; rows at y=107+8k; real dispatch ladder (rows 0–2 → setup, 3 = load, 4 = hall of fame) |
| Difficulty | §26.2 | `DIFFICUL.PIK`; cells `(idx%3)*105+23, (idx/3)*96+7, 68x90` with `idx = n+1`; per-row outline ink {0x0A,9,0x0E,0x0D,0x0C}; titles y=16/29 |
| Nation | §26.3 | `NATIONS.PIK`; cells `(i%2)*99+112, (i/2)*91+13, 88x82`; outline = the nation's flag colour; titles y=36/49 |
| Leader name | §26.4 | `WOODPANL.PIK`, FONTINTR, default = the nation's leader, maxlen 23 |
| Briefings | §26.5 | `@NATIONnA` history + `@NATIONnB` bonus, `{}` spans gold |
| Intro cards | woodcuts_and_intro §2 | `LEVN0001..0010.PIK` + `@BUILD1..10`, ink 0x0E, `%STRING` substitution per card |
| King's audience | §26.13 | `@VICEROY` / `@VICEROY2` (Netherlands), FONTKING |
| Map view | §26.7 | viewport (0,8,240,192) 15x12 @16px; minimap (241,8,79,41); sidebar season/gold/tax + unit panel |

Rules already wired: starting gold by difficulty (1000/300/0/0/0), the
`@SCENARIO` start tiles (England 34,20 · France 39,10 · Spain 47,61 ·
Netherlands 50,33), the Dutch Caravel→Merchantman upgrade, the doubled
starting force at difficulty ≤ 1, and the year cadence (1 turn = 1 year
before 1600, then seasons).

## Build

```sh
python3 port/tools/build_assets.py   # col.zip -> port/assets/ (PNG + manifest)
python3 port/tools/bundle.py         # -> port/dist/colonization.html (one file)
```

`build_assets.py` reuses the byte-verified codec in `tools/ssdec.py`
(MADSPACK/FAB); the `.PIK` layout follows `viceroy_cpp/src/pik.cpp` and the
`.FF` font layout follows `data_extracted/fonts/ff_metrics.json`.

**Fonts.** `.FF` glyphs are 2bpp and the engine maps levels 1–3 through a
3-entry palette LUT (level 1 = the main ink, level 3 = the dark core — the
pickers use 254/253/0). Each level is exported as its own mask and the
renderer tints and stacks them, which is what gives the text its embossed look.

**Palettes.** Each `.PIK` carries its own 256-colour palette. The master
`VICEROY.PAL` leaves 0xFC–0xFE as magenta placeholders, and `WOODPANL`/`LEVN`
leave them unset too, so the loader keeps each backdrop's scene colours and
patches only the placeholder entries from the picker palette.

## Assets and copyright

`port/assets/` and `port/dist/` are **generated from your own copy of the game
and are git-ignored** — the same convention `CLAUDE.md` sets for `extracted/`.
Nothing copyrighted is committed. Run the two build steps above to produce them.

## Next milestones

M1 land movement + fog · M2 found a colony and the production loop ·
M3 Europe and the market · M4 combat and natives · M5 King/REF/Congress.
AI opponents are deliberately last — `spec/systems/ai.md` is the thinnest area
and real opponents would mean inventing behaviour rather than porting it.
