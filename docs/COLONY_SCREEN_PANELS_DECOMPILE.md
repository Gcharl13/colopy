# COLONY SCREEN — remaining panels, EXHAUSTIVE code-anchored decompile

> Source of truth = **VICEROY.EXE disassembly**
> (`data_extracted/disassembly/VICEROY_annotated.asm`, capstone 16-bit), with static
> bytes read from `raw/COLONIZE/VICEROY.EXE` at **DGROUP file base `0x1D9A0`**
> (BSS starts at `DS:0x2CC6`; offsets `< 0x2CC6` are static, `≥ 0x2CC6` are runtime/BSS).
> Thunks resolved with `tools/follow_thunk.py`. Cross-ref:
> `docs/COLONY_SCREEN_VICEROY_DECODE.md`. Built 2026-06-24.
>
> This file is the per-function decompile the §-level doc points at: for each
> sub-renderer it gives (1) the RAW asm, (2) a per-block English translation, and
> (3) a table of EVERY drawn element with exact x / y / w·h / sprite-or-text /
> color index / @offset — **including every border/divider line and panel-clear
> rect and its color index** (the previously "missing" black region borders).

## 0. Shared primitives (thunk → file offset, byte-resolved)

`tools/follow_thunk.py 0x181f <off>` / `0x191f <off>`:

| thunk | file | role (calling convention) |
|-------|------|---------------------------|
| `cs:0x2CAC3` → `0x191f:0x7EC` | **`0x02633E`** | **panel CLEAR/RESTORE rect** — pushes the **`[0x83A2:0x83A4]` bottom-band surface** + **`[0x2DA8..0x2DAE]` graphics context**, forwards to `0x181f:0x444`(`0xDCF6`). It does **NOT** paint a solid colour — it **re-blits the COLONY.PIK panel art** for that rect (the panel frames/borders are *baked into COLONY.PIK*, §5 of the decode). **Push order at every call site = `push h; push w; push y; push x; push cs; call 0x2cac3`** → inside func_02633E `[bp+6]=x, [bp+8]=y, [bp+0xa]=w, [bp+0xc]=h`. (Verified against the known panels: plaza `func_0270D0` pushes `0x30,0x78,0x82,0` = h48,w120,y130,x0 = `(0,130,120,48)` ✓.) |
| `0x181f:0xCE` → `0xE0A2` | line / filled-rect | **`draw_rect(x0,y0,x1,y1,color, ctx…)`** — THE line/border primitive. Args: `push ctx(4× [0x2da8..0x2dae]); push x1; push color; bx=x0; ax=y0; dx=y1`. A 1-px line is a rect with x0==x1 or y0==y1. **This is the call to look at for every border/divider.** |
| `0x181f:0x254` → `0xE76A` | `blit_sprite(sheet,frame,x,y)` | sheet far-ptr `[0x83E:0x840]`, `bx=&sheet_hdr`, `ax=frame`, `dx=y`, `push x`. |
| `0x181f:0x2BC` → `0x386A` | `blit_sprite_clipped(sheet,frame,x,y,w,h)` (worker colonist) |
| `0x181f:0x2F8` → `0xE964` | `blit_small_sprite` (commodity icon variant) |
| `0x181f:0xE2` → `0xDB3A` | **clipped scroll-blit** (the screen-edge "dirty-rect flush", `[bp+6]≠0` tail of each panel) — NOT a line. |
| `0x181f:0x22` → `func_002462` `0x2462` | **fetch heap string #N** from text heap `[0x2D42:0x2D44]`; returns far ptr in `dx:ax`. |
| `0x181f:0x13C` → `0x2B38` | **draw formatted/number string** `draw_text(color,y,x, far_ptr)` (printf-into-pixels). |
| `0x181f:0x100` → `func_002BC8` `0x2BC8` | **draw CENTRED text** in a box `(color,y,x,w, far_ptr)`. |
| `0x181f:0x16E` → `func_002992` | strcat a **table string** (index → `lcall 0:0x62` → far ptr, `%s`). |
| `0x181f:0x182` → `func_0029DE` | strcat a **decimal number** (`itoa`). |
| `0x181f:0x1A0` → `func_002A06` | strcat **zero-padded** number. |
| `0x181f:0x178`/`0x1BE`/`0x1B4`/`0x1DC` → `0x28B0`/`0x28F2`/`0x28E2`/`0x2902` | strlen / append-separator helpers. |
| `0x181f:0xB32` → `0xB23E` | **unit-record index at colony slot** (returns unit idx; `*0x1C` strides `UnitRecord` @`0x3146`). |
| `0x181f:0x9FC` → `0x863E` | "is good *N* the selected good?" (returns bool). |
| `0x181f:0xCFE` → `0x85B2` | "is good *N* boycotted?" (returns bool). |
| `0x181f:0xD3A` → `0x8D00` | **warehouse capacity** for the current colony (returns cap in `ax`). |
| `0x181f:0xB0` → **`func_00275C`** `0x275C` | general **rich-text painter** (title banner paint). |
| `0x181f:0xB1E` → `func_008862` | nation prefix/colour merge into a string buffer. |
| `0x181f:0x722` → `func_005E90` | tile-attribute byte at (map_x,map_y). |
| `0xD1D:0x8FA` | C-runtime `itoa`/`ltoa`. `0xD1D:0x7A4` `strcat`. `0xD1D:0x117E` `sprintf`. `0xD1D:0x11B4` `strcat(far)`. `0xD1D:0x7E4` `strcpy`. |

**Colour indices seen in this screen (VGA palette):** `0x0F` white, `0x0C` red
("will spoil" / over-cap), `0x0E` yellow (selection box), `0x0A`/`0x0D` greens, `0`
black/transparent. (No literal `push 0` "black line" exists in these panels — the
panel borders are PIK-baked; see the per-function notes.)

---

