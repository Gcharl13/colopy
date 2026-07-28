# Dialog Geometry — Byte-Cited Data Flow

> ⚠ **SUPERSEDED (2026-07-28).** §2 is built on a **misread**: it claims the function at
> `0x0C36:0x000A` (= file `0x00E76A`, thunk `0x181F:0x254`) *writes* the 4 stack args into
> `[bx+0]…[bx+6]` and calls its file offset "TBD" — but `func_00E76A` **reads** `[bx]`/`[bx+2]`
> (sprite w−1/h−1): it is "blit ONE sprite" (`render_primitives.md`), not a geometry writer.
> **Do not build from this file.** Authoritative: `spec/ui/dialog_framework.md`.


This document traces how the popup-window pixel rect at
`DGROUP:[0x839E..0x83A4]` is computed by VICEROY.EXE, citing every
file offset of the underlying assembly. It supersedes prior Python
renderers that hand-measured popup dimensions from DOSBox screenshots.

## The four globals

| Global | Role | Setter mechanism |
|--------|------|------------------|
| `[0x839E]` (word) | popup rect arg1 (x or x1) | written by overlay 0x0C36:0x000A via `BX` pointer |
| `[0x83A0]` (word) | popup rect arg2 (y or y1) | same |
| `[0x83A2]` (word) | popup rect arg3 (x2 or width) | same |
| `[0x83A4]` (word) | popup rect arg4 (y2 or height) | same |

These four words are NEVER written via direct `MOV [imm], reg` —
empirical confirmation from a byte-pattern scan of the entire EXE
returned 0 hits for `89 06 9E 83`, `C7 06 9E 83 ...`, or any other
direct-memory-write opcode. All updates flow through `LEA bx, [0x839E]`
followed by an indirect call into overlay-resident code.

## Setter chain

### 1. Compute-and-set wrappers (8 sites in load image / overlay)

`LEA bx, [0x839E]` followed by `LCALL` to the overlay setter. The 8
known sites are:

| File | Containing function | Adjacent LCALL target |
|------|---------------------|------------------------|
| `0x02648E` | (orphan / no enclosing func detected) | — |
| `0x067DFE` | `func_067DC8` (65 bytes) | `LCALL 0x181F:0x254` → `0x0C36:0x000A` |
| `0x067E18` | (orphan) | — |
| `0x067EC2` | `func_067E8C` (65 bytes) | (similar pattern) |
| `0x067EDC` | (orphan) | — |
| `0x075427` | `func_075352` (578 bytes — endgame/audience renderer) | (different LCALL) |
| `0x075499` | `func_075352` | (different LCALL) |
| `0x07608E` | `func_075FB6` (288 bytes) | (different LCALL) |

### 2. The setter overlay function: 0x0C36:0x000A

The function at overlay-segment 0x0C36 offset 0x000A receives:
- `BX` register = pointer to dialog struct (`&[0x839E]`)
- Stack arguments (4 words pushed in right-to-left order)
- Writes the 4 stack args into `[bx+0]`, `[bx+2]`, `[bx+4]`, `[bx+6]`,
  i.e. into `[0x839E]`, `[0x83A0]`, `[0x83A2]`, `[0x83A4]`.

Segment 0x0C36 has only 1 thunk reference and is NOT yet resolved in
`viceroy_source/overlay_directory.json`. The exact file-offset of this
function is therefore TBD (Day 6 work).

### 3. Reference: how `func_067DC8` computes the rect args

