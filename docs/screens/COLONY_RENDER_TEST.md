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
- **16-cell stockpile bar** — `x=2+i·19`, icon `y=181`, **ssdec ICONS frame `0x16+good`** (=game
  `0x17+good` minus the ssdec off-by-one; Food=22, MSE-0 verified all 16) (was wrongly `0x17+good`,
  which shifted Food→Sugar) (corrected
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

## ✓ Matched pair captured — the snapshot DID match the screenshot (prior section retracted)
An earlier revision of this doc claimed the snapshot and `11_colony_screen.png` were *different
states* (fresh vs developed). **That was wrong** — see RULINGS 2026-06-27 (CORRECTION). I drove the
live game under DOSBox (loaded COLONY09.SAV → founded Jamestown → opened the colony screen) and
captured a matched pair:
- `docs/screens/colony_live_1505.png` (native 320×200 screenshot) + `scratchpad/dbx/colony_live_1505.bin`
  (RAM dump, regenerable).
- The live screen matches `11_colony_screen.png` at **MSE 312** (essentially identical — one turn
  apart, 1504 vs 1505).
- The live RAM is byte-equivalent to `colony_jamestown.bin`: same `cp=0x606E`, "Jamestown", pop 1,
  same `0x266` plot table, same `0x8E82` def-ids, same `DS:0x260=[45,44,43,0,46,0]`.

So the original snapshot + screenshot were **the same state** all along (a fresh pop-1 Jamestown).
The mistake: reading the on-screen **"100% (I)"** as Sons-of-Liberty membership. Byte-trace of
`sol_membership_pct @0x8524` gives `100·A/divisor` (A=u32@+0xC2, divisor=u32@+0xC6/+0xC8, +20 if
human-owned, cap 100) ⇒ **0%** for this colony — so "100%" is *not* SoL membership; its source is a
separate open item.

**Consequence:** the render's MSE gap is **decode quality** (building frames + dynamic overlays),
not state mismatch — and is now directly validatable against the matched live pair. The game's own
render of this exact RAM is MSE 312 from the reference; my from-scratch render is MSE ~3600, and that
whole gap is mine to close.

## Remaining decode gaps (now measurable against the matched pair)
- **Exact building→frame map** — `def_id` is not the frame index; spec's old `word[id*2+0x8DC8]`
  formula reads out-of-range vs the snapshot. Real frame is `func_026DD4`/`func_026CC2` multi-branch
  (default `def_id+1`, special-cases). Resolvable now by tracing AX at the `0x181F:0x254` blit in the
  live process.
- **Dynamic COLONY.PIK overlays** — the "100% (I)" panel value, "No Ships In Port", colonist row,
  boycott "✗" marks, right commodity column — runtime game-state, present in the matched RAM.

## Verdict
The static + per-colony-data layer is byte-true: palette (stride-3), stockpile icons
(ICONS.SS `0x17+good`), plot positions, and empty-plot terrain all land. With a **matched
screenshot+RAM pair** now in hand (game-own render = MSE 312 from the reference), the remaining
~3600 MSE is entirely my decode imperfection (building frames + dynamic overlays) — measurable and
non-fabricated, no longer confounded by any state question.
