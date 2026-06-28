# END-GAME / SPECIAL SCREENS — VICEROY.EXE decode (code-anchored)

> Source of truth = **VICEROY.EXE disassembly** (`raw/COLONIZE/VICEROY.EXE`, capstone
> 16-bit). Companion to `docs/EUROPE_SCREEN_VICEROY_DECODE.md` and
> `docs/COLONY_SCREEN_VICEROY_DECODE.md`. Covers the King audience / loss / win,
> the Colonization SCORE (F10), the Declaration of Independence, and the closing /
> end screen. Built 2026-06-24.
> Tiers: **B** byte-verified / **A** anchor / **R** reconstructed / **TBD** (runtime/BSS or unresolved).

## 0. Anchors (shared with colony/europe decodes)
- DGROUP file base = `0x1D9A0`; BSS starts `DS:0x2CC6` (any `[0xNNNN]` ≥ 0x2CC6 is
  runtime → **TBD**; `< 0x2CC6` is static data at file `0x1D9A0+0xNNNN`).
- **Text pen globals** (the FONT engine state, DGROUP-static): `[0x1F4A]` = pen **x**,
  `[0x1F50]` = pen **y**, `[0x1F52]` = pen z/baseline adj, `[0x1F56]` = **flags**
  (`|=0x18` = the King text mode bits), `[0x1F9E]/[0x1FA0]` = **ink colour** dword.
  Confirmed by the save/restore bracket in `func_075352` (§1.2).
- **Glyph/text engine** = thunk **`0x181F:0x3FE`** → target file **`0x06F594`**
  (`func_06F594`, resolved via `follow_thunk`). This is the routine the King body text,
  and 44 other call sites, use to stamp a formatted string at the current pen.
- **Font/asset loader** = thunk **`0x1A1F:0xA86`** (loads a named font/sheet by string,
  e.g. `"FONTKING"`). **Sprite-region blit** = thunk **`0x181F:0x2F8`** → target file
  **`0x0E964`** (`func_00E964`).
- **`[0x268A]/[0x268C]`** = the **FONTINTR** ink-colour register (the default intro/score
  font colour); `func_075352` restores the pen colour from it on exit (`@0x075576`). The
  SCORE screen (§5) uses the same global as its figure-metric font colour.

---

## 1. KING screens — audience / tax-demand, loss, win (`func_075352 @0x075352`)

A **single** renderer, `func_075352`, paints all three King end-states. It picks the
backdrop sprite-sheet (`KING1` / `KINGLOSE` / `KINGWIN`) and the nation prefix
(`ENGLND`/`FRANCE`/`SPAIN`/`DUTCH`) from globals, loads **FONTKING**, blits the portrait,
and stamps the King's speech body at pen **(242, 47)**.

### 1.1 Entry / trigger chain
```
end-of-turn sequence  @0x005AE5
  gate: [0x828]==0 && [0x826]==0 && [0x53C2]!=0   (King-event-pending flag, @0x005ADE)
  lcall 0x181F:0x61E   → func_02F3A2  (King-event orchestrator, enter 0x78)
     @0x005ACC: [0x538A]++ (year) ; [0x538C] season — same turn-clock as colony/europe
func_02F3A2 @0x02F3A2  (reached only via thunk 0x181F:0x61E from 0x005AE5)
  selects sub-event by [0x5398] (active power id 0..3) and event sub-state, builds the
  King body string, then calls the renderer:
    @0x02F552  push 1 ; push 2 ; lcall 0x191F:0xABA → func_075352   (audience variant)
    @0x02F6A8  push 1 ; push 1 ; lcall 0x191F:0xABA → func_075352   (loss/win variant)
  (0x191F:0xABA is the far thunk that lands on func_075352 — find_callers confirms the
   only two reach sites are 0x2F552 and 0x2F6A8.)
```
`func_075352` signature (stack args): **`[bp+6]`** = primary state, **`[bp+8]`** =
secondary state, **`[bp+0xA]`** = pointer to the pre-formatted body-text buffer
(passed to the glyph engine at `@0x075540`). `[bp-0x320]` is a 0x320-byte local text
work buffer (`enter 0x320,0` @0x075352). **B.**

### 1.2 Draw chain — `func_075352`, call-for-call

