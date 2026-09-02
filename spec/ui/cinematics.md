# End-Game & Cinematic Screens

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers:
> B (`BYTE_VERIFIED`) / A (`ANCHOR_VERIFIED`) / R (`RECONSTRUCTED`).
> Substantive: the three in-VICEROY painters are **B** — king-defeats `func_075352`
> (argument matrix + FONTKING context, re-disassembled 2026-06-21), score `func_03A9C0`
> (+ component sum `func_039EE2`), Declaration `func_03DA2A` (cross-ref `declaration_independence.md`).
> The OPENING.EXE / CLOSING.EXE cinematics are now **deeply byte-decoded** (2026-06-26): real-time
> clock, frame cascade, the **blit routine + calling convention**, the **asset-load order**, the
> **placement model** (table-driven + literal-centered exceptions), the ship-path PATH.DAT pipeline,
> and the CLOSING actor-schedule loop + sentinel exit (§6/§7). The only residual is **data-file
> contents** — the per-element literal X/Y/frame timelines live in the external OPENING anim file /
> PATH.DAT / CLOSING sequence file (each named with its load site + BSS table). KING2.SS and
> DECLARAT.PIK are proven absent (**B**, negative). AMERICA.MOV is decoded (A/R).

**Overall confidence:** in-VICEROY painters **B** (`func_075352`, `func_03A9C0`+`func_039EE2`,
`func_03DA2A` — all re-disassembled 2026-06-21); OPENING.EXE/CLOSING.EXE playback **B** (loops, blit
convention, asset-load order, placement model — `code/OPENING|CLOSING/disasm/orphans_load_image.asm`
+ capstone, decode-verify 2026-06-26); asset identification **A**; per-element literal coordinates
**resolved to committed data-files (B)** — the per-element literal X/Y/frame timelines are the committed CSV tables `data_extracted/text/OPENING_sections.json @OPENING` (anim: col1 sheet-idx / col2 activation-tick / col4 X-base 640|320, parsed by `_load_anims` @`0xDD2`) and `data_extracted/text/CLOSING_sections.json @CLOSING` (actors: col1 sheet-idx / col2 count / col5 Y-position, parsed by `func_000A00` @`0xA00`) plus PATH.DAT waypoints (`_ship[]` @`0x4f0c`); only the per-frame sprite-bbox Y is asset-derived (**A**). AMERICA.MOV **A/R** (`data_extracted/data/AMERICA_MOV.json`, structure decoded §11.3). · **Canonical primary:**
`docs/KING_AND_CINEMATIC_AUDIT.md` §3/§5, `viceroy_source/docs/drawlist/CHROME_AND_DISPATCH_INDEX.md`
§B6, `docs/CINEMATIC_TIMING_AUDIT.md`, `data_extracted/text/{GAME,LABELS,OPENING,CLOSING}_sections.json`.
· **Last updated:** 2026-06-26.

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

### 3e. Amendment 2026-09-02 — composition byte-complete, triggers re-read, ported (screens track)

Re-read of `func_075352` @0x075352..0x75593 and the two call sites (RULINGS 2026-09-02f), all **B**:

- **Composition.** `"KINGLSS"+N` (@0x7536E..0x75385) is loaded into the PIK buffer `[0x839E..]`
  with its palette at `[bp-0x320]` (@0x753A9). The banner `<NATION>+N` (@0x753BB..0x753F3) is
  loaded (@0x75405) and blitted **into the PIK buffer** with the anchored verb `0x181F:0x2F8`
  at its own frame-1 descriptor (`dx = es:[si+0x46]`, `y = es:[si+0x48]`, scale 0x64,
  `bx = [0x839E]` @0x7541A..0x7542B); the king sheet is selected @0x75430..0x75461 and blitted
  the same way (@0x75477..0x7549D); DAC ← the PIK palette (@0x754AD); buffer → screen 320×200
  (@0x754DB); present (@0x754ED). Every placement is therefore the sheet's own anchor —
  top-left = (hx − (w>>1), hy − h + 1): KING1 (94,198) 189×187 → **(0,12)**; KINGLOSE (74,198)
  149×179 → **(0,20)**; KINGWIN (134,198) 214×198 → **(27,1)**; ENGLND1/FRANCE1/SPAIN1/DUTCH1 →
  (32,0)/(30,0)/(35,0)/(34,0); ENGLND2 (139,132) 174×133 → **(52,0)**, FRANCE2 (137,130)
  176×131 → (49,0), SPAIN2 (144,127) 170×128 → (59,0), DUTCH2 (140,130) 170×131 → (55,0). The
  `*2` sheets are separate one-frame sheets (N=2 only — the defeat page); the old "portrait
  x=100" reading (row 13 of the tracker) was a pen-seed misread and is withdrawn.
