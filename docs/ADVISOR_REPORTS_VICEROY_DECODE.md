# ADVISOR REPORTS (F1–F10) — VICEROY.EXE decode (code-anchored)

> Source of truth = **VICEROY.EXE disassembly** (`raw/COLONIZE/VICEROY.EXE`, capstone
> 16-bit, RTLink-resolved). Every coordinate / sprite index / string id / color below
> cites a VICEROY.EXE file offset (`@0xNNNNN`, the exact push/mov site) or a named
> data table (`@MISC <idx>` in `data_extracted/text/LABELS_sections.json`). DGROUP image
> base = file `0x1D9A0`; **BSS starts at `DS:0x2CC6`** — any `DS:` offset **≥ 0x2CC6 is
> runtime/BSS** (zero in the file → marked **TBD** with its site). The shared draw verbs
> are NOT re-derived here; they are cited from `viceroy_source/docs/UI_PRIMITIVES.md` §0a
> and the per-verb table below. Template = `docs/COLONY_SCREEN_VICEROY_DECODE.md`.
> Built 2026-06-24 by re-disassembling each body against the bytes; cross-checked against
> `spec/ui/advisor_reports.md` and `viceroy_source/docs/drawlist/REPORTS.md` (RTLink
> `validate` → ALL PASS 2026-05-31). All offsets in this doc were re-confirmed live.

## 0. Anchors

- **DGROUP file base = `0x1D9A0`.** `DS:off` static data = file `0x1D9A0 + off`.
- **BSS at `DS:0x2CC6`**: `< 0x2CC6` = static (readable); `≥ 0x2CC6` = runtime/BSS = **TBD**.
- **Active PowerRecord ptr = `[DS:0x84FC]`** (set by `0x181F:0x582` `func_030550`:
  `arg·0x13C + 0x8808` → `[0x84FC]`; PowerRecord stride **0x13C=316**, base 0x8808).
- **`overlay 0x191F:NNN`** resolves via `tools/follow_thunk.py 0x191f 0xNNN`.
  `0x39E53`/`0x39E3F`/`0x39E70` are local trampolines into `0x191F:0xF4A/0xF12/...`
  (the title composer `func_037340`).

## 1. Dispatch ladder (F1–F10 → body) — byte-verified

In-game key handler `switch([bp+6])`; F-key report ladder @`0x023843..0x02390B`. Each
F-key `cmp [bp+6],<code>` then `lcall 0x191F:0x3xx` (overlay page 5, code base 0x37340).

| F-key | report | key code | dispatch site | thunk `0x191F:` | **BODY @file** | prologue | retf |
|-------|--------|----------|---------------|-----------------|----------------|----------|------|
| F1 | Terrain Information | 0x48 | @0x023849 | 0x41A | **0x3744A** | `enter 0x6E` | @0x037957 |
| F2 | Religious Adviser | 0x41 | @0x02385A | 0x40C | **0x37958** | `enter 0x2C` | @0x037A0F |
| F3 | Continental Congress | 0x42 | @0x02386E | 0x3FE | **0x37A10** | `enter 0x6E` | @0x03807D |
| F4 | Labor Adviser | 0x43 | @0x02387F | 0x3F0 | **0x38418** | `enter 0x120` | @0x038777 |
| F5 | Economic Adviser | 0x44 | @0x023890 | 0x3E2 | **0x38A50** | `enter 0x8C` | @0x038ED2 |
| F6 | Colony Adviser | 0x45 | @0x0238A1 | 0x3D4 | **0x39218** | `enter 0x68` | @0x0393F2 |
| F7 | Naval Adviser | 0x46 | @0x0238B2 | 0x3C6 | **0x3954C** | `enter 0x6A` | @0x039886 |
| F8 | Foreign Affairs | 0x47 | @0x0238C3 | 0x3B8 | **0x39888** | `enter 0x72` | @0x039E98 region |
| F9 | Indian Adviser | 0x49 | @0x0238E2 | 0x3AA | **0x39EE2** | `enter 0x7E` | (paginated) |
| F10 | Colonization Score | — | (score selector) | — | **`func_03A9C0` 0x3A9C0** | `enter 0x3C4` | — |

- **F9 gate** @0x0238D1: `test [DS:0x5383],0x20; je` — bit CLEAR (natives discovered) →
  `push 1; lcall 0x191F:0x3AA` (body draws, arg=1); bit SET → broken-thunk landing (no
  draw). F9 thunk is the lone nonzero-seg case (`ljmp_seg=0x2B1`).
- **F10** is not in the F-key ladder; it routes through the score path `func_03A9C0`.

## 2. Shared frame (every advisor body opens with this)

