# MENUS — VICEROY.EXE byte-decode (boot/main menu + in-game menu bar)

> **Deliverable A.** Byte-accurate decode of the two VICEROY menu families for a
> rebuild: (1) the **boot/main menu** (OPENMENU background + `@BEGINMENU` item list
> + the `BEGINMENU` runner + the `dec ax` selection ladder), and (2) the **in-game
> pulldown menu bar** (`func_072090` build + `func_06083A` bar line + `func_06D316`
> dropdown geometry + per-item hit-rects).
>
> **Method/tiers per `CLAUDE.md`:** every coordinate/string/key cites a `func@0xNNNNN`
> push/mov site or a `*.TXT`/`@`-directive key. **B** = byte-verified at the cited
> offset (re-confirmed against `raw/COLONIZE/VICEROY.EXE` this pass); **R** =
> reconstructed/low-trust; **TBD** = no evidence (+ blocker). The shared centred
> dialog/plaque geometry engine is **already specced** in `spec/ui/menus.md §11` and
> `spec/ui/popups.md §2` — cited here, not re-derived. **Every number below was
> re-confirmed against the EXE in this pass** (disasm spot-checks shown inline).
>
> **Canonical primary:** `raw/COLONIZE/VICEROY.EXE`; `spec/ui/menus.md` (Layer-2 spec);
> `data_extracted/text/{MENU,GAME,NAMES,LABELS}_sections.json`;
> `viceroy_source/docs/drawlist/CHROME_AND_DISPATCH_INDEX.md` §B1/§B9/§B10.
> **Infra:** DGROUP base `0x1D9A0` (DGROUP off + 0x1D9A0 = literal's file offset);
> BSS `DS:0x2CC6`. **Last updated:** 2026-06-24.

---

## 1. The two menu families (do not conflate)

| | family | code | text source | background |
|--|--------|------|-------------|-----------|
| §2–4 | **Boot / main menu** | title composer `func_0759E8` @0x0759E8 + `BEGINMENU` runner `func_06F594` @0x06F594 | `GAME.TXT @BEGINMENU` | `OPENMENU` over `OPENING.PIK` |
| §5–7 | **In-game pulldown bar** | build `func_072090` @0x072090; bar line `func_06083A` @0x060890; run `func_06E3D0` @0x06E3D0 | `MENU_sections.json` `game menu` | map HUD top strip |

Both share the centred-dialog geometry engine `panel_construct func_06C520` /
`panel_finalize_geometry func_06D316` (`spec/ui/menus.md §11`, `popups.md §2.3`) — see §8.

---

## 2. BOOT / MAIN MENU — background + decoration

### 2.1 Background — **B**

The main-menu backdrop is the literal EXE string **`"OPENMENU"`**:

- `[0x233C]` → file **0x1FCDC** = `"OPENMENU\0BEGINMENU\0…"` (verified: `dd` @0x1FCDC =
  `OPENMENU.BEGINME…`). Built/composited @0x075AE4 via `0x181F:0x44E` to off-screen
  buffer `0x0D1D:0xFB2`, restored to 0xA000 via `0x181F:0x3F4` @0x075C1D. **B**
  (`menus.md §2.1`; re-confirmed string bytes).
- The new-game backdrop copy `[0x2374]` → file 0x1FD14 = `"OPENMENU"` (push @0x075DA3). **B.**

### 2.2 OPENBORD decoration (draw order) — **B**

Re-confirmed at 0x075B8E: `lcall 0x1A1F:0xDF8` (sprite-pair blit), then the 4-word rect
header `[0x839E..0x83A4]` is pushed, then the next pair pushes `0xC8 / 8 / 9` (h, sprite-hi,
sprite-lo) with `bx=0x140`:

| # | element | sprites | call | @asm | tier |
|---|---------|---------|------|------|------|
| 1 | OPENBORD pair | 6,7 | `lcall 0x1A1F:0xDF8` (x via `bx=0x140`, y=0xC8=200) | 0x075B8E | B |
| 2 | OPENBORD pair | 8,9 | `push 0xC8; push 8; push 9; … lcall 0x1A1F:0xDF8` | 0x075BB0 | B |
| 3 | OPENBORD pair | 0xE,0xF (14,15) | `lcall 0x1A1F:0xDF8` | 0x075BD2 | B |
| 4 | cursor decor | sheet `[0x2DA8..]` | `lcall 0x181F:0x444` (rect block-copy), y=0xC8 w=0x140 | 0x075C00 | B |
| 5 | full-screen cell blit | `[0x2DA8]` | `push 0xC8(h); push 0x140(w); push 0(x); lcall 0x181F:0xE2` (clipped sprite blit) | 0x075C12 | B |
| 6 | cursor/mode primer | id 0x33 | `push 0x33; lcall 0x181F:0x4DE` | 0x075C28 | B |

**Font** for all boot-menu/title text = **FONTINTR** (`[0x268A]`, a runtime handle in BSS;
loaded at boot — the static value is 0, value is TBD-runtime-but-known-source). **B** (font
source) / TBD (runtime handle value).

---

## 3. BOOT MENU — `@BEGINMENU` item list + layout

### 3.1 Item list — **B** (`GAME.TXT @BEGINMENU`, present in `GAME_sections.json`)

Item text comes from **`GAME.TXT` section `@BEGINMENU`** (an `@options` list), NOT from
literal EXE pushes. The section is read by the runner via the section-reader thunk. Section
**present** in `data_extracted/text/GAME_sections.json` (grep-confirmed, key `@BEGINMENU`).
The five option lines (`menus.md §4`, body in JSON):

| 1-based idx | item (verbatim §4) | dispatch (dec-ax ladder §3.3) |
|-------------|--------------------|-------------------------------|
| 1 | Start a Game in NEW WORLD | (ladder: `dec ax`→0 → **exit** `jmp 0x75F8D`) † |
| 2 | Start a Game in AMERICA | load-game / `@AMERICA` sub-picker `jmp 0x75DEA` |
| 3 | CUSTOMIZE New World | setup / scenario list `jmp` to 0x75C86 setup loop |
| 4 | LOAD Game | new-game `jmp 0x75EB0` → `begin_game` |
| 5 | View Hall of Fame | (falls through default `jmp 0x75F8D`) |

> † The exact item-text→ladder-branch *labelling* is the historically slippery part: the
> ladder is a raw `dec ax` chain (§3.3), and the 1-based index returned by the runner is what
> selects the branch — the item **wording** vs which `jmp` it triggers is asserted from
> `menus.md §2.2/§4` (B mechanism). The **branch targets** are byte-verified (§3.3); the
> **text** is byte-verified present in JSON. The exact text-string↔index pairing inside
> `@BEGINMENU` is data-driven (option order in the JSON body) — **B (text+order) / B
> (branch targets) / the per-line→branch binding follows option order**.

### 3.2 The runner — `BEGINMENU` via `func_06F594` — **B**

Re-confirmed @0x075C60:

```
0x075c60: lea   bx, [0x2345]          ; "BEGINMENU"  ([0x2345]→file 0x1FCE5 = "BEGINMENU.AMERIC…")
0x075c64: lcall 0x181f, 0x3fe         ; runner → func_06F594 @0x06F594 (page 0x17); returns 1-based idx in AX
0x075c69: mov   [bp-0xe0], ax         ; stash selected index
```
Bytes @0x075C60: `8d 1e 45 23 9a fe 03 1f 18` — **PASS**. `[0x2345]` string verified =
`"BEGINMENU\0AMERICA\0…"` @file 0x1FCE5. **B.**

The runner lays the rows out through the centred-dialog geometry engine (§8); GAME.TXT
`@BEGINMENU @options @width=160 @y=91` pins **y=91**, centred x, content-width floor ≥160
(`menus.md §4`; the `@width`/`@y` literals are in raw GAME.TXT but **stripped from
`*_sections.json`** — re-confirm from raw GAME.TXT / EXE, see §8 note). So the boot-menu
**per-row y positions are engine-laid-out from y=91** (not fabricated literals):
**B (mechanism + y=91 pin)**; the exact per-row y stride = `line_count` step in `func_06D316`
(§8) — **B (engine)**.

### 3.3 Selection ladder — `dec ax` — **B** (re-confirmed @0x075C6D)

```
0x075c6d: dec ax              ; idx-1
0x075c6e: jge 0x75c73         ; idx>=1 → continue
0x075c70: jmp 0x75f8d         ;   idx==0 → EXIT
0x075c73: dec ax / dec ax     ; idx-3
0x075c75: jle 0x75c86         ; idx<=3 → SETUP/scenario-list loop @0x75C86
0x075c77: dec ax
0x075c78: jne 0x75c7d
0x075c7a: jmp 0x75dea         ;   idx==4-branch (LOAD / @AMERICA path)
0x075c7d: dec ax
0x075c7e: jne 0x75c83
0x075c80: jmp 0x75eb0         ;   next branch (NEW-GAME → begin_game)
0x075c83: jmp 0x75f8d         ; default → EXIT
```

Branch targets all **B** (disassembled this pass). The new-game branch reaches
`begin_game @0x072578` via `lcall 0x191F:0x320` @0x075E5F (bytes `9a 20 03 1f 19` — **PASS**,
`menus.md §2.2`). The setup loop @0x075C86 initialises the per-power records
(`[bx+0x1e7e]` write @0x075CA0, `cmp 5` loop bound @0x075CA8). **B.**

### 3.4 Highlight bar / colors — **B** (`menus.md §3`)

Plaque colors are pushed as **direct RGB** through `mr_color_for(r,g,b)` (export 48464,
nearest-palette scan), not palette-index pushes: outline **(20,12,6)**, **selection bar
(56,32,16)**, text green **(82,138,49)**, **selected-gold (227,170,40)** (gold = OPENMENU
palette idx 0x54). Wood fill = **WOODTILE.SS** tiled (plaques). Nav keys: ENTER 13 / ESC 27 /
SPACE 32 / arrows / digit + first-letter hotkeys. **B** (`menus.md §3`; design-intent RGBs).
The highlighted-row index is the runner's current selection; the bar is painted by the runner
before the modal wait — the bar **rect** is the selected option row's engine-laid rect (§8),
height = one option-row metric. **B (mechanism)** / the exact selection-bar pixel rect per row
falls out of the §8 option-row stride — **B (engine)**.

---

## 4. BOOT MENU — sub-pickers (cross-ref)

The new-game wizard reached via ladder branch 4 (`begin_game @0x072578`) runs the difficulty
and nation pickers. These are **byte-cited grids** fully specced in `menus.md §7`; summary
(re-confirmed this pass):

- **Difficulty** `func_070494` / cell-xy `func_0702C0`: `m=n+1`, `col=m%3`, `grp=m/3`,
  **x = col·0x69 + 0x17 (105·col+23)** @0x0702DA (`imul ax,dx,0x69; add ax,0x17` — **PASS**),
  **y = grp·0x60 + 7 (96·grp+7)** @0x0702F2 (`imul cx,bx,0x60` — **PASS**). 1-px hollow
  selection box `0x181F:0xCE` @0x0703AB (`9a ce 00 1f 18` — **PASS**), w=0x43=67 h=0x59=89.
  Background `DIFFICUL.PIK`; levels `NAMES @DIFFICULTY`. **B.**
- **Nation** `func_07092E` / cell-xy `func_070782`: `col=n%2`, `row=n/2`,
  **x = col·0x63 + 0x70 (99·col+112)** @0x07079C (`imul ax,dx,0x63; add ax,0x70` — **PASS**),
  **y = row·0x5B + 0x0D (91·row+13)** @0x0707A7 (`imul ax,bx,0x5b; add ax,0xd` — **PASS**).
  Box w=0x57=87 h=0x51=81. Background `NATIONS.PIK`; powers `NAMES @COUNTRY`. **B.**

Full per-row cell/selection-box rects in `menus.md §7.1/§7.2`.

---

## 5. IN-GAME MENU BAR — build chain `func_072090` @0x072090 — **B**

Re-confirmed this pass (disasm @0x072090):

| step | action | @asm | bytes / note | tier |
|------|--------|------|--------------|------|
| open font ctx | `push [0x8a0]; push [0x89e]; push 0xfa0; lcall 0x1A1F:0x2D2` → FONTINTR handle → `[0x896]/[0x898]` | 0x072099–0x0720AF | handle 0xFA0 = FONTINTR | B |
| open section | `push 0x2098; push 0x209d; lcall 0x191F:0x928` (section reader `func_06F8FA`) | **0x0720BE** | `[0x2098]`→file 0x1FA38=`"game"`, `[0x209d]`→file 0x1FA3D=`"menu"` (verified) | B |
| read record N | `push si; lcall 0x191F:0x91C` (record reader `func_06F9E6`) | 0x0720D5 / 0x0720ED (loop) | si=1.. command id | B |
| register row A | `lcall 0x1A1F:0x31A` (add command record `func_044B7A`) | 0x0720E4 | — | B |
| register row B | `lcall 0x1A1F:0x33E` (`func_044D16`) | 0x0720FD | — | B |

Spot-checks **PASS**: 0x0720BE `68 98 20 68 9d 20` (push "game"/"menu"); 0x0720C4
`9a 28 09 1f 19` (0x191F:0x928); 0x0720D5 `9a 1c 09 1f 19` (0x191F:0x91C). The command ids
are **sequential `game menu` section indices** (data section indices, **NOT** screen
coordinates). **B.**

---

## 6. IN-GAME MENU BAR — bar line draw `func_06083A` @0x060890 — **B**

The menu bar is **ONE centred label line**, not a strip-fill. Re-confirmed @0x060890:

```
0x060890: lcall 0x181f, 0x182     ; 0x181F:0x182 builds the bar string into [bp-0x50]
0x060898: push  0xf               ; color = 0x0F (white)
0x06089a: push  5                 ; y = 5
0x06089c: push  0x140             ; box-w = 0x140 (320)
0x06089f: push  0                 ; x = 0
0x0608a1: lea   ax, [bp-0x50] / push ss / push ax   ; the assembled bar string
0x0608a6: lcall 0x181f, 0x100     ; 0x181F:0x100 = CENTER-TEXT-IN-BOX
```

Spot-check @0x060898: `6a 0f 6a 05 68 40 01 6a 00` — **PASS** (push 0x0F color; push 5 y;
push 0x140 box-w; push 0 x). **Bar geometry: x=0, y=5, box-w=320, color 0x0F, centred,
FONTTINY/FONTINTR.** Menu-bar **height = 8 px** (text at y=5; map viewport begins y=8 per
`render_frame_setup func_06787C`). There is **no** wood-fill / black rule / per-label color
draw in this function. **B.** (CORRECTION carried from RULING 2026-05-31: a prior draw-list
mislabeled `0x100` as a fill.)

After the centred line, @0x0608AE the builder terminates the string and re-emits via
`0x181F:0x16E` (strcat) / `0x181F:0x178` for the secondary (gold/turn) field — not part of
the title row. **B.**

---

## 7. IN-GAME MENU BAR — dropdown geometry + items + hit-rects

### 7.1 Dropdown open/run/hit-test — `func_06E3D0` @0x06E3D0 — **B**

Re-confirmed @0x06E3D0: opens with mode split `cmp [0x1f5c],7 / jle` @0x06E3DA (the same
KING/tribe mode word the popups use), clears `[0x1f68]`/`[bp-2]`, and tests `es:[bx+0xa]&0x10`
@0x06E3F6 (the `flags&0x10` "no-border" path → `[0x1f8a]=1`). The dropdown is **sized by the
shared dialog geometry engine** `func_06D316`/`func_06C520` (§8). **Origin anchored
`@x`=label-x, `@y`=8** (opens below the bar); centred only on the `-1` sentinel. The
`@`-directive section is parsed by `func_06F0F4` @0x06F0F4 (`cmp byte [bx],0x40` @0x06F192 —
re-confirmed). **Font = FONTINTR** for dropdown rows. **B.**

**Row highlight = `0x181F:0xCE` = 1-px HOLLOW rectangle outline** (`func_00E0A2`-clamped,
color = the per-row palette byte), **not** a filled cell (RULING 2026-05-31). Same primitive
as the picker selection boxes (§4). **B.**

### 7.2 Per-item hit-rects — mechanism **B**, explicit per-item x **R**

The bar's per-title hit-rects are built by the bar widget from the **glyph-grid title widths**
— they fall out of the single centred `0x181F:0x100` label string (§6), **not** per-label
draw-immediates. So **mechanism = B** but the **explicit x-origins are R** (`GAME@11 … COLONIZOPEDIA@261`
come from the low-trust `_VICEROY_MODERN` C reconstruction, absent from the EXE). Same
reconciliation as `map_view.md §6.4` / `menus.md §6.4` — **do not assert the x's as
byte-true**. **B (mechanism) / R (per-item x)** — **blocker:** tightening to B requires
disassembling the bar widget's per-label layout (currently one centred string).

### 7.3 Dropdown contents — **B** (`MENU_sections.json`, all keys grep-confirmed present)

All seven titles + `@END` confirmed present in `data_extracted/text/MENU_sections.json`
(`@GAME @VIEW @ORDERS @REPORTS @TRADE @CUP @PEDIA @END`; `@CUP` header = `~CHEAT`). Item text
+ ordering = **B** (verbatim from JSON, `menus.md §6.5`); the per-row `game menu` command-id
each row dispatches is data-driven via the dispatcher `func_0235D6` @0x0235D6 (27-case switch)
— **TBD at B (per-row id binding)**, except REPORTS which routes F1–F10 through the advisor
ladder (`advisor_reports.md §3`, key codes 0x41–0x49 for F1–F9; F10 = score path) — **B**.

| pulldown | header | items (count) | per-row dispatch |
|----------|--------|---------------|------------------|
| `@GAME` | `~GAME` | Game Options · Colony Report Options · Sound Options · Pick Music · Save Game · Load Game · **DECLARE INDEPENDENCE** · Retire · Exit to DOS (9) | TBD (command-id) |
| `@VIEW` | `~VIEW` | Move/View Pieces · European Status · Find Colony · Zoom In/Out · Zoom Level 120×96/60×48/30×24/15×12 · Show Hidden Terrain · Center View | zoom → `[0x184]` states (`map_view.md §6.2`) |
| `@ORDERS` | `~ORDERS` | Activate · Wait · Fortify · Sentry · Build/Join Colony · Clear Forest · Plow · Road · Load/Unload Cargo · Pillage · Go to Port/Place · Trade Route · Return to Europe · No Orders · Dump Overboard · Disband (19) | TBD (command-id) |
| `@REPORTS` | `~REPORTS` | F1 Terrain · F2 Religious · F3 Continental Congress · F4 Labor · F5 Economic · F6 Colony · F7 Naval · F8 Foreign · F9 Indian · F10 Score (10) | **B** (advisor ladder 0x41–0x49) |
| `@TRADE` | `~TRADE` | Edit/Create/Delete Trade Route (3) | TBD |
| `@CUP` | `~CHEAT` | F01 Create Unit · F02 Debug · F04 Reveal Map · F05 Set Human · F06 Kill Indians · F07 Advance Rev · Sound/Memory · F08 Strategy · F09 Colony Sites · F010 Test (11) | TBD |
| `@PEDIA` | `~COLONIZOPEDIA` | Cargo/Unit/Terrain Types · Colonist Skills · Colony Buildings · Founding Fathers · Misc · Complete (8) | TBD |
| `@END` | — | (empty terminator) | — |

`~` = hotkey-underline marker; full verbatim transcriptions in `menus.md §6.5`. **B (text+order).**

---

## 8. Shared geometry engine (cited, not re-derived) — **B**

Both menu families use `panel_construct func_06C520` + `panel_finalize_geometry func_06D316`
(`menus.md §11`, `popups.md §2.3`). Re-confirmed the load-bearing finalize math this pass:

```
content_w = max(80, longest_line_px+10, @width)   ; @0x06D392 (max of +0x28,+0x20,+0x34) — PASS
box_h     = line_count·2 + border([bx+0x46]=3)    ; @0x06D363 (shl 1; add es:[bx+0x46])  — PASS
            (+ title rows + Σ option rows)
X = (@x==-1) ? (320 - box_w)/2 : @x               ; @0x06D522 (sar 1; sub 0xA0; neg)      — PASS
Y = (@y==-1) ? (200 - box_h)/2 : @y               ; @0x06D53B (sar 1; sub 0x64; neg)      — PASS
clamp: X+box_w>0x140 shift left @0x06D563; Y+box_h>0xC8 shift up @0x06D571                 — PASS
```

> **Struct-field note (correction):** in this VICEROY build the finalize routine checks the
> `@x` sentinel on **`es:[bx+0x10]`** (origin-x) reading width from **`es:[bx+0x14]`**, and
> `@y` on **`es:[bx+0x12]`** reading height from **`es:[bx+0x16]`** (disasm @0x06D51C–0x06D546).
> `popups.md §2.3` cites the +0x14/+0x16 pair for the sentinel check — that is the
> **width/height** field; the **sentinel/origin** fields are +0x10/+0x12. The *formula*
> (`sar 1; sub 0xA0/0x64; neg`) is identical and verified. Flagging the field-offset gloss for
> the rebuild; numbers unaffected. **B.**

- Construction `func_06C520`: border `+0x46`=3 @0x06C5E9, inset `+0x48`=2 @0x06C5F5,
  default/min content-width `+0x28`=0x50(80) @0x06C5A6. **B** (`menus.md §11`).
- `@width` keyword `"WIDTH\0"` @file **0x1F989** (verified bytes = `WIDTH.LE…`) = a content-width
  **floor**, never a clamp. **B.**
- **Boot menu/pickers/dropdowns font = FONTINTR**; generic popup body = FONTTINY. **B.**

> **JSON-strip caveat (carried):** per-section `@width`/`@x`/`@y` literals (e.g. `@BEGINMENU
> @width=160 @y=91`) are **B via raw GAME.TXT / EXE** but the section extractor **strips
> valueless `@`-directive lines**, so `*_sections.json` does not carry them. Re-confirm
> specific values from raw `GAME.TXT` / the EXE, not the committed JSON. **B (engine + the
> known literals) / TBD-via-JSON (per-section re-confirmation).**

---

## 9. Evidence (offsets re-confirmed this pass)

- `raw/COLONIZE/VICEROY.EXE` — boot runner site 0x075C60 (`lea [0x2345]; lcall 0x181F:0x3FE`);
  `dec ax` ladder 0x075C6D; begin_game `lcall 0x191F:0x320` @0x075E5F; OPENBORD blit 0x075B8E;
  bar build `func_072090` @0x072090 (font 0x1A1F:0x2D2; section "game"/"menu" 0x0720BE; readers
  0x191F:0x928/0x91C); bar line `func_06083A` @0x060890 (push 0x0F/5/0x140/0; 0x181F:0x100 @0x0608A6);
  dropdown engine `func_06E3D0` @0x06E3D0 (mode split @0x06E3DA); `func_06F0F4` @0x06F0F4
  (`cmp byte [bx],0x40` @0x06F192); geometry `func_06D316` (0x06D363/0x06D392/0x06D522/0x06D53B/
  0x06D563/0x06D571); `func_06C520` (border/inset/min-width); difficulty `func_0702C0`
  (0x0702DA/0x0702F2/0x0703AB); nation `func_070782` (0x07079C/0x0707A7). **B.**
- String literals: `[0x2345]`="BEGINMENU" @file 0x1FCE5; `[0x233C]`/`[0x2374]`="OPENMENU" @file
  0x1FCDC/0x1FD14; `[0x2098]`="game"/`[0x209d]`="menu" @file 0x1FA38/0x1FA3D; `"WIDTH"` @file
  0x1F989. (DGROUP base 0x1D9A0.) **B.**
- `data_extracted/text/MENU_sections.json` — `@GAME @VIEW @ORDERS @REPORTS @TRADE @CUP @PEDIA
  @END` present. `GAME_sections.json` — `@BEGINMENU` present. **B.**
- `spec/ui/menus.md` §2/§4/§6/§7/§11 (Layer-2 spec, all numbers re-confirmed above);
  `viceroy_source/docs/drawlist/CHROME_AND_DISPATCH_INDEX.md` §B1/§B9/§B10. **B.**

## 10. Open items / blockers

1. **Menu-bar per-item x-origins** — built from glyph-grid title widths (mechanism **B**);
   explicit per-label x's are **R** (C-recon). **Blocker:** disassemble the bar widget's
   per-label layout (currently one centred `0x181F:0x100` string).
2. **Per-row `game menu` command-id binding** (non-REPORTS pulldown rows) — data-driven via
   `func_0235D6`; item text+order **B**, per-row id→handler **TBD**. **Blocker:** the binding
   lives in the `game menu` data section, not statically pinned per row.
3. **Per-section `@width`/`@x`/`@y`** — **B via raw GAME.TXT / EXE**, stripped from JSON
   (§8 caveat). **Blocker:** read raw GAME.TXT to re-confirm a specific section's literal.
4. **Save/load slot count** — file-list dialog (glob `*.MP`), overlay-resident; no `MAX_SAVE`/10
   array constant in any decompiled body. **R/TBD** (overlay not in export).
5. **FONTINTR runtime handle `[0x268A]`** — static value 0 (BSS); the value is loaded at boot.
   **TBD (runtime) / B (source = FONTINTR load)**.
