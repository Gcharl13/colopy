# End-Game & Cinematic Screens

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers:
> B (`BYTE_VERIFIED`) / A (`ANCHOR_VERIFIED`) / R (`RECONSTRUCTED`) / `TBD`.
> Substantive: the three in-VICEROY painters are **B** — king-defeats `func_075352`
> (argument matrix + FONTKING context, re-disassembled 2026-06-21), score `func_03A9C0`
> (+ component sum `func_039EE2`), Declaration `func_03DA2A` (cross-ref `declaration_independence.md`).
> The OPENING.EXE / CLOSING.EXE per-frame timing is **byte-grounded** (real-time `[0x82]`/`[0x6c]`
> clock + frame-select cascade — `docs/CINEMATIC_TIMING_AUDIT.md`); cinematic asset *identification*
> is **A**. KING2.SS and DECLARAT.PIK are proven absent (**B**, negative). AMERICA.MOV is decoded
> (A/R). Residuals (resident draw routines, CLOSING outer-driver clock, glyph→palette text RGB) are
> **A/TBD** and listed in §7.

**Overall confidence:** in-VICEROY painters **B** (`func_075352`, `func_03A9C0`+`func_039EE2`,
`func_03DA2A` — all re-disassembled 2026-06-21); per-frame animation timing in OPENING.EXE/CLOSING.EXE
**B** (playback loops in `code/OPENING|CLOSING/disasm/orphans_load_image.asm`); asset identification
**A**; AMERICA.MOV **A/R**. · **Canonical primary:** `docs/KING_AND_CINEMATIC_AUDIT.md` §3/§5,
`viceroy_source/docs/drawlist/CHROME_AND_DISPATCH_INDEX.md` §B6, `docs/CINEMATIC_TIMING_AUDIT.md`,
`data_extracted/text/{GAME,LABELS,OPENING,CLOSING}_sections.json`. · **Last updated:** 2026-06-23.

---

## 1. Purpose

The cinematic and end-game screens that bracket a game of Colonization: the title/boot demo
(OPENING), the in-game endgame plates (King-defeats, Score, Declaration of Independence), and the
retirement/credits sequence (CLOSING). None of these is the live HUD — each replaces the screen with
a full-frame composite driven either by a PIK fullscreen background or by a scripted SS-sprite
sequence. **A** (`docs/SESSION_UI_CATALOG.md`, `docs/KING_AND_CINEMATIC_AUDIT.md` §5).

The Declaration of Independence screen has its **own** Layer-2 file
(`spec/ui/declaration_independence.md`); §5 here is a brief cross-reference only.

## 2. Engine split — three binaries, two paint mechanisms

Three distinct executables paint cinematics; within them, two paint mechanisms recur. This split is
the backbone of the spec — every cinematic below names which binary owns it and which mechanism it
uses. **B** (`docs/KING_AND_CINEMATIC_AUDIT.md` §5, `docs/CINEMATIC_TIMING_AUDIT.md`).

| Binary | Screens it owns | Background source | Foreground / sequencer |
|--------|-----------------|-------------------|------------------------|
| **OPENING.EXE** | Title / boot demo | `OPENING.PIK` panorama | `OPEN*.SS` sprites, sequenced by `@OPENING` script |
| **VICEROY.EXE** | King-defeats, Score, Declaration | `KINGLSS<N>.PIK` / `WOODPAN2` / `DECOIND.PIK` | in-game painters `func_075352` / `func_03A9C0` / `func_03DA2A` |
| **CLOSING.EXE** | Retirement / end credits | `CLOS-BKG.PIK` | `CLOS-*.SS` sprites, sequenced by `@CLOSING` script |

### 2a. Mechanism A — PIK fullscreen loader
A 320×200 background is loaded by name (`.PIK` appended in code) into the full frame, then overlays
are composited on top. In VICEROY this is `load_PIK_fullscreen` / `func_076B9E` via thunk
`0x181F:0x44E` (basename pushed as a DGROUP string ptr). Used by the King-defeats screen
(`KINGLSS<N>.PIK`), the Declaration (`DECOIND.PIK`), and the OPENING/CLOSING backgrounds. **B**
(`docs/KING_AND_CINEMATIC_AUDIT.md` §5, `declaration_independence.md` §3).

