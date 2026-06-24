# COLONY SCREEN — COMPLETE DECODE (raw + translated, every element)

> **Purpose.** One authoritative file that pulls *every* element of the colony screen
> from `VICEROY.EXE` — functions, RTLink thunks, static data tables, and runtime state —
> with the **raw disassembly** next to a **plain-English translation**, plus exact
> screen coordinates, sprite frames, colors, and border/divider lines. Built 2026-06-24
> to end the piecemeal back-and-forth: if it's drawn on the colony screen, it is decoded
> here with a `func_XXXX @0xNNNN` (or a `DS:0xNNN` byte) citation.
>
> Trust order (per `notes/TRUTH_HIERARCHY.md`): running DOS game > extracted sprite pixels
> > EXE disasm at a cited offset > recon. Where the EXE and the pixel catalog conflict, both
> are shown and the conflict is named — never silently resolved.

---

## 0. How to read this file

Each screen element is documented in three layers:

1. **RAW** — the actual disassembly lines copied from
   `data_extracted/disassembly/VICEROY_annotated.asm` (capstone 16-bit), or the raw bytes
   from `raw/COLONIZE/VICEROY.EXE` for data tables.
2. **TRANSLATED** — what each block does in plain English.
3. **ELEMENT TABLE** — `element | x | y | w/h | sprite/text/LINE | color | @offset`, so the
   renderer can place it without interpretation. Lines/rect-outlines (the black/colored
   borders around each region) are listed as first-class elements.

**Coordinate convention (proven, §1).** The colony screen draws into a single 320×200
indexed back buffer; every `x,y` passed to a blit/line/fill primitive is an **absolute
screen pixel** — there is no per-panel origin or clip transform. So a literal `132` in
`func_0270D0` is screen-y 132. (Earlier "surface-local" hedges were wrong and are corrected
in §4.)

**Thunk convention.** Many draws go through RTLink resident thunks `lcall 0x181F:X` /
`0x191F:X` / `0x1A1F:X`. These are resolved to their target file offset (and named function)
inline; the mechanism is in §6.2. A plain `grep "call 0x7464C"` finds **nothing** for these
because the call goes through a thunk stub + `ljmp` trampoline — see §6.2.

---

## 1. How the colony screen is set up (architecture)

```
colony_screen_main(colony)                       (recol func_01D989)
  set active colony  [0x8542]   (ColonyRecord, stride 0xCA)
  precompute surrounding tiles
  paint_colony_background  → load COLONY.PIK      (the bottom-band image)
  COMPOSER  func_028592                           (the 12-step draw list — §3.1)
  event loop  (menu/build dialogs, §5)
```

- **One back buffer.** `[0x83e]:[0x840]` is a single 320×200 indexed surface, allocated once
  (`@0x0765D9`, from the asset name `"icons"`), pitch = 320. *Every* composer step and every
  panel sub-renderer pushes this same descriptor. There is **no per-panel sub-surface** — all
  coordinates are absolute screen pixels (§6.4).
- **Palette.** The active palette is the **gameplay palette** (PHYS0 / BUILDING / ICONS /
  WOODTILE share it; indices 120–127 are the water/river blue gradient). COLONY.PIK's pixel
  indices are authored against this palette (its embedded palette is a red herring) — so the
  PIK is blitted raw. (§6.4.)
- **Two layers of background.** The base is the gameplay-palette chrome; **COLONY.PIK** is the
  whole bottom band (panel frames + warehouse barrels + stockpile cells + the Europe "E"
  button are baked into the image). Panel sub-renderers draw dynamic content *over* the PIK.
- **The composer (`func_028592`) is a fixed draw list** of ~12 trampolined calls, each
  `call 0x2Cxxx → ljmp 0x191F:NNN → file 0xNNNN` resolving to one named sub-renderer. Draw
  order matters (later steps paint over earlier ones). Full list + resolution in §3.1.

The screen partitions into:

| zone | region (x,y,w,h) | renderer | section |
|---|---|---|---|
| Title / menu bar | top, ~0–9 | func_0268CE + menu @0x02BDEA | §5.5 / §5.6 |
| Building scene | upper-left, x6..173 y13..106 | func_02701C (+026FF2/026DD4) | §3.3 |
| Worked-tiles (field-production) | 224,32,72,72 | func_0264A8 | §4.2 |
| Colonist plaza + SoL/Tory + Food/Cross/Bell | 0,130,120,48 | func_0270D0 | §4.1 |
| Surrounding-tile minimap | 121,130,84,48 | func_027DB2 | §5.1 |
| Ship / cargo / message | 211,130,91,48 | func_02814C | §5.2 |
| Flag | 303,132,17,45 | func_02853C | §5.3 |
| Stockpile (warehouse) bar | 0,179,320,21 | func_0281D6 | §5.4 |

---

## 2. How the project documents this (so the file resolves)

- **Three-layer model** (`METHODOLOGY.md`): evidence (EXE/pixels) → **spec** (`spec/`) →
  implementation (`viceroy_cpp/`). This file is evidence+spec for the colony screen.
- **Citations resolve.** Every value carries a `func_XXXX @0xNNNN`, a `DS:0xNNN` byte
  offset (DGROUP file base `0x1D9A0`, so `DS:0xNNN` = file `0x1D9A0+0xNNN`), or a thunk
  `seg:off` (resolved via `tools/follow_thunk.py`, §6.2).
- **Static vs runtime is called out everywhere** (§7). The colony screen mixes *static* data
  (plot positions, category structure, empty-lot frames, the type→frame base table) with
  *runtime* state (which building is in which plot — RNG; production quantities; the final
  building frame; the title string). A value that is runtime is labeled **RUNTIME** with the
  exact site that produces it — it is never invented.

---

## 3. Composer + scene + buildings

**Provenance.** Every line below copied from `data_extracted/disassembly/VICEROY_annotated.asm`
and cross-checked against `docs/COLONY_SCREEN_VICEROY_DECODE.md` and `viceroy_source/src/overlay/`.
Trampolines (`call 0x2Cxxx` → `ljmp 0x191f:NNN`) and `lcall 0x181f/0x191f/0x1a1f` thunks resolved
with `tools/follow_thunk.py`. DGROUP data file base = **0x1D9A0**. Overlay CS base for the §3.5
jump table = file **0x25900**.

### 3.0 Primitive verb glossary (resolved thunks)

| thunk (`0x181f:`) | file | verb | calling convention |
|---|---|---|---|
| `0xCE`  | `0x0E0A2` `func_00E0A2` | **LINE / rule draw** (orders endpoints, plots pixels via `0xBBC:0xC`) | `ax`,`bx`=x endpoints; `dx`=y0; `[bp+8]`=y1; `[bp+6]`=color(byte); `[bp+0xA..0x10]`=4-word surface desc |
| `0xE2`  | `0x0DB3A` `func_00DB3A` | **clipped SPRITE blit** (edge/strip), sheet `[0x2DA8]` — *NOT a line* | `[bp+6],[bp+8],[bp+0xA]`=coords/idx |
| `0x254` | `0x0E76A` `func_00E76A` | **blit ONE sprite** (H-mirror via index bit15) | `bx`=sprite-record ptr; `dx`=index; `ax`=x; pushes y,sheet |
| `0x236` | `0x02EE4` `func_002EE4` | **proportional sprite-strip indicator** (filled/empty icons) | `ax`=fill-sprite,`bx`=count,`dx`=max; `[bp+0xE]`=x,`[bp+0x10]`=y |
| `0x510` | `0x0531C` | **WOODFRAM scene frame** (colony-scene only, 1 caller = `func_026374`) | 7×push coords + 2× 4-word far-ptr |
| `0x506` | `0x05234` | **scene-strip composite** (sheet `[0x2DA8]`) | clip + far-ptr |
| `0x4FC` | `0x051D2` | **sprite-strip / panel-bg composite** | sheet,x,y,frame,count |
| `0xC22` | `0x0BC06` | **graphics-context / scene-clip init** (8 callers) | — |
| `0xC5E` | `0x08720` | **fetch ColonyRecord/Power base ptr** | — |
| `0x718` | `0x060A0` | **world tile-id read** at (x,y) | `[bp+6]`=x,`[bp+8]`=y → id |
| `0x302` | `0x05BFA` | **on-map test** (x,y → bool) | |
| `0x74A` | `0x05EE8` | **fog/visibility test** (x,y → mask) | |
| `0xACE` | `0x09786` | **`byte[type + 0x2CA]`** static base-frame lookup | `[bp+6]`=type |
| `0xBAA` | `0x09818` | **upgrade-chain level walk** | `[bp+6]`=type |
| `0xA88` | `0x0975A` | building meta flag (sign chooses branch) | `[bp+6]`=type |
| `0x9FC` | `0x0863E` | **has_building / type-enabled test** (47 callers) | `[bp+6]`=type |
| `0x13C` | `0x02B38` | **blit string** (FONTTINY) | ss:ptr |

### 3.1 COMPOSER — `func_028592 @0x028592`

The fixed draw list: 12 paint steps + a conditional 13th. Each `call 0x2Cxxx` is a trampoline
resolved through `ljmp 0x191f:NNN` to its file offset.

```asm
028592  push    bp / mov bp,sp
028595  lcall   0x181f, 0xc22          ; STEP 1: scene/graphics-context init  -> file 0x0BC06 (no pixels)
02859B  call    0x2ca5a               ; STEP 2: ljmp 0x191f:0x6f0 -> 0x025C32  colonist-sort (stage A)
02859F  call    0x2cacd               ; STEP 3: ljmp 0x191f:0x804 -> 0x026374  *** SCENE ZONE *** (§3.2)
0285A2  push 0xc8/0x140/0/0           ;         h=200 w=320 y=0 x=0
0285AD  call    0x2cac3               ; STEP 4: ljmp 0x191f:0x7ec -> 0x02633E  full-screen region fill
0285B5  call    0x2cae6               ; STEP 5: ljmp 0x191f:0x840 -> 0x0268CE  TITLE / status text line
0285BD  call    0x2c9a1               ; STEP 6: ljmp 0x191f:0x534 -> 0x0264A8  FIELD-PRODUCTION panel (§4.1)
0285C5  call    0x2c9dd               ; STEP 7: ljmp 0x191f:0x5c4 -> 0x0270D0  COLONIST plaza row (§4.2)
0285CD  call    0x2ca19               ; STEP 8: ljmp 0x191f:0x654 -> 0x0281D6  STOCKPILE / warehouse bar (§5)
0285D7  call    0x2c9e7               ; STEP 9: ljmp 0x191f:0x5dc -> 0x02853C  FLAG panel (§5)
0285DF  call    0x2c9fb               ; STEP 10: ljmp 0x191f:0x60c -> 0x027DB2  SURROUNDING-tile minimap (§5)
0285E7  call    0x2c983               ; STEP 11: ljmp 0x191f:0x4ec -> 0x02814C  SoL / cargo / message panel (§5)
0285EF  call    0x2c97e               ; STEP 12: ljmp 0x191f:0x4e0 -> 0x02701C  *** 15-PLOT BUILDING LOOP *** (§3.3)
0285F4  cmp     word ptr [bp + 6], 0  ; if (arg0 != 0):
028607  lcall   0x181f, 0xe2          ; STEP 13 (cond.): clipped sprite strip over (0,0,320,200) -> 0x0DB3A
02860D  retf
```

**Draw order matters** (later steps paint over earlier). Note: the scene zone (3) draws first, then a
full-screen fill (4) establishes the chrome the panels paint over, then each panel. The remainder of
the function (`0x02860E`+) is separate per-panel "redraw one element" dirty-flag handlers, not part
of the straight-line paint.

| step | sub-renderer (file) | element | region (x,y,w,h) |
|---|---|---|---|
| 1 | `0x0BC06` | ctx/clip init (no pixels) | — |
| 2 | `0x025C32` | colonist sort A (state only) | — |
| 3 | `0x026374` | **scene zone** (ground + units + WOODFRAM) | top, y7..~128 |
| 4 | `0x02633E` | full-screen region fill | 0,0,320,200 |
| 5 | `0x0268CE` | title/status text | centered, y~5 |
| 6 | `0x0264A8` | field-production panel | 224,32,72,72 |
| 7 | `0x0270D0` | colonist plaza row | 0,130,120,48 |
| 8 | `0x0281D6` | stockpile bar | 0,179,320,21 |
| 9 | `0x02853C` | flag panel | 303,132,17,45 |
| 10 | `0x027DB2` | surrounding minimap | 121,130,84,48 |
| 11 | `0x02814C` | SoL/cargo/msg panel | 211,130,91,48 |
| 12 | `0x02701C` | **15-plot building loop** | scene region |
| 13 | `0x0DB3A` | bottom sprite strip (cond.) | 0,0,320,200 extent |

