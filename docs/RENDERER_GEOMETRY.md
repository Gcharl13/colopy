# Renderer Geometry Spec

Byte-cited pixel coordinates and source addresses for every UI
element observed in session frames. Created 2026-05-05 to consolidate
findings from `SESSION_UI_CATALOG.md` into actionable renderer specs.

All coordinates are in NATIVE 320×200 mode 13h pixels (the renderer
should compose at this resolution and scale up).

---

## Updates 2026-05-08 — overlay-verified geometry

The following coordinates were verified against captured frames using
`tools/overlay_ui_regions.py` (which renders predicted regions over
actual screen captures). Several v1 coordinates required correction.

### Atom sizes (the renderer's building blocks)

| Atom | Size | Verified from |
|------|-----:|---------------|
| Map tile (PHYS0/TERRAIN) | **16×16** | tile renderer (15×12 closest-zoom viewport) |
| Unit/commodity sprite (ICONS) | **16×16** | ICONS.SS rows |
| Small font glyph (FONTSMAL) | **6×8** | UI text |
| Tiny font glyph (FONTTINY) | **5×6** | densest text |
| King font glyph (FONTKING) | **8×16** | parchment / king title |

### Three layout regimes coexist on the 320×200 canvas

1. **Tile-grid** (16-px aligned) — map view, mini-map, colony scene
2. **Sprite-bbox** (variable, content-driven) — ship docks, REF groups, FF portraits
3. **Glyph-grid** (~6-8 px) — top menu, popup text, FF list, button labels

The renderer dispatches to a different layout system per screen region.
The map viewport is the only region that uses pure 16-px tile-grid.

---

## Map view (gameplay — frame 1310262984) — VERIFIED v2

**Closest-zoom viewport math**: 15×12 tiles × 16×16 px = 240×192 px.

| Region | Pixel rect | Notes |
|--------|------------|-------|
| Top menu strip | (0, 0, 320, 14) | glyph-grid; labels GAME/VIEW/ORDERS/REPORTS/TRADE/CHEAT/COLONIZOPEDIA |
| Map viewport (visible) | (0, 14, 240, 186) | 15-tile-wide × ~11.6 tile-tall visible (12th tile row partially clipped by menu bar) |
| Sidebar A — minimap | (240, 14, 80, 58) | 58×72 world squashed into ≈80×58 |
| Sidebar B — gold/year/tax | (240, 72, 80, 64) | "Spring 1544 / Gold: 1920 / Tax: 0%" lines |
| Sidebar C — selected unit panel | (240, 136, 80, 64) | "Locat: (40, 46) / x4 Eng. Scouts / Expert / No Orders / (Tropical Forest)" |

**Correction from v1**: the map viewport was claimed to start at y=8.
Verified at y=14. Sidebar B/C order was inverted in v1 (gold/year is in
the upper sub-panel, not the lower).

---

## Colony screen (Plymouth — frame 1310196718) — VERIFIED v3

**Frame-verified 2026-05-20** via luma-edge analysis of
`reverse_engineered/session_1777952458/frames/1310196718000000.webp`.
See `tools/measure_colony_bands.py` and `tools/measure_colony_xbands.py`
for the measurement scripts. v2 entries had the title bar 4 px too
tall and the middle band misnamed "Colonist row" at 26 px when it's
actually 50 px tall and contains 4 sub-panels.

**Layered render**: the colony scene + 8 surrounding tile workers
are rendered as a unified scene at x=0..256, NOT as separable regions.
The 256..320 strip on the right shows the **surrounding-tiles minimap**
(8 tiles around the colony center with workers/yields), not an
"active building scene" as v2 claimed.

### Outer bands (y-axis)

| Region | Pixel rect | Notes |
|--------|------------|-------|
| Title bar | (0, 0, 320, 8) | "Plymouth.  Spring, 1543.  Gold: 1920" — FONTSMAL green over WOODTILE strip |
| Colony scene | (0, 8, 199, 120) | beige sand background with buildings/colonists/trees — verify x=199 boundary with luma edge analysis (`tools/measure_colony_x_split.py`) |
| Wood frame separator | (199, 8, 25, 120) | vertical dark wood strip between colony scene and minimap |
| Surrounding-tiles minimap | (224, 8, 72, 120) | 3-wide tile grid (24 px tile width) of immediate-neighbor tiles with worker sprites |
| Wood frame right border | (296, 8, 24, 120) | right edge wood-panel trim |
| Middle band | (0, 128, 320, 50) | SoL + colonists + ships + cargo + build progress + Exit — see sub-panels |
| Stockpile strip | (8, 178, 304, 22) | 16 commodity cells × 19 px stride; left margin 8 px |
| Stockpile cell N | (8 + N×19, 178, 19, 22) | for N in 0..15 |

