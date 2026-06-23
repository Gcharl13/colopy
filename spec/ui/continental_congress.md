# Continental Congress

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.
> Substantive: state→display map, FF-acquisition reveal mechanism, and F3-body fonts/colors are
> **B**; band geometry **A**. **No graphical progress bar** (RULING 2026-06-21). Residuals:
> bell/US-flag/REF sprite IDs (A/TBD — absent from the F3 text body) and reveal-popup chrome (TBD).

**Overall confidence:** band geometry **A**; state→display memory map **B** (REF base, portrait
table, owned-FF bitmap now raw-EXE-verified); FF-acquisition portrait-reveal mechanism **B**. ·
**Canonical primary:** `ghidra_export/VICEROY_decompiled.named.c` (`congress_screen_render`
25583, `congress_portraits_draw` 25547), `raw/COLONIZE/VICEROY.EXE`,
`docs/ADVISOR_REPORTS_AUDIT.md` F3, `docs/SESSION_UI_CATALOG.md` §3 (overlay band geometry).

> **Updates (2026-06-21, raw-EXE-verified):** (a) the CC-NN portrait blit loop
> (`congress_portraits_draw`) is the **FF-acquisition reveal animation**, not the F3 list —
> reconciling the "text-only Activities / portraits in popup" split (now **B** mechanism).
> (b) The portrait-id table `DG8(0x123A+i)`, the owned-FF bitmap (stride `0x13C`, base
> `−0x77F1`), and the REF array base `0x53DA` are byte-confirmed. (c) The `DGROUP:0xE7AC`
> FF-threshold table is **unsupported** (zero raw immediate hits) — the threshold is
> *computed* by `func_03C282`; demoted to TBD (see §6).

## 1. Purpose
The Continental Congress Activities screen (also reachable as advisor report F3). Shows progress toward the next Founding Father, Rebel/Tory sentiment, bells/turn, the King's Expeditionary Force (REF) by unit type, and the list of acquired Founding Fathers. Surfaces as an overlay on CCBKGD.PIK. **A** (`SESSION_UI_CATALOG.md` §3).

## 2. Layout — "what is drawn where"
Native 320×200. Bands frame-verified via luma analysis (originally `RENDERER_GEOMETRY.md` v3, now
removed; the overlay source survives as `SESSION_UI_CATALOG.md` §3 frame 1310124562, tier **A**).

| Region | Pixel rect | Tier | Notes |
|--------|-----------|------|-------|
| Title | (0, 0, 320, 10) | A | "CONTINENTAL CONGRESS ACTIVITIES" |
| Session subtitle | (0, 10, 320, 20) | A | "Next Continental Congress Session: (\<FF\>) (NN in MM)" — the **progress is this text, not a bar** |
| Sentiment strip | (0, 36, 320, 8) | A | "Rebel Sentiment: X%   Tory Sentiment: Y%" |
| Bell icons row | (0, 44, 320, 32) | A/TBD | **discrete** bell sprites (one per bells/turn) — *not in the F3 text body* (§6.1); luma-observed only, may be a separate overlay path |
| REF / FF list | (0, 76, 320, 40) | A | 4 REF unit groups w/ count badges |
| Founding Fathers list | (0, 116, 320, 60) | A | acquired FF names (plain green text, not portraits) |
| OK button | (290, 184, 26, 14) | A | bottom-right |

> **No progress bar (RULING 2026-06-21).** An earlier row claimed a graphical
> "Progress bar (0,30,320,6) — yellow fill = bells_current/threshold" (tier A, luma-guessed from
> the since-removed `RENDERER_GEOMETRY.md`). It is **deleted as fabricated**: (1) the game has **no graphical
> progress/fill bars anywhere** (user ground-truth, top of the truth hierarchy), and (2) the F3
> paint body (`0x37A10`, fully disassembled) is **text/box only** (§6.1) — a text/box routine
> cannot draw a fill bar. Progress toward the next Founding Father is conveyed **only** by the
> **"(NN in MM)" text** in the session subtitle, where `NN = threshold − bells_current`,
> `MM = threshold` (session-subtitle text + computation, F3 body `0x37A10`). **B** (text + computation).