### 3.2 SCENE ZONE — `func_026374 @0x026374`

```asm
026374  enter 0xe,0 / push si
026379  mov bx,[0x8542]              ; g_current_colony_ptr
02637D  mov al,[bx]    -> [0x17c]    ; colony map X (clip origin)
026384  mov al,[bx+1]  -> [0x17e]    ; colony map Y
02638A  lcall 0x181f,0xc5e           ; fetch power/colony base ptr (0x08720)
02639A  lcall 0x191f,0x8a4           ; scene prep A -> 0x06891E
02639F  lcall 0x191f,0x896           ; scene prep B -> 0x0672C8
0263A4  lcall 0x191f,0x888           ; scene prep C -> 0x06716A  (lay out standing-unit positions)
; --- WOODFRAM scene-frame + ground composite ---
0263A9  push 0x50/0x50/8/0xc8/0/0    ; frame geometry
0263B6  push [0x83a4..0x839e]        ; dest surface far-ptr (COLONY.PIK band)
0263C6  push [0x83a4..0x839e]        ; src surface far-ptr (scene sheet)
0263D6  lcall 0x181f,0x510           ; *** scene composite blit (WOODFRAM) *** -> 0x0531C
0263DE  lcall 0x181f,0xc5e           ; re-fetch base
0263E5  mov al,[bx+0x329]            ; loop bound = unit count on tile
; --- per standing-unit loop ---
0263FA  mov al,[bx+0xde] + colonyY   ; world Y (row offset table +0xDE)
02640E  mov al,[bx+0xc8] + colonyX   ; world X (col offset table +0xC8)
02641D  lcall 0x181f,0x302           ; on-map test (skip if off)
026439  lcall 0x181f,0x74a           ; fog/visibility mask (AI colonies)
026459  lcall 0x181f,0x718           ; world tile-id read
02646C  imul 0x18 * row + 0x3c       ; screen Y = 60 + 24*row
026481  imul 0x18 * col + 0xfc       ; screen X = 252 + 24*col
02648B  add ax,0x5a                  ; frame = tile_id + 0x5A
026492  lcall 0x181f,0x254           ; *** blit terrain/unit sprite *** -> 0x0E76A
0264A7  retf
```

**Translation.** Read colony map coords into the scene clip origin; run 3 scene-prep sub-renderers
that lay out the standing-unit positions; **WOODFRAM composite** (`0x181f:0x510`, colony-scene-only,
single caller) paints the scene ground + its wood frame — *this is the scene border the user reported
missing, a sprite frame, NOT a `0xCE` line*. Then for each unit on the tile: compute world (X,Y) from
offset tables `[+0xC8]`(col)/`[+0xDE]`(row), skip if off-map or not in the owner's fog mask, read the
tile id, and blit frame `= tile_id + 0x5A` at screen `X = 252 + 24*col`, `Y = 60 + 24*row`.

| element | x | y | sprite frame / LINE | sheet | @offset |
|---|---|---|---|---|---|
| Scene prep A/B/C (layout only) | — | — | — | — | 02639A/02639F/0263A4 |
| **WOODFRAM scene frame + ground** | 0 (`[0x839E]`) | 0 base | composite frame (`0x510`) | `[0x83A2:0x83A4]` | 0263D6 |
| Standing unit/terrain sprite (×N) | 252+24·col | 60+24·row | frame = `tile_id + 0x5A` | `[0x839E]` | 026492 |

> The scene's visible **border** is the WOODFRAM composite at `0x0263D6` — there is no separate `0xCE`
> divider inside `func_026374`.

### 3.3 BUILDING LOOP — `func_02701C @0x02701C` (15 plots)

```asm
02701C  enter 0xa,0 / push si
; --- PRE-LOOP element 1: a LINE (0xCE) ---
027021  push [0x2dae..0x2da8]        ; surface descriptor
027031  push 0x80                    ; [bp+8] = y1 = 128
027034  push 0                       ; [bp+6] = color = 0 (BLACK)
027036  mov ax,0xffff / dx,7 / bx,0xc7  ; x endpoints -1 & 199 ; y0 = 7
02703F  lcall 0x181f,0xce            ; *** LINE *** (black panel-border rule) -> 0x0E0A2
; --- PRE-LOOP element 2: panel-bg sprite strip (0x4FC) ---
027044  push 7/0x78/0xc7/8/0         ; count=7 y=120 x=199 frame=8
02705F  lcall 0x181f,0x4fc           ; *** panel-bg sprite strip *** -> 0x051D2
; --- the 15-slot loop ---
027067  mov [bp-8],0                 ; slot = 0
027081  mov bx,[bp-8] / shl bx,2
027087  mov ax,[bx+0x266]           ; plot.x  (DS:0x266[slot])
02708B  mov cx,[bx+0x268] / add cx,8 ; plot.y + 8
027095  mov dl,[bx-0x729e]          ; category  byte[DS:0x8D62 + slot]
02709D  mov al,[bx-0x717e]          ; level     byte[DS:0x8E82 + slot]
0270A2  or ax,ax / jl 0x2706e        ; level < 0 -> EMPTY branch
0270A6  push dx/cx/si/ax / call 0x2ca23 ; BUILT  -> ljmp 0x191f:0x66c -> 0x026DD4
027072  push dx/cx/si    / call 0x2cae1 ; EMPTY  -> ljmp 0x191f:0x834 -> 0x026FF2
0270B4  cmp [bp+6],0                 ; POST-LOOP (cond.)
0270C8  lcall 0x181f,0xe2            ; clipped edge sprite @ (199,120) -> 0x0DB3A
0270CF  retf
```

**Translation.** The loop draws a **black `0xCE` border rule** (x −1→199, y 7→128, color 0) framing
the building-panel column — *one of the "missing" border lines* — then the wood panel-bg strip. Then
for each of 15 slots: read `plot.x = word[DS:0x266 + slot*4]`, `plot.y = word[DS:0x268 + slot*4] + 8`,
`category = byte[DS:0x8D62 + slot]`, `level = byte[DS:0x8E82 + slot]`. **level < 0 → EMPTY**
(`func_026FF2`); else **BUILT** (`func_026DD4`).

| element | x | y | sprite/LINE | color | @offset |
|---|---|---|---|---|---|
| **Panel border LINE** | −1 → 199 | 7 → 128 | **LINE** (`0xCE`) | **0 (black)** | 02703F |
| Panel-bg sprite strip | 199 | 120 | frame 8 ×7 (`0x4FC`) | — | 02705F |
| Per-plot building (×0..15) | `[0x266+slot*4]` | `[0x268+slot*4]+8` | `func_026DD4`/`func_026FF2` | — | 0270AB / 027072 |
| Post-loop edge sprite (cond.) | 199 | 120 | sheet `[0x2DA8]` (`0xE2`) | — | 0270C8 |

**The 15 plot positions** (static `DS:0x266`, file `0x1DC06`, stride 4; y raw and +8 as drawn):

| slot | x | y(raw) | y(drawn) | slot | x | y(raw) | y(drawn) |
|---|---|---|---|---|---|---|---|
| 0 | 56 | 5 | 13 | 8 | 128 | 45 | 53 |
| 1 | 145 | 7 | 15 | 9 | 10 | 68 | 76 |
| 2 | 173 | 10 | 18 | 10 | 15 | 94 | 102 |
| 3 | 8 | 33 | 41 | 11 | 87 | 3 | 11 |
| 4 | 37 | 37 | 45 | 12 | 66 | 79 | 87 |
| 5 | 67 | 46 | 54 | 13 | 123 | 98 | 106 |
| 6 | 96 | 45 | 53 | 14 | 123 | 47 | 55 |
| 7 | 6 | 6 | 14 | | | | |

Category counts `DS:0x224 = [7,4,2,1,1]`; type-bases `DS:0x22a = [0,7,11,13,14]`.

### 3.4 EMPTY / CLEARED-LOT DRAWER — `func_026FF2 @0x026FF2`

```asm
026FF2  enter 2,0
026FF6  mov bx,[bp+0xa]             ; category (3rd arg)
026FF9  mov al,[bx+0x260]          ; frame = byte[DS:0x260 + category]
026FFE  or ax,ax / je 0x27019       ; frame == 0 -> draw nothing
027002  push [0x844]/[0x842]/[bp+8] ; sheet rec + y
027011  mov dx,[bp+6]              ; x
027014  lcall 0x181f,0x254         ; *** blit ONE sprite *** -> 0x0E76A
02701A  retf
```

`func_026FF2(x, y, category)`: frame = `byte[DS:0x260 + category]` (5-entry table at `DS:0x260`, file
`0x1DC00` = `[45,44,43,0,46]`); if 0, draw nothing; else blit that one sprite at (x,y) from sheet
`[0x2DA8]`.

### 3.5 BUILT-BUILDING DRAWER — `func_026DD4 @0x026DD4` + FRAME MAPPER `func_026CC2 @0x026CC2`

**Frame mapper `func_026CC2(type, *out_index, *out_dims, *out_flag) -> frame`:**
1. **Special-cased types** (skip the static table): type `0x13`/`0x14` → frame `[0xA892]` (runtime),
   dims `0x3F`; type `0x11` → frame `[0x8DD8]` (runtime), dims `0x1F`.
2. **General case:** `base = byte[DS:0x2CA + type]` (`0x181f:0xACE`). If `base == 0xFF` → no sprite.
3. `level = 0x181f:0xBAA(type)` walks the upgrade chain; `<0` → bail.
4. **Inline jump table** at file `0x26D72` (CS base 0x25900), switch on `base-9`:
   - base 9-12,14-15 → default: `index = base`, `dims = base + 0x17`
   - base **13** → index 0x10, dims 0x37
   - base **16** → index 0x11, dims 0x39
   - base **17** → index 0x12, dims 0x3F
5. **RUNTIME final frame:** `frame = word[DS:0x8DC8 + index*2]` (`@0x026D8F`, `[bx-0x7238]`,
   `0x10000-0x7238 = 0x8DC8` = the **per-colony production block** — so the actual BUILDING.SS frame is
   resolved from live state, NOT statically). If base == 0x11, `frame -= [0xA892]`.

Raw jump table bytes (file `0x26D72`): `30 14 30 14 30 14 30 14 3E 14 30 14 30 14 4A 14 56 14`.

**Static `DS:0x2CA` base-frame table** (file `0x1DC6A`, 42 entries, grouped in 3 = the three upgrade
levels per category; `0xFF` = no BUILDING.SS sprite):
```
21 21 21  0F 0F 0F  FF FF FF  11 11 11  12 12 12  FF FF FF  FF FF FF
0B 0B 0B  0A 0A 0A  09 09 09  11 11     0C 0C 0C  0D 0D     10 10     0E 0E 0E
```

**Built drawer `func_026DD4(type, x, y, category_rec)`:**
1. Latch colony sub-mode `[0x336]` → `[0x70]`.
2. Pick **base lot sprite frame**: default `type+1`; type-0/0xF/0x11 special-cased (frames 0x11/0x2F/
   0x30) via `has_building` (`0x181f:0x9fc`).
3. **Blit base building sprite** at (x,y) from sheet `[0x2DA8]` (`0x254`) — `@0x026E4E`.
4. Query base/level, promote type 0xF→0x11 if upgraded, **call frame mapper `func_026CC2`** for the
   runtime overlay frame/dims.
5. Draw the **proportional production-icon strip** (`0x236`) at per-category sub-offsets `[+0x24E]`(x)/
   `[+0x254]`(y)/`[+0x25A]`(width) — `@0x026EF7`.
6. By level sign, draw an **upgrade badge** (`func_026BCC`) or **alt badge** (`func_026AB2`) at offsets
   `[+0x23C]`(x)/`[+0x242]`(y).
7. If production count (`ColonyRecord+0x95`/`+0x96`) > 1, format and **blit the number text** in white
   (0x0F) at per-category text anchor `[+0x230]`/`[+0x236]` — `@0x026FE4`.

| element | x | y | sprite frame / text | color | @offset |
|---|---|---|---|---|---|
| Base building lot sprite | plot.x | plot.y+8 | frame `type+1` (or 0x11/0x2F/0x30) | sheet `[0x2DA8]` | 026E4E |
| Production-icon strip | `x+[cat+0x24E]` | `y+[cat+0x254]` (+9 if 0x11) | fill `[bp-0x5e]`, count = runtime `word[0x8DC8+idx*2]` | — | 026EF7 |
| Upgrade badge (level>0) | `x+[cat+0x23C]` | `y+[cat+0x242]` | via `func_026BCC` | — | 026F2B |
| Alt badge (level<0) | `x+[cat+0x23C]` | `y+[cat+0x242]` | via `func_026AB2` | — | 026F5F |
| Production-count number | `x+[cat+0x230]/2−1` | `y+[cat+0x236]/2−3` | int string (`+0x95`/`+0x96`) | **0x0F white** | 026FE4 |

