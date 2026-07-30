# UI AUDIT TRACKER — byte-verified documentation of the ENTIRE VICEROY UI

> Mandate: `CLAUDE.md` "UI DOCUMENTATION MANDATE". Goal = 100% byte-verified docs of every
> screen + every element's exact placement/font/string/color, enough to rebuild.

> ## ⚠ AUDIT CORRECTION (2026-07-28) — the "DONE" labels below are NOT reliable
> Three adversarial audits found the UI is **not** rebuild-sufficient and the prior
> "SCRUB COMPLETE / static layout of every screen is byte-cited / nothing fabricated"
> conclusion was **false**. The specifics:
> - **No `spec/ui/*.md` sheet passes the "redraw from spec alone" test.** Systemic blockers:
>   the glyph-width tables were deleted (now restored — `data_extracted/fonts/ff_metrics.json`,
>   `fonts_and_colors.md` §1a); the dialog-framework **row-layout math** is missing/wrong
>   (`box_h = line_count·2+3` is arithmetically impossible); ~100 residuals were **reworded**
>   ("resolved-as-state", luma-from-one-frame relabeled **B**) instead of solved.
> - **Coverage: ~300 UI surfaces have zero spec** — the Colonizopedia (166), map editor (23),
>   options/music/debug dialogs (26), European diplomacy popups (~45), 12 woodcut screens,
>   tutorial overlays, multiplayer, Combat Analysis. Plus **undocumented in-game screens** in
>   the disasm: a 4.3 KB text page (`func_05E9B0`, page 0x11) and a 5-member modal family on
>   page 0x16.
> - **Integrity defects (now fixed):** `menus.md` had a leaked `</content></invoke>` artifact;
>   the popup frame-blit was mis-attributed to the colony scene; four framework docs
>   (`UI_RENDERER_SPEC.md`/`DIALOG_GEOMETRY.md`/`UI_DIALOGS.md` + a dangling `RENDERER_GEOMETRY.md`
>   link) were stale — all now stamped SUPERSEDED; `0x181F:0x35C` was mis-called a text-draw
>   (it is `clamp()`, `func_0048CC`).
>
> **Treat every row's "DONE" as UNVERIFIED** until re-hardened in the 2026-07 re-decompile
> (Phase 0 foundation → Phase 2 per-screen rebuild-B → Phase 3 render-and-diff). Attribution
> is done against the committed `code/VICEROY/disasm_overlay_reseg/page_*.asm` (the local-only
> `code/VICEROY/flat/` substrate is gitignored/regenerable, not required).

> ~~Status: **DONE** (every element byte-cited or TBD-with-blocker). Last updated: 2026-06-24
> (autonomous scrub).~~ **← retracted, see above.**

## Screens & subsystems

