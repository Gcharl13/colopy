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
  (FONTTINY) descriptor for row pitch, with **no second-font switch** (B). Only **F10 score**
  also reads `[0x268A]` (FONTKING) (`@0x3B054`) for the big score figures — **B** (F10 uses
  FONTKING); the `[0x268A]`=FONTKING.FF identity is by usage, **A/R**.
- **Colors** resolve via the shared **REPORT\*.PIK palette** (identical across REPORT2/3/4/5/7/8/9
  for every cited index) → exact RGB (B): `0x0F`→(255,255,255) white; **title fill `0x90`**→
  (255,255,190); `0x91`→(255,255,142); `0x92`→(255,243,93); `0x61`→(247,243,199) cream. Byte-cited
  pushes: title `push 0x90 @0x37970`, F2 `push 0x0F @0x379D9`, F3 `push 0x61 @0x37FF7`, F6
  `push 0x92 @0x39335`, F8 `push 0x91 @0x39973`.
- **Correction:** `0x39/0x38/0x3F/0x7C/0x7D` are **ICONS.SS sprite indices** (the gauge / rebel /
  tory / REF tiled-strip sprites), **not** text colors. The F4/F8 column line-fills use `dx`
  args `0x137`/`0x13F` which are **16-bit** (>255) → color-run/pattern args, **not** palette
  indices (**TBD** as a single RGB).

## 2. Report-specific detail
- **F2 Religious:** per-colony grid of crosses + colonist counts; iterates colonies; cross
  gauge sprites filled `0x39`/empty `0x38`. ColonyRecord `+0x1F` size, profession byte for
  missionaries. **B/R**
- **F4 Labor:** profession columns × per-colony counts; tally by NAMES `@JOB`. **B** (body);
  per-row (x,y) **A/R**.
- **F5 Economic:** treasury gold (PowerRecord `+0x2A`), tax (`+0x01`), per-commodity
  price_level (`+0x4C`) / vol_accum (`+0x5C`), "(Building Upkeep)"/"TOTAL UPKEEP". **B**
- **F6 Colony:** per-colony row name/size/production/SoL/sentiment via the colony-header panel
  (`call 0x39E58`, N=7). **B**
- **F7 Naval:** TABLE, **20-px row grid** — first row y=42, pitch 20, 7 ships/page, name LEFT
  at x=26 (via 0x13C), Location/Destination CENTERED (0x100, box w=80/76 at x=162/242), cargo
  = sprite row. Geometry now corroborated by F7 body bytes → upgrade **A→B**. UnitRecord base
  0x3146 stride 0x1C, ship-type filter. **B**
- **F8 Foreign:** **gate polarity corrected** — `test [0x5382],1; je body` ⇒ when bit0 is
  **SET** (WoI declared) it draws `@FOREIGNNOTAVAIL` (`push 0x11B6`); when **CLEAR** it draws
  the 4-power diplomacy/strength table (strength rows `@MISC` 95–102, color 0x91). The
  separate "View Whose Report?" nested-picker function is **not** `func_039888` and is still
  **TBD**. **B (gate) / TBD (picker)**
- **F9 Indian:** per-tribe row; NativeSettlement table DGROUP `0x54EC` stride 18 (+0x02 owner,
  +0x04 pop, +0x05 mission); NAMES `@TRIBES`. **B**
- **F10 Score:** `func_03A9C0` (`@0x3A9C0`) computes `scaled = value·(diff+4(+1≥3)(+1≥4))/100
  >>1`, then loops `i=1..24` choosing `panel = i-1` for the largest `i` with `i·i/3 ≥ scaled`
  (clamped 0..23), and loads **`SCORE(panel+1).SS`** (one band plate, not a per-line map) over
  background **WOODPAN2**. Uses FONTKING. Body lines from `@MISC` (Citizens / Independence /
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
2. Per-report intra-row exact label (x,y) for the non-Naval reports — full per-line coords are
   a deeper decompile (**A** where geometry docs measured, else **R**); the *font* (FONTTINY)
   and *color* are now resolved (§1).
3. ✅ **`@MISC` title-label loader — CLOSED 2026-06-21 (B).** Each `[DS:0x2Dxx]` slot is filled
   by the indexed loop in `func_0749E0` `@0x75226..0x7523C` (`intern token 0x1A1F:0xB16 →
   mov [bx+0x2DBA],ax`, `0xDD=221` entries), so **`label_slot = 0x2DBA + @MISC_index·2`** — a
   linear pointer array, not a push-N table. Verified: F2 `[0x2DF6]`=idx30, F3 `[0x2E04]`=idx37,
   F4 `[0x2E1C]`=idx49, F8 `[0x2E78]`=idx95 (all `0x2DBA+idx·2`). (Disproves the prior
   "`func_0749E0` stops at `0x2DB0`" claim.)
4. F3 REF/2nd-force icon ids are read from runtime DGROUP cells `[0x5286/0x52A2/…]` — those are
   live **game-state values** (the current REF composition), not a static layout gap.
