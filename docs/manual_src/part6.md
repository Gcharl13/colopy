## 25. UI engine — draw primitives, dialog framework, popups, menus

Every screen in the 1994 binary is painted through one resident draw-verb library (the far-call
window `0x181F:NNNN`, resolved through the RTLink thunk table at file 0x1A5F0–0x1B5EF; a type-B
thunk resolves as `target_file_offset = 0x2400 + (jmpf_seg<<4) + jmpf_off`). On top of the verbs
sit four engine layers: the `@`-directive dialog framework (every GAME.TXT template dialog,
plaque, and list menu), the gameplay-popup engine (speaker portraits + modal wait), the
pulldown-menu engine of the in-game map bar, and the mouse/keyboard input pipeline. This section
documents each layer to rebuild precision; §26 then applies them screen by screen.

### 25.1 The draw-verb vocabulary (`0x181F:NNNN`)

Text verbs split into two colour families: the **global-colour** family (`func_002Axx`) takes no
colour argument — the pen colour is the screen-level latch byte `[0x830]` (with `[0x831]` as the
hilite slot); the **explicit-colour** family (`func_002Bxx`) takes the colour as a push argument.
Both bottom out in the string rasteriser core `func_00E51C` (`0x181F:0x1FA`), whose 2-bpp ink
levels map through the 4-entry LUT at `[0x269E]:[0x26A0]`.

| Thunk `0x181F:` | Target (file) | Class | Function |
|---|---|---|---|
| `0x1FA` | 0x0E51C | text core | proportional string rasteriser (`ch−1` glyph lookup, 2 bpp → ink LUT); all text bottoms out here |
| `0x204` | 0x0E6A6 | measure | pixel width of a string (Σ glyph widths) — the width source for every centred/right-aligned element |
| `0x22`  | 0x02462 | fetch | **string-fetch-by-id**: walks N NUL-terminated strings in the heap at `[0x2D42:0x2D44]` and returns a far ptr to string #N. Draws nothing (an early "fill_rect" gloss is wrong) |
| `0x100` | 0x02BC8 | text | **centred** text-in-box (args: colour, y, box-w, x) |
| `0x13C` | 0x02B38 | text | draw text at explicit (x,y) — explicit-colour |
| `0x132` | 0x02AFE | text | draw text at (x,y) — global-colour `[0x830]` |
| `0x150` | 0x02B72 | text | **right-aligned** draw (anchor x minus measured width; mechanism at 0x002B9F — the Colonizopedia "(Exit)" uses it) |
| `0x182` | 0x029DE | build | append a **decimal number** to the working string buffer |
| `0x1A0` | 0x02A06 | build | append a zero-padded number |
| `0x16E` | 0x02992 | build | strcat into the working buffer |
| `0x114` | 0x02AC6 | measure | measure/justify helper (right-align maths) |
| `0x11E` / `0x128` | 0x02922 / 0x02932 | build | append literal `(` / `)` (glyph pool at file 0x1D9F0+, DGROUP 0x5E/0x60) |
| `0x1BE` | 0x028F2 | build | append `": "` (DGROUP 0x55) |
| `0x146` / `0x15A` | 0x02962 / — | build | append `+` (DGROUP 0x66) / `−` (DGROUP 0x68) |
| `0x178` | 0x028B0 | build | append `" "` (DGROUP 0x50) |
| `0x196` | — | build | append `" "` × N (repeat-space) |
| `0xE2`  | 0x0DB3A | sprite/present | **clipped sprite/cell blit** from sheet ctx `[0x2DA8]` — used both for element frames and as the "present composed rect" step (`push h; push w; push x`). NOT a line rule |
| `0x254` | 0x0E76A | sprite | **blit ONE sprite**. Convention: `AX` = frame (bit 15 = H-mirror), `DX` = x, stacked args = y + far sheet handle, `BX` = &surface-ctx (`0x2DA8` screen / `0x839E` work surface). Reads frame header `[bx]`=w−1, `[bx+2]`=h−1 |
| `0x24A` / `0x1468` / `0x18F8` | 0x0380C / 0x0D9E0 / 0x0DB80 | sprite | blit variants |
| `0x2BC` | 0x0386A | sprite | **per-unit info panel** composite (unit figure + condition) — map sidebar, Europe ship rows, F6/F7 reports, pedia UNIT page |
| `0x222` / `0x22C` / `0x218` | 0x033F2 / 0x03104 / 0x03193 | sprite row | enqueue icon+count (`0x222`, row counter `[0x2CE0]++`), open row (`0x218`), **flush** the accumulated row left-to-right into a fixed span (`0x22C`, `push 4` columns, span `bx=0x12C`=300) |
| `0x236` | 0x02EE4 | sprite row | **proportional filled/empty icon strip**: `count` filled sprites (AX) tiled across a span, pitch `(span−w)/(count−1)` clamped `[1, w+1]`, remainder = empty sprite 0x38 (hard-coded at 0x002FA5). The game's only "gauge" — there are no fill bars |
| `0x3C0` | 0x04A80 | modal | **wait-for-key/click loop** (~120-tick timeout at 0x4ADD, mouse region `[0x826]`/`[0x7F4]`). Draws NOTHING — the dialog builder paints the box first. Returns the key in DI |
| `0x444` | 0x0DCF6 | fill | rect block-fill / 2-D copy |
| `0x484` | 0x0DCD4 | fill | horizontal solid-colour span fill |
| `0xBA`  | 0x0DDEA | fill | **solid bar fill** (args `ax`=x, `dx`=y, `bx`=w; stack colour, h, sheet) — dialog interiors, highlight bars |
| `0xCE`  | 0x0E0A2 | rect | **1-px HOLLOW rectangle outline** (h/v-span helpers `0xBBC:0xC`/`0xBC3:6`) — selection boxes, dropdown row highlight. Never a filled cell |
| `0xC4`  | 0x0E350 | fill | **tiled fill** from a 4-word tile record (§25.2 fill-record system) |
| `0x510` | 0x0531C | blit | src→dst stretch blit; sole call site 0x0263D6 is the colony-scene ×1.5 upscaler (§26.8) |
| `0x590` / `0xDAE` | 0x0BCEA / 0x0BCAA | fill | span-fill + VRAM variants |
| `0x44E` / `0x438` | (overlay 0x76B9E) | load | **load_PIK by name** (appends ".PIK") / paired asset blit-by-name |
| `0x4C0` | — | sound | **gated sound play** (id gated on the sound-option globals; ids <0x10 = driver commands always pass) |
| `0x998` | 0x6F51A | engine | **menu_lookup_run**: given a section name + file ctx `[0x87C]`, builds the `@`-template via `0x191F:0x182` (parser) and runs it via `0x191F:0x16A` (modal pump), returning the 1-based chosen row in AX |
| `0x3FE` | 0x6F594 | engine | **GAME wrapper**: hardwires file `"GAME"` (`[0x87C]`), section name in BX, then runs the same `0x998` core — the verb behind `@BEGINMENU`, the options dialogs and every plain GAME.TXT popup |
| `0x652` | 0x6F5F2 | engine | **advisor popup**: as `0x3FE` but first sets the advisor portrait channel `[0x1F5E]` → `MSS<n>.SS` (tutorials, announcements); the companion `0x1A1F:0x688` = 0x6F61C sets the third channel `[0x1F60]` → `MYR<n>.SS` for conversations |
| `0x3CA` | 0x04B16 | hit | point-in-rect against mouse `[0x7E8]/[0x7EA]` (args x,y,w,h) |
| `0x35C` | 0x048CC | util | `clamp(v,lo,hi)` — NOT a draw (a mis-cite that propagated; corrected) |

### 25.2 The dialog framework (the `@`-template layout engine)

One engine on overlay page 0x17 lays out and runs every GAME.TXT `@KEY` dialog, popup body, boot
plaque and list menu: construct `func_06C520` (0x06C520) → template parser `func_06F0F4`
(0x06F0F4) → finalize/layout `func_06D316` (0x06D316) → modal pump `func_06E3D0` (0x06E3D0),
with row records appended by `func_044D16` (0x044D16, thunk `0x1A1F:0x33E`).

```c
typedef struct {                    // dialog struct (far ptr; les bx,[bp+4] in func_06D316)
    uint16_t pad0;                  // +0x00
    uint16_t option_count;          // +0x02 option-row count (inc @0x06CA2B via func_06C850)
    uint16_t text_count;            // +0x04 text-line count (inc @0x06CB87 via func_06CA82)
    uint16_t prompt_count;          // +0x08 third item-class count (func_06CB94)
    uint16_t flags;                 // +0x0A 0x10=borderless, 0x40=off-screen, 0x20=sibling, |=5 checkbox
    int16_t  req_x, req_y;          // +0x0C/+0x0E requested X/Y from @x/@y (−1 = centre sentinel)
    int16_t  x, y;                  // +0x10/+0x12 final on-screen X/Y (centre/clamp resolved)
    uint16_t w, h;                  // +0x14/+0x16 box W/H
    uint16_t rect[4];               // +0x18..+0x1E final absolute rect (stores @0x06D5B9)
    uint16_t longest_px;            // +0x20 longest-line pixel width
    uint16_t pad;                   // +0x22 = 4: option-row x-INDENT component (NOT outer width)
    uint16_t content_x0;            // +0x24 = (flags&0x10)?0:3; option row x = +0x24+inset+pad = box_x+9
    uint16_t row_y_seed;            // +0x26 = inset'(3)+border(3) = 6; += border+text_h if text present
    uint16_t width_floor;           // +0x28 content-width floor: init 0x50 (80), overridden by @WIDTH
    uint16_t text_x0, text_y0;      // +0x2A/+0x2C = 3 / 6; text line x = +0x2A+inset = box_x+5
    uint8_t  fill_c1, fill_c2;      // +0x3C/+0x3E fill pair ← [0x1F3C]/[0x1F3E] (TEXTCOLR.SS spr 1/2 pixels)
    uint8_t  sel_c1, sel_c2;        // +0x40/+0x42 selection-band pair ← [0x1F40]/[0x1F42] (boot 0x37)
    uint8_t  ring2_c;               // +0x44 ring-2 frame colour ← [0x1F44]
    uint16_t border;                // +0x46 = (flags&0x10)?0:3
    uint16_t inset;                 // +0x48 = (flags&0x10)?0:2
    uint16_t content_cursor;        // +0x4A content-height cursor (init 0; item y = border+cursor)
    uint16_t hit_row, hit_row2;     // +0x4C/+0x4E cursor: the row under the pointer (pump stores)
    void far *option_head;          // +0x54/+0x56 option-row list head
    void far *text_head;            // +0x58/+0x5A text-line list head
    void far *widget_head;          // +0x5C/+0x5E child/widget list (pump loop B; painter func_06DE6E)
    void far *prompt_head;          // +0x60/+0x62 prompt list head
    void far *submenu_or_sprite;    // +0x68/+0x6A attached submenu; on widget nodes = the ELEMENT
                                    //   SPRITE far-ptr the painter blits (func_06D938 @0x06D952)
    uint16_t ink_record[8];         // +0x74 5 ink words + font ptr, built by func_06C296:
                                    //   +2 normal ←[0x1F4A], +4 disabled ←[0x1F4C], +6 hilite ←[0x1F4E],
                                    //   +8 ←[0x1F50], +0xA ←[0x1F52], +0xC/+0xE font
    uint16_t key_lo, key_hi;        // +0x80/+0x82 identity key / @SMALLFONT font latch copy
    // +0x30..+0x3B, +0x50..+0x53, +0x64..+0x67, +0x6C..+0x73, +0x84.. unmapped
} Dialog;
```

