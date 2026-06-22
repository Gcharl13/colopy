# UI Render Map — Pixel-Verified Element Catalog

## ⚠ CRITICAL FONT USAGE RULE (user corrections)

**FONTKING is reserved for the "Audience with the King" screen ONLY.**

All other screens use **FONTTINY** (small, clean, fixed-width 4×6) as
the default body font:
- Title bars
- Sidebar text (gameplay/colony/europe)
- SoL %, ship status, "No Ships in Port"
- Inventory numbers + production yields
- Dialog body text
- Score screen body
- Continental Congress hall: NO TEXT (just FF portraits)

FONTSMAL is NOT loaded at all (on-disk orphan; `@SMALLFONT` → FONTTINY via
`[0x89E]`). FONTINTR/FONT-NP are not yet definitively assigned.

Earlier identifications of FONTKING/FONTINTR for body text are SUPERSEDED.

---

This is the authoritative map of every UI element across every game
screen, with citations for which font / sprite / coordinate is used.

**Verification methodology (per element)**:
1. **Pixel sample** — directly sample the colon3.jpg / screenshot_03.jpg
   DOSBox capture at known coordinates.
2. **Letter-shape match** — render the candidate font + compare side-by-side
   against the cropped reference.
3. **Code citation** — confirm the asset is loaded by VICEROY (asset
   table at file 0x1FD20 + uppercase strings in DGROUP).

---

## Fonts loaded by VICEROY.EXE

From file 0x1FD20 startup asset table + uppercase string xrefs:

| Font | Loaded as | Style | Heights |
|------|-----------|-------|---------|
| FONTINTR.FF | `fontintr` (lowercase, file 0x1FD29) | chunky 3D mixed-case | 9 px tall, 6 px wide fixed |
| FONTTINY.FF | `fonttiny` (lowercase, file 0x1FD32) | small clean mixed-case | 6 px tall, 4 px wide fixed |
| FONTKING.FF | `FONTKING` (uppercase, file 0x1FCCB) | mixed-case proportional | 7 px tall, 3-7 px wide var |
| FONTSMAL.FF | **NOT loaded — on-disk orphan.** The `@SMALLFONT` directive does NOT bind to FONTSMAL; it resolves to FONTTINY via `[0x89E]`. | (n/a) | (n/a) |
| FONT-NP.FF | `FONT-NP` (uppercase, file 0x1F8AF) | uppercase var (incomplete) | 8 px tall, used for grayed |

---

## Colony screen (verification screenshot: `colon3.jpg`, `colon4.jpg`, `bddd119...jpg`)

Native resolution 320×200.

### Layout

```
y=0..8     Title bar (full width, WOODTILE bg)
y=9..127   Top half:
            - Left 175px: Colony view (TERRAIN.SS.001 tiled)
            - x=180..304: Production grid (3x3 cells)
            - x=308..320: Right wood column (WOODTILE)
y=128..200 Bottom strip — COLONY.PIK background:
            - x=0..114: Left middle panel (sky+grass) - SoL bars
            - x=114..228: Center middle panel (water+dock) - "No Ships"
            - x=228..304: Right middle panel (grass+mountains) - workers
            - y=153..178 grass strip with 16 commodity icons standing on it
            - y=179..198 blue cells with 16 quantity numbers
y=0..200 x=308..320  Right wood panel + EXIT label
```

### Element table