| Step | site | primitive | effect |
|------|------|-----------|--------|
| set active player record | (per body) | `0x181F:0x582` `func_030550` | `arg·0x13C+0x8808` → `[DS:0x84FC]`. **NOT a draw.** |
| title-bar background | `push N; call 0x39E53`→`0x191F:0xF4A` | `func_037340` @0x37340 | loads title template `0x11A2`, appends report-number N (`0x181F:0x182`), substitutes nation quartet `[DS:0x2DA8/2DAA/2DAC/2DAE]` (`0x181F:0x44E`), draws (`0x181F:0x484`). **Only REPORT-PIK load site.** |
| title fill-rect | `push 0x90; push <h>; push 0x140; push 0; push [DS:<attr>]; 0x181F:0x22` | `func_002462` @0x02462 | string FETCH of report-name id `[DS:<attr>]` fed to `0x100` centre-text **color 0x90** — `0x22` does NOT draw (`UI_PRIMITIVES.md` §0x022). h=5 (F1–F7), h=2 (F8). |
| footer rule | `push 0; push 0x140; push 0xC8; 0x181F:0xE2` | `func_00DB3A` @0x0DB3A | clipped sprite blit (sheet `[0x2DA8]`), y=0xC8=**200**, w=0x140=320 (`UI_PRIMITIVES.md` §0x0E2 — a sprite strip, not a 1-px rule). |
| OK button | `0x181F:0x3C0` | `func_004A80` @0x04A80 | OK widget; label `@MISC 46` "OK". `0x3C0` is the modal wait loop — the OK box+label are painted by the dialog builder. |

**Report-number N → title (`@MISC`, all verified present):** N=1→`@MISC 79` 'Terrain';
N=2→`@MISC 30` 'RELIGIOUS ADVISER REPORT'; N=3→`@MISC 37` 'CONTINENTAL CONGRESS
ACTIVITIES'; N=4→`@MISC 49` 'LABOR ADVISER REPORT'; N=5→`@MISC 50` 'ECONOMIC ADVISER
REPORT'; N=7→`@MISC 51` 'COLONY ADVISER REPORT'; F7→`@MISC 52` 'NAVAL ADVISER REPORT'
(via 0x39E3F→`0x191F:0xF12`); N=8→`@MISC 93` 'FOREIGN AFFAIRS REPORT'; F9→`@MISC 29`
'INDIAN ADVISER REPORT'; F10→`@MISC 114` 'COLONIZATION SCORE'. (N byte-verified:
F1=1@0x37450, F2=2@0x37967, F3=3@0x37A20, F4=4@0x38429, F5=5@0x38A60, F6=7@0x39403,
F8=8@0x398AF.)

### 2.1 Shared draw / text-composition verbs (cite, do not re-derive)

| `0x181F:` | @file | role |
|-----------|-------|------|
| 0x16E | 0x02992 | strcat (append string to buffer) |
| 0x182 | 0x029DE | append number (base 10) |
| 0x114 | 0x02AC6 | measure string width (F1 right-align: `x = 0x136 − textW`) |
| 0x13C | 0x02B38 | **draw text at explicit (x,y) color** — LEFT-aligned; font FONTTINY `[0x89E]` |
| 0x100 | 0x02BC8 | **draw text in box** — CENTERED |
| 0x22  | 0x02462 | string FETCH (skip-N-strings; NO draw) |
| 0xE2  | 0x0DB3A | clipped sprite blit (footer strip), sheet `[0x2DA8]` |
| 0x222 | 0x033F2 | **ENQUEUE** sprite row item (ax=sprite, dx=value/count, bx=color) at `[0x2CE0]++` — no draw |
| 0x22C | 0x03104 | **FLUSH** the centred icon row (value copies of each enqueued sprite). Stack push 4; ax=X, dx=Y, bx=span(0x12C) |
| 0x236 | 0x02EE4 | **proportional filled/empty icon strip** (`func_002EE4`): FILLED sprite=ax tiled across span; EMPTY sprite **0x38** (hardcoded @0x02FA5) past the value; CENTERED. `[bp+0x10]`=X(advances), `[bp+0xe]`=Y, `[bp+0xc]`=span. Pitch `(span−w)/(count−1)` clamped `[1,w+1]`. NOT a fill bar, NOT a color. |
| 0x2BC | 0x03E40 | **per-unit / colony status sprite** (`func_003E40`) — condition icon from a table record |
| 0x254 | 0x0E76A | **blit one sprite** (`func_00E76A`), sheet `[0x840]/[0x83E]`, ax=sprite idx |
| 0x484 | 0x0DCD4 | composited title string |
| 0x44E | 0x76B9E | string-substitution/format engine (nation %s quartet) |
| 0x3C0 | 0x04A80 | OK-button modal wait loop |
| 0x652 | 0x6F5F2 | "report not available" message (F8 gate) |
| 0x7B4 | 0x0BC10 | has-Founding-Father(idx) → 0/1 (F3, F8) |
| **`0x191F:0x8BC`** | 0x0DFCC | **horizontal color-run / line-fill** (`func_00DFCC`): `MOV es:[di],al; INC di; LOOPNE`. F4/F5/F8 separators. **`0x77`→(134,0,0) dark-red**. |

### 2.2 Fonts & colors (resolved; REPORT*.PIK shared palette)

- **Font:** F1–F9 bodies use **FONTTINY** (`[DS:0x89E]` descriptor → char-height drives
  row pitch). F10 = FONTTINY labels + **FONTINTR** big figures (`[DS:0x268A]` @0x3B054 —
  FONTINTR.FF, not FONTKING). **No report uses FONTKING.**