> **Runtime caveat (per CLAUDE.md UI mandate):** the final BUILDING.SS frame at `0x026D8F`
> (`word[DS:0x8DC8 + index*2]`) is read from the per-colony production block (BSS `0x8DC8`), populated
> at runtime — NOT statically knowable. The static `0x2CA` table gives only the **pre-lookup index**.
> This is the byte-level reason the exact built-building sprite cannot be reproduced from the EXE
> alone (compounding the §7 RNG-placement issue).

### 3.6 Trampoline / thunk resolution appendix (§3)

| call | trampoline `ljmp 0x191f:` | file | role | | `lcall 0x181f:` | file | verb |
|---|---|---|---|---|---|---|---|
| `0x2ca5a` | `0x6f0` | `0x025C32` | colonist sort A | | `0xC22` | `0x0BC06` | ctx/clip init |
| `0x2cacd` | `0x804` | `0x026374` | scene zone | | `0xE2` | `0x0DB3A` | clipped sprite blit |
| `0x2cac3` | `0x7ec` | `0x02633E` | full-screen fill | | `0xCE` | `0x0E0A2` | LINE / rule |
| `0x2cae6` | `0x840` | `0x0268CE` | title text | | `0x254` | `0x0E76A` | blit one sprite |
| `0x2c9a1` | `0x534` | `0x0264A8` | field-production panel | | `0x236` | `0x02EE4` | proportional strip |
| `0x2c9dd` | `0x5c4` | `0x0270D0` | colonist plaza | | `0x510` | `0x0531C` | WOODFRAM frame |
| `0x2ca19` | `0x654` | `0x0281D6` | stockpile bar | | `0x506` | `0x05234` | scene-strip composite |
| `0x2c9e7` | `0x5dc` | `0x02853C` | flag panel | | `0x4FC` | `0x051D2` | panel-bg strip |
| `0x2c9fb` | `0x60c` | `0x027DB2` | surrounding minimap | | `0xC5E` | `0x08720` | fetch base ptr |
| `0x2c983` | `0x4ec` | `0x02814C` | SoL/cargo/msg | | `0x718` | `0x060A0` | world tile-id read |
| `0x2c97e` | `0x4e0` | `0x02701C` | building loop | | `0x302` | `0x05BFA` | on-map test |
| `0x2cae1` | `0x834` | `0x026FF2` | empty-lot drawer | | `0x74A` | `0x05EE8` | fog/visibility |
| `0x2ca23` | `0x66c` | `0x026DD4` | built-building drawer | | `0xACE` | `0x09786` | `byte[type+0x2CA]` lookup |
| `0x2ca46` | `0x6c0` | `0x026CC2` | frame mapper | | `0xBAA` | `0x09818` | upgrade-chain walk |
| `0x2ca55` | `0x6e4` | `0x026BCC` | upgrade-badge drawer | | `0xA88` | `0x0975A` | building meta flag |
| `0x2c9b5` | `0x564` | `0x026AB2` | alt-badge drawer | | `0x9FC` | `0x0863E` | has_building test |
| | | | | | `0x13C` | `0x02B38` | blit string (FONTTINY) |
| | | | | | `0x191f:0x8a4/0x896/0x888` | `0x06891E/0x0672C8/0x06716A` | scene-unit layout prep |

## 4. Plaza + worked-tiles

**Source:** `data_extracted/disassembly/VICEROY_annotated.asm` (lines 43104–43467 and 44219–44651).
**Render model:** both routines draw into the single 320×200 back buffer with **no panel-origin
transform** — every x/y below is an **absolute screen coordinate**.

### 4.0 Primitive / thunk dictionary (resolved via `tools/follow_thunk.py`, cross-ref `viceroy_source/docs/UI_PRIMITIVES.md`)

| Thunk `0x181F:N` | Target file | Verb | Signature (load-bearing) |
|---|---|---|---|
| `:0xCE` | `func_00E0A2` | **RECTANGLE-OUTLINE / box-line draw** (2 HLINEs via `0xBBC:0xC` + 2 VLINEs via `0xBC3:6`). **This is the line/divider/border verb.** | `ax`=x1, `bx`=x2 (auto-ordered), `dx`=y1, `[bp+8]`=y2, `[bp+6]`=**color**, `[bp+0xA..0x10]`=4-word surface descriptor `[0x2DA8/0x2DAA/0x2DAC/0x2DAE]`. A 1-px-tall box (y1==y2) = a horizontal rule; 1-px-wide = a vertical rule. |
| `:0x222` | `func_0033F2` | **ENQUEUE row item** (sprite,value,color) into accumulators `[0x2CCE]/[0x2CE2]/[0x2CF4]`, INC `[0x2CE0]`. No draw. | `ax`=value, `bx`=count/width, `dx`=fill-sprite. The SoL/Tory split-bar enqueue. |
| `:0x22C` | `func_003104` | **FLUSH centred icon+value row** (drains accumulators, H-centres). | `[stack]`=span, `dx`=y, `bx`=x. The Food/Crosses/Bells production row. |
| `:0x254` | `func_00E76A` | **Blit ONE sprite** (bit15 of index = H-mirror). | `ax`=frame, `bx`=sprite-record ptr (`[0x2DA8]`), `dx`=x, `[stack]`=y. |
| `:0x2BC` | `func_00386A` | **Per-unit info panel** (colonist icon + stat spans). | `ax`=unit idx, x/y on stack. The worker colonist render. |
| `:0x236` | `func_002EE4` | **Proportional sprite-strip indicator** (filled idx = `ax`, empty idx = **0x38=56**). | center/expert worker markers, good-icon strips. |
| `:0x506` | `func_005234` | **Surrounding-land strip composite** (sheet `[0x2DA8]`). | panel background. |
| `:0xE2` | `func_00DB3A` | **Clipped sprite blit** (cursor-hidden); the bottom restore-strip. | — |
| `:0x218` | `func_0033EA` | reset row accumulator counter `[0x2CE0]=0`. | — |
| `:0xB3C` | `func_009B9C` | **production-quantity compute** (returns yield count in `ax`). | tile (col,row) in. |
| `:0xC0E` | `func_0090C8` | map (outer,inner)→**tile-direction/offset index**. | — |
| `:0xA74` | `func_0091CC` | map tile index → **worked-tile slot / unit-at-tile**. | — |
| `:0x7E0` | `func_0066CC` | **find unit-at-tile** record (returns unit idx in `ax`, −1 none). | — |
| `:0x2E4` | `func_0066BA` | **next-unit-in-stack** iterator. | — |
| `:0xC86` | `func_008524` | **SoL%/rebel-sentiment compute** (returns % in `ax`). | — |
| `:0xCE0` | (tile-good lookup) | (outer,inner)→**good produced id** (`al`). | — |
| `:0x13C`/`:0x10A`/`:0x178`/`:0x11E`/`:0x182`/`:0x128`/`:0x204` | str heap | itoa / strcat / strlen / draw-string helpers. | — |

> **CRITICAL for the "missing black borders":** every border/divider on these two panels is a
> `0x181F:0xCE` (rectangle-outline) call. The **color is the `[bp+6]` stack push immediately before
> the `lcall`** (the `push <color>` that follows the four `push [0x2DAx]` surface pushes). If borders
> are missing in a port, the `0xCE` calls with `push 0` were dropped, or the surface-descriptor
> `[0x2DA8..0x2DAE]` clip window is wrong. (Full inventory in §4.3.)

### 4.1 `func_0264A8` — upper-right WORKED-TILES / field-production panel

#### 4.1a Raw disassembly (verbatim, file offsets)

```asm
0264A8  enter   0x20, 0
0264AD  mov     al, byte ptr [0x336]          ; player nation byte
0264B2  mov     word ptr [0x70], ax           ; set active-nation render var
0264B5  mov     ax, 0x18                      ; 24 = tile stride
0264BE  mov     al, byte ptr [0x835]
0264C4  push    0x78  / 0x78 / 8              ; clear-rect w=120 h=120 y=8
0264CA  mov     ax, 0xc8                      ; 200  (clear-rect x)
0264D1  push    [0x2dae]/[0x2dac]/[0x2daa]/[0x2da8]  ; surface descriptor
0264E1  lcall   0x181f, 0x506                 ; SURROUNDING-LAND STRIP composite @ (200,8,120,120)
0264E9  push    0x48 / 0x48 / 0x20 / 0xe0     ; panel-fill h=72 w=72 y=32 x=224
0264F3  call    0x2cac3                       ; trampoline -> PANEL RECT FILL (224,32,72,72)
; --- divider rule #1 (outer panel frame) ---
0264F9  push    [0x2dae]/[0x2dac]/[0x2daa]/[0x2da8]
026509  push    0x80                          ; y2 = 128
02650C  push    0                             ; COLOR = 0 (BLACK)
02650E  mov     ax, 0xc7  / dx, 7 / bx, 0x140 ; x1=199 y1=7 x2=320
026517  lcall   0x181f, 0xce                  ; BOX/RULE (199,7)-(320,128) color 0
; --- divider rule #2 (inner grid frame) ---
02651C  push    [0x2dae]/[0x2dac]/[0x2daa]/[0x2da8]
02652C  push    0x68                          ; y2 = 104
02652E  push    0                             ; COLOR = 0 (BLACK)
026530  mov     ax, 0xdf / dx, 0x1f / bx, 0x128 ; x1=223 y1=31 x2=296
026539  lcall   0x181f, 0xce                  ; BOX/RULE (223,31)-(296,104) color 0
02653E  mov     word ptr [bp - 0x14], 0       ; row = 0
026543  jmp     0x2689d                       ; -> row loop test
; ===== inner-cell body (per (col=[bp-0x12], row=[bp-0x14])) =====
026553  mov     al, byte ptr [bx + si - 0x7210] ; flags = DS:[col*5+row - 0x7210] (work-tile flag table)
02655C  test    al, 0x40                      ; bit 0x40 = "produces a good"?
02655E  je      0x26589
026584  lcall   0x181f, 0xce                  ; good-cell BOX (cell_x,cell_y)-(+23,+23) color 0x0C (orange)
026589  cmp     word ptr [bp - 4], 0
02659C  cmp     byte ptr [bx + si - 0x7262], 0 ; road/edge table
0265B8  mov     ax, 0x6d                      ; FRAME 0x6D (109) = empty/road marker
0265BF  lcall   0x181f, 0x254                 ; BLIT empty-marker (cell_x+8, cell_y+4)
0265C4  test    byte ptr [bp - 4], 0x80       ; worked?
0265E9  lcall   0x181f, 0x7e0                 ; FIND unit-at-tile(world_x,world_y) -> ax
;   world_y = colony.y + row - 2 ; world_x = colony.x + col - 2
026606  cmp     byte ptr [bx + 0x5236], 1     ; UnitType.category > 1 ?
026610  lcall   0x181f, 0x2e4                 ; next unit in stack
026639  lcall   0x181f, 0x2bc                 ; UNIT-PANEL (worker) @ (cell_x+4, cell_y+4)
02663E  test    byte ptr [bp - 4], 8          ; center-worker marker?
02665A  mov     ax, 0x17                      ; filled idx 0x17 (good base)
02665D  lcall   0x181f, 0x236                 ; STRIP center marker @ (cell_x,cell_y)
02668A  lcall   0x181f, 0x236                 ; STRIP expert marker @ (cell_x, cell_y+13)
; --- production quantity ---
02669B  lcall   0x181f, 0xb3c                 ; COMPUTE yield -> ax (and [bp-0x10] = good id)
0266A9  add     ax, 0x17                      ; good icon frame = good + 0x17
0266B5  lcall   0x181f, 0xce0                 ; tile good lookup
0266C2  lcall   0x181f, 0xc0e                 ; tile direction/offset idx
0266D0  cmp     ax, 8 -> [bp-2]=0x3a          ; dir 8: good icon -> frame 0x3A (58)
0266D7  cmp     word ptr [bp - 0xe], 0
0266DB  jle     0x26708                       ; yield<=0 branch
0266E5  cmp [bp-0xe],2 -> w=0x10(>2)/0x18(<=2)
026700  lcall   0x181f, 0x236                 ; STRIP good-icons @ (cell_x,cell_y), count=yield
; --- yield<=0: single good icon centred + marker ---
02673E  lcall   0x181f, 0x254                 ; BLIT centred good icon @ (cell_x+(16-w)/2, cell_y+1)
02674E  mov     ax, 0x41                      ; FRAME 0x41 (65) = small overlay marker
026758  lcall   0x181f, 0x254                 ; BLIT marker 0x41 @ (cell_x, cell_y)
02677C  lcall   0x181f, 0x24a                 ; river/road tick @ (cell_x+12, cell_y+6)
; --- selection highlights (when [0xB98]==0) ---
026810  lcall   0x181f, 0xce                  ; selected-tile BOX (cell_x,cell_y)-(+23,+23) color 0x0A (green)
026891  lcall   0x181f, 0xce                  ; cursor-tile  BOX (cell_x,cell_y)-(+23,+23) color 0x0F (white)
; --- cell advance: cell_x = 200 + 24*col, cell_y = 8 + 24*row ---
026794  imul ax,[bp-0x12],0x18 / add 0xc8     ; cell_x = 200 + 24*col
02679E  imul ax,[bp-0x14],0x18 / add 8        ; cell_y = 8 + 24*row
0267A8  cmp [bp-0x12],0 .. 4 / [bp-0x14],0 .. 4 ; skip outer ring (only col,row in 1..3 run body)
; --- epilogue ---
0268AC  mov     word ptr [0x70], 0
0268B2  cmp     word ptr [bp + 6], 0          ; redraw flag
0268C6  lcall   0x181f, 0xe2                  ; CLIPPED restore-blit (200,8,120,120)
0268CD  retf
```