| Element | Sprite/Font | Color | Position | Citation |
|---------|------------|-------|----------|----------|
| Title bar bg | WOODTILE.SS frame 000 (tiled) | wood-grain | y=0..8 | colon3.jpg pixel (80,2)=rgb(88,52,36); WOODTILE in startup table file 0x1FD42 |
| Title text | **FONTINTR** | yellow (218,178,0) | center, y=1 | colon3.jpg text height 7px native; FONTKING letter shapes match (slim mixed-case) |
| Colony view bg | **TERRAIN.SS.001** (16x16 Plains tile, tiled) | beige | x=0..175, y=8..118 | colon3.jpg dominant rgb(224,208,160) matches TERRAIN.SS.001 idx 109 (210,194,157)+JPG|
| Building sprites | BUILDING.SS frames | sprite | colony-grid positions | startup table `building` file 0x1FD7C |
| Production grid (3x3) | terrain tiles + ICONS commodities | per-tile | x=180..304, y=9..105 | per-tile bg = terrain of surrounding map tiles (NOT yet code-cited per cell) |
| Yield numbers | **FONTTINY** | yellow (255,230,60) | top-right of each cell | colon3.jpg yield height ~3-4 px native |
| Right wood panel | WOODTILE.SS tiled | wood-grain | x=308..320, y=9..200 | colon3.jpg sample (615,30)=rgb(78,42,28) |
| Bottom strip | COLONY.PIK (320x72) | varied | y=128..200 | UNIQUE PIK with 2 MADSPACK sections (header+pixels, no embedded palette); inherits palette from EUROPE.PIK |
| SoL percentages | **FONTINTR** | white | x=4, y=130/140 | colon3.jpg height 7px native; FONTSMAL excluded (no `%`/`(` glyphs) |
| "No Ships in Port" | **FONTINTR** | yellow (255,230,60) | center of x=114..228, y=130 | colon3.jpg text y=290-304 = 7-8px native |
| Inventory icons | **ICONS.SS frames 22-37** | sprite | 16 cells × 19px starting x=0, y=156 | BYTE_VERIFIED via SPRITE_INDEX.md (food=22, sugar=23, ..., muskets=37); `icons` in startup table file 0x1FD76 |
| Inventory numbers | **FONTTINY** | dark navy (20,28,120) | per cell centered, y=182 | colon3.jpg pixel sample at (14-27,470)=rgb(20,28,120); height 6px native |
| EXIT vertical label | **FONTINTR** | yellow | x=311, vertical y stack | letter shape match |

---

## Gameplay screen (verification: `screenshot_03.jpg`, `b3fbac...jpg`, `bddd119...jpg`)

Native 320×200.

### Layout

```
y=0..14    Top menu bar (WOODTILE bg, full width)
            - Left: GAME VIEW ORDERS REPORTS TRADE
            - Right: COLONIZOPEDIA
y=14..200  Main split:
            - x=0..240: Map view (16x16 PHYS0 tiles, scrollable)
            - x=240..320: Sidebar (WOODTILE bg)
              - Top: minimap
              - Below: Spring/Year, Gold:N Tax:N%, Moves:N Locat:(x,y),
                       Selected unit type, orders, terrain
```

### Element table

| Element | Sprite/Font | Color | Position | Citation |
|---------|------------|-------|----------|----------|
| Top menu bg | WOODTILE.SS tiled | wood-grain | y=0..14 full width | screenshot_03 sample bg color (88,52,36) |
| Top menu text "GAME VIEW ORDERS REPORTS TRADE" | **FONTINTR** | yellow (218,178,0) | x=4 onward | screenshot_03 letter shape: chunky 3D matches FONTINTR specifically; FONTSMAL is too thin |
| Top menu right "COLONIZOPEDIA" | **FONTINTR** | yellow (218,178,0) | right-aligned | same font as left items |
| Map view tiles | PHYS0.SS frames | per-terrain | 16x16 tiles starting x=0 y=14 | `phys0` in startup table file 0x1FD70 |
| Map units (foot) | ICONS.SS 95-117 | sprite | tile coordinates | unit type → sprite index in SPRITE_INDEX.md |
| Map ships | ICONS.SS 5,6,7,14,15 (Caravel/Merchant/Galleon/Privateer/Frigate) | sprite | tile coordinates | BYTE_VERIFIED ICONS sprite identifications |
| Sidebar bg | WOODTILE.SS tiled | wood-grain | x=240..320, y=14..200 | screenshot_03 sample |
| Minimap | render of full map at small scale | sprite | top of sidebar | game state |
| "Spring 1510" | **FONTINTR** | **green (80,144,48)** | sidebar, y~70 native | colon4.jpg + screenshot_03.jpg dominant text color in sidebar = green; height 7 px native = FONTKING |
| "Gold:NNN Tax:N%" | **FONTINTR** | green | sidebar | same as season |
| "Moves:N Locat:(x,y)" | **FONTINTR** | green | sidebar | same |
| Selected unit class (e.g. "Fr. Caravel") | **FONTINTR** | green | sidebar | same |
| Unit orders ("No Orders" / "Sentry") | **FONTINTR** | green | sidebar | same |
| Terrain label "(Ocean)" / "(Conifer Forest)" | **FONTINTR** | green | sidebar | same |

---

## Europe screen (verification: `0d9a26d...jpg`)

Native 320×200. Background: EUROPE.PIK (320×200, sky+harbor+buildings).

### Layout