- **Colors** (REPORT*.PIK palette → exact RGB): `0x0F`→(255,255,255) white; title fill
  `0x90`→(255,255,190); `0x91`→(255,255,142); `0x92`→(255,243,93); `0x61`→(247,243,199)
  cream; `0x77`→(134,0,0) dark-red.
- **Sprite indices, NOT colors:** `0x39/0x38/0x3F/0x7C/0x7D` are **ICONS.SS sprite
  indices** (F2 crosses filled 0x39/empty 0x38; F3 bells filled 0x3F/empty 0x38; rebel
  0x7C/tory 0x7D). Port png idx = VICEROY runtime idx − 1.

---

## F1 — Terrain Information (`func_3744A`, retf @0x37957)

- **Body function:** `func_3744A` @0x3744A (`enter 0x6E`).
- **PIK background:** `REPORT1.PIK` (N=1 @0x37450 → `func_037340`).
- **Title:** `@MISC 79` 'Terrain'. Fill-rect color **0x90**, attr `[DS:0x2DF4]` (push
  @0x37463), fed to centre-text `0x181F:0x100` @0x37471.

| element | (x,y) / stride / pitch | verb | source / color | cite |
|---------|------------------------|------|----------------|------|
| per-terrain row loop start | **y=0xA** (`[bp-0x5A]`), **x=0x19=25** (`[bp-0x5C]`); idx `[bp-0x64]=0` | — | terrain rec `[DS:0x8D4E]`; rows = `[0x8D4E]+7` | @0x37479–0x3748B |
| terrain palette/icon byte | `al = [bx+0x848]` → `[bp-0x6E]` | — | terrain record | @0x3748F |
| terrain name (left) | composed buffer | `0x16E` strcat → `0x1BE` flush | name table `[DS:0x962E + idx·6]` (stride 6) | @0x37489–0x374C2 |
| "Move Cost" col (page-mode gated `[0x8D4E]+3 & 0x80`) | 4 corner draws | `0x13C` color 0 | `@MISC 186` 'Move Cost' (`[DS:0x2EBE]`) | @0x374CF–0x3760B |
| right-aligned numeric value | **x = 0x136 − textW** (measure `0x181F:0x114`; sub 0x136; neg) | `0x13C` | live count → **layout** | @0x375AF–0x375BC |
| row advance | **y += 0x1E** then **y += font_h+2** | — | FONTTINY pitch | @0x37613–0x37627 |
| column captions | — | `0x13C`/`0x100` | `[DS:0x2DF0]`, `[DS:0x2DF2]`, `[DS:0x2E14]` (`@MISC`) | @0x37758, 0x3775E, 0x37802 |
| **terrain icon row** | x=`[bp-0x6C]`, y=`[bp-0x68]`; **x+=3, y+=0x14** per | `0x254` blit-sprite, sheet `[0x83E]/[0x840]` | **sprite = `[bp-0x54]+0x72`** (terrain-derived, NOT a literal) | @0x378FA–0x37917 |
| footer rule | y=0xC8, w=0x140 | `0x181F:0xE2` | sprite strip | @0x3794A |
| OK button | bottom | `0x181F:0x3C0` | `@MISC 46` | @0x3794F |

**Data inputs:** terrain record `[DS:0x8D4E]` (+2 idx, +3 flag 0x80, +7 rows); colony
tally ColonyRecord stride 0x12 @ `[DS:0x54EE]`, count `[DS:0x539A]` (`0x181F:0xA4C`);
unit tally UnitRecord base 0x3144 stride 0x1C, count `[DS:0x539C]`.

**Remaining TBD (F1):** the right-aligned numeric column **value** (live terrain
unit/colony counts) and its resulting x (data-driven `0x136−textW`) — runtime, computed
in the tally loop (no static literal). Terrain-icon sprite id is `[bp-0x54]+0x72`
(terrain-derived runtime value).

---

## F2 — Religious Adviser (`func_37958`, retf @0x37A0F)

- **Body:** `func_37958` @0x37958 (`enter 0x2C`).
- **PIK:** `REPORT2.PIK` (N=2 @0x37967).
- **Title:** `@MISC 30` 'RELIGIOUS ADVISER REPORT'. Fill `push 0x90` @0x37970, attr
  `[DS:0x2DF6]` @0x3797A, h=5 @0x37973; centre-text `0x100` @0x37988.

| element | (x,y) / span | verb | source / color | cite |
|---------|--------------|------|----------------|------|
| **Crosses gauge** | **X=0xA** (`[bp+0x10]`, pushed 1st @0x37996), **Y=0x19=25** (`[bp+0xe]`, @0x3799D), **span 0x12C=300**, mode=1 | `0x181F:0x236` strip | **FILLED sprite ax=0x39** (@0x379B1), EMPTY 0x38; value dx:bx = PowerRecord `+0x30`(hi)/`+0x2E`(lo) | @0x37990–0x379B4 |
| "next immigrant" text (gated `[DS:0x5383]&0x20`) | x=0xA, y=0x19 | `0x181F:0x13C` | template `0x11A9`; **color 0x0F** (push @0x379D9) | @0x379B9–0x379E9 |
| footer rule | y=0xC8 | `0x181F:0xE2` | — | @0x37A04 |
| OK button | — | `0x181F:0x3C0` | `@MISC 46` | @0x37A09 |