#### 4.1b Plain-English

1. **Prologue / clear:** set nation render var `[0x70]`; tile stride 24; composite the
   **surrounding-land strip** (`0x506`) at **(200,8,120,120)**.
2. **Panel fill:** trampoline `0x2CAC3` fills inner panel rect **(224,32,72,72)**.
3. **Two divider boxes:** rule #1 = box **(199,7)–(320,128)** color **0 (black)** = outer panel frame;
   rule #2 = box **(223,31)–(296,104)** color **0 (black)** = inner 3×3 grid frame. *(These are the
   borders the user reports missing.)*
4. **Cell loop:** `cell_x = 200 + 24*col`, `cell_y = 8 + 24*row`; **only the inner 3×3 (col,row ∈
   1..3)** runs the body; outer ring skipped.
5. **Per inner cell:** read work-tile flag `DS:[col*5+row − 0x7210]`. Bit `0x40` (produces good) →
   orange highlight box (color **0x0C**). flags==0 & road≥0 → **empty/road marker frame 0x6D** at
   (cell_x+8, cell_y+4). Bit `0x80` (worked) → find field unit at (colony.x+col−2, colony.y+row−2),
   draw **colonist info panel (`0x2BC`)** at (cell_x+4, cell_y+4). Center/expert markers (`0x236`).
   Compute **yield** (`0xB3C`); draw good as icon **strip (`0x236`)**, frame=good+0x17 (or 0x3A for
   direction 8); or single centred icon + marker frame 0x41 if yield≤0.
6. **Selection highlights** (when `[0xB98]==0`): selected tile → **green box (0x0A)**; cursor tile →
   **white box (0x0F)**; both (cell_x,cell_y)-(+23,+23).
7. **Epilogue:** clear `[0x70]`; if redraw-flag set, restore-blit (200,8,120,120) via `0xE2`.

#### 4.1c Element table — `func_0264A8`

| Element | x | y | w/h | frame / text | color | @offset |
|---|---|---|---|---|---|---|
| Surrounding-land strip (bg) | 200 | 8 | 120×120 | composite `0x506` | (sheet) | 0264E1 |
| Panel rect fill | 224 | 32 | 72×72 | solid `0x2CAC3` | `[0x835]` | 0264F3 |
| **Border box #1 (outer panel frame)** | 199 | 7 | →(320,128) | `0xCE` rect-outline | **0 (black)** | 026517 |
| **Border box #2 (inner grid frame)** | 223 | 31 | →(296,104) | `0xCE` rect-outline | **0 (black)** | 026539 |
| Good-tile highlight box (per cell) | cell_x | cell_y | →(+23,+23) | `0xCE` rect-outline | **0x0C (orange)** | 026584 |
| Empty/road marker | cell_x+8 | cell_y+4 | 8×16 | sprite **0x6D** (109) | (sprite) | 0265BF |
| Worker colonist panel | cell_x+4 | cell_y+4 | ~100×16 | `0x2BC` unit panel | (composite) | 026639 |
| Center-worker marker strip | cell_x | cell_y | span24,w16 | `0x236` filled 0x17, empty 0x38 | (sprite) | 02665D |
| Expert-worker marker strip | cell_x | cell_y+13 | span24,w16 | `0x236` filled good+0x17 | (sprite) | 02668A |
| Good-icon strip (yield>0) | cell_x | cell_y | span24,w16(>2)/24(≤2) | `0x236` frame good+0x17 (or 0x3A) | (sprite) | 026700 |
| Centred good icon (yield≤0) | cell_x+(16−w)/2 | cell_y+1 | icon | sprite good+0x17 | (sprite) | 02673E |
| Overlay marker (yield≤0) | cell_x | cell_y | 14×16 | sprite **0x41** (65) | (sprite) | 026758 |
| River/road tick marker | cell_x+12 | cell_y+6 | small | `0x24A` | (sprite) | 02677C |
| Selected-tile highlight box | cell_x | cell_y | →(+23,+23) | `0xCE` rect-outline | **0x0A (green)** | 026810 |
| Cursor-tile highlight box | cell_x | cell_y | →(+23,+23) | `0xCE` rect-outline | **0x0F (white)** | 026891 |
| Bottom restore-blit (cond.) | 200 | 8 | 120×120 | `0xE2` clipped blit | (sheet) | 0268C6 |

Cell geometry: inner cells col,row ∈ {1,2,3} → cell_x ∈ {224,248,272}, cell_y ∈ {32,56,80}.

### 4.2 `func_0270D0` — colonist PLAZA + SoL/Tory + Food/Crosses/Bells production bar

#### 4.2a Raw disassembly (verbatim)

```asm
0270D0  enter   0x7e, 0
0270D6  push    0x30 / 0x78 / 0x82 / 0         ; plaza clear: h=48 w=120 y=130 x=0
0270E0  call    0x2cac3                        ; PLAZA CLEAR rect (0,130,120,48)
0270E6  mov     bx, word ptr [0x8542]          ; g_current_colony_ptr
0270EA  mov     al, byte ptr [bx + 0x1f]       ; ColonyRecord.size (#colonists)
0270EE  add     ax, word ptr [0x8d72]          ; + extra (units at gate)
0270F2  mov     word ptr [bp - 0x68], ax       ; total colonist count
0270F5  mov     word ptr [bp - 0x5c], 1        ; X = 1
0270FA  mov     word ptr [bp - 0x60], 0x8f     ; Y = 143
; --- pre-pass: sum sprite widths for spacing calc (02710A..027143) ---
027131  mov     ax, word ptr es:[bx + si + 0x3e] ; sprite width  (si = unit*12)
027135  add     word ptr [bp - 0x7e], ax        ; accum total width
; --- spacing fit so colonists fit in 0x60=96px (027143..027173) ---
027143  mov     byte ptr [0xa890], 2           ; spacing = 2
027170  cmp     ax, 0x60                        ; > 96 ? -> shrink spacing & retry
; ===== per-colonist body =====
027186  mov     word ptr [bp - 0x64], 0xa       ; default highlight color 0x0A (green)
0271EC  lcall   0x181f, 0xce                    ; BOX around colonist (X-1,Y+1)-(X+w,Y+h) color [bp-0x64]
02724B  lcall   0x181f, 0xce                    ; (cursor) BOX (X-1,Y+1)-(X+w,Y+h) color 0x0F (white)
0272E7  lcall   0x181f, 0x254                   ; BLIT colonist sprite at (X, Y)
027316  mov     word ptr [bp - 0x64], 0xf       ; cursor highlight -> color 0x0F
; ===== SoL% / production bar (02731E..) =====
027326  mov     word ptr [bp - 0x60], 0xa3      ; Y = 163 (production-bar row)
02732B  lcall   0x181f, 0x218                   ; reset row accumulator
02735B  mov     ax, 0x4017                       ; sprite 0x17 + flag 0x4000 (filled SoL segment A)
02735E  lcall   0x181f, 0x222                    ; ENQUEUE SoL bar segment A
027388  lcall   0x181f, 0x222                    ; ENQUEUE SoL bar (single, 8e32!=0 path)
027397  mov     ax, 0x8017 -> lcall 0x222        ; ENQUEUE second SoL segment (mirror/empty)
0273AD  mov     ax, 0x39 ; dx=[0x8dea]           ; crosses (sprite 0x39, count [0x8DEA])
0273B2  lcall   0x181f, 0x222                    ; ENQUEUE crosses
0273C2  mov     ax, 0x3f ; dx=[0x8dec]           ; bells (sprite 0x3F, count [0x8DEC])
0273C7  lcall   0x181f, 0x222                    ; ENQUEUE bells
0273CC  push 4 / ax=2 / dx=[bp-0x60](=163) / bx=0x76(=118)
0273D7  lcall   0x181f, 0x22c                    ; FLUSH centred production row @ (x=2,y=163,span=118)
0273DC  lcall   0x181f, 0xc86                    ; compute SoL% -> ax
0273E4  sub ax,0x64 / neg ax                      ; Tory% = 100 - SoL%
027400  ... imul size ; +0x32 ; /0x64             ; #Tory = round(Tory%*size/100)
02740E  ... #SoL = size - #Tory
027411  mov     word ptr [bp - 0x60], 0x84       ; Y = 132 (crown/% text row)
027416  mov     al, byte ptr [0x53a6]            ; g_difficulty -> threshold = 10 - difficulty
027437  ... AI: threshold = 0x32 (50)
02743C  mov     word ptr [bp - 0x7c], 0xf         ; Tory% text color 0x0F (white) ...
027449  mov     word ptr [bp - 0x7c], 4           ; ... 4 (red) if #Tory >= threshold
027458  mov     word ptr [bp - 0x7c], 0xc         ; ... 0x0C (orange) if #Tory >= 2*threshold
; --- Tory crown + count text (left) ---
027471  mov     ax, 0x7c                          ; FRAME 0x7C (124) = Tory crown
02747B  lcall   0x181f, 0x254                     ; BLIT Tory crown @ (2,132)
0274EF  lcall   0x181f, 0x13c                     ; DRAW Tory% text @ (crown_w+2, 133) color [bp-0x7c]
; --- SoL% (right-aligned) + crown ---
027551  mov     ax, 0x75                          ; 117 = right edge; x = 0x75 - sprite_w
027589  lcall   0x181f, 0x13c                     ; DRAW SoL% text (right-aligned) @ y=133
02759C  mov     ax, 0x7d                          ; FRAME 0x7D (125) = SoL/rebel crown
0275A6  lcall   0x181f, 0x254                     ; BLIT SoL crown @ (0x75-w, 132)
; --- epilogue ---
0275AB  mov     word ptr [0x70], 0
0275C5  lcall   0x181f, 0xe2                       ; CLIPPED restore-blit (0,130,...)
0275CD  retf
```

#### 4.2b Plain-English

1. **Plaza clear:** trampoline `0x2CAC3` clears the plaza rect **(0,130,120,48)**.
2. **Count + cursor init:** colonist count = `size [+0x1F]` + `[0x8D72]`; X=1, Y=143.
3. **Spacing pre-pass:** sum sprite widths; set inter-colonist spacing `[0xA890]` (starts 2,
   decremented until the row fits in 96px); then X++, Y−−.
4. **Per-colonist loop:** resolve unit (`0xC0E`/`0xA74`), **blit sprite (`0x254`) at (X,Y)**;
   conditionally draw a **highlight box (`0xCE`)** color 0x0A (green) normally or 0x0F (white) for the
   cursor, at (X−1,Y+1)–(X+w,Y+h); advance X by spacing+width (+4 gap before gate units).
5. **Production bar (Y=163):** reset accumulator (`0x218`); **enqueue (`0x222`)** SoL split-bar
   segment(s) (sprite 0x17 + flag 0x4000/0x8000), **Crosses** (sprite 0x39, count `[0x8DEA]`),
   **Bells** (sprite 0x3F, count `[0x8DEC]`); **flush (`0x22C`)** centred at **(x=2, y=163, span=118)**.
6. **Tory/SoL crowns + % text:** SoL% (`0xC86`), Tory%=100−SoL%, #Tory/#SoL; text color by sentiment
   (white 0xF / red 4 / orange 0x0C; threshold = 10−difficulty, or 50 for AI). **Tory crown frame
   0x7C at (2,132)**, count text right of it at y=133. **SoL crown frame 0x7D** right-aligned at
   **x=0x75−w, y=132**, SoL% text right-aligned at y=133.
