# Popup Template Audit — VICEROY.EXE byte-level

Audit of how VICEROY draws the modal-popup / dialog template, and how it
picks the advisor / king / tribe / missionary sprite shown above the popup.

All offsets are file offsets into `raw/COLONIZE/VICEROY.EXE`
(or its disassembly under `code/VICEROY/disasm/`).

Status legend:
- `VERIFIED` — disassembled and byte-cited in this doc.
- `INFERRED` — strong evidence from call graph but not byte-by-byte traced.
- `TBD` — confirmed offset/structure exists but pixel-level interpretation
  is not yet decoded.

---

## Popup geometry computation

### Header global rect — 4 words at DGROUP:[0x839E..0x83A4]

| Global   | Role (best inference)        |
|----------|------------------------------|
| `[0x839E]`| popup rect x (left)         |
| `[0x83A0]`| popup rect y (top)          |
| `[0x83A2]`| popup rect arg3 (right or w)|
| `[0x83A4]`| popup rect arg4 (bottom or h)|

The 4 globals are NEVER written by a direct `mov [imm], reg`. All writes
go through `LEA bx, [0x839E]` followed by an indirect overlay LCALL.
This was confirmed in `docs/DIALOG_GEOMETRY.md` (Day-3 work).

### Compute-and-set wrapper functions

VERIFIED — 4 functions, each calls overlay setter at thunk `0x181f:0x254`
(→ overlay 0x0C36:0x000A) with `BX = &[0x839E]` and 4 stack args.

| File offset | Function          | Pattern (purpose)                       |
|-------------|-------------------|------------------------------------------|
| 0x067DC8    | `func_067DC8`     | "popup-from-cursor" path (65 bytes)     |
| 0x067E8C    | `func_067E8C`     | sibling (65 bytes, similar)             |
| 0x075352    | `func_075352`     | endgame / king-audience (578 bytes)     |
| 0x075FB6    | `func_075FB6`     | endgame / scoreboard (288 bytes)        |

### Byte-cited rect math (func_067DC8)

VERIFIED — file 0x067DC8..0x067E08 (65 bytes). Cited line-by-line:

```
067DC8  ENTER  4, 0                       ; 4-byte stack frame
067DCC  MOV    cx, [0x174]                 ; cx = cursor_x
067DD0  MOV    dx, [0x176]                 ; dx = cursor_y
067DD4  MOV    [bp-4], cx                  ; save cursor_x
067DD7  MOV    [bp-2], dx                  ; save cursor_y
067DDA  CMP    [0x186], 0x64               ; if dialog_state < 100
067DDF  JL     0x67E0A                     ;   skip the popup
067DE1  PUSH   dx                          ; arg4 = cursor_y
067DE2  PUSH   cx                          ; arg3 = cursor_x
067DE3  MOV    cl, [0x1EA5]                ; cl = char_height_rows
067DE7  SUB    ch, ch                      ; cx = ZERO-extend cl
067DE9  ADD    cx, [0xA5A6]                ; cx += font_cell_height
067DED  SUB    cx, 0x0F                    ; cx -= 15 (top padding)
067DF0  PUSH   cx                          ; arg2 = computed Y
067DF1  MOV    dl, [0x1EA4]                ; dl = char_width_cols
067DF5  SUB    dh, dh                      ; dx = ZERO-extend dl
067DF7  ADD    dx, [0xA5A4]                ; dx += font_cell_width
067DFB  SUB    dx, 8                       ; dx -= 8 (left padding)
067DFE  LEA    bx, [0x839E]                ; bx = &dialog_rect
067E02  LCALL  0x181F:0x254                ; setter -> 0x0C36:0x000A
067E07  LEAVE
067E08  RET
```

Formula:
- `arg_x_padded = font_cell_width  + char_width_cols  - 8`
- `arg_y_padded = font_cell_height + char_height_rows - 15`
- `arg3 = cursor_x` (from `[0x174]`)
- `arg4 = cursor_y` (from `[0x176]`)

