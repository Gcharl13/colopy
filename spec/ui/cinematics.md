# End-Game & Cinematic Screens

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers:
> B (`BYTE_VERIFIED`) / A (`ANCHOR_VERIFIED`) / R (`RECONSTRUCTED`) / `TBD`.
> Substantive: the in-VICEROY painters (king-defeats `func_075352`, score `func_03A9C0`,
> Declaration `func_03DA2A`) and the `@OPENING`/`@CLOSING`/`@CREDITS` script tables are **B**;
> cinematic assets **A**. The OPENING.EXE/CLOSING.EXE **per-frame timing is now byte-grounded**
> (real-time `[0x82]`/`[0x6c]` clock + frame-select cascade — `docs/CINEMATIC_TIMING_AUDIT.md`),
> KING2.SS is proven absent, and AMERICA.MOV is decoded (A/R). Residuals (resident draw routines,
> outer-driver clock) are listed in §Open-questions.

**Overall confidence:** in-VICEROY painters **B** (`func_075352` king-defeats argument
matrix, `func_03A9C0`+`func_039EE2` score screen, `func_03DA2A` DECOIND — all re-disassembled
2026-06-21); per-frame animation timing in OPENING.EXE/CLOSING.EXE is **now byte-grounded** (the
playback loops in `code/OPENING|CLOSING/disasm/orphans_load_image.asm` — real-time `[0x82]`/`[0x6c]`
clock + frame-select cascade, drawn `LCALL 0x392`/`0x2BC`; **B**), traced in
`docs/CINEMATIC_TIMING_AUDIT.md`; AMERICA.MOV decoded (A/R). Remaining residuals (the resident draw
routine, the outer keypress/clock driver) are narrow and listed there.
**Canonical primary:** `docs/CINEMATIC_TIMING_AUDIT.md`, `docs/KING_AND_CINEMATIC_AUDIT.md`,
`data_extracted/text/OPENING_sections.json`,
`data_extracted/text/CLOSING_sections.json`, `data_extracted/text/GAME_sections.json`.
**Last updated:** 2026-06-21.

## Overview — cinematic engine split

Three distinct binaries paint cinematics:
- **OPENING.EXE** — title / boot demo (`OPENING.PIK` + `OPEN*.SS` sprites,
  sequenced by `OPENING_sections.json @OPENING`).
- **VICEROY.EXE** — in-game endgame (King-defeats screen `func_075352`,
  score screen `func_03A9C0`, Declaration `func_03DA2A`).
- **CLOSING.EXE** — closing credits / retirement (`CLOS-BKG.PIK` + `CLOS-*.SS`,
  sequenced by `CLOSING_sections.json @CLOSING`).

Each cinematic-script section is a CSV table of `(sprite_idx, frame, ...)`
rows (byte-verified format in the JSON dumps). King-text overlays use GAME.TXT
keys with explicit `@x` / `@y` / `@width` directives. **A/B**.

## King-defeats screen (KINGLSS1/2.PIK)
- **Purpose:** revolution conclusion — King mocked (player wins) or triumphant
  (player loses).
- **Painter:** `func_075352` (file `0x075352..0x075593`, 578 bytes), tagged
  "KINGLSS","ENGLND","FRANCE". **B** (disasm-cited in
  `docs/KING_AND_CINEMATIC_AUDIT.md` §5).
- **Argument matrix (B):** background `KINGLSS<N>.PIK` where `N=bp+6` (1 or 2);
  nation art `ENGLND/FRANCE/SPAIN/DUTCH` + `N` from `[0x5398]`; King sprite:
  `bp+6=1,bp+8=1`→`KING1.SS`; `bp+6=1,other`→`KINGLOSE.SS` (king crying =
  **player WINS**, `@KINGLOSE`); `bp+6=2`→`KINGWIN.SS` (king triumphant =
  **player LOSES**, `@KINGWIN`).
- **Text (B):** `GAME @KINGLOSE` (`@width=68 @x=232 @y=31`, body
  "…let you go your own way…") and `GAME @KINGWIN` (`@width=90 @x=202 @y=125`,
  body "…Rag Tag armies are simply no match…"). Both bodies + geometry verified
  in GAME_sections.json. **B.**