**Remaining TBD (F2):** the crosses-gauge **value** (PowerRecord `+0x2E/+0x30`, live);
the gate flag `[DS:0x5383]&0x20` (runtime).

---

## F3 — Continental Congress (`func_037A10`, retf @0x3807D) — VALIDATION REFERENCE

- **Body:** `func_037A10` @0x37A10 (`enter 0x6E`).
- **PIK:** `REPORT3.PIK` (N=3 @0x37A20) + CCBKGD.
- **Title:** `@MISC 37` 'CONTINENTAL CONGRESS ACTIVITIES'. Fill color **0x90**, attr
  `[DS:0x2E04]` @0x37A37.

| # | element | (x,y) / span | verb | source / color | cite |
|---|---------|--------------|------|----------------|------|
| 1 | session line | composed | `0x16E` strcat | `@MISC 112` 'Next Continental Congress Session' + bells-to-go (`0x191F:0xF66`); `[DS:0x2E9A/2E9C]` | @0x37A5E–0x37B0B |
| 2 | **bell gauge** | **X=`[bp-0x56]`=4** (push @0x37BCE), **Y=`[bp-0x5a]`** running row (@0x37BE2), **span 0x12C** | `0x181F:0x236` strip | **FILLED sprite 0x3F** (`mov ax,0x3F` @0x37BEC), EMPTY 0x38; value dx:bx=`[bp-0x54]:[bp-0x66]` | @0x37BCE–0x37BF5 |
| 3 | sentiment line | — | `0x182` | label `[DS:0x2E44]` + rebel% `[DS:0x53D0]` | @0x37C40–0x37D03 |
| 4 | **rebel/tory strip** | X=`[bp-0x56]`=4, Y=`[bp-0x5a]`, span bx=0x12C | `0x222`×2 → `0x22C` flush | **rebel sprite 0x7C** ×`[bp-0x64]` (@0x37D43), **tory sprite 0x7D** ×`[bp-0x6C]` (@0x37D50), color 0 | @0x37D43–0x37D6D |
| 5 | **REF row** | X=`[bp-0x56]`, Y=`[bp-0x5a]`, span 0x12C | `0x222`×4 → `0x22C` | icon=`[DS:0x5286/52A2/52CC/532E]` (runtime cells) + counts `[DS:0x53DA/DC/E0/DE]`; label `@MISC 85` (`[DS:0x2E64]`) | @0x37E1C–0x37E6D |
| 6 | 2nd-force row | flush span 0x12C | `0x222`×4 → `0x22C` | icons `[DS:0x52B0/5294/52CC/532E]` + counts `[DS:0x53E2/E4/E8/E6]`; label `[DS:0x2E98/2E6C]` | @0x37EFE–0x37F4F |
| 7 | "Founding Fathers" hdr | — | strcat | `@MISC 89` (`[DS:0x2E6C]`) | @0x37F6D |
| 8 | **FF grid** | cols **{4,82,160,238}** (start 4 @0x37A49, **step 0x4E** @0x3800C), 4/row (`cmp 4` @0x38013), Y-step font+2 | `0x13C` **color 0x61** (push 0x61 @0x37FF7) | idx 0..0x18 (`cmp 0x19`); has-FF `0x181F:0x7B4` → name `[DS:0x9632 + idx·6]` | @0x37FC6–0x3803C |
| 9 | footer rule | y=0xC8, w=0x140 | `0x181F:0xE2` | — | @0x38056 |
| 10 | OK button | — | `0x181F:0x3C0` | `@MISC 46` | @0x3805B |
| 11 | overflow pager | — | `0x191F:0xF74` | `@MISC 105` '+ More +' | @0x38073 |

**Remaining TBD (F3):** the **REF / 2nd-force icon-id cells** `[DS:0x5286/52A2/52CC/532E]`
and `[DS:0x52B0/5294/...]` — these are runtime DGROUP cells (≥0x2CC6) holding the current
REF composition's sprite ids; **not statically resolvable** (the port's 125/126/9/127 are
unverified guesses). Pin via the icon-id loader or a runtime dump. The static strip tiles
ARE pinned (bells 0x3F, rebel 0x7C, tory 0x7D, empty 0x38). Live values: rebel%
`[DS:0x53D0]`, bells `[DS:0x53D4]`, REF counts `[DS:0x53DA…]` (runtime BSS).

---

## F4 — Labor Adviser (`func_38418`, retf @0x38777)

- **Body:** `func_38418` @0x38418 (`enter 0x120`); sub-pages `func_038778` (`enter 6`,
  N=5) and `func_038890` (`enter 0x66`).
- **PIK:** `REPORT4.PIK` (N=4 @0x38429).
- **Title:** `@MISC 49` 'LABOR ADVISER REPORT'. Two title fills: attr `[DS:0x2E1C]`
  @0x3843C, attr `[DS:0x2E2A]` @0x38467; color 0x90.