7. **Epilogue:** clear `[0x70]`; if redraw-flag set, restore-blit the plaza band via `0xE2`.

#### 4.2c Element table — `func_0270D0`

| Element | x | y | w/h | frame / text | color | @offset |
|---|---|---|---|---|---|---|
| Plaza clear rect | 0 | 130 | 120×48 | solid `0x2CAC3` | (bg) | 0270E0 |
| Colonist sprite (per colonist) | X (1+…, advancing) | 143→ | sprite | `0x254`, frame=unit sprite | (sprite) | 0272E7 |
| **Colonist highlight box (selected)** | X−1 | Y+1 | →(X+w,Y+h) | `0xCE` rect-outline | **0x0A (green)** | 0271EC |
| **Colonist highlight box (cursor)** | X−1 | Y+1 | →(X+w,Y+h) | `0xCE` rect-outline | **0x0F (white)** | 02724B |
| SoL bar segment A (filled) | (centred row) | 163 | bar | `0x222` enqueue, sprite 0x17 +flag 0x4000 | (sprite) | 02735E |
| SoL bar segment B | (centred row) | 163 | bar | `0x222` enqueue, sprite 0x17 +flag 0x4000/0x8000 | (sprite) | 02739D / 027388 |
| Crosses count strip | (centred row) | 163 | bar | `0x222` enqueue, sprite **0x39**, count `[0x8DEA]` | (sprite) | 0273B2 |
| Bells count strip | (centred row) | 163 | bar | `0x222` enqueue, sprite **0x3F**, count `[0x8DEC]` | (sprite) | 0273C7 |
| **Production row FLUSH** | x=2 | y=163 | span=118 (0x76) | `0x22C` centred row | (composite) | 0273D7 |
| Tory crown | 2 | 132 | 13×11 | sprite **0x7C** (124) | (sprite) | 02747B |
| Tory% / count text | crown_w+2 | 133 | text | `0x13C` draw string | **0x0F/4/0x0C** ([bp-0x7c]) | 0274EF |
| SoL crown | 0x75−w | 132 | 13×11 | sprite **0x7D** (125) | (sprite) | 0275A6 |
| SoL% text (right-aligned) | rightedge−textw | 133 | text | `0x13C` draw string | **0x0F/4/0x0C** ([bp-0x7c]) | 027589 |
| Bottom restore-blit (cond.) | 0 | 130 | 130×120 | `0xE2` clipped blit | (sheet) | 0275C5 |

> The production-row colors come from `0x222`'s enqueued **sprite index** (0x17/0x39/0x3F), not a
> separate color arg — bar segments use the sprite's own palette; only the Tory/SoL **% text** has an
> explicit color index (`[bp-0x7c]`). Consistent with Food=0x17 / Crosses=0x39 / Bells=0x3F.

### 4.3 The "missing black border lines" — complete `0xCE` inventory

Every panel border/divider/highlight on these two screens is a **`0x181F:0xCE` rectangle-outline**.
The **color is the `push <color>` placed immediately after the four `push [0x2DAx]` surface pushes**
(lands at `[bp+6]` in `func_00E0A2`).

| @offset | corners (x1,y1)-(x2,y2) | color | role |
|---|---|---|---|
| 026517 | (199,7)-(320,128) | **0 (black)** | worked-tiles outer panel frame |
| 026539 | (223,31)-(296,104) | **0 (black)** | worked-tiles inner 3×3 grid frame |
| 026584 | (cell_x,cell_y)-(+23,+23) | 0x0C (orange) | good-tile cell highlight |
| 026810 | (cell_x,cell_y)-(+23,+23) | 0x0A (green) | selected-tile box |
| 026891 | (cell_x,cell_y)-(+23,+23) | 0x0F (white) | cursor-tile box |
| 0271EC | (X−1,Y+1)-(X+w,Y+h) | 0x0A (green) | plaza colonist selection box |
| 02724B | (X−1,Y+1)-(X+w,Y+h) | 0x0F (white) | plaza colonist cursor box |

**The two black (color 0) panel borders are at `func_0264A8` @0x026517 and @0x026539.** If missing in a
port: (a) the two `0xCE` calls were not emitted; (b) `0xCE` was mis-implemented as a no-op clamp (an
error made and corrected 2026-06-23 — `func_00E0A2` *does* draw, via `0xBBC:0xC` HLINEs + `0xBC3:6`
VLINEs); or (c) the surface-descriptor `[0x2DA8..0x2DAE]` clip window is wrong so the lines are
clipped. Note `0x026517` spans the **full outer rectangle** (x 199→320, y 7→128) and `0x026539` the
inner rectangle (223→296 / 31→104) — they are complete 4-sided boxes, not single rules; their bottom
edges happen to sit at y=128 and y=104.

## 5. Bottom panels, title, menu

> Full per-function raw asm for this section is in the companion file
> `docs/COLONY_SCREEN_PANELS_DECOMPILE.md`. Condensed here: the byte-pinned geometry, every
> drawn element, and the **borders/colors** resolution.

### 5.0 Shared primitives (this section)

| thunk | file | role |
|---|---|---|
| `cs:0x2CAC3` → `0x191f:0x7EC` | `0x02633E` | **panel CLEAR/RESTORE rect** — does NOT solid-fill; **re-blits COLONY.PIK** for that rect (panel frames/borders are baked into PIK). Push order `h, w, y, x`. |
| `0x181f:0xCE` → `0x0E0A2` | `draw_rect(x0,y0,x1,y1,color,ctx)` | THE line/border primitive |
| `0x181f:0x254` → `0x0E76A` | `blit_sprite(sheet,frame,x,y)` | |
| `0x181f:0x2BC` → `0x0386A` | clipped worker-colonist blit | |
| `0x181f:0xE2` → `0x0DB3A` | **clipped scroll-blit** (dirty-rect flush tail) — NOT a line | |
| `0x181f:0x22` → `0x02462` | fetch heap string #N from text heap `[0x2D42:0x2D44]` | |
| `0x181f:0x13C` → `0x02B38` | draw formatted/number string | |
| `0x181f:0x100` → `0x02BC8` | draw CENTRED text in a box `(color,y,x,w,ptr)` | |
| `0x181f:0xD3A` → `0x08D00` | warehouse capacity for current colony | |
| `0x181f:0xB0` → `0x0275C` | rich-text painter (title banner) | |

### 5.1 `func_027DB2` — SURROUNDING-TILE MINIMAP — panel **(121,130,84,48)** (composer step 10)

`[0x33C]` = surrounding-tile count. `[0x33C]==0` → one centred caption (heap str `#[0x2DD0]`); else a
worked-tile preview. Always draws a 6-slot icon strip via geometry helper `func_027D84`:
`x = 127 + slot·12`, `y = 165`, `w = 10`, `h = 22`, frame **0x7B (123)**.

| element | x | y | w·h | frame / text | color | @offset |
|---|---|---|---|---|---|---|
| panel clear (PIK restore) | 121 | 130 | 84×48 | COLONY.PIK | (PIK) | 027DC1 |
| centred caption (`[0x33C]==0`) | 121 | 132 | w=84 | heap str `#[0x2DD0]` | **57 (0x39)** | 027DE5 |
| minimap icon ×6 | 127+slot·12 | 165 | 10×22 | sprite **0x7B (123)** | — | 027E2F |
| caption (`[0x33C]!=0`) | 121 | 132 | w=84 | str `#[0x2DE8]`+unit name | 57 | 027EA3 |
| worker sprites (preview) | runtime | runtime | clipped | unit sprite | — | 027F10 |
| divider line(s) (preview) | runtime | runtime | line | — | `[bp-0x72]` (0x0A/0x0F) | 027F9D |

> `[0x2DD0]`/`[0x2DE8]` are BSS (≥0x2CC6) → indices runtime-loaded; file bytes stale.

### 5.2 `func_02814C` — SoL / cargo / MESSAGE panel — **(211,130,91,48)** (composer step 11)

3-way switch on mode byte `[0x337]`: `0`→`func_0275CE` (SoL% + goods strip), `1`→`func_027746`
(ship-in-port; **"No Ships In Port" caption lives inside this**), `2`→`func_027BB6` (active message).

| element | content | @offset |
|---|---|---|
| panel clear (PIK restore) at (211,130,91,48) | COLONY.PIK | 02815A |
| mode-0 → `func_0275CE` | SoL%/goods | 028167 |
| mode-1 → `func_027746` | cargo / "No Ships In Port" | 02816D |
| mode-2 → `func_027BB6` | message text | 028173 |

### 5.3 `func_02853C` — FLAG panel — **(303,132,17,45)** (composer step 9)

Gated by `[0xB98]` (overlay-suppress). Flag sprite = base frame **0x44 (68) + nation byte** (`[0x339]`
if arg `[bp+8]≠0` else `[0x337]`) at panel-local x+3. Helper `func_028466` also draws **two vertical
bracket lines color 0x3F (63)** flanking the flag.

| element | x | y | frame / line | color | @offset |
|---|---|---|---|---|---|
| panel clear (PIK restore) | 303 | 132 | COLONY.PIK | (PIK) | 02854B |
| flag sprite | panel+3 | panel y | **frame 0x44 + nation** | — | 0284CA |
| left bracket line | base_x+frame_w | runtime | line | **0x3F (63)** | 0284AD |
| right bracket line | base_x+frame_w−1 | runtime | line | **0x3F (63)** | 028518 |

### 5.4 `func_0281D6` — STOCKPILE warehouse bar — **(0,179,320,21)** (composer step 8)

16 cells, pitch 19. Per good `i=0..15`: **icon = frame `good + 0x17`** (ICONS 23..38) at **y=181**,
centred (`icon_x = cell_x − icon_w/2 + 9`); **quantity number** = `colony[+0x9A + i*2]` at **y=194**,
color default white **0x0F** / selected **0x0A** / over-cap (`> warehouse cap` via `0x181f:0xD3A`) box
**0x0C red** + text **4**. Second pass draws selection/boycott boxes (`func_02819E`, color 0x0A/0x0E).
Right-end caption heap str `#[0x2F5E]` at **(306,179) color 0x0F white — NOT gold**.

| element | x | y | frame / text | color | @offset |
|---|---|---|---|---|---|
| panel clear (PIK restore) | 0 | 179 | COLONY.PIK | (PIK) | 0281E6 |
| good icon ×16 | cell_x−w/2+9 (cell_x=1+i·19) | 181 | **frame good+0x17** | — | 028270 |
| quantity number ×16 | centred under cell | 194 | itoa(stockpile word) | **0x0F / 0x0A / 4** | 028220 |
| over-cap box | i·19−1..+18 | 179 | box | **0x0C (red)** | 0281CE |
| selected-good box | i·19+1..+18 | 179 | box | **0x0A** | 0283A7→0281CE |
| boycott / mode box | i·19+1..+18 | 179 | box | **0x0E (yellow)** | 0283C1→0281CE |
| right-end caption | 306 | 179 | heap str `#[0x2F5E]` (NOT gold) | **0x0F** | 028407 |

> The box right edge in `func_02819E` is the literal `0xC7`(199) pushed as line x1; the color is the
> passed-in arg (0x0A/0x0C/0x0E) — every box border color is byte-pinned. **Bundle-frame caveat:** in
> the committed bundle Food is frame 22 (base `good+0x16`); the EXE literal `+0x17` indexes the EXE's
> own sheet enumeration.

### 5.5 `func_0268CE` — TITLE banner (composer step 5)

One centred line near top (`y≈5`, runtime). String assembled left→right into `[bp-0x50]`: colony
numeric prefix → 4 per-colony bytes → per-colony table string → title string `[0x2E38]` → tile-attr
number → nation×index byte → **SEASON** (`word[[0x538C]*2 − 0x6800]`, `@SEASONS`) → **YEAR**
(`[0x538A]`) → heap str `#[0x93A0]`. `func_008862` merges nation prefix/color, then **`func_00275C`**
(`0x181f:0xB0`) paints it centred in text-box globals `[0x2CC6..0x2CCC]`.

| element | x | y | text | color | @offset |
|---|---|---|---|---|---|
| title banner (centred) | centred | ~5 (runtime) | colony name + **Season + Year** + heap parts | nation color | 026AA6 |

> **Runtime caveat:** the literal rendered sentence is NOT statically reproducible — appends pull from
> the runtime string heap and live colony fields; banner x/y come from the `0x181f:0xC22` text-box
> context. Mechanism + field sources byte-traced; exact pixels/wording **TBD** (trace `@0x026AA6`, dump
> `ss:[bp-0x50]`, read `[0x2CC6..0x2CCC]`).

