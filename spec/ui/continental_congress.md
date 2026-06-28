# Continental Congress

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.
> Substantive: state→display map, FF-acquisition reveal mechanism, and F3-body fonts/colors are
> **B**; band geometry **A**. **No graphical progress bar** (RULING 2026-06-21). Residuals:
> bell/US-flag/REF sprite IDs and reveal-popup chrome — **RESOLVED 2026-06-27** (UI closeout): bell
> strip = proportional sprite **0x3F** filled/empty; REF rows = count-badge verb **0x181F:0x222**
> (icons `[0x52xx]`); FF portraits at coords baked into the **CC-NN.SS frame-0 descriptor**
> (`es:[bx+0x46/0x48]`); OK/dismiss **0x191F:0xF74**. Title `(0,5,320,c=0x90)`; body `x=4,y=25,
> +FONTTINY-height`. Tracker row 5 = **DONE**; only live counts are runtime.

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
> FF-threshold table is **unsupported** (zero raw immediate hits) — there is no threshold
> *table*; the threshold is **fully computed** by `func_03C282 @0x03C282` (160 bytes, complete
> disasm). **Closed (B, multibranch decode):** F3 body `func_037A10` pushes the power index and
> calls it (`push [bp+6]; lcall 0x191F:0xF66 @0x037B08`), storing the return in `[bp-0x54]`; the
> result is the bell threshold rendered as `MM` in the "(NN in MM)" subtitle (§2). Algorithm:
> `base = (power<4 && PowerRecord[power] flag [bx+0x543F]==0) ? (difficulty[0x53A6]+3)*2 :
> (14 − difficulty[0x53A6])`; `t = base<<3`; then +50% (`SAR 1; ADD`) for each year-band reached in
> `[0x538A]` ≥ **0x640/0x672/0x6A4/0x6D6 = 1600/1650/1700/1750**; `cnt = owned-FF byte [bx−0x77E4]`
> (bx = power*0x13C); `t = (cnt+1)*t + 1`, halved if `cnt==0`; if endgame `[0x5382]&1` set,
> overridden to `difficulty*0x5DC + 0x7D0`. The sample "129" is one runtime evaluation of this
> formula. `0xE7AC` struck as speculative.

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
| Bell icons row | (0, 44, 320, 32) | A/B | **discrete** bell sprites (one per bells/turn) drawn **IN the F3 body** at `func_037A20 @0x037BF5` (`mov ax,0x3f; lcall 0x181f,0x236` = `func_002EE4`, span `0x12c`=300) — *not* a separate overlay path (the §6.1 "not in the F3 body" claim rested on a 140-byte-truncated disasm; the full `0x037A10..0x3807D` body draws it). Sprite `0x3F` filled / `0x38` empty (`func_002EE4 @0x002FA5`). Band rect still luma-A. |
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
  advanced by `[0x89E]` glyph-height+2 per line. **Pitch byte-derived (B):** the per-line advance code at
  `func_037A20 @0x037BD1` does `les bx,[0x89E]` → `mov al,es:[bx]` (FONTTINY descriptor byte 0 = glyph cell
  height) → `inc ax; inc ax` (`@0x037BDA/DB`, +2) → `add [bp-0x5a],ax`. Decompressing `raw/COLONIZE/FONTTINY.FF`
  (MADSPACK 2.0, 914-byte payload per formats/FF.md) gives **height H = 6** (payload[0]), so the text-line
  pitch is **H+2 = 8 px**. With the byte-cited y-seed `0x19=25` (`mov [bp-0x5a],0x19 @0x037A4E`) and x-seed
  `4` (`mov [bp-0x56],4 @0x037A49`), the first body lines sit at y=25, 33, 41, … (+8 each). The bell-row
  advance differs: it adds the bell sprite-sheet cel height `es:[bx+0x334]` from `[0x83E]` +2 (`@0x037BFD`),
  a separate runtime sprite descriptor. The absolute §2 band *rects* remain luma-A overlay geometry, but the
  text-line y-progression is now fully byte-derived.