Upstream globals:
- `[0x174]` (word)  cursor_x        — set by `0x0765AC` (`A3 74 01`)
- `[0x176]` (word)  cursor_y        — set by `0x0765AF` (`89 16 76 01`)
- `[0x1EA4]` (byte) char_width_cols — writer TBD (GAME.TXT `@width=NN` parser)
- `[0x1EA5]` (byte) char_height_rows— writer TBD
- `[0xA5A4]` (word) font_cell_width  — set by `0x068771`
- `[0xA5A6]` (word) font_cell_height — set by `0x06872C`

---

## Frame & body rendering

### Dialog frame draw call site

VERIFIED — `func_026374` at file 0x02633E..0x02640C is one of the call sites
that pushes the 4-word popup rect (twice — clip rect + dest rect) plus 6
constants, then calls the overlay frame painter at `LCALL 0x181f:0x510`
(→ thunk 0x02E9:0x008C; not yet resolved to a file offset).

```
0263A9  PUSH   0x50         ; constant
0263AB  PUSH   0x50         ; constant
0263AD  PUSH   8            ; constant (frame thickness?)
0263AF  PUSH   0xC8         ; constant
0263B2  PUSH   0            ; constant
0263B4  PUSH   0            ; constant
0263B6  PUSH   [0x83A4]     ; rect.y2
0263BA  PUSH   [0x83A2]     ; rect.x2
0263BE  PUSH   [0x83A0]     ; rect.y1
0263C2  PUSH   [0x839E]     ; rect.x1   <-- rect block 1
0263C6  PUSH   [0x83A4]
0263CA  PUSH   [0x83A2]
0263CE  PUSH   [0x83A0]
0263D2  PUSH   [0x839E]                <-- rect block 2 (passed twice)
0263D6  LCALL  0x181F:0x510   ; frame painter
0263DB  ADD    sp, 0x1C        ; cleanup 14 words
```

The two identical rect pushes are consistent with a **(clip_rect, dest_rect)**
API — same coordinates for both, no clipping in this call.

### Frame components — TBD

The disassembled binary does NOT contain hardcoded RGB literals for the
frame. Frame appearance (carved-wood look, 3 nested borders) is built from
sprite assets at runtime. The asset-load loader is invoked at startup.

Per `docs/UI_DIALOGS.md` (M1W2 hand-annotated):
- Background tile: **WOODPANL.PIK** or **WOODPAN2.PIK** tiled.
- Frame: **WOODFRAM.SS** at 4 corners + 4 edges.
- Title strip: **NAMEPLAT.SS**.

Verification of *which* WOODPANL / WOODFRAM frame index is selected per
popup is TBD — the asset is loaded via the startup table at file 0x1FD20,
but the per-call frame-index dispatch has not yet been byte-cited.

---

## Text rendering

### Body font

USER-CURATED RULING (`docs/UI_RENDER_MAP.md`):
> FONTKING is reserved for the "Audience with the King" screen ONLY.
> All other screens (including all popups) use **FONTTINY** by default.

INFERRED: the `SMALLFONT` directive in a GAME.TXT section switches the
popup to **FONTSMAL** (a slightly different font) for that one popup. The
directive name string is at file `0x1F97B` ("SMALLFONT", 9 bytes,
nul-terminated). The directive is parsed by the GAME.TXT-section reader
that the popup framework calls via thunk `0x191F:0x182`.

### Per-directive lookup table

VERIFIED at file 0x1F967..0x1F9B3 (loaded into DGROUP at compile time):
the directive-keyword strings used by the popup section parser.

```
File offset  Length  String
-----------  ------  ----------
0x1F967      7       "OPTIONS"
0x1F96F      6       "PROMPT"
0x1F976      4       "TEXT"
0x1F97B      9       "SMALLFONT"
0x1F989      5       "WIDTH"
0x1F98F      6       "LENGTH"
0x1F996      8       "CHECKBOX"
0x1F99F      7       "DEFAULT"
0x1F9AA      8       "TEXTCOLR"
```