### 5.6 TOP MENU BAR + GOLD

**Command dispatch `@0x02BDEA`:** menu commands id `0x13C..0x144` each read colony owner power
(`[0x8542]+0x1a`) and fire `lcall 0x191f,0x3xx` handlers — the **same handler family** the map-screen
menu dispatches by ASCII hotkey (`@0x02385D`), i.e. colony and map menus share command handlers; only
the trigger ids differ. Dropdown chrome is registered by the resident menu framework.

**Gold value:** treasury = **`PowerRecord + 0x2A`** (`g_gold`) via `[0x84FC]` (`g_current_power_ptr`);
turn code writes it back (`@0x02E7B7 add [bx+0x2a],ax`). Displayed mirror at DGROUP `+0x9CB0` (u32) /
formatted ASCII `+0x9CD2`. **Correction:** the colony-page write `@0x02B80E mov [0x9cb0],ax` stores a
**production/market value** (from `market_sensitivity`), not gold — `[0x9CB0]`/`[0x9CD2]` are a shared
format slot reused for several header numbers; the gold *value* is always `PowerRecord+0x2A`. Header
gold blit x/y/font are runtime menu chrome (**TBD** — trace the menu draw of `[0x9CD2]`).

### 5.7 Border / divider / clear-rect color summary — the "missing borders" resolution

1. **Panel borders are NOT drawn as lines by these renderers.** Each panel begins with a `func_02633E`
   clear that **RE-BLITS COLONY.PIK** for that rect — the panel frames/borders are **baked into
   COLONY.PIK pixels**, not stroked. There is **no `push 0 (black) … 0x181f:0xCE`** for the panel
   outlines. If the port currently strokes black panel boxes, that is a **double-draw over the PIK and
   should be removed.**
2. The **only explicit `0x181f:0xCE` line/rect draws** on these panels:
   - flag bracket lines color **0x3F (63)** — `func_028466` `@0284AD`/`@028518`
   - stockpile selection/boycott/over-cap boxes colors **0x0A / 0x0E / 0x0C** — `func_02819E` `@0281CE`
   - minimap preview dividers color `[bp-0x72]` (0x0A or 0x0F) `@027F9D`
   - **the worked-tiles panel's two black frames are in `func_0264A8` `@026517`/`@026539`** (§4.1/§4.3)
     — those *are* the black region borders, drawn by the field-production panel, not these four.
3. **Clear-rect colors:** none are solid — all four panels clear via `func_02633E` = PIK restore.

> Reconciliation: the black borders the user reported missing are real but belong to **`func_0264A8`**
> (the worked-tiles panel, §4.3) and the **building-loop `func_02701C` `@02703F`** (§3.3) — both `0xCE`
> draws with `push 0`. The four bottom panels (minimap/cargo/flag/stockpile) get their frames from the
> PIK, not from line draws. A faithful port must (a) draw the §3.3/§4.3 black `0xCE` rules, and (b)
> blit COLONY.PIK for the bottom band rather than stroking boxes over it.

## 6. Data tables, thunk mechanism, RNG, palette

All values byte-verified from `raw/COLONIZE/VICEROY.EXE`. **DGROUP file base = `0x1D9A0`**, so
`DS:0xNNN` maps to file offset `0x1D9A0 + 0xNNN`. Cross-checked against
`data_extracted/disassembly/VICEROY_annotated.asm`, `tools/follow_thunk.py`,
`tools/parse_thunks.py`, `tools/rtlink/viceroy_rtlink_map.json`, and
`data_extracted/thunk_targets.json`.

### 6.1 Static data tables

The colony "plot" subsystem groups the 15 building/terrain plots into **5 categories**. Element
widths confirmed from the access instructions (`mov al, byte ptr […]` ⇒ byte array;
`mov ax, word ptr […]` ⇒ word array).

#### 6.1a Per-category tables (5 elements each, all BYTE arrays)

| Table | DS off | File off | Raw bytes | Decoded (cat 0..4) | Read at |
|---|---|---|---|---|---|
| **counts/cat** | `0x224` | `0x1DBC4` | `07 04 02 01 01` | **[7, 4, 2, 1, 1]** (Σ=15) | `025D88`, `025DD4` (`mov al,[bx+0x224]`) |
| **bases/cat** | `0x22A` | `0x1DBCA` | `00 07 0B 0D 0E` | **[0, 7, 11, 13, 14]** (running start index of each cat in the 15) | `025D98`, `025DCB`, `025E44` |
| **width/cat** | `0x230` | `0x1DBD0` | `17 2C 35 49 4B` | **[23, 44, 53, 73, 75]** (px) | `025EF5`, `026FD3`, `029EEB` |
| **height/cat** | `0x236` | `0x1DBD6` | `1B 16 25 12 30` | **[27, 22, 37, 18, 48]** (px) | `025EFD`, `026FC5`, `029EE5` |
| **emptyframe/cat** | `0x260` | `0x1DC00` | `2D 2C 2B 00 2E` | **[45, 44, 43, 0, 46]** (sprite frame drawn for an empty lot in that category) | `026FF9` (`mov al,[bx+0x260]`) |
| **suboff_0x24E** | `0x24E` | `0x1DBEE` | `FB 00 00 00 00` | **[251, 0, 0, 0, 0]** — `0xFB` = **−5** signed | `026ECE` |
| **suboff_0x254** | `0x254` | `0x1DBF4` | `FD 01 01 01 01` | **[253, 1, 1, 1, 1]** — `0xFD` = **−3** signed | `026ED7` |
| **suboff_0x25A** | `0x25A` | `0x1DBFA` | `14 16 1E 14 14` | **[20, 22, 30, 20, 20]** | `026EE3` |

`0x24E / 0x254 / 0x25A` are three parallel per-category sub-offset tables consumed together by
`func_026DD4` (the per-plot sprite-emit helper, entry `026ECE`); they are small pixel nudges
(note the negative cat-0 values) applied to the plot anchor before drawing.

#### 6.1b Plot positions — `DS:0x266` (15 plots × {x,y}, WORD array, 60 bytes)

File `0x1DC06`. Read as `mov ax, word ptr [bx+0x266]` at `027087`, `029EC4`.

```
38 00 05 00 91 00 07 00 AD 00 0A 00 08 00 21 00 25 00 25 00
43 00 2E 00 60 00 2D 00 06 00 06 00 80 00 2D 00 0A 00 44 00
0F 00 5E 00 57 00 03 00 42 00 4F 00 7B 00 62 00 7B 00 2F 00
```

| plot | x | y | | plot | x | y |
|---|---|---|---|---|---|---|
| 0 | 56 | 5 | | 8 | 128 | 45 |
| 1 | 145 | 7 | | 9 | 10 | 68 |
| 2 | 173 | 10 | | 10 | 15 | 94 |
| 3 | 8 | 33 | | 11 | 87 | 3 |
| 4 | 37 | 37 | | 12 | 66 | 79 |
| 5 | 67 | 46 | | 13 | 123 | 98 |
| 6 | 96 | 45 | | 14 | 123 | 47 |
| 7 | 6 | 6 | | | | |

These are the on-screen pixel anchors of the 15 colony plots (top-left origin, within the
colony panel / building scene).

#### 6.1c Type → frame-base table — `DS:0x2CA` (42 BYTE entries)

File `0x1DC6A`. Read at `00978D` (`mov al, byte ptr [bx+0x2ca]`). `0xFF` = "no sprite / invalid type".

```
15 15 15 0F 0F 0F FF FF FF 11 11 11 12 12 12 FF FF FF FF FF FF
0B 0B 0B 0A 0A 0A 09 09 09 11 11 0C 0C 0C 0D 0D 10 10 0E 0E 0E
```

Decimal (index 0..41):
```
[21,21,21, 15,15,15, 255,255,255, 17,17,17, 18,18,18, 255,255,255,
 255,255,255, 11,11,11, 10,10,10, 9,9,9, 17,17, 12,12,12, 13,13, 16,16, 14,14,14]
```

Maps a building/terrain **type id** (0..41) to its **sprite frame-base**. Note the run-of-three
structure (each logical type occupies 3 consecutive entries — likely {empty, in-progress,
complete} or 3 graphical sub-states), and the `0xFF` gaps at indices 6–8, 15–20 (reserved/unused
type ids).

#### 6.1d Surrounding-tile offset tables — `DS:0xC8` (dx) and `DS:0xDE` (dy), 20 SIGNED bytes each

`0xC8` file `0x1DA68`; `0xDE` file `0x1DA7E`. Read as signed bytes (`mov al, byte ptr [bx+0xc8]` /
`[bx+0xde]` at `0087C5/0087D4`, `00B08A/00B094`, `00B9C8/00B9DC`).

```
dx (0xC8): 00 01 00 FF FF 01 01 FF 00 02 00 FE FF 01 FF 01 FE FE 02 02
dy (0xDE): FF 00 01 00 FF FF 01 01 FE 00 02 00 FE FE 02 02 FF 01 FF 01
```

Decoded (col,row) deltas — the 20 tiles surrounding the colony, in draw order:

| i | dx | dy | | i | dx | dy |
|---|---|---|---|---|---|---|
| 0 | 0 | −1 | | 10 | 0 | 2 |
| 1 | 1 | 0 | | 11 | −2 | 0 |
| 2 | 0 | 1 | | 12 | −1 | −2 |
| 3 | −1 | 0 | | 13 | 1 | −2 |
| 4 | −1 | −1 | | 14 | −1 | 2 |
| 5 | 1 | −1 | | 15 | 1 | 2 |
| 6 | 1 | 1 | | 16 | −2 | −1 |
| 7 | −1 | 1 | | 17 | −2 | 1 |
| 8 | 0 | −2 | | 18 | 2 | −1 |
| 9 | 2 | 0 | | 19 | 2 | 1 |

The first 8 entries are the 8-neighborhood (N, E, S, W, then the 4 diagonals); entries 8–19 are
the outer ring (the classic Colonization "fat cross" / 3×3-plus-spokes colony work area). dx and
dy are separate parallel arrays.

### 6.2 RTLink thunk dispatch (why `grep "call 0xNNNN"` misses everything)

The colony code never far-calls its targets directly. Pocket Soft **RTLink/Plus** overlays the
binary: each overlay-resident function has a 10- or 14-byte **thunk stub** in the resident thunk
table (`0x1A5F0…`, 1023 thunks). A call site executes `lcall 0xSS1F:0xOFF` into the stub; the
stub is:

```
9A oo oo ss ss      LCALL <RTLink runtime>   ; load overlay if needed
EA oo oo ss ss      LJMP  <overlay seg:off>  ; then jump to the real code
[2–6 trailer bytes for type-A: page id + chain metadata]
```

Two runtime entry points (`parse_thunks.py`):
- **Type-B** `LCALL 0x110D:0x0D91` (file `0x14261`) — resident, no metadata, 10-byte stub. Base = **`0x2400`**.
- **Type-A** `LCALL 0x110D:0x0DAB` (file `0x1427B`) — paged overlay, carries trailer metadata, 12/14-byte stub. Base = the **page's `code_offset`** from the RTLink segment table (`viceroy_rtlink_map.json → segments[page_id]`).

**Resolution formula** (`follow_thunk.py::resolve`):
```
stub_file       = 0x2400 + seg*16 + off              ; locate the stub in the table
base            = 0x2400                  (type-B)
                  segments[page_id].code_offset  (type-A)
target_file_off = base + ljmp_seg*16 + offset_in_segment
```

The 1F-family call segments map to **`ljmp` trampoline pages**: e.g. file `0x76384` is a wall of
`ljmp 0x1A1F:0xD2E`, `ljmp 0x1A1F:0xD3C`, … — the resident code jumps to a trampoline, which
jumps to the stub, which loads+jumps to overlay code. Three call-segment families seen on the
colony path: **`0x181F`** (resident type-B utilities), **`0x191F`** and **`0x1A1F`** (paged
type-A overlays).

#### Worked resolutions (all byte-verified)

**`0x181F:0x4D4` → `random_int` `func_00C322`** (type-B). Stub @file `0x1AAC4`:
`9A 91 0D 0D 11 | EA 32 00 EF 09`. LJMP = `0x09EF:0x0032`.
`0x2400 + 0x09EF*16 + 0x32 = 0x2400 + 0x9EF0 + 0x32 = 0xC322`. ✓ (222 call sites — the shared RNG utility.)

**`0x191F:0x66C` → `func_026DD4`** (type-A, page 2). Stub @file `0x1BC5C`:
`9A AB 0D 0D 11 | EA D4 14 00 00 | 02 00`. LJMP off=`0x14D4`, trailer page=2.
`segments[2].code_offset = 0x25900`; `0x25900 + 0 + 0x14D4 = 0x26DD4`. ✓

