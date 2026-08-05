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
| King's audience | §18.5 / §26.13 | `KINGLSS1.PIK` throne room + `KING1.SS` king-and-dog + the nation canopy banner (`ENGLND1`/`FRANCE1`/`SPAIN1`/`DUTCH1`), both placed by their frame descriptors' (centre-x, bottom-y) anchor; `@VICEROY` / `@VICEROY2` scroll in FONTKING at `@width=78 @x=232 @y=21`, 8px pitch, `^^` lines centred |
| Map view | §26.7 | viewport (0,8,240,192) 15x12 @16px; minimap well (252,9,56,39) in a 1px orange frame; menu bar = wood + FONTTINY titles in HUD green with COLONIZOPEDIA at x=259; sidebar season/gold/tax + unit panel |

Rules already wired: starting gold by difficulty (1000/300/0/0/0), the
`@SCENARIO` start tiles (England 34,20 · France 39,10 · Spain 47,61 ·
Netherlands 50,33), the Dutch Caravel→Merchantman upgrade, the doubled
starting force at difficulty ≤ 1, and the year cadence (1 turn = 1 year
before 1600, then seasons).

### Terrain compositor (§6.3–6.11)

Tiles go through the O514 → O513 → O512 chain. Implemented: the ground fold
(`func_006204`), the **adjacency-masked** overlay bands — forest `0x40+mask`,
mountains `0x20+mask`, hills `0x30+mask`, rivers `0x00`/`0x10 + mask` with an
isolated river forced to `0xF` — river mouths, the coastal beach halo (clean
edges 150–153 plus the 8×8 quadrant fallback) and the prime-resource detail
band. Masks weight **N=8, S=4, W=2, E=1**; the sprite index on disk is the
manual's engine frame **minus one**.

Two coast details were settled by rendering `AMER2.MP` and diffing against the
live DOSBox frame `docs/screens/colony_sites_live.png` — both are written up in
`notes/rulings/RULINGS.md` (2026-08-04): the quadrant code's `|=1` bit is the
**counter-clockwise** cardinal (not clockwise, as the manual read), and the halo
ground substitution shows through the **clean-edge** frames only, the quadrant
frames compositing over open water.

### The fog path (§6.11)

An unexplored tile is **not black**: it draws PHYS0 engine frame `0x95`
(disk `0x94`), then runs O512 so explored neighbours dither into its edge.
Both halves are pixel-verified against `docs/screens/06_ingame_map.png`
(the opening turn: one caravel, a 3×3 explored patch, everything else fogged):
every fog tile away from the patch matches frame `0x94` exactly, each fog tile
cardinally touching it carries the stencil's dots on that cardinal's band, the
diagonals are untouched, and the patch's own tiles take nothing back from the
fog. The skip rule that produces all four is in `notes/rulings/RULINGS.md`
(2026-08-05), along with the `PHYS0C`-vs-`PHYS0` stencil-atlas bug that entry
also fixes.

Not yet implemented: roads as a terrain band (§6.8 — the loader discards the
feature plane anyway; player-built roads come from the improvement layer
instead), and **water palette cycling** — bands 54–60 and 120–127 are pure
rotation in the original, but the tick rate and direction are undecoded, so the
port renders the water static at the master palette's phase (which is the phase
the live map capture shows). The base water tile itself is now **253/256 pixels
exact** against that capture; see the 2026-08-05 palette ruling for the three
that are not, and why they are not a palette question.

## Build

```sh
python3 port/tools/build_assets.py   # col.zip -> port/assets/ (PNG + manifest)
python3 port/tools/bundle.py         # -> port/dist/colonization.html (one file)
python3 port/tools/shots.py          # -> port/_shots/*.png, one per screen
```

`shots.py` drives the bundle headlessly in Chromium and dumps each screen at
the logical 320×200, so output can be diffed pixel-for-pixel against the DOSBox
captures in `docs/screens/`.

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

M1 land movement + fog, M2 colonies and the production loop, M3 Europe and the
market, M4 combat and natives, and M5 King/REF/Congress are **done**, as is
every row of all six MENU.TXT pulldowns (`test_flow.py` asserts the binding).

What is left:

- **The base ocean sprite.** The largest remaining pixel gap against the DOSBox
  captures — see the fog-path section above and the 2026-08-05 ruling.
- **AI opponents**, deliberately last: `spec/systems/ai.md` is the thinnest area
  in the spec and real opponents would mean inventing behaviour rather than
  porting it. The rival powers exist as diplomatic actors, not as players.
- **Audio**, out of fidelity scope by user decision (`docs/AUDIO_SPIKE.md`).