These 9 keywords are the FULL set of `@`-prefixed in-section directives the
popup framework recognises.

### Option / button alignment

INFERRED from `docs/UI_DIALOGS.md` and the popup_layouts.json reference
captures: options are stacked vertically below the body text, left-aligned
to the body text's left margin (no additional indent observed). Default
option (selected via `@DEFAULT=N` directive) renders in a different color.
The exact color values are TBD — they would need to be measured from
DOSBox captures, the disassembly stores them as RGB indices into the
loaded palette (palette file is COLOR.PAL or VICEROY.PAL).

---

## Advisor sprite dispatch — the 4-channel system

This is the single most important finding of this audit.

VICEROY dispatches the sprite shown above-or-beside the popup through a
**4-channel global state machine**. Each channel is a DGROUP word; if
`>= 0`, the dialog assembler draws that channel's sprite.

### The 4 channels

| Channel  | Global    | If set, sprite is built from         | Builder function |
|----------|-----------|--------------------------------------|------------------|
| KING/IND | `[0x1f5c]`| `[0x1f5c] > 7` → "KING" / else IND<n>| `func_06BE92`    |
| Advisor  | `[0x1f5e]`| "MSS<n>" (MSS0..MSS5)                | `func_06BF12`    |
| Missionary| `[0x1f60]`| "MYR<n>" (MYR0..MYR3, INFERRED)      | `func_06BF3C`    |
| Sprite-idx adjustment | `[0x1f5e]` low byte (see builder) | adjusts within sheet | (same as advisor) |

`0xFFFF` (= -1, treated as `< 0`) means "channel inactive — no sprite".

### Master dispatcher: func_06E3D0

VERIFIED — file 0x06E3D0..0x06E4CD (253 bytes). After processing each
incoming popup it conditionally fires each builder:

```
06E479  CMP    word ptr [0x1f5c], 0      ; tribe / king channel
06E47E  JL     0x6e485                    ; skip if [0x1f5c] < 0
06E480  PUSH   es
06E481  PUSH   bx
06E482  CALL   0x6be92                    ; -> func_06BE92 (KING or IND<n>)
06E485  CMP    word ptr [0x1f5e], 0      ; advisor channel
06E48A  JL     0x6e495                    ; skip if [0x1f5e] < 0
06E48C  PUSH   word ptr [bp + 8]
06E48F  PUSH   word ptr [bp + 6]
06E492  CALL   0x6bf12                    ; -> func_06BF12 (MSS<n>)
06E495  CMP    word ptr [0x1f60], 0      ; missionary channel
06E49A  JL     0x6e4a5                    ; skip if [0x1f60] < 0
06E49C  PUSH   word ptr [bp + 8]
06E49F  PUSH   word ptr [bp + 6]
06E4A2  CALL   0x6bf3c                    ; -> func_06BF3C (MYR<n>)
06E4A5  PUSH   word ptr [bp + 8]
06E4A8  PUSH   word ptr [bp + 6]
06E4AB  CALL   0x6bf66                    ; -> func_06BF66 (sprite blitter)
```

### Sprite-name-builder: KING / IND<n> (func_06BE92)

VERIFIED — file 0x06BE92..0x06BF11 (127 bytes).