### Middle band sub-panels (x-axis, all at y=128..178)

| Sub-panel | Pixel rect | Notes |
|-----------|------------|-------|
| Left (SoL + colonists) | (0, 128, 120, 50) | flag + "%loyal (count)" SoL stats + idle colonist sprites + profession icons |
| Center (ships) | (120, 128, 86, 50) | "Loading: \<ShipName\>" + selected ship sprite on water |
| Right (cargo + build) | (206, 128, 97, 50) | cargo barrels + in-progress build sprite + 3 trade-good icons |
| Exit button | (303, 128, 17, 50) | red "Exit" text vertically stacked |

**Corrections from v2**:
- Title bar height 12 → 8 (off by 4 px)
- Colony scene 12..152 → 8..128 (shifted up by 4, shorter by 16)
- "Colonist row" 152..178 (26 px) → "Middle band" 128..178 (50 px) — was missing 24 px and mislabeled
- "Buildings panel" → "Surrounding-tiles minimap" (correct rect, wrong name)
- Added middle-band sub-panel boundaries at x=120, x=206, x=303
- **2026-05-21 (b)**: colony scene x-width 256 → 199 (off by 57 px!).
  Luma edge at x=199 has Δ=217 — the strongest x-edge in the band.
  Between x=199..224 is a black wood-frame separator; the surrounding-
  tiles minimap actually starts at x=224 (not 256) and is 72 px wide
  (3 tile columns × 24 px). Right-edge wood trim at x=296..320.

### Plymouth-specific building inventory (frame 1310196718)

Approximate positions in the colony scene (0..199, 8..128) catalogued
by visual inspection of `build/plymouth_scene_grid.png`. These are
the positions in DOS — to be matched against BUILDING.SS sprite
indices and verified via in-game state.

| # | Element | Approx (x, y) | BUILDING.SS idx (visual match against build/building_atlas.png) |
|---|---------|--------------:|----------------------|
| 1 | Pavilion / open-roof building | (5, 18) | **006 or 007** (75×48 large multi-roof with trees) |
| 2 | Thatched-roof barn (yellow roof) | (50, 35) | **015** (44×22 with yellow thatch) |
| 3 | Trees cluster (top row) | (35, 15), (70, 15), (135, 15), (170, 15) | **048 or 049** (tree-only background sprites) |
| 4 | Stockade with crates above (warehouse?) | (40, 60) | **000/001** (73×18 wooden fence with crates) |
| 5 | Free Colonist sprite | (55, 80) | ICONS.SS ~95 (Free Colonist) |
| 6 | Small house | (85, 75) | **022/023** (23×27 single-story dwelling) |
| 7 | 2-story house | (118, 75) | **025-029** (23×27 multi-story dwelling) |
| 8 | Stone colonial building (Town Hall) | (80, 100) | **038-040** (53×37 large colonial) |
| 9 | Conquistador with flag | (102, 110) | ICONS.SS conquistador sprite |
| 10 | Fence + "(Outside Colony)" sign | (155, 110) | **016** (73×18 wooden fence) + text label overlay |
| 11 | Water/river feature | (180, 95) | TERRAIN water tile |
| 12 | Trees scattered (decorative) | various | **048/049** or TERRAIN-style trees, possibly RNG-placed |

**Notes on BUILDING.SS atlas:**
- 50 sprite slots; **042 are real buildings**; slots 010, 011, 017, 024, 030, 031, 036 are 1×1 placeholders (do not render)
- Sprites 000-002, 016 are long fence segments (73×18) — used for stockade walls
- Sprites 003-005, 012-015, 035-036, 041-043, 046-047 are mid-size (44×22)
- Sprites 006-009, 037-038, 042, 045 are large (53×37 to 75×48) — town hall, church, gazebo
- Sprites 018-029, 032-034, 039-040, 044 are 23×27 dwellings (most common building type)
- Some sprites are NEAR-DUPLICATES (e.g. 003 vs 004 vs 005) — likely different upgrade tiers
  or animation states of the same logical building

