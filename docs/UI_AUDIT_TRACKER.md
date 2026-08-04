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
| REPORTS | **PARTIAL** | F2 Religious, F5 Economic, F6 Colony and F7 Naval are built from real state, each with its own adviser portrait. F1/F3/F4/F8/F9/F10 name themselves — the state they report on (congress, labour allocation, foreign powers, natives, score) does not exist yet. |
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
- **Settlement PLACEMENT is a placeholder**: `func_065D26` seeds up to 84 settlements from the
  map seed and that logic is not in the evidence here, so villages are scattered by a
  deterministic hash on land. **PARTIAL.**
- Village trade, raids, missions and converts are **not built** — entering a village only
  reports whether the tribe is hostile.

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
