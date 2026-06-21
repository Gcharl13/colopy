# UI Fonts & Colors — shared reference

> **Layer 2 — UI Specification.** Per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. This is the shared
> font + color model referenced by every `spec/ui/*.md`. **Canonical primary:** boot asset
> table `@file 0x1FD20` (font loads), the per-call color push-arg in each render function
> (`raw/COLONIZE/VICEROY.EXE`), and `docs/UI_FONT_REFERENCE.md` (pixel-verified colony screen).

## 1. Fonts — five bitmap fonts (`.FF`)

The engine loads four fonts at boot (asset table `@file 0x1FD20`/export `BOOT_ASSETS`) plus
`FONTSMAL` selected by the `@smallfont` directive. Each is a MicroProse `.FF` bitmap font
(format in `formats/FF.md`). Glyph metrics from extracted PNGs (`docs/UI_FONT_REFERENCE.md`).

| Font | File | Glyph (h × w) | Style | Role / where used | Tier |
|------|------|---------------|-------|-------------------|------|
| **FONTTINY** | `FONTTINY.FF` (`@0x1FD32`) | 6 × 4 fixed | mixed-case fixed | **default body / HUD**: inventory qty, production-grid yields, sidebar numbers | B (load) / A (role) |
| **FONTINTR** | `FONTINTR.FF` (`@0x1FD29`) | 9 × 6 fixed | chunky 3-D | **intro / boot-menu plaques / title** | B / A |
| **FONTKING** | `FONTKING.FF` (`@0x1FCCB`) | 7 × 3–7 var | mixed-case proportional | **large readable**: screen titles, SoL%, **Score screen**, **Hall of Fame**, king-defeats | B / A |
| **FONT-NP** | `FONT-NP.FF` (`@0x1F8AF`) | 8 × 7–8 var | uppercase var | **national-power** / grayed text | B / A |
| **FONTSMAL** | `FONTSMAL.FF` | 6 × 6 fixed | uppercase fixed | popup body when the **`SMALLFONT`** directive (`@file 0x1F97B`) is set (`func_06F0F4`) | B |

**Selection mechanism (B):** the popup/dialog framework `func_06F0F4` defaults bodies to
`FONTTINY` and switches to `FONTSMAL` on the `SMALLFONT` directive. Full-screen renderers pick
their font explicitly (e.g. the Score screen and Hall of Fame call `FONTKING`).

## 2. Colors — palette-index args (not literal RGB)

Text and fills take an **explicit palette-index color argument**, pushed immediately before the
draw thunk — e.g. `push 0xF` (white) before a text-draw `lcall`, or `push 0x90` before a
box-fill. So the **byte-cited value is the VGA palette index (tier B)**; the **perceived RGB is
palette-dependent** — it resolves through the screen's currently-loaded PIK/`VICEROY.PAL`
palette, so RGBs are **A** (pixel-measured) or **R** (inferred), never raw literals.

### Recurring named colors
| Index / RGB | Meaning | Source | Tier |
|-------------|---------|--------|------|
| `0x0F` (15) | **white** body/number text | `push 0xf` before text-draw (e.g. colony stockpile, europe) | B |
| `0x90` | title/header **box-fill** color (all advisor reports) | `push 0x90` fill | B |
| `0x91` / `0x92` | report row text (strength / labels) | advisor bodies | B |
| `0x61` | report value / tan text | advisor F3/F4/F7 | B |
| RGB(0x52,0x8A,0x31) | **title green** (colony title, europe header) | `ui_color_for`, render bodies | B (call) / A (RGB) |
| RGB(0xE3,0xAA,0x28) | menu **gold** (selected/highlight text) | menu framework export 48508 | B / A |
| RGB(0x38,0x20,0x10) | menu **selection bar** | menu framework 48507 | B / A |
| RGB(0x14,0x0C,0x06) | menu plaque **outline** | menu framework 48506 | B / A |
| RGB(0xF0,0xE0,0xB0) | SoL-panel **cream** ("Sons of Liberty") | `colony_paint_sol_panel` 16910 | B / A |
| yellow ~(218,178,0) | colony **title-bar** text | pixel-verified `docs/UI_FONT_REFERENCE.md` | A |
| dark-navy (20,28,120) | colony **inventory qty** digits | pixel-verified | A |

## 3. Per-screen font + color (byte/pixel-grounded)

The authoritative per-element table is in each screen's own spec; collected here for reference.
**Colony screen** is pixel-verified (`docs/UI_FONT_REFERENCE.md`):

| Element | Font | Color | Tier |
|---------|------|-------|------|
| Colony/Europe title bar | FONTKING | title green / yellow (218,178,0) | B (font), A (RGB) |
| Inventory cell qty | FONTTINY | white `0x0F` (navy in some captures) | B |
| Production-grid yields | FONTTINY | yellow | A |
| SoL% / "No Ships In Port" | FONTKING | white / cream | B/A |
| Score screen + Hall of Fame | **FONTKING** | per `@MISC` | B |
| Advisor report titles | (report font) | fill `0x90`; rows `0x91/0x92/0x61` | B |
| Boot-menu plaques | FONTINTR | green text `0x52,0x8A,0x31` / gold selected | B/A |
| Popup body (default / `SMALLFONT`) | FONTTINY / FONTSMAL | per `TEXTCOLR` directive | B |

## 4. Residual
The exact **perceived RGB** of a palette-index color depends on the loaded PIK palette and any
cycling; where not pixel-measured it stays **A/R**. The palette *index* in every render call is
**B**. (No font/color claim requires a memory dump — fonts are byte-cited loads, colors are
byte-cited push-args; only the index→RGB resolution is palette/runtime.)
