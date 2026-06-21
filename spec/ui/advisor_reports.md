# Advisor Reports (F2–F10)

> **Layer 2 — UI Specification.** Per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.

**Overall confidence:** dispatcher, **real** paint-func body offsets, title-N→PIK mapping, F8
gate polarity, and the F10 score-band selector are now **B** (raw-EXE-verified). Per-report
intra-row pixel coords are **A** (geometry docs) / **B** (where the body shows them). ·
**Canonical primary:** `raw/COLONIZE/VICEROY.EXE`, `viceroy_source/docs/drawlist/REPORTS.md`
(offsets raw-confirmed), `docs/RENDERER_GEOMETRY.md` (Naval table).

> **Correction (2026-06-21, RULING):** the paint-function offsets formerly cited from
> `docs/ADVISOR_REPORTS_AUDIT.md` (`0x025F18`/`0x025A0A`/`0x0269D8`/`0x027010`/`0x0277D8`/
> `0x027B0C`/`0x027E48`/`0x025FD0`) are **broken-thunk artifacts** — `0x025F18` is
> mid-instruction garbage. The **real** report bodies live at `0x37xxx–0x3Axxx` (re-verified
> by disassembly). The PIK→report table was also a visual guess; the true art is
> `REPORT<N>.PIK` with `N` = the report's title number. See `notes/rulings/RULINGS.md`
> 2026-06-21.

## 0. Common framework (all reports)
- **Dispatcher** `@0x2BDEA..0x2BED5` (raw-verified): scan codes `0x13C..0x144` (+ menu letters
  'A'..'I') → `lcall 0x191F:0x3xx` thunk per report; pushes power_idx (`[0x8542]+0x1A`). **B**
- **PIK loader** `func_037340` (`@0x37340`): `strcat("REPORT") + sprintf(N) → load_PIK`
  (`0x181F:0x44E`), nation quartet `[0x2DA8/2DAA/2DAC/2DAE]`. The **only** REPORT-PIK load
  site. **B**
- **Title:** centered LABELS `@MISC` string drawn from the body's `push N` value; title
  fill-rect color `0x90`. **B**
- **Footer:** "OK" (`@MISC`) bottom-right. **B**

## 1. Per-report bodies (real offsets, raw-verified)

| F | Report | Body `@file` | title `push N` → PIK | title `@MISC` | per-row text color |
|---|--------|--------------|----------------------|---------------|--------------------|
| F2 | Religious | **0x37958** (`enter 0x2c`) | N=2 → REPORT2 | "RELIGIOUS ADVISER REPORT" | immigrant text 0xF; crosses 0x39/0x38 |
| F3 | Cont. Congress | **0x37A10** (`enter 0x6e`) | N=3 → REPORT3 (+CCBKGD) | "CONTINENTAL CONGRESS ACTIVITIES" | rows 0x92, FF-grid 0x61; bells 0x3F/0x38 |
| F4 | Labor | **0x38418** (`enter 0x120`) | N=4 → REPORT4 | "LABOR ADVISER REPORT" | labels 0x92 / counts 0x61; sep 0x137 |
| F5 | Economic | **0x38A50** (`enter 0x8c`) | N=5 → REPORT5 | "ECONOMIC ADVISER REPORT" | sep 0x13F |
| F6 | Colony | **0x39218** (`enter 0x68`) | N=7 → REPORT7 | "COLONY ADVISER REPORT" | colony name 0x92 |
| F7 | Naval | **0x3954C** (`enter 0x6a`) | title via 0x39E3F → `@MISC` 52 | "NAVAL ADVISER REPORT" | all cells 0x61 |
| F8 | Foreign | **0x39888** (`enter 0x72`) | N=8 → REPORT8 | "FOREIGN AFFAIRS REPORT" | strength rows 0x91; sep 0x13F |
| F9 | Indian | **0x39EE2** (`enter 0x7e`) | title → `@MISC` 29 | "INDIAN ADVISER REPORT" | rows 0x92 |
| F10 | Score | selector `func_03A9C0` `@0x3A9C0` | SCORE(panel+1).SS over WOODPAN2 | "COLONIZATION SCORE" | — |

All `@MISC` titles verified present in `LABELS_sections.json`. **B** (offsets + title-N all
raw-disassembled this pass).

