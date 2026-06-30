# Viceroy Forge

A headless **design & modding tool** for the new-colony game, built on the tested
sim core (`viceroy_cpp/sim`). It is the shared content pipeline upstream of the
player clients (Godot / ESP32): the Forge is the only component that *writes*
content; the clients only *read* it. See `docs/PORTING_OPTIONS.md` for the strategy.

The pure sim core stays dependency-free (it still cross-compiles for embedded); all
I/O (JSON, files) lives here in `forge/`. The lone runtime dep is libpng (for the
non-Forge importer), not used by the Forge CLI.

## Build

```bash
cmake -S viceroy_cpp -B viceroy_cpp/build -DCMAKE_BUILD_TYPE=Release
cmake --build viceroy_cpp/build -j
(cd viceroy_cpp/build && ctest)        # sim_tests + forge_{map,rules,mod,save,data}
```

## CLI

```
forge inspect [overlay.json]   validate a ruleset + chart its balance curves vs the default
forge rules diff IN [OUT]       write the sparse rules.json overlay diff vs the default
forge rules selftest            overlay write/round-trip self-test
forge map validate FILE.mp      check a map (Sea-Lane edge, id ranges, land/ocean masses)
forge map roundtrip FILE.mp     confirm .MP load->save->load is byte-identical
forge map selftest              self-contained .MP round-trip + validate test
forge mod validate DIR          validate a mod package (modinfo + rules + map)
forge mod selftest              write/load/validate a mod package
forge save selftest             game save/load round-trip self-test
forge data check [FILE]         structural-validate the data tables (names_tables.json)
forge data selftest             data-table validator self-test
forge serve [port]              launch the browser GUI (default port 8099)
```

## Browser GUI (`forge serve`)

The graphical front-end is a **local web app** — no OpenGL/GLFW, no extra deps. It is a
tiny built-in HTTP server (POSIX sockets, bound to `127.0.0.1` only) that serves an
embedded HTML/JS page and exposes the tested C++ backend over a small JSON API.

```bash
viceroy_cpp/build/forge serve            # then open http://127.0.0.1:8099 in any browser
viceroy_cpp/build/forge serve 9000       # custom port
```

Run it from the repo root so the default data paths resolve. Tabs:
- **Rules** — click **Load full ruleset** to dump the *entire* real ruleset (every unit,
  terrain id, and balance constant) into the editor, or paste a sparse `rules.json` overlay
  (or leave empty for the default). Apply to see invariants PASS/FAIL + the balance curves
  vs the baseline; Download writes the **sparse** overlay (only your edits) even if you
  started from the full dump. (Endpoint: `GET /api/rules/full`.)
- **Map** — Load a `.MP`, paint terrain on the canvas (palette + river/forest toggles),
  Validate, and Save (byte-faithful — trailing metadata preserved).
- **Data** — structural-validate `data_extracted/tables/names_tables.json`.

Notes: the server is **local-only** by design (binds `127.0.0.1`; the API reads/writes
files by path), so don't expose the port. **Windows is supported natively** — the server
uses Winsock there (CMake links `ws2_32`), so `forge serve` works in PowerShell/cmd; WSL
also works. The Dear ImGui desktop app (`-DFORGE_GUI=ON`, see `gui/README.md`) remains an
alternative.

### Zero-dependency build (incl. Windows)

libpng is needed **only** by the asset importer/renderer (`viceroy_cpp`). `forge` and the
tests don't use it, so it's optional — without libpng, CMake skips the importer and still
builds the Forge:

```bash
cmake -S viceroy_cpp -B build -DCMAKE_BUILD_TYPE=Release   # importer auto-skipped if no libpng
cmake --build build -j --target forge
```

On a bare Windows toolchain (MSVC/MinGW, no vcpkg) this builds `forge` (CLI + browser GUI)
with only CMake + a C++17 compiler.

## The content pipeline

```
data_extracted/tables/*.json ─ data check ─┐
                                            │
   default RuleData (value-identical) ──────┼─ rules diff ─▶ rules.json (sparse overlay)
                                            │                      │
   forge inspect (balance curves) ◀─────────┘                      │
                                                                   ▼
   .MP map ── map edit/validate ──▶ map.mp ──┐            mod write ──▶  mymod/
                                             └──────────────────────────┘ (modinfo+rules+map)
                                                                   │
                                          mod validate ◀───────────┘  (check_rules + map validate)
                                                                   │
                                              save/load ◀── a running GameState+World
```

## Source layout

| File | Role |
|------|------|
| `json.{hpp,cpp}` | tiny dependency-free JSON reader + serializer |
| `inspect.hpp` | balance-curve computations (shared by CLI + GUI) |
| `rules_json.{hpp,cpp}` | apply/diff a `RuleData` overlay (`rules.json`) |
| `mapedit.{hpp,cpp}` | byte-faithful `.MP` read/write + edit + validate |
| `mod.{hpp,cpp}` | mod package write/load/validate (`modinfo.json`) |
| `savegame.{hpp,cpp}` | full `GameState`+`World` JSON save/load |
| `datacheck.{hpp,cpp}` | structural validation of the raw data tables |
| `main.cpp` | the `forge` CLI |
| `gui/` | optional Dear ImGui desktop front-end (`-DFORGE_GUI=ON`; see `gui/README.md`) |

## What's data-driven vs code

The sim reads its balance numbers from a `RuleData` (units/terrain/scalars), whose
defaults are **value-identical** to the original (oracle: `tools/verify_rules.py`).
Formulas, enums (`NUNITTYPES=24`), and the fixed sprite atlas are code/art walls —
so the Forge is a **balance laboratory + content editor**, not an arbitrary
game-logic SDK. Edits are validated against the same `sim_tests`/`check_rules`
engine the clients run.
