# Dialog Text-Format Spec — Byte-Cited from VICEROY3.EXE.c

Extracted directly from the Ghidra decompile of VICEROY.EXE (`FUN_4000_bd23` at line 53021 and `FUN_4000_d367` at line 54127). NO guessing — these are literal control-character handlers in the binary.

## Text-line renderer: `FUN_4000_bd23(char *str, undefined2 seg, int *cursor_x_ptr)`

The function walks the string character by character. For each char:

| Char | What VICEROY does |
|---|---|
| `\0` | Return (end of line) |
| `{` | Set `DAT_0000_1f62 = 1` → highlight color (yellow) for following chars |
| `}` | Set `DAT_0000_1f62 = 0` → back to body color (green) |
| `|` | Return (line break / end of segment) |
| `~` | Call `FUN_4000_bce1()` (palette swap), advance past the `~`, then `FUN_1000_83ea()` measures+blits the NEXT char with highlight applied. **Single-char accelerator** — only the char AFTER `~` is highlighted. |
| other | `FUN_1000_83ea()` measures+blits at current cursor, advances cursor |

The `cursor_x_ptr` (`int *param_3`) is passed by reference — VICEROY ADVANCES IT as each char is drawn. So sequential calls keep moving the cursor along the line.

## Highlight-color flag

`DAT_0000_1f62` (word) is the runtime flag for "use highlight color":
- `0` = body (green)
- `1` = highlight (yellow) — set when char is inside `{...}` or after `~`
- `2` = (seen via `*(uint *)&DAT_0000_1f62 = *uStack_12 & 2;` at line 54157) — set when a tree node's flag-bit-1 is set, used for selected option highlighting

## Dialog tree-walker: `FUN_4000_d367(dialog_struct *param_1)`

Walks a linked list of tree nodes. Each node:

| Offset | Field | Notes |
|---|---|---|
| `+0x00` | flag byte | bit 1 (mask 0x02) → set selected-option highlight flag in DAT_1f62 |
| `+0x06` | (unknown, checked against 0 at line 54167) | |
| `+0x08` | far ptr to text string (lo) | the body line of this row |
| `+0x0A` | far ptr to text string (hi seg) | |
| `+0x10` | far ptr to next sibling (lo) | linked-list pointer |
| `+0x12` | far ptr to next sibling (hi seg) | |

## Dialog struct layout (param_1 to FUN_4000_d367 / FUN_4000_d809)

| Offset | Field | Notes |
|---|---|---|
| `+0x0a` | flags byte | bit 2 (0x04) → highlight selected option |
| `+0x4c`, `+0x4e` | selection-anchor pointer (lo, hi seg) | what's currently selected |
| `+0x50`, `+0x52` | cursor X, Y | seeded by FUN_4000_dd49 (x, y) |
| `+0x54`, `+0x56` | tree head ptr (lo, hi seg) | head of body-text linked list |
| `+0x60`, `+0x62` | second tree ptr (lo, hi seg) | options/buttons linked list? |
| `+0x74` | cursor X (advanced per char) | passed by ref to FUN_4000_bd23 |
| `+0x80`, `+0x82` | cursor-restore source ptr (lo, hi seg) | for backing up cursor between lines |

## Implications for the Python renderer

### Currently WRONG in tools/render_modal.py

1. **`~` is stripped, not highlighted.** Per the binary, `~G` in `~GAME` should render `G` in yellow (the accelerator letter for the keyboard shortcut). My code at line 652 just strips it. Need to handle: when `~` is seen, render the NEXT char in highlight color, then continue body.

2. **`|` not handled.** Per the binary, `|` means RETURN (end the line / segment). My code probably ignores it. Some popups may have `|` in body lines as a layout marker.

3. **`{...}` partial — already handled** (per earlier fix), green outside / yellow inside. Confirmed correct by binary.

4. **Selected-option highlight color is DIFFERENT.** DAT_1f62 value 2 (per line 54157) means a tree node flagged for selection. This is a third color (probably bright yellow or with inverse video). My current code uses the same yellow as `{...}` highlight.

### What this tells us about layouts (NOT in this doc — separate question)

The cursor position when `FUN_4000_dd49` is called sets where the dialog starts drawing. That call site is in event-specific handlers (per-popup setup code). To get per-popup (x, y) we still need to trace each event handler — that's the missing piece.

But the TEXT-FORMAT rules above are now 100% byte-cited and apply to every popup.