**`0x1A1F:0xD2E` → `func_07464C`** (type-A, page 26). Stub @file `0x1D31E`:
`9A AB 0D 0D 11 | EA DC 13 00 00 | 1A 00 1E 01`. `segments[26].code_offset = 0x72090`;
resolved `offset_in_segment=0x13DC`, `ljmp_seg=0x11E`:
`0x72090 + 0x11E*16 + 0x13DC = 0x72090 + 0x11E0 + 0x13DC = 0x7464C`. ✓

**Why `grep "call 0xNNNN"` finds nothing:** the actual target address never appears as an operand
anywhere. The call operand is the *stub's* `seg:off` (a fixed thunk-table slot); the real file
offset only exists as the sum of `base + ljmp_seg*16 + offset_in_segment`, computed at parse/run
time. You must resolve through the thunk table (`thunk_targets.json`) — a textual grep for the
destination is structurally impossible.

### 6.3 The RNG — full chain and its EFFECT

#### 6.3a Core LCG — `rand` = `func_0103D4` (file `0x103D4`)

Microsoft C runtime LCG. Raw bytes:
```
B8 FD 43 BA 03 00 52 50 FF 36 F0 28 FF 36 EE 28 9A 60 0F 1D 0D 05 C3 9E 83 D2 26 A3 EE 28 89 16 F0 28 8B C2 80 E4 7F CB
```
Disassembled:
```
0103D4  mov ax,0x43FD          ; multiplier lo
0103D7  mov dx,0x0003          ; multiplier hi  -> 0x000343FD
0103DC  push [0x28F0] / [0x28EE]  ; 32-bit seed at DS:0x28EE (file 0x2028E)
0103E4  lcall 0xD1D,0xF60      ; 32-bit multiply: seed * 0x343FD
0103E9  add ax,0x9EC3 / adc dx,0x26   ; + 0x00269EC3
0103EF  mov [0x28EE]=ax / [0x28F0]=dx ; store new seed
0103F6  mov ax,dx / and ah,0x7F       ; return (seed>>16) & 0x7FFF
0103FB  retf
```
So: **`seed = seed*0x343FD + 0x269EC3; return (seed>>16) & 0x7FFF`** — a 15-bit result in
0..32767. Seed lives at **`DS:0x28EE`** (file `0x2028E`), 32-bit.

#### 6.3b Range mapper — `random_int` = `func_00C322` (`0x181F:0x4D4`)

```
00C326  lcall 0xD1D,0xE04          ; = rand()  (0..32767)
00C32D  ax = hi - lo (arg8 - arg6)
00C333  inc ax                     ; span = hi-lo+1
00C334  imul cx                    ; rand() * span  (32-bit in dx:ax)
00C336..C35A  >> 15  (take bits 15..30)
00C35C  add ax, lo
```
**`random_int(lo,hi) = lo + (rand()*(hi-lo+1) >> 15)`**. This is *the* placement/generation
primitive (222 call sites across the binary).

#### 6.3c Seed source for the colony — `func_009726` (`0x181F:0xD62`)

Called **once at the top of the colony placement routine** `func_025D34` (at `025D3A`, its first action):
```
009736  bx = [0x8542]             ; current ColonyRecord pointer
00973A  ah = byte[bx+1]           ; colony_y  -> ah, so colony_y<<8
00973F  cdq / al=0
009740  cl = byte[bx]             ; colony_x
009744  ax = (colony_y<<8) + colony_x
009749  add ax,[0x8D80] / adc dx,[0x8D82]   ; + base session seed (32-bit)
009753  lcall 0x9EF,0x1A          ; STORE result as the active LCG seed (-> 0x28EE)
```
**`seed = (colony_y<<8) + colony_x + dword[0x8D80]`**, then installed as the LCG seed. Every
plot/building draw in this colony then pulls from `random_int` off that seed.

#### 6.3d The base seed `dword[0x8D80]` — written ONCE from the BIOS clock

`func_00E4D2` (`0x181F:0xE72`) reads the **BIOS timer tick at `0040:006C`**:
```
00E4D2  mov bx,0x40 / es=bx / bx=0x6C
00E4DA  ax = es:[bx]   dx = es:[bx+2]     ; the 32-bit tick count
00E4E1  retf
```
Called exactly once during game/session init, in `func_075FB6` at `075FF0`, and committed:
```
075FF0  lcall 0x181F,0xE72            ; read 0040:006C
075FF5  mov [0x8D80], ax              ; dword[0x8D80] (file 0x26720) = clock at startup
075FF8  mov [0x8D82], dx
```

#### 6.3e EFFECT (the part that matters)

`dword[0x8D80]` (file `0x26720`) is the **system-clock value captured at game/session start**.
It is therefore:
- **Random across sessions** (different clock tick every launch), but
- **Fixed for the entire session** (written once, never touched again on the colony path).

Combined with §6.3c, a colony's RNG seed is **fully determined by `(colony_y, colony_x)` plus the
one session constant**. Consequences for building layout (`func_025D34` → `func_026DD4`):

- **Within a single game, a given colony tile always lays out its buildings identically** —
  re-opening the same colony reproduces the same arrangement.
- **Two different colonies in the same game differ**, because `(colony_y<<8)+colony_x` differs.
- **The same colony across two different game launches differs**, because `dword[0x8D80]` differs.
- **Therefore the layout is NOT reconstructible from static bytes alone.** To match a specific
  *observed* screen you must capture the live runtime value of `dword[0x8D80]` (or equivalently
  the installed LCG seed at `DS:0x28EE`) at the moment that colony was first laid out. With it,
  the whole sequence is deterministic and replayable.

### 6.4 Palette + surface

**Palette:** the colony screen shares the gameplay palette `viceroy.pal` (name string at
`DS:0x237D`, file `0x1FD1D`, ASCII `"viceroy.pal\0"`), loaded into the palette handle at
`DS:0x83A6` (referenced widely, e.g. `00503C`, `02E18E`). PHYS0/BUILDING sprites composite against
this same palette — no separate colony palette. The animated **water gradient occupies palette
entries 120–127** (the cycled blues), shared with the map.

**Surface:** a single **320×200 8-bpp back buffer**, far-pointer at **`DS:0x83E:0x840`** (file
`0x1E1DE`/`0x1E1E0`), allocated at `0765D9`:
```
0765CE  lea bx,[0x23D6]          ; asset name "icons" (DS:0x23D6, file 0x1FD76: "icons\0")
0765D2  mov ax,0x4000            ; 0x4000 paragraphs = 0x40000 bytes back-buffer arena
0765D6  call 0x76638            ; allocator
0765D9  mov [0x83E]=ax / [0x840]=dx   ; store far pointer
```
Pitch is the screen width **320** (`0x140`); the buffer is accessed as a flat `les bx,[0x83E]`
framebuffer (e.g. `002DA1`, `003087`). **There is no per-panel sub-surface** — the colony panel,
the 15 plots, and the surrounding tiles are all blitted directly into this one buffer at the
`DS:0x266` plot anchors plus the §6.1a sub-offsets, then the whole 320×200 buffer is flipped to
VRAM (`0xA000`). The second buffer at `DS:0x842` (name `"building"` at `DS:0x23DC`) is the
sprite-sheet staging arena, not a render target.

### 6.5-index Key file offsets

rand `func_0103D4`=0x103D4 (seed DS:0x28EE=0x2028E); `random_int func_00C322`=0xC322;
seed-source `func_009726`=0x9726; clock reader `func_00E4D2`=0xE4D2; base-seed write @0x75FF5 →
`dword[0x8D80]`=file 0x26720; placement `func_025D34`=0x25D34; plot emitter `func_026DD4`=0x26DD4;
current-colony ptr DS:0x8542=0x25EE2; back-buffer DS:0x83E=0x1E1DE. Tables: 0x224→0x1DBC4,
0x22A→0x1DBCA, 0x230→0x1DBD0, 0x236→0x1DBD6, 0x24E→0x1DBEE, 0x254→0x1DBF4, 0x25A→0x1DBFA,
0x260→0x1DC00, 0x266→0x1DC06, 0x2CA→0x1DC6A, 0xC8→0x1DA68, 0xDE→0x1DA7E.

## 6.5 Mechanics that drive what is drawn  — *(agent section)*

> The renderer only *reads* state; the simulation *produces* it. This section decompiles
> every game mechanic that determines a value or sprite on the colony screen, and links each
> one to the exact element it feeds — so the screen can be populated from a real turn snapshot
> rather than guessed.

**Scope.** The game-simulation inputs the renderer reads, traced from simulation to the exact
drawn element. All offsets are VICEROY.EXE **file offsets**; DGROUP file base `0x1D9A0` (so
DGROUP var `[0xNNNN]` = file `0x1D9A0+0xNNNN`). ColonyRecord stride `0xCA`; active record pointer
`[DGROUP:0x8542]` (set by `set_active_colony @0x82DC`). Thunks resolved via `tools/follow_thunk.py`.

#### The leaf renderers (all `retf`, called from the un-extracted overlay-0x191F master)

| File offset | Role (byte-derived) | Reads | Draws |
|---|---|---|---|
| **`func_0264A8`** | **Surround worked-tile grid** (loops over a 5-wide field skipping corners `@0x267A8..BE`; tile origin = colony `(x,y)−(2,2)`) | `[0x8542]+0x00/+0x01` (x,y); per-tile yield via `compute_terrain_yield @0x9B9C`; worker resolve | ground sprite + per-tile **good sprite** + **worker figure** |
| **`func_0270D0`** | **Plaza SoL/Tory bar + colonist row** | size `+0x1F`; `sol_membership_pct @0x8524`; difficulty `[0x53A6]`; owner `+0x1A` | SoL/rebel bar fill, colonist figures, "NN%/Tory" text |
| **`func_0275CE`** | **Production / commodity gauges** (raw 0..7, manufactured 8..15, then bells/crosses/food) | per-good production words near `[0x85C2]` | the **gauge bars** |
| **`func_027746`** | **Building grid / build-in-progress** | build target `+0x94`; building name; "X of Y" | building sprites + **"X of Y hammers" string** |
| (`func_026DD4`) | **Single stockpile/cargo cell** | warehouse level `+0x95`, `+0x96`; good idx | one cargo icon + count |
| (`func_0268CE`) | colony **title bar** | `+0x02` name, year, owner `+0x1A` | header text |

Key thunk resolutions: `0xb3c→0x9B9C` (compute_terrain_yield) · `0xc86→0x8524` (sol_membership_pct)
· `0xc0e→0x90C8` (worker→tile-slot byte `+0x20+i`) · `0xa74→0x91CC→0x9102` (colonist profession
byte `+0x40+i`) · `0x254→0xE76A` (5-arg sprite blit) · `0xce→0xE0A2` (rect/line) · `0x222→0x33F2`
(deferred bar-segment enqueue) · `0xce0→0x8956→0x8892` (worked-tile/unit lookup at (x−2,y−2)) ·
`0x7e0→0x66CC` (surround tile origin).

#### M1. Tile / worked-land production

`compute_terrain_yield` (`0x9B9C..0x9FFB`, spec/systems/colony.md §3):
```
yield = terrain_yield_table[terrain_id*16 + g]      # NAMES @UNFORESTED/@FORESTED, DGROUP:0x2F7B, @0x9C1E
if yield>0:
  adjacency nudge for g>=8 (manufactured): ±1/−2     @0x9C3E
  feature bumps (furs+feature, river bits)            @0x9C87
  tory_cnt = round(pop*(100−sol_pct)/100)             @0x9D14
  divisor  = (owner<4 && active) ? (10−difficulty[0x53A6]) : 10   @0x9D49
  yield   += −(tory_cnt/divisor)   (+1 rebel-majority, +1 unanimous latches)
  if colonist_skill(tile)==g:                         @0x9DAD
      g∈{Food0,Horses8}: yield+=2  else: yield*=2     @0x9DD2  (expert doubles manufactured)
  yield += feature_yield_bonus(resource,g)            @0x9AAA (penalty-resource ×2 else +bonus, ×2 if expert)
  if g>=8 && !building_bit(6): yield=0                @0x9F4F (needs the manufacturing building)
  if g==Furs4 && FF_op(8): yield*=2                   @0x9F83
yield = max(yield,0)
```
The centre-tile auto-production is the same call with the centre terrain; the colony centre always
yields food + the secondary good with no colonist.
**Reads:** `+0x00/+0x01` (x,y), worked-tile→colonist map `+0x20+i`, profession `+0x40+i`, `+0x8A`
building bitmap, difficulty `[0x53A6]`, SoL%. **Writes:** per-good accumulator summed by
`colony_turn_update` (`0xA222..0xA6A1`) into the 20-good array at `+0x9A`.
**→ Element:** `func_0264A8 @0x2669B` → per-tile **good icon** (`@0x2673E`/`@0x26758`) + **worker
figure** (`@0x2659F`/`@0x265BF`). Summed food feeds the plaza Food row.