| element | (x,y) / pitch | verb | source / color | cite |
|---------|---------------|------|----------------|------|
| occupation NAME | name x=**2** (`[bp-0x56]=2` @0x3889F), **y-base 0x2A=42** (`[bp-0x58]` @0x388A4), row pitch driven by font | `0x13C` **color 0x92** | occupation name `[bx·8−0x715C]` | @0x3889F region |
| occupation COUNT | x = label_x + 0x27 | `0x182` then `0x13C` **color 0x61** | UnitRecord tally (`@JOB`) | @0x38675 |
| profession column x | `di+0xC` / `di+0x27` | — | di computed → state | @0x3862F/@0x3866E |
| **header separator LINE** | x-start `ax=2` (@0x3887A), **x-end `dx=0x137`=311** (@0x3887D), y `bx=row·8+0x2A` (@0x38871), 18-wide loop (`cmp 0x12` @0x38888) | `0x191F:0x8BC` line-fill | **color `push 0x77`** (@0x3886F) → (134,0,0) dark-red | @0x3886F–0x3888C |
| gold/summary value | — | `0x16E`+`0x13C` | `[DS:0x8542+si+0x9A]`; color 0x61/0x92/0x0E by magnitude (@0x3891E/0x38929/0x38990) | @0x388FA–0x3899F |
| matrix-frame outline | 4 edges (`0xB9E` ×4) | `0x2C6`/`0x24A` | nation quartet `[DS:0x2DA8..0x2DAE]` — a line-drawn box, NOT bordered cells | (see §2.1) |
| footer rule + OK | y=0xC8 (@0x386EE), OK 0x3C0 (@0x386F3) | `0xE2`+`0x3C0` | `@MISC 46` | @0x386EE–0x386F3 |
| click-hit-scan (selectable colony cells) | — | `0x181F:0x3CA` | — | @0x386EE region |

**Remaining TBD (F4):** per-occupation **counts** (UnitRecord tally, live); the gold
summary value `[DS:0x8542+…]` (runtime colony field); some F4 section-label `@MISC` slots
(`[DS:0x2E1C/2E1E/2E2A/2F58]` — loader unidentified).

---

## F5 — Economic Adviser (`func_38A50`, retf @0x38ED2)

- **Body:** `func_38A50` @0x38A50 (`enter 0x8C`); sub-pages `func_038ED4` (`enter 2`,N=6),
  `func_038F2C` (`enter 0x66`), `func_0391C0` (`enter 2`, N=6).
- **PIK:** `REPORT5.PIK` (N=5 @0x38A60).
- **Title:** `@MISC 50` 'ECONOMIC ADVISER REPORT'. Two fills: attr `[DS:0x2E1E]` @0x38A73,
  attr `[DS:0x2F56]` @0x38A9E; color 0x90.

| element | (x,y) / stride | verb | source / color | cite |
|---------|----------------|------|----------------|------|
| column-header HORIZONTAL LINES | — | `0x191F:0x8BC` line-fill | nation quartet; separator lines (NOT bordered cells) | @0x38AB4–0x38BCD |
| header columns | **x = 76 / 170 / 220** at **y=25** (`push 0x4C`=76 @0x38AF6, `mov ax,0xAA`=170 @0x38B63, `mov ax,0xDC`=220 @0x38B90) | `0x13C`/`0x100` | section labels `[DS:0x2E2E/2E30/2F50/2F52]` (`@MISC`) | @0x38AD8–0x38B7B |
| commodity table | **x=2 stride 0x11=17** (@0x38F3C/@0x3903F); **y-start 25/33, pitch 8** (@0x38AEB/@0x38BE2/@0x38E33) | `0x13C` | per-commodity rows | @0x38F3C |
| value column | **x=250/150 stride 12** (@0x38FEF/@0x3916C); right-aligned `anchor − strwidth` | `0x13C` (live) | price_level (`+0x4C`)/vol_accum (`+0x5C`) | @0x38FEF/@0x3916C |
| per-good row separators | — | `0x191F:0x8BC` line-fill | — | @0x38C22, 0x38CF2 |
| sub-page hdrs | N=6 | `0x13C` | `[DS:0x2E20]`+`[DS:0x2F5C/2F4E/2F5A]` | @0x38EEB–0x39206 |

**Data inputs:** Treasury gold PowerRecord `+0x2A`, tax `+0x01`, per-commodity price
`+0x4C` / vol_accum `+0x5C`; "(Building Upkeep)" / "TOTAL UPKEEP".

**Remaining TBD (F5):** all per-good **values** (gold, tax, prices, volumes — runtime
PowerRecord fields); some F5 section-label `@MISC` slots (loader unidentified).

---

## F6 — Colony Adviser (`func_39218`, retf @0x393F2)

- **Body:** `func_39218` @0x39218 (`enter 0x68`); sub-page `func_0393F4` (`enter 0x58`,N=7).
- **PIK:** `REPORT7.PIK` (N=7 @0x39403).
- **Title:** `@MISC 51` 'COLONY ADVISER REPORT'. Fill attr `[DS:0x2E22]` @0x39416, color 0x90.