- **Font + color (2026-06-21):** this screen is the **sole FONTKING user** in VICEROY.EXE —
  `func_075352` loads `FONTKING` (`lea bx,[0x232b]` @0x754F2, `lcall 0x1A1F:0xA86`), falls back to
  FONTTINY on failure, and promotes it to the active-font global `[0x1F9E]/[0x1FA0]` @0x75511; pen
  seed **(x=`[0x1F4A]`=0xF2=242, y=`[0x1F50]`=0x2F=47)** set @0x75526/0x7552C; style bits
  `[0x1F56]|=0x18` @0x75538; the text is drawn by the glyph engine `lcall 0x181F:0x3FE` @0x75540.
  Font + position **B**. **Text color:** the `0x181F:0x3FE` glyph engine takes **no explicit
  per-call palette arg** at this site — the on-screen color is the engine's glyph→palette mapping
  (FONTKING.FF foreground = 1-bpp pixel index 3), which is **runtime/engine-resident → A** (not
  byte-pinnable here). *(Correction 2026-06-21: `[0x1F5C]` is NOT the text color — it is the
  **speaker-portrait selector channel** (RULING): the dispatcher `func_06E3D0`/`func_06BE92` branch
  on it (≤7→`IND<tribe>`, =8→KING), and `cmp [0x1F5C],0; jl; call 0x6F82B(sprite struct +0x10..+0x16)`
  @0x6E319 renders the selected speaker sprite. My earlier "text fg = [0x1F5C]" was wrong.)*
- **Tier:** **B** (font/geometry/position/text-string); text RGB **A** (glyph-engine mapping).

## Score screen (SCORE01-24.SS) — **B (byte-grounded 2026-06-21)**
- **Purpose:** end-of-game score + honor-rating screen, one illustrated plate per
  **rating tier**.
- **Painter:** `func_03A9C0` (`@file 0x3A9C0`) — disassembled this pass. **B.**
- **Plate selection — RESOLVED (was "per-category TBD"):** the 24 `SCORE*` plates are
  **rating-tier art**, not per-category lines. `func_03A9C0` computes
  `scaled = rawscore·(diff+4(+1≥3)(+1≥4))/100 >>1`, then loops `i=1..0x18` choosing the
  largest `i` with `i·i/3 ≥ scaled`; `panel = i−1` clamped `[0,0x17]`. Filename =
  `"SCORE"(0x11CF) + ("0"(0x11D5) if panel<9) + (panel+1)` → **SCORE01..SCORE24**
  (`push 0x11cf @0x3AAAA`, `cmp [bp-0xc0],9; jge; push 0x11d5 @0x3AAB9`, both re-verified),
  drawn over background **WOODPAN2**. Font = **FONTTINY** labels (`[0x89E]` @0x3ABF4) +
  **FONTINTR** big-figure metrics (`[0x268A]` @0x3B054) — **not** FONTKING (RULING 2026-06-21;
  the `FONTKING` string loads only in king-defeats). **B.**
- **Score component sum** (`func_039EE2`, `@file 0x39EE2`): base `[0x53A8] + 0x64·[0x53A7]`
  (century-of-independence byte ×100, written by the Independence handler `func_03DE46`);
  "Foreign Recognition" = count of the 4 powers with `PowerRecord[+? ] & 4` (stride 0x13C);
  cross-ref `spec/systems/scoring.md`. **B.**
- **Text (B):** `LABELS @MISC` "COLONIZATION SCORE", "Citizens", "Independence", "Villages
  Burned", "Foreign Recognition", "Total Score"; honor flavor `GAME @EXPLOITS` + `@SCORE`
  (24-line honor-list, body present). **B.**
- **Tier:** painter + plate selector + component sum **B**; plate art identification **A**.

## Opening cinematic (OPENING.PIK)
- **Purpose:** title screen / boot demo (old-style world map with sea monsters).
- **Engine:** OPENING.EXE (separate exe; loads `AMERICA.MOV` script per
  `docs/KING_AND_CINEMATIC_AUDIT.md` §5). **A.**
- **Script (B):** `OPENING_sections.json @OPENING` — CSV of
  **`(sprite_idx, activation_time, layer, pan_width)`** rows commented Wind/Sun/Monster1-3/Fish/
  "Bonk into land"/"Guy getting out"/"Opening logo"/"END OF DEMO" (`-1`=END at time 891). `@CREDITS`
  section = credit-roll timing rows. **B** (table present verbatim; col3 pan-extent **A**).
