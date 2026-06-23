# VICEROY.EXE — Resident UI Draw-Primitive Vocabulary ("Rosetta Stone")

> **Scope.** The resident (load-image) UI primitives reached from screen code via
> `LCALL 0x181F:NNN`. Every screen-transcription depends on knowing whether a
> given `0x181F:NNN` call **fills a rectangle**, **fills a colored span**,
> **blits one sprite**, **tiles a sprite strip**, **centers text**, **draws text
> at x,y**, **measures a string**, or merely **enqueues / waits**. This document
> distinguishes those, byte-by-byte.
>
> **cite-or-stop.** Every claim below is read from
> `raw/COLONIZE/VICEROY.EXE`
> (494,910 bytes, sha256 `a17ed64c27671e5e95236e54a7ddc85803a96ba822fbed05e1dad34d3917e2e3`)
> and the per-function disassembly in
> `code/VICEROY/disasm/`. `codeOffset = 0x2400`,
> `DGROUP` base `0x1D9A0`. Items not byte-confirmed are flagged
> **NEEDS VERIFICATION**. Nothing here is guessed.

---

## 0a. Shared WIDGETS — cross-screen "recognize once" index (2026-06-23)

Several `0x181F:NNN` verbs are not one-screen helpers but **reusable UI widgets**: the
same routine renders the "same kind of thing" on many screens. Recognise these once and
**cite the verb** instead of re-deriving a per-screen mechanism (this is the lesson from the
"is the bell row a fill bar?" trap — it is the shared `0x236` indicator, not CC-specific).

| verb | widget | screens / call sites that use it |
|------|--------|----------------------------------|
| **0x236** `func_002EE4` | **proportional filled/empty icon strip** (count fitted to a fixed span; pitch `(span−w)/(count−1)` clamped `[1,w+1]`; overlaps when count large) — §0x236 | colony field-production yields (`@0x02665D/8A/0x026700`), colony building indicator (`@0x026EF7`), colony bottom panel (`@0x027CCC`), **F2 Religious crosses** (`@0x0379B4`, filled `0x39`), **F3 CC bells** (`@0x037BF5`, filled `0x3F`) — **7 sites** |
| **0x2BC** `func_00386A` | **per-unit info panel** (UnitRecord-indexed: icon + colour-span stat bars + text) — §0x2BC | Europe ship-status row (`@0x0313C2`) + in-port unit (`@0x031A6E`), colony field/plaza/SoL panels (`@0x026639/0x02794A/0x028058`), **F6 Colony** (`@0x039297`) + **F7 Naval** (`@0x039586`), popup/menu engine (`@0x06DF9E`) — **20 sites** |
| **0x222 + 0x22C** `func_0033F2`/`func_003104` | **enqueue row item → flush a centred icon+value+colour row** (the three parallel accumulators `[0x2CCE]/[0x2CE2]/[0x2CF4]`) — §0x222/§0x22C | colony panels (`@0x0273D7/0x02762B/0x0276A1/0x027738`) **and F3 CC** rebel/tory + REF + FF-list rows (`@0x037D68/0x037E6D/0x037F4F`) — **7 sites** |
| **0x100** `func_002BC8` | **centre text in a box** | menu-bar label line, dialog OPTION rows, **report titles**, colony minimap & Europe dock **empty-panel captions**, and 70+ more sites |
| **0x13C** `func_002B38` | **draw text at explicit (x,y)** | every screen's body/number text |
| **`[0x2DD0]` caption** | **shared "empty panel" caption string** (fetched `0x22`→centred `0x100`) | colony surrounding-minimap empty state (`@0x027DD7`) **and** Europe dock "No Ships In Port" (`@0x031501`) — same DGROUP string id on both screens |

> **Rule for screen specs:** when a screen draws "a count as a row of icons", "a unit
> info panel", "a centred row", or "an empty-panel caption", reference the verb above and
> link here — do **not** invent a screen-local bar/grid. The game has **no continuous
> fill bars anywhere**; every "how much" indicator resolves to `0x236`/`0x2BC`/`0x22C`,
> all of which bottom out in the single-sprite blit `0xC36:0x0A` (= `0x254`).

---

## 0. How `0x181F:NNN` resolves (the addressing model)

`0x181F` is the **first of three overlapping link-time windows onto the single
RTLink thunk table** (`0x181F` / `0x191F` / `0x1A1F`; see
`OVERLAY_THUNKS.md`). The window base is

```
file_base(0x181F) = codeOffset + 0x181F*16 = 0x2400 + 0x1A5F0 = 0x1A5F0
```

so the thunk for `0x181F:NNN` is the 10-byte record at file `0x1A5F0 + NNN`.
Each of these is a **Type-B** thunk (resident target):

```
+0  9A 91 0D 0D 11      LCALL 0x110D:0x0D91   ; type-B loader stub (no overlay swap)
+5  EA <off> <seg>      JMPF  <seg>:<off>      ; <seg> is a REAL link-time segment
```

