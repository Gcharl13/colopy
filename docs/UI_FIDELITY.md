# UI Fidelity — Byte-Cited Pixel Specs

Pixel-faithful UI formulas reverse-engineered from `raw/COLONIZE/VICEROY.EXE`.
Every constant below cites a raw VICEROY.EXE file offset (verified with
`xxd` against the binary, not just the disassembly). Disassembly source:
`code/VICEROY/disasm_overlay_reseg/page_17.asm` (segment file-base 0x06BB00;
in-segment offset + 0x06BB00 = file offset). `mapedit.c` is NOT cited.

**Sections (all byte-verified 2026-05-30):** Fonts · Sprites · Popups/Dialogs ·
Menus. These are the fidelity primitives the port still approximates — which
font/sprite each element uses, and how dialog/menu boxes are sized. Layout
geometry (where boxes sit) is in `SCREEN_LAYOUTS.md`; this doc is the *how it's
drawn* layer.

---

## Popups / Dialogs

### Overview of the geometry pipeline

A message/dialog box is a "panel" struct. Three functions build it:

1. **`func_06C520`** (file 0x06C520, `panel_construct`) — allocates the
   panel struct (size 0x29 paragraphs via `lcall 0x1a1f:0x356` at 0x06C56E),
   zeroes it, and writes the geometry **defaults**: border thickness `+0x46`,
   inner inset `+0x48`, default content-width `+0x28 = 0x50` (80).
2. **`func_06C850`** (file 0x06C850, text-element adder) and the line-builder
   path through **`func_06CCxx`** — for each body line, measure its pixel
   width (`func_06C2D6` → font engine `lcall 0x181f:0x204`) and grow the
   panel's content-width fields `+0x20` / `+0x34`.
3. **`func_06D316`** (file 0x06D316, `panel_finalize_geometry`) — folds line
   count, border, title, and option rows into the final width `+0x14` and
   height `+0x16`, then **centers** the box on the 320×200 screen into `+0x10`
   (x) / `+0x12` (y) and clamps it on-screen.

The drawn-rect API later reads the 4 result words and a 320×200 clip rect
(`func_06E2DE` / `func_06E3D0`; see `docs/POPUP_TEMPLATE_AUDIT.md` for the
frame/sprite blit and `docs/DIALOG_GEOMETRY.md` for the cursor-anchored
tooltip variant — a *different* mechanism from this centered-dialog path).

### Panel-struct geometry fields (subset, byte-cited)

| Field | Role | Set at |
|-------|------|--------|
| `+0x0a` | flags byte (bit 0x10 = compact/no-frame) | (caller) |
| `+0x0c`/`+0x0e` | requested X / Y (`@x=`/`@y=`; default −1 = "auto") | (parser) |
| `+0x10`/`+0x12` | final draw X / Y (origin, top-left) | 0x06D349 / 0x06D522 / 0x06D53B |
| `+0x14` | final box **width** (px) | 0x06D359 (seed 0) → grown |
| `+0x16` | final box **height** (px) | 0x06D369 (seed) → grown |
| `+0x20` | running max single-line content width | 0x06CA27 / 0x06D3B2 |
| `+0x28` | default/min content width = **0x50 (80)** | 0x06C5A6 |
| `+0x34` | running max line width **+ 0x0A (10)** margin; @width floor | 0x06CCF3 |
| `+0x46` | **border thickness**: (flags&0x10)? 0 : **3** | 0x06C5E9 |
| `+0x48` | **inner inset**: (flags&0x10)? 0 : **2** | 0x06C5F5 |
| `+0x4a` | body line count (rows) | 0x06C68D (init) |

### 1. WIDTH

The box width `+0x14` starts at 0 (0x06D359: `mov es:[bx+0x14],0`). The
content width used to size it is the running maximum line width:

- Per body line (line-builder, 0x06CCDB–0x06CCF3):
  `line_w = text_pixel_width + sub_width + 0x0A` then
  `[bx+0x34] = max([bx+0x34], line_w)`. The **+0x0A (10 px)** is the
  left+right body margin. (`func_06C850` independently maintains `+0x20` as
  `max(text_w + border*2 + inset)` at 0x06C9E8/0x06CA27.)
- `func_06D316` then takes the **largest** of the three width candidates
  (0x06D392–0x06D3B2): `width_base = max([bx+0x28]=80_default, [bx+0x20],
  [bx+0x34])` and stores it into `+0x20`, `+0x28`, **and** `+0x34`.

So `@width=N` (directive keyword `"WIDTH"` at file **0x1F989**, parsed by the
section parser `lcall 0x191f:0x928` → file 0x02591A; see
`docs/POPUP_TEMPLATE_AUDIT.md`) supplies the **minimum/floor** content width:
it seeds `+0x34` so that even a short line yields a box at least `@width`
wide. It is a floor, NOT a hard clamp — a line longer than `@width` widens the
box further (the `max` at 0x06D392). The only hard upper bound is the screen
edge (see POSITION clamps below).

`+0x14` (final pixel width) is then the content width with border added:
along each layout branch the code does `width_base + [bx+0x46]` (border)
before centering — e.g. 0x06D4BA (`add ax,[bx+0x46]`) and the title/option
branches at 0x06D61D (`add ax,3`), 0x06D606 (`add cx,3`).

**Width formula (normal framed dialog, flags&0x10 == 0):**
```
content_w = max(80, longest_body_line_px + 10, @width)
box_w     = content_w + border(=3) + per-branch padding (3..6)
```

### 2. HEIGHT

