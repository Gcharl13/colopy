# FRONT-END SCREENS — VICEROY.EXE decode (code-anchored)

> Source of truth = **VICEROY.EXE disassembly** (`raw/COLONIZE/VICEROY.EXE`, capstone
> 16-bit). Companion to `docs/EUROPE_SCREEN_VICEROY_DECODE.md` /
> `docs/COLONY_SCREEN_VICEROY_DECODE.md`. Covers the four setup/front-end screens:
> **Opening**, **Nation select**, **Difficulty select**, **Customize New World**.
> Built 2026-06-24. Tiers: **B** byte-verified / **A** anchor / **R** reconstructed / **TBD**.

## 0. Anchors (shared by all front-end screens)

- DGROUP file base = **`0x1D9A0`**; a DGROUP offset `0xNNN` reads at file `0x1D9A0+0xNNN`.
  BSS starts **`DS:0x2CC6`** — anything ≥ that is runtime ⇒ value **TBD** (structure may
  still be B).
- **Two PIK loaders, both append `".PIK"`** (ext string `"PIK"` at DGROUP `0x23FA`/`0x2402`,
  open mode `"rb"` at `0x23FE`/`0x2406`):
  - **`0x191F:0x87A`** = `func@0x076AEC` — used by EUROPE (key `"EUROPE"` DG `0xFBA`) and the
    WOODPANL menu chrome (key `"WOODPANL"` DG `0x2189`/`0x236B`).
  - **`0x181F:0x44E`** = `func@0x076B9E` — **the setup-screen PIK-by-name loader**: strcpy
    the name, append `".PIK"`, open, blit. **This is the loader the three setup screens use.**
    (Verified: all `lcall 0x181F:0x44E` sites and their pushed name pointer — §1a.)
- **Hit-test primitive** = `0x181F:0x3CA` = `func@0x004B16` (**B**): args `(x,y,w,h)` at
  `[bp+6..+0xc]`; returns 1 if mouse **`[0x7E8]`(X) / `[0x7EA]`(Y)** ∈ `[x,x+w)×[y,y+h)`.
- **Text-menu fallback** = `0x181F:0x998` — given a GAME.TXT `@KEY` string ptr + the render
  struct `[0x87C]`, runs a plain list-menu and returns the 1-based chosen index. Used by the
  Nation/Difficulty screens **only when their PIK fails to load** (graceful degrade).
- Common draw thunks: `0x181F:0x444` = filled-rect/blit (`func@0x00DCF6`); `0x181F:0xE2` =
  clipped sprite blit / not a line (`func@0x00DB3A`); `0x181F:0xCE` = highlight box
  (`func@0x00E0A2`); `0x181F:0x100` = text blit (`func@0x002BC8`); `0x181F:0x1C8` =
  centered title text (`func@0x002CE0`); `0x181F:0x16E` = string-index→formatted text
  (`func@0x002992`); `0x181F:0x3B6`/`0x3F4` = save/set clip rect; `0x181F:0x47A` = reset
  mouse latches; `0x181F:0xF6` = poll input; `0x181F:0x3E0` = get key; `0x181F:0x45C` =
  end-screen/teardown. (All resolved with `tools/follow_thunk.py`.)
- Mouse-state globals: **`[0x7E8]`** = X, **`[0x7EA]`** = Y, **`[0x7F4]`** = click latch,
  **`[0x7F0]`/`[0x7F6]`** = event-present flags. (B — read sites cited per screen.)

### 0a. The front-end map at a glance

| Screen | Function | PIK | loader push | selection global | grid |
|--------|----------|-----|-------------|------------------|------|
| Opening / intro | **OPENING.EXE** (separate program) | OPENING.PIK | — | — | §1 |
| Boot / main menu | `func_0759E8` (composer of screen `0x2A` @`0x07661F`) | WOODPANL.PIK + OPENMENU.PIK | `0x236B`/`0x233C` | menu index | §2 |
| Nation select | **`func_070A1A`** | **NATIONS.PIK** | `0x2043` @`0x070A3F` | **`[0x5398]`** (0..3) | 2×2 |
| Difficulty select | **`func_070580`** | **DIFFICUL.PIK** | `0x202D` @`0x0705A5` | **`[0x53A6]`** (0..4) | 3-wide×5 |
| Customize New World | **`func_070060`** | **CUSTOMIZ.PIK** | `0x2022` @`0x070085` | **`[0x1E7E]`** ×4 axes | 4×3 |