The actual primitive is at `file = codeOffset + seg*16 + off = 0x2400 + seg*16 + off`.
All targets below were resolved this way and cross-checked against the thunk-table
disassembly `func_01A5F0_rtlink_overlay_thunk_table.asm`.

### Shared sheets / globals these primitives read

| Global | Role | Cite |
|---|---|---|
| `[0x89E]` / `[0x8A0]` | **FONTTINY.FF** glyph table (handle:base / seg). The default body font. | `ASSET_ROLES.md` line 76 (`FONTTINY.FF … [0x89E] @0x0760E8`); used by `func_002B38`, `func_00E6A6` |
| `[0x83E]` / `[0x840]` | sprite-sheet descriptor (icon strip). Per-sprite records are **stride 12 (0x0C)**, with a **width word at +0x3E** into the descriptor. | `func_003104` @0x3165–0x3169; `func_002EE4` @0x2F66/0x2F6A |
| `[0x2DA8]` | sprite-table base pointer passed as `bx` to the low-level blitters. | `func_002B38` @0x2B60; `func_002EE4` @0x2F76; `func_00DB3A` @0x2DB60 |
| `[0x2CCE]/[0x2CE2]/[0x2CF4]`, counter `[0x2CE0]` | the **row accumulator** arrays (sprite / value / colour) filled by enqueue `0x222` and drained by flush `0x22C`. | `func_0033F2`, `func_003104` |
| `[0x3144]` (+0x02 type), stride 0x1C | **UnitRecord** table (NOT a sprite table). | memory `project_unit_table_correction`; `func_00B2A2` @0x3150, `func_00386A` @0x3146 |
| `[0xA899]`, `[0x58A]/[0x58B]` | software mouse-cursor hidden flag / state (cursor hidden around blits). | `func_00CC4E`, `func_00CC60` |

### The low-level draw verbs every primitive bottoms out in

| LCALL | file / func | verb |
|---|---|---|
| `0xC2A:0x06` | `func_00E6A6` | **measure** a string → pixel width (sums glyph-width bytes) |
| `0xC28:0x0A` | `func_00E68A` | **set text colour / state** (writes `[0x269E]` byte pair) |
| `0xC11:0x0C` | `func_00E51C` | **blit a string** (the glyph rasteriser) |
| `0xC36:0x0A` | `func_00E76A` | **blit ONE sprite** (also = primitive `0x254`) |
| `0xA4E:0x08` | `func_00C8E8` | **pixel-address calc** (x,y + surface desc → far ptr; also = `0x290`) |
| `0xC05:0x04` | `func_00E454` | fetch surface row descriptor |
| `0xB9E:0x0A` | `func_00DDEA` | **REP STOSW colour-span fill** |

---

## 1. Summary table