- **Frame timing — RESOLVED 2026-06-21 (B; scope-expanded into OPENING.EXE).** The demo is a
  **real-time master clock**, not a fixed delay: the loop in `code/OPENING/disasm/orphans_load_image.asm`
  spins on the BIOS 18.2 Hz tick (`SUB cx,[0x6c]` @file `0x1335`) and advances demo clock `[0x82]`
  (`INC [0x82]` @`0x134D`); a `CMP [0x82],imm` cascade (`0x106A`…`0x10B8`,`0x117E`; thresholds
  135/153/173/195/220/236/252/507) selects the active frame; draw = `LCALL 0x392,0` @`0x111E`; loop
  exits on row count `[0x46]` (not a sentinel). The element X-pan over the wide `OPENING.PIK`
  panorama uses `_pan_x`/`_scr_map`/`_update_*_map_area` + `_ship_path`/`_load_ship_path`. Full
  trace: **`docs/CINEMATIC_TIMING_AUDIT.md` §1**. Delay quantum ≈ one tick (55 ms)/clock step.
- **Assets (A):** `OPENING.PIK` bg + `OPEN*` sprites (OPENLOGO, OPENBORD,
  OPENGUY, OPENSHIP, OPENFISH, OPENSUN, OPENMON1-3, OPENWND1-2, OPENCRD1-3,
  OPENTILE, OPENBONK) per `docs/SESSION_UI_CATALOG.md`.
- **Tier:** script **B**; assets **A**; **frame-timing mechanism B** (`CINEMATIC_TIMING_AUDIT.md`).

## Closing cinematic (CLOS-BKG.PIK / CLOS-*.SS)
- **Purpose:** end credits / retirement celebration (Liberty Bell, fireworks).
- **Engine:** CLOSING.EXE (separate exe; only references `CONFIG.COL`). **A.**
- **Script (B):** `CLOSING_sections.json @CLOSING` — CSV rows commented
  Fireworks / Liberty Bell / Rock / Hat / Lady / Man / Military / "End of
  closing". **B** (table present verbatim).
- **Frame timing — RESOLVED 2026-06-21 (B mechanism; scope-expanded into CLOSING.EXE).** The
  per-element composite loop in `code/CLOSING/disasm/orphans_load_image.asm` (`@0xB16`) walks a
  **stride-7 element table** (type `0x4B96` / active `0x4BA0` / sprite `0x4BA2`), draws via
  `LCALL 0x2BC,4` @`0xB91` (fade effect `LCALL 0x69B,0xE`, `ax=0x5A`=90 @`0xBAA`), and loops to the
  active-element count `[0x52]`; a companion erase/redraw pass is at `0xC57`. Per-element times live
  in the stride-7 table; the outer-driver real-time pacer (CLOSING's analogue of OPENING's
  `[0x82]`/`[0x6c]`) is **TBD**. Full trace: **`docs/CINEMATIC_TIMING_AUDIT.md` §2**.
- **Assets (A):** bg `CLOS-BKG.PIK`; sprites `CLOS-FWK` (fireworks),
  `CLOS-BEL` (Liberty Bell), `CLOS-ROC`, `CLOS-HAT`, `CLOS-LDY`, `CLOS-MAN`,
  `CLOS-MIL` per `docs/SESSION_UI_CATALOG.md` / `docs/KING_AND_CINEMATIC_AUDIT.md`.
- **Tier:** script **B**; assets **A**; **per-frame loop B**, outer-driver clock **TBD** (`CINEMATIC_TIMING_AUDIT.md`).

## Declaration of Independence (adjacent, VICEROY.EXE)
- **Purpose:** the signing cinematic + printed-document screen.
- **Painter (B):** `func_03DA2A` (DECOIND.PIK signing scene + signature glyph layout, disasm-cited;
  `docs/KING_AND_CINEMATIC_AUDIT.md` §5, full detail in `declaration_independence.md`).
  **`DECLARAT.PIK` is an ORPHAN** — the "DECLARAT" string is absent from every binary; the engine
  draws **DECOIND.PIK**. There is no DECLARAT loader to find (closed as a negative).
