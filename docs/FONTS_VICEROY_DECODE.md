# FONTS — VICEROY.EXE byte-level decode

> **Mandate:** every claim cites a `VICEROY.EXE` file offset (`func@0xNNNNN` /
> push/mov site). Un-verifiable → **TBD** + blocker. DGROUP base **0x1D9A0**;
> a static datum at DGROUP offset `D` lives at file `0x1D9A0 + D`. BSS (DS ≥
> 0x2CC6) values are runtime → TBD.
>
> Cross-checked against `spec/ui/fonts_and_colors.md`; **every** claim below was
> re-confirmed against the EXE this pass. Two corrections to prior docs are
> flagged inline (FONT-NP has no fixed global latch; FONTKING writes the shared
> active-font global, not a private latch).

---

## 0. Summary table (all byte-verified)

| Font | Disk file | Name string (file / DGROUP) | Load site | Latch global it sets | Width source |
|------|-----------|-----------------------------|-----------|----------------------|--------------|
| **FONTINTR** | `FONTINTR.FF` | `"fontintr"` @ **0x1FD2B** (DG+0x238B) | `func_075FB6` @ **0x0760C6** (`lea bx,[0x2389]` @0x760C2; `lcall 0x1A1F:0xA86`) | **`[0x268A]`**(off)/**`[0x268C]`**(seg) — stored @0x760CB/0x760CE | per-glyph (`+2` byte in glyph record) |
| **FONTTINY** | `FONTTINY.FF` | `"fonttiny"` @ **0x1FD32** (DG+0x2392) | `func_075FB6` @ **0x0760E8** (`lea bx,[0x2392]` @0x760E4; `lcall 0x1A1F:0xA86`) | **`[0x89E]`**(off)/**`[0x8A0]`**(seg) — stored @0x760ED/0x760F0 | per-glyph (`+2` byte in glyph record) |
| **FONTKING** | `FONTKING.FF` | `"FONTKING"` @ **0x1FCCB** (DG+0x232B) | `func_075352` @ **0x0754F6** (`lea bx,[0x232B]`; `lcall 0x1A1F:0xA86`) | **no private latch** — writes shared active-font global **`[0x1F9E]/[0x1FA0]`** @0x75511 (falls back to FONTTINY `[0x89E]/[0x8A0]` @0x7550A if load fails) | per-glyph |
| **FONT-NP** | `FONT-NP.FF` | `"FONT-NP"` @ **0x1F8AF** (DG+0x1F0F) | `func_06B722` @ **0x06B7AF** (`lea bx,[0x1F0F]` @0x6B7AB; `lcall 0x1A1F:0xA86`) | **no fixed global** — handle stored to **stack local `[bp-0x3AC]/[bp-0x3AA]`** @0x6B7B4/0x6B7B8 | per-glyph |
| ~~FONTSMAL~~ | `FONTSMAL.FF` | *(absent from EXE — no `fontsmal`/`FONTSMAL` string)* | — | — | **ORPHAN, never loaded** |

**Common font-load verb = `0x1A1F:0xA86`** (target file **0x076C70**, `enter 0x13E,0`).
It is called with `bx` = far-ptr-able DGROUP offset of the asset name and returns
the font handle in **dx:ax** (seg:off). It has exactly **4** call sites — the four
fonts above (`tools/follow_thunk.py 0x1a1f 0xa86`): 0x0760C6, 0x0760E8, 0x0754F6,
0x06B7AF. There is **no fifth font load**, confirming FONTSMAL is an orphan.

---

## 1. The boot font loader — `func_075FB6` (file 0x075FB6)

Loads FONTINTR then FONTTINY, in that order, into the two persistent screen
latches. Disasm (`scratchpad/disv.py 0x076090`):

```
0760C2  lea   bx, [0x2389]          ; -> "fontintr" (DG+0x238B; bx is at 0x2389, the record head)
0760C6  lcall 0x1A1F:0xA86          ; FONT LOAD VERB -> dx:ax = handle
0760CB  mov   [0x268A], ax          ; FONTINTR latch low  (offset)
0760CE  mov   [0x268C], dx          ; FONTINTR latch high (segment)
0760D2  mov   ax, dx
0760D4  or    ax, [0x268A]
0760D8  jne   0760E4                 ; handle != 0 -> ok
0760DA  mov   [0x822], 0x15          ; else fatal error code 0x15
...
0760E4  lea   bx, [0x2392]          ; -> "fonttiny" (DG+0x2393)
0760E8  lcall 0x1A1F:0xA86          ; FONT LOAD VERB
0760ED  mov   [0x89E], ax           ; FONTTINY latch low  (offset)    <-- boot default
0760F0  mov   [0x8A0], dx           ; FONTTINY latch high (segment)
0760F4  or    ax/dx -> jne 76106    ; else fatal error 0x16
```

So **FONTTINY is the boot default body font** (its handle `[0x89E]/[0x8A0]` is the
one every paint helper pushes by default), and **FONTINTR is the second persistent
font** (`[0x268A]/[0x268C]`), used by title/menu/Hall-of-Fame/score paths. Both
latches are **static DGROUP words** (DG offsets 0x89E/0x8A0 and 0x268A/0x268C →
file 0x1E23E/0x1E240 and 0x2002A/0x2002C) but their **runtime values are font
handles produced by the loader** → the *handle value* is runtime/TBD; the *latch
location* and *which font fills it* are byte-verified above.

The asset-name strings sit in a packed list at DG+0x2380…:
`"viceroy.pal\0fontintr\0fonttiny\0cursor\0woodtile\0parch\0opentile\0..."`
(hex-dumped at file 0x1FD20). Note the names are **lowercase on disk-key**; the
disk files are upper-case `FONTINTR.FF` etc. (the loader appends the extension /
is case-insensitive — extension handling in `0x076C70`).

---

## 2. FONTKING — transient, king-defeats only — `func_075352`

```
0754F2  lea   bx, [0x232B]          ; -> "FONTKING"
0754F6  lcall 0x1A1F:0xA86          ; load (same verb)
0754FE  mov   [bp-0xA], dx          ; keep handle locally
07550xx or dx,ax / je 0750A         ; if load FAILED:
07550A    mov ax,[0x89E]; mov dx,[0x8A0]   ;   fall back to FONTTINY
075511  mov   [0x1F9E], ax          ; write the SHARED active-font global
075514  mov   [0x1FA0], dx          ;   (off/seg)
...
075540  lcall 0x181F:0x3FE          ; draw via glyph engine
```

**Correction vs. premise:** FONTKING has **no private persistent latch**. It is
loaded on entry to the king-defeats screen, and its handle is written into the
**active-font global `[0x1F9E]/[0x1FA0]`** (the channel the glyph engine reads),
with a FONTTINY fall-back if the file is missing. This matches
`notes/rulings/RULINGS.md` 2026-06-21 and `spec/ui/fonts_and_colors.md` (sole
FONTKING user). Pen is set to (x=0xF2=242, y=0x2F=47) at 0x754F2-region
(`[0x1F4A]=0xF2`, `[0x1F50]=0x2F` @0x75526/0x7552C).

---

## 3. FONT-NP — transient, name-plate path — `func_06B722`

```
06B7AB  lea   bx, [0x1F0F]          ; -> "FONT-NP"
06B7AF  lcall 0x1A1F:0xA86          ; load (same verb)
06B7B4  mov   [bp-0x3AC], ax        ; handle stored to a STACK LOCAL (off)
06B7B8  mov   [bp-0x3AA], dx        ;                              (seg)
06B7BE  or dx,ax / jne 6B7C3        ; bail if load failed
```

**Correction vs. premise:** FONT-NP does **not** set a fixed global latch; its
handle lives in a stack local within `func_06B722` (the WDCUT/name-plate setup
path, which also loads further records via `0x191F:0xFD0` at 0x6B7CE/0x6B7E8).
Any per-blit use of FONT-NP passes that local handle directly to the draw verb.
Where FONT-NP is actually *drawn from* (which paint pushes `[bp-0x3AC]`) is inside
`func_06B722`'s body — **TBD** (blocker: large function, the specific name-plate
text-draw push not yet isolated this pass).

---

## 4. Glyph metrics — **proportional / per-glyph width** (the load-bearing fact)

The shared **measure-width core** is reached by thunk **`0x181F:0x204`**
(Type-B → file **0x00E6A6**) and by the resident far-call `0xC2A:6` (same core).
Disasm (`scratchpad/disv.py 0x00E6A6`):

```
00E6A6  enter 2,0
00E6AD  lds   si, [bp+6]            ; si -> the string
00E6BA  mov   es, [bp+0xC]          ; es = font handle segment
00E6BD  mov   al, [si]              ; al = current char code
00E6C0  mov   di, ax
00E6C2  dec   di                    ; di = char-1
00E6C4  add   di, [bp+0xA]          ; + font glyph-table base (handle offset)
00E6C7  mov   cl, es:[di+2]         ; <<< cl = PER-GLYPH WIDTH byte (record +2)
00E6CB  sub   ch, ch
00E6CD  or    cx, cx / jle 00E6D8   ; width<=0 -> skip add
00E6D1  cmp   [si], ch              ; (last char? no trailing spacing)
00E6D5  add   cx, [bp-4]            ; + INTER-GLYPH SPACING arg
00E6D8  add   [bp-2], cx            ; accumulate pen advance
00E6DB  cmp   [si], 0 / jne 00E6BD  ; next char
00E6E5  mov   ax, [bp-2]            ; return total pixel width
```

**Conclusion (byte-verified):** text is **NOT fixed-width**. Each glyph's advance
is `width = font_record[char-1].byte[+2]`, read from a **per-glyph width table**
inside the loaded `.FF` handle (base = handle offset `[bp+0xA]`, indexed by
`char-1`, the width field is at **+2** within each glyph record), plus a caller-
supplied **inter-glyph spacing** word (`[bp-4]`). x advances by that per glyph.
The `(char-1)` indexing means glyph records start at character code 1 (code 0 =
terminator). This applies to **all four fonts** — they all flow through the same
measure/draw core; the only per-font difference is the handle pushed.

**Glyph cell height / pixel layout** (rows per glyph, bitplane format) lives in
the `.FF` file body, not in the EXE — decoded by the importer (`formats/FF.md`).
The EXE only consumes the width byte at `+2`; the cell *height* is **TBD from the
EXE** (blocker: height is read inside the draw core `0x6F7EF`, not the measure
core; the per-font 6×4 / 9×6 / 7×var / 8×var values in
`spec/ui/fonts_and_colors.md` come from the decoded `.FF` atlases, tier A, not an
EXE constant).

---

## 5. The shared text-draw verb family (file 0x002AC6 – 0x002BC6)

A compact bank of `retf` wrappers, each ~30 bytes, that every screen's paint code
far-calls. They differ only in **which font handle they push** and the
**alignment**. Disasm (`scratchpad/disv.py 0x002AC6`):

| File offset | Role | Font pushed | Core called |
|-------------|------|-------------|-------------|
| **0x002AC6** | measure width (left) | FONTTINY `push [0x8A0];push [0x89E]` | `0xC2A:6` (= measure core 0x00E6A6) |
| **0x002AE2** | measure width | **FONTINTR** `push [0x268C];push [0x268A]` | `0xC2A:6` |
| **0x002AFE** | draw text, left-aligned | FONTTINY `[0x8A0]/[0x89E]` | `0xC11:0xC` (draw core) via `lea bx,[0x2DA8]` param |
| **0x002B38** | draw text + set pen color | FONTTINY | sets color via `0xC28:0xA`, then `0xC11:0xC` |
| **0x002B72** | draw text, **right/center** | FONTTINY | measures (`0xC2A:6`), subtracts width from x, then `0xC11:0xC` |

- The **draw core = `0xC11:0xC`** (11 call sites). It is handed the same font
  handle + a draw-params block at DGROUP **`0x2DA8`** (`lea bx,[0x2DA8]`), the pen
  x (`[bp+6]`)/y (`[bp+8]`), color, and the string. It walks the string and
  advances x per glyph using the same per-glyph width table as §4.
- The **pen-color setter = `0xC28:0xA`** (`ax=0xFFFF` mask + color in dl from
  `[0x830]`/arg), seen at 0x002B12, 0x002B4B, 0x002B85.
- The general dispatcher used by FONTKING / name-plate is **`0x181F:0x3FE`**
  (Type-A → file **0x06F594**), which funnels all variants into `call 0x6F7EF`
  with `bx = [0x87C]` (the active draw-context struct). `[0x1F5C]` set in this
  path is the **speaker-portrait/style selector** (e.g. `=8` @0x6F5DD), **not**
  text color (confirms RULING 2026-06-21).

**How x advances per glyph (final):** for left-aligned draws the pen starts at the
caller's x and increases by `glyph_width(char) + spacing` after each glyph (the
draw core mirrors the measure core in §4). For right/center draws (`0x002B72`) the
total measured width is subtracted from the anchor x **first**, then it draws
left-to-right.

---

## 6. Which screen uses which font (re-confirmed push sites)

| Screen / element | Font handle pushed | Cite |
|------------------|--------------------|------|
| Colony title/body, Europe rows, advisor bodies, popups | **FONTTINY** `push [0x8A0];push [0x89E]` | @0x25F62, @0x30EDE (europe row builder `func_030DF4` @0x030EDE→`lcall 0x181F:0x204`), @0x3860C |
| Hall of Fame, in-game menu, score big figures | **FONTINTR** `push [0x268C];push [0x268A]` | @0x22ABE, @0x23C06, @0x3B054 |
| King-defeats text | **FONTKING** (active global `[0x1F9E]`) | `func_075352` @0x75511/@0x75540 |
| Speaker name-plate | **FONT-NP** (local handle) | `func_06B722` @0x6B7B4 |

(Colony/Europe/advisor never push FONTKING — verified: their pushes are `[0x89E]`,
not `[0x232B]`.)

---

## 7. Residual / TBD

- **Glyph cell height per font from the EXE** — TBD (read inside draw core
  `0x6F7EF`; EXE measure core only uses the width byte at `+2`). Heights in
  `spec/ui/fonts_and_colors.md` are `.FF`-atlas-derived (tier A), not EXE
  constants.
- **FONT-NP draw site** (which paint pushes the `[bp-0x3AC]` handle) — TBD inside
  `func_06B722`.
- **Runtime font-handle values** in `[0x89E]/[0x8A0]/[0x268A]/[0x268C]` — runtime
  (loader output) → TBD by rule (BSS/heap handle); only the latch *locations* and
  *which font* are static.