| # | @site | call / op | role |
|---|-------|-----------|------|
| 1 | 0x075375 | `lcall 0xD1D:0x7E4` (sprintf) into `[bp-0x20]`, fmt `[0x22F2]`="KINGLSS" family | build asset-name stem |
| 2 | 0x075385 | `lcall 0x181F:0x182` (str concat) | append nation/variant token to stem |
| 3 | 0x0753A9 | `lcall 0x181F:0x44E` (file/asset open over `[bp-0x320]`, args `[0x839E..0x83A4]`) | open the King **SS** sheet; `je 0x753B8` on success |
| 4 | 0x0753BB | switch on **`[0x5398]`** (0→`[0x22FA]`="ENGLND", 1→`[0x2301]`="FRANCE", 2→`[0x2308]`="SPAIN", 3→`[0x230E]`="DUTCH") | nation prefix select |
| 5 | 0x075430 | `[bp+6]==1 && [bp+8]==1` → `[0x2314]`="KING1" (+ `lcall 0x181F:0x48E` arg `0x3E`); elif `[bp+6]==1` → `[0x231A]`="KINGLOSE"; else `[0x2323]`="KINGWIN" | **state→backdrop SS select** |
| 6 | 0x07546D | `lcall 0x191F:0xFDE` then `0x191F:0xFD0` (load sheet, returns `dx:ax` handle→`si`) | **load backdrop sprite sheet** |
| 7 | 0x075485 | if handle≠0: `push seg; push si; push es:[si+0x48]; push 0x64; dx=es:[si+0x46]; ax=1; bx=&[0x839E]; lcall 0x181F:0x2F8` | **blit portrait/backdrop sprite at x=0x64 (100)**, y/h from sheet header fields `[si+0x46]/[si+0x48]` (**runtime sheet data → y is R/TBD**) |
| 8 | 0x0754A2 | `lcall 0x181F:0x3B6` (flush/clip setup) | |
| 9 | 0x0754D8..0x0754ED | `bx=0x140; lcall 0x181F:0x444` then `push 0,0x140,0xC8; lcall 0x181F:0xE2` | **full-screen play-area frame** `(0,0,320,200)` (`0x140`=320, `0xC8`=200) |
| 10 | 0x0754F6 | `lea bx,[0x232B]`="FONTKING"; `lcall 0x1A1F:0xA86` | **load FONTKING**; handle→`[bp-0xC]/[bp-0xA]`, mirror `[0x1F9E]/[0x1FA0]` ← handle or `[0x89E]/[0x8A0]` (`@0x07550A`) |
| 11 | 0x075518 | save pen `[0x1F4A]/[0x1F50]/[0x1F52]` → `si/di/[bp-6]` | save caller pen |
| 12 | 0x075526 | `[0x1F4A]=0xF2 (242)` ; `[0x1F50]=0x2F (47)` ; `[0x1F52]=0` ; `[0x1F56] |= 0x18` | **set King text pen (242,47) + flags** |
| 13 | 0x075540 | `bx=[bp+0xA]` (body buffer) ; `lcall 0x181F:0x3FE` | **stamp King speech body at (242,47), FONTKING** |
| 14 | 0x075545 | restore pen `[0x1F4A]/[0x1F50]/[0x1F52]` ← `si/di/[bp-6]` | restore caller pen |
| 15 | 0x075553 | `lcall 0x181F:0x3B6` ; `push 0xA000,0xFC00; lcall 0x181F:0x3F4` | page-flip / palette fade-in (`0xA000`=VGA seg, `0xFC00` fade param) |
| 16 | 0x075563 | if `[bp-0xA]:[bp-0xC]`≠0 → `lcall 0x191F:0x1A8` | free the loaded font handle |
| 17 | 0x075576 | `[0x1F9E]/[0x1FA0]` ← `[0x268A]/[0x268C]` (FONTINTR colour); `[0x1F64]=1`; `[0x372]=[bp-8]` | restore default ink, set flag, return |

### 1.3 Region map — KING screen elements