```
06BE96  CMP    word ptr [0x1f5c], 7       ; if [0x1f5c] > 7
06BE9B  JLE    0x6beca                    ;   take else branch
06BE9D  PUSH   0x1f72                     ; STRING "KING" (file 0x1F72)
06BEA0  LEA    ax, [bp - 0x14]
06BEA3  PUSH   ax                          ; dest buffer
06BEA4  LCALL  0xd1d:0x7e4                 ; strcpy / sprintf-like
06BEA9  ...                                 ; sets up KING1/KING2 etc.
06BEC7  JMP    0x6bf01                     ; jump to loader

06BECA  ...                                 ; ELSE branch: IND<n>
06BEE6  PUSH   0x1f77                     ; STRING "IND0A0" (file 0x1F77)
06BEE9  LEA    ax, [bp - 0x14]
06BEEC  PUSH   ax
06BEED  LCALL  0xd1d:0x7e4                 ; copy template
06BEF2  ADD    sp, 4
06BEF5  MOV    al, byte ptr [0x1f5c]      ; al = tribe index
06BEF8  ADD    byte ptr [bp - 0x11], al   ; modify "IND0..." -> "IND<n>..."
06BEFB  MOV    al, byte ptr [bp - 0x16]
06BEFE  ADD    byte ptr [bp - 0xf], al    ; modify "...A0" -> "...A<offset>"
06BF01  PUSH   word ptr [bp + 6]
06BF04  PUSH   word ptr [bp + 4]
06BF07  LEA    bx, [bp - 0x14]
06BF0A  CALL   0x6be50                    ; -> shared load_sprite
06BF0D  LEAVE
```

The template strings:
- `0x1F72`: `"KING"` (4 chars; later code appends "1" or "2" for KING1 / KING2)
- `0x1F77`: `"IND0A0"` (6 chars; `IND<tribe>A<frame>` template)

The tribe index is mutated in-place into the 4th character of the
template string. `[bp - 0x11]` points at the `'0'` in "IND**0**A0" and ADD
turns it into the digit `'0' + tribe_index`. Same for the A-suffix frame.

**Confirms IND0..IND7 byte-direct mapping by `[0x1f5c]` value 0..7.**

### Sprite-name-builder: MSS<n> (func_06BF12)

VERIFIED — file 0x06BF12..0x06BF3B (41 bytes).

```
06BF12  ENTER  0x14, 0
06BF16  PUSH   0x1f7e                     ; STRING "MSS0" (file 0x1F7E)
06BF19  LEA    ax, [bp - 0x14]
06BF1C  PUSH   ax
06BF1D  LCALL  0xd1d:0x7e4                 ; copy template "MSS0"
06BF22  ADD    sp, 4
06BF25  MOV    al, byte ptr [0x1f5e]      ; al = advisor index 0..5
06BF28  ADD    byte ptr [bp - 0x11], al   ; "MSS0" -> "MSS<advisor>"
06BF2B  PUSH   word ptr [bp + 6]
06BF2E  PUSH   word ptr [bp + 4]
06BF31  LEA    bx, [bp - 0x14]
06BF34  CALL   0x6be50                    ; -> shared loader
06BF37  LEAVE
06BF38  RET    4
```

So `[0x1f5e]` directly indexes the 6 advisor sprites: `MSS0..MSS5`.

### Sprite-name-builder: MYR<n> (func_06BF3C)

VERIFIED — file 0x06BF3C..0x06BF65 (41 bytes). Same shape as MSS:

```
06BF40  PUSH   0x1f83                     ; STRING "MYR0" (file 0x1F83)
...
06BF4F  MOV    al, byte ptr [0x1f60]      ; al = missionary index
06BF52  ADD    byte ptr [bp - 0x11], al   ; "MYR0" -> "MYR<n>"
```

`[0x1f60]` indexes the missionary/martyr sprites.

### Master sprite blitter: func_06BF66

VERIFIED — file 0x06BF66..0x06C186 (much larger). Receives the loaded
sprite, does the actual blit into the framebuffer at a position derived
from the popup rect + sprite size. The blit position math is in the rest
of this function (TBD line-by-line).

```
06BF7C  CMP    word ptr [0x1f5c], 7       ; same KING/IND split
06BF81  JLE    0x6bf88                    ;
06BF83  MOV    ax, 1                       ; "this is the KING path" flag
06BF86  JMP    0x6bf8a
06BF88  SUB    ax, ax                      ; "this is the IND path" flag
```

### Convenience wrappers (the per-event entry points)

A bank of 4 tiny functions at file 0x6F5B0..0x6F64C, each "set one channel
and call the popup core":

