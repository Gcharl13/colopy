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
| `.MP` read / write (byte-exact)    | ✅ done — round-trips AMER2.MP byte-for-byte (`make test`) |
| Terrain model + palette            | ✅ done — verified ids 0–15, 25, 26; ids 16–23 named TODO_VERIFY |
| `.TXT` resource parser (menus/names)| ✅ done — parses the same NAMES/MAPMENU/MAPEDIT files |
| Editor tools (paint/fill/overlays/undo/continents) | ✅ core done (headless) |
| `mpedit` CLI (info/verify/ascii/new)| ✅ done |
| SDL2 GUI (menus, palette, map view, status bar) | ⏳ next |

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