### 1a. PIK-by-name load sites — `0x181F:0x44E` (B, verified)

Every `lcall 0x181F:0x44E` site, with the screen-name DGROUP pointer pushed ~16 bytes prior:

| call site | name ptr | string | → PIK |
|-----------|----------|--------|-------|
| `@0x070088` | `0x2022` | `CUSTOMIZ` | **CUSTOMIZ.PIK** (Customize screen) |
| `@0x0705A8` | `0x202D` | `DIFFICUL` | **DIFFICUL.PIK** (Difficulty screen) |
| `@0x070A42` | `0x2043` | `NATIONS`  | **NATIONS.PIK** (Nation screen) |
| `@0x075AE7` | `0x233C` | `OPENMENU` | OPENMENU.PIK (boot menu, §2) |
| `@0x075DA6` | `0x2374` | `OPENMENU` | OPENMENU.PIK (boot sub-menu) |
| `@0x0753A9` | (King) | `KINGLSS` | king screen (`docs/ENDGAME_SCREENS…`) |
| 0x4BD2/0x3737F/0x3AB02/0x3BB6D/0x3DA4A | (other) | — | other PIK-backed screens |

This table overturns an earlier hypothesis that the setup screens reused WOODPANL — **each
loads its own dedicated PIK by name.** The three setup-screen functions
(`func_070060`/`func_070580`/`func_070A1A`) are byte-identical in skeleton (same prologue,
same loader call, same draw-all/event-loop shape); they differ only in PIK key, grid
dimensions, selection global, and per-cell geometry.

---

## 1. OPENING / intro screen — **NOT in VICEROY.EXE** (boundary, B)

The animated opening (MicroProse logo → ship → sea-monsters → "Bonk into land" → opening
logo) is implemented by the **separate launcher program `OPENING.EXE`**, not VICEROY.EXE.

**Byte evidence (B):**
- VICEROY.EXE contains **none** of the opening sprite-sheet names: searching the whole file
  for `OPENING`, `OPENLOGO`, `OPENSUN`, `OPENSHIP`, `OPENMON`, `PATH.DAT` returns **0 hits**.
- `OPENING.EXE` contains the full opening asset list as a contiguous name table at file
  `0x0BFE8`: `PATH.DAT`, `OPENING` (×PIK/TXT), `FONTINTR`, `#SOUND.COL`, **`MPSLOGO`**,
  **`MPSNAME`**, `OPENBORD`, `OPENSHIP`, `OPENCRD0`, `OPENWND1`, `OPENSUN`, `OPENMON1`,
  `OPENWND2`, `OPENMON2`, `OPENMON3`, `OPENFISH`, `OPENGUY`, `OPENLOGO`, `OPENBONK`.
- VICEROY.EXE does **not** spawn/exec OPENING.EXE (no `OPENING.EXE` string; the `VICEROY.EXE`
  string at file `0x19951` is the self-name used in overlay/RTLink memory messages).

**Animation data (B, data-file, not EXE):** `OPENING.TXT` (decoded in
`data_extracted/text/OPENING.full.json`) holds the timing in three sections:
- `@CREDITS` — `start_frame, end_frame, series, sprite` credit roll (e.g.
  `25,50,0,1` MicroProse presentation; `120,135,0,2` Game design by; … `610,625,2,5`).
- `@OPENING` — `Series, Frame, Repeats, BaseX` per animated element:
  `0,78,1,640` Wind 1 · `1,40,0,640` Sun · `2,200,2,320` Monster 1 ·
  `3,248,1,320` Wind 2 · `4,255,1,320` Monster 2 · `5,485,1,320` Monster 3 ·
  `6,502,3,320` Fish · `9,701,0,0` Bonk into land · `7,720,0,0` Guy getting out ·
  `8,767,0,0` Opening logo · `-1,891,0,0` END OF DEMO.
- `@MESSAGES` — `"Loading Game..."`.
- Ship trajectory per frame = `PATH.DAT` (`(x,y)` pairs;
  `docs/COLONIZE_DATA_FILES_INDEX.md`).

**Conclusion:** the opening's exact draw chain / sprite blit coordinates are byte-cited to
**OPENING.EXE offsets**, which is **out of scope for a VICEROY.EXE decode**. Marked as a
clean executable boundary, not guessed. To decode pixel placement, disassemble OPENING.EXE
(the asset table base is `0x0BFE8`; the frame/series numbers above are its data input).