| element | (x,y) / pitch | verb | source / color | cite |
|---------|---------------|------|----------------|------|
| row geometry | **base x=2** (`[bp-0x5a]=2` @0x39227), **base y=0x14=20** (`[bp-0x5e]=0x14` @0x3922C), **row pitch +0x11=17** (@0x392A4), **9 rows/page** (`cmp 9` @0x392AB) | — | paginated `[DS:0x539E]` | @0x39227–0x392F1 |
| condition sprite | advancing x by `[bp-0x58]` | `0x181F:0x2BC` | colony condition icon | @0x39297 |
| colony icon | x=`[bp-0x5a]` | `0x181F:0x2A8` | colony icon sprite | @0x39330 |
| colony NAME | **x=`[bp-0x5a]+0x17`** (@0x39342), **y=`[bp-0x5e]+7`** (@0x39338) | `0x13C` **color 0x92** (push @0x39335) | colony name | @0x3934D |
| production-rate strip | — | `0x35C`→`0x2BC` sprite-strip | per-field production | @0x39288–0x3939B |
| 4 centered captions | **(x,box) = (2,80)/(82,80)/(162,80)/(242,76)**, y=27 | `0x100` **color 0x92** | section `[DS:0x2E34/2E36/2E38/2E3A]` | @0x3945C/@0x39480/@0x394AA/@0x394CE |
| footer + OK | y=0xC8 (@0x392C9), OK 0x3C0 (@0x392CE) | `0xE2`+`0x3C0` | `@MISC 46` | @0x392C9–0x393E5 |

**Note:** F6's `0x8BC` @0x39372 is a production-quantity helper (thunk → 0x0427:0x0D38),
**NOT** the F4/F8 line-fill.

**Remaining TBD (F6):** per-colony field **values** (ColonyRecord stride 0xCA @ base
0x5D60, live); the production/condition sprite ids (runtime, from the colony record);
some F6 section-label `@MISC` slots.

---

## F7 — Naval Adviser (`func_3954C`, retf @0x39886) — FULLY PINNED 4-col table

- **Body:** `func_3954C` @0x3954C (`enter 0x6A`).
- **PIK:** `REPORT*.PIK` (title via 0x39E3F → `0x191F:0xF12`).
- **Title:** `@MISC 52` 'NAVAL ADVISER REPORT'. Column headers `@MISC 61` 'Ship' / `62`
  'Cargo' / `63` 'Location' / `64` 'Destination' (centered, drawn on the title path).
- **Row grid:** **first row y=0x2A=42** (`[bp-0x58]=0x2A` @0x39560), **pitch 0x14=20**
  (@0x39796), **7 ships/page** (`cmp 7` @0x3979D), base x=2 (`[bp-0x56]=2` @0x3955B).

| column | x (base=2) | technique | align | color | cite |
|--------|-----------|-----------|-------|-------|------|
| **Ship name** | `[bp-0x66]` = base+0x18=**26** (class 0xD–0x12); else +0x56→**112** | `0x13C` | LEFT | **0x61** (push @0x39656/@0x39660) | @0x39636–0x39676 |
| **Cargo** | x=`[bp-0x6a]` (≈base), +0xC/icon | `0x254` sprite loop (good id `0xC68`, count `0xBE6`) + `0x2BC` condition sprite; empty=sprite **0x17** (@0x39605), full-stack **0x27** (@0x395A8) | sprite row | — | @0x39574–0x39608 |
| **Location** | box_x=base+0xA0=**162**, **box_w=0x50=80** | `0x100` | CENTERED [162..242] | **0x61** | @0x396AC–0x396C4 |
| **Destination** | box_x=base+0xF0=**242**, **box_w=0x4C=76** | `0x100` | CENTERED [242..318] | **0x61** | @0x3977F–0x39793 |

- Ship status icon (left of name): `0x191F:0xF82` (@0x396A2, @0x39709) — unit's OWN sprite.
- **Exactly ONE rule per page = footer y=0xC8** (page1 @0x397BB, page2 @0x3987A). No
  header/row/column rules. OK 0x3C0 @0x397C0/@0x3987F.
- Two passes: pass1 ships on-map/in-colony (re-init @0x397CF); pass2 at-sea/Europe (class
  split @0x397F2/@0x39801 → re-enters cargo path @0x39574).

**Data inputs:** UnitRecord base 0x3144 stride 0x1C; type `+0x3147 & 0xF`, class
`+0x3146` (0xD..0x12=ships), cargo count `+0x3150`, name `[DS:0x5230+cls·0xE]`; location
`+0x314C`; route `0x181F:0x302`; Europe names `[DS:0x5426+p·0x34]`.

**Remaining TBD (F7):** per-ship **rows** (live UnitRecord data — name, cargo contents,
location, destination); cargo sprite ids per slot (runtime).

---

## F8 — Foreign Affairs (`func_39888`, retf @0x39E98 region)

