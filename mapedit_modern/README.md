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
| Terrain model + verified colours   | ✅ ids 0–15, 25, 26 verified; ids 16–23 named TODO_VERIFY |
| `.TXT` resource parser (menus/names)| ✅ parses the same NAMES/MAPMENU/MAPEDIT files |
| Editor tools (paint/fill/overlays/undo/continents) | ✅ core done |
| `mpedit` CLI (info/verify/ascii/new)| ✅ done |
| GUI layout (wood menu, mini-map, status panel, tile-select popup) | ✅ matches the original; screenshot-verified headlessly (`mpedit-shot`) |
| `.SS` asset decoder (MADSPACK + FAB + MS_SPRITE) | ✅ `ss.c` — loads the real PHYS0/TERRAIN textures |
| Terrain rendering with original art | ✅ textured ground + tree overlays + textured water |
| SDL2 window/input (`make gui`)     | ✅ written; needs `libsdl2-dev` to build/run |
| Pixel-exact coast autotiling + mountain/river sprites | ⏳ needs the overlay terrain renderer (terrain.obj) reverse-engineered |

## Rendering with the original art

The renderer uses the actual game sprites when the COLONIZE assets are reachable
(`$COLONIZE_DIR`, default `../raw/COLONIZE` for tools / `.` for the GUI):

- `TERRAIN.SS` supplies the textured ground; each terrain id is matched to a
  frame by nearest colour to the byte-verified palette.
- `PHYS0.SS` supplies the tree overlay (auto-detected) for forested tiles.
- With no assets it falls back to the verified solid colours.

`build/mpedit-shot FILE.MP OUT.png [zoom 0..3] [cx cy] [menu|9]` renders the
whole editor screen to a PNG headlessly — used to verify the layout without a
window server.

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