### 1 — remaining TBD
- The opening animation's per-frame sprite blit (x,y) inside **OPENING.EXE** (separate EXE;
  not disassembled here). Inputs are byte-known (`OPENING.TXT` series/frame/baseX + `PATH.DAT`).

---

## 2. Boot / main menu (OPENMENU/BEGINMENU) — `func_0759E8` (composer of screen `0x2A`)

The first VICEROY.EXE screen is the boot menu (screen id `0x2A`, entry stub
`@0x07661F` → `enter_screen_view(bx=0x2A)`; composer = **`func_0759E8`**). Documented here as
the hub that launches the three setup screens (tracker row 8 owns its detail).

**Backdrop + menu (B):**
- `@0x075E00 push 0x236B`("WOODPANL") → `0x191F:0x87A` — wood-panel backdrop (WOODPANL.PIK).
- `@0x075AE4 push 0x233C`("OPENMENU") → `0x181F:0x44E` — OPENMENU.PIK overlay (the
  parchment menu plate), composited at `(0xC8,7,6,…)` via `0x1A1F:0xDF8` line draws.
- Menu items from **`@BEGINMENU`** (GAME.TXT, ptr table built at `[0x2345]`): 5 rows —
  `"Start a Game in NEW WORLD"`, `"Start a Game in AMERICA"`, `"CUSTOMIZE New World"`,
  `"LOAD Game"`, `"View Hall of Fame"`. Title line `"{COLONIZATION} Version %STRING0 …"`.
- Menu-runner = `0x181F:0x3FE` (`func@0x06F594`) `@0x075C64` (push `[0x2345]`=BEGINMENU):
  returns the chosen item index in `ax`; dispatch switch `@0x075C6D` (`dec ax` ladder):
  item→`0x75F8D`(exit)/`0x75DEA`/`0x75EB0`/`0x75C86`(NEW WORLD start).
- Hall of Fame branch `@0x075EBC` = `0x191F:0xF8E` (`func@0x03ADA6`, push 0).
- "CUSTOMIZE" and the New-World start flow lead into the three setup screens below
  (the `[0x1E7E]` defaults array is pre-seeded here `@0x075C8E`–`0x075CC2`, value 1 ×5).

> The boot menu is tracker row 8; only its role as the setup-screen launcher is decoded here.

---

## 3. NATION SELECT — `func_070A1A` (loads **NATIONS.PIK**)

### 3.1 Entry + PIK load (B)
```
func_070A1A @0x070A1A   enter 0x314
  @0x070A2B  [0xA60A] = 0            ; active-cell cursor = 0
  @0x070A3F  push 0x2043 ("NATIONS")
  @0x070A42  lcall 0x181F:0x44E      ; load + blit NATIONS.PIK (→func@0x076B9E)
  @0x070A4A  if load OK → jmp paint (0x070A7A); else text-menu fallback:
  @0x070A4E  [0x1F5C] = 4            ; 4 nations
  @0x070A58  lea ax,[0x204B]("PICKNATION"); 0x181F:0x998  ; @PICKNATION list-menu
  @0x070A74  [0x5398] = result-1     ; store nation index, then exit
```
- **Selection global = `[0x5398]`** (nation index 0..3). **B.**
- `[0x1F5C]=4` (`@0x070A4E`) and the loop cap `[0x201E]?5:4` (`@0x070B9F`) bound the count.

### 3.2 Paint (B)
- `@0x070A7A` save clip (`0x181F:0x3B6`) → set clip to PIK rect (`0x181F:0x3F4`, rect
  `[0x839E..0x83A4]`, runtime **TBD** values).
- `@0x070AB3` filled-rect **(0,0,320,200)** (`0x140`×`0xC8` @`0x070AAA`/`0x070AB0`) +
  `@0x070AC5` clipped sprite blit (0,0,320,200) — composites the NATIONS.PIK backdrop.
- `@0x070ACB call 0x70C3C` → `0x1A1F:0xBE2` = **draw-all** (title + 4 nation cells).
- `@0x070ACE` reset mouse latches (`0x181F:0x47A`).

