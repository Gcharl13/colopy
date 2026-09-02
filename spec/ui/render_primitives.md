# UI Render Primitives — the draw-verb vocabulary (B)

> **Layer 2 — UI Specification.** The canonical table of every low-level draw call a screen
> painter issues, so a rebuild knows exactly what each `lcall 0x181F:0xNNN` in the other
> `spec/ui/*.md` sheets *does*. Every target is byte-verified via the type-B thunk formula
> `target_file_offset = 0x2400 + (jmpf_seg<<4) + jmpf_off` (`code/VICEROY/thunks_resolved.json`),
> spot-checked by disassembling the target in `raw/COLONIZE/VICEROY.EXE`. Supersedes the partial,
> partly-wrong vocabulary in `viceroy_source/docs/UI_PRIMITIVES.md` (which omits 10 of these) and
> corrects the `0x35C`-is-text-draw error propagated into `advisor_reports.md`.

## 0. Two colour-sourcing families (important for a rebuild)
Text verbs split into two families by **where the pen colour comes from**:
- **Global-colour text** (`func_002Axx`/`002Cxx`): colour = byte **`[0x830]`** (and `[0x831]`),
  a screen-level pen latch — e.g. `func_002AFE` pushes `[0x830]` `@0x002B07` then the font latch
  `[0x89E]:[0x8A0]` and `(x,y)`. No per-call colour arg.
- **Explicit-arg text** (`func_002Bxx`): colour is a push-arg to the call.
Both bottom out in the same string rasteriser core **`func_00E51C`** (`0x181F:0x1FA`), whose ink
levels map through the 4-entry LUT `[0x269E]:[0x26A0]` (`spec/ui/fonts_and_colors.md` §1b).

## 1. Canonical draw-verb table (all type-B → resident, byte-verified)

| Thunk | Target (file) | Class | What it does |
|-------|---------------|-------|--------------|
| `0x181F:0x1FA` | `func_00E51C` | **text core** | Proportional string rasteriser: `ch−1` glyph lookup, 2 bpp → `[0x269E]` LUT. All text bottoms out here. |
| `0x181F:0x204` | `func_00E6A6` | **text measure** | Returns pixel width of a string (Σ glyph widths). The width source for every centered/right-aligned element. |
| `0x181F:0x100` | `func_002BC8` | text | **Centered** title/string (centres in a pushed box width). |
| `0x181F:0x13C` | `func_002B38` | text | Draw string at `(x,y)` — **explicit-colour** family. |
| `0x181F:0x132` | `func_002AFE` | text | Draw string at `(x,y)` — **global-colour** (`[0x830]`). |
| `0x181F:0x150` | `func_002B72` | text | String draw variant (global-colour family). |
| `0x181F:0x18C` | `func_002C4A` | text | String draw variant. |
| `0x181F:0x1AA` | `func_002C82` | text | String draw variant. |
| `0x181F:0x182` | `func_0029DE` | text | Append a **decimal number** to the working string. |
| `0x181F:0x1A0` | `func_002A06` | text | Append a **zero-padded** number. |
| `0x181F:0x16E` | `func_002992` | text | **strcat** into the working string buffer. |
| `0x181F:0x10A` | `func_002912` | text | string-build helper (append). |
| `0x181F:0x11E` | `func_002922` | text | string-build helper. |
| `0x181F:0x128` | `func_002932` | text | string-build helper. |
| `0x181F:0x146` | `func_002962` | text | string-build helper. |
| `0x181F:0x178` | `func_0028B0` | text | string-build helper (call-overlay-with-80). |
| `0x181F:0x1BE` | `func_0028F2` | text | string-build helper. |
| `0x181F:0xE2`  | `func_00DB3A` | **sprite** | **Clipped sprite blit** (the workhorse — units, icons, panels). |
| `0x181F:0x254` | `func_00E76A` | sprite | Blit ONE sprite (reads `[bx]`=w−1, `[bx+2]`=h−1). |
| `0x181F:0x24A` | `func_00380C` | sprite | Sprite blit variant. |
| `0x181F:0x1468`| `func_00D9E0` | sprite | Sprite blit variant. |
| `0x181F:0x18F8`| `func_00DB80` | sprite | Sprite blit variant. |
| `0x181F:0x222` | `func_0033F2` | sprite | **Icon-bar** strip (discrete indicators — SoL/crosses/bells). |
| `0x181F:0x2BC` | `func_00386A` | sprite | **Unit-info panel** composite (used by map sidebar + reports). |
| `0x181F:0x510` | `func_00531C` | **blit** | src→dst rect/scene blit (normalises two far ptrs via `0xA4E:8`, copies with transparent skip). Used for full-scene backdrops AND (via a different call site) the popup frame — see caveat. |
| `0x181F:0xBA`  | `func_00DDEA` | fill | **Span fill** (horizontal run). |
| `0x181F:0x444` | `func_00DCF6` | fill | **Rect fill** (box). |
| `0x181F:0xCE`  | `func_00E0A2` | line | Line / plot. |
| `0x181F:0x590` | `func_00BCEA` | fill | Span-fill + vram (variant). |
| `0x181F:0xDAE` | `func_00BCAA` | fill | Span-fill + vram (variant). |
| `0x181F:0x44E` | *(type-A, overlay)* | load | **load_PIK** — load a `.PIK` background by name. |
| `0x181F:0x438` | *(type-A, overlay)* | load/blit | PIK/asset blit-by-name (paired with `0x44E`). |