Height `+0x16` is seeded from line count × line metric plus the border
(0x06D35F–0x06D369):
```
06D35F  mov ax, es:[bx+0x4a]   ; ax = line_count (rows)
06D363  shl ax, 1              ; ax = line_count * 2
06D365  add ax, es:[bx+0x46]   ; + border (3)
06D369  mov es:[bx+0x16], ax   ; height seed
```
i.e. **height_seed = line_count×2 + border**. The body line-stepping itself
is applied per-line through the line-builder/render loop (each option/body
line advances the running height); the title strip and option-list rows then
add fixed reservations:

- **Title strip**: if a title is present (`+0x80/+0x82` set), height grows by
  the title's measured rows × the title metric (0x06D461–0x06D4A7), plus a
  fixed **+6** when the title equals the active section, else **+3**
  (0x06D509 `add es:[bx+0x16],6` / 0x06D513 `add es:[bx+0x16],3`). The +3/+6
  gate is `[0x1f66]` and a title-string match at 0x06D4F4.
- **Option list** (`@OPTIONS`, second tree at `+0x68/+0x6a`): each option row
  reserves `option_text_rows + 3` (0x06D606 `add cx,3`) and the block adds
  `+3` again (0x06D61D `add ax,3`) for inter-block spacing.

> **Per-row line-height constant — RESOLVED (see Fonts section).** The fixed
> contributions (`×2` row seed at 0x06D363; `+3`/`+6` title; `+3` option
> spacing) are byte-pinned here. The body font is **FONTTINY** (`[0x89E]`, the
> engine default); the `SMALLFONT` directive also binds to fonttiny (0x06F207),
> **not** a "FONTSMAL" (which is an unloaded on-disk orphan — see Fonts). The
> per-line pixel step = the font's **glyph line height = decompressed `.FF`
> record byte 0**, with line advance `byte0 + 1` (renderer reads it at
> 0x031BCB / 0x0324CE). So the height seed `line_count×2` is the geometry
> reservation; the actual text advance comes from FONTTINY's byte0.

### 3. POSITION (centering)

After width `+0x14` and height `+0x16` are final, the box origin is centered
on the 320×200 screen — but only if the requested coordinate is the sentinel
−1 (0xFFFF). The requested X/Y come from `@x=`/`@y=` (default −1) seeded
`+0x0c/+0x0e` → copied to `+0x10/+0x12` at function entry (0x06D349 / 0x06D351):

**X centering** (0x06D51B–0x06D52D):
```
06D51B  cmp es:[bx+0x10], -1   ; X requested?
06D520  jne ...                ; if @x given, keep it
06D522  mov ax, es:[bx+0x14]   ; ax = box_w
06D526  sar ax, 1              ; box_w / 2
06D528  sub ax, 0xA0           ; - 160
06D52B  neg ax                 ; = 160 - box_w/2
06D52D  mov es:[bx+0x10], ax   ; X
```
=> **X = (320 − box_w) / 2**  (0xA0 = 160 = 320/2).

**Y centering** (0x06D534–0x06D546):
```
06D534  cmp es:[bx+0x12], -1   ; Y requested?
06D539  jne ...
06D53B  mov ax, es:[bx+0x16]   ; ax = box_h
06D53F  sar ax, 1              ; box_h / 2
06D541  sub ax, 0x64           ; - 100
06D544  neg ax                 ; = 100 - box_h/2
06D546  mov es:[bx+0x12], ax   ; Y
```
=> **Y = (200 − box_h) / 2**  (0x64 = 100 = 200/2).

**On-screen clamp** (0x06D54A–0x06D585): compute right edge `X + box_w` and
bottom edge `Y + box_h`; if right > **0x140 (320)** shift X left by the
overflow (0x06D563 `cmp ax,0x140` … 0x06D56D `add es:[bx+0x10],ax`); if
bottom > **0xC8 (200)** shift Y up by the overflow (0x06D571 `cmp [bp-0x22],
0xC8` … 0x06D581 `add es:[bx+0x12],ax`). So the box is kept fully inside the
320×200 frame after centering or after an explicit `@x/@y`.

### 4. BORDER / PADDING / BUTTONS

- **Frame thickness = 3 px** for a normal dialog. Set in `func_06C520`
  (0x06C5DA–0x06C5E9): `cl = (flags & 0x10) ? 0 : 3` → `+0x46`. (The
  `cmp ax,1; sbb cx,cx; and cx,3` idiom yields 3 when bit 0x10 is clear.)
- **Inner inset = 2 px** for a normal dialog. Same idiom at 0x06C5ED–0x06C5F5:
  `(flags & 0x10) ? 0 : 2` → `+0x48`. The inset is doubled (×2) where applied,
  e.g. `func_06D316` 0x06D363 (`shl 1`) and `func_06C850` 0x06C9E8
  (`[bx+0x48] shl 1`), i.e. inset is added on both top/bottom or left/right.
- **Body left/right margin = 10 px** (`+0x0A`) added to each line width
  (0x06CCE3, see WIDTH).