| Element | x | y | w | h | frame / sheet | string | source-offset | tier |
|---------|---|---|---|---|----------------|--------|---------------|------|
| Full-screen frame fill | 0 | 0 | 320 | 200 | — | — | `@0x0754D8` (`bx=0x140`) + `@0x0754E2` (`push 0,0x140,0xC8`) | B |
| King portrait / backdrop | 100 | `[si+0x46]` (R) | `[si+0x48]`→ sheet (R) | sheet | **KING1 / KINGLOSE / KINGWIN.SS** (state-selected §1.2 #5), nation-prefixed (`ENGLND`/`FRANCE`/`SPAIN`/`DUTCH`) | — | x=`@0x07541E push 0x64`; y/h=`@0x075492/0x07548C` | **B (x), R (y/h runtime)** |
| King speech body text | **242** | **47** | wraps | — | FONTKING glyph engine `0x181F:0x3FE` | `[bp+0xA]` (runtime-built body, fmt via `0xD1D:0x7E4`) | x/y=`@0x075526`/`@0x07552C`; draw=`@0x075540` | **B (pen), R (text content)** |
| King text ink / flags | — | — | — | — | flags `[0x1F56]\|=0x18` | — | `@0x075538` | B (flag); colour=runtime font handle (R) |

### 1.4 Variant matrix (which SS is shown) — selected by `[bp+6]`,`[bp+8]` (B)
The three callers each hard-code the `(bp+6,bp+8)` pair, and `func_075352` `@0x075430`
maps the pair to the backdrop SS:

| Caller | pushes (bp+6, bp+8, bp+0xA) | `@0x075430` result | Screen | body string ptr |
|--------|----------------------------|--------------------|--------|------------------|
| **`func_075594`** (audience sequencer, reached via fn-ptr `[0x763BC]` / thunk `0x1A1F:0xDC8`) | `push 1; push 1` (`@0x0755C1/0x0755C3`) + body `[bp-0x14]` | `bp+6==1 && bp+8==1` → **`KING1.SS`** | **King audience / tax-demand** | built from stem `[0x2334]` (`@0x075598`), nation-suffixed if `[0x5398]==3` (`@0x0755A7`) |
| **`@0x02F552`** (King-event handler `func_02F3A2`) | `push 1` (`@0x02F550`), `bp+8`=2 (`@0x02F54E`), body `[0xF20]`="KINGLOSE" | `bp+6==1`, `bp+8≠1` → **`KINGLOSE.SS`** | **King loss** | `[0xF20]` |
| **`@0x02F6A8`** (same handler) | `bp+6`=2 (`@0x02F6A6`), `push 1` (`@0x02F6A4`), body `[0xF31]`="KINGWIN" | `bp+6≠1` → **`KINGWIN.SS`** | **King win** | `[0xF31]` |

- KING1 path `@0x075430` additionally runs `lcall 0x181F:0x48E` with arg `0x3E` (62) —
  an extra setup step unique to the audience variant (`@0x07544B`).
- Nation prefix (`ENGLND`/`FRANCE`/`SPAIN`/`DUTCH`) from **`[0x5398]`** (active power id),
  `@0x0753BB` switch (#4), concatenated onto the stem via `0x181F:0x182` (#2). So the
  loaded sheet name is nation+state (e.g. `ENGLND`+`KINGLOSE`). The asset stems
  `KINGLSS`/`KINGLOSE`/`KINGWIN`/`KING1`/`FONTKING` all live in the name block at
  `[0x22F2..0x232B]` (file `0x1FC92`). **B.**

### 1.5 KING — remaining TBD
- Portrait **y / height**: read from runtime sheet-header fields `[si+0x46]`/`[si+0x48]`
  → **TBD** (break `@0x075485`, read the loaded SS header). x=100 is byte-pinned.
- King speech **body text**: built at runtime in `[bp+0xA]` by `func_02F3A2` from
  GAME.TXT fragments (tax %, demand amount) — **TBD literal** (trace `func_02F3A2`
  string assembly @0x02F3A2..0x02F6B5).
- King text **ink colour**: comes from the FONTKING handle loaded `@0x0754F6` (runtime)
  → **TBD** (only the `[0x1F56]|=0x18` flag is byte-pinned).
- The exact KINGLSS1 vs KINGLSS2 / KINGLOSE.SS frame index (multi-frame loss anim) —
  **TBD** (the blit `0x181F:0x2F8` takes frame 0 of the sheet here; any animation loop
  would be in `func_02F3A2`, not yet traced).

---

<!-- SCORE_SECTION -->
<!-- DECLARATION_SECTION -->
<!-- CLOSING_SECTION -->