- **Body:** `func_39888` @0x39888 (`enter 0x72`).
- **Gate** @0x39892: `test [DS:0x5382],1; je 0x398A4` — bit0 **CLEAR → JE taken → body
  draws** @0x398A4; bit0 **SET → "FOREIGNNOTAVAIL"** (`push 1; push 0x11B6; lcall
  0x181F:0x652` @0x39894) + return @0x398A3.
- **PIK:** `REPORT8.PIK` (N=8 @0x398AF).
- **Title:** `@MISC 93` 'FOREIGN AFFAIRS REPORT'. Fill color **0x90**, **h=2** (push 2
  @0x398BB), attr `[DS:0x2E74]` @0x398C0.

| element | (x,y) | verb | source / color | cite |
|---------|-------|------|----------------|------|
| per-power HEADER LINES | x=idx·0x2D+0xD−3, 4 powers (`cmp 4`) | `0x191F:0x8BC` line-fill, **color dx=0x13F**=319 | underline (NOT bordered cell); sprite 0x77 | @0x398DD–0x39917 |
| contact guard | — | `0x181F:0x7B4` + `[DS:0x53A2]` | — | @0x39922–0x39939 |
| strength labels | label x=`[bp-0x5a]`=**2** | `0x13C` **color 0x91** (push @0x39973) | `@MISC 95` Colonies (`[DS:0x2E78]`) / 96 Population (`2E7C`) / 97 Average Colony (`2E7A`) / 98 Military Power (`2E7E`) / 99 Naval Power (`2E80`) / 100 Merchant Marine (`2E82`) | @0x39940–0x39ADA |
| per-power VALUES | x=`[bp-0x5e]`=**0xD=13 / 0x50=80 / 0xA0=160 / 0xF0** | `0x13C` **color 0x91** LEFT | live strength | @0x399C7/@0x39A13/@0x39B13 |
| war/peace + recognition | — | strcat | `@MISC 101` War (`[DS:0x2E66]`) / 102 Peace (`2E68`); recognition `[DS:0x2F38/2F36]` | @0x39C65–0x39DDF |
| footer rows | quartet ×2 | `0x191F:0x8BC` | — | @0x39E60, 0x39E7F |

- Single-power branch @0x39B27 indexed by `[DS:0x53D2]` when focus flag `[DS:0x53A2]≠0`.

**Remaining TBD (F8):** per-power strength **values** (live PowerRecord, stride 0x13C);
gate flag `[DS:0x5382]&1`, rival flag `[DS:0x53A2]`, recognition `[DS:0x2F38/2F36]`
(runtime); the nested "View Whose Report?" power-picker runs in `func_0235D6` @0x23810
(not in the F8 body); some F8 section-label `@MISC` slots.

---

## F9 — Indian Adviser (`func_39EE2`, paginated via `func_039E98`)

- **Body:** `func_39EE2` @0x39EE2 (`enter 0x7E`); reached via gated dispatch (F9 gate §1).
- **PIK:** `REPORT*.PIK`; title `@MISC 29` 'INDIAN ADVISER REPORT'. Two title fills: attr
  `[DS:0x2E9E]` @0x39F61, attr `[DS:0x2EB6]` @0x39F90; color 0x90.

| element | (x,y) | verb | source / color | cite |
|---------|-------|------|----------------|------|
| native-relation scalar | `[DS:0x53A8] + 0x64·[DS:0x53A7]` | — | runtime | @0x39EE6 |
| player-presence count | players<4, PowerRecord flag&4 | — | `[DS:0x5398]` | @0x39F1C–0x39F3A |
| header strings | — | `0x100` | `[DS:0x2DE0]`, year `[DS:0x538A]` | @0x39FFF, 0x3A061 |
| paginator | `[DS:0x2D0E]` x+=8 wrap 0x124; `[DS:0x2D10]` y | `func_039E98` | — | @0x3A107, 0x3A1CA |
| status/mission column | **x=0x10=16** (@0x3A28A), then **+0x48=72** (@0x3A307), **+0x14=20** (@0x3A4A0) | `0x13C`/`0x100` | NativeSettlement fields | @0x3A28A–0x3A4A0 |
| per-tribe rows | **y-start 0x18=24** (@0x3A09A), 2nd block **0x96=150** (@0x3A3B0) | `0x13C`/`0x100` | mission labels `[DS:0x2E30/2EA4/2E44/2E48/2ED6/2EA2/2EA8/2ED8/2EAC]`; tribe names `@TRIBES` | @0x3A412–0x3A8F5 |
| **cell text color** | — | — | **runtime global `[DS:0x830]`** (`mov al,[0x830]; push ax` @0x3A271) = `@COLORS` "basic" slot (idx 68 → (85,150,52) green); title uses `[DS:0x831]` "hilite" 149 → (199,162,32) gold | @0x3A271 |

**Data inputs:** NativeSettlement base `[DS:0x54EC]` stride 18 (+0x02 owner, +0x04 pop,
+0x05 mission flag); tribe names `@TRIBES`; relation bytes `[DS:0x53A7/53A8]`.