### 2b. Mechanism B — SS-sequence player
Each cinematic-script section (`@OPENING`, `@CLOSING`) is a CSV table whose rows drive a real-time
sequencer that selects/animates `*.SS` frames against a master clock. Row format is byte-verified in
the JSON dumps (§3, §4). King-text overlays inside VICEROY use GAME.TXT keys with explicit
`@x`/`@y`/`@width` directives (in GAME.TXT; stripped from the extracted JSON bodies — see §3 note).
**B** (`docs/CINEMATIC_TIMING_AUDIT.md` §1–§2).

---

## 3. King-defeats screen (KINGLSS1/2.PIK) — VICEROY.EXE

- **Purpose:** revolution conclusion — King mocked (player wins independence) or King triumphant
  (player loses the War of Independence). **A** (`docs/KING_AND_CINEMATIC_AUDIT.md` §5).
- **Painter (B):** `func_075352` (`@file 0x075352..0x075593`, 578 bytes, `ENTER 0x320`), tagged
  "KINGLSS"/"ENGLND"/"FRANCE"; disasm `code/VICEROY/disasm/func_075352_unknown.asm`. This is the
  shared **royal-audience dialog renderer** that also serves the endgame king-loss screen (str
  `[0x22F2]`="KINGLSS" @0x07536E). **B** (`KING_AND_CINEMATIC_AUDIT.md` §5,
  `CHROME_AND_DISPATCH_INDEX.md` §B6 row 15).

### 3a. Argument matrix (B)
Background, nation art, and King sprite are all selected by the two args `bp+6` (1 or 2) and `bp+8`,
plus player power index `[0x5398]`:

| `bp+6` | `bp+8` | Background | Nation art (`[0x5398]`→prefix) | King sprite | Outcome |
|--------|--------|-----------|--------------------------------|-------------|---------|
| 1 | 1 | `KINGLSS1.PIK` | `ENGLND1/FRANCE1/SPAIN1/DUTCH1.SS` | `KING1.SS` (mocking + bound colonist) | Sub-variant "1a" |
| 1 | other | `KINGLSS1.PIK` | `…1.SS` | `KINGLOSE.SS` (king crying) | **`@KINGLOSE` — player WINS** |
| 2 | any | `KINGLSS2.PIK` | `…2.SS` | `KINGWIN.SS` (king triumphant) | **`@KINGWIN` — player LOSES** |

Filename build: `KINGLSS` + `append_int(bp+6)` @0x07537D/0x075385; nation switch on `[0x5398]`
0→ENGLND / 1→FRANCE / 2→SPAIN / 3→DUTCH @0x0753BB then `append_int(bp+6)` (same `N`); King-sprite
branch `cmp [bp+6],1`@0x075430 / `cmp [bp+8],1`@0x075436. Naming is **inverted** vs outcome (KINGLOSE
sprite = king has lost = player won). **B** (`KING_AND_CINEMATIC_AUDIT.md` §5).

### 3b. Text + geometry (B string, A RGB)
- **Body (B):** `GAME @KINGLOSE` ("…we have decided to let you go your own way…") and `GAME @KINGWIN`
  ("…your Rag Tag armies are simply no match for our Royal forces.") — both bodies verified verbatim
  in `data_extracted/text/GAME_sections.json` (lines 485–486). **B.**
- **Layout directives (B):** `@KINGLOSE` `@width=68 @x=232 @y=31` (upper-right of KINGLSS1);
  `@KINGWIN` `@width=90 @x=202 @y=125` (lower-right of KINGLSS2). These directives live in
  `raw/COLONIZE/GAME.TXT` lines 3328–3345 and are cited from `KING_AND_CINEMATIC_AUDIT.md` §5; the
  extractor strips `@x/@y/@width` from the JSON body, so the geometry's primary is the audit/GAME.TXT,
  not the JSON. **B.**

### 3c. Font + color (B font/position; A text RGB)
This screen is the **sole FONTKING user** in VICEROY.EXE — `func_075352` switches the dialog text
context to FONTKING and overrides the dialog metric globals (`CHROME_AND_DISPATCH_INDEX.md` §B6):