| 0x181F off | Function (file) | Role | Stack signature (caller pushes, far/Pascal order) | Align / sheet / colour |
|---|---|---|---|---|
| **0x022** | `func_002462` | **String scan (`memchr`/`strlen`-helper)** — *NOT a fill-rect* | `[bp+6]` = max count; buffer at `[0x2D42:0x2D44]`; `REPNE SCASB` | — (no draw) |
| **0x0CE** | `func_00E0A2` | **min/order-2 clamp helper** — *NOT a glyph draw* | regs `ax`,`bx`; returns ordered low/high | — (no draw) |
| **0x0E2** | `func_00DB3A` | **Clipped sprite blit** (cursor-hidden) — *NOT a horizontal rule* | `[bp+6],[bp+8],[bp+0xA]` coords/idx; `dx`→`di`; sheet `[0x2DA8]`; `RETF 6` | sprite, sheet `[0x2DA8]` |
| **0x100** | `func_002BC8` | **CENTER text in box** (horizontal) | `[bp+6]`=surface, `[bp+8]`=string, `[bp+0xA]`=box_x, `[bp+0xC]`=boxW, `[bp+0xE]`,`[bp+0x10]`=font/colour | **H-centred**; FONTTINY |
| **0x114** | `func_002AC6` | **Measure string width** (returns width−1) | `[bp+6]`=string, `[bp+8]`=?, `[0x89E]/[0x8A0]`=font | FONTTINY |
| **0x13C** | `func_002B38` | **Draw text at explicit x,y** (no centering) | `[bp+6]`=x, `[bp+8]`=y, `[bp+0xA]`=string(`di`), `[bp+0xC]`=colour, `[bp+0xE]`=? | left-aligned at (x,y); FONTTINY |
| **0x16E** | `func_002992` | **strcat** into shared buffer (no draw) | `[bp+6]`=dest, `[bp+8]`=src; calls `0:0x62` then `_strcat 0xD1D:0x11B4` | — |
| **0x182** | `func_0029DE` | **Append number** (itoa+strcat, no draw) | `[bp+6]`=dest, `[bp+8]`=?, `[bp+0xA]`=int; `0xD1D:0x8FA`=itoa | — |
| **0x1BE** | `func_0028F2` | **Dispatch overlay op 0x55** (flush/draw buffer entry — *thin thunk*) | see §detail | — |
| **0x1C8** | `func_002CE0` | **CENTER text in box** (style variant of 0x100, more font args) | `[bp+6]`=surface, `[bp+8]`=string, `[bp+0xA]`=box_x, `[bp+0xC]`=boxW, `[bp+0xE..0x12]`=font/style | **H-centred** — *NOT a title sprite tiler* |
| **0x222** | `func_0033F2` | **ENQUEUE (sprite,value,colour)** into row arrays (no draw) | `ax`=value→`[0x2CF4]`, `[bp-4]`=sprite→`[0x2CCE]`, `[bp-2]`=colour→`[0x2CE2]`, INC `[0x2CE0]` | — |
| **0x22C** | `func_003104` | **FLUSH row**: measure each sprite (sheet `[0x83E]`+0x3E), lay out + **centre** the row | drains `[0x2CE0]` items; widths from `[0x83E]+si*12+0x3E` | **H-centred row**; sheet `[0x83E]` |
| **0x236** | `func_002EE4` | **Proportional sprite-strip indicator** (shared, 7 sites): `count` filled/empty icons fitted to a fixed span at pitch `(span−w)/(count−1)` clamped `[1, w+1]` (overlap when count large) — NOT a fill bar. See detail below. | `ax/bx/dx`(in)=fill-sprite/count/max; `[bp+0xE]`=x, `[bp+0x10]`=y, width arg `[bp+0xC]` | filled idx = arg, empty idx = **0x38 (56)**; used by colony field/building panels, CC bells, reports |
| **0x254** | `func_00E76A` | **Blit ONE sprite** (with H-mirror via high bit) | `bx`=sprite-record ptr (`[bx]`=w−1,`[bx+2]`=h−1); `[bp-0x2E]`=index (bit15=mirror) | sprite; mirror flag = index bit 15 |
| **0x290** | `func_00C8E8` | **Pixel-address calc** (x,y → far ptr) — helper, not a draw | `ax`=x, `dx`=y, `bx`=surface desc(`+2`pitch,`+4`base,`+6`seg) | — |
| **0x2BC** | `func_00386A` | **Per-unit info panel** (icon + filled stat spans + text) — *composite, NOT a plain bar* | `ax`=unit index (→`[0x3146]`, stride 0x1C); large frame | sprites + colour spans + FONTTINY |
| **0x2F8** | `func_00E964` | **Blit ONE sprite (clipped/masked variant)** — *NOT specifically a text row* | `bx`=sprite-record ptr; `[bp-0x174]`=index (bit15=mirror) | sprite; mirror flag = index bit 15 |
| **0x3C0** | `func_004A80` | **Modal "wait for OK / keypress" loop** (kbhit/getch, ~120-tick timeout) — *DRAWS NOTHING* | none meaningful; polls `[0x7F4]`; calls kbhit `0xAE7:2`, getch `0xAE7:0x16` | — (input, not draw) |
| **0x444** | `func_00DCF6` | **Rectangle block-fill / copy** (REP MOVS, row by row) | `ax`=w, `bx`=h(?), `[bp+0xE/0x10]`,`[bp+0x14/0x16]` corners; `RETF 0x12` | 2-D region; uses `func_00C8E8` addr calc |
| **0x484** | `func_00DCD4` | **Horizontal colour span fill** (delegates to `func_00DDEA` REP STOSW) — *NOT a "title string"* | `[bp+6]`=colour, `[bp+8]`=?, `[bp+0xA]`=?, `[bp+0xC]`=? ; `RETF 8` | solid colour run |
| **0xBE6** | `func_00B2A2` | **UnitRecord field test** (`unit[i].field@+0x50 > arg ? -1`) — *NOT a sprite-width query* | `[bp+6]`=unit idx (×0x1C), `[bp+8]`=threshold; returns −1/0 | — (no draw) |

> Two more cited by §0 verbs: **`0x290 / func_00C8E8`** = pixel-address calc;
> **`0xC36:0xA / func_00E76A`** = the single-sprite blit that the gauge tiles
> (same function as `0x254`).

---

## 2. Per-primitive detail

### 0x022 → `func_002462` — String scan (NOT fill-rect) — **brief premise corrected**
File `0x002462..0x00248F` (45 b). Loads buffer ptr from `[0x2D42:0x2D44]`,
`XOR al,al`, `MOV cx,0xFFFF`, `REPNE SCASB`; loops `[bp+6]` times. Returns
`dx:ax` = (segment : pointer past match). This is a **`memchr`/`strlen`-style
buffer scan** (used internally by strcat `0x16E`, which calls `0:0x62`). It is
**not** a rectangle fill — the brief's "suspected FILL RECTANGLE" is incorrect.
Cite: `func_002462_find_char_in_buffer.asm` lines 16–31.