#### M2. Building production

A colonist in a building converts input→output good using the same producer arithmetic, gated/scaled by:
- **building presence** — `if g>=8 && !building_bit(6)` (`@0x9F4F`) requires the building bit in `+0x8A`;
- **factory tier** — `count_building_chain_present @0x864E` walks the upgrade chain via
  `byte[idx*12+0x8F86]`; **count>2** (`@0x8EA9`) = factory ⇒ ×2 manufacturing;
- **Tory/SoL modifier** — `−(tory_cnt/(10−diff))` + rebel-majority/unanimous +1 latches.

**Reads:** `+0x8A`, `+0x40+i`, difficulty, SoL%. **Writes:** `+0x9A` 20-good array (Hammers 0x10→
`+0x92`/`+0xB6`, Crosses 0x11, Bells 0x12).
**→ Element:** `func_0275CE` draws each good's **gauge bar** via `0x181f:0x222`; Crosses & Bells get
their own (`@0x27688`/`@0x276C8`/`@0x27713`); stockpile totals `+0x9A` → warehouse cells (`func_026DD4`).

#### M3. Sons of Liberty / Tory

Display: `sol_membership_pct @0x8524`:
```
load s32 dividend [bx+0xC2]:[bx+0xC4]                @0x8531/0x8535
if [bx+0xC8]!=0 or [bx+0xC6]!=0:                      @0x8539 guard
    sol = (dividend*100)/divisor                      @0x8557/0x855E
if FF_op(0x12)[Jan de Witt] && owner<4 && human: sol += 20   @0x859C
sol = min(sol,100)                                   @0x85A8
```
Per-turn EMA (`func_02D658 @0x2DA1C`): `B−=B>>6; B=max(B,1); B+=2·pop`; `A+=new_bells−(A>>6);
A=clamp[0,B]` ⇒ steady-state **sol% ≈ 50·bells/pop**. `rebel = round(sol·pop/100)`; `tory = pop−rebel`.
**Reads:** `+0xC2/+0xC4` (rebel_dividend), `+0xC6`/`+0xC8` (divisor), `+0x1F` (pop), `+0x1A` (owner),
difficulty, FF bit 0x12.
**→ Elements (all `func_0270D0`):** SoL% / Tory **count text** (`@0x274EF`/`@0x27589`); bar/crown
**colour latches** (`bp-0x7c`: 0xF→4 when `rebelpct≤sol` `@0x27449`, →0xC when `2·rebelpct≤sol`
`@0x27458`); the **colonist left/right group split** (figure loop `@0x27186..0x272E7` uses
rebel/tory counts to set how many figures on each side).

#### M4. Construction / has_building

- **`has_building(n)`** — `func_0085B2 @0x85B2`: `bit = [ [0x8542]+0x8A + n/8 ] & (1<<(n&7))`. Persistent
  twin `+0x84` (`func@0x860E`, set by `func_0092E0 @0x9308`).
- **Completion** (`func_02D658`): hammer accrual `+0x92 += produced` (`@0x2E50F`); target `+0x94`
  (`@0x2E529`, `<0`=none); cost from BUILDING table `[0x8F8C]` (stride 12, 42 entries); gate
  `cost≤+0x92` (`@0x2E53B`); debit `+0xB6 −= cost`, **surplus carried** (`@0x2E6A7`); commit sets `+0x84`
  bit then mirrors to `+0x8A`. Upgrade chains via predecessor link `byte[idx*12+0x8F86]`; warehouse/
  capitol counters `+0x95`/`+0x96`.
**→ Element:** `func_027746` reads `+0x94` (`@0x2775D`) → in-progress building name + draws it, formats
**"X of Y hammers"** (`+0xB6` vs cost, `@0x27793`). Building grid is gated tile-by-tile on
`has_building` (`+0x8A`); `func_026DD4` reads `+0x95`/`+0x96` for warehouse-expansion sprites.

#### M5. Colonist assignment

Two parallel per-colonist arrays (length = pop `+0x1F`):
- **`+0x20+i` = work-location byte** — `func@0x90C8` (thunk `0xc0e`): which surround tile / building the
  colonist occupies (`i≥size` resolves an outside unit).
- **`+0x40+i` = profession/skill byte** — `func@0x9102` (via `0x91CC`/thunk `0xa74`): NAMES `@JOB`
  profession id; outside colonists fall back to `UnitRecord+0x315B` (`@0x9134`).

A colonist is **on a tile** if `+0x20+i` maps to a surround slot (`+0x70..+0x77`); else it occupies a
building. Iteration order via `func_025C32`.
**→ Element:** in `func_0264A8` the **profession picks which worker sprite** is blitted on each tile
(`@0x2659F`/`@0x265BF`); in `func_0270D0` the plaza loop resolves each profession (`@0x272CA`) to pick
the **plaza-occupant figure** (`@0x272E7`), positioned by the SoL split.

#### M6. Food / growth / starvation

Net food = produced − `pop·2`, accumulating into the **growth store `+0xC8`** (the `+200` growth constant
added `@0x2E098`). Growth path `func_00929A`: grow branch `@0x009432` fires only while `pop(+0x1F)<0x20`,
then `pop++` (`@0x009464`), `+0xC6 += 100` (`@0x009453`, bumps SoL divisor), posts `@NEWCOLONIST`. Food
cap base = 200 (`(+0x95+1)·100`, `func_008D00`); over-cap = spoilage.
**Reads:** `+0xC8` (food accumulator), `+0x1F` (pop ×2), `+0x95` (cap).
**→ Element:** the **Food gauge / net-food bar** — `func_0270D0` computes the running food balance into
`[bp-0x68] = size + [0x8d72]` (`@0x270EA`); the loop `@0x2710A..0x27143` sums per-tile food
(`es:[bx+si+0x3e]`), comparing against `0x60` (`@0x27170`) to decide how many food rows to fill; bar fill
colour `@0x2735E` (`0x4017`) shows surplus vs deficit (grow vs starve). The "X food → new colonist"
outcome is the `func_00929A` grow branch.

#### Caveats / TBD (mechanics)
- The **overlay-0x191F master** that calls these leaf renderers (and passes their screen-origin args
  `[0x83e]/[0x840]`, `[0x2da8..0x2dae]` clip rect) is **not in the extracted disassembly**; the leaf bodies
  are fully byte-present but their absolute on-screen pixel origins come from the un-extracted caller
  (per docs/COLONY_RENDER_CHAIN.md §6) — those literal X/Y bases are **TBD** for the gauge column
  `func_0275CE` and building grid `func_027746` (but resolved for `func_0264A8`/`func_0270D0`, §4).
- `sol_membership_pct` field-pair push order at `@0x8549` (`+0xC2/+0xC4` vs `+0xC6/+0xC8`) is worth one
  runtime confirmation; spec already flags the ambiguity.

---

## 7. The RNG and its EFFECT — why the building layout can't be matched statically

This is the crux of the "buildings are still wrong" loop, so it gets its own plain
explanation (the byte-level chain is in §6.3).

**The mechanism.** When the colony screen is entered, `func_025D34` lays out the 15 building
plots. The 15 plot *positions* are a fixed table (`DS:0x266`); the 15 plots are split into
**5 fixed category blocks** by counts `[7,4,2,1,1]` / bases `[0,7,11,13,14]` (`DS:0x224`/
`DS:0x22A`). Which building lands in which plot *inside its block* is decided by a
random-permutation:

```
seed   = (uint16)( (colony_y << 8) + colony_x + dword[0x8D80] )   ; func_009726
for each building i in its category block:
    slot = base[cat] + random_int(0, count[cat]-1)                ; MSC LCG, §6.3
    retry until an unused slot is found
```

**The decisive fact:** `dword[0x8D80]` — the base seed added to every colony's tile — is
written **exactly once**, `@0x075FF5`, from the **BIOS timer-tick counter at `0040:006C`**
(read via `func_00E4D2`). That is the **system clock at the moment the game starts**.

**What that means (the effect):**

- The base seed is a **random constant chosen once per game session**, not a fixed value and
  not zero. It is **not stored in the EXE** — it only exists in RAM while a game runs.
- Therefore the building layout is **deterministic *within* one game** — the same colony tile
  always lays out the same way for the rest of that session — but **differs every new game**,
  and **cannot be predicted or reproduced from static data**.
- So when you (the user) look at a real Jamestown, its exact arrangement is a function of the
  clock value when *that* game started. My earlier "computed layout" assumed `[0x8D80]=0`,
  which is why it doesn't match your screen — **not** because the algorithm is wrong (it's
  byte-exact), but because the one seed input is unknowable statically.
- **To match a specific real colony pixel-for-pixel you must supply the runtime seed**: dump
  the 4 bytes at `dword[0x8D80]` from the running game (or dump the already-resolved
  `0x8D62`/`0x8E82`/`0x8E92` tables, or watch the per-slot blit args at `@0x026EF7`). With the
  real `[0x8D80]`, re-running the loop above reproduces the layout exactly.

**What is still fully static (and *is* matched):** the 15 plot positions, the 5-category
block structure, the empty-lot frame per category (`DS:0x260=[45,44,43,0,46]`), and the
type→frame *base* table (`DS:0x2CA`). The only non-static pieces are (a) the permutation
order (this seed) and (b) the final building *sprite* frame, which `func_026CC2` resolves
from runtime per-colony production state (`0x8DC8[]`) — see §3.3 and §6.3.

---

## 8. Static vs runtime — the honest ledger

| element | static? | source / runtime site |
|---|---|---|
| 15 plot positions | **STATIC** | `DS:0x266` (file 0x1DC06) |
| 5 category blocks (counts/bases) | **STATIC** | `DS:0x224`/`DS:0x22A` |
| empty-lot frame per category | **STATIC** | `DS:0x260=[45,44,43,0,46]` |
| building type→frame *base* | **STATIC** | `DS:0x2CA` (file 0x1DC6A) |
| which building in which plot | **RUNTIME** | `func_025D34` RNG, seed `[0x8D80]` (BIOS clock) §7 |
| final building *sprite* frame | **RUNTIME** | `func_026CC2` reads `0x8DC8[]` production block |
| plaza element coords | **STATIC** | absolute screen coords, §4.1 |
| colonist figure frame | **RUNTIME** | per-colonist skill byte `+0x40+i` → ICONS frame |
| Food / Crosses / Bells counts | **RUNTIME** | `[0x8e0a]`/`[0x8dea]`/`[0x8dec]` (turn production) |
| SoL% / Tory / Rebel counts | **RUNTIME** | `0x181F:0xC86` (`+0xC2`/`+0xC6` bell EMA) |
| stockpile quantities | **RUNTIME** | `ColonyRecord +0x9A[]` |
| title string (name/season/year) | **RUNTIME** | loaded text heap + live colony fields |
| gold | **RUNTIME** | `PowerRecord +0x2A` (mirror `[0x9CB0]`) |

> The render can populate every **RUNTIME** row by running the headless `sim/` for one turn
> and reading the colony's state — that is the path to a fully faithful snapshot without a
> live DOS dump (except the `[0x8D80]` seed, which must come from the actual game).

---

## 9. Companion files

- `docs/COLONY_SCREEN_PANELS_DECOMPILE.md` — full per-function raw asm for §5 (the four bottom panels,
  title, menu) with complete block-by-block translation.
- `docs/COLONY_SCREEN_VICEROY_DECODE.md` — the earlier decode this file supersedes/consolidates
  (PIK raw-palette §5, icon base 0x16 §6, placement trace §12).
- `notes/rulings/RULINGS.md` — the far-ptr dispatch ruling and the 2026-06-22/23 sprite-role rulings.

---

*Sections 3–6.5 are assembled verbatim from five byte-verification passes over
`data_extracted/disassembly/VICEROY_annotated.asm` + `raw/COLONIZE/VICEROY.EXE`. This file is a
decode, not a render: every coordinate, frame, color, and table here is byte-cited to a `func_XXXX
@0xNNNN` / `DS:0xNNN` / thunk, or explicitly marked **RUNTIME/TBD** with the exact trace site. The two
load-bearing runtime unknowns — the building **placement permutation** (BIOS-clock seed `[0x8D80]`,
§7) and the final building **sprite frame** (`word[0x8DC8+idx*2]`, §3.5) — are the byte-level reasons
a specific real colony cannot be matched pixel-for-pixel from the EXE alone; everything else is static
and reproduced here.*