## 1. `func_027DB2` — SURROUNDING-TILE MINIMAP (bottom band, centre)
Panel rect **(x=121, y=130, w=84, h=48)** — byte-confirmed by the clear push order
`h=0x30(48), w=0x54(84), y=0x82(130), x=0x79(121)`. Composer step 10
(`0x2C9FB`→`0x191f:0x60C`).

### 1a. RAW asm
```
027DB2  enter   0x74, 0
027DB6  push    si
027DB7  push    0x30                     ; h = 48
027DB9  push    0x54                     ; w = 84
027DBB  push    0x82                     ; y = 130
027DBE  push    0x79                     ; x = 121
027DC0  push    cs
027DC1  call    0x2cac3                  ; func_02633E  CLEAR/RESTORE (x121,y130,w84,h48)
027DC4  add     sp, 8
027DC7  cmp     word ptr [0x33c], 0      ; [0x33C] = surrounding-tile count
027DCC  jne     0x27e36                  ; count!=0 -> real minimap loop
; ---- CENTRED-CAPTION branch ([0x33C]==0: no surrounding tiles known) ----
027DCE  push    0x39                     ; color = 57   (func_002BC8 [bp+0x10])
027DD0  push    0x84                     ; y     = 132  ([bp+0xe])
027DD3  push    0x54                     ; width = 84   ([bp+0xc], centred)
027DD5  push    0x79                     ; x     = 121  ([bp+0xa])
027DD7  push    word ptr [0x2dd0]        ; heap string index (BSS -> runtime)
027DDB  lcall   0x181f, 0x22             ; fetch heap string #[0x2DD0]
027DE0  add     sp, 2
027DE3  push    dx                       ; far ptr seg ([bp+8])
027DE4  push    ax                       ; far ptr off ([bp+6])
027DE5  lcall   0x181f, 0x100            ; func_002BC8 DRAW CENTRED TEXT (x121,w84,y132,col57)
027DEA  add     sp, 0xc
027DED  mov     word ptr [bp - 0x62], 0  ; slot = 0
027DF2  jmp     0x27df7
027DF4  inc     word ptr [bp - 0x62]
027DF7  cmp     word ptr [bp - 0x62], 6  ; 6-SLOT loop
027DFB  jl      0x27e00
027DFD  jmp     0x2812e                  ; done
027E00  lea     ax, [bp - 0x68]          ; &out_w
027E03  push    ax
027E04  lea     ax, [bp - 0x66]          ; &out_h
027E07  push    ax
027E08  lea     ax, [bp - 0x5c]          ; &out_x
027E0B  push    ax
027E0C  lea     cx, [bp - 0x5a]          ; &out_y
027E0F  push    cx
027E10  push    word ptr [bp - 0x62]     ; slot
027E13  push    cs
027E14  call    0x2c9d8                  ; func_027D84  (geometry helper)
027E17  add     sp, 0xa
027E1A  push    word ptr [0x840]         ; sheet seg
027E1E  push    word ptr [0x83e]         ; sheet off
027E22  push    word ptr [bp - 0x5c]     ; x  (=0x7F+slot*12)
027E25  mov     ax, 0x7b                 ; frame = 0x7B (123)
027E28  lea     bx, [0x2da8]             ; sheet hdr [0x2DA8]
027E2C  mov     dx, word ptr [bp - 0x5a] ; y  (=0xA5=165)
027E2F  lcall   0x181f, 0x254            ; blit_sprite
027E34  jmp     0x27df4
; ---- [0x33C]!=0 : real surrounding-tile minimap (worked-tile preview) ----
027E36  mov     byte ptr [bp - 0x50], 0  ; build a caption string buf[bp-0x50]
027E3A  push    word ptr [0x2de8]        ; heap string idx (BSS)
027E3E  lea     ax, [bp - 0x50]
027E41  push    ax
027E42  lcall   0x181f, 0x16e            ; strcat table string
...
027E5A  lcall   0x181f, 0xb32            ; unit-at-slot lookup ([0x33E])
...
027E95  push    0x39                     ; color = 57
027E97  push    0x84                     ; y = 132
027E9A  push    0x54                     ; width = 84
027E9C  push    0x79                     ; x = 121
027E9E  lea     ax, [bp - 0x50]
027EA3  lcall   0x181f, 0x100            ; DRAW CENTRED caption (x121,w84,y132,col57)
... (then the per-tile preview loop @0x27ED5..0x28128 draws worker
     sprites via 0x181f:0x2f8, divider lines via 0x181f:0xCE, and
     production numbers via 0x181f:0xb3c — detailed in 1d) ...
02812E  cmp     word ptr [bp + 6], 0     ; tail flush
028132  je      0x28148
028134  push    0x82                     ; w=130
028137  push    0x54                     ; h=84
028139  push    0x30                     ; x=48?  -> dirty-rect flush args
02813B  mov     ax, 0x79
02813E  mov     dx, 0x82
028141  mov     bx, ax
028143  lcall   0x181f, 0xe2             ; clipped scroll-blit (flush), NOT a line
028148  pop     si
028149  leave
02814A  retf
```

### 1b. `func_027D84` — minimap slot geometry (RAW)
```
027D84  push  bp / mov bp,sp
027D87  mov   ax,[bp+6]          ; slot
027D8A  mov   cx,ax
027D8C  shl   ax,1               ; *2
027D8E  add   ax,cx              ; *3
027D90  shl   ax,2               ; *12   (slot*12)
027D93  add   ax,0x7f            ; + 127
027D96  mov   bx,[bp+8]  / mov [bx],ax     ; out_x = 0x7F + slot*12  (127,139,151,163,175,187)
027D9B  mov   bx,[bp+0xa]/ mov [bx],0xa5   ; out_y = 165
027DA2  mov   bx,[bp+0xc]/ mov [bx],0xa    ; out_w = 10
027DA9  mov   bx,[bp+0xe]/ mov [bx],0x16   ; out_h = 22
027DB0  leave / retf
```