### 0x0E2 → `func_00DB3A` — Clipped sprite blit (NOT a horizontal rule) — **corrected**
File `0x00DB3A..0x00DB7F` (69 b). `RETF 6` (three word args). Sequence:
`LCALL 0xA58:0x2CE` (save/clip state), `LCALL 0xA58:0x5BE` → `func_00CF3E`
(**clip-rectangle computation** against the clip window `[0x594..0x5B8]` and
cursor `[0x5A4]/[0x5A6]` — §0xE2 helper). Then pushes `[bp+6],[bp+8],[bp+0xA]`,
`[bp-2]`, `di`(=`dx` arg), `[bp-4]`, `ds`, `0x2DA8` and `LCALL 0xD11:0x1C` →
`func_00F52C` (the **VRAM pixel-address calc**: reads pitch `+2`, base `+4`,
seg `+6` from the surface; `y*pitch`, `dx<<0xC`). Cursor is hidden/shown via the
`0xA58:0x6FD` / `0xA58:0x2E0` wrappers (`[0xA899]`). **Verdict: a clipped sprite
blit using sheet `[0x2DA8]`** — not a full-width rule. Cite:
`func_00DB3A_unknown.asm` lines 20–36; `func_00CF3E_unknown.asm`;
`func_00F52C_unknown.asm`.

### 0x100 → `func_002BC8` — **CENTER text in box** (confirmed)
File `0x002BC8..0x002C0C` (68 b). `di=[bp+6]` (surface/handle).
Calls `func_002AC6` (`0x114` measure) on string `[bp+8]` → width in `ax`;
`SAR ax,1` (=textW/2); `cx=[bp+0xC]` (boxW) `SAR cx,1` (=boxW/2);
`si = boxW/2 − textW/2 + [bp+0xA]` (box_x); `if si<0 → si=0` (left-clamp);
then pushes `si`(x), `dx`(string), `di`, cs and `CALL func_002B38` (`0x13C`
draw-at-xy). **Horizontally centres** the string within `[box_x .. box_x+boxW]`.
`[bp+0xE]`,`[bp+0x10]` are forwarded to the measure call (font/colour). Cite:
`func_002BC8_unknown.asm` lines 17–48.

### 0x114 → `func_002AC6` — **Measure string pixel width** (confirmed)
File `0x002AC6..0x002AE1` (27 b). Pushes font table `[0x8A0]/[0x89E]`,
`[bp+8]`, `[bp+6]`(string), `0`; `LCALL 0xC2A:0x06` → `func_00E6A6`.
`func_00E6A6` walks the string, and for each char `al` reads the glyph width
byte at `es:[di+2]` where `di = al−1 + [bp+0xA]` and `es = [bp+0xC]` (the font
sheet), accumulating total width + inter-char spacing `[bp-4]`. `func_002AC6`
returns `width − 1` (`DEC ax`). The **right-align** mentioned in the brief is
not done here — callers that right-align do their own `SUB`/`NEG` on this width
(the centering funcs `0x100`/`0x1C8` do `width SAR 1` and subtract; a right-edge
caller would `x = right − width`). Cite: `func_002AC6_unknown.asm`;
`func_00E6A6_unknown.asm` lines 22–35.

### 0x13C → `func_002B38` — **Draw text at explicit x,y** (no centering, confirmed)
File `0x002B38..0x002B72` (58 b). `di=[bp+0xA]`(string), `si=[bp+0xE]`.
`LCALL 0xC28:0x0A` → `func_00E68A` (set text colour/state, `ax=0xFFFF`).
Then pushes font `[0x8A0]/[0x89E]`, `[bp+8]`(y), `[bp+6]`(x), `0`;
`LEA bx,[0x2DA8]`; `ax=di`(string), `dx=[bp+0xC]`(colour);
`LCALL 0xC11:0x0C` → `func_00E51C` (the glyph rasteriser). **No width measure,
no centering** — draws the string with its top-left at (`[bp+6]`,`[bp+8]`).
This is the primitive that `0x100` and `0x1C8` call after computing a centred x.
Cite: `func_002B38_unknown.asm` lines 17–32.

### 0x16E → `func_002992` — **strcat** (no draw, confirmed)
File `0x002992..0x0029AC` (26 b). `PUSH [bp+8]`; `LCALL 0:0x62`
(= `func_002462` buffer-scan to find current end); then pushes
`dx,ax,ds,[bp+6]` and `LCALL 0xD1D:0x11B4` (MSC runtime far `strcat`).
Appends string `[bp+6]` onto the running text buffer. Cite:
`func_002992_unknown.asm`.

### 0x182 → `func_0029DE` — **Append number** (no draw, confirmed)
File `0x0029DE..0x002A05` (39 b). `LEA ax,[bp-0x14]` (local 10-byte buffer),
`LCALL 0xD1D:0x8FA` (MSC integer-to-string of arg `[bp+0xA]`, radix 10),
then `LCALL 0xD1D:0x11B4` (`strcat`) to append the formatted number to dest.
Cite: `func_0029DE_unknown.asm`.