## 1b. `0x181F:0x2BC` = `func_00386A` — the unit-info panel composite (DECODED 2026-08-20)

Five screens draw a unit through this one verb — F7 Naval (`@0x039586`), F6 Colony
(`@0x039297`), the colony screen (`@0x026639`), the Europe ship rows
(`func_031366 @0x0313C2`) and the Colonizopedia figures — so one wrong reading of it
is wrong in five places. What follows is read off `@0x00386A`–`@0x003E3D`
(`enter 0x46`, `retf 6`).

**Arguments.** Three on the stack plus three in registers:

| where | meaning |
|---|---|
| `ax` | unit index (stored via `func_0037BE` into `[bp-0x2A]`) |
| `bx` | x |
| `dx` | FLAGS: bit `0x80` = check the AI/debug branch (`@0x00388E`), bit `0x20` = suppress the status letter and use a 4-px pad (`@0x003BDF`, `@0x003D8F`), bit `0x40` masked out early |
| `[bp+6]` | MODE: `0x64` (100) = the full panel; `0x19` and `0x32` are two smaller variants (`@0x003B3C`) |
| `[bp+8]` | a width to centre within — surplus over the sprite width is split (`@0x003B23`) |
| `[bp+0xA]` | y |

**Unit CLASS `[bp-0x12]`**, which decides where the plate sits relative to the sprite
(prologue `@0x0038B6`–`@0x0039FC`):

| class | unit types |
|---|---|
| 1 | `0x0F` Galleon, `0x10` Privateer, `0x11` Frigate, `0x12` Man-O-War |
| 2 | `0x0A` Treasure, `0x0B` Artillery, `0x0C` Wagon Train |
| 3 | `0x0D` Caravel, `0x0E` Merchantman, `0x04` Dragoons, `0x05` Scouts, `0x07` Cont. Cav., `0x08` Cavalry, `0x15` Mtd. Braves, `0x16` Mtd. Warriors |
| 4 | `0x0B` Artillery **with** `+0x3148 & 0x80` (damaged) |
| 0 | everything else — the foot units |

**The composite**, in draw order (mode `0x64`, `@0x003BDA` onward):

1. the sprite, through `func_00380C` with layer 1 then layer 2, at
   (`[bp-4]`, `[bp+0xA]`) — class 0 defers layer 1 to after the plate (`@0x003D71`);
2. **the PLATE**: a rect of colour **0** sized `[bp-0x22] × [bp-0x24]` at
   (`[bp-2]`, `[bp-6]`), then a second rect inset by 1 in each axis, sized 2 less in
   each axis, filled with the OWNER colour `[bp-0x0F]` = `[di+0x848]`
   (`@0x003D1C`–`@0x003D66`, both through `0xB9E:0xA`). A black-outlined plate in the
   nation's colour — which is what the port's hand-drawn 7×9 `SACK_ROWS` art stands in
   for today;
