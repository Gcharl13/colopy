# MAPEDIT — modern C reimplementation

A clean, portable, **modern C** rebuild of `MAPEDIT.EXE`, the standalone map
editor that ships with Sid Meier's Colonization (MicroProse, 1994). The goal is
behavioural fidelity — same UI layout, same tools, and a **byte-compatible
`.MP` save/export format** — without any 16-bit DOS assembly.

The format and data model are reverse-engineered from the original binaries and
the game's own `.TXT` resource files (see `../code/MAPEDIT`, `../data_extracted`
and `docs/MP_FORMAT.md`). This directory is the forward implementation.

## Status

| Layer                              | State |
|------------------------------------|-------|
| `.MP` read / write (byte-exact)    | ✅ round-trips AMER2.MP byte-for-byte (`make test`) |
| `.MP` header / layout              | ✅ **6-byte header** (w,h,reserved) + 3 layers — pinned by ground truth (tile (29,36)=Hills) |
| Terrain classification             | ✅ hills/mtn (bit 0x20/0x80), forest (ids 8–23), river (0x40), ocean/sea-lane (25/26) — matches the original status bar |
| `.SS` decoder (MADSPACK + FAB + MS_SPRITE) | ✅ `ss.c` — loads the real PHYS0/TERRAIN sprites |
| `.FF` font decoder                 | ✅ `ff.c` — loads FONTINTR/FONTTINY game fonts |
| Terrain rendering (real game art)  | ✅ base ground (TERRAIN.SS via verified `terrain_cell_transform`), forest canopy, hills/mountains, rivers, coast — all from PHYS0/TERRAIN |
| GUI (wood menu, mini-map, status panel, tile-select popup, game fonts) | ✅ matches the original; screenshot-verified (`mpedit-shot`) |
| Editor tools (paint/fill/overlays/undo/continents) | ✅ core done |
| `mpedit` CLI (info/verify/ascii/new)| ✅ done |
| Native 320×200 layout (scaled up)  | ✅ renders at the original VGA resolution, upscaled `UI_SCALE`× — menu/map/panel proportions match; game fonts (FONTINTR/FONTTINY) |
| SDL2 window/input (`make gui`)     | ✅ written (RenderSetLogicalSize for native coords); needs `libsdl2-dev` |
| Editor model for hills/mtn painting | ⏳ painting sets base ids; hills/mtn-flag painting is a TODO |

## Rendering — faithful to the original (see docs/RENDER_SPEC.md)

With the COLONIZE assets reachable (`$COLONIZE_DIR`, default `../raw/COLONIZE`),
the map composes exactly like VICEROY's O513 chain, using the real sprites:

- **base ground**: `TERRAIN.SS[terrain_cell_transform(land_base)]`
- **forest** (ids 8–23, minus the Scrub/Desert `land_base==1` group): PHYS0
  `0x41 + nmask4_forest` (the verified `forest_neighbour` predicate)
- **hills/mountains** (bit 0x20; 0x80 = mtn): PHYS0 `0x31`/`0x21 + nmask4_feat_hi`
- **river** (bit 0x40): PHYS0 `0x96` (blue + tan banks)
- **coast** (O512, water side): a beach composed from the game's own coast
  colours (sand/shallow/deep ocean sampled from PHYS0 `0x97`) on every
  land-facing edge + corner — the 8×8 sub-cell selection table itself is not
  byte-decoded, so this approximates it without inventing colours
- elevation/feature bits are read from the **packed L1 byte** (stock `.MP`
  leaves the separate feature layer empty; all hills/river/forest bits live in L1)
- each `.SS` uses its **embedded palette** (VICEROY.PAL as a global DAC palette
  mis-colours the indices — verified)

Chrome text uses the real **FONTINTR** (menus) and **FONTTINY** (panel) fonts.
With no assets, everything falls back to verified colours + the built-in font.

`build/mpedit-shot FILE.MP OUT.png [zoom 0..3] [cx cy] [menu|9]` renders the
whole editor screen to a PNG headlessly.

## Build & test

```sh
make            # builds build/mpedit and build/test_mp
make test       # runs unit tests; round-trips ../raw/COLONIZE/AMER2.MP
```

(If the original binaries haven't been materialised yet, run
`python3 ../bin/reconstitute.py` from the repo root first so `AMER2.MP` exists.)

## CLI

```sh
build/mpedit info   FILE.MP      # dimensions, layers, terrain histogram, masses
build/mpedit verify FILE.MP      # load -> save -> byte-compare (round-trip proof)
build/mpedit ascii  FILE.MP      # ASCII minimap
build/mpedit new    W H OUT.MP   # create a blank ocean map with sea-lane borders
```

## Layout

```
include/    public headers (mp, terrain, txt, editor)
src/        core implementation + cli.c
tests/      unit tests
docs/       MP_FORMAT.md (verified byte layout) and design notes
data/       bundled resource snapshots (optional)
```

The core (`libmpedit`: mp/terrain/txt/editor) is GUI-independent: the SDL2 front
end will sit on top of it unchanged.

## Fidelity notes

- **Save/export is byte-exact**: a clean load→save reproduces the input
  byte-for-byte; raw tile bytes are always preserved, so unknown fields can
  never corrupt a file.
- The editor's menus/dialog text and terrain names are loaded from the same
  `NAMES.TXT` / `MAPMENU.TXT` / `MAPEDIT.TXT` resources the original used.
- Items that are reconstructed rather than byte-verified (land ids 16–23, the
  exact coastline-protect rule) are flagged `TODO_VERIFY` in code and docs.