**Template parser** `func_06F0F4` (ENTER 0x168): reads section lines, blank line = paragraph,
`@`-directive test `cmp byte [bx],0x40` at 0x06F193. Exactly ten live directives (keyword pool at
file 0x1F967, DGROUP base delta 0x1D9A0): `OPTIONS` (mode 2 — option rows), `PROMPT`, `TEXT`
(mode 1 — body), `SMALLFONT` (copies the current font latch `[0x89E]/[0x8A0]` into `+0x80` — it
does NOT load FONTSMAL, which is never loaded by the binary), `Y` → `+0x0E`, `X` → `+0x0C`,
`WIDTH` (pixel content-width **floor** → `+0x28`; "WIDTH\0" at file 0x1F989), `LENGTH`
(text-entry max → `[0xA5B6]`), `CHECKBOX` (`flags |= 5`), `DEFAULT` (pre-highlighted row index —
an index, not a colour). The eleventh pool string `TEXTCOLR` (file 0x1F9AA) is never compared by
the parser — it is the sheet name for the **TEXTCOLR.SS colour-table load** in `func_06F6DA`
(0x06F6F0): sprite-pixel reads there seed the ink globals `[0x1F3C..0x1F4E]`.

**Box geometry** `func_06D316` (0x06D316..0x06D889):

```text
content_w = max(@WIDTH[+0x28], longest_line_px[+0x20], [+0x34])         ; clamp @0x06D392
box_w     = content_w + 2*border(3)                                     ; @0x06D4D0/@0x06D4E5 — NO pad term
box_h     = 2*content_cursor[+0x4A] + border[+0x46], item-driven        ; @0x06D35F..0x06D369
X = (req_x == -1) ? 160 - W/2 : req_x                                   ; @0x06D522
Y = (req_y == -1) ? 100 - H/2 : req_y                                   ; @0x06D53B
clamp: right > 0x140 shift left @0x06D563 ; bottom > 0xC8 shift up @0x06D571
negative left/top -> error logger 0x181F:0x772 @0x06D5AD
```

Vertical layout: text block pens from `+0x2C` (box-relative 6) with **text-line pitch =
glyph_h + 1** (0x06D07E); if text is present the option seed bumps `+0x26 += border(3) + text_h`
(0x06D440). Option rows sit at x = box_x+9, text/title lines at box_x+5; option text draws at
row-pen+1 (0x06DB8C). **Row pitch = clamped_glyph_h + border**: the pitch helper `func_06CD66`
(0x06CD66) returns the font cell height **clamped 6→5 on bordered dialogs** (`[0x1F8A]==0`,
latched at pump entry 0x06E3F6), so a bordered FONTTINY dialog has pitch 5+3 = **8 px**
(borderless: 6). Boot-menu check: `@y=91`, 1 title line → title top 91+6 = 97; first option top
91+6+3+6+1 = 107. Return AX=0 laid out, AX=1 empty-item bail.

**Modal pump** `func_06E3D0` (thunk `0x191F:0x16A`): hit-tests the frame bbox `+0x10..+0x16`
against mouse `[0x7E8]/[0x7EA]` with gates `[0x7F6]/[0x7F0]`; loop A walks the option list from
`+0x54` at y-seed `+0x26` with the 8-px pitch above (disabled rows — node flag bit 0 — are
skipped; the hit row lands in `+0x4C/+0x4E`); loop B walks widgets from `+0x5C` (row top =
dialog_y + inset + node[0], height = node[+2], action dispatch `call 0x3D26`). There is **no
universal x/y constant** — both are per-dialog struct state.

**Row records** (`func_044D16`, 0x16-byte nodes): `+0` flags (bit 0 = empty ⇒ skipped), `+2`
string-derived scalar, `+4` command id the row fires, `+6/+8` row text far-ptr, `+0x0E/+0x10`
NEXT, `+0x12/+0x14` PREV. Nodes carry **no screen coordinates** — row (x,y) is computed at
pump/paint time.

**Selection bar** (`func_06D9CC`, hit row == `+0x4C`): filled band at **(box_x+4, option_top−1,
content_w−2, glyph_h+2)** — boot menu: (81, 106, 158, 7) — colour `+0x40` ← `[0x1F40]` (boot
0x37; tiled instead if the byte is 7). Pixel-confirmed: the extra 2 px once measured on the left
was the box's own bevel column sharing palette index 0x37.

**Box paint chain** (driver `func_06E2DE` → box painter `func_06E0C8`, all chrome skipped when
flags&0x10): 1-px **black outline** (colour 0 pushed immediate, `0x181F:0xCE`); ring 2 inset 1
colour `[0x1F44]`; ring-3 **bevel** at inset 2 — light `[0x1F46]` top+right, dark `[0x1F48]`
left+bottom; interior fill (x+3, y+3, w−6, h−6) colour `[0x1F3C]/[0x1F3E]` via `func_06C18C`.

**Fill-record system:** `func_06C18C` (0x06C18C) takes the **tiled** path only when
`[0x1F6C] != 0` AND fill colour 1 == **7** (the wood-tile sentinel) — then `0x181F:0xC4` =
`func_00E350` tiles the 4-word record at near ptr `[0x1F6C]`, phase-anchored at the **box
origin** (`phase = |fill_xy − box_xy| mod (tile_w, tile_h)` at 0x00E371..0x00E3A2); otherwise a
flat `0x181F:0xBA` fill. The boot loader builds three 32×24 tile records: `[0x93F0]` ←
WOODTILE.SS spr 1 (0x07620F), `[0x93F8]` ← PARCH.SS spr 1 (0x07624D), `[0x9400]` ← OPENTILE.SS
spr 1 (0x07627C; literal "opentile" at file 0x1FD51); default `[0x1F6C]=0x93F0`. Two mode
setters: **in-game** at 0x073474 (inks from `[0x830..0x839]`, WOODTILE) and **boot/title** at
0x0734BC (text `[0x1F4A]=0xFE`, gold hilite `[0x1F4E]=0xFC`, disabled `[0x1F4C]=8`, ring
`[0x1F44]=0x2E`, bevel light `[0x1F46]=0xFD` / dark `[0x1F48]=0x37`, selection
`[0x1F40]=[0x1F42]=0x37`, **OPENTILE** `[0x1F6C]=0x9400`), invoked from the title composer at
0x075C52 right before the `@BEGINMENU` run. `[0x1F4E]=0xFC` at the boot menu is additionally
confirmed by a live RAM read (0x95 in-game — state-dependent).

**Ink selection per glyph** (`func_06C346`): disabled → `+0x74+4`; hilite when `[0x1F62]!=0` →
`+0x74+6`; else normal `+0x74+2`. `{` / `}` in any string toggle the hilite latch `[0x1F62]`
1/0 (`func_06C388`); `|` ends the visible span.

**Frame sprite:** the dialog element painter is `func_06D938` — it blits the sprite far-ptr
stored at widget-node `+0x68/+0x6A` via `0x181F:0x254`, taking h/w from the sprite header. The
WOODFRAM/NAMEPLAT chrome sprites are pre-loaded handles bound by the builder; the dialog overlay
pushes no asset-name string itself. **Save-under**: dialogs and menus save the screen under
their rect with mode `ax=0xFFF8` via `0x1A1F:0x364` → `func_078640` and restore via
`0x1A1F:0x38A` → `func_0786FE`.

### 25.3 The popup engine (gameplay event dialogs)

Every gameplay popup (~30 GAME.TXT event templates: king demands, raids, Lost City, combat
outcomes…) is the §25.2 engine plus a **speaker-portrait channel system**. Three DGROUP channel
words select the portrait sheet; `0xFFFF` = no sprite:

| Channel | Global | Builder | Sheet built from the channel value |
|---|---|---|---|
| King / tribe | `[0x1F5C]` | `func_06BE92` (0x06BE92) | 0..7 → `IND<n>A<pose>.SS` (tribe order = NAMES `@TRIBES`: Inca, Aztec, Arawak, Iroquois, Cherokee, Apache, Sioux, Tupi); >7 → `KING<n>.SS` (split `cmp 7/jle` at 0x06BE96; only KING1 exists — KING2 is byte-absent) |
| Advisor | `[0x1F5E]` | `func_06BF12` (0x06BF12) | 0..5 → `MSS0..MSS5.SS` |
| Missionary | `[0x1F60]` | `func_06BF3C` (0x06BF3C) | 0..3 → `MYR0..MYR3.SS` |

Popups reach the engine through per-channel emit wrappers: plain body = the `0x3FE` GAME wrapper;
advisor-voiced = `0x181F:0x652` (`func_06F5F2`, sets `[0x1F5E]` before the run); conversation =
`0x1A1F:0x688` (`func_06F61C`, sets `[0x1F60]` and returns the chosen row); king/tribe events set
`[0x1F5C]` directly (e.g. `mov [0x1F5C],8` for `@KINGTAX`). The blitter `func_06BF66` copies the
loaded sheet handle into a 0x14-byte cel and blits it via
the page-27 graphics overlay (`0x1A1F:0x372`, file 0x76642) to the back-buffer 0xA000:0xFC00,
clipped to the popup rect `[0x839E..0x83A4]`. **There is no coordinate literal** — the landing
pixel is computed inside the blitter from the sheet handle and returned in AX/DX (stored back to
cel `+0xC/+0xE`); the .SS directory carries no per-cel anchor field, so a specific frame's pixel
is runtime state. After a popup closes all three channels reset to `0xFFFF` at file **0x06EE6B**.

Placement: gameplay popups are **centred** (no `@x/@y`); across all of GAME.TXT the `@width`
histogram is {190: 336 sections, 220: 99, 300: 11, 310: 10, 160: 8, …}. Standard event popups
(`@KINGTAX`, `@RAIDWREAK`, `@LOSTCITY0..9`, `@FOODLOW`, `@SHIPCOMBAT`, `@LANDFALL`, `@BURNED`,
`@DECLARE`, `@INVASION` …) are `@width=190`; the wide set (`@TEAPARTY`, `@CASHTREASURE`,
`@INTERVENTION`, `@INDEPENDENCE`, `@SONSUP`, `@SMITEINDIANS`) is `@width=220`. Only 21 sections
carry a literal `@x/@y` (menus, tutorials, `@VICEROY` x=232/y=21, `@KINGLOSE` x=232/y=31,
`@KINGWIN` x=202/y=125). Dismissal = any key/click via the modal wait `0x181F:0x3C0`; there is
**no OK/Cancel button sprite anywhere** — the strings "OK"/"Cancel" do not exist in the binary
as button labels; options are `@OPTIONS` text rows. Body font = FONTTINY (the engine default
latch `[0x89E]`).