### Fonts & colors (resolved 2026-06-21)
- **Font:** every report **body (F2–F9) uses FONTTINY** — each body reads the `[0x89E]`
  (FONTTINY) descriptor for row pitch, with **no second-font switch** (B). **F10 score** also
  reads `[0x268A]` (`@0x3B054`/`0x3B0E6`) for the big-figure glyph metrics — and **`[0x268A]` is
  FONTINTR.FF, not FONTKING**: it is loaded from the string `fontintr`@0x2389 at 0x760CB
  (byte-verified; corrects the prior "FONTKING by usage A/R" — RULING 2026-06-21). So F10 = FONTTINY
  labels + FONTINTR figures; **no report uses FONTKING** (the `FONTKING` string loads only in the
  king-defeats screen). **B.**
- **Colors** resolve via the shared **REPORT\*.PIK palette** (identical across REPORT2/3/4/5/7/8/9
  for every cited index) → exact RGB (B): `0x0F`→(255,255,255) white; **title fill `0x90`**→
  (255,255,190); `0x91`→(255,255,142); `0x92`→(255,243,93); `0x61`→(247,243,199) cream. Byte-cited
  pushes: title `push 0x90 @0x37970`, F2 `push 0x0F @0x379D9`, F3 `push 0x61 @0x37FF7`, F6
  `push 0x92 @0x39335`, F8 `push 0x91 @0x39973`.
- **Correction:** `0x39/0x38/0x3F/0x7C/0x7D` are **ICONS.SS sprite indices** — **discrete**
  filled/empty indicator sprites (crosses/bells, one per count) and the rebel / tory / REF
  tiled-strip sprites, **not** text colors and **not** a continuous progress/fill bar (the game
  has no fill bars — RULING 2026-06-21).