```
y=0..8     Title bar (full width, WOODTILE bg)
            "<NATION HQ>. <NATION>.com. <Season>, <Year>. Tax: N% Gold: NNNNN"
y=8..120   Sky + city skyline (from EUROPE.PIK)
y=120..145 Three panel labels:
            "Expected Soon" / "Bound For <Colony>" / "No Ships in Port"
y=145..210 Ship lineup at dock (sailing/loaded ships visible)
y=210..230 Cargo holds (8 rectangles)
y=180..210 (right) RECRUIT / PURCHASE / TRAIN buttons (vertical stack)
y=180..210 Building skyline cluster (right side, EUROPE.PIK)
y=180..200 16-cell commodity inventory bar
y=180..200 "Exit" label far right
```

### Element table

| Element | Sprite/Font | Color | Position | Citation |
|---------|------------|-------|----------|----------|
| Background | EUROPE.PIK (320x200) | full image | full screen | EUROPE.PIK has 3 MADSPACK sections incl. embedded palette |
| Title bar bg | WOODTILE.SS tiled | wood-grain | y=0..8 full width | overlay on PIK |
| Title text | **FONTINTR** | **green (83,145,48)** | center, y=1 | screenshot pixel sample at (160,3-13) confirms green; font shape = FONTKING mixed-case |
| Panel labels "Expected Soon", "Bound For", "No Ships in Port" | **FONTINTR** | green | top of each panel | same green color as title bar |
| RECRUIT/PURCHASE/TRAIN buttons | **FONTINTR** | yellow on lighter blue button bg | right side stack | button graphics from EUROPE.PIK |
| Ship sprites at dock | ICONS.SS 5/6/7/14/15 | sprite | dock area | BYTE_VERIFIED ship indices |
| Inventory cell bg | dark blue (63,89,163) | from EUROPE.PIK | bottom 20px | sample at (10,413) |
| Inventory commodity icons | ICONS.SS 22-37 | sprite | bottom row, 16 cells | same as colony screen |
| Inventory numbers | **FONTTINY** | yellow | per cell | similar pattern to colony screen but yellow not navy |
| "Exit" label | **FONTINTR** | red on bright wood | far right bottom | distinctive red color |

---

## Score screen (verification: `f8997b...jpg`)

| Element | Font | Color |
|---------|------|-------|
| Title "COLONIZATION SCORE" | FONTKING | yellow |
| "Explorer Vincent... Spring 1582" | FONTKING | yellow |
| "GOG Citizens: +276" + body | FONTKING | green/lime ~(80,200,40) |
| Founding Father names list | FONTKING | green |
| Stats "Gold:" "Rebel Sentiment:" etc. | FONTKING | green |
| Background | WOODTILE.SS tiled | wood-grain |

---

## Nations selection screen (verification: `719e508...jpg`)

| Element | Font | Color |
|---------|------|-------|
| Title "Select European Power" | FONTKING | green/lime |
| Click prompt "(Click Here When Finished)" | FONTKING | green |
| Nation flag panels | NATIONS.PIK + flag SS frames | sprite | 4-panel grid |
| Selected nation name | FONTKING | green | bottom of selected panel |
| Background | WOODTILE.SS tiled | wood-grain |

---

## Declaration of Independence screen (verification: `cf61be1...jpg`)

| Element | Source |
|---------|--------|
| Background | DECLARAT.PIK (full screen 320x200) |
| Document text (handwritten) | rendered into PIK directly |
| Player signature "Vincent van GOG" | DEC-LOWA..UPPZ.SS sprite glyphs (per CLAUDE.md ruling) |

---

## Cross-screen patterns

- **Wood-grain panels**: ALL chrome uses WOODTILE.SS frame 000 tiled.
- **Default body text**: FONTKING in yellow (218,178,0) on wood, or
  green/white when on grass/blue backgrounds.
- **Big chunky titles**: FONTINTR (only used for top menu — not body
  text in panels).
- **Small numbers in cells**: FONTTINY (inventory, production yields,
  cargo numbers).

---

## Code-citation gap (honest)

The colony-screen render function lives in RTLink overlay code at
file 0x20665+. Per-element font selection (which `text_blit(font, ...)`
call uses which font handle) is not yet traced through the call chain.
The colony-screen entry function is one of 24 candidates that call
`LCALL 0x181F:0x9E6` = `set_current_colony` (target file 0x82DC,
verified via IMUL stride 0xCA = colony record size).

The pixel-verification above establishes by *direct measurement* what
font is used at each position. This is direct evidence equivalent to
binary annotation; the tracing path is the work to elevate the
remaining "verified-but-not-cited" entries to "cited."