### 0x1BE → `func_0028F2` — overlay-op 0x55 dispatch (thin)
File name `func_0028F2_dispatch_overlay_op_55.asm`. A one-line thunk that calls
the overlay dispatcher with opcode `0x55`. The brief's "flush/draw buffer"
interpretation is plausible (the text-accumulator buffer is committed via this
op), but the *drawing itself* lives behind the overlay dispatch.
**NEEDS VERIFICATION** of exactly which op-0x55 handler runs. Cite:
`func_0028F2_dispatch_overlay_op_55.asm`.

### 0x1C8 → `func_002CE0` — **CENTER text in box** (variant) — **brief premise corrected**
File `0x002CE0..0x002D27` (71 b). **Structurally identical to `0x100`**: measure
via `CALL func_002AE2` (which calls `func_00E6A6`, the same measure core),
`SAR ax,1`, centre within boxW `[bp+0xC]` at box_x `[bp+0xA]`, clamp ≥0, then
`CALL func_002C4A` (which calls `func_00E68A` set-colour + `func_00E51C`
rasterise). It takes **more font/style args** (`[bp+0xE]`,`[bp+0x10]`,`[bp+0x12]`
forwarded to the measure helper) — i.e. a styled centred-text variant. **It is
NOT a title-bar sprite tiler.** Cite: `func_002CE0_unknown.asm` lines 17–48;
`func_002AE2`/`func_002C4A` decoded inline (LCALL targets `0xC2A:6→E6A6`,
`0xC28:0xA→E68A`, `0xC11:0xC→E51C`).

### 0x222 → `func_0033F2` — **ENQUEUE (sprite,value,colour)** (no draw, confirmed)
File `0x0033F2..0x00341D` (43 b). If `dx==0 && bx==0` → skip. Else
`bx = [0x2CE0] << 1` (word index); store `ax`→`[bx+0x2CF4]` (value),
`[bp-4]`(=incoming `bx`, the sprite)→`[bx+0x2CCE]`, `[bp-2]`(=incoming `dx`,
colour)→`[bx+0x2CE2]`; `INC [0x2CE0]`. **No draw** — it appends one cell to the
three parallel row arrays. Drained by `0x22C`. Cite: `func_0033F2_unknown.asm`
lines 17–28 (arrays/counter match the brief exactly).

### 0x22C → `func_003104` — **FLUSH row (measure + centre + blit)** (confirmed)
File `0x003104..0x003193+` (truncated by reseg). Three passes over `[0x2CE0]`
queued items:
1. **Pass 1** (`@0x3122`): accumulate raw sprite indices `[bx+0x2CCE]`, count
   cells with value >1.
2. **Pass 2** (`@0x3150`): for each cell, `si = [bx+0x2CF4] & 0xFFF` (sprite idx
   masked to 12 bits), compute `si*12` (record stride 0x0C in sheet `[0x83E]`),
   `LES bx,[0x83E]`, add the **width word at `es:[bx + si*12 + 0x3E]`** into the
   total-pixel-width accumulator `[bp-0xC]`.
3. **Centering** (`@0x317C`): `[0x2CE0]*spacing − totalWidth`, `NEG`, clamp ≥0 →
   the centred starting x of the row; then it blits each queued sprite left-to-
   right at that origin (blit tail past 0x3192 via `func_00E76A`/`0xC36:0xA`).

So `0x22C` **measures each enqueued sprite from the sheet `[0x83E]` (+0x3E width
field, stride 12), lays the row out, centres it, and blits**. Cite:
`func_003104_unknown.asm` lines 26–66; tail continues in image at 0x3192.

### 0x236 → `func_002EE4` — **Sprite-strip GAUGE** (confirmed)
File `0x002EE4..0x00304A` (358 b). `ENTER 0x1A`; the three pushed regs
(`bx`,`dx`,`ax`) supply the gauge inputs (fill-sprite index = `[bp-0x20]`,
count `[bp-0x1C]`, max `[bp-0x1E]`). The fill loop (`@0x2F66`):
- pushes sheet `[0x840]/[0x83E]`, `x = [bp+0xE]+1`, loads `ax = [bp-0x20]`
  (**the FILLED-segment sprite index**), `LEA bx,[0x2DA8]`, `dx = [bp+0x10]` (y),
  `LCALL 0xC36:0x0A` → `func_00E76A` (**blit one sprite**).
- For positions past the filled threshold (`@0x2FA5`) it loads `ax = 0x38`
  (**sprite index 56 = the EMPTY/background segment**) and blits that instead.
- The filled count is `[bp-0x18] = −(arg8 − [bp-0x1C])` then `SAR` by a shift
  count — i.e. value scaled into the bar's cell count.
- `LCALL 0x12B:0x15C` (`func_00380C`) draws a per-cell value/label (the optional
  number printed over the bar).