**Plymouth-specific palette of building sprites (17 buildings constructed):**
Plymouth has 17 of 42 possible buildings built. The bitmask at
ColonyRecord +0x60..+0x65 (48 bits) marks which @BUILDING index is
constructed. The colony scene draws each constructed building at
its assigned (x, y). For 99.4% pixel match we need:

1. Map building bitmask → BUILDING.SS sprite index
2. Map BUILDING.SS sprite index → fixed (x, y) in 0..199 × 8..128 scene
3. Place each colonist (5 of them in Plymouth) at their assigned position

(2) is the key open question — trace VICEROY's colony-scene draw in
disasm to find the position lookup table.

**Open question for state-faithful render**:
- Are building positions FIXED per building type, or RNG-seeded per colony?
- Trees + decorative elements likely deterministic-RNG from colony's
  (map_x, map_y) — needs disasm trace of colony-scene draw.
- Colonist positions tied to colonist record assignments.

---

## Europe screen (frame 1310291187) — VERIFIED v3

**Frame-verified 2026-05-21** via `tools/measure_screen_bands.py`.
Y-band edges from luma analysis: y=8, 45, 135?, 168?, 179.

### Outer bands

| Region | Pixel rect | Notes |
|--------|------------|-------|
| Title bar | (0, 0, 320, 8) | "Selling \<Cargo\> at \<N\> Gold: (\<gold\>¢)" — same height as colony |
| Trade transaction panel | (0, 8, 320, 37) | "Sold N X at Y¢/ton / Price / Tax / Net" multi-line breakdown over parchment |
| Dock + ships scene | (0, 45, 270, 90) | sky + grass + water + dock with ships, EXPECTED/BOUND/LOADING panels at y=118 |
| Right button column | (270, 45, 50, 130) | wood-panel + RECRUIT/PURCHASE/TRAIN buttons |
| Stockpile strip | (8, 179, 304, 21) | 16 cells × 19 px stride (1 px taller than colony's 22 — VERIFY) |
| Exit button | (303, ~190, 17, 10) | small red "E" |

### Edges from luma analysis

| Edge | y | strength |
|------|---|----------|
| Title/transaction | 7→8 | 71.7 / 164.8 |
| Transaction/dock | 45→46 | 52.2 / 52.1 |
| Stockpile top | 178→179 | 110.8 / 132.8 |
| Bottom edge | 199 | 129.4 |

**Old v2 entries (lines below) had:** trade banner = 0..12 (off by 4),
Expected Soon panel y=118 (probably right, verify against grass-edge),
EXIT button (305, 193, 15, 7) — verify against y=179 stockpile top.

---

## Europe screen — v2 (deprecated, see v3 above)

| Region | Pixel rect | Notes |
|--------|------------|-------|
| Trade banner | (0, 0, 320, 12) | "Selling Sugar at 1632 Gold: (1920¢)" |
| **Transaction dialog** (NEW) | (130, 18, 180, 56) | "Sold N X at Y¢/ton / Price / Tax / Net" — appears after sell |
| Expected Soon panel | (0, 118, 115, 14) | sprite-bbox |
| Bound For panel | (115, 118, 100, 14) | sprite-bbox |
| Loading panel | (215, 118, 105, 14) | sprite-bbox |
| RECRUIT button | (273, 144, 40, 14) | glyph-aligned |
| PURCHASE button | (273, 160, 40, 14) | glyph-aligned (stride 16 — corrected from v1's 14) |
| TRAIN button | (273, 176, 40, 14) | glyph-aligned |
| EXIT button | (305, 193, 15, 7) | small red E |
| Stockpile strip | (8, 180, 304, 20) | same format as colony |

**New finding**: the transaction dialog at (130, 18, 180, 56) was not
documented in v1. It's a content-driven popup that appears after each
sell action, showing breakdown of gross/tax/net.

---

## Continental Congress (frame 1310124562) — VERIFIED v3

**Frame-verified 2026-05-21** via `tools/measure_screen_bands.py`.
Y-band edges from luma analysis: y=10, 30, 36, 44, 76, 116.

### Outer bands (revised)

| Region | Pixel rect | Notes |
|--------|------------|-------|
| Title | (0, 0, 320, 10) | "CONTINENTAL CONGRESS ACTIVITIES" — 10 px (not 12) |
| Session subtitle | (0, 10, 320, 20) | "Next Continental Congress Session: (\<FF\>)..." 2-line text band |
| Progress bar | (0, 30, 320, 6) | yellow-fill bar showing bells_toward_next_ff / cost |
| Sentiment strip | (0, 36, 320, 8) | "Rebel Sentiment: X%   Tory Sentiment: Y%" |
| Bell icons row | (0, 44, 320, 32) | bell sprites + progress indicators |
| REF / FF list | (0, 76, 320, 40) | 4 REF unit groups + Founding Fathers names |
| Founding Fathers list | (0, 116, 320, 60) | scrollable FF names |
| OK button | (290, 184, 26, 14) | bottom-right |

Old v2 had vertical positions ~6 px off uniformly. Title was 12 (now 10).

---

## Continental Congress — v2 (deprecated, see v3 above)

All vertical positions in v1 were ~10 px too low. Corrected:

| Region | Pixel rect | Notes |
|--------|------------|-------|
| Title | (0, 0, 320, 12) | "CONTINENTAL CONGRESS ACTIVITIES" |
| Subtitle | (0, 14, 320, 8) | "1st Continental Congress Session: (William Brewster) (30 in 129)" |
| Progress bar | (4, 22, 312, 6) | yellow fill = bells_toward_next_ff / cost |
| Rebel Sentiment label+value | (4, 32, 100, 10) | "Rebel Sentiment: 13%" |
| Tory Sentiment label+value | (180, 32, 100, 10) | "Tory Sentiment: 87%" |
| Bell icons row | (20, 42, 280, 16) | sprite-bbox; stride 18 (= 16 sprite + 2 gap) |
| Expeditionary Force header | (4, 60, 200, 10) | "English Expeditionary Force:" |
| REF Reg (Foot) group | (4, 72, 80, 28) | sprite-bbox + count |
| REF Cav (Dragoon) group | (85, 72, 80, 28) | sprite-bbox + count |
| REF Art group | (160, 72, 80, 28) | sprite-bbox + count |
| REF MoW group | (235, 72, 80, 28) | sprite-bbox + count |
| Founding Fathers header | (4, 110, 200, 10) | "Founding Fathers" |
| FF list | (4, 122, 312, 60) | 12-px stride per name |
| OK button | (290, 184, 26, 14) | bottom-right |

---

## Popup framework — TWO CLASSES IDENTIFIED v2

The dialog framework supports two popup geometries depending on
content:

### Class 1: Banner popup (single-line message)

Examples: PRICEDOWN, PRICEUP, CHIEFKILL gold notification.

| Region | Pixel rect | Notes |
|--------|------------|-------|
| Speaker sprite (MSS/MYR) | ~(120, 30, 80, 80) | drawn ABOVE banner; extends into map view |
| Banner | (4, 110, 218, 38) | text-only, no embedded sprite |

### Class 2: Warning popup with response choices (multi-line)

Examples: SEACOLONY (NOOCEAN), foreign-colony hover with action choices.

| Region | Pixel rect | Notes |
|--------|------------|-------|
| Speaker sprite | ~(130, 20, 80, 100) | larger speaker, extends further up |
| Warning popup | (4, 124, 218, 70) | multi-line text |
| Choice 1 | (8, 168, 210, 10) | first response option |
| Choice 2 | (8, 180, 210, 10) | second response option |

**Key correction from v1**: speaker sprites are NOT inside the popup
banner — they are a separate render layer drawn ABOVE the banner,
overlapping the map view. The popup banner contains only text.

---

## Naval Adviser Report (frame 1310166171) — NEW v3

**Frame-verified 2026-05-21** via `tools/measure_screen_bands.py`.
Y-band edges from luma analysis: y=40, 60, 80, 100, 121, 140, 161.
A regular 20-px row grid — this is a TABLE layout.

| Region | Pixel rect | Notes |
|--------|------------|-------|
| Title | (0, ~6, 320, 14) | "NAVAL ADVISER REPORT" centered |
| Table header row | (0, 20, 320, 20) | "Ship  Cargo  Location  Destination" column labels |
| Table row 0 | (0, 40, 320, 20) | first ship entry |
| Table row 1 | (0, 60, 320, 20) | row stride = 20 px |
| Table row 2 | (0, 80, 320, 20) |  |
| Table row 3 | (0, 100, 320, 20) |  |
| Table row 4 | (0, 121, 320, 19) | (1 px off from 20-stride, verify) |
| Table row 5 | (0, 140, 320, 21) |  |
| Table row 6 | (0, 161, 320, 19) |  |
| OK button | (~280, 184, 30, 14) | bottom-right |

Background = parchment + decorative caravel ship watermark.
Table grid lines = dark red horizontal rules between rows.

---

## Map view (gameplay — frame 1310262984) — REVISED v3

Y-edges at y=7→8 (title bar bottom) confirm v2's "top menu strip
(0, 0, 320, 14)" was 6 px too tall. The actual top menu is **8 px**
high, matching colony/europe.

Updated: top menu (0, 0, 320, 8). Map viewport begins at y=8, not y=14.

Other edges weaker — y=49 visible (could be a UI band) but
mostly map content. v2's sidebar geometry probably still correct.

---

## Verification methodology

Each region in this section was visually verified by overlaying the
predicted rectangle on the captured frame using
`tools/overlay_ui_regions.py`. Output overlays are saved to
`verification/ui_overlays/*_overlay.png`. Re-run the script after any
geometry change to re-verify.

---

## Continental Congress Activities (frame 1310124562)

**Background**: `CCBKGD.PIK` (320×200, full screen)

### Layout (estimated from frame, scaled from 1280×800 → 320×200)

| Element | Position (native px) | Source data |
|---------|---------------------|-------------|
| Title "CONTINENTAL CONGRESS ACTIVITIES" | centered, y=4 | LABELS.TXT @MISC line 52 |
| Title font | FONTKING (yellow) | — |
| Body font | FONTSMAL (yellow on title strip / green on body) | — |
| "Next Continental Congress Session:" label | x=4, y=18 | LABELS.TXT @MISC line 127 |
| FF name `(William Brewster)` | x=140, y=18 | NAMES.TXT @FATHERS[20] |
| Progress text `(30 in 129)` | x=210, y=18 | computed from PowerRecord +0x0C |
| Progress bar | x=4..316, y=30, h=4 | progress=30/129 |
| Bar fill color | yellow (200, 160, 24) | — |
| "Rebel Sentiment:" label | x=4, y=46 | LABELS.TXT @MISC lines 84,86 |
| Rebel pct text | x=80, y=46 | PowerRecord +0x02 byte |
| "Tory Sentiment:" label | x=130, y=46 | LABELS.TXT @MISC lines 85,86 |
| Tory pct text | x=205, y=46 | derived = 100 − Rebel |
| US flag sprite | x=4, y=58 | (small flag — needs identification) |
| Bell sprite array | x=20, y=58, stride=18px | repeat for `bells_per_turn` (PowerRecord +0x0E) |
| "English Expeditionary Force:" label | x=4, y=80 | "Expeditionary Force" from LABELS @MISC line 100 + nation prefix |
| REF Regulars sprite group | x=4, y=92 | DGROUP:0x53DA (count) |
| REF Cavalry sprite group | x=85, y=92 | DGROUP:0x53DC |
| REF Artillery sprite group | x=160, y=92 | DGROUP:0x53E0 (slot 3 not 2!) |
| REF Man-O-War sprite group | x=235, y=92 | DGROUP:0x53DE (slot 2 not 3!) |
| Each REF group: count badge top-left | offset (0, 0) of group | u16 from DGROUP |
| Each REF group: 3-5 small unit sprites in row | offset (8, 4) | repeat sprite for visual fill |
| "Founding Fathers:" label | x=4, y=140 | LABELS.TXT @MISC line 104 |
| FF list (one per line) | x=4, y=150+12n | iterate names from acquired-FF bitmask |
| OK button | x=296, y=180 | LABELS.TXT @MISC line 61 "OK" |

### Memory state → CC display mapping (BYTE-VERIFIED)

```python
# Pseudo-code for renderer (CORRECTED 2026-05-05)
state = {
    "next_ff_idx": find_next_ff(),   # walk @FATHERS by category
    "next_ff_name": NAMES_TXT.fathers[next_ff_idx],
    "next_ff_threshold": compute_ff_cost(next_ff_idx, era),
    # +0x0C is "bells toward CURRENT next FF" (resets on acquisition)
    "bells_current": PowerRecord[+0x0C],
    "progress_remaining": next_ff_threshold - PowerRecord[+0x0C],
    "rebel_pct": PowerRecord[+0x02],
    "tory_pct": 100 - PowerRecord[+0x02],
    "bells_per_turn": PowerRecord[+0x0E],
    "ref_regulars": DGROUP[0x53DA],
    "ref_cavalry":  DGROUP[0x53DC],
    "ref_mow":      DGROUP[0x53DE],
    "ref_artillery": DGROUP[0x53E0],
    "ff_count": PowerRecord[+0x14],
    "acquired_ff_bitmask": PowerRecord[+0x07],  # u32 — bit i = FF idx i acquired
}
```

### Display formula

The screen text "(NN in MM)" displays:
- `NN = next_ff_threshold - bells_current` (bells STILL NEEDED)
- `MM = next_ff_threshold` (total cost)

So at frame 1310124562: bells_current=99, threshold=129, display="30 in 129".

When current_ff is acquired:
1. PowerRecord +0x07 bit set (bit i for FF idx i)
2. PowerRecord +0x14 incremented (FF count)
3. PowerRecord +0x0C resets to ~0 and accumulates toward next FF

---

## Europe Trade Port (frame 1310291187)

**Background**: `EUROPE.PIK` (sky + harbor + dock) at full screen,
overlaid with `COLONY.PIK` strip at y=128..200 (16-good inventory bar).

### Layout

| Element | Position | Source |
|---------|----------|--------|
| Banner background strip | y=0, h=10, brown wood | (built-in or NAMEPLAT) |
| Banner text "Selling Sugar at 1632 Gold: (19200%)" | centered, y=2 | runtime computed |
| "Sold 72 Rum at 0%/ton" | centered, y=18 | LABELS.TXT @CMESSAGE "sold for"/"at"/"$/ton" |
| "Price:    0%" | x=140, y=30 | LABELS.TXT @CMESSAGE "Price" |
| "0% Tax:   0%" | x=140, y=42 | LABELS.TXT @CMESSAGE "% Tax" |
| Underline | x=140-220, y=52 | rendered as 1px line |
| "Net:      0%" | x=140, y=58 | LABELS.TXT @CMESSAGE "Net" |
| RECRUIT button | x=270, y=80, 40×12 | LABELS.TXT @EUROLABEL[0] |
| PURCHASE button | x=270, y=96, 40×12 | LABELS.TXT @EUROLABEL[1] |
| TRAIN button | x=270, y=112, 40×12 | LABELS.TXT @EUROLABEL[2] |
| Button highlight color | red text on light blue plate | — |
| 3-panel dock area | y=128..145 | — |
| Panel 1 "Expected Soon" | x=4, y=128, w=80, h=18 | LABELS.TXT @MISC line 24 |
| Panel 2 "Bound For New England" | x=88, y=128, w=80, h=18 | LABELS.TXT @MISC line 25 + NAMES.TXT @COUNTRY[0] |
| Panel 3 "Loading: Caravel" | x=172, y=128, w=80, h=18 | LABELS.TXT @MISC "Loading" + ship name |
| Caravel sprite (active) | x=176, y=140 | ICONS.SS.<caravel-idx> |
| Cargo crates row | x=176, y=152 | per-cargo ICONS sprite |
| Inventory bar | y=170..190 | 16 cells, w=20 each |
| Cargo cell N | x=4+20*N, y=170, w=18, h=18 | ICONS.SS.<12+N> commodity |
| Cargo current/max text | below cell, y=189 | from PowerRecord cargo state |
| **Boycott red X overlay** on cell N if (PowerRecord +0x20 >> N) & 1 | overlay ICONS.SS.043 on cell | DGROUP boycott bitfield |
| EXIT red E button | x=300, y=190 | EXIT sprite |

### Boycott vs Saturation rendering rules

```
for good_idx in range(16):
    cell_x = 4 + 20 * good_idx
    icon = ICONS.SS[12 + good_idx]  # commodity icon
    blit(icon, cell_x, 170)
    
    if PowerRecord[+0x20] & (1 << good_idx):
        # Boycotted — show red X overlay
        blit(ICONS.SS[43], cell_x, 170)
        # Display "0/N" or "BOYCOTTED" instead of normal text
    else:
        price_byte = PowerRecord[+0x4C + good_idx]
        if price_byte == 0xC8:
            # Saturated — display "0/0"
            stock = current_stock_for_good(good_idx)
            display = f"{stock}/0"
        else:
            display = f"{stock}/{max_stock}"
```

---

## Map Banner Popups (PRICEDOWN / PRICERISE / NOOCEAN)

**Background**: full-screen map (live render), popup overlays bottom-center.

### Layout (frame 1310280609 - PRICEDOWN)

| Element | Position | Source |
|---------|----------|--------|
| Background | full-screen map | unchanged from prior frame |
| Speaker sprite (MSS2 merchant) | x=80, y=20 (centered above popup) | MSS2/MSS2.SS.000 |
| Popup wood frame | x=4, y=110, w=218, h=48 | WOODFRAM stretched/tiled |
| Body text line 1 | x=12, y=120 | GAME.TXT @PRICEDOWN body line 1 |
| Body text line 2 | x=12, y=132 | GAME.TXT @PRICEDOWN body line 2 |
| Highlighted commodity name | yellow inline | %STRING0 = sugar |
| Highlighted price | yellow inline | %NUMBER0$ = 17 |
| Body color | green (80, 144, 48) | — |
| Highlight color | yellow (200, 160, 24) | — |

### Geometry from GAME.TXT directives

GAME.TXT @PRICEDOWN section header:
```
@PRICEDOWN
@width=190
The price of {%STRING0} in %STRING1 has fallen to {%NUMBER0$}.
```

The `@width=190` is the popup body width in pixels. With WOODFRAM
border of ~10px each side, the outer popup is ~210px wide.
The popup is centered horizontally at x=(320-210)/2 = 55.
The popup vertical position depends on game state — for these
banner popups the y is fixed at 110 (lower-center).

---

## NOOCEAN advisor warning (frame 1310261859)

**Background**: full-screen map, sidebar still visible.

| Element | Position | Source |
|---------|----------|--------|
| Pioneer sprite (MSS3) | centered, y=10..70 | MSS3/MSS3.SS.000 |
| Popup frame | x=4, y=80, w=200, h=80 | WOODFRAM |
| Body text (5 lines) | x=12, y=92, line-spacing=10 | GAME.TXT @NOOCEAN... template |
| Response option 1 (`"Oh, I forgot..."`) | x=12, y=140 | from @options block |
| Response option 2 (highlighted bright) | x=12, y=152 | active=2 (default highlight) |

GAME.TXT @options syntax:
```
@<message>
@width=200
@options
Body text...
"Oh, I forgot about that."
"And that is exactly what I had in mind."
```

The renderer should parse the body, extract response options
(quoted lines after the body), and highlight option N where
`@default=N` is set.

---

## Default map view sidebar

**Background**: WOODPANL.PIK tiled (right ~80 pixels of screen).

### Layout (frame 1310262984 — Scout selected)

| Element | Position | Source |
|---------|----------|--------|
| Top menu bar | y=0..8 | LABELS.TXT @MISC menu items + COLONIZOPEDIA |
| Menu item GAME | x=4, y=2 | yellow on wood |
| Menu item VIEW | x=44, y=2 | |
| Menu item ORDERS | x=84, y=2 | |
| Menu item REPORTS | x=144, y=2 | |
| Menu item TRADE | x=200, y=2 | |
| Menu item CHEAT | x=244, y=2 | |
| Menu item COLONIZOPEDIA | x=234, y=2 (right side) | |
| Map area | x=0, y=8, w=240, h=192 | tile-rendered |
| Right sidebar | x=240, y=0, w=80, h=200 | WOODPANL |
| Minimap | x=244, y=8, w=72, h=44 | |
| Spring/year text | x=244, y=58 | "Spring %YEAR" |
| Gold text | x=244, y=66 | "Gold: %NUMBER%%" |
| Tax text | x=290, y=66 | "Tax: %NUMBER2%%" |
| Selected unit sprite | x=244, y=80 | ICONS.SS.<unit_type> |
| Unit info "Moves: N" | x=270, y=82 | LABELS.TXT @INFO[0] |
| Unit info "Locat: (x, y)" | x=270, y=92 | LABELS.TXT @INFO[1] |
| Unit type label | x=244, y=104 | NAMES.TXT @UNIT[type] |
| Unit skill | x=244, y=112 | NAMES.TXT @JOB[skill] |
| Unit orders | x=244, y=120 | LABELS.TXT @MISC ("No Orders" / "Sentry" / etc.) |
| Terrain in parens | x=244, y=128 | "(Terrain)" — NAMES.TXT @UNFORESTED/@FORESTED |

---

## Colony view (frame 1310196718 — Plymouth)

**Background**: COLONY.PIK strip at y=128..200 + colony scene
composed of BUILDING sprites.

### Layout

| Element | Position | Source |
|---------|----------|--------|
| Title bar (yellow) | y=0..8 | "Plymouth, Spring 1543, Gold: 19200%" |
| Colony scene viewport | x=4, y=10, w=176, h=110 | tile-by-tile composition |
| Tile grid (3×3 worked tiles + center) | x=190, y=10, w=132, h=110 | terrain + production icons |
| 4 bottom panels | y=124..150 | |
| Colonist list panel | x=4, y=124, w=80, h=26 | with SoL/Tory counts "102 (0)" "902 (5)" |
| Loading: Caravel panel | x=88, y=124, w=80, h=26 | active ship + cargo |
| Production panel | x=172, y=124, w=80, h=26 | bell/cross/hammer icons |
| Building selected slots | x=256, y=124, 3 stacked slots | visible buildings clickable |
| 16-good inventory | y=176, h=18, cell w=20 | 16 commodity icons |
| Stockpile counts | below each cell, y=194 | per-good byte at colony+offset |
| EXIT red E button | x=300, y=190 | |

---

## Build menu overlay (frame 1310206750)

| Element | Position |
|---------|----------|
| Overlay frame | x=80, y=20, w=200, h=170 |
| Title "Select An Item To Build" | x=88, y=24 |
| Build option lines | x=88, y=36+12*N | from @CTITLE list |
| Each option: name (left) + cost (right) | aligned x=88 + x=240 |
| Highlight bar (selected option) | full-width horizontal bar across selected line |
| (F1 for Help) | x=232, y=180 |

Costs are read from `func_02D658` (colony renderer) which
references hardcoded hammer/tool requirement tables. Per
session frame:

```
Stockade            (64 Hammers)
Armory              (52 Hammers)
Docks               (52 Hammers)
Schoolhouse         (64 Hammers)
Warehouse           (80 Hammers)
Stable              (64 Hammers)
Printing Press      (52 Hammers) (20 Tools)
Weaver's Shop       (64 Hammers) (20 Tools)
Tobacconist's Shop  (64 Hammers) (20 Tools)
Rum Distillery      (64 Hammers) (20 Tools)
Fur Trading Post    (56 Hammers) (20 Tools)
Lumber Mill         (52 Hammers)
Church              (64 Hammers)
Blacksmith's Shop   (64 Hammers) (20 Tools)
Wagon Train         (40 Hammers)
```

These costs need byte-verification against the disasm cost-table
load (file 0x02D658 region).

---

## Screen-bounds reminder

DGROUP:0x839E..0x83A4 holds the SCREEN BOUNDS (200, 320, 0, 15585)
which are the clip rect, NOT a popup rect. Per
SESSION_RUNTIME_TRACE.md, these are constant across all 396
snapshots. Renderers using `LCALL 0x191F:0x087A` (load_PIK) should
clip to (0, 0, 320, 200).

The actual popup rect IS NOT in DGROUP — it's computed inline by
`func_07431E` using GAME.TXT @width directive + cursor position.
That's the geometry "missing setter" referenced in
DIALOG_GEOMETRY.md.

---

## How to use this spec

1. Each renderer (`render_cc.py`, `render_europe.py`, etc.) should
   replace its hardcoded coordinates with the values in this doc.
2. Each coordinate must have a comment citing this doc + the source
   address (PowerRecord +0xNN, DGROUP:0xNNNN, or LABELS.TXT @SECTION
   line N).
3. Run `tests/run_regression.py` after each renderer change to
   verify against goldens.
4. If a coordinate here doesn't match the visual, the FRAME is
   ground truth — update this doc, not the renderer.