Cited line-by-line from
`code/VICEROY/disasm/func_067DC8_unknown.asm`:

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
067E02  LCALL  0x181F:0x254                ; call overlay 0x0C36:0x000A
067E07  LEAVE
067E08  RET
```

So when this code path runs:
- `[0x839E]` ← `[0xA5A4] + [0x1EA4] - 8`   (the X computed in `dx`)
- `[0x83A0]` ← `[0xA5A6] + [0x1EA5] - 0xF` (the Y computed in `cx`)
- `[0x83A2]` ← `cursor_x` from `[0x174]` (last PUSH cx)
- `[0x83A4]` ← `cursor_y` from `[0x176]` (PUSH dx)

(The exact arg→field assignment depends on the right-to-left push order
and the setter's stack layout. The setter implementation in segment
0x0C36 governs which arg lands in which field.)

## Upstream globals

The rect computation depends on these inputs. Their writers (where
known) are:

| Global | Role | Writer file offset |
|--------|------|---------------------|
| `[0x174]` (word) | cursor_x | `0x0765AC` (`A3 74 01` = `mov [0x174], ax`) |
| `[0x176]` (word) | cursor_y | `0x0765AF` (`89 16 76 01` = `mov [0x176], dx`) |
| `[0x1EA4]` (byte) | char_width_cols | NOT YET FOUND — set via indirection |
| `[0x1EA5]` (byte) | char_height_rows | NOT YET FOUND — set via indirection |
| `[0xA5A4]` (word) | font_cell_width | `0x068771` (`mov [0xA5A4], cx`) |
| `[0xA5A6]` (word) | font_cell_height | `0x06872C` (`mov [0xA5A6], ax`) |

The two byte fields at `[0x1EA4]/[0x1EA5]` carry the CHARACTER-GRID
dimensions of the dialog (number of columns × number of rows, parsed
from GAME.TXT `@width=NN` directives). Their setter is somewhere in
overlay code that hasn't been traced yet — likely the GAME.TXT
section parser. Day-5 follow-up.

## Implications for the Python renderers

`render_map_popup.py`, `render_dialog.py`, etc. currently emit
hardcoded `POPUP_X/Y/W/H` literals derived from pixel-measuring
DOSBox screenshots. The byte-cited replacement is:

```
# Pseudo-code for the renderer:
char_w = parse_game_txt_width(section)        # e.g. @width=78 → 78
char_h = count_body_lines(section)             # row count
cursor_x = ...                                 # game-state input
cursor_y = ...

font_cell_w = 8     # from [0xA5A4]; verify (TBD: writer not yet
                    # decoded but FONTTINY is 4×6 px so a glyph-cell
                    # of 8 is plausible)
font_cell_h = 8     # from [0xA5A6]

# Per func_067DC8 (file 0x067DC8..0x067E08):
dialog_x = font_cell_w + char_w - 8     # padding -8
dialog_y = font_cell_h + char_h - 0xF   # padding -15
dialog_x2 = cursor_x
dialog_y2 = cursor_y
```

**Status of this code-cited formula**: the formula is byte-cited
from `func_067DC8`; the values of `font_cell_w`, `font_cell_h`,
`char_w`, `char_h` are NOT yet known statically — they depend on
runtime state set by code that is partially undecoded (the
`[0x1EA4]/[0x1EA5]` byte writes).

## Day-5 next steps

1. Decode the function at overlay 0x0C36:0x000A (the setter). Need to
   resolve seg 0x0C36 to a file offset first (Day-1 follow-up).
2. Find the writer of `[0x1EA4]/[0x1EA5]`. Probably the GAME.TXT
   section parser (which reads `@width=NN` lines).
3. Resolve the actual font-cell-width/height values at startup. Probably
   set when the font is loaded (FF format, see `formats/FF.md`).
4. Replace `render_map_popup.py POPUP_X/Y/W/H` with the byte-cited
   formula, marking each literal with `# CITED: VICEROY file 0xNNNNNN`
   as the user-mandated rule.

## What this rules out

- The user's previous `POPUP_X=6, POPUP_Y=142, POPUP_W=210, POPUP_H=50`
  values were measured pixel-by-pixel from `b6235e.jpg` DOSBox capture.
  They are NOT in the binary. They are an OBSERVED OUTCOME of the
  formula above for one specific game state (specific cursor + char
  dims). For a different popup with different `@width` (e.g. @VICEROY
  with `@width=78` vs @KINGTAX with `@width=190`), the values would
  differ.
- Any "hand-tuned" geometry constants in the renderers should be
  removed and recomputed from the formula above with `# CITED:`
  comments pointing at this document.

## Open questions for downstream byte-tracing

- **Which call sites use which compute-formula?** The 8 LEA sites
  appear in 4 different functions (func_067DC8, func_067E8C,
  func_075352, func_075FB6) plus 3 orphan offsets. Each may compute
  the rect differently for its specific use case (king audience vs
  popup dialog vs map popup). Each formula should be documented
  separately if they differ.
- **Is `[0x186]` (the dialog-state flag) controlling whether the
  setter runs?** The `CMP [0x186], 0x64 / JL skip` pattern in
  func_067DC8 suggests yes — find what writes 0x186 to determine the
  trigger condition.