**Verdict: tiles the caller-supplied sprite for the filled portion and sprite
`0x38` for the empty portion, segment by segment, via the single-sprite blit.**
Cite: `func_002EE4_unknown.asm` lines 62–112.

> **Proportional, clamped pitch — the defining behaviour (byte-verified 2026-06-23,
> helper `func_002D74`).** The segments are NOT packed at a fixed sprite width: the
> `count` sprites are fitted into a fixed **span** (the caller's width arg, e.g.
> `0x12C`=300) at pitch **`stride = (span − sprite_w)/(count − 1)`** (`idiv` @0x002DC6),
> **clamped to `[1, sprite_w+1]`** (cap @0x002DCD, floor @0x002DD7). Consequences:
> small `count` → `stride = sprite_w+1` (icons just touching); large `count` → `stride`
> floors at **1 px so the icons OVERLAP / almost stack**. So this is the engine's
> universal **"show a count as a proportional row of filled/empty icons across a fixed
> width"** verb — fullness is conveyed by filled (caller sprite) vs empty (`0x38`)
> segments, never by a rectangle fill. (This is why none of the screens have graphical
> fill bars.)

> **Call-site map (all 7 — this is shared chrome, recognise it everywhere):**
> | site | screen / panel | what it counts |
> |------|----------------|----------------|
> | `@0x02665D` / `@0x02668A` / `@0x026700` | colony **field-production panel** (`func_0264A8`) | per-field production yield icons |
> | `@0x026EF7` | colony **building draw** (`func_026DD4` region) | building-level / capacity indicator |
> | `@0x027CCC` | colony **bottom panel** (`func_027xxx`) | a per-colony count strip |
> | `@0x037BF5` | **F3 Continental Congress** body (`func_037A20`) | bells-toward-next-FF (filled `0x3F`/`0x39` vs empty `0x38`) |
> | `@0x0379B4` | advisor **report** sub-renderer (`func_037958`) | a report count strip |
>
> Any spec that shows "a row of N icons for a count" should cite `0x181F:0x236`
> rather than re-deriving it: `spec/ui/continental_congress.md` (bells),
> `spec/ui/colony_screen.md` §3.2 (field yields), and the advisor reports.