### 1c. Per-block translation
- **clear:** `func_02633E` re-blits COLONY.PIK over the minimap panel (no solid colour).
- **`[0x33C]==0`** (no known surrounding tiles): draw ONE centred caption — heap
  string `#[0x2DD0]` — via `func_002BC8` with **x=121 (0x79), width=84 (0x54),
  y=132 (0x84), colour=57 (0x39)** (arg slots verified from the func_002BC8 body:
  `[bp+0xa]=x, [bp+0xc]=width, [bp+0xe]=y, [bp+0x10]=color`). Then the 6-slot icon
  strip is drawn (loop @`0x27DED`).
- **6-slot strip:** for slot 0..5, geometry from `func_027D84` → `x=127+slot·12`,
  `y=165`, `w=10`, `h=22`; blit **frame `0x7B`(123)** from sheet `[0x2DA8]`. (Same
  base+slot·12 / y=165 shape as the Europe dock-ship row.)
- **`[0x33C]!=0`** branch (`@0x27E36`): assembles a caption from heap string
  `#[0x2DE8]` + the slot-`[0x33E]` unit's name and draws it centred; then a worked-tile
  preview (workers + commodity icons + production numbers + divider lines) — that
  inner loop is the same machinery as the field-production panel `func_0264A8`.
- **tail (`[bp+6]≠0`):** dirty-rect flush via `0x181f:0xE2` — not a drawn element.

> `[0x2DD0]`/`[0x2DE8]` are **BSS (≥0x2CC6)** → their indices are runtime-loaded; the
> file bytes (0x0E38 / 0x0D35) are stale and meaningless. `[0x33C]`/`[0x33E]`/`[0x340]`
> are game-state words (file = 0 initial).

### 1d. Drawn elements
| element | x | y | w·h | frame / text | color | @offset |
|---|---|---|---|---|---|---|
| panel clear (PIK restore) | 121 (0x79) | 130 (0x82) | 84×48 (0x54×0x30) | COLONY.PIK art | (PIK) | 0x027DC1 |
| centred caption ([0x33C]==0) | 121 (0x79) | 132 (0x84) | w=84 (0x54) | heap str `#[0x2DD0]` | **57 (0x39)** | 0x027DE5 |
| minimap icon ×6 | 127+slot·12 | 165 (0xA5) | 10×22 | sprite **0x7B (123)** | — | 0x027E2F |
| caption ([0x33C]!=0) | 121 (0x79) | 132 (0x84) | w=84 (0x54) | str `#[0x2DE8]`+unit name | 57 (0x39) | 0x027EA3 |
| worker sprites (preview) | runtime | runtime | clipped | unit sprite via `[0x5232]` | — | 0x027F10 |
| divider line(s) (preview) | runtime | runtime | line | — | `[bp-0x72]` (0x0A or 0x0F) | 0x027F9D |
| production number(s) | runtime | runtime | text | itoa qty | — | 0x028058 |

All values byte-confirmed from the clear push order (`h,w,y,x`) and the func_002BC8
arg slots (`[bp+0xa]=x, [bp+0xc]=width, [bp+0xe]=y, [bp+0x10]=color`). The caption
colour **57** is the gameplay-palette text colour passed for both branches.

---

## 2. `func_02814C` — SoL / cargo / MESSAGE panel
Panel rect **(x=211 (0xD3), y=130 (0x82), w=91 (0x5B), h=48 (0x30))**.
Composer step 11 (`0x2C983`→`0x191f:0x4EC`).

### 2a. RAW asm (complete)
```
02814C  push  bp / mov bp,sp
02814F  push  0x30                  ; h = 48
028151  push  0x5b                  ; w = 91
028153  push  0x82                  ; y = 130
028156  push  0xd3                  ; x = 211
028159  push  cs
02815A  call  0x2cac3              ; func_02633E  CLEAR/RESTORE (x211,y130,w91,h48)
02815D  mov   sp, bp
02815F  mov   al, byte ptr [0x337]  ; MODE = [0x337]  (panel content selector)
028162  sub   ah, ah
028164  jmp   0x28178
028166  push  cs / call 0x2c9b0     ; mode 0 -> func_0275CE  (SoL %% / goods strip)
028169  jmp   0x28182
02816C  push  cs / call 0x2ca50     ; mode 1 -> func_027746  (ship-in-port)
028170  jmp   0x28182
028172  push  cs / call 0x2caa0     ; mode 2 -> func_027BB6  (active message)
028176  jmp   0x28182
028178  or    ax, ax / je 0x28166   ; ax==0 -> mode 0
02817C  dec   ax     / je 0x2816c   ; ax==1 -> mode 1
02817F  dec   ax     / je 0x28172   ; ax==2 -> mode 2
028182  cmp   word ptr [bp + 6], 0  ; tail flush
028186  je    0x2819c
028188  push  0x82 / push 0x5b / push 0x30
02818F  mov   ax,0xd3 / mov dx,0x82 / mov bx,ax
028197  lcall 0x181f, 0xe2         ; clipped scroll-blit (flush)
0281A2... (func_02819E follows)
```

### 2b. Translation
- **clear:** PIK restore of `(211,130, 91×48)`.
- **3-way switch on `[0x337]`** (the panel-mode byte): `0`→`func_0275CE` (the
  Sons-of-Liberty % bar + production/goods strip), `1`→`func_027746` (ship-in-port
  cargo holds), `2`→`func_027BB6` (current message / event text). Default falls
  through drawing nothing extra.
- **"No Ships In Port"** path lives **inside `func_027746`** (mode 1): when the
  colony has no docked ship it draws that caption instead of cargo holds (the string
  is fetched there, not in this dispatcher).