| step | action | value | @asm |
|------|--------|-------|------|
| load FONTKING | `lea bx,[0x232B]("FONTKING"); lcall 0x1A1F:0xA86` | handle 0x232B | `0x0754F2` |
| set dialog font | `[0x1F9E]=ax; [0x1FA0]=dx` | FONTKING | `0x075511` |
| override pen X | `[0x1F4A]=0xF2` (242) | 0xF2 | `0x075526` |
| override pen Y | `[0x1F50]=0x2F` (47) | 0x2F | `0x07552C` |
| style bits | `[0x1F56] |= 0x18` | 0x18 | `0x075538` |
| run @-menu | `lcall 0x181F:0x3FE` (king's choice list) | — | `0x075540` |
| restore buffer | `push 0xA000; push 0xFC00; lcall 0x181F:0x3F4` | — | `0x075558` |

Falls back to FONTTINY on load failure. Spot-checks PASS: `0x0754F2 8d 1e 2b 23` (lea "FONTKING"),
`0x075526 c7 06 4a 1f f2 00` (`[0x1F4A]=0xF2`). Font + pen seed **B**. **Text RGB — A:** the glyph
engine `0x181F:0x3FE` takes **no explicit per-call palette arg**; on-screen color is the engine's
glyph→palette mapping (FONTKING.FF 1-bpp foreground = pixel index 3), runtime/engine-resident →
**A** (not byte-pinnable at this site).
- *Correction (RULING 2026-06-21):* `[0x1F5C]` is **not** the text color — it is the
  **speaker-portrait channel**. The name-builder `func_06BE92` (§3d) branches on it (≤7→`IND<tribe>`,
  >7→KING). An earlier "text fg = [0x1F5C]" claim was wrong.

### 3d. Sprite-sheet name builder `func_06BE92` (B)
`@file 0x06BE92..0x06BF11` (127 bytes), `code/VICEROY/disasm/func_06BE92_unknown.asm`,
`CHROME_AND_DISPATCH_INDEX.md` §B6. If `[0x1F5C] > 7` (king channel): `push 0x1F72("KING")` →
`KING.SS`, sets `[0x1F6E]=1`/`[0xA5AE]=1` @0x06BE9D. Else (native advisor): `push 0x1F77("IND0A0")`,
suffixed by channel byte @0x06BEF5 and tribe index @0x06BEFB → `IND<N>A<P>.SS`. Tail `call 0x6BE50`
loads the named sheet. Spot-checks: `0x06BE9D 68 72 1f` (push "KING"), `0x06BEE6 68 77 1f` (push
"IND0A0"). **B.**

- **Tier:** painter + argument matrix + FONTKING context + name builder **B**; text body + GAME.TXT
  geometry **B**; text RGB **A** (glyph→palette mapping).

## 4. Score screen (SCORE01–24.SS / WOODPAN2) — VICEROY.EXE — **B**

- **Purpose:** end-of-game score + honor-rating screen, one illustrated plate per **rating tier**.
  **A** (`docs/SESSION_UI_CATALOG.md`).
- **Painter (B):** `func_03A9C0` (`@file 0x03A9C0`; the leading 73 bytes 0x3A9C0..0x3AA09 are the
  score-formula head, the screen-paint continues into the adjacent overlay range re-disassembled
  2026-06-21). Disasm `code/VICEROY/disasm/func_03A9C0_unknown.asm`. **B.**
- **Plate selection (B) — RESOLVED (was "per-category TBD"):** the 24 `SCORE*` plates are
  **rating-tier art**, not per-category lines. `func_03A9C0` computes
  `scaled = rawscore·(diff+4(+1 if diff≥3)(+1 if diff≥4))/100 >> 1`, then loops `i=1..0x18`, choosing
  the largest `i` with `i·i/3 ≥ scaled`; `panel = i−1` clamped `[0,0x17]`. Filename =
  `"SCORE"(ptr 0x11CF) + ("0"(ptr 0x11D5) if panel<9) + (panel+1)` → **SCORE01..SCORE24**
  (`push 0x11cf @0x3AAAA`; `cmp [bp-0xc0],9; jge; push 0x11d5 @0x3AAB9`), drawn over background
  **WOODPAN2**. **B.**
- **Fonts (B):** **FONTTINY** labels (handle `[0x89E]` @0x3ABF4) + **FONTINTR** big-figure metrics
  (handle `[0x268A]` @0x3B054) — **not** FONTKING (RULING 2026-06-21: the `FONTKING` string loads
  only in king-defeats §3c). **B.**
- **Score component sum (B):** `func_039EE2` (`@file 0x39EE2`,
  `code/VICEROY/disasm/func_039EE2_unknown.asm`): base `[0x53A8] + 0x64·[0x53A7]` (century-of-
  independence byte ×100, written by the Independence handler `func_03DE46` which sets `[0x53A7] =
  year/100`); "Foreign Recognition" = count of the 4 powers with `PowerRecord[+?] & 4` (stride 0x13C).
  Cross-ref `spec/systems/scoring.md`. **B.**
- **Text (B):** `LABELS @MISC` provides "COLONIZATION SCORE", "Citizens", "Independence",
  "Villages Burned", "Foreign Recognition", "Total Score", "SCORING COMPLETE" (all verified present in
  `data_extracted/text/LABELS_sections.json`); honor flavor `GAME @EXPLOITS` ("COLONIZATION RATING:
  %NUMBER0%%…") + `GAME @SCORE` (24-line honor-list, body present) + `GAME @SCORED` ("Scoring for this
  game is now complete…") — all verified in `data_extracted/text/GAME_sections.json`. **B.**
- **Tier:** painter + plate selector + component sum + fonts + text **B**; plate-art *identification*
  **A**.

## 5. Declaration of Independence (cross-reference) — VICEROY.EXE

- **Purpose:** the signing cinematic. Painter `func_03DA2A` (DECOIND.PIK signing scene +
  signature glyph layout, byte-verified inline). **Full spec: `spec/ui/declaration_independence.md`.**
- **Key facts (B):** the engine draws **DECOIND.PIK** via Mechanism A (PIK loader `func_076B9E`,
  thunk `0x181F:0x44E`). The signature is composed glyph-by-glyph from `DEC-LOWA..Z` / `DEC-UPPA..Z`
  / `DEC-SQIG` cursive sprites; leader name read at `0x540E + [0x5398]·0x34`. **`DECLARAT.PIK` is an
  ORPHAN** — the "DECLARAT" string is absent from every binary; there is no DECLARAT loader (closed
  as a negative). **B** (`docs/KING_AND_CINEMATIC_AUDIT.md` §5, `declaration_independence.md`).
- **Tier:** see `declaration_independence.md` (DECOIND painter + signature layout **B**, DECLARAT
  orphan **B** negative). Not duplicated here.

## 6. Opening cinematic (OPENING.PIK) — OPENING.EXE

- **Purpose:** title screen / boot demo — old-style world map with sea monsters, ship landing,
  opening logo. **A.**
- **Engine:** OPENING.EXE (separate exe; Mechanism A background + Mechanism B sequencer). Loads
  `AMERICA.MOV` script. **A** (`docs/KING_AND_CINEMATIC_AUDIT.md` §5).
- **Script (B):** `OPENING_sections.json @OPENING` — CSV of
  **`(sprite_idx, activation_time, layer, pan_width)`** rows, verified verbatim and commented
  Wind1/Wind1/Sun/Monster1/Wind2/Monster2/Monster3/Fish/"Bonk into land"/"Guy getting out"/"Opening
  logo"/`-1`="END OF DEMO" (END at time 891). `@CREDITS` = credit-roll timing rows; `@MESSAGES` also
  present. **B** (table present verbatim; col-4 pan-extent identification **A**).
- **Frame timing (B mechanism) — RESOLVED 2026-06-21:** the demo is a **real-time master clock**, not
  a fixed delay. The loop in `code/OPENING/disasm/orphans_load_image.asm` spins on the BIOS 18.2 Hz
  tick (`SUB cx,[0x6c]` @file `0x1335`) and advances demo clock `[0x82]` (`INC [0x82]` @`0x134D`); a
  `CMP [0x82],imm` cascade (offsets `0x106A`…`0x10B8`,`0x117E`; thresholds 135/153/173/195/220/236/
  252/507) selects the active frame; draw `LCALL 0x392,0` @`0x111E`; loop exits on row count `[0x46]`
  (count-based, not a sentinel). Element X-pan over the wide `OPENING.PIK` panorama uses
  `_pan_x`/`_scr_map`/`_update_*_map_area` + `_ship_path`/`_load_ship_path`. Delay quantum ≈ one
  tick (55 ms)/clock step. Full trace: **`docs/CINEMATIC_TIMING_AUDIT.md` §1**. **B** (loop/clock/
  draw); panning subsystem symbol-names **A**.
- **Assets (A):** `OPENING.PIK` bg + `OPEN*` sprites (OPENLOGO, OPENBORD, OPENGUY, OPENSHIP,
  OPENFISH, OPENSUN, OPENMON1-3, OPENWND1-2, OPENCRD1-3, OPENTILE, OPENBONK) per
  `docs/SESSION_UI_CATALOG.md`. **A.**
- **Tier:** script **B**; frame-timing mechanism **B**; asset identification **A**.

## 7. Closing cinematic (CLOS-BKG.PIK / CLOS-*.SS) — CLOSING.EXE

- **Purpose:** end credits / retirement celebration (Liberty Bell, fireworks). **A.**
- **Engine:** CLOSING.EXE (separate exe; references only `CONFIG.COL` from the COLONIZE/ tree —
  everything else is its own bundled assets). Mechanism A background + Mechanism B sequencer. **A**
  (`docs/KING_AND_CINEMATIC_AUDIT.md` §5).
- **Script (B):** `CLOSING_sections.json @CLOSING` — CSV rows verified verbatim, commented
  Fireworks / Liberty Bell / Rock / Hat / Lady / Man / Military / `-1`="End of closing" (END at time
  390). `@MESSAGES` also present. **B.**
- **Frame timing (B mechanism; outer clock TBD) — RESOLVED 2026-06-21:** the per-element composite
  loop in `code/CLOSING/disasm/orphans_load_image.asm` (`@0xB16`) walks a **stride-7 element table**
  (type `0x4B96` / active `0x4BA0` / sprite `0x4BA2`), draws via `LCALL 0x2BC,4` @`0xB91`
  (fade effect `LCALL 0x69B,0xE`, `ax=0x5A`=90 @`0xBAA`), loops to active-element count `[0x52]`;
  companion erase/redraw pass @`0xC57`. Per-element times live in the stride-7 table; the
  outer-driver real-time pacer (CLOSING's analogue of OPENING's `[0x82]`/`[0x6c]`) is **TBD**. Full
  trace: **`docs/CINEMATIC_TIMING_AUDIT.md` §2**.
- **Assets (A):** bg `CLOS-BKG.PIK`; sprites `CLOS-BEL.SS` (22f Liberty Bell), `CLOS-FWK.SS`
  (67f fireworks), `CLOS-HAT.SS` (23f), `CLOS-LDY.SS` (22f), `CLOS-MAN.SS` (15f), `CLOS-MIL.SS`
  (21f), `CLOS-ROC.SS` (23f) per `docs/SESSION_UI_CATALOG.md` / `docs/KING_AND_CINEMATIC_AUDIT.md`
  §5. **A.**
- **Tier:** script **B**; per-frame loop **B**; outer-driver clock **TBD**; asset identification **A**.

## 8. Sprite-role reference (KINGWIN / KINGLOSE / KING1 / KING2)

- `KINGLOSE.SS` = king crying (player **won** the Revolution); `KINGWIN.SS` = king triumphant
  (player **lost**); `KING1.SS` = mocking king + bound-colonist sub-variant. Naming is **inverted**
  vs game outcome (`docs/KING_AND_CINEMATIC_AUDIT.md` §3/§5). **B.**
- `KING.SS` = the 1-frame standing King portrait used by the in-game audience popup (`@KINGTAX`
  etc.); not an endgame sheet. **B** (`docs/KING_AND_CINEMATIC_AUDIT.md` §3).
- `KING2.SS` (8-frame arm-raise animation): **no loader exists** — "KING2" is absent from VICEROY,
  OPENING.EXE and CLOSING.EXE (`docs/CINEMATIC_TIMING_AUDIT.md` §4); treat as an orphan asset.
  **B** (negative). (Earlier speculation that KING2 was an 8-level "anger states" sheet keyed by
  `[0x53A7]` is **not** supported — `[0x53A7]` is the century-of-independence byte, §4.)

## 9. Interactions

- **King-defeats / Score** are entered from the endgame flow at the conclusion of the War of
  Independence (player wins → `@KINGLOSE`; player loses → `@KINGWIN`), then the Score plate; each is a
  full-frame replacement with a final OK/continue dismiss through the shared @-menu (`func_075352`
  runs the @-menu @0x075540). **B** (painter); dismiss convention **R**.
- **Declaration** is triggered from the GAME menu → "DECLARE INDEPENDENCE" (verified in MENU `@GAME`)
  → `@PICKINDEPENDENCE` confirmation → DECOIND cinematic. See `declaration_independence.md` §4. **B.**
- **Opening** runs at boot from OPENING.EXE; the demo loop early-outs on a keypress (the outer
  keypress driver is part of the CINEMATIC_TIMING_AUDIT residual). **B** mechanism; keypress early-out
  **TBD** (`CINEMATIC_TIMING_AUDIT.md` §5).
- **Closing** runs from CLOSING.EXE on retirement; advances by its internal element timetable to the
  `-1` "End of closing" sentinel at time 390. **B** (script); outer pacer **TBD**.

## 10. Evidence

- `docs/KING_AND_CINEMATIC_AUDIT.md` §3/§5 — `func_075352` argument matrix (KINGLSS, nation art,
  KINGWIN/LOSE/KING1), `func_03DA2A` (DECOIND), `func_037340` (REPORT loader), `GAME @KINGLOSE`/
  `@KINGWIN` geometry (GAME.TXT lines 3328–3345), KING2 / DECLARAT negatives, OPENING/CLOSING exe
  split. **B/A**.
- `viceroy_source/docs/drawlist/CHROME_AND_DISPATCH_INDEX.md` §B6 — `func_075352` FONTKING context
  (load @0x0754F2, `[0x1F9E]/[0x1FA0]` @0x075511, metric overrides @0x075526/0x07552C, @-menu
  @0x075540) + sprite-name builder `func_06BE92` @0x06BE92; spot-checks PASS. **B**.
- `docs/CINEMATIC_TIMING_AUDIT.md` §1–§5 — OPENING/CLOSING per-frame loops, master clock, AMERICA.MOV
  decode, KING2 negative, residual TBDs. **B/A**.
- `code/VICEROY/disasm/{func_075352,func_03A9C0,func_039EE2,func_03DA2A}_unknown.asm` — painter
  disasm files (all present in tree). **B**.
- `data_extracted/text/GAME_sections.json` — `@KINGLOSE`, `@KINGWIN`, `@EXPLOITS`, `@SCORE`,
  `@SCORED` bodies (all verified present). **B**.
- `data_extracted/text/LABELS_sections.json @MISC` — "COLONIZATION SCORE", "SCORING COMPLETE",
  "Citizens", "Independence", "Villages Burned", "Foreign Recognition", "Total Score" (verified). **B**.
- `data_extracted/text/OPENING_sections.json` — `@OPENING`, `@CREDITS`, `@MESSAGES` script tables
  (verified). **B**.
- `data_extracted/text/CLOSING_sections.json` — `@CLOSING`, `@MESSAGES` script tables (verified). **B**.
- `docs/SESSION_UI_CATALOG.md` — `SCORE01..24`, `OPEN*`, `CLOS-*`, `KINGLSS1/2`, `DEC-*` visual
  identification. **A**.

## 11. Open questions (TBD)

1. ✅ **Score plate→category mapping — RESOLVED 2026-06-21 (B).** Plates are rating-tier art selected
   by `func_03A9C0`'s `i·i/3 ≥ scaled` loop (§4), not per-category lines.
2. ✅ **OPENING/CLOSING frame timing & sequencing — RESOLVED 2026-06-21 (B mechanism).** Real-time
   master clock: BIOS-tick spin advances `[0x82]`, a `CMP [0x82],threshold` cascade selects the
   active frame, loop exit count-based (`CINEMATIC_TIMING_AUDIT.md` §1–§2). **Residual TBD:** the
   resident draw routines (`LCALL 0x392`/`0x2BC`), the OPENING outer keypress early-out, and CLOSING's
   outer clock offset (that doc §5).
3. ✅ **AMERICA.MOV demo-script — PARTLY RESOLVED (A/R).** The `.MOV` blob
   (`data_extracted/data/AMERICA_MOV.json`) is a 1-bpp coastline/depth bitmap + ship-path waypoint
   list (`_load_ship_path`/`_increments`/`_scr_depth`, `CINEMATIC_TIMING_AUDIT.md` §3). Any non-bitmap
   header opcode grammar stays **TBD**.
4. ✅ **`KING2.SS` loader — RESOLVED (B, negative).** "KING2" absent from VICEROY + OPENING.EXE +
   CLOSING.EXE (`CINEMATIC_TIMING_AUDIT.md` §4); orphan asset.
5. ✅ **`DECLARAT.PIK` loader — RESOLVED (B, negative).** Orphan; the engine draws DECOIND.PIK
   (`declaration_independence.md` §3). Closed as a negative.
6. **King-defeats / score-screen text RGB — A (engine-resident).** The glyph engine `0x181F:0x3FE`
   takes no per-call palette arg; on-screen color is the FONTKING/FONTTINY glyph→palette mapping —
   not byte-pinnable at the call site. Tightening to B requires tracing the glyph engine's palette
   resolve or a DOS-frame pixel sample. **TBD at B.**