### Fonts & colors (F3 body `0x37A10..0x3807D`, byte-grounded 2026-06-21)
- **Font = FONTTINY** for the whole F3 body — it reads the `[0x89E]` (FONTTINY) latch **6×** and
  `[0x268A]` (=FONTINTR, byte-verified — *not* FONTKING; RULING 2026-06-21) **0×** (B). The
  geometry doc's "FONTKING title" is **not supported** — FONTKING loads only in king-defeats; the
  title is centred FONTTINY text via `0x181F:0x100` → mark FONTKING-title **R (refuted)**.
- **Colors** (resolved via **CCBKGD.PIK** palette): **title `0x90`→(255,255,190)** pale-yellow;
  **all body/row text `0x92`→(255,243,93)** bright-yellow (B — the trailing color arg to each
  `0x181F:0x13C`/`0x100` text draw). Layout latches: left margin **x=4**, running **y seed 0x19=25**,
  advanced by `[0x89E]` glyph-height+2 per line.
- **Correction (sprite-vs-color trap):** the *only* colors in the body are `0x90`/`0x92`.
  `0x3F`/`0x38` and the REF-row icons (from `[0x5286]/[0x52A2]/…`) are **ICONS.SS sprite ids**
  (`0x39` filled / `0x38` empty are the game's **discrete** indicator sprites — *not* a continuous
  bar), `0x61` is the FF-list **marker** sprite, and `0x12C`=300 / `0x4E`=78 are a numeric **scale**
  / REF **column stride** — none are text colors, and none is a progress-bar fill. (Bell/US-flag
  sprites are legitimately absent from this F3 text body — §6.1.)

**FF portrait slots (25, CC-NN.SS):** the 25 portraits CC-00..CC-24 map 1:1 to NAMES
`@FATHERS` order. On this **Activities** screen the acquired-FF list renders as **plain text**
(frame 1310124562). The CC-NN blits live in the **FF-acquisition reveal popup**, now
byte-grounded: `congress_screen_render(power, new_ff)` loads CCBKGD.PIK, then runs a two-phase
reveal — draw owned portraits *without* the new bit → present → set the owned bit
(`ff_set_owned_bit`) → redraw → present (the "portrait lights up"). `congress_portraits_draw`
loops `i=0..0x18`, reads portrait id `DG8(0x123A+i)` (raw-verified @0x386D8, the `0x123A`
immediate occurs exactly once), tests the per-power owned bitmap (`lcall 0x181F:0x7B4`, stride
`0x13C`, base `−0x77F1`, bit `1<<(ff&7)`), builds the `"CC-NN"` path, and **blits each owned
portrait at the sprite's own baked `frames[0].x/.y`** (`ss_blit(&sheet,0,frame.x,frame.y)`
25574) — i.e. screen positions come from inside each CC-NN.SS, not a code-side grid. **B
(mechanism)**; popup chrome (frame/title/OK) **TBD** (no frame capture).

## 3. Assets & text
- **Background:** CCBKGD.PIK full-screen (scribe at desk). REF unit icons + bell + US flag from ICONS.SS. FF portraits: CC-00..CC-24.SS (1 per FF, indices = `@FATHERS` order). **A/B**
- **Title** LABELS `@MISC` "CONTINENTAL CONGRESS ACTIVITIES" (verified in `LABELS_sections.json`). **B**
- **Labels** (verified `@MISC`): "Next Continental Congress Session", "Rebel", "Tory", "Sentiment", "Expeditionary Force", "Founding Fathers", "Rebels", "Tories", "OK". **B**
- FF names from NAMES `@FATHERS` (verified; Adam Smith / Jakob Fugger / Peter Minuit … confirmed in JSON). **B**

## 4. Interactions
- OK button → dismiss. **A**
- Reachable via REPORTS → F3 / menu-letter 'B' (`ADVISOR_REPORTS_AUDIT.md` dispatcher) and as the FF-acquired event screen. **B**

