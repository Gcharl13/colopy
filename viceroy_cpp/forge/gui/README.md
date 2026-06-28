# Viceroy Forge — desktop GUI (scaffold)

A Dear ImGui front-end over the tested Forge backend: the balance inspector
(`forge/inspect.hpp`), the rules-overlay loader + invariants
(`forge/rules_json.hpp`, `sim/rules_invariants.hpp`), and the map editor core
(`forge/mapedit.hpp`). All game logic, balance curves, validation, and `.MP`
read/write are reused verbatim — `forge_gui.cpp` only renders them.

## Status

This is a **scaffold**. It is built only when you opt in, because it pulls Dear
ImGui + GLFW over the network (FetchContent) and needs an OpenGL/GLFW dev
environment. It is **not** part of the default build or CI, and was authored in an
environment without GUI libraries or network access, so it has not been compiled
here — treat it as a starting point, not a verified binary. The non-GUI layers it
calls *are* covered by `sim_tests` / `forge map selftest` / `tools/verify_rules.py`.

## Build (locally, with network + OpenGL)

```bash
cmake -S viceroy_cpp -B build-gui -DCMAKE_BUILD_TYPE=Release -DFORGE_GUI=ON
cmake --build build-gui -j --target forge_gui
./build-gui/forge_gui
```

Requires: CMake ≥ 3.16, a C++17 compiler, OpenGL dev headers, and network access
for FetchContent (GLFW 3.4, Dear ImGui v1.91.5). On Linux you may also need the
usual X11/Wayland dev packages that GLFW links against.

## What it does

- **Rules Inspector** — load a `rules.json` overlay (or edit a few scalars live),
  see `check_rules` PASS/FAIL, and a table of balance curves vs the default
  ruleset with deltas.
- **Map Editor** — load/save a `.MP` (byte-faithful), paint terrain on a grid
  canvas with river/forest toggles, and run `validate` (Sea-Lane edge, id ranges,
  land/ocean-mass counts).

## Next steps for the GUI

- Data-table grid editor over `data_extracted/tables/*.json` (write sparse
  overlays via the rules_json writer once it exists).
- Live visual-diff preview by rendering a 320×200 screen via the existing
  `Surface`/`mapview` path into an ImGui image.
- Undo/redo and mod packaging (the `modinfo.json` overlay format).