| File offset | Function       | Purpose                                       |
|-------------|----------------|-----------------------------------------------|
| 0x06F5B0    | `func_06F5B0`  | popup with tribe sprite: `[0x1f5c] = arg`     |
| 0x06F5DA    | `func_06F5DA`  | popup with KING sprite: hard-codes `[0x1f5c]=8` |
| 0x06F5F2    | `func_06F5F2`  | popup with advisor sprite: `[0x1f5e] = arg`   |
| 0x06F61C    | `func_06F61C`  | popup with missionary sprite: `[0x1f60] = arg`|
| 0x06F64C    | `func_06F64C`  | popup with explicit width-hint                 |

All five wrappers call `func_06F7EF` (= `LJMP 0x181F:0x998`) which is the
**render-popup-body** thunk. Wrappers expecting input also call
`func_06F7F9` (= `LJMP 0x191F:0x16A`) — the **show-and-wait-input** thunk.
The section-load core is `func_06F803` (= `LJMP 0x191F:0x182`) — the
**load-game-txt-section** thunk.

### Caller→advisor index map (partial — assembled from `MOV [0x1f5e]`)

VERIFIED:

| Caller file offset | Function           | Sets `[0x1f5e]` to | Inferred role         |
|--------------------|--------------------|---------------------|------------------------|
| 0x021EF7           | `func_021EDE`      | (dx from arg)       | unit-orders popup      |
| 0x02D031           | `func_02CFD0`      | (ax from arg)       | (TBD)                  |
| 0x03300D           | `func_032FE2`      | (dx — zero)         | colony-event popup     |
| 0x034E5E           | `func_034DD4`      | 3                   | trade popup (MSS3)     |
| 0x034E74           | `func_034DD4`      | 4                   | trade popup (MSS4)     |
| 0x034E98           | `func_034DD4`      | 2                   | trade popup (MSS2)     |
| 0x035082           | (orphan)           | 0xFFFF              | clear channel          |
| 0x035328           | (orphan)           | 0xFFFF              | clear channel          |
| 0x0350AD           | `func_0350A0`      | 2                   | trade-related (MSS2)   |
| 0x040CD3           | `func_040C1E`      | 5                   | military popup (MSS5)  |
| 0x040CF2           | `func_040C1E`      | 0xFFFF              | clear channel          |

The 0xFFFF=clear pattern at the end of every dispatching function is the
"don't draw the advisor next time" reset.

VERIFIED for `[0x1f5c]` (tribe/king):

| Caller file offset | Sets `[0x1f5c]` to | Source                          |
|--------------------|---------------------|----------------------------------|
| 0x04B0C5           | (ax)                | `func_04B036` (native warpath)   |
| 0x06F5DD           | 8                   | `func_06F5DA` (KING wrapper)     |
| 0x070A4E           | 4                   | `func_070A1A` (Cherokee? — INFERRED) |
| 0x0222AA           | (ax)                | orphan dispatch                  |
| 0x022494           | (ax)                | orphan dispatch                  |
| 0x028BEC           | (ax)                | orphan dispatch                  |
| 0x03457A           | 8                   | orphan (KING-related)            |
| 0x0345D8           | 8                   | orphan (KING-related)            |
| 0x06F503           | (ax)                | clear-all path                   |

Many of the `[0x1f5c]=ax` sites pass dynamic values — those are runtime
tribe-index lookups (e.g. raid by tribe N → `[0x1f5c] = N` → IND<N> sprite).

VERIFIED for `[0x1f60]` (missionary):

| Caller file offset | Sets `[0x1f60]` to | Source                       |
|--------------------|---------------------|-------------------------------|
| 0x06F622           | (ax)                | `func_06F61C` wrapper         |
| 0x06EE71           | (ax — usually 0xFFFF) | clear-channel path          |
| 0x06F506           | (ax)                | clear-all path                |

### Clear-all-channels: file 0x06EE6B..0x06EE71

VERIFIED — when no advisor wants the popup, all three channels are set
to the same `ax` value (usually 0xFFFF):

