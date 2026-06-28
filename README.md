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