- **Correction (sprite-vs-color trap):** the *only* colors in the body are `0x90`/`0x92`.
  `0x3F`/`0x38` and the REF-row icons (from `[0x5286]/[0x52A2]/…`) are **ICONS.SS sprite ids**
  (`0x39` filled / `0x38` empty are the game's **discrete** indicator sprites — *not* a continuous
  bar), `0x61` is the FF-list **marker** sprite, and `0x12C`=300 / `0x4E`=78 are a numeric **scale**
  / REF **column stride** — none are text colors, and none is a progress-bar fill. (Bell/US-flag
  sprites are legitimately absent from this F3 text body — §6.1.)

> **Bell-row layout — the discrete sprites are PROPORTIONALLY pitched (`0x181F:0x236`
> = `func_002EE4`, helper `func_002D74`, byte-verified 2026-06-23).** The row of `count`
> = bells-needed sprites is fitted into a fixed span (`0x12C`=300): each sprite's pitch
> `stride = (span − sprite_w)/(count − 1)` (`idiv` @0x002DC6), **clamped to
> `[1, sprite_w+1]`** (cap @0x002DCD, floor @0x002DD7). So with **few** bells needed the
> sprites sit just-touching (`stride = sprite_w+1`); with **many** needed the pitch
> collapses toward **1 px and the bells overlap / almost stack** — the count's "fullness"
> reads as how many are the **filled** sprite (`0x39`/the passed `0x3F`) vs the **empty**
> sprite (`0x38`, @0x002FA5), NOT a fill bar. This is exactly why it is a sprite row, not
> a gauge. **B.** **This is a SHARED engine verb, not a CC-specific draw** — the same
> `0x181F:0x236` renders the colony field-production yields and other report count strips
> (7 call sites). Canonical: `viceroy_source/docs/UI_PRIMITIVES.md` §0x236 (call-site map).

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
(mechanism)**. **Popup chrome RESOLVED (B):** the resident reveal popup is `func_03BB4A @0x03BB4A`
(string `'CCBKGD'`; = `congress_screen_render`). It has **no decorative frame/title/OK widget** — it
loads CCBKGD.PIK full-screen (`0x181F:0x44e` @0x03BB6D, id `0x1253`), blits the whole 320×200 image
(`0x181F:0x444` @0x03BBB5, `bx=0x140`/`0xc8`), draws the portraits (`call 0x3C410`) and presents
(`0x181F:0xe2` @0x03BBE6) for both reveal phases; dismissal is a **key/ESC wait** `0x181F:0x3c0`
(`func_004A80`, role "ESC") @0x03BC14 — the full-screen CCBKGD image IS the popup, no boxed frame.

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

## 6. Open questions
1. Bell sprite **RESOLVED (B); US-flag still TBD.** The earlier "F3 body is text/box only, no
   sprite blits" finding was based on a **truncated** disasm (the asm file ended at 0x37A9C, 140
   bytes); the **full** body `0x037A10..0x3807D` DOES draw the bell row — `mov ax,0x3f; lcall
   0x181f,0x236` @0x037BF5 (`func_002EE4`, span `0x12c`=300), so **bell sprite = `0x3F` filled /
   `0x38` empty** (`func_002EE4 @0x002FA5`), drawn in-body, not a separate overlay path. The body
   has **no generic sprite blit** (`0x181F:0x254`/`0x2BC`) and **no US-flag immediate** anywhere in
   `0x037A10..0x3807D` — so the **US flag is genuinely absent from this F3 report**. **Closed as a negative
   (B):** the *other* congress code path, the FF-reveal popup `congress_screen_render`/`func_03BB4A` in
   overlay page_06 (`@0x03BB4A..0x03BC40`, loads CCBKGD id 0x1253 `@0x03BB6A`, full-screen blit `0x181F:0x444`
   `@0x03BBB5`, portrait calls `0x1090/0x1095`, present `0x181F:0xe2`, ESC-wait `0x181F:0x3c0 @0x03BC14`),
   ALSO contains **no sprite-blit verb** (`0x181F:0x254`/`0x2BC`) and **no flag immediate** — the nearest
   `0x254` blit is at `0x03DD3A`, in an unrelated function. There is therefore **no US-flag draw in either
   congress routine**; the §3 "US flag from ICONS.SS" asset note is unsupported by code. (The `push 0x44`
   flag index belongs to the *colony* renderer, not congress.) **No new capture needed — resolved negative.**