| # | Screen / subsystem | entry / composer | decode doc | status |
|---|--------------------|------------------|-----------|--------|
| 1 | Map view (HUD/sidebar/menubar/minimap/viewport) | enter_screen_view 0xD @0x076871; composer func_067700 | docs/MAPVIEW_SCREEN_VICEROY_DECODE.md; spec/ui/map_view.md | DONE (structure B; per-line text-stack runtime + pixel-confirmed) — composer **func_067700** (via 0x181f:0xe1c)/minimap(241,8,79,41 @0x066CF8)/viewport(func_06787C)/tile-chain all **B**; sidebar **x-origin [0x8550]=240** (func_070FF8 @0x071039), **FONTTINY** white **0x0F** (func_076C70 @0x076C85), rect B(240,72,80,64); value sources gold=PowerRecord+0x2A, tax=+0x01, season=year[0x538a] band; string sources @MISC/@INFO/@SEASONS via func_002462; unit-panel data func_0672C8 (+0x3144/45 sprite, @UNIT/@JOB) — all **B**. Residual: per-line **y-stack** within the rect is emitted by a runtime-installed print vector ([0xa644]=0x1a1f:0xf10, func_0772FA @0x07730C) — FONTTINY 8px line stack [season+year, "Gold:N", "Tax:N%"], **pixel-confirmed** in docs/screens/06_ingame_map.png. (func_06083A = top turn/year strip, not the menu bar) |
| 2 | Colony screen | composer func_028592; screen 0x2C @0x025EE5 | docs/COLONY_SCREEN_VICEROY_DECODE.md; spec/ui/colony_screen.md | DONE (B) — **RNG placement func_025D34 §12 fully traced + snapshot-verified 2026-06-26** (category table 0x8D62, within-category shuffle → 0x8E92, present-gate 0x8E82, frame word[id*2−0x7238]); captured live (docs/screens/11_colony_screen.png) + ColonyRecord runtime-confirmed (hard rule 8). Per-colony plot→building map is RNG (replayable from seed 0x181F:0xD62), by design |
| 3 | Europe screen | composer func_031E4C; screen 0x2B @0x030DEB | docs/EUROPE_SCREEN_VICEROY_DECODE.md + spec/ui/europe_screen.md | DONE (structure B; title-origin via set_text_box) — header strip **func_030F76** (composer step 4 @0x031E6B); painter **0x181F:0xB0 → file 0x275C** reads its text-box rect from BSS **[0x2cc6..0x2ccc]** set per-screen by **set_text_box @0x2740** (`w,h,x,y` = [bp+6/8/a/c]); dock empty-state caption rect **(69,120,81,143)** string [0x2dd0] @0x0314F8; in-port ship names = **@UNIT[type]** (UnitRecord +0x3146, dock loop func_0314DC @0x031642); gold = PowerRecord+0x2A. Residual: the title-band x/y are the `set_text_box` call args (one per-screen trace each); live heap-string slot contents are runtime |
| 4 | Advisor reports F1–F10 | dispatch @0x023843; bodies 0x37xxx–0x3Axxx | docs/ADVISOR_REPORTS_VICEROY_DECODE.md (+ spec/ui/advisor_reports.md) | DONE — all 10 bodies' static layout byte-cited (x-cols/y-start/pitch/verb/string/color/font; F7 4-col table, F3/F2 strips, F8 gate, F10 i·i/3 band selector + SCORE<panel+1>.SS/WOODPAN2). TBD = live game-state (counts/gold/prices/score figures), runtime DGROUP icon-id cells ≥0x2CC6 (F3 REF), and some @MISC label-slot bindings (loader unidentified) — each TBD names its site |
| 5 | Continental Congress (F3 + Activities) | func_037A20 @0x37A10 (enter 0x6E) | spec/ui/continental_congress.md | DONE (B) — title **x=0,y=5,w=320**,color 0x90 via centered verb 0x181F:0x100 @0x37A29; body **left x=4, y-seed=25 (0x19)**, per-line += FONTTINY glyph-height [0x89E]; "Next Session" line (label [0x2E9A] + FF name when [0x5382]&1==0 & PowerRecord+0x12≥0); sentiment line x=4/color 0x92 (Rebel% via [0x53D4]/0x181F:0x9A4, Tory% [0x2E9C]); bell strip = proportional sprite 0x3F filled/empty; REF rows = count-badge verb 0x181F:0x222 (icons [0x52xx]); FF list loop i=0..0x18 owned-bit 0x181F:0x7B4; FF portraits @0x3BAA6 blit at coords baked into **CC-NN.SS frame-0 descriptor** (es:[bx+0x46/0x48]); OK/dismiss 0x191F:0xF74. Residual = live counts only (runtime) |
| 6 | Popups / dialogs engine | func_06C520/06D316/06C850 | spec/ui/popups.md + docs/POPUP_INSTANCES_VICEROY_DECODE.md | DONE — engine B (finalize math re-confirmed @0x06D363/92/0x06D522/3B); ~30 per-popup instances enumerated with @KEY(s) (159/159 grep-confirmed)/speaker channel (K/T/A/M via func_06BE92/BF12/BF3C, templates re-read 0x1F912/17/1E/23)/special-sprite/Lost-City func_061454 map; @x/@y/@width = **B-via-EXE / TBD-via-JSON** (extractor strips them); TBD = food-trigger fn, WOODPANL/PAN2 per-popup, func_06BF66 sprite x/y math |
| 7 | In-game menu bar + dropdowns | func_072090 build; **func_0452D4 dropdown (ruling 2026-07-30; NOT func_06E3D0)** | spec/ui/menus.md + docs/MENUS_VICEROY_DECODE.md + **docs/UI_PHASE1_ATTRIBUTION.md §5** | DONE — build chain func_072090 B (font 0x1A1F:0x2D2; "game"/"menu" 0x0720BE; readers 0x191F:0x928/0x91C); **dropdown engine = func_0452D4 (page 0x0A) per RULINGS.md 2026-07-30 — func_06E3D0 belongs to the dialog framework, not the menu bar**; bar draw = func_044E7C (fill 320px h=title_h+2 @0x044EB2–0x044EC9); per-title x = chain prev.x+prev.w+gap 0x0C, first x=0x0C (@0x044BA4–0x044BD1); full struct map + interaction loop + 317/199 clamps in §5; items+order from MENU_sections.json B; **func_06083A @0x060890 REFUTED as the pulldown bar (= turn/title strip, [0x9E14]/0x4A @0x060883)**; per-row cmd-id binding = item node +4 → func_0235D6 switch @0x0235E2ff; residual TBD = absolute per-title pixel x/w (font text-width runtime), [0x149C] color-block writer chain |
| 8 | Main/boot menu (OPENMENU/BEGINMENU) | func_075xxx; screen 0x2A @0x07661F | spec/ui/menus.md + docs/MENUS_VICEROY_DECODE.md | DONE — OPENMENU bg ([0x233C]→0x1FCDC) + OPENBORD decor (0x075B8E/B0/D2) + @BEGINMENU items (GAME.TXT, present) + runner @0x075C60 (lea [0x2345]; 0x181F:0x3FE) + dec-ax ladder @0x075C6D + begin_game 0x191F:0x320 @0x075E5F + colors (direct-RGB) all B; per-row y engine-laid from @y=91 (B-mechanism); difficulty/nation pickers byte-cited grids §4 |
| 9 | Opening / intro (OPENING.PIK) | **OPENING.EXE** `_opening` @file 0x1AAC (asset load) + blit `seg 0x392:0`=file 0x4520 | docs/FRONTEND_SCREENS_VICEROY_DECODE.md §1 + spec/ui/cinematics.md §6 | DONE (deep decode 2026-06-26) — EXE boundary (NOT in VICEROY); asset-load ORDER B (PATH.DAT→CREDITS→anims→#SOUND.COL→MPSLOGO/NAME→OPENING.PIK→OPENBORD(.PIK)→OPENSHIP→OPENCRD0-2→10 .SS); blit calling convention B (AX frame+flip/BX surface[0x3910]/DX,X/[bp+6],Y/[bp+8:0xA] handle; stride-12 records, bbox +0x3a/3c/3e/40); placement = table-driven (_anim[] @0x4de8 + _pan_x @0x4aca init640 dec) B, literal-centered credit (x160/y183) + logo exceptions B; ship path from PATH.DAT (_ship[] @0x4f0c) B; clock cascade [0x82] B. TBD: per-element literal coords (external anim data file + PATH.DAT contents) |
| 10 | Nation select (NATIONS.PIK) | **func_070A1A** (loads NATIONS.PIK push 0x2043 @0x070A42 via 0x181F:0x44E) | docs/FRONTEND_SCREENS_VICEROY_DECODE.md §3 | DONE (B: PIK load + @PICKNATION fallback; 2×2 grid x{112,211}/y{13,104} 82×88 @0x07078D; sel=[0x5398] mod-4; hit-rects 0x181F:0x3CA @0x070BCA; commit mouseX<112) — **LITERALS RESOLVED**: 4 nation labels = **@PICKNATION** rows (England/France/Spain/Netherlands) via `lea ax,[0x204b]`("PICKNATION", file 0x1f9eb) → `0x181F:0x998` list-menu @0x070A5E, result-1→[0x5398] @0x070A74; GAME.TXT @PICKNATION + snapshot blob (England 0x223fa) confirm. TBD: per-cell font/ink (runtime/BSS highlight on [0x5398] — AI-GATED) |
| 11 | Difficulty select (DIFFICUL.PIK) | **func_070580** (loads DIFFICUL.PIK push 0x202D @0x0705A8) | docs/FRONTEND_SCREENS_VICEROY_DECODE.md §4 | DONE (B: PIK load + @DIFFICULTY fallback; 3-wide×5 cells col·105+23/row·96+7 90×68 @0x0702C0; sel=[0x53A6] mod-5; hit-rects @0x070707; commit mouseY<103&X<128) — **LITERALS RESOLVED**: 5 level labels = **@DIFFICULTY** rows (Discoverer/Explorer/Conquistador/Governor/Viceroy) via `lea ax,[0x2036]`("DIFFICULTY", file 0x1f9d6) → `0x181F:0x998` list-menu @0x0705BE, result-1→[0x53A6] @0x0705D2; NAMES.TXT @DIFFICULTY + snapshot blob (NUL-list @0x4c27a) confirm. **DS:0x8394 is NOT the literal pointer table** (snapshot words there = 0x3e..0x42, ints not ptrs) — literals come straight from @DIFFICULTY. TBD: per-level ink switch + font (runtime/BSS — AI-GATED) |
| 12 | Customize (CUSTOMIZ.PIK) | **func_070060** (loads CUSTOMIZ.PIK push 0x2022 @0x070088) | docs/FRONTEND_SCREENS_VICEROY_DECODE.md §5 | DONE (B: PIK load; draw-all func_06FF94; 4×3 grid col·76+10/row·60+16 48×72 @0x06FDF0; title y4 ink0xFD/bg0xFE; cell ink0x0A/0x0E; sel=[0x1E7E]×4 default[1,1,1,1]; finish=click&mouseY≥185 @0x07027E) — TBD: LABELS idx→literal, font id, Diff/Power sub-popups func_070302/070494 |
| 13 | King audience / loss / win (KING*) | renderer func_075352 @0x075352; trigger func_02F3A2 @0x02F3A2 | docs/ENDGAME_SCREENS_VICEROY_DECODE.md §1 | DONE (KING1/KINGLOSE/KINGWIN select + pen (242,47) FONTKING + portrait x=100 byte-cited; portrait y/h + body text runtime TBD) |
| 14 | Native diplomacy / raids (IND*) | popup channels func_06BE92 | spec/ui/popups.md §2.7 + docs/POPUP_INSTANCES_VICEROY_DECODE.md §3.2-3.6 | DONE — tribe channel [0x1F5C]→IND<n>A<pose>.SS (func_06BE92 split @0x06BE96, inject @0x06BEF5, "IND0A0"@0x1F917) B; raid block = exactly 6 keys @file 0x1F52A (re-read; @RAIDSCALP orphan, B-negative); warpath @INDIAN* keys B; attitude/haggle/gift/raze keys grep-confirmed B; trigger fns func_04A7CA/04B308/049600/0572E6/05BE84/04B036 A. Sprite x/y position math (func_06BF66) TBD |
| 15 | Score screen (SCORE01–24) / F10 | func_03A9C0 @0x03A9C0 | docs/ADVISOR_REPORTS_VICEROY_DECODE.md §F10 (+ spec/ui/advisor_reports.md) | DONE (selector) — band selector byte-cited: i=1..0x18, panel=i-1 for largest i with i·i/3≥scaled (`imul cx;idiv 3;jge` @0x3AA4D-0x3AA5A), clamp ≤0x17 @0x3AA71; SCORE<panel+1>.SS (str 0x11CF +`0x182`@0x3AADA) over WOODPAN2 (str 0x11D7 @0x3AAFF, quartet 0x44E @0x3AB02); FONTTINY+FONTINTR (`[0x268A]`@0x3B054). TBD = live score figures + per-line big-figure x/y |
| 16 | Declaration of Independence (DECLARAT) | **func_03DA2A** @0x03DA2A (dispatch slot 4 @0x3EA0B, event flag [0x5382] bit 0) | spec/ui/declaration_independence.md + spec/ui/cinematics.md §5 | DONE — in VICEROY.EXE: loads **DECOIND.PIK** (DECLARAT.PIK is an orphan, B-negative) + per-letter **DEC-UPPA..Z / DEC-LOWA..Z / DEC-SQIG** sprite sheets; sprite-based typewriter reveal start x=126 y=148, wrap x=220 (no glyph font). TBD = live per-letter reveal cadence (runtime clock) |
| 17 | Closing / end (CLOS-BKG) | **CLOSING.EXE** func_000E4C @0xE4C (loop) + func_000C0C (scheduler) + func_000A00 (actor-table load) | spec/ui/cinematics.md §7 | DONE (deep decode 2026-06-26) — asset load (_closing: CLOS-BKG via 0xbe:0xa, FONTINTR, 7 CLOS-* sheets via 0x2db:0xe → handle table @0x72) B; loop = 32-bit clock [0x488c] via LCALL 0x24a,2, gate interval [0x54], present 0xAC2, **sentinel exit CMP [0x6c],0/JNE** ([0x6c] cleared @0xD70/@0xE07) B; placement = table-driven actor structs (stride-14 @0x4b96: +0 sheet,+2 tick,+6 Y-base) from the CLOSING sequence file B; MIL(idx4) special-event lcall 0x69b,0xe; **credits are sprite actors, NOT a text scroll** (loop text = debug counter pen (5,5)) B. TBD: per-actor literal frame/coord timeline (external CLOSING sequence file) + runtime interval [0x54] |
| 18 | Fonts (FONTTINY/INTR/KING/NP) | load verb 0x1A1F:0xA86 (4 loads); measure core 0x181F:0x204→0x00E6A6 | docs/FONTS_VICEROY_DECODE.md | DONE (loads+latches+per-glyph width byte-verified; cell heights .FF-atlas tier-A; FONT-NP draw site TBD) |
| 19 | Screen-view runner / event loop | INLINED template; colony runner func_02C5D4 loop 0x02C85C, exit [0x346]@0x2C929 | docs/SCREEN_FRAMEWORK_VICEROY_DECODE.md | DONE (skeleton+input thunks+exit byte-verified; **0x181F:0x772 corrected = error-logger, NOT enter_screen_view**; map main-loop start TBD) |
| 20 | Colony RNG placement PORT | func_025D34/009726/00C322 + 0x7238 frame | docs/COLONY_SCREEN_VICEROY_DECODE.md §12; spec/ui/colony_screen.md | DONE — func_025D34 @0x025D34..0x025EAF fully traced (seed 0x181F:0xD62 → category table 0x8D62 [0×7,1×4,2×2,3,4] → within-cat shuffle 0x181F:0x4D4 → present-gate 0x8E82[plot]=def-id) + verified against live Jamestown snapshot (8 buildings, plots {2,3,4,5,6,10,12,13}). Frame = word[id*2−0x7238]=[id*2+0x8DC8] |
| 21 | **Input & controls (mouse/keyboard/bindings)** | mouse module seg 0xA58 file 0xC980–0xCF00 (8× int 0x33); kbd `kbhit`@0xD272/`getch`@0xD286/`wait_for_keypress`@0x4A5C; poll/edge-detector @0xD106 → input globals 0x7E4–0x7FA | **spec/ui/input.md** | DONE (B: 8 int 0x33 wrappers AX-decoded + hand-verified; SW 16×16 cursor blit @0xCE98 color-0xFF transparency; mouse-state global block 0x7E4–0x7FA; getch/kbhit int 0x16 pipeline; per-screen binding table from spec/ui/* + menu @-accel tables) — TBD: left/right button bit at 0x7E4; per-screen click region ownership (runtime UI-mode in BSS); in-game map key-dispatch site |

## Screen-tag map (`bx` at the error-exit tails — `0x181F:0x772` = error-logger, NOT a screen dispatch; see docs/SCREEN_FRAMEWORK_VICEROY_DECODE.md §0)
- 0x2D @0x005E63 · 0x2C @0x025EE5 (colony) · 0x2B @0x030DEB (europe) · 0x28 @0x0450AE
  · 0x29 @0x06D5AA · 0x2A @0x07661F (boot menu) · 0xD @0x076871 (map) · 0x18 @0x077401/
  0x0774E4/0x0775A7 (= error-exit `0x181F:0x772` tails, NOT the setup screens) · more @0x078B8B/0x078C7C.
  NB: the real setup screens are **func_070A1A** (nation), **func_070580** (difficulty),
  **func_070060** (customize) — each loads its own PIK by name via `0x181F:0x44E`; the
  opening is in **OPENING.EXE** (not VICEROY.EXE). See docs/FRONTEND_SCREENS_VICEROY_DECODE.md.

## Method (every agent/pass follows)
- Disasm tool: `scratchpad/disv.py 0xADDR N`; thunks: `tools/follow_thunk.py SEG OFF`.
- Cite every coordinate to the push/mov site. Runtime/RNG/BSS → TBD + the exact site.
- Output: a code-anchored decode section/doc; update this tracker honestly.

## Autonomous scrub session log (2026-06-24) — corrections & findings (all byte-verified)
- **Colony building placement is RNG-driven** (`func_025D34`): seeded from the colony MAP
  POSITION (`map_y<<8 + map_x + [0x8D80]`, `func_009726`); `random_int(lo,hi)=lo+((rand()*range)>>15)`;
  5 plot-categories counts `[7,4,2,1,1]` bases `[0,7,11,13,14]`. The earlier "COMPLETE" label was
  RETRACTED. Remaining sub-sources (per-type category `0x8F88`, frame table `0x8DC8`, rand LCG) named
  with exact sites (decode §12).
- **`func_06083A` is NOT the map menu bar** — it is the **trade-route "Route N" title** (reads
  `[0x9E14]/0x4A`; `[0x9E14]=route*0x4A` written @0x05FE69). Verified. Recon docs mislabeled it;
  `map_view.md`/`menus.md` flagged for retraction.
- **Map sidebar HUD (season/gold/tax) has ZERO draw site in the map page** (0x66000–0x77000) — it is
  the shared screen-view HUD overlay. So "where is gold shown": value = `PowerRecord+0x2A` (B), blit =
  overlay chrome (TBD). Same for colony/europe menu-header gold.
- **Declaration of Independence = `func_03DA2A`** (dispatch slot 4 @0x3EA0B, event flag `[0x5382]`
  bit 0). Loads **DECOIND.PIK** + per-letter **DEC-UPPA..Z / DEC-LOWA..Z** + **DEC-SQIG** sprite
  sheets; typewriter reveal at start x=126 y=148, wrap at x=220. Sprite-based lettering (no glyph font).
- **Closing screen is a SEPARATE program** (`CLOSING.EXE` + `CLOSING.TXT @CLOSING`: CLOS-BKG.PIK + 7
  CLOS-*.SS series) launched via the `"closing "` cmdline string (file 0x1DABB). Not in VICEROY.EXE.
- **SCORE (F10) = `func_03A9C0`**: band = `clamp(maxᵢ{i: i²/3 < lvl·score/100}, 0..23)` → SCORE01..24
  artwork; FONTINTR pen `[0x268A]`, color 0xFC (0xFE for player's own band); 3 palette tiers (≤6→0x21,
  7..22→0x25, 23→0x24).
- **KING = `func_075352`** (FONTKING, pen 242,47; KING1/KINGLOSE/KINGWIN by outcome; portrait x=100).

## Corrections to PROPAGATE (found late in the scrub — fix across docs)
- **`0x181F:0x772` is NOT `enter_screen_view`** — the framework agent byte-verified it as an
  error-logger. So the "enter_screen_view(bx=screen-id)" labels in EUROPE_SCREEN /
  COLONY_SCREEN / MAPVIEW decode + the screen-id table are MISLABELED on the function identity
  (the bx=0x2B/0x2C/0xD screen ids are still passed to the real screen setup, but via a
  different call). Real screen-view entry / main loop = TBD (SCREEN_FRAMEWORK doc). FIX: replace
  "enter_screen_view 0x181F:0x772" with "screen setup (id in bx); the 0x181F:0x772 call there is
  the error-logger, not the entry" pending the real entry being pinned.
- `func_06083A` = trade-route title, not map menu bar (already noted) — fix map_view.md/menus.md.

## ~~SCRUB COMPLETE — parallel phase (2026-06-24)~~ — RETRACTED 2026-07-28
The 2026-06-24 "static layout of every screen is byte-cited / nothing was fabricated"
conclusion did **not** hold (see the AUDIT CORRECTION banner at the top). What was actually
true: the *systems* spec is solid, and the in-game screens have a partial byte-cited skeleton.
What was false: rebuild-sufficiency (missing glyph metrics + framework row math), coverage
(~300 unspec'd surfaces incl. undocumented in-game screens), and ~100 reworded-not-solved
residuals presented as closed.

### Coverage gap ledger (surfaces with NO spec — 2026-07-28)
Deferred to the comprehensive phase; **explicitly TBD, not "done":**
- **Colonizepedia** (166 PEDIA.TXT surfaces — article + 6 index pages) → new `spec/ui/colonizopedia.md`
- **Map editor** (MAPEDIT: 19 dialogs + 4 pulldowns/25 rows) → new `spec/ui/map_editor.md`
- **Options/music/debug** (`@GAMEOPTIONS/@COLONYOPTIONS/@SOUNDOPTIONS`, 4 music pickers, 19 DEBUG dialogs) → new `spec/ui/options_dialogs.md` + `debug_screens.md`
- **European (foreign-power) diplomacy** (~45 `@HELLO*/@PIRACY/@TRIBUTE/@WORTHY/@WITHDRAW…` `{width:220}` templates) → `popups.md` new section
- **Woodcut event screens** (12 of 17 unspec'd), **tutorial overlays** (`@TUTORIAL1..19` + `@x/@y`), **multiplayer** (`@MULTI/@MULTINEXT/@MULTIREV`), **Combat Analysis** (0 mentions), **trade-route editor** geometry, **Founding-Father pick** (`@WHICHFREEDOM`), **nation briefings** (`@NATION*` 7 of 8), **intro caption cards** (`@BUILD1..10`).
- ~~**Undocumented in-game render code:** `func_05E9B0` (page 0x11 text screen), the page-0x16 modal family (`func_0694AE/06A700/06AA88/06AE08/06AF1C`), `func_061F02` (0x13), `func_048F34` (0x0C), `func_0452D4` (0x0A). → Phase 1 attribution.~~ **DONE 2026-07-30** — all five attributed with byte-cited decodes in `docs/UI_PHASE1_ATTRIBUTION.md`:
  - `func_05E9B0` = generic two-column unit-roster modal (parameterized shared renderer; concrete screen = caller-determined, trace sites named) — §1.
  - **Page-0x16 family = the Colonizopedia entry pages** (CARGO/UNIT/TERRAIN/JOB/BUILDING/FATHER/MISC incl. siblings `func_0696C6`/`func_069D8C`; browser = `func_06B398`; context-help dispatcher = `func_02BC72`) — §3. **Ruling 2026-07-30: refutes CLAUDE.md hard rule 7's "0x69D8C = map-editor palette, not in-game" clause** (amendment pending user sign-off). This also seeds the Colonizopedia coverage row above.
  - `func_061F02` = DEBUG "Close Moves" pathfinding overlay (`@OPTIONS` bit 0x10) — §2; `func_048F34` = native supply/demand model + DEBUG "Supply and Demand (Indians)" dump (bit 4) — §4: both debug-only, → `debug_screens.md` scope.
  - `func_0452D4` = the in-game menu-bar pulldown engine (page 0x0A module) — §5. **Ruling 2026-07-30: supersedes the `func_06E3D0` dropdown-engine claim in row 7 / MENUS decode §7.1** and resolves row 7's "bar draw + per-item x" TBD (`func_044E7C`; x-chain @0x044BA4–0x044CA0).

(OPENING.EXE/CLOSING.EXE remain out of VICEROY.EXE scope.)
