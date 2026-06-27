# Colony screen — render test (the "ultimate test")

`tools/render_colony_screen.py` renders the colony screen **from the byte-verified spec layout +
the extracted game assets** (no game engine), and `colony_COMPARE.png` stacks it against the live
DOS capture (`11_colony_screen.png`, Jamestown).

## What reproduces (byte-verified spec → faithful render)
- **Title bar** "Jamestown. Spring, 1504. Gold: 1000e" — green FONTTINY, via the documented shared
  header (set_text_box mechanism); text/colour/position match.
- **Composite backdrop** — woodgrain chrome (WOODTILE) + parchment scene inset (PARCH 4,8,204,120)
  + COLONY.PIK band at y=128 — matches.
- **Bottom production band** (SoL panel, colonists, warehouse fence/barrels) — essentially
  pixel-accurate (it IS COLONY.PIK).
- **16-cell stockpile bar + Exit "E"** — `x=1+i·19`, icon `y=181`, ICONS frame `0x16+good` — correct.
- **Building plot positions** — the 15 `DS:0x266` plots (`func_02701C`), Jamestown's 8 buildings.

## Known gaps (each already documented in the spec — runtime/RNG, not unknowns)
- **Colony minimap** (top-right) — a separate composited element (colony-area minimap), not in the
  backdrop list; positions known (rect), content is the live surrounding tiles.
- **Building→sprite identity** — WHICH building fills each plot is RNG-driven (`func_025D34`, §12);
  the render uses placeholder `frame=plot-index`, so the *positions* are right but the *sprites* are
  not the real Jamestown buildings. (Mapping building-id → BUILDING.SS frame is the next step.)
- **Dynamic panel overlays** — live SoL% "100% (I)", "No Ships In Port", the worked-tile colonist
  sprites, the "(Outside Colony)" hover tooltip — all runtime game-state.

## Verdict
The spec drives a recognizable from-scratch colony screen: structure, composite, title, stockpile
bar, and plot positions all land. The residual is the documented runtime/RNG layer — confirming the
spec is rewrite-grade for the static screen and that the remaining work is wiring live state, not
discovering layout.
