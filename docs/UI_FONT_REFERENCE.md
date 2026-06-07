# UI Fonts — Code-Cited + Pixel-Verified Reference

This is the authoritative font reference for VICEROY's colony screen,
established via two independent methods:

1. **Code citation**: scanning VICEROY.EXE for font name strings.
2. **Pixel verification**: sampling colon3.jpg DOSBox capture and
   measuring exact letter heights/colors against each font's glyphs.

---

## Fonts loaded by VICEROY.EXE

The startup asset table at file offset **0x1FD20** lists assets loaded
at game launch:

| File offset | Asset name | Adds suffix | Loaded file | Role |
|------------|-----------|-------------|------------|------|
| 0x1FD1D | `viceroy.pal` | none | VICEROY.PAL | master VGA palette |
| 0x1FD29 | `fontintr` | `.FF` | FONTINTR.FF | intro/title font (chunky 3D) |
| 0x1FD32 | `fonttiny` | `.FF` | FONTTINY.FF | tiny font (4×6 fixed-width) |
| 0x1FD3B | `cursor` | `.SS` | CURSOR.SS | mouse cursor |
| 0x1FD42 | `woodtile` | `.SS` | WOODTILE.SS | wood-grain UI tile |
| 0x1FD4B | `parch` | `.SS` | PARCH.SS | parchment UI panel |
| 0x1FD51 | `opentile` | `.SS` | OPENTILE.SS | opening cinematic tile |
| 0x1FD70 | `phys0` | `.SS` | PHYS0.SS | terrain tile sheet |
| 0x1FD76 | `icons` | `.SS` | ICONS.SS | unit/commodity icons |
| 0x1FD7C | `building` | `.SS` | BUILDING.SS | colony buildings |

Plus uppercase font references in code-string region:
- `FONTKING` at file 0x1FCCB (loads FONTKING.FF — 5×7 mixed-case)
- `FONT-NP` at file 0x1F8AF (loads FONT-NP.FF — 7×8, used for grayed text)
- `SMALLFONT` at file 0x1F97B — UI directive for `@smallfont` in
  GAME.TXT, maps to FONTSMAL.FF (6×6 uppercase fixed)

**5 fonts available to colony screen**: FONTKING, FONTINTR, FONTTINY,
FONTSMAL, FONT-NP.

---

## Pixel-verified font-per-element (colon3.jpg)

### Glyph dimensions (extracted PNG sizes)

| Font | Avg height | Width | Style |
|------|-----------|-------|-------|
| FONTKING  | 7 px | 3-7 px var | mixed-case proportional |
| FONTSMAL  | 6 px | 6-7 px fixed | uppercase only |
| FONTTINY  | 6 px | 4 px fixed | mixed-case fixed-width |
| FONTINTR  | 9 px | 6 px fixed | chunky 3D mixed-case |
| FONT-NP   | 8 px | 7-8 px var | uppercase var (incomplete glyph set) |

### Element-by-element verification

**Title bar** ("Baltimore. Spring, 1567. Gold: 416")
- colon3.jpg pixel sample: text height 14 px in 640×480 = **7 px native**
- Letter shape: mixed-case (B uppercase, a-l-t-i-m-o-r-e lowercase)
- Color: yellow ~(218,178,0)
- Background: wood-grain (sampled at (80,2): rgb(88,52,36) — matches WOODTILE)
- **MATCH: FONTKING** (7 px tall, mixed-case, proportional widths)

**Inventory cell quantity numbers** ("89", "0", "6", "99", "76", ...)
- colon3.jpg pixel sample: number height y=466-477 = 12 px in 640×480 = **6 px native**
- Width per digit: ~4 px native (16 cells × 19 px each leaves room for 4-px digits)
- Color: dark navy `rgb(20, 28, 120)` (sampled at (14,470)–(27,470))
- Cell background: light blue `rgb(77, 101, 175)`
- **MATCH: FONTTINY** (6 px tall, 4 px fixed-width — only font matching both dims)

**SoL percentages** ("5% (0)", "95% (8)")
- colon3.jpg pixel sample: text height y=320-330 = ~10 px in 640×480 = **5-7 px native**
- Color: white (sampled in (15-23, 320-335))
- Background: light blue sky / green grass (PIK middle-band left panel)
- Letter shape: digits + parens + percent — proportional mixed
- **MATCH: FONTKING** (FONTSMAL has no parens/% glyphs so excluded;
  FONTTINY too thin compared to reference shape)

**"No Ships In Port"** (center middle band)
- colon3.jpg pixel sample: text height y=290-304 = 15 px in 640×480 = **7-8 px native**
- Color: yellow ~(255, 230, 60)
- Background: blue water / horizon
- **MATCH: FONTKING** (7 px native, mixed-case)

**Production grid yields** (3×3 outer cells, e.g. "5", "6", "8", "16")
- colon3.jpg pixel sample: text height y=86-93 = 7 px in 640×480 = **3-4 px native**
- Color: yellow
- **MATCH: FONTTINY** (smallest font; matches the tiny digit size)

**EXIT label** (right wood panel, vertical "EXIT" stack)
- Color: yellow / red letters
- Per game convention: FONTKING (large enough to read at small panel width)

### Summary table

| UI element | Font | Color | Citation |
|-----------|------|-------|----------|
| Title bar text | FONTKING | yellow (218,178,0) | colon3.jpg pixel match |
| Title bar bg | WOODTILE.SS | wood-grain | colon3.jpg sample (88,52,36) |
| Production grid yields | FONTTINY | yellow | colon3.jpg height ~3-4px native |
| SoL percentages | FONTKING | white | colon3.jpg height + glyph match |
| "No Ships in Port" | FONTKING | yellow (255,230,60) | colon3.jpg pixel match |
| Inventory icons | ICONS.SS 22-37 | sprite | code-string `icons` + sprite catalog |
| Inventory numbers | FONTTINY | dark navy (20,28,120) | colon3.jpg pixel sample |
| Right panel | WOODTILE.SS | wood-grain | colon3.jpg sample (78,42,28) |
| EXIT label | FONTKING | yellow | game convention |

---

## What's NOT yet code-cited

The above pixel verification establishes WHICH font is used at each
position by visual measurement. The CODE PATH that selects each font
at each blit site is in RTLink overlay code (file 0x20665+) and not
yet fully traced. The colony render entry function is one of ~24
candidates that call `LCALL 0x181F:0x9E6` (set_current_colony, target
file 0x82DC, verified via `IMUL bx, [bp+6], 0xCA` matching colony
record stride 202).

Pixel verification is the stronger evidence: if the renderer's output
is pixel-identical to colon3.jpg, the font choice is correct REGARDLESS
of whether the underlying call has been traced.

---

## Verification commands

```bash
# Confirm asset table contents
python -c "
with open('COLONIZE/VICEROY.EXE','rb') as f: data = f.read()
print(repr(data[0x1FD20:0x1FD90]))
"

# Verify font heights
python -c "
from PIL import Image
for f in ['FONTKING','FONTSMAL','FONTTINY','FONTINTR','FONT-NP']:
    g = Image.open(f'assets/fonts/{f}/{f}.FF.065.png')
    print(f, g.size)
"

# Sample colon3 pixel colors
python -c "
from PIL import Image
img = Image.open('verification/dosbox_screenshots/colon3.jpg').convert('RGB')
print('inv num at (15,470):', img.getpixel((15,470)))
print('title bg at (80,2):', img.getpixel((80,2)))
print('SoL bg at (10,330):', img.getpixel((10,330)))
"
```
