# UI Fonts & Colors — shared reference

> **Layer 2 — UI Specification.** Per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. This is the shared
> font + color model referenced by every `spec/ui/*.md`. **Canonical primary:** boot asset
> table `@file 0x1FD20` (font loads), the per-call color push-arg in each render function
> (`raw/COLONIZE/VICEROY.EXE`), and the per-screen pixel verification in `spec/ui/colony_screen.md`
> (the removed `docs/UI_FONT_REFERENCE.md` previously held the same colony-screen measurements).

## 1. Fonts — four loaded bitmap fonts (`.FF`) (+ FONTSMAL orphan)

VICEROY.EXE loads exactly **four** fonts: FONTTINY (the boot default latch), FONTINTR, FONTKING,
FONT-NP. A fifth file `FONTSMAL.FF` exists on disk but is **never loaded** (the strings
`FONTSMAL`/`fontsmal` are absent from the EXE — see `notes/rulings/RULINGS.md` 2026-06-21). Each
loaded font is a MicroProse `.FF` bitmap (format in `formats/FF.md`); glyph metrics are measured
from the decoded `.FF` glyph atlases (importer output — see `viceroy_cpp` `import-font`; the removed
`docs/UI_FONT_REFERENCE.md` previously tabulated the same metrics).

| Font | File | Glyph (h × w) | Style | Role / where used | Tier |
|------|------|---------------|-------|-------------------|------|
| **FONTTINY** | `FONTTINY.FF` (`@0x1FD32`) | 6 × 4 fixed | mixed-case fixed | **default body / HUD** (boot latch `[0x89E]`): inventory qty, yields, sidebar numbers, advisor bodies, popup bodies | B (load) / A (role) |
| **FONTINTR** | `FONTINTR.FF` (`@0x1FD29`) | 9 × 6 fixed | chunky 3-D | **intro / title / boot menu** plaques | B / A |
| **FONTKING** | `FONTKING.FF` (`@0x1FCCB`) | 7 × 3–7 var | mixed-case proportional | **king-defeats screen ONLY** — the string `FONTKING`@0x232b is referenced **exactly once** in the EXE (`lea bx,[0x232b]` @0x754F2 in `func_075352`); never cached to a global (RULING 2026-06-21) | B / A |
| **FONT-NP** | `FONT-NP.FF` (`@0x1F8AF`) | 8 × 7–8 var | uppercase var | **national-power** / speaker name-plate | B / A |
| ~~FONTSMAL~~ | `FONTSMAL.FF` | — | — | **ORPHAN — never loaded by VICEROY.EXE**; the `SMALLFONT`/`@smallfont` directive does *not* load it | (refuted) |

**Selection mechanism — important caveat (tier A for per-element font):** the active font is a
**screen-level global latch** (`[0x89E]/[0x8A0]`, set at screen-enter; FONTTINY by boot default),
**not** a per-draw select inside the paint helpers — no per-draw font-set appears in
`colony_paint_*` / `europe_draw_*` / the advisor bodies (those read the `[0x89E]` latch). So
**which font a given element uses is inferred from the framework + pixel verification**
(per-screen pixel verification, formerly tabulated in the removed `docs/UI_FONT_REFERENCE.md`),
tier **A**, not a byte-verified per-blit handle. The popup
framework's `SMALLFONT` directive (handler `@0x6F207`) merely **copies the latched `[0x89E]`
font** into the section — it does **not** switch to a smaller font (FONTSMAL is never loaded).
The active-font global is **`[0x1F9E]/[0x1FA0]`**, set only from FONTTINY (`[0x89E]`), FONTINTR
(`[0x268A]`), or — uniquely in king-defeats — FONTKING (RULING 2026-06-21). Screens select their
font by pushing the font far-ptr to the render call: colony/Europe/advisor-report bodies push
**FONTTINY** (`push [0x8A0];push [0x89E]` @0x25F62/0x30EDE/0x3860C…); the Hall of Fame and menus
push **FONTINTR** (`push [0x268C];push [0x268A]` @0x22ABE/0x23C06). The only genuine FONTKING load
is king-defeats (`func_075352`). **Colors, by contrast, are per-draw `push`-args → exact RGB
(B) wherever the draw is in the extracted image; in the popup framework the body color is **not a
`push`-arg at all** — it is *resolved-as-state*: the body renderer `func_00E51C` reads its pen from
the glyph color-map global `[0x269E..0x26A1]` (set by `func_00E68A` @0x00E68A), which the section-init
setter `func_06C296` populates from caller args — see §3 "Popup body" (fully resolved, no TBD).**

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
| `0x39` | (77,97,170) / blue | crosses/bells **filled** indicator sprite (discrete, one per count — *not* a bar); recruit-cell outline | EUROPE/REPORT |
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
**Colony screen** is pixel-verified (see `spec/ui/colony_screen.md`; formerly `docs/UI_FONT_REFERENCE.md`):