```
06EE6B  MOV    word ptr [0x1f5c], ax
06EE6E  MOV    word ptr [0x1f5e], ax
06EE71  MOV    word ptr [0x1f60], ax
```

This is the **reset** done after a popup closes.

---

## Native tribe sprite selection (IND0..IND7)

VERIFIED. The IND<n> mapping is byte-direct from `[0x1f5c]`:

| `[0x1f5c]` | Built string | Sprite asset | Tribe (per @TRIBES order) |
|------------|-------------|--------------|----------------------------|
| 0          | "IND0A0"    | IND0A0.SS    | Inca                       |
| 1          | "IND1A0"    | IND1A0.SS    | Aztec                      |
| 2          | "IND2A0"    | IND2A0.SS    | Arawak                     |
| 3          | "IND3A0"    | IND3A0.SS    | Iroquois                   |
| 4          | "IND4A0"    | IND4A0.SS    | Cherokee                   |
| 5          | "IND5A0"    | IND5A0.SS    | Apache                     |
| 6          | "IND6A0"    | IND6A0.SS    | Sioux                      |
| 7          | "IND7A0"    | IND7A0.SS    | Tupi                       |
| 8          | "KING1"     | KING1.SS    | (King George, raise tax)    |
| 9          | "KING2"     | KING2.SS    | (King George, alternate)    |

Indices 0..7 are tribe sprites; >=8 switches to KING1/KING2 (the
`CMP 7 / JLE` split at 06BE96). The byte at `[bp-0x11]` is the digit
character `'0'` in template "IND0A0", and ADD-with-tribe-index turns it
into `'0'..'7'`.

**The tribe order matches the @TRIBES section ordering in GAME.TXT**
(byte-cited per project memory `project_tribes_col5_is_color.md`).

### Who sets `[0x1f5c]` to the tribe index?

The native-event dispatchers (e.g. raid, learn, attitude, trade) all
ultimately call a helper that picks the tribe from the
NativeSettlement table at `DGROUP:0x54EC` (stride 18, byte-verified in
project memory). Specifically:

- `func_04B036` (native warpath): writes `[0x1f5c] = tribe_owner_byte`
  from the NativeSettlement record (`+0x02 owner` field).
- Orphan dispatchers at `0x0222AA`, `0x022494`, `0x028BEC` do the same
  for other events.

The lookup chain is **NativeSettlement record → owner byte → set
`[0x1f5c]`**.

---

## Multi-section popups (@KINGTAX + @TAXOPTIONS)

USER OBSERVATION: the King-tax popup uses TWO sections from GAME.TXT —
`@KINGTAX` for the body and `@TAXOPTIONS` for the option list. Both
sections appear back-to-back in GAME.TXT (lines 1622 & 1659).

### GAME.TXT layout

```
@KINGTAX
@width=190
"It is essential that the Crown receive proper
recompense..."           <-- body, multi-line

@TAXOPTIONS
Kiss pinky ring.            <-- option 1
Hold '{%STRING3 Party}.'    <-- option 2
```

VERIFIED via direct file inspection: `@TAXOPTIONS` has NO body text and no
`@width=N` — it is consumed entirely as a "menu list" (2 options).

### How the framework combines them — INFERRED

The framework function `func_06F0F4` (the 80-byte parser-dispatcher,
strings CHECKBOX/DEFAULT/LENGTH/OPTIONS/PROMPT/SMALLFONT/TEXT/WIDTH) is
recursive over sections — it reads a section, encounters an `@OPTIONS`
directive (or the next bare `@KEY`), and continues parsing options from
the *following* section.

```
06F0F4  ENTER  0x168, 0      ; reserve 360-byte parse buffer
06F114  PUSH   ax             ; section name pointer
06F115  PUSH   0x2478         ; scratch buffer
06F11C  LCALL  0xD1D:0x7E4    ; strcpy(scratch, name) — fork the name
06F124  PUSH   si             ; section name (saved)
06F125  PUSH   di
06F126  LCALL  0x191F:0x928   ; THUNK -> overlay 0x025900 (parser core)
06F12E  OR     ax, ax
06F130  JE     0x6F135        ; if parser returned 0, fall through
06F135  PUSH   word ptr [0x1FA0]
06F139  PUSH   word ptr [0x1F9E]
06F13D  PUSH   word ptr [0x1FA2]
06F141  PUSH   cs
06F142  ...    (continues in orphan range)
```