- **Text.** FONTKING (@0x754F6; FONTTINY fallback @0x7550A..0x75514); `[0x1F4A]=0xF2`,
  `[0x1F50]=0x2F` @0x75526/@0x7552C are register seeds the runner `0x181F:0x3FE` @0x75540
  re-lays-out from the key's own directives (RULINGS 2026-07-31): `@KINGLOSE @width=68 @x=232
  @y=31`, `@KINGWIN @width=90 @x=202 @y=125` (GAME.TXT 3328–3341). The text is drawn ON the
  page — it is not a popup. Text RGB remains **A** (engine-resident).
- **Triggers** (`func_02F3A2`): victory @0x2F542..0x2F55F — `@WINNING` (`lea bx,[0xF18]`;
  `0x181F:0x3FE`) then `push 0xF20 "KINGLOSE"; push 2; push 1; lcall 0x191F:0xABA` =
  `func_075352(1, 2, "KINGLOSE")`, then `or [0x5382],8`; defeat @0x2F670..0x2F6B0 —
  `@LOSING<n>` (`"LOSING0"` + digit `[bp-0x5C]`) then `%STRING0 ← [bx-0x72BE]` (per-player,
  read by the ports as the country — identity TBD) and `push 0xF31 "KINGWIN"; push 1; push 2;
  lcall 0x191F:0xABA` = `func_075352(2, 1, "KINGWIN")`, `0x191F:0xAAC`, `jmp 0x2F44C` (the
  score). The boot audience is `func_075352(1, 1, @VICEROY)` @0x7555C3 (tune 0x3E @0x7544D).
- **Orphans (B-negative).** `KING2.SS`, `WIN.SS`, `WIN-FWRK.SS`: none of `KING2`, `\0WIN\0`,
  `WIN-`, `FWRK` occurs in VICEROY/COLONIZE/OPENING/CLOSING.EXE — never loaded, never packed.
- **Ports.** JS `drawKingText` (the runner), `drawKing`, `drawEndKing`; C `king_page`/`king_text`,
  `rm_draw_king`, `rm_draw_king_plate`; oracle `tools/render_endking_compare.py` (win / lose).

## 4. Score screen (SCORE01–24.SS / WOODPAN2) — VICEROY.EXE — **B**

- **Purpose:** end-of-game score + honor-rating screen, one illustrated plate per **rating tier**.
  **A** (`docs/SESSION_UI_CATALOG.md`).
- **Painter (B):** `func_03A9C0` (`@file 0x03A9C0`; the leading 73 bytes 0x3A9C0..0x3AA09 are the
  score-formula head, the screen-paint continues into the adjacent overlay range re-disassembled
  2026-06-21). Disasm `code/VICEROY/disasm/func_03A9C0_unknown.asm`. **B.**
- **Plate selection (B) — RESOLVED (was "per-category open"):** the 24 `SCORE*` plates are
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

### 4a. Amendment 2026-09-02 — the page byte-complete, the selector corrected, ported (screens track)

Re-read of `func_03A9C0` @0x03A9C0..0x3ADA2 (RULINGS 2026-09-02e). **Supersedes the selector
sentence above:** the band loop runs on the **un-halved** `mult·base/100` (`[bp-2]` @0x3AA3E;
`cmp ax,[bp-2]; jge` @0x3AA55/0x3AA58 — panel = i−1 for every i whose `i·i/3` is **below** it),
and `sar [bp-2],1` @0x3AA6A halves it **after** the loop for the printed `%NUMBER0`. No screen
when base ≤ 0 (@0x3AA00), panel < 0, display = 0, or the scored latch `[0x5382]&0x10`
(@0x3AA88..0x3AAA0). `[0x372]` @0x3A9E5/@0x3A9EC/@0x3AD9F is the palette-cycling enable
(saved/cleared/restored as on every PIK page), not a score accumulator.

**Composition** (all **B**): WOODPAN2.PIK is loaded straight into the screen surface (@0x3AAFF;
layer-fill 0 on failure @0x3AB20); the SCORE sheet then loads with the palette-receive pointer
`[0x23F2:0x23F4]` aimed at the PIK's palette buffer (@0x3AB46..0x3AB68), so the DAC upload
@0x3AB84 is the **plate's** table — WOODPAN2 shows through it (all 24 tables differ). Text is
FONTTINY (`[0x89E]` @0x3ABF4, H = 6) through the centred verb `0x181F:0x100(str, x, w, y,
colour)`: the three `@EXPLOITS` lines (`%STRING0` = the string at `0x5426 + [0x5398]·0x34`,
`%NUMBER0` = the halved rating; @0x3AB9D..0x3ABB9) at x=0 w=0x140, y = 5, 5+(H+1), 5+2(H+1),
colour 0xFC (@0x3ABC7..0x3AC0B); the `@SCORE` rows i = 0..panel (@0x3AC1A..0x3ACA8) at
y = 0xC3 − (H+1)(i+1), each line split at its comma (`0x191F:0xFC4` = file 0x6FA3E; the second
field left-trimmed by `0x1A1F:0xB44` = file 0xD972), field 1 centred in x=0xA0 w=0xA0
(@0x3AC89/0x3AC8C), colour 0xFE, or 0xFC on the achieved row i == panel (@0x3AC3E..0x3AC4E);
the caption = the last row's field 2 with `%STRING0` = `strrchr(name, ' ')` (`0xD1D:0xD1A` = file
0x102EA, the pointer AT the last space — the surname keeps its leading space) or the whole name
(@0x3ACB2..0x3ACE2), centred in x=0x22 w=0x8C at y=0x8E, colour 0xFC (@0x3ACF6..0x3AD0B);
present; the plate's frame 1 anchored at its own descriptor at 100 % (@0x3AD2F..0x3AD4C; SCORE01
(104,136) 140×97 → (34,40), SCORE02..24 (104,138) 142×99 → (33,40)); tune 0x24 (panel ≥ 23) /
0x25 (panel > 6) / 0x21 via `0x181F:0x4C0` (@0x3AD51..0x3AD6D); staged present; key/click wait
@0x3AD86; DAC restore @0x3AD96. The `@SCORE` row is therefore **deterministic** (the band), not
random. `%%` in `@EXPLOITS` is one "%" (format verb `0x191F:0x910`, @0x6F0CE).

**Trigger** (`func_03B2F8` @0x3B2F8, thunk `0x181F:0x574`): snapshot → `func_039EE2(0)` @0x3B340
→ `func_03A9C0(1, &panel)` @0x3B350 — which first draws the **F10 body with its own key-wait**
(`func_039EE2(1)`, present + `0x181F:0x3C0` @0x3A998..0x3A9B5) — → `func_03ADA6(name)` @0x3B364
(HoF insert). `@SCORED` follows in the callers (@0x580A, @0x2FAC9).

**Ports.** JS `scorePanel`/`drawScoreScreen` (`port/src/game.js`), C `score_panel`/`rm_draw_score`
(`cport/core/colopy_rivals.c`, `cport/render/colopy_report_render.c`); oracle
`tools/render_score_compare.py` (bands 0 and 23).

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

## 6. Opening cinematic (OPENING.PIK) — OPENING.EXE — **B** (deep decode 2026-06-26)

- **Purpose:** title screen / boot demo — old-style world map with sea monsters, ship landing,
  opening logo. **A.**
- **Engine:** OPENING.EXE (separate exe; Mechanism A background + Mechanism B sequencer). The binary
  carries a **C symbol-name table** (file `0x11900+`): `_opening`, `_open_loop`, `_load_ship_path`,
  `_load_anims`, `_load_credits`, `_do_ship`, `_do_anims`, `_do_logo`, `_pan_x`, `_anim_frame`, …,
  decoded against the symtab encoding. **B.**
- **Boot / asset-load order — `_opening` @file `0x1AAC`..`0x1EC2` (B, 2026-06-26):** a single init
  pass loads, in this exact order, each at a cited push+loader site:
  1. **PATH.DAT** — ship-path waypoints, `_load_ship_path` @`0xCEA` (`push 0xd8`=DGROUP name → file
     `0xbfe8` `"PATH.DAT"`; `lcall 0x1bf,0x24` open @`0xCF6`).
  2. **CREDITS** rows — `_load_credits` @`0xD52` (`_text_open(0xe9="OPENING",0xe1="CREDITS")` @`0xD5E`).
  3. **anim table** — `_load_anims` @`0xDD2` (`_text_open(0xf9,0xf1="OPENING")` @`0xDDE`; `rep movsw`
     6 words/record into `_anim[]` @`0x4de8`, count `[0x46]`).
  4. **#SOUND.COL** (`lea [0x11b]`/`lcall 0x1a2,0x40` @`0x1bbb`), **MPSLOGO** (`0x126` @`0x1bec`),
     **MPSNAME** (`0x12e` @`0x1c06`) as `.SS` sheets.
  5. **OPENING.PIK** bg — `_picture_load_2` (`seg 0x181:4`) @`0x1c94`.
  6. **OPENBORD** — `_picture_load` (`seg 0x1b4:8`) as a **`.PIK`, not a `.SS`** @`0x1d10`.
  7. **OPENSHIP** `.SS` @`0x1d90` → handle `[0x92]`; **OPENCRD0/1/2** built in a 3-iter loop
     @`0x1dcc`..`0x1e0e`; then **OPENWND1, OPENSUN, OPENMON1, OPENWND2, OPENMON2, OPENMON3,
     OPENFISH, OPENGUY, OPENLOGO, OPENBONK** as `.SS` in that order @`0x1e0e`..`0x1ebe`, each into a
     fixed DGROUP handle slot (`[0xa2]`,`[0xa6]`,…). CONFIG.COL/MEMORY.TXT/MEMORY2.TXT are **config/
     diagnostic**, not cinematic assets (`_config_read` @`0x227E`; MEMORY*.TXT `lea [0x391]/[0x3b6]`).
  - **Loaders (B):** `.SS` = `seg 0x3b1:0xa` (file `0x471A`), bare-name ptr in `BX`, returns a handle
    far-ptr; `.PIK` = `seg 0x1b4:8`; `.PIK` (fullscreen) = `seg 0x181:4`.
- **Frame timing (B) — real-time master clock:** loop top `_do_anims`/`_open_loop` region; BIOS 18.2 Hz
  tick (`SUB cx,[0x6c]` @file `0x1335`); advances animation-phase counter `_anim_frame` `[0x82]`
  (`INC [0x82]` @`0x134D`); `CMP [0x82],imm` cascade (offsets `0x106A`…`0x10B8`,`0x117E`; thresholds
  135/153/173/195/220/236/252/507 = `0x87/0x99/0xAD/0xC3/0xDC/0xEC/0xFC/0x1FB`) sets the element frame
  index `[bp-2]`=1..7. Per-subsystem last-tick latches `_pan_clock`[0x60]/`_ship_clock`[0x64]/
  `_credit_clock`[0x68]/`_anim_clock`[0x6c]/`_logo_clock`[0x70]/`_fade_clock`[0x74] vs intervals
  `_*_timing` [0x48]..[0x50]; `_game_clock` latch `[0x4ade]:[0x4ae0]` refreshed by `lcall 0x31b,6`
  @`0x16bf`. Loop exits on row count `[0x46]` (count-based, not a sentinel).
- **Blit routine — `seg 0x392:0` = file `0x4520` (B):** `enter 0x28,0`; calling convention
  **AX** = frame index (**bit15 = horizontal-flip flag**, low 15 bits = frame; masked `& 0x7fff`
  @`0x4546`); **BX** = destination surface descriptor (always `lea bx,[0x3910]`); **DX** = X dest;
  **`[bp+6]`** = Y dest; **`[bp+8]:[bp+0xA]`** = far ptr to the sprite-sheet handle. Per-frame sprite
  record stride = **12 bytes** (`frame*3<<2`), header `0x36` then records at `+0x36`; bbox fields
  `+0x3A` x-anchor, `+0x3C` y1, `+0x3E` width, `+0x40` y-extent; sheet dims `+0x4A`/`+0x4C`.
- **Placement model (B) — table-driven, NOT literal pushes for the animated elements:**
  `_do_anims` @file `0x102C` iterates `_anim[]` (count `[0x46]`, 12-byte records @`0x4de8`); each
  record's field0 indexes the sheet-handle table `_animsprite` @`0xa2` (`les bx,[fld0*4+0xa2]`
  @`0x10d1`). Per-element X = `-((width[+0x3e]>>1) − x-anchor[+0x3a]) + record[+6] − _pan_x[0x4aca]`
  (@`0x10e7`); Y/extent = `-(rec[+0x40] − rec[+0x3c]) + 1` (@`0x10eb`). So which sheet draws where is
  **read from the runtime anim data file**, not hard-coded.
  - **Literal-placed exceptions (B):** the **credit** plate (`_do_credit` @`0xFB6`, blit @`0x101b`)
    is centered **x=160 / y=183** (`-((w>>1)−0xa0)` / `-((h>>1)−0xb7)`); the **logo/name**
    (`_do_logo` @`0x1700`) is bbox-centered plus literal offsets **+0x17, −8, +0x10**.
- **Panorama pan (B):** `_pan_x` `[0x4aca]` init **0x280 (640)** (`mov [0x4aca],0x280` @`0x16af`),
  **decremented 1 px/tick** in `_pan` @`0x113e` (gated by `_pan_timing` [0x48]); subtracted from every
  element X (anims @`0x110e`, ship @`0xfa3`) so the scene scrolls right→left as `_pan_x` counts 640→0.
- **Ship path (B):** read from **PATH.DAT** — `_load_ship_path` @`0xCEA` parses word-pairs (X,Y) into
  `_ship[]` @`0x4f0c` (stride 4), count `[0x42]`, terminating on a 0 X-word. `_do_ship` @`0xF6E`:
  X(DX) = `ship_X − (sheet.width[+0x4a]>>2) − _pan_x`; Y = `-((sheet.height[+0x4c]>>1) − ship_Y)`;
  frame = `_ship_wave` [0x7a]. `_ship_move` @`0x119A` steps `_ship_at` [0x78] (clamped to `[0x42]-1`)
  and cycles `_ship_wave` on the master clock.
- **Assets (A):** `OPENING.PIK` bg + `OPEN*` sprites (per load order above) + MPSLOGO/MPSNAME.
- **Tier:** asset-load order **B**; frame-timing + blit convention + placement model **B**; per-element
  **literal** X/Y for the anim-table elements is now **partly resolved (B)** — the anim file is the
  **committed** `data_extracted/text/OPENING_sections.json @OPENING` table, parsed by `_load_anims`
  @`0xDD2`: it reads 4 CSV columns (`lcall 0x1bf:0x1a2` ×4 @`0xDFD..0xE15`) into the 6-word `_anim[]`
  record (`rep movsw cx=6` @`0xE4B`, stride 12 @`0x4de8`) = **col1 sheet-index** (→ `_animsprite`
  table), **col2 activation tick**, **col3** (unused by the X/Y math), **col4 X-base** (640 or 320,
  stored at record `+6`=`0x4dee` and added to X @`0x110A` before subtracting `_pan_x`), words 5–6 = 0
  (runtime frame/active flags). So the **X-base, activation-tick and sheet are committed data**
  (decodable now); only the per-frame **Y** is runtime — derived from the sprite-sheet frame bbox
  `-(rec[+0x40]−rec[+0x3c])+1` @`0x10EB` (a `.SS` asset value, **A**, not in the table). Ship X/Y
  likewise reads PATH.DAT waypoints `_ship[]` @`0x4f0c` (func_001522 not involved; `_load_anims` @0xDD2). Residual: per-frame Y (sprite-bbox, **A**) + PATH.DAT waypoint stream (external).

## 7. Closing cinematic (CLOS-BKG.PIK / CLOS-*.SS) — CLOSING.EXE — **B** (deep decode 2026-06-26)

- **Purpose:** end credits / retirement celebration (Liberty Bell, fireworks). The "credits" are a
  **sprite-actor pageant**, not a scrolling text roll (see TEXT note below). **A** intent / **B** mechanism.
- **Engine:** CLOSING.EXE (separate exe; references only `CONFIG.COL` from the COLONIZE/ tree by name).
  Carries symbols `_closing`, `_text_close`, `_env_get_path`, `_env_special_path`. DS para `0xa5d`
  (DS-rel `N` → file `0xafd0+N`). **B.**
- **Asset load — `_closing` (B):** **CLOS-BKG** background via far loader `seg 0xbe:0xa` (4 dword
  params `[0x36c2..0x36c8]`, off-screen target seg `0xfc00`) @`0x1084`; **FONTINTR** once
  (`lea [0x9a]`="FONTINTR" / `lcall 0x275,6`) @`0xff6`; the **7 CLOS-* sheets** (HAT/LDY/MAN/MIL/FWK/
  ROC/BEL) loaded uniformly (`lea bx,[DSoff]`/`sub ax,ax`/`lcall 0x2db,0xe`) @`0x110E`..`0x1185` into a
  flat far-ptr handle table at base `0x72` (handle `k` = `[0x72+k*4]`).
- **Per-frame loop — `func_000E4C` @file `0xE4C` (B):** loop top `0xE59`. **32-bit master clock**
  `[0x488c]:[0x488e]` latched via `LCALL 0x24a,2` @`0xE59`; frame gate in stepper `CALL 0xC0C` @`0xE66`
  (interval `[0x54]` — runtime, live-adjustable by `INC/DEC [0x54]` @`0xE2A`/`0xE30`; on
  elapsed `INC` step-counter `[0x6a]` @`0xC35`); present `CALL 0xAC2` @`0xE6A` (copies fb
  `0xA000:0xFC00` + palette); input `@0xE6E`. **Exit is sentinel-based:** `CMP word [0x6c],0` @`0xE71` /
  `JNE 0xe59` @`0xE76` — runs while `[0x6c]≠0`; `[0x6c]` cleared at `0xD70` (path complete) and `0xE07`
  (quit). (Unlike OPENING there is **no immediate-threshold frame cascade** — selection is the
  schedule loop in `0xC0C`.)
- **Placement model (B) — table-driven actor list:** scheduler `func_000C0C` walks BSS actor structs
  (**stride `0x0E` = 14 bytes**, base `0x4b96`; fields `+0` sheet index, `+2` activation tick `0x4b98`,
  `+6` Y-base `0x4b9c`) populated at load by `func_000A00` @`0xA00` from the **`CLOSING` sequence file**
  (open `lcall 0xfd:0x1a`, number parse `0xfd:0x198`). Per-tile X/Y are computed from the frame-header
  bbox + the table Y-base — **no literal sprite coordinates**. Special-event hook: an actor with
  sheet-index **4 (= CLOS-MIL)** at a trigger-frame set fires sound/event `lcall 0x69b,0xe`
  (`ax=0x59` @`0xca0`, `ax=0x5a` @`0xba7`).
- **Text (B — important correction):** the only text the cinematic loop draws is a **debug
  step-counter** at pen **(5,5)** with FONTINTR (`0xbbd`..`0xc01`; `0x12f8`..`0x1303`). There is **no
  scrolling-credits render in the CLOSING loop.** The `_text_close`/`_text_search` path (@`0x1bd8`/
  @`0x19ea`: builds `"@"+key`, `_env_special_path`, opens a handle, parses `0x50`-byte lines into
  `0x5382`) reads `CLOSING.TXT @CLOSING`/`@MESSAGES` rows — those drive the **sequence/actor timing**,
  not an on-screen text scroll.
- **Script (B):** `CLOSING_sections.json @CLOSING` rows verified verbatim
  (Fireworks/Bell/Rock/Hat/Lady/Man/Military/`-1`="End of closing", END at time 390).
- **Assets (A):** bg `CLOS-BKG.PIK`; `CLOS-BEL/FWK/HAT/LDY/MAN/MIL/ROC.SS`.
- **Tier:** asset load + loop + exit + placement-model + text-mechanism **B**; per-actor **literal**
  frame/coordinate timeline is **external-file data (closed)** — it lives in the committed
  `CLOSING_sections.json @CLOSING` (parsed by `func_000A00` @`0xA00` → actor structs @`0x4b96`) + the
  runtime interval `[0x54]`; a port reads those, the EXE supplies the centering + schedule math (**B**).
  No further EXE byte to decode.

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
- **Opening** runs at boot from OPENING.EXE; the demo loop early-outs on a keypress. **Resolved (B):**
  the input handler `func_001522` @`0x1522` polls **BIOS kbhit** via `lcall 0x24f:2` (= file `0x30F2`:
  `mov ah,1; int 0x16; jne; xor ax,ax` — `b4 01 cd 16`) @`0x152E`; if a key is pending
  (`or ax,ax; je` @`0x1533`) it reads the key with **BIOS getch** `lcall 0x24f:0x16` (= file `0x3106`:
  `mov ah,0; int 0x16` — `b4 00 cd 16`) @`0x1537` into `[bp-0xa]` (`+`/`-`=0x2B/0x2D tune timing
  `[0x48]/[0x50]`, ESC/click forces `0x1B`); the exit path clears the loop flag `[0x8c]=0` @`0x15C8`/
  `0x15D4`, and the outer driver `func_0016AC` (`_open_loop`, pan init `[0x4aca]=0x280` @`0x16AF`)
  runs while `[0x8c]≠0` (`cmp [0x8c],0; jne 0x16bf` — `83 3e 8c 00 00 75 c2` @`0x16F6`) (func_001522 @0x1522, func_0016AC @0x16AC). **B** mechanism + keypress early-out.
- **Closing** runs from CLOSING.EXE on retirement; advances by its internal element timetable to the
  `-1` "End of closing" sentinel at time 390. **B** (script). **Outer pacer resolved (B):** the pacer is
  the per-frame loop `func_000E4C` @`0xE4C` — it latches the 32-bit master clock via `lcall 0x24a:2`
  into `[0x488c]:[0x488e]` @`0xE59`, runs the frame-gated scheduler `func_000C0C` @`0xC0C` (advances
  only when `(clock − lasttick[0x66:0x68]) ≥ interval [0x54]`, `cmp` @`0xC25`), presents the frame
  (`call 0xac2` @`0xE6A`), polls input (`call 0xd98` @`0xE6E`), and loops while the sentinel `[0x6c]≠0`
  (`cmp [0x6c],0; jne 0xe59` @`0xE71`) — `[0x6c]` is cleared on quit/path-complete @`0xE07`/`0xD70`
  (func_000E4C @0xE4C, func_000C0C @0xC0C). **B** (script + pacer).

## 10. Evidence

- `docs/KING_AND_CINEMATIC_AUDIT.md` §3/§5 — `func_075352` argument matrix (KINGLSS, nation art,
  KINGWIN/LOSE/KING1), `func_03DA2A` (DECOIND), `func_037340` (REPORT loader), `GAME @KINGLOSE`/
  `@KINGWIN` geometry (GAME.TXT lines 3328–3345), KING2 / DECLARAT negatives, OPENING/CLOSING exe
  split. **B/A**.
- `viceroy_source/docs/drawlist/CHROME_AND_DISPATCH_INDEX.md` §B6 — `func_075352` FONTKING context
  (load @0x0754F2, `[0x1F9E]/[0x1FA0]` @0x075511, metric overrides @0x075526/0x07552C, @-menu
  @0x075540) + sprite-name builder `func_06BE92` @0x06BE92; spot-checks PASS. **B**.
- `docs/CINEMATIC_TIMING_AUDIT.md` §1–§5 — OPENING/CLOSING per-frame loops, master clock, AMERICA.MOV
  decode (1-bpp coastline bitmap + waypoint list: `count=8`, deltas `3,9,3,3,2,2,2,3,2` at the blob tail,
  per `AMERICA_MOV.json`), KING2 negative. **B/A**. (Sole residual = the AMERICA.MOV leading 4-byte
  header `0c 00 00 0e`, §11.6, and the engine-resident text RGB, §11.6.)
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

## 11. Open questions

1. ✅ **Score plate→category mapping — RESOLVED 2026-06-21 (B).** Plates are rating-tier art selected
   by `func_03A9C0`'s `i·i/3 ≥ scaled` loop (§4), not per-category lines.
2. ✅ **OPENING/CLOSING frame timing, sequencing, blit + placement — RESOLVED (B, deepened
   2026-06-26).** OPENING: real-time clock `[0x82]` + threshold cascade (§6); the **blit routine
   `seg 0x392:0`=file `0x4520` is fully decoded** (AX frame+flip / BX surface / DX,X / [bp+6],Y /
   [bp+8:0xA] handle); placement is **table-driven** (anim table `_anim[]` @`0x4de8` + pan `_pan_x`
   @`0x4aca`), with literal-centered credit (x160/y183) and logo exceptions; ship path is **PATH.DAT**
   (`_ship[]` @`0x4f0c`). CLOSING: loop `func_000E4C` @`0xE4C`, 32-bit clock `[0x488c]`, **sentinel
   exit** `[0x6c]≠0`, table-driven actors (stride-14 @`0x4b96`, loaded by `func_000A00` from the
   `CLOSING` sequence file). **Residual = committed data-file contents (closed):** the per-element *literal*
   X/Y/frame timelines live in the **committed** OPENING anim table (`OPENING_sections.json @OPENING`,
   parsed by `_load_anims` @`0xDD2` — col1 sheet / col2 tick / col4 X-base, §6) + PATH.DAT + the
   **committed** CLOSING sequence table (`CLOSING_sections.json @CLOSING`, parsed by `func_000A00`
   @`0xA00`: `lcall 0xfd:0x198` ×5 → 7-word actor record `rep movsw cx=7` @`0xA7E`, stride 14 @`0x4b96`
   = col1 sheet-index `+0`, col2 activation tick `+2`, col5 position `+8`); the EXE supplies the
   centering + schedule math, which is B. (Only the runtime sprite-bbox Y and PATH.DAT waypoints remain external/asset-derived.)
   **Both former code-side items are now decoded (B):** the CLOSING frame interval `[0x54]` is a
   **BSS-default-0** word with no immediate initializer — its only writers are `inc [0x54]` @`0xE2A`
   (`+`/0x2B key) and `dec [0x54]` @`0xE30` (`-`/0x2D key); the stepper `func_000C0C` reads it
   (`mov ax,[0x54]` @`0xC11`) and advances the schedule only when `(clock − lasttick) ≥ [0x54]`
   (@`0xC25`), so default 0 = advance every loop, live-tunable by the player. The `LCALL 0x24a,2`
   clock helper body is at file `0x2EA2`: `les bx,[0x340]; mov ax,es:[bx]; mov dx,es:[bx+2]; retf`
   (`c4 1e 40 03 / 26 8b 07 / 26 8b 57 02 / cb`) — it dereferences the 32-bit tick far-ptr
   `[0x342]:[0x340]`, which the timer install/uninstall routine sets to the game's software counter
   `0xa5d:0x4f4c` while the custom INT 8 ISR is hooked (`mov ax,0xa5d;[0x342] / mov ax,0x4f4c;[0x340]`
   @`0x30BC`) and restores to the **BIOS 18.2 Hz tick `0040:006c`** on uninstall
   (`mov ax,0x40;[0x342] / mov ax,0x6c;[0x340]` @`0x30FA`) (clock helper @0x2EA2, installer @0x30BC).
   The only residual is the **live value** of `[0x54]` (STATE — player-driven, default 0).
3. ✅ **AMERICA.MOV demo-script — PARTLY RESOLVED (A/R).** The `.MOV` blob
   (`data_extracted/data/AMERICA_MOV.json`) is a 1-bpp coastline/depth bitmap + ship-path waypoint
   list (`_load_ship_path`/`_increments`/`_scr_depth`, `CINEMATIC_TIMING_AUDIT.md` §3). Any non-bitmap
   header is the 8-byte leader `0c 00 00 0e 00 00 00 00` (word0=12, word1=0x0E00; verbatim in `AMERICA_MOV.json`), preceding the 1-bpp coastline bitmap; the bitmap is followed by the waypoint stream at file +0x220 marked `f5 01 08 00` = (`0x01f5`=501, `count=8`) then deltas `3,9,3,3,2,2,2,3,2` then `00 00` terminator — all bytes decoded (`binary_decode`). The semantic *grammar* of the 4 header bytes has **no EXE reader to trace**: the "AMERICA.MOV" string appears only in VICEROY.EXE @`0x1f7f0` in **write** context (adjacent `wb\0` mode flag, map-editor record path) — it is **not** referenced by name in OPENING.EXE/CLOSING.EXE, so the cinematic engine reads PATH.DAT, not this blob. The blob is thus a data-only artifact; the byte structure is documented, no further EXE byte exists to decode.
4. ✅ **`KING2.SS` loader — RESOLVED (B, negative).** "KING2" absent from VICEROY + OPENING.EXE +
   CLOSING.EXE (`CINEMATIC_TIMING_AUDIT.md` §4); orphan asset.
5. ✅ **`DECLARAT.PIK` loader — RESOLVED (B, negative).** Orphan; the engine draws DECOIND.PIK
   (`declaration_independence.md` §3). Closed as a negative.
6. **King-defeats / score-screen text RGB — A (closed at anchor tier; B unreachable statically).**
   Painter `func_075352` decoded: the FONTKING draw sets pen `[0x1f4a]=0xF2`(x=242) / `[0x1f50]=0x2F`(y=47)
   / `[0x1f52]=0`, style `[0x1f56]|=0x18`, then draws via the **type-A thunk `0x181F:0x3FE`**. That thunk is
   **runtime-patched**: its static target is the 21-byte style-mask helper `func_06F57E` (`(1<<(n-1)) & [0x1f54]`),
   **not** the glyph blitter — capstone of the deoverlay-guessed target `0x029044` decodes to unrelated colony
   code, confirming the real blitter is paged in at run time and its ink-level→palette-index map is **not
   statically resolvable**. FONTKING is 2-bpp (ink levels 1/2/3, `formats/FF.md`); on-screen RGB = the screen's
   loaded palette (KINGLSS/SCORE PIK) at those intrinsic ink indices. The three literal RGB triples would need a
   DOS-frame pixel sample (out of scope here). **Closed at A — not a static-B candidate.**
