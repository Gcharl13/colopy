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
| 2 | Colony screen | composer func_028592; screen 0x2C @0x025EE5 | docs/COLONY_SCREEN_VICEROY_DECODE.md | PARTIAL (RNG placement func_025D34 §12, frame table — being ported) |
| 3 | Europe screen | composer func_031E4C; screen 0x2B @0x030DEB | docs/EUROPE_SCREEN_VICEROY_DECODE.md | PARTIAL (heap-string contents, menu gold blit) |
| 4 | Advisor reports F1–F10 | dispatch @0x023843; bodies 0x37xxx–0x3Axxx | docs/ADVISOR_REPORTS_VICEROY_DECODE.md (+ spec/ui/advisor_reports.md) | DONE — all 10 bodies' static layout byte-cited (x-cols/y-start/pitch/verb/string/color/font; F7 4-col table, F3/F2 strips, F8 gate, F10 i·i/3 band selector + SCORE<panel+1>.SS/WOODPAN2). TBD = live game-state (counts/gold/prices/score figures), runtime DGROUP icon-id cells ≥0x2CC6 (F3 REF), and some @MISC label-slot bindings (loader unidentified) — each TBD names its site |
| 5 | Continental Congress (F3 + Activities) | func_037A20 / congress_screen_render | spec/ui/continental_congress.md | PARTIAL |
| 6 | Popups / dialogs engine | func_06C520/06D316/06C850 | spec/ui/popups.md | PARTIAL (geometry engine DONE; per-popup) |
| 7 | In-game menu bar + dropdowns | func_072090 build; @0x060890 line | spec/ui/menus.md | PARTIAL |
| 8 | Main/boot menu (OPENMENU/BEGINMENU) | func_075xxx; screen 0x2A @0x07661F | spec/ui/menus.md | PARTIAL |
| 9 | Opening / intro (OPENING.PIK) | screen 0x18 @0x077401 region | — | TBD |
| 10 | Nation select (NATIONS.PIK) | screen 0x18 region | — | TBD |
| 11 | Difficulty select (DIFFICUL.PIK) | — | — | TBD |
| 12 | Customize (CUSTOMIZ.PIK) | — | — | TBD |
| 13 | King audience / loss / win (KING*) | renderer func_075352 @0x075352; trigger func_02F3A2 @0x02F3A2 | docs/ENDGAME_SCREENS_VICEROY_DECODE.md §1 | DONE (KING1/KINGLOSE/KINGWIN select + pen (242,47) FONTKING + portrait x=100 byte-cited; portrait y/h + body text runtime TBD) |
| 14 | Native diplomacy / raids (IND*) | popup channels func_06BE92 | spec/ui/popups.md §2.7 | PARTIAL |
| 15 | Score screen (SCORE01–24) / F10 | func_03A9C0 @0x03A9C0 | docs/ADVISOR_REPORTS_VICEROY_DECODE.md §F10 (+ spec/ui/advisor_reports.md) | DONE (selector) — band selector byte-cited: i=1..0x18, panel=i-1 for largest i with i·i/3≥scaled (`imul cx;idiv 3;jge` @0x3AA4D-0x3AA5A), clamp ≤0x17 @0x3AA71; SCORE<panel+1>.SS (str 0x11CF +`0x182`@0x3AADA) over WOODPAN2 (str 0x11D7 @0x3AAFF, quartet 0x44E @0x3AB02); FONTTINY+FONTINTR (`[0x268A]`@0x3B054). TBD = live score figures + per-line big-figure x/y |
| 16 | Declaration of Independence (DECLARAT) | screen 0x28 @0x0450AE? | — | TBD |
| 17 | Closing / end (CLOS-BKG) | — | — | TBD |
| 18 | Fonts (FONTTINY/INTR/KING/NP) | load verb 0x1A1F:0xA86 (4 loads); measure core 0x181F:0x204→0x00E6A6 | docs/FONTS_VICEROY_DECODE.md | DONE (loads+latches+per-glyph width byte-verified; cell heights .FF-atlas tier-A; FONT-NP draw site TBD) |
| 19 | Screen-view runner / event loop | INLINED template; colony runner func_02C5D4 loop 0x02C85C, exit [0x346]@0x2C929 | docs/SCREEN_FRAMEWORK_VICEROY_DECODE.md | DONE (skeleton+input thunks+exit byte-verified; **0x181F:0x772 corrected = error-logger, NOT enter_screen_view**; map main-loop start TBD) |
| 20 | Colony RNG placement PORT | func_025D34/009726/00C322 + 0x7238 frame | docs/COLONY_SCREEN_VICEROY_DECODE.md §12 | IN PROGRESS (this session) |

## Screen-tag map (`bx` at the error-exit tails — `0x181F:0x772` = error-logger, NOT a screen dispatch; see docs/SCREEN_FRAMEWORK_VICEROY_DECODE.md §0)
- 0x2D @0x005E63 · 0x2C @0x025EE5 (colony) · 0x2B @0x030DEB (europe) · 0x28 @0x0450AE
  · 0x29 @0x06D5AA · 0x2A @0x07661F (boot menu) · 0xD @0x076871 (map) · 0x18 @0x077401/
  0x0774E4/0x0775A7 (intro/nation/difficulty) · more @0x078B8B/0x078C7C.

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