### 3.3 Per-nation cell geometry (B) — rect helper `func@0x07078D` (`0x1A1F:0xBC8`, via `0x70C5A`)
For nation index `i` (0..3), the cell origin is computed as a **2×2 grid**:
- **x = (i mod 2)·`0x63`(99) + `0x70`(112)** ⇒ columns at **x=112, 211** (`@0x07079C`/`0x07079F`).
- **y = (i div 2)·`0x5B`(91) + `0x0D`(13)** ⇒ rows at **y=13, 104** (`@0x0707A7`/`0x0707AA`).
- Cell hit size: pushes `0x52`(82) and `0x58`(88) (`@0x070BC0`/`0x070BC2`, §3.5) — **arg labels CORRECTED by Phase-3 pixel diff (2026-07-31): on screen the cell is 88 WIDE x 82 TALL** (the highlight rect in the live capture starts at (112,13) and extends 88x82; the spec-as-written 82x88 mis-fits by 98.8%->99.9% swap test). The w/h labeling of the hit/draw primitive's args in §0 was transposed; the *values* are right.

| nation | @GAME.TXT | row src | cell (x,y) | w | h |
|--------|-----------|---------|-----------|---|---|
| 0 England | `@PICKNATION`/`@NATION0A` | runtime str (TBD) | (112,13) | 82 | 88 |
| 1 France  | `@PICKNATION`/`@NATION1A` | runtime str (TBD) | (211,13) | 82 | 88 |
| 2 Spain   | `@PICKNATION`/`@NATION2A` | runtime str (TBD) | (112,104) | 82 | 88 |
| 3 Netherlands | `@PICKNATION`/`@NATION3A` | runtime str (TBD) | (211,104) | 82 | 88 |

(Labels England/France/Spain/Netherlands = `@PICKNATION` rows; the leader/portrait per cell
is the `@NATIONnA` block. The string-index→text binding is fetched at runtime via the
draw-cell `0x181F:0x16E`/`0x100` path ⇒ **literal text TBD**, layout B.)

### 3.4 Keyboard navigation (B)
Event loop `@0x070B26`+. Arrow keys (scancodes `0x148`↑/`0x150`↓/left/right) rotate the
selection **mod 4**: `@0x070B40 ax=3 ; [0x5398]=(sel+3)%4` (prev) or `+1)%4` (next)
(`@0x070B4D`–`@0x070B57`), redrawing the old + new cell via `0x70C5F` (draw-cell).

### 3.5 Hit-rects — point-in-rect `0x181F:0x3CA` (B)
Loop `[bp-4]=0..(4 or 5)` `@0x070B9F`:
```
@0x070BC0  push 0x52 (w=82) ; push 0x58 (h=88)
@0x070BC4  push cellX ; push cellY        (from rect helper 0x70C5A)
@0x070BCA  lcall 0x181F:0x3CA             ; hit-test cell i
  → on hit: [0x5398] = i, redraw old+new cell, continue
@0x070BFC  if [0x7F4](click) && [0x7E8](mouseX) < 0x70 (112) → [bp-0xA]=0 (commit/exit)
```
| hit-id | rect (x,y,w,h) | action |
|--------|----------------|--------|
| nation i (0..3) | (col·99+112, row·91+13, 82, 88) | set `[0x5398]=i` |
| commit | click & mouseX<112 (left margin / OK zone) | leave screen, return chosen `[0x5398]` |

### 3.6 Fonts / colors
Cell text via draw-cell (`0x181F:0x100`); title via `0x181F:0x1C8`. Font handle + ink come
from render struct `[0x87C]` and the draw-cell's color byte (the active cell gets a
highlighted ink, mirror of the Customize cell logic §5.4) — **exact color bytes TBD** (read
sites: draw-cell `func@0x070302`-family; `[0x87C]` font descriptor is BSS). **A.**

### 3 — remaining TBD
- Per-nation **label/leader string literals** (runtime `@PICKNATION`/`@NATIONnA` fetch).
- Nation **icon/portrait sprite index** per cell (drawn inside draw-cell from the loaded PIK
  metadata — runtime).
- **Font id + cell ink colors** (render struct `[0x87C]`, draw-cell color byte) — BSS.
- Clip/PIK rect `[0x839E..0x83A4]`, `[0x2DA8..0x2DAE]` — BSS.

---

## 4. DIFFICULTY SELECT — `func_070580` (loads **DIFFICUL.PIK**)

