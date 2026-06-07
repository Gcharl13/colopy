# Visual Verification Methodology

The strategic pivot from per-line .asm annotation to **visual-output
verification** is the central methodology of the project's completion
phase. This doc captures how it works.

---

## Core principle

Per-line annotation produces a comment count, which is a proxy for
correctness. **Pixel-matched visual output is direct evidence**. If
a render program produces output indistinguishable from a DOSBox
gameplay screenshot, that subsystem is correct — regardless of
whether each individual instruction is annotated.

---

## What gets verified visually

| Subsystem | Verification |
|-----------|-------------|
| `.MP` map decode | `render_map_v2.py` produces correct continental outlines (BYTE_VERIFIED — Americas continents recognizable) |
| `.PIK` background loading | `render_screen.py` outputs match DOSBox screenshots for 29/30 known screens |
| Tile sprite mapping | render_gameplay map tiles match DOSBox; per-terrain forest/mountain/river overlays |
| Unit/ship rendering | `render_gameplay.py` map_units overlay places ICONS sprites at correct screen positions |
| Commodity inventory | render_colony 16-cell bar matches DOSBox (each icon, each quantity) |
| HUD chrome (top bar + sidebar) | render_gameplay structural composition matches user reference |
| Dialog overlays | render_gameplay --dialog produces bottom-overlay popups |
| Game-formula logic | `simulate_formulas.py` produces values matching DOSBox-observed gameplay |
| RNG | `simulate_rng.py` matches DOSBox-captured sequences with same seed |

---

## Verification programs

### `tools/render_map_v2.py` — Low-fi map render

Pure terrain-color render of any .MP file. Solid colors per terrain ID
using the BYTE_VERIFIED `TERRAIN_PAL_INDEX` mapping. Output looks
like a Civilization-style minimap.

Verifies: .MP decode, terrain ID → palette index lookup,
VICEROY.PAL load.

### `tools/render_gameplay.py` — Full gameplay screen

Composite of: top menu bar + map view (with unit overlays + cursor) +
right sidebar (with minimap + mixed-case status text). Matches the
DOSBox gameplay screen layout structurally.

Verifies: HUD layout, font selection (FONTKING for sidebar / FONTSMAL
for menu), text rendering with proper case + punctuation, ICONS sprite
overlay at map coordinates.

### `tools/render_colony.py` — Colony screen (e.g. Baltimore)

Full colony screen composition matching DOSBox layout:
- Title bar with name/season/year/treasury
- Top-left colony view with buildings + colonists
- Top-right 3×3 production grid with yields
- Middle band with SoL bars + ships panel + workers
- Bottom 16-cell commodity inventory (BYTE_VERIFIED icon mapping)
- Right wood-grain panel with EXIT button

Verifies: building placement, production yield display, commodity
icon mapping, colony screen structure.

### `tools/render_screen.py` — Per-screen background renders

Loads each .PIK background and produces a PNG. 29 of 30 screens
render correctly; COLONY.PIK has an mpskit decode quirk. Each
verifies that the .PIK extraction worked end-to-end.

### `tools/render_dialog.py` — Dialog overlays (deprecated)

The original full-screen dialog renderer was wrong (treated dialogs
as full-screen replacements). The dialog overlay is now done by
`render_gameplay.py --dialog <name>` as a bottom-screen overlay.

### `tools/simulate_formulas.py` — Game-formula simulators

Runs the BYTE_VERIFIED game-system formulas with sample inputs:
- Native village raze (CHIEFKILL): `gold = sum_3 × roll_4 × 4 × (size+1)`
- Diplomatic SMITE: `clamp(player_factor × treasury / 2500, 10, 200) × 50`
- King tax raise: `((diff & 0xFE) × 2 + 4) × ((turn / 400) + 1)`
- Combat demotion ladder: 5 unit-type → demoted-type rules

Outputs a table of (input, output) pairs that should match DOSBox
gameplay observations.

### `tools/simulate_rng.py` — LCG simulation

Runs the MSC 6.0 standard rand() with the BYTE_VERIFIED constants
(0x000343FD multiplier, 0x269EC3 increment) starting from a given
seed. The output sequence should byte-match what VICEROY.EXE
generates given the same seed (verifiable via DOSBox debugger or by
deterministic gameplay actions).

---