- **Assets (A):** `DECOIND.PIK` background; signature drawn from
  `DEC-LOWA..Z` + `DEC-UPPA..Z` + `DEC-SQIG` cursive-letter sprites (53).
- **Tier:** DECOIND painter + signature layout **B**; DECLARAT orphan **B** (negative).

## KINGWIN / KINGLOSE sprite roles (reference)
- `KINGLOSE.SS` = king crying (player won the Revolution); `KINGWIN.SS` = king
  triumphant (player lost); `KING1.SS` = mocking king + bound colonist sub-variant.
  Naming is inverted vs game outcome (`docs/KING_AND_CINEMATIC_AUDIT.md` §5). **B**.
  `KING2.SS` (8-frame arm-raise animation): **no loader exists** — "KING2" is absent from VICEROY,
  OPENING.EXE and CLOSING.EXE (`docs/CINEMATIC_TIMING_AUDIT.md` §4); treat as an orphan asset. **B** (negative).

## Evidence
- `docs/KING_AND_CINEMATIC_AUDIT.md` — `func_075352` argument matrix (KINGLSS,
  nation art, KINGWIN/LOSE/KING1), `func_03DA2A` (DECOIND), `func_037340`
  (REPORT loader), GAME.TXT `@KINGLOSE`/`@KINGWIN` geometry, OPENING/CLOSING exe
  split. **B/A**.
- `data_extracted/text/OPENING_sections.json` — `@OPENING`, `@CREDITS`,
  `@MESSAGES` script tables. **B**.
- `data_extracted/text/CLOSING_sections.json` — `@CLOSING`, `@MESSAGES` script
  tables. **B**.
- `data_extracted/text/GAME_sections.json` — `@KINGLOSE` (`@width=68 @x=232
  @y=31` + body), `@KINGWIN` (`@width=90 @x=202 @y=125` + body), `@EXPLOITS`,
  `@SCORE`. **B**.
- `data_extracted/text/LABELS_sections.json` `@MISC` — "COLONIZATION SCORE",
  "SCORING COMPLETE", score category words. **B**.
- `docs/SESSION_UI_CATALOG.md` — `SCORE01..24`, `OPEN*`, `CLOS-*`, `KINGLSS1/2`,
  `DEC-*` visual identification. **A**.

## Open questions (TBD)
*(Score plate→category mapping is RESOLVED 2026-06-21 — the plates are rating-tier art,
selected by `func_03A9C0`; see the Score-screen section above.)*

1. ✅ **OPENING/CLOSING frame timing & sequencing — RESOLVED 2026-06-21 (B mechanism).** Scope was
   expanded into `OPENING.EXE`/`CLOSING.EXE` (in-repo, `code/OPENING|CLOSING/disasm`). The playback
   is a **real-time master clock**: a BIOS-tick spin-wait advances demo clock `[0x82]` and a
   `CMP [0x82],threshold` cascade selects the active frame; loop exit is count-based. Full
   byte-cited trace (loop offsets, draw calls, panning subsystem) → **`docs/CINEMATIC_TIMING_AUDIT.md`**.
   Residual TBD: the resident draw routines (`LCALL 0x392`/`0x2BC`), the outer-driver keypress
   early-out, and CLOSING's outer clock offset (listed in that doc §5).
2. ✅ **AMERICA.MOV demo-script — partly resolved (A/R).** The `.MOV` blob
   (`data_extracted/data/AMERICA_MOV.json`) is a **1-bpp coastline/depth bitmap + ship-path waypoint
   list** (`_load_ship_path`/`_increments`/`_scr_depth`), `docs/CINEMATIC_TIMING_AUDIT.md` §3. Any
   non-bitmap header opcode grammar stays **TBD**.
3. **DECLARAT.PIK printed-document loader** — no string xref in VICEROY (DECLARAT is an **orphan**;
   the engine draws DECOIND.PIK, see `declaration_independence.md`). Closed as a negative.
4. ✅ **`KING2.SS` loader — RESOLVED (B, negative).** "KING2" is absent from VICEROY **and** from
   OPENING.EXE/CLOSING.EXE (grep over both disasm trees + `strings.json`,
   `docs/CINEMATIC_TIMING_AUDIT.md` §4) — no binary loads it via a traceable path; treat as an
   unused/orphan asset.
