# Viceroy Forge — desktop GUI (scaffold)

A Dear ImGui + imnodes front-end over the tested Forge backend: the balance
inspector (`forge/inspect.hpp`), the rules-overlay loader + invariants
(`forge/rules_json.hpp`, `sim/rules_invariants.hpp`), the map editor core
(`forge/mapedit.hpp`), and **the data-driven game engine** (`forge/engine.hpp`) —
the same node catalog / graph interpreter / binding resolver the browser IDE uses,
here linked **in-process** (no HTTP). All game logic, balance curves, validation,
`.MP` I/O, and the engine VM are reused verbatim — `forge_gui.cpp` only renders them.

## Status

This is a **scaffold**. It is built only when you opt in, because it pulls Dear
ImGui + imnodes + GLFW over the network (FetchContent) and needs an OpenGL/GLFW dev
environment. It is **not** part of the default build or CI, and was authored in an
environment without GUI libraries or network access, so the **windowed binary has
not been compiled here** — treat it as a starting point, not a verified binary. The
**browser engine is the verified twin** to diff its behavior against.

What *is* checked here: the default (`-DFORGE_GUI=OFF`) CMake config still
configures + builds + passes `ctest`, and the GUI's non-ImGui engine logic
(`node_pins`/`attr_of` — which wire the graph into imnodes, including ShowPopup's
dynamic choice pins) was compiled standalone against the real engine headers and
run over all eight event graphs: every edge endpoint resolves to a real pin (0
unresolved). The deeper layers are covered by `sim_tests` / `forge engine selftest`
/ `forge map selftest` / `tools/verify_rules.py`.

## Build (locally, with network + OpenGL)

```bash
cmake -S viceroy_cpp -B build-gui -DCMAKE_BUILD_TYPE=Release -DFORGE_GUI=ON
cmake --build build-gui -j --target forge_gui
./build-gui/forge_gui
```

Requires: CMake ≥ 3.16, a C++17 compiler, OpenGL dev headers, and network access
for FetchContent (GLFW 3.4, Dear ImGui v1.91.5, imnodes v0.5). On Linux you may
also need the usual X11/Wayland dev packages that GLFW links against.

## What it does

- **Rules Inspector** — load a `rules.json` overlay (or edit a few scalars live),
  see `check_rules` PASS/FAIL, and a table of balance curves vs the default
  ruleset with deltas.
- **Map Editor** — load/save a `.MP` (byte-faithful), paint terrain on a grid
  canvas with river/forest toggles, and run `validate` (Sea-Lane edge, id ranges,
  land/ocean-mass counts).
- **Engine — Node Graph** — the in-process engine front-end: a node palette from
  `node_catalog()`, an **imnodes** canvas that lays out a loaded graph's nodes +
  wires (`load_graph`), a **Run** button that fires it against an in-process
  `GameState`/`World` via `run_graph`, a **Reset game** button, and a live bindings
  panel (`resolve_binding`) plus the last run's effects/log. Same engine as the
  browser; no HTTP.

## Next steps for the GUI

- Editing on the canvas (create/delete nodes + drag-to-wire) writing back to the
  graph JSON via `save_graph`; a per-node param panel.
- An ImGui screen-designer canvas (the browser's Screens tab) + a tables view.
- Live visual-diff preview by rendering a 320×200 screen via the existing
  `Surface`/`mapview` path into an ImGui image.
- Undo/redo and mod packaging (the `modinfo.json` overlay format).
