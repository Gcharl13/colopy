# UI Fonts & Colors — shared reference

> **Layer 2 — UI Specification.** Per `/METHODOLOGY.md`. Tiers: B/A/R. This is the shared
> font + color model referenced by every `spec/ui/*.md`. **Canonical primary:** boot asset
> table `@file 0x1FD20` (font loads), the per-call color push-arg in each render function
> (`raw/COLONIZE/VICEROY.EXE`), and the per-screen pixel verification in `spec/ui/colony_screen.md`
> (the removed `docs/UI_FONT_REFERENCE.md` previously held the same colony-screen measurements).

## 1. Fonts — four loaded bitmap fonts (`.FF`) (+ FONTSMAL orphan)

VICEROY.EXE loads exactly **four** fonts: FONTTINY (the boot default latch), FONTINTR, FONTKING,
FONT-NP. A fifth file `FONTSMAL.FF` exists on disk but is **never loaded** (the strings
`FONTSMAL`/`fontsmal` are absent from the EXE — see `notes/rulings/RULINGS.md` 2026-06-21). Each
loaded font is a MicroProse `.FF` bitmap (format in `formats/FF.md`). **Per-glyph metrics are
committed in `data_extracted/fonts/ff_metrics.json`** (decoded from the original assets with the
corrected `ch−1` slot mapping — see §1b) and tabulated in §1a below.

| Font | File | Cell h | Widths | Line pitch (h+3) | Style | Role / where used | Tier |
|------|------|--------|--------|------------------|-------|-------------------|------|
| **FONTTINY** | `FONTTINY.FF` (`@0x1FD32`) | 6 | **proportional 2–6** (most 4; space/`i`/`l` 2; `M`/`W`/`m`/`w` 6) | 9 | mixed-case | **default body / HUD** (boot latch `[0x89E]`): inventory qty, yields, sidebar numbers, advisor bodies, popup bodies | **B** (load + metrics) |
| **FONTINTR** | `FONTINTR.FF` (`@0x1FD29`) | 9 | proportional 3–9 | 12 | chunky 3-D | **intro / title / boot menu** plaques | **B** |
| **FONTKING** | `FONTKING.FF` (`@0x1FCCB`) | 7 | proportional 2–8 | 10 | mixed-case | **king-defeats screen ONLY** — `FONTKING`@0x232b referenced exactly once (`lea bx,[0x232b]` @0x754F2 in `func_075352`); never cached to a global (RULING 2026-06-21) | **B** |
| **FONT-NP** | `FONT-NP.FF` (`@0x1F8AF`) | 8 | proportional 5–11, **uppercase A–Z only** | 11 | uppercase | **national-power** / speaker name-plate | **B** |
| ~~FONTSMAL~~ | `FONTSMAL.FF` | 6 | (2–8, digits+letters) | — | — | **ORPHAN — never loaded by VICEROY.EXE**; the `SMALLFONT`/`@smallfont` directive does *not* load it | (refuted) |