### 25.4 The pulldown-menu engine (in-game map menu bar)

The map bar (GAME / VIEW / ORDERS / REPORTS / TRADE / CHEAT / COLONIZOPEDIA) is a separate
module on overlay page 0x0A. The bar object at `[0x896]` is built once by `func_072090`
(0x072090) from the `game menu` data sections (`"game"/"menu"` opened at 0x0720BE via reader
`0x191F:0x928`; 7 add-pulldown calls → `func_044B7A`, 91 add-item calls → `func_044D16`). The
interaction core is **`func_0452D4`** (0x0452D4, 1559 B, page 0x0A) — the modal
open/navigate/select tracker (an earlier attribution of the dropdown to the dialog pump
`func_06E3D0` was overturned; that engine serves the `@`-directive dialogs).

```c
typedef struct {                 // menubar object at [0x896] (created by func_044836)
    uint16_t result_cmd;         // +0x00 selected command id (write @0x045895; 0 = none)
    uint16_t bar_y;              // +0x04 = 1
    uint16_t title_gap;          // +0x06 = 0x0C (12) between titles
    uint16_t item_leading;       // +0x08 = 3
    uint16_t title_xpad;         // +0x0A = 1
    uint16_t bar_c1, bar_c2;     // +0x0E/+0x10 bar colours ← [0x149C]/[0x149E] (runtime-filled,
                                 //   partly from MENUCOLR.SS sprite queries)
    uint16_t hi_c1, hi_c2;       // +0x1A/+0x1C highlight colours ← [0x14A8]/[0x14AA]
    uint16_t title_font[6];      // +0x20 title font descriptor (string at +0x28)
    uint16_t item_font[6];       // +0x2C item font descriptor (string at +0x34)
    void far *first_menu;        // +0x38
} Menubar;

typedef struct {                 // menu node (0x22 bytes, alloc @0x044BD9)
    uint16_t pad0;               // +0x00
    uint16_t x;                  // +0x02 = prev menu x+width + gap; FIRST TITLE x = 0x0C (12)
    uint16_t title_w;            // +0x04
    uint16_t panel_inner_w;      // +0x06 (init 0x0A, grown by add-item)
    uint16_t hotkey;             // +0x08 title accelerator char
    uint16_t flags;              // +0x0C bit0 = disabled
    void far *title;             // +0x0E
    void far *owner;             // +0x12 owner menubar
    void far *next, *prev;       // +0x16/+0x1A
    void far *first_item;        // +0x1E
} Menu;

typedef struct {                 // item node
    uint16_t flags;              // +0x00 bit0 disabled, bit1 hidden
    uint16_t shortcut;           // +0x02 item accelerator key
    uint16_t command_id;         // +0x04 returned on commit
    void far *label;             // +0x06 (empty first byte = separator row)
    void far *next, *prev;       // +0x0E/+0x12
} MenuItem;
```

Layout (`func_044FA4`): panel x = menu.x; panel y = bar_y + title-text-height + 3; width =
`menu.+6` + 2; height = n_visible·(item_font_h + leading) + leading + 2; item x = panel_x + 1;
first item y = panel_y + leading + 1. **Screen clamps**: right edge ≥ 0x13E → shifted so right =
**0x13D** (317); bottom ≥ 0xC6 → shifted so bottom = **0xC7** (199). Bar draw (`func_044E7C`):
full-width fill (0, 0, 320, title_h + bar_y + 1); selected title gets a highlight box in colours
`+0x1A/+0x1C`; title text at menu.x + pad, y = bar_y (=1). Save-under before open
(`0x1A1F:0x364`), restore + blit on close. Interaction: Alt-tap (`[0xB96]`) or a bar click opens;
'8'/0x148 up, '2'/0x150 down (skipping hidden/disabled/separators, wrapping), 0x14B/0x14D
prev/next menu, Enter accepts, Esc cancels, any other key is scanned against item `+0x02`
shortcuts; releasing Alt closes. The result command id is switch-dispatched by the executor
`func_0235D6` (0x0235D6, `switch [bp+6]`). The **CHEAT menu is built always** but hidden unless
the cheat bit is set (`test [0x5383],0x20` at 0x072A8B → menu-record hidden bit; see §27.2 for
the Alt-W-I-N combo).

### 25.5 Mouse / keyboard pipeline (summary; bindings in §27)

**Mouse**: one resident module (file 0xC980+, segment 0xA58) wraps `int 0x33` in exactly 8 call
sites; in mode 13h the driver cursor is suppressed and a **16×16 software cursor** (transparent
colour 0xFF, screen stride 320) is drawn by an installed AX=0x14 event handler (handler at
0xCB87). The poll/edge-detector at 0xD106 publishes: `[0x7E8]/[0x7EA]` cursor x/y, `[0x7E6]` raw
buttons, `[0x7EC]` down-edge, `[0x7F4]` release-edge, `[0x7F6]` any-button-down, and `[0x7E4]` =
`!(buttons & 1)` — **0 = left click, 1 = right click**, written only on a fresh press. There is
no central hit-test table: each screen compares the globals against its own rects via
`0x181F:0x3CA`.

**Keyboard**: 100 % BIOS INT 16h polling — `kbhit` at 0xD272 (AH=1) and `getch` at 0xD286
(AH=0); no INT 09h ISR is ever installed. `getch` normalises: printable key → AH zeroed (clean
ASCII); extended key (AL==0) → scan code kept in AH, so callers distinguish letters from
arrows/F-keys by the high byte. Wait helpers: `wait_for_keypress` (0x4A5C),
`wait_keyOrClick` = `0x181F:0x3C0` (0x4A80), `drain_keyboard_buffer` (0x4AFA), interruptible
`idle_poll` (0x4D1E, abort codes 0x110/0x12D → `[0x828]=1`). Dispatch is table-driven: the key
indexes a normalisation/flag table at DS:0x27ED (bit 1 = case-fold −0x20) and then per-screen
action tables; the executor is `func_0235D6`.

---

## 26. Screens — geometry, fonts, keys, state

Every screen below is native 320×200 (mode 13h). Coordinates are byte-cited EXE immediates
unless marked "(measured; not byte-cited)" — pixel-verified against the running game, 1994
binary under DOSBox. Palette indices refer to the screen's loaded PIK/gameplay palette.

### 26.1 Boot / main menu

The title screen's plaque menu: OPENMENU.PIK backdrop, one wood-framed dialog run from GAME.TXT
`@BEGINMENU` (`@options @width=160 @y=91 @smallfont`), painted by the §25.2 engine under the
boot-mode ink setter (0x0734BC). The three `0x1A1F:0xDF8` calls before the menu are full-screen
**palette-index remaps** (7→6, 8→9, 15→14 — `func_00E146`), a no-op on OPENMENU.PIK; there is no
"OPENBORD sprite" pass.