**Remaining TBD (F9):** per-tribe **data** (owner/pop/mission — live NativeSettlement);
cell color `[DS:0x830]`/`[DS:0x831]` are runtime `@COLORS` cells (BSS); paginator row-y
layout is data-driven by `func_039E98`.

---

## F10 — Colonization Score (`func_03A9C0` @0x3A9C0)

- **Body:** `func_03A9C0` @0x3A9C0 (`enter 0x3C4`).
- **Score-band selector (byte-verified):** computes `scaled` (value scaled by difficulty),
  then loops **i=1..0x18=24** (`cmp 0x18` @0x3AA63): `cx=i`, `ax = i·i / 3` (`imul cx; idiv
  3` @0x3AA4D–0x3AA53); if `ax < scaled` (`cmp ax,[bp-2]; jge` @0x3AA55) → `dec cx;
  panel=cx` (@0x3AA5A). After loop `sar [bp-2],1` (@0x3AA6A); **clamp panel ≤ 0x17=23**
  (`cmp 0x17; jle … mov ax,0x17` @0x3AA71–0x3AA76).
- **Band plate:** builds string `"SCORE"` (`0x11CF` @0x3AAC0 region) + **`panel+1`**
  (append number `0x182` @0x3AADA) → loads **`SCORE<panel+1>.SS`** (one band plate).
- **Background:** **`WOODPAN2`** (string `0x11D7` @0x3AAFF), composited with the nation
  quartet `[DS:0x2DA8/2DAA/2DAC/2DAE]` via `0x181F:0x44E` @0x3AB02.
- **Title:** `@MISC 114` 'COLONIZATION SCORE'.
- **Font:** FONTTINY labels (`[DS:0x89E]` @0x3ABF4) + **FONTINTR** big figures
  (`[DS:0x268A]` @0x3B054 / 0x3B0E6) — NOT FONTKING.
- **Body lines** (from `@MISC`): 115 'Citizens' / 116 'Independence' / 117 'Villages
  Burned' / 120 'Foreign Recognition' / 121 'Total Score' (+ FF list + Rebel Sentiment).
- Extra gate: `test [DS:0x5382],0x10; je` @0x3AA9B (post-selector branch).

**Remaining TBD (F10):** live **score figures** (Citizens/Independence/Villages
Burned/Foreign Recognition/Total Score — runtime); the per-line big-figure (x,y) inside
the SCORE plate region (FONTINTR-driven, not yet pinned to literal pushes); `[DS:0x5382]`
flags (runtime).

---

## Coverage summary

| report | static layout (x/y/stride/color/string) | live data |
|--------|------------------------------------------|-----------|
| F1 Terrain | **FULL** (row y=0xA x=0x19, +0x1E+font; right-align 0x136−w; icon +0x72; captions) | counts TBD (runtime tally) |
| F2 Religious | **FULL** (gauge X=0xA Y=0x19 span 0x12C, fill 0x39; immigrant text 0xA/0x19/0x0F) | gauge value TBD |
| F3 Congress | **FULL** (gauge 0x3F X=4; rebel 0x7C/tory 0x7D; FF grid {4,82,160,238} step 0x4E color 0x61) | REF/2nd-force icon-id cells TBD (runtime DGROUP); counts TBD |
| F4 Labor | **FULL** (name x=2 y=0x2A color 0x92; count +0x27 color 0x61; sep line 0x77 x 2..311) | counts TBD; some label slots TBD |
| F5 Economic | **FULL** (hdr x=76/170/220 y=25; table x=2 stride 17; value x=250/150 stride 12; sep lines) | values TBD; some label slots TBD |
| F6 Colony | **FULL** (base x=2 y=20 pitch 17, 9/page; name x+0x17 y+7 color 0x92; captions (2/82/162/242,27)) | field values TBD; sprite ids TBD |
| F7 Naval | **FULL** (4 cols y=42 pitch 20 7/page; Ship x=26 LEFT 0x61; Loc x=162 w=80 / Dest x=242 w=76 CENTERED 0x61; cargo sprite row; footer-only rule) | rows TBD (runtime) |
| F8 Foreign | **FULL** (gate polarity; labels x=2 color 0x91; values x=13/80/160/240; hdr lines 0x13F) | strength values TBD; some label slots TBD |
| F9 Indian | **FULL** (status col x=16/+72/+20; y-start 24 / block 150; color `[0x830]`) | tribe data TBD; color cells runtime |
| F10 Score | **FULL** (band selector i·i/3≥scaled, clamp ≤23; SCORE<panel+1>.SS over WOODPAN2; FONTTINY+FONTINTR) | score figures TBD; big-figure xy TBD |

**Fully pinned (static layout, all immediates byte-cited):** F1, F2, F3, F4, F5, F6, F7,
F8, F9, F10 — every report's x-columns, y-start, pitch, draw verb, string source, color
and font are byte-verified. **TBD across all reports = live game-state only** (per-row
counts/gold/prices/score figures, runtime DGROUP icon-id cells ≥0x2CC6, and a handful of
`@MISC` section-label→slot bindings whose bulk loader is unidentified). No layout constant
is fabricated; every TBD names its blocking site.
