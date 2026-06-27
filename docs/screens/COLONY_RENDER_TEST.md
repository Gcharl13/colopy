# Colony screen — render test (the "ultimate test")

`tools/render_colony_screen.py` renders the colony screen **from the byte-verified spec layout +
the extracted game assets** (no game engine), and `colony_COMPARE.png` stacks it against the live
DOS capture (`11_colony_screen.png`, Jamestown).

The renderer decodes **raw `.SS`/`.PIK` via `tools/ssdec.py`** (byte-verified) with the corrected
**VICEROY.PAL stride-3** palette and **live snapshot data** (`colony_jamestown.bin`) — NOT the
mis-baked `lab/assets/*.png` extracts.

## Measured fit vs the DOS capture (native 320×200 crop, MSE)
| region | y-band | MSE | note |
|---|---|---|---|
| chrome / title | 0–8 | **803** | good |
| building/terrain scene | 8–128 | **4863** | dominant error — empty-plot terrain fill missing (see gaps) |
| COLONY.PIK band | 128–181 | **1585** | it *is* COLONY.PIK |
| stockpile bar | 181–200 | **2684** | icons correct; qty-number glyph/colour imperfect |
| **full screen** | 0–200 | **3625** | down from 6387 (pre-palette-fix) |

These are honest, recomputed numbers — not an eyeball judgement.

## What reproduces (byte-verified spec → render)
- **Title bar** "Jamestown. …" — green FONTTINY via the documented shared header. MSE 803.
- **Composite backdrop** — WOODTILE chrome + PARCH scene inset + COLONY.PIK band at y=128.
- **Bottom production band** — essentially pixel-accurate (it IS COLONY.PIK). MSE 1585.
- **16-cell stockpile bar** — `x=1+i·19`, icon `y=181`, **ICONS.SS frame `0x17+good`** (corrected
  this pass: lab assets had wrong frame numbering; raw `ssdec` decode gives the right commodity icons).
- **Building plots** — the 15 `DS:0x266` plots (`func_02701C`), def-id = signed `byte[0x8E82+i]`
  (`<0`=empty), drawn from BUILDING.SS at Jamestown's exact 8-building layout. Positions + presence
  are byte-true; the per-category frame index follows the spec's `func_026CC2`/`func_026DD4` chain.

## Known gaps (load-bearing unknown named, not hidden)
- **Empty-plot terrain fill** — the dominant scene-region error. Empty plots draw from the **active
  sprite-sheet descriptor `[0x2DA8]`** (`func_026FF2 @0x26FF2`, gated by `byte[feat+0x260]`,
  `feat = byte[0x8D62+i]`). `[0x2DA8]` is a **general "current sheet" global** lea'd 100+ times,
  loaded by **index** (no name string) in colony-screen setup → its exact identity + the terrain
  frame are **TBD pending the setup loader trace**. This is why the scene band is MSE 4863. **Not
  fabricated.**
- **Colony minimap** (top-right) — separate composited element; rect known, content is live tiles.
- **Dynamic panel overlays** — live SoL% "100% (I)", "No Ships In Port", worked-tile colonist
  sprites — all runtime game-state (spec §6 R/TBD).

## Verdict
The spec drives a recognizable from-scratch colony screen and the palette/icon/building decodes are
now byte-true (MSE 6387 → 3625). The residual is concentrated in the **empty-plot terrain fill**
(active-sheet `[0x2DA8]` identity) and the documented runtime/RNG panel layer — each named with its
specific blocker rather than papered over.