- **F4/F8 column separators — RESOLVED 2026-06-21 (B; the earlier "16-bit color-run/pattern,
  TBD" guess was wrong).** The `dx` args `0x137`/`0x13F` are **right-edge x-coordinates**, not
  colors: the call is `lcall 0x191F:0x8BC` → `func_00DFCC`, a clipped horizontal run-fill
  (`mov al,[bp+6]; mov es:[di],al; inc di; loopne`). F4 separator @0x3887D: x-start `ax=2`,
  **x-end `dx=0x137`=311**, y `bx=row·8+0x2A`, **color `push 0x77`** (@0x3886F). F8 @0x39908:
  x-start `ax=0`, **x-end `dx=0x13F`=319**, color `push 0x77`. **`0x77`→(134,0,0) dark-red**
  (resolved via REPORT4/REPORT8.PIK, both `#860000`) — a solid dark-red horizontal rule.

## 2. Report-specific detail

> **Per-line layout model — RESOLVED 2026-06-21 (B for the static immediates).** Unlike F7 (a
> true fixed-pitch table), F2/F5/F8/F9 build each line into a stack buffer and draw it once; the
> **per-row y is a flow accumulator advanced by the FONTTINY glyph height** (`les bx,[0x89E];
> mov al,es:[bx]; add y,al(+2)`) — a font-derived value, **not** a literal gap. What **is** static
> (and now byte-cited → **B**) is each report's **x-columns + y-start**; live counts/gold/prices
> stay game-state. The column/y immediates below are re-disassembled against VICEROY.EXE.

- **F2 Religious:** per-colony grid of crosses + colonist counts; iterates colonies; cross
  gauge sprites filled `0x39`/empty `0x38`. ColonyRecord `+0x1F` size, profession byte for
  missionaries. Static layout (**B**): name x=**4** (`@0x37A49`, reset x=0 `@0x38109` for the 2nd
  sub-table; secondary cols +0x4E=78 `@0x3800C`, +0x69=105 `@0x383BE`); y-start **0x19=25**
  (`@0x37A4E`, reset 0x1C=28 `@0x380A9`); colors `0x92`/`0x61`, one cell y=30/x=14 `@0x38274`.
  **B (layout) / R (per-row y = FONTTINY flow; counts live)**
- **F4 Labor:** profession columns × per-colony counts; tally by NAMES `@JOB`. Static grid
  (**B**, F7-like): name x=**2** (`@0x3889F`), **y-base 0x2A=42** (`@0x388A4`), **row pitch 8**
  (`@0x389C2`); profession-column x = `di+0xC`/`di+0x27` (`@0x3862F`/`@0x3866E`, di = computed
  column base → state). **B** (body + grid).
- **F5 Economic:** treasury gold (PowerRecord `+0x2A`), tax (`+0x01`), per-commodity
  price_level (`+0x4C`) / vol_accum (`+0x5C`), "(Building Upkeep)"/"TOTAL UPKEEP". Static columns
  (**B**): header x=**76/170/220** at y=25 (`push 0x4C @0x38AF6`, `mov ax,0xAA @0x38B63`,
  `mov ax,0xDC @0x38B90`); commodity table x=2 stride 0x11=17 (`@0x38F3C`/`@0x3903F`), value
  column x=250/150 stride 12 (`@0x38FEF`/`@0x3916C`); y-start 25/33, pitch 8 (`@0x38AEB`/
  `@0x38BE2`/`@0x38E33`); right-aligned numerics = `anchor − strwidth` (`lcall :0x204`, live).
  **B** (columns) / live values.
- **F6 Colony:** per-colony row name/size/production/SoL/sentiment via the colony-header panel
  (`call 0x39E58`, N=7). **4 centered column captions** (**B**, F7-style): color `0x92`, **y=27**,
  `(x,box)` = **(2,80)/(82,80)/(162,80)/(242,76)** (`@0x3945C`/`@0x39480`/`@0x394AA`/`@0x394CE`);
  body name x=2, content x=20 stride 17 (`@0x3922C`/`@0x392A4`), row pitch 12 (`@0x395C8`). **B**
- **F7 Naval:** TABLE, **20-px row grid** — first row y=42, pitch 20, 7 ships/page, name LEFT
  at x=26 (via 0x13C), Location/Destination CENTERED (0x100, box w=80/76 at x=162/242), cargo
  = sprite row. Geometry now corroborated by F7 body bytes → upgrade **A→B**. UnitRecord base
  0x3146 stride 0x1C, ship-type filter. **B**
- **F8 Foreign:** **gate polarity corrected** — `test [0x5382],1; je body` ⇒ when bit0 is
  **SET** (WoI declared) it draws `@FOREIGNNOTAVAIL` (`push 0x11B6`); when **CLEAR** it draws
  the 4-power diplomacy/strength table (strength rows `@MISC` 95–102, color 0x91). The
  separate "View Whose Report?" nested-picker function is **not** `func_039888` and is still
  **TBD**. Static columns (**B**): first column x=**0xD=13** (`@0x398DD`, 2nd col = `+strwidth`),
  cell x literals **0x50=80 / 0xA0=160** (`@0x399C7`/`@0x39A13`/`@0x39B13`), color `0x91`, row
  base 2 (`@0x398D8`); one cell color is state-driven (`cmp [bp-0x70],1; …; +0xF` `@0x39BE9`).
  **B (gate + columns) / TBD (picker)**
- **F9 Indian:** per-tribe row; NativeSettlement table DGROUP `0x54EC` stride 18 (+0x02 owner,
  +0x04 pop, +0x05 mission); NAMES `@TRIBES`. Static layout (**B**): status/mission column
  x=**0x10=16** (`@0x3A28A`, then +0x48=72 `@0x3A307`, +0x14=20 `@0x3A4A0`); y-start **0x18=24**
  (`@0x3A09A`, 2nd block 0x96=150 `@0x3A3B0`). **Cell text color is the runtime global `[0x830]`**
  (`mov al,[0x830]; push ax` @0x3A271) — i.e. the **NAMES `@COLORS` "basic" slot** (index 68 →
  (85,150,52) green via VICEROY.PAL; the title uses `[0x831]`="hilite" 149→(199,162,32) gold),
  cross-confirming the minimap `@COLORS` decode (`map_view.md` §6.1). **B.**
- **F10 Score:** `func_03A9C0` (`@0x3A9C0`) computes `scaled = value·(diff+4(+1≥3)(+1≥4))/100
  >>1`, then loops `i=1..24` choosing `panel = i-1` for the largest `i` with `i·i/3 ≥ scaled`
  (clamped 0..23), and loads **`SCORE(panel+1).SS`** (one band plate, not a per-line map) over
  background **WOODPAN2**. Font = **FONTTINY** labels + **FONTINTR** big-figure metrics (`[0x89E]`
  @0x3ABF4, `[0x268A]`=FONTINTR @0x3B054) — **not** FONTKING. Body lines from `@MISC` (Citizens / Independence /
  Villages Burned / Foreign Recognition / Total Score + FF list + Rebel Sentiment). **B**

## 5. Evidence
- `raw/COLONIZE/VICEROY.EXE` (capstone 16-bit, this pass): F2 `@0x37958`, F4 `@0x38418`
  (+`push 4 @0x38429`), dispatcher `@0x2BDEA`, loader `@0x37340` (REPORT+N), `func_03A9C0`
  `@0x3A9C0`; strings REPORT@0x11A2 / SCORE@0x11CF / WOODPAN2@0x11D7 (DGROUP base 0x1D9A0). **B**
- `viceroy_source/docs/drawlist/REPORTS.md` — the real body-offset table (offsets here
  raw-confirmed; supersedes `docs/ADVISOR_REPORTS_AUDIT.md`, whose offsets are disproven). **B**
- `docs/RENDERER_GEOMETRY.md` "Naval Adviser Report v3". **A**
- `data_extracted/text/{LABELS,MENU,NAMES}_sections.json` — `@MISC` titles/rows, `@REPORTS`,
  `@JOB`/`@TRIBES`. **B**

## 6. Open questions (TBD)
1. ✅ **F8 "View Whose Report?" nested power-picker — RESOLVED 2026-06-21 (B).** The picker is
   in the command/menu dispatcher `func_0235D6`, block `@0x23810`: it seeds the default from the
   viewed-power global `[0x5396]`, runs the generic TXT-menu builder (`lcall 0x181F:0x998` with
   section "SETREPORT" / file "DEBUG"), and `dec ax` maps the 1-based result to power **0..3**
   (English/French/Spanish/Dutch); the sibling SETVIEW handler `@0x23D52` commits it to
   `[0x5398]/[0x5394]/[0x5396]`. The F8 body reads the focus flag `[0x53A2]` (0 ⇒ 4-power table,
   else single-power branch `@0x39B27` indexed by `[0x53D2]`). **B** (only the exact per-key
   sub-handler that copies `[0x5396]→[0x53A2]/[0x53D2]` is left as a minor R).
2. ✅ **Per-report intra-row label (x,y) for the non-Naval reports — RESOLVED 2026-06-21 (B for
   the static immediates).** The static **x-columns + y-start** are now byte-cited per report
   (§2): F4 is a clean F7-style grid (name x=2, y-base 42, pitch 8); F6 has 4 centered captions
   (x=2/82/162/242, box 80/80/80/76, y=27); F2/F5/F8/F9 carry byte-cited x-columns (e.g. F5
   76/170/220; F8 13/80/160; F9 16/+72/+20) and y-starts (F2 25/28, F5 25/33, F9 24/150). The
   **per-row y is a FONTTINY line-height flow accumulator** (`add y,[0x89E].h`), and F9's text
   color is the runtime `[0x830]` `@COLORS` slot — both are computed/state, not layout gaps. Font
   (FONTTINY) + colors resolved (§1). **B.**
3. ✅ **`@MISC` title-label loader — CLOSED 2026-06-21 (B).** Each `[DS:0x2Dxx]` slot is filled
   by the indexed loop in `func_0749E0` `@0x75226..0x7523C` (`intern token 0x1A1F:0xB16 →
   mov [bx+0x2DBA],ax`, `0xDD=221` entries), so **`label_slot = 0x2DBA + @MISC_index·2`** — a
   linear pointer array, not a push-N table. Verified: F2 `[0x2DF6]`=idx30, F3 `[0x2E04]`=idx37,
   F4 `[0x2E1C]`=idx49, F8 `[0x2E78]`=idx95 (all `0x2DBA+idx·2`). (Disproves the prior
   "`func_0749E0` stops at `0x2DB0`" claim.)
4. F3 REF/2nd-force icon ids are read from runtime DGROUP cells `[0x5286/0x52A2/…]` — those are
   live **game-state values** (the current REF composition), not a static layout gap.