## 5. Evidence
- `docs/SESSION_UI_CATALOG.md` §3 — frame 1310124562, memory-tied display table, CC-NN→`@FATHERS` mapping. **A/B**
- Band geometry (§2 table) was originally luma-measured in the since-removed `RENDERER_GEOMETRY.md`
  "Continental Congress (VERIFIED v3)"; those bands are tier **A** (overlay/luma, not byte-cited) and
  now rest on `SESSION_UI_CATALOG.md` §3 (frame 1310124562) as the surviving overlay source. The
  state→display **memory map** (REF base `0x53DA`, portrait table `DG8(0x123A+i)`, owned-FF bitmap)
  is byte-verified in `ghidra_export/VICEROY_decompiled.named.c` + `raw/COLONIZE/VICEROY.EXE`. **A/B**
- `docs/ADVISOR_REPORTS_AUDIT.md` F3 — CCBKGD.PIK, title `@MISC[52]`. **B** *(its older
  "paint_func file 0x025FD0" is **stale/refuted** — that offset is colony stockpile-cell
  code; the real F3 body is `func_037A20` per the 2026-06-21 RULING, re-confirmed this pass.)*
- State→display (BYTE_VERIFIED): PowerRecord +0x02 rebel%, +0x0C bells_current, +0x0E
  bells/turn, **+0x12 FF-in-progress index** (the founding father being worked toward →
  name table `[bx−0x69AE]`; gated by phase `[0x5382]&1`, `@0x037A7A`/`@0x037AA2`), +0x14
  FF count (also the `≥0x19`→INDEPENDENCE gate, export 25502), +0x07 acquired-FF mask. **B**
- **F3 body re-verified (`func_037A20`, this pass):** title = report N=3 (`call 0x39E53`),
  fill `(0,0,320,5)` color `0x90`, centred title string `[0x2E04]` (`0x181F:0x100`); body
  x=4, y-seed 0x19, color `0x92`, FONTTINY. The bells row uses `0x181F:0x236` with **sprite
  id `0x3F`** (`ax=0x3F`, count `dx`, max `bx`, width `0x12C`) — a **discrete sprite row**,
  **confirming the no-fill-bar RULING** (it is *not* a continuous gauge). **B.**
- **Raw-EXE anchors (capstone 16-bit, this pass):** portrait-id table `DG8(0x123A+i)` @0x386D8
  (`0x123A` unique in image); owned-FF bitmap `mov al,[bx+si−0x77F1]`, power stride `0x13C`
  @0xBC10; REF u16 array base `0x53DA` (slots 0..3, `bx=slot<<1`) @0x34F2F. **B**
- REF DGROUP order: 0x53DA Regulars / 0x53DC Cavalry / 0x53DE Man-O-War / 0x53E0 Artillery
  (note the *screen* draws Artillery before Man-O-War); USER-VERIFIED values (23,10,5,8). **B**
- `data_extracted/text/{LABELS,NAMES}_sections.json` — `@MISC`, `@FATHERS` (verified). **B**

## 6. Open questions (TBD)
1. Bell sprite + US-flag ICONS.SS indices — **legitimately TBD (confirmed 2026-06-21).** The
   F3 paint body (`@file 0x37A10`, fully disassembled) is **text/box only** — it contains **no
   sprite blits** (`0x181F:0x254`/`0x2BC`) and no bell/flag immediate. So the bell row and US
   flag are **not** drawn in the F3 report; they live on the (separate) Activities/overlay path
   or are absent from this text report. The only byte-cited flag index **0x44** is the *colony*
   renderer's player flag (`push 0x44 @0x65C11`), **not** congress. Stays **TBD** for this screen.
2. ~~FF "next session" selection logic + DGROUP:0xE7AC threshold table.~~ **Mostly resolved
   2026-06-21.** Selection logic is **B** in the export: `ff_is_available` (25425) = not-owned
   AND all lower-index same-category fathers owned (category-gated walk over the 25-entry
   `FF_TABLE`), weighted by era band (`ff_weight_for_year` 25413; bands at 1600/1700). The
   **threshold ("129") is computed** by `func_03C282` (bell-cost curve, entry @0x03C282), **not**
   a static table — `0xE7AC` has **zero** raw immediate hits and is struck as speculative.
3. REF group sprite indices + count-badge geometry — sprites **R** (candidate ICONS indices
   Regulars/Cavalry/Man-O-War/Artillery not tied to this screen); geometry **A** (v3 bands).
4. CC-NN FF-acquisition reveal popup chrome (frame/title/OK) — **TBD** (mechanism byte-grounded
   in §2; only the popup decoration lacks a frame capture).