2. ~~FF "next session" selection logic + DGROUP:0xE7AC threshold table.~~ **Mostly resolved
   2026-06-21.** Selection logic is **B** in the export: `ff_is_available` (25425) = not-owned
   AND all lower-index same-category fathers owned (category-gated walk over the 25-entry
   `FF_TABLE`), weighted by era band (`ff_weight_for_year` 25413; bands at 1600/1700). The
   **threshold ("129") is computed** by `func_03C282` (bell-cost curve, entry @0x03C282), **not**
   a static table — `0xE7AC` has **zero** raw immediate hits and is struck as speculative.
3. REF group sprite indices + count-badge geometry — **source RESOLVED (B); icon VALUES = STATE.**
   The F3 body draws TWO REF count-badge rows via `0x181F:0x222` (=`func_0033F2`, count-badge queue):
   land group @0x037E1C uses icon ids `[0x5286]/[0x52A2]/[0x52CC]/[0x532E]` with counts
   `[0x53DA]/[0x53DC]/[0x53E0]/[0x53DE]`; naval group @0x037EFE uses icons
   `[0x52B0]/[0x5294]/[0x52CC]/[0x532E]` with counts `[0x53E2]/[0x53E4]/[0x53E8]/[0x53E6]`. Each row is
   opened by `0x181F:0x218` (`func_003193`) and flushed by `0x181F:0x22c` (`func_003104`, `push 4` =
   **4 columns**, span `bx=0x12c`=300) — so geometry is a 4-column proportional badge layout, **B**. The
   icon-id globals (`0x5286`…) are DGROUP **≥0x2CC6 = BSS** (past MZ image end file `0x20665`); they hold
   no static immediate (no `A2/A3/C6 06/C7 06` store to any of `0x5286/0x52A2/0x52CC/0x532E/0x52B0/0x5294`
   exists anywhere in VICEROY.EXE), so the ICONS.SS index VALUES are runtime/loaded → **STATE**. **Live
   oracle (B):** read from the COLONY-live snapshot `scratchpad/dbx/colony_live_1505.bin` (DGROUP base
   validated by anchor reads 0x2F5E=0x219/0x2DD0=0x152/0x33C=0): land-group icons `[0x5286]=0x7E (126)`,
   `[0x52A2]=0x7F (127)`, `[0x52CC]=0x0A (10)`, `[0x532E]=0x80 (128)`; naval-group icons `[0x52B0]=0x81 (129)`,
   `[0x5294]=0x82 (130)`, `[0x52CC]=0x0A`, `[0x532E]=0x80` — these are the per-game ICONS.SS sprite ids the
   `0x181F:0x222` count-badge verb draws (a second snapshot taken before REF-init shows all-zero, confirming
   runtime population). Source = BSS globals `[0x52xx]`, renderer `func_0033F2` (`0x181F:0x222`), 4-column
   proportional layout; per-game STATE, not a static constant.
4. CC-NN FF-acquisition reveal popup chrome — **RESOLVED (B): there is no frame/title/OK chrome.**
   The resident popup `func_03BB4A @0x03BB4A` (string `'CCBKGD'`) loads CCBKGD.PIK full-screen
   (`0x181F:0x44e` @0x03BB6D), blits the whole 320×200 image (`0x181F:0x444` @0x03BBB5), draws the
   owned portraits at their baked CC-NN.SS coords and `vid_present()`s twice (the two-phase
   light-up), then **waits for a key/ESC to dismiss** (`0x181F:0x3c0` = `func_004A80` role "ESC"
   @0x03BC14). No boxed dialog, no title bar, no OK widget is drawn — the full CCBKGD screen IS the
   popup; it matches decompiled `congress_screen_render` (25583).