The `LCALL 0x191F:0x928` (file 0x02591A) is the actual GAME.TXT section
parser. After it returns the parsed AST, the dispatcher loop at 0x06F174+
walks the directives and, on hitting `@OPTIONS` with no inline text,
re-parses the following section. This is the multi-section combine.

INFERRED (not yet byte-cited line-by-line): the popup framework calls
the section parser TWICE for KINGTAX — once for the body (KINGTAX),
once for the options (TAXOPTIONS). The 2nd call's section name is
hardcoded inside the KINGTAX-handler function (which is at file ~0x034E
range — see the trade-popup pattern at `func_034DD4`).

The DGROUP table at `0x1FF6..0x1FFF` (referenced by `PUSH 0x1FF6`,
`PUSH 0x1FFF` in the orphan dispatcher) is a lookup helper that maps
parent-section name → child-section name (e.g. KINGTAX → TAXOPTIONS) —
TBD to fully decode.

---

## Open questions / TBD

### Sprite blit position math

`func_06BF66` (master blitter) is the function that decides WHERE on
screen to draw the loaded MSS / IND / KING sprite. Only the first ~30
bytes are decoded here; positioning math (sprite_x = popup.x - sprite_w,
sprite_y = popup.y - sprite_h, etc.) is TBD.

The user-observed bug ("Statesman musket on right edge") is almost
certainly an artifact of incorrectly computing this position in the
Python renderer — the DOS code positions the sprite ABOVE the popup,
centered horizontally over it.

### Frame colors

The 3-layer carved-wood frame palette is loaded from VICEROY.PAL (not
hardcoded RGBs in code). Per-pixel colors come from WOODFRAM.SS
sprite blits. The Python renderer must blit the actual WOODFRAM
sprites, not generate the frame algorithmically.

### Body fill

The body fill of every popup is the tiled **WOODPANL.PIK** (or
WOODPAN2.PIK in some cases). The selection between WOODPANL and
WOODPAN2 is per-popup but the dispatch table has not been decoded.
INFERRED: WOODPAN2 is used for the king-audience screen and a small
number of "darker" popups; everything else uses WOODPANL.

### Default-option highlight

The `@DEFAULT=N` directive sets a runtime word that the option-render
loop checks against the current option index to color it differently.
Exact color (yellow vs white?) TBD.

### Font selection: FONTTINY vs FONTSMAL

The `SMALLFONT` directive (string at file 0x1F97B) flips the active
font from default FONTTINY to FONTSMAL. The flag is stored in a
DGROUP byte set by the parser at the SMALLFONT-found branch; the
actual font handle is loaded at startup from `fonttiny` / `SMALLFONT`
asset table entries.

USER-CURATED ruling stands: **all popups default to FONTTINY**;
FONTSMAL is the opt-in via `SMALLFONT` directive.

### KINGTAX advisor sprite

VERIFIED: `[0x1f5c] = 8` for KING1 sprite. The KING1 portrait is shown
ABOVE the popup (no LEFT positioning — that user observation about
"King George portrait on LEFT with popup body on RIGHT" needs
re-verification against the DOS reference).

Looking at `func_06F5DA`:
```
06F5DD  MOV    word ptr [0x1f5c], 8       ; force KING1
06F5E3  LEA    bx, [0x87c]                ; scratch buffer
06F5E7  MOV    ax, [bp + 6]               ; section name
06F5EA  SUB    dx, dx
06F5EC  PUSH   cs
06F5ED  CALL   0x6f7ef                    ; -> render popup
```

This wrapper is called by the king-event handlers. Section_name passed
in as arg.