### 0x254 → `func_00E76A` — **Blit ONE sprite** (signature pinned)
File `0x00E76A..` (the load-image sprite blitter). `bx` = pointer to a sprite
record: `[bx]` = width, `[bx+2]` = height (both `DEC`'d → w−1/h−1). The index arg
`[bp-0x2E]`: **bit 15 = horizontal-mirror flag** (`dx=−1` if set, else `+1`,
saved in `[bp-0x10]`), then `&0x7FFF` to recover the real sprite index. So the
**signature is `(spriteRecordPtr=bx, indexWithMirrorBit, x, y, surface)`** with
the mirror encoded in the index's high bit. This is the function the gauge
(`0x236`), the row-flush (`0x22C`), and the unit panel (`0x2BC`) all bottom out
in for sprite output. Cite: `func_00E76A_unknown.asm` lines 19–35.

### 0x290 → `func_00C8E8` — **Pixel-address calc** (helper, not a draw)
File `0x00C8E8..0x00C8FB` (orphan range in `orphans_load_image.asm`). Given
`ax`=x, `dx`=y, `bx`=surface descriptor: `ax = y * [bx+2]` (pitch) `+ [bx+4]`
(base) `+ x`; `dx = [bx+6]` (segment). Returns the far pointer `dx:ax` to pixel
(x,y). Used by the rectangle fill `0x444` and the blitters. **Not itself a tile
blit** — the brief's "tile blit" label is a misnomer; it is the address
arithmetic. Cite: `orphans_load_image.asm` lines 7263–7272.

### 0x2BC → `func_00386A` — **Per-unit info panel** (composite) — **brief premise corrected**
File `0x00386A..` (≈1494 b composite chain). `ax` (saved `si`) = a **unit index**:
`IMUL bx,[bp-0x2A],0x1C` and `MOV al,[bx+0x3146]` read the **UnitRecord type**
field (base `0x3144` + 0x02, stride 0x1C — see memory). The body then:
measures text (`func_00E6A6`), blits sprites (`func_00E964`, `func_00E76A`),
draws **five colour spans** (`func_00DDEA` ×5 — the stat bars), and draws text
(`func_00E68A`+`func_00E51C`). **This is a unit icon + filled-stat-bars + labels
panel, not a single bar/gauge or frame.** Cite: `func_00386A_unknown.asm`
lines 40–46; far-call set `0x427:2/0x427:0x4A/0x37F:0xA/0xC2A:6/0xC83:2/0xC56:4/
0xB9E:0xA(×5)/0xC28:0xA/0xC11:0xC/0xC36:0xA`.

### 0x2F8 → `func_00E964` — **Blit ONE sprite (clipped/masked variant)** — **corrected**
File `0x00E964..` . **Identical prologue to `func_00E76A`**: `bx`=sprite record
(`[bx]`/`[bx+2]` = w/h −1), index arg `[bp-0x174]` with **bit 15 = mirror flag**,
`&0x7FFF`. The much larger stack frame (`ENTER 0x16E`) is for a clip/mask scratch
buffer. **It is a sprite-blit variant (clipped), not a dedicated text/icon-row
routine.** Cite: `func_00E964_unknown.asm` lines 19–34.

### 0x3C0 → `func_004A80` — **Modal wait-for-OK / keypress loop** (NOT a draw) — **brief premise corrected**
File `0x004A80..0x004AFA` (122 b). `si=1`(loop flag), `di=0`. Body:
- `LCALL 0xC0C:6` → `func_00E4C6` (read a far dword = the tick/timer baseline →
  `[bp-4]/[bp-2]`).
- `LCALL 0xACB:0x30` (`func_00D0E0`) … `LCALL 0x29F:0xF6` (`func_004EE6`,
  the input/state poll dispatcher) … `LCALL 0xACB:0x56` (`func_00D106`) — the
  mouse-cursor blink / state servicing (the `0xACB`/`func_00D0E0` family pokes
  `[0xA899]` and `INT 0x33` mouse).
- `LCALL 0xAE7:2` → `func_00D272` = **kbhit**; if no key, `LCALL 0xAE7:0x16` →
  `func_00D286` = **getch** (→ `di`).
- `CMP [0x7F4],0x07` … `LCALL 0xACB:0x11A` (`func_00D1CA`) — checks the click/key
  result.
- Re-reads the timer (`func_00E4C6`), computes baseline `+ 0x78` (**120 ticks**),
  compares → loop (`JNE 0x4A96`) until a key/click arrives or the timeout fires.

**Verdict: this is the "press a key / click to dismiss" modal wait used after a
dialog is painted — it polls keyboard + mouse with a ~120-tick timeout and
DRAWS NOTHING.** The brief's premise ("decode exactly what the OK button draws —
a sprite? filled rect + text?") does not apply: the OK button's *box and label*
are painted by the dialog builder beforehand; `0x3C0` is only the wait loop.
Cite: `func_004A80_unknown.asm` + continuous bytes file `0x4A80..0x4AFA`;
`func_00D272_kbhit.asm`, `func_00D286_getch.asm`.

### 0x444 → `func_00DCF6` — **Rectangle block-fill / copy** (the real 2-D fill) — **brief offset corrected**
File `0x00DCF6..0x00DDEA` (244 b). `RETF 0x12` (9 word args). Computes
`[bp-0xA] = −w` and `[bp-0xE] = −h` (`NEG`), derives two corner addresses via
`func_00C8E8` (`0xA4E:8`, the pixel-address calc) + `func_00E454` (`0xC05:4`
surface fetch), then runs a **row-by-row `REP MOVSW`/`MOVSB`** advancing the
destination by the scanline pitch (`0x800` segment step in the inner loop). This
is the **rectangular region block-copy/fill** primitive (clear a panel, copy a
saved background, etc.). **Note:** the brief mapped `0x444` to `func_00DCD4`,
but the thunk at `0x181F:0x444` is `JMPF 0xB8F:6` → file `0x00DCF6`
(`func_00DCF6`); `func_00DCD4` is `0x484`. Cite:
`func_00DCF6_unknown.asm` + continuous bytes `0xDCF6..0xDDEA`.

### 0x484 → `func_00DCD4` — **Horizontal colour-span fill** (NOT a title string) — **corrected**
File `0x00DCD4..0x00DCF6` (34 b). `RETF 8` (4 word args). Pushes
`[bp+0xC],[bp+0xA],[bp+8],[bp+6]` (geometry) + `[bp+6]` again + `ax`,
`SUB ax,ax`, `CDQ`, `bx=[bp+8]`, then `LCALL 0xB9E:0x0A` → `func_00DDEA`.
`func_00DDEA` clips (`0xA4E:0x1C`), fetches the row pointer (`0xC05:4`), loads
the **colour byte from `[bp+6]`** (`MOV al,[bp+6]; MOV ah,al`) and does
`REP STOSW es:[di]` — i.e. **fills a horizontal run with a single colour**. So
`0x484` is a **solid colour horizontal span / line fill** (and is the closest
thing in this set to a "horizontal rule"), *not* a composited title string.
Cite: `func_00DCD4_unknown.asm`; `func_00DDEA_unknown.asm` lines 52–66
(`REP STOSW`).

### 0xBE6 → `func_00B2A2` — **UnitRecord field test** (NOT sprite-width) — **corrected**
File `0x00B2A2..0x00B2C1` (31 b). `IMUL bx,[bp+6],0x1C` (stride-0x1C UnitRecord),
`MOV al,[bx+0x3150]` (field at +0x50 into the record at base `0x3144`),
`CMP ax,[bp+8]`, returns `0xFFFF` (−1) when the field ≤ threshold else 0. The
disasm filename already names it `unit_cargo_slot_kind_or_neg1`. **This is a
gameplay/UnitRecord predicate, not a sprite-width query.** (Real per-sprite width
is read inline from `[0x83E]+0x3E` by `0x22C`/`0x236`.) Cite:
`func_00B2A2_unit_cargo_slot_kind_or_neg1.asm` lines 15–24; memory
`project_unit_table_correction` (base 0x3144, stride 0x1C).

### 0x0CE → `func_00E0A2` — **min / order-2 helper** (NOT glyph draw) — **corrected**
File `0x00E0A2..0x00E0B0+` (14 b head). `CMP bx,ax; if bx<ax swap (dx=ax, ax=bx)`
— returns the two inputs in low/high order (a clamp/min used for clip bounds).
**Not a glyph or short-string draw.** Cite: `func_00E0A2_unknown.asm`
lines 17–22.

---

## 3. Corrections to the original brief (so future transcriptions don't repeat them)

| Brief claim | Byte-verified reality |
|---|---|
| `0x22 / func_002462` = **FILL RECTANGLE** | `memchr`/`strlen` buffer **scan**; no drawing. (The real rect fill is `0x444 / func_00DCF6`.) |
| `0xE2 / func_00DB3A` = **HORIZONTAL RULE full-width** | **Clipped sprite blit** (sheet `[0x2DA8]`, cursor-hidden). (The real colour-span fill is `0x484 / func_00DCD4`.) |
| `0x1C8` = **title-bar sprite tiler** | **Centered-text-in-box** variant of `0x100` (`func_002CE0`). No sprite tiling. |
| `0x254 / func_00E76A` blit signature | Confirmed; **index bit 15 = H-mirror flag**, `&0x7FFF` = real index; `bx` = sprite record (`[bx]`/`[bx+2]` = w/h −1). |
| `0x290 / func_00C8E8` = **tile blit** | **Pixel-address calculator** (x,y + surface → far ptr); a helper, not a blit. |
| `0x2BC / func_00386A` = secondary bar/gauge | **Per-unit info panel** (UnitRecord-indexed; icon + 5 colour-span stat bars + text). Composite. |
| `0x2F8 / func_00E964` = text/icon row | **Clipped single-sprite blit** variant (same prologue as `0x254`). |
| `0x3C0 / func_004A80` = the OK button (decode what it DRAWS) | **Modal wait-for-keypress/click loop** with ~120-tick timeout (kbhit/getch + mouse-blink). **Draws nothing**; the OK box/label are painted by the dialog builder first. |
| `0x444 → func_00DCD4` | `0x444` thunk → `func_00DCF6` (**rect block-fill/copy**); `func_00DCD4` is `0x484`. |
| `0x484 / func_00DCD4` = composited title string | **Horizontal solid-colour span fill** (`REP STOSW` via `func_00DDEA`). |
| `0xBE6 / func_00B2A2` = sprite-width query | **UnitRecord field predicate** (`unit[i]@+0x50 > arg ? −1`). Not a width query. |
| `0xCE / func_00E0A2` = glyph/short string | **min / order-2 clamp** helper. No draw. |

---

## 4. Quick mental model for transcribers

- **"Fills a rectangle"** → `0x444` (`func_00DCF6`, 2-D block) or `0x484`
  (`func_00DCD4`, 1-D colour span). Address math = `0x290` (`func_00C8E8`).
- **"Blits / tiles sprites"** → single sprite: `0x254` (`func_00E76A`) and its
  clipped twin `0x2F8` (`func_00E964`); clipped one-shot: `0xE2`
  (`func_00DB3A`); **strip/gauge** (tile fill-sprite then empty sprite `0x38`):
  `0x236` (`func_002EE4`); **enqueue+flush a centred icon row**: `0x222` then
  `0x22C`. Sprite index **bit 15 = horizontal mirror**.
- **"Centers text"** → `0x100` (`func_002BC8`) and styled variant `0x1C8`
  (`func_002CE0`). Both call **measure** `0x114` (`func_002AC6`/`func_00E6A6`),
  compute `x = box_x + (boxW − textW)/2`, clamp ≥0, then **draw-at-xy** `0x13C`.
- **"Draws text at x,y (left-aligned)"** → `0x13C` (`func_002B38`). Font =
  **FONTTINY** (`[0x89E]/[0x8A0]`).
- **"Measures / right-aligns text"** → `0x114` (`func_002AC6`) returns width−1;
  the caller does `x = right − width` for right alignment.
- **"Builds a text string"** → `0x16E` strcat, `0x182` append-number.
- **"Waits for the user to dismiss a dialog"** → `0x3C0` (`func_004A80`) — input
  loop, no drawing.
- **Unit-specific** (not generic UI): `0x2BC` (unit panel), `0xBE6` (UnitRecord
  predicate).

---

*Generated 2026-05-31 by byte-tracing VICEROY.EXE thunk window `0x181F` and the
resident load-image functions. All offsets relative to file 0 unless noted.*