- **tail flush** via `0x181f:0xE2`.

### 2c. Drawn elements (this function)
| element | x | y | w·h | content | color | @offset |
|---|---|---|---|---|---|---|
| panel clear (PIK restore) | 211 (0xD3) | 130 (0x82) | 91×48 (0x5B×0x30) | COLONY.PIK art | (PIK) | 0x02815A |
| mode-0 content | — | — | — | → func_0275CE | — | 0x028167 |
| mode-1 content | — | — | — | → func_027746 ("No Ships In Port") | — | 0x02816D |
| mode-2 content | — | — | — | → func_027BB6 | — | 0x028173 |
| dirty flush | — | — | — | scroll-blit | — | 0x028197 |

---

## 3. `func_02853C` — FLAG panel
Panel rect **(x=303 (0x12F), y=132 (0x84), w=17 (0x11), h=45 (0x2D))**.
Composer step 9 (`0x2C9E7`→`0x191f:0x5DC`).

### 3a. RAW asm (complete)
```
02853C  enter 2, 0
028540  push  0x2d                  ; h = 45
028542  push  0x11                  ; w = 17
028544  push  0x84                  ; y = 132
028547  push  0x12f                 ; x = 303
02854A  push  cs / call 0x2cac3     ; func_02633E  CLEAR/RESTORE (PIK restore)
02854E  add   sp, 8
028551  cmp   word ptr [0xb98], 0   ; [0xB98] = "suppress overlay" flag
028556  jne   0x28575               ; if set, skip the flag sprite
028558  push  0x44                  ; frame BASE 0x44 (68) = flag sprite
02855A  push  3                     ; (panel-local x offset = +3)
02855C  cmp   word ptr [bp + 8], 0  ; arg: which nation field?
028560  je    0x28568
028562  mov   al, byte ptr [0x339]  ; nation byte A  ([0x339])
028565  jmp   0x2856b
028568  mov   al, byte ptr [0x337]  ; nation byte B  ([0x337])
02856B  sub   ah, ah
02856D  push  ax                    ; frame = 0x44 + nation byte
02856E  push  cs / call 0x2c979     ; -> func_028466 (flag-sprite + box helper)
028572  add   sp, 6
028575  cmp   word ptr [bp + 6], 0  ; tail flush
028579  je    0x2858f
02857B  push  0x84 / push 0x11 / push 0x2d
028582  mov   ax,0x12f / mov dx,0x84 / mov bx,ax
02858A  lcall 0x181f, 0xe2          ; clipped scroll-blit (flush)
0285... leave / retf
```

### 3b. `func_028466` — flag sprite + bracket (the helper, RAW key part)
```
028466  enter 0xc, 0
02846A  ... call 0x2cadc  (0x191f:0x828, sprite-dims lookup for frame)
028483  mov   [bp-8],0                ; i = 0
02848A  push [0x2dae..0x2da8]         ; gfx context
02849A  add   ax,[bp-0xa]            ; x = base_x + frame_w
02849D  push  ax
02849E  push  0x3f                    ; line colour/param 0x3F (63)
0284A0  mov   ax,[bp-4] / bx=[bp-2]+ax / ax++ / dx=[bp-6]+1
0284AD  lcall 0x181f, 0xce           ; DRAW LINE/RECT  colour 0x3F  (left bracket)
0284B2  push [0x840]/[0x83e]/[bp-6]  ; sheet + frame
0284C7  mov dx,[bp-4] / lcall 0x181f, 0x254   ; blit_sprite (flag frame i)
0284CF  inc [bp-8] ...               ; loop frames
...
0284F4  push [0x2dae..]              ; (when [bp+6]==i) second bracket
028509  push  0x3f                   ; line colour 0x3F
028518  lcall 0x181f, 0xce           ; DRAW LINE/RECT colour 0x3F (right bracket)
028537  ... blit_sprite ... / leave / retf
```

### 3c. Translation
- **clear:** PIK restore of `(303,132, 17×45)`.
- gated by `[0xB98]` (overlay-suppress): if 0, draw the flag.
- **flag sprite** = base frame **`0x44` (68)** + the **nation byte** (`[0x339]` if
  `[bp+8]≠0`, else `[0x337]`) from sheet `[0x2DA8]`, at panel-local **x+3**.
- `func_028466` additionally draws **two vertical bracket lines colour `0x3F` (63)**
  flanking the flag (a multi-frame flag strip with a selection bracket — used when the
  panel shows several nation flags; for the single-colony flag it draws frame 0).
- **tail flush** `0x181f:0xE2`.

### 3d. Drawn elements
| element | x | y | w·h | frame / line | color | @offset |
|---|---|---|---|---|---|---|
| panel clear (PIK restore) | 303 (0x12F) | 132 (0x84) | 17×45 (0x11×0x2D) | COLONY.PIK art | (PIK) | 0x02854B |
| flag sprite | panel+3 | (panel y) | sprite | **frame 0x44 + nation byte** | — | 0x028466→0x2854A/0x284CA |
| left bracket line | base_x+frame_w | runtime | line | — | **0x3F (63)** | 0x0284AD |
| right bracket line | base_x+frame_w-1 | runtime | line | — | **0x3F (63)** | 0x028518 |
| dirty flush | — | — | — | scroll-blit | — | 0x02858A |

---

## 4. `func_0281D6` — STOCKPILE warehouse bar
Panel rect **(x=0, y=179 (0xB3), w=320 (0x140), h=21 (0x15))**.
Composer step 8 (`0x2CA19`→`0x191f:0x654`).