3. **the STATUS LETTER**, one character at (`[bp-2]+2`, `[bp-6]+2`) via `0xC11:0xC`,
   in `[bp-0x1F]` = the owner colour ±8 (or `0x0F` / `0x0C` in the special cases at
   `@0x003DBA`–`@0x003DD6`) — skipped entirely when flags bit `0x20` is set;
4. if `[bp-0x18]` (the `+0x3148 & 0x80` state on a non-Artillery) and mode is `0x64`,
   sprite **`0x38`** at (`[bp+0xA]+4`, `[bp-4]+4`) (`@0x003E19`).

**Plate size** is derived from the letter, not fixed: `[bp-0x22] = strwidth(letter) + 3`
(`0xC2A:6` `@0x003AA8`) and `[bp-0x24] = fontheight + 3` (`@0x003ABC`). Flags bit `0x20`
replaces both with 4.

**The letter** `[bp-1]` comes from `[bx+0x54DE]` indexed by the orders byte — the
`-STGLFFBPR---` array already cited in `spec/systems/terrain_improvement.md` — with four
overrides: a non-human owner's ship uses `+0x3150 + 0x30` (`@0x00393B`), a Privateer
under `[0x53A2] == 0` uses `0x58` (`@0x003955`), the AI-debug branch uses `+0x314B`
(or `0x45` when `>= 0x80`, `@0x00397B`), and a unit with `+0x3148 & 0x80` shows its
remaining work as a digit or `+` (`@0x003A3B`–`@0x003A88`).

**`func_00380C`, the two-layer sprite draw (DECODED 2026-08-28).** The verb this
composite draws its sprite through is itself two blits: **layer 1** renders the frame as a
**solid silhouette** in one flat colour — `flags & 4 ? 0x5F : 0`, so black in every
composite path (`@0x003829`–`@0x003834`, through the shape-fill blit `0xCD8:4`) — at
(`x`, `y`); **layer 2** is the real sprite at (**`x + 2`**, `y`) (`lea dx, [di+2]`
`@0x003854`). Every unit panel is therefore a black shadow copy with the sprite two
pixels right of it; class 0 defers layer 1 until after the plate (`@0x003D71`), every
class draws layer 2 last (`@0x003D80`).

