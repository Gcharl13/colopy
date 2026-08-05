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
| 2 | Colony screen | composer func_028592; screen 0x2C @0x025EE5 | docs/COLONY_SCREEN_VICEROY_DECODE.md; spec/ui/colony_screen.md | DONE (B) — **RNG placement func_025D34 §12 fully traced + snapshot-verified 2026-06-26** (category table 0x8D62, within-category shuffle → 0x8E92, present-gate 0x8E82, frame word[id*2−0x7238]); captured live (docs/screens/11_colony_screen.png) + ColonyRecord runtime-confirmed (hard rule 8). Per-colony plot→building map is RNG (replayable from seed 0x181F:0xD62), by design. **Scene-panel terrain source RESOLVED 2026-07-31 (B, §3.8 / RULINGS batch 5)**: map compositor 5×5@16px from TERRAIN.SS `[0x16C]`+PHYS0 `[0x174]` (`func_068898→06787C→0685DC→0681A8`, scene latch `[0x18A]`), **×1.5 dither-upscale `func_00531C`+`func_005296`** (0,0,80×80)→(200,8,120×120); visible (224,32,72,72)=central 3×3; markers `func_004314` (ICONS 1..4, pennant 0x77+power); workers post-upscale 24px pitch from PHYS0. Residual TBD: `[0x890]` live value; `func_003E40` unit-marker decode |
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
| 21 | **Colonizopedia** (browser + 7 entry-page renderers) | browser func_06B398 (menu cmds 0x70..0x77 → handler @0x023904); pages func_0694AE/0696C6/069D8C/06A700/06AA88/06AE08/06AF1C (page 0x16); context-help dispatcher func_02BC72 | **spec/ui/colonizopedia.md** + docs/UI_PHASE1_ATTRIBUTION.md §3 | DONE (B, 2026-07-30) — shared skeleton (WOODPANL bg, [0x2E92] title y=5, header y=font_h+7, article via menu_lookup_run, modal-wait) + all 7 per-page layouts byte-cited (Cargo production rows pitch 0x14; Unit temp-preview-record gallery 17/row pitch 0x12 + stat line; Terrain 3×3 preview mosaic **byte-confirming hard rule 5** (TERRAIN.SS 12-tile array [0x16c] ← func_072B9A frames 1..12) + per-job yield rows + resource-bonus matrix func_009AAA; Skill workplace/upgrade chain; Building picture+worker+prerequisite; Father/Concept text-only); browser index 3col×24row pitch 7, (More)/(Exit), full key+mouse map; name-table loaders pinned (@OTHER_NAMES @0x074AC2, @MISCELLANEOUS @0x07530B). Two original-game bugs recorded (Artillery missing ')', right-wrap off-by-one). TBD (spec §11): 0xd1d C-runtime fixup, [0x2DBA] label-array loader, MISCn section resolution, func_00386A internals, ink-global runtime rewrites |
| 22 | **Map editor (MAPEDIT.EXE — separate program)** | `_main` @0x3ED8 → `_viceroy_game` @0x3B16 → `_turn_control_loop` @0x38B0; CodeView symbols mined 2026-07-30 (`data_extracted/mapedit_symbols.json`, 1071 names) | **spec/ui/map_editor.md**; substrate `code/MAPEDIT/disasm_named/`; format `formats/MP_FORMAT.md` (rewritten from `_write_map_file`) | DONE (B, 2026-07-30) — startup/flags/init-order with per-asset exit codes; NAMES.TXT section loads (corroborate hard rules 1/2/5); session flow (58×72 all-Ocean create, no size picker/procgen; `_forest_fix` normalization); .MP format corrected via ruling (6-byte header w/h/ver=4 + 3 layers; bit5=mtn/hill, bit6=river, bit7=modifier; forest = ids 8..23); menu bar + dropdowns (menu.obj = VICEROY page-0x0A module, clamp-instruction-identical) with full command-id/accelerator map; popup engine (parser ^/^^/{}/%STRINGn, bevel frame, WOODTILE fill); editor screen (viewport 240×192, zoom 15<<s×12<<s @ 16>>s px, mini-map 1px/tile TERRAIN.SS-sampled, info window, tile-select picker 17px pitch, paint/fill/undo, full PHYS0 frame map). **5 shipped bugs recorded** (Memory-check row unread, @HELP off-by-one → @HELP5 unreachable + "How To Use Maps"→ABOUT, dead @XS/@YS, dead id 0x21/0x6A, AMER2 ids 16..23 not round-trip-safe). **Coast-frame flag** (151–154 vs rule 4's 150–153) in RULINGS.md pending VICEROY re-check. TBD: retail MAPEDIT/MAPMENU.TXT absent; FONTTINY height px; VICEROY's own .MP loader |
| 23 | **Input & controls (mouse/keyboard/bindings)** | mouse module seg 0xA58 file 0xC980–0xCF00 (8× int 0x33); kbd `kbhit`@0xD272/`getch`@0xD286/`wait_for_keypress`@0x4A5C; poll/edge-detector @0xD106 → input globals 0x7E4–0x7FA | **spec/ui/input.md** | DONE (B: 8 int 0x33 wrappers AX-decoded + hand-verified; SW 16×16 cursor blit @0xCE98 color-0xFF transparency; mouse-state global block 0x7E4–0x7FA; getch/kbhit int 0x16 pipeline; per-screen binding table from spec/ui/* + menu @-accel tables) — TBD: left/right button bit at 0x7E4; per-screen click region ownership (runtime UI-mode in BSS); in-game map key-dispatch site |

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
- ~~**Colonizepedia** (166 PEDIA.TXT surfaces — article + 6 index pages) → new `spec/ui/colonizopedia.md`~~ **DONE 2026-07-30** — `spec/ui/colonizopedia.md` (row 21): browser + all 7 entry-page renderers at rebuild-B; article TEXT is PEDIA.TXT data rendered by the already-spec'd text-window engine, so per-article layout = engine spec + section text.
- ~~**Map editor** (MAPEDIT: 19 dialogs + 4 pulldowns/25 rows) → new `spec/ui/map_editor.md`~~ **DONE 2026-07-30** — `spec/ui/map_editor.md` (row 22): MAPEDIT.EXE fully decoded at rebuild-B via its own CodeView symbols.
- ~~**Options/music/debug** (`@GAMEOPTIONS/@COLONYOPTIONS/@SOUNDOPTIONS`, 4 music pickers, 19 DEBUG dialogs) → new `spec/ui/options_dialogs.md` + `debug_screens.md`~~ **DONE 2026-07-30** — both specs landed at B: all three options dialogs with complete bit tables + polarity + save-block persistence ([0x894] session-only); all 4 music pickers = one function with byte-decoded tune-id tables + rotation scheduler + external `#SOUND.COL` driver architecture; all 20 DEBUG.TXT sections attributed (16 live incl. the full @CREATE unit-spawner family, 4 dead), the **Alt-W-I-N cheat combo** (`xor [0x5383],0x20` @0x023F9A), cheat-menu build/gating, the complete 7-bit `[0x894]` table (bits 0x01/0x02/0x08 solved), and the non-TXT cheat items (Kill Indians / Show Strategy / Colony Sites / Terrain Info→pedia).
- ~~**European (foreign-power) diplomacy** (~45 templates)~~ **DONE 2026-07-30** → `spec/ui/diplomacy_popups.md`: all 48 sections mapped to one dispatcher `func_057F4E` (+ AI ticker `func_057DC0`, treaty-attack path `func_03ECF0`); runtime key construction, MYR portrait channel, full state machine (+0x34 matrix bits, +0x40 respect counter — **ruling** corrects diplomacy.md §2), Franklin effects, 3 latent bugs (missing @CANCELTREATY/@WANTSTUFF sections, @SIEGESUSA row swap).
- ~~**Woodcut event screens**~~ **DONE 2026-07-30** → `spec/ui/woodcuts_and_intro.md`: renderer func_06B722 + wrapper once-bits + complete 17-row trigger table (caller scan exhaustive: 10 sites); **ruling refutes 4 popups.md woodcut glosses** (WDCUT04/10/12/13; only WDCUT11 survived); WDCUT 0/6/12/14–16 have no caller.
- ~~**Tutorial overlays**~~ **DONE** → `spec/ui/tutorial.md`: dispatcher func_020F50 (10 unit-focus tutorials, full trigger conditions) + 9 event-driven sites; T18 ungated (original quirk).
- ~~**Multiplayer**~~ **DONE, LIVE** → `spec/ui/tutorial.md` §2: `SET COLONIZE=MULTI` unlock @0x070EDD, @MULTI power checkboxes, @MULTINEXT hot-seat handoff, @MULTIREV revolution warning (declaring clears the flag); hot-seat flag `[0x5381]&0x80` consumers mapped.
- ~~**Combat Analysis**~~ **DONE** → `spec/ui/combat_analysis.md`: **= the Phase-1 mystery func_05E9B0** (identity closed); full modifier-row table, gate, caller, LABELS @MISC binding (loader found @0x075214 — closes 2 standing open items); cheat-mode extra rows (final strengths + raw roll).
- ~~**Trade-route editor**~~ **DONE** → `spec/ui/trade_routes.md`: RouteRecord/StopRecord layouts, editor geometry (rows y=0x3D..0x8D pitch 0x14, separators 0x73/0xC6, OK box), shared destination picker, create/delete flows, phantom-probe-unit mechanism, dead duplicate func_060522 flagged.
- ~~**Founding-Father pick**~~ **DONE** → `spec/ui/ff_pick_and_briefings.md`: era-weighted 5-category candidate build, un-cancelable dialog with pedia help, acquisition flow (CCBKGD reveal splash), FF bitmask + per-father instant effects.
- ~~**Nation briefings**~~ **DONE** → `spec/ui/ff_pick_and_briefings.md`: @NATION<n>A/B shown once at new-game (digit-patched key, 'A'→'B' increment), full new-game chain (difficulty/nation/leader-name/@MULTI).
- ~~**Intro caption cards**~~ **DONE** → `spec/ui/woodcuts_and_intro.md` §2: LEVN PIK slideshow over world generation, one card per 0x23A ticks, pen (14,54), per-card substitutions, skip/quit keys.
- ~~**Undocumented in-game render code:** `func_05E9B0` (page 0x11 text screen), the page-0x16 modal family (`func_0694AE/06A700/06AA88/06AE08/06AF1C`), `func_061F02` (0x13), `func_048F34` (0x0C), `func_0452D4` (0x0A). → Phase 1 attribution.~~ **DONE 2026-07-30** — all five attributed with byte-cited decodes in `docs/UI_PHASE1_ATTRIBUTION.md`:
  - `func_05E9B0` = generic two-column unit-roster modal (parameterized shared renderer; concrete screen = caller-determined, trace sites named) — §1.
  - **Page-0x16 family = the Colonizopedia entry pages** (CARGO/UNIT/TERRAIN/JOB/BUILDING/FATHER/MISC incl. siblings `func_0696C6`/`func_069D8C`; browser = `func_06B398`; context-help dispatcher = `func_02BC72`) — §3. **Ruling 2026-07-30: refutes CLAUDE.md hard rule 7's "0x69D8C = map-editor palette, not in-game" clause** (amendment pending user sign-off). This also seeds the Colonizopedia coverage row above.
  - `func_061F02` = DEBUG "Close Moves" pathfinding overlay (`@OPTIONS` bit 0x10) — §2; `func_048F34` = native supply/demand model + DEBUG "Supply and Demand (Indians)" dump (bit 4) — §4: both debug-only, → `debug_screens.md` scope.
  - `func_0452D4` = the in-game menu-bar pulldown engine (page 0x0A module) — §5. **Ruling 2026-07-30: supersedes the `func_06E3D0` dropdown-engine claim in row 7 / MENUS decode §7.1** and resolves row 7's "bar draw + per-item x" TBD (`func_044E7C`; x-chain @0x044BA4–0x044CA0).

(OPENING.EXE/CLOSING.EXE remain out of VICEROY.EXE scope.)

## Port: menu bar and key commands (2026-08-04)

The six pulldowns are built from MENU.TXT verbatim — every row the shipped game
has is present and shows its `~` accelerator, so the gaps are visible in the UI
rather than hidden. Rows with no handler render greyed and report themselves.

| Group | Status | Note |
|---|---|---|
| ORDERS | **MOSTLY DONE** | Activate/Wait/Fortify/Sentry/Build Colony/Clear-Plow/Road/Load/Unload/Return to Europe/No Orders/Dump Cargo/Disband all live. **Absent**: Pillage, Go to Place, Begin Trade Route. |
| VIEW | **DONE** | Move/View Pieces, European Status, Find Colony, Zoom In/Out, the four zoom levels, Show Hidden Terrain, Center View. Zoom spans verified as `(0xF<<z) × (0xC<<z)` at `(0x10>>z)` px. |
| GAME | **PARTIAL** | Save Game / Load Game work (localStorage; the whole of `G` is the save). Options, Pick Music, Retire and Exit are still absent. |
| REPORTS | **MOSTLY DONE** | F2 Religious, F3 Congress, F4 Labor, F5 Economic, F6 Colony, F7 Naval, F8 Foreign Affairs, F9 Indian and F10 Score are all built from real state, each over **its own REPORT&lt;N&gt;.PIK** (mapping established by matching the plates against the DOS captures — RULINGS.md 2026-08-04) with its own adviser portrait. F1 routes to the Colonizopedia terrain page, which is what it actually is. **PARTIAL**: the per-report body layouts are the port's own, not the byte-cited x-columns and y-flow in `advisor_reports.md`. |
| TRADE | **TBD** | Trade-route editor not built. |
| COLONIZOPEDIA | **DONE** 2026-08-04 | All seven categories plus Complete, articles straight from PEDIA.TXT, three-column index pager, stat blocks from the NAMES tables. |

### Colonizopedia notes
- Entry counts: Cargo 16, Unit 23, Terrain 29, Skill 28, Building 42, Father 25, Concept 12 → **175** in Complete. The spec says the engine's merged index holds **162**, so ~13 rows are skipped by the enumerator's per-category skip list, which is not in the evidence here. **PARTIAL.**
- Terrain names come from `@UNFORESTED`+`@FORESTED`+`@OTHER`+`@OTHER_NAMES` = 26, but PEDIA.TXT ships 29 TERRAIN articles; ids 26–28 are shown by index rather than given invented names.
- Game Concept entries have index names in `@MISCELLANEOUS` but **no article** anywhere in PEDIA.TXT; the page says so rather than filling the space.

### Combat (§14)
- Implemented: base from the `@UNIT` combat column (carriers add attack, damaged ships −2), the
  `strength·(bonus+4)/4·3/2` terrain/fort term with the cited defence accumulator, the human
  `+(4−difficulty)` handicap on **both** sides, colony +50%, fortified +50%, `·difficulty/20`,
  and the roll `random_int(1, ATK+DEF)` won by the attacker iff `roll ≤ ATK`.
- **NOT implemented**: §14.3 step 8, "a further doubling gated on `game.difficulty`, exact
  condition an open item". Guessing at it would change every fight, so it is left out.
- The Combat Analysis dialog (§26.10) is not built; combat resolves silently with a message.

### Natives (§19)
- Tension per tribe 0..100 with the cited bands (**75 hostile, 100 war**), all changes through
  `adjustTension`, which clamps and **halves positive deltas for France and Pocahontas**.
  Alarm seed `random_int(0,14) + 2d` per §18.11. Attacking a tribe applies +100.
- **Settlement sprites resolved 2026-08-04**: ICONS has two parallel 21×16 settlement bands.
  **disk 0–3 are European colonies** — every one carries a blue pennant, running bare logs /
  low fence / wooden palisade / stone walls, i.e. the stockade→fort→fortress progression.
  **disk 10–13 are the NATIVE settlements**, pennant-free: tipi camp, pueblo, stepped pyramid,
  terraced stone city — exactly `@TRIBES.level` 0–3. Found by rendering the whole sheet as a
  grid; the manual's ICONS catalogue lists 10–13 as "not yet role-assigned".
- **Settlement placement RESOLVED 2026-08-04**: it is not procedural at all — `TRIBE.TXT`
  ships the exact site list, 59 across eight tribes. Its x coordinates need **+2** to index the
  stored map plane; that offset puts 0 of 59 in water where every other offset tested leaves at
  least 6 (RULINGS.md 2026-08-04).
- **Village trade built 2026-08-04.** Walking into a settlement opens its screen: the chief's
  greeting, the "especially interested in" line (top of the sorted demand list), the tribe's own
  `IND<t>A<attitude>` portrait, and one row per good in the visitor's hold with its offer. The
  sell price is §19.5's formula — `mood = random(1..5)`, `base` 6 raw / 7 manufactured with the
  per-good colour (Furs −random(0..7), Muskets +(12−known), Horses +(10−known), Trade Goods +1),
  `seed = 2·(base − difficulty − want + mood + 4)`, offer `max(1, (max(0, seed·demand) + 5·mood)·qty/100/2)`.
  Selling cools the village by the quantity and a **full 100-load zeroes its alarm**; muskets and
  horses **arm the tribe** (+1 at 25 units, +2 at 50, horses adding a quarter of the load to the
  herd); a −4 tension credit rides along. Alarm shows on the map as the cited exclamation ramp.
- **Village demand is PARTIAL**: the engine's `village_supply_demand` is a three-phase model
  (claimed-tile mask, 5×5 terrain scan, tribe-level formulas). The port runs the 5×5 scan and
  applies the two cited headline behaviours (a capital doubles raw-goods demand, ×1.5 for
  tools/muskets/trade goods, and doubles manufactured supply) but not phases 1 and 3.
- **Gift credit is untraced**: §19.5 records the haggle "gift" row but its tension credit is TBD.
  The port uses twice the sale credit (−8) as a stated stand-in.
- **Buying built 2026-08-04** to §19.5's other formula: `ask` 200, or `(8 − tribe.level)·50` for
  horses and manufactures, plus `market·(2d+15)` for silver and better; price
  `max(50, qty·ask/100 + (d + random(0..2))·10) + random(0..ask) − 4·surplus + 4·tension`.
  Which goods a village offers is derived from its 5×5 yield (the same PARTIAL demand model).
- Raids, missions and converts are still not built.

### Rival European powers
- The three other powers start at their own `@SCENARIO` positions — the same table that gives
  the human theirs — found colonies from their own COLONY.TXT name pools (Quebec, Isabella,
  New Amsterdam …), and render in their `@COUNTRY` colours with the settlement/pennant chrome.
- **First contact** fires woodcut 10, MEETING FELLOW EUROPEANS (`func_057F4E @0x057FDF`), once
  per game, and F8 Foreign Affairs reports each power's status.
- **PARTIAL — rival turn logic is a stand-in.** The engine's AI (`func_059B90`, the heading
  planner, the colony-site scorer) is largely unmapped in this repo; rivals here sail west,
  plant on the first free coast they reach, and otherwise hold. No diplomacy, no war, no trade
  between powers.

### Continental Congress (§17)
- **Cost formula byte-exact** and cross-checked against the manual's live-verified value:
  base = human `(d+3)·16`, each era gate 1600/1650/1700/1750 compounding ×1.5,
  `cost = (owned+1)·base + 1`, first father half price, `d·1500 + 2000` after the Declaration.
  Explorer human with one father pre-1600 → **129**, exactly as recorded.
- **Candidate draw** per §17.3: one per category over the un-owned fathers with a nonzero weight
  in the current era band (<1600 / 1600–1699 / ≥1700), weighted `random_int(1, Σw)` subtract-walk.
  The `@FATHERS` era-weight columns are now parsed and exported.
- **PARTIAL — bell accrual rate**: the per-building bell production is not in the evidence here,
  so the port uses Town Hall 1 + 3 per working Statesman. Same class of placeholder as the
  crosses rate.
- **PARTIAL — the pick dialog** (`@WHICHFREEDOM`) is not built: the port auto-selects the first
  candidate. Per-father effects are recorded as owned but only Fugger's boycott clear is wired.

### Immigration
- **Threshold is byte-cited** and implemented exactly: `clamp4000((Σ pop + units) × 2 + 8) × (8−d)/8`, England ×2/3.
- **Cross accrual rate is a flagged placeholder**: 1 per colony per turn, +1 per Church, +1 per Cathedral. §17.6 states the real accrual site is unidentified in the repo. **PARTIAL.**

## Port: colony mechanics still open (2026-08-04)

| Item | Status | Note |
|---|---|---|
| Construction menu (build a building) | **DONE** 2026-08-04 | `C` opens a popup listing every `@BUILDING` row the colony lacks and whose `min_colony` gate its population meets, with the hammers/tools cost. Hammers bank each turn from working carpenters; the building completes when hammers and tools are both paid. |
| Field-work assignment | **DONE** 2026-08-04 | Click a cell in the 3×3 scene window to put an idle colonist on that field (or click a worker to recall them); `Enter` opens the jobs menu to put one into a building. Food and hammers both read the assignments. |
| Job → building mapping | **PARTIAL** | A building's job is taken as the `@JOB` row whose name prefixes the building name (Carpenter's Shop → Carpenter). That covers every production chain in `@BUILDING`, but the engine's own building→job table is unread. |
| Per-job field yields | **PARTIAL** | Field workers are assigned as Farmers, so only the `y_farmer` column is exercised. The other eight yield columns are exported and the tile lookup is general, but there is no UI to pick a non-food profession for a field. |

## Port implementation gaps (2026-08-04)

Tracked because the HTML port now renders these screens and the gaps are
load-bearing render inputs, not cosmetics. Per the UI mandate rule 2 neither
screen is "COMPLETE" while these stand.

| Screen | Item | Status | Blocker |
|---|---|---|---|
| Colony (§26.8) | Starting-building set for a brand-new colony | **RESOLVED (derived)** 2026-08-04 | Falls out of NAMES.TXT `@BUILDING`'s **upkeep** column: exactly 8 rows have upkeep 0 (the free base tier), and 7 of those have `min_colony` 1. The 8th, Stockade, is gated at `min_colony` 3 so it cannot exist at founding. Every later tier of every chain carries upkeep 5/10/15/20. The port derives the list at runtime rather than hardcoding it. Caveat: this is an inference from the table's semantics, not a traced `0x8E82` initialiser — that remains unread. |
| Colony (§26.8) | Per-colony plot assignment | **TBD** | `func_025D34` is a 16-bit-seeded RNG shuffle (already flagged in CLAUDE.md). The port uses the `DS:0x266` plots in table order. |
| Colony (§26.8) | Empty-plot placeholder frames | **PARTIAL** | `DS:0x260[category]−1` — the table values are unknown. BUILDING.SS frames 42/43/44/45/47 were identified as the scenery by rendering the sheet tail and matching `docs/screens/11_colony_screen.png`; the category→frame mapping is inferred, not cited. |
| Colony (§26.8) | Building-field ground texture | **PARTIAL** | The field is a per-pixel speckle over the contiguous palette ramp 0x62/0x63/0x64 (measured 30/52/17 proportion in the capture), not a flat fill. The engine's noise source is unidentified; the port uses a deterministic positional hash matched to those proportions. Tone ramp and proportions are measured; the generator is TBD. |
| Colony (§26.8) | Centre-tile food band | **PARTIAL** | Consumption is byte-verified (`eaten = 2·pop`, colony.md §152 @0xA5F2). Production uses a terrain **band class 0..3** whose mapping is not in the evidence here; the port substitutes the terrain row's own `y_farmer` column and applies the cited modifiers (+2 at d=0, +1 at d=1, +1 river). The band function is TBD. |
| Colony (§26.8) | Right-panel button → mode mapping | **PARTIAL** | The three buttons are byte-cited as region (303,132,17,45) and confirmed to be ICONS disk 67/68/69 (house/musket/hammer) by rendering the band against the capture. Which button drives which `[0x337]` mode is inferred from the icons. |
| Europe (§26.9) | Market price movement | **DONE** 2026-08-04 | Implemented to §9.2–9.4: prices roll in `[start1,start2]`, the traffic accumulator gains `attrition` per turn and `±(qty << volatility)` per trade, steps the price at `−100·rise` / `+100·fall` handing the threshold back, and clamps to the good's low/high. |
| Europe (§26.9) | Buy / sell | **DONE** 2026-08-04 | SELL: `gross = price·qty`, `tax = gross·rate/100`, treasury gains the rest, the King's fund gains the tax. BUY: pays the ask (`bid + burden + 1`), untaxed. Market-bar clicks route to the sell handler as cited. |
| Europe (§26.9) | Recruit / Train | **DONE** 2026-08-04 | Dock slots hold **unit types** drawn by the §17.6 ladder (Petty Criminal / Indentured Servant / Free Colonist, with a professional every 4th turn), each carrying the `@CLASS` band its passage is priced from. Train lists all 17 `@JOB` rows with a real `europe_value`, price-sorted. |
| Europe (§26.9) | Recruit price band for professionals | **PARTIAL** | `@CLASS` rows 0/1 are literally "Petty Criminals"/"Indentured Servants", matching the first two ladder outcomes, so those two prices are solid. Free Colonists and the professionals are mapped onto bands 2–7 by **nearest `@JOB` europe_value** — a mapping between two shipped tables, but inferred, not cited. §17.6's "pool word at slot·6 + 4" is the real source and is unread. |
| Europe (§26.9) | Purchase page | **DONE** 2026-08-04 | The catalog **is** byte-cited, in §17.6: Artillery 500, Caravel 1000, Merchantman 2000, Galleon 3000, Privateer 2000, Frigate 5000, with only Artillery escalating (+100 per unit bought). The earlier "no price table exists" note was wrong — the prices sit in the immigration section, not the market one. |
| Europe (§26.9) | Dock queue | **DONE** 2026-08-04 | Recruits, trainees and purchased land units stand on the dock until a ship sails, then board it. |
| Europe (§26.9) | Crossing duration | **PARTIAL** | Ships take 3 turns each way, read off the sail-state 1/2/3 bands in §26.9. The per-ship sail *distance* the engine actually counts is not in the evidence here. |

## Port: missions, converts and native raids (2026-08-04)

Everything below is now implemented in `port/src/game.js`. Cited items are
byte-verified; the PARTIAL/TBD rows name the exact blocker per UI-mandate rule 2.

| Item | Status | Note |
|---|---|---|
| Native-village `@ACTIONS` menu | **DONE** | The ten rows and their per-row gating are transcribed from `spec/ui/context_dialogs.md` §6 (`func_04B308`, the table's only consumer): Trade / Enter Hostile exclusive at alarm 75, Establish Mission = Missionary + no mission, Denounce Heresy = foreign mission present, Live Among excludes Scouts, Speak With Chief = Scout only, Tribute excludes ships, Cancel always. Rendered as a §3 popup over the map (not a screen of its own) with the greeting as the body block and the chief on the tribe speaker channel. |
| Village greeting text | **DONE** | The five shipped GAME.TXT bodies `@VILLAGEHAPPY/MEDIUM/SAVAGE/BAD/WAR` replace the port's invented greeting line. |
| Establish Mission | **DONE** | Writes the founding power into the settlement's mission byte with the expert bit set when the founder holds **Jean de Brebeuf** (`or [bx+5],0x10` @0x48C81, gated on `has_father(0x16)` @0x48C71). Announcement is `@MISSION0..3`. |
| Mission anger reduction | **PARTIAL** | The *clamp* is byte-verified — the delta is trimmed so the meter lands at **70 or below** (`cmp ax,0x46; jg` @0x571DA) — but the delta's own magnitude (@0x571EB) is the one residual the applier study never resolved. The port applies **only** the clamp, so no invented magnitude enters the model. |
| Mission attitude band (which of `@MISSION0..3`) | **PARTIAL** | The engine bands a per-settlement colonial-presence score at the byte-verified cutoffs −5 / 0 / 10 (@0x048B62..0x048B90), but that score's composition is multi-term and undecomposed. The port bands the tension meter it does keep. |
| `@MISSION0..3` `%STRING` bindings | **PARTIAL** | `%STRING0` is the per-power `@MISSION` prefix and `%NUMBER0` the year; the port fills `%STRING1`/`%STRING2`/`%STRING3` as tribe-singular / settlement noun / tribe-plural by inspection of the sentence, not from a traced argument list. |
| Conversion roll | **DONE** | `threshold = @TRIBES.level + 2`, doubled by the expert bit; `roll = random_int(0,15)`; fires on `roll < threshold` — all byte-verified in `func_0572E6` (bound `0x0F` @0x5730A, fail test @0x57316). |
| Conversion scheduler | **PARTIAL** | *When* "each eligible turn" fires is untraced. The port rolls once per owned mission per turn. |
| Indian Convert unit | **DONE** | Created at the nearest owned colony and stamped the convert class (`UnitRecord +0x17 = 0x1B` @0x57374 = `@JOB` row 27, Indian Converts), announced with `@INDIANSCONVERT`. |
| Loss of faith | **DONE** | Converts that have not joined a colony within **eight turns** are eliminated, with `@DEADCONVERTS`. Join Colony is now implemented (it was not before), so the timer is escapable. |
| Jean de Brebeuf / Bartolome de las Casas | **DONE** | Brebeuf retroactively marks every mission you own expert (@0x3BE77); las Casas converts every Indian Convert to a Free Colonist on acquisition (class `0x1B`→`0x1C`, @0x3BEB2). |
| Juan de Sepulveda ±4 | **TBD** | `+4` / `−4` are byte-verified onto the conversion metric `[bp-0x62]` (@0x5E20B / @0x5E221), but what that metric feeds is not traced. **Not implemented** rather than bound to a guessed input. |
| Denounce Heresy | **PARTIAL** | Both endings (`@HERESY0` win / `@HERESY1` the missionary burns) are wired and the missionary is spent either way. The win/lose roll is untraced (the manual says so); the port uses a fair coin rather than inventing a weighting. |
| Mission cross on the map | **PARTIAL** | The rule is the spec's — a cross in the founding power's colour, brighter for an expert mission — but no dedicated cross sprite has been located in ICONS, so the 5×7 mark is drawn from primitives. |
| Raid arming threshold | **DONE** | Byte-verified `alarm ≥ 0x80` (128) — the raid-target scan @0x04734E and the colony-placement gates @0x04CAD7 / @0x053D4E all test `cmp [..+0x54F6],0x80`. |
| Raid gate roll | **PARTIAL** | `random_int(1,12) − 1`, `+ (difficulty − 2)` against a human European, tested against `3·K + 1` (@0x5BEE5). **K is untraced** and the manual says so; the port carries `RAID_GATE_K = 0` as a named placeholder. |
| Raid outcome dispatch | **DONE** | `random_int(1,4)`, downgraded while `turn < 40·(2−difficulty)`, dispatched 1→`@RAIDSTORES`, 2→`@RAIDWREAK`, 3→`@RAIDGOLD`, 4→`@RAIDBURN`/`@RAIDSHIP`, 0→`@RAIDNOTHING` — the byte-verified 5-way ladder. Woodcut 13 (INDIAN RAID) fires on a raid against a human colony. |
| Raid payloads | **PARTIAL** | Only STORES has traced state writes (the village banks the haul: raid budget `+0x08`, wealth `+0x0A += 0x19`, @0x5C3E1/@0x5C3E4). What WREAK / GOLD / BURN / SHIP actually take is unmapped in the evidence; the port takes the largest stock, a quarter of the treasury, one non-starting building and a docked ship respectively, and every one of those magnitudes is the port's own. |
| Alarm word vs tension meter | **PARTIAL** | The engine keeps two parallel per-(settlement, power) meters — tension 0..100 (hostile 75 / war 100, DGROUP 0x5B1C) and alarm 0..255 (raids at 128, DGROUP 0x54F6). Both thresholds are byte-verified and used as such, but what drives the alarm word up is not traced, so the port runs it off the same delta ledger as the tension meter. Two invented rules were **struck** in the process: a sale of ≥100 units zeroing the alarm word, and a gift zeroing it. |
| Live Among / Speak With Chief / Incite / Demand Tribute / Attack Village | **DONE / PARTIAL** 2026-08-04 | All five built — see the table below. Their gates read the tribe-record **posture** byte `+0x5236`, which is traced but not decoded, so the Incite / Tribute / Attack gates remain unconditional. |

## Port: the five remaining village actions + the native background economy (2026-08-04)

Built from `RULINGS.md` **2026-08-01** (the native-background-economy pass),
which supersedes `spec/systems/natives.md` §3/§6 — that section's
per-**settlement** tension model is recorded there as wrong (the `0x5B1C` table
is `TribeData +0x46`, per **tribe** × power, stride `0x4E`), which is the shape
the port already had.

| Item | Status | Note |
|---|---|---|
| Settlement target size | **DONE** | `func_046DE0`: `2·level + 3`, or `3·level + 4` for a capital — the growth cap, not a display value. Cross-checks the manual's own 3/5/7/9 and 4/7/10/13 table exactly. |
| Village growth | **DONE** | Settlement `+0x06` accumulates `+= population` each turn and acts at 20: it fills a brave-respawn request first (flags `0x01`), otherwise grows by one while below the cap. |
| One brave per village | **DONE** | Map creation spawns exactly one, linked to its village; a village only builds another when its own dies, and the unit-removal path stamps the request. Replaces the old "a brave beside every third village". |
| Mission per-turn tick | **DONE** | `M = (expert ? 4 : 1)`, ×2 in a capital, ×2 with **Bartolomé de las Casas** (FF `0x18`), ÷2 with **Juan de Sepúlveda** (FF `0x17`); the tribe's fractional feeder gains `M` and every 8 becomes one visible −1 tension tick, while the village's alarm word falls by `3·M`. **This closes the Sepúlveda/las Casas TBD from the previous pass** — the manual's "±4 on the conversion metric" is this doubler. |
| Starting population / which site is the capital | **PARTIAL** | Neither is in the evidence. Villages open at their target size (where a long-settled village would sit) and the tribe's first TRIBE.TXT site is taken as its capital. |
| Live Among The Natives | **DONE** | Outdoor skills only (`@JOB` rows 0–4, 7, 8, 22); Petty Criminals refused, an existing master refused, one grant per village. The roll is byte-cited: succeeds when `random_int(1,1000) ≥ 200·difficulty + 100` — 90/70/50/30/10 %. |
| Which skill a village teaches | **PARTIAL** | The per-settlement skill field is mapped nowhere. The port derives it from the site's coordinates — deterministic, but the port's own. |
| Ask to Speak With Chief | **PARTIAL** | All six arms are wired (trade briefing, guides, area reveal, beads, polite nothing, the taboo execution). **Which arm fires is untraced** — the sub-mode selector, the beads amount, the reveal radius and the taboo odds are all TBD, so the port rolls uniformly and rolls the execution in only where the village is already on a war footing. The area-reveal arm has nothing to reveal: this build has no fog model. |
| Incite Indians | **PARTIAL** | `@INDIANWARPATH2` is wired and payment puts the tribe on the warpath against the named rival. **The asking price's formula and the payment's tension writes are both untraced**; the port prices it off the three factors the manual names (your missions with the tribe, their attitude to you, the target) and says so. The ±100 pair once filed under "incite" is **not** used — RULINGS.md 2026-08-01 item 6 reassigns it to the post-Declaration war council. |
| Demand Tribute | **DONE** | `func_04AC00` demands **goods, not gold**, and the coded clamp collapses: the wealth-word ceiling operand is only ever written zero, so every successful demand is **exactly ten units** (ceiling @0x4AEA2, floor @0x4AEB0). Each village pays once ever — the settlement flags bit `0x10` tribute-once latch. |
| Tribute strength contest | **PARTIAL** | The shape is the manual's — your regional military score against the tribe's, each side rolling `random(0..strength)`, Spain and Hernán Cortés ×1.5 — but neither score's own definition is traced. The port sums `@UNIT` combat over land units against `2·pop·(level+1)`. |
| Attack Village | **DONE** | **The population is the counter**, byte-located @0x5D67A inside `func_05CA7E`: each lost battle does `pop--` while `pop > 1`, and at the last point the village is destroyed, a human attacker stamps the tribe's avenge flag (`+0x03 \|= 0x40` @0x5D6A1), and `remove_settlement` @0x5D6A9 runs. |
| Raze payout | **DONE** | `(Σ 3 × random_int(0, 10−difficulty)) × random_int(0,6) × 4 × (population + 1)`, credited straight to gold (32-bit add @0x4AB66) — no ×100, no Treasure unit on this path. Cross-checks the manual's own ceiling table: size factor 21 at Discoverer is `30·6·4·21 = 15 120`. The size operand is the **population** per the user-verified 2026-05-30 ruling (the raw instruction reads the tribe's level byte — the "Apache richer than Aztec" bug). |
| Capital raze bonus | **TBD** | Both captured capital razes exceed the formula ceiling, so a capital-only bonus exists; its magnitude is unmapped, so none is applied. |
| Settlement removal | **DONE** | Native units of the village are detached, the record retired; the tribe's **last** village sets the dead bit and announces `@EXTINCT`, while a surviving tribe has its horse herd and horse lore scaled by `n/(n+1)` — the **tribe's** record, not the dead village's (corrected 2026-08-01). |
| Village defence strength | **PARTIAL** | The engine resolves village attacks in the ordinary combat path; what the settlement itself contributes to the defender is not traced. The port defends with a Brave's strength on the village tile, scaled by `(4 + level)/4`. |

## Port: the colony production loop (2026-08-04)

Before this pass a colony produced only food (farmers only) and hammers
(carpenters, with no input). It now runs the whole `colony_turn_update`
pipeline. `spec/systems/colony.md` §3 is the source; the core of it is
byte-verified.

| Item | Status | Note |
|---|---|---|
| Per-tile yield | **DONE** | `compute_terrain_yield` (0x9B9C..0x9FFB). A field worker reads the column of the terrain table that matches the good they work, across all eight outdoor jobs — Fisherman is the ninth column and produces Food from water. Clicking a scene cell now assigns the cell's **best** job, not always Farmer. |
| Sons-of-Liberty / Tory production penalty | **DONE** | Byte-verified @0x9D14..0x9D98: `tories = round(pop·(100−SoL)/100)`, and every `10 − difficulty` of them costs one unit of every worker's output; the rebel-majority and rebel-unanimous latches give one back each. |
| Expert match | **DONE** | @0x9DAD..0x9DD2: Food and Horses take a flat **+2**, every other good **doubles**. |
| Raw→finished chains | **DONE** | The five byte-cited conversion call sites (@0xA660..0xA68C): Ore→Tools, Tobacco→Cigars, Cotton→Cloth, Furs→Coats, Sugar→Rum, all 1:1. An indoor worker's output is capped by the raw on hand plus what the fields brought in this turn. |
| Factory tier | **DONE** | `count_building_chain_present > 2` (@0x8EA9) is the factory condition, and the factory makes the same output cost **2/3** of the raw (@0x8EB1). |
| Indoor production rate | **PARTIAL** | **Not in the evidence.** `@BUILDING` has no production column (its `size` column is the colony screen's category slot 0..4) and PEDIA quotes no numbers. The port uses 3 at the base tier and 6 once the second link is built — the original game's familiar rates, but the port's own. |
| Carpenter needs lumber | **DONE** | PEDIA `@BUILDING35` is explicit: *"the carpenter needs lumber to create hammers."* The port previously made hammers from nothing. |
| Muskets ← Tools | **PARTIAL** | The Armory chain is **not** one of the five byte-cited conversion sites; PEDIA `@BUILDING3` describes it. Implemented, flagged. |
| Building → job binding | **PARTIAL** | Still inferred from the `@BUILDING` name grouping (the table is laid out chain by chain) rather than the engine's own table, which is unread. The previous prefix match silently missed every chain whose building name does not start with the job name ("Rum Distiller's House" → Distiller). |
| Sons of Liberty % | **DONE** | `sol = A·100/B` (`sol_membership_pct` 0x8524..0x85B1), +20 with Jan de Witt, capped 100. Both terms are 32-bit EMAs with 1/64 decay: `B -= B>>6; B = max(B,1); B += 2·pop` and `A += bells − (A>>6); A = max(A,0); A = min(A,B)` (@0x2DA1C..0x2DAD8). A new colony seeds **B = 200, A = 0** — runtime-confirmed against a captured pop-1 Jamestown record. |
| Liberty bells | **DONE** | Now produced per colony by Statesmen through the same production pass instead of a flat guess, and fed to both the SoL EMA and the Continental Congress pool. |
| Crosses | **PARTIAL** | Preachers now produce them through the production pass; the flat +1 per colony stays a flagged placeholder, as the per-building cross rate is still unlocated. |
| Food consumption / growth | **PARTIAL** | `eaten = 2·pop` is byte-verified (@0xA5F2). The **199-cap / 200-food-for-a-colonist** numbers are the manual's, tier **R**, not located in any resident function — flagged as such in `warehousing.md` §6. A colony that cannot feed itself loses a colonist. |
| Over-100 disposal | **DONE (with an open question)** | Byte-verified at `func_02D658` @0x2D6F7: a good at **100 or more** is cut to **50** and the excess is **sold** net of tax to the treasury (@0x2D785) — or **wasted** if independence has been declared (`[0x5382]&1` @0x2D728). **OPEN:** whether a Custom-House gate sits in the caller. None is recorded in the spec, so none is applied; if play shows goods auto-selling when they should not, that gate is where to look. |
| Warehouse capacity | **NOTED** | `(level+1)·100` (`func_008D00`) is implemented but, per the 2026-06-27 correction, it bounds **only** the food growth reserve — not per-good stock. |

## Port: pioneer terrain improvement + movement in thirds (2026-08-04)

`spec/systems/terrain_improvement.md` is byte-verified end to end, and the port
now follows it. Before this pass Clear/Plow and Build Road only set an order
letter and did nothing at all.

| Item | Status | Note |
|---|---|---|
| Order dispatch | **DONE** | Order **8 Clear/Plow** → `func_040656`, order **9 Build Road** → `func_0409D6` (dispatcher @0x051D56). Clear vs plow is chosen by the tile's forest state. |
| Work counter and threshold | **DONE** | Counter `UnitRecord +0x16`, incremented each turn the order is held (@0x04071D / @0x040A46). Threshold is the `@TERRAIN` **improvement** column (+0x2F78 — present in NAMES as the column of that name): **clear/plow = col + 2** (@0x040727), **road = col** (@0x040A50), **halved for a Hardy Pioneer** (@0x04074A / @0x040A59). |
| Tile writes | **DONE** | road `\|= 0x08` (@0x040AEC), plow `\|= 0x40` (@0x04089F) in the **improvement layer** (the engine's map layer #2, DGROUP [0x160]/[0x162] — a separate plane from the terrain byte, which is why plow's 0x40 does not collide with the terrain plane's river bit). Clear subtracts 8 from the tile id (@0x040896). |
| Clear's −8 on a folded id | **NOTED** | Raw ids 16..23 fold to 8..15 first (CLAUDE.md hard rule 3), so a straight −8 on the raw byte would leave such a tile still forested. The port folds first, landing both halves of the band on their 0..7 unforested base. |
| Tool cost and reversion | **DONE** | −20 tools per action (`func_040608` @0x4060F), and below 20 the Pioneer reverts to a plain Colonist with `@USEDUPTOOLS` (@0x04061D). A Pioneer starts with 100 tools (`UnitRecord +0x15`). |
| Lumber from clearing | **PARTIAL — conflict recorded** | The grant goes to the nearest colony's Lumber slot (@0x04084D) and emits `@CLEARCUT`. The spec cites the amount's source column as **+0x2F80**, which by this table's own column arithmetic (movement +0x2F76, defensive +0x2F77, improvement +0x2F78, value +0x2F79, then the nine yields) is **y_ore** — while the grant is plainly lumber. The port reads the **lumberjack** column as the coherent one and scales it ×10 to land in the original's familiar range. Both the column choice and the scale are the port's; resolving it needs the executor re-read. |
| Plow / road yield deltas | **DONE** | `compute_terrain_yield`: the **road** bit adds `bonus` iff the good index is **> 3** (@0x9F01/@0x9F05 — ore, furs, timber and up); the **plow** bit adds it iff the good index is **≤ 3** (@0x9F1F/@0x9F23 — food and the three planter crops). `bonus` is **1**, or **2** for good index 5 or a river tile (@0x9EC6/@0x9EDD). |
| Movement in thirds | **DONE** | The `@UNIT` loader stores the movement column **×3** (`SHL al,1 / ADD al,cl` @0x074F04, `unit.md` §3), so budgets are in thirds and a road step costs **one third**. The port now runs the whole movement model on that: a step costs `3 × the terrain's movement column`, or **1** with a road at both ends, or **1** for a cardinal step along a river running through both tiles. A unit that has not moved yet may always take one step however dear the ground. The HUD shows whole moves with the odd third spelled out. |
| Road rendering | **DONE** | Roads are their own layer (@0x6842B, engine base `0x51` + an 8-direction mask, `func_067D54`). On disk that base is `0x50`: `0x50` is the isolated junction stub and `0x51..0x58` are the eight spokes, whose **N, NE, E, SE, S, SW, W, NW** order was read off the sheet by rendering it. A colony counts as a road end. |
| Plow rendering | **PARTIAL** | No dedicated plow frame has been located anywhere in PHYS0, so the port draws furrow dots in the ploughed-earth tone rather than borrowing a sprite that means something else. |
| Bug found in passing | **FIXED** | `drawTile`'s land branch **returns early**, so anything appended to the end of that function only ever ran for water tiles. The improvement layer is now drawn from a helper called on both paths. |

## Port: the Declaration, the REF war and the score (2026-08-04)

The game's third act, previously untouched. Sources: `spec/systems/revolution.md`,
`king.md`, `ref_growth.md`, `scoring.md`.

| Item | Status | Note |
|---|---|---|
| Declaration gate | **DONE** | `func_03E984`'s three steps: already-revolting → `@ALREADYREVOLUTION`; the national SoL meter **< 50** → `@TOOTORY` with the percentage filled in (`cmp [0x53D0],0x32; jge` @0x3E99E — 50 is the hard floor); otherwise the `@DECLARE` confirm, and only its second row declares. |
| National SoL meter | **PARTIAL** | The declare gate reads `[0x53D0]`, a 0..100 meter separate from the per-colony percentages, and its own per-turn driver is not in the evidence here. The port takes the population-weighted mean of the colony meters. The **+20 from Simón Bolívar** is byte-cited (`add [0x53D0],0x14` @0x3BE64, capped 100) and is applied. |
| Game-state flags | **DONE** | `[0x5382]`: bit 0 War of Independence declared, bit 1 intervention, bit 3 independence won. |
| Mobilisation | **DONE** | `mobilize_continentals`, byte-verified: every colony at SoL ≥ 50 promotes a budget of `((SoL−50)·(size/2))/50`, clamped ≥ 1, of the veteran Soldiers and Dragoons **standing in it** — `@UNIT` type 1 → 9 Cont. Army, type 4 → 7 Cont. Cav. **No units are created**, which is the part that makes the Declaration a decision rather than a windfall. |
| REF seed | **DONE** | `new_game_setup`, difficulty-scaled: `8d+15` Regulars, `5d+5` Cavalry, `3d+2` Man-O-War, `6d+2` Artillery. The REF is **exactly** those four types. |
| REF growth | **DONE** | The royal fund accrues `(8·difficulty + 10) · 2^era` per turn (era doubling as the year passes 1600/1700/1750), and every **1800** banked buys one unit (`func_03E162`: accrue @0x3E181, gate `>= 0x708` @0x3E1C6, `SUB [bx+0x22],0x708` @0x3E271). The port's own sales tax feeds the same fund — the closed loop the manual describes: your taxes buy the army sent against you. |
| REF slot choice | **PARTIAL** | The spec says the slot is "chosen by ratio" without giving it. The port buys into whichever type is furthest below its share of the seeded mix. |
| REF landing | **PARTIAL** | The arrival colony is a **population-weighted random pick over the coastal colonies**, as `land_intervention_force` does, and a Man-O-War takes a beach tile beside it. The wave size and the beach-tile scoring are the port's own. |
| The war | **PARTIAL** | REF land units march on the nearest colony and fight through the ordinary combat resolution; an undefended colony falls (woodcut 12, COLONY DESTROYED). The King's own AI is not specced anywhere — `spec/systems/ai.md` is the weakest area in the tree — so this movement is the port's, and flagged as such. |
| Victory / defeat | **PARTIAL** | The resolver runs while bit 0 is set and bit 3 clear, and sets the won bit when the King's land units are spent and none remain to sail (`@KINGLOSE`). Losing every colony brings `@KINGWIN`. The spec's own threshold (1 normally, 8 with a flag set) and the intervention tally are not both modelled. **`@KINGVICTORY` is deliberately NOT used here** — it is the Crown's tax cut after a *European* war, not the rebel defeat. |
| Foreign intervention | **TBD** | `@CONSIDER` / `@INTERVENTION` and the bell threshold that arms them are exported but not wired. |
| Score | **DONE** | All seven byte-verified components of `func_039EE2`: population (**+1** for an Indentured Servant / Petty Criminal / **Indian Convert**, +2 for a Free Colonist, +4 for a real profession — the manual's gloss omits converts, the byte gates are authoritative), Founding Fathers **+5** each, the sentiment meter ×1, razed colonies × **−(1+difficulty)**, `min(gold/100, 100)`, bells/1000, and the revolution bonus `(1780 − declaration year)·2` once independence is won. The multiplier is **computed, not tabled**: `difficulty + 4`, +1 at 3, +1 at 4 → {4, 5, 6, 8, 10}; the total is `(mult · base)/100` halved. F10 shows the breakdown. |
| No Declaration woodcut | **NOTED** | `@WOODCUT`'s 17 captions contain none — 11 and 12 are COLONY BURNING and COLONY DESTROYED. An earlier draft fired woodcut 11 on declaring; struck. |

## Port: the King's demands, tea parties, boycotts, Lost City Rumours (2026-08-04)

The recurring event layer. Sources: `spec/systems/king.md` and
`spec/systems/events.md`, both byte-verified in the parts used here.

| Item | Status | Note |
|---|---|---|
| Tax-demand cadence | **DONE** | `func_036138` @0x36150..0x361BA: nothing before **turn 30**, then a demand only when `turn % interval == 0`, where the interval starts at **18** and shrinks to **15 / 12 / 9** as the year crosses 1600 / 1700 / 1750, further reduced by the human `(difficulty − 2)` term. Skipped once tax > 85. |
| Raise amount | **DONE** | `func_034AE0`, read instruction by instruction: `delta = ((difficulty & 0xFE) << 1) + 4`, `turn_factor = (turn/400) + 1`, `candidate = delta · turn_factor`, with the `random_int(1, difficulty+1)` roll gating the low-tax path. |
| Tax cap | **DONE** | Hard-clamped at **75** at the write site (`func_034318` @0x03434F). The separate **60** threshold is a message gate, not a cap — both numbers are byte-verified and serve different roles, so only 75 clamps here. |
| Pretext escalation | **DONE** | `sev = random_int(1,1000) + (2·sentiment − tax)·5 + gold/100 + turn/30`, banded at 0x28A / 0x3B6 / 0x44C into `@KINGWIFE` (royal wedding) → `@KINGWAR` → `@KINGNAVACT` (Navigation Acts) → `@KINGSTAMPACT`. Higher unrest, tax and treasure make the excuse escalate. |
| Salutation | **DONE** | `[0x8394]` resolved as a 5-entry table of per-difficulty salutation strings — the Crown addresses you by your difficulty rank, which `@DIFFICULTY` supplies. |
| Options and the Tea Party | **DONE** | `@TAXOPTIONS` supplies the two rows for whichever pretext body fired (the port's event popups gained an options-key parameter for exactly this). Refusing throws the good into the sea, leaves the tax alone, and **boycotts** it. |
| Boycotts | **DONE** | `PowerRecord +0x20` is a 16-bit mask, bit per good: set on a Party (`or [bx+0x20], 1<<good` @0x034717), tested on every trade (@0x030B47), cleared in full by **Jakob Fugger** (@0x03BD45). The port blocks buying, selling and the over-100 auto-export for a boycotted good. Per-good clearing by back-tax payment is not wired. |
| Rumour placement | **PARTIAL** | Presence is **procedural, not a stored marker** (a 2026-06-21 correction that dissolved the old `0xA0`/`0xB0` model): `func_006188` hashes the coordinates against the map seed — `((x>>2)·0x13 + (y>>2)·0x11 + seed + 8) & 0x1F − (y&3)·4 == (x&3)` — gated on the terrain not being Arctic / Ocean / Sea Lane. The port implements the hash and that gate and rolls the seed per game as the generator does. The engine's **third** gate (the tile's feature high-nibble must be 0xF) needs a feature-nibble plane the port does not carry, so it is not reproduced. |
| Outcome selection | **DONE** | `n = max(anti_streak_floor, random_int(1,9))`, the floor climbing by one per rumour and capping at **3** — so the Fountain of Youth and Cibola are only reachable on the first rumours. The quality roll `random_int(1,100) + scout·10` against 10/25 demotes them, and each is capped once per game. |
| Scout bonus | **DONE** | Level 0..3: +1 Scout, +1 Seasoned Scout, +1 **Hernando de Soto** (`func_061454`). It biases the quality roll by `level·10`. |
| Reward magnitudes | **DONE** | Byte-verified dice: ruins `10·3d8` scaled by `(s+2)/2`; friendly tribe `2·4d10`; Cibola `10·(s+2) + 1d20` shown ×100; `@BURIAL2` `10·3d8`; `@BURIAL3` `2·(1d8 + 2·(s+5))` shown ×100. The Fountain queues **8** immigrants. |
| Burial sub-dispatch | **PARTIAL** | The three `@BURIAL` outcomes are wired but the port picks between them with a flat roll; the engine's own selector for `[bp-0x38]` is not in the evidence read. `@SCREWED` (desecration) is not wired. |
| Rumour marker | **PARTIAL** | ICONS **17** is a gold sunburst that reads as the rumour marker; no catalogue entry names it, so the identification is by eye and flagged. |

## Port: the Combat Analysis dialog (2026-08-05)

`spec/ui/combat_analysis.md` (`func_05E9B0`, page 0x11) — the panel that
itemises a fight's modifiers. It was specced and unbuilt; combat resolved
silently with only a one-line status message.

| Item | Status | Note |
|---|---|---|
| Geometry | **DONE** | Byte-cited: **x = 53, w = 214, h = rows·20 + 6, vertically centred**; title "COMBAT ANALYSIS"; attacker column pens at **x = 56**, defender at **x = 160**, each value right-aligned at **col_x + 0x50**; **row pitch 20**. |
| Labels | **DONE** | Every row label is a LABELS.TXT `@MISC` line through the pointer table at DG 0x2DBA — 62 Cargo, 65 Veteran, 75 COMBAT ANALYSIS, 76 Fatigue, 77 Attack Bonus, 78 Ambush, 79 Terrain, 80 Colony, 81 Fortified, 82 Spain Bonus, 84 Artillery In Open, 90 Drake, 104 Bombard, 129 Artillery Vs. Raid, 132 Tory Unrest, 133 Rebel Unrest. No label is hardcoded. |
| The chain is itemised, not re-derived | **DONE** | `combatAnalysis()` runs the §14.3 chain **once** and records a row as each modifier fires; `combatStrength()` is now just its total, so the panel can never disagree with the arithmetic that decided the fight. A regression check asserts that agreement. |
| Rows implemented | **PARTIAL** | Veteran +50%, Cargo −12.5%/hold, Ambush/Terrain +def·25%, Colony +(fort+1)·50%, Fortified +50%, Artillery In Open −75%, Drake +50%, Spain Bonus +50%, Bombard +50%, and Tory/Rebel Unrest. **Not implemented:** Fatigue (the `@HALF` pre-roll prompt is not built), the Muskets row (its "+1" value semantics are an open item in the spec itself), Artillery Vs. Raid, and the colony-structure row (its building-name table DG 0x9634 is unread). |
| Gate | **DONE** | Game Options bit **0x0200** "Combat Analysis". The full options dialog is not built, so the GAME menu's "Game Options" row toggles the one option this build honours. |
| Ordering | **NOTED** | The engine shows the panel *after* the roll but *before* resolution renders. The port applies the result first and then shows the same figures over the map. The arithmetic is identical; only the moment the loser's sprite vanishes differs. |
| The roll line | **NOTED** | The engine prints the raw roll only in cheat mode (`[0x5383]&0x20`). The port shows it always — it is the whole point of the panel for a player learning the odds — which is a deliberate deviation, not an oversight. |

## Port: the combat aftermath (2026-08-05)

§14.6, `apply_combat_result`. The port previously deleted whichever unit lost.
That is not what the engine does, and the difference is large: most land defeats
are a demotion or a capture, not a death.

| Item | Status | Note |
|---|---|---|
| The demotion ladder | **DONE** | A beaten land unit falls one rung instead of dying: Dragoons→Soldiers, Soldiers→Colonists, Cont. Cav.→Cont. Army, Cavalry→Regulars, Cont. Army→Colonists. Anything with no rung below it is destroyed. `@DEMOTE`. |
| Missionary special case | **DONE** | A unit demoting to Colonist while carrying the Missionary profession becomes a **Missionaries** unit instead. |
| Veteran status | **DONE** | Lost on the way down — which is what `@COLONISTCAPTURE2` ("Soldiers lose Veteran status") announces on the capture path. |
| Capture instead of death | **DONE** | Only **Colonists, Treasure and Wagon Trains** are capture-eligible, and only from a European owner: the unit changes hands intact. `@COLONISTCAPTURE` / `@COLONISTCAPTURE2` / `@WAGONCAPTURE` / `@LOOTCAPTURE`. **Not modelled:** the winning ship's transport-room requirement. |
| Artillery damage states | **DONE** | A loss flips it to Damaged (`@ARTILLERY`, "Further damage will destroy it"); a damaged piece that loses again is destroyed (`@ARTILLERY2`). |
| Ships | **DONE** | Damaged first (`@SHIPDAMAGE`, returns to port for repairs), sunk only if already damaged (`@SHIPSUNK`). **Not modelled:** the separate raw guns/hull roll for ship-vs-ship, cargo scatter on sinking, and the Privateer/Frigate-only guard on starting a ship attack. |
| Promotion | **DONE** | `P = winner_strength / (ATK + DEF ± difficulty − class penalty)`, rolled `random_int(1,S)`; a human gets +difficulty, Petty Criminals cost 10 and Indentured Servants 5, and **George Washington skips the roll entirely**. The class ladder walks Petty Criminal → Indentured Servant → Free Colonist → Veteran, a Scout hardens to Seasoned (`@WELLSEASONED`), and at the soldier ceiling the **type** advances to Continental once the war has begun. `@VETERAN` / `@VALOR`. |
| Fatigue | **PARTIAL** | Attacking with a part-spent unit now raises the byte-cited `@HALF` prompt **before the roll** — *"these men are tired… they will fight at 2/3 strength"* — with Charge! / Then let them rest. The penalty then shows as a **Fatigue** row in the Combat Analysis panel. The engine has two fatigue flags (`F&0x100` −33% and `S&8` −66%) but the evidence read does not give the rule that picks between them; the port uses "less than a third of the budget left" for the heavier penalty and flags that threshold as its own. |