### 4a. RAW asm (complete)
```
0281D6  enter 0x80, 0
0281DA  push  si
0281DB  push  0x15                 ; h = 21
0281DD  push  0x140                ; w = 320
0281E0  push  0xb3                 ; y = 179
0281E3  push  0                    ; x = 0
0281E5  push  cs / call 0x2cac3    ; func_02633E  CLEAR/RESTORE (full-width PIK restore)
0281E9  add   sp, 8
0281EC  mov   word ptr [bp-0x6e], 1    ; cell_x = 1   (running icon x)
0281F1  mov   word ptr [bp-0x72], 0xb5 ; icon_y = 181
0281F6  mov   word ptr [bp-0x7e], 0    ; i = 0   (good index)
0281FB  jmp   0x28231
; ---- back-edge of the per-cell loop (number paint of PREVIOUS cell) ----
0281FE  push  0xa / lea ax,[bp-0x56] / push ax / push [bp-0x76]
028207  lcall 0xd1d, 0x8fa         ; itoa(quantity, buf, 10)
02820F  push  [bp-6]               ; colour   (0x0F white / 0x0C red / 0x0A)
028212  push  [bp-0x7c]            ; y (=0xC2=194 quantity-text y)
028215  mov   ax,[bp-0x78] / inc ax ; x+1
028219  push  ax
02821A  lea   ax,[bp-0x56] / push ss / push ax
02821F  lcall 0x181f, 0x13c        ; DRAW TEXT (quantity number)
028224  add   sp, 0xa
028227  mov   [bp-0x78],ax
02822A  add   word ptr [bp-0x6e], 0x13  ; cell_x += 19   (PITCH 0x13)
02822E  inc   word ptr [bp-0x7e]        ; i++
028231  cmp   word ptr [bp-0x7e], 0x10  ; 16 cells
028235  jl    0x2823a
028237  jmp   0x28394                   ; -> second pass (boycott / selection)
; ---- icon blit ----
02823A  push  [0x840]/[0x83e]          ; sheet
028242  push  [bp-0x72]                ; icon_y = 181
028245  mov   ax,[bp-0x7e]            ; i
028248  ... si = i*12
028253  add   ax, 0x17                ; FRAME = good + 0x17  (ICONS 23..38)
028256  mov   dx,[bp-0x6e]            ; cell_x
028259  les   bx,[0x83e]
02825D  mov   cx, es:[bx+si+0x152]    ; icon_w from sheet header
028262  sar   cx, 1                   ; icon_w/2
028264  sub   dx, cx                  ; CENTER: x = cell_x - icon_w/2
028266  add   dx, 9                   ;             + 9
028269  mov   [bp-0x80], dx
02826C  lea   bx,[0x2da8]
028270  lcall 0x181f, 0x254          ; BLIT ICON (frame good+0x17, centred)
; ---- quantity formatting (qty/100 etc.) ----
028275  mov   byte ptr [bp-0x56],0
028279  ... itoa( colony[+0x9A + i*2] , buf )         ; the stockpile quantity word
0282A4  mov   word ptr [bp-0x7c], 0xc2     ; quantity text y = 194
0282A9  push [0x8a0]/[0x89e] / lcall 0x181f,0x204  ; measure string pixel-width
0282BD  inc   ax                      ; width+1
0282C1  sar   ax,1 / sub ax,[bp-0x6e] / neg ax / add ax,9  ; centre number under cell
0282CB  mov   [bp-0x78], ax           ; number_x
0282CE  mov   word ptr [bp-0x6c], 0xf ; (default colour 0x0F white)
0282D3  ... idiv 0x64 -> [bp-0x70]=qty/100, [bp-0x76]=qty%100
0282EE  mov   word ptr [bp-2], 0x94   ; (=148) selected-good box param
0282F3  mov   word ptr [bp-6], 0x3d   ; (=61) default text colour seed
; ---- selected-good highlight test ----
0282F8  push  0x12 / lcall 0x181f,0x9fc   ; is good selected?  (mode 0x12)
028302  or ax,ax / je 0x2831a
028306  push  [bp-0x7e] / lcall 0x181f,0xcfe ; (2nd test)
028311  or ax,ax / je 0x2831a
028315  mov   word ptr [bp-6], 0xa    ; selected -> colour 0x0A (green)
; ---- OVER-CAPACITY (will-spoil) test ----
02831A  cmp   word ptr [bp-0x7e], 0 / je 0x2833e
028320  lcall 0x181f, 0xd3a           ; warehouse CAP -> ax
028325  si=i*2 / bx=[0x8542]
02832E  cmp   [bx+si+0x9a], ax        ; stockpile[i] > cap ?
028332  jle   0x2833e
028334  mov   word ptr [bp-2], 0xc    ; over-cap box -> colour 0x0C (red)
028339  mov   word ptr [bp-6], 4      ; over-cap text -> colour 4
0283... (loops back via 0x281FE to paint the number with the chosen colour)
; ===================== SECOND PASS @0x28394 (boycott red-X) =====================
028394  mov   word ptr [bp-0x7e], 0
028399  mov   al, byte ptr [0x33a]    ; selected good index [0x33A]
02839E  cmp   ax,[bp-0x7e] / jne ...
0283A3  push  0xa / push ax / push cs / call 0x2c9d3  ; func_02819E  highlight box (colour param 0xA)
0283AD  cmp [0x7ee],0 / cmp [0x8d54],5 / ...          ; mode-gated extra box
0283BB  push  0xe / push [bp-0x7e] / call 0x2c9d3     ; func_02819E box colour 0xE (yellow)
0283C7  cmp [0x32e],4 / cmp [0x334],0 / cmp [0xb9d],0 ; another mode gate
0283DC  push  0xe / push [bp-0x7e] / call 0x2c9d3     ; func_02819E box colour 0xE
0283E8  inc [bp-0x7e] / cmp 0x10 / jl 0x28399
; ===================== RIGHT-END CAPTION @0x283F1 =====================
0283F1  push  0xf                     ; colour 0x0F (white)
0283F3  push  0xb3                    ; y = 179
0283F6  push  0x132                   ; x = 306
0283F9  push  word ptr [0x2f5e]       ; heap string index [0x2F5E]  (BSS/runtime)
0283FD  lcall 0x181f, 0x22            ; fetch heap string #[0x2F5E]
028402  add   sp, 2
028405  push  dx / push ax
028407  lcall 0x181f, 0x13c           ; DRAW TEXT (the caption — NOT gold)
02840C  add   sp, 0xa
; ---- tail flush ----
02840F  cmp word ptr [bp+6], 0 / je 0x28429
028415  push 0xb3 / push 0x140 / push 0x15
02841D  sub ax,ax / mov dx,0xb3 / sub bx,bx
028424  lcall 0x181f, 0xe2            ; clipped scroll-blit (flush)
028429  pop si / leave / retf
```