### 4.1 Entry + PIK load (B)
```
func_070580 @0x070580   enter 0x312
  @0x070591  [0xA60A] = 0                      ; cursor
  @0x0705A5  push 0x202D ("DIFFICUL")
  @0x0705A8  lcall 0x181F:0x44E                 ; load + blit DIFFICUL.PIK
  @0x0705B0  if load OK → jmp paint (0x0705D8); else text-menu fallback:
  @0x0705B4  lea ax,[0x2036]("DIFFICULTY"); 0x181F:0x998  ; @DIFFICULTY list-menu
  @0x0705D2  [0x53A6] = result-1               ; store difficulty level, then exit
```
- **Selection global = `[0x53A6]`** (difficulty level 0..4). **B.**
- `@DIFFICULTY` (GAME.TXT) = 5 levels: Discoverer / Explorer / Conquistador / Governor /
  Viceroy. (The data parser also caches the 5 level-name pointers at runtime table
  `DS:0x8394`, 5 words, loaded `@0x074C87`–`@0x074CAE` with `cmp …,5`; values BSS ⇒ TBD.)

### 4.2 Paint (B)
- `@0x0705D8` save/set clip (`0x181F:0x3B6`/`0x3F4`).
- `@0x070611` filled-rect (0,0,320,200) + `@0x070623` sprite blit (0,0,320,200) — DIFFICUL.PIK.
- `@0x070628 call 0x70C64` → `0x1A1F:0xBF2` = **draw-all**: title at y≈4 (`@0x0704B3 add ax,4`),
  then the 5 level cells.
- `@0x07062C` reset mouse latches.

### 4.3 Per-level cell geometry (B) — rect helper `func@0x0702C0` (via `0x70C46`/`0x1A1F:0xB90`)
For level `i` (0..4), `idx=i+1` is split by **3** (`cx=3` @`0x0702C9`; `idiv` twice):
- **x = (idx mod 3)·`0x69`(105) + `0x17`(23)** (`@0x0702DA`/`0x0702DD`).
- **y = (idx div 3)·`0x60`(96) + 7** (`@0x0702F2`/`0x0702F7`), with a **−1** row adjust when
  row>1 (`@0x0702E5`).
- Cell hit/fill size: pushes `0x5A`(90) and `0x44`(68) (`@0x06FD…`/draw-cell `@0x07033A`/`0x070342` — **arg labels CORRECTED by Phase-3 pixel diff (2026-07-31): on screen the cell is 68 WIDE x 90 TALL** (spec-as-written would run x=233+90=323 off the 320px screen; the swapped rect matches the capture at 99.96%);
  hit-test `@0x0706FD`).

⇒ a **3-wide layout** for 5 cells (row0: idx1,2 → cols 1,2; row1: idx3,4,5 → cols 0,1,2,
i.e. the 5 levels wrap across a 3-column grid; exact base/wrap as above). Cells filled by
draw-cell `func@0x070302` (`0x1A1F:0xBAC`).

### 4.4 Keyboard navigation (B)
`@0x070692`: up = `(level+4)%5`; `@0x0706C8`: down = `(level+1)%5` (wrap **mod 5**), storing
into `[0x53A6]` and redrawing old+new cell (`0x70C50` = draw-cell). Arrow scancodes matched
at `@0x0706CC` (`0x148`/`0x150`/etc.). ESC (`0x1B`) handled in the key switch (exit).

### 4.5 Hit-rects — point-in-rect `0x181F:0x3CA` (B)
Loop `[bp-0xE]=0..4` `@0x0706E5`:
```
@0x0706FD  push 0x5A (w=90) ; push 0x44 (h=68)
@0x070701  push cellX ; push cellY            (rect helper 0x70C46)
@0x070707  lcall 0x181F:0x3CA                 ; hit-test level i
  → on hit: [0x53A6] = i, redraw old+new cell
@0x07073A  if [0x7F4](click) && [0x7EA](mouseY) < 0x67 && [0x7E8](mouseX) < 0x80
           → [bp-8]=0 (commit/exit)
```
| hit-id | rect (x,y,w,h) | action |
|--------|----------------|--------|
| level i (0..4) | (col·105+23, row·96+7[−1 if row>1], 90, 68) | set `[0x53A6]=i` |
| commit | click & mouseY<103 & mouseX<128 (top-left zone) | leave, return `[0x53A6]` |