```python
regions = [
    (0,   0, 320, 200, "OPENMENU.PIK backdrop",      "art",   "load_PIK @0x075AE4; composited over OPENING.PIK"),
    (77, 91, 166,  58, "Menu plaque box",            "panel", "w=160+2*3 byte-derived; x=160-166/2; h item-driven (measured 58)"),
    (82, 97, 156,   6, "Title line",                 "text",  "'{COLONIZATION} Version ...' x=box+5, top=box+6"),
    (86, 107, 148, 40, "Option rows x5",             "hit",   "x=box+9; tops y=107+8k, k=0..4 (pitch 8)"),
    (81, 106, 158,  7, "Selection bar",              "hit",   "(box_x+4, option_top-1, 158, 7) tracks the hit row"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Plaque box | (77,91,166,58) | panel | dialog engine; OPENTILE.SS 32×24 tile fill phase-anchored at box origin (`[0x1F6C]=0x9400`, sentinel colour 7) | — |
| Box chrome | outline+2 rings | panel | black outline (idx 0), ring `[0x1F44]`=0x2E, bevel light 0xFD top/right, dark 0x37 left/bottom | boot-mode setter 0x0734BC |
| Title | y=97 | text | `@BEGINMENU` title; `{...}` span in gold | hilite latch `[0x1F62]` |
| Options ×5 | y=107+8k, x=86 | hit | "Start a Game in NEW WORLD / Start a Game in AMERICA / CUSTOMIZE New World / LOAD Game / View Hall of Fame" | `dec ax` ladder at 0x075C6D |
| Selection bar | (81,106,158,7) | hit | flat fill colour `[0x1F40]`=0x37 | hit row `+0x4C` |

Fonts/inks: **FONTTINY** (the `@smallfont` directive copies the FONTTINY latch; pixel-proven —
FONTINTR's 9-px cells cannot fit these spans). Text 0xFE, `{}`-hilite gold **0xFC**
(live-confirmed), disabled 8. Keys: arrows move the bar, ENTER(13) selects, ESC(27) cancels,
SPACE(32), digit + first-letter hotkeys. Dispatch (`dec ax` at 0x075C6D): 1=exit branch,
2=load/AMERICA sub-picker, 3=setup/scenario list, 4=new game → `begin_game` 0x072578. State:
returned 1-based row in AX from `0x181F:0x3FE` run at 0x075C60.

### 26.2 Difficulty select

Full-screen DIFFICUL.PIK (five conquistador figures baked into the art); code adds only the
labels, the finish prompt, and a 1-px hollow selection outline. Painter `func_070494` /
`func_070580`, cell helper `func_0702C0`.

```python
regions = [
    (0,    0, 320, 200, "DIFFICUL.PIK backdrop", "art",  "load_PIK 'DIFFICUL' @0x0705A8; own embedded palette"),
    (128,  7,  68,  90, "Discoverer cell",       "hit",  "grid: x=(idx%3)*105+23, y=(idx//3)*96+7, idx=n+1"),
    (233,  7,  68,  90, "Explorer cell",         "hit",  ""),
    (23, 103,  68,  90, "Conquistador cell",     "hit",  ""),
    (128,103,  68,  90, "Governor cell",         "hit",  ""),
    (233,103,  68,  90, "Viceroy cell",          "hit",  ""),
    (0,   16, 112,  26, "Title 'Choose / Difficulty Level'", "text", "y=16/29, centred over the left column (measured)"),
    (0,   81, 112,   8, "Finish prompt",         "text", "'(Click Here When Finished)' y=81 (measured)"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Cell i (0..4) | (col·105+23, grp·96+7, 68, 90) | hit | level name = NAMES `@DIFFICULTY` (Discoverer/Explorer/Conquistador/Governor/Viceroy); sub-label = LABELS `@MISC` 165–169 (Easiest..Toughest) | selected → `[0x53A6]` |
| Selection outline | selected cell | rect | `0x181F:0xCE` 1-px hollow; per-row colour byte {0xA, 9, 0xE, 0xD, 0xC}; captured state shows ink 9 (blue) | `[0x53A6]==row` |
| Titles | y=16/29 | text | `@MISC` 162/163 "Choose"/"Difficulty Level", FONTINTR, black shadow at (1,0),(0,1),(1,1) (measured) | — |
| Finish prompt | y=81 | text/hit | `@MISC` 161 + parens, FONTTINY ink 254; commit zone = click with mouseY<103 & mouseX<128 (0x07073A) | exit |

Fonts/inks: FONTINTR labels, inks level1=254 / level2=253 / level3=0 (measured; not byte-cited).
Keys: up = (level+4)%5, down = (level+1)%5 (0x070692/0x0706C8), ESC exits. Name/description
drawn centred in the cell for the selected row only. PIK-load failure degrades to the
`@DIFFICULTY` text list via `0x181F:0x998`.

### 26.3 Nation select

Full-screen NATIONS.PIK (four flag plaques baked in), 2×2 grid, twin of §26.2. Painter
`func_07092E` / `func_070A1A`, cell helper `func_070782`; menu-mode `[0x1F5C]=4`.

```python
regions = [
    (0,    0, 320, 200, "NATIONS.PIK backdrop", "art", "load_PIK 'NATIONS' @0x070A42"),
    (112, 13,  88,  82, "England cell",         "hit", "grid: x=(i%2)*99+112, y=(i//2)*91+13"),
    (211, 13,  88,  82, "France cell",          "hit", ""),
    (112,104,  88,  82, "Spain cell",           "hit", ""),
    (211,104,  88,  82, "Netherlands cell",     "hit", ""),
    (0,   36, 112,  26, "Title 'Select / European Power'", "text", "y=36/49, left-column-centred (measured)"),
    (0,  182, 112,   8, "Finish prompt",        "text", "y=182 (measured)"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Cell i (0..3) | (col·99+112, row·91+13, 88, 82) | hit | NAMES `@COUNTRY` England/France/Spain/Netherlands; leaders `@LEADERNAME`; trait label at cell bottom = `@MISC` 173–176 (Immigration/Cooperation/Conquest/Trade) | selected → `[0x5398]` |
| Selection outline | selected cell | rect | `0x181F:0xCE` 1-px hollow, colour = per-nation flag byte `[bx+0x848]`; captured state ink 12 (red) | `[0x5398]==row` |
| Titles | y=36/49 | text | `@MISC` 170/171 "Select"/"European Power", FONTINTR | — |
| Commit | click & mouseX<112 | hit | left-margin zone (0x070BFC) | exit, returns `[0x5398]` |

Fonts/inks: FONTINTR, same ink triplet as §26.2. Keys: arrows rotate mod 4 (0x070B40), ESC.
Fallback: `@PICKNATION` text list. The per-nation flavour pages `@NATION0A..3B` follow (§26.5).

### 26.4 Leader-name entry

A WOODPANL-backed text-entry dialog (`@LEADERNAME`, `@width=300`, maxlen 23) shown after nation
select; default text = the nation's leader name from the AIPersonality record 0x540E + n·0x34.

```python
regions = [
    (0,   0, 320, 200, "WOODPANL.PIK backdrop", "art",   "wood-panel background"),
    (10, 88, 300,   8, "Prompt line",           "text",  "@LEADERNAME body, centred; y=88 (measured)"),
    (79, 98, 167,  14, "Entry field outline",   "panel", "green 1-px outline (measured; not byte-cited)"),
    (82,101, 161,   9, "Entry text + cursor",   "text",  "default 'Walter Raleigh' + '_' cursor; X=160-W/2 centring"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Prompt | y=88 centred | text | GAME `@LEADERNAME` | — |
| Field | (79,98,167,14) | panel | green outline + text-bbox background fill (measured) | — |
| Entry text | (82,101) | text | FONTINTR, proportional glyph advance; `_` cursor | result copied to leader-name field 0x540E+n·0x34; `@LENGTH` max → `[0xA5B6]` |

Font: **FONTINTR** (this dialog carries no `@smallfont`; the FONTTINY rule applies only to
`@smallfont` dialogs). The `@width=300` box draws no visible frame on this screen. Keys:
printable chars append (proportional FONTTINY-style advance per glyph), ENTER accepts, ESC
cancels.

### 26.5 Nation briefings (`@NATION<n>A/B`)

Two full-width text plaques shown once, at game start, immediately after leader-name entry —
history page A then gameplay-bonus page B. Sole invoker: new-game setup `func_07431E`, which
builds `"NATION0A"`, patches digit `buf[6] += [0x5398]` (0x07444F), shows page A, then
`inc buf[7]` ('A'→'B', 0x0744A8) and shows page B. Both sections are `@width=300`, centred, run
by the standard §25.2 engine over the WOODPANL backdrop.

```python
regions = [
    (0,  0, 320, 200, "WOODPANL.PIK backdrop", "art",   ""),
    (7, -1, 306,  -1, "Briefing dialog",       "panel", "@width=300 => box_w=306, x=160-306/2=7; y centred, h item-driven"),
]  # 320x200 Mode 13h
```

Fonts/inks: FONTTINY body per the engine defaults; keys: any key/click dismisses (modal wait
`0x181F:0x3C0`). State: nation index `[0x5398]` selects the section pair.

### 26.6 Intro caption cards (`@BUILD1..10`)

A self-advancing slideshow over world generation: ten full-screen LEVN PIK plates, each with a
GAME.TXT caption block. Renderer `func_004B72` (resident): builds `"LEVN00"+n`, loads via
`0x181F:0x44E` (card 1 blanks the screen and latches the 768-byte palette), then renders section
`"BUILD"+n` with `^^`-centred lines; staged present `func_005160(8)`.

```python
regions = [
    (0,  0, 320, 200, "LEVN000n.PIK plate", "art",  "one per card, full-screen"),
    (14, 54, 292, -1, "Caption text block", "text", "pen (14,54); ^^-centred lines"),
]  # 320x200 Mode 13h
```

| Item | Value | Source |
|---|---|---|
| Text pen | (14, 54) | `func_004B72`; inks `[0x1F4A]=0x0E`, `[0x1F50]=0x36`, restored after |
| Card 2 substitutions | %STRING0 = difficulty rank `[0x8394+2·diff]`, %STRING1 = leader name (0x540E+p·0x34) | byte-cited |
| Card 3 | %STRING0 = home port `[0x838C+2·nation]` | byte-cited |
| Card 4 | %STRING0 = nation name, %STRING1 = `@MYLEADER[nation]` ("King/King/King/Stadtholder") | byte-cited |
| Advance | one card per **0x23A ticks** via counter `[0x8C]` (sequencer `func_004D1E` = `0x181F:0x3AC`, 34 call sites in world-gen) | byte-cited |
| Skip / abort | any key or click (`[0x8A]=1`); Alt-X / Alt-Q exits to DOS (exit code 3) | byte-cited |

### 26.7 Map view (main gameplay screen)

The default in-game screen: tile viewport left, wood sidebar right, pulldown bar on top. Tile
rendering itself (terrain decode, zoom compositor, fog, units) is specified in Part II; this
entry gives the screen geometry and bindings.

```python
regions = [
    (0,    0, 320,   8, "Pulldown menu bar",        "hit",   "bar fill h=title_h+2; titles y=1, first x=12, gap 12"),
    (0,    8, 240, 192, "World viewport",           "art",   "render_frame_setup func_06787C; 15x12 tiles @16px (zoom 0)"),
    (241,  8,  79,  41, "Minimap panel",            "hit",   "func_066CD6, panel box @0x66CF4; 1px/tile 56x39 window"),
    (240, 72,  80,  64, "Sidebar B: season/gold/tax","text", "x-origin [0x8550]=240 (@0x071039)"),
    (240,136,  80,  64, "Sidebar C: unit panel",    "text",  "sprite + @INFO labels; foreign-colony hover variant"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Menu bar | (0,0,320,8) | hit | 7 titles from MENU sections `@GAME @VIEW @ORDERS @REPORTS @TRADE @CUP @PEDIA`; per-title x from glyph widths (mechanism byte-cited; exact x's not) | Alt-tap `[0xB96]`; result → `func_0235D6` |
| Viewport | (0,8,240,192) | art | zoom `[0x184]`: spans `0xF<<z` × `0xC<<z`, tile px `0x10>>z` → 15×12@16 / 30×24@8 / 60×48@4 / 120×96@2 | cursor `[0x853E]/[0x8540]` |
| Minimap | (241,8,79,41) | hit | owner-dot colours from `[0x830..0x833]` = NAMES `@COLORS` bytes (68,149,8,128…, palette indices); viewport rect idx 0x0F | click recentres |
| Sidebar B | (240,72,80,64) | text | season NAMES `@SEASONS` + year `[0x538A]`; gold = PowerRecord+0x2A; tax = +0x01; FONTTINY white 0x0F | live |
| Sidebar C | (240,136,80,64) | text | unit sprite (`0x181F:0x2BC` panel), `@INFO` "Moves:/Locat:", type NAMES `@UNIT`, skill `@JOB`, orders, terrain name | selected unit `[0x5392]` |

Sidebar per-line stack (single-frame measurement, approximate): season/year (244,58), Gold
(244,66), Tax (290,66), unit sprite (244,80), Moves (270,82), Locat (270,92), type (244,104),
skill (244,112), orders (244,120), terrain (244,128) — 8-px FONTTINY lines (measured; the
per-line y is emitted through a runtime-installed printer pointer `[0xA644]`). Keys: see §27.1.
Click own colony → colony screen (entry chain via set_active_colony at file 0x82DC).

### 26.8 Colony screen

The colony management screen: composer `func_028592` (0x028592) draws 12 ordered steps —
terrain scene first, then a full-screen WOODTILE region fill composited over it, then title,
panels, buildings. COLONY.PIK is a 320×72 town-scene strip blitted at y=128 (no embedded
palette; renders on the gameplay palette). Entry: screen id 0x2C; active colony ptr `*[0x8542]`
(ColonyRecord base 0x5D46, stride 0xCA; `+0`=cx, `+1`=cy, `+2`=name).

```python
regions = [
    (0,    0, 320,   7, "Title strip",                  "text",  "name+season+year+gold; paint 0x181F:0xB0, origin runtime (text-box globals [0x2CC6..])"),
    (0,    0, 320, 200, "WOODTILE region fill",         "panel", "step 4 func_02633E; composited over the scene, from (0,0)"),
    (0,  128, 320,  72, "COLONY.PIK town strip",        "art",   "320x72 strip at y=128"),
    (200,  8, 120, 120, "5x5 scene (x1.5 upscale)",     "art",   "80x80 render stretch-copied via 0x181F:0x510 + 4x4 dither"),
    (224, 32,  72,  72, "Visible 3x3 scene window",     "art",   "central 3x3 of the 5x5; 24px tiles; outer ring overdrawn"),
    (248, 56,  24,  24, "Colony-centre tile",           "art",   "field-production centre cell"),
    (0,  130, 120,  48, "Left panel: colonist plaza",   "hit",   "region id 0; rows left-aligned at origin+2"),
    (121,130,  84,  48, "Middle panel: cargo dock",     "hit",   "region id 8; 6 crate slots (ICONS disk 122) or centred caption"),
    (207,130,  95,  48, "Right panel: SoL/cargo/msg",   "hit",   "x207..301 on screen (fill push was 211,91); mode [0x337]"),
    (303,132,  17,  45, "Nation flag panel",            "hit",   "region id 3; ICONS 0x44 at +3, frame=[0x337]/[0x339]"),
    (0,  179, 320,  21, "Stockpile bar",                "hit",   "16 cells pitch 19; icons y=181; digits (9+19i,194)"),
    (306,179,  15,  21, "Exit caption/zone",            "hit",   "region id 9; string-id slot [0x2F5E]=210 -> @MISC 'Exit'"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Title | (0,0,320,7) | text | colony name (rec+2) + NAMES `@SEASONS[0x538C]` + year `[0x538A]` + gold (PowerRecord+0x2A via money formatter); green FONTTINY | live |
| Buildings ×15 | table DS:0x266 (stride 4: x@+0, y@+2) | art | BUILDING.SS frame = **def_id+1** (EXE-sheet; specials: def 0 + no-stockade → 0x11; def 0xF/0x11 garrison → 0x2F/0x30; blit `0x181F:0x254` at 0x026E4E); empty plot (byte 0x8E82[i]==255) → frame `DS:0x260[category]−1` | def table 0x8E82, categories 0x8D62 = [0,0,0,0,0,0,0,1,1,1,1,2,2,3,4]; plot assignment = per-colony 16-bit-seeded RNG shuffle (`func_025D34`) |
| Plot positions | (56,13)(145,15)(173,18)(8,41)(37,45)(67,54)(96,53)(6,14)(128,53)(10,76)(15,102)(87,11)(66,87)(123,106)(123,55) | art | the DS:0x266 table values as printed (no extra +8) | — |
| Scene | (200,8,120,120) | art | map compositor: 5×5 neighbourhood at 16 px from TERRAIN.SS `[0x16C]` + PHYS0.SS `[0x174]`, colony/unit markers on the 80×80, then ×1.5 stretch (2→3 duplication) with positional 4×4 ramp dither (`func_00531C`/`func_005296`) — deterministic, no dedicated 24-px tileset | colony (cx,cy)−2 origin |
| Scene workers | x=cell·24+252, y=cell·24+60 | art | PHYS0 sprites, drawn after the upscale; cells signed −2..+2 from DS:0xC8/0xDE | colony+0x329 count |
| Plaza row | (0,130,120,48) | hit | colonist sprites, rows left-aligned at panel origin+2; pitch = sprite width + adaptive gap (2→0, fit-to-96px, 0x02715C) | count = colony+0x1F + `[0x8D72]` |
| Middle panel | (121,130,84,48) | hit | 6 cargo-crate slots (ICONS disk frame 122) or centred caption via string-id slot + `0x181F:0x22`/`0x100` | `[0x33C]` |
| Right panel | (207..301,130,48) | hit | `[0x337]` 3-way: 0 = SoL/garrison icon bar (`0x181F:0x222` rows); 1 = cargo + caption `[0x939A]`; 2 = cargo + caption + hammer strip (`0x236` sprite 55) | SoL% = `(colony+0xC2·100)/colony+0xC6` (+20 human latch, clamp 100 — `func_008524`) |
| SoL band text | "100% (1)" at (75,133) white; "No Ships In Port" caption (118,130) | text | digit in parens (not letter I); caption = `@MISC` string id | live |
| Stockpile bar | (0,179,320,21) | hit | 16 cells pitch 19 (0x13); icon = ICONS `good+0x17` (EXE) at y=181; qty digits centred at (9+19i, 194), white 0x0F, red 0x0C over warehouse cap; order Food first | colony+0x9A 16×u16 |
| Carpenter overlay | colonist ICONS 81 at (42,111); green box `#55ff55` x39..50 y112..127; hammers ICONS 54 ×production at (15,104),(22,104),(29,104) | art | production count = live building-production state (strip verb `0x181F:0x236`) | per-turn |
| Exit | (306,179,15,21) | hit | FONTTINY white "Exit" (string-id 210 of the 221-entry `@MISC` id table at 0x2DBA) | region id 9 |

Fonts/inks: FONTTINY throughout; title green (screen latch); digits white 0x0F / red 0x0C.
Click regions (hit-tester at 0x299A0, ids): title 0xA, scene-left 2 (0,8,199,120), scene-right 1
(200,8,120,120), plaza 0, minimap 8, SoL 4, flag 3, stockpile 5 (0,179,305,21), exit 9, default
0x14. Keys (manual-sourced; routed through the multi-function display, no per-letter compare in
the static image): Tab view-to-view, arrows within view, Enter jobs menu, L/=/+ load, U/−/_
unload, M toggle views, 1/2/3 production/units/construction, N numbers, C construction menu, B
buy, F1 info, ESC exit.

### 26.9 Europe screen

The home-port harbour (screen-view id 0x2B, EUROPE.PIK key 0x0FBA; composer `func_031E4C`,
9-step chain). The dock town, market grid and the red "E" are baked PIK art; the engine draws
the title band, market prices, dock contents, captions and the recruit menu.

```python
regions = [
    (0,    0, 320,   8, "Title band",               "text", "text y=1 centred on x=160; band rect (320,7,0,0) via set_text_box @0x035B24"),
    (0,    8, 320, 192, "Play-area fill over PIK",  "art",  "func_030D86 @0x031E4C"),
    (0,  179, 320,  21, "Market bar",               "hit",  "16 cells stride 19; icons x=1+19i y=181; bid/ask pairs y=194"),
    (143,118,  81,  60, "Dock rect",                "hit",  "id 1; 'Loading: <ship>' centres in this rect"),
    (147,165,  72,  12, "Dock ship slots x6",       "art",  "x=147+12k, y=165, 10x12 each; crate frame (disk 0x7A)"),
    (1,  118,  70,  51, "Loading panel",            "hit",  "id 3; caption slot 336 'Docks At'/Loading"),
    (72, 118,  70,  51, "Bound For panel",          "hit",  "id 2; caption slot 337/338"),
    (224,120,  96,  59, "Expected panel",           "hit",  "id 4"),
    (281, 89,  37,  32, "Recruit/Purchase/Train",   "hit",  "id 5; rows (281,89+11r,37,9)"),
    (306,179,  15,  21, "Exit zone",                "hit",  "id 0xB; white 'Exit' + red 'E' at (308,187)"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Title band | (0,0,320,8), text y=1 | text | "London, England. Spring, 1500. Tax:0% Gold: 1000$" — banner builder `func_030F76`; centred within box (320,7,0,0); the gold suffix is the FONTTINY '$' glyph; literal "Tax:0%" has no space | ink state-dependent: idle green **68**, arrival-banner gold **149**; good `[0x9E12]`, year `[0x538A]`, tax PowerRecord+0x01 |
| Market icons | x=1+19i, y=181 | art | ICONS `good+0x17` (EXE), 16 goods in NAMES `@CARGO` order | boycott: the good's own icon redrawn as the marker (gate 0x031A73) |
| Market prices | cell-centred, y=194 | text | **bid/ask pairs**, FONTTINY ink 0x2F; bid = nibble of the per-good market record (base 0x3150 stride 0x1C); ask = bid + `@CARGO`.Burden + 1 | live prices; click = buy/sell (sell handler 0x32914) |
| Selected-good outline | around the active cell | rect | 1-px outline, yellow 14 / green 10 (runtime `[0x9E12]`-driven; measured) | `[0x9E12]` |
| Dock slots | (147+12k, 165, 10, 12) | art | crate sprite (`mov ax,0x7B` engine = disk frame 122) | ships in port `[0xFA2]` |
| Ship status rows | y=146 / 137 / 132 | text/art | sail-state 1/2/3 bands (`func_031298` jump-table); bar width `0x64>>state`; type icon `@UNIT[type]` | per-ship sail distance |
| Captions | "Expected Soon" (16,120); "Bound For"/"New England" (87,120/127); "Loading:"/"Caravel" (150/186,120) (measured x/y) | text | fixed per-panel `@MISC` string-id slots: 336 Docks At, 337 Expected Soon, 338 Bound For, 339 No Ships In Port | in-port loop selects only colour (0xA/0xF) |
| Recruit menu | rows (281, 89+11r, 37, 9) | hit | LABELS `@EUROLABEL` "RECRUIT/PURCHASE/TRAIN/x"; rows horizontally centred; bevel colours 57/48 (measured), accelerator first letter yellow; row pitch 11 (measured — the "glyphH+2" formula does not reproduce it) | ink 0x0F / 0x00 by selection |
| Exit | (306,179,15,21) | hit | white "Exit" caption; the red "E" at (308,187) is PIK art | generic screen-view close; keys `x`/ESC/E |

State fields: treasury PowerRecord+0x2A (u32), tax +0x01, boycott bitmask +0x20, price_level
+0x4C[16], vol_accum +0x5C[16]. Keys (manual-sourced except the byte-corroborated `x`): Tab,
arrows, Enter dock/harbor options, L/= buy full, + buy some, U/−/_ sell, R/1 recruit, P/2
purchase, T/3 train, F1 info, ESC/E exit. Water animation is pure palette cycling (indices
54–60), gated by the Water Color Cycling option (§27.4).

### 26.10 Combat Analysis dialog

A modal two-column modifier breakdown shown inside land-combat resolution (`func_05CA7E`),
after the roll is computed and before resolution renders, when Game-Options bit 0x0200 is set
and a human is involved. The dialog is `func_05E9B0` (page 0x11; thunk `0x1A1F:0x704`), called
once at 0x05D291 with 13 args.

```python
regions = [
    (53, -1, 214, -1, "Analysis box",   "panel", "x=53, w=214; h=rows*20+6, vertically centred (y=100-h/2)"),
    (56, -1,  80, -1, "Attacker column","text",  "labels at x=56; values right-aligned at 56+0x50"),
    (160,-1,  80, -1, "Defender column","text",  "labels at x=160; values right-aligned at 160+0x50"),
]  # 320x200 Mode 13h
```

| Element | Value | Source |
|---|---|---|
| Frame | `0x1A1F:0x710`, x=53, w=214, h=rows·20+6, vertically centred; row pitch 20 | byte-cited |
| Title | "COMBAT ANALYSIS" = LABELS `@MISC` line 75 (slot `[0x2E50]`) | byte-cited |
| Columns | attacker x=56, defender x=160; labels colour `[0x830]`, values right-aligned at col_x+0x50 colour `[0x831]`; per-column unit sprite + info panel (`0x181F:0x2BC`) | byte-cited |
| Inputs | per column: flag word `F=[col·2+0x8D00]`, secondary `S=[col·2+0xA156]`, base strength `[col·2+0x8D06]` | byte-cited |
| Dismiss | modal wait `0x181F:0x3C0` | byte-cited |

Row table (flag → label → value): F&0x200 veteran-name row (base strength); F&0x400 Muskets
"+1"; F&2 Veteran +50%; F&4 Cargo −12.5% per used hold; F&0x100/S&8 Fatigue −33%/−66%; F&1
Attack Bonus +50%; F&0x8000 Bombard +50%; S&2/S&4 Tory/Rebel Unrest −(100−SoL%)/+SoL%; F&0x80
Ambush (att) / Terrain (def, draws the target tile) +terrain_def·25%; F&0x40 Colony
+(fortlevel+1)·50%; F&8(+0x10/0x20) colony-structure row +n·50%; F&0x800 Artillery In Open −75%;
S&1 Artillery Vs. Raid +100%; F&0x2000 Fortified +50%; F&0x1000 Spain Bonus +50%; F&0x4000 Drake
+50%. With the cheat bit (`[0x5383]&0x20`) extra rows show the final strengths and the raw roll.

### 26.11 Colonizopedia

The in-game encyclopedia: an alphabetized 3-column browser plus seven category entry-page
renderers on overlay page 0x16 (one function per `@PEDIA` category). Reached from the eight
`@PEDIA` pulldown items (commands 0x70..0x77 → `func_06B398`) and from per-screen context help
(dispatcher `func_02BC72` on selection type `[0x32E]`).

**Browser / index pager** (`func_06B398` / `func_06B02A`):

```python
regions = [
    (0,   0, 320,  15, "Title strip",   "text", "'ENCYCLOPEDIA OF COLONIZATION' centred y=5, colour 0xF"),
    (5,   5, 100,   7, "(More)",        "hit",  "left, only when count>72; hover recolour [0x831]"),
    (215, 5, 100,   7, "(Exit)",        "hit",  "right-aligned to x=315, y=5 via 0x181F:0x150"),
    (0,  15, 320, 185, "Index grid",    "hit",  "3 cols x 24 rows; x=col*100+5 (5/105/205), y=row*7+25, pitch 7"),
]  # 320x200 Mode 13h
```

| Element | Value | Source |
|---|---|---|
| Grid cell | x = col·100+5, y = row·7+25 (25..186); text at (x+2, y+1); cell hit 100×7 | `func_069156` 0x069182/0x069190 |
| Inks | normal `[0x830]`, highlighted `[0x831]`; highlight bar `0x181F:0xBA` w=textW+4 h=fontH+1 colour `[0x835]`; browser title colour 0xF literal | byte-cited |
| List | capacity 216; category sizes 16/23/21/27/38/25/12 (skips: terrain 0x10..0x17, Teacher, 4 buildings); forested terrains get " Forest" suffix; gnome-sorted alphabetically | byte-cited |
| Keys | Up '8'/0x148, Down '2'/0x150 (±1 mod count); Left '4'/0x14B −24 (wrap); Right '6'/TAB/0x14D +24; ENTER/SPACE open; ESC exit; "(More)" pages forward 3 columns cyclically | byte-cited |
| Font | FONTTINY (`[0x89E]`) | byte-cited |

**Shared entry-page skeleton** (identical opcode sequence in all seven): WOODPANL.PIK backdrop
(fallback fill colour 8); screen title `[0x2E92]` "ENCYCLOPEDIA OF COLONIZATION" centred y=5
colour `[0x831]`; entry header "<name>: <category>" centred at y = font_h+7; body seed y =
header_y + font_h + 0xE (JOB page: +font_h+3), x = 10; article = PEDIA section `<KEY><idx>` via
menu_lookup_run (`0x181F:0x998`), text-window y-cursor `[0x1F5A]`; terminator: present `0xE2`
(0,320,200) + modal wait. Sheets: ICONS.SS `[0x83E]`, BUILDING.SS `[0x842]`.

Per-page layouts (all byte-cited):

| Page (fn) | Layout facts |
|---|---|
| Cargo (`func_0694AE`) | production-chain rows, pitch y+=0x14; per row: job figure ICONS `job+0x52` at (10, y−2), cargo icon `cargo+0x17` then 6 more copies at x+=4 (7-icon stack), text "<Cargo> With <Expert>" at (x, y+4) colour `[0x830]` |
| Unit (`func_0696C6`) | temp preview UnitRecord (destroyed at exit); figures via `0x181F:0x2BC`, pitch 18 px, x home 8; type 0 = 25-figure profession gallery, 17/row, wrap y+=0x14; name line at fig_y+6; stat line "Combat/Moves(÷3)/Cargo Holds" at (8, y) — type 0xB's "(and Damaged <Name>" is missing its ")" in the shipping binary; article `@UNIT0..23`, `[0x1F5A]` = stat_y+0xC |
| Terrain (`func_069D8C`) | header "(<Name>: Terrain Type)"; **3×3 tile preview** framed (7,y0)–(0x3A,y0+0x33) (52×52 double rect colours `[0x839]`/`[0x837]`), 16-px cells at x=9/25/41; base ground from the boot-rasterized 12-tile TERRAIN array `[0x16C]`; forest overlay PHYS0 `0x41+M[c+3r]`, M=[5,7,6,13,15,14,9,11,10]; hills 0x31+M, mountains 0x21+M; rivers (0,1)→0x17 (0,2)→0x1B; roads (2,0)/(2,1); centre resource `0x5A+R[id]` (word table at file 0x1DB32); stat rows right column x=63 pitch 0x10 — figure `0x52+j` + "<Job>: N" at (75, row+6) colour `[0x831]` + bonus lines colour `[0x830]`; movement/defence line "M / +25·defence%" at (63, row+6); article `@TERRAIN0..28` |
| Skill (`func_06A700`) | workplace building chain (BUILDING frame b+1, x += frame_w+3); job figure `idx+0x52` at (10, y+bldg_h/2−7); product strip icons `idx+0x17`, x+=0x10 |
| Building (`func_06AA88`) | big picture BUILDING `rec+1` at (10, y) (idx 0x11→0x2F, 0x10/0x1F none); header at (10+w+3, h/2−7+y+6) colour `[0x831]`; worker figure + product; prerequisite line at (10, y) colour `[0x830]`, y+=0x14 |
| Father (`func_06AE08`) | text-only: name (table 0x9652 stride 6), y += font_h+0xE, article `@FATHER0..24` |
| Concept (`func_06AF1C`) | text-only: 12 names from the PEDIA `@MISCELLANEOUS` loader, article `"MISC<n>"` |

Inks: `[0x830]`=0x44, `[0x831]`=0x95 static inits (runtime rewrites possible).

### 26.12 Continental Congress (F3) + advisor-report geometry

The F3 Activities screen: full-screen REPORT3.PIK backdrop, text/sprite body `func_037A20`
(0x037A10..0x3807D). Progress toward the next Founding Father is **text only** — "(NN in MM)" —
the game has no fill bars anywhere.

```python
regions = [
    (0,  0, 320,   5, "Title fill + centred title", "text", "fill colour 0x90; 'CONTINENTAL CONGRESS ACTIVITIES' (@MISC 37)"),
    (4, 25, 312, 150, "Body line stack",            "text", "x=4, y-seed 25, pitch 8 (FONTTINY h6+2); colour 0x92"),
    (4, -1, 300,  -1, "Bell gauge row",             "art",  "0x181F:0x236: filled 0x3F / empty 0x38, span 300"),
    (4, -1, 300,  -1, "Rebel/Tory strip",           "art",  "sprites 0x7C x rebels + 0x7D x tories, span 300"),
    (4, -1, 300,  -1, "REF rows x2",                "art",  "0x222 enqueue x4 -> 0x22C flush, 4 columns, span 300"),
    (4, -1, 312,  -1, "Founding Fathers grid",      "text", "cols x={4,82,160,238}, step 0x4E, colour 0x61, 4/row"),
]  # 320x200 Mode 13h
```

State: PowerRecord +0x02 rebel%, +0x0C bells_current, +0x0E bells/turn, +0x12 FF-in-progress,
+0x14 FF count; REF counts `[0x53DA/DC/E0/DE]` + naval `[0x53E2..E8]`; threshold computed by
`func_03C282` (base `(diff+3)·2` human / `14−diff` AI, ×8, +50 % per year band 1600/1650/1700/
1750, ×(FF+1)+1, halved at 0 FF; endgame override `diff·0x5DC+0x7D0`). The FF-acquisition
**reveal popup** is a different path: full-screen CCBKGD.PIK (`func_03BB4A`), owned portraits
CC-00..24.SS blitted at each sheet's own baked frame-descriptor coordinates, two-phase light-up,
key/ESC dismiss — no frame, title, or OK widget.

**Advisor reports F1–F10 — summary geometry** (all bodies at file 0x37xxx–0x3Axxx; shared frame:
REPORT<N>.PIK, centred title in fill (0,0,320,~5) colour 0x90, footer sprite y=200, OK = `@MISC`
46 via the modal wait; body font FONTTINY, row flow = glyph_h+2):

| Report (body @file) | Static geometry |
|---|---|
| F1 Terrain (0x3744A) | rows y=0xA x=0x19; advance y+=0x1E then font+2; icon sprite terrain+0x72; right-justified counts at x=0x136−textW |
| F2 Religious (0x37958) | crosses gauge `0x236` X=10 Y=25 span 300, filled 0x39/empty 0x38; optional text x=10 y=25 colour 0xF |
| F3 Congress (0x37A10) | above |
| F4 Labor (0x38418) | matrix: name x=2, y-base 42, pitch 8, colour 0x92; count at +0x27 colour 0x61; dark-red (0x77) separator line x=2..311 |
| F5 Economic (0x38A50) | headers x=76/170/220 y=25; commodity table x=2 stride 17; value cols x=250/150 stride 12; y 25/33 pitch 8 |
| F6 Colony (0x39218) | rows base (2,20) pitch 17, 9/page; name colour 0x92 at +0x17; 4 centred captions y=27 at (2/82/162/242, box 80/80/80/76) |
| F7 Naval (0x3954C) | 4-col table: first row y=42, pitch 20, 7 ships/page; name LEFT x=26 colour 0x61; cargo sprite row; Location centred box (162,80); Destination centred box (242,76) |
| F8 Foreign (0x39888) | gate `[0x5382]&1` clear = draws; labels x=2 colour 0x91; power value columns x=13/80/160/240; full-width 0x77 separators |
| F9 Indian (0x39EE2) | rows from village table 0x54EC stride 18; columns x=16, +72, +20; y-start 24, second block 150; text colour = `[0x830]` (`@COLORS` basic) |
| F10 Score (0x3A9C0) | WOODPAN2 + SCORE<panel+1> plate, panel = largest i with i²/3 ≥ scaled score; FONTTINY labels + FONTINTR figures |

### 26.13 King audience / King-defeat screens

One renderer, `func_075352` (0x075352), paints the King audience (tax demands), the player-wins
(`@KINGLOSE`) and player-loses (`@KINGWIN`) plates. Backdrop = **KINGLSS<n>.PIK** (throne room,
empty chair, blank scroll); the outcome-selected **foreground** sheet (KING1.SS mocking king +
dog / KINGLOSE.SS crying / KINGWIN.SS triumphant) and the nation banner (ENGLND1/2, FRANCE…,
stem + digit) land by the .SS frame-descriptor anchor convention (descriptor stores centre-x /
bottom-y; on-screen x = ax−⌊w/2⌋, y = ay−h+1).

```python
regions = [
    (0,   0, 320, 200, "KINGLSS<n>.PIK throne room", "art",  "load_PIK @0x0753A9"),
    (0,  12, 189, 187, "KING1.SS figure",            "art",  "desc (94,198) -> (0,12), bottom-anchored to row 199"),
    (32,  0,  -1,  -1, "ENGLND1.SS canopy banner",   "art",  "desc (118,121) -> (32,0); nation stem + digit"),
    (232, 29,  80,  40, "Scroll header, 4 lines",    "text", "per-line centred on x~271.5, tops y=29..61 (measured)"),
    (232, -1,  80,  72, "Scroll body, 9 lines",      "text", "left-aligned x=232, pitch 8 = FONTKING h+1 (measured)"),
]  # 320x200 Mode 13h
```

| Element | Value | Source |
|---|---|---|
| Variant select | `(bp+6,bp+8)`: (1,1)→KING1 (audience); (1,other)→KINGLOSE (player WINS); (2,·)→KINGWIN (player LOSES); nation prefix switch on `[0x5398]` | 0x075430 / 0x0753BB |
| Font | **FONTKING** (sole user in the binary; loaded 0x0754F6, dialog font latch `[0x1F9E]/[0x1FA0]`; falls back to FONTTINY) | byte-cited |
| Pen stores | `[0x1F4A]=242, [0x1F50]=47`, flags `[0x1F56]|=0x18` — register values, NOT the on-screen origin; the glyph runner re-lays-out under the 0x18 flags | 0x075526/0x07552C |
| Text layout | header per-line centred x≈271.5, tops y=29..61; body x=232, pitch 8 (measured; FONTKING metrics pixel-perfect) | measured |
| Body strings | GAME `@KINGLOSE` (`@width=68 @x=232 @y=31`) / `@KINGWIN` (`@width=90 @x=202 @y=125`); audience bodies built by the King-event orchestrator `func_02F3A2` | byte-cited (GAME.TXT directives) |
| Dismiss / choice | the `@`-menu run at 0x075540 (king's option list); page-flip + palette restore 0x075553 | byte-cited |

Ink: FONTKING is 2-bpp; level-3 measures black (idx 0) on this palette (measured).

### 26.14 Woodcut event screens

Full-screen carved-wood event plates (WDCUT01..13.SS) with a caption strip, shown once per
event. Renderer `func_06B722` (0x06B722, `0x181F:0x52E`); once-only wrapper `func_00543C`
(`0x181F:0x524`, shown-bitmask `[0x540A]`, per-woodcut music cues).

```python
regions = [
    (0,   0, 320, 200, "Black clear",           "panel", ""),
    (-1, -1,  -1,  -1, "WOODFRAM frame 1",      "art",   "centred from sheet-header words"),
    (-1, -1,  -1,  -1, "WDCUT<n> art",          "art",   "plate blit inside the frame"),
    (-1, 162, -1,  -1, "NAMEPLAT strip",        "art",   "left cap + N mid tiles + right cap, centred on x=160, y=162"),
    (-1, 165, -1,  -1, "Caption",               "text",  "'<year>: <CAPTION>' centred y=165, FONT-NP"),
]  # 320x200 Mode 13h
```

Caption = line n of the single `@WOODCUT` section, prefixed `"<year>: "` from `[0x538A]`;
ink LUT palette indices 0x5C/0x5D/0x5E; staged present/fade `func_005160(8)`; modal wait;
palette restore. Frame numbering is 1-based over disk descriptors. Trigger table (caller scan
exhaustive): 1 DISCOVERY (first landfall), 2 BUILDING A COLONY (first colony, human), 3/4/5
MEETING THE NATIVES / AZTEC / INCA (first contact by tribe), 7 ENTERING INDIAN VILLAGE, 8
FOUNTAIN OF YOUTH (Lost City outcome 1), 9 CARGO FROM THE NEW WORLD (first Europe cargo), 10
MEETING FELLOW EUROPEANS, 11 COLONY BURNING, 13 INDIAN RAID; 0/6/12/14–16 have no caller
(unreachable in the shipping binary).

### 26.15 Trade-route editor

The Edit Trade Route screen (page 0x12; commands 0x50 Edit / 0x51 Create / 0x52 Delete →
`func_060FBC`/`func_0610B0`/`func_0612E6`; painter `func_06083A`). Data: RouteRecord stride
0x4A, max 12 (`[0x53A0]`): +0 name[0x20], +0x20 type (1=sea), +0x21 stop count (max 4), +0x22
stops[4] stride 0xA (dest word — 0x3E7 = Europe; load/unload cargo nibbles).

```python
regions = [
    (0,     0, 320, 200, "Clear colour 0x22",       "panel", ""),
    (0,     5, 320,   8, "Title",                   "text",  "'EDIT TRADE ROUTE <n+1>' centred y=5, colour 0x0F @0x060898"),
    (10, 0x19, 300,   8, "Route Name row",          "hit",   "'Route Name:' + name at (10,25); click = @TRADENAME entry"),
    (10,   -1, 300,   8, "Route Type row",          "text",  "'Route Type:' + Sea/Land at (10, glyph_h+0x1B)"),
    (10,   -1, 310,   8, "Column headers",          "text",  "Destination / Unload / Load at y=0x37-glyph_h; x=w('0.  ')+10 / 0x7D / 0xD0"),
    (0,  0x3D, 320,  80, "Stops table (5 bands)",   "hit",   "rows y=0x3D..0x8D pitch 0x14; separators x=0x73 and x=0xC6"),
    (0x118,0xAA, 30, 20, "OK button",               "hit",   "box (0x118,0xAA)-(0x135,0xBD), label 'OK' (@MISC)"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Stop row n | y = 0x3D + n·0x14 | hit | "N. <destname>" at (10, rowY+8); unload icons from x=0x7D, load icons from x=0xD0 — ICONS `cargo+0x17`, advance sprite_w+2 | route stops[4]; row=(y−0x3D)/0x14; x<0x73 destination, <0xC6 unload, else load |
| Cargo cells | icon columns | hit | click icon = remove (shift left); click space = `@CARGOUNLOAD`/`@CARGOLOAD` 16-row menu (width 120), max 6 | nibble get/set `func_0603DA`/`func_06040A` |
| Destination picker | shared dialog | hit | `@TRADESTART` header; rows = eligible own colonies; Europe row for ships only (per-nation port name `[0x838C]`) | `func_060026` (also serves Go-To orders) |
| OK / exit | (0x118,0xAA,0x1E,0x14) | hit | y≥0xAA exits; Enter/Esc exit | commit |

Labels from the runtime `@ROUTE` table `[0x93DE..0x93EE]` (9 entries). The editor creates a
phantom probe unit at (0xFF,0xFF) to filter reachable destinations (deleted at exit). Create
flow: cap check → dest 1 → coastal test → `@TRADETYPE` → default name = colony + random
`@TRADENAMES` word → name entry → dest 2 → editor. Delete compacts the array and fixes unit
links (unit byte +0x17: lo nibble route, hi nibble stop).

### 26.16 Founding-Father pick dialog

The `@WHICHFREEDOM` dialog (width 190, centred, standard engine), posted by the colony-turn
update when no FF candidate is in progress. Rows = one weighted-random candidate per each of the
5 categories: "FATHERNAME (Category Adviser)" — category names from NAMES `@FOUNDING`
(Trade/Exploration/Military/Political/Religious), "Adviser" from `@MISC`; row id = category+1.

```python
regions = [
    (62, -1, 196, -1, "Pick dialog", "panel", "@width=190 => box_w=196, x=160-196/2=62; y centred, h item-driven"),
]  # 320x200 Mode 13h
```

Bindings: **cannot cancel** (result ≤0 re-shows, 0x03C231); right-click/help (`[0x1F68]`) opens
the pedia FATHER page for the candidate, then re-shows; result → `[0x84FC]+0x12` = father id.
Acquisition fires the `@FREEDOM` popup then the CCBKGD reveal (§26.12). Candidate weights =
NAMES `@FATHERS` era-weight bytes (era bands <1600 / 1600–1699 / ≥1700).

### 26.17 Tutorial / popup placement notes

Tutorial hints (`@TUTORIAL1..19`) are ordinary GAME.TXT popups through the §25.2/§25.3 engine
(portrait channel `[0x1F5E]` → MSS<n>.SS), gated by Game-Options bit 0x80 (T18 ungated).
Placement is either centred or a fixed GAME.TXT literal — never unit-relative:

| Section | Literal directives |
|---|---|
| `@TUTORIAL1` | `@x=10 @y=40` |
| `@TUTORIAL4` | `@x=10` |
| `@TUTORIAL12` | `@y=5` |
| `@TUTORIAL16` | `@x=5 @y=10 @smallfont` |
| `@TUTORIAL17` / `@TUTORIAL18` | `@y=10 @width=300 @smallfont` |
| `@VICEROY` | `@x=232 @y=21` |
| `@KINGLOSE` / `@KINGWIN` | `@x=232 @y=31` / `@x=202 @y=125` |
| all §25.3 gameplay popups | centred, `@width` 190 or 220 |

Once-flags live in save bytes `[0x5380]/[0x5386]/[0x5387]`; the unit-focus dispatcher
`func_020F50` (0x020F50) drives T1/T3/T8–T11/T13–T15/T19 from the selected unit `[0x5392]`.

---

## 27. Input, cheats, and options

The complete keyboard surface of the shipped binary, the hidden Alt-W-I-N cheat system, and the
three persisted option dialogs. Facts here fall into three trust classes: literal compare sites
in the EXE (exact codes), `~`-marked accelerator letters in the TXT menu data (exact text; the
per-row handler binding is data-driven), and printed-manual key lists whose engine wiring is
runtime table dispatch — each class is labelled where it matters.

### 27.1 Keyboard maps

**Dispatch model.** The command executor is `func_0235D6` (`switch [bp+6]` on a normalised
command/key id). Only the F-key report ladder is a literal compare chain (0x023843–0x02390B);
the single-letter accelerators are data-driven — the `~`-marked letter parsed from each menu
row (live-verified in RAM: the menu nodes carry the `MENU.TXT` labels verbatim) is matched
against the typed key by the menu engine, and the matched row's command id dispatches. So the
letters below are exact (string-table + manual-corroborated); the per-row handler binding is
runtime menu-node state, not a static per-key compare.

Map view — global single-letter commands (from the `~` accelerators of the ORDERS/VIEW rows):

| Key | Action | | Key | Action |
|---|---|---|---|---|
| Arrows | move active unit / cursor (8-way with the keypad; menus and the pedia also accept ASCII '8'/'2'/'4'/'6' aliases of scancodes 0x148/0x150/0x14B/0x14D) | | `G` | Go to port / place |
| `A` | Activate unit | | `O` | Dump cargo overboard |
| `W` | Wait for next unit | | `L` / `U` | Load / Unload cargo |
| `Space` | No orders (skip) | | `T` | Begin trade route |
| `F` | Fortify | | `Shift-D` | Disband unit |
| `S` | Sentry | | `E` | Return to Europe |
| `B` | Build / Join colony | | `V` / `M` | View mode / Move mode |
| `P` | Clear forest / Plow | | `H` | Show hidden terrain |
| `R` | Build road | | `Z` / `X` | Zoom in / out |
| `C` | Centre view | | `ESC` | exit (confirm) |
| Alt+letter | open that pulldown (Alt-G/V/O/R/T…) | | right-click | info popup |

**8-way movement / view scroll.** Cursor movement is handled by the keyboard movement
dispatcher `func_023F1C` (0x023F1C..0x0241CE) on the last scan code `[0x981E]`: the arrow/numpad
arms bump the cursor `[0x17C]/[0x17E]` by ±1 (or the page step `[0x188]`), clamped to the map
bounds `[0x853A]/[0x853C]`; the extended-scancode block 0x147..0x151 selects a **direction code
0..7** through the 9-entry jump table at file 0x024170 (`jmp cs:[bx·2+0x3290]`) — full 8-way
movement including the keypad diagonals — which then either issues the unit move or scrolls the
view (`0x181F:0xDA4`).

F-key reports (explicit `cmp [bp+6],code` ladder — all byte-cited):

| Key | Report | code | Thunk | Body @file |
|---|---|---|---|---|
| F1 | Terrain Information | 0x48 | `0x191F:0x41A` | 0x3744A |
| F2 | Religious Adviser | 0x41 | `0x191F:0x40C` | 0x37958 |
| F3 | Continental Congress | 0x42 | `0x191F:0x3FE` | 0x37A10 |
| F4 | Labor Adviser | 0x43 | `0x191F:0x3F0` | 0x38418 |
| F5 | Economic Adviser | 0x44 | `0x191F:0x3E2` | 0x38A50 |
| F6 | Colony Adviser | 0x45 | `0x191F:0x3D4` | 0x39218 |
| F7 | Naval Adviser | 0x46 | `0x191F:0x3C6` | 0x3954C |
| F8 | Foreign Affairs | 0x47 | `0x191F:0x3B8` | 0x39888 |
| F9 | Indian Adviser | 0x49 | `0x191F:0x3AA` (gated, see §27.2) | 0x39EE2 |
| F10 | Colonization Score | — | score path | 0x3A9C0 |

Colony screen (manual-sourced — the keys drive the multi-function display, no static per-letter
compare): Tab view-to-view; arrows within view; Enter jobs menu; `L`/`=` load all, `+` load
some; `U`/`-` unload all, `_` unload some; `M` toggle views; `1`/`2`/`3`
production/units/construction; `N` numbers on/off; `C` construction menu; `B` buy; `F1` info;
`ESC` exit.

Europe screen (manual-sourced; `x`/ESC byte-corroborated): Tab; arrows; Enter dock/harbor
options; `L`/`=` buy full, `+` buy some; `U` sell, `-`/`_` sell all/some; `R`/`1` recruit,
`P`/`2` purchase, `T`/`3` train; `F1` info; `ESC`/`E` exit.

Dialogs / popups: arrows move the highlighted row; Enter/click confirms; Space/Enter/click
dismisses a message; row highlight = the `0x181F:0xCE` 1-px hollow outline. Boot menu: arrows,
ENTER 13, ESC 27, SPACE 32, digits + first letters. Pulldowns: '8'/'2' or arrow scancodes
navigate, 0x14B/0x14D switch menus, item-shortcut letters fire rows, releasing Alt closes.
Internal abort codes 0x110/0x12D in the idle poll set the abort flag `[0x828]`.

### 27.2 The Alt-W-I-N cheat system

- **Master flag** = bit 0x20 of `[0x5383]`. Cleared at new-game init (`mov word [0x5382],0xC600`
  at 0x0755E5); survives load (`and word [0x5382],0x207F` at 0x02306A).
- **Enable combo: Alt-W, Alt-I, Alt-N** in the map key handler `func_023F1C` — sequence state
  `[0xB92]`, key compares 0x111/0x117/0x131 at 0x023FA9/0x023FB9/0x023FD0 → `xor byte
  [0x5383],0x20` + un/hide the CHEAT menu + redraw. No CLI or file enable exists.
- The CHEAT pulldown (`@CUP`, header "~CHEAT") is always built as menu 6 with hard-coded command
  ids, hidden while the bit is clear (`test [0x5383],0x20` at 0x072A8B).
- **Anti-cheat**: with cheat mode on, F10 Colonization Score is refused with a **beep**
  (`test [0x5383],0x20` at 0x0238D1 diverts the dispatch); F9 uses the same gate bit.

Cheat-menu command table (row order per `@CUP`; ids 0x62..0x6F):

| id | Item | Effect (byte-cited) |
|---|---|---|
| 0x62 | F01 Create Unit | DEBUG `@CREATE` (peace) / `@CREATE2` (war): unit spawner at the map cursor (`[0x853E]/[0x8540]`); rows → unit types (row 9 → `@CSHIP` Caravel..Man-O-War; rows 10–13 Indians owned by the village under the cursor, or war remaps to Continental/King's forces; row 14 → `@FOREIGN`/`@FOREIGN2` creating-power picker) |
| 0x63 | F02 Debug Info Flags | the `[0x894]` checkbox dialog (§27.3) |
| 0x65 | F04 Reveal Map | `@SETVIEW`: view-as-power `[0x53A4]`, row 5 Complete Map `[0x53A2]=1` + clears the cheat bit |
| 0x66 | F05 Set Human Player | `@SETHUMAN`: all powers AI, picked power human (`[0x5398]/[0x5394]/[0x5396]`); "None" → `@SETAUTO` autoplay `[0x826]=1` |
| 0x67 | F06 Kill Indians | runtime tribe menu → `func_046FC2` destroys every village (base 0x54EC stride 0x12) owned by tribe+4 |
| 0x68 | F07 Advance Revolution Status | `@FORCED`, staged: (a) rebel meter `[0x53D0]`=75 + create REF power; (b) declare independence (`[0x5382]|=1`); (c) next war stage (`|=2`); (d) `|=0x20` + text |
| 0x69 | Sound Test | DEBUG `@SOUND` numeric dialog ("Play what sound #?") → `[0x9CC8]` → gated play `0x181F:0x4C0` — arbitrary sound-id playback |
| 0x6A | Memory Check | DEBUG `@MEMORY` display-only: far-heap / menu-arena / near / stack free + PSP segment |
| 0x6B | F08 Show Strategy | `func_02165E`: plots the 64×4-byte AI strategy slots per power (BSS 0x98B0+power·0x100, {x,y,?,type}); pass 2 prints 14 counter rows at (5, i·7+10) colour 0xF |
| 0x6C | F09 Show Colony Sites | `func_021602`: per-tile site desirability (low nibble of the tile flag byte) drawn over the map |
| 0x6F | F010 Test Routine | `and [0x5382],0xF4` + dialog with unit count `[0x539C]` / colony count `[0x539E]` |

Ungated debug: the `@DANGER` AI-assertion box (`func_078142`, 37 call sites) fires in the
shipping binary on AI sanity-check failure.

### 27.3 The `[0x894]` debug bitfield (7 bits; session-only; default 8)

Builder `func_02356C` (cheat id 0x63): checkbox dialog over DEBUG `@OPTIONS` (7 rows), preset
`and dx,[0x894]`, rebuild `or [0x894],ax`. The field lives in **no save block** — session-only —
and boots with **bit 0x08 already set** (live-verified at boot and in-game; invisible without
the cheat bit).

| bit | Row | Tester | Effect |
|---|---|---|---|
| 0x01 | Anger & Friction Levels | 0x004241 / 0x044303 | white anger number at village px+2/py+9; info panel appends 8 tribe rows |
| 0x02 | Indian AI movement | 0x0470A3 | shows AI moves + tile flash when visible to the human |
| 0x04 | Supply and Demand (Indians) | 0x0494DA/0x0495DE | 16-good supply/demand dump, x=1, y=8·(g+1), colour 0x0F, blocking getch |
| 0x08 | Foreign AI planning modes | 0x003971 (ALSO requires the cheat bit) | AI units' map letters become their plan-mode char (≥0x80 → 'E') |
| 0x10 | Close Moves | 0x061F14 | per-tile path-cost overlay, red summary (5,190), Z/X zoom |
| 0x20 | Far Moves | 0x062975 | "Far: %d(%d,%d)…" overlay |
| 0x40 | All Movement | 0x062D94 | sets latch `[0x1DF2]` honoured by the Close-Moves renderer |

### 27.4 The three options dialogs

All are standard §25.2 checkbox dialogs over GAME.TXT sections; checkbox channel = bitmask word
`[0x1F54]` (reset `0x191F:0x26E`, pre-seed `0x262`, read-back `0x306`).

**Game Options** (`@GAMEOPTIONS`, width 190, `func_022FD6`; state word `[0x5382]`, clear mask
`and 0x207F` — deliberately preserving the 0x2000 cheat-master bit):

| Row | Option | Bit | Polarity |
|---|---|---|---|
| 1 | Show Indian Moves | 0x8000 | direct |
| 2 | Show Foreign Moves | 0x4000 | direct |
| 3 | Fast Piece Slide | 0x1000 | direct (slide step 8 vs 10, zoom-shifted) |
| 4 | End of Turn | 0x0800 | direct |
| 5 | Autosave | 0x0400 | direct (rolling slot 9 each turn + slot 8 on decades) |
| 6 | Combat Analysis | 0x0200 | direct (gate at 0x05D221) |
| 7 | Water Color Cycling | 0x0100 | **INVERTED** — bit set = cycling OFF; side-effect: `[0x372]` master + vblank-synced full DAC restore when disabling |
| 8 | Tutorial Hints | 0x0080 | direct |

**Colony Report Options** (`@COLONYOPTIONS`, width 220, `func_02311A`; state word `[0x5384]`,
clear `and 0xFC00`). **All 10 bits are INVERTED — a set bit means "suppress"**:

| Row | Option | Bit | | Row | Option | Bit |
|---|---|---|---|---|---|---|
| 1 | Labels on buildings | 0x0002 | | 6 | Report tools needed | 0x0010 |
| 2 | Labels on cargo and terrain | 0x0001 | | 7 | Report inefficient government | 0x0008 |
| 3 | Report when colonists trained | 0x0080 | | 8 | Report new cargos available | 0x0004 |
| 4 | Report food shortages | 0x0040 | | 9 | Report Sons of Liberty membership | 0x0100 |
| 5 | Report raw materials shortages | 0x0020 | | 10 | Report rebel majorities | 0x0200 |

**Sound Options** (`@SOUNDOPTIONS`, `func_0232AE`): row 1 `[0xA2]` Background Music, row 2
`[0xA0]` Event Music, row 3 `[0xA4]` Sound Effects — mirrored into the persisted flag word
`[0x5386]`; turning an option off sends driver command 1 (stop). **Pick Music** (`@PICKMUSIC` +
3 sub-pickers, `func_023344`): rows 1–12 = the folk tunes, rows 13/14/15 open the
Independence/Military/Indian sub-lists; selection → tune id `[0x96]` (ids 0x20..0x3B) + gated
play; no persistent lock — normal rotation resumes when the tune ends.

**Persistence**: `[0x5382]` (game options), `[0x5384/5]` (colony options) and `[0x5386]` (sound
mirror) all live in **save block #3** (base 0x5380, size 0x8E), written by `func_0734F8` and
restored by `func_073BB0` — all three dialogs survive save/load; `[0xA0]/[0xA2]/[0xA4]` and the
water-cycling master `[0x372]` are re-derived on load. The debug bitfield `[0x894]` is in no
save block — session-only. No configuration file exists.