## Sprite identification methodology

To identify which sprite-index corresponds to which game element:

1. **Generate contact sheet** via `tools/sprite_contact_sheet.py
   --sheet <NAME>`. Output: a labeled grid of all sprites in the sheet.
2. **Visual inspection** of the contact sheet identifies broad
   categories (commodities at indices N..M, unit sprites at indices
   X..Y, etc.).
3. **Per-sprite verification** by loading individual PNGs at native
   size for ambiguous cases.
4. **Document in `assets/sprites/SPRITE_INDEX.md`** as BYTE_VERIFIED
   once the role is confirmed.

This produces a catalog of (sheet, frame_index, role) triples that
the renderers consume.

---

## Asset identification status (after this session)

### BYTE_VERIFIED sprite roles

- ICONS 022-037: 16 commodity icons (food, sugar, tobacco, cotton,
  fur, lumber, ore, silver, horses, rum, cigars, cloth, coats, trade
  goods, tools, muskets) — confirmed via labeled grid output.
- ICONS 015: Caravel ship sprite — confirmed.
- ICONS 100, 103, 108: Continental Army Soldier, Dragoon, Native
  warrior — confirmed by visual inspection.
- ICONS 0-3, 12-13: Native village variants.

### Identified but not pixel-verified

- BUILDING.SS: 48 sprites cataloged with sizes; per-building role
  inferred from visual inspection but not yet matched against
  DOSBox colony screenshots.
- PHYS0.SS: layout categorized (water/coast 0-15, mountain 16-47,
  forest 48-79, etc.) but per-sprite terrain mapping not yet pinned
  for transition tiles.

### Still TBD

- Per-tile rendering with neighbor-aware transitions (this requires
  decoding the render-chain function `func_O514` → `O513` → `O512`
  in VICEROY).
- Per-terrain `(terrain_id, neighbor_pattern) → sprite_index`
  lookup table.
- Color-cycling water animation (gated on CYCLE.DAT decoding +
  cycle-tick function annotation).
- Large dialog portrait sprite (the Continental Army Soldier in the
  user's Cherokee dialog is NOT in any extracted .SS sheet — likely
  embedded in code or in an overlay-page-resident sheet).

---

## Iteration cycle

1. Look at DOSBox screenshot of subsystem X.
2. Run my render program for X.
3. Diff visually (or via `tools/visual_diff.py` for pixel comparison
   when available).
4. Identify gaps (missing sprite, wrong index, wrong color).
5. Fix the renderer or the sprite-index mapping.
6. Repeat until pixel-identical.
7. Mark subsystem BYTE_VERIFIED in this doc.

This is faster than .asm annotation because:
- The feedback loop is **seconds** (re-run the renderer) instead of
  hours (decompile next function).
- Each gap is a **specific lookup change** (one entry in the
  sprite-index dict), not a per-instruction annotation.
- The output is **directly comparable** to DOSBox — no interpretation
  needed.

---

## Output catalog

| Verification target | Render program | Reference |
|---------------------|----------------|-----------|
| Map (Americas continents) | `render_map_v2.py` | `assets/maps/AMER2_render_v2.png` |
| Map (16px detail) | `render_map_v2.py --tile-size 16` | `assets/maps/AMER2_render_v2_16px.png` |
| Gameplay screen | `render_gameplay.py` | `verification/gameplay/gameplay.png` |
| Cherokee attack dialog | `render_gameplay.py --dialog cherokee_attack` | `verification/gameplay/gameplay.png` |
| Baltimore colony screen | `render_colony.py` | `verification/screens/colony_baltimore.png` |
| 29 background screens | `render_screen.py --all-screens` | `verification/screens/<name>.png` |
| Commodity icons | (in render_colony) | `verification/icons_22_37.png` |
| Unit icons | (in render_gameplay) | `verification/icons_units_95_130.png` |
| Top icons (ships/villages) | (in render_gameplay) | `verification/icons_0_20.png` |
| Building sprites | (in render_colony) | `verification/buildings_labeled.png` |
| Game-formula table | `simulate_formulas.py` | stdout |
| RNG sequence | `simulate_rng.py` | stdout |

The `verification/dosbox_screenshots/` directory holds the reference
DOSBox captures (currently only descriptions in REFERENCE_NOTES.md;
captures themselves to be added by the user).
