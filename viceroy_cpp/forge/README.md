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
forge formulas                  print the complete formula/function catalog (all systems)
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
- **Map** — Load a `.MP` and see it drawn the way the game does: `TERRAIN.SS` base ground
  with **`PHYS0.SS` overlays composited on top per each tile's neighbours** — forest canopy,
  rivers, and **coastline beaches/shore** (the `compose_coast`/forest-mask logic ported from
  `viceroy_cpp/src/mapview.cpp`). `AMER2.MP` renders as a recognizable, textured Americas.
  Tilesets are cropped offline into `data_extracted/tileset/{terrain16,phys0}.png`. Toggle
  "real tiles" off for flat colors. Paint terrain, Validate, Save (byte-faithful).
  *Caveat:* the committed contact sheets baked transparency to opaque black, losing the
  original land-side/ocean-cutout index distinction, so coast is a faithful **approximation**
  — the byte-exact pipeline needs the raw `.SS` assets (run `viceroy_cpp mapview` for those).
- **Data** — structural-validate `data_extracted/tables/names_tables.json`.
- **Formulas** — a read-only catalog of *every* formula the sim computes (the logic
  behind the data): each function, the exact expression, the editable `cfg` knobs that
  feed it, and which parts are fixed code logic. The complete ruleset = the editable
  data (Rules tab) **+** this logic. Also available as `forge formulas` (text) and
  `GET /api/formulas` (JSON); a committed copy lives in `FORMULAS.txt`.
- **Assets** — browse every preloaded asset: all 206 sprite sheets and 35 full-screen
  images, served from `docs/atlas/` (`GET /api/assets` lists them; `GET /assets/<sub>`
  serves the bytes). Filter by name; click any tile to view it full size in a popup.
- **Screens** — pick a full-screen background (colony, Europe, reports…) and compose on
  top of it: click to drop clickable **hotspot** buttons, each wired to the popup system.
  A seed for the screen/UI designer, demonstrating the engine's button/popup/event layer.

- **Play** — the **engine loop**: a real game on the real Americas map driven by the same
  headless sim, with **real unit sprites** (cropped from `ICONS.SS` into
  `data_extracted/tileset/units.png`, one per unit type). **New game** seeds colonies + units
  on `AMER2.MP`; **click a unit** to select it and **click a tile** to send it (it routes
  around coastline over the next turns); **Found colony** turns a land unit into a colony;
  **End turn** runs `step_turn` once (colonies grow, immigration & the King's army accrue,
  prices drift). Backed by `POST /api/game/{new,step,order,found}`, `GET /api/game/state`.

- **Tables** — browse every `@`-section of the game data (NAMES.TXT) as a filterable grid
  (`GET /api/tables`). The table content the rest of the engine is driven by.
- **Logic** — the **visual node-graph editor** (Blueprint-inspired): drag nodes from the palette,
  wire pin→pin (exec = control flow, data = values), edit a node's params, and **Run** to fire the
  graph against the live game. Logic is built by connecting nodes, not by writing code. Node
  categories: Triggers, Flow (Branch/Roll/Sequence), Data (GetState/Math/Compare/Constant), Actions
  (GrantGold/SetTax/SetPrice/AddREF/SpawnUnit/StepTurn/…), Dialog (ShowPopup/Navigate). The six
  major event families ship as graphs (`data_extracted/engine/graphs/`): king's tax, founding
  father, lost city, native raid, immigration, declare independence.
- **Screens** — the **visual screen designer**: pick/new/save a screen, drag widgets (text /
  button / rect / sprite), edit them in the property panel, and a **State Inspector** that writes
  live game values (year/gold/tax/…) so the screen reacts. Text widgets interpolate `{binding}`
  tokens. **Preview** runs the screen with live buttons that fire their `onClick` node graph —
  which can mutate the game, pop a dialog, or **Navigate** to another screen.

These three tabs are the **game-development engine**: the game is data — node graphs (logic/events)
and screen definitions under `data_extracted/engine/` — that `forge.exe` both *runs* (the graph
interpreter + screen runtime + the sim) and *authors* (the editors). See
`data_extracted/engine/schemas.md`. Backed by `/api/{nodes,graphs,graph,graph/run,bind,bind/set,
screens,screen}`. (The browser UI is the verified host now; a native-GUI port reuses the same
C++ engine + JSON backend.)

The popup/toast/button UI layer (`ui.popup` / `ui.toast`, ESC- and click-outside-to-close)
is reusable across tabs — the interactive shell the full engine builds on.

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
| `formulas.{hpp,cpp}` | the complete formula/function catalog (Formulas tab + `forge formulas`) |
| `main.cpp` | the `forge` CLI |
| `gui/` | optional Dear ImGui desktop front-end (`-DFORGE_GUI=ON`; see `gui/README.md`) |

## What's data-driven vs code

The sim reads its balance numbers from a `RuleData` (units/terrain/scalars), whose
defaults are **value-identical** to the original (oracle: `tools/verify_rules.py`).
Formulas, enums (`NUNITTYPES=24`), and the fixed sprite atlas are code/art walls —
so the Forge is a **balance laboratory + content editor**, not an arbitrary
game-logic SDK. Edits are validated against the same `sim_tests`/`check_rules`
engine the clients run.