### 4.6 Fonts / colors (A)
Draw-cell `func@0x070302` fills the cell (`0x181F:0x444`, 90×68) then selects a per-level
**ink via a switch** on the level index (`@0x07034A` `dec ax` ladder → cases `0x7035C`/`62`/`68`/`6E`/`74`),
default color byte `0x0A` (`@0x07035C mov byte[bp-0x58],0xA`). Exact per-case color bytes
**TBD** (need each case's `mov byte[bp-0x58],imm`); font from `[0x87C]`.

### 4 — remaining TBD
- The 5 **level-name string literals** (runtime `@DIFFICULTY`; pointer table `DS:0x8394`, BSS).
- Per-level **ink color bytes** (draw-cell switch cases) and **font id** (`[0x87C]`).
- Title blit (x,y) — runtime text-box; PIK/clip rects `[0x839E..]`/`[0x2DA8..]` — BSS.

---

## 5. CUSTOMIZE NEW WORLD — `func_070060` (loads **CUSTOMIZ.PIK**)

### 5.1 Entry + PIK load (B)
```
func_070060 @0x070060   enter 0x312
  @0x070071  [0xA60A] = 0                      ; active-axis cursor
  @0x070085  push 0x2022 ("CUSTOMIZ")
  @0x070088  lcall 0x181F:0x44E                 ; load + blit CUSTOMIZ.PIK
  @0x070092  if load fails → jmp exit (0x702AA)
  @0x070097  save/set clip (0x181F:0x3B6 / 0x3F4)
  @0x0700D0  filled-rect (0,0,320,200) ; @0x0700E2 sprite blit (0,0,320,200)
  @0x0700E7  call 0x70C55 (→0x1A1F:0xBBA) = draw-all (title/divider/finish/grid)
  @0x0700EB  reset mouse latches (0x181F:0x47A)
```
- It is a **4-axis × 3-value selector grid** + a "Click Here When Finished" exit.

### 5.2 Draw-all `func@0x06FF94` (B)
1. `@0x06FF9C` title string-index from BSS `[0x2EFA]` (→ "CUSTOMIZE NEW WORLD"); format
   `0x181F:0x16E`.
2. `@0x06FFBE` draw title `0x181F:0x1C8` — ink **`0xFD`**, bg **`0xFE`** (`@0x06FFAC`/`AF`),
   **y=4**, x=0, **w=0x140 (centered)**.
3. `@0x06FFD2` divider sprite `0x181F:0xE2` at **y=0x10 (16)**, w=0x140.
4. `@0x06FFE7` finish string-index from BSS `[0x2EFC]` (→ "Click Here When Finished").
5. `@0x070013` draw finish text `0x181F:0x100` at **y=0xBE (190)**, x=0, w=0x140.
6. `@0x07002A` divider line `0x181F:0xE2` at **y=0xB7 (183)**, w=0x140.
7. `@0x07002F`–`@0x07005E` nested loop **col 0..3 × row 0..2** → draw-cell `func@0x06FE1C`.

### 5.3 Grid geometry (B) — rect-compute `func@0x06FDF0` (`0x1A1F:0xB82`, via `0x70C41`)
For axis-column `col` (0..3) and value-row `row` (0..2):
- **x = col·`0x4C`(76) + `0x0A`(10)** (`@0x06FDF3`/`@0x06FDF7`) ⇒ x = 10, 86, 162, 238.
- **y = row·`0x3C`(60) + `0x10`(16)**, **−1 when row>1** (`@0x06FDFF`/`@0x06FE0C`/`@0x06FE12`)
  ⇒ y = 16, 76, 135.
- Cell box **w=`0x30`(48), h=`0x48`(72)** (fill `@0x06FE56`; hit `@0x070201`).

| axis col | x | LABELS axis (@MISCELLANEOUS) | values (rows 0/1/2) |
|----------|---|------------------------------|----------------------|
| 0 | 10  | "Land Mass" (idx 144) | Small / Moderate / Large |
| 1 | 86  | "Land Form" (idx 145) | Archipelago / Normal / Continents |
| 2 | 162 | "Temperature" (idx 146) | Cool / Temperate / Warm |
| 3 | 238 | "Climate" (idx 147) | Arid / Normal / Wet |

(Rows at y=16/76/135; cell 48×72. Title "CUSTOMIZE NEW WORLD" = LABELS idx 160; finish
"Click Here When Finished" = idx 161. **String literals are LABELS @MISCELLANEOUS runtime
fetches** — index tables in BSS `[0x2EDA]`(4 axes)/`[0x2EE2]`(12 values)/`[0x2EFA]`(title)/
`[0x2EFC]`(finish), populated at runtime ⇒ index→string binding **TBD**, layout B.)

### 5.4 Per-cell draw `func@0x06FE1C` (B)
- `@0x06FE61` fill cell (`0x181F:0x444`, 48×72).
- `@0x06FE66` text ink **`0x0A`** default; **`0x0E`** if this is the **active axis**
  (`cmp [0xA60A]` @`0x06FE72`).
- `@0x06FEB1` highlight box (`0x181F:0xCE`) drawn for the **selected value** only
  (when `[col·2+0x1E7E] == row`).
- `@0x06FECE` axis label: index from BSS `[col·2+0x2EDA]`, format `0x181F:0x16E`, strcat
  `":"` (DG `0x2020`, `0xD1D:0x7A4`), draw `0x181F:0x100`.
- `@0x06FF3E` value label: index from BSS `[(col·3+row)·2 + 0x2EE2]`, draw `0x181F:0x100`.

### 5.5 Selection globals & per-axis logic (B)
- **Per-axis selected value = word array at DGROUP `0x1E7E`** (4 entries, index `axis·2`).
  This is **initialized data** (< BSS) — static bytes = **[1,1,1,1]** ⇒ default = middle
  value (Moderate / Normal / Temperate / Normal) for all four axes. **B.**
- **Active-axis cursor = `[0xA60A]`** (init 0 @`0x070071`).
- Keyboard (loop `@0x0700F5`, key via `0x181F:0x3E0`):
  - `0x1B` ESC (`@0x070121`) → exit `0x702AA`.
  - up/left family (`@0x070158`): axis `(axis+3)%4`; value `(v+2)%3` (`@0x070198`).
  - down/right family (`@0x070192`/`@0x0701CA`): axis `(axis+1)%4`; value `(v+1)%3`.
  - On change → redraw old+new cell (`0x70C4B`).

### 5.6 Hit-rects — point-in-rect `0x181F:0x3CA` (B)
| hit-id | rect (x,y,w,h) | action |
|--------|----------------|--------|
| grid cell (col,row) | (col·76+10, row·60+16[−1 if row>1], 48, 72) | set `[col·2+0x1E7E]=row`, focus `[0xA60A]=col`, redraw (test loop `@0x0701E0`–`@0x070269`, hit `@0x07020B`) |
| **Click Here When Finished** | click `[0x7F4]` AND mouseY `[0x7EA]` ≥ `0xB9` (185) (`@0x07027E`) | `[bp-6]=0` → exit loop (finish) |

The finish "button" is a **y-threshold** test (clicked AND below y=185, matching finish text
y=190 / divider y=183), not a point-in-rect call.

Exit `@0x0702AA`: restore clip (`0x181F:0x3B6`), set clip to VGA (`push 0xA000,0xFC00`;
`0x181F:0x3F4`), return `[bp-4]` (**1 = finished, 0 = ESC**).

### 5.7 Fonts / colors (B/A)
- Title ink **`0xFD`** / bg **`0xFE`** (`@0x06FFAC`/`AF`).
- Cell value ink **`0x0A`** normal, **`0x0E`** for the active-axis column (`@0x06FE66`/`72`).
- Finish text bg **`0xFE`**. Font handle from `[0x87C]` (descriptor in BSS) — **font id TBD**.

### 5.8 Difficulty / Power sub-selectors inside Customize (A)
Customize also exposes Difficulty + European-Power pickers, drawn by **sibling pop-up
functions** `func_070302` (`@0x070302`, frame `0x58`) and `func_070494` (`@0x070494`, frame
`0x62`) — they reuse the finish string `[0x2EFC]` and a single-column cell helper
(`0x70C46`→`0x1A1F:0xB90`). Full decode of those two pop-ups is a follow-up pass (geometry
shape known; per-row contents TBD).

### 5 — remaining TBD
- LABELS string-index→literal bindings in BSS `[0x2EDA]`/`[0x2EE2]`/`[0x2EFA]`/`[0x2EFC]`.
- **Font id** (`[0x87C]`); the per-cell highlight-box color (`0x181F:0xCE` arg).
- The two sub-selector pop-ups `func_070302`/`func_070494` (Difficulty/Power within Customize).
- PIK/clip rects `[0x839E..0x83A4]`/`[0x2DA8..0x2DAE]` — BSS.

---

## 6. Cross-screen verification summary

- **VERIFIED (B):** the four-screen map (§0a); each setup screen's **dedicated PIK load by
  name** via `0x181F:0x44E` (§1a — CUSTOMIZ/DIFFICUL/NATIONS.PIK), with a `0x181F:0x998`
  text-menu fallback keyed on `@DIFFICULTY`/`@PICKNATION`; full **paint chain** (clip →
  320×200 fill → 320×200 PIK blit → draw-all) for all three; **per-cell geometry** (Nation
  2×2 @ x{112,211}/y{13,104} 82×88; Difficulty 3-wide×5 @ col·105+23/row·96+7 90×68;
  Customize 4×3 @ col·76+10/row·60+16 48×72); **keyboard nav** (mod-4 / mod-5 / mod-3);
  **hit-rects** (`0x181F:0x3CA`, `[0x7E8]`/`[0x7EA]` mouse) + commit/finish zones;
  **selection globals** (`[0x5398]` nation, `[0x53A6]` difficulty, `[0x1E7E]` customize
  axes); **Customize colors** (title `0xFD`/`0xFE`, cell `0x0A`/`0x0E`).
- **Opening RESOLVED as an EXE boundary (B):** the opening animation lives entirely in
  `OPENING.EXE` (asset table @ file `0x0BFE8`; VICEROY.EXE has none of its sprites) with
  timing in `OPENING.TXT` + `PATH.DAT`. Its pixel placement is an OPENING.EXE decode, out of
  scope here.
- **Earlier hypothesis corrected:** the setup screens do **not** reuse WOODPANL; that was a
  premature conclusion from an immediate-only scan. The dedicated PIK loads are byte-proven
  in §1a. `func_07431E` (WOODPANL, `[0x5398]`, 4 PowerRecords `[0x8832]`/`0x13C`) is the
  **multiplayer power/seat-assignment** setup, a different screen from the single-player
  Nation picker `func_070A1A`.

### Per-screen remaining TBD (consolidated)
- **Opening:** all pixel placement (separate OPENING.EXE; inputs byte-known).
- **Nation:** label/leader literals, per-cell icon sprite, font/ink, clip rects (all runtime/BSS).
- **Difficulty:** 5 level literals (`DS:0x8394`), per-level ink switch cases, font, title blit, clip rects.
- **Customize:** LABELS index→literal bindings, font id, highlight-box color, the two
  Difficulty/Power sub-pop-ups (`func_070302`/`func_070494`), clip rects.

---

## Phase-3 render-and-diff verdicts (2026-07-31) — nation & difficulty screens

Both screens were rebuilt purely from this doc + original assets and pixel-diffed against the
live captures (`docs/screens/02/03_*.png`, de-scaled from 2× nearest-neighbor 640×400-in-1024×768,
RGB565-quantized capture path). Result: **99.96% (difficulty) / 99.86% (nation) identical**
(cursor excluded). Artifacts: `docs/screens/reports/phase3_frontend/`.

**Confirmed (pixel-exact):** PIK identity + full-screen composite (each screen uses its OWN
embedded PIK palette; the two differ at 157 indices); grid origin math (difficulty (idx%3)·105+23 /
(idx//3)·96+7; nation (i%2)·99+112 / (i//2)·91+13); label literal sources (@DIFFICULTY row
uppercased+':'; @PICKNATION row uppercased+':'); the MADSPACK/FAB/.FF codecs and the 2026-07-28
`ch−1` glyph ruling (glyph-exact text); advance = glyph width.

**Falsified/corrected:** (1) cell w/h arg labels transposed (see §3/§4 corrections above);
(2) §4.2 "title at y≈4" is not an absolute — measured title tops y=16/29 (difficulty),
y=36/49 (nation).

**Measured (previously TBD — now measured facts, still needing byte-citation to be B):**
titles = LABELS.TXT `@MISC` rows 162/163 ("Choose"/"Difficulty Level") and 170/171
("Select"/"European Power"), FONTINTR, centered over the LEFT margin column (~x 0..112), inks
level1=254 (80,148,48) / level2=253 / level3=0; finish prompt "(Click Here When Finished)" =
`@MISC` 161 + parens, FONTTINY ink 254, y=81 (difficulty) / y=182 (nation) — present on BOTH
screens (draw-all descriptions omitted it); per-level second label = `@MISC` 165–169
(Easiest..Toughest); per-nation trait label = `@MISC` 173–176 (Immigration/Cooperation/
Conquest/Trade) at cell bottom; selection highlight = 1px outline, ink 9 (blue) difficulty /
12 (red) nation; cell labels drawn with black shadow at (1,0),(0,1),(1,1).
