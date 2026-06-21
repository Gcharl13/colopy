# End-Game & Cinematic Screens

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers:
> B (`BYTE_VERIFIED`) / A (`ANCHOR_VERIFIED`) / R (`RECONSTRUCTED`) / `TBD`.
> Substantive: the in-VICEROY painters (king-defeats `func_075352`, score `func_03A9C0`,
> Declaration `func_03DA2A`) and the `@OPENING`/`@CLOSING`/`@CREDITS` script tables are **B**;
> cinematic assets **A**. Remaining: OPENING.EXE/CLOSING.EXE per-frame timing + the `AMERICA.MOV`
> interpreter — being lifted from TBD via annotation of the in-repo `code/OPENING|CLOSING/disasm`
> (§ Open questions / §Opening / §Closing).

**Overall confidence:** in-VICEROY painters **B** (`func_075352` king-defeats argument
matrix, `func_03A9C0`+`func_039EE2` score screen, `func_03DA2A` DECOIND — all re-disassembled
2026-06-21); per-frame animation timing lives in the OPENING.EXE/CLOSING.EXE binaries, which **are
present and mechanically disassembled in-repo** (`code/OPENING/disasm` 145 fns, `code/CLOSING/disasm`
136 fns, 99.7% byte-identified) but **not yet semantically annotated** — so timing/`.MOV` stay
**TBD by Phase-2 effort**, not artifact-absence; out of the chosen VICEROY-only scope this pass.
**Canonical primary:** `docs/KING_AND_CINEMATIC_AUDIT.md`,
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
  `(sprite, frame, layer, width)` rows commented Wind/Sun/Monster1-3/Fish/
  "Bonk into land"/"Guy getting out"/"Opening logo"/"END OF DEMO". `@CREDITS`
  section = credit-roll timing rows. **B** (table present verbatim).
- **Assets (A):** `OPENING.PIK` bg + `OPEN*` sprites (OPENLOGO, OPENBORD,
  OPENGUY, OPENSHIP, OPENFISH, OPENSUN, OPENMON1-3, OPENWND1-2, OPENCRD1-3,
  OPENTILE, OPENBONK) per `docs/SESSION_UI_CATALOG.md`.
- **Tier:** script **B**; assets **A**; exact frame timing **TBD**.

## Closing cinematic (CLOS-BKG.PIK / CLOS-*.SS)
- **Purpose:** end credits / retirement celebration (Liberty Bell, fireworks).
- **Engine:** CLOSING.EXE (separate exe; only references `CONFIG.COL`). **A.**
- **Script (B):** `CLOSING_sections.json @CLOSING` — CSV rows commented
  Fireworks / Liberty Bell / Rock / Hat / Lady / Man / Military / "End of
  closing". **B** (table present verbatim).
- **Assets (A):** bg `CLOS-BKG.PIK`; sprites `CLOS-FWK` (fireworks),
  `CLOS-BEL` (Liberty Bell), `CLOS-ROC`, `CLOS-HAT`, `CLOS-LDY`, `CLOS-MAN`,
  `CLOS-MIL` per `docs/SESSION_UI_CATALOG.md` / `docs/KING_AND_CINEMATIC_AUDIT.md`.
- **Tier:** script **B**; assets **A**; frame timing **TBD**.

## Declaration of Independence (adjacent, VICEROY.EXE)
- **Purpose:** the signing cinematic + printed-document screen.
- **Painters (B):** `func_03DA2A` (DECOIND.PIK signing scene, disasm-cited);
  `DECLARAT.PIK` printed-document scene (loader **TBD**).
  `docs/KING_AND_CINEMATIC_AUDIT.md` §5.
- **Assets (A):** `DECOIND.PIK`, `DECLARAT.PIK` backgrounds; signature drawn from
  `DEC-LOWA..Z` + `DEC-UPPA..Z` + `DEC-SQIG` cursive-letter sprites (53).
- **Tier:** DECOIND painter **B**; DECLARAT loader **TBD**.

## KINGWIN / KINGLOSE sprite roles (reference)
- `KINGLOSE.SS` = king crying (player won the Revolution); `KINGWIN.SS` = king
  triumphant (player lost); `KING1.SS` = mocking king + bound colonist sub-variant.
  Naming is inverted vs game outcome (`docs/KING_AND_CINEMATIC_AUDIT.md` §5). **B**.
  `KING2.SS` (8-frame arm-raise animation) loader site **TBD** (§7).

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

The remaining items are **out of the chosen VICEROY-only scope this pass** — they live in the
OPENING.EXE/CLOSING.EXE binaries (not a runtime, and not absent — see below):
1. **OPENING/CLOSING frame timing & sequencing** — lives in `OPENING.EXE`/`CLOSING.EXE`, which
   **are present in-repo** (`raw/COLONIZE/OPENING.EXE`/`CLOSING.EXE` via `bin/reconstitute.py`)
   and **mechanically disassembled** (`code/OPENING/disasm` 145 fns, `code/CLOSING/disasm` 136 fns,
   99.7% byte-identified; `functions.json`, `rtlink_segments.md`). What is missing is **Phase-2
   semantic annotation** of those listings — every function is still `func_0XXXXX_unknown` (no
   Ghidra decompile, unlike VICEROY). The `@OPENING`/`@CLOSING`/`@CREDITS` script tables and asset
   lists are byte-present (**B**); the playback-engine *semantics* are **TBD by Phase-2 effort**,
   not by artifact-absence.
2. **AMERICA.MOV demo-script semantics** — the `.MOV` blob is extracted
   (`data_extracted/data/AMERICA_MOV.json`); the interpreter is among the (disassembled-but-
   unannotated) OPENING.EXE functions. **TBD by Phase-2 effort.**
3. **DECLARAT.PIK printed-document loader** — no string xref in VICEROY (likely overlay). **TBD.**
4. **`KING2.SS` animation loader** — the "KING2" string is not in any traced VICEROY
   function; the war-declaration cinematic loader is unlocated. **TBD.**