**The F7 caller's anchors (BYTE-VERIFIED 2026-08-28).** `func_03954C` sets
`[bp-0x56] = 2` (`@0x03955B`) and enters the composite twice: **ship rows** at
`@0x039843` with `bx = [bp-0x56] = 2` (the row x — the previously FITTED anchor 4 was
compensating for `func_00380C`'s own +2), and **sea-borne land units** at `@0x039574`
with `bx = [bp-0x56] + 0x56 = 88` (the cargo column). Its cargo column draws one crate
per occupied hold — frame `(qty >= 0x64 ? 0x17 : 0x27) + good` (`@0x039605` full /
`@0x0395A8` partial; goods via `0x181F:0xBE6`, quantities via `0xC68`) at `88 + 12k` —
and its location column (`@0x0396A4`, formatter `0x191F:0xF82`) prints the colony NAME
when the ship sits on a colony tile, coordinates only at sea.

**The sheet-header width field settled (measured 2026-08-28).** `es:[bx+0x3E]` (the
runtime 12-byte-stride sheet table) holds the frame's **trimmed width** — on the F7
census an adjustment sweep scores trimmed-w best (0 → 163 px total, −1 → +91, −2 →
+103). With all of the above implemented, census row C4.1 (F7) CLOSED at 163 px (82 of
it the mouse pointer, from 1,635) and C4.27 (the Europe crossing column) dropped
486 → 421 px — the "black plate behind every figure" was `func_00380C`'s silhouette
layer, sitting 2 px left of each capture-pinned sprite position.

## 2. NOT a draw — the `0x35C` correction (B)
**`0x181F:0x35C` → `func_0048CC` is `clamp(v, lo, hi)`**, not a text/sprite verb. Body
(`@0x0048CC`): `dx=[bp+6]` (lo), `ax=[bp+8]` (v), `cmp ax,dx; jge …; mov ax,dx` (max), then
`cmp ax,[bp+0xa]; jle …; mov ax,[bp+0xa]` (min) → returns `max(lo, min(v, hi))`. It **draws
nothing**. Any spec citing `0x35C` as a draw is wrong — see `advisor_reports.md` ("`0x35C`→`0x2BC`
sprite-strip") and `docs/ADVISOR_REPORTS_VICEROY_DECODE.md:246`; those refer to the value being
*clamped before* a subsequent real draw, not a draw itself.

## 3. Notes for the other sheets
- The 10 previously-undocumented verbs (`0x132/0x150/0x18C/0x1AA/0x1FA/0x24A/0x590/0xDAE/0x1468/
  0x18F8`) are now in §1 — no rasteriser-reaching thunk is missing from the vocabulary.
- When a sheet says "draws text via `0x181F:0xNNN`", resolve the colour family here: if the verb is
  in the `002Axx` group the colour is the `[0x830]` latch (find its most-recent set), not a
  per-call arg.
- `0x181F:0x510` is a genuine blit primitive; the open question is *which call site* draws the
  popup frame vs the colony scene (both currently cite site `0x0263D6`) — resolved separately in
  the dialog-framework decode / `popups.md`.


## Amendment 2026-09-02 — `func_00386A` modes 0x32 / 0x19 and the scaled blit `func_00E964` (C4.11)

§1b covers `mode = 0x64`. The mode dispatch @0x003B32–@0x003B44: `mode == 0x64` → the
full panel; `mode − 0x19 == 0` → the 0x19 path; `− 0x19` again `== 0` → the 0x32 path;
anything else → a 2×2 owner-colour box at `(x, y)` (@0x003B46–@0x003B5B → @0x003BB0).
Before the dispatch, for `mode ≠ 0x64`, `0xC83:2` = `func_00EC32` (@0x003B0C) scales the
frame record: `w' = (w·pct + 50) / 100`, `h' = (h·pct + 50) / 100` (unsigned, @0x00EC4D–
@0x00EC72) and `[bp−8] = w'` (@0x003B11), so the shared centring @0x003B23 becomes
`x_c = x + ((W − w') >> 1)` when `W > w'`.

- **0x32** (@0x003B6C–@0x003BD7): box `(x + 5, y + 5)` 2×2 in `[bp−0xF]` = the owner colour
  byte `[0x848 + power]` (@0x003A0A), through `0xB9E:0xA` (@0x003BCF); the sprite through
  `0xC56:4` = `func_00E964` at CENTRE `x_c + (w' >> 1)`, BOTTOM `y + h' − 1`, pct = mode
  (@0x003B94–@0x003BAB). No silhouette, plate or letter. Returns `retf 6` @0x003BD7.
- **0x19** (@0x003B5E): the 2×2 box alone at `(x + 1, y + 1)`.

**`func_00E964 @0x00E964`** (`0x181F:0x2F8`, `0xC56:4`) — args: sheet far ptr, y (bottom),
pct pushed; `ax` frame (negative = mirror, `[bp−0x10] = −1` @0x00E97C–@0x00E98A), `dx` x
(centre), `bx` clip rect. One mask table (@0x00EA00–@0x00EA36): `acc = 0x32; for i < max(w,h):
acc += pct; if acc ≥ 0x64 → keep (0xFF), acc −= 0x64; else drop (0)`, counting `w'` = kept
indices `< w` and `h'` = kept `< h` (@0x00EA1A–@0x00EA25). `x_left = x − (w' >> 1)`
(@0x00EA38–@0x00EA3D), `y_top = y − h' + 1` (@0x00EA41–@0x00EA48). Rows are kept/skipped by
`mask[row]` (@0x00EB1E; a dropped row's RLE is skipped to its 0xFF terminator @0x00EC1B–
@0x00EC26); within a row `mask[col]` (@0x00EB73/@0x00EBB8/@0x00EBE4) selects the source
pixels, the destination advancing only on kept ones (@0x00EB91); 0xFD is transparent
(@0x00EB8A). So 50 % keeps even indices, 25 % keeps 1, 5, 9, …; nearest-neighbour
decimation from a fixed phase. Ports: `rd_blit_scaled` / `sheetFrameScaled` (mirror flag not
modelled — no caller passes one).
