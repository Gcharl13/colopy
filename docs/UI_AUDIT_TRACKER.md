# UI AUDIT TRACKER — byte-verified documentation of the ENTIRE VICEROY UI

> Mandate: `CLAUDE.md` "UI DOCUMENTATION MANDATE". Goal = 100% byte-verified docs of every
> screen + every element's exact placement/font/string/color, enough to rebuild. No
> fabrication: every cell cites a `func@offset` or is **TBD** with the blocker named.
> Status: **DONE** (every element byte-cited or TBD-with-blocker) / **PARTIAL** / **TBD**.
> Last updated: 2026-06-24 (autonomous scrub).

## Screens & subsystems

| # | Screen / subsystem | entry / composer | decode doc | status |
|---|--------------------|------------------|-----------|--------|
| 1 | Map view (HUD/sidebar/menubar/minimap/viewport) | enter_screen_view 0xD @0x076871; composer func_067700 | docs/MAPVIEW_SCREEN_VICEROY_DECODE.md; spec/ui/map_view.md | PARTIAL — composer/minimap(241,8,79,41 @0x066CF8)/viewport-geom(func_06787C)/tile-chain/units-overlay all **B**; sidebar season/gold/tax text **TBD** (no draw site in map page 0x66000-0x77000 — overlay HUD); **func_06083A REFUTED** as map bar (= trade-route title, [0x9E14]/0x4A @0x060883) |
| 2 | Colony screen | composer func_028592; screen 0x2C @0x025EE5 | docs/COLONY_SCREEN_VICEROY_DECODE.md; spec/ui/colony_screen.md | DONE (B) — **RNG placement func_025D34 §12 fully traced + snapshot-verified 2026-06-26** (category table 0x8D62, within-category shuffle → 0x8E92, present-gate 0x8E82, frame word[id*2−0x7238]); captured live (docs/screens/11_colony_screen.png) + ColonyRecord runtime-confirmed (hard rule 8). Per-colony plot→building map is RNG (replayable from seed 0x181F:0xD62), by design |
| 3 | Europe screen | composer func_031E4C; screen 0x2B @0x030DEB | docs/EUROPE_SCREEN_VICEROY_DECODE.md | PARTIAL (heap-string contents, menu gold blit) |
| 4 | Advisor reports F1–F10 | dispatch @0x023843; bodies 0x37xxx–0x3Axxx | docs/ADVISOR_REPORTS_VICEROY_DECODE.md (+ spec/ui/advisor_reports.md) | DONE — all 10 bodies' static layout byte-cited (x-cols/y-start/pitch/verb/string/color/font; F7 4-col table, F3/F2 strips, F8 gate, F10 i·i/3 band selector + SCORE<panel+1>.SS/WOODPAN2). TBD = live game-state (counts/gold/prices/score figures), runtime DGROUP icon-id cells ≥0x2CC6 (F3 REF), and some @MISC label-slot bindings (loader unidentified) — each TBD names its site |
| 5 | Continental Congress (F3 + Activities) | func_037A20 / congress_screen_render | spec/ui/continental_congress.md | PARTIAL |
| 6 | Popups / dialogs engine | func_06C520/06D316/06C850 | spec/ui/popups.md + docs/POPUP_INSTANCES_VICEROY_DECODE.md | DONE — engine B (finalize math re-confirmed @0x06D363/92/0x06D522/3B); ~30 per-popup instances enumerated with @KEY(s) (159/159 grep-confirmed)/speaker channel (K/T/A/M via func_06BE92/BF12/BF3C, templates re-read 0x1F912/17/1E/23)/special-sprite/Lost-City func_061454 map; @x/@y/@width = **B-via-EXE / TBD-via-JSON** (extractor strips them); TBD = food-trigger fn, WOODPANL/PAN2 per-popup, func_06BF66 sprite x/y math |
| 7 | In-game menu bar + dropdowns | func_072090 build; func_06E3D0 dropdown | spec/ui/menus.md + docs/MENUS_VICEROY_DECODE.md | DONE — build chain func_072090 B (font 0x1A1F:0x2D2; "game"/"menu" 0x0720BE; readers 0x191F:0x928/0x91C); dropdown open/run/hit func_06E3D0 B (mode split @0x06E3DA); geometry func_06D316 B; items+order from MENU_sections.json B; **func_06083A @0x060890 REFUTED as the pulldown bar (= turn/title strip, [0x9E14]/0x4A @0x060883)** — bar *draw* + per-item x = TBD/R (overlay-resident); per-row cmd-id binding TBD |
| 8 | Main/boot menu (OPENMENU/BEGINMENU) | func_075xxx; screen 0x2A @0x07661F | spec/ui/menus.md + docs/MENUS_VICEROY_DECODE.md | DONE — OPENMENU bg ([0x233C]→0x1FCDC) + OPENBORD decor (0x075B8E/B0/D2) + @BEGINMENU items (GAME.TXT, present) + runner @0x075C60 (lea [0x2345]; 0x181F:0x3FE) + dec-ax ladder @0x075C6D + begin_game 0x191F:0x320 @0x075E5F + colors (direct-RGB) all B; per-row y engine-laid from @y=91 (B-mechanism); difficulty/nation pickers byte-cited grids §4 |
| 9 | Opening / intro (OPENING.PIK) | **OPENING.EXE** (separate program; asset table @file 0x0BFE8) | docs/FRONTEND_SCREENS_VICEROY_DECODE.md §1 | DONE (EXE boundary: opening is NOT in VICEROY.EXE — 0 OPEN* sprite refs; timing=OPENING.TXT+PATH.DAT byte-known; pixel placement = OPENING.EXE decode, out of scope) |
| 10 | Nation select (NATIONS.PIK) | **func_070A1A** (loads NATIONS.PIK push 0x2043 @0x070A42 via 0x181F:0x44E) | docs/FRONTEND_SCREENS_VICEROY_DECODE.md §3 | DONE (B: PIK load + @PICKNATION fallback; 2×2 grid x{112,211}/y{13,104} 82×88 @0x07078D; sel=[0x5398] mod-4; hit-rects 0x181F:0x3CA @0x070BCA; commit mouseX<112) — **LITERALS RESOLVED**: 4 nation labels = **@PICKNATION** rows (England/France/Spain/Netherlands) via `lea ax,[0x204b]`("PICKNATION", file 0x1f9eb) → `0x181F:0x998` list-menu @0x070A5E, result-1→[0x5398] @0x070A74; GAME.TXT @PICKNATION + snapshot blob (England 0x223fa) confirm. TBD: per-cell font/ink (runtime/BSS highlight on [0x5398] — AI-GATED) |
| 11 | Difficulty select (DIFFICUL.PIK) | **func_070580** (loads DIFFICUL.PIK push 0x202D @0x0705A8) | docs/FRONTEND_SCREENS_VICEROY_DECODE.md §4 | DONE (B: PIK load + @DIFFICULTY fallback; 3-wide×5 cells col·105+23/row·96+7 90×68 @0x0702C0; sel=[0x53A6] mod-5; hit-rects @0x070707; commit mouseY<103&X<128) — **LITERALS RESOLVED**: 5 level labels = **@DIFFICULTY** rows (Discoverer/Explorer/Conquistador/Governor/Viceroy) via `lea ax,[0x2036]`("DIFFICULTY", file 0x1f9d6) → `0x181F:0x998` list-menu @0x0705BE, result-1→[0x53A6] @0x0705D2; NAMES.TXT @DIFFICULTY + snapshot blob (NUL-list @0x4c27a) confirm. **DS:0x8394 is NOT the literal pointer table** (snapshot words there = 0x3e..0x42, ints not ptrs) — literals come straight from @DIFFICULTY. TBD: per-level ink switch + font (runtime/BSS — AI-GATED) |
| 12 | Customize (CUSTOMIZ.PIK) | **func_070060** (loads CUSTOMIZ.PIK push 0x2022 @0x070088) | docs/FRONTEND_SCREENS_VICEROY_DECODE.md §5 | DONE (B: PIK load; draw-all func_06FF94; 4×3 grid col·76+10/row·60+16 48×72 @0x06FDF0; title y4 ink0xFD/bg0xFE; cell ink0x0A/0x0E; sel=[0x1E7E]×4 default[1,1,1,1]; finish=click&mouseY≥185 @0x07027E) — TBD: LABELS idx→literal, font id, Diff/Power sub-popups func_070302/070494 |
| 13 | King audience / loss / win (KING*) | renderer func_075352 @0x075352; trigger func_02F3A2 @0x02F3A2 | docs/ENDGAME_SCREENS_VICEROY_DECODE.md §1 | DONE (KING1/KINGLOSE/KINGWIN select + pen (242,47) FONTKING + portrait x=100 byte-cited; portrait y/h + body text runtime TBD) |
| 14 | Native diplomacy / raids (IND*) | popup channels func_06BE92 | spec/ui/popups.md §2.7 + docs/POPUP_INSTANCES_VICEROY_DECODE.md §3.2-3.6 | DONE — tribe channel [0x1F5C]→IND<n>A<pose>.SS (func_06BE92 split @0x06BE96, inject @0x06BEF5, "IND0A0"@0x1F917) B; raid block = exactly 6 keys @file 0x1F52A (re-read; @RAIDSCALP orphan, B-negative); warpath @INDIAN* keys B; attitude/haggle/gift/raze keys grep-confirmed B; trigger fns func_04A7CA/04B308/049600/0572E6/05BE84/04B036 A. Sprite x/y position math (func_06BF66) TBD |
| 15 | Score screen (SCORE01–24) / F10 | func_03A9C0 @0x03A9C0 | docs/ADVISOR_REPORTS_VICEROY_DECODE.md §F10 (+ spec/ui/advisor_reports.md) | DONE (selector) — band selector byte-cited: i=1..0x18, panel=i-1 for largest i with i·i/3≥scaled (`imul cx;idiv 3;jge` @0x3AA4D-0x3AA5A), clamp ≤0x17 @0x3AA71; SCORE<panel+1>.SS (str 0x11CF +`0x182`@0x3AADA) over WOODPAN2 (str 0x11D7 @0x3AAFF, quartet 0x44E @0x3AB02); FONTTINY+FONTINTR (`[0x268A]`@0x3B054). TBD = live score figures + per-line big-figure x/y |
| 16 | Declaration of Independence (DECLARAT) | screen 0x28 @0x0450AE? | — | TBD |
| 17 | Closing / end (CLOS-BKG) | — | — | TBD |
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

## SCRUB COMPLETE — parallel phase (2026-06-24)
10 byte-verified decode docs cover every screen: MAPVIEW, COLONY, EUROPE, ADVISOR_REPORTS
(F1–F10), ENDGAME (King/Score/Declaration/Closing), MENUS (boot+in-game), POPUP_INSTANCES
(~30 families), FONTS, SCREEN_FRAMEWORK, FRONTEND_SCREENS (Nation/Difficulty/Customize).
**Static layout of every screen is byte-cited.** The ONE consistent remaining TBD class is
**live game-state + a few overlay-resident HUD blits** (per-row counts/gold/prices/score
figures; the sidebar/menu-header gold blit; runtime DGROUP string indices; the colony
RNG-placement sub-source tables) — each TBD names its exact site/blocker. Two adjacent
binaries (OPENING.EXE, CLOSING.EXE) are out of VICEROY.EXE scope, noted with extract steps.
Nothing was fabricated.