- **Default/min content width = 80 px** (`+0x28 = 0x50`, 0x06C5A6).
- **OK/Cancel button row — TBD (sprite + exact placement).** The option /
  button list is the second linked-list tree at `+0x68/+0x6a`; its rows are
  height-reserved as `rows + 3` (0x06D606) and positioned by the option
  layout branches (0x06D5FA–0x06D7FC) which sub-center each row using the
  *same* `(width)/2 − 0xA0` / `(height)/2 − 0x64` idiom against the option's
  own measured cell. The actual button **sprite** (WOODFRAM/NAMEPLAT button
  art) and its pixel size are NOT a literal in page_17 — they are blitted from
  loaded SS assets (see `docs/POPUP_TEMPLATE_AUDIT.md` "Frame & body
  rendering"). Mark button geometry **TBD** until the SS button sprite index
  is pixel-verified.

### 5. ROW STEPPING / WORD-WRAP

- **Row stepping**: the body is a linked list of pre-split lines (one tree
  node per line, `+0x54/+0x56` head; `func_06CCxx` adds nodes). Each node
  advances the running content height; the fixed per-block reservations are
  `+0x46` (border, in the ×2 seed) and `+3`/`+6` (title) / `+3` (options) as
  cited in HEIGHT. The numeric inter-line pixel pitch is the font glyph
  height — **TBD** (see HEIGHT note).
- **Word-wrap to `@width`**: NO automatic word-wrap was found in this path.
  Lines are split on the literal `|` / newline control characters by the
  line-builder, and on `~` / `{` / `}` for highlight (see
  `docs/DIALOG_TEXT_FORMAT_BYTE_CITED.md`). `@width` acts as a *minimum box
  width* (floor on `+0x34`), not as a wrap column — GAME.TXT body strings are
  pre-wrapped by hand in the data file. (Confirmed by GAME.TXT inspection:
  body lines are stored already broken, e.g. @KINGTAX in
  `docs/POPUP_TEMPLATE_AUDIT.md`.) If a single stored line exceeds `@width`,
  the box widens to fit it (the `max` at 0x06D392), then the on-screen clamp
  caps it at 320. **No per-character wrap-to-@width logic exists** in
  func_06C520 / func_06D316 / the line-builder — TBD only in the sense that
  this is an absence, not a missing trace.

### Net formulas (normal framed, centered dialog)

```
border      = 3                                   # @0x06C5E9 (flags&0x10 ? 0 : 3)
inset       = 2                                   # @0x06C5F5
body_margin = 10                                  # @0x06CCE3
content_w   = max(80, longest_line_px + 10, @width)   # @0x06C5A6 / @0x06D392
box_w       = content_w + border (+3..+6 per layout branch)
box_h       = line_count*2 + border               # @0x06D363  (+ title/option rows)
              + (title ? title_rows*metric + (match?6:3) : 0)   # @0x06D509/@0x06D513
              + (options ? sum(option_rows + 3) + 3 : 0)        # @0x06D606/@0x06D61D
X = (@x == -1) ? (320 - box_w)/2 : @x             # @0x06D522  (0xA0=160)
Y = (@y == -1) ? (200 - box_h)/2 : @y             # @0x06D53B  (0x64=100)
# then clamp: if X+box_w>320 shift left; if Y+box_h>200 shift up
#   @0x06D563 (0x140=320) / @0x06D571 (0xC8=200)
```

---

## Menus

Two distinct things are called "menus": **(A)** the title-screen main-menu
list (New Game / Load / etc.) and **(B)** the in-game menu-bar dropdowns
(Game / View / Orders / Reports / Trade / Cheat). Byte-tracing shows **(A) and
(B) share ONE runner and ONE geometry engine** — the same panel/widget engine
documented under *Popups / Dialogs* above. They are NOT a separate code path.

### Architecture — the menu runner is NOT `0x181F:0x3FE`

The often-quoted "menu runner = `lcall 0x181F:0x3FE`" is a thunk for
`opt_register`, not the runner. The real chain (every link byte-verified):

```
title @BEGINMENU:  lea bx,[0x2345]; lcall 0x181F:0x3FE       @0x075C60
in-game dropdown:  (stage key/mode via 0x181F:0x3FE / 0x652 / 0x416 …)
        │
        ▼  0x181F:0x3FE → page 0x17 file 0x06F594  (func_06F57E+0x16, opt_register)
opt_register(key):  mov ax,bx; lea bx,[0x87C]; sub dx,dx; call cs:0x3CEF   @0x06F594
        │           (0x87C = the shared menu/option DESCRIPTOR base)
        ▼  cs:0x3CEF = ljmp 0x181F:0x998 → page 0x17 file 0x06F51A
menu_lookup_run():  rec = opt_lookup_rec();  if(rec){ ret = opt_win_query(rec);
                    opt_win_dispose(rec); }  return ret;                @0x06F51A
        │   opt_lookup_rec  = cs:0x3D03 = ljmp 0x191F:0x182 → page 0x17 file 0x06F0F4
        │   opt_win_query   = cs:0x3CF9 = ljmp 0x191F:0x16A → page 0x17 file 0x06E3D0
        ▼   opt_win_dispose =                lcall 0x191F:0x1A8 → page 0x1F (free window)
returns the 1-based chosen item index (0 = cancel) in AX.
```

- **`func_06F0F4`** (file 0x06F0F4, 1061 B, `0x191F:0x182` = *build/lookup the
  menu record*): the **@-directive template parser**. It seeds a work buffer
  from `str 0x2478` (`lcall 0xD1D:0x7E4` @0x06F11C), then walks the section
  line-by-line (`lcall 0x191F:0x928`/`0x91C` record readers @0x06F126/0x06F174),
  parsing lines that start with `@` (0x40, `cmp byte[bx],0x40` @0x06F193).
  Recognised `@`-keywords build the rows: WIDTH (`0x1FE9`), end/continue
  (`0x1FC7`/`0x1FCF`/`0x1FD6`), sprite-dims (`0x1FDB`), field `+0xE`/`+0xC`
  (`0x1FE5`/`0x1FE7`), msg-arg (`0x1FEF`), flags|=5 (`0x1FF6`), assign
  (`0x1FFF`). This is the engine `@BEGINMENU` (title) and every in-game
  dropdown/dialog section feeds.
- **`func_06E3D0`** (file 0x06E3D0, 2820 B, `0x191F:0x16A` = *run + hit-test*):
  the interactive picker. Reads the per-option enable bitmask `[0x1F54]`, the
  input/cursor globals (`[0x7E8]`/`[0x7EA]` mouse, `[0x7E4]`/`[0x7EE]`/`[0x7F0]`
  edge flags) and the screen-mode word `[0x1F5C]`; draws the rows and the
  selected-row highlight; returns the picked index.

Because both (A) and (B) route through `func_06F0F4` (build) + `func_06D316`
(geometry, *Popups/Dialogs* above) + `func_06E3D0` (run), **menu-box sizing is
identical to dialog sizing**: the width/row-height/total-height/origin formulas
in *Popups / Dialogs* apply verbatim. Differences are only in the *content tree*
fed in (buttons vs label-rows vs value-rows) and the `[0x1F5C]` mode.

### Menu-box sizing (applies to A and B)

Re-stated from `func_06D316` (`panel_finalize_geometry`) for the menu case
(every constant byte-pinned — see *Popups/Dialogs* and the spot-check table):

| quantity | formula | @asm |
|----------|---------|------|
| content-W/H base | `2·PANEL[+0x4A] + PANEL[+0x46]` → PANEL[+0x16] | 0x06D35F |
| border inset `b` | `(PANEL[+0x0A] & 0x10) ? 0 : 3` | 0x06D36D |
| inner width | `max(PANEL[+0x28]=80, PANEL[+0x20], PANEL[+0x34])` | 0x06D392 |
| **button rows** | `rowH = textkind(+0x80,+0x82) + PANEL[+0x46]`; `H = rowH · PANEL[+2]` | 0x06D46B/0x06D478 |
| **value rows** | `rowH = textkind(…) + PANEL[+0x46] + 5`; `H = rowH · PANEL[+8]` | 0x06D493/0x06D499 |
| label rows | last `node[+2]` (right-extent) competes with `rowsH` for content-y | 0x06D405/0x06D4D2 |
| final width | `PANEL[+0x14] += 2·b + PANEL[+0x20]` | 0x06D4E5 |
| final height | `PANEL[+0x16] += 2·b + max(last_label[+2], rowsH)` | 0x06D4DD |
| hover frame | `+6` if anchored to live cursor `(0x89E,0x8A0)` else `+3` | 0x06D509/0x06D513 |
| **origin X** | `(PANEL[+0x10]==-1) ? 0xA0 - box_w/2 : @x` | 0x06D51B |
| **origin Y** | `(PANEL[+0x12]==-1) ? 0x64 - box_h/2 : @y` | 0x06D534 |
| clamp | if `X+w > 0x140` shift left; if `Y+h > 0xC8` shift up | 0x06D563/0x06D571 |

**Row height (the per-item vertical step)** = `textkind(line) + PANEL[+0x46]`,
where `textkind` is `func_06CD66` (file 0x06CD66): it reads the **first byte of
the row string as a text-class index 0..6** (`mov al,es:[bx]` @0x06CD6D),
remapping 6→5 when `[0x1F8A]==0`, and returns it. `PANEL[+0x46]` is the font
cell height. So the step is **data-driven per row** (a small class byte + font
height), which is why the per-option row Y is `[layout]`, not a fixed literal.
For the common single-class menu the step is constant within one menu.

### Item layout (left inset, highlight bar, hotkey/overflow)

From the row painters (`overlay_06D938_0702D5.c`, all byte-cited):

- **Button row** (`func_06DC64`, file 0x06DC64): origin `ox = PANEL[+0x24] +
  PANEL[+0x48]`, `oy = PANEL[+0x26]` (@0x06DC74). Label drawn inset; a click/
  highlight cell is blit via `lcall 0x181F:0xCE` (@0x06DD68). If the label is
  longer than `node[+6]` cells it is truncated and an **overflow marker
  `[0x1F9B]`** (an ellipsis-class string) is appended (`lcall 0xD1D:0x7A4`
  @0x06DCD2). **Selected/hover row**: when `node[0] & 0x80` is set, the label is
  redrawn with the **highlight font `PANEL[+0x40]/[+0x42]`** instead of the
  normal font `PANEL[+0x3C]/[+0x3E]` (@0x06DDC8 → call 0x68c @0x06DE19).
- **Value row** (`func_06D9CC`, file 0x06D9CC): `base_x = PANEL[+0x24] +
  PANEL[+0x48] + PANEL[+0x22]`, `base_y = PANEL[+0x26]` (@0x06D9D6); per-row
  advance `base_y += rowH + PANEL[+0x46]` (@0x06DC0A). Selected cell
  (`PANEL[+0x4C]/[+0x4E] == this node`) is drawn with the highlight font
  `+0x40/+0x42` (@0x06DA85). A separator row draws a bar via `lcall 0x181F:0xBA`
  (@0x06DB4B).
- **Label row** (`func_06DE6E`, file 0x06DE6E): style indent `= (node[+0x0A] &
  0x10) ? 0 : 3`; the **cursor row** (`node == PANEL[+0x50]/[+0x52]`) gets an
  **inverse-cursor highlight cell** via `lcall 0x181F:0xCE` width `0x0F`
  (@0x06E022). Right-alignment uses the last node's `[+2]` extent (pass 1).
- **Highlight bar dimensions**: the selected-row highlight is the cell blit at
  `0x181F:0xCE` (the same primitive the HUD uses for boxes); its width is the
  option cell width (`node[+2]` / `0x0F` for the label-cursor case) and its
  height is the row height above. There is **no separate hotkey/checkmark
  column** in the menu rows themselves — hotkey accelerators are parsed out of
  the label text by `func_06C2D6` (the `~`-split accelerator resolver), not laid
  out as a fixed column. Checkbox state is the per-option bit in `[0x1F54]`
  (`opt_flag_set`/`opt_flag_test`, file 0x06F554/0x06F57E), reflected by the
  `node[0]&0x80` highlight, not a glyph column.

### Wide / compact (multi-column) mode

`func_06D938` @0x06D93D: `wide = ([0x1F5C] > 7) ? 1 : 0` (`cmp [0x1F5C],7;
jle`). When the staged screen-mode word `[0x1F5C]` exceeds 7 the renderer pairs
a second value column (`func_06D938` second `acc_value`, gated also on
`[0x1F6E]` and `[0xA5AE] > 0`). `[0x1F5C]` is the word the menu model stages via
`opt_set_field_a` (file 0x06F5B0, writes `[0x1F5C]`). This is the only
menu-vs-dialog content-layout discriminator found.

### (B) The in-game menu-BAR strip (the top y≈0..7 bar)

The bar that hosts the dropdown labels is painted by **`draw_map_view_chrome`**
(`func_06083A`, overlay page 0x06, file 0x06083A; see `src/render/hud.c`). It is
a FIXED-coordinate strip, NOT laid out by the menu engine:

| element | x | y | w | h | how | @asm |
|---------|---|---|---|---|-----|------|
| **menu-strip fill** | 0 | **5** | **0x140 (320)** | — | color `0x0F`, `lcall 0x181F:0x100` | 0x060898 (args) / 0x0608A6 (call) |
| full-screen frame box | 0 | 0 | 0x140 | 0xC8 | `lcall 0x181F:0xE2` | 0x060C1E |

- **Bar height**: the strip fill is anchored at **y=5**, and the **map viewport
  begins at y=8** (`render_frame_setup`, SCREEN_LAYOUTS §1 / RENDERER_GEOMETRY
  v3). So the menu-bar occupies the **top 8 px (y=0..7)**, height **8**. (The
  brief's "y=0..11" is ~3 px too tall; the frame-verified value is 8 — see
  RENDERER_GEOMETRY.md "REVISED v3": *"top menu (0, 0, 320, 8); map viewport
  begins at y=8, not y=14."*)
- **Per-label x positions**: the labels GAME / VIEW / ORDERS / REPORTS / TRADE /
  CHEAT (+ COLONIZOPEDIA) are drawn at **x = 4, 44, 84, 144, 200, 244**, **y =
  2** (`topmenu_render` in hud.c). These x's are **frame-verified, NOT
  byte-pinned** to a draw-call immediate — they come from a string-table walk
  in `func_06083A` whose per-label x stepping was not byte-isolated. **TBD:** the
  exact draw-call that emits each label x (the label loop in func_06083A).
- **How a dropdown's x derives from its label**: the dropdown opens anchored to
  the live cursor/label coord. `func_06D316` centering only fires when the
  requested origin is the `-1` sentinel; for a menu-bar dropdown the caller
  stages a real `@x`/`@y` (the label's bar x and y=8, the bar bottom) into
  `PANEL[+0x0C]/[+0x0E]`, so the box opens **below its label** and is then
  on-screen-clamped (right edge ≤ 320). **The exact "label x → dropdown @x"
  assignment site is TBD** (it is in the menu-bar input handler, not in
  func_06083A or func_06D316; the keyboard/menu-bar command source is also the
  open item in `docs/DEBUG_MENU.md`).

### (A) vs (B) — do they differ?

**Sizing: identical.** Both build a panel via `func_06F0F4` and size it via
`func_06D316`; the width = `max(80, longest item + margins, @width)` + border,
the row step = `textclass + font-height`, the total height = `rows·step +
border + title/hover`, and the origin centers on (160,100) unless `@x/@y` is
given. The only differences:

| aspect | (A) title main-menu list | (B) in-game dropdown |
|--------|--------------------------|----------------------|
| invoked from | `func_0759E8` @0x075C60 (`lea bx,[0x2345]`, @BEGINMENU) | menu-bar input handler (per-label key) |
| origin | centered (no `@x/@y` ⇒ −1 sentinel ⇒ (160,100)) | anchored `@x` = label x, `@y` = 8 (opens below bar) |
| host strip | drawn over the OPENING/OPENBORD backdrop (no bar) | drawn under the y=0..7 menu-bar strip |
| `[0x1F5C]` mode | menu mode (single column) | per-command (Europe=4 / Report=5 …; >7 ⇒ wide) |
| dispatch | `dec ax` ladder: 1=exit 2=load 3=setup 4=new-game @0x075C6D | screen-mode latch + command router `func_0235D6` |

So: **one geometry engine, two callers with different origin/anchor and content
mode.** No separate "main-menu sizing" vs "dropdown sizing" code exists.

### Menu spot-checks (file offset : expected bytes)

| # | What | File offset | Expected bytes (hex) | Meaning |
|---|------|-------------|----------------------|---------|
| M1 | **title @BEGINMENU run** | `0x075C60` | `8D 1E 45 23 9A FE 03 1F 18` | `lea bx,[0x2345]; lcall 0x181F:0x3FE` (main-menu runner entry) |
| M2 | **opt_register** (`0x181F:0x3FE`) | `0x06F594` | `8B C3 8D 1E 7C 08 2B D2` | `mov ax,bx; lea bx,[0x87C]; sub dx,dx` (stage key into descriptor 0x87C) |
| M3 | **menu_lookup_run** (`0x181F:0x998`) | `0x06F51A` | `C8 06 00 00 C7 46 FE 00 00` | `enter 6,0; [bp-2]=0` (the runner; returns chosen index) |
| M4 | runner disposes window (`0x191F:0x1A8`) | `0x06F542` | `9A A8 01 1F 19` | `lcall 0x191F:0x1A8` (free menu/control window) |
| M5 | **menu BUILD record** (`0x191F:0x182`) | `0x06F0F4` | `C8 68 01 00` | `enter 0x168,0` (func_06F0F4 @-directive template parser) |
| M6 | build parses `@`-lines | `0x06F193` | `80 3F 40` | `cmp byte [bx],0x40` ('@' directive prefix) |
| M7 | **menu RUN / hit-test** (`0x191F:0x16A`) | `0x06E3D0` | `C8 38 00 00 56` | `enter 0x38,0; push si` (func_06E3D0 picker) |
| M8 | **row height = class + font-h** | `0x06D46B` | `E8 F8 F8 83 C4 04 C4 5E 04 26 03 47 46 26 F7 6F 02` | `call func_06CD66; …; add ax,[bx+0x46]; imul word[bx+2]` (rowH·count) |
| M9 | **value-row +5 step** | `0x06D493` | `E8 D0 F8 83 C4 04 C4 5E 04 26 03 47 46 05 05 00` | `call func_06CD66; add ax,[bx+0x46]; add ax,5` |
| M10 | **text-class (row kind 0..6)** | `0x06CD66` | `C8 02 00 00 C4 5E 04 26 8A 07` | `enter 2,0; les bx,[bp+4]; mov al,es:[bx]` (first byte = row class) |
| M11 | **wide-mode threshold** | `0x06D93D` | `83 3E 5C 1F 07 7E 06` | `cmp word [0x1F5C],7; jle` (>7 ⇒ paired column) |
| M12 | **menu-bar strip fill** | `0x060898` | `6A 0F 6A 05 68 40 01 6A 00` | `push 0x0F(color); push 5(y); push 0x140(w=320); push 0(x)` then `lcall 0x181F:0x100` |
| M13 | button-row overflow ellipsis | `0x06DCD2` | `9A A4 07 1D 0D` | `lcall 0xD1D:0x7A4` (append marker `[0x1F9B]` when label too long) |
| M14 | selected-cell highlight blit | `0x06E022` | `9A CE 00 1F 18` | `lcall 0x181F:0xCE` (inverse-cursor highlight cell, label row) |

(Width/height/origin/clamp/border spot-checks #1–#13 in the master table below
apply to menus too — same `func_06D316`/`func_06C520` engine.)

---

## SPOT-CHECK LIST (file offset : expected bytes)

All offsets are into `raw/COLONIZE/VICEROY.EXE`; all bytes below were read
from the binary and match.

| # | What | File offset | Expected bytes (hex) | Meaning |
|---|------|-------------|----------------------|---------|
| 1 | **X-centering** | `0x06D522` | `26 8B 47 14 D1 F8 2D A0 00 F7 D8` | `mov ax,es:[bx+0x14]; sar ax,1; sub ax,0xA0(160); neg ax` → X=(320−w)/2 |
| 2 | **Y-centering** | `0x06D53B` | `26 8B 47 16 D1 F8 2D 64 00 F7 D8` | `mov ax,es:[bx+0x16]; sar ax,1; sub ax,0x64(100); neg ax` → Y=(200−h)/2 |
| 3 | **Right-edge clamp = 320** | `0x06D563` | `3D 40 01` | `cmp ax, 0x140` (320) |
| 4 | **Bottom-edge clamp = 200** | `0x06D571` | `81 7E DE C8 00` | `cmp word [bp-0x22], 0xC8` (200) |
| 5 | **Height seed = rows×2 + border** | `0x06D35F` | `26 8B 47 4A D1 E0 26 03 47 46` | `mov ax,es:[bx+0x4a]; shl ax,1; add ax,es:[bx+0x46]` |
| 6 | **Border thickness (3 / 0)** | `0x06C5DA` | `26 8A 47 0A 25 10 00 3D 01 00 1B C9 83 E1 03` | `al=flags; and 0x10; cmp 1; sbb cx; and cx,3` → 3 unless bit0x10 |
| 7 | **Inner inset (2 / 0)** | `0x06C5ED` | `3D 01 00 1B C0 25 02 00` | `cmp ax,1; sbb ax; and ax,2` → +0x48 |
| 8 | **Body line margin = 10** | `0x06CCE3` | `05 0A 00` | `add ax, 0x0A` (per-line 10-px margin into `+0x34`) |
| 9 | **Default/min content width = 80** | `0x06C5A6` | `26 C7 47 28 50 00` | `mov word es:[bx+0x28], 0x50` (80) |
| 10 | **Title row reservation +6 / +3** | `0x06D509` / `0x06D513` | `26 83 47 16 06` / `26 83 47 16 03` | `add es:[bx+0x16], 6` / `…, 3` |
| 11 | **X/Y "auto" sentinel = −1** | `0x06D51B` / `0x06D534` | `26 83 7F 10 FF` / `26 83 7F 12 FF` | `cmp es:[bx+0x10],-1` / `…+0x12,-1` |
| 12 | **`@width` keyword string** | `0x1F989` | `57 49 44 54 48 00` | `"WIDTH\0"` (directive table; `"Y\0"`@0x1F985, `"X\0"`@0x1F987) |
| 13 | **Frame draw clip = 320×200** | `0x06E511` | `68 C8 00 … BB 40 01` | `push 0xC8(200); … mov bx,0x140(320)` before frame painter |

---

## Open items (TBD — not byte-pinned)

- **Per-line pixel pitch** of FONTTINY / FONTSMAL (the numeric line-height).
  Comes from the FF font glyph metrics via the font overlay
  (`lcall 0x181f:0x204` / `:0x1fa`), not from page_17. Read it from the
  FONTTINY FF header to finish the HEIGHT formula.
- **OK/Cancel button sprite + pixel size** and exact button-row Y. The option
  rows are height-reserved (`rows + 3`) and sub-centered, but the button art
  is a loaded SS sprite (WOODFRAM/NAMEPLAT family) — index TBD via
  sprite-cataloger.
- **`@width` → which DGROUP word the parser writes**, and how it reaches the
  panel `+0x34` floor. The keyword is at file 0x1F989 and the parser is
  `lcall 0x191f:0x928` (file 0x02591A); the post-parse copy of the numeric
  value into the panel struct was not traced line-by-line in this pass.

---

## Fonts

VICEROY uses MADSPACK-2.0-compressed `.FF` bitmap fonts (loader appends `.FF` at
file 0x20022). **The decompressed font record's byte 0 = line height**; the
renderer advances lines by `byte0 + 1` (read at 0x0430E8 / 0x031BCB / 0x070498 /
0x0324CE). This is the per-line pitch left TBD in the Popups + Menus sections.

**Only 4 fonts are actually loaded** (FONTSMAL.FF exists on disk but is NEVER
referenced — an orphan):

| Font | EXE string | handle | loaded into | load site |
|---|---|---|---|---|
| FONTTINY.FF | `fonttiny` | 0x2392 | [0x89E]/[0x8A0] (boot default) | 0x0760E8 loader, 0x0760ED `mov [0x89E],ax` |
| FONTINTR.FF | `fontintr` | 0x2389 | [0x268A]/[0x268C] (boot) | 0x0760C2 push, 0x0760CB `mov [0x268A],ax` |
| FONTKING.FF | `FONTKING` | 0x232B | dialog ctx, on-demand | 0x0754F2 lea, 0x0754F6 load |
| FONT-NP.FF | `FONT-NP` | 0x1F0F | local, on-demand | 0x06B7AB lea, 0x06B7AF load |
| FONTSMAL.FF | *(no string)* | — | **never loaded (orphan)** | — |

Font loader = Type-A thunk **`LCALL 0x1A1F:0x0A86`** (`9a 86 0a 1f 1a`; record
0x1B, thunk-table @0x1D076), MADSPACK-decompresses a `.FF`, returns far ptr DX:AX.

**Two active-font globals (two text paths):**
- **[0x89E]/[0x8A0]** — the resident generic text printer `func_002B38`
  (= thunk 0x181F:0x13C `draw_text_clip`; `func_002BC8` = 0x181F:0x100
  `draw_text_at` centers + tail-calls it). It unconditionally reads [0x89E]
  (0x002B54 `push [0x89E]`). HUD, popups, reports, unit/tile-info all use this.
  "Set generic font" = write [0x89E]/[0x8A0].
- **[0x1F9E]/[0x1FA0]/[0x1FA2]** — the dialog/menu text context, set by
  `func_06EED4` (0x06EEDD `mov [0x1F9E],ax`). The page-0x17 dialog layout reads
  it (0x06F135).

**Per-context font selection (byte-cited):**

| context | font | citation |
|---|---|---|
| Title / opening menu | **FONTINTR** | OPENMENU build 0x075AE4 + BEGINMENU run 0x075C60; fontintr height read 0x070498 |
| Menu bar / dropdowns | **FONTINTR** (dialog ctx) | build_menubar func_072090 → page-0x17 dialog path 0x06F135 |
| Difficulty / nation pickers | **FONTINTR** | 0x070494 `les bx,[0x268A]; al=es:[bx]` (height) |
| In-game status bar / sidebar | **TBD** (flows through [0x89E]=fonttiny default, but no explicit HUD set-font located) | not byte-pinned — do NOT assert |
| King Audience | **FONTKING** | 0x0754F2 load → 0x075511 `mov [0x1F9E],ax`; metric overrides 0x075526.. |
| Woodcut / newspaper report | **FONT-NP** | 0x06B7AB load (neighbors WDCUT/WOODFRAM/NAMEPLAT) |
| F1-F10 adviser reports + generic dialog/popup body + tile/unit-info | **FONTTINY** ([0x89E] default) | report row primitive 0x181F:0x13C; tile-info 0x0692D7 `mov ax,[0x89E]` |

`@SMALLFONT` dialog directive binds to **fonttiny** ([0x89E]), NOT a "FONTSMAL"
(0x06F1F4 push handle 0x1FDB "SMALLFONT" → 0x06F207 `mov ax,[0x89E]`).

**Port reconciliation:** king=FONTKING ✓, news=FONT-NP ✓, intro=FONTINTR ✓ all
AGREE. tiny=FONTTINY status = PARTIAL (fonttiny is the engine default; the
status-bar binding itself is TBD). **small=FONTSMAL body text DISAGREES** — there
is no FONTSMAL in the binary; body text reads [0x89E] = FONTTINY. The port should
treat its FONTSMAL slot as FONTTINY.

> **Fabrication flag:** `viceroy_source/src/asset/asset_loader.c` and
> `viceroy_source/formats/FF.md` list a font roster FONTMED/FONTLARG/FONTBOLD/
> SYMBOLS — **none of these exist in VICEROY.EXE**. The real set is the 4 loaded
> above (+ FONTSMAL.FF orphan on disk). Needs correction.

**Spot-checks (all PASS):** 0x1F8AF "FONT-NP\0"; 0x1FCCB "FONTKING\0"; 0x1FD32
"fonttiny\0"; 0x0760E8 `9a 86 0a 1f 1a` (loader) + 0x0760ED `a3 9e 08`
(mov [0x89E]); 0x002B54 `ff 36 9e 08` (printer reads [0x89E]); 0x0754F2
`8d 1e 2b 23` (FONTKING); 0x06B7AB `8d 1e 0f 1f` (FONT-NP); 0x06F1F4 `68 db 1f` +
0x06F207 `a1 9e 08` (@SMALLFONT→fonttiny).

---

## Sprites (UI elements)

All indexed sprite blits go through **`LCALL 0x181f:0x254`** (thunk @file 0x01A844,
Type-B → overlay 0x0C36:0x000A), register-based: **AX = sprite index, DX = x,
BX = &ctx/clip-rect** (usually 0x2da8; 0x839e for popups); the **active sheet
handle is read by the callee**. Same thunk with `sub dx,dx` + a buffer in BX
*queries* sprite width/height instead of drawing. Text/number printing is the
companion `LCALL 0x181f:0x13c` (thunk @0x01A72C).

**Sheet handles (VICEROY DGROUP, loaded @file 0x0765CE+):** PHYS0 = [0x174],
**ICONS = [0x83e]**, **BUILDING = [0x842]**. Name strings: 0x1FD70 "phys0",
0x1FD76 "icons", 0x1FD7C "building". Attribution is mechanical: the handle
pushed / `LES`-loaded right before a 0x254 blit names the sheet.

| UI element | sheet | index | @asm (file) |
|---|---|---|---|
| Stockpile / market commodity icons | ICONS | **23..38** (0x17+i, 16-loop) | add 0x17 @0x028253; width-centre `les [0x83e]`+`es:[bx+si+0x152]` @0x028259 |
| Mid-band field-worker yield icons | ICONS | 23+offset | add 0x17 @0x026573 (gated `test al,0x40` expert) |
| Player nation flag | ICONS | **68 (0x44)** | `mov ax,0x44` @0x0704CC; redraw push 0x44 @0x0704F9 |
| Colony/Europe building "slot" (empty-lot base) | ICONS | **123 (0x7B)** | `mov ax,0x7B` @0x027E25; 6-slot loop `cmp 6` @0x027DF7 |
| Colony building (per type/level) | **BUILDING** | **type+1**, overrides 0x11/0x2F/0x30 (Stockade/special/Cathedral) | `[bp+6]+1` @0x026DE5, overrides @0x026E2D/34; `push [0x842]`+blit @0x026E39 |
| Colony empty-lot decoration | BUILDING | data byte `bldgRec[+0x260]` (values TBD) | `[bx+0x260]` @0x026FF9; `push [0x842]`+blit @0x027002 |
| Colonist-in-plaza row | ICONS | 124,125 (0x7C,0x7D) + computed | x0=0x8F @0x0270FA, max `cmp 0x60` @0x027170; widths `es:[bx+si+0x3e]` @0x02712D |
| Colony unit-on-tile marker | ICONS | **109 (0x6D)** | `mov ax,0x6D` @0x0265BF (foot-unit, matches ICONS 100-105/109) |
| Panel strip tile (colony/report) | ICONS | **63 (0x3F)** | push 0x3F @0x02849E (pitch 0x84); `mov ax,0x3F` @0x038FA4 pos (0x92,0xD2) |
| Report header sprite (2nd) | ICONS | 124 (0x7C) | `mov ax,0x7C` @0x039113 pos (0x92,0x6E) |
| Dialog/popup box frame + corners | — NOT indexed | WOODFRAM whole-sprite | frame painter `lcall 0x181f:0x510` @0x0263D6, consts (0x50,0x50,8,0xC8,0,0) + rect [0x839e]x2 |
| Dialog OK/Cancel buttons | — NOT sprites | FONTTINY text | OPTIONS directive list (no sprite index) |
| Menu-bar / dropdown decoration | — NOT indexed | rect-fill + FONTINTR text | panel-fill jump-table @0x02CAC3 |
| King-audience / native-advisor popups | KING/IND/MSS/MYR.SS **by NAME** | name built from channel byte (`[0x1f5c]=8`→"KING") | func_06BE92 @0x06BE9D push 0x1F72 ("KING") |
| Boycott "X" | **NOT a sprite** (ICONS 43 disproved) | — | boycott shown by recolouring the qty number (text colour 0xC/0x4 @0x028334); the 0x2B @0x065C11 is a palette op, not a blit |
| SoL panel Bell / Cross / Anvil | **TBD** | TBD | SoL-state readers don't call the indexed blit; ICONS 38 (0x26, `test byte,4` armed) is an unconfirmed candidate |

Carried-forward (re-confirmed where reachable): report title-bar 0xFD/0xFE;
hall-of-fame rating 0x24/0x25/0x21; title OPENBORD pairs (6,7)(8,9)(0xE,0xF).

**Key resolutions:** building sprites = BUILDING.SS at `type+1`; the dialog frame
+ buttons are asset/text-driven (no per-element index); King/advisor sprites are
name-built, not numeric; boycott-X is a recolour not a sprite. **TBD:** the
empty-lot per-type table values (+0x260) and the SoL Bell/Cross/Anvil indices.

**Spot-checks (all PASS):** 0x1FD76 "icons"/0x1FD7C "building"; 0x027E25
`b8 7b 00 8d 1e a8 2d` (slot 0x7B); 0x026E39 `ff 36 44 08 ff 36 42 08` (BUILDING
blit); 0x0704CC `b8 44 00` (flag 68); 0x038FA4 `b8 3f 00` (ICONS 63); 0x0263D6
`9a 10 05 1f 18` (frame painter); 0x065C11 `6a 44 6a 2b 9a 0e 07 1f 18` (palette
op — boycott-X disproof).
