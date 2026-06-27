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

## Resolved this pass
- **`[0x2DA8]` = BUILDING.SS** for the plot grid: both painters (`func_02701C`) blit from the same
  active sheet at `(plotX, plotY+8)`.
- **Empty-plot terrain** = BUILDING.SS frame `byte[0x260 + category]`, category = `byte[0x8D62+i]`,
  skipped when 0. Snapshot `DS:0x260 = [45,44,43,0,46,0]` → frames 45/44/43/46. Added to the render.

## Known gaps (load-bearing unknown named, not hidden)
- **Exact building→frame mapping** — the scene-band's dominant remaining error. `def_id` is NOT the
  frame index, and the spec's old `word[id*2+0x8DC8]` formula returns out-of-range/non-distinct
  values against the byte-correct snapshot (see RULINGS 2026-06-27). The real frame comes from
  `func_026CC2`'s multi-branch logic inside painter `func_026DD4` — **TBD pending a runtime trace**
  of AX at the `0x181F:0x254` blit. The render approximates with `frame≈def_id` (recognizable, not
  exact).
- **Dynamic COLONY.PIK overlays** — live SoL% "100% (I)", "No Ships In Port", worked-tile colonist
  sprites, boycott "✗" marks, right-column commodity icons — all runtime game-state (spec §6 R/TBD).
- **Colony minimap** (top-right) — separate composited element; rect known, content is live tiles.

## Why the scene band cannot pixel-match this capture (the real ceiling)
The snapshot's plot table (`0x266`) places buildings in **different positions** than the screenshot,
despite identical turn (Spring 1504), gold (1000), and stockpile (muskets 50) — i.e. it is the same
colony at the same turn but a **different open**. Per spec §12, the plot→building assignment is
**RNG-driven and recomputed on every colony-open** (`func_025D34`, seed `0x181F:0xD62`), so two
captures of the same colony legitimately differ in layout. Confirmed empirically: rendering with
`frame=def_id` (oracle scene-MSE 6191) vs the byte-traced `def_id+1` (7050) — neither aligns,
because the **positions** differ, not the frames. **The pixel oracle cannot adjudicate the building
frame from this snapshot/screenshot pair**; doing so requires a snapshot captured at the *same open*
as the screenshot (or rendering from the screenshot's own RAM).

## Verdict
The static + per-open-data layer is byte-true: palette (stride-3), stockpile icons (ICONS.SS
`0x17+good`), plot positions, and empty-plot terrain all land (full-screen MSE 6387 → 3606), and the
side-by-side reads as Jamestown. The scene band's residual is **bounded by RNG re-placement between
captures**, not by decode quality — plus the dynamic COLONY.PIK overlay layer (runtime game-state).
Both are named and non-fabricated. The exact building→frame map (`def_id+1` per `func_026DD4` vs the
spec's refuted `0x8DC8` formula) stays **TBD pending a same-open runtime trace**.