### 4b. `func_02819E` — the per-cell highlight/boycott BOX (RAW)
```
02819E  enter 4, 0
0281A2  imul  ax,[bp+6],0x13     ; x = cell_index * 19  (PITCH 0x13)
0281A6  inc   ax                 ; +1
0281A7  cmp   word ptr [0xb98],0 ; overlay-suppress gate
0281AC  jne   0x281d3
0281AE  push  [0x2dae..0x2da8]   ; gfx context
0281BE  push  0xc7               ; x1 = 199  (box right edge)  <-- see note
0281C1  mov   cl,[bp+8] / push cx ; colour (the 0xA or 0xE passed in)
0281C5  mov   bx,ax / add bx,0x12 ; x+18
0281CA  dec   ax                  ; x-1
0281CB  mov   dx,0xb3             ; y = 179
0281CE  lcall 0x181f, 0xce        ; DRAW LINE/RECT  (the selection / boycott box)
0281D3  leave / retf
```

### 4c. Translation
- **clear:** full-width PIK restore of `(0,179, 320×21)`.
- **first pass — 16 cells, pitch 19 (`0x13`):** for good `i=0..15`:
  - **icon** = frame **`good + 0x17`** (ICONS 23..38; Food=23…Muskets=38) from sheet
    `[0x2DA8]`, at **icon_y = 181 (`0xB5`)**, **centred**: `icon_x = cell_x −
    icon_w/2 + 9` where `icon_w = sheet_hdr[0x152 + i*12]`.
    *(Bundle-frame caveat per the §-doc: in the committed bundle Food is frame 22, i.e.
    base `good+0x16`; the EXE literal `+0x17` indexes the EXE's own sheet enumeration.)*
  - **quantity number** = `colony[+0x9A + i*2]` (the stockpile word), itoa'd, drawn at
    **y = 194 (`0xC2`)**, x = centred under the cell; **colour selection:**
    default `0x0F` white seed `0x3D`; if the good is **selected** → `0x0A` green; if
    **stockpile[i] > warehouse cap** (`0x181f:0xD3A`) → box `0x0C` **red** + text
    colour `4` ("will spoil").
- **second pass (`@0x28394`) — selection/boycott boxes:** for each cell, if it is the
  selected good `[0x33A]` draw a highlight box (colour `0xA`); mode-gated extra boxes
  (colour `0xE` yellow) via `func_02819E`. The boycott **red-X** is part of this box
  family (drawn when the good is boycotted; box drawn by `func_02819E` `0x181f:0xCE`).
- **right-end caption (`@0x283F1`):** heap string `#[0x2F5E]` drawn at **x=306
  (`0x132`), y=179 (`0xB3`), colour `0x0F` white**. **This is a label caption, NOT the
  player gold** (`0x2F5E` is a string index, never written as a treasury value; gold is
  in the top menu header, §6). `[0x2F5E]` is BSS → its value is runtime.
- **tail flush** `0x181f:0xE2`.

### 4d. Drawn elements
| element | x | y | w·h | frame / text | color | @offset |
|---|---|---|---|---|---|---|
| panel clear (PIK restore) | 0 | 179 (0xB3) | 320×21 (0x140×0x15) | COLONY.PIK art | (PIK) | 0x0281E6 |
| good icon ×16 | cell_x−w/2+9, cell_x=1+i·19 | 181 (0xB5) | sprite | **frame good+0x17 (ICONS 23..38)** | — | 0x028270 |
| quantity number ×16 | centred under cell | 194 (0xC2) | text | itoa(stockpile word) | **0x0F / 0x0A / 4** | 0x028368 / 0x28220 |
| over-cap box | i·19±, dec/+18 | 179 (0xB3) | line/box | — | **0x0C (red)** | 0x0281CE (via 0x2833E set) |
| selected-good box | i·19+1 .. +18 | 179 | box | — | **0x0A (10)** | 0x0283A7→0x0281CE |
| boycott / mode box | i·19+1 .. +18 | 179 | box | — | **0x0E (yellow)** | 0x0283C1 / 0x0283E2 →0x0281CE |
| right-end caption | 306 (0x132) | 179 (0xB3) | text | heap str `#[0x2F5E]` (NOT gold) | **0x0F (white)** | 0x028407 |
| dirty flush | 0 | 179 | scroll-blit | — | — | 0x028424 |

> The selection/boycott **box right edge** in `func_02819E` is the literal `0xC7`
> (199) pushed as the line x1 — combined with `x=i·19` this draws the per-cell
> rectangle outline. The colour is the **passed-in argument** (`0x0A`, `0x0C`, or
> `0x0E`), so every box border colour is byte-pinned above.

---

## 5. `func_0268CE` — TITLE banner (composer step 5)
Composer step 5 (`0x2CAE6`→`0x191f:0x840`). One centred line near top (`y≈5`, runtime).
Full block-by-block string assembly is in `COLONY_SCREEN_VICEROY_DECODE.md` §9b; the RAW
asm is reproduced here with the paint call highlighted.

### 5a. Gating + the final paint (RAW excerpt)
```
0268CE  enter 0x54, 0
0268D3  bx=[0x8542] ; current colony
0268D7  cmp  byte [bx+0x1a], 4        ; owner power < 4 ?
0268DB  jae  0x268ee
0268DD  ... cmp byte[bx*0x34+0x543f],0 ; OR AI-personality controller==0
0268E9  jne  0x268ee
0268EB  jmp  0x269f8                  ; else -> spectator/AI variant
0268EE  cmp  word [0xb98],0 / jne 0x269f8   ; overlay-suppress
0268F8  cmp  byte [0x828],0 / jne 0x269f8   ; another gate
; --- player-owned string assembly into [bp-0x50] (8 appends; see §9b) ---
026915  lcall 0x181f,0x1a0   ; (1) zero-pad num  byte[colony+0x1b]
026942  lcall 0x181f,0x182   ; (2) append number byte[colony+0x8c..0x8f]  (x4)
02697A  lcall 0x181f,0x16e   ; (2') append table str  word[byte[colony+0x8d]*2-0x6840]
02698C  lcall 0x181f,0x16e   ; (3) append table str  word[0x2e38]
0269AD  lcall 0x181f,0x722   ; (4) tile attr byte (map_x,map_y) -> appended as number
0269ED  lcall 0x181f,0x182   ; (5) append number  byte[(nation<<4)+si-0x6790]
; --- spectator/AI variant @0x269f8 builds a shorter string then merges at 0x26a61 ---
0269f8  ... strcpy(colony+2) ...
026A22  bx=[0x538c] ; SEASON counter
026A28  push word[bx*2-0x6800]       ; (6) SEASON string  (@SEASONS = Spring/Autumn)
026A30  lcall 0x181f,0x16e           ;     append table str
026A44  push word [0x538a]           ; (7) YEAR   (g_year)
026A4D  lcall 0x181f,0x182           ;     append number
026A61  push word [0x93a0] / lcall 0x181f,0x22  ; (8) heap str #[0x93A0] -> strcat
; --- nation prefix merge + PAINT ---
026A96  lcall 0x181f, 0xb1e          ; func_008862  merge nation prefix/colour
026AA3  push word [bp+6]             ; mode = 0  (composer pushes 0 @0x0285B2)
026AA6  lcall 0x181f, 0xb0           ; func_00275C  RICH-TEXT PAINT (centred banner)
026AAE  pop si / leave / retf
```

### 5b. Translation
- **Three gates** (`@0x268D7/EE/F8`): player-owned + not overlay-suppressed; else the
  shorter spectator/AI variant at `0x269F8`.
- **String** (left→right into `[bp-0x50]`): colony numeric prefix → 4 per-colony bytes
  → a per-colony table string → title string `[0x2E38]` → tile-attribute number →
  nation×index byte → **SEASON** (`word[[0x538C]*2 − 0x6800]`, `@SEASONS`) → **YEAR**
  (`[0x538A]`) → heap string `#[0x93A0]`.
- **Final transform:** `func_008862` merges the per-nation prefix/colour; then
  **`func_00275C(buf, mode=0)`** paints it centred in the text-box globals
  `[0x2CC6/0x2CC8/0x2CCA/0x2CCC]`.

### 5c. Drawn element
| element | x | y | w·h | text | color | @offset |
|---|---|---|---|---|---|---|
| title banner (centred) | centred (0..320) | ~5 (runtime) | text-box clip | colony name + **Season + Year** + heap parts | nation colour (via func_008862) | 0x026AA6 |

> **Runtime caveat (per UI mandate rule 2):** the **literal rendered sentence is NOT
> statically reproducible** — `0x16E`/`0x22` appends pull from the runtime string heap
> (`[0x2D42:0x2D44]`, `[0x93A0]`, the `−0x6840`/`−0x6800` per-colony word tables) and
> several inputs are live colony fields; and the banner **x/y** come from the
> composer's `0x181f:0xC22` text-box context (runtime). The *mechanism* and *field
> sources* are byte-traced (**B**); the *exact pixels/wording* are **TBD/R** — trace
> `@0x026AA6` (dump `ss:[bp-0x50]`) and read `[0x2CC6..0x2CCC]` for the literals.

---

## 6. TOP MENU BAR + GOLD

### 6a. Command dispatch table — `@0x02BDEA` (RAW)
```
02BDEA  cmp  word [bp+6], 0x13c / jne .. / push owner / lcall 0x191f,0x40c   ; cmd 0x13C
02BE03  cmp  word [bp+6], 0x13d / jne .. /            lcall 0x191f,0x3fe     ; cmd 0x13D
02BE1C  cmp  word [bp+6], 0x13e / jne .. /            lcall 0x191f,0x3f0     ; cmd 0x13E
02BE35  cmp  word [bp+6], 0x13f / jne .. /            lcall 0x191f,0x3e2     ; cmd 0x13F
02BE4E  cmp  word [bp+6], 0x140 / jne .. /            lcall 0x191f,0x3d4     ; cmd 0x140
02BE67  cmp  word [bp+6], 0x141 / jne .. /            lcall 0x191f,0x3c6     ; cmd 0x141
02BE80  cmp  word [bp+6], 0x142 / jne .. /            lcall 0x191f,0x3b8     ; cmd 0x142
02BE99  cmp  word [bp+6], 0x143 / jne .. /            lcall 0x191f,0x41a     ; cmd 0x143
02BEB2  cmp  word [bp+6], 0x144 / ...                 lcall 0x191f,0x3aa     ; cmd 0x144
```
Each menu command (id `0x13C..0x144`) reads the colony owner power
(`[0x8542]+0x1a`) and fires the matching handler thunk. The **same `0x191f:0x3xx`
handler family** is also dispatched by the map-screen menu (`@0x02385D`:
`lcall 0x191f,0x40c` for hotkey `0x41`='A'; `@0x02386E`: `lcall 0x191f,0x3fe` for
`0x42`='B'), i.e. the colony and map menus share the command handlers; only the
trigger ids differ (colony uses the `0x13C..0x144` command codes here, the map menu
uses ASCII hotkeys). The dropdown chrome itself is registered by the resident menu
framework (`spec/ui/menus.md`).

### 6b. Gold value source (byte-verified)
- **Treasury = `PowerRecord + 0x2A`** (`g_gold`), reached via `[0x84FC]`
  (`g_current_power_ptr`). The turn code writes it back, e.g.
  `@0x02E7B7  add word ptr [bx+0x2a], ax  ; PowerRecord.gold` (`bx=[0x84FC]`).
- A **displayed mirror** lives at **DGROUP `+0x9CB0`** (u32) and a formatted ASCII copy
  at **`+0x9CD2`**. **Caveat (corrected here):** the colony-page site `@0x02B80E`
  `mov [0x9cb0],ax / [0x9cb2],dx` writes `[bp-8]` = a **production/market value**
  (computed from `PowerRecord.market_sensitivity` `@0x02B7CF` and colony fields), and
  `@0x02B7FF` sprintf's it into `[0x9CD2]` — i.e. **this particular `[0x9CB0]` write is
  the colony's net-production readout, not the player gold.** The treasury gold uses
  the same mirror slot `[0x9CB0]` when written from the turn/header path
  (`@0x022EB7`, `@0x02E892`, `@0x02E965`). The header gold blit reads the formatted
  `[0x9CD2]` string. (So `[0x9CB0]`/`[0x9CD2]` are a *shared* format slot reused for
  several header numbers; the gold value itself is always `PowerRecord+0x2A`.)

### 6c. "Gold:" label
- `@CTITLE` is the colony-screen LABELS pool (`"Pop:\nGold:\nBUY\nCHANGE\n…\nTax:"`).
  **Only `Gold:` (idx 1)** belongs to the top header; `Pop:` (idx 0) / `Tax:` (idx 9)
  are drawn elsewhere. Gold value = treasury `PowerRecord+0x2A`.

### 6d. Drawn elements
| element | x | y | w·h | text | color | @offset |
|---|---|---|---|---|---|---|
| menu bar dropdowns (8 cmds) | top bar | 0 | — | menu items, ids 0x13C..0x144 | menu chrome | 0x02BDEA+ (dispatch) |
| "Gold:" label | header (runtime) | top bar (runtime) | text | `@CTITLE` idx 1 | menu colour | TBD (runtime menu-renderer blit) |
| gold value | after label (runtime) | top bar (runtime) | text | `[0x9CD2]` ← `PowerRecord+0x2A` | menu colour | TBD (reads `[0x9CD2]` at menu draw) |

> **Runtime caveat:** the exact **x/y/font** of the header gold blit is **menu chrome
> drawn at runtime** (the menu renderer reads `[0x9CD2]`); the literal draw site is not
> a static colony-screen instruction. **TBD** — trace the menu draw of `[0x9CD2]`. The
> *value source* (`PowerRecord+0x2A`, mirror `[0x9CB0]`/`[0x9CD2]`) is **byte-verified**.

---

## 7. Summary of every BORDER / DIVIDER LINE and CLEAR-RECT colour (the "missing borders")

The user observed missing black region-border lines. The byte truth:

1. **Panel borders are NOT drawn as lines by these renderers.** Each panel begins with
   a **`func_02633E` clear that RE-BLITS COLONY.PIK** for that rect — the panel frames /
   borders are **baked into COLONY.PIK pixels**, not stroked. So there is **no
   `push 0 (black) ... 0x181f:0xCE`** for the panel outlines. (Confirms decode §5: "do
   NOT also draw panel outlines over the PIK.")
2. The **only explicit line/rect (`0x181f:0xCE`) draws** on these panels are:
   - **flag bracket lines** colour **`0x3F` (63)** — `func_028466` `@0x0284AD/0x028518`.
   - **stockpile selection/boycott/over-cap boxes** colours **`0x0A` / `0x0E` / `0x0C`**
     — `func_02819E` `@0x0281CE` (right edge literal `0xC7`).
   - the **field-production-panel dividers** (separate function `func_0264A8`, not in
     this set) at `y=104` and `y=128`.
   - the **minimap preview dividers** colour `[bp-0x72]` (`0x0A` or `0x0F`) `@0x027F9D`.
3. **Clear-rect colours:** none are solid — all four panels (`func_027DB2`,
   `func_02814C`, `func_02853C`, `func_0281D6`) clear via `func_02633E` = PIK restore.
   If the project's render currently draws black panel boxes, that is a **double-draw
   over the PIK** and should be removed.

## 8. Status
- **B (byte-verified):** all four panel rects + their clear convention; the
  `func_027DB2` 6-slot geometry (`func_027D84`) + frame `0x7B`; the `func_02814C`
  3-way mode dispatch → `func_0275CE`/`func_027746`/`func_027BB6`; the `func_02853C`
  flag frame `0x44+nation` + the two `0x3F` bracket lines; the `func_0281D6` 16-cell
  pitch-19 geometry, icon `good+0x17`, quantity colours `0x0F/0x0A/0x0C/4`,
  selection/boycott box colours `0x0A/0x0E`, and the `(306,179)` `[0x2F5E]` caption =
  **not gold**; the title banner field sources + paint site; the menu command table
  `0x13C..0x144`; gold = `PowerRecord+0x2A` mirror `[0x9CB0]/[0x9CD2]`.
- **R / TBD (runtime):** title banner literal text + x/y (runtime heap + text-box
  context); minimap caption colour `0x79` (R); the header gold blit x/y/font (runtime
  menu chrome); the `func_0275CE/027746/027BB6` interior content (mode-dependent
  state). Each is named with its trace breakpoint above.