> *(Corrects the earlier "6 × 4 fixed" / "9 × 6 fixed" claims — all four fonts are proportional;
> the fixed-width reading came from the off-by-one table decode fixed in §1b. The "per-glyph
> FONTTINY width (proportional advance)" note in `menus.md` §Customize was the correct one.)*

### 1a. Per-glyph width tables (B — decoded from the assets; authoritative copy in `data_extracted/fonts/ff_metrics.json`)

Advance = width (each glyph bitmap carries its own trailing spacing column); string width =
Σ width(ch); line pitch = cell height + 3 (`@0x3AB7`). Chars absent from a table have width 0
(no glyph). Space widths: FONTTINY 2, FONT-NP 5, FONTKING 2, FONTINTR 3.

**FONTTINY** (h=6, space=2) — every non-zero width:
`!`4 `"`4 `#`4 `$`4 `%`4 `&`4 `'`2 `(`4 `)`4 `+`4 `,`4 `-`4 `.`4 `/`4 digits `0`–`9` all 4
`:`4 `;`4 `?`4 · `A`–`Z` all 4 except **`M`6 `W`6** · `[`6 `]`6 ·
`a`–`z` all 4 except **`i`2 `l`2 `m`6 `w`6 `t`3** · `'`2.

**FONT-NP** (h=8, space=5, uppercase only):
`A`8 `B`7 `C`7 `D`9 `E`7 `F`8 `G`9 `H`10 `I`5 `J`6 `K`9 `L`7 **`M`11** `N`10 `O`8 `P`7 `Q`8 `R`9
`S`5 `T`7 `U`9 `V`9 **`W`11** `X`9 `Y`9 `Z`7.

**FONTKING** (h=7, space=2):
`!`4 `"`4 `$`4 `%`4 `(`4 `)`4 `+`4 `,`4 `-`4 `.`4 `/`4 · `0`5 `1`3 `2`6 `3`6 `4`6 `5`6 `6`6 `7`5
`8`7 `9`6 · `:`4 `;`4 `?`6 · `A`5 `B`6 `C`5 `D`6 `E`5 `F`4 `G`5 `H`5 `I`6 `J`5 `K`7 `L`6 **`M`8**
`N`6 `O`6 `P`5 `Q`6 `R`6 `S`6 `T`5 `U`5 `V`6 **`W`8** `X`6 `Y`6 `Z`5 · `a`4 `b`4 `c`4 `d`4 `e`4
`f`4 `g`4 `h`5 `i`2 `j`4 `k`5 `l`2 `m`6 `n`4 `o`4 `p`4 `q`4 `r`4 `s`5 `t`3 `u`4 `v`4 `w`6 `x`4
`y`5 `z`4.

**FONTINTR** (h=9, space=3):
`!`3 `"`5 `#`7 `$`7 `%`9 `&`7 `'`3 `(`5 `)`5 `*`7 `+`5 `,`3 `-`5 `.`3 `/`9 · digits `0`–`9` all 6
· `:`3 `;`3 `<`6 `=`5 `>`6 `?`5 `@`9 · `A`6 `B`6 `C`6 `D`6 `E`6 `F`5 `G`6 `H`6 `I`3 `J`6 `K`6 `L`5
`M`7 `N`6 `O`7 `P`6 `Q`7 `R`6 `S`7 `T`5 `U`6 `V`6 `W`7 `X`7 `Y`5 `Z`6 · `[`8 `]`8 `_`7 · `a`6 `b`6
`c`5 `d`5 `e`5 `f`5 `g`6 `h`5 `i`3 `j`5 `k`5 `l`3 `m`7 `n`5 `o`5 `p`5 `q`6 `r`5 `s`6 `t`4 `u`5
`v`5 `w`7 `x`6 `y`5 `z`5.

**FONTSMAL** (h=6, space=3 — orphan, for completeness):
`#`6 `.`6 digits 6 · `A`7 `B`–`H` 6 `I`3 `J`–`L`6 `M`8 `N`8 `O`7 `P`6 `Q`8 `R`,`S`6 `T`,`U`,`V`7
`W`8 `X`,`Y`7 `Z`6 · lowercase mirrors uppercase.

*(Generated from `data_extracted/fonts/ff_metrics.json` — do not hand-edit these lists; regenerate
from the JSON, which is the machine-readable source a rebuild should consume.)*

### 1b. Rasteriser + the `ch−1` slot mapping + ink→colour LUT (B, 2026-07-28)

The resident blit_string core **`func_00E51C`** (file `0x00E51C`; reached via `0x181F:0x1FA` and
the `func_002AC6..002C82` wrapper family that pushes the `[0x89E]:[0x8A0]` font latch):

- **Slot mapping:** the engine indexes the font tables with **`ch−1`** — `dec dl` `@0x00E5DA`,
  width `mov al,[bx+si+2]` `@0x00E5E9` (= `font[2+(ch−1)]`), glyph offset
  `mov si,[bx+si+0x82]` `@0x00E606`. The `.FF` width/offset tables therefore hold char `j+1`
  in slot `j` (bitmap-render-proven; `formats/FF.md` corrected 2026-07-28 — the prior
  `width[char]` reading was off by one and produced the bogus "fixed-width" metrics).
- **Ink→colour:** glyph pixels are 2 bpp levels 0–3 (`shl ax,2` `@0x00E629`); each level maps
  through a **4-entry palette-index LUT at far `[0x269E]:[0x26A0]`** (captured to the frame
  `@0x00E532`, applied `mov ah,[bp+si−6]` `@0x00E632`), and a LUT entry of **`0xFF` = transparent**
  (`cmp ah,0xFF` `@0x00E637`). A string's colour = the 4-byte LUT contents at draw time (set via
  `func_00E68A`; see §3 "Popup body" for the popup path). Anti-aliased fonts thus render with
  up to 3 ink shades per call.

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
setter `func_06C296` populates from caller args — see §3 "Popup body" (fully resolved).**

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
| Popup body | FONTTINY (latch; `SMALLFONT` just copies it) | **resolved-as-state — NOT a literal `0x0F`.** The body glyph blit is the no-color-arg proportional renderer `func_00E51C` (`181F:01FA` @0x00E51C; reseg'd from VICEROY.EXE — committed disasm truncated at 24B); it reads its pen from the 4-byte glyph color-map global `[0x269E..0x26A1]`, set by `func_00E68A` (`181F:01F0` @0x00E68A: `mov [0x269e],cl` / `[0x269f],dl` / `[0x26a0],al` / `[0x26a1],al`). For the popup body that map is loaded by wrapper `func_06C346` @0x6C346, called from the body-draw `func_06C388` @0x6C3A5, which selects the pen from the **section-struct color fields** `es:[bx+4]` (highlight, ax=bx&1), else `es:[bx+6]` (when state latch `[0x1F62]`≠0), else `es:[bx+2]`, plus `+8`/`+0xa` — all populated as caller args by the section-init setter `func_06C296` @0x6C2A5–0x6C2C1. So body text color is per-section runtime state (typically the latched body pen), not a hardcoded index. **No `TEXTCOLR` override exists — byte-confirmed: the dialog parser `func_06F0F4` @0x6F0F4 dispatches exactly **10** directives (OPTIONS/PROMPT/TEXT/SMALLFONT/**X**/**Y**/WIDTH/LENGTH/CHECKBOX/DEFAULT — count corrected 2026-07-28, `dialog_framework.md` §2) via the `lcall 0xd1d:0x816` strcmp chain @0x6F1B0–0x6F37D and never compares the `TEXTCOLR` string (file 0x1F9AA / DGROUP off 0x200A; zero code-xref)** | B (renderer/source) / state (color) |
| Speaker name-plate | FONT-NP (loaded with WOODFRAM/NAMEPLAT) | overlay-resident draw via a runtime-patched thunk; color = FONT-NP intrinsic ink vs the loaded NAMEPLAT/WOODFRAM panel palette — **A (anchor; the literal RGB needs a DOS pixel sample, out of scope)** | A |

## 4. Residual — honest list (2026-07-28 revision)

*(The prior "Residual — none (font/color is fully static)" header contradicted §3's own A/state
rows and is retracted.)* What is **B**: font loads + metrics (§1/§1a), the rasteriser + ink→LUT
mechanism (§1b), push-arg colours + PIK-palette RGB resolution (§2), and the per-screen font
latches (§3). Still open, each with its exact closer:

1. **Colony/Europe title-bar RGB** — §3 lists both "title green (82,138,49)" and "yellow
   (218,178,0)" from different captures. Closer: trace the title draw's `[0x269E]` LUT load
   (§1b gives the lever) or one matched DOS pixel sample. **A, unreconciled.**
2. **King-defeats text RGB** — no per-call palette arg; now known to be the `[0x269E]` LUT
   contents on the `func_075352` path. Closer: trace that path's `func_00E68A`-family LUT store
   (static, newly tractable via §1b). **A → statically closable.**
3. **Popup body colour** — per-section state fields `es:[bx+2/4/6]` (mechanism fully B in §3);
   the *typical* literal per popup family is unverified. Closer: trace `func_06C296` callers'
   pushed args per family. **state/B(mechanism).**
4. **Speaker name-plate RGB** — FONT-NP intrinsic ink through the loaded panel palette.
   Closer: one DOS pixel sample, or the NAMEPLAT palette + §1b LUT trace. **A.**
5. **Boot-menu plaque font latch** — FONTINTR vs FONTTINY at that moment is latch-order
   dependent. Closer: trace `[0x1F9E]` writes on the boot path. **A → statically closable.**

Palette **cycling** (water shimmer) remains a documented animation effect
(`docs/PALETTE_AND_CYCLING.md`), not an unknown. Index→RGB resolution is static from the `.PIK`
palette (§2).