| Element | Font | Color | Tier |
|---------|------|-------|------|
| Colony/Europe title bar | **FONTTINY** (`push [0x89E]` @0x25F62/0x30EDE — *not* FONTKING) | title green / yellow (218,178,0) | B (font), A (RGB) |
| Inventory cell qty | FONTTINY | white `0x0F` (navy in some captures) | B |
| Production-grid yields | FONTTINY | yellow | A |
| SoL% / "No Ships In Port" | **FONTTINY** (colony render latch — *not* FONTKING) | white / cream | B/A |
| Score screen | **FONTTINY** labels (`[0x89E]`) + **FONTINTR** big-figure metrics (`[0x268A]` @0x3B054) — *not* FONTKING | per `@MISC` | B |
| Hall of Fame | **FONTINTR** (`push [0x268A]` @0x22ABE — *not* FONTKING) | per `@MISC` | B |
| Advisor reports F2–F9 | FONTTINY (body+title) | title fill `0x90`→(255,255,190); rows `0x91`(255,255,142)/`0x92`(255,243,93)/`0x61`(247,243,199); text `0x0F` white | B |
| Advisor F10 score | **FONTTINY** (`[0x89E]`) + FONTINTR figure metrics (`[0x268A]`) — *not* FONTKING; same `func_03A9C0` as the cinematic score | per `@MISC` | B |
| Boot-menu plaque (BEGINMENU) | latched (FONTINTR/FONTTINY) — `@smallfont` loads no distinct font | green (82,138,49) / gold (227,170,40) selected — via `mr_color_for` direct-RGB | A (font) / B (color) |
| Hall of Fame table | **FONTINTR** (`push [0x268A]` @0x23C06 — *not* FONTKING) | gold `0xFC`→(199,162,32) via **WOODPAN2.PIK** | B |
| King-defeats text (the **sole FONTKING user**) | **FONTKING** (`func_075352` @0x754F2, pen (x=242,y=47), glyph engine `0x181F:0x3FE`) | no per-call palette arg → glyph-engine mapping (`[0x1F5C]` is the **speaker-portrait selector** channel, *not* text color — RULING) | B (font/pos) / A (RGB) |
| Popup body | FONTTINY (latch; `SMALLFONT` just copies it) | **resolved-as-state — NOT a literal `0x0F`.** The body glyph blit is the no-color-arg proportional renderer `func_00E51C` (`181F:01FA` @0x00E51C; reseg'd from VICEROY.EXE — committed disasm truncated at 24B); it reads its pen from the 4-byte glyph color-map global `[0x269E..0x26A1]`, set by `func_00E68A` (`181F:01F0` @0x00E68A: `mov [0x269e],cl` / `[0x269f],dl` / `[0x26a0],al` / `[0x26a1],al`). For the popup body that map is loaded by wrapper `func_06C346` @0x6C346, called from the body-draw `func_06C388` @0x6C3A5, which selects the pen from the **section-struct color fields** `es:[bx+4]` (highlight, ax=bx&1), else `es:[bx+6]` (when state latch `[0x1F62]`≠0), else `es:[bx+2]`, plus `+8`/`+0xa` — all populated as caller args by the section-init setter `func_06C296` @0x6C2A5–0x6C2C1. So body text color is per-section runtime state (typically the latched body pen), not a hardcoded index. **No `TEXTCOLR` override exists — byte-confirmed: the dialog parser `func_06F0F4` @0x6F0F4 dispatches exactly 8 directives (OPTIONS/PROMPT/TEXT/SMALLFONT/WIDTH/LENGTH/CHECKBOX/DEFAULT) via the `lcall 0xd1d:0x816` strcmp chain @0x6F1A4–0x6F376 and never compares the `TEXTCOLR` string (file 0x1F9AA / DGROUP off 0x200A; zero code-xref)** | B (renderer/source) / state (color) |
| Speaker name-plate | FONT-NP (loaded with WOODFRAM/NAMEPLAT) | overlay-resident → TBD | A |

## 4. Residual — none (font/color is fully static)
**No font/color claim needs a runtime or a capture.** Fonts are byte-cited boot-table loads;
colors are byte-cited push-args **and** their exact RGB is the decodable PIK palette indexed by
that arg. The only runtime aspect is **palette *cycling*** (a few animated indices, e.g. water),
which shifts an index's RGB frame-to-frame — that is a documented animation effect
(`docs/PALETTE_AND_CYCLING.md`), not an unknown. (Corrects the earlier note that called the
index→RGB resolution "runtime" — it is static, from the `.PIK` file.)
