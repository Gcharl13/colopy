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
| **FONTINTR** | `FONTINTR.FF` (`@0x1FD29`) | 9 × 6 fixed | chunky 3-D | **intro / title**; default menu font (but `@BEGINMENU` overrides to FONTSMAL via `@smallfont`) | B / A |
| **FONTKING** | `FONTKING.FF` (`@0x1FCCB`) | 7 × 3–7 var | mixed-case proportional | **large readable**: screen titles, SoL%, **Score screen**, **Hall of Fame**, king-defeats | B / A |
| **FONT-NP** | `FONT-NP.FF` (`@0x1F8AF`) | 8 × 7–8 var | uppercase var | **national-power** / grayed text | B / A |
| **FONTSMAL** | `FONTSMAL.FF` | 6 × 6 fixed | uppercase fixed | popup body when the **`SMALLFONT`** directive (`@file 0x1F97B`) is set (`func_06F0F4`) | B |

**Selection mechanism — important caveat (tier A for per-element font):** the active font is a
**screen-level global latch** (`g_font_ptr_89E`, set by an `ov_set_font(KEY_…)` at screen-enter),
**not** a per-draw select inside the paint helpers — no `ov_set_font` appears in
`colony_paint_*` / `europe_draw_*`. So **which font a given element uses is inferred from the
framework + pixel verification** (`docs/UI_FONT_REFERENCE.md`), tier **A**, not a byte-verified
per-blit handle. (The popup framework `func_06F0F4` is the exception that *does* switch
`FONTTINY`↔`FONTSMAL` on the `SMALLFONT` directive — that one is **B**.) **Colors, by contrast,
are per-draw `push`-args → exact RGB (B); fonts are screen-latched → A.**

## 2. Colors — palette-index args, resolved to exact RGB (fully static — tier B)

Text and fills take an **explicit palette-index color argument**, pushed immediately before the
draw thunk — e.g. `push 0xF` (white) before a text-draw `lcall`, or `push 0x90` before a
box-fill. The byte-cited value is the VGA palette index (**B**), and the **exact RGB is also
static**: it resolves through the screen's loaded **PIK palette, which is a decodable 768-byte
section of the `.PIK` file** (`tools/ssdec.py`) — *no runtime/capture needed*. Resolving an
index = decode that screen's PIK palette (last 768-byte section, 6-bit→8-bit) and index it.
Tier **B** for both index and RGB. (Each screen's palette source: reports → `REPORT<N>.PIK`;
colony/Europe → `EUROPE.PIK`; congress → `CCBKGD.PIK`; menus/HoF → `WOODPANL`/`WOODPAN2`.)

### Recurring named colors — RGB resolved from the PIK palette (all tier **B**)
| Index | Resolved RGB | Meaning | Source (palette) |
|-------|--------------|---------|------------------|
| `0x0F` | (255,255,255) white | body / number text | every screen (EUROPE/REPORT/CCBKGD all agree) |
| `0x90` | (255,255,190) pale-yellow | title/header **box-fill** (advisor reports) | REPORT\<N\>.PIK |
| `0x91` | (255,255,142) yellow | report strength rows | REPORT\<N\>.PIK |
| `0x92` | (255,243, 93) bright-yellow | report labels (F3/F4/F6/F9) | REPORT\<N\>.PIK |
| `0x61` | (247,243,199) cream | report values (F3/F4/F7) | REPORT\<N\>.PIK |
| `0x39` | (77,97,170) / blue | crosses/bells **filled** gauge; recruit-cell outline | EUROPE/REPORT |
| `0x04` | (170,0,0) dark-red | SoL% text when tories ≥ threshold | EUROPE.PIK |
| `0x0C` | (255,85,85) bright-red | SoL% text when tories ≥ 2·threshold | EUROPE.PIK |
| `0x0A` | (85,255,85) green | colonist selection box | EUROPE.PIK |
| RGB(0x52,0x8A,0x31) | (82,138,49) green | **title green** (colony/europe header) | `ui_color_for` (direct RGB) |
| RGB(0xE3,0xAA,0x28) | (227,170,40) gold | menu **gold** highlight | menu framework 48508 (direct RGB) |
| RGB(0x38,0x20,0x10) | (56,32,16) | menu **selection bar** | menu framework 48507 (direct RGB) |
| RGB(0xF0,0xE0,0xB0) | (240,224,176) cream | SoL-panel "Sons of Liberty" | `colony_paint_sol_panel` (direct RGB) |

*(Resolve any other index for a given screen with `tools/ssdec.py`: decode that screen's PIK,
take the last 768-byte section as the 6-bit palette, `(v<<2)|(v>>4)` per channel, index by the
push-arg.)*

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
| Boot-menu plaque (BEGINMENU) | **FONTSMAL** (`@smallfont`) | green (82,138,49) / gold (227,170,40) selected — via `mr_color_for` direct-RGB | B |
| Hall of Fame | FONTKING | gold `0xFC`→(199,162,32) via **WOODPAN2.PIK** | B |
| Popup body (default / `SMALLFONT`) | FONTTINY / FONTSMAL | per `TEXTCOLR` directive | B |

## 4. Residual — none (font/color is fully static)
**No font/color claim needs a runtime or a capture.** Fonts are byte-cited boot-table loads;
colors are byte-cited push-args **and** their exact RGB is the decodable PIK palette indexed by
that arg. The only runtime aspect is **palette *cycling*** (a few animated indices, e.g. water),
which shifts an index's RGB frame-to-frame — that is a documented animation effect
(`docs/PALETTE_AND_CYCLING.md`), not an unknown. (Corrects the earlier note that called the
index→RGB resolution "runtime" — it is static, from the `.PIK` file.)
