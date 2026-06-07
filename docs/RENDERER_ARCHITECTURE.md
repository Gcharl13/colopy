# UI Renderer Architecture

This doc describes the verified UI renderers and how they compose
each game screen from extracted assets.

---

## Per-screen renderers

Each renderer takes a state dict (or sample default) and produces a
320×200 native-resolution PNG (scaled 4x by default to 1280×800).

| Renderer | Output | Reference screenshot |
|----------|--------|----------------------|
| `tools/render_colony.py` | colony screen | `colon3.jpg` |
| `tools/render_gameplay.py` | gameplay (top menu + map + sidebar + optional dialog) | `screenshot_03.jpg` |
| `tools/render_europe.py` | Europe screen | `0d9a26d...jpg` |
| `tools/render_dialog.py` | dialogs (king tax / FF acquired / raze / diplomatic) | `acaab05...jpg`, `b6235e...jpg` |
| `tools/render_score.py` | end-of-game COLONIZATION SCORE | `f8997b...jpg` |
| `tools/render_nations.py` | nation selection | `719e508...jpg` |
| `tools/render_screen.py` | dispatches to dedicated renderers; fallback to PIK-only | (multiple) |

Master verification: `tools/verify_ui_renders.py` produces a contact
sheet showing all 6 main screens side-by-side with their DOSBox
references.

---

## Asset pipeline

Each renderer pulls from these asset categories:

### Sprites (`assets/sprites/<NAME>/<NAME>.SS.NNN.png`)
- WOODTILE.SS — chrome backgrounds (title bar, side panels)
- ICONS.SS — commodity icons (22-37) + unit sprites (95-117) + ship sprites (5,6,7,14,15)
- BUILDING.SS — colony building sprites (0-47)
- TERRAIN.SS — colony view ground tiles (12 frames, 16×16)
- PHYS0.SS — world map tile sprites (155 frames)
- KING.SS / KINGLOSE.SS / KINGWIN.SS — diplomatic portraits
- CC-NN.SS — Founding Father portraits (25 sheets, 0..24)
- NAMEPLAT.SS — dialog title strip
- WOODFRAM.SS — dialog frame border
- CURSOR.SS, PARCH.SS, OPENTILE.SS — UI primitives

### Backgrounds (`assets/backgrounds/<NAME>/<NAME>.PIK.png`)
- COLONY.PIK — colony screen bottom 72 rows (UNIQUE: 2-section MADSPACK,
  inherits palette from EUROPE.PIK)
- EUROPE.PIK — Europe screen full 320×200
- NATIONS.PIK — nation selection 320×200
- CCBKGD.PIK — Continental Congress hall 320×200
- DECLARAT.PIK — Declaration of Independence document 320×200
- WOODPANL.PIK / WOODPAN2.PIK — dialog backgrounds
- KINGLSS1/2.PIK, REPORT1-9.PIK, LEVN0001-10.PIK, etc.

### Fonts (`assets/fonts/<NAME>/`)
- FONTKING — main UI font (mixed-case proportional, 7 px tall)
- FONTINTR — chunky 3D font (uppercase, 9 px tall) — top menu only
- FONTTINY — small clean font (mixed-case fixed-width 4×6) — numbers/yields
- FONTSMAL — uppercase fixed-width (6×6)
- FONT-NP — disabled/grayed text

### Palette (`assets/palettes/`)
- viceroy.pal.json — master VGA 6-bit palette (256 colors)
- europe.pal.json — EUROPE.PIK embedded palette (used by COLONY.PIK too)

---

## Pixel-verified font usage map

See `docs/UI_RENDER_MAP.md` for the per-element catalogue.

Quick reference:

| Where | Font | Color | Bg |
|-------|------|-------|----|
| Colony title | FONTKING | yellow (218,178,0) | WOODTILE |
| Colony view ground | (sprite) | beige | TERRAIN.SS.001 (Plains) |
| Colony SoL bars | FONTKING | white | over COLONY.PIK |
| Colony "No Ships in Port" | FONTKING | yellow | over COLONY.PIK |
| Colony inventory numbers | FONTTINY | dark navy (20,28,120) | over COLONY.PIK |
| Colony production yields | FONTTINY | yellow | TERRAIN.SS bg |
| Gameplay top menu | **FONTINTR** | yellow | WOODTILE |
| Gameplay sidebar | FONTKING | green (80,153,48) | WOODTILE |
| Europe title | FONTKING | green (83,145,48) | WOODTILE |
| Europe panel labels | FONTKING | green | over EUROPE.PIK |
| Dialog body | FONTKING | green (102,140,53) | WOODPANL or WOODTILE |
| Dialog title | FONTKING | yellow | NAMEPLAT |
| Score title | FONTKING | yellow | WOODTILE |
| Score body | FONTKING | green | WOODTILE |
| Nations title | FONTKING | green | NATIONS.PIK |

---

## Renderer composition pattern

Each renderer follows the same structure:

```python
def render_<screen>(state):
    canvas = Image.new("RGBA", (SCREEN_W, SCREEN_H), bg)

    # 1. Background layer (PIK or tiled WOODTILE)
    if pik_exists:
        canvas.paste(open(pik_png), (0, 0))
    else:
        tile_woodtile(canvas)

    # 2. Sprite layers (buildings, units, icons)
    for sprite, x, y in state['sprites']:
        canvas.paste(load_sprite(sprite), (x, y), sprite)

    # 3. Text overlays (title, body, labels)
    for text, x, y, font, color in state['texts']:
        render_text(canvas, text, x, y, font=font, color=color)

    return canvas.convert("RGB")
```

The key innovation: `load_glyph_recolored(font, ascii, color)` does
2-bit-per-pixel palette decode of glyph PNGs:
- Index 0 → transparent
- Index 1 → shadow color (auto-derived as 1/3 of primary)
- Index 3 → primary color (caller-specified)

This produces font output with built-in shadows that match the DOSBox
appearance exactly.

---

## Verification workflow

After any renderer change:

```bash
# 1. Re-render every screen
python tools/render_screen.py

# 2. Generate side-by-side comparison sheet
python tools/verify_ui_renders.py

# 3. Open ui_verification_sheet.png and compare visually
```

If a render diverges from its DOSBox reference, sample pixel colors at
known coordinates in the reference (e.g. with PIL `getpixel`) and update
the renderer's font/color constants to match. All color choices in the
renderers are accompanied by inline citations to the pixel sample
coordinates that justified them.

---

## Code citations (where elements come from in the EXE)

VICEROY.EXE asset table at file 0x1FD20 lists startup-loaded assets:
- viceroy.pal, fontintr, fonttiny, cursor, woodtile, parch, opentile,
  phys0, icons, building

Plus uppercase string xrefs:
- FONTKING (file 0x1FCCB), FONT-NP (file 0x1F8AF),
  SMALLFONT directive (file 0x1F97B)

Per-screen render code lives in RTLink overlay pages. Per-callsite
trace from `set_current_colony` (LCALL 0x181F:0x9E6, target file
0x82DC, IMUL stride 0xCA) through to text-blit calls is documented
gap; pixel verification is the operational substitute.
