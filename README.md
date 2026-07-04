# new-colony — a build-from-spec starter kit

A clean, self-contained starting point for building a **new implementation** of a
*Sid Meier's Colonization*-style game (any language, any engine) from a complete,
byte-verified specification — without any of the reverse-engineering machinery that
produced it.

This repo is a **fresh, independent copy** of the spec + data + assets from a prior
RE project. It carries **no commit history and no disassembly** — just the contract,
the game data, the graphics, and the tools to (re)generate them from original files.

## What's here

| Path | What it is |
|------|------------|
| **`spec/`** | The **contract** — every system's formulas (`spec/systems/*.md`), every screen's layout/font/color (`spec/ui/*.md`), and the data-record layouts (`spec/data/*.md`). Byte-verified; **this is the source of truth.** Start at `spec/README.md`. |
| **`formats/`** | File-format specs for the original data/asset files (`.MP` maps, `.SS` sprites, `.PAL` palette, `.PIK` backgrounds, `.FF` fonts, `.TXT` tables). |
| **`data_extracted/`** | The decoded **game data** as JSON: `text/` (NAMES/GAME tables — terrain, units, buildings, cargo, fathers…), `tables/`, `map/` (AMER2 etc.), `palette.json`. |
| **`docs/atlas/`** | The **graphics** — 206 sprite sheets + 35 backgrounds as **paletted PNGs** (indices preserved for palette cycling) with `frames.json` metadata. |
| **`docs/screens/`** | Reference screenshots of the original — a **visual oracle** to diff against. |
| **`docs/GAME_MANUAL.md`** | The original game manual (HIGH-trust for *what a feature does*). |
| **`viceroy_cpp/`** | A **reference C++ port** (asset importer + format loaders + a thin sim core). Crib loaders/patterns from it, or ignore it and start fresh. |
| **`bin/` + `tools/`** | The **asset/data pipeline**: `bin/*.b64` + `reconstitute.py` rebuild the original files from your own copy; `tools/ssdec.py` + `extract_*.py` decode them into the data/atlas above. |
| **`REWRITE_READINESS.md`** | The implementation strategy — fidelity policy (preserve vs modernize), architecture (sim core / presentation / asset bundle), and validation approach. **Read this before coding.** |
| `METHODOLOGY.md`, `NAMING_CONVENTIONS.md` | Project conventions (three-layer model; the spec is Layer 2, your implementation is Layer 3). |

## The one rule
**Build from the spec.** Where `spec/` states a formula, layout, color, or value, that is
the contract — reproduce its *output*. The *route* (language, math width, RNG, engine) is
free; see `REWRITE_READINESS.md` §1 for the preserve-vs-modernize line.

## Forge — the native desktop engine

**Forge is the product: a fully native desktop game-development engine**
(Dear ImGui — no web technology). It opens a *project* — a folder of game
data; this repository checkout is the Colonization project — and presents
every layer as editable, journaled, undoable data that saves back to the
project as canonical text (`data/`, Ctrl+S):

| panel | what it does |
| --- | --- |
| Records / Inspector | every record type in the store; field-level editing |
| Sprites | the full 437-sprite catalog drawn from the real sheets |
| Popups | all 499 GAME.TXT messages rendered through the wood-frame engine; test `%NUMBER/%STRING` fills + choices, edit text/box/speaker |
| Screens | the screen designer: real PIK backgrounds (movable), sprites, text with `{bindings}`, buttons + message boxes in game chrome; **Play mode** fires onClick events with real in-chrome popups |
| Tables | spreadsheet grid per record type, inline cell editing |
| Rules | the config knobs grouped by system; edits hit the live rules |
| Events | the 36 typed chain events with commentary + step trees |
| Map | the byte-faithful `.MP` editor rendered with the real tile stack; paint terrain/river/forest, validate, save |
| Game | the playable game: map/units/turns, click a colony for the full colony screen (assign colonists, right-click picks the profession), `E` for Europe (live market, docks recruit, artillery), `F1..F10` advisor reports |

```bash
# build (cmake, C++17; SDL2 for the editor on Linux; zlib/libpng optional)
cmake -S viceroy_cpp -B viceroy_cpp/build
cmake --build viceroy_cpp/build -j8

./viceroy_cpp/build/Forge .             # open THIS checkout as the project
```

On Windows the binary is `Forge.exe` — double-click it inside the project
folder (or anywhere: it asks you to pick one). Cross-compile from Linux:

```bash
cmake -S viceroy_cpp -B viceroy_cpp/build-win \
      -DCMAKE_TOOLCHAIN_FILE=$PWD/viceroy_cpp/cmake/mingw-w64-x86_64.cmake
cmake --build viceroy_cpp/build-win -j8 --target forge_studio   # -> build-win/Forge.exe (static)
```

**Your game files upgrade the art automatically.** The repo ships decoded
art; the `.FF` fonts and original `.SS`/`.PIK` codecs are loaded straight
from the game's own files when present — drop `FONTTINY.FF` (and any
`.SS`/`.PIK` you have) into `raw/COLONIZE/` and Forge uses the real fonts,
sheets, backgrounds and portraits everywhere.

The same build also produces `forge` (the CLI: selftests, map/rules/save
tools, plus `forge serve 8099` — the legacy browser mode kept as reference),
`viceroy` (a standalone SDL2 game runtime), and the asset-pipeline CLI.
Verify a checkout: `ctest --test-dir viceroy_cpp/build` (16 gates incl. the
native render/popup/app/editor smokes).

## Regenerating assets from your own game files
The original copyrighted assets are **not** shipped verbatim. To rebuild them locally:

```bash
pip install -r requirements.txt
python bin/reconstitute.py                 # rebuild original files from bin/*.b64
python tools/extract_pal.py ...            # palette → data_extracted/palette.json
python tools/ssdec.py ...                  # .SS sprites → PNG atlas
# (see REWRITE_READINESS.md §4a for the full import pipeline)
```

## License / provenance
The decoded data tables and the paletted-PNG atlas are derived from copyrighted MicroProse
assets and are included here for a **private** build-from-spec effort. Do not redistribute the
art or any reconstituted binaries. Ship your engine + importer, not the converted assets.
